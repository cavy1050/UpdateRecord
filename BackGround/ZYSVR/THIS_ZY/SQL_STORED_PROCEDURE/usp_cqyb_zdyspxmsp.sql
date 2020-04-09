if exists(select 1 from sysobjects where name='usp_cqyb_zdyspxmsp')
  drop proc usp_cqyb_zdyspxmsp
GO

CREATE proc usp_cqyb_zdyspxmsp
(
	@syxh       VARCHAR(20),
	@jsxh       VARCHAR(20),              
    @xh         VARCHAR(12),              --������� 
    @spjg       VARCHAR(3),               --�������  1 ͨ��  2 ��ͨ��  0ȡ��������δ������
	@spyy       varchar(1000),            --����ԭ��
    @czyh       VARCHAR(10)               --�����û�
)
as  

DECLARE @czsj datetime

SET @czsj = GETDATE()

    BEGIN TRAN

    IF NOT EXISTS(SELECT 1 FROM YY_CQYB_ZDYSPFYMX(NOLOCK) WHERE xh = @xh)
    BEGIN
        INSERT INTO YY_CQYB_ZDYSPFYMX (syxh, jsxh, xh, spjg, spyy, czyh, czrq,sftb)
        VALUES  (@syxh, -- syxh - ut_syxh
                 @jsxh, -- jsxh - ut_xh12
                 @xh, -- xh - ut_xh12
                 @spjg, -- spjg - varchar(3)
                 @spyy, -- spyy - varchar(500)
                 @czyh, -- czyh - varchar(10)
                 @czsj,  -- czrq - datetime
                 0)
		if @@error <> 0 AND @@ROWCOUNT <> 1 
		begin
			ROLLBACK TRAN
			SELECT 'F','����ҽ����Ŀ�������ʧ�ܣ�'
			return
		END
		INSERT INTO YY_CZLOG(czyh,czrq,tabname,field,field_xh,cznr)
		VALUES(	@czyh,convert(char(8),getdate(),112)+convert(char(8),getdate(),8),'YY_CQYB_ZDYSPFYMX','xh',@xh,
				'����Ա' + @czyh +'�����Ϊ' + @xh + '�ķ�����ϸ��������޸�Ϊ' + @spjg)
		if @@error <> 0 AND @@ROWCOUNT <> 1 
		begin
			ROLLBACK TRAN
			SELECT 'F','����ҽ����Ŀ�������ʱ������־��¼ʧ�ܣ�'
			return
		END
    END
    ELSE
	BEGIN
	    IF @spjg = '0' 
		BEGIN
            DELETE YY_CQYB_ZDYSPFYMX where xh=@xh
			if @@error <> 0 AND @@ROWCOUNT <> 1 
			begin
				ROLLBACK TRAN
				SELECT 'F','ȡ��ҽ����Ŀ�������ʧ�ܣ�'
				return
			END
			INSERT INTO YY_CZLOG(czyh,czrq,tabname,field,field_xh,cznr)
			VALUES(	@czyh,convert(char(8),getdate(),112)+convert(char(8),getdate(),8),'YY_CQYB_ZDYSPFYMX','xh',@xh,
					'����Ա' + @czyh +'�����Ϊ' + @xh + '�ķ�����ϸ��������޸�Ϊ' + @spjg)
			if @@error <> 0 AND @@ROWCOUNT <> 1 
			begin
				ROLLBACK TRAN
				SELECT 'F','ȡ��ҽ����Ŀ�������ʱ������־��¼ʧ�ܣ�'
				return
			END			
		END
	    ELSE
		BEGIN 
			--�˴�Ҫ�޸�jsxh�����ڱ䶯����
			UPDATE YY_CQYB_ZDYSPFYMX SET spjg = @spjg,spyy=@spyy,czyh=@czyh,czrq=@czsj,jsxh=@jsxh,sftb = 0 WHERE xh = @xh
			if @@error <> 0 AND @@ROWCOUNT <> 1 
			begin
				ROLLBACK TRAN
				SELECT 'F','�޸�ҽ����Ŀ�������ʧ�ܣ�'
				return
			END
			INSERT INTO YY_CZLOG(czyh,czrq,tabname,field,field_xh,cznr)
			VALUES(	@czyh,convert(char(8),getdate(),112)+convert(char(8),getdate(),8),'YY_CQYB_ZDYSPFYMX','xh',@xh,
					'����Ա' + @czyh +'�����Ϊ' + @xh + '�ķ�����ϸ��������޸�Ϊ' + @spjg)
			if @@error <> 0 AND @@ROWCOUNT <> 1 
			begin
				ROLLBACK TRAN
				SELECT 'F','�޸�ҽ����Ŀ�������ʱ������־��¼ʧ�ܣ�'
				return
			END
        END
	end
	
    COMMIT TRAN

    SELECT 'T',''
	RETURN
go
