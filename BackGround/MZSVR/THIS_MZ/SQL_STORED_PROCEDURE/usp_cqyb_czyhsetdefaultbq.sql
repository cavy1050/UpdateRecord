if exists(select 1 from sysobjects where name='usp_cqyb_czyhsetdefaultbq')
  drop proc usp_cqyb_czyhsetdefaultbq
go
Create proc usp_cqyb_czyhsetdefaultbq
(
    @lb         VARCHAR(10),        --�������
    @czyh		VARCHAR(10),		--�����û�
    @bqdm		VARCHAR(10) 		--��������
)
as  
/*
    ��˽������ò���ԱĬ��ѡ����
*/
set nocount on

IF @lb <> '01' and ISNULL(@bqdm,'') = ''  
BEGIN
   SELECT 'F','�������벻��Ϊ�գ�'
   RETURN
end

IF @lb = '01' --��ѯ����Ա���ò���
BEGIN
    SELECT c.name '�����û�',b.name '��������',c.id '�û�����',b.id '��������'  FROM YY_CQYB_CZYHSETDEFAULTBQ a(NOLOCK),ZY_BQDMK b(NOLOCK),YY_ZGBMK c(NOLOCK)
    where a.bqdm = b.id AND a.czyh = c.id
END
ELSE IF @lb = '02' --���没��
BEGIN
    IF EXISTS (SELECT 1 FROM YY_CQYB_CZYHSETDEFAULTBQ WHERE czyh = @czyh AND bqdm = @bqdm)
    BEGIN
        SELECT 'F', '�ò����Ѵ���!'  
		RETURN 
    END
    
    INSERT INTO YY_CQYB_CZYHSETDEFAULTBQ (czyh, bqdm)
    VALUES  (@czyh, @bqdm )
    if @@error <> 0 or @@rowcount = 0 
	BEGIN 
		SELECT 'F', '������������!'  
		RETURN
	END
    SELECT 'T',''
END
ELSE IF @lb = '03' --ɾ������
BEGIN
    DELETE YY_CQYB_CZYHSETDEFAULTBQ where czyh= @czyh and bqdm = @bqdm
    if @@error <> 0 or @@rowcount = 0 
	BEGIN 
		SELECT 'F', 'ɾ����������!'  
		RETURN
	END
    
    SELECT 'T',''
END
ELSE
BEGIN
    SELECT 'F','������������ֵ��'
END


RETURN
GO
