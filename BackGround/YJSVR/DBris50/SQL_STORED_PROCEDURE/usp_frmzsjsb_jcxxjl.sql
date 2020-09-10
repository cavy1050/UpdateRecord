use DBris50
go
alter proc usp_frmzsjsb_jcxxjl
@ksrq varchar(16)='',
@jsrq varchar(16)='',   
@yydm varchar(4)='0000' 
as
/******
示例：exec usp_frmzsjsb_jcxxjl '2020010100:00:00','2020013123:59:59','01'
说明：检查详细记录(usp_frmzsjsb_jyxxjl)
作者：winning-dingsong-chongqing
时间：20200818
参数：挂号日期 between @ksrq and @jsrq  
		@yyid：医院代码
exec usp_hqms_frmzblxx_jbxx @ksrq,@jsrq,@yyid,1
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

exec [MZSVR].THIS_MZ.dbo.usp_hqms_frmzblxx_jbxx @ksrq,@jsrq,@yydm,1

insert into #fepailist
select * from [MZSVR].THIS_MZ.dbo.frmzsb_pailist(nolock)
delete [MZSVR].THIS_MZ.dbo.frmzsb_pailist

 
create table #temp  
(  
P7502 varchar(50) not null ,-- 就诊卡号  门急诊卡号  
P7506 varchar(20) not null ,-- 就诊日期  门急诊患者填写挂号日期时间。【yyyy-MM-dd HH:mm:ss】格式  
P7000 varchar(50) not null ,-- 门诊就诊流水号  同发热门诊病例信息关联  
P4 varchar(40) not null ,-- 姓名    
P7701 varchar(50)  ,-- 辅助检查机构名称    
P7702 varchar(700)  ,-- 辅助检查机构代码    
P7703 varchar(50)  ,-- 辅助检查-申请单号  可多条  
P7704 varchar(30) not null ,-- 辅助检查-报告单号  【辅助检查-报告单号】联合【辅助检查-院内检查-项目代码】唯一标识记录字段  
P7705 varchar(50)  ,-- 辅助检查-检查报告单名称    
P7706 varchar(20)  ,-- 辅助检查-检查日期  【yyyy-MM-dd HH:mm:ss】格式  
P7707 varchar(10)  ,-- 辅助检查-类别代码 【CV5199.01检验检查类别代码】   
P7708 varchar(30)  ,-- 辅助检查-项目代码    
P7709 varchar(100)  ,-- 辅助检查-类别名称    
P7710 varchar(300)  ,-- 辅助检查-项目名称    
P7711 varchar(30) not null ,-- 辅助检查-院内检查-项目代码  【辅助检查-报告单号】联合【辅助检查-院内检查-项目代码】唯一标识记录字段  
P7712 varchar(300) not null ,-- 辅助检查-院内检查-项目名称    
P7713 varchar(500) not null ,-- 辅助检查-检查部位    
P7714 varchar(2)  ,-- 辅助检查-结果是否阳性 "【RC016】1=是2=否"   
P7715 varchar(max) not null ,-- 辅助检查-检查所见    
P7716 varchar(10)  ,-- 辅助检查-检查结果异常标识 【CT01.00.006检查/检验结果异常标识】   
P7717 varchar(max) not null -- 辅助检查-检查结论    
)
insert into #temp 
select distinct
isnull(a.CARDNO,'-') P7502,
isnull(stuff(stuff(stuff(a.JZRQ,5,0,'-'),8,0,'-'),11,0,' '),'-') P7506,
isnull(a.BLH,'-') P7000,
isnull(a.HZXM,'-') P4,
@yymc P7701,
@jgdm P7702,
b.ApplyNo P7703,
isnull(b.ApplyNo,'-') P7704,
c.ItemName P7705,
convert(varchar(20),b.ExecTime,120) P7706,
'-' P7707,--f.replb P7707,
c.ItemCode P7708,
f.replbmc P7709,
c.ItemName P7710,
isnull(c.ItemCode,'-') P7711,
isnull(c.ItemName,'-') P7712,
isnull(f.jcbw,'-') P7713,
'' P7714,
isnull(f.jcsj,'-') P7715,
'' P7716,
isnull(f.jcjl,'-') P7717
from #fepailist a(nolock)
left join Ris_list b(nolock) on a.BLH=b.HospNo
left join Ris_AcceptItems c(nolock) on b.ApplyNo=c.ApplyNo
left join Ris_result d(nolock) on c.ApplyNo=d.ApplyNo
left join RIS_ItemDic e(nolock) on d.ItemCode=e.ItemCode
left join SF_YS_REPORT f(nolock) on f.xh=d.ApplyNo 

--select max(len(jcjl)) from SF_YS_REPORT
  
--替换换行符
declare @sql varchar(max)=''
select @sql=@sql+'replace(replace('+name+',char(10),''；''),char(13),''；'') '+name+',' from tempdb.sys.all_columns where object_id=object_id('tempdb.dbo.#temp')
select @sql=substring(@sql,1,len(@sql)-1)
exec('select '+@sql+' from #temp')
  
drop table #temp 

