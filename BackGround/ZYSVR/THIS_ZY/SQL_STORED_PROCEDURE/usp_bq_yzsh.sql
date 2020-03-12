ALTER proc usp_bq_yzsh  
 @syxh ut_syxh,--首页序号   
    @czyh ut_czyh,--操作员号  
 @shlb smallint = 0,--审核类别0=全部医嘱，1=单条医嘱  
 @yzbz smallint = 0,--医嘱类别0=临时，1=长期, -1, 全部  
 @fzxh ut_xh12 = null,--医嘱序号  
 @yexh ut_syxh = 0,--婴儿序号  
 @maxcqyzxh ut_xh12 =0,--最大长期医嘱序号  
 @maxlsyzxh ut_xh12 =0,--最大临时医嘱序号  
 @LSfzxh varchar(200) = '',--审核不通过的临时医嘱分组序号集合  
 @CQfzxh varchar(200) = '',--审核不通过的长期医嘱分组序号集合  
 @dqksdm ut_ksdm='',--当前登录科室代码  
 @emrsybz ut_bz = 0 ,--审核源 0:护士站， 1：医生站  
 @yzlbcondition varchar(100)='', --医嘱类别查询条件  
 @shsj ut_rq16 = '', --指定审核时间，为空则取当前时间  
 @guid   ut_mc64=''  --当前操作唯一码        
as --集416223 2018-09-04 14:15:42 4.0标准版  
/**********  
[版本号]4.0.0.0.0  
[创建时间]2004.12.1  
[作者]王奕  
[版权] Copyright ? 2004-2008上海金仕达-卫宁软件股份有限公司[描述]医嘱审核  
[功能说明]  
 病人单条医嘱或全部医嘱审核  
[参数说明]  
 @syxh ut_syxh,  首页序号  
     @czyh ut_czyh,  操作员号  
 @shlb smallint = 0, 审核类别0=全部医嘱，1=单条医嘱  
 @yzbz smallint = 0, 医嘱类别0=临时，1=长期, -1, 全部  
 @fzxh ut_xh12 = null, 医嘱序号  
 @yexh ut_syxh = 0 婴儿序号, Add by Wang Yi, 2003.03.03  
 @maxcqyzxh ut_xh12 =0,  最大长期医嘱序号   add by agg 2004.05.17  
 @maxlsyzxh ut_xh12 =0,  最大临时医嘱序号   add by agg 2004.05.17  
 @LSfzxh varchar(100) = '', 审核不通过的临时医嘱分组序号集合    
 @CQfzxh varchar(100) = ''  审核不通过的长期医嘱分组序号集合  
 @emrsybz ut_bz = 0 0:护士站医嘱审核， 1：医生站医嘱审核  
[返回值]  
[结果集、排序]  
[调用的sp]  
[调用实例]  
[修改说明]  
Modify By Koala 2002.02.19 审核时增加医嘱类别的判断（允许单独审核长期/临时医嘱）  
          hkh 2003.11.13   谁停止医嘱，医嘱停止者显示谁,不再显示停止医嘱的审核者  
         BQ_CQYZK.tzysdm 改为 BQ_LSYZK.lrczyh ，原为BQ_CQYZK.ysdm  
         医嘱停止者显示:BQ_CQYZK.tzysdm,原为BQ_CQYZK.tzczyh(即审核停止医嘱的人）   
 gaowen 2003.12.29 isnull(c.memo,c.ysdm)的写法有问题，改为case……when  
 yxp 2004-02-25 关于memo的写法；调用usp_bq_tzyz时没有判断@@error  
        agg 2004.05.17 加了最大长期医嘱序号和最大临时医嘱序号，审核时不能大于这个序号，以防止医嘱和护士同时操作时，有医嘱护士没年就审核了.  
 hhr 2004-07-08 临时医嘱联动材料保存到BQ_LSJZK  
 mit, 2oo4-11-19 ,CLJZ  
 Modify By Koala 2005.04.13 Modify 增加手术单据状态的判断(用于区别审核后有通知单后手术室才能接收还是手术室可以直接接收)     
 wuming update 材料记账全部转为龙华版材料记账，去除老模式的支持 Modify  at 20050523  
 Modify By Koala 2006.08.07 增加职称审核更新 开发序号12690  
**********/  
set nocount on  
if(isnull(@czyh,'')='')
begin
select 'F','操作员工号不能为空！'
return
end  
declare @now varchar(16),  
 @tzxh ut_xh12,  --停止医嘱分组序号  
 @ysdm ut_czyh,  --医生代码  
 @tzrq ut_rq16,  --停止日期  
 @yzlb smallint,  --医嘱类别  
 @ksrq ut_rq16,  --开始日期  
 @ypdm ut_xmdm,  --药品代码  
 @mzdm ut_xmdm,  --麻醉代码  
 @ypmc ut_mc256,  --药品名称  
 @zxksdm ut_ksdm, --科室代码  
 @ztnr ut_memo, --嘱托内容  
 @errmsg varchar(50),  
 @btbz char(2),  
 @ispc char(2),  --是否使用带频次的材料记账  
 @issh varchar(4),       --阳性药品是否能审核  
 @shnr varchar(255)    --药品没有通过审核信息  
 ,@execmsg varchar(8000)  
 ,@ssql varchar(1000)  
  
declare @iscansssq char(2),  
 @ssjlzt ut_bz,  
 @ssdj ut_bz  
declare @configG014 char(2),  --是否在住院医生站里调用医嘱审核  
 @configG106 char(2),  --医嘱审核是否发送消息给护士站(G014="是"有效)  
 @fsip varchar(32),   --发送方IP地址  
 @jsbq varchar(32),  --接收者 ,可能是职工，科室，病区  
 @brcw varchar(32),  --病人床位  
 @hzxm ut_mc64,  --病人姓名  
 @msg varchar(255),   --消息内容  
 @configG107 ut_xmdm,  
 @configG108 ut_xmdm,  
    @configG153 char(2)         --消息是否自动打印  
    ,@config6461 char(2)         --病区医嘱审核后是否发送消息  
    ,@jajbz ut_bz   --是否有加急的医嘱    0:无   1:有     -1:没有医嘱被审核  
    ,@config6480 char(2)   --是否使用医生(EMR医嘱审核)与护士分开审核的机制  
    ,@config6481 char(2)   --六院医嘱审核发送消息时是否放到前台进行(必须是EMR中,并且6461为否的情况下)  
    ,@config6A70 char(2)   --医嘱审核成功后是否弹出本次审核的医嘱明细  
    ,@config6036 varchar(2)  
    ,@configG236 varchar(2)  
    ,@sfxyzlc int     --是否使用新医嘱流程   
    ,@config6501 varchar(2)  --是否使用围手术期控制  
    ,@configks20 int  
    ,@configG435 varchar(2)  
    ,@yznr varchar(255)  
    ,@tzyy int  
    ,@config6800 varchar(1)   
 ,@config6949 varchar(2) --lyljfs是否默认为1重新累计  
 ,@config6538 varchar(2) --是否提示病人的长期医嘱存在有效的累计领药信息(控制护士站和医生站医嘱录入)  
 ,@config6A03 varchar(255) --选择明启发药的药房代码  
 ,@config6A71 varchar(2)  --是否给平台发送消息  
 ,@config6A19 varchar(2) --新开医嘱是否启用特殊模式  
 ,@config6A95_ls varchar(50)  --默认的执行时间为医嘱开始时间延后多少分钟  临时  
 ,@config6A95_cq varchar(50)  --默认的执行时间为医嘱开始时间延后多少分钟  长期  
 ,@config6142 varchar(2)    --小处方是否生成到临时医嘱  
 ,@config6583 varchar(2)    --小处方是否要经过审核后才生成领药信息  
 ,@config6C54 varchar(200)  --启用医嘱审核同步更新护士执行医嘱的执行及护士签名的医嘱类别集合  
 ,@config6A38 VARCHAR(2) --是否将病人的数据写入平台中间库  
 ,@config6C58 varchar(64)  
 ,@brfyye  ut_money --病人费用余额  
 ,@qkbz   smallint  
 ,@cydyfyye  ut_money --病人费用余额  
 ,@error_count int   --医生不通过医嘱是否存在   1 存在   0 不存在  
  
--add by kongwei 参数6A38 ESB接口专用  
declare @syxh_1 varchar(12),@yexh_1 varchar(12),@maxlsyzxh_1 varchar(12),@xhtemp_dyz_1 varchar(12),@xhtemp_1 varchar(12)   
  
declare @yzbh_cqlsbz ut_bz,   --长期临时标志   
    @yzbh_syxh ut_xh12,  
    @yzbh_yzxh ut_xh12,  
    @yzbh_zxks ut_ksdm,  
    @yzbh_bqdm ut_ksdm,       
    @yzbh_xtbz ut_bz,  
    @yzbh_pcsj ut_dm5,  
    @shr ut_czyh,  
    @yzzt ut_bz  
declare @shyzcount int --审核医嘱数量  
DECLARE @config6788 BIT --add by zll for 189327上海市儿童医院—病区管理系统 医嘱审核 是否启用拒绝通过审核功能  
SELECT @config6788=1                          
SELECT @config6788=(SELECT CASE WHEN isnull(config,'否')='是'then 0 else 1 end from YY_CONFIG where id='6788')                        
select @jajbz=-1 ,@execmsg=''     
  
select @shyzcount = 0  
select @config6480='否'  
select @config6480=isnull(config,'否') from YY_CONFIG where id='6480'  
select @config6142=isnull(config,'否') from YY_CONFIG where id='6142'  
select @config6583=isnull(config,'否') from YY_CONFIG where id='6583'  
select @configG014=isnull(config,'否') from YY_CONFIG where id='G014'  
select @configG106=isnull(config,'否') from YY_CONFIG where id='G106'  
select @configG107=isnull(config,'') from YY_CONFIG where id='G107' --危重文字医嘱代码  
select @configG108=isnull(config,'') from YY_CONFIG where id='G108' --危重文字医嘱代码    
select @config6800=isnull(config,'1') from YY_CONFIG where id='6800'--医嘱审核变更ZY_BRSYK.wzjb的方式 0:不更新 1:根据参数 G107 、 G108 更新 2: 根据5.0医生站的yzlb=16,17更新  
if @shsj = ''   
begin  
 select @now=convert(char(8),getdate(),112)+convert(char(8),getdate(),8)  
end  
else  
begin  
 select @now=@shsj  
end  
select @iscansssq=isnull(config,'否') from YY_CONFIG where id='G024'  
select @iscansssq = isnull(@iscansssq,'否')  
select @issh = isnull(config,'是') from YY_CONFIG where id='6293'  
select @shnr = ''  
if @iscansssq ='否'  
 select @ssjlzt = 0  
else  
 select @ssjlzt = -1  
  
select @configG153=isnull(config,'否') from YY_CONFIG where id='G153'  
select @configG153 = isnull(@configG153,'否')  
  
select @config6461=isnull(config,'否') from YY_CONFIG where id='6461'  
select @config6461 = isnull(@config6461,'否')  
  
select @config6481=isnull(config,'否') from YY_CONFIG where id='6481'  
select @config6481 = isnull(@config6481,'否')  
  
select @config6501=isnull(config,'否') from YY_CONFIG where id='6501'  
  
select @config6036 = config from YY_CONFIG where id = '6036'   
select @config6036 = isnull(@config6036,'否')  
select @configG236 = config from YY_CONFIG where id = 'G236'   
select @configG236 = isnull(@configG236,'否')  
  
select @config6A70 = config from YY_CONFIG where id = '6A70'  
select @config6A70 = isnull(@config6A70,'0')    
select @config6A71 = config from YY_CONFIG where id = '6A71'  
select @config6A71 = isnull(@config6A71,'否')    
select @config6A19 = config from YY_CONFIG where id = '6A19'  
select @config6A19 = ISNULL(@config6A19, '0')  
select @config6C54 = ISNULL(config,'') from YY_CONFIG where id = '6C54'  
if @config6C54 <> ''   
begin  
    select @config6C54 = replace(@config6C54, ',', '","')  
    select @config6C54 = '"' + @config6C54 +'"'  
end  
select @config6A38=config from YY_CONFIG where id='6A38'   
SELECT @config6A38=ISNULL(@config6A38,'否')  
----------默认的执行时间为医嘱开始时间延后多少分钟 长期临时控制参数拆分---------  
if @config6A19 = '4'  
begin  
 declare @config6A95 varchar(100)  
 select @config6A95_cq = '0'  
 select @config6A95_ls = '0'  
 select @config6A95 = config from YY_CONFIG where id = '6A95'  
 if (charindex(',',@config6A95)<>0)   
 begin  
  select @config6A95_cq = substring(@config6A95,1,charindex(',',@config6A95)-1)  
  select @config6A95_ls = substring(@config6A95,charindex(',',@config6A95)+1,len(@config6A95)-charindex(',',@config6A95))  
 end  
 else  
 begin  
  select @config6A95_cq = @config6A95  
 end  
 if @config6A95_cq = ''  
     select @config6A95_cq = '0'  
 if @config6A95_ls = ''  
     select @config6A95_ls = '0'    
end  
-------默认的执行时间为医嘱开始时间延后多少分钟 长期临时控制参数拆分   结束------  
  
select @configks20=isnull(config,0) from YY_CONFIG where id ='KS20'  
  
if (@config6036='是') and (@configG236='是')   
    select @sfxyzlc=1  
else  
    select @sfxyzlc=0  
  
if exists(select 1 from YY_CONFIG where id='G435' and isnull(config,'是')='是')   
 select @configG435='是'  
else  
 select @configG435='否'     
select @config6949=isnull(config,'否') from YY_CONFIG where id='6949'  
select @config6538=isnull(config,'否') from YY_CONFIG where id='6538'  
select @config6A03 = isnull(config,'') from YY_CONFIG where id='6A03'  
select @config6C58=config from YY_CONFIG where id='6C58'   
SELECT @config6C58=ISNULL(@config6C58,'')  
  
--如前台传入0进来，说明不对，现赋个最大值，这种情况出现在升级时，前台程序升了，但后台没有升，即前台没给@maxcqyzxh和@maxlsyzxh赋值，  
--加了下面语句，就不会出现前台看医嘱执行了，但实际没能有执行的情况  
if @maxcqyzxh  =0   
 select @maxcqyzxh=999999999999  
  
if @maxlsyzxh  =0  
 select @maxlsyzxh=999999999999  
   
--KS20开启后6501参数无效  
IF(@configks20>0)  
BEGIN  
 select @config6501='否'   
END  
  
declare @tablename varchar(32)   
  
create table #sh_yzxh_ls  
(  
 xh ut_xh12  
)  
create table #sh_yzxh_cq  
(  
 xh ut_xh12  
)  
create table #yjm_bq_lsyzk  
(  
 xh ut_xh12  
)  
create table #yjm_bq_cqyzk  
(  
 xh ut_xh12  
)  
  
select @tablename='##sh_yzxh_ls'+convert(varchar(12),@syxh)  
select @ssql ='select xh into '+@tablename+' from BQ_LSYZK a(nolock) where syxh='+convert(varchar(12),@syxh)+' and yzzt = 0 '    
if  (@shlb=1)    
 select @ssql=@ssql+' and fzxh='+convert(varchar(12),@fzxh)    
exec (@ssql)    
exec('insert into #sh_yzxh_ls select * from '+@tablename) --select xh into #sh_yzxh_ls from ##sh_yzxh_ls    
exec('drop table '+@tablename)--drop table ##sh_yzxh_ls    
    
select @tablename='##sh_yzxh_cq'+convert(varchar(12),@syxh)  
select @ssql ='select xh into '+@tablename+' from BQ_CQYZK a(nolock) where syxh='+convert(varchar(12),@syxh)+' and yzzt = 0 '    
if  (@shlb=1)    
 select @ssql=@ssql+' and fzxh='+convert(varchar(12),@fzxh)    
exec (@ssql)    
exec('insert into #sh_yzxh_cq select * from '+@tablename) --select xh into #sh_yzxh_cq from ##sh_yzxh_cq    
exec('drop table '+@tablename)--drop table ##sh_yzxh_cq    
    
--sang+++2014-04-30 只能对前台解密通过的医嘱才能审核,此段代码现场不可随意修改，修改需要咨询公司开发部  
--取已解密临时医嘱  
--select xh   
--into #yjm_bq_lsyzk  
--from BQ_LSYZK(nolock)   
--where syxh=@syxh --xq205569 由于公司其他部门涉及到这块的内容还没有改造完成,程序调整，暂不用医嘱加密,所以加载该病人所有医嘱到【已解密医嘱临时表】  
----and ypsl2=ypsl3 and ypsl2<>'' --当ypsl2为null时，ypsl3也为null  ypsl2=ypsl3是不成立的  
--and yzlb<>15 --排除草药生成的临时医嘱  
--if @@error<>0  
--begin  
--  select "F","取已解密临时医嘱失败！"  
--  return     
--end   
select @tablename='##yjm_bq_lsyzk_1'+convert(varchar(12),@syxh)  
if( @yzlbcondition<>'') and (@shlb=0)    
begin    
    select @ssql='select xh into '+@tablename+'  from BQ_LSYZK a(nolock) where syxh='+convert(varchar(12),@syxh)+' and yzlb<>15  and ' +@yzlbcondition    
end    
else    
begin    
    select @ssql='select xh into '+@tablename+'  from BQ_LSYZK a(nolock) where syxh='+convert(varchar(12),@syxh)+' and yzlb<>15  '    
end    
if  (@shlb=1)    
 select @ssql=@ssql+' and fzxh='+convert(varchar(12),@fzxh)    
    
exec (@ssql)    
exec('insert into #yjm_bq_lsyzk select * from '+@tablename) --select xh into #yjm_bq_lsyzk from ##yjm_bq_lsyzk_1    
exec('drop table '+@tablename)--drop table ##yjm_bq_lsyzk_1    
  
--取已解密长期医嘱  
--select xh   
--into #yjm_bq_cqyzk  
--from BQ_CQYZK(nolock)   
--where syxh=@syxh  --xq205569 由于公司其他部门涉及到这块的内容还没有改造完成,程序调整，暂不用医嘱加密,所以加载该病人所有医嘱到【已解密医嘱临时表】  
----and ypsl2=ypsl3 and ypsl2<>'' --当ypsl2为null时，ypsl3也为null  ypsl2=ypsl3是不成立的  
--if @@error<>0  
--begin  
--  select "F","取已解密长期医嘱失败！"  
--  return     
--end    
select @tablename='##yjm_bq_cqyzk_1'+convert(varchar(12),@syxh)   
if( @yzlbcondition<>'') and (@shlb=0)    
begin    
    select @ssql='select xh into '+@tablename+'  from BQ_CQYZK a(nolock) where syxh='+convert(varchar(12),@syxh)+'  and ' +@yzlbcondition    
end    
else    
begin    
    select @ssql='select xh into '+@tablename+'  from BQ_CQYZK a(nolock) where syxh='+convert(varchar(12),@syxh)    
end    
if  (@shlb=1)    
 select @ssql=@ssql+' and fzxh='+convert(varchar(12),@fzxh)        
exec (@ssql)    
exec('insert into #yjm_bq_cqyzk select * from '+@tablename) --select xh into #yjm_bq_cqyzk from ##yjm_bq_cqyzk_1    
exec('drop table '+@tablename)--drop table ##yjm_bq_cqyzk_1    
    
delete from #yjm_bq_lsyzk where xh>@maxlsyzxh  
delete from #yjm_bq_cqyzk where xh>@maxcqyzxh  
  
--审核临时  
if @yzbz=0 and not exists(select 1 from #yjm_bq_lsyzk)  
begin  
  select "F","无解密成功的临时医嘱可审核！"  
  return     
end  
  
--审核长期  
if @yzbz=1 and not exists(select 1 from #yjm_bq_cqyzk)  
begin  
 select "F","无解密成功的长期医嘱可审核！"  
 return    
end  
  
--审核临时和长期  
if not exists(select 1 from #yjm_bq_lsyzk) and not exists(select 1 from #yjm_bq_cqyzk)   
begin  
 select "F","无解密成功的医嘱可审核！"  
 return      
end  
  
if exists(select 1 from YY_CONFIG (nolock) where id='6B88' and config='是')  
begin  
 select @error_count = 0  
 if exists (select 1 from BQ_LSYZK a (nolock) inner join #yjm_bq_lsyzk b on a.xh=b.xh   
  where  a.syxh=@syxh and a.yexh=@yexh and a.yzzt=0 and a.ksrq>@now  
  )  
 begin  
  select @error_count = 1  
  delete from  #yjm_bq_lsyzk where xh in (select a.xh from BQ_LSYZK a (nolock) inner join #yjm_bq_lsyzk b on a.xh=b.xh   
  where  a.syxh=@syxh and a.yexh=@yexh and a.yzzt=0 and a.ksrq>@now)  
  select @shnr='存在未到医嘱开始日期的医嘱，不能审核！'  
 end  
 if exists (select 1 from BQ_CQYZK a (nolock) inner join #yjm_bq_cqyzk b on a.xh=b.xh   
  where  a.syxh=@syxh and a.yexh=@yexh and a.yzzt=0 and a.ksrq>@now  
  )  
 begin  
  select @error_count = 1  
  delete from #yjm_bq_cqyzk where xh in (select a.xh from BQ_CQYZK a (nolock) inner join #yjm_bq_cqyzk b on a.xh=b.xh    
  where  a.syxh=@syxh and a.yexh=@yexh and a.yzzt=0 and a.ksrq>@now)  
  select @shnr='存在未到医嘱开始日期的医嘱，不能审核！'  
 end  
 if (@error_count=1) and (not exists (select 1 from BQ_LSYZK a (nolock) inner join #yjm_bq_lsyzk b on a.xh=b.xh where a.syxh=@syxh and a.yzzt=0)  
  and not exists (select 1 from BQ_CQYZK a (nolock) inner join #yjm_bq_cqyzk b on a.xh=b.xh  where a.syxh=@syxh and a.yzzt=0))  
 begin  
  select "T",@shnr  
  return  
 end  
end  
  
if (select config from  YY_CONFIG (nolock) where id = '6A04')='是'  
begin  
    if @shlb=0  --审核全部医嘱 只审核 ysshbz=0，2的  
    begin  
  select @error_count = 0  
        if (@yzbz = 0) or (@yzbz = -1)  -- @yzbz 医嘱类别(0:临时, -1:全部)   
        begin  
            if exists (select 1 from BQ_LSYZK a (nolock) inner join #yjm_bq_lsyzk b on a.xh=b.xh   
               where  a.syxh=@syxh and a.yexh=@yexh and a.xh<= @maxlsyzxh and a.yzzt=0 and (a.ysshbz not in (0,2) and isnull(a.v5xh,0)<>0))  
            begin  
    select @error_count = 1  
                delete from  #yjm_bq_lsyzk where xh in (select a.xh from BQ_LSYZK a (nolock) inner join #yjm_bq_lsyzk b on a.xh=b.xh   
                where  a.syxh=@syxh and a.yexh=@yexh and a.xh<= @maxlsyzxh and a.yzzt=0 and (a.ysshbz not in (0,2) and isnull(a.v5xh,0)<>0))            
            end     
               
        end  
        if (@yzbz = 1) or (@yzbz = -1) -- @yzbz 医嘱类别(1:长期, -1:全部)   
        begin  
            if exists (select 1 from BQ_CQYZK a (nolock) inner join #yjm_bq_cqyzk b on a.xh=b.xh    
            where  a.syxh=@syxh and a.yexh=@yexh and a.xh<=@maxcqyzxh and a.yzzt=0 and (a.ysshbz not in (0,2) and isnull(a.v5xh,0)<>0))  
         begin  
    select @error_count = 1  
                delete from #yjm_bq_cqyzk where xh in (select a.xh from BQ_CQYZK a (nolock) inner join #yjm_bq_cqyzk b on a.xh=b.xh    
                where  a.syxh=@syxh and a.yexh=@yexh and a.xh<=@maxcqyzxh and a.yzzt=0 and (a.ysshbz not in (0,2) and isnull(a.v5xh,0)<>0))  
            end  
        end  
        if (@error_count=1) and (not exists (select 1 from BQ_LSYZK a (nolock) inner join #yjm_bq_lsyzk b on a.xh=b.xh where a.syxh=@syxh and a.yzzt=0)  
   and not exists (select 1 from BQ_CQYZK a (nolock) inner join #yjm_bq_cqyzk b on a.xh=b.xh  where a.syxh=@syxh and a.yzzt=0))  
  begin  
      select "F1","医嘱因药师未审核，医嘱审核未通过！"  
      return      
  end  
    end  
    else --单条审核 ysshbz=1的不审核 医嘱查询的时候 已经过滤了 0，1，2  
    begin  
  if exists (select 1 from BQ_LSYZK a (nolock) inner join #yjm_bq_lsyzk b on a.xh=b.xh where  a.syxh=@syxh and a.yexh=@yexh and a.xh=@fzxh and a.yzzt=0 and a.ysshbz=1)  
     or exists (select 1 from BQ_CQYZK a (nolock) inner join #yjm_bq_cqyzk b on a.xh=b.xh  where  a.syxh=@syxh and a.yexh=@yexh and a.xh=@fzxh and a.yzzt=0 and a.ysshbz=1)  
  begin  
   select "F1","医嘱因药师未审核，医嘱审核未通过！"  
   return  
  end  
    end   
end  
   
select @brfyye = 0 --病人费用余额  
exec usp_zy_bryjjbj @syxh, 1, 0, @errmsg output  -- 在院病人预交金报警（后台调用）     
if @errmsg like 'F%'   
 select @qkbz=1 --欠款标志 0否 1是  
else  
 select @brfyye = convert(numeric(14,4),rtrim(ltrim(substring(@errmsg,2,49))))  
  
  
---创建审核通过医嘱临时表，用于医嘱闭环--------------------------------  
declare @config0251 varchar(2), @config6D87 VARCHAR(2)      
select @config0251 =isnull(config,'否') from YY_CONFIG (nolock) where id='0251'   
select @config6D87 =isnull(config,'否') from YY_CONFIG (nolock) where id='6D87'    
  
create table #yshyz  
(  
 yzxh ut_xh12 null,  
 cqlsbz ut_bz null,  
 yzzt ut_bz null  
)  
--------------------------------------------------------------------------  
begin tran --=======●●●事务 开始============================  
  
-----------------上海儿童医院出院带药审核--swx 20140227-----  
if (@yzbz=0 or @yzbz=-1)   
 and exists(select 1 from BQ_LSYZK a(nolock) inner join #yjm_bq_lsyzk wls on wls.xh=a.xh   
    left join BQ_LSYZK_FZ b(nolock) on a.xh = b.yzxh   
   where a.syxh=@syxh and a.yzzt= 0 and a.yzlb=12   
    and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
    and (@config6788=1 OR isnull(b.tgbz,1) <> 0)  
    and (@shlb=0 or (@shlb=1 and a.fzxh= isnull(@fzxh,0)))  
 ) -- 全部审核时，出院带药医嘱处理  
begin  
 if exists(select 1 from YY_CONFIG where id='6C03' and config='是')  
 begin  
  select @cydyfyye=0  
  select @cydyfyye=sum(a.ypsl*cd.ylsj)   
  from BQ_LSYZK a(nolock) inner join #yjm_bq_lsyzk wls on wls.xh=a.xh   
   left join BQ_LSYZK_FZ b(nolock) on a.xh = b.yzxh   
   inner join YK_YPCDMLK cd(nolock) on a.idm=cd.idm  
  where a.syxh=@syxh and a.yzzt= 0 and a.yzlb=12   
   and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
   and (@config6788=1 OR isnull(b.tgbz,1) <> 0)  
   and (@shlb=0 or (@shlb=1 and a.fzxh= isnull(@fzxh,0)))  
    
  if @cydyfyye>@brfyye  
  begin  
   delete from  #yjm_bq_lsyzk   
   where xh in (select a.xh from BQ_LSYZK a (nolock) inner join #yjm_bq_lsyzk b on a.xh=b.xh   
    where  a.syxh=@syxh and a.yexh=@yexh and a.yzzt=0 and a.yzlb=12   
    )  
   select @shnr='出院带药药品金额大于病人余额，不能审核！'  
   if not exists (select 1 from BQ_LSYZK a (nolock) inner join #yjm_bq_lsyzk b on a.xh=b.xh where a.syxh=@syxh and a.yzzt=0)  
    and not exists (select 1 from BQ_CQYZK a (nolock) inner join #yjm_bq_cqyzk b on a.xh=b.xh  where a.syxh=@syxh and a.yzzt=0)  
   begin  
    rollback  tran  
    select "F",@shnr  
    return  
   end  
  end  
 end  
 if @shnr<>'出院带药药品金额大于病人余额，不能审核！'  
 begin  
  declare @syxh_cydy ut_syxh,  
    @yzxh_cydy ut_xh12   
  
  exec usp_bq_cydysh '',1,@syxh_cydy,@delphi = 0,@errmsg = @errmsg output,@usewbtran=1  --使用外部事物 0否 1是  
  if @errmsg like "F%"  
  begin  
   rollback  tran  
   select "F",substring(@errmsg,2,50)  
   return        
  end    
  declare cs_cydy_yzsh cursor for  --第二步  
   select distinct a.syxh,a.xh   -- 病人待审的出院带药  
   from BQ_LSYZK a(nolock) inner join #yjm_bq_lsyzk wls on wls.xh=a.xh   
    left join BQ_LSYZK_FZ b(nolock) on a.xh = b.yzxh  
   where a.syxh=@syxh and a.yzzt= 0 and a.yzlb=12  
    and (@shlb=0 or (@shlb=1 and a.fzxh= isnull(@fzxh,0)))  
    and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
    and (@config6788=1 OR isnull(b.tgbz,1) <> 0)  
  for read only  
  open cs_cydy_yzsh   
  fetch cs_cydy_yzsh into @syxh_cydy,@yzxh_cydy  
  while @@fetch_status=0 ---游标 cs_cydy_yzsh while Start  
  begin  
   if @config0251='是' or @config6D87='是'--医嘱闭环状态更新  
   begin  
    insert into #yshyz   
    select distinct xh,0,2  
    from BQ_LSYZK   
    where syxh=@syxh and xh=@yzxh_cydy-- and yzlb=12 and xh in (select xh from #yjm_bq_lsyzk)   
   end     
   update BQ_LSYZK set yzzt=2,shrq=null,zxrq=null,shczyh=null,zxczyh=null   
   where syxh=@syxh and xh=@yzxh_cydy-- and yzlb=12 and xh in (select xh from #yjm_bq_lsyzk)   
           
   exec usp_bq_cydysh '',2,@syxh_cydy,@yzxh_cydy,@delphi = 0,@errmsg = @errmsg output,@usewbtran=1  --使用外部事物 0否 1是    
   if @errmsg like "F%"  
   begin  
    rollback  tran  
    select "F",substring(@errmsg,2,50)  
    return        
   end     
       
   fetch cs_cydy_yzsh into @syxh_cydy,@yzxh_cydy  
  end   
  close cs_cydy_yzsh  
  deallocate cs_cydy_yzsh  
  
  exec usp_bq_cydysh '',3,@syxh_cydy,@yzxh_cydy,@czyh,@czyh,@delphi = 0,@errmsg = @errmsg output,@usewbtran=1  --使用外部事物 0否 1是  
  if @errmsg like "F%"  
  begin  
   rollback  tran  
   select "F",substring(@errmsg,2,50)  
   return        
  end   
 end    
end  
------------------------------------------------------------  
if @shlb=0  ---=======================▲审核类别 0=全部医嘱  start=====================================  
begin  
 if (select config from  YY_CONFIG (nolock) where id = 'Y002')='是'  --参数Y002 (福建)是否需要医嘱审批 为 是 start  
 begin  
  --将已用的审批记录更新为已用  
  update YY_BRSPXMK  
  set yyspsl = b.ypsl  , spbz = 2  
  from YY_BRSPXMK a, BQ_LSYZK b,#yjm_bq_lsyzk wls  
  where a.syxh = @syxh and b.xh=wls.xh  
  and a.syxh = b.syxh  
  and a.idm = b.idm  
  and a.ypdm = b.ypdm  
  and a.spbz = 1  
  and b.yzzt = 0  
  and charindex( ','+convert(varchar(100),b.fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
 end --参数Y002 (福建)是否需要医嘱审批 为 是 end  
 if @@error<>0  
 begin  
  rollback tran  
  select "F","更新审批信息失败！"  
  return  
 end  
  
 --将已用的职称审批记录更新为已用  
 if exists (select 1 from BQ_BRXZYYSQK(nolock) where syxh = @syxh and spbz = 1)  
 begin  
  --将已用的审批记录更新为已用  
  update BQ_BRXZYYSQK  
  set spbz = 2  
  from BQ_BRXZYYSQK a, BQ_CQYZK b,#yjm_bq_cqyzk wcq  
  where a.syxh = @syxh and b.xh=wcq.xh  
  and a.syxh = b.syxh  
  and a.idm = b.idm  
  and a.ypdm = b.ypdm  
  and a.spbz = 1  
  and b.yzzt=0  
  and a.sqry = b.ysdm  
  and charindex( ','+convert(varchar(100),b.fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
 end  
 if @@error<>0  
 begin  
  rollback tran  
  select "F","更新职称审批信息失败！"  
  return  
 end  
   
 if (@yzbz = 0) or (@yzbz = -1)  --▲▲审核全部或审核临时 @yzbz 医嘱类别(0:临时, -1:全部) start  
 begin  
  if exists(select 1 from BQ_LSYZK a(nolock) inner join #yjm_bq_lsyzk wls on wls.xh=a.xh   
   where a.syxh=@syxh and a.yexh = @yexh and a.xh<= @maxlsyzxh  and a.yzzt=0 and a.yzlb=2   
    and ( (@sfxyzlc=0) or (isnull(a.ssyzzt,0)=2 )  )  
    )  
  begin ----△if LLLLLL start  
   if (select config from YY_CONFIG (nolock) where id="G090")='否' or @configks20>0  
   begin    
    ----△△参数G090 手术通知单是否审批 为 否  或者 KS20参数>0 使用抗菌素药品管理系统2.0 start  
/*    if exists (select 1 from SS_SSDJK where syxh = @syxh and jlzt = 0 and yzxh = 0 )  
    begin  
     update SS_SSDJK  
     set yzxh = b.xh  
     from SS_SSDJK a , BQ_LSYZK b,SS_SSDJDMK c, SS_SSMZK e    
     where a.syxh = b.syxh  
     and b.syxh = @syxh  
     and b.yexh = @yexh  
     and b.xh <= @maxlsyzxh   
     and b.yzzt = 0   
     and b.yzlb = 2  
     and a.jlzt = 0  
     and a.shzt = c.ssjs  
     and a.yzxh = 0  
     and a.ssdm = b.ypdm  
     and e.id = a.ssdm  
     and e.djdm = c.id   
     if (@@error<>0) or ( @@rowcount=0)  
     begin  
      rollback tran  
      select "F","更新手术通知单失败！"  
      return  
     end  
    end  
    else  
    begin  
     rollback tran  
     select "F","手术通知单未审核完成，不能录入手术医嘱！"  
     return  
    end  
   end  
   else  
   begin  
      
*/  
      
    if (select config from YY_CONFIG (nolock) where id="6036")='是' and @config6501<>'是'  
    begin  ----△△△参数6036 是否使用手术管理系统 为是 且 参数6501，是否使用围手术抗生素控制功能 为否 start  
             insert into SS_SSDJK(syxh, yzxh, patid, blh, hzxm, py, wb, bqdm, ksdm,   
      cwdm, djrq, djczyh, sqrq, ssdm, ssmc, mzdm, mzmc, ssksdm,   
      glbz, qkdj, jlzt, slbz, sslb, memo, ysdm,sqzd,haabz,aprq,jzssbz,ssyzshrq  
      )  
     select @syxh, c.xh, a.patid, a.blh, a.hzxm, a.py, a.wb, a.bqdm, a.ksdm,  
         ---a.cwdm, @now, @czyh, c.ksrq, c.ypdm, c.ypmc, c.mzdm,isnull((select name from  SS_SSMZK b   
         a.cwdm,@now, @czyh,case when (exists(select 1 from YY_CONFIG where id='G256' and config='是')) and (isnull(c.ssaprq,'')<>'') then c.ssaprq else c.ksrq  end sqrq,  
         c.ypdm, convert(varchar(256),c.ypmc), c.mzdm,isnull((select name from  SS_SSMZK b (nolock) where b.id=c.mzdm),''), c.zxksdm,0, null,@ssjlzt, 0, 0,   
      convert(varchar(24),c.ztnr), case isnull(c.memo,'') when '' then (case isnull((select name from  SS_SSMZK b (nolock) where b.id=c.mzdm),'') when '' then '' else c.ysdm   
      --- end) else c.memo end as ysdm,c.sqzd,'-1',c.ssaprq  
      end) else c.memo end as ysdm,c.sqzd,c.haabz,c.ssaprq,c.jzssbz,@now  
           from ZY_BRSYK a (nolock)inner join BQ_LSYZK c(nolock) on a.syxh=c.syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh<=@maxlsyzxh and c.yzzt=0 and c.yzlb=2   
      inner join #yjm_bq_lsyzk wls on c.xh=wls.xh    
      left join BQ_LSYZK_FZ fz(nolock) on fz.yzxh=c.xh  
         where a.syxh=@syxh  
         AND not EXISTS(SELECT 1 FROM SS_SSDJK ss(NOLOCK) WHERE a.syxh=ss.syxh AND ss.yzxh=c.xh AND ss.sslb=0)   
     if @@error<>0  
     begin  
      rollback tran  
      select "F","审核手术医嘱出错！"  
      return  
     end  
                      
     DECLARE @xhtemp ut_xh12    
     SELECT @xhtemp = scope_identity()  --add by kongwei 存在触发器影响 @@identity   ---保存SS_SSDJK.xh  
     SELECT @xhtemp=ISNULL(@xhtemp,0)  
     IF @xhtemp>0  
     BEGIN  
     --主刀医生  
     --  
     --IF NOT EXISTS (SELECT 1 FROM SS_SSRYK a(NOLOCK),SS_SSDJK b(NOLOCK) WHERE a.ssxh=b.xh AND a.rylb=1 AND a.rydm=b.ysdm AND b.syxh=@syxh)  
     IF NOT EXISTS (SELECT 1 FROM SS_SSRYK a(NOLOCK),SS_SSDJK b(NOLOCK) WHERE a.ssxh=b.xh AND a.rylb=1 AND a.rydm=b.ysdm AND b.syxh=@syxh AND b.xh=@xhtemp)  
     begin ----if LLLLLL_aaaaa_111_iiii1 start  
      insert into SS_SSRYK(ssxh,rylb,rydm,ryxm,memo,isjb)  
      select e.xh,1,e.ysdm,d.name,null,0  
      from ZY_BRSYK a (nolock)  
       inner join BQ_LSYZK c(nolock) on a.syxh =c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh=e.yzxh   
       left join YY_ZGBMK d(nolock) on e.ysdm =d.id   
          where a.syxh=@syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh<=@maxlsyzxh and c.yzzt=0 and c.yzlb=2 AND e.xh=@xhtemp  
       and isnull(e.ysdm,'') != ''  
      if @@error<>0  
      begin  
       rollback tran  
       select "F","审核手术医嘱出错！"  
       return  
      END   
     END ----if LLLLLL_aaaaa_111_iiii1 end  
  
     --生成手术一助  
     IF NOT EXISTS (SELECT 1 FROM SS_SSRYK a(NOLOCK),SS_SSDJK b(NOLOCK) WHERE a.ssxh=b.xh AND a.rylb=2 AND b.syxh=@syxh  AND b.xh=@xhtemp)  
     BEGIN ----if LLLLLL_aaaaa_111_iiii2 start  
      insert into SS_SSRYK(ssxh,rylb,rydm,ryxm,memo,isjb)  
      select e.xh,2,c.ssyzysdm,d.name,null,0  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh= c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh=e.yzxh   
       left join YY_ZGBMK d(nolock) on c.ssyzysdm=d.id   
          where a.syxh=@syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh<=@maxlsyzxh and c.yzzt=0 and c.yzlb=2 AND e.xh=@xhtemp  
        and isnull(c.ssyzysdm,'') != ''  
      if @@error<>0  
      begin  
       rollback tran  
       select "F","审核手术医嘱出错！"  
       return  
      END  
     END ----if LLLLLL_aaaaa_111_iiii2 end  
  
     --生成手术二助  
     IF NOT EXISTS (SELECT 1 FROM SS_SSRYK a(NOLOCK),SS_SSDJK b(NOLOCK) WHERE a.ssxh=b.xh AND a.rylb=3 AND b.syxh=@syxh  AND b.xh=@xhtemp)  
     BEGIN ----if LLLLLL_aaaaa_111_iiii3 start  
      insert into SS_SSRYK(ssxh,rylb,rydm,ryxm,memo,isjb)  
      select e.xh,3,c.ssezysdm,d.name,null,0  
      from ZY_BRSYK a (nolock)  
       inner join BQ_LSYZK c(nolock) on a.syxh=c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh         
       inner join SS_SSDJK e(nolock) on c.xh=e.yzxh  
                            left join YY_ZGBMK d(nolock) on c.ssezysdm = d.id           
          where a.syxh=@syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh<=@maxlsyzxh and c.yzzt=0 and c.yzlb=2 AND e.xh=@xhtemp  
        and isnull(c.ssezysdm,'') != ''  
      if @@error<>0  
      begin  
       rollback tran  
       select "F","审核手术医嘱出错！"  
       return  
      end  
                    END ----if LLLLLL_aaaaa_111_iiii3 end  
  
     --生成手术三助  
     IF NOT EXISTS (SELECT 1 FROM SS_SSRYK a(NOLOCK),SS_SSDJK b(NOLOCK) WHERE a.ssxh=b.xh AND a.rylb=4 AND b.syxh=@syxh  AND b.xh=@xhtemp)  
     BEGIN ----if LLLLLL_aaaaa_111_iiii4 start  
      insert into SS_SSRYK(ssxh,rylb,rydm,ryxm,memo,isjb)  
      select e.xh,4,c.ssszysdm,d.name,null,0  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh  
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh         
       inner join SS_SSDJK e(nolock) on c.xh=e.yzxh  
       left join YY_ZGBMK d(nolock) on c.ssszysdm=d.id    
          where a.syxh=@syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh<=@maxlsyzxh and c.yzzt=0 and c.yzlb=2 AND e.xh=@xhtemp  
        and isnull(c.ssszysdm,'') != ''  
      if @@error<>0  
      begin  
       rollback tran  
       select "F","审核手术医嘱出错！"  
       return  
      end  
                  END ----if LLLLLL_aaaaa_111_iiii4 end  
  
     --术前诊断  
     insert into SS_SSZDK(ssxh,zdlb,zdlx,zddm,zdmc,memo)  
     select e.xh,0,0,e.sqzd,isnull(d.name,''),null  
     from ZY_BRSYK a (nolock)  
      inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh   
      inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
      inner join SS_SSDJK e(nolock) on c.xh =e.yzxh   
      left join YY_ZDDMK d(nolock) on e.sqzd = d.id   
     where a.syxh=@syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh<=@maxlsyzxh and c.yzzt=0 and c.yzlb=2  
       and isnull(e.sqzd,'') != ''  
     if @@error<>0  
     begin  
      rollback tran  
      select "F","审核手术医嘱出错！"  
      return  
     end  
       
     if exists(select 1 from sysobjects where name='V5_SSYZK')  
     begin  
      --辅助诊断一  
      insert into SS_SSZDK(ssxh,zdlb,zdlx,zddm,zdmc,memo)  
      select e.xh,0,1,d.SQZD1,isnull(d.SQZDMC1,''),null  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh =e.yzxh   
       left join V5_SSYZK d(nolock) on c.v5xh = d.YZXH and d.SYXH=@syxh  
      where a.syxh=@syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh<=@maxlsyzxh and c.yzzt=0 and c.yzlb=2  
        and isnull(d.SQZD1,'') != ''   
        and not exists (select 1 from SS_SSZDK where ssxh = e.xh and zdlb = 0 and zdlx = 1)  
      if @@error<>0  
      begin  
       rollback tran  
       select "F","审核手术医嘱出错！"  
       return  
      end  
      --辅助诊断二  
      insert into SS_SSZDK(ssxh,zdlb,zdlx,zddm,zdmc,memo)  
      select e.xh,0,2,d.SQZD2,isnull(d.SQZDMC2,''),null  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh =e.yzxh   
       left join V5_SSYZK d(nolock) on c.v5xh = d.YZXH and d.SYXH=@syxh   
      where a.syxh=@syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh<=@maxlsyzxh and c.yzzt=0 and c.yzlb=2  
        and isnull(d.SQZD2,'') != ''  
        and not exists (select 1 from SS_SSZDK where ssxh = e.xh and zdlb = 0 and zdlx = 2)  
      if @@error<>0  
      begin  
       rollback tran  
       select "F","审核手术医嘱出错！"  
       return  
      end  
      --辅助诊断三  
      insert into SS_SSZDK(ssxh,zdlb,zdlx,zddm,zdmc,memo)  
      select e.xh,0,3,d.SQZD3,isnull(d.SQZDMC3,''),null  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh =e.yzxh   
       left join V5_SSYZK d(nolock) on c.v5xh = d.YZXH and d.SYXH=@syxh  
      where a.syxh=@syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh<=@maxlsyzxh and c.yzzt=0 and c.yzlb=2  
        and isnull(d.SQZD3,'') != ''  
        and not exists (select 1 from SS_SSZDK where ssxh = e.xh and zdlb = 0 and zdlx = 3)  
      if @@error<>0  
      begin  
       rollback tran  
       select "F","审核手术医嘱出错！"  
       return  
      end  
     end        
     END   
       
     if (@config6A38='是')  
     begin  
      select @syxh_1=convert(varchar,@syxh),@yexh_1=convert(varchar,@yexh)  
          ,@maxlsyzxh_1=convert(varchar,@maxlsyzxh),@xhtemp_1=convert(varchar,@xhtemp)  
      --手术人员库  
      exec('insert into '+@config6C58+'dbo.JK_SS_SSRYK (xh,eventtype,opeordernumber,emptype,empcode,empname,Facility,FacilityName,  
          memo,isclude,createtime,processstatus)  
      --主刀医生  
      select NEWID(),1,e.xh,1   --人员类别( 0：指导医生,1主刀医生,2：手术一助3:手术二助,4：手术三助  
      --  10：麻醉指导,11：主麻 12付麻   
      --  20：器械护士,21：巡回护士,22：洗手护士  
      --  30：输血)  
      ,e.ysdm,d.name,d.ks_id,d.ks_mc,null,0  --1：手术接班人员，0：手术参与人员  
      ,CONVERT(DATETIME,GETDATE(),120),1 --1:新增 2-平台已读取 3-平台处理失败 4-平台处理成功 5-无效数据   
      from ZY_BRSYK a (nolock)  
       inner join BQ_LSYZK c(nolock) on a.syxh =c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh=e.yzxh   
       left join YY_ZGBMK d(nolock) on e.ysdm =d.id   
          where a.syxh='+@syxh_1+' and c.syxh='+@syxh_1+' and c.yexh = '+@yexh_1+' and c.xh<='+@maxlsyzxh_1+' and c.yzzt=0 and c.yzlb=2 AND e.xh='+@xhtemp_1+'  
       and isnull(e.ysdm,"") != ""  
      union all  
      --手术一助  
      select NEWID(),1,e.xh,2,e.ysdm,d.name,d.ks_id,d.ks_mc,null,0,CONVERT(DATETIME,GETDATE(),120),1  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh= c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh=e.yzxh   
       left join YY_ZGBMK d(nolock) on c.ssyzysdm=d.id   
          where a.syxh='+@syxh_1+' and c.syxh='+@syxh_1+' and c.yexh = '+@yexh_1+' and c.xh<='+@maxlsyzxh_1+' and c.yzzt=0 and c.yzlb=2 AND e.xh='+@xhtemp_1+'  
        and isnull(c.ssyzysdm,"") != ""  
      union all  
      --手术二助  
      select NEWID(),1,e.xh,3,e.ysdm,d.name,d.ks_id,d.ks_mc,null,0,CONVERT(DATETIME,GETDATE(),120),1  
      from ZY_BRSYK a (nolock)  
       inner join BQ_LSYZK c(nolock) on a.syxh=c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh         
       inner join SS_SSDJK e(nolock) on c.xh=e.yzxh  
                            left join YY_ZGBMK d(nolock) on c.ssezysdm = d.id           
          where a.syxh='+@syxh_1+' and c.syxh='+@syxh_1+' and c.yexh = '+@yexh_1+' and c.xh<='+@maxlsyzxh_1+' and c.yzzt=0 and c.yzlb=2 AND e.xh='+@xhtemp_1+'  
        and isnull(c.ssezysdm,"") != ""  
      union all  
      --手术三助  
      select NEWID(),1,e.xh,4,e.ysdm,d.name,d.ks_id,d.ks_mc,null,0,CONVERT(DATETIME,GETDATE(),120),1  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh  
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh         
       inner join SS_SSDJK e(nolock) on c.xh=e.yzxh  
       left join YY_ZGBMK d(nolock) on c.ssszysdm=d.id    
          where a.syxh='+@syxh_1+' and c.syxh='+@syxh_1+' and c.yexh = '+@yexh_1+' and c.xh<='+@maxlsyzxh_1+' and c.yzzt=0 and c.yzlb=2 AND e.xh='+@xhtemp_1+'  
        and isnull(c.ssszysdm,"") != "" ')  
        
      --手术登记库  
      exec('insert into '+@config6C58+'dbo.JK_SS_SSDJK (xh,eventtype,PatID,PatientID,PatientName,DateTimeofBirth,AdministrativeSex,StreetOrMailingAddress,  
           ZipOrPostalCode,AddressType,PhoneNumberHome,PhoneNumberBusiness,MaritalStatusIdentifier,MaritalStatusText,  
        EthnicGroup,EthnicGroupText,BirthPlace,Nationality,NationalityText,IDCardNo,IDCardType,IDCardTypeName,IdentifyNO,  
        PatientClass,PointOfCare,PointOfCareName,Room,Bed,Facility,FacilityName,AttendingDoctor,ReAdmissionIndicator,  
        VisitNumber,AdmitDateTime,OperationOrderNumber,PlacerOrderNumber,RequestDateTime,ScheduleDateTime,FixupDateTime,  
        OrderingFacility,UniversalServiceIdentifier,UniversalServiceText,FillerStatusCode,Position,SpecialMaterial,  
        OperationSite,IsReadyBlood,CutsRating,HepatitisIndicator,SpecialInfect,OperationDept,OperationRoom,Sequence,  
        OperationScaleID,OperationScale,AnaesthesiaMethod,EmergencyIndicator,IsolationIndicator,Memo,RequestedDoctorID,  
        createtime,processstatus)  
      select NEWID(),1,a.patid,a.blh,a.hzxm,convert(datetime,substring(a.birth,1,4)+"-"+substring(a.birth,5,2)+"-"+substring(a.birth,7,2)),  
       case when a.sex="男" then "1" when a.sex="女" then "2" else "9" end,k.lxdz,k.lxyb,"",k.lxdh,k.dwdh,k.hyzk,  
       case when k.hyzk="0" then "未婚"  when k.hyzk="1" then "已婚"  when k.hyzk="2" then "离独"   when k.hyzk="3" then "丧偶"   else "未知" end,   --0未婚,1已婚,2离独,3丧偶  
       k.mzbm,d.name,l.name+m.name+n.name,k.gjbm,e.name,a.cardno,a.cardtype,o.name,substring(a.sfzh,1,18),b.sslb,---患者类别  
       b.bqdm,g.name,h.fjh,b.cwdm,b.ksdm,i.name,b.ysdm,a.zycs,a.syxh,  
       convert(datetime,substring(a.ryrq,1,4)+"-"+substring(a.ryrq,5,2)+"-"+substring(a.ryrq,7,2) + " " +substring(a.ryrq,9,8)),  
       b.xh,b.yzxh,convert(datetime,SUBSTRING(b.djrq,1,4)+"-"+SUBSTRING(b.djrq,5,2)+"-"+SUBSTRING(b.djrq,7,2) + " " + SUBSTRING(b.djrq,9,8)),  
       case when b.kssj is null or rtrim(b.kssj)="" then null else convert(datetime,SUBSTRING(b.kssj,1,4)+"-"+SUBSTRING(b.kssj,5,2)+"-"+SUBSTRING(b.kssj,7,2)+" "+SUBSTRING(b.kssj,9,8)) end,  
       case when b.aprq is null or rtrim(b.aprq)="" then null else convert(datetime,SUBSTRING(b.aprq,1,4)+"-"+SUBSTRING(b.aprq,5,2)+"-"+SUBSTRING(b.aprq,7,2)+" "+SUBSTRING(b.aprq,9,8)) end,  
       j.name,b.ssdm,b.ssmc,b.jlzt,b.tw,b.tsqx,b.bwid,case when isnull(b.bx,"")<>"" then 1 else 0 end,b.qkdj,b.haabz,b.tsgr,  
       b.ssksdm,b.roomno,b.sstc,b.ssdj,p.name,b.mzmc,b.jzssbz,b.glbz,b.memo,b.ysdm,CONVERT(DATETIME,GETDATE(),120),1  
      from ZY_BRSYK a (nolock)  
          inner join SS_SSDJK b(nolock) on a.syxh=b.syxh  
       inner join ZY_BRXXK k(nolock) on a.patid=k.patid  
       left join YY_MZDMK d(nolock) on k.mzbm=d.id  
       left join YY_GJDMK e(nolock) on k.gjbm=e.id  
       left join YY_YBFLK f(nolock) on a.ybdm=f.ybdm  
       inner join ZY_BQDMK g(nolock) on b.bqdm=g.id  
       inner join ZY_BCDMK h(nolock) on b.bqdm=h.bqdm and b.cwdm=h.id   
       inner join YY_KSBMK i(nolock) on b.ksdm=i.id  
       inner join YY_KSBMK j(nolock) on b.ssksdm=j.id  
          inner join BQ_LSYZK c(nolock) on a.syxh=c.syxh and c.syxh='+@syxh_1+' and c.yexh = '+@yexh_1+' and c.xh<='+@maxlsyzxh_1+' and c.yzzt=0 and c.yzlb=2   
       inner join #yjm_bq_lsyzk wls on c.xh=wls.xh    
       left join BQ_LSYZK_FZ fz(nolock) on fz.yzxh=c.xh  
       left join YY_DQDMK l(nolock) on k.csd_s=l.id and l.lb=0  
       left join YY_DQDMK m(nolock) on k.csd_djs=m.id and l.lb=1  
       left join YY_DQDMK n(nolock) on k.csd_x=n.id and l.lb=2  
       left join YY_CARDTYPE o(nolock) on a.cardtype=o.id  
       left join SS_SSDJDMK p(nolock) on b.ssdj=p.id  
          where a.syxh='+@syxh_1+'  
          AND b.xh='+@xhtemp_1+' ')  
  
      --手术诊断库  
      exec('insert into '+@config6C58+'dbo.JK_SS_SSZDK (xh,eventtype,OperationOrderNumber,DiagnosisCode,DiagnosisDescription,DiagnosisType,DiagnosisFlag,  
          Memo,Description,createtime,processstatus)  
      --术前诊断  
      select newid(),1,e.xh,e.sqzd,isnull(d.name,""),0  --诊断类别,(0：术前诊断,1：术后诊断,2：病理诊断)  
          ,0 --诊断类型,(0：主诊,1：第一辅诊,2：第二辅诊,3：第三辅诊,4：第四辅诊)  
       ,null,null,CONVERT(DATETIME,GETDATE(),120),1  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh =e.yzxh   
       left join YY_ZDDMK d(nolock) on e.sqzd = d.id   
      where a.syxh='+@syxh_1+' and c.syxh='+@syxh_1+' and c.yexh = '+@yexh_1+' and c.xh<='+@maxlsyzxh_1+' and c.yzzt=0 and c.yzlb=2  
        and isnull(e.sqzd,"") != ""  
      union all  
      --辅助诊断一  
      select newid(),1,e.xh,d.SQZD1,isnull(d.SQZDMC1,""),0,1  
       ,null,null,CONVERT(DATETIME,GETDATE(),120),1  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh =e.yzxh   
       left join V5_SSYZK d(nolock) on c.v5xh = d.YZXH and d.SYXH='+@syxh_1+'  
      where a.syxh='+@syxh_1+' and c.syxh='+@syxh_1+' and c.yexh = '+@yexh_1+' and c.xh<='+@maxlsyzxh_1+' and c.yzzt=0 and c.yzlb=2  
        and isnull(d.SQZD1,"") != ""   
        and not exists (select 1 from SS_SSZDK where ssxh = e.xh and zdlb = 0 and zdlx = 1)  
      union all  
      --辅助诊断二  
      select newid(),1,e.xh,d.SQZD2,isnull(d.SQZDMC2,""),0,2  
       ,null,null,CONVERT(DATETIME,GETDATE(),120),1  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh =e.yzxh   
       left join V5_SSYZK d(nolock) on c.v5xh = d.YZXH and d.SYXH='+@syxh_1+'   
      where a.syxh='+@syxh_1+' and c.syxh='+@syxh_1+' and c.yexh = '+@yexh_1+' and c.xh<='+@maxlsyzxh_1+' and c.yzzt=0 and c.yzlb=2  
        and isnull(d.SQZD2,"") != ""  
        and not exists (select 1 from SS_SSZDK where ssxh = e.xh and zdlb = 0 and zdlx = 2)  
      union all  
      --辅助诊断三  
      select newid(),1,e.xh,d.SQZD3,isnull(d.SQZDMC3,""),0,3  
       ,null,null,CONVERT(DATETIME,GETDATE(),120),1  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh =e.yzxh   
       left join V5_SSYZK d(nolock) on c.v5xh = d.YZXH and d.SYXH='+@syxh_1+'  
      where a.syxh='+@syxh_1+' and c.syxh='+@syxh_1+' and c.yexh = '+@yexh_1+' and c.xh<='+@maxlsyzxh_1+' and c.yzzt=0 and c.yzlb=2  
        and isnull(d.SQZD3,"") != ""  
        and not exists (select 1 from SS_SSZDK where ssxh = e.xh and zdlb = 0 and zdlx = 3) ')  
     end  
    end  ----△△△参数6036 是否使用手术管理系统 为是 且 参数6501，是否使用围手术抗生素控制功能 为否 end  
   end  ----△△参数G090 手术通知单是否审批 为 否  或者 KS20参数>0 使用抗菌素药品管理系统2.0 end  
            else  
            begin ----△△参数G090 手术通知单是否审批 为 是  或者 KS20参数=0 不使用抗菌素药品管理系统2.0 start  
                if (@sfxyzlc=1)  
                begin  
                    update SS_SSDJK set jlzt=0  
                    where yzxh in (select c.xh from ZY_BRSYK a, BQ_LSYZK c,#yjm_bq_lsyzk wls   
         where a.syxh=@syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh<=@maxlsyzxh and c.yzzt=0 and c.yzlb=2 and c.xh=wls.xh  
                           and isnull(c.ssyzzt,0)=2  )  
  
     if @@error<>0  
     begin  
      rollback tran  
      select "F","审核手术医嘱出错！"  
      return  
     end  
                end  
            end ----△△参数G090 手术通知单是否审批 为 是  或者 KS20参数=0 不使用抗菌素药品管理系统2.0 end  
              
  end ----△if LLLLLL end  
  
        if @issh='否' --△参数6293 医嘱审核时，阳性药品是否能审核 为 否 start  
        begin  
            --△△if QQQQ start    
            if exists(select 1 from BQ_LSYZK a(nolock),BQ_BRGMJLK b (nolock),#yjm_bq_lsyzk wls  
    where a.syxh=@syxh and a.yexh = @yexh and a.xh=wls.xh and a.xh<=@maxlsyzxh and a.yzzt=0 and a.syxh=b.syxh and a.gg_idm=b.gg_idm   
    and b.gmlx in (1,6,7) and b.jlzt=0  
    )                     
                    set @shnr = '该病人医嘱存在阳性的过敏药品，造成相应医嘱没有审核通过！'  
             -- △△if QQQQ end   
  
            if @config6480<>'是' --△△参数6480 是否使用医生(EMR医嘱审核)与护士分开审核的机制 为 否 start  
            begin  
    if @config0251='是' or @config6D87='是'  
    begin  
                    insert into #yshyz   
                    select distinct a.xh,0,1  
                    from BQ_LSYZK a inner join #yjm_bq_lsyzk wls on wls.xh=a.xh  
              where a.syxh=@syxh and a.yexh = @yexh and a.xh<=@maxlsyzxh and a.yzzt=0   
      and  not exists (  
                            select 1   
                            from BQ_LSYZK b,BQ_BRGMJLK c  
                            where b.syxh=@syxh and b.yexh = @yexh and b.xh<=@maxcqyzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
                            and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh)  
      and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
               and ( (@sfxyzlc=0) or (a.yzlb<>2) or (isnull(a.ssyzzt,0)=2 ) )  
                        AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
    end  
    update BQ_LSYZK set shrq=@now,  
     shczyh=@czyh,  
     yzzt=1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end  
     ,gxrq=@now  
                from BQ_LSYZK a inner join #yjm_bq_lsyzk wls on wls.xh=a.xh  
          where a.syxh=@syxh and a.yexh = @yexh and a.xh<=@maxlsyzxh and a.yzzt=0   
     and  not exists (  
                        select 1   
                        from BQ_LSYZK b,BQ_BRGMJLK c  
                        where b.syxh=@syxh and b.yexh = @yexh and b.xh<=@maxcqyzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
                        and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh)  
     and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
                    and ( (@sfxyzlc=0) or (a.yzlb<>2) or (isnull(a.ssyzzt,0)=2 ) )  
                    AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
            end --△△参数6480 是否使用医生(EMR医嘱审核)与护士分开审核的机制 为 否 end  
            else  
            begin --△△参数6480 是否使用医生(EMR医嘱审核)与护士分开审核的机制 为 是 start  
    if @emrsybz = 0 --- if @emrsybz = 0 start  
    begin  
     if @config0251='是' or @config6D87='是'  
     begin  
      insert into #yshyz   
      select distinct a.xh,0,1  
      from BQ_LSYZK a inner join #yjm_bq_lsyzk wls on wls.xh=a.xh  
      where a.syxh=@syxh and a.yexh = @yexh and a.xh<=@maxlsyzxh and a.yzzt=0   
       and  not exists (  
        select 1   
        from BQ_LSYZK b,BQ_BRGMJLK c  
        where b.syxh=@syxh and b.yexh = @yexh and b.xh<=@maxcqyzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
        and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh)  
       and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
       and isnull(a.yshdbz,0)=1  
                            and ( (@sfxyzlc=0) or (a.yzlb<>2) or (isnull(a.ssyzzt,0)=2 ) )  
                            AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
     end  
     update BQ_LSYZK set shrq=@now,  
     shczyh=@czyh,  
     yzzt=1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
     ,gxrq=@now  
     from BQ_LSYZK a inner join #yjm_bq_lsyzk wls on wls.xh=a.xh  
     where a.syxh=@syxh and a.yexh = @yexh and a.xh<=@maxlsyzxh and a.yzzt=0   
      and  not exists (  
        select 1   
        from BQ_LSYZK b,BQ_BRGMJLK c  
        where b.syxh=@syxh and b.yexh = @yexh and b.xh<=@maxcqyzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
        and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh)  
       and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
       and isnull(a.yshdbz,0)=1  
                            and ( (@sfxyzlc=0) or (a.yzlb<>2) or (isnull(a.ssyzzt,0)=2 ) )  
                            AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
    end  --- if @emrsybz = 0 end   
    else if @emrsybz = 1   --- if @emrsybz = 1 start  
    begin  
     update BQ_LSYZK set yshdbz = 1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
      ,gxrq=@now  
     from BQ_LSYZK a inner join #yjm_bq_lsyzk wls on wls.xh=a.xh  
     where a.syxh=@syxh and a.yexh = @yexh and a.xh<=@maxlsyzxh and a.yzzt=0   
      and  not exists (  
       select 1   
       from BQ_LSYZK b,BQ_BRGMJLK c  
       where b.syxh=@syxh and b.yexh = @yexh and b.xh<=@maxcqyzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
      and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh )  
      and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
      and isnull(a.yshdbz,0)=0  
     AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
         
    end  --- if @emrsybz = 1 end  
            end --△△参数6480 是否使用医生(EMR医嘱审核)与护士分开审核的机制 为 是 end  
  
        end --△参数6293 医嘱审核时，阳性药品是否能审核 为 否 end  
        else  
        begin  --△参数6293 医嘱审核时，阳性药品是否能审核 为 是 start  
            if @config6480<>'是' --△△参数6480 是否使用医生(EMR医嘱审核)与护士分开审核的机制 为 否 start  
            begin  
    if @config0251='是' or @config6D87='是'  
    begin  
     insert into #yshyz  
     select distinct xh,0,1   
     from BQ_LSYZK a  
     where syxh=@syxh and yexh = @yexh and xh<=@maxlsyzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
      and xh in (select xh from #yjm_bq_lsyzk)  
      and ( (@sfxyzlc=0) or (yzlb<>2) or (isnull(ssyzzt,0)=2 ) )  
      AND ((@config6788=1)OR( xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
    end  
    update BQ_LSYZK set shrq=@now,  
    shczyh=@czyh,  
    yzzt=1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
    ,gxrq=@now  
    from BQ_LSYZK a  
    where syxh=@syxh and yexh = @yexh and xh<=@maxlsyzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
     and xh in (select xh from #yjm_bq_lsyzk)  
                    and ( (@sfxyzlc=0) or (yzlb<>2) or (isnull(ssyzzt,0)=2 ) )  
     AND ((@config6788=1)OR( xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
            end --△△参数6480 是否使用医生(EMR医嘱审核)与护士分开审核的机制 为 否 end  
            else  
            begin --△△参数6480 是否使用医生(EMR医嘱审核)与护士分开审核的机制 为 是 start  
    if @emrsybz = 0 --- if @emrsybz = 0  start  
    begin  
     if @config0251='是' or @config6D87='是'  
     begin   
      insert into #yshyz  
      select distinct xh,0,1   
      from BQ_LSYZK a  
      where syxh=@syxh and yexh = @yexh and xh<=@maxlsyzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
       and isnull(yshdbz,0)=1  
       and xh in (select xh from #yjm_bq_lsyzk)  
       and ( (@sfxyzlc=0) or (yzlb<>2) or (isnull(ssyzzt,0)=2 ) )  
       AND ((@config6788=1)OR( xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
     end  
     update BQ_LSYZK set shrq=@now,  
     shczyh=@czyh,  
     yzzt=1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
     ,gxrq=@now  
     from BQ_LSYZK a  
     where syxh=@syxh and yexh = @yexh and xh<=@maxlsyzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
      and isnull(yshdbz,0)=1  
      and xh in (select xh from #yjm_bq_lsyzk)  
                        and ( (@sfxyzlc=0) or (yzlb<>2) or (isnull(ssyzzt,0)=2 ) )  
                        AND ((@config6788=1)OR( xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
    end --- if @emrsybz = 0  end  
    else if @emrsybz = 1 --- if @emrsybz = 1  start  
    begin  
     update BQ_LSYZK set yshdbz = 1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
     ,gxrq=@now  
     from BQ_LSYZK a  
     where syxh=@syxh and yexh = @yexh and xh<=@maxlsyzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
      and isnull(yshdbz,0)=0  
      and xh in (select xh from #yjm_bq_lsyzk)  
      AND ((@config6788=1)OR( xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
            
    end --- if @emrsybz = 1  end  
            end --△△参数6480 是否使用医生(EMR医嘱审核)与护士分开审核的机制 为 是 end  
  
        end--△参数6293 医嘱审核时，阳性药品是否能审核 为 是 end  
    if @@error<>0  
  begin  
         rollback tran  
      select "F","审核临时医嘱出错！"  
      return  
  end  
/***********************************************临时医嘱写入平台中间表******************************************************/  
  if @config6A71 = '是'  
  begin  
   insert into JK_ZY_ZYYZ (xh,eventtype,patientid,syxh,isstandingorder,orderno,groupno,  
    isprimary,createdby,begintime,audittime,exectime,stoptime,  
    freqcode,execnumber,execfreq,execfequnit,execweek,  
    needskintest,ordertype,needcharge,phacode,phaname,spec,dosage,dosageunit,quantity,  
    quantityunit,ordermemo,ordercontent,usage,memo,isself,execdept,  
    createtime,updatetime,processstatus)  
   select (select NEWID()),1,(select patid from ZY_BRSYK where syxh = a.syxh),syxh,2,xh,fzxh,  
    null,ysdm,SUBSTRING(ksrq,1,8) + ' ' + SUBSTRING(ksrq,9,8), SUBSTRING(shrq,1,8) + ' ' + SUBSTRING(shrq,9,8),  
    SUBSTRING(zxrq,1,8) + ' ' + SUBSTRING(zxrq,9,8),SUBSTRING(tzrq,1,8) + ' ' + SUBSTRING(tzrq,9,8),  
    pcdm,(select zxcs from ZY_YZPCK where id = a.pcdm),(select zxzq from ZY_YZPCK where id = a.pcdm),  
    (select zxzqdw from ZY_YZPCK where id = a.pcdm),(select zbz from ZY_YZPCK where id = a.pcdm),  
    psbz,yzlb,1,ypdm,ypmc,ypgg,ypjl,jldw,ypsl,zxdw,ztnr,yznr,ypyf,memo,case zbybz when 1 then 1 else 0 end,zxksdm,  
    GETDATE(),null,1  
   from BQ_LSYZK a  
   where a.syxh=@syxh and xh in (select xh from #sh_yzxh_ls) and a.yzlb in (0,1,3,4,5,8,12)  
   if @@error<>0  
   begin  
    rollback tran  
    select "F","写入平台中间表JK_ZY_ZYYZ出错！"  
    return  
   end  
  end  
/*****************************************************************************************************/     
  select @shyzcount = @shyzcount + @@rowcount  
 end --▲▲审核全部或审核临时 @yzbz 医嘱类别(0:临时, -1:全部) end  
   
 if (@yzbz = 1) or (@yzbz = -1) --▲▲审核长期或全部 @yzbz 医嘱类别(1:长期, -1:全部) start  
 begin  
        if @issh='否'  --△参数6293 医嘱审核时，阳性药品是否能审核 为 否 start  
        begin  
            ---△△if QQQQQ start  
            if exists(select 1 from BQ_CQYZK a(nolock),BQ_BRGMJLK b (nolock),#yjm_bq_cqyzk wcq  
    where a.syxh=@syxh and a.yexh = @yexh and a.xh<=@maxcqyzxh and a.yzzt=0 and a.xh=wcq.xh   
  and a.syxh=b.syxh and a.gg_idm=b.gg_idm and b.gmlx in (1,6,7) and b.jlzt=0  
    )  
                    set @shnr = '该病人医嘱存在阳性的过敏药品，造成相应医嘱没有审核通过！'  
            ---△△if QQQQQ end  
                      
            if @config6480<>'是' --△△参数6480 是否使用医生(EMR医嘱审核)与护士分开审核的机制 为 否 start  
            begin  
    if @config0251='是' or @config6D87='是'  
    begin  
     insert into #yshyz  
     select distinct a.xh,1,1  
     from BQ_CQYZK a inner join #yjm_bq_cqyzk wcq on wcq.xh=a.xh  
     where a.syxh=@syxh and a.yexh = @yexh and a.xh<=@maxcqyzxh and a.yzzt=0   
      and   not exists (  
        select 1   
        from BQ_CQYZK b,BQ_BRGMJLK c  
        where b.syxh=@syxh and b.yexh = @yexh and b.xh<=@maxcqyzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
        and c.gmlx in (1,6,7) and c.jlzt=0  and a.fzxh=b.fzxh)  
      and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
      AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
    end  
    --select zxksdm, * from BQ_CQYZK  
    update BQ_CQYZK set shrq=@now,  
     shczyh=@czyh,  
     yzzt=1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
     ,gxrq=@now  
     ,ksrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
       convert(char(8),dateadd(day,1,substring(substring(ksrq,1,8),1,8)),112) +'00:01:00'  
       else ksrq end  
     ,yzxrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
       convert(char(8),dateadd(day,1,substring(substring(yzxrq,1,8),1,8)),112)   
       else yzxrq end  
     ,zxrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
       convert(char(8),dateadd(day,1,substring(substring(zxrq,1,8),1,8)),112)   
       else zxrq end  
    from BQ_CQYZK a inner join #yjm_bq_cqyzk wcq on wcq.xh=a.xh  
    where a.syxh=@syxh and a.yexh = @yexh and a.xh<=@maxcqyzxh and a.yzzt=0   
     and   not exists (  
       select 1   
       from BQ_CQYZK b,BQ_BRGMJLK c  
       where b.syxh=@syxh and b.yexh = @yexh and b.xh<=@maxcqyzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
       and c.gmlx in (1,6,7) and c.jlzt=0  and a.fzxh=b.fzxh)  
     and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
     AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
            end --△△参数6480 是否使用医生(EMR医嘱审核)与护士分开审核的机制 为 否 end  
            else  
            begin --△△参数6480 是否使用医生(EMR医嘱审核)与护士分开审核的机制 为 是 start  
    if @emrsybz = 0  --- if @emrsybz = 0 start  
    begin  
     if @config0251='是' or @config6D87='是'  
     begin  
      insert into #yshyz  
      select distinct a.xh,1,1  
      from BQ_CQYZK a inner join #yjm_bq_cqyzk wcq on wcq.xh=a.xh  
      where a.syxh=@syxh and a.yexh = @yexh and a.xh<=@maxcqyzxh and a.yzzt=0   
       and  not exists (  
        select 1   
        from BQ_CQYZK b,BQ_BRGMJLK c  
        where b.syxh=@syxh and b.yexh = @yexh and b.xh<=@maxcqyzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
        and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh)  
       and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
       and isnull(a.yshdbz,0)=1  
       AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
     end  
     update BQ_CQYZK set shrq=@now,  
     shczyh=@czyh,  
     yzzt=1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
     ,gxrq=@now  
     ,ksrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
       convert(char(8),dateadd(day,1,substring(substring(ksrq,1,8),1,8)),112) +'00:01:00'  
       else ksrq end  
     ,yzxrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
       convert(char(8),dateadd(day,1,substring(substring(yzxrq,1,8),1,8)),112)   
       else yzxrq end  
     ,zxrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
       convert(char(8),dateadd(day,1,substring(substring(zxrq,1,8),1,8)),112)   
       else zxrq end  
     from BQ_CQYZK a inner join #yjm_bq_cqyzk wcq on wcq.xh=a.xh  
     where a.syxh=@syxh and a.yexh = @yexh and a.xh<=@maxcqyzxh and a.yzzt=0   
      and  not exists (  
       select 1   
       from BQ_CQYZK b,BQ_BRGMJLK c  
       where b.syxh=@syxh and b.yexh = @yexh and b.xh<=@maxcqyzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
       and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh)  
      and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
      and isnull(a.yshdbz,0)=1  
      AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
    end  --- if @emrsybz = 0 end  
    else if @emrsybz = 1   --- if @emrsybz = 1 start  
    begin  
     update BQ_CQYZK set yshdbz = 1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
     ,gxrq=@now  
     from BQ_CQYZK a inner join #yjm_bq_cqyzk wcq on wcq.xh=a.xh  
     where a.syxh=@syxh and a.yexh = @yexh and a.xh<=@maxcqyzxh and a.yzzt=0   
      and  not exists (  
        select 1   
        from BQ_CQYZK b,BQ_BRGMJLK c  
        where b.syxh=@syxh and b.yexh = @yexh and b.xh<=@maxcqyzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
        and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh )  
      and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
      and isnull(a.yshdbz,0)=0  
      AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
    end --- if @emrsybz = 1 end  
            end --△△参数6480 是否使用医生(EMR医嘱审核)与护士分开审核的机制 为 是 end  
        end  --△参数6293 医嘱审核时，阳性药品是否能审核 为 否 end  
        else  
        begin  --△参数6293 医嘱审核时，阳性药品是否能审核 为 是 start  
            if @config6480<>'是' --△△参数6480 是否使用医生(EMR医嘱审核)与护士分开审核的机制 为 否 start  
            begin  
    if @config0251='是' or @config6D87='是'  
    begin   
     insert into #yshyz  
     select distinct a.xh,1,1  
     from BQ_CQYZK a inner join #yjm_bq_cqyzk wcq on wcq.xh=a.xh  
        where a.syxh=@syxh and a.yexh = @yexh and a.xh<=@maxcqyzxh and a.yzzt=0   
      and  not exists (  
       select 1   
       from BQ_CQYZK b,BQ_BRGMJLK c  
       where b.syxh=@syxh and b.yexh = @yexh and b.xh<=@maxcqyzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
       and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh )  
      and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
      and isnull(a.yshdbz,0)=0  
      AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
    end  
    update BQ_CQYZK set shrq=@now,  
    shczyh=@czyh,  
    yzzt=1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
    ,gxrq=@now  
    ,ksrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
     convert(char(8),dateadd(day,1,substring(substring(ksrq,1,8),1,8)),112) +'00:01:00'  
     else ksrq end  
    ,yzxrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
     convert(char(8),dateadd(day,1,substring(substring(yzxrq,1,8),1,8)),112)   
     else yzxrq end  
    ,zxrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then       
     convert(char(8),dateadd(day,1,substring(substring(zxrq,1,8),1,8)),112)   
     else zxrq end  
    from BQ_CQYZK a  
    where syxh=@syxh  and yexh = @yexh and xh<=@maxcqyzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
     and xh in (select xh from #yjm_bq_cqyzk)  
    AND ((@config6788=1)OR( xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
            end --△△参数6480 是否使用医生(EMR医嘱审核)与护士分开审核的机制 为 否 end  
            else  
            begin --△△参数6480 是否使用医生(EMR医嘱审核)与护士分开审核的机制 为 是 start  
    if @emrsybz = 0 --- if @emrsybz = 0 start  
    begin  
     if @config0251='是' or @config6D87='是'  
     begin  
      insert into #yshyz  
      select distinct xh,1,1  
      from BQ_CQYZK a  
      where syxh=@syxh  and yexh = @yexh and xh<=@maxcqyzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
       and isnull(yshdbz,0)=1  
       and xh in (select xh from #yjm_bq_cqyzk)  
       AND ((@config6788=1)OR(xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
     end  
     update BQ_CQYZK set shrq=@now,  
     shczyh=@czyh,  
     yzzt=1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
     ,gxrq=@now  
     ,ksrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
       convert(char(8),dateadd(day,1,substring(substring(ksrq,1,8),1,8)),112) +'00:01:00'  
       else ksrq end  
     ,yzxrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
       convert(char(8),dateadd(day,1,substring(substring(yzxrq,1,8),1,8)),112)   
       else yzxrq end  
     ,zxrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
       convert(char(8),dateadd(day,1,substring(substring(zxrq,1,8),1,8)),112)   
       else zxrq end  
     from BQ_CQYZK a  
     where syxh=@syxh  and yexh = @yexh and xh<=@maxcqyzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
      and isnull(yshdbz,0)=1  
      and xh in (select xh from #yjm_bq_cqyzk)  
      AND ((@config6788=1)OR(xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
    end --- if @emrsybz = 0 end  
    else if @emrsybz = 1 ---- if @emrsybz = 1 start  
    begin  
     update BQ_CQYZK set yshdbz = 1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
     ,gxrq=@now  
     from BQ_CQYZK a  
     where syxh=@syxh  and yexh = @yexh and xh<=@maxcqyzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
      and isnull(yshdbz,0)=0  
      and xh in (select xh from #yjm_bq_cqyzk)  
     AND ((@config6788=1)OR(xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
    end ---- if @emrsybz = 1 end  
            end --△△参数6480 是否使用医生(EMR医嘱审核)与护士分开审核的机制 为 是 end  
        end --△参数6293 医嘱审核时，阳性药品是否能审核 为 是 end  
  if @@error<>0  
  begin  
   rollback tran  
   select "F","审核长期医嘱出错！"  
   return  
  end  
    
/***********************************************长期医嘱插入平台中间表******************************************************/  
  if @config6A71= '是'  
  begin  
   insert into JK_ZY_ZYYZ (xh,eventtype,patientid,syxh,isstandingorder,orderno,groupno,  
    isprimary,createdby,begintime,audittime,exectime,stoptime,  
    freqcode,execnumber,execfreq,execfequnit,execweek,  
    needskintest,ordertype,needcharge,phacode,phaname,spec,dosage,dosageunit,quantity,  
    quantityunit,ordermemo,ordercontent,usage,memo,isself,execdept,  
    createtime,updatetime,processstatus)  
   select (select NEWID()),1,(select patid from ZY_BRSYK where syxh = a.syxh),syxh,1,xh,fzxh,  
    null,ysdm,SUBSTRING(ksrq,1,8) + ' ' + SUBSTRING(ksrq,9,8), SUBSTRING(shrq,1,8) + ' ' + SUBSTRING(shrq,9,8),  
    SUBSTRING(zxrq,1,8) + ' ' + SUBSTRING(zxrq,9,8),SUBSTRING(tzrq,1,8) + ' ' + SUBSTRING(tzrq,9,8),  
    pcdm,(select zxcs from ZY_YZPCK where id = a.pcdm),(select zxzq from ZY_YZPCK where id = a.pcdm),  
    (select zxzqdw from ZY_YZPCK where id = a.pcdm),(select zbz from ZY_YZPCK where id = a.pcdm),  
    0,yzlb,1,ypdm,ypmc,ypgg,ypjl,jldw,ypsl,zxdw,ztnr,yznr,ypyf,memo,case zbybz when 1 then 1 else 0 end,zxksdm,  
    GETDATE(),null,1  
   from BQ_CQYZK a  
   where a.syxh=@syxh and xh in (select xh from #sh_yzxh_cq) and a.yzlb in (0,1,3,4,5,8,14,15)   
   if @@error<>0  
   begin  
    rollback tran  
    select "F","写入平台中间表JK_ZY_ZYYZ出错！"  
    return  
   end  
  end       
/*****************************************************************************************************/      
  select @shyzcount =@shyzcount + @@rowcount  
 end --▲▲审核长期或全部 @yzbz 医嘱类别(1:长期, -1:全部) end  
           
        --▲▲停止医嘱 开始  
 if exists(select 1 from BQ_LSYZK a(nolock) inner join #yjm_bq_lsyzk wls on wls.xh=a.xh where a.syxh=@syxh and a.yexh = @yexh and a.yzzt=1 and a.yzlb=9)  
 begin -- if TTTTTTTT1  start   
  declare cs_tzyz cursor for   
--  select distinct b.fzxh, a.tzrq, a.ysdm from BQ_LSYZK a, BQ_CQYZK b   
  select distinct b.fzxh, a.tzrq, a.lrczyh,b.yzlb,a.ypmc from BQ_LSYZK a(nolock), BQ_CQYZK b(nolock),#yjm_bq_lsyzk wls,#yjm_bq_cqyzk wcq   --谁停止医嘱，医嘱停止者显示谁,不再显示停止医嘱的审核者  
  where a.syxh=@syxh and a.yzzt=1 and a.yzlb=9 and b.syxh=@syxh and b.xh=a.tzxh and a.xh=wls.xh and b.xh=wcq.xh  
  for read only  
  
  open cs_tzyz  
  fetch cs_tzyz into @tzxh,@tzrq,@ysdm,@yzlb,@yznr  
  while @@fetch_status=0 ---游标 cs_tzyz while Start  
  begin  
   select @tzyy=0    
   if SUBSTRING(@yznr,1,3)='术停*'    
    select @tzyy=1    
   else if SUBSTRING(@yznr,1,3)='产停*'    
    select @tzyy=4    
   else if SUBSTRING(@yznr,1,3)='化停*'    
    select @tzyy=5  
   --add by hhy 如果是术后停医嘱，这条医嘱的停止医生，应该是开术后医嘱的医生，而不是原来录入医嘱的医生   
   --并且这条术后文字医嘱的shczy，应该改成当前操作员  
   if @tzyy = 1  
   begin  
    select @ysdm = a.lrczyh from BQ_CQYZK a(nolock) inner join #yjm_bq_cqyzk wcq on wcq.xh=a.xh where a.syxh = @syxh and a.fzxh > @tzxh and a.yzzt = 2 and a.yzlb = 14   
    if exists(select 1 from BQ_CQYZK a(nolock) inner join #yjm_bq_cqyzk wcq on wcq.xh=a.xh where a.syxh = @syxh and a.fzxh > @tzxh and a.yzzt = 2 and a.yzlb = 14 and ltrim(rtrim(a.shczyh)) = "" )  
    update BQ_CQYZK set shczyh = @czyh where syxh = @syxh and fzxh > @tzxh and yzzt = 2 and yzlb = 14 and xh in (select xh from #yjm_bq_cqyzk)  
    if @@ERROR <> 0  
    begin  
     rollback tran  
     deallocate cs_   
     select "F","更新术后医嘱状态出错"  
     return  
    end  
   end   
   
     --add by kongwei 记录审核时传入的tzrq  
   insert into BQ_TZRQLOG(cqfzxh,syxh,lstzxh,lstzrq,czyh) values  
   (@tzxh,@syxh,@tzxh,@tzrq,@czyh)  
   
   -- add by hhy end  
   exec usp_bq_tzyz @syxh,@czyh,@tzrq,@ysdm,@tzyy,@errmsg output,1,@tzxh, 0, @yexh  
   if @errmsg like "F%"  
   begin  
    rollback tran  
    deallocate cs_tzyz  
    select "F",substring(@errmsg,2,49)  
    return  
   end  
   if (@yzlb IN(14,15)) and (@configG435='否')  --zzk  
   begin    
    if exists(select 1 from BQ_CQYZK a(nolock) inner join #yjm_bq_cqyzk wcq on wcq.xh=a.xh where a.syxh=@syxh and a.fzxh=@tzxh and a.yzzt<3)   
    begin   
          
     if @config0251='是' or @config6D87='是'--医嘱闭环状态更新  
     begin  
      insert into #yshyz   
      select distinct xh,1,4  
      from BQ_CQYZK   
      where syxh=@syxh and fzxh=@tzxh and yzzt<3 and xh in (select xh from #yjm_bq_cqyzk)   
     end    
     update BQ_CQYZK set yzzt=4 where syxh=@syxh and fzxh=@tzxh and yzzt<3 and xh in (select xh from #yjm_bq_cqyzk)   
       end   
   end   
   fetch cs_tzyz into @tzxh,@tzrq,@ysdm,@yzlb,@yznr  
  end ---游标 cs_tzyz while end  
  close cs_tzyz  
  deallocate cs_tzyz  
  if @config0251='是' or @config6D87='是'--医嘱闭环状态更新  
  begin  
   insert into #yshyz   
   select distinct xh,0,2  
  from BQ_LSYZK   
   where syxh=@syxh and yexh = @yexh and yzzt=1 and yzlb=9 and xh in (select xh from #yjm_bq_lsyzk)  
   if @@error<>0  
   begin  
    rollback tran  
    select "F","审核停止医嘱出错！"  
    return  
   end  
  end    
  update BQ_LSYZK set zxrq=@now,  
   zxczyh=@czyh,  
   yzzt=2,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
   ,gxrq=@now  
  where syxh=@syxh and yexh = @yexh and yzzt=1 and yzlb=9 and xh in (select xh from #yjm_bq_lsyzk)  
  if @@error<>0  
  begin  
   rollback tran  
   select "F","审核停止医嘱出错！"  
   return  
  end  
 end -- if TTTTTTTT1  end  
 --▲▲停止医嘱 结束  
end  ---=======================▲审核类别 0=全部医嘱  end=====================================  
else   
begin  ---=======================▲审核类别 1=单条医嘱  start=====================================  
 if @yzbz=0 ----▲▲审核医嘱类别 @yzbz (0:临时) start  
 begin  
        --add by hhy 2014.04.17 for 198733  出院带药前面审核过了，这里直接返回就行  
     if exists(select 1 from BQ_LSYZK a(nolock) inner join #yjm_bq_lsyzk wls on wls.xh=a.xh where a.xh = @fzxh and a.yzlb = 12)  
  begin  
   ---------医嘱闭环开始-------------------------------------------------------------------------  
    declare cs_yzsh_bh_ls cursor for  --第二步  
   select distinct b.syxh,a.yzxh,case isnull(@dqksdm,'') when '' then b.ksdm else @dqksdm end,  
    b.bqdm,b.shczyh,a.yzzt    
   from BQ_LSYZK b (nolock)   inner join  #yshyz a(nolock) on a.yzxh=b.xh   
   where a.cqlsbz=0 and b.yzlb<>9   
   order by a.yzxh,a.yzzt  
   open cs_yzsh_bh_ls   
   fetch cs_yzsh_bh_ls into @yzbh_syxh,@yzbh_yzxh,@yzbh_zxks,@yzbh_bqdm,@shr,@yzzt  
   while @@fetch_status=0 ---游标 cs_cydy_yzsh while Start  
   begin  
    select @yzbh_pcsj=''   
    select @yzbh_cqlsbz=0     
    if @yzzt=1   
    begin  
     select @yzbh_xtbz=6  
    end  
    else if @yzzt=2  
    begin  
     select @yzbh_xtbz=7  
    end  
      --========◆◆◆医嘱闭环 调用1 临时◆◆◆===========   
    exec usp_bq_yzbh_dy @yzbh_syxh,@yzbh_yzxh,@yzbh_cqlsbz,@yzbh_zxks,@yzbh_bqdm,  
     @shr,'',@yzbh_pcsj,@yzbh_xtbz,0,@errmsg output  
    if @errmsg like 'F%'  
    begin  
     rollback TRAN  
     deallocate cs_yzsh_bh_ls     
     select "F",substring(@errmsg,2,49)  
     return    
    end  
    fetch cs_yzsh_bh_ls into @yzbh_syxh,@yzbh_yzxh,@yzbh_zxks,@yzbh_bqdm,@shr,@yzzt  
   end   
   close cs_yzsh_bh_ls  
   deallocate cs_yzsh_bh_ls     
   declare cs_yzsh_bh_cq cursor for  
   select distinct b.syxh,a.yzxh,case isnull(@dqksdm,'') when '' then b.ksdm else @dqksdm end,  
    b.bqdm,b.shczyh,a.yzzt    
   from BQ_CQYZK b (nolock) inner join  #yshyz a(nolock) on a.yzxh=b.xh   
   where a.cqlsbz=1   
   order by a.yzxh,a.yzzt  
   open cs_yzsh_bh_cq   
   fetch cs_yzsh_bh_cq into @yzbh_syxh,@yzbh_yzxh,@yzbh_zxks,@yzbh_bqdm,@shr,@yzzt   
   while @@fetch_status=0 ---游标 cs_cydy_yzsh while Start  
   begin  
    select @yzbh_pcsj=''   
    select @yzbh_cqlsbz=1  
    if @yzzt=1   
    begin  
     select @yzbh_xtbz=6  
    end  
    else if @yzzt=2  
    begin  
     select @yzbh_xtbz=7  
    end  
    else if @yzzt=4  --停止审核  
    begin  
     select @yzbh_xtbz=10  
    end  
      --========◆◆◆医嘱闭环 调用2 长期 ◆◆◆===========      
    exec usp_bq_yzbh_dy @yzbh_syxh,@yzbh_yzxh,@yzbh_cqlsbz,@yzbh_zxks,@yzbh_bqdm,  
         @shr,'',@yzbh_pcsj,@yzbh_xtbz,0,@errmsg output  
    if @errmsg like 'F%'  
    begin  
      rollback tran   
      deallocate cs_yzsh_bh_cq    
      select "F",substring(@errmsg,2,49)  
      return    
    end  
    fetch cs_yzsh_bh_cq into @yzbh_syxh,@yzbh_yzxh,@yzbh_zxks,@yzbh_bqdm,@shr,@yzzt  
   end   
   close cs_yzsh_bh_cq  
   deallocate cs_yzsh_bh_cq   
   ---------------医嘱闭环结束----------------------------------------------------------------------------------   
            commit tran  
     
   select "T",@shnr  
   return        
        end        
  if (select config from  YY_CONFIG (nolock) where id = 'Y002')='是' ----参数Y002 (福建)是否需要医嘱审批 为 是 start  
  begin  
   --将已用的审批记录更新为已用  
   update YY_BRSPXMK  
   set yyspsl = b.ypsl  , spbz = 2  
   from YY_BRSPXMK a, BQ_LSYZK b,#yjm_bq_lsyzk wls  
   where a.syxh = @syxh  
   and a.syxh = b.syxh  
   and b.xh=wls.xh  
   and a.idm = b.idm  
   and a.ypdm = b.ypdm  
   and a.spbz = 1  
   and b.xh=@fzxh and b.yzzt=0  
   and charindex( ','+convert(varchar(100),b.fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
  end ----参数Y002 (福建)是否需要医嘱审批 为 是 end  
  if @@error<>0  
  begin  
   rollback tran  
   select "F","更新审批信息失败！"  
   return  
  end  
  
  --将已用的职称审批记录更新为已用  
  if exists (select 1 from BQ_BRXZYYSQK(nolock) where syxh = @syxh and spbz = 1)  
  begin  
   --将已用的审批记录更新为已用  
   update BQ_BRXZYYSQK  
   set spbz = 2  
   from BQ_BRXZYYSQK a, BQ_CQYZK b,#yjm_bq_cqyzk wcq  
   where a.syxh = @syxh  
   and a.syxh = b.syxh  
   and b.xh=wcq.xh  
   and a.idm = b.idm  
   and a.ypdm = b.ypdm  
   and a.spbz = 1  
   and b.xh=@fzxh and b.yzzt=0  
   and a.sqry = b.ysdm  
   and charindex( ','+convert(varchar(100),b.fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
  end  
  if @@error<>0  
  begin  
   rollback tran  
   select "F","更新职称审批信息失败！"  
   return  
  end  
       
  select @yzlb=yzlb,  
--   @ysdm=ysdm,  
   @ysdm=lrczyh,  --谁停止医嘱，医嘱停止者显示谁,不再显示停止医嘱的审核者  
   @tzxh=tzxh,  
   @tzrq=tzrq,  
   @ksrq=ksrq,  
   @ypdm=ypdm,  
   @mzdm=mzdm,  
   @ypmc=ypmc,  
   @zxksdm=zxksdm,  
   @ztnr=convert(varchar(24),ztnr),  
   @yznr = ypmc  
  from BQ_LSYZK   
  where syxh=@syxh and yexh = @yexh and xh=@fzxh and yzzt in (0,3) and xh in (select xh from #yjm_bq_lsyzk)  
  if @@rowcount=0 or @@error<>0  
  begin  
   rollback tran  
   select "F","审核临时医嘱出错！"  
   return  
  end  
  
        if @issh='否' --△参数6293 医嘱审核时，阳性药品是否能审核 为 否 start  
        begin  
            --△△if QQQQ start  
            if exists(select 1 from BQ_LSYZK a(nolock),BQ_BRGMJLK b (nolock),#yjm_bq_lsyzk wls  
                where a.syxh=@syxh and a.yexh = @yexh and a.fzxh=@fzxh and a.yzzt=0 and a.xh=wls.xh and a.syxh=b.syxh and a.gg_idm=b.gg_idm   
    and b.gmlx in (1,6,7) and b.jlzt=0)  
                    set @shnr = '该病人医嘱存在阳性的过敏药品，造成相应医嘱没有审核通过！'  
            -- △△if QQQQ end  
  
            if @config6480<>'是' --△△参数6480 是否使用医生(EMR医嘱审核)与护士分开审核的机制 为 否 start  
            begin  
    if @config0251='是' or @config6D87='是'  
    begin  
     insert into #yshyz  
     select distinct a.xh,0,1  
     from BQ_LSYZK a inner join #yjm_bq_lsyzk wls on wls.xh=a.xh  
        where a.syxh=@syxh and a.yexh = @yexh and a.fzxh=@fzxh and a.yzzt=0   
      and  not exists (  
       select 1   
       from BQ_LSYZK b,BQ_BRGMJLK c  
       where b.syxh=@syxh and b.yexh = @yexh and b.fzxh=@fzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
       and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh )  
      and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
      and ( (@sfxyzlc=0) or (a.yzlb<>2) or (isnull(a.ssyzzt,0)=2 ) )  
      AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))       
    end  
    update BQ_LSYZK set shrq=@now,  
     shczyh=@czyh,  
     yzzt=1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end  
     ,gxrq=@now  
    from BQ_LSYZK a inner join #yjm_bq_lsyzk wls on wls.xh=a.xh  
    where a.syxh=@syxh and a.yexh = @yexh and a.fzxh=@fzxh and a.yzzt=0   
     and  not exists (  
      select 1   
      from BQ_LSYZK b,BQ_BRGMJLK c  
      where b.syxh=@syxh and b.yexh = @yexh and b.fzxh=@fzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
      and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh )  
     and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
                    and ( (@sfxyzlc=0) or (a.yzlb<>2) or (isnull(a.ssyzzt,0)=2 ) )  
                    AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
            end --△△参数6480 是否使用医生(EMR医嘱审核)与护士分开审核的机制 为 否 end  
            else  
            begin --△△参数6480 是否使用医生(EMR医嘱审核)与护士分开审核的机制 为 是 start  
    if @emrsybz = 0 -- if if @emrsybz = 0 start  
    begin  
     if @config0251='是' or @config6D87='是'  
     begin  
      insert into #yshyz  
      select distinct a.xh,0,1  
      from BQ_LSYZK a inner join #yjm_bq_lsyzk wls on wls.xh=a.xh  
      where a.syxh=@syxh and a.yexh = @yexh and a.fzxh=@fzxh and a.yzzt=0 and  not exists (  
       select 1   
       from BQ_LSYZK b,BQ_BRGMJLK c  
       where b.syxh=@syxh and b.yexh = @yexh and b.fzxh=@fzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
       and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh)  
       and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
      and isnull(a.yshdbz,0)=1 and ( (@sfxyzlc=0) or (a.yzlb<>2) or (isnull(a.ssyzzt,0)=2 ) )  
      AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
     end  
     update BQ_LSYZK set shrq=@now,  
     shczyh=@czyh,  
     yzzt=1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
     ,gxrq=@now  
     from BQ_LSYZK a inner join #yjm_bq_lsyzk wls on wls.xh=a.xh  
     where a.syxh=@syxh and a.yexh = @yexh and a.fzxh=@fzxh and a.yzzt=1   
      and  not exists (  
        select 1   
        from BQ_LSYZK b,BQ_BRGMJLK c  
        where b.syxh=@syxh and b.yexh = @yexh and b.fzxh=@fzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
        and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh)  
      and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
      and isnull(a.yshdbz,0)=1 and ( (@sfxyzlc=0) or (a.yzlb<>2) or (isnull(a.ssyzzt,0)=2 ) )  
      AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
    end -- if if @emrsybz = 0 end  
    else if @emrsybz = 1 ---- if if @emrsybz = 1 start  
    begin  
     update BQ_LSYZK set yshdbz = 1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
     ,gxrq=@now  
     from BQ_LSYZK a inner join #yjm_bq_lsyzk wls on wls.xh=a.xh  
     where a.syxh=@syxh and a.yexh = @yexh and a.fzxh=@fzxh and a.yzzt=0   
      and  not exists (  
        select 1   
        from BQ_LSYZK b,BQ_BRGMJLK c  
        where b.syxh=@syxh and b.yexh = @yexh and b.fzxh=@fzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
        and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh)  
      and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @LSfzxh+ ',' )<=0 and isnull(a.yshdbz,0)=0  
      AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
    end -- if if @emrsybz = 1 end  
            end --△△参数6480 是否使用医生(EMR医嘱审核)与护士分开审核的机制 为 是 end  
        end --△参数6293 医嘱审核时，阳性药品是否能审核 为 否 end  
        else  
        begin --△参数6293 医嘱审核时，阳性药品是否能审核 为 是 start  
            if @config6480<>'是' ----△△参数6480 是否使用医生(EMR医嘱审核)与护士分开审核的机制 为 否 start  
            begin  
                if @config0251='是' or @config6D87='是'  
                begin  
                 insert into #yshyz  
                    select  distinct  xh,0,1   
                    from BQ_LSYZK a  
                    where syxh=@syxh and yexh = @yexh and fzxh=@fzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
      and xh in (select xh from #yjm_bq_lsyzk)  
                        and ( (@sfxyzlc=0) or (yzlb<>2) or (isnull(ssyzzt,0)=2 ) )  
                    AND ((@config6788=1)OR(xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
                end  
    update BQ_LSYZK set shrq=@now,  
    shczyh=@czyh,  
    yzzt=1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end  
    ,gxrq=@now  
    from BQ_LSYZK a  
    where syxh=@syxh and yexh = @yexh and fzxh=@fzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
     and xh in (select xh from #yjm_bq_lsyzk)  
                    and ( (@sfxyzlc=0) or (yzlb<>2) or (isnull(ssyzzt,0)=2 ) )  
     AND ((@config6788=1)OR(xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))         
            end ----△△参数6480 是否使用医生(EMR医嘱审核)与护士分开审核的机制 为 否 end  
            else  
            begin ----△△参数6480 是否使用医生(EMR医嘱审核)与护士分开审核的机制 为 是 start  
    if @emrsybz = 0 ----if @emrsybz = 0  start   
    begin  
     if @config0251='是' or @config6D87='是'  
     begin  
      insert into #yshyz  
      select  distinct  xh,0,1   
      from BQ_LSYZK a  
      where syxh=@syxh and yexh = @yexh and fzxh=@fzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
      and isnull(yshdbz,0)=1  
      and xh in (select xh from #yjm_bq_lsyzk)  
                        and ( (@sfxyzlc=0) or (yzlb<>2) or (isnull(ssyzzt,0)=2 ) )  
                        AND ((@config6788=1)OR(xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
     end  
     update BQ_LSYZK set shrq=@now,  
     shczyh=@czyh,  
     yzzt=1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
     ,gxrq=@now  
     from BQ_LSYZK a  
     where syxh=@syxh and yexh = @yexh and fzxh=@fzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
      and isnull(yshdbz,0)=1  
      and xh in (select xh from #yjm_bq_lsyzk)  
                        and ( (@sfxyzlc=0) or (yzlb<>2) or (isnull(ssyzzt,0)=2 ) )  
                        AND ((@config6788=1)OR(xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
    end  ----if @emrsybz = 0  end   
    else if @emrsybz = 1   ----if @emrsybz = 1  start   
    begin  
     update BQ_LSYZK set yshdbz = 1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
     ,gxrq=@now  
     from BQ_LSYZK a  
     where syxh=@syxh and yexh = @yexh and fzxh=@fzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
      and isnull(yshdbz,0)=0  
      and xh in (select xh from #yjm_bq_lsyzk)  
      AND ((@config6788=1)OR(xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
    end  ----if @emrsybz = 1  end          
            end ----△△参数6480 是否使用医生(EMR医嘱审核)与护士分开审核的机制 为 是 start  
        end --△参数6293 医嘱审核时，阳性药品是否能审核 为 是 end  
    if @@error<>0  
  begin  
         rollback tran  
      select "F","审核临时医嘱出错！"  
      return  
  END  
     
  select @shyzcount = @shyzcount + @@rowcount  
                  
  if @yzlb=9 --△停止医嘱 开始  
  BEGIN  
      select @tzxh = fzxh  
      from BQ_CQYZK(nolock) where xh=@tzxh --and xh in (select xh from #yjm_bq_cqyzk)       
      if @@rowcount=0 or @@error<>0  
      begin  
       rollback tran  
       select "F","审核临时医嘱出错！"  
       return  
      end  
      select @tzyy=0    
   if SUBSTRING(@yznr,1,3)='术停*'    
    select @tzyy=1    
   else if SUBSTRING(@yznr,1,3)='产停*'    
    select @tzyy=4    
   else if SUBSTRING(@yznr,1,3)='化停*'    
    select @tzyy=5  
   --add by hhy 如果是术后停医嘱，这条医嘱的停止医生，应该是开术后医嘱的医生，而不是原来录入医嘱的医生   
   --并且这条术后文字医嘱的shczy，应该改成当前操作员  
   if @tzyy = 1  
   begin  
    select @ysdm = a.lrczyh from BQ_CQYZK a(nolock) inner join #yjm_bq_cqyzk wcq on wcq.xh=a.xh where a.syxh = @syxh and a.fzxh > @tzxh and a.yzzt = 2 and a.yzlb = 14   
    if exists(select 1 from BQ_CQYZK a(nolock) inner join #yjm_bq_cqyzk wcq on wcq.xh=a.xh where a.syxh = @syxh and a.fzxh > @tzxh and a.yzzt = 2 and a.yzlb = 14 and ltrim(rtrim(a.shczyh)) = "")  
     update BQ_CQYZK set shczyh = @czyh where syxh = @syxh and fzxh > @tzxh and yzzt = 2 and yzlb = 14 and xh in (select xh from #yjm_bq_cqyzk)  
    if @@ERROR <> 0  
    begin  
     rollback tran  
     deallocate cs_tzyz  
     select "F","更新术后医嘱状态出错"  
     return  
    end  
   end  
   
      --add by kongwei 记录审核时传入的tzrq  
   insert into BQ_TZRQLOG(cqfzxh,syxh,lstzxh,lstzrq,czyh) values  
   (@tzxh,@syxh,@tzxh,@tzrq,@czyh)  
   
   -- add by hhy end  
   --exec usp_bq_tzyz @syxh,@czyh,@tzrq,@ysdm,0,@errmsg output,1,@tzxh, 0, @yexh  
   exec usp_bq_tzyz @syxh,@czyh,@tzrq,@ysdm,@tzyy,@errmsg output,1,@tzxh, 0, @yexh  
   if @errmsg like "F%"  
   begin  
    rollback tran  
    select "F",substring(@errmsg,2,49)  
    return  
   end  
           if @config0251='是' or @config6D87='是'  
        begin  
             insert into #yshyz  
    select  distinct  xh,0,2   
    from BQ_LSYZK   
    where syxh=@syxh and yexh = @yexh and fzxh=@fzxh and xh in (select xh from #yjm_bq_lsyzk)  
      if @@error<>0  
    begin  
     rollback tran  
     select "F","审核停止医嘱出错！"  
     return  
    end  
     end  
   update BQ_LSYZK set zxrq=@now,  
    zxczyh=@czyh,  
    yzzt=2,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end  
    ,gxrq=@now  
   where syxh=@syxh and yexh = @yexh and fzxh=@fzxh and xh in (select xh from #yjm_bq_lsyzk)  
   if @@error<>0  
   begin  
    rollback tran  
    select "F","审核停止医嘱出错！"  
    return  
   end  
  end --△停止医嘱 结束  
  else if @yzlb=2 --△if [yzlb 2手术] start  
  begin  
   if (select config from YY_CONFIG (nolock) where id="G090")='否' or @configks20>0  
   begin   
    ----△△参数G090 手术通知单是否审批 为 否  或者 KS20参数>0 使用抗菌素药品管理系统2.0 start  
/*  
    select @ssdj = 0  
    select @ssdj = isnull(a.ssjs,0) from SS_SSDJDMK a (nolock),  SS_SSMZK  b (nolock)  
    where b.id =@ypdm  
    and b.djdm = a.id  
    if (@@error<>0)   
    begin  
     rollback tran  
     select "F","取手术等级失败！"  
     return  
    end  
      
    if exists (select 1 from SS_SSDJK where syxh = @syxh and jlzt = 0 and shzt = @ssdj and yzxh = 0 and ssdm = @ypdm)  
    begin  
     update SS_SSDJK  
     set yzxh =@fzxh  
     from SS_SSDJK a   
     where a.syxh = @syxh  
     and a.jlzt = 0  
     and a.shzt = @ssdj  
     and a.yzxh = 0  
     and a.ssdm = @ypdm  
     if (@@error<>0) or ( @@rowcount=0)  
     begin  
      rollback tran  
      select "F","更新手术通知单失败！"  
      return  
     end  
    end  
    else  
    begin  
     rollback tran  
     select "F","手术通知单未审核完成，不能录入手术医嘱！"  
     return  
    end  
   end  
   else  
   begin  
*/  
    if (select config from YY_CONFIG (nolock) where id="6036")='是'  
    begin   
     ----△△△参数6036 是否使用手术管理系统 为是  start  
     --insert into SS_SSDJK(syxh, yzxh, patid, blh, hzxm, py, wb, bqdm, ksdm,   
      --cwdm, djrq, djczyh, sqrq, ssdm, ssmc, mzdm, mzmc, ssksdm,   
      --glbz, qkdj, jlzt, slbz, sslb, memo, ysdm,haabz)  
     --select @syxh, @fzxh, a.patid, a.blh, a.hzxm, a.py, a.wb, a.bqdm, a.ksdm,  
      --a.cwdm, @now, @czyh, @ksrq, @ypdm, @ypmc, @mzdm, b.name, @zxksdm,  
      --0, null, @ssjlzt, 0, 0, @ztnr, @ysdm,'-1'  
      --from ZY_BRSYK a (nolock), SS_SSMZK b (nolock)  
      --where a.syxh=@syxh and b.id=@mzdm  
     --if @@error<>0  
     --begin  
      --rollback tran  
      --select "F","审核手术医嘱出错！"  
      --return  
     --end  
       
     insert into SS_SSDJK(syxh, yzxh, patid, blh, hzxm, py, wb, bqdm, ksdm,   
      cwdm, djrq, djczyh, sqrq, ssdm, ssmc, mzdm, mzmc, ssksdm,   
      glbz, qkdj, jlzt, slbz, sslb, memo, ysdm,sqzd,haabz,aprq,jzssbz,ssyzshrq  
      )  
           select @syxh, c.xh, a.patid, a.blh, a.hzxm, a.py, a.wb, a.bqdm, a.ksdm,  
         a.cwdm,@now, @czyh,case when exists(select 1 from YY_CONFIG where id='G256' and config='是') then c.ssaprq else c.ksrq  end sqrq, c.ypdm, convert(varchar(256),c.ypmc), c.mzdm,isnull((select name from  SS_SSMZK b   
      (nolock) where b.id=c.mzdm),''), c.zxksdm,0, null,@ssjlzt, 0, 0, convert(varchar(24),c.ztnr), case isnull(c.memo,'') when '' then (case isnull((select name from  SS_SSMZK b (nolock) where b.id=c.mzdm),'') when '' then '' else c.ysdm   
      end) else c.memo end as ysdm,c.sqzd,c.haabz,c.ssaprq,c.jzssbz,@now  
           from ZY_BRSYK a (nolock)inner join BQ_LSYZK c(nolock) on a.syxh=c.syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh=@fzxh and c.yzzt in (0,1) and c.yzlb=2   
      inner join #yjm_bq_lsyzk wls on c.xh=wls.xh  
      left join BQ_LSYZK_FZ fz(nolock) on fz.yzxh=c.xh  
         where a.syxh=@syxh   
         AND not EXISTS(SELECT 1 FROM SS_SSDJK ss(NOLOCK) WHERE a.syxh=ss.syxh AND ss.yzxh=c.xh AND ss.sslb=0 AND ss.yzxh=@fzxh)   
     if @@error<>0  
     begin  
      rollback tran  
      select "F","审核手术医嘱出错！"  
      return  
     end  
     DECLARE @xhtemp_dyz ut_xh12    
     SELECT @xhtemp_dyz = scope_identity()  --add by kongwei 存在触发器影响 @@identity   ---保存SS_SSDJK.xh  
     SELECT @xhtemp_dyz=ISNULL(@xhtemp_dyz,0)  
       
     IF @xhtemp_dyz>0  
     BEGIN  
     IF NOT EXISTS (SELECT 1 FROM SS_SSRYK a(NOLOCK),SS_SSDJK b(NOLOCK) WHERE a.ssxh=b.xh AND a.rylb=1 AND a.rydm=b.ysdm AND b.syxh=@syxh AND b.xh=@xhtemp_dyz)  
     begin   
      insert into SS_SSRYK(ssxh,rylb,rydm,ryxm,memo,isjb)  
      select e.xh,1,e.ysdm,d.name,null,0  
      from ZY_BRSYK a (nolock)  
       inner join BQ_LSYZK c(nolock) on a.syxh =c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh=e.yzxh   
       left join YY_ZGBMK d(nolock) on e.ysdm =d.id   
          where a.syxh=@syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh<=@maxlsyzxh and c.yzzt in (0,1) and c.yzlb=2 and e.xh = @xhtemp_dyz  
       and isnull(e.ysdm,'') != ''  
      if @@error<>0  
      begin  
       rollback tran  
       select "F","审核手术医嘱出错！"  
       return  
      END   
     END   
  
     --生成手术一助  
     IF NOT EXISTS (SELECT 1 FROM SS_SSRYK a(NOLOCK),SS_SSDJK b(NOLOCK) WHERE a.ssxh=b.xh AND a.rylb=2 AND b.syxh=@syxh AND b.xh=@xhtemp_dyz)  
     BEGIN   
      insert into SS_SSRYK(ssxh,rylb,rydm,ryxm,memo,isjb)  
      select e.xh,2,c.ssyzysdm,d.name,null,0  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh= c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh=e.yzxh   
       left join YY_ZGBMK d(nolock) on c.ssyzysdm=d.id   
          where a.syxh=@syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh<=@maxlsyzxh and c.yzzt in (0,1) and c.yzlb=2 and e.xh = @xhtemp_dyz  
        and isnull(c.ssyzysdm,'') != ''  
      if @@error<>0  
      begin  
       rollback tran  
       select "F","审核手术医嘱出错！"  
       return  
      END  
     END  
  
     --生成手术二助  
     IF NOT EXISTS (SELECT 1 FROM SS_SSRYK a(NOLOCK),SS_SSDJK b(NOLOCK) WHERE a.ssxh=b.xh AND a.rylb=3 AND b.syxh=@syxh  AND b.xh=@xhtemp_dyz)  
     BEGIN  
      insert into SS_SSRYK(ssxh,rylb,rydm,ryxm,memo,isjb)  
      select e.xh,3,c.ssezysdm,d.name,null,0  
      from ZY_BRSYK a (nolock)  
       inner join BQ_LSYZK c(nolock) on a.syxh=c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       left join YY_ZGBMK d(nolock) on c.ssezysdm = d.id   
       inner join SS_SSDJK e(nolock) on c.xh=e.yzxh   
          where a.syxh=@syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh<=@maxlsyzxh and c.yzzt in (0,1) and c.yzlb=2 and e.xh = @xhtemp_dyz  
        and isnull(c.ssezysdm,'') != ''  
      if @@error<>0  
      begin  
       rollback tran  
       select "F","审核手术医嘱出错！"  
       return  
      end  
     END   
  
     --生成手术三助  
     IF NOT EXISTS (SELECT 1 FROM SS_SSRYK a(NOLOCK),SS_SSDJK b(NOLOCK) WHERE a.ssxh=b.xh AND a.rylb=4 AND b.syxh=@syxh AND b.xh=@xhtemp_dyz)  
     BEGIN  
      insert into SS_SSRYK(ssxh,rylb,rydm,ryxm,memo,isjb)  
      select e.xh,4,c.ssszysdm,d.name,null,0  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh  
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       left join YY_ZGBMK d(nolock) on c.ssszysdm=d.id   
       inner join SS_SSDJK e(nolock) on c.xh=e.yzxh   
          where a.syxh=@syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh<=@maxlsyzxh and c.yzzt in (0,1) and c.yzlb=2 and e.xh = @xhtemp_dyz  
        and isnull(c.ssszysdm,'') != ''  
      if @@error<>0  
      begin  
       rollback tran  
       select "F","审核手术医嘱出错！"  
       return  
      end  
                  END  
     --术前诊断  
     insert into SS_SSZDK(ssxh,zdlb,zdlx,zddm,zdmc,memo)  
     select e.xh,0,0,e.sqzd,isnull(d.name,''),null  
     from ZY_BRSYK a (nolock)  
      inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh   
      inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
      inner join SS_SSDJK e(nolock) on c.xh =e.yzxh   
      left join YY_ZDDMK d(nolock) on e.sqzd = d.id   
     where a.syxh=@syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh<=@maxlsyzxh and c.yzzt in (0,1) and c.yzlb=2  
       and isnull(e.sqzd,'') != ''  
     if @@error<>0  
     begin  
      rollback tran  
      select "F","审核手术医嘱出错！"  
      return  
     end  
       
     if exists(select 1 from sysobjects where name='V5_SSYZK')  
     begin  
      --辅助诊断一  
      insert into SS_SSZDK(ssxh,zdlb,zdlx,zddm,zdmc,memo)  
      select e.xh,0,1,d.SQZD1,isnull(d.SQZDMC1,''),null  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh =e.yzxh   
       left join V5_SSYZK d(nolock) on c.v5xh = d.YZXH and d.SYXH=@syxh  
      where a.syxh=@syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh<=@maxlsyzxh and c.yzzt in (0,1) and c.yzlb=2  
        and isnull(d.SQZD1,'') != ''  
        and not exists (select 1 from SS_SSZDK where ssxh = e.xh and zdlb = 0 and zdlx = 1)  
      if @@error<>0  
      begin  
       rollback tran  
       select "F","审核手术医嘱出错！"  
       return  
      end  
      --辅助诊断二  
      insert into SS_SSZDK(ssxh,zdlb,zdlx,zddm,zdmc,memo)  
      select e.xh,0,2,d.SQZD2,isnull(d.SQZDMC2,''),null  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh =e.yzxh   
       left join V5_SSYZK d(nolock) on c.v5xh = d.YZXH and d.SYXH=@syxh   
      where a.syxh=@syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh<=@maxlsyzxh and c.yzzt in (0,1) and c.yzlb=2  
        and isnull(d.SQZD2,'') != ''  
        and not exists (select 1 from SS_SSZDK where ssxh = e.xh and zdlb = 0 and zdlx = 2)  
      if @@error<>0  
      begin  
       rollback tran  
       select "F","审核手术医嘱出错！"  
       return  
      end  
      --辅助诊断三  
      insert into SS_SSZDK(ssxh,zdlb,zdlx,zddm,zdmc,memo)  
      select e.xh,0,3,d.SQZD3,isnull(d.SQZDMC3,''),null  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh =e.yzxh   
       left join V5_SSYZK d(nolock) on c.v5xh = d.YZXH and d.SYXH=@syxh  
      where a.syxh=@syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh<=@maxlsyzxh and c.yzzt in (0,1) and c.yzlb=2  
        and isnull(d.SQZD3,'') != ''  
        and not exists (select 1 from SS_SSZDK where ssxh = e.xh and zdlb = 0 and zdlx = 3)  
      if @@error<>0  
      begin  
       rollback tran  
       select "F","审核手术医嘱出错！"  
       return  
      end  
     end       
     END   
       
     if (@config6A38='是')  
     begin  
      select @syxh_1=convert(varchar,@syxh),@yexh_1=convert(varchar,@yexh)  
          ,@maxlsyzxh_1=convert(varchar,@maxlsyzxh),@xhtemp_dyz_1=convert(varchar,@xhtemp_dyz)  
      --手术人员库  
      exec('insert into '+@config6C58+'dbo.JK_SS_SSRYK (xh,eventtype,opeordernumber,emptype,empcode,empname,Facility,FacilityName,  
       memo,isclude,createtime,processstatus)  
      --主刀医生  
      select NEWID(),1,e.xh,1   --人员类别( 0：指导医生,1主刀医生,2：手术一助3:手术二助,4：手术三助  
      --  10：麻醉指导,11：主麻 12付麻   
      --  20：器械护士,21：巡回护士,22：洗手护士  
      --  30：输血)  
      ,e.ysdm,d.name,d.ks_id,d.ks_mc,null,0  --1：手术接班人员，0：手术参与人员  
      ,CONVERT(DATETIME,GETDATE(),120),1 --1:新增 2-平台已读取 3-平台处理失败 4-平台处理成功 5-无效数据   
      from ZY_BRSYK a (nolock)  
       inner join BQ_LSYZK c(nolock) on a.syxh =c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh=e.yzxh   
       left join YY_ZGBMK d(nolock) on e.ysdm =d.id   
          where a.syxh='+@syxh_1+' and c.syxh='+@syxh_1+' and c.yexh = '+@yexh_1+' and c.xh<='+@maxlsyzxh_1+' and c.yzzt in (0,1) and c.yzlb=2 and e.xh = '+@xhtemp_dyz_1 +'  
       and isnull(e.ysdm,"") != ""  
      union all  
      --手术一助  
      select NEWID(),1,e.xh,2,e.ysdm,d.name,d.ks_id,d.ks_mc,null,0,CONVERT(DATETIME,GETDATE(),120),1  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh= c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh=e.yzxh   
       left join YY_ZGBMK d(nolock) on c.ssyzysdm=d.id   
          where a.syxh='+@syxh_1+' and c.syxh='+@syxh_1+' and c.yexh = '+@yexh_1+' and c.xh<='+@maxlsyzxh_1+' and c.yzzt in (0,1) and c.yzlb=2 and e.xh = '+@xhtemp_dyz_1 +'  
        and isnull(c.ssyzysdm,"") != ""  
      union all  
      --手术二助  
      select NEWID(),1,e.xh,3,e.ysdm,d.name,d.ks_id,d.ks_mc,null,0,CONVERT(DATETIME,GETDATE(),120),1  
      from ZY_BRSYK a (nolock)  
       inner join BQ_LSYZK c(nolock) on a.syxh=c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       left join YY_ZGBMK d(nolock) on c.ssezysdm = d.id   
       inner join SS_SSDJK e(nolock) on c.xh=e.yzxh   
          where a.syxh='+@syxh_1+' and c.syxh='+@syxh_1+' and c.yexh = '+@yexh_1+' and c.xh<='+@maxlsyzxh_1+' and c.yzzt in (0,1) and c.yzlb=2 and e.xh = '+@xhtemp_dyz_1 +'  
        and isnull(c.ssezysdm,"") != ""  
      union all  
      --手术三助  
      select NEWID(),1,e.xh,4,e.ysdm,d.name,d.ks_id,d.ks_mc,null,0,CONVERT(DATETIME,GETDATE(),120),1  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh  
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       left join YY_ZGBMK d(nolock) on c.ssszysdm=d.id   
       inner join SS_SSDJK e(nolock) on c.xh=e.yzxh   
          where a.syxh='+@syxh_1+' and c.syxh='+@syxh_1+' and c.yexh = '+@yexh_1+' and c.xh<='+@maxlsyzxh_1+' and c.yzzt in (0,1) and c.yzlb=2 and e.xh = '+@xhtemp_dyz_1 +'  
        and isnull(c.ssszysdm,"") != ""'  
      )  
        
      --手术登记库  
      exec('insert into '+@config6C58+'dbo.JK_SS_SSDJK (xh,eventtype,PatID,PatientID,PatientName,DateTimeofBirth,AdministrativeSex,StreetOrMailingAddress,  
        ZipOrPostalCode,AddressType,PhoneNumberHome,PhoneNumberBusiness,MaritalStatusIdentifier,MaritalStatusText,  
        EthnicGroup,EthnicGroupText,BirthPlace,Nationality,NationalityText,IDCardNo,IDCardType,IDCardTypeName,IdentifyNO,  
        PatientClass,PointOfCare,PointOfCareName,Room,Bed,Facility,FacilityName,AttendingDoctor,ReAdmissionIndicator,  
        VisitNumber,AdmitDateTime,OperationOrderNumber,PlacerOrderNumber,RequestDateTime,ScheduleDateTime,FixupDateTime,  
        OrderingFacility,UniversalServiceIdentifier,UniversalServiceText,FillerStatusCode,Position,SpecialMaterial,  
        OperationSite,IsReadyBlood,CutsRating,HepatitisIndicator,SpecialInfect,OperationDept,OperationRoom,Sequence,  
        OperationScaleID,OperationScale,AnaesthesiaMethod,EmergencyIndicator,IsolationIndicator,Memo,RequestedDoctorID,  
        createtime,processstatus)  
      select NEWID(),1,a.patid,a.blh,a.hzxm,convert(datetime,substring(a.birth,1,4)+"-"+substring(a.birth,5,2)+"-"+substring(a.birth,7,2)),  
       case when a.sex="男" then "1" when a.sex="女" then "2" else "9" end,k.lxdz,k.lxyb,"",k.lxdh,k.dwdh,k.hyzk,  
       case when k.hyzk="0" then "未婚"  when k.hyzk="1" then "已婚"  when k.hyzk="2" then "离独"   when k.hyzk="3" then "丧偶"  else "未知" end,   --0未婚,1已婚,2离独,3丧偶  
       k.mzbm,d.name,l.name+m.name+n.name,k.gjbm,e.name,a.cardno,a.cardtype,o.name,substring(a.sfzh,1,18),b.sslb,---患者类别  
       b.bqdm,g.name,h.fjh,b.cwdm,b.ksdm,i.name,b.ysdm,a.zycs,a.syxh,  
       convert(datetime,substring(a.ryrq,1,4)+"-"+substring(a.ryrq,5,2)+"-"+substring(a.ryrq,7,2) + " " +substring(a.ryrq,9,8)),  
       b.xh,b.yzxh,convert(datetime,SUBSTRING(b.djrq,1,4)+"-"+SUBSTRING(b.djrq,5,2)+"-"+SUBSTRING(b.djrq,7,2) + " " + SUBSTRING(b.djrq,9,8)),  
       case when b.kssj is null or rtrim(b.kssj)="" then null else convert(datetime,SUBSTRING(b.kssj,1,4)+"-"+SUBSTRING(b.kssj,5,2)+"-"+SUBSTRING(b.kssj,7,2)+" "+SUBSTRING(b.kssj,9,8)) end,  
       case when b.aprq is null or rtrim(b.aprq)="" then null else convert(datetime,SUBSTRING(b.aprq,1,4)+"-"+SUBSTRING(b.aprq,5,2)+"-"+SUBSTRING(b.aprq,7,2)+" "+SUBSTRING(b.aprq,9,8)) end,  
       j.name,b.ssdm,b.ssmc,b.jlzt,b.tw,b.tsqx,b.bwid,case when isnull(b.bx,"")<>"" then 1 else 0 end,b.qkdj,b.haabz,b.tsgr,  
       b.ssksdm,b.roomno,b.sstc,b.ssdj,p.name,b.mzmc,b.jzssbz,b.glbz,b.memo,b.ysdm,CONVERT(DATETIME,GETDATE(),120),1  
      from ZY_BRSYK a (nolock)  
       inner join SS_SSDJK b(nolock) on a.syxh=b.syxh  
       inner join ZY_BRXXK k(nolock) on a.patid=k.patid  
       left join YY_MZDMK d(nolock) on k.mzbm=d.id  
       left join YY_GJDMK e(nolock) on k.gjbm=e.id  
       left join YY_YBFLK f(nolock) on a.ybdm=f.ybdm  
       inner join ZY_BQDMK g(nolock) on b.bqdm=g.id  
       inner join ZY_BCDMK h(nolock) on b.bqdm=h.bqdm and b.cwdm=h.id   
       inner join YY_KSBMK i(nolock) on b.ksdm=i.id  
       inner join YY_KSBMK j(nolock) on b.ssksdm=j.id  
       inner join BQ_LSYZK c(nolock) on a.syxh=c.syxh and c.syxh='+@syxh_1+' and c.yexh = '+@yexh_1+' and c.xh<='+@maxlsyzxh_1+' and c.yzzt in (0,1) and c.yzlb=2   
       inner join #yjm_bq_lsyzk wls on c.xh=wls.xh    
       left join BQ_LSYZK_FZ fz(nolock) on fz.yzxh=c.xh  
       left join YY_DQDMK l(nolock) on k.csd_s=l.id and l.lb=0  
       left join YY_DQDMK m(nolock) on k.csd_djs=m.id and l.lb=1  
       left join YY_DQDMK n(nolock) on k.csd_x=n.id and l.lb=2  
       left join YY_CARDTYPE o(nolock) on a.cardtype=o.id  
       left join SS_SSDJDMK p(nolock) on b.ssdj=p.id  
          where a.syxh='+@syxh_1+'  
          AND b.xh='+@xhtemp_dyz_1+' ')  
  
      --手术诊断库  
      exec('insert into '+@config6C58+'dbo.JK_SS_SSZDK (xh,eventtype,OperationOrderNumber,DiagnosisCode,DiagnosisDescription,DiagnosisType,DiagnosisFlag,  
       Memo,Description,createtime,processstatus)  
      --术前诊断  
      select newid(),1,e.xh,e.sqzd,isnull(d.name,""),0  --诊断类别,(0：术前诊断,1：术后诊断,2：病理诊断)  
       ,0 --诊断类型,(0：主诊,1：第一辅诊,2：第二辅诊,3：第三辅诊,4：第四辅诊)  
       ,null,null,CONVERT(DATETIME,GETDATE(),120),1  
      from ZY_BRSYK a (nolock)  
      inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh   
      inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
      inner join SS_SSDJK e(nolock) on c.xh =e.yzxh   
      left join YY_ZDDMK d(nolock) on e.sqzd = d.id   
      where a.syxh='+@syxh_1+' and c.syxh='+@syxh_1+' and c.yexh = '+@yexh_1+' and c.xh<='+@maxlsyzxh_1+' and c.yzzt in (0,1) and c.yzlb=2  
       and isnull(e.sqzd,"") != ""  
      union all  
      --辅助诊断一  
      select newid(),1,e.xh,d.SQZD1,isnull(d.SQZDMC1,""),0,1  
       ,null,null,CONVERT(DATETIME,GETDATE(),120),1  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh =e.yzxh   
       left join V5_SSYZK d(nolock) on c.v5xh = d.YZXH and d.SYXH='+@syxh_1+'  
      where a.syxh='+@syxh_1+' and c.syxh='+@syxh_1+' and c.yexh = '+@yexh_1+' and c.xh<='+@maxlsyzxh_1+' and c.yzzt in (0,1) and c.yzlb=2  
        and isnull(d.SQZD1,"") != ""  
        and not exists (select 1 from SS_SSZDK where ssxh = e.xh and zdlb = 0 and zdlx = 1)  
      union all  
      --辅助诊断二  
      select newid(),1,e.xh,d.SQZD2,isnull(d.SQZDMC2,""),0,2  
       ,null,null,CONVERT(DATETIME,GETDATE(),120),1  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh =e.yzxh   
       left join V5_SSYZK d(nolock) on c.v5xh = d.YZXH and d.SYXH='+@syxh_1+'   
      where a.syxh='+@syxh_1+' and c.syxh='+@syxh_1+' and c.yexh = '+@yexh_1+' and c.xh<='+@maxlsyzxh_1+' and c.yzzt in (0,1) and c.yzlb=2  
        and isnull(d.SQZD2,"") != ""  
        and not exists (select 1 from SS_SSZDK where ssxh = e.xh and zdlb = 0 and zdlx = 2)  
      union all  
      --辅助诊断三  
      select newid(),1,e.xh,d.SQZD3,isnull(d.SQZDMC3,""),0,3  
       ,null,null,CONVERT(DATETIME,GETDATE(),120),1  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh =e.yzxh   
       left join V5_SSYZK d(nolock) on c.v5xh = d.YZXH and d.SYXH='+@syxh_1+'  
      where a.syxh='+@syxh_1+' and c.syxh='+@syxh_1+' and c.yexh = '+@yexh_1+' and c.xh<='+@maxlsyzxh_1+' and c.yzzt in (0,1) and c.yzlb=2  
        and isnull(d.SQZD3,"") != ""  
        and not exists (select 1 from SS_SSZDK where ssxh = e.xh and zdlb = 0 and zdlx = 3) ')  
     end      
    end ----△△△参数6036 是否使用手术管理系统 为是  end  
   end  ----△△参数G090 手术通知单是否审批 为 否  或者 KS20参数>0 使用抗菌素药品管理系统2.0 end  
            else  
            begin ----△△参数G090 手术通知单是否审批 为 是  或者 KS20参数=0 不使用抗菌素药品管理系统2.0 start  
                if (@sfxyzlc=1)  
                begin  
                    update SS_SSDJK set jlzt=0  
                    where yzxh = @fzxh and syxh=@syxh  
     if @@error<>0  
     begin  
      rollback tran  
      select "F","审核手术医嘱出错！"  
      return  
     end  
                end  
            end ----△△参数G090 手术通知单是否审批 为 是  或者 KS20参数=0 不使用抗菌素药品管理系统2.0 end  
  end --△if [yzlb 2手术] end  
 end  ----▲▲审核医嘱类别 @yzbz (0:临时) end  
 else   
 begin  ----▲▲审核医嘱类别 @yzbz (1:长期) start  
     declare @dc_yzzt ut_bz   --取出医嘱状态，判断审核的是dc医嘱还是正常的yzzt=0的医嘱   dc医嘱单独处理  
         ,@rowcount int,@error int --记录update语句结果  
     select @dc_yzzt = 0  
     select @dc_yzzt = yzzt from BQ_CQYZK where syxh=@syxh and yexh = @yexh and fzxh=@fzxh and yzzt in (0,3)   
        if @issh='否' --△参数6293 医嘱审核时，阳性药品是否能审核 为 否 start  
        begin  
            --△△if QQQQ start    
            if exists(select 1 from BQ_CQYZK a(nolock),BQ_BRGMJLK b (nolock)  
    where a.syxh=@syxh and a.yexh = @yexh and fzxh=@fzxh and a.yzzt=0 and a.syxh=b.syxh and a.gg_idm=b.gg_idm and b.gmlx in (1,6,7) and b.jlzt=0  
    )  
    set @shnr = '该病人医嘱存在阳性的过敏药品，造成相应医嘱没有审核通过！'  
            -- △△if QQQQ end   
  
            if @config6480<>'是' --△△参数6480 是否使用医生(EMR医嘱审核)与护士分开审核的机制 为 否 start  
            begin  
    if @config0251 ='是' or @config6D87='是'    
    begin  
     insert into #yshyz   
     select distinct a.xh,1,1   
     from BQ_CQYZK a inner join #yjm_bq_cqyzk wcq on wcq.xh=a.xh  
     where a.syxh=@syxh and a.yexh = @yexh and a.fzxh=@fzxh and a.yzzt=0   
      and  not exists (  
       select 1   
       from BQ_CQYZK b,BQ_BRGMJLK c  
       where b.syxh=@syxh and b.yexh = @yexh and b.fzxh=@fzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
       and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh)  
      and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
      AND ((@config6788=1)OR( a.xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
  end  
    update BQ_CQYZK set shrq=@now,  
     shczyh=@czyh,  
     yzzt=1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end  
     ,gxrq=@now  
     ,ksrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
       convert(char(8),dateadd(day,1,substring(substring(ksrq,1,8),1,8)),112) +'00:01:00'  
       else ksrq end  
     ,yzxrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
       convert(char(8),dateadd(day,1,substring(substring(yzxrq,1,8),1,8)),112)   
       else yzxrq end  
     ,zxrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
       convert(char(8),dateadd(day,1,substring(substring(zxrq,1,8),1,8)),112)   
       else zxrq end  
    from BQ_CQYZK a inner join #yjm_bq_cqyzk wcq on wcq.xh=a.xh  
    where a.syxh=@syxh and a.yexh = @yexh and a.fzxh=@fzxh and a.yzzt=0   
     and  not exists (select 1  from BQ_CQYZK b,BQ_BRGMJLK c where b.syxh=@syxh and b.yexh = @yexh and b.fzxh=@fzxh   
      and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh)  
     and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
     AND ((@config6788=1)OR( a.xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
              
    select @rowcount=@@rowcount,@error=@@error   --记录update语句结果  
            end --△△参数6480 是否使用医生(EMR医嘱审核)与护士分开审核的机制 为 否 end  
            else  
            begin --△△参数6480 是否使用医生(EMR医嘱审核)与护士分开审核的机制 为 是 start  
    if @emrsybz = 0 --  if @emrsybz = 0 start  
    begin  
     if @config0251 ='是' or @config6D87='是'    
     begin  
      insert into #yshyz   
      select distinct a.xh,1,1  
      from BQ_CQYZK a inner join #yjm_bq_cqyzk wcq on wcq.xh=a.xh  
      where a.syxh=@syxh and a.yexh = @yexh and a.fzxh=@fzxh and a.yzzt=0   
       and  not exists (  
        select 1   
        from BQ_CQYZK b,BQ_BRGMJLK c  
        where b.syxh=@syxh and b.yexh = @yexh and b.fzxh=@fzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
        and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh)  
       and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
       and isnull(a.yshdbz,0)=1  
       AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
     end  
     update BQ_CQYZK set shrq=@now,  
      shczyh=@czyh,  
      yzzt=1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
      ,gxrq=@now  
      ,ksrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
       convert(char(8),dateadd(day,1,substring(substring(ksrq,1,8),1,8)),112) +'00:01:00'  
       else ksrq end  
      ,yzxrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
       convert(char(8),dateadd(day,1,substring(substring(yzxrq,1,8),1,8)),112)   
       else yzxrq end  
      ,zxrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
       convert(char(8),dateadd(day,1,substring(substring(zxrq,1,8),1,8)),112)   
       else zxrq end  
     from BQ_CQYZK a inner join #yjm_bq_cqyzk wcq on wcq.xh=a.xh  
     where a.syxh=@syxh and a.yexh = @yexh and a.fzxh=@fzxh and a.yzzt=0   
      and  not exists (  
       select 1   
       from BQ_CQYZK b,BQ_BRGMJLK c  
       where b.syxh=@syxh and b.yexh = @yexh and b.fzxh=@fzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
       and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh)  
      and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
      and isnull(a.yshdbz,0)=1  
  AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
      
     select @rowcount=@@rowcount,@error=@@error   --记录update语句结果  
    end --  if @emrsybz = 0 end  
    else if @emrsybz = 1 ----  if @emrsybz = 1 start  
    begin  
     update BQ_CQYZK set yshdbz = 1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
     ,gxrq=@now  
     from BQ_CQYZK a inner join #yjm_bq_cqyzk wcq on wcq.xh=a.xh  
     where a.syxh=@syxh and a.yexh = @yexh and a.fzxh=@fzxh and a.yzzt=0   
      and  not exists (  
       select 1   
       from BQ_CQYZK b,BQ_BRGMJLK c  
       where b.syxh=@syxh and b.yexh = @yexh and b.fzxh=@fzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
       and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh)  
      and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
      and isnull(a.yshdbz,0)=0  
      AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
      
     select @rowcount=@@rowcount,@error=@@error   --记录update语句结果  
    end  ----  if @emrsybz = 1 end  
    end --△△参数6480 是否使用医生(EMR医嘱审核)与护士分开审核的机制 为 否 end  
        end --△参数6293 医嘱审核时，阳性药品是否能审核 为 否 end  
        else  
        begin --△参数6293 医嘱审核时，阳性药品是否能审核 为 是 start  
            if @config6480<>'是'  --△△参数6480 是否使用医生(EMR医嘱审核)与护士分开审核的机制 为 否 start  
            begin  
    if @config0251 ='是' or @config6D87='是'    
    begin  
     insert into #yshyz  
     select xh,1,1  
     from BQ_CQYZK  
     where syxh=@syxh  and yexh = @yexh and fzxh=@fzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
     and xh in (select xh from #yjm_bq_cqyzk)  
    end  
    update BQ_CQYZK set shrq=@now,  
    shczyh=@czyh,  
    yzzt=1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end  
    ,gxrq=@now  
    where syxh=@syxh  and yexh = @yexh and fzxh=@fzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
     and xh in (select xh from #yjm_bq_cqyzk)     
              
    select @rowcount=@@rowcount,@error=@@error   --记录update语句结果  
            end --△△参数6480 是否使用医生(EMR医嘱审核)与护士分开审核的机制 为 否 end  
            else  
            begin --△△参数6480 是否使用医生(EMR医嘱审核)与护士分开审核的机制 为 是 start  
    if @emrsybz = 0 ----  if @emrsybz = 0 start  
    begin  
     if @config0251 ='是' or @config6D87='是'    
     begin  
      insert into #yshyz  
      select xh,1,1  
      from BQ_CQYZK a  
      where syxh=@syxh  and yexh = @yexh and fzxh=@fzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
      and isnull(yshdbz,0)=1  
      and xh in (select xh from #yjm_bq_cqyzk)  
      AND ((@config6788=1)OR(xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
     end  
     update BQ_CQYZK set shrq=@now,  
     shczyh=@czyh,  
     yzzt=1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
     ,gxrq=@now  
     ,ksrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
       convert(char(8),dateadd(day,1,substring(substring(ksrq,1,8),1,8)),112) +'00:01:00'  
       else ksrq end  
     ,yzxrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
       convert(char(8),dateadd(day,1,substring(substring(yzxrq,1,8),1,8)),112)   
       else yzxrq end  
     ,zxrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
       convert(char(8),dateadd(day,1,substring(substring(zxrq,1,8),1,8)),112)   
       else zxrq end  
     from BQ_CQYZK a  
     where syxh=@syxh  and yexh = @yexh and fzxh=@fzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
      and isnull(yshdbz,0)=1  
      and xh in (select xh from #yjm_bq_cqyzk)  
     AND ((@config6788=1)OR(xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
      
     select @rowcount=@@rowcount,@error=@@error   --记录update语句结果  
    end ----  if @emrsybz = 0 end  
    else  
    if @emrsybz = 1 ----  if @emrsybz = 1 start  
    begin    
     update BQ_CQYZK set yshdbz = 1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
     ,gxrq=@now  
     from BQ_CQYZK a  
     where syxh=@syxh  and yexh = @yexh and fzxh=@fzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @CQfzxh+ ',' )<=0     
      and isnull(yshdbz,0)=0   
      and xh in (select xh from #yjm_bq_cqyzk)   
     AND ((@config6788=1)OR(xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))           
      
     select @rowcount=@@rowcount,@error=@@error   --记录update语句结果  
    end ----  if @emrsybz = 1 end  
            end  --△△参数6480 是否使用医生(EMR医嘱审核)与护士分开审核的机制 为 是 start  
        end --△参数6293 医嘱审核时，阳性药品是否能审核 为 是 end  
  if @dc_yzzt <> 3  --dc医嘱审核时不做判断  
  begin  
   if @error<>0 or @rowcount=0  
   begin  
    rollback tran  
    select "F","审核长期医嘱出错！"  
    return  
   end  
  end   
  select @shyzcount = @shyzcount + @@rowcount  
 end  ----▲▲审核医嘱类别 @yzbz (1:长期) end  
end ---=======================▲审核类别 1=单条医嘱  end=====================================  
  
--add by kongwei 2017-10-09 需求195482  无锡锡山人民医院--1704病区管理  
if (@config6C54 <> '')  
begin  
    declare @wkdz ut_mc64,@hs_yzxh ut_xh12,@hs_zxsj varchar(5),@hs_zxrq ut_rq16,@hs_ypjl ut_sl10,@errmsg_hszxyz varchar(200)  
    select @wkdz = '#hszxyz'  
      
 exec usp_bq_hszxyz @wkdz,1,@czyh,0,'','',@delphi=0,@errmsg=@errmsg_hszxyz  
 declare cs_hszxyz cursor FOR   
   select xh,substring(shrq,9,5) zxsj,shrq,ypjl from BQ_LSYZK a where a.syxh=@syxh  
     and (a.yzzt = 1 or (a.yzzt=2 and a.yzlb=9)) and a.shczyh = @czyh and a.shrq = @now and charindex('"'+convert(varchar,a.yzlb)+'"',@config6C54) > 0  
     and a.xh in (select xh from #yjm_bq_lsyzk)  
 open cs_hszxyz  
 fetch cs_hszxyz into @hs_yzxh,@hs_zxsj,@hs_zxrq,@hs_ypjl  
 while @@fetch_status=0  
 BEGIN  
     update BQ_LSYZK set zxczyh_hs=@czyh,zxrq_hs=shrq  
         where xh = @hs_yzxh and syxh = @syxh and (yzzt = 1 or (yzzt=2 and yzlb=9))  
     exec usp_bq_hszxyz @wkdz,2,@czyh,@hs_yzxh,'',@hs_zxsj,@hs_zxrq,@sjjl=@hs_ypjl,@zxks=@dqksdm,@delphi=0,@errmsg=@errmsg_hszxyz  
  fetch cs_hszxyz into @hs_yzxh,@hs_zxsj,@hs_zxrq,@hs_ypjl  
 end  
 close cs_hszxyz  
 deallocate cs_hszxyz  
 exec usp_bq_hszxyz @wkdz,3,@czyh,0,'','',@yzbz=0,@delphi=0,@errmsg=@errmsg_hszxyz  
end   
  
--==============================住院小处方审核   start=========================================  
if (@config6142 = '是') and (@config6583 = '是')  
begin  
    declare @stryzxh ut_xh12,  
            @strbqdm ut_ksdm  
 declare cs_bqdm cursor FOR select xh,bqdm from BQ_LSYZK a where a.syxh=@syxh  and  a.yzlb=14  
     and a.yzzt = 1 and a.shczyh = @czyh and a.shrq = @now  
     and not exists (select 1 from BQ_FYQQK b where b.yzxh=a.xh and a.syxh=b.syxh AND b.jlzt=0)   
     and a.xh in (select xh from #yjm_bq_lsyzk)  
 open cs_bqdm  
 fetch cs_bqdm into @stryzxh,@strbqdm  
 while @@fetch_status=0  
 BEGIN  
     update BQ_LSYZK set yzzt = 2,shrq = null,shczyh = null,zxrq=null,zxczyh=null   
     where xh = @stryzxh and syxh = @syxh and yzlb = 14 and yzzt = 1  
   and xh in (select xh from #yjm_bq_lsyzk)  
     --小处方审核  
        exec usp_zy_xcfsh @czyh,1,@syxh,@cflx =0   
        exec usp_zy_xcfsh @czyh,2,@syxh,@stryzxh,@czyh,@czyh,@strbqdm,@dqksdm  
        exec usp_zy_xcfsh @czyh,3,@syxh,0,@czyh,@czyh,'','',0   
  fetch cs_bqdm into @stryzxh,@strbqdm  
 end  
 close cs_bqdm  
 deallocate cs_bqdm   
end   
--==============================住院小处方审核   end=========================================  
  
--swx 2015-10-14 for 需求47224 仙居县人民医院---病区护士站医嘱执行  
--医生站发送的医嘱不同步lyljfs，6538=否医嘱录入不提示时  
if (@config6949='是')and(@config6538='否')  
begin  
 update BQ_CQYZK set lyljfs=1  
 from BQ_CQYZK a inner join #yjm_bq_cqyzk wcq on wcq.xh=a.xh  
 where a.syxh=@syxh and a.yexh = @yexh and a.xh<=@maxcqyzxh  
  and a.yzzt=1 and shrq=@now and shczyh=@czyh   --当前操作员当前审核的医嘱  
  and  not exists (  
     select 1   
     from BQ_CQYZK b,BQ_BRGMJLK c  
     where b.syxh=@syxh and b.yexh = @yexh and b.fzxh=@fzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
     and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh  
     )  
  and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
  AND ((@config6788=1)OR( a.xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))   
  and a.idm in (SELECT lj.idm FROM BQ_LJLYMX lj(nolock) WHERE lj.jlzt=0 and lj.syxh=a.syxh ) --药品存在有效累计记录  
end  
         
---------医嘱闭环开始-------------------------------------------------------------------------         
IF @config6D87='是'  
BEGIN  
 INSERT INTO BQ_JK_YZBHXX([guid],yzxh,cqlsbz,yzzt,zxczyh,zxsj)  
 SELECT DISTINCT @guid, a.yzxh,0,1,@czyh,  
 (SUBSTRING(@now,1,4)+'-'+SUBSTRING(@now,5,2)+'-'+SUBSTRING(@now,7,2)+' '+SUBSTRING(@now,9,8))  
 from BQ_LSYZK b (nolock)   inner join  #yshyz a(nolock) on a.yzxh=b.xh   
 where a.cqlsbz=0 and b.yzlb<>9   
  
 INSERT INTO BQ_JK_YZBHXX([guid],yzxh,cqlsbz,yzzt,zxczyh,zxsj)  
 SELECT DISTINCT @guid, a.yzxh,1,1,@czyh,  
 (SUBSTRING(@now,1,4)+'-'+SUBSTRING(@now,5,2)+'-'+SUBSTRING(@now,7,2)+' '+SUBSTRING(@now,9,8))  
 from BQ_CQYZK b (nolock) inner join  #yshyz a(nolock) on a.yzxh=b.xh   
 where a.cqlsbz=1   
END  
       
IF @config0251='是'  
BEGIN      
 declare cs_yzsh_bh_ls cursor for  --第二步  
 select distinct b.syxh,a.yzxh,case isnull(@dqksdm,'') when '' then b.ksdm else @dqksdm end  
 ,b.bqdm,b.shczyh,a.yzzt    
 from BQ_LSYZK b (nolock)   inner join  #yshyz a(nolock) on a.yzxh=b.xh   
 where a.cqlsbz=0 and b.yzlb<>9   
 order by a.yzxh,a.yzzt  
 open cs_yzsh_bh_ls   
 fetch cs_yzsh_bh_ls into @yzbh_syxh,@yzbh_yzxh,@yzbh_zxks,@yzbh_bqdm,@shr,@yzzt  
 while @@fetch_status=0 ---游标 cs_cydy_yzsh while Start  
 begin  
 select @yzbh_pcsj=''   
 select @yzbh_cqlsbz=0     
 if @yzzt=1   
 begin  
 select @yzbh_xtbz=6  
 end  
 else if @yzzt=2  
 begin  
 select @yzbh_xtbz=7  
 end  
 --========◆◆◆医嘱闭环 调用1 临时◆◆◆===========   
 exec usp_bq_yzbh_dy @yzbh_syxh,@yzbh_yzxh,@yzbh_cqlsbz,@yzbh_zxks,@yzbh_bqdm,  
 @shr,'',@yzbh_pcsj,@yzbh_xtbz,0,@errmsg output  
 if @errmsg like 'F%'  
 begin  
 rollback TRAN  
 deallocate cs_yzsh_bh_ls     
 select "F",substring(@errmsg,2,49)  
 return    
 end  
 fetch cs_yzsh_bh_ls into @yzbh_syxh,@yzbh_yzxh,@yzbh_zxks,@yzbh_bqdm,@shr,@yzzt  
 end   
 close cs_yzsh_bh_ls  
 deallocate cs_yzsh_bh_ls     
  
 declare cs_yzsh_bh_cq cursor for  
 select distinct b.syxh,a.yzxh,case isnull(@dqksdm,'') when '' then b.ksdm else @dqksdm end,  
 b.bqdm,b.shczyh,a.yzzt    
 from BQ_CQYZK b (nolock) inner join  #yshyz a(nolock) on a.yzxh=b.xh   
 where a.cqlsbz=1   
 order by a.yzxh,a.yzzt  
 open cs_yzsh_bh_cq   
 fetch cs_yzsh_bh_cq into @yzbh_syxh,@yzbh_yzxh,@yzbh_zxks,@yzbh_bqdm,@shr,@yzzt   
 while @@fetch_status=0 ---游标 cs_cydy_yzsh while Start  
 begin  
 select @yzbh_pcsj=''   
 select @yzbh_cqlsbz=1  
 if @yzzt=1   
 begin  
 select @yzbh_xtbz=6  
 end  
 else if @yzzt=2  
 begin  
 select @yzbh_xtbz=7  
 end  
 else if @yzzt=4  --停止审核  
 begin  
 select @yzbh_xtbz=10  
 end  
 --========◆◆◆医嘱闭环 调用2 长期 ◆◆◆===========      
 exec usp_bq_yzbh_dy @yzbh_syxh,@yzbh_yzxh,@yzbh_cqlsbz,@yzbh_zxks,@yzbh_bqdm,  
 @shr,'',@yzbh_pcsj,@yzbh_xtbz,0,@errmsg output  
 if @errmsg like 'F%'  
 begin  
 rollback tran   
 deallocate cs_yzsh_bh_cq    
 select "F",substring(@errmsg,2,49)  
 return    
 end  
 fetch cs_yzsh_bh_cq into @yzbh_syxh,@yzbh_yzxh,@yzbh_zxks,@yzbh_bqdm,@shr,@yzzt  
 end   
 close cs_yzsh_bh_cq  
 deallocate cs_yzsh_bh_cq   
END     
---------------医嘱闭环结束----------------------------------------------------------------------------------   
if @config6800='1' --更新危重标志医嘱处理,危重医嘱只能做为临时医嘱下达--老流程 2014-03-06 caoshuang 增加6800为2的情况，根据yzlb判断  
begin  
 if exists(select 1 from BQ_LSYZK a(nolock) where a.syxh=@syxh and a.yzzt=1 and idm=0 AND  LTRIM(RTRIM(a.ypdm))<>'' AND  (a.ypdm=@configG107 or a.ypdm=@configG108))  
 begin  
  update ZY_BRSYK set wzjb=1 where syxh=@syxh  
  if @@error<>0 or @@rowcount=0  
  begin  
    rollback tran  
    select "F","审核医嘱更新当前患者危重标志出错！"  
    return  
  end     
 end  
end  
if @config6800='2'--按照yzlb来更新 wzjb  2014-03-06 caoshuang add  for 193728   
begin  
  select  yzlb  into #yzlb_6800 from BQ_LSYZK where 1=2 --创建该病人yzlb临时表  
  insert into #yzlb_6800  
  select yzlb from BQ_LSYZK where syxh=@syxh and yzzt in(1,2) group by yzlb--插入临嘱的所有yzlb  
  insert into #yzlb_6800 --插入长嘱的所有yzlb  
  select yzlb from BQ_CQYZK a where syxh=@syxh and yzzt in(1,2)   
  and not exists(select 1 from BQ_LSYZK b where b.syxh=@syxh and b.yzzt=2 and b.yzlb=9 and b.tzxh=a.xh) --排除有停止医嘱申请的长期医嘱  
  group by yzlb  
  if exists(select 1 from #yzlb_6800 where yzlb=16) and not exists(select 1 from #yzlb_6800 where yzlb=17)--只有16的情况  
  begin  
      update ZY_BRSYK set wzjb=2 where syxh=@syxh   
      if @@error<>0 or @@rowcount=0  
   begin  
   rollback tran  
   select "F","审核医嘱更新当前患者危重标志出错！"  
   return  
   end     
  end  
   if exists(select 1 from #yzlb_6800 where yzlb=17) and not exists(select 1 from #yzlb_6800 where yzlb=16)--只有17的情况  
  begin  
      update ZY_BRSYK set wzjb=3 where syxh=@syxh   
      if @@error<>0 or @@rowcount=0  
   begin  
   rollback tran  
   select "F","审核医嘱更新当前患者危重标志出错！"  
   return  
   end     
  end  
  if exists(select 1 from #yzlb_6800 where yzlb=17)  and  exists(select 1 from #yzlb_6800 where yzlb=16)--17 16共存的情况  
  begin  
      update ZY_BRSYK set wzjb=1 where syxh=@syxh   
      if @@error<>0 or @@rowcount=0  
   begin  
   rollback tran  
   select "F","审核医嘱更新当前患者危重标志出错！"  
   return  
   end     
  end  
   if (not exists(select 1 from #yzlb_6800 where yzlb=17))  and (not exists(select 1 from #yzlb_6800 where yzlb=16))--17 16 都没有的情况  
  begin  
      update ZY_BRSYK set wzjb=0 where syxh=@syxh   
      if @@error<>0 or @@rowcount=0  
   begin  
   rollback tran  
   select "F","审核医嘱更新当前患者危重标志出错！"  
   return  
   end     
  end  
end  
  
--更新辅助表已存在的sfqrxx列数据  
INSERT INTO BQ_LSYZK_FZ(syxh,yzxh,sfqrxx,tgbz)  
select h.syxh,h.xh,1,1  
from BQ_LSYZK h(nolock)  
WHERE  h.syxh = @syxh and h.yzzt=1 and h.gxrq=@now  
 and not exists(select 1 from BQ_LSYZK_FZ g(nolock) where g.syxh=h.syxh and g.yzxh=h.xh)  
  
INSERT INTO BQ_CQYZK_FZ(syxh,yzxh,sfqrxx,tgbz)  
select h.syxh,h.xh,1,1  
from BQ_CQYZK h(nolock)  
WHERE  h.syxh = @syxh and h.yzzt=1 and h.gxrq=@now  
 and not exists(select 1 from BQ_CQYZK_FZ g(nolock) where g.syxh=h.syxh and g.yzxh=h.xh)  
  
UPDATE BQ_LSYZK_FZ SET sfqrxx = 1   
from BQ_LSYZK_FZ g left join BQ_LSYZK h on g.yzxh = h.xh and g.syxh = h.syxh and h.yzzt=1 and h.gxrq=@now  
WHERE  g.syxh = @syxh   
  
UPDATE BQ_CQYZK_FZ SET sfqrxx = 1   
from BQ_CQYZK_FZ g left join BQ_CQYZK h on g.yzxh = h.xh and g.syxh = h.syxh and h.yzzt=1 and h.gxrq=@now  
WHERE  g.syxh = @syxh   
  
if @config6A19 = '4'   
begin  
 UPDATE BQ_LSYZK_FZ SET zxsj1 = case when h.yzlb=7 then convert(varchar(8),dateadd(dd,1,substring(h.ksrq,1,8)+' '+substring(h.ksrq,9,8)),112) + '06:00:00' else (convert(char(8),dateadd(minute,convert(int,@config6A95_ls),substring(h.ksrq,1,8) + ' ' + subs
tring(h.ksrq,9,8)),112)   
  + convert(char(8),dateadd(minute,convert(int,@config6A95_ls),substring(h.ksrq,1,8) + ' ' + substring(h.ksrq,9,8)),8))  end  
 from BQ_LSYZK_FZ g inner join BQ_LSYZK h on g.yzxh = h.xh and g.syxh = h.syxh and h.yzzt=1 and h.gxrq=@now  
 WHERE  g.syxh = @syxh   
  
 UPDATE BQ_CQYZK_FZ SET zxsj1 = convert(char(8),dateadd(minute,convert(int,@config6A95_cq),substring(h.ksrq,1,8) + ' ' + substring(h.ksrq,9,8)),112)   
  + convert(char(8),dateadd(minute,convert(int,@config6A95_cq),substring(h.ksrq,1,8) + ' ' + substring(h.ksrq,9,8)),8)  
 from BQ_CQYZK_FZ g inner join BQ_CQYZK h on g.yzxh = h.xh and g.syxh = h.syxh and h.yzzt=1 and h.gxrq=@now  
 WHERE  g.syxh = @syxh   
end  
  
  
commit tran   --=======●●●事务 结束============================  
  
if @config6A70 <> '0'   
begin  
 --处理医嘱审核批次  
 declare @shxh ut_xh9  
 if (select isnull((select 1  where @now in (select shrq from BQ_YZSHDYRZ where czyh = @czyh)), 0)) = 0  
 begin  
  insert BQ_YZSHDYRZ(czyh,bqdm,dycs,dysj,scdy,shrq) values (@czyh,'',0,'',0,@now)    
  select @shxh=@@IDENTITY    
 end  
 else  
 begin  
  select top 1 @shxh=shpc from BQ_YZSHDYRZ where shrq = @now and czyh = @czyh  
 end  
 insert into BQ_YZSHDYRZMX(shpc,yzbz,xh,syxh,yexh)    
 select @shxh,0,xh,syxh,yexh   
 from BQ_CQYZK (nolock)   
 where syxh=@syxh and yexh=@yexh and xh<=@maxcqyzxh and @config6A70<>'2'    --add by kongwei for 188137  1 全部 2 只显示停止医嘱   
 and (yzzt=1 and xh not in (select xh from BQ_YZSHDYRZMX where  syxh=@syxh and yexh=@yexh and yzbz=0 ) and shczyh=@czyh and shrq = @now)   
  
 insert into BQ_YZSHDYRZMX(shpc,yzbz,xh,syxh,yexh)    
 select @shxh,1,xh,syxh,yexh   
 from BQ_LSYZK (nolock)   
 where syxh=@syxh and yexh=@yexh and xh<=@maxlsyzxh and (yzzt=1 or yzzt=2) and shczyh=@czyh  and shrq = @now  
 and xh not in (select xh from BQ_YZSHDYRZMX where  syxh=@syxh and yexh=@yexh and yzbz=1 )  
 and (@config6A70<>'2' or (@config6A70='2' and yzlb = 9))                   --add by kongwei for 188137  1 全部 2 只显示停止医嘱     
 --处理医嘱审核批次结束    
   
 if not exists(select 1 from BQ_YZSHDYRZMX where shpc = @shxh) --add by kongwei 如果没有对应明细则删除记录 不显示   
        delete from BQ_YZSHDYRZ where shpc = @shxh    
end  
    
--医嘱审核调用移动条码，后期建议加参数控制    
if exists(select 1 from YY_CONFIG(nolock) where id='6971' and config='是')  
begin  
 if @shlb=0 --全部审核    
 begin    
  if (@yzbz = 0) or (@yzbz = -1)     
  begin    
   insert into BQ_YDTMYZJLK(syxh,fzxh,cqlsbz,ydscbz)    
   select a.syxh,a.fzxh,0,0    
   from BQ_LSYZK a(nolock) -- 当前已审核医嘱，且已插入的不再插入    
   where a.syxh=@syxh and a.yzzt=1    
   and not exists (select 1 from BQ_YDTMYZJLK b(nolock) where a.syxh=b.syxh and a.fzxh=b.fzxh and b.cqlsbz=0)    
  end    
  if (@yzbz = 1) or (@yzbz = -1)    
  begin    
   insert into BQ_YDTMYZJLK(syxh,fzxh,cqlsbz,ydscbz)    
   select a.syxh,a.fzxh,1,0    
   from BQ_CQYZK a(nolock)    
   where a.syxh=@syxh and a.yzzt=1    
   and not exists (select 1 from BQ_YDTMYZJLK b(nolock) where a.syxh=b.syxh and a.fzxh=b.fzxh and b.cqlsbz=1)    
  end    
 end    
 else --单医嘱审核    
 begin    
  if @yzbz=0    
  begin    
   insert into BQ_YDTMYZJLK(syxh,fzxh,cqlsbz,ydscbz)    
   select a.syxh,a.fzxh,0,0    
   from BQ_LSYZK a(nolock)    
   where a.syxh=@syxh and a.fzxh=@fzxh and a.yzzt=1    
   and not exists (select 1 from BQ_YDTMYZJLK b(nolock) where a.syxh=b.syxh and a.fzxh=b.fzxh and b.cqlsbz=0)    
  end    
  if @yzbz = 1    
  begin    
   insert into BQ_YDTMYZJLK(syxh,fzxh,cqlsbz,ydscbz)    
   select a.syxh,a.fzxh,1,0    
   from BQ_CQYZK a(nolock)    
   where a.syxh=@syxh and a.fzxh=@fzxh and a.yzzt=1    
   and not exists (select 1 from BQ_YDTMYZJLK b(nolock) where a.syxh=b.syxh and a.fzxh=b.fzxh and b.cqlsbz=1)    
  end    
 end    
 declare @csyxh varchar(12)  
  ,@cfzxh varchar(12)  
  ,@cyzbz varchar(1)  
 declare cs_ydtm cursor for         
 select syxh,fzxh,cqlsbz from BQ_YDTMYZJLK     
 where syxh=@syxh and isnull(ydscbz,0)=0 -- 当前病人移动生成标志为0的，调用移动接口生成条码    
 for read only        
 open cs_ydtm        
 fetch cs_ydtm into @syxh,@fzxh,@yzbz        
 while @@fetch_status=0     
 begin        
  select @csyxh=convert(varchar(12),@syxh)  
   ,@cfzxh=convert(varchar(12),@fzxh)  
   ,@cyzbz=convert(varchar(1),@yzbz)  
  exec('exec usp_nurse_yzzxjl '+@cfzxh+','+@cyzbz)   
  --exec('exec usp_bq_CreatePlanAndBarcode 1,'+@csyxh+','+@cfzxh)  
  fetch cs_ydtm into @syxh,@fzxh,@yzbz    
 end       
 close cs_ydtm        
 deallocate cs_ydtm        
end  
-- end    
  
--if exists(select 1 from sysobjects where name = 'usp_bq_crtdjdyjl')  
--begin  
-- declare @yzxh_wsh ut_xh12  
--  ,@cqlsbz int  
-- declare cs_wshyz cursor for   
--  select a.xh,0 from BQ_LSYZK a inner join #yjm_bq_lsyzk b on a.xh=b.xh   
--  where a.syxh=@syxh and a.yexh=@yexh and a.yzzt in (1,2) and substring(a.shrq,1,10) =substring(@now,1,10)   
--  union all  
--  select a.xh,1 from BQ_CQYZK a inner join #yjm_bq_cqyzk b on a.xh=b.xh   
--  where a.syxh=@syxh and a.yexh=@yexh and a.yzzt = 1  
-- for read only  
-- open cs_wshyz  
-- fetch cs_wshyz into @yzxh_wsh,@cqlsbz  
-- while @@fetch_status=0  
-- begin   
--  exec usp_bq_crtdjdyjl @bz=0   --0 单个医嘱生成  1 批量生产  
--   ,@syxh=@syxh  
--   ,@yexh=@yexh  
--   ,@yzxh=@yzxh_wsh  
--   ,@cqlsbz=@cqlsbz  
--  fetch cs_wshyz into @yzxh_wsh,@cqlsbz  
-- end  
-- close cs_wshyz  
-- deallocate cs_wshyz  
--end  
  
if ((((@configG014 ='是') and (@configG106 ='是')) or ((@config6461='是' or @config6481='是') and @emrsybz=1)) and (@jajbz<>-1))   
begin --- if HHHH start  
 select @fsip=ipdz from YY_USERIP(nolock) where czyh=@czyh  
 select @jsbq=bqdm,@brcw=cwdm,@hzxm=hzxm from ZY_BRSYK (nolock) where syxh=@syxh  
 select @msg=@brcw+'床患者：'+@hzxm+'有新医嘱已审核！'   --默认值  
  
 if (object_id('tempdb..#msgxxlsb') is not null)  
  drop table #msgxxlsb  
    select convert(varchar(4000),'') as bz ,convert(varchar(4000),'') as tsxx into #msgxxlsb where 1=2  
 insert into #msgxxlsb   
 exec('usp_yy_msgmemo 1,' + @syxh + ',' + @yexh)   
 select @msg=tsxx from  #msgxxlsb  
  
    if (@emrsybz=1 and @config6481='是')  
    begin --- if HHHH_aaaa1 start  
  --抗生素医嘱审核用  
  if (@LSfzxh<>'' or @CQfzxh<>'')   
  begin --- if HHHH_aaaa_AA start  
   if (@shyzcount > 0)  
   begin   
    if @configG153='是'   
                    select @execmsg='exec usp_yy_autosendmsg 2,"' + ltrim(rtrim(@czyh)) + '","' + @fsip + '","' + @jsbq + '","' + @msg + '",1,'  
     --@czyh,@fsip,@jsbq,@msg,1  
    else  
                    select @execmsg='exec usp_yy_autosendmsg 2,"' + ltrim(rtrim(@czyh)) + '","' + @fsip + '","' + @jsbq + '","' + @msg + '",0,'  
     --exec usp_yy_autosendmsg 2,@czyh,@fsip,@jsbq,@msg,0  
   end  
  end --- if HHHH_aaaa_AA end  
  else  
  begin --- if HHHH_aaaa_BB start  
   if @configG153='是'   
                select @execmsg='exec usp_yy_autosendmsg 2,"' + ltrim(rtrim(@czyh)) + '","' + @fsip + '","' + @jsbq + '","' + @msg + '",1,'  
    --@czyh,@fsip,@jsbq,@msg,1  
   else  
                select @execmsg='exec usp_yy_autosendmsg 2,"' + ltrim(rtrim(@czyh)) + '","' + @fsip + '","' + @jsbq + '","' + @msg + '",0,'  
/*  
   if @configG153='是'   
    exec usp_yy_autosendmsg 2,@czyh,@fsip,@jsbq,@msg,1  
   else  
    exec usp_yy_autosendmsg 2,@czyh,@fsip,@jsbq,@msg,0  
*/  
  end  --- if HHHH_aaaa_BB end  
        select @execmsg=@execmsg+convert(varchar(10),@jajbz)  
    end --- if HHHH_aaaa1 end  
    else  
    begin --- if HHHH_aaaa2 start  
  --抗生素医嘱审核用  
  if (@LSfzxh<>'' or @CQfzxh<>'')   
  begin  
   if (@shyzcount > 0)  
   begin  
    if @configG153='是'   
     exec usp_yy_autosendmsg 2,@czyh,@fsip,@jsbq,@msg,1,@jajbz  
    else  
     exec usp_yy_autosendmsg 2,@czyh,@fsip,@jsbq,@msg,0,@jajbz  
   end  
  end  
  else  
  begin  
   if @configG153='是'   
    exec usp_yy_autosendmsg 2,@czyh,@fsip,@jsbq,@msg,1,@jajbz  
   else  
    exec usp_yy_autosendmsg 2,@czyh,@fsip,@jsbq,@msg,0,@jajbz  
  end  
    end --- if HHHH_aaaa2 end  
end --- if HHHH end  
  
  
select "T",@shnr,@execmsg  
return  
  


