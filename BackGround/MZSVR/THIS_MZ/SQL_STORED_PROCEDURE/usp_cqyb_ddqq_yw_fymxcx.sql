if exists(select * from sysobjects where name='usp_cqyb_ddqq_yw_fymxcx')
  drop proc usp_cqyb_ddqq_yw_fymxcx
go

Create procedure usp_cqyb_ddqq_yw_fymxcx             
 @syxh   ut_syxh,  --��ҳ���              
 @lb   ut_bz=0,  --���              
 @dxmdm  ut_kmdm=null, --����Ŀ����              
    @idm        ut_xh9=0,       --ҩidm              
 @ypdm       ut_xmdm='',  --ҩƷ����              
 @jsxh  ut_xh12=null, --�������              
 @cxlb  ut_bz=0              
              
as              
/**********              
[�汾��]4.0.0.0.0              
[����ʱ��]2001.11.21              
[����]��ΰ��              
[��Ȩ] Copyright ? 1998-2001�Ϻ����˴�-����ҽ����Ϣ�������޹�˾              
[����] סԺϵͳ--������ϸ��ѯ              
[����˵��]              
 ���˷�����ϸ��ѯ(�洢�������Ż�,�ֳ������洢������,�˴洢����ֻ�����)              
[����˵��]              
 @syxh   ��ҳ���              
 @lb   ��� 0=�������              
 @dxmdm  ut_kmdm ����Ŀ���루lb=1ʱʹ�ã�              
    @idm        ҩidm��lb=2ʱʹ�ã�              
 @ypdm       ҩƷ���루lb=2ʱʹ�ã�              
 @jsxh  �������              
 @cxlb  0=���У�1=����ҩ�ѣ�2=���з�ҩ��              
[����ֵ]              
[�����������]              
 �ɹ������ݼ�              
 ����"F","������Ϣ"              
[���õ�sp]              
[����ʵ��]              
[�޸���ʷ]              
 yxp С���޸�ǰ��������ʾ��һ              
 hcy �޸�ҩƷ�Ĵ�������ҩƷ��־ȡ.              
 2003.10.15 Wang Yi               
  1�����ص��Էѽ����Ҫ�۳�����֧������              
  2�����ؽ�������ӷ���֧����ǰ̨ͨ�����������Ƿ����0���ж��Ƿ��Ƿ���֧����Ŀ              
 2003.10.24 Wang Yi              
  �洢�������Ż�,�ֳ������洢������,�˴洢����ֻ����              
  Ϊ�����޸�סԺ����ģ�飬�ӿڲ��������Ķ�������              
**********/              
set nocount on              
              
declare @patid ut_syxh 
      -- ,@jsxh ut_xh12              
              
select @patid=patid from ZY_BRSYK where syxh=@syxh and brzt not in (9)  ----���Բ�brzt=8��.            
if @@rowcount=0 or @@error<>0              
begin              
 select "F","�ò��˲����ڣ�"              
 return              
end              
               
if @lb <> 0               
begin              
 select "F", "�����������ȷ"              
 return              
end              
              
create table #tempbqdx              
(              
    jsxh          ut_xh12           not null, --�������              
    lb       ut_bz    not null, --���              
    dxmdm         ut_kmdm               null, --�������              
    dxmmc         ut_mc16              null, --��������              
    xmje          ut_money           null, --��Ŀ���              
    zfje          ut_money              null, --�Էѽ��              
    yhje          ut_money              null, --�Żݽ��              
    yeje          ut_money              null, --Ӥ�����              
    kbje as (xmje - zfje),  --�ɱ����              
    memo    ut_memo    null  --��ע              
    ,flzfje  ut_money  null  --����֧�����,add by Wang Yi, 2003.10.15              
)              
              
              
/*
insert #tempbqdx(jsxh,lb,dxmdm,dxmmc,xmje,zfje,yhje,yeje,flzfje)              
select b.jsxh,0,b.dxmdm,b.dxmmc,b.xmje,b.zfje,b.yhje,b.yeje,b.flzfje              
 from ZY_BRJSK a (nolock),ZY_BRJSMXK b (nolock)--20130530zhyy����ʷ��Ĺ�ϵ�޸�Ϊ��ͼ              
 where a.syxh=@syxh and a.xh=b.jsxh and a.jlzt=0 and b.xmje<>0            
*/


--�ӷ�����ϸ��ȡ���ã��ϼƴ�����Ϣ����Ҫ�����Էѽ��

select @jsxh = a.xh from ZY_BRJSK a WHERE a.syxh = @syxh AND a.jlzt = 0

insert #tempbqdx(jsxh,lb,dxmdm,dxmmc,xmje,zfje,yhje,yeje,flzfje) 
SELECT @jsxh jsxh,0,a.dxmdm,b.name dxmmc
	,SUM(a.zje) xmje
	,SUM(CASE WHEN ISNULL(c.ybfydj,3) = 3 THEN a.zje ELSE 0 END) zfje
	,SUM(a.yhje) yhje
	,0 yeje
	,0 flzfje 
FROM VW_BRFYMXK a(NOLOCK),YY_SFDXMK b(NOLOCK),
		 YK_YPCDMLK c(NOLOCK) --LEFT JOIN YPML d(NOLOCK) ON (CASE WHEN ISNULL(c.dydm,'') = '' THEN '197827' ELSE c.dydm END) = d.YPLSH
WHERE a.dxmdm = b.id 
  AND a.idm = c.idm
  AND a.idm <> 0
  AND a.jszt = 0 
  AND a.syxh = @syxh 
GROUP BY a.jsxh,a.dxmdm,b.name

UNION ALL

SELECT @jsxh jsxh,0,a.dxmdm,b.name dxmmc
	,SUM(a.zje) xmje
	,SUM(CASE WHEN ISNULL(c.ybfydj,3) = 3 THEN a.zje ELSE 0 END) zfje
	,SUM(a.yhje) yhje
	,0 yeje
	,0 flzfje 
FROM ZY_BRFYMXK a(NOLOCK),YY_SFDXMK b(NOLOCK),
     YY_SFXXMK c(NOLOCK) --LEFT JOIN ZLXM d(NOLOCK) ON (CASE WHEN ISNULL(c.dydm,'') = '' THEN '67790' ELSE c.dydm END) = d.XMLSH
WHERE a.dxmdm = b.id 
  AND a.ypdm = c.id
  AND a.idm = 0
  AND a.jszt = 0 
  AND a.syxh = @syxh 
GROUP BY a.jsxh,a.dxmdm,b.name


select jsxh, sum(yeje) as yeje              
into #yeje from #tempbqdx where lb=0 group by jsxh              
          
     /*   
insert #tempbqdx(jsxh,lb,dxmdm,dxmmc,xmje,zfje,yhje,yeje,flzfje)              
select a.xh,1,"","�ܼ�",a.zje,a.zfyje,a.yhje,b.yeje,a.flzfje              
 from ZY_BRJSK a (nolock),#yeje b (nolock)               
 where a.syxh=@syxh and a.jlzt=0  and a.xh*=b.jsxh  --and a.zje<>0  --hkh on 2003.04.29     
        */
 insert #tempbqdx(jsxh,lb,dxmdm,dxmmc,xmje,zfje,yhje,yeje,flzfje)              
select a.xh,1,"","�ܼ�",a.zje,SUM(b.zfje),SUM(b.yhje),SUM(b.yeje),SUM(b.flzfje)              
 from ZY_BRJSK a (nolock),#tempbqdx b (nolock)               
 where a.syxh=@syxh and a.jlzt=0  and a.xh=b.jsxh 
 GROUP BY a.xh,a.zje
              
insert #tempbqdx(jsxh,lb,dxmdm,dxmmc,xmje,zfje,yhje,yeje,flzfje)              
select xh,3,null,null,null,null,null,null,null              
 from ZY_BRJSK (nolock) where syxh=@syxh and jlzt=0              
              
insert #tempbqdx(jsxh,lb,dxmdm,dxmmc,xmje,zfje,yhje,yeje,flzfje)              
select jsxh,2,null,"Ѻ���ۼ�",sum(jje-dje),null,null,null,null              
 from ZYB_BRYJK (nolock) where syxh=@syxh and czlb in (0,1,2,3,4,5,6) and               
  jsxh in (select jsxh from #tempbqdx)              
 group by jsxh              
              
select dxmdm "��Ŀ����",dxmmc "��Ŀ����",xmje "��Ŀ���",flzfje "����֧�����",zfje-flzfje "�Էѽ��",
       0 "�ɱ����",yhje "������",jsxh "�������",yeje "Ӥ�����"              
 from #tempbqdx order by jsxh,lb             
return              

GO
