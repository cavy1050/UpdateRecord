if exists(select 1 from sysobjects where name='usp_cqyb_zdyzdsp')
  drop proc usp_cqyb_zdyzdsp
GO

CREATE proc usp_cqyb_zdyzdsp
(
	@syxh       VARCHAR(20),                --��ҳ���
	@spjg       VARCHAR(3),                 --�������  1 ͨ��  2 ��ͨ��  0ȡ��������δ������,99��ѯ����������,
	                                        --			98 �ֹ������������Ĳ���(��sjly=1)
	                                        --			97 ���Ӳ�������������Ĳ���(sjly=1)
	                                        --			96 ��ѯ��Ժ�����������
    @spyy       VARCHAR(500),               --����ԭ�� 
    @czyh       VARCHAR(10),                --�����û�
    @ksrq       VARCHAR(30)='',             --��ʼ����
    @jsrq       VARCHAR(30)='',             --��������
	@spbz       VARCHAR(3)='0',             --0ȫ��,1ͨ��,2δͨ��,3δ����
	@xmzyh      VARCHAR(30)='',             --����סԺ��
	@bqdmlist   VARCHAR(300)='',            --���������б�     
	@addtype	ut_bz	= 0,				--spjg=97ʱ��Ч,0 ��ӡ�1��ɾ��
	@kygjz		VARCHAR(1000)=''			--���ɹؼ���(��˸�����Ϣ)
)
as  

DECLARE @czsj datetime

IF @spjg = '99'  --��ѯ�������������
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
	   ��Ժ���� varchar(30) null,
	   ��˽�� varchar(30) null,
	   ����ԭ�� varchar(500) null,
	   ����� varchar(30) null,
	   ������� datetime null,
	   ��ҳ��� varchar(30) null,
	   סԺ�� varchar(30) NULL,
	   ���ɹؼ��� VARCHAR(1000) NULL
	)
    INSERT INTO #temp 
	SELECT a.blh "������",d.zddm + d.zdmc "�����Ϣ",h.ybsm "�ѱ�",
		   a.hzxm "��������",
		   a.ryrq "��Ժ����",b.name "����",g.name "����",a.cyrq "��Ժ����",
		   CASE ISNULL(c.spjg,'0') WHEN '1' THEN 'ͨ��' WHEN '2' THEN '��ͨ��' ELSE '' end "��˽��",c.spyy "����ԭ��",
		   f.name "�����",c.czrq "�������",a.syxh "��ҳ���",a.blh "סԺ��",c.kygjz "���ɹؼ���"
    FROM ZY_BRSYK a(NOLOCK) INNER JOIN YY_KSBMK b(NOLOCK) ON a.ksdm = b.id 
							LEFT JOIN YY_CQYB_ZDYZDSPJG c(NOLOCK) ON a.syxh = c.syxh AND ISNULL(c.sjly ,'0') = '0'
							INNER JOIN VW_CQYB_ZYBRRYZD d(NOLOCK) ON a.syxh = d.syxh
							INNER JOIN YY_CQYB_ZDYSPXM e(NOLOCK) ON e.xmdm = d.zddm AND e.xmlb = '2'  
							LEFT JOIN YY_ZGBMK f(NOLOCK) ON c.czyh = f.id
							LEFT JOIN ZY_BQDMK g(NOLOCK) ON a.bqdm = g.id
							LEFT JOIN YY_YBFLK h(NOLOCK) ON a.ybdm = h.ybdm
	WHERE a.brzt NOT IN (3,8,9)
	  and a.ryrq >= @ksrq
	  AND a.ryrq <= @jsrq
	  AND (ISNULL(c.spjg,'3') = @spbz OR '0' = @spbz)
	  AND (a.hzxm LIKE +@xmzyh+'%' OR a.blh = @xmzyh)
	  AND ( charindex(convert(varchar(12),RTRIM(a.bqdm)),@bqdmlist) > 0 OR @bqdmlist = '' )
	
	INSERT INTO #temp
	SELECT a.blh "������",d.zddm + d.zdmc "�����Ϣ",h.ybsm "�ѱ�",
		   a.hzxm "��������",
		   a.ryrq "��Ժ����",b.name "����",g.name "����",a.cyrq "��Ժ����",
		   CASE ISNULL(c.spjg,'0') WHEN '1' THEN 'ͨ��' WHEN '2' THEN '��ͨ��' ELSE '' end "��˽��",c.spyy "����ԭ��",
		   f.name "�����",c.czrq "�������",a.syxh "��ҳ���",a.blh "סԺ��",c.kygjz "���ɹؼ���"
    FROM ZY_BRSYK a(NOLOCK) INNER JOIN YY_KSBMK b(NOLOCK) ON a.ksdm = b.id 
							INNER JOIN YY_CQYB_ZDYZDSPJG c(NOLOCK) ON a.syxh = c.syxh AND ISNULL(c.sjly ,'0') <> '0'
							LEFT JOIN VW_CQYB_ZYBRRYZD d(NOLOCK) ON a.syxh = d.syxh 
							LEFT JOIN YY_ZGBMK f(NOLOCK) ON c.czyh = f.id
							LEFT JOIN ZY_BQDMK g(NOLOCK) ON a.bqdm = g.id
							LEFT JOIN YY_YBFLK h(NOLOCK) ON a.ybdm = h.ybdm
	WHERE a.brzt NOT IN (3,8,9)
	  and a.ryrq >= @ksrq
	  AND a.ryrq <= @jsrq
	  AND (CASE ISNULL(c.spjg,'3') WHEN '0' THEN '3' ELSE c.spjg END = @spbz OR '0' = @spbz)
	  AND (a.hzxm LIKE +@xmzyh+'%' OR a.blh = @xmzyh)
	  AND ( charindex(convert(varchar(12),RTRIM(a.bqdm)),@bqdmlist) > 0 OR @bqdmlist = '' )
	 	  
	SELECT a.������,
		CONVERT(VARCHAR(1000),STUFF((select ','+CONVERT(varchar(100), b.�����Ϣ) FROM #temp b 
		    WHERE b.��ҳ���=a.��ҳ���  order by b.�����Ϣ for xml path('') ), 1, 1, '')) "�����Ϣ",a.�ѱ�,
		a.��������,a.��Ժ����,a.����,a.����,a.��Ժ����,a.��˽��,a.����ԭ��,a.�����,a.�������,a.��ҳ���,a.סԺ��,a.���ɹؼ���
	FROM  #temp a
	GROUP BY a.������,��������,a.��Ժ����,a.����,a.����,��Ժ����,a.��˽��,a.����ԭ��,a.�����,a.�������,
			 a.��ҳ���,a.סԺ��,a.�ѱ�,a.���ɹؼ���
	ORDER BY a.����,a.����,a.������,a.��Ժ����
END
ELSE IF @spjg = '98' --�ֹ������������Ĳ���(��sjly=1)
BEGIN
    IF NOT EXISTS(SELECT 1 FROM YY_CQYB_ZDYZDSPJG(NOLOCK) WHERE syxh = @syxh) 
	BEGIN
	    SET @czsj = GETDATE()
		INSERT INTO YY_CQYB_ZDYZDSPJG (syxh,  spjg, spyy, czyh, czrq,sjly,kygjz)
		VALUES  (@syxh, -- syxh - ut_syxh
				 '2', -- spjg - varchar(3)  --Ĭ��Ϊ��ͨ��
				 '�ֹ�����������', -- spyy - varchar(1000)
				 @czyh, -- czyh - varchar(10)
				 @czsj,  -- czrq - datetime
				 '1',
				 @kygjz
				 )
		if @@error <> 0 AND @@ROWCOUNT <> 1 
		begin
			ROLLBACK TRAN
			SELECT 'F','��������������ʧ�ܣ�'
			return
		end
	END
	ELSE
    BEGIN
	    SELECT 'F','�ò�������ӹ���'
		RETURN
    END
    SELECT 'T',''
	RETURN
END
ELSE IF @spjg = '97' --���Ӳ�������������Ĳ���(sjly=1)
BEGIN
	IF @addtype = 0
	BEGIN
		IF NOT EXISTS(SELECT 1 FROM YY_CQYB_ZDYZDSPJG(NOLOCK) WHERE syxh = @syxh) 
		BEGIN
			SET @czsj = GETDATE()
			INSERT INTO YY_CQYB_ZDYZDSPJG (syxh,  spjg, spyy, czyh, czrq,sjly,kygjz)
			VALUES  (@syxh, -- syxh - ut_syxh
					 '0', -- spjg - varchar(3)  --Ĭ��Ϊδ���
					 CASE ISNULL(@spyy,'') WHEN '' then '���Ӳ�������������' ELSE @spyy END,
					 @czyh, -- czyh - varchar(10)
					 @czsj,  -- czrq - datetime
					 '1',
					 @kygjz
					 )
			if @@error <> 0 AND @@ROWCOUNT <> 1 
			begin
				ROLLBACK TRAN
				SELECT 'F','��������ʧ�ܣ�'
				return
			end
		END
		ELSE
		BEGIN
			SELECT 'F','�ò�������ӹ���'
			RETURN
		END		
	END
	ELSE IF @addtype = 1 
	BEGIN
		IF EXISTS(SELECT 1 FROM YY_CQYB_ZDYZDSPJG(NOLOCK) WHERE syxh = @syxh) 
		BEGIN
			DELETE FROM YY_CQYB_ZDYZDSPJG WHERE syxh = @syxh
			if @@error <> 0 AND @@ROWCOUNT <> 1 
			begin
				ROLLBACK TRAN
				SELECT 'F','ɾ������ʧ�ܣ�'
				return
			end
		END
	END
	ELSE
	BEGIN
		SELECT 'F','δ����Ĳ������ͣ�'
		return
	END	
    SELECT 'T',''
	RETURN
END
ELSE IF @spjg = '96'  --��ѯ��Ժ�����������
BEGIN	
    CREATE TABLE #temp1 
	(
	   ������ varchar(30) null,
	   �����Ϣ varchar(200) null,
	   �ѱ�     VARCHAR(20) NULL,
	   �������� varchar(30) null,
	   ��Ժ���� varchar(30) null,
	   ���� varchar(50) null,
	   ���� varchar(50) null,
	   ��Ժ���� varchar(30) null,
	   ��˽�� varchar(30) null,
	   ����ԭ�� varchar(500) null,
	   ����� varchar(30) null,
	   ������� datetime null,
	   ��ҳ��� varchar(30) null,
	   סԺ�� varchar(30) null,
	   ���ɹؼ��� VARCHAR(1000) NULL
	)
    INSERT INTO #temp1 
	SELECT a.blh "������",d.zddm + d.zdmc "�����Ϣ",h.ybsm "�ѱ�",
		   a.hzxm "��������",
		   a.ryrq "��Ժ����",b.name "����",g.name "����",a.cyrq "��Ժ����",
		   CASE ISNULL(c.spjg,'0') WHEN '1' THEN 'ͨ��' WHEN '2' THEN '��ͨ��' ELSE '' end "��˽��",c.spyy "����ԭ��",
		   f.name "�����",c.czrq "�������",a.syxh "��ҳ���",a.blh "סԺ��",c.kygjz "���ɹؼ���"
    FROM ZY_BRSYK a(NOLOCK) INNER JOIN YY_KSBMK b(NOLOCK) ON a.ksdm = b.id 
							LEFT JOIN YY_CQYB_ZDYZDSPJG c(NOLOCK) ON a.syxh = c.syxh AND ISNULL(c.sjly ,'0') = '0'
							INNER JOIN VW_CQYB_ZYBRRYZD d(NOLOCK) ON a.syxh = d.syxh
							INNER JOIN YY_CQYB_ZDYSPXM e(NOLOCK) ON e.xmdm = d.zddm AND e.xmlb = '2'  
							LEFT JOIN YY_ZGBMK f(NOLOCK) ON c.czyh = f.id
							LEFT JOIN ZY_BQDMK g(NOLOCK) ON a.bqdm = g.id
							LEFT JOIN YY_YBFLK h(NOLOCK) ON a.ybdm = h.ybdm
	WHERE a.brzt IN (3,8,9)
	  and a.ryrq >= @ksrq
	  AND a.ryrq <= @jsrq
	  AND (ISNULL(c.spjg,'3') = @spbz OR '0' = @spbz)
	  AND (a.hzxm LIKE +@xmzyh+'%' OR a.blh = @xmzyh)
	  AND ( charindex(convert(varchar(12),RTRIM(a.bqdm)),@bqdmlist) > 0 OR @bqdmlist = '' )

	INSERT INTO #temp1
	SELECT a.blh "������",d.zddm + d.zdmc "�����Ϣ",h.ybsm "�ѱ�",
		   a.hzxm "��������",
		   a.ryrq "��Ժ����",b.name "����",g.name "����",a.cyrq "��Ժ����",
		   CASE ISNULL(c.spjg,'0') WHEN '1' THEN 'ͨ��' WHEN '2' THEN '��ͨ��' ELSE '' end "��˽��",c.spyy "����ԭ��",
		   f.name "�����",c.czrq "�������",a.syxh "��ҳ���",a.blh "סԺ��",c.kygjz "���ɹؼ���"
    FROM ZY_BRSYK a(NOLOCK) INNER JOIN YY_KSBMK b(NOLOCK) ON a.ksdm = b.id 
							INNER JOIN YY_CQYB_ZDYZDSPJG c(NOLOCK) ON a.syxh = c.syxh AND ISNULL(c.sjly ,'0') <> '0'
							LEFT JOIN VW_CQYB_ZYBRRYZD d(NOLOCK) ON a.syxh = d.syxh 
							LEFT JOIN YY_ZGBMK f(NOLOCK) ON c.czyh = f.id
							LEFT JOIN ZY_BQDMK g(NOLOCK) ON a.bqdm = g.id
							LEFT JOIN YY_YBFLK h(NOLOCK) ON a.ybdm = h.ybdm
	WHERE a.brzt IN (3,8,9)
	  and a.ryrq >= @ksrq
	  AND a.ryrq <= @jsrq
	  AND (CASE ISNULL(c.spjg,'3') WHEN '0' THEN '3' ELSE c.spjg END = @spbz OR '0' = @spbz)
	  AND (a.hzxm LIKE +@xmzyh+'%' OR a.blh = @xmzyh)
	  AND ( charindex(convert(varchar(12),RTRIM(a.bqdm)),@bqdmlist) > 0 OR @bqdmlist = '' )

	SELECT a.������,
		CONVERT(VARCHAR(1000),STUFF((select ','+CONVERT(varchar(100), b.�����Ϣ) FROM #temp1 b 
		    WHERE b.��ҳ���=a.��ҳ���  order by b.�����Ϣ for xml path('') ), 1, 1, '')) "�����Ϣ",a.�ѱ�,
		a.��������,a.��Ժ����,a.����,a.����,a.��Ժ����,a.��˽��,a.����ԭ��,a.�����,a.�������,a.��ҳ���,a.סԺ��,a.���ɹؼ��� 
	FROM  #temp1 a
	GROUP BY a.������,��������,a.��Ժ����,a.����,a.����,��Ժ����,a.��˽��,a.����ԭ��,a.�����,a.�������,
			 a.��ҳ���,a.סԺ��,a.�ѱ�,a.���ɹؼ���
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
	IF NOT EXISTS(SELECT 1 FROM YY_CQYB_ZDYZDSPJG(NOLOCK) WHERE syxh = @syxh) 
	BEGIN
		INSERT INTO YY_CQYB_ZDYZDSPJG (syxh,  spjg, spyy, czyh, czrq,sjly,kygjz)
		VALUES  (@syxh, -- syxh - ut_syxh
				 @spjg, -- spjg - varchar(3)
				 @spyy, -- spyy - varchar(1000)
				 @czyh, -- czyh - varchar(10)
				 @czsj,  -- czrq - datetime
				 '0',
				 @kygjz
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
		IF @spjg = '0' 
		BEGIN
			DELETE YY_CQYB_ZDYZDSPJG where syxh=@syxh
			if @@error <> 0 AND @@ROWCOUNT <> 1 
			begin
				ROLLBACK TRAN
				SELECT 'F','ȡ��ҽ����Ŀ�������ʧ�ܣ�'
				return
			end
		END
		ELSE
		BEGIN 
			UPDATE YY_CQYB_ZDYZDSPJG SET spjg = @spjg,spyy=@spyy,czyh=@czyh,czrq=@czsj WHERE syxh = @syxh
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
