if exists(select * from sysobjects where name='usp_cqyb_ddqq_yw_fymxcx_fyxxhz')
  drop proc usp_cqyb_ddqq_yw_fymxcx_fyxxhz
go

Create procedure usp_cqyb_ddqq_yw_fymxcx_fyxxhz              
	@syxh   ut_syxh,  --首页序号                  
	@dxmdm  ut_kmdm=null, --大项目代码                  
	@jsxh  ut_xh12=null, --结算序号                  
	@cxlb  ut_bz=0,          
	@bqdm  ut_ksdm=null          
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
 @bqdm  病区代码          
[返回值]                  
[结果集、排序]                  
 成功：数据集                  
 错误："F","错误信息"                  
[调用的sp]                  
[调用实例]      

exec usp_bq_fymxcx_ex1 506128,"13",884313            
[修改历史]                  
 2003.11.3 tony 增加了药品明细甲乙类药的显示                  
 2004.01.08 Wang Yi 增加显示分类自负比例                  
 2004.2.11 Wang Yi 出院病人增加显示收费操作员                 
 2005.01.27 pgf  公费病人与非公费病人分别取相应的药品名称。              
 2010.12.01 add by yangdi 在院结算病人，如果费用在年表中，结算后ZY_BRFYMXK中jsxh没有更新，打印不出汇总项目，所以取费用时间段进行计算             
**********/                  
set nocount on                  
                  
declare @patid ut_syxh                  
	 , @brzt ut_bz --病人状态， add by Wang Yi, 2004.02.13                  
	 , @sfczy varchar(16) --收费操作员                 
	 , @rqfl char(2),  @ybdm ut_ybdm            
	 , @ksrq_zy ut_rq16          
	 , @jsrq_zy ut_rq16                  
                  
select @patid=patid, @brzt = brzt,@ybdm=ybdm  from ZY_BRSYK where syxh=@syxh and brzt not in (8,9)                  
if @@rowcount=0 or @@error<>0                  
begin                  
	select "F","该病人不存在！"                  
	return                  
end                  
                
SELECT @rqfl=rqfldm FROM YY_YBFLK where ybdm=@ybdm              
          
if @jsxh is not null          
	SELECT @ksrq_zy=ksrq,@jsrq_zy=jzrq from ZY_BRJSK (nolock) where xh=@jsxh            
                  
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
	,dydm   VARCHAR(32)   NULL          
)                  
          
          
if @dxmdm is null                  
begin                  
	DECLARE @count ut_xh9                  
	SELECT @count=0             
                   
	IF @cxlb=0                  
	BEGIN               
		if @jsxh is null                  
		begin                  
			insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,zje,zfje,yhje,ypdj,flzfje,ybfydj, dydm)                  
			select a.idm,a.ypdm,a.ypmc,a.dxmdm,a.ypgg,max(a.ypdw),sum(a.ypsl/a.dwxs),isnull(sum(a.zje),0),isnull(sum(a.zfje),0),                  
			isnull(sum(a.yhje),0),0, isnull(sum(a.flzfje),0),b.ybfydj, a.dydm          
			from VW_BRFYMXK a(nolock),YK_YPCDMLK b(NOLOCK) 
			WHERE a.syxh=@syxh and a.idm<>0 and (@bqdm is null or a.bqdm = @bqdm)  
			  AND a.idm = b.idm                
			group by a.idm,a.ypdm,a.ypmc,a.dxmdm,a.ypgg,a.ypdw,b.ybfydj, a.dydm          
			select @count=@@rowcount                  
              
			insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,zje,zfje,yhje,ypdj,flzfje,ybfydj, dydm)                  
			select a.idm,a.ypdm,'',a.dxmdm,a.ypgg,max(a.ypdw),sum(a.ypsl/a.dwxs),isnull(sum(a.zje),0),isnull(sum(a.zfje),0),                  
			isnull(sum(a.yhje),0),0, isnull(sum(a.flzfje),0),b.ybfydj, a.dydm          
			from VW_BRFYMXK a(nolock),YY_SFXXMK b(NOLOCK) 
			WHERE a.syxh=@syxh and a.idm=0 and (@bqdm is null or a.bqdm = @bqdm)
			  AND a.ypdm = b.id                 
			group by  a.idm,a.ypdm,a.dxmdm,a.ypgg,a.ypdw,b.ybfydj, a.dydm         
			select @count=@count+@@rowcount                  
		end                  
		else                  
		begin      
			INSERT #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,zje,zfje,yhje,ypdj,flzfje,ybfydj, dydm)                  
			SELECT a.idm,a.ypdm,a.ypmc,a.dxmdm,a.ypgg,MAX(a.ypdw),SUM(a.ypsl/a.dwxs),ISNULL(SUM(a.zje),0),ISNULL(SUM(a.zfje),0),                  
			ISNULL(SUM(a.yhje),0),0, ISNULL(SUM(a.flzfje),0),b.ybfydj, a.dydm          
			FROM VW_BRFYMXK a(NOLOCK),YK_YPCDMLK b(NOLOCK) 
			WHERE a.syxh=@syxh AND ((a.ybzxrq BETWEEN @ksrq_zy AND @jsrq_zy) OR (a.jsxh=@jsxh)) AND a.idm<>0 AND (@bqdm IS NULL OR a.bqdm = @bqdm)
			  AND a.idm = b.idm                 
			GROUP BY a.idm,a.ypdm,a.ypmc,a.dxmdm,a.ypgg,a.ypdw,b.ybfydj, a.dydm  
		        
			SELECT @count=@@rowcount                  
                  
			INSERT #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,zje,zfje,yhje,ypdj,flzfje,ybfydj, dydm)                  
				SELECT a.idm,a.ypdm,'',a.dxmdm,a.ypgg,MAX(a.ypdw),SUM(a.ypsl/a.dwxs),ISNULL(SUM(a.zje),0),ISNULL(SUM(a.zfje),0),                  
				ISNULL(SUM(a.yhje),0),0, ISNULL(SUM(a.flzfje),0),b.ybfydj, a.dydm          
				FROM VW_BRFYMXK a(NOLOCK),YY_SFXXMK b(NOLOCK)
				WHERE a.syxh=@syxh AND ((a.ybzxrq BETWEEN @ksrq_zy AND @jsrq_zy) OR (a.jsxh=@jsxh)) AND a.idm=0 AND (@bqdm IS NULL OR a.bqdm = @bqdm)
				AND a.ypdm = b.id                 
				GROUP BY a.idm,a.ypdm,a.dxmdm,a.ypgg,a.ypdw,b.ybfydj, a.dydm  
			        
			select @count=@count+@@rowcount					           
		end                  
	END                  
	ELSE if @cxlb=1                  
	BEGIN                  
		if @jsxh is null                  
		begin                  
			insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,zje,zfje,yhje,ypdj,flzfje,ybfydj, dydm)                  
				select a.idm,a.ypdm,a.ypmc,a.dxmdm,a.ypgg,max(a.ypdw),sum(a.ypsl/a.dwxs),isnull(sum(a.zje),0),                  
				isnull(sum(a.zfje),0),isnull(sum(a.yhje),0),0, isnull(sum(a.flzfje),0),b.ybfydj, a.dydm          
				from VW_BRFYMXK a(nolock),YK_YPCDMLK b(NOLOCK) 
				WHERE a.syxh=@syxh 
				  AND a.dxmdm in (select id from YY_SFDXMK where ypbz in (1,2,3)) and a.idm<>0 and (@bqdm is null or a.bqdm = @bqdm)
				  AND a.idm = b.idm                 
				group by a.idm,a.ypdm,a.ypmc,a.dxmdm,a.ypgg,a.ypdw,b.ybfydj, a.dydm          
			select @count=@@rowcount                  
                  
			insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,zje,zfje,yhje,ypdj,flzfje,ybfydj, dydm)                  
				select a.idm,a.ypdm,'',a.dxmdm,a.ypgg,max(a.ypdw),sum(a.ypsl/a.dwxs),isnull(sum(a.zje),0),                  
				isnull(sum(a.zfje),0),isnull(sum(a.yhje),0),0, isnull(sum(a.flzfje),0),b.ybfydj, a.dydm          
				from VW_BRFYMXK a(nolock),YY_SFXXMK b(NOLOCK) 
				WHERE syxh=@syxh 
				AND a.dxmdm in (select id from YY_SFDXMK where ypbz in (1,2,3)) and a.idm=0 and (@bqdm is null or a.bqdm = @bqdm)
				AND a.ypdm = b.id                 
				group by a.idm,a.ypdm,a.dxmdm,a.ypgg,a.ypdw,b.ybfydj, a.dydm          
			select @count=@count+@@rowcount                  
		end                  
		else                  
		begin              
			insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,zje,zfje,yhje,ypdj,flzfje,ybfydj, dydm)                  
				select a.idm,a.ypdm,a.ypmc,a.dxmdm,a.ypgg,max(a.ypdw),sum(a.ypsl/a.dwxs),isnull(sum(a.zje),0),                  
				isnull(sum(a.zfje),0),isnull(sum(a.yhje),0),0, isnull(sum(a.flzfje),0),b.ybfydj, a.dydm          
				from VW_BRFYMXK a(nolock),YK_YPCDMLK b(NOLOCK) 
				WHERE a.syxh=@syxh and a.jsxh=@jsxh 
				  AND a.dxmdm in (select id from YY_SFDXMK where ypbz in (1,2,3)) and a.idm<>0                  
				  AND (@bqdm is null or a.bqdm = @bqdm)
				  AND a.idm = b.idm          
				group by a.idm,a.ypdm,a.ypmc,a.dxmdm,a.ypgg,a.ypdw,b.ybfydj, a.dydm          
			select @count=@@rowcount                  
                  
			insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,zje,zfje,yhje,ypdj,flzfje,ybfydj, dydm)                  
				select a.idm,a.ypdm,'',a.dxmdm,a.ypgg,max(a.ypdw),sum(a.ypsl/a.dwxs),isnull(sum(a.zje),0),                  
				isnull(sum(a.zfje),0),isnull(sum(a.yhje),0),0, isnull(sum(a.flzfje),0),b.ybfydj, a.dydm          
				from VW_BRFYMXK a(nolock) ,YY_SFXXMK b(NOLOCK)
				WHERE a.syxh=@syxh and a.jsxh=@jsxh and a.dxmdm in (select id from YY_SFDXMK where ypbz in (1,2,3)) and a.idm=0                  
				  AND (@bqdm is null or a.bqdm = @bqdm) 
				  AND a.ypdm = b.id         
				group by a.idm,a.ypdm,a.dxmdm,a.ypgg,a.ypdw,b.ybfydj, a.dydm          
			select @count=@count+@@rowcount                  
		end                  
	END                  
	ELSE
	BEGIN                  
		if @jsxh is null                  
		begin                  
			insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,zje,zfje,yhje,ypdj,flzfje,ybfydj, dydm)                  
				select a.idm,a.ypdm,a.ypmc,a.dxmdm,a.ypgg,max(ypdw),sum(ypsl/dwxs),isnull(sum(zje),0),isnull(sum(zfje),0),                  
				isnull(sum(yhje),0),0, isnull(sum(flzfje),0),b.ybfydj, a.dydm          
				from VW_BRFYMXK a(nolock) ,YK_YPCDMLK b (nolock) where syxh=@syxh and dxmdm not in (select id from YY_SFDXMK where ypbz in (1,2,3)) and a.idm<>0                  
				and (@bqdm is null or bqdm = @bqdm) 
				and a.idm=b.idm         
				group by a.idm,a.ypdm,a.ypmc,a.dxmdm,a.ypgg,a.ypdw,b.ybfydj,a.dydm          
			select @count=@@rowcount                  
                  
			insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,zje,zfje,yhje,ypdj,flzfje,ybfydj, dydm)             
				select a.idm,ypdm,'',a.dxmdm,a.ypgg,max(a.ypdw),sum(ypsl/dwxs),isnull(sum(zje),0),isnull(sum(zfje),0),                  
				isnull(sum(yhje),0),0, isnull(sum(flzfje),0),b.ybfydj, a.dydm          
				from VW_BRFYMXK a(nolock) ,YY_SFXXMK b (nolock) where syxh=@syxh and a.dxmdm not in (select id from YY_SFDXMK where ypbz in (1,2,3)) and a.idm=0                  
				and (@bqdm is null or bqdm = @bqdm)  
				 and a.ypdm=b.id       
				group by a.idm,a.ypdm,a.dxmdm,a.ypgg,a.ypdw,b.ybfydj, a.dydm          
			select @count=@count+@@rowcount                  
		end                  
		else                  
		begin                  
			insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,zje,zfje,yhje,ypdj,flzfje,ybfydj, dydm)                  
				select a.idm,a.ypdm,a.ypmc,a.dxmdm,a.ypgg,max(a.ypdw),sum(a.ypsl/a.dwxs),isnull(sum(zje),0),                  
				isnull(sum(zfje),0),isnull(sum(yhje),0),0, isnull(sum(flzfje),0),b.ybfydj, a.dydm          
				from VW_BRFYMXK a(nolock),YK_YPCDMLK b(nolock)
			  where syxh=@syxh and jsxh=@jsxh and dxmdm not in (select id from YY_SFDXMK where ypbz in (1,2,3)) and a.idm<>0                  
				and (@bqdm is null or bqdm = @bqdm)   
				and a.idm=b.idm       
				group by a.idm,a.ypdm,a.ypmc,a.dxmdm,a.ypgg,a.ypdw,b.ybfydj,a.dydm  
				        
			select @count=@@rowcount                  
                  
			insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,zje,zfje,yhje,ypdj,flzfje,ybfydj, dydm)                  
				select a.idm,a.ypdm,'',a.dxmdm,a.ypgg,max(ypdw),sum(ypsl/dwxs),isnull(sum(zje),0),                  
				isnull(sum(zfje),0),isnull(sum(yhje),0),0, isnull(sum(flzfje),0),b.ybfydj, a.dydm          
				from VW_BRFYMXK a(nolock),YY_SFXXMK b(nolock)
				 where syxh=@syxh and jsxh=@jsxh and a.dxmdm not in (select id from YY_SFDXMK where ypbz in (1,2,3)) and a.idm=0                  
				and (@bqdm is null or bqdm = @bqdm)    
				and a.ypdm=b.id      
				group by a.idm,a.ypdm,a.dxmdm,a.ypgg,a.ypdw,b.ybfydj,a.dydm          
          
			select @count=@count+@@rowcount                  
		end                  
	END                  
                  
	if @count>0                  
	begin                  
		if @brzt = 3 --查询的是出院病人                  
			select @sfczy = "(收费员:" + rtrim(jsczyh) + ")"                   
			from ZY_BRJSK (nolock)                   
			where xh = (select max(xh) from ZY_BRJSK (nolock)                   
				where syxh = @syxh and jszt = 2 and ybjszt = 2 and jlzt = 0)                  
		else                  
			select @sfczy = ""                  
			insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,ypdj,zje,zfje,yhje,flzfje,ybfydj)                  
			select 0,"",'☆☆总计' + @sfczy,"zz",null,null,null,null,sum(zje),sum(zfje),sum(yhje), sum(flzfje),'99'                  
			from #tempbqmx                   
	end                  
end                  
else 
BEGIN                  
	if @jsxh is null                  
	begin                  
		insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,zje,zfje,yhje,ypdj,flzfje,ybfydj, dydm)                  
			select a.idm,a.ypdm,a.ypmc,a.dxmdm,a.ypgg,max(a.ypdw),sum(ypsl/dwxs),isnull(sum(zje),0),isnull(sum(zfje),0),                  
			isnull(sum(yhje),0),0, isnull(sum(flzfje),0),b.ybfydj,a.dydm          
			from VW_BRFYMXK a(nolock),YK_YPCDMLK b(nolock)
			where syxh=@syxh and dxmdm=@dxmdm and a.idm<>0--and jsxh=@jsxh                  
			and (@bqdm is null or bqdm = @bqdm) 
			and a.idm=b.idm         
			group by a.idm,a.ypdm,a.ypmc,a.dxmdm,a.ypgg,a.ypdw,b.ybfydj,a.dydm          
                  
		insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,zje,zfje,yhje,ypdj,flzfje,ybfydj, dydm)                  
			select a.idm,a.ypdm,'',a.dxmdm,a.ypgg,max(a.ypdw),sum(ypsl/dwxs),isnull(sum(zje),0),isnull(sum(zfje),0),                  
			isnull(sum(a.yhje),0),0, isnull(sum(a.flzfje),0),b.ybfydj, a.dydm          
			from VW_BRFYMXK a(nolock),YY_SFXXMK b(nolock)
			 where syxh=@syxh and a.dxmdm=@dxmdm and a.idm=0 --and jsxh=@jsxh                  
			and (@bqdm is null or bqdm = @bqdm) 
			and a.ypdm=b.id         
			group by a.idm,a.ypdm,a.dxmdm,a.ypgg,a.ypdw,b.ybfydj,a.dydm          
	end                  
	else                  
	begin     
		insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,zje,zfje,yhje,ypdj,flzfje,ybfydj, dydm)                  
			select a.idm,a.ypdm,a.ypmc,a.dxmdm,a.ypgg,max(a.ypdw),sum(ypsl/dwxs),isnull(sum(zje),0),
			--ISNULL(sum(zfje),0), 
			SUM(case ISNULL(b.ybfydj,3) when 3 then isnull(zje,0) ELSE 0 END ),                  
			isnull(sum(a.yhje),0),0, isnull(sum(a.flzfje),0),b.ybfydj,a.dydm          
			from VW_BRFYMXK a(nolock),YK_YPCDMLK b(nolock)
			where syxh=@syxh and dxmdm=@dxmdm and jsxh=@jsxh and a.idm<>0
			and a.idm=b.idm                  
			and (@bqdm is null or bqdm = @bqdm)          
			group by a.idm,a.ypdm,a.ypmc,a.dxmdm,a.ypgg,a.ypdw,b.ybfydj,a.dydm          
                  
		insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,zje,zfje,yhje,ypdj,flzfje,ybfydj, dydm)                  
			select a.idm,a.ypdm,'',a.dxmdm,a.ypgg,max(a.ypdw),sum(a.ypsl/a.dwxs),isnull(sum(a.zje),0),
			--ISNULL(sum(zfje),0),
			SUM(case ISNULL(b.ybfydj,3) when 3 then isnull(a.zje,0) ELSE 0 END ),                  
			isnull(sum(a.yhje),0),0, isnull(sum(a.flzfje),0),b.ybfydj,a.dydm          
			from VW_BRFYMXK a(nolock),YY_SFXXMK b(nolock)
			 where syxh=@syxh and a.dxmdm=@dxmdm and a.jsxh=@jsxh and a.idm=0                  
			and (@bqdm is null or bqdm = @bqdm) 
			and a.ypdm=b.id         
			group by a.idm,a.ypdm,a.dxmdm,a.ypgg,a.ypdw,b.ybfydj,a.dydm          
	end                  
end                  
                  
--modify by Wang Yi, 2004.01.08, 增加显示分类自负比例                  
update #tempbqmx                  
  SET ypmc=b.name                  
	  , flzfbl = (case when b.zyflzfbz = 1 and a.flzfje <> 0 then '※自负' + convert(varchar(10),convert(int, b.zyzfbl * 100)) + '%' else '' end)              
	  , ybfydj = b.ybfydj                  
from #tempbqmx a, YY_SFXXMK b                   
where a.ypdm=b.id and a.idm=0                  
 
insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,ypdj,zje,zfje,yhje,flzfje,ybfydj)                  
	select 0,"",'△△以上：'+b.name,dxmdm,null,null,null,null,                  
	sum(isnull(zje,0))
	--,sum(isnull(zfje,0))
	,SUM(case ISNULL(a.ybfydj,3) when 3 then isnull(a.zje,0) ELSE 0 END) 
	,sum(isnull(yhje,0)),sum(isnull(flzfje,0)),'99'                  
	from #tempbqmx a,YY_SFDXMK b (nolock)                  
	where a.dxmdm=b.id                  
	group by a.dxmdm,b.name                  
                  
update #tempbqmx set ypdj = convert(money,zje/ypsl) where isnull(ypsl,0) <>0                   
                  
IF @ybdm="122"          
BEGIN          
	UPDATE #tempbqmx SET ybfydj=TQFYDJ FROM #tempbqmx a, ZLXM b WHERE a.dydm=b.XMLSH AND ISNULL(TQFYDJ,"")<>""          
	UPDATE #tempbqmx SET ybfydj=TQFYDJ FROM #tempbqmx a, YPML b WHERE a.dydm=b.YPLSH AND ISNULL(TQFYDJ,"")<>""          
END          
select a.idm "idm代码",a.ypdm "项目代码",                  
		rtrim(a.ypmc)+' ※'+rtrim(a.ypgg)  "项目名称规格",                  
		rtrim(a.ypdw) "单位",a.ypsl "数量",a.ypdj "单价",a.zje "金额", /*a.flzfje*/ 0 "分类支付金额",a.zfje  "自费金额",                 
		a.yhje "减免金额",a.dxmdm "大项目代码",@jsxh "结算序号",/*a.zje - (a.zfje - a.flzfje) - a.flzfje*/0 "可报金额",                  
		case a.ybfydj when 1 then '甲' when 2 then '乙' when 3 then '丙'  when  99  then '' else  '未' end 属性                  
from #tempbqmx a--,YK_YPCDMLK b (nolock)                  
where a.zje<>0-- and a.idm*=b.idm                  
order by a.dxmdm,a.xh                  
return                  
  
GO
