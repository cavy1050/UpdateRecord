Text
CREATE proc usp_sf_bftf
	@wkdz varchar(32),
	@jszt smallint,
	@sfbz smallint,
	@qtbz smallint,
	@rqbz smallint,
  	@sjh ut_sjh,
	@czyh ut_czyh,
	@cfxh ut_xh12,
	@mxxh ut_xh12, 
	@tysl ut_sl10, 
	@cfts integer,
	@newsjh ut_sjh = null,
	@zxlsh_tf ut_lsh = null,
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
	@jsrq ut_rq16 = '',
	@jsrq_tf ut_rq16 = ''
	,@ylknewje ut_money=0
	,@ylkhcsqxh ut_lsh=''
	,@ylkhczxlsh ut_lsh=''
	,@ylknewsqxh ut_lsh=''
	,@ylknewzxlsh ut_lsh=''
	,@zffs ut_bz=0
	,@tfksdm     ut_ksdm=''--add by wudong 2015-06-19 要求29652
	,@isxjtf_paycenter ut_bz=0 --结算支付中心按现金退费
as --集160146 2019-12-26 16:23:45 4.0标准版_201810补丁
/**********
[版本号]4.0.0.0.0
[创建时间]2004.11.3
[作者]王奕
[版权] Copyright ? 2004-2008上海金仕达-卫宁软件股份有限公司[描述]收费部分退费
[功能说明]
	收费部分退费，支持退非药费，支持药房退药的收费确认
[参数说明]
	@wkdz varchar(32),	网卡地址
	@jszt smallint,		结束状态	1=创建表，2=插入，3=递交
	@sfbz smallint,		收费标志0=预算，1=递交(请求1), 2=正式递交(请求2)
	@qtbz smallint,		全退标志0=部分，1=全退(此标志只在@sfbz=2时生效)
	@rqbz smallint,		日期标志0=日库，1=年库
  	@sjh ut_sjh,		收据号
	@czyh ut_czyh,		操作员号
	@cfxh ut_xh12,		处方序号
	@mxxh ut_xh12,		明细序号
	@tysl ut_sl10,		退药数量
	@cfts integer,		处方贴数
	@newsjh ut_sjh = null,		新收据号
	@zxlsh_tf ut_lsh = null,	退费返回的中心流水号
	@zhbz ut_zhbz = null,		账户标志	
	@zddm ut_zddm = null,		诊断代码
	@zxlsh ut_lsh = null,		中心流水号
	@jslsh ut_lsh = null,		计算流水号
	@xmlb ut_dm2 = null,		大病项目
	@qfdnzhzfje numeric(12,2) = null, 	起付段当年账户支付
	@qflnzhzfje numeric(12,2) = null,	起付段历年帐户支付
	@qfxjzfje numeric(12,2) = null,		起付段现金支付
	@tclnzhzfje numeric(12,2) = null,	统筹段历年帐户支付
	@tcxjzfje numeric(12,2) = null,		统筹段现金支付
	@tczfje numeric(12,2) = null,		统筹段统筹支付
	@fjlnzhzfje numeric(12,2) = null,	附加段历年帐户支付
	@fjxjzfje numeric(12,2) = null,		附加段历金支付
	@dffjzfje numeric(12,2) = null		附加段地方附加支付
	@dnzhye numeric(12,2) = null,		当年账户余额
	@lnzhye numeric(12,2) = null		历年账户余额
	@jsrq ut_rq16 = ''					结算日期
	@jsrq_tf ut_rq16 = ''				结算日期(退费)
--mit ,, 2oo3-o5-o8 ,, 银联卡参数
	,@ylknewje ut_money=0		--银联卡金额
	,@ylkhcsqxh ut_lsh=''		--银联卡退申请序号
	,@ylkhczxlsh ut_lsh=''		--银联卡退中心流水号
	,@ylknewsqxh ut_lsh=''		--银联卡新申请序号
	,@ylknewzxlsh ut_lsh=''		--银联卡新中心流水号
	,@zffs ut_bz=0				--支付方式0－退现金，1－退支票
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]
[修改日志]
qxh 2003.5.29 加了按处方打发票方式下的退部分处方处方
tony 2003.8.21 修改了医保分类自负部分
tony 2003.12.8 小城镇医保修改
gzy 20050330 增加部分退费时新处方的窗口沿用老的发药序号
zwj 20050616 增加划价明细序号的处理
ozb 20060320 增加二级药柜的处理
ozb 20060622 增加发票组号的红冲及相关处理，增加发票明细对应库的红冲
ozb 20060704 增加对旧的打印模式的兼容的处理
sunyu 20061206 增加对帮困病人不计分类自付的处理
**********/
set nocount on

--生成递交的临时表
declare @tablename varchar(32),@acfdfp ut_bz,@bcdwtffp ut_bz
	,@configdyms	ut_bz	--打印模式0 旧模式 1 新模式	--add by ozb 20060704
	,@bkybdmjh		varchar(255)
    ,@isbftfall     ut_bz ---一张发票0允许1不允许部分退
    ,@qtbz_cf      ut_bz
	,@postffs		ut_bz	--在2181为是的情况下 0:按选择来处理 1:当日隔日默认都退pos  2:当日隔日默认都退现金 3:当日退pos隔日退金
	,@ntfts			int		--退费天数
	,@acfdfp_dyfs	varchar(2)	--按处方打印时打印方式：0按处方数打印1合并西药处方类型2和并相同的执行科室和大项类型
    ,@zdgrjzsj varchar(20) --最大的该操作员结账日期
    ,@yczyh ut_czyh  --退费记录的操作员号 
    ,@ysfrq varchar(20) --退费记录的收费日期
    ,@config2545 varchar(500)--门诊收费除POS机外允许按照现金退费的支付方式集合 默认为空，多个代码用逗号分隔，以逗号开头逗号结尾

,@sfly ut_bz  --收费来源
declare	@outmsg varchar(200)
declare @yjclfbz   ut_bz,
		@yjqxyy ut_mc64
exec usp_yy_ldjzq @outmsg output
if substring(@outmsg,1,1)='F'
begin
	select	'F',substring(@outmsg,2,200)
	return
end

select @tablename='##sfbftf'+@wkdz+@czyh

if (select config from YY_CONFIG (nolock) where id='2044')='否'
 	set   @acfdfp=0
else
 	set   @acfdfp=1
 	

--add by ozb
if exists(select 1 from YY_CONFIG where id='2153'and config='是') 
	select @bcdwtffp=1
else
	select @bcdwtffp=0

--add by ozb 收费是否使用新的打印模式
if exists(select 1 from YY_CONFIG where id='2154' and config='是')
	select @configdyms=1 
else 
	select @configdyms=0

if exists(select 1 from YY_CONFIG where id='2192' and config='是')
	select @isbftfall=1 
else 
	select @isbftfall=0

select @acfdfp_dyfs=config from YY_CONFIG (nolock) where id='2270'
if @@rowcount=0 or isnull(@acfdfp_dyfs,'')=''
select @acfdfp_dyfs='0'

--add by sunyu 2006-12-06
select @bkybdmjh=config from YY_CONFIG (nolock) where id='0102'

select @postffs=config from YY_CONFIG (nolock) where id='2204'
select @postffs=isnull(@postffs,0)

select @config2545=config from YY_CONFIG(nolock) where id='2545'

if (@sjh='zzj' or @sjh='zzsf') select @sfly=1
	if @sjh='yszdy' select @sfly=2
	if @sjh='mzyj'  select @sfly=3
	if ltrim(rtrim(@sjh))='000' select @sfly=0 

--cjt 判断有无权限退现金	alter by liuchun 20140523
declare @gwdm	varchar(50),@config0205 varchar(50),@strMess varchar(5),@isCross smallint
select @gwdm = isnull(gwdm,'') from czryk(nolock) where id = @czyh
select @config0205 = isnull(config,'') from YY_CONFIG(nolock) where id = '0205'
select @isCross = 0
if exists(select 1 from SF_BRJSK where sjh=@sjh and jlzt=0 and ybjszt=2 and xjje<>0)
   and @config0205 <> ''
begin
	--按照岗位代码来判断，某些操作员可能存在多个岗位代码，需要逐个解析 需求202881
	while ltrim(@gwdm)<>'' 
	begin
		select @strMess = SUBSTRING(@gwdm,1,CHARINDEX(',',@gwdm)-1)
		select @gwdm = SUBSTRING(@gwdm,CHARINDEX(',',@gwdm)+1,LEN(@gwdm)-CHARINDEX(',',@gwdm))
		if CHARINDEX('"'+@strMess+'"',@config0205)>0
		begin
			select @isCross=1
			break
		end
	end
	if @isCross <> 1
	begin
		select 'F','操作员没有退现金权限'
		return
	end
end
if exists (select 1 from YY_CONFIG(nolock) where id='0236' and config='否')
begin
    if exists (select 1 from VW_MZBRJSK where sjh=@sjh and isnull(fph,0)=0 and fpdybz <> 2)
    begin
        select 'F','此结算记录未打印发票，不能退费！'
        return
    end
end
if @jszt=1
begin
	exec('if exists(select * from tempdb..sysobjects where name="'+@tablename+'")
		drop table '+@tablename)
	exec('create table '+@tablename+'(
		cfxh ut_xh12 not null,
		mxxh ut_xh12 not null,
		cfts int not null,
		tysl ut_sl10 not null
		)')
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
	declare @ccfxh varchar(12),
		@cmxxh varchar(12),
		@ccfts varchar(8),
		@ctysl varchar(12)

	select @ccfxh=convert(varchar(12),@cfxh),
		@cmxxh=convert(varchar(12),@mxxh),
		@ccfts=convert(varchar(8),@cfts),
		@ctysl=convert(varchar(12),@tysl)

	exec('insert into '+@tablename+' values('+@ccfxh+','+@cmxxh+','+@ccfts+','+@ctysl+')')
	if @@error<>0
	begin
		select "F","插入临时表时出错！"
		return
	end 
    if exists(select 1 from YF_MZFYZD b(nolock) where b.jssjh=@sjh and b.cfxh=@cfxh and b.fybz=1  )
	if not exists(select 1 from YF_MZFYZD b(nolock) where b.jssjh=@sjh and b.cfxh=@cfxh and b.fybz=1 and b.tfbz=1 and b.jlzt=0 and b.tfqrbz = 0 )
	begin
		select "F","此处方存在已发药信息,请先退药！"
		return
	end 
	select "T"
	return
end

declare	@now ut_rq16,		--当前时间
		@ybdm ut_ybdm,		--医保代码
		@zfbz smallint,		--比例标志
		@rowcount int,
		@error int,
		@zje ut_money,		--药费总金额
		@zje1 ut_money,		--非药费总金额
		@zfyje ut_money,	--自费药费金额
		@zfyje1 ut_money,	--自费非药费金额
		@yhje ut_money,		--优惠药费金额
		@yhje1 ut_money,	--优惠非药费金额
		@ybje ut_money,		--可用于医保计算的药费金额
		@ybje1 ut_money,	--可用于医保计算的非药费金额
		@pzlx ut_dm2,		--凭证类型
		@sfje ut_money,		--实收金额(药品)
		@sfje1 ut_money,	--实收金额(非药品)
		@flzfje ut_money,	--分类自费金额(药品)
		@flzfje1 ut_money,	--分类自费金额(非药品)
		@flzfjedbxm ut_money, --分类自负金额(大病范围项目)
		@sfje_all ut_money,	--实收金额(包含自费金额)
		@errmsg varchar(50),
		@srbz char(1),		--舍入标志
		@srje ut_money,		--舍入金额
		@sfje2 ut_money,	--舍入后的实收金额
		@xhtemp ut_xh12,
		@ksmc ut_mc32,		--科室名称
		@ysmc ut_mc32,		--医生姓名
		@xmzfbl float,		--药品自付比例
		@xmzfbl1 float,		--非药品自付比例
		@xmzfbltf float,	--药品自付比例
		@xmzfbltf1 float,	--非药品自付比例
		@xmce ut_money,		--自付金额和大项自付金额汇总的差额
		@fplx smallint,		--发票类型
		@fph bigint,			--发票号
		@fpjxh ut_xh12,		--发票卷序号
		@print smallint,	--是否打印0打印，1不打
		@tfbz smallint,		--退费标志0=第一次退，1=曾经失败过
		@newsjh1 ut_sjh,
		@qkbz smallint,		--欠款标志0：正常，1：记账，2：欠费
		@qkje ut_money,		--欠款金额（记账金额）
		@qkje1 ut_money,	--欠款金额（记账金额）
		@zhje ut_money,		--账户金额
		@patid ut_xh12,		--病人唯一标志
		@djbz int,			--冻结标志
		@qkbz1 smallint,	--欠款标志0：正常，1：记账，2：欠费
		@sfrq 	ut_rq16,		--退费的收费日期
		@qkje2 ut_money, 		--帮困金额 保留两位小数
		@sfje_bkall ut_money,	--帮困实收金额(包含自费金额)
		@tcljbz1 int,		--统筹累计标志
		@tcljje1 ut_money,	--统筹累计金额（镇保、新疆回沪使用）
		@config3291 varchar(5),
		@config2395 varchar(500),  --大病减负范围内的项目代码集合
		@ccfbz ut_bz --长处方标志,

declare @ybzje	ut_money,	--医保交易费用总额
	@ybjszje ut_money,	--医保结算范围费用总额
	@ybzlf ut_money,	--治疗费
	@ybssf ut_money,	--手术材料费
	@ybjcf ut_money,	--检查费
	@ybhyf ut_money,	--化验费
	@ybspf ut_money,	--摄片费
	@ybtsf ut_money,	--透视费
	@ybxyf ut_money,	--西药费
	@ybzyf ut_money,	--中成药费
	@ybcyf ut_money,	--中草药费
	@ybqtf ut_money,	--其它费
	@ybgrzf ut_money,	--非医保结算范围个人自费
	@yjbz ut_bz,		--是否使用充值卡
	@yjye ut_money,		--预交金余额
	@bdyhkje ut_money --绑定银行卡金额
	,@ylkysje ut_money	--POS卡、建行IC卡金额	add by gzy at 20050501
	--,@posfph	int	--add by gzy at 20061101 过滤POS机的费用
	,@posfph	varchar(32)	--modify by zyh 20090610 支票号可能包含字母
	,@yplcjs2169 varchar(6)  --是否使用药品零差价
	,@lcyhje ut_money   --零差优惠金额
	,@jfbz varchar(2)
	,@jfje ut_money
	,@config2471 smallint
--tony 2003.12.8 小城镇医保修改
declare @tcljje numeric(12,2),	--统筹累计金额
		@jsfs ut_bz,				--结算方式
		@tcljbz ut_bz		--统筹累计标志
--会员卡功能修改新增变量 zwj 2006.12.12
		,@hykmsbz ut_bz		--会员卡模式标志
		,@hysybz ut_bz		--会员使用标志(YY_YBFLK中hysybz)
		,@xjje	ut_money
		,@qrbz	ut_bz
		,@zpje ut_money
		,@zph varchar(32)
		,@tslc	ut_bz	--账户停用后,退费特殊流程,需求6233 add by liuchun 20140926
		,@qkje_ts1 ut_money
		,@qkje_ts ut_money
		,@qrbznew ut_bz		--新生成的记录的qrbz
		,@tfspbz ut_bz		--新生成的记录的tfspbz

if exists(select 1 from YY_JZBRK a(nolock),YY_JZBRYJK b(nolock) where a.xh = b.jzxh and isnull(b.sjh,'') = @sjh 
	and a.jlzt = 1)
begin
	select @tslc = 1
end
else
begin
	select @tslc = 0
end


select @now=convert(char(8),getdate(),112)+convert(char(8),getdate(),8),
	@zje=0, @zfyje=0, @yhje=0, @ybje=0,
	@zje1=0, @zfyje1=0, @yhje1=0, @ybje1=0,
	@sfje=0, @sfje1=0, @sfje_all=0, @srje=0, @sfje2=0, 
	@xmzfbl=0, @xmzfbl1=0, @xmce=0, @print=0, @tfbz=0,
	@qkbz=0, @qkje=0, @qkje1=0, @zhje=0, @djbz=0,@xmzfbltf=0, @xmzfbltf1=0,
	@flzfje=0, @flzfje1=0,@sfje_bkall = 0,@bdyhkje = 0
	, @tcljje1=0,@jfbz = '0',@jfje = 0,@xjje=0,@qrbz=0,@zpje=0,@zph='',@qrbznew=0,@config2471=0

select  @ybzje=0, @ybjszje=0, @ybzlf=0, @ybssf=0,
	@ybjcf=0, @ybhyf=0, @ybspf=0, @ybtsf=0,
	@ybxyf=0, @ybzyf=0, @ybcyf=0, @ybqtf=0,
	@ybgrzf=0, @yjbz=0, @yjye=0,
	@ylkysje = 0,@config2395='',@flzfjedbxm=0	--add by gzy at 20050501

select @tcljje=0, @jsfs=0, @tcljbz=0, @hykmsbz=0,@yplcjs2169 = '',@lcyhje = 0
declare @srfs varchar(1)  --0：精确到分，1：精确到角
select @srfs = 0
select @srfs = config from YY_CONFIG (nolock) where id='2235'
if @@error<>0 or @@rowcount=0
	select @srfs='0'
if exists (select 1 from YY_CONFIG(nolock) where id='3291' and config='是')
    select @config3291='是'
else
    select @config3291='否'
if exists (select 1 from YY_CONFIG(nolock) where id='2395')
    select @config2395=isnull(config,'') from YY_CONFIG(nolock) where id='2395'
else
    select  @config2395=''

if exists(select 1 from YY_CONFIG nolock where id = '2471' and config='是')
	select @config2471 = 1
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

--退费预算
if @sfbz=0
begin
	--开始插入账单、明细表的处理流程
	create table #cfmx_tf
	(
		cfxh ut_xh12 not null,
		mxxh ut_xh12 not null,
		cfts int not null,
		tysl ut_sl10 not null
	)
	exec('insert into #cfmx_tf select * from '+@tablename)
	if @@error<>0
	begin
		select "F","插入临时表时出错！"
		return
	end
	
	exec('drop table '+@tablename)
	
	select xh, jssjh, hjxh,	cfxh, czyh, lrrq, patid, hzxm, ybdm, py, wb, ysdm, ksdm,
    	yfdm, qrczyh, qrrq, qrksdm, pyczyh, pyrq, cfts, txh, sfckdm, pyckdm, fyckdm,
    	jsbz, jlzt, fybz, cflx, sycfbz, tscfbz, pybz, jcxh, memo,zje,zfyje,yhje,zfje,srje,fph,fpjxh,tfbz,tfje,
		fyckxh, sqdxh	-- add by gzy at 20050530
		,ejygbz, ejygksdm,xzks_id,ylxzbh,tmhdbz	--add by ozb 20060320 增加二级药柜的处理
		,ghxh,wsbz,wsts,cftszddm,cftszdmc,yscfbz  --add by yfq @20120528
		into #mzcf_old from SF_NMZCFK where 1=2

	select xh, cfxh, cd_idm, gg_idm, dxmdm,	ypmc, ypdm, ypgg, ypdw, dwxs, ykxs,
    	ypfj, ylsj, ypsl, ts, cfts, zfdj, yhdj, memo, flzfdj, hjmxxh,
		gbfwje, gbfwwje, gbtsbz
		,fpzh			--add fpzh by ozb 20060602 增加发票组号
		,lcxmdm, lcxmmc,lcxmsl,dydm,yjqrbz,zbz,lcjsdj,yjspbz --add "dydm" 20070119
     ,qrczyh,qrksdm,ssbfybz   -- add by sqf 20110323
		,zje,tmxxh,shbz,yqrsl,ktsl,wsbz,ldcfxh,ldmxxh,tfbz,0 gjybz,convert(money,0) gjydeje  --@#$
		into #cfmx_old from SF_NCFMXK where 1=2
    
	--原处方明细
	insert into #mzcf_old 
	select xh, jssjh, hjxh,	cfxh, czyh, lrrq, patid, hzxm, ybdm, py, wb, ysdm, ksdm,
    	yfdm, qrczyh, qrrq, qrksdm, pyczyh, pyrq, cfts, txh, sfckdm, pyckdm, fyckdm,
    	jsbz, jlzt, fybz, cflx, sycfbz, tscfbz, pybz, jcxh, memo,zje,zfyje,yhje,zfje,srje,fph,fpjxh,0,0,
		fyckxh, sqdxh	-- add by gzy at 20050530
		, isnull(ejygbz,0), isnull(ejygksdm,""),xzks_id,ylxzbh,tmhdbz	--add by ozb 20060320 增加二级药柜的处理
		,ghxh,isnull(wsbz,0),isnull(wsts,0),cftszddm,cftszdmc,yscfbz --add by yfq @20120528
		from VW_MZCFK where jssjh=@sjh and jlzt=0 and jsbz=1
	if @@rowcount=0 or @@error<>0
	begin
		select "F","没有有效的处方信息！"
		return
	end   
	insert into #cfmx_old 
	select xh, cfxh, cd_idm, gg_idm, dxmdm,	ypmc, ypdm, ypgg, ypdw, dwxs, ykxs,
    	ypfj, ylsj, ypsl, ts, cfts, zfdj, yhdj, memo, flzfdj, hjmxxh,
		gbfwje, gbfwwje, gbtsbz
		,fpzh			--add by ozb 20060602 增加发票组号
		, lcxmdm, lcxmmc,lcxmsl,dydm,yjqrbz,zbz,lcjsdj,yjspbz --add "dydm" 20070119
        ,qrczyh,qrksdm,ssbfybz,zje,tmxxh,shbz,yqrsl,ktsl,isnull(wsbz,0),ldcfxh,ldmxxh,tfbz,0,0  --@#$ 
		from VW_MZCFMXK where cfxh in (select xh from #mzcf_old)
	if @@rowcount=0 or @@error<>0
	begin
		select "F","没有有效的处方信息！"
		return
	end 
	--打折项目部分退校验
	declare @sqdxh	ut_xh12
	if exists(select 1 from YY_CONFIG nolock where id='0392' and config='是')
	begin
		select a.sqdxh,a.xh as cfxh,b.xh as mxxh,b.ypsl*b.dwxs as ypsl,isnull(d.cfts*d.tysl,0) as tysl,
			dbo.fun_yy_getsqddzbz(0,a.patid,0,0,a.sqdxh,a.ybdm) as dzbz,b.lcxmdm as lcxmdm,
			a.hjxh,b.hjmxxh
		into #tfmx_tf_sqd
		from #mzcf_old a(nolock)
			inner join #cfmx_old b(nolock) on a.xh=b.cfxh
			inner join VW_MZHJCFMXK c(nolock) on b.hjmxxh = c.xh
			left join #cfmx_tf d on b.xh=d.mxxh and a.xh=d.cfxh
		where isnull(c.sfms,0)=1 and b.hjmxxh is not null and b.hjmxxh>0
			and a.sqdxh is not null and a.sqdxh > 0
		
		declare m_cursor_sqd cursor scroll for
		select distinct sqdxh from  #tfmx_tf_sqd
		where tysl>0

		open m_cursor_sqd
		 
		fetch next from m_cursor_sqd into @sqdxh
		while @@FETCH_STATUS=0
		begin
			if exists(select 1 from #tfmx_tf_sqd where sqdxh=@sqdxh and ypsl<>tysl and dzbz=1)
			begin
				select 'F','打折项目不可部分退费!'
				close m_cursor_sqd
				deallocate m_cursor_sqd
				return
			end
			select * from SF_HJCFMXSFK a(nolock) ,#tfmx_tf_sqd b
				where a.patid=@patid and a.sqdxh=@sqdxh and a.cfxh=b.hjxh and a.cfmxxh=b.hjmxxh and a.sqdxh=b.sqdxh
					and b.ypsl<>b.tysl and b.dzbz=0
					
			if exists(select 1 from SF_HJCFMXSFK a(nolock) ,#tfmx_tf_sqd b
				where a.patid=@patid and a.sqdxh=@sqdxh and a.cfxh=b.hjxh and a.cfmxxh=b.hjmxxh and a.sqdxh=b.sqdxh
					and b.ypsl<>b.tysl and b.dzbz=0)
			begin
				select 'F','临床项目内部不可部分退费!'
				close m_cursor_sqd
				deallocate m_cursor_sqd
				return
			end
			fetch next from m_cursor_sqd into @sqdxh
		end
		 
		close m_cursor_sqd
		deallocate m_cursor_sqd
		
		drop table #tfmx_tf_sqd
	end
	--更新一下新处方中的dydm
	update a set dydm=b.dydm
	from #cfmx_old a,YY_SFXXMK b(nolock)
	where a.cd_idm=0 and a.ypdm=b.id	
	if @@error<>0
	begin
	    select 'F','更新处方明细对应代码出错!'
	    return
	end
	update a set dydm=b.dydm
	from #cfmx_old a,YK_YPCDMLK b(nolock)
	where a.cd_idm>0 and a.cd_idm=b.idm	
	if @@error<>0
	begin
	    select 'F','更新处方明细对应代码出错!'
	    return
	end
	select * into #cfmx_old_fz from SF_CFMXK_FZ where cfxh in (select xh from #mzcf_old) --add by wangmiao
	select * into #mzcf_old_fz from VW_MZCFK_FZ where jssjh=@sjh
	if @@error<>0--update by winning-dingsong-chongqing with @@rowcount>>@@error
	begin
	    select 'F','查询处方库辅助表出错!'
	    return
	end
	select distinct cfxh, cfts into #mzcf_tf from #cfmx_tf
	--得到退费后剩下的处方和明细
	select * into #mzcf_new from #mzcf_old
	select * into #cfmx_new from #cfmx_old
	select * into #cfmx_new_fz from #cfmx_old_fz -- add by wangmiao
	if exists(select 1 from YY_CONFIG where id='3115' and config='是')
	begin
		update #cfmx_new set cfts=a.cfts-(case when a.cfts>1 and a.ypsl=b.tysl*a.dwxs then b.cfts when a.cfts>1 and a.ypsl<>b.tysl*a.dwxs then 0 else 0 end),
				ypsl=a.ypsl-(case when a.cfts>1 and a.ypsl=b.tysl*a.dwxs then 0 when a.cfts>1 and a.ypsl<>b.tysl*dwxs then b.tysl*a.dwxs  else b.tysl*a.dwxs end),
				ktsl=case when a.ktsl>0 then 
					 a.ktsl-(case when a.cfts>1 and a.ypsl=b.tysl*a.dwxs then 0 when a.cfts>1 and a.ypsl<>b.tysl*dwxs then b.tysl*a.dwxs  else b.tysl*a.dwxs end)
					 else 0 end
		from #cfmx_new a, #cfmx_tf b
		where a.xh=b.mxxh
		if @@error<>0
		begin
			select "F","查询退费处方明细出错！"
			return
		end
	end
	else begin
		update #cfmx_new set cfts=a.cfts-(case when a.cfts>1 then b.cfts else 0 end),
			ypsl=a.ypsl-(case when a.cfts>1 then 0 else b.tysl*a.dwxs end),
			ktsl=case when a.ktsl>0 then 
					 a.ktsl-(case when a.cfts>1 and a.ypsl=b.tysl*a.dwxs then 0 when a.cfts>1 and a.ypsl<>b.tysl*dwxs then b.tysl*a.dwxs  else b.tysl*a.dwxs end)
					 else 0 end
		from #cfmx_new a, #cfmx_tf b
		where a.xh=b.mxxh
		if @@error<>0
		begin
			select "F","查询退费处方明细出错！"
			return
		end
	end

	update b set b.cfts = a.cfts from #cfmx_new a,#mzcf_new b where a.cfxh = b.xh

	delete #cfmx_new_fz where cfxh in (select cfxh from #cfmx_new where cfts=0 or ypsl=0) -- add by wangmiao
	delete #cfmx_new where cfts=0 or ypsl=0
	delete #mzcf_new where not exists(select 1 from #cfmx_new b where #mzcf_new.xh=b.cfxh)
	--判断未退数量是否存在小于0的情况（退数量大于原数量时）
	if exists(select 1 from #cfmx_new where ypsl<0)
	begin
		select 'F','传入退费数量不正确，退数量不能大于原数量!'
	    return
	end
	--如果外送的处方,不允许做部分退费
	if @config3291='是' and exists (select 1 from #cfmx_old where isnull(wsbz,0)=1)
	begin
	    if exists (select 1 from #cfmx_old a,#mzcf_new b where a.xh=b.xh and isnull(a.wsbz,0)=1)
	    begin
	        select 'F','退费处方中有外送药品,不能部分退费!'
	        return
	    end
	end

	--控制医技材料费不能退费的明细
	if exists(select 1 from YY_CONFIG where id='2291' and config='是') --只有接口模式时控制
		and exists(select 1 from SF_CFMXK_FZ a(nolock),#cfmx_tf b where a.mxxh=b.mxxh and a.yjclfbz=1)
	begin
		--并且有未退的主项目
		if exists(select 1 from SF_CFMXK_FZ a(nolock),#cfmx_new b where a.mxxh=b.xh and yjclfbz=0 and b.cd_idm=0)
		begin
			select @errmsg=''
			select @errmsg=@errmsg+c.ypmc+',' from SF_CFMXK_FZ a(nolock),#cfmx_tf b,#cfmx_old c 
				where a.mxxh=b.mxxh and yjclfbz=1 and a.mxxh=c.xh and c.cd_idm=0
			select 'F','医技材料费['+@errmsg+']不能退费'
			return
		end
	end
	--通过参数控制未进行退费审批的项目不能退费
	if	exists(select 1 from YY_CONFIG where id='2356' and config='是')	
	begin
		if exists(select 1 from VW_MZCFMXK_FZ a(nolock),#cfmx_tf b where a.mxxh=b.mxxh and isnull(a.tfspbz,0)=0)
		begin
			select @errmsg=''
			select @errmsg=@errmsg+c.ypmc+',' from VW_MZCFMXK_FZ a(nolock),#cfmx_tf b,#cfmx_old c 
				where a.mxxh=b.mxxh and isnull(a.tfspbz,0)=0 and a.mxxh=c.xh
			select 'F','['+@errmsg+']未进行审批，不能退费'
			return
		end
	end
	
	--通过参数控制医技预约项目是否允许退费
	if	exists(select 1 from YY_CONFIG where id='2462' and config='否')	
	begin
		if exists(select 1 from VW_MZCFMXK a(nolock),#cfmx_tf b where a.xh=b.mxxh and isnull(a.yyzt,0)=1)
		begin
			select @errmsg=''
			select @errmsg=@errmsg+c.ypmc+',' from VW_MZCFMXK a(nolock),#cfmx_tf b,#cfmx_old c 
				where a.xh=b.mxxh and isnull(a.yyzt,0)=1 and a.xh=c.xh
			select 'F','已经预约的医技项目['+@errmsg+']不能退费,请取消预约再退费'
			return
		end
	end
	------------------------------- 
	--置退费标志 qxh 2003.5.27
	if @acfdfp=1 
	begin
		--jjw 2003-12-22 modify bug:一个处方中如果某个药只退一部分则可以打印出来如果全退了这个药这个处方就不会打了
		--update #mzcf_new set tfbz=1 where xh in (select cfxh from #cfmx_new a  where xh in (select mxxh from  #cfmx_tf where mxxh=a.xh and tysl>0))
--		update #mzcf_new set tfbz=1 where xh in 
--		(select cfxh from #cfmx_new a  where xh in (select mxxh from  #cfmx_tf where cfxh=a.cfxh and tysl>0))
		--by ydj 2004-11-04
		update #mzcf_new set tfbz=1 where xh  in (select cfxh from #cfmx_tf)
		--西药处方合并时，只有未退费的处方，都需要从新打印
		--将相同发票好的处方都同时置上退费标志
		if (@acfdfp_dyfs<>'0')
		begin
			select a.fph,b.xh,0 as tfbz into #mzcf_new_temp from SF_MZCFK a,#mzcf_new b where a.xh=b.xh
			select a.fph,b.cfxh into #cfmx_tf_temp from SF_MZCFK a,#cfmx_tf b where a.xh=b.cfxh
			update #mzcf_new_temp set tfbz=1 where fph in (select fph from #cfmx_tf_temp)
			update a set a.tfbz=b.tfbz from #mzcf_new a,#mzcf_new_temp b where a.xh=b.xh
		end 
		/*
		if (@acfdfp_cflx=1) 
			and exists(select 1 from #mzcf_new where cflx=1)	--存在未退的西药处方 
			and exists(select 1 from #mzcf_tf a,#mzcf_old b where a.cfxh=b.xh and b.cflx=1)	--存在已退的西药处方
		begin
			update #mzcf_new set tfbz=1 where cflx=1
		end
		*/
	end

	--如果什么都没剩下，说明是全部退费,此时#cfmx_new，#mzcf_new 剩下需要重新收取的的处方明细
	if not exists(select 1 from #mzcf_new)
		select @qtbz=1
	else
		select @qtbz=0
	
	if @qtbz=0
	begin
		if exists(select 1 from #cfmx_new where isnull(lcxmdm,'0')<>'0')
		begin		
			update #cfmx_new set lcxmsl=a.ypsl/b.xmsl
				from #cfmx_new a,YY_LCSFXMDYK b
				where a.lcxmdm=b.lcxmdm and a.ypdm=b.xmdm
			--重算临床项目数量,bug54034
			update a set a.lcxmsl=a.ypsl/(b.ypsl/b.lcxmsl) 
			from #cfmx_new a,#cfmx_old b 
			where a.xh=b.xh and isnull(a.lcxmdm,'0')<>'0' and isnull(b.lcxmdm,'0')<>'0' and b.ypsl/b.lcxmsl>0 
		end
	end
	   
--cjt
	------诊疗方案退费不允许部分退费  先判断新生成的里面有没有，在判断退费里面有没有
	if   exists(select 1 from #cfmx_new a ,VW_MZHJCFMXK b(nolock) where a.hjmxxh=b.xh and b.sjzlfabdxh<>0) 
	begin
		if 	exists(select 1 from #cfmx_tf a ,VW_MZCFMXK b(nolock) ,VW_MZHJCFMXK c(nolock) where a.mxxh=b.xh and b.hjmxxh=c.xh and c.sjzlfabdxh<>0)
		begin
			
			declare @zlfamxmc_tmp varchar(80),@zlfamxmc varchar(8000)  
			select @zlfamxmc='',@zlfamxmc_tmp=''
			--将所有的诊疗方案明细显示给前台
			declare cs_sftf_zlfa cursor for
			select ypmc from VW_MZHJCFMXK (nolock) where cfxh in (select hjxh from #mzcf_old) and sjzlfabdxh<>0
			for read only 
			open cs_sftf_zlfa
			fetch cs_sftf_zlfa into @zlfamxmc_tmp
			while @@fetch_status=0
			begin 
				if @zlfamxmc='' 
				begin
					select @zlfamxmc=@zlfamxmc_tmp  
				end
				else
				begin
					select @zlfamxmc=@zlfamxmc+':' +@zlfamxmc_tmp  
				end
				fetch cs_sftf_zlfa into @zlfamxmc_tmp
			end
			close cs_sftf_zlfa
			deallocate cs_sftf_zlfa


			select  "F", '处方中包含【'+@zlfamxmc+'】诊疗方案明细必须全退，诊疗方案明细不允许部分退费！'  
			return
		end
	end 
----------------- 

	select sjh, patid, ghsjh, ghxh, fph, fpjxh, czyh, sfrq, sfksdm, ksdm, hzxm, blh, ybdm, pzh, 
		sfzh, ylxm, zddm, dnzhye, lnzhye, dwbm, brlx, zje, zfyje, yhje, deje, zfje, zpje, zph, 
		xjje, srje, qkbz, qkje, zxlsh, jslsh, ybjszt, zhbz, tsjh, jlzt, cardno, cardtype, ghsfbz, 
		mjzbz, jcxh, memo 
		,ylkje,ylkysje	--mit ,, 2oo3-o5-14 ,, 银医通
		,flzfje			--zwj 2003.08.19 分类自费金额
		,qrbz,qrczyh,qrrq,tcljje,tcljbz,0 ljje,yflsh,tsyhje,spzlx
		,gbje, gbbz, gbtsbz,gbfwwje,bdyhkje,bdyhklsh,lcyhje,hzdybz
		,yhdm,appjkdm,syldyhbz,syldyhje --add by yjn 2015-03-21
		into #brjsk from SF_BRJSK where 1=2
	if @tslc = 0
	begin
		insert into #brjsk 
		select a.sjh, a.patid, a.ghsjh, a.ghxh, a.fph, a.fpjxh, a.czyh, a.sfrq, a.sfksdm, a.ksdm, a.hzxm, a.blh, a.ybdm, a.pzh, 
			a.sfzh, a.ylxm, a.zddm, a.dnzhye, a.lnzhye, a.dwbm, a.brlx, a.zje, a.zfyje, a.yhje, a.deje, a.zfje, a.zpje, a.zph, 
			a.xjje, a.srje, a.qkbz, a.qkje, a.zxlsh, a.jslsh, a.ybjszt, a.zhbz, a.tsjh, a.jlzt, b.cardno, b.cardtype, a.ghsfbz, 
			a.mjzbz, a.jcxh, a.memo 
			,a.ylkje,a.ylkysje	--mit ,, 2oo3-o5-14 ,, 银医通
			,a.flzfje,a.qrbz,a.qrczyh,a.qrrq,a.tcljje,a.tcljbz,b.ljje,a.yflsh,tsyhje,b.spzlx
			,gbje, gbbz, gbtsbz,gbfwwje,bdyhkje,bdyhklsh,a.lcyhje,a.hzdybz
			,a.yhdm,a.appjkdm,syldyhbz,syldyhje --add by yjn 2015-03-21
			from VW_MZBRJSK a (nolock),SF_BRXXK b (nolock) where a.sjh=@sjh and a.patid=b.patid
		if @@error<>0 or @@rowcount=0
		begin
			select "F","门诊结算库记录不存在！"
			return
		end
	end
	else
	begin
		insert into #brjsk 
		select a.sjh, a.patid, a.ghsjh, a.ghxh, a.fph, a.fpjxh, a.czyh, a.sfrq, a.sfksdm, a.ksdm, a.hzxm, a.blh, a.ybdm, a.pzh, 
			a.sfzh, a.ylxm, a.zddm, a.dnzhye, a.lnzhye, a.dwbm, a.brlx, a.zje, a.zfyje, a.yhje, a.deje, a.zfje-a.srje, a.zpje, a.zph, 
			a.xjje-a.srje+a.qkje,0, 0, 0, a.zxlsh, a.jslsh, a.ybjszt, a.zhbz, a.tsjh, a.jlzt, b.cardno, b.cardtype, a.ghsfbz, 
			a.mjzbz, a.jcxh, a.memo 
			,a.ylkje,a.ylkysje	--mit ,, 2oo3-o5-14 ,, 银医通
			,a.flzfje,a.qrbz,a.qrczyh,a.qrrq,a.tcljje,a.tcljbz,b.ljje,a.yflsh,tsyhje,b.spzlx
			,gbje, gbbz, gbtsbz,gbfwwje,bdyhkje,bdyhklsh,a.lcyhje,a.hzdybz
			,a.yhdm,a.appjkdm,syldyhbz,syldyhje --add by yjn 2015-03-21
			from VW_MZBRJSK a (nolock),SF_BRXXK b (nolock) where a.sjh=@sjh and a.patid=b.patid
		if @@error<>0 or @@rowcount=0
		begin
			select "F","门诊结算库记录不存在！"
			return
		end
		select @qkje_ts = xjje from #brjsk
		select @srbz=config from YY_CONFIG (nolock) where id='2016'
		if @@error<>0 or @@rowcount=0
			select @srbz='0'
		--需要舍入处理liuchun，bug6369
		/*小数舍入处理 begin*/
		if @srbz='5'
			select @qkje_ts1=round(@qkje_ts, 1)
		else if @srbz='6'
			exec usp_yy_wslr @qkje_ts,1,@qkje_ts1 output
		else if @srbz>='1' and @srbz<='9'
			exec usp_yy_wslr @qkje_ts,1,@qkje_ts1 output,@srbz
		else
			select @qkje_ts1=@qkje_ts

		select @srje=@qkje_ts1-@qkje_ts
		/*小数舍入处理 begin*/
		update #brjsk set xjje = @qkje_ts1,srje = @srje,zfje = zfje + @srje
	end
	
	-----add by sqf 20090602 begin	一张发票是否允许部分退费
	if  @isbftfall=1 and exists(select 1 from #brjsk where sjh=@sjh and isnull(fph,0)<>0)---不允许部分退
	begin 
		if @acfdfp=1 and @configdyms=0 --如果是按处方打印的，则每一张处方就是一张发票，用cfxh来校验是否是全退
		begin
			select cfxh,sum(1) cfsl  into #temp_cfmxnew1 from #cfmx_new group by cfxh      
			select cfxh,sum(1) cfsl  into #temp_cfmxold1 from #cfmx_old where cfxh in (select cfxh from #cfmx_new) group by cfxh      

			select cfxh,xh,ypsl into #temp_cfmxnew from #cfmx_new       
			select cfxh,xh ,ypsl into #temp_cfmxold from #cfmx_old 
			where cfxh in (select cfxh from #cfmx_new)       

			if not  exists (select 1 from #temp_cfmxnew a,#temp_cfmxold b where a.cfxh=b.cfxh and a.xh=b.xh and a.ypsl<>b.ypsl)      
			and  not exists (select 1 from #temp_cfmxnew1 a,#temp_cfmxold1 b where a.cfxh=b.cfxh and a.cfsl<>b.cfsl )      
				select @qtbz_cf=1          
			else          
				select @qtbz_cf=0       

			if @qtbz_cf=0     
			begin    
				select 'F','不允许部分退费，请重新输入数量退费'    
				return    
			end 
		end
		else---不按处方，则整张收据就是一张发票号，只要需要判断是不是全退就可以了
		begin
			--老发票模式时
			if @configdyms=0
			begin
				if not exists(select 1 from #mzcf_new)
					select @qtbz=1
				else
					select @qtbz=0    
				       
				if @qtbz=0     
				begin    
					select 'F','不允许部分退费，请重新输入数量退费'    
					return    
				end                    
			end
			else if @configdyms=1  --新发票模式
			begin
				--看剩余的处方明细里面发票金额是否一致
				select fpzh,sum(round(ylsj*ypsl*ts*cfts/ykxs,2)) as zje into #temp_fpzh from #cfmx_new group by fpzh
				if exists(select 1 from VW_SFFPMXDYK a,#temp_fpzh b where a.jssjh=@sjh and a.zh=b.fpzh and round(a.zje,2)<>b.zje)
				begin
					select 'F','同一张发票不允许部分退费，请重新输入数量退费'    
					return 
				end
			end
		end
			
	end  
		
	select @ylkysje = ylkysje, @posfph=zph, @patid = patid,@ybdm=ybdm, @qkbz=qkbz, @qkje1=qkje, @tcljje=ljje-(zje-zfyje),
	  @tcljje1=ljje-(zje-zfyje),@tcljbz=tcljbz,@sfrq=sfrq,@bdyhkje = bdyhkje,@xjje=xjje,@qrbz=qrbz,
	  @qrbznew=case qrbz when 1 then 1 else 0 end,
	  @zpje=zpje,@zph=zph
	from #brjsk	-- modify by gzy in 20050501
	--如果是帮困，重新提取账户支付
	if @qkbz = 1 
		select @qkje1 = isnull(je,0) from SF_JEMXK where jssjh = @sjh and lx = '01'
	--如果是后付费模式时，如果还未缴费的记录，不允许退费 by xxl 2012-05-06
	if exists(select 1 from YY_CONFIG where id='H233' and charindex(','+rtrim(ltrim(@ybdm))+',',','+config+',')>0)
	begin
		if (@xjje>0) and (@qrbz in(1,3))
		begin
			select "F","后付费模式时，当前结算记录还未缴费，不允许退费！"
			return
		end
	end
    --优化流程模式下同时使用就诊卡和代币卡时不支持部分退费
    if (@qkbz=3) and exists(select 1 from SF_CARDZFJEK where jssjh=@sjh and lx='4') and (@qtbz=0)
    begin
    	select "F","同时使用就诊卡和代币卡时不支持部分退费,请全退后重新收取未退费部分！"
		return
    end
	--已挂失不能退费
	if (@qkbz=3) and (@qkje1>0) and exists(select 1 from YY_JZBRK where patid=@patid and jlzt=0 and gsbz=1)
	begin
    	select "F","充值卡已挂失,不能退费！"
		return
	end
	select @zfbz=zfbz, @pzlx=pzlx, @jsfs=jsfs, @hysybz=hysybz from YY_YBFLK where ybdm=@ybdm
	if @@rowcount=0 or @@error<>0
	begin
		select "F","患者费用类别不正确！"
		return
	end

	select @hykmsbz = config from YY_CONFIG where id='0099'
	if @@error<>0
	begin
		select "F","门诊会员卡模式设置不正确！"
		return
	end
/*
	if @hykmsbz=1
	begin
		if @hysybz=1 and @qtbz=0
		begin
			select "F","会员卡模式下只能全退！"
			return
		end
	end
*/
	if exists(select ybdm from YY_YBFLK nolock where ybdm = @ybdm and lcyhbz = 1)
		select @yplcjs2169 = '是'
	else 
		select @yplcjs2169 = '否'
	--生成收据号
	exec usp_yy_createsjh 'SF_BRJSK','sjh','czyh',@czyh,@errmsg output
	if @errmsg like 'F%'
	begin
		select "F",substring(@errmsg,2,49)
		return
	end
	else
		select @newsjh=rtrim(substring(@errmsg,2,32))

	if exists(select 1 from SF_BRJSK where tsjh=@sjh and ybjszt=2)
		select @tfbz=1
	else begin
		select @newsjh1=@newsjh
		exec usp_yy_getnextsjh @newsjh1, @newsjh output
	end

	--add by zyh 20100223
	if exists(select * from YY_CONFIG where id='2181' and config='是') and @postffs>0 and @zph='7'
	begin
		select @ntfts=datediff(day,left(sfrq,8),left(@now,8)) from #brjsk

		if @postffs=1
			select @zffs=1
		if @postffs=2
			select @zffs=0
		if @postffs=3 and @ntfts=0
			select @zffs=1
		if @postffs=3 and @ntfts>0
			select @zffs=0
	    if @postffs=4  --根据sjh号操作人员日账单库中查询该结算记录是否已经结账,来决定采用哪种退费方式.
	    begin
	        select @yczyh=czyh,@ysfrq=sfrq from SF_BRJSK(nolock) where sjh=@sjh  --查出退费这条记录的操作员号和收费日期
	        --查出这个操作员的最大结账日期  
	        if exists( select 1 from SF_CZRYRZD(nolock) where czyh=@yczyh and jzbz>=1)
	        begin
	            select top 1 @zdgrjzsj=grjzsj from SF_CZRYRZD(nolock) where czyh=@yczyh and jzbz>=1 order by xh desc 	            
	            if @ysfrq>@zdgrjzsj 
	                select @zffs=1 
	            else 
	                select @zffs=0  --收费日期大于最大结账日期表示没有结账,按pos机退费 反之表示结账 按pos机现金退费
            end
            else  
	            select @zffs=1  --该操作员一直没有结账 按pos机退费
	    end 			
	end
  
	--全退不处理
	if @qtbz=0
	begin
		--{TODO -oyfq -c2016-12 : 医保高价药政策改造 as @#$ begin}
		--执行高价药政策
		if @config2451='是' and dbo.fun_judgeybdm4gjy(0,@ybdm,@xmlb,@zhbz)='TF'
		begin
		    /**
			if exists (select 1 from sysobjects(nolock) where id=object_id('YB_SH_YBDYK'))
			begin
				update a set dydm=b.dydm 
				from #cfmx_new a,YB_SH_YBDYK b(nolock)
				where a.cd_idm=0 and a.ypdm=b.xmdm and b.jlzt=1 and @now between b.qyrq+'00:00:00' and b.yxqx+'23:59:59'
				update a set dydm=b.dydm 
				from #cfmx_new a,YB_SH_YBDYK b(nolock)
				where a.cd_idm>0 and a.cd_idm=b.idm and b.jlzt=1 and @now between b.qyrq+'00:00:00' and b.yxqx+'23:59:59'
			end
			**/
			update a set gjybz=1,gjydeje=isnull(b.zfdeje,0)
			from #cfmx_new a,YY_YBYPK b(nolock)
			where a.dydm=b.mc_code and isnull(b.tsbz,0)<>0 and @now between b.ksrq+'00:00:00' and b.jzrq+'23:59:59'
			--有高价药,单独计算高价药自负金额
			if exists (select 1 from #cfmx_new where gjybz=1)
			begin
				select @gjybz=1
				select @gjyzje=isnull(sum(round(ypsl*ylsj*cfts/ykxs,2)),0),
					@gjyzfje=isnull(sum(round(ypsl*gjydeje*cfts/ykxs,2)),0)
				from #cfmx_new where cd_idm>0 and gjybz=1
				select @gjyzje1=isnull(sum(round(ypsl*ylsj*cfts/ykxs,2)),0),
					@gjyzfje1=isnull(sum(round(ypsl*gjydeje*cfts/ykxs,2)),0)
				from #cfmx_new where cd_idm=0 and gjybz=1
			end
			else
				select @gjybz=0
		end
		--{TODO -oyfq -c2016-12 : 医保高价药政策改造 as @#$ end}
		--统筹金额独立配置的医保代码
		if exists(select 1 from YY_CONFIG (nolock) where charindex('"'+rtrim(@ybdm)+'"',config)>0 and id='0115')
		begin
			select @tcljje1=tcljje from YY_BRLJXXK nolock where mzpatid = @patid
		end		

	    --add by qxh 2003.5.27 
		if @acfdfp=1 
		begin
			--计算收费费用
			select @zje=isnull(sum(round(ypsl*ylsj*cfts/ykxs,2)),0),
				@zfyje=isnull(sum(round(ypsl*zfdj*cfts/ykxs,2)),0),
				@yhje=isnull(sum(round(ypsl*yhdj*cfts/ykxs,2)),0)
				--from #cfmx_old where cd_idm>0 jjw 2004-01-06 modify 更新有退费记录的新处方
				from #cfmx_new where cd_idm>0 
                and cfxh in (select distinct cfxh from #cfmx_tf) --jjw 2004-01-06 modify 更新有退费记录的新处方才参与重新计算
			if isnull(@yplcjs2169,'') = '是'
			begin
				select 	@zje=isnull(sum(round(ypsl*ylsj*cfts/ykxs,2)),0),
						@zfyje=isnull(sum(round(ypsl*zfdj*cfts/ykxs,2)),0),
						@yhje= isnull(sum(case when lcjsdj <>0 and yhdj = ylsj - lcjsdj then round(ypsl*ylsj*cfts/ykxs,2) - round(ypsl*lcjsdj*cfts/ykxs,2)
								else round(ypsl*yhdj*cfts/ykxs,2) end),0),
						@lcyhje = isnull(sum( case when lcjsdj <>0  then round(ypsl*ylsj*cfts/ykxs,2) - round(ypsl*lcjsdj*cfts/ykxs,2) else 0 end ),0)
					from #cfmx_new where cd_idm>0
	                and cfxh in (select distinct cfxh from #cfmx_tf) 
			end
			select @zje1=isnull(sum(round(ypsl*ylsj*cfts/ykxs,2)),0),
				@zfyje1=isnull(sum(round(ypsl*zfdj*cfts/ykxs,2)),0),
				@yhje1=isnull(sum(round(ypsl*yhdj*cfts/ykxs,2)),0)
				--from #cfmx_old where cd_idm=0 jjw 2004-01-06 modify
				from #cfmx_new where cd_idm=0
                and cfxh in (select distinct cfxh from #cfmx_tf) --jjw 2004-01-06 modify 更新有退费记录的新处方才参与重新计算
	        if @gjybz=1  --@#$
			    select @ybje=@zje-@zfyje-@yhje-@gjyzje,@ybje1=@zje1-@zfyje1-@yhje1-@gjyzje1
			else
			select @ybje=@zje-@zfyje-@yhje, @ybje1=@zje1-@zfyje1-@yhje1
	
			--取得实收金额
			if @pzlx not in (10,11)
			begin
				--药品金额计算
				execute usp_yy_ybjs @ybdm,0,@ybje,0,@errmsg output
				if @errmsg like "F%"
				begin
					select "F",substring(@errmsg,2,49)
					return
				end
				else
					select @sfje=convert(numeric(10,2),substring(@errmsg,2,11))
	
				execute usp_yy_ybjs @ybdm,0,0,@ybje1,@errmsg output
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
				begin	
					select @xmzfbltf=(@sfje+@zfyje)/@ybje
					select @xmzfbl=@sfje/@ybje
				end
	
				if @ybje1>0
				begin
					select @xmzfbltf1=(@sfje1+@zfyje1)/@ybje1
					select @xmzfbl1=@sfje1/@ybje1
				end
	
				select @sfje_all=@sfje+@sfje1+@zfyje+@zfyje1
				select @srbz=config from YY_CONFIG (nolock) where id='2016'
				if @@error<>0 or @@rowcount=0
					select @srbz='0'
				if @srfs = '1' and @qkbz in(3)---，1：精确到角
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
	
				/*
				if @qkbz in(1,3)
				begin
					if @qkje1>@sfje2
						select @qkje=@sfje2
					else
						select @qkje=@qkje1
	
					select @qkje1=@qkje1-@qkje
				end
				else if @qkbz=2
					select @qkje=@sfje2
				*/
			end

			/*jjw 2003-01-06 modify
			update 	#mzcf_old  set  tfje=b.tfje 
				from    #mzcf_old a ,(select c.cfxh, 
		   	        isnull(round(sum(round((c.ylsj-c.zfdj-c.yhdj)*d.tysl*c.dwxs*d.cfts*(case when c.cd_idm>0 then @xmzfbltf else @xmzfbltf1 end)/c.ykxs,2)),2),0) as tfje
	        		from  #cfmx_old c,#cfmx_tf d where c.xh=d.mxxh group by c.cfxh ) b
				where a.xh=b.cfxh  
			*/
		end	

		if charindex('"'+@ybdm+'",',@bkybdmjh)>0
			update #cfmx_new set flzfdj=0

		--计算收费费用
		select @zje=isnull(sum(round(ypsl*ylsj*cfts/ykxs,2)),0),
			@zfyje=isnull(sum(round(ypsl*zfdj*cfts/ykxs,2)),0),
			@yhje=isnull(sum(round(ypsl*yhdj*cfts/ykxs,2)),0),
			@flzfje=isnull(sum(round(ypsl*flzfdj*cfts/ykxs,2)),0)
			from #cfmx_new where cd_idm>0
		if isnull(@yplcjs2169,'') = '是'
		begin
			select 	@zje=isnull(sum(round(ypsl*ylsj*cfts/ykxs,2)),0),
					@zfyje=isnull(sum(round(ypsl*zfdj*cfts/ykxs,2)),0),
					@yhje= isnull(sum(case when lcjsdj <>0 and yhdj = ylsj - lcjsdj then round(ypsl*ylsj*cfts/ykxs,2) - round(ypsl*lcjsdj*cfts/ykxs,2)
							else round(ypsl*yhdj*cfts/ykxs,2) end),0),
					@lcyhje = isnull(sum( case when lcjsdj <>0  then round(ypsl*ylsj*cfts/ykxs,2) - round(ypsl*lcjsdj*cfts/ykxs,2) else 0 end ),0)
				from #cfmx_new where cd_idm>0
		end
		select @zje1=isnull(sum(round(ypsl*ylsj*cfts/ykxs,2)),0),
			@zfyje1=isnull(sum(round(ypsl*zfdj*cfts/ykxs,2)),0),
			@yhje1=isnull(sum(round(ypsl*yhdj*cfts/ykxs,2)),0),
			@flzfje1=isnull(sum(round(ypsl*flzfdj*cfts/ykxs,2)),0)
			from #cfmx_new where cd_idm=0
        if @gjybz=1  --@#$
            select @ybje=@zje-@zfyje-@yhje-@gjyzje,@ybje1=@zje1-@zfyje1-@yhje1-@gjyzje1
        else
		select @ybje=@zje-@zfyje-@yhje, @ybje1=@zje1-@zfyje1-@yhje1

   		 --add by qxh 2003.5.29
		if @acfdfp=1 
			update 	#mzcf_new  set  zje=b.zje,zfyje=b.zfyje,yhje=b.yhje 
		       	from  #mzcf_new a , (select cfxh,isnull(round(sum(round(ypsl*ylsj*cfts/ykxs,2)),2),0) as zje ,
		            isnull(round(sum(round(ypsl*zfdj*cfts/ykxs,2)),2),0) as zfyje,
                    isnull(round(sum(round(ypsl*yhdj*cfts/ykxs,2)),2),0) as yhje  
                from  #cfmx_new group by cfxh ) b  where a.xh=b.cfxh  

		--取得实收金额
		select @sfje_all=@sfje+@sfje1+@zfyje+@zfyje1
			select @srbz=config from YY_CONFIG (nolock) where id='2016'
			if @@error<>0 or @@rowcount=0
				select @srbz='0'
		select @sfje2=@sfje_all

		if @pzlx not in (10,11)
		begin
			--tony 2003.12.8 小城镇医保修改
			if @tcljbz=1
			begin
				select @ybje=@ybje+@ybje1,@ybje1=0,@sfje=0,@sfje1=0
	
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
			else begin
				--药品金额计算
				execute usp_yy_ybjs @ybdm,0,@ybje,0,@errmsg output
				if @errmsg like "F%"
				begin
					select "F",substring(@errmsg,2,49)
					return
				end
				else
					select @sfje=convert(numeric(10,2),substring(@errmsg,2,11))
	
				execute usp_yy_ybjs @ybdm,0,0,@ybje1,@errmsg output
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
			if @srfs = '1' and @qkbz in(3)---，1：精确到角
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
			
			if @qkbz in(1)
			begin
				--自费费用自己负担(帮困开始)
				if exists(select 1 from YY_CONFIG (nolock) where charindex('"'+rtrim(@ybdm)+'"',config)>0 and id='0053')
				begin
					if @qkje1>@sfje2-@zfyje-@zfyje1+@flzfje+@flzfje1
						select @qkje=round(@sfje2-@zfyje-@zfyje1+@flzfje+@flzfje1,1),
								@qkje2 = @sfje_all-@zfyje-@zfyje1+@flzfje+@flzfje1
					else
						select @qkje=round(@qkje1,1),@qkje2 =@qkje1
				end
				else
				begin
					if @qkje1>@sfje2
						select @qkje=round(@sfje2,1),@qkje2 =@sfje_all
					else
						select @qkje=round(@qkje1,1),@qkje2 =@qkje1
				end

				insert into SF_JEMXK(jssjh, lx, mc, je, memo)
				values(@newsjh, '01', '起付段当年账户支付',@qkje2 , null)
				if @@error<>0
				begin
					select "F","保存结算01信息出错！"
					rollback tran
					return
				end
				
				/*
				select @sfje_bkall = @sfje_all - @qkje2,@qkje = 0
				--小数舍入处理
				if @srbz='5'
					select @sfje2=round(@sfje_bkall, 1)
				else if @srbz='6'
					exec usp_yy_wslr @sfje_bkall,1,@sfje2 output 
				else if @srbz>='1' and @srbz<='9'
					exec usp_yy_wslr @sfje_bkall,1,@sfje2 output,@srbz
				else
					select @sfje2=@sfje_bkall

				select @srje = @sfje2 - (@sfje_all - @qkje2)
				if @ybje>0
					select @xmzfbl=(@ybje - @qkje2)/@ybje
				select @sfje = @ybje - @qkje2
				*/
				--帮困结束
			end
			else 
			begin
				if @qkbz=2
					select @qkje=@sfje2
				if @qkbz=3
				begin
					if @qkje1>@sfje2
						select @qkje=@sfje2
					else
					begin
						select @qkje=@qkje1	
						if @srfs = '1'---1：精确到角则先舍入20110426sqf
						begin
							select @qkje=round(@qkje1, 1,1) ---去掉小数位
						end 						
					end				
				end
				if @qkbz=4	--代币卡
				begin
					if @qkje1>@sfje2
						select @qkje=@sfje2
					else
						select @qkje=@qkje1					
				end
			end	
		end

		--处理大项汇总金额
		select dxmdm, round(ylsj*ypsl*cfts/ykxs,2) as xmje, 
			round((ylsj-zfdj-yhdj)*ypsl,2) as zfje,
			round(zfdj*ypsl*cfts/ykxs,2) as zfyje, 
			round(yhdj*ypsl*cfts/ykxs,2) as yhje,
			round(flzfdj*ypsl*cfts/ykxs,2) as flzfje,
			round(flzfdj*ypsl*cfts/ykxs,2) as lcyhje
			into #sfmx1
			from #cfmx_new where 1=2 

		if isnull(@yplcjs2169,'') = '是'
			insert into #sfmx1(dxmdm, xmje,zfje,zfyje,yhje,flzfje,lcyhje)
			select dxmdm, sum(round(ylsj*ypsl*cfts/ykxs,2)) as xmje, 
				sum(round((ylsj-zfdj-yhdj)*ypsl*cfts*(case when cd_idm>0 then @xmzfbl else @xmzfbl1 end)/ykxs,2)) as zfje,
				sum(round(zfdj*ypsl*cfts/ykxs,2)) as zfyje, 
				sum(case when lcjsdj <>0 and yhdj = ylsj - lcjsdj then round(ylsj*ypsl*cfts/ykxs,2) - round(lcjsdj*ypsl*cfts/ykxs,2)
					     else round(yhdj*ypsl*cfts/ykxs,2) end ) as yhje,
				sum(round(flzfdj*ypsl*cfts/ykxs,2)) as flzfje,
				sum( case when lcjsdj = 0 then 0 else round(ylsj*ypsl*cfts/ykxs,2) - round(lcjsdj*ypsl*cfts/ykxs,2) end) lcyhje
				from #cfmx_new group by dxmdm		
		else
			insert 	into #sfmx1(dxmdm,xmje,zfje,zfyje,yhje,flzfje,lcyhje)
			select dxmdm, sum(round(ylsj*ypsl*cfts/ykxs,2)) as xmje, 
				sum(round((ylsj-zfdj-yhdj)*ypsl*cfts*(case when cd_idm>0 then @xmzfbl else @xmzfbl1 end)/ykxs,2)) as zfje,
				sum(round(zfdj*ypsl*cfts/ykxs,2)) as zfyje, 
				sum(round(yhdj*ypsl*cfts/ykxs,2)) as yhje,
				sum(round(flzfdj*ypsl*cfts/ykxs,2)) as flzfje,0
			from #cfmx_new group by dxmdm

		if exists (select 1 from #sfmx1)
		begin
			select @xmce=@sfje+@sfje1-sum(zfje) from #sfmx1
			update #sfmx1 set zfje=zfje+zfyje
			set rowcount 1
			update #sfmx1 set zfje=zfje+@xmce
			set rowcount 0
		end

		--jjw 2003-01-06 add 更新有退费记录的新处方的zfje
		if @acfdfp=1
			update #mzcf_new  set  zfje=b.zfje
	       	from #mzcf_new a, (select c.cfxh, isnull(round(sum(round((c.ylsj-c.zfdj-c.yhdj)*c.ypsl*c.cfts*(case when c.cd_idm>0 then @xmzfbltf else @xmzfbltf1 end)/c.ykxs,2)),2),0) as zfje
            	 from  #cfmx_new c where cfxh in (select cfxh from #cfmx_tf) group by c.cfxh) b
			where a.xh=b.cfxh
	end
	if @qkbz in (1,3,4) and @srfs = '0'
	begin
		select @sfje2=@sfje_all-@qkje
		if @srbz='5'
			select @sfje2=round(@sfje2, 1)
		else if @srbz='6'
			exec usp_yy_wslr @sfje2,1,@sfje2 output
		else if @srbz>='1' and @srbz<='9'
			exec usp_yy_wslr @sfje2,1,@sfje2 output,@srbz
		else
			select @sfje2=@sfje2
		select @sfje2=@sfje2+@qkje
		select @srje=@sfje2-@sfje_all
	end
	else if (@srfs = '0' or @srfs = '1') and @qkbz not in (1,3,4)
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
    --jjw 2004-01-06 add  
	if @acfdfp=1 
	begin
		update 	#mzcf_old  set  tfje=zfje
        update  #mzcf_old  set  tfje=a.tfje-b.zfje 
		from    #mzcf_old a ,#mzcf_new b
		where a.xh=b.xh
    end


	if @pzlx in (10,11) and @qtbz=0
	begin
		--update by zwj 2003-09-09	医保四期修改
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
		if (@pzlx = 11) and exists(select 1 from #brjsk where substring(zhbz,12,1)='0')----大病减负
		begin
		    select @xmlb=isnull(ylxm,'0') from #brjsk
			declare @msg varchar(300)
			exec usp_yy_yb_getylxm '0','0',@xmlb,@jfbz output,@msg output
			if @jfbz <>'0' and @msg <>'R'
			begin
			    if @config2395<>''
			    begin
			        select @flzfjedbxm=isnull(sum(round(ypsl*flzfdj*cfts/ykxs,2)),0)
			        from #cfmx_new
			        where cd_idm=0 and charindex('"'+rtrim(ltrim(ypdm))+'"',@config2395)>0			        
			    end
				select @ybzje=@ybje+@ybje1+@flzfje+@flzfjedbxm ---------医保交易金额包括药品的flzfje
				select @jfje= @flzfje+@flzfjedbxm
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

    if @zph='S'
  begin        
        if not exists(select 1 from YY_PAYDETAILK where zflb=1 and jssjh=@sjh and zfzt=1 and jlzt in (0,1))
           and @isxjtf_paycenter=0
        begin
            --只有部分退费才存在
            select 'F','上一次部分退费支付退款已失败，请到异常支付程序中处理失败记录，成功后即可继续退费！'
            return
        end
    end

	begin tran
	declare cs_sfbftf cursor for
	select xh from #mzcf_old
	for read only

	open cs_sfbftf
	fetch cs_sfbftf into @cfxh
	while @@fetch_status=0
	begin
		--已退费不再红冲
		if @tfbz=0
		begin
			--红冲原纪录
			insert into SF_MZCFK(jssjh, hjxh, czyh, lrrq, patid, hzxm, ybdm, py, wb, 
				ysdm, ksdm, yfdm, qrczyh, qrrq, qrksdm, pyczyh, pyrq, cfts, txh, sfckdm, 
				pyckdm, fyckdm, jsbz, jlzt, fybz, cflx, sycfbz, tscfbz, pybz, jcxh, memo, cfxh,
				zje,zfyje,yhje,zfje,srje,fph,fpjxh,tfje, sqdxh,ejygbz, ejygksdm,xzks_id,ylxzbh,tmhdbz,ghxh,gxrq,wsbz,wsts,cftszddm,cftszdmc,yscfbz)	--mod by ozb 20060320增加ejygbz, ejygksdm
			select @newsjh1, hjxh, @czyh, @now, patid, hzxm, ybdm, py, wb, 
				ysdm, ksdm, yfdm, qrczyh, qrrq, qrksdm, pyczyh, pyrq, cfts, xh, sfckdm, --退序号插入红冲的序号 , Modify By Agg , 2003.08.12
				pyckdm, fyckdm, jsbz, 9, fybz, cflx, sycfbz, tscfbz, pybz, jcxh, memo, cfxh,
				-zje,-zfyje,-yhje,-zfje,-srje,fph,fpjxh,tfje, sqdxh,isnull(ejygbz,0), isnull(ejygksdm,""),xzks_id,ylxzbh,tmhdbz--红冲记录该成负数 , Modify By Agg , 2003.08.12 --mod by ozb 20060320增加ejygbz, ejygksdm
				,ghxh,@now,isnull(wsbz,0),isnull(wsts,0),cftszddm,cftszdmc,yscfbz  --add by yfq @20120528
				from #mzcf_old where xh=@cfxh
			if @@error<>0 or @@rowcount=0
			begin
				select "F","红冲收费处方出错！"
				rollback tran
				deallocate cs_sfbftf
				return
			end

			select @xhtemp=@@identity

			insert into SF_CFMXK(cfxh, cd_idm, gg_idm, dxmdm, ypmc, ypdm, ypdw, dwxs, ykxs, ypfj, ylsj, 
				ypsl, ts, cfts, zfdj, yhdj, memo, ypgg, flzfdj, hjmxxh,
				gbfwje, gbfwwje, gbtsbz,fpzh, lcxmdm, lcxmmc,lcxmsl,dydm,yjqrbz,zbz,
				lcjsdj,yjspbz,ssbfybz,zje,tmxxh,shbz,yqrsl,ktsl,wsbz,ldcfxh,ldmxxh,tfbz) --add "dydm" 20070119 --add fpzh by ozb 20060622 增加发票组号
			select @xhtemp, cd_idm, gg_idm, dxmdm, ypmc, ypdm, ypdw, dwxs, ykxs, ypfj, ylsj, 
				-ypsl, ts, cfts, zfdj, yhdj, memo, ypgg, flzfdj, hjmxxh,
				-gbfwje, -gbfwwje, gbtsbz,fpzh, lcxmdm, lcxmmc,-lcxmsl,dydm,yjqrbz,zbz 
				,lcjsdj,yjspbz,ssbfybz,-zje,xh,shbz,-yqrsl,-ktsl,wsbz,ldcfxh,ldmxxh,tfbz--add "dydm" 20070119 --add fpzh by ozb 20060622 增加发票组号
				from #cfmx_old where cfxh=@cfxh
			if @@error<>0
			begin
				select "F","红冲收费处方明细出错！"
				rollback tran
				deallocate cs_sfbftf
				return		
			end
			--插入辅助表
			insert into SF_MZCFK_FZ(jssjh,hjxh,cfxh,patid,ccfbz)
			select @newsjh1,hjxh,@xhtemp,@patid,ccfbz
			from #mzcf_old_fz where cfxh=@cfxh
			if @@error<>0
			begin
				select "F","保存收费处方明细出错！"
				rollback tran
				deallocate cs_mzsf
				return		
			end
		end

		--全退不处理
		if @qtbz=0
		begin
			--保存剩下的处方明细
			declare @hjxh ut_xh12
			insert into SF_MZCFK(jssjh, hjxh, czyh, lrrq, patid, hzxm, ybdm, py, wb, 
				ysdm, ksdm, yfdm, qrczyh, qrrq, qrksdm, pyczyh, pyrq, cfts, txh, sfckdm, 
				pyckdm, fyckdm, jsbz, jlzt, fybz, cflx, sycfbz, tscfbz, pybz, jcxh, memo, cfxh,
				zje,zfyje,yhje,zfje,srje,fph,fpjxh,tfje,tfbz,fyckxh, sqdxh, ejygbz, ejygksdm,xzks_id,ylxzbh,tmhdbz,ghxh,gxrq,wsbz,wsts,cftszddm,cftszdmc,yscfbz)--mod by ozb 20060320增加ejygbz, ejygksdm
			select @newsjh, hjxh, @czyh, @now, patid, hzxm, ybdm, py, wb, 
				ysdm, ksdm, yfdm, qrczyh, qrrq, qrksdm, pyczyh, pyrq, cfts, xh, sfckdm,  --退序号插入红冲的序号 , Modify By Agg , 2003.08.12
				pyckdm, fyckdm, jsbz, 9, fybz, cflx, sycfbz, tscfbz, pybz, jcxh, memo, cfxh,
				zje,zfyje,yhje,zfje,srje,fph,fpjxh,tfje,tfbz,fyckxh, sqdxh, isnull(ejygbz,0), isnull(ejygksdm,""),xzks_id,ylxzbh--mod by ozb 20060320增加ejygbz, ejygksdm
				,case when cfts>0 and cflx = 3 and cfts%7 = 0 then '1' else '0' end,ghxh,@now,isnull(wsbz,0),isnull(wsts,0),cftszddm,cftszdmc,yscfbz --add by yfq @20120528
				from #mzcf_new where xh=@cfxh
			if @@error<>0
			begin
				select "F","保存收费处方出错！"
				rollback tran
				deallocate cs_sfbftf
				return
			end

			select @xhtemp=@@identity

			insert into SF_CFMXK(cfxh, cd_idm, gg_idm, dxmdm, ypmc, ypdm, ypdw, dwxs, ykxs, ypfj, ylsj, 
				ypsl, ts, cfts, zfdj, yhdj, memo, ypgg, flzfdj, hjmxxh,fpzh, lcxmdm, lcxmmc,lcxmsl,dydm,
				yjqrbz,zbz,lcjsdj,yjspbz,qrczyh,qrksdm,ssbfybz,zje,tmxxh,shbz,yqrsl,ktsl,wsbz,ldcfxh,ldmxxh --add "dydm" 20070119	--add fpzh by ozb 20060622 增加发票组号
				,tfbz)
			select @xhtemp, cd_idm, gg_idm, dxmdm, ypmc, ypdm, ypdw, dwxs, ykxs, ypfj, ylsj, 
				ypsl, ts, cfts, zfdj, yhdj, memo, ypgg, flzfdj, hjmxxh,fpzh, lcxmdm, lcxmmc,lcxmsl,dydm,yjqrbz,zbz,
				lcjsdj,yjspbz,qrczyh,qrksdm,ssbfybz,isnull(round(ypsl*ylsj*cfts/ykxs,2),0),xh,shbz,yqrsl,case @config2471 when 0 then ktsl else ktsl end,isnull(wsbz,0),ldcfxh,ldmxxh  --add "dydm" 20070119	--add fpzh by ozb 20060622 增加发票组号
				,case when @config2471=0 and ktsl > 0 then 1 else tfbz end
				from #cfmx_new where cfxh=@cfxh
			if @@error<>0
			begin
				select "F","保存收费处方明细出错！"
				rollback tran
				deallocate cs_sfbftf
				return		
			end
			--插入辅助表
			
			--bug 137298 add z_wm
			if exists(select 1 from #cfmx_new where cfxh=@cfxh)
			begin		
			    select @hjxh=hjxh from SF_MZCFK  where xh=@cfxh	
				insert into SF_MZCFK_FZ(jssjh,hjxh,cfxh,patid,ccfbz)
				select @newsjh,@hjxh,@xhtemp,@patid,ccfbz
				from #mzcf_old_fz where cfxh=@cfxh
				if @@error<>0
				begin
					select "F","保存收费处方明细出错！"
					rollback tran
					deallocate cs_mzsf
					return		
				end
			end 
			select @tfspbz=tfspbz,@yjqxyy=qxyy from #cfmx_old_fz where cfxh=@cfxh
			--wangmiao
			select @yjclfbz=yjclfbz from #cfmx_new_fz where cfxh=@cfxh
			insert into SF_CFMXK_FZ(cfxh,mxxh,hjmxxh,yjclfbz,tfspbz,qxyy)
			select @xhtemp,xh,hjmxxh,@yjclfbz,@tfspbz,@yjqxyy from SF_CFMXK where cfxh= @xhtemp  
			if @@error<>0
			begin
				select "F","保存收费处方明细出错！"
				rollback tran
				deallocate cs_mzsf
				return		
			end
		end

		fetch cs_sfbftf into @cfxh
	end
	close cs_sfbftf
	deallocate cs_sfbftf

	--已退费不再红冲
	if @tfbz=0
	begin
		--红冲门诊结算库
		IF @ylkysje<>0	-- add by gzy at 20050501
		BEGIN
			insert into SF_BRJSK(sjh, patid, ghsjh, ghxh, fph, fpjxh, czyh, sfrq, sfksdm, ksdm, 
				hzxm, blh, ybdm, pzh, sfzh, ylxm, zddm, dwbm, zje, zfyje, yhje, deje, zfje, 
				zpje, zph, xjje, srje, qkbz, qkje, zxlsh, jslsh, ybjszt, zhbz, tsjh, jlzt, cardno,
				cardtype, ghsfbz, jcxh, memo, mjzbz, brlx
				,ylkje,ylkysje, flzfje
				,qrbz,qrczyh,qrrq,tcljje,tcljbz,yflsh,tsyhje,spzlx
				,gbje, gbbz, gbtsbz,gbfwwje,bdyhkje,bdyhklsh,lcyhje,hzdybz,gxrq
				,yhdm,appjkdm,syldyhbz,syldyhje)	--mit ,2oo3-11-14
			select @newsjh1, patid, ghsjh, ghxh, fph, fpjxh, @czyh, @now, /*sfksdm*/@tfksdm, ksdm, --wudong alter sfksdm to @tfksdm 2015-06-19 需求29652
				hzxm, blh, ybdm, pzh, sfzh, ylxm, zddm, dwbm, -zje, -zfyje, -yhje, -deje, -zfje, 
				-zpje, zph, -xjje-ylkysje, -srje, qkbz, -qkje, zxlsh, jslsh, 0, zhbz, @sjh, 2, cardno,
				cardtype, ghsfbz, jcxh, memo, mjzbz, brlx
				,0,0, -flzfje
				,qrbz,@czyh,@now,tcljje,tcljbz,yflsh,-tsyhje,spzlx
				,-gbje, gbbz, gbtsbz,-gbfwwje,-bdyhkje,bdyhklsh,-lcyhje,hzdybz--mit ,2oo3-11-14
                ,@now
                ,yhdm,appjkdm,syldyhbz,-syldyhje --add by yjn 2015-03-21
				from #brjsk
			if @@error<>0
			begin
				select "F","红冲结算账单出错！"
				rollback tran
				return		
			end
		END
		ELSE
		IF @posfph='7' or CHARINDEX(','+@posfph+',',@config2545)>0
		BEGIN
			insert into SF_BRJSK(sjh, patid, ghsjh, ghxh, fph, fpjxh, czyh, sfrq, sfksdm, ksdm, 
				hzxm, blh, ybdm, pzh, sfzh, ylxm, zddm, dwbm, zje, zfyje, yhje, deje, zfje, 
				zpje, zph, xjje, srje, qkbz, qkje, zxlsh, jslsh, ybjszt, zhbz, tsjh, jlzt, cardno,
				cardtype, ghsfbz, jcxh, memo, mjzbz, brlx
				,ylkje,ylkysje, flzfje
				,qrbz,qrczyh,qrrq,tcljje,tcljbz,yflsh,tsyhje,spzlx
				,gbje, gbbz, gbtsbz,gbfwwje,bdyhkje,bdyhklsh,lcyhje,hzdybz,gxrq
				,yhdm,appjkdm,syldyhbz,syldyhje)	--mit ,2oo3-11-14
			select @newsjh1, patid, ghsjh, ghxh, fph, fpjxh, @czyh, @now, /*sfksdm*/@tfksdm, ksdm,  --wudong alter sfksdm to @tfksdm 2015-06-19 需求29652
				hzxm, blh, ybdm, pzh, sfzh, ylxm, zddm, dwbm, -zje, -zfyje, -yhje, -deje, -zfje, 
				case when @zffs=0 then 0 else -zpje end, case when @zffs=0 then '' else zph end, case when @zffs=0 then -xjje-zpje else -xjje end, 
				-srje, qkbz, -qkje, zxlsh, jslsh, 0, zhbz, @sjh, 2, cardno,
				cardtype, ghsfbz, jcxh, memo, mjzbz, brlx
				,-ylkje,-ylkysje, -flzfje
				,qrbz,@czyh,@now,tcljje,tcljbz,yflsh,-tsyhje,spzlx
				,-gbje, gbbz, gbtsbz,-gbfwwje,-bdyhkje,bdyhklsh	,-lcyhje,hzdybz--mit ,2oo3-11-14
                ,@now --add by yfq @20120528
                ,yhdm,appjkdm,syldyhbz,-syldyhje--add by yjn 2015-03-21
				from #brjsk
			if @@error<>0
			begin
				select "F","红冲结算账单出错！"
				rollback tran
				return		
			end
		END
		ELSE  if @zph<>'' -- @zph='S'
		BEGIN
			insert into SF_BRJSK(sjh, patid, ghsjh, ghxh, fph, fpjxh, czyh, sfrq, sfksdm, ksdm, 
				hzxm, blh, ybdm, pzh, sfzh, ylxm, zddm, dwbm, zje, zfyje, yhje, deje, zfje, 
				zpje, zph, xjje, srje, qkbz, qkje, zxlsh, jslsh, ybjszt, zhbz, tsjh, jlzt, cardno,
				cardtype, ghsfbz, jcxh, memo, mjzbz, brlx
				,ylkje,ylkysje, flzfje
				,qrbz,qrczyh,qrrq,tcljje,tcljbz,yflsh,tsyhje,spzlx
				,gbje, gbbz, gbtsbz,gbfwwje,bdyhkje,bdyhklsh,lcyhje,hzdybz,gxrq
				,yhdm,appjkdm,syldyhbz,syldyhje)	--mit ,2oo3-11-14
			select @newsjh1, patid, ghsjh, ghxh, fph, fpjxh, @czyh, @now, /*sfksdm*/@tfksdm, ksdm, --wudong alter sfksdm to @tfksdm 2015-06-19 需求29652 
				hzxm, blh, ybdm, pzh, sfzh, ylxm, zddm, dwbm, -zje, -zfyje, -yhje, -deje, -zfje, 
				--没有判断@zffs,部分退费时红冲按原方式红冲你，重收按现金重收有问题
				case when @zffs=0 then 0 else -zpje end, case when @zffs=0 then '' else zph end, case when @zffs=0 then -xjje-zpje else -xjje end, -srje, qkbz, -qkje, zxlsh, jslsh, 0, zhbz, @sjh, 2, cardno, 
				--源代码 -zpje, zph, -xjje, -srje, qkbz, -qkje, zxlsh, jslsh, 0, zhbz, @sjh, 2, cardno,
				cardtype, ghsfbz, jcxh, memo, mjzbz, brlx
				,-ylkje,-ylkysje, -flzfje
				,qrbz,@czyh,@now,tcljje,tcljbz,yflsh,-tsyhje,spzlx
				,-gbje, gbbz, gbtsbz,-gbfwwje,-bdyhkje,bdyhklsh,-lcyhje,hzdybz	--mit ,2oo3-11-14
                ,@now --add by yfq @20120528
                ,yhdm,appjkdm,syldyhbz,-syldyhje --add by yjn 2015-03-21        
				from #brjsk
			if @@error<>0
			begin
				select "F","红冲结算账单出错！"
				rollback tran
				return		
			end
		END
		ELSE
		BEGIN
			insert into SF_BRJSK(sjh, patid, ghsjh, ghxh, fph, fpjxh, czyh, sfrq, sfksdm, ksdm, 
				hzxm, blh, ybdm, pzh, sfzh, ylxm, zddm, dwbm, zje, zfyje, yhje, deje, zfje, 
				zpje, zph, xjje, srje, qkbz, qkje, zxlsh, jslsh, ybjszt, zhbz, tsjh, jlzt, cardno,
				cardtype, ghsfbz, jcxh, memo, mjzbz, brlx
				,ylkje,ylkysje, flzfje
				,qrbz,qrczyh,qrrq,tcljje,tcljbz,yflsh,tsyhje,spzlx
				,gbje, gbbz, gbtsbz,gbfwwje,bdyhkje,bdyhklsh,lcyhje,hzdybz,gxrq
				,yhdm,appjkdm,syldyhbz,syldyhje)	--mit ,2oo3-11-14
			select @newsjh1, patid, ghsjh, ghxh, fph, fpjxh, @czyh, @now, /*sfksdm*/@tfksdm, ksdm, --wudong alter sfksdm to @tfksdm 2015-06-19 需求29652 
				hzxm, blh, ybdm, pzh, sfzh, ylxm, zddm, dwbm, -zje, -zfyje, -yhje, -deje, -zfje, 
				-zpje, zph, -xjje, -srje, qkbz, -qkje, zxlsh, jslsh, 0, zhbz, @sjh, 2, cardno,
				cardtype, ghsfbz, jcxh, memo, mjzbz, brlx
				,-ylkje,-ylkysje, -flzfje
				,qrbz,@czyh,@now,tcljje,tcljbz,yflsh,-tsyhje,spzlx
				,-gbje, gbbz, gbtsbz,-gbfwwje,-bdyhkje,bdyhklsh,-lcyhje,hzdybz	--mit ,2oo3-11-14
                ,@now --add by yfq @20120528
                ,yhdm,appjkdm,syldyhbz,-syldyhje --add by yjn 2015-03-21        
				from #brjsk
			if @@error<>0
			begin
				select "F","红冲结算账单出错！"
				rollback tran
				return		
			end
		END

		insert into SF_BRJSMXK(jssjh, dxmdm, dxmmc, fpxmdm, fpxmmc, xmje, zfje, zfyje, yhje, memo, flzfje
			,tsyhje, gbzfje,gbfwje,gbfwwje,gbtsfwje,gbtsfwwje,gbtszfje ,lcyhje,syldyhje)
		select @newsjh1, dxmdm, dxmmc, fpxmdm, fpxmmc, -xmje, -zfje, -zfyje, -yhje, memo,- flzfje
			,-tsyhje, -gbzfje,-gbfwje,-gbfwwje,-gbtsfwje,-gbtsfwwje,-gbtszfje,-lcyhje,-syldyhje 
			from VW_MZBRJSMXK where jssjh=@sjh
		if @@error<>0
		begin
			select "F","红冲结算明细出错！"
			rollback tran
			return		
		end

		--add by ozb 红冲发票明细 begin
		delete from SF_FPMXDYK	where jssjh=@newsjh1
		insert into SF_FPMXDYK(jssjh,zh,fph,fpjxh,zje,zfje,flzfje,yhje,zfyje,bcdbz,wtpbz)
		select @newsjh1,zh,fph,fpjxh,-zje,-zfje,-flzfje,-yhje,-zfyje,bcdbz,wtpbz
			from VW_SFFPMXDYK where jssjh=@sjh
		if @@error<>0
		begin
			select "F","红冲发票明细对应记录出错！"
			rollback tran
			return		
		end
		--add by ozb 红冲发票明细 end

		--add by ozb 20060602 begin    
		if @bcdwtffp=1    
		begin			    
			update SF_FPMXDYK set wtpbz=1 where jssjh=@newsjh1 and zh not in (select fpzh from #cfmx_old a,#cfmx_tf b where a.xh=b.mxxh)  		
			select @fph=max(fph),@fpjxh=max(fpjxh) from SF_FPMXDYK(nolock) where jssjh=@newsjh1 and wtpbz=1			
		end
		--add by ozb 20060602 end    
		--add by ozb 红冲发票明细 end    
	end

	--全退不处理
	if @qtbz=0
	begin

		--保存剩下的门诊结算信息 cjt 20111122 dfbz=2表示退费重收
		insert into SF_BRJSK(sjh, patid, ghsjh, ghxh, fph, fpjxh, czyh, sfrq, sfksdm, ksdm, 
			hzxm, blh, ybdm, pzh, sfzh, ylxm, zddm, dwbm, zje, zfyje, yhje, deje, zfje, 
			zpje, zph, xjje, srje, qkbz, qkje, zxlsh, jslsh, ybjszt, zhbz, tsjh, jlzt, cardno,
			cardtype, ghsfbz, jcxh, memo, mjzbz, brlx, flzfje, qrbz, qrczyh, qrrq, tcljje, 
			tcljbz, yflsh,spzlx,lcyhje,hzdybz,dfbz,gxrq,yhdm,appjkdm)
		select @newsjh, patid, ghsjh, ghxh, isnull(@fph,0), isnull(@fpjxh,0), @czyh, @now, /*sfksdm*/@tfksdm, ksdm,  --wudong alter sfksdm to @tfksdm 2015-06-19 需求29652
			hzxm, blh, ybdm, pzh, sfzh, ylxm, zddm, dwbm, @zje+@zje1, @zfyje+@zfyje1, @yhje+@yhje1, 0, @sfje2,
			0, '', 0, @srje, @qkbz, @qkje, '', '', 0, zhbz, @newsjh1, 0, cardno,
			cardtype, ghsfbz, jcxh, memo, mjzbz, brlx, @flzfje+@flzfje1, @qrbznew , 
			@czyh,@now,@tcljje1,@tcljbz, yflsh,spzlx,@lcyhje,hzdybz,'2',@now --add by yfq @20120528
			,yhdm,appjkdm --add by yjn 2015-03-21
		from #brjsk
		if @@error<>0
		begin
			select "F","保存结算账单出错！"
			rollback tran
			return		
		end
		insert into SF_BRJSMXK(jssjh, dxmdm, dxmmc, fpxmdm, fpxmmc, xmje, zfje, zfyje, yhje, memo, flzfje,lcyhje)
		select @newsjh, a.dxmdm, b.name, b.mzfp_id, b.mzfp_mc, a.xmje, a.zfje, a.zfyje, a.yhje, null, flzfje,lcyhje
			from #sfmx1 a, YY_SFDXMK b (nolock) where a.dxmdm=b.id
		if @@error<>0
		begin
			select "F","保存结算明细出错！"
			rollback tran
			return		
		end
		
		-- 插入辅助表.
		if exists (select 1 from sysobjects where name='SF_BRJSK_FZ' and xtype='U')
		BEGIN
		    if exists(select 1 from SF_BRJSK_FZ where sjh = @newsjh)
		    begin
			    delete from SF_BRJSK_FZ where sjh = @newsjh
			    if @@error<>0
			    begin
				    select "F","清除SF_BRJSK_FZ重复记录出错！"
				    rollback tran
				    return		
			    end	
		    end		
		    insert into SF_BRJSK_FZ
		    (sjh,patid,ghsjh,ghxh,fph,fpjxh,ip,mac,sfly)
		    select                
		    @newsjh, @patid, ghsjh, ghxh, null, null,'',@wkdz,@sfly
		    from #brjsk
		    if @@error<>0
		    begin
			    select "F","保存结算账单出错！"
			    rollback tran
			    return		
		    end	
	   END
		
	end

	/*if @configdyms=0 and @acfdfp=1
	begin
		--zwj 2006.7.26 更新门诊退药清单
		update YF_MZFYZD set jlzt=1 
		from YF_MZFYZD a where a.jssjh=@sjh and a.tfbz=1 and a.tfqrbz=0 and not exists(select 1 from #mzcf_tf b where a.cfxh=b.cfxh) and jlzt=0
		if @@error<>0
		begin
			select "F","更新退药信息出错！"
			rollback tran
			return		
		end
	end*/
	--多零售价跨批次部分退费问题处理，需求44612,2015-10-27
	declare @isdlsjfa ut_bz, --是否采用多零售价方案（0不采用，1采用）
			@ypxtslt int,--零售价方案
			@cfmxxh_cs	ut_xh12,--重收序号
			@tcfmxxh_cs	ut_xh12,--退明细序号
			@ypsl_cs	ut_xh12,--重收数量
			@zje_cs ut_money, 
			@sfje_cs ut_money,
			@ybje_cs ut_money, 
			@flzfje_cs ut_money, 
			@yjzfje_cs ut_money,
			
			@cfxh_ty	ut_xh12,
			@mxxh_ty	ut_xh12,
			@tmxxh_ty	ut_xh12,
			@pjlsj_ty	ut_money,
			@ypsl_ty	ut_sl10
	select @isdlsjfa=0,@ypxtslt=0,@cfmxxh_cs=0,@tcfmxxh_cs=0,@ypsl_cs=0,@zje_cs=0, @sfje_cs=0,@ybje_cs=0, @flzfje_cs=0, @yjzfje_cs=0
			,@cfxh_ty=0,@mxxh_ty=0,@tmxxh_ty=0,@pjlsj_ty=0,@ypsl_ty=0
	if exists(select 1 from sysobjects where name='f_get_ypxtslt')	
	begin
		select @ypxtslt=dbo.f_get_ypxtslt()  
		if @ypxtslt=3 
		select @isdlsjfa=1
	end
	if (@isdlsjfa = 1)and(@qtbz = 0)
	begin
		if exists(select 1 from SF_MZCFK a(nolock),SF_CFMXK b(nolock) where a.jssjh = @newsjh and a.xh=b.cfxh and a.cflx in(1,2,3) and a.fybz=0)
		begin
			declare cs_mzsf_dpcjgcl_ys cursor for
			select b.xh,b.tmxxh,b.ypsl*b.cfts  from SF_MZCFK a(nolock)
				inner join SF_CFMXK b(nolock) on a.xh = b.cfxh
			where a.jssjh=@newsjh and a.cflx in(1,2,3) and a.fybz=0
			for read only
			open cs_mzsf_dpcjgcl_ys
			fetch cs_mzsf_dpcjgcl_ys into @cfmxxh_cs,@tcfmxxh_cs,@ypsl_cs
			while @@fetch_status=0
			begin							
				exec usp_yf_sfjk_bftf_cfdypc_cl @cfmxxh_cs,@ypsl_cs,@tcfmxxh_cs,@czyh,0,@errmsg output
				if substring(@errmsg,1,1)<>'T'
				begin
					select 'F','药品多批次单价计算出错：'+@errmsg
					rollback tran
					deallocate cs_mzsf_dpcjgcl_ys
					return
				end
				fetch cs_mzsf_dpcjgcl_ys into @cfmxxh_cs,@tcfmxxh_cs,@ypsl_cs
			end
			close cs_mzsf_dpcjgcl_ys
			deallocate cs_mzsf_dpcjgcl_ys
			
			select b.xh mxxh,sum((a.yplsj/a.ykxs)*a.djk_djsl) lsje into #yf_ypcfpc_dydjjlk
			from YF_YPCFPC_DYDJJLK a(nolock)
			inner join SF_CFMXK b(nolock) on a.mxxh = b.xh
			inner join SF_MZCFK c(nolock) on b.cfxh = c.xh
			where c.jssjh = @newsjh and c.cflx in(1,2,3) and c.fybz=0
			group by b.xh

			
			
			update a set a.ylsj= convert(numeric(10,4),(c.lsje/(a.ypsl*a.cfts))*a.ykxs),
				a.zje = convert(numeric(10,2),(((c.lsje/(a.ypsl*a.cfts))*a.ykxs)*a.dwxs*a.cfts/a.ykxs)*(a.ypsl/a.dwxs))
			from SF_CFMXK a
			inner join SF_MZCFK b(nolock) on a.cfxh = b.xh
			inner join #yf_ypcfpc_dydjjlk c(nolock) on a.xh = c.mxxh
			where b.jssjh = @newsjh and b.cflx in(1,2,3) and b.fybz=0
			if @@ERROR <> 0
			begin
				select 'F','多零售价方案，更新药品明细的零售价出错！'
				rollback tran
				return
			end
			
			--金额重算
			exec usp_sf_sfcl_jecs @newsjh,@errmsg output,@zje_cs output, @sfje_cs output,@ybje_cs output, @flzfje_cs output, @yjzfje_cs output
			if substring(@errmsg,1,1)<>'T'
			begin
				select 'F','费用重算出错：'+@errmsg
				rollback tran
				return
			end
		end
		if exists(select 1 from SF_MZCFK a(nolock),SF_CFMXK b(nolock) where a.jssjh = @newsjh and a.xh=b.cfxh and a.cflx in(1,2,3) and a.fybz=1)
		begin
			select b.xh cfxh,a.xh mxxh,a.tmxxh tmxxh,ypsl ypsl,@sjh jssjh,a.cfts into #cfmx_fyty	--重收的处方明细
			from SF_CFMXK a(nolock)
				inner join SF_MZCFK b(nolock) on a.cfxh = b.xh
				inner join #cfmx_tf c on a.tmxxh = c.mxxh
			where b.jssjh  = @newsjh and b.fybz = 1 and b.cflx in (1,2,3)
			
			select a.ylsj,a.ypsl,a.ykxs,a.mxxh,a.cfts into #yf_mzfymx									--发药明细
			from YF_MZFYMX a(nolock)
				inner join YF_MZFYZD b(nolock) on a.fyxh = b.xh
			where b.jssjh = @sjh
			--if @@ROWCOUNT = 0 --note by mxd for bug:21272 and pdms:30686
			begin
				insert into #yf_mzfymx
				select a.ylsj,a.ypsl,a.ykxs ,a.mxxh,a.cfts
				from YF_NMZFYMX a(nolock)
					inner join YF_NMZFYZD b(nolock) on a.fyxh = b.xh
				where b.jssjh = @sjh
			end
			
			declare cs_mzsf_dpcjgcl_ty cursor for
			select cfxh,mxxh,tmxxh,ypsl*cfts
			from #cfmx_fyty
			for read only
			open cs_mzsf_dpcjgcl_ty
			fetch cs_mzsf_dpcjgcl_ty into @cfxh_ty,@mxxh_ty,@tmxxh_ty,@ypsl_ty
			while @@fetch_status=0
			begin						
				select @pjlsj_ty = SUM(ylsj*ypsl*cfts)/@ypsl_ty
				from #yf_mzfymx
				where mxxh = @tmxxh_ty 
				
				update SF_CFMXK set ylsj=@pjlsj_ty,zje = @pjlsj_ty*@ypsl_ty/ykxs
				where xh = @mxxh_ty
				if @@ROWCOUNT=0 or @@ERROR<>0
				begin
					select 'F','更新重收药品零售价失败！'
					rollback tran
					close cs_mzsf_dpcjgcl_ty
					deallocate cs_mzsf_dpcjgcl_ty
					return
				end
				fetch cs_mzsf_dpcjgcl_ty into @cfxh_ty,@mxxh_ty,@tmxxh_ty,@ypsl_ty
			end
			close cs_mzsf_dpcjgcl_ty
			deallocate cs_mzsf_dpcjgcl_ty
			
			--金额重算
			exec usp_sf_sfcl_jecs @newsjh,@errmsg output,@zje_cs output, @sfje_cs output,@ybje_cs output, @flzfje_cs output, @yjzfje_cs output
			if substring(@errmsg,1,1)<>'T'
			begin
				select 'F','费用重算出错：'+@errmsg
				rollback tran
				return
			end
		end
	end
	commit tran	
	UPDATE dbo.SF_CFMXK_FZ SET hxbz = '1' WHERE mxxh IN (
	SELECT a.xh FROM dbo.SF_CFMXK a
	LEFT JOIN dbo.SF_CFMXK b ON a.tmxxh=b.xh
	LEFT JOIN dbo.SF_MZCFK c ON a.cfxh = c.xh
	LEFT JOIN dbo.SF_CFMXK_FZ fz ON b.xh=fz.mxxh
	WHERE fz.hxbz = '1' AND c.jssjh = @newsjh)--更新新的sf_cfmxk_fz中的hxbz

	if @qtbz=0
	begin
		select "T", 0, @newsjh, @zje+@zje1, @sfje2-@qkje, @ybje+@ybje1,  --0-5
				@flzfje+@flzfje1,@ybzje, @ybjszje, @ybzlf, @ybssf, @ybjcf, --6-11
				@ybhyf, @ybspf, @ybtsf, @ybxyf, @ybzyf, @ybcyf, @ybqtf, -- 12-18
				@ybgrzf,@patid,round(isnull(@bdyhkje,0.00),2) -- 19-21
				,@jfbz,@jfje --22-23
				,@zffs --24
	end
	else
		select "T", 1,@newsjh,@zffs
end

return






