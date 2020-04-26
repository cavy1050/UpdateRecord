--医保数据字典对照
if not exists(select 1 from sysobjects where name='YY_CQYB_YBSJZD_DZ')
begin
	create table YY_CQYB_YBSJZD_DZ
	(
		zdlb			varchar(20)	not null,	--字典类别
		hiscode			varchar(20)	not null,	--his代码值
		ybcode			varchar(20)	not null,	--医保对照代码值
		constraint PK_YY_CQYB_YBSJZD_DZ primary key(zdlb,hiscode)
	)
	create index idx_yb_cqyb_ybsjzd_dz_zdlb on YY_CQYB_YBSJZD_DZ(zdlb)
	create index idx_yb_cqyb_ybsjzd_dz_hiscode on YY_CQYB_YBSJZD_DZ(hiscode)
	create index idx_yb_cqyb_ybsjzd_dz_ybcode on YY_CQYB_YBSJZD_DZ(ybcode)
end
go

