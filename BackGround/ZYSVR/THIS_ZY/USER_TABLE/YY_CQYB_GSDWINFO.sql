--医保工伤单位信息
if not exists(select 1 from sysobjects where name='YY_CQYB_GSDWINFO')
begin  
	create table YY_CQYB_GSDWINFO
	(      
        sbkh			varchar(20)	not	null,	--社会保障号码
        grbh			varchar(10)	not	null,   --个人编号
        dwbh			varchar(10)	not	null,   --单位编号
        dwmc			varchar(50)		null,	--单位名称
        jlzt			ut_bz			null,	--记录状态0有效1无效
	)
	create index idx_sbkh on YY_CQYB_GSDWINFO(sbkh)	
	create index idx_grbh on YY_CQYB_GSDWINFO(grbh)	
	create index idx_dwbh on YY_CQYB_GSDWINFO(dwbh)	
end
go
