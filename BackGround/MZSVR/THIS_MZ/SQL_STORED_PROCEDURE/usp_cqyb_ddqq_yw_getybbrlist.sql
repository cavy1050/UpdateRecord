if exists(select * from sysobjects where name='usp_cqyb_ddqq_yw_getybbrlist')
  drop proc usp_cqyb_ddqq_yw_getybbrlist
GO
SET ANSI_NULLS ON
SET ANSI_WARNINGS ON 
go
CREATE proc usp_cqyb_ddqq_yw_getybbrlist
(
	@brlx			ut_bz='99',			--��������1��Ժ2��Ժ
	@ybdm			ut_ybdm='', 		--ҽ������
	@shbz           ut_bz='2'			--��˱�־0δ��ˣ�1����ˣ�2ȫ��   
)
as
/****************************************
[�汾��]4.0.0.0.0
[����ʱ��]2017.03.05
[����]FerryMan
[��Ȩ]Copyright ? 1998-2017���������Ƽ����Źɷ����޹�˾
[����]סԺҽ����˻�ȡ�����б�
[����˵��]
	סԺҽ����˻�ȡ�����б�
[����˵��]
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��]
[�޸ļ�¼]
****************************************/
set nocount on 
 
declare @ybjkid varchar(3),@configCQ61 varchar(4)

select @ybjkid = config from YY_CONFIG where id = 'CQ18'
SELECT @configCQ61 = config from YY_CONFIG where id = 'CQ61'
IF ISNULL(@configCQ61,'') = '' 
    SELECT @configCQ61 = '��' 
create table #temp_brlist       
(        
	syxh	ut_syxh		not null,			--��ҳ���
	jsxh	ut_xh12		not null,			--�������
	hzxm    ut_mc64			null,			--��������
	blh     ut_blh			null,			--סԺ��
	sex		ut_sex			null,			--�Ա�
	bqdm	ut_ksdm			null,			--��������
	cwdm	ut_cwdm			null,			--��λ����
	shbz	ut_bz			null			--��˱�־
) 

create table #temp_ybdmlist       
(        
	ybdm	ut_ybdm							--ҽ������
) 

insert into #temp_ybdmlist
select ybdm from YY_YBFLK where xtbz = 1 and ybjkid = @ybjkid and (@ybdm = '' or @ybdm = 'ALL' or ybdm = @ybdm) 

if @brlx = 1		--��Ժ����
begin
	insert into #temp_brlist(syxh,jsxh,hzxm,blh,sex,bqdm,cwdm,shbz) 
	select a.syxh,b.xh as jsxh,a.hzxm,a.blh,a.sex,a.bqdm,rtrim(a.cwdm),isnull(b.shbz,0)  
	from ZY_BRSYK a(nolock) 
		inner join ZY_BRJSK b(nolock) on a.syxh = b.syxh and b.jlzt = 0 and b.ybjszt <> 2 AND b.ybjszt <> 5
	where a.brzt in (2,4)
	and a.ybdm in (select ybdm from #temp_ybdmlist) 
	and ((@shbz <> '999' and isnull(b.shbz,0) = @shbz) or @shbz = '999')
end
else if @brlx = 2	--��Ժ����
begin 
	insert into #temp_brlist(syxh,jsxh,hzxm,blh,sex,bqdm,cwdm,shbz) 
	select a.syxh,b.xh as jsxh,a.hzxm,a.blh,a.sex,a.bqdm,rtrim(a.cwdm),isnull(b.shbz,0)  
	from ZY_BRSYK a(nolock) 
		inner join ZY_BRJSK b(nolock) on a.syxh = b.syxh and b.jlzt = 0 and b.ybjszt <> 2 AND b.ybjszt <> 5
	where a.brzt in (1,5,6,7)
	and a.ybdm in (select ybdm from #temp_ybdmlist) 
	and ((@shbz <> '999' and isnull(b.shbz,0) = @shbz) or @shbz = '999')
end
else if @brlx = 3	--�������г�Ժ��¼   VW_CQYB_CYJLYJSH  --����ͼΪ���Ӳ��������г�Ժ��¼��ɵ�syxh��
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
else if @brlx = 4	--δ����Ժ��������Ŀ
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
else if @brlx = 5	--��ʱ��Ժ
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
else if @brlx = 99	--���в���
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
	   a.hzxm as "��������",a.blh as "סԺ��",a.syxh "��ҳ���",a.sex "�Ա�",rtrim(a.cwdm) as "��λ����",a.jsxh as "�������",
	   ISNULL(a.shbz,0) as "��˱�־",a.bqdm, CASE ISNULL(b.spjg,'0') WHEN '2' THEN '[����]' else '' END wsspjg,d.gcbz
INTO #temp
FROM #temp_brlist a LEFT JOIN YY_CQYB_ZDYZDSPJG b(NOLOCK)  ON a.syxh = b.syxh 
					LEFT JOIN ZY_BCDMK c(NOLOCK) ON a.cwdm = c.id AND a.bqdm = c.bqdm
					LEFT JOIN YY_CWLBDMK d(NOLOCK) ON c.cwlb = d.id 
order BY a.bqdm ASC

IF @configCQ61 = '��'
    SELECT * FROM #temp
ELSE
    SELECT * FROM #temp WHERE ISNULL(gcbz,0) = 0

return
GO

SET ANSI_NULLS off
SET ANSI_WARNINGS OFF

go
