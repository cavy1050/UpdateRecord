if exists(select 1 from sysobjects where name = 'usp_cqyb_getpatinfo')
  drop proc usp_cqyb_getpatinfo
go
Create proc usp_cqyb_getpatinfo
(
	@sbkh				varchar(20)			--社会保障号码
)
as
/****************************************
[版本号]4.0.0.0.0
[创建时间]2017.03.05
[作者]FerryMan
[版权]Copyright ? 1998-2017卫宁健康科技集团股份有限公司
[描述]获取医保病人基本信息及账户信息
[功能说明]
	获取医保病人基本信息及账户信息
	可以自行添加和删除，前台展示顺序由字段先后顺序决定，参数CQ04和CQ24相关
[参数说明]
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]
[修改记录] 
****************************************/
set nocount on 

select a.sbkh as "社保卡号",a.name as "姓名",a.sex as "性别",a.age+'岁' as "年龄",a.sfzh as "身份证号",a.nation as "民族",
a.rylb as "在职",a.dwmc as "单位名称",c.name as "行政区划",case when a.fszk = '0' then '' else d.name end as "封锁状况",
fsyy as "封锁原因",e.name as "参保类别",b.zhye as "账户余额",bnzycs as "本年住院次数",
case when b.zyzt = '0' then "未住院" else "在住院" end as "住院状态",ISNULL(f.name,a.mzrylb) "民政人员类别",
b.bntczflj  as "统筹支付累积",b.bntsmzybflj as "特殊门诊医保费累计",b.bntsmzqfbzljzf as "本年特殊门诊起付标准累计"
,b.bnexzlzyqfbzzflj as "本年恶性肿瘤住院起付标准累计",b.bnfhgwyfwmzfylj as "本年符合公务员范围门诊费用累计" ,
a.address AS "住址" ,a.dqfprylb "当前扶贫人员类别"
from YY_CQYB_PATINFO a(nolock)
	left join YY_CQYB_ACCINFO b(nolock) on a.sbkh = b.sbkh
	left join YY_CQYB_YBSJZD c(nolock) on a.xzqhbm = c.code and c.zdlb = 'XZQH'
	left join YY_CQYB_YBSJZD d(nolock) on a.fszk = d.code and d.zdlb = 'FSZK'
	left join YY_CQYB_YBSJZD e(nolock) on a.cblb = e.code and e.zdlb = 'CBLB'
	left join YY_CQYB_YBSJZD f(nolock) on a.mzrylb = f.code and f.zdlb = 'MZRYLB'
where a.sbkh = @sbkh

return
GO
