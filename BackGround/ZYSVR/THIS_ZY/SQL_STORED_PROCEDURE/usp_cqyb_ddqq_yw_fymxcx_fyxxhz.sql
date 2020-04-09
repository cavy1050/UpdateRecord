if exists(select * from sysobjects where name='usp_cqyb_ddqq_yw_fymxcx_fyxxhz')
  drop proc usp_cqyb_ddqq_yw_fymxcx_fyxxhz
go

Create procedure usp_cqyb_ddqq_yw_fymxcx_fyxxhz              
	@syxh   ut_syxh,  --��ҳ���                  
	@dxmdm  ut_kmdm=null, --����Ŀ����                  
	@jsxh  ut_xh12=null, --�������                  
	@cxlb  ut_bz=0,          
	@bqdm  ut_ksdm=null          
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
 @bqdm  ��������          
[����ֵ]                  
[�����������]                  
 �ɹ������ݼ�                  
 ����"F","������Ϣ"                  
[���õ�sp]                  
[����ʵ��]      

exec usp_bq_fymxcx_ex1 506128,"13",884313            
[�޸���ʷ]                  
 2003.11.3 tony ������ҩƷ��ϸ������ҩ����ʾ                  
 2004.01.08 Wang Yi ������ʾ�����Ը�����                  
 2004.2.11 Wang Yi ��Ժ����������ʾ�շѲ���Ա                 
 2005.01.27 pgf  ���Ѳ�����ǹ��Ѳ��˷ֱ�ȡ��Ӧ��ҩƷ���ơ�              
 2010.12.01 add by yangdi ��Ժ���㲡�ˣ��������������У������ZY_BRFYMXK��jsxhû�и��£���ӡ����������Ŀ������ȡ����ʱ��ν��м���             
**********/                  
set nocount on                  
                  
declare @patid ut_syxh                  
	 , @brzt ut_bz --����״̬�� add by Wang Yi, 2004.02.13                  
	 , @sfczy varchar(16) --�շѲ���Ա                 
	 , @rqfl char(2),  @ybdm ut_ybdm            
	 , @ksrq_zy ut_rq16          
	 , @jsrq_zy ut_rq16                  
                  
select @patid=patid, @brzt = brzt,@ybdm=ybdm  from ZY_BRSYK where syxh=@syxh and brzt not in (8,9)                  
if @@rowcount=0 or @@error<>0                  
begin                  
	select "F","�ò��˲����ڣ�"                  
	return                  
end                  
                
SELECT @rqfl=rqfldm FROM YY_YBFLK where ybdm=@ybdm              
          
if @jsxh is not null          
	SELECT @ksrq_zy=ksrq,@jsrq_zy=jzrq from ZY_BRJSK (nolock) where xh=@jsxh            
                  
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
		if @brzt = 3 --��ѯ���ǳ�Ժ����                  
			select @sfczy = "(�շ�Ա:" + rtrim(jsczyh) + ")"                   
			from ZY_BRJSK (nolock)                   
			where xh = (select max(xh) from ZY_BRJSK (nolock)                   
				where syxh = @syxh and jszt = 2 and ybjszt = 2 and jlzt = 0)                  
		else                  
			select @sfczy = ""                  
			insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,ypdj,zje,zfje,yhje,flzfje,ybfydj)                  
			select 0,"",'����ܼ�' + @sfczy,"zz",null,null,null,null,sum(zje),sum(zfje),sum(yhje), sum(flzfje),'99'                  
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
                  
--modify by Wang Yi, 2004.01.08, ������ʾ�����Ը�����                  
update #tempbqmx                  
  SET ypmc=b.name                  
	  , flzfbl = (case when b.zyflzfbz = 1 and a.flzfje <> 0 then '���Ը�' + convert(varchar(10),convert(int, b.zyzfbl * 100)) + '%' else '' end)              
	  , ybfydj = b.ybfydj                  
from #tempbqmx a, YY_SFXXMK b                   
where a.ypdm=b.id and a.idm=0                  
 
insert #tempbqmx(idm,ypdm,ypmc,dxmdm,ypgg,ypdw,ypsl,ypdj,zje,zfje,yhje,flzfje,ybfydj)                  
	select 0,"",'�������ϣ�'+b.name,dxmdm,null,null,null,null,                  
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
select a.idm "idm����",a.ypdm "��Ŀ����",                  
		rtrim(a.ypmc)+' ��'+rtrim(a.ypgg)  "��Ŀ���ƹ��",                  
		rtrim(a.ypdw) "��λ",a.ypsl "����",a.ypdj "����",a.zje "���", /*a.flzfje*/ 0 "����֧�����",a.zfje  "�Էѽ��",                 
		a.yhje "������",a.dxmdm "����Ŀ����",@jsxh "�������",/*a.zje - (a.zfje - a.flzfje) - a.flzfje*/0 "�ɱ����",                  
		case a.ybfydj when 1 then '��' when 2 then '��' when 3 then '��'  when  99  then '' else  'δ' end ����                  
from #tempbqmx a--,YK_YPCDMLK b (nolock)                  
where a.zje<>0-- and a.idm*=b.idm                  
order by a.dxmdm,a.xh                  
return                  
  
GO
