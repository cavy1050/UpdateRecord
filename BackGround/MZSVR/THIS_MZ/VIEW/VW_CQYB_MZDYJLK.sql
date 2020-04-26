--医保门诊账户抵用信息
if exists(select 1 from sysobjects where type='V' and name='VW_CQYB_MZDYJLK')
  drop view VW_CQYB_MZDYJLK
go
create view VW_CQYB_MZDYJLK 
as
(
	select * from YY_CQYB_MZDYJLK(NOLOCK)
	union all
	select * from YY_CQYB_NMZDYJLK(NOLOCK)
)
go