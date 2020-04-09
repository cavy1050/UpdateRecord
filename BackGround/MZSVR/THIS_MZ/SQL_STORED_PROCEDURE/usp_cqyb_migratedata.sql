if exists(select 1 from sysobjects where name = 'usp_cqyb_migratedata')
  drop proc usp_cqyb_migratedata
go
CREATE proc usp_cqyb_migratedata
(
	@syxh				ut_syxh,		--��ҳ���
	@jsxh				ut_xh12			--�������
)
as
/****************************************
[�汾��]4.0.0.0.0
[����ʱ��]2017.03.05
[����]FerryMan
[��Ȩ]Copyright ? 1998-2017���������Ƽ����Źɷ����޹�˾
[����]סԺȡ�������ҽ�����ݴ����Ǩ�ƻ��ձ�
[����˵��]
	סԺȡ�������ҽ�����ݴ����Ǩ�ƻ��ձ�
[����˵��]
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��]
[�޸ļ�¼] 
****************************************/
set nocount on 

declare @jsxh_new ut_xh12,@jsxh_old ut_xh12
begin tran 
--20180207 bdd ȡ�����˺�ͬʱ�����м��
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
				select "F","ȡ�����˺�YY_CQYB_ZYJSJLK����ʧ��!"
				return
				end	
	END
end
--סԺȡ����������ݵ����ձ�
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
		select "F","YY_CQYB_NZYFYMXK���ݵ����ձ�ʧ��!"
		return
	end

	delete YY_CQYB_NZYFYMXK where syxh = @syxh
	if @@error<>0
	begin
		rollback tran
		select "F","ɾ��YY_CQYB_NZYFYMXK����ʷ����ʧ��!"
		return
	end
end

commit tran 

update a set jsxh = b.jsxh from YY_CQYB_ZYFYMXK a(nolock) inner join ZY_BRFYMXK b(nolock) on a.syxh = b.syxh and a.xh = b.xh 
where a.syxh = @syxh 
if @@error <> 0 
begin
	select "F","����YY_CQYB_ZYFYMXK��jsxhʧ��!"
	return
end

select "T"

return
GO
