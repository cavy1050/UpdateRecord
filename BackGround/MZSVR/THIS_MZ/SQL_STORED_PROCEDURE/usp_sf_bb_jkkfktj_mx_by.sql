ALTER proc usp_sf_bb_jkkfktj_mx_by  
@ksrq ut_rq16,  
@jsrq ut_rq16,  
@czyh ut_czyh  
as  
  
/**********************  
������������ϸ��  
---add by yangdi 2020.2.28 ���ҽ������Ϊ10λ��ͳ�Ʒ���ʱ����ؿ����ݣ���ȥ����
**********************/  
  
set nocount on  
  
declare @fksl ut_sl10,@fkje ut_money  
  
select a.czyh,b.name czym,a.cardno,case c.cardno when '' then '�������˿�' else c.hzxm end as hzxm,a.yj into #temp  
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
  
  
  
  
  
  
  
  

