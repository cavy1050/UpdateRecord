IF exists(SELECT 1 FROM sysobjects WHERE name = 'usp_cqyb_checkzdyxx')
  DROP PROC usp_cqyb_checkzdyxx
GO
CREATE PROC usp_cqyb_checkzdyxx
(
	@czlb				VARCHAR(10),			--�������
	@str				VARCHAR(500) = '',
	@str1				VARCHAR(500) = '',
	@str2				VARCHAR(500) = '',
	@str3				VARCHAR(500) = '',
	@str4				VARCHAR(500) = '',
	@str5				VARCHAR(500) = '',
	@str6				VARCHAR(500) = '',
	@str7				VARCHAR(500) = '',
	@str8				VARCHAR(500) = '',
	@str9				VARCHAR(500) = ''
)
AS
/****************************************
[�汾��]4.0.0.0.0
[����ʱ��]2018.12.31
[����]Zhuhb
[��Ȩ]Copyright ? 1998-2017���������Ƽ����Źɷ����޹�˾
[����]����Զ�����Ϣ
[����˵��]
	����Զ�����Ϣ
[����˵��]
	@czlb	1:ҽ���˷�ʱ����˻������Ƿ���ʾ
			2:�жϲ�����Ժ�Ƿ�365����Ҫ�н�
			3:�Ե�ǰ��ƶ��Ա��������ʾ
			4:ʱ�������쳣��ʾ
[����ֵ]
	����ʱ�̶�����ֵ��ʽ��
[�����������]
[���õ�sp]
[����ʵ��]
[�޸ļ�¼]

****************************************/
SET NOCOUNT ON

DECLARE @ybdm		ut_ybdm,			--ҽ������
		@cblb_his	VARCHAR(10)			--�α����
IF @czlb = 1
BEGIN
	IF NOT EXISTS(SELECT 1 FROM YY_CQYB_MZDYJLK a(NOLOCK) WHERE a.jssjh = @str AND a.jlzt = 2)
	BEGIN
		SELECT "T",""
		RETURN
	END
	ELSE
	BEGIN
		SELECT "F","�ñʽ��״����˻�����"
		RETURN
	END

END
IF @czlb = 2
BEGIN
	--@str1 ��ҳ��š�@str2 �������
	--��׼�汾1
	--DECLARE @rqrq VARCHAR(30),
	--		@cqrq VARCHAR(30);
	--IF EXISTS(SELECT 1 FROM ZY_BRSYK a(NOLOCK) WHERE a.syxh = @str1 AND a.brzt = 2 )
	--BEGIN
	--	SELECT	@rqrq = SUBSTRING(a.rqrq,1,8) + ' ' + SUBSTRING(a.rqrq,10,8),
	--			@cqrq = SUBSTRING(a.cqrq,1,8) + ' ' + SUBSTRING(a.cqrq,10,8)
	--	FROM ZY_BRSYK a(NOLOCK) WHERE a.syxh = @str1 AND a.brzt = 2		
	--END
	--ELSE
	--BEGIN
	--	SELECT "F","��ȡ���������쳣"
	--	RETURN		
	--END	
	--IF (ISDATE(@rqrq) = 0) OR (ISDATE(@cqrq) = 0)
	--BEGIN
	--	SELECT "F","����ʱ������ʱ���ʽ����"
	--	RETURN
	--END
	
	--IF CONVERT(datetime,@cqrq,101) > DATEADD(YEAR,1,CONVERT(datetime,@rqrq,101))
	--BEGIN
	--	SELECT "F","�û�����Ժʱ�䳬��365�죬���Ƚ�����;����"
	--	RETURN
	--END

	--��׼�汾2
	SELECT "T",""
	RETURN
END
IF @czlb = 3--�Ե�ǰ��ƶ��Ա��������ʾ
BEGIN
	--��׼�汾
	SELECT 'T',''
	RETURN
	--�����汾
	--IF EXISTS(SELECT 1 FROM YY_CQYB_PATINFO a(NOLOCK) WHERE a.sbkh = @str AND ISNULL(a.dqfprylb,'') <> '')
	--BEGIN
	--	SELECT 'T','��ע�⣺�ò��ˣ�' + a.sbkh + '��Ϊ' + a.dqfprylb FROM YY_CQYB_PATINFO a(NOLOCK) 
	--	WHERE a.sbkh = @str AND ISNULL(a.dqfprylb,'') <> ''
	--	RETURN	
	--END
	--ELSE
	--BEGIN
	--	SELECT 'T',''
	--	RETURN	
	--END
END
IF @czlb = 4--ʱ�������쳣��ʾ
BEGIN
	declare @cnt INT,
			@spjg	VARCHAR(10),
			@spyy	VARCHAR(1000);
	--��׼�汾
	SELECT 'T',''
	RETURN
	/*
	--��������ҽԺ
	IF NOT EXISTS(SELECT 1 FROM YY_CQYB_SHSPJG a(NOLOCK) WHERE a.syxh= @str)
	BEGIN
		SELECT 'T',''
	END
	ELSE
	BEGIN
		SELECT @cnt = COUNT(0) FROM YY_CQYB_SHSPJG a(NOLOCK) WHERE a.syxh= @str
		IF @cnt > 1
		BEGIN
			SELECT 'R','�º������쳣����ѯ�������ݼ�����1����'	
		END
		ELSE
		BEGIN
			SELECT @spjg = spjg,@spyy = a.spyy FROM YY_CQYB_SHSPJG a(NOLOCK) WHERE a.syxh= @str
			IF @spjg = '2'
			BEGIN
				SELECT 'R','�º�����δͨ����'+ @spyy + '����' + '�뵽���ڴ���'	
			END	
			ELSE
			BEGIN
				SELECT 'T',''
			END		
		END
	END
	RETURN
	*/
END
IF @czlb = 5--��̨��ȡ360��ͼ��ַ
BEGIN
	--��׼�汾
	SELECT 'T',''
	RETURN
	/*
	--��������ҽԺ�汾
	SELECT 'T','http://www.winning.com.cn'
	RETURN	
	*/
END

SELECT "T",""

RETURN
GO
