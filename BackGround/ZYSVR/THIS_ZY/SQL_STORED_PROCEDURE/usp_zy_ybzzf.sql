CREATE proc usp_zy_ybzzf      
                                                
@ksrq u5_rq16                                                
,@jsrq u5_rq16       
      
--范例 exec usp_zy_ybzzf '20200101','20200529'                                             
as      
      
select b.blh 病历号,b.hzxm 姓名,b.sex 性别,b.cyzdmc 诊断,e.name 科室,a.ypmc 药品名称      
      
,a.ypgg 药品规格,a.ypsl 药品数量,a.ypdj 药品单价,a.zje 药品金额,c.name 操作医生,a.lrrq 操作时间      
      
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