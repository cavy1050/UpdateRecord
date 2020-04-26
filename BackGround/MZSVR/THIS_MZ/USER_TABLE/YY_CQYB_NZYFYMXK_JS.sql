--医保住院结算记录费用明细信息(年表)
if not exists(select 1 from sysobjects where name='YY_CQYB_NZYFYMXK_JS')
begin
	create table YY_CQYB_NZYFYMXK_JS
	(   
		syxh			ut_syxh		not null,	--首页序号
		jsxh			ut_xh12		not null,	--结算序号
		xh				ut_xh12		not null,	--明细序号
		txh				ut_xh12		not	null,	--退明细序号
		cfh				ut_xh12		    null,	--处方号
		cfrq			ut_rq16			null,	--处方日期
		idm				ut_xh9			null,	--药品idm
		xmdm			ut_xmdm			null,	--项目代码
		xmmc			ut_mc64			null,	--项目名称
		xmgg			ut_mc32			null,	--规格
		xmdj			ut_money		null,	--单价
		xmsl			ut_sl10			null,	--数量
		xmdw			ut_unit			null,	--单位
		xmje			ut_money	    null,	--金额		
		ksdm			ut_ksdm			null,	--科室代码
		ysdm			ut_czyh			null,	--医生代码
		jbr				ut_czyh			null,	--经办人
		jzbz			varchar(3)      null,	--急诊标志		
		zzfbz			varchar(10)		null,   --转自费标识
		ktsl			ut_sl10			null,	--可退数量
		ktje			ut_money		null,	--可退金额
		spbz			ut_bz			null,	--医院高收费审批标志0未审批1审批通过2审批不通过
		spclbz			ut_bz			null,	--医院高收费处理标志(调用21号交易)0未处理1已处理
		qzfbz			ut_bz			null,	--医院全自费标志0正常处理1全自费
		ybscbz			ut_bz			null,	--医保上传标志0未上传1已上传2无需上传 3不上传（已正负冲销）4部分退后需红冲已上传  5 红冲后待重新上传和部分退后上传				
		zxlsh			varchar(20)     null,	--冲消明细流水号
		ybxmdj			numeric(10,4)	null,	--医保项目单价
		ybspbz			varchar(10)		null,	--医保审批标志 1 高收费审批 2 血液白蛋白审批
		ybzje			numeric(10,4)	null,	--医保总金额
		sfxmdj			varchar(10)		null,	--收费项目等级
		ybzfbl			numeric(5,4)	null,	--医保自付比例
		ybbzdj			numeric(10,4)	null,	--医保标准单价
		ybzfje			numeric(10,4)	null,	--医保自付金额
		ybzlje			numeric(10,4)	null,	--医保自费金额
		dydm            VARCHAR(32)     null,   --上传的医保流水号
		scxmdj			ut_money		null,	--上传单价
		scxmsl			ut_sl10			null,	--上传数量
		scxmje			ut_money	    null	--上传金额
		constraint PK_YY_CQYB_NZYFYMXK_JS primary key(xh,jsxh)
	)
	create index idx_syxh on YY_CQYB_NZYFYMXK_JS(syxh)
	create index idx_jsxh on YY_CQYB_NZYFYMXK_JS(jsxh)
	create index idx_xh on YY_CQYB_NZYFYMXK_JS(xh)
	create index idx_txh on YY_CQYB_NZYFYMXK_JS(txh)
	create index idx_cfh on YY_CQYB_NZYFYMXK_JS(cfh)
end;
GO

