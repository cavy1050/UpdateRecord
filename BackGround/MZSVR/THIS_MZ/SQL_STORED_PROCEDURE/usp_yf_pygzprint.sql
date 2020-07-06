alter procedure usp_yf_pygzprint    
 @jssjh   ut_lsh,      --结算收据号    
 @cfxhgroup  varchar(255),     --处方序号组   
 @pqbz  ut_bz=0,      --瓶签标志0 否 1 是,2药袋  
 @cxbz  ut_bz=0,   --查询标志(0日表,1年表)  
 @dybz       ut_bz=0 ,      --打印标志（0自动打印，1补打）  
 @dyfileterbz ut_bz=0 ,          --打印过滤标志 0 不过滤 1 过滤参数3336设置用法 2 过滤3336 没有设置的用法  
 @ydxhlist varchar(8000)='',      --药袋序号集合  
    @czyh ut_czyh ='00'  
as --集439554 2018-10-29 19:59:36 4.0标准版  
/**********    
[版本号]4.0.0.0.0    
[创建时间]2004.10.29    
[作者] 苏志军    
[版权] Copyright ? 2004-2008上海金仕达-卫宁软件股份有限公司  
[描述] 门诊系统--配药打印处方    
[功能说明]    
 配药打印处方     
[参数说明]    
  
[返回值]    
[结果集、排序]    
[调用的sp]    
[调用实例]    
  select top 5 * from SF_MZCFK where pybz=1 and hjxh<>0 and pyrq like '2007%' order by pyrq desc  
  exec usp_yf_pygzprint  "20150915000014","122444"  
  exec usp_yf_pygzprint  "200704128590007  ","14383"  
  exec usp_yf_pygzprint  "20081216000016","9767"--【Clientdataset】  
[修改记录]    
 Modify By : Koala In : 2004-05-10  For : 药品名称前增加成组标志(针对医生站划价信息)    
 Modify By : Koala In : 2004-06-07  For : 增加配药窗口代码的传出    
 Modify By : Koala In : 2004-06-08  For : 将剂量、剂量单位、频次、天数、用法信息分列显示，方便用法自由组合    
    modify by : zyp     in : 2005-03-04     for : 加厂家,加别名        
    yxp 2005-4-27 传特殊标志，加收代煎费标志YK_TSBZK s (nolock)    
    modify by : yxp     in : 2005-4-28 For xdfxh,xdfmc应该传出字段名  
 modify by gzy at 20050520 传出药房发药序号  
 modify by yxp 20050531 成组的药品需要打印在一起  
 modify by gzy at 20050619 修改调出修改发票再打印时没有用法的BUG  
 yxp 2005-8-26 增加参数瓶签标志@pqbz =0 的传入，处理一个药品打印一张瓶签的功能  
   将#pyprinttemp改为@tablename=#py+@jssjh  
 yxp 2005-8-26 修改配药打印，标识出退费处方，退费处方的区分是SF_MZCFK中txh不为0的记录  
 xujian 2005-09-20 增加‘配药打印的用法集合’‘配药瓶签打印的用法集合’  
 yxp 2005-10-29 查询明细不用再判断参数H090，直接根据hjmxxh判断  
 yxp 2005-11-1 关联SF_BRJSK时，需要增加ybjszt=2的条件  
 yxp 2005-11-11 传出ypjl时，原来关联不到HJK时写成了round(a.ypsl/a.dwxs,2) as ypjl应该是 null as ypjl  
 yxp 2006-3-8 处方的查询条件中增加‘and isnull(ejygbz,0)=0’  
 mly 2006-03-21 修改急诊病人或者家床病人不结算配药显示不出的ＢＵＧ　((a.ghsfbz=1 and a.ybjszt=2) or a.ghsfbz=2)  
 yxp 2006-6-8 开关用错了，应该是3096，而不是3092 配药时同一病人的多个挂号的处方是否一起打印  
 yxp 2006-7-3 用法集合长度扩大，能支持100个用法  
 yxp 2006-7-5 去掉开关3079的功能，原来为杭三制作，功能多余，实现无用处  
 yxp 2006-7-13 使用@strwhere来合并@arpy不同情况下的sql语句  
 yxp 2006-8-29 程序简化，速度优化:手工处方按hjxh=0来判断;ypyf1,ypyf2是空字段，删除;建临时表存处方明细与药品信息  
  增加传出参数cfk_yflsh：取自SF_MZCFK中，以和JSK中药房流水号区分  
 yxp 2006-9-5 手工处方应该按hjxh<=0来判断  
 yxp 2006-9-18 单价应该传出为四位小数  
 yxp 2006-9-27 天数，如果是电子处方，应该取HJCFMXK.ts；否则固定为1  
 yxp 2006-10-11 合并省立现场修改功能：增加sfdr'是否当日补打'(如是当日处方则传出空，否则传出‘往日处方‘字样),ypgg2‘药品规格*前的内容’  
 yxp 2007-05-14 del SF_MZCFK.jlzt=0的条件，以免开关3096设置为是时，病人部分退费后，没有将红冲记录和部分收的记录分别打印出来  
 yxp 2007-6-18 将全局临时表改为普通临时表，解决金山医院配药打印报错的问题;null as ypjl改为 0 as ypjl以免报错  
      增加“处方嘱托”，“处方用法”，“处方用法名称”的传出，传出字段分别为cf_yznr,cf_ypyf,cf_ypyfmc  
    xiaoyan 2007-6-20 打印的时候增加转盘位置号字段(zpwzbh)   
 xiaoyan 2007-7-6 将3016参数禁用，放到药房代码库中设置。  
 xiaoyan 2007-7-9 如果fyckmc 为空的话，系统不让把数据插入临时表中，所以改为 isnull(d.name , " ")  
 xiaoyan 2007-7-19 传出YK_YPGGMLK表的ypmc字段  
 xiaoyan 2007-7-28 漏掉 n.ypyf=q.id   
    yxp 2007-10-31 松江区公立医院药品零差率HIS实现:增加SF_CFMXK.yylsj的传出  
    xiaoyan 2007-11-23 增加dzyzimage字段  
 yxp 2007-10-31 松江区公立医院药品零差率门诊药房修改：yylsj不再使用，现取SF_CFMXK.lcjsdj'零差结算单价'，打印时传出lcjsdj，原来的修改作废  
        mly 2008-04-14 增加SF_HJCFMXK.皮试标志的传出  
 jianglong 2008-05-07 公费标志,公费名称,医保名称的传出  
 jl 2008-12-15 福州配药打印诊断代码的传出  
        xjj     2008-12-16     增加出访类型传出  
    jl 2009-07-15 增加分日表查询和年表查询  
    JL 2009-07-16 如果是补打增加配药人的传出  
    jl 2009-12-02 传出SF_MZCFK.txh  
    jl  2009-12-31  传出jssjh  
    xwm 2010-08-16  传出草药处方小包装情况，显示不显示由报表模版来处理  
    xjj 2011-6-1  传出是否自包标志  
    grj 2011-12-14 增加筛除手术用药明细  
**********/    
set nocount on    
  
 --当前药品系统使用的是何种方案:    
 --0  全院药品统一价格管理方案,    
 --1  全院药品统一价格管理方案,进价采用加权平均进价方案,    
 --2  全院药品统一零售价,多进价管理方案,    
 --3  全院药品多零售价管理方案    
declare  @ypxtslt int             
select @ypxtslt = dbo.f_get_ypxtslt()    
if @@error<>0    
begin    
 select 'F','获取药品系统模式出错!'    
 return    
end   
   
declare     @strsql  varchar(8000),     
   @strfybz  varchar(2000),        
   @patid    varchar(12),      
   @strwhere varchar(255),      
   @arpy     ut_bz, --同一病人一起处理 qxh for fjjg 2006.1.3        
   @pyfybz     ut_bz, --配药是否自动打印 xiaoyan 2007-7-6    
   @yfdm       ut_dm2, --药房代码 xiaoyan 2007-7-6  
   @strtableA VARCHAR(80),  
   @strtableB1 VARCHAR(80),   
   @strtableB2 VARCHAR(80),   
   @strtableB3 VARCHAR(80),  
   @strtableC VARCHAR(80),  
   @strtableD VARCHAR(80),  
   @cfwz varchar(50),  
   @config3321 varchar(2),  
   @cs_cd_idm ut_xh9,  
   @cs_ypsl ut_sl10,  
   @cs_yfdm ut_ksdm,  
   @cs_cfmxxh ut_xh12,  
   @cs_ylsj1 ut_money,  
   @cs_lsje1 ut_je14,  
   @cs_jjje1 ut_je14,  
   @errmsg varchar(50),  
   @strfilter varchar(200),  
   @strwhere_ypyf varchar(2000),  
   @config3529  varchar(2),  
   @config3056 varchar(8000),  
   @config3541 varchar(2),  
   @cflx_add varchar(256) --添加的材料规则  
   ,@config3557 varchar(2)  
   ,@strwhere_ydbd varchar(2000)  
   ,@yymc ut_mc64,   --医院名称  
            @ks_id ut_ksdm,  
      @yydm  ut_dm2  
  
select @ks_id=a.ks_id from YY_ZGBMK a(nolock) where a.id=@czyh  
select @yydm =a.yydm from YY_KSBMK a(nolock) where a.id=@ks_id  
select @yymc=a.name from YY_JBCONFIG a(nolock) where a.id=@yydm  
  
/*处理诊断信息*/  
create table #temp_zdxx  
(   
  ghxh ut_xh12, --挂号序号  
  zddm ut_zdmc, --诊断代码  
  zdmc  ut_zdmc, --诊断名称  
  zdmc1 ut_zdmc, --诊断名称1  
  zdmc2 ut_zdmc, --诊断名称2  
  zdmc3 ut_zdmc, --诊断名称3  
  zdmc4 ut_zdmc, --诊断名称4  
  zdmc5 ut_zdmc, --诊断名称5  
  zdmc6 ut_zdmc, --诊断名称6  
  zdmc7 ut_zdmc, --诊断名称7  
  zdmc8 ut_zdmc, --诊断名称8  
  zdmc9 ut_zdmc, --诊断名称9  
  zdmc10 ut_zdmc, --诊断名称10  
  zdmemo1 varchar(256),   
  zdmemo2 varchar(256),  
  zdmemo3 varchar(256),  
  zdmemo4 varchar(256),  
  zdmemo5 varchar(256),  
  zdmemo6 varchar(256),   
  zdmemo7 varchar(256),  
  zdmemo8 varchar(256),  
  zdmemo9 varchar(256),  
  zdmemo10 varchar(256)    
 )  
   
 select @strwhere_ypyf=''  
    
select @cfxhgroup =substring(@cfxhgroup,1,len(@cfxhgroup))   
          
select @config3321='否'  
select @config3321=config from YY_CONFIG(nolock) where id='3321'  
  
select @config3529='否'  
select @config3529=LTRIM(rtrim(isnull(config,'否'))) from YY_CONFIG(nolock) where id='3529'   
if (LTRIM(rtrim(@config3529))<>'是') and (LTRIM(rtrim(@config3529))<>'否')    
begin  
    select @config3529='否'  
end  
   
  
select @config3056 =''  
select @config3056=LTRIM(rtrim(isnull(config,''))) from YY_CONFIG(nolock) where id='3056'      
select @config3056 =replace(@config3056,'"','')  
if @@ROWCOUNT= 0  
begin  
   select @config3056 =''  
end   
  
if @config3529 ='否'  
begin  
   select @config3056 =''  
end  
  
select @config3541='否'  
select @config3541=LTRIM(rtrim(isnull(config,'否'))) from YY_CONFIG(nolock) where id='3541'   
if (LTRIM(rtrim(@config3541))<>'是') and (LTRIM(rtrim(@config3541))<>'否')    
begin  
    select @config3541='否'  
end  
  
select @config3557='否'  
select @config3557=LTRIM(rtrim(isnull(config,'否'))) from YY_CONFIG(nolock) where id='3557'   
if (LTRIM(rtrim(@config3557))<>'是') and (LTRIM(rtrim(@config3557))<>'否')    
begin  
    select @config3557='否'  
end  
  
if (@config3557 ='是') and (@ydxhlist<>'')  
begin  
   create table #ydjh  
   (  
    ydxh ut_xh12  
   )  
   insert into #ydjh(ydxh)  
   select col from dbo.fun_Split(@ydxhlist,',')  
     
   select @strwhere_ydbd =' inner join #ydjh yd (nolock) on a.xh =yd.ydxh '   
end  
  
     
IF @cxbz = 0  
 SELECT @strtableA='SF_CFMXK a (nolock)'  
ELSE  
 SELECT @strtableA='VW_MZCFMXK a(nolock)' --sang 2011-07-29 改成视图  
   
IF @cxbz = 0  
begin  
  SELECT @strtableB1='SF_BRJSK l(nolock)',@strtableB2='SF_HJCFK m(nolock)',@strtableB3='SF_HJCFMXK n(nolock)'  
end  
ELSE  
begin  
  SELECT @strtableB1='VW_MZBRJSK l(nolock)',@strtableB2='VW_MZHJCFK m(nolock)',@strtableB3='VW_MZHJCFMXK n(nolock)'  
end  
   
IF @cxbz = 0  
 SELECT @strtableC='SF_BRJSK l(nolock)'  
ELSE  
 SELECT @strtableC='VW_MZBRJSK l(nolock)'  --sang 2011-07-29 改成视图  
   
IF @cxbz = 0  
 SELECT @strtableD='SF_MZCFK c (nolock)'  
ELSE  
 SELECT @strtableD='VW_MZCFK c (nolock)' --sang 2011-07-29 改成视图   
      
select a.xh as xh,a.cfxh,a.cd_idm,a.gg_idm,a.dxmdm,a.ypmc,a.ypdm,a.ypgg,a.ypdw,a.dwxs,  
a.ykxs,a.ypfj,a.ylsj,a.ypsl,a.ts,a.cfts,a.zfdj,a.yhdj,a.memo,a.shbz,a.flzfdj,a.txbl,  
a.lcxmdm,a.lcxmmc,a.zbz,a.yjqrbz,a.qrczyh,a.qrrq,a.yylsj,a.qrksdm,a.clbz,a.hjmxxh,a.hy_idm,  
a.hy_pdxh,a.gbfwje,a.gbfwwje,a.gbtsbz,a.gbtsbl,a.fpzh,a.bgdh,a.bgzt,a.txzt,a.hzlybz,a.bglx,  
a.lcxmsl,a.dydm,a.yyrq,a.yydd,a.zysx,a.lcjsdj,a.yjspbz,a.sbid,a.tjbz,a.ktsl,a.sqdgroupno,a.ssbfybz,  
a.zje,a.tmxxh, b.zfbz, b.zfbl, b.flzfbz , b.bxbz, b.cjmc, s.id as yptsbz, s.name as yptsmc, g.ypbz, q.fysm,q.cfsm,    
convert(varchar(32)," ") as bmmc,  isnull(q.ypmc ," ") ypmc_lc,b.gfbz,b.gfmc,b.ybmc,b.memo ypmemo   
into #cfmx_tmp    
from SF_CFMXK a(nolock), YK_YPCDMLK b(nolock),YK_TSBZK s(nolock),YY_SFDXMK g(nolock),YK_YPGGMLK q(nolock)   
   
where 1=2    
    
exec('insert into #cfmx_tmp(xh,cfxh,cd_idm,gg_idm,dxmdm,ypmc,ypdm,ypgg,ypdw,dwxs,ykxs,ypfj,ylsj,ypsl,ts,  
cfts,zfdj,yhdj,memo,shbz,flzfdj,txbl,lcxmdm,lcxmmc,zbz,yjqrbz,qrczyh,qrrq,yylsj,qrksdm,clbz,hjmxxh,hy_idm,  
hy_pdxh,gbfwje,gbfwwje,gbtsbz,gbtsbl,fpzh,bgdh,bgzt,txzt,hzlybz,bglx,lcxmsl,dydm,yyrq,yydd,zysx,lcjsdj,yjspbz,  
sbid,tjbz,ktsl,sqdgroupno,ssbfybz,zje,tmxxh,zfbz,zfbl,flzfbz,bxbz,cjmc,yptsbz,yptsmc,ypbz,fysm,cfsm,bmmc,ypmc_lc,  
gfbz,gfmc,ybmc,ypmemo)     
select a.xh,a.cfxh,a.cd_idm,a.gg_idm,a.dxmdm,a.ypmc,a.ypdm,a.ypgg,a.ypdw,a.dwxs,a.ykxs,a.ypfj,a.ylsj,  
a.ypsl,a.ts,a.cfts,a.zfdj,a.yhdj,a.memo,a.shbz,a.flzfdj,a.txbl,a.lcxmdm,a.lcxmmc,a.zbz,a.yjqrbz,a.qrczyh,  
a.qrrq,a.yylsj,a.qrksdm,a.clbz,a.hjmxxh,a.hy_idm,a.hy_pdxh,a.gbfwje,a.gbfwwje,a.gbtsbz,a.gbtsbl,a.fpzh,  
a.bgdh,a.bgzt,a.txzt,a.hzlybz,a.bglx,a.lcxmsl,a.dydm,a.yyrq,a.yydd,a.zysx,a.lcjsdj,a.yjspbz,a.sbid,a.tjbz,  
a.ktsl,a.sqdgroupno,a.ssbfybz,a.zje,a.tmxxh, b.zfbz, b.zfbl, b.flzfbz , b.bxbz, b.cjmc, s.id as yptsbz,   
s.name as yptsmc, g.ypbz, q.fysm,q.cfsm,    
convert(varchar(32)," ") as bmmc,  isnull(q.ypmc ," ") ypmc_lc,b.gfbz,b.gfmc,b.ybmc ,b.memo    
from '+@strtableA+' inner join  YK_YPCDMLK b (nolock) on a.cd_idm=b.idm '+  
' inner join YY_SFDXMK g (nolock) on a.dxmdm=g.id '+  
' inner join YK_YPGGMLK q(nolock) on a.gg_idm=q.idm  '+  
' left join YK_TSBZK s (nolock) on b.tsbz=s.id '+     
@strwhere_ydbd+    
' where a.cfxh in (' + @cfxhgroup + ')   
and isnull(a.ssbfybz , 0) = 0')  --grj 2011-12-14 增加筛除手术用药明细  
  
  
if (@config3529 ='是') or (@config3056<>'')--(材料方补充)  
begin  
 exec('insert into #cfmx_tmp(xh,cfxh,cd_idm,gg_idm,dxmdm,ypmc,ypdm,ypgg,ypdw,dwxs,ykxs,ypfj,ylsj,ypsl,ts,  
 cfts,zfdj,yhdj,memo,shbz,flzfdj,txbl,lcxmdm,lcxmmc,zbz,yjqrbz,qrczyh,qrrq,yylsj,qrksdm,clbz,hjmxxh,hy_idm,  
 hy_pdxh,gbfwje,gbfwwje,gbtsbz,gbtsbl,fpzh,bgdh,bgzt,txzt,hzlybz,bglx,lcxmsl,dydm,yyrq,yydd,zysx,lcjsdj,yjspbz,  
 sbid,tjbz,ktsl,sqdgroupno,ssbfybz,zje,tmxxh,zfbz,zfbl,flzfbz,bxbz,cjmc,yptsbz,yptsmc,ypbz,fysm,cfsm,bmmc,ypmc_lc,  
 gfbz,gfmc,ybmc,ypmemo)     
 select a.xh,a.cfxh,a.cd_idm,a.gg_idm,a.dxmdm,a.ypmc,a.ypdm,a.ypgg,a.ypdw,a.dwxs,a.ykxs,a.ypfj,a.ylsj,  
 a.ypsl,a.ts,a.cfts,a.zfdj,a.yhdj,a.memo,a.shbz,a.flzfdj,a.txbl,a.lcxmdm,a.lcxmmc,a.zbz,a.yjqrbz,a.qrczyh,  
 a.qrrq,a.yylsj,a.qrksdm,a.clbz,a.hjmxxh,a.hy_idm,a.hy_pdxh,a.gbfwje,a.gbfwwje,a.gbtsbz,a.gbtsbl,a.fpzh,  
 a.bgdh,a.bgzt,a.txzt,a.hzlybz,a.bglx,a.lcxmsl,a.dydm,a.yyrq,a.yydd,a.zysx,a.lcjsdj,a.yjspbz,a.sbid,a.tjbz,  
 a.ktsl,a.sqdgroupno,a.ssbfybz,a.zje,a.tmxxh, isnull(b.zfbz,0), isnull(b.zfbl,0), isnull(b.flzfbz,0) , isnull(b.bxbz,0), isnull(b.cjmc,""), isnull(s.id,0) as yptsbz,   
 isnull(s.name,"") as yptsmc, g.ypbz, q.fysm,q.cfsm,    
 convert(varchar(32)," ") as bmmc,  isnull(q.ypmc ,"") ypmc_lc,isnull(b.gfbz,0),isnull(b.gfmc,""),isnull(b.ybmc,"") ,isnull(b.memo,"")    
 from '+@strtableA+'  
  left join  YK_YPCDMLK b (nolock) on a.cd_idm=b.idm '+  
 ' inner join YY_SFDXMK g (nolock) on a.dxmdm=g.id '+  
 ' left join YK_YPGGMLK q(nolock) on a.gg_idm=q.idm  '+  
 ' left join YK_TSBZK s (nolock) on b.tsbz=s.id '+     
         @strwhere_ydbd+   
 ' where a.cfxh in (' + @cfxhgroup + ')   
 and isnull(a.ssbfybz , 0) = 0 and  exists (select 1 from SF_MZCFK  l (nolock) where l.xh = a.cfxh and cflx =4 and charindex(a.ypdm,"'+@config3056+'")>0 )')  --lls   
  
end  
  
if (@config3541='是')--(3541材料方补充)  
begin  
 exec('insert into #cfmx_tmp(xh,cfxh,cd_idm,gg_idm,dxmdm,ypmc,ypdm,ypgg,ypdw,dwxs,ykxs,ypfj,ylsj,ypsl,ts,  
 cfts,zfdj,yhdj,memo,shbz,flzfdj,txbl,lcxmdm,lcxmmc,zbz,yjqrbz,qrczyh,qrrq,yylsj,qrksdm,clbz,hjmxxh,hy_idm,  
 hy_pdxh,gbfwje,gbfwwje,gbtsbz,gbtsbl,fpzh,bgdh,bgzt,txzt,hzlybz,bglx,lcxmsl,dydm,yyrq,yydd,zysx,lcjsdj,yjspbz,  
 sbid,tjbz,ktsl,sqdgroupno,ssbfybz,zje,tmxxh,zfbz,zfbl,flzfbz,bxbz,cjmc,yptsbz,yptsmc,ypbz,fysm,cfsm,bmmc,ypmc_lc,  
 gfbz,gfmc,ybmc,ypmemo)     
 select a.xh,a.cfxh,a.cd_idm,a.gg_idm,a.dxmdm,a.ypmc,a.ypdm,a.ypgg,a.ypdw,a.dwxs,a.ykxs,a.ypfj,a.ylsj,  
 a.ypsl,a.ts,a.cfts,a.zfdj,a.yhdj,a.memo,a.shbz,a.flzfdj,a.txbl,a.lcxmdm,a.lcxmmc,a.zbz,a.yjqrbz,a.qrczyh,  
 a.qrrq,a.yylsj,a.qrksdm,a.clbz,a.hjmxxh,a.hy_idm,a.hy_pdxh,a.gbfwje,a.gbfwwje,a.gbtsbz,a.gbtsbl,a.fpzh,  
 a.bgdh,a.bgzt,a.txzt,a.hzlybz,a.bglx,a.lcxmsl,a.dydm,a.yyrq,a.yydd,a.zysx,a.lcjsdj,a.yjspbz,a.sbid,a.tjbz,  
 a.ktsl,a.sqdgroupno,a.ssbfybz,a.zje,a.tmxxh, isnull(b.zfbz,0), isnull(b.zfbl,0), isnull(b.flzfbz,0) , isnull(b.bxbz,0), isnull(b.cjmc,""), isnull(s.id,0) as yptsbz,   
 isnull(s.name,"") as yptsmc, g.ypbz, q.fysm,q.cfsm,    
 convert(varchar(32)," ") as bmmc,  isnull(q.ypmc ,"") ypmc_lc,isnull(b.gfbz,0),isnull(b.gfmc,""),isnull(b.ybmc,"") ,isnull(b.memo,"")    
 from '+@strtableA+'  
  left join  YK_YPCDMLK b (nolock) on a.cd_idm=b.idm '+  
 ' inner join YY_SFDXMK g (nolock) on a.dxmdm=g.id '+  
 ' left join YK_YPGGMLK q(nolock) on a.gg_idm=q.idm  '+  
 ' left join YK_TSBZK s (nolock) on b.tsbz=s.id '+     
          @strwhere_ydbd+   
 ' where a.cfxh in (' + @cfxhgroup + ')   
 and isnull(a.ssbfybz , 0) = 0 and  exists (select 1 from SF_MZCFK  l (nolock) where l.xh = a.cfxh and l.cflx=5 )')    
  
end  
  
update a set bmmc=b.bmmc from #cfmx_tmp a, YK_YPBMK b (nolock) where a.cd_idm=b.idm    
    
select @arpy=0        
if exists(select 1 from YY_CONFIG (nolock) where id = '3096' and config = '是')                   
    select @arpy=1        
       
IF @cxbz = 0  
 select @yfdm=isnull(yfdm,0) from SF_MZCFK (nolock) WHERE jssjh=@jssjh  
ELSE  
 select @yfdm=isnull(yfdm,0) from SF_NMZCFK (nolock) WHERE jssjh=@jssjh  
      
select @pyfybz =isnull(pyfybz,0) from YF_YFDMK (nolock) where id=@yfdm    
    
    
select @patid=0     
if @arpy=0    
begin    
    select @strwhere=' and c.jssjh = "' + @jssjh + '"'    
end    
else        
BEGIN  
  IF @cxbz = 0  
  begin    
  select @patid=convert(varchar(12),patid) from SF_MZCFK (nolock) WHERE jssjh=@jssjh  
  end   
  else  
  begin  
  select @patid=convert(varchar(12),patid) from SF_NMZCFK (nolock) WHERE jssjh=@jssjh  
  end   
     select @strwhere=' and c.patid = "' + @patid + '" '    
end    
     
declare @pyyf_sfxm  varchar(2000)  --药品用法集合,根据@pqbz变动    
      
if @pqbz=0   
begin   
   select @pyyf_sfxm=config from YY_CONFIG (nolock) where id='3083'  
end     
else if  @pqbz=1   
begin   
   select @pyyf_sfxm=config from YY_CONFIG (nolock) where id='3084'   
end    
else  
begin  
   select @pyyf_sfxm=config from YY_CONFIG (nolock) where id='3227'    
end  
  
if (@pyyf_sfxm='')  
begin  
   select  @strwhere_ypyf=''  
end  
else  
begin  
    select  @strwhere_ypyf=' and n.ypyf in ('+@pyyf_sfxm+') '  
end  
  
if @dyfileterbz<>0  
begin  
    select @strfilter=config from YY_CONFIG (nolock) where id='3336'  
    select @strfilter=SUBSTRING(@strfilter,3,LEN(@strfilter)-2)  
end  
                                                              
if @pyfybz=1 --配药是否自动发药 1 是， 0 否   
begin   
    select @strfybz = ',case when c.fybz = 1 then "已发药" else "库存不足未发药" end "发药标志" '   
end    
else  
begin    
    select @strfybz = ',case when c.fybz = 1 then "已发药" else "未发药" end "发药标志" '    
end   
  
select a.bmmc,case when isnull(n.zbz,0)=0 then " " when isnull(n.zbz,0)=1 then "┏"     
when isnull(n.zbz,0)>1 then "┃" when isnull(n.zbz,0) =-1 then "┗" else "┃" end + a.ypmc  ypmc ,      
a.ypgg,round(a.ylsj*a.dwxs/a.ykxs,4) as lsj, round(a.ypsl/a.dwxs,2) as sl,      
round(a.ypsl*a.ylsj*a.cfts/a.ykxs,2) as je, a.ypdw,substring(c.pyrq,1,4)+"年"+substring(c.pyrq,5,2)      
+"月"+substring(c.pyrq,7,2)+"日" pyrq, d.name fyckmc,e.name ysmc,f.name sfymc,c.xh,substring(c.lrrq,1,4)      
+"-"+substring(c.lrrq,5,2)+"-"+substring(c.lrrq,7,2)+" "+substring(c.lrrq,9,5) sfrq,c.cfts,       
n.ypjl, n.jldw, o.xsmc "频次",n.ts "天数", p.name ypyf,n.ypyf as ypyf0, n.memo yznr,    
case when isnull(m.jsdjfbz,0)=1 then "加收代煎费" else " " end "加收代煎费标志",n.memo zt,    
n.xh as sxh,m.xdfxh,m.xdfmc,"库存不足未发药" "发药标志"    
, 0 fzbz, case when isnull(c.txh,0)<>0 then "退费" else "" end "退费标志",    
c.jssjh,c.fyckdm ,c.ksdm,k.name ksmc,t.ybdm,t.ybsm,t.memo,    
l.mjzbz,e.zc_mc, c.pyckdm, l.fph ,a.fysm,a.cfsm,l.yflsh, c.yflsh as cfk_yflsh, c.fyckxh,     
l.patid, a.cd_idm, a.ypbz,a.zfbz, a.zfbl, a.flzfbz,a.bxbz,a.cjmc,    
case when a.yptsbz in (1,2,3) then a.yptsmc else " " end  "特殊标志",    
case charindex("*",a.ypgg) when 0 then a.ypgg else  substring(a.ypgg,1,charindex("*",a.ypgg)-1) end ypgg2,    
case when substring(c.lrrq,1,8)<>convert(varchar(30),getdate(),112) then "往日处方" else "  " end sfdr    
,m.memo as cf_yznr, m.cfypyf as cf_ypyf, c.zpwzbh, a.ypmc_lc    
,round(a.lcjsdj*a.dwxs/a.ykxs,4) lcjsdj, e.dzyzimage,n.psbz,a.gfbz,a.gfmc,a.ybmc,a.ypmemo,    
m.cfjyfs,convert(varchar(20),"") as zddm,convert(varchar(256),"") as zdmc,m.ghxh,c.cflx,c.pyczyh,c.hjxh,c.txh,   
n.cfypsl,case isnull(m.wsbz,0) when 1 then "外送" else "不外送" end as "外送标志",isnull(n.fzxh,0) fzxh,  
case isnull(m.zbbz,0) when 1 then "自包" else "" end as "自包标志",c.yfdm,  
convert(varchar(256),"") as zdmc1,convert(varchar(256),"") as zdmemo1,  
convert(varchar(256),"") as zdmc2,convert(varchar(256),"") as zdmemo2,  
convert(varchar(256),"") as zdmc3,convert(varchar(256),"") as zdmemo3,  
convert(varchar(256),"") as zdmc4,convert(varchar(256),"") as zdmemo4,  
convert(varchar(256),"") as zdmc5,convert(varchar(256),"") as zdmemo5,  
convert(varchar(256),"") as zdmc6,convert(varchar(256),"") as zdmemo6,  
convert(varchar(256),"") as zdmc7,convert(varchar(256),"") as zdmemo7,  
convert(varchar(256),"") as zdmc8,convert(varchar(256),"") as zdmemo8,  
convert(varchar(256),"") as zdmc9,convert(varchar(256),"") as zdmemo9,  
convert(varchar(256),"") as zdmc10,convert(varchar(256),"") as zdmemo10,  
n.dwlb,n.gg_idm,n.ypjl zxypjl,n.jldw zxjldw,a.cfxh as cfmxxh  
into #pydy_tmp    
from #cfmx_tmp a(nolock),SF_MZCFK c (nolock),YF_FYCKDMK d (nolock),YY_ZGBMK e (nolock),YY_ZGBMK f (nolock),      
YY_KSBMK k(nolock),SF_BRJSK l(nolock),SF_HJCFK m(nolock),SF_HJCFMXK n(nolock),    
SF_YS_YZPCK o(nolock),SF_YPYFK p(nolock), YY_YBFLK t(nolock)   
where 1=2    
  
--添加电子处方    
select @strsql = 'insert INTO #pydy_tmp(bmmc,ypmc,ypgg,lsj,sl,je,ypdw,pyrq,fyckmc,ysmc,sfymc,xh,sfrq,cfts,ypjl,  
jldw,频次,天数,ypyf,ypyf0,yznr,加收代煎费标志,zt,sxh,xdfxh,xdfmc,发药标志,fzbz,退费标志,jssjh,fyckdm,ksdm,ksmc,ybdm,  
ybsm,memo,mjzbz,zc_mc,pyckdm,fph,fysm,cfsm,yflsh,cfk_yflsh,fyckxh,patid,cd_idm,ypbz,zfbz,zfbl,flzfbz,bxbz,  
cjmc,特殊标志,ypgg2,sfdr,cf_yznr,cf_ypyf,zpwzbh,ypmc_lc,lcjsdj,dzyzimage,psbz,gfbz,gfmc,ybmc,ypmemo,cfjyfs,zddm,zdmc,  
ghxh,cflx,pyczyh,hjxh,txh,cfypsl,外送标志,fzxh,自包标志,yfdm,zdmc1,zdmemo1,zdmc2,zdmemo2,zdmc3,zdmemo3,zdmc4,zdmemo4,zdmc5,  
zdmemo5,zdmc6,zdmemo6,zdmc7,zdmemo7,zdmc8,zdmemo8,zdmc9,zdmemo9,zdmc10,zdmemo10,dwlb,gg_idm,zxypjl,zxjldw,cfmxxh)   
select a.bmmc,case when isnull(n.zbz,0)=0 then " " when isnull(n.zbz,0)=1 then "┏"     
when isnull(n.zbz,0)>1 then "┃" when isnull(n.zbz,0) =-1 then "┗" else "┃" end + a.ypmc  ypmc ,      
a.ypgg,round(a.ylsj*a.dwxs/a.ykxs,4) as lsj, round(a.ypsl/a.dwxs,2) as sl,      
round(a.ypsl*a.ylsj*a.cfts/a.ykxs,2) as je, a.ypdw,substring(c.pyrq,1,4)+"年"+substring(c.pyrq,5,2)      
+"月"+substring(c.pyrq,7,2)+"日" pyrq, isnull(d.name," ") fyckmc,  isnull(e.name," ") ysmc, isnull(f.name," ") sfymc,c.xh,substring(c.lrrq,1,4)      
+"-"+substring(c.lrrq,5,2)+"-"+substring(c.lrrq,7,2)+" "+substring(c.lrrq,9,5) sfrq,c.cfts,       
n.ypjl, n.jldw, o.xsmc "频次",n.ts "天数", isnull(p.name," ") ypyf, isnull(n.ypyf," ") as ypyf0, n.memo yznr,    
case when isnull(m.jsdjfbz,0)=1 then "加收代煎费" else " " end "加收代煎费标志",n.memo zt,    
n.xh as sxh,m.xdfxh,m.xdfmc'+@strfybz+'     
, 0 fzbz, case when isnull(c.txh,0)<>0 then "退费" else "" end "退费标志",    
c.jssjh,c.fyckdm ,c.ksdm,k.name ksmc,t.ybdm,t.ybsm,t.memo,    
l.mjzbz,e.zc_mc, c.pyckdm, l.fph ,a.fysm,a.cfsm,l.yflsh, c.yflsh as cfk_yflsh, c.fyckxh,     
l.patid, a.cd_idm, a.ypbz,a.zfbz, a.zfbl, a.flzfbz,a.bxbz,a.cjmc,    
case when a.yptsbz in (1,2,3) then a.yptsmc else " " end  "特殊标志",    
case charindex("*",a.ypgg) when 0 then a.ypgg else  substring(a.ypgg,1,charindex("*",a.ypgg)-1) end ypgg2,    
case when substring(c.lrrq,1,8)<>convert(varchar(30),getdate(),112) then "往日处方" else "  " end sfdr     
,m.memo as cf_yznr, m.cfypyf as cf_ypyf,  c.zpwzbh , a.ypmc_lc    ---q.name as cf_ypyfmc,--edit by xiaoyan 2007-7-19    
,round(a.lcjsdj*a.dwxs/a.ykxs,4) lcjsdj, e.dzyzimage,n.psbz,a.gfbz,a.gfmc,a.ybmc,a.ypmemo,m.cfjyfs,"","",m.ghxh,c.cflx,c.pyczyh,c.hjxh,c.txh,isnull(n.cfypsl,""),  
case isnull(m.wsbz,0) when 1 then "外送" else "不外送" end as "外送标志",isnull(n.fzxh,0) fzxh, case isnull(m.zbbz,0) when 1 then "自包" else "" end as 自包标志,c.yfdm,      --add jl 2008-05-07   
"" zdmc1, "" zdmc2, "" zdmc3, "" zdmc4,"" zdmc5,"" zdmc6,"" zdmc7,"" zdmc8,"" zdmc9, "" zdmc10,  
"" zdmemo1,"" zdmemo2,"" zdmemo3,"" zdmemo4,"" zdmemo5,"" zdmemo6,"" zdmemo7,"" zdmemo8,"" zdmemo9,"" zdmemo10,n.dwlb,n.gg_idm,n.ypjl zxypjl,n.jldw zxjldw  
,a.xh as cfmxxh  
from #cfmx_tmp a inner join '+@strtableD + ' on a.cfxh = c.xh ' +  
' inner join ' + @strtableB1 + ' on c.jssjh=l.sjh  and ((l.ghsfbz=1 and l.ybjszt=2) or l.ghsfbz=2)  '+   
' inner join ' + @strtableB2 + ' on c.hjxh = m.xh and m.jlzt = 1   '+  
' inner join ' + @strtableB3 + ' on m.xh = n.cfxh '+  
' inner join YY_YBFLK t(nolock) on c.ybdm=t.ybdm '+  
' left join YF_FYCKDMK d (nolock) on c.fyckdm = d.id '+  
' left join YY_ZGBMK e (nolock) on c.ysdm = e.id '+  
' left join YY_ZGBMK f (nolock) on  c.czyh = f.id '+  
' left join  YY_KSBMK k(nolock) on c.ksdm= k.id '+     
' left join SF_YS_YZPCK o(nolock) on n.pcdm =o.id '+  
' left join SF_YPYFK p(nolock) on n.ypyf=p.id'+  
' where isnull(c.ejygbz,0)=0 and c.cflx in (1,2,3) '+@strwhere+@strwhere_ypyf+ '       
and a.cd_idm>0 and ((isnull(a.hjmxxh,0)=0 and a.cd_idm=n.cd_idm) or (isnull(a.hjmxxh,0)<>0 and isnull(a.hjmxxh,0)=n.xh))'  
exec (@strsql)   
   
--添加额外处方类型（cflx =4）  
  
if (@config3529='是')and(@config3056<>'')  
begin  
 select @strsql = 'insert INTO #pydy_tmp(bmmc,ypmc,ypgg,lsj,sl,je,ypdw,pyrq,fyckmc,ysmc,sfymc,xh,sfrq,cfts,ypjl,  
 jldw,频次,天数,ypyf,ypyf0,yznr,加收代煎费标志,zt,sxh,xdfxh,xdfmc,发药标志,fzbz,退费标志,jssjh,fyckdm,ksdm,ksmc,ybdm,  
 ybsm,memo,mjzbz,zc_mc,pyckdm,fph,fysm,cfsm,yflsh,cfk_yflsh,fyckxh,patid,cd_idm,ypbz,zfbz,zfbl,flzfbz,bxbz,  
 cjmc,特殊标志,ypgg2,sfdr,cf_yznr,cf_ypyf,zpwzbh,ypmc_lc,lcjsdj,dzyzimage,psbz,gfbz,gfmc,ybmc,ypmemo,cfjyfs,zddm,zdmc,  
 ghxh,cflx,pyczyh,hjxh,txh,cfypsl,外送标志,fzxh,自包标志,yfdm,zdmc1,zdmemo1,zdmc2,zdmemo2,zdmc3,zdmemo3,zdmc4,zdmemo4,zdmc5,  
 zdmemo5,zdmc6,zdmemo6,zdmc7,zdmemo7,zdmc8,zdmemo8,zdmc9,zdmemo9,zdmc10,zdmemo10,dwlb,gg_idm,zxypjl,zxjldw,cfmxxh)   
 select a.bmmc,case when isnull(n.zbz,0)=0 then " " when isnull(n.zbz,0)=1 then "┏"     
 when isnull(n.zbz,0)>1 then "┃" when isnull(n.zbz,0) =-1 then "┗" else "┃" end + a.ypmc  ypmc ,      
 a.ypgg,round(a.ylsj*a.dwxs/a.ykxs,4) as lsj, round(a.ypsl/a.dwxs,2) as sl,      
 round(a.ypsl*a.ylsj*a.cfts/a.ykxs,2) as je, a.ypdw,substring(c.pyrq,1,4)+"年"+substring(c.pyrq,5,2)      
 +"月"+substring(c.pyrq,7,2)+"日" pyrq, isnull(d.name," ") fyckmc,  isnull(e.name," ") ysmc, isnull(f.name," ") sfymc,c.xh,substring(c.lrrq,1,4)      
 +"-"+substring(c.lrrq,5,2)+"-"+substring(c.lrrq,7,2)+" "+substring(c.lrrq,9,5) sfrq,c.cfts,       
 n.ypjl, n.jldw, o.xsmc "频次",isnull(n.ts,0) "天数", isnull(p.name," ") ypyf, isnull(n.ypyf," ") as ypyf0, n.memo yznr,      
    case when isnull(m.jsdjfbz,0)=1 then "加收代煎费" else " " end "加收代煎费标志",n.memo zt,      
    isnull(n.xh,0) as sxh,m.xdfxh,m.xdfmc'+@strfybz+'      
 , 0 fzbz, case when isnull(c.txh,0)<>0 then "退费" else "" end "退费标志",    
 c.jssjh,c.fyckdm ,c.ksdm,k.name ksmc,t.ybdm,t.ybsm,t.memo,    
 l.mjzbz,e.zc_mc, c.pyckdm, l.fph ,a.fysm,a.cfsm,l.yflsh, c.yflsh as cfk_yflsh, c.fyckxh,     
 l.patid, a.cd_idm, a.ypbz,a.zfbz, a.zfbl, a.flzfbz,a.bxbz,a.cjmc,    
 case when a.yptsbz in (1,2,3) then a.yptsmc else " " end  "特殊标志",    
 case charindex("*",a.ypgg) when 0 then a.ypgg else  substring(a.ypgg,1,charindex("*",a.ypgg)-1) end ypgg2,    
 case when substring(c.lrrq,1,8)<>convert(varchar(30),getdate(),112) then "往日处方" else "  " end sfdr     
 ,m.memo as cf_yznr, m.cfypyf as cf_ypyf,  c.zpwzbh , a.ypmc_lc    ---q.name as cf_ypyfmc,--edit by xiaoyan 2007-7-19    
 ,round(a.lcjsdj*a.dwxs/a.ykxs,4) lcjsdj, e.dzyzimage,n.psbz,a.gfbz,a.gfmc,a.ybmc,a.ypmemo,m.cfjyfs,"","",m.ghxh,c.cflx,c.pyczyh,c.hjxh,c.txh,isnull(n.cfypsl,""),  
 case isnull(m.wsbz,0) when 1 then "外送" else "不外送" end as "外送标志",isnull(n.fzxh,0) fzxh, case isnull(m.zbbz,0) when 1 then "自包" else "" end as 自包标志,c.yfdm,      --add jl 2008-05-07   
 "" zdmc1, "" zdmc2, "" zdmc3, "" zdmc4,"" zdmc5,"" zdmc6,"" zdmc7,"" zdmc8,"" zdmc9, "" zdmc10,  
 "" zdmemo1,"" zdmemo2,"" zdmemo3,"" zdmemo4,"" zdmemo5,"" zdmemo6,"" zdmemo7,"" zdmemo8,"" zdmemo9,"" zdmemo10,isnull(n.dwlb,0) as dwlb ,a.gg_idm,n.ypjl zxypjl,n.jldw zxjldw    
 ,a.xh as cfmxxh  
 from #cfmx_tmp a inner join '+@strtableD + ' on a.cfxh = c.xh ' +  
 ' inner join ' + @strtableB1 + ' on c.jssjh=l.sjh  and ((l.ghsfbz=1 and l.ybjszt=2) or l.ghsfbz=2)  '+   
 ' left join ' + @strtableB2 + ' on c.hjxh = m.xh and m.jlzt = 1   '+  
 ' left join ' + @strtableB3 + ' on m.xh = n.cfxh '+  
 ' left join YY_YBFLK t(nolock) on c.ybdm=t.ybdm '+  
 ' left join YF_FYCKDMK d (nolock) on c.fyckdm = d.id '+  
 ' left join YY_ZGBMK e (nolock) on c.ysdm = e.id '+  
 ' left join YY_ZGBMK f (nolock) on  c.czyh = f.id '+  
 ' left join  YY_KSBMK k(nolock) on c.ksdm= k.id '+     
 ' left join SF_YS_YZPCK o(nolock) on n.pcdm =o.id '+  
 ' left join SF_YPYFK p(nolock) on n.ypyf=p.id'+  
 ' where isnull(c.ejygbz,0)=0 '+@strwhere+ '       
 and a.cd_idm=0 and ((isnull(a.hjmxxh,0)=0 and a.cd_idm=isnull(n.cd_idm,0)) or (isnull(a.hjmxxh,0)<>0 and isnull(a.hjmxxh,0)=isnull(n.xh,0)))  
 and (c.cflx =4 and charindex(a.ypdm,"'+@config3056+'")>0 ) '  
   
 exec (@strsql)   
end  
  
if (@config3541='是') --材料  
begin  
 select @strsql = 'insert INTO #pydy_tmp(bmmc,ypmc,ypgg,lsj,sl,je,ypdw,pyrq,fyckmc,ysmc,sfymc,xh,sfrq,cfts,ypjl,  
 jldw,频次,天数,ypyf,ypyf0,yznr,加收代煎费标志,zt,sxh,xdfxh,xdfmc,发药标志,fzbz,退费标志,jssjh,fyckdm,ksdm,ksmc,ybdm,  
 ybsm,memo,mjzbz,zc_mc,pyckdm,fph,fysm,cfsm,yflsh,cfk_yflsh,fyckxh,patid,cd_idm,ypbz,zfbz,zfbl,flzfbz,bxbz,  
 cjmc,特殊标志,ypgg2,sfdr,cf_yznr,cf_ypyf,zpwzbh,ypmc_lc,lcjsdj,dzyzimage,psbz,gfbz,gfmc,ybmc,ypmemo,cfjyfs,zddm,zdmc,  
 ghxh,cflx,pyczyh,hjxh,txh,cfypsl,外送标志,fzxh,自包标志,yfdm,zdmc1,zdmemo1,zdmc2,zdmemo2,zdmc3,zdmemo3,zdmc4,zdmemo4,zdmc5,  
 zdmemo5,zdmc6,zdmemo6,zdmc7,zdmemo7,zdmc8,zdmemo8,zdmc9,zdmemo9,zdmc10,zdmemo10,dwlb,gg_idm,zxypjl,zxjldw,cfmxxh)   
 select a.bmmc,case when isnull(n.zbz,0)=0 then " " when isnull(n.zbz,0)=1 then "┏"     
 when isnull(n.zbz,0)>1 then "┃" when isnull(n.zbz,0) =-1 then "┗" else "┃" end + a.ypmc  ypmc ,      
 a.ypgg,round(a.ylsj*a.dwxs/a.ykxs,4) as lsj, round(a.ypsl/a.dwxs,2) as sl,      
 round(a.ypsl*a.ylsj*a.cfts/a.ykxs,2) as je, a.ypdw,substring(c.pyrq,1,4)+"年"+substring(c.pyrq,5,2)      
 +"月"+substring(c.pyrq,7,2)+"日" pyrq, isnull(d.name," ") fyckmc,  isnull(e.name," ") ysmc, isnull(f.name," ") sfymc,c.xh,substring(c.lrrq,1,4)      
 +"-"+substring(c.lrrq,5,2)+"-"+substring(c.lrrq,7,2)+" "+substring(c.lrrq,9,5) sfrq,c.cfts,       
 n.ypjl, n.jldw, o.xsmc "频次",isnull(n.ts,0) "天数", isnull(p.name," ") ypyf, isnull(n.ypyf," ") as ypyf0, n.memo yznr,      
    case when isnull(m.jsdjfbz,0)=1 then "加收代煎费" else " " end "加收代煎费标志",n.memo zt,      
    isnull(n.xh,0) as sxh,m.xdfxh,m.xdfmc'+@strfybz+'      
 , 0 fzbz, case when isnull(c.txh,0)<>0 then "退费" else "" end "退费标志",    
 c.jssjh,c.fyckdm ,c.ksdm,k.name ksmc,t.ybdm,t.ybsm,t.memo,    
 l.mjzbz,e.zc_mc, c.pyckdm, l.fph ,a.fysm,a.cfsm,l.yflsh, c.yflsh as cfk_yflsh, c.fyckxh,     
 l.patid, a.cd_idm, a.ypbz,a.zfbz, a.zfbl, a.flzfbz,a.bxbz,a.cjmc,    
 case when a.yptsbz in (1,2,3) then a.yptsmc else " " end  "特殊标志",    
 case charindex("*",a.ypgg) when 0 then a.ypgg else  substring(a.ypgg,1,charindex("*",a.ypgg)-1) end ypgg2,    
 case when substring(c.lrrq,1,8)<>convert(varchar(30),getdate(),112) then "往日处方" else "  " end sfdr     
 ,m.memo as cf_yznr, m.cfypyf as cf_ypyf,  c.zpwzbh , a.ypmc_lc    ---q.name as cf_ypyfmc,--edit by xiaoyan 2007-7-19    
 ,round(a.lcjsdj*a.dwxs/a.ykxs,4) lcjsdj, e.dzyzimage,n.psbz,a.gfbz,a.gfmc,a.ybmc,a.ypmemo,m.cfjyfs,"","",m.ghxh,c.cflx,c.pyczyh,c.hjxh,c.txh,isnull(n.cfypsl,""),  
 case isnull(m.wsbz,0) when 1 then "外送" else "不外送" end as "外送标志",isnull(n.fzxh,0) fzxh, case isnull(m.zbbz,0) when 1 then "自包" else "" end as 自包标志,c.yfdm,      --add jl 2008-05-07   
 "" zdmc1, "" zdmc2, "" zdmc3, "" zdmc4,"" zdmc5,"" zdmc6,"" zdmc7,"" zdmc8,"" zdmc9, "" zdmc10,  
 "" zdmemo1,"" zdmemo2,"" zdmemo3,"" zdmemo4,"" zdmemo5,"" zdmemo6,"" zdmemo7,"" zdmemo8,"" zdmemo9,"" zdmemo10,isnull(n.dwlb,0) as dwlb ,a.gg_idm,n.ypjl zxypjl,n.jldw zxjldw    
 ,a.xh as cfmxxh  
 from #cfmx_tmp a inner join '+@strtableD + ' on a.cfxh = c.xh ' +  
 ' inner join ' + @strtableB1 + ' on c.jssjh=l.sjh  and ((l.ghsfbz=1 and l.ybjszt=2) or l.ghsfbz=2)  '+   
 ' left join ' + @strtableB2 + ' on c.hjxh = m.xh and m.jlzt = 1   '+  
 ' left join ' + @strtableB3 + ' on m.xh = n.cfxh '+  
 ' left join YY_YBFLK t(nolock) on c.ybdm=t.ybdm '+  
 ' left join YF_FYCKDMK d (nolock) on c.fyckdm = d.id '+  
 ' left join YY_ZGBMK e (nolock) on c.ysdm = e.id '+  
 ' left join YY_ZGBMK f (nolock) on  c.czyh = f.id '+  
 ' left join  YY_KSBMK k(nolock) on c.ksdm= k.id '+     
 ' left join SF_YS_YZPCK o(nolock) on n.pcdm =o.id '+  
 ' left join SF_YPYFK p(nolock) on n.ypyf=p.id'+  
 ' where isnull(c.ejygbz,0)=0 '+@strwhere+ '       
 and a.cd_idm=0 and ((isnull(a.hjmxxh,0)=0 and a.cd_idm=isnull(n.cd_idm,0)) or (isnull(a.hjmxxh,0)<>0 and isnull(a.hjmxxh,0)=isnull(n.xh,0)))  
 and (c.cflx=5 ) '  
 exec (@strsql)   
end  
  
if exists (select 1 from YY_CONFIG(nolock) where id ='3147' and config ='是') and (@strwhere_ypyf='')  --添加手工处方  
begin  
select @strsql = 'insert INTO #pydy_tmp(bmmc,ypmc,ypgg,lsj,sl,je,ypdw,pyrq,fyckmc,ysmc,sfymc,xh,sfrq,cfts,ypjl,  
jldw,频次,天数,ypyf,ypyf0,yznr,加收代煎费标志,zt,sxh,xdfxh,xdfmc,发药标志,fzbz,退费标志,jssjh,fyckdm,ksdm,ksmc,ybdm,  
ybsm,memo,mjzbz,zc_mc,pyckdm,fph,fysm,cfsm,yflsh,cfk_yflsh,fyckxh,patid,cd_idm,ypbz,zfbz,zfbl,flzfbz,bxbz,  
cjmc,特殊标志,ypgg2,sfdr,cf_yznr,cf_ypyf,zpwzbh,ypmc_lc,lcjsdj,dzyzimage,psbz,gfbz,gfmc,ybmc,ypmemo,cfjyfs,zddm,zdmc,  
ghxh,cflx,pyczyh,hjxh,txh,cfypsl,外送标志,fzxh,自包标志,yfdm,zdmc1,zdmemo1,zdmc2,zdmemo2,zdmc3,zdmemo3,zdmc4,zdmemo4,zdmc5,  
zdmemo5,zdmc6,zdmemo6,zdmc7,zdmemo7,zdmc8,zdmemo8,zdmc9,zdmemo9,zdmc10,zdmemo10,dwlb,gg_idm,zxypjl,zxjldw,cfmxxh)      
select a.bmmc,a.ypmc ypmc,a.ypgg,round(a.ylsj*a.dwxs/a.ykxs,4) as lsj, round(a.ypsl/a.dwxs,2) as sl,        
round(a.ypsl*a.ylsj*a.cfts/a.ykxs,2) as je, a.ypdw,substring(c.pyrq,1,4)+"年"+      
substring(c.pyrq,5,2)+"月"+substring(c.pyrq,7,2)+"日" pyrq, isnull(d.name," ") fyckmc, isnull(e.name," ") ysmc,      
isnull(f.name," ") sfymc,c.xh,substring(c.lrrq,1,4)+"-"+substring(c.lrrq,5,2)+"-"+substring(c.lrrq,7,2)+" "+      
substring(c.lrrq,9,5) sfrq,c.cfts,    
0 as ypjl , a.ypdw," ", 1 as ts, " " ypyf," " as ypyf0," " yznr,    
" " "加收代煎费标志",a.memo zt,     
a.xh as sxh,0 xdfxh," " xdfmc'+@strfybz+'    
, 0 fzbz, case when isnull(c.txh,0)<>0 then "退费" else "" end "退费标志",    
c.jssjh,c.fyckdm ,c.ksdm,k.name ksmc,t.ybdm,t.ybsm,t.memo,    
l.mjzbz,e.zc_mc, c.pyckdm, l.fph ,a.fysm,a.cfsm,l.yflsh, c.yflsh as cfk_yflsh, c.fyckxh,     
l.patid, a.cd_idm, a.ypbz,a.zfbz, a.zfbl, a.flzfbz,a.bxbz,a.cjmc,    
case when a.yptsbz in (1,2,3) then a.yptsmc else " " end  "特殊标志",    
case charindex("*",a.ypgg) when 0 then a.ypgg else  substring(a.ypgg,1,charindex("*",a.ypgg)-1) end ypgg2,    
case when substring(c.lrrq,1,8)<>convert(varchar(30),getdate(),112) then "往日处方" else "  " end sfdr    
,"" as cf_yznr, "" as cf_ypyf,  c.zpwzbh , a.ypmc_lc    ----"" as cf_ypyfmc,--edit by xiaoyan 2007-7-19    
,round(a.lcjsdj*a.dwxs/a.ykxs,4) lcjsdj, e.dzyzimage,-1 as psbz,a.gfbz,a.gfmc,a.ybmc,a.ypmemo,0,"","",0,c.cflx,c.pyczyh,c.hjxh,c.txh,"","不外送" as "外送标志",0 fzxh  
,"" as 自包标志,c.yfdm,  
"" zdmc1, "" zdmc2, "" zdmc3, "" zdmc4,"" zdmc5,"" zdmc6,"" zdmc7,"" zdmc8,"" zdmc9, "" zdmc10,  
"" zdmemo1,"" zdmemo2,"" zdmemo3,"" zdmemo4,"" zdmemo5,"" zdmemo6,"" zdmemo7,"" zdmemo8,"" zdmemo9,"" zdmemo10,0 dwlb, 0 gg_idm,0 zxypjl,a.ypdw zxjldw  
,a.xh as cfmxxh  
from #cfmx_tmp a inner join '+@strtableD+' on a.cfxh = c.xh '+  
' inner join ' + @strtableC + ' on c.jssjh=l.sjh and ((l.ghsfbz=1 and l.ybjszt=2) or l.ghsfbz=2)   '+   
' inner join YY_YBFLK t(nolock) on c.ybdm=t.ybdm '+  
' left join YF_FYCKDMK d (nolock) on c.fyckdm = d.id '+  
' left join YY_ZGBMK e (nolock) on c.ysdm = e.id '+  
' left join YY_ZGBMK f (nolock) on  c.czyh = f.id '+  
' left join  YY_KSBMK k(nolock) on c.ksdm= k.id '+     
' where isnull(c.ejygbz,0)=0 and c.cflx in (1,2,3) '  
+@strwhere+ '  and a.cd_idm > 0 and c.hjxh<=0 order by c.xh,sxh '  
   exec (@strsql)  
end  
  
if (@pqbz=2) and (@dybz=0) --打印药袋的时候不需要打印红冲jlzt=2的处方  
begin  
 ---去掉红冲的数据  
 delete a from #pydy_tmp a inner join SF_MZCFK b(nolock) on a.xh=b.xh   
 where b.jlzt=2  
end  
    
--------------增加处理最小剂量单位   
UPDATE  a   
SET a.zxypjl=CASE WHEN a.dwlb=0 THEN ceiling(a.ypjl/b.ggxs) ELSE  a.ypjl END,  
    a.zxjldw=CASE WHEN a.dwlb=0 THEN b.zxdw ELSE  a.jldw END  
FROM #pydy_tmp a,YK_YPGGMLK b(nolock)   
WHERE a.gg_idm>0 and a.gg_idm=b.idm   
AND b.tybz=0 AND a.dwlb=0    
  
/*处理诊断信息*/  
  
declare @sycfzdfs ut_bz  
select @sycfzdfs=config from YY_CONFIG where id='H195' --使用处方诊断方式[0不用1使用]  
if isnull(@sycfzdfs,-1)=1  
begin  
  
   update  #pydy_tmp  set zddm = b.zddm ,zdmc=b.zdmc   
   from #pydy_tmp a,SF_YS_MZBLZDK b(nolock) where a.xh=b.cfxh    
end  
else  
begin  
  
 insert into #temp_zdxx(ghxh,zddm,zdmc,  
 zdmc1,zdmc2,zdmc3,zdmc4,zdmc5,zdmc6,zdmc7,zdmc8,zdmc9,zdmc10,  
 zdmemo1,zdmemo2,zdmemo3,zdmemo4,zdmemo5,zdmemo6,zdmemo7,zdmemo8,zdmemo9,zdmemo10)  
 select distinct isnull(ghxh,0) ghxh,"" zddm,"" zdmc,  
  "" zdmc1, "" zdmc2, "" zdmc3, "" zdmc4,"" zdmc5,"" zdmc6,"" zdmc7,"" zdmc8,"" zdmc9, "" zdmc10,  
  "" zdmemo1,"" zdmemo2,"" zdmemo3,"" zdmemo4,"" zdmemo5,"" zdmemo6,"" zdmemo7,"" zdmemo8,"" zdmemo9,"" zdmemo10  
 from #pydy_tmp  
  
 declare @ghxh1 ut_xh12,@str varchar(255),@zddmstr  varchar(255)  
 declare @zdmc1 ut_zdmc,@zdmemo1 varchar(256), @zdmc2 ut_zdmc,@zdmemo2 varchar(256), @zdmc3 ut_zdmc,@zdmemo3 varchar(256) ,                   
 @zdmc4 ut_zdmc,@zdmemo4 varchar(256),@zdmc5 ut_zdmc,@zdmemo5 varchar(256),@zdmc6 ut_zdmc ,  @zdmemo6 varchar(256),@zdmemo7 ut_zdmc,@zdmc7 varchar(256)  
 ,@zdmc8 ut_zdmc,@zdmemo8 varchar (256),@zdmc9 ut_zdmc,@zdmemo9 varchar (256) ,@zdmc10 ut_zdmc,@zdmemo10 varchar (256)     
  
 declare cs_zdxx cursor for   
 select top 100 ghxh  from SF_YS_MZBLZDK (nolock)   
 where ghxh in (select distinct ghxh from #temp_zdxx where ghxh<>0)  
  
 open cs_zdxx   
 fetch cs_zdxx into @ghxh1   
 while  @@FETCH_STATUS=0  
 begin   
  select @str=" "  
  select @zddmstr=" "  
  select @str=@str+zdmc+', ',@zddmstr=@zddmstr+zddm+', ' from SF_YS_MZBLZDK   
  where ghxh=@ghxh1 and ghxh in (select distinct ghxh from #temp_zdxx where ghxh<>0)  
  update  #temp_zdxx set zdmc=@str,zddm=@zddmstr  where  ghxh=@ghxh1                                                    
  select @zdmc1=zdmc,@zdmemo1=memo from VW_SF_YS_MZBLZDK b (nolock)   where b.ghxh =@ghxh1 and b.zdlx=0                                                             
  select @zdmc2=zdmc,@zdmemo2=memo  from VW_SF_YS_MZBLZDK b (nolock)  where b.ghxh=@ghxh1 and b.zdlx=1                            
  select @zdmc3=zdmc,@zdmemo3=memo  from VW_SF_YS_MZBLZDK b (nolock)  where b.ghxh =@ghxh1 and b.zdlx=2                                        
  select @zdmc4=zdmc,@zdmemo4=memo  from VW_SF_YS_MZBLZDK b (nolock) where b.ghxh=@ghxh1 and b.zdlx=3                                                 
  select @zdmc5=zdmc,@zdmemo5=memo from VW_SF_YS_MZBLZDK b (nolock) where b.ghxh=@ghxh1 and b.zdlx=4                                        
  select @zdmc6=zdmc,@zdmemo6=memo  from VW_SF_YS_MZBLZDK  b (nolock) where b.ghxh=@ghxh1 and b.zdlx=5         
  select @zdmc7=zdmc,@zdmemo7=memo from  VW_SF_YS_MZBLZDK  b (nolock) where b.ghxh=@ghxh1 and b.zdlx=6  
  select @zdmc8=zdmc,@zdmemo8=memo from  VW_SF_YS_MZBLZDK  b (nolock) where b.ghxh=@ghxh1 and b.zdlx=7   
  select @zdmc9=zdmc,@zdmemo9=memo from  VW_SF_YS_MZBLZDK  b (nolock) where b.ghxh=@ghxh1 and b.zdlx=8  
  select @zdmc10=zdmc,@zdmemo10=memo from  VW_SF_YS_MZBLZDK  b (nolock) where b.ghxh=@ghxh1 and b.zdlx=9              
                         
  select @zdmc1=isnull(@zdmc1," "), @zdmc2=isnull(@zdmc2," "), @zdmc3=isnull(@zdmc3," "), @zdmc4=isnull(@zdmc4," "),                  
      @zdmc5=isnull(@zdmc5," "),@zdmc6=isnull(@zdmc6," "), @zdmc7=isnull(@zdmc7," "), @zdmc8=isnull(@zdmc8," "),                   
      @zdmc9=isnull(@zdmc9," "), @zdmc10=isnull(@zdmc10," "), @zdmemo1=isnull(@zdmemo1," "), @zdmemo2=isnull(@zdmemo2," "),                   
      @zdmemo3=isnull(@zdmemo3," "),@zdmemo4=isnull(@zdmemo4," "),@zdmemo5=isnull(@zdmemo5," "),@zdmemo6=isnull(@zdmemo6," "),                 
      @zdmemo7=isnull(@zdmemo7," "), @zdmemo8=isnull(@zdmemo8," "),@zdmemo9=isnull(@zdmemo9," "), @zdmemo10=isnull(@zdmemo10," ")                
    
  update  #temp_zdxx  set zdmc1=@zdmc1,zdmc2=@zdmc2,zdmc3=@zdmc3,zdmc4=@zdmc4,zdmc5=@zdmc5,  
   zdmc6=@zdmc6,zdmc7=@zdmc7,zdmc8=@zdmc8,zdmc9=@zdmc9,zdmc10=@zdmc10,  
   zdmemo1=@zdmemo1,zdmemo2=@zdmemo2,zdmemo3=@zdmemo3,zdmemo4=@zdmemo4,zdmemo5=@zdmemo5,  
   zdmemo6=@zdmemo6,zdmemo7=@zdmemo7,zdmemo8=@zdmemo8,zdmemo9=@zdmemo9,zdmemo10=@zdmemo10  
  where  ghxh=@ghxh1   
      
  fetch cs_zdxx into @ghxh1           
 end   
 close cs_zdxx  
 DEALLOCATE  cs_zdxx  
  
 select distinct t1.ghxh,t1.zddm,t1.zdmc,t1.zdmc1,t1.zdmc2,t1.zdmc3,t1.zdmc4,t1.zdmc5,t1.zdmc6,t1.zdmc7,  
     t1.zdmc8,t1.zdmc9,t1.zdmc10,t1.zdmemo1,t1.zdmemo2,t1.zdmemo3,t1.zdmemo4,t1.zdmemo5,t1.zdmemo6,  
     t1.zdmemo7,t1.zdmemo8,t1.zdmemo9,t1.zdmemo10  
 into #temp_zdxx1   
 from #temp_zdxx t1(nolock)  
  
  
 update #pydy_tmp  set zdmc=b.zdmc, zddm=b.zddm,  
 zdmc1=b.zdmc1,zdmc2=b.zdmc2,zdmc3=b.zdmc3,zdmc4=b.zdmc4,zdmc5=b.zdmc5,  
 zdmc6=b.zdmc6,zdmc7=b.zdmc7,zdmc8=b.zdmc8,zdmc9=b.zdmc9,zdmc10=b.zdmc10,  
 zdmemo1=b.zdmemo1, zdmemo2=b.zdmemo2, zdmemo3=b.zdmemo3, zdmemo4=b.zdmemo4, zdmemo5=b.zdmemo5,   
 zdmemo6=b.zdmemo6, zdmemo7=b.zdmemo7, zdmemo8=b.zdmemo8, zdmemo9=b.zdmemo9, zdmemo10=b.zdmemo10   
 from #pydy_tmp a,#temp_zdxx1 b(nolock)   
 where a.ghxh=b.ghxh   
  
end  
  
--通过txh更新jssjh  
update a set a.jssjh=b.jssjh from #pydy_tmp a,SF_MZCFK b(nolock) where a.txh=b.xh   

--增加草药处方录入信息 --add by yangdi 2020.6.10
/*
select x.CYCYJX+' 共 '+CONVERT(VARCHAR(2),a.cfts)+' 剂 用法: '+x.CYYYFF+' 每 '+CONVERT(VARCHAR(2),x.CYMRJL)+' 日一剂,分 '+CONVERT(VARCHAR(2),x.CYFYCS)+' 次用 '+x.CYFYYQ,* from #pydy_tmp a
	INNER JOIN dbo.SF_HJCFK c ON a.hjxh=c.xh
	INNER JOIN CISDB.dbo.OUTP_ORDER x ON c.v5xh=x.XH
*/

UPDATE a SET a.cf_yznr=x.CYCYJX+' 共 '+CONVERT(VARCHAR(2),a.cfts)+' 剂 用法: '+x.CYYYFF+' 每 '+CONVERT(VARCHAR(2),x.CYMRJL)+' 日一剂,分 '+CONVERT(VARCHAR(2),x.CYFYCS)+' 次用 '+x.CYFYYQ
from #pydy_tmp a
	INNER JOIN dbo.SF_HJCFK c ON a.hjxh=c.xh
	INNER JOIN CISDB.dbo.OUTP_ORDER x ON c.v5xh=x.XH
  
  
select a.bmmc,a.ypmc,a.ypgg,a.lsj,a.sl,a.je,a.ypdw,a.pyrq,a.fyckmc,a.ysmc,a.sfymc,a.xh,a.sfrq,  
       a.cfts,a.ypjl,a.jldw,a.频次,a.天数,a.ypyf,a.ypyf0,a.yznr,a.加收代煎费标志,a.zt,a.sxh,a.xdfxh,  
       a.xdfmc,a.发药标志,a.fzbz,a.退费标志,a.jssjh,a.fyckdm,a.ksdm,a.ksmc,a.ybdm,a.ybsm,a.memo,a.mjzbz,  
       a.zc_mc,a.pyckdm,a.fph,a.fysm,a.cfsm,a.yflsh,a.cfk_yflsh,a.fyckxh,a.patid,a.cd_idm,a.ypbz,a.zfbz,  
       a.zfbl,a.flzfbz,a.bxbz,a.cjmc,a.特殊标志,a.ypgg2,a.sfdr,a.cf_yznr,a.cf_ypyf,a.zpwzbh,a.ypmc_lc,  
       a.lcjsdj,a.dzyzimage,a.psbz,a.gfbz,a.gfmc,a.ybmc,a.ypmemo,a.cfjyfs,a.zddm,a.zdmc,a.ghxh,a.cflx,  
       a.pyczyh,a.hjxh,a.txh,a.cfypsl,a.外送标志,a.fzxh,a.自包标志,a.yfdm,a.zdmc1,a.zdmemo1,a.zdmc2,  
       a.zdmemo2,a.zdmc3,a.zdmemo3,a.zdmc4,a.zdmemo4,a.zdmc5,a.zdmemo5,a.zdmc6,a.zdmemo6,a.zdmc7,a.zdmemo7,  
       a.zdmc8,a.zdmemo8,a.zdmc9,a.zdmemo9,a.zdmc10,a.zdmemo10,a.dwlb,a.gg_idm,a.zxypjl,a.zxjldw,a.cfmxxh   
into #tmp_result   
from #pydy_tmp a(nolock)  
where 1=2  
  
--把明细内容 存放到 #tmp_result 临时表  
insert into #tmp_result(bmmc,ypmc,ypgg,lsj,sl,je,ypdw,pyrq,fyckmc,ysmc,sfymc,xh,sfrq,cfts,ypjl,jldw,频次,天数,  
ypyf,ypyf0,yznr,加收代煎费标志,zt,sxh,xdfxh,xdfmc,发药标志,fzbz,退费标志,jssjh,fyckdm,ksdm,ksmc,ybdm,ybsm,memo,  
mjzbz,zc_mc,pyckdm,fph,fysm,cfsm,yflsh,cfk_yflsh,fyckxh,patid,cd_idm,ypbz,zfbz,zfbl,flzfbz,bxbz,cjmc,特殊标志,  
ypgg2,sfdr,cf_yznr,cf_ypyf,zpwzbh,ypmc_lc,lcjsdj,dzyzimage,psbz,gfbz,gfmc,ybmc,ypmemo,cfjyfs,zddm,zdmc,  
ghxh,cflx,pyczyh,hjxh,txh,cfypsl,外送标志,fzxh,自包标志,yfdm,zdmc1,zdmemo1,zdmc2,zdmemo2,zdmc3,zdmemo3,zdmc4,  
zdmemo4,zdmc5,zdmemo5,zdmc6,zdmemo6,zdmc7,zdmemo7,zdmc8,zdmemo8,zdmc9,zdmemo9,zdmc10,zdmemo10,dwlb,gg_idm,  
zxypjl,zxjldw,cfmxxh)   
select bmmc,ypmc,ypgg,lsj,sl,je,ypdw,pyrq,fyckmc,ysmc,sfymc,xh,sfrq,cfts,ypjl,jldw,频次,天数,  
ypyf,ypyf0,yznr,加收代煎费标志,zt,sxh,xdfxh,xdfmc,发药标志,fzbz,退费标志,jssjh,fyckdm,ksdm,ksmc,ybdm,ybsm,memo,  
mjzbz,zc_mc,pyckdm,fph,fysm,cfsm,yflsh,cfk_yflsh,fyckxh,patid,cd_idm,ypbz,zfbz,zfbl,flzfbz,bxbz,cjmc,特殊标志,  
ypgg2,sfdr,cf_yznr,cf_ypyf,zpwzbh,ypmc_lc,lcjsdj,dzyzimage,psbz,gfbz,gfmc,ybmc,ypmemo,cfjyfs,zddm,zdmc,  
ghxh,cflx,pyczyh,hjxh,txh,cfypsl,外送标志,fzxh,自包标志,yfdm,zdmc1,zdmemo1,zdmc2,zdmemo2,zdmc3,zdmemo3,zdmc4,  
zdmemo4,zdmc5,zdmemo5,zdmc6,zdmemo6,zdmc7,zdmemo7,zdmc8,zdmemo8,zdmc9,zdmemo9,zdmc10,zdmemo10,dwlb,gg_idm,  
zxypjl,zxjldw,cfmxxh   
from #pydy_tmp(nolock)   
  
--添加传出本处方金额合计  
select xh,sum(je) as 本处方金额合计 into #tmp_result_cfje from #tmp_result group by xh  
  
if (@config3321='是') and (@ypxtslt=2)  
begin  
 select t2.cd_idm,(-1)*t2.cfts*t2.ypsl as ypsl,t3.yfdm,t2.xh as mxxh  
 into #yf_pygz_yclkc   
 from #tmp_result t1(nolock)       
  inner join SF_CFMXK t2(nolock) on t1.cfmxxh=t2.xh  
  inner join SF_MZCFK t3(nolock) on t2.cfxh=t3.xh  
 where t2.cd_idm<>0  
  
 declare cs_yfpy cursor for   
 select a.cd_idm,a.ypsl,a.yfdm,a.mxxh  
 from #yf_pygz_yclkc a(nolock)   
 where a.ypsl<>0           
 for read only  
  
 open cs_yfpy  
 fetch cs_yfpy into @cs_cd_idm, @cs_ypsl, @cs_yfdm,@cs_cfmxxh  
 while @@fetch_status=0  
 begin    
     --先删除YF_PY_MXPCXX 同一张处方的配药明细，防止重复配药多次往YF_PY_MXPCXX插入数据  
     delete from YF_PY_MXPCXX where zdmxxh=@cs_cfmxxh  
  exec usp_yf_pygz_kcycl @cs_cd_idm,@cs_yfdm,@cs_ypsl,1,@errmsg output,0,@cs_yfdm,0,  
                   0,@cs_cfmxxh,'99',@cs_ylsj1 output,@cs_lsje1 output,@cs_jjje1 output  
  fetch cs_yfpy into @cs_cd_idm, @cs_ypsl, @cs_yfdm,@cs_cfmxxh  
 end  
 close cs_yfpy  
 deallocate cs_yfpy  
      
 select a.bmmc,a.ypmc,a.ypgg,a.lsj,a.sl,a.je,a.ypdw,a.pyrq,a.fyckmc,a.ysmc,a.sfymc,a.xh,a.sfrq,  
       a.cfts,a.ypjl,a.jldw,a.频次,a.天数,a.ypyf,a.ypyf0,a.yznr,a.加收代煎费标志,a.zt,a.sxh,a.xdfxh,  
       a.xdfmc,a.发药标志,a.fzbz,a.退费标志,a.jssjh,a.fyckdm,a.ksdm,a.ksmc,a.ybdm,a.ybsm,a.memo,a.mjzbz,  
       a.zc_mc,a.pyckdm,a.fph,a.fysm,a.cfsm,a.yflsh,a.cfk_yflsh,a.fyckxh,a.patid,a.cd_idm,a.ypbz,a.zfbz,  
       a.zfbl,a.flzfbz,a.bxbz,a.cjmc,a.特殊标志,a.ypgg2,a.sfdr,a.cf_yznr,a.cf_ypyf,a.zpwzbh,a.ypmc_lc,  
       a.lcjsdj,a.dzyzimage,a.psbz,a.gfbz,a.gfmc,a.ybmc,a.ypmemo,a.cfjyfs,a.zddm,a.zdmc,a.ghxh,a.cflx,  
       a.pyczyh,a.hjxh,a.txh,a.cfypsl,a.外送标志,a.fzxh,a.自包标志,a.yfdm,a.zdmc1,a.zdmemo1,a.zdmc2,  
       a.zdmemo2,a.zdmc3,a.zdmemo3,a.zdmc4,a.zdmemo4,a.zdmc5,a.zdmemo5,a.zdmc6,a.zdmemo6,a.zdmc7,a.zdmemo7,  
       a.zdmc8,a.zdmemo8,a.zdmc9,a.zdmemo9,a.zdmc10,a.zdmemo10,a.dwlb,a.gg_idm,a.zxypjl,a.zxjldw,  
       (-1)*b.czsl/d.dwxs as pysl_pc,c.hgmc as hgmc,abs(b.lsje) as lsje_pc, 1 as cfts_pc   
    into #tmp_result_pc      
 from #tmp_result a(nolock) inner join YF_PY_MXPCXX b(nolock) on a.cfmxxh=b.zdmxxh  
                            inner join #cfmx_tmp d(nolock) on a.cfmxxh=d.xh  
                            left join YF_YPHGWH_PC c(nolock) on b.yfpcxh=c.pcxh  
 union all   
 select a.bmmc,a.ypmc,a.ypgg,a.lsj,a.sl,a.je,a.ypdw,a.pyrq,a.fyckmc,a.ysmc,a.sfymc,a.xh,a.sfrq,  
       a.cfts,a.ypjl,a.jldw,a.频次,a.天数,a.ypyf,a.ypyf0,a.yznr,a.加收代煎费标志,a.zt,a.sxh,a.xdfxh,  
       a.xdfmc,a.发药标志,a.fzbz,a.退费标志,a.jssjh,a.fyckdm,a.ksdm,a.ksmc,a.ybdm,a.ybsm,a.memo,a.mjzbz,  
       a.zc_mc,a.pyckdm,a.fph,a.fysm,a.cfsm,a.yflsh,a.cfk_yflsh,a.fyckxh,a.patid,a.cd_idm,a.ypbz,a.zfbz,  
       a.zfbl,a.flzfbz,a.bxbz,a.cjmc,a.特殊标志,a.ypgg2,a.sfdr,a.cf_yznr,a.cf_ypyf,a.zpwzbh,a.ypmc_lc,  
       a.lcjsdj,a.dzyzimage,a.psbz,a.gfbz,a.gfmc,a.ybmc,a.ypmemo,a.cfjyfs,a.zddm,a.zdmc,a.ghxh,a.cflx,  
       a.pyczyh,a.hjxh,a.txh,a.cfypsl,a.外送标志,a.fzxh,a.自包标志,a.yfdm,a.zdmc1,a.zdmemo1,a.zdmc2,  
       a.zdmemo2,a.zdmc3,a.zdmemo3,a.zdmc4,a.zdmemo4,a.zdmc5,a.zdmemo5,a.zdmc6,a.zdmemo6,a.zdmc7,a.zdmemo7,  
       a.zdmc8,a.zdmemo8,a.zdmc9,a.zdmemo9,a.zdmc10,a.zdmemo10,a.dwlb,a.gg_idm,a.zxypjl,a.zxjldw,  
       (-1)*a.sl*a.cfts as pysl_pc,null as hgmc,abs(a.je) as lsje_pc,1 as cfts_pc    
     from  #tmp_result a(nolock) inner join #cfmx_tmp d(nolock) on a.cfmxxh=d.xh  
     where not exists(select 1 from YF_PY_MXPCXX b(nolock) where a.cfmxxh=b.zdmxxh)    
      
    if @cxbz = 0   ---日表  
    begin   
  --sang+++ 2011-07-27 创建报表抬头内容 masterbedpipline  
  --注意抬头 只能是一条记录 字段不够，可修改相应sql，自行调整  
  select top 1 e.cardno 卡号,e.blh 病历号,e.hzxm 患者姓名,e.sex 性别,e.birth 出生年月,  
  (dbo.FUN_GETBRNL(e.birth,convert(char(8),getdate(),112)+convert(char(8),getdate(),8),1,0,null))  年龄,   
  (dbo.FUN_GETBRNL(e.birth,convert(char(8),getdate(),112)+convert(char(8),getdate(),8),0,0,null)) 岁数,e.sfzh 身份证,   
  b.ybsm 费别,b.pzlx,e.pzh,e.dwbm, e.dwmc ,e.lxdz 联系地址,e.lxdh 联系电话,c.name as dymc ,e.qtkh,e.dyid,  
  s.lrrq kfrq,s.tmhdbz,case s.tmhdbz when 1 then '已核对' else '未核对' end as tmhdbz_sm  
  into #tmp_title_pc  
  from SF_BRXXK e (nolock)   
   inner join SF_BRJSK d(nolock) on d.patid=e.patid  
   inner join SF_MZCFK s(nolock) on  d.sjh=s.jssjh  
   left join YY_YBFLK b (nolock) on e.ybdm=b.ybdm  
   left join YY_BRDYLYK c(nolock) on  e.dyid=c.id  
  where s.jssjh=@jssjh  
  
  --将抬头和明细联合起来  
  select @cfwz cfwz,xh mzcfk_xh,  
      a.卡号,a.病历号,a.患者姓名,a.性别,a.出生年月,a.年龄,a.岁数,a.身份证,a.费别,a.pzlx,a.pzh,a.dwbm,a.dwmc,  
      a.联系地址,a.联系电话,a.dymc,a.qtkh,a.dyid,a.kfrq,a.tmhdbz,a.tmhdbz_sm,  
      b.bmmc,b.ypmc,b.ypgg,b.lsj,b.sl,b.je,b.ypdw,b.pyrq,b.fyckmc,b.ysmc,b.sfymc,b.xh,b.sfrq,b.cfts,  
      b.ypjl,b.jldw,b.频次,b.天数,b.ypyf,b.ypyf0,b.yznr,b.加收代煎费标志,b.zt,b.sxh,b.xdfxh,b.xdfmc,  
      b.发药标志,b.fzbz,b.退费标志,b.jssjh,b.fyckdm,b.ksdm,b.ksmc,b.ybdm,b.ybsm,b.memo,b.mjzbz,b.zc_mc,  
      b.pyckdm,b.fph,b.fysm,b.cfsm,b.yflsh,b.cfk_yflsh,b.fyckxh,b.patid,b.cd_idm,b.ypbz,b.zfbz,b.zfbl,  
      b.flzfbz,b.bxbz,b.cjmc,b.特殊标志,b.ypgg2,b.sfdr,b.cf_yznr,b.cf_ypyf,b.zpwzbh,b.ypmc_lc,b.lcjsdj,  
      b.dzyzimage,b.psbz,b.gfbz,b.gfmc,b.ybmc,b.ypmemo,b.cfjyfs,b.zddm,b.zdmc,b.ghxh,b.cflx,b.pyczyh,  
      b.hjxh,b.txh,b.cfypsl,b.外送标志,b.fzxh,b.自包标志,b.yfdm,b.zdmc1,b.zdmemo1,b.zdmc2,b.zdmemo2,  
      b.zdmc3,b.zdmemo3,b.zdmc4,b.zdmemo4,b.zdmc5,b.zdmemo5,b.zdmc6,b.zdmemo6,b.zdmc7,b.zdmemo7,b.zdmc8,  
      b.zdmemo8,b.zdmc9,b.zdmemo9,b.zdmc10,b.zdmemo10,b.dwlb,b.gg_idm,b.zxypjl,b.zxjldw,  
      b.pysl_pc,b.hgmc,b.lsje_pc,b.cfts_pc  
  into #tmp_zz_result_pc   
  from #tmp_title_pc a(nolock),#tmp_result_pc b(nolock)  
  
  update #tmp_zz_result_pc set cfwz=b.cfwz  
  from #tmp_zz_result_pc a(nolock),YF_YFZKC b(nolock)  
  where a.yfdm=b.ksdm and a.cd_idm=b.cd_idm  
          
        select a.cfwz,a.mzcfk_xh,a.卡号,a.病历号,a.患者姓名,a.性别,a.出生年月,a.年龄,a.岁数,a.身份证,a.费别,  
      a.pzlx,a.pzh,a.dwbm,a.dwmc,a.联系地址,a.联系电话,a.dymc,a.qtkh,a.dyid,a.kfrq,a.tmhdbz,a.tmhdbz_sm,  
      a.bmmc,a.ypmc,a.ypgg,a.lsj,a.sl,a.je,a.ypdw,a.pyrq,a.fyckmc,a.ysmc,a.sfymc,a.xh,a.sfrq,a.cfts,  
      a.ypjl,a.jldw,a.频次,a.天数,a.ypyf,a.ypyf0,a.yznr,a.加收代煎费标志,a.zt,a.sxh,a.xdfxh,a.xdfmc,  
      a.发药标志,a.fzbz,a.退费标志,a.jssjh,a.fyckdm,a.ksdm,a.ksmc,a.ybdm,a.ybsm,a.memo,a.mjzbz,a.zc_mc,  
      a.pyckdm,a.fph,a.fysm,a.cfsm,a.yflsh,a.cfk_yflsh,a.fyckxh,a.patid,a.cd_idm,a.ypbz,a.zfbz,a.zfbl,  
      a.flzfbz,a.bxbz,a.cjmc,a.特殊标志,a.ypgg2,a.sfdr,a.cf_yznr,a.cf_ypyf,a.zpwzbh,a.ypmc_lc,a.lcjsdj,  
      a.dzyzimage,a.psbz,a.gfbz,a.gfmc,a.ybmc,a.ypmemo,a.cfjyfs,a.zddm,a.zdmc,a.ghxh,a.cflx,a.pyczyh,  
      a.hjxh,a.txh,a.cfypsl,a.外送标志,a.fzxh,a.自包标志,a.yfdm,a.zdmc1,a.zdmemo1,a.zdmc2,a.zdmemo2,  
      a.zdmc3,a.zdmemo3,a.zdmc4,a.zdmemo4,a.zdmc5,a.zdmemo5,a.zdmc6,a.zdmemo6,a.zdmc7,a.zdmemo7,a.zdmc8,  
      a.zdmemo8,a.zdmc9,a.zdmemo9,a.zdmc10,a.zdmemo10,a.dwlb,a.gg_idm,a.zxypjl,a.zxjldw,  
      a.pysl_pc,a.hgmc,a.lsje_pc,a.cfts_pc ,convert(varchar(64), @yymc) as yymc  
     into #temp_zz_result_sc_rb       
  from #tmp_zz_result_pc a(nolock)  
  order by a.cfwz,a.xh,a.sxh             
        if @dyfileterbz=0   
        begin  
            select  a.*,b.本处方金额合计  from #temp_zz_result_sc_rb a left join #tmp_result_cfje b on a.xh=b.xh   
        end  
        else if @dyfileterbz=1   
        begin  
            exec('select a.*,b.本处方金额合计 from #temp_zz_result_sc_rb a left join #tmp_result_cfje b on a.xh=b.xh where ypyf0 in ('+@strfilter+')')  
        end  
        else if @dyfileterbz=2   
        begin  
            exec('select a.*,b.本处方金额合计 from #temp_zz_result_sc_rb a left join #tmp_result_cfje b on a.xh=b.xh where ypyf0 not in ('+@strfilter+')')  
        end  
                    
 end  
 else   ---年表  
 begin  
  --sang+++ 2011-07-27 创建报表抬头内容 masterbedpipline  
  --注意抬头 只能是一条记录 字段不够，可修改相应sql，自行调整  
  select top 1 e.cardno 卡号,e.blh 病历号,e.hzxm 患者姓名,e.sex 性别,e.birth 出生年月,  
  (dbo.FUN_GETBRNL(e.birth,convert(char(8),getdate(),112)+convert(char(8),getdate(),8),1,0,null))  年龄,   
  (dbo.FUN_GETBRNL(e.birth,convert(char(8),getdate(),112)+convert(char(8),getdate(),8),0,0,null)) 岁数,e.sfzh 身份证,   
  b.ybsm 费别,b.pzlx,e.pzh,e.dwbm, e.dwmc ,e.lxdz 联系地址,e.lxdh 联系电话,c.name as dymc ,e.qtkh,e.dyid,  
  s.lrrq kfrq,s.tmhdbz,case s.tmhdbz when 1 then '已核对' else '未核对' end as tmhdbz_sm  
  into #tmp_title_pc_nb  
  from SF_BRXXK e (nolock)   
   inner join VW_MZBRJSK d(nolock) on d.patid=e.patid  
   inner join VW_MZCFK s(nolock) on  d.sjh=s.jssjh  
   left join YY_YBFLK b (nolock) on e.ybdm=b.ybdm  
   left join YY_BRDYLYK c(nolock) on  e.dyid=c.id  
  where s.jssjh=@jssjh  
  
  --将抬头和明细联合起来  
  select @cfwz cfwz,xh mzcfk_xh,  
      a.卡号,a.病历号,a.患者姓名,a.性别,a.出生年月,a.年龄,a.岁数,a.身份证,a.费别,a.pzlx,a.pzh,a.dwbm,a.dwmc,  
      a.联系地址,a.联系电话,a.dymc,a.qtkh,a.dyid,a.kfrq,a.tmhdbz,a.tmhdbz_sm,  
      b.bmmc,b.ypmc,b.ypgg,b.lsj,b.sl,b.je,b.ypdw,b.pyrq,b.fyckmc,b.ysmc,b.sfymc,b.xh,b.sfrq,b.cfts,  
      b.ypjl,b.jldw,b.频次,b.天数,b.ypyf,b.ypyf0,b.yznr,b.加收代煎费标志,b.zt,b.sxh,b.xdfxh,b.xdfmc,  
      b.发药标志,b.fzbz,b.退费标志,b.jssjh,b.fyckdm,b.ksdm,b.ksmc,b.ybdm,b.ybsm,b.memo,b.mjzbz,b.zc_mc,  
      b.pyckdm,b.fph,b.fysm,b.cfsm,b.yflsh,b.cfk_yflsh,b.fyckxh,b.patid,b.cd_idm,b.ypbz,b.zfbz,b.zfbl,  
      b.flzfbz,b.bxbz,b.cjmc,b.特殊标志,b.ypgg2,b.sfdr,b.cf_yznr,b.cf_ypyf,b.zpwzbh,b.ypmc_lc,b.lcjsdj,  
      b.dzyzimage,b.psbz,b.gfbz,b.gfmc,b.ybmc,b.ypmemo,b.cfjyfs,b.zddm,b.zdmc,b.ghxh,b.cflx,b.pyczyh,  
      b.hjxh,b.txh,b.cfypsl,b.外送标志,b.fzxh,b.自包标志,b.yfdm,b.zdmc1,b.zdmemo1,b.zdmc2,b.zdmemo2,  
      b.zdmc3,b.zdmemo3,b.zdmc4,b.zdmemo4,b.zdmc5,b.zdmemo5,b.zdmc6,b.zdmemo6,b.zdmc7,b.zdmemo7,b.zdmc8,  
      b.zdmemo8,b.zdmc9,b.zdmemo9,b.zdmc10,b.zdmemo10,b.dwlb,b.gg_idm,b.zxypjl,b.zxjldw,  
      b.pysl_pc,b.hgmc,b.lsje_pc,b.cfts_pc  
  into #tmp_zz_result_pc_nb   
  from #tmp_title_pc_nb a(nolock),#tmp_result_pc b(nolock)  
  
  update #tmp_zz_result_pc_nb set cfwz=b.cfwz  
  from #tmp_zz_result_pc_nb a(nolock),YF_YFZKC b(nolock)  
  where a.yfdm=b.ksdm and a.cd_idm=b.cd_idm  
          
  select a.cfwz,a.mzcfk_xh,a.卡号,a.病历号,a.患者姓名,a.性别,a.出生年月,a.年龄,a.岁数,a.身份证,a.费别,  
      a.pzlx,a.pzh,a.dwbm,a.dwmc,a.联系地址,a.联系电话,a.dymc,a.qtkh,a.dyid,a.kfrq,a.tmhdbz,a.tmhdbz_sm,  
      a.bmmc,a.ypmc,a.ypgg,a.lsj,a.sl,a.je,a.ypdw,a.pyrq,a.fyckmc,a.ysmc,a.sfymc,a.xh,a.sfrq,a.cfts,  
      a.ypjl,a.jldw,a.频次,a.天数,a.ypyf,a.ypyf0,a.yznr,a.加收代煎费标志,a.zt,a.sxh,a.xdfxh,a.xdfmc,  
      a.发药标志,a.fzbz,a.退费标志,a.jssjh,a.fyckdm,a.ksdm,a.ksmc,a.ybdm,a.ybsm,a.memo,a.mjzbz,a.zc_mc,  
      a.pyckdm,a.fph,a.fysm,a.cfsm,a.yflsh,a.cfk_yflsh,a.fyckxh,a.patid,a.cd_idm,a.ypbz,a.zfbz,a.zfbl,  
      a.flzfbz,a.bxbz,a.cjmc,a.特殊标志,a.ypgg2,a.sfdr,a.cf_yznr,a.cf_ypyf,a.zpwzbh,a.ypmc_lc,a.lcjsdj,  
      a.dzyzimage,a.psbz,a.gfbz,a.gfmc,a.ybmc,a.ypmemo,a.cfjyfs,a.zddm,a.zdmc,a.ghxh,a.cflx,a.pyczyh,  
      a.hjxh,a.txh,a.cfypsl,a.外送标志,a.fzxh,a.自包标志,a.yfdm,a.zdmc1,a.zdmemo1,a.zdmc2,a.zdmemo2,  
      a.zdmc3,a.zdmemo3,a.zdmc4,a.zdmemo4,a.zdmc5,a.zdmemo5,a.zdmc6,a.zdmemo6,a.zdmc7,a.zdmemo7,a.zdmc8,  
      a.zdmemo8,a.zdmc9,a.zdmemo9,a.zdmc10,a.zdmemo10,a.dwlb,a.gg_idm,a.zxypjl,a.zxjldw,  
      a.pysl_pc,a.hgmc,a.lsje_pc,a.cfts_pc,convert(varchar(64), @yymc) as yymc  
     into #temp_zz_result_sc_nb         
  from #tmp_zz_result_pc_nb a(nolock)  
  order by a.cfwz,a.xh,a.sxh    
  if @dyfileterbz=0   
        begin  
            select a.*,b.本处方金额合计 from #temp_zz_result_sc_nb a left join #tmp_result_cfje b on a.xh=b.xh    
        end  
        else if @dyfileterbz=1   
        begin  
             exec('select a.*,b.本处方金额合计 from #temp_zz_result_sc_nb a left join #tmp_result_cfje b on a.xh=b.xh  where ypyf0 in ('+@strfilter+')')  
        end  
        else if @dyfileterbz=2   
        begin  
            exec('select a.*,b.本处方金额合计 from #temp_zz_result_sc_nb a left join #tmp_result_cfje b on a.xh=b.xh  where ypyf0 not in ('+@strfilter+')')  
        end  
       
 end  
 return    
end  
else   --3221为否  
begin  
 if @cxbz = 0   ---日表  
 begin  
  --sang+++ 2011-07-27 创建报表抬头内容 masterbedpipline  
  --注意抬头 只能是一条记录 字段不够，可修改相应sql，自行调整  
  select top 1 e.cardno 卡号,e.blh 病历号,e.hzxm 患者姓名,e.sex 性别,e.birth 出生年月,  
  (dbo.FUN_GETBRNL(e.birth,convert(char(8),getdate(),112)+convert(char(8),getdate(),8),1,0,null))  年龄,   
  (dbo.FUN_GETBRNL(e.birth,convert(char(8),getdate(),112)+convert(char(8),getdate(),8),0,0,null)) 岁数,e.sfzh 身份证,   
  b.ybsm 费别,b.pzlx,e.pzh,e.dwbm, e.dwmc ,e.lxdz 联系地址,e.lxdh 联系电话,c.name as dymc ,e.qtkh,e.dyid,  
  s.lrrq kfrq,s.tmhdbz,case s.tmhdbz when 1 then '已核对' else '未核对' end as tmhdbz_sm  
  into #tmp_title  
  from SF_BRXXK e (nolock) 
   inner join SF_BRJSK d(nolock) on d.patid=e.patid  
   inner join SF_MZCFK s(nolock) on  d.sjh=s.jssjh  
   left join YY_YBFLK b (nolock) on e.ybdm=b.ybdm  
   left join YY_BRDYLYK c(nolock) on  e.dyid=c.id  
  where s.jssjh=@jssjh  
  
  --将抬头和明细联合起来  
  select @cfwz cfwz,xh mzcfk_xh,  
      a.卡号,a.病历号,a.患者姓名,a.性别,a.出生年月,a.年龄,a.岁数,a.身份证,a.费别,a.pzlx,a.pzh,a.dwbm,a.dwmc,  
      a.联系地址,a.联系电话,a.dymc,a.qtkh,a.dyid,a.kfrq,a.tmhdbz,a.tmhdbz_sm,  
      b.bmmc,b.ypmc,b.ypgg,b.lsj,b.sl,b.je,b.ypdw,b.pyrq,b.fyckmc,b.ysmc,b.sfymc,b.xh,b.sfrq,b.cfts,  
      b.ypjl,b.jldw,b.频次,b.天数,b.ypyf,b.ypyf0,b.yznr,b.加收代煎费标志,b.zt,b.sxh,b.xdfxh,b.xdfmc,  
      b.发药标志,b.fzbz,b.退费标志,b.jssjh,b.fyckdm,b.ksdm,b.ksmc,b.ybdm,b.ybsm,b.memo,b.mjzbz,b.zc_mc,  
      b.pyckdm,b.fph,b.fysm,b.cfsm,b.yflsh,b.cfk_yflsh,b.fyckxh,b.patid,b.cd_idm,b.ypbz,b.zfbz,b.zfbl,  
      b.flzfbz,b.bxbz,b.cjmc,b.特殊标志,b.ypgg2,b.sfdr,b.cf_yznr,b.cf_ypyf,b.zpwzbh,b.ypmc_lc,b.lcjsdj,  
      b.dzyzimage,b.psbz,b.gfbz,b.gfmc,b.ybmc,b.ypmemo,b.cfjyfs,b.zddm,b.zdmc,b.ghxh,b.cflx,b.pyczyh,  
      b.hjxh,b.txh,b.cfypsl,b.外送标志,b.fzxh,b.自包标志,b.yfdm,b.zdmc1,b.zdmemo1,b.zdmc2,b.zdmemo2,  
      b.zdmc3,b.zdmemo3,b.zdmc4,b.zdmemo4,b.zdmc5,b.zdmemo5,b.zdmc6,b.zdmemo6,b.zdmc7,b.zdmemo7,b.zdmc8,  
      b.zdmemo8,b.zdmc9,b.zdmemo9,b.zdmc10,b.zdmemo10,b.dwlb,b.gg_idm,b.zxypjl,b.zxjldw  
  into #tmp_zz_result   
  from #tmp_title a(nolock),#tmp_result b(nolock)  
  
  update #tmp_zz_result set cfwz=b.cfwz  
  from #tmp_zz_result a(nolock),YF_YFZKC b(nolock)  
  where a.yfdm=b.ksdm and a.cd_idm=b.cd_idm  
  
  select a.cfwz,a.mzcfk_xh,a.卡号,a.病历号,a.患者姓名,a.性别,a.出生年月,a.年龄,a.岁数,a.身份证,a.费别,  
      a.pzlx,a.pzh,a.dwbm,a.dwmc,a.联系地址,a.联系电话,a.dymc,a.qtkh,a.dyid,a.kfrq,a.tmhdbz,a.tmhdbz_sm,  
      a.bmmc,a.ypmc,a.ypgg,a.lsj,a.sl,a.je,a.ypdw,a.pyrq,a.fyckmc,a.ysmc,a.sfymc,a.xh,a.sfrq,a.cfts,  
      a.ypjl,a.jldw,a.频次,a.天数,a.ypyf,a.ypyf0,a.yznr,a.加收代煎费标志,a.zt,a.sxh,a.xdfxh,a.xdfmc,  
      a.发药标志,a.fzbz,a.退费标志,a.jssjh,a.fyckdm,a.ksdm,a.ksmc,a.ybdm,a.ybsm,a.memo,a.mjzbz,a.zc_mc,  
      a.pyckdm,a.fph,a.fysm,a.cfsm,a.yflsh,a.cfk_yflsh,a.fyckxh,a.patid,a.cd_idm,a.ypbz,a.zfbz,a.zfbl,  
      a.flzfbz,a.bxbz,a.cjmc,a.特殊标志,a.ypgg2,a.sfdr,a.cf_yznr,a.cf_ypyf,a.zpwzbh,a.ypmc_lc,a.lcjsdj,  
      a.dzyzimage,a.psbz,a.gfbz,a.gfmc,a.ybmc,a.ypmemo,a.cfjyfs,a.zddm,a.zdmc,a.ghxh,a.cflx,a.pyczyh,  
      a.hjxh,a.txh,a.cfypsl,a.外送标志,a.fzxh,a.自包标志,a.yfdm,a.zdmc1,a.zdmemo1,a.zdmc2,a.zdmemo2,  
      a.zdmc3,a.zdmemo3,a.zdmc4,a.zdmemo4,a.zdmc5,a.zdmemo5,a.zdmc6,a.zdmemo6,a.zdmc7,a.zdmemo7,a.zdmc8,  
      a.zdmemo8,a.zdmc9,a.zdmemo9,a.zdmc10,a.zdmemo10,a.dwlb,a.gg_idm,a.zxypjl,a.zxjldw,  
      convert(varchar(64), @yymc) as yymc  
     into #temp_zz_result_sc_rb_1  
  
  from #tmp_zz_result a(nolock)  
  order by a.fzxh
  --a.cfwz,a.xh,a.sxh  lj20191124药房配药打印模板显示错乱
         
  --update by winning-dingsong-chongqing on 20200706 增加排序【order by sxh】
  if @dyfileterbz=0   
        begin  
            select a.*,b.本处方金额合计 from #temp_zz_result_sc_rb_1  a left join #tmp_result_cfje b on a.xh=b.xh
			order by sxh  
        end  
        else if @dyfileterbz=1   
        begin  
             exec('select a.*,b.本处方金额合计 from #temp_zz_result_sc_rb_1 a left join #tmp_result_cfje b on a.xh=b.xh  where ypyf0 in ('+@strfilter+') order by sxh  ')  
        end  
        else if @dyfileterbz=2   
        begin  
            exec('select a.*,b.本处方金额合计 from #temp_zz_result_sc_rb_1 a left join #tmp_result_cfje b on a.xh=b.xh  where ypyf0 not in ('+@strfilter+') order by sxh  ')  
        end  
 end  
 else  
 begin    -----年表  
  --sang+++ 2011-07-27 创建报表抬头内容 masterbedpipline  
  --注意抬头 只能是一条记录 字段不够，可修改相应sql，自行调整  
  select top 1 e.cardno 卡号,e.blh 病历号,e.hzxm 患者姓名,e.sex 性别,e.birth 出生年月,  
  (dbo.FUN_GETBRNL(e.birth,convert(char(8),getdate(),112)+convert(char(8),getdate(),8),1,0,null))  年龄,  
  (dbo.FUN_GETBRNL(e.birth,convert(char(8),getdate(),112)+convert(char(8),getdate(),8),0,0,null)) 岁数,  
  e.sfzh 身份证, b.ybsm 费别,b.pzlx,e.pzh,e.dwbm, e.dwmc ,e.lxdz 联系地址,e.lxdh 联系电话,c.name as dymc ,e.qtkh,e.dyid,  
  s.lrrq kfrq,s.tmhdbz,case s.tmhdbz when 1 then '已核对' else '未核对' end as tmhdbz_sm  
  into #tmp_title_nb  
  from SF_BRXXK e (nolock)   
   inner join VW_MZBRJSK d(nolock) on d.patid=e.patid  
   inner join VW_MZCFK s(nolock) on  d.sjh=s.jssjh  
   left join YY_YBFLK b (nolock) on e.ybdm=b.ybdm  
   left join YY_BRDYLYK c(nolock) on  e.dyid=c.id  
  where s.jssjh=@jssjh  
    
  --将抬头和明细联合起来   
  select @cfwz cfwz,xh mzcfk_xh,  
      a.卡号,a.病历号,a.患者姓名,a.性别,a.出生年月,a.年龄,a.岁数,a.身份证,a.费别,a.pzlx,a.pzh,a.dwbm,a.dwmc,  
      a.联系地址,a.联系电话,a.dymc,a.qtkh,a.dyid,a.kfrq,a.tmhdbz,a.tmhdbz_sm,  
      b.bmmc,b.ypmc,b.ypgg,b.lsj,b.sl,b.je,b.ypdw,b.pyrq,b.fyckmc,b.ysmc,b.sfymc,b.xh,b.sfrq,b.cfts,  
      b.ypjl,b.jldw,b.频次,b.天数,b.ypyf,b.ypyf0,b.yznr,b.加收代煎费标志,b.zt,b.sxh,b.xdfxh,b.xdfmc,  
      b.发药标志,b.fzbz,b.退费标志,b.jssjh,b.fyckdm,b.ksdm,b.ksmc,b.ybdm,b.ybsm,b.memo,b.mjzbz,b.zc_mc,  
      b.pyckdm,b.fph,b.fysm,b.cfsm,b.yflsh,b.cfk_yflsh,b.fyckxh,b.patid,b.cd_idm,b.ypbz,b.zfbz,b.zfbl,  
      b.flzfbz,b.bxbz,b.cjmc,b.特殊标志,b.ypgg2,b.sfdr,b.cf_yznr,b.cf_ypyf,b.zpwzbh,b.ypmc_lc,b.lcjsdj,  
      b.dzyzimage,b.psbz,b.gfbz,b.gfmc,b.ybmc,b.ypmemo,b.cfjyfs,b.zddm,b.zdmc,b.ghxh,b.cflx,b.pyczyh,  
      b.hjxh,b.txh,b.cfypsl,b.外送标志,b.fzxh,b.自包标志,b.yfdm,b.zdmc1,b.zdmemo1,b.zdmc2,b.zdmemo2,  
      b.zdmc3,b.zdmemo3,b.zdmc4,b.zdmemo4,b.zdmc5,b.zdmemo5,b.zdmc6,b.zdmemo6,b.zdmc7,b.zdmemo7,b.zdmc8,  
      b.zdmemo8,b.zdmc9,b.zdmemo9,b.zdmc10,b.zdmemo10,b.dwlb,b.gg_idm,b.zxypjl,b.zxjldw   
  into #tmp_zz_result_nb   
  from #tmp_title_nb a(nolock),#tmp_result b(nolock)  
  
  update #tmp_zz_result_nb set cfwz=b.cfwz  
  from #tmp_zz_result_nb a(nolock),YF_YFZKC b(nolock)  
  where a.yfdm=b.ksdm and a.cd_idm=b.cd_idm  
  
  select a.cfwz,a.mzcfk_xh,a.卡号,a.病历号,a.患者姓名,a.性别,a.出生年月,a.年龄,a.岁数,a.身份证,a.费别,  
      a.pzlx,a.pzh,a.dwbm,a.dwmc,a.联系地址,a.联系电话,a.dymc,a.qtkh,a.dyid,a.kfrq,a.tmhdbz,a.tmhdbz_sm,  
      a.bmmc,a.ypmc,a.ypgg,a.lsj,a.sl,a.je,a.ypdw,a.pyrq,a.fyckmc,a.ysmc,a.sfymc,a.xh,a.sfrq,a.cfts,  
      a.ypjl,a.jldw,a.频次,a.天数,a.ypyf,a.ypyf0,a.yznr,a.加收代煎费标志,a.zt,a.sxh,a.xdfxh,a.xdfmc,  
      a.发药标志,a.fzbz,a.退费标志,a.jssjh,a.fyckdm,a.ksdm,a.ksmc,a.ybdm,a.ybsm,a.memo,a.mjzbz,a.zc_mc,  
      a.pyckdm,a.fph,a.fysm,a.cfsm,a.yflsh,a.cfk_yflsh,a.fyckxh,a.patid,a.cd_idm,a.ypbz,a.zfbz,a.zfbl,  
      a.flzfbz,a.bxbz,a.cjmc,a.特殊标志,a.ypgg2,a.sfdr,a.cf_yznr,a.cf_ypyf,a.zpwzbh,a.ypmc_lc,a.lcjsdj,  
      a.dzyzimage,a.psbz,a.gfbz,a.gfmc,a.ybmc,a.ypmemo,a.cfjyfs,a.zddm,a.zdmc,a.ghxh,a.cflx,a.pyczyh,  
      a.hjxh,a.txh,a.cfypsl,a.外送标志,a.fzxh,a.自包标志,a.yfdm,a.zdmc1,a.zdmemo1,a.zdmc2,a.zdmemo2,  
      a.zdmc3,a.zdmemo3,a.zdmc4,a.zdmemo4,a.zdmc5,a.zdmemo5,a.zdmc6,a.zdmemo6,a.zdmc7,a.zdmemo7,a.zdmc8,  
      a.zdmemo8,a.zdmc9,a.zdmemo9,a.zdmc10,a.zdmemo10,a.dwlb,a.gg_idm,a.zxypjl,a.zxjldw,  
     convert(varchar(64), @yymc) as yymc  
  into #temp_zz_result_sc_nb_1      
  from #tmp_zz_result_nb a(nolock)  
  order by a.cfwz,a.xh,a.sxh   
  
  if @dyfileterbz=0   
        begin  
            select a.*,b.本处方合计金额 from #temp_zz_result_sc_nb_1  a left join #tmp_result_cfje b on a.xh=b.xh    
        end  
        else if @dyfileterbz=1   
        begin  
             exec('select a.*,b.本处方合计金额 from #temp_zz_result_sc_nb_1 a left join #tmp_result_cfje b on a.xh=b.xh  where ypyf0 in ('+@strfilter+')')  
        end  
        else if @dyfileterbz=2   
        begin  
            exec('select a.*,b.本处方合计金额 from #temp_zz_result_sc_nb_1 a left join #tmp_result_cfje b on a.xh=b.xh  where ypyf0 not in ('+@strfilter+')')  
        end  
    
 end  
 return   
end 




