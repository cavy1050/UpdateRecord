IF exists(SELECT 1 FROM sysobjects WHERE name = 'usp_cqyb_zdyspxminport')
  DROP PROC usp_cqyb_zdyspxminport
GO
CREATE PROC usp_cqyb_zdyspxminport
	@czyh ut_czyh	--����Ա��
AS
/****************************************
[�汾��]4.0.0.0.0
[����ʱ��]2019.2.25
[����]Zhuhb
[��Ȩ]Copyright ? 1998-2017���������Ƽ����Źɷ����޹�˾
[����]ҽ��������Ŀ�Զ��嵼��
[����˵��]
	�ṩҽ��������Ŀ�Զ��嵼�빦�ܣ��ֳ��Զ���洢���ֳ�ά����
[����˵��]
	--
[����ֵ]
	--
[�����������]
[���õ�sp]
[����ʵ��]
[�޸ļ�¼]

****************************************/
SET NOCOUNT ON

SELECT "T"

RETURN
GO
