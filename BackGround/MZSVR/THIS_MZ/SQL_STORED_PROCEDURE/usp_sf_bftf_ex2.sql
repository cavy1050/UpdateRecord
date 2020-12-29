Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE proc usp_sf_bftf_ex2
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
	,@bdyhkje ut_money = 0
	,@bdyhklsh ut_lsh = ''
	,@IsUseBdk ut_bz = 0
    ,@ysztfbz  ut_bz=0
	,@isQfbz   ut_bz=0
	,@sfywbzh ut_bz=0 -- 是否有外部账户 0 有 1 无 add by aorigele     
    ,@jfje  ut_money=0 --外部扣费金额 
	,@yftfdybz ut_bz=1 --add by yjn 2013-07-26 添加药房退费是否打印标志 0不打印 1打印
	,@zzfs_tf ut_bz=1--支付方式 add by gxs  0:退现金1：按原有方式处理 
	,@zffs	ut_bz=0
	,@sfksdm ut_ksdm=''	--收费科室代码
	,@isxjtf_paycenter ut_bz=0 --结算支付中心按现金退费
	,@ipdz_gxzsj VARCHAR(30)=''
as --集51631 2019-04-24 18:20:35 4.0标准版_201810补丁
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
	,@bdyhkje ut_money = 0   绑定银行卡支付金额
	,@bdyhklsh ut_lsh = ''   绑定银行卡流水号 
	,@IsUseBdk ut_bz = 0  是否使用绑定银行卡 0 不使用 1使用
    ,@ysztfbz  ut_bz=0 医生站退费标志，1 医生站调用
	,@zffs ut_bz=0				--支付方式0－退现金，1－原路返回
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]

@sjh     被退收据号
@newsjh1  红冲收据号
@newsjh  部分退费后的新收据号
[修改记录]
ozb 20060622 屏蔽掉走发票的内容 在打印发票前调用 usp_sf_zfp进行处理，因为收费后才分发票
ozb 20060705 增加兼容性，兼容以前的发票打印模式
yxp 2007-2-5 产生的自动调价记录,ykxs保存不正确，会导致金额翻倍
yxp 2007-2-8 产生自动调价记录时，游标没有使用distinct，会导致调价单记录翻倍
mly 2007-04-29 增加调用4。5统一接口 0门诊退药退费
yxp 2007-8-28 调用usp_yf_jk_tjdzdsc的bug修改，数量传得不对
xwm 2011-12-03 3117参数作废，只在药房退药处处理库存,
不管是劝退还是部分退药，只要有药品是发过药的记录都要调用usp_sf_bftf_fydcl，作用：生成新处方对应的发药数据，可能在次存储过程中处理药房库存

部分退费，重收记录应与红冲记录支付方式保持一致。不然帐是不平的。
**********/
set nocount on

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
		@sfje_all ut_money,	--实收金额(包含自费金额)
		@errmsg varchar(50),
		@srbz char(1),		--舍入标志
		@srje ut_money,		--舍入金额
		@sfje2 ut_money,	--舍入后的实收金额
		@xhtemp ut_xh12,
		@ksmc ut_mc32,		--科室名称
		@ysmc ut_mc64,		--医生姓名
		@xmzfbl float,		--药品自付比例
		@xmzfbl1 float,		--非药品自付比例
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
		@djbz int,		--冻结标志
		@qkbz1 smallint,	--欠款标志0：正常，1：记账，2：欠费
		@yjbz ut_bz,		--是否使用充值卡
		@yjye ut_money		--预交金余额
		,@acfdfp ut_bz		--按处方打印mit 2oo3-11-o7
		,@sjyjye ut_money	--实际押金余额
		,@sjdjje ut_money	--实际冻结金额		--mit , 2oo3-11-19
		,@flzfje ut_money,	--分类自负金额
		@tcljbz ut_bz,		--统筹累计标志
		@tcljje ut_money,	--统筹累计金额（镇保、新疆回沪使用） 
		@tcljje1 ut_money,	--统筹累计金额（镇保、新疆回沪使用） 
 		@qkje_hc ut_money,
		@qkje_new ut_money,
		@qkje_view ut_money
		,@gyfpbz ut_bz		--公用发票标志0:私用1:公用
		,@tsyhje ut_money  --特殊优惠金额
		,@gbje ut_money
		,@gbje1 ut_money
		,@ysybzfje  ut_money --原始医保自负金额,2005-11-14干保要求打印实际干保自负金额
		,@gbje2 ut_money    --2005-11-14干保要求打印自费金额2
		,@bdyhkje_old ut_money --原来的银联支付金额
		,@gbbz ut_bz --干保标志
		,@configdyms	ut_bz	--打印模式0 旧模式 1 新模式	--add by ozb 20060704
		,@tcljybdm varchar(500)  --统筹累计医保集合
		,@lczje ut_money		--零差药费总金额	
		,@lcyhje ut_money       --零差优惠金额
		,@config3117 ut_bz		--药房退药时是否处理库存[配合退费共同实现，不能随意修改] --add by sunyu 20080408 0:否，1:是
		,@bdyfplb varchar(255)	--zfje为0时不打印发票医保代码集合
		,@yflsh integer  --药房流水号 --add by xr 2010-09-17
		,@fyckdm1 ut_dm2 --发药窗口代码1 --add by xr 2010-09-17
		,@fyckxh  integer --发药窗口序号 --add by xr 2010-09-17
        ,@now8 ut_rq16		
		,@hzdybz ut_bz --确认标志 0无需确认 1未确认 2已确认
		,@fpdybz	ut_bz		--发票打印标志
		,@fpdyczyh	ut_czyh		--发票打印操作员
		,@fpdyrq	ut_rq16		--发票打印日期

declare @jzxh ut_xh12,
		@czym ut_mc64,
		@pycfxh	ut_xh12,	--SF_PYQQK对应的处方库xh
		@pyhjxh	ut_xh12,	--SF_PYQQK对应的处方库hjxh
		@pyfybz	ut_bz,		--处方库发药标志
		@qqkpybz	ut_bz,	--SF_PYQQK的配药标志
		@havejl	ut_bz,		--处方在SF_PYQQK中是否有记录
		@pyhcxh	ut_xh12,	--处方库红冲记录的xh
		@pyhcsjh	ut_sjh,	--处方库红冲记录的sjh
		@qqxh	ut_xh12,		--SF_PYQQK的xh
        @fpbz ut_bz ---0打印1不打印
        ,@dbkzf1  ut_money   --代币卡转存部分原支付金额
        ,@dbkzf   ut_money   --代币卡转存部分现支付金额
        ,@dbkye   ut_money   --代币卡转存部分余额
		,@yytbz ut_bz 
declare @yfdm ut_ksdm,
		@cd_idm			ut_xh9
		,@zpje_yyt		ut_money	--银医通zpje add by gxs
		,@zpje_zfzx		ut_money	--支付中心支付额(重收金额)
		,@zpje_zfzx1	ut_money	--支付中心支付额(红冲金额)
		,@config0220	ut_bz		--1按工号和科室代码领发票模式0传统模式
		,@configA234 ut_bz  -- ADD KCS 是否启用HRP系统
		,@fpdm varchar(16)
		,@yhyydm varchar(16)
		,@config2555 varchar(20) --门诊退费结算支付中心强制按照现金退费的支付方式集合
		,@oldzph	varchar(5)
		,@config2596	varchar(5)
select @now8 = convert(char(8),getdate(),112),@yflsh = 0
select @now=convert(char(8),getdate(),112)+convert(char(8),getdate(),8),
	@zje=0, @zfyje=0, @yhje=0, @ybje=0,
	@zje1=0, @zfyje1=0, @yhje1=0, @ybje1=0,
	@sfje=0, @sfje1=0, @sfje_all=0, @srje=0, @sfje2=0, 
	@xmzfbl=0, @xmzfbl1=0, @xmce=0, @print=0, @tfbz=0,
	@qkbz=0, @qkje=0, @qkje1=0, @zhje=0, @djbz=0, @qkbz1=0, @yjbz=0, @yjye=0
	,@sjyjye=0,@sjdjje=0, @flzfje=0, @tcljbz=0, @tcljje=0, @tcljje1=0
	,@qkje_hc=0, @qkje_new=0, @gyfpbz=0,@tsyhje = 0, @gbje=0, @gbje1=0,@ysybzfje = 0
	,@gbbz = '0',@lcyhje = 0,@lczje = 0,@fpbz =0,@yflsh=0,@hzdybz =0,@zpje_yyt = 0,
	@zpje_zfzx=0,@zpje_zfzx1=0,@yhyydm='0'
	
if (select config from YY_CONFIG (nolock) where id='0220')='是'      
	select @config0220=1      
else      
	select @config0220=0 
	
if (select config from YY_CONFIG (nolock) where id='2044')='否'
	set @acfdfp=0
else
	set @acfdfp=1
	
if (select config from YY_CONFIG (nolock) where id='A234')='是'      
	select @configA234=1      
else      
	select @configA234=0  
	
select @czym=name from czryk where id=@czyh

if (select config from YY_CONFIG (nolock) where id='2135')='是'
	select @gyfpbz = 1
else
	select @gyfpbz = 0 
select @config2555 =config  from YY_CONFIG (nolock) where id='2555' 
select @config2596=config from YY_CONFIG (nolock) where id='2596' 
--add by ozb 收费是否使用新的打印模式
if exists(select 1 from YY_CONFIG where id='2154' and config='是')
	select @configdyms=1 
else 
	select @configdyms=0

--add by sunyu 20080408
if exists(select 1 from YY_CONFIG where id='3117' and config='是')
	select @config3117=1
else
	select @config3117=0

if exists(select 1 from YY_CONFIG where id='0162' and config='1')    
  select @yytbz=1
else 
if exists (select 1 from YY_CONFIG where id='2258' and config='是')
  select @yytbz=1
 else
 select @yytbz=0


if @sfbz=2 --实时医保结算2或其它病人退费确定
begin
	if (select config from YY_CONFIG (nolock) where id='2101')='是'
		select @djbz=1

	select @newsjh1=sjh from SF_BRJSK where tsjh=@sjh and ybjszt=0 and jlzt=2 and czyh=@czyh
	if @@error<>0 or @@rowcount=0
	begin
		select "F","读取退费信息出错！"
		return
	end
	
	--获取正记录zph
	select @oldzph=zph from VW_MZBRJSK where sjh=@sjh and ybjszt=2
	 
    if @isxjtf_paycenter=1
    begin
        if @qtbz=1--全退
        begin
            --全退更新红冲记录
            --update SF_BRJSK set xjje=xjje+zpje,zpje=0,zph='S' where sjh=@newsjh1
			update SF_BRJSK set xjje=xjje+zpje,zpje=0,zph='' where sjh=@newsjh1    --支票金额0，支票号空
        end
        else
        begin
            --部分退 更新重收记录 --现金金额 后面会更新
            declare @zpje_old  ut_money                    
            --select @zpje_old=zpje from VW_MZBRJSK (nolock) where sjh=@sjh
			select @zpje_old=zfje-qkje from VW_MZBRJSK (nolock) where sjh=@newsjh
                        
			--结算支付中心退现金，部分退费重收的时候肯定按现金重收，zph不能更新为S。
            --update SF_BRJSK set zpje=@zpje_old,zph='S' where sjh=@newsjh
        end
    end	
    else if (@isxjtf_paycenter=0) and (@oldzph='S')
    begin
		declare @xjje_temp ut_money
		select @xjje_temp=isnull(sum(paymoney),0) from YY_PAYDETAILK (nolock) 
		where jssjh=@sjh and jlzt in (0,1) and zfzt=1 and charindex(rtrim(ltrim(paytype)),isnull(@config2555,''))>0 
		--add by mxd for bug :374071 参数2555在参数0339=0时有效
		and exists(select 1 from dbo.YY_CONFIG where id='0339' and substring(config,2,1)='0')
        if @qtbz=1--全退
        begin
            --全退更新红冲记录
            update SF_BRJSK set xjje=xjje-@xjje_temp,zpje=zpje+@xjje_temp,zph='S' where sjh=@newsjh1
        end
        else
        begin
			--部分退 更新重收记录 --现金金额 后面会更新
			update SF_BRJSK set xjje=xjje-@xjje_temp,zpje=zpje+@xjje_temp,zph='S' where sjh=@newsjh1
			select @zpje_old=zfje-qkje from SF_BRJSK (nolock) where sjh=@newsjh
		    
			
			----部分退 更新重收记录 --现金金额 后面会更新
			update SF_BRJSK set zpje=case when (@zpje_old-@xjje_temp>0) then @zpje_old-@xjje_temp else 0 end,zph='S' 
			where sjh=@newsjh
        end
    end	
	else if (@zffs = 1) and (@oldzph<>'')  --判断必须原方式退费，更新重收记录支票金额，现金金额后面更新；如果为退现金，则不能先更新支票，否则现金金额计算不对；
	begin
		if @qtbz=0 --参考存储过程usp_pay_autosetbftfzfinfo
		begin
			--先取到需要支付的费用
			declare @oldzpje ut_money,
					@newzpje ut_money,
					@newzfje ut_money
			select @oldzpje=case when zph<>'' then zpje else 0 end from VW_MZBRJSK(nolock) where sjh=@sjh
			select @newzfje=zfje-qkje from SF_BRJSK(nolock) where sjh=@newsjh

			--新的支付金额不能超过原来的支付，否则可能出现不够支付的情况
			--默认优先按现金退，重收部分优先使用非现金支付方式
			if @newzfje<=@oldzpje
				select @newzpje=@newzfje
			else
				select @newzpje=@oldzpje

			update SF_BRJSK set zph=@oldzph,zpje=@newzpje where sjh = @newsjh
		end
	end
	else if (@zffs=0) and (@oldzph<>'')
	begin
		--对于没有设置在2545内的参数，强制转换为原方式退回  20180627
		declare @config2545 varchar(200)
		select @config2545 = config from YY_CONFIG WHERE id='2545'
		if @qtbz=1 and CHARINDEX(','+@oldzph+',',@config2545)=0 and @oldzph <> '7'
		begin
			--全退更新红冲记录
            update SF_BRJSK set xjje=0,zpje=xjje+zpje,zph=@oldzph where sjh=@newsjh1   
		end
	end
	
	

	select @qkbz=qkbz, @qkje1=-qkje, @patid=patid, @ybdm=ybdm, @tcljje=zje-zfyje, @tcljbz=tcljbz 
		,@tsyhje = tsyhje, @gbje1=-gbje,@yhje1=yhje,
		--@zpje_zfzx1=case when zph  in ('S') then -isnull(zpje,0) else 0 end 
		---取消结算退现金，不红冲S
		@zpje_zfzx1=0
	from SF_BRJSK where sjh=@newsjh1
	if @@rowcount=0
	begin
		select "F","读取退费信息出错！"
		return
	end

	select @pzlx=pzlx from YY_YBFLK (nolock) where ybdm=@ybdm
	if @@rowcount=0 or @@error<>0
	begin
		select "F","患者费用类别不正确！"
		return
	end

	--mit ,, 2oo3-11-o7 ,,单独判断是否有充值卡

	select @jzxh=case when isnull(zcbz,0)=0 then xh else isnull(zkxh,xh) end ,
         @fpbz =isnull(fpbz,0)
		from YY_JZBRK where patid=@patid and jlzt=0
	if @@rowcount>0
	begin
		select @yjye=yjye-isnull(djje,0) from YY_JZBRK where xh=@jzxh and jlzt=0
		if @@rowcount=0
        begin
			select @yjye=0
            select @fpbz=0
        end
		else
			select @yjbz=1
	end
    if (select config from YY_CONFIG (nolock) where id='0133')='否' and @fpbz ='1'
		select @print=2

	if (select config from YY_CONFIG (nolock) where id='1022')='是'
		select @fplx=0
	else
		select @fplx=1

	if @qtbz=0
	begin
		select @ybdm=ybdm, @qkbz1=qkbz,@qkje=qkje, @zje=zje, @sfje2=zfje, @zfyje=zfyje, @flzfje=flzfje,
			@tcljje1=zje-zfyje, @gbje=gbje,@gbbz = gbbz,@lcyhje = lcyhje,@lczje = @zje - lcyhje,@yhje=yhje
			,@hzdybz =hzdybz,@zpje_zfzx=case when zph='S' then isnull(zpje,0) else 0 end
			from SF_BRJSK(nolock) where sjh=@newsjh
		if @@rowcount=0
		begin
			select "F","读取退费信息出错！"
			return
		end

		if @qkbz=2 and @qkje1>0
			select @print=1
		
		select @bdyfplb=config from YY_CONFIG where id='2161'
		if @sfje2=0
			if charindex(','+ltrim(rtrim(@ybdm))+',', ','+@bdyfplb+',')>0
				select @print=1

		if (select config from YY_CONFIG (nolock) where id='2238')='否'





		begin 
			if @sfje2 = 0 
				select @print=1 
		end
        --老发票模式中增加对参数2273受控
		if exists(select 1 from YY_CONFIG where id = '2273' and charindex(',' + LTrim(RTrim(@ybdm)) + ',',','+config+',')>0) 
			select @print=1
			
		--add wuwei for bug 104037 老发票模式下,qrbz=1的部分退费,会打印,应该不打印才对.
		if @hzdybz =1
		begin
			select @print =1

		end
		--add by will for bug 103404
		--add by sxm bug160918 1、参数2275，医保代码中账户标志为2的病人类型<允许欠费>是否打印发票
        -- 2275=是，欠费病人部分退费4不会打印发票，没有修改对应的usp_sf_bftf_ex2 
		
		if exists(select 1 from YY_CONFIG (NOLOCK)WHERE id='2275' and config='是') and 	@qkbz1=2 
		BEGIN
			select @print=0	
		END			
		
		declare @config2238 varchar(20)  
		select @config2238 =config from YY_CONFIG where id ='2238'
		if exists(select 1 from SF_BRJSK where sjh=@newsjh and zfje=0 and @config2238='否')
			set @isQfbz=1
			
		--add by yjn 2013-07-26 添加药房退费是否打印	
		if @yftfdybz=0
		begin
		    select @print=1
			if @qtbz =0
			begin	
				update SF_BRJSK set qrbz =case qrbz when 0 then 0 else 1 end where sjh =@newsjh
				if @@error <>0
				begin
					select "F","药房更新打印标志出错！"
					return
				end
			end			    
		end
		
		if @print=0 and @configdyms=0 and @isQfbz=0--add by ozb 兼容旧的打印模式and @configdyms=0
		begin
			--add by qxh 2003.5.27		
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


						return
					end
				end
				else
				begin
					select @fph=fpxz, @fpjxh=0,@fpdm=isnull(fpdm,'') from SF_GYFPK where czyh=@czyh and xtlb=@fplx
					if @@rowcount=0
					begin
						select "F","没有可用发票！"


						return
					end
				end
			end
			else
			begin
				--按处方打印发票时的走发票处理
				exec usp_sf_acfdfp_zfp @newsjh,1,@czyh,@errmsg output,@sfksdm
				if @errmsg like 'F%'
				begin
					select "F",substring(@errmsg,2,49)


					return
				end		
				select top 1 @fph=fph,@fpjxh=fpjxh from SF_MZCFK(nolock) where jssjh=@newsjh order by fph		















			end
		end		










	end
	else
		select @print=1

    if @ysztfbz=1
        select @print=3
	
	select xh, txh into #tfmzcf from SF_MZCFK where jssjh=@newsjh1
	if @@error<>0
	begin
		select "F","读取退费信息出错！"
		return
	end

	--是否解冻药房库存
	
	if @djbz=1 and exists(select 1 from SF_MZCFK where jssjh=@sjh and cflx in (1,2,3) and fybz=0)
	begin
		select a.yfdm, b.cd_idm,b.cfts*b.ypsl ypsl,b.xh,0 cssl,0 csxh
		into #djtemp from SF_MZCFK a, SF_CFMXK b
		where a.jssjh=@sjh and a.cflx in (1,2,3) and a.fybz=0 and a.xh=b.cfxh

		if @@error<>0
		begin
			select "F","解冻药房库存出错！"
			return
		end

		update #djtemp set cssl=b.ypsl,csxh=b.xh
		from #djtemp a, (select a.yfdm, b.cd_idm, (b.cfts*b.ypsl) ypsl,b.xh from SF_MZCFK a, SF_CFMXK b
			where a.jssjh=@newsjh and a.cflx in (1,2,3) and a.fybz=0 and a.xh=b.cfxh
			--group by a.yfdm, b.cd_idm
			) b
			where a.cd_idm=b.cd_idm and a.yfdm=b.yfdm
		if @@error<>0
		begin
			select "F","解冻药房库存出错！"
			return
		end

		select @djbz=2
	end

	begin tran
	-- add kcs by 11439 增减物资库存
	if (@configA234 = 1) and (exists (select 1 from SF_BRJSK a
					inner join SF_MZCFK b on a.sjh = b.jssjh
					inner join SF_CFMXK c on b.xh = c.cfxh
					inner join SF_HJCFMXK d on c.hjmxxh = d.xh
					where a.sjh = @newsjh1 and ISNULL(d.wzkfdm,'') <> '' and isnull(d.wzdm,'')<>''))   -- 分析要求通过SF_HJCFMXK.wzkfdm 是否有值判断是否扣费扣库存
	begin
	    declare 
		   @kc_ifid               ut_xh12,                --接口全局标识
		   @kc_ifid_t             ut_xh12,                --退序号
		   @kc_kfdm               varchar(12),            --手术室库房
		   @kc_wzdm               ut_xh12,                --物资代码
		   @kc_xmmc               ut_mc64,    --项目名称
		   @kc_pcxh               varchar(120),           --退时,必须不能为空
		   @kc_wzsl               ut_sl10,            --负数为退
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
		   @kc_ch                 ut_mc16,         --床号
		   @kc_patid              ut_syxh,
		   @kc_patname            ut_mc64,
		   @kc_zxczy              ut_czyh,
		   @kc_zxczyxm            ut_mc64,
		   @kc_lrczy              ut_czyh,         --录入操作员
		   @kc_lrczyxm            ut_mc64,         --录入操作员姓名
		   @kc_fymxh              ut_xh12,         --费用明细号
		   @kc_pHjmxh             ut_xh12,  --划价明细号
		   @kc_pTxmMaster         ut_mc64,         --主条形码
		   @kc_pTxmSlave          ut_mc64,         --从条形码
		   @kc_pNeedNewBill       ut_zt,            -- 补录入出库
		   @kc_memo               ut_memo,         -- 备注
		   @outpcxh            ut_mc64,
		   @outpcsl            ut_mc64,
		   @hrperrmsg             ut_mc64,
		   @config6845            VARCHAR(20),
		   @sql                   nVARCHAR(3000),
		   @ParmDefinition        nvarchar(500)
		    
		
		select @kc_wzsl = 1,@kc_pHjmxh = -1,@kc_pNeedNewBill = '0'
		select @config6845 = config from YY_CONFIG where id = '6845'
		
		-- 撤销红冲收据已扣的库存
		declare lscm_kc cursor for select c.xh from SF_BRJSK a
					inner join SF_MZCFK b on a.sjh = b.jssjh
					inner join SF_CFMXK c on b.xh = c.cfxh
					inner join SF_HJCFMXK d on c.hjmxxh = d.xh
					where a.sjh = @newsjh1 and ISNULL(d.wzkfdm,'') <> '' and isnull(d.wzdm,'')<>''
	    open lscm_kc
	    fetch lscm_kc into @kc_ifid
		while @@fetch_status=0 
	    begin        
	        select @kc_kfdm = b.wzkfdm,@kc_ifid_t=a.tmxxh,@kc_wzdm = b.wzdm,@kc_xmmc = a.ypmc,@kc_pcxh = b.wzpcxh,@kc_wzsl = a.ypsl,
	               @kc_ksdm = c.sfksdm,@kc_ksmc = d.name,@kc_fymxh = a.xh,@kc_pHjmxh = b.xh,@kc_pTxmMaster = b.tm,
	               @kc_pTxmSlave = b.ctxm,@kc_pKsdmBr = e.ksdm,@kc_pKsmcBr = f.name,@kc_pDrName = g.name,@kc_blh = h.blh,
	               @kc_patid = @patid,@kc_patname = h.hzxm,@kc_zxczy = e.qrczyh,@kc_zxczyxm = i.name  
	                 from SF_CFMXK a
	                 inner join SF_HJCFMXK b on a.hjmxxh = b.xh
	                 inner join SF_BRJSK c on c.sjh = @newsjh1
	                 inner join YY_KSBMK d on c.sfksdm = d.id
	                 left join SF_MZCFK e on a.cfxh = e.xh
	                 left join YY_KSBMK f on e.ksdm = f.id
	                 left join YY_ZGBMK g on e.ysdm = g.id
	                 left join SF_BRXXK h on e.patid = h.patid
	                 left join czryk i on e.qrczyh = i.id
					 where a.xh = @kc_ifid
					 
			select @sql = N'exec ' + @config6845 + 'dbo.USP_LSCM_IF4THIS_KC @ifid = ' + convert(varchar(12),isnull(@kc_ifid,0))
			            +', @ifid_t = ' + convert(varchar(12),isnull(@kc_ifid_t,0))
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
			            +'",@patid="'+convert(varchar(12),isnull(@kc_patid,0))
			            +'",@patname="'+convert(varchar(64),isnull(@kc_patname,''))
			            +'",@zxczy="'+convert(varchar(12),isnull(@kc_zxczy,''))
			            +'",@zxczyxm="'+convert(varchar(64),isnull(@kc_zxczyxm,''))
			            +'"'
			            
			select  @sql = @sql + N',@outpcxh = @outpcxh OUTPUT ,@outpcsl = @outpcsl output,@errmsg = @hrperrmsg output '
			set  @ParmDefinition = N' @outpcxh varchar(100) output,@outpcsl  varchar(100) output,  @hrperrmsg varchar(64) output '
			            
			exec sp_executesql @sql,@ParmDefinition,@outpcxh = @outpcxh OUTPUT,@outpcsl = @outpcsl OUTPUT ,@hrperrmsg=@hrperrmsg OUTPUT 		
            IF (@@ERROR<>0)or (@hrperrmsg like 'F%')
            begin
                select 'F','扣除物资库存失败！'
				rollback tran
				DEALLOCATE lscm_kc
                return      
            end
            
			select @sql = N'exec ' + @config6845 + 'dbo.USP_LSCM_IF4THIS_KC @ifid = ' + convert(varchar(12),isnull(@kc_ifid,0))
			            +', @ifid_t = ' + convert(varchar(12),isnull(@kc_ifid_t,0))
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
			            +'",@patid="'+convert(varchar(12),isnull(@kc_patid,0))
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
                select 'F','扣除物资库存失败！'
				rollback tran
				DEALLOCATE lscm_kc
                return      
            end            
            
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
        
        -- 按照新收据号再扣一次库存
        declare lscm_kc1 cursor for select c.xh from SF_BRJSK a
					inner join SF_MZCFK b on a.sjh = b.jssjh
					inner join SF_CFMXK c on b.xh = c.cfxh
					inner join SF_HJCFMXK d on c.hjmxxh = d.xh
					where a.sjh = @newsjh and ISNULL(d.wzkfdm,'') <> '' and isnull(d.wzdm,'')<>''
	    open lscm_kc1
	    fetch lscm_kc1 into @kc_ifid
		while @@fetch_status=0 
	    begin        
	        select @kc_kfdm = b.wzkfdm,@kc_ifid_t=a.tmxxh,@kc_wzdm = b.wzdm,@kc_xmmc = a.ypmc,@kc_pcxh = b.wzpcxh,@kc_wzsl = a.ypsl,
	               @kc_ksdm = c.sfksdm,@kc_ksmc = d.name,@kc_fymxh = a.xh,@kc_pHjmxh = b.xh,@kc_pTxmMaster = b.tm,
	               @kc_pTxmSlave = b.ctxm,@kc_pKsdmBr = e.ksdm,@kc_pKsmcBr = f.name,@kc_pDrName = g.name,@kc_blh = h.blh,
	               @kc_patid = @patid,@kc_patname = h.hzxm,@kc_zxczy = e.qrczyh,@kc_zxczyxm = i.name
	                 from SF_CFMXK a
	                 inner join SF_HJCFMXK b on a.hjmxxh = b.xh
	                 inner join SF_BRJSK c on c.sjh = @newsjh
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
			            +',@pTxmMaster="'+convert(varchar(12),isnull(@kc_pTxmMaster,''))
			            +'",@pTxmSlave="'+convert(varchar(12),isnull(@kc_pTxmSlave,''))
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
                select 'F','扣除物资库存失败！'
				rollback tran
				DEALLOCATE lscm_kc1
                return      
            end
            fetch lscm_kc1 into @kc_ifid
        end
        close lscm_kc1
        deallocate lscm_kc1
	end
	----------------------------处理申请退费记录
	declare @config2437 varchar(20)
	select @config2437 = config from YY_CONFIG where id = '2437'
	if @config2437='是'
	begin
	   if exists( select 1 from SF_TFSQK a(nolock),VW_MZCFK b(nolock) where a.cfxh = b.xh and a.jlzt = 1 and b.jssjh=@sjh)
	   begin
	       update a set a.jlzt=2,tfrq=@now from SF_TFSQK a(nolock),VW_MZCFK b(nolock) where a.cfxh = b.xh and a.jlzt = 1 and b.jssjh=@sjh
	       if @@ERROR <> 0 
	       begin 
	           rollback tran
			   select "F","更新退费申请状态错误！"
			   return
		   end
	   end	
	end	
	------------------------
	
-- add kcs 20151104 收费存在优惠记录信息的 作废处理 begin
	declare @yhjlxh ut_xh12,         -- YY_HZYHFSJLK_MZ.xh
	        @sjhjh varchar(100)      -- 收据号集合
	        
	if exists(select 1 from YY_HZYHFSJLK_MZ where CHARINDEX(rtrim(ltrim(@sjh)),sjhjh) > 0 and jlzt = '2')
    begin
        select @yhjlxh = xh,@sjhjh = sjhjh from YY_HZYHFSJLK_MZ where CHARINDEX(rtrim(ltrim(@sjh)),sjhjh) > 0 and jlzt = '2'
        
        -- 作废原优惠记录信息
	    update YY_HZYHFSJLK_MZ set jlzt = 3 where xh = @yhjlxh
	    if @@ERROR <> 0 
	    begin
	        rollback tran
		    select "F","作废优惠原因记录库出错！"
		    return
	    end
	    
        --	插入新优惠记录信息    
        -- 全退且存在多个收据号的优惠记录 直接去掉当前退费的sjh
        -- 全退单一收据号的优惠记录不用重写数据
        if (@qtbz = 1) and (2*LEN(rtrim(ltrim(@sjh))) < LEN(@sjhjh))
        begin
            insert into YY_HZYHFSJLK_MZ
            select cardno,patid,sfzh,REPLACE(@sjhjh,'"' + rtrim(ltrim(@sjh)) + '",',''),yhid,@now,@czyh,'2' from YY_HZYHFSJLK_MZ where xh = @yhjlxh    
        end
        -- 部分退费直接把sjhjh中的作废收据号换成重收记录收据号即可
        else if @qtbz = 0
        begin
            insert into YY_HZYHFSJLK_MZ
            select cardno,patid,sfzh,REPLACE(@sjhjh,rtrim(ltrim(@sjh)),rtrim(ltrim(@newsjh))),yhid,@now,@czyh,'2' from YY_HZYHFSJLK_MZ where xh = @yhjlxh
        end
	end
-- add kcs 20151104 收费存在优惠记录信息的 作废处理 end
	
	--红冲原纪录
	update SF_MZCFK set jlzt=1,gxrq=@now where jssjh=@sjh  --add by yfq @20120528
	if @@error<>0
	begin
		rollback tran
		select "F","作废门诊处方库出错！"
		return
	end

	update SF_NMZCFK set jlzt=1,gxrq=@now where jssjh=@sjh  --add by yfq @20120528
	if @@error<>0
	begin
		rollback tran
		select "F","作废门诊处方库出错！"
		return
	end


----诊疗方案收费成功后更新收费标志  SF_HJCFMXK.sjzlfabdxh<>0  ZLFA_SJBDK.SFBZ=1
	select hjxh	into #sfcfk from VW_MZCFK (nolock)where jssjh=@sjh
	if @@rowcount=0
	begin
		select "F","收费信息不存在！"
		rollback tran
		return		
	end
	---去除重收的,剩下部分是需要退的，也就是需要更新的
	--delete  from #sfcfk where hjxh in (select hjxh from VW_MZCFK (nolock)where jssjh=@newsjh)
	--update l_cj by bug337364
    delete  from #sfcfk where hjxh in (select hjxh from dbo.SF_MZCFK (nolock)where jssjh=@newsjh)
	
	UPDATE a set a.sfbz=0 ,a.tempbz=0 ,a.hjmxxh =null,a.yrzt=0 from ZLFA_SJBDK a, VW_MZHJCFMXK b
		where b.cfxh  in (select hjxh from #sfcfk ) and a.xh=b.sjzlfabdxh
	if @@error<>0
	begin
		select "F","更新三级绑定收费信息出错！"
		rollback tran
		return
	end 
----end



	-- 更新排药标志 若原处方已排则来一张负处方需要排药，若未排则都不用排
	update SF_MZCFK set czyh=@czyh,
		lrrq=(case when @jsrq_tf='' then @now else @jsrq_tf end),
		jlzt=2,
		jsbz=1,
		pybz = 1-pybz,
		gxrq=@now   --add by yfq @20120528
		where jssjh=@newsjh1
	if @@error<>0
	begin
		rollback tran
		select "F","红冲门诊处方库出错！"
		return
	end

    --更新SF_HJCFMXK_TYSQ中记录状态
	select b.hjmxxh,(b.ypsl-isnull(d.ypsl,0)) ypsl into #SF_HJCFMXK_TYSQ_TEMP 
	from VW_MZCFK a(nolock)
	join VW_MZCFMXK b(nolock) on a.xh = b.cfxh and a.jssjh = @sjh 
	left join VW_MZCFK c(nolock) on c.jssjh=@newsjh and a.xh=isnull(c.txh,0) and a.hjxh=isnull(c.hjxh,0)
	left join VW_MZCFMXK d(nolock) on c.xh = d.cfxh and b.hjmxxh=isnull(d.hjmxxh,0)
    where a.jssjh = @sjh and '0'=isnull(b.lcxmdm,'0') 
	if @@error<>0
	begin
		rollback tran
		select "F","统计退费数量信息出错！"
		return
	end
	insert into #SF_HJCFMXK_TYSQ_TEMP(hjmxxh,ypsl) 
	select b.hjmxxh,(b.lcxmsl-isnull(d.lcxmsl,0)) ypsl
	from VW_MZCFK a(nolock)
	join VW_MZCFMXK b(nolock) on a.xh = b.cfxh and a.jssjh = @sjh 
	left join VW_MZCFK c(nolock) on c.jssjh=@newsjh and a.xh=isnull(c.txh,0) and a.hjxh=isnull(c.hjxh,0)
	left join VW_MZCFMXK d(nolock) on c.xh = d.cfxh and b.hjmxxh=isnull(d.hjmxxh,0)
    where a.jssjh = @sjh and '0'<>isnull(b.lcxmdm,'0')
	group by  b.hjmxxh,b.lcxmsl,d.lcxmsl
	if @@error<>0
	begin
		rollback tran
		select "F","统计退费数量信息出错！"
		return
	end
    --update SF_HJCFMXK_TYSQ set jlzt = 2 from SF_HJCFMXK_TYSQ a(nolock),VW_MZCFK b(nolock),VW_MZCFMXK c(nolock) 
    --where b.jssjh = @sjh and b.xh = c.cfxh and a.hjcfmxxh = c.hjmxxh 
    update SF_HJCFMXK_TYSQ set jlzt = 2 from SF_HJCFMXK_TYSQ a(nolock),#SF_HJCFMXK_TYSQ_TEMP b
    where a.hjcfmxxh = b.hjmxxh and a.sqsl=b.ypsl and a.jlzt=0  -- add by zxm for bug 51681 加条件只改有效的数据，否则同数量已取消的数据也会被更新为2
	if @@error<>0
	begin
		rollback tran
		select "F","更新SF_HJCFMXK_TYSQ中记录状态出错！"
		return
	end
	--mit ,, 2oo3-o5-o8 ,, 银联卡退费处理,默认先退卡,再退现金

	declare @ylkje ut_money

	if exists(select 1 from SF_BRJSK where sjh=@sjh)
		update SF_BRJSK set jlzt=1, @sfje=zfje 
					,@ylkje=ylkje,@bdyhkje_old = bdyhkje
          ,gxrq=@now --add by yfq @20120528
		where sjh=@sjh
	else
		update SF_NBRJSK set jlzt=1, @sfje=zfje 
					,@ylkje=ylkje,@bdyhkje_old = bdyhkje
          ,gxrq=@now --add by yfq @20120528 
		where sjh=@sjh
	if @@error<>0
	begin
		rollback tran
		select "F","作废门诊结算库出错！"
		return
	end	
	--wxp ,, 2005-10-28  增加对绑定银行卡的处理
	if @IsUseBdk = 0 and @bdyhkje_old <> 0
	begin
		update SF_BRJSK set xjje = xjje+bdyhkje,bdyhkje = 0,gxrq=@now where sjh = @newsjh1
		select @bdyhkje_old = 0
	end	
	--wxp 更新绑定银行卡交易记录状态
	if @IsUseBdk = 1 
	begin 
		update YY_BDYHKJLK set jlzt = 1	where jssjh = @sjh and jlzt = 0
		if @@error<>0
		begin
			rollback tran
			select "F","更新绑定银行卡交易记录状态出错！"
			return
		end
	end

	if @qtbz = 1 
	begin
		declare @zffsdm ut_mc32,
				@zpje	ut_money

		if exists (select 1 from YY_CONFIG (nolock) where id='2111')
		   select @zffsdm=config from YY_CONFIG(nolock) where id='2111'
		else
		   select @zffsdm = ''

		--add by chenwei 2004-09-01 增加隔日全部退费时指定支付方式的退为现金(如支付方式为财务转帐之类)
		if @zffsdm <> '' 
		begin
			if exists( select 1 from VW_MZBRJSK (nolock) where sjh=@sjh and substring(sfrq,1,8) <> substring(@now,1,8))
			begin
				select @zpje = zpje from VW_MZBRJSK(nolock) 
				 where sjh=@sjh and charindex(ltrim(rtrim(zph)),@zffsdm)>0
				if @zpje <> 0
				begin
					update SF_BRJSK set xjje = xjje + zpje, zpje = zpje - zpje,gxrq=@now where sjh=@newsjh1
					if @@error<>0
					begin
						select "F","更新退费现金出错！"
						rollback tran
						return		
					end
				end
			end
		end
	end
    --门诊部分退费时应收的那部分费用是否作为POS的支付方式（原收费方式也是POS的支付方式） 
    declare @zffs_y varchar(2),@zpje_y ut_money,@zfje_y ut_money,@tzpfs ut_bz
    select @zffs_y='',@zpje_y=0,@zfje_y=0,@tzpfs=0
    select @zffs_y=zph,@zpje_y=isnull(zpje,0),@zfje_y=isnull(zfje,0),
		   @zpje_yyt=case when zph  in ('Y') then isnull(zpje,0) else 0 end
    from VW_MZBRJSK where sjh=@sjh
	
	--------add by gxs
	if @qtbz = 1 
	begin
		if ((@zffs_y='Y') and (@zpje_yyt>0) and (@zzfs_tf=0))
		begin
			update SF_BRJSK set zpje = 0, xjje=xjje+zpje,zph=''  where sjh=@newsjh1
			if @@error<>0
			begin
				select "F","更新收费结算信息出错1！"
				rollback tran
				return		
			end
			if ((@zffs_y='Y') and (@zpje_yyt>0) and (@zzfs_tf=0))
				select @zffs_y=''
			select @zpje_yyt=0
		end
	end
	else
	begin
		if (@zffs_y='Y') and (@zpje_yyt>0) and (@zzfs_tf=0)
		begin
			update SF_BRJSK set zpje = 0, xjje=xjje+zpje,zph=''  where sjh=@newsjh1
			if @@error<>0
			begin
				select "F","更新收费结算信息出错1！"
				rollback tran
				return		
			end
			if ((@zffs_y='Y') and (@zpje_yyt>0) and (@zzfs_tf=0))
				select @zffs_y=''
			select @zpje_yyt=0
		end
	end
	
	-----end add by gxs

 ---- begin add by yhw   
 declare @tje money
 select @tje=isnull(zpje,0) from VW_MZBRJSK where sjh=@sjh and zph in('7','12','13','14','15','S') 
 if ((@zffs_y in('7','12','13','14','15','S') and @tje>0) or @zffs_y in ('','1'))
 begin  
  update SF_BRJSK set xjje=xjje+zpje,zpje = 0,zph='' where sjh=@newsjh1            
  if @@error<>0            
  begin            
   select "F","更新收费结算信息出错2！"            
   rollback tran            
   return              
  end  
  select @tje=0   
 end  
 ----end      

    
--add by winning-dingsong-chongqing on 20191129-begin
--处理部分退费后收取部分，支付方式为现金（因为退为现金，所以部分退收也为现金）
declare @zpzje money
select @zpzje=isnull(zpje,0) from VW_MZBRJSK where sjh=@sjh and zph in('7','12','13','14','15','S') 
if ((@zffs_y in('7','12','13','14','15','S') and @zpzje>0))
begin
	if exists(select 1 from SF_BRJSK WHERE tsjh=@newsjh1)
	begin
		update SF_BRJSK set xjje=xjje+zpje,zpje = 0,zph='' where tsjh=@newsjh1--sjh=@newsjh --
		if @@error<>0            
		begin            
			select "F","更新收费结算信息出错3！"            
			rollback tran            
			return              
		end 
	end 
	select @zpzje=0 
end
--add by winning-dingsong-chongqing on 20191129-end

    if (@qtbz = 0) and (@zffs_y='7') and (@zpje_y>0)
       and (exists (select 1 from YY_CONFIG (nolock) where id='2197' and config='是'))
    begin
        if @zfje_y<>@zpje_y 
        begin           
			select "F","部分支票支付时不能部分退费，请使用全退！"
			rollback tran
			return
        end
        
		--if exists(select 1 from SF_BRJSK where sjh=@newsjh1 and xjje=zfje and zph='7' and zpje=0)
        if exists(select 1 from SF_BRJSK where tsjh=@newsjh1 and xjje=zfje and isnull(zph,'') in ('','1') and zpje=0)--winning-dingsong-chongqing-20191127
        select @tzpfs=0   --采用现金退的方式
        else
        select @tzpfs=1   --采用退pos方式
        /*if @tzpfs=1 
        begin
			del by aorigele 20100422
			update SF_BRJSK set xjje = 0, zpje = -zfje ,zph='7' where sjh=@newsjh1
			if @@error<>0
			begin
				select "F","更新退费现金出错！"
				rollback tran
				return		
			end
        end*/        
    end
    select @fpdybz=fpdybz,@fpdyrq=fpdyrq,@fpdyczyh=fpdyczyh from VW_MZBRJSK(nolock) where sjh = @sjh
    
	update SF_BRJSK set
		sfrq=(case when @jsrq_tf='' then @now else @jsrq_tf end),
		ybjszt=2,
		zxlsh=@zxlsh_tf
		,ylksqxh=@ylkhcsqxh
		,ylkzxlsh=@ylkhczxlsh	--mit ,, 2oo3-o5-o8 ,, 
		,qrrq=@now
		,bdyhklsh = @bdyhklsh
		,lrrq=@now
		,gxrq=@now --add by yfq @20120528
		,fpdybz=@fpdybz
		,fpdyrq=@fpdyrq
		,fpdyczyh=@fpdyczyh
		where sjh=@newsjh1
	if @@error<>0
	begin
		rollback tran
		select "F","红冲门诊结算库出错！"
		return
	end

	if exists(select 1 from SF_BRJSK where sjh=@sjh)
		insert into SF_JEMXK(jssjh, lx, mc, je, memo)
		select @newsjh1, lx, mc, -je, memo
			from SF_JEMXK where jssjh=@sjh
	else
		insert into SF_JEMXK(jssjh, lx, mc, je, memo)
		select @newsjh1, lx, mc, -je, memo
			from SF_NJEMXK where jssjh=@sjh
	if @@error<>0
	begin
		rollback tran
		select "F","红冲门诊结算金额库出错！"
		return
	end
    --红冲卡支付记录库
    if exists(select 1 from SF_BRJSK where sjh=@sjh)
		insert into SF_CARDZFJEK(jssjh, lx, mc, je, memo)
		select @newsjh1, lx, mc, -je, memo
			from SF_CARDZFJEK where jssjh=@sjh
	else
		insert into SF_NCARDZFJEK(jssjh, lx, mc, je, memo)
		select @newsjh1, lx, mc, -je, memo
			from SF_NCARDZFJEK where jssjh=@sjh
	if @@error<>0
	begin
		rollback tran
		select "F","红冲门诊结算卡支付金额库出错！"
		return
	end
	--add by zwj 2004.02.02	更新交易明细记录
	if @pzlx in ('10','11')
	begin
		update YY_YBJYMX set jssjh=@newsjh1
			where zxlsh=@zxlsh_tf
		if @@error<>0
		begin
			rollback tran
			select "F","更新医保交易明细信息出错！"
			return
		end
	end

	--是否解冻药房库存
	declare @isdlsjfa ut_bz, --是否采用多零售价方案（0不采用，1采用）
			@ypxtslt int--零售价方案
	select @isdlsjfa=0,@ypxtslt=0
	if exists(select 1 from sysobjects where name='f_get_ypxtslt')	
	begin
		select @ypxtslt=dbo.f_get_ypxtslt()  
		if @ypxtslt=3 
		select @isdlsjfa=1
	end


	if (@djbz=2) and (@isdlsjfa=0)
	begin
		if exists(select 1 from #djtemp where ypsl>0)
		begin
		/*
			update YF_YFZKC set djsl=a.djsl+b.ypsl
				from YF_YFZKC a, #djtemp b
				where a.cd_idm=b.cd_idm and a.ksdm=b.yfdm and b.ypsl<0
			if @@error<>0
			begin
				rollback tran
				select "F","解冻药房库存出错！"
				return
			end
		
		*/
			declare @yfdm_djkc_ex ut_ksdm,
			@mxtbname_djkc_ex ut_mc32,
			@hjmxxh_djkc_ex ut_xh12,
			@cfmxxh_djkc_ex ut_xh12,
			@idm_djkc_ex ut_xh9,
			@czls_djkc_ex ut_sl10,
			@yczls_djkc_ex ut_sl10,  --原操作数量
			@rtnmsg_djkc_ex varchar(50)   

			--初始化变量
			select @yfdm_djkc_ex = '',@mxtbname_djkc_ex = '',@hjmxxh_djkc_ex = 0,@cfmxxh_djkc_ex = 0,@idm_djkc_ex = 0,@czls_djkc_ex = 0,@yczls_djkc_ex = 0, @rtnmsg_djkc_ex = '';
			--取消冻结全部
			declare cs_cfk_djkc_ex cursor for select distinct a.yfdm,a.xh,a.cd_idm,a.ypsl
				from #djtemp a
			open cs_cfk_djkc_ex
			fetch cs_cfk_djkc_ex INTO @yfdm_djkc_ex,@cfmxxh_djkc_ex,@idm_djkc_ex,@czls_djkc_ex
			while @@fetch_status=0 
			begin 
				if @idm_djkc_ex>0 
				begin  
					exec usp_yf_jk_yy_freeze 2,@yfdm_djkc_ex,'SF_CFMXK',@cfmxxh_djkc_ex,@idm_djkc_ex,@czls_djkc_ex,0,@rtnmsg_djkc_ex output
					if substring(@rtnmsg_djkc_ex,1,1)='F'
					begin
						select 'F','取消冻结药品库存出错,'+substring(@rtnmsg_djkc_ex,2,len(@rtnmsg_djkc_ex)-1)
						rollback tran
						deallocate cs_cfk_djkc_ex
						return
					end
				end
				fetch cs_cfk_djkc_ex INTO @yfdm_djkc_ex,@cfmxxh_djkc_ex,@idm_djkc_ex,@czls_djkc_ex
			end
			close cs_cfk_djkc_ex
			deallocate cs_cfk_djkc_ex	
			--冻结重收部分
			declare cs_cfk_djkc_ex cursor for select distinct a.yfdm,a.csxh,a.cd_idm,a.cssl
				from #djtemp a
			open cs_cfk_djkc_ex
			fetch cs_cfk_djkc_ex INTO @yfdm_djkc_ex,@cfmxxh_djkc_ex,@idm_djkc_ex,@czls_djkc_ex
			while @@fetch_status=0 
			begin 
				if @idm_djkc_ex>0 and @czls_djkc_ex>0
				begin  
					exec usp_yf_jk_yy_freeze 1,@yfdm_djkc_ex,'SF_CFMXK',@cfmxxh_djkc_ex,@idm_djkc_ex,@czls_djkc_ex,0,@rtnmsg_djkc_ex output
					if substring(@rtnmsg_djkc_ex,1,1)='F'
					begin
						select 'F','冻结药品库存出错,'+substring(@rtnmsg_djkc_ex,2,len(@rtnmsg_djkc_ex)-1)
						rollback tran
						deallocate cs_cfk_djkc_ex
						return
					end
				end
				fetch cs_cfk_djkc_ex INTO @yfdm_djkc_ex,@cfmxxh_djkc_ex,@idm_djkc_ex,@czls_djkc_ex
			end
			close cs_cfk_djkc_ex
			deallocate cs_cfk_djkc_ex	

		end		
	end
	if exists (select 1 from YY_CONFIG(nolock) where id='2422' and config='是') and @isdlsjfa=0
	    and exists (select 1 from VW_MZCFK(nolock) where jssjh=@sjh and cflx in (1,2,3) and fybz=0)
	begin
	    declare @yfdm_djkc ut_ksdm,
	        @mxtbname_djkc ut_mc32,
	        @hjmxxh_djkc ut_xh12,
	        @cfmxxh_djkc ut_xh12,
	        @idm_djkc ut_xh9,
	        @czls_djkc ut_sl10,
	        @rtnmsg_djkc varchar(50)
	    declare cs_cfk_djkc cursor for select distinct a.yfdm,isnull(b.hjmxxh,0),b.xh,b.cd_idm,b.ypsl*b.cfts
			from VW_MZCFK a(nolock),VW_MZCFMXK b(nolock) 
			where a.jssjh=@sjh and a.cflx in (1,2,3) and a.xh=b.cfxh and a.fybz=0
        open cs_cfk_djkc
        fetch cs_cfk_djkc INTO @yfdm_djkc,@hjmxxh_djkc,@cfmxxh_djkc,@idm_djkc,@czls_djkc
		while @@fetch_status=0 
        begin
            if @idm_djkc>0 



	        begin
	            exec usp_yf_jk_yy_freeze 2,@yfdm_djkc,'SF_CFMXK',@cfmxxh_djkc,@idm_djkc,@czls_djkc,0,@rtnmsg_djkc output
				if substring(@rtnmsg_djkc,1,1)='F'
				begin
				    select 'F','解冻原处方药品库存出错,'+substring(@rtnmsg_djkc,2,len(@rtnmsg_djkc)-1)
				    rollback tran
					deallocate cs_cfk_djkc
					return
				end


	        end
            fetch cs_cfk_djkc INTO @yfdm_djkc,@hjmxxh_djkc,@cfmxxh_djkc,@idm_djkc,@czls_djkc  
        end
        close cs_cfk_djkc
		deallocate cs_cfk_djkc  
	    
	    declare cs_cfk_djkc cursor for select distinct a.yfdm,isnull(b.hjmxxh,0),b.xh,b.cd_idm,b.ypsl*b.cfts
			from SF_MZCFK a(nolock),SF_CFMXK b(nolock) 
			where a.jssjh=@newsjh and a.cflx in (1,2,3) and a.xh=b.cfxh and a.fybz=0
        open cs_cfk_djkc
        fetch cs_cfk_djkc INTO @yfdm_djkc,@hjmxxh_djkc,@cfmxxh_djkc,@idm_djkc,@czls_djkc
		while @@fetch_status=0 
        begin
            if @idm_djkc>0 
            begin
				exec usp_yf_jk_yy_freeze 1,@yfdm_djkc,'SF_CFMXK',@cfmxxh_djkc,@idm_djkc,@czls_djkc,0,@rtnmsg_djkc output
				if substring(@rtnmsg_djkc,1,1)='F'
				begin
					select 'F','冻结药品库存出错,'+substring(@rtnmsg_djkc,2,len(@rtnmsg_djkc)-1)
					rollback tran
					deallocate cs_cfk_yfdm
					return
				end
            end
            fetch cs_cfk_djkc INTO @yfdm_djkc,@hjmxxh_djkc,@cfmxxh_djkc,@idm_djkc,@czls_djkc
        end
		close cs_cfk_djkc
		deallocate cs_cfk_djkc
	end
----------cjt 先把钱充回来，这样才能重算
-------------cjt  重没有算时把退费的扣卡金额加进来，这样是不科学的
 if @yjbz=1 and ((@qkbz in(1,3)) or (@qkbz1 in (1,3)))    
 begin    
	--代币卡转存部分金额处理    
	select @dbkzf1=isnull(dbkje,0) from YY_JZBRYJK where sjh=@sjh and jlzt=0    
	select @dbkye=isnull(dbkye,0) from YY_JZBRK where xh=@jzxh and jlzt=0    

	select @dbkye=@dbkye+@dbkzf1    
	if @dbkye>=@qkje    
	select @dbkzf=@qkje    
	else    
	select @dbkzf=@dbkye    



    
  update YY_JZBRK set yjye=yjye+@qkje1     
   ,@sjyjye=yjye+@qkje1, @sjdjje=djje,dbkye=isnull(dbkye,0)+@dbkzf1-@dbkzf    
  where xh=@jzxh and jlzt=0    
  if @@error<>0    
  begin    
   select "F","更新记账病人库预交金余额出错！"    
   rollback tran    

   return    
  end    
  if @qtbz=0    
  begin    
	--部分退费时押金采用红冲方式    
	--1红冲    
   insert into YY_JZBRYJK(fpjxh,fph,jzxh,czyh,czym,lrrq,jje,dje,yje,zffs,czlb,hcxh,jlzt,memo,sjh,hcsjh,ybdm,dbkje)    
   values(0,0,@jzxh,@czyh,@czym,@now,0,@qkje1,@sjyjye,1,4,null,0,'',@newsjh1,@sjh, @ybdm,-@dbkzf1)    
            if @@error<>0    
   begin    
    select 'F','插入YY_JZBRYJK记录时出错'    
    rollback tran    
    return    
   end     
  end     
 end    
	--多批次方案时解冻库存
	if @isdlsjfa=1
	begin		
		--select b.xh,a.xh  from VW_MZCFK a,VW_MZCFMXK b where a.jssjh=@sjh and a.xh=b.cfxh and a.cflx in(1,2,3) and a.fybz=0
		--第一步、解冻结
		--药品多批次单价计算处理逻辑
		declare 
			@cfmxxh_temp ut_xh12,@cfxh_temp ut_xh12,
			@djpcxh ut_xh12,--冻结指定批次序号(默认为0，按3183参数规则，定批次）
			@rtnmsg	varchar(50), --返回信息
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
			@yjzfje_cs ut_money,  --重算后预交金支付余额
			@tmxxh	ut_xh12,		--退明细序号（原纪录）
			@djsl_cs	ut_sl10		--重收预算，重新冻结的数量
		if exists(select 1 from VW_MZCFK a,VW_MZCFMXK b where a.jssjh=@sjh and a.xh=b.cfxh and a.cflx in(1,2,3) and a.fybz=0)
		begin
			--先保存历史处方明细的批次记录信息，否则解冻后就被删除了
			--select a.* into #yf_ypdjjlk_old 
			--from YF_YPDJJLK a(NOLOCK)
			--	inner join VW_MZCFMXK b(nolock) on a.mxxh = b.xh
			--	inner join VW_MZCFK c(nolock) on b.cfxh = c.xh
			--where c.jssjh = @sjh and c.cflx in (1,2,3) and c.fybz = 0 and a.mxtbname in ('SF_CFMXK','SF_NCFMXK')
			--收费处做冻结，但药房未发药的，退费时需要做解冻结，如果药房已经发药，由药房进行解冻结
			declare cs_mzsf_dpcjgcl cursor for
			select b.xh,a.xh  from VW_MZCFK a,VW_MZCFMXK b where a.jssjh=@sjh and a.xh=b.cfxh and a.cflx in(1,2,3) and a.fybz=0
			for read only
			open cs_mzsf_dpcjgcl
			fetch cs_mzsf_dpcjgcl into @cfmxxh_temp,@cfxh_temp
			while @@fetch_status=0
			begin
				select @rtnmsg ='',@totalYplsje =0,@totalYpjjje =0,@avgYplsj =0,@avgYpjj =0,@yfpcxhlist ='',@yfpcsllist =''
				exec usp_yf_mzsf_ypdpcdj_inf 2,@cfmxxh_temp,0,0,@rtnmsg output,@totalYplsje output,@totalYpjjje output,@avgYplsj output,@avgYpjj output,@yfpcxhlist output,@yfpcsllist output
				if substring(@rtnmsg,1,1)<>'T'

				begin
					select 'F','药品多批次解冻结出错：'+@rtnmsg
					deallocate cs_mzsf_dpcjgcl
					rollback tran

					return
				end
				fetch cs_mzsf_dpcjgcl into @cfmxxh_temp,@cfxh_temp







			end
			close cs_mzsf_dpcjgcl
			deallocate cs_mzsf_dpcjgcl
		end
		--第二步、再冻结
		--药品多批次单价计算处理逻辑
		if exists(select 1 from SF_MZCFK a,SF_CFMXK b where a.jssjh=@newsjh and a.xh=b.cfxh and a.cflx in(1,2,3))
		begin
			if exists(select 1 from SF_MZCFK a,SF_CFMXK b where a.jssjh=@newsjh and a.xh=b.cfxh and a.cflx in(1,2,3) and a.fybz=0)
			begin
				declare cs_mzsf_dpcjgcl2 cursor for
				--select b.xh,a.xh,b.tmxxh  from SF_MZCFK a,SF_CFMXK b where a.jssjh=@newsjh and a.xh=b.cfxh and a.cflx in(1,2,3) and a.fybz=0
				select b.xh,a.xh,b.tmxxh,isnull(c.pcxh,0),c.djk_djsl from SF_MZCFK a(nolock)
					inner join SF_CFMXK b(nolock) on a.xh = b.cfxh
					inner join YF_YPCFPC_DYDJJLK c on b.xh = c.mxxh
				where a.jssjh=@newsjh and a.cflx in(1,2,3) and a.fybz=0
				for read only
				open cs_mzsf_dpcjgcl2
				fetch cs_mzsf_dpcjgcl2 into @cfmxxh_temp,@cfxh_temp,@tmxxh,@djpcxh,@djsl_cs
				while @@fetch_status=0
				begin
					select @rtnmsg ='',@totalYplsje =0,@totalYpjjje =0,@avgYplsj =0,@avgYpjj =0,@yfpcxhlist ='',@yfpcsllist =''									
					exec usp_yf_mzsf_ypdpcdj_inf 6,@cfmxxh_temp,@djpcxh,0,@rtnmsg output,@totalYplsje output,@totalYpjjje output,@avgYplsj output,@avgYpjj output,@yfpcxhlist output,@yfpcsllist output,@djsl_cs
					if substring(@rtnmsg,1,1)<>'T'
					begin
						select 'F','药品多批次单价计算出错：'+@rtnmsg
						rollback tran
						deallocate cs_mzsf_dpcjgcl2
						return
					end
					--update SF_CFMXK set zje=@totalYplsje,ylsj=@avgYplsj where xh=@cfmxxh_temp and cfxh=@cfxh_temp
					--if @@error<>0
					--begin
					--	select 'F','药品多批次单价计算出错：更新处方明细库零售价时出错'
					--	rollback tran
					--	deallocate cs_mzsf_dpcjgcl2
					--	return
					--end
					fetch cs_mzsf_dpcjgcl2 into @cfmxxh_temp,@cfxh_temp,@tmxxh,@djpcxh,@djsl_cs
				end
				close cs_mzsf_dpcjgcl2
				deallocate cs_mzsf_dpcjgcl2
				--插入处方明细三级表			
				insert into SF_CFMXK_DPC(cfmxxh,cfxh,pcxh,cd_idm,ypmc,ypdm,ylsj,ypsl,memo)
				select b.xh,b.cfxh,c.pcxh,b.cd_idm,b.ypmc,b.ypdm,c.yplsj,c.djk_djsl,'' from SF_MZCFK a,SF_CFMXK b,YF_YPDJJLK c 
				where a.jssjh=@newsjh and a.xh=b.cfxh and a.cflx in(1,2,3)
						and b.xh=c.mxxh and b.cfxh=c.zd_xh and c.mxtbname='SF_CFMXK' 
				if @@error<>0
				begin
					select 'F','插入处方明细三级表SF_CFMXK_DPC出错'
					rollback tran
					return
				end 
			end
			if exists (select 1 from SF_MZCFK a,SF_CFMXK b where a.jssjh=@newsjh1 and a.xh=b.cfxh and a.cflx in(1,2,3) and a.fybz=1)
			begin
			  --发药单处理
				exec usp_sf_bftf_fydcl @sjh,@newsjh1,@newsjh,@czyh,1,@errmsg output
				if substring(@errmsg,1,1)='F'
				begin
					rollback tran
					select 'F','执行发药单处理程序usp_sf_bftf_fydcl出错['+@errmsg+']'
					return
				end
			end
			if exists(select 1 from SF_MZCFK a,SF_CFMXK b where a.jssjh=@newsjh and a.xh=b.cfxh and a.cflx in(1,2,3) and a.fybz=1)
			begin
				--药房已经做退药的，直接去发药明细里面的ylsj
				update b set b.ylsj=c.ylsj,
							b.zje=c.lsje  --isnull(round(b.ypsl*c.ylsj*b.cfts/b.ykxs,2),0) 
				from SF_MZCFK a,SF_CFMXK b,YF_MZFYMX c
				where a.jssjh=@newsjh and a.xh=b.cfxh and a.cflx in(1,2,3) and a.fybz=1  
				and c.mxxh=b.xh and c.cfxh=a.xh
				if @@error<>0
				begin
					select 'F','药品多批次单价计算出错：更新处方明细库零售价时出错'
					rollback tran
					return
				end 
				--插入处方明细三级表
				insert into SF_CFMXK_DPC(cfmxxh,cfxh,pcxh,cd_idm,ypmc,ypdm,ylsj,ypsl,memo)
				select b.xh,b.cfxh,d.yfpcxh,b.cd_idm,b.ypmc,b.ypdm,d.yplsj,-d.czsl,'' 
				from SF_MZCFK a,SF_CFMXK b,YF_MZFYMX c,YF_MZMXPCXX d 
					where a.jssjh=@newsjh and a.xh=b.cfxh and a.cflx in(1,2,3)
					and b.xh=c.mxxh and b.cfxh=c.cfxh and b.xh=c.mxxh and c.xh=d.zdmxxh
					and d.czsl<>0 
			end
						
			--费用重算，价格变动
			--注意：上海医保不支持，重算太复杂，牵涉医保算法的维护，所以此处未处理
			--exec usp_sf_sfcl_jecs @newsjh,@rtnmsg output,@zje_cs output, @sfje_cs output,@ybje_cs output, @flzfje_cs output, @yjzfje_cs output
			--if substring(@rtnmsg,1,1)<>'T'
			--begin
			--	select 'F','费用重算出错：'+@rtnmsg
			--	rollback tran
			--	return
			--end
			--从算后对变量进行从新赋值，确保提示信息正确
			--select @ybdm=ybdm, @qkbz1=qkbz,@qkje=qkje, @zje=zje, @sfje2=zfje, @zfyje=zfyje, @flzfje=flzfje,
			--		@tcljje1=zje-zfyje, @gbje=gbje,@gbbz = gbbz,@lcyhje = lcyhje,@lczje = @zje - lcyhje,@yhje=yhje
			--		,@hzdybz =hzdybz
			--from SF_BRJSK where sjh=@newsjh
			--if @@rowcount=0
			--begin
			--	select "F","从算后读取退费信息出错！"
			--	rollback tran
			--	return
			--end
		end
	end
  --xwm 2011-12-03 3117参数作废，只在药房退药处处理库存
  --只在部分退费时生成新发药单（不入帐）
  --部分退费时，生成新发药单,也要补足红冲退药，都不入帐，以满足消耗量查询要求  xwm 2012-02-23
  if @isdlsjfa=0 and exists(select 1 from SF_MZCFK a,SF_CFMXK b where a.jssjh=@newsjh1 and a.xh=b.cfxh and a.cflx in(1,2,3) and a.fybz=1)
  begin   		   
    exec usp_sf_bftf_fydcl @sjh,@newsjh1,@newsjh,@czyh,1,@errmsg output
  if substring(@errmsg,1,1)='F'
    begin
      rollback tran
      select 'F','执行发药单处理程序usp_sf_bftf_fydcl出错['+@errmsg+']'
      return
    end
  end 
	--确认退药记录
	--update YF_MZFYZD set tfqrbz=1, jzbz=1, sfrq=@now, fyrq=@now where jssjh=@sjh and tfbz=1 and tfqrbz=0 and jlzt=0
	--如果3117设置为1 ，则药房已经处理jzbz
	if @config3117=0
	begin
		update YF_MZFYZD set tfqrbz=1, jzbz=case jzbz when 0 then 1 else jzbz end, sfrq=@now, fyrq=@now where jssjh=@sjh and tfbz=1 and tfqrbz=0 and jlzt=0
		if @@rowcount=0
		update YF_NMZFYZD set tfqrbz=1, jzbz=case jzbz when 0 then 1 else jzbz end, sfrq=@now, fyrq=@now where jssjh=@sjh and tfbz=1 and tfqrbz=0 and jlzt=0	
		if @@error<>0
		begin
			rollback tran
			select "F","确认退费记录出错！"
			return
		end
	end
	else
	begin
		update YF_MZFYZD set tfqrbz=1, jzbz=case jzbz when 0 then 1 else jzbz end, sfrq=@now  where jssjh=@sjh and tfbz=1 and tfqrbz=0 and jlzt=0
		if @@rowcount=0
		update YF_NMZFYZD set tfqrbz=1, jzbz=case jzbz when 0 then 1 else jzbz end, sfrq=@now where jssjh=@sjh and tfbz=1 and tfqrbz=0 and jlzt=0	
		if @@error<>0
		begin
			rollback tran
			select "F","确认退费记录出错！"
			return
		end
	end

	--恢复作废退药记录 zwj 2006.7.26
	--新退药方式是不删除原来的退药记录，而直接新增一条退药记录所以不能再更新jlzt
	/*
	update YF_MZFYZD set jlzt=0 where jssjh=@sjh and tfbz=1 and tfqrbz=0 and jlzt=1
	if @@rowcount=0
	update YF_NMZFYZD set jlzt=0 where jssjh=@sjh and tfbz=1 and tfqrbz=0 and jlzt=1
	if @@error<>0
	begin
		rollback tran
		select "F","恢复作废退药记录出错！"
		return
	end
	*/

	if @qkbz=1
	begin 
 		select @qkje_new = isnull(je,0) from SF_JEMXK where jssjh = @newsjh and lx in ( '01','yb01') 
 		select @qkje_hc = isnull(-je,0) from SF_JEMXK where jssjh = @newsjh1 and lx in ('01','yb01') 		
		update SF_BRXXK set zhje=zhje+ @qkje_hc- @qkje_new,gxrq=@now where patid = @patid --add by yfq @20120531
		if @@error<>0
		begin
			select "F","更新信息库账户金额出错！"
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
		update SF_BRXXK set ljje=isnull(ljje,0)+@tcljje+@tcljje1,gxrq=@now --add by yfq @20120531
			where patid=@patid
		if @@error<>0
		begin
			select "F","更新病人信息出错！"
			rollback tran
			return
		end
	end

	if @yjbz=1 and ((@qkbz in(1,3)) or (@qkbz1 in (1,3)))
	begin
        --代币卡转存部分金额处理
        select @dbkzf1=isnull(dbkje,0) from YY_JZBRYJK where sjh=@sjh and jlzt=0
        select @dbkye=isnull(dbkye,0) from YY_JZBRK where xh=@jzxh and jlzt=0

        select @dbkye=@dbkye+@dbkzf1
        if @dbkye>=@qkje
        select @dbkzf=@qkje
        else
        select @dbkzf=@dbkye

		update YY_JZBRK set yjye=yjye-@qkje 
			,@sjyjye=yjye-@qkje, @sjdjje=djje,dbkye=isnull(dbkye,0)-@dbkzf
		where xh=@jzxh and jlzt=0

		if @@error<>0
		begin
			select "F","更新记账病人库预交金余额出错！"
			rollback tran
			return
		end
		if @qtbz=0
        begin
            --部分退费时押金采用红冲方式
            --1红冲
	/* cjt 在上面先红冲
			insert into YY_JZBRYJK(fpjxh,fph,jzxh,czyh,czym,lrrq,jje,dje,yje,zffs,czlb,hcxh,jlzt,memo,sjh,hcsjh,ybdm,dbkje)
			values(0,0,@jzxh,@czyh,@czym,@now,0,@qkje1,@sjyjye,1,4,null,0,'',@newsjh1,@sjh, @ybdm,-@dbkzf1)
            if @@error<>0
			begin
				select 'F','插入YY_JZBRYJK记录时出错'
				rollback tran
				return
			end
			*/
            --2收费
            insert into YY_JZBRYJK(fpjxh,fph,jzxh,czyh,czym,lrrq,jje,dje,yje,zffs,czlb,hcxh,jlzt,memo,sjh,hcsjh,ybdm,dbkje)
			values(0,0,@jzxh,@czyh,@czym,@now,@qkje,0,@sjyjye,1,3,null,0,'',@newsjh,@sjh, @ybdm,@dbkzf)
			if @@error<>0
			begin
				select 'F','插入YY_JZBRYJK记录时出错'
				rollback tran
				return
			end
            insert into SF_CARDZFJEK(jssjh,lx,mc,je,memo)
            values(@newsjh,'3','充值卡支付',@qkje,'')
            if @@error<>0
			begin
				select 'F','插入YY_JZBRYJK记录时出错'
				rollback tran
				return
			end
        end
		else
        begin 
			insert into YY_JZBRYJK(fpjxh,fph,jzxh,czyh,czym,lrrq,jje,dje,yje,zffs,czlb,hcxh,jlzt,memo,sjh,hcsjh,ybdm)
			values(0,0,@jzxh,@czyh,@czym,@now,0,@qkje1-@qkje,@sjyjye,1,4,null,0,'',@newsjh1,@sjh, @ybdm)			
			if @@error<>0
			begin
				select 'F','插入YY_JZBRYJK记录时出错'
				rollback tran
				return
			end            
        end
	end

	if (@qkbz=4) or exists(select 1 from SF_CARDZFJEK where jssjh=@sjh and lx='4')
	begin
		declare @cardxh ut_xh12
               ,@dbkje ut_money 
		--select @cardxh= kxh,@qkje=@qkje1-@qkje from YY_CARDJEK where jssjh=@sjh
		select @cardxh= kxh from YY_CARDJEK where jssjh=@sjh

        if  exists(select 1 from SF_CARDZFJEK where jssjh=@sjh and lx='4')
		 select @dbkje=je from SF_CARDZFJEK where jssjh=@sjh and lx='4'
		else
            select @dbkje=@qkje1

		--add s_yh 代币卡支付不打印发票 for BUG 160901
		if (select config from YY_CONFIG where id ='2243' ) ='否'
		begin
			if (@cardxh <>0) and (@dbkje<>0)
				select @print=1
		end
		

		--先红冲
		update YY_CARDXXK set yjye=yjye+@dbkje,zjrq=(case when @jsrq='' then @now else @jsrq end)
		where kxh=@cardxh and jlzt=0
		if @@error<>0
		begin
			select "F","更新代币卡病人帐户余额出错！"
			rollback tran
			return
		end		

		select @zhje=yjye from YY_CARDXXK(nolock) where kxh=@cardxh
		
		insert into YY_CARDJEK(kxh,jssjh,yjjxh,kdm,czyh,czym,lrrq,zje,zhye,yhje,yhje_zje,yhje_mx,jlzt,xtbz,memo)
		   select kxh,@newsjh1,0,kdm,@czyh,'',(case when @jsrq='' then @now else @jsrq end),-@dbkje,@zhje,@yhje1,0,0,1,0,''
			from YY_CARDJEK where jssjh=@sjh
		if @@error<>0
		begin
			rollback tran
			select "F","更新代币卡金额库出错！"
			return
		end
		
		if @qtbz = 0	--部分退费 --add by gxf 2008-2-21
		begin
            --多种支付方式时无法部分退费，不考虑exists(select 1 from SF_CARDZFJEK where jssjh=@sjh and lx='4')
			insert into YY_CARDJEK(kxh,jssjh,yjjxh,kdm,czyh,czym,lrrq,zje,zhye,yhje,yhje_zje,yhje_mx,jlzt,xtbz,memo)
			select kxh,@newsjh,0,kdm,@czyh,'',(case when @jsrq='' then @now else @jsrq end),
				   @qkje,
				   @zhje - @qkje,@yhje,0,0,0,0,''
			from YY_CARDJEK where jssjh=@sjh
			if @@error<>0
			begin
				rollback tran
				select "F","更新代币卡金额库出错！"
				return
			end		

			update YY_CARDXXK set yjye = yjye - @qkje
			where kxh=@cardxh and jlzt=0
			if @@error<>0
			begin
				select "F","更新代币卡病人帐户余额出错！"
				rollback tran
				return
			end	
            insert into SF_CARDZFJEK(jssjh,lx,mc,je,memo)
            values(@newsjh,'4','代币卡支付',@qkje,'')
            if @@error<>0
			begin
				select 'F','插入YY_JZBRYJK记录时出错'
				rollback tran
				return
			end
		end
		
	end
	--add by l_jj 2012-07-13 需求119419 	
    if exists(select 1 from VW_MZBRJSK a,VW_MZCFK b where a.sjh=@sjh and b.jssjh=a.sjh and isnull(b.sqdxh,0)<>0)
    begin
		--更新日表
        update c set c.jlzt=1 from VW_MZBRJSK a,VW_MZCFK b,SF_MZSQD c
        where a.sjh=@sjh and b.jssjh=a.sjh and b.sqdxh=c.xh and isnull(b.sqdxh,0)<>0
		and ((@qtbz=0 and b.sqdxh not in(select e.sqdxh from SF_BRJSK d,SF_MZCFK e where d.sjh=@newsjh and e.jssjh=d.sjh and isnull(e.sqdxh,0)<>0))  --部分退费
			or (@qtbz=1)) --全退
	    if @@error<>0
	    begin
			select "F","更新申请单信息出错！"
		    rollback tran
		    return		
	    end 
		--更新年表
		update c set c.jlzt=1 from VW_MZBRJSK a,VW_MZCFK b,SF_NMZSQD c
        where a.sjh=@sjh and b.jssjh=a.sjh and b.sqdxh=c.xh and isnull(b.sqdxh,0)<>0
		and ((@qtbz=0 and b.sqdxh not in(select e.sqdxh from SF_BRJSK d,SF_MZCFK e where d.sjh=@newsjh and e.jssjh=d.sjh and isnull(e.sqdxh,0)<>0))  --部分退费
			or (@qtbz=1)) --全退
	    if @@error<>0
	    begin
			select "F","更新申请单信息出错！"
		    rollback tran
		    return		
	    end         
    end
    --yxc
	declare @yyt_tje ut_money,@yyt_sje ut_money -- 操作部分退费退多少钱的银医通
	
	select @yyt_tje=ISNULL(@yyt_tje,0),@yyt_sje=ISNULL(@yyt_sje,0)
	
	select @yyt_tje = zpje  from SF_BRJSK WHERE sjh=@newsjh1 and zph='Y'
	if @qtbz=0
	begin
		--更新收费新纪录(相当于新处方)
		update SF_MZCFK set jlzt=0,
			lrrq=(case when @jsrq='' then @now else @jsrq end),
			czyh=@czyh,pybz = 0,gxrq=@now   --add by yfq @20120528
		where jssjh=@newsjh
		if @@error<>0
		begin
			rollback tran
			select "F","更新门诊处方信息出错！"
			return
		end
		
	    if @acfdfp=1 and @configdyms=0 --add by ozb and @configdyms=0 打印模式为旧模式
		begin	

			update SF_MZCFK  SET zfje=round(a.zfje+b.srje,2),srje=round(b.srje,2)  
			from SF_BRJSK b(nolock),SF_MZCFK a(nolock)  where a.jssjh=b.sjh and b.sjh=@newsjh  
				and a.cfxh=(select min(cfxh) from SF_MZCFK(nolock) where jssjh=@newsjh)
			if @@error<>0
			begin
				rollback tran
				select "F","更新门诊处方信息出错！"
				return
			end		
			--总金额对平
			declare @jece ut_money
			select @jece=zfje-(select sum(isnull(zfje,0)) from SF_MZCFK(nolock) where jssjh=@newsjh ) 
				from SF_BRJSK(nolock)  where sjh=@newsjh  
			update SF_MZCFK  set zfje=round(isnull(zfje,0)+@jece,2) where jssjh=@newsjh 
				and cfxh=(select min(cfxh) from SF_MZCFK(nolock) where jssjh=@newsjh)
			if @@error<>0
			begin
				rollback tran
				select "F","更新门诊处方信息出错！"
				return
			end
	 
		end

		--药房流水号处理  add by xr 2010-09-17
		if (select config from YY_CONFIG (nolock) where id='2132')='是'  
		begin  
			if (select config from YY_CONFIG (nolock) where id='0081')='2'   
			begin  
				declare cs_cfk_fyckxh cursor for select distinct fyckdm from SF_MZCFK(nolock) where jssjh=@newsjh and cflx in (1,2,3) -- add by gzy at 20050518  
				open cs_cfk_fyckxh  
				fetch cs_cfk_fyckxh into @fyckdm1  
				while @@fetch_status=0   
				begin  
					--copy by gxf 2011-1-27
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
					update SF_MZCFK set yflsh=@yflsh,fyckxh=@fyckxh+1 where jssjh = @newsjh AND fyckdm = @fyckdm1  -- modify by wfy 2007-03-16
					if @@ERROR<>0 OR @@ROWCOUNT = 0
					begin
						select 'F','更新流水号错误'
						rollback tran 
						deallocate cs_cfk_fyckxh
						return      
					end
					--copy by gxf 2011-1-27
					fetch cs_cfk_fyckxh into @fyckdm1  
				end  
				close cs_cfk_fyckxh  
				deallocate cs_cfk_fyckxh  
			end  
			else if (select config from YY_CONFIG (nolock) where id='0081')='3'   
			begin  
				if exists(select 1 from SF_MZCFK where jssjh=@newsjh and cflx in (1,2,3))  
				begin  
					--select @yfdm=yfdm from SF_MZCFK   
					--select @yflsh=isnull(xh,0) from SF_YFLSHK(nolock) where rq =substring(@now,1,8)  
					select @yflsh = xh from SF_YFLSHK(nolock) where rq =substring(@now,1,8) and yfdm=''  
					if @@error<>0      
					begin       
						select "F","取最大药房流水号出错！" 
						rollback tran      
						return      
					end       

					select @yflsh = isnull(@yflsh,0)+1 -- add by wfy 2007-03-15  

					if @yflsh<=1  
					insert SF_YFLSHK(rq,xh,yfdm)  
					values(substring(@now,1,8),@yflsh,'')    
					else  
					update SF_YFLSHK set xh=@yflsh where rq =substring(@now,1,8) and yfdm=''  
					if @@error<>0      
					begin      
						select "F","更新最大据号出错！" 
						rollback tran    
						return      
					end      
					update SF_MZCFK set yflsh=@yflsh where jssjh = @newsjh  -- modify by wfy 2007-03-16  
					if @@ERROR<>0 OR @@ROWCOUNT = 0  
					begin  
						select "F","更新药房流水号出错！"  
						rollback tran   
						return  
					end  
				end  
			end  
			else if (select config from YY_CONFIG (nolock) where id='0081')='1'   
			begin  
				declare cs_cfk_yfdm cursor for select distinct yfdm from SF_MZCFK(nolock) where jssjh=@newsjh and cflx in (1,2,3)  
				open cs_cfk_yfdm  
				fetch cs_cfk_yfdm into @yfdm  
				while @@fetch_status=0   
				begin  
					select @yflsh = xh from SF_YFLSHK(nolock) where rq =substring(@now,1,8) and yfdm=@yfdm  
					if @@error<>0      
					begin      
						select "F","取最大药房流水号出错！"  
						rollback tran
						deallocate cs_cfk_yfdm      
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
						deallocate cs_cfk_yfdm      
						return      
					end   
					update SF_MZCFK set yflsh=@yflsh where jssjh = @newsjh and yfdm=@yfdm  -- modify by wfy 2007-03-16  
					if @@ERROR<>0 OR @@ROWCOUNT = 0  
					begin  
						select "F","更新药房流水号出错！"  
						rollback tran  
						deallocate cs_cfk_yfdm  
						return  
					end  
					fetch cs_cfk_yfdm into @yfdm  
				end  
				close cs_cfk_yfdm  
				deallocate cs_cfk_yfdm  
			end  
		end 
		--根据原收费金额，判断重收的zfje与原收费数据的xjje比较
		--mod by yyc for BUG 153690
		if (@zffs_y='7') and (@zpje_y>0) and (@tzpfs=1) 
            and (exists (select 1 from YY_CONFIG (nolock) where id='2197' and config='是'))	
        begin	
			update SF_BRJSK set sfrq=(case when @jsrq='' then @now else @jsrq end),
				ybjszt=2,
				zxlsh=(case isnull(@zxlsh,'') when '' then zxlsh else @zxlsh end),
				fph=(case isnull(@fph,0) when 0 then fph else @fph end),
				fpjxh=(case isnull(@fpjxh,0) when 0 then fpjxh else @fpjxh end),
				--xjje=zfje-@qkje,
				xjje = 0,
				--xjje = (case @qkbz when 4 then 0 else zfje-@qkje-(@ylknewje)-@gbje-@bdyhkje end), --alter by gxf 2008-1-21
				--qkje = (case @qkbz when 4 then zfje else qkje end),--alter by gxf 2008-1-21
				dnzhye=(case when @qkbz=1 then @zhje else dnzhye end)
				,ylkje=@ylknewje
				,ylksqxh=@ylknewsqxh
				,yflsh=@yflsh --add by xr 2010-09-17
				,ylkzxlsh=@ylknewzxlsh
				,qrrq=@now
				,bdyhkje = @bdyhkje
				,bdyhklsh = @bdyhklsh
				,lrrq=@now
				,zpje =zfje-@qkje-(@ylknewje)-@gbje-@bdyhkje-(case when (@yytbz >0) and (@zffs_y = 'Y'  ) then @jfje else 0 end)
				,zph = '7'
				,gxrq=@now --add by yfq @20120528
				--,fpdybz=1
				,fpdybz=case when @print=0 and @configdyms=0 then 0 else 1 end
				,fpdyczyh=case when @print=0 and @configdyms=0 then @czyh else null end
				,fpdyrq=case when @print=0 and @configdyms=0 then @now else null end
				,hzdybz=0
				where sjh=@newsjh
		end
		else
		begin
			update SF_BRJSK set sfrq=(case when @jsrq='' then @now else @jsrq end),
				ybjszt=2,
				zxlsh=(case isnull(@zxlsh,'') when '' then zxlsh else @zxlsh end),
				fph=(case isnull(@fph,0) when 0 then fph else @fph end),
				fpjxh=(case isnull(@fpjxh,0) when 0 then fpjxh else @fpjxh end),
				--xjje=zfje-@qkje,
				xjje = zfje-@qkje-(@ylknewje)-@gbje-@bdyhkje
						-(case when (@yytbz >0) and (@zffs_y = 'Y'  ) then @jfje else 0 end)
						/*   -(case when zph='S' then zpje else 0 end),   */
						-(case when zph<>'' then zpje else 0 end),
				--xjje = (case @qkbz when 4 then 0 else zfje-@qkje-(@ylknewje)-@gbje-@bdyhkje end), --alter by gxf 2008-1-21
				--qkje = (case @qkbz when 4 then zfje else qkje end),--alter by gxf 2008-1-21
				dnzhye=(case when @qkbz=1 then @zhje else dnzhye end)
				,ylkje=@ylknewje
				,ylksqxh=@ylknewsqxh
				,yflsh=@yflsh --add by xr 2010-09-17
				,ylkzxlsh=@ylknewzxlsh
				,qrrq=@now
				,bdyhkje = @bdyhkje
				,bdyhklsh = @bdyhklsh
				,lrrq=@now
				,zpje =(case when (@yytbz >0) and (@zffs_y = 'Y'  ) then @jfje else zpje end)
				,zph = (case when (@yytbz >0) and (@zffs_y = 'Y'  ) then 'Y'
							 when qkbz=4 then '4' 
							 else zph end)
				,gxrq=@now --add by yfq @20120528
				--,fpdybz=1
				,fpdybz=case when @print=0 and @configdyms=0 then 0 else 1 end
				,fpdyczyh=case when @print=0 and @configdyms=0 then @czyh else null end
				,fpdyrq=case when @print=0 and @configdyms=0 then @now else null end
				,hzdybz=0
				where sjh=@newsjh		
		end
		if @@error<>0 or @@rowcount=0
		begin
			select "F","更新收费结算信息出错！"
			rollback tran
			return
		end

		if @config2596='是' and @zffs <> 0 
		begin	--重收 @newsjh，正记录 @y_sjh, 负记录 @newsjh1
			declare @cs_zfje	ut_money,
					@cs_xjje	ut_money,
					@cs_zpje	ut_money,
					@cs_zph		varchar(5),
					@y_qkje		ut_money,
					@y_xjje		ut_money,
					@y_zpje		ut_money,
					@y_zph		varchar(5),
					@y_sjh		varchar(30)

			select @y_sjh=tsjh from SF_BRJSK where sjh=@newsjh1
			select @y_xjje=xjje,@y_zpje=zpje,@y_zph=zph,@y_qkje=qkje from VW_MZBRJSK (nolock) where sjh=@y_sjh
			select @cs_zfje=zfje from SF_BRJSK (nolock) where sjh=@newsjh
			--排除充值卡以及支票支付
			if @y_qkje=0 and @y_zph<>'2'
			begin
				if @cs_zfje<=@y_xjje

				begin
					select @cs_xjje=@cs_zfje,@cs_zpje=0,@cs_zph=''


				end
				else
				begin
					select @cs_xjje=@y_xjje,@cs_zpje=@cs_zfje-@y_xjje,@cs_zph=@y_zph
				end

				update SF_BRJSK set
					xjje=@cs_xjje,
					zpje=@cs_zpje,
					zph=@cs_zph
				where sjh=@newsjh
			end;
		end

		if exists(select 1 from YY_CONFIG nolock where id='1584' and config='是')
			and exists(select 1 from SF_BRXXK_FZ nolock where patid=@patid and isnull(gbfsjh,'')=@sjh)
		begin
			if @qtbz=0
				update SF_BRXXK_FZ set gbfsjh=@newsjh where patid=@patid
			else if @qtbz = 1
				update SF_BRXXK_FZ set gbfsjh='' where patid=@patid
			if @@ERROR<>0
			begin
				select "F","更新病人工本费收据出错！"
				rollback tran
				return
			end

		end
		if @qtbz = 0 
		begin
		    if exists (select 1 from sysobjects where name='SF_BRJSK_FZ' and xtype='U')

		    BEGIN		
		        select @yhyydm = isnull(yhyydm,'0') from SF_BRJSK_FZ where sjh = @sjh
		    
			    update  SF_BRJSK_FZ set fph=@fph,fpjxh=@fpjxh,fpdm=@fpdm,yhyydm = @yhyydm where sjh=@newsjh		 
			    if @@error<>0
			    begin
				    select "F","保存结算账单出错！"
				    rollback tran
				    return		
			    end	
		    END

		end


		              
  IF  EXISTS (SELECT 1 FROM YY_ADZFPT_JYMX WHERE sjh=@newsjh)              
  begin              
   UPDATE YY_ADZFPT_JYMX SET jsbz = 2,tsjh=@sjh  WHERE sjh=@newsjh            
   if @@error<>0 or @@rowcount=0            
   begin            
    select "F","更新亚德补收记录出错！"            
    rollback tran            
    return            
   END            
  END  
		--mod by yyc 
		if (@zffs_y='7') and (@zpje_y>0) and (@tzpfs=1) 
            and (exists (select 1 from YY_CONFIG (nolock) where id='2197' and config='是'))
		begin
			update SF_BRJSK set xjje = 0, zpje = zfje ,zph='7' where sjh=@newsjh
			if @@error<>0
			begin
				select "F","更新收费结算信息出错1！"
				rollback tran
				return		
			end
            --select @sfje=0,@sfje2=0
		end



        
  if @print=0 and @acfdfp=0 and @configdyms=0 --add by ozb and @configdyms=0 打印模式为旧模式            
  begin            
   exec usp_yy_gxzsj @fplx, @czyh, @errmsg output, @gyfpbz            
   if @errmsg like 'F%'            
   begin            
    select "F",substring(@errmsg,2,49)            
    rollback tran            
    return            
   end            
  end            
              
 END             
 IF @zffs_y='Y' AND @zzfs_tf=1            
 BEGIN            
  UPDATE YY_ADZFPT_JYMX SET jlzt=1 WHERE sjh=@sjh            
  if @@error<>0 or @@rowcount=0            
  begin            
   select "F","更新亚德被退记录出错！"            
   rollback tran            
   return            
  END             
              
  UPDATE YY_ADZFPT_JYMX SET jsbz = 2,sjh=@newsjh1  WHERE tsjh=@sjh AND jlzt=2            
  if @@error<>0 or @@rowcount=0            
  begin            
   select "F","更新亚德红冲出错！"            
   rollback tran            
   return            
  END             
         

		if  @qtbz=0  
		begin
			select @yyt_sje = zpje  from SF_BRJSK WHERE sjh=@newsjh and zph='Y'
			select  @yyt_tje=@yyt_tje+@yyt_sje

		end
		if @print=0 and @acfdfp=0 and @configdyms=0 --add by ozb and @configdyms=0 打印模式为旧模式


		begin
			exec usp_yy_gxzsj @fplx, @czyh, @errmsg output, @gyfpbz,@fpjxh,@sfksdm,@ipdz_gxzsj
			if @errmsg like 'F%'
			begin
				select "F",substring(@errmsg,2,49)
				rollback tran
				return
			end
		end
	end
	
	
	

	--确认出错记录
	update SF_YBBFTFJKK set jlzt=1 where sjh=@sjh and jlzt=0 
	if @@error<>0
	begin
		rollback tran
		select "F","确认出错记录出错！"
		return
	end
	
	--统筹累计金额处理
	select @tcljybdm = config from YY_CONFIG where id = '0115'
	if charindex('"'+rtrim(@ybdm)+'"',@tcljybdm) > 0
	begin
		declare @mzpatid ut_xh12,
				@m_cardno ut_cardno,
				@tcljje2 ut_money,
				@cardtype ut_dm2
		select @m_cardno = cardno,@cardtype = cardtype,
				@tcljje1=zje-(zfje-srje)-yhje-isnull(tsyhje,0)
				from SF_BRJSK nolock where sjh = @sjh
		select @mzpatid=mzpatid from YY_BRLJXXK nolock where cardno = @m_cardno and cardtype = @cardtype
		if @@rowcount <> 0
		begin
			select @tcljje2=zje-(zfje-srje)-yhje-isnull(tsyhje,0)
			from SF_BRJSK nolock where sjh = @newsjh
			select @tcljje = isnull(@tcljje2,0) -isnull(@tcljje1,0)

			exec usp_zy_tcljjegl @m_cardno,@mzpatid,@tcljje,0,0,0,3,@czyh
			if @@error <> 0 
			begin
				rollback tran
				select "F","更新YY_BRLJXXK的统筹累计金额出错！"
				return
			end
		end
	end	

	--add wuwei 汇总打印发票退费处理
	if exists(select 1 from VW_MZBRJSK where sjh =@sjh and hzdybz =1)


	begin
		declare @fph_hzdy bigint
		,@fpjxh_hzdy int
		,@updatefph ut_bz --0 不更新 1 更新
		,@fph_fymxdyk bigint
		,@fpjxh_fymxdyk int
		,@maxxh int

		select @updatefph =1
	
 
		select @fph_hzdy =fph,@fpjxh_hzdy =fpjxh from 	VW_MZBRJSK where sjh =@sjh

		if isnull(@fph_hzdy,0) =0--如果发票号为空，则已经更新过了无须更新
		begin
			select @updatefph =0
		end
		
		if @updatefph =1---需要更新，则更新发票号
		begin
			if exists(select 1 from SF_BRJSK where fph =@fph_hzdy and ybjszt =2 and jlzt =0 and fpjxh =@fpjxh_hzdy)
			begin
				update SF_BRJSK set fph =null,qrbz =case qrbz when 0 then 0 else 1 end,fpjxh =null--,fpdybz = 1 
				where fph =@fph_hzdy and ybjszt =2 and jlzt =0 and fpjxh =@fpjxh_hzdy
				if @@error <>0
				begin
					rollback tran
					select "F","还原 fph,qrbz 出错！"
					return
				end
			end
			else
			begin
				update SF_NBRJSK set fph =null,qrbz =case qrbz when 0 then 0 else 1 end,fpjxh =null--,fpdybz = 1 
				 where fph =@fph_hzdy and ybjszt =2 and jlzt =0 and fpjxh =@fpjxh_hzdy
				if @@error <>0
				begin
					rollback tran
					select "F","还原 Nfph,qrbz出错！"
					return
				end
			end
		end
		else
		if @updatefph =0--无需更新代表已经被清空了，则将发票号从 SF_FPDYMXK_HZDY 中反更新回来
		begin
			select @maxxh =max(xh) 
			from SF_FPDYMXK_HZDY where jssjh =@sjh
			
			if isnull(@maxxh,0)<>0 
			begin
			    select @fph_fymxdyk =fph,@fpjxh_fymxdyk =fpjxh from SF_FPDYMXK_HZDY where xh =@maxxh
			    if @@rowcount =0
			    begin
				    select 'F','取反更新 SF_FPDYMXK_HZDY.xh 出错'
				    rollback tran
				    return
			    end
			
			    if exists(select 1 from SF_BRJSK where sjh =@sjh)
			    begin
				    update SF_BRJSK set fph =@fph_fymxdyk,fpjxh =@fpjxh_fymxdyk,qrbz =case qrbz when 0 then 0 else 2 end  where sjh =@sjh
				    if @@error <>0
				    begin
					    rollback tran
					    select "F","反更新 fph,qrbz 出错！"
					    return
				    end
    				
				    update SF_BRJSK set fph =@fph_fymxdyk,fpjxh =@fpjxh_fymxdyk,qrbz =case qrbz when 0 then 0 else 2 end  where sjh =@newsjh1
				    if @@error <>0
				    begin
					    rollback tran
					    select "F","反更新 fph,qrbz 出错！"
					    return
				    end
			    end
			 end
			else
			begin
				update SF_NBRJSK set fph=@fph_fymxdyk,fpjxh =@fpjxh_fymxdyk,qrbz =case qrbz when 0 then 0 else 2 end  where sjh =@sjh
				if @@error <>0
				begin
					rollback tran
					select "F","反更新 nfph,qrbz 出错！"
					return
				end				
				update SF_NBRJSK set fph =@fph_fymxdyk,fpjxh =@fpjxh_fymxdyk,qrbz =case qrbz when 0 then 0 else 2 end  where sjh =@newsjh1
				if @@error <>0
				begin
					rollback tran
					select "F","反更新 nfph,qrbz 出错！"
					return
				end
			end
		end
		
		if @qtbz =0
		begin	
			update SF_BRJSK set qrbz =case qrbz when 0 then 0 else 1 end where sjh =@newsjh
			if @@error <>0
			begin
				rollback tran
				select "F","还原SF_BRJSK.qrbz出错！"
				return
			end
		end		
	end
	
	--if exists(select 1 from SF_BRJSK(nolock) where sjh =@newsjh and zph='S' AND zpje=0) 
	--	update SF_BRJSK set zph='' where sjh =@newsjh

	if exists(select 1 from SF_BRJSK(nolock) where sjh =@newsjh and zph<>'' AND zpje=0) 
		update SF_BRJSK set zph='' where sjh =@newsjh

	--二级库系统自动减库存 
	
	if ((select config from YY_CONFIG where id='A219')='是') and ((select config from YY_CONFIG where id='A234')='否')
		and ((select config from YY_CONFIG where id='A262')='是')and ((select config from YY_CONFIG where id='A206')='1') 
	begin
		--begin tran
		declare @pcxh ut_xh12  --批次序号  
			 ,@tm ut_mc64   --条码 
			 ,@pcfxh	ut_xh12 
			 ,@pcfmxxh	ut_xh12 
			 ,@phjcfxh	ut_xh12 
			 ,@phjcfmxxh	ut_xh12 
		

		declare cs_ejkc cursor for 
		select a.xh,b.xh,b.hjmxxh,c.cfxh  from SF_MZCFK a (nolock),SF_CFMXK b (nolock) ,SF_HJCFMXK c (nolock) 
			where a.xh=b.cfxh and b.hjmxxh=c.xh and  jssjh=@newsjh1 and cflx not in (1,2,3)
		for read only

		open cs_ejkc
		fetch cs_ejkc into @pcfxh,@pcfmxxh ,@phjcfmxxh,@phjcfxh 
		while @@fetch_status=0
		begin 
			---获取批次
			select @pcxh=0,@tm='0'
			select @pcxh=isnull(wzpcxh,'0'),@tm=isnull(txm,'0') from fun_yy_mz_cljlk(@phjcfxh,@phjcfmxxh,1) 
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
				exec usp_yy_mz_updatecljlk @phjcfxh,@phjcfmxxh,@pcfmxxh,3,@errmsg output 
				if @errmsg like 'F%' or @@error<>0  
				begin    
			 		rollback tran
					select "F","二级库系统自动增减库存时出错--更新状态！"+@errmsg
					deallocate cs_ejkc
					return
				END  
			end
			fetch cs_ejkc into @pcfxh,@pcfmxxh ,@phjcfmxxh,@phjcfxh
		end
		close cs_ejkc
		deallocate cs_ejkc

		if @qtbz=0	--部分退费时要插入新记录
		begin
			declare cs_ejkct cursor for 
			select a.xh,b.xh,b.hjmxxh,c.cfxh  from SF_MZCFK a (nolock),SF_CFMXK b (nolock) ,SF_HJCFMXK c (nolock) 
			where a.xh=b.cfxh and b.hjmxxh=c.xh and jssjh=@newsjh and cflx not in (1,2,3)
			for read only

			open cs_ejkct
			fetch cs_ejkct into @pcfxh,@pcfmxxh ,@phjcfmxxh,@phjcfxh
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
						deallocate cs_ejkct
						return
					END  

					---更新状态
					exec usp_yy_mz_updatecljlk @phjcfxh,@phjcfmxxh,@pcfmxxh,2,@errmsg output 
					if @errmsg like 'F%' or @@error<>0  
					begin    
			 			rollback tran
						select "F","二级库系统自动增减库存时出错--更新状态！"+@errmsg
						deallocate cs_ejkct
						return
					END   
				end

				fetch cs_ejkct into @pcfxh,@pcfmxxh,@phjcfmxxh,@phjcfxh
			end
			close cs_ejkct
			deallocate cs_ejkct
		end
		--commit tran
	end 
    
    --需求 347373 凤阳县人民医院--HRP与HIS对接 
    if exists(select 1 from YY_CONFIG nolock where id='2590' and config='是') 
	begin
		declare @hrp_database	varchar(32)
		select @hrp_database = config from YY_CONFIG nolock where id='0252'
		if(@@ROWCOUNT = 1)and(RTRIM(@hrp_database)<>'')
		begin		
			declare @hrp_cfxh		ut_xh12,
					@hrp_cfmxxh		ut_xh12,
					@hrp_ncfxh		ut_xh12,
					@hrp_ncfmxxh	ut_xh12,
					@hrp_strsql		varchar(1000)
					
			declare cs_hrp_clhx cursor for 
			select a.txh,b.tmxxh,a.xh,b.xh
			from SF_MZCFK a (nolock) 
				inner join SF_CFMXK b (nolock) on a.xh = b.cfxh
			where a.jssjh=@newsjh and b.yjqrbz is not null and b.yjqrbz = 1
				and isnull(b.qrksdm,'')<>'' and isnull(b.qrczyh,'')<>''
				and isnull(b.cd_idm,0) = 0 and isnull(b.lcxmdm,'0')='0' 
				and a.patid=@patid
			for read only

			open cs_hrp_clhx
			fetch cs_hrp_clhx into @hrp_cfxh,@hrp_cfmxxh ,@hrp_ncfxh,@hrp_ncfmxxh 
			while @@fetch_status=0
			begin 
				select @hrp_strsql = 
					'	declare @hrp_result	varchar(2),'+
					'	@hrp_msg	varchar(64) '+
					'	exec '+RTRIM(@hrp_database)+'dbo.USP_LSCM_CLHXQR @patid='+CONVERT(varchar(12),@patid)+
					',@ycfxh='+CONVERT(varchar(12),@hrp_cfxh)+',@ycfmxxh='+CONVERT(varchar(12),@hrp_cfmxxh)+
					',@ncfxh='+CONVERT(varchar(12),@hrp_ncfxh)+',@ncfmxxh='+CONVERT(varchar(12),@hrp_ncfmxxh)+
					',@result=@hrp_result output,@cwxx=@hrp_msg output '+
					'if @hrp_result = ''F'' '+
					'	RAISERROR(''USP_LSCM_CLHXQR return error : %s '',16,1,@hrp_msg) '
				exec(@hrp_strsql)
				if(@@ERROR<>0)
				begin
					select 'F','调用HRP材料核销状态重绑定失败！'
					rollback tran
					close cs_hrp_clhx
					deallocate cs_hrp_clhx
					return
				end
				fetch cs_hrp_clhx into @hrp_cfxh,@hrp_cfmxxh ,@hrp_ncfxh,@hrp_ncfmxxh 
			end
			close cs_hrp_clhx
			deallocate cs_hrp_clhx
		end
	end
	commit tran

	--采用医生站配药流程（配药写入SF_PYQQK方式）
	
	if (select config from YY_CONFIG where id='0124')='是'
	begin
		begin tran          
		declare cs_pyqq1 cursor for 
		select xh,hjxh,fybz from SF_MZCFK(nolock) where jssjh=@sjh and fybz=0	--未发药的记录需要处理
		for read only

		open cs_pyqq1
		fetch cs_pyqq1 into @pycfxh,@pyhjxh,@pyfybz
		while @@fetch_status=0
		begin
			select @qqkpybz=0,@havejl=0
			select @qqxh=xh,@qqkpybz=pybz from SF_PYQQK where jssjh=@sjh and (cfkxh=@pycfxh or hjxh=@pyhjxh) and patid=@patid
			if @@rowcount<>0	--SF_PYQQK中有记录
			begin
				select @havejl=1
				if @qqkpybz=1	--未发药且已配药
				begin
					select @pyhcxh=xh,@pyhcsjh=jssjh from SF_MZCFK(nolock) 
					where isnull(txh,0)=@pycfxh and jlzt=2

					insert into SF_PYQQK(jssjh,hjxh,cfxh,cfkxh,czyh,lrrq,patid,hzxm,ybdm,py,wb,ysdm,ksdm,yfdm,qrczyh,
					qrrq,qrksdm,pyczyh,pyrq,cfts,txh,sfckdm,pyckdm,fyckdm,jsbz,
					jlzt,fybz,cflx,sycfbz,tscfbz,pybz,jcxh,memo,zje,zfyje,yhje,zfje,srje,
					fph,fpjxh,tfbz,tfje,xzks_id ,spzfbl,spzfce,pyqr,sqdxh,yflsh,ejygksdm,
					ejygbz,ksfyzd_xh,fyckxh,dpxsbz,zpwzbh,zpbh)	
					select @pyhcsjh,hjxh,cfxh,@pyhcxh,czyh,@now,patid,hzxm,ybdm,py,wb,ysdm,ksdm,yfdm,qrczyh,
					qrrq,qrksdm,"","",cfts,xh,sfckdm,pyckdm,fyckdm,jsbz,
					2,fybz,cflx,sycfbz,tscfbz,0,jcxh,memo,zje,zfyje,yhje,zfje,srje,
					fph,fpjxh,tfbz,tfje,xzks_id ,spzfbl,spzfce,pyqr,sqdxh,yflsh,ejygksdm,
					ejygbz,ksfyzd_xh,fyckxh,dpxsbz,zpwzbh,zpbh
					from SF_PYQQK(nolock)
					where xh=@qqxh
					if @@error<>0
					begin
						rollback tran
						select "F","红冲SF_PYQQK时出错！"
						deallocate cs_pyqq1
						return
					end

					select @xhtemp=@@identity

					insert into SF_PYMXK(cfxh,cd_idm,gg_idm,dxmdm,ypmc,ypdm,ypgg,ypdw,dwxs,ykxs,ypfj,ylsj,ypsl,
					ts,cfts,zfdj,yhdj,shbz,memo,flzfdj,txbl,lcxmdm,lcxmmc,zbz,yjqrbz,qrksdm,clbz,hjmxxh,
					hy_idm,hy_pdxh,gbfwje,gbfwwje,gbtsbz,btsbl,hzlybz,bgdh,bgzt,txzt,bglx,fpzh,lcxmsl,
					dydm,yyrq,yydd,zysx,yylsj,yjspbz,lcjsdj)
					select @xhtemp,cd_idm,gg_idm,dxmdm,ypmc,ypdm,ypgg,ypdw,dwxs,ykxs,ypfj,ylsj,-1*ypsl,
					ts,cfts,zfdj,yhdj,shbz,memo,flzfdj,txbl,lcxmdm,lcxmmc,zbz,yjqrbz,qrksdm,clbz,hjmxxh,
					hy_idm,hy_pdxh,gbfwje,gbfwwje,gbtsbz,btsbl,hzlybz,bgdh,bgzt,txzt,bglx,fpzh,-1*lcxmsl,
					dydm,yyrq,yydd,zysx,yylsj,yjspbz,lcjsdj
					from SF_PYMXK(nolock)
					where cfxh=@qqxh
					if @@error<>0
					begin
						rollback tran
						select "F","红冲SF_PYMXK时出错！"
						deallocate cs_pyqq1
						return
					end
				end
				if @qqkpybz=0	--未发药且未配药
				begin
					delete from SF_PYQQK where xh=@qqxh
					if @@error<>0
					begin
						rollback tran
						select "F","删除SF_PYQQK的记录时出错！"
						deallocate cs_pyqq1
						return
					end
				end
			end
			fetch cs_pyqq1 into @pycfxh,@pyhjxh,@pyfybz
		end
		close cs_pyqq1
		deallocate cs_pyqq1

		if @qtbz=0	--部分退费时要插入新记录
		begin
			declare cs_pyqq2 cursor for
			select xh,hjxh from SF_MZCFK(nolock) where jssjh=@newsjh and fybz=0

			open cs_pyqq2
			fetch cs_pyqq2 into @pycfxh,@pyhjxh
			while @@fetch_status=0
			begin
				insert into SF_PYQQK(jssjh,hjxh,cfxh,cfkxh,czyh,lrrq,patid,hzxm,ybdm,py,wb,ysdm,ksdm,yfdm,qrczyh,
				qrrq,qrksdm,pyczyh,pyrq,cfts,txh,sfckdm,pyckdm,fyckdm,jsbz,
				jlzt,fybz,cflx,sycfbz,tscfbz,pybz,jcxh,memo,zje,zfyje,yhje,zfje,srje,
				fph,fpjxh,tfbz,tfje,xzks_id ,spzfbl,spzfce,pyqr,sqdxh,yflsh,ejygksdm,
				ejygbz,ksfyzd_xh,fyckxh,dpxsbz,zpwzbh,zpbh)
				select jssjh,hjxh,cfxh,xh,czyh,lrrq,patid,hzxm,ybdm,py,wb,ysdm,ksdm,yfdm,qrczyh,
				qrrq,qrksdm,pyczyh,pyrq,cfts,null,sfckdm,pyckdm,fyckdm,1,
				jlzt,fybz,cflx,sycfbz,tscfbz,pybz,jcxh,memo,isnull(zje,0),isnull(zfyje,0),isnull(yhje,0),isnull(zfje,0),isnull(srje,0),
				fph,fpjxh,tfbz,tfje,xzks_id ,0,0,pyqr,sqdxh,yflsh,ejygksdm,
				ejygbz,ksfyzd_xh,fyckxh,dpxsbz,zpwzbh,zpbh
				from SF_MZCFK(nolock)
				where xh=@pycfxh
				if @@error<>0
				begin
					rollback tran
					select "F","插入SF_PYQQK出错！"
					deallocate cs_pyqq2
					return
				end

				select @xhtemp=@@identity

				insert into SF_PYMXK(cfxh,cd_idm,gg_idm,dxmdm,ypmc,ypdm,ypgg,ypdw,dwxs,ykxs,ypfj,ylsj,ypsl,
				ts,cfts,zfdj,yhdj,shbz,memo,flzfdj,txbl,lcxmdm,lcxmmc,zbz,yjqrbz,qrksdm,clbz,hjmxxh,
				hy_idm,hy_pdxh,gbfwje,gbfwwje,gbtsbz,btsbl,hzlybz,bgdh,bgzt,txzt,bglx,fpzh,lcxmsl,
				dydm,yyrq,yydd,zysx,yylsj,yjspbz,lcjsdj)
				select @xhtemp,cd_idm,gg_idm,dxmdm,ypmc,ypdm,ypgg,ypdw,dwxs,ykxs,ypfj,ylsj,ypsl,
				ts,cfts,zfdj,yhdj,shbz,memo,flzfdj,txbl,lcxmdm,lcxmmc,zbz,yjqrbz,qrksdm,clbz,hjmxxh,
				hy_idm,hy_pdxh,gbfwje,gbfwwje,gbtsbz,gbtsbl,hzlybz,bgdh,bgzt,txzt,bglx,fpzh,lcxmsl,
				dydm,yyrq,yydd,zysx,yylsj,yjspbz,lcjsdj
				from SF_CFMXK(nolock)
				where cfxh=@pycfxh
				if @@error<>0
				begin
					rollback tran
					select "F","插入SF_PYMXK出错！"
					deallocate cs_pyqq2
					return
				end

				fetch cs_pyqq2 into @pycfxh,@pyhjxh
			end
			close cs_pyqq2
			deallocate cs_pyqq2
		end
		commit tran
	end  
    
			

	if @qkbz = 1 
	begin
		select @qkje_view = @qkje_new
	end
	else
		select @qkje_view = @qkje




	select 	@ysybzfje = isnull(sum(je),0) from SF_JEMXK nolock where lx in ('20','22','yb25') and jssjh = @newsjh
	select 	@gbje2 = isnull(sum(je),0) from SF_JEMXK nolock where lx in ('24','yb99') and jssjh = @newsjh

	--已停用的卡退费，qkje退到xjje中
	declare @tslc		ut_bz,
			@oldqkje	ut_money,
			@newqkje	ut_money
	if exists(select 1 from YY_JZBRK a(nolock),YY_JZBRYJK b(nolock) where a.xh = b.jzxh and isnull(b.sjh,'') = @sjh 
		and a.jlzt = 1)
	begin
		select @tslc = 1
	end
	else
	begin
		select @tslc = 0
	end
	if @tslc = 1
	begin
		select @oldqkje = xjje from SF_BRJSK (nolock) where sjh = @newsjh1
		if @qtbz = 0
			select @newqkje = xjje from SF_BRJSK (nolock) where sjh = @newsjh
		else 
			select @newqkje = 0
	end
	if @acfdfp=0 or @configdyms=1
	begin

		if (select config from YY_CONFIG (nolock) where id='2036')='是'
		begin
			select "T", @zje, case when @gbbz = '0' then @zfyje-@flzfje else @gbje2 end, convert(varchar(20),@fph), --0-3
				@print, @sfje2-@qkje-@gbje, @qfdnzhzfje+@qflnzhzfje+@tclnzhzfje+@fjlnzhzfje,  --4-6
				@tczfje, @dffjzfje, 
				case @tslc when 1 then abs(@oldqkje+@newqkje) else case when (@sfywbzh=0) and (@zffs_y='Y') then 0
				    else
					@sfje-isnull(@sfje2,0)-(@qkje1-@qkje)-
					(isnull(@ylkje,0)-isnull(@ylknewje,0))-(@gbje1-@gbje)-(isnull(@bdyhkje_old,0)-isnull(@bdyhkje,0))
					-case when @qkbz=4 then 0 else isnull(@dbkje,0) end +@yyt_tje
				 end end-@zpje_yyt-(@zpje_zfzx1-@zpje_zfzx), 
				 '', @qkbz, @qkje_view  --12
				,@sjyjye,@sjdjje,@tsyhje,@gbje,@ysybzfje,@lczje,@lcyhje,0,0,@qkje1-@qkje 'tqkje'  --13-19-22 
				,-@yyt_tje yyt_tje,@fpdm--23,24
			union all
			select fpxmmc, sum(xmje), 0, '0', 0, sum(zfje), sum(zfyje),sum(yhje), 0, 0, fpxmdm, 0, 0 ,0,0,0,0,0,sum(xmje-lcyhje),sum(lcyhje),0,0,@qkje1-@qkje 'tqkje'  -- -22 
				,-@yyt_tje yyt_tje,''--23,24
				from SF_BRJSMXK where jssjh=@newsjh group by fpxmdm, fpxmmc
		end
		else begin
			select "T", @zje, case when @gbbz = '0' then @zfyje-@flzfje else @gbje2 end, convert(varchar(20),@fph), @print, @sfje2-@qkje-@gbje, @qfdnzhzfje+@qflnzhzfje+@tclnzhzfje+@fjlnzhzfje,  --0,6
				@tczfje, @dffjzfje   --7,8
				,
				case @tslc when 1 then abs(@oldqkje+@newqkje) else case when (@sfywbzh=0) and (@zffs_y='Y') then 0 
				 else
					 @sfje-isnull(@sfje2,0)-(@qkje1-@qkje)-(isnull(@ylkje,0)-isnull(@ylknewje,0))-(@gbje1-@gbje)-(isnull(@bdyhkje_old,0)-isnull(@bdyhkje,0))
					 -case when @qkbz=4 then 0 else isnull(@dbkje,0) end + @yyt_tje
				 end end-@zpje_yyt-(@zpje_zfzx1-@zpje_zfzx), 
				'', @qkbz, @qkje_view  -- 10 ,12
				,@sjyjye,@sjdjje,@tsyhje,@gbje,@ysybzfje,@lczje,@lcyhje,0,0,@qkje1-@qkje 'tqkje'  --13-19-22 
				,-@yyt_tje yyt_tje,@fpdm--23,24
			union all
			select dxmmc, xmje, 0, '0', 0, zfje, zfyje,yhje, 0, 0, dxmdm, 0, 0 ,0,0,0,0,0,xmje-lcyhje,lcyhje,0,0,@qkje1-@qkje 'tqkje'   --22
				,-@yyt_tje yyt_tje,''--23,24
				from SF_BRJSMXK where jssjh=@newsjh
		end
	end
	else
	begin

		--将有退费的处方打印出来  qxh 2003.5.27
		if exists(select 1 from  SF_MZCFK  where jssjh=@newsjh  and tfbz=1 and jlzt=0 ) 
		        select  "T",sum(zje), sum(zfyje), convert(varchar(20),@fph), @print, sum(zfje), @qfdnzhzfje+@qflnzhzfje+@tclnzhzfje+@fjlnzhzfje,
				@tczfje, @dffjzfje,
				case @tslc when 1 then abs(@oldqkje+@newqkje) else  case when (@sfywbzh=0) and (@zffs_y='Y') then 0 
				 else
					 @sfje-isnull(@sfje2,0)-(@qkje1-@qkje)-(isnull(@ylkje,0)-isnull(@ylknewje,0))-(@gbje1-@gbje)-(isnull(@bdyhkje_old,0)-isnull(@bdyhkje,0))
					 -case when @qkbz=4 then 0 else isnull(@dbkje,0) end + @yyt_tje
				 end end-(@zpje_zfzx1-@zpje_zfzx)
                ,'', @qkbz, @qkje_view,max(xh),max(cfxh)  --14
				,@sjyjye,@sjdjje,@tsyhje,@gbje,@ysybzfje,@lczje,@lcyhje,@qkje1-@qkje 'tqkje' --15 -22
				,-@yyt_tje yyt_tje--23
				from SF_MZCFK  where jssjh=@newsjh  and tfbz=1  
				group by fph		
				order by fph 		 
		else
		        select  "T",0, 0, 0, 1, @sfje2-@qkje-@gbje, @qfdnzhzfje+@qflnzhzfje+@tclnzhzfje+@fjlnzhzfje,
				@tczfje, @dffjzfje, 
				case @tslc when 1 then abs(@oldqkje+@newqkje) else  case when (@sfywbzh=0) and (@zffs_y='Y') then 0
				 else	
					@sfje-isnull(@sfje2,0)-(@qkje1-@qkje)-(isnull(@ylkje,0)-isnull(@ylknewje,0))-(@gbje1-@gbje)-(isnull(@bdyhkje_old,0)-isnull(@bdyhkje,0))
					-case when @qkbz=4 then 0 else isnull(@dbkje,0) end + @yyt_tje
				 end end-(@zpje_zfzx1-@zpje_zfzx)
                , '',@qkbz, @qkje_view,0,0
				,@sjyjye,@sjdjje,@tsyhje,@gbje,@ysybzfje,@lczje,@lcyhje,@qkje1-@qkje 'tqkje' --15 -22
				,-@yyt_tje yyt_tje--23
	end
end

return








