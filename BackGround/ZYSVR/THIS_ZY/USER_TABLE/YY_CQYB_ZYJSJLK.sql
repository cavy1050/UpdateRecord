--医保住院结算信息
if not exists(select 1 from sysobjects where name='YY_CQYB_ZYJSJLK')
begin  
	create table YY_CQYB_ZYJSJLK
	(      
        jsxh			ut_xh12		not	null,	--结算序号
        syxh			ut_syxh		not null,	--首页序号
        sbkh            varchar(20)	not	null,	--社会保障号码
        xzlb            ut_bz			null,   --险种类别
        jzlsh           varchar(20)	not	null,	--住院(或门诊)号
        jslb            ut_bz			null,   --结算类别
        zhzfbz          ut_bz			null,   --账户支付标志
        zhdybz          ut_bz			null,	--账户抵用标志
        jsqzrq          varchar(19)		null,   --中途结算起止日期
        jszzrq          varchar(19)		null,   --中途结算终止日期
        gsrdbh          varchar(10)		null,   --工伤认定编号
        gsjbbm          varchar(200)	null,	--工伤认定疾病编码
        cfjslx          varchar(10)		null,   --尘肺结算类型
        sylb			varchar(10)		null,	--生育类别
        sysj			varchar(10)		null,	--生育时间
        sybfz			varchar(10)		null,	--生育并发症
        ncbz			varchar(10)		null,	--难产标志
        rslx			varchar(10)		null,	--妊娠类型
        dbtbz			varchar(10)		null,	--多胞胎标志
        syfwzh			varchar(50)		null,	--生育服务证号
        jyjc			varchar(200)	null,	--遗传病基因检查项目
        jhzh			varchar(50)		null,	--结婚证号
        gzcybz			ut_bz			null,	--挂账出院标志0未挂账出院1挂账出院
        jlzt			ut_bz		not null,	--记录状态0录入1预算2结算3取消结算
        zxlsh           varchar(20)		null,   --交易流水号
        zxjssj			varchar(20)		null,	--中心结算时间
        czlsh           varchar(20)		null,   --冲正交易流水号
        zxczsj			varchar(20)		null,	--中心冲正时间
		ddyljgbm        varchar(20)		null,    --定点医疗机构编码
		lrsj			ut_rq16			null,	--录入时间
		cyzd			varchar(20)		null,	--出院诊断
		bfzinfo         varchar(200)	null 	--并发症信息
		CONSTRAINT PK_YY_CQYB_ZYJSJLK primary key(jsxh)
	)
	create index idx_jsxh on YY_CQYB_ZYJSJLK(jsxh)	
	create index idx_syxh on YY_CQYB_ZYJSJLK(syxh)	
	create index idx_sbkh on YY_CQYB_ZYJSJLK(sbkh)	
end
GO

-- 增加lrsj 
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('YY_CQYB_ZYJSJLK') AND name = 'lrsj')
BEGIN
	ALTER TABLE YY_CQYB_ZYJSJLK ADD lrsj ut_rq16 null;	
END

--定点医疗机构编码
if not exists(select 1 from syscolumns where id=object_id('YY_CQYB_ZYJSJLK') and name='ddyljgbm')
	alter table YY_CQYB_ZYJSJLK add ddyljgbm varchar(20) null
go

-- 增加cyzd
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('YY_CQYB_ZYJSJLK') AND name = 'cyzd')
BEGIN
	ALTER TABLE YY_CQYB_ZYJSJLK ADD cyzd VARCHAR(20) null;	
END
go

-- 增加bfzinfo
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('YY_CQYB_ZYJSJLK') AND name = 'bfzinfo')
BEGIN
	ALTER TABLE YY_CQYB_ZYJSJLK ADD bfzinfo VARCHAR(200) null;	
END
GO
