--医保门诊登记信息(年表)
if not exists(select 1 from sysobjects where name='YY_CQYB_NMZJZJLK')
begin  
	create table YY_CQYB_NMZJZJLK
	(      
        jssjh			ut_sjh		not	null,	--收据号
        sbkh            varchar(20)	not	null,	--社会保障号码
        xzlb            ut_bz			null,   --险种类别
        cblb            ut_bz			null,   --参保类别
        jzlsh           varchar(20)	not	null,	--住院(或门诊)号
        zgyllb          varchar(10)	    null,   --医疗类别
        ksdm            ut_ksdm			null,   --科室代码
        ysdm            ut_czyh			null,   --医生代码
        ryrq            varchar(10)		null,   --入院日期
        ryzd            varchar(20)		null,	--入院诊断
        cyrq			varchar(10)		null,	--出院日期
        cyzd			varchar(20)		null,	--出院诊断 
        cyyy			varchar(10)		null,	--出院原因
        bfzinfo         varchar(200)	null,	--并发症信息
        jzzzysj         varchar(10)		null,	--急诊转住院时间
        bah             varchar(20)		null,   --病案号
        syzh            varchar(20)		null,   --生育证号
        xsecsrq         varchar(10)		null,	--新生儿出生日期
        jmyllb          varchar(10)		null,   --居民特殊就诊标记
        gsgrbh          varchar(10)		null,   --工伤个人编号
        gsdwbh          varchar(10)		null,   --工伤单位编号
        zryydm			varchar(14)		null,	--转入医院代码
        jlzt			ut_bz		not null,	--记录状态0录入1登记2医保结算3登记撤销        
        zxlsh           varchar(20)		null,   --交易流水号
	)
	create index idx_jssjh on YY_CQYB_NMZJZJLK(jssjh)	
	create index idx_sbkh on YY_CQYB_NMZJZJLK(sbkh)	
end
go

