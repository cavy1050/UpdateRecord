CREATE proc usp_zy_zysfxmpm      
@ksdm utKsdm        --@ksdm=-1��ʾȡȫԺ����      
,@fzf  varchar(8)   --���Էѱ�־Ϊ1ʱ��ʾΪ���Էѣ�-1Ϊ��ȡ����������������͵Ĳ���,0Ϊ�ԷѲ���                                   
      
,@ksrq u5_rq16                                                
,@jsrq u5_rq16       
      
--���� exec usp_zy_zysfxmpm '-1',1,'20190501','20200529'                                             
as      
if  @ksdm='-1'and @fzf=-1        ---ȫԺ����      
begin       
select ypdm ��Ŀ����,ypmc ��Ŀ����,ypsl ��Ŀ����,ypdj ��Ŀ����,sum(a.zje) ��Ŀ��� from VW_BRFYMXK a(nolock)       
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
      
else if  @ksdm='-1'and @fzf=-1       ---��������      
begin       
select ypdm ��Ŀ����,ypmc ��Ŀ����,ypsl ��Ŀ����,ypdj ��Ŀ����,sum(a.zje) ��Ŀ��� from VW_BRFYMXK a(nolock)       
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
      
else if  @ksdm='-1'and @fzf=0         ---ȫԺ�Է�����      
begin       
select ypdm ��Ŀ����,ypmc ��Ŀ����,ypsl ��Ŀ����,ypdj ��Ŀ����,sum(a.zje) ��Ŀ��� from VW_BRFYMXK a(nolock)       
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
      
else if  @ksdm<>'-1'and @fzf=0    --�����Է�����      
begin      
select ypdm ��Ŀ����,ypmc ��Ŀ����,ypsl ��Ŀ����,ypdj ��Ŀ����,sum(a.zje) ��Ŀ��� from VW_BRFYMXK a(nolock)       
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
      
else if  @ksdm<>'-1' and @fzf=1     --���ҷ��ԷѲ���      
begin      
select ypdm ��Ŀ����,ypmc ��Ŀ����,ypsl ��Ŀ����,ypdj ��Ŀ����,sum(a.zje) ��Ŀ��� from VW_BRFYMXK a(nolock)       
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
      
else if  @ksdm='-1'and @fzf=1      --ȫԺ���ԷѲ���      
begin      
select ypdm ��Ŀ����,ypmc ��Ŀ����,ypsl ��Ŀ����,ypdj ��Ŀ����,sum(a.zje) ��Ŀ��� from VW_BRFYMXK a(nolock)       
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