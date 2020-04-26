--医保门诊结算信息
if exists(select 1 from sysobjects where type='V' and name='VW_CQYB_MZJSJLK')
  drop view VW_CQYB_MZJSJLK
go
create view VW_CQYB_MZJSJLK 
as
(
	select * from YY_CQYB_MZJSJLK(NOLOCK)
	union all
	select * from YY_CQYB_NMZJSJLK(NOLOCK)
)
go