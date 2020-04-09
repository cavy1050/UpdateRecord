if exists(select * from sysobjects where name='usp_cqyb_ddqq_yw_fymxcx_fymx')
  drop proc usp_cqyb_ddqq_yw_fymxcx_fymx
go

Create procedure usp_cqyb_ddqq_yw_fymxcx_fymx              
 @syxh   ut_syxh,  --��ҳ���                
 @dxmdm  ut_kmdm=null, --����Ŀ����                
 @idm ut_xh9=0,       --ҩidm                
 @ypdm ut_xmdm='',  --ҩƷ����                
 @jsxh ut_xh12=null, --�������                
 @cxlb ut_bz=0,        
 @hblcxm ut_bz=0,        
 @bqdm ut_ksdm = null  -- ��������        
                
as                
/**********                
[�汾��]4.0.0.0.0                
[����ʱ��]2003.10.24                
[����]����                
[��Ȩ] Copyright ? 1998-2001�Ϻ����˴�-����ҽ����Ϣ�������޹�˾                
[����] סԺϵͳ--������ϸ��ѯ2                
[����˵��]                
 ���˷�����ϸ��ѯ������ϸ��Ŀ���ã�                
[����˵��]                
 @syxh   ��ҳ���                
 @dxmdm  ut_kmdm=null, --����Ŀ����                
    @idm        ҩidm                
 @ypdm       ҩƷ����                
 @jsxh  �������                
 @cxlb  0=���У�1=����ҩ�ѣ�2=���з�ҩ��           
 @hblcxm �ϲ��ٴ���Ŀ             
 @bqdm   ��������        
[����ֵ]                
[�����������]                
 �ɹ������ݼ�                
 ����"F","������Ϣ"                
[���õ�sp]                
[����ʵ��]                
exec usp_bq_fymxcx_ex2 12,null,0,"",null,0                
--exec usp_bq_fymxcx_ex2 25,null,0,"",null,0                
--exec usp_bq_fymxcx_ex2 25,null,0,"",null,0                
[�޸���ʷ]                
**********/                
set nocount on                
                
declare @patid ut_syxh,                
        @rqfl char(2),                
        @ybdm ut_ybdm                
                
select @patid=patid,@ybdm=ybdm from ZY_BRSYK(NOLOCK) where syxh=@syxh and brzt not in (9) --���Բ�brzt=8��.               
if @@rowcount=0 or @@error<>0                
begin                
 select "F","�ò��˲����ڣ�"                
 return                
end                
SELECT @rqfl=rqfldm FROM YY_YBFLK where ybdm=@ybdm              
        
--modify by Wang Yi, �޸ĳɲ�����ʱ����ʽ���Ա��ڸ��·����Ը�����                
create table #tempbqmx                
(                
 idm  ut_xh9      not null, --ҩidm                
 qqrq varchar(20) null,  --��������                
 sfrq varchar(20) null,  --�շ�����                
 ypdm ut_xmdm  null,  --��Ŀ����                
 ypmc    ut_mc64  null,  --ҩƷ����                
 ypgg    ut_mc32  null,   --ҩƷ���                
 ypdw  ut_unit  null,  --��λ                
 ypsl numeric(10,2) null,  --����                
 ypdj money  null,  --����                
 zje ut_je14  null,  --���                
 flzfje ut_je14  null,  --����֧�����                
 zfje ut_je14  null,  --�Էѽ��                
 yhje ut_je14  null,  --������                
 fylb varchar(12) null,  --�������                
 cjmc ut_mc32  null,  --��������                
 czyh ut_czyh  null,  --����Ա����                
 czymc ut_name  null,  --����Ա                
 bqmc ut_mc32  null,  --����                
 zxks ut_mc32  null,  --ִ�п���                
 flzfbl varchar(10)  null,  --�����Ը�����                
 sxlb varchar(10) null,     --�������    
 jlzt ut_bz null,        --��¼״̬    
 fpxmdm ut_kmdm null, --��Ʊ��Ŀ����    
 fpxmmc ut_mc16 null, --��Ʊ��Ŀ����    
 memo   ut_mc64 null --��ע��Ϣ����ʾҽ����Ϣ    
 ,dydm VARCHAR(32) null               
)             
          
declare @selbz ut_bz        
if @idm = 0 and @ypdm=''         
 select @selbz = 0        
else        
 select @selbz = 1        
--ѡ�����        
select a.*,b.fpxmdm,b.fpxmmc into #tmpfymxk        
from VW_BRFYMXK a (nolock),ZY_BRJSMXK b (nolock)        
where a.syxh = @syxh and a.zje <> 0 and (@jsxh is null or a.jsxh = @jsxh)  and (@bqdm is null or a.bqdm = @bqdm) and a.jsxh=b.jsxh and a.dxmdm=b.dxmdm      
 and ( (@selbz=0 and ( @cxlb = 0         
        or (@cxlb = 1 and exists(select 1 from YY_SFDXMK where id=a.dxmdm and ypbz in (1,2,3)))        
        or (@cxlb = 2 and not exists(select 1 from YY_SFDXMK where id=a.dxmdm and ypbz in (1,2,3)))        
      ))--@selbz=0        
  or (@selbz<>0 and a.idm=@idm and a.ypdm=@ypdm and a.dxmdm=@dxmdm))        
        
--���ٴ���        
select bqdm,syxh,czyh,zxks,qqrq,zxrq,idm,ypdm,ypmc,ypgg,ypdw,convert(numeric(10,2),ypsl/dwxs) as ypsl,        
 convert(numeric(12,4),ypdj*dwxs/ykxs) as ypdj,zje,zfje,yhje,flzfje,fylb,lcxmdm,jlzt,fpxmdm,fpxmmc, dydm    
into #tmpbrfy        
from #tmpfymxk         
where (@hblcxm = 0 or lcxmdm = '0')        
        
if @hblcxm <> 0         
begin        
        
 --�ٴ��ϲ�        
 select distinct identity(int,1,1) id,syxh,czyh,yzxh,qqxh,qqrq,fylb,lcxmdm,lcxmmc,min(xh) minxh,max(xh) maxxh,sum(zje) zje,sum(zfje) zfje,sum(yhje) yhje,sum(flzfje) flzfje,1 as ypsl     
 into #tmplcxmk        
 from #tmpfymxk        
 where lcxmdm <> '0'          
 group by syxh,czyh,yzxh,qqxh,qqrq,fylb,lcxmdm,lcxmmc,(case when tyxh > 0 then 1 else 0 end)      
 order by syxh,qqrq         
 --�ϲ�        
 select a.id,a.minxh,a.zje,a.zfje,a.yhje,a.flzfje,(case when b.xmsl = 0 then c.ypsl else convert(numeric(12,2),(c.ypsl/dwxs)/b.xmsl) end) ypsl        
 into #tmplcsum        
 from #tmplcxmk a,YY_LCSFXMDYK b(NOLOCK),#tmpfymxk c         
 where a.lcxmdm = b.lcxmdm and a.minxh = c.xh and c.ypdm = b.xmdm        
 --�ҵ��ϲ���        
 insert into #tmpbrfy(bqdm,syxh,czyh,zxks,qqrq,zxrq,idm,ypdm,ypmc,ypgg,ypdw,ypsl,ypdj,        
  zje,zfje,yhje,flzfje,fylb,lcxmdm,jlzt,fpxmdm,fpxmmc )        
 select a.bqdm,a.syxh,a.czyh,a.zxks,a.qqrq,a.zxrq,0,a.lcxmdm,a.lcxmmc,'�ٴ���Ŀ',a.ypdw,b.ypsl,convert(numeric(12,4),case when b.ypsl = 0 then b.zje else b.zje/b.ypsl end) ypdj,        
  convert(numeric(12,4),isnull(b.zje,0)) zje,convert(numeric(12,4),isnull(b.zfje,0)) zfje,convert(numeric(12,4),isnull(b.yhje,0)) yhje,convert(numeric(12,4),isnull(b.flzfje,0)) flzfje,a.fylb,a.lcxmdm,a.jlzt ,a.fpxmdm,a.fpxmmc                
 from #tmpfymxk a,#tmplcsum b        
 where a.xh = b.minxh        
 --û�ҵ���        
 insert into #tmpbrfy(bqdm,syxh,czyh,zxks,qqrq,zxrq,idm,ypdm,ypmc,ypgg,ypdw,ypsl,ypdj,        
  zje,zfje,yhje,flzfje,fylb,lcxmdm,jlzt,fpxmdm,fpxmmc )        
 select a.bqdm,a.syxh,a.czyh,a.zxks,a.qqrq,a.zxrq,0,a.lcxmdm,a.lcxmmc,'�ٴ���Ŀ',a.ypdw,b.ypsl,convert(numeric(12,4),case when b.ypsl = 0 then b.zje else b.zje/b.ypsl end) ypdj,        
  convert(numeric(12,4),isnull(b.zje,0)) zje,convert(numeric(12,4),isnull(b.zfje,0)) zfje,convert(numeric(12,4),isnull(b.yhje,0)) yhje,convert(numeric(12,4),isnull(b.flzfje,0)) flzfje,a.fylb,a.lcxmdm,a.jlzt,a.fpxmdm,a.fpxmmc                 
 from #tmpfymxk a,#tmplcxmk b        
 where not exists(select 1 from #tmplcsum c where b.id = c.id)        
  and a.xh = b.minxh        
        
 update #tmpbrfy set ypdj = b.xmdj from #tmpbrfy a,YY_LCSFXMK b(NOLOCK) where a.lcxmdm = b.id and a.ypdj = 0        
end        
---        
 insert into #tempbqmx(idm,qqrq,sfrq,ypdm,ypmc,ypgg,ypdw,ypsl,ypdj,zje,flzfje,zfje,yhje,fylb,cjmc,czyh,czymc,bqmc,zxks,jlzt,fpxmdm,fpxmmc,memo,dydm)                
 select a.idm "idm����",substring(qqrq,1,4)+"."+substring(qqrq,5,2)+"."+substring(qqrq,7,2)+" "+substring(qqrq,9,8) "��������",        
  substring(zxrq,1,4)+"."+substring(zxrq,5,2)+"."+substring(zxrq,7,2)+" "+substring(zxrq,9,8) "�շ�����",                
  a.ypdm "��Ŀ����",rtrim(a.ypmc) ypmc, rtrim(a.ypgg) ypgg,a.ypdw "��λ",                
  convert(numeric(10,2),a.ypsl) "����",convert(money,a.ypdj) "����",                
  isnull(a.zje,0) "���",a.flzfje "����֧�����",isnull(a.zfje-a.flzfje,0) "�Էѽ��",isnull(a.yhje,0) "������",                
  case a.fylb when 0 then "��ʱҽ��"                 
   when 1 then "����ҽ��"                
   when 3 then "ҽ��"                
   when 4 then "�̶�����"                
   when 5 then "��ҩ"                
   when 6 then "��ҽ����Ŀ"                
   when 7 then "��������"                
   when 8 then "��Ժ��ҩ"                
   when 9 then "Ӥ������"                
   when 10 then "С����"                
   else "����" end "�������",c.cjmc "��������",                
   a.czyh "����Ա����",d.name  "����Ա", b.name  "����",case e.name when null then b.name else e.name end "ִ�п���" ,a.jlzt ,a.fpxmdm,a.fpxmmc,c.memo, a.dydm    
 from #tmpbrfy a(nolock) LEFT JOIN YK_YPCDMLK c(NOLOCK) ON a.idm = c.idm
                         LEFT JOIN czryk d(NOLOCK) ON a.czyh = d.id
						 LEFT JOIN YY_KSBMK e(nolock) ON a.zxks = e.id 
                         INNER JOIN ZY_BQDMK b(nolock) ON a.bqdm=b.id              
 order by zxrq                
        
 UPDATE #tempbqmx    
 SET sxlb=(CASE WHEN v.ylfydj=1 THEN "[��]" WHEN v.ylfydj=2 THEN "[��]" WHEN v.ylfydj=3 THEN "[��]" WHEN v.ylfydj=4 THEN "[��]" ELSE "[δ]" END)    
 FROM #tempbqmx t, VW_YBYPXM v(NOLOCK)    
 WHERE t.dydm=v.yblsh    
 IF @ybdm="122"    
  UPDATE #tempbqmx    
  SET sxlb=(CASE WHEN v.tqfydj=1 THEN "[��]" WHEN v.tqfydj=2 THEN "[��]" WHEN v.tqfydj=3 THEN "[��]" WHEN v.ylfydj=4 THEN "[��]" ELSE "[δ]" END)    
  FROM #tempbqmx t, VW_YBYPXM v(NOLOCK)    
  WHERE t.dydm=v.yblsh     
  AND v.tqfydj<>""    
  AND v.tqfydj IS NOT NULL    
    
--update #tempbqmx set sxlb=(case when  b.ybfydj=1 then '[��]' when b.ybfydj=2 then '[��]' when b.ybfydj=3 then '[��]' else '[δ]' end)                   
-- from #tempbqmx a(nolock),YK_YPCDMLK b(nolock)                   
-- where a.idm=b.idm and a.idm<>0                  
--update #tempbqmx set sxlb=(case when  c.ybfydj=1 then '[��]' when c.ybfydj=2 then '[��]' when c.ybfydj=3 then '[��]' else '[δ]' end)                  
--from #tempbqmx a(nolock),YY_SFXXMK c (nolock)                  
----where a.ypdm=c.id and c.zybz=1 and c.sybz=1                   
--where a.ypdm=c.id and a.idm=0        
      
select a.idm "idm����",a.qqrq "��������",a.sfrq "�շ�����",a.ypdm "��Ŀ����",rtrim(a.ypmc)+' ��'+rtrim(a.ypgg) + rtrim(a.flzfbl)  "��Ŀ���ƹ��"                
 ,a.ypdw "��λ",a.ypsl "����",a.ypdj "����",a.zje "���",a.flzfje "����֧�����",a.zfje "�Էѽ��",a.yhje "������"                
 ,a.fylb "�������",a.cjmc "��������",a.czyh "����Ա����",a.czymc "����Ա",a.bqmc "����",a.zxks "ִ�п���",isnull(a.sxlb,'[δ]') "�������" ,a.jlzt,0 px,a.memo "ҽ��������Ϣ"    
,convert(money,isnull(b.BZJ,0)) "ҽ����׼��",convert(money,(case when isnull(convert(money,isnull(b.BZJ,0)),0)=0 then 0 else (a.ypdj-convert(money,isnull(b.BZJ,0)))*a.ypsl end)) "������"    
into #tempend    
from #tempbqmx a LEFT JOIN ZLXM b (nolock) ON a.dydm=b.XMLSH 
where a.idm=0    
UPDATE #tempend      
SET ҽ����׼��=0      
WHERE ҽ����׼�� IS NULL      
UPDATE #tempend      
SET ������=0      
WHERE ������ IS NULL      
insert into #tempend     
select idm "idm����",qqrq "��������",sfrq "�շ�����",ypdm "��Ŀ����",rtrim(ypmc)+' ��'+rtrim(ypgg) + rtrim(flzfbl)  "��Ŀ���ƹ��"                
 ,ypdw "��λ",ypsl "����",ypdj "����",zje "���",flzfje "����֧�����",zfje "�Էѽ��",yhje "������"                
 ,fylb "�������",cjmc "��������",czyh "����Ա����",czymc "����Ա",bqmc "����",zxks "ִ�п���",isnull(sxlb,'[δ]') "�������" ,jlzt,0 px,memo "ҽ��������Ϣ"    
,null  "ҽ����׼��",null "������"    
from #tempbqmx    
where idm<>0     
order by sfrq        
     
insert into #tempend(idm����,�շ�����,��Ŀ���ƹ��,�������,jlzt,px)    
select 0,'�����','����Ϊ��������','',0,1    
    
insert into #tempend(idm����,��Ŀ���ƹ��,����,���,����֧�����,�Էѽ��,������,�������,jlzt,px)    
select 0,fpxmmc,sum(ypsl),sum(zje),sum(flzfje),sum(zfje),sum(yhje),'',0,2    
from #tempbqmx    
group by fpxmdm,fpxmmc    
    
    
insert into #tempend(idm����,�շ�����,��Ŀ���ƹ��,�������,jlzt,px)      
select 0,'�����','����Ϊ���ܽ������','',0,3      
              
insert into #tempend(idm����,��Ŀ���ƹ��,����,���,����֧�����,�Էѽ��,������,�������,jlzt,px)      
select 0,"�ܽ��",0,sum(zje),sum(flzfje),sum(zfje),sum(yhje),'',0,4      
from #tempbqmx      
        
      
    
select * from #tempend order by px,�շ�����      
    
return                  

GO
