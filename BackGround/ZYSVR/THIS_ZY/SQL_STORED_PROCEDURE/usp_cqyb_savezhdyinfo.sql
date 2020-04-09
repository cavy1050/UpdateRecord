if exists(select 1 from sysobjects where name = 'usp_cqyb_savezhdyinfo')
  drop proc usp_cqyb_savezhdyinfo
go
CREATE proc usp_cqyb_savezhdyinfo
(
	@jsxh				ut_sjh,				--结算序号
	@syxh				ut_syxh=0,			--首页序号
	@xtbz				ut_bz,				--系统标志0挂号1收费2住院
	@czlb				ut_bz,				--操作类别0删除1保存
	@bcdykh				varchar(10)='',		--本次抵用卡号
    @bcdyje				ut_money=0			--本次抵用金额
)
as
/****************************************
[版本号]4.0.0.0.0
[创建时间]2017.03.05
[作者]FerryMan
[版权]Copyright ? 1998-2017卫宁健康科技集团股份有限公司
[描述]保存医保账户抵用信息
[功能说明]
	保存医保账户抵用信息
[参数说明]
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]
[修改记录]
****************************************/
set nocount on

if @xtbz in (0,1)  
begin
	if @czlb = 0
	begin
		delete from YY_CQYB_MZDYJLK where jssjh = @jsxh
		if @@error <> 0 
		begin
			select "F","删除YY_CQYB_MZDYJLK的医保账户抵用信息失败!"
			return
		end
	end
	else if @czlb = 1
	begin
		if exists(select 1 from YY_CQYB_MZDYJLK where jssjh = @jsxh and dykh = @bcdykh)
		begin
			select "F","此笔结算已使用过卡号为【"+@bcdykh+"】的医保卡做过账户冲抵，无法再次使用!"
			return
		end
		
		insert into YY_CQYB_MZDYJLK(jssjh,jzlsh,sbkh,name,sfzh,xzqhbm,cblb,dykh,dyje,jlzt)
		select a.jssjh,a.jzlsh,a.sbkh,b.name,b.sfzh,b.xzqhbm,a.cblb,@bcdykh,@bcdyje,1
		from YY_CQYB_MZJZJLK a(nolock) inner join YY_CQYB_PATINFO b(nolock) on a.sbkh = b.sbkh
		where a.jssjh = @jsxh and a.jlzt = 1
		if @@error <> 0 or @@rowcount = 0
		begin
			select "F","保存门诊账户抵用信息失败!"
			return
		end;
	end
end
else if @xtbz = 2
begin
	if @czlb = 0
	begin
		delete from YY_CQYB_ZYDYJLK where syxh = @syxh and jsxh = @jsxh
		if @@error <> 0 
		begin
			select "F","删除YY_CQYB_ZYDYJLK的医保账户抵用信息失败!"
			return
		end
	end
	else if @czlb = 1
	begin
		if exists(select 1 from YY_CQYB_ZYDYJLK where syxh = @syxh and jsxh = @jsxh and dykh = @bcdykh)
		begin
			select "F","此笔结算已使用过卡号为【"+@bcdykh+"】的医保卡做过账户冲抵，无法再次使用!"
			return
		end
		
		insert into YY_CQYB_ZYDYJLK(jsxh,syxh,jzlsh,sbkh,name,sfzh,xzqhbm,cblb,dykh,dyje,jlzt)
		select @jsxh,a.syxh,a.jzlsh,a.sbkh,b.name,b.sfzh,b.xzqhbm,a.cblb,@bcdykh,@bcdyje,1
		from YY_CQYB_ZYJZJLK a(nolock) inner join YY_CQYB_PATINFO b(nolock) on a.sbkh = b.sbkh
		where a.syxh = @syxh and a.jlzt = 1
		if @@error <> 0 or @@rowcount = 0
		begin
			select "F","保存住院账户抵用信息失败!"
			return
		end;
	end
end

select "T"

return
GO
