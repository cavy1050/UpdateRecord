if exists(select 1 from sysobjects where name = 'usp_cqyb_scmxsd')
  drop proc usp_cqyb_scmxsd
go
Create proc usp_cqyb_scmxsd
(
	@syxh varchar(20)='',	 --��ҳ���
	@lb   varchar(10),        --���lock������  unlock������
	@bz   varchar(3)         --�ϴ���ϸ������־  2��3�����㣬ҽ�����   4:�����߿�
)
as
/****************************************
[�汾��]4.0.0.0.0
[����ʱ��]2017.07.07
[����]qinfj
[��Ȩ]Copyright ? 1998-2017���������Ƽ����Źɷ����޹�˾
[����]ҽ����ϸ�ϴ���������
[����˵��]
	ҽ����ϸ�ϴ���������
[����˵��]
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��]

exec usp_cqyb_scmxsd '503470','lock','3'
exec usp_cqyb_scmxsd '503536','unlock','2'
select a.* from YY_CQYB_ZYJZJLK a WHERE a.syxh = 503536

[�޸ļ�¼]  
****************************************/
set nocount on 
DECLARE @scsdsj VARCHAR(20),
        @scsdbz varchar(3),
        @now    VARCHAR(20)
 
IF @syxh = ''
BEGIN
    SELECT 'F','��ҳ���Ϊ�գ�'
    return
END

BEGIN TRANSACTION 

IF @lb = 'lock'
BEGIN
    SELECT @scsdsj = ISNULL(scsdsj,''),@scsdbz = ISNULL(scsdbz,'0') FROM YY_CQYB_ZYJZJLK(NOLOCK) WHERE syxh = @syxh AND jlzt = 1
	IF @scsdbz IN ('2','3','4')
	BEGIN
		IF @scsdsj <> ''
		BEGIN
			if DATEDIFF(HOUR , CONVERT(DATETIME,@scsdsj), GETDATE() ) <= 8
			BEGIN
				SELECT 'F','�ѱ����������Ƚ�����'
				rollback TRANSACTION
				RETURN
			END
		END		
	END
	
    SELECT @now = CONVERT(VARCHAR(20),GETDATE(),120)
    UPDATE YY_CQYB_ZYJZJLK SET scsdbz = @bz,scsdsj = @now WHERE syxh = @syxh AND jlzt = 1
    IF @@error <> 0
	BEGIN
		SELECT 'F','����ʧ�ܣ�'
		rollback TRANSACTION
		return
	end
END
ELSE IF @lb = 'unlock'
BEGIN
    UPDATE YY_CQYB_ZYJZJLK SET scsdbz = 0,scsdsj = '' WHERE syxh = @syxh AND jlzt = 1
    if @@error <> 0
	begin
		select 'F','����ʧ�ܣ�'
		rollback TRANSACTION
		return
	end
END
ELSE
BEGIN
    select 'F','�Ƿ���Σ�'
	rollback TRANSACTION
	return
END 

COMMIT TRANSACTION 

SELECT 'T',''

return
GO
