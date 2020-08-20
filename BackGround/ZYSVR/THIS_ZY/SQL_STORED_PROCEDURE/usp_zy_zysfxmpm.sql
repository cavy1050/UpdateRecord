CREATE proc usp_zy_zysfxmpm      
@ksdm utKsdm        --@ksdm=-1表示取全院数据      
,@fzf  varchar(8)   --非自费标志为1时表示为非自费，-1为不取这个条件即所有类型的病人,0为自费病人                                   
      
,@ksrq u5_rq16                                                
,@jsrq u5_rq16       
      
--范例 exec usp_zy_zysfxmpm '-1',1,'20190501','20200529'                                             
as      
if  @ksdm='-1'and @fzf=-1        ---全院数据      
begin       
select ypdm 项目代码,ypmc 项目名称,ypsl 项目数量,ypdj 项目单价,sum(a.zje) 项目金额 from VW_BRFYMXK a(nolock)       
left join YY_KSBMK b(nolock )   on  b.id=a.ksdm      
left join ZY_BRSYK c(nolock )   on  c.syxh=a.syxh      
where SUBSTRING (a.lrrq,1,4)+SUBSTRING (a.lrrq,5,2)+SUBSTRING (a.lrrq,7,2)  between @ksrq and @jsrq +24      
--and a.ksdm=@ksdm      
and a.jlzt=0   
and a.jszt=1      
and a.fylb not in (5,6)    
--and c.ybdm='101'      
group by ypdm,ypmc,ypsl,ypdj      
order by sum(a.zje) desc      
end      
      
else if  @ksdm='-1'and @fzf=-1       ---科室数据      
begin       
select ypdm 项目代码,ypmc 项目名称,ypsl 项目数量,ypdj 项目单价,sum(a.zje) 项目金额 from VW_BRFYMXK a(nolock)       
left join YY_KSBMK b(nolock )   on  b.id=a.ksdm      
left join ZY_BRSYK c(nolock )   on  c.syxh=a.syxh      
where SUBSTRING (a.lrrq,1,4)+SUBSTRING (a.lrrq,5,2)+SUBSTRING (a.lrrq,7,2)  between @ksrq and @jsrq +24      
and a.ksdm=@ksdm      
and a.jlzt=0  
and a.jszt=1      
and a.fylb not in (5,6)     
--and c.ybdm='101'      
group by ypdm,ypmc,ypsl,ypdj      
order by sum(a.zje) desc      
end      
      
else if  @ksdm='-1'and @fzf=0         ---全院自费数据      
begin       
select ypdm 项目代码,ypmc 项目名称,ypsl 项目数量,ypdj 项目单价,sum(a.zje) 项目金额 from VW_BRFYMXK a(nolock)       
left join YY_KSBMK b(nolock )   on  b.id=a.ksdm      
left join ZY_BRSYK c(nolock )   on  c.syxh=a.syxh      
where SUBSTRING (a.lrrq,1,4)+SUBSTRING (a.lrrq,5,2)+SUBSTRING (a.lrrq,7,2)  between @ksrq and @jsrq +24      
--and a.ksdm=@ksdm      
and a.jlzt=0  
and a.jszt=1     
and a.fylb not in (5,6)      
and c.ybdm='101'      
group by ypdm,ypmc,ypsl,ypdj      
order by sum(a.zje) desc      
end      
      
else if  @ksdm<>'-1'and @fzf=0    --科室自费数据      
begin      
select ypdm 项目代码,ypmc 项目名称,ypsl 项目数量,ypdj 项目单价,sum(a.zje) 项目金额 from VW_BRFYMXK a(nolock)       
left join YY_KSBMK b(nolock )   on  b.id=a.ksdm      
left join ZY_BRSYK c(nolock )   on  c.syxh=a.syxh      
where SUBSTRING (a.lrrq,1,4)+SUBSTRING (a.lrrq,5,2)+SUBSTRING (a.lrrq,7,2)  between @ksrq and @jsrq +24      
and a.ksdm=@ksdm      
and a.jlzt=0   
and a.jszt=1      
and a.fylb not in (5,6)    
and c.ybdm='101'      
group by ypdm,ypmc,ypsl,ypdj      
order by sum(a.zje) desc      
end      
      
else if  @ksdm<>'-1' and @fzf=1     --科室非自费病人      
begin      
select ypdm 项目代码,ypmc 项目名称,ypsl 项目数量,ypdj 项目单价,sum(a.zje) 项目金额 from VW_BRFYMXK a(nolock)       
left join YY_KSBMK b(nolock )   on  b.id=a.ksdm      
left join ZY_BRSYK c(nolock )   on  c.syxh=a.syxh      
where SUBSTRING (a.lrrq,1,4)+SUBSTRING (a.lrrq,5,2)+SUBSTRING (a.lrrq,7,2)  between @ksrq and @jsrq +24      
and a.ksdm=@ksdm      
and a.jlzt=0  
and a.jszt=1      
and a.fylb not in (5,6)     
and c.ybdm<>'101'      
group by ypdm,ypmc,ypsl,ypdj      
order by sum(a.zje) desc      
end      
      
else if  @ksdm='-1'and @fzf=1      --全院非自费病人      
begin      
select ypdm 项目代码,ypmc 项目名称,ypsl 项目数量,ypdj 项目单价,sum(a.zje) 项目金额 from VW_BRFYMXK a(nolock)       
left join YY_KSBMK b(nolock )   on  b.id=a.ksdm      
left join ZY_BRSYK c(nolock )   on  c.syxh=a.syxh      
where SUBSTRING (a.lrrq,1,4)+SUBSTRING (a.lrrq,5,2)+SUBSTRING (a.lrrq,7,2)  between @ksrq and @jsrq +24      
--and a.ksdm=@ksdm      
and a.jlzt=0   
and a.jszt=1     
and a.fylb not in (5,6)     
and c.ybdm<>'101'      
group by ypdm,ypmc,ypsl,ypdj      
order by sum(a.zje) desc      
end