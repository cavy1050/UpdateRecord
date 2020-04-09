if exists(select 1 from sysobjects where name = 'usp_cqyb_migratedata')
  drop proc usp_cqyb_migratedata
go
CREATE proc usp_cqyb_migratedata
(
	@syxh				ut_syxh,		--首页序号
	@jsxh				ut_xh12			--结算序号
)
as
/****************************************
[版本号]4.0.0.0.0
[创建时间]2017.03.05
[作者]FerryMan
[版权]Copyright ? 1998-2017卫宁健康科技集团股份有限公司
[描述]住院取消结算后医保数据从年表迁移回日表
[功能说明]
	住院取消结算后医保数据从年表迁移回日表
[参数说明]
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]
[修改记录] 
****************************************/
set nocount on 

declare @jsxh_new ut_xh12,@jsxh_old ut_xh12
begin tran 
--20180207 bdd 取消结账后同时生成中间表
select @jsxh_new=xh from ZY_BRJSK(nolock) where syxh=@syxh and jlzt=0 and jszt=0 and ybjszt=0 order by xh desc
select @jsxh_old=xh from ZY_BRJSK(nolock) where syxh=@syxh and jlzt=2 and jszt=2 and ybjszt=2 order by xh desc
if isnull(@jsxh_new,0)<>0 and isnull(@jsxh_old,0)<>0
begin
	IF NOT EXISTS(SELECT 1 from  YY_CQYB_ZYJSJLK where syxh = @syxh and jsxh = @jsxh_old and jlzt = 3 )
	BEGIN
		insert into YY_CQYB_ZYJSJLK 
				( jsxh, syxh, sbkh, xzlb, jzlsh, jslb, zhzfbz, zhdybz, jsqzrq, jszzrq, 
				gsrdbh, gsjbbm, cfjslx, sylb, sysj, sybfz, ncbz, rslx,dbtbz, syfwzh, 
				jyjc, jhzh, gzcybz, jlzt, zxlsh, zxjssj, czlsh, zxczsj )
		select @jsxh_new, syxh, sbkh, xzlb, jzlsh, jslb, zhzfbz, zhdybz, jsqzrq, jszzrq,
			   gsrdbh, gsjbbm, cfjslx, sylb, sysj, sybfz, ncbz, rslx, dbtbz, syfwzh, 
			   jyjc, jhzh,gzcybz, 0, '', '', '', '' 
			   from  YY_CQYB_ZYJSJLK 
			   where syxh = @syxh and jsxh = @jsxh_old and jlzt = 3 
			   if @@error<>0
				begin
				rollback tran
				select "F","取消结账后YY_CQYB_ZYJSJLK插入失败!"
				return
				end	
	END
end
--住院取消结算后数据导回日表
if exists(select 1 from YY_CQYB_NZYFYMXK where syxh = @syxh)
begin
	insert YY_CQYB_ZYFYMXK(syxh,jsxh,xh,txh,cfh,cfrq,idm,xmdm,xmmc,xmgg,xmdj,xmsl,xmdw,xmje,ksdm,ysdm,jbr,jzbz,zzfbz,ktsl,
		ktje,spbz,spclbz,ybscbz,zxlsh,ybxmdj,ybspbz,ybzje,sfxmdj,ybzfbl,ybbzdj,ybzfje,ybzlje)
	select syxh,jsxh,xh,txh,cfh,cfrq,idm,xmdm,xmmc,xmgg,xmdj,xmsl,xmdw,xmje,ksdm,ysdm,jbr,jzbz,zzfbz,ktsl,
		ktje,spbz,spclbz,ybscbz,zxlsh,ybxmdj,ybspbz,ybzje,sfxmdj,ybzfbl,ybbzdj,ybzfje,ybzlje
	from YY_CQYB_NZYFYMXK where syxh = @syxh
	if @@error<>0
	begin
		rollback tran
		select "F","YY_CQYB_NZYFYMXK数据导回日表失败!"
		return
	end

	delete YY_CQYB_NZYFYMXK where syxh = @syxh
	if @@error<>0
	begin
		rollback tran
		select "F","删除YY_CQYB_NZYFYMXK的历史数据失败!"
		return
	end
end

commit tran 

update a set jsxh = b.jsxh from YY_CQYB_ZYFYMXK a(nolock) inner join ZY_BRFYMXK b(nolock) on a.syxh = b.syxh and a.xh = b.xh 
where a.syxh = @syxh 
if @@error <> 0 
begin
	select "F","更新YY_CQYB_ZYFYMXK的jsxh失败!"
	return
end

select "T"

return
GO
