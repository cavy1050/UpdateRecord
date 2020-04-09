if exists(select 1 from sysobjects where name='usp_cqyb_ybmrjyk')
  drop proc usp_cqyb_ybmrjyk
GO

CREATE proc usp_cqyb_ybmrjyk
	@cxlb ut_bz,
	@bqdm ut_ksdm,
	@syxh ut_syxh = 0
as
/**********
[�汾��]4.0.0.0.0
[����ʱ��]2002.2.6
[����]
[��Ȩ] Copyright ? 1998-2001�Ϻ����˴�-����ҽ����Ϣ�������޹�˾
[����]ҽ��ÿ���嵥
[����˵��]
	ҽ��ÿ���嵥
[����˵��]
	@cxlb ut_bz 0 ���ݲ�����ѯ 1������ҳ��ѯ 3 ��ѯ����ҽ������
	@bqdm ut_ksdm ��������
	@syxh ut_syxh ��ҳ���
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��]

**********/
set nocount on
declare @now ut_rq16,@fyrq ut_rq8
select @now = convert(char(8),getdate(),112)+convert(char(8),getdate(),8)
select @fyrq = substring(@now,1,8)

	select convert(numeric(12,0),0) xh,a.cardno,a.centerid,b.syxh,b.zje,b.yhje,a.ryrq,a.cqrq,
		a.ybdjrq,a.ybtbrq,convert(money,0) yjlj,0 ybjkid,a.hzxm,a.cwdm
	into #temppat
	from ZY_BRSYK a (nolock),ZY_BRJSK b (nolock)
	where -1=0 and a.brzt in (1,5,6,7) and 
		a.syxh=b.syxh and b.jlzt=0 and b.jszt=0		

	if @cxlb = 0
	begin
		--ѡ���ˣ�������Ժ����
		insert into #temppat(xh,cardno,centerid,syxh,zje,yhje,ryrq,cqrq,ybdjrq,ybtbrq,ybjkid,hzxm,cwdm)
		select b.xh,a.cardno,a.centerid,b.syxh,b.zje,b.yhje,a.ryrq,a.cqrq,isnull(a.ybdjrq,b.ksrq),a.ybtbrq
		       ,(SELECT ybjkid FROM YY_YBFLK WHERE ybdm = a.ybdm) ybjkid,a.hzxm,a.cwdm
		from ZY_BRSYK a (nolock),ZY_BRJSK b (nolock)
		where a.brzt in (1,5,6,7) and a.bqdm = @bqdm and 
			a.syxh=b.syxh and b.jlzt=0 and b.jszt=0	and b.ybjszt not in (2,5)	
			and exists(select 1 from YY_YBFLK where ybdm = a.ybdm AND ybjkid IN ( SELECT config FROM YY_CONFIG WHERE id IN ('GN02','CQ18') ) )-- pzlx in (12))
	end
	else if @cxlb = 1
	begin
		--ȥ��Ĭ�ϵ���;����δ����ļ�¼����Ȼ�߿�ʱ04���׻ᵼ�²��ַ��ò����ϴ�
		delete  from YY_CQYB_ZYJSJLK  where  syxh = @syxh and jlzt in(0) and jslb='10'
		--ѡ���ˣ�������Ժ����
		insert into #temppat(xh,cardno,centerid,syxh,zje,yhje,ryrq,cqrq,ybdjrq,ybtbrq,ybjkid,hzxm,cwdm)
		select b.xh,a.cardno,a.centerid,b.syxh,b.zje,b.yhje,a.ryrq,a.cqrq,isnull(a.ybdjrq,b.ksrq),a.ybtbrq
		       ,(SELECT ybjkid FROM YY_YBFLK WHERE ybdm = a.ybdm) ybjkid,a.hzxm,a.cwdm
		from ZY_BRSYK a (nolock),ZY_BRJSK b (nolock)
		where a.brzt in (1,5,6,7) and a.syxh = @syxh and 
			a.syxh=b.syxh and b.jlzt=0 and b.jszt=0	and b.ybjszt not in (2,5)	
			and exists(select 1 from YY_YBFLK where ybdm = a.ybdm AND ybjkid IN ( SELECT config FROM YY_CONFIG WHERE id IN ('GN02','CQ18') ) )--  pzlx in (12))	
	end
	else if @cxlb = 3
	begin
		--ѡ���ˣ�������Ժ����
		insert into #temppat(xh,cardno,centerid,syxh,zje,yhje,ryrq,cqrq,ybdjrq,ybtbrq,ybjkid,hzxm,cwdm)
		select b.xh,a.cardno,a.centerid,b.syxh,b.zje,b.yhje,a.ryrq,a.cqrq,isnull(a.ybdjrq,b.ksrq),a.ybtbrq
		       ,(SELECT ybjkid FROM YY_YBFLK WHERE ybdm = a.ybdm) ybjkid,a.hzxm,a.cwdm
		from ZY_BRSYK a (nolock),ZY_BRJSK b (nolock)
		where a.brzt in (1,5,6,7) and 
			a.syxh=b.syxh and b.jlzt=0 and b.jszt=0	and b.ybjszt not in (2,5)	
			and exists(select 1 from YY_YBFLK where ybdm = a.ybdm and ybjkid IN ( SELECT config FROM YY_CONFIG WHERE id IN ('GN02','CQ18') ) )-- pzlx in (12))		
	end

	update #temppat set yjlj = b.yjlj
	from #temppat a,(select syxh,isnull(sum(jje-dje),0) yjlj 
						from ZYB_BRYJK c  where exists(select 1 from #temppat where c.syxh=syxh and c.jsxh=xh) group by syxh ) b
	where a.syxh = b.syxh

	insert into YY_YBMRJYK(syxh,jsxh,centerid,fyrq,jlzt,zje,yhje,yjlj)
	select syxh,xh,centerid,@fyrq,0,zje,yhje,yjlj
	from #temppat a
	where not exists(select 1 from YY_YBMRJYK b where a.syxh=b.syxh and a.xh=b.jsxh and b.fyrq=@fyrq)

	update YY_YBMRJYK set zje = b.zje,yhje = b.yhje,yjlj=b.yjlj
	from YY_YBMRJYK a,#temppat b
	where a.syxh=b.syxh and a.jsxh=b.xh and a.fyrq = @fyrq	

	select syxh,xh,centerid, 1 scbz, -- -1 ���ϴ�
			convert(char(8),ybdjrq,112) ksrq,convert(char(8),getdate()+1,112) jsrq,zje,yhje,ybjkid,hzxm,cwdm
	from #temppat

return
GO
