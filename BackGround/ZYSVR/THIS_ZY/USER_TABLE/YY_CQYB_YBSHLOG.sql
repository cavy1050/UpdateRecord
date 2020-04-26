--医保审核日志
if not exists(select 1 from sysobjects where name='YY_CQYB_YBSHLOG')
begin
	create table YY_CQYB_YBSHLOG
	(   
		xh				ut_xh12    identity	not null , --序号
		syxh			ut_syxh		not null,	--首页序号
		jsxh			ut_xh12		not null,	--结算序号
		shbz			ut_bz		NOT NULL,	--审核标志	0 未审核或未复核, 1 审核、复核均通过, 2 未通过(需要2审复核)
		czyh            varchar(10)     NULL,   --操作用户
		czrq            ut_rq16        NULL    --操作日期
	)
	create index idx_yy_cqyb_ybshlog_syxh on YY_CQYB_YBSHLOG(syxh)
	create index idx_yy_cqyb_ybshlog_jsxh on YY_CQYB_YBSHLOG(jsxh)
end;
GO
