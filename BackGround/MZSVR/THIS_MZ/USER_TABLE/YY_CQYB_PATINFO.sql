--医保病人基本信息库
if not exists(select 1 from sysobjects where name='YY_CQYB_PATINFO')
begin  
	create table YY_CQYB_PATINFO
	(      
		sbkh			varchar(20) not null,	--社会保障号码
		name			varchar(60)	not	null,	--姓名
		sex				varchar(20)		null,	--性别
		age				varchar(10)		null,	--实足年龄
		sfzh			varchar(18)		null,	--身份证号
		nation			varchar(20)		null,	--民族
		address			varchar(50)		null,   --住址
		rylb			varchar(10)		null,   --人员类别
		gwydy			varchar(10)		null,   --是否享受公务员待遇
		dwmc			varchar(50)		null,   --单位名称
		xzqhbm			varchar(14)		null,   --行政区划编码
		fszk			varchar(10)		null,   --封锁状况
		fsyy			varchar(128)	null,   --封锁原因
		rylxbg			varchar(10)		null,   --人员类型变更
		rylxbgsj		varchar(20)		null,   --人员类型变更时间
		dyfskssj		varchar(20)		null,   --待遇封锁开始时间
		dyfsjssj		varchar(20)		null,   --待遇封锁终止时间
		mzrylb			varchar(10)		null,   --民政人员类别
		jmjfdc			varchar(10)		null,   --居民缴费档次
		cblb			varchar(10)		null,   --参保类别
		lxdh			varchar(20)		null,   --患者联系电话
		gscbzt			varchar(10)		null,   --工伤参保状态
		gscbsj			varchar(20)		null,   --工伤参保时间
		gsfszk			varchar(10)		null,   --工伤封锁状况
		gsfsyy			varchar(128)	null,   --工伤封锁原因
		gsdyfskssj		varchar(20)		null,   --工伤待遇封锁开始时间
		gsdyfsjssj		varchar(20)		null,   --工伤待遇封锁终止时间
		zyzz			varchar(10)		null,   --转院转诊
		fzqjcbsp		varchar(10)		null,   --辅助器具超标审批
		sycbsj			varchar(20)		null,   --生育参保时间
		jydjzh			varchar(20)		null,   --就医登记证号
		xsjzbz			varchar(10)		null,   --是否享受就诊标志
		bxsjzyy			varchar(200)	null,   --不能享受就诊原因
		jydjjjbm		varchar(10)		null,   --就医登记机构编码
		bfzbz			varchar(10)		null,   --并发症标志
		dyxskssj		varchar(20)		null,   --享受待遇实际开始时间
		dyxsjssj		varchar(20)		null,   --享受待遇实际结束时间
		dqfprylb		varchar(50)     NULL	--当前扶贫人员类别
		constraint PK_YY_CQYB_PATINFO primary key(sbkh)
	)
	create index idx_sbkh on YY_CQYB_PATINFO(sbkh)
	create index idx_name on YY_CQYB_PATINFO(name)
end
go

--01交易修改姓名长度
alter table YY_CQYB_PATINFO ALTER COLUMN name varchar(60) null
go

--20181128   增加1.28版当前扶贫人员类别
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('YY_CQYB_PATINFO') AND name = 'dqfprylb') 	
alter table YY_CQYB_PATINFO  add 	dqfprylb varchar(50)  NULL --当前扶贫人员类别