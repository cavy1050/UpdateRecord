if exists(select 1 from sysobjects where name = 'usp_cqyb_checkmedcode')
  drop proc usp_cqyb_checkmedcode
go
Create proc usp_cqyb_checkmedcode
(
	@jsxh				ut_sjh,				--结算序号
	@syxh				ut_syxh,			--首页序号
	@xtbz				ut_bz,				--系统标志0,1门诊2住院
	@cblb				varchar(10)			--参保类别
)
as
/****************************************
[版本号]4.0.0.0.0
[创建时间]2017.03.05
[作者]FerryMan
[版权]Copyright ? 1998-2017卫宁健康科技集团股份有限公司
[描述]校验患者医保代码信息
[功能说明]
	校验患者医保代码信息
[参数说明]
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]
[修改记录]
****************************************/
set nocount on

declare @ybdm		ut_ybdm,			--医保代码
		@cblb_his	varchar(10)			--参保类别

if @xtbz in(0 ,1)
begin
	select @ybdm = ybdm from SF_BRJSK(nolock) where sjh = @jsxh

	select @cblb_his = cblb from YY_YBFLK(nolock) where ybdm = @ybdm

	if @cblb <> ISNULL(@cblb_his,'')
	begin
		select "F","患者当前医保代码不正确，请先进行凭证修改或重新选择医保代码后再收费!"
		return
	end
end
else if @xtbz = 2
begin
	select @ybdm = ybdm from ZY_BRSYK(nolock) where syxh = @syxh

	select @cblb_his = cblb from YY_YBFLK(nolock) where ybdm = @ybdm

	if @cblb <> ISNULL(@cblb_his,'')
	begin
		select "F","患者当前医保代码不正确，请重新选择医保代码后再进行医保登记!"
		return
	end
end

select "T"

return
GO
