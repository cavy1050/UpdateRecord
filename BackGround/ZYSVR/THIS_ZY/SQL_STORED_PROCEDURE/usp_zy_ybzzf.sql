CREATE proc usp_zy_ybzzf      
                                                
@ksrq u5_rq16                                                
,@jsrq u5_rq16       
      
--���� exec usp_zy_ybzzf '20200101','20200529'                                             
as      
      
select b.blh ������,b.hzxm ����,b.sex �Ա�,b.cyzdmc ���,e.name ����,a.ypmc ҩƷ����      
      
,a.ypgg ҩƷ���,a.ypsl ҩƷ����,a.ypdj ҩƷ����,a.zje ҩƷ���,c.name ����ҽ��,a.lrrq ����ʱ��      
      
from  VW_BRFYMXK  a       
      
left join ZY_BRSYK b(nolock )   on  b.syxh=a.syxh      
left join YY_ZGDMK c(nolock )   on  c.zgdm=a.ysdm      
left join YY_KSBMK e(nolock )   on  e.id=b.ksdm      
LEFT JOIN dbo.YK_YPCDMLK f(NOLOCK) ON f.ypdm=a.ypdm       
where ybzzfbz=1  and a.jlzt=0  
and a.jszt=1     
and f.ybfydj in(1,2)  
and a.fylb not in (5,6)      
and SUBSTRING (a.lrrq,1,4)+SUBSTRING (a.lrrq,5,2)+SUBSTRING (a.lrrq,7,2)       
between @ksrq and @jsrq  +24    