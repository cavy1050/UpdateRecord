--医保住院结算费用信息
if exists(select 1 from sysobjects where type='V' and name='VW_CQYB_ZYFYMXK_JS')
  drop view VW_CQYB_ZYFYMXK_JS
go
create view VW_CQYB_ZYFYMXK_JS 
as
(
	select * from YY_CQYB_ZYFYMXK_JS(NOLOCK)
	union all
	select * from YY_CQYB_NZYFYMXK_JS(NOLOCK)
)
go