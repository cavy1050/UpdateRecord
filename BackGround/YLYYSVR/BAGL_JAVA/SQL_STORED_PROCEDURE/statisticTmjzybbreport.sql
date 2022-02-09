alter procedure statisticTmjzybbreport
@fyydmstr varchar(100),          
 @freportdatestr varchar(100),--报表日期  
 @ftykh VARCHAR(30),  
 @dateType tinyint,    --日期类型,1为"月报"，2为"季报"，3为"年报"，4为"非正式" , 5为"院内用表"   
 @ftyyhbh varchar(30),    --统一用户编号  
 @fusername varchar(30),    --用户姓名  
 @date1 datetime,    --汇总的起始日期 '2008-01-01'  
 @date2 datetime,    --汇总的终止日期 '2008-01-01'DD  
 @calendarDay int=31,    --日历天数  
 @workDay int=31,    --工作日数  
 @week int=4,   --周数  
 @errcode tinyint out,     --错误消息  
 @errmsg varchar(200) out    --错误内容          
as            
            
/**********            
[版本号]4.0.0.0.0            
[创建时间]2003.1.17            
[作者]孙超仁            
[版权] copyright ? 1998-2001上海金仕达-卫宁医疗信息技术有限公司            
[描述]门急诊报表            
[功能说明]            
生成本院的特定时间范围内数据，对于分院数据，直接由中间表获得            
[参数说明]            
@yydm = '' 检索本院和分院（若有）汇总数据            
[返回值]            
[结果集、排序]            
[调用的usp]            
exec statisticTmjzybbreport '01','','TZYQY',5,'','','2020-11-01','2020-11-30',30,21,5,NULL,NULL            
[调用实例]            
**********/                  
     
set nocount on            
            
declare @yymc varchar(50)            
declare @yydm2 varchar(12)            
declare @sqltj varchar(20)            
declare @ts integer --天数    
declare @yydm varchar(12) ='01'          
declare @begindate varchar(8)=convert(varchar(8),@date1,112)       
declare @enddate varchar(8)=convert(varchar(8),dateadd(dd,-1,@date2),112)        
           
            
--获取医院名称                                  
--select @yymc = rtrim(name),@yydm2 = rtrim(yydm) from YY_JBCONFIG where id = ltrim(@yydm)                                  
--if @@error <> 0 or @@rowcount = 0                                  
--begin                                  
-- select 'F','查找医院名称失败!'                                  
-- return                                  
--end                                  
                                  
--计算天数                                  
select @ts = DATEDIFF(day,@begindate,@enddate) + 1                                   
if @ts <= 0                                  
begin                                  
 select 'F','开始日期，结束日期输入不正确!'                                  
 return                                  
end          
          
--if @ts >31                                  
--begin                                  
-- select 'F','开始日期至结束日期请选择在31天内!'                                 
-- return          
--end          
          
DECLARE @sqlstr varchar(5000),          
@hisrc int,          
@barc int          
          
set @sqlstr='select top 1 hismzrc,0 FROM openquery([172.20.0.40\MZ],''select         
sum(case when jlzt in (0,1) then 1 else 0 end)-sum(case when jlzt=2 then 1 else 0 end) hismzrc           
from THIS_MZ.dbo.VW_GHZDK (nolock)              
where jsbz=1 and jlzt in (0,1,2)           
and ghrq between '''''+@begindate+''''' and '''''+@enddate+''''' +''''24''''           
and (case when ksdm=''''025000'''' then ghksdm else ksdm end) in(select id from THIS_MZ.dbo.YY_KSBMK where yydm='''''+@fyydmstr+''''')'')'          
create table #temp_bd                               
(            
hisrc  int null,    --科室代码            
barc  int null    --科室名称           
)          
insert into #temp_bd(hisrc,barc)          
exec (@sqlstr)          
          
update #temp_bd set barc=(          
select sum(a.sz1+a.sz2+a.sz5+sz29)                                  
from [172.20.0.43\LIS].THIS_BAGL.dbo.BA_TJSJ_T a (nolock)            
left join [172.20.0.43\LIS].THIS_BAGL.dbo.YY_KSBMK b (nolock) on a.ksdm=b.id                   
where sjlb=3             
and tjrq between @begindate and @enddate+'24'            
--and b.yydm like @yydm            
and b.jlzt=0)          
          
--select top 1 @hisrc=hisrc,@barc=barc from #temp_bd          
--if @hisrc<>@barc          
--begin         
--select 'F','HIS门诊人次('+CONVERT(varchar(100),@hisrc)+')与病案人次('+CONVERT(varchar(100),@barc)+')存在误差，请核对'          
--return            
--end          
--创建临时表                                  
create table #temp                               
(            
ksdm  varchar(32) null,    --科室代码            
ksmc  varchar(32) null,    --科室名称            
mzrc  integer  null,   --门诊人次            
jzrc  integer   null,   --急诊人次            
zjrc integer   null,  --专家人次            
qtrc  integer   null,   --其他人次            
hj  integer  null,  --合计  
zlrc2  integer  null, --诊疗人次            
mzrc2  integer  null, --门诊人次            
jzrc2  integer  null, --急诊人次            
jkjcrc2  integer  null,  --体检人次
hlwrc2   integer  null  --互联网人次                
)                                  
            
            
--门急诊分科人次            
insert into #temp(ksdm,ksmc,mzrc,jzrc,zjrc,qtrc,hj)                                  
select a.ksdm,'',sum(a.sz1+sz29),sum(a.sz2),sum(sz5+sz30),sum(sz31),sum(a.sz1+a.sz2+a.sz5+sz29+sz30+sz31)                                  
from [172.20.0.43\LIS].THIS_BAGL.dbo.BA_TJSJ_T a (nolock)            
left join [172.20.0.43\LIS].THIS_BAGL.dbo.YY_KSBMK b (nolock) on a.ksdm=b.id                   
where sjlb=3             
and tjrq between @begindate and @enddate+'24'            
and b.yydm like @fyydmstr            
and b.jlzt=0            
group by a.ksdm                    
          
          
--取科室名称                                  
update #temp                                  
set ksmc = b.name                                  
from #temp a,[172.20.0.43\LIS].THIS_BAGL.dbo.YY_KSBMK b (nolock) where a.ksdm = b.id            

     
----急诊内科、急诊外科数据需要显示在急诊人次一栏 add by yangdi 2013.8.22            
update a set a.jzrc=a.jzrc+a.mzrc+zjrc,a.mzrc=0,zjrc=0 from #temp a                    
where a.ksdm in ('020901','020902')
--中医科急诊人次算到普通门诊 by dongchuan 20200910  
update a set a.mzrc=a.jzrc+a.mzrc,jzrc=0 from #temp a                    
where a.ksdm in ('022601')      

          
--插入总的合计            
insert #temp(ksdm,ksmc,mzrc,jzrc,zjrc,qtrc,hj)                                   
select '0','合  计',sum(mzrc),sum(jzrc),sum(zjrc),sum(qtrc),sum(mzrc+jzrc+zjrc+qtrc)                               
from #temp              
            
   
          
             
create table #temp2                               
(            
zlrc  integer  null, --诊疗人次            
mzrc  integer  null, --门诊人次            
jzrc  integer  null, --急诊人次            
jkjcrc  integer  null,  --体检人次 
hlwrc   integer  NULL,  --互联网人次      
qtrc    int      NULL    --其他人次   
)             
            
insert into #temp2             
select top 1 hj,(mzrc+zjrc),jzrc,0,0,qtrc from #temp a where ksdm='0' and ksmc ='合  计'         
      
/*  
  
select sum(sz4) sz4 from (  
 select sum(sz4) sz4            
from [172.20.0.43\LIS].THIS_BAGL.dbo.BA_TJSJ_T where sjlb=2 and kslb=0 and tjrq  between  @begindate and @enddate  and yydm  like @fyydmstr  
union all   
 select count(*) from [172.20.0.40\MZ].TJGL.dbo.EXAM_TJRYK c where   convert(varchar(16),c.TJRQ,120)  between @begindate and @enddate   and  right(c.ORGID,2)  like @fyydmstr  
  ) a   
*/  
  
--处理诊疗总情况            
update #temp2 set jkjcrc=(select sum(sz4) sz4 from (  
 select sum(sz4) sz4            
from [172.20.0.43\LIS].THIS_BAGL.dbo.BA_TJSJ_T where sjlb=2 and kslb=0 and tjrq  between  @begindate and @enddate  and yydm  like @fyydmstr  
union all   
 select count(*) from [172.20.0.40\MZ].TJGL.dbo.EXAM_TJRYK c where   convert(varchar(16),c.TJRQ,112)  between @begindate and @enddate   and  right(c.ORGID,2)  like @fyydmstr  
  ) a )            
  
 update #temp2 set hlwrc=(select count(1) from [172.20.0.40\MZ].THIS_MZ.dbo.VW_GHZDK where 
     ghrq between @begindate and @enddate+'24' and jlzt=0 and ghlb=99) 
  update #temp set zlrc2=#temp2.zlrc,mzrc2=#temp2.mzrc+#temp2.qtrc,jzrc2=#temp2.jzrc,jkjcrc2=#temp2.jkjcrc
  ,hlwrc2=#temp2.hlwrc  
   from #temp2 where ksmc ='合  计'  
   
select @yydm2 yydm,@yymc yymc,ksdm,                   
  substring(@begindate,1,4)+'-'+substring(@begindate,5,2)+'-'+substring(@begindate,7,2) FKSSJ,                             
  substring(@enddate,1,4)+'-'+substring(@enddate,5,2)+'-'+substring(@enddate,7,2) FSJSJ,                                  
  ksmc 'FKSMC',mzrc 'FMZRC',zjrc 'FZJRC',qtrc 'FQTRC',jzrc 'FJZRC', hj 'FZRC',--,zpjrc '平均人次'  
  zlrc2 'FZLRC2',mzrc2 'FMZRC2',jzrc2 'FJZRC2',jkjcrc2 'FJKJCRC2',hlwrc2 'HLWRC'                            
 from #temp a                      
 where  hj>0                             
 order by ksdm                     
--select @yydm2 yydm,@yymc yymc,                                  
--  substring(@begindate,1,4)+'-'+substring(@begindate,5,2)+'-'+substring(@begindate,7,2) ksrq,                             
--  substring(@enddate,1,4)+'-'+substring(@enddate,5,2)+'-'+substring(@enddate,7,2) jsrq, zlrc '诊疗人次',        
--  mzrc '门诊人次',jzrc as '急诊人次',jkjcrc as '健康检查人次' from #temp2            
drop table #temp            
drop table #temp2            
return   









