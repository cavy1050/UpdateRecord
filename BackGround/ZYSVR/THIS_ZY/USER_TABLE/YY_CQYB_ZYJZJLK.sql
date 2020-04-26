--医保住院登记信息
if not exists(select 1 from sysobjects where name='YY_CQYB_ZYJZJLK')
begin  
	create table YY_CQYB_ZYJZJLK
	(      
        syxh			ut_syxh		not null,	--首页序号
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
		scsdbz          varchar(3)      null,   --上传明细锁定标志2：结算，医保审核3:病区催款
		scsdsj          varchar(20)     null,   --上传明细锁定时间
		zhye            ut_money        null,   --账户余额
		yzcyymc         VARCHAR(50)     null,    --原转出医院名称
		lrsj			ut_rq16			null,	--录入时间
		zzjdjbz			ut_bz			null,	--是否自助机登记(0窗口、1自助机)
		czyh			ut_czyh         null    --医保登记人
	)
	create index idx_syxh on YY_CQYB_ZYJZJLK(syxh)	
	create index idx_sbkh on YY_CQYB_ZYJZJLK(sbkh)	
	CREATE NONCLUSTERED INDEX idx_yy_cqyb_zyjzjlk_jzlsh ON dbo.YY_CQYB_ZYJZJLK (jzlsh) INCLUDE (sbkh,xzlb,cblb,zgyllb,jmyllb)
end
GO

-- 增加zzjdjbz
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('YY_CQYB_ZYJZJLK') AND name = 'zzjdjbz')
BEGIN
	ALTER TABLE YY_CQYB_ZYJZJLK ADD zzjdjbz ut_bz null;	
END
-- 增加lrsj 
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('YY_CQYB_ZYJZJLK') AND name = 'lrsj')
BEGIN
	ALTER TABLE YY_CQYB_ZYJZJLK ADD lrsj ut_rq16 null;	
END

--医保登记人
if not exists(select 1 from syscolumns where id=object_id('YY_CQYB_ZYJZJLK') and name='czyh')
	ALTER TABLE YY_CQYB_ZYJZJLK add czyh ut_czyh NULL
GO