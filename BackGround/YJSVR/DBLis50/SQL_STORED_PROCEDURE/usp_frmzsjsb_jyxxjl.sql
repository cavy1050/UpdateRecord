use DBlis50
go
alter proc usp_frmzsjsb_jyxxjl
@ksrq varchar(16)='',
@jsrq varchar(16)='',   
@yydm varchar(4)='0000' 
as
/******
示例：exec usp_frmzsjsb_jyxxjl '2020010100:00:00','2020013123:59:59','01'
说明：检验详细记录(usp_frmzsjsb_jyxxjl)
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
P7502	varchar(50)	not null	,	--	就诊卡号
P7506	varchar(50)	not null	,	--	就诊日期
P7000	varchar(50)	not null 	,	--	门诊就诊流水号
P4	    varchar(40) not null    ,	--	姓名
P7601	varchar(50)	         	,	--	检验机构代码
P7602	varchar(700)		    ,	--	检验机构名称
P7603	varchar(50)	         	,	--	检验报告单类别名称
P7604	varchar(30)	         	,	--	检验报告单类别代码
P7605   varchar(50)	        	,	--	检验申请单号
P7606   varchar(50)	        	,	--	检验申请单据名称
P7607   varchar(20)	        	,	--	检验日期
P7608   varchar(20)		        ,	--	检验报告日期
P7609   varchar(20)	            ,	--	检验送检日期
P7610	varchar(20)	            ,	--	检验采样日期
P7611   varchar(30)	         	,	--	检验标本号
P7612	varchar(30)	        	,	--	检验标本名称
P7613   varchar(30)	        	,	--	检验-项目代码
P7614	varchar(64)             ,	--	检验-项目名称
P7615	varchar(30)	not null	,	--	检验院内检验-项目代码
P7616	varchar(300)not null	,	--	检验院内检验-项目名称
P7617  	varchar(50)		        ,	--	检验方法
P7618  	varchar(20)		        ,	--	检验参考值
P7619  	varchar(200)		    ,	--	检验-计量单位
P7620  	varchar(64)	not null    ,	--	检验-结果(数值)
P7621 	varchar(2000)not null   ,	--	检验-结果(定性)
P7622  	varchar(30)	not null	,	--	检验报告单号
P7623  	varchar(30)		        ,	--	检验-项目明细代码
P7624	varchar(300)		    ,	--	检验-项目明细名称
P7625	varchar(10)	not null	,	--	检验结果异常标识
)

insert into #temp
select distinct
case when isnull(a.CARDNO,'')='' then a.BLH else a.CARDNO end P7502,
isnull(stuff(stuff(stuff(a.JZRQ,5,0,'-'),8,0,'-'),11,0,' '),'') P7506,
isnull(a.BLH,'') P7000,
isnull(a.HZXM,'') P4,
@jgdm P7601,
@yymc P7602,
'' P7603,--f.InstName P7603,
'' P7604,--f.InstCode P7604,
c.ApplyNo P7605,
c.HisOrderName P7606,
convert(varchar(20),b.ExecTime,120) P7607,
convert(varchar(20),b.ReportTime,120) P7608,
convert(varchar(20),b.ApplyTime,120) P7609,
convert(varchar(20),b.SampleTime,120) P7610,
c.Specimen P7611,
c.SpecimenDesc P7612,
c.HisOrderCode P7613,
c.HisOrderName P7614,
isnull(c.HisOrderCode,'-') P7615,
isnull(c.HisOrderName,'-') P7616,
f.InstName P7617,
cast(d.REFERENCERANGE as varchar(20)) P7618,
d.UNIT P7619,
isnull(d.ResultValue,0) P7620,
isnull(d.ResultChar,'-') P7621,
isnull(d.SerialNo,'-') P7622, 
d.ItemCode P7623,
e.ItemName P7624,
case isnull(d.HIGHLOWFLAG,'') when '' then '1' when 'H' then '21' when 'L' then '22' when 'P' then '2' else '23' end P7625
from #fepailist a(nolock)
left join Lis_list b(nolock) on a.BLH=b.HospNo
left join Lis_AcceptItems c(nolock) on b.ApplyNo=c.ApplyNo
left join Lis_result d(nolock) on c.ApplyNo=d.ApplyNo
left join lis_item e(nolock) on d.ItemCode=e.ItemCode
left join INSTRUMENT f(nolock) on d.InstID=f.InstID

--替换换行符
declare @sql varchar(max)=''
select @sql=@sql+'replace(replace('+name+',char(10),''；''),char(13),''；'') '+name+',' from tempdb.sys.all_columns where object_id=object_id('tempdb.dbo.#temp')
select @sql=substring(@sql,1,len(@sql)-1)
exec('select '+@sql+' from #temp')
--select * from #temp

drop table #temp
