--医保工伤认定信息
if not exists(select 1 from sysobjects where name='YY_CQYB_GSRDINFO')
begin  
	create table YY_CQYB_GSRDINFO
	(      
        sbkh			varchar(20)	not	null,	--社会保障号码
        grbh			varchar(10)	not	null,   --个人编号
        dwbh			varchar(10)	not	null,   --单位编号
        rdbh			varchar(10)	not	null,   --认定编号
        tgbz			varchar(3)	 	null,   --通过标志
        sssj			varchar(10)	 	null,   --工伤受伤时间
        jssj			varchar(10)	 	null,   --治疗参考结束时间
        bzinfo			varchar(200)	null,	--工伤受伤病种信息
        jlzt			ut_bz			null,	--记录状态0有效1无效
	)
	create index idx_sbkh on YY_CQYB_GSRDINFO(sbkh)	
	create index idx_grbh on YY_CQYB_GSRDINFO(grbh)	
	create index idx_dwbh on YY_CQYB_GSRDINFO(dwbh)	
	create index idx_rdbh on YY_CQYB_GSRDINFO(rdbh)
end
go
