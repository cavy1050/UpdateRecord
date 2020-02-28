ALTER proc usp_sf_bb_jkkfktj_mx_by  
@ksrq ut_rq16,  
@jsrq ut_rq16,  
@czyh ut_czyh  
as  
  
/**********************  
健康卡发卡明细表  
---add by yangdi 2020.2.28 外地医保卡号为10位，统计发卡时有外地卡数据，需去掉。
**********************/  
  
set nocount on  
  
declare @fksl ut_sl10,@fkje ut_money  
  
select a.czyh,b.name czym,a.cardno,case c.cardno when '' then '此人已退卡' else c.hzxm end as hzxm,a.yj into #temp  
from YY_JZBRYJK_KYJ a (nolock),YY_ZGBMK b (nolock),SF_BRXXK c (nolock)  
where a.czyh=b.id and a.patid=c.patid and a.jlzt in(0,1,3)  and a.czyh=@czyh and a.lrrq between @ksrq and @jsrq
and b.ks_id in(select id from YY_KSBMK where yydm='01')   
and not exists (select 1 from YY_JZBRK_GSLOG e (nolock) where a.cardno=e.cardno and a.patid=e.patid and e.gsbz=2)  
and len(a.cardno)=10  AND LEFT(a.cardno,1)<>'#'
  
  
select @fksl=count(1),@fkje=sum(yj) from #temp  
select @fksl fksl,@fkje fkje,@ksrq ksrq,@jsrq jsrq  
  
select * from  #temp  
order by cardno  
  
return  
  
  
  
  
  
  
  
  

