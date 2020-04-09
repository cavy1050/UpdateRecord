if exists(select 1 from sysobjects where name='usp_cqyb_zdyspxmsp')
  drop proc usp_cqyb_zdyspxmsp
GO

CREATE proc usp_cqyb_zdyspxmsp
(
	@syxh       VARCHAR(20),
	@jsxh       VARCHAR(20),              
    @xh         VARCHAR(12),              --费用序号 
    @spjg       VARCHAR(3),               --审批结果  1 通过  2 不通过  0取消审批（未审批）
	@spyy       varchar(1000),            --审批原因
    @czyh       VARCHAR(10)               --操作用户
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
			SELECT 'F','新增医保项目审批结果失败！'
			return
		END
		INSERT INTO YY_CZLOG(czyh,czrq,tabname,field,field_xh,cznr)
		VALUES(	@czyh,convert(char(8),getdate(),112)+convert(char(8),getdate(),8),'YY_CQYB_ZDYSPFYMX','xh',@xh,
				'操作员' + @czyh +'将序号为' + @xh + '的费用明细审批结果修改为' + @spjg)
		if @@error <> 0 AND @@ROWCOUNT <> 1 
		begin
			ROLLBACK TRAN
			SELECT 'F','新增医保项目审批结果时插入日志记录失败！'
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
				SELECT 'F','取消医保项目审批结果失败！'
				return
			END
			INSERT INTO YY_CZLOG(czyh,czrq,tabname,field,field_xh,cznr)
			VALUES(	@czyh,convert(char(8),getdate(),112)+convert(char(8),getdate(),8),'YY_CQYB_ZDYSPFYMX','xh',@xh,
					'操作员' + @czyh +'将序号为' + @xh + '的费用明细审批结果修改为' + @spjg)
			if @@error <> 0 AND @@ROWCOUNT <> 1 
			begin
				ROLLBACK TRAN
				SELECT 'F','取消医保项目审批结果时插入日志记录失败！'
				return
			END			
		END
	    ELSE
		BEGIN 
			--此处要修改jsxh，存在变动可能
			UPDATE YY_CQYB_ZDYSPFYMX SET spjg = @spjg,spyy=@spyy,czyh=@czyh,czrq=@czsj,jsxh=@jsxh,sftb = 0 WHERE xh = @xh
			if @@error <> 0 AND @@ROWCOUNT <> 1 
			begin
				ROLLBACK TRAN
				SELECT 'F','修改医保项目审批结果失败！'
				return
			END
			INSERT INTO YY_CZLOG(czyh,czrq,tabname,field,field_xh,cznr)
			VALUES(	@czyh,convert(char(8),getdate(),112)+convert(char(8),getdate(),8),'YY_CQYB_ZDYSPFYMX','xh',@xh,
					'操作员' + @czyh +'将序号为' + @xh + '的费用明细审批结果修改为' + @spjg)
			if @@error <> 0 AND @@ROWCOUNT <> 1 
			begin
				ROLLBACK TRAN
				SELECT 'F','修改医保项目审批结果时插入日志记录失败！'
				return
			END
        END
	end
	
    COMMIT TRAN

    SELECT 'T',''
	RETURN
go
