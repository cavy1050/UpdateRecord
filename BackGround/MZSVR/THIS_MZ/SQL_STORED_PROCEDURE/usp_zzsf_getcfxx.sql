ALTER proc usp_zzsf_getcfxx              
 @lb ut_bz ,                 --0主信息1明细信息                    
 @patid ut_xh12,    --病人标识                      
 @cflx ut_dm2 = '',    --处方类别                    
 @sfczyh ut_czyh,             --收费操作员                    
 @yfdm ut_ksdm = '',                    
 @hjmxxh varchar(255)='' --划价明细序号            
 ,@tjcfbz varchar(2)=0 --体检处方标志0非体检处方，1体检处方                    
as                    
/******************************************                    
   自助机专用                    
---------------------------                    
mzzzxt                    
---------------------------                    
exec usp_zzsf_getcfxx "1",32627,"","","2010",'',1         
exec usp_zzsf_getcfxx_ljiamy "1",621406,"","","","","1"                   
exec usp_zzsf_getcfxx "0",96209,"",""                    
select yfdm,* from SF_HJCFK where patid=96209 and jlzt in (0,3,5,8)                     
select * from SF_HJCFMXK where cfxh in ('597899',                    
'597900',                    
'597901','597902')                    
select ldxmzh,* from YY_SFXXMK WHERE id='39310'                    
select * from YY_SFDXMK                    
---------------------------                    
OK                       
---------------------------                    
                    
*******************************************/      

/*
if not exists(select * from SF_BRJSK a(nolock),GH_GHZDK b(nolock)    
 where a.ybjszt=2 and a.jlzt=0 and    
 a.ghsfbz=0 and a.patid =@patid and a.ghxh=b.xh and b.ghrq >=dbo.fun_getyxq(CASE a.mjzbz WHEN 2 THEN 3 ELSE 0 END))                    
begin                    
 select 'F','未找到该病人挂号信息，请先挂号！'                    
 return                    
end                      
*/
                   
-------该表与usp_sf_sfcl 的必传参数一致，前台通过该表动态拼装usp_sf_sfcl                    
select @hjmxxh=''                     
create table #usp_sf_sfcl                    
(                      
  sflb  smallint,  ---收费类别1=普通，2=急诊  1                                          
  czksfbz int,       ---充值卡收费标志， 0 :不从充值卡收费  ，1 从充值卡收费2                    
  qrbz  ut_bz,     --确认标志0=普通，1=记帐(医技收费用) 3                     
  patid  ut_xh12,  ---病人唯一标识 4                    
  sjh  ut_sjh,  ---收据号 5                     
  czyh  ut_czyh,  ---操作员号 6                     
  ksdm  ut_ksdm,  ---科室代码 7                    
  ysdm  ut_czyh,  ---医生代码  8                    
  sfksdm  ut_ksdm,  ---收费科室代码 9                    
  yfdm  ut_ksdm,  --- 药房代码 10                    
  sfckdm  ut_dm2,  ---收费窗口代码 11                     
  pyckdm  ut_dm2,  ---配药窗口代码12                     
  fyckdm  ut_dm2,  ---发药窗口代码13                     
  ybdm  ut_ybdm,  ---医保代码 14                    
  cfxh  int,      ---处方序号 15                     
  hjxh  ut_xh12,  ---划价序号 16                    
  cflx  ut_bz,  ---处方类别1:西药处方,2:中药处方,3:草药处方,4:治疗处方 17                    
  sycfbz  ut_bz,  ---输液处方标志0:普通处方，1:输液处方 18                    
  tscfbz  ut_bz,  ---特殊处方标志0:普通处方，1:尿毒症处方 19                     
  dxmdm  ut_kmdm, ---大项目代码20                       
  xxmdm  ut_xmdm, ---小项目代码（药品代码21）                       
  idm  ut_xh9,  ---产地idm 22                     
  ypdw  ut_unit, ---药品单位23                      
  dwxs  ut_dwxs, ---单位系数 24                      
  fysl  ut_sl10, ---发药数量 25                    
  cfts  integer, ---处方贴数 26                    
  ypdj  ut_money,---药品单价 27                     
  ghsjh  ut_sjh  null, ---挂号收据号 28                    
  ghxh  ut_xh12  null ---挂号序号 29                    
  ,yhdj  ut_money   ---优惠单价30                    
  ,ypmc  ut_mc32   ---药品名称31                    
  ,lcxmdm ut_xmdm  ---临床项目代码32                    
  ,hjmxxh ut_xh12  ---划价明细序号33                     
     ,out_hzxm      ut_name                    
  ,out_zje    ut_money                    
     ,out_yfmc   ut_mc64 null                    
 ,ypgg varchar(64) null    
,cardno ut_cardno                    
    ,ybspbz ut_bz                    
 ,shbz1 ut_bz  --审核标志 //add by yxc for 皮试处方         
 ,shbz2 ut_bz  --审核标志                    
 ,shbz3 ut_bz  --审核标志                    
 ,shbz4 ut_bz  --审核标志                    
 ,shbz5 ut_bz  --审核标志     
 ,xssl  ut_sl10  --显示数量                    
)                    
if @tjcfbz<>'1'            
begin            
insert into #usp_sf_sfcl(sflb,czksfbz,qrbz,patid,sjh,czyh,ksdm,ysdm,sfksdm,                    
       yfdm,sfckdm,pyckdm,fyckdm,                    
       ybdm,cfxh,hjxh,cflx,sycfbz,tscfbz,dxmdm,xxmdm,idm,                    
       ypdw,dwxs,fysl,cfts,ypdj,ghsjh,ghxh,yhdj,                    
                            ypmc,lcxmdm,hjmxxh,out_hzxm,out_zje,ypgg,cardno,ybspbz,                    
                            shbz1, shbz2, shbz3, shbz4, shbz5,xssl)                     
select j.mjzbz,'1' as czksfbz ,'1' as qrbz, @patid,'zzqfsjh' as sjh,@sfczyh,h.ksdm,h.ysdm,''as sfksdm,                    
        h.yfdm ,'' as sfckdm ,convert(varchar(4),'') as pyckdm, convert(varchar(4),'')  as fyckdm,                    
        j.ybdm,h.xh as cfxh,h.xh as hjxh,h.cflx,h.sycfbz, h.tscfbz,m.dxmdm,m.ypdm,m.cd_idm,                    
  m.ypdw, m.ypxs, m.ypsl/m.ypxs as ypsl,m.cfts,m.ylsj*m.ypxs/m.ykxs as ypdj,j.sjh,g.xh,m.yhdj,--gxs b.ylsj*b.dwxs/b.ykxs                    
        m.ypmc,m.lcxmdm,m.xh as hjmxxh,h.hzxm,m.ylsj*m.ypsl*m.cfts/m.ykxs,c.ypgg,j.cardno,m.ybspbz                    
  ,h.shbz1,h.shbz2,h.shbz3,h.shbz4,h.shbz5                    
  , m.ypsl/m.ypxs as xssl                    
from SF_HJCFK h, GH_GHZDK g (nolock) , YY_KSBMK k(nolock) , SF_BRJSK j(nolock),                     
      SF_HJCFMXK m (nolock),YK_YPCDMLK c (nolock)                    
where h.ghxh=g.xh and h.ksdm=k.id and h.patid =g.patid                    
and g.jssjh=j.sjh and j.ghsfbz=0 and h.xh =m.cfxh and m.cd_idm > 0 and m.cd_idm =c.idm and m.lcxmdm = 0                    
and h.jlzt in (0,3,5,8) and h.patid = @patid                    
and h.cflx<>'6'                    
and m.zbybz=0 --zhangwei 2016年12月20日 11:55:04 自备药也收费问题     
and h.lrrq >=dbo.fun_getyxq(1)  
union ALL                    
                    
select j.mjzbz,'1' as czksfbz ,'1' as qrbz, @patid,'zzqfsjh' as sjh,@sfczyh,h.ksdm,h.ysdm,'' as sfksdm,                    
        h.yfdm ,'' as sfckdm ,convert(varchar(4),'') as pyckdm, convert(varchar(4),'')  as fyckdm,                    
        j.ybdm,h.xh as cfxh,h.xh as hjxh,h.cflx,h.sycfbz, h.tscfbz,m.dxmdm,m.ypdm,m.cd_idm,                    
  m.ypdw, m.ypxs, m.ypsl/m.ypxs as ypsl,m.cfts,m.ylsj/m.ypxs as ypdj,j.sjh,g.xh,m.yhdj,                    
       m.ypmc,m.lcxmdm,m.xh as hjmxxh,h.hzxm,m.ylsj*m.ypsl*m.cfts/m.ykxs,c.xmgg,j.cardno,m.ybspbz                    
  ,h.shbz1,h.shbz2,h.shbz3,h.shbz4,h.shbz5                    
  ,m.ypsl/m.ypxs as xssl                    
from SF_HJCFK h, GH_GHZDK g (nolock) , YY_KSBMK k(nolock) , SF_BRJSK j(nolock),                     
   SF_HJCFMXK m (nolock),YY_SFXXMK c (nolock)                    
where h.ghxh=g.xh and h.ksdm=k.id and h.patid =g.patid                    
and g.jssjh=j.sjh and j.ghsfbz=0 and h.xh =m.cfxh and m.cd_idm = 0 and m.ypdm =c.id and m.lcxmdm = 0                    
and h.jlzt in (0,3,5,8) and h.patid = @patid                    
and h.cflx<>'6'              
and m.zbybz=0 --zhangwei 2016年12月20日 11:55:04 自备药也收费问题  
and h.lrrq >=dbo.fun_getyxq(1)                    
union ALL                    
                    
select j.mjzbz,'1' as czksfbz ,'1' as qrbz, @patid,'zzqfsjh' as sjh,@sfczyh,h.ksdm,h.ysdm,'' as sfksdm,                    
        h.yfdm ,'' as sfckdm ,convert(varchar(4),'') as pyckdm, convert(varchar(4),'')  as fyckdm,                    
        j.ybdm,h.xh as cfxh,h.xh as hjxh,h.cflx,h.sycfbz, h.tscfbz,d.dxmdm,c.id,m.cd_idm,                    
  c.xmdw, m.ypxs, m.ypsl *d.xmsl as ypsl,m.cfts,c.xmdj as ypdj,j.sjh,g.xh,m.yhdj as yhdj,----by xdw 20130822 更新数量   ----zwb 2014-10-23 ypdj单价显示不对  ---yhw 2014-10-24 注释掉一部分 --by ljiamy m.yhdj 201711220                 
        c.name,m.lcxmdm,m.xh as hjmxxh,h.hzxm,c.xmdj*m.ypsl*d.xmsl,c.xmgg,j.cardno,m.ybspbz                    
  ,h.shbz1,h.shbz2,h.shbz3,h.shbz4,h.shbz5                    
  , m.ypsl as xssl                    
from SF_HJCFK h, GH_GHZDK g (nolock) , YY_KSBMK k(nolock) , SF_BRJSK j(nolock),                     
      SF_HJCFMXK m (nolock),YY_SFXXMK c (nolock),YY_LCSFXMDYK d (nolock),YY_LCSFXMK l(nolock)                    
where h.ghxh=g.xh and h.ksdm=k.id and h.patid =g.patid                    
and g.jssjh=j.sjh and j.ghsfbz=0 and h.xh =m.cfxh and m.cd_idm = 0  and m.lcxmdm > 0                    
and d.lcxmdm=m.lcxmdm and d.xmdm=c.id and d.lcxmdm=l.id                     
and h.jlzt in (0,3,5,8) and h.patid = @patid                    
and h.cflx<>'6'                
and m.zbybz=0 --zhangwei 2016年12月20日 11:55:04 自备药也收费问题                 
and h.lrrq >=dbo.fun_getyxq(1)         
--union all                    
end            
else            
begin                    
----by xdw 增加体检病人数据调阅 20131106     --by ljiamy  增加处方有效期判断        
declare @yxrq ut_rq8='',@yxrqq varchar(10)=''        
select @yxrqq=CONVERT(varchar(10),GETDATE()-1,120)        
select @yxrq=SUBSTRING(@yxrqq,1,4)+SUBSTRING(@yxrqq,6,2)+SUBSTRING(@yxrqq,9,2)        
        
insert into #usp_sf_sfcl(sflb,czksfbz,qrbz,patid,sjh,czyh,ksdm,ysdm,sfksdm,                    
       yfdm,sfckdm,pyckdm,fyckdm,         
       ybdm,cfxh,hjxh,cflx,sycfbz,tscfbz,dxmdm,xxmdm,idm,                    
       ypdw,dwxs,fysl,cfts,ypdj,ghsjh,ghxh,yhdj,                    
                            ypmc,lcxmdm,hjmxxh,out_hzxm,out_zje,ypgg,cardno,ybspbz,                    
                            shbz1, shbz2, shbz3, shbz4, shbz5,xssl)                     
select '3' mjzbz,'1' as czksfbz ,'1' as qrbz, @patid,'zzqfsjh' as sjh,@sfczyh,h.ksdm,h.ysdm,'' as sfksdm,                    
        h.yfdm ,'' as sfckdm ,convert(varchar(4),'') as pyckdm, convert(varchar(4),'')  as fyckdm,                    
        j.ybdm,h.xh as cfxh,h.xh as hjxh,h.cflx,h.sycfbz, h.tscfbz,d.dxmdm,c.id,m.cd_idm,                    
  c.xmdw, m.ypxs, m.ypsl*d.xmsl as ypsl,m.cfts,c.xmdj as ypdj,'' sjh,'1' xh,m.yhdj as yhdj,----by xdw 20130822 更新数量 --byljiamy 体检收费没走优惠 原来写死0.00                   
        c.name,m.lcxmdm,m.xh as hjmxxh,h.hzxm,c.xmdj*m.ypsl,c.xmgg, j.cardno,m.ybspbz                    
  ,h.shbz1,h.shbz2,h.shbz3,h.shbz4,h.shbz5                    
  , m.ypsl as xssl                    
from SF_HJCFK h, YY_KSBMK k(nolock), SF_HJCFMXK m (nolock),YY_SFXXMK c (nolock),YY_LCSFXMDYK d (nolock),YY_LCSFXMK l(nolock),                    
SF_BRXXK j(nolock)                    
where h.ksdm=k.id                     
and j.patid=h.patid                    
and h.xh =m.cfxh                     
and m.cd_idm = 0                      
and m.lcxmdm > 0                    
and d.lcxmdm=m.lcxmdm                     
and d.xmdm=c.id                     
and d.lcxmdm=l.id                     
and c.id=m.ypdm ---by xdw 20131107                    
and h.jlzt in (0,3,5,8)                     
and h.patid = @patid                    
and h.cflx='6'                    
and m.dxmdm='07'                
and m.zbybz=0 --zhangwei 2016年12月20日 11:55:04 自备药也收费问题          
and h.lrrq>@yxrq                
                    
union ALL  ----by xdw 增加临床项目取数为2倍 2014/2/20                    
                    
select '3' mjzbz,'1' as czksfbz ,'1' as qrbz, @patid,'zzqfsjh' as sjh,@sfczyh,h.ksdm,h.ysdm,'' as sfksdm,                    
        h.yfdm ,'' as sfckdm ,convert(varchar(4),'') as pyckdm, convert(varchar(4),'')  as fyckdm,                    
        j.ybdm,h.xh as cfxh,h.xh as hjxh,h.cflx,h.sycfbz, h.tscfbz,d.dxmdm,c.id,m.cd_idm,                    
  c.xmdw, m.ypxs, m.ypsl*d.xmsl as ypsl,m.cfts,c.xmdj as ypdj,'' sjh,'1' xh,m.yhdj as yhdj,----by xdw 20130822 更新数量  --by ljiamy 20171220                  
        c.name,m.lcxmdm,m.xh as hjmxxh,h.hzxm,c.xmdj*m.ypsl*d.xmsl,c.xmgg, j.cardno,m.ybspbz                    
  ,h.shbz1,h.shbz2,h.shbz3,h.shbz4,h.shbz5                    
  , m.ypsl as xssl                    
from SF_HJCFK h, YY_KSBMK k(nolock), SF_HJCFMXK m (nolock),YY_SFXXMK c (nolock),YY_LCSFXMDYK d (nolock),YY_LCSFXMK l(nolock),                    
SF_BRXXK j(nolock)                    
where h.ksdm=k.id                     
and j.patid=h.patid                    
and h.xh =m.cfxh                     
and m.cd_idm = 0                      
and m.lcxmdm > 0                    
and d.lcxmdm=m.lcxmdm                     
and d.xmdm=c.id                     
and d.lcxmdm=l.id                   
and c.id=m.ypdm ---by xdw 20131107                    
and h.jlzt in (0,3,5,8)                     
and h.patid = @patid                    
and h.cflx='6'                    
and m.dxmdm<>'07'                    
and m.zbybz=0 --zhangwei 2016年12月20日 11:55:04 自备药也收费问题     
and h.lrrq >=dbo.fun_getyxq(1)               
union ALL                    
select '3' mjzbz,'1' as czksfbz ,'1' as qrbz, @patid,'zzqfsjh' as sjh,@sfczyh,h.ksdm,h.ysdm,'' as sfksdm,                    
        h.yfdm ,'' as sfckdm ,convert(varchar(4),'') as pyckdm, convert(varchar(4),'')  as fyckdm,                    
        j.ybdm,h.xh as cfxh,h.xh as hjxh,h.cflx,h.sycfbz, h.tscfbz,m.dxmdm,m.ypdm,m.cd_idm,                    
  m.ypdw, m.ypxs, m.ypsl/m.ypxs as ypsl,m.cfts,m.ylsj/m.ypxs as ypdj,'' sjh,'0' xh,m.yhdj,                    
       m.ypmc,m.lcxmdm,m.xh as hjmxxh,h.hzxm,m.ylsj*m.ypsl*m.cfts/m.ykxs,c.xmgg,j.cardno,m.ybspbz                    
  ,h.shbz1,h.shbz2,h.shbz3,h.shbz4,h.shbz5                    
  ,m.ypsl/m.ypxs as xssl                    
from SF_HJCFK h,YY_KSBMK k(nolock) ,                    
   SF_HJCFMXK m (nolock),YY_SFXXMK c (nolock),SF_BRXXK j(nolock)                    
where  h.ksdm=k.id                     
and j.patid=h.patid                    
and h.xh =m.cfxh         
and m.cd_idm = 0                     
and m.ypdm =c.id                     
and m.lcxmdm = 0                    
and h.jlzt in (0,3,5,8)                     
and h.patid = @patid                    
and h.cflx='6'                    
and m.zbybz=0 --zhangwei 2016年12月20日 11:55:04 自备药也收费问题            
and h.lrrq>@yxrq          
end               
if @@rowcount = 0 or @@error <> 0                     
begin                    
 select 'F','取处方信息出错！'                    
 return                    
end                    
 ---                    
 update #usp_sf_sfcl set yfdm=dxmdm,out_yfmc = b.name                    
 from   #usp_sf_sfcl a,YY_SFDXMK b                    
 where  a.dxmdm=b.id and isnull(a.yfdm,'')=''                    
 --- add by gxs 联动材料直接更新为大项目代码                    
if @lb = 0 ---主信息                    
begin                    
 declare @cfsl int,                    
 @zhye ut_money                    
 ---select @cfsl = count(distinct cfxh) from #usp_sf_sfcl                    
                    
    update #usp_sf_sfcl set out_yfmc = b.name                     
 from #usp_sf_sfcl a,YY_KSBMK b                    
 where a.yfdm = b.id                    
                    
    select @zhye = yjye from YY_JZBRK where patid = @patid        
                       
 select patid,out_hzxm as hzxm,yfdm,out_yfmc as yfmc,                    
         count(distinct cfxh) as cfsl,sum(round(out_zje,2)) as cfje ,cardno,@zhye as zhye                    
 from #usp_sf_sfcl                    
 where  shbz1 in(0,2) and shbz2 in(0,2) and  shbz3 in(0,2) and  shbz4 in(0,2) and shbz5 in(0,2,8) ----zwb 2015-4-29 shbz5=8的记录查询                     
    group by patid,out_hzxm,yfdm,out_yfmc,cardno                    
    order by out_yfmc         
                     
end      
else if @lb = 1 ---明细信息                    
begin                    
/* select sflb,czksfbz,qrbz,patid,sjh,czyh,ksdm,ysdm,sfksdm,yfdm,sfckdm,pyckdm,                    
    fyckdm,ybdm,cfxh,hjxh,cflx,sycfbz,tscfbz,dxmdm,xxmdm,idm,ypdw,dwxs,fysl,cfts,                    
    convert(varchar(18),ypdj) as ypdj,ghsjh,ghxh,yhdj,ypmc,lcxmdm,hjmxxh,out_hzxm as hzxm,ypgg,cardno,convert(varchar(18),out_zje) as out_zje,ybspbz                    
 from #usp_sf_sfcl                     
 where isnull(yfdm,'')=@yfdm or (isnull(@yfdm,'') = '')*/                    
 select  id as lcxmdm_1,name as lcxmmc_1 into #temp_lcxm from YY_LCSFXMK                    
 if @hjmxxh<>'' --如果划价明细序号不为空则根据序号获取明细                    
 begin                    
  select sflb,czksfbz,qrbz,patid,sjh,czyh,ksdm,c.name ksmc,ysdm,sfksdm,yfdm,sfckdm,pyckdm,                    
   fyckdm,ybdm,cfxh,hjxh,cflx,sycfbz,tscfbz,dxmdm,xxmdm,idm,ypdw,dwxs,fysl,cfts,                    
   convert(varchar(18),ypdj) as ypdj,ghsjh,ghxh,isnull(yhdj,0) as yhdj,ypmc,lcxmdm,hjmxxh,out_hzxm as hzxm,ypgg,cardno,                    
   convert(varchar(18),out_zje) as out_zje,ybspbz,b.lcxmmc_1 as lcxmmc,a.xssl                    
   into #usp_sf_sfcl_temp                    
   from #usp_sf_sfcl a      
   left join #temp_lcxm b on a.lcxmdm=b.lcxmdm_1        
   left join YY_KSBMK c on a.ksdm=c.id                         
   where       
   --a.lcxmdm*=b.lcxmdm_1 and   ----xgq 2018-05-23 修改显示科室名称                 
   shbz1 in(0,2) and shbz2 in(0,2) and  shbz3 in(0,2) and  shbz4 in(0,2) and shbz5 in(0,2,8)  ----zwb 2015-4-29 shbz5=8的记录查询                    
                    
   AND( isnull(yfdm,'')=@yfdm or (isnull(@yfdm,'') = ''))                    
  exec('select * from  #usp_sf_sfcl_temp  where hjmxxh in ('+@hjmxxh+') order by hjxh' ) 
  --add 'order by hjxh' by winning-dingsong-chongqing on 20200708                    
 end                    
 else                    
 begin                    
  select sflb,czksfbz,qrbz,patid,sjh,czyh,ksdm,c.name ksmc,ysdm,sfksdm,yfdm,sfckdm,pyckdm,                    
  fyckdm,ybdm,cfxh,hjxh,cflx,sycfbz,tscfbz,dxmdm,xxmdm,idm,ypdw,dwxs,fysl,cfts,                    
  convert(varchar(18),ypdj) as ypdj,ghsjh,ghxh,isnull(yhdj,0) as yhdj,ypmc,lcxmdm,hjmxxh,out_hzxm as hzxm,ypgg,                    
  cardno,convert(varchar(18),out_zje) as out_zje,ybspbz,b.lcxmmc_1 as lcxmmc,a.xssl                    
  from #usp_sf_sfcl  a      
  left join #temp_lcxm b on a.lcxmdm=b.lcxmdm_1      
  left join YY_KSBMK c on a.ksdm=c.id          
  where (isnull(yfdm,'')=@yfdm or (isnull(@yfdm,'') = ''))                    
   and  shbz1 in(0,2)      
   and shbz2 in(0,2)       
   and  shbz3 in(0,2)       
   and  shbz4 in(0,2)       
   and shbz5 in(0,2,8)  ----zwb 2015-4-29 shbz5=8的记录查询                       
   --and a.lcxmdm*=b.lcxmdm_1 --xgq 2018-05-23 修改显示科室名称                   
   order by hjxh
   --add 'order by hjxh' by winning-dingsong-chongqing on 20200708                  
 end                    
end                    
                    
drop table #usp_sf_sfcl                    
                    
                    
                    



