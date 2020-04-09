if exists(select * from sysobjects where name='usp_cqyb_ddqq_yw_fymxcx_fymx')
  drop proc usp_cqyb_ddqq_yw_fymxcx_fymx
go

Create procedure usp_cqyb_ddqq_yw_fymxcx_fymx              
 @syxh   ut_syxh,  --首页序号                
 @dxmdm  ut_kmdm=null, --大项目代码                
 @idm ut_xh9=0,       --药idm                
 @ypdm ut_xmdm='',  --药品代码                
 @jsxh ut_xh12=null, --结算序号                
 @cxlb ut_bz=0,        
 @hblcxm ut_bz=0,        
 @bqdm ut_ksdm = null  -- 病区代码        
                
as                
/**********                
[版本号]4.0.0.0.0                
[创建时间]2003.10.24                
[作者]王毅                
[版权] Copyright ? 1998-2001上海金仕达-卫宁医疗信息技术有限公司                
[描述] 住院系统--费用明细查询2                
[功能说明]                
 病人费用明细查询（查明细项目费用）                
[参数说明]                
 @syxh   首页序号                
 @dxmdm  ut_kmdm=null, --大项目代码                
    @idm        药idm                
 @ypdm       药品代码                
 @jsxh  结算序号                
 @cxlb  0=所有，1=所有药费，2=所有非药费           
 @hblcxm 合并临床项目             
 @bqdm   病区代码        
[返回值]                
[结果集、排序]                
 成功：数据集                
 错误："F","错误信息"                
[调用的sp]                
[调用实例]                
exec usp_bq_fymxcx_ex2 12,null,0,"",null,0                
--exec usp_bq_fymxcx_ex2 25,null,0,"",null,0                
--exec usp_bq_fymxcx_ex2 25,null,0,"",null,0                
[修改历史]                
**********/                
set nocount on                
                
declare @patid ut_syxh,                
        @rqfl char(2),                
        @ybdm ut_ybdm                
                
select @patid=patid,@ybdm=ybdm from ZY_BRSYK(NOLOCK) where syxh=@syxh and brzt not in (9) --可以查brzt=8的.               
if @@rowcount=0 or @@error<>0                
begin                
 select "F","该病人不存在！"                
 return                
end                
SELECT @rqfl=rqfldm FROM YY_YBFLK where ybdm=@ybdm              
        
--modify by Wang Yi, 修改成插入临时表形式，以便于更新分类自负比例                
create table #tempbqmx                
(                
 idm  ut_xh9      not null, --药idm                
 qqrq varchar(20) null,  --请求日期                
 sfrq varchar(20) null,  --收费日期                
 ypdm ut_xmdm  null,  --项目代码                
 ypmc    ut_mc64  null,  --药品名称                
 ypgg    ut_mc32  null,   --药品规格                
 ypdw  ut_unit  null,  --单位                
 ypsl numeric(10,2) null,  --数量                
 ypdj money  null,  --单价                
 zje ut_je14  null,  --金额                
 flzfje ut_je14  null,  --分类支付金额                
 zfje ut_je14  null,  --自费金额                
 yhje ut_je14  null,  --减免金额                
 fylb varchar(12) null,  --费用类别                
 cjmc ut_mc32  null,  --生产厂家                
 czyh ut_czyh  null,  --操作员代码                
 czymc ut_name  null,  --操作员                
 bqmc ut_mc32  null,  --病区                
 zxks ut_mc32  null,  --执行科室                
 flzfbl varchar(10)  null,  --分类自负比例                
 sxlb varchar(10) null,     --属性类别    
 jlzt ut_bz null,        --记录状态    
 fpxmdm ut_kmdm null, --发票项目代码    
 fpxmmc ut_mc16 null, --发票项目名称    
 memo   ut_mc64 null --备注信息，显示医保信息    
 ,dydm VARCHAR(32) null               
)             
          
declare @selbz ut_bz        
if @idm = 0 and @ypdm=''         
 select @selbz = 0        
else        
 select @selbz = 1        
--选择费用        
select a.*,b.fpxmdm,b.fpxmmc into #tmpfymxk        
from VW_BRFYMXK a (nolock),ZY_BRJSMXK b (nolock)        
where a.syxh = @syxh and a.zje <> 0 and (@jsxh is null or a.jsxh = @jsxh)  and (@bqdm is null or a.bqdm = @bqdm) and a.jsxh=b.jsxh and a.dxmdm=b.dxmdm      
 and ( (@selbz=0 and ( @cxlb = 0         
        or (@cxlb = 1 and exists(select 1 from YY_SFDXMK where id=a.dxmdm and ypbz in (1,2,3)))        
        or (@cxlb = 2 and not exists(select 1 from YY_SFDXMK where id=a.dxmdm and ypbz in (1,2,3)))        
      ))--@selbz=0        
  or (@selbz<>0 and a.idm=@idm and a.ypdm=@ypdm and a.dxmdm=@dxmdm))        
        
--非临床的        
select bqdm,syxh,czyh,zxks,qqrq,zxrq,idm,ypdm,ypmc,ypgg,ypdw,convert(numeric(10,2),ypsl/dwxs) as ypsl,        
 convert(numeric(12,4),ypdj*dwxs/ykxs) as ypdj,zje,zfje,yhje,flzfje,fylb,lcxmdm,jlzt,fpxmdm,fpxmmc, dydm    
into #tmpbrfy        
from #tmpfymxk         
where (@hblcxm = 0 or lcxmdm = '0')        
        
if @hblcxm <> 0         
begin        
        
 --临床合并        
 select distinct identity(int,1,1) id,syxh,czyh,yzxh,qqxh,qqrq,fylb,lcxmdm,lcxmmc,min(xh) minxh,max(xh) maxxh,sum(zje) zje,sum(zfje) zfje,sum(yhje) yhje,sum(flzfje) flzfje,1 as ypsl     
 into #tmplcxmk        
 from #tmpfymxk        
 where lcxmdm <> '0'          
 group by syxh,czyh,yzxh,qqxh,qqrq,fylb,lcxmdm,lcxmmc,(case when tyxh > 0 then 1 else 0 end)      
 order by syxh,qqrq         
 --合并        
 select a.id,a.minxh,a.zje,a.zfje,a.yhje,a.flzfje,(case when b.xmsl = 0 then c.ypsl else convert(numeric(12,2),(c.ypsl/dwxs)/b.xmsl) end) ypsl        
 into #tmplcsum        
 from #tmplcxmk a,YY_LCSFXMDYK b(NOLOCK),#tmpfymxk c         
 where a.lcxmdm = b.lcxmdm and a.minxh = c.xh and c.ypdm = b.xmdm        
 --找到合并的        
 insert into #tmpbrfy(bqdm,syxh,czyh,zxks,qqrq,zxrq,idm,ypdm,ypmc,ypgg,ypdw,ypsl,ypdj,        
  zje,zfje,yhje,flzfje,fylb,lcxmdm,jlzt,fpxmdm,fpxmmc )        
 select a.bqdm,a.syxh,a.czyh,a.zxks,a.qqrq,a.zxrq,0,a.lcxmdm,a.lcxmmc,'临床项目',a.ypdw,b.ypsl,convert(numeric(12,4),case when b.ypsl = 0 then b.zje else b.zje/b.ypsl end) ypdj,        
  convert(numeric(12,4),isnull(b.zje,0)) zje,convert(numeric(12,4),isnull(b.zfje,0)) zfje,convert(numeric(12,4),isnull(b.yhje,0)) yhje,convert(numeric(12,4),isnull(b.flzfje,0)) flzfje,a.fylb,a.lcxmdm,a.jlzt ,a.fpxmdm,a.fpxmmc                
 from #tmpfymxk a,#tmplcsum b        
 where a.xh = b.minxh        
 --没找到的        
 insert into #tmpbrfy(bqdm,syxh,czyh,zxks,qqrq,zxrq,idm,ypdm,ypmc,ypgg,ypdw,ypsl,ypdj,        
  zje,zfje,yhje,flzfje,fylb,lcxmdm,jlzt,fpxmdm,fpxmmc )        
 select a.bqdm,a.syxh,a.czyh,a.zxks,a.qqrq,a.zxrq,0,a.lcxmdm,a.lcxmmc,'临床项目',a.ypdw,b.ypsl,convert(numeric(12,4),case when b.ypsl = 0 then b.zje else b.zje/b.ypsl end) ypdj,        
  convert(numeric(12,4),isnull(b.zje,0)) zje,convert(numeric(12,4),isnull(b.zfje,0)) zfje,convert(numeric(12,4),isnull(b.yhje,0)) yhje,convert(numeric(12,4),isnull(b.flzfje,0)) flzfje,a.fylb,a.lcxmdm,a.jlzt,a.fpxmdm,a.fpxmmc                 
 from #tmpfymxk a,#tmplcxmk b        
 where not exists(select 1 from #tmplcsum c where b.id = c.id)        
  and a.xh = b.minxh        
        
 update #tmpbrfy set ypdj = b.xmdj from #tmpbrfy a,YY_LCSFXMK b(NOLOCK) where a.lcxmdm = b.id and a.ypdj = 0        
end        
---        
 insert into #tempbqmx(idm,qqrq,sfrq,ypdm,ypmc,ypgg,ypdw,ypsl,ypdj,zje,flzfje,zfje,yhje,fylb,cjmc,czyh,czymc,bqmc,zxks,jlzt,fpxmdm,fpxmmc,memo,dydm)                
 select a.idm "idm代码",substring(qqrq,1,4)+"."+substring(qqrq,5,2)+"."+substring(qqrq,7,2)+" "+substring(qqrq,9,8) "请求日期",        
  substring(zxrq,1,4)+"."+substring(zxrq,5,2)+"."+substring(zxrq,7,2)+" "+substring(zxrq,9,8) "收费日期",                
  a.ypdm "项目代码",rtrim(a.ypmc) ypmc, rtrim(a.ypgg) ypgg,a.ypdw "单位",                
  convert(numeric(10,2),a.ypsl) "数量",convert(money,a.ypdj) "单价",                
  isnull(a.zje,0) "金额",a.flzfje "分类支付金额",isnull(a.zfje-a.flzfje,0) "自费金额",isnull(a.yhje,0) "减免金额",                
  case a.fylb when 0 then "临时医嘱"                 
   when 1 then "长期医嘱"                
   when 3 then "医技"                
   when 4 then "固定费用"                
   when 5 then "退药"                
   when 6 then "非医嘱项目"                
   when 7 then "手术费用"                
   when 8 then "出院带药"                
   when 9 then "婴儿费用"                
   when 10 then "小处方"                
   else "其它" end "费用类别",c.cjmc "生产厂家",                
   a.czyh "操作员代码",d.name  "操作员", b.name  "病区",case e.name when null then b.name else e.name end "执行科室" ,a.jlzt ,a.fpxmdm,a.fpxmmc,c.memo, a.dydm    
 from #tmpbrfy a(nolock) LEFT JOIN YK_YPCDMLK c(NOLOCK) ON a.idm = c.idm
                         LEFT JOIN czryk d(NOLOCK) ON a.czyh = d.id
						 LEFT JOIN YY_KSBMK e(nolock) ON a.zxks = e.id 
                         INNER JOIN ZY_BQDMK b(nolock) ON a.bqdm=b.id              
 order by zxrq                
        
 UPDATE #tempbqmx    
 SET sxlb=(CASE WHEN v.ylfydj=1 THEN "[甲]" WHEN v.ylfydj=2 THEN "[乙]" WHEN v.ylfydj=3 THEN "[非]" WHEN v.ylfydj=4 THEN "[混]" ELSE "[未]" END)    
 FROM #tempbqmx t, VW_YBYPXM v(NOLOCK)    
 WHERE t.dydm=v.yblsh    
 IF @ybdm="122"    
  UPDATE #tempbqmx    
  SET sxlb=(CASE WHEN v.tqfydj=1 THEN "[甲]" WHEN v.tqfydj=2 THEN "[乙]" WHEN v.tqfydj=3 THEN "[非]" WHEN v.ylfydj=4 THEN "[混]" ELSE "[未]" END)    
  FROM #tempbqmx t, VW_YBYPXM v(NOLOCK)    
  WHERE t.dydm=v.yblsh     
  AND v.tqfydj<>""    
  AND v.tqfydj IS NOT NULL    
    
--update #tempbqmx set sxlb=(case when  b.ybfydj=1 then '[甲]' when b.ybfydj=2 then '[乙]' when b.ybfydj=3 then '[非]' else '[未]' end)                   
-- from #tempbqmx a(nolock),YK_YPCDMLK b(nolock)                   
-- where a.idm=b.idm and a.idm<>0                  
--update #tempbqmx set sxlb=(case when  c.ybfydj=1 then '[甲]' when c.ybfydj=2 then '[乙]' when c.ybfydj=3 then '[非]' else '[未]' end)                  
--from #tempbqmx a(nolock),YY_SFXXMK c (nolock)                  
----where a.ypdm=c.id and c.zybz=1 and c.sybz=1                   
--where a.ypdm=c.id and a.idm=0        
      
select a.idm "idm代码",a.qqrq "请求日期",a.sfrq "收费日期",a.ypdm "项目代码",rtrim(a.ypmc)+' ※'+rtrim(a.ypgg) + rtrim(a.flzfbl)  "项目名称规格"                
 ,a.ypdw "单位",a.ypsl "数量",a.ypdj "单价",a.zje "金额",a.flzfje "分类支付金额",a.zfje "自费金额",a.yhje "减免金额"                
 ,a.fylb "费用类别",a.cjmc "生产厂家",a.czyh "操作员代码",a.czymc "操作员",a.bqmc "病区",a.zxks "执行科室",isnull(a.sxlb,'[未]') "属性类别" ,a.jlzt,0 px,a.memo "医保限制信息"    
,convert(money,isnull(b.BZJ,0)) "医保标准价",convert(money,(case when isnull(convert(money,isnull(b.BZJ,0)),0)=0 then 0 else (a.ypdj-convert(money,isnull(b.BZJ,0)))*a.ypsl end)) "超标金额"    
into #tempend    
from #tempbqmx a LEFT JOIN ZLXM b (nolock) ON a.dydm=b.XMLSH 
where a.idm=0    
UPDATE #tempend      
SET 医保标准价=0      
WHERE 医保标准价 IS NULL      
UPDATE #tempend      
SET 超标金额=0      
WHERE 超标金额 IS NULL      
insert into #tempend     
select idm "idm代码",qqrq "请求日期",sfrq "收费日期",ypdm "项目代码",rtrim(ypmc)+' ※'+rtrim(ypgg) + rtrim(flzfbl)  "项目名称规格"                
 ,ypdw "单位",ypsl "数量",ypdj "单价",zje "金额",flzfje "分类支付金额",zfje "自费金额",yhje "减免金额"                
 ,fylb "费用类别",cjmc "生产厂家",czyh "操作员代码",czymc "操作员",bqmc "病区",zxks "执行科室",isnull(sxlb,'[未]') "属性类别" ,jlzt,0 px,memo "医保限制信息"    
,null  "医保标准价",null "超标金额"    
from #tempbqmx    
where idm<>0     
order by sfrq        
     
insert into #tempend(idm代码,收费日期,项目名称规格,属性类别,jlzt,px)    
select 0,'★★★★','以下为汇总数据','',0,1    
    
insert into #tempend(idm代码,项目名称规格,数量,金额,分类支付金额,自费金额,减免金额,属性类别,jlzt,px)    
select 0,fpxmmc,sum(ypsl),sum(zje),sum(flzfje),sum(zfje),sum(yhje),'',0,2    
from #tempbqmx    
group by fpxmdm,fpxmmc    
    
    
insert into #tempend(idm代码,收费日期,项目名称规格,属性类别,jlzt,px)      
select 0,'★★★★','以下为汇总金额数据','',0,3      
              
insert into #tempend(idm代码,项目名称规格,数量,金额,分类支付金额,自费金额,减免金额,属性类别,jlzt,px)      
select 0,"总金额",0,sum(zje),sum(flzfje),sum(zfje),sum(yhje),'',0,4      
from #tempbqmx      
        
      
    
select * from #tempend order by px,收费日期      
    
return                  

GO
