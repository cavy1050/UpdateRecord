if exists(select 1 from sysobjects where name = 'usp_cqyb_savecfjsinfo')
  drop proc usp_cqyb_savecfjsinfo
go
CREATE proc usp_cqyb_savecfjsinfo
(
	@jsxh				ut_sjh,				--结算序号
	@syxh				ut_syxh,			--首页序号
	@xtbz				ut_bz,				--系统标志0挂号1收费2住院
    @mxxh				ut_xh12,			--费用明细序号
    @zxlsh				varchar(20),		--交易流水号
    @xmdj				numeric(10,4),		--项目单价
    @spbz				varchar(10),		--审批标记
    @xmje				numeric(10,4),		--项目费用总额
    @xmbz				varchar(10),		--项目等级
    @zfbl				numeric(5,4),		--自付比例
    @bzdj				numeric(10,4),		--标准单价
    @zfje				numeric(10,4),		--自付金额
    @zlje				numeric(10,4)		--自费金额
)
as
/****************************************
[版本号]4.0.0.0.0
[创建时间]2017.03.05
[作者]FerryMan
[版权]Copyright ? 1998-2017卫宁健康科技集团股份有限公司
[描述]保存处方明细上传后医保返回信息
[功能说明]
	保存处方明细上传后医保返回信息
[参数说明]
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]
[修改记录]
****************************************/
set nocount on

if @xtbz = 0  
begin
	update GH_GHMXK set zxlsh = @zxlsh,ybxmdj = @xmdj,ybspbz = @spbz,ybzje = @xmje,sfxmdj = @xmbz,ybzfbl = @zfbl,
		ybbzdj = @bzdj,ybzfje = @zfje,ybzlje = @zlje
	where xh = @mxxh
	if @@error <> 0 
	begin
		select "F","更新GH_GHMXK的医保处方明细信息失败!"
	end
end
else if @xtbz = 1
begin
	update SF_CFMXK set zxlsh = @zxlsh,ybxmdj = @xmdj,ybspbz = @spbz,ybzje = @xmje,sfxmdj = @xmbz,ybzfbl = @zfbl,
		ybbzdj = @bzdj,ybzfje = @zfje,ybzlje = @zlje
	where xh = @mxxh
	if @@error <> 0 
	begin
		select "F","更新SF_CFMXK的医保处方明细信息失败!"
	end
end
else --if @xtbz in (2,3,4)
begin
	update YY_CQYB_ZYFYMXK set zxlsh = @zxlsh,ybxmdj = @xmdj,ybspbz = 0,ybzje = @xmje,sfxmdj = @xmbz,ybzfbl = @zfbl,
		ybbzdj = @bzdj,ybzfje = @zfje,ybzlje = @zlje,ybscbz = 1
	where @syxh = @syxh and jsxh = @jsxh and xh = @mxxh
	if @@error <> 0 
	begin
		select "F","更新YY_CQYB_ZYFYMXK的医保处方明细信息失败!"
	end
	
	update YY_CQYB_NZYFYMXK set zxlsh = @zxlsh,ybxmdj = @xmdj,ybspbz = 0,ybzje = @xmje,sfxmdj = @xmbz,ybzfbl = @zfbl,
		ybbzdj = @bzdj,ybzfje = @zfje,ybzlje = @zlje,ybscbz = 1
	where @syxh = @syxh and jsxh = @jsxh and xh = @mxxh
	if @@error <> 0 
	begin
		select "F","更新YY_CQYB_NZYFYMXK的医保处方明细信息失败!"
	end
end

select "T"
return
GO
