if exists(select 1 from sysobjects where name='usp_sf_sfxmcx_bygh' and type='P')
	drop proc usp_sf_sfxmcx_bygh
go 
create proc usp_sf_sfxmcx_bygh  
  @patid  ut_xh12,  
  @ghxh ut_xh12,
  @cxlb VARCHAR(3)='1'  
as--集104221 2011-05-09 14:32:32 4.0标准版 测试环境搭建93008  
/**********  
[版本号]4.0.0.0.0  
[创建时间]2009.05.10  
[作者]xxl  
[版权] Copyright ? 1998-2001上海金仕达-卫宁医疗信息技术有限公司  
[描述] 门诊系统--  
[功能说明]  
 项目确认  
[参数说明]  
@lb     ut_bz,    --0根据sjh获取费用信息1根据patid获取费用信息2获取确认明细  
@patid  ut_xh12=0,  
@sjh    ut_sjh='',      
@qrxh   ut_xh12=0,     --确认序号  
@ksrq   ut_rq8='',     --过滤开始时间  
@jsrq   ut_rq8='',     --过滤结束时间  
@yqr    ut_bz=0        --是否显示已确认完，默认为不显示  
[返回值]  
[结果集、排序]  
 成功："T"  
 错误："F","错误信息"  
[调用的sp]  
   usp_sf_sfxmcx_bygh 9763,11442,'2'
   usp_sf_sfxmcx_bygh 4610,11279,'2'
   
[调用实例]  
*****/  
set nocount on  

IF @cxlb = '1'
BEGIN
    select sjh,sfrq into #sjh from VW_MZBRJSK(nolock) 
	where patid=@patid and ghxh=@ghxh and ghsfbz=1 and jlzt=0

	select c.ypdm '药品编码',c.ypmc '药品名称',ROUND(c.ypsl/c.dwxs,2) '药品数量',c.ypdw '单位',
	  substring(a.sfrq,1,4)+'-'+substring(a.sfrq,5,2)+'-'+substring(a.sfrq,7,2)+ ' ' + substring(a.sfrq,9,8) '收费日期'  
	from #sjh a,VW_MZCFK b(nolock),VW_MZCFMXK c(nolock)
	where a.sjh=b.jssjh and b.xh=c.cfxh and b.jlzt=0
END
ELSE IF @cxlb = '2' 
BEGIN
    select sjh,sfrq into #sjh2 from VW_MZBRJSK(nolock) 
	where patid=@patid and ghxh=@ghxh and ghsfbz=1 and ybjszt = 2

    select b.xh AS mxxh,b.cfxh,b.ypdm,b.ypmc,ROUND(b.ypsl/b.ypxs,2) ypsl,b.ypdw
	into #hjcfk 
	from VW_MZHJCFK a(nolock) ,VW_MZHJCFMXK b(NOLOCK) 
	where a.xh = b.cfxh and patid=@patid and ghxh=@ghxh

	select b.hjxh,c.hjmxxh,b.jlzt,a.sfrq
	into #mzcfk 
	from #sjh2 a,VW_MZCFK b(nolock),VW_MZCFMXK c(nolock)
	where a.sjh=b.jssjh and b.xh=c.cfxh and b.jlzt IN (0,1)

	select a.ypdm '药品编码',a.ypmc '药品名称',CONVERT(DECIMAL(13,2),a.ypsl) '药品数量',a.ypdw '单位',
			SUBSTRING(b.sfrq,1,4)+'-'+substring(b.sfrq,5,2)+'-'+substring(b.sfrq,7,2)+ ' ' + substring(b.sfrq,9,8) '收费日期',
			CASE WHEN b.jlzt IS NULL THEN '未收费' WHEN b.jlzt = 0 THEN '已收费' WHEN b.jlzt = 1 THEN '已退费' ELSE '' end '收费标志'
	FROM #hjcfk a LEFT JOIN #mzcfk b ON a.cfxh = b.hjxh AND a.mxxh = b.hjmxxh
END

return
go