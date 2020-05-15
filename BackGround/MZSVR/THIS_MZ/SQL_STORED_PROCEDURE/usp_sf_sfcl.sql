CREATE proc usp_sf_sfcl --收费处理功能  
 @wkdz varchar(32),  
 @jszt smallint,  
 @sfbz smallint,  
 @sflb smallint,  
 @czksfbz  int,     
 @qrbz ut_bz,  
 @patid ut_xh12,  
 @sjh ut_sjh,  
 @czyh ut_czyh,  
 @ksdm ut_ksdm,  
 @ysdm ut_czyh,  
 @sfksdm ut_ksdm,  
 @yfdm ut_ksdm,  
 @sfckdm ut_dm2,  
 @pyckdm ut_dm2,  
 @fyckdm ut_dm2,  
 @ybdm ut_ybdm,  
 @cfxh int,  
 @hjxh ut_xh12,  
 @cflx ut_bz,  
 @sycfbz ut_bz,  
 @tscfbz ut_bz,  
 @dxmdm ut_kmdm,  
 @xxmdm ut_xmdm,  
 @idm ut_xh9,  
 @ypdw ut_unit,  
 @dwxs ut_dwxs,  
 @fysl ut_sl10,  
 @cfts integer,  
 @ypdj ut_money,  
 @ghsjh ut_sjh = null,  
 @ghxh ut_xh12 = null,  
 @tcljje numeric(12,2) = 0,  
 @shbz ut_bz = 0,  
 @zph varchar(32) = null,  
 @zpje numeric(12,2) = null,  
 @zhbz ut_zhbz = null,  
 @zddm ut_zddm = null,  
 @zxlsh ut_lsh = null,  
 @jslsh ut_lsh = null,  
 @xmlb ut_dm2 = null,  
 @qfdnzhzfje numeric(12,2) = null,  
 @qflnzhzfje numeric(12,2) = null,  
 @qfxjzfje numeric(12,2) = null,  
 @tclnzhzfje numeric(12,2) = null,  
 @tcxjzfje numeric(12,2) = null,  
 @tczfje numeric(12,2) = null,  
 @fjlnzhzfje numeric(12,2) = null,  
 @fjxjzfje numeric(12,2) = null,  
 @dffjzfje numeric(12,2) = null,  
 @dnzhye numeric(12,2) = null,  
 @lnzhye numeric(12,2) = null,  
 @qkbz smallint = 0,  
 @jsrq ut_rq16 = ''  
 ,@ylcardno ut_cardno=''  
 ,@ylkje ut_money=0  
 ,@ylkhcysje ut_money=0  
 ,@ylksqxh ut_lsh=''  
 ,@ylkzxlsh ut_lsh=''  
 ,@ylkhcyssqxh ut_lsh=''  
 ,@ylkhcyszxlsh ut_lsh=''  
 ,@yhdj ut_money=0   --add by chenwei 2003.12.06   
 ,@ypmc ut_mc64=''  
 ,@lcxmdm ut_xmdm='0'                    --agg 2004.07.09    
 ,@hjmxxh ut_xh12='0'   --zwj 2005.6.16  
    ,@lcxmsl numeric(12,4)=0 --add by ctg at 2006.11.22 增加了lcxmsl  
 ,@dfpzhzfje ut_money =0 --add wuwei 2011-06-08 将多发票已经使用的zhzfje传入增加判断 for bug 95182  
 ,@fybz  ut_bz=0  --自费转医保时,原记录的fybz  
 ,@yjqrbz ut_bz=0  --自费转医保时,原记录的yjqrbz  
 ,@yjclfbz ut_bz=0  --医技材料费标志  
 ,@yhdm ut_ybdm='0'--优惠类型代码  
 ,@tbzddm ut_mc32=''--特病诊断代码    
 ,@tbzdmc ut_mc32=''--特病诊断名称    
 ,@yhyy varchar(12)='' -- ZY_YHFSK.id  add kcs 20151102  
 ,@kfsdm      ut_ybdm=''  
    
   
as --集51409 2019-04-24 14:44:30 4.0标准版_201810补丁  
/***********  
[版本号]4.0.0.0.0  
[创建时间]2004.10.25  
[作者]王奕  
[版权] Copyright ? 2004-2008上海金仕达-卫宁软件股份有限公司[描述]收费处理  
[功能说明]  
 收费处理功能  
[参数说明]  
 @wkdz varchar(32), 网卡地址  
 @jszt smallint,  结束状态 1=创建表，2=插入，3=递交  
 @sfbz smallint,  收费标志0=预算，1=递交(请求1), 2=正式递交(请求2)  
 @sflb smallint,  收费类别1=普通，2=急诊  
 @czksfbz  int    充值卡收费标志， 0 :不从充值卡收费  ，1 从充值卡收费 add by szj  
 @qrbz ut_bz,  确认标志0=普通，1=记帐(医技收费用)  
 @patid ut_xh12,  病人唯一标识  
   @sjh ut_sjh,  收据号  
 @czyh ut_czyh,  操作员号  
   @ksdm ut_ksdm,  科室代码  
   @ysdm ut_czyh,  医生代码  
 @sfksdm ut_ksdm, 收费科室代码  
 @yfdm ut_ksdm,  药房代码  
 @sfckdm ut_dm2,  收费窗口代码  
 @pyckdm ut_dm2,  配药窗口代码  
 @fyckdm ut_dm2,  发药窗口代码  
 @ybdm ut_ybdm,  医保代码  
 @cfxh int,   处方序号  
 @hjxh ut_xh12,  划价序号  
 @cflx ut_bz,  处方类别1:西药处方,2:中药处方,3:草药处方,4:治疗处方  
 @sycfbz ut_bz,  输液处方标志0:普通处方，1:输液处方  
 @tscfbz ut_bz,  特殊处方标志0:普通处方，1:尿毒症处方  
 @dxmdm ut_kmdm,  大项目代码  
 @xxmdm ut_xmdm,  小项目代码（药品代码）  
 @idm ut_xh9,  产地idm  
 @ypdw ut_unit,  药品单位  
 @dwxs ut_dwxs,  单位系数  
 @fysl ut_sl10,  发药数量  
 @cfts integer,  处方贴数  
 @ypdj ut_money,  药品单价  
 @ghsjh ut_sjh = null,  挂号收据号  
 @ghxh ut_xh12 = null,  挂号序号  
 @tcljje numeric(12,2) = 0, 统筹累计金额(新疆回沪用)  
 @shbz ut_bz = 0,  审核标志 0 不需审核,1 审核,2 审核不通过  
 @zph varchar(32) = null, 支票号  
 @zpje numeric(12,2) = null, 支票金额  
 @zhbz ut_zhbz = null,  账户标志   
 @zddm ut_zddm = null,  诊断代码  
 @zxlsh ut_lsh = null,  中心流水号  
 @jslsh ut_lsh = null,  计算流水号  
 @xmlb ut_dm2 = null,  大病项目  
 @qfdnzhzfje numeric(12,2) = null,  起付段当年账户支付  
 @qflnzhzfje numeric(12,2) = null, 起付段历年帐户支付  
 @qfxjzfje numeric(12,2) = null,  起付段现金支付  
 @tclnzhzfje numeric(12,2) = null, 统筹段历年帐户支付  
 @tcxjzfje numeric(12,2) = null,  统筹段现金支付  
 @tczfje numeric(12,2) = null,  统筹段统筹支付  
 @fjlnzhzfje numeric(12,2) = null, 附加段历年帐户支付  
 @fjxjzfje numeric(12,2) = null,  附加段历金支付  
 @dffjzfje numeric(12,2) = null  附加段地方附加支付  
 @dnzhye numeric(12,2) = null,  当年账户余额  
 @lnzhye numeric(12,2) = null,  历年账户余额  
 @qkbz smallint = 0     欠款标志0：正常，2：欠费  
 @jsrq ut_rq16 = ''     结算日期  
 @lcxmdm ut_xmdm='0'                     临床项目代码  
 @hjmxxh ut_xh12='0'   划价明细序号  
    @lcxmsl numeric(12,4)=0 --add by ctg at 2006.11.22 增加了lcxmsl  
[返回值]  
[结果集、排序]  
[调用的sp]  
 usp_sf_getsfpck --取收费窗口对应的配、发药窗口  
[调用实例]  
[修改说明]  
Modify By Koala 2003.02.13 for 吴淞中心医院   
 增加急诊收费的发药窗口处理，如果设置为急诊指定发药窗口的，则将发药窗口设置为YY_CONFIG中设置的发药窗口  
  
Modify by qxh  2003.2.27    
 增加按处方打印发票的处理   
  
Modify by Koala  2003.03.11 for 肿瘤医院    
 急诊实时医保病人的用药比例按住院比例处理  
  
tony 2003.8.21 修改了医保分类自负部分  
  
zwj 2003.09.09  医保四期修改  
  药品规格保存方式增加设置  
tony 2003.12.8 小城镇医保修改  
  
Modify by chenwei  2003.12.06 国宾  
 优惠处理，自由打折  
modify by szj  2004.02.18 充值卡需要提供密  
 码才可以收费添加了@czksfbz 参数。控制是否从充值卡上扣钱  
modify by agg   2004.07.09 增加对临床项目的支持  
yxp 2004-11-18 保存处方时，有时没有保存正确的yfdm或cflx，现增加判断：如发现yfdm或cflx不正确时报提示  
zwj 20050616 增加划价明细序号的处理  
ozb 20060321 增加二级药柜的处理  
sunyu 20061206 增加帮困病人不计分类自付金额的处理  
yxp 2007-5-15 开关3096设置为是时，如果上午病人开了项目处方，下午再开药品处方时，分配窗口会取上午分配的窗口，开关3096功能实现有误，修改usp_sf_sfcl.sql和usp_sf_getsfpck.sql解决，现在3096功能改在getsfpck中统一实现  
wfy 2007-5-18 按开关2130设置处理。以前急诊也是按门诊处理了   
ozb 2007-07-02 取收发配窗口时，增加根据返回信息判断是否成功  
ozb 2008-06-12 修改四舍五入的处理  
**********/  
set nocount on  
  
---by dingsong 自助机无sfksdm，默认  
if(len(@sfksdm)=0) begin select @sfksdm=case when len(@ksdm)=0 then (select top 1 ks_id from YY_ZGBMK where id=@czyh) else @ksdm end end  
--by dingsong 自助机不锁定处方，医生再次修改保存后导致处方库划价库数据不匹配，写入处方库时便锁定处方信息  
if(@czyh in ('999999','9999A9'))  
begin  
update SF_HJCFK set jlzt=5 where xh = @hjxh and jlzt=0  
end  
  
declare @config2490  varchar(5),  
  @config2491  varchar(5),  
  @config2490_js varchar(5), --儿童是否加收  
  @etnl   varchar(5), --儿童年龄  
  @etbirth  varchar(10),--儿童出生日期  
  @nowdate  varchar(10),  
  @jsksdm   varchar(8), --儿童加收科室代码  
  @ghxhtmp  ut_xh12  
select @config2490=config from YY_CONFIG where id='2490'  
select @config2491=config from YY_CONFIG where id='2491'  
select @config2490_js='',@etbirth='',@nowdate='',@etnl='',@jsksdm=''  
if @config2490>'0'  
begin  
 select @etbirth=birth from SF_BRXXK where patid=@patid  
 select @nowdate=convert(char(8),getdate(),112)  
 select @etnl=DATEDIFF( YEAR, @etbirth, @nowdate)  
 if cast(@etnl as int)<=cast(@config2490 as int)  
  set @config2490_js='是'  
end  
--生成递交的临时表  
declare @tablename varchar(32)  
declare @newfyckdm ut_dm2,  
  @acfdfp ut_bz,       --是否按处方打发票 0 不是， 1   
  @bkybdmjh varchar(255),  --帮困代码集合config0102  
  @mjzsybz varchar(20)  
declare @outmsg varchar(200)  
exec usp_yy_ldjzq @outmsg output  
if substring(@outmsg,1,1)='F'  
begin  
 select 'F',substring(@outmsg,2,200)  
 return  
end    
if (select config from YY_CONFIG (nolock) where id='2044')='否'  
 set @acfdfp=0  
else  
 set @acfdfp=1  
   
/*add by zkh for xq 179616*********************************begin*/  
--保存处方挂号是否按照医生开处方对应的挂号序号保存  
if (select config from YY_CONFIG (nolock) where id='2505')='是' AND isnull(@hjxh,0) <> 0  
BEGIN  
 SELECT @ghxh=ghxh FROM SF_HJCFK (NOLOCK) WHERE xh=@hjxh  
 --modified for bug 31599  
 select @ghsjh = jssjh from GH_GHZDK where xh = @ghxh  
END   
/*add by zkh for xq 179616*********************************end*/   
  
select @bkybdmjh=config from YY_CONFIG (nolock) where id='0102'  
  
select @tablename='##mzsf'+@wkdz+@czyh  
  
if @jszt=1  --创建表  
begin  
 exec('if exists(select * from tempdb..sysobjects where name="'+@tablename+'")  
  drop table '+@tablename)  
 exec('create table '+@tablename+'(  
  xh ut_xh12 identity(1,1) not null,  
  ksdm ut_ksdm not null,  
  ysdm ut_czyh not null,  
  yfdm ut_ksdm not null,  
  cfxh int not null,  
  hjxh ut_xh12 null,  
  cflx ut_bz not null,  
  sycfbz ut_bz not null,  
  tscfbz ut_bz not null,  
  cfts int not null,  
  dxmdm ut_kmdm not null,  
  xxmdm ut_xmdm not null,  
  idm ut_xh9 not null,  
  ypdw ut_unit null,  
  dwxs ut_dwxs not null,  
  fysl ut_sl10 not null,  
  ypdj ut_money null,  
  pyckdm ut_dm2 null,  
  fyckdm ut_dm2 null,  
  shbz ut_bz null,  
  yhdj ut_money null,  
  ypmc ut_mc64 null,  
        lcxmdm ut_xmdm null,  
  lcxmmc ut_mc32 null,  
  zbz  ut_bz null,  
  hjmxxh ut_xh12 null ,  
  lcxmsl numeric(12,4) null,  
  fybz ut_bz null,  
  yjqrbz ut_bz null,  
  yjclfbz ut_bz null,  
  wsbz    ut_bz null,  
        wsts    ut_sl10 null,  
        tbzddm  ut_mc32 null,  
        tbzdmc  ut_zdmc null,  
     ghxh ut_xh12 null  
  )')  --agg 2004.07.09 增加lcxmdm,lcxmmc,zbz  
 if @@error<>0  
 begin  
  select "F","创建临时表时出错！"  
  return  
 end  
  
 select "T"  
 return  
end  
--插入递交的记录  
if @jszt=2  
begin  
  
 declare @ccfxh varchar(8),  
  @chjxh varchar(12),  
  @ccflx varchar(2),  
  @csycfbz varchar(2),  
  @ctscfbz varchar(2),  
  @ccfts varchar(8),  
  @cidm varchar(9),  
  @cdwxs varchar(9),  
  @cfysl varchar(12),  
  @cypdj varchar(12),  
  @cshbz varchar(2),  
  @cyhdj varchar(12),  
  @cypmc varchar(64),  
  @clcxmmc varchar(32),  --agg 2004.07.09  
  @zbz ut_bz,             --agg 2004.07.09   
  @zxmdm ut_xmdm,         --agg 2004.07.09  
  @chjmxxh varchar(12),  
  @cfybz  varchar(2),  --自费转医保时用到的fybz  
  @cyjclfbz varchar(2),  
  @err_cfxx varchar(256),--错误处方信息  
  @czbz varchar(5),  
  @clcxmsl varchar(20),  
  @cyjqrbz varchar(5),  
  @cghxh  varchar(12)  
    
 select @ccfxh=convert(varchar(8),@cfxh),  
  @chjxh=convert(varchar(12),@hjxh),  
  @ccflx=convert(varchar(2),@cflx),  
  @csycfbz=convert(varchar(2),@sycfbz),  
  @ctscfbz=convert(varchar(2),@tscfbz),  
  @ccfts=convert(varchar(8),@cfts),  
  @cidm=convert(varchar(9),@idm),  
  @cdwxs=convert(varchar(9),@dwxs),  
  @cfysl=convert(varchar(12),@fysl),  
  @cypdj=convert(varchar(12),@ypdj,2),  
  @cshbz=convert(varchar(2),@shbz),  
  @cyhdj=convert(varchar(12),@yhdj,2),  
  @cypmc=convert(varchar(64),@ypmc),  
  @chjmxxh=convert(varchar(12),@hjmxxh),  
  @cfybz=convert(varchar(2),@fybz),  
  @cyjclfbz=convert(varchar(2),@yjclfbz),  
  @err_cfxx=''  
    
  ,@clcxmsl=convert(varchar(12),@lcxmsl)   
  ,@cyjqrbz =convert(varchar(5),@yjqrbz)  
  ,@cghxh =convert(varchar(12),isnull(@ghxh,0))   
  , @czbz =convert(varchar,@zbz)  
  
  --agg 2004.07.09 取lcxmmc begin  
 if @lcxmdm='' select @lcxmdm='0'   
  
 if @lcxmdm='0'  
 begin  
   select @clcxmmc=''  
   select @czbz='0'  
 end  
 else begin   
  select @clcxmmc=name,@zxmdm=zxmdm from YY_LCSFXMK where id=@lcxmdm  
  if @xxmdm=@zxmdm   
   select @czbz='0'  
  else   
   select @czbz='1'   
 end  
  select @clcxmmc=name from YY_LCSFXMK where id=@lcxmdm  
  --agg 2004.07.09 取lcxmmc end  
  
 select @pyckdm='', @fyckdm=''  
   
   
 --add h_ww 20150305 for 14182 判断阿里处方标志(alcfbz),如果存在转出到阿里的处方，则不允许收费  
 if exists(select 1 from SF_HJCFK(nolock) where xh=@chjxh and ISNULL(alcfbz,0)<>0)  
 begin  
  select @err_cfxx="存在转出到阿里的处方,不能收费！处方号="+  @chjxh + ";明细信息:"  
  select @err_cfxx = @err_cfxx + +char(13)+char(10)+ "名称("+ ypmc +")"  
   from SF_HJCFMXK(nolock) where cfxh=@chjxh   
       
  select "F",@err_cfxx  
  return  
 end  
 --项目代码和药品idm均未传入时，不做提交，否则结算会有问题  
 if @xxmdm='' and @cidm='0'  
 begin  
  select "T"  
  return  
 end  
  
  
 exec ('insert into '+@tablename+' values("'+@ksdm+'","'+@ysdm+'","'+@yfdm+'",'+@ccfxh+','  
  +@chjxh+','+@ccflx+','+@csycfbz+','+@ctscfbz+','+@ccfts+',"'+@dxmdm+'","'+@xxmdm+'",'  
  +@cidm+',"'+@ypdw+'",'+@cdwxs+','+@cfysl+','+@cypdj+',"'+@pyckdm+'","'+@fyckdm+'",' + @cshbz +','  
  +@cyhdj+',"'+@cypmc+'"'+',"'+@lcxmdm+'"'+',"'+@clcxmmc+'",'+@czbz+','+@chjmxxh+','+@clcxmsl+','  
  +@cfybz + ',' + @cyjqrbz + ',' + @cyjclfbz + ',0,0,"'+@tbzddm+'","'+@tbzdmc+'","'+@cghxh+'")')  --agg 2004.07.09 增加lcxmcm,lcxmmc,zbz    
    
 if @@error<>0  
 begin  
  select "F","插入临时表时出错2！"  
  return  
 end  
  
 select "T"  
 return  
end  
  
declare @now ut_rq16,  --当前时间  
  @zfbz smallint,  --比例标志  
  @rowcount int,  
  @error int,  
  @zje ut_money,  --药费总金额  
  @zje1 ut_money,  --非药费总金额  
  @zfyje ut_money, --自费药费金额  
  @zfyje1 ut_money, --自费非药费金额  
  @yhje ut_money,  --优惠药费金额  
  @yhje1 ut_money, --优惠非药费金额  
  @ybje ut_money,  --可用于医保计算的药费金额  
  @ybje1 ut_money, --可用于医保计算的非药费金额  
  @flzfje ut_money, --分类自负金额(药品)  
  @flzfje1 ut_money, --分类自负金额(非药品)  
  @flzfjedbxm ut_money, --分类自负金额(大病范围项目)  
  @pzlx ut_dm2,  --凭证类型  
  @sfje ut_money,  --实收金额(药品)  
  @sfje1 ut_money, --实收金额(非药品)  
  @sfje_all ut_money, --实收金额(包含自费金额)  
  @errmsg varchar(50),  
  @srbz char(1),  --舍入标志  
  @srje ut_money,  --舍入金额  
  @sfje2 ut_money, --舍入后的实收金额  
  @xhtemp ut_xh12,  
  @ksmc ut_mc32,  --科室名称  
  @ysmc ut_mc32,  --医生姓名  
--  @xmzfbl float,  --药品自付比例  
--  @xmzfbl1 float,  --非药品自付比例  
  @xmzfbl numeric(12,4),    
  @xmzfbl1 numeric(12,4), --mit ,, 2oo3-o7-28 ,,float的话四舍五入有问题   
  @xmce ut_money,  --自付金额和大项自付金额汇总的差额  
  @fplx smallint,  --发票类型  
  @fph bigint,   --发票号  
  @fpjxh ut_xh12,  --发票卷序号  
  @print smallint, --是否打印0打印，1不打  
  @pzh ut_pzh,  --凭证号  
  @brlx ut_dm2,  --病人类型  
  @qkbz1 smallint, --欠款标志0：正常，1：记账，2：欠费  
  @zhje ut_money,  --账户金额  
  @qkje ut_money,  --欠款金额（记账金额）  
  @jsfs ut_bz,  --结算方式  
  @mjzbz ut_bz,  --门急诊标志  
         @zfje  ut_money,  
         @zjecf ut_money,  
  @zfyjecf ut_money,  
         @yhjecf  ut_money,  
  @ekbz ut_bz,  --儿科标志  
    @nl int, --照顾病人年龄下限  
  @csybdm varchar(255),  
  @sqdxh ut_xh12,   
  @ejygbz ut_bz,  --二级药柜标志 add by ozb 20060320   
  @ejygksdm ut_ksdm --二级药柜科室代码 add by sunyu 2006-03-24   
  ,@qkbz2  ut_bz  
  ,@yydjje ut_money  --预约冻结金额  
  ,@ybjkid ut_bz  
  ,@sfly   ut_bz --add by yxc 收费来源  
  ,@config2366 varchar(128)  
  ,@config2367 varchar(128)  
  ,@yscfbz ut_bz  --延伸处方标志  
  ,@ccfbz ut_bz   --长处方标志  
  ,@config2394 varchar(10)  
  ,@config2157 varchar(10)  
  ,@hjmxts int  
  ,@sfmxts int  
  ,@config2395 varchar(500)  
  ,@config2466 varchar(10)  
declare @brnl integer ,   --病人年龄  
   @zcbz ut_bz,    
   @pyzc ut_dm2,    
   @fyzc ut_dm2    
  
  
declare @ybzje ut_money, --医保交易费用总额  
 @ybjszje ut_money, --医保结算范围费用总额  
 @ybzlf ut_money, --治疗费  
 @ybssf ut_money, --手术材料费  
 @ybjcf ut_money, --检查费  
 @ybhyf ut_money, --化验费  
 @ybspf ut_money, --摄片费  
 @ybtsf ut_money, --透视费  
 @ybxyf ut_money, --西药费  
 @ybzyf ut_money, --中成药费  
 @ybcyf ut_money, --中草药费  
 @ybqtf ut_money, --其它费  
 @ybgrzf ut_money, --非医保结算范围个人自费  
 @yjbz ut_bz,  --是否使用充值卡  
 @yjye ut_money,  --预交金余额  
 @yjzfje ut_money, --预交金支付余额  
 @yjyebz varchar(2), --充值卡余额不足是否允许继续收费  
 @ypggbz varchar(2), --是否使用药品规格  
 @djje ut_money,  --冻结金额  
 @tcljbz ut_bz,  --统筹累计标志  
 @tcljje1 ut_money, --统筹累计金额（镇保、新疆回沪使用）   
 @qkje2 ut_money,  --帮困金额 保留两位小数  
 @sfje_bkall ut_money, --帮困实收金额(包含自费金额)  
 @lcyhje ut_money, -- 零差优惠金额  
 @hjcfjlzt ut_bz,  
 @jfbz varchar(2),  
 @jfje ut_money,  
 @wsbz ut_bz,  --外送处方标志  
 @wsts ut_sl10  --外送处方帖数  
--会员卡功能修改新增变量 zwj 2006.12.12  
declare @hykmsbz ut_bz  --会员卡模式标志  
 ,@hysybz ut_bz  --会员使用标志(YY_YBFLK中hysybz)  
 ,@tjmfbz ut_bz  --体检收费表示，会员卡记录免费体检用  
    ,@ylxzbh ut_xh9     --医疗组编号  
 ,@gsbz ut_bz  --挂失标志  
declare @config2206 varchar(50)  
  ,@vipyxe ut_money  
  ,@vipfylj ut_money  
  ,@config2422   varchar(10) --2422新药品冻结方案  
select @now=convert(char(8),getdate(),112)+convert(char(8),getdate(),8),  
 @zje=0, @zfyje=0, @yhje=0, @ybje=0,  
 @zje1=0, @zfyje1=0, @yhje1=0, @ybje1=0,  
 @sfje=0, @sfje1=0, @sfje_all=0, @srje=0, @sfje2=0,   
 @xmzfbl=0, @xmzfbl1=0, @xmce=0, @print=0, @fplx=0,@flzfjedbxm=0,  
 @qkbz1=0, @qkje=0, @mjzbz=1, @jsfs=0, @ekbz=0,  
 @flzfje=0, @flzfje1=0, @tcljbz=0, @tcljje1=0, @hykmsbz=0, @tjmfbz=0  
 ,@lcyhje = 0,@jfbz = '0',@jfje = 0,@hjmxts = 0,@sfmxts = 0  
select  @ybzje=0, @ybjszje=0, @ybzlf=0, @ybssf=0,  
 @ybjcf=0, @ybhyf=0, @ybspf=0, @ybtsf=0,  
 @ybxyf=0, @ybzyf=0, @ybcyf=0, @ybqtf=0,  
 @ybgrzf=0, @yjbz=0, @yjye=0, @yjzfje=0,@yydjje = 0,  
 @hjcfjlzt=0  
 ,@ylxzbh=0  
declare @config2297 varchar(128)  
if exists(select 1 from YY_CONFIG where id='2297')  
    select @config2297=rtrim(config) from YY_CONFIG where id='2297'  
else  
    select @config2297=''  
  
if exists(select 1 from YY_CONFIG where id='2366')  
    select @config2366=rtrim(config) from YY_CONFIG where id='2366'  
else  
    select @config2366=''  
  
if exists(select 1 from YY_CONFIG where id='2367')  
    select @config2367=rtrim(config) from YY_CONFIG where id='2367'  
else  
    select @config2367=''  
  
if exists(select 1 from YY_CONFIG where id='2394')  
    select @config2394=rtrim(config) from YY_CONFIG where id='2394'  
else  
    select @config2394='否'  
      
 if exists(select 1 from YY_CONFIG where id='2157')  
    select @config2157 =rtrim(config) from YY_CONFIG where id='2157'  
else  
   select @config2157 ='否'     
     
if exists (select 1 from YY_CONFIG(nolock) where id='2395')  
    select @config2395=isnull(config,'') from YY_CONFIG(nolock) where id='2395'  
else  
    select  @config2395=''  
if exists (select 1 from YY_CONFIG(nolock) where id='2101' and config='是')  
    and exists (select 1 from YY_CONFIG(nolock) where id='2422' and config='是')  
begin  
    select 'F','药品冻结方案只能二选一,当前参数【2101,2422】设置都为是,请修改设置!'  
    return  
end  
select @config2466=config from YY_CONFIG(nolock) where id='2466'   
if exists(select 1 from YY_CONFIG where id='2422')  
    select @config2422=config from YY_CONFIG(nolock) where id='2422'  
else  
    select @config2422 ='否'   
--{TODO -oyfq -c2016-12 : 医保高价药政策改造 as @#$ begin}  
declare @config2451 char(2)  
 ,@gjybz ut_bz  
 ,@gjyzje ut_money  
 ,@gjyzfje ut_money  
 ,@gjyzje1 ut_money  
 ,@gjyzfje1 ut_money  
if exists (select 1 from YY_CONFIG where id='2451' and config='是')  
    select @config2451='是'  
else  
    select @config2451='否'  
select @gjybz=0,@gjyzje=0,@gjyzfje=0,@gjyzje1=0,@gjyzfje1=0  
--{TODO -oyfq -c2016-12 : 医保高价药政策改造 as @#$ end}   
--收费预算  
if @sfbz=0  
begin  
 --开始插入账单、明细表的处理流程  
 create table #mzsftmp  
 (  
  xh ut_xh12 not null,  
  ksdm ut_ksdm not null,  
  ysdm ut_czyh not null,  
  yfdm ut_ksdm not null,  
  cfxh int not null,  
  hjxh ut_xh12 null,  
  cflx ut_bz not null,  
  sycfbz ut_bz not null,  
  tscfbz ut_bz not null,  
  cfts int not null,  
  dxmdm ut_kmdm not null,  
  xxmdm ut_xmdm not null,  
  idm ut_xh9 not null,  
  ypdw ut_unit null,  
  dwxs ut_dwxs not null,  
  fysl ut_sl10 not null,  
  ypdj ut_money null,  
  pyckdm ut_dm2 null,  
  fyckdm ut_dm2 null,  
  shbz ut_bz null,  
  yhdj ut_money null,  
  ypmc ut_mc64 null,  
  lcxmdm ut_xmdm null,  --agg 2004.07.09    
  lcxmmc ut_mc32 null,  --agg 2004.07.09   
  zbz ut_bz null,       --agg 2004.07.09  
  hjmxxh ut_xh12 null,  
  lcxmsl numeric(12,4) null,  --ctg 2006.11.24   
  fybz ut_bz null, --自费转医保用  
  yjqrbz ut_bz null, --自费转医保用  
  yjclfbz ut_bz null,  
  wsbz ut_bz null,  
        wsts ut_sl10 null,  
        tbzddm  ut_mc32 null,  
        tbzdmc  ut_zdmc null,  
        ghxh ut_xh12 null  
 )   
    
 exec('insert into #mzsftmp select * from '+@tablename)  
 if @@error<>0  
 begin  
  select "F","插入临时表时出错3！"  
  return  
 end  
   
 exec('drop table '+@tablename)  
   
  
 --add by yangdi 2012.6.26 个体体检，传入收费明细时打印两张发票，程序bug处理        
 if exists (select 1 from #mzsftmp where isnull(xxmdm,'')='')        
 begin        
  delete from #mzsftmp where isnull(xxmdm,'')=''        
 end        
  
 --开始处理收费项目  
 create table #sfzd  
 (  
  cfxh int not null,  
  ksdm ut_ksdm not null,  
  ysdm ut_czyh not null,  
  yfdm ut_ksdm not null,  
  hjxh ut_xh12 null,  
  cflx ut_bz not null,  
  sycfbz ut_bz not null,  
  tscfbz ut_bz not null,  
  cfts int not null,  
  pyckdm ut_dm2 null,  
  fyckdm ut_dm2 null,  
  zje    ut_money null,           
  zfyje  ut_money null,  
  yhje   ut_money null,  
  zfje   ut_money null,  
  srje   ut_money null,    
  fph    bigint null,  
  fpjxh ut_xh12   null,  
  ejygbz ut_bz null, --add by ozb 20060320 二级药柜标志  
  ejygksdm ut_ksdm null, --add by sunyu 2006-03-24 二级药柜科室代码  
  fybz ut_bz null, --自费转医保用  
  wsbz ut_bz null,  
  wsts ut_sl10 null,  
  tbzddm  ut_mc32 null,  
        tbzdmc  ut_zdmc null,  
        yscfbz ut_bz null,  
        ccfbz ut_bz null,  
        ghxh ut_xh12 null  
 )  
  
  
 --门急诊标志2002.10.21 / 此段从下面移到此处，以便使用@mjzbz 2003.02.25  
   
 select @mjzsybz = config from YY_CONFIG where id = '2130'  
 if @mjzsybz = '是'  
  select @mjzbz = @sflb  
 else  
 begin  
  select @mjzbz=mjzbz from SF_BRJSK (nolock) where sjh=@ghsjh  
  if @@rowcount=0  
   select @mjzbz=1  --门诊病人  
    end  
  select @nl=isnull(convert(int,config),70) from YY_CONFIG where id='2109'  
  
   select @brnl = datediff(yy,birth,substring(@now,1,8))    
    from SF_BRXXK where patid = @patid    
    
   select @zcbz = 0    
 if (@sjh='zzj' or @sjh='zzsf') select @sfly=1  
 if @sjh='yszdy' select @sfly=2  
 if @sjh='mzyj'  select @sfly=3  
 if ltrim(rtrim(@sjh))='000' select @sfly=0   
 /*重新设置处方对应的配、发药窗口, Wang Yi 2003.02.25, begin*/  
  
/*  
 if isnull(@qrbz,0)=0  
 begin  
  create table #tmp_sfpck(  
    yfdm ut_ksdm not null  
   ,pyckdm ut_dm2 null  
   ,fyckdm ut_dm2 null  
   )  
   
  declare cr_getpfck cursor for  
   --select distinct yfdm from #mzsftmp where cflx <> 4  
   select distinct yfdm from #mzsftmp where cflx in (1,2,3) --体检处方、医技处方也不需要取配药发药窗口  
  open cr_getpfck  
  fetch cr_getpfck into @yfdm  
  while @@fetch_status = 0   
  begin  
     if @brnl >= @nl     
     begin    
       if exists (select 1 from YF_FYCKDMK  where yfdm = @yfdm and zcbz = 1 and sybz = 0 )  
         select @zcbz = 1    
       else    
         select @zcbz = 0    
     end    
     --增加70岁以上老人专窗处理  
     if @zcbz =1     
     begin    
       select @pyckdm = id from YF_PYCKDMK     
        where yfdm = @yfdm and zcbz = 1    
     
       select @fyckdm = id  from YF_FYCKDMK     
        where yfdm = @yfdm and zcbz = 1    
     end    
     else    
     begin         
    exec usp_sf_getsfpck @sfckdm, @yfdm, @mjzbz, @fyckdm output, @pyckdm output,@patid,@errmsg output  
   end  
   if @@error <> 0   
   begin  
    deallocate cr_getpfck  
    select "F", "取对应配、发药窗口出错！"  
    return  
   end  
   --add by ozb 20070702 增加根据返回信息判断  
   if left(@errmsg,1)<>'T'  
   begin  
    deallocate cr_getpfck  
    select "F", substring(@errmsg,2,49)  
    return  
   end  
   insert into #tmp_sfpck( yfdm, pyckdm, fyckdm) values(@yfdm, @pyckdm, @fyckdm)  
   fetch cr_getpfck into @yfdm  
  end  
   
  deallocate cr_getpfck   
   
  update #mzsftmp set pyckdm = b.pyckdm, fyckdm = b.fyckdm  
   from #mzsftmp a, #tmp_sfpck b  
   where a.yfdm = b.yfdm  
   
  ----  2005-05-17 增加费别对应发药窗口，如果有发药窗口，即isnull(@cflx,0) in (1,2,3) 才更改  
  if exists (select 1 from YY_YBFLK nolock where ybdm = @ybdm and (isnull(dypyckdm,'') <> '' or isnull(dyfyckdm,'') <> ''))  
  begin  
   update #mzsftmp set pyckdm = case when isnull(b.dypyckdm,'') <> '' then b.dypyckdm else a.pyckdm end,  
    fyckdm = case when isnull(b.dyfyckdm,'') <> '' then b.dyfyckdm  else a.fyckdm end   
    from #mzsftmp a,YY_YBFLK b  
    where b.ybdm = @ybdm and isnull(a.cflx,0) in (1,2,3)  
   if @@error<>0   
   begin  
    select "F","读取费别对应的窗口时出错！"  
    return  
   end  
  end  
 end  
*/  
 /*重新设置处方对应的配、发药窗口, Wang Yi 2003.02.25, end*/  
  
 /*将收费处方插入临时表 begin*/  
 insert into #sfzd   
 select distinct cfxh, ksdm, ysdm, yfdm, hjxh, cflx, sycfbz, tscfbz, cfts, pyckdm, fyckdm,null,null,null,null,null,0,null,0,null,  
 fybz,wsbz,wsts,tbzddm,tbzdmc,0,0,ghxh from #mzsftmp   
 where isnull(xxmdm,'')<>'' and isnull(ypmc,'')<>''  
 order by cfxh -- add by ozb 增加二级药柜标志  
 if @@error<>0 or @@rowcount=0  
 begin  
  select "F","处理收费处方时出错！"  
  return  
 end  
 /*将收费处方插入临时表 end*/  
  
 /*判断收费明细条数是否与处方明细条数一致 begin*/  
 if @config2394 = '是'  or @config2157 = '否'   
 begin  
   
  declare @wkcypxx varchar(8000),  
    @kcbgts  int  --库存不够的条数  
  select @wkcypxx = char(10)+CHAR(13)+'无库存药品信息：'   
  select @kcbgts =0  
    
    
  select @sfmxts = count(b.xh) from #mzsftmp a,SF_HJCFMXK b(nolock) where isnull(a.hjmxxh,0) <> 0 and a.hjmxxh = b.xh  
  select @hjmxts = count(b.xh) from #sfzd a,SF_HJCFMXK b(nolock) where a.hjxh = b.cfxh and isnull(b.lcxmdm,'0')='0'  
  select @hjmxts = @hjmxts + count(c.xmdm) from #sfzd a,SF_HJCFMXK b,YY_LCSFXMDYK c(nolock) where a.hjxh = b.cfxh and isnull(b.lcxmdm,'0')<>'0' and b.lcxmdm = c.lcxmdm   
  --  
    
  select  * into #hjmxk_tmp from  SF_HJCFMXK a(nolock) where a.cfxh  in (select b.hjxh from #mzsftmp b) and a.cd_idm > 0  
  select @wkcypxx = @wkcypxx+char(10)+CHAR(13)+'  ['+a.ypmc+']'    
      from #hjmxk_tmp a left join #mzsftmp b on a.xh = b.hjmxxh and b.idm > 0  
         inner join SF_HJCFK d(nolock) on a.cfxh = d.xh  
         left join YF_YFZKC c(nolock) on  a.cd_idm = c.cd_idm  
  where d.yfdm = c.ksdm and (a.ypsl*a.ypxs*a.cfts/c.mzxs) > (c.kcsl3-c.djsl)  
  select @kcbgts = @@ROWCOUNT  
       
  if @sfmxts <> @hjmxts and @config2394='是'  
  begin  
        
   select "F","划价明细条数与收费明细条数不一致，请检查相应数据"+case when @kcbgts > 0 then  @wkcypxx else '' end  
   return  
  end   
    
  if  @kcbgts > 0 and @config2157 = '否' and @config2422<>'是'  
  begin  
   select "F","库存不够，"+@wkcypxx  
   return  
  end  
       
 end;  
 /*判断收费明细条数是否与处方明细条数一致 end*/  
    
 /*收费前进行情况判断 begin*/  
 select * into #brxxk from SF_BRXXK where patid=@patid  
 if @@rowcount=0 or @@error<>0  
 begin  
  select "F","患者基本信息不存在！"  
  return  
 end  
 --add by winning-dingsong-chongqing on 20200213  
 if not exists(select 1 from #brxxk a inner join GH_GHZDK b on a.patid=b.patid and a.hzxm=b.hzxm where a.patid=@patid)  
 begin  
  update a set a.hzxm=b.hzxm from #brxxk a inner join GH_GHZDK b on a.patid=b.patid where a.patid=@patid  
 end  
  
 select @pzh=pzh, @zhje=zhje, @tcljje1=isnull(ljje,0) from #brxxk  
 select @zfbz=zfbz, @pzlx=pzlx, @brlx=brlxdm, @qkbz1=zhbz,@jsfs=jsfs, @hysybz=hysybz, @qkbz2  = zhbz, @ybjkid=isnull(ybjkid,0) from YY_YBFLK (nolock) where ybdm=@ybdm  
 if @@rowcount=0 or @@error<>0  
 begin  
  select "F","患者费用类别不正确！"  
  return  
 end  
  
   
   
 --统筹金额独立配置的医保代码  
 if exists(select 1 from YY_CONFIG (nolock) where charindex('"'+rtrim(@ybdm)+'"',config)>0 and id='0115')  
 begin  
  select @tcljje1=tcljje from YY_BRLJXXK nolock where mzpatid = @patid  
 end  
 select @hykmsbz = config from YY_CONFIG where id='0099'  
 if @@error<>0  
 begin  
  select "F","门诊会员卡模式设置不正确！"  
  return  
 end  
  
 if @hykmsbz=0  
 begin  
  select @yydjje=sum(isnull(djje,0)) from GH_GHYYK(nolock) where patid=@patid and djbz=1 and jlzt = 0   
  
  select @yjye=isnull(yjye,0)-isnull(@yydjje,0),@gsbz=gsbz  from YY_JZBRK where patid=@patid and jlzt=0  
  if @@rowcount=0  
   select @yjye=0  --预交金余额  
  else  
   select @yjbz=1 --是否使用充值卡  
  
  if @gsbz=1  
  begin  
   select "F","充值卡已挂失，不能使用！"  
   return  
  end  
 end  
 else  
 begin  
  execute usp_yy_jzbryjye @patid, @ybdm, @hysybz, 0, @errmsg output  
  if @errmsg like "F%"  
  begin  
   select "F",substring(@errmsg,2,49)  
   return  
  end  
  else  
   select @yjye=convert(numeric(10,2),substring(@errmsg,2,11))  
  
  if @yjye=0  
   select @yjbz=0  
  else  
   select @yjbz=1  
 end  
  
 if @yjbz =1--add wuwei 2011-06-08 for bug 95182 多发票结算模式下，先扣除掉前面已经用来预算的yjye  
 begin  
  select @yjye =@yjye -@dfpzhzfje  
  if @yjye <0 --add wuwei 以防万一，判断一把  
  begin  
   select 'F','多发票结算计算押金余额出错！'  
   return  
  end  
 end  
 select @yjyebz = config from YY_CONFIG where id='2059'  
 if @@rowcount=0 or @@error<>0  
 begin  
  select "F","充值卡余额不足是否允许继续收费设置不正确！"  
  return  
 end  
  
 select @ypggbz='否'  
  
 select @ypggbz = config from YY_CONFIG where id='2063'  
 if @@error<>0  
 begin  
  select "F","药品规格保存方式设置不正确！"  
  return  
 end  
  
 select @csybdm = ltrim(rtrim(config)) from YY_CONFIG where id = '1106'  
 if @@error<>0  
 begin  
  select "F","慈善医保代码设置不正确！"  
  return  
 end  
  
 /*收费前进行情况判断 end*/  
  
 if exists(select 1 from GH_GHZDK a (nolock) where a.xh=@ghxh and exists(select 1 from YY_KSBMK b (nolock) where a.ksdm=b.id and b.ekbz=1))  
  select @ekbz=1  
  
 --欠款的第一次递交不处理  
 if @qkbz1=2  
  select @qkbz1=0  
  
 --帐户无金额作为普通处理  
 if @qkbz1=1 and @zhje=0  
  select @qkbz1=0  
  
 if @pzlx not in (10,11)  
  select @xmlb=ylxm, @zddm=zddm from SF_YBPZK (nolock) where pzh=@pzh and patid=@patid and pzlx=@pzlx  
   
 select a.cfxh, a.idm, b.gg_idm, b.ypmc, a.xxmdm, a.fysl*a.dwxs as fysl, a.cfts,   
     b.yplh as dxmdm, c.name as dxmmc, b.ylsj, b.ypfj, b.zfbz, b.zfbl,   
     0 as yhbz, convert(numeric(6,4),0) as yhbl, convert(money, 0) as zfdj, isnull(a.yhdj,convert(money, 0)) yhdj,  
     c.mzfp_id, c.mzfp_mc, a.ypdw, a.dwxs, b.ykxs, b.sxjg, b.ypgg, a.shbz, b.flzfbz,  
     convert(money, 0) as flzfdj,convert(money,0) as dffbz,convert(numeric(6,4),0) as txbl,a.lcxmdm,a.lcxmmc,a.zbz,a.hjmxxh, 0 as ejygbz,a.lcxmsl,b.dydm --add "dydm" 20070119 --agg 2004.07.09 增加lcxmdm,lcxmmc,zbz --add by ozb 20060320 增加二级药柜标志  
  ,b.lcjsdj,b.ylsj*0  yyhdj,a.xh 'ind',a.yjqrbz yjqrbz,a.yfdm,convert(smallint,0) 'mxwsbz'  
  --,convert(varchar(24),'') as memo  
  --modified by mxd for bug:291335 后面会根据VW_MZHJCFMXK.memo去更新#sfmx.memo，会报截断  
  ,convert(varchar(256),'') as memo   
  ,convert(money, 0) txdj,0 djjsbz,a.ksdm  
  ,0 gjybz,convert(money,0) gjydeje  
  into #sfmx  
     from #mzsftmp a, YK_YPCDMLK b (nolock), YY_SFDXMK c (nolock)  
     where a.idm>0 and b.idm=a.idm and c.id=b.yplh and 1=2   
 if @@error<>0  
 begin  
  select "F","计算收费费用时出错！"  
  return  
 end  
  
 --计算收费费用  
    /*判断是否为急诊的实时医保病人 begin*/  
    if @pzlx in (10,11) and @mjzbz = 2 and (select config from YY_CONFIG (nolock) where id='2048')='是' --急诊收费是否按照住院自费比例  
    begin  
  insert into #sfmx  
     select a.cfxh, a.idm, b.gg_idm, b.ypmc, a.xxmdm, a.fysl*a.dwxs as fysl, a.cfts,   
     b.yplh as dxmdm, c.name as dxmmc, b.ylsj, b.ypfj, b.zyzfbz, b.zyzfbl,  
     0 as yhbz, convert(numeric(6,4),0) as yhbl, convert(money, 0) as zfdj, isnull(a.yhdj*b.ykxs/a.dwxs,convert(money, 0)) yhdj,  
     c.mzfp_id, c.mzfp_mc, a.ypdw, a.dwxs, b.ykxs, b.sxjg,   
     case when (@ekbz=1 and @ypggbz='是') then (LTrim(RTrim(Case When b.ggxs>=1 And Floor(b.ggxs)*10=Floor(b.ggxs*10) Then  Str(b.ggxs,12,0)   
     When b.ggxs>=1 And Floor(b.ggxs*10)*10=Floor(b.ggxs*100) Then  Str(b.ggxs,12,1)    
     When b.ggxs<1 And Floor(b.ggxs*10)*10=Floor(b.ggxs*100) Then Str(b.ggxs,12,1)    
     When b.ggxs<1 And Floor(b.ggxs*100)*10=Floor(b.ggxs*1000) Then Str(b.ggxs,12,2)    
     When b.ggxs<1 And Floor(b.ggxs*1000)*10=Floor(b.ggxs*10000) Then Str(b.ggxs,12,3)   
     Else Str(b.ggxs,12,4) end ))   
          + LTrim(RTrim(b.ggdw))+'×'+LTrim(RTrim(str(b.ekxs,6,0)))      
          + LTrim(RTrim(b.zxdw))+'/' +LTrim(RTrim(b.ekdw)))  
     when (@ekbz=0 and @ypggbz='是') then (LTrim(RTrim(Case When b.ggxs>=1 And Floor(b.ggxs)*10=Floor(b.ggxs*10) Then  Str(b.ggxs,12,0)   
     When b.ggxs>=1 And Floor(b.ggxs*10)*10=Floor(b.ggxs*100) Then  Str(b.ggxs,12,1)    
     When b.ggxs<1 And Floor(b.ggxs*10)*10=Floor(b.ggxs*100) Then Str(b.ggxs,12,1)    
     When b.ggxs<1 And Floor(b.ggxs*100)*10=Floor(b.ggxs*1000) Then Str(b.ggxs,12,2)    
     When b.ggxs<1 And Floor(b.ggxs*1000)*10=Floor(b.ggxs*10000) Then Str(b.ggxs,12,3)   
     Else Str(b.ggxs,12,4) end ))   
          + LTrim(RTrim(b.ggdw))+'×'+LTrim(RTrim(str(b.mzxs,6,0)))      
          + LTrim(RTrim(b.zxdw))+'/' +  LTrim(RTrim(b.mzdw)))   
     else b.ypgg end, a.shbz, b.zyflzfbz, 0,isnull(b.dffbz,0),convert(numeric(6,4),0) as txbl,a.lcxmdm,a.lcxmmc,a.zbz,a.hjmxxh,0,a.lcxmsl,b.dydm --add "dydm" 20070119  --agg 2004.07.09 增加lcxmdm,lcxmmc,zbz --add by ozb 20060320 ejygbz  
   ,b.lcjsdj,0,a.xh,a.yjqrbz,a.yfdm,0,''  
   ,convert(money, 0) txdj,0 djjsbz,a.ksdm,0,0  
     from #mzsftmp a, YK_YPCDMLK b (nolock), YY_SFDXMK c (nolock)  
     where a.idm>0 and b.idm=a.idm and c.id=b.yplh   
    end  
    else begin  
        insert into #sfmx  
     select a.cfxh, a.idm, b.gg_idm, b.ypmc, a.xxmdm, a.fysl*a.dwxs as fysl, a.cfts,   
                                      --zxm 20190304 b.ylsj不能直接取，如果原b.ylsj=0且用户在前台界面输入了自己的价格，传进来就要取输入的价格。BUG 40045   
     b.yplh as dxmdm, c.name as dxmmc, case when isnull(b.ylsj,0)=0 then a.ypdj else b.ylsj end, b.ypfj, b.zfbz, b.zfbl,   
     0 as yhbz, convert(numeric(6,4),0) as yhbl, convert(money, 0) as zfdj, isnull(a.yhdj*b.ykxs/a.dwxs,convert(money, 0)) yhdj,  
     c.mzfp_id, c.mzfp_mc, a.ypdw, a.dwxs, b.ykxs, b.sxjg,   
     case when (@ekbz=1 and @ypggbz='是') then (LTrim(RTrim(Case When b.ggxs>=1 And Floor(b.ggxs)*10=Floor(b.ggxs*10) Then  Str(b.ggxs,12,0)   
     When b.ggxs>=1 And Floor(b.ggxs*10)*10=Floor(b.ggxs*100) Then  Str(b.ggxs,12,1)    
     When b.ggxs<1 And Floor(b.ggxs*10)*10=Floor(b.ggxs*100) Then Str(b.ggxs,12,1)    
     When b.ggxs<1 And Floor(b.ggxs*100)*10=Floor(b.ggxs*1000) Then Str(b.ggxs,12,2)    
     When b.ggxs<1 And Floor(b.ggxs*1000)*10=Floor(b.ggxs*10000) Then Str(b.ggxs,12,3)   
     Else Str(b.ggxs,12,4) end ))   
          + LTrim(RTrim(b.ggdw))+'×'+LTrim(RTrim(str(b.ekxs,6,0)))      
          + LTrim(RTrim(b.zxdw))+'/' +LTrim(RTrim(b.ekdw)))  
     when (@ekbz=0 and @ypggbz='是') then (LTrim(RTrim(Case When b.ggxs>=1 And Floor(b.ggxs)*10=Floor(b.ggxs*10) Then  Str(b.ggxs,12,0)   
     When b.ggxs>=1 And Floor(b.ggxs*10)*10=Floor(b.ggxs*100) Then  Str(b.ggxs,12,1)    
     When b.ggxs<1 And Floor(b.ggxs*10)*10=Floor(b.ggxs*100) Then Str(b.ggxs,12,1)    
     When b.ggxs<1 And Floor(b.ggxs*100)*10=Floor(b.ggxs*1000) Then Str(b.ggxs,12,2)    
     When b.ggxs<1 And Floor(b.ggxs*1000)*10=Floor(b.ggxs*10000) Then Str(b.ggxs,12,3)   
   Else Str(b.ggxs,12,4) end ))   
          + LTrim(RTrim(b.ggdw))+'×'+LTrim(RTrim(str(b.mzxs,6,0)))      
          + LTrim(RTrim(b.zxdw))+'/' +  LTrim(RTrim(b.mzdw)))   
     else b.ypgg end, a.shbz, b.flzfbz, 0,isnull(b.dffbz,0),convert(numeric(6,4),0) as txbl,a.lcxmdm,a.lcxmmc,a.zbz,a.hjmxxh,0,a.lcxmsl,b.dydm --add "dydm" 20070119   --agg 2004.07.09 增加lcxmdm,lcxmmc,zbz --add by ozb 20060320 ejygbz  
   ,b.lcjsdj,0,a.xh,a.yjqrbz,a.yfdm,0,''  
   ,convert(money, 0) txdj,0 djjsbz,a.ksdm,0,0  
     from #mzsftmp a, YK_YPCDMLK b (nolock), YY_SFDXMK c (nolock)  
     where a.idm>0 and b.idm=a.idm and c.id=b.yplh  
    end  
 select @error=@@error, @rowcount=@@rowcount  
 if @error<>0  
 begin  
  select "F","计算收费费用时出错！"  
  return  
 end  
  /*判断是否为急诊的实时医保病人 end*/  
  
 insert into #sfmx  
 select a.cfxh, 0, 0, case when ltrim(rtrim(b.name))<>ltrim(rtrim(a.ypmc)) then a.ypmc else b.name end, a.xxmdm, a.fysl, a.cfts,   
  b.dxmdm, c.name as dxmmc, (case when (a.cflx=6) or (b.xmdj=0) then a.ypdj else b.xmdj end),   
  (case when b.xmdj=0 then a.ypdj else b.xmdj end),   
  b.mzzfbz, b.mzzfbl, (case when b.yhbl>0 then 1 else 0 end), b.yhbl, 0, isnull(a.yhdj,convert(money, 0)) yhdj,  
  c.mzfp_id, c.mzfp_mc, a.ypdw, a.dwxs, 1, b.sxjg, b.xmgg, a.shbz, b.flzfbz, 0,0,convert(numeric(6,4),0) as txbl,a.lcxmdm,a.lcxmmc,a.zbz,a.hjmxxh,0 ,a.lcxmsl,b.dydm --add "dydm" 20070119   --agg 2004.07.09 增加lcxmdm,lcxmmc,zbz --add by ozb 20060320 ejygbz 
  
  
  
  
   
   
   
  
  
   
   
  
  
  ,0 as lcjsdj,0,a.xh,a.yjqrbz,a.yfdm,0,''  
  ,convert(money, 0) txdj,0 djjsbz,a.ksdm,0,0  
  from #mzsftmp a, YY_SFXXMK b (nolock), YY_SFDXMK c (nolock)  
  where a.idm<=0 and b.id=a.xxmdm and c.id=b.dxmdm   
 select @error=@@error, @rowcount=@rowcount+@@rowcount  
 if @error<>0  
 begin  
  select "F","计算收费费用时出错！"  
  return  
 end  
  
 if @rowcount=0  
 begin  
  select "F","收费项目不存在，请输入收费项目！"  
  return  
 end  
 else   
 begin  
  --儿童加收begin add by wang_qiang 20170704  
  if @config2490_js='是'  
  begin  
   if @config2491='是'  
   begin  
    update a set a.ylsj=a.ylsj+b.etjsje   
    from #sfmx a  
    inner join YK_YPCDMLKZK b(nolock) on b.idm=a.idm  
    inner join YY_KSJSXMDYK c(nolock) on c.ksdm=a.ksdm and c.idm=b.idm and c.idm>0  
    where a.idm>0 and b.etjsbz=1   
      
    update a set a.ylsj=a.ylsj+b.etjsje   
    from #sfmx a  
    inner join YY_SFXXMK b (nolock) on b.id=a.xxmdm  
    inner join YY_KSJSXMDYK c(nolock) on c.ksdm=a.ksdm and c.ypdm=b.id and c.idm<=0  
    where a.idm<=0 and b.etjsbz=1  
   end  
   else if @config2491='否'  
   begin  
    update a set a.ylsj=a.ylsj+b.etjsje   
    from #sfmx a  
    inner join YK_YPCDMLKZK b(nolock) on b.idm=a.idm  
    where a.idm>0 and b.etjsbz=1  
      
    update a set a.ylsj=a.ylsj+b.etjsje   
    from #sfmx a  
    inner join YY_SFXXMK b (nolock) on b.id=a.xxmdm  
    where a.idm<=0 and b.etjsbz=1  
   end  
  end  
  --儿童加收end add by wang_qiang 20170704  
    
  /*计算收费费用 begin */  
  if not ((select config from YY_CONFIG (nolock) where id='2254')='是' AND @cflx=6) -- add by h_wh bug 60660  
  begin  
   update #sfmx set ylsj=a.ylsj*b.sfbl,ypfj=a.ypfj*b.sfbl  
    from #sfmx a,YY_LCSFXMK b  
    where a.lcxmdm=b.id and isnull(a.lcxmdm,"0")<>"0" and b.sfbl>0  
   if @@error<>0  
   begin  
    select "F","计算收费费用时出错！"  
    return  
   end  
  end  
     --处理临床项目中单个收费项目的shbz     
     update a set shbz = e.ybshbz  
     from #sfmx a,SF_HJCFMXK b(nolock),SF_HJCFK c(nolock),dbo.SF_MZSQD d(nolock),SF_SQDYBSHBZ e(nolock)  
     where a.idm = 0 and a.hjmxxh = b.xh and b.cfxh = c.xh and c.sqdxh = d.xh and convert(numeric(12,0),d.blsqdxh/100) = e.sqdxh  
     and a.xxmdm = e.xmdm and isnull(a.lcxmdm,"0") <> "0"  
    
  if @zfbz=0  --比例标志  
   update #sfmx set yhbz=0, yhbl=0,txbl=0  
  else if @zfbz=2  
  begin  
   update #sfmx set yhbz=0, yhbl=0,txbl=0  
  
   update #sfmx set zfbz=1, zfbl=b.zfbl  
    from #sfmx a, YY_TSSFXMK b (nolock)  
    where b.idm=a.idm and b.xmdm=a.xxmdm and b.ybdm=@ybdm  
   if @@error<>0  
   begin  
    select "F","计算收费费用时出错！"  
    return  
   end  
  end  
  else if @zfbz=3     
  begin  
   if charindex('"'+ltrim(rtrim(@ybdm))+'"',@csybdm) > 0  
   begin  
    if @zhje > 0  
    begin  
     update #sfmx set yhbz=1, yhbl=b.yhbl  
      from #sfmx a, YY_TSSFXMK b (nolock)  
      where b.idm=a.idm and b.xmdm=a.xxmdm and b.ybdm=@ybdm  
    end  
    else begin  
     update #sfmx set yhbz=0, yhbl=0  
      from #sfmx a, YY_TSSFXMK b (nolock)  
      where b.idm=a.idm and b.xmdm=a.xxmdm and b.ybdm=@ybdm      
    end  
   end  
   else if charindex('"'+ltrim(rtrim(@ybdm))+'",',@bkybdmjh) > 0  
   begin  
    update #sfmx set yhbz=1, yhbl=b.yhbl  
     from #sfmx a, YY_TSSFXMK b (nolock)  
     where b.idm=a.idm and b.xmdm=a.xxmdm and b.ybdm=@ybdm  
   end  
   else   
    update #sfmx set zfbz=0, zfbl=0, yhbz=1, yhbl=b.yhbl,txbl=b.txbl,txdj = b.txdj,djjsbz=isnull(b.djjsbz,0)  
     from #sfmx a, YY_TSSFXMK b (nolock)  
     where b.idm=a.idm and b.xmdm=a.xxmdm and b.ybdm=@ybdm  
   if @@error<>0  
   begin  
    select "F","计算收费费用时出错！"  
    return  
   end  
  end  
  else if @zfbz=4  
   update #sfmx set zfbz=0, zfbl=0, yhbz=0, yhbl=0,txbl=0  
  
  --如果有审核过的数据,检验下正确性  
        --参数2039设置为0时,乙类药审核通过会把自费比例更新为0,不符合报销规则  
        --所以变更2039参数只能设置为1,只支持审核不通过作为不可保处理方式  
        --药品设置规则:需要医保审批的药品,在药品字典中勾选医保控制标志  
        --自费比例按符合医保限制情况的比例进行设置  
        --医生在审核时，如符合医保限制情况就审核通过,如不符合医保限制情况就审核不通过  
        if exists (select 1 from #sfmx where isnull(shbz,0)<>0)  
        begin  
            --判断医生站是否提供审核功能及审核功能针对的医保代码  
            --除1,4,10,11(在收费处手工处方)外,在0022中设置的凭证类型也需要医保审批  
            declare @configH164 char(2),@config0022 varchar(500)  
            select @configH164=config from YY_CONFIG(nolock) where id='H164'  
            select @config0022=config from YY_CONFIG(nolock) where id='0022'  
            if exists (select 1 from #sfmx where isnull(hjmxxh,0)<>0) and charindex('"'+rtrim(ltrim(@pzlx))+'"',@config0022)<1  
            begin  
                select 'F','医保审批流程启用,当前电子处方的医保类型未在审批范围内,不能结算!'  
                return   
            end  
            if exists (select 1 from #sfmx where isnull(hjmxxh,0)=0)  
               and charindex('"'+rtrim(ltrim(@pzlx))+'"',@config0022)<1 and @pzlx not in (1,4,10,11)  
            begin  
                select 'F','医保审批流程启用,当前手工处方的医保类型未在审批范围内,不能结算!'  
                return  
            end  
            else  
            begin  
                if @configH164='否' and exists (select 1 from #sfmx where isnull(hjmxxh,0)<>0 and isnull(shbz,0)<>0)  
    begin  
     select 'F','医保审批流程未启用,当前处方中存在医保审批数据,不能结算!'  
     return  
    end  
    if exists (select 1 from YK_YPCDMLK a(nolock),#sfmx b(nolock)  
     where a.idm=b.idm and b.idm>0 and isnull(shbz,0)<>0 and isnull(a.ybkzbz,0)=0   
     and isnull(b.hjmxxh,0)<>0)  
    begin  
     select 'F','医保审批流程启用,当前处方(电子方)中存在不需要医保审批的药品有审批标志,不能结算!'  
     return  
    end  
    if exists (select 1 from YK_YPCDMLK a(nolock),#sfmx b(nolock)  
        where a.idm=b.idm and b.idm>0 and isnull(shbz,0)<>0 and isnull(a.ybkzbz,0)=0   
        and isnull(b.hjmxxh,0)=0)  
    begin  
     select 'F','医保审批流程启用,当前处方(手工方)中存在不需要医保审批的药品有审批标志,不能结算!'  
     return      
    end  
    if exists (select 1 from YY_SFXXMK a(nolock),#sfmx b(nolock)  
     where a.id=b.xxmdm and b.idm=0 and isnull(shbz,0)<>0 and isnull(a.ybkzbz,0)=0   
     and isnull(b.hjmxxh,0)<>0)  
    begin  
     select 'F','医保审批流程启用,当前处方(电子方)中存在不需要医保审批的项目有审批标志,不能结算!'  
     return  
    end  
    if exists (select 1 from YY_SFXXMK a(nolock),#sfmx b(nolock)  
        where a.id=b.xxmdm and b.idm=0 and isnull(shbz,0)<>0 and isnull(a.ybkzbz,0)=0   
        and isnull(b.hjmxxh,0)=0)  
    begin  
     select 'F','医保审批流程启用,当前处方(手工方)中存在不需要医保审批的项目有审批标志,不能结算!'  
     return      
    end  
            end  
            --判断参数2039的设置  
            if exists (select 1 from YY_CONFIG(nolock) where id='2039' and config='0')  
            begin  
                select 'F','参数2039设置为0,上海地区请设置参数为1!'  
                return  
            end              
        end          
        update #sfmx set zfbz=1, zfbl=1, yhbz=0, yhbl=0, flzfbz=0  where shbz=2  
  --如参数2039一定要设置为0，可以打开以下注释，慎重设置  
  /*  
  if (select config from YY_CONFIG (nolock) where id='2039')='0'  
     update #sfmx set zfbz=0, zfbl=0, yhbz=0, yhbl=0 where shbz=1   --审核通过作为可报处理  
  else  
     update #sfmx set zfbz=1, zfbl=1, yhbz=0, yhbl=0, flzfbz=0  where shbz=2   --审核不通过作为不可报处理  
    */  
  --update by zwj 2003.11.07 医保审核为否是不作为分类自费药品处理  
  
  --扶贫政策改造 vsts 315326 begin  
  --贫困等级  
  if exists(select 1 from YY_CONFIG where id ='0384' and config ='是')and  exists(select 1 from SF_BRXXK a(nolock),YY_PKRKXXB b(nolock) where a.patid =@patid and a.sfzh =b.sfzh and b.jlzt =1 and b.shbz =1)  
  begin  
   declare @pkdj ut_bz  
   select @pkdj =pkdj from SF_BRXXK a(nolock),YY_PKRKXXB b(nolock) where a.patid =@patid and a.sfzh =b.sfzh  
    
    update #sfmx set zfbz=0, zfbl=0, yhbz=1, yhbl=b.yhbl    
    from #sfmx a, YY_PKSFXMK b (nolock)    
    where b.idm=a.idm and b.xmdm=a.xxmdm and b.pkdj=@pkdj and isnull(b.xtbz,2)in(0,2)   
  end  
  --扶贫政策改造 end  
  
  /*计算收费费用 end */  
  
  --处理备注信息  
  update #sfmx set memo = isnull(b.memo,'') from #sfmx a(nolock),VW_MZHJCFMXK b(nolock) where a.hjmxxh = b.xh  
   
      --处理可调参数2366参数2367数据  
  if (@config2366 <> '') or (@config2367 <> '')  
  BEGIN  
   --门诊收费处直接开的处方,也要加上判断，否则门诊收费处直接开的处方，也会按照优惠计算  
   update #sfmx set zfbz=1, zfbl=1, yhbz=0, yhbl=0, flzfbz=0   
         where hjmxxh = 0 and (@config2367 <> '' and charindex('"'+rtrim(@ksdm)+'"',@config2367) = 0)  
     
   --处理可调参数2366数据  
   update #sfmx set zfbz=1, zfbl=1, yhbz=0, yhbl=0, flzfbz=0   
   from #sfmx a(nolock),SF_HJCFK b(nolock),SF_HJCFMXK c(nolock)  
   where a.hjmxxh = c.xh and b.xh = c.cfxh   
   and (@config2366 <> '' and ((charindex('"'+rtrim(b.ksdm)+'"',@config2366)>0 and isnull(c.echjbz,0)=0)   
   or charindex('"'+rtrim(b.ksdm)+'"',@config2366) = 0))  
         
   --处理可调参数2367数据  
   update #sfmx set zfbz=1, zfbl=1, yhbz=0, yhbl=0, flzfbz=0   
   from #sfmx a(nolock),SF_HJCFK b(nolock),SF_HJCFMXK c(nolock)  
   where a.hjmxxh = c.xh and b.xh = c.cfxh   
   and (@config2367 <> '' and charindex('"'+rtrim(b.ksdm)+'"',@config2367) = 0)  
  end   
  
    
  --对处方的单方不可报复方可报处理begin  
  select distinct cfxh   
  into #tempcfxh   
  from #sfmx where dffbz=1 group by cfxh  
    
  select cfxh,count(cfxh) recno  
  into #tempno  
  from #sfmx a where exists(select 1 from #tempcfxh b where a.cfxh=b.cfxh) group by cfxh  
    
   --复方可报  
  update #sfmx set zfbz=0,zfbl=0,yhbz=0,yhbl=0,txbl=0  
  where dffbz=1 and exists(select 1 from #tempno where cfxh=#sfmx.cfxh and recno>1)  
   --单方不可报不优惠  
  update #sfmx set zfbz=1,zfbl=1,yhbz=0,yhbl=0,txbl=0  
  where dffbz=1 and exists(select 1 from #tempno where cfxh=#sfmx.cfxh and recno=1)  
  --对处方的单方不可报复方可报处理end  
  
  --add by chenwei 2004.02.28  
  if @zfbz = 3   
          update #sfmx set ylsj= case when isnull(djjsbz,0) =  1 then txdj else case when txbl <>0 then ylsj*txbl else ylsj end end,  
        ypfj=case when isnull(djjsbz,0) =  1 then txdj else case when txbl<>0 then ypfj*txbl else ypfj end end   
           
          
          
  
  --W20050313 特殊收费项目中增加上限价格,作用是针对特殊病人的上限价格设置.  
  --顺序:先执行收费小项目中的上限价格,再覆盖执行特殊收费项目中的上限价格  
  update #sfmx set sxjg = b.sxjg  
   from #sfmx a,YY_TSSFXMK b   
   where a.xxmdm = b.xmdm and b.ybdm = @ybdm  
  --modify by chewei 2003.12.06 保存前台设置的优惠单价  
  update #sfmx set zfdj=(case when sxjg<ylsj and sxjg>0 then (ylsj-sxjg)+sxjg*zfbl else ylsj*zfbl end),  
   yhdj=case when yhdj<>0 then yhdj else (case when sxjg<ylsj and sxjg>0 then sxjg*(1-zfbl)*yhbl else ylsj*(1-zfbl)*yhbl end) end  
     
  
  update #sfmx set flzfdj=(case when flzfbz=0 then 0 else   
   zfdj-(case when sxjg<ylsj and sxjg>0 then (ylsj-sxjg) else 0 end)  end)   
  
  --W20071125 松江零差价处理,影响到zfdj,flzfdj,yhdj  
  --涉及到原始比例；上线价格；特殊自费、优惠比例；特殊上线价格；  
  --所有的比例都应该乘：药品零差价  
  if exists(select ybdm from YY_YBFLK nolock where ybdm = @ybdm and lcyhbz = 1)     
  begin  
   --判断非零差结算的药房，参数不设置时，默认所有药房  
   update #sfmx set lcjsdj=0 where charindex('"'+rtrim(ltrim(yfdm))+'"',@config2297)>0  
   update #sfmx set zfdj=(case when sxjg<lcjsdj and sxjg>0 then (lcjsdj-sxjg)+sxjg*zfbl else lcjsdj*zfbl end),  
        yhdj=case when sxjg<lcjsdj and sxjg>0 then sxjg*(1-zfbl)*yhbl else lcjsdj*(1-zfbl)*yhbl end  
    where lcjsdj <> 0   
   update #sfmx set yyhdj = yhdj --保存原来的优惠单价，留着计算金额时使用  
   --保证优惠掉的金额不大于原零售金额a:原零售价 b:优惠后金额 k:原来优惠比例 bk+a-b <= a    
   update #sfmx set yhdj = yhdj + ylsj - lcjsdj where lcjsdj <> 0  
   update #sfmx set flzfdj=(case when flzfbz=0 then 0 else   
           zfdj-(case when sxjg<lcjsdj and sxjg>0 then (lcjsdj-sxjg) else 0 end)  end)   
    where lcjsdj <> 0  
   select @lcyhje = isnull(sum(round(fysl*ylsj*cfts/ykxs,2)),0) -   
       isnull(sum(round(fysl*lcjsdj*cfts/ykxs,2)),0)  
    from #sfmx where idm>0 and lcjsdj <>0   
  end  
  else   
   update #sfmx set lcjsdj = 0  
    
    
    
  --modify by sunyu 2006-12-06 增加帮困不计分类自付的处理  
  if charindex('"'+ltrim(rtrim(@ybdm))+'",',@bkybdmjh)>0  
   update #sfmx set flzfdj=0, zfdj=0 where flzfbz=1  
--------------begin诊疗方案销售时已经收费，这里设置lsje为0   
  update a set a.flzfdj=0, a.zfdj=0,a.yhdj=0,a.ylsj=0 from #sfmx a, SF_HJCFMXK b  
   WHERE a.hjmxxh=b.xh and b.sjzlfabdxh<>0  
--------------end    
        --{TODO -oyfq -c2016-12 : 医保高价药政策改造 as @#$ begin}  
  --执行高价药政策  
  if @config2451='是' and dbo.fun_judgeybdm4gjy(0,@ybdm,@xmlb,@zhbz)='TF'  
  begin  
      /**  
   if exists (select 1 from sysobjects(nolock) where id=object_id('YB_SH_YBDYK'))  
   begin  
    update a set dydm=b.dydm   
    from #sfmx a,YB_SH_YBDYK b(nolock)  
    where a.idm=0 and a.xxmdm=b.xmdm and b.jlzt=1 and @now between b.qyrq+'00:00:00' and b.yxqx+'23:59:59'  
    update a set dydm=b.dydm   
    from #sfmx a,YB_SH_YBDYK b(nolock)  
    where a.idm>0 and a.idm=b.idm and b.jlzt=1 and @now between b.qyrq+'00:00:00' and b.yxqx+'23:59:59'  
   end  
   **/  
   update a set gjybz=1,gjydeje=isnull(b.zfdeje,0),  
    zfdj=0,flzfdj=0,zfbl=0,flzfbz=0,yhdj=0,yhbl=0  
   from #sfmx a,YY_YBYPK b(nolock)  
   where a.dydm=b.mc_code and isnull(b.tsbz,0)<>0 and @now between b.ksrq+'00:00:00' and b.jzrq+'23:59:59'  
   --有高价药,单独计算高价药自负金额  
   if exists (select 1 from #sfmx where gjybz=1)  
   begin  
    select @gjybz=1  
    select @gjyzje=isnull(sum(round(fysl*ylsj*cfts/ykxs,2)),0),  
     @gjyzfje=isnull(sum(round(fysl*gjydeje*cfts/ykxs,2)),0)  
    from #sfmx where idm>0 and gjybz=1  
    select @gjyzje1=isnull(sum(round(fysl*ylsj*cfts/ykxs,2)),0),  
     @gjyzfje1=isnull(sum(round(fysl*gjydeje*cfts/ykxs,2)),0)  
    from #sfmx where idm=0 and gjybz=1  
   end  
   else  
    select @gjybz=0  
  end  
  --{TODO -oyfq -c2016-12 : 医保高价药政策改造 as @#$ end}  
  if exists(select ybdm from YY_YBFLK nolock where ybdm = @ybdm and lcyhbz = 1)     
  begin  
   select @zje=isnull(sum(round(fysl*ylsj*cfts/ykxs,2)),0),  
    @zfyje=isnull(sum(round(fysl*zfdj*cfts/ykxs,2)),0),  
    @yhje = isnull(sum(case when isnull(lcjsdj,0) = 0 then round(yhdj*fysl*cfts/ykxs,2) else   
               round(ylsj*fysl*cfts/ykxs,2) - round(lcjsdj*fysl*cfts/ykxs,2)+ round(yyhdj*fysl*cfts/ykxs,2) end ),0),  
    @flzfje=isnull(sum(round(fysl*flzfdj*cfts/ykxs,2)),0)  
    from #sfmx where idm>0  
  end  
  else begin  
   select @zje=isnull(sum(round(fysl*ylsj*cfts/ykxs,2)),0),  
    @zfyje=isnull(sum(round(fysl*zfdj*cfts/ykxs,2)),0),  
    @yhje =isnull(sum(round(yhdj*fysl*cfts/ykxs,2)),0),  
    @flzfje=isnull(sum(round(fysl*flzfdj*cfts/ykxs,2)),0)  
    from #sfmx where idm>0     
  end  
    
  select @zje1=isnull(sum(round(fysl*ylsj*cfts/ykxs,2)),0),  
   @zfyje1=isnull(sum(round(fysl*zfdj*cfts/ykxs,2)),0),  
   @yhje1=isnull(sum(round(fysl*yhdj*cfts/ykxs,2)),0),  
   @flzfje1=isnull(sum(round(fysl*flzfdj*cfts/ykxs,2)),0)  
   from #sfmx where idm=0  
        if @gjybz=1  --@#$  
      select @ybje=@zje-@zfyje-@yhje-@gjyzje,@ybje1=@zje1-@zfyje1-@yhje1-@gjyzje1  
  else  
  select @ybje=@zje-@zfyje-@yhje, @ybje1=@zje1-@zfyje1-@yhje1  
 end  
  
 --add by zyh 20100305  
 select @config2206=rtrim(config) from YY_CONFIG where id='2206'  
 select @vipyxe=convert(money,config) from YY_CONFIG where id='2207'  
 select @vipyxe=isnull(@vipyxe,0)  
 if charindex(','+rtrim(@ybdm)+',' , ','+@config2206+',')>0 and isnull(@vipyxe,0)>0  
 begin  
  if not exists(select 1 from SF_VIPBRSPJL where patid=@patid)  
  begin  
   select @vipfylj=sum(zje) from VW_MZBRJSK(nolock) where patid=@patid and ybjszt=2 and jlzt=0 and ghsfbz=1 and charindex(','+rtrim(ybdm)+',' , ','+rtrim(@config2206)+',')>0 and sfrq like left(@now,6)+'%'  
   select @vipfylj=isnull(@vipfylj,0)  
   if @vipfylj+@zje+@zje1>@vipyxe  
   begin  
    select "F","VIP病人本月已消费"+convert(varchar,@vipfylj)+",本次收费后超出月限额"+convert(varchar,@vipyxe)  
    return  
   end  
  end  
 end  
  
  
    --add by qxh 2003.2.27  
 if @acfdfp=1   
  update  #sfzd  set  zje=b.zje,zfyje=b.zfyje,yhje=b.yhje   
        from  #sfzd a , (select cfxh,isnull(sum(round(fysl*ylsj*cfts/ykxs,2)),0) as zje ,  
                                     isnull(sum(round(fysl*zfdj*cfts/ykxs,2)),0) as zfyje,  
                                     isnull(sum(round(fysl*yhdj*cfts/ykxs,2)),0) as yhje  
                       from  #sfmx group by cfxh ) b  where a.cfxh=b.cfxh    
 --生成收据号  
 declare @czyh_new ut_czyh  
 select   @czyh_new = @czyh  
 if CHARINDEX('_',@wkdz)>0  
   select @czyh_new = LTRIM(RTRIM(@czyh))+SUBSTRING(@wkdz,CHARINDEX('_',@wkdz)+1,LEN(@wkdz)-CHARINDEX('_',@wkdz))   
 exec usp_yy_createsjh 'SF_BRJSK','sjh','czyh',@czyh_new,@errmsg output  
 --exec usp_yy_createsjh 'SF_BRJSK','sjh','czyh',@czyh,@errmsg output  
 if @errmsg like 'F%'  
 begin  
  select "F",substring(@errmsg,2,49)  
  return  
 end  
 else  
  select @sjh=rtrim(substring(@errmsg,2,32))  
  
 --add by ozb 20080612 begin  
 select @srbz=config from YY_CONFIG (nolock) where id='2016'  
  if @@error<>0 or @@rowcount=0  
   select @srbz='0'  
 select @sfje_all=@zje-@yhje  
 --add by ozb 20080612 end  
 --取得实收金额  
 if @pzlx not in (10,11)  
 begin  
  
  --tony 2003.12.8 小城镇医保修改  
  if exists(select 1 from YY_CONFIG (nolock) where charindex('"'+rtrim(@ybdm)+'"',config)>0 and id='2082')  
   select @tcljbz=1  
  
  if @tcljbz=1  --统筹金额无  
  begin  
  
   select @ybje=@ybje+@ybje1,@ybje1=0  
  
   --金额计算,有统筹金额的处理  
   execute usp_yy_ybjs @ybdm,0,@ybje,0,@errmsg output,0,@tcljje1,@jsfs  
   if @errmsg like "F%"  
   begin  
    select "F",substring(@errmsg,2,49)  
    return  
   end  
   else  
    select @sfje=convert(numeric(10,2),substring(@errmsg,2,11))  
            if @gjybz=1  --@#$  
      begin  
       select @ybje=@ybje+@gjyzje+@gjyzje1,@sfje=@sfje+@gjyzfje+@gjyzfje1  
      end  
   if @ybje+@ybje1>0  
    select @xmzfbl=@sfje/@ybje,@xmzfbl1=@sfje/@ybje  
  end  
  else  
  begin  
   --药品金额计算  
   execute usp_yy_ybjs @ybdm,0,@ybje,0,@errmsg output,0,@tcljje,@jsfs  
   if @errmsg like "F%"  
   begin  
    select "F",substring(@errmsg,2,49)  
    return  
   end  
   else  
    select @sfje=convert(numeric(10,2),substring(@errmsg,2,11))  
    
   execute usp_yy_ybjs @ybdm,0,0,@ybje1,@errmsg output,0,@tcljje,@jsfs  
   if @errmsg like "F%"  
   begin  
    select "F",substring(@errmsg,2,49)  
    return  
   end  
   else  
    select @sfje1=convert(numeric(10,2),substring(@errmsg,2,11))  
      if @gjybz=1  --@#$  
            begin  
                select @ybje=@ybje+@gjyzje,@sfje=@sfje+@gjyzfje  
                select @ybje1=@ybje1+@gjyzje1,@sfje1=@sfje1+@gjyzfje1  
            end  
   if @ybje>0  
    select @xmzfbl=@sfje/@ybje  
    
   if @ybje1>0  
    select @xmzfbl1=@sfje1/@ybje1  
  
  end  
  
  
  select @sfje_all=@sfje+@sfje1+@zfyje+@zfyje1  
  select @sfje2=@sfje_all  
  select @srbz=config from YY_CONFIG (nolock) where id='2016'  
  if @@error<>0 or @@rowcount=0  
   select @srbz='0'  
  
  declare @srfs varchar(1)  --0：精确到分，1：精确到角  
  select @srfs = config from YY_CONFIG (nolock) where id='2235'  
  if @@error<>0 or @@rowcount=0  
   select @srfs='0'  
  if @srfs = '1' and  @czksfbz = 1 and @yjbz=1 ---1：精确到角则先舍入20110426sqf  
  begin  
   if @srbz='5'  
    select @sfje2=round(@sfje_all, 1)  
   else if @srbz='6'  
    exec usp_yy_wslr @sfje_all,1,@sfje2 output   
   else if @srbz>='1' and @srbz<='9'  
    exec usp_yy_wslr @sfje_all,1,@sfje2 output,@srbz  
   else  
    select @sfje2=@sfje_all  
  
   select @srje=@sfje2-@sfje_all  
  end  
  
  declare @srpdbz ut_bz  
   
  --慈善基金病人（在医院有个人账户的病人）  
  if @qkbz1=1 and @zhje>0  
  begin  
   --自费费用自己负担(帮困开始)  
   if exists(select 1 from YY_CONFIG (nolock) where charindex('"'+rtrim(@ybdm)+'"',config)>0 and id='0053')  
   begin  
      
    if @sfje2-@zfyje-@zfyje1+@flzfje+@flzfje1<=@zhje  
    BEGIN  
     SELECT @qkje=@sfje2-@zfyje-@zfyje1+@flzfje+@flzfje1,@qkje2 = @sfje_all-@zfyje-@zfyje1+@flzfje+@flzfje1  
     /*  
     select @srpdbz=0  
     IF @srbz="0"  
      SELECT @qkje=@sfje2-@zfyje-@zfyje1+@flzfje+@flzfje1,@qkje2 = @sfje_all-@zfyje-@zfyje1+@flzfje+@flzfje1  
     ELSE  
      select  @qkje = round(@sfje2-@zfyje-@zfyje1+@flzfje+@flzfje1,1),  
       @qkje2 = @sfje_all-@zfyje-@zfyje1+@flzfje+@flzfje1  
     */  
    END  
    else  
    BEGIN  
     SELECT @qkje=@zhje, @qkje2=@zhje  
     /*  
     select @srpdbz=1  
     IF @srbz="0"  
      SELECT @qkje=@zhje, @qkje2=@zhje  
     ELSE  
      select  @qkje = round(@zhje,1),@qkje2 = @zhje  
     */  
    END  
   end  
   else  
   begin  
    if @sfje2<=@zhje  
    BEGIN  
     SELECT @qkje=@sfje2, @qkje2=@sfje_all  
     /*  
     select @srpdbz=0  
     IF @srbz="0"  
      SELECT @qkje=@sfje2, @qkje2=@sfje_all  
     ELSE  
      select @qkje = round(@sfje2,1),@qkje2 = @sfje_all  
     */  
    END  
    ELSE  
    BEGIN  
     SELECT @qkje=@zhje, @qkje2=@zhje  
     /*  
     select @srpdbz=1  
     IF @srbz="0"  
      SELECT @qkje=@zhje, @qkje2=@zhje  
     ELSE  
      select @qkje = round(@zhje,1),@qkje2 = @zhje  
     */  
    END  
   end  
   /*  
   --add by sunyu 2008-2-29 统一对@qkje进行小数舍入处理  
   if @srbz='5'  
    select @qkje=round(@qkje2, 1)  
   else if @srbz='6'  
    exec usp_yy_wslr @qkje2,1,@qkje output   
   else if @srbz>='1' and @srbz<='9'  
    exec usp_yy_wslr @qkje2,1,@qkje output,@srbz  
   else  
    select @qkje=@qkje2  
   */  
   insert into SF_JEMXK(jssjh, lx, mc, je, memo)  
   values(@sjh, '01', '起付段当年账户支付',@qkje2 , null)  
   if @@error<>0  
   begin  
    select "F","保存结算01信息出错！"  
    return  
   end  
   /*  
   if @srpdbz=0  
    select @sfje_bkall = @sfje_all - @qkje2  
   else  
    select @sfje_bkall = @sfje_all - @qkje--,@qkje = 0  
     
   --小数舍入处理  
   if @srbz='5'  
    select @sfje2=round(@sfje_bkall, 1)  
   else if @srbz='6'  
    exec usp_yy_wslr @sfje_bkall,1,@sfje2 output   
   else if @srbz>='1' and @srbz<='9'  
    exec usp_yy_wslr @sfje_bkall,1,@sfje2 output,@srbz  
   else  
    select @sfje2=@sfje_bkall  
   if @srpdbz=0  
    select @srje = @sfje2 - (@sfje_all - @qkje2)  
   else  
    select @srje = @sfje2 - (@sfje_all - @qkje)  
   */  
   select @sfje2=@sfje2+@qkje  
     
--    if @ybje>0  
--     select @xmzfbl=(@ybje - @qkje2)/@ybje  
--    select @sfje = @ybje - @qkje2  
       
   --帮困结束  
  end  
  else if @czksfbz = 1 --2004.02.17 szj add 密码输对才进行充值卡收费  
  begin  
   if @yjbz=1  
   begin  
    if @cflx=6 and @hykmsbz=1  
    begin  
     execute usp_yy_jzbrtjsf @patid, @ybdm, 0, @errmsg output  
     if @errmsg like "T%" --为F时不处理体检金额  
     begin  
      --zwj 2007.04.23 改为优惠方式处理  
      select @sfje2=0, @tjmfbz=1,@xmzfbl=0, @xmzfbl1=0,  
       @yhje=@zje, @yhje1=@zje1, @zfyje=0, @zfyje1=0, @srje=0  
      update #sfmx set yhdj=ylsj, zfdj=0, flzfdj=0  
     end  
    end  
  
--    if @yjyebz='否' and @yjye<@sfje2  
--    begin  
--     select "F","充值卡余额不足，不能继续收费！"  
--     return  
--    end  
  
    if @yjye>0  
    begin  
     if @sfje2<=@yjye  
      select @qkje=@sfje2  
     else  
     begin  
  
  
  
  
  
  
  
  
  
  
  
      select @qkje=@yjye   
      if @srfs = '1'---1：精确到角则先舍入20110426sqf  
      begin  
       select @qkje=round(@yjye, 1,1) ---去掉小数位  
      end        
     end  
                    select @qkbz1=3,@yjzfje=@qkje  
    end  
   end  
  end  
 end  
 else if @czksfbz = 1 and @ybjkid > 0  
 begin  
  if @yjbz = 1  
  begin  
   select @qkbz1=3,@yjzfje=@yjye  
   if @srfs = '1'---1：精确到角则先舍入20110426sqf  
    select @yjzfje=round(@yjye, 1,1) ---去掉小数位 --预算时保留押金余额，在结算一时处理  
  end  
 end  
 else if @czksfbz = 1      --2004.02.17  szj add 密码输对才进行充值卡收费  
 begin  
  if @yjbz=1  
  begin  
--   select @qkbz=1  
--  else  
   select @yjzfje=@yjye --预算时保留押金余额，在结算一时处理  
   if @srfs = '1'---1：精确到角则先舍入20110426sqf  
    select @yjzfje=round(@yjye, 1,1) ---去掉小数位  
  end  
 end  
  
 --add by ozb 20080612 begin --mod by wuwei 20101109 将舍入提到qkje计算之前  
 if (@qkbz1 = 3 and @srfs = '0') or (@qkbz1 in(1,4))---0：精确到分则先舍入20110426sqf  
 begin   
  select @sfje2=@sfje_all-@qkje  
  if @srbz='5'  
   select @sfje2=round(@sfje_all-@qkje, 1)  
  else if @srbz='6'  
   exec usp_yy_wslr @sfje2,1,@sfje2 output   
  else if @srbz>='1' and @srbz<='9'  
   exec usp_yy_wslr @sfje2,1,@sfje2 output,@srbz  
  else  
   select @sfje2=@sfje_all-@qkje  
  select @sfje2=@sfje2+@qkje  
  select @srje=@sfje2-@sfje_all  
 end  
 else if @qkbz1 not in( 1,3,4) ------处理非账户病人  
 begin  
  if @srbz='5'  
   select @sfje2=round(@sfje_all, 1)  
  else if @srbz='6'  
   exec usp_yy_wslr @sfje_all,1,@sfje2 output   
  else if @srbz>='1' and @srbz<='9'  
   exec usp_yy_wslr @sfje_all,1,@sfje2 output,@srbz  
  else  
   select @sfje2=@sfje_all  
  select @srje=@sfje2-@sfje_all  
 end  
  
   
 --add by ozb 20080612 end  
 --处理大项汇总金额,20071125增加零差价处理  
  select dxmdm, dxmmc, mzfp_id, mzfp_mc,   
   round(ylsj*fysl*cfts/ykxs,2) as xmje,   
   round((ylsj-zfdj-yhdj)*fysl*cfts,2) as zfje,  
   round(zfdj*fysl*cfts/ykxs,2) as zfyje,   
   round(yhdj*fysl*cfts/ykxs,2) as yhje,  
   round(flzfdj*fysl*cfts/ykxs,2) as flzfje,  
   round(flzfdj*fysl*cfts/ykxs,2) as lcyhje  
   into #sfmx1  
   from #sfmx where 1= 2  
  
 if exists(select ybdm from YY_YBFLK nolock where ybdm = @ybdm and lcyhbz = 1)     
  insert into #sfmx1(dxmdm, dxmmc, mzfp_id, mzfp_mc,xmje,zfje,zfyje,yhje,flzfje,lcyhje)  
  select dxmdm, dxmmc, mzfp_id, mzfp_mc, sum(round(ylsj*fysl*cfts/ykxs,2)) as xmje,   
   sum(round((ylsj-zfdj-yhdj)*fysl*cfts*(case when idm>0 then @xmzfbl else @xmzfbl1 end)/ykxs,2)) as zfje,  
   sum(round(zfdj*fysl*cfts/ykxs,2)) as zfyje,   
   sum(case when lcjsdj = 0 then round(yhdj*fysl*cfts/ykxs,2) else   
              round(ylsj*fysl*cfts/ykxs,2) - round(lcjsdj*fysl*cfts/ykxs,2)+ round(yyhdj*fysl*cfts/ykxs,2) end ) as yhje,  
   sum(round(flzfdj*fysl*cfts/ykxs,2)) as flzfje,  
   sum( case when lcjsdj = 0 then 0 else round(ylsj*fysl*cfts/ykxs,2) - round(lcjsdj*fysl*cfts/ykxs,2) end) lcyhje  
   from #sfmx group by dxmdm, dxmmc, mzfp_id, mzfp_mc  
 else   
  insert into #sfmx1(dxmdm, dxmmc, mzfp_id, mzfp_mc,xmje,zfje,zfyje,yhje,flzfje,lcyhje)  
  select dxmdm, dxmmc, mzfp_id, mzfp_mc, sum(round(ylsj*fysl*cfts/ykxs,2)) as xmje,   
   sum(round((ylsj-zfdj-yhdj)*fysl*cfts*(case when idm>0 then @xmzfbl else @xmzfbl1 end)/ykxs,2)) as zfje,  
   sum(round(zfdj*fysl*cfts/ykxs,2)) as zfyje, sum(round(yhdj*fysl*cfts/ykxs,2)) as yhje,  
   sum(round(flzfdj*fysl*cfts/ykxs,2)) as flzfje,0  
   from #sfmx group by dxmdm, dxmmc, mzfp_id, mzfp_mc    
  
 if exists (select 1 from #sfmx1)  
 begin  
  select @xmce=@sfje+@sfje1-sum(zfje) from #sfmx1  
--   select @xmce=@sfje2-sum(zfje) from #sfmx1  
  update #sfmx1 set zfje=zfje+zfyje  
  set rowcount 1  
  update #sfmx1 set zfje=zfje+@xmce  
  set rowcount 0  
 end   
  
 --配、发药窗口代码统一由 usp_sf_getsfpck 返回，里面已经处理了这种情况 Wang Yi 2003.02.25  
 /*增加判断：急诊发药是否指定发药窗口 begin  
 if @mjzbz = 2   
 begin   
  if exists (select id from YY_CONFIG  where id = '3031' and config = '是')  
  begin  
   if exists (select id from YY_CONFIG  where id = '3032')    
    select @newfyckdm = config  from YY_CONFIG  where id = '3032'  
  end  
 end  
 增加判断：急诊发药是否指定发药窗口 end*/  
  
 --add by qxh 2003.2.27  
 --把自付金额分摊到处方上  
 if @acfdfp=1   
  update  #sfzd  set  zfje=b.zfje+a.zfyje  
        from  #sfzd a , (select cfxh,  
   sum(round((ylsj-zfdj-yhdj)*fysl*cfts*(case when idm>0 then @xmzfbl else @xmzfbl1 end)/ykxs,2)) as zfje                                      
                        from  #sfmx group by cfxh ) b  where a.cfxh=b.cfxh    
  
   
 if @pzlx in (10,11)  
 begin  
  --update by zwj 2003-09-09 医保四期修改  
  select b.mzyb_id as id, b.mzyb_mc as name, sum(round(a.xmje,2)) as xmje,   
   sum(round(zfje,2)) as zfje,  
   sum(round(zfyje,2)) as zfyje, sum(round(yhje,2)) as yhje,  
   sum(round(flzfje,2)) as flzfje  
   into #ybsfmx  
   from #sfmx1 a,YY_SFDXMK b  
   where a.dxmdm=b.id    
   group by b.mzyb_id, b.mzyb_mc  
  if @@error<>0  
  begin  
   select "F","计算医保费用时出错！"  
   return  
  end  
   
  select @ybzje=@ybje+@ybje1,@ybjszje=@ybje+@ybje1+(@flzfje+@flzfje1)  
  ----add by sqf 20101103  
  --这里换用SF_BRJSK的账户标志  
  --不用SF_BRXXK的账户标志  
  if @pzlx = 11 and substring(@zhbz,12,1)='0'----大病减负  
  begin  
   declare @msg varchar(300)  
            select @xmlb=isnull(ylxm,'0') from SF_BRJSK (nolock) where sjh=@ghsjh  ----前台没有传进来？？？？预算结算的确没有传进来  
            select @xmlb=isnull(@xmlb,'0')  
   exec usp_yy_yb_getylxm '0','0',@xmlb,@jfbz output,@msg output  
   if @jfbz <>'0' and @msg <>'R'  
   begin  
       if @config2395<>''  
       begin  
           select @flzfjedbxm=isnull(sum(round(fysl*flzfdj*cfts/ykxs,2)),0)  
           from #sfmx  
           where idm=0 and charindex('"'+rtrim(ltrim(xxmdm))+'"',@config2395)>0             
       end  
    select @ybzje=@ybje+@ybje1+@flzfje+@flzfjedbxm ---------医保交易金额包括药品的flzfje和大病减负范围内的项目  
    select @jfje=@flzfje+@flzfjedbxm  
   end   
  end    
  select @ybzlf=isnull(xmje-zfyje-yhje+flzfje,0) from #ybsfmx where id='02'  
  select @ybssf=isnull(xmje-zfyje-yhje+flzfje,0) from #ybsfmx where id='03'  
  select @ybjcf=isnull(xmje-zfyje-yhje+flzfje,0) from #ybsfmx where id='04'  
  select @ybhyf=isnull(xmje-zfyje-yhje+flzfje,0) from #ybsfmx where id='05'  
  select @ybspf=isnull(xmje-zfyje-yhje+flzfje,0) from #ybsfmx where id='06'  
  select @ybtsf=isnull(xmje-zfyje-yhje+flzfje,0) from #ybsfmx where id='07'  
  select @ybxyf=isnull(xmje-zfyje-yhje+flzfje,0) from #ybsfmx where id='08'  
  select @ybzyf=isnull(xmje-zfyje-yhje+flzfje,0) from #ybsfmx where id='09'  
  select @ybcyf=isnull(xmje-zfyje-yhje+flzfje,0) from #ybsfmx where id='10'  
  select @ybqtf=isnull(xmje-zfyje-yhje+flzfje,0) from #ybsfmx where id='11'  
  select @ybgrzf=isnull(sum(zfyje-flzfje),0) from #ybsfmx   
 end  
   
 --根据hjk更新二级药柜标志   
 --update a set ejygbz=b.ejygbz,ejygksdm=b.ejygksdm from #sfzd a,SF_HJCFK b(nolock)  
 --where a.hjxh=b.xh and isnull(hjxh,0)<>0  
 update a set ejygbz=b.ejygbz,ejygksdm=b.ejygksdm,  
     wsbz=isnull(b.wsbz,0),  
        wsts=isnull(b.cydjts,0),  
        yscfbz=isnull(b.yscfbz,0),  
        ccfbz=isnull(b.ccfbz,0)  
 from #sfzd a,SF_HJCFK b(nolock)  
 where a.hjxh=b.xh and isnull(hjxh,0)<>0  
   
 update b set mxwsbz=a.wsbz from #sfzd a,#sfmx b where a.cfxh=b.cfxh  
  
 -----需要分成两组处方：正常的及二级药柜的  
 update a set ejygbz = 1 from #sfmx a, BQ_EJYGYPJLK b (nolock)  
 where a.idm = b.idm and b.ksdm = @ksdm and jlzt = 0 and isnull(hjmxxh,0)=0  
  
 declare @sqdlb   varchar(2) ----add by sqf   
   ,@yjclfbz_temp ut_bz  
   ,@pyrq ut_rq16  
   ,@pybz ut_bz  
   ,@pyczyh ut_czyh  
  
 select @yjclfbz_temp=0  
 /*收费信息保存 begin*/  
 begin tran  
 declare cs_mzsf cursor for  
 select cfxh, ksdm, ysdm, yfdm, hjxh, cflx, sycfbz, tscfbz, cfts, pyckdm, fyckdm,zje,zfyje,  
  yhje,zfje,ejygbz,ejygksdm,fybz,wsbz,wsts,tbzddm,tbzdmc,yscfbz,ccfbz,ghxh from #sfzd --add by ozb 增加二级药柜标志  
 for read only  
  
 open cs_mzsf  
 fetch cs_mzsf into @cfxh, @ksdm, @ysdm, @yfdm, @hjxh, @cflx, @sycfbz, @tscfbz, @cfts, @pyckdm, @fyckdm,@zjecf,@zfyjecf,  
  @yhjecf,@zfje,@ejygbz,@ejygksdm,@fybz,@wsbz,@wsts,@tbzddm,@tbzdmc,@yscfbz,@ccfbz,@ghxhtmp --add by ozb 增加二级药柜标志  
 while @@fetch_status=0  
 begin  
  --不需要判断，前面已经处理了, Wang Yi 2003.02.25  
/*  if @mjzbz = 2   
   select @fyckdm = @newfyckdm*/  
  
  --yxp add 2005-2-28   
  if (isnull(@cflx,0) in (1,2,3)) and (not exists(select 1 from YF_YFDMK where id=@yfdm))  
  begin  
   select "F","当前处方记录中药房代码["+(@yfdm)+"]不存在,请退出后重新录入！"  
   rollback tran  
   deallocate cs_mzsf  
   return  
  end  
  if (isnull(@cflx,0) not in (1,2,3)) and (exists(select 1 from #sfmx a, YK_YPCDMLK b (nolock)      where a.cfxh=@cfxh and a.idm=b.idm))  
  begin  
   select @ypmc=a.ypmc from #sfmx a, YK_YPCDMLK b (nolock)   
   where a.cfxh=@cfxh and a.idm=b.idm  
     
   select "F","当前处方中存在药品["+ltrim(@ypmc)+"]，而处方类型不正确,请退出后重新录入！"  
   rollback tran  
   deallocate cs_mzsf  
   return  
  end  
  
  --xxl 20080903 增加医疗组信息保存  
        if exists(select 1 from BQ_YS_YLXZCYXXB where ysdm=@ysdm)  
         select @ylxzbh=bh from BQ_YS_YLXZCYXXB where ysdm=@ysdm   
        else  
            select @ylxzbh=0  
  
        set @sqdxh = 0  
        if @hjxh>0  
  begin  
            select @sqdxh=isnull(sqdxh,0) from SF_HJCFK where xh=@hjxh  
   if (@@ROWCOUNT = 0)   
       select @sqdxh=isnull(sqdxh,0) from SF_NHJCFK where xh=@hjxh   
  end  
  
  if @hjxh>0   
  begin  
   select @hjcfjlzt=jlzt,@sqdlb = isnull(sqdlb,''),@pybz = isnull(pybz,0),@pyczyh = isnull(pyczyh,''),@pyrq = isnull(pyrq,'') from SF_HJCFK where xh=@hjxh  
  
   insert into SF_MZCFK(jssjh, hjxh, czyh, lrrq, patid, hzxm, ybdm, py, wb,   
    ysdm, ksdm, yfdm, qrczyh, qrrq, qrksdm, pyczyh, pyrq, cfts, txh, sfckdm,   
    pyckdm, fyckdm, jsbz, jlzt, fybz, cflx, sycfbz, tscfbz, pybz, jcxh, memo, cfxh,zje,zfyje,yhje,zfje, sqdxh  
    ,ejygbz, ejygksdm,xzks_id,ylxzbh,tmhdbz,ghxh,gxrq,wsbz,wsts,cftszddm,cftszdmc,yscfbz)  
   select @sjh, @hjxh, @czyh, @now, a.patid, a.hzxm, @ybdm, a.py, a.wb,  
    @ysdm, @ksdm, @yfdm, '', '', '', @pyczyh, @pyrq, @cfts, null, @sfckdm,  
    @pyckdm, @fyckdm, 1, 9, @fybz, @cflx, @sycfbz, @tscfbz, @pybz, null, null, @cfxh,@zjecf,@zfyjecf,@yhjecf,@zfje, @sqdxh  
    ,@ejygbz, case when @ejygbz=1 then @ejygksdm else "" end,isnull(b.xzks_id,b.ks_id),@ylxzbh  
    ,case when @cfts>0 and @cflx = 3 and @cfts%7 = 0 then '1' else '0' end  
    ,isnull(@ghxhtmp,-1),@now,isnull(@wsbz,0),isnull(@wsts,0),@tbzddm,@tbzdmc,@yscfbz --add by yfq @20120528  
    from #brxxk a,YY_ZGBMK b(nolock)  
    where b.id=@ysdm  
   if @@error<>0 or @@rowcount=0  
   begin  
    select "F","保存收费处方出错！"  
    rollback tran  
    deallocate cs_mzsf  
    return  
   end  
   
   select @xhtemp=@@identity  
    
   insert into SF_CFMXK(cfxh, cd_idm, gg_idm, dxmdm, ypmc, ypdm, ypdw, dwxs, ykxs, ypfj, ylsj,   
    ypsl, ts, cfts, zfdj, yhdj, memo, ypgg, shbz, flzfdj,txbl,lcxmdm,lcxmmc,zbz,hjmxxh,lcxmsl,dydm  
    ,lcjsdj,yjqrbz,zje,wsbz) --add "dydm" 20070119 --agg 2004.07.09 增加lcxmdm,lcxmmc,zbz  
   select @xhtemp, idm, gg_idm, dxmdm, ypmc, xxmdm, ypdw, dwxs, ykxs, ypfj, ylsj,   
    fysl, 1, cfts, zfdj, yhdj, convert(varchar(100),memo) memo, ypgg, shbz, flzfdj,txbl,lcxmdm,lcxmmc,zbz,hjmxxh,lcxmsl,dydm   
    ,lcjsdj,case when @hjcfjlzt in (3,8) and @cflx not in (1,2,3,7) and @sqdlb <> '99' then 1   
    when @sqdlb ='99' then 8 else yjqrbz end--add "dydm" 20070119  --agg 2004.07.09 增加lcxmdm,lcxmmc,zbz  
    ,isnull(round(fysl*ylsj*cfts/ykxs,2),0),isnull(mxwsbz,0)  
    from #sfmx where cfxh=@cfxh order by ind  
   if @@error<>0  
   begin  
    select "F","保存收费处方明细出错！"  
    rollback tran  
    deallocate cs_mzsf  
    return    
   end  
  end  
  else  
  begin  
   if exists(select 1 from #sfmx where cfxh=@cfxh and isnull(ejygbz,0)=0)  
   begin  
    insert into SF_MZCFK(jssjh, hjxh, czyh, lrrq, patid, hzxm, ybdm, py, wb,   
     ysdm, ksdm, yfdm, qrczyh, qrrq, qrksdm, pyczyh, pyrq, cfts, txh, sfckdm,   
     pyckdm, fyckdm, jsbz, jlzt, fybz, cflx, sycfbz, tscfbz, pybz, jcxh, memo, cfxh,zje,zfyje,yhje,zfje, sqdxh  
     ,ejygbz, ejygksdm,xzks_id,ylxzbh,tmhdbz,ghxh,gxrq,wsbz,wsts,cftszddm,cftszdmc,yscfbz)  
    select @sjh, @hjxh, @czyh, @now, a.patid, a.hzxm, @ybdm, a.py, a.wb,  
     @ysdm, @ksdm, @yfdm, '', '', '', '', '', @cfts, null, @sfckdm,  
     @pyckdm, @fyckdm, 1, 9, @fybz, @cflx, @sycfbz, @tscfbz, 0, null, null, @cfxh,@zjecf,@zfyjecf,@yhjecf,@zfje, @sqdxh  
     ,0,  "", isnull(b.xzks_id,b.ks_id),@ylxzbh  
     ,case when @cfts>0 and @cflx = 3 and @cfts%7 = 0 then '1' else '0' end  
     ,isnull(@ghxhtmp,-1),@now,isnull(@wsbz,0),isnull(@wsts,0),@tbzddm,@tbzdmc,@yscfbz  --add by yfq @20120528  
     from #brxxk a,YY_ZGBMK b(nolock)  
    where b.id=@ysdm   
    if @@error<>0 or @@rowcount=0  
    begin  
     select "F","保存收费处方出错！"  
     rollback tran  
     deallocate cs_mzsf  
     return  
    end  
    
    select @xhtemp=@@identity  
     
    insert into SF_CFMXK(cfxh, cd_idm, gg_idm, dxmdm, ypmc, ypdm, ypdw, dwxs, ykxs, ypfj, ylsj,   
     ypsl, ts, cfts, zfdj, yhdj, memo, ypgg, shbz, flzfdj,txbl,lcxmdm,lcxmmc,zbz,hjmxxh,lcxmsl,dydm  
     ,lcjsdj,zje,yjqrbz,wsbz) --add "dydm" 20070119  --agg 2004.07.09 增加lcxmdm,lcxmmc,zbz  
    select @xhtemp, idm, gg_idm, dxmdm, ypmc, xxmdm, ypdw, dwxs, ykxs, ypfj, ylsj,   
     fysl, 1, cfts, zfdj, yhdj, memo, ypgg, shbz, flzfdj,txbl,lcxmdm,lcxmmc,zbz,hjmxxh,lcxmsl,dydm   
     ,lcjsdj--add "dydm" 20070119  --agg 2004.07.09 增加lcxmdm,lcxmmc,zbz  
     ,isnull(round(fysl*ylsj*cfts/ykxs,2),0),yjqrbz,isnull(mxwsbz,0)  
     from #sfmx where cfxh=@cfxh  and isnull(ejygbz,0)=0 order by ind  
    if @@error<>0  
    begin  
     select "F","保存收费处方明细出错！"  
     rollback tran  
     deallocate cs_mzsf  
     return    
    end  
   end  
  
   if exists(select 1 from #sfmx where cfxh=@cfxh and isnull(ejygbz,0)=1)  
   begin  
    insert into SF_MZCFK(jssjh, hjxh, czyh, lrrq, patid, hzxm, ybdm, py, wb,   
     ysdm, ksdm, yfdm, qrczyh, qrrq, qrksdm, pyczyh, pyrq, cfts, txh, sfckdm,   
     pyckdm, fyckdm, jsbz, jlzt, fybz, cflx, sycfbz, tscfbz, pybz, jcxh, memo, cfxh,zje,zfyje,yhje,zfje, sqdxh  
     ,ejygbz, ejygksdm,xzks_id,ylxzbh,tmhdbz,ghxh,gxrq,wsbz,wsts,cftszddm,cftszdmc,yscfbz)  
    select @sjh, @hjxh, @czyh, @now, a.patid, a.hzxm, @ybdm, a.py, a.wb,  
     @ysdm, @ksdm, @yfdm, '', '', '', '', '', @cfts, null, @sfckdm,  
     @pyckdm, @fyckdm, 1, 9, @fybz, @cflx, @sycfbz, @tscfbz, 0, null, null, @cfxh,@zjecf,@zfyjecf,@yhjecf,@zfje, @sqdxh  
     ,1,  @ksdm ,isnull(b.xzks_id,b.ks_id),@ylxzbh  
     ,case when @cfts>0 and @cflx = 3 and @cfts%7 = 0 then '1' else '0' end  
     ,isnull(@ghxhtmp,-1),@now,isnull(@wsbz,0),isnull(@wsts,0),@tbzddm,@tbzdmc,@yscfbz  --add by yfq @20120528  
     from #brxxk a,YY_ZGBMK b(nolock)  
    where b.id=@ysdm   
    if @@error<>0 or @@rowcount=0  
    begin  
     select "F","保存收费处方出错！"  
     rollback tran  
     deallocate cs_mzsf  
     return  
    end  
    
    select @xhtemp=@@identity  
    
    insert into SF_CFMXK(cfxh, cd_idm, gg_idm, dxmdm, ypmc, ypdm, ypdw, dwxs, ykxs, ypfj, ylsj,   
     ypsl, ts, cfts, zfdj, yhdj, memo, ypgg, shbz, flzfdj,txbl,lcxmdm,lcxmmc,zbz,hjmxxh,lcxmsl,dydm  
     ,lcjsdj,zje,yjqrbz,wsbz) --add "dydm" 20070119  --agg 2004.07.09 增加lcxmdm,lcxmmc,zbz  
    select @xhtemp, idm, gg_idm, dxmdm, ypmc, xxmdm, ypdw, dwxs, ykxs, ypfj, ylsj,   
     fysl, 1, cfts, zfdj, yhdj, memo, ypgg, shbz, flzfdj,txbl,lcxmdm,lcxmmc,zbz,hjmxxh,lcxmsl,dydm   
     ,lcjsdj--add "dydm" 20070119  --agg 2004.07.09 增加lcxmdm,lcxmmc,zbz  
     ,isnull(round(fysl*ylsj*cfts/ykxs,2),0),yjqrbz,isnull(mxwsbz,0)  
     from #sfmx where cfxh=@cfxh  and isnull(ejygbz,0)=1 order by ind  
    if @@error<>0  
    begin  
     select "F","保存收费处方明细出错！"  
     rollback tran  
     deallocate cs_mzsf  
     return    
    end      
   end    
  end   
  
  --插入辅助表  
  insert into SF_MZCFK_FZ(jssjh,hjxh,cfxh,patid,ccfbz)  
  values(@sjh,@hjxh,@xhtemp,@patid,@ccfbz)  
  if @@error<>0  
  begin  
   select "F","保存收费处方明细出错！"  
   rollback tran  
   deallocate cs_mzsf  
   return    
  end  
    
  select @yjclfbz_temp=yjclfbz from #mzsftmp where cfxh=@cfxh  
  
  insert into SF_CFMXK_FZ(cfxh,mxxh,hjmxxh,yjclfbz,sl,se,sqje,shje)  
  select @xhtemp,a.xh,a.hjmxxh,@yjclfbz_temp   
   ,isnull(b.sl,0)              --税率  
   ,round(a.ypsl*(a.ylsj-a.yhdj)*isnull(b.sl,0)*a.cfts/a.ykxs,2)  --税额  
   ,round(a.ypsl*(a.ylsj-a.yhdj)*a.cfts/a.ykxs,2)      --税前金额  
   ,round(a.ypsl*(a.ylsj-a.yhdj)*(1-isnull(b.sl,0))*a.cfts/a.ykxs,2) --税后金额  
  from SF_CFMXK a  
   left join YY_SFXXMK b on  a.ypdm=b.id and a.cd_idm=0  
  where cfxh=@xhtemp  
    
  if @@error<>0  
  begin  
   select "F","保存收费处方明细出错！"  
   rollback tran  
   deallocate cs_mzsf  
   return    
  end    
    
     fetch cs_mzsf into @cfxh, @ksdm, @ysdm, @yfdm, @hjxh, @cflx, @sycfbz, @tscfbz, @cfts, @pyckdm, @fyckdm,@zjecf,@zfyjecf,  
     @yhjecf,@zfje,@ejygbz,@ejygksdm,@fybz,@wsbz,@wsts,@tbzddm,@tbzdmc,@yscfbz,@ccfbz,@ghxhtmp --add by ozb 增加二级药柜标志  
 end  
 close cs_mzsf  
 deallocate cs_mzsf  
 --将划价明细库的数据更新到处方明细库   
 update a set ssbfybz=b.ssbfybz,a.ldcfxh=b.ldcfxh,a.ldmxxh=b.ldmxxh  from SF_CFMXK a,SF_HJCFMXK b,#sfzd c where a.hjmxxh=b.xh and b.cfxh=c.hjxh  
 if @@error<>0  
 begin  
  select "F","更新处方明细库出错！"  
  rollback tran  
  return    
 end  
 --需求131729 SF_HJCFMXK_FZ(fzxh、fzbz)   
 update a set fzbz=b.fzbz,fzxh=b.fzxh from SF_CFMXK_FZ a,SF_HJCFMXK_FZ b,#sfzd c where a.hjmxxh=b.mxxh and b.cfxh=c.hjxh  
 if @@error<>0  
 begin  
  select "F","更新处方明细辅助库出错！"  
  rollback tran  
  return    
 end  
  
 IF @qkbz2=2  
  SELECT @sfje2=@sfje2-@srje, @srje=0  
  
 insert into SF_BRJSK(sjh, patid, ghsjh, ghxh, fph, fpjxh, czyh, sfrq, sfksdm, ksdm,   
  hzxm, blh, ybdm, pzh, sfzh, ylxm, zddm, dwbm, zje, zfyje, yhje, deje, zfje,   
  zpje, zph, xjje, srje, qkbz, qkje, zxlsh, jslsh, ybjszt, zhbz, tsjh, jlzt, cardno,  
  cardtype, ghsfbz, jcxh, memo, mjzbz, brlx, flzfje, qrbz, tcljje, tcljbz, tjmfbz,lcyhje,gxrq,lrrq  
  ,yhdm,appjkdm)  
 select @sjh, patid, @ghsjh, @ghxh, null, null, @czyh, @now, @sfksdm, @ksdm,  
  hzxm, blh, @ybdm, pzh, sfzh, @xmlb, @zddm, dwbm, @zje+@zje1, @zfyje+@zfyje1, @yhje+@yhje1, 0, @sfje2,  
  0, '', 0, @srje, @qkbz1, @qkje, null, null, 0, @zhbz, null, 0, cardno,  
  cardtype, 1, null, null, @mjzbz, @brlx, @flzfje+@flzfje1, @qrbz, @tcljje1, @tcljbz, @tjmfbz   
  ,@lcyhje,@now,@now,@yhdm,@kfsdm  
  from #brxxk  
 if @@error<>0  
 begin  
  select "F","保存结算账单出错！"  
  rollback tran  
  return    
 end  
  
 insert into SF_BRJSMXK(jssjh, dxmdm, dxmmc, fpxmdm, fpxmmc, xmje, zfje, zfyje, yhje, memo, flzfje,lcyhje)  
 select @sjh, dxmdm, dxmmc, mzfp_id, mzfp_mc, xmje, zfje, zfyje, yhje, null, flzfje,lcyhje  
  from #sfmx1  
 if @@error<>0  
 begin  
  select "F","保存结算明细出错！"  
  rollback tran  
  return    
 end  
   
 if exists (select 1 from sysobjects where name='SF_BRJSK_FZ' and xtype='U')  
 BEGIN  
  if exists(select 1 from SF_BRJSK_FZ where sjh = @sjh)  
  begin  
   delete from SF_BRJSK_FZ where sjh = @sjh  
   if @@error<>0  
   begin  
    select "F","清除SF_BRJSK_FZ重复记录出错！"  
    rollback tran  
    return    
   end   
  end   
             
        -- add 20141104 kcs 本条收费记录所有明细均没有优惠则此记录不保存优惠原因    
  if not exists(select 1 from SF_CFMXK where cfxh in (select xh from SF_MZCFK where jssjh = @sjh) and yhdj <> 0)  
      select @yhyy = ''  
  
  insert into SF_BRJSK_FZ  
  (sjh,patid,ghsjh,ghxh,fph,fpjxh,ip,mac,sfly,yhyydm)  
  select                  
  @sjh, @patid, @ghsjh, @ghxh, null, null,'',@wkdz,@sfly,@yhyy  
  if @@error<>0  
  begin  
   select "F","保存结算账单出错！"  
   rollback tran  
   return  
  end   
 END  
   
 --医保属性相关的判断  
 if exists(select 1 from sysobjects where name='usp_sf_sfcl_ybkz' and type='P')   
 begin  
  exec usp_sf_sfcl_ybkz @patid,@sjh,0,@outmsg output  
  if substring(@outmsg,1,1)<>'T'  
  begin  
   select 'F',@outmsg  
   rollback tran  
   return  
  end  
 end  
 --药品多批次单价计算处理逻辑  
 declare @isdlsjfa ut_bz, --是否采用多零售价方案（0不采用，1采用）  
  @ypxtslt int,--零售价方案  
  @cfmxxh_temp ut_xh12,@cfxh_temp ut_xh12,  
  @djpcxh ut_xh12,--冻结指定批次序号(默认为0，按3183参数规则，定批次）  
  @rtnmsg varchar(50), --返回信息  
  @totalYplsje ut_je14, --返回批次拆分后，总零售金额  
  @totalYpjjje ut_je14, --返回批次拆分后，总进价金额  
  @avgYplsj ut_money,  --返回批次拆分后，平均药品零售价  
  @avgYpjj ut_money,  --返回批次拆分后，平均药品进价  
  @yfpcxhlist  varchar(500), --返回批次拆分后，药房批次序号列表 以逗号分隔  
  @yfpcsllist  varchar(500), --返回批次拆分后，药房批次数量列表 以逗号分隔  顺序和@yfpcxhlist一致  
  @zje_cs  ut_money,   --重算后总金额  
  @sfje_cs ut_money,   --重算后实收金额  
  @ybje_cs ut_money,   --重算后医保金额   
  @flzfje_cs ut_money, --重算后分类自负金额  
  @yjzfje_cs ut_money  --重算后预交金支付余额  
 select @isdlsjfa=0,@ypxtslt=0  
 if exists(select 1 from sysobjects where name='f_get_ypxtslt')   
 begin  
  select @ypxtslt=dbo.f_get_ypxtslt()    
  if @ypxtslt=3   
  select @isdlsjfa=1  
 end  
 if @isdlsjfa=1 and exists(select 1 from SF_MZCFK a,SF_CFMXK b where a.jssjh=@sjh and a.xh=b.cfxh and a.cflx in(1,2,3))  
 begin  
    --add by l_jj 2017-11-05 for 210848 先解冻医生  
        if exists(select 1 from YY_CONFIG (nolock) where id='3525' and config='是')  
           and exists(select 1 from SF_MZCFK (nolock) where jssjh=@sjh and cflx in(1,2,3) and isnull(hjxh,0)<>0)  
     begin  
            declare @hjxh_temp   ut_xh12,  
                    @i           ut_xh12,  
                    @count       int  
            create table #ypdj_hjxh  
 (  
                xh      ut_xh12 identity not null,  
                hjxh    ut_xh12          not null  
            )  
   create table #result  
   (  
       resultcode  ut_mc16,  
    resultmsg   ut_mc256  
   )  
            insert into #ypdj_hjxh(hjxh)  
            select distinct hjxh from SF_MZCFK (nolock) where jssjh=@sjh and cflx in(1,2,3) and isnull(hjxh,0)<>0  
  
            select @i=1  
            select @count=count(1) from #ypdj_hjxh  
          
            if isnull(@count,0)>0  
            begin  
                select @rtnmsg=''  
    delete from #result insert into #result exec usp_yf_mzys_ypdpcdj_undo @wkdz,1,0,@rtnmsg output  
                if @rtnmsg like 'F%'  
                begin  
                    select 'F','药品解冻出错1：'+@rtnmsg  
                    rollback tran  
                    return  
                end  
  
                while @i<=@count  
                begin  
                    select @hjxh_temp=hjxh from #ypdj_hjxh where xh=@i  
  
                    select @rtnmsg=''  
                    delete from #result insert into #result exec usp_yf_mzys_ypdpcdj_undo @wkdz,2,@hjxh_temp,@rtnmsg output  
                    if @rtnmsg like 'F%'  
                    begin  
                        select 'F','药品解冻出错2：'+@rtnmsg  
                        rollback tran  
                        return  
                    end  
  
                    select @i=@i+1  
                end  
  
                select @rtnmsg=''  
                delete from #result insert into #result exec usp_yf_mzys_ypdpcdj_undo @wkdz,3,0,@rtnmsg output  
                if @rtnmsg like 'F%'  
                begin  
                    select 'F','药品解冻出错3：'+@rtnmsg  
                    rollback tran  
                    return  
                end  
            end  
        end  
  
  declare cs_mzsf_dpcjgcl cursor for  
  select b.xh,a.xh  from SF_MZCFK a,SF_CFMXK b where a.jssjh=@sjh and a.xh=b.cfxh and a.cflx in(1,2,3)  
  for read only  
  open cs_mzsf_dpcjgcl  
  fetch cs_mzsf_dpcjgcl into @cfmxxh_temp,@cfxh_temp  
  while @@fetch_status=0  
  begin  
   select @rtnmsg ='',@totalYplsje =0,@totalYpjjje =0,@avgYplsj =0,@avgYpjj =0,@yfpcxhlist ='',@yfpcsllist =''  
  
   exec usp_yf_mzsf_ypdpcdj_inf 1,@cfmxxh_temp,0,0,@rtnmsg output,@totalYplsje output,@totalYpjjje output,@avgYplsj output,@avgYpjj output,@yfpcxhlist output,@yfpcsllist output  
   if substring(@rtnmsg,1,1)<>'T'  
   begin  
    select 'F','药品多批次单价计算出错：'+@rtnmsg  
    rollback tran  
    deallocate cs_mzsf_dpcjgcl  
    return  
   end  
   update SF_CFMXK set zje=@totalYplsje,ylsj=@avgYplsj where xh=@cfmxxh_temp and cfxh=@cfxh_temp  
   if @@error<>0  
   begin  
    select 'F','药品多批次单价计算出错：更新处方明细库零售价时出错'  
    rollback tran  
    deallocate cs_mzsf_dpcjgcl  
    return  
   end  
   fetch cs_mzsf_dpcjgcl into @cfmxxh_temp,@cfxh_temp  
  end  
  close cs_mzsf_dpcjgcl  
  deallocate cs_mzsf_dpcjgcl  
    
  ---for vsts 225606 by maoyong 20171117 begin  
  declare @yhcs varchar(20)  
  select @yhcs='是'  
  if exists(select 1 from YY_CONFIG (nolock) where id='2534')  
   select @yhcs=ISNULL(config,'是') from YY_CONFIG (nolock) where id='2534'  
  
    
  if @yhcs='是'  and  @zfbz = 3   
  begin  
      select b.xh,a.jssjh,b.cd_idm,c.sxjg,c.yhbl  into #tempdpcyhcl  from SF_MZCFK a,SF_CFMXK b,YY_TSSFXMK c   
   where a.jssjh=@sjh and  a.xh=b.cfxh and a.cflx in(1,2,3) and b.cd_idm=c.idm and b.cd_idm>0 and c.ybdm =@ybdm   
     
   update a set yhdj = case when b.sxjg<a.ylsj and b.sxjg>0 then sxjg else convert(numeric(10,2),ylsj*yhbl) end   
    from  SF_CFMXK a   
   inner join #tempdpcyhcl b on a.xh =b.xh   
  
   update a set zfdj =ylsj-yhdj   
    from  SF_CFMXK a   
   inner join #tempdpcyhcl b on a.xh =b.xh   
  
  end  
    
  ---for vsts 225606 by maoyong 20171117 end  
    
    
  --插入处方明细三级表  
  insert into SF_CFMXK_DPC(cfmxxh,cfxh,pcxh,cd_idm,ypmc,ypdm,ylsj,ypsl,memo)  
  select b.xh,b.cfxh,c.pcxh,b.cd_idm,b.ypmc,b.ypdm,c.yplsj,c.djk_djsl,'' from SF_MZCFK a,SF_CFMXK b,YF_YPDJJLK c   
  where a.jssjh=@sjh and a.xh=b.cfxh and a.cflx in(1,2,3)  
    and b.xh=c.mxxh and b.cfxh=c.zd_xh and c.mxtbname='SF_CFMXK'   
  if @@error<>0  
  begin  
   select 'F','插入处方明细三级表SF_CFMXK_DPC出错'  
   rollback tran  
   return  
  end   
    
    
    
    
    
  --费用重算，价格变动  
  --注意：上海医保不支持，重算太复杂，牵涉医保算法的维护，所以此处未处理  
  exec usp_sf_sfcl_jecs @sjh,@rtnmsg output,@zje_cs output, @sfje_cs output,@ybje_cs output, @flzfje_cs output, @yjzfje_cs output  
  if substring(@rtnmsg,1,1)<>'T'  
  begin  
   select 'F','费用重算出错：'+@rtnmsg  
   rollback tran  
   return  
  end  
 end  
 if @config2466='是'  
 begin  
  exec usp_sf_lcxmyhjs @sjh,@rtnmsg output,@zje_cs output, @sfje_cs output,@ybje_cs output, @flzfje_cs output, @yjzfje_cs output  
  if substring(@rtnmsg,1,1)<>'T'  
  begin  
   select 'F','临床项目优惠结算出错：'+@rtnmsg  
   rollback tran  
   return  
  end   
 end  
 commit tran  
 if (@isdlsjfa=1 and exists(select 1 from SF_MZCFK a,SF_CFMXK b where a.jssjh=@sjh and a.xh=b.cfxh and a.cflx in(1,2,3))) or (@config2466='是')  
  select "T",@sjh,@zje_cs, @sfje_cs,@ybje_cs, @flzfje_cs, @yjzfje_cs,  
  @ybzje, @ybjszje, @ybzlf, @ybssf, @ybjcf, @ybhyf, @ybspf, @ybtsf, @ybxyf, @ybzyf, @ybcyf, @ybqtf, @ybgrzf,@jfbz,@jfje --20--21  
 else  
  select "T", @sjh, @zje+@zje1, @sfje2-@qkje, @ybje+@ybje1, @flzfje+@flzfje1, @yjzfje,  
  @ybzje, @ybjszje, @ybzlf, @ybssf, @ybjcf, @ybhyf, @ybspf, @ybtsf, @ybxyf, @ybzyf, @ybcyf, @ybqtf, @ybgrzf,@jfbz,@jfje --20--21  
  
 /*收费信息保存 end*/  
  
end  
return  
  
  
  
  
  
  
  
  
  
  
  
  