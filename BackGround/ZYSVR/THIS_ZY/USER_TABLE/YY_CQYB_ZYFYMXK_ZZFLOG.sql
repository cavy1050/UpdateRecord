--医保住院费用明细信息_转自费日志
if not exists(select 1 from sysobjects where name='YY_CQYB_ZYFYMXK_ZZFLOG')
begin
	create table YY_CQYB_ZYFYMXK_ZZFLOG
	(   
		syxh			ut_syxh		not null,	--首页序号
		jsxh			ut_xh12		not null,	--结算序号
		xh				ut_xh12		not NULL,	--明细序号
		lb              VARCHAR(3)       NOT NULL,   --数据类别，1转自费，2转医保
		czyh            varchar(10)     NULL,   --操作用户
		czrq            DATETIME        NULL    --操作日期
	)
	create index idx_yy_cqyb_zyfymxk_zzflog_syxh on YY_CQYB_ZYFYMXK_ZZFLOG(syxh)
	create index idx_yy_cqyb_zyfymxk_zzflog_jsxh on YY_CQYB_ZYFYMXK_ZZFLOG(jsxh)
	create index idx_yy_cqyb_zyfymxk_zzflog_xh on YY_CQYB_ZYFYMXK_ZZFLOG(xh)
end;
GO
