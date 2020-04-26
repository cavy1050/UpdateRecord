--门诊账户抵用记录库(年表)
if not exists(select 1 from sysobjects where name='YY_CQYB_NMZDYJLK')
begin  
	create table YY_CQYB_NMZDYJLK
	(      
        jssjh			ut_sjh		not	null,	--收据号
        jzlsh           varchar(18)	not	null,	--住院(或门诊)号
        zxlsh			varchar(20)		null,	--结算交易流水号(待抵用结算记录)
        sbkh            varchar(20)	not	null,	--社会保障号码
        name            varchar(20)		null,   --就医人姓名
        sfzh            varchar(18)		null,	--住院(或门诊)号
		xzqhbm			varchar(10)		null,   --行政区划编码
        dykh            varchar(10)	NOT NULL,   --抵用卡号
        dyje			ut_money		null,	--待抵用金额
        cblb            ut_bz			null,   --参保类别
        jlzt			ut_bz		not null,	--记录状态0录入1预算2结算3取消结算
        dyzxlsh			varchar(20)		null,	--抵用交易流水号	
        bcdyje          ut_money		null,   --本次抵用金额
        dyrxm           varchar(20)		null,   --抵用人姓名
        dyrsfzh         varchar(18)		null,	--抵用人身份证号
        dyrzhye         ut_money		null,   --抵用人账户余额
        ydyzje			ut_money		null,   --已抵用总金额
		constraint PK_YY_CQYB_NMZDYJLK primary key(jssjh,dykh)
	)
	create index idx_jssjh on YY_CQYB_NMZDYJLK(jssjh)	
	create index idx_sbkh on YY_CQYB_NMZDYJLK(sbkh)
end
go

