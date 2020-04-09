if exists(select * from sysobjects where name='usp_cqyb_ddqq_yw_fymxcx')
  drop proc usp_cqyb_ddqq_yw_fymxcx
go

Create procedure usp_cqyb_ddqq_yw_fymxcx             
 @syxh   ut_syxh,  --首页序号              
 @lb   ut_bz=0,  --类别              
 @dxmdm  ut_kmdm=null, --大项目代码              
    @idm        ut_xh9=0,       --药idm              
 @ypdm       ut_xmdm='',  --药品代码              
 @jsxh  ut_xh12=null, --结算序号              
 @cxlb  ut_bz=0              
              
as              
/**********              
[版本号]4.0.0.0.0              
[创建时间]2001.11.21              
[作者]朱伟杰              
[版权] Copyright ? 1998-2001上海金仕达-卫宁医疗信息技术有限公司              
[描述] 住院系统--费用明细查询              
[功能说明]              
 病人费用明细查询(存储过程做优化,分成三个存储过程做,此存储过程只查大项)              
[参数说明]              
 @syxh   首页序号              
 @lb   类别 0=大项费用              
 @dxmdm  ut_kmdm 大项目代码（lb=1时使用）              
    @idm        药idm（lb=2时使用）              
 @ypdm       药品代码（lb=2时使用）              
 @jsxh  结算序号              
 @cxlb  0=所有，1=所有药费，2=所有非药费              
[返回值]              
[结果集、排序]              
 成功：数据集              
 错误："F","错误信息"              
[调用的sp]              
[调用实例]              
[修改历史]              
 yxp 小项修改前后名称显示不一              
 hcy 修改药品的大项代码从药品标志取.              
 2003.10.15 Wang Yi               
  1）返回的自费金额中要扣除分类支付部分              
  2）返回结果集增加分类支付金额，前台通过检查此项金额是否大于0来判断是否是分类支付项目              
 2003.10.24 Wang Yi              
  存储过程做优化,分成三个存储过程做,此存储过程只查大项。              
  为避免修改住院结算模块，接口参数不做改动！！！              
**********/              
set nocount on              
              
declare @patid ut_syxh 
      -- ,@jsxh ut_xh12              
              
select @patid=patid from ZY_BRSYK where syxh=@syxh and brzt not in (9)  ----可以查brzt=8的.            
if @@rowcount=0 or @@error<>0              
begin              
 select "F","该病人不存在！"              
 return              
end              
               
if @lb <> 0               
begin              
 select "F", "传入参数不正确"              
 return              
end              
              
create table #tempbqdx              
(              
    jsxh          ut_xh12           not null, --结算序号              
    lb       ut_bz    not null, --类别              
    dxmdm         ut_kmdm               null, --大项代码              
    dxmmc         ut_mc16              null, --大项名称              
    xmje          ut_money           null, --项目金额              
    zfje          ut_money              null, --自费金额              
    yhje          ut_money              null, --优惠金额              
    yeje          ut_money              null, --婴儿金额              
    kbje as (xmje - zfje),  --可报金额              
    memo    ut_memo    null  --备注              
    ,flzfje  ut_money  null  --分类支付金额,add by Wang Yi, 2003.10.15              
)              
              
              
/*
insert #tempbqdx(jsxh,lb,dxmdm,dxmmc,xmje,zfje,yhje,yeje,flzfje)              
select b.jsxh,0,b.dxmdm,b.dxmmc,b.xmje,b.zfje,b.yhje,b.yeje,b.flzfje              
 from ZY_BRJSK a (nolock),ZY_BRJSMXK b (nolock)--20130530zhyy由历史库的关系修改为视图              
 where a.syxh=@syxh and a.xh=b.jsxh and a.jlzt=0 and b.xmje<>0            
*/


--从费用明细中取费用，合计大项信息，主要由于自费金额

select @jsxh = a.xh from ZY_BRJSK a WHERE a.syxh = @syxh AND a.jlzt = 0

insert #tempbqdx(jsxh,lb,dxmdm,dxmmc,xmje,zfje,yhje,yeje,flzfje) 
SELECT @jsxh jsxh,0,a.dxmdm,b.name dxmmc
	,SUM(a.zje) xmje
	,SUM(CASE WHEN ISNULL(c.ybfydj,3) = 3 THEN a.zje ELSE 0 END) zfje
	,SUM(a.yhje) yhje
	,0 yeje
	,0 flzfje 
FROM VW_BRFYMXK a(NOLOCK),YY_SFDXMK b(NOLOCK),
		 YK_YPCDMLK c(NOLOCK) --LEFT JOIN YPML d(NOLOCK) ON (CASE WHEN ISNULL(c.dydm,'') = '' THEN '197827' ELSE c.dydm END) = d.YPLSH
WHERE a.dxmdm = b.id 
  AND a.idm = c.idm
  AND a.idm <> 0
  AND a.jszt = 0 
  AND a.syxh = @syxh 
GROUP BY a.jsxh,a.dxmdm,b.name

UNION ALL

SELECT @jsxh jsxh,0,a.dxmdm,b.name dxmmc
	,SUM(a.zje) xmje
	,SUM(CASE WHEN ISNULL(c.ybfydj,3) = 3 THEN a.zje ELSE 0 END) zfje
	,SUM(a.yhje) yhje
	,0 yeje
	,0 flzfje 
FROM ZY_BRFYMXK a(NOLOCK),YY_SFDXMK b(NOLOCK),
     YY_SFXXMK c(NOLOCK) --LEFT JOIN ZLXM d(NOLOCK) ON (CASE WHEN ISNULL(c.dydm,'') = '' THEN '67790' ELSE c.dydm END) = d.XMLSH
WHERE a.dxmdm = b.id 
  AND a.ypdm = c.id
  AND a.idm = 0
  AND a.jszt = 0 
  AND a.syxh = @syxh 
GROUP BY a.jsxh,a.dxmdm,b.name


select jsxh, sum(yeje) as yeje              
into #yeje from #tempbqdx where lb=0 group by jsxh              
          
     /*   
insert #tempbqdx(jsxh,lb,dxmdm,dxmmc,xmje,zfje,yhje,yeje,flzfje)              
select a.xh,1,"","总计",a.zje,a.zfyje,a.yhje,b.yeje,a.flzfje              
 from ZY_BRJSK a (nolock),#yeje b (nolock)               
 where a.syxh=@syxh and a.jlzt=0  and a.xh*=b.jsxh  --and a.zje<>0  --hkh on 2003.04.29     
        */
 insert #tempbqdx(jsxh,lb,dxmdm,dxmmc,xmje,zfje,yhje,yeje,flzfje)              
select a.xh,1,"","总计",a.zje,SUM(b.zfje),SUM(b.yhje),SUM(b.yeje),SUM(b.flzfje)              
 from ZY_BRJSK a (nolock),#tempbqdx b (nolock)               
 where a.syxh=@syxh and a.jlzt=0  and a.xh=b.jsxh 
 GROUP BY a.xh,a.zje
              
insert #tempbqdx(jsxh,lb,dxmdm,dxmmc,xmje,zfje,yhje,yeje,flzfje)              
select xh,3,null,null,null,null,null,null,null              
 from ZY_BRJSK (nolock) where syxh=@syxh and jlzt=0              
              
insert #tempbqdx(jsxh,lb,dxmdm,dxmmc,xmje,zfje,yhje,yeje,flzfje)              
select jsxh,2,null,"押金累计",sum(jje-dje),null,null,null,null              
 from ZYB_BRYJK (nolock) where syxh=@syxh and czlb in (0,1,2,3,4,5,6) and               
  jsxh in (select jsxh from #tempbqdx)              
 group by jsxh              
              
select dxmdm "项目代码",dxmmc "项目名称",xmje "项目金额",flzfje "分类支付金额",zfje-flzfje "自费金额",
       0 "可报金额",yhje "减免金额",jsxh "结算序号",yeje "婴儿金额"              
 from #tempbqdx order by jsxh,lb             
return              

GO
