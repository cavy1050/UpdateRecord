ALTER proc usp_zzsf_getcfxx              
 @lb ut_bz ,                 --0����Ϣ1��ϸ��Ϣ                    
 @patid ut_xh12,    --���˱�ʶ                      
 @cflx ut_dm2 = '',    --�������                    
 @sfczyh ut_czyh,             --�շѲ���Ա                    
 @yfdm ut_ksdm = '',                    
 @hjmxxh varchar(255)='' --������ϸ���            
 ,@tjcfbz varchar(2)=0 --��촦����־0����촦����1��촦��                    
as                    
/******************************************                    
   ������ר��                    
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
 select 'F','δ�ҵ��ò��˹Һ���Ϣ�����ȹҺţ�'                    
 return                    
end                      
*/
                   
-------�ñ���usp_sf_sfcl �ıش�����һ�£�ǰ̨ͨ���ñ�̬ƴװusp_sf_sfcl                    
select @hjmxxh=''                     
create table #usp_sf_sfcl                    
(                      
  sflb  smallint,  ---�շ����1=��ͨ��2=����  1                                          
  czksfbz int,       ---��ֵ���շѱ�־�� 0 :���ӳ�ֵ���շ�  ��1 �ӳ�ֵ���շ�2                    
  qrbz  ut_bz,     --ȷ�ϱ�־0=��ͨ��1=����(ҽ���շ���) 3                     
  patid  ut_xh12,  ---����Ψһ��ʶ 4                    
  sjh  ut_sjh,  ---�վݺ� 5                     
  czyh  ut_czyh,  ---����Ա�� 6                     
  ksdm  ut_ksdm,  ---���Ҵ��� 7                    
  ysdm  ut_czyh,  ---ҽ������  8                    
  sfksdm  ut_ksdm,  ---�շѿ��Ҵ��� 9                    
  yfdm  ut_ksdm,  --- ҩ������ 10                    
  sfckdm  ut_dm2,  ---�շѴ��ڴ��� 11                     
  pyckdm  ut_dm2,  ---��ҩ���ڴ���12                     
  fyckdm  ut_dm2,  ---��ҩ���ڴ���13                     
  ybdm  ut_ybdm,  ---ҽ������ 14                    
  cfxh  int,      ---������� 15                     
  hjxh  ut_xh12,  ---������� 16                    
  cflx  ut_bz,  ---�������1:��ҩ����,2:��ҩ����,3:��ҩ����,4:���ƴ��� 17                    
  sycfbz  ut_bz,  ---��Һ������־0:��ͨ������1:��Һ���� 18                    
  tscfbz  ut_bz,  ---���⴦����־0:��ͨ������1:��֢���� 19                     
  dxmdm  ut_kmdm, ---����Ŀ����20                       
  xxmdm  ut_xmdm, ---С��Ŀ���루ҩƷ����21��                       
  idm  ut_xh9,  ---����idm 22                     
  ypdw  ut_unit, ---ҩƷ��λ23                      
  dwxs  ut_dwxs, ---��λϵ�� 24                      
  fysl  ut_sl10, ---��ҩ���� 25                    
  cfts  integer, ---�������� 26                    
  ypdj  ut_money,---ҩƷ���� 27                     
  ghsjh  ut_sjh  null, ---�Һ��վݺ� 28                    
  ghxh  ut_xh12  null ---�Һ���� 29                    
  ,yhdj  ut_money   ---�Żݵ���30                    
  ,ypmc  ut_mc32   ---ҩƷ����31                    
  ,lcxmdm ut_xmdm  ---�ٴ���Ŀ����32                    
  ,hjmxxh ut_xh12  ---������ϸ���33                     
     ,out_hzxm      ut_name                    
  ,out_zje    ut_money                    
     ,out_yfmc   ut_mc64 null                    
 ,ypgg varchar(64) null    
,cardno ut_cardno                    
    ,ybspbz ut_bz                    
 ,shbz1 ut_bz  --��˱�־ //add by yxc for Ƥ�Դ���         
 ,shbz2 ut_bz  --��˱�־                    
 ,shbz3 ut_bz  --��˱�־                    
 ,shbz4 ut_bz  --��˱�־                    
 ,shbz5 ut_bz  --��˱�־     
 ,xssl  ut_sl10  --��ʾ����                    
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
and m.zbybz=0 --zhangwei 2016��12��20�� 11:55:04 �Ա�ҩҲ�շ�����     
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
and m.zbybz=0 --zhangwei 2016��12��20�� 11:55:04 �Ա�ҩҲ�շ�����  
and h.lrrq >=dbo.fun_getyxq(1)                    
union ALL                    
                    
select j.mjzbz,'1' as czksfbz ,'1' as qrbz, @patid,'zzqfsjh' as sjh,@sfczyh,h.ksdm,h.ysdm,'' as sfksdm,                    
        h.yfdm ,'' as sfckdm ,convert(varchar(4),'') as pyckdm, convert(varchar(4),'')  as fyckdm,                    
        j.ybdm,h.xh as cfxh,h.xh as hjxh,h.cflx,h.sycfbz, h.tscfbz,d.dxmdm,c.id,m.cd_idm,                    
  c.xmdw, m.ypxs, m.ypsl *d.xmsl as ypsl,m.cfts,c.xmdj as ypdj,j.sjh,g.xh,m.yhdj as yhdj,----by xdw 20130822 ��������   ----zwb 2014-10-23 ypdj������ʾ����  ---yhw 2014-10-24 ע�͵�һ���� --by ljiamy m.yhdj 201711220                 
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
and m.zbybz=0 --zhangwei 2016��12��20�� 11:55:04 �Ա�ҩҲ�շ�����                 
and h.lrrq >=dbo.fun_getyxq(1)         
--union all                    
end            
else            
begin                    
----by xdw ������첡�����ݵ��� 20131106     --by ljiamy  ���Ӵ�����Ч���ж�        
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
  c.xmdw, m.ypxs, m.ypsl*d.xmsl as ypsl,m.cfts,c.xmdj as ypdj,'' sjh,'1' xh,m.yhdj as yhdj,----by xdw 20130822 �������� --byljiamy ����շ�û���Ż� ԭ��д��0.00                   
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
and m.zbybz=0 --zhangwei 2016��12��20�� 11:55:04 �Ա�ҩҲ�շ�����          
and h.lrrq>@yxrq                
                    
union ALL  ----by xdw �����ٴ���Ŀȡ��Ϊ2�� 2014/2/20                    
                    
select '3' mjzbz,'1' as czksfbz ,'1' as qrbz, @patid,'zzqfsjh' as sjh,@sfczyh,h.ksdm,h.ysdm,'' as sfksdm,                    
        h.yfdm ,'' as sfckdm ,convert(varchar(4),'') as pyckdm, convert(varchar(4),'')  as fyckdm,                    
        j.ybdm,h.xh as cfxh,h.xh as hjxh,h.cflx,h.sycfbz, h.tscfbz,d.dxmdm,c.id,m.cd_idm,                    
  c.xmdw, m.ypxs, m.ypsl*d.xmsl as ypsl,m.cfts,c.xmdj as ypdj,'' sjh,'1' xh,m.yhdj as yhdj,----by xdw 20130822 ��������  --by ljiamy 20171220                  
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
and m.zbybz=0 --zhangwei 2016��12��20�� 11:55:04 �Ա�ҩҲ�շ�����     
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
and m.zbybz=0 --zhangwei 2016��12��20�� 11:55:04 �Ա�ҩҲ�շ�����            
and h.lrrq>@yxrq          
end               
if @@rowcount = 0 or @@error <> 0                     
begin                    
 select 'F','ȡ������Ϣ����'                    
 return                    
end                    
 ---                    
 update #usp_sf_sfcl set yfdm=dxmdm,out_yfmc = b.name                    
 from   #usp_sf_sfcl a,YY_SFDXMK b                    
 where  a.dxmdm=b.id and isnull(a.yfdm,'')=''                    
 --- add by gxs ��������ֱ�Ӹ���Ϊ����Ŀ����                    
if @lb = 0 ---����Ϣ                    
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
 where  shbz1 in(0,2) and shbz2 in(0,2) and  shbz3 in(0,2) and  shbz4 in(0,2) and shbz5 in(0,2,8) ----zwb 2015-4-29 shbz5=8�ļ�¼��ѯ                     
    group by patid,out_hzxm,yfdm,out_yfmc,cardno                    
    order by out_yfmc         
                     
end      
else if @lb = 1 ---��ϸ��Ϣ                    
begin                    
/* select sflb,czksfbz,qrbz,patid,sjh,czyh,ksdm,ysdm,sfksdm,yfdm,sfckdm,pyckdm,                    
    fyckdm,ybdm,cfxh,hjxh,cflx,sycfbz,tscfbz,dxmdm,xxmdm,idm,ypdw,dwxs,fysl,cfts,                    
    convert(varchar(18),ypdj) as ypdj,ghsjh,ghxh,yhdj,ypmc,lcxmdm,hjmxxh,out_hzxm as hzxm,ypgg,cardno,convert(varchar(18),out_zje) as out_zje,ybspbz                    
 from #usp_sf_sfcl                     
 where isnull(yfdm,'')=@yfdm or (isnull(@yfdm,'') = '')*/                    
 select  id as lcxmdm_1,name as lcxmmc_1 into #temp_lcxm from YY_LCSFXMK                    
 if @hjmxxh<>'' --���������ϸ��Ų�Ϊ���������Ż�ȡ��ϸ                    
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
   --a.lcxmdm*=b.lcxmdm_1 and   ----xgq 2018-05-23 �޸���ʾ��������                 
   shbz1 in(0,2) and shbz2 in(0,2) and  shbz3 in(0,2) and  shbz4 in(0,2) and shbz5 in(0,2,8)  ----zwb 2015-4-29 shbz5=8�ļ�¼��ѯ                    
                    
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
   and shbz5 in(0,2,8)  ----zwb 2015-4-29 shbz5=8�ļ�¼��ѯ                       
   --and a.lcxmdm*=b.lcxmdm_1 --xgq 2018-05-23 �޸���ʾ��������                   
   order by hjxh
   --add 'order by hjxh' by winning-dingsong-chongqing on 20200708                  
 end                    
end                    
                    
drop table #usp_sf_sfcl                    
                    
                    
                    



