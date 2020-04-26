--医保门诊就诊信息
if exists(select 1 from sysobjects where type='V' and name='VW_CQYB_MZJZJLK')
  drop view VW_CQYB_MZJZJLK
go
create view VW_CQYB_MZJZJLK 
as
(
	select * from YY_CQYB_MZJZJLK(NOLOCK)
	union all
	select * from YY_CQYB_NMZJZJLK(NOLOCK)
)
go