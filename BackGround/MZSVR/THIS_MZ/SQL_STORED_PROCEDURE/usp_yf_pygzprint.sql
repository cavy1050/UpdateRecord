alter procedure usp_yf_pygzprint    
 @jssjh   ut_lsh,      --�����վݺ�    
 @cfxhgroup  varchar(255),     --���������   
 @pqbz  ut_bz=0,      --ƿǩ��־0 �� 1 ��,2ҩ��  
 @cxbz  ut_bz=0,   --��ѯ��־(0�ձ�,1���)  
 @dybz       ut_bz=0 ,      --��ӡ��־��0�Զ���ӡ��1����  
 @dyfileterbz ut_bz=0 ,          --��ӡ���˱�־ 0 ������ 1 ���˲���3336�����÷� 2 ����3336 û�����õ��÷�  
 @ydxhlist varchar(8000)='',      --ҩ����ż���  
    @czyh ut_czyh ='00'  
as --��439554 2018-10-29 19:59:36 4.0��׼��  
/**********    
[�汾��]4.0.0.0.0    
[����ʱ��]2004.10.29    
[����] ��־��    
[��Ȩ] Copyright ? 2004-2008�Ϻ����˴�-��������ɷ����޹�˾  
[����] ����ϵͳ--��ҩ��ӡ����    
[����˵��]    
 ��ҩ��ӡ����     
[����˵��]    
  
[����ֵ]    
[�����������]    
[���õ�sp]    
[����ʵ��]    
  select top 5 * from SF_MZCFK where pybz=1 and hjxh<>0 and pyrq like '2007%' order by pyrq desc  
  exec usp_yf_pygzprint  "20150915000014","122444"  
  exec usp_yf_pygzprint  "200704128590007  ","14383"  
  exec usp_yf_pygzprint  "20081216000016","9767"--��Clientdataset��  
[�޸ļ�¼]    
 Modify By : Koala In : 2004-05-10  For : ҩƷ����ǰ���ӳ����־(���ҽ��վ������Ϣ)    
 Modify By : Koala In : 2004-06-07  For : ������ҩ���ڴ���Ĵ���    
 Modify By : Koala In : 2004-06-08  For : ��������������λ��Ƶ�Ρ��������÷���Ϣ������ʾ�������÷��������    
    modify by : zyp     in : 2005-03-04     for : �ӳ���,�ӱ���        
    yxp 2005-4-27 �������־�����մ���ѱ�־YK_TSBZK s (nolock)    
    modify by : yxp     in : 2005-4-28 For xdfxh,xdfmcӦ�ô����ֶ���  
 modify by gzy at 20050520 ����ҩ����ҩ���  
 modify by yxp 20050531 �����ҩƷ��Ҫ��ӡ��һ��  
 modify by gzy at 20050619 �޸ĵ����޸ķ�Ʊ�ٴ�ӡʱû���÷���BUG  
 yxp 2005-8-26 ���Ӳ���ƿǩ��־@pqbz =0 �Ĵ��룬����һ��ҩƷ��ӡһ��ƿǩ�Ĺ���  
   ��#pyprinttemp��Ϊ@tablename=#py+@jssjh  
 yxp 2005-8-26 �޸���ҩ��ӡ����ʶ���˷Ѵ������˷Ѵ�����������SF_MZCFK��txh��Ϊ0�ļ�¼  
 xujian 2005-09-20 ���ӡ���ҩ��ӡ���÷����ϡ�����ҩƿǩ��ӡ���÷����ϡ�  
 yxp 2005-10-29 ��ѯ��ϸ�������жϲ���H090��ֱ�Ӹ���hjmxxh�ж�  
 yxp 2005-11-1 ����SF_BRJSKʱ����Ҫ����ybjszt=2������  
 yxp 2005-11-11 ����ypjlʱ��ԭ����������HJKʱд����round(a.ypsl/a.dwxs,2) as ypjlӦ���� null as ypjl  
 yxp 2006-3-8 �����Ĳ�ѯ���������ӡ�and isnull(ejygbz,0)=0��  
 mly 2006-03-21 �޸ļ��ﲡ�˻��߼Ҵ����˲�������ҩ��ʾ�����ģ£գǡ�((a.ghsfbz=1 and a.ybjszt=2) or a.ghsfbz=2)  
 yxp 2006-6-8 �����ô��ˣ�Ӧ����3096��������3092 ��ҩʱͬһ���˵Ķ���ҺŵĴ����Ƿ�һ���ӡ  
 yxp 2006-7-3 �÷����ϳ���������֧��100���÷�  
 yxp 2006-7-5 ȥ������3079�Ĺ��ܣ�ԭ��Ϊ�������������ܶ��࣬ʵ�����ô�  
 yxp 2006-7-13 ʹ��@strwhere���ϲ�@arpy��ͬ����µ�sql���  
 yxp 2006-8-29 ����򻯣��ٶ��Ż�:�ֹ�������hjxh=0���ж�;ypyf1,ypyf2�ǿ��ֶΣ�ɾ��;����ʱ��洦����ϸ��ҩƷ��Ϣ  
  ���Ӵ�������cfk_yflsh��ȡ��SF_MZCFK�У��Ժ�JSK��ҩ����ˮ������  
 yxp 2006-9-5 �ֹ�����Ӧ�ð�hjxh<=0���ж�  
 yxp 2006-9-18 ����Ӧ�ô���Ϊ��λС��  
 yxp 2006-9-27 ����������ǵ��Ӵ�����Ӧ��ȡHJCFMXK.ts������̶�Ϊ1  
 yxp 2006-10-11 �ϲ�ʡ���ֳ��޸Ĺ��ܣ�����sfdr'�Ƿ��ղ���'(���ǵ��մ����򴫳��գ����򴫳������մ���������),ypgg2��ҩƷ���*ǰ�����ݡ�  
 yxp 2007-05-14 del SF_MZCFK.jlzt=0�����������⿪��3096����Ϊ��ʱ�����˲����˷Ѻ�û�н�����¼�Ͳ����յļ�¼�ֱ��ӡ����  
 yxp 2007-6-18 ��ȫ����ʱ���Ϊ��ͨ��ʱ�������ɽҽԺ��ҩ��ӡ���������;null as ypjl��Ϊ 0 as ypjl���ⱨ��  
      ���ӡ��������С����������÷������������÷����ơ��Ĵ����������ֶηֱ�Ϊcf_yznr,cf_ypyf,cf_ypyfmc  
    xiaoyan 2007-6-20 ��ӡ��ʱ������ת��λ�ú��ֶ�(zpwzbh)   
 xiaoyan 2007-7-6 ��3016�������ã��ŵ�ҩ������������á�  
 xiaoyan 2007-7-9 ���fyckmc Ϊ�յĻ���ϵͳ���ð����ݲ�����ʱ���У����Ը�Ϊ isnull(d.name , " ")  
 xiaoyan 2007-7-19 ����YK_YPGGMLK���ypmc�ֶ�  
 xiaoyan 2007-7-28 ©�� n.ypyf=q.id   
    yxp 2007-10-31 �ɽ�������ҽԺҩƷ�����HISʵ��:����SF_CFMXK.yylsj�Ĵ���  
    xiaoyan 2007-11-23 ����dzyzimage�ֶ�  
 yxp 2007-10-31 �ɽ�������ҽԺҩƷ���������ҩ���޸ģ�yylsj����ʹ�ã���ȡSF_CFMXK.lcjsdj'�����㵥��'����ӡʱ����lcjsdj��ԭ�����޸�����  
        mly 2008-04-14 ����SF_HJCFMXK.Ƥ�Ա�־�Ĵ���  
 jianglong 2008-05-07 ���ѱ�־,��������,ҽ�����ƵĴ���  
 jl 2008-12-15 ������ҩ��ӡ��ϴ���Ĵ���  
        xjj     2008-12-16     ���ӳ������ʹ���  
    jl 2009-07-15 ���ӷ��ձ��ѯ������ѯ  
    JL 2009-07-16 ����ǲ���������ҩ�˵Ĵ���  
    jl 2009-12-02 ����SF_MZCFK.txh  
    jl  2009-12-31  ����jssjh  
    xwm 2010-08-16  ������ҩ����С��װ�������ʾ����ʾ�ɱ���ģ��������  
    xjj 2011-6-1  �����Ƿ��԰���־  
    grj 2011-12-14 ����ɸ��������ҩ��ϸ  
**********/    
set nocount on    
  
 --��ǰҩƷϵͳʹ�õ��Ǻ��ַ���:    
 --0  ȫԺҩƷͳһ�۸������,    
 --1  ȫԺҩƷͳһ�۸������,���۲��ü�Ȩƽ�����۷���,    
 --2  ȫԺҩƷͳһ���ۼ�,����۹�����,    
 --3  ȫԺҩƷ�����ۼ۹�����    
declare  @ypxtslt int             
select @ypxtslt = dbo.f_get_ypxtslt()    
if @@error<>0    
begin    
 select 'F','��ȡҩƷϵͳģʽ����!'    
 return    
end   
   
declare     @strsql  varchar(8000),     
   @strfybz  varchar(2000),        
   @patid    varchar(12),      
   @strwhere varchar(255),      
   @arpy     ut_bz, --ͬһ����һ���� qxh for fjjg 2006.1.3        
   @pyfybz     ut_bz, --��ҩ�Ƿ��Զ���ӡ xiaoyan 2007-7-6    
   @yfdm       ut_dm2, --ҩ������ xiaoyan 2007-7-6  
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
   @cflx_add varchar(256) --��ӵĲ��Ϲ���  
   ,@config3557 varchar(2)  
   ,@strwhere_ydbd varchar(2000)  
   ,@yymc ut_mc64,   --ҽԺ����  
            @ks_id ut_ksdm,  
      @yydm  ut_dm2  
  
select @ks_id=a.ks_id from YY_ZGBMK a(nolock) where a.id=@czyh  
select @yydm =a.yydm from YY_KSBMK a(nolock) where a.id=@ks_id  
select @yymc=a.name from YY_JBCONFIG a(nolock) where a.id=@yydm  
  
/*���������Ϣ*/  
create table #temp_zdxx  
(   
  ghxh ut_xh12, --�Һ����  
  zddm ut_zdmc, --��ϴ���  
  zdmc  ut_zdmc, --�������  
  zdmc1 ut_zdmc, --�������1  
  zdmc2 ut_zdmc, --�������2  
  zdmc3 ut_zdmc, --�������3  
  zdmc4 ut_zdmc, --�������4  
  zdmc5 ut_zdmc, --�������5  
  zdmc6 ut_zdmc, --�������6  
  zdmc7 ut_zdmc, --�������7  
  zdmc8 ut_zdmc, --�������8  
  zdmc9 ut_zdmc, --�������9  
  zdmc10 ut_zdmc, --�������10  
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
          
select @config3321='��'  
select @config3321=config from YY_CONFIG(nolock) where id='3321'  
  
select @config3529='��'  
select @config3529=LTRIM(rtrim(isnull(config,'��'))) from YY_CONFIG(nolock) where id='3529'   
if (LTRIM(rtrim(@config3529))<>'��') and (LTRIM(rtrim(@config3529))<>'��')    
begin  
    select @config3529='��'  
end  
   
  
select @config3056 =''  
select @config3056=LTRIM(rtrim(isnull(config,''))) from YY_CONFIG(nolock) where id='3056'      
select @config3056 =replace(@config3056,'"','')  
if @@ROWCOUNT= 0  
begin  
   select @config3056 =''  
end   
  
if @config3529 ='��'  
begin  
   select @config3056 =''  
end  
  
select @config3541='��'  
select @config3541=LTRIM(rtrim(isnull(config,'��'))) from YY_CONFIG(nolock) where id='3541'   
if (LTRIM(rtrim(@config3541))<>'��') and (LTRIM(rtrim(@config3541))<>'��')    
begin  
    select @config3541='��'  
end  
  
select @config3557='��'  
select @config3557=LTRIM(rtrim(isnull(config,'��'))) from YY_CONFIG(nolock) where id='3557'   
if (LTRIM(rtrim(@config3557))<>'��') and (LTRIM(rtrim(@config3557))<>'��')    
begin  
    select @config3557='��'  
end  
  
if (@config3557 ='��') and (@ydxhlist<>'')  
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
 SELECT @strtableA='VW_MZCFMXK a(nolock)' --sang 2011-07-29 �ĳ���ͼ  
   
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
 SELECT @strtableC='VW_MZBRJSK l(nolock)'  --sang 2011-07-29 �ĳ���ͼ  
   
IF @cxbz = 0  
 SELECT @strtableD='SF_MZCFK c (nolock)'  
ELSE  
 SELECT @strtableD='VW_MZCFK c (nolock)' --sang 2011-07-29 �ĳ���ͼ   
      
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
and isnull(a.ssbfybz , 0) = 0')  --grj 2011-12-14 ����ɸ��������ҩ��ϸ  
  
  
if (@config3529 ='��') or (@config3056<>'')--(���Ϸ�����)  
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
  
if (@config3541='��')--(3541���Ϸ�����)  
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
if exists(select 1 from YY_CONFIG (nolock) where id = '3096' and config = '��')                   
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
     
declare @pyyf_sfxm  varchar(2000)  --ҩƷ�÷�����,����@pqbz�䶯    
      
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
                                                              
if @pyfybz=1 --��ҩ�Ƿ��Զ���ҩ 1 �ǣ� 0 ��   
begin   
    select @strfybz = ',case when c.fybz = 1 then "�ѷ�ҩ" else "��治��δ��ҩ" end "��ҩ��־" '   
end    
else  
begin    
    select @strfybz = ',case when c.fybz = 1 then "�ѷ�ҩ" else "δ��ҩ" end "��ҩ��־" '    
end   
  
select a.bmmc,case when isnull(n.zbz,0)=0 then " " when isnull(n.zbz,0)=1 then "��"     
when isnull(n.zbz,0)>1 then "��" when isnull(n.zbz,0) =-1 then "��" else "��" end + a.ypmc  ypmc ,      
a.ypgg,round(a.ylsj*a.dwxs/a.ykxs,4) as lsj, round(a.ypsl/a.dwxs,2) as sl,      
round(a.ypsl*a.ylsj*a.cfts/a.ykxs,2) as je, a.ypdw,substring(c.pyrq,1,4)+"��"+substring(c.pyrq,5,2)      
+"��"+substring(c.pyrq,7,2)+"��" pyrq, d.name fyckmc,e.name ysmc,f.name sfymc,c.xh,substring(c.lrrq,1,4)      
+"-"+substring(c.lrrq,5,2)+"-"+substring(c.lrrq,7,2)+" "+substring(c.lrrq,9,5) sfrq,c.cfts,       
n.ypjl, n.jldw, o.xsmc "Ƶ��",n.ts "����", p.name ypyf,n.ypyf as ypyf0, n.memo yznr,    
case when isnull(m.jsdjfbz,0)=1 then "���մ����" else " " end "���մ���ѱ�־",n.memo zt,    
n.xh as sxh,m.xdfxh,m.xdfmc,"��治��δ��ҩ" "��ҩ��־"    
, 0 fzbz, case when isnull(c.txh,0)<>0 then "�˷�" else "" end "�˷ѱ�־",    
c.jssjh,c.fyckdm ,c.ksdm,k.name ksmc,t.ybdm,t.ybsm,t.memo,    
l.mjzbz,e.zc_mc, c.pyckdm, l.fph ,a.fysm,a.cfsm,l.yflsh, c.yflsh as cfk_yflsh, c.fyckxh,     
l.patid, a.cd_idm, a.ypbz,a.zfbz, a.zfbl, a.flzfbz,a.bxbz,a.cjmc,    
case when a.yptsbz in (1,2,3) then a.yptsmc else " " end  "�����־",    
case charindex("*",a.ypgg) when 0 then a.ypgg else  substring(a.ypgg,1,charindex("*",a.ypgg)-1) end ypgg2,    
case when substring(c.lrrq,1,8)<>convert(varchar(30),getdate(),112) then "���մ���" else "  " end sfdr    
,m.memo as cf_yznr, m.cfypyf as cf_ypyf, c.zpwzbh, a.ypmc_lc    
,round(a.lcjsdj*a.dwxs/a.ykxs,4) lcjsdj, e.dzyzimage,n.psbz,a.gfbz,a.gfmc,a.ybmc,a.ypmemo,    
m.cfjyfs,convert(varchar(20),"") as zddm,convert(varchar(256),"") as zdmc,m.ghxh,c.cflx,c.pyczyh,c.hjxh,c.txh,   
n.cfypsl,case isnull(m.wsbz,0) when 1 then "����" else "������" end as "���ͱ�־",isnull(n.fzxh,0) fzxh,  
case isnull(m.zbbz,0) when 1 then "�԰�" else "" end as "�԰���־",c.yfdm,  
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
  
--��ӵ��Ӵ���    
select @strsql = 'insert INTO #pydy_tmp(bmmc,ypmc,ypgg,lsj,sl,je,ypdw,pyrq,fyckmc,ysmc,sfymc,xh,sfrq,cfts,ypjl,  
jldw,Ƶ��,����,ypyf,ypyf0,yznr,���մ���ѱ�־,zt,sxh,xdfxh,xdfmc,��ҩ��־,fzbz,�˷ѱ�־,jssjh,fyckdm,ksdm,ksmc,ybdm,  
ybsm,memo,mjzbz,zc_mc,pyckdm,fph,fysm,cfsm,yflsh,cfk_yflsh,fyckxh,patid,cd_idm,ypbz,zfbz,zfbl,flzfbz,bxbz,  
cjmc,�����־,ypgg2,sfdr,cf_yznr,cf_ypyf,zpwzbh,ypmc_lc,lcjsdj,dzyzimage,psbz,gfbz,gfmc,ybmc,ypmemo,cfjyfs,zddm,zdmc,  
ghxh,cflx,pyczyh,hjxh,txh,cfypsl,���ͱ�־,fzxh,�԰���־,yfdm,zdmc1,zdmemo1,zdmc2,zdmemo2,zdmc3,zdmemo3,zdmc4,zdmemo4,zdmc5,  
zdmemo5,zdmc6,zdmemo6,zdmc7,zdmemo7,zdmc8,zdmemo8,zdmc9,zdmemo9,zdmc10,zdmemo10,dwlb,gg_idm,zxypjl,zxjldw,cfmxxh)   
select a.bmmc,case when isnull(n.zbz,0)=0 then " " when isnull(n.zbz,0)=1 then "��"     
when isnull(n.zbz,0)>1 then "��" when isnull(n.zbz,0) =-1 then "��" else "��" end + a.ypmc  ypmc ,      
a.ypgg,round(a.ylsj*a.dwxs/a.ykxs,4) as lsj, round(a.ypsl/a.dwxs,2) as sl,      
round(a.ypsl*a.ylsj*a.cfts/a.ykxs,2) as je, a.ypdw,substring(c.pyrq,1,4)+"��"+substring(c.pyrq,5,2)      
+"��"+substring(c.pyrq,7,2)+"��" pyrq, isnull(d.name," ") fyckmc,  isnull(e.name," ") ysmc, isnull(f.name," ") sfymc,c.xh,substring(c.lrrq,1,4)      
+"-"+substring(c.lrrq,5,2)+"-"+substring(c.lrrq,7,2)+" "+substring(c.lrrq,9,5) sfrq,c.cfts,       
n.ypjl, n.jldw, o.xsmc "Ƶ��",n.ts "����", isnull(p.name," ") ypyf, isnull(n.ypyf," ") as ypyf0, n.memo yznr,    
case when isnull(m.jsdjfbz,0)=1 then "���մ����" else " " end "���մ���ѱ�־",n.memo zt,    
n.xh as sxh,m.xdfxh,m.xdfmc'+@strfybz+'     
, 0 fzbz, case when isnull(c.txh,0)<>0 then "�˷�" else "" end "�˷ѱ�־",    
c.jssjh,c.fyckdm ,c.ksdm,k.name ksmc,t.ybdm,t.ybsm,t.memo,    
l.mjzbz,e.zc_mc, c.pyckdm, l.fph ,a.fysm,a.cfsm,l.yflsh, c.yflsh as cfk_yflsh, c.fyckxh,     
l.patid, a.cd_idm, a.ypbz,a.zfbz, a.zfbl, a.flzfbz,a.bxbz,a.cjmc,    
case when a.yptsbz in (1,2,3) then a.yptsmc else " " end  "�����־",    
case charindex("*",a.ypgg) when 0 then a.ypgg else  substring(a.ypgg,1,charindex("*",a.ypgg)-1) end ypgg2,    
case when substring(c.lrrq,1,8)<>convert(varchar(30),getdate(),112) then "���մ���" else "  " end sfdr     
,m.memo as cf_yznr, m.cfypyf as cf_ypyf,  c.zpwzbh , a.ypmc_lc    ---q.name as cf_ypyfmc,--edit by xiaoyan 2007-7-19    
,round(a.lcjsdj*a.dwxs/a.ykxs,4) lcjsdj, e.dzyzimage,n.psbz,a.gfbz,a.gfmc,a.ybmc,a.ypmemo,m.cfjyfs,"","",m.ghxh,c.cflx,c.pyczyh,c.hjxh,c.txh,isnull(n.cfypsl,""),  
case isnull(m.wsbz,0) when 1 then "����" else "������" end as "���ͱ�־",isnull(n.fzxh,0) fzxh, case isnull(m.zbbz,0) when 1 then "�԰�" else "" end as �԰���־,c.yfdm,      --add jl 2008-05-07   
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
   
--��Ӷ��⴦�����ͣ�cflx =4��  
  
if (@config3529='��')and(@config3056<>'')  
begin  
 select @strsql = 'insert INTO #pydy_tmp(bmmc,ypmc,ypgg,lsj,sl,je,ypdw,pyrq,fyckmc,ysmc,sfymc,xh,sfrq,cfts,ypjl,  
 jldw,Ƶ��,����,ypyf,ypyf0,yznr,���մ���ѱ�־,zt,sxh,xdfxh,xdfmc,��ҩ��־,fzbz,�˷ѱ�־,jssjh,fyckdm,ksdm,ksmc,ybdm,  
 ybsm,memo,mjzbz,zc_mc,pyckdm,fph,fysm,cfsm,yflsh,cfk_yflsh,fyckxh,patid,cd_idm,ypbz,zfbz,zfbl,flzfbz,bxbz,  
 cjmc,�����־,ypgg2,sfdr,cf_yznr,cf_ypyf,zpwzbh,ypmc_lc,lcjsdj,dzyzimage,psbz,gfbz,gfmc,ybmc,ypmemo,cfjyfs,zddm,zdmc,  
 ghxh,cflx,pyczyh,hjxh,txh,cfypsl,���ͱ�־,fzxh,�԰���־,yfdm,zdmc1,zdmemo1,zdmc2,zdmemo2,zdmc3,zdmemo3,zdmc4,zdmemo4,zdmc5,  
 zdmemo5,zdmc6,zdmemo6,zdmc7,zdmemo7,zdmc8,zdmemo8,zdmc9,zdmemo9,zdmc10,zdmemo10,dwlb,gg_idm,zxypjl,zxjldw,cfmxxh)   
 select a.bmmc,case when isnull(n.zbz,0)=0 then " " when isnull(n.zbz,0)=1 then "��"     
 when isnull(n.zbz,0)>1 then "��" when isnull(n.zbz,0) =-1 then "��" else "��" end + a.ypmc  ypmc ,      
 a.ypgg,round(a.ylsj*a.dwxs/a.ykxs,4) as lsj, round(a.ypsl/a.dwxs,2) as sl,      
 round(a.ypsl*a.ylsj*a.cfts/a.ykxs,2) as je, a.ypdw,substring(c.pyrq,1,4)+"��"+substring(c.pyrq,5,2)      
 +"��"+substring(c.pyrq,7,2)+"��" pyrq, isnull(d.name," ") fyckmc,  isnull(e.name," ") ysmc, isnull(f.name," ") sfymc,c.xh,substring(c.lrrq,1,4)      
 +"-"+substring(c.lrrq,5,2)+"-"+substring(c.lrrq,7,2)+" "+substring(c.lrrq,9,5) sfrq,c.cfts,       
 n.ypjl, n.jldw, o.xsmc "Ƶ��",isnull(n.ts,0) "����", isnull(p.name," ") ypyf, isnull(n.ypyf," ") as ypyf0, n.memo yznr,      
    case when isnull(m.jsdjfbz,0)=1 then "���մ����" else " " end "���մ���ѱ�־",n.memo zt,      
    isnull(n.xh,0) as sxh,m.xdfxh,m.xdfmc'+@strfybz+'      
 , 0 fzbz, case when isnull(c.txh,0)<>0 then "�˷�" else "" end "�˷ѱ�־",    
 c.jssjh,c.fyckdm ,c.ksdm,k.name ksmc,t.ybdm,t.ybsm,t.memo,    
 l.mjzbz,e.zc_mc, c.pyckdm, l.fph ,a.fysm,a.cfsm,l.yflsh, c.yflsh as cfk_yflsh, c.fyckxh,     
 l.patid, a.cd_idm, a.ypbz,a.zfbz, a.zfbl, a.flzfbz,a.bxbz,a.cjmc,    
 case when a.yptsbz in (1,2,3) then a.yptsmc else " " end  "�����־",    
 case charindex("*",a.ypgg) when 0 then a.ypgg else  substring(a.ypgg,1,charindex("*",a.ypgg)-1) end ypgg2,    
 case when substring(c.lrrq,1,8)<>convert(varchar(30),getdate(),112) then "���մ���" else "  " end sfdr     
 ,m.memo as cf_yznr, m.cfypyf as cf_ypyf,  c.zpwzbh , a.ypmc_lc    ---q.name as cf_ypyfmc,--edit by xiaoyan 2007-7-19    
 ,round(a.lcjsdj*a.dwxs/a.ykxs,4) lcjsdj, e.dzyzimage,n.psbz,a.gfbz,a.gfmc,a.ybmc,a.ypmemo,m.cfjyfs,"","",m.ghxh,c.cflx,c.pyczyh,c.hjxh,c.txh,isnull(n.cfypsl,""),  
 case isnull(m.wsbz,0) when 1 then "����" else "������" end as "���ͱ�־",isnull(n.fzxh,0) fzxh, case isnull(m.zbbz,0) when 1 then "�԰�" else "" end as �԰���־,c.yfdm,      --add jl 2008-05-07   
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
  
if (@config3541='��') --����  
begin  
 select @strsql = 'insert INTO #pydy_tmp(bmmc,ypmc,ypgg,lsj,sl,je,ypdw,pyrq,fyckmc,ysmc,sfymc,xh,sfrq,cfts,ypjl,  
 jldw,Ƶ��,����,ypyf,ypyf0,yznr,���մ���ѱ�־,zt,sxh,xdfxh,xdfmc,��ҩ��־,fzbz,�˷ѱ�־,jssjh,fyckdm,ksdm,ksmc,ybdm,  
 ybsm,memo,mjzbz,zc_mc,pyckdm,fph,fysm,cfsm,yflsh,cfk_yflsh,fyckxh,patid,cd_idm,ypbz,zfbz,zfbl,flzfbz,bxbz,  
 cjmc,�����־,ypgg2,sfdr,cf_yznr,cf_ypyf,zpwzbh,ypmc_lc,lcjsdj,dzyzimage,psbz,gfbz,gfmc,ybmc,ypmemo,cfjyfs,zddm,zdmc,  
 ghxh,cflx,pyczyh,hjxh,txh,cfypsl,���ͱ�־,fzxh,�԰���־,yfdm,zdmc1,zdmemo1,zdmc2,zdmemo2,zdmc3,zdmemo3,zdmc4,zdmemo4,zdmc5,  
 zdmemo5,zdmc6,zdmemo6,zdmc7,zdmemo7,zdmc8,zdmemo8,zdmc9,zdmemo9,zdmc10,zdmemo10,dwlb,gg_idm,zxypjl,zxjldw,cfmxxh)   
 select a.bmmc,case when isnull(n.zbz,0)=0 then " " when isnull(n.zbz,0)=1 then "��"     
 when isnull(n.zbz,0)>1 then "��" when isnull(n.zbz,0) =-1 then "��" else "��" end + a.ypmc  ypmc ,      
 a.ypgg,round(a.ylsj*a.dwxs/a.ykxs,4) as lsj, round(a.ypsl/a.dwxs,2) as sl,      
 round(a.ypsl*a.ylsj*a.cfts/a.ykxs,2) as je, a.ypdw,substring(c.pyrq,1,4)+"��"+substring(c.pyrq,5,2)      
 +"��"+substring(c.pyrq,7,2)+"��" pyrq, isnull(d.name," ") fyckmc,  isnull(e.name," ") ysmc, isnull(f.name," ") sfymc,c.xh,substring(c.lrrq,1,4)      
 +"-"+substring(c.lrrq,5,2)+"-"+substring(c.lrrq,7,2)+" "+substring(c.lrrq,9,5) sfrq,c.cfts,       
 n.ypjl, n.jldw, o.xsmc "Ƶ��",isnull(n.ts,0) "����", isnull(p.name," ") ypyf, isnull(n.ypyf," ") as ypyf0, n.memo yznr,      
    case when isnull(m.jsdjfbz,0)=1 then "���մ����" else " " end "���մ���ѱ�־",n.memo zt,      
    isnull(n.xh,0) as sxh,m.xdfxh,m.xdfmc'+@strfybz+'      
 , 0 fzbz, case when isnull(c.txh,0)<>0 then "�˷�" else "" end "�˷ѱ�־",    
 c.jssjh,c.fyckdm ,c.ksdm,k.name ksmc,t.ybdm,t.ybsm,t.memo,    
 l.mjzbz,e.zc_mc, c.pyckdm, l.fph ,a.fysm,a.cfsm,l.yflsh, c.yflsh as cfk_yflsh, c.fyckxh,     
 l.patid, a.cd_idm, a.ypbz,a.zfbz, a.zfbl, a.flzfbz,a.bxbz,a.cjmc,    
 case when a.yptsbz in (1,2,3) then a.yptsmc else " " end  "�����־",    
 case charindex("*",a.ypgg) when 0 then a.ypgg else  substring(a.ypgg,1,charindex("*",a.ypgg)-1) end ypgg2,    
 case when substring(c.lrrq,1,8)<>convert(varchar(30),getdate(),112) then "���մ���" else "  " end sfdr     
 ,m.memo as cf_yznr, m.cfypyf as cf_ypyf,  c.zpwzbh , a.ypmc_lc    ---q.name as cf_ypyfmc,--edit by xiaoyan 2007-7-19    
 ,round(a.lcjsdj*a.dwxs/a.ykxs,4) lcjsdj, e.dzyzimage,n.psbz,a.gfbz,a.gfmc,a.ybmc,a.ypmemo,m.cfjyfs,"","",m.ghxh,c.cflx,c.pyczyh,c.hjxh,c.txh,isnull(n.cfypsl,""),  
 case isnull(m.wsbz,0) when 1 then "����" else "������" end as "���ͱ�־",isnull(n.fzxh,0) fzxh, case isnull(m.zbbz,0) when 1 then "�԰�" else "" end as �԰���־,c.yfdm,      --add jl 2008-05-07   
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
  
if exists (select 1 from YY_CONFIG(nolock) where id ='3147' and config ='��') and (@strwhere_ypyf='')  --����ֹ�����  
begin  
select @strsql = 'insert INTO #pydy_tmp(bmmc,ypmc,ypgg,lsj,sl,je,ypdw,pyrq,fyckmc,ysmc,sfymc,xh,sfrq,cfts,ypjl,  
jldw,Ƶ��,����,ypyf,ypyf0,yznr,���մ���ѱ�־,zt,sxh,xdfxh,xdfmc,��ҩ��־,fzbz,�˷ѱ�־,jssjh,fyckdm,ksdm,ksmc,ybdm,  
ybsm,memo,mjzbz,zc_mc,pyckdm,fph,fysm,cfsm,yflsh,cfk_yflsh,fyckxh,patid,cd_idm,ypbz,zfbz,zfbl,flzfbz,bxbz,  
cjmc,�����־,ypgg2,sfdr,cf_yznr,cf_ypyf,zpwzbh,ypmc_lc,lcjsdj,dzyzimage,psbz,gfbz,gfmc,ybmc,ypmemo,cfjyfs,zddm,zdmc,  
ghxh,cflx,pyczyh,hjxh,txh,cfypsl,���ͱ�־,fzxh,�԰���־,yfdm,zdmc1,zdmemo1,zdmc2,zdmemo2,zdmc3,zdmemo3,zdmc4,zdmemo4,zdmc5,  
zdmemo5,zdmc6,zdmemo6,zdmc7,zdmemo7,zdmc8,zdmemo8,zdmc9,zdmemo9,zdmc10,zdmemo10,dwlb,gg_idm,zxypjl,zxjldw,cfmxxh)      
select a.bmmc,a.ypmc ypmc,a.ypgg,round(a.ylsj*a.dwxs/a.ykxs,4) as lsj, round(a.ypsl/a.dwxs,2) as sl,        
round(a.ypsl*a.ylsj*a.cfts/a.ykxs,2) as je, a.ypdw,substring(c.pyrq,1,4)+"��"+      
substring(c.pyrq,5,2)+"��"+substring(c.pyrq,7,2)+"��" pyrq, isnull(d.name," ") fyckmc, isnull(e.name," ") ysmc,      
isnull(f.name," ") sfymc,c.xh,substring(c.lrrq,1,4)+"-"+substring(c.lrrq,5,2)+"-"+substring(c.lrrq,7,2)+" "+      
substring(c.lrrq,9,5) sfrq,c.cfts,    
0 as ypjl , a.ypdw," ", 1 as ts, " " ypyf," " as ypyf0," " yznr,    
" " "���մ���ѱ�־",a.memo zt,     
a.xh as sxh,0 xdfxh," " xdfmc'+@strfybz+'    
, 0 fzbz, case when isnull(c.txh,0)<>0 then "�˷�" else "" end "�˷ѱ�־",    
c.jssjh,c.fyckdm ,c.ksdm,k.name ksmc,t.ybdm,t.ybsm,t.memo,    
l.mjzbz,e.zc_mc, c.pyckdm, l.fph ,a.fysm,a.cfsm,l.yflsh, c.yflsh as cfk_yflsh, c.fyckxh,     
l.patid, a.cd_idm, a.ypbz,a.zfbz, a.zfbl, a.flzfbz,a.bxbz,a.cjmc,    
case when a.yptsbz in (1,2,3) then a.yptsmc else " " end  "�����־",    
case charindex("*",a.ypgg) when 0 then a.ypgg else  substring(a.ypgg,1,charindex("*",a.ypgg)-1) end ypgg2,    
case when substring(c.lrrq,1,8)<>convert(varchar(30),getdate(),112) then "���մ���" else "  " end sfdr    
,"" as cf_yznr, "" as cf_ypyf,  c.zpwzbh , a.ypmc_lc    ----"" as cf_ypyfmc,--edit by xiaoyan 2007-7-19    
,round(a.lcjsdj*a.dwxs/a.ykxs,4) lcjsdj, e.dzyzimage,-1 as psbz,a.gfbz,a.gfmc,a.ybmc,a.ypmemo,0,"","",0,c.cflx,c.pyczyh,c.hjxh,c.txh,"","������" as "���ͱ�־",0 fzxh  
,"" as �԰���־,c.yfdm,  
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
  
if (@pqbz=2) and (@dybz=0) --��ӡҩ����ʱ����Ҫ��ӡ���jlzt=2�Ĵ���  
begin  
 ---ȥ����������  
 delete a from #pydy_tmp a inner join SF_MZCFK b(nolock) on a.xh=b.xh   
 where b.jlzt=2  
end  
    
--------------���Ӵ�����С������λ   
UPDATE  a   
SET a.zxypjl=CASE WHEN a.dwlb=0 THEN ceiling(a.ypjl/b.ggxs) ELSE  a.ypjl END,  
    a.zxjldw=CASE WHEN a.dwlb=0 THEN b.zxdw ELSE  a.jldw END  
FROM #pydy_tmp a,YK_YPGGMLK b(nolock)   
WHERE a.gg_idm>0 and a.gg_idm=b.idm   
AND b.tybz=0 AND a.dwlb=0    
  
/*���������Ϣ*/  
  
declare @sycfzdfs ut_bz  
select @sycfzdfs=config from YY_CONFIG where id='H195' --ʹ�ô�����Ϸ�ʽ[0����1ʹ��]  
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
  
--ͨ��txh����jssjh  
update a set a.jssjh=b.jssjh from #pydy_tmp a,SF_MZCFK b(nolock) where a.txh=b.xh   

--���Ӳ�ҩ����¼����Ϣ --add by yangdi 2020.6.10
/*
select x.CYCYJX+' �� '+CONVERT(VARCHAR(2),a.cfts)+' �� �÷�: '+x.CYYYFF+' ÿ '+CONVERT(VARCHAR(2),x.CYMRJL)+' ��һ��,�� '+CONVERT(VARCHAR(2),x.CYFYCS)+' ���� '+x.CYFYYQ,* from #pydy_tmp a
	INNER JOIN dbo.SF_HJCFK c ON a.hjxh=c.xh
	INNER JOIN CISDB.dbo.OUTP_ORDER x ON c.v5xh=x.XH
*/

UPDATE a SET a.cf_yznr=x.CYCYJX+' �� '+CONVERT(VARCHAR(2),a.cfts)+' �� �÷�: '+x.CYYYFF+' ÿ '+CONVERT(VARCHAR(2),x.CYMRJL)+' ��һ��,�� '+CONVERT(VARCHAR(2),x.CYFYCS)+' ���� '+x.CYFYYQ
from #pydy_tmp a
	INNER JOIN dbo.SF_HJCFK c ON a.hjxh=c.xh
	INNER JOIN CISDB.dbo.OUTP_ORDER x ON c.v5xh=x.XH
  
  
select a.bmmc,a.ypmc,a.ypgg,a.lsj,a.sl,a.je,a.ypdw,a.pyrq,a.fyckmc,a.ysmc,a.sfymc,a.xh,a.sfrq,  
       a.cfts,a.ypjl,a.jldw,a.Ƶ��,a.����,a.ypyf,a.ypyf0,a.yznr,a.���մ���ѱ�־,a.zt,a.sxh,a.xdfxh,  
       a.xdfmc,a.��ҩ��־,a.fzbz,a.�˷ѱ�־,a.jssjh,a.fyckdm,a.ksdm,a.ksmc,a.ybdm,a.ybsm,a.memo,a.mjzbz,  
       a.zc_mc,a.pyckdm,a.fph,a.fysm,a.cfsm,a.yflsh,a.cfk_yflsh,a.fyckxh,a.patid,a.cd_idm,a.ypbz,a.zfbz,  
       a.zfbl,a.flzfbz,a.bxbz,a.cjmc,a.�����־,a.ypgg2,a.sfdr,a.cf_yznr,a.cf_ypyf,a.zpwzbh,a.ypmc_lc,  
       a.lcjsdj,a.dzyzimage,a.psbz,a.gfbz,a.gfmc,a.ybmc,a.ypmemo,a.cfjyfs,a.zddm,a.zdmc,a.ghxh,a.cflx,  
       a.pyczyh,a.hjxh,a.txh,a.cfypsl,a.���ͱ�־,a.fzxh,a.�԰���־,a.yfdm,a.zdmc1,a.zdmemo1,a.zdmc2,  
       a.zdmemo2,a.zdmc3,a.zdmemo3,a.zdmc4,a.zdmemo4,a.zdmc5,a.zdmemo5,a.zdmc6,a.zdmemo6,a.zdmc7,a.zdmemo7,  
       a.zdmc8,a.zdmemo8,a.zdmc9,a.zdmemo9,a.zdmc10,a.zdmemo10,a.dwlb,a.gg_idm,a.zxypjl,a.zxjldw,a.cfmxxh   
into #tmp_result   
from #pydy_tmp a(nolock)  
where 1=2  
  
--����ϸ���� ��ŵ� #tmp_result ��ʱ��  
insert into #tmp_result(bmmc,ypmc,ypgg,lsj,sl,je,ypdw,pyrq,fyckmc,ysmc,sfymc,xh,sfrq,cfts,ypjl,jldw,Ƶ��,����,  
ypyf,ypyf0,yznr,���մ���ѱ�־,zt,sxh,xdfxh,xdfmc,��ҩ��־,fzbz,�˷ѱ�־,jssjh,fyckdm,ksdm,ksmc,ybdm,ybsm,memo,  
mjzbz,zc_mc,pyckdm,fph,fysm,cfsm,yflsh,cfk_yflsh,fyckxh,patid,cd_idm,ypbz,zfbz,zfbl,flzfbz,bxbz,cjmc,�����־,  
ypgg2,sfdr,cf_yznr,cf_ypyf,zpwzbh,ypmc_lc,lcjsdj,dzyzimage,psbz,gfbz,gfmc,ybmc,ypmemo,cfjyfs,zddm,zdmc,  
ghxh,cflx,pyczyh,hjxh,txh,cfypsl,���ͱ�־,fzxh,�԰���־,yfdm,zdmc1,zdmemo1,zdmc2,zdmemo2,zdmc3,zdmemo3,zdmc4,  
zdmemo4,zdmc5,zdmemo5,zdmc6,zdmemo6,zdmc7,zdmemo7,zdmc8,zdmemo8,zdmc9,zdmemo9,zdmc10,zdmemo10,dwlb,gg_idm,  
zxypjl,zxjldw,cfmxxh)   
select bmmc,ypmc,ypgg,lsj,sl,je,ypdw,pyrq,fyckmc,ysmc,sfymc,xh,sfrq,cfts,ypjl,jldw,Ƶ��,����,  
ypyf,ypyf0,yznr,���մ���ѱ�־,zt,sxh,xdfxh,xdfmc,��ҩ��־,fzbz,�˷ѱ�־,jssjh,fyckdm,ksdm,ksmc,ybdm,ybsm,memo,  
mjzbz,zc_mc,pyckdm,fph,fysm,cfsm,yflsh,cfk_yflsh,fyckxh,patid,cd_idm,ypbz,zfbz,zfbl,flzfbz,bxbz,cjmc,�����־,  
ypgg2,sfdr,cf_yznr,cf_ypyf,zpwzbh,ypmc_lc,lcjsdj,dzyzimage,psbz,gfbz,gfmc,ybmc,ypmemo,cfjyfs,zddm,zdmc,  
ghxh,cflx,pyczyh,hjxh,txh,cfypsl,���ͱ�־,fzxh,�԰���־,yfdm,zdmc1,zdmemo1,zdmc2,zdmemo2,zdmc3,zdmemo3,zdmc4,  
zdmemo4,zdmc5,zdmemo5,zdmc6,zdmemo6,zdmc7,zdmemo7,zdmc8,zdmemo8,zdmc9,zdmemo9,zdmc10,zdmemo10,dwlb,gg_idm,  
zxypjl,zxjldw,cfmxxh   
from #pydy_tmp(nolock)   
  
--��Ӵ������������ϼ�  
select xh,sum(je) as ���������ϼ� into #tmp_result_cfje from #tmp_result group by xh  
  
if (@config3321='��') and (@ypxtslt=2)  
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
     --��ɾ��YF_PY_MXPCXX ͬһ�Ŵ�������ҩ��ϸ����ֹ�ظ���ҩ�����YF_PY_MXPCXX��������  
     delete from YF_PY_MXPCXX where zdmxxh=@cs_cfmxxh  
  exec usp_yf_pygz_kcycl @cs_cd_idm,@cs_yfdm,@cs_ypsl,1,@errmsg output,0,@cs_yfdm,0,  
                   0,@cs_cfmxxh,'99',@cs_ylsj1 output,@cs_lsje1 output,@cs_jjje1 output  
  fetch cs_yfpy into @cs_cd_idm, @cs_ypsl, @cs_yfdm,@cs_cfmxxh  
 end  
 close cs_yfpy  
 deallocate cs_yfpy  
      
 select a.bmmc,a.ypmc,a.ypgg,a.lsj,a.sl,a.je,a.ypdw,a.pyrq,a.fyckmc,a.ysmc,a.sfymc,a.xh,a.sfrq,  
       a.cfts,a.ypjl,a.jldw,a.Ƶ��,a.����,a.ypyf,a.ypyf0,a.yznr,a.���մ���ѱ�־,a.zt,a.sxh,a.xdfxh,  
       a.xdfmc,a.��ҩ��־,a.fzbz,a.�˷ѱ�־,a.jssjh,a.fyckdm,a.ksdm,a.ksmc,a.ybdm,a.ybsm,a.memo,a.mjzbz,  
       a.zc_mc,a.pyckdm,a.fph,a.fysm,a.cfsm,a.yflsh,a.cfk_yflsh,a.fyckxh,a.patid,a.cd_idm,a.ypbz,a.zfbz,  
       a.zfbl,a.flzfbz,a.bxbz,a.cjmc,a.�����־,a.ypgg2,a.sfdr,a.cf_yznr,a.cf_ypyf,a.zpwzbh,a.ypmc_lc,  
       a.lcjsdj,a.dzyzimage,a.psbz,a.gfbz,a.gfmc,a.ybmc,a.ypmemo,a.cfjyfs,a.zddm,a.zdmc,a.ghxh,a.cflx,  
       a.pyczyh,a.hjxh,a.txh,a.cfypsl,a.���ͱ�־,a.fzxh,a.�԰���־,a.yfdm,a.zdmc1,a.zdmemo1,a.zdmc2,  
       a.zdmemo2,a.zdmc3,a.zdmemo3,a.zdmc4,a.zdmemo4,a.zdmc5,a.zdmemo5,a.zdmc6,a.zdmemo6,a.zdmc7,a.zdmemo7,  
       a.zdmc8,a.zdmemo8,a.zdmc9,a.zdmemo9,a.zdmc10,a.zdmemo10,a.dwlb,a.gg_idm,a.zxypjl,a.zxjldw,  
       (-1)*b.czsl/d.dwxs as pysl_pc,c.hgmc as hgmc,abs(b.lsje) as lsje_pc, 1 as cfts_pc   
    into #tmp_result_pc      
 from #tmp_result a(nolock) inner join YF_PY_MXPCXX b(nolock) on a.cfmxxh=b.zdmxxh  
                            inner join #cfmx_tmp d(nolock) on a.cfmxxh=d.xh  
                            left join YF_YPHGWH_PC c(nolock) on b.yfpcxh=c.pcxh  
 union all   
 select a.bmmc,a.ypmc,a.ypgg,a.lsj,a.sl,a.je,a.ypdw,a.pyrq,a.fyckmc,a.ysmc,a.sfymc,a.xh,a.sfrq,  
       a.cfts,a.ypjl,a.jldw,a.Ƶ��,a.����,a.ypyf,a.ypyf0,a.yznr,a.���մ���ѱ�־,a.zt,a.sxh,a.xdfxh,  
       a.xdfmc,a.��ҩ��־,a.fzbz,a.�˷ѱ�־,a.jssjh,a.fyckdm,a.ksdm,a.ksmc,a.ybdm,a.ybsm,a.memo,a.mjzbz,  
       a.zc_mc,a.pyckdm,a.fph,a.fysm,a.cfsm,a.yflsh,a.cfk_yflsh,a.fyckxh,a.patid,a.cd_idm,a.ypbz,a.zfbz,  
       a.zfbl,a.flzfbz,a.bxbz,a.cjmc,a.�����־,a.ypgg2,a.sfdr,a.cf_yznr,a.cf_ypyf,a.zpwzbh,a.ypmc_lc,  
       a.lcjsdj,a.dzyzimage,a.psbz,a.gfbz,a.gfmc,a.ybmc,a.ypmemo,a.cfjyfs,a.zddm,a.zdmc,a.ghxh,a.cflx,  
       a.pyczyh,a.hjxh,a.txh,a.cfypsl,a.���ͱ�־,a.fzxh,a.�԰���־,a.yfdm,a.zdmc1,a.zdmemo1,a.zdmc2,  
       a.zdmemo2,a.zdmc3,a.zdmemo3,a.zdmc4,a.zdmemo4,a.zdmc5,a.zdmemo5,a.zdmc6,a.zdmemo6,a.zdmc7,a.zdmemo7,  
       a.zdmc8,a.zdmemo8,a.zdmc9,a.zdmemo9,a.zdmc10,a.zdmemo10,a.dwlb,a.gg_idm,a.zxypjl,a.zxjldw,  
       (-1)*a.sl*a.cfts as pysl_pc,null as hgmc,abs(a.je) as lsje_pc,1 as cfts_pc    
     from  #tmp_result a(nolock) inner join #cfmx_tmp d(nolock) on a.cfmxxh=d.xh  
     where not exists(select 1 from YF_PY_MXPCXX b(nolock) where a.cfmxxh=b.zdmxxh)    
      
    if @cxbz = 0   ---�ձ�  
    begin   
  --sang+++ 2011-07-27 ��������̧ͷ���� masterbedpipline  
  --ע��̧ͷ ֻ����һ����¼ �ֶβ��������޸���Ӧsql�����е���  
  select top 1 e.cardno ����,e.blh ������,e.hzxm ��������,e.sex �Ա�,e.birth ��������,  
  (dbo.FUN_GETBRNL(e.birth,convert(char(8),getdate(),112)+convert(char(8),getdate(),8),1,0,null))  ����,   
  (dbo.FUN_GETBRNL(e.birth,convert(char(8),getdate(),112)+convert(char(8),getdate(),8),0,0,null)) ����,e.sfzh ���֤,   
  b.ybsm �ѱ�,b.pzlx,e.pzh,e.dwbm, e.dwmc ,e.lxdz ��ϵ��ַ,e.lxdh ��ϵ�绰,c.name as dymc ,e.qtkh,e.dyid,  
  s.lrrq kfrq,s.tmhdbz,case s.tmhdbz when 1 then '�Ѻ˶�' else 'δ�˶�' end as tmhdbz_sm  
  into #tmp_title_pc  
  from SF_BRXXK e (nolock)   
   inner join SF_BRJSK d(nolock) on d.patid=e.patid  
   inner join SF_MZCFK s(nolock) on  d.sjh=s.jssjh  
   left join YY_YBFLK b (nolock) on e.ybdm=b.ybdm  
   left join YY_BRDYLYK c(nolock) on  e.dyid=c.id  
  where s.jssjh=@jssjh  
  
  --��̧ͷ����ϸ��������  
  select @cfwz cfwz,xh mzcfk_xh,  
      a.����,a.������,a.��������,a.�Ա�,a.��������,a.����,a.����,a.���֤,a.�ѱ�,a.pzlx,a.pzh,a.dwbm,a.dwmc,  
      a.��ϵ��ַ,a.��ϵ�绰,a.dymc,a.qtkh,a.dyid,a.kfrq,a.tmhdbz,a.tmhdbz_sm,  
      b.bmmc,b.ypmc,b.ypgg,b.lsj,b.sl,b.je,b.ypdw,b.pyrq,b.fyckmc,b.ysmc,b.sfymc,b.xh,b.sfrq,b.cfts,  
      b.ypjl,b.jldw,b.Ƶ��,b.����,b.ypyf,b.ypyf0,b.yznr,b.���մ���ѱ�־,b.zt,b.sxh,b.xdfxh,b.xdfmc,  
      b.��ҩ��־,b.fzbz,b.�˷ѱ�־,b.jssjh,b.fyckdm,b.ksdm,b.ksmc,b.ybdm,b.ybsm,b.memo,b.mjzbz,b.zc_mc,  
      b.pyckdm,b.fph,b.fysm,b.cfsm,b.yflsh,b.cfk_yflsh,b.fyckxh,b.patid,b.cd_idm,b.ypbz,b.zfbz,b.zfbl,  
      b.flzfbz,b.bxbz,b.cjmc,b.�����־,b.ypgg2,b.sfdr,b.cf_yznr,b.cf_ypyf,b.zpwzbh,b.ypmc_lc,b.lcjsdj,  
      b.dzyzimage,b.psbz,b.gfbz,b.gfmc,b.ybmc,b.ypmemo,b.cfjyfs,b.zddm,b.zdmc,b.ghxh,b.cflx,b.pyczyh,  
      b.hjxh,b.txh,b.cfypsl,b.���ͱ�־,b.fzxh,b.�԰���־,b.yfdm,b.zdmc1,b.zdmemo1,b.zdmc2,b.zdmemo2,  
      b.zdmc3,b.zdmemo3,b.zdmc4,b.zdmemo4,b.zdmc5,b.zdmemo5,b.zdmc6,b.zdmemo6,b.zdmc7,b.zdmemo7,b.zdmc8,  
      b.zdmemo8,b.zdmc9,b.zdmemo9,b.zdmc10,b.zdmemo10,b.dwlb,b.gg_idm,b.zxypjl,b.zxjldw,  
      b.pysl_pc,b.hgmc,b.lsje_pc,b.cfts_pc  
  into #tmp_zz_result_pc   
  from #tmp_title_pc a(nolock),#tmp_result_pc b(nolock)  
  
  update #tmp_zz_result_pc set cfwz=b.cfwz  
  from #tmp_zz_result_pc a(nolock),YF_YFZKC b(nolock)  
  where a.yfdm=b.ksdm and a.cd_idm=b.cd_idm  
          
        select a.cfwz,a.mzcfk_xh,a.����,a.������,a.��������,a.�Ա�,a.��������,a.����,a.����,a.���֤,a.�ѱ�,  
      a.pzlx,a.pzh,a.dwbm,a.dwmc,a.��ϵ��ַ,a.��ϵ�绰,a.dymc,a.qtkh,a.dyid,a.kfrq,a.tmhdbz,a.tmhdbz_sm,  
      a.bmmc,a.ypmc,a.ypgg,a.lsj,a.sl,a.je,a.ypdw,a.pyrq,a.fyckmc,a.ysmc,a.sfymc,a.xh,a.sfrq,a.cfts,  
      a.ypjl,a.jldw,a.Ƶ��,a.����,a.ypyf,a.ypyf0,a.yznr,a.���մ���ѱ�־,a.zt,a.sxh,a.xdfxh,a.xdfmc,  
      a.��ҩ��־,a.fzbz,a.�˷ѱ�־,a.jssjh,a.fyckdm,a.ksdm,a.ksmc,a.ybdm,a.ybsm,a.memo,a.mjzbz,a.zc_mc,  
      a.pyckdm,a.fph,a.fysm,a.cfsm,a.yflsh,a.cfk_yflsh,a.fyckxh,a.patid,a.cd_idm,a.ypbz,a.zfbz,a.zfbl,  
      a.flzfbz,a.bxbz,a.cjmc,a.�����־,a.ypgg2,a.sfdr,a.cf_yznr,a.cf_ypyf,a.zpwzbh,a.ypmc_lc,a.lcjsdj,  
      a.dzyzimage,a.psbz,a.gfbz,a.gfmc,a.ybmc,a.ypmemo,a.cfjyfs,a.zddm,a.zdmc,a.ghxh,a.cflx,a.pyczyh,  
      a.hjxh,a.txh,a.cfypsl,a.���ͱ�־,a.fzxh,a.�԰���־,a.yfdm,a.zdmc1,a.zdmemo1,a.zdmc2,a.zdmemo2,  
      a.zdmc3,a.zdmemo3,a.zdmc4,a.zdmemo4,a.zdmc5,a.zdmemo5,a.zdmc6,a.zdmemo6,a.zdmc7,a.zdmemo7,a.zdmc8,  
      a.zdmemo8,a.zdmc9,a.zdmemo9,a.zdmc10,a.zdmemo10,a.dwlb,a.gg_idm,a.zxypjl,a.zxjldw,  
      a.pysl_pc,a.hgmc,a.lsje_pc,a.cfts_pc ,convert(varchar(64), @yymc) as yymc  
     into #temp_zz_result_sc_rb       
  from #tmp_zz_result_pc a(nolock)  
  order by a.cfwz,a.xh,a.sxh             
        if @dyfileterbz=0   
        begin  
            select  a.*,b.���������ϼ�  from #temp_zz_result_sc_rb a left join #tmp_result_cfje b on a.xh=b.xh   
        end  
        else if @dyfileterbz=1   
        begin  
            exec('select a.*,b.���������ϼ� from #temp_zz_result_sc_rb a left join #tmp_result_cfje b on a.xh=b.xh where ypyf0 in ('+@strfilter+')')  
        end  
        else if @dyfileterbz=2   
        begin  
            exec('select a.*,b.���������ϼ� from #temp_zz_result_sc_rb a left join #tmp_result_cfje b on a.xh=b.xh where ypyf0 not in ('+@strfilter+')')  
        end  
                    
 end  
 else   ---���  
 begin  
  --sang+++ 2011-07-27 ��������̧ͷ���� masterbedpipline  
  --ע��̧ͷ ֻ����һ����¼ �ֶβ��������޸���Ӧsql�����е���  
  select top 1 e.cardno ����,e.blh ������,e.hzxm ��������,e.sex �Ա�,e.birth ��������,  
  (dbo.FUN_GETBRNL(e.birth,convert(char(8),getdate(),112)+convert(char(8),getdate(),8),1,0,null))  ����,   
  (dbo.FUN_GETBRNL(e.birth,convert(char(8),getdate(),112)+convert(char(8),getdate(),8),0,0,null)) ����,e.sfzh ���֤,   
  b.ybsm �ѱ�,b.pzlx,e.pzh,e.dwbm, e.dwmc ,e.lxdz ��ϵ��ַ,e.lxdh ��ϵ�绰,c.name as dymc ,e.qtkh,e.dyid,  
  s.lrrq kfrq,s.tmhdbz,case s.tmhdbz when 1 then '�Ѻ˶�' else 'δ�˶�' end as tmhdbz_sm  
  into #tmp_title_pc_nb  
  from SF_BRXXK e (nolock)   
   inner join VW_MZBRJSK d(nolock) on d.patid=e.patid  
   inner join VW_MZCFK s(nolock) on  d.sjh=s.jssjh  
   left join YY_YBFLK b (nolock) on e.ybdm=b.ybdm  
   left join YY_BRDYLYK c(nolock) on  e.dyid=c.id  
  where s.jssjh=@jssjh  
  
  --��̧ͷ����ϸ��������  
  select @cfwz cfwz,xh mzcfk_xh,  
      a.����,a.������,a.��������,a.�Ա�,a.��������,a.����,a.����,a.���֤,a.�ѱ�,a.pzlx,a.pzh,a.dwbm,a.dwmc,  
      a.��ϵ��ַ,a.��ϵ�绰,a.dymc,a.qtkh,a.dyid,a.kfrq,a.tmhdbz,a.tmhdbz_sm,  
      b.bmmc,b.ypmc,b.ypgg,b.lsj,b.sl,b.je,b.ypdw,b.pyrq,b.fyckmc,b.ysmc,b.sfymc,b.xh,b.sfrq,b.cfts,  
      b.ypjl,b.jldw,b.Ƶ��,b.����,b.ypyf,b.ypyf0,b.yznr,b.���մ���ѱ�־,b.zt,b.sxh,b.xdfxh,b.xdfmc,  
      b.��ҩ��־,b.fzbz,b.�˷ѱ�־,b.jssjh,b.fyckdm,b.ksdm,b.ksmc,b.ybdm,b.ybsm,b.memo,b.mjzbz,b.zc_mc,  
      b.pyckdm,b.fph,b.fysm,b.cfsm,b.yflsh,b.cfk_yflsh,b.fyckxh,b.patid,b.cd_idm,b.ypbz,b.zfbz,b.zfbl,  
      b.flzfbz,b.bxbz,b.cjmc,b.�����־,b.ypgg2,b.sfdr,b.cf_yznr,b.cf_ypyf,b.zpwzbh,b.ypmc_lc,b.lcjsdj,  
      b.dzyzimage,b.psbz,b.gfbz,b.gfmc,b.ybmc,b.ypmemo,b.cfjyfs,b.zddm,b.zdmc,b.ghxh,b.cflx,b.pyczyh,  
      b.hjxh,b.txh,b.cfypsl,b.���ͱ�־,b.fzxh,b.�԰���־,b.yfdm,b.zdmc1,b.zdmemo1,b.zdmc2,b.zdmemo2,  
      b.zdmc3,b.zdmemo3,b.zdmc4,b.zdmemo4,b.zdmc5,b.zdmemo5,b.zdmc6,b.zdmemo6,b.zdmc7,b.zdmemo7,b.zdmc8,  
      b.zdmemo8,b.zdmc9,b.zdmemo9,b.zdmc10,b.zdmemo10,b.dwlb,b.gg_idm,b.zxypjl,b.zxjldw,  
      b.pysl_pc,b.hgmc,b.lsje_pc,b.cfts_pc  
  into #tmp_zz_result_pc_nb   
  from #tmp_title_pc_nb a(nolock),#tmp_result_pc b(nolock)  
  
  update #tmp_zz_result_pc_nb set cfwz=b.cfwz  
  from #tmp_zz_result_pc_nb a(nolock),YF_YFZKC b(nolock)  
  where a.yfdm=b.ksdm and a.cd_idm=b.cd_idm  
          
  select a.cfwz,a.mzcfk_xh,a.����,a.������,a.��������,a.�Ա�,a.��������,a.����,a.����,a.���֤,a.�ѱ�,  
      a.pzlx,a.pzh,a.dwbm,a.dwmc,a.��ϵ��ַ,a.��ϵ�绰,a.dymc,a.qtkh,a.dyid,a.kfrq,a.tmhdbz,a.tmhdbz_sm,  
      a.bmmc,a.ypmc,a.ypgg,a.lsj,a.sl,a.je,a.ypdw,a.pyrq,a.fyckmc,a.ysmc,a.sfymc,a.xh,a.sfrq,a.cfts,  
      a.ypjl,a.jldw,a.Ƶ��,a.����,a.ypyf,a.ypyf0,a.yznr,a.���մ���ѱ�־,a.zt,a.sxh,a.xdfxh,a.xdfmc,  
      a.��ҩ��־,a.fzbz,a.�˷ѱ�־,a.jssjh,a.fyckdm,a.ksdm,a.ksmc,a.ybdm,a.ybsm,a.memo,a.mjzbz,a.zc_mc,  
      a.pyckdm,a.fph,a.fysm,a.cfsm,a.yflsh,a.cfk_yflsh,a.fyckxh,a.patid,a.cd_idm,a.ypbz,a.zfbz,a.zfbl,  
      a.flzfbz,a.bxbz,a.cjmc,a.�����־,a.ypgg2,a.sfdr,a.cf_yznr,a.cf_ypyf,a.zpwzbh,a.ypmc_lc,a.lcjsdj,  
      a.dzyzimage,a.psbz,a.gfbz,a.gfmc,a.ybmc,a.ypmemo,a.cfjyfs,a.zddm,a.zdmc,a.ghxh,a.cflx,a.pyczyh,  
      a.hjxh,a.txh,a.cfypsl,a.���ͱ�־,a.fzxh,a.�԰���־,a.yfdm,a.zdmc1,a.zdmemo1,a.zdmc2,a.zdmemo2,  
      a.zdmc3,a.zdmemo3,a.zdmc4,a.zdmemo4,a.zdmc5,a.zdmemo5,a.zdmc6,a.zdmemo6,a.zdmc7,a.zdmemo7,a.zdmc8,  
      a.zdmemo8,a.zdmc9,a.zdmemo9,a.zdmc10,a.zdmemo10,a.dwlb,a.gg_idm,a.zxypjl,a.zxjldw,  
      a.pysl_pc,a.hgmc,a.lsje_pc,a.cfts_pc,convert(varchar(64), @yymc) as yymc  
     into #temp_zz_result_sc_nb         
  from #tmp_zz_result_pc_nb a(nolock)  
  order by a.cfwz,a.xh,a.sxh    
  if @dyfileterbz=0   
        begin  
            select a.*,b.���������ϼ� from #temp_zz_result_sc_nb a left join #tmp_result_cfje b on a.xh=b.xh    
        end  
        else if @dyfileterbz=1   
        begin  
             exec('select a.*,b.���������ϼ� from #temp_zz_result_sc_nb a left join #tmp_result_cfje b on a.xh=b.xh  where ypyf0 in ('+@strfilter+')')  
        end  
        else if @dyfileterbz=2   
        begin  
            exec('select a.*,b.���������ϼ� from #temp_zz_result_sc_nb a left join #tmp_result_cfje b on a.xh=b.xh  where ypyf0 not in ('+@strfilter+')')  
        end  
       
 end  
 return    
end  
else   --3221Ϊ��  
begin  
 if @cxbz = 0   ---�ձ�  
 begin  
  --sang+++ 2011-07-27 ��������̧ͷ���� masterbedpipline  
  --ע��̧ͷ ֻ����һ����¼ �ֶβ��������޸���Ӧsql�����е���  
  select top 1 e.cardno ����,e.blh ������,e.hzxm ��������,e.sex �Ա�,e.birth ��������,  
  (dbo.FUN_GETBRNL(e.birth,convert(char(8),getdate(),112)+convert(char(8),getdate(),8),1,0,null))  ����,   
  (dbo.FUN_GETBRNL(e.birth,convert(char(8),getdate(),112)+convert(char(8),getdate(),8),0,0,null)) ����,e.sfzh ���֤,   
  b.ybsm �ѱ�,b.pzlx,e.pzh,e.dwbm, e.dwmc ,e.lxdz ��ϵ��ַ,e.lxdh ��ϵ�绰,c.name as dymc ,e.qtkh,e.dyid,  
  s.lrrq kfrq,s.tmhdbz,case s.tmhdbz when 1 then '�Ѻ˶�' else 'δ�˶�' end as tmhdbz_sm  
  into #tmp_title  
  from SF_BRXXK e (nolock) 
   inner join SF_BRJSK d(nolock) on d.patid=e.patid  
   inner join SF_MZCFK s(nolock) on  d.sjh=s.jssjh  
   left join YY_YBFLK b (nolock) on e.ybdm=b.ybdm  
   left join YY_BRDYLYK c(nolock) on  e.dyid=c.id  
  where s.jssjh=@jssjh  
  
  --��̧ͷ����ϸ��������  
  select @cfwz cfwz,xh mzcfk_xh,  
      a.����,a.������,a.��������,a.�Ա�,a.��������,a.����,a.����,a.���֤,a.�ѱ�,a.pzlx,a.pzh,a.dwbm,a.dwmc,  
      a.��ϵ��ַ,a.��ϵ�绰,a.dymc,a.qtkh,a.dyid,a.kfrq,a.tmhdbz,a.tmhdbz_sm,  
      b.bmmc,b.ypmc,b.ypgg,b.lsj,b.sl,b.je,b.ypdw,b.pyrq,b.fyckmc,b.ysmc,b.sfymc,b.xh,b.sfrq,b.cfts,  
      b.ypjl,b.jldw,b.Ƶ��,b.����,b.ypyf,b.ypyf0,b.yznr,b.���մ���ѱ�־,b.zt,b.sxh,b.xdfxh,b.xdfmc,  
      b.��ҩ��־,b.fzbz,b.�˷ѱ�־,b.jssjh,b.fyckdm,b.ksdm,b.ksmc,b.ybdm,b.ybsm,b.memo,b.mjzbz,b.zc_mc,  
      b.pyckdm,b.fph,b.fysm,b.cfsm,b.yflsh,b.cfk_yflsh,b.fyckxh,b.patid,b.cd_idm,b.ypbz,b.zfbz,b.zfbl,  
      b.flzfbz,b.bxbz,b.cjmc,b.�����־,b.ypgg2,b.sfdr,b.cf_yznr,b.cf_ypyf,b.zpwzbh,b.ypmc_lc,b.lcjsdj,  
      b.dzyzimage,b.psbz,b.gfbz,b.gfmc,b.ybmc,b.ypmemo,b.cfjyfs,b.zddm,b.zdmc,b.ghxh,b.cflx,b.pyczyh,  
      b.hjxh,b.txh,b.cfypsl,b.���ͱ�־,b.fzxh,b.�԰���־,b.yfdm,b.zdmc1,b.zdmemo1,b.zdmc2,b.zdmemo2,  
      b.zdmc3,b.zdmemo3,b.zdmc4,b.zdmemo4,b.zdmc5,b.zdmemo5,b.zdmc6,b.zdmemo6,b.zdmc7,b.zdmemo7,b.zdmc8,  
      b.zdmemo8,b.zdmc9,b.zdmemo9,b.zdmc10,b.zdmemo10,b.dwlb,b.gg_idm,b.zxypjl,b.zxjldw  
  into #tmp_zz_result   
  from #tmp_title a(nolock),#tmp_result b(nolock)  
  
  update #tmp_zz_result set cfwz=b.cfwz  
  from #tmp_zz_result a(nolock),YF_YFZKC b(nolock)  
  where a.yfdm=b.ksdm and a.cd_idm=b.cd_idm  
  
  select a.cfwz,a.mzcfk_xh,a.����,a.������,a.��������,a.�Ա�,a.��������,a.����,a.����,a.���֤,a.�ѱ�,  
      a.pzlx,a.pzh,a.dwbm,a.dwmc,a.��ϵ��ַ,a.��ϵ�绰,a.dymc,a.qtkh,a.dyid,a.kfrq,a.tmhdbz,a.tmhdbz_sm,  
      a.bmmc,a.ypmc,a.ypgg,a.lsj,a.sl,a.je,a.ypdw,a.pyrq,a.fyckmc,a.ysmc,a.sfymc,a.xh,a.sfrq,a.cfts,  
      a.ypjl,a.jldw,a.Ƶ��,a.����,a.ypyf,a.ypyf0,a.yznr,a.���մ���ѱ�־,a.zt,a.sxh,a.xdfxh,a.xdfmc,  
      a.��ҩ��־,a.fzbz,a.�˷ѱ�־,a.jssjh,a.fyckdm,a.ksdm,a.ksmc,a.ybdm,a.ybsm,a.memo,a.mjzbz,a.zc_mc,  
      a.pyckdm,a.fph,a.fysm,a.cfsm,a.yflsh,a.cfk_yflsh,a.fyckxh,a.patid,a.cd_idm,a.ypbz,a.zfbz,a.zfbl,  
      a.flzfbz,a.bxbz,a.cjmc,a.�����־,a.ypgg2,a.sfdr,a.cf_yznr,a.cf_ypyf,a.zpwzbh,a.ypmc_lc,a.lcjsdj,  
      a.dzyzimage,a.psbz,a.gfbz,a.gfmc,a.ybmc,a.ypmemo,a.cfjyfs,a.zddm,a.zdmc,a.ghxh,a.cflx,a.pyczyh,  
      a.hjxh,a.txh,a.cfypsl,a.���ͱ�־,a.fzxh,a.�԰���־,a.yfdm,a.zdmc1,a.zdmemo1,a.zdmc2,a.zdmemo2,  
      a.zdmc3,a.zdmemo3,a.zdmc4,a.zdmemo4,a.zdmc5,a.zdmemo5,a.zdmc6,a.zdmemo6,a.zdmc7,a.zdmemo7,a.zdmc8,  
      a.zdmemo8,a.zdmc9,a.zdmemo9,a.zdmc10,a.zdmemo10,a.dwlb,a.gg_idm,a.zxypjl,a.zxjldw,  
      convert(varchar(64), @yymc) as yymc  
     into #temp_zz_result_sc_rb_1  
  
  from #tmp_zz_result a(nolock)  
  order by a.fzxh
  --a.cfwz,a.xh,a.sxh  lj20191124ҩ����ҩ��ӡģ����ʾ����
         
  --update by winning-dingsong-chongqing on 20200706 ��������order by sxh��
  if @dyfileterbz=0   
        begin  
            select a.*,b.���������ϼ� from #temp_zz_result_sc_rb_1  a left join #tmp_result_cfje b on a.xh=b.xh
			order by sxh  
        end  
        else if @dyfileterbz=1   
        begin  
             exec('select a.*,b.���������ϼ� from #temp_zz_result_sc_rb_1 a left join #tmp_result_cfje b on a.xh=b.xh  where ypyf0 in ('+@strfilter+') order by sxh  ')  
        end  
        else if @dyfileterbz=2   
        begin  
            exec('select a.*,b.���������ϼ� from #temp_zz_result_sc_rb_1 a left join #tmp_result_cfje b on a.xh=b.xh  where ypyf0 not in ('+@strfilter+') order by sxh  ')  
        end  
 end  
 else  
 begin    -----���  
  --sang+++ 2011-07-27 ��������̧ͷ���� masterbedpipline  
  --ע��̧ͷ ֻ����һ����¼ �ֶβ��������޸���Ӧsql�����е���  
  select top 1 e.cardno ����,e.blh ������,e.hzxm ��������,e.sex �Ա�,e.birth ��������,  
  (dbo.FUN_GETBRNL(e.birth,convert(char(8),getdate(),112)+convert(char(8),getdate(),8),1,0,null))  ����,  
  (dbo.FUN_GETBRNL(e.birth,convert(char(8),getdate(),112)+convert(char(8),getdate(),8),0,0,null)) ����,  
  e.sfzh ���֤, b.ybsm �ѱ�,b.pzlx,e.pzh,e.dwbm, e.dwmc ,e.lxdz ��ϵ��ַ,e.lxdh ��ϵ�绰,c.name as dymc ,e.qtkh,e.dyid,  
  s.lrrq kfrq,s.tmhdbz,case s.tmhdbz when 1 then '�Ѻ˶�' else 'δ�˶�' end as tmhdbz_sm  
  into #tmp_title_nb  
  from SF_BRXXK e (nolock)   
   inner join VW_MZBRJSK d(nolock) on d.patid=e.patid  
   inner join VW_MZCFK s(nolock) on  d.sjh=s.jssjh  
   left join YY_YBFLK b (nolock) on e.ybdm=b.ybdm  
   left join YY_BRDYLYK c(nolock) on  e.dyid=c.id  
  where s.jssjh=@jssjh  
    
  --��̧ͷ����ϸ��������   
  select @cfwz cfwz,xh mzcfk_xh,  
      a.����,a.������,a.��������,a.�Ա�,a.��������,a.����,a.����,a.���֤,a.�ѱ�,a.pzlx,a.pzh,a.dwbm,a.dwmc,  
      a.��ϵ��ַ,a.��ϵ�绰,a.dymc,a.qtkh,a.dyid,a.kfrq,a.tmhdbz,a.tmhdbz_sm,  
      b.bmmc,b.ypmc,b.ypgg,b.lsj,b.sl,b.je,b.ypdw,b.pyrq,b.fyckmc,b.ysmc,b.sfymc,b.xh,b.sfrq,b.cfts,  
      b.ypjl,b.jldw,b.Ƶ��,b.����,b.ypyf,b.ypyf0,b.yznr,b.���մ���ѱ�־,b.zt,b.sxh,b.xdfxh,b.xdfmc,  
      b.��ҩ��־,b.fzbz,b.�˷ѱ�־,b.jssjh,b.fyckdm,b.ksdm,b.ksmc,b.ybdm,b.ybsm,b.memo,b.mjzbz,b.zc_mc,  
      b.pyckdm,b.fph,b.fysm,b.cfsm,b.yflsh,b.cfk_yflsh,b.fyckxh,b.patid,b.cd_idm,b.ypbz,b.zfbz,b.zfbl,  
      b.flzfbz,b.bxbz,b.cjmc,b.�����־,b.ypgg2,b.sfdr,b.cf_yznr,b.cf_ypyf,b.zpwzbh,b.ypmc_lc,b.lcjsdj,  
      b.dzyzimage,b.psbz,b.gfbz,b.gfmc,b.ybmc,b.ypmemo,b.cfjyfs,b.zddm,b.zdmc,b.ghxh,b.cflx,b.pyczyh,  
      b.hjxh,b.txh,b.cfypsl,b.���ͱ�־,b.fzxh,b.�԰���־,b.yfdm,b.zdmc1,b.zdmemo1,b.zdmc2,b.zdmemo2,  
      b.zdmc3,b.zdmemo3,b.zdmc4,b.zdmemo4,b.zdmc5,b.zdmemo5,b.zdmc6,b.zdmemo6,b.zdmc7,b.zdmemo7,b.zdmc8,  
      b.zdmemo8,b.zdmc9,b.zdmemo9,b.zdmc10,b.zdmemo10,b.dwlb,b.gg_idm,b.zxypjl,b.zxjldw   
  into #tmp_zz_result_nb   
  from #tmp_title_nb a(nolock),#tmp_result b(nolock)  
  
  update #tmp_zz_result_nb set cfwz=b.cfwz  
  from #tmp_zz_result_nb a(nolock),YF_YFZKC b(nolock)  
  where a.yfdm=b.ksdm and a.cd_idm=b.cd_idm  
  
  select a.cfwz,a.mzcfk_xh,a.����,a.������,a.��������,a.�Ա�,a.��������,a.����,a.����,a.���֤,a.�ѱ�,  
      a.pzlx,a.pzh,a.dwbm,a.dwmc,a.��ϵ��ַ,a.��ϵ�绰,a.dymc,a.qtkh,a.dyid,a.kfrq,a.tmhdbz,a.tmhdbz_sm,  
      a.bmmc,a.ypmc,a.ypgg,a.lsj,a.sl,a.je,a.ypdw,a.pyrq,a.fyckmc,a.ysmc,a.sfymc,a.xh,a.sfrq,a.cfts,  
      a.ypjl,a.jldw,a.Ƶ��,a.����,a.ypyf,a.ypyf0,a.yznr,a.���մ���ѱ�־,a.zt,a.sxh,a.xdfxh,a.xdfmc,  
      a.��ҩ��־,a.fzbz,a.�˷ѱ�־,a.jssjh,a.fyckdm,a.ksdm,a.ksmc,a.ybdm,a.ybsm,a.memo,a.mjzbz,a.zc_mc,  
      a.pyckdm,a.fph,a.fysm,a.cfsm,a.yflsh,a.cfk_yflsh,a.fyckxh,a.patid,a.cd_idm,a.ypbz,a.zfbz,a.zfbl,  
      a.flzfbz,a.bxbz,a.cjmc,a.�����־,a.ypgg2,a.sfdr,a.cf_yznr,a.cf_ypyf,a.zpwzbh,a.ypmc_lc,a.lcjsdj,  
      a.dzyzimage,a.psbz,a.gfbz,a.gfmc,a.ybmc,a.ypmemo,a.cfjyfs,a.zddm,a.zdmc,a.ghxh,a.cflx,a.pyczyh,  
      a.hjxh,a.txh,a.cfypsl,a.���ͱ�־,a.fzxh,a.�԰���־,a.yfdm,a.zdmc1,a.zdmemo1,a.zdmc2,a.zdmemo2,  
      a.zdmc3,a.zdmemo3,a.zdmc4,a.zdmemo4,a.zdmc5,a.zdmemo5,a.zdmc6,a.zdmemo6,a.zdmc7,a.zdmemo7,a.zdmc8,  
      a.zdmemo8,a.zdmc9,a.zdmemo9,a.zdmc10,a.zdmemo10,a.dwlb,a.gg_idm,a.zxypjl,a.zxjldw,  
     convert(varchar(64), @yymc) as yymc  
  into #temp_zz_result_sc_nb_1      
  from #tmp_zz_result_nb a(nolock)  
  order by a.cfwz,a.xh,a.sxh   
  
  if @dyfileterbz=0   
        begin  
            select a.*,b.�������ϼƽ�� from #temp_zz_result_sc_nb_1  a left join #tmp_result_cfje b on a.xh=b.xh    
        end  
        else if @dyfileterbz=1   
        begin  
             exec('select a.*,b.�������ϼƽ�� from #temp_zz_result_sc_nb_1 a left join #tmp_result_cfje b on a.xh=b.xh  where ypyf0 in ('+@strfilter+')')  
        end  
        else if @dyfileterbz=2   
        begin  
            exec('select a.*,b.�������ϼƽ�� from #temp_zz_result_sc_nb_1 a left join #tmp_result_cfje b on a.xh=b.xh  where ypyf0 not in ('+@strfilter+')')  
        end  
    
 end  
 return   
end 




