--医保门诊结算信息(年表)
if not exists(select 1 from sysobjects where name='YY_CQYB_NMZJSJLK')
begin  
	create table YY_CQYB_NMZJSJLK
	(      
        jssjh			ut_sjh		not	null,	--收据号
        sbkh            varchar(20)	not	null,	--社会保障号码
        xzlb            ut_bz			null,   --险种类别
        jzlsh           varchar(20)	not	null,	--住院(或门诊)号
        jslb            ut_bz			null,   --结算类别
        zhzfbz          ut_bz			null,   --账户支付标志
        zhdybz          ut_bz			null,	--账户抵用标志
        jszzrq          varchar(10)		null,   --中途结算终止日期
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
        jlzt			ut_bz		not null,	--记录状态0录入1预算2结算3取消结算
        zxlsh           varchar(20)		null,   --交易流水号
        zxjssj			varchar(20)		null,	--中心结算时间
        czlsh           varchar(20)		null,   --冲正交易流水号
        zxczsj			varchar(20)		null,	--中心冲正时间
		ddyljgbm        varchar(10)     null    --定点医疗机构编码
		constraint PK_YY_CQYB_NMZJSJLK primary key(jssjh)
	)
	create index idx_jssjh on YY_CQYB_NMZJSJLK(jssjh)	
	create index idx_sbkh on YY_CQYB_NMZJSJLK(sbkh)	
	CREATE NONCLUSTERED INDEX idx_yy_cqyb_nmzjsjlk_ddyljgbm ON dbo.YY_CQYB_NMZJSJLK (ddyljgbm) INCLUDE (jssjh,xzlb,sylb,zxlsh)
end
go

--定点医疗机构编码
if not exists(select 1 from syscolumns where id=object_id('YY_CQYB_NMZJSJLK') and name='ddyljgbm')
	alter table YY_CQYB_NMZJSJLK add ddyljgbm varchar(20) null
go