if exists(select * from sysobjects where name='usp_cqyb_ddqq_yw_fymxcx_yb')
  drop proc usp_cqyb_ddqq_yw_fymxcx_yb
go
CREATE  procedure usp_cqyb_ddqq_yw_fymxcx_yb  
  @syxh   ut_syxh,  --首页序号          
 @dxmdm  ut_kmdm=null, --大项目代码          
  @jsxh  ut_xh12=null, --结算序号          
  @cxlb  ut_bz=0          
as          
/**********          
[版本号]4.0.0.0.0          
[创建时间]2003.10.24          
[作者]王毅          
[版权] Copyright ? 1998-2001上海金仕达-卫宁医疗信息技术有限公司          
[描述] 住院系统--费用明细查询1          
[功能说明]          
  病人费用明细查询（查小项目费用）          
[参数说明]          
  @syxh   首页序号          
  @dxmdm  ut_kmdm 大项目代码          
  @jsxh  结算序号          
  @cxlb  0=所有，1=所有药费，2=所有非药费          
[返回值]          
[结果集、排序]          
  成功：数据集          
  错误："F","错误信息"          
[调用的sp]          
[调用实例]          
[修改历史]          
  2003.11.3 tony 增加了药品明细甲乙类药的显示          
  2004.01.08 Wang Yi 增加显示分类自负比例          
  2004.2.11 Wang Yi 出院病人增加显示收费操作员         
  2005.01.27 pgf  公费病人与非公费病人分别取相应的药品名称。         
**********/          
set nocount on          
          
declare @patid ut_syxh          
  , @brzt ut_bz --病人状态， add by Wang Yi, 2004.02.13          
  , @sfczy varchar(16) --收费操作员         
  , @rqfl char(2),  @ybdm ut_ybdm            
          
select @patid=patid, @brzt = brzt,@ybdm=ybdm  from ZY_BRSYK where syxh=@syxh and brzt not in (9)          
if @@rowcount=0 or @@error<>0          
begin          
  select "F","该病人不存在！"          
  return          
end          
          
create table #tempbqmx          
(          
  xh            ut_xh12 identity  not null, --序号          
  idm           ut_xh9              not null, --药idm          
     ypdm          ut_xmdm                null, --药品代码          
     ypmc          ut_mc64                 null, --药品名称          
     dxmdm         ut_kmdm                 null, --大项代码          
     ypgg          ut_mc32                 null, --药品规格          
     ypdw          ut_unit                 null, --药品单位          
     ypsl          ut_sl10                null, --药品数量          
     ypdj          ut_money               null, --药品单价          
     zje           ut_money               null, --金额          
     zfje          ut_money               null, --自费金额          
  yhje    ut_money      null --优惠金额          
  ,flzfje  ut_money  null  --分类支付金额,add by Wang Yi, 2003.10.15          
  ,flzfbl  varchar(10) null --分类自负比例，add by Wang Yi, 2004.01.08          
  ,ybfydj  ut_bz null --医保分类登记      
  ,memo   ut_mc64 null --备注信息，显示医保信息  
 ,ybshbz ut_bz NULL --医保审核标志 0：无需审核 1：审核通过 2：审核不通过  
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
    if @brzt = 3 --查询的是出院病人          
      select @sfczy = "(收费员:" + rtrim(jsczyh) + ")"           
       from ZY_BRJSK (nolock)           
       where xh = (select max(xh) from ZY_BRJSK (nolock)           
         where syxh = @syxh and jszt = 2 and ybjszt = 2 and jlzt = 0)          
    else          
      select @sfczy = ""          
  
    insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,ypdj,zje,zfje,yhje,flzfje,ybfydj, ybshbz)          
     select 0,"",'☆☆总计' + @sfczy,"zz",null,null,null,null,sum(zje),sum(zfje),sum(yhje), sum(flzfje),'99', NULL  
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
if @rqfl<>'02' --医保              
 update #tempbqmx set ypmc=(case when b.ybmc='' then b.ypmc else b.ybmc end),        
  flzfbl = (case when b.zyflzfbz = 1 and a.flzfje <> 0 then '※自负' + convert(varchar(10),convert(int, b.zyzfbl * 100)) + '%' else '' end)                
 , ybfydj = b.ybfydj      
    from #tempbqmx a,YK_YPCDMLK b where a.idm=b.idm              
if @rqfl='02'--公费              
 update #tempbqmx set ypmc=(case when b.gfmc='' then b.ypmc else b.gfmc end),            
   flzfbl = (case when b.zyflzfbz = 1 and a.flzfje <> 0 then '※自负' + convert(varchar(10),convert(int, b.zyzfbl * 100)) + '%' else '' end)         
 , ybfydj = b.ybfydj      
 from #tempbqmx a,YK_YPCDMLK b where a.idm=b.idm           
          
*/            
        
insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,ypdj,zje,zfje,yhje,flzfje,ybfydj, ybshbz)          
select 0,"",'△△以上：'+b.name,dxmdm,null,null,null,null,          
  sum(isnull(zje,0)),sum(isnull(zfje,0)),sum(isnull(yhje,0)),sum(isnull(flzfje,0)),'99', NULL  
 from #tempbqmx a,YY_SFDXMK b (nolock)          
 where a.dxmdm=b.id          
 group by a.dxmdm,b.name          
  
update #tempbqmx set ypdj = convert(money,zje/ypsl) where isnull(ypsl,0) <>0           
          
select a.idm "idm代码",a.ypdm "项目代码",        --0-1  
   rtrim(a.ypmc)+' ※'+rtrim(a.ypgg)  "项目名称规格",        --2  
   rtrim(a.ypdw) "单位",a.ypsl "数量",a.ypdj "单价",a.zje "金额", --3,6         
   case a.ybfydj when '1' then '甲' when '2' then '乙' when '3' then '非'  when  99  then '' else  '未' end 属性,  
 a.memo "医保信息",dxmdm "大项目代码",@jsxh--8,10  
 , (CASE a.ybshbz WHEN 0 THEN "审批不通过" WHEN 1 THEN "审批通过" WHEN 2 THEN " " END) AS "医保审核标志"  
from #tempbqmx a--,YK_YPCDMLK b (nolock)          
where a.zje<>0-- and a.idm*=b.idm          
order by a.dxmdm,a.xh, a.ybshbz  
return 

GO
