--医保病人账户基础信息
if not exists(select 1 from sysobjects where name='YY_CQYB_ACCINFO')
begin  
	create table YY_CQYB_ACCINFO
	(      
        sbkh			varchar(20)	not	null,	--社会保障号码
        --医疗保险返回参数
        zhye			ut_money		null,   --账户余额
        bntczflj		ut_money		null,   --本年统筹支付累计
        bntsmzqfbzljzf  ut_money		null,	--本年特殊门诊起付标准支付累计
        bntsmzybflj		ut_money		null,   --本年特殊门诊医保费累计
        bnexzlzyqfbzzflj ut_money		null,	--本年恶性肿瘤住院起付标准支付累计
        bnfhgwyfwmzfylj ut_money		null,	--本年符合公务员范围门诊费用累计
        bnzycs			varchar(10)		null,   --本年住院次数
        zyzt			varchar(2)		null,   --住院状态
        bntbmzxbzzfje   ut_money		null,	--本年特病门诊还需补助的自付金额
        bnzyxbzzfje		ut_money		null,   --本年住院还需补助的自付金额
        bnfsgexzlbz		varchar(10)		null,   --本年发生过恶性肿瘤标志
        bndbzflj		ut_money		null,   --本年大病支付累计
        jbzdjbfsbz		varchar(10)		null,   --居保重大疾病发生标志
        bnywshzflj		ut_money		null,   --本年意外伤害支付累计
        bnndyjhzflj		ut_money		null,   --本年耐多药结核支付累计
        bnetlbzflj		ut_money		null,   --本年儿童两病支付累计
        bnkfxmzflj		ut_money		null,   --本年康复项目支付累计
        ndmzzyzflj		ut_money		null,   --年度民政住院支付累计
        ndmzmzzflj		ut_money		null,   --年度民政门诊支付累计
        jxbzlj			ut_money		null,   --降消补助累计
        ndptmzzflj		ut_money		null,   --年度普通门诊支付累计
        yddjbz			varchar(10)		null,   --异地登记标志
        zhxxyly			ut_money		null,   --账户信息预留1
        zhxxyle			ut_money		null,   --账户信息预留2
        --工伤保险返回参数
        cfxmtslj		ut_money		null,   --尘肺项目天数累计
        gszyzt			varchar(2)		null,   --工伤住院状态
        --生育保险返回参数
        byqcqjczflj		ut_money		null,   --本孕期产前检查支付累计
        byqycbjyjczflj  ut_money		null,   --本孕期遗传病检查支付累计
        byqjhsysszflj   ut_money		null,	--本孕期计划生育手术支付累计
        byqfmzzrsylfzflj ut_money    	null,   --本孕期分娩或终止妊娠医疗费支付累计
        byqbfzzflj		ut_money		null,   --本孕期并发症支付累计
        syzyzt			varchar(2)		null,   --生育住院状态        
		constraint PK_YY_CQYB_ACCINFO primary key(sbkh)
	)
	create index idx_sbkh on YY_CQYB_ACCINFO(sbkh)	
end
go 

