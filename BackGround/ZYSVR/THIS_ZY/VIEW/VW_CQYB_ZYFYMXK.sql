--医保住院费用信息
if exists(select 1 from sysobjects where type='V' and name='VW_CQYB_ZYFYMXK')
  drop view VW_CQYB_ZYFYMXK
go
create view VW_CQYB_ZYFYMXK 
as
(
	select * from YY_CQYB_ZYFYMXK(NOLOCK)
	union all
	select * from YY_CQYB_NZYFYMXK(NOLOCK)
)
go