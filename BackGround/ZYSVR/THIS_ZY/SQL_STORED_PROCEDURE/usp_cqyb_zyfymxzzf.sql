if exists(select 1 from sysobjects where name='usp_cqyb_zyfymxzzf')
  drop proc usp_cqyb_zyfymxzzf
go
CREATE proc usp_cqyb_zyfymxzzf
  @lb   VARCHAR(10),     --01：转自费，02 转医保正常 
  @syxh ut_xh12 = 0, 
  @jsxh  ut_xh12 = 0,   
  @xh ut_xh12,			--zy_fymxk.xh 
  @czyh varchar(10)      
as
/**********
[版本号]4.0.0.0.0
[创建时间]
[作者]
[版权]
[描述]
[功能说明]

[返回值]
[结果集、排序]

**********/

set nocount ON

IF @lb = '01'   --转自费
BEGIN
	BEGIN TRAN
	update YY_CQYB_ZYFYMXK set qzfbz = 1 where syxh = @syxh and jsxh = @jsxh and xh = @xh
    if @@error <> 0 or @@rowcount = 0 
	BEGIN 
		SELECT 'F', '更新转全自费标志出错!' 
		ROLLBACK TRAN 
		RETURN
	END

	insert into YY_CQYB_ZYFYMXK_ZZFLOG(syxh,jsxh,xh,lb,czyh,czrq) 
              values (@syxh,@jsxh, @xh,'1',@czyh,GETDATE())
    if @@error <> 0 or @@rowcount = 0 
	BEGIN 
		SELECT 'F','保存转全自费日志记录出错!' 
		ROLLBACK TRAN 
		RETURN
	END

	COMMIT TRAN
	SELECT 'T',''
END
ELSE IF @lb = '02'  --转医保正常
BEGIN
    BEGIN TRAN
    update YY_CQYB_ZYFYMXK set qzfbz = 0 where syxh = @syxh and jsxh = @jsxh and xh = @xh
    if @@error <> 0 or @@rowcount = 0 
	BEGIN 
		SELECT 'F', '更新转医保标志出错!' 
		ROLLBACK TRAN 
		RETURN
	END 

	insert into YY_CQYB_ZYFYMXK_ZZFLOG(syxh,jsxh,xh,lb,czyh,czrq) 
              values (@syxh,@jsxh, @xh,'2',@czyh,GETDATE())
    if @@error <> 0 or @@rowcount = 0 
	BEGIN 
		SELECT 'F','保存转医保日志记录出错!' 
		ROLLBACK TRAN 
		RETURN
	END

	COMMIT TRAN
	SELECT 'T',''
END

return 
GO
