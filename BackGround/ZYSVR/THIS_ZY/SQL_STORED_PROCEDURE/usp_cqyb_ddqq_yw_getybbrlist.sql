if exists(select * from sysobjects where name='usp_cqyb_ddqq_yw_getybbrlist')
  drop proc usp_cqyb_ddqq_yw_getybbrlist
GO
SET ANSI_NULLS ON
SET ANSI_WARNINGS ON 
go
CREATE proc usp_cqyb_ddqq_yw_getybbrlist
(
	@brlx			ut_bz='99',			--病人类型1出院2在院
	@ybdm			ut_ybdm='', 		--医保代码
	@shbz           ut_bz='2'			--审核标志0未审核，1已审核，2全部   
)
as
/****************************************
[版本号]4.0.0.0.0
[创建时间]2017.03.05
[作者]FerryMan
[版权]Copyright ? 1998-2017卫宁健康科技集团股份有限公司
[描述]住院医保审核获取病人列表
[功能说明]
	住院医保审核获取病人列表
[参数说明]
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]
[修改记录]
****************************************/
set nocount on 
 
declare @ybjkid varchar(3),@configCQ61 varchar(4)

select @ybjkid = config from YY_CONFIG where id = 'CQ18'
SELECT @configCQ61 = config from YY_CONFIG where id = 'CQ61'
IF ISNULL(@configCQ61,'') = '' 
    SELECT @configCQ61 = '是' 
create table #temp_brlist       
(        
	syxh	ut_syxh		not null,			--首页序号
	jsxh	ut_xh12		not null,			--结算序号
	hzxm    ut_mc64			null,			--患者姓名
	blh     ut_blh			null,			--住院号
	sex		ut_sex			null,			--性别
	bqdm	ut_ksdm			null,			--病区代码
	cwdm	ut_cwdm			null,			--床位代码
	shbz	ut_bz			null			--审核标志
) 

create table #temp_ybdmlist       
(        
	ybdm	ut_ybdm							--医保代码
) 

insert into #temp_ybdmlist
select ybdm from YY_YBFLK where xtbz = 1 and ybjkid = @ybjkid and (@ybdm = '' or @ybdm = 'ALL' or ybdm = @ybdm) 

if @brlx = 1		--出院病人
begin
	insert into #temp_brlist(syxh,jsxh,hzxm,blh,sex,bqdm,cwdm,shbz) 
	select a.syxh,b.xh as jsxh,a.hzxm,a.blh,a.sex,a.bqdm,rtrim(a.cwdm),isnull(b.shbz,0)  
	from ZY_BRSYK a(nolock) 
		inner join ZY_BRJSK b(nolock) on a.syxh = b.syxh and b.jlzt = 0 and b.ybjszt <> 2 AND b.ybjszt <> 5
	where a.brzt in (2,4)
	and a.ybdm in (select ybdm from #temp_ybdmlist) 
	and ((@shbz <> '999' and isnull(b.shbz,0) = @shbz) or @shbz = '999')
end
else if @brlx = 2	--在院病人
begin 
	insert into #temp_brlist(syxh,jsxh,hzxm,blh,sex,bqdm,cwdm,shbz) 
	select a.syxh,b.xh as jsxh,a.hzxm,a.blh,a.sex,a.bqdm,rtrim(a.cwdm),isnull(b.shbz,0)  
	from ZY_BRSYK a(nolock) 
		inner join ZY_BRJSK b(nolock) on a.syxh = b.syxh and b.jlzt = 0 and b.ybjszt <> 2 AND b.ybjszt <> 5
	where a.brzt in (1,5,6,7)
	and a.ybdm in (select ybdm from #temp_ybdmlist) 
	and ((@shbz <> '999' and isnull(b.shbz,0) = @shbz) or @shbz = '999')
end
else if @brlx = 3	--在区已有出院记录   VW_CQYB_CYJLYJSH  --此视图为电子病历中已有出院记录完成的syxh表
begin 
	insert into #temp_brlist(syxh,jsxh,hzxm,blh,sex,bqdm,cwdm,shbz) 
	select a.syxh,b.xh as jsxh,a.hzxm,a.blh,a.sex,a.bqdm,rtrim(a.cwdm),isnull(b.shbz,0)  
	from ZY_BRSYK a(nolock) 
		inner join ZY_BRJSK b(nolock) on a.syxh = b.syxh and b.jlzt = 0 and b.ybjszt <> 2 AND b.ybjszt <> 5
		inner join VW_CQYB_CYJLYJSH c(nolock) on a.syxh = c.syxh
	where a.brzt in (1,5,6,7)
	and a.ybdm in (select ybdm from #temp_ybdmlist) 
	and ((@shbz <> '999' and isnull(b.shbz,0) = @shbz) or @shbz = '999')
end
else if @brlx = 4	--未结算院内审批项目
begin 
	insert into #temp_brlist(syxh,jsxh,hzxm,blh,sex,bqdm,cwdm,shbz) 
	select distinct a.syxh,b.xh as jsxh,a.hzxm,a.blh,a.sex,a.bqdm,rtrim(a.cwdm),isnull(b.shbz,0)  
	from ZY_BRSYK a(nolock) 
		inner join ZY_BRJSK b(nolock) on a.syxh = b.syxh and b.jlzt = 0 and b.ybjszt <> 2 AND b.ybjszt <> 5
		inner join ZY_BRFYMXK c(nolock) on a.syxh = c.syxh and c.jszt = 0 and c.jlzt = 0 and c.idm <> 0
		inner join YY_CQYB_ZDYSPXM d(nolock) on convert(varchar(20),c.idm) = d.xmdm and d.jlzt = 0 and d.xmlb in ('0','1')		                                    
	where a.brzt not in (3,8,9) 
	and a.ybdm in (select ybdm from #temp_ybdmlist) 
	and ((@shbz <> '999' and isnull(b.shbz,0) = @shbz) or @shbz = '999')

	insert into #temp_brlist(syxh,jsxh,hzxm,blh,sex,bqdm,cwdm,shbz) 
	select distinct a.syxh,b.xh as jsxh,a.hzxm,a.blh,a.sex,a.bqdm,rtrim(a.cwdm),isnull(b.shbz,0)  
	from ZY_BRSYK a(nolock) 
		inner join ZY_BRJSK b(nolock) on a.syxh = b.syxh and b.jlzt = 0 and b.ybjszt <> 2 AND b.ybjszt <> 5
		inner join ZY_BRFYMXK c(nolock) on a.syxh = c.syxh and c.jszt = 0 and c.jlzt = 0 and c.idm = 0
		inner join YY_CQYB_ZDYSPXM d(nolock) on c.ypdm = d.xmdm and d.jlzt = 0 and d.xmlb in ('0','1')		                                    
	where a.brzt not in (3,8,9)
	and a.ybdm in (select ybdm from #temp_ybdmlist) 
	and ((@shbz <> '999' and isnull(b.shbz,0) = @shbz) or @shbz = '999')
END
else if @brlx = 5	--临时出院
BEGIN
    insert into #temp_brlist(syxh,jsxh,hzxm,blh,sex,bqdm,cwdm,shbz) 
	select a.syxh,b.xh as jsxh,a.hzxm,a.blh,a.sex,a.bqdm,rtrim(a.cwdm),isnull(b.shbz,0)  
	from ZY_BRSYK a(nolock) 
		inner join ZY_BRJSK b(nolock) on a.syxh = b.syxh and b.jlzt = 0 and b.ybjszt <> 2 AND b.ybjszt <> 5
		inner join VW_CQYB_LSCY c(nolock) on a.syxh = c.syxh
	where a.brzt in (1,5,6,7)
	and a.ybdm in (select ybdm from #temp_ybdmlist) 
	and ((@shbz <> '999' and isnull(b.shbz,0) = @shbz) or @shbz = '999')
END
else if @brlx = 99	--所有病人
begin 
	insert into #temp_brlist(syxh,jsxh,hzxm,blh,sex,bqdm,cwdm,shbz) 
	select a.syxh,b.xh as jsxh,a.hzxm,a.blh,a.sex,a.bqdm,rtrim(a.cwdm),isnull(b.shbz,0)  
	from ZY_BRSYK a(nolock) 
		inner join ZY_BRJSK b(nolock) on a.syxh = b.syxh and b.jlzt = 0 and b.ybjszt <> 2 AND b.ybjszt <> 5
	where a.brzt not in (3,8,9) 
	and a.ybdm in (select ybdm from #temp_ybdmlist) 
	and ((@shbz <> '999' and isnull(b.shbz,0) = @shbz) or @shbz = '999')
end

SELECT DISTINCT 
	   a.hzxm as "患者姓名",a.blh as "住院号",a.syxh "首页序号",a.sex "性别",rtrim(a.cwdm) as "床位代码",a.jsxh as "结算序号",
	   ISNULL(a.shbz,0) as "审核标志",a.bqdm, CASE ISNULL(b.spjg,'0') WHEN '2' THEN '[外伤]' else '' END wsspjg,d.gcbz
INTO #temp
FROM #temp_brlist a LEFT JOIN YY_CQYB_ZDYZDSPJG b(NOLOCK)  ON a.syxh = b.syxh 
					LEFT JOIN ZY_BCDMK c(NOLOCK) ON a.cwdm = c.id AND a.bqdm = c.bqdm
					LEFT JOIN YY_CWLBDMK d(NOLOCK) ON c.cwlb = d.id 
order BY a.bqdm ASC

IF @configCQ61 = '是'
    SELECT * FROM #temp
ELSE
    SELECT * FROM #temp WHERE ISNULL(gcbz,0) = 0

return
GO

SET ANSI_NULLS off
SET ANSI_WARNINGS OFF

go
