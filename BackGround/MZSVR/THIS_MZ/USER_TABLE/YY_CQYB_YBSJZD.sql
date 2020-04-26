--医保数据字典
if not exists(select 1 from sysobjects where name='YY_CQYB_YBSJZD')
begin
	create table YY_CQYB_YBSJZD
	(
		zdlb			varchar(20)	not null,	--字典类别
		zdsm			varchar(32)	not null,	--字典说明
		code			varchar(20)	not null,	--代码值
		name			varchar(64)	not null,	--代码说明	
		xtbz			ut_bz			null,	--系统标志0门诊1住院
		cblb			ut_bz			null,	--参保类别1职工医保2居民医保3离休干部	
		xzlb			ut_bz			null,	--险种类别1医疗保险2工伤保险3生育保险
		py				ut_py			null,	--拼音
		wb				ut_py			null,	--五笔
		jlzt			ut_bz		not	null,	--有效标识
	)
	create index idx_yb_cqyb_ybsjzd_zdlb on YY_CQYB_YBSJZD(zdlb)
	create index idx_yb_cqyb_ybsjzd_code on YY_CQYB_YBSJZD(code)
	create index idx_yb_cqyb_ybsjzd_xtbz on YY_CQYB_YBSJZD(xtbz)
	create index idx_yb_cqyb_ybsjzd_cblb on YY_CQYB_YBSJZD(cblb)
	create index idx_yb_cqyb_ybsjzd_xzlb on YY_CQYB_YBSJZD(xzlb)
end
go
