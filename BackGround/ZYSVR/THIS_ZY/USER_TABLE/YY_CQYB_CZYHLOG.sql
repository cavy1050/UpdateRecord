--医保对照操作日志
if not exists(select 1 from sysobjects where name='YY_CQYB_CZYHLOG')
begin
	create table YY_CQYB_CZYHLOG
	(
		xh				int	   identity(1,1),	--序号
		czyh			ut_czyh		not null,   --操作用户
		czlb			ut_bz		not null,   --操作类别 0：对照  1：取消对照 2：其他
		czrq			ut_rq16		not null,	--操作日期
		hisxmdm			varchar(20)		null,   --his项目代码
		ybxmdm			varchar(20)		null,   --医保项目代码
		memo			varchar(1024)	null    --说明
	)
	create index idx_hisxmdm on YY_CQYB_CZYHLOG(hisxmdm)
	create index idx_ybxmdm on YY_CQYB_CZYHLOG(ybxmdm)
	
end;
go

