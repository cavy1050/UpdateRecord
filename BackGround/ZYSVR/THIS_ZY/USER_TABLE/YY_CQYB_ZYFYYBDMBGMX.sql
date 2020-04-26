if not exists(select 1 from sysobjects where name='YY_CQYB_ZYFYYBDMBGMX')
BEGIN
	--住院费用医保代码变更明细
	CREATE TABLE YY_CQYB_ZYFYYBDMBGMX
	(
		xh		ut_xh12,		--ZY_BRFYMXK.xh
		syxh	ut_syxh,		--首页序号
		jsxh	ut_xh12,		--结算序号
		oldybdm	VARCHAR(32),	--旧医保代码
		newybdm VARCHAR(32),	--新医保代码
		czyh	ut_czyh,		--操作员号
		czrq	ut_rq16,		--操作日期
		sfcl	ut_bz			--是否处理 0 未处理、1 已处理
	)	
END
GO
