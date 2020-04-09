if exists(select 1 from sysobjects where name = 'usp_cqyb_savegsrdinfo')
  drop proc usp_cqyb_savegsrdinfo
go
Create proc usp_cqyb_savegsrdinfo
(
	@sbkh				varchar(20),		--社会保障号码
	@grbh				varchar(10),		--个人编号
	@dwbh				varchar(10),		--单位编号
	@rdbh				varchar(50),		--认定编号
	@tgbz				ut_bz,				--通过标志0未通过1通过2认定结果未下达		
	@sssj				varchar(10),		--工伤受伤事件
	@jssj				varchar(10),		--治疗参考结束事件
	@bzinfo				varchar(200)		--工伤受伤病种信息
)
as
/****************************************
[版本号]4.0.0.0.0
[创建时间]2017.03.05
[作者]FerryMan
[版权]Copyright ? 1998-2017卫宁健康科技集团股份有限公司
[描述]保存医保工伤认定信息
[功能说明]
	保存医保工伤认定信息
[参数说明]
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]
[修改记录]
****************************************/
set nocount on
	
if not exists(select 1 from YY_CQYB_GSRDINFO where sbkh = @sbkh and rdbh = @rdbh)
begin
	insert into YY_CQYB_GSRDINFO(sbkh,grbh,dwbh,rdbh,tgbz,sssj,jssj,bzinfo,jlzt)
	select @sbkh,@grbh,@dwbh,@rdbh,@tgbz,@sssj,@jssj,@bzinfo,0
	if @@error<>0 or @@rowcount = 0 
	begin
		select "F","保存医保工伤认定信息失败!"
		return
	end;
end
else
begin
	update YY_CQYB_GSRDINFO set grbh = @grbh,dwbh = @dwbh,tgbz = @tgbz,sssj = @sssj,jssj = @jssj,
		bzinfo = @bzinfo,jlzt = 0 where sbkh = @sbkh and rdbh = @rdbh
	if @@error<>0 or @@rowcount = 0 
	begin
		select "F","更新医保工伤认定信息失败!"
		return
	end;
end

select "T"

return
GO
