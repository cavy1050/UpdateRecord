ALTER proc usp_gh_ghdj
	@wkdz varchar(32),
	@jszt smallint,
	@ghbz smallint,
	@ghlb smallint,
	@czksfbz  int, 
	@cfzbz smallint,
	@patid ut_xh12,
	@czyh ut_czyh,
	@ksdm ut_ksdm,
	@ysdm ut_czyh,--10
	@ghksdm ut_ksdm,
	@sjh ut_sjh = null,
	@lybz smallint = 0,
	@yyxh ut_xh12 = null,
	@zhbz ut_zhbz = null,
	@zddm ut_zddm = null,
	@zxlsh ut_lsh = null,
	@jslsh ut_lsh = null,
	@xmlb ut_dm2 = null,
	@qfdnzhzfje numeric(12,2) = null,--20
	@qflnzhzfje numeric(12,2) = null,
	@qfxjzfje numeric(12,2) = null,
	@tclnzhzfje numeric(12,2) = null,
	@tcxjzfje numeric(12,2) = null,
	@tczfje numeric(12,2) = null,
	@fjlnzhzfje numeric(12,2) = null,
	@fjxjzfje numeric(12,2) = null,
	@dffjzfje numeric(12,2) = null,
	@dnzhye numeric(12,2) = null,
	@lnzhye numeric(12,2) = null,--30
	@jsrq ut_rq16 = '',
	@qkbz smallint = 0
	,@ylcardno ut_cardno=''
	,@ylkje ut_money=0
	,@ylkysje ut_money=0
	,@ylksqxh ut_lsh=''
	,@ylkzxlsh ut_lsh=''
	,@ylkyssqxh ut_lsh=''
	,@ylkyszxlsh ut_lsh=''
	,@yslx int=0 --40
	,@ybdm ut_ybdm=''
	,@zjdm ut_ksdm = null
	,@zmdm ut_ksdm = null
	,@zm ut_mc32 =null
	,@yyrq	ut_rq16=''
	,@zqdm	ut_ksdm=null
	,@jmjsbz ut_bz=0
	,@zzdjh varchar(100) = ''
	,@inghzdxh	ut_xh12=0	
	,@zymzxh ut_xh12 = 0  --中医名专挂号费序号
    ,@pbmxxh ut_xh12 = 0
    ,@xmldxx varchar(800)='' --联动项目字符串
    ,@ghfdm ut_xmdm = ''
    ,@kmdm	ut_xmdm=''
    ,@ghfselectbz varchar(12)=''
    ,@mfghyy	ut_dm2=''
	,@yhdm ut_ybdm=''--优惠类型代码    
	,@kfsdm ut_ybdm=null--app开发商代码
	,@sfyf ut_bz=0 --是否优抚
	,@zbdm ut_zddm = '' -- 专病代码
	,@brlyid ut_czyh='' --病人来源id
	,@wlzxyid ut_czyh=''--网络操作员id  
	,@hrpbz    ut_bz=''  --1走HRP 
	,@zzdh varchar(100) = '' --转诊单号
	,@isQygh ut_bz =0 --是否签约挂号
as  
/**********
[版本号]4.0.0.0.0
[创建时间]2004.10.25
[作者]王奕
[版权] Copyright ? 2004-2008上海金仕达-卫宁软件股份有限公司[描述]挂号登记
[功能说明]
	挂号登记功能
[参数说明]
	@wkdz varchar(32),	网卡地址
	@jszt smallint,		结束状态	1=创建表，2=插入，3=递交
	@ghbz smallint,		挂号标志: 0=预算，1=递交(请求1), 2=正式递交(请求2)
	@ghlb smallint,		挂号类别：0=普通，1=急诊，2=专家，3=点名专家，4=特殊挂号，5=义诊，6=外宾挂号,7= 免挂号费, 8=免费挂号
	@czksfbz  int, 		充值卡收费标志， 0 :不从充值卡收费  ，1 从充值卡收费 add by szj
	@cfzbz smallint,	初诊标志：0=初诊，1=复诊
	@patid ut_xh12,		病人唯一标识
	@czyh ut_czyh,		操作员号
  	@ksdm ut_ksdm,		科室代码
  	@ysdm ut_czyh,		专家代码
	@ghksdm ut_ksdm,	挂号科室代码
 	@sjh ut_sjh = null,	结算库收据号
	@lybz smallint = 0,	挂号来源0=普通，1=预约 2=自助挂号
	@yyxh ut_xh12 = null,	预约序号
	@zhbz ut_zhbz = null,	账户标志
	@zddm ut_zddm = null,	诊断代码
	@zxlsh ut_lsh = null,	中心流水号
	@jslsh ut_lsh = null,	计算流水号
	@xmlb ut_dm2 = null,	大病项目
	@qfdnzhzfje numeric(12,2) = null, 	起付段当年账户支付
	@qflnzhzfje numeric(12,2) = null,	起付段历年帐户支付
	@qfxjzfje numeric(12,2) = null,		起付段现金支付
	@tclnzhzfje numeric(12,2) = null,	统筹段历年帐户支付
	@tcxjzfje numeric(12,2) = null,		统筹段现金支付
	@tczfje numeric(12,2) = null,		统筹段统筹支付
	@fjlnzhzfje numeric(12,2) = null,	附加段历年帐户支付
	@fjxjzfje numeric(12,2) = null,		附加段现金支付
	@dffjzfje numeric(12,2) = null,		附加段地方附加支付
	@dnzhye numeric(12,2) = null,		当年账户余额
	@lnzhye numeric(12,2) = null,		历年账户余额
	@jsrq ut_rq16 = ''					结算日期
	@qkbz smallint = 0					欠款标志0：正常，2：欠费
	,@ylcardno ut_cardno=''
	,@ylkje ut_money=0
	,@ylkysje ut_money=0
	,@ylksqxh ut_lsh=''
	,@ylkzxlsh ut_lsh=''
	,@ylkyssqxh ut_lsh=''
	,@ylkyszxlsh ut_lsh=''
	,@yslx int=0 --40	医生类型
	,@ybdm ut_ybdm=''	医保代码
	,@zjdm ut_ksdm = null	诊间代码
	,@zmdm ut_ksdm = null	诊名代码
	,@zm ut_mc32 =null	诊名
	,@yyrq	ut_rq16=''	预约日期
	,@zqdm	ut_ksdm=null	诊区代码
	,@jmjsbz ut_bz=0					减免结算标志0:正常结算,1:医保减免,2:财政减免
	,@zzdjh varchar(100) = ''  二三级医院转诊单据号
	,@ghzdxh	ut_xh12=0		挂号账单序号（挂号收费确认流程用到config(1151)=1）
[返回值]
[结果集、排序]
[调用的sp1]
[调用实例]
[修改记录]
	modified by hkh  on 20030625  
		增加免挂号费挂号 (1049)
	20030728 hcy  挂号号序取count(ghhx)
	20030905 tony	医保四期修改：
		1。@ghbz=0时新增传出字段：挂号费，诊疗费，预交金余额
		2。伤残病人挂号费不付
		3。门诊预交金病人从账户里扣钱
		4。外宾挂号挂科室时诊疗费按科室收取
		5。处理挂号标志为1，2的程序从本存储过程删除
	20031128 mit 根据设置1065判断可以记账的凭证类型
	modify by szj	 2004.02.19 充值卡需要提供密ghrq
		码才可以收费添加了@czksfbz 参数。控制是否从充值卡上扣钱
	2004-03-12 panlian 增加判断70岁以上免挂号费
	2004-05-25 增加外宾挂号的费用处理，需要在特殊项目里设置
	2004-06-09 lingzhi 增加从前台传入医保代码，可临时修改病人凭证类型
	2004-06-19 lingzhi 增加传入诊间和诊名
	W20050313 特殊收费项目中增加上限价格,作用是针对特殊病人的上限价格设置.
		      顺序:先执行收费小项目中的上限价格,再覆盖执行特殊收费项目中的上限价格
	2008-01-07 zyh 保存医生对应的行政科室
	2008-02-19 zyh 增加select @sfje2=@sfje3，解决医保病人在挂号时作自费处理时返回收费金额为0的问题
**********/
set nocount on

---by dingsong 自助机无sfksdm，默认
if(isnull(@ghksdm,'')='')
begin
select @ghksdm=case when isnull(@ksdm,'')='' then (select top 1 id from YY_KSBMK where name like '%财务%') else @ksdm end
end

declare 	@config1662		varchar(5),	--儿童是否加收（'是'or'否'）
		@config1662_js		varchar(5),	--儿童加收
		@config1630_js     varchar(5), --年龄控制
		@config1665		varchar(2000),	--科室加收
		@config1665_js 		varchar(5),	--科室是否加收
		@etnl			varchar(5),	--儿童年龄
		@etbirth		varchar(10),--儿童出生日期
		@nowdate		varchar(10),
		@jsksdm			varchar(8),	--儿童加收科室代码
		@ghxhtmp  ut_xh12
		,@config2613 varchar(200) --add by liuquan vsts29479 如果2613=否，不应该结算
		,@config2604 varchar(8)--门诊收费时是否调用HRP接口进行价格重算（默认为否）
		,@zlfjmlx varchar(8)--诊疗费减免类型 0:优抚减免,1:60岁老人减免，2：转诊减免

select @config1630_js=config from YY_CONFIG(nolock) where id='1630'
select @config1662=config from YY_CONFIG(nolock) where id='1662'
select @config1665=config from YY_CONFIG(nolock) where id='1665'
select @config1662_js='',@etbirth='',@nowdate='',@etnl='',@jsksdm='',@config1665_js=''
select @config2613=ISNULL(config,'否') from YY_CONFIG WHERE id="2613" --add by liuquan vsts29479 如果2613=否，不应该结算

if cast(@config1630_js as int)>0 AND @config1662='是'
begin
	select @etbirth=birth from SF_BRXXK where patid=@patid
	select @nowdate=convert(char(8),getdate(),112)
	select @etnl=DATEDIFF( YEAR, @etbirth, @nowdate)
	if cast(@etnl as int)<=cast(@config1630_js as int)
		set @config1662_js='是'
end

if (ltrim(rtrim(@config1665))='' or charindex(','+ltrim(rtrim(@ksdm))+',',ltrim(rtrim(@config1665)))>0) and @config1662='是'
begin
		set @config1665_js='是'
end
--获取参数2604 并去空格
select @config2604=config from YY_CONFIG(nolock) where id='2604'
select @config2604=ltrim(rtrim(@config2604))

--生成递交的临时表
declare @tablename varchar(32),
		@ysbz smallint,
        @ksorys smallint,--ghf,zlf选科室的还是医生的--湖南肿瘤需求
		@gfyyxh ut_xh12 
		,@config1151	VARCHAR(200)
        --,@fsdgh  ut_bz  --分时间段挂号标志
        ,@pbmxxh_temp ut_xh12
        ,@ghrq  ut_rq16
        ,@hxfs_new  smallint 		/*号序方式	0 占号方式，即预约了几号挂号就是几号（中医）	
								1 预约号和现场号分离计算，即假设预约号为1 3 5 7 9。。。则预约病人只能挂号预约号上，现场病人只能挂2 4 6 8等号
								2 预约号和现场病人号序混合算,即现场和预约病人都是先来先得
								3 老预约和新预约混用，老预约负责现场号，新预约负责预约号（大华模式）
								*/
		,@yyghlb ut_bz
		,@kmmc	ut_mc64  
		,@zqmc	ut_mc64  
		,@fbdm	ut_xmdm  
		,@fbmc	ut_mc64  
		,@sfzh  ut_sfzh
		,@hzxm  ut_mc64
		,@fpdybz	ut_bz	--发票打印标志
		,@zbdm_temp ut_zddm 
		,@yjksbz varchar(10)
		,@config1566 varchar(20)
		,@yjfhbz varchar(2)  			
declare	@outmsg varchar(200)
declare @yjksjh varchar(100)
exec usp_yy_ldjzq @outmsg output
if substring(@outmsg,1,1)='F'
begin
	select	'F',substring(@outmsg,2,200)
	return
end


if exists(select 1 from YY_CONFIG(nolock) where id='1601' and ltrim(rtrim(config))<>'')--如果配置了1601参数且配置了预检参数集合
begin
	select @yjksjh=config from YY_CONFIG(nolock) where id='1601'  --获得科室集合
	select @config1566=config from YY_CONFIG(nolock) where id='1566' --获得护士站的数据库名称
	select @yjksbz=charindex(rtrim(@ksdm),@yjksjh)  --判断传入的ksdm是否在配置的科室集合中
	if @yjksbz<>0 --如果有说明要判断挂这个科室的病人是否预检过
	begin
		 if object_id('tempdb..#temptableyjxx') is not null 
			 drop table #temptableyjxx
		 create table #temptableyjxx   --创建临时表存入护士站存储返回的该病人的预检结果
			 (
				yjbz varchar(2),
				yjxh varchar(100)
			 )
         --执行护士站的存储放入临时临时表  因为这个存储没有使用output参数，所以这样接收结果 
		 insert into #temptableyjxx(yjbz,yjxh) exec('exec '+ @config1566+'usp_his5_jzhs_getpatyjxh '+@patid )  
		 select @yjfhbz=yjbz from  #temptableyjxx     	
         --判断如果返回的是F 说明没有预检过，不能继续挂号
		 if @yjfhbz='F' 
		 begin
			 select 'F','如果要挂当前这个科室，病人必须先预检，因为没有预检信息，所以不让挂号.'  
			 return  		 
		 end	 
	end 
end


--是否只允许院内职工免费挂号
if exists(select 1 from YY_CONFIG(nolock) where id='1351' and config='是') and @ghlb=8
begin
	select @sfzh=sfzh,@hzxm=hzxm from SF_BRXXK (nolock) where patid=@patid
	if isnull(@sfzh,'')=''
	begin
        select 'F','身份证号为空，不能挂免费号'
        return
    end
    if not exists(select 1 from YY_ZGBMK (nolock) where name=@hzxm and sfzh=@sfzh and jlzt=0)
    begin
        select 'F','非本院职工，不能挂免费号'
        return
    end 
    if not exists(select 1 from SF_BRXXK (nolock) where patid=@patid and cardtype=2) and 
       not exists(select 1 from SF_BRCARD (nolock) where patid=@patid and cardtype=2)
    begin
        select 'F','病人卡类型不为保障卡，不能挂免费号'
        return
    end
end
			
				
SELECT @config1151="0"
SELECT @config1151=ISNULL(config,0) FROM YY_CONFIG(nolock) WHERE id="1151"

--if (select config from YY_CONFIG (nolock) where id='1171')='是'
--    select @fsdgh=1
--else
--    select @fsdgh=0
    
select @hxfs_new = -1
select @hxfs_new = config from YY_CONFIG (nolock) where id = '1235'
if @hxfs_new is null
    select @hxfs_new = 0
    
--普通挂号是否选医生
select @ysbz=(case when config='0' then 0 else 1 end) from YY_CONFIG (nolock) where id='1012'
--是：ghf与zlf都取自医生，而不是科室
select @ksorys=(case when config='否' then 0 else 1 end) from YY_CONFIG (nolock) where id='1105'--只有在1012为是时才有效

select @tablename='##mzgh'+@wkdz+@czyh
---cjt 自动挂号初复诊处理
----if @lybz=2 
----begin
----	select @cfzbz=isnull(ghbz,'0') from SF_BRXXK where patid=@patid  
----end
--delete by yxc 以后自动挂号也可以选择初复诊了-----

/*add by mxd for vsts:237239 自动挂号可能存在不选的情况，传入的是-1 2017.12.05*/	
if @cfzbz=-1
begin
	select @cfzbz=isnull(ghbz,'0') from SF_BRXXK where patid=@patid  
end

declare @iskmgh ut_bz
select @iskmgh= case  when config= '是' then 1 else 0 end   from YY_CONFIG (nolock) where id='1319'   
select @iskmgh=ISNULL(@iskmgh,0)
if  @iskmgh=1 and exists (select 1 from YY_CONFIG WHERE id='1188' and config='是')
begin
	select 'F','程序配置错误，请联系管理员（参数1188和1319不能同时为“是”）'
	return
end



 
declare @strmorning char(5),
@strnoon char(5),
@strnight char(5),
@sjdsm varchar(10),
@sjdjl ut_mc32,
@hour varchar(8)

set @hour=substring(convert(char(8),getdate(),8),1,5)

select @strmorning=isnull(convert(char(5),config),'07:30') from YY_CONFIG (nolock) where id='1018'   --晚上上午分隔时间
select @strnoon=isnull(convert(char(5),config),'12:00') from YY_CONFIG (nolock) where id='1016'      --上午下午分隔时间 
select @strnight=isnull(convert(char(5),config),'17:30') from YY_CONFIG (nolock) where id='1017'      --下午晚上分隔时间
if @hour>=@strmorning and @hour<@strnoon
	select @sjdsm='上午',@sjdjl=@strmorning+'-'+@strnoon
else if @hour>=@strnoon and @hour<@strnight
	select @sjdsm='下午',@sjdjl=@strnoon+'-'+@strnight
else if @hour>=@strnight
	select @sjdsm='晚上',@sjdjl=@strnight+'-23:00'
else
	select @sjdsm='未知',@sjdjl='00:00-00:00'

if @jszt=1
begin
	exec('if exists(select * from tempdb..sysobjects where name="'+@tablename+'")
		drop table '+@tablename)
	exec('create table '+@tablename+'(
		ghlb smallint not null,
		cfzbz smallint not null,
		ksdm ut_ksdm not null,
		ysdm ut_czyh not null,
		lybz smallint not null,
		yyxh ut_xh12 not null,
		yyrq ut_rq16 null
		,zqdm	ut_ksdm null
		,xzks_id ut_ksdm null
	    ,zymzxh ut_xh12  null --中医名专挂号费序号
        ,pbmxxh ut_xh12  null
        ,xmldxx varchar(800) null  --联动项目信息
        ,kmdm  ut_xmdm null
        ,zbdm ut_zddm null
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
	declare @cghlb varchar(2),
			@ccfzbz varchar(2),
			@clybz varchar(2),
			@cyyxh varchar(12),
			@cyyrq varchar(16),
            @cpbmxxh ut_xh12,
            @ckmdm varchar(16),
            @czbdm ut_zddm 

	select 	@cghlb=convert(varchar(2),@ghlb),
			@ccfzbz=convert(varchar(2),@cfzbz),
			@clybz=convert(varchar(2),@lybz),
			@cyyxh=convert(varchar(12),@yyxh),
			@cyyrq=convert(varchar(16),@yyrq),
            @cpbmxxh=convert(varchar(12),@pbmxxh),   
            @ckmdm=convert(varchar(12),@kmdm)  
			,@czbdm = @zbdm
	exec('insert into '+@tablename+' values('+@cghlb+','+@ccfzbz+',"'+@ksdm+'","'+@ysdm+'",'+@clybz+','+@cyyxh+',"'+@cyyrq+
		'","'+@zqdm+'","'+@ksdm+'",'+@zymzxh+','+@cpbmxxh+',"'+@xmldxx+  '","'+@ckmdm+'","'+@czbdm+'")')
	if @@error<>0
	begin
		select "F","插入临时表时出错！"
		return
	end
	select "T"
	return
end
declare	@now ut_rq16,		--当前时间
		@brybdm ut_ybdm,	--病人医保代码
		@zfbz smallint,		--比例标志
		@rowcount int,
		@error int,
		@zje ut_money,		--总金额
		@zfyje ut_money,	--自费金额
		@yhje ut_money,		--优惠金额
		@ybje ut_money,		--可用于医保计算的金额
		@pzlx ut_dm2,		--凭证类型
		@sfje ut_money,		--实收金额
		@sfje1 ut_money,	--实收金额(包含自费金额)
		@errmsg varchar(50),
		@srbz char(1),		--舍入标志
		@srje ut_money,		--舍入金额
		@sfje2 ut_money,	--舍入后的实收金额
		@xhtemp ut_xh12,
		@ksmc ut_mc32,		--科室名称
		@ysmc ut_mc64,		--医生姓名
		@xmzfbl float,		--项目自付比例
		@xmce ut_money,		--自付金额和大项自付金额汇总的差额
		@fph bigint,			--发票号
		@fpjxh ut_xh12,		--发票卷序号
		@print smallint,	--是否打印0打印，1不打
		@ghhx int,			--挂号号序
		@ghzdxh ut_xh12,	--挂号账单序号
		@brlx ut_dm2,		--病人类型
		@pzh ut_pzh,		--凭证号
		@qkbz1 smallint,	--欠款标志0：正常，1：记账，2：欠费
		@zhje ut_money,		--账户金额
		@qkje ut_money,		--欠款金额（记账金额）
		@cardno ut_cardno,	--卡号
		@cardtype ut_dm2 ,	--卡类型
		@config  varchar(255),   --YY_CONFIG中的config
		@config1  varchar(255),   --YY_CONFIG中的config '1051'普通挂号选医生是否只能选医生站值班医生
		@config2  varchar(255),   --YY_CONFIG中的config '1053'当'1051'为是时挂号费诊疗费取自医生而不是科室
		@scybdm ut_ybdm,	--伤残病人医保代码
		@yjbz ut_bz,		--是否使用充值卡
		@yjye ut_money,		--预交金余额
		@ybldbz varchar(2),	--医保是否允许联动
		@ghf ut_money,		--挂号费
		@zlf ut_money,		--诊疗费
		@qrbz ut_bz,		--确认标志0无需确认，1未确认，2已确认
		@yjyebz varchar(2),	--充值卡余额不足是否允许继续收费
		@yjdybz varchar(2),	--充值卡挂号是否打印发票
		@jsfs ut_bz,		--结算方式
		@tcljbz ut_bz,		--统筹累计标志
		@tcljje ut_money,	--统筹累计金额（镇保、新疆回沪使用） 
		@config3 varchar(2), 	--YY_CONFIG中的1071
		@birth varchar(16),
		@yyxh_new ut_xh12,
		@mzlcbz  	ut_bz	--门诊流程标志(0-传统模式，1-优化模式，2-兼容模式)
		,@qkje2  ut_money   	--帮困账户支付保留两位小数
		,@sfje_caclsr ut_money  --计算帮困时处理舍入问题
		,@zfyje_sc ut_money  	--伤残病人的自费药金额
		,@csybdm varchar(255)	--慈善医保代码
		,@ghldbz varchar(2)	--挂号是否联动
		,@issyzzgh ut_bz	--是否启用自助挂号
		,@jmje	ut_money	--减免金额
		,@tsrydm ut_dm2		--特殊人员代码
		,@yydj ut_bz		--医院等级 
		,@jmghf ut_money --减免挂号费
		,@jmzlf ut_money --减免诊疗费
		,@jmghfbl float
		,@jmzlfbl float 
		,@sfje_zzjsq ut_money		--转诊计算前实收金额
		,@xzks_id ut_ksdm
		,@sfje3 ut_money
		,@hznl   int ---患者年龄 cjt 20110913  	
		,@sex   ut_sex ---患者性别 20121217
		--,@config1334 varchar(5)  --是否调用zdfz
		,@ynyhje numeric(12,2) --院内优惠金额
		--会员卡功能修改新增变量 zwj 2006.12.12
		,@tsghksdm ut_ksdm  --特殊挂号科室代码ghlb=4时
		,@tsghksmc ut_mc32 --特殊挂号科室名称
declare @hykmsbz ut_bz		--会员卡模式标志
	,@hysybz ut_bz		--会员使用标志(YY_YBFLK中hysybz)
	,@yyxh1  ut_xh12	--预约序号
	,@djje	 ut_money	--冻结金额
	,@gsbz	ut_bz		--挂失标志
	,@ghfdm_hb ut_xmdm
	,@zlfdm_hb ut_xmdm
	,@hbdm ut_xmdm -- 号别
	,@isUsehb int -- 是否使用号别管理 1 使用0 不使用
	,@config1501 varchar(4)

select @now=convert(char(8),getdate(),112)+convert(char(8),getdate(),8),
	@zje=0, @zfyje=0, @yhje=0, @ybje=0,
	@sfje=0, @sfje1=0, @srje=0, @sfje2=0, 
	@xmzfbl=0, @xmce=0, @print=0, @ghhx=0,
	@qkbz1=0, @qkje=0, @yjbz=0, @yjye=0, @ghf=0, @zlf=0, @qrbz=0,
	@jsfs=0, @tcljbz=0, @tcljje=0,@zfyje_sc = 0,@issyzzgh=0,@jmje=0,@jmzlf = 0,@jmghf = 0 
	,@sfje_zzjsq = 0,@hznl=0,@fpdybz=0
if exists(select 1 from YY_CONFIG where id='1124' and config='是')
	select @issyzzgh=1
--取得医院等级
select @yydj=c.yydj from YY_KSBMK k(nolock),YY_JBCONFIG c (nolock)
            where k.id= @ksdm and k.yydm=c.id 
select @yydj = isnull(@yydj,1)

if exists(select 1 from YY_CONFIG where id='1500' and config='是')
	select @isUsehb=1
else
	select @isUsehb = 0
	
select @config1501 = config from YY_CONFIG where id='1501'

declare @sfly ut_bz
	if (@sjh='zzj' or @sjh='zzsf') select @sfly=1
	if @sjh='yszdy' select @sfly=2
	if @sjh='mzyj'  select @sfly=3
	if @sjh='SJH' select @sfly=0
select @tsghksdm=rtrim(ltrim(isnull(config,''))) from YY_CONFIG(nolock) where id='1599'
if @tsghksdm<>''
  select @tsghksmc=name from YY_KSBMK(nolock) where id=@tsghksdm
/*if exists (select 1 from YY_CONFIG(nolock) where id='1334' and config='是')
  select @config1334='是'
else
  select @config1334='否'*/
--挂号预算
if @ghbz=0
begin
	--开始挂号处理流程
	create table #mzghtmp        --临时存放挂号和诊疗费信息
	(
		ghxh ut_xh12 identity not null,
		ghlb smallint not null,
		cfzbz smallint not null,
		ksdm ut_ksdm not null,
		ksmc ut_mc32 null,
		ysdm ut_czyh not null,
		ysmc ut_mc64 null,
		lybz smallint not null,
		yyxh ut_xh12 not null,
		yyrq ut_rq16 null
		,zqdm	ut_ksdm null
		,xzks_id ut_ksdm null
		,zymzxh ut_xh12 null --中医名专序号
        ,pbmxxh ut_xh12 null --排班明细序号
        ,xmldxx varchar(800) null  --联动项目信息
         ,kmdm  ut_xmdm null  --科目代码
		,kmmc	ut_mc64 null
		,zqmc	ut_mc64 null
		,fbdm	ut_xmdm null
		,fbmc	ut_mc64 null
		,zbdm ut_zddm null
	)
	
	exec('insert into #mzghtmp(ghlb, cfzbz, ksdm, ysdm, lybz, yyxh, yyrq, zqdm, xzks_id,zymzxh,pbmxxh,xmldxx,kmdm,zbdm) 
		  select * from '+@tablename)

	if @@error<>0
	begin
		select "F","插入临时表时出错！"
		return
	end
	
	exec('drop table '+@tablename)   --递交过程完成
	create table #ghmx_ldxm   --联动项目库
	(
		ghxh ut_xh12 not null,
		xmdm ut_xmdm not null,
		xmsl ut_sl10 not null,
		xmdj varchar(12) null
	)
    declare @strtemp varchar(300),@xmdm_temp ut_xmdm,@xmsl_temp varchar(12),@ghzdxh_temp ut_xh12,@xmldxx_temp varchar(800),@xmdj_temp varchar(12)
    if exists(select 1 from #mzghtmp where xmldxx<>'')
	begin
		declare cs_mzgh_ld cursor for
		select ghxh,xmldxx from #mzghtmp for read only
		open cs_mzgh_ld
		fetch cs_mzgh_ld into @ghzdxh_temp,@xmldxx_temp
		while @@fetch_status=0
		begin  
			while charindex('$',@xmldxx_temp)>0 
			begin
				select @strtemp=substring(@xmldxx_temp,1,charindex('$',@xmldxx_temp)-1)
				select @strtemp  = substring(@strtemp,charindex('|',@strtemp)+1,len(@strtemp)-charindex('|',@strtemp))   --去除第一列
				select @xmdm_temp=substring(@strtemp,1,charindex('|',@strtemp)-1) 
				select @strtemp  = substring(@strtemp,charindex('|',@strtemp)+1,len(@strtemp)-charindex('|',@strtemp))    --去除第二列
				select @strtemp  = substring(@strtemp,charindex('|',@strtemp)+1,len(@strtemp)-charindex('|',@strtemp))    --去除第三列
				select @xmsl_temp=substring(@strtemp,1,charindex('|',@strtemp)-1) 
				--取其中的单价
		        select @xmdj_temp=substring(@strtemp,charindex('|',@strtemp)+1,len(@strtemp)-charindex('|',@strtemp))
				select @xmdj_temp=substring(@xmdj_temp,1,charindex('|',@xmdj_temp)-1)
                insert into #ghmx_ldxm(ghxh,xmdm,xmsl,xmdj)  
				values(@ghzdxh_temp,@xmdm_temp,@xmsl_temp,@xmdj_temp)
				select @xmldxx_temp=substring(@xmldxx_temp,charindex('$',@xmldxx_temp)+1,len(@xmldxx_temp)-charindex('$',@xmldxx_temp))
			end 			
			fetch cs_mzgh_ld into @ghzdxh_temp,@xmldxx_temp
		end
		close cs_mzgh_ld
		deallocate cs_mzgh_ld  
	end
	/*判断初复症*/
	if exists(select 1 from #mzghtmp where cfzbz=0)
	begin
		update #mzghtmp set cfzbz=0 where ghxh=1
		update #mzghtmp set cfzbz=1 where ghxh>1
	end

	select patid,blh,hzxm,wb,py,cardno,zypatid,sbh,qtkh,sfzh,sex,birth,lxdz,lxdh,yzbm,lxr,ybdm,pzh,dwbm,dwmc,qxdm,zhje,
	    ljje,zhszrq,zjrq,czyh,lrrq,tybz,cardtype,zhbz,memo,csd_s,csd_x,ghbz,ylxm,dyid,centerid,ekfmxm,czrq,gms,xgh,cth,
	    mrh,qth,hyzk,gjbm,email,lxsj,zcbm,zwbm,xlmc,ztqk,brjob,zydm,mzzyk,qysj,spzlx,gxybz,gxycbcs,gzdm,jgsrq,gxyszbz,
	    jkdabz,xl,brnldw,brnldw1,ssdw,tsbz,tyczyh,tyrq,lxr_s,qytt,qyys,rylb,fzid,grxp,tjlb_id,mzdm,bmmc,shhjh,lxdz_s,
	    lxdz_x,zggh,zl,xyclcs,chssid,bkh,mzdblh,zrysdm,ssks,nsccy,fzname,bjh,gwydm,sfzly,bmbz,bmhm,zzid,dahid,zcsq,zcbz,
	    zjghxh,tsbzdmjh,zjlx,empi,jhrxm,jhrzjlx,jhrsfzh,gxrq,qybrsyid,ay,birthtime,bmdm,
	    txfwbz,xxmc,yynr,tsts,qebzkh,yhdm,hfbz,lxrgx,lxrdh 
	into #brxxk from SF_BRXXK(nolock) where patid=@patid
	if @@rowcount=0 or @@error<>0
	begin
		select "F","挂号患者不存在！"
		return
	end

	--add by yangdi 2020.1.1 病人年龄通过标量函数计算，避免虚实岁的问题.
	select @pzh=pzh, @zhje=zhje, @cardno=cardno, @cardtype=cardtype, @tcljje=isnull(ljje,0), @brybdm=ybdm ,
		@hznl=dbo.FUN_GETBRNL_EX(birth,CONVERT(CHAR(8),GETDATE(),112)+CONVERT(CHAR(8),GETDATE(),108),1,0,NULL),@sex=sex from #brxxk

	--qinfj  20180529  病人年龄大于参数值时不允许挂号，例病人年龄大于31时不允许挂儿科      
 if exists(select 1 from YY_CONFIG (nolock) where  charindex(rtrim(@ksdm),config)>0 and id='1231')      
 BEGIN      
  if exists(select 1 from YY_CONFIG (nolock) where id='1230' and config<>'-1' and config<=@hznl)       
   begin      
    --select "F","挂号患者年龄大于14岁（包含14岁）不能挂儿科、儿童保健科！"   
    select top 1 "F","挂号患者年龄大于14岁（包含14岁）不能挂"+name+"！" from YY_KSBMK where id=@ksdm    --winning-dsong-chongqing   
    return      
   end      
 END    

  --add by yangdi 2019.3.13 挂号年龄控制    
if exists(select 1 from YY_CONFIG (nolock) where  charindex(rtrim(@ksdm),config)>0 and id='X004')      
 BEGIN      
  if exists(select 1 from YY_CONFIG (nolock) where id='1230' and config<>'-1' and config>@hznl)       
   begin      
    --select "F","挂号患者年龄小于14岁！"   
    select top 1 "F","挂号患者年龄小于14岁！不能挂"+name+"！" from YY_KSBMK where id=@ksdm    --winning-dsong-chongqing     
    return      
   end      
 END    
 
 IF RTRIM(@sex) = '男'      
 BEGIN      
     if exists(select 1 from YY_CONFIG (nolock) where  charindex(rtrim(@ksdm),config)>0 and id='1294')      
  BEGIN      
      --select "F","男性患者不能挂妇科、产科！"   
      select top 1 "F","男性患者不能挂"+name+"！" from YY_KSBMK where id=@ksdm    --winning-dsong-chongqing         
  return      
  END      
 END         

	-- 14岁以下儿科病人挂其他科室或医生要控制  add by jch 20160818
	if (@config1501 = '是') and (exists(select 1 from YY_CONFIG (nolock) where id='1230' and config<>'-1' and config>=@hznl))
	--and (not exists(select 1 from YY_CONFIG (nolock) where  charindex('"'+rtrim(@ksdm)+'"',config)>0 and id='1231'))
	begin
		-- 挂的非儿科科室
		if (not exists(select 1 from YY_CONFIG (nolock) where  charindex('"'+rtrim(@ksdm)+'"',config)>0 and id='1231')) 
		begin
			--没有权限的科室或没有权限的医生
			if (not exists(select 1 from GH_ETKSYSSZK where pbkm = @ksdm and pblx = 1)) and 
			(not exists(select 1 from GH_ETKSYSSZK where pbkm = @ysdm and pblx = 0))
			begin
				select 'F','您所挂的科室或医生，不具备看儿童患者的权限'
				return
			end
		end
	end 

	if (select config from YY_CONFIG (nolock) where id='1078')='否' or @ybdm=''
		select @ybdm=@brybdm

	--开始处理挂号项目
	create table #ghmx
	(
		ghxh ut_xh12 not null,
		xmdm ut_xmdm null,
		xmsl ut_sl10 not null,
		isghf  int   not null  --0:其他费1:挂号费2:诊疗费
	)

	if (select config from YY_CONFIG where id = '1204') = '是'
	begin
		if exists(select 1 from YY_CONFIG (nolock) where id='1188' and config = '是')  
		begin 
			declare @ghsl int,@xzybdm varchar(100),@flag varchar(1)
		  --大华模式合并 aorigele 2011-6-2	
	      --if not exists(select 1 from YY_CONFIG (nolock) where id='1218' and config = '否')
			if @hxfs_new = 3
			begin
				-- 新版预约挂号使用(限制医保病人每日只能挂两个号且为两个不同科室/医生，不要此功能可屏蔽本段)  add by sdb 2010-11-19  		   
				--读取1203 参数设置的值  
				--declare @xzybdm varchar(100);  
				select @xzybdm = config from YY_CONFIG where id = '1203'   
				if @ghlb = 0 --普通科室  
				begin  
					if exists(    
						select 1  from GH_GHZDK a(nolock)   
						where a.patid = @patid   
							and SUBSTRING(a.ghrq,1,8) = SUBSTRING(@now,1,8)     
							and ghlb = @ghlb      
							and ksdm = @ksdm  
							and ybdm not in (@xzybdm) ---lza0324   
							and fzbz in('0','1','2','3')  --0:未分诊，1分诊，2就诊，3结束就诊 ４:结束就诊（其它）5:结束中（其它)    
							and jlzt = 0    
						)     
					begin    
						if @lybz='2' --自助机直接提示  
						begin  
							select 'F','您已经挂过该科室，不能再挂'  --医保病人每日只能挂两个号且为两个不同科室    
							return  
						end  
					end    
				end    
				else if @ghlb = 2  --医生    
				begin    
					if exists(    
						select 1 from GH_GHZDK a(nolock)   
						where a.patid = @patid   
						and SUBSTRING(a.ghrq,1,8) = SUBSTRING(@now,1,8)     
						and ghlb = @ghlb      
						and ysdm = @ysdm  
						and ybdm not in (@xzybdm) ---lza0324   
						and fzbz in('0','1','2','3')  --0:未分诊，1分诊，2就诊，3结束就诊 ４:结束就诊（其它）5:结束中（其它)    
						and jlzt = 0    
						)     
					begin    
						if @lybz='2' --自助机直接提示  
						begin  
							select 'F','您已经挂过该医生，不能再挂 '  --医保病人每日只能挂两个号且为两个不同科室    
							return  
						end  
					end   
				end;     
			end              
		  -- 新版预约挂号使用(限制医保病人每日只能挂两个号且为两个不同科室/医生，不要此功能可屏蔽本段) add by sdb 2010-11-19 END 
		end
		else
		begin
			-- 新版预约挂号使用(限制医保病人每日只能挂两个号且为两个不同科室/医生，不要此功能可屏蔽本段)  add by sdb 2010-11-19
			if exists(select 1 from YY_CONFIG (nolock) where id='1188' and config = '是')
			begin				
				select @xzybdm = config from YY_CONFIG(nolock) where id = '1203'
				
				set @flag = '0' 
				
				if CHARINDEX('"' + RTrim(LTRIM(@ybdm)) + '"',@xzybdm) <> 0 
					select @flag = '1'	  
				 
				if @flag = '0'  
				begin
					if @ghlb = 0 --普通科室
					begin
						select @ghsl = COUNT(*) from GH_GHZDK a(nolock) where a.patid = @patid and SUBSTRING(a.ghrq,1,8) = SUBSTRING(@now,1,8)
						if @ghsl >= 2
						begin
							select 'F','医保病人每日只能挂两个号且为两个不同科室'
							return 
						end

						if exists(
							select 1 from GH_GHZDK a(nolock) where a.patid = @patid and SUBSTRING(a.ghrq,1,8) = SUBSTRING(@now,1,8) 
								and ghlb = 0  
								and ksdm = @ksdm
								and fzbz in('0','1','2')  --0:未分诊，1分诊，2就诊，3结束就诊 ４:结束就诊（其它）5:结束中（其它)
								and jlzt = 0
						)
						begin
							select 'F','请先完成上次就诊'  --医保病人每日只能挂两个号且为两个不同科室
							return
						end
					end
					else if @ghlb = 2  --医生
					begin
						select @ghsl = COUNT(*) from GH_GHZDK a(nolock) where a.patid = @patid and SUBSTRING(a.ghrq,1,8) = SUBSTRING(@now,1,8)
						if @ghsl >= 2
						begin
							select 'F','医保病人每日只能挂两个号且为两个不同医生'
							return 
						end
						
						if exists(
							select 1 from GH_GHZDK a(nolock) where a.patid = @patid and SUBSTRING(a.ghrq,1,8) = SUBSTRING(@now,1,8) 
								and ghlb = 2 
								and ysdm = @ysdm 
								and fzbz in('0','1','2')  --0:未分诊，1分诊，2就诊，3结束就诊 ４:结束就诊（其它）5:结束中（其它)
								and jlzt = 0
						)
						begin
							select 'F','请先完成上次就诊'
							return
						end  
					end		     
				end
			end	
			-- 新版预约挂号使用(限制医保病人每日只能挂两个号且为两个不同科室/医生，不要此功能可屏蔽本段) add by sdb 2010-11-19 END 
		end
	end
	
	select @config = config from YY_CONFIG(nolock) where id='1049'
	select @config1 = config from YY_CONFIG (nolock)where id='1051'
	select @config2 = config from YY_CONFIG(nolock) where id='1053'
	if @@rowcount=0 or @@error<>0
	begin
		select "F","免挂号费挂号设置不正确！"
		return
	end

	select @scybdm = config from YY_CONFIG(nolock) where id='1030'
	if @@rowcount=0 or @@error<>0
	begin
		select "F","伤残费别设置不正确！"
		return
	end

	select @ybldbz = config from YY_CONFIG(nolock) where id='1059'
	if @@rowcount=0 or @@error<>0
	begin
		select "F","医保挂号联动设置不正确！"
		return
	end

	select @ghldbz = config from YY_CONFIG(nolock) where id='1004'
	if @@rowcount=0 or @@error<>0
	begin
		select "F","挂号联动设置不正确！"
		return
	end


	select @yjyebz = config from YY_CONFIG(nolock) where id='1058'
	if @@rowcount=0 or @@error<>0
	begin
		select "F","充值卡余额不足是否允许继续收费设置不正确！"
		return
	end

	select @yjdybz = config from YY_CONFIG(nolock) where id='1056'
	if @@rowcount=0 or @@error<>0
	begin
		select "F","使用充值卡是否打印挂号发票设置不正确！"
		return
	end

	select @mzlcbz = config from YY_CONFIG(nolock) where id='0037'
	if @@rowcount=0 or @@error<>0
	begin
		select "F","门诊流程模式设置不正确！"
		return
	end
	
	select @csybdm = ltrim(rtrim(config)) from YY_CONFIG(nolock) where id = '1106'
	if @@error<>0
	begin
		select "F","慈善医保代码设置不正确！"
		return
	end
	
	--划价可以录入的治疗项目
	if exists(select 1 from YY_CONFIG (nolock) where charindex('"'+rtrim(@ybdm)+'"',config)>0 and id='2082')
		select @tcljbz=1
	else
		select @tcljje=0
	--统筹金额独立配置的医保代码
	if exists(select 1 from YY_CONFIG (nolock) where charindex('"'+rtrim(@ybdm)+'"',config)>0 and id='0115')
	begin
		select @tcljje=tcljje from YY_BRLJXXK(nolock)  where cardno = @cardno and cardtype = @cardtype		
	end
	--工本费
	if (@cardtype='2') or (@cardtype='1' and datalength(@cardno)=28)
		insert into #ghmx select a.ghxh, b.config, 1,0 from #mzghtmp a, YY_CONFIG b  
		where a.cfzbz=0 and b.id in ('1002')  --病历工本费
	else
		insert into #ghmx select a.ghxh, b.config, 1,0 from #mzghtmp a, YY_CONFIG b  
		where a.cfzbz=0 and b.id in ('1002', '1003')  
	-- 根据不同需要插入工本费或磁卡费
	INSERT INTO #ghmx SELECT a.ghxh, b.config, 1, 0 FROM #mzghtmp a, YY_CONFIG b
	WHERE a.cfzbz=2 AND b.id IN ("1002")	-- 复诊补收工本费
	INSERT INTO #ghmx SELECT a.ghxh, b.config, 1, 0 FROM #mzghtmp a, YY_CONFIG b
	WHERE a.cfzbz=3 AND b.id IN ("1003")	-- 复诊补收磁卡费

	select @zfbz=zfbz, @pzlx=pzlx, @brlx=brlxdm, @qkbz1=zhbz, @jsfs=jsfs,@tsrydm=tsrydm, @hysybz=hysybz from YY_YBFLK (nolock) where ybdm=@ybdm
	if @@rowcount=0 or @@error<>0
	begin
		select "F","患者费用类别不正确！"
		return
	end
	
	select @hykmsbz = config from YY_CONFIG(nolock) where id='0099'
	if @@error<>0
	begin
		select "F","门诊会员卡模式设置不正确！"
		return
	end

	--取预约冻结的金额
	select @djje=0
	select @djje=isnull(djje,0) from GH_GHYYK(nolock) where xh=@yyxh and djbz=1

	if @hykmsbz=0
	begin
		select @yjye=isnull(yjye,0)+@djje,@gsbz=gsbz from YY_JZBRK(nolock) where patid=@patid and jlzt=0
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
	if exists(select 1 from #mzghtmp where ghlb in (0,1,5,7,8)) and @iskmgh=0 --普通,急诊,特殊挂号, 免挂号费
	begin
		--大华模式直接使用公共版模式 aorigele 2011-6-2
		--if exists(select  * from YY_CONFIG (nolock) where id='1218' and config = '否')		
        -- 新版预约挂号使用aorigele 20100730
	
		if exists(select 1 from YY_CONFIG (nolock) where id='1188' and config = '是') 
		   and (exists(select 1 from #mzghtmp where pbmxxh>=0 and ghlb in (0,1,5,8)))--dingsong
		begin
			
			--急诊、特殊挂号、免挂号费  按老流程走，因为1188改动没有设置急诊、特殊挂号费
			insert into #ghmx select aa.ghxh, b.ghfdm, 1, 1
			 from #mzghtmp aa,GH_YY_PBZB a(nolock),GH_YY_PBZBMX b(nolock)  
			where a.pbzbid = b.pbzbid and b.pbmxid = aa.pbmxxh
--			  and ((aa.ysdm = a.pbkm)or(aa.ksdm = a.pbkm))   modfiy by yfq for:按照前台传进来的pbmxid取排班中的挂号费
			insert into #ghmx select aa.ghxh, b.zlfdm, 1, 2
			 from #mzghtmp aa,GH_YY_PBZB a(nolock),GH_YY_PBZBMX b(nolock)  
			where a.pbzbid = b.pbzbid and b.pbmxid = aa.pbmxxh
--			  and ((aa.ysdm = a.pbkm)or(aa.ksdm = a.pbkm))   modfiy by yfq for:按照前台传进来的pbmxid取排班中的诊查费
            ----add by sqf  for :如果一次挂号选多科室，其中有的是新排版有的是老排版则挂号费算不对
			insert into #ghmx select a.ghxh, (case a.ghlb when 0 then b.ghf_pt when 1 then b.ghf_jz when 5  then b.ghf_pt when 7 then b.ghf_pt when 8 then b.ghf_pt else b.ghf_ts end), 1,1 
				from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb in (0,1,4,5,7,8) and b.id=a.ksdm
                     and a.pbmxxh <= 0
			insert into #ghmx select a.ghxh, (case a.ghlb when 0 then b.zlf_pt when 1 then b.zlf_jz when 4 then b.zlf_ts else b.zlf_pt end), 1,2
			from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb in (0,1,4,5,7,8) and b.id=a.ksdm
                     and a.pbmxxh <= 0
			 
		end		
		else --老模式兼容
		begin
			if @config1='是' and @config2='是' --费用取自医生而不科室,而且因为医生没有急诊费用，所以取普通费用 --agg 2003.08.27
			begin
			    if @ghlb = 7
			    begin
		--			if @ybdm<>@scybdm
		--			begin
					if @config='是' --公费病人挂第二科室起不收挂号费
				    begin
				    if isnull(@ysdm,'') <> ''  --专家
				    begin
						insert into #ghmx select a.ghxh,'', 1,1 
							from #mzghtmp a, YY_ZGBMK b(nolock) where a.ghlb in (0,1,4,5,7,8) and b.id=a.ysdm
							
						insert into #ghmx select a.ghxh,b.zlf, 1,2 
							from #mzghtmp a, YY_ZGBMK b(nolock) where a.ghlb in (0,1,4,5,7,8) and b.id=a.ysdm
					end
					else  --科室
					begin
					    insert into #ghmx select a.ghxh,'', 1,1 
							from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb in (0,1,4,5,7,8) and b.id=a.ksdm
						insert into #ghmx select a.ghxh,b.zlf_pt, 1,2
							from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb in (0,1,4,5,7,8) and b.id=a.ksdm
					end
				end
				else
					if isnull(@ysdm,'') <> ''  --专家
					begin
						insert into #ghmx select a.ghxh,b.ghf, 1,1 
							from #mzghtmp a, YY_ZGBMK b(nolock) where a.ghlb in (0,1,4,5,7,8) and b.id=a.ysdm
							
						insert into #ghmx select a.ghxh,b.zlf, 1,2 
							from #mzghtmp a, YY_ZGBMK b(nolock) where a.ghlb in (0,1,4,5,7,8) and b.id=a.ysdm	
					end
					else  --科室
					begin
					    insert into #ghmx select a.ghxh,'', 1,1 
							from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb in (0,1,4,5,7,8) and b.id=a.ksdm
						insert into #ghmx select a.ghxh,b.zlf_pt, 1,2
							from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb in (0,1,4,5,7,8) and b.id=a.ksdm
					end
				end
				else
				begin
				    if isnull(@ysdm,'')<>'' and @ysbz=1 and @ksorys=1 and exists(select 1 from #mzghtmp where ghlb in (0)) --普通挂号，选医生，按医生的ghf，zlf收费
					begin
						insert into #ghmx select a.ghxh,  b.ghf , 1,1 
							from #mzghtmp a, YY_ZGBMK b(nolock) where a.ghlb in (0) and b.id=a.ysdm
						insert into #ghmx select a.ghxh,  b.zlf , 1,2 
							from #mzghtmp a, YY_ZGBMK b(nolock) where a.ghlb in (0) and b.id=a.ysdm
					end
					else
					begin 	
		--			if @ybdm<>@scybdm
		--			begin
						if @config='是'                     
							insert into #ghmx select a.ghxh, (case a.ghlb when 0 then b.ghf_pt when 1 then b.ghf_jz when 5  then b.ghf_pt when 7 then '' when 8 then b.ghf_pt else b.ghf_ts end), 1,1 
								from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb in (0,1,4,5,7,8) and b.id=a.ksdm

						else
							insert into #ghmx select a.ghxh, (case a.ghlb when 0 then b.ghf_pt when 1 then b.ghf_jz  when 5  then b.ghf_pt when 7 then b.ghf_pt when 8 then b.ghf_pt else b.ghf_ts end), 1,1 
								from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb in (0,1,4,5,7,8) and b.id=a.ksdm
		--			end

						insert into #ghmx select a.ghxh, (case a.ghlb when 0 then b.zlf_pt when 1 then b.zlf_jz when 4 then b.zlf_ts else b.zlf_pt end), 1,2
							from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb in (0,1,4,5,7,8) and b.id=a.ksdm
					end 
				end
			end
			else 
			begin
	-- 					select 't',@ksdm,@ysbz,@ksorys ,* from #mzghtmp where ghlb in (0) --hyh
	-- 			return  	
				 --if isnull(@ksdm,'')<>'' and @ysbz=1 and @ksorys=1 and exists(select 1 from #mzghtmp where ghlb in (0)) --普通挂号，选医生，按医生的ghf，zlf收费 
				if isnull(@ysdm,'')<>'' and @ysbz=1 and @ksorys=1 and exists(select 1 from #mzghtmp where ghlb in (0)) --普通挂号，选医生，按医生的ghf，zlf收费
				begin
					insert into #ghmx select a.ghxh,  b.ghf , 1,1 
						from #mzghtmp a, YY_ZGBMK b(nolock) where a.ghlb in (0) and b.id=a.ysdm
					insert into #ghmx select a.ghxh,  b.zlf , 1,2 
						from #mzghtmp a, YY_ZGBMK b(nolock) where a.ghlb in (0) and b.id=a.ysdm
				end
				else
				begin 	
	--			if @ybdm<>@scybdm
	--			begin
					if @config='是'                     
						insert into #ghmx select a.ghxh, (case a.ghlb when 0 then b.ghf_pt when 1 then b.ghf_jz  when 5  then b.ghf_pt when 7 then '' when 8 then isnull(b.ghf_pt,b.ghf_jz) else b.ghf_ts end), 1,1 
							from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb in (0,1,4,5,7,8) and b.id=a.ksdm

                    else
						insert into #ghmx select a.ghxh, (case a.ghlb when 0 then b.ghf_pt when 1 then b.ghf_jz  when 5  then b.ghf_pt when 7 then b.ghf_pt when 8 then isnull(b.ghf_pt,b.ghf_jz) else b.ghf_ts end), 1,1 
							from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb in (0,1,4,5,7,8) and b.id=a.ksdm
	--			end

					insert into #ghmx select a.ghxh, (case a.ghlb when 0 then b.zlf_pt when 1 then b.zlf_jz when 4 then b.zlf_ts when 8 then isnull(b.zlf_pt,b.zlf_jz) else b.zlf_pt end), 1,2
						from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb in (0,1,4,5,7,8) and b.id=a.ksdm
				end
			end
/*
            if exists(select 1 from #mzghtmp where ghlb in (7)) --免挂号费
	        begin
				if isnull(@ysdm,'')<>'' and exists(select 1 from YY_CONFIG WHERE id ='1105' and config = '是')
                begin
					delete from #ghmx --需要删除，前面有可能已经插过了
					insert into #ghmx select a.ghxh,  b.zlf , 1,2 
						from #mzghtmp a, YY_ZGBMK b where a.ghlb in (7) and b.id=a.ysdm				
				end
			end
*/
		end;
		if (@ybldbz='是' or @pzlx='0') and @ghldbz='是' --医保病人挂号是否允许联动项目
			--insert into #ghmx select a.ghxh, b.ypdm, b.xmsl,0 
			--	from #mzghtmp a, GH_GHLDK b where a.ghlb in (0,1,4,7) and b.id=a.ksdm and b.lb=1
            insert into #ghmx(ghxh,xmdm,xmsl,isghf) select ghxh,xmdm,xmsl,0 from #ghmx_ldxm
		/*
        if (@ybldbz='是' or @pzlx='0') and @ghldbz='是' --医保病人挂号是否允许联动项目
			insert into #ghmx select a.ghxh, b.ypdm, b.xmsl,0 
				from #mzghtmp a, GH_GHLDK b 
				where a.ghlb in (0,1,4,7) and b.id=a.ysdm and b.lb=0
         */
	end
	
	if exists(select 1 from #mzghtmp where ghlb=2) and @iskmgh=0 --专家
	begin 
		--大华模式直接使用公共版模式 aorigele 2011-6-2
		--if exists(select 1 from YY_CONFIG (nolock) where id='1218' and config = '否')
		-- 新版预约挂号使用aorigele 20100730
		if exists(select 1 from YY_CONFIG (nolock) where id='1188' and config = '是')
		   and (exists(select 1 from #mzghtmp where pbmxxh>=0 ))
		begin	
			--急诊、特殊挂号、免挂号费  按老流程走，因为1188改动没有设置急诊、特殊挂号费
			insert into #ghmx select aa.ghxh, b.ghfdm, 1, 1
			 from #mzghtmp aa,GH_YY_PBZB a(nolock),GH_YY_PBZBMX b(nolock)  
			where a.pbzbid = b.pbzbid and b.pbmxid = aa.pbmxxh
			  and ((aa.ysdm = a.pbkm)or(aa.ksdm = a.pbkm)) and aa.ghlb=2
			insert into #ghmx select aa.ghxh, b.zlfdm, 1, 2
			 from #mzghtmp aa,GH_YY_PBZB a(nolock),GH_YY_PBZBMX b(nolock)  
			where a.pbzbid = b.pbzbid and b.pbmxid = aa.pbmxxh
			  and ((aa.ysdm = a.pbkm)or(aa.ksdm = a.pbkm)) and aa.ghlb=2
		end
		else
		begin
			insert into #ghmx select a.ghxh, b.ghf, 1 ,1
				from #mzghtmp a, YY_ZGBMK b where a.ghlb=2 and b.id=a.ysdm
			insert into #ghmx select a.ghxh, b.zlf, 1 ,2
				from #mzghtmp a, YY_ZGBMK b where a.ghlb=2 and b.id=a.ysdm
		end;
		if exists(select 1 from #mzghtmp where zymzxh <> 0)
		begin
			update #ghmx set xmdm = b.ghf
				from #mzghtmp a, GH_ZYY_ZJGHFSZ b(nolock),#ghmx c
				where a.zymzxh = b.xh and b.jlzt = 0 and c.isghf = 1 
					and ltrim(rtrim(isnull(b.ghf,''))) <> ''
		end 		    
		--add by sdb 2011-04-25 自助挂号中是否自动判断名老专家存在初诊和复诊挂号费的差异(上海中医：一年内没看过该医生，算初诊) BEGIN
		if (select config from YY_CONFIG (nolock) where id = '1219') = '是'
		begin
			if exists (select 1 from GH_ZYY_ZJGHFSZ(nolock) where id = @ysdm and jlzt = 0 and isnull(ghf,'') <> '')
			begin
				declare @ghf_temp ut_xmdm
				
				if not exists(select 1 from GH_GHZDK_MZ(nolock) where patid = @patid and ysdm = @ysdm)
				begin--若一年内没看过该医生，则做为初诊，挂号费收取最大值
				    select @ghf_temp = a.ghf from GH_ZYY_ZJGHFSZ a(nolock), YY_SFXXMK b(nolock),#ghmx c 
						where a.ghf = b.id and a.jlzt = 0 and c.isghf = 1 and a.id = @ysdm order by b.xmdj asc				

					update #ghmx set xmdm = @ghf_temp where isghf = 1
				end
				else
				begin--否则作为复诊病人，挂号费收取最小值
				    select @ghf_temp = a.ghf from GH_ZYY_ZJGHFSZ a(nolock), YY_SFXXMK b(nolock),#ghmx c 
						where a.ghf = b.id and a.jlzt = 0 and c.isghf = 1 and a.id = @ysdm order by b.xmdj desc				

					update #ghmx set xmdm = @ghf_temp where isghf = 1

				end
			end
		end
		--add by sdb 2011-04-25 自助挂号中是否自动判断名老专家存在初诊和复诊挂号费的差异 END
		
		if (@ybldbz='是' or @pzlx='0') and @ghldbz='是' --医保病人挂号是否允许联动项目
           insert into #ghmx(ghxh,xmdm,xmsl,isghf) select ghxh,xmdm,xmsl,0 from #ghmx_ldxm
	end
	
	if exists(select 1 from #mzghtmp where ghlb=3) and @iskmgh=0 --点名专家
	begin
		--20050302 增加对龙华民生卡的处理
		declare @zhdcsx ut_money   
select @zhdcsx=isnull(zhdcsx,0) 
    from SF_BRXXK a(nolock) 
    left join YY_YBFLK b(nolock) on a.ybdm=b.ybdm 
    where a.patid=@patid
	
		if @zhdcsx > 0   
		begin  
			insert into #ghmx select a.ghxh, b.ghfdm2, 1 ,1  
			from #mzghtmp a, GH_DMZJK b(nolock) where a.ghlb=3 and b.id=a.ysdm  and a.ksdm = b.ksdm
		end  
		else  
			insert into #ghmx select a.ghxh, b.ghfdm1, 1 ,1  
			from #mzghtmp a, GH_DMZJK b(nolock) where a.ghlb=3 and b.id=a.ysdm and a.ksdm = b.ksdm

		insert into #ghmx select a.ghxh, b.zlfdm, 1,2 
		from #mzghtmp a, GH_DMZJK b(nolock) where a.ghlb=3 and b.id=a.ysdm and a.ksdm = b.ksdm
		
		if (@ybldbz='是' or @pzlx='0') and @ghldbz='是' --医保病人挂号是否允许联动项目
            insert into #ghmx(ghxh,xmdm,xmsl,isghf) select ghxh,xmdm,xmsl,0 from #ghmx_ldxm
	end

	if exists(select 1 from #mzghtmp where ghlb=6) and @iskmgh=0 --外宾挂号
	begin
		if exists (select 1 from YY_CONFIG b(nolock) where b.id in ('1019') and config <> '' )
			insert into #ghmx select a.ghxh, config, 1 ,1
			from #mzghtmp a, YY_CONFIG b(nolock) where a.ghlb=6 and b.id in ('1019')  --外宾挂号统一价（挂号费代码）
		else
		begin
			insert into #ghmx select a.ghxh, b.ghf, 1 ,1
				from #mzghtmp a, YY_ZGBMK b(nolock) where a.ghlb=6 and b.id=a.ysdm
			insert into #ghmx select a.ghxh, b.ghf_pt, 1,1
				from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb=6 and b.id=a.ksdm and not exists(select 1 from #ghmx c where a.ghxh=c.ghxh and c.isghf=1)
		end
		insert into #ghmx select a.ghxh, b.zlf, 1 ,2
			from #mzghtmp a, YY_ZGBMK b where a.ghlb=6 and b.id=a.ysdm
		--tony 2003.09.12 如果不是专家挂号，就取科室的诊疗费
		insert into #ghmx select a.ghxh, b.zlf_pt, 1,2
			from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb=6 and b.id=a.ksdm and not exists(select 1 from #ghmx c where a.ghxh=c.ghxh and c.isghf=2)
			
		if (@ybldbz='是' or @pzlx='0') and @ghldbz='是' --医保病人挂号是否允许联动项目
            insert into #ghmx(ghxh,xmdm,xmsl,isghf) select ghxh,xmdm,xmsl,0 from #ghmx_ldxm
	end
	if exists(select 1 from #mzghtmp where ghlb=4) and @iskmgh=0 --特殊挂号 add by aorigele 20120210
	begin
		if exists(select 1 from YY_CONFIG (nolock) where id='1188' and config = '是')
		   and (exists(select 1 from #mzghtmp where pbmxxh>=0))
		begin	
			IF EXISTS(SELECT 1 FROM YY_CONFIG (NOLOCK) WHERE id = '1691' AND config = '是')
			BEGIN
				if isnull(@ysdm,'') <> ''  --专家
				begin
						insert into #ghmx select a.ghxh,b.ghf1, 1,1 
						from #mzghtmp a, YY_ZGBMK b(nolock) where a.ghlb in (4) and b.id=a.ysdm
							
						insert into #ghmx select a.ghxh,b.zlf, 1,2 
						from #mzghtmp a, YY_ZGBMK b(nolock) where a.ghlb in (4) and b.id=a.ysdm	
				end
				else  --科室
				begin
						insert into #ghmx select a.ghxh,b.ghf_ts, 1,1 
						from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb in (4) and b.id=a.ksdm
						insert into #ghmx select a.ghxh,b.zlf_ts, 1,2
						from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb in (4) and b.id=a.ksdm
				end				
			END
			ELSE
			BEGIN
				--急诊、特殊挂号、免挂号费  按老流程走，因为1188改动没有设置急诊、特殊挂号费
				insert into #ghmx select aa.ghxh, b.ghfdm, 1, 1
				 from #mzghtmp aa,GH_YY_PBZB a(nolock),GH_YY_PBZBMX b(nolock)  
				where a.pbzbid = b.pbzbid and b.pbmxid = aa.pbmxxh
						and ((aa.ysdm = a.pbkm)or(aa.ksdm = a.pbkm)) and aa.ghlb=4
				insert into #ghmx select aa.ghxh, b.zlfdm, 1, 2
				 from #mzghtmp aa,GH_YY_PBZB a(nolock),GH_YY_PBZBMX b(nolock)  
				where a.pbzbid = b.pbzbid and b.pbmxid = aa.pbmxxh
						and ((aa.ysdm = a.pbkm)or(aa.ksdm = a.pbkm)) and aa.ghlb=4				
			END
		end
		else
		begin
				if isnull(@ysdm,'') <> ''  --专家
				begin
						insert into #ghmx select a.ghxh,b.ghf1, 1,1 
						from #mzghtmp a, YY_ZGBMK b(nolock) where a.ghlb in (4) and b.id=a.ysdm
							
						insert into #ghmx select a.ghxh,b.zlf, 1,2 
						from #mzghtmp a, YY_ZGBMK b(nolock) where a.ghlb in (4) and b.id=a.ysdm	
				end
				else  --科室
				begin
						insert into #ghmx select a.ghxh,b.ghf_ts, 1,1 
						from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb in (4) and b.id=a.ksdm
						insert into #ghmx select a.ghxh,b.zlf_ts, 1,2
						from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb in (4) and b.id=a.ksdm
				end
		end;
		if (@ybldbz='是' or @pzlx='0') and @ghldbz='是' --医保病人挂号是否允许联动项目
            insert into #ghmx(ghxh,xmdm,xmsl,isghf) select ghxh,xmdm,xmsl,0 from #ghmx_ldxm
	end;
	if exists(select 1 from #mzghtmp where ghlb=9) and @iskmgh=0 --预约
	begin
		-- 新版预约挂号使用aorigele 20100730
		if exists(select 1 from YY_CONFIG (nolock) where id='1188' and config = '是')
		begin
			select @gfyyxh = zjxh,@yyghlb = yyghlb from GH_SH_GHYYK(nolock) where xh = @yyxh

			insert into #ghmx select aa.ghxh, b.ghfdm, 1, 1
			 from #mzghtmp aa,GH_YY_PBZB a(nolock),GH_YY_PBZBMX b(nolock)  
			where a.pbzbid = b.pbzbid and b.pbmxid = @gfyyxh
			  and ((aa.ysdm = a.pbkm)or(aa.ksdm = a.pbkm))
			insert into #ghmx select aa.ghxh, b.zlfdm, 1, 2
			 from #mzghtmp aa,GH_YY_PBZB a(nolock),GH_YY_PBZBMX b(nolock)  
			where a.pbzbid = b.pbzbid and b.pbmxid = @gfyyxh
			  and ((aa.ysdm = a.pbkm)or(aa.ksdm = a.pbkm))
--			select * from GH_YY_PBZBMX
			if exists(select 1 from #ghmx_ldxm)	--add by liuchun 添加预约挂号联动项目
			begin
				if (@ybldbz='是' or @pzlx='0') and @ghldbz='是' 
				begin
					insert into  #ghmx select ghxh,xmdm,xmsl,0 from #ghmx_ldxm   
					if @@ERROR <> 0 or @@ROWCOUNT = 0
					begin
						select 'F','新版预约挂号添加联动项目出错'
						return
					end
				end
			end
		end
		-- add by aorigele end;
		else --兼容
		begin
			select @gfyyxh = zjxh from GH_GHYYK(nolock) where xh = @yyxh
			insert into #ghmx select a.ghxh, b.ghfdm, 1, 1
				from #mzghtmp a, GH_YYZJK b(nolock) where a.ghlb=9 and (b.id=a.ysdm or (b.id='-1' and b.ksdm=a.ksdm)) and b.xh = @gfyyxh
			insert into #ghmx select a.ghxh, b.zlfdm, 1, 2 
				from #mzghtmp a, GH_YYZJK b(nolock) where a.ghlb=9 and (b.id=a.ysdm or (b.id='-1' and b.ksdm=a.ksdm)) and b.xh = @gfyyxh
			if exists(select 1 from #ghmx_ldxm)	--add by liuchun 添加预约挂号联动项目
			begin
				if (@ybldbz='是' or @pzlx='0') and @ghldbz='是' 
				begin
					insert into  #ghmx select ghxh,xmdm,xmsl,0 from #ghmx_ldxm   
					if @@ERROR <> 0 or @@ROWCOUNT = 0
					begin
						select 'F','预约挂号添加联动项目出错'
						return
					end
				end
			end
		end;
	end
	
	if @iskmgh=1--yxc
	begin
		update 	aa set aa.kmmc=a.kmmc,aa.fbdm=a.fbdm,aa.fbmc=a.fbmc,aa.zqmc=a.bmmc,aa.zqdm=a.bmdm
		from #mzghtmp aa,GH_GHKMK a(nolock) 
		where aa.kmdm = a.kmdm  
 		if @@error <>0 
		begin
			select 'F','更新科目信息出错！'
			return
		end
		delete from #ghmx where isghf in (1,2) --yxc2 
		--急诊、特殊挂号、免挂号费  按老流程走，因为1188改动没有设置急诊、特殊挂号费
		insert into #ghmx select aa.ghxh, b.ghfdm, 1, 1
		 from #mzghtmp aa,GH_GHKMK a(nolock),GH_GHFBFLK b(nolock),GH_KM_PBZBMX c (nolock)
		where aa.kmdm = a.kmdm and a.fbdm = b.fbdm    and aa.pbmxxh=c.pbmxid and aa.kmdm=c.pbkm
--			  
		insert into #ghmx select aa.ghxh, b.zlfdm, 1, 2
		 from #mzghtmp aa,GH_GHKMK a(nolock),GH_GHFBFLK b(nolock)  ,GH_KM_PBZBMX c (nolock)
		where aa.kmdm = a.kmdm and a.fbdm = b.fbdm    and aa.pbmxxh=c.pbmxid and aa.kmdm=c.pbkm
		
		--insert into #ghmx select a.ghxh, (case a.ghlb when 0 then b.ghf_pt when 1 then b.ghf_jz when 7 then b.ghf_pt when 8 then b.ghf_pt else b.ghf_ts end), 1,1 
		--	from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb in (0,1,4,7,8) and b.id=a.ksdm
--                  and a.pbmxxh <= 0
		--insert into #ghmx select a.ghxh, (case a.ghlb when 0 then b.zlf_pt when 1 then b.zlf_jz when 4 then b.zlf_ts else b.zlf_pt end), 1,2
		--from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb in (0,1,4,7,8) and b.id=a.ksdm
--                  and a.pbmxxh <= 0

		if @ghlb=9
		begin
			if (@ybldbz='是' or @pzlx='0') and @ghldbz='是' --医保病人挂号是否允许联动项目
			   insert into #ghmx(ghxh,xmdm,xmsl,isghf) select ghxh,xmdm,xmsl,0 from #ghmx_ldxm
		end
	end	
	
	--处理根据医保代码设置挂号费诊疗费代码（南京医保有老年医保项目代码）
	--注意如果一次挂多个不号，且挂号类别不同，则无法处理 
	update a set xmdm=b.xmdm 
	from #ghmx a,GH_TSGHFZLF b(nolock)
	where b.ybdm=@ybdm and a.isghf=b.isghf and @ghlb=b.ghlb
	if @@error <>0 
	begin
		select 'F','用特殊挂号费诊疗费更新挂号费诊疗费时出错！'
		return
	end 
	
	/*add by mxd for vsts:237239 2017.12.05*/
	--医生站挂号控制 0=普通，1=急诊，2=专家，3=点名专家，4=特殊挂号，5=义诊，6=外宾挂号,7= 免挂号费, 8=免费挂号
	--and @ghlb<>'7' add by mxd for bug:290373 2018.04.23 @ghlb=7在上面插入的xmdm为空，且下面还会删掉@ghlb=7的ghf，所以这里不需判断@ghlb=7
	if not exists(select 1 from  #ghmx where  isnull(xmdm,'')<>'' and isghf = 1 ) and @ghlb<>'7'--and  (@ghlb in (0,1,2,3,4,6))
	begin 
		select "F","挂号费设置不对，请先设置挂号费"  
		return 
	end
	if not exists(select 1 from  #ghmx where  isnull(xmdm,'')<>'' and isghf = 2 ) --and  (@ghlb in (0,1,2,3,4,6))
	begin 
		select "F","诊疗费设置不对，请先设置诊疗费"  
		return 
	end
	/*end add by mxd for vsts:237239 2017.12.05*/	

    --add by lsz 2018-02-05 儿童诊疗费 要求201788
    declare @config1630 int
    if exists(select 1 from YY_CONFIG(nolock) where id='1630' and ltrim(rtrim(config))<>'')
    begin
       select @config1630=cast(rtrim(config) as int) from YY_CONFIG(nolock) where id='1630' 
	  if @config1630>0 and @config1662='否'
	   begin
           update #ghmx set xmdm=dbo.fun_gh_getetzlf(@patid,xmdm) where isghf=2
	   end
    end
			
    /*
	update #mzghtmp set ksdm=(case when a.ghlb in (2,3,6) then b.ks_id else a.ksdm end), ysmc=b.name, xzks_id=isnull(b.xzks_id,b.ks_id)
		from #mzghtmp a, YY_ZGBMK b (nolock)
		where b.id=a.ysdm
    */ 
	update #mzghtmp set ysmc=b.name, xzks_id=isnull(b.xzks_id,b.ks_id)--yyx 20090610
		from #mzghtmp a, YY_ZGBMK b (nolock)
		where b.id=a.ysdm
	/* panlian 2004-03-12 70岁以上免挂号费 */
	select @config3=config from YY_CONFIG where id='1071' 
	if @config3 = '否'
	begin
		select @birth=birth from SF_BRXXK(nolock) where patid=@patid
		if cast(substring(@now,1,4) as int ) - cast(substring(@birth,1,4)  as int ) >=70
			delete from  #ghmx where isghf=1
	end 

	if exists(select 1 from YY_CONFIG where id='1263' and config='否')
	begin
		delete from  #ghmx where isghf=2
	end
	--add by ozb 2007-12-17 begin
	
	/*此段提到插入完#ghmx后立即更新 by mxd for vsts:237239 2017.12.05
	--处理根据医保代码设置挂号费诊疗费代码（南京医保有老年医保项目代码）
	--注意如果一次挂多个不号，且挂号类别不同，则无法处理 
	update a set xmdm=b.xmdm 
	from #ghmx a,GH_TSGHFZLF b(nolock)
	where b.ybdm=@ybdm and a.isghf=b.isghf and @ghlb=b.ghlb
	if @@error <>0 
	begin
		select 'F','用特殊挂号费诊疗费更新挂号费诊疗费时出错！'
		return
	end 
	*/	
    --cjt 此处用于更新免费挂号时数量为空，控制计算出来的挂号费用为零
	if exists(select 1 from #mzghtmp where ghlb in(5,8)) 
	begin
	    --modi by yuliang 2012-11-23 for bug147514此处这样更新有问题，如果同时挂多个号,中间包含ghlb=8的，会将所有的费用更新为0
		--update #ghmx set xmsl=0 where isghf<>0
		update a set a.xmsl=0 from #ghmx a,#mzghtmp b  
		where a.isghf<>0 and a.ghxh=b.ghxh and b.ghlb in (5,8)
		--modi end
	end
	/*** ---chenhong add 20191124 院内职工挂号 begin
	***/
	if exists(select 1 from YY_CONFIG (nolock) where id='1188' and config = '是') and exists (select 1 from #mzghtmp where ghlb=8)        
			begin      
				delete from #ghmx
			end	
			 if exists(select 1 from #mzghtmp where ghlb=8) --便民挂号        
			 begin        
			  insert into #ghmx select a.ghxh, config, 1 ,1        
			   from #mzghtmp a, YY_CONFIG b where a.ghlb=8 and b.id='X001'        
			  insert into #ghmx select a.ghxh, config, 1 ,2        
			   from #mzghtmp a, YY_CONFIG b where a.ghlb=8 and b.id='X002'     
			 end
			 /***
			 ***/---chenhong add 20191124 院内职工挂号 begin
	if exists(select 1 from #mzghtmp where ghlb=7) 
	begin
	    delete a
	    from #ghmx a,#mzghtmp b 
	    where a.ghxh=b.ghxh and b.ghlb=7 and a.isghf=1
	end
	delete from #ghmx where ltrim(isnull(xmdm,''))=''
	--add by ozb 2007-12-17 end
	
	--add by xxl 20140702 自由选择是否收取挂号费方式 第一位：挂号费；第二位：诊疗费；第三位：磁卡工本费；第四位病历工本费
	if @ghfselectbz<>''
	begin
	    --isghf 0:其他费1:挂号费2:诊疗费
		if substring(@ghfselectbz,1,1)='0'	--不收挂号费
		begin
			update #ghmx set xmsl=0 where isghf=1
		end
		if substring(@ghfselectbz,2,1)='0'	--不收诊疗费
		begin
			update #ghmx set xmsl=0 where isghf=2
		end
		--工本费的计算从新根据参数处理
		delete #ghmx where xmdm in (select config from YY_CONFIG where id in('1002','1003')) and isghf=0
		if substring(@ghfselectbz,3,1)='1'	--收磁卡工本费
		begin
			insert into #ghmx select top 1 a.ghxh, b.config, 1,0 from #mzghtmp a, YY_CONFIG b  
				where b.id in ('1003')  
		end
		if substring(@ghfselectbz,4,1)='1'	--收病历工本费
		begin
			insert into #ghmx select top 1 a.ghxh, b.config, 1,0 from #mzghtmp a, YY_CONFIG b  
				where b.id in ('1002')  
		end
		
	end
	
	update #mzghtmp set ksmc=b.name
		from #mzghtmp a, YY_KSBMK b (nolock)
		where b.id=a.ksdm

	--欠款的第一次递交不处理
	if @qkbz1=2
		select @qkbz1=0

	if @qkbz1=1 and @zhje=0 and isnull(@zhdcsx,0) = 0
		select @qkbz1=0


	if @pzlx not in (10,11)
		select @xmlb=ylxm, @zddm=zddm from SF_YBPZK (nolock) where pzh=@pzh and patid=@patid and pzlx=@pzlx

	--计算挂号费用 W20040525
	--select a.ybdm,case when @ghlb = 6 then isnull(a.txbl,1) else 1 end as txbl,a.xmdm,isnull(djjsbz,0) djjsbz,txdj into #txblxm  
	select a.ybdm,isnull(a.txbl,1) as txbl,a.xmdm,isnull(djjsbz,0) djjsbz,txdj into #txblxm  --去掉@ghlb=6才取txbl的限制  for bug154246 alter by djs 2017-04-27
		from YY_TSSFXMK a,SF_BRXXK b(nolock) 
	where a.ybdm = b.ybdm and b.patid = @patid and a.idm=0
	if @@error <> 0 
	begin
		select "F","选取特殊项目比例时报错"
		return
	end
	
	--add by sdb 2012-11-22 上海七院特殊挂号费
	if @ghfdm <> '' 
	    update #ghmx set xmdm = @ghfdm where isghf = 1
		     
	if exists(select 1 from YY_CONFIG(nolock) where id='1416' and config='是')
	begin
		select * into #ghmx_hff from #ghmx
		delete #ghmx
	end
	
	
	select a.ghxh, a.xmdm, b.name as xmmc, a.xmsl,case when d.djjsbz = 1 then d.txdj else b.xmdj*isnull(d.txbl,1) end xmdj,
		b.dxmdm, c.name as dxmmc, 
		b.mzzfbz as zfbz, b.mzzfbl as zfbl, (case when b.yhbl>0 then 1 else 0 end) as yhbz, b.yhbl, 
		convert(money, 0) as zfdj, convert(money, 0) as yhdj, c.mzfp_id, c.mzfp_mc, b.sxjg, a.isghf
		,convert(numeric(6,4),0) jmbl
	into #ghmx1
	from #ghmx a inner join YY_SFXXMK b (nolock) on a.xmdm=b.id
    inner join YY_SFDXMK c(nolock) on c.id=b.dxmdm
    left join #txblxm d on a.xmdm=d.xmdm
	select @error=@@error, @rowcount=@@rowcount
	if @error<>0
	begin
		select "F","计算挂号费用时出错！"
		return
	end
	--IF @ghlb in (8)------chenhong add 20191124
	--begin
	--	update #ghmx1 set xmdj=1 where xmdj<>0
	--end
	if @rowcount=0 --此前无结算金额
	begin
		select @zfyje=0, @yhje=0, @ybje=0, @sfje3=0
	end
	else 
	begin
		if @zfbz=0 --医保费用初试化
			update #ghmx1 set yhbz=0, yhbl=0
		else if @zfbz=2
		begin
			update #ghmx1 set yhbz=0, yhbl=0
			update #ghmx1 set zfbz=1, zfbl=b.zfbl
				from #ghmx1 a, YY_TSSFXMK b (nolock)
				where b.idm=0 and b.xmdm=a.xmdm and b.ybdm=@ybdm
			if @@error<>0
			begin
				select "F","计算挂号费用时出错！"
				return
			end
		end
		else if @zfbz=3
		begin
			if charindex('"'+ltrim(rtrim(@ybdm))+'"',@csybdm) > 0
			begin
				if @zhje > 0
				begin
					update #ghmx1 set zfbz=0, zfbl=0, yhbz=1, yhbl=b.yhbl
						from #ghmx1 a, YY_TSSFXMK b (nolock)
						where b.idm=0 and b.xmdm=a.xmdm and b.ybdm=@ybdm
				end
				else 
				begin
					update #ghmx1 set zfbz=0, zfbl=0, yhbz=0, yhbl=0
						from #ghmx1 a, YY_TSSFXMK b (nolock)
						where b.idm=0 and b.xmdm=a.xmdm and b.ybdm=@ybdm
				end
			end
			else 
				update #ghmx1 set zfbz=0, zfbl=0, yhbz=1, yhbl=b.yhbl
					from #ghmx1 a, YY_TSSFXMK b (nolock)
					where b.idm=0 and b.xmdm=a.xmdm and b.ybdm=@ybdm
			if @@error<>0
			begin
				select "F","计算挂号费用时出错！"
				return
			end
		end
		else if @zfbz=4
			update #ghmx1 set zfbz=0, zfbl=0, yhbz=0, yhbl=0

		--扶贫政策改造 vsts 315326 begin
		--贫困等级
		if exists(select 1 from YY_CONFIG where id ='0384' and config ='是')and  exists(select 1 from SF_BRXXK a(nolock),YY_PKRKXXB b(nolock) where a.patid =@patid and a.sfzh =b.sfzh and b.jlzt =1 and b.shbz =1)
		begin
			declare @pkdj ut_bz
			select @pkdj =pkdj from SF_BRXXK a(nolock),YY_PKRKXXB b(nolock) where a.patid =@patid and a.sfzh =b.sfzh
		
				update #ghmx1 set  zfbz=0, zfbl=0,yhbz=1, yhbl=b.yhbl  
				from #ghmx1 a, YY_PKSFXMK b (nolock)  
				where b.idm=0 and b.xmdm=a.xmdm and b.pkdj=@pkdj and isnull(b.xtbz,2)in(0,2)     
		end
		--扶贫政策改造 end	

		if @config1662_js='是' and @config1665_js='是' --add by hwh 2018-8-9
		begin
			update a set a.xmdj=a.xmdj+b.etjsje 
			from #ghmx1 a
			inner join YY_SFXXMK b (nolock) on b.id=a.xmdm
			where b.etjsbz=1
		end			

		--WED20050608 判断如果是签约病人就在这里优惠
		if charindex(rtrim(ltrim(@ybdm)),(select config from YY_CONFIG where id = '1099')) > 0
		begin
			update #ghmx1 set zfbz=0, zfbl=0, yhbz=1, yhbl=b.yhbl
				from #ghmx1 a, YY_TSSFXMK b (nolock)
				where b.idm=0 and b.xmdm=a.xmdm and b.ybdm=@ybdm
			if @@error<>0
			begin
				select "F","更新挂号费用优惠比例时出错！"
				return
			end			
		end

		--sunyu 2007-01-14 财政减免费用处理
		if @jmjsbz=2
		begin
			update #ghmx1 set zfbz=0, zfbl=0,yhbz=0,yhbl=0,jmbl=case when @tsrydm='1' then zfbl else 1 end
				where isghf in (1,2)
			if @@error<>0
			begin
				select "F","更新挂号费用自费比例时出错！"
				return
			end
		end
		
		--W20050313 特殊收费项目中增加上限价格,作用是针对特殊病人的上限价格设置.
		--顺序:先执行收费小项目中的上限价格,再覆盖执行特殊收费项目中的上限价格
		update #ghmx1 set sxjg = b.sxjg
			from #ghmx1 a,YY_TSSFXMK b
			where a.xmdm = b.xmdm and b.ybdm = @ybdm 

		update #ghmx1 set zfdj=(case when sxjg<xmdj and sxjg>0 then (xmdj-sxjg)+sxjg*zfbl else xmdj*zfbl end),
			yhdj=(case when sxjg<xmdj and sxjg>0 then sxjg*(1-zfbl)*yhbl else xmdj*(1-zfbl)*yhbl end)

		--Wxp20070317 对二三级医院转诊处理，诊查费自费和诊查费优惠50%
		--条件： @zzdjh <> '',是二三级医院，普通挂号费，范围限制：挂号费和诊疗费
		if (@zzdjh <> '' and @yydj > 1 and @ghlb in (0,1)) 
		begin
			if @zfbz = 4 --自费病人原程序处理没有任何特殊费用比例，造成ghf没有
			begin
				select @jmghf=isnull(sum(round(xmdj*xmsl*0.5,2)),0) from #ghmx1 where isghf=1
				select @jmzlf=isnull(sum(round(xmdj*xmsl*0.5,2)),0) from #ghmx1 where isghf=2				
				update #ghmx1 set zfdj= zfdj *0.5,yhdj= xmdj*0.5  where isghf in (1,2)
			end
			if @pzlx  in (10,11)
			begin
				if @zfbz = 3 
				begin 
					select @jmghf=isnull(sum(round((xmdj-yhdj)*xmsl*0.5,2)),0) from #ghmx1 where isghf=1
					select @jmzlf=isnull(sum(round((xmdj-yhdj)*xmsl*0.5,2)),0) from #ghmx1 where isghf=2					
					update #ghmx1 set zfdj= zfdj *0.5,yhdj= yhdj+(xmdj-yhdj) *0.5  where isghf in (1,2)
				end 
				else begin
					if @zfbz = 2
					begin
						--挂号费：取自费药金额*0.5    诊疗费：取可保金额*0.5
						select @jmghf=isnull(sum(round(zfdj*xmsl*0.5,2)),0) from #ghmx1 where isghf=1
						select @jmzlf=isnull(sum(round((xmdj-zfdj)*xmsl*0.5,2)),0) from #ghmx1 where isghf=2						
						update #ghmx1 set zfdj= zfdj *0.5,yhdj= zfdj *0.5  where isghf =1
						update #ghmx1 set yhdj= (xmdj-zfdj) *0.5  where isghf =2
					end
					else begin
						select @jmghf=isnull(sum(round(xmdj*xmsl*0.5,2)),0) from #ghmx1 where isghf=1
						select @jmzlf=isnull(sum(round(xmdj*xmsl*0.5,2)),0) from #ghmx1 where isghf=2						
						update #ghmx1 set zfdj= zfdj *0.5,yhdj= xmdj*0.5  where isghf in (1,2)
					end
				end		
			end
		end

		-- add kcs 20160808 by 98152 优抚病人诊查费减半 如果已经减半了 就不需要判断是否是60以上老人了
		if (@sfyf = 1) and (@ghlb in (0))
		begin
		    select @jmzlf=isnull(sum(round((xmdj-yhdj)*xmsl*0.5,2)),0) from #ghmx1 where isghf=2					
			update #ghmx1 set zfdj= zfdj *0.5,yhdj= yhdj+(xmdj-yhdj) *0.5  where isghf in (2)
			select @zlfjmlx=0
		end
        else
		begin
			if exists(select 1 from sysobjects where name='usp_gh_ghfyhcl' and type='P') --and 1=1
			AND EXISTS(SELECT 1 FROM dbo.YY_CONFIG WHERE id='1726' AND config='是')
			begin
				declare @tablename_ghmx varchar(100)
				select @tablename_ghmx ='##ghmx'+@wkdz+@czyh
				exec('if exists(select * from tempdb..sysobjects where name="'+@tablename_ghmx+'")
					drop table '+@tablename_ghmx)
				exec('select * into '+@tablename_ghmx+' from #ghmx1 where 1=2') --创建临时表保存优惠结果
				exec('exec usp_gh_ghfyhcl @wkdz="'+@wkdz+'",@patid='+@patid+',@czyh="'+@czyh+'",@ksdm="'+@ksdm+'",@ysdm="'+@ysdm+'",@ghlb="'+@ghlb+'" ')  
				exec('delete from #ghmx1; insert into #ghmx1 select * from '+@tablename_ghmx)
				exec('drop table '+@tablename_ghmx)				
				--SELECT '优惠后',* FROM #ghmx1
			end
			else--else usp_gh_ghfyhcl
			begin
				-- add kcs 20160805 by 97896
				declare @config1497 varchar(2),@config1693 numeric(10,2),@jmzlfzje numeric(10,2)
				select @config1497 = config from YY_CONFIG where id = '1497'
				select @config1693 = convert(numeric(10,2),config) from YY_CONFIG where id = '1693'
				if (@config1497 = '是') and (@ghlb in (0))
				begin
					select @birth=birth from SF_BRXXK(nolock) where patid=@patid
					--if cast(substring(@now,1,4) as int ) - cast(substring(@birth,1,4)  as int ) >= 60
					if dbo.FUN_GETBRNL(@birth,convert(char(8),getdate(),112)+convert(char(8),getdate(),8),1,1,null) >= 60
					begin
						if @config1693=0
						begin             
							select @jmzlf=isnull(sum(round((xmdj-yhdj)*xmsl*0.5,2)),0) from #ghmx1 where isghf=2					
							update #ghmx1 set zfdj= zfdj *0.5,yhdj= yhdj+(xmdj-yhdj) *0.5  where isghf in (2)
							select @zlfjmlx=1
						end
						else
						begin
							select @jmzlfzje=isnull(sum(round((xmdj-yhdj)*xmsl,2)),0),@jmzlf=case when isnull(sum(round((xmdj-yhdj)*xmsl-@config1693,2)),0)<0 then isnull(sum(round((xmdj-yhdj)*xmsl,2)),0) else @config1693 end from #ghmx1 where isghf=2					
							update #ghmx1 set zfdj= zfdj *(1-@jmzlf/@jmzlfzje),yhdj= yhdj+(xmdj-yhdj) *(@jmzlf/@jmzlfzje)  where isghf in (2)
							select @zlfjmlx=1
						end
					end
				end
			end--end else usp_gh_ghfyhcl
		end

		if substring(@ghfselectbz,5,1)='1'	--特殊费用(根据医院的不同需求修改)
		begin
			update #ghmx1 set xmdj=1 where isghf=1
			update #ghmx1 set xmdj=3 where isghf=2
			update #ghmx1 set yhdj=0 where isghf=1
			update #ghmx1 set yhdj=0 where isghf=2
		end				
		--add HRP 联动项目价格重算
		if @hrpbz='1'  and  @config2604='是'
		begin
		    update #ghmx1 set xmdj=b.xmdj from  #ghmx1 a,#ghmx_ldxm b  where a.xmdm=b.xmdm and a.isghf=0
		end
		
		select @zje=sum(round(xmsl*xmdj,2)),
			@zfyje=sum(round(xmsl*zfdj,2)),
			@yhje=sum(round(xmsl*yhdj,2)),
			@jmje=sum(round(xmsl*xmdj*jmbl,2))
			from #ghmx1
		
		select @ybje=@zje-@zfyje-@yhje-@jmje
		select @sfje3=@zje-@yhje-@jmje
	end
	--20050302 民生卡的处理

	if @ghlb=3   	
	begin  
	if @zje<=@zhdcsx  
		select @zhje = @zje--,@ybje=@zje-@zfyje  --,@zfyje=0  
	else  
		select @zhje= @zhdcsx--,@ybje=@zje-@zfyje --@zfyje=@zje-@zhdcsx,  
	end 
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
	--取得实收金额

	select @sfje2=@sfje3	--zyh 20071221 医保病人也按自费计算时

	if @pzlx not in (10,11) --非医保住院、和医保门诊大病
	begin
		execute usp_yy_ybjs @ybdm,0,0,@ybje,@errmsg output,0,@tcljje,@jsfs  --医保金额计算
		if @errmsg like "F%"
		begin
			select "F",substring(@errmsg,2,49)
			return
		end
		else
			select @sfje=convert(numeric(10,2),substring(@errmsg,2,11))

		select @sfje_zzjsq = @sfje
		--处理一下本地计算的人
		if (@zzdjh <> '' and @yydj > 1 and @ghlb in (0,1) and @zfbz <> 4) 
		begin
			select @jmghfbl = 0,@jmzlfbl = 0
			if @ybje > 0
			begin
				select @jmghfbl = (xmdj-zfdj-yhdj-xmdj*jmbl)*xmsl/@ybje
					from #ghmx1 where isghf =1
				select @jmzlfbl = (xmdj-zfdj-yhdj-xmdj*jmbl)*xmsl/@ybje  
					from #ghmx1 where isghf =2
			end
			select @jmghf=(@sfje*@jmghfbl+zfdj*xmsl)* 0.5 from #ghmx1 where isghf in (1)
			select @jmzlf=(@sfje*@jmzlfbl+zfdj*xmsl)* 0.5 from #ghmx1 where isghf in (2)

			update #ghmx1 set yhdj= yhdj+@jmghf/xmsl,zfdj = zfdj*0.5,yhbz = 1 where isghf = 1
			update #ghmx1 set yhdj= yhdj+@jmzlf/xmsl,zfdj = zfdj*0.5,yhbz = 1 where isghf = 2
			select @sfje=@sfje*0.5,@zfyje = @zfyje-(zfdj*xmsl) from #ghmx1 where isghf in (1)
			select @yhje=sum(round(xmsl*yhdj,2))  from #ghmx1
		end

		select @sfje1=@sfje+@zfyje
		
		if exists (select 1 from sysobjects where name = 'usp_gh_ynyhcl') --70岁以上老人挂号减免1元费用，并且要记录优惠的金额 
		begin  
			exec usp_gh_ynyhcl @patid,@ynyhje out,@errmsg out  
			if @sfje1 >= @ynyhje   
			begin  
				select @sfje1 = @sfje1 - @ynyhje,@yhje = @yhje+@ynyhje  
			end  
			else  
			begin  
				select @yhje = @yhje+@sfje1,@sfje1 = 0  
			end  
		end 
		
		select @srbz=config from YY_CONFIG (nolock) where id='1014' --四舍五入舍入数值
		if @@error<>0 or @@rowcount=0
			select @srbz='0'

        declare @srfs varchar(1)  --0：精确到分，1：精确到角
		select @srfs = config from YY_CONFIG (nolock) where id='2235'
		if @@error<>0 or @@rowcount=0
			select @srfs='0'

		select @sfje2 = @sfje1  -----add by sqf 统一处理四舍五入
        if @srfs = '1' or @qkbz1=1 ---1：精确到角则先舍入20110426sqf
		begin		
			if @srbz='5'
				select @sfje2=round(@sfje1, 1)
			else if @srbz='6'
				exec usp_yy_wslr @sfje1,1,@sfje2 output
			else if @srbz>='1' and @srbz<='9'
				exec usp_yy_wslr @sfje1,1,@sfje2 output,@srbz
			else
				select @sfje2=@sfje1

			select @srje=@sfje2-@sfje1
		end

		if @ybje>0
		begin
			if (@zzdjh <> '' and @yydj > 1 and @ghlb in (0,1) and @zfbz <> 4 and @pzlx not in (10,11)) 
				select @xmzfbl=@sfje_zzjsq/@ybje
			else
				select @xmzfbl=@sfje/@ybje
		end
		--慈善基金病人（在医院有个人账户的病人）
		if @qkbz1=1
		begin
			--涉及到有些人的挂号费在账户里扣除，有的要自己掏
			declare @zfyje_zh   money --账户病人的自费金额
			if exists(select 1 from YY_CONFIG (nolock) 
				where charindex('"'+rtrim(@ybdm)+'"',config)>0 and id='1098')
				select @zfyje_zh = 0
			else
				select @zfyje_zh = @zfyje

			if @sfje2-@zfyje_zh<=@zhje
				select @qkje=@sfje2-@zfyje_zh,@qkje2=@sfje1-@zfyje_zh
			else
				select @qkje=round(@zhje,1),@qkje2 = @zhje

			insert into SF_JEMXK(jssjh, lx, mc, je, memo)
			values(@sjh, '01', '起付段当年账户支付',@qkje2 , null)
			if @@error<>0
			begin
				select "F","保存结算01信息出错！"
				return
			end
			--(帮困结束)
		end
		else if @czksfbz = 1
		begin
			if @yjbz=1
			begin
				if @yjyebz='否' and @yjye<@sfje2 and @lybz <> 2
				begin
					select "F","充值卡余额不足，不能继续挂号！"
					return
				end
	
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
					select @qkbz1=3
	
					if @yjdybz='否' and (@sfje2<=@yjye)
						--select @qrbz=1
						select @fpdybz=1
				end
			end
		end
		if @yjdybz='否' and @mzlcbz=1 and exists(select 1 from YY_CONFIG where id='1065' and charindex('"'+rtrim(@pzlx)+'"',config)>0)
			--select @qrbz=1
			select @fpdybz=1
		if @lybz = 2  --add by sdb 2010-11-2 自助挂号才会判断GH_ZDGHJLK表里数据
		begin
			if @issyzzgh=1 and exists(select 1 from GH_ZDGHJLK where patid=@patid and jlzt=0 and ghlb=@ghlb)
				select @qrbz=3,@fpdybz=1
		end

		if @mzlcbz=1
		begin
			if @yjyebz='否' and @yjye<@sfje2 and @sfje2>0 and @yjbz=1 and @lybz <> 2
			begin
				select "F","充值卡余额不足，不能继续挂号！"
				return
			end
		end
	end
	else 
	begin
		--mit , 2oo3-11-28 , 根据设置判断是否记账
		if @yjdybz='否' and @mzlcbz=1 and exists(select 1 from YY_CONFIG where id='1065' and charindex('"'+rtrim(@pzlx)+'"',config)>0)
			--select @qrbz=1
			select @fpdybz=1
		if @lybz = 2  --add by sdb 2010-11-2 自助挂号才会判断GH_ZDGHJLK表里数据
		begin
			if @issyzzgh=1 and exists(select 1 from GH_ZDGHJLK where patid=@patid and jlzt=0)
				select @qrbz=3,@fpdybz=1
		end
	end
-----------add by sqf 统一处理四舍五入	begin
	if @qkbz1 = 3 and @srfs = '0'---0：精确到分则先舍入20110426sqf
	begin 
		select @sfje2=@sfje1-@qkje
		if @srbz='5'
			select @sfje2=round(@sfje1-@qkje, 1)
		else if @srbz='6'
			exec usp_yy_wslr @sfje2,1,@sfje2 output 
		else if @srbz>='1' and @srbz<='9'
			exec usp_yy_wslr @sfje2,1,@sfje2 output,@srbz
		else
			select @sfje2=@sfje1-@qkje
		select @sfje2=@sfje2+@qkje
		select @srje=@sfje2-@sfje1
		--add by cxl for bug 3945 
		if @yjdybz='否' and (@sfje2<=@yjye)
			--select @qrbz=1
			select @fpdybz=1		
	end
	else if @srfs = '0' and @qkbz1 <> 1
	begin
		if @srbz='5'
			select @sfje2=round(@sfje1, 1)
		else if @srbz='6'
			exec usp_yy_wslr @sfje1,1,@sfje2 output
		else if @srbz>='1' and @srbz<='9'
			exec usp_yy_wslr @sfje1,1,@sfje2 output,@srbz
		else
			select @sfje2=@sfje1
		select @srje=@sfje2-@sfje1
	end
	
-----------add by sqf 统一处理四舍五入	end
	--计算挂号费、诊疗费
	if (@ybdm=@scybdm) or (@jmjsbz=2)
	begin
--		if @ghlb not in (2,3)
		select @ghf=isnull(sum(round(xmdj*xmsl,2)),0) from #ghmx1 where isghf=1
	end
	else
		select @ghf=isnull(sum(round(zfdj*xmsl,2)),0) from #ghmx1 where isghf=1
	select @zlf=isnull(sum(round((xmdj-yhdj-zfdj)*xmsl,2)),0) from #ghmx1 where isghf=2

	--处理大项汇总金额
	select dxmdm, dxmmc, mzfp_id, mzfp_mc, sum(round(xmdj*xmsl,2)) as xmje, 
		sum(round((xmdj-zfdj-yhdj)*xmsl*@xmzfbl,2)) as zfje,
		sum(round(zfdj*xmsl,2)) as zfyje, sum(round(yhdj*xmsl,2)) as yhje,
		sum(round(xmdj*jmbl*xmsl,2)) as jmje
		into #ghmx2
		from #ghmx1 group by dxmdm, dxmmc, mzfp_id, mzfp_mc
	if @@rowcount>0
	begin
		select @xmce=@sfje-sum(zfje) from #ghmx2
		update #ghmx2 set zfje=zfje+zfyje
		set rowcount 1
		update #ghmx2 set zfje=zfje+@xmce
		set rowcount 0
	end	

	begin tran
	declare cs_mzgh cursor for
	select ghxh, ghlb, cfzbz, ksdm, ksmc, ysdm, ysmc, lybz, yyxh, yyrq, zqdm, xzks_id,pbmxxh,kmdm,kmmc,fbdm,fbmc,zqmc,zbdm from #mzghtmp
	for read only
--yxc2
	open cs_mzgh
	fetch cs_mzgh into @ghzdxh, @ghlb, @cfzbz, @ksdm, @ksmc, @ysdm, @ysmc, @lybz, @yyxh, @yyrq, @zqdm, @xzks_id,@pbmxxh_temp,@kmdm,@kmmc,@fbdm,@fbmc,@zqmc,@zbdm_temp
	while @@fetch_status=0
	begin
		if @pbmxxh_temp>0
		begin
			if @iskmgh=1 
			select @ghrq=zxrq+convert(char(8),getdate(),8) from GH_KM_PBZBMX where pbmxid=@pbmxxh_temp
			else
			select @ghrq=zxrq+convert(char(8),getdate(),8) from GH_YY_PBZBMX where pbmxid=@pbmxxh_temp
		end
		else
			select @ghrq=@now
		if isnull(@ghrq,'')=''---空值取现在的日期
		begin
			select @ghrq=@now
		end 
		select @yyxh_new=@yyxh
		IF (@config1151=1) AND (EXISTS(SELECT 1 FROM GH_GHZDK WHERE patid=@patid AND jlzt=8 AND jsbz=1))
		BEGIN
			if isnull(@inghzdxh,0)=0 
			begin
				SELECT "F","传入挂号账单序号不正确,可能是前后台不一致导致！"
				ROLLBACK TRAN
				DEALLOCATE cs_mzgh
				RETURN
			end

			UPDATE GH_GHZDK SET jssjh=@sjh, czyh=@czyh, xzks_id=@xzks_id
			WHERE patid=@patid AND jlzt=8 AND jsbz=1 and xh=@inghzdxh
			IF @@ERROR<>0 OR @@ROWCOUNT=0
			BEGIN
				SELECT "F","保存挂号账单出错！"
				ROLLBACK TRAN
				DEALLOCATE cs_mzgh
				RETURN
			END
			
			if exists (select 1 from GH_YY_PBZBMX(NOLOCK) where pbmxid = @pbmxxh_temp)
			select @sjdjl = b.kssj+'-'+b.jssj,@sjdsm = b.name
			from GH_YY_PBZBMX a(nolock)
			inner join GH_YY_ZZLX b(nolock) on a.zzlx=b.id
			where a.pbmxid = @pbmxxh_temp
			
			if exists (select 1 from GH_GHZDK_FZ(NOLOCK) where ghxh=@inghzdxh) 
			update GH_GHZDK_FZ set jssjh=@sjh,sjdjl=@sjdjl,sjdsm =@sjdsm,brlyid=@brlyid,wlzxyid=@wlzxyid
			---,zlfjmje=@jmzlf,zlfjmlx=@zlfjmlx,zzdh=@zzdh,isqygh=@isQygh
			where ghxh=@inghzdxh
			else
			insert into GH_GHZDK_FZ(ghxh,jssjh,patid,sjdjl,sjdsm,brlyid,wlzxyid) values(@inghzdxh,@sjh,@patid,@sjdjl,@sjdsm,@brlyid,@wlzxyid)
			if @@error<>0
			begin
				select "F","挂号帐单库辅助库出错！"
				rollback tran
				deallocate cs_mzgh
				return		
			end

			select @xhtemp=@inghzdxh
			--select @xhtemp=xh FROM GH_GHZDK WHERE patid=@patid AND jssjh=@sjh
			DELETE FROM GH_GHMXK WHERE ghxh=@xhtemp
			insert into GH_GHMXK(ghxh, xmdm, xmmc, xmdj, xmsl, dxmdm, dxmmc, zfdj, yhdj, memo,isghf)
			select @xhtemp, xmdm, xmmc, xmdj, xmsl, dxmdm, dxmmc, zfdj, yhdj, null,isghf
				from #ghmx1 where ghxh=@ghzdxh
			if @@error<>0
			begin
				select "F","保存挂号明细出错！"
				rollback tran
				deallocate cs_mzgh
				return		
			end
			-- 保存号别
			if @isUsehb = 1 
			begin
				select @ghfdm_hb = xmdm from #ghmx1 where ghxh = @ghzdxh and isghf=1
				select @zlfdm_hb = xmdm from #ghmx1 where ghxh = @ghzdxh and isghf=2
				select @hbdm = isnull(id,'') from GH_GHHBK where ghfdm = @ghfdm_hb and zlfdm= @zlfdm_hb and jlzt =0
				if @hbdm <> ''
				begin
					update GH_GHZDK SET ghlx = @hbdm where xh =@inghzdxh
					if @@error<>0
					begin
						select "F","保存挂号账单ghlx出错！"
						rollback tran
						deallocate cs_mzgh
						return		
					end
				end
			end
			
		END
		ELSE
		BEGIN
			insert into GH_GHZDK(jssjh, patid, blh, ybdm, cardno, yyxh, hzxm, py, wb, 
				czyh, czrq, ghrq, ksdm, ksmc, ysdm, ysmc, ghhx, cfzbz, lybz, ghlb, sfcs, txh, jlzt, 
				fzbz, fzrq, jsbz, memo
				,zjdm,zmdm,zm, zqdm,ghksdm,ghysdm,xzks_id,pbmxxh,yyghlb,kmdm,kmmc,fbdm,fbmc,zqmc,tsbzdm,mfghyy,appjkdm,sfyf,zbdm)
			select @sjh, patid, blh, @ybdm, cardno, @yyxh_new, hzxm, py, wb,
				@czyh, @now, @ghrq, case when @ghlb=4 and @tsghksdm<>'' then @tsghksdm else @ksdm end, case when @ghlb=4 and @tsghksdm<>'' then @tsghksmc else @ksmc end, @ysdm, @ysmc, 0, @cfzbz, @lybz, @ghlb, 0, null, 9,
				0, null, 1, null 
				,@zjdm,@zmdm,@zm, @zqdm,@ksdm,@ysdm,@xzks_id,@pbmxxh_temp,@yyghlb ,@kmdm,@kmmc,@fbdm,@fbmc,@zqmc,@zddm,@mfghyy,@kfsdm,@sfyf,@zbdm_temp
				from #brxxk
			if @@error<>0 or @@rowcount=0
			begin
				select "F","保存挂号账单出错！"
				rollback tran
				deallocate cs_mzgh
				return
			end
			
			select @xhtemp=@@identity
			
			if exists (select 1 from GH_YY_PBZBMX(NOLOCK) where pbmxid = @pbmxxh_temp)
			select @sjdjl = b.kssj+'-'+b.jssj,@sjdsm = b.name
			from GH_YY_PBZBMX a(nolock)
			inner join GH_YY_ZZLX b(nolock) on a.zzlx=b.id
			where a.pbmxid = @pbmxxh_temp
			
			if exists (select 1 from GH_GHZDK_FZ(NOLOCK) where ghxh=@xhtemp) 
			update GH_GHZDK_FZ set jssjh=@sjh,sjdjl=@sjdjl,sjdsm =@sjdsm,brlyid=@brlyid,wlzxyid=@wlzxyid
			where ghxh=@xhtemp
			else
			insert into GH_GHZDK_FZ(ghxh,jssjh,patid,sjdjl,sjdsm,brlyid,wlzxyid) select @xhtemp,@sjh,patid,@sjdjl,@sjdsm,@brlyid,@wlzxyid from #brxxk
			if @@error<>0
			begin
				select "F","挂号帐单库辅助库出错！"
				rollback tran
				deallocate cs_mzgh
				return		
			end

			insert into GH_GHMXK(ghxh, xmdm, xmmc, xmdj, xmsl, dxmdm, dxmmc, zfdj, yhdj, memo,isghf)
			select @xhtemp, xmdm, xmmc, xmdj, xmsl, dxmdm, dxmmc, zfdj, yhdj, null,isghf
				from #ghmx1 where ghxh=@ghzdxh
			if @@error<>0
			begin
				select "F","保存挂号明细出错！"
				rollback tran
				deallocate cs_mzgh
				return		
			end		
			-- 保存号别 
			if @isUsehb = 1 
			begin
				select @ghfdm_hb = xmdm from #ghmx1 where ghxh = @ghzdxh and isghf=1
				select @zlfdm_hb = xmdm from #ghmx1 where ghxh = @ghzdxh and isghf=2
				select @hbdm = isnull(id,'') from GH_GHHBK where ghfdm = @ghfdm_hb and zlfdm= @zlfdm_hb and jlzt =0
				if @hbdm <> ''
				begin
					update GH_GHZDK SET ghlx = @hbdm where xh =@xhtemp
					if @@error<>0
					begin
						select "F","保存挂号账单ghlx出错！"
						rollback tran
						deallocate cs_mzgh
						return		
					end
				end
			end	
			/*if @config1334='是'
			begin
			  exec usp_gh_zdfz @xhtemp,@errmsg output
			  if substring(@errmsg,1,1)='F'
			  begin
			    select "F",substring(@errmsg,2,49)
				  rollback tran
				  deallocate cs_mzgh
				  return
			  end 
			end*/--add  by zyj  for 59904 
		END
		fetch cs_mzgh into @ghzdxh, @ghlb, @cfzbz, @ksdm, @ksmc, @ysdm, @ysmc, @lybz, @yyxh, @yyrq, @zqdm, @xzks_id,@pbmxxh_temp,@kmdm,@kmmc,@fbdm,@fbmc,@zqmc,@zbdm_temp
	end
	close cs_mzgh
	deallocate cs_mzgh  
	insert into SF_BRJSK(sjh, patid, ghsjh, ghxh, fph, fpjxh, czyh, sfrq, sfksdm, ksdm, 
		hzxm, blh, ybdm, pzh, sfzh, ylxm, zddm, dwbm, zje, zfyje, yhje, deje, zfje, 
		zpje, zph, xjje, srje, qkbz, qkje, zxlsh, jslsh, ybjszt, zhbz, tsjh, jlzt, cardno,
		cardtype, ghsfbz, jcxh, memo, mjzbz, brlx, qrbz, tcljbz, tcljje, jmje,gxrq,lrrq,yhdm,fpdybz,appjkdm)
	select @sjh, patid, @sjh, @xhtemp, null, null, @czyh, @now, @ghksdm, @ksdm,
		hzxm, blh, @ybdm, pzh, sfzh, @xmlb, @zddm, dwbm, @zje, @zfyje, @yhje, 0, @sfje2,
		0, '', 0, @srje, @qkbz1, @qkje, null, null, 0, @zhbz, null, 0, cardno,
		cardtype, 0, null, null, (case when @ghlb=1 then 2 else 1 end), @brlx, @qrbz, @tcljbz, @tcljje, @jmje,@now,@now,@yhdm
		,@fpdybz,@kfsdm
		from #brxxk
	if @@error<>0
	begin
		select "F","保存结算账单出错！"
		rollback tran
		return		
	end

	insert into SF_BRJSMXK(jssjh, dxmdm, dxmmc, fpxmdm, fpxmmc, xmje, zfje, zfyje, yhje, jmje, memo)
	select @sjh, dxmdm, dxmmc, mzfp_id, mzfp_mc, xmje, zfje, zfyje, yhje, jmje, null
		from #ghmx2
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
		insert into SF_BRJSK_FZ
		(sjh,patid,ghsjh,ghxh,fph,fpjxh,ip,mac,sfly)
		select                
		@sjh, @patid, @sjh, @xhtemp, null, null,'',@wkdz,@sfly
		if @@error<>0
		begin
			select "F","保存结算账单出错！"
			rollback tran
			return		
		end	
	END	
	--Wxp20070317 对二三级医院转诊处理，诊查费自费和诊查费优惠50%
	--条件： @zzdjh <> '',是二三级医院，普通挂号费，范围限制：挂号费和诊疗费
	if (@zzdjh <> '' and @yydj > 1 and @ghlb in (0,1)) 
	begin
		delete from  GH_ZZBRJLK  where zzdjh = @zzdjh and jszt <> 2 --把上次没有结算完成的记录删除掉
		if @@error<>0
		begin
			select "F","删除垃圾转诊单时出错！"
			rollback tran
			return		
		end
		insert into GH_ZZBRJLK(zzdjh,czyh,czrq,jmghf,jmzlf,fjzfbl,jssjh,jszt,jlzt)
		select @zzdjh ,@czyh,@now,@jmghf,@jmzlf,0,@sjh,0,0		
		if @@error<>0
		begin
			select "F","保存转诊单记录时出错！"
			rollback tran
			return		
		end
	end
	if exists(select 1 from YY_CONFIG(nolock) where id='1416' and config='是')	
	begin	
		if exists(select 1 from #ghmx_hff)	
		begin	
			insert into SF_HJCFK( czyh,lrrq,patid,hzxm,py,wb,ysdm,ksdm,yfdm,sfksdm,qrczyh,qrrq,cfts,jlzt,cflx,ghxh,qrksdm,
			cftszddm,cftszdmc,medtype,medtypemc,ybbfz,ybbfzmc,tsyxbz) 
			select case @czyh when '' then @ysdm else @czyh end,@now,patid,hzxm,py,wb,case @ysdm when '' then @czyh else @ysdm end,
			@ksdm,@ksdm,@ksdm,case @czyh when '' then @ysdm else @czyh end,@now,1,
			--CASE @config1151 WHEN 1 THEN 0 ELSE 3 END,
			--0,--modified by mxd for bug:29479
			case @config2613 when '是' then 0 else 3 end, --add by liuquan vsts29479 如果2613=否，不应该结算
			7,@xhtemp,@ksdm,  
			'','','','','','','1'			 
			from #brxxk			
			if @@error<>0
			begin
				select "F","保存挂号费诊疗费到划价处方库中出错！"
				rollback tran
				return		
			end
			select @xhtemp=@@identity
			insert into SF_HJCFMXK(cfxh,cd_idm,gg_idm,dxmdm,ypdm,ypdw,ypxs,ykxs,ypfj,ylsj,ts,ypsl,cfts,yhdj,ypmc,lcxmdm)
			select @xhtemp,0,0,b.dxmdm,a.xmdm,'',1,1,case when isnull(d.djjsbz,0) =1 then d.txdj else b.xmdj*isnull(d.txbl,1) end,
				case when isnull(d.djjsbz,0) =1 then d.txdj else b.xmdj*isnull(d.txbl,1) end,1,a.xmsl,1,0,b.name,0 
			from #ghmx_hff a
			inner join YY_SFXXMK b (nolock) on a.xmdm=b.id
			inner join YY_SFDXMK c(nolock) on c.id=b.dxmdm
			left join #txblxm d on a.xmdm=d.xmdm
			if @@error<>0
			begin
				select "F","保存挂号费诊疗费到划价处方明细库中出错！"
				rollback tran
				return		
			end	
		end		
	end
	--if exists (select 1 from YY_LXHZXXK a(NOLOCK),SF_BRJSK b(nolock) where b.sjh=@sjh and a.sfzh=b.sfzh and (@now between a.yxksrq and a.yxjsrq)) 
	--begin
	--	update GH_GHZDK_FZ set lxbz=1 where jssjh=@sjh
	--	if @@error<>0
	--	begin
	--		select "F","更新GH_GHZDK_FZ中的lxbz出错！"
	--		rollback tran
	--		return		
	--	end
	--end
	commit tran
	if ltrim(rtrim(@ybdm)) = ltrim(rtrim(@scybdm))
		select @zfyje_sc = case when @ghlb not in (0,1) then @ghf else 0 end
	else
		select @zfyje_sc = @ghf
	select "T", @sjh, @zje, @sfje2-@qkje, @ybje, @ghf, @zlf, @yjye,@zfyje_sc,@jmje,@qkje,@yjye-@qkje 
end

return






