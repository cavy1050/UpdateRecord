if exists(select 1 from sysobjects where name = 'usp_cqyb_scmxsd')
  drop proc usp_cqyb_scmxsd
go
Create proc usp_cqyb_scmxsd
(
	@syxh varchar(20)='',	 --首页序号
	@lb   varchar(10),        --类别lock：锁定  unlock：解锁
	@bz   varchar(3)         --上传明细锁定标志  2，3：结算，医保审核   4:病区催款
)
as
/****************************************
[版本号]4.0.0.0.0
[创建时间]2017.07.07
[作者]qinfj
[版权]Copyright ? 1998-2017卫宁健康科技集团股份有限公司
[描述]医保明细上传锁定解锁
[功能说明]
	医保明细上传锁定解锁
[参数说明]
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]

exec usp_cqyb_scmxsd '503470','lock','3'
exec usp_cqyb_scmxsd '503536','unlock','2'
select a.* from YY_CQYB_ZYJZJLK a WHERE a.syxh = 503536

[修改记录]  
****************************************/
set nocount on 
DECLARE @scsdsj VARCHAR(20),
        @scsdbz varchar(3),
        @now    VARCHAR(20)
 
IF @syxh = ''
BEGIN
    SELECT 'F','首页序号为空！'
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
				SELECT 'F','已被锁定，请先解锁！'
				rollback TRANSACTION
				RETURN
			END
		END		
	END
	
    SELECT @now = CONVERT(VARCHAR(20),GETDATE(),120)
    UPDATE YY_CQYB_ZYJZJLK SET scsdbz = @bz,scsdsj = @now WHERE syxh = @syxh AND jlzt = 1
    IF @@error <> 0
	BEGIN
		SELECT 'F','锁定失败！'
		rollback TRANSACTION
		return
	end
END
ELSE IF @lb = 'unlock'
BEGIN
    UPDATE YY_CQYB_ZYJZJLK SET scsdbz = 0,scsdsj = '' WHERE syxh = @syxh AND jlzt = 1
    if @@error <> 0
	begin
		select 'F','解锁失败！'
		rollback TRANSACTION
		return
	end
END
ELSE
BEGIN
    select 'F','非法入参！'
	rollback TRANSACTION
	return
END 

COMMIT TRANSACTION 

SELECT 'T',''

return
GO
