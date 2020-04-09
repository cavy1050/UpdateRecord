if exists(select 1 from sysobjects where name = 'usp_cqyb_saveybspinfo')
  drop proc usp_cqyb_saveybspinfo
go
CREATE proc usp_cqyb_saveybspinfo
(
	@jsxh				ut_sjh,				--结算序号
	@syxh				ut_syxh,			--首页序号
	@xtbz				ut_bz,				--系统标志0挂号1收费2住院3医保审核预算
	@cflsh				varchar(20),		--处方流水号
    @splx				ut_bz				--审批类型1高收费审批2血液白蛋白审批

)
as
/****************************************
[版本号]4.0.0.0.0
[创建时间]2017.03.05
[作者]FerryMan
[版权]Copyright ? 1998-2017卫宁健康科技集团股份有限公司
[描述]保存医保未审批项目信息
[功能说明]
	保存医保未审批项目信息
[参数说明]
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]
[修改记录]
****************************************/
set nocount on

IF @xtbz = 1
begin
	update b set ybspbz = @splx from SF_MZCFK a(nolock) inner join SF_CFMXK b(nolock) on a.xh = b.cfxh and b.zxlsh = @cflsh
	where a.jssjh = @jsxh 
	if @@error <> 0 
	begin
		select "F","更新YY_CQYB_ZYFYMXK中ybspbz出错!"
		return;
	end;
end
else if @xtbz in (2,3,4)   
begin
	update YY_CQYB_ZYFYMXK set ybspbz = @splx where syxh = @syxh and jsxh = @jsxh and zxlsh = @cflsh
	if @@error <> 0 
	begin
		select "F","更新YY_CQYB_ZYFYMXK中ybspbz出错!"
		return;
	end;
end

select "T"

return
GO
