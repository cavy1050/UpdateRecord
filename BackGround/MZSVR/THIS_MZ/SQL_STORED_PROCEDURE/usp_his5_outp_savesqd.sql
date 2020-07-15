ALTER proc usp_his5_outp_savesqd        
(        
@wkdz   varchar(32)   --网卡地址              
,@czzt   int    --操作状态1=创建表，2=插入申请单内容，3=插入收费信息 4＝递交 9 =作废              
,@xtlb   int=0   --类别 0= 门诊, 1=住院 3体检        
,@yzxh   ut_xh12=0   --医嘱序号            
,@sqdxh   ut_xh12=0   --申请单序号              
,@mbxh   ut_xh12=0   --模板明细序号              
,@ysdm   ut_czyh=''   --医生代码              
,@sqks   ut_ksdm=''   --申请科室              
,@zxks   ut_ksdm=''   --执行科室              
,@ywxh   ut_xh12=0   --@lb =0 挂号序号，1住院首页序号 3体检人员序号        
,@cpatid  ut_xh12=0   --门诊patid        
,@emrsqdxh  ut_xh12=0   --emr中的申请单序号。检查为负，检验为正。          
,@frmcode  int=0    --申请单表单代码              
,@dataset  ut_mc64=''        
,@fieldname  ut_mc64=''        
,@vclcaption ut_mc64=''        
,@valuedm  varchar(200)=''        
,@value   varchar(1000)=''        
,@vcltype  ut_mc64=''        
,@vclname  ut_mc64=''        
,@taborder  ut_bz=0        
--这是以前的              
-- @zhid   int          =0,   --组合代码              
-- @zhmc  varchar(200) ='',  --组合名称              
-- @memo   varchar(200) ='',  --备注           
--          
--申请单项目参数          
,@kxmdm   ut_xmdm=''   --项目代码            
,@kxmmc   ut_mc64=''   --项目名称            
,@kxmlb   int=0    --项目类别 0 收费项目 1 临床项目            
,@kxmsl   int=0    --项目数量            
--            
,@gxbz   ut_bz=0    --允许修改标志              
,@ghlb   ut_bz=-1   --挂号类别              
,@mjzsm   ut_name=''   --门急诊说明                
,@yjjzbz  ut_bz=0    --急诊标志              
,@yexh   ut_xh12=0   --婴儿序号            
,@copybz  ut_bz=0    --复制标志：0不复制1复制           
,@bzdm   ut_zddm=null  --病种代码        
,@bzmc   ut_mc32=null  --病种名称        
,@ybkz   varchar(200)=NULL --医保审批控制标志        
,@groupno  INT=-1    --组号        
,@kybz   ut_bz=0    --科研标志        
,@cfmedtype  ut_dm4=''   --处方医疗类别        
,@cfmedtypemc ut_mc32=''   --处方医疗类别名称        
,@cftszddm  ut_zddm=''   --处方特殊诊断        
,@cftszdmc  ut_mc32=''   --特病名称         
,@cfybbfz  ut_mc32=''   --并发症        
,@cfybbfzmc  ut_mc32=''   --并发症名称        
,@v5xh   ut_xh12=0   --50库申请单明细序号        
,@shbz7         ut_bz     --审核标志7         
,@sqdlb         ut_dm4=''           --申请单类别        
,@mbbz          ut_bz=0    --慢病标志        
,@zfbz          ut_bz=0    --申请单自费标志        
,@yzxrq         ut_rq8=''           --预执行日期        
,@gsbz       ut_bz=0            --工伤标志        
,@lxbz        ut_bz=0            --离休标志        
,@zfcfbz        ut_bz=0            --自费处方标志        
,@shid          varchar(max) = '' --审核id         
,@cfybzddm  ut_mc64=''   --处方医保诊断代码           
,@cfybzdmc  ut_mc256=''   --处方医保诊断名称         
,@buweimemo  ut_memo=''   --部位备注信息          
)        
as        
declare  @tablename_sqd varchar(32),              
--   @tablename_sfzh varchar(32),             
@tabname_sfmx varchar(50),        
@tabname_ybkz varchar(50),           
@sql varchar(5000),              
@pxbz ut_xh9              
        
declare  @patid ut_xh12,              
@now varchar(16),              
@sqdxh2 ut_xh12,  --申请单序号              
@url ut_mc64,              
--以下用于门诊划价处理的游标赋值              
@cxmdm ut_xmdm, --项目代码              
@cxmsl int,     --项目数量              
@clcxmdm ut_xmdm ,--临床项目代码              
@sfksdm ut_ksdm , --收费科室代码              
@bzsm ut_mc64,  --备注说明              
@xmdw ut_unit, --项目单位                
@ylsj ut_money,  --药零售价              
@dxmdm ut_kmdm,  --大项目代码              
@cfysdm ut_czyh, -- 处方医生代码        
@cv5xh ut_xh12,        
@cmxjjbz ut_bz,   --项目明细加急标志        
@cmemo  ut_mc256,  --项目明细备注        
@ypfj ut_money,  --药批发价        
@yzxrq2 ut_rq8,        
@buweimemo2 ut_memo,         
@zfcfbz2 ut_bz        
--以下定义门诊划价处理所需的变量                
declare  @djbz ut_bz,              
@djje ut_money,              
@is_prepay   int,       --是否使用预交金 0否1是              
@jzbz ut_bz,     --是否曾经扣过预交金 0否1是              
@config_1058 char(2),    --充值卡余额不够是否允许继续收费              
@yzbrk_yjye  ut_money,  --记账病人库中的押金余额              
@cfje ut_money,     --当前处方金额              
@xhtemp ut_xh12,         
@mxxhtemp ut_xh12, --cfmxk.xh add by zc 20100705 for 医保控制标志            
@hzxm  ut_mc64,              
@py    ut_py,             
@wb  ut_py,              
@ybdm   ut_ybdm,              
@config_H125 char(2),   --充值卡余额不够是否允许继录入。              
@strmsg varchar(255),    --提示信息         
@cshid varchar(max)            
--以下定义病区医嘱处理所需的变量                
declare  @bqdm ut_ksdm,              
@ksdm ut_ksdm,              
--  @xmmc ut_mc32,              
@cgyzbz ut_bz,              
@yjqrbz ut_bz,              
@djfl ut_dm4, --单据分类              
@yzdjfl ut_dm4,         
@errmsg varchar(50),               
@yzzt ut_bz,              
@yzzxbz varchar(2)               
declare  @zkpatid ut_xh12,              
@config_9022 varchar(4)        
        
select @strmsg = ''         
        
--以下为更新 url所需              
declare  @urlbz ut_bz,              
--以下为需求63251需求单修改内容           
@config_2147 varchar(4), --是否控制划价处方库明细数目        
@config_2149 int,   --最大明细数        
@hjcfxhtemp int,   --划价处方单序号        
@hjcfindex int    --划价处方明细序号        
--end add by lls        
        
if @copybz=1            
select @sqdxh=0,@yzxh=0      
    
DECLARE @config_H172 ut_bz      --增加代码    
SELECT  @config_H172 = ( SELECT CASE WHEN config = '是' THEN 1      
     ELSE 0  END   FROM   YY_CONFIG  WHERE  id = 'H172' )    
    
        
if @czzt = 9 --作废单据              
begin           
if  not exists(select 1 from  SF_MZSQD where blsqdxh =@emrsqdxh )             
begin              
select 'F', '没有申请单可作废，请先选择申请单再作废！'              
return              
end           
        
select @sqdxh =xh from SF_MZSQD where blsqdxh =@emrsqdxh           
select @now = convert(varchar(8),getdate(),112) + convert(varchar(8),getdate(),108)          
        
if @xtlb in (0,3)              
begin              
select @patid = patid from SF_MZSQD where xh = @sqdxh and jlzt = 0 ---and qrbz = 0              
if @@rowcount = 0              
begin              
select 'F','未找到相应的申请单信息,可能已经收费或确认!'              
return              
end         
if exists(select 1 from SF_HJCFK where patid = @patid and sqdxh = @sqdxh and jlzt=1)              
begin        
update SF_HJCFMXK set tfbz=1 where cfxh in (select xh from SF_HJCFK where patid = @patid and sqdxh = @sqdxh and jlzt=1)        
select 'F','该申请单已经收费,已更新退费标志!'              
return                 
end             
if exists(select 1 from SF_HJCFK where patid = @patid and sqdxh = @sqdxh and jlzt not in (0,1,2))              
begin              
select 'F','该申请单已经收费或确认，不能作废!'              
return                 
end              
select @cfje = isnull(sum(djje),0) from SF_HJCFK (nolock)         
where patid = @patid and sqdxh = @sqdxh and jlzt = 0 and djbz = 1 and jzbz = 1          
if exists(select 1 from YY_CONFIG where id='H353' and config='是')        
select @cfje=0        
--查找主卡信息              
exec usp_yy_cxjzbrzk @patid, 1, @zkpatid output              
if @zkpatid = 0 select @zkpatid = @patid        
        
begin tran          
        
if @cfje <> 0               
begin              
update SF_HJCFK set djbz = 0,jzbz = 0 where patid = @patid and sqdxh = @sqdxh and jlzt = 0 and djbz = 1 and jzbz = 1              
if @@error <> 0               
begin              
select 'F','更新记帐标志失败！'              
rollback tran              
return              
end            
        
update YY_JZBRK set djje = djje - @cfje where patid = @zkpatid               
if @@error <> 0               
begin              
select 'F','更新记帐金额失败！'            
rollback tran            
return            
end            
end            
        
update SF_HJCFK set jlzt = 2 where patid = @patid and sqdxh = @sqdxh and jlzt = 0            
if @@error <> 0            
begin            
select 'F','更新划价处方失败！'              
rollback tran            
return  
end            
        
update SF_MZSQD set jlzt = 1,zfczyh=@ysdm,zfrq = @now where xh = @sqdxh              
if @@error <> 0               
begin            
select 'F','更新申请单状态失败！'              
rollback tran              
return              
end         
    
---门诊材料费计算                
IF @config_H172 = 1       
BEGIN                               
EXEC usp_mz_ys_jyclldcl @patid = @patid, @sqks = @sqks, @zxks = @zxks, @ghxh = @ywxh, @czyh = @ysdm              
IF @@error <> 0       
BEGIN                    
SELECT  'F', '处理联动材料出错1！'                    
ROLLBACK TRAN                            
RETURN                      
END                  
END     
  
        
commit tran              
select 'T','更新成功!'             
return              
end              
else             
begin            
select @patid = syxh,@yexh=isnull(yexh,0) from ZY_BRSQD (nolock) where xh = @sqdxh and jlzt = 0 and qrbz = 0            
if @@rowcount = 0            
begin            
select 'F','未找到相应的申请单信息,可能已经收费或确认!'            
return            
end            
if exists(select 1 from BQ_LSYZK where syxh = @patid and sqdxh = @sqdxh and yzzt <> 0         
and yexh=@yexh)            
begin            
select 'F','该申请单已经审核，不能作废!'            
return               
end            
        
begin tran            
        
delete from BQ_LSYZK where syxh = @patid and sqdxh = @sqdxh and yzzt = 0 and yexh=@yexh            
if @@error<>0            
begin            
select 'F','更新医嘱信息失败！'            
rollback tran            
return              
end         
        
update ZY_BRSQD set jlzt = 1,zfczyh=@ysdm,zfrq = @now where xh = @sqdxh            
if @@error <> 0             
begin            
select 'F','更新申请单状态失败！'            
rollback tran            
return            
end          
        
update BQ_YJQQK set jlzt = 4 where sqdxh = @sqdxh and isnull(yexh,0)=@yexh            
if @@error <> 0             
begin            
select 'F','更新申请单状态失败！'            
rollback tran            
return            
end           
        
commit tran            
select 'T','更新成功!'            
return        
end        
select 'F','未跟新任何申请单'        
return                  
end              
        
select @tablename_sqd='##sqdxx'+@wkdz,                  
@tabname_sfmx = '##sqdxmzhxy'+rtrim(@wkdz)+rtrim(@ysdm),        
@tabname_ybkz = '##ybkz'+rtrim(@wkdz)+rtrim(@ysdm)               
select @url=isnull(config,'') from YY_CONFIG (nolock) where id='0104'              
declare @month int        
declare @month_str varchar(2)        
set @month=DATEPART(month,GETDATE())        
set @month_str = CONVERT(varchar,@month)        
if @month < 10        
begin        
set @month_str='0'+CONVERT(varchar,@month)        
end        
        
if @url=''        
begin        
set @url='\'+convert(varchar,DATEPART(YEAR,GETDATE()))+'\'+@month_str+'\'        
end        
else        
begin        
if SUBSTRING(@url,len(@url),1) = '\'        
set @url= rtrim(ltrim(@url)) + convert(varchar,DATEPART(YEAR,GETDATE()))+'\'+@month_str+'\'        
else        
set @url= rtrim(ltrim(@url)) + '\' + convert(varchar,DATEPART(YEAR,GETDATE()))+'\'+@month_str+'\'        
end             
if @czzt=1              
begin         
exec('if exists(select * from tempdb..sysobjects where name='''+@tablename_sqd+''')        
drop table '+@tablename_sqd)         
        
exec('create table '+@tablename_sqd+'(              
zyxh  ut_xh9   not null, --值域序号(=TJ_XMZYK.xh)                 
caption  ut_mc32   null,  --显示名称              
valuedm  varchar(200) null,  --值域内容代码              
value       varchar(1000) null,  --值域内容              
zlx   ut_bz   not null,         
--值的类型: 0字符串,1整数,2浮点数,3从项目字典中单选,4从项目字典中多选              
taborder int    null  --打印顺序              
)')              
if @@error<>0              
begin              
select 'F','创建全局临时表时出错1！'              
return            
end                  
        
--创建全局临时表         
exec('if exists(select 1 from tempdb..sysobjects where name ='''+@tabname_sfmx+''')             
drop table '+@tabname_sfmx)            
exec('create table '+@tabname_sfmx+' (           
xmdm ut_xmdm  not null, --项目代码              
xmmc ut_mc64  not null, --项目名称              
xmlb int   not null, --项目类别 0 收费项目 1 临床项目              
xmsl int   not null, --项目数量              
sjxmdm  ut_xmdm  not null, --上级项目代码              
bzsm ut_mc64  null,  --备注说明              
sqdgroupno int         null, --组号        
v5xh ut_xh12  null,  --50库申请单明细序号         
mxjjbz  ut_bz       null,      --明细加急标志  SF_HJCFMXK.ybjzbz        
memo    ut_mc256    null,       --明细备注      SF_HJCFMXK.memo        
yzxrq   ut_rq8      null,        --预执行日期        
zfcfbz  ut_bz       null,        
shid    varchar(max)    null,    --审核id        
buweimemo ut_memo null           --部位备注        
)')            
if @@error<>0            
begin            
select 'F','创建全局临时表时出错3！'            
return            
end            
        
--创建全局临时表--医保审批控制临时表            
exec('if exists(select 1 from tempdb..sysobjects where name ='''+@tabname_ybkz+''')             
drop table '+@tabname_ybkz)            
exec('create table '+@tabname_ybkz+' (           
sfid ut_xmdm null, --项目代码        
xmmc ut_mc64 null, --项目名称        
ybkzbz ut_bz null --医保控制标志             
)')            
if @@error<>0            
begin            
select 'F','创建全局临时表时出错4！'            
return            
end           
        
--申请单自定义收费处理          
declare @result1 varchar(8),@msg1 ut_mc256          
exec usp_his5_outp_savesqdcharge @wkdz=@wkdz,@jszt=1,@result=@result1 output,@msg=@msg1 output          
if @result1='F'          
begin          
select @result1,@msg1          
return          
end         
        
select 'T'              
return          
end            
        
if @czzt=2              
begin                
select @sql ='insert into '+@tablename_sqd+' values('              
+convert(varchar(14),@taborder)              
+ ',''' + isnull(@vclcaption,'') + ''''              
+ ',''' + isnull(@valuedm,'') + ''''              
+ ',''' + isnull(@value,'') + ''''              
+ ',' + convert(varchar(14),0)  --值类型目前都传0              
+ ',' + convert(varchar(14),isnull(@taborder,999))              
+')'            
exec(@sql)              
if @@error<>0              
begin              
select 'F','插入全局临时表时出错1！'              
return              
end              
select 'T'            
return              
end            
        
if @czzt=3              
begin               
if @kxmlb=0          
begin          
if not exists(select 1 from  YY_SFXXMK (nolock) where id =@kxmdm )           
begin          
select 'F', 'HIS中没有【'+@kxmdm+'】小项目项目!'               
return            
end           
end          
else          
begin          
if not exists( select 1 from  YY_LCSFXMK (nolock) where id =@kxmdm )           
begin          
select 'F', 'HIS中没有【'+@kxmdm+'】临床项目!'               
return            
end           
end        
        
--项目停用判断 --add by lls for 75027        
if @kxmlb=0          
begin          
if not exists(select 1 from  YY_SFXXMK (nolock) where id =@kxmdm and sybz = 1 and mzbz = 1)           
begin          
select 'F', 'HIS中【'+@kxmdm+'】小项目项目已经停用!'               
return            
end           
end          
else          
begin          
if not exists( select 1 from  YY_LCSFXMK (nolock) where id =@kxmdm and jlzt = 0)           
begin          
select 'F', 'HIS中没有【'+@kxmdm+'】临床项目已经停用!'               
return            
end           
end        
        
--医保控制处理        
if @kxmlb = 0        
begin        
select @sql ='insert into '+@tabname_ybkz+' select id,name,case ybkzbz when 0 then 0 else 2 end  from YY_SFXXMK (nolock) where id ='''+@kxmdm+''''          
end         
else     
begin       
select @sql ='insert into '+@tabname_ybkz+' select a.id,a.name,case a.ybkzbz when 0 then 0 else 2 end          
from YY_SFXXMK a (nolock),YY_LCSFXMK b (nolock),YY_LCSFXMDYK c (nolock)        
where b.id ='''+@kxmdm+''' and b.id=c.lcxmdm and c.xmdm=a.id'          
end          
exec(@sql)        
if @@error<>0              
begin              
select 'F','插入全局医保控制临时表时出错！'              
return              
end            
--根据医技传入更新ybkzbz          
if (isnull(@ybkz,'') <>'')        
begin        
select @sql='update '+@tabname_ybkz+' set ybkzbz=1 where sfid in ('+@ybkz+')'        
exec(@sql)          
if @@error<>0              
begin              
select 'F','更新全局医保控制临时表时出错！'              
return              
end         
end          
--处理明细           
select @sql ='insert into '+@tabname_sfmx+' values('              
+''''+convert(varchar(16),@kxmdm)+''''           --add by yangdi 2020.7.15 项目代码截断  
+ ',''' + convert(varchar(64),@kxmmc)+''''             
+ ',' + convert(varchar,@kxmlb)          
+ ',' + convert(varchar,@kxmsl)            
+ ',' + convert(varchar(14),0) --值类型目前都传0              
+','''+convert(varchar(256),@value)+''''          
+','+convert(varchar(2),@groupno)        
+','+convert(varchar(12),@v5xh)        
+','+convert(varchar,@yjjzbz)         
+','''+convert(varchar(256),@value)+''''  --项目明细的备注借用@value字段        
+','''+convert(varchar(256),@yzxrq)+''''         
+','+convert(varchar,@zfcfbz)         
+',''' + CONVERT(VARCHAR(256), @shid) + ''''         
+',''' + convert(varchar(24),@buweimemo) + ''''        
+')'              
exec(@sql)              
if @@error<>0              
begin              
select 'F','插入全局临时表时出错3！'              
return              
end              
select 'T'            
return                  
end                
if @czzt=4              
begin                 
--查找对应的医生              
declare  @yjbbzl varchar(32),        
@maxzyxh int,        
@yjlb ut_xmdm,              
@dyyzlb ut_bz,              
@sjxmdm ut_xmdm,              
@xmmc ut_mc32,        
@fylb ut_mc32, --费用类别，-add by lls for88846        
@tmpsqdgroupno INT,        
@c_idm  ut_xh9,        
@c_ypyf  ut_dm2,        
@c_pcdm  ut_dm2,        
@c_ypjl  ut_sl14_3,        
@c_jldw  ut_unit,        
@c_dwlb  ut_bz,        
@c_ts  smallint,        
@c_ypsl  ut_sl10,        
@c_cfts  smallint,        
@c_mxlb  ut_xmdm,        
@yhdj  ut_money,        
@config9052 ut_mc32        
        
select @cfysdm = SQYSDM from CISDB..OUTP_CFQSQK with  (nolock) where YSDM = @ysdm  --查找授权医生        
if rtrim(isnull(@cfysdm, '')) = ''         
select @cfysdm = zgbm from czryk (nolock) where id = @ysdm         
if rtrim(isnull(@cfysdm, '')) = ''               
select @cfysdm = @ysdm                  
select @now = convert(varchar(8),getdate(),112) + convert(varchar(8),getdate(),108),@zxks = ltrim(rtrim(@zxks))           
select @mbxh=@frmcode              
if(@sqdlb='2')        
begin        
select @yjlb=id,@dyyzlb=dyyzlb from YJ_SQDYJFLK (nolock) where jchybz=0  and name ='ris'        
end        
else if(@sqdlb='1')        
begin        
select @yjlb=id,@dyyzlb=dyyzlb from YJ_SQDYJFLK (nolock) where jchybz=0  and name ='lis'        
end         
select @config9052=isnull(config,'否') from YY_CONFIG(nolock) where id='9052'        
select @config9052=isnull(@config9052,'否')        
if @config9052<>'是'        
select @kybz=0        
        
--校验界面值域信息填写情况            
exec usp_yj_sqdcheck @tablename_sqd,@xtlb,@frmcode,@errmsg output            
if @errmsg like 'F%'            
begin            
select 'F',substring(@errmsg,2,49)            
return            
end         
        
--4.1将全局临时表的内容复制到临时表里            
create table #sqdxx            
(              
zyxh  ut_xh9   not null, --值域序号(=TJ_XMZYK.xh)                 
caption  ut_mc32   null,  --显示名称              
valuedm  varchar(200) null,  --值域内容代码              
value       varchar(1000) null,  --值域内容              
zlx   ut_bz   not null,         
--值的类型: 0字符串,1整数,2浮点数,3从项目字典中单选,4从项目字典中多选              
taborder int    null,  --打印顺序              
memo  ut_memo   null            
)               
exec('insert into #sqdxx select *,'''' from '+@tablename_sqd)              
if @@error<>0              
begin              
select 'F','插入临时表时出错1！'             
return               
end               
exec('drop table '+@tablename_sqd)              
        
select @zxks=rtrim(value) from #sqdxx (nolock) where caption='执行科室代码'         
        
/*        
if exists(select 1  from #sqdxx (nolock) where caption='执行科室代码' and  rtrim(value) <> '')              
begin              
select @zxks=rtrim(value) from #sqdxx (nolock) where caption='执行科室代码'              
end              
else              
begin              
select 'F','请选择执行科室！'              
return               
end           
*/           
        
--更新值域“申请单序号”的内容            
if exists(select 1 from #sqdxx (nolock) where caption='申请单序号' and @sqdxh>0)            
begin            
update #sqdxx set value=convert(varchar,@sqdxh) where caption='申请单序号'            
if @@error<>0            
begin            
select 'F','更新申请单序号失败！'            
return            
end            
end            
        
select @maxzyxh= max(zyxh)+1 from #sqdxx (nolock)           
        
--处理明细            
create table #sfxm            
(              
xmdm ut_xmdm  not null, --项目代码              
xmmc ut_mc64  not null, --项目名称              
xmlb int   not null, --项目类别 0 收费项目 1 临床项目              
xmsl int   not null, --项目数量              
sjxmdm  ut_xmdm  not null, --上级项目代码              
bzsm ut_mc64  null,  --备注说明              
sqdgroupno INT         NULL,        --组号            
tsbz ut_bz  null,        
v5xh ut_xh12  null,  --50库申请单明细序号        
mxjjbz  ut_bz       null,  --明细急诊标志 SF_HJCFMXK.ybjzbz         
memo    ut_mc256    null,       --明细备注      SF_HJCFMXK.memo          
yzxrq   ut_rq8      null,        
zfcfbz  ut_bz       null,        
shid    varchar(max) null,      --  审核id                  
buweimemo ut_memo    null       --部位备注信息        
)                                         
--exec('select distinct * from '+@tabname_sfmx)          
--select ('insert into #sfxm select distinct *,'''' from '+@tabname_sfmx)          
--exec('insert into #sfxm select distinct *,'''' from '+@tabname_sfmx)          
exec('insert into #sfxm select xmdm,xmmc,xmlb,xmsl,sjxmdm,bzsm,sqdgroupno,null tsbz,v5xh,mxjjbz,memo,yzxrq,zfcfbz,shid,buweimemo from '+@tabname_sfmx)            
if @@error<>0              
begin              
select 'F','插入临时表时出错3！'              
return               
end               
exec('drop table '+@tabname_sfmx)        
        
--处理医保控制标准         
create table #ybkzsfxm           
(              
xmdm ut_xmdm  not null, --项目代码              
xmmc ut_mc64  not null, --项目名称        
ybkzbz ut_bz null --医保控制标志                   
)            
exec('insert into #ybkzsfxm select * from '+@tabname_ybkz)              
if @@error<>0              
begin              
select 'F','插入临时表时出错3！'              
return               
end               
exec('drop table '+@tabname_ybkz)               
        
create table #outp_brsqddysfk            
(            
xmdm ut_xmdm  not null, --项目代码             
xmlb int   not null, --项目类别 0 收费项目 1 临床项目            
v5xh ut_xh12  null,  --50库申请单明细序号              
xmdj  ut_money null,  --项目单价               
)            
insert into #outp_brsqddysfk select XMDM,XMLB,SQMXXH,XMDJ from CISDB..OUTP_BRSQDDYSFK            
where SQMXXH <>0 and SQMXXH in (select abs(v5xh) from #sfxm)          
if @@error<>0                      
begin                      
select 'F','插入临时表#outp_brsqddysfk时出错！'                      
return                       
end            
        
        
/******************保存申请单的生育医保信息  zhangwei************************/      
declare        
@xzlb ut_bz,    --险种类别        
@bfzbz ut_bz,    --并发症标志        
@syyllb ut_dm5,    --生育医疗类别        
@sylbdm ut_dm5,    --生育类别代码        
@sylbmc ut_mc64,   --生育类别名称        
@sybzdm varchar(20),  --生育诊断代码        
@sybzmc  ut_mc64,   --生育诊断名称          
@bfz  varchar(10),  --并发症        
@zzrslx varchar(50),  --终止妊娠类型        
@sysj ut_rq16,   --生育时间点        
@ycbjyjcxmdm varchar(20), --遗传基因检查项目代码        
@ycbjyjcxmmc varchar(100), --遗传基因检查项目名称        
@syfwzh varchar(20),  --生育服务证号        
@jhzh varchar(20)   --结婚证号        
        
select         
@xzlb=cast(ta.XZLB as smallint),        
@bfzbz=cast(ta.BFZBZ as smallint),        
@syyllb=cast(ta.SYYLLB as varchar(5)),        
@sylbdm=cast(ta.SYLBDM as varchar(5)),        
@sylbmc=cast(ta.SYLBMC as varchar(64)),        
@sybzdm=cast(ta.SYZDDM as varchar(20)),        
@sybzmc=cast(ta.SYZDMC as varchar(64)),        
@bfz=cast(ta.BFZ as varchar(10)),        
@zzrslx=cast(ta.ZZRSLX as varchar(50)),        
@sysj=ta.SYSJ,        
@ycbjyjcxmdm=cast(ta.YCBJYJCXMDM as varchar(20)),        
@ycbjyjcxmmc=cast(ta.YCBJYJCXMMC as varchar(100)),        
@syfwzh=cast(ta.SYFWZH as varchar(100)),        
@jhzh=cast(ta.JHZH as varchar(20))        
from CISDB..OUTP_BRSQDK ta inner join CISDB..OUTP_BRSQDMXK tb on ta.XH=tb.SQXH        
inner join #outp_brsqddysfk tc on tb.XH=tc.v5xh           
/*******************保存申请单的生育医保信息************************/        
        
        
--开始处理              
begin tran              
        
--4.2开始生成申请单              
--4.2.1 生成门诊医技申请单              
if @xtlb in(0,3)              
begin           
--往门诊申请单主表插入信息           
if  not exists(select 1 from  SF_MZSQD (nolock) where blsqdxh =@emrsqdxh )             
begin           
if @ywxh<>0          
begin          
select @patid = patid from GH_GHZDK (nolock) where xh = @ywxh           
if @@rowcount = 0              
begin              
select 'F','未找到有效的挂号账单,请核实!'        
rollback tran              
return              
end           
end          
else          
begin          
select  @patid=@cpatid          
end           
        
insert into SF_MZSQD (patid,ghxh,mbxh,lrrq,czyh,sqks,zxks,lb, ghlb, mjzsm,hjcfbz,yjlb,jzbz ,blsqdxh,kybz)              
values(@patid,@ywxh,@mbxh,@now,@ysdm,@sqks,@zxks,case @xtlb when 0 then 0 else 3 end, @ghlb, @mjzsm,0,@yjlb,@yjjzbz,@emrsqdxh,@kybz)              
if @@error<>0              
begin              
select 'F','往SF_MZSQD插入数据时出错！'             
rollback tran              
return               
end        
        
select @sqdxh = @@identity              
        
--update YJ_YS_SQDZHMXK set sqdxh=@sqdxh,sqdid=@frmcode where sqdxh=-9999 and ghxh=@ywxh               
select @urlbz = 1              
select @url =@url + 'MZ'+convert(varchar(12),@emrsqdxh)+'.html'              
end              
else             
begin             
select  @sqdxh =xh from  SF_MZSQD (nolock) where blsqdxh =@emrsqdxh            
select @urlbz= 0              
        
select @patid = patid from SF_MZSQD (nolock) where xh = @sqdxh and jlzt = 0 and qrbz = 0              
if @@rowcount = 0              
begin              
select 'F','未找到有效的申请单信息,可能已确认或作废!'              
rollback tran              
return              
end                 
update SF_MZSQD set zxks=@zxks,jzbz = @yjjzbz,kybz=@kybz where xh = @sqdxh              
end              
        
--   *****这个表暂时不知道有什么意义！！          
--  delete YJ_YS_SQDZHMXK where sqdxh=@sqdxh and ghxh=@ywxh and sqdid=@frmcode            
--  insert into YJ_YS_SQDZHMXK(ghxh,sqdxh,zhid,zhmc,memo,sqdid,sl)              
--  select @ywxh,@sqdxh,zhid,zhmc,memo,@frmcode,1 from #sfzh              
        
--保留原来的修改记录内容              
select * into #tmpmzmxk from SF_MZSQDMXK (nolock) where sqdxh =@sqdxh              
--删除原来的申请单内容              
delete SF_MZSQDMXK where sqdxh =@sqdxh              
if @@error<>0              
begin              
select 'F','删除SF_MZSQDMXK时出错！'            
rollback tran              
return               
end            
        
--更新值域“申请单序号”的内容            
if exists(select 1 from #sqdxx (nolock) where caption='申请单序号' and @sqdxh>0)            
begin            
update #sqdxx set value=convert(varchar,@sqdxh) where caption='申请单序号'            
if @@error<>0            
begin            
select 'F','更新申请单序号失败！'            
return            
end            
end            
        
--插入申请单明细内容            
insert into SF_MZSQDMXK(sqdxh,zyxh,caption,valuedm,value,zlx,sjxh,taborder,dykz,lrczyh,lrrq,memo,kybz)              
select @sqdxh,zyxh,caption,valuedm,value,zlx,0,taborder,0, @ysdm, @now,memo,@kybz from #sqdxx              
if @@error<>0              
begin              
select 'F','插入SF_MZSQDMXK时出错！'              
rollback tran              
return               
end            
        
--获取费用类别，-add by lls for88846        
select @fylb=isnull(valuedm,'') from #sqdxx(nolock) where caption='费别'        
select @fylb=isnull(@fylb,'')        
        
--更新上级序号            
select a.xh,b.xh sjxh               
into #sjxh_mz              
from SF_MZSQDMXK a (nolock),SF_MZSQDMXK b (nolock)              
where a.sqdxh = @sqdxh and b.sqdxh = @sqdxh and a.sjxh >0 and a.sjxh = b.zyxh              
        
update SF_MZSQDMXK  set sjxh = b.sjxh from SF_MZSQDMXK a (nolock),#sjxh_mz b where a.xh = b.xh            
if @@error<>0              
begin              
select 'F','更新SF_MZSQDMXK时出错！'              
rollback tran              
return     
end            
        
--更新操作记录              
update SF_MZSQDMXK set lrczyh = b.lrczyh,lrrq = b.lrrq from SF_MZSQDMXK a (nolock),#tmpmzmxk b (nolock)              
where a.sqdxh = @sqdxh and a.zyxh = b.zyxh and isnull(b.lrczyh,'') <> ''              
        
--更新url路径              
if @urlbz = 1              
begin             
update SF_MZSQD set sqdurl = @url where xh = @sqdxh              
if @@error<>0              
begin              
select 'F','更新SF_MZSQD url路径时出错！'              
rollback tran              
return               
end              
end            
        
--begin add by lls for 84670 保存申请条形码、申请单名称至申请单主表        
update SF_MZSQD         
set sqdmc=(select top 1 value from #sqdxx(nolock) where caption='申请单名称')        
,txm=(select top 1 value from #sqdxx(nolock) where caption='条形码')        
where xh = @sqdxh              
if @@error<>0              
begin              
select 'F','更新SF_MZSQD申请单名称、条形码时出错！'              
rollback tran              
return               
end          
--end add by lls for 84670        
        
select @config_9022=isnull(config,'否') from YY_CONFIG where id='9022'              
        
--判断是否已确费              
if exists(select 1 from SF_HJCFK (nolock) where patid = @patid  and sqdxh = @sqdxh and jlzt = 1)              
begin              
select @strmsg='申请单的处方信息已确费'              
select @xtlb = -1              
end              
end     --完成生成门诊医技申请单            
        
--4.3 开始处理收费项目              
if @xtlb = 0  --4.3.1 处理门诊收费项目              
begin              
if (@gxbz=0)               
begin              
select @hzxm=hzxm, @py=py, @wb=wb from SF_BRXXK (nolock) where patid=@patid           
        
--查找主卡信息              
exec usp_yy_cxjzbrzk @patid, 1, @zkpatid output              
if @zkpatid = 0         
select @zkpatid = @patid         
        
if (@sqdxh <> 0)               
begin              
select xh, djje, djbz, jzbz into #temphjcfk from SF_HJCFK (nolock) where patid = @patid and sqdxh = @sqdxh and jlzt = 0              
        
select @cfje = isnull(sum(djje), 0) from #temphjcfk (nolock) where djbz = 1 and jzbz = 1         
if exists(select 1 from YY_CONFIG where id='H353' and config='是')        
select @cfje=0             
--将以前的冻结金额恢复              
update YY_JZBRK set djje = djje - isnull(@cfje,0) where patid = @zkpatid               
if @@error <> 0               
begin              
select 'F','更新记帐金额失败！'        
rollback tran              
return              
end              
        
delete SF_HJCFMXK  from #temphjcfk b (nolock) where cfxh=b.xh              
if @@error<>0              
begin              
select 'F','更新SF_HJCFMXK失败！'              
rollback tran              
return               
end                      
        
delete SF_HJCFK from SF_HJCFK a,#temphjcfk b (nolock) where a.xh=b.xh              
if @@error<>0              
begin              
select 'F','更新SF_HJCFK失败！'              
rollback tran              
return               
end              
--再次判断              
if exists(select 1 from SF_HJCFK (nolock) where patid = @patid  and sqdxh = @sqdxh and jlzt = 0)              
begin              
select 'F','已经存在该申请单的处方信息，请先核对！'              
rollback tran              
return               
end              
end            
        
select @config_H125 = config from YY_CONFIG (nolock) where id = 'H125'        
        
--add by lls        
--添加是否对划价处方明细数目进行控制的判断          
select @config_2147 = config from YY_CONFIG (nolock) where id = '2147'   --判断是否控制条数        
select @config_2149 = isnull(config,0) from YY_CONFIG (nolock) where id = '2149'   --单页打印最大条数        
set @hjcfxhtemp = ''   --划价单序号        
set @hjcfindex = 1     --划价单明细号        
--end add by lls        
        
--游标数据临时表               
create table #cs_sfxm(              
xmdm  ut_xmdm  not null, --项目代码                
xmxl  int   null,  --项目数量               
sfksdm  ut_ksdm  null,  --收费科室代码              
xmdw  ut_unit  null,  --项目单位              
lcxmdm  ut_xmdm  null,  --临床项目代码            
xmdj  ut_money null,  --项目单价        
dxmdm  ut_kmdm  null,  --大项目代码        
sjxmdm  ut_xmdm  null,  --上级项目代码          
bzsm  ut_mc64  null,  --备注说明        
name  ut_mc64  NULL,  --项目名称        
sqdgroupno  INT         NULL,       --组号        
idm   ut_xh9  null,        
ypyf  ut_dm2  null,        
pcdm  ut_dm2      null,        
ypjl  ut_sl14_3 null,        
jldw  ut_unit  null,        
dwlb  ut_bz  null,        
ts   smallint null,        
ypsl  ut_sl10  null,        
cfts  smallint null,        
mxlb  ut_xmdm  null,        
v5xh  ut_xh12  null,        
mxjjbz      ut_bz       null,        
memo        ut_mc256    null,        
ypfj   ut_money null,  --批发价        
yzxrq  ut_rq8 null,        
zfcfbz  ut_bz null,        
shid varchar(max) null,        
buweimemo ut_memo null         
)              
if @@error<>0              
begin              
select 'F','创建全局临时表时出错1！'         
rollback tran             
return              
end         
        
insert into #cs_sfxm        
select a.xmdm, a.xmsl, (case when @zxks = '' then isnull(b.zxks_id,'') else @zxks end) sfksdm, isnull(b.xmdw,''), '0'as lcxmdm,        
b.xmdj, b.dxmdm,a.sjxmdm,a.bzsm ,(case when rtrim(a.xmmc)<>'' then a.xmmc else b.name end) name ,a.sqdgroupno          
,0,'', '', 0, '' , 0,1,  @cxmsl, 1,0,v5xh,a.mxjjbz,a.memo ,b.xmdj,a.yzxrq,a.zfcfbz,a.shid,a.buweimemo           
from #sfxm a (nolock), YY_SFXXMK b (nolock)              
where a.xmlb = 0 and a.xmdm = b.id               
union all            
select c.zxmdm,a.xmsl, (case when @zxks = '' then isnull(b.zxks_id,'') else @zxks end) sfksdm, isnull(b.xmdw,''), c.id as lcxmdm,        
c.xmdj, b.dxmdm,a.sjxmdm,a.bzsm,c.name,a.sqdgroupno             
,0,'', '', 0, '' , 0,1,  @cxmsl, 1 ,1,v5xh ,a.mxjjbz,a.memo ,c.xmdj,a.yzxrq,a.zfcfbz,a.shid,a.buweimemo                
from #sfxm a (nolock), YY_SFXXMK b (nolock), YY_LCSFXMK c (nolock)            
where a.xmlb = 1 and a.xmdm = c.id and c.zxmdm = b.id         
union all      
select b.ypdm,b.ypsl, (case when @zxks = '' then isnull(b.zxks,'') else @zxks end) sfksdm, b.jldw, b.lcxmdm lcxmdm,        
0, '',a.sjxmdm,a.bzsm,b.ypmc,a.sqdgroupno             
,b.idm,b.ypyf,b.pcdm,b.ypjl,b.jldw ,b.dwlb,b.ts,  @cxmsl*b.ypsl, b.cfts,2,v5xh,a.mxjjbz ,a.memo,0,a.yzxrq,a.zfcfbz,a.shid,a.buweimemo            
from #sfxm a (nolock), SF_YS_MZXDFMX b (nolock)          
where a.xmlb = 2 and a.xmdm = b.cfxh        
        
update a set a.xmdj=b.xmdj from #cs_sfxm a,#outp_brsqddysfk b where abs(a.v5xh)=b.v5xh  and a.mxlb=b.xmlb and ((b.xmlb=0 and a.xmdm=b.xmdm) or (b.xmlb=1 and a.lcxmdm=b.xmdm))            
        
--新增划价处方               
declare cs_sfxmcl cursor for                
select * from #cs_sfxm (nolock)        
order by  sfksdm   --对收费科室进行排序  --add by lls           
for read only                 
open cs_sfxmcl                 
fetch cs_sfxmcl into @cxmdm ,@cxmsl, @sfksdm, @xmdw, @clcxmdm ,@ylsj, @dxmdm,@sjxmdm,@bzsm,@xmmc ,@tmpsqdgroupno         
,@c_idm,@c_ypyf,@c_pcdm,@c_ypjl,@c_jldw,@c_dwlb,@c_ts,@c_ypsl,@c_cfts,@c_mxlb,@cv5xh,@cmxjjbz ,@cmemo,@ypfj,@yzxrq2,@zfcfbz2,@cshid,@buweimemo2        
while @@fetch_status=0                    
begin              
if @c_mxlb=2 and @c_idm>0        
begin        
select @cfje = @c_ypsl*ylsj*@c_cfts/ykxs from YK_YPCDMLK(nolock) where idm=@c_idm        
end        
else if @c_mxlb=2 and @c_idm=0 and @ylsj=0        
begin        
select @cfje = xmdj from YY_SFXXMK(nolock) where id=@cxmdm        
end        
else        
begin        
select @cfje = @ylsj        
end        
        
select @djje = 0 , @djbz = 0              
select @config_1058 = config from YY_CONFIG where id = '1058'              
select @is_prepay = 0               
        
--开始处理冲值卡部分begin              
select @yzbrk_yjye = yjye-djje           
from YY_JZBRK (nolock) where patid = @zkpatid and jlzt = 0           
        
--     select @yzbrk_yjye          
--     select * from YY_JZBRK where patid = @zkpatid            
        
if @yzbrk_yjye is not null               
begin              
select @is_prepay = 1            
if exists(select 1 from YY_CONFIG where id='H353' and config <> '是')        
select @djje=@cfje , @djbz=1         
ELSE        
SELECT @djje=0,@djbz=0            
        
if @yzbrk_yjye - @cfje < 0              
begin              
--if isnull(@config_1058,'') <> '是' --充值卡余额不够是否允许继续收费              
if isnull(@config_H125,'') = '2'              
begin --不能开              
rollback tran              
deallocate cs_sfxmcl                  
select 'F', '不允许录入,金额总数超过预交金￥' + convert(varchar(24), @cfje - @yzbrk_yjye)              
return                
end              
else if rtrim(@strmsg) = '' and isnull(@config_H125,'') = '1'              
select @strmsg = '余额不足,超过预交金￥' + convert(varchar, @cfje-@yzbrk_yjye)              
end              
end              
        
--处理科研项目优惠单价        
if @kybz=1 and @c_idm=0 and @config9052='是'        
begin        
if isnull(@clcxmdm,'0')='0'        
begin        
if exists(select 1 from YY_SFXXMK(nolock) where id=@cxmdm and iskybz=1)        
select @yhdj=@ylsj        
end        
else        
begin             
if (not exists(select 1 from YY_LCSFXMK a(nolock),YY_LCSFXMDYK b(nolock),YY_SFXXMK c(nolock)         
where a.id=@clcxmdm and a.id=b.lcxmdm and b.xmdm=c.id and a.jlzt=0 and isnull(c.iskybz,0)=0))        
select @yhdj=@ylsj             
end             
end            
        
--如果使用预交金，修改押金余额              
select @jzbz = 0              
if @is_prepay = 1              
begin              
/*if isnull(@config_1058,'') <> '是' --充值卡余额不够不允许继续收费              
begin              
update YY_JZBRK               
set djje = djje + @cfje               
where patid = @zkpatid               
end              
else*/           
        
update YY_JZBRK               
set djje = djje + @djje               
where patid = @zkpatid            
if @@rowcount=0 or @@error<>0              
begin              
select 'F','更新预交金数据出错'              
rollback tran              
deallocate cs_sfxmcl                  
return              
end          
        
        
select @jzbz = 1              
end        
        
declare @tsbrshbz ut_bz        
if @mbbz+@gsbz+@lxbz>0        
set @tsbrshbz=1        
else        
set @tsbrshbz=0        
--开始处理冲值卡部分end              
-- add by jeffrey 2007.3.12 split recipe by section office              
--保存划价库            
if @config_9022='否'              
begin          
      
      
 if (@cfmedtype='' or @cfmedtype is null)   --新增代码  by xieni       
    select @cftszddm='',@cftszdmc=''       
      
        
insert into SF_HJCFK( czyh, lrrq, patid, hzxm, py, wb,               
ysdm,  ksdm,  yfdm,  sfksdm, qrczyh, qrrq,   cfts, jlzt,  cflx, sycfbz,   tscfbz,  ghxh, memo,              
shbz1,  shbz2,  shbz3,  zfcfbz,  jzbz,shbz7              
,djje,djbz,ybshbz,sqdxh,sqdid,bzdm,bzmc,fylb ,medtype,medtypemc,cftszddm,cftszdmc,ybbfz,ybbfzmc,sqdlb ,zjbz,ismxb, --add fylb by lls for88846        
xzlb,bfzbz,syyllb,sylbdm,sylbmc,sybzdm,sybzmc,bfz,zzrslx,sysj,ycbjyjcxmdm,ycbjyjcxmmc,syfwzh,jhzh,sqdzfbz,tsbrshbz,cfybzddm,cfybzdmc) --add zhangwei 需求 87078 重庆开县人民医院生育医保申请单            
values(  @ysdm, @now, @patid, @hzxm,  @py, @wb,              
@cfysdm, @sqks , @sfksdm, @sfksdm,   null, null,  1,    0, 5 , 0, 0, @ywxh, @vclcaption,              
0, 0, 0, 0, @jzbz,@shbz7              
,@djje,@djbz,0,@sqdxh,@frmcode,@bzdm,@bzmc,@fylb,@cfmedtype,@cfmedtypemc,@cftszddm,@cftszdmc,@cfybbfz,@cfybbfzmc,@sqdlb,2,@mbbz,        
@xzlb,@bfzbz,@syyllb,@sylbdm,@sylbmc,@sybzdm,@sybzmc,@bfz,@zzrslx,@sysj,@ycbjyjcxmdm,@ycbjyjcxmmc,@syfwzh,@jhzh,@zfbz,@tsbrshbz,@cfybzddm,@cfybzdmc)                  
if @@error<>0 or @@rowcount=0              
begin              
select 'F','保存划价处方出错！'              
rollback tran              
deallocate cs_sfxmcl                  
return              
end              
        
select @xhtemp=@@identity              
        
insert into SF_HJCFMXK(cfxh, cd_idm, gg_idm, dxmdm, ypdm,ypmc,               
ypdw,  ypxs,  ykxs,  ypfj, ylsj,               
ypyf, pcdm, ypjl, jldw, dwlb,              
ts,  ypsl,  cfts,  memo,   zbz,    mzdm,shbz,lcxmdm,sqdsjxm,sqdxmbz,sqdgroupno,yhdj,v5xh,ybjzbz,yzxrq,zfcfbz,shid,buweimemo)              
select @xhtemp, @c_idm, 0, @dxmdm, @cxmdm,@xmmc,              
@xmdw, 1,  1, @ypfj ,  @ylsj,              
@c_ypyf, @c_pcdm, @c_ypjl, @c_jldw , @c_dwlb,              
@c_ts,  @cxmsl, @c_cfts, @cmemo,   0,    '',0 ,@clcxmdm,@clcxmdm,@bzsm ,@tmpsqdgroupno ,@yhdj,@cv5xh,@cmxjjbz,@yzxrq2,@zfcfbz2,@cshid,@buweimemo2        
if @@error<>0              
begin              
select 'F','保存划价处方明细出错！'              
rollback tran              
deallocate cs_sfxmcl                  
return                
end        
select @mxxhtemp=@@identity           
end              
else           
--modify by lls            
begin        
if exists(select 1 from SF_HJCFK (nolock) where patid=@patid and sqdxh=@sqdxh and sfksdm=@sfksdm and        
(@config_2147 = '否') or ( (@config_2147 = '是') and (@hjcfindex % @config_2149 <> 1) ) )              
begin              
--modify by lls 将最新记录的划价处方单序号付给临时值        
--select @xhtemp=xh from SF_HJCFK where patid=@patid and sqdxh=@sqdxh and sfksdm=@sfksdm              
set @xhtemp = @hjcfxhtemp        
--modify by lls        
        
if @@error<>0              
begin              
select 'F','保存划价处方出错！'              
rollback tran              
deallocate cs_sfxmcl                  
return              
end              
insert into SF_HJCFMXK(cfxh, cd_idm, gg_idm, dxmdm, ypdm,ypmc,               
ypdw,  ypxs,  ykxs,  ypfj, ylsj,               
ypyf, pcdm, ypjl, jldw, dwlb,              
ts,  ypsl,  cfts,  memo,        
zbz,    mzdm,shbz,lcxmdm,sqdsjxm,sqdxmbz,sqdgroupno,yhdj,v5xh,ybjzbz,yzxrq,zfcfbz,shid,buweimemo)              
select @xhtemp, 0, 0, @dxmdm, @cxmdm,@xmmc,              
@xmdw, 1,  1, @ypfj ,  @ylsj,              
'', '', 0, '' , 0,              
1,  @cxmsl, 1, @cmemo,        
0,    '',0 ,@clcxmdm,@sjxmdm,@bzsm ,@tmpsqdgroupno,@yhdj,@cv5xh,@cmxjjbz,        
@yzxrq2,@zfcfbz2,@cshid,@buweimemo2            
if @@error<>0              
begin              
select 'F','保存划价处方明细出错！'              
rollback tran              
deallocate cs_sfxmcl                  
return                
end        
select @mxxhtemp=@@identity          
end              
else              
begin       
      
if (@cfmedtype='' or @cfmedtype is null)   --新增代码  by xieni       
      select @cftszddm='',@cftszdmc=''       
            
             
insert into SF_HJCFK( czyh, lrrq, patid, hzxm, py, wb,             
ysdm,  ksdm,  yfdm,  sfksdm, qrczyh, qrrq,        
cfts, jlzt,  cflx, sycfbz,   tscfbz,  ghxh, memo,              
shbz1,  shbz2,  shbz3,  zfcfbz,  jzbz,shbz7              
,djje,djbz,ybshbz,sqdxh,sqdid,bzdm,bzmc,fylb,medtype,medtypemc,cftszddm,cftszdmc,ybbfz,ybbfzmc,sqdlb,zjbz,ismxb,     --add fylb by lls for88846        
xzlb,bfzbz,syyllb,sylbdm,sylbmc,sybzdm,sybzmc,bfz,zzrslx,sysj,ycbjyjcxmdm,ycbjyjcxmmc,syfwzh,jhzh,sqdzfbz,tsbrshbz,cfybzddm,cfybzdmc)           
--add zhangwei 需求 87078 重庆开县人民医院生育医保申请单              
values(  @ysdm, @now, @patid, @hzxm,  @py, @wb,              
@cfysdm, @sqks , @sfksdm, @sfksdm,   null, null,        
1,    0, 5 , 0, 0, @ywxh, @vclcaption,              
0, 0, 0, 0, @jzbz,@shbz7              
,@djje,@djbz,0,@sqdxh,@frmcode,@bzdm,@bzmc,@fylb,@cfmedtype,@cfmedtypemc,        
@cftszddm,@cftszdmc,@cfybbfz,@cfybbfzmc,@sqdlb,2,@mbbz        
,@xzlb,@bfzbz,@syyllb,@sylbdm,@sylbmc,@sybzdm,@sybzmc,@bfz,@zzrslx,@sysj,@ycbjyjcxmdm,        
@ycbjyjcxmmc,@syfwzh,@jhzh,@zfbz,@tsbrshbz,@cfybzddm,@cfybzdmc)                   
if @@error<>0 or @@rowcount=0              
begin              
select 'F','保存划价处方出错！'              
rollback tran              
deallocate cs_sfxmcl                  
return              
end              
        
select @xhtemp=@@identity          
set @hjcfxhtemp = @xhtemp  --add by lls 记录最新的划价处方序号                    
        
insert into SF_HJCFMXK(cfxh, cd_idm, gg_idm, dxmdm, ypdm,ypmc,               
ypdw,  ypxs,  ykxs,  ypfj, ylsj,               
ypyf, pcdm, ypjl, jldw, dwlb,              
ts,  ypsl,  cfts,  memo,           
zbz,    mzdm,shbz,lcxmdm,sqdsjxm,sqdxmbz,sqdgroupno,yhdj,v5xh,ybjzbz,yzxrq,                      zfcfbz,shid,buweimemo)              
select @xhtemp, @c_idm, 0, @dxmdm, @cxmdm,@xmmc,              
@xmdw, 1,  1, @ypfj ,  @ylsj,              
@c_ypyf, @c_pcdm, @c_ypjl, @c_jldw , @c_dwlb,              
@c_ts,  @cxmsl, @c_cfts, @cmemo,        
0,    '',0 ,@clcxmdm,@sjxmdm,@bzsm,@tmpsqdgroupno,@yhdj,@cv5xh,@cmxjjbz,        
@yzxrq2,@zfcfbz2,@cshid,@buweimemo2             
if @@error<>0              
begin              
select 'F','保存划价处方明细出错！'              
rollback tran              
deallocate cs_sfxmcl                  
return                
end        
select @mxxhtemp=@@identity         
        
set @hjcfindex = 1   --计数清1        
        
end        
        
set @hjcfindex = @hjcfindex + 1   --对同一科室的明细进行累加           
end        
--end modify by lls         
        
--保存医保审批标志        
if (isnull(@clcxmdm,'0') = '0')        
begin        
insert into MZ_LCMXYBSPJLK(cfxh,cfmxxh,patid,sfid,xmmc,ybspbz,lrrq)        
select @xhtemp,@mxxhtemp,@patid,xmdm,xmmc,ybkzbz,@now from #ybkzsfxm where         
xmdm=@cxmdm        
end else        
begin        
insert into MZ_LCMXYBSPJLK(cfxh,cfmxxh,patid,sfid,xmmc,ybspbz,lrrq)        
select @xhtemp,@mxxhtemp,@patid,a.xmdm,a.xmmc,a.ybkzbz,@now from #ybkzsfxm a,                YY_LCSFXMDYK b (nolock)          
where b.lcxmdm=@clcxmdm and b.xmdm=a.xmdm        
end        
if @@error<>0              
begin              
select 'F','保存医保审批记录出错！'              
rollback tran              
deallocate cs_sfxmcl                  
return                
end        
    
    
        
fetch cs_sfxmcl into @cxmdm ,@cxmsl, @sfksdm, @xmdw, @clcxmdm ,@ylsj,@dxmdm,@sjxmdm,        
@bzsm,@xmmc,@tmpsqdgroupno         
,@c_idm,@c_ypyf,@c_pcdm,@c_ypjl,@c_jldw,@c_dwlb,@c_ts,@c_ypsl,@c_cfts,@c_mxlb,@cv5xh,@cmxjjbz,@cmemo,@ypfj,@yzxrq2,@zfcfbz2,@cshid,@buweimemo2             
end            
close cs_sfxmcl                
deallocate cs_sfxmcl                  
end              
end              
insert into SF_SQDYBSHBZ(sqdxh,xmdm,xmmc,idm,spbh,ybshbz,bxbl,bxsm,memo1,memo2,memo3,mxxh)         
select SQDXH,XMDM,XMMC,0,SPBH,YBSHBZ,BXBL,BXSM,MEMO1,MEMO2,MEMO3,0 from CISDB..OUTP_SQDYBSHBZ where SQDXH = @emrsqdxh / 100  and JLZT=0        
update CISDB..OUTP_SQDYBSHBZ set JLZT=1 where SQDXH = @emrsqdxh / 100  and JLZT=0         
        
--申请单自定义收费处理          
declare @result3 varchar(8),@msg3 ut_mc256          
exec usp_his5_outp_savesqdcharge @wkdz=@wkdz,@jszt=3,@result=@result3 output,@msg=@msg3 output          
if @result3='F'          
begin          
rollback tran       
select @result3,@msg3          
return          
end     
    
---门诊材料费计算                
IF @config_H172 = 1       
begin             
EXEC usp_mz_ys_jyclldcl @patid = @patid, @sqks = @sqks, @zxks = @zxks, @ghxh = @ywxh, @czyh = @ysdm              
IF @@error <> 0       
begin                    
SELECT  'F', '处理联动材料出错！'                    
ROLLBACK TRAN     
end    
end    
        
commit tran            
select 'T'+isnull(@strmsg, ''),@sqdxh,@xhtemp        
return             
end 


