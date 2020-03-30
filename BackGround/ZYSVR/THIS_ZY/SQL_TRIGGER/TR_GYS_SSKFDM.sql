IF OBJECT_ID('TR_GYS_SSKFDM','TR') IS NOT NULL
DROP TRIGGER TR_GYS_SSKFDM
GO

CREATE TRIGGER TR_GYS_SSKFDM ON dbo.GYS_XDBSMQK AFTER INSERT
AS

/*****************************
--add by yangdi 2020.3.29
���Ӵ����������������״δ����GYS_XDBSMQK.sskfdm,GYS_XDBSMQK.sskfmcΪnull,���²��ܽ��л������⡣
GYS_XDBSMQK.sskfdm=GYS_XDBSMQK.kfdm
GYS_XDBSMQK.sskfmc=GYS_XDBSMQK.kfmc
*****************************/

SET NOCOUNT ON

IF EXISTS(SELECT 1 FROM INSERTED) AND NOT EXISTS (SELECT 1 FROM DELETED)
BEGIN
	UPDATE b SET b.sskfdm=a.kfdm,b.sskfmc=a.kfmc FROM INSERTED a
		INNER JOIN dbo.GYS_XDBSMQK b ON a.xh=b.xh
END

RETURN