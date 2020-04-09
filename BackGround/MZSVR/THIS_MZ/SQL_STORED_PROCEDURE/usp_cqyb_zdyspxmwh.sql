if exists(select 1 from sysobjects where name='usp_cqyb_zdyspxmwh')
  drop proc usp_cqyb_zdyspxmwh
GO

CREATE proc usp_cqyb_zdyspxmwh
(
    @code		varchar(10),	          --���״��� 01������02����/ͣ��,03��ѯά����Ϣ,04��ѯ��־
    @xh         VARCHAR(12)='',           --��� 
    @xmlb		VARCHAR(30)='',			  --��Ŀ��� 0ҩƷ 1���� 2���
    @xmdm       VARCHAR(30)='',           --��Ŀ���� 
	@xmmc       VARCHAR(100)='',          --��Ŀ����
    @jlzt       ut_bz = 0,                --��¼״̬
    @czyh       VARCHAR(10)=''               --�����û�
)
as  

DECLARE @czsj datetime

SET @czsj = GETDATE()
    
IF @code = '01'  --����
BEGIN
    
    IF EXISTS(SELECT 1 FROM YY_CQYB_ZDYSPXM WHERE xmlb = @xmlb AND xmdm = @xmdm)
    BEGIN
        SELECT 'F','����Ŀ�Ѵ���,�����ظ���ӣ�'
        RETURN
    END
    
    BEGIN TRAN
    
    INSERT INTO YY_CQYB_ZDYSPXM (xmlb, xmdm, xmmc, jlzt,czyh,czsj)
    VALUES  (@xmlb, @xmdm, @xmmc, 0,@czyh,@czsj )
    if @@error <> 0
	begin
        ROLLBACK TRAN
        SELECT 'F','����ʧ��'
		return
	end
    
    INSERT INTO YY_CQYB_ZDYSPXMLOG (whxh, czyh, czlb, czrq, memo)
    VALUES  (@@IDENTITY,  @czyh,  0,  @czsj, '����' )
    if @@error <> 0
	begin
        ROLLBACK TRAN
        SELECT 'F','����ʧ��log'
		return
	END
	
    COMMIT TRAN
    SELECT 'T',''
	RETURN
END
ELSE IF @code = '02' --����/ͣ��
BEGIN
    BEGIN TRAN
    
    UPDATE YY_CQYB_ZDYSPXM SET jlzt = @jlzt WHERE xh = @xh
    if @@error <> 0
	begin
        ROLLBACK TRAN
        SELECT 'F','����ʧ��'
		return
	end
    
    INSERT INTO YY_CQYB_ZDYSPXMLOG (whxh, czyh, czlb, czrq, memo)
    VALUES  (@xh,  @czyh,  CASE @jlzt WHEN '1' THEN 2 WHEN '0' THEN 1 ELSE NULL END ,
             @czsj, CASE @jlzt WHEN '1' THEN 'ͣ��' WHEN '0' THEN '����' ELSE NULL END)
    if @@error <> 0
	begin
        ROLLBACK TRAN
        SELECT 'F','����ʧ��log'
		return
	END
    
    COMMIT TRAN
    SELECT 'T',''
    RETURN   
END
ELSE IF @code = '03' --��ѯά����Ϣ
BEGIN
    SELECT CASE a.xmlb WHEN '0' THEN 'ҩƷ' WHEN '1' THEN '����' WHEN '2' THEN '���' ELSE '' END "��Ŀ����",
           a.xmdm "��Ŀ����",a.xmmc "��Ŀ����",
           CASE a.jlzt WHEN 1 then "ͣ��" WHEN 0 THEN "����" end AS "��¼״̬",
           a.xh "xh",
		   CASE a.xmlb WHEN '0' THEN (SELECT c.BZ FROM YK_YPCDMLK b(NOLOCK),YPML c(NOLOCK) WHERE b.dydm = c.YPLSH AND a.xmdm = b.idm)
		               WHEN '1' THEN (SELECT e.BZ FROM YY_SFXXMK d(NOLOCK),ZLXM e(NOLOCK)  where d.dydm = e.XMLSH and a.xmdm = d.id)
					   ELSE ''   
		   END as "��ע"
    FROM YY_CQYB_ZDYSPXM a(NOLOCK) 
	WHERE (xmlb = @xmlb OR "-1" = @xmlb) 
	  AND (a.xmmc LIKE '%'+@xmmc+'%')
    
    RETURN   
END
ELSE IF @code = '04' --��ѯ��־
BEGIN
    SELECT a.czlb "�������", a.memo "����˵��",a.czyh "�޸���",a.czrq "�޸�ʱ��" 
    FROM YY_CQYB_ZDYSPXMLOG a(NOLOCK) INNER JOIN YY_CQYB_ZDYSPXM b(NOLOCK) ON a.whxh = b.xh 
    WHERE a.whxh = @xh ORDER BY a.czrq
    
    RETURN   
END
ELSE
BEGIN
	SELECT 'F','û�иý��״���'
	RETURN
END

go
