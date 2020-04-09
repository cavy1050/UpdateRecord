if exists(select 1 from sysobjects where name = 'usp_cqyb_savegsdwinfo')
  drop proc usp_cqyb_savegsdwinfo
go
Create proc usp_cqyb_savegsdwinfo
(
	@sbkh				varchar(20),		--社会保障号码
	@grbh				varchar(10),		--个人编号
	@dwbh				varchar(10),		--单位编号
	@dwmc				varchar(50)			--单位名称
)
as
/****************************************
[版本号]4.0.0.0.0
[创建时间]2017.03.05
[作者]FerryMan
[版权]Copyright ? 1998-2017卫宁健康科技集团股份有限公司
[描述]保存医保工伤单位信息
[功能说明]
	保存医保工伤单位信息
[参数说明]
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]
[修改记录]
****************************************/
set nocount on
	
if not exists(select 1 from YY_CQYB_GSDWINFO where sbkh = @sbkh and grbh = @grbh and dwbh = @dwbh)
begin
	insert into YY_CQYB_GSDWINFO(sbkh,grbh,dwbh,dwmc,jlzt)
	select @sbkh,@grbh,@dwbh,@dwmc,0
	if @@error<>0 or @@rowcount = 0 
	begin
		select "F","保存医保工伤单位信息失败!"
		return
	end;
end
else
begin
	update YY_CQYB_GSDWINFO set dwmc = @dwmc,jlzt = 0 where sbkh = @sbkh and grbh = @grbh and dwbh = @dwbh
	if @@error<>0 or @@rowcount = 0 
	begin
		select "F","更新医保工伤单位信息失败!"
		return
	end;
end

select "T"

return
go
