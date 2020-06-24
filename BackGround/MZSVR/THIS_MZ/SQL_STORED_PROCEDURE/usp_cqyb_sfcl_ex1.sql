Text
CREATE proc usp_cqyb_sfcl_ex1
(
	@jssjh			ut_sjh,			--收据号
	@jslb			ut_bz,			--0预算1结算
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
/****************************************
[版本号]4.0.0.0.0
[创建时间]2017.03.05
[作者]FerryMan
[版权]Copyright ? 1998-2017卫宁健康科技集团股份有限公司
[描述]保存医保结算金额信息
[功能说明]
	保存医保结算金额信息
[参数说明]
	@jssjh	--收据号
	@jslb	--0预算1结算
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]
[修改记录]
统筹+账户+公务员补助+现金支付+大额理赔金额+单病种定点医疗机构垫支+耐多药项目支付金额+一般诊疗支付数+神华救助基金支付数
+生育基金支付+生育现金支付+工伤基金支付+工伤现金支付+工伤单病种机构垫支
****************************************/
set nocount on

declare	@patid		ut_xh12,		--患者id
		@now		ut_rq16,		--当前时间
		@srbz		ut_bz,			--舍入标志
		@zje		ut_money,		--总金额
		@ybzje		ut_money,		--医保总金额
		@sfje		ut_money,		--实收金额
		@sfje1		ut_money,		--实收金额
		@sfje2		ut_money,		--舍入后的实收金额
		@srje		ut_money,		--舍入金额
		@xmzfbl		numeric(8,4),	--自负比例	
		@xmce		ut_money,		--自付金额和大项自付金额汇总的差额
		@yjbz		ut_bz,			--是否使用充值卡
		@yjye		ut_money,		--预交金余额
		@yjzfje		ut_money,		--预交金支付余额
		@yjyebz		varchar(2),  	--充值卡余额不足是否允许继续收费
		@qkbz		ut_bz,			--欠款标志0：正常，1：记账，2：欠费
		@qkje		ut_money,		--欠款金额（记账金额）
		@ybzje_ys	ut_money,		--医保预算总金额
		@ybxjzf_ys	ut_money,		--医保预算个人自费金额
		@ybgwyfh_ys	ut_money,		--医保预算公务员返还
		@zhdyje_ys	ut_money,		--医保预算账户抵用金额
		@zhdyje_hz	ut_money,		--账户抵用金额总和
		@czksfbz	ut_bz,			--充值卡收费标志
		@byzg_yhje	ut_money,		--本院职工优惠金额
        @errmsg      varchar(100),
		@configCQ01 varchar(10)
		,@config2136 varchar(10)='否'  --tsyhje特殊优惠 
		,@tsyhje	ut_money		--tsyhje和参数2136有关,总金额要传到医保，这里是医保报销之后再优惠

select @now=convert(char(8),getdate(),112) + convert(char(8),getdate(),8),
	   @zje=0, @ybzje=0, @sfje=0, @sfje1=0, @sfje2=0, @srje=0, @xmzfbl=0, 
	   @xmce=0, @yjbz=0, @yjye=0, @yjzfje=0, @qkbz=0, @qkje=0, @ybzje_ys=0,  
	   @ybxjzf_ys=0, @ybgwyfh_ys=0, @zhdyje_ys=0, @zhdyje_hz=0, @czksfbz=1,@byzg_yhje=0,@errmsg=''
	   ,@tsyhje=0

--计算HIS总金额
select @patid = patid,@zje = zje-yhje ,@tsyhje=tsyhje  
--(CASE ghsfbz WHEN 1 then zje-yhje ELSE zje END)  --挂号也有优惠
 FROM SF_BRJSK(nolock) where sjh = @jssjh
if @@rowcount=0
begin
	select "F","该收费结算记录不存在!"
	return
end

select @configCQ01 = ISNULL(config,'DR') from YY_CONFIG where id = 'CQ01'
select @config2136=ISNULL(config,'否') from YY_CONFIG where id = '2136'
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
    select @ybzje = @ybzje + @mzjzje --+@ybzlzfje --20181016暂时不确定，万达一级医院统筹是否包含一般诊疗支付
END

if abs(@zje - @ybzje)>0.1
begin
	select "F","HIS总额和医保总额不一致!"
	return
end

----chenhong add 20191125 根据医院要求修改 begin
if exists (select 1 from SF_JEMXK a(nolock) where jssjh=@jssjh and a.lx='yb23' and je>19)
begin
	select "F","医院垫付金额大于1元，不能结算！"
	return
end
----chenhong add 20191125 根据医院要求修改 end

if @jslb = 0
begin
    --校验账户抵用金额
    IF EXISTS (SELECT 1 FROM YY_CQYB_MZDYJLK(nolock) where jssjh = @jssjh and jlzt = 1)
	begin
		select @zhdyje_hz = ISNULL(sum(isnull(dyje,0)),0) from YY_CQYB_MZDYJLK(nolock) where jssjh = @jssjh and jlzt = 1
	
		if @zhdyje <> @zhdyje_hz
		begin
			select "F","账户抵用金额计算错误!"
			return
		END
    end
end
if @jslb = 1 
begin
	select @ybzje_ys = sum(isnull(je,0)) from SF_JEMXK(nolock) 
	where jssjh = @jssjh and lx in ('yb01','yb02','yb03','yb04','yb05','yb08','yb11','yb13','yb24','yb25','yb26','yb27','yb28','yb30','yb31','yb32')
	
	if @configCQ01 = 'WD'
	begin
		select @ybzje_ys = @ybzje_ys + sum(isnull(je,0)) from SF_JEMXK(nolock) where jssjh = @jssjh and lx in( 'yb09','yb12')--20181016暂时不确定yb12,先写上
	end

	select @ybxjzf_ys = sum(isnull(je,0)) from SF_JEMXK(nolock) where jssjh = @jssjh and lx in ('yb04','yb25','yb27')
	
	select @ybgwyfh_ys = isnull(je,0) from SF_JEMXK(nolock) where jssjh = @jssjh and lx = 'yb06'
	
	select @zhdyje_ys = isnull(je,0) from SF_JEMXK(nolock) where jssjh = @jssjh and lx = 'yb99'
	
	--校验账户抵用金额
	select @zhdyje_hz = ISNULL(sum(isnull(dyje,0)),0) from YY_CQYB_MZDYJLK(nolock) where jssjh = @jssjh and jlzt = 2
	
	if @zhdyje <> @zhdyje_hz
	begin
		select "F","账户抵用金额计算错误!"
		return
	end
end;

--计算医保病人自付金额=HIS总金额-(医保总金额-现金支付-生育现金支付-工伤现金支付)-账户抵用金额-历史起付线公务员返还 -(特殊优惠金额)
select @sfje = @zje - (@ybzje - @xjzf - @syxjzf - @gsxjzf) - @zhdyje - @lsqfxgwyfh -(case when @config2136='是' and @jslb=1 then @tsyhje else 0 end )

--本院职工挂号优惠金额@byzg_yhje
IF EXISTS(select 1 from SF_BRJSK(nolock) where sjh = @jssjh AND ISNULL(ghsfbz,0)=0)
BEGIN
    EXEC usp_cqyb_ynzg_gh '02',@jssjh,@sfje,@errmsg OUTPUT,@byzg_yhje OUTPUT
    if @errmsg like "F%"
	begin
		select "F",@errmsg
		return 
	END
	SELECT @sfje = @sfje - @byzg_yhje
END

select @yjye = yjye from YY_JZBRK(nolock) where patid = @patid and jlzt = 0
if @@rowcount = 0
	select @yjye = 0
else
	select @yjbz = 1

select @yjyebz = config from YY_CONFIG where id = '2059'
if @@rowcount = 0 or @@error <> 0
begin
	select "F","充值卡余额不足是否允许继续收费设置不正确!"
	return
end

if @zje > 0
	select @xmzfbl = @sfje/@zje

select @sfje1 = @sfje
select @srbz = config from YY_CONFIG (nolock) where id='2016'
if @@error <> 0 or @@rowcount = 0
	select @srbz = '0'

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

--纠正部分退费余额    
if exists(select 1 from SF_BRJSK(nolock) where sjh = @jssjh and isnull(tsjh,'') <> '' and qkbz = 3)
begin
    select @yjye = @yjye - b.qkje
    from SF_BRJSK a(nolock),VW_MZBRJSK b(nolock)
    where a.sjh = @jssjh and a.tsjh = b.sjh
end 

if @czksfbz = 1 --从充值卡收费
begin
	if @yjbz = 1
	begin
		if @yjyebz = '否' and @yjye < @sfje2
		begin
			select 'F','充值卡余额不足,请先充值:自负金额【'+convert(varchar(20),@sfje2)+'元】，押金余额【'+convert(varchar(20),@yjye)+'元】，差额【'+convert(varchar(20),@sfje2-@yjye)+'元】!' 
			return
		end
	
		if (@yjye > 0) and (@sfje2 > 0)
		begin
			if @sfje2 <= @yjye
				select @qkje = @sfje2
			else
			begin
				select @qkje = @yjye
				if @srfs = '1'---1：精确到角则先舍入20110426
				begin
					select @qkje = round(@yjye,1,1) ---去掉小数位
				end 
	        end
	        select @qkbz = 3,@yjzfje = @qkje
		end
	end
end

--处理大项汇总金额
select dxmdm,round((xmje-zfyje-yhje)*@xmzfbl,2) as zfje,zfyje
into #sfmx2
from SF_BRJSMXK(nolock) where jssjh = @jssjh
if @@rowcount>0
begin
	select @xmce = @sfje - sum(zfje) from #sfmx2
	update #sfmx2 set zfje = zfje + zfyje
		
	set rowcount 1
	update #sfmx2 set zfje = zfje + @xmce
	set rowcount 0
end
	
begin tran
	update SF_BRJSK set sfrq = @now,
		zfje = @sfje2,
		srje = @srje,
		ybjszt = 1,
		qkje = @qkje,
		qkbz = @qkbz,
		yhje = ISNULL(yhje,0) + @byzg_yhje,
		zxlsh = @zxlsh
	where sjh = @jssjh
	if @@error <> 0
	begin
		select "F","保存结算信息出错!"
		rollback tran
		return
	end

	update SF_BRJSMXK set zfje = b.zfje
	from SF_BRJSMXK a,#sfmx2 b
	where a.jssjh = @jssjh and a.dxmdm = b.dxmdm
	if @@error <> 0
	begin
		select "F","保存结算明细信息出错!"
		rollback tran
		return
	end

	delete from SF_JEMXK where jssjh = @jssjh
	if @@error <> 0
	begin
		select "F","删除结算金额信息出错!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb01', '统筹支付', @tczf, null)
	if @@error <> 0
	begin
		select "F","保存统筹支付信息出错!"
		rollback tran
		return
	end
	
	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb02', '账户支付', @zhzf, null)
	if @@error <> 0
	begin
		select "F","保存账户支付信息出错!"
		rollback tran
		return
	end
	
	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb03', '公务员补助', @gwybz, null)
	if @@error <> 0
	begin
		select "F","保存公务员补助信息出错!"
		rollback tran
		return
	end
	
	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb04', '现金支付', @xjzf, null)
	if @@error <> 0
	begin
		select "F","保存现金支付信息出错!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb05', '大额理赔金额', @delpje, null)
	if @@error <> 0
	begin
		select "F","保存大额理赔金额信息出错!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb06', '历史起付线公务员返还', @lsqfxgwyfh, null)
	if @@error <> 0
	begin
		select "F","保存历史起付线公务员返还信息出错!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb07', '账户余额', @zhye, null)
	if @@error <> 0
	begin
		select "F","保存账户余额信息出错!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb08', '单病种医疗机构垫支', @dbzyljgdz, null)
	if @@error <> 0
	begin
		select "F","保存单病种医疗机构垫支信息出错!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb09', '民政救助金额', @mzjzje, null)
	if @@error <> 0
	begin
		select "F","保存民政救助金额信息出错!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb10', '民政救助门诊余额', @mzjzmzye, null)
	if @@error <> 0
	begin
		select "F","保存民政救助门诊余额信息出错!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb11', '耐多药项目支付金额', @ndyxmzfje, null)
	if @@error <> 0
	begin
		select "F","保存耐多药项目支付金额信息出错!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb12', '一般诊疗支付数', @ybzlzfje, null)
	if @@error <> 0
	begin
		select "F","保存一般诊疗支付数信息出错!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb13', '神华救助基金支付数', @shjzjjzfje, null)
	if @@error <> 0
	begin
		select "F","保存神华救助基金支付数信息出错!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb14', '本年统筹支付累计', @bntczflj, null)
	if @@error <> 0
	begin
		select "F","保存本年统筹支付累计信息出错!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb15', '本年大额支付累计', @bndezflj, null)
	if @@error <> 0
	begin
		select "F","保存本年大额支付累计信息出错!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb16', '特病起付线支付累计', @tbqfxzflj, null)
	if @@error <> 0
	begin
		select "F","保存特病起付线支付累计信息出错!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb17', '耐多药项目累计', @ndyxmlj, null)
	if @@error <> 0
	begin
		select "F","保存耐多药项目累计信息出错!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb18', '本年民政救助住院支付累计', @bnmzjzzyzflj, null)
	if @@error <> 0
	begin
		select "F","保存本年民政救助住院支付累计信息出错!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb19', '中心结算时间', 0, @zxjssj)
	if @@error <> 0
	begin
		select "F","保存中心结算时间信息出错!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb20', '本次起付线支付金额', @bcqfxzfje, null)
	if @@error <> 0
	begin
		select "F","保存本次起付线支付金额信息出错!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb21', '本次进入医保范围费用', @bcjrybfwfy, null)
	if @@error <> 0
	begin
		select "F","保存本次进入医保范围费用信息出错!"
		rollback tran
		return
	end
	
	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb22', '药事服务费支付数', @ysfwzfje, null)
	if @@error <> 0
	begin
		select "F","保存药事服务费支付数信息出错!"
		rollback tran
		return
	end
	
	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb23', '医院超标扣款金额', @yycbkkje, null)
	if @@error <> 0
	begin
		select "F","保存医院超标扣款金额信息出错!"
		rollback tran
		return
	end
	
	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb24', '生育基金支付', @syjjzf, null)
	if @@error <> 0
	begin
		select "F","保存生育基金支付信息出错!"
		rollback tran
		return
	end
	
	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb25', '生育现金支付', @syxjzf, null)
	if @@error <> 0
	begin
		select "F","保存生育现金支付信息出错!"
		rollback tran
		return
	end
	
	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb26', '工伤基金支付', @gsjjzf, null)
	if @@error <> 0
	begin
		select "F","保存工伤基金支付信息出错!"
		rollback tran
		return
	end
	
	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb27', '工伤现金支付', @gsxjzf, null)
	if @@error <> 0
	begin
		select "F","保存工伤现金支付信息出错!"
		rollback tran
		return
	end
	
	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb28', '工伤单病种机构垫支', @gsdbzjgdz, null)
	if @@error <> 0
	begin
		select "F","保存工伤单病种机构垫支信息出错!"
		rollback tran
		return
	end
	
	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb29', '工伤全自费原因', 0, @gsqzfyy)
	if @@error <> 0
	begin
		select "F","保存工伤全自费原因信息出错!"
		rollback tran
		return
	END
	
	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb30', '其他补助', @qtbz, NULL)
	if @@error <> 0
	begin
		select "F","保存其他补助信息出错!"
		rollback tran
		return
	END
	
	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb31', '生育账户支付', @syzhzf, NULL)
	if @@error <> 0
	begin
		select "F","保存生育账户支付信息出错!"
		rollback tran
		return
	END
	
	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb32', '工伤账户支付', @gszhzf, NULL)
	if @@error <> 0
	begin
		select "F","保存工伤账户支付信息出错!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb33', '本次结算扶贫人员类别', 0, @bcjsfprylb)
	if @@error <> 0
	begin
		select "F","保存本次结算扶贫人员类别信息出错!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb34', '健康扶贫医疗基金', @jkfpyljj, NULL)
	if @@error <> 0
	begin
		select "F","保存健康扶贫医疗基金信息出错!"
		rollback tran
		return
	end
	
	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb35', '精准脱贫保险金额', @jztpbxje, NULL)
	if @@error <> 0
	begin
		select "F","保存精准脱贫保险金额信息出错!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb36', '其他扶贫报销金额', @qtfpbxje, NULL)
	if @@error <> 0
	begin
		select "F","保存其他扶贫报销金额信息出错!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb99', '账户抵用金额', @zhdyje, null)
	if @@error <> 0
	begin
		select "F","保存账户抵用金额信息出错!"
		rollback tran
		return
	end
commit tran
	
if @jslb = 1
begin
	if abs(@ybzje - @ybzje_ys) > 0.1 or abs(@xjzf + @syxjzf + @gsxjzf - @ybxjzf_ys) > 0.1 or abs(@lsqfxgwyfh - @ybgwyfh_ys) > 0.1
		or abs(@zhdyje - @zhdyje_ys) > 0.1
	begin
	    select "R","医保正式结算时金额与医保预算时不一致!请按门诊收费发票上的金额收费!"
	    return
	end
end

select "T", @sfje2, @qkbz, @yjzfje

return


