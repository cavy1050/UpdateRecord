use THIS_MZ
GO
alter proc usp_frmzsjsb_blxx
@ksrq ut_rq16='',
@jsrq ut_rq16='',
@yydm varchar(4)='0000' 
as
/******
示例：exec usp_frmzsjsb_blxx '2020010100:00:00','2020013123:59:59','01'
说明：发热门诊病例信息(usp_frmzsjsb_blxx)
作者：winning-dingsong-chongqing
时间：20200818
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
P900	varchar(50)	not null	,	--	医疗机构代码
P6891	varchar(80)	not null	,	--	机构名称
P686	varchar(50)	 	,	        --	医疗保险手册（卡）号
P800	varchar(50)		,	        --	健康卡号
P7501	varchar(2)	not null	,	--	就诊类型--01门诊02急诊03住院04体检05运营09其他
P7502	varchar(50)	not null	,	--	就诊卡号
P7000	varchar(50)	not null	,	--	门诊就诊流水号
P4	    varchar(40)	not null	,	--	姓名
P5   	varchar(2)	not null	,	--	性别
P6   	varchar(20)	not null	,	--	出生日期
P7   	varchar(3)	not null	,	--	年龄
P12   	varchar(40)		        ,	--	国籍
P11   	varchar(20)	not null	,	--	民族
P8	    varchar(2)	not null	,	--	婚姻状况
P9   	varchar(2)	         	,	--	职业
P7503	varchar(2)	not null	,	--	注册证件类型代码
P13   	varchar(18)	not null	,	--	注册证件号码
P801	varchar(200)  not null    ,	--	现住址
P802	varchar(40)	not null	,	--	住宅电话
P803	varchar(6)	not null	,	--	现住址邮政编码
P14  	varchar(200)		    ,	--	工作单位及地址
P15  	varchar(40)		        ,	--	工作单位电话
P16  	varchar(6)		        ,	--	工作单位邮政编码
P18  	varchar(20)	         	,	--	联系人姓名
P19 	varchar(1)		        ,	--	关系
P20  	varchar(200)		    ,	--	联系人地址
P21  	varchar(40)		        ,	--	联系人电话
P7505	varchar(4)	not null	,	--	就诊次数
P7520	varchar(2)		        ,	--	是否初诊
P7521	varchar(2)	            ,	--	是否转诊
P7504	varchar(70)	        	,	--	就诊科室代码
P7522   varchar(50)	        	,	--	就诊科室名称
P7506   varchar(20)	not null	,	--	就诊日期
P7507   varchar(2000) not null  ,	--	主诉
P7523   varchar(2000)           ,	--	现病史
P7524   varchar(2000)           ,	--	体格检查(体征)
P7525   varchar(50)             ,	--	症状代码
P7526   varchar(1000)           ,	--	症状名称
P7527   varchar(1000)           ,	--	症状描述
P7528   varchar(20)		        ,	--	发病日期
P7529   varchar(2)	not null	,	--	是否留观
P28     varchar(100)	        ,	--	门（急）诊诊断编码
P281    varchar(1000) not null	,	--	门（急）诊诊断描述
P7530   varchar(2) 	            ,	--	确诊标记
P1      varchar(2) not null	    ,	--	医疗付款方式
P7508   numeric(10,2) not null	,	--	总费用
P7509   numeric(10,2) 	        ,	--	挂号费
P7510   numeric(10,2) 	        ,	--	药品费
P7511   numeric(10,2)          	,	--	检查费
P7512   numeric(10,2)         	,	--	自付费用
)

insert into #temp
select distinct
cast(@jgdm as varchar(50)) P900,
cast(@yymc as varchar(80)) P6891,
cast('' as varchar(50)) P686,
cast('' as varchar(50)) P800,
cast(case a.GHLB when 0 then '01' when 1 then '02' else '09' end as varchar(2)) P7501,
cast(a.CARDNO as varchar(50)) P7502,
cast(a.BLH as varchar(50)) P7000,
cast(a.HZXM as varchar(40)) P4,
cast(case a.SEX when '男' then '1' when '女' then '2' else '9' end as varchar(2)) P5,
stuff(stuff(stuff(a.BIRTH,5,0,'-'),8,0,'-'),11,0,' ') P6,
cast(datediff(year,stuff(stuff(a.BIRTH,5,0,'-'),8,0,'-'),getdate()) as varchar(3)) P7,
cast(gj.name as varchar(40)) P12,
'' P11,
'' P8,
'' P9,
'01' P7503,
cast(case when isnull(b.sfzh,'')='' then '-' else b.sfzh end as varchar(18)) P13,
cast(g.jzd_sname+g.jzd_xname+g.jzd_addr as varchar(200)) as P801,--现住址    
cast(b.lxdh as varchar(40)) as P802,--联系电话    
'-' as P803,'' as P14,'' as P15,'' as P16,'' as P18,'' as P19,'' as P20,'' as P21,    
'1' as P7505,    
'' as P7520,    
'' as P7521,    
'' as P7504,    
'' as P7522,    
substring(a.JZRQ,1,4)+'-'+substring(a.JZRQ,5,2)+'-'+substring(a.JZRQ,7,2)+' '+substring(a.JZRQ,9,8) as  P7506,--就诊日期    
cast(case when isnull(c.zsnr,'')='' then '-' else c.zsnr end as varchar(2000)) as P7507,--主诉     
'' as P7523,    
'' as P7524,    
'' as P7525,    
'-' as P7526,    
'' as P7527,    
'' as P7528,    
'2' as P7529,    
cast(STUFF ((select'|'+zddm from VW_SF_YS_MZBLZDK nn(nolock) where nn.ghxh=a.GHXH for xml path('')),1,1,'') as varchar(100))  as P28,    
cast(isnull(STUFF ((select'|'+zdmc from VW_SF_YS_MZBLZDK ww(nolock) where ww.ghxh=a.GHXH for xml path('')),1,1,''),'-') as varchar(100)) as P281,    
'' as P7530,    
cast(isnull(e.ybdydm,'') as varchar(2))  as P1,--医疗支付方式    
cast(isnull(sum(f.zje),0) as numeric(10,2)) as P7508,--总费用    
cast((select sum(h.zje) From VW_MZBRJSK h(nolock) where h.ghsjh=a.JSSJH and h.ghsfbz=0 and h.ybjszt=2 and h.jlzt=0) as numeric(10,2))  as P7509,    
cast((select isnull(sum(ff.xmje),0) from VW_MZBRJSK hh(nolock),VW_MZBRJSMXK ff(nolock) where a.JSSJH=hh.ghsjh and hh.sjh=ff.jssjh and ff.fpxmmc='药品费' and hh.ybjszt=2 and hh.jlzt=0  ) as numeric(10,2)) as P7510,    
cast((select isnull(sum(kk.xmje),0) from VW_MZBRJSK gg(nolock),VW_MZBRJSMXK kk(nolock) where a.JSSJH=gg.ghsjh and gg.sjh=kk.jssjh and kk.fpxmmc like '%检查%' and gg.ybjszt=2 and gg.jlzt=0  ) as numeric(10,2)) as P7511,    
cast(case when isnull(sum(f.zfje),0)<0 then '0' else isnull(sum(f.zfje),0) end  as numeric(10,2)) as P7512                
from  #fepailist a(nolock)     
inner join  SF_BRXXK b (nolock) on a.PATID=b.patid  
left join  VW_SF_YS_MZBLK c(nolock) on a.GHXH=c.ghxh   
left join  VW_SF_YS_MZBLZDK  d(nolock) on a.GHXH=d.ghxh     
left join YY_YBDY_DYMXK e(nolock) on a.YBDM=e.hisdydm and e.dyfl='RC032'
left join YY_GJDMK gj(nolock) on b.gjbm=gj.id
left join YY_ZYDMK zy(nolock) on b.zydm=zy.id     
inner join VW_MZBRJSK f(nolock) on a.JSSJH=f.ghsjh and f.ybjszt=2 and f.jlzt=0   
inner join SF_BRXXK_FZ g(nolock) on b.patid=g.patid   
group by a.GHXH,a.BLH, a.CARDNO,a.HZXM,b.sfzh,a.BIRTH,a.SEX,a.JZRQ, a.JSSJH,e.ybdydm , c.zsnr ,a.GHLB ,     
a.GHKSDM ,c.ysdm  ,b.lxdz  ,b.lxdh,  d.zdmc   ,b.zydm  ,g.jzd_sname,g.jzd_xname,g.jzd_addr,gj.name,zy.name 

--exec usp_frmzsjsb_blxx '2020010100:00:00','2020013123:59:59','01'
--select * from YY_YBDY_DYMXK

--替换换行符
declare @sql varchar(max)=''
select @sql=@sql+'replace(replace('+name+',char(10),''；''),char(13),''；'') '+name+',' from tempdb.sys.all_columns where object_id=object_id('tempdb.dbo.#temp')
select @sql=substring(@sql,1,len(@sql)-1)
exec('select '+@sql+' from #temp')
--select * from #temp

drop table #temp







