if exists(select 1 from sysobjects where name = 'usp_cqyb_saveaccinfo')
  drop proc usp_cqyb_saveaccinfo
go

CREATE proc usp_cqyb_saveaccinfo
(
	@sbkh				varchar(20),		--社会保障号码
	@xzlb				varchar(10),		--险种类别
    --医疗保险返回参数
    @zhye				ut_money=0,			--账户余额
    @bntczflj			ut_money=0,			--本年统筹支付累计
    @bntsmzqfbzljzf		ut_money=0,			--本年特殊门诊起付标准支付累计
    @bntsmzybflj		ut_money=0,			--本年特殊门诊医保费累计
    @bnexzlzyqfbzzflj	ut_money=0,			--本年恶性肿瘤住院起付标准支付累计
    @bnfhgwyfwmzfylj	ut_money=0,			--本年符合公务员范围门诊费用累计
    @bnzycs				varchar(10)='',		--本年住院次数
    @zyzt				varchar(2)='',		--住院状态
    @bntbmzxbzzfje		ut_money=0,			--本年特病门诊还需补助的自付金额
    @bnzyxbzzfje		ut_money=0,			--本年住院还需补助的自付金额
    @bnfsgexzlbz		varchar(10)='',		--本年发生过恶性肿瘤标志
    @bndbzflj			ut_money=0,			--本年大病支付累计
    @jbzdjbfsbz			varchar(10)='',		--居保重大疾病发生标志
    @bnywshzflj			ut_money=0,			--本年意外伤害支付累计
    @bnndyjhzflj		ut_money=0,			--本年耐多药结核支付累计
    @bnetlbzflj			ut_money=0,			--本年儿童两病支付累计
    @bnkfxmzflj			ut_money=0,			--本年康复项目支付累计
    @ndmzzyzflj			ut_money=0,			--年度民政住院支付累计
    @ndmzmzzflj			ut_money=0,			--年度民政门诊支付累计
    @jxbzlj				ut_money=0,			--降消补助累计
    @ndptmzzflj			ut_money=0,			--年度普通门诊支付累计
    @yddjbz				varchar(10)='',		--异地登记标志
    @zhxxyly			ut_money=0,			--账户信息预留1
    @zhxxyle			ut_money=0,			--账户信息预留2
    --工伤保险返回参数
    @cfxmtslj			ut_money=0,			--尘肺项目天数累计
    @gszyzt				varchar(2)='',		--工伤住院状态
    --生育保险返回参数
    @byqcqjczflj		ut_money=0,			--本孕期产前检查支付累计
    @byqycbjyjczflj		ut_money=0,			--本孕期遗传病检查支付累计
    @byqjhsysszflj		ut_money=0,			--本孕期计划生育手术支付累计
    @byqfmzzrsylfzflj	ut_money=0,			--本孕期分娩或终止妊娠医疗费支付累计
    @byqbfzzflj			ut_money=0,			--本孕期并发症支付累计
    @syzyzt				varchar(2)=''		--生育住院状态
)
as
/****************************************
[版本号]4.0.0.0.0
[创建时间]2017.03.05
[作者]FerryMan
[版权]Copyright ? 1998-2017卫宁健康科技集团股份有限公司
[描述]保存医保病人账户基础信息
[功能说明]
	 保存医保病人账户基础信息
[参数说明]
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]
[修改记录]
****************************************/
set nocount on
	
if not exists(select 1 from YY_CQYB_ACCINFO where sbkh = @sbkh)
begin
	if @xzlb = '1'			--医疗保险
	begin
		insert into YY_CQYB_ACCINFO(sbkh,zhye,bntczflj,bntsmzqfbzljzf,bntsmzybflj,bnexzlzyqfbzzflj,bnfhgwyfwmzfylj,bnzycs,zyzt,bntbmzxbzzfje,
			bnzyxbzzfje,bnfsgexzlbz,bndbzflj,jbzdjbfsbz,bnywshzflj,bnndyjhzflj,bnetlbzflj,bnkfxmzflj,ndmzzyzflj,ndmzmzzflj,jxbzlj,ndptmzzflj,
			yddjbz,zhxxyly,zhxxyle)
		select @sbkh,@zhye,@bntczflj,@bntsmzqfbzljzf,@bntsmzybflj,@bnexzlzyqfbzzflj,@bnfhgwyfwmzfylj,@bnzycs,@zyzt,@bntbmzxbzzfje,@bnzyxbzzfje,
			@bnfsgexzlbz,@bndbzflj,@jbzdjbfsbz,@bnywshzflj,@bnndyjhzflj,@bnetlbzflj,@bnkfxmzflj,@ndmzzyzflj,@ndmzmzzflj,@jxbzlj,@ndptmzzflj,
			@yddjbz,@zhxxyly,@zhxxyle 
		if @@error<>0 or @@rowcount = 0 
		begin
			select "F","保存医保病人(医疗保险)账户基础信息失败!"
			return
		end;
	end
	else if @xzlb = '2'		--工伤保险
	begin
		insert into YY_CQYB_ACCINFO(sbkh,cfxmtslj,gszyzt)
		select @sbkh,@cfxmtslj,@gszyzt
		if @@error<>0 or @@rowcount = 0 
		begin
			select "F","保存医保病人(工伤保险)账户基础信息失败!"
			return
		end;
	end
	else if @xzlb = '3'		--生育保险
	begin
		insert into YY_CQYB_ACCINFO(sbkh,byqcqjczflj,byqycbjyjczflj,byqjhsysszflj,byqfmzzrsylfzflj,byqbfzzflj,syzyzt)
		select @sbkh,@byqcqjczflj,@byqycbjyjczflj,@byqjhsysszflj,@byqfmzzrsylfzflj,@byqbfzzflj,@syzyzt
		if @@error<>0 or @@rowcount = 0 
		begin
			select "F","保存医保病人(生育保险)账户基础信息失败!"
			return
		end;
	end;
end
else
begin
	if @xzlb = '1'			--医疗保险
	begin
		update YY_CQYB_ACCINFO set zhye = @zhye,bntczflj= @bntczflj,bntsmzqfbzljzf = @bntsmzqfbzljzf,bntsmzybflj = @bntsmzybflj,
			bnexzlzyqfbzzflj = @bnexzlzyqfbzzflj,bnfhgwyfwmzfylj = @bnfhgwyfwmzfylj,bnzycs = @bnzycs,zyzt = @zyzt,bntbmzxbzzfje = @bntbmzxbzzfje,
			bnzyxbzzfje = @bnzyxbzzfje,bnfsgexzlbz = @bnfsgexzlbz,bndbzflj = @bndbzflj,jbzdjbfsbz = @jbzdjbfsbz,bnywshzflj = @bnywshzflj,
			bnndyjhzflj= @bnndyjhzflj,bnetlbzflj = @bnetlbzflj,bnkfxmzflj = @bnkfxmzflj,ndmzzyzflj = @ndmzzyzflj,ndmzmzzflj = @ndmzmzzflj,
			jxbzlj = @jxbzlj,ndptmzzflj = @ndptmzzflj,yddjbz = @yddjbz,zhxxyly = @zhxxyly,zhxxyle = @zhxxyle
		where sbkh = @sbkh
		if @@error<>0 or @@rowcount = 0 
		begin
			select "F","更新医保病人(医疗保险)账户基础信息失败!"
			return
		end;
	end
	else if @xzlb = '2'		--工伤保险
	begin
		update YY_CQYB_ACCINFO set cfxmtslj = @cfxmtslj,gszyzt = @gszyzt
		where sbkh = @sbkh
		if @@error<>0 or @@rowcount = 0 
		begin
			select "F","更新医保病人(工伤保险)账户基础信息失败!"
			return
		end;
	end
	else if @xzlb = '3'		--生育保险
	begin
		update YY_CQYB_ACCINFO set byqcqjczflj = @byqcqjczflj,byqycbjyjczflj = @byqycbjyjczflj,byqjhsysszflj = @byqjhsysszflj,
			byqfmzzrsylfzflj = @byqfmzzrsylfzflj,byqbfzzflj = @byqbfzzflj,syzyzt = @syzyzt
		where sbkh = @sbkh
		if @@error<>0 or @@rowcount = 0 
		begin
			select "F","更新医保病人(生育保险)账户基础信息失败!"
			return
		end;
	end;
end

select "T"
return
GO
