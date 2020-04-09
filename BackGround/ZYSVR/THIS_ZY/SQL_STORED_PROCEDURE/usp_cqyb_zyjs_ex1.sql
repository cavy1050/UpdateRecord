if exists(select 1 from sysobjects where name = 'usp_cqyb_zyjs_ex1')
  drop proc usp_cqyb_zyjs_ex1
go
SET ANSI_WARNINGS OFF
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF
go
Create proc usp_cqyb_zyjs_ex1
(
	@syxh			ut_syxh,		--首页序号
	@jsxh			ut_xh12,		--结算序号
	@jslb			ut_bz,			 --0预算1结算2模拟预算
	@zxlsh			varchar(20),	--交易流水号
    @tczf	        ut_money, 		--统筹支付
    @zhzf			ut_money,		--账户支付
    @gwybz			ut_money,		--公务员补助
    @xjzf			ut_money, 		--现金支付
    @delpje			ut_money, 		--大额理赔金额
    @lsqfxgwyfh     ut_money, 		--历史起付线公务员返还
    @zhye			ut_money,		--账户余额
    @dbzyljgdz		ut_money,		--单病种医疗机构垫支
    @mzjzje			ut_money,		--民政救助金额
    @mzjzmzye		ut_money,		--民政救助门诊余额
    @ndyxmzfje		ut_money,		--耐多药项目支付金额
    @ybzlzfje       ut_money, 		--一般诊疗支付数
    @shjzjjzfje		ut_money, 		--神华救助基金支付数
    @bntczflj		ut_money,		--本年统筹支付累计
    @bndezflj		ut_money,		--本年大额支付累计
    @tbqfxzflj		ut_money, 		--特病起付线支付累计
    @ndyxmlj		ut_money,		--耐多药项目累计
    @bnmzjzzyzflj	ut_money,		--本年民政救助住院支付累计
    @zxjssj			varchar(20),	--中心结算时间
    @bcqfxzfje		ut_money,		--本次起付线支付金额
    @bcjrybfwfy		ut_money,		--本次进入医保范围费用
    @ysfwzfje		ut_money,		--药事服务费支付数
    @yycbkkje		ut_money,		--医院超标扣款金额
    @syjjzf			ut_money,		--生育基金支付
    @syxjzf			ut_money,		--生育现金支付
    @gsjjzf			ut_money,		--工伤基金支付
	@gsxjzf			ut_money,		--工伤现金支付
    @gsdbzjgdz		ut_money,		--工伤单病种机构垫支
	@gsqzfyy		varchar(100),	--工伤全自费原因
	@qtbz           ut_money,		--其他补助
	@syzhzf         ut_money,		--生育账户支付
	@gszhzf         ut_money,		--工伤账户支付
	@bcjsfprylb     varchar(100),	--本次结算扶贫人员类别	1.28版
	@jkfpyljj		ut_money,		--健康扶贫医疗基金		1.28版
	@jztpbxje		ut_money,		--精准脱贫保险金额		1.28版
	@qtfpbxje		ut_money,		--其他扶贫报销金额		1.28版
	@zhdyje			ut_money		--账户抵用金额
)
as
/**********************
[版本号]4.0.0.0.0
[创建时间]2017.03.05
[作者]FerryMan
[版权]Copyright ? 1998-2017卫宁健康科技集团股份有限公司
[描述]住院结算处理
[功能说明]
	HIS住院结算处理
[参数说明]
	@jsxh	--结算序号
	@syxh	--首页序号
	@jslb	--0预算1结算
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]
exec usp_zjyb_zyjs_ex1
[修改纪录]
**********************/
set nocount on

declare	@now		ut_rq16,		--当前时间
		@zje		ut_money,		--总金额
		@ybzje		ut_money,		--医保总金额
		@sfje		ut_money,		--实收金额
		@sfje1		ut_money,		--实收金额
		@sfje2		ut_money,		--舍入后的实收金额
		@srbz		ut_bz,			--舍入标志
		@srje		ut_money,		--舍入金额		
		@xmzfbl		numeric(12,4),	--自负比例				
		@xmce		ut_money,		--自付金额和大项自付金额汇总的差额
		@ybzje_ys	ut_money,		--医保预算总金额
		@ybxjzf_ys	ut_money,		--医保预算个人自费金额
		@ybgwyfh_ys	ut_money, 		--医保预算公务员返还
		@zhdyje_ys	ut_money,		--医保预算账户抵用金额
		@zhdyje_hz	ut_money,		--账户抵用金额总和
		@jsbz		ut_bz,			--结算标志 
		@qzrq		ut_rq16,		--费用起止日期
		@zzrq		ut_rq16,		--费用终止日期
		@configCQ01 varchar(10),
		@ts_msg     varchar(200)=''	--结算预算金额不一致提示信息  

select @now=convert(char(8),getdate(),112)+convert(char(8),getdate(),8),
	   @zje=0, @ybzje=0, @sfje=0, @sfje1=0, @sfje2=0, @srje=0, 
	   @xmzfbl=0, @xmce=0, @ybzje_ys=0, @ybxjzf_ys=0, @ybgwyfh_ys=0,
	   @zhdyje_ys=0, @zhdyje_hz=0

IF EXISTS (SELECT 1 FROM ZY_BRJSK a(NOLOCK) WHERE a.xh = @jsxh AND a.syxh = @syxh AND a.ybjszt = 2 )
BEGIN
    select "F","该病人结算序号已结算，不能再预算或结算！" + CONVERT(VARCHAR(12),@jsxh)
	return
END

IF @jslb = 2
BEGIN
    IF EXISTS (SELECT 1 FROM ZY_BRJSK a(NOLOCK) WHERE a.xh = @jsxh AND a.syxh = @syxh AND a.ybjszt <> 0 )
	BEGIN
		select "F","该病人已在收费处进行结算，不能再进行模拟预算！" + CONVERT(VARCHAR(12),@jsxh)
		return
	END
END 

select @configCQ01 = ISNULL(config,'DR') from YY_CONFIG(NOLOCK) where id = 'CQ01'

--计算HIS总金额
if exists(select 1 from ZY_BRSYK(nolock) where syxh = @syxh and brzt in (2,4))
begin
	select @zje = zje - yhje from ZY_BRJSK(NOLOCK) WHERE syxh = @syxh and xh = @jsxh
	if @@rowcount=0
	begin
		select "F","该住院结算记录不存在！"
		return
	END
	--减去不上传的部分金额  由于无需上传部分可能没有先结算，就会做医保的预算
	select @zje = @zje - ISNULL(sum(zje-yhje),0) from ZY_BRFYMXK(nolock) where syxh = @syxh and jsxh = @jsxh AND ISNULL(ybscbz,0) = 3 
end
ELSE  
begin
	--费用起止日期
	select @jsbz = isnull(jslb,0),@qzrq = CASE LEN(RTRIM(jsqzrq)) when 10 THEN REPLACE(jsqzrq,'-','') + '00:00:00' ELSE REPLACE(REPLACE(jsqzrq,'-',''),' ','') end 
	FROM YY_CQYB_ZYJSJLK(nolock) where syxh = @syxh and jsxh = @jsxh
	--费用截止日期
	select @zzrq = 
	    CASE when ISNULL(jszzrq,'') = '' THEN  
		    CASE WHEN b.brzt NOT IN ('2','4') THEN @now ELSE b.cqrq  end
		else  
	        CASE LEN(RTRIM(a.jszzrq)) when 10 THEN REPLACE(a.jszzrq,'-','') + '23:59:59' ELSE REPLACE(REPLACE(a.jszzrq,'-',''),' ','') end 
		end
	FROM YY_CQYB_ZYJSJLK a(nolock),ZY_BRSYK b(NOLOCK) WHERE a.syxh = b.syxh and a.syxh = @syxh and a.jsxh = @jsxh
	
	--费用总额   
	select @zje = isnull(sum(zje-yhje),0) from ZY_BRFYMXK(nolock) where syxh = @syxh and jsxh = @jsxh and ISNULL(ybzxrq,zxrq) between @qzrq and @zzrq and isnull(ybscbz ,0 ) <> 3
	if @@rowcount=0
	begin
		select "F","该住院结算记录不存在！"
		return
	END
--add 20200107	
--	DECLARE @zje_ztjs numeric(18,2)
--	select @zje_ztjs = ys_zje from ZY_BRJSK(NOLOCK) where syxh = @syxh and xh = @jsxh  -- tmp_zje 不包含优惠金额，需修改usp_zyb_brjs
-- if (@jslb = 1) and (abs(@zje - @zje_ztjs)>0.1)
--	begin
	--	select 'F','结算库总金额【'+convert(varchar,@zje_ztjs)+'】和明细金额【'+convert(varchar,@zje)+'】不等，不能中途结算！'
	--	return
--	end
	--add 20200107
	
end 

/********************
本次结算总金额=统筹支付+账户支付+公务员补助+现金支付+大额理赔金额+单病种定点医疗机构垫支+耐多药项目支付金额+一般诊疗支付数
+神华救助基金支付数+生育基金支付+生育现金支付+工伤基金支付+工伤现金支付+工伤单病种机构垫支+其他补助+生育账户支付+工伤账户支付
(东软)统筹包含民政救助、一般诊疗(一级医院有)和耐多药  ，神华救助已经没有了
(万达)统筹不包含民政救助、一般诊疗(一级医院有) 
********************/
select @ybzje = @tczf + @zhzf + @gwybz + @xjzf + @delpje + @dbzyljgdz --+ @ndyxmzfje + @ybzlzfje + @shjzjjzfje
			  + @syjjzf + @syxjzf + @gsjjzf + @gsxjzf + @gsdbzjgdz + @qtbz + @syzhzf + @gszhzf

if @configCQ01 = 'WD'
begin
    select @ybzje = @ybzje + @mzjzje--+@ybzlzfje --20181016暂时不确定，万达一级医院统筹是否包含一般诊疗支付
END

if abs(@zje - @ybzje)>0.1
begin
	select 'F','医保返回的总金额【'+convert(varchar,@ybzje)+'】和本地金额【'+convert(varchar,@zje)+'】相差大于0.1元，不能结算！'
	return
end

if @jslb = 0
begin
    --校验账户抵用金额
	select @zhdyje_hz = isnull(sum(isnull(dyje,0)),0) from YY_CQYB_ZYDYJLK(nolock) where syxh = @syxh and jsxh = @jsxh and jlzt = 1
	IF @zhdyje_hz = NULL 
		SELECT @zhdyje_hz = 0.00

	if @zhdyje <> @zhdyje_hz
	begin
		select "F","账户抵用金额计算错误!"
		return
	end
end
if @jslb = 1 
begin
	select @ybzje_ys = sum(isnull(je,0)) from ZY_BRJSJEK(nolock) 
	where jsxh = @jsxh and lx in ('yb01','yb02','yb03','yb04','yb05','yb08','yb11','yb13','yb24','yb25','yb26','yb27','yb28','yb30','yb31','yb32')
	
	if @configCQ01 = 'WD'
	begin
		select @ybzje_ys = @ybzje_ys + sum(isnull(je,0)) from ZY_BRJSJEK(nolock) where jsxh = @jsxh and lx in( 'yb09','yb12')
	end
    
	select @ybxjzf_ys = sum(isnull(je,0)) from ZY_BRJSJEK(nolock) where jsxh = @jsxh and lx in ('yb04','yb25','yb27')
	select @ybgwyfh_ys = isnull(je,0) from ZY_BRJSJEK(nolock) where jsxh = @jsxh and lx = 'yb06'
	select @zhdyje_ys = isnull(je,0) from ZY_BRJSJEK(nolock) where jsxh = @jsxh and lx = 'yb99'

	--校验账户抵用金额
	select @zhdyje_hz = sum(isnull(dyje,0)) from YY_CQYB_ZYDYJLK(nolock) where syxh = @syxh and jsxh = @jsxh and jlzt = 2
	IF @zhdyje_hz = NULL 
		SELECT @zhdyje_hz = 0.00

	if @zhdyje <> @zhdyje_hz
	begin
		select "F","账户抵用金额计算错误!"
		return
	end
end;

--计算医保病人自付金额=HIS总金额-(医保总金额-现金支付-生育现金支付-工伤现金支付)-账户抵用金额-历史起付线公务员返还
select @sfje = @zje - (@ybzje - @xjzf - @syxjzf - @gsxjzf) - @zhdyje - @lsqfxgwyfh

--医院垫支的算在病人头上(目前只有巴南人民医院)
if exists(select 1 from YY_CQYB_ZYJSJLK (nolock) where  jsxh=@jsxh and syxh=@syxh and jlzt in(1,2) and ddyljgbm in('10492'))
begin
	--贫困户不算在病人头上
	if not exists(select 1 from ZY_BRXXK a(nolock),ZY_BRSYK b(nolock) where a.patid=b.patid and b.syxh=@syxh and  isnull(a.pkhbz,0)<>1)
	begin
		if @dbzyljgdz>0 --大于0的才算
			select @sfje =  @sfje + @dbzyljgdz - @yycbkkje  --巴南要求改成单病种、药品超标病人支付,119945需求改成药品超标不由病人支付
	end
end

if @zje > 0
	select @xmzfbl = @sfje/@zje

select @sfje1=@sfje
	
select @srbz=config from YY_CONFIG (nolock) where id='5007'
if @@error<>0 or @@rowcount=0
	select @srbz='0'

declare @srfs varchar(1)  --0：精确到分，1：精确到角--20150430
select @srfs = config from YY_CONFIG (nolock) where id='2235'
if @@error <> 0 or @@rowcount = 0
select @srfs = '0'
if @srfs = '1'---，1：精确到角
begin 
	/*小数舍入处理 begin*/
	if @srbz = '5'
		select @sfje2 = round(@sfje1, 1)
	else if @srbz = '6'
		exec usp_yy_wslr @sfje1,1,@sfje2 output
	else if @srbz >= '1' and @srbz <= '9'
		exec usp_yy_wslr @sfje1,1,@sfje2 output,@srbz
	else
		select @sfje2 = @sfje1

	select @srje = @sfje2 - @sfje1
	/*小数舍入处理 begin*/
end
else 
	select @sfje2 = @sfje1

update ZY_BRJSMXK set zfje = 0 where jsxh=@jsxh  

select dxmdm,round((xmje-zfje-yhje)*@xmzfbl,2) as zfje, zfje as zfyje
into #sfmx2
from ZY_BRJSMXK(nolock) where jsxh = @jsxh
if @@rowcount>0
begin
	select @xmce=@sfje - sum(zfje) from #sfmx2
	update #sfmx2 set zfje = zfje + zfyje
		
	set rowcount 1
	update #sfmx2 set zfje = zfje + @xmce
	set rowcount 0
end

begin tran	
	if @jslb <> 2
	begin
		update ZY_BRJSK set zfje = @sfje2,
			zfyje = @zje - @ybzje,
			sybybzje = @ybzje-@xjzf-@syxjzf-@gsxjzf,
			srje = @srje,  
			jsrq = @now, 
			ybjszt = 1
			where syxh = @syxh and xh = @jsxh AND ybjszt <> 2 AND jlzt = 0
		if @@error <> 0 AND @@ROWCOUNT <> 1 
		begin
			select "F","保存结算1信息出错！"
			rollback tran
			return
		end	

		update ZY_BRJSMXK set zfje = b.zfje
		from ZY_BRJSMXK a,#sfmx2 b
			where a.jsxh = @jsxh and a.dxmdm = b.dxmdm
		if @@error <> 0
		begin
			select "F","保存结算1信息出错！"
			rollback tran
			return
		end
	end
	else
	begin
		update ZY_BRJSK set zfje = @sfje2,
			zfyje = @zje - @ybzje,
			sybybzje = @ybzje-@xjzf-@syxjzf-@gsxjzf,
			srje = @srje
			where syxh = @syxh and xh = @jsxh AND ybjszt <> 2 AND jlzt = 0
		if @@error <> 0 AND @@ROWCOUNT <> 1 
		begin
			select "F","保存结算1信息出错！"
			rollback tran
			return
		end	
	end

	delete from ZY_BRJSJEK where jsxh = @jsxh
	if @@error <> 0
	begin
		select "F","删除ZY_BRJSJEK信息出错！"
		rollback tran
		return
	end
	
	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, 'yb01', '统筹支付', @tczf, null)
	if @@error <> 0
	begin
		select "F","保存统筹支付信息出错！"
		rollback tran
		return
	end
	
	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, 'yb02', '账户支付', @zhzf, null)
	if @@error <> 0
	begin
		select "F","保存账户支付信息出错！"
		rollback tran
		return
	end
	
	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, 'yb03', '公务员补助', @gwybz, null)
	if @@error <> 0
	begin
		select "F","保存公务员补助信息出错！"
		rollback tran
		return
	end
	
	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, 'yb04', '现金支付', @xjzf, null)
	if @@error <> 0
	begin
		select "F","保存现金支付信息出错！"
		rollback tran
		return
	end

	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, 'yb05', '大额理赔金额', @delpje, null)
	if @@error <> 0
	begin
		select "F","保存大额理赔金额信息出错！"
		rollback tran
		return
	end

	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, 'yb06', '历史起付线公务员返还', @lsqfxgwyfh, null)
	if @@error <> 0
	begin
		select "F","保存历史起付线公务员返还信息出错！"
		rollback tran
		return
	end

	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, 'yb07', '账户余额', @zhye, null)
	if @@error <> 0
	begin
		select "F","保存账户余额信息出错！"
		rollback tran
		return
	end

	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, 'yb08', '单病种医疗机构垫支', @dbzyljgdz, null)
	if @@error <> 0
	begin
		select "F","保存单病种医疗机构垫支信息出错！"
		rollback tran
		return
	end

	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, 'yb09', '民政救助金额', @mzjzje, null)
	if @@error <> 0
	begin
		select "F","保存民政救助金额信息出错！"
		rollback tran
		return
	end

	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, 'yb10', '民政救助门诊余额', @mzjzmzye, null)
	if @@error <> 0
	begin
		select "F","保存民政救助门诊余额信息出错！"
		rollback tran
		return
	end

	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, 'yb11', '耐多药项目支付金额', @ndyxmzfje, null)
	if @@error <> 0
	begin
		select "F","保存耐多药项目支付金额信息出错！"
		rollback tran
		return
	end

	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, 'yb12', '一般诊疗支付数', @ybzlzfje, null)
	if @@error <> 0
	begin
		select "F","保存一般诊疗支付数信息出错！"
		rollback tran
		return
	end

	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, 'yb13', '神华救助基金支付数', @shjzjjzfje, null)
	if @@error <> 0
	begin
		select "F","保存神华救助基金支付数信息出错！"
		rollback tran
		return
	end

	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, 'yb14', '本年统筹支付累计', @bntczflj, null)
	if @@error <> 0
	begin
		select "F","保存本年统筹支付累计信息出错！"
		rollback tran
		return
	end

	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, 'yb15', '本年大额支付累计', @bndezflj, null)
	if @@error <> 0
	begin
		select "F","保存本年大额支付累计信息出错！"
		rollback tran
		return
	end

	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, 'yb16', '特病起付线支付累计', @tbqfxzflj, null)
	if @@error <> 0
	begin
		select "F","保存特病起付线支付累计信息出错！"
		rollback tran
		return
	end

	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, 'yb17', '耐多药项目累计', @ndyxmlj, null)
	if @@error <> 0
	begin
		select "F","保存耐多药项目累计信息出错！"
		rollback tran
		return
	end

	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, 'yb18', '本年民政救助住院支付累计', @bnmzjzzyzflj, null)
	if @@error <> 0
	begin
		select "F","保存本年民政救助住院支付累计信息出错！"
		rollback tran
		return
	end

	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, 'yb19', '中心结算时间', 0, @zxjssj)
	if @@error <> 0
	begin
		select "F","保存中心结算时间信息出错！"
		rollback tran
		return
	end

	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, 'yb20', '本次起付线支付金额', @bcqfxzfje, null)
	if @@error <> 0
	begin
		select "F","保存本次起付线支付金额信息出错！"
		rollback tran
		return
	end

	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, 'yb21', '本次进入医保范围费用', @bcjrybfwfy, null)
	if @@error <> 0
	begin
		select "F","保存本次进入医保范围费用信息出错！"
		rollback tran
		return
	end
	
	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, 'yb22', '药事服务费支付数', @ysfwzfje, null)
	if @@error <> 0
	begin
		select "F","保存药事服务费支付数信息出错！"
		rollback tran
		return
	end
	
	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, 'yb23', '医院超标扣款金额', @yycbkkje, null)
	if @@error <> 0
	begin
		select "F","保存医院超标扣款金额信息出错！"
		rollback tran
		return
	end
	
	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, 'yb24', '生育基金支付', @syjjzf, null)
	if @@error <> 0
	begin
		select "F","保存生育基金支付信息出错！"
		rollback tran
		return
	end
	
	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, 'yb25', '生育现金支付', @syxjzf, null)
	if @@error <> 0
	begin
		select "F","保存生育现金支付信息出错！"
		rollback tran
		return
	end
	
	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, 'yb26', '工伤基金支付', @gsjjzf, null)
	if @@error <> 0
	begin
		select "F","保存工伤基金支付信息出错！"
		rollback tran
		return
	end
	
	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, 'yb27', '工伤现金支付', @gsxjzf, null)
	if @@error <> 0
	begin
		select "F","保存工伤现金支付信息出错！"
		rollback tran
		return
	end
	
	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, 'yb28', '工伤单病种机构垫支', @gsdbzjgdz, null)
	if @@error <> 0
	begin
		select "F","保存工伤单病种机构垫支信息出错！"
		rollback tran
		return
	end
	
	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, 'yb29', '工伤全自费原因', 0, @gsqzfyy)
	if @@error <> 0
	begin
		select "F","保存工伤全自费原因信息出错！"
		rollback tran
		return
	end
	
	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, 'yb30', '其他补助', @qtbz, null)
	if @@error <> 0
	begin
		select "F","保存其他补助信息出错!"
		rollback tran
		return
	END
	
	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, 'yb31', '生育账户支付', @syzhzf ,null)
	if @@error <> 0
	begin
		select "F","保存生育账户支付信息出错!"
		rollback tran
		return
	END
	
	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, 'yb32', '工伤账户支付', @gszhzf, null)
	if @@error <> 0
	begin
		select "F","保存工伤账户支付信息出错!"
		rollback tran
		return
	end

	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, 'yb33', '本次结算扶贫人员类别', 0, @bcjsfprylb)
	if @@error <> 0
	begin
		select "F","保存本次结算扶贫人员类别信息出错!"
		rollback tran
		return
	end

	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, 'yb34', '健康扶贫医疗基金', @jkfpyljj, NULL)
	if @@error <> 0
	begin
		select "F","保存健康扶贫医疗基金信息出错!"
		rollback tran
		return
	end
	
	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, 'yb35', '精准脱贫保险金额', @jztpbxje, NULL)
	if @@error <> 0
	begin
		select "F","保存精准脱贫保险金额信息出错!"
		rollback tran
		return
	end

	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, 'yb36', '其他扶贫报销金额', @qtfpbxje, NULL)
	if @@error <> 0
	begin
		select "F","保存其他扶贫报销金额信息出错!"
		rollback tran
		return
	end
	
	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)                            
	values(@jsxh, 'yb98', '医保差额', @zje-@ybzje, null)  ----本地HIS总金额和医保返回总金额的差额                                  
	if @@error<>0                                    
	begin                                   
	   select "F","保存医保差额信息出错！"                                    
	   rollback tran                                    
	   return                                    
	end

	insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
	values(@jsxh, 'yb99', '账户抵用金额', @zhdyje, null)
	if @@error <> 0
	begin
		select "F","保存账户抵用金额信息出错！"
		rollback tran
		return
	end

	IF EXISTS(SELECT 1 FROM YY_YBMRJYK(nolock) where syxh = @syxh and jsxh = @jsxh and fyrq = convert(varchar(8),getdate(),112) )
	BEGIN
		update YY_YBMRJYK set ybje = @ybzje, 
			zfyje = zje - @ybzje,
			jsxjzf = @xjzf + @syxjzf + @gsxjzf,
			jszhzf = @zhzf + @syzhzf + @gszhzf,
			jstczf = @tczf + @syjjzf + @gsjjzf + @qtbz,
			jsdbzf = @delpje,
			jsgwybz = @gwybz,
			jsgwyret = @lsqfxgwyfh,
			mzjzje = @mzjzje,
			mzjzmzye = @mzjzmzye,
			jlzt = 1
		where syxh = @syxh and jsxh = @jsxh and fyrq = convert(varchar(8),getdate(),112)		
	END
	ELSE
	BEGIN
		DECLARE @tmp_yjlj ut_money--押金累计	
		SELECT @tmp_yjlj = isnull(sum(ISNULL(jje,0)-ISNULL(dje,0)),0) 
		FROM ZYB_BRYJK c(nolock) WHERE c.syxh = @syxh AND c.jsxh = @jsxh;
  		
		INSERT INTO YY_YBMRJYK
		(syxh,centerid,jsxh,fyrq,jlzt,yjlj,zje,yhje,zfyje,ybje,jsxjzf,
		jszhzf,jstczf,jsdbzf,jsgwybz,jsgwyret,mzjzje,mzjzmzye)
		SELECT @syxh,a.centerid,@jsxh,convert(varchar(8),getdate(),112),1,@tmp_yjlj,b.zje,b.yhje,b.zje - @ybzje,@ybzje,@xjzf + @syxjzf + @gsxjzf,
		@zhzf + @syzhzf + @gszhzf,@tczf + @syjjzf + @gsjjzf + @qtbz,@delpje,@gwybz,@lsqfxgwyfh,@mzjzje,@mzjzmzye
		from ZY_BRSYK a (nolock) INNER JOIN ZY_BRJSK b (nolock) ON a.syxh = b.syxh  
		where a.syxh = @syxh AND b.xh = @jsxh and a.brzt in (1,2,5,6,7) and b.jlzt=0 and b.jszt=0 and b.ybjszt not in (2,5);			
	END;

	if @@error <> 0
	begin
		select "F","更新YY_YBMRJYK信息出错！"
		rollback tran
		return
	end
		
	
commit tran
	
if @jslb = 1
begin
	if abs(@ybzje - @ybzje_ys) > 0.1 or abs(@xjzf + @syxjzf + @gsxjzf - @ybxjzf_ys) > 0.1 or abs(@lsqfxgwyfh - @ybgwyfh_ys) > 0.1
		or abs(@zhdyje - @zhdyje_ys) > 0.1
	begin
	     if abs(@ybzje - @ybzje_ys) > 0.1
			select @ts_msg=@ts_msg+"\n医保预算总金额【"+convert(varchar(100),@ybzje_ys)+"】医保结算总金额【"++convert(varchar(100),@ybzje)+"】"
		if abs(@xjzf + @syxjzf + @gsxjzf - @ybxjzf_ys) > 0.1
			select  @ts_msg=@ts_msg+"\n医保预算现金支付【"+convert(varchar(100),@ybxjzf_ys)+"】医保结算现金支付【"++convert(varchar(100),@xjzf + @syxjzf + @gsxjzf)+"】"
		if abs(@lsqfxgwyfh - @ybgwyfh_ys) > 0.1
			select  @ts_msg=@ts_msg+"\n医保预算公务员返还【"+convert(varchar(100),@ybgwyfh_ys)+"】医保结算公务员返还【"++convert(varchar(100),@lsqfxgwyfh)+"】"

	    select "R","医保正式结算金额与医保预算时不一致!请按住院结算发票上的金额收费!"+@ts_msg+"\n*注意*已知晓请点击[是]"
	    return
	end
end

select "T", @sfje2

return

GO
SET ANSI_WARNINGS on
SET ANSI_NULLS on
GO
