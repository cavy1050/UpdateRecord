Text
CREATE proc usp_sf_sfcl_ex2
	@wkdz varchar(32),
	@jszt smallint,
	@sfbz smallint,
	@sflb smallint,
	@czksfbz int,
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
	@shbz	ut_bz = 0,
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
	,@cardxh ut_xh12=0			--add by chenwei 2003.12.06
	,@cardje ut_money=0			--同上
	,@bdyhkje ut_money = 0
	,@bdyhklsh ut_lsh = ''
	,@zlje	ut_money=0			--add by ozb 20060622 找零金额
	,@isQfbz ut_bz  = 0   --add by will
	,@hcsjh ut_sjh=''  --自费转医保时用到,指红冲记录的sjh
	,@jslb	smallint = 0	--结算类别0正常一次结算1分发票多次结算
	,@ipdz_gxzsj VARCHAR(30)=''
as --集48769 2019-04-18 18:04:22 4.0标准版_201810补丁
/**********
[版本号]4.0.0.0.0
[创建时间]2004.10.25
[作者]王奕
[版权] Copyright ? 2004-2008上海金仕达-卫宁软件股份有限公司[描述]收费处理
[功能说明]
	收费处理功能(只用于sfbz=2)
[参数说明]
	@wkdz varchar(32),	网卡地址
	@jszt smallint,		结束状态	1=创建表，2=插入，3=递交
	@sfbz smallint,		收费标志0=预算，1=递交(请求1), 2=正式递交(请求2)
	@sflb smallint,		收费类别1=普通，2=急诊
	@czksfbz int,		充值卡收费标志， 0 :不从充值卡收费  ，1 从充值卡收费 add by szj
	@qrbz ut_bz,		确认标志0=普通，1=记帐(医技收费用)
	@patid ut_xh12,		病人唯一标识
  	@sjh ut_sjh,		收据号
	@czyh ut_czyh,		操作员号
  	@ksdm ut_ksdm,		科室代码
  	@ysdm ut_czyh,		医生代码
	@sfksdm ut_ksdm,	收费科室代码
	@yfdm ut_ksdm,		药房代码
	@sfckdm ut_dm2,		收费窗口代码
	@pyckdm ut_dm2,		配药窗口代码
	@fyckdm ut_dm2,		发药窗口代码
	@ybdm ut_ybdm,		医保代码
	@cfxh int,			处方序号
	@hjxh ut_xh12,		划价序号
	@cflx ut_bz,		处方类别1:西药处方,2:中药处方,3:草药处方,4:治疗处方
	@sycfbz ut_bz,		输液处方标志0:普通处方，1:输液处方
	@tscfbz ut_bz,		特殊处方标志0:普通处方，1:尿毒症处方
	@dxmdm ut_kmdm,		大项目代码
	@xxmdm ut_xmdm,		小项目代码（药品代码）
	@idm ut_xh9,		产地idm
	@ypdw ut_unit,		药品单位
	@dwxs ut_dwxs,		单位系数
	@fysl ut_sl10,		发药数量
	@cfts integer,		处方贴数
	@ypdj ut_money,		药品单价
	@ghsjh ut_sjh = null,		挂号收据号
	@ghxh ut_xh12 = null,		挂号序号
	@tcljje numeric(12,2) = 0,	统筹累计金额
	@shbz	ut_bz = 0,		审核标志 0 不需审核,1 审核,2 审核不通过
	@zph varchar(32) = null,	支票号
	@zpje numeric(12,2) = null,	支票金额
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
	@lnzhye numeric(12,2) = null,		历年账户余额
	@qkbz smallint = 0					欠款标志0：正常，2：欠费
	@jsrq ut_rq16 = ''					结算日期
--mit add 2003-05-05 ,,银联卡 
	,@ylcardno ut_cardno=''		银联卡卡号
	,@ylkje ut_money=0		银联卡金额
	,@ylkhcysje ut_money=0	银联卡预授金额(冲)
	,@ylksqxh ut_lsh=’’		银联卡申请序号
	,@ylkzxlsh ut_lsh=’’		银联卡中心流水号
	,@ylkhcyssqxh ut_lsh=’’		银联卡预授申请序号(冲)
	,@ylkhcyszslsh ut_lsh=’’		银联卡预授中心流水号(冲)

	,@cardxh ut_xh12=0,					代币卡序号
	,@cardje ut_money=0					代币卡金额
	,@bdyhkje ut_money = 0      绑定银行卡金额
	,@bdyhklsh ut_lsh = ''      绑定银行卡流水号
	,@zlje	ut_money=0		找零金额 
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]

[修改说明]
Modify by qxh  2003.2.27  
	增加按处方打印发票的处理 
add by chenwei 2003.12.06
	代币卡病人处理 
modify by szj	 2004.02.18 充值卡需要提供密
	码才可以收费添加了@czksfbz 参数。控制是否从充值卡上扣钱
add by gzy at 20050520 增加0081根据不同要求生成不同的药房流水号
mod by ozb 20060622
	屏蔽掉走发票的内容 在打印发票前调用 usp_sf_zfp进行处理，因为收费后才分发票
	增加保存找零金额
ozb 20060705 增加兼容性，兼容以前的发票打印模式
wfy 20070315 修改yflsh处理部分代码，原代码不能实现设计目的
wfy 20070316 当开关‘0081’设为2时，医保组把生成的流水号保存到SF_MZCFK中的fyckxh,综合组用的是yflsh字段
**********/
set nocount on

--winning-dingsong-chongqing-判断@wkdz不能为空
if(isnull(@wkdz,'')='')
begin
	select @wkdz=@patid
	--select 'F','传入参数@wkdz不能为空！'
	--return
end

declare	@now ut_rq16,		--当前时间
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
		@sfje_all ut_money,	--实收金额(包含自费金额)
		@errmsg varchar(50),
		@srbz char(1),		--舍入标志
		@srje ut_money,		--舍入金额
		@sfje2 ut_money,	--舍入后的实收金额
		@xhtemp ut_xh12,
		@ksmc ut_mc32,		--科室名称
		@ysmc ut_mc64,		--医生姓名
--		@xmzfbl float,		--药品自付比例
--		@xmzfbl1 float,		--非药品自付比例
		@xmzfbl numeric(12,4),		
		@xmzfbl1 numeric(12,4),	--mit ,, 2oo3-o7-28 ,,float的话四舍五入有问题	
		@xmce ut_money,		--自付金额和大项自付金额汇总的差额
		@fplx smallint,		--发票类型
		@fph bigint,			--发票号
		@fpjxh ut_xh12,		--发票卷序号
		@print smallint,	--是否打印0打印，1不打
		@pzh ut_pzh,		--凭证号
		@brlx ut_dm2,		--病人类型
		@qkbz1 smallint,	--欠款标志0：正常，1：记账，2：欠费 3：扣充值卡
		@zhje ut_money,		--账户金额
		@qkje ut_money,		--欠款金额（记账金额）
		@acfdfp ut_bz,	        --是否按处方打发票  
		@yjbz ut_bz,		--是否使用充值卡
		@yjye ut_money,		--预交金余额
		@flzfje ut_money	--分类自负金额
		,@djje ut_money		--冻结金额
		,@sjyjye ut_money	--实际押金余额
		,@sjdjje ut_money,	--实际冻结金额		--mit , 2oo3-11-19
		@cardbz ut_bz,	    --是否使用代币卡
		@kdm ut_dm2,		--代币卡分类代码
		@kmc ut_mc16,		--代币卡名称
		@cardno ut_pzh,		--代币卡卡号
		@tcljbz ut_bz,		--统筹累计标志
		@tcljje1 ut_money	--统筹累计金额（镇保、新疆回沪使用） 
		,@qkje2 ut_money
		,@yflsh	integer		--药房流水号
		,@gyfpbz ut_bz		--公用发票标志0:私用1:公用
		,@fyckdm1 ut_dm2	--发药窗口代码1	--add by gzy at 20050518
		,@fyckxh INTEGER		--发药窗口序号	--add by gzy at 20050518
		,@tsyhje ut_money  ---特殊优惠金额 
		,@spzlx varchar(10)  --双凭证类型
		,@gbje ut_money
		,@ysybzfje  ut_money --原始医保自负金额,2005-11-14干保要求打印实际干保自负金额
		,@gbje2 ut_money    --2005-11-14干保要求打印自费金额2
		,@gbbz ut_bz	--干保标志
		,@configdyms	ut_bz	--打印模式 0 旧的打印模式 1 新的打印模式
		,@tjmfbz ut_bz  --体检免费标志
		,@sctjrq ut_rq8 --上次体检日期
    	,@bdyfplb varchar(255)
		,@tcljybdm varchar(500)  --统筹累计医保集合
		,@lczje ut_money		--零差药费总金额	
		,@lcyhje ut_money       --零差优惠金额
		,@yydjje ut_money
		,@now8 ut_rq16
			,@djjexs ut_zfbl	--冻结金额系数，和参数H353有关，1：否，0：是
		,@iscreateblh ut_bz --0卡号病人收费时是否自动生成病历号。

declare @jzxh ut_xh12,
		@czym ut_mc64,
		@pycfxh	ut_xh12,
		@pyhjxh	ut_xh12,
        @fpbz ut_bz ---0打印1不打印
        ,@dbkye ut_money 
        ,@dbkzf ut_money
        ,@config0220 ut_bz	--1按工号和科室代码领发票模式0传统模式
        ,@configA234 ut_bz  -- ADD KCS 是否启用HRP系统
        ,@fpdm varchar(16)
		,@ysxjje ut_money	--预算现金金额 
        ,@ysyjye ut_money --正常结算后押金余额       
		,@zsxjje ut_money  --正算算现金金额 
		,@zsyjye ut_money --正常结算后押金余额 
		,@config2391	smallint	--判断押金余额是否为负值,并且回滚数据
        ,@config1524 char(2)
        ,@config0203 char(2)
        ,@config2559 char(2)		
select @now8 = convert(char(8),getdate(),112),@yflsh = 0

select @now=convert(char(8),getdate(),112)+convert(char(8),getdate(),8),
	@zje=0, @lczje=0, @zfyje=0, @yhje=0, @ybje=0,
	@zje1=0, @zfyje1=0, @yhje1=0, @ybje1=0,
	@sfje=0, @sfje1=0, @sfje_all=0, @srje=0, @sfje2=0, 
	@xmzfbl=0, @xmzfbl1=0, @xmce=0, @print=0, @fplx=0,
	@qkbz1=0, @qkje=0, @yjbz=0, @yjye=0, @flzfje=0
	,@sjyjye=0,@sjdjje=0,@cardbz=0,@kdm='',@kmc='',@cardno='',@tcljbz=0,@tcljje1=0,@yflsh=0, @gyfpbz=0
	,@tsyhje = 0, @gbje=0, @ysybzfje = 0,@gbje2 = 0,@gbbz = '0'
	 ,@lcyhje = 0,@lczje = 0,@yydjje = 0,@fpbz =0,@fpdm=''
	,@ysxjje=0	--预算现金金额 
    ,@ysyjye=0 --正常结算后押金余额       
	,@zsxjje=0  --正算算现金金额 
	,@zsyjye=0 --正常结算后押金余额 
	,@config2391=0
	,@config2559='否'
	
select @spzlx = spzlx from SF_BRXXK (nolock)where patid = @patid
 
select @czym=name from czryk where id=@czyh

----add by yangdi 优化流程冻结金额处理
select @djjexs=1
if exists(select 1 from YY_CONFIG(nolock) where id='H353' and config='是')
	select @djjexs=0

select @iscreateblh=0
if exists(select 1 from YY_CONFIG(nolock) where id='3041' and config='是')
	select @iscreateblh=1




if (select config from YY_CONFIG (nolock) where id='2391')='否'
	select   @config2391=0
else
 	select   @config2391=1
 
if (select config from YY_CONFIG (nolock) where id='2044')='否'
	select   @acfdfp=0
else
 	select   @acfdfp=1

--是否使用代币卡结算
if (select config from YY_CONFIG (nolock) where id='2083')='否'
	select   @cardbz=0
else
 	select   @cardbz=1

if (select config from YY_CONFIG (nolock) where id='2135')='是'
	select @gyfpbz = 1
else
	select @gyfpbz = 0
	
if exists (select 1 from YY_CONFIG(nolock) where id='1524' and config='否')
    select @config1524='否'
else
    select @config1524='是'   	
   
if exists (select 1 from YY_CONFIG(nolock) where id='0203' and config='否')
    select @config0203='否'
else
    select @config0203='是'   	    
      
--add by ozb 收费是否使用新的打印模式
if exists(select 1 from YY_CONFIG(nolock) where id='2154' and config='是')
	select @configdyms=1 
else 
	select @configdyms=0
 
if (select config from YY_CONFIG (nolock) where id='0220')='是'      
	select @config0220=1      
else      
	select @config0220=0   
	
if (select config from YY_CONFIG (nolock) where id='A234')='是'      
	select @configA234=1      
else      
	select @configA234=0 
if exists (select 1 from YY_CONFIG(nolock) where id='2559' and config='是')
    select @config2559='是'
else
    select @config2559='否'
if @config0203='是' and @zph='S' 
begin
	exec usp_pay_judgesettlement 1,@patid,@sjh,0,0,0,0,0,@errmsg output   
  	if substring(@errmsg,1,1)='F'   
  	begin  
   		select "F",@errmsg  
   		return  
  	end    
end	
--add wuwei 2011-06-10
declare @srfs varchar(1)  --0：精确到分，1：精确到角
select @srfs = config from YY_CONFIG (nolock) where id='2235'
if @@error<>0 or @@rowcount=0
	select @srfs='0'

if @qkbz=2 --and (select zhbz from YY_YBFLK (nolock) where ybdm=@ybdm)<>'2'
begin
	if  exists (select 1 from YY_CONFIG where id='2538' and config='是' )
	begin
		if exists (select 1 from YY_CONFIG where id='1657' and config='是' )
		begin
			if exists (select 1 from SF_BRXXK_FZ where patid=@patid and lstdbz=1 )
			begin
				if not exists (select 1 from SF_BRXXK_FZ where patid=@patid and @now between lstdkssj and lstdjssj)
				begin
					select "F","病人结算时间不在欠费结算有效期内！"
					return
				end
			end	
			else
			begin	
				if (select zhbz from YY_YBFLK (nolock) where ybdm=@ybdm)<>'2'
				begin
					select "F","该患者不允许欠费！"
					return
				end
			end	
		end
		else
		begin
			if (select zhbz from YY_YBFLK (nolock) where ybdm=@ybdm)<>'2'
			begin
				select "F","该患者不允许欠费！"
				return
			end
		end
	end
	else
	if (select zhbz from YY_YBFLK (nolock) where ybdm=@ybdm)<>'2'
	begin
		select "F","该患者不允许欠费！"
		return
	end
end


if @sfbz=2
begin
	select @ybdm=ybdm, @qkbz1=qkbz, @qkje=qkje, @zje=zje, @lczje=zje-lcyhje, @sfje2=zfje, @zfyje=zfyje, @qrbz=qrbz, @flzfje=flzfje,
			@yhje=yhje, @tcljbz=tcljbz, @tcljje1=zje-zfyje,@tsyhje = tsyhje, @gbje=isnull(gbje,0)
			,@gbbz = gbbz, @tjmfbz =isnull(tjmfbz,0),@lcyhje = lcyhje,
			@ysxjje=xjje	--预算现金金额 
			,@ysyjye=qkje --正常结算后押金余额 
		from SF_BRJSK where sjh=@sjh
	if @@rowcount=0
	begin
		select "F","该收费结算记录不存在！"
		return
	end
	--欠款病人的记账金额要打印出来，同时账户金额-@qkje2，如果@qkbz1 = 3，还可以按照原来的值
	if @qkbz1 = 1
		select @qkje2 = isnull((select je from SF_JEMXK where jssjh = @sjh and lx = '01'),0) 
	else 
		select @qkje2 = @qkje

	select @pzlx=pzlx from YY_YBFLK (nolock) where ybdm=@ybdm
	if @@rowcount=0 or @@error<>0
	begin
		select "F","患者费用类别不正确！"
		return
	end

	select @jzxh=case when isnull(zcbz,0)=0 then xh else isnull(zkxh,xh) end ,
        @fpbz =isnull(fpbz,0)
		from YY_JZBRK where patid=@patid and jlzt=0
	if @@rowcount=0
    begin
		select @yjye=0
        select @fpbz=0
    end
	else
	begin
		select @yydjje=sum(isnull(djje,0)) from GH_GHYYK(nolock) where patid=@patid and djbz=1 and jlzt = 0 

		select @yjye=isnull(yjye,0)-isnull(@yydjje,0) from YY_JZBRK where xh=@jzxh and jlzt=0
		if @@rowcount=0
			select @yjye=0
		else
			select @yjbz=1
	end	
	
	--控制充值卡 储值卡不能同时使用
	if @yjbz=1
	begin
	    if @config0203='是'
	    begin
	        if exists(select 1 From YY_PAYTYPEK where id=3 and jlzt=0)


	        begin
				select "F","充值卡和储值卡功能不能同时启用！"
				return






	        end	    
	    end	
	end	
-- 在预算时，qkje和舍入金额已经处理完，无须再次计算
--	if @czksfbz = 1 --从充值卡收费
--	begin
--		if @yjye>0
--		begin
--			if (@sfje2-@gbje)<=@yjye
--				select @qkje=(@sfje2-@gbje)
--			else
--			begin	
--				if @srbz='5'
--					select @qkje=round(@yjye, 1)
--				else if @srbz='6'
--					exec usp_yy_wslr @yjye,1,@qkje output 
--				else if @srbz>='1' and @srbz<='9'
--					exec usp_yy_wslr @yjye,1,@qkje output,@srbz
--				else
--					select @qkje=@yjye	
--			end
--		end
--	end
--
--	---add wuwei 2011-06-13
--	if @srfs = '1'---1：精确到角则先舍入20110426sqf
--	begin
--		select @qkje=round(@qkje, 1,1) ---去掉小数位
--	end
    if (select config from YY_CONFIG (nolock) where id='0133')='否' and @fpbz ='1'
		select @print=2

	if @qkbz=2 --and (select zhbz from YY_YBFLK (nolock) where ybdm=@ybdm)<>'2'
	begin
	    if exists (select 1 from YY_CONFIG where id='1657' and config='是' )
		begin
			if exists (select 1 from SF_BRXXK_FZ where patid=@patid and lstdbz=1 )
			begin
				if not exists (select 1 from SF_BRXXK_FZ where patid=@patid and @now between lstdkssj and lstdjssj)
				begin
					select "F","病人结算时间不在欠费结算有效期内！"
					return
				end
			end	
		end
		else
		if (select zhbz from YY_YBFLK (nolock) where ybdm=@ybdm)<>'2'
		begin
			select "F","该患者不允许欠费！"
			return
		end
	end

	if @qkbz=2
		select @qkbz1=2, @qkje=@sfje2

	select hjxh	into #sfcfk from SF_MZCFK(nolock) where jssjh=@sjh
	if @@rowcount=0
	begin
		select "F","收费信息不存在！"
		return		
	end 

	
	if (@config2559='否') and exists(select 1 from SF_HJCFK(nolock) where jlzt=1 and isnull(ybtscf,0)<>1 and xh in (select hjxh from #sfcfk) and patid=@patid)
	begin
		select "F","当前处方已经被结算，无法再次进行结算！"
		return	
	end
	
	if @qkbz1=2 and @qkje>0
		select @print=1
	if exists(select 1 from YY_CONFIG (NOLOCK)WHERE id='2275' and config='是') and 	@qkbz1=2 --yxc 20121207
	BEGIN
		select @print=0	
	
	END	
	-- by cjt 20130726 缺费标志为1时将确认标志设置为1,在接下的语句中会做更新,此处主要用于发票打印判断
	if @isQfbz=1 
	begin
		select @qrbz=1
	end
	if @qrbz=1
		select @print=1
	
	 --add by gxf 2007-6-7 
	 select @bdyfplb = config from YY_CONFIG where id = '2161'
	 if @sfje2 = 0 
			if charindex(',' + LTrim(RTrim(@ybdm)) + ',',','+@bdyfplb+',')>0 
				select @print=1
	--add by gxf 2007-6-7

	if (select config from YY_CONFIG (nolock) where id='2238')='否'
	begin 
		if @sfje2 = 0 
		    select @print=1 
	end

	
	--add wuwei 代币卡支付不打印发票
	if (select config from YY_CONFIG where id ='2243' ) ='否'
	begin
		if (@cardxh <>0) and (@cardje<>0)
			select @print=1
	end
	--老发票模式中增加对参数2273受控
	if exists(select 1 from YY_CONFIG where id = '2273' and charindex(',' + LTrim(RTrim(@ybdm)) + ',',','+config+',')>0) 
		select @print=1

	begin tran
	
	-- add kcs by 11439 增减物资库存
	if (@configA234 = 1) and (exists (select 1 from SF_BRJSK a
					inner join SF_MZCFK b on a.sjh = b.jssjh
					inner join SF_CFMXK c on b.xh = c.cfxh
					inner join SF_HJCFMXK d on c.hjmxxh = d.xh
					where a.sjh = @sjh and ISNULL(d.wzkfdm,'') <> '' and isnull(d.wzdm,'')<>''))   -- 分析要求通过SF_HJCFMXK.wzkfdm 是否有值判断是否扣费扣库存
	begin
	    declare 
		   @kc_ifid               ut_xh12,                --接口全局标识
		   @kc_ifid_t             ut_xh12,                --退序号
		   @kc_kfdm               varchar(12),            --手术室库房
		   @kc_wzdm               ut_mc32,                --物资代码
		   @kc_xmmc               ut_mc64,                --项目名称
		   @kc_pcxh               varchar(120),           --退时,必须不能为空
		   @kc_wzsl               ut_sl10 ,            --负数为退
		   @kc_xhfs               ut_zt,                  --消耗方式:0: 材料记帐; 1: 材料补记帐; 3. 医嘱执行; 4.医技收费; 5.手术费用,6.门诊手术费用录入; 9.其他
		   @kc_ksdm               ut_ksdm,         --手术室  扣费科室代码
		   @kc_ksmc               ut_mc32,         --扣费科室民称
		   @kc_bqdm               ut_ksdm,
		   @kc_bqmc               ut_mc32,
		   @kc_pKsdmBr            ut_ksdm,         --病人科室代码,外科的住院病人
		   @kc_pKsmcBr            ut_mc32,         --病人科室名称
		   @kc_pDrName            ut_mc64,         --医生姓名，用于签字
		   @kc_pNurseName         ut_mc64,         --护士姓名，用于签字
		   @kc_syxh               ut_syxh,
		   @kc_blh                ut_blh,
		   @kc_ch                 ut_mc16 ,         --床号
		   @kc_patid              ut_syxh ,
		   @kc_patname            ut_mc64 ,
		   @kc_zxczy              ut_czyh ,
		   @kc_zxczyxm            ut_mc64 ,
		   @kc_lrczy              ut_czyh ,         --录入操作员
		   @kc_lrczyxm            ut_mc64 ,         --录入操作员姓名
		   @kc_fymxh              ut_xh12 ,         --费用明细号
		   @kc_pHjmxh             ut_xh12 ,           --划价明细号
		   @kc_pTxmMaster         ut_mc64 ,         --主条形码
		   @kc_pTxmSlave          ut_mc64 ,         --从条形码
		   @kc_pNeedNewBill       ut_zt ,            -- 补录入出库
		   @kc_memo               ut_memo,         -- 备注
		   @outpcxh            ut_mc64,
		   @outpcsl            ut_mc64,
		   @hrperrmsg             ut_mc64,
		   @config6845            VARCHAR(20),
		   @sql                   nVARCHAR(3000),
		   @ParmDefinition        nvarchar(500)
		select @kc_wzsl= 1,@kc_pHjmxh= -1,@kc_pNeedNewBill= '0'
		select @config6845 = config from YY_CONFIG where id = '6845'
		
		declare lscm_kc cursor for select c.xh from SF_BRJSK a
					inner join SF_MZCFK b on a.sjh = b.jssjh
					inner join SF_CFMXK c on b.xh = c.cfxh
					inner join SF_HJCFMXK d on c.hjmxxh = d.xh
					where a.sjh = @sjh and ISNULL(d.wzkfdm,'') <> '' and ISNULL(d.wzdm,'') <> '' 
	    open lscm_kc
	    fetch lscm_kc into @kc_ifid
		while @@fetch_status=0 
	    begin        
	        select @kc_kfdm = b.wzkfdm,@kc_wzdm = case isnull(b.wzdm,'') when '' then '"0"' else b.wzdm end,@kc_xmmc = a.ypmc,@kc_pcxh = b.wzpcxh,@kc_wzsl = a.ypsl,
	               @kc_ksdm = c.sfksdm,@kc_ksmc = d.name,@kc_fymxh = a.xh,@kc_pHjmxh = b.xh,@kc_pTxmMaster = b.tm,
	               @kc_pTxmSlave = b.ctxm,@kc_pKsdmBr = e.ksdm,@kc_pKsmcBr = f.name,@kc_pDrName = g.name,@kc_blh = h.blh,
	               @kc_patid = @patid,@kc_patname = h.hzxm,@kc_zxczy = e.qrczyh,@kc_zxczyxm = i.name  
	                 from SF_CFMXK a
	                 inner join SF_HJCFMXK b on a.hjmxxh = b.xh
	                 inner join SF_BRJSK c on c.sjh = @sjh
	                 inner join YY_KSBMK d on c.sfksdm = d.id
	                 left join SF_MZCFK e on a.cfxh = e.xh
	                 left join YY_KSBMK f on e.ksdm = f.id
	                 left join YY_ZGBMK g on e.ysdm = g.id
	                 left join SF_BRXXK h on e.patid = h.patid
	                 left join czryk i on e.qrczyh = i.id
					 where a.xh = @kc_ifid					 		 	 
					 
			select @sql = N'exec ' + @config6845 + 'dbo.USP_LSCM_IF4THIS_KC @ifid = ' + convert(varchar(12),isnull(@kc_ifid,0))
			            +', @kfdm = "' + convert(varchar(12),isnull(@kc_kfdm,''))
			            +'", @wzdm = ' + convert(varchar(12),isnull(@kc_wzdm,0))
			            +', @xmmc = "'+ convert(varchar(64),isnull(@kc_xmmc,''))
			            +'",@pcxh=' + convert(varchar(12),isnull(@kc_pcxh,0))
			 +',@wzsl=' + convert(varchar(12),isnull(@kc_wzsl,''))
			            +',@xhfs=7,'
			            +'@ksdm="' + convert(varchar(12),isnull(@kc_ksdm,''))
			            +'",@ksmc="'+ convert(varchar(64),isnull(@kc_ksmc,''))
			            +'",@pHjmxh='+ convert(varchar(12),isnull(@kc_pHjmxh,''))
			            +',@pTxmMaster="'+convert(varchar(64),isnull(@kc_pTxmMaster,''))
			            +'",@pTxmSlave="'+convert(varchar(64),isnull(@kc_pTxmSlave,''))
			            +'",@pKsdmBr="'+convert(varchar(12),isnull(@kc_pKsdmBr,''))
			            +'",@pKsmcBr="'+convert(varchar(12),isnull(@kc_pKsmcBr,''))
			            +'",@pDrName="'+convert(varchar(64),isnull(@kc_pDrName,''))
			            +'",@blh="'+convert(varchar(12),isnull(@kc_blh,''))
			            +'",@patid="'+convert(varchar(12),isnull(@kc_patid,''))
			            +'",@patname="'+convert(varchar(64),isnull(@kc_patname,''))
			            +'",@zxczy="'+convert(varchar(12),isnull(@kc_zxczy,''))
			            +'",@zxczyxm="'+convert(varchar(64),isnull(@kc_zxczyxm,''))
			            +'"'
			 
			select  @sql = @sql + N',@outpcxh = @outpcxh OUTPUT ,@outpcsl = @outpcsl output,@errmsg = @hrperrmsg output '
			set  @ParmDefinition = N' @outpcxh varchar(100) output,@outpcsl  varchar(100) output,  @hrperrmsg varchar(64) output '
			            
			exec sp_executesql @sql,@ParmDefinition,@outpcxh = @outpcxh OUTPUT,@outpcsl = @outpcsl OUTPUT ,@hrperrmsg=@hrperrmsg OUTPUT 		
            IF (@@ERROR<>0)or (@hrperrmsg like 'F%')
            begin
                select 'F','扣除物资库存失败！'+@hrperrmsg
				rollback tran
				DEALLOCATE lscm_kc
                return      
            end
            
			select @sql = N'exec ' + @config6845 + 'dbo.USP_LSCM_IF4THIS_KC @ifid = ' + convert(varchar(12),isnull(@kc_ifid,0))
			            +', @kfdm = "' + convert(varchar(12),isnull(@kc_kfdm,''))
			            +'", @wzdm = ' + convert(varchar(12),isnull(@kc_wzdm,0))
			            +', @xmmc = "'+ convert(varchar(64),isnull(@kc_xmmc,''))
			            +'",@pcxh=' + convert(varchar(12),isnull(@kc_pcxh,0))
			            +',@wzsl=' + convert(varchar(12),isnull(@kc_wzsl,''))
			            +',@xhfs=7,'
			            +'@ksdm="' + convert(varchar(12),isnull(@kc_ksdm,''))
			            +'",@ksmc="'+ convert(varchar(64),isnull(@kc_ksmc,''))
			            +'",@pHjmxh='+ convert(varchar(12),isnull(@kc_pHjmxh,''))
			            +',@pTxmMaster="'+convert(varchar(64),isnull(@kc_pTxmMaster,''))
			            +'",@pTxmSlave="'+convert(varchar(64),isnull(@kc_pTxmSlave,''))
			            +'",@pKsdmBr="'+convert(varchar(12),isnull(@kc_pKsdmBr,''))
			            +'",@pKsmcBr="'+convert(varchar(12),isnull(@kc_pKsmcBr,''))
			            +'",@pDrName="'+convert(varchar(64),isnull(@kc_pDrName,''))
			            +'",@blh="'+convert(varchar(12),isnull(@kc_blh,''))
			            +'",@patid="'+convert(varchar(12),isnull(@kc_patid,''))
			            +'",@patname="'+convert(varchar(64),isnull(@kc_patname,''))
			            +'",@zxczy="'+convert(varchar(12),isnull(@kc_zxczy,''))
			            +'",@zxczyxm="'+convert(varchar(64),isnull(@kc_zxczyxm,''))
			            +'",@fymxh="'+convert(varchar(12),isnull(@kc_fymxh,'')) 	
			            +'"'
			 
			select  @sql = @sql + N',@outpcxh = @outpcxh OUTPUT ,@outpcsl = @outpcsl output,@errmsg = @hrperrmsg output '
			set  @ParmDefinition = N' @outpcxh varchar(100) output,@outpcsl  varchar(100) output,  @hrperrmsg varchar(64) output '
			            
			exec sp_executesql @sql,@ParmDefinition,@outpcxh = @outpcxh OUTPUT,@outpcsl = @outpcsl OUTPUT ,@hrperrmsg=@hrperrmsg OUTPUT 		
            IF (@@ERROR<>0)or (@hrperrmsg like 'F%')
            begin
                select 'F','扣除物资库存失败！'+@hrperrmsg
				rollback tran
				DEALLOCATE lscm_kc
                return      
            end  
            
if @kc_wzdm = 'NULL'
				select  @kc_wzdm = 0
                      
            if exists(select 1 From sysobjects where name ='YY_SF_HRP_LOG')
            begin            
				insert into YY_SF_HRP_LOG(
				kc_ifid            
				,kc_ifid_t          
				,kc_kfdm            
				,kc_wzdm            
				,kc_xmmc            
				,kc_pcxh            
				,kc_wzsl            
				,kc_xhfs            
				,kc_ksdm            
				,kc_ksmc            
				,kc_bqdm            
				,kc_bqmc            
				,kc_pKsdmBr         
				,kc_pKsmcBr         
				,kc_pDrName         
				,kc_pNurseName      
				,kc_syxh            
				,kc_blh             
				,kc_ch              
				,kc_patid           
				,kc_patname         
				,kc_zxczy           
				,kc_zxczyxm         
				,kc_lrczy           
				,kc_lrczyxm         
				,kc_fymxh           
				,kc_pHjmxh          
				,kc_pTxmMaster      
				,kc_pTxmSlave       
				,kc_pNeedNewBill    
				,kc_memo            
				,outpcxh            
				,outpcsl            
				,hrperrmsg          
				 )
				 values
				 (
				 @kc_ifid          
				,@kc_ifid_t       
				,@kc_kfdm         
				,@kc_wzdm         
				,@kc_xmmc         
				,@kc_pcxh         
				,@kc_wzsl         
				,@kc_xhfs         
				,@kc_ksdm         
				,@kc_ksmc         
				,@kc_bqdm         
				,@kc_bqmc         
				,@kc_pKsdmBr      
				,@kc_pKsmcBr      
				,@kc_pDrName      
				,@kc_pNurseName   
				,@kc_syxh         
				,@kc_blh          
				,@kc_ch           
				,@kc_patid        
				,@kc_patname      
				,@kc_zxczy        
				,@kc_zxczyxm      
				,@kc_lrczy        
				,@kc_lrczyxm      
				,@kc_fymxh        
				,@kc_pHjmxh       
				,@kc_pTxmMaster   
				,@kc_pTxmSlave    
				,@kc_pNeedNewBill 
				,@kc_memo         
				,@outpcxh         
				,@outpcsl         
				,@hrperrmsg  
				 )            
				IF (@@ERROR<>0)
				begin
					select 'F','扣除物资库存失败！'
					rollback tran
					DEALLOCATE lscm_kc
					return      
				end               
            end
            fetch lscm_kc into @kc_ifid
        end
        close lscm_kc
        deallocate lscm_kc
	end

	
    if @print=0 and @configdyms=0 and @isQfbz=0


	begin
		if (select config from YY_CONFIG (nolock) where id='1022')='是'   --挂号发票和收费发票一致
			select @fplx=0
		else
			select @fplx=1

		if @acfdfp=0 
      	begin
			if @gyfpbz=0
			begin
				if @config0220=1
				select @fph=fpxz, @fpjxh=xh,@fpdm=isnull(fpdm,'') from SF_FPDJK(nolock) where lyry=@czyh and jlzt=1 and xtlb=@fplx and ksdm=@sfksdm
				else
				select @fph=fpxz, @fpjxh=xh,@fpdm=isnull(fpdm,'') from SF_FPDJK(nolock) where lyry=@czyh and jlzt=1 and xtlb=@fplx
				if @@rowcount=0
				begin
					select "F","没有可用发票！"
					rollback tran

					return
				end
			end
			else
			begin
				select @fph=fpxz, @fpjxh=0,@fpdm=isnull(fpdm,'') from SF_GYFPK(nolock) where czyh=@czyh and xtlb=@fplx
				if @@rowcount=0
				begin
					select "F","没有可用发票！"
					rollback tran

					return
				end
			end

			exec usp_yy_gxzsj @fplx, @czyh, @errmsg output, @gyfpbz,@fpjxh,@sfksdm,@ipdz_gxzsj
			if @@ERROR <> 0
			begin
				select "F",'更新发票号失败！'
				rollback tran
				return
			end
			if @errmsg like 'F%'
			begin
				select "F",substring(@errmsg,2,49)
				rollback tran

				return
			end
		end
		else 

		begin
			--取处方发票号 begin
			exec usp_sf_acfdfp_zfp @sjh,0,@czyh,@errmsg output,@sfksdm
			if @errmsg like 'F%'
			begin
				select "F",substring(@errmsg,2,49)
				rollback tran

				return


			end
			select top 1 @fph=fph,@fpjxh=fpjxh from SF_MZCFK(nolock) where jssjh=@sjh order by fph



		end	
	end
	--mit ,, 2oo3-o8-29 ,, 医技确认的项目收费后fybz置为1
		--move here , 先更新否则jlzt就不对了, 2oo3-12-11
/*	update SF_MZCFK 
	set fybz=1,qrczyh=b.qrczyh,qrrq=b.qrrq,qrksdm=b.yfdm
	from SF_MZCFK a,SF_HJCFK b
	where a.jssjh=@sjh
	and a.hjxh=b.xh
	and b.jlzt in(3,8)
	if @@error<>0
	begin
		rollback tran
		select "F","更新门诊处方信息出错！"
		return
	end
*/
	if @hcsjh=''  --医保转自费时,不在这更新yjqrbz,以前台传入的为准
	begin
		update SF_CFMXK set yjqrbz=b.fybz,qrczyh=b.qrczyh,qrrq=b.qrrq
		from SF_CFMXK a,SF_MZCFK b
		where a.cfxh=b.xh and b.jssjh=@sjh and b.fybz=1
		if @@error<>0
		begin
			rollback tran
			select "F","更新门诊处方明细信息出错！"
			return
		end
	end
	--add by zyh 20100304 H354 对无需确认的小项目和执行科室为医生本科室的项目在结算后直接修改医技确认标志为已确认
	if exists(select 1 from YY_CONFIG WHERE id='H354' and config='是')
	begin
		update SF_CFMXK set yjqrbz=1,qrczyh=@czyh,qrrq=@now
		from SF_CFMXK a,SF_MZCFK b,YY_SFXXMK c
		where a.cfxh=b.xh and b.jssjh=@sjh and isnull(a.hjmxxh,0)>0 and a.cd_idm=0 and a.ypdm=c.id and a.yjqrbz=0 and c.mzyjqrbz=0
		if @@error<>0
		begin
			rollback tran
			select "F","更新门诊处方明细信息出错！"
			return
		end

		update SF_CFMXK set yjqrbz=1,qrczyh=@czyh,qrrq=@now
		from SF_CFMXK a,SF_MZCFK b,SF_HJCFMXK c,SF_HJCFK d
		where a.cfxh=b.xh and b.jssjh=@sjh and isnull(a.hjmxxh,0)>0 and a.cd_idm=0 and a.yjqrbz=0 and a.hjmxxh=c.xh and c.cfxh=d.xh and d.ksdm=d.yfdm
		if @@error<>0
		begin
			rollback tran
			select "F","更新门诊处方明细信息出错！"
			return
		end
	end
    -----------------------add by sqf 2012-11-22更新处方库的wsbz 
    update SF_MZCFK  set wsbz = b.wsbz 
    from SF_MZCFK a,SF_HJCFK b
    where a.jssjh = @sjh and a.hjxh = b.xh and isnull(a.hjxh,0) > 0 and b.cflx = 3 ----草药
  /*
  判断划价库数据有没有被结算过注释掉,多发票处理时可能发生第一次结算一个HJCFMX中的一部分,第二次再结算这个HJCFMX里中另一部分的情况
  但是SF_HJCFK.jlzt在第一次结算的时候就更新了,导致第二次结算提示"该处方已经被结算，不能重复结算！"  
  */
--	--判断划价库数据有没有被结算过  
--	if exists(select 1 from SF_HJCFK a,#sfcfk b where a.patid=@patid and a.xh=b.hjxh and a.jlzt=1 and b.hjxh<>0)
--	begin
--		select "F","该处方已经被结算，不能重复结算！"
--		rollback tran
--		return
--	end

	update SF_MZCFK set jlzt=0,
		lrrq=(case when @jsrq='' then @now else @jsrq end),
		czyh=@czyh
		where jssjh=@sjh
	if @@error<>0
	begin

		rollback tran
		select "F","更新门诊处方信息出错！"
		return
	end
	--体检处方收费后直接确认  需求332134
	if exists(select 1 from YY_CONFIG nolock where id='2584' and config='是')
	begin
		update a set yjqrbz=1,qrczyh=@czyh,qrrq=@now
		from SF_CFMXK a,SF_MZCFK b(nolock)
		where a.cfxh=b.xh and b.jssjh=@sjh and b.cflx=6 and a.yjqrbz=0
		if @@error<>0
		begin

			rollback tran
			select "F","更新门诊处方明细医技状态信息出错！"
			return
		end
	end
----诊疗方案收费成功后更新收费标志  SF_HJCFMXK.sjzlfabdxh<>0  ZLFA_SJBDK.SFBZ=1
	select hjxh	into #fasfcfk from VW_MZCFK (nolock)where jssjh=@sjh
	if @@rowcount=0


	begin
		select "F","收费信息不存在！"
		rollback tran

		return		
	end

	update a set a.sfbz=1 from ZLFA_SJBDK a, VW_MZHJCFMXK b
		where b.cfxh  in (select hjxh from #fasfcfk ) and a.xh=b.sjzlfabdxh
	if @@error<>0

	begin
		select "F","更新三级绑定收费信息出错！"
		rollback tran
		return

	end 
----end
	
	
	--mit , 2oo3-11-1o
	if @czksfbz = 1
	begin
		if @yjbz=1
		begin
			--mit , 2oo3-11-o8 , move here
			select @djje=sum(isnull(djje,0)) from SF_HJCFK 
				where xh in (select hjxh from #sfcfk)
			select @djje=isnull(@djje,0)
			if @djje<>0
			begin
				if exists(select 1 from YY_JZBRK where xh=@jzxh and jlzt=0 and djje>@djje)--gxs 20131224 add
				begin
					update YY_JZBRK set djje=djje-@djje 
					,@sjdjje=djje-@djje		--mit ,2oo3-11-19 , add
					where xh=@jzxh and jlzt=0
				end
				else
				begin
					update YY_JZBRK set djje=0
					,@sjdjje=djje-@djje		--mit ,2oo3-11-19 , add
					where xh=@jzxh and jlzt=0
				end
				if @@error<>0
				begin
					select "F","更新记账病人库预交金余额出错！"
					rollback tran
					return
				end
			end
		end
		
		if @yjbz=1 and @qkbz1=3
		begin
            --计算代币卡支付部分，优先扣代币卡转存部分金额
            select @dbkye=isnull(dbkye,0) from YY_JZBRK where xh=@jzxh and jlzt=0  
            if @dbkye>=@qkje 
            select @dbkzf=@qkje 
            else
            select @dbkzf=@dbkye
      
			update YY_JZBRK set yjye=yjye-@qkje,dbkye=isnull(dbkye,0)-@dbkzf 
			,@sjyjye=yjye-@qkje		--mit ,2oo3-11-19 , add
			,@sctjrq=isnull(sctjrq,"")	
			where xh=@jzxh and jlzt=0
			if @@error<>0
			begin
				select "F","更新记账病人库预交金余额出错！"
				rollback tran
				return
			end
			
			insert into YY_JZBRYJK(fpjxh,fph,jzxh,czyh,czym,lrrq,jje,dje,yje,zffs,czlb,hcxh,jlzt,memo,sjh,ybdm,dbkje)
			values(0,0,@jzxh,@czyh,@czym,@now,@qkje,0,@sjyjye,1,3,null,0,'',@sjh, @ybdm,@dbkzf)
			if @@error<>0
			begin
				select 'F','插入YY_JZBRYJK记录时出错'
				rollback tran
				return
			end
            insert into SF_CARDZFJEK(jssjh,lx,mc,je,memo)
            values(@sjh,'3','充值卡支付',@qkje,'')
            if @@error<>0
			begin
				select 'F','插入YY_JZBRYJK记录时出错'
				rollback tran
				return
			end

			if @tjmfbz=1 and @sctjrq<>substring(@now,1,8)
			begin
				update YY_JZBRK set tjcs=isnull(tjcs,0)+1
					,sctjrq=substring(@now,1,8)
				where xh=@jzxh and jlzt=0
				if @@error<>0
				begin
					select "F","更新记账病人库预交金余额出错！"
					rollback tran
					return
				end
			end
		end
	end	
	--add by yangdi 2014.4.11 通过hzxm触发平台消息，同步blh信息。 add by yangdi 2019.12.27
	declare @newblh ut_blh
	if exists (select 1 from SF_BRXXK (nolock) where patid=@patid and blh='0') and @iscreateblh=1
	begin 
		exec usp_yy_createblh "SF_BRXXK","blh",@errmsg output 
		select @newblh=substring(@errmsg,2,49)
		
		update SF_BRXXK set blh=@newblh,hzxm=hzxm where patid=@patid
		if @@error<>0
		begin
			select "F","更新病人信息出错！"
			rollback tran
			return
		end
		
		update SF_BRJSK set blh=@newblh,hzxm=hzxm where sjh=@sjh
		if @@error<>0
		begin
			select "F","更新病人结算信息出错！"
			rollback tran
			return
		end
	end
	if @qkbz1 in (1,3)
	begin
		update SF_BRXXK set zhje=zhje-@qkje2,gxrq=@now where patid=@patid --add by yfq @20120531
		if @@error<>0
		begin
			select "F","更新病人信息出错！"
			rollback tran
			return
		end
	
		select @zhje=zhje from SF_BRXXK where patid=@patid
		if @@error<>0
		begin
			select "F","更新账户金额出错！"
			rollback tran
			return
		end		
	end

	if @tcljbz=1
	begin
		update SF_BRXXK set ljje=isnull(ljje,0)+@tcljje1,gxrq=@now --add by yfq @20120531
			where patid=@patid
		if @@error<>0
		begin
			select "F","更新病人信息出错！"
			rollback tran
			return
		end
	end

	--代币卡病人处理 add by chenwei 2003.12.06
	if @cardbz = 1 
	begin
		if (@cardxh <> 0) or (@cardje <> 0)
		begin
      --优化流程同时又有代币卡支付的情况下，SF_BRJSK只记录充值卡支付信息，代币卡支付信息在SF_CARDZFJEK库中记录 
      if not((@qkje>0) and (@yjbz=1) and (@qkbz1=3))
      --如果本次结算金额小于代币卡支付金额时，将代币卡金额更新为本次结算金额，在多次结算时会发生
      --代币卡作为一种支付方式，应该是舍入之后的金额作为扣卡金额
      select @cardje = case when (round(yjye,1,1)-@cardje<0) and (round(yjye,1,1)>@sfje2) then @sfje2
                            when (round(yjye,1,1)-@cardje<0) and (round(yjye,1,1)<=@sfje2) then round(yjye,1,1) 
                            when (round(yjye,1,1)-@cardje>=0) and (@cardje>@sfje2) then @sfje2
                            when (round(yjye,1,1)-@cardje>=0) and (@cardje<=@sfje2) then @cardje
                       else 0  end
        from YY_CARDXXK nolock
			  where kxh=@cardxh and jlzt=0
			select @qkbz1 = '4', @qkje=@cardje
      /*
            ------------------------------------------------------
            declare @xjje_srq ut_money, --舍入前
                    @xjje_srh ut_money  --舍入后
			select @xjje_srq = zfje-@qkje-isnull(@zpje,0)-isnull(@ylkje,0)-isnull(@gbje,0)-isnull(@bdyhkje,0)
	          from SF_BRJSK nolock
              where sjh=@sjh     
			select @srbz=config from YY_CONFIG (nolock) where id='2016'

			if @srbz='5'
				select @xjje_srh=round(@xjje_srq, 1)
			else if @srbz='6'
				exec usp_yy_wslr @xjje_srq,1,@xjje_srh output 
			else if @srbz>='1' and @srbz<='9'
				exec usp_yy_wslr @xjje_srq,1,@xjje_srh output,@srbz
			else
				select @xjje_srh=@xjje_srq

			select @srje=@xjje_srh-@xjje_srq
      */
            ------------------------------------------------------
			update YY_CARDXXK set zjrq=(case when @jsrq='' then @now else @jsrq end),
                  yjye=case when yjye-@cardje<=0 then 0 else yjye-@cardje end,
								  @sjyjye=case when yjye-@cardje<=0 then 0 else yjye-@cardje end,
          @sjdjje = @cardje
			where kxh=@cardxh and jlzt=0
			if @@error<>0
			begin
				select "F","更新代币卡病人帐户余额出错！"
				rollback tran
				return
			end		

			select @kdm=a.kdm,@kmc=b.kmc,@zhje=yjye,@cardno=cardno 
			  from YY_CARDXXK a(nolock),YY_CARDFLK b(nolock) 
			  where a.kxh=@cardxh and a.kdm=b.kdm
			
			insert into YY_CARDJEK(kxh,jssjh,yjjxh,kdm,czyh,czym,lrrq,zje,zhye,yhje,yhje_zje,yhje_mx,jlzt,xtbz,memo)
			values(@cardxh,@sjh,0,@kdm,@czyh,'',(case when @jsrq='' then @now else @jsrq end),@cardje,@zhje,@yhje,0,0,0,0,'')
			if @@error<>0
			begin
				rollback tran
				select "F","更新代币卡金额库出错！"
				return
			end

            insert into SF_CARDZFJEK(jssjh,lx,mc,je,memo)
            values(@sjh,'4','代币卡支付',@cardje,'')
            if @@error<>0
			begin
				select 'F','插入YY_JZBRYJK记录时出错'
				rollback tran
				return
			end
		end
	end
    /*-----自费转医保缴费时,处理原记录,红冲记录的状态 begin-----*/
	if @hcsjh<>''
	begin
		declare @ysjh ut_sjh,@ypatid ut_xh12,@yjzxh ut_xh12,@yqkje ut_money
		if exists(select 1 from SF_BRJSK(NOLOCK) where sjh = @hcsjh) OR	--@hcsjh有时候传入的是‘0’，那么向押金明细库中插入数据就会报错，增加校验
			exists(select 1 from SF_NBRJSK(NOLOCK) where sjh = @hcsjh)
		BEGIN
			select @ysjh = tsjh,@ypatid=patid,@yqkje=(case when qkbz=3 then -qkje else 0 end) from SF_BRJSK (nolock) where sjh=@hcsjh
			update SF_BRJSK set ybjszt=2 where sjh=@hcsjh
			update SF_BRJSK set jlzt=1 where sjh=@ysjh
			if @@rowcount=0
			update SF_NBRJSK set jlzt=1 where sjh=@ysjh
			update SF_MZCFK set jlzt=1 where jssjh=@ysjh
			if @@rowcount=0
			update SF_NMZCFK set jlzt=1 where jssjh=@ysjh
			update SF_BRJSK set tsjh=@hcsjh where sjh=@sjh

			if @yqkje<>0
			begin
				select @yjzxh=xh from YY_JZBRK (nolock) where patid=@ypatid and jlzt=0 and gsbz=0   
				select @sjyjye=yjye from YY_JZBRK (nolock) where xh=@yjzxh
				insert into YY_JZBRYJK(fpjxh,fph,jzxh,czyh,czym,lrrq,jje,dje,yje,zffs,czlb,hcxh,jlzt,memo,sjh,ybdm,dbkje)
				select 0,0,@yjzxh,@czyh,@czym,@now,0,@yqkje,@sjyjye+@yqkje,1,4,null,0,'自费转医保红冲',@hcsjh,@ybdm,0
				update YY_JZBRK set yjye=@sjyjye+@yqkje where xh=@yjzxh
				update SF_BRXXK set zhje=@sjyjye+@yqkje where patid=@ypatid
			end
		END
	end
  /*-----自费转医保缴费时,处理原记录,红冲记录的状态 end-----*/

	--药房流水号处理
	if (select config from YY_CONFIG (nolock) where id='2132')='是'
	begin
		IF (select config from YY_CONFIG (nolock) where id='0081')='2' 
		BEGIN
			DECLARE cs_cfk_fyckxh CURSOR FOR SELECT DISTINCT fyckdm FROM SF_MZCFK(NOLOCK) WHERE jssjh=@sjh and cflx in (1,2,3)	-- add by gzy at 20050518
	        OPEN cs_cfk_fyckxh
	        FETCH cs_cfk_fyckxh INTO @fyckdm1
			WHILE @@fetch_status=0 
	        BEGIN        
	            if not exists(select 1 from SF_YFLSHK nolock where rq = @now8 and fyckdm = @fyckdm1)




                begin
                   insert into SF_YFLSHK(rq,xh,yfdm,fyckdm)
                   select @now8,1,@fyckdm1,@fyckdm1
                   select @yflsh =1

                end
                else 
				begin
                   update SF_YFLSHK set xh =xh +1,@yflsh = isnull(xh,0)+1 where rq = @now8 and fyckdm = @fyckdm1
                end
                select @yflsh  = isnull(@yflsh,1)
                UPDATE SF_MZCFK SET yflsh=@yflsh,fyckxh=@fyckxh+1 WHERE jssjh = @sjh AND fyckdm = @fyckdm1  -- modify by wfy 2007-03-16
                IF @@ERROR<>0 OR @@ROWCOUNT = 0
                BEGIN
                    select @errmsg='F更新流水号错误'
					rollback tran
					DEALLOCATE cs_cfk_fyckxh
                    return      
                END

                FETCH cs_cfk_fyckxh INTO @fyckdm1
            END
            CLOSE cs_cfk_fyckxh
            DEALLOCATE cs_cfk_fyckxh
        END
		ELSE IF (select config from YY_CONFIG (nolock) where id='0081')='3' 
		begin
			if exists(select 1 from SF_MZCFK where jssjh=@sjh and cflx in (1,2,3))
			begin
                --select @yfdm=yfdm from SF_MZCFK 
				--select @yflsh=isnull(xh,0) from SF_YFLSHK(nolock) where rq =substring(@now,1,8)
				select @yflsh = xh from SF_YFLSHK(nolock) where rq =substring(@now,1,8) and yfdm=''
				if @@error<>0    
				begin    
					rollback tran
					select "F","取最大药房流水号出错！"    
				    return    
				end    	

				select @yflsh = isnull(@yflsh,0)+1 -- add by wfy 2007-03-15

				if @yflsh<=1
					insert SF_YFLSHK(rq,xh,yfdm)
					values(substring(@now,1,8),@yflsh,'')  
				else
					update SF_YFLSHK set xh=xh+1 where rq =substring(@now,1,8) and yfdm=''
				if @@error<>0    
				begin    
					select "F","更新最大据号出错！"  
					rollback tran  
				    return    
				end    
				UPDATE SF_MZCFK SET yflsh=@yflsh WHERE jssjh = @sjh  -- modify by wfy 2007-03-16
				IF @@ERROR<>0 OR @@ROWCOUNT = 0
				BEGIN
					SELECT "F","更新药房流水号出错！"
					ROLLBACK TRAN

					RETURN
				END		


			end
		end
		else if (select config from YY_CONFIG (nolock) where id='0081')='1' 
		BEGIN
			DECLARE cs_cfk_yfdm CURSOR FOR SELECT DISTINCT yfdm FROM SF_MZCFK(NOLOCK) WHERE jssjh=@sjh	and cflx in (1,2,3)
	        OPEN cs_cfk_yfdm
	        FETCH cs_cfk_yfdm INTO @yfdm
			WHILE @@fetch_status=0 
	        BEGIN				

				select @yflsh = xh from SF_YFLSHK(nolock) where rq =substring(@now,1,8) and yfdm=@yfdm
				if @@error<>0    
				begin  

					select "F","取最大药房流水号出错！"   
					rollback tran
					DEALLOCATE cs_cfk_yfdm			   
				    return    
				end    	

				select @yflsh = isnull(@yflsh,0)+1 -- add by wfy 2007-03-15

				if @yflsh<=1
					insert SF_YFLSHK(rq,xh,yfdm)
					values(substring(@now,1,8),@yflsh,@yfdm)  
				else
					update SF_YFLSHK set xh=@yflsh where rq =substring(@now,1,8) and yfdm=@yfdm
				if @@error<>0    
				begin    
					select "F","更新最大据号出错！" 
					rollback tran
					DEALLOCATE cs_cfk_yfdm   
				    return    
				end 
				UPDATE SF_MZCFK SET yflsh=@yflsh WHERE jssjh = @sjh and yfdm=@yfdm  -- modify by wfy 2007-03-16
				IF @@ERROR<>0 OR @@ROWCOUNT = 0
				BEGIN
					SELECT "F","更新药房流水号出错！"
					ROLLBACK TRAN
					DEALLOCATE cs_cfk_yfdm
					RETURN
				END
				FETCH cs_cfk_yfdm INTO @yfdm
			END
			CLOSE cs_cfk_yfdm
			DEALLOCATE cs_cfk_yfdm
		END
	end
	--分发票多次结算时,支票金额进行分摊
	if @jslb=1
	begin
		--add by xxl 约定如果使用支票支付，那只能全部使用支票，不支持部分支票部分现金（两者分摊时非常复杂，未实现），由前台提示
		if isnull(@zpje,0)>0
			select @zpje=(case when @qkbz1 = 4 then zfje-@qkje-isnull(@ylkje,0)-isnull(@gbje,0)-isnull(@bdyhkje,0)
                                  else zfje-@qkje-isnull(@ylkje,0)-isnull(@gbje,0)-isnull(@bdyhkje,0)-@cardje end)
			from SF_BRJSK where sjh=@sjh		
	end
	update SF_BRJSK set sfrq=(case when @jsrq='' then @now else @jsrq end),
		ybjszt=2,
		zxlsh=(case isnull(@zxlsh,'') when '' then zxlsh else @zxlsh end),
		fph=@fph,
		fpjxh=@fpjxh,
		zpje=isnull(@zpje,0),
		zph=@zph,
		pzh=(case when @qkbz1 = 4 then @cardno else pzh end),
		xjje =zfje-@qkje-isnull(@zpje,0)-isnull(@ylkje,0)-isnull(@gbje,0)-isnull(@bdyhkje,0),

		qkbz=@qkbz1,
		qkje=@qkje,
		--dnzhye=(case when @qkbz1=1 then @zhje when @qkbz1=4 then @sjyjye else dnzhye end),
		--mod by ozb 20080403 医保病人的当年帐户余额不能是冲值卡或代币卡的余额
		dnzhye=(case when @qkbz1=1 and @pzlx not in ('10','11') then @zhje when @qkbz1=4 and @pzlx not in ('10','11') then @sjyjye else dnzhye end),
		qrrq=(case when @qrbz=0 then @now else null end),
		qrczyh=(case when @qrbz=0 then @czyh else null end)
		,ylkje=@ylkje
		,ylkysje=@ylkhcysje
		,ylksqxh=@ylksqxh
		,ylkzxlsh=@ylkzxlsh
		,ylcardno=@ylcardno	--mit ,, 2003-05-07 ,, 银联卡增加字段
		,yflsh=@yflsh
		,spzlx = @spzlx
		,bdyhklsh = @bdyhklsh
		,bdyhkje = @bdyhkje
		,zlje=@zlje		--add by ozb 20060622
		,lrrq=@now
		,gxrq=@now
		,fpdybz=1
	where sjh=@sjh	

	if @@error<>0 or @@rowcount=0
	begin
		select "F","更新收费结算信息出错！"
		rollback tran
		return
	end
		IF @zph='Y'
    BEGIN
		UPDATE YY_ADZFPT_JYMX set jsbz=2  where jsbz=0 and sjh=@sjh
    
		if @@error<>0 or @@rowcount=0
		begin
			select "F","更新亚德交易信息出错！"
			rollback tran
			return
		end
    END
	
	if (@qkbz1=3)and(@config2391=1)
	begin
		--cjt 医生站出现现金金额
		select @zsxjje= xjje,@zsyjye=qkje from SF_BRJSK where sjh=@sjh and qkbz=3
		if (@ysyjye<>@zsyjye)
		begin
			rollback tran
			select "F","结算失败！预算与结算金额不一致！请重新结算！"
			return
		end 
		if (@sjyjye<0)
		begin
			rollback tran
			select "F","结算失败！本次结算押金余额小于0！请重新结算！"
			return
		end 
	end


	-- by will 20110919
	IF @configdyms = 0
	begin
		if @print=0
		begin
			update SF_BRJSK set fpdybz=0,fpdyczyh=@czyh,fpdyrq = @now where sjh = @sjh
			if @@error<>0 or @@rowcount=0
			begin
				select "F","更新收费发票信息有误！"
				rollback tran
				return
			end
		end
	end
	if exists (select 1 from sysobjects where name='SF_BRJSK_FZ' and xtype='U')
	BEGIN		
		update  SF_BRJSK_FZ set fph=@fph,fpjxh=@fpjxh,fpdm=@fpdm where sjh=@sjh		 
		if @@error<>0
		begin
			select "F","保存结算账单出错！"
			rollback tran
			return		
		end	
	END	
	if @isQfbz=1 
	begin
		update SF_BRJSK set qrbz=1 where sjh=@sjh
		if @@error<>0 or @@rowcount=0
		begin
			select "F","更新收费结算信息出错！"
			rollback tran
			return
		end
	end

	--add by will for bug 103404
	declare @config2238 varchar(20)  
	select @config2238 =config from YY_CONFIG where id ='2238'
    if exists(select 1 from SF_BRJSK where sjh=@sjh and zfje=0 and @config2238='否')
		set @isQfbz=1


	--mit ,, 2003-05-07 ,, 如果有预授则插入YY_YLJYJLK
	if (@ylkhcysje<>0) and (@ylkhcyssqxh<>'') 
	begin
		declare @hcxh ut_xh12
		select @hcxh = xh 
		from YY_YLJYJLK 
		where patid=@patid and jlzt in(0,1)

		update YY_YLJYJLK
		set jlzt=2
		where xh=@hcxh
		if @@error<>0
		begin
			select "F","更新银联卡预授信息出错！"
			rollback tran
			return
		end
		insert into YY_YLJYJLK(ylcardno,patid,ylkje,jyrq,ylksqxh,ylkzxlsh,jlzt,qxxh,sjh)
		values(@ylcardno,@patid,@ylkhcysje,@jsrq,@ylkhcyssqxh,@ylkhcyszxlsh,3,@hcxh,@sjh)
		if @@error<>0
		begin
			rollback tran
			select "F","更新银联卡预授信息出错！"
			return
		end
	end
		
	/*更新发药窗口和配药窗口的未发药处方数, Wang Yi 2003.02.25*/	
/*
	--改为前台调用存储过程处理
	update YF_FYCKDMK set fpzs = fpzs + b.num
		from YF_FYCKDMK a, (select count(xh) num, yfdm, fyckdm 
				from SF_MZCFK (nolock) where jssjh = @sjh and cflx <> 4 group by yfdm, fyckdm) b
		where a.yfdm = b.yfdm and a.id = b.fyckdm
	if @@error<>0
	begin
		select "F","更新发药窗口信息出错！"
		rollback tran
		return
	end
    
	update YF_PYCKDMK set fpzs = fpzs + b.num
		from YF_PYCKDMK a, (select count(xh) num, yfdm, pyckdm 
				from SF_MZCFK (nolock) where jssjh = @sjh and cflx <> 4 group by yfdm, pyckdm) b
		where a.yfdm = b.yfdm and a.id = b.pyckdm
	if @@error<>0
	begin
		select "F","更新配药窗口信息出错！"
		rollback tran
		return
	end
*/	
    --虚库存处理add by tony
		declare @isdlsjfa ut_bz, --是否采用多零售价方案（0不采用，1采用）
			@ypxtslt int--零售价方案
			,@cfxh_temp int,@cfmxxh_temp int
			,@ypmc_temp ut_mc64
	select @isdlsjfa=0,@ypxtslt=0,@cfxh_temp= 0,@cfmxxh_temp =0,@ypmc_temp= ''
	if exists(select 1 from sysobjects where name='f_get_ypxtslt')	
	begin
		select @ypxtslt=dbo.f_get_ypxtslt()  
		if @ypxtslt=3 
		select @isdlsjfa=1
	end
	-- add by jch 20190412 吉林省中医院-门诊收费预结算冻结数量与解冻作业冲突
	if @isdlsjfa = 1 
	begin
		declare cs_mzsf_dpcjgcl cursor for
			select b.xh,a.xh ,b.ypmc from SF_MZCFK a(nolock),SF_CFMXK b(nolock) where a.jssjh=@sjh and a.xh=b.cfxh and a.cflx in(1,2,3) --and isnull(a.hjxh,0)=0 and isnull(b.hjmxxh,0) =0
			for read only
			open cs_mzsf_dpcjgcl
			fetch cs_mzsf_dpcjgcl into @cfmxxh_temp,@cfxh_temp,@ypmc_temp
			while @@fetch_status=0
			begin
				if not exists(select 1 from YF_YPDJJLK(nolock)  where mxtbname= 'SF_CFMXK' and zd_xh =@cfxh_temp and  mxxh = @cfmxxh_temp)
				begin
					select 'F','收费时获取冻结记录药品名称【'+@ypmc_temp+'】的信息失败，程序自动回滚，请重新收费！'
					rollback tran
					deallocate cs_mzsf_dpcjgcl
					return
				end
				fetch cs_mzsf_dpcjgcl into @cfmxxh_temp,@cfxh_temp,@ypmc_temp
			end
			close cs_mzsf_dpcjgcl
			deallocate cs_mzsf_dpcjgcl
	end
	else
	if @isdlsjfa=0
	begin
		declare @yfdm_djkc ut_ksdm,
		    @mxtbname_djkc ut_mc32,
		    @hjmxxh_djkc ut_xh12,
		    @cfmxxh_djkc ut_xh12,
		    @idm_djkc ut_xh9,
		    @czls_djkc ut_sl10,
			@yczls_djkc ut_sl10,  --原操作数量
		    @rtnmsg_djkc varchar(50)   

	    if exists (select 1 from YY_CONFIG (nolock) where id='2101' and config='是')
		begin
			/* 
			update YF_YFZKC set djsl=a.djsl+b.ypsl
				from YF_YFZKC a,(select yfdm,d.cd_idm,sum(d.ypsl*d.cfts) as ypsl from SF_CFMXK d(nolock),SF_MZCFK e(nolock) 
					where d.cfxh=e.xh and e.jssjh=@sjh and e.cflx in (1,2,3)  group by yfdm, cd_idm)  b
				where a.cd_idm=b.cd_idm and b.yfdm=a.ksdm
			if @@error<>0
			begin
				select "F","更新配药窗口信息出错！"
				rollback tran
				return
			end
			*/
			--初始化变量
			select @yfdm_djkc = '',@mxtbname_djkc = '',@hjmxxh_djkc = 0,@cfmxxh_djkc = 0,@idm_djkc = 0,@czls_djkc = 0,@yczls_djkc = 0, @rtnmsg_djkc = '';

		    declare cs_cfk_djkc cursor for select distinct a.yfdm,b.xh,b.cd_idm,b.ypsl*b.cfts
				from SF_MZCFK a(nolock) inner join SF_CFMXK b(nolock) on a.xh = b.cfxh
				where a.jssjh = @sjh and a.cflx in (1,2,3)    
	        open cs_cfk_djkc
	        fetch cs_cfk_djkc INTO @yfdm_djkc,@cfmxxh_djkc,@idm_djkc,@czls_djkc
			while @@fetch_status=0 
	        begin 
	            if @idm_djkc>0 
	            begin  
					exec usp_yf_jk_yy_freeze 1,@yfdm_djkc,'SF_CFMXK',@cfmxxh_djkc,@idm_djkc,@czls_djkc,0,@rtnmsg_djkc output
					if substring(@rtnmsg_djkc,1,1)='F'
					begin
						select 'F','冻结药品库存出错,'+substring(@rtnmsg_djkc,2,len(@rtnmsg_djkc)-1)
						rollback tran
						deallocate cs_cfk_djkc
						return
					end
	            end
	            fetch cs_cfk_djkc INTO @yfdm_djkc,@cfmxxh_djkc,@idm_djkc,@czls_djkc
	        end
			close cs_cfk_djkc
			deallocate cs_cfk_djkc	
		end

	    if exists (select 1 from YY_CONFIG (nolock) where id='2422' and config='是')
		begin
			--初始化变量
			select @yfdm_djkc = '',@mxtbname_djkc = '',@hjmxxh_djkc = 0,@cfmxxh_djkc = 0,@idm_djkc = 0,@czls_djkc = 0,@yczls_djkc = 0, @rtnmsg_djkc = '';

		    declare cs_cfk_djkc_new cursor for select distinct a.yfdm,isnull(b.hjmxxh,0),b.xh,b.cd_idm,b.ypsl*b.cfts,isnull(c.ypsl*c.cfts,b.ypsl*b.cfts) ypsl_old
				from SF_MZCFK a(nolock)
				join SF_CFMXK b(nolock) on a.xh=b.cfxh
				left join SF_HJCFMXK c(nolock) on c.cfxh=a.hjxh
				where a.jssjh=@sjh and a.cflx in (1,2,3)    
	        open cs_cfk_djkc_new
	        fetch cs_cfk_djkc_new INTO @yfdm_djkc,@hjmxxh_djkc,@cfmxxh_djkc,@idm_djkc,@czls_djkc,@yczls_djkc 
			while @@fetch_status=0 
	        begin 
	            if @idm_djkc>0 
	            begin  
					if @hjmxxh_djkc=0
					begin 
						exec usp_yf_jk_yy_freeze 1,@yfdm_djkc,'SF_CFMXK',@cfmxxh_djkc,@idm_djkc,@czls_djkc,0,@rtnmsg_djkc output
						if substring(@rtnmsg_djkc,1,1)='F'
						begin
						    select 'F','冻结药品库存出错,'+substring(@rtnmsg_djkc,2,len(@rtnmsg_djkc)-1)
						    rollback tran
							deallocate cs_cfk_djkc_new
							return
						end
					end
					else
					begin 
					    --如果在冻结日志中存在则解冻，医生站有定时解冻，如果已经解冻过则不需要解冻
                        if exists(select 1 from YF_YPFREEZELOG a(nolock) where a.mxtbname='SF_HJCFMXK' and a.mxxh=@hjmxxh_djkc 
                             and a.yfdm=@yfdm_djkc and a.cd_idm=@idm_djkc and a.jlzt=0 )
                        begin       
							exec usp_yf_jk_yy_freeze 2,@yfdm_djkc,'SF_HJCFMXK',@hjmxxh_djkc,@idm_djkc,@yczls_djkc,0,@rtnmsg_djkc output
							if substring(@rtnmsg_djkc,1,1)='F'
							begin
								select 'F','解冻药品库存出错,'+substring(@rtnmsg_djkc,2,len(@rtnmsg_djkc)-1)
								rollback tran
								deallocate cs_cfk_djkc_new
								return
							end
						end 
						exec usp_yf_jk_yy_freeze 1,@yfdm_djkc,'SF_CFMXK',@cfmxxh_djkc,@idm_djkc,@czls_djkc,0,@rtnmsg_djkc output
					    if substring(@rtnmsg_djkc,1,1)='F'
						begin
						    select 'F','冻结药品库存出错,'+substring(@rtnmsg_djkc,2,len(@rtnmsg_djkc)-1)
						    rollback tran
							deallocate cs_cfk_djkc_new
							return
						end
					end
	            end
	            fetch cs_cfk_djkc_new INTO @yfdm_djkc,@hjmxxh_djkc,@cfmxxh_djkc,@idm_djkc,@czls_djkc,@yczls_djkc
	        end
			close cs_cfk_djkc_new
			deallocate cs_cfk_djkc_new	        
		end
	end
	
	select @tcljybdm = config from YY_CONFIG where id = '0115'
	if charindex('"'+rtrim(@ybdm)+'"',@tcljybdm) > 0
	begin
		declare @mzpatid ut_xh12,
				@m_cardno ut_cardno,
				@tcljje2 ut_money,
				@cardtype ut_dm2
		select @m_cardno = cardno,@cardtype = cardtype,
				@tcljje2=zje-(zfje-srje)-yhje-isnull(tsyhje,0)
				from SF_BRJSK nolock where sjh = @sjh
		select @mzpatid=mzpatid from YY_BRLJXXK nolock where cardno = @m_cardno and cardtype = @cardtype
		if @@rowcount <> 0
		begin
			exec usp_zy_tcljjegl @m_cardno,@mzpatid,@tcljje2,0,0,0,2,@czyh
			if @@error <> 0 
			begin
				rollback tran
				select "F","更新YY_BRLJXXK的统筹累计金额出错！"
				return
			end
		end
	end	
	
	--将更新划价库的动作移到事务最后执行，减少死锁发生的概率	
	update SF_HJCFK set jlzt=1 
		where xh in (select hjxh from #sfcfk) and patid=@patid
	if @@error<>0
	begin
		select "F","更新划价信息出错！"
		rollback tran
		return
	end
	
	update SF_HJCFK set jlzt=jlzt-5 
		where xh not in (select hjxh from #sfcfk) and jlzt in (5,8) and patid=@patid
			and ISNULL(alcfbz,0)=0--add h_ww 20150305 for 14182 只更新没有转入阿里的处方
	if @@error<>0
	begin
		select "F","更新划价信息出错！"
		rollback tran
		return
	end


	--二级库系统自动减库存 
	
    --二级库系统自动减库存 	 
	if ((select config from YY_CONFIG where id='A219')='是') 
	    and ((select config from YY_CONFIG where id='A234')='否')
	    and ((select config from YY_CONFIG where id='A262')='是')
	    and ((select config from YY_CONFIG where id='A206')='1')
	begin
		--begin tran
		declare @pcxh ut_xh12  --批次序号  
			 ,@tm ut_mc64   --条码 
			 ,@pcfxh	ut_xh12 
			 ,@pcfmxxh	ut_xh12 
			 ,@phjcfxh	ut_xh12 
			 ,@phjcfmxxh	ut_xh12 

		declare cs_ejkc cursor for 
		select a.xh, b.xh,b.hjmxxh,c.cfxh  from SF_MZCFK a (nolock),SF_CFMXK b (nolock) ,SF_HJCFMXK c (nolock) 
		where a.xh=b.cfxh and b.hjmxxh=c.xh and jssjh=@sjh and cflx not in (1,2,3)
		for read only

		open cs_ejkc
		fetch cs_ejkc into @pcfxh,@pcfmxxh ,@phjcfmxxh,@phjcfxh
		while @@fetch_status=0
		begin 
			---获取批次
			select @pcxh=0,@tm='0'
			select @pcxh=isnull(wzpcxh,'0'),@tm=isnull(txm,'0') from fun_yy_mz_cljlk(@phjcfxh,@phjcfmxxh,0) 
			---增减库存
			if isnull(@pcxh,0)<>0 or isnull( @tm,'0')<>'0'
			begin			
				exec usp_wz_hisxhpcl @pcfxh,0,@errmsg output,@pcxh=@pcxh,@tm=@tm,@mxxh=@pcfmxxh  
				if @errmsg like 'F%' or @@error<>0  
				begin    
			 		rollback tran
					select "F","二级库系统自动增减库存时出错！"+@errmsg
					deallocate cs_ejkc
					return
				END  

				---更新状态
				exec usp_yy_mz_updatecljlk @phjcfxh,@phjcfmxxh,@pcfmxxh,2,@errmsg output 
				if @errmsg like 'F%' or @@error<>0  
				begin    
			 		rollback tran
					select "F","二级库系统自动增减库存时出错--更新状态！"+@errmsg
					deallocate cs_ejkc
					return
				END   
			end

			fetch cs_ejkc into @pcfxh,@pcfmxxh,@phjcfmxxh,@phjcfxh
		end
		close cs_ejkc
		deallocate cs_ejkc
	--	commit tran
	end
	  
	commit tran

	
	
	--采用医生站配药流程（配药写入SF_PYQQK方式）
	begin tran
	if (select config from YY_CONFIG where id='0124')='是'
	begin
		declare cs_pyqq cursor for 
		select xh,hjxh from SF_MZCFK(nolock) where jssjh=@sjh and cflx in (1,2,3)
		for read only

		open cs_pyqq
		fetch cs_pyqq into @pycfxh,@pyhjxh
		while @@fetch_status=0
		begin
			if @pyhjxh=0 or not exists(select 1 from SF_PYQQK(nolock) where hjxh=@pyhjxh and @pyhjxh>0 and jlzt=0)
			begin
				insert into SF_PYQQK(jssjh,hjxh,cfxh,cfkxh,czyh,lrrq,patid,hzxm,ybdm,py,wb,ysdm,ksdm,yfdm,qrczyh,
				qrrq,qrksdm,pyczyh,pyrq,cfts,txh,sfckdm,pyckdm,fyckdm,jsbz,
				jlzt,fybz,cflx,sycfbz,tscfbz,pybz,jcxh,memo,zje,zfyje,yhje,zfje,srje,
				fph,fpjxh,tfbz,tfje,xzks_id ,spzfbl,spzfce,pyqr,sqdxh,yflsh,ejygksdm,
				ejygbz,ksfyzd_xh,fyckxh,dpxsbz,zpwzbh,zpbh)
				select jssjh,hjxh,cfxh,xh,czyh,lrrq,patid,hzxm,ybdm,py,wb,ysdm,ksdm,yfdm,qrczyh,
				qrrq,qrksdm,pyczyh,pyrq,cfts,txh,sfckdm,pyckdm,fyckdm,1,
				jlzt,fybz,cflx,sycfbz,tscfbz,pybz,jcxh,memo,isnull(zje,0),isnull(zfyje,0),isnull(yhje,0),isnull(zfje,0),isnull(srje,0),
				fph,fpjxh,tfbz,tfje,xzks_id ,0,0,pyqr,sqdxh,yflsh,ejygksdm,
				ejygbz,ksfyzd_xh,fyckxh,dpxsbz,zpwzbh,zpbh
				from SF_MZCFK(nolock)
				where xh=@pycfxh
				if @@error<>0
				begin
					rollback tran
					select "F","插入SF_PYQQK出错！"
					deallocate cs_pyqq
					return
				end

				select @xhtemp=@@identity

				insert into SF_PYMXK(cfxh,cd_idm,gg_idm,dxmdm,ypmc,ypdm,ypgg,ypdw,dwxs,ykxs,ypfj,ylsj,ypsl,
				ts,cfts,zfdj,yhdj,shbz,memo,flzfdj,txbl,lcxmdm,lcxmmc,zbz,yjqrbz,qrksdm,clbz,hjmxxh,
				hy_idm,hy_pdxh,gbfwje,gbfwwje,gbtsbz,btsbl,hzlybz,bgdh,bgzt,txzt,bglx,fpzh,lcxmsl,
				dydm,yyrq,yydd,zysx,yylsj,yjspbz)
				select @xhtemp,cd_idm,gg_idm,dxmdm,ypmc,ypdm,ypgg,ypdw,dwxs,ykxs,ypfj,ylsj,ypsl,
				ts,cfts,zfdj,yhdj,shbz,memo,flzfdj,txbl,lcxmdm,lcxmmc,zbz,yjqrbz,qrksdm,clbz,hjmxxh,
				hy_idm,hy_pdxh,gbfwje,gbfwwje,gbtsbz,gbtsbl,hzlybz,bgdh,bgzt,txzt,bglx,fpzh,lcxmsl,
				dydm,yyrq,yydd,zysx,yylsj,yjspbz
				from SF_CFMXK(nolock)
				where cfxh=@pycfxh
				if @@error<>0
				begin
					rollback tran
					select "F","插入SF_PYMXK出错！"
					deallocate cs_pyqq
					return
				end
			end

			if exists(select 1 from SF_PYQQK(nolock) where hjxh=@pyhjxh and @pyhjxh>0 and pybz=1 and jlzt=0)
			begin
				update SF_MZCFK set pybz=1,pyczyh=b.pyczyh,pyrq=b.pyrq
				FROM SF_MZCFK a(nolock),SF_PYQQK b(nolock)
				where a.xh=@pycfxh and a.hjxh=b.hjxh and b.jlzt=0
				if @@error<>0
				begin
					rollback tran
					select "F","更新SF_MZCFK的配药标志时出错！"
					deallocate cs_pyqq
					return
				end
			end

			if exists(select 1 from SF_PYQQK(nolock) where hjxh=@pyhjxh and @pyhjxh>0 and jlzt=0)
			begin
				update SF_PYQQK set jsbz=1,jssjh=@sjh
				where hjxh=@pyhjxh and jlzt=0 and patid=@patid
				if @@error<>0
				begin
					rollback tran
					select "F","更新SF_PYQQK的结算标志时出错！"
					deallocate cs_pyqq
					return
				end
			end

			fetch cs_pyqq into @pycfxh,@pyhjxh
		end
		close cs_pyqq
		deallocate cs_pyqq
	end
	commit tran

	select 	@ysybzfje = isnull(sum(je),0) from SF_JEMXK nolock where lx in ('20','22') and jssjh = @sjh
	select 	@gbje2 = isnull(sum(je),0) from SF_JEMXK nolock where lx in ('24') and jssjh = @sjh
	
	if @config1524='是'
	begin
	    exec usp_app_xxts '02',@patid,@sjh,'','','','','',@errmsg output
	end	
	/*
	if @errmsg like "F%"
	begin
		select "F",substring(@errmsg,2,49)
		return
	end
	*/	
	
	if @acfdfp=0  or @configdyms=1 --mod by ozb 20060704 add @configdyms=1
	begin
		if (select config from YY_CONFIG (nolock) where id='2036')='是'
		begin
			select "T", @zje, case when @gbbz = '0' then @zfyje-@flzfje else @gbje2 end, convert(varchar(20),@fph),   --0-3
				@print, @sfje2-@qkje-isnull(@gbje,0)-isnull(@bdyhkje,0), @qfdnzhzfje+@qflnzhzfje+@tclnzhzfje+@fjlnzhzfje,  --  4-6
				@tczfje, @dffjzfje, '', @qkbz1, @qkje2  --7-11
				,@sjyjye,@sjdjje, @kmc, @cardno, @tsyhje, @gbje,@ysybzfje, @lczje,@lcyhje,@zpje,@fpdm	-- 12 -,19,20,21,22
			union all
			select fpxmmc, sum(xmje), 0, '0', 0, sum(zfje), sum(zfyje), sum(yhje), 0, fpxmdm, 0,0,0,0,'','',0,0,0,0,0,0,''
				from SF_BRJSMXK where jssjh=@sjh 
				group by fpxmdm, fpxmmc
		end
		else begin
			select "T", @zje, case when @gbbz = '0' then @zfyje-@flzfje else @gbje2 end, convert(varchar(20),@fph), 
				@print, @sfje2-@qkje-isnull(@gbje,0)-isnull(@bdyhkje,0), @qfdnzhzfje+@qflnzhzfje+@tclnzhzfje+@fjlnzhzfje,
				@tczfje, @dffjzfje, '', @qkbz1, @qkje2
				,@sjyjye,@sjdjje, @kmc, @cardno,@tsyhje, @gbje,@ysybzfje, @lczje,@lcyhje,@zpje,@fpdm	-- 12 -,19,20,21,22
			union all
			select dxmmc, xmje, 0, '0', 0, zfje, zfyje, yhje, 0, dxmdm, 0,0,0,0,'','',0,0,0,0,0,0,@fpdm
				from SF_BRJSMXK where jssjh=@sjh
		end
    end
	else
	begin
        select  "T",sum(zje) as zje, sum(zfyje) as zfyje,convert(varchar(20),fph) as fph,@print, sum(zfje) as zfje, 
				@qfdnzhzfje+@qflnzhzfje+@tclnzhzfje+@fjlnzhzfje,
				@tczfje, @dffjzfje, '', @qkbz1, @qkje2,max(xh) as xh,max(cfxh) as cfxh 
				,@sjyjye,@sjdjje, @kmc, @cardno,@tsyhje, @gbje,@ysybzfje, @lczje,@lcyhje,@zpje	-- 14,21,22,23
		from SF_MZCFK  where jssjh=@sjh  
		group by fph		
		order by fph
	end
end
return








