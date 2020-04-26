--医保特殊病审批信息
if not exists(select 1 from sysobjects where name='YY_CQYB_TSBINFO')
begin  
	create table YY_CQYB_TSBINFO
	(      
        sbkh			varchar(20)	not	null,	--社会保障号码
        bzbm			varchar(20)	not	null,   --病种编码
        bzmc			varchar(80)		null,   --病种名称
        bfz				varchar(200)	null,	--并发症
        jlzt			ut_bz			null,	--记录状态0有效1无效
		id				INT	IDENTITY(1,1),		--序号
		timetemp		TIMESTAMP	NOT NULL	--时间戳
		constraint PK_YY_CQYB_TSBINFO PRIMARY KEY (id)
	)
	create index idx_sbkh on YY_CQYB_TSBINFO(sbkh)
end
GO

if not exists(select 1 from syscolumns where id=object_id('YY_CQYB_TSBINFO') and name='timetemp')
	ALTER TABLE YY_CQYB_TSBINFO add timetemp TIMESTAMP NOT NULL
GO