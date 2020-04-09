if exists(select * from sysobjects where name='usp_cqyb_ddqq_yw_fymxcx_yb')
  drop proc usp_cqyb_ddqq_yw_fymxcx_yb
go
CREATE  procedure usp_cqyb_ddqq_yw_fymxcx_yb  
  @syxh   ut_syxh,  --��ҳ���          
 @dxmdm  ut_kmdm=null, --����Ŀ����          
  @jsxh  ut_xh12=null, --�������          
  @cxlb  ut_bz=0          
as          
/**********          
[�汾��]4.0.0.0.0          
[����ʱ��]2003.10.24          
[����]����          
[��Ȩ] Copyright ? 1998-2001�Ϻ����˴�-����ҽ����Ϣ�������޹�˾          
[����] סԺϵͳ--������ϸ��ѯ1          
[����˵��]          
  ���˷�����ϸ��ѯ����С��Ŀ���ã�          
[����˵��]          
  @syxh   ��ҳ���          
  @dxmdm  ut_kmdm ����Ŀ����          
  @jsxh  �������          
  @cxlb  0=���У�1=����ҩ�ѣ�2=���з�ҩ��          
[����ֵ]          
[�����������]          
  �ɹ������ݼ�          
  ����"F","������Ϣ"          
[���õ�sp]          
[����ʵ��]          
[�޸���ʷ]          
  2003.11.3 tony ������ҩƷ��ϸ������ҩ����ʾ          
  2004.01.08 Wang Yi ������ʾ�����Ը�����          
  2004.2.11 Wang Yi ��Ժ����������ʾ�շѲ���Ա         
  2005.01.27 pgf  ���Ѳ�����ǹ��Ѳ��˷ֱ�ȡ��Ӧ��ҩƷ���ơ�         
**********/          
set nocount on          
          
declare @patid ut_syxh          
  , @brzt ut_bz --����״̬�� add by Wang Yi, 2004.02.13          
  , @sfczy varchar(16) --�շѲ���Ա         
  , @rqfl char(2),  @ybdm ut_ybdm            
          
select @patid=patid, @brzt = brzt,@ybdm=ybdm  from ZY_BRSYK where syxh=@syxh and brzt not in (9)          
if @@rowcount=0 or @@error<>0          
begin          
  select "F","�ò��˲����ڣ�"          
  return          
end          
          
create table #tempbqmx          
(          
  xh            ut_xh12 identity  not null, --���          
  idm           ut_xh9              not null, --ҩidm          
     ypdm          ut_xmdm                null, --ҩƷ����          
     ypmc          ut_mc64                 null, --ҩƷ����          
     dxmdm         ut_kmdm                 null, --�������          
     ypgg          ut_mc32                 null, --ҩƷ���          
     ypdw          ut_unit                 null, --ҩƷ��λ          
     ypsl          ut_sl10                null, --ҩƷ����          
     ypdj          ut_money               null, --ҩƷ����          
     zje           ut_money               null, --���          
     zfje          ut_money               null, --�Էѽ��          
  yhje    ut_money      null --�Żݽ��          
  ,flzfje  ut_money  null  --����֧�����,add by Wang Yi, 2003.10.15          
  ,flzfbl  varchar(10) null --�����Ը�������add by Wang Yi, 2004.01.08          
  ,ybfydj  ut_bz null --ҽ������Ǽ�      
  ,memo   ut_mc64 null --��ע��Ϣ����ʾҽ����Ϣ  
 ,ybshbz ut_bz NULL --ҽ����˱�־ 0��������� 1�����ͨ�� 2����˲�ͨ��  
)          
          
if @dxmdm is null          
begin          
  declare @count ut_xh9          
  select @count=0          
          
  if @cxlb=0          
  begin          
    if @jsxh is null          
    begin          
      insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,zje,zfje,yhje,ypdj,flzfje,ybfydj, ybshbz)          
   select idm,ypdm,ypmc,dxmdm,ypgg,max(ypdw),sum(ypsl/dwxs),isnull(sum(zje),0),isnull(sum(zfje),0),          
      isnull(sum(yhje),0),0, isnull(sum(flzfje),0),0,0 
	 --ybfydj,(CASE WHEN (cqybsplx<>0 and cqybspbz=0) THEN 0 WHEN (cqybsplx<>0 and cqybspbz=1) THEN 1 ELSE 2 END)  
   from VW_BRFYMXK (nolock) where syxh=@syxh and idm<>0          
   group by idm,ypdm,ypmc,dxmdm,ypgg,ypdw--,ybfydj, cqybsplx,cqybspbz  
     
   select @count=@@rowcount          
          
      insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,zje,zfje,yhje,ypdj,flzfje,ybfydj, ybshbz)          
   select idm,ypdm,ypmc,dxmdm,ypgg,max(ypdw),sum(ypsl/dwxs),isnull(sum(zje),0),isnull(sum(zfje),0),          
      isnull(sum(yhje),0),0, isnull(sum(flzfje),0),0,0
	  --ybfydj,(CASE WHEN (cqybsplx<>0 and cqybspbz=0) THEN 0 WHEN (cqybsplx<>0 and cqybspbz=1) THEN 1 ELSE 2 END)  
   from VW_BRFYMXK (nolock) where syxh=@syxh and idm=0          
   group by idm,ypdm,ypmc,dxmdm,ypgg,ypdw--,ybfydj,cqybsplx,cqybspbz  
     
   select @count=@count+@@rowcount          
    end          
    else          
    begin          
      insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,zje,zfje,yhje,ypdj,flzfje,ybfydj, ybshbz)          
      select idm,ypdm,ypmc,dxmdm,ypgg,max(ypdw),sum(ypsl/dwxs),isnull(sum(zje),0),isnull(sum(zfje),0),          
      isnull(sum(yhje),0),0, isnull(sum(flzfje),0),0,0
	   --ybfydj,(CASE WHEN (cqybsplx<>0 and cqybspbz=0) THEN 0 WHEN (cqybsplx<>0 and cqybspbz=1) THEN 1 ELSE 2 END)  
       from VW_BRFYMXK (nolock) where syxh=@syxh and jsxh=@jsxh and idm<>0          
       group by idm,ypdm,ypmc,dxmdm,ypgg,ypdw--,ybfydj, cqybsplx,cqybspbz  
      select @count=@@rowcount          
             
      insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,zje,zfje,yhje,ypdj,flzfje,ybfydj, ybshbz)          
      select idm,ypdm,ypmc,dxmdm,ypgg,max(ypdw),sum(ypsl/dwxs),isnull(sum(zje),0),isnull(sum(zfje),0),          
       isnull(sum(yhje),0),0, isnull(sum(flzfje),0),0,0
	   --ybfydj, (CASE WHEN (cqybsplx<>0 and cqybspbz=0) THEN 0 WHEN (cqybsplx<>0 and cqybspbz=1) THEN 1 ELSE 2 END)  
       from VW_BRFYMXK (nolock) where syxh=@syxh and jsxh=@jsxh and idm=0          
       group by idm,ypdm,ypmc,dxmdm,ypgg,ypdw--,ybfydj, cqybsplx,cqybspbz  
      select @count=@count+@@rowcount          
    end          
  end          
  else if @cxlb=1          
  begin          
    if @jsxh is null          
    begin          
      insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,zje,zfje,yhje,ypdj,flzfje,ybfydj, ybshbz)          
      select idm,ypdm,ypmc,dxmdm,ypgg,max(ypdw),sum(ypsl/dwxs),isnull(sum(zje),0),          
       isnull(sum(zfje),0),isnull(sum(yhje),0),0, isnull(sum(flzfje),0),0,0
	   --ybfydj, (CASE WHEN (cqybsplx<>0 and cqybspbz=0) THEN 0 WHEN (cqybsplx<>0 and cqybspbz=1) THEN 1 ELSE 2 END)  
       from VW_BRFYMXK (nolock) where syxh=@syxh and   
    dxmdm in (select id from YY_SFDXMK where ypbz in (1,2,3)) and idm<>0          
       group by idm,ypdm,ypmc,dxmdm,ypgg,ypdw
       --,ybfydj, cqybsplx,cqybspbz  
      select @count=@@rowcount          
             
      insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,zje,zfje,yhje,ypdj,flzfje,ybfydj, ybshbz)          
      select idm,ypdm,ypmc,dxmdm,ypgg,max(ypdw),sum(ypsl/dwxs),isnull(sum(zje),0),          
       isnull(sum(zfje),0),isnull(sum(yhje),0),0, isnull(sum(flzfje),0),0,0
	  -- ,ybfydj, (CASE WHEN (cqybsplx<>0 and cqybspbz=0) THEN 0 WHEN (cqybsplx<>0 and cqybspbz=1) THEN 1 ELSE 2 END)  
       from VW_BRFYMXK (nolock) where syxh=@syxh and   
    dxmdm in (select id from YY_SFDXMK where ypbz in (1,2,3)) and idm=0          
       group by idm,ypdm,ypmc,dxmdm,ypgg,ypdw--,ybfydj, cqybsplx,cqybspbz  
      select @count=@count+@@rowcount          
    end          
    else          
    begin          
      insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,zje,zfje,yhje,ypdj,flzfje,ybfydj, ybshbz)          
      select idm,ypdm,ypmc,dxmdm,ypgg,max(ypdw),sum(ypsl/dwxs),isnull(sum(zje),0),          
       isnull(sum(zfje),0),isnull(sum(yhje),0),0, isnull(sum(flzfje),0),0,0
	  -- ybfydj, (CASE WHEN (cqybsplx<>0 and cqybspbz=0) THEN 0 WHEN (cqybsplx<>0 and cqybspbz=1) THEN 1 ELSE 2 END)  
       from VW_BRFYMXK (nolock) where syxh=@syxh and jsxh=@jsxh and dxmdm in (select id from YY_SFDXMK where ypbz in (1,2,3)) and idm<>0          
       group by idm,ypdm,ypmc,dxmdm,ypgg,ypdw--,ybfydj, cqybsplx,cqybspbz  
      select @count=@@rowcount          
             
      insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,zje,zfje,yhje,ypdj,flzfje,ybfydj, ybshbz)          
      select idm,ypdm,ypmc,dxmdm,ypgg,max(ypdw),sum(ypsl/dwxs),isnull(sum(zje),0),          
       isnull(sum(zfje),0),isnull(sum(yhje),0),0, isnull(sum(flzfje),0),0,0
	   --ybfydj, (CASE WHEN (cqybsplx<>0 and cqybspbz=0) THEN 0 WHEN (cqybsplx<>0 and cqybspbz=1) THEN 1 ELSE 2 END)  
       from VW_BRFYMXK (nolock) where syxh=@syxh and jsxh=@jsxh and dxmdm in (select id from YY_SFDXMK where ypbz in (1,2,3)) and idm=0          
       group by idm,ypdm,ypmc,dxmdm,ypgg,ypdw--,ybfydj, cqybsplx,cqybspbz  
select @count=@count+@@rowcount          
    end          
  end          
  else begin          
    if @jsxh is null          
    begin          
      insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,zje,zfje,yhje,ypdj,flzfje,ybfydj, ybshbz)          
      select idm,ypdm,ypmc,dxmdm,ypgg,max(ypdw),sum(ypsl/dwxs),isnull(sum(zje),0),isnull(sum(zfje),0),          
       isnull(sum(yhje),0),0, isnull(sum(flzfje),0),0,0
	   --,ybfydj, (CASE WHEN (cqybsplx<>0 and cqybspbz=0) THEN 0 WHEN (cqybsplx<>0 and cqybspbz=1) THEN 1 ELSE 2 END)  
       from VW_BRFYMXK (nolock) where syxh=@syxh and dxmdm not in (select id from YY_SFDXMK where ypbz in (1,2,3)) and idm<>0          
       group by idm,ypdm,ypmc,dxmdm,ypgg,ypdw---,ybfydj, cqybsplx,cqybspbz  
      select @count=@@rowcount          
             
      insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,zje,zfje,yhje,ypdj,flzfje,ybfydj, ybshbz)          
      select idm,ypdm,ypmc,dxmdm,ypgg,max(ypdw),sum(ypsl/dwxs),isnull(sum(zje),0),isnull(sum(zfje),0),          
       isnull(sum(yhje),0),0, isnull(sum(flzfje),0),0,0
	   --ybfydj, (CASE WHEN (cqybsplx<>0 and cqybspbz=0) THEN 0 WHEN (cqybsplx<>0 and cqybspbz=1) THEN 1 ELSE 2 END)  
       from VW_BRFYMXK (nolock) where syxh=@syxh and dxmdm not in (select id from YY_SFDXMK where ypbz in (1,2,3)) and idm=0          
       group by idm,ypdm,ypmc,dxmdm,ypgg,ypdw--,ybfydj, cqybsplx,cqybspbz  
      select @count=@count+@@rowcount          
    end          
    else          
    begin          
      insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,zje,zfje,yhje,ypdj,flzfje,ybfydj, ybshbz)          
      select idm,ypdm,ypmc,dxmdm,ypgg,max(ypdw),sum(ypsl/dwxs),isnull(sum(zje),0),          
       isnull(sum(zfje),0),isnull(sum(yhje),0),0, isnull(sum(flzfje),0),0,0
	   --ybfydj, (CASE WHEN (cqybsplx<>0 and cqybspbz=0) THEN 0 WHEN (cqybsplx<>0 and cqybspbz=1) THEN 1 ELSE 2 END)  
       from VW_BRFYMXK (nolock) where syxh=@syxh and jsxh=@jsxh and dxmdm not in (select id from YY_SFDXMK where ypbz in (1,2,3)) and idm<>0          
       group by idm,ypdm,ypmc,dxmdm,ypgg,ypdw--,ybfydj, cqybsplx,cqybspbz  
      select @count=@@rowcount          
             
      insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,zje,zfje,yhje,ypdj,flzfje,ybfydj, ybshbz)          
      select idm,ypdm,ypmc,dxmdm,ypgg,max(ypdw),sum(ypsl/dwxs),isnull(sum(zje),0),          
       isnull(sum(zfje),0),isnull(sum(yhje),0),0, isnull(sum(flzfje),0),0,0
	   --ybfydj, (CASE WHEN (cqybsplx<>0 and cqybspbz=0) THEN 0 WHEN (cqybsplx<>0 and cqybspbz=1) THEN 1 ELSE 2 END)  
       from VW_BRFYMXK (nolock) where syxh=@syxh and jsxh=@jsxh and dxmdm not in (select id from YY_SFDXMK where ypbz in (1,2,3)) and idm=0          
       group by idm,ypdm,ypmc,dxmdm,ypgg,ypdw--,ybfydj, cqybsplx,cqybspbz  
      select @count=@count+@@rowcount          
    end          
  end          
          
  if @count>0          
  begin          
    if @brzt = 3 --��ѯ���ǳ�Ժ����          
      select @sfczy = "(�շ�Ա:" + rtrim(jsczyh) + ")"           
       from ZY_BRJSK (nolock)           
       where xh = (select max(xh) from ZY_BRJSK (nolock)           
         where syxh = @syxh and jszt = 2 and ybjszt = 2 and jlzt = 0)          
    else          
      select @sfczy = ""          
  
    insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,ypdj,zje,zfje,yhje,flzfje,ybfydj, ybshbz)          
     select 0,"",'����ܼ�' + @sfczy,"zz",null,null,null,null,sum(zje),sum(zfje),sum(yhje), sum(flzfje),'99', NULL  
     from #tempbqmx           
  end          
end          
else begin          
  if @jsxh is null          
  begin          
    insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,zje,zfje,yhje,ypdj,flzfje,ybfydj, ybshbz)          
    select idm,ypdm,ypmc,dxmdm,ypgg,max(ypdw),sum(ypsl/dwxs),isnull(sum(zje),0),isnull(sum(zfje),0),          
     isnull(sum(yhje),0),0, isnull(sum(flzfje),0),0,0
	 --ybfydj, (CASE WHEN (cqybsplx<>0 and cqybspbz=0) THEN 0 WHEN (cqybsplx<>0 and cqybspbz=1) THEN 1 ELSE 2 END)  
     from VW_BRFYMXK (nolock) where syxh=@syxh and dxmdm=@dxmdm and idm<>0--and jsxh=@jsxh          
     group by idm,ypdm,ypmc,dxmdm,ypgg,ypdw--,ybfydj, cqybsplx,cqybspbz  
            
    insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,zje,zfje,yhje,ypdj,flzfje,ybfydj, ybshbz)          
    select idm,ypdm,ypmc,dxmdm,ypgg,max(ypdw),sum(ypsl/dwxs),isnull(sum(zje),0),isnull(sum(zfje),0),          
     isnull(sum(yhje),0),0, isnull(sum(flzfje),0),0,0
	 --ybfydj, (CASE WHEN (cqybsplx<>0 and cqybspbz=0) THEN 0 WHEN (cqybsplx<>0 and cqybspbz=1) THEN 1 ELSE 2 END)  
     from VW_BRFYMXK (nolock) where syxh=@syxh and dxmdm=@dxmdm and idm=0 --and jsxh=@jsxh          
     group by idm,ypdm,ypmc,dxmdm,ypgg,ypdw--,ybfydj, cqybsplx,cqybspbz  
  end          
  else          
  begin          
    insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,zje,zfje,yhje,ypdj,flzfje,ybfydj, ybshbz)          
    select idm,ypdm,ypmc,dxmdm,ypgg,max(ypdw),sum(ypsl/dwxs),isnull(sum(zje),0),isnull(sum(zfje),0),          
     isnull(sum(yhje),0),0, isnull(sum(flzfje),0),0,0
	 --ybfydj, (CASE WHEN (cqybsplx<>0 and cqybspbz=0) THEN 0 WHEN (cqybsplx<>0 and cqybspbz=1) THEN 1 ELSE 2 END)  
     from VW_BRFYMXK (nolock) where syxh=@syxh and dxmdm=@dxmdm and jsxh=@jsxh and idm<>0          
     group by idm,ypdm,ypmc,dxmdm,ypgg,ypdw--,ybfydj, cqybsplx,cqybspbz  
            
    insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,zje,zfje,yhje,ypdj,flzfje,ybfydj, ybshbz)          
    select idm,ypdm,ypmc,dxmdm,ypgg,max(ypdw),sum(ypsl/dwxs),isnull(sum(zje),0),isnull(sum(zfje),0),          
     isnull(sum(yhje),0),0, isnull(sum(flzfje),0),0,0
	 --ybfydj, (CASE WHEN (cqybsplx<>0 and cqybspbz=0) THEN 0 WHEN (cqybsplx<>0 and cqybspbz=1) THEN 1 ELSE 2 END)  
     from VW_BRFYMXK (nolock) where syxh=@syxh and dxmdm=@dxmdm and jsxh=@jsxh and idm=0          
     group by idm,ypdm,ypmc,dxmdm,ypgg,ypdw--,ybfydj, cqybsplx,cqybspbz  
  end          
end          
          
update #tempbqmx          
 set memo=b.memo          
from #tempbqmx a, YK_YPCDMLK b           
where a.idm=b.idm and isnull(b.memo,"")<>""  
  
update #tempbqmx          
 set memo=b.memo          
from #tempbqmx a, YY_SFXXMK b           
where a.idm=0 and a.ypdm=b.id and isnull(b.memo,"")<>""  
  
/*        
if @rqfl<>'02' --ҽ��              
 update #tempbqmx set ypmc=(case when b.ybmc='' then b.ypmc else b.ybmc end),        
  flzfbl = (case when b.zyflzfbz = 1 and a.flzfje <> 0 then '���Ը�' + convert(varchar(10),convert(int, b.zyzfbl * 100)) + '%' else '' end)                
 , ybfydj = b.ybfydj      
    from #tempbqmx a,YK_YPCDMLK b where a.idm=b.idm              
if @rqfl='02'--����              
 update #tempbqmx set ypmc=(case when b.gfmc='' then b.ypmc else b.gfmc end),            
   flzfbl = (case when b.zyflzfbz = 1 and a.flzfje <> 0 then '���Ը�' + convert(varchar(10),convert(int, b.zyzfbl * 100)) + '%' else '' end)         
 , ybfydj = b.ybfydj      
 from #tempbqmx a,YK_YPCDMLK b where a.idm=b.idm           
          
*/            
        
insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,ypdj,zje,zfje,yhje,flzfje,ybfydj, ybshbz)          
select 0,"",'�������ϣ�'+b.name,dxmdm,null,null,null,null,          
  sum(isnull(zje,0)),sum(isnull(zfje,0)),sum(isnull(yhje,0)),sum(isnull(flzfje,0)),'99', NULL  
 from #tempbqmx a,YY_SFDXMK b (nolock)          
 where a.dxmdm=b.id          
 group by a.dxmdm,b.name          
  
update #tempbqmx set ypdj = convert(money,zje/ypsl) where isnull(ypsl,0) <>0           
          
select a.idm "idm����",a.ypdm "��Ŀ����",        --0-1  
   rtrim(a.ypmc)+' ��'+rtrim(a.ypgg)  "��Ŀ���ƹ��",        --2  
   rtrim(a.ypdw) "��λ",a.ypsl "����",a.ypdj "����",a.zje "���", --3,6         
   case a.ybfydj when '1' then '��' when '2' then '��' when '3' then '��'  when  99  then '' else  'δ' end ����,  
 a.memo "ҽ����Ϣ",dxmdm "����Ŀ����",@jsxh--8,10  
 , (CASE a.ybshbz WHEN 0 THEN "������ͨ��" WHEN 1 THEN "����ͨ��" WHEN 2 THEN " " END) AS "ҽ����˱�־"  
from #tempbqmx a--,YK_YPCDMLK b (nolock)          
where a.zje<>0-- and a.idm*=b.idm          
order by a.dxmdm,a.xh, a.ybshbz  
return 

GO
