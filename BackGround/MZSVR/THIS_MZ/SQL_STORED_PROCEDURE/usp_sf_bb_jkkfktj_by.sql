ALTER proc usp_sf_bb_jkkfktj_by  
@ksrq ut_rq16,  
@jsrq ut_rq16  
as  
  
/**********************  
�����������ܱ�  
**********************/  
  
set nocount on  
  
----add by yangdi 2012.4.1   
/*********************************************  
�������������ݴ���  
�˴���Ա���˶��з���YY_JZBRYJK_KYJ.cardno=null��SF_BRXXK.cardno<>null��������д���  
������������������Ϊְ�����ǲ����м�¼�ġ�  
---add by yangdi 2020.2.28 ���ҽ������Ϊ10λ��ͳ�Ʒ���ʱ����ؿ����ݣ���ȥ����
**********************************************/  
  
if exists (select 1 from YY_JZBRYJK_KYJ a,SF_BRXXK b  
where isnull(a.cardno,'')=''  
and a.patid=b.patid  
and isnull(b.cardno,'')<>''  
and a.jlzt<>2  
and len(b.cardno)=10)  
begin  
 Update a set a.cardno=b.cardno   
 from YY_JZBRYJK_KYJ a,SF_BRXXK b  
 where isnull(a.cardno,'')=''  
 and a.patid=b.patid  
 and isnull(b.cardno,'')<>''  
 and a.jlzt<>2  
 and len(b.cardno)=10  
end  
  
select czyh,b.name czym,count(1) ksl,sum(yj) kyjje   
from YY_JZBRYJK_KYJ a (nolock),YY_ZGBMK b (nolock)  
where a.czyh=b.id and a.lrrq between @ksrq and @jsrq and a.jlzt in (0,1,3)  
and isnull(a.cardno,'')<>''  and b.ks_id in(select id from YY_KSBMK where yydm='01') 
and not exists (select 1 from YY_JZBRK_GSLOG c (nolock) where a.cardno=c.cardno and a.patid=c.patid and c.gsbz=2)  
and len(a.cardno)=10   AND LEFT(a.cardno,1)<>'#'
group by czyh,b.name  
  
select @ksrq ksrq,@jsrq jsrq  
  
return  
  
  
  
  
  
  
  

