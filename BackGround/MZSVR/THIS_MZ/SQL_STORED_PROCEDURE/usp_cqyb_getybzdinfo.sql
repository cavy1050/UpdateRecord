if exists(select 1 from sysobjects where name='usp_cqyb_getybzdinfo')
  drop proc usp_cqyb_getybzdinfo
go
Create proc usp_cqyb_getybzdinfo
(
  @flag		varchar(40),
  @value	varchar(100)
)
as
/****************************************
[版本号]4.0.0.0.0
[创建时间]2017.03.05
[作者]FerryMan
[版权]Copyright ? 1998-2017卫宁健康科技集团股份有限公司
[描述]获取医保返回值涵义
[功能说明]
	获取医保返回值涵义
[参数说明]
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]
[修改记录] 
****************************************/
set nocount on 

if @flag = '人员类别' 
begin
	if exists(select 1 from YY_CQYB_YBSJZD where zdlb = 'RYLB' and code = @value and jlzt = 0)
		select "T",name from YY_CQYB_YBSJZD where zdlb = 'RYLB' and code = @value and jlzt = 0
	else
		select "T",@value
end
else if @flag = '是否享受公务员待遇' 
begin
	if @value = '0'
		select "T","不享受"
	else if @value = '1'
		select "T","享受"
	else
		select "T",@value
end
else if @flag = '行政区划编码' 
begin
	if exists(select 1 from YY_CQYB_YBSJZD where zdlb = 'XZQH' and code = @value and jlzt = 0)
		select "T",name from YY_CQYB_YBSJZD where zdlb = 'XZQH' and code = @value and jlzt = 0
	else
		select "T",@value
end
else if @flag = '封锁状况' 
begin
	if exists(select 1 from YY_CQYB_YBSJZD where zdlb = 'FSZK' and code = @value and jlzt = 0)
		select "T",name from YY_CQYB_YBSJZD where zdlb = 'FSZK' and code = @value and jlzt = 0
	else if ltrim(rtrim(@value)) = '' or @value = '0' 
		select "T","无封锁"
	else
		select "T",@value
end
else if @flag = '人员变更类型' 
begin
	if exists(select 1 from YY_CQYB_YBSJZD where zdlb = 'RYLXBG' and code = @value and jlzt = 0)
		select "T",name from YY_CQYB_YBSJZD where zdlb = 'RYLXBG' and code = @value and jlzt = 0
	else
		select "T",@value
end
else if @flag = '民政人员类别' 
begin
	if exists(select 1 from YY_CQYB_YBSJZD where zdlb = 'MZRYLB' and code = @value and jlzt = 0)
		select "T",name from YY_CQYB_YBSJZD where zdlb = 'MZRYLB' and code = @value and jlzt = 0
	else
		select "T",@value
end
else if @flag = '居民缴费档次' 
begin
	if @value = '1'
		select "T","一档"
	else if @value = '2'
		select "T","二档"
	else
		select "T",@value
end
else if @flag = '参保类别'
begin
	if exists(select 1 from YY_CQYB_YBSJZD where zdlb = 'CBLB' and code = @value and jlzt = 0)
		select "T",name from YY_CQYB_YBSJZD where zdlb = 'CBLB' and code = @value and jlzt = 0
	else
		select "T",@value
end
else if @flag = '参保状态'
begin
	if @value = '1'
		select "T","正常参保"
	else if @value = '2'
		select "T","暂停参保"
	else if @value = '3'
		select "T","终止参保"
	else
		select "T",@value
end
else if @flag = '辅助器具超标审批'
begin
	if @value = '0'
		select "T","不需要审批"
	else if @value = '1'
		select "T","需要审批"
	else
		select "T",@value
end
else if @flag = '可否享受就诊标志'
begin
	if @value = '0'
		select "T","不予享受"
	else if @value = '1'
		select "T","可以享受"
	else
		select "T",@value
end
else if @flag = '并发症标志'
begin
	if @value = '0'
		select "T","无并发症"
	else if @value = '1'
		select "T","有并发症"
	else
		select "T",@value
end
else if @flag = '住院状态'
begin
	if @value = '0'
		select "T","未住院"
	else if @value = '1'
		select "T","在住院"
	else
		select "T",@value
end
else
	select "T",@value

return
GO
