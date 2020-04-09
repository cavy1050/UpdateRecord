if exists(select 1 from sysobjects where name='usp_cqyb_ybzddz')
  drop proc usp_cqyb_ybzddz
GO

CREATE proc usp_cqyb_ybzddz
(
    @code		varchar(30),	          --���״��� GET_ZDLBLB ��ȡ�ֵ�����б� GET_ZDXXȡhis 
    @zdlb         VARCHAR(12)='',         --�ֵ���� 
    @hisid		VARCHAR(30)='',			  --his�ֵ����
    @ybid       VARCHAR(30)=''            --ҽ���ֵ���� 
)
/*
�������ֶα������������޸�
*/
as  


DECLARE @czsj datetime

SET @czsj = GETDATE()
    
IF @code = 'GET_ZDLBLB'  --��ȡ�ֵ�����б�
BEGIN
    SELECT DISTINCT zdlb + '-' + zdsm '�ֵ����' FROM YY_CQYB_YBSJZD
    WHERE zdlb IN ('JX','DCJLDW','ZXJLDW','YYTJ','SYPC','CYYY','YLLB') AND ISNULL(jlzt,0) = 0
END
ELSE IF @code = 'GET_ZDXX' --����zdlb��ȡҽ���ֵ���Ϣ
BEGIN
    SELECT code '����',name '����',CASE xtbz WHEN 0 THEN '����' WHEN 1 THEN 'סԺ' ELSE 'δ֪' END 'ϵͳ��־'
    FROM YY_CQYB_YBSJZD WHERE zdlb = @zdlb AND ISNULL(jlzt,0) = 0
END
ELSE IF @code = 'GET_HISZDXX' --��ȡHis�ֵ�
BEGIN
    IF @zdlb IN ('JX','CBLB')
    BEGIN
        SELECT id '����',name '����',py 'ƴ����',wb '�����' FROM YK_YPJXK 
        where id NOT IN (SELECT hiscode FROM YY_CQYB_YBSJZD_DZ WHERE zdlb = @zdlb)
    END
    ELSE IF @zdlb = 'DCJLDW' 
    BEGIN
        SELECT id '����',name '����',py 'ƴ����',wb '�����' FROM YY_UNIT WHERE lb = 1 
        and id NOT IN (SELECT hiscode FROM YY_CQYB_YBSJZD_DZ WHERE zdlb = @zdlb)                        
	END 
	ELSE IF @zdlb = 'ZXJLDW'
	BEGIN
	    SELECT id '����',name '����',py 'ƴ����',wb '�����' FROM YY_UNIT WHERE lb = 0
	    and id NOT IN (SELECT hiscode FROM YY_CQYB_YBSJZD_DZ WHERE zdlb = @zdlb)
	END 
	ELSE IF @zdlb = 'YYTJ' 
	BEGIN
	    SELECT id '����',name '����',py 'ƴ����',wb '�����' FROM SF_YPYFK WHERE jlzt = 0
	    and id NOT IN (SELECT hiscode FROM YY_CQYB_YBSJZD_DZ WHERE zdlb = @zdlb)
	END
	ELSE IF @zdlb = 'SYPC'
	BEGIN
	    SELECT id '����',xsmc+'('+name+')' '����',py 'ƴ����',wb '�����' FROM SF_YS_YZPCK WHERE jlzt = 0
	    and id NOT IN (SELECT hiscode FROM YY_CQYB_YBSJZD_DZ WHERE zdlb = @zdlb)
	END
    ELSE IF @zdlb = 'CYYY'
    BEGIN
        SELECT id '����',name '����',py 'ƴ����',wb '�����' FROM ZYB_CYFSK
		WHERE  id NOT IN (SELECT hiscode FROM YY_CQYB_YBSJZD_DZ WHERE zdlb = @zdlb)
	END
    ELSE IF @zdlb = 'YLLB'
    BEGIN
        SELECT id '����',name '����',py 'ƴ����',wb '�����' FROM ZYB_RYFSK
		WHERE  id NOT IN (SELECT hiscode FROM YY_CQYB_YBSJZD_DZ WHERE zdlb = @zdlb)
	END
    RETURN   
END
ELSE IF @code = 'GET_YDZXX' --����zdlb��ȡ�Ѷ�����Ϣ
BEGIN
    SELECT zdlb, hiscode 'His����' ,ybcode 'ҽ������' FROM YY_CQYB_YBSJZD_DZ 
    WHERE zdlb = @zdlb 
    
    /*
    IF @zdlb = 'JX'
    BEGIN
        SELECT id '����',name '����',py 'ƴ����',wb '�����' FROM YK_YPJXK 
    END
    ELSE IF @zdlb = 'DCJLDW' 
    BEGIN
        SELECT id '����',name '����',py 'ƴ����',wb '�����' FROM YY_UNIT WHERE lb = 1                         
	END 
	ELSE IF @zdlb = 'ZXJLDW'
	BEGIN
	    SELECT id '����',name '����',py 'ƴ����',wb '�����' FROM YY_UNIT WHERE lb = 0
	END 
	ELSE IF @zdlb = 'YYTJ' 
	BEGIN
	    SELECT id '����',name '����',py 'ƴ����',wb '�����' FROM SF_YPYFK WHERE jlzt = 0
	END
	ELSE IF @zdlb = 'SYPC'
	BEGIN
	    SELECT id '����',xsmc+'('+name+')' '����',py 'ƴ����',wb '�����' FROM SF_YS_YZPCK WHERE jlzt = 0
	END
	*/
END
ELSE IF @code = 'SAVE_DZXX' --���������Ϣ
BEGIN
    INSERT INTO YY_CQYB_YBSJZD_DZ (zdlb, hiscode, ybcode)
    VALUES  (@zdlb, -- zdlb - varchar(20)
             @hisid, -- hiscode - varchar(20)
             @ybid  -- ybcode - varchar(20)
             )
    if @@error <> 0 AND @@ROWCOUNT < 1
	begin
        ROLLBACK TRAN
        SELECT 'F','���ձ���ʧ�ܣ�'
		return
	END
	SELECT 'T',''
    RETURN     
END
ELSE IF @code = 'DEL_DZXX' --ɾ��������Ϣ
BEGIN
    DELETE YY_CQYB_YBSJZD_DZ WHERE zdlb = @zdlb AND hiscode =@hisid
    if @@error <> 0 AND @@ROWCOUNT < 1
	begin
        ROLLBACK TRAN
        SELECT 'F','ȡ������ʧ�ܣ�'
		return
	END
	SELECT 'T',''
    RETURN   
END
ELSE
BEGIN
	SELECT 'F','û�иý��״���'
	RETURN
END

RETURN
go
