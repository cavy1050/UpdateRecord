if exists(select 1 from sysobjects where name='usp_cqyb_shsp')
  drop proc usp_cqyb_shsp
GO

CREATE proc usp_cqyb_shsp
(
	@code       VARCHAR(10),                --����(1ͨ����2��ͨ����0ȡ������(δ����)��99����ѯ)
	@syxh       VARCHAR(20)		='',        --��ҳ���
    @spyy       VARCHAR(500)	='',        --����ԭ�� 
    @czyh       VARCHAR(10)		='',        --�����û�
    @ksrq       VARCHAR(30)		='',        --��ʼ����
    @jsrq       VARCHAR(30)		='',        --��������
	@spbz       VARCHAR(3)		='0',       --0ȫ��,1ͨ��,2δͨ��,3δ����
	@xmzyh      VARCHAR(30)		='',        --����סԺ��
	@bqdmlist   VARCHAR(300)	=''         --���������б�     
)
as  

DECLARE @czsj datetime

IF @code = '99'  --��ѯ�������������
BEGIN
    CREATE TABLE #temp 
	(
	   ������ varchar(30) null,
	   �����Ϣ varchar(200) null,
	   �ѱ�     VARCHAR(20) NULL, 
	   �������� varchar(30) null,
	   ��Ժ���� varchar(30) null,
	   ���� varchar(50) null,
	   ���� varchar(50) null,
	   ��˽�� varchar(30) null,
	   ����ԭ�� varchar(500) null,
	   ����� varchar(30) null,
	   ������� datetime null,
	   ��ҳ��� varchar(30) null,
	   סԺ�� varchar(30) NULL,
	)	
	INSERT INTO #temp
	SELECT a.blh "������",d.zddm + d.zdmc "�����Ϣ",h.ybsm "�ѱ�",
		   a.hzxm "��������",
		   a.ryrq "��Ժ����",b.name "����",g.name "����",
		   CASE ISNULL(c.spjg,'0') WHEN '1' THEN 'ͨ��' WHEN '2' THEN '��ͨ��' ELSE '' end "��˽��",c.spyy "����ԭ��",
		   f.name "�����",c.czrq "�������",a.syxh "��ҳ���",a.blh "סԺ��"
    FROM ZY_BRSYK a(NOLOCK) INNER JOIN YY_KSBMK b(NOLOCK) ON a.ksdm = b.id
							INNER JOIN YY_CQYB_ZYJZJLK i(NOLOCK) ON a.syxh = i.syxh AND i.jlzt = 1 
							LEFT JOIN YY_CQYB_SHSPJG c(NOLOCK) ON a.syxh = c.syxh
							LEFT JOIN VW_CQYB_ZYBRRYZD d(NOLOCK) ON a.syxh = d.syxh 
							LEFT JOIN YY_ZGBMK f(NOLOCK) ON c.czyh = f.id
							LEFT JOIN ZY_BQDMK g(NOLOCK) ON a.bqdm = g.id
							LEFT JOIN YY_YBFLK h(NOLOCK) ON a.ybdm = h.ybdm
	WHERE a.brzt NOT IN (3,8,9)
	  and a.ryrq >= @ksrq
	  AND a.ryrq <= @jsrq
	  AND (CASE ISNULL(c.spjg,'3') WHEN '0' THEN '3' ELSE ISNULL(c.spjg,'3') END = @spbz OR '0' = @spbz)
	  AND (a.hzxm LIKE @xmzyh+'%' OR a.blh = @xmzyh)
	  AND ( charindex(convert(varchar(12),RTRIM(a.bqdm)),@bqdmlist) > 0 OR @bqdmlist = '' )
	 	  
	SELECT a.������,
		CONVERT(VARCHAR(1000),STUFF((select ','+CONVERT(varchar(100), b.�����Ϣ) FROM #temp b 
		    WHERE b.��ҳ���=a.��ҳ���  order by b.�����Ϣ for xml path('') ), 1, 1, '')) "�����Ϣ",a.�ѱ�,
		a.��������,a.��Ժ����,a.����,a.����,a.��˽��,a.����ԭ��,a.�����,a.�������,a.��ҳ���,a.סԺ��
	FROM  #temp a
	GROUP BY a.������,��������,a.��Ժ����,a.����,a.����,a.��˽��,a.����ԭ��,a.�����,a.�������,
			 a.��ҳ���,a.סԺ��,a.�ѱ�
	ORDER BY a.����,a.����,a.������,a.��Ժ����
END
ELSE
BEGIN
    SET @czsj = GETDATE()
	IF LTRIM(RTRIM(@syxh)) = ''
	BEGIN
		SELECT 'F','��ҳ���Ϊ�գ�'
		RETURN		
	END		
    BEGIN TRAN
	IF NOT EXISTS(SELECT 1 FROM YY_CQYB_SHSPJG(NOLOCK) WHERE syxh = @syxh) 
	BEGIN
		INSERT INTO YY_CQYB_SHSPJG (syxh,  spjg, spyy, czyh, czrq)
		VALUES  (@syxh, -- syxh - ut_syxh
				 @code, -- spjg - varchar(3)
				 @spyy, -- spyy - varchar(1000)
				 @czyh, -- czyh - varchar(10)
				 @czsj  -- czrq - datetime
				 )
		if @@error <> 0 AND @@ROWCOUNT <> 1 
		begin
			ROLLBACK TRAN
			SELECT 'F','��������������ʧ�ܣ�'
			return
		END
	END
	ELSE
	BEGIN
		IF @code = '0' 
		BEGIN
			DELETE YY_CQYB_SHSPJG where syxh=@syxh
			if @@error <> 0 AND @@ROWCOUNT <> 1 
			begin
				ROLLBACK TRAN
				SELECT 'F','ȡ��ҽ����Ŀ�������ʧ�ܣ�'
				return
			end
		END
		ELSE
		BEGIN 
			UPDATE YY_CQYB_SHSPJG SET spjg = @code,spyy=@spyy,czyh=@czyh,czrq=@czsj WHERE syxh = @syxh
			if @@error <> 0 AND @@ROWCOUNT <> 1 
			begin
				ROLLBACK TRAN
				SELECT 'F','�޸�ҽ����Ŀ�������ʧ�ܣ�'
				return
			end
		END
	end
    COMMIT TRAN

	SELECT 'T',''
END

RETURN
GO
