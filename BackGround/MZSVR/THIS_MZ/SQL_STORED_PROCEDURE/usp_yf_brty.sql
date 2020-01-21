Text
CREATE proc usp_yf_brty  
	@wkdz varchar(32),  
	@jszt smallint,  
	@rqbz smallint,  
	@sjh ut_sjh,  
	@czyh ut_czyh,  
	@yfdm ut_ksdm,  
	@cfxh ut_xh12,  
	@mxxh ut_xh12,  
	@tysl ut_sl10,  
	@cfts int,  
	@tyyy ut_mc32='',  
	@tyys ut_czyh=null,  --退药医生  
	@fzzr ut_czyh=null , --负责主任  
	@tyrq varchar(20)='', --退药日期。  
	@yjs  ut_czyh=null, --药方药剂师
	@memo1 ut_memo='',  --备注1 xq90338
	@memo2 ut_memo='',  --备注2 xq90338
	@tfyydm ut_dm2='', --退药原因代码
	@delphi smallint = 1,	--0=后台调用， 1=前台调用
	@errmsg varchar(500) = null output 
as --集118087 2019-09-27 15:04:36 4.0标准版_201810补丁
/**********  
[版本号]4.0.0.0.0  
[创建时间]2004.11.9  
[作者]王奕  
[版权] Copyright ? 2004-2008上海金仕达-卫宁软件股份有限公司
[描述]药房病人退药  
[功能说明]  
 已发药处方的退药功能，包括门急诊病人和家床病人的退药  
[参数说明]  
	@wkdz varchar(32), 网卡地址  
	@jszt smallint,  结束状态 1=创建表，2=插入，3=递交  
	@rqbz smallint,  日期标志0=日库，1=年库  
	@sjh ut_sjh,  收据号  
	@czyh ut_czyh,  操作员号  
	@yfdm ut_ksdm,  药房代码  
	@cfxh ut_xh12,  处方序号  
	@mxxh ut_xh12,  明细序号  
	@tysl ut_sl10,  退药数量  
	@cfts integer,  处方贴数  
	@tyyy ut_bz  退药原因  
	@tyys ut_czyh=null,  --退药医生  
	@fzzr ut_czyh=null , --负责主任  
	@tyrq varchar(20)='', --退药日期。  
	@yjs  ut_czyh=null --药方药剂师
[返回值]  
[结果集、排序]  
[调用的sp]  
[调用实例]  
[修改记录]  
 yxp 2006-6-23 关于停用的判断放到后台实现  
xiaoyan 2007-5-17 新增原开方医生 ，退药医生  ，退药开方日期  ，负责主任  ， 退药日期。  
xiaoyan 2007-7-2  原开方医生 ，退药开方日期  变量不需要传进来。
mly 2007-09-15 兼容药品4.5接口  操作代码变更
yxp 2007-10-26 松江区公立医院药品零差率HIS实现
yxp 2007-10-31 松江区公立医院药品零差率HIS实现:增加SF_CFMXK.yylsj的传出
yxp 2007-10-31 松江区公立医院药品零差率门诊药房修改：yylsj不再使用，现取SF_CFMXK.lcjsdj'零差结算单价'，打印时传出lcjsdj，原来的修改作废
JL 2008-03-23 增加开关3117的控制，实现在药房退费的时候加库存
add by mly 2008-09-19 增加门诊发药账单3007参数打开后扣库存同时更新SF_MZFYZD.jzbz =1 否则库存减了，台帐没有更新
mly 2010-10-14 修复BUG 门诊发药账单使用jssjh 会产生重复扣库存的情况，改用xh + jzbz = 0 来过滤。
xwm 2011-07-26 增加药房批次管理
xwm 2011-12-29 处方单与发药单的迁移可能不同步，因此取退药信息直接使用视图
xwm 2012-02-23 退药原因@tyyy类型ut_bz不对，应为ut_dm2
liu_ke 2012-09-13 增加多零售价处理
liu_ke 2012-12-04 处理同处方存在相同药品时的退药问题
caoshuang 2012-03-20 退药原因@tyyy改为ut_memo 支持退药原因手写。参数3207控制
**********/  
set nocount on  

CREATE TABLE [#result](
	[rettype] [varchar](1)  NULL,
	[retmsg] [varchar](500)  NULL,--sjh
	[sjh] [ut_sjh]  NULL,
	[ypmc] [ut_mc256]  NULL,
	[ypgg] [ut_mc256] NULL,
	[ypdj] [numeric](12, 4) NULL,
	tysl ut_sl10 NULL,
	[sl]  ut_sl10 NULL,
	[ypdw] [ut_mc32]  NULL,
	tyje ut_je14 NULL,
	[lsje] ut_je14 NULL,
	[发票号] [int] NULL,
	[门诊号] [ut_blh] NULL,
	[姓名] [ut_mc64] NULL,
	[卡号] [ut_cardno] NULL,
	[性别] [ut_mc64] NULL,
	[年龄] varchar(50) NULL,
	[开方科室] [ut_mc64] NULL,
	[诊断] [ut_zdmc] NULL,
	[lrrq] [ut_rq16]  NULL,
	[zxrq] [ut_rq16] NULL,
	tysl1 ut_sl10 NULL,
	[ypsl1] ut_sl10 NULL,
	[lcjsdj]  [ut_money] NULL,
	xh  ut_xh12 NULL,--处方明细序号
	[mxxh]  ut_xh12 NULL,
	[zje] [ut_money] NULL,
	[ypsl2] ut_sl10 NULL,
	[cfts] [smallint]  NULL,
	[cfxh] ut_xh12  NULL,
	[ypyf] [varchar](500) NULL,
	[memo1] [ut_mc256] NULL,
	[memo2] [ut_mc256] NULL
)

declare @now ut_rq16  --当前时间    
select @now=convert(char(8),getdate(),112)+convert(char(8),getdate(),8)  
declare @m2550 varchar(2)
select @m2550=isnull(config,'否') from YY_CONFIG where id='2550'  

declare @patid ut_xh12,	@errmsg50 varchar(50)
--add liu_ke 2012-09-13 for 多零售价
declare @ypxtslt int--药品系统标志:0统一价格 1进价加权平均 2多进价 3多零售价
select @ypxtslt=dbo.f_get_ypxtslt() 
if @@error<>0 or @ypxtslt not in(0,1,2,3)
begin
	select @errmsg='F获取药品系统方案出错！'
    goto err
end

if exists(select 1 from YF_YFDMK a(nolock) where a.id=@yfdm and isnull(a.zdyjtzwcbz,0)=1)
begin
	select @errmsg='F药房正在台账自动月结状态，不能进行其它库存操作！'
    goto err
end

if not exists(select 1 from YF_TJQSZ a(nolock) where a.yfdm=@yfdm and a.jzbz=0)
begin
	select @errmsg='F药房未启用，不能进行库存操作！'
    goto err
end

declare @config3117 varchar(20)
select @config3117=config from YY_CONFIG(nolock) where id='3117'
if not (isnull(@config3117,'')='是' or isnull(@config3117,'')='否')
begin
	select @errmsg='F3117参数未正确配置！'
    goto err
end

--if (@ypxtslt=2) and (@config3117<>'是') 
--begin
--   select @errmsg='F多进价模式3117参数必须配置成是！'
--   goto err
--end

if (@ypxtslt=3) and (@config3117<>'是') 
begin
   select @errmsg='F多零售价模式3117参数必须配置成是！'
   goto err
end

declare @config3249 varchar(2)
select @config3249='否'
select @config3249 = isnull(config,'否') from YY_CONFIG(nolock) where id ='3249' 
if (ltrim(rtrim(isnull(@config3249,'')))='')
begin
    select @config3249='否'
end 

if not (isnull(@config3249,'')='是' or isnull(@config3249,'')='否')
begin
	select @errmsg='F3249参数未正确配置！'
    goto err
end

declare @config3291 varchar(2)
select @config3291='否'
select @config3291 = isnull(config,'否') from YY_CONFIG(nolock) where id ='3291' 
if (ltrim(rtrim(isnull(@config3291,'')))='')
begin
    select @config3291='否'
end 
if not (isnull(@config3291,'')='是' or isnull(@config3291,'')='否')
begin
	select @errmsg='F3291参数未正确配置！'
    goto err
end

if (@ypxtslt in(3)) and (@config3249='是')
begin
   select @errmsg='F多零售价模式3249参数必须配置为否！'
   goto err
end

if (@ypxtslt in(3)) and (@config3291='是')
begin
   select @errmsg='F多零售价模式3249参数必须配置为否！'
   goto err
end 

if (@config3291='是') and  (@config3249='是')
begin
   select @errmsg='F参数3291和3249不可以同时为是！'
   goto err
end

declare @config0325 varchar(2)
select @config0325='否'
select @config0325=config from YY_CONFIG(nolock) where id='0325'
if (ltrim(rtrim(isnull(@config0325,'')))='')
begin
    select @config0325='否'
end 
if not (isnull(@config0325,'')='是' or isnull(@config0325,'')='否')
begin
   select @errmsg='F0325参数未正确配置！'
   goto err
end

declare @config3414 varchar(2)
select @config3414='否'
select @config3414=config from YY_CONFIG(nolock) where id='3414'
if (@ypxtslt<>2) or ((ltrim(rtrim(isnull(@config3414,'')))=''))
begin
    select @config3414='否'
end 

declare @config3554 varchar(20)
select @config3554=config from YY_CONFIG(nolock) where id='3554'
if not (isnull(@config3554,'')='是' or isnull(@config3554,'')='否')
begin
    select @config3554='否'
end

declare @cnt int,@isnb ut_bz

declare @cfxh0 ut_xh12,--首次处方
        @curr_sychxh ut_xh12,--当前剩余处方
        @lbcfxh ut_xh12, --链表处方
        @lbcfxh_type ut_bz, --链表处方类型   0剩余 1红冲
        @lbcfxh_isnb ut_bz, --年表标志 0否 1是年表
        @lbtxh ut_xh12 --退序号

declare @lbfyzdxh ut_xh12, --链表发药单序号
        @lbfyzdxh_czdm ut_dm2, --链表发药单操作类别  09发药 10退药 
        @lbfyzdxh_jzbz ut_bz, --链表发药单记账标志
        @lbfyzdxh_isnb ut_bz, --链表发药单年表标志 0否 1是年表
        @lbfyzdxh_memo ut_memo, --链表发药单memo
        @lbfyzdxh_cfdybz ut_bz --链表发药单处方对应标志

declare @ypmc ut_mc64 

declare @cfmx_tmxxh ut_xh12,@cfmx_tmxxh_dycfxh ut_xh12 --处方明细 退明细序号   及 退明细序号对应的处方序号

declare @tmpxh ut_xh12 

declare @error int, @rowcount int

declare @maxloop ut_xh12
declare @yb_fymxxh ut_xh12,@tmp_fymxxh ut_xh12,@tmp_tfymxxh ut_xh12 


 --mly 2007-09-15
declare @czdm varchar(2)      --操作代码变量
if exists(select 1 from xtdldm where xtdldm='3' and vertion='4.5')     
select @czdm = '32'
else
select @czdm = '10'

declare @xhtemp ut_xh12	--发药帐单序号

declare @config3183 ut_bz
select @config3183=0
select @config3183=isnull(config,0) from YY_CONFIG (nolock) where id='3183'

--生成递交的临时表  
declare @tablename varchar(32)  
select @tablename='##yfty'+ltrim(rtrim(isnull(@wkdz,'')))+ltrim(rtrim(isnull(@czyh,'')))
  
if @jszt=1  
begin  
	exec('if exists(select * from tempdb..sysobjects where name="'+@tablename+'")  
	drop table '+@tablename)  
	exec('create table '+@tablename+'(  
	cfxh ut_xh12 not null,  
	mxxh ut_xh12 not null,  
	cfts int not null,  
	tysl ut_sl10 not null 
	,memo1 ut_memo null
	,memo2 ut_memo null 
	)')  
	if @@error<>0  
	begin  
		select @errmsg='创建临时表时出错！'
        goto err  
	end  

	delete from #result
	insert into #result(rettype,retmsg) select 'T' rettype,'' retmsg
	goto success 
end  
--插入递交的记录  
if @jszt=2  
begin  
	declare @ccfxh varchar(12),  
			@cmxxh varchar(12),  
			@ccfts varchar(8),  
			@ctysl varchar(12)  

	select  @ccfxh=convert(varchar(12),@cfxh),  
			@cmxxh=convert(varchar(12),@mxxh),  
			@ccfts=convert(varchar(8),@cfts),  
			@ctysl=convert(varchar(12),@tysl)  

	exec('insert into '+@tablename+' values('+@ccfxh+','+@cmxxh+','+@ccfts+','+@ctysl+',"'+@memo1+'","'+@memo2+'"'+')')  
	if @@error<>0 
	begin  
		select @errmsg='插入临时表时出错！'
        goto err  
	end  

	delete from #result
	insert into #result(rettype,retmsg) select 'T' rettype,'' retmsg
	goto success  
end  
  
if @jszt=3  --- if @jszt=3   start
begin 
 
declare @acfdfp ut_bz       --是否按处方打发票 0 不是， 1 是  
if (select config from YY_CONFIG (nolock) where id='2044')='否' 
begin 
   select @acfdfp=0 
end  
else
begin  
   select @acfdfp=1
end  
  
 --开始插入账单、明细表的处理流程  
 create table #cfmx_tf  
 (  
  cfxh ut_xh12 not null,  
  mxxh ut_xh12 not null,  
  cfts int not null,  
  tysl ut_sl10 not null 
  ,memo1 ut_memo null
  ,memo2 ut_memo null  
 )  
   
 exec('insert into #cfmx_tf select * from '+@tablename)  
 if @@error<>0   
 begin  
    select @errmsg='F插入临时表时出错！'
    goto err 
 end  
   
 exec('drop table '+@tablename)  
 
 --多零售价模式下使用此表来记录收费时每个批次的价格
 create table #mzmxpcxxjlb
 (
  xh ut_xh12 identity not null,
  yfpcxh ut_xh12 not null,
  yplsj ut_money not null
 )
  
 select distinct cfxh, cfts 
 into #mzcf_tf 
 from #cfmx_tf (nolock) 

 --判断当前要退的药品，是不是目前最后一次有效剩余处方start
 select distinct cfxh,convert(smallint,-1) isnb --是否年表标志 0否 1是  -1未知
 into #tycfxhlist 
 from #cfmx_tf (nolock)

 update #tycfxhlist set isnb=0  --日表
 from SF_MZCFK a(nolock),#tycfxhlist b
 where a.xh=b.cfxh

 select @cnt=count(1) from #tycfxhlist b(nolock) where isnb=-1
 if isnull(@cnt,0)>0
 begin
	update #tycfxhlist set isnb=1 --年表
	from SF_NMZCFK a(nolock),#tycfxhlist b
	where a.xh=b.cfxh 
 end

 select @cnt=count(1) from #tycfxhlist b(nolock) where isnb=-1
 if isnull(@cnt,0)>0
 begin
    select @errmsg='F处方数据不存在！'
    goto err 
 end
 
 select @cnt=count(1) from #tycfxhlist b(nolock) where isnb=1
 if isnull(@cnt,0)>0 --有年表数据
 begin
   select top 1 @patid=a.patid from VW_MZCFK a(nolock) inner join #tycfxhlist b(nolock) on a.xh=b.cfxh
   if exists (select 1 from VW_MZCFK a(nolock),#tycfxhlist b(nolock) where a.xh=b.cfxh and a.jlzt=1 and a.patid=@patid )
   begin
	   select @errmsg='F当前处方已进行部分退费，不能进行退药0！'
       goto err   
   end
   if exists(select 1 from (
     select b.cfxh,count(1) jls from VW_MZCFK a(nolock),#tycfxhlist b(nolock)
     where a.xh=b.cfxh and a.jlzt=0 and a.patid=@patid  --是不是目前最后一次有效剩余处方
     group by b.cfxh ) t1 where t1.jls<>1)
   begin
	   select @errmsg='F当前处方不能进行退药1！'
       goto err  
   end
 end
 else -- 无年表数据
 begin
   select top 1 @patid=a.patid from SF_MZCFK a(nolock) inner join #tycfxhlist b(nolock) on a.xh=b.cfxh
   if exists (select 1 from SF_MZCFK a(nolock),#tycfxhlist b(nolock) where a.xh=b.cfxh and a.jlzt=1 and a.patid=@patid )
   begin
	   select @errmsg='F当前处方已进行部分退费，不能进行退药0！'
       goto err  
   end
   
   if exists(select 1 from (
     select b.cfxh,count(1) jls from SF_MZCFK a(nolock),#tycfxhlist b(nolock)
     where a.xh=b.cfxh and a.jlzt=0 and a.patid=@patid --是不是目前最后一次有效剩余处方
     group by b.cfxh ) t1 where t1.jls<>1)
   begin
	   select @errmsg='F当前处方不能进行退药1！'
       goto err   
   end   
 end
 --判断当前要退的药品，是不是目前最后一次有效剩余处方end
 
--begin判断退费锁定标志，如果当前处方被退费处锁定，则不允许进行退药或是取消退药操作
 if exists(select 1 from VW_MZCFK a(nolock) inner join #tycfxhlist b(nolock) on a.xh=b.cfxh
            where isnull(a.tfsdbz,0)=1 and a.jlzt=0 and a.patid=@patid )
 begin
	   select @errmsg='F当前处方被退费处锁定,不能进行退药7！'
       goto err 
 end        
--end判断退费锁定标志，如果当前处方被退费处锁定，则不允许进行退药或是取消退药操作

--begin判断病人退药是否判断允许退药标志
declare @config3326 varchar(10)
select @config3326='否'
select @config3326=isnull(config,'否') from YY_CONFIG (nolock) where id='3326'
if (@config3326='是')
begin
    if exists (select 1 from VW_MZCFK a(nolock) inner join #tycfxhlist b(nolock) on a.xh=b.cfxh
      where ISNULL(a.yxtybz,0)=0 and a.jlzt=0 and a.patid=@patid )
    begin
	   select @errmsg='F当前有处方未被审核通过，请先审核通过后再允许退药！'
       goto err      
    end           
end
--end判断病人退药是否判断允许退药标志


--创建处方链表start
--处方链表
create table #tmp_cflianb(
recno ut_xh12  identity(1,1) not null,
cfxh0 ut_xh12 null,--首次处方
curr_sychxh ut_xh12 null,--当前剩余处方
lbcfxh ut_xh12 null, --链表处方
lbcfxh_type ut_bz null, --链表处方类型   0剩余 1红冲
lbcfxh_isnb ut_bz null  --年表标志 0否 1是年表
)
--处方链表倒序
create table #tmp_cflianb_daoxu(
recno ut_xh12  identity(1,1) not null,
cfxh0 ut_xh12 null,--首次处方
curr_sychxh ut_xh12 null,--当前剩余处方
lbcfxh ut_xh12 null, --链表处方
lbcfxh_type ut_bz null, --链表处方类型   0剩余 1红冲
lbcfxh_isnb ut_bz null, --年表标志 0否 1是年表
dy_fyzdxh_czdm ut_dm2 null --对应发药单操作类别  09发药 10退药 
)

--处方链表对应发药单
create table #tmp_cflianb_tmpdyfyd(
recno ut_xh12  identity(1,1) not null,
cfxh0 ut_xh12 null,--首次处方
curr_sychxh ut_xh12 null,--当前剩余处方
lbcfxh ut_xh12 null, --链表处方
lbcfxh_type ut_bz null, --链表处方类型   0剩余 1红冲
lbcfxh_isnb ut_bz null, --年表标志 0否 1是年表
dy_fyzdxh ut_xh12 null, --对应发药单序号
dy_fyzdxh_czdm ut_dm2 null, --对应发药单操作类别  09发药 10退药 
dy_fyzdxh_isnb ut_bz null, --对应发药单年表标志 0否 1是年表
dy_fyzdxh_memo ut_memo null, --对应发药单memo
dy_fyzdxh_cfdybz ut_bz null --对应发药单处方对应标志
)
create table #tmp_cflianb_dyfyd(
recno ut_xh12  identity(1,1) not null,
cfxh0 ut_xh12 null,--首次处方
curr_sychxh ut_xh12 null,--当前剩余处方
lbcfxh ut_xh12 null, --链表处方
lbcfxh_type ut_bz null, --链表处方类型   0剩余 1红冲
lbcfxh_isnb ut_bz null, --年表标志 0否 1是年表
dy_fyzdxh ut_xh12 null, --对应发药单序号
dy_fyzdxh_czdm ut_dm2 null, --对应发药单操作类别  09发药 10退药 
dy_fyzdxh_isnb ut_bz null, --对应发药单年表标志 0否 1是年表
dy_fyzdxh_memo ut_memo null, --对应发药单memo
dy_fyzdxh_cfdybz ut_bz null --对应发药单处方对应标志
)

create table #tycfxhlist_order
(
  cfxh ut_xh12 null,
  isnb ut_bz null
)
delete from #tycfxhlist_order

create table #tmp_sytk_pc_cfmx3183_order
(
yfpcxh ut_xh12 null,
sykt_ypsl ut_sl10 null
)
delete from #tmp_sytk_pc_cfmx3183_order

INSERT into #tycfxhlist_order(cfxh,isnb)
select cfxh,isnb from #tycfxhlist(nolock) 
order by cfxh

declare cs_crbflb cursor 
for select cfxh,isnb from #tycfxhlist_order(nolock) 
for read only
   
open cs_crbflb
fetch cs_crbflb into @cfxh,@isnb
while @@fetch_status=0
begin  --游标开始
   select @lbtxh=0
   if @isnb=0
     select @lbtxh=txh from SF_MZCFK a(nolock) where xh=@cfxh and a.patid=@patid
   else
     select @lbtxh=txh from VW_MZCFK a(nolock) where xh=@cfxh and a.patid=@patid
   if isnull(@lbtxh,0)=0  ---- if isnull(@lbtxh,0)=0 start
   begin
     --没有退序号，说明是首次处方，只有剩余，无红冲
     --当前剩余
     select @cfxh0=@cfxh, @lbcfxh=@cfxh,@lbcfxh_type=0,@lbcfxh_isnb=@isnb
     if isnull(@lbcfxh,0)>0
     begin
       --每一个剩余都插两遍 一个09 一个10 先放着，后面再删
       insert into #tmp_cflianb_daoxu(cfxh0,curr_sychxh,lbcfxh,lbcfxh_type,lbcfxh_isnb,dy_fyzdxh_czdm)
       select @cfxh0,@lbcfxh,@lbcfxh,@lbcfxh_type,@lbcfxh_isnb,'10'
       insert into #tmp_cflianb_daoxu(cfxh0,curr_sychxh,lbcfxh,lbcfxh_type,lbcfxh_isnb,dy_fyzdxh_czdm)
       select @cfxh0,@lbcfxh,@lbcfxh,@lbcfxh_type,@lbcfxh_isnb,'09'
     end
   end  ---- if isnull(@lbtxh,0)=0 end
   else
   begin ---- if isnull(@lbtxh,0)<>0 start
      select @lbcfxh=@cfxh --当前剩余
      --从当前剩余开始倒推
      while(@lbtxh>0) --while start
      begin
         --剩余
         if exists(select 1 from SF_MZCFK a(nolock) where txh=@lbtxh and xh=@lbcfxh and a.patid=@patid)
           select @lbcfxh=xh,@lbcfxh_type=0,@lbcfxh_isnb=0 from SF_MZCFK a(nolock) where txh=@lbtxh and xh=@lbcfxh and a.patid=@patid
         else
           select @lbcfxh=xh,@lbcfxh_type=0,@lbcfxh_isnb=1 from VW_MZCFK a(nolock) where txh=@lbtxh and xh=@lbcfxh and a.patid=@patid
         if isnull(@lbcfxh,0)>0
         begin
           --每一个剩余都插两遍 一个09 一个10 先放着，后面再删
           insert into #tmp_cflianb_daoxu(curr_sychxh,lbcfxh,lbcfxh_type,lbcfxh_isnb,dy_fyzdxh_czdm)
           select @cfxh,@lbcfxh,@lbcfxh_type,@lbcfxh_isnb,'10'
           insert into #tmp_cflianb_daoxu(curr_sychxh,lbcfxh,lbcfxh_type,lbcfxh_isnb,dy_fyzdxh_czdm)
           select @cfxh,@lbcfxh,@lbcfxh_type,@lbcfxh_isnb,'09'
         end
         --红冲
         if exists(select 1 from SF_MZCFK a(nolock) where a.patid=@patid and a.txh=@lbtxh and a.xh<>@lbcfxh)
           select @lbcfxh=xh,@lbcfxh_type=1,@lbcfxh_isnb=0 from SF_MZCFK a(nolock) where a.patid=@patid and a.txh=@lbtxh and a.xh<>@lbcfxh
         else
         begin
            if exists(select 1 from VW_MZCFK a(nolock) where a.patid=@patid and a.txh=@lbtxh and a.xh<>@lbcfxh)
              select @lbcfxh=xh,@lbcfxh_type=1,@lbcfxh_isnb=1 from VW_MZCFK a(nolock) where a.patid=@patid and a.txh=@lbtxh and a.xh<>@lbcfxh
            else
              select @lbcfxh=0
         end
         if isnull(@lbcfxh,0)>0
         begin
           insert into #tmp_cflianb_daoxu(curr_sychxh,lbcfxh,lbcfxh_type,lbcfxh_isnb)
           select @cfxh,@lbcfxh,@lbcfxh_type,@lbcfxh_isnb
         end
 
         --@lbtxh未重新赋值前，表示上一次剩余
         --查找上一次剩余，是否有txh,如果没有，表示已到首次处方，如果有需继续循环
         select @lbcfxh=0
         select @lbtxh=txh,@lbcfxh=xh,@lbcfxh_isnb=0 from SF_MZCFK a(nolock) where xh=@lbtxh and a.patid=@patid
         if isnull(@lbcfxh,0)=0
         begin
           select @lbtxh=txh,@lbcfxh=xh,@lbcfxh_isnb=1 from VW_MZCFK a(nolock) where xh=@lbtxh and a.patid=@patid
         end
         if @lbcfxh=0 
         begin
           select @lbtxh=0
         end
         if isnull(@lbtxh,0)=0 --表示已到首次处方，插入一个剩余即可
         begin
             --每一个剩余都插两遍 一个09 一个10 先放着，后面再删
            insert into #tmp_cflianb_daoxu(curr_sychxh,lbcfxh,lbcfxh_type,lbcfxh_isnb,dy_fyzdxh_czdm)
            select @cfxh,@lbcfxh,0,@lbcfxh_isnb,'10' 
            insert into #tmp_cflianb_daoxu(curr_sychxh,lbcfxh,lbcfxh_type,lbcfxh_isnb,dy_fyzdxh_czdm)
            select @cfxh,@lbcfxh,0,@lbcfxh_isnb,'09' 
            update #tmp_cflianb_daoxu set cfxh0=@lbcfxh where curr_sychxh=@cfxh
         end
      end --while end
   end  ---- if isnull(@lbtxh,0)<>0 end
   fetch cs_crbflb into @cfxh,@isnb  
end   --游标结束
close cs_crbflb
deallocate cs_crbflb

insert into #tmp_cflianb(cfxh0,curr_sychxh,lbcfxh,lbcfxh_type,lbcfxh_isnb)
select distinct cfxh0,curr_sychxh,lbcfxh,lbcfxh_type,lbcfxh_isnb 
from #tmp_cflianb_daoxu (nolock)
order by cfxh0,curr_sychxh,lbcfxh

insert into #tmp_cflianb_tmpdyfyd(cfxh0,curr_sychxh,lbcfxh,lbcfxh_type,lbcfxh_isnb,dy_fyzdxh_czdm)
select cfxh0,curr_sychxh,lbcfxh,lbcfxh_type,lbcfxh_isnb,dy_fyzdxh_czdm 
from #tmp_cflianb_daoxu (nolock)
order by recno desc
--创建处方链表end

--select * from #tmp_cflianb
--select * from #tmp_cflianb_tmpdyfyd
--return

--创建发药单链表start
--发药单链表
create table #tmp_fydlianb(
recno ut_xh12  identity(1,1) not null,
cfxh0 ut_xh12 null,--首次处方
curr_sychxh ut_xh12 null,--当前剩余处方
lbcfxh ut_xh12 null, --链表处方
lbfyzdxh ut_xh12 null, --链表发药单序号
lbfyzdxh_czdm ut_dm2 null, --链表发药单操作类别  09发药 10退药 
lbfyzdxh_jzbz ut_bz null, --链表发药单记账标志
lbfyzdxh_isnb ut_bz null, --链表发药单年表标志 0否 1是年表
lbfyzdxh_memo ut_memo null, --链表发药单memo
lbfyzdxh_cfdybz ut_bz null --链表发药单处方对应标志
)

select xh as lbfyzdxh,jzbz as lbfyzdxh_jzbz,0 lbfyzdxh_isnb,
      convert(varchar(10),'') as lbfyzdxh_czdm,memo as lbfyzdxh_memo,
	  cfdybz as lbfyzdxh_cfdybz 
into #tmp_getfydlist
from YF_NMZFYZD (nolock)
where 1=2

--select * from #tmp_getfydlist
--return

create table #tmp_cflianb_order
(
  cfxh0 ut_xh12 null,
  curr_sychxh ut_xh12 null,
  lbcfxh ut_xh12 null,
  lbcfxh_isnb ut_bz null
)
delete from #tmp_cflianb_order

create table #tmp_pdktsl_ff2_order
(
  cfxh ut_xh12 null,
  mxxh ut_xh12 null,
  lbcfxh_isnb ut_bz null
)
delete from #tmp_pdktsl_ff2_order


INSERT into #tmp_cflianb_order
( cfxh0,curr_sychxh, lbcfxh,lbcfxh_isnb)
select cfxh0,curr_sychxh,lbcfxh,lbcfxh_isnb 
from #tmp_cflianb (nolock) 
order by recno

declare cs_crfydlb cursor 
for select a.cfxh0,a.curr_sychxh,a.lbcfxh,a.lbcfxh_isnb 
from #tmp_cflianb_order a(nolock) 

for read only

open cs_crfydlb
fetch cs_crfydlb into @cfxh0,@curr_sychxh,@lbcfxh,@lbcfxh_isnb
while @@fetch_status=0
begin  --游标开始
   delete from #tmp_getfydlist
   if @lbcfxh_isnb=0 --//假如处方表和发药表迁移一致
   begin
     insert into #tmp_getfydlist
     select xh as lbfyzdxh,jzbz as lbfyzdxh_jzbz,0 lbfyzdxh_isnb,'' as lbfyzdxh_czdm ,memo as lbfyzdxh_memo,cfdybz as lbfyzdxh_cfdybz 
     from YF_MZFYZD a(nolock) 
	 where cfxh=@lbcfxh  and tfbz in(0,1) and jlzt=0 and a.patid=@patid --add by guo 1207
     update #tmp_getfydlist set lbfyzdxh_czdm=b.czdm
     from #tmp_getfydlist a,YF_MZFYMX b(nolock)
     where a.lbfyzdxh=b.fyxh 
   end
   select @cnt=count(1) from #tmp_getfydlist
   if isnull(@cnt,0)=0--查年表
   begin
     insert into #tmp_getfydlist
     select xh as lbfyzdxh,jzbz as lbfyzdxh_jzbz,0 lbfyzdxh_isnb,'' as lbfyzdxh_czdm,memo as lbfyzdxh_memo,cfdybz as lbfyzdxh_cfdybz 
     from VW_MZFYZD a(nolock) 
	 where cfxh=@lbcfxh and tfbz in(0,1) and jlzt=0 and a.patid=@patid --add by guo 1207
     update #tmp_getfydlist set lbfyzdxh_czdm=b.czdm
     from #tmp_getfydlist a,VW_MZFYMX b(nolock)
     where a.lbfyzdxh=b.fyxh
   end
   select @cnt=count(1) from #tmp_getfydlist
   if isnull(@cnt,0)>0
   begin
     insert into #tmp_fydlianb(cfxh0,curr_sychxh,lbcfxh,lbfyzdxh,lbfyzdxh_jzbz,lbfyzdxh_isnb,lbfyzdxh_czdm,lbfyzdxh_memo,lbfyzdxh_cfdybz)
     select @cfxh0,@curr_sychxh,@lbcfxh,lbfyzdxh,lbfyzdxh_jzbz,lbfyzdxh_isnb,lbfyzdxh_czdm,lbfyzdxh_memo,lbfyzdxh_cfdybz
     from #tmp_getfydlist
     order by lbfyzdxh
   end
   fetch cs_crfydlb into @cfxh0,@curr_sychxh,@lbcfxh,@lbcfxh_isnb 
end   --游标结束
close cs_crfydlb
deallocate cs_crfydlb
--创建发药单链表end

--更新处方链表中对应的发药单start
update #tmp_cflianb_tmpdyfyd set dy_fyzdxh=b.lbfyzdxh,dy_fyzdxh_czdm=b.lbfyzdxh_czdm,dy_fyzdxh_isnb=b.lbfyzdxh_isnb,
                        dy_fyzdxh_memo=b.lbfyzdxh_memo,dy_fyzdxh_cfdybz=b.lbfyzdxh_cfdybz
 from #tmp_cflianb_tmpdyfyd a,#tmp_fydlianb b
where a.cfxh0=b.cfxh0 and a.curr_sychxh=b.curr_sychxh and a.lbcfxh=b.lbcfxh  and isnull(a.dy_fyzdxh_czdm,'')=b.lbfyzdxh_czdm

update #tmp_cflianb_tmpdyfyd set dy_fyzdxh=b.lbfyzdxh,dy_fyzdxh_czdm=b.lbfyzdxh_czdm,dy_fyzdxh_isnb=b.lbfyzdxh_isnb,
                        dy_fyzdxh_memo=b.lbfyzdxh_memo,dy_fyzdxh_cfdybz=b.lbfyzdxh_cfdybz
 from #tmp_cflianb_tmpdyfyd a,#tmp_fydlianb b
where a.cfxh0=b.cfxh0 and a.curr_sychxh=b.curr_sychxh and a.lbcfxh=b.lbcfxh  and isnull(a.dy_fyzdxh_czdm,'')=''


--剩余处方，删除没有对应的退药
delete #tmp_cflianb_tmpdyfyd
  from #tmp_cflianb_tmpdyfyd a
where lbcfxh_type=0 and isnull(dy_fyzdxh,0)=0 and isnull(dy_fyzdxh_czdm,'')='10'

update #tmp_cflianb_tmpdyfyd set dy_fyzdxh_czdm=null
  from #tmp_cflianb_tmpdyfyd a
where lbcfxh_type=0 and isnull(dy_fyzdxh,0)=0


insert into #tmp_cflianb_dyfyd(cfxh0,curr_sychxh,lbcfxh,lbcfxh_type,lbcfxh_isnb,dy_fyzdxh,dy_fyzdxh_czdm,dy_fyzdxh_isnb,dy_fyzdxh_memo,dy_fyzdxh_cfdybz)
select cfxh0,curr_sychxh,lbcfxh,lbcfxh_type,lbcfxh_isnb,dy_fyzdxh,dy_fyzdxh_czdm,dy_fyzdxh_isnb,dy_fyzdxh_memo,dy_fyzdxh_cfdybz
from #tmp_cflianb_tmpdyfyd
order by recno

--更新处方链表中对应的发药单end

----发药单链表中完整数据（发药账单及明细，并区分是否会影响库存）start

select memo into #tmp_memo from (select  '红冲后补发药' memo union select '部分退药补完红冲' memo) t1

select cfdybz into #tmp_cfdybz from 
(select  1 cfdybz --1部分退药
 union 
 select  2 cfdybz --2医保兑付
 union 
 select  3 cfdybz --3家床结算
) t1

select xh,jssjh,cfxh,patid,yfdm,sfrq,sfczry,pyrq,pyczry,fyrq,fyczyh,cfts,tfbz,tfqrbz,jzbz,
jlzt,tfxh,memo,ejygbz,tfys,zrys,yfyjs,fybz,jjje,jqpjjj_je,yszbz,cfdybz
into #tmp_mzfyzd_data from YF_NMZFYZD where 1=2

select xh,fyxh,czdm,cfxh,mxxh,cd_idm,gg_idm,ypmc,ypdm,ypgg,ykxs,ypdw,dwxs,ylsj,ypfj,jxce,
cfts,ypsl,memo,jjje,mztybz,tfymxxh,lsje,jqpjjj_je,cfdybz,wsbz,CONVERT(numeric(12,0),0) as fymxxh0 --首次发药明细序号 
into #tmp_mzfymx_data from YF_NMZFYMX where 1=2

select xh,jssjh,cfxh,patid,yfdm,sfrq,sfczry,pyrq,pyczry,fyrq,fyczyh,cfts,tfbz,tfqrbz,jzbz,
jlzt,tfxh,memo,ejygbz,tfys,zrys,yfyjs,fybz,jjje,jqpjjj_je,yszbz,cfdybz 
into #tmp_mzfyzd_data_valid from YF_NMZFYZD where 1=2

select xh,fyxh,czdm,cfxh,mxxh,cd_idm,gg_idm,ypmc,ypdm,ypgg,ykxs,ypdw,dwxs,ylsj,ypfj,jxce,
cfts,ypsl,memo,jjje,mztybz,tfymxxh,lsje,jqpjjj_je,cfdybz,wsbz,CONVERT(numeric(12,0),0) as fymxxh0 --首次发药明细序号 
into #tmp_mzfymx_data_valid from YF_NMZFYMX where 1=2

insert into #tmp_mzfyzd_data(xh,jssjh,cfxh,patid,yfdm,sfrq,sfczry,pyrq,pyczry,fyrq,fyczyh,cfts,tfbz,tfqrbz,jzbz,
jlzt,tfxh,memo,ejygbz,tfys,zrys,yfyjs,fybz,jjje,jqpjjj_je,yszbz,cfdybz)
select b.xh,b.jssjh,b.cfxh,b.patid,b.yfdm,b.sfrq,b.sfczry,b.pyrq,b.pyczry,b.fyrq,b.fyczyh,b.cfts,b.tfbz,b.tfqrbz,b.jzbz,
b.jlzt,b.tfxh,b.memo,b.ejygbz,b.tfys,b.zrys,b.yfyjs,b.fybz,b.jjje,b.jqpjjj_je,b.yszbz,b.cfdybz
from #tmp_fydlianb a,YF_MZFYZD b(nolock)
where a.lbfyzdxh=b.xh and b.tfbz in(0,1) and b.jlzt=0 and b.patid=@patid --1207 guo

insert into #tmp_mzfymx_data(xh,fyxh,czdm,cfxh,mxxh,cd_idm,gg_idm,ypmc,ypdm,ypgg,ykxs,ypdw,dwxs,ylsj,ypfj,jxce,
cfts,ypsl,memo,jjje,mztybz,tfymxxh,lsje,jqpjjj_je,cfdybz,wsbz )
select c.xh,c.fyxh,c.czdm,c.cfxh,c.mxxh,c.cd_idm,c.gg_idm,c.ypmc,c.ypdm,c.ypgg,c.ykxs,c.ypdw,c.dwxs,
c.ylsj,c.ypfj,c.jxce,c.cfts,c.ypsl,c.memo,c.jjje,c.mztybz,c.tfymxxh,c.lsje,c.jqpjjj_je,c.cfdybz,
isnull(c.wsbz,0) as wsbz
from #tmp_fydlianb a,YF_MZFYZD b(nolock),YF_MZFYMX c(nolock)
where a.lbfyzdxh=b.xh and b.xh=c.fyxh and b.tfbz in(0,1)and b.jlzt=0 and b.patid=@patid --1207 guo

if exists(select 1 from #tmp_fydlianb a
where not exists(select 1 from  #tmp_mzfyzd_data b where a.lbfyzdxh=b.xh))
begin
  insert into #tmp_mzfyzd_data(xh,jssjh,cfxh,patid,yfdm,sfrq,sfczry,pyrq,pyczry,fyrq,fyczyh,cfts,tfbz,tfqrbz,jzbz,
jlzt,tfxh,memo,ejygbz,tfys,zrys,yfyjs,fybz,jjje,jqpjjj_je,yszbz,cfdybz)
  select b.xh,b.jssjh,b.cfxh,b.patid,b.yfdm,b.sfrq,b.sfczry,b.pyrq,b.pyczry,b.fyrq,b.fyczyh,b.cfts,b.tfbz,b.tfqrbz,b.jzbz,
  b.jlzt,b.tfxh,b.memo,b.ejygbz,b.tfys,b.zrys,b.yfyjs,b.fybz,b.jjje,b.jqpjjj_je,b.yszbz,b.cfdybz
  from #tmp_fydlianb a,VW_MZFYZD b(nolock)
  where a.lbfyzdxh=b.xh and not exists(select 1 from  #tmp_mzfyzd_data c where a.lbfyzdxh=c.xh)
  and b.tfbz in(0,1)and b.jlzt=0 and b.patid=@patid

  insert into #tmp_mzfymx_data(xh,fyxh,czdm,cfxh,mxxh,cd_idm,gg_idm,ypmc,ypdm,ypgg,ykxs,ypdw,dwxs,ylsj,ypfj,jxce,
  cfts,ypsl,memo,jjje,mztybz,tfymxxh,lsje,jqpjjj_je,cfdybz,wsbz )
  select c.xh,c.fyxh,c.czdm,c.cfxh,c.mxxh,c.cd_idm,c.gg_idm,c.ypmc,c.ypdm,c.ypgg,c.ykxs,c.ypdw,c.dwxs,
  c.ylsj,c.ypfj,c.jxce,c.cfts,c.ypsl,c.memo,c.jjje,c.mztybz,c.tfymxxh,c.lsje,c.jqpjjj_je,c.cfdybz,
  isnull(c.wsbz,0) as wsbz
  from #tmp_fydlianb a,VW_MZFYZD b(nolock),VW_MZFYMX c(nolock)
  where a.lbfyzdxh=b.xh and b.xh=c.fyxh  and not exists(select 1 from #tmp_mzfymx_data x1 where x1.xh=c.xh )
  and b.tfbz in(0,1)and b.jlzt=0  and b.patid=@patid   
end

-- #tmp_mzfymx_data 首次发药明细序号 更新 start
select @maxloop=COUNT(1) from #tmp_mzfymx_data
select @maxloop=ISNULL(@maxloop,0)

declare cs_fymxxh0 cursor 
for select xh from #tmp_mzfymx_data(nolock)
for read only

open cs_fymxxh0
fetch cs_fymxxh0 into @yb_fymxxh
while @@fetch_status=0
begin  --游标开始
  select @tmp_fymxxh=0,@tmp_tfymxxh=0
  select @tmp_fymxxh=xh,@tmp_tfymxxh=tfymxxh from #tmp_mzfymx_data where xh=@yb_fymxxh
  select @tmp_tfymxxh=isnull(@tmp_tfymxxh,0)
  while(@tmp_tfymxxh>0 and @maxloop>0)
  begin
     select @tmp_fymxxh=xh,@tmp_tfymxxh=tfymxxh from #tmp_mzfymx_data where xh=@tmp_tfymxxh
     select @tmp_tfymxxh=isnull(@tmp_tfymxxh,0)
     select @maxloop=@maxloop-1
  end
  update #tmp_mzfymx_data set fymxxh0=isnull(@tmp_fymxxh,0) where xh=@yb_fymxxh 
 fetch cs_fymxxh0 into @yb_fymxxh 
end   --游标结束
close cs_fymxxh0
deallocate cs_fymxxh0
-- #tmp_mzfymx_data 首次发药明细序号 更新 end

select  recno,cfxh0,curr_sychxh,lbcfxh,lbfyzdxh,lbfyzdxh_jzbz,lbfyzdxh_isnb,lbfyzdxh_czdm,
lbfyzdxh_memo,lbfyzdxh_cfdybz into #tmp_fydlianb_valid 
from #tmp_fydlianb a
where not exists(select 1 from #tmp_memo w1 where w1.memo=a.lbfyzdxh_memo)
and not exists(select 1 from #tmp_cfdybz w2 where w2.cfdybz=a.lbfyzdxh_cfdybz)


insert into #tmp_mzfyzd_data_valid(xh,jssjh,cfxh,patid,yfdm,sfrq,sfczry,pyrq,pyczry,fyrq,fyczyh,cfts,tfbz,tfqrbz,jzbz,
jlzt,tfxh,memo,ejygbz,tfys,zrys,yfyjs,fybz,jjje,jqpjjj_je,yszbz,cfdybz )
select a.xh,a.jssjh,a.cfxh,a.patid,a.yfdm,a.sfrq,a.sfczry,a.pyrq,a.pyczry,a.fyrq,a.fyczyh,a.cfts,a.tfbz,a.tfqrbz,a.jzbz,
a.jlzt,a.tfxh,a.memo,a.ejygbz,a.tfys,a.zrys,a.yfyjs,a.fybz,a.jjje,a.jqpjjj_je,a.yszbz,a.cfdybz
from #tmp_mzfyzd_data a(nolock)
where exists(select 1 from #tmp_fydlianb_valid b(nolock) where b.lbfyzdxh=a.xh)

insert into #tmp_mzfymx_data_valid
(xh,fyxh,czdm,cfxh,mxxh,cd_idm,gg_idm,ypmc,ypdm,ypgg,ykxs,ypdw,dwxs,ylsj,ypfj,jxce,
cfts,ypsl,memo,jjje,mztybz,tfymxxh,lsje,jqpjjj_je,cfdybz )
select xh,fyxh,czdm,cfxh,mxxh,cd_idm,gg_idm,ypmc,ypdm,ypgg,ykxs,ypdw,dwxs,ylsj,ypfj,jxce,
cfts,ypsl,memo,jjje,mztybz,tfymxxh,lsje,jqpjjj_je,cfdybz 
from #tmp_mzfymx_data a(nolock)
where exists(select 1 from #tmp_fydlianb_valid b(nolock) where b.lbfyzdxh=a.fyxh)
----发药单链表中完整数据（发药账单及明细，并区分是否会影响库存）end


--当前要退的处方数据 start
-- currtycfts  currtysl是前台录入的数量(单帖数量)，★typsl是最小单位数量（单帖数量） 
select xh,jssjh,hjxh,cfxh,czyh,lrrq,patid,hzxm,ybdm,py,wb,ysdm,
ksdm,yfdm,qrczyh,qrrq,qrksdm,pyczyh,pyrq,cfts,txh,sfckdm,pyckdm,
fyckdm,jsbz,jlzt,fybz,cflx,sycfbz,tscfbz,pybz,jcxh,memo,zje,zfyje,
yhje,zfje,srje,fph,fpjxh,tfbz,tfje,fyckxh,sqdxh,yflsh,ejygksdm,
ejygbz,ksfyzd_xh,dpxsbz,pyqr,zpwzbh,zpbh,fptfbz,fptfje,xzks_id,
ylxzbh,ydybz,tmqrbz_yf,tmhdbz,ghxh,gxrq,wsbz
into #tmp_currty_mzcfk_data 
from SF_NMZCFK(nolock) where 1=2

select @cfts currtycfts,@tysl currtysl,@tysl typsl,
xh,cfxh,cd_idm,gg_idm,dxmdm,ypmc,ypdm,ypgg,ypdw,dwxs,ykxs,ypfj,ylsj,ypsl,ts,cfts,zfdj,yhdj,
memo,shbz,flzfdj,txbl,lcxmdm,lcxmmc,zbz,yjqrbz,qrczyh,qrrq,yylsj,qrksdm,clbz,hjmxxh,hy_idm,
hy_pdxh,gbfwje,gbfwwje,gbtsbz,gbtsbl,fpzh,bgdh,bgzt,txzt,hzlybz,bglx,lcxmsl,dydm,yyrq,yydd,
zysx,lcjsdj,yjspbz,sbid,sbclbz,ktsl,tjbz,sqdgroupno,ssbfybz,zje,tmxxh,wsbz,cfts as wsts
into #tmp_currty_cfmx_data 
from SF_NCFMXK(nolock) where 1=2

if exists(select 1 from #tmp_cflianb a(nolock),#cfmx_tf b(nolock)
where a.lbcfxh=b.cfxh and a.lbcfxh_isnb=0)
begin
	insert into #tmp_currty_mzcfk_data(xh,jssjh,hjxh,cfxh,czyh,lrrq,patid,hzxm,ybdm,py,wb,ysdm,
	ksdm,yfdm,qrczyh,qrrq,qrksdm,pyczyh,pyrq,cfts,txh,sfckdm,pyckdm,
	fyckdm,jsbz,jlzt,fybz,cflx,sycfbz,tscfbz,pybz,jcxh,memo,zje,zfyje,
	yhje,zfje,srje,fph,fpjxh,tfbz,tfje,fyckxh,sqdxh,yflsh,ejygksdm,
	ejygbz,ksfyzd_xh,dpxsbz,pyqr,zpwzbh,zpbh,fptfbz,fptfje,xzks_id,
	ylxzbh,ydybz,tmqrbz_yf,tmhdbz,ghxh,gxrq,wsbz)
	select b.xh,b.jssjh,b.hjxh,b.cfxh,b.czyh,b.lrrq,b.patid,b.hzxm,b.ybdm,b.py,b.wb,b.ysdm,
	b.ksdm,b.yfdm,b.qrczyh,b.qrrq,b.qrksdm,b.pyczyh,b.pyrq,b.cfts,b.txh,b.sfckdm,b.pyckdm,
	b.fyckdm,b.jsbz,b.jlzt,b.fybz,b.cflx,b.sycfbz,b.tscfbz,b.pybz,b.jcxh,b.memo,b.zje,b.zfyje,
	b.yhje,b.zfje,b.srje,b.fph,b.fpjxh,b.tfbz,b.tfje,b.fyckxh,b.sqdxh,b.yflsh,b.ejygksdm,
	b.ejygbz,b.ksfyzd_xh,b.dpxsbz,b.pyqr,b.zpwzbh,b.zpbh,b.fptfbz,b.fptfje,b.xzks_id,
	b.ylxzbh,b.ydybz,b.tmqrbz_yf,b.tmhdbz,b.ghxh,b.gxrq,isnull(b.wsbz,0) as wsbz
	from #cfmx_tf a(nolock),SF_MZCFK b(nolock) 
	where a.cfxh=b.xh and b.patid=@patid
  
	insert into #tmp_currty_cfmx_data(currtycfts,currtysl,typsl,
	xh,cfxh,cd_idm,gg_idm,dxmdm,ypmc,ypdm,ypgg,ypdw,dwxs,ykxs,ypfj,ylsj,ypsl,ts,cfts,zfdj,yhdj,
	memo,shbz,flzfdj,txbl,lcxmdm,lcxmmc,zbz,yjqrbz,qrczyh,qrrq,yylsj,qrksdm,clbz,hjmxxh,hy_idm,
	hy_pdxh,gbfwje,gbfwwje,gbtsbz,gbtsbl,fpzh,bgdh,bgzt,txzt,hzlybz,bglx,lcxmsl,dydm,yyrq,yydd,
	zysx,lcjsdj,yjspbz,sbid,sbclbz,ktsl,tjbz,sqdgroupno,ssbfybz,zje,tmxxh,wsbz,wsts)
	select a.cfts,a.tysl,a.tysl*b.dwxs,
	b.xh,b.cfxh,b.cd_idm,b.gg_idm,b.dxmdm,b.ypmc,b.ypdm,b.ypgg,b.ypdw,b.dwxs,b.ykxs,b.ypfj,b.ylsj,b.ypsl,b.ts,b.cfts,b.zfdj,b.yhdj,
	b.memo,b.shbz,b.flzfdj,b.txbl,b.lcxmdm,b.lcxmmc,b.zbz,b.yjqrbz,b.qrczyh,b.qrrq,b.yylsj,b.qrksdm,b.clbz,b.hjmxxh,b.hy_idm
	,b.hy_pdxh,b.gbfwje,b.gbfwwje,b.gbtsbz,b.gbtsbl,b.fpzh,b.bgdh,b.bgzt,b.txzt,b.hzlybz,b.bglx,b.lcxmsl,b.dydm,b.yyrq,b.yydd,
	b.zysx,b.lcjsdj,b.yjspbz,b.sbid,b.sbclbz,b.ktsl,b.tjbz,b.sqdgroupno,b.ssbfybz,b.zje,b.tmxxh,
	isnull(b.wsbz,0),isnull(c.wsts,0)
	from #cfmx_tf a(nolock),SF_CFMXK b(nolock),SF_MZCFK c(nolock) 
	where a.mxxh=b.xh and b.cfxh=c.xh and c.patid=@patid
end

if exists(select 1 from #cfmx_tf a
where not exists(select 1 from #tmp_currty_cfmx_data b where a.mxxh=b.xh))
begin
	insert into #tmp_currty_mzcfk_data(xh,jssjh,hjxh,cfxh,czyh,lrrq,patid,hzxm,ybdm,py,wb,ysdm,
	ksdm,yfdm,qrczyh,qrrq,qrksdm,pyczyh,pyrq,cfts,txh,sfckdm,pyckdm,
	fyckdm,jsbz,jlzt,fybz,cflx,sycfbz,tscfbz,pybz,jcxh,memo,zje,zfyje,
	yhje,zfje,srje,fph,fpjxh,tfbz,tfje,fyckxh,sqdxh,yflsh,ejygksdm,
	ejygbz,ksfyzd_xh,dpxsbz,pyqr,zpwzbh,zpbh,fptfbz,fptfje,xzks_id,
	ylxzbh,ydybz,tmqrbz_yf,tmhdbz,ghxh,gxrq,wsbz)
	select b.xh,b.jssjh,b.hjxh,b.cfxh,b.czyh,b.lrrq,b.patid,b.hzxm,b.ybdm,b.py,b.wb,b.ysdm,
	b.ksdm,b.yfdm,b.qrczyh,b.qrrq,b.qrksdm,b.pyczyh,b.pyrq,b.cfts,b.txh,b.sfckdm,b.pyckdm,
	b.fyckdm,b.jsbz,b.jlzt,b.fybz,b.cflx,b.sycfbz,b.tscfbz,b.pybz,b.jcxh,b.memo,b.zje,b.zfyje,
	b.yhje,b.zfje,b.srje,b.fph,b.fpjxh,b.tfbz,b.tfje,b.fyckxh,b.sqdxh,b.yflsh,b.ejygksdm,
	b.ejygbz,b.ksfyzd_xh,b.dpxsbz,b.pyqr,b.zpwzbh,b.zpbh,b.fptfbz,b.fptfje,b.xzks_id,
	b.ylxzbh,b.ydybz,b.tmqrbz_yf,b.tmhdbz,b.ghxh,b.gxrq,isnull(b.wsbz,0) as wsbz
	from #cfmx_tf a(nolock),VW_MZCFK b(nolock) 
    where a.cfxh=b.xh and b.patid=@patid
	and not exists(select 1 from #tmp_currty_mzcfk_data x(nolock) where x.xh=b.xh)
 
	insert into #tmp_currty_cfmx_data(currtycfts,currtysl,typsl,
	xh,cfxh,cd_idm,gg_idm,dxmdm,ypmc,ypdm,ypgg,ypdw,dwxs,ykxs,ypfj,ylsj,ypsl,ts,cfts,zfdj,yhdj,
	memo,shbz,flzfdj,txbl,lcxmdm,lcxmmc,zbz,yjqrbz,qrczyh,qrrq,yylsj,qrksdm,clbz,hjmxxh,hy_idm,
	hy_pdxh,gbfwje,gbfwwje,gbtsbz,gbtsbl,fpzh,bgdh,bgzt,txzt,hzlybz,bglx,lcxmsl,dydm,yyrq,yydd,
	zysx,lcjsdj,yjspbz,sbid,sbclbz,ktsl,tjbz,sqdgroupno,ssbfybz,zje,tmxxh,wsbz,wsts)
	select a.cfts,a.tysl,a.tysl*b.dwxs,
	b.xh,b.cfxh,b.cd_idm,b.gg_idm,b.dxmdm,b.ypmc,b.ypdm,b.ypgg,b.ypdw,b.dwxs,b.ykxs,b.ypfj,b.ylsj,b.ypsl,b.ts,b.cfts,b.zfdj,b.yhdj,
	b.memo,b.shbz,b.flzfdj,b.txbl,b.lcxmdm,b.lcxmmc,b.zbz,b.yjqrbz,b.qrczyh,b.qrrq,b.yylsj,b.qrksdm,b.clbz,b.hjmxxh,b.hy_idm
	,b.hy_pdxh,b.gbfwje,b.gbfwwje,b.gbtsbz,b.gbtsbl,b.fpzh,b.bgdh,b.bgzt,b.txzt,b.hzlybz,b.bglx,b.lcxmsl,b.dydm,b.yyrq,b.yydd,
	b.zysx,b.lcjsdj,b.yjspbz,b.sbid,b.sbclbz,b.ktsl,b.tjbz,b.sqdgroupno,b.ssbfybz,b.zje,b.tmxxh,isnull(b.wsbz,0) as wsbz,
	isnull(c.wsts,0) as wsts
	from #cfmx_tf a(nolock),VW_MZCFMXK b(nolock),VW_MZCFK c(nolock) 
	where a.mxxh=b.xh and b.cfxh=c.xh and c.patid=@patid
	and not exists(select 1 from #tmp_currty_cfmx_data x(nolock) where x.xh=b.xh)
end

if exists(select 1 from #cfmx_tf a(nolock)
where not exists(select 1 from #tmp_currty_cfmx_data b(nolock) 
where a.mxxh=b.xh and a.cfts=b.currtycfts and a.tysl=b.currtysl))
begin
   select @errmsg='F检索当前要退的处方数据出错！'
   goto err 
end

--当前要退的处方数据 end

--判断当前要退处方明细是否已经已经生成 发药明细，已生成的，不可再次生成 start
if exists(select 1 from(
select a.mxxh,count(1) jls
 from #tmp_mzfymx_data_valid a(nolock)
where  exists(select 1 from #tmp_currty_cfmx_data b(nolock) where a.mxxh=b.xh )
group by a.mxxh having count(1)>1) t1)
begin
	select @errmsg='F当前处方已进行退药确认，不可重复确认！'
    goto err 
end
--判断当前要退处方明细是否已经已经生成 发药明细，已生成的，不可再次生成 end

select cd_idm,@tysl ytsl,@tysl ktsl into #tmp_pdktsl_ff1 
from #tmp_currty_cfmx_data 
where 1=2

insert into #tmp_pdktsl_ff1
select cd_idm,sum(currtycfts*typsl) ytsl,0 ktsl
from #tmp_currty_cfmx_data
group by cd_idm

update #tmp_pdktsl_ff1 set ktsl=t2.ktsl
from #tmp_pdktsl_ff1 t1,(select cd_idm,sum(cfts*ypsl) ktsl 
from #tmp_mzfymx_data_valid 
group by cd_idm) t2
where t1.cd_idm=t2.cd_idm


if exists(select 1 from #tmp_pdktsl_ff1(nolock) where ytsl>ktsl)
begin
   select top 1 @ypmc=b.ypmc from #tmp_pdktsl_ff1 a(nolock),YK_YPCDMLK b(nolock) 
   where a.cd_idm=b.idm and a.ytsl>a.ktsl 

   select @errmsg='F'+isnull(@ypmc,'')+',超过可退数量！'
   goto err
end

--判断方法2 mxxh (主要出现在，一个处方中，出现同一种药品)
select convert(numeric(12,0),xh) as mxxh,cd_idm,@tysl ytsl,@tysl ktsl into #tmp_pdktsl_ff2 from #tmp_currty_cfmx_data where 1=2

insert into #tmp_pdktsl_ff2
select xh,cd_idm,sum(currtycfts*typsl) ytsl,0 ktsl
from #tmp_currty_cfmx_data (nolock)
group by xh,cd_idm

--获取当前要退的处方明细对应的发药单明细链表 start
select @mxxh currty_mxxh,xh,fyxh,czdm,cfxh,mxxh,cd_idm,gg_idm,ypmc,
        ypdm,ypgg,ykxs,ypdw,dwxs,ylsj,ypfj,jxce,
        cfts,ypsl,memo,jjje,mztybz,tfymxxh,lsje,jqpjjj_je,cfdybz 
into #tmp_currty_fycfmx_lianb 
from #tmp_mzfymx_data where 1=2 

delete from #tmp_pdktsl_ff2_order
INSERT into #tmp_pdktsl_ff2_order(cfxh,mxxh,lbcfxh_isnb)
select b.cfxh,a.mxxh,c.lbcfxh_isnb
from #tmp_pdktsl_ff2 a(nolock),#tmp_currty_cfmx_data b(nolock),#tmp_cflianb c(nolock)
where a.mxxh=b.xh and b.cfxh=c.lbcfxh
order by b.cfxh,a.mxxh

 declare cs_crtycfmxlb cursor 
 for select a.cfxh,a.mxxh,a.lbcfxh_isnb
     from #tmp_pdktsl_ff2_order a(nolock)

 for read only
   
 open cs_crtycfmxlb
 fetch cs_crtycfmxlb into @cfxh,@mxxh,@isnb
 while @@fetch_status=0
 begin  --游标开始    
    insert into #tmp_currty_fycfmx_lianb (currty_mxxh,xh,fyxh,czdm,cfxh,mxxh,cd_idm,gg_idm,ypmc,ypdm,ypgg,ykxs,ypdw,dwxs,ylsj,ypfj,jxce,
	cfts,ypsl,memo,jjje,mztybz,tfymxxh,lsje,jqpjjj_je,cfdybz)
    select @mxxh,a.xh,a.fyxh,a.czdm,a.cfxh,a.mxxh,a.cd_idm,a.gg_idm,a.ypmc,a.ypdm,a.ypgg,a.ykxs,a.ypdw,a.dwxs,a.ylsj,a.ypfj,a.jxce,
	a.cfts,a.ypsl,a.memo,a.jjje,a.mztybz,a.tfymxxh,a.lsje,a.jqpjjj_je,a.cfdybz
	from #tmp_mzfymx_data_valid a (nolock)
    where mxxh=@mxxh and not exists (select 1 from #tmp_currty_fycfmx_lianb b (nolock) where b.xh=a.xh)

    select @tmpxh=0
    if @isnb=0
      select @tmpxh=isnull(tmxxh,0) from SF_CFMXK(nolock) where xh=@mxxh 
    else
      select @tmpxh=isnull(tmxxh,0) from VW_MZCFMXK(nolock) where xh=@mxxh   
    select @cfmx_tmxxh=isnull(@tmpxh,0)
    if (isnull(@cfmx_tmxxh,0)>0)
    begin
       insert into #tmp_currty_fycfmx_lianb (currty_mxxh,xh,fyxh,czdm,cfxh,mxxh,cd_idm,gg_idm,ypmc,ypdm,ypgg,ykxs,ypdw,dwxs,ylsj,ypfj,jxce,
		cfts,ypsl,memo,jjje,mztybz,tfymxxh,lsje,jqpjjj_je,cfdybz)
       select @mxxh,a.xh,a.fyxh,a.czdm,a.cfxh,a.mxxh,a.cd_idm,a.gg_idm,a.ypmc,a.ypdm,a.ypgg,a.ykxs,a.ypdw,a.dwxs,a.ylsj,a.ypfj,a.jxce,
		a.cfts,a.ypsl,a.memo,a.jjje,a.mztybz,a.tfymxxh,a.lsje,a.jqpjjj_je,a.cfdybz 
	   from #tmp_mzfymx_data_valid a
       where mxxh=@cfmx_tmxxh and not exists (select 1 from #tmp_currty_fycfmx_lianb b where b.xh=a.xh) 
    end
    while(isnull(@cfmx_tmxxh,0)>0)--while start
    begin 
       select @cfmx_tmxxh_dycfxh=0
       select top 1 @cfmx_tmxxh_dycfxh=cfxh from #tmp_mzfymx_data where mxxh=@cfmx_tmxxh
       if isnull(@cfmx_tmxxh_dycfxh,0)=0
       begin
         select @cfmx_tmxxh_dycfxh=cfxh from VW_MZCFMXK where xh=@cfmx_tmxxh
       end
       select @isnb=-1
       select top 1 @isnb=lbcfxh_isnb from #tmp_cflianb where lbcfxh=@cfmx_tmxxh_dycfxh
       select @tmpxh=0
       if @isnb=0
         select @tmpxh=isnull(tmxxh,0),@cfmx_tmxxh_dycfxh=cfxh from SF_CFMXK(nolock) where xh=@cfmx_tmxxh
       else
         select @tmpxh=isnull(tmxxh,0),@cfmx_tmxxh_dycfxh=cfxh from VW_MZCFMXK(nolock) where xh=@cfmx_tmxxh
       select @cfmx_tmxxh=isnull(@tmpxh,0)
       if (isnull(@cfmx_tmxxh,0)>0)
       begin
         insert into #tmp_currty_fycfmx_lianb (currty_mxxh,xh,fyxh,czdm,cfxh,mxxh,cd_idm,gg_idm,ypmc,ypdm,ypgg,ykxs,ypdw,dwxs,ylsj,ypfj,jxce,
		 cfts,ypsl,memo,jjje,mztybz,tfymxxh,lsje,jqpjjj_je,cfdybz)
         select @mxxh,a.xh,a.fyxh,a.czdm,a.cfxh,a.mxxh,a.cd_idm,a.gg_idm,a.ypmc,a.ypdm,a.ypgg,a.ykxs,a.ypdw,a.dwxs,a.ylsj,a.ypfj,a.jxce,
		 a.cfts,a.ypsl,a.memo,a.jjje,a.mztybz,a.tfymxxh,a.lsje,a.jqpjjj_je,a.cfdybz 
		 from #tmp_mzfymx_data_valid a(nolock)
         where a.mxxh=@cfmx_tmxxh and not exists (select 1 from #tmp_currty_fycfmx_lianb b where b.xh=a.xh) 
       end
    end  --while end
    fetch cs_crtycfmxlb into @cfxh,@mxxh,@isnb 
 end   --游标结束
 close cs_crtycfmxlb
 deallocate cs_crtycfmxlb
 --获取当前要退的处方明细对应的发药单明细链表 end

update #tmp_pdktsl_ff2 set ktsl=t2.ktsl
from #tmp_pdktsl_ff2 t1,(select currty_mxxh,cd_idm,sum(cfts*ypsl) ktsl 
from #tmp_currty_fycfmx_lianb
group by currty_mxxh,cd_idm) t2
where t1.mxxh=t2.currty_mxxh and t1.cd_idm=t2.cd_idm


if exists(select 1 from #tmp_pdktsl_ff1(nolock) where ytsl>ktsl)
begin
   select top 1 @ypmc=b.ypmc from #tmp_pdktsl_ff1 a,YK_YPCDMLK b(nolock) 
   where a.cd_idm=b.idm and a.ytsl>a.ktsl 
   select @errmsg='F'+isnull(@ypmc,'')+',超过可退数量.！'
   goto err
end

--判断可退数量end

select xh,jssjh,hjxh,cfxh,czyh,lrrq,patid,hzxm,ybdm,py,wb,ysdm,ksdm,yfdm,qrczyh,qrrq,qrksdm,pyczyh,pyrq,
	cfts,txh,sfckdm,pyckdm,fyckdm,jsbz,jlzt,fybz,cflx,sycfbz,tscfbz,pybz,jcxh,memo,zje,zfyje,yhje,zfje,srje,
	fph,fpjxh,tfbz,tfje,fyckxh,sqdxh,yflsh,ejygksdm,ejygbz,ksfyzd_xh,dpxsbz,pyqr,zpwzbh,zpbh,fptfbz,fptfje,
	xzks_id,ylxzbh,ydybz,tmqrbz_yf,tmhdbz,ghxh,gxrq,wsbz,tcfts,0 gfbz 
into #mzcfk 
from
	(select distinct a.xh,a.jssjh,a.hjxh,a.cfxh,a.czyh,a.lrrq,a.patid,a.hzxm,a.ybdm,a.py,a.wb,a.ysdm,a.ksdm,a.yfdm,a.qrczyh,a.qrrq,a.qrksdm,a.pyczyh,a.pyrq,
	a.cfts,a.txh,a.sfckdm,a.pyckdm,a.fyckdm,a.jsbz,a.jlzt,a.fybz,a.cflx,a.sycfbz,a.tscfbz,a.pybz,a.jcxh,a.memo,a.zje,a.zfyje,a.yhje,a.zfje,a.srje,
	a.fph,a.fpjxh,a.tfbz,a.tfje,a.fyckxh,a.sqdxh,a.yflsh,a.ejygksdm,a.ejygbz,a.ksfyzd_xh,a.dpxsbz,a.pyqr,a.zpwzbh,a.zpbh,a.fptfbz,a.fptfje,
	a.xzks_id,a.ylxzbh,a.ydybz,a.tmqrbz_yf,a.tmhdbz,a.ghxh,a.gxrq,isnull(a.wsbz,0) as wsbz,b.currtycfts as tcfts 
	from #tmp_currty_mzcfk_data a(nolock),#tmp_currty_cfmx_data b(nolock)
	where a.xh=b.cfxh ) tbl
select @error=@@error,@rowcount=@@rowcount  
if @error<>0  
begin  
	select @errmsg='F读取退药处方时出错！'
    goto err    
end 
if @rowcount = 0 
begin  
	select @errmsg='F未找到退药处方！'
    goto err     
end  
---
 if  @ypxtslt in (0,1) ---处理膏方标识
begin
   if exists (select 1 from YY_CONFIG where id='3430' and config ='是')
   begin 
    update a set gfbz=1 
    from #mzcfk a inner join SF_MZCFK b(nolock) on a.xh=b.xh
    where (b.xdfxh is not null) and (b.dyxdf_idm is not null) and b.patid=@patid

   end
end
    
    select xh,jssjh,hjxh,cfxh,czyh,lrrq,patid,hzxm,ybdm,py,wb,ysdm,ksdm,yfdm,qrczyh,qrrq,qrksdm,pyczyh,pyrq,
	cfts,txh,sfckdm,pyckdm,fyckdm,jsbz,jlzt,fybz,cflx,sycfbz,tscfbz,pybz,jcxh,memo,zje,zfyje,yhje,zfje,srje,
	fph,fpjxh,tfbz,tfje,fyckxh,sqdxh,yflsh,ejygksdm,ejygbz,ksfyzd_xh,dpxsbz,pyqr,zpwzbh,zpbh,fptfbz,fptfje,
	xzks_id,ylxzbh,ydybz,tmqrbz_yf,tmhdbz,ghxh,gxrq,wsbz,tcfts,1 gfbz,cfxh fyxh 
	into #mzcfk_gf from #mzcfk where gfbz=1
    update #mzcfk_gf set fyxh=0

---

select distinct a.currtycfts,a.currtysl,a.typsl,
  a.xh,a.cfxh,a.cd_idm,a.gg_idm,a.dxmdm,a.ypmc,a.ypdm,a.ypgg,a.ypdw,a.dwxs,a.ykxs,a.ypfj,a.ylsj,a.ypsl,a.ts,a.cfts,a.zfdj,a.yhdj,
  a.memo,a.shbz,a.flzfdj,a.txbl,a.lcxmdm,a.lcxmmc,a.zbz,a.yjqrbz,a.qrczyh,a.qrrq,a.yylsj,a.qrksdm,a.clbz,a.hjmxxh,a.hy_idm,
  a.hy_pdxh,a.gbfwje,a.gbfwwje,a.gbtsbz,a.gbtsbl,a.fpzh,a.bgdh,a.bgzt,a.txzt,a.hzlybz,a.bglx,a.lcxmsl,a.dydm,a.yyrq,a.yydd,
  a.zysx,a.lcjsdj,a.yjspbz,a.sbid,a.sbclbz,a.ktsl,a.tjbz,a.sqdgroupno,a.ssbfybz,a.zje,a.tmxxh, 
  b.cfts as tcfts,c.jjje as jxce,b.mxxh,--此处的c.jjje as jxce作为定义字段用，后面会重新计算
  c.ypsl as fysl,c.jjje,c.xh as fymxxh,c.memo as fymxmemo,a.wsbz,a.wsts
  into #cfmxk   
  from #tmp_currty_cfmx_data a (nolock), #cfmx_tf b,#tmp_mzfymx_data c(nolock),#tmp_mzfyzd_data d(nolock)   
  where b.cfxh=a.cfxh and b.mxxh=a.xh  and a.xh=c.mxxh and c.fyxh=d.xh and d.jlzt=0
select @error=@@error,@rowcount=@@rowcount 
 if @error<>0   
 begin  
	select @errmsg='F读取退药处方明细时出错！'
    goto err    
 end
 if @rowcount = 0  
 begin  
	select @errmsg='F未找到退药处方明细！'
    goto err     
 end
   if  exists(
    select 1 from #cfmxk a inner join #mzcfk_gf b  on a.cfxh =b.xh  
    inner join SF_CFMXK c(nolock) on a.xh=c.xh  where a.currtysl<>c.ypsl or a.currtycfts<>c.cfts)
    begin
	  select @errmsg='F膏方药品必须要全退！'
      goto err    
    end
    if  exists(  
     select 1 from SF_CFMXK a inner join #mzcfk_gf b  on a.cfxh =b.xh   where a.xh not in (select xh from #cfmxk))
     begin
	  select @errmsg='F膏方药品必须要全退！'
      goto err    
     end
if exists(select 1 from 
(select cd_idm,sum(typsl) typsl from #tmp_currty_cfmx_data (nolock) group by cd_idm) t1,
(select cd_idm,sum(typsl) typsl from #cfmxk (nolock) group by cd_idm) t2
where t1.cd_idm=t2.cd_idm and t1.typsl<>t2.typsl)
begin
  select @errmsg='F生成退药明细重复,不允许退药！'
  goto err
end

 --yxp add 2006-6-23  增加功能：停用的药品不允许退  
 if exists(select 1 from #cfmxk a(nolock), YK_YPCDMLK b(nolock) where a.cd_idm=b.idm and b.tybz=1)  
 begin  
  set rowcount 1  
  select @errmsg='F'+'药品['+isnull(b.ypmc,'')+']已停用，不能做退药操作！'
  from  #cfmxk a(nolock), YK_YPCDMLK b(nolock) where a.cd_idm=b.idm and b.tybz=1
  select @errmsg='F'+substring(isnull(@errmsg,''),2,499)
  goto err  
 end  

 update #cfmxk 
 set    jxce=b.typsl*a.jxce/a.ypsl,
        jjje=convert(numeric(14,2),b.typsl*a.jjje/a.ypsl)
 from #tmp_mzfymx_data a(nolock),#cfmxk b 
 where a.mxxh=b.mxxh and a.cd_idm=b.cd_idm 
 if @@error<>0  
 begin  
	select @errmsg='F读取退药处方明细金额时出错！'
    goto err    
 end   
 
begin transaction ---★★★★事务开始★★★★  
    --删除发药明细
     select b.fyxh,b.xh as fymxxh
     into #fymx_del
     from YF_MZFYZD a(nolock),YF_MZFYMX b(nolock),#cfmxk c
     where a.xh=b.fyxh and b.mxxh=c.xh and a.cfxh=c.cfxh and a.jssjh=@sjh and a.tfbz=1 and a.tfqrbz=0 and a.jlzt=0 and a.yfdm=@yfdm
          and not exists(select 1 from #tmp_memo w1 where w1.memo=a.memo)
          and not exists(select 1 from #tmp_cfdybz w2 where w2.cfdybz=a.cfdybz)
          and a.tfbz in(0,1) and a.jlzt=0--1207 guo 
		  and a.patid=@patid
     if @@error<>0  
	 begin  
		 select @errmsg='F从日表中初始化待删除表记录出错！'
		 rollback transaction
         goto err
	 end  
     if @rqbz=1 
     begin
        insert into #fymx_del(fyxh,fymxxh)
           select b.fyxh,b.xh as fymxxh
		   from YF_NMZFYZD a(nolock),YF_NMZFYMX b(nolock),#cfmxk c
		   where a.xh=b.fyxh and b.mxxh=c.xh and a.cfxh=c.cfxh and a.jssjh=@sjh and a.tfbz=1 and a.tfqrbz=0 and a.jlzt=0 and a.yfdm=@yfdm
                       and not exists(select 1 from #tmp_memo w1 where w1.memo=a.memo)
                       and not exists(select 1 from #tmp_cfdybz w2 where w2.cfdybz=a.cfdybz)
					   and a.patid=@patid
       if @@error<>0  
	   begin  
		   select @errmsg='F从年表中初始化待删除表记录出错！'
		   rollback transaction
           goto err  
	   end  
     end        
     if exists(select 1 from #fymx_del )
     begin
		 delete YF_MZFYMX
			  from YF_MZFYMX a,#fymx_del b 				
			  where a.xh=b.fymxxh
		 if @@error<>0  
		 begin  
			 select @errmsg='F删除旧退药明细出错！'
		     rollback transaction
             goto err  
		 end  
		 --删除没有退药明细的退药处方
		 delete YF_MZFYZD 
			 where jssjh=@sjh and yfdm=@yfdm and tfbz=1 and tfqrbz=0 and jlzt=0  
				 and xh in (select distinct fyxh from #fymx_del)
				 and not exists(select 1 from YF_MZFYMX c where c.fyxh = YF_MZFYZD.xh)
				 and patid=@patid
		 if @@error<>0  
		 begin  
			select @errmsg='F删除旧退药帐单信息出错！'
		    rollback transaction
            goto err  
		 end  
     end  
     --处理一个发票号包含多个处方的情况
     declare @tyxh_begin ut_xh12 --初始退药序号
     declare @ytycfsl  int  --应插入退药处方数
     declare @stycfsl  int  --实际插入退药处方数
     select @tyxh_begin= max(xh)+1 from YF_MZFYZD (nolock)
     select @ytycfsl = count(*) from #mzcfk (nolock)
  
	 insert into YF_MZFYZD(jssjh, cfxh, patid, yfdm, sfrq, sfczry, pyrq, pyczry, fyrq, fyczyh,  
	        cfts, tfbz, tfqrbz, jzbz, jlzt, tfxh, memo, zrys,tfys,yfyjs,fybz,wsbz,gfbz,tfyydm)  
	 select jssjh, xh, patid, @yfdm, lrrq, czyh, pyrq, pyczyh,
	        (case isnull(@tyrq,'') when '' then @now else @tyrq end) as fyrq,
			@czyh,tcfts, 1, 0, 0, 0, null, @tyyy,@fzzr,  @tyys, @yjs,1,wsbz,gfbz,@tfyydm
	  from #mzcfk (nolock)      
	 if @@error<>0 or  @@rowcount=0  
	 begin  
	    select @errmsg='F保存退药帐单信息出错！'
		rollback transaction
        goto err   
	 end  
    
	 select @xhtemp=SCOPE_IDENTITY()
	 
	  update #mzcfk_gf set fyxh=b.xh  
	  from #mzcfk_gf a inner join YF_MZFYZD b(nolock) on a.xh=b.cfxh  
	  and b.gfbz=1  and b.xh=@xhtemp and b.patid=@patid
	 
     select @stycfsl=count(*) from YF_MZFYZD a where xh>=@tyxh_begin and xh<=@xhtemp and a.patid=@patid
     if @ytycfsl> @stycfsl
     begin
		  select @errmsg='F保存退药信息出错,由于并发退药的原因，请重新退药即可！'
		  rollback transaction
          goto err 
     end
     
    if @config3291='是'
	begin			
		insert into YF_MZFYMX(fyxh, czdm, cfxh, mxxh, cd_idm, gg_idm, ypmc, ypdm, ypgg, ykxs,   
							ypdw, dwxs, ylsj,ypfj,jxce, cfts, ypsl,memo,jjje,mztybz,tfymxxh,wsbz,wsts)  
		select c.xh, @czdm, a.cfxh, a.xh, a.cd_idm, a.gg_idm, a.ypmc, a.ypdm, a.ypgg, a.ykxs,  
			a.ypdw, a.dwxs, 
			convert(numeric(12,4),case when txbl > 1 then a.ylsj/a.txbl else a.ylsj end),
			convert(numeric(12,4),case when a.txbl>1 then a.ypfj/a.txbl else a.ypfj end),    
			convert(numeric(14,2),case when d.jxje=0 then  1*a.jxce else (a.typsl*a.tcfts*(d.jxje/case when d.kcsl3=0 then 1 else d.kcsl3 end)) end),
			a.tcfts, -a.typsl,'', 
			convert(numeric(14,2),-a.jjje),1,a.fymxxh,isnull(a.wsbz,0),isnull(a.wsts,0)   
			from #cfmxk a, YF_MZFYZD c,YF_YFZKC d  
			where (c.xh>=@tyxh_begin and c.xh<=@xhtemp) and c.cfxh=a.cfxh 
			and c.tfbz=1 and c.tfqrbz=0 and c.jlzt=0 and d.cd_idm=a.cd_idm and d.ksdm=@yfdm
			and ISNULL(a.wsbz,0)=0	and c.patid=@patid
		union all
		select c.xh, @czdm, a.cfxh, a.xh, a.cd_idm, a.gg_idm, a.ypmc, a.ypdm, a.ypgg, a.ykxs,  
			a.ypdw, a.dwxs, 
			convert(numeric(12,4),case when txbl > 1 then a.ylsj/a.txbl else a.ylsj end),
			convert(numeric(12,4),case when a.txbl>1 then a.ypfj/a.txbl else a.ypfj end),    
			convert(numeric(14,2),case when d.jxje=0 then  1*a.jxce else (a.typsl*(a.tcfts-a.wsts)*(d.jxje/case when d.kcsl3=0 then 1 else d.kcsl3 end)) end),
			a.tcfts, -a.typsl,'', 
			convert(numeric(14,2),-a.jjje),1,a.fymxxh,isnull(a.wsbz,0),isnull(a.wsts,0)   
			from #cfmxk a, YF_MZFYZD c,YF_YFZKC d  
			where (c.xh>=@tyxh_begin and c.xh<=@xhtemp) and c.cfxh=a.cfxh 
			and c.tfbz=1 and c.tfqrbz=0 and c.jlzt=0 and d.cd_idm=a.cd_idm and d.ksdm=@yfdm
			and ISNULL(a.wsbz,0)=1	and c.patid=@patid		 
		if @@error<>0 or  @@rowcount=0  
		begin  
			select @errmsg='F保存退药明细信息出错！'
		    rollback transaction
            goto err    
		end 		
	
	end
	else
	begin
		insert into YF_MZFYMX(fyxh, czdm, cfxh, mxxh, cd_idm, gg_idm, ypmc, ypdm, ypgg, ykxs,   
							ypdw, dwxs, ylsj,ypfj,jxce, cfts, ypsl,memo,jjje,mztybz,tfymxxh,wsbz,wsts)  
		select c.xh, @czdm, a.cfxh, a.xh, a.cd_idm, a.gg_idm, a.ypmc, a.ypdm, a.ypgg, a.ykxs,  
			a.ypdw, a.dwxs, 
			convert(numeric(12,4),case when txbl > 1 then a.ylsj/a.txbl else a.ylsj end),
			convert(numeric(12,4),case when a.txbl>1 then a.ypfj/a.txbl else a.ypfj end),    
			convert(numeric(14,2),case when d.jxje=0 then  1*a.jxce else   (a.typsl*a.tcfts*(d.jxje/case when d.kcsl3=0 then 1 else d.kcsl3 end)) end),
			a.tcfts, -a.typsl,'', 
			convert(numeric(14,2),-a.jjje),1,a.fymxxh,isnull(a.wsbz,0),isnull(a.wsts,0)   
			from #cfmxk a, YF_MZFYZD c,YF_YFZKC d  
			where (c.xh>=@tyxh_begin and c.xh<=@xhtemp) and c.cfxh=a.cfxh 
			and c.tfbz=1 and c.tfqrbz=0 and c.jlzt=0 and d.cd_idm=a.cd_idm and d.ksdm=@yfdm
			and c.patid=@patid	    
		if @@error<>0 or  @@rowcount=0  
		begin  
			select @errmsg='F保存退药明细信息出错！'
		    rollback transaction
            goto err   
		end   
	end
	--插入YF_ZYFYMX时SF_CFMXK.tffs根据2550=否 来决定是否更新
	if @m2550='否'
	begin 
	  update a set a.tffs=abs(b.tcfts) from SF_CFMXK a join #cfmxk b on a.xh=b.xh 
	end
  ------------更新SF_CFMXK_FZ--start------------------
  if @config3414='是' 
  begin
	  if @rqbz =0 
	  begin
		 update a set a.memo1=b.memo1,a.memo2=b.memo2
		 from SF_CFMXK_FZ a ,#cfmx_tf b 
		 where a.cfxh=b.cfxh and a.mxxh=b.mxxh
	  end
	  else if @rqbz =1 
	  begin
		 update a set a.memo1=b.memo1,a.memo2=b.memo2
		 from SF_NCFMXK_FZ a ,#cfmx_tf b 
		 where a.cfxh=b.cfxh and a.mxxh=b.mxxh
	  end
  end
  ------------更新SF_CFMXK_FZ--end------------------
  
  if  ((@ypxtslt =2) and (@config3117='否')) 
begin
      declare @tmp_cfmxxh9 ut_xh12,  --此处需要保存库存数据保证 退费的时候可以获取到指定的批次数据
      @tmp_idm9 ut_xh12,
      @tmp_fymxxh9  ut_xh12,
      @tmp_ypsl9 ut_sl10,
      @tmp_cnt int
      
      declare @cur_pcxh9 ut_xh12,
              @cur_pcsl9 ut_sl10,
              @sysl9 ut_sl10  --当前批次序号，当前批次数量，剩余数量
       
      create table #yftyzdmx_kcjl
    (
      cd_idm ut_xh9 not null,
      ypsl  ut_sl10 not null,
      yfdm  ut_ksdm not null,
      fymxxh ut_xh12 not null,
      cfmxxh  ut_xh12 null
    ) 
      CREATE TABLE [#tmp_sytk_pc_cfmx_kcjl](
		[yfpcxh] [numeric](12, 0) NULL,
		[cd_idm] [numeric](9, 0)  NULL,
		[ykxs] [numeric](12, 4)  NULL,
		[sykt_ypsl] [numeric](38, 2) NULL,
		[avgylsj] [money] NULL,
		[avgypjj] [money] NULL,
		[ypfj] [money]  NULL,
		[sykt_lsje] [numeric](38, 2) NULL,
		[sykt_jjje] [numeric](38, 2) NULL
	) 
	
	CREATE TABLE [#tmp_sytk_pc_cfmx_kcjl3183](
	    [recno] ut_xh12 identity not null,
		[yfpcxh] [numeric](12, 0) NULL,
		[sykt_ypsl] [numeric](38, 2) NULL,
	) 
	
	 if @config3291='是'
    begin
  		INSERT into #yftyzdmx_kcjl(cd_idm,ypsl,yfdm,fymxxh,cfmxxh)
		select b.cd_idm, case when b.wsbz=1 then (-b.ypsl*(b.cfts-b.wsts)) else (-b.ypsl*b.cfts) end , 
		a.yfdm,b.xh,b.mxxh as mxxh
		from YF_MZFYZD a(nolock),YF_MZFYMX b(nolock),#tmp_mzfymx_data d(nolock)
		where a.xh=b.fyxh  and b.tfymxxh=d.xh and a.tfbz=1 and a.jlzt=0
		and a.xh>=@tyxh_begin and a.xh<=@xhtemp   and a.gfbz<>1 --膏方明细不扣库存
		and a.patid=@patid
    end
    else
    begin
		INSERT into #yftyzdmx_kcjl(cd_idm,ypsl,yfdm,fymxxh,cfmxxh)
		select b.cd_idm, -b.ypsl*b.cfts,a.yfdm,b.xh,b.mxxh as mxxh
		from YF_MZFYZD a(nolock),YF_MZFYMX b(nolock),#tmp_mzfymx_data d(nolock)
		where a.xh=b.fyxh  and b.tfymxxh=d.xh and a.tfbz=1 and a.jlzt=0
		and a.xh>=@tyxh_begin and a.xh<=@xhtemp
		and (@config3249='否' or (@config3249='是' and a.wsbz=0)) and a.gfbz<>1 --膏方明细不扣库存
		and a.patid=@patid   
    end
		   
	declare cs_yfty_mzty_tmp cursor for 
		select a.cd_idm,a.ypsl,a.cfmxxh,a.fymxxh 
		from #yftyzdmx_kcjl a(nolock)
		where a.cd_idm<>0 and a.ypsl<>0
		
	for read only
	open cs_yfty_mzty_tmp
	fetch cs_yfty_mzty_tmp  into @tmp_idm9, @tmp_ypsl9,@tmp_cfmxxh9,@tmp_fymxxh9
	while @@fetch_status=0
	begin
	    
	    delete from #tmp_sytk_pc_cfmx_kcjl	 --先清空
        insert into #tmp_sytk_pc_cfmx_kcjl exec usp_yf_mzbftf_sycfmxinfo @tmp_cfmxxh9,3 --全部信息
        
        delete from #tmp_sytk_pc_cfmx_kcjl3183 --清空
        if @config3183=0
		begin
		   insert into #tmp_sytk_pc_cfmx_kcjl3183(yfpcxh,sykt_ypsl)
		   select  a.yfpcxh,a.sykt_ypsl
		   from #tmp_sytk_pc_cfmx_kcjl a,YF_YFPCK b(nolock) 
		   where a.yfpcxh=b.xh 
		   order by b.sxrq desc
		end
		else
		begin
		  insert into #tmp_sytk_pc_cfmx_kcjl3183(yfpcxh,sykt_ypsl)
		   select a.yfpcxh,a.sykt_ypsl
		   from #tmp_sytk_pc_cfmx_kcjl a,YF_YFPCK b(nolock) 
		   where a.yfpcxh=b.xh 
		   order by b.rkrq desc
		end
				
		select @cnt=count(1) from #tmp_sytk_pc_cfmx_kcjl3183
		if isnull(@cnt,0)=0
		begin
			select @errmsg='F取剩余可退的记录失败2！'
			rollback transaction
			close cs_yfty_mzty_tmp
            deallocate cs_yfty_mzty_tmp
			goto err
		end
		
		select @sysl9 =@tmp_ypsl9

		declare cs_yfty_mzty_pc_tmp cursor for  
			 select yfpcxh,sykt_ypsl as czsl 
			 from #tmp_sytk_pc_cfmx_kcjl3183
			 order by recno  --注意这里czsl前不用加负号
		for read only
		
		--应该取剩余可退的记录 end
		open cs_yfty_mzty_pc_tmp
		fetch cs_yfty_mzty_pc_tmp into @cur_pcxh9,@cur_pcsl9
		while @@fetch_status=0 and @sysl9>0
		begin
			if @sysl9 - isnull(@cur_pcsl9,0)<=0  --当前批次能发完
				select @cur_pcsl9=@sysl9	
   
			insert into YF_BRTYPCXX (fymxxh,cfmxxh,yfpcxh ,tysl )
            select @tmp_fymxxh9,@tmp_cfmxxh9,@cur_pcxh9,@cur_pcsl9 
            		        
			select @sysl9=@sysl9-@cur_pcsl9
			
			fetch cs_yfty_mzty_pc_tmp into @cur_pcxh9,@cur_pcsl9
		end
		close cs_yfty_mzty_pc_tmp
		deallocate cs_yfty_mzty_pc_tmp	
     	
     	fetch cs_yfty_mzty_tmp into @tmp_idm9, @tmp_ypsl9,@tmp_cfmxxh9,@tmp_fymxxh9
	end
	close cs_yfty_mzty_tmp
	deallocate cs_yfty_mzty_tmp

end 
  
  
/*---===========================xwm 2011-12-08  药房批次进价处理 begin ===============================================---*/
------增加开始
    --xwm 2011-12-06 3117参数撤消，只充许退药时处理库存（退费处不处理库存）
	--if exists(select 1 from YY_CONFIG where id="3117" and config="是")
	--begin
        --对退药帐单明细进行扣库存

--需求171429 重新修改，支持模式0，1，2的3117=否的退药流程
--这样的，药房退药需要进行库存处理，增加库存的情况有：
-- 模式3
--模式0，1，2 且 3117为是的时候
if ((@ypxtslt in (0,1,2)) and (@config3117='是')) or (@ypxtslt in (3))  ----是否需要进行库存处理判断 start  模式0，1,2下3117=否时，这里不需要进行库存处理和调价处理 start
begin
	declare @cd_idm ut_xh9,
			@ypsl ut_sl10,
			@tymxxh ut_xh12,
			@fymxxh ut_xh12,
			@ylsj   ut_money,  --药品零售价（平均）
			@lsje   ut_je14,  --零售金额 
			@jjje   ut_je14,   --进价金额  
			@czdmfy ut_dm2,
			@czdmty ut_dm2
			,@fymxylsj ut_money		--发药明细零售价
			,@fymxyypjj_ts ut_money	--进价(推算)
			,@tmptfymxxh1 ut_xh12
			,@tmptfymxxh1_czdm ut_dm2
    
	declare @cur_pcxh ut_xh12,@cur_pcsl ut_sl10,@sysl ut_sl10  --当前批次序号，当前批次数量，剩余数量
	declare @pcjj1 ut_money,@ylsj1 ut_money,@lsje1 ut_je14,@jjje1 ut_je14  --当中过渡用

	select @ylsj=0,@lsje=0,@jjje=0
    
    CREATE TABLE [#tmp_sytk_pc_cfmx](
		[yfpcxh] [numeric](12, 0) NULL,
		[cd_idm] [numeric](9, 0)  NULL,
		[ykxs] [numeric](12, 4)  NULL,
		[sykt_ypsl] [numeric](38, 2) NULL,
		[avgylsj] [money] NULL,
		[avgypjj] [money] NULL,
		[ypfj] [money]  NULL,
		[sykt_lsje] [numeric](38, 2) NULL,
		[sykt_jjje] [numeric](38, 2) NULL
	) 

	 CREATE TABLE [#tmp_sytk_pc_cfmx3183](
	    [recno] ut_xh12 identity not null,
		[yfpcxh] [numeric](12, 0) NULL,
		[cd_idm] [numeric](9, 0)  NULL,
		[ykxs] [numeric](12, 4)  NULL,
		[sykt_ypsl] [numeric](38, 2) NULL,
		[avgylsj] [money] NULL,
		[avgypjj] [money] NULL,
		[ypfj] [money]  NULL,
		[sykt_lsje] [numeric](38, 2) NULL,
		[sykt_jjje] [numeric](38, 2) NULL
	) 

    create table #yftyzdmx
    (
      cd_idm ut_xh9 not null,
      ypsl  ut_sl10 not null,
      yfdm  ut_ksdm not null,
      tymxxh ut_xh12 not null,
      fymxxh ut_xh12 not null,
      czdmty ut_dm2 null,
      czdmfy ut_dm2 null,
      fymxylsj ut_money null,
      mxxh  ut_xh12 null
    ) 
	
    if @config3291='是'
    begin
  		INSERT into #yftyzdmx(cd_idm,ypsl,yfdm,tymxxh,fymxxh,czdmty,czdmfy,fymxylsj,mxxh)
		select b.cd_idm, case when b.wsbz=1 then (-b.ypsl*(b.cfts-b.wsts)) else (-b.ypsl*b.cfts) end , 
		a.yfdm,b.xh as tymxxh,d.xh as fymxxh,b.czdm as czdmty,
		d.czdm as czdmfy,b.ylsj  as fymxylsj,b.mxxh as mxxh
		from YF_MZFYZD a(nolock),YF_MZFYMX b(nolock),#tmp_mzfymx_data d(nolock)
		where a.xh=b.fyxh  and b.tfymxxh=d.xh and a.tfbz=1 and a.jlzt=0
		and a.xh>=@tyxh_begin and a.xh<=@xhtemp   and a.gfbz<>1 --膏方明细不扣库存
		and a.patid=@patid
    end
    else
    begin
		INSERT into #yftyzdmx(cd_idm,ypsl,yfdm,tymxxh,fymxxh,czdmty,czdmfy,fymxylsj,mxxh)
		select b.cd_idm, -b.ypsl*b.cfts, a.yfdm,b.xh as tymxxh,d.xh as fymxxh,b.czdm as czdmty,
		d.czdm as czdmfy,b.ylsj  as fymxylsj,b.mxxh as mxxh
		from YF_MZFYZD a(nolock),YF_MZFYMX b(nolock),#tmp_mzfymx_data d(nolock)
		where a.xh=b.fyxh  and b.tfymxxh=d.xh and a.tfbz=1 and a.jlzt=0
		and a.xh>=@tyxh_begin and a.xh<=@xhtemp
		and (@config3249='否' or (@config3249='是' and a.wsbz=0)) and a.gfbz<>1 --膏方明细不扣库存
		and a.patid=@patid   
    end
		   
	declare cs_yfty_mzty cursor for 
		select a.cd_idm,a.ypsl,a.yfdm,a.tymxxh,a.fymxxh,a.czdmty,a.czdmfy,a.fymxylsj,a.mxxh
		from #yftyzdmx a(nolock)
		where a.cd_idm<>0 and a.ypsl<>0	
			   
	for read only
	open cs_yfty_mzty
	fetch cs_yfty_mzty into @cd_idm, @ypsl, @yfdm,@tymxxh,@fymxxh,@czdmty,@czdmfy,@fymxylsj,@mxxh
	while @@fetch_status=0
	begin
		select @ylsj=0,@lsje=0,@jjje=0
		select @tmptfymxxh1=0,@tmptfymxxh1_czdm=''
		--if @config3180=2 
		if @ypxtslt in(2,3)
		begin
		    select @cur_pcxh=0
            select @tmptfymxxh1=tfymxxh,@tmptfymxxh1_czdm=czdm from #tmp_mzfymx_data where xh=@fymxxh
            --先判断是否是在批次进价启用前发的药（没有YF_MZMXPCXX记录）
            if not exists(select 1 from YF_MZMXPCXX(nolock) where zdmxxh=@fymxxh and czdm=@czdmfy)
				and not exists(select 1 from YF_MZMXPCXX(nolock) where zdmxxh=@tmptfymxxh1 and czdm=@tmptfymxxh1_czdm)
            begin
                if @ypxtslt=3 ----if @ypxtslt=3  start  必须加到 相同价格的批次上，如果没有，则不能退药
				begin
					select @cur_pcxh=0
					select top 1 @fymxyypjj_ts=@fymxylsj*(a.ypjj/a.yplsj) from YF_YFPCK a(nolock) where a.ksdm=@yfdm and a.cd_idm=@cd_idm 
					select top 1 @cur_pcxh=xh from YF_YFPCK a(nolock) where a.ksdm=@yfdm and a.cd_idm=@cd_idm and a.yplsj=@fymxylsj and a.ypjj=@fymxyypjj_ts
					if isnull(@cur_pcxh,0)=0
					begin
						insert into YF_YFPCK
						(ksdm,cd_idm,ykpcxh,ph,ykxs,dwxs,kcsl,pcdjsl,yplsj,ypjj,lsje,jjje,rkrq,sxrq,scrq,jlzt,memo) 
						select top 1 ksdm,cd_idm,0 ykpcxh,'mzbrty',ykxs,dwxs,0 kcsl,0 pcdjsl,@fymxylsj,@fymxyypjj_ts,0,0,convert(char(8),getdate(),112),convert(char(8),dateadd(year,2,getdate()),112),null,0,'' 
						from YF_YFPCK a(nolock) where a.ksdm=@yfdm and a.cd_idm=@cd_idm
						select @cur_pcxh=SCOPE_IDENTITY()
					end  
				end ---if @ypxtslt=3  end 
                exec usp_yf_kccl @cd_idm,@yfdm,@ypsl,0,@errmsg50 output ,0,@yfdm,0
					,@cur_pcxh,@tymxxh,@czdmty,@ylsj output,@lsje output,@jjje output
				if @errmsg50 like 'F%'
				begin
					select @errmsg='F'+substring(isnull(@errmsg50,''),2,49)
					rollback transaction
					close cs_yfty_mzty
                    deallocate cs_yfty_mzty
					goto err		
				end
            end
            else --发药在批次进价启用后
            begin
				--找到发药的批次对应上，要处理部分退药的情况
				select @sysl=@ypsl,@cur_pcxh=0,@cur_pcsl=0

				--应该取剩余可退的记录 start  ？？？
                delete from #tmp_sytk_pc_cfmx
				delete from #tmp_sytk_pc_cfmx3183
                insert into #tmp_sytk_pc_cfmx exec usp_yf_mzbftf_sycfmxinfo @mxxh,3
				if @@error<>0 or @@rowcount=0
				begin
					select @errmsg='F取剩余可退的记录失败！'
					rollback transaction
					close cs_yfty_mzty
                    deallocate cs_yfty_mzty
					goto err
				end

				if @config3183=0
				begin
				   insert into #tmp_sytk_pc_cfmx3183(yfpcxh,cd_idm,ykxs,sykt_ypsl,avgylsj,avgypjj,ypfj,sykt_lsje,sykt_jjje)
				   select  a.yfpcxh,a.cd_idm,a.ykxs,a.sykt_ypsl,a.avgylsj,a.avgypjj,a.ypfj,a.sykt_lsje,a.sykt_jjje
				   from #tmp_sytk_pc_cfmx a,YF_YFPCK b(nolock) 
				   where a.yfpcxh=b.xh 
				   order by b.sxrq desc
				end
				else
				begin
				  insert into #tmp_sytk_pc_cfmx3183(yfpcxh,cd_idm,ykxs,sykt_ypsl,avgylsj,avgypjj,ypfj,sykt_lsje,sykt_jjje)
				   select a.yfpcxh,a.cd_idm,a.ykxs,a.sykt_ypsl,a.avgylsj,a.avgypjj,a.ypfj,a.sykt_lsje,a.sykt_jjje
				   from #tmp_sytk_pc_cfmx a,YF_YFPCK b(nolock) 
				   where a.yfpcxh=b.xh 
				   order by b.rkrq desc
				end
				
				select @cnt=count(1) from #tmp_sytk_pc_cfmx3183
				if isnull(@cnt,0)=0
				begin
					select @errmsg='F取剩余可退的记录失败2！'
					rollback transaction
					close cs_yfty_mzty
                    deallocate cs_yfty_mzty
					goto err
				end

				delete from #tmp_sytk_pc_cfmx3183_order
				INSERT into #tmp_sytk_pc_cfmx3183_order(yfpcxh,sykt_ypsl)
				select yfpcxh,sykt_ypsl
				from #tmp_sytk_pc_cfmx3183 
				order by recno --注意这里czsl前不用加负号

				declare cs_yfty_mzty_pc cursor for  
					--select yfpcxh,-czsl from YF_MZMXPCXX(nolock) where zdmxxh=@fymxxh and czdm=@czdmfy order by yfpcxh
					 select yfpcxh,sykt_ypsl as czsl from #tmp_sytk_pc_cfmx3183_order --注意这里czsl前不用加负号

				for read only
				--应该取剩余可退的记录 end
				open cs_yfty_mzty_pc
				fetch cs_yfty_mzty_pc into @cur_pcxh,@cur_pcsl
				while @@fetch_status=0 and @sysl>0
				begin
					if @sysl - isnull(@cur_pcsl,0)<=0  --当前批次能发完
						select @cur_pcsl=@sysl	
	       
					exec usp_yf_kccl @cd_idm,@yfdm,@cur_pcsl,0,@errmsg50 output ,0,@yfdm,0--1
									 ,@cur_pcxh,@tymxxh,@czdmty,@ylsj1 output,@lsje1 output,@jjje1 output

					if @errmsg50 like 'F%'
					begin
						select @errmsg='F'+substring(isnull(@errmsg50,''),2,49)
						rollback transaction
						close cs_yfty_mzty_pc
						deallocate cs_yfty_mzty_pc
						close cs_yfty_mzty
						deallocate cs_yfty_mzty
						goto err		
					end				        
					select @sysl=@sysl-@cur_pcsl,@lsje=@lsje+@lsje1,@jjje=@jjje+@jjje1 
					fetch cs_yfty_mzty_pc into @cur_pcxh,@cur_pcsl   
				end
				close cs_yfty_mzty_pc
				deallocate cs_yfty_mzty_pc
				
				if @ypxtslt=3  ---按原来发药时收的费用来退费写入业务表
				begin						    
					delete from #mzmxpcxxjlb
					INSERT into #mzmxpcxxjlb(yfpcxh,yplsj) 
					select a.yfpcxh,a.yplsj 
					from YF_MZMXPCXX a(nolock) 
						inner join #tmp_mzfymx_data b on a.zdmxxh=b.fymxxh0
                    where b.xh=@fymxxh and a.czdm='09'
					if @@error<>0
					begin
						select @errmsg='F门诊退药帐单明细'+isnull(convert(varchar(12),@tymxxh),'')+'更新金额失败！'
						rollback transaction
						close cs_yfty_mzty
						deallocate cs_yfty_mzty
						goto err
					end
					if @@ROWCOUNT=0  --没有找到则从年表中找
					begin
						INSERT into #mzmxpcxxjlb(yfpcxh,yplsj)
						select a.yfpcxh,a.yplsj 
						from YF_NMZMXPCXX a(nolock) 
						   inner join #tmp_mzfymx_data b on a.zdmxxh=b.fymxxh0
                        where b.xh=@fymxxh and a.czdm='09' 
						if @@error<>0
						begin
							select @errmsg='F门诊退药帐单明细'+isnull(convert(varchar(12),@tymxxh),'')+'更新金额失败！'
							rollback transaction
							close cs_yfty_mzty
							deallocate cs_yfty_mzty
							goto err
						end				        
					end
					----更新退药单据按手的价格来退
					update a set a.yplsj=b.yplsj,
								 a.lsje=CONVERT(numeric(14,2),b.yplsj*a.czsl/a.ykxs)
					from YF_MZMXPCXX a,#mzmxpcxxjlb b
					where a.zdmxxh=@tymxxh and a.yfpcxh=b.yfpcxh and a.czdm='10' 
					if @@error<>0 or @@rowcount=0
					begin
						select @errmsg='F门诊退药帐单明细'+isnull(convert(varchar(12),@tymxxh),'')+'更新金额失败！'
						rollback transaction
						close cs_yfty_mzty
						deallocate cs_yfty_mzty
						goto err
					end			    
					select @lsje=SUM(a.lsje)
					from YF_MZMXPCXX a
					where a.zdmxxh=@tymxxh and a.czdm='10' 
				end					
            end 
	    		    
			if @ypxtslt=3
			begin
				update YF_MZFYMX 
				set ylsj=abs(convert(money,(-@lsje)/(ypsl*isnull(cfts,1)/ykxs))),
				    lsje=-@lsje,
					jjje=-@jjje,
					jxce=(-1)*((-@lsje)-(-@jjje))
				where xh=@tymxxh
			end	 
            else --统一零售价
            begin
				update  YF_MZFYMX 
				set ylsj=b.ylsj,
				    lsje=-@lsje,
					jjje=-@jjje,
					jxce=(-1)*((-@lsje)-(-@jjje))
				from YF_MZFYMX a,YK_YPCDMLK b(nolock)
				where a.cd_idm=b.idm and  a.xh=@tymxxh 
			end	
			if @@error<>0 or @@rowcount=0
			begin
				select @errmsg='F门诊退药帐单明细'+isnull(convert(varchar(12),@tymxxh),'')+'更新金额失败！'
				rollback transaction
				close cs_yfty_mzty
				deallocate cs_yfty_mzty
				goto err
			end

			update #cfmxk 
			set ylsj=b.ylsj 
			from #cfmxk a,YF_MZFYMX b(nolock) 
			where a.xh=b.mxxh and b.xh=@tymxxh
		   	if @@error<>0 or @@rowcount=0
			begin
				select @errmsg='F门诊退药帐单明细'+isnull(convert(varchar(12),@tymxxh),'')+'更新金额失败！'
				rollback transaction
				close cs_yfty_mzty
				deallocate cs_yfty_mzty
				goto err
			end

		end else
	    begin
			exec usp_yf_kccl @cd_idm,@yfdm,@ypsl,0,@errmsg50 output,0,'',0--1
			if @errmsg50 like 'F%'
			begin
				select @errmsg='F'+substring(isnull(@errmsg50,''),2,49)
				rollback transaction
				close cs_yfty_mzty
				deallocate cs_yfty_mzty
				goto err
			end		
		end
		fetch cs_yfty_mzty into @cd_idm, @ypsl, @yfdm,@tymxxh,@fymxxh,@czdmty,@czdmfy,@fymxylsj,@mxxh
	end
	close cs_yfty_mzty
	deallocate cs_yfty_mzty

	if @ypxtslt in(2,3)
	begin
		update YF_MZFYZD set jjje=t1.jjje from (
		select a.xh,sum(b.jjje) jjje
			from  YF_MZFYZD a,YF_MZFYMX b(nolock)
		where a.xh=b.fyxh and a.xh>=@tyxh_begin and a.patid=@patid and a.xh<=@xhtemp group by a.xh) t1, YF_MZFYZD t2
		where t1.xh=t2.xh 
		if @@error<>0 or @@rowcount=0
		begin
			select @errmsg='F更新发药帐单进价金额出错'
		    rollback transaction
            goto err
		end
	end

	update YF_MZFYZD set jzbz=1
		where xh>=@tyxh_begin and xh<=@xhtemp and patid=@patid
	if @@error<>0 or @@rowcount=0
	begin
		select @errmsg='F更新发药帐单结帐标志出错'
		rollback transaction
        goto err
	end

/*---========================xwm 2011-12-08  药房批次进价处理 end ===============================================---*/

--临时用药控制
if (@config0325='是')
begin
	declare @cur_ls_yfdm ut_ksdm,
			@cur_ls_czyh ut_czyh,
			@cur_ls_czlb int,
			@cur_ls_idm ut_xh9,
			@cur_ls_czsl ut_sl10,
			@cur_ls_sqks ut_ksdm,
			@cur_ls_sqys ut_czyh  
	        
	create table #lsypkzcl
	(
		yfdm ut_ksdm,--药房代码
		czyh ut_czyh,--操作员号
		czlb ut_bz, --0为门诊发药，1为门诊退药，2为住院发药，3为住院退药
		idm ut_xh9,   --产地idm
		czsl ut_sl10, --药品数量
		sqks ut_ksdm, --申请科室
		sqys ut_czyh,  --申请医生
	)	
    delete from #lsypkzcl
    
	INSERT into #lsypkzcl
	(yfdm,czyh,czlb,idm,czsl,sqks,sqys)
	select @yfdm as yfdm,@czyh as czyh,1 as czlb,a.cd_idm as idm,
		  a.ypsl as czsl,c.ksdm as sqks,c.ysdm as sqys		   
	from #yftyzdmx a(nolock)
		  inner join  SF_CFMXK b(nolock) on a.mxxh=b.xh
		  inner join  SF_MZCFK c(nolock) on b.cfxh=c.xh
	where a.cd_idm<>0 and a.ypsl<>0	and c.patid=@patid  
		
		 	
	declare cs_ls_kckzcl cursor for 
		 select a.yfdm,a.czyh,a.czlb,a.idm,a.czsl,a.sqks,a.sqys 
		 from #lsypkzcl a(nolock)  
		 where a.czsl<>0  
	for read only

	open cs_ls_kckzcl
	fetch cs_ls_kckzcl into @cur_ls_yfdm,@cur_ls_czyh,@cur_ls_czlb,@cur_ls_idm,@cur_ls_czsl,@cur_ls_sqks,@cur_ls_sqys
	while @@fetch_status=0
	begin 
		exec usp_yy_lsyygz_kccl @cur_ls_yfdm,@cur_ls_czyh,@cur_ls_czlb,@cur_ls_idm,@cur_ls_czsl,@cur_ls_sqks,@cur_ls_sqys,
								0,@errmsg50 output			
		if @errmsg50 like 'F%'
		begin
			select @errmsg='F'+substring(isnull(@errmsg50,''),2,49)
			rollback transaction
			close cs_ls_kckzcl
			deallocate cs_ls_kckzcl
			goto err
		end      
		fetch cs_ls_kckzcl into @cur_ls_yfdm,@cur_ls_czyh,@cur_ls_czlb,@cur_ls_idm,@cur_ls_czsl,@cur_ls_sqks,@cur_ls_sqys
	end
	close cs_ls_kckzcl
	deallocate cs_ls_kckzcl      
end
---------------处理膏方药品begin
if exists(select 1 from #mzcfk_gf )
begin
     declare @cfxh_gf ut_xh12,@fyzdxh_gf ut_xh12,@idm_gf ut_xh12,@tcfts_gf ut_sl10
     declare cur_gf cursor for 
		 select xh from  #mzcfk_gf 	
	for read only

	open cur_gf
	fetch cur_gf into @cfxh_gf
	while @@fetch_status=0
	begin 
	       insert into YF_MZFYZD(jssjh, cfxh, patid, yfdm, sfrq, sfczry, pyrq, pyczry, fyrq, fyczyh,  
	                    cfts, tfbz, tfqrbz, jzbz, jlzt, tfxh, memo, zrys,tfys,yfyjs,fybz,wsbz,gfbz)  
	       select a.jssjh,a.xh,a.patid,a.yfdm,a.lrrq,a.czyh,a.pyrq,a.pyczyh,@tyrq,@czyh,b.tcfts,1,0,1,0,null,
		          @tyyy,@fzzr,@tyys,@yjs,1,b.wsbz,2
	       from SF_MZCFK a (nolock) inner join #mzcfk_gf b(nolock) on a.xh=b.xh
	       where a.xh=@cfxh_gf and a.patid=@patid 
	        IF @@ERROR<>0 OR  @@ROWCOUNT=0  
	       BEGIN  
				select @errmsg='F保存膏方退药帐单信息出错！'
				rollback transaction
				close cur_gf
				deallocate cur_gf
				goto err   
		   END    
		   select @fyzdxh_gf=SCOPE_IDENTITY()

		   update a  set gfzdxh=@fyzdxh_gf 
		   from YF_MZFYZD a inner join #mzcfk_gf b(nolock) on a.xh=b.fyxh
		   where a.patid=@patid
	       IF @@ERROR<>0 OR  @@ROWCOUNT=0  
	       BEGIN  
				select @errmsg='F回写膏方账单序号失败！'
				rollback transaction
				close cur_gf
				deallocate cur_gf
				goto err     
		   END 
		   
		   select @idm_gf=dyxdf_idm from SF_MZCFK a(nolock) where a.xh=@cfxh_gf and a.patid=@patid

		   if @idm_gf is null 
		   begin
				select @errmsg='F取膏方idm失败！'
				rollback transaction
				close cur_gf
				deallocate cur_gf
				goto err 
		   end
		 select  @tcfts_gf= tcfts from #mzcfk_gf (nolock)  where xh=@cfxh_gf
		   IF @@ERROR<>0 OR  @@ROWCOUNT=0  
	       BEGIN  
				select @errmsg='F取退处方序号失败！'
				rollback transaction
				close cur_gf
				deallocate cur_gf
				goto err    
		   END 
	    insert into YF_MZFYMX(fyxh, czdm, cfxh, mxxh, cd_idm, gg_idm, ypmc, ypdm, ypgg, ykxs,   
							ypdw, dwxs, ylsj,ypfj,jxce, cfts, ypsl,memo,jjje,mztybz,tfymxxh,wsbz,wsts) 
			     select @fyzdxh_gf,@czdm,@cfxh_gf,0,a.idm,a.gg_idm,a.ypmc,a.ypdm,a.ypgg,a.ykxs,a.mzdw
			     ,a.mzxs,a.ylsj,a.ypfj, @tcfts_gf*(d.jxje/case when d.kcsl3=0 then 1 else d.kcsl3 end),
			     @tcfts_gf,-1,'',@tcfts_gf*a.ylsj - @tcfts_gf*(d.jxje/case when d.kcsl3=0 then 1 else d.kcsl3 end),
			     1,0,0,0
			     from YK_YPCDMLK a(nolock),YF_YFZKC d (nolock)  
	  		     where a.idm=@idm_gf and a.idm=d.cd_idm and d.ksdm=@yfdm
          IF @@ERROR<>0 OR  @@ROWCOUNT=0  
	       BEGIN  
				select @errmsg='F插入发药明细失败！'
				rollback transaction
				close cur_gf
				deallocate cur_gf
				goto err    
		   END 
        --select @tcfts_gf=@tcfts_gf*-1
      	exec usp_yf_kccl @idm_gf,@yfdm,@tcfts_gf,0,@errmsg50 output,0,'',0--1
			if @errmsg50 like 'F%'
			begin
				select @errmsg='F'+substring(isnull(@errmsg50,''),2,49)
				rollback transaction
				close cur_gf
				deallocate cur_gf
				goto err  
			end		
		   
	fetch cur_gf into @cfxh_gf
	end
	close cur_gf
	deallocate cur_gf     
						 
	
end						  
---------------处理膏方药品end
--增加在病人退药的时候冻结数量，冻结数量=冻结数量+退药数量 begin ---------------------------------
if (@config3554='是')
begin
	declare @yfdm_tydj ut_ksdm,
	        @czyh_tydj ut_czyh,
			@mxxh_tydj ut_xh12,
			@cd_idm_tydj ut_xh9,
			@ypsl_tydj ut_sl10  
	        
	create table #tydjkztmp
	(
		yfdm ut_ksdm,--药房代码
		czyh ut_czyh,--操作员号
		mxxh ut_xh12 null,--YF_MZFYMX.xh
		idm ut_xh9,   --产地idm
		ypsl ut_sl10, --药品数量
	)	
    delete from #tydjkztmp
    
	INSERT into #tydjkztmp
	(yfdm,czyh,mxxh,idm,ypsl)
	select a.yfdm,@czyh as czyh,b.xh as mxxh,b.cd_idm,(-1)*b.cfts*b.ypsl 
    from YF_MZFYZD a(nolock)
	     inner join YF_MZFYMX b(nolock) on a.xh=b.fyxh	  		   
    where a.xh>=@tyxh_begin and a.xh<=@xhtemp and a.patid=@patid 
		 	
	declare cs_tydj_kz cursor for 
		 select a.yfdm,a.czyh,a.mxxh,a.idm,a.ypsl 
		 from #tydjkztmp a(nolock)  
		 where a.ypsl<>0  
	for read only

	open cs_tydj_kz
	fetch cs_tydj_kz into @yfdm_tydj,@czyh_tydj,@mxxh_tydj,@cd_idm_tydj,@ypsl_tydj
	while @@fetch_status=0
	begin 
	    --冻结
		exec usp_yf_jk_yy_freeze '1',@yfdm_tydj,'YF_MZFYMX',@mxxh_tydj,@cd_idm_tydj,@ypsl_tydj,0,@errmsg50 output			
		if @errmsg50 like 'F%'
		begin
			select @errmsg='F'+substring(isnull(@errmsg50,''),2,49)
			rollback transaction
			close cs_tydj_kz
			deallocate cs_tydj_kz
			goto err  
		end      
		fetch cs_tydj_kz into @yfdm_tydj,@czyh_tydj,@mxxh_tydj,@cd_idm_tydj,@ypsl_tydj
	end
	close cs_tydj_kz
	deallocate cs_tydj_kz  

end
--增加在病人退药的时候冻结数量，冻结数量=冻结数量+退药数量 end ---------------------------------
-------增加完成
    commit transaction ---★★★★事务结束★★★★ 
   	
	declare @xh     ut_xh12   --序号
	declare @fyczyh ut_czyh   --发药操作员
	declare @jssjh  ut_sjh    --结算收据号
	declare @ypdw   ut_unit   --药品单位
	declare @dwxs   ut_dwxs   --单位系数	 
	declare @qpfj	ut_money  --前批发价
	declare	@qlsj	ut_money 	--前零售价
	declare @xpfj	ut_money	--新批发价
	declare @xlsj	ut_money        --新零售价
	declare @tzje_pf ut_money       --调整批发金额
	declare @tzje_ls ut_money       --调整零售金额
	declare @memo	ut_memo	        --明细备注
	declare @pcxh   ut_xh12         --批次序号(库房实现批次管理时需要传入)
	declare @cursor_yfpcxh ut_xh12  --药房批次序号
	
	if exists(select 1 from YF_MZFYZD a, YF_MZFYMX b, YK_YPCDMLK c (nolock) 
		where a.xh>=@tyxh_begin and a.xh<=@xhtemp and a.tfbz=1  and b.fyxh=a.xh and c.idm=b.cd_idm and a.patid=@patid
		and (b.ylsj<>c.ylsj or b.ypfj<>c.ypfj)) and (@ypxtslt<>3) 
	begin	--调价处理 start
	
		declare TJ_Cursor cursor for 
		select a.yfdm, a.xh, a.fyczyh, a.jssjh, b.cd_idm,  b.ypsl * (case isnull(b.wsbz,0) when 1 then(b.cfts-b.wsts) else b.cfts end) as ypsl ,b.ypdw, b.dwxs,--yxp 2007-8-28 调用usp_yf_jk_tjdzdsc的bug修改
			c.ypfj as q_ypfj,c.ylsj as q_ylsj ,b.ypfj as x_ypfj,b.ylsj as x_ylsj,  
			(c.ypfj-b.ypfj)*b.ypsl*(case isnull(b.wsbz,0) when 1 then(b.cfts-b.wsts) else b.cfts end)/c.ykxs as tzje_pf, 
			(c.ylsj-b.ylsj)*b.ypsl*(case isnull(b.wsbz,0) when 1 then(b.cfts-b.wsts) else b.cfts end)/c.ykxs as tzje_ls 
		from YF_MZFYZD a, YF_MZFYMX b, YK_YPCDMLK c (nolock) 
			where a.xh>=@tyxh_begin and a.xh<=@xhtemp and a.patid=@patid
			   and a.tfbz=1 and b.fyxh=a.xh and c.idm=b.cd_idm 
			   and (b.ylsj<>c.ylsj or b.ypfj<>c.ypfj)

		if @@error<>0
		begin
			select @errmsg='F调价调整时出错！'
            goto err
		end

		open TJ_Cursor 
		
		fetch TJ_Cursor into @yfdm,@xh,@fyczyh,@jssjh,@cd_idm,@ypsl,@ypdw,@dwxs,@qpfj,@qlsj,@xpfj,@xlsj,@tzje_pf,@tzje_ls


		while @@fetch_status=0
		begin
			--调用4.5药品调价接口 0门诊退药退
			exec usp_yf_jk_tjdzdsc @yfdm,@xh,@fyczyh,@jssjh,0,@cd_idm,@ypsl,@ypdw,@dwxs,@qpfj,@qlsj,@xpfj,@xlsj,'',@errmsg50 output
			
			if @errmsg50 like 'F%'
			begin
				select @errmsg='F'+substring(isnull(@errmsg50,''),2,49)
				close TJ_Cursor
                deallocate TJ_Cursor
                goto err
			end
		
			fetch TJ_Cursor into @yfdm,@xh,@fyczyh,@jssjh,@cd_idm,@ypsl,@ypdw,@dwxs,@qpfj,@qlsj,@xpfj,@xlsj,@tzje_pf,@tzje_ls

		end  --end while
	
		close TJ_Cursor
		deallocate TJ_Cursor
	
	end  --调价处理 end
	
	if exists(select 1 from YF_MZFYZD a, YF_MZFYMX b, YK_YPCDMLK c (nolock),YF_MZMXPCXX d(nolock),YF_YFPCK e(nolock) 
	where a.xh>=@tyxh_begin and a.xh<=@xhtemp and a.tfbz=1  and b.fyxh=a.xh and c.idm=b.cd_idm  and a.patid=@patid
	 and b.xh=d.zdmxxh and d.czdm='10' and d.yfpcxh=e.xh
	and (d.yplsj<>e.yplsj )) and (@ypxtslt=3)
	begin	--调价处理 start
			
		declare TJ_Cursor cursor for 
		select a.yfdm, a.xh, a.fyczyh, a.jssjh, b.cd_idm, (-1)*d.czsl as ypsl ,b.ypdw, b.dwxs,--yxp 2007-8-28 调用usp_yf_jk_tjdzdsc的bug修改
			c.ypfj as q_ypfj,e.yplsj as q_ylsj ,c.ypfj as x_ypfj,d.yplsj as x_ylsj,  
			(c.ypfj-c.ypfj)*(-1)*d.czsl/c.ykxs as tzje_pf, 
			(e.yplsj-d.yplsj)*(-1)*d.czsl/c.ykxs as tzje_ls,e.xh as yfpcxh 
		from YF_MZFYZD a(nolock), YF_MZFYMX b(nolock), YK_YPCDMLK c (nolock),YF_MZMXPCXX d(nolock),YF_YFPCK e(nolock)
		where a.xh>=@tyxh_begin and a.xh<=@xhtemp and a.patid=@patid
			   and a.tfbz=1 and b.fyxh=a.xh and c.idm=b.cd_idm 
			   and (d.yplsj<>e.yplsj ) and b.xh=d.zdmxxh and d.czdm='10' and d.yfpcxh=e.xh

		if @@error<>0
		begin
			select @errmsg='F调价调整时出错！'
            goto err
		end

		open TJ_Cursor 
		
		fetch TJ_Cursor into @yfdm,@xh,@fyczyh,@jssjh,@cd_idm,@ypsl,@ypdw,@dwxs,@qpfj,@qlsj,@xpfj,@xlsj,@tzje_pf,@tzje_ls,@cursor_yfpcxh


		while @@fetch_status=0
		begin
			--调用4.5药品调价接口 0门诊退药退
			exec usp_yf_jk_tjdzdsc @yfdm,@xh,@fyczyh,@jssjh,0,@cd_idm,@ypsl,@ypdw,@dwxs,@qpfj,@qlsj,@xpfj,@xlsj,'',@errmsg50 output,0,@cursor_yfpcxh
			
			if @errmsg50 like 'F%'
			begin
				select @errmsg='F'+substring(isnull(@errmsg50,''),2,49)
				close TJ_Cursor
                deallocate TJ_Cursor
                goto err
			end
		
			fetch TJ_Cursor into @yfdm,@xh,@fyczyh,@jssjh,@cd_idm,@ypsl,@ypdw,@dwxs,@qpfj,@qlsj,@xpfj,@xlsj,@tzje_pf,@tzje_ls,@cursor_yfpcxh

		end  --end while
	
		close TJ_Cursor
		deallocate TJ_Cursor
	
	end  --调价处理 end

end ----是否需要进行库存处理判断 end 模式0，1,2下3117=否时，这里不需要进行库存处理和调价处理 end
else
begin --不需要进行库存处理 start
   --模式 2,3,  不支持 3117 为否流程 
   commit transaction ---★★★★事务结束★★★★ 
end --不需要进行库存处理 end

	 
declare @fph int, @blh ut_blh, @hzxm ut_mc64, @cardno ut_cardno ,@hzxb ut_mc64,@hznl int ,@kfks ut_mc64,@brzd ut_zdmc    
select  @fph = a.fph, @hzxm = b.hzxm, @blh = b.blh,@cardno = b.cardno,@hzxb = b.sex, @hznl = datediff(yy,birth,getdate())    
from SF_BRJSK a (nolock),SF_BRXXK b (nolock)      
where a.patid=b.patid and a.sjh=@sjh and a.patid=@patid   
    
select top 1 @kfks = a.yjks_mc 
from YY_KSBMK a(nolock),VW_MZCFK b(nolock),#tycfxhlist c(nolock)  
where a.id = b.ksdm and b.patid=@patid  and b.xh=c.cfxh     
    
select @brzd = b.zdmc 
from VW_MZHJCFK  a(nolock) 
    inner join VW_MZCFK c(nolock) on a.xh=c.hjxh and a.patid=c.patid
	inner join #tycfxhlist d(nolock) on c.xh=d.cfxh
    left join VW_SF_YS_MZBLZDK b (nolock) on a.ghxh=b.ghxh and isnull(b.cfxh,0)=0  
where a.ghxh=b.ghxh and a.patid=@patid
order by b.zdlx     
    
 if not exists(select 1 from YY_CONFIG where id ='3398' and config='是')   ---  参数3398 病人退药打印时，是否打印原发药信息 为 是 start
 begin 
    delete from #result 
    insert into #result(rettype,retmsg,sjh,
	  ypmc,ypgg,ypdj,
	  tysl,sl,
	  ypdw,tyje,lsje,
	  发票号,门诊号,姓名,卡号,性别,年龄,开方科室,诊断,
	  lrrq,zxrq,tysl1,ypsl1,
	  lcjsdj,xh,mxxh,zje,ypsl2,cfts,cfxh,ypyf,memo1,memo2)  
	select distinct 'T', @sjh,@sjh sjh, 
	  b.ypmc, b.ypgg, convert(numeric(12,4), b.ylsj*b.dwxs/b.ykxs) ypdj,       
	  convert(numeric(10,2),b.typsl/b.dwxs) tysl,convert(numeric(10,2),b.typsl/b.dwxs) sl, 
	  b.ypdw, convert(numeric(12,2), b.ylsj*typsl/b.ykxs*tcfts) tyje,convert(numeric(12,2), b.ylsj*b.typsl/b.ykxs*b.tcfts) lsje,      
	  @fph '发票号', @blh '门诊号', @hzxm '姓名', @cardno '卡号',@hzxb '性别',rtrim(convert(varchar,@hznl))  '年龄',@kfks '开方科室',@brzd '诊断',
	  a.lrrq ,@now as zxrq,convert(numeric(10,2),b.typsl/b.dwxs*b.tcfts) tysl1,convert(numeric(10,2),b.typsl/b.dwxs*b.tcfts) ypsl1,       
	  --yxp del 2007-10-31,convert(numeric(12,4), b.yylsj*dwxs/ykxs) yylsj --yxp 2007-10-31 松江区公立医院药品零差率HIS实现:增加SF_CFMXK.yylsj的传出    
	  convert(numeric(12,4), b.lcjsdj*b.dwxs/b.ykxs) lcjsdj,b.mxxh xh,b.mxxh,mx.zje,mx.ypsl/mx.dwxs ypsl2,mx.cfts,b.cfxh,'' ypyf,c.memo1,c.memo2   
	from #cfmxk b(nolock)
	    inner join VW_MZCFMXK mx(nolock) on b.xh=mx.xh  
		inner join #tmp_currty_mzcfk_data a(nolock) on  a.xh=b.cfxh   
		left join VW_MZCFMXK_FZ c(nolock) on b.cfxh=c.cfxh and b.mxxh=c.mxxh
	select top 1 @errmsg=rettype+retmsg from #result
	goto success  
 end   ---  参数3398 病人退药打印时，是否打印原发药信息 为 是 end     
 else    
 begin   ---  参数3398 病人退药打印时，是否打印原发药信息 为 否 start  
    delete from #result 
   insert into #result(rettype,retmsg,sjh,
	  ypmc,ypgg,ypdj,
	  tysl,sl,
	  ypdw,tyje,lsje,
	  发票号,门诊号,姓名,卡号,性别,年龄,开方科室,诊断,
	  lrrq,zxrq,tysl1,ypsl1,
	  lcjsdj,xh,mxxh,zje,ypsl2,cfts,cfxh,ypyf,memo1,memo2)     
	select distinct 'T', @sjh,@sjh sjh, 
	   c.ypmc, c.ypgg, convert(numeric(12,4), c.ylsj*c.dwxs/c.ykxs) ypdj,      
	   convert(numeric(10,2),c.ypsl/c.dwxs) tysl,convert(numeric(10,2),c.ypsl/c.dwxs) sl, 
	   c.ypdw, convert(numeric(12,2), c.ylsj*c.ypsl/c.ykxs*c.cfts) tyje,convert(numeric(12,2), c.ylsj*c.ypsl/c.ykxs*c.cfts) lsje,    
	   @fph '发票号', @blh '门诊号', @hzxm '姓名', @cardno '卡号',@hzxb '性别',rtrim(convert(varchar,@hznl)) '年龄',@kfks '开方科室',@brzd '诊断',
	   b.lrrq ,@now as zxrq,convert(numeric(10,2),a.ypsl/a.dwxs*a.cfts) tysl1, convert(numeric(10,2),a.ypsl/a.dwxs*a.cfts) ypsl1,      
	   convert(numeric(12,4), c.lcjsdj*c.dwxs/c.ykxs) lcjsdj,c.xh xh,c.xh mxxh,c.zje zje,c.ypsl/c.dwxs ypsl2,  
	   c.cfts cfts,b.xh as cfxh,  
	   rtrim(convert(varchar(14),e.ypjl))+rtrim(e.jldw)+' '+rtrim(f.xsmc)+'*'+rtrim(convert(varchar(3),e.ts))+' '+g.name as ypyf,
	   h.memo1,h.memo2  
	from #cfmxk a 
		inner join VW_MZCFK b(nolock) on a.cfxh=b.xh--原来的处方    
		inner join VW_MZCFMXK c(nolock) on c.cfxh=b.xh and a.xh=c.xh  
		left join VW_MZHJCFMXK e (nolock) on b.hjxh = e.cfxh and c.hjmxxh=e.xh  
		left join SF_YS_YZPCK f (nolock) on e.pcdm = f.id  
		left join SF_YPYFK g (nolock) on e.ypyf = g.id 
		left join VW_MZCFMXK_FZ h(nolock) on a.cfxh=h.cfxh and a.mxxh=h.mxxh
	where b.patid=@patid
	
	insert into #result(rettype,retmsg,sjh,
	  ypmc,ypgg,ypdj,
	  tysl,sl,
	  ypdw,tyje,lsje,
	  发票号,门诊号,姓名,卡号,性别,年龄,开方科室,诊断,
	  lrrq,zxrq,tysl1,ypsl1,
	  lcjsdj,xh,mxxh,zje,ypsl2,cfts,cfxh,ypyf,memo1,memo2)       
	select distinct 'T', @sjh,@sjh sjh,  
	  b.ypmc, b.ypgg, convert(numeric(12,4), b.ylsj*dwxs/b.ykxs) ypdj,  --当前退药     
	  convert(numeric(10,2),-1*typsl/dwxs) tysl,convert(numeric(10,2),-1*typsl/dwxs) sl, 
	  b.ypdw, convert(numeric(12,2),-1*e.ylsj*typsl/b.ykxs*tcfts) tyje,convert(numeric(12,2),-1*e.ylsj*typsl/b.ykxs*tcfts) lsje,      
	  @fph '发票号', @blh '门诊号', @hzxm '姓名', @cardno '卡号',@hzxb '性别',rtrim(convert(varchar,@hznl)) '年龄',@kfks '开方科室',@brzd '诊断',
	  a.lrrq ,@now as zxrq,convert(numeric(10,2),-1*typsl/dwxs*tcfts) tysl1,convert(numeric(10,2),-1*typsl/dwxs*tcfts) ypsl1,       
	  convert(numeric(12,4), b.lcjsdj*dwxs/b.ykxs) lcjsdj,b.mxxh xh,b.mxxh,b.zje,b.ypsl ypsl2,  
	  b.cfts cfts,b.cfxh,  
	  rtrim(convert(varchar(14),e.ypjl))+rtrim(e.jldw)+' '+rtrim(f.xsmc)+'*'+rtrim(convert(varchar(3),e.ts))+' '+g.name as ypyf, 
	  c.memo1,c.memo2    
	from #cfmxk b  
		inner join #tmp_currty_mzcfk_data a on b.cfxh =a.xh  
		left join VW_MZHJCFMXK e (nolock) on a.hjxh = e.cfxh and b.hjmxxh=e.xh  
		left join SF_YS_YZPCK f (nolock) on e.pcdm = f.id  
		left join SF_YPYFK g (nolock) on e.ypyf = g.id
		left join VW_MZCFMXK_FZ c(nolock) on b.cfxh=c.cfxh and b.mxxh=c.mxxh
    where  a.xh=b.cfxh
	 
    select top 1 @errmsg=rettype+retmsg from #result
	goto success    
 end ---  参数3398 病人退药打印时，是否打印原发药信息 为 否 end  
 
end  --- if @jszt=3   end

delete from #result
insert into #result(rettype,retmsg) select 'T' rettype,'' retmsg
goto success 

--=============返回结果==================
err:
  select @errmsg='F'+ltrim(rtrim(substring(isnull(@errmsg,''),2,499)))
  if @delphi=1
  begin
     delete from #result

	 insert into #result(rettype,retmsg)
	 select 'F' rettype,ltrim(rtrim(substring(isnull(@errmsg,''),2,499))) retmsg

	 select 'F' rettype,a.retmsg,a.sjh,
	        a.ypmc,a.ypgg,a.ypdj,a.tysl,a.sl,a.ypdw,a.tyje,a.lsje,a.发票号,a.门诊号,a.姓名,a.卡号,a.性别,a.年龄,a.开方科室,a.诊断,
			a.lrrq,a.zxrq,a.tysl1,a.ypsl1,a.lcjsdj,a.xh,a.mxxh,a.zje,a.ypsl2,a.cfts,a.cfxh,a.ypyf,a.memo1,a.memo2
	 from #result a
  end
return 


success:
  select @errmsg='T'+ltrim(rtrim(substring(isnull(@errmsg,''),2,499)))
  if @delphi=1
  begin
    select 'T' rettype,a.retmsg,a.sjh,
	        a.ypmc,a.ypgg,a.ypdj,a.tysl,a.sl,a.ypdw,a.tyje,a.lsje,a.发票号,a.门诊号,a.姓名,a.卡号,a.性别,a.年龄,a.开方科室,a.诊断,
			a.lrrq,a.zxrq,a.tysl1,a.ypsl1,a.lcjsdj,a.xh,a.mxxh,a.zje,a.ypsl2,a.cfts,a.cfxh,a.ypyf,a.memo1,a.memo2
	 from #result a
  end
return





