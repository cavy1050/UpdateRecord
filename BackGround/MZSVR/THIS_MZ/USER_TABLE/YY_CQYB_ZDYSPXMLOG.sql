--医保自定义审批项目库操作日志
if not exists(select 1 from sysobjects where name='YY_CQYB_ZDYSPXMLOG')
begin
	create table YY_CQYB_ZDYSPXMLOG
	(
		xh				int	   identity(1,1),	--序号
		whxh            int         NOT NULL,   --YY_CQYB_ZDYSPXM.xh 维护序号
		czyh			ut_czyh		not null,   --操作用户
		czlb			ut_bz		not null,   --操作类别 0：新增  1：启用 2：停用
		czrq			datetime		not null,	--操作日期
		memo			varchar(1024)	null    --说明
	)
	create index idx_yy_cqyb_zdyspxmlog_whxh on YY_CQYB_ZDYSPXMLOG(whxh)
end;
GO

