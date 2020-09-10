use THIS_MZ
GO
alter proc usp_frmzsjsb_zlcf
@ksrq ut_rq16='',
@jsrq ut_rq16='',
@yydm varchar(4)='0000' 
as
/******
示例：exec usp_frmzsjsb_zlcf '2020010100:00:00','2020013123:59:59','01'
说明：诊疗处方(usp_frmzsjsb_zlcf)
作者：winning-dingsong-chongqing
时间：20200828
参数：挂号日期 between @ksrq and @jsrq  
		@yyid：医院代码
exec usp_hqms_frmzblxx_jbxx @ksrq,@jsrq,@yyid
******/
set nocount on


IF(ISNULL(@ksrq,'')='' OR ISNULL(@jsrq,'')='') ---默认前7天到前一天之间的日期段  
BEGIN  
SELECT @ksrq = CONVERT(VARCHAR(8),DATEADD(DAY,-7,GETDATE()),112)+'00:00:00'
SELECT @jsrq = CONVERT(VARCHAR(8),DATEADD(DAY,-1,GETDATE()),112)+'23:59:59'  
END  
else  
begin  
select @ksrq=LEFT(@ksrq,8)+'00:00:00'  
select @jsrq=LEFT(@jsrq,8)+'23:59:59'  
end

create table #fepailist                      
(GHXH varchar(16) ,--挂号序号                      
 HZXM varchar(32) NOT NULL, --患者姓名                      
 SEX  varchar(8) NULL,  --性别                      
 GHLB INT NOT NULL,  -- 挂号类别                                 
 PATID varchar(16) NOT NULL, -- 患者的唯一ID：门诊取VW_JZJLK.PATID,住院取CPOE_BRSYK.CPOE_BRSYK                                     
 BLH varchar(32) NULL,  --- 病历号                      
 CARDTYPE varchar(8) NULL, --- 卡类型                      
 CARDNO varchar(32) NULL, --- 卡号                      
 SFZH varchar(32) NULL, --- 身份证号                      
 BIRTH varchar(16) NULL, ---出生日期                                       
 GHKSDM varchar(16) NULL,   ---科室代码                      
 KSMC varchar(32) NULL,   ---科室名称                                      
 JZRQ varchar(32) NOT NULL, ----就诊日期：门诊 VW_JZJLK.GHRQ, 住院CPOE_BRSYK.RYRQ    
 JSSJH varchar(100),--结算收据号                    
 YBDM varchar(10)--医保代码  
) 

declare @jgdm varchar(32),@yymc varchar(32)
if(@yydm='01' or @yydm='0000')
begin
select @jgdm=yydm,@yymc=name from [MZSVR].THIS_MZ.dbo.YY_JBCONFIG(nolock) where id='01'
select @jgdm='67866859X'
end
else if(@yydm='02')
begin
select @jgdm=yydm,@yymc=name from [MZSVR].THIS_MZ.dbo.YY_JBCONFIG(nolock) where id='02'
select @jgdm='07882355X'
end
else
begin
select 'F','医院代码不匹配！'
return
end

insert into #fepailist
exec usp_hqms_frmzblxx_jbxx @ksrq,@jsrq,@yydm

create table #temp
(
P7502	varchar(50)	not null	,--	就诊卡号		门急诊卡号
P7506	varchar(20)	not null	,--	就诊日期		门急诊患者填写挂号日期时间，【yyyy-MM-dd HH:mm:ss】格式
P7000	varchar(50)	not null	,--	门诊就诊流水号		同发热门诊病例信息关联
P4	varchar(40)	not null	,--	姓名		
P7800	varchar(50)	not null	,--	处方号		【处方号】联合【处方明细代码】唯一标识记录字段
P7801	varchar(20)		,--	处方开具时间		【yyyy-MM-dd HH:mm:ss】格式
P7802	varchar(2)		,--	处方类别代码	【CT05.10.007处方类别代码】	
P7803	varchar(30)		,--	处方项目分类代码	【CV06.00.229医嘱项目类别代码】	
P7804	varchar(100)		,--	处方项目分类名称		
P7805	varchar(30)	not null	,--	处方明细代码		医院内部药品编码
P7806	varchar(100)	not null	,--	处方明细名称		医院内部药品名称
P7807	varchar(20)		,--	中药类别名称		
P7808	varchar(2)		,--	中药类别代码	【CV06.00.101中药使用类别代码】	
P7809	varchar(200)		,--	草药脚注		
P7810	varchar(100)		,--	药物类型代码	【CV5301.06药物类型代码】	
P7811	varchar(100)		,--	药物类型		
P7812	varchar(2)		,--	药物剂型代码	【CV08.50.002药物剂型代码】	
P7813	varchar(110)		,--	药物剂型名称		
P7814	varchar(50)		,--	药品规格		
P7815	varchar(20)	not null	,--	药物使用-频率		
P7816	numeric(30,4)		,--	药物使用-总剂量		类型为数值，且精度小于等于4
P7817	numeric(30,4)	not null	,--	药物使用-次剂量		类型为数值，且精度小于等于4
P7818	varchar(10)	not null	,--	药物使用-剂量单位		
P7819	varchar(3)		,--	药物使用-途径代码	【CV06.00.102用药途径代码】	
P7820	varchar(30)		,--	药物使用-途径		
P7821	varchar(10)		,--	皮试判别(是否过敏)	"【RC016】1=是2=否"	
P7822	varchar(20)		,--	用药开始时间		【yyyy-MM-dd HH:mm:ss】格式
P7823	varchar(20)		,--	用药停止日期时间		【yyyy-MM-dd HH:mm:ss】格式
P7824	numeric(5)		,--	用药天数		类型为整数
P7825	varchar(1)		,--	是否主药	"【RC016】1=是2=否"	
P7826	varchar(1)		,--	是否加急	"【RC016】1=是2=否"	
P7827	varchar(70)		,--	科室代码	【RC023科室代码】	
P7828	varchar(50)		,--	科室名称		
P7829	varchar(1)		,--	是否统一采购药品	"【RC016】1=是2=否"	
P7830	varchar(20)		,--	药品采购码		填写医疗机构所在地区药品采购平台的药品编码
P7831	varchar(50)		,--	药管平台码		
P7832	varchar(2)		--	是否基本药物	"【RC016】1=是2=否"	
)

insert into #temp
select distinct--a.xh,
isnull(a.CARDNO,'') P7502,
isnull(stuff(stuff(stuff(a.JZRQ,5,0,'-'),8,0,'-'),11,0,' '),'') P7506,
isnull(a.BLH,'') P7000,
isnull(a.HZXM,'') P4,--P4
isnull(b.xh,0) P7800,
stuff(stuff(stuff(b.lrrq,5,0,'-'),8,0,'-'),11,0,' ') P7801,
'' P7802,--b.cflx P7802,
'' P7803,--c.dxmdm P7803,
'' P7804,--d.mzfp_mc P7804,--P7804
isnull(c.ypdm,0) P7805,
isnull(c.ypmc,'') P7806,
case c.dxmdm when '02' then '中成药' when '03' then '中草药' else '未使用' end P7807,--P7807
'' P7808,--case c.dxmdm when '02' then '2' when '03' then '3' else '1' end,--P7808
c.memo P7809,
'' P7810,--e.fldm P7810,
ypfl.name P7811,
'' P7812,--e.jxdm P7812,
jx.name P7813,
c.ypgg P7814,
isnull(yzpc.xsmc,'') P7815,
case when c.ypsl>0 then c.ypsl else null end P7816,
isnull(hjmx.ypjl,0) P7817,
isnull(hjmx.jldw,'') P7818,--P7818
'' P7819,--hjmx.ypyf P7819,
ypyf.name P7820,
case gmjl.gmlx when 0 then 2 when 1 then 1 end P7821,--P7821
case when isnull(b.pyrq,'')<>'' then stuff(stuff(stuff(b.pyrq,5,0,'-'),8,0,'-'),11,0,' ') else null end P7822,
'' P7823,
hjmx.ts P7824,
'' P7825,
'' P7826,
'' P7827,--b.ksdm P7827,
ks.name P7828,
'' P7829,
'' P7830,'' P7831,'' P7832
from #fepailist a(nolock)
left join VW_MZCFK b(nolock) on a.PATID=b.patid and a.GHXH=b.ghxh
left join VW_MZCFMXK c(nolock) on b.xh=c.cfxh
left join VW_HJCFMXK hjmx(nolock) on c.hjmxxh=hjmx.xh
--left join YY_SFDXMK d on c.dxmdm=d.mzfp_id
left join YK_YPCDMLK e(nolock) on c.cd_idm=e.idm
left join YK_YPFLK ypfl(nolock) on e.fldm=ypfl.id
left join YK_YPJXK jx(nolock) on e.jxdm=jx.id
left join SF_YS_YZPCK yzpc(nolock) on hjmx.pcdm=yzpc.id
left join SF_YPYFK ypyf(nolock) on hjmx.ypyf=ypyf.id
left join SF_YS_BRGMJLK gmjl(nolock) on hjmx.xh=gmjl.hjmxxh and a.PATID=b.patid and hjmx.cd_idm=gmjl.cd_idm
left join YY_KSBMK ks(nolock) on b.ksdm=ks.id

--替换换行符
declare @sql varchar(max)=''
select @sql=@sql+'replace(replace('+name+',char(10),''；''),char(13),''；'') '+name+',' from tempdb.sys.all_columns where object_id=object_id('tempdb.dbo.#temp')
select @sql=substring(@sql,1,len(@sql)-1)
exec('select '+@sql+' from #temp')
--select * from #temp

drop table #temp


