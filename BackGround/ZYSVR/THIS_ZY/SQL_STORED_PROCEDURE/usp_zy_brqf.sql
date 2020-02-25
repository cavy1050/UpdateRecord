alter proc usp_zy_brqf   
	@syxh ut_syxh,
	@czyh ut_czyh,
	@ysdm ut_czyh,
	@idm ut_xh9,
	@ypdm ut_xmdm,
	@yfdm ut_ksdm,
	@fylb smallint,
	@fyly smallint,
	@ypdw ut_unit,
	@dwxs ut_dwxs,
	@zxsl ut_sl10,
	@txbz smallint,
	@errmsg varchar(50) output,
	@xmdj money = null,
	@yzxh numeric(12,0) = null,
	@qqxh numeric(12,0) = null,
	@qqrq varchar(16) = null,
	@yexh ut_syxh = null,
	@tfbz smallint = 0,
	@tfxh ut_xh12 = null,
	@ykxs ut_dwxs = null,
	@memo ut_memo = null,
	@zfdj money = 0,
   	@shbz ut_bz = 0,
   	@spbh ut_mc32 = null,
	@jfsj ut_rq16=null,
	@kl ut_zfbl=1,
	@bljsbl ut_zfbl=1,
	@jzjsbl ut_zfbl=1,
	@lcxmdm ut_xmdm='0',  --agg 2004.09.10 
	@lcxmmc ut_mc64=null,  --agg 2004.09.10
	@zxmdm  ut_xh12=-1,--scr 2004.12.11 福州修改，除外项目对应的主项目代码
	@xedj money = 0, 	--限额单价 用于区别项目单价
	@qrksdm ut_ksdm = '', --mly 2005-04-12 确认科室代码 
	@tdxmxh ut_xh12 = 0,  --Koala 2005-09-13 特定项目 
	@ispreqf ut_bz = 0,	 --Koala	2005-08-11	是否确费预算
	@yjmxxh ut_xh12=0,
    @ybqdm ut_ksdm=null,
    @yksdm ut_ksdm=null,
    @fymxxh_out    ut_xh12 = null output,	--传出明细序号
    @qfzfyy varchar(60)='',
    @cq_fjxm ut_bz = 0,  --用于病人出区附加固定项目执行（仁济包床用流程） 
    @jzks_qf  ut_ksdm=''   --记账科室（用于报表统计）
    ,@gdzxbz ut_bz=0   --固定项目执行标志
    ,@txbl_hg ut_zfbl=null		--特需比例(用于包床时费用回滚)
    ,@sbid_qf varchar(1000)=''
    ,@jzys_qf  ut_czyh=''    --记账医生（用于报表统计）
    ,@num  int=-1,    --连续调用次数
    @cth  varchar(20)='',    --CT号
    @xxh  varchar(20)='',    --X线号
    @mrih  varchar(20)='',    --MRI号
    @bch  varchar(20)='',    --B超号
	@wkdz varchar(32)='',    --网卡地址
	@yzlb int = -1,			--医嘱类别
    ------药品多零售价合并------
    @sffy int = 0,			--是否发药，0不发药，1发药,2 退药,3已发药确费
	@zxlb int = 0,			--@sffy = 1 时有效,0 :BQ_FYQQK ,1:BQ_SYCFMXK 2:BQ_YJQQK 3:BQ_YZZJQFK 4:BQ_YJFYQQK
	@yfyzje ut_money =0,	--已发药药品总金额    
	@fyfzxh	ut_xh12=0,		--费用分组序号
	@zyfymxxh1 ut_xh12=0 
	,@ssbl_qf ut_zfbl =1  --实收比例
	,@jsks_qf ut_mc32=''
	,@wzdj money = 0  --add by guo for 物资单价(恩施医院专用)
	------药品多零售价合并--------
	,@pcxh	ut_xh12=0		--批次序号
	,@tm	ut_mc64=''		--条码
	,@kcdylb  int=0           --库存调用类别  默认0， 0-原流程  1-delphi手术费用录入 扫条码是否扣库存  
	,@jzbq_qf  ut_ksdm=''	--记账病区
	,@sfbl	ut_zfbl=null	--收费比率  add by swx 2015-1-13 for 12179 舟山普陀第二人民医院
	,@wzqqxh numeric(12,0) = 0
	,@tcwbz	ut_bz=0			--套餐外标志
	,@jzyy	ut_mc64=''		--记账原因
	,@lcxmdj money = null
	,@dyly	int	= 0			--调用来源 0 不判断 1 补记账作废 .....
	,@zxrq_xg varchar(16)=''-- 需求74281 常山县人民医院医技退费问题 医技退费是否可以修改时间
	,@bxbl	ut_zfbl=null	--80900 青岛阜外医院护士站费用录入限定范围比例选择
	,@ybshbz ut_bz=1
	,@ylzdm ut_ksdm=''		--121877 天津总医院 - 病人确费存储usp_zy_brqf增加入参“医疗小组代码”
	,@szbdj ut_money=0      --省招标单价
	,@qzzfbz ut_bz = 0       --强制自费标志  0 原流程  1 强制自费
	,@barcodehrp varchar(100)='' --望海HRP条码 
	,@sfxdzf  ut_bz=0 --收费限定支付标志  0否 1是
as--集69222 2010-4-14 15:46:11 4.0标准版 测试环境搭建63096                             
/**********
[版本号]4.0.0.0.0
[创建时间]2004.11.22
[作者]王奕
[版权] Copyright ? 2004-2008上海金仕达-卫宁软件股份有限公司[描述]病人确费
[功能说明]
	住院病人费用确费
[参数说明]
	@syxh ut_syxh,	首页序号
	@czyh ut_czyh,	操作员
	@ysdm ut_czyh,	医生代码
	@idm ut_xh9,	药idm
	@ypdm ut_xmdm,	药品代码或项目代码
	@yfdm ut_ksdm,	执行科室代码
	@fylb smallint,	同病人费用明细库的fylb字段
	@fyly smallint,	0=YK_YPCDMLK, 1=YY_SFXXMK
	@ypdw ut_unit,	药品单位
	@dwxs ut_dwxs,	单位系数
	@zxsl ut_sl10,	执行数量
	@txbz smallint,	特需标志0=普通，1=特需
	@errmsg varchar(50) output,
	@xmdj money = null,			项目单价(项目单价为0时或@tfbz=2)
	@yzxh numeric(12,0) = null,	医嘱序号
	@qqxh numeric(12,0) = null,	请求序号
	@qqrq varchar(16) = null,	请求日期
	@yexh ut_syxh = null,		婴儿序号
	@tfbz smallint = 0,			退费标志0=正常，1=作废，2=退费
	@tfxh ut_xh12 = null		退费序号(@tfbz=1)
	@ykxs ut_dwxs,				药库系数
	@memo ut_memo,				备注信息
	@zfdj money=null,			自费单价
    @shbz ut_bz,                审核标志
    @spbh ut_mc32,              审批编号 
	@jfsj ut_rq16=null			记费时间
    @lcxmdm ut_xmmd                         临床项目代码
	@lcxmmc ut_mc64                         临床项目名称
	@pcxh ut_xh12=0				批次序号
	@tm	ut_mc64=''				条码
	,@sfxdzf  ut_bz=0 --收费限定支付标志  0否 1是
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]
[修改纪录]
tony 2003.8.21 修改了医保分类自负部分
chenwei 2003.11.7 添加传入参数zfdj,退费时按原自费单价计算医保分类自负金额
Modify By : Koala In : 2005-01-24	For 福州需求，增加床位限额
mit ,2oo4-12-21,保存txbl
modify by wxp 2005-02-18 copy by mly   修改婴儿分类自负金额为0
			  2005-03-13 处理博爱医院病人结算要求超过定额后全部自费
modify by mly 2005-04-12 增加确认科室的传入
Modify By : Koala	In : 2005-09-11	For :福州省立需求,欠费控制方案修改,增加@ispreqf ut_bz = 0	 --Koala	2005-08-11	是否确费预算
Modify By : tony	In : 2005-10-25	For :ypmc改为ut_mc64
Modify by : gujun	In : 2005-12-27	For :增加医疗小组模式.详见概要设计.
Modify by : ydj		In : 2006-3-22	For : 增加保存BQ_YJFYQQK 中分xh到ZY_BRFYMXK 
Modify by : sunyu	In : 2006-4-18	For :增加儿保病人乙类药品不按全额计入flzfje的处理
modify by gzy at 20060809 for: 对儿保病人只插入zfje，不插入flzfje
Modify By : Koala	In : 2006-11-08	For :开发序号 13730 福州省立需求,将医疗组的赋值放到前面处理，并增加@@error的判断 
Modify By : Koala	In : 2007-01-15	For :开发序号 14347 江西二院需求,如使用医疗组，控制医疗组为空时不允许确费
   xwm  2011-07-29 要保证退费单价放在最后面设置以免给其它情况给冲掉了
yjf 2013-06-04 确费时自动扣除物资材料库存  
Modify By : wyh	In : 2014-04-24	For :开发序号 196585 
**********/
set nocount on

declare @lsjms	ut_bz	  --零售价模式，3为多零售价模式
select @lsjms = dbo.f_get_ypxtslt() --add by shiyong 2012-04-08 获取零售价模式
--多零售加的药品确费
if (@lsjms=3 and @idm>0) and (@dyly<>1)		-- 补记账作废药品无发药无多零售模式
begin
	exec usp_zy_brqf_dpc @syxh,@czyh,@ysdm,@idm,@ypdm,@yfdm,@fylb,@fyly,@ypdw,@dwxs
		,@zxsl,@txbz,@errmsg output,@xmdj,@yzxh,@qqxh,@qqrq,@yexh,@tfbz,@tfxh
		,@ykxs,@memo,@zfdj,@shbz,@spbh,@jfsj,@kl,@bljsbl,@jzjsbl
		,@lcxmdm,@lcxmmc,@zxmdm,@xedj,@qrksdm,@tdxmxh,@ispreqf,@yjmxxh
		,@ybqdm,@yksdm,@fymxxh_out output,@qfzfyy,@cq_fjxm,@jzks_qf,@gdzxbz
		,@txbl_hg,@sbid_qf,@jzys_qf,@num,@cth,@xxh,@mrih,@bch
		,@wkdz,@yzlb,@sffy,@zxlb,@yfyzje,@fyfzxh,@zyfymxxh1,@ssbl_qf,@jsks_qf,@jzbq_qf,@szbdj,@sfxdzf
	return								  
end	

declare @config7245 varchar(2)
select @config7245='否'
if @lsjms in(0,1,2)
begin
     select @config7245=config from YY_CONFIG(nolock) where id='7245'
end
	
--以下非多零售价模式
select @jzks_qf=ltrim(rtrim(@jzks_qf)),@jzys_qf=ltrim(rtrim(@jzys_qf)),@jzbq_qf=ltrim(rtrim(@jzbq_qf))
declare @hzxm varchar(64),
		@ybdm	ut_ybdm,		--医保代码
		@now	ut_rq16,		--当前时间
		@zfbz	smallint,		--比例标志
		@tybqdm	ut_ksdm,	--退药病区代码	-- add by gzy at 20041208
		@bqdm	ut_ksdm,		--病区代码
        @tyksdm	ut_ksdm,
		@ksdm	ut_ksdm,		--科室代码
		@ypdj	ut_money,		--药品单价
		@sxjg	ut_money,		--上限价格
--		@zfdj	ut_money,		--自费单价
		@yhdj	ut_money,		--优惠单价
--		@ykxs	ut_dwxs,		--药库系数
		@zfbl	ut_zfbl,		--自费比例
		@yhbl	ut_zfbl,		--优惠比例
		@txbl	ut_zfbl,		--特需比例
		@dxmdm	ut_kmdm,		--大项代码
		@zje	ut_money,		--项目金额
		@zfje	ut_money,		--自费金额
		@yhje	ut_money,		--优惠金额
		@flzfje ut_money,	--分类自负金额
		@flzfbz ut_bz,		--分类自负标志
		@yeje	ut_money,		--婴儿金额
		@srce	numeric(16,4), --舍入差额
		@fyce	numeric(16,4),	--费用差额，为了计算部分退费时第一次的费用差额，补齐收费时对应的差额
		@ypmc	ut_mc64,		--药品名称
		@ypgg	ut_mc32,		--药品规格
		@jsxh	ut_xh12,		--结算序号
		@old_ykxs	ut_dwxs,	--老的药库系数
		@old_zfdj	money,	--老的自费单价
		@cwdm	ut_cwdm,		--床位代码
		@dffbz	ut_bz,		--单复方标志
		@czyks	ut_ksdm,     --操作员科室（确认科室）
		@djrq	ut_rq16
		,@zrysdm	ut_czyh    --主任医生代码
		,@zzysdm	ut_czyh    --主治医生代码
		,@age	numeric
		,@xh_temp	ut_xh12
		,@pzlx	ut_dm2
		,@yjbj	ut_money
		,@isusebj	char(4)
        ,@ysks_temp	ut_ksdm  --医生科室
        ,@czybq_temp	ut_ksdm   --操作员病区
		,@gbbz	ut_bz		--干保标志
		,@gbfwje	ut_money	--干保范围内金额
		,@gbfwwje	ut_money	--干保范围外金额
		,@gbtsbz	ut_bz		--干保特殊标志
		,@gbtsfwje	ut_money	--干保特殊范围金额
		,@gbtsfwwje ut_money	--干保特殊范围外金额
		,@gbtsbl	ut_zfbl	--干保特殊自负比例
        ,@gbzfbl_tf ut_zfbl    --干保退费自费比例
		,@ylxzdm	ut_ksdm	--医疗小组代码
		,@fzrysdm	ut_czyh   --付主任医生代码
		,@flzfbl	ut_zfbl	--分类自负比例
		,@flzfdj	ut_money	--分类自负单价
		,@yzshkz	CHAR(4)	--开关5223 出院结算是否使用医嘱审核功能	add by gzy in 20061215
		,@jskzbz	ut_bz	--结算审核控制标志	add by gzy in 20061215
		,@yzshbz	ut_bz	--医嘱审核标志		add by gzy in 20061215
		,@isuseylz  char(4)
		,@dydm		varchar(32)      --YK_YPCDMLK或YY_SFXXMK里的dydm，即医保系统中药品与小项目的代码 add 20070119
		,@lcjsdj	ut_money    	--ZY_BRFYMXK .lcjsdj
		,@lcyhje	ut_money	--ZY_BRJSMXK .lcyhje 
		,@xzks_id	ut_ksdm    --行政科室代码 
		,@yyhdj		ut_money    --原优惠单价
		,@flzfje_is3  varchar(2) --分类自付金额是否保留3位小数？
		,@cwtxbz	ut_bz        --特需标志 ZY_BCDMK.txbz
		,@yzczh		ut_mc64    --医保药品项目注册号  --add by cyh 2012-06-19
		,@config6623	varchar(2),
		@config6661		varchar(10),
		@config6809		varchar(2), --add by hhy 是否使用逻辑病区
        @config6A21		VARCHAR(2), --add by cyh （石河子单独流程）费用记账医保已审核是否必须满足ZY_BRJSK.shbz=1且ZY_BRSYK.ybjsbz=1（默认为否）
        @brybjsbz		ut_bz       --add by cyh 病人一般结算标志ybjsbz（0-未结算，1-已结算）
        ,@config9177	varchar(2)-- 需求74281 常山县人民医院医技退费问题 医技退费是否可以修改时间
		,@sfxmmrsx		int --收费项目每日收费上限
		,@config6A33	char(1)
		,@config6B01	varchar(2)
		,@config6B06	varchar(2)
		,@etjsb			ut_zfbl
		,@txdj			ut_money
		,@djjsbz		INT
		,@yzxrq        VARCHAR(16)  ---原执行日期
		,@etjsje ut_money  --儿童加收金额
		,@etjsbz ut_money  --儿童加收标志
		,@config6B96 int   --（浙江）启用儿童就诊项目加价流程的儿童年龄
		,@config6B60 int   --启用儿童就诊项目加价模式
	    ,@now_time   varchar(19) --当前时间time格式 2017-12-26 08：56：00
		,@djrq_time  varchar(19) --结算时间time格式 2017-12-26 08：56：00
		,@pkdj		 ut_bz		--贫困等级  YY_PKRKXXB.pkdj
		,@pk_yhbl	 ut_zfbl	--优惠比例  YY_PKSFXMK.yhbl

--获取参数
-- 5188 by ydj 20050411 增加控制报警线为博爱医院
select @now=convert(char(8),getdate(),112)+convert(char(8),getdate(),8)
select @isusebj=isnull(config,'否') from  YY_CONFIG (nolock)where id='5188'
--add by hhy 是否使用逻辑病区
select @config6809 = isnull(config,'否') from YY_CONFIG(nolock) where id = '6809'
select @flzfje_is3 = config from YY_CONFIG (nolock) where id='5241'
if isnull(@flzfje_is3,'') = '' 
	select @flzfje_is3 = '否'
select @config6623=isnull(config,'否') from YY_CONFIG (nolock) where id='6623'  
-- add by gzy in 20061215 判断出院结算是否要审核医嘱，如果要则判断结算库中的kzbz（控制标志）控制标志 0 未控制(不允许改变费用), 1 控制(允许改变费用)
SELECT @yzshkz=ISNULL(config,"否") FROM YY_CONFIG (nolock)WHERE id="5223"
SELECT @config6A21= isnull(config,'否') from YY_CONFIG(nolock) where id = '6A21'
SELECT @config6A21= isnull(@config6A21,'否')
select @config6661=config from YY_CONFIG(nolock) where id='6661' 
select @config9177=isnull(config,'否') from YY_CONFIG(nolock) where id='9177'
select @config6A33=isnull(config,'0') from YY_CONFIG(nolock) where id='6A33'
SELECT @config6A33= isnull(@config6A33,'0')
select @config6B01=isnull(config,'否') from YY_CONFIG(nolock) where id='6B01'
SELECT @config6B01= isnull(@config6B01,'否')
select @config6B06=isnull(config,'否') from YY_CONFIG(nolock) where id='6B06'
select @config6B06= isnull(@config6B06,'否')
select @config6B60=convert(int, isnull(config,'0')) from YY_CONFIG (nolock) where id='6B60'
--浙江省儿童就诊部分项目加价收取-住院病人确费改造
select @config6B96=convert(int, isnull(config,'0')) from YY_CONFIG (nolock) where id='6B96'  
if @config6B96 < 0
   select @config6B96 = 0

--基本信息判断
select @bqdm=bqdm, @ksdm=ksdm, @ybdm=ybdm, @cwdm=cwdm,@yjbj=yjbj,@gbbz=isnull(gbbz,0) 
	,@hzxm = hzxm,@brybjsbz=ISNULL(ybjsbz,0) 
from ZY_BRSYK (nolock)	--增加干保标志
where syxh=@syxh and brzt not in (3,8,9)
if @@rowcount=0
begin
	select @errmsg='F没有该病人信息！'
	return
end

select @pzlx=pzlx from YY_YBFLK (nolock)where ybdm=@ybdm
if @@rowcount=0 
begin
	select @errmsg='F医保类型没有进行匹配'
	return
end		

if exists (select 1 from ZY_BRSYK (nolock) where syxh=@syxh and gzbz=1)  ---已挂账病人
begin
	select @errmsg= 'F'+@cwdm+'床病人【'+@hzxm+'】已挂账,不能记账!'
	return
end		

if exists(select 1 from ZY_BRSYK(nolock) where syxh=@syxh and bqdm=@bqdm)  
    select @zzysdm=a.zzysdm,@zrysdm=a.zrysdm,@fzrysdm=a.fzrysdm,@ylxzdm=a.id 
	from BQ_YS_YLZXX a(nolock),ZY_BRSYK b(nolock) where a.id=b.ylzdm and b.syxh=@syxh
else
    select @zzysdm=a.zzysdm,@zrysdm=a.zrysdm,@fzrysdm=a.fzrysdm,@ylxzdm=a.id 
    from BQ_YS_YLZXX a (nolock),BQ_BRZKQQK b (nolock) 
    where a.id=b.yylxzid and b.syxh=@syxh and b.bqdm=@bqdm and b.jlzt<>2
if @@error<>0 
begin
	select @errmsg='F取病人医疗组信息失败，请于系统管理员联系！'
	return	
end

--如使用医疗组，如为空，则不允许确费
select @isuseylz ='否'
select @isuseylz = isnull(config,'否') from YY_CONFIG(nolock) where id ='6237'
if @@error<>0 
begin
	select @errmsg='F取医疗组设置出错！'
	return	
end

if @isuseylz = '是'
begin
	if isnull(@ylxzdm,'') = ''
	begin
		select @errmsg='F病人医疗组信息为空，请重新维护后再收费！'
		return	
	end

	if isnull(@ylzdm,'')<>''
		select @ylxzdm=@ylzdm

	if exists (select 1 from BQ_YS_YLZXX where id=@ylxzdm and isnull(jlzt,0)<>0)
	begin
		select @errmsg='F病人医疗小组已停止，请重新维护后再收费！'
		return	
	end
end

--满足条件：必须是类别 = 6 +正常录入+数量小于0+ 参数配置存在
if (ltrim(rtrim(@isusebj))='是') and (@zxsl < 0) and (@fylb=6 ) and (@tfbz = 0)
begin
	select @errmsg='F参数5188=“是”所以不允许录入负数，请用作废功能'
	return
END

if exists (select 1 from ZY_BRJSK (nolock)where syxh=@syxh and jlzt=0 and ybjszt=1)
begin
	select @errmsg= "F该病人正在结算!不能记帐!"
	return
end

SELECT @jskzbz=kzbz, @yzshbz=shbz FROM ZY_BRJSK (nolock)WHERE syxh=@syxh AND jlzt=0
IF (@yzshkz="是") AND (@jskzbz=1)
BEGIN
	SELECT @errmsg= "F该病人正在出院处审核!不能记帐!"
	RETURN
END
if (@config6A21='是')
begin
	IF(@yzshbz=1) AND(@brybjsbz=1)
	BEGIN
		SELECT @errmsg= "F出院处已审核该病人的费用!不能记帐!"
		RETURN
	END
end
else 
begin
	IF (@yzshkz="是") AND (@yzshbz=1)
	BEGIN
		SELECT @errmsg= "F该病人的所有医嘱已审核!不能记帐!"
		RETURN
	END
end
if exists(select 'x' from YY_CONFIG where id ='6A44' and config='是')
begin
	if exists(select 1 from ZY_BRFYMXK a (nolock) where a.syxh=@syxh and a.xh=isnull(@tfxh,0) and a.ybscbz=1 )
	begin
		select @errmsg='F部分费用已上传，请撤销后再做修改！'
		return
	end
end

if @jfsj is not null
begin
	select @djrq=ksrq from ZY_BRJSK (nolock)where syxh=@syxh and jszt=0 and ybjszt=0 and jlzt=0
	if @@error<>0 or @@rowcount=0
	begin
		select @errmsg='F病人当前结算记录不可用，请于系统管理员联系！'
		return	
	END
	
select @now_time=CONVERT(VARCHAR(10),GETDATE(),120)+' '+convert(char(8),getdate(),8)
select @djrq_time=case when len(ltrim(rtrim(isnull(@djrq,''))))=16 then 
                 	substring(@djrq,1,4)+'-'+substring(@djrq,5,2)+'-'+substring(@djrq,7,2)+' '+substring(@djrq,9,8) 
                 ELSE @djrq END
                 	
	if @jfsj<@djrq
	begin
		--select @errmsg='F不能补病人结算前的帐！'
		select @errmsg='F不能补病人结算'+@djrq_time+'时间前的帐！'
		return	
	end
	if @jfsj>@now
	begin
		--select @errmsg='F不能补当前时间后的帐！'
		select @errmsg='F不能补'+@now_time+'时间后的帐！'
		return	
	end
end


 --[▲fylb 费用类别(0：临时医嘱生成 1：长期医嘱生成 3：医技生成 4：固定费用 5：退药生成 
                                --              6：非医嘱项目录入时生成(收费), 此类可以直接作废)
                                --              7：手术费用(包括麻醉处方、麻醉费用)
                                --              8：出院带药 9：婴儿费用(母婴同床的时候，婴儿费用fylb=9)
                                --              10：小处方生成 11：其它 12：草药]

if @fylb=3 --3：医技生成
begin
	if ((@yfdm='') or (@ysdm is null))
	begin
		select @ysdm = ysdm from BQ_YJQQK(nolock) where xh=@qqxh
	end
end

if (@isuseylz = '是') and (@config6B01='是') and ((@fylb=0)or(@fylb=1))
	select @ysdm=@zrysdm

select @old_ykxs=@ykxs,@old_zfdj=isnull(@zfdj,0)
select @gbbz=0, @gbfwje=0, @gbfwwje=0, @gbtsbz=0, @gbtsfwje=0, @gbtsfwwje=0,@lcjsdj =0,@lcyhje = 0
	,@yyhdj = 0
--红会增加 医生当时科室（可能以后会转科），操作员所在病区
select @ysks_temp=ks_id from YY_ZGBMK(nolock) where id =@ysdm
--10970 201810补丁优先  住院退费退药时，病人费用明细库中医生科室代码为NULL（ZY_BRFYMXK.ysks）
if(isnull(@ysks_temp,'')='') and isnull(@tfxh,0)<>'0'
begin
	select @ysks_temp=ysks from ZY_BRFYMXK where xh=@tfxh
end
-- add by cyh for 146486  按小时收费的项目退费修改
--select @czybq_temp=bq_id from YY_ZGBMK (nolock)where zglb=2 and id in (select zgbm from czryk(nolock) where id =@czyh)
select @czybq_temp=a.bq_id from YY_ZGBMK a (nolock) where a.zglb=2 and exists(select 1 from  czryk b(nolock) where a.id=b.zgbm and b.id=@czyh)

--复旦大学附属眼耳鼻喉科医院增加特需标志
select @cwtxbz=isnull(txbz,0) from ZY_BCDMK(nolock) where syxh=@syxh 
if not exists(select 1 from YY_CONFIG (nolock)where id='6383' and config='是')
begin
	if not exists(select 1 from YY_CONFIG (nolock)where id='6384' and config='是')
	    select @cq_fjxm=0
end

if @qqrq is null
	select @qqrq=@now
if  (select config from YY_CONFIG (nolock)where id='6242')='是'  
	if @fylb=1 
		select @qqrq=zxrq from BQ_CQYZK (nolock)WHERE xh=@yzxh

--判断当前的ZY_BRJSK中ybjszt=0的xh是否和ZY_BRFYMXXMK中的jsxh一致，如果不一致，则不能红冲，如果一致，则可以红冲。
if (@tfbz=1) and (exists (select 1 from YY_CONFIG (nolock)where id='5231' and config='否'))   
begin  
    if not exists (select 1 from ZY_BRJSK a (nolock),ZY_BRFYMXK b (nolock)  
					where a.syxh=@syxh and a.jlzt=0 and a.ybjszt=0 and a.xh=b.jsxh and b.syxh=a.syxh and b.xh=@tfxh)  
    begin  
		select @errmsg= "F病人中途结帐的费用不允许红冲!"  
		return  
    end  
end 


if @ybqdm is not null
select @bqdm=@ybqdm
if @yksdm is not null
select @ksdm=@yksdm
if @idm>0
	select @fyly=0
else
begin
	select @fyly=1
end

--add by kongwei for  96509 现改成在前台录入时控制
--select @sfxmmrsx = ISNULL(mrsxsl,0),@ypmc=name from YY_SFXXMK (nolock) where id =@ypdm 
--if @sfxmmrsx > 0 
--begin
--	if (@zxsl > @sfxmmrsx or exists(select 1 from ZY_BRFYMXK a(nolock) where a.syxh =@syxh and ypdm =@ypdm and SUBSTRING(qqrq,1,8)=SUBSTRING(@now,1,8)
--		group by syxh,ypdm,SUBSTRING(qqrq,1,8) having SUM(ypsl)+@zxsl > @sfxmmrsx)) 
--	begin
--		select @errmsg='F病人当日【'+@ypmc+'】计费数量已经超过上限！'
--		return
--	end
--end

if @config9177 = '是' 
begin 
	if isnull(@zxrq_xg,'') = ''
	select @zxrq_xg = @now
end 

IF ISNULL(@tfxh,0)>0
BEGIN
	SELECT TOP 1 @yzxrq=zxrq FROM ZY_BRFYMXK(nolock)  WHERE syxh=@syxh AND ISNULL(yexh,0)=ISNULL(@yexh,0) AND xh=@tfxh
END
else begin
   select @yzxrq=@now
end


if @tfbz=1 --▲▲▲1=作废  start ▲▲▲
begin
	---add by cyh 更新注册证号  需求:118862
	if exists(select 1 from ZY_BRFYMXK a (nolock) where a.syxh=@syxh and a.xh=@tfxh and a.jlzt=0  and idm=0 )
	begin
		update a  set a.yzczh=c.item_previousidl
		from ZY_BRFYMXK  a,YY_SFXXMK b,YY_YBXMK c
		where  a.ypdm=b.id and b.sybz=1 and  a.syxh=@syxh and a.xh=@tfxh and a.jlzt=0 
			and b.dydm=c.item_code and a.idm=0 and isnull(a.yzczh,'')<>''
		if @@error<>0 
		begin
			select @errmsg='F更新医保注册证号时出错！'
			return
		end  
	end	        
	else 
	begin
		update a  set a.yzczh=c.previousidl
		from ZY_BRFYMXK  a,YK_YPCDMLK b,YY_YBYPK c
		where  a.idm=b.idm and b.tybz=0 and a.syxh=@syxh and a.xh=@tfxh and a.jlzt=0  
			and b.dydm=c.mc_code and a.idm>0 and isnull(a.yzczh,'')<>'' 
  		if @@error<>0
		begin
			select @errmsg='F更新医保注册证号时出错！'
			return
		end          
	end       
               
	update ZY_BRFYMXK set jlzt=1,zfyy=@qfzfyy,
		@zje=-zje,
		@zfje=-zfje,
		@yhje=-yhje,
		@flzfje=-flzfje,
		@dxmdm=dxmdm,
		@yeje=(case when @fylb=9 or @yexh>0 then -zfje else 0 end),
		@gbtsbz =gbtsbz,
		@gbfwje =-gbfwje,
		@gbfwwje =-gbfwwje
		,@lcjsdj =-isnull(lcjsdj,0)
		,@lcyhje = case when lcjsdj <> 0 then -(round(zje,2) - round(lcjsdj*ypsl/ykxs, 2)) else 0 end 		
		where syxh=@syxh and xh=@tfxh and jlzt=0
	if @@error<>0 or @@rowcount=0
	begin
		select @errmsg='F病人确费时出错！'
		return
	end

	select @srce = -srce,@sfxdzf=ISNULL(sfxdzf,0) from ZY_BRFYMXK_FZ(nolock) where syxh=@syxh and xh=@tfxh 
	if @gbtsbz=1
		select @gbtsfwje=@gbfwje, @gbtsfwwje=@gbfwwje
end --▲▲▲1=作废  end ▲▲▲
else 
begin --▲▲▲0=正常 or 2=退费 start ▲▲▲
	select @zfbz=zfbz from YY_YBFLK (nolock)where ybdm=@ybdm

	if @fyly=0 --◆药品 start
	begin
	   	--select @ypdj=ylsj  处理药品单价为0 zhouyi 201311.20
		 select @ypdj=case when ylsj=0 then isnull(@xmdj,0) else ylsj end, @ykxs=ykxs, @zfbl=zyzfbl, @yhbl=0, @txbl=1, @dxmdm=yplh, @ypmc=ypmc,  
				@ypgg=ypgg, @sxjg=sxjg, @flzfbz=zyflzfbz,@dffbz=isnull(dffbz,0),@flzfbl=zyzfbl,
				@dydm=dydm,@lcjsdj = isnull(lcjsdj,0) --add 20070119
			from YK_YPCDMLK (nolock) where idm=@idm
		if @@error<>0 or @@rowcount=0
		begin
			select @errmsg='F产地idm为'+convert(varchar(9),@idm)+'的药品不存在！'
			return
		end

		if (@config7245='是') 
		begin
			select @ypdj=dbo.FUN_GETCEIL(b.ylsj,2) 
			from YK_YPCDMLK b(nolock)  inner join YY_SFDXMK c(nolock) on b.yplh=c.id
			where b.idm=@idm and c.ypbz=3  --只针对草药
		end

		--退费走负数的流程
		if @zxsl<0 
		begin
		     select @ypdj=case @xmdj when 0 then @ypdj else @xmdj end
		end

		--如果不享受则零差单价= 0 
		if exists(select ybdm from YY_YBFLK (nolock) where ybdm = @ybdm and lcyhbz = 0)
			select  @lcjsdj = 0
		select @tybqdm= (case when kslb = 1 then @bqdm else bqdm end), --mod by hhy 2014.08.27 for 2218 手术室退药的话，bqdm应该写病人所在病区的
		           @tyksdm=ksdm from BQ_BRTYD(nolock) 	-- add by gzy at 20041208 增加退费原科室
			where xh in (select tyxh from BQ_BRTYMX (nolock)where syxh = @syxh AND qqxh = @qqxh) AND yfdm = @yfdm
		if @@error<>0
		begin
			select @errmsg='F读取单据病区代码出错！'
			return
		end
	end --◆药品 end
	else 
	begin --◆项目 start
		select @ypdj=(case when @config6661=@ypdm then(select xmdj from ZY_BRFJGDXMK (nolock) where syxh=@syxh and xmdm=@config6661) else 
							(case when @config6623='是' then (select dbo.fun_getjjcl(@ypdm,xmdj))else xmdj end )
						end), 
			@ykxs=1, @zfbl=zyzfbl, @yhbl=yhbl, @txbl=txbl, @dxmdm=dxmdm, @dwxs=1, 
			@ypmc=name, @ypgg=xmgg, @ypdw=xmdw, @sxjg=sxjg, @flzfbz=zyflzfbz,@dffbz=0,@flzfbl=zyzfbl,@dydm=dydm --add 20070119
			,@etjsb=isnull(etjsb,0),@etjsje=etjsje,@etjsbz=etjsbz
		from YY_SFXXMK (nolock) where id=@ypdm
		if @@error<>0 or @@rowcount=0
		begin
			select @errmsg='F项目代码为'+@ypdm+'的项目不存在！'
			return
		end
		select @ypdj=@ypdj*sfbl,@lcxmdj=case when isnull(@lcxmdj,0)=0 then isnull(xmdj,0) else @lcxmdj end
		from YY_LCSFXMK(nolock) 
		where id=@lcxmdm and @lcxmdm<>'0' and sfbl>0

--		if (@xmdj is not null) and (@xmdj <> 0)
--			select @ypdj = @xmdj 

		if (@xedj <> 0) and (@xedj is not null)
			select @ypdj = @xedj
			
		if @ypdj=0
			select @ypdj=isnull(@xmdj,0)
			
		--add by guo for 物资单价(恩施医院专用)
        --if (select config from YY_CONFIG (nolock) where id='6714')='否'	
	    --begin
          IF isnull(@wzdj,0)<>0 
            SELECT  @ypdj=ISNULL(@wzdj,0)
        --end
         --add by xhy for 物资单价(恩施医院专用)
          if (select config from YY_CONFIG (nolock) where id='8129')='否'	 
	    begin
	      IF isnull(@wzdj,0)<>0 
               SELECT  @ypdj=ISNULL(@wzdj,0)
	    end
	    
	    if @etjsbz = 1 and @config6B96 > 0 and @config6B60 = 2
	    begin
	        if exists(select 1 from ZY_BRSYK where syxh = @syxh 
				--and (case when isnull(birth,'')='' then 0 else datediff(year,convert(datetime,birth),getdate()) end) <= @config6B96 
				--假设6B96=6，那么6周01天在datediff(year,convert(datetime,birth),getdate())判断时也是6，实际上超过6周哪怕1天也算大于6周
				--因此再增加判断，年龄-1天时要＜6，这样就不会把6周01天算进去了，只会判断0-6周的婴儿
				and (cast(convert(char( 8 ),getdate(),112) as int) - cast(convert(char( 8 ),convert(datetime,birth),112) as int))/10000 <= @config6B96 
				and (cast(convert(char( 8 ),getdate(),112) as int) - cast(convert(char( 8 ),dateadd(dd,1,convert(datetime,birth)),112) as int))/10000 < @config6B96 
				)
	        --启用儿童就诊项目加价流程的儿童年龄,小于参数值且不为0时走该流程
	        begin
	            SELECT  @ypdj=@ypdj + @etjsje
	        end
	    end

		if @yfdm is null or @yfdm=''   -- 没有执行科室的项目把病人科室当作执行科室
			select @yfdm=@ksdm
	end --◆项目 end		

	--W20050313 特殊收费项目中增加上限价格,作用是针对特殊病人的上限价格设置.
	--顺序:先执行收费小项目中的上限价格,再覆盖执行特殊收费项目中的上限价格
	if @fyly = 0 
		select @sxjg = isnull(sxjg,0) from YY_TSSFXMK (nolock)where idm= @idm and ybdm = @ybdm
	else
		select @sxjg = isnull(sxjg,0) from YY_TSSFXMK (nolock)where xmdm= @ypdm and ybdm = @ybdm

	if @old_ykxs is not null
		select @ykxs=@old_ykxs

	if @txbz=0
		select @txbl=1

    if @gdzxbz=2   --出区费用回滚时，因为无法找特需标志，所以直接使用传进来的比例
        select @txbl=@txbl_hg

	--select @ypdj=@ypdj*@txbl

	--Lexus , 2004-07-28 , 14岁以下儿童加收20%,读特需比例！
	if (select config from YY_CONFIG (nolock) where id='5172')='是'	--[广州红会]住院病人小于14岁是否加收检查费和治疗费 为 是 start
	begin
		if @fyly<>0
		begin
			if exists(select 1 from ZY_BRSYK (nolock)where --yxp datediff(year,convert(datetime,birth),getdate())<=14 and syxh=@syxh)
				(case when isnull(birth,'')='' then 0 else datediff(year,convert(datetime,birth),getdate()) end)<=14 and syxh=@syxh)
				select top 1 @txbl=txbl*@txbl from YY_TSSFXMK (nolock)WHERE xmdm=@ypdm and ybdm=@ybdm
		end

		if @txbl<1
			select @txbl=1

		select @ypdj=@ypdj*(@txbl-1)+@ypdj*(@jzjsbl-1)+@ypdj*@kl

	end 	--[广州红会]住院病人小于14岁是否加收检查费和治疗费 为 是 end
	else
	begin 	--[广州红会]住院病人小于14岁是否加收检查费和治疗费 为 否 start
		if @txbz=0
			select @txbl=1

		if @gdzxbz=2   --出区费用回滚时，因为无法找特需标志，所以直接使用传进来的比例
			select @txbl=@txbl_hg
		select @ypdj=@ypdj*@txbl
	end 	--[广州红会]住院病人小于14岁是否加收检查费和治疗费 为 否 end
	--年龄大于28天小于6岁的病人是否按照儿童加收比来计费
	if (@fyly<>0) 
	begin
		if @config6B60=1 
		begin
			if exists(select 1 from ZY_BRSYK (nolock) where syxh=@syxh 
					and (case when isnull(birth,'')='' then 0 else datediff(year,convert(datetime,birth),getdate()) end)<6	--小于6岁
					and (case when isnull(birth,'')='' then 0 else datediff(day,convert(datetime,birth),getdate()) end)>28 --大于28天
				)
				select @ypdj=@ypdj*(1+@etjsb)
		end
	end
	-- swx 2015-7-31 for 36039 苏州儿童医院+护士记账
	if @fylb<>9	-- 大人或分床婴儿
	begin
		if (@fyly<>0) 
			and exists(select 1 from ZY_BRSYK (nolock) where syxh=@syxh 
				and (case when isnull(birth,'')='' then 0 else datediff(year,convert(datetime,birth),getdate()) end)>6)
			and exists(select 1 from YY_SFXXMK (nolock) where id=@ypdm and ekbz=1)
		begin
			select @errmsg='F儿科标志的小项目6岁以上患者不允许使用！'
			return
		end	
	end
	else
	begin
		if (@fyly<>0) 
			and exists(select 1 from ZY_BABYSYK (nolock) where xh=@yexh 
				and (case when isnull(birth,'')='' then 0 else datediff(year,convert(datetime,substring(birth,1,8)),getdate()) end)>6)
			and exists(select 1 from YY_SFXXMK (nolock) where id=@ypdm and ekbz=1)
		begin
			select @errmsg='F儿科标志的小项目6岁以上患者不允许使用！'
			return
		end	
	end
	
	--要保证退费单价放在最后面设置以免给其它情况给冲掉了  mod by xwm  2011-07-29
	if @tfbz=2 
		select @ypdj=@xmdj
	-- swx 2014-12-4 for 9804 上海天佑医院  病区护士站   医嘱执行项目翻倍
	if exists(select 1 from YY_CONFIG(nolock) where id='6872' and config='是')
	begin 
		if exists(select 1 from YY_CONFIG(nolock) where id='G073' and config='')
			and exists(select 1 from YY_TSSFXMK (nolock) WHERE xmdm=@ypdm and ybdm=@ybdm and idm=0 and @idm=0) -- 存在@idm=0、xmdm=@ypdm的特殊收费项目
			and exists(select 1 from ZY_BCDMK where id =(select cwdm from ZY_BRSYK where syxh=@syxh) and isnull(txbz,0)<>1 -- 8555 床位项目的如果设置了特需标志的不走此流程。
				and bqdm=@bqdm ) 
			and exists(select 1 from YY_CONFIG (nolock) where id='5172' and config='否')	--5172为是时不走此流程
			and exists(select 1 from YY_SFXXMK (nolock) where id=@ypdm and @idm=0 and xmdj<>0) --xmdj=0的自定义单价项目不走此流程
			and exists(select 1 from YY_YBFLK yb(nolock) inner join ZY_BRSYK sy(nolock) on sy.ybdm=yb.ybdm where sy.syxh=@syxh and yb.ybdm=@ybdm and yb.zfbz=3) 		 
		begin
			select @txbl=txbl from YY_TSSFXMK (nolock) WHERE xmdm=@ypdm and ybdm=@ybdm and idm=0
			if @txbl is null
			begin
				select @errmsg='F特殊收费项目基础数据维护不正确！'
				return
			end
			select @ypdj=@ypdj*@txbl
		end
	end
	--是否启用广州现代医院确费模式
	if exists(select 1 from YY_CONFIG (nolock) where id='6B64' and config='是')
	begin
		if exists(select 1 from YY_TSSFXMK (nolock) WHERE ybdm=@ybdm 
			and ((@idm=0 and xmdm=@ypdm and idm=0)or(@idm>0 and idm=@idm)) 
			)
		begin
			select @djjsbz=isnull(djjsbz,0),@txdj=txdj,@txbl=txbl 
			from YY_TSSFXMK (nolock) 
			WHERE ybdm=@ybdm
				and ((@idm=0 and xmdm=@ypdm and idm=0)or(@idm>0 and idm=@idm)) 
			if @djjsbz=1
				select @ypdj=@txdj
			else
				select @ypdj=@ypdj*isnull(@txbl,1)
		end
	end
	--add by kongwei for 317278 扶贫政策改造
	if exists(select 1 from YY_PKRKXXB a inner join ZY_BRSYK b(nolock) on a.sfzh=b.sfzh and b.syxh=@syxh where a.jlzt=1 and a.shbz=1 and a.mzzybz in (0,2) )
	begin
		--现获取贫困等级  为了获取优惠比例计算优惠后ypdj
		select @pkdj=a.pkdj from YY_PKRKXXB a 
		inner join ZY_BRSYK b(nolock) on a.sfzh=b.sfzh and b.syxh=@syxh 
		where a.jlzt=1 and a.shbz=1 and a.mzzybz in (0,2)
		--获取优惠比例
		select @pk_yhbl=isnull(a.yhbl,1)
		from YY_PKSFXMK a
		where a.idm=@idm and a.xmdm=@ypdm and a.pkdj=@pkdj and xtbz=1
		--计算优惠后ypdj
		select @ypdj=@ypdj*isnull(@pk_yhbl,1)
	end

	if @memo='6951流程,一天只收一次'
	begin
		select @ypdj=0
	end
	--add by Wang Yi, 2003.03.07，婴儿医嘱也归到婴儿费用中
	if @yexh > 0 and @fylb in (0,1)
		select @fylb = 9

	if @fylb=9 or @yexh > 0		--婴儿费用全自费
		select @yhbl=0, @zfbl=1
	else if @zfbz=0
		select @yhbl=0
	else if @zfbz=2 
	begin
		select @yhbl=0
		if @idm > 0
			select @zfbl=zfbl,@flzfbl=zfbl from YY_TSSFXMK (nolock)
				where idm=@idm and ybdm=@ybdm
		else
			select @zfbl=zfbl,@flzfbl=zfbl from YY_TSSFXMK (nolock)
				where idm=@idm and xmdm=@ypdm and ybdm=@ybdm

		if @@error<>0
		begin
			select @errmsg='F计算费用时出错！'
			return
		end
	end
	else if @zfbz=3
	begin
		if @idm > 0
			select @zfbl=0,@yhbl=yhbl from YY_TSSFXMK (nolock)
				where idm=@idm and ybdm=@ybdm
		else
			select @zfbl=0,@yhbl=yhbl from YY_TSSFXMK (nolock)
				where idm=@idm and xmdm=@ypdm and ybdm=@ybdm

		if @@error<>0
		begin
			select @errmsg='F计算费用时出错！'
			return
		end
	end

	if (@pzlx<>'8') or ((@zfbl<1) and (@zfbl>0))
		select @flzfbl=@zfbl
	/****处理博爱医院病人结算要求超过定额后全部自费   开始************/
    if (@isusebj='是') and (@pzlx<>0)and (@zfbl<>1) --◆目前控制处理医保病人并且通过参数5186开关控制 start
	begin
		declare   @dqbrzje money --确费前病人总金额
		select @dqbrzje = zje-zfyje-yhje+flzfje from ZY_BRJSK (nolock) where syxh=@syxh and jszt=0 and ybjszt=0 and jlzt=0
		if (@dqbrzje-@yjbj)>=0
			select @zfbl=1
        else
		begin
			if @dqbrzje+(@ypdj*@zxsl*(1-@zfbl)/@ykxs)>=@yjbj
				select @zfbl=(@ypdj*@zxsl*(1-@zfbl)/@ykxs-@yjbj+@dqbrzje+@ypdj*@zxsl*@zfbl/@ykxs)*0.0001/(round(@ypdj*@zxsl/@ykxs, 2)*0.0001)
			else
				select @zfbl=@zfbl
		end
	end  --◆目前控制处理医保病人并且通过参数5186开关控制 end
	/****处理博爱医院病人结算要求超过定额后全部自费   结束************/
	if @zfbz=4 and @fylb<>9
		select @zfbl = 0,@zfdj=0, @yhbl = 0,@yhdj=0, @flzfbl = 0 ,@flzfdj=0

	--对小处方的单方不可报复方可报处理begin
	--只有小处方才能判断单复方,单方不可报不优惠
	if @fylb=10 and @dffbz=1
	begin	
		if (select count(1) from ZY_XCFMXK (nolock) where 
				cfxh=(select cfxh from BQ_FYQQK (nolock) where xh=@qqxh))>1
			select @zfbl = 0,@zfdj=0,@flzfdj=0,@flzfbl = 0 
		else
			select @zfbl = 1,@zfdj=@ypdj,@yhbl = 0,@yhdj=0,@flzfdj=@ypdj,@flzfbl = 1
	end
	--对小处方的单方不可报复方可报处理end

	if @flzfbz=0 
		select @flzfdj=0,@flzfbl = 0
    
	if (select config from YY_CONFIG (nolock) where id='5055')='0'
	begin
		if @shbz=1
	  		select @zfdj=0, @zfje=0, @yhdj=0, @yhje=0, @flzfje=0,@flzfdj=0
					,@zfbl = 0, @yhbl = 0,@flzfbl = 0 --审核通过作为可报处理
	end
	else begin
		if @shbz=2
	  		select @zfdj=@ypdj, @zfje=@zje, @yhdj=0, @yhje=0, @flzfje=0,@flzfdj=0 	
            ,@zfbl = 1, @yhbl = 0,@flzfbl = 0 --审核不通过作为不可报处理
	end

	--W20050119 ,当是婴儿时，不保存分类自负金额
	if @yexh > 0 
		select @flzfje = 0,@flzfbl = 0,@flzfbz=0
    if @cq_fjxm=1
        select @zfbl=1
    --add by kongwei 
	if @qzzfbz = 1    --强制自费  
    select @yhbl=0, @zfbl=1  

	if @sxjg<@ypdj and @sxjg>0 and @cq_fjxm=0
	begin
		select @zfdj=(@ypdj-@sxjg)+@sxjg*@zfbl, @yhdj=@sxjg*(1-@zfbl)*@yhbl 
		if (select rtrim(ltrim(config)) from YY_CONFIG (nolock) where id='5266')='0'
	        select @flzfdj=@sxjg*@flzfbl*@flzfbz 
		else
			select @flzfdj=(@ypdj-@sxjg)*@flzfbz	
	end
	else
		select @zfdj=@ypdj*@zfbl, @yhdj=@ypdj*(1-@zfbl)*@yhbl, @flzfdj=@ypdj*@flzfbl

	--W20071125 松江区零差价处理,在计算金额前确定单价
	if (exists(select ybdm from YY_YBFLK (nolock) where ybdm = @ybdm and lcyhbz = 1)) and (@lcjsdj <> 0)
	begin
		if @sxjg<@lcjsdj and @sxjg>0
			select @zfdj=(@lcjsdj-@sxjg)+@sxjg*@zfbl, 
					@yhdj=@sxjg*(1-@zfbl)*@yhbl, 
					@flzfdj=@sxjg*@flzfbl
					--@flzfdj=(@ypdj-@sxjg)+@sxjg*@flzfbl
		else
			select @zfdj=@lcjsdj*@zfbl, 
					@yhdj=@lcjsdj*(1-@zfbl)*@yhbl,
					@flzfdj=@lcjsdj*@flzfbl
		select @yyhdj =@yhdj
		select @yhdj = @yhdj + @ypdj - isnull(@lcjsdj,0)
		select @lcyhje = round(@ypdj*@zxsl/@ykxs, 2) - round(@lcjsdj*@zxsl/@ykxs, 2)
	end
	--*******以后本行作为比例 和单价、金额计算的分界点，以上作为公共比例计算使用，以下作为涉及金额计算	
	--add by chenwei 2003.11.7 退费时按原自费单价计算医保分类自负金额
	if @tfbz = 2 --◆2=退费 start
	begin
		select @zfdj=@old_zfdj
		select @flzfje = flzfje, @qqrq=zxrq,@yhdj=yhdj,@lcjsdj = isnull(lcjsdj,0)  FROM ZY_BRFYMXK (nolock) where syxh = @syxh and qqxh = @qqxh 
		       and fylb in(0,1,8,10) and idm = @idm  
		if @flzfje is not null
		begin
			if  @flzfje <> 0
				select @flzfbz = 1
			else
				select @flzfbz = 0		
		end
	end --◆2=退费 end
		
	if (exists(select ybdm from YY_YBFLK (nolock) where ybdm = @ybdm and lcyhbz = 1)) and (@lcjsdj <> 0)
	begin
		select @yhje=case when @lcjsdj = 0 then round(@yhdj*@zxsl/@ykxs,2) else 
						round(@ypdj*@zxsl/@ykxs,2)- round(@lcjsdj*@zxsl/@ykxs,2)+round(@yyhdj*@zxsl/@ykxs,2) 
					end
	end
	else begin
		select @yhje=round(@yhdj*@zxsl/@ykxs,2) 
	end
					
	select @zje=round(@ypdj*@zxsl/@ykxs, 2)	
	select @srce =ROUND(@ypdj*@zxsl/@ykxs - @zje,4)
    --只只有乙类药，明细保存才这样处理，其它明细不处理
	if  (@flzfje_is3 = '是') and (@flzfdj <> 0)   
		select @flzfje=round(@flzfdj*@zxsl/@ykxs,3)
			,@zfje=round(@zfdj*@zxsl/@ykxs, 3)
	else 
		select @flzfje=round(@flzfdj*@zxsl/@ykxs,2)
			,@zfje=round(@zfdj*@zxsl/@ykxs, 2)	

	if @fylb=9  or @yexh>0
		select @yeje=@zje
	else
		select @yeje=0
   
    if (@zje=@zfje) --AND (@pzlx='8')	-- add by gzy at 20060809
		select @flzfdj=0 ,@flzfbz=0,@flzfbl = 0, @flzfje=0

	--add by pin 41277 2009-8-4 begin
	if exists (select 1 from YY_CONFIG(nolock) where id='9052' and isnull(config,'否')='是') --◆是否使用科研类申请单 为是 start
	begin
		if @qqxh is not null
		begin
			if exists (select 1 from BQ_YJQQK a(nolock),YY_SFXXMK b(nolock) where a.xmdm=b.id and isnull(a.lcxmdm,'0')='0' 
				and  a.kybz=1 and b.iskybz=1 and a.syxh=@syxh and a.xh=@qqxh)
			begin
				select @yhdj=@ypdj,@yhje=@zje,@zfdj=0,@zfje=0,@flzfje=0
			end
			else if exists (select 1 from BQ_YJQQK a(nolock),YY_SFXXMK b(nolock),YY_LCSFXMK e(nolock),YY_LCSFXMDYK f(nolock) 
				where isnull(a.lcxmdm,'0')<>'0' and a.lcxmdm=e.id and e.id=f.lcxmdm and f.xmdm=b.id  and  a.kybz=1 and b.iskybz=1 and a.syxh=@syxh and a.xh=@qqxh )
				and not exists (select 1 from BQ_YJQQK a(nolock),YY_SFXXMK b(nolock),YY_LCSFXMK e(nolock),YY_LCSFXMDYK f(nolock) 
				where isnull(a.lcxmdm,'0')<>'0' and a.lcxmdm=e.id and e.id=f.lcxmdm and f.xmdm=b.id  and  a.kybz=1 and isnull(b.iskybz,0)=0 and a.syxh=@syxh and a.xh=@qqxh )
			begin
				select @yhdj=@ypdj,@yhje=@zje,@zfdj=0,@zfje=0,@flzfje=0
			end
		end
		else begin
			if exists (select 1 from VW_LSYZK a(nolock),VW_ZYSQD b(nolock),YY_SFXXMK c(nolock) where a.sqdxh=b.xh and 
				a.ypdm=c.id and isnull(a.lcxmdm,'0')='0' and b.kybz=1 and c.iskybz=1 and a.syxh=@syxh and a.xh=@yzxh)
			begin
				select @yhdj=@ypdj,@yhje=@zje,@zfdj=0,@zfje=0,@flzfje=0
			end
			else if exists (select 1 from VW_LSYZK a(nolock),YY_SFXXMK b(nolock),VW_ZYSQD c(nolock),YY_LCSFXMK e(nolock),YY_LCSFXMDYK f(nolock) 
				where isnull(a.lcxmdm,'0')<>'0' and a.sqdxh=c.xh and a.lcxmdm=e.id and e.id=f.lcxmdm and f.xmdm=b.id  and  c.kybz=1 and b.iskybz=1 and a.syxh=@syxh and a.xh=@yzxh )
				and not exists (select 1 from VW_LSYZK a(nolock),YY_SFXXMK b(nolock),VW_ZYSQD c(nolock),YY_LCSFXMK e(nolock),YY_LCSFXMDYK f(nolock) 
				where isnull(a.lcxmdm,'0')<>'0' and a.sqdxh=c.xh and a.lcxmdm=e.id and e.id=f.lcxmdm and f.xmdm=b.id  and  c.kybz=1 and isnull(b.iskybz,0)=0 and a.syxh=@syxh and a.xh=@yzxh )
			begin
				select @yhdj=@ypdj,@yhje=@zje,@zfdj=0,@zfje=0,@flzfje=0
			end
		end
	end--end --◆是否使用科研类申请单 为是 end

	--干保处理
	if @gbbz=1 and ((@zfje-@flzfje>0 and @zfje >0 ) or (@zfje-@flzfje<0 and @zfje <0 )) --◆干保处理 start
	begin
        
        select @gbfwwje=@zfje-@flzfje

        if @tfbz = 2 and @zxsl<0 --if @tfbz = 2 and @zxsl<0 start
        begin
            select @gbzfbl_tf=gbtsbl 
            from ZY_BRFYMXK (nolock)
            where syxh = @syxh and qqxh = @qqxh and idm = @idm and ypsl>0
			if @@error<>0
			begin
			    select @errmsg="F取干保范围外费用时出错！"
				select "F","取干保范围外费用时出错！"
				return
			end
            if @gbzfbl_tf is not null
            begin
				select @gbfwwje=(@zfje-@flzfje)*@gbzfbl_tf,
						@gbtsbz=1,
						@gbtsbl=@gbzfbl_tf
				if @@error<>0
				begin
					select @errmsg="F取干保范围外费用时出错1！"
					select "F","取干保范围外费用时出错1！"
					return
				end
            end

        end --if @tfbz = 2 and @zxsl<0 end
        else
        begin -- if not (@tfbz = 2 and @zxsl<0) start
		
			if exists(select 1 from YY_GBTSSFXMK b (nolock)	where b.idm=@idm and b.xmdm=@ypdm and b.ybdm=@ybdm)
			begin
				select @gbfwwje=(@zfje-@flzfje)*b.zfbl,
						@gbtsbz=1,
						@gbtsbl=b.zfbl
					from YY_GBTSSFXMK b (nolock)
					where b.idm=@idm and b.xmdm=@ypdm and b.ybdm=@ybdm
				if @@error<>0
				begin
					select @errmsg="F计算干保范围外费用时出错！"
					select "F","计算干保范围外费用时出错！"
					return
				end
			end
			if exists(select 1	from YY_GBBRTSSFXMK b (nolock) where b.idm=@idm and b.xmdm=@ypdm and b.xtlb=1 and b.brxh=@syxh)
			begin
				select @gbfwwje=(@zfje-@flzfje)*b.zfbl,
						@gbtsbz=1,
						@gbtsbl=b.zfbl
					from YY_GBBRTSSFXMK b (nolock)
					where b.idm=@idm and b.xmdm=@ypdm and b.xtlb=1 and b.brxh=@syxh
				if @@error<>0
				begin
				    select @errmsg="F计算干保范围外费用时出错1！"
					select "F","计算干保范围外费用时出错1！"
					return
				end
			end
        end -- if not (@tfbz = 2 and @zxsl<0) end

		select @gbfwje=@zfje-@flzfje-@gbfwwje

		if @gbtsbz=1
			select @gbtsfwje=@gbfwje, @gbtsfwwje=@gbfwwje  
	end --◆干保处理 end
    if @tfbz=2  --◆@tfbz 2=退费 start--退费费用都按退药数量与原来总数量的比例取，以免当中参数变化导致算出来不对,@zxsl传入时即为负数  add by xwm 2011-07-29
    begin
        declare @flzfjexsw int
        if (@flzfje_is3 = '是') and (@flzfdj <> 0)
            select @flzfjexsw=3
        else
            select @flzfjexsw=2
        
		select @srce = -srce,@sfxdzf=ISNULL(sfxdzf,0) from ZY_BRFYMXK_FZ(nolock) where syxh=@syxh and xh=@tfxh 
		if exists(select 1 from ZY_BRFYMXK a(nolock) where a.syxh=@syxh and a.tfxh=@tfxh)
		begin
			select @srce = 0.0,@fyce=0.0
		end
		else
		begin
			select @fyce=round(zje-round(zje/ypsl,2)*ypsl,2) from ZY_BRFYMXK(nolock) where syxh=@syxh and xh=@tfxh and jlzt=0
		end
                  
        select @zje=round(round(zje/ypsl,2)*@zxsl,2)-@fyce,
            --@srce =round( ypdj*@zxsl/ykxs -round(zje*@zxsl/ypsl,2),4),
			@zfje=round(zfje*@zxsl/ypsl,@flzfjexsw),--add by guo 20140114 for bug190727
			@yhje=round(yhje*@zxsl/ypsl,2),
			@flzfje=round(flzfje*@zxsl/ypsl,@flzfjexsw),
			@dxmdm=dxmdm,
			@yeje=(case when @fylb=9 or @yexh>0 then round(zje*@zxsl/ypsl,2) else 0 end),
			@gbtsbz =gbtsbz,
			@gbfwje =round(gbfwje*@zxsl/ypsl,2),
			@gbfwwje =round(gbfwwje*@zxsl/ypsl,2)
			,@lcjsdj =isnull(lcjsdj,0)
			,@lcyhje = case when lcjsdj <> 0 then (round(zje*@zxsl/ypsl,2) - round(lcjsdj*@zxsl/ypsl, 2)) else 0 end 
        from ZY_BRFYMXK(nolock)
		where syxh=@syxh and xh=@tfxh and jlzt=0

		--select @srce = -srce,@sfxdzf=ISNULL(sfxdzf,0) from ZY_BRFYMXK_FZ(nolock) where syxh=@syxh and xh=@tfxh 
		if @gbtsbz=1
			select @gbtsfwje=@gbfwje, @gbtsfwwje=@gbfwwje
    end  --◆@tfbz 2=退费 end
end --▲▲▲0=正常 or 2=退费 end ▲▲▲

--modify by mly 2005-04-12 增加确认科室的传入如果有传入就是用传入科室,没有传入就是用操作员所在科室
if @qrksdm <> ''  
	select @czyks = @qrksdm	
else
begin
	select @czyks =isnull(ks_id,'')  from czryk(nolock) where id =  @czyh and charindex('00',gwdm)<=0	
    if @czyks=''
	select @czyks=@ksdm
end

if @tfbz=0 --add zengtao 20121110
begin
	select @yhdj= @ypdj-(@ypdj-@yhdj)*@ssbl_qf 
	select @yhje= round(@yhdj*@zxsl/@ykxs,2) 
end 

-- swx 2015-1-20 for 12179
if exists(select 'x' from YY_CONFIG where id ='6881' and config='是')
	and exists(select 'x' from YY_CONFIG where id ='6882' and charindex(@dxmdm,config)>0)
	and (@tfbz=0)
begin
	select @yhdj= @ypdj*(1-isnull(@sfbl,1))
	select @yhje= round(@yhdj*@zxsl/@ykxs,2) 
end

update ZY_BRJSK set zje=isnull(zje,0)+isnull(@zje,0), 
	zfyje=isnull(zfyje,0)+isnull(@zfje,0), 
	yhje=isnull(yhje,0)+isnull(@yhje,0), 
	@jsxh=xh, 
	flzfje=isnull(flzfje,0)+isnull(@flzfje,0),
	lcyhje = isnull(lcyhje,0)+isnull(@lcyhje,0)
where syxh=@syxh and jszt=0 and ybjszt=0 and jlzt=0
if @@error<>0 or @@rowcount=0
begin
	select @errmsg='F病人当前结算记录不可用，请于系统管理员联系！'
	return	
end
if not exists(select 1 from ZY_BRJSK_FZ where jsxh =@jsxh and syxh =@syxh )
begin
	insert into  ZY_BRJSK_FZ(jsxh, syxh, patid, srce)
	select @jsxh ,@syxh,patid ,isnull(@srce,0)
	from ZY_BRSYK (nolock) where syxh =@syxh
	if @@error<>0 or @@rowcount=0
	begin
		select @errmsg='F病人确费出错！'
		return	
	end	
end
else
begin
	update  ZY_BRJSK_FZ set  srce  = isnull(srce ,0) + isnull(@srce,0) 
	where jsxh=@jsxh and syxh =@syxh
	if @@error<>0 or @@rowcount=0
	begin
		select @errmsg='F病人确费出错！'
		return	
	end	
end


if exists(select 1 from ZY_BRJSMXK (nolock)where jsxh=@jsxh and dxmdm=@dxmdm)
begin
	update ZY_BRJSMXK set xmje=isnull(xmje,0)+isnull(@zje,0),
		zfje=isnull(zfje,0)+isnull(@zfje,0),
		yhje=isnull(yhje,0)+isnull(@yhje,0),
		yeje=isnull(yeje,0)+isnull(@yeje,0),
		flzfje=isnull(flzfje,0)+isnull(@flzfje,0),
		gbfwje=isnull(gbfwje,0)+isnull(@gbfwje,0),
		gbfwwje=isnull(gbfwwje,0)+isnull(@gbfwwje,0),
		gbtsfwje=isnull(gbtsfwje,0)+isnull(@gbtsfwje,0),
		gbtsfwwje=isnull(gbtsfwwje,0)+isnull(@gbtsfwwje,0),
		lcyhje = isnull(lcyhje,0) +isnull(@lcyhje,0)		
	where jsxh=@jsxh and dxmdm=@dxmdm
	if @@error<>0 or @@rowcount=0
	begin
		select @errmsg='F病人确费出错！'
		return	
	end	
	if not exists(select 1 from ZY_BRJSMXK_FZ where jsxh =@jsxh and dxmdm =@dxmdm)
	begin
		insert into  ZY_BRJSMXK_FZ(jsxh, dxmdm,srce,fpxmdm)
		select @jsxh, @dxmdm, isnull(@srce,0), zyfp_id
		from YY_SFDXMK (nolock) 
		where id=@dxmdm
		if @@error<>0 or @@rowcount=0
		begin
			select @errmsg='F病人确费出错！'
			return	
		end	
	end
	else
	begin
		update  ZY_BRJSMXK_FZ set  srce  = isnull(srce ,0) + isnull(@srce,0) 
		where jsxh=@jsxh and dxmdm=@dxmdm
		if @@error<>0 or @@rowcount=0
		begin
			select @errmsg='F病人确费出错！'
			return	
		end	
	end
end
else begin
	insert into ZY_BRJSMXK(jsxh, dxmdm, dxmmc, fpxmdm, fpxmmc, xmje, zfje, yhje, yeje, memo, flzfje,
			gbfwje, gbfwwje, gbtsfwje, gbtsfwwje,lcyhje)
	select @jsxh, @dxmdm, name, zyfp_id, zyfp_mc, isnull(@zje,0), isnull(@zfje,0), isnull(@yhje,0), isnull(@yeje,0), null, isnull(@flzfje,0),
			isnull(@gbfwje,0), isnull(@gbfwwje,0), isnull(@gbtsfwje,0), isnull(@gbtsfwwje,0),isnull(@lcyhje,0)
	from YY_SFDXMK (nolock) 
	where id=@dxmdm
	if @@error<>0 or @@rowcount=0
	begin
		select @errmsg='F大项目设置不正确，确费出错！'
		return	
	end
	insert into  ZY_BRJSMXK_FZ(jsxh, dxmdm,srce,fpxmdm)
	select @jsxh, @dxmdm, isnull(@srce,0), zyfp_id
	from YY_SFDXMK (nolock) 
	where id=@dxmdm
	if @@error<>0 or @@rowcount=0
	begin
		select @errmsg='F大项目设置不正确，确费出错！'
		return	
	end	
end

if @tfbz=1 --▲▲▲1=作废 start ▲▲▲ 
begin
	--add by shiyong 2012-11-12判断是否拆分退费
	declare @cfbz varchar(1)
	if @zxsl < 0
		select @cfbz = '1'
	else
		select @cfbz = '0'

	insert into ZY_BRFYMXK(syxh, zxrq, czyh, yzxh, qqxh, qqrq, bqdm, ksdm, ysdm, idm,
		ypdm, ypmc, dxmdm, zxks, ypgg, ypdw, dwxs, ykxs, ypsl, ypdj, zfdj, yhdj, zje, zfje,
		yhje, fylb, yexh, jsxh, jszt, jlzt, memo, cwdm, flzfje, ybshbz, ybspbh, qrks,zrysdm,zzysdm,lcxmdm,lcxmmc	--agg 2004.09.10 增加lcxmdm,lcxmmc
		,txbl, ysks,czybq, tdxmxh, gbfwje, gbfwwje, gbtsbz, gbtsbl, fzrysdm, ylxzdm,qqmxxh,dydm,lcjsdj,xzks_id,tfxh,
		zfyy,jzks,gdzxbz,sffjxm,sbid,jzys,yzlb,txbz,fyfzxh,jsks,bar_code) --add "dydm" 20070119 --add by shiyong 2010-08-06 yzlb
	select syxh,case isnull(@jfsj,'') when '' then (case when @config9177='是' then @zxrq_xg else @now end) else @jfsj end, @czyh, yzxh, qqxh, qqrq, bqdm, ksdm, ysdm, idm,
		ypdm, ypmc, dxmdm, zxks, ypgg, ypdw, dwxs, ykxs,case @cfbz when '0' then -ypsl else @zxsl end, ypdj, zfdj, yhdj, case @cfbz when '0' then -zje else Convert(decimal(9,2),@zxsl * ypdj/ykxs) end, -zfje, 
		-yhje, fylb, yexh, @jsxh, 0, 2, memo, cwdm, -flzfje, ybshbz, ybspbh, qrks,zrysdm,zzysdm,lcxmdm,lcxmmc  --agg 2004.09.10 增加lcxmdm,lcxmmc
		,txbl, ysks,@czybq_temp, tdxmxh, -gbfwje, -gbfwwje, gbtsbz, gbtsbl ,fzrysdm ,ylxzdm,qqmxxh,dydm,lcjsdj,xzks_id,@tfxh,zfyy,jzks,@gdzxbz, --edit by hqx @ysks_temp 2 ysks for 10970
		@cq_fjxm,sbid,jzys,yzlb,txbz,fyfzxh,jsks,@barcodehrp  --mit,2oo4-12-21,增加txbl     -- Add Koaka, 2005-09-13	增加tdxmxh --add by shiyong 2010-08-06 yzlb
	from ZY_BRFYMXK (nolock)
	where syxh=@syxh and xh=@tfxh
	if @@error<>0 or @@rowcount=0
	begin
		select @errmsg='F病人确费时出错！'
		return
	end

	select @xh_temp =SCOPE_IDENTITY()

	--add by hhy 2014.04.17 for 206094 逻辑病区代码
	if @isuseylz = '是' and @config6809 = '是'
	begin
		insert into ZY_BRFYMXK_FZ
			( xh ,syxh , ljbqdm,sfbl,tcwbz,jzyy,lcxmdj,srce,ybsl,yzxrq,szbdj,sfxdzf,hrptxm)
		select a.xh,a.syxh,b.ljbqdm,@sfbl,@tcwbz,@jzyy,@lcxmdj,isnull(@srce,0)
			,case when @config6A33='5' then isnull(c.ybsl,0) else null END,@yzxrq,@szbdj,@sfxdzf,@barcodehrp
		from ZY_BRFYMXK a(nolock) inner join ZY_BRSYK b(nolock)on a.syxh = b.syxh 
			left join YY_LCSFXMDYK c(nolock) on c.lcxmdm=@lcxmdm and @lcxmdm<>'0' and a.ypdm=c.xmdm and a.lcxmdm=c.lcxmdm
		where a.xh = @xh_temp 
		if @@ERROR <> 0 or @@ROWCOUNT = 0
		begin
			select @errmsg='F病人确费时出错！'
			return
		end
	end
    else
	begin
		insert into ZY_BRFYMXK_FZ
			( xh ,syxh , ljbqdm,sfbl,tcwbz,jzyy,lcxmdj,srce,ybsl,yzxrq,szbdj,sfxdzf,hrptxm)
		select a.xh,a.syxh,null,@sfbl,@tcwbz,@jzyy,@lcxmdj,isnull(@srce,0)
			,case when @config6A33='5' then isnull(c.ybsl,0) else null END,@yzxrq,@szbdj,@sfxdzf,@barcodehrp
		from ZY_BRFYMXK a(nolock)
			left join YY_LCSFXMDYK c(nolock) on c.lcxmdm=@lcxmdm and @lcxmdm<>'0' and a.ypdm=c.xmdm and a.lcxmdm=c.lcxmdm
		where a.xh = @xh_temp 
		if @@ERROR <> 0 or @@ROWCOUNT = 0
		begin
			select @errmsg='F病人确费时出错！'
			return
		end
	end
	
    if (isnull(@wzqqxh,0)<>0)
    begin 
		update YY_ZY_CLJLK set jlzt=3
		where fyxh=@tfxh
	end
	--yjf 2013-06-04 确费时自动扣除物资材料库存
	IF EXISTS(SELECT 1 FROM YY_CONFIG(nolock) WHERE id='A234' AND config<>'是')
	begin
		IF EXISTS(SELECT 1 FROM YY_CONFIG(nolock) WHERE id='A219' AND config='是')
			and ((isnull(@wzqqxh,0)<>0) or EXISTS(SELECT 1 FROM YY_CONFIG(nolock) WHERE id='A262' AND config<>'是')  )
		BEGIN
			if (@kcdylb=0) or (@kcdylb=1 and (LEFT(@tm,2) in ('GZ','DZ')))
			begin     
				exec usp_wz_hisxhpcl @xh_temp,1,@errmsg output,@pcxh=@pcxh,@tm=@tm
				if @errmsg like 'F%' or @@error<>0
				begin
					--select @errmsg;
					return
				END
			end
		END
	end      
	--yjf 2013-06-04 确费时自动扣除物资材料库存
    	
    if @zxmdm=-1
    begin
         select @zxmdm=@xh_temp
    end
    --add by shiyong 2012-11-12 将所有的退费记录全部置为状态2
	if @cfbz='0'
	begin
		update ZY_BRFYMXK set jlzt = 2 WHERE syxh=@syxh AND tfxh = @tfxh
    end
    update ZY_BRFYMXK set prnxh=@zxmdm where xh=@xh_temp
	if @@error<>0 or @@rowcount=0
	begin
		select @errmsg='F病人确费时出错！'
		return
	end
    	
	if exists(select 1 from ZY_BRFYMXK (nolock) where syxh=@syxh and xh=@xh_temp and idm=0 )
	begin
	   ---add by cyh 更新注册证号  需求:118862
	   update a  set a.yzczh=c.item_previousidl
	   from ZY_BRFYMXK  a,YY_SFXXMK b,YY_YBXMK c
	   where  a.ypdm=b.id and b.sybz=1 and  a.syxh=@syxh and a.xh=@xh_temp  
			  and b.dydm=c.item_code and a.idm=0 and isnull(a.yzczh,'')<>''
		if @@error<>0 
		begin
			select @errmsg='F更新医保注册证号时出错！'
			return
		end          
	end
	else begin
	   update a  set a.yzczh=c.previousidl
	   from ZY_BRFYMXK  a,YK_YPCDMLK b,YY_YBYPK c
	   where  a.idm=b.idm and b.tybz=0 and a.syxh=@syxh and a.xh=@xh_temp 
			  and b.dydm=c.mc_code and a.idm>0 and isnull(a.yzczh,'')<>'' 
		if @@error<>0
		begin
			select @errmsg='F更新医保注册证号时出错！'
			return
		end         
	end	

end --▲▲▲1=作废 end ▲▲▲ 
--panlian  2004-03-15 补记帐作废只能作废本科室 加入判断依据字段qrks 
else begin --▲▲▲0=正常 or 2=退费 start ▲▲▲ 
    select @xzks_id=(select xzks_id from YY_ZGBMK (nolock)where id=@ysdm) 
	--宁波六院医保审批处理
	if exists(select 1 from ZY_LCMXYBSPJLK (nolock) where syxh=@syxh and qqxh=@qqxh and sfid=@ypdm and yzlx='1')
	begin
		select @shbz=ybspbz from ZY_LCMXYBSPJLK (nolock) where syxh=@syxh and qqxh=@qqxh and sfid=@ypdm and yzlx='1'	
	end
	
	if @idm=0 
       select @yzczh=b.item_previousidl  from YY_SFXXMK a(nolock),YY_YBXMK b(nolock) where a.id=@ypdm and a.dydm=b.item_code and a.sybz=1
	else
	   select @yzczh=b.previousidl  from YK_YPCDMLK a(nolock),YY_YBYPK b(nolock) where a.idm=@idm and a.dydm=b.mc_code and a.tybz=0
	   
	/* Move To Up */
	if @jfsj is null
	begin
        if  (select config from YY_CONFIG (nolock) where id='6242')='是'   
        begin			
			insert into ZY_BRFYMXK(syxh, zxrq, czyh, yzxh, qqxh, qqrq, bqdm, ksdm, ysdm, idm, 
				ypdm, ypmc, dxmdm, zxks, ypgg, ypdw, dwxs, ykxs, ypsl, ypdj, zfdj, yhdj, zje, zfje, 
				yhje, fylb, yexh, jsxh, jszt, jlzt, memo, cwdm, flzfje, ybshbz, ybspbh,qrks,zzysdm,zrysdm,lcxmdm,lcxmmc --agg 2004.09.10 增加lcxmdm,lcxmmc
				,txbl, ysks,czybq,tdxmxh, gbfwje, gbfwwje, gbtsbz, gbtsbl, fzrysdm, ylxzdm,qqmxxh,dydm,lcjsdj,xzks_id,tfxh,jzks,
				gdzxbz,sffjxm,sbid,jzys,yzlb,txbz,yzczh,fyfzxh,jsks,jzbq,bar_code )
			values(@syxh, case @gdzxbz when 1 then (case when @config9177='是' then @zxrq_xg else @now end) else @qqrq end, @czyh, @yzxh, @qqxh, @qqrq, ISNULL(@tybqdm,@bqdm), ISNULL(@tyksdm,@ksdm), @ysdm, @idm,	-- modify by gzy at 20041208 @bqdm
				@ypdm, @ypmc, @dxmdm, @yfdm, @ypgg, @ypdw, @dwxs, @ykxs, @zxsl, isnull(@ypdj,0), @zfdj, @yhdj, @zje, isnull(@zfje,0), 
				isnull(@yhje,0), @fylb, @yexh, @jsxh, 0, 0, @memo, @cwdm, isnull(@flzfje,0), @shbz, @spbh, @czyks,@zzysdm,@zrysdm,@lcxmdm,@lcxmmc --agg 2004.09.10 增加lcxmdm,lcxmmc
				,@txbl,@ysks_temp,@czybq_temp,@tdxmxh, @gbfwje, @gbfwwje, @gbtsbz, @gbtsbl, @fzrysdm, @ylxzdm,@yjmxxh,@dydm,@lcjsdj,@xzks_id,@tfxh,@jzks_qf,@gdzxbz,@cq_fjxm,
				case when @sbid_qf='' then null else convert(numeric(9,0),@sbid_qf) end,@jzys_qf,@yzlb,@cwtxbz,@yzczh,@fyfzxh,@jsks_qf,@jzbq_qf,@barcodehrp) --add "dydm" 20070119		--mit,2oo4-12-21,增加特需比例 -- Add Koaka, 2005-09-13	增加tdxmxh
			
		end
		else
		begin
			insert into ZY_BRFYMXK(syxh, zxrq, czyh, yzxh, qqxh, qqrq, bqdm, ksdm, ysdm, idm, 
				ypdm, ypmc, dxmdm, zxks, ypgg, ypdw, dwxs, ykxs, ypsl, ypdj, zfdj, yhdj, zje, zfje, 
				yhje, fylb, yexh, jsxh, jszt, jlzt, memo, cwdm, flzfje, ybshbz, ybspbh,qrks,zzysdm,zrysdm,lcxmdm,lcxmmc --agg 2004.09.10 增加lcxmdm,lcxmmc
				,txbl, ysks,czybq,tdxmxh, gbfwje, gbfwwje, gbtsbz, gbtsbl, fzrysdm, ylxzdm,qqmxxh,dydm,lcjsdj,xzks_id,tfxh,jzks,
				gdzxbz,sffjxm,sbid,jzys,yzlb ,txbz,yzczh,fyfzxh,jsks,jzbq,bar_code) --add "dydm" 20070119 
			values(@syxh, case when @config9177='是' then @zxrq_xg else @now end, @czyh, @yzxh, @qqxh, @qqrq, ISNULL(@tybqdm,@bqdm), ISNULL(@tyksdm,@ksdm), @ysdm, @idm,	-- modify by gzy at 20041208 @bqdm
				@ypdm, @ypmc, @dxmdm, @yfdm, @ypgg, @ypdw, @dwxs, @ykxs, @zxsl, isnull(@ypdj,0), @zfdj, @yhdj, @zje, isnull(@zfje,0), 
				isnull(@yhje,0), @fylb, @yexh, @jsxh, 0, 0, @memo, @cwdm, isnull(@flzfje,0), @shbz, @spbh, @czyks,@zzysdm,@zrysdm,@lcxmdm,@lcxmmc --agg 2004.09.10 增加lcxmdm,lcxmmc
				,@txbl,@ysks_temp,@czybq_temp,@tdxmxh, @gbfwje, @gbfwwje, @gbtsbz, @gbtsbl, @fzrysdm, @ylxzdm,@yjmxxh,@dydm,@lcjsdj,@xzks_id,@tfxh,@jzks_qf,@gdzxbz,@cq_fjxm,
				case when @sbid_qf='' then null else convert(numeric(9,0),@sbid_qf) end,@jzys_qf,@yzlb,@cwtxbz,@yzczh,@fyfzxh,@jsks_qf,@jzbq_qf,@barcodehrp) --add "dydm" 20070119		--mit,2oo4-12-21,增加特需比例 -- Add Koaka, 2005-09-13	增加tdxmxh
        end
	end
	else
	begin
		insert into ZY_BRFYMXK(syxh, zxrq, czyh, yzxh, qqxh, qqrq, bqdm, ksdm, ysdm, idm, 
			ypdm, ypmc, dxmdm, zxks, ypgg, ypdw, dwxs, ykxs, ypsl, ypdj, zfdj, yhdj, zje, zfje, 
			yhje, fylb, yexh, jsxh, jszt, jlzt, memo, cwdm, flzfje, ybshbz, ybspbh,qrks,zzysdm,zrysdm,lcxmdm,lcxmmc --agg 2004.09.10 增加lcxmdm,lcxmmc
			,txbl,ysks,czybq,tdxmxh, gbfwje, gbfwwje, gbtsbz, gbtsbl, fzrysdm, ylxzdm ,qqmxxh,dydm,lcjsdj,xzks_id,tfxh,jzks,gdzxbz,sffjxm,sbid,jzys,yzlb,txbz,yzczh,fyfzxh,jsks,jzbq,bar_code ,ybzzfbz) --add "dydm" 20070119 add "ybzzfbz"手术室医保转自费标志 lj
		values(@syxh, case @gdzxbz when 1 then (case when @config9177='是' then @zxrq_xg else @now end) else @jfsj end , @czyh, @yzxh, @qqxh, @qqrq, ISNULL(@tybqdm,@bqdm),  ISNULL(@tyksdm,@ksdm), @ysdm, @idm,	-- modify by gzy at 20041208 @bqdm
			@ypdm, @ypmc, @dxmdm, @yfdm, @ypgg, @ypdw, @dwxs, @ykxs, @zxsl, isnull(@ypdj,0), @zfdj, @yhdj, @zje, isnull(@zfje,0), 
			isnull(@yhje,0), @fylb, @yexh, @jsxh, 0, 0, @memo, @cwdm, isnull(@flzfje,0), @shbz, @spbh, @czyks,@zzysdm,@zrysdm,@lcxmdm,@lcxmmc --agg 2004.09.10 增加lcxmdm,lcxmmc
			,@txbl,@ysks_temp,@czybq_temp,@tdxmxh, @gbfwje, @gbfwwje, @gbtsbz, @gbtsbl, @fzrysdm, @ylxzdm ,@yjmxxh,@dydm,@lcjsdj,@xzks_id,@tfxh,@jzks_qf,@gdzxbz,@cq_fjxm,
			case when @sbid_qf='' then null else convert(numeric(9,0),@sbid_qf) end,@jzys_qf,@yzlb,@cwtxbz,@yzczh,@fyfzxh,@jsks_qf,@jzbq_qf,@barcodehrp,case when @shbz='2'then'1' else '0'end) --add "dydm" 20070119		--mit,2oo4-12-21,增加特需比例 -- Add Koaka, 2005-09-13	增加tdxmxh
	end

	if @@error<>0 or @@rowcount=0
	begin
		select @errmsg='F病人确费时出错！'
		return
	end
    	select @xh_temp =SCOPE_IDENTITY()
    	
	---add by cyh 20151227 for仙居县人民医院---因需要将申请单中的明细项目是否可以报销记录下来，病区需要做对应修改	
	if (select config from YY_CONFIG (nolock) where id='6959')='是'
	BEGIN
		if (select config from YY_CONFIG (nolock) where id='5055')='0'
		begin
		    if exists(select 1 from sysobjects where name='usp_bq_gxybshbz' and type='P')
			begin
				IF isnull(@idm,0)=0 
				BEGIN			  
					 exec usp_bq_gxybshbz @syxh,@yexh,@xh_temp,@lcxmdm,@ypdm    
				END
			end
		END		
	END		
    ---add by cyh 20151227 for仙居县人民医院---因需要将申请单中的明细项目是否可以报销记录下来，病区需要做对应修改

	--80900 青岛阜外医院护士站费用录入限定范围比例选择
	if @config6A33='4'
	begin
		if ISNULL(@bxbl,0)<>0
		begin
			insert into ZY_BRFYMXK_SH
				( fyxh,shbz,spbh,bxbl,bxsm,shczyh,shsj)
			select a.xh,ISNULL(@ybshbz,1),'',ISNULL(@bxbl,0),'',a.czyh,a.zxrq
			from ZY_BRFYMXK a(nolock),ZY_BRSYK b(nolock)
			where a.xh = @xh_temp and a.syxh = b.syxh 
			if @@ERROR <> 0 or @@ROWCOUNT = 0
			begin
				select @errmsg='F病人确费时出错！'
				return
			end
		end
	end
	
	--add by hhy 2014.04.17 for 206094 逻辑病区代码
	if @isuseylz = '是' and @config6809 = '是'
	begin
		insert into ZY_BRFYMXK_FZ
			( xh ,syxh , ljbqdm,sfbl,tcwbz,jzyy,lcxmdj,srce,ybsl,yzxrq,szbdj,sfxdzf,hrptxm)
		select a.xh,a.syxh,b.ljbqdm,@sfbl,@tcwbz,@jzyy,@lcxmdj,isnull(@srce,0)
			,case when @config6A33='5' then isnull(c.ybsl,0) else null END,@yzxrq,@szbdj,@sfxdzf,@barcodehrp
		from ZY_BRFYMXK a(nolock) 
		    inner join ZY_BRSYK b(nolock)on a.syxh = b.syxh 
			left join YY_LCSFXMDYK c(nolock) on c.lcxmdm=@lcxmdm and @lcxmdm<>'0' and a.ypdm=c.xmdm and a.lcxmdm=c.lcxmdm
		where a.xh = @xh_temp 
		if @@ERROR <> 0 or @@ROWCOUNT = 0
		begin
			select @errmsg='F病人确费时出错！'
			return
		end
	end
	else
	begin
		insert into ZY_BRFYMXK_FZ
			( xh ,syxh , ljbqdm,sfbl,tcwbz,jzyy,lcxmdj,srce,ybsl,yzxrq,szbdj,sfxdzf,hrptxm)
		select a.xh,a.syxh,null,@sfbl,@tcwbz,@jzyy,@lcxmdj,isnull(@srce,0)
			,case when @config6A33='5' then isnull(c.ybsl,0) else null END,@yzxrq,@szbdj,@sfxdzf,@barcodehrp
		from ZY_BRFYMXK a(nolock)
			left join YY_LCSFXMDYK c(nolock) on c.lcxmdm=@lcxmdm and @lcxmdm<>'0' and a.ypdm=c.xmdm and a.lcxmdm=c.lcxmdm
		where a.xh = @xh_temp
		if @@ERROR <> 0 or @@ROWCOUNT = 0
		begin
			select @errmsg='F病人确费时出错！'
			return
		end
	end
	if (isnull(@wzqqxh,0)<>0) and (@tfbz=0)
	begin
		update YY_ZY_CLJLK set jlzt=2,fyxh=@xh_temp
		where xh = @wzqqxh 
	end
		    	
    --yjf 2013-06-04 确费时自动扣除物资材料库存
    IF EXISTS(SELECT 1 FROM YY_CONFIG(nolock) WHERE id='A234' AND config<>'是')
    begin
		IF EXISTS(SELECT 1 FROM YY_CONFIG(nolock) WHERE id='A219' AND config='是') 
			and ((isnull(@wzqqxh,0)<>0) or EXISTS(SELECT 1 FROM YY_CONFIG(nolock) WHERE id='A262' AND config<>'是')  )
		BEGIN 
			if (@kcdylb=0) or (@kcdylb=1 and (LEFT(@tm,2) in ('GZ','DZ')))
			begin 
				exec usp_wz_hisxhpcl @xh_temp,1,@errmsg output,@pcxh=@pcxh,@tm=@tm
				if @errmsg like 'F%' or @@error<>0
				begin
					--select @errmsg;
					return
				END
			end
		END
	end          
    --yjf 2013-06-04 确费时自动扣除物资材料库存
        
	if @zxmdm=-1
	begin
		select @zxmdm=@xh_temp
	end

	update ZY_BRFYMXK set prnxh=@zxmdm where xh=@xh_temp
	if @@error<>0 or @@rowcount=0
    begin
    	select @errmsg='F病人确费时出错！'
    	return
    end

	--zwt 2010.05.23 将@xh_temp插入临时表中保存,插入BQ_JLHXXK表数据 begin
    declare @tablename varchar(32), @sql nvarchar(500), @TOTAL_COUNT int
    select @tablename='##tmp_xh_temp'+@wkdz+@czyh
    if @num = 0
    begin
        exec('if object_id(''tempdb..' + @tablename + ''') is not null      
            begin
                delete from ' + @tablename + '
                insert into ' + @tablename + ' values (' + @xh_temp + ')
            end
            else
            begin
                select ' + @xh_temp + ' as xh_temp into '+ @tablename + '
            end')
    end
    if @num >= 0 and (@cth <> '' or @xxh <> '' or @mrih <> '' or @bch <> '')
    begin
        declare @patid ut_syxh,@fzh ut_xh12
        select @patid = patid from ZY_BRSYK (nolock) where syxh = @syxh
        
        select @sql = 'select @fzh = xh_temp from ' + @tablename
        execute sp_executesql  @sql, N'@fzh ut_xh12 output', @fzh output

        insert into BQ_JLHXXK(syxh, fyxh, fzh, patid, cth, xxh, mrih, bch) 
            values(@syxh, @xh_temp, @fzh, @patid, @cth, @xxh, @mrih, @bch)
	    if @@error<>0 or @@rowcount=0
        begin
    	    select @errmsg='F病人确费时出错！'
    	    return
        end
    end
	--zwt 2010.05.23 将@xh_temp插入临时表中保存,插入BQ_JLHXXK表数据 end

end --▲▲▲0=正常 or 2=退费 end ▲▲▲ 

--Add By : Koala	In : 2005-08-11		For :是否确费预算
if @ispreqf =1 
begin
	select @errmsg="T"+convert(varchar(16),@zje)+','+ convert(varchar(16),@zfje)+','+ convert(varchar(16),@yhje) +',',
	       @fymxxh_out = @xh_temp
	return
end
else
begin
	select @errmsg="T"+convert(varchar(16),@xh_temp) + ',',
	       @fymxxh_out = @xh_temp
	
end

--/*增加重庆医保ybzzfbz需求*/

IF(select config from YY_CONFIG where id='CQ36')='3'

BEGIN

	/*临时医嘱获取自费标志||药品*/
	--手术系统补记费用yzxh和BQ_LSYZK手术医嘱xh重复，加入b.idm>0
	UPDATE a set a.ybzzfbz=b.zfybz from ZY_BRFYMXK a , BQ_LSYZK b  

		where a.yzxh=b.xh and a.syxh=b.syxh  and a.idm>0 and b.idm>0 and a.syxh=@syxh

   /*长期医嘱获取自费标志||药品*/
   --手术系统补记费用yzxh和BQ_LSYZK手术医嘱xh重复，加入b.idm>0
	UPDATE a set a.ybzzfbz=b.zfybz from ZY_BRFYMXK a , BQ_CQYZK b 

		where  a.yzxh=b.xh and a.syxh=b.syxh and  a.idm>0 and b.idm>0 and a.syxh=@syxh

END
return


