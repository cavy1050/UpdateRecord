Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE proc usp_bq_x_yzsh 
	@wkdz		varchar(32),
	@jszt		smallint,	
	@czyh		ut_czyh,	
	@syxh		ut_syxh=0,
	@yexh		ut_syxh=0,
	@fzxh		ut_xh12=0,
	@yzbz		ut_bz=0					--0临时 1长期
	,@shsj		ut_rq16=''
    ,@guid		varchar(36)=''		--GUID
    ,@emrsybz	ut_bz = 0			--核对源 0:护士站， 1：医生站
    ,@dlksdm	ut_ksdm=''			--登录科室代码
as --集440685 2018-10-31 17:52:30 4.0标准版
/********** 
[版本号]4.0.0.0.0
[创建时间]2017.10.31
[作者]swx
[版权] Copyright ? 2004-2008上海金仕达-卫宁软件股份有限公司
[描述]医嘱核对
[功能说明]
	医嘱核对
[参数说明]
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]

DBCC DROPCLEANBUFFERS  --清除缓冲区
DBCC FREEPROCCACHE  --删除计划高速缓存中的元素
SET STATISTICS TIME ON --执行时间
SET STATISTICS IO ON --IO读取
begin tran		
--select yzzt,* from BQ_LSYZK where yzzt=0 and xh=452	
exec usp_bq_x_yzsh "F0DEF1493D3E",1,'00'
exec usp_bq_x_yzsh "F0DEF1493D3E",2,'00',156,0,452,0
exec usp_bq_x_yzsh "F0DEF1493D3E",3,'00',0,0
--select yzzt,* from BQ_LSYZK where xh=452	
rollback tran 

[修改记录]
**********/
set nocount on

if(isnull(@czyh,'')='')
begin
select 'F','操作员工号不能为空！'
return
end

--生成递交的临时表
declare @tablename varchar(32)
select @tablename='##yzsh'+@wkdz+@czyh  
if @jszt=1  ---三步提交1：创建全局临时表 start
begin
	exec('if exists(select 1 from tempdb..sysobjects where name="'+@tablename+'")
		drop table '+@tablename)
	exec('create table '+@tablename+'(  
			syxh ut_syxh null,
			yexh ut_syxh null,
			fzxh ut_xh12 null,
			yzbz ut_bz null,
			shsj ut_rq16 null,
		)')
	if @@error<>0
	begin
		select 'F','创建临时表时出错！'
		return
	end
	select 'T'
	return
end ---三步提交1：创建全局临时表 end

if @jszt=2 ---三步提交2：往全局临时表插入明细数据 start
begin
	declare @csyxh varchar(12)
		,@cyexh	varchar(12)
		,@cfzxh	varchar(12)
		,@cyzbz	varchar(1)
		,@cldxmsl varchar(14)
		,@cldxmlb varchar(1)

	select @csyxh=CONVERT(varchar(12),@syxh)
		,@cyexh=CONVERT(varchar(12),@yexh)
		,@cfzxh=CONVERT(varchar(12),@fzxh)
		,@cyzbz=CONVERT(varchar(12),@yzbz)
		
	exec('insert into '+@tablename+' values('+@csyxh+','+@cyexh+','+@cfzxh+','+@cyzbz+',"'+@shsj+'")') 
	if @@error<>0
	begin
		select 'F','插入临时表时出错！'
		return  
	end
	select 'T'
	return
end ---三步提交2：往全局临时表插入明细数据 end

if @jszt=3 ---三步提交3：将全局临时表数据，转到局部临时表，处理后，保存到医嘱库 start
begin
	create table #yzsh
	(
		syxh ut_syxh,
		yexh ut_syxh,
		fzxh ut_xh12 null,
		yzbz ut_bz null,
		shsj ut_rq16 null,
		qkbz int null,
		brfyye ut_money null,
	)
	if exists(select 1 from tempdb..sysobjects where name=@tablename)
	begin
		exec('insert into #yzsh(syxh,yexh,fzxh,yzbz,shsj) select * from ' + @tablename + ' ')
		exec('drop table '+@tablename)
	end
	if not exists(select 1 from #yzsh)
	begin
		if exists(select 1 from sysobjects where name = 'BQ_XZSJJH')
		begin
			insert into #yzsh(syxh,yexh,fzxh,yzbz,shsj) 
			select syxh,yexh,fzxh,yzbz,shsj
			from BQ_XZSJJH (nolock)
			where qtguid=@guid and czyh=@czyh
			--移到年表
			insert into BQ_NXZSJJH
			select * from BQ_XZSJJH (nolock) where qtguid=@guid and czyh=@czyh
			--删除数据
			delete from BQ_XZSJJH where qtguid=@guid and czyh=@czyh
		end
	end
	if not exists(select 1 from #yzsh)
	begin
		select 'F','没有要核对的医嘱！'
		return
	end
	--select * from #yzsh
	
	declare @cs_syxh ut_syxh
		,@cs_yexh ut_syxh
		,@cs_yzxh ut_xh12
		,@cs_fzxh ut_xh12
		,@cs_yzbz int
		,@cs_ksrq	ut_rq16
		,@cs_dqzxsj	ut_rq16
		,@cs_zxzqdw	int
		,@cs_zxzq	int
		,@rtnmsg  varchar(50)
		
	--病人列表循环1 start  
	declare cs_brlist cursor for   
		select distinct syxh,yexh from #yzsh  
	for read only  
	open cs_brlist  
	fetch cs_brlist into @cs_syxh,@cs_yexh  
	while @@fetch_status=0  
	begin   
		--病人是否欠款  
		select @rtnmsg='T'  
		exec usp_zy_bryjjbj	@cs_syxh, 1, 0, @rtnmsg output
		if @rtnmsg like 'F%'     
			update #yzsh set qkbz=1,brfyye=0 where syxh=@cs_syxh --and yexh=@yexh
		else
			update #yzsh set qkbz=0,brfyye=convert(numeric(14,4),rtrim(ltrim(substring(@rtnmsg,2,49)))) 
			where syxh=@cs_syxh --and yexh=@yexh

		fetch cs_brlist into @cs_syxh,@cs_yexh
	end  
	close cs_brlist  
	deallocate cs_brlist  
	--病人列表循环1 end  
	
	
	declare @now varchar(16),
		@tzxh ut_xh12,		--停止医嘱分组序号
		@ysdm ut_czyh,		--医生代码
		@tzrq ut_rq16,		--停止日期
		@yzlb smallint,		--医嘱类别
		@ksrq ut_rq16,		--开始日期
		@ypdm ut_xmdm,		--药品代码
		@mzdm ut_xmdm,		--麻醉代码
		@ypmc ut_mc256,		--药品名称
		@zxksdm ut_ksdm,	--科室代码
		@ztnr	ut_memo,	--嘱托内容
		@errmsg varchar(50),
		@btbz char(2),
		@ispc char(2),		--是否使用带频次的材料记账
		@issh varchar(4),       --阳性药品是否能核对
		@shnr varchar(255)    --药品没有通过核对信息
		,@execmsg varchar(8000)
		,@ssql varchar(1000)
		,@iscansssq char(2),
		@ssjlzt ut_bz,
		@ssdj ut_bz
		,@configG014 char(2),		--是否在住院医生站里调用医嘱核对
		@configG106 char(2),		--医嘱核对是否发送消息给护士站(G014="是"有效)
		@fsip varchar(32),			--发送方IP地址
		@jsbq	varchar(32),		--接收者 ,可能是职工，科室，病区
		@brcw	varchar(32),		--病人床位
		@hzxm	ut_mc64,		--病人姓名
		@msg varchar(255),			--消息内容
		@configG107 ut_xmdm,
		@configG108 ut_xmdm,
		@configG153 char(2)         --消息是否自动打印
		,@config6461 char(2)         --病区医嘱核对后是否发送消息
		,@jajbz ut_bz   --是否有加急的医嘱    0:无   1:有     -1:没有医嘱被核对
		,@config6480 char(2)   --是否使用医生(EMR医嘱核对)与护士分开核对的机制
		,@config6481 char(2)   --六院医嘱核对发送消息时是否放到前台进行(必须是EMR中,并且6461为否的情况下)
		,@config6A70 char(2)   --医嘱核对成功后是否弹出本次核对的医嘱明细
		,@config6036 varchar(2)
		,@configG236 varchar(2)
		,@sfxyzlc int     --是否使用新医嘱流程 
		,@config6501 varchar(2)		--是否使用围手术期控制
		,@configks20 int
		,@configG435 varchar(2)
		,@yznr varchar(255)
		,@tzyy int
		,@config6800 varchar(1) 
		,@config6949	varchar(2)	--lyljfs是否默认为1重新累计
		,@config6538 varchar(2)	--是否提示病人的长期医嘱存在有效的累计领药信息(控制护士站和医生站医嘱录入)
		,@config6A03 varchar(255) --选择明启发药的药房代码
		,@config6A71 varchar(2)  --是否给平台发送消息
		,@config6A19 varchar(2) --新开医嘱是否启用特殊模式
		,@config6A95_ls varchar(50)  --默认的执行时间为医嘱开始时间延后多少分钟  临时
		,@config6A95_cq varchar(50)  --默认的执行时间为医嘱开始时间延后多少分钟  长期
		,@config6142 varchar(2)    --小处方是否生成到临时医嘱
		,@config6583 varchar(2)    --小处方是否要经过核对后才生成领药信息
		,@config6C54 varchar(200)  --启用医嘱核对同步更新护士执行医嘱的执行及护士签名的医嘱类别集合
		--,@brfyye		ut_money	--病人费用余额
		--,@qkbz			smallint
		,@cydyfyye		ut_money	--病人费用余额
		,@yzbh_cqlsbz ut_bz,   --长期临时标志 
		@yzbh_syxh ut_xh12,
		@yzbh_yzxh ut_xh12,
		@yzbh_zxks ut_ksdm,
		@yzbh_bqdm ut_ksdm,   		
		@yzbh_xtbz ut_bz,
		@yzbh_pcsj ut_dm5,
		@shr ut_czyh,
		@yzzt ut_bz
		,@shyzcount	int	--核对医嘱数量
		,@config6788 BIT --add by zll for 189327上海市儿童医院—病区管理系统 医嘱核对 是否启用拒绝通过核对功能
		,@config6999 varchar(2)
		,@config6975 varchar(1)
		,@configG256 varchar(2)
		,@config6C90 varchar(2)	--补临医嘱是否打印
	
	SELECT @config6788=1                        
	SELECT @config6788=(SELECT CASE WHEN isnull(config,'否')='是'then 0 else 1 end from YY_CONFIG(nolock) where id='6788')                 	   	
	select @jajbz=-1 ,@execmsg=''       
	select @shyzcount = 0
	select @config6480='否'
	select @config6480=isnull(config,'否') from YY_CONFIG(nolock) where id='6480'
	select @config6142=isnull(config,'否') from YY_CONFIG(nolock) where id='6142'
	select @config6583=isnull(config,'否') from YY_CONFIG(nolock) where id='6583'
	select @configG014=isnull(config,'否') from YY_CONFIG(nolock) where id='G014'
	select @configG106=isnull(config,'否') from YY_CONFIG(nolock) where id='G106'
	select @configG107=isnull(config,'') from YY_CONFIG(nolock) where id='G107' --危重文字医嘱代码
	select @configG108=isnull(config,'') from YY_CONFIG(nolock) where id='G108' --危重文字医嘱代码		
	select @config6800=isnull(config,'1') from YY_CONFIG(nolock) where id='6800'--医嘱核对变更ZY_BRSYK.wzjb的方式 0:不更新 1:根据参数 G107 、 G108 更新 2: 根据5.0医生站的yzlb=16,17更新
	if @shsj = '' 
		select @now=convert(char(8),getdate(),112)+convert(char(8),getdate(),8)
	else
		select @now=@shsj
	select @iscansssq=isnull(config,'否') from YY_CONFIG(nolock) where id='G024'
	select @iscansssq = isnull(@iscansssq,'否')
	select @issh = isnull(config,'是') from YY_CONFIG(nolock) where id='6293'
	select @shnr = ''
	if @iscansssq ='否'
		select @ssjlzt = 0
	else
		select @ssjlzt = -1
	select @configG153=isnull(config,'否') from YY_CONFIG(nolock) where id='G153'
	select @configG153 = isnull(@configG153,'否')
	select @config6461=isnull(config,'否') from YY_CONFIG(nolock) where id='6461'
	select @config6461 = isnull(@config6461,'否')
	select @config6481=isnull(config,'否') from YY_CONFIG(nolock) where id='6481'
	select @config6481 = isnull(@config6481,'否')
	select @config6501=isnull(config,'否') from YY_CONFIG(nolock) where id='6501'
	select @config6036 = config from YY_CONFIG(nolock) where id = '6036'	
	select @config6036 = isnull(@config6036,'否')
	select @configG236 = config from YY_CONFIG(nolock) where id = 'G236'	
	select @configG236 = isnull(@configG236,'否')
	select @config6A70 = config from YY_CONFIG(nolock) where id = '6A70'
	select @config6A70 = isnull(@config6A70,'0')  
	select @config6A71 = config from YY_CONFIG(nolock) where id = '6A71'
	select @config6A71 = isnull(@config6A71,'否')  
	select @config6A19 = config from YY_CONFIG(nolock) where id = '6A19'
	select @config6A19 = ISNULL(@config6A19, '0')
	select @config6C54 = ISNULL(config,'') from YY_CONFIG(nolock) where id = '6C54'
	if @config6C54 <> '' 
	begin
		select @config6C54 = replace(@config6C54, ',', '","')
		select @config6C54 = '"' + @config6C54 +'"'
	end
	----------默认的执行时间为医嘱开始时间延后多少分钟 长期临时控制参数拆分---------
	if @config6A19 = '4'
	begin
		declare @config6A95 varchar(100)
		select @config6A95_cq = '0'
		select @config6A95_ls = '0'
		select @config6A95 = config from YY_CONFIG(nolock) where id = '6A95'
		if (charindex(',',@config6A95)<>0) 
		begin
			select @config6A95_cq = substring(@config6A95,1,charindex(',',@config6A95)-1)
			select @config6A95_ls = substring(@config6A95,charindex(',',@config6A95)+1
				,len(@config6A95)-charindex(',',@config6A95))
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

	select @configks20=isnull(config,0) from YY_CONFIG(nolock) where id ='KS20'
	if (@config6036='是') and (@configG236='是') 
		select @sfxyzlc=1
	else
		select @sfxyzlc=0
	if exists(select 1 from YY_CONFIG(nolock) where id='G435' and isnull(config,'是')='是') 
		select @configG435='是'
	else
		select @configG435='否'   
	select @config6949=isnull(config,'否') from YY_CONFIG(nolock) where id='6949'
	select @config6538=isnull(config,'否') from YY_CONFIG(nolock) where id='6538'
	select @config6A03 = isnull(config,'') from YY_CONFIG(nolock) where id='6A03'
	--KS20开启后6501参数无效
	IF(@configks20>0)
	BEGIN
		select @config6501='否'	
	END
	select @config6999 = '否'
	SELECT @config6999 = ISNULL(config,'否') FROM YY_CONFIG (nolock) WHERE id = '6999'  
	SELECT @config6975 = ISNULL(config,'0') FROM YY_CONFIG (nolock) WHERE id = '6975'  
	if ISNULL(@config6975,'')='' select @config6975='0'
	select @configG256 = ISNULL(config,'否') FROM YY_CONFIG (nolock) WHERE id = 'G256'  
	select @config6C90 = ISNULL(config,'是') FROM YY_CONFIG (nolock) WHERE id = '6C90'  
	if isnull(@config6C90,'')<>'否' select @config6C90='是'
	
	select distinct a.syxh ,a.yexh ,a.xh ,b.shsj ,b.qkbz ,b.brfyye 
	into #yjm_bq_lsyzk 
	from BQ_LSYZK a(nolock)inner join #yzsh b on a.syxh=b.syxh and a.fzxh=b.fzxh and b.yzbz=0 
	where ((@config6788=1)OR(NOT exists (SELECT yzxh FROM BQ_LSYZK_FZ d(nolock) WHERE a.syxh=d.syxh AND d.tgbz=0 and d.yzxh=a.xh )))

	select distinct a.syxh ,a.yexh ,a.xh ,b.shsj ,b.qkbz ,b.brfyye 
	into #yjm_bq_cqyzk 
	from BQ_CQYZK a(nolock)inner join #yzsh b on a.syxh=b.syxh and a.fzxh=b.fzxh and b.yzbz=1 
	where ((@config6788=1)OR(NOT exists (SELECT yzxh FROM BQ_CQYZK_FZ d(nolock) WHERE a.syxh=d.syxh AND d.tgbz=0 and d.yzxh=a.xh ))) 

	delete #yjm_bq_lsyzk 
	from #yjm_bq_lsyzk wls inner join BQ_LSYZK a(nolock) on wls.xh=a.xh and a.yzzt<>0
	delete #yjm_bq_cqyzk 
	from #yjm_bq_cqyzk wcq inner join BQ_CQYZK a(nolock) on wcq.xh=a.xh and a.yzzt<>0
	
	--dc的先处理一遍
	if @config6999='是'
	begin
		if exists(select 1 from BQ_LSYZK a(nolock)inner join #yzsh b on a.syxh=b.syxh and a.fzxh=b.fzxh and b.yzbz=0 where a.yzzt=3)
			or exists(select 1 from BQ_CQYZK a(nolock)inner join #yzsh b on a.syxh=b.syxh and a.fzxh=b.fzxh and b.yzbz=1 where a.yzzt=3)
		begin
			update fz set czbz=1
			from BQ_LSYZK a(nolock)inner join #yzsh b on a.syxh=b.syxh and a.fzxh=b.fzxh and b.yzbz=0
				inner join BQ_LSYZK_FZ fz on a.syxh = fz.syxh and a.xh = fz.yzxh 
			where a.yzzt=3

			update fz set czbz=1
			from BQ_CQYZK a(nolock)inner join #yzsh b on a.syxh=b.syxh and a.fzxh=b.fzxh and b.yzbz=1
				inner join BQ_CQYZK_FZ fz on a.syxh = fz.syxh and a.xh = fz.yzxh 
			where a.yzzt=3

			if not exists(select 1 from #yjm_bq_lsyzk) and not exists(select 1 from #yjm_bq_cqyzk) 
			begin
				select "T"
				return    
			end
		end
	end
	
	--核对临时和长期
	if not exists(select 1 from #yjm_bq_lsyzk) and not exists(select 1 from #yjm_bq_cqyzk) 
	begin
		select "F","没有需要核对的医嘱！"
		return
	end
	if exists(select 1 from YY_CONFIG (nolock) where id='6B88' and config='是')
	begin
		delete #yjm_bq_lsyzk 
		from #yjm_bq_lsyzk wls inner join BQ_LSYZK a(nolock) on wls.xh=a.xh and a.yzzt=0 and a.ksrq>@now

		delete #yjm_bq_cqyzk 
		from #yjm_bq_cqyzk wcq inner join BQ_CQYZK a(nolock) on wcq.xh=a.xh and a.yzzt=0 and a.ksrq>@now 

		if not exists (select 1 from BQ_LSYZK a(nolock) inner join #yjm_bq_lsyzk wls on a.xh=wls.xh where a.yzzt=0)
			and not exists (select 1 from BQ_CQYZK a(nolock) inner join #yjm_bq_cqyzk wcq on a.xh=wcq.xh  where a.yzzt=0)
		begin
			select "F",'存在未到医嘱开始日期的医嘱，不能核对！'
			return
		end
	end
	if exists(select 1 from YY_CONFIG (nolock) where id='6A04' and config='是')
	begin
		delete #yjm_bq_lsyzk 
		from #yjm_bq_lsyzk wls inner join BQ_LSYZK a(nolock) on wls.xh=a.xh and a.yzzt=0 and a.ysshbz not in (0,2) and isnull(a.v5xh,0)<>0

		delete #yjm_bq_cqyzk 
		from #yjm_bq_cqyzk wcq inner join BQ_CQYZK a(nolock) on wcq.xh=a.xh and a.yzzt=0 and a.ysshbz not in (0,2) and isnull(a.v5xh,0)<>0

		if not exists (select 1 from BQ_LSYZK a(nolock) inner join #yjm_bq_lsyzk wls on a.xh=wls.xh where a.yzzt=0)
			and not exists (select 1 from BQ_CQYZK a(nolock) inner join #yjm_bq_cqyzk wcq on a.xh=wcq.xh  where a.yzzt=0)
		begin
			select "F","医嘱因药师未核对，医嘱核对未通过！"
			return    
		end
	end

	--==============================医嘱明细拆分   start======================================
	select id,name,yfjh,xmlbjh,yzlbjh,lb,pxsz,pcdy,djlx
		--,case when id='02' then 0 --服药单  
		--when id='03' then 1  --静脉滴注单  
		--when id='04' then 4  --护理单  
		--when id='05' then 7  --注射单  
		--when id='06' then 5  --饮食单  
		--when id='07' then 3  --药品其他单据  
		--when id='08' then 8  --治疗单  
		--when id='16' then 9  --出院带药  
		--else (-1)*convert(int,id) end djlx
	into #YZDJK
	from BQ_YZDJK_X where sfkj=1 

	if exists(select 1 from #yjm_bq_lsyzk)
	begin
		--临时不拆分
		insert into BQ_LSYZMXK(yzxh,fzxh,syxh,yexh--,hzxm,bqdm,ksdm,ysdm,lrrq
			--,lrczyh,shrq,shczyh,ksrq,zxrq,zxczyh,dcczyh,qxsj,dcysdm,tzxh
			--,tzrq,tzysdm,idm,ypdm,ypmc,ypgg,ypjl,jldw,dwlb,ypsl
			--,zxdw,ztnr,djfl,yzdjfl,ypyf,pcdm,zxcs,zxzq,zxzqdw,zdm,zxsj
			,pczxsj,yztm--,yzlb,yzzt,zbybz,zxksdm,cgyzbz,yjqrbz
			)
		select a.xh,a.fzxh,a.syxh,a.yexh--,a.hzxm,a.bqdm,a.ksdm,a.ysdm,a.lrrq
			--,a.lrczyh,a.shrq,a.shczyh,a.ksrq,a.zxrq,a.zxczyh,a.dcczyh,a.qxsj,a.dcysdm,a.tzxh
			--,a.tzrq,'' tzysdm,a.idm,a.ypdm,a.ypmc,a.ypgg,a.ypjl,a.jldw,a.dwlb,a.ypsl
			--,a.zxdw,a.ztnr,a.djfl,a.yzdjfl,a.ypyf,a.pcdm,pc.zxcs,pc.zxzq,pc.zxzqdw,pc.zbz zdm,pc.zxsj
			,'' pczxsj,'' yztm--,a.yzlb,a.yzzt,a.zbybz,a.zxksdm,a.cgyzbz,a.yjqrbz
		from BQ_LSYZK a(nolock) inner join #yjm_bq_lsyzk wls on wls.syxh=a.syxh and wls.xh=a.xh
			inner join ZY_YZPCK pc(nolock) on a.pcdm=pc.id
		where not exists(select 1 from BQ_LSYZMXK mx(nolock) where mx.syxh=a.syxh and mx.yzxh=a.xh)
			and ((@config6C90='是')or(@config6C90<>'是' and a.blzbz=0))

		select a.syxh,a.yexh,a.bqdm,a.ksdm,null djlx,a.xh as yzxh,a.fzxh,0 zh,a.ksrq,a.idm,a.ypdm
			,case a.yzlb when 2 then a.yznr else a.ypmc end ypmc --手术的显示yznr
			,a.ypgg,cd.ggdw,a.ypjl,a.jldw,a.ypsl,a.zxdw ypdw,a.ypjl ypyl,a.ypyf,yf.name yfmc,'' fysm
			,a.pcdm,pc.name pcmc,a.ztnr,a.tzrq,pc.zxcs,a.zxrq,pc.zxsj,a.lrczyh lrczy,a.shczyh shczy,a.ysdm zyys
			,'' ssmc,a.memo,a.psbz,a.zbybz,a.zxksdm yfdm,fz.tspcsm,a.lcxmdm,a.yzlb,null xmlb,'  ' czbz,a.dybz as yzdybz
		into #LSYZDJDY
		from BQ_LSYZK a(nolock) inner join #yjm_bq_lsyzk wls on wls.syxh=a.syxh and wls.xh=a.xh
			left join BQ_LSYZK_FZ fz(nolock) on a.syxh=fz.syxh and a.xh=fz.yzxh
			left join YK_YPCDMLK cd (nolock) on a.idm=cd.idm
			left join ZY_YPYFK yf(nolock)on a.ypyf=yf.id
			left join ZY_YZPCK pc(nolock)on a.pcdm=pc.id
		where ((@config6C90='是')or(@config6C90<>'是' and a.blzbz=0))

		update #LSYZDJDY set xmlb=b.xmlb
		from #LSYZDJDY a inner join YY_SFXXMK b(nolock) on a.ypdm=b.id
		where a.idm=0 and isnull(a.lcxmdm,'0')='0'

		update #LSYZDJDY set xmlb=b.xmlb
		from #LSYZDJDY a inner join YY_LCSFXMK b(nolock) on a.lcxmdm=b.id
		where a.idm=0 and isnull(a.lcxmdm,'0')<>'0'

		--更新 --成组医嘱标识符 ┓ ┃ ┛ 
		select syxh,yexh,fzxh,min(yzxh) min_recno,max(yzxh) max_recno 
		into #tmp_fzxh_zh_ls
		from #LSYZDJDY 
		group by syxh,yexh,fzxh 
		having count(1)>1

		--初始化
		update #LSYZDJDY set czbz=''

		update #LSYZDJDY set czbz='┓'
		from #LSYZDJDY a,#tmp_fzxh_zh_ls b
		where a.syxh=b.syxh and a.yexh=b.yexh and a.fzxh=b.fzxh  and a.yzxh=b.min_recno

		update #LSYZDJDY set czbz='┛'
		from #LSYZDJDY a,#tmp_fzxh_zh_ls b
		where a.syxh=b.syxh and a.yexh=b.yexh and a.fzxh=b.fzxh  and a.yzxh=b.max_recno

		update #LSYZDJDY set czbz='┃'
		from #LSYZDJDY a,#tmp_fzxh_zh_ls b
		where a.syxh=b.syxh and a.yexh=b.yexh and a.fzxh=b.fzxh  and czbz=''

		select * into #BQ_LSYZDJDY_BF from BQ_LSYZDJDY_BF where 1=2

		insert into #BQ_LSYZDJDY_BF(syxh,yexh,bqdm,ksdm,djlx,yzxh,fzxh,zh,ksrq,idm,ypdm,ypmc
			,ypgg,ggdw,ypjl,jldw,ypsl,ypdw,ypyl,ypyf,yfmc,fysm
			,pcdm,pcmc,ztnr,tzrq,zxcs,zxrq,zxsj,lrczy,shczy,zyys
			,ssmc,memo,psbz,zbybz,yfdm,tspcsm,lcxmdm,yzlb,yzdybz)
		select a.syxh,a.yexh,a.bqdm,a.ksdm,dj.djlx,a.yzxh,a.fzxh,a.zh,a.ksrq,a.idm,a.ypdm,a.ypmc
			,a.ypgg,a.ggdw,a.ypjl,a.jldw,a.ypsl,a.ypdw,a.ypyl,a.ypyf,a.yfmc,a.fysm
			,a.pcdm,a.pcmc,a.ztnr,a.tzrq,a.zxcs,a.zxrq,a.zxsj,a.lrczy,a.shczy,a.zyys
			,a.ssmc,a.memo,a.psbz,a.zbybz,a.yfdm,a.tspcsm,a.lcxmdm,a.yzlb,a.yzdybz
		from #LSYZDJDY a
			inner join #YZDJK dj on dj.lb =0 
				and (dj.yfjh = '' or charindex( '"' + a.ypyf + '"', dj.yfjh) >0) 
				and (dj.yzlbjh = '' or charindex( '"' + convert(varchar(2),a.yzlb) + '"', dj.yzlbjh) >0)
		where not exists(select 1 from BQ_LSYZDJDY_BF bf(nolock) where bf.syxh=a.syxh and bf.yzxh=a.yzxh)
		UNION ALL
		select a.syxh,a.yexh,a.bqdm,a.ksdm,dj.djlx,a.yzxh,a.fzxh,a.zh,a.ksrq,a.idm,a.ypdm,a.ypmc
			,a.ypgg,a.ggdw,a.ypjl,a.jldw,a.ypsl,a.ypdw,a.ypyl,a.ypyf,a.yfmc,a.fysm
			,a.pcdm,a.pcmc,a.ztnr,a.tzrq,a.zxcs,a.zxrq,a.zxsj,a.lrczy,a.shczy,a.zyys
			,a.ssmc,a.memo,a.psbz,a.zbybz,a.yfdm,a.tspcsm,a.lcxmdm,a.yzlb,a.yzdybz
		from #LSYZDJDY a
			inner join #YZDJK dj on dj.lb =1 
				and (dj.xmlbjh = '' or charindex( '"' + convert(varchar(2),a.xmlb) + '"', dj.xmlbjh) >0)
				and (dj.yzlbjh = '' or charindex( '"' + convert(varchar(2),a.yzlb) + '"', dj.yzlbjh) >0)
		where not exists(select 1 from BQ_LSYZDJDY_BF bf(nolock) where bf.syxh=a.syxh and bf.yzxh=a.yzxh)
		UNION ALL
		select a.syxh,a.yexh,a.bqdm,a.ksdm,dj.djlx,a.yzxh,a.fzxh,a.zh,a.ksrq,a.idm,a.ypdm,a.ypmc
			,a.ypgg,a.ggdw,a.ypjl,a.jldw,a.ypsl,a.ypdw,a.ypyl,a.ypyf,a.yfmc,a.fysm
			,a.pcdm,a.pcmc,a.ztnr,a.tzrq,a.zxcs,a.zxrq,a.zxsj,a.lrczy,a.shczy,a.zyys
			,a.ssmc,a.memo,a.psbz,a.zbybz,a.yfdm,a.tspcsm,a.lcxmdm,a.yzlb,a.yzdybz
		from #LSYZDJDY a
			inner join #YZDJK dj ON dj.lb =2 
				and (
					(dj.yfjh = '' or charindex( '"' + a.ypyf + '"', dj.yfjh) >0) --OR a.ypyf='' 
					or 
					(dj.xmlbjh = '' or charindex( '"' + convert(varchar(2),a.xmlb) + '"', dj.xmlbjh) >0)--OR a.xmlb IS NULL 
				)
				and (dj.yzlbjh = '' or charindex( '"' + convert(varchar(2),a.yzlb) + '"', dj.yzlbjh) >0)
		where not exists(select 1 from BQ_LSYZDJDY_BF bf(nolock) where bf.syxh=a.syxh and bf.yzxh=a.yzxh)


		delete a from #BQ_LSYZDJDY_BF a where a.yzlb = 1 
		AND EXISTS(SELECT 1 FROM #YZDJK dj WHERE a.djlx=dj.djlx and isnull(dj.xmlbjh,'')<>'')
		and ypdm not in (select id from YY_SFXXMK sf(nolock) where sf.xmlb = 0 and sf.sybz=1 and sf.zybz=1) --xmlb 0治疗

		--根据项目集合删除
		delete a from #BQ_LSYZDJDY_BF a
		where EXISTS(SELECT 1 FROM #YZDJK dj WHERE a.djlx=dj.djlx  and dj.lb in (1,2) and isnull(dj.xmlbjh,'')<>''
		and ypdm not in (select id from YY_SFXXMK where (charindex( '"' +  rtrim(convert(char(2),xmlb)) + '"', dj.xmlbjh) >0)) )
		and lcxmdm='0' and yzlb<>0  --医嘱类别（0:药品，1治疗，3膳食，4输血，5护理，6检查，7检验，8输液）

		delete a from #BQ_LSYZDJDY_BF a
		where EXISTS(SELECT 1 FROM #YZDJK dj WHERE a.djlx=dj.djlx and dj.lb in (1,2) and isnull(dj.xmlbjh,'')<>''
		and lcxmdm not in (select id from YY_LCSFXMK where (charindex( '"' +  rtrim(convert(char(2),xmlb)) + '"', dj.xmlbjh) >0))) 						
		and lcxmdm <>'0' and yzlb<>0  --医嘱类别（0:药品，1治疗，3膳食，4输血，5护理，6检查，7检验，8输液）
	

		-- Add By wf In 20160528	非药品单据或者混合单据(含药品和项目)，根据"病区单据设置"的收费小项目打印
		--如果对应项目的收费小项目未设置，则取所有的,如果有设置，则取设置的小项目集合 begin
		delete a FROM #BQ_LSYZDJDY_BF a ,YY_SFXXMK b,#YZDJK dj,BQ_DJDYXMSZK d 
		where a.ypdm = b.id and  a.djlx=dj.djlx  and dj.id=d.djid  AND b.xmlb = d.xmlb
		and dj.lb in (1,2) and isnull(dj.xmlbjh,'')<>''
		and CHARINDEX('"'+rtrim(convert(varchar(12),a.ypdm))+'"',d.sfxxmjh) <= 0
		and a.lcxmdm='0' and a.yzlb<>0

		insert into BQ_LSYZDJDY_BF(syxh,yexh,bqdm,ksdm,djlx,yzxh,fzxh,zh,ksrq,idm,ypdm,ypmc
			,ypgg,ggdw,ypjl,jldw,ypsl,ypdw,ypyl,ypyf,yfmc,fysm
			,pcdm,pcmc,ztnr,tzrq,zxcs,zxrq,zxsj,lrczy,shczy,zyys
			,ssmc,memo,psbz,zbybz,yfdm,tspcsm,lcxmdm,yzlb,yzdybz)
		select syxh,yexh,bqdm,ksdm,djlx,yzxh,fzxh,zh,ksrq,idm,ypdm,ypmc
			,ypgg,ggdw,ypjl,jldw,ypsl,ypdw,ypyl,ypyf,yfmc,fysm
			,pcdm,pcmc,ztnr,tzrq,zxcs,zxrq,zxsj,lrczy,shczy,zyys
			,ssmc,memo,psbz,zbybz,yfdm,tspcsm,lcxmdm,yzlb,yzdybz
		from #BQ_LSYZDJDY_BF a
		where not exists(select 1 from BQ_LSYZDJDY_BF bf(nolock) where bf.syxh=a.syxh and bf.yzxh=a.yzxh)

		if object_id('tempdb..#BQ_LSYZDJDY_BF') is not null
		drop table #BQ_LSYZDJDY_BF
	end
	if exists(select 1 from #yjm_bq_cqyzk)
	begin
		--长期，有时间点的拆分zxzqdw in (-1,0)
		insert into BQ_CQYZMXK(yzxh,fzxh,syxh,yexh--,hzxm,bqdm,ksdm,ysdm,lrrq
			--,lrczyh,shrq,shczyh,ksrq,zxrq,zxczyh,dcczyh,qxsj,dcysdm,tzxh
			--,tzrq,tzysdm,idm,ypdm,ypmc,ypgg,ypjl,jldw,dwlb,ypsl
			--,zxdw,ztnr,djfl,yzdjfl,ypyf,pcdm,zxcs,zxzq,zxzqdw,zdm,zxsj
			,pczxsj,yztm--,yzlb,yzzt,zbybz,zxksdm,cgyzbz,yjqrbz
			)
		select a.xh,a.fzxh,a.syxh,a.yexh--,a.hzxm,a.bqdm,a.ksdm,a.ysdm,a.lrrq
			--,a.lrczyh,a.shrq,a.shczyh,a.ksrq,a.zxrq,'' zxczyh,a.dcczyh,a.qxsj,a.dcysdm,0 tzxh
			--,a.tzrq,a.tzysdm,a.idm,a.ypdm,a.ypmc,a.ypgg,a.ypjl,a.jldw,a.dwlb,a.ypsl
			--,a.zxdw,a.ztnr,a.djfl,a.yzdjfl,a.ypyf,a.pcdm,a.zxcs,a.zxzq,a.zxzqdw,a.zdm,a.zxsj
			,c.hr pczxsj,'' yztm--,a.yzlb,a.yzzt,a.zbybz,a.zxksdm,a.cgyzbz,a.yjqrbz
		from BQ_CQYZK a(nolock) inner join #yjm_bq_cqyzk wcq on wcq.syxh=a.syxh and wcq.xh=a.xh
			inner join YY_Hour c(nolock) on charindex(c.hr,a.zxsj)>0
		where a.yzlb in (0,8,1,3,4,5,6,7) and a.zxzqdw in (-1,0)
			and not exists(select 1 from BQ_CQYZMXK mx(nolock) where mx.syxh=a.syxh and mx.yzxh=a.xh)

		if exists(select 1 from BQ_CQYZK a(nolock) inner join #yjm_bq_cqyzk wcq on wcq.syxh=a.syxh and wcq.xh=a.xh
			where a.zxzqdw in (1,2)
			)
		begin
			--长期，按小时、或分钟的频次拆分zxzqdw in (1,2) 
			DECLARE @time table 
			(
				zxrq varchar(8) not null,
				zxsj varchar(16) not null
			)
			declare @dqzxsj1 varchar(20)

			declare cs_yzcf cursor for 
				select a.xh,a.ksrq,a.dqzxsj,a.zxzqdw,a.zxzq 
				from BQ_CQYZK a(nolock) inner join #yjm_bq_cqyzk wcq on wcq.syxh=a.syxh and wcq.xh=a.xh
				where a.yzlb in (0,8,1,3,4,5,6,7) and a.zxzqdw in (1,2)
					and not exists(select 1 from BQ_CQYZMXK mx(nolock) where mx.syxh=a.syxh and mx.yzxh=a.xh)
			for read only
			open cs_yzcf
			fetch cs_yzcf into @cs_yzxh,@cs_ksrq,@cs_dqzxsj,@cs_zxzqdw,@cs_zxzq 
			while @@fetch_status=0
			begin
				delete @time
				if @cs_dqzxsj is null or @cs_dqzxsj=''
					select @cs_dqzxsj=@cs_ksrq
				select @cs_ksrq=convert(varchar(8),dateadd(day,1,substring(@cs_ksrq,1,8)),112)+substring(@cs_ksrq,9,8)
				while @cs_dqzxsj<@cs_ksrq
				begin
					insert into @time values(substring(@cs_dqzxsj,1,8),@cs_dqzxsj)

					if @cs_zxzqdw=1
						select @dqzxsj1=convert(varchar(20),dateadd(hh,@cs_zxzq,substring(@cs_dqzxsj,1,8)+' '+substring(@cs_dqzxsj,9,8)),121)
					else
						select @dqzxsj1=convert(varchar(20),dateadd(mi,@cs_zxzq,substring(@cs_dqzxsj,1,8)+' '+substring(@cs_dqzxsj,9,8)),121)
					select @cs_dqzxsj=substring(@dqzxsj1,1,4)+substring(@dqzxsj1,6,2)+substring(@dqzxsj1,9,2)+substring(@dqzxsj1,12,8)
				end

				insert into BQ_CQYZMXK(yzxh,fzxh,syxh,yexh--,hzxm,bqdm,ksdm,ysdm,lrrq
					--,lrczyh,shrq,shczyh,ksrq,zxrq,zxczyh,dcczyh,qxsj,dcysdm,tzxh
					--,tzrq,tzysdm,idm,ypdm,ypmc,ypgg,ypjl,jldw,dwlb,ypsl
					--,zxdw,ztnr,djfl,yzdjfl,ypyf,pcdm,zxcs,zxzq,zxzqdw,zdm,zxsj
					,pczxsj,yztm--,yzlb,yzzt,zbybz,zxksdm,cgyzbz,yjqrbz
					)
				select a.xh,a.fzxh,a.syxh,a.yexh--,a.hzxm,a.bqdm,a.ksdm,a.ysdm,a.lrrq
					--,a.lrczyh,a.shrq,a.shczyh,a.ksrq,a.zxrq,'' zxczyh,a.dcczyh,a.qxsj,a.dcysdm,0 tzxh
					--,a.tzrq,a.tzysdm,a.idm,a.ypdm,a.ypmc,a.ypgg,a.ypjl,a.jldw,a.dwlb,a.ypsl
					--,a.zxdw,a.ztnr,a.djfl,a.yzdjfl,a.ypyf,a.pcdm,a.zxcs,a.zxzq,a.zxzqdw,a.zdm,a.zxsj
					,substring(b.zxsj,9,5) pczxsj,'' yztm--,a.yzlb,a.yzzt,a.zbybz,a.zxksdm,a.cgyzbz,a.yjqrbz
				from BQ_CQYZK a(nolock) inner join #yjm_bq_cqyzk wcq on wcq.syxh=a.syxh and wcq.xh=a.xh
					cross join @time b
				where a.xh=@cs_yzxh

				fetch cs_yzcf into @cs_yzxh,@cs_ksrq,@cs_dqzxsj,@cs_zxzqdw,@cs_zxzq 
			end
			close cs_yzcf
			deallocate cs_yzcf
		end

		select a.syxh,a.yexh,a.bqdm,a.ksdm,null djlx,a.xh as yzxh,a.fzxh,0 zh,a.ksrq,a.idm,a.ypdm,a.ypmc
			,a.ypgg,cd.ggdw,a.ypjl,a.jldw,a.ypsl,a.zxdw ypdw,a.ypjl ypyl,a.ypyf,yf.name yfmc,'' fysm
			,a.pcdm,pc.name pcmc,a.ztnr,a.tzrq,a.zxzq,a.zxzqdw,a.zdm,a.zxcs,a.zxrq,a.zxsj,a.lrczyh lrczy,a.shczyh shczy,a.ysdm zyys
			,'' ssmc,a.memo,0 psbz,a.zbybz,a.zxksdm yfdm,fz.tspcsm,a.lcxmdm,a.yzlb,null xmlb,'  ' czbz,a.dybz as yzdybz
		into #CQYZDJDY
		from BQ_CQYZK a(nolock) inner join #yjm_bq_cqyzk wcq on wcq.syxh=a.syxh and wcq.xh=a.xh
			left join BQ_CQYZK_FZ fz(nolock) on a.syxh=fz.syxh and a.xh=fz.yzxh
			left join YK_YPCDMLK cd (nolock) on a.idm=cd.idm
			left join ZY_YPYFK yf(nolock)on a.ypyf=yf.id
			left join ZY_YZPCK pc(nolock)on a.pcdm=pc.id

		update #CQYZDJDY set xmlb=b.xmlb
		from #CQYZDJDY a inner join YY_SFXXMK b(nolock) on a.ypdm=b.id
		where a.idm=0 and isnull(a.lcxmdm,'0')='0'

		update #CQYZDJDY set xmlb=b.xmlb
		from #CQYZDJDY a inner join YY_LCSFXMK b(nolock) on a.lcxmdm=b.id
		where a.idm=0 and isnull(a.lcxmdm,'0')<>'0'

		--更新 --成组医嘱标识符 ┓ ┃ ┛ 
		select syxh,yexh,fzxh,min(yzxh) min_recno,max(yzxh) max_recno 
		into #tmp_fzxh_zh_cq
		from #CQYZDJDY 
		group by syxh,yexh,fzxh 
		having count(1)>1

		--初始化
		update #CQYZDJDY set czbz=''

		update #CQYZDJDY set czbz='┓'
		from #CQYZDJDY a,#tmp_fzxh_zh_cq b
		where a.syxh=b.syxh and a.yexh=b.yexh and a.fzxh=b.fzxh  and a.yzxh=b.min_recno

		update #CQYZDJDY set czbz='┛'
		from #CQYZDJDY a,#tmp_fzxh_zh_cq b
		where a.syxh=b.syxh and a.yexh=b.yexh and a.fzxh=b.fzxh  and a.yzxh=b.max_recno

		update #CQYZDJDY set czbz='┃'
		from #CQYZDJDY a,#tmp_fzxh_zh_cq b
		where a.syxh=b.syxh and a.yexh=b.yexh and a.fzxh=b.fzxh  and czbz=''
		
        select * into #BQ_CQYZDJDY_BF from BQ_CQYZDJDY_BF where 1=2
		
		insert into #BQ_CQYZDJDY_BF(syxh,yexh,bqdm,ksdm,djlx,yzxh,fzxh,zh,ksrq,idm,ypdm,ypmc
			,ypgg,ggdw,ypjl,jldw,ypsl,ypdw,ypyl,ypyf,yfmc,fysm
			,pcdm,pcmc,ztnr,tzrq,zxzq,zxzqdw,zdm,zxcs,zxrq,zxsj,lrczy,shczy,zyys
			,ssmc,memo,psbz,zbybz,yfdm,tspcsm,lcxmdm,yzlb,yzdybz)
		select a.syxh,a.yexh,a.bqdm,a.ksdm,dj.djlx,a.yzxh,a.fzxh,a.zh,a.ksrq,a.idm,a.ypdm,a.ypmc
			,a.ypgg,a.ggdw,a.ypjl,a.jldw,a.ypsl,a.ypdw,a.ypyl,a.ypyf,a.yfmc,a.fysm
			,a.pcdm,a.pcmc,a.ztnr,a.tzrq,a.zxzq,a.zxzqdw,a.zdm,a.zxcs,a.zxrq,a.zxsj,a.lrczy,a.shczy,a.zyys
			,a.ssmc,a.memo,a.psbz,a.zbybz,a.yfdm,a.tspcsm,a.lcxmdm,a.yzlb,a.yzdybz
		from #CQYZDJDY a
			inner join #YZDJK dj on dj.lb =0 
				and (dj.yfjh = '' or charindex( '"' + a.ypyf + '"', dj.yfjh) >0) 
				and (dj.yzlbjh = '' or charindex( '"' + convert(varchar(2),a.yzlb) + '"', dj.yzlbjh) >0)
		where not exists(select 1 from BQ_CQYZDJDY_BF bf(nolock) where bf.syxh=a.syxh and bf.yzxh=a.yzxh)
		UNION ALL
		select a.syxh,a.yexh,a.bqdm,a.ksdm,dj.djlx,a.yzxh,a.fzxh,a.zh,a.ksrq,a.idm,a.ypdm,a.ypmc
			,a.ypgg,a.ggdw,a.ypjl,a.jldw,a.ypsl,a.ypdw,a.ypyl,a.ypyf,a.yfmc,a.fysm
			,a.pcdm,a.pcmc,a.ztnr,a.tzrq,a.zxzq,a.zxzqdw,a.zdm,a.zxcs,a.zxrq,a.zxsj,a.lrczy,a.shczy,a.zyys
			,a.ssmc,a.memo,a.psbz,a.zbybz,a.yfdm,a.tspcsm,a.lcxmdm,a.yzlb,a.yzdybz
		from #CQYZDJDY a
			inner join #YZDJK dj on dj.lb =1 
				and (dj.xmlbjh = '' or charindex( '"' + convert(varchar(2),a.xmlb) + '"', dj.xmlbjh) >0)
				and (dj.yzlbjh = '' or charindex( '"' + convert(varchar(2),a.yzlb) + '"', dj.yzlbjh) >0)
		where not exists(select 1 from BQ_CQYZDJDY_BF bf(nolock) where bf.syxh=a.syxh and bf.yzxh=a.yzxh)
		UNION ALL
		select a.syxh,a.yexh,a.bqdm,a.ksdm,dj.djlx,a.yzxh,a.fzxh,a.zh,a.ksrq,a.idm,a.ypdm,a.ypmc
			,a.ypgg,a.ggdw,a.ypjl,a.jldw,a.ypsl,a.ypdw,a.ypyl,a.ypyf,a.yfmc,a.fysm
			,a.pcdm,a.pcmc,a.ztnr,a.tzrq,a.zxzq,a.zxzqdw,a.zdm,a.zxcs,a.zxrq,a.zxsj,a.lrczy,a.shczy,a.zyys
			,a.ssmc,a.memo,a.psbz,a.zbybz,a.yfdm,a.tspcsm,a.lcxmdm,a.yzlb,a.yzdybz
		from #CQYZDJDY a
			inner join #YZDJK dj ON dj.lb =2 
				and (
					(dj.yfjh = '' or charindex( '"' + a.ypyf + '"', dj.yfjh) >0) --OR a.ypyf='' 
					or 
					(dj.xmlbjh = '' or charindex( '"' + convert(varchar(2),a.xmlb) + '"', dj.xmlbjh) >0) --OR a.xmlb IS NULL
				)
				and (dj.yzlbjh = '' or charindex( '"' + convert(varchar(2),a.yzlb) + '"', dj.yzlbjh) >0)
		where not exists(select 1 from BQ_CQYZDJDY_BF bf(nolock) where bf.syxh=a.syxh and bf.yzxh=a.yzxh)

		
		delete a from #BQ_CQYZDJDY_BF a where a.yzlb = 1 
		AND EXISTS(SELECT 1 FROM #YZDJK dj WHERE a.djlx=dj.djlx and isnull(dj.xmlbjh,'')<>'')
		and ypdm not in (select id from YY_SFXXMK sf(nolock) where (sf.xmlb =0 or sf.id in('900443','900432','zb0006','zb0051','zb0052','zb0053','zb0054','zb0055','zb0056','zb0057','zb0058','zb0059','zb0060','zb0061')) and sf.sybz=1 and sf.zybz=1) --xmlb 0治疗---
ZJQ sf.xmlb =0 修改为 (sf.xmlb =0 or sf.id='900443'),不然ypdm='900443'的医嘱会被屏蔽

		--根据项目集合删除
		delete a from #BQ_CQYZDJDY_BF a
		where EXISTS(SELECT 1 FROM #YZDJK dj WHERE a.djlx=dj.djlx  and dj.lb in (1,2) and isnull(dj.xmlbjh,'')<>''
		and ypdm not in (select id from YY_SFXXMK where (charindex( '"' +  rtrim(convert(char(2),xmlb)) + '"', dj.xmlbjh) >0)) )
		and lcxmdm='0' and yzlb<>0  --医嘱类别（0:药品，1治疗，3膳食，4输血，5护理，6检查，7检验，8输液）

		delete a from #BQ_CQYZDJDY_BF a
		where EXISTS(SELECT 1 FROM #YZDJK dj WHERE a.djlx=dj.djlx and dj.lb in (1,2) and isnull(dj.xmlbjh,'')<>''
		and lcxmdm not in (select id from YY_LCSFXMK where (charindex( '"' +  rtrim(convert(char(2),xmlb)) + '"', dj.xmlbjh) >0))) 						
		and lcxmdm <>'0' and yzlb<>0  --医嘱类别（0:药品，1治疗，3膳食，4输血，5护理，6检查，7检验，8输液）
		and a.ypdm not in ('zb0006','zb0051','zb0052','zb0053','zb0054','zb0055','zb0056','zb0057','zb0058','zb0059','zb0060','zb0061') --lj 加入康复DKF需要打印的数据
	

		-- Add By wf In 20160528	非药品单据或者混合单据(含药品和项目)，根据"病区单据设置"的收费小项目打印
		--如果对应项目的收费小项目未设置，则取所有的,如果有设置，则取设置的小项目集合 begin
		delete a FROM #BQ_CQYZDJDY_BF a ,YY_SFXXMK b,#YZDJK dj,BQ_DJDYXMSZK d 
		where a.ypdm = b.id and  a.djlx=dj.djlx  and dj.id=d.djid  AND b.xmlb = d.xmlb
		and dj.lb in (1,2) and isnull(dj.xmlbjh,'')<>''
		and CHARINDEX('"'+rtrim(convert(varchar(12),a.ypdm))+'"',d.sfxxmjh) <= 0
		and a.lcxmdm='0' and a.yzlb<>0

		insert into BQ_CQYZDJDY_BF(syxh,yexh,bqdm,ksdm,djlx,yzxh,fzxh,zh,ksrq,idm,ypdm,ypmc
		,ypgg,ggdw,ypjl,jldw,ypsl,ypdw,ypyl,ypyf,yfmc,fysm
		,pcdm,pcmc,ztnr,tzrq,zxzq,zxzqdw,zdm,zxcs,zxrq,zxsj,lrczy,shczy,zyys
		,ssmc,memo,psbz,zbybz,yfdm,tspcsm,lcxmdm,yzlb,yzdybz)
		select syxh,yexh,bqdm,ksdm,djlx,yzxh,fzxh,zh,ksrq,idm,ypdm,ypmc
		,ypgg,ggdw,ypjl,jldw,ypsl,ypdw,ypyl,ypyf,yfmc,fysm
		,pcdm,pcmc,ztnr,tzrq,zxzq,zxzqdw,zdm,zxcs,zxrq,zxsj,lrczy,shczy,zyys
		,ssmc,memo,psbz,zbybz,yfdm,tspcsm,lcxmdm,yzlb,yzdybz
		from #BQ_CQYZDJDY_BF a
		where not exists(select 1 from BQ_CQYZDJDY_BF bf(nolock) where bf.syxh=a.syxh and bf.yzxh=a.yzxh)

		if object_id('tempdb..#BQ_CQYZDJDY_BF') is not null
		drop table #BQ_CQYZDJDY_BF

	end
	--==============================医嘱明细拆分   end======================================
	
	--select @brfyye = 0 --病人费用余额
	--exec usp_zy_bryjjbj	@syxh, 1, 0, @errmsg output  -- 在院病人预交金报警（后台调用）   
	--if @errmsg like 'F%'	
	--	select @qkbz=1	--欠款标志 0否 1是
	--else
	--	select @brfyye = convert(numeric(14,4),rtrim(ltrim(substring(@errmsg,2,49))))


	---创建核对通过医嘱临时表，用于医嘱闭环--------------------------------
	declare @config0251 varchar(2)
	select @config0251 =isnull(config,'否') from YY_CONFIG (nolock) where id='0251' 
	create table #yshyz
	(
		yzxh ut_xh12 null,
		cqlsbz ut_bz null,
		yzzt ut_bz null
	)
	--------------------------------------------------------------------------
	begin tran --=======●●●事务 开始============================
	
	--==============================出院带药核对   start======================================
	-----------------上海儿童医院出院带药核对--swx 20140227-----
	if exists(select 1 from BQ_LSYZK a(nolock) inner join #yjm_bq_lsyzk wls on a.syxh=wls.syxh and wls.xh=a.xh
		where a.yzzt= 0 and a.yzlb=12 
		)	-- 全部核对时，出院带药医嘱处理
	begin
		if exists(select 1 from YY_CONFIG(nolock) where id='6C03' and config='是')
		begin
			--select @cydyfyye=0
			--select @cydyfyye=sum(a.ypsl*cd.ylsj) 
			select syxh,yexh,sum(a.ypsl*cd.ylsj) as cydyje
			into #cydyfyye
			from BQ_LSYZK a(nolock) inner join #yjm_bq_lsyzk wls on a.syxh=wls.syxh and wls.xh=a.xh
				inner join YK_YPCDMLK cd(nolock) on a.idm=cd.idm
			where a.yzzt= 0 and a.yzlb=12 
			group by a.syxh,a.yexh
			
			--if @cydyfyye>@brfyye
			begin
				--delete from  #yjm_bq_lsyzk 
				--where fzxh in (select a.fzxh from BQ_LSYZK a (nolock) inner join #yjm_bq_lsyzk b on a.fzxh=b.fzxh 
				--	where a.yzzt=0 and a.yzlb=12 
				--	)
				
				delete #yjm_bq_lsyzk 
				from #yjm_bq_lsyzk wls inner join #cydyfyye b on wls.syxh=b.syxh and wls.yexh=b.yexh and wls.brfyye<b.cydyje
					inner join BQ_LSYZK a(nolock) on a.xh=wls.xh and a.yzzt=0 and a.yzlb=12 
				if @@rowcount>0
					select @shnr='出院带药药品金额大于病人余额，不能核对！'
				
				if not exists (select 1 from BQ_LSYZK a (nolock) inner join #yjm_bq_lsyzk wls on a.xh=wls.xh where a.yzzt=0)
					and not exists (select 1 from BQ_CQYZK a (nolock) inner join #yjm_bq_cqyzk wcq on a.xh=wcq.xh  where a.yzzt=0)
				begin
					rollback  tran
					select "F",@shnr
					return
				end
			end
		end
		if @shnr<>'出院带药药品金额大于病人余额，不能核对！'
		begin
			declare cs_brlist cursor for   
				select distinct a.syxh
				from BQ_LSYZK a(nolock)inner join #yjm_bq_lsyzk wls on a.syxh=wls.syxh and wls.xh=a.xh
				where a.yzlb=12
			for read only  
			open cs_brlist  
			fetch cs_brlist into @cs_syxh  
			while @@fetch_status=0
			begin
				exec usp_bq_cydysh '',1,@cs_syxh,@delphi = 0,@errmsg = @errmsg output,@usewbtran=1  --使用外部事物 0否 1是
				if @errmsg like "F%"
				begin
					rollback tran
					deallocate cs_brlist
					select "F",substring(@errmsg,2,50)
					return      
				end
				
				declare cs_cydy_yzsh cursor for		--第二步
					select distinct a.xh						-- 病人待审的出院带药
					from BQ_LSYZK a(nolock)inner join #yjm_bq_lsyzk wls on a.syxh=wls.syxh and wls.xh=a.xh
					where a.syxh=@cs_syxh and a.yzzt= 0 and a.yzlb=12
				for read only
				open cs_cydy_yzsh 
				fetch cs_cydy_yzsh into @cs_yzxh
				while @@fetch_status=0 ---游标 cs_cydy_yzsh while Start
				begin
					if @config0251='是'--医嘱闭环状态更新
					begin
						insert into #yshyz 
						select distinct xh,0,2
						from BQ_LSYZK (nolock) 
						where syxh=@cs_syxh and xh=@cs_yzxh
					end   
					update BQ_LSYZK set yzzt=2,shrq=null,zxrq=null,shczyh=null,zxczyh=null 
					where syxh=@cs_syxh and xh=@cs_yzxh

					exec usp_bq_cydysh '',2,@cs_syxh,@cs_yzxh,@delphi = 0,@errmsg = @errmsg output,@usewbtran=1  --使用外部事物 0否 1是 	
					if @errmsg like "F%"
					begin
						rollback  tran
						deallocate cs_cydy_yzsh
						deallocate cs_brlist
						select "F",substring(@errmsg,2,50)
						return      
					end 		

					fetch cs_cydy_yzsh into @cs_yzxh
				end 
				close cs_cydy_yzsh
				deallocate cs_cydy_yzsh

				exec usp_bq_cydysh '',3,@cs_syxh,@cs_yzxh,@czyh,@czyh,@delphi = 0,@errmsg = @errmsg output,@usewbtran=1  --使用外部事物 0否 1是
				if @errmsg like "F%"
				begin
					rollback  tran
					deallocate cs_brlist
					select "F",substring(@errmsg,2,50)
					return      
				end	
			
				fetch cs_brlist into @cs_syxh
			end  
			close cs_brlist  
			deallocate cs_brlist  
		end		
	end
	--==============================出院带药核对   end========================================
	--==============================住院小处方核对   start====================================
	if (@config6142 = '是') and (@config6583 = '是')
	begin
		if exists(select 1 from BQ_LSYZK a(nolock)inner join #yjm_bq_lsyzk wls on a.syxh=wls.syxh and wls.xh=a.xh where a.yzlb=14)
		begin
			declare @stryzxh ut_xh12,
					@strbqdm ut_ksdm
			declare cs_bqdm cursor FOR 
				select distinct a.xh,a.bqdm,a.syxh,a.yexh 
				from BQ_LSYZK a(nolock)inner join #yjm_bq_lsyzk wls on a.syxh=wls.syxh and wls.xh=a.xh 
				where a.yzlb=14 --and a.yzzt = 1 and a.shczyh = @czyh and a.shrq = @now
					--and not exists (select 1 from BQ_FYQQK b(nolock) where b.yzxh=a.xh and a.syxh=b.syxh AND b.jlzt=0) 
			open cs_bqdm
			fetch cs_bqdm into @stryzxh,@strbqdm,@cs_syxh,@cs_yexh
			while @@fetch_status=0
			BEGIN
				update BQ_LSYZK set yzzt = 2,shrq = null,shczyh = null,zxrq=null,zxczyh=null 
				where xh = @stryzxh --and yzlb = 14 and yzzt = 1
					
				--小处方核对
				exec usp_zy_xcfsh @czyh,1,@cs_syxh,@cflx =0 
				exec usp_zy_xcfsh @czyh,2,@cs_syxh,@stryzxh,@czyh,@czyh,@strbqdm,@dlksdm
				exec usp_zy_xcfsh @czyh,3,@cs_syxh,0,@czyh,@czyh,'','',0 
				
				fetch cs_bqdm into @stryzxh,@strbqdm,@cs_syxh,@cs_yexh
			end
			close cs_bqdm
			deallocate cs_bqdm 
		end
	end	
	--==============================住院小处方核对   end======================================
	--==============================草药核对   start==========================================
	if exists(select 1 from YY_CONFIG (nolock) where id='G306' and config='是')
	begin
		if exists(select 1 from BQ_LSYZK a(nolock)inner join #yjm_bq_lsyzk wls on a.syxh=wls.syxh and wls.xh=a.xh where a.yzlb=15)
		begin
			declare cs_brlist cursor for
				select distinct a.syxh,a.yexh
				from BQ_LSYZK a(nolock)inner join #yjm_bq_lsyzk wls on a.syxh=wls.syxh and wls.xh=a.xh 
				where a.yzlb=15
			for read only  
			open cs_brlist  
			fetch cs_brlist into @cs_syxh,@cs_yexh  
			while @@fetch_status=0
			begin
				select @cs_fzxh=max(a.xh) 
				from BQ_LSYZK a(nolock)inner join #yjm_bq_lsyzk wls on a.syxh=wls.syxh and wls.xh=a.xh 
				where a.syxh=@cs_syxh and a.yzlb=15
				
				exec usp_bq_cyshqf @syxh=@cs_syxh,@czyh=@czyh,@yexh=@cs_yexh,@maxcqyzxh =0
					,@maxlsyzxh =@cs_fzxh,@emrsybz = 0,@delphi =0,@errmsg = @errmsg output
				if (@errmsg like "F%") and (@config6975='2')
				begin
					rollback tran
					deallocate cs_brlist
					select "F",substring(@errmsg,2,50)
					return
				end
				
				declare cs_cursor cursor for 
					select distinct a.fzxh 
					from BQ_LSYZK a(nolock)inner join #yjm_bq_lsyzk wls on a.syxh=wls.syxh and wls.xh=a.xh 
					where a.syxh=@cs_syxh and a.yzlb=15
				for read only
				open cs_cursor
				fetch cs_cursor into @cs_fzxh    
				while @@fetch_status=0
				begin
					exec usp_bq_cyyzsh_ex @cs_syxh,@cs_yexh,1,@cs_fzxh,0,@czyh,0,@errmsg output
					if @errmsg like 'F%' 
					begin
						rollback tran
						deallocate cs_cursor
						deallocate cs_brlist
						select "F",substring(@errmsg,2,50)
						return
					end
					fetch cs_cursor into @cs_fzxh 
				end
				close cs_cursor
				deallocate cs_cursor

				fetch cs_brlist into @cs_syxh,@cs_yexh
			end
			close cs_brlist
			deallocate cs_brlist
		end
	end
	--==============================草药核对   end============================================
	--if @shlb=0  ---=======================▲核对类别 0=全部医嘱  start=====================================
	begin
		if exists(select 1 from YY_CONFIG (nolock) where id = 'Y002' and config='是')  --参数Y002 (福建)是否需要医嘱审批 为 是 start
		begin
			--将已用的审批记录更新为已用
			update YY_BRSPXMK
			set yyspsl = b.ypsl  , spbz = 2
			from YY_BRSPXMK a inner join #yjm_bq_lsyzk wls on a.syxh=wls.syxh 
				inner join BQ_LSYZK b(nolock)on wls.syxh = b.syxh and wls.xh=b.xh and b.yzzt = 0
					and a.idm = b.idm and a.ypdm = b.ypdm 
			where a.spbz = 1
			if @@error<>0
			begin
				rollback tran
				select "F","更新审批信息失败！"
				return
			end
		end --参数Y002 (福建)是否需要医嘱审批 为 是 end

		--将已用的职称审批记录更新为已用
		if exists (select 1 from BQ_BRXZYYSQK a(nolock)inner join #yjm_bq_cqyzk yz on yz.syxh = a.syxh where spbz = 1)
		begin
			--将已用的审批记录更新为已用
			update BQ_BRXZYYSQK
			set spbz = 2
			from BQ_BRXZYYSQK a inner join #yjm_bq_cqyzk wcq on a.syxh=wcq.syxh
				inner join BQ_CQYZK b(nolock)on wcq.syxh = b.syxh and wcq.xh=b.xh and b.yzzt=0 
					and a.idm = b.idm and a.ypdm = b.ypdm and a.sqry = b.ysdm
			where a.spbz = 1
			if @@error<>0
			begin
				rollback tran
				select "F","更新职称审批信息失败！"
				return
			end
		end
		
		--if (@yzbz = 0) or (@yzbz = -1) 	--▲▲核对全部或核对临时 @yzbz 医嘱类别(0:临时, -1:全部) start
		begin
			--yzlb=2 手术医嘱处理 begin
			if exists(select 1 from BQ_LSYZK a(nolock) inner join  #yjm_bq_lsyzk wls on a.syxh=wls.syxh and wls.xh=a.xh
				where a.yzzt=0 and a.yzlb=2 and ( (@sfxyzlc=0) or (isnull(a.ssyzzt,0)=2 )  )
				)
			begin ----△if LLLLLL start
				if (select config from YY_CONFIG (nolock) where id="G090")='否' or @configks20>0
				begin  	
					if @config6036='是' and @config6501<>'是'	----△△△参数6036 是否使用手术管理系统 为是 且 参数6501，是否使用围手术抗生素控制功能 为否 start
					begin
		          		insert into SS_SSDJK(syxh, yzxh, patid, blh, hzxm, py, wb, bqdm, ksdm, 
							cwdm, djrq, djczyh, sqrq, ssdm, ssmc, mzdm, mzmc, ssksdm, 
							glbz, qkdj, jlzt, slbz, sslb, memo, ysdm,sqzd,haabz,aprq,jzssbz
							)
						select c.syxh, c.xh, a.patid, a.blh, a.hzxm, a.py, a.wb, a.bqdm, a.ksdm,
			    			a.cwdm,@now, @czyh,case when len(c.ssaprq)=16 then c.ssaprq else c.ksrq end sqrq,--case when @configG256='是' and isnull(c.ssaprq,'')<>'' then c.ssaprq else c.ksrq  end sqrq,--winning-dingsong-chongqing
			    			c.ypdm, convert(varchar(64),c.ypmc), c.mzdm,isnull(b.name,'') mzmc, c.zxksdm,0, null,@ssjlzt, 0, 0, 
							convert(varchar(24),c.ztnr), case isnull(c.memo,'') when '' then (case isnull(b.name,'') when '' then '' else c.ysdm 
							end) else c.memo end as ysdm,c.sqzd,c.haabz,c.ssaprq,c.jzssbz
						from ZY_BRSYK a (nolock)inner join #yjm_bq_lsyzk wls on a.syxh=wls.syxh 
							inner join BQ_LSYZK c(nolock) on wls.syxh=c.syxh and wls.xh=c.xh and c.yzzt=0 and c.yzlb=2 
							left join SS_SSMZK b (nolock) on b.id=c.mzdm
						if @@error<>0
						begin
							rollback tran
							select "F","核对手术医嘱出错！"
							return
						end
	                    
						--DECLARE @xhtemp ut_xh12  
						--SELECT @xhtemp = @@identity   ---保存SS_SSDJK.xh
						
						--主刀医生
						IF NOT EXISTS (
							SELECT 1 FROM SS_SSRYK a(NOLOCK)inner join SS_SSDJK b(NOLOCK)on a.ssxh=b.xh AND a.rydm=b.ysdm
								inner join BQ_LSYZK c(nolock) on c.xh=b.yzxh and c.yzzt=0 and c.yzlb=2 
							WHERE a.rylb=1 
								and exists(select 1 from #yjm_bq_lsyzk wls where c.syxh=wls.syxh and wls.xh=c.xh)
							)
						begin ----if LLLLLL_aaaaa_111_iiii1 start
							insert into SS_SSRYK(ssxh,rylb,rydm,ryxm,memo,isjb)
							select e.xh,1,e.ysdm,d.name,null,0
							from ZY_BRSYK a (nolock)inner join #yjm_bq_lsyzk wls on a.syxh=wls.syxh
								inner join BQ_LSYZK c(nolock) on wls.syxh =c.syxh and wls.xh=c.xh and c.yzzt=0 and c.yzlb=2 
								inner join SS_SSDJK e(nolock) on c.xh=e.yzxh and isnull(e.ysdm,'') != ''
								left join YY_ZGBMK d(nolock) on e.ysdm =d.id 	
							if @@error<>0
							begin
								rollback tran
								select "F","核对手术医嘱出错！"
								return
							END	
						END ----if LLLLLL_aaaaa_111_iiii1 end

						--生成手术一助
						IF NOT EXISTS (
							SELECT 1 FROM SS_SSRYK a(NOLOCK)inner join SS_SSDJK b(NOLOCK)on a.ssxh=b.xh 
								inner join  BQ_LSYZK c(nolock) on c.xh=b.yzxh and c.yzzt=0 and c.yzlb=2 
							WHERE a.rylb=2
								and exists(select 1 from #yjm_bq_lsyzk wls where c.syxh=wls.syxh and wls.xh=c.xh)
							)
						BEGIN ----if LLLLLL_aaaaa_111_iiii2 start
							insert into SS_SSRYK(ssxh,rylb,rydm,ryxm,memo,isjb)
							select e.xh,2,c.ssyzysdm,d.name,null,0
							from ZY_BRSYK a (nolock)
								inner join BQ_LSYZK c(nolock) on a.syxh= c.syxh and c.yzzt=0 and c.yzlb=2 and isnull(c.ssyzysdm,'') != '' 
								inner join #yjm_bq_lsyzk wls on c.syxh=wls.syxh and wls.xh=c.xh
								inner join SS_SSDJK e(nolock) on c.xh=e.yzxh 
								left join YY_ZGBMK d(nolock) on c.ssyzysdm=d.id 
							if @@error<>0
							begin
								rollback tran
								select "F","核对手术医嘱出错！"
								return
							END
						END ----if LLLLLL_aaaaa_111_iiii2 end

						--生成手术二助
						IF NOT EXISTS (
							SELECT 1 FROM SS_SSRYK a(NOLOCK)inner join SS_SSDJK b(NOLOCK)on a.ssxh=b.xh  
								inner join  BQ_LSYZK c(nolock) on c.xh=b.yzxh and c.yzzt=0 and c.yzlb=2 
							WHERE a.rylb=3
								and exists(select 1 from #yjm_bq_lsyzk wls where c.syxh=wls.syxh and wls.xh=c.xh)
							)
						BEGIN ----if LLLLLL_aaaaa_111_iiii3 start
							insert into SS_SSRYK(ssxh,rylb,rydm,ryxm,memo,isjb)
							select e.xh,3,c.ssezysdm,d.name,null,0
							from ZY_BRSYK a (nolock)
								inner join BQ_LSYZK c(nolock) on a.syxh=c.syxh and c.yzzt=0 and c.yzlb=2 and isnull(c.ssezysdm,'') != ''
								inner join #yjm_bq_lsyzk wls on c.syxh=wls.syxh and wls.xh=c.xh
								inner join SS_SSDJK e(nolock) on c.xh=e.yzxh
								left join YY_ZGBMK d(nolock) on c.ssezysdm = d.id
							if @@error<>0
							begin
								rollback tran
								select "F","核对手术医嘱出错！"
								return
							end
						END ----if LLLLLL_aaaaa_111_iiii3 end

						--生成手术三助
						IF NOT EXISTS (
							SELECT 1 FROM SS_SSRYK a(NOLOCK)inner join SS_SSDJK b(NOLOCK)on a.ssxh=b.xh 
								inner join  BQ_LSYZK c(nolock) on c.xh=b.yzxh and c.yzzt=0 and c.yzlb=2 
							WHERE a.rylb=4 
								and exists(select 1 from #yjm_bq_lsyzk wls where c.syxh=wls.syxh and wls.xh=c.xh) 
							)
						BEGIN ----if LLLLLL_aaaaa_111_iiii4 start
							insert into SS_SSRYK(ssxh,rylb,rydm,ryxm,memo,isjb)
							select e.xh,4,c.ssszysdm,d.name,null,0
							from ZY_BRSYK a (nolock)
								inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh and c.yzzt=0 and c.yzlb=2 and isnull(c.ssszysdm,'') != ''
								inner join #yjm_bq_lsyzk wls on c.syxh=wls.syxh and wls.xh=c.xh
								inner join SS_SSDJK e(nolock) on c.xh=e.yzxh
								left join YY_ZGBMK d(nolock) on c.ssszysdm=d.id
							if @@error<>0
							begin
								rollback tran
								select "F","核对手术医嘱出错！"
								return
							end
                 		END ----if LLLLLL_aaaaa_111_iiii4 end

						--术前诊断
						insert into SS_SSZDK(ssxh,zdlb,zdlx,zddm,zdmc,memo)
						select e.xh,0,0,e.sqzd,isnull(d.name,''),null
						from ZY_BRSYK a (nolock)
							inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh and c.yzzt=0 and c.yzlb=2
							inner join #yjm_bq_lsyzk wls on c.syxh=wls.syxh and wls.xh=c.xh
							inner join SS_SSDJK e(nolock) on c.xh =e.yzxh and isnull(e.sqzd,'') != ''
							left join YY_ZDDMK d(nolock) on e.sqzd = d.id 
						if @@error<>0
						begin
							rollback tran
							select "F","核对手术医嘱出错！"
							return
						end
						
						if exists(select 1 from sysobjects where name='V5_SSYZK')
						begin
							--辅助诊断一
							insert into SS_SSZDK(ssxh,zdlb,zdlx,zddm,zdmc,memo)
							select e.xh,0,1,d.SQZD1,isnull(d.SQZDMC1,''),null
							from ZY_BRSYK a (nolock)
								inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh and c.yzzt=0 and c.yzlb=2
								inner join #yjm_bq_lsyzk wls on c.syxh=wls.syxh and wls.xh=c.xh
								inner join SS_SSDJK e(nolock) on c.xh =e.yzxh 
								inner join V5_SSYZK d(nolock) on c.v5xh = d.YZXH and isnull(d.SQZD1,'') != '' 
							where not exists (select 1 from SS_SSZDK(nolock) where ssxh = e.xh and zdlb = 0 and zdlx = 1)
							if @@error<>0
							begin
								rollback tran
								select "F","核对手术医嘱出错！"
								return
							end
							--辅助诊断二
							insert into SS_SSZDK(ssxh,zdlb,zdlx,zddm,zdmc,memo)
							select e.xh,0,2,d.SQZD2,isnull(d.SQZDMC2,''),null
							from ZY_BRSYK a (nolock)
								inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh and c.yzzt=0 and c.yzlb=2
								inner join #yjm_bq_lsyzk wls on c.syxh=wls.syxh and wls.xh=c.xh
								inner join SS_SSDJK e(nolock) on c.xh =e.yzxh 
								inner join V5_SSYZK d(nolock) on c.v5xh = d.YZXH and isnull(d.SQZD2,'') != ''
							where not exists (select 1 from SS_SSZDK(nolock) where ssxh = e.xh and zdlb = 0 and zdlx = 2)
							if @@error<>0
							begin
								rollback tran
								select "F","核对手术医嘱出错！"
								return
							end
							--辅助诊断三
							insert into SS_SSZDK(ssxh,zdlb,zdlx,zddm,zdmc,memo)
							select e.xh,0,3,d.SQZD3,isnull(d.SQZDMC3,''),null
							from ZY_BRSYK a (nolock)
								inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh and c.yzzt=0 and c.yzlb=2
								inner join #yjm_bq_lsyzk wls on c.syxh=wls.syxh and wls.xh=c.xh
								inner join SS_SSDJK e(nolock) on c.xh =e.yzxh 
								inner join V5_SSYZK d(nolock) on c.v5xh = d.YZXH and isnull(d.SQZD3,'') != ''
							where not exists (select 1 from SS_SSZDK(nolock) where ssxh = e.xh and zdlb = 0 and zdlx = 3)
							if @@error<>0
							begin
								rollback tran
								select "F","核对手术医嘱出错！"
								return
							end
						end
					end  ----△△△参数6036 是否使用手术管理系统 为是 且 参数6501，是否使用围手术抗生素控制功能 为否 end
				end  ----△△参数G090 手术通知单是否审批 为 否  或者 KS20参数>0 使用抗菌素药品管理系统2.0 end
				else
				begin ----△△参数G090 手术通知单是否审批 为 是  或者 KS20参数=0 不使用抗菌素药品管理系统2.0 start
					if (@sfxyzlc=1)
					begin
						update SS_SSDJK set jlzt=0
						from SS_SSDJK ss inner join #yjm_bq_lsyzk wls on ss.syxh=wls.syxh and ss.yzxh=wls.xh
							inner join BQ_LSYZK c(nolock)on c.xh=wls.xh and c.yzzt=0 and c.yzlb=2 and isnull(c.ssyzzt,0)=2  
						if @@error<>0
						begin
							rollback tran
							select "F","核对手术医嘱出错！"
							return
						end
					end
				end ----△△参数G090 手术通知单是否审批 为 是  或者 KS20参数=0 不使用抗菌素药品管理系统2.0 end
			end ----△if LLLLLL end
			--yzlb=2 手术医嘱处理 end
			
			if @issh='否' --△参数6293 医嘱核对时，阳性药品是否能核对 为 否 start  【且有阳性药品】
				and exists(select 1 from BQ_LSYZK a(nolock)inner join #yjm_bq_lsyzk wls on a.syxh=wls.syxh and wls.xh=a.xh
						inner join BQ_BRGMJLK b (nolock)on a.syxh=b.syxh and a.gg_idm=b.gg_idm and b.gmlx in (1,6,7) and b.jlzt=0
					where a.yzzt=0 
					)
			begin
				set @shnr = '该病人医嘱存在阳性的过敏药品，造成相应医嘱没有核对通过！'

				delete wls 
				from BQ_LSYZK a(nolock)inner join #yjm_bq_lsyzk wls on a.syxh=wls.syxh and wls.xh=a.xh
					inner join BQ_BRGMJLK b (nolock)on a.syxh=b.syxh and a.gg_idm=b.gg_idm and b.gmlx in (1,6,7) and b.jlzt=0
				where a.yzzt=0
			end --△参数6293 医嘱核对时，阳性药品是否能核对 为 否 end

			if @config6480<>'是' --△△参数6480 是否使用医生(EMR医嘱核对)与护士分开核对的机制 为 否 start
			begin
				if @config0251='是'
				begin
					insert into #yshyz 
					select distinct a.xh,0,1
					from BQ_LSYZK a(nolock)inner join #yjm_bq_lsyzk wls on a.syxh=wls.syxh and wls.xh=a.xh
					where a.yzzt=0 
						and ( (@sfxyzlc=0) or (a.yzlb<>2) or (isnull(a.ssyzzt,0)=2 ) )
				end
				update BQ_LSYZK set shrq=@now,
					shczyh=@czyh,
					yzzt=1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end
					,gxrq=@now
				from BQ_LSYZK a inner join #yjm_bq_lsyzk wls on a.syxh=wls.syxh and wls.xh=a.xh
				where a.yzzt=0 
					and ( (@sfxyzlc=0) or (a.yzlb<>2) or (isnull(a.ssyzzt,0)=2 ) )
			end --△△参数6480 是否使用医生(EMR医嘱核对)与护士分开核对的机制 为 否 end
			else
			begin --△△参数6480 是否使用医生(EMR医嘱核对)与护士分开核对的机制 为 是 start
				if @emrsybz = 0 --- if @emrsybz = 0 start
				begin
					if @config0251='是'
					begin
						insert into #yshyz 
						select distinct a.xh,0,1
						from BQ_LSYZK a(nolock) inner join #yjm_bq_lsyzk wls on a.syxh=wls.syxh and wls.xh=a.xh
						where a.yzzt=0 and isnull(a.yshdbz,0)=1
							and ( (@sfxyzlc=0) or (a.yzlb<>2) or (isnull(a.ssyzzt,0)=2 ) )
					end
					update BQ_LSYZK set shrq=@now,
					shczyh=@czyh,
					yzzt=1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end 
					,gxrq=@now
					from BQ_LSYZK a  inner join #yjm_bq_lsyzk wls on a.syxh=wls.syxh and wls.xh=a.xh
					where a.yzzt=0 and isnull(a.yshdbz,0)=1
						and ( (@sfxyzlc=0) or (a.yzlb<>2) or (isnull(a.ssyzzt,0)=2 ) )
				end  --- if @emrsybz = 0 end 
				else if @emrsybz = 1   --- if @emrsybz = 1 start
				begin
					update BQ_LSYZK set yshdbz = 1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end 
						,gxrq=@now
					from BQ_LSYZK a inner join #yjm_bq_lsyzk wls on a.syxh=wls.syxh and wls.xh=a.xh
					where a.yzzt=0 and isnull(a.yshdbz,0)=0
				end  --- if @emrsybz = 1 end
			end --△△参数6480 是否使用医生(EMR医嘱核对)与护士分开核对的机制 为 是 end	
	  		if @@error<>0
			begin
				rollback tran
				select "F","核对临时医嘱出错！"
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
				select (select NEWID()),1,(select patid from ZY_BRSYK(nolock) where syxh = a.syxh),a.syxh,2,a.xh,fzxh,
					null,ysdm,SUBSTRING(ksrq,1,8) + ' ' + SUBSTRING(ksrq,9,8), SUBSTRING(shrq,1,8) + ' ' + SUBSTRING(shrq,9,8),
					SUBSTRING(zxrq,1,8) + ' ' + SUBSTRING(zxrq,9,8),SUBSTRING(tzrq,1,8) + ' ' + SUBSTRING(tzrq,9,8),
					pcdm,(select zxcs from ZY_YZPCK(nolock) where id = a.pcdm),(select zxzq from ZY_YZPCK(nolock) where id = a.pcdm),
					(select zxzqdw from ZY_YZPCK(nolock) where id = a.pcdm),(select zbz from ZY_YZPCK(nolock) where id = a.pcdm),
					psbz,yzlb,1,ypdm,ypmc,ypgg,ypjl,jldw,ypsl,zxdw,ztnr,yznr,ypyf,memo,case zbybz when 1 then 1 else 0 end,zxksdm,
					GETDATE(),null,1
				from BQ_LSYZK a(nolock) inner join #yjm_bq_lsyzk wls on a.syxh=wls.syxh and wls.xh=a.xh
				where a.yzlb in (0,1,3,4,5,8,12)
				if @@error<>0
				begin
					rollback tran
					select "F","写入平台中间表JK_ZY_ZYYZ出错！"
					return
				end
			end
	/*****************************************************************************************************/	  
			select @shyzcount = @shyzcount + @@rowcount
		end --▲▲核对全部或核对临时 @yzbz 医嘱类别(0:临时, -1:全部) end

		--if (@yzbz = 1) or (@yzbz = -1) --▲▲核对长期或全部 @yzbz 医嘱类别(1:长期, -1:全部) start
		begin
			if @issh='否'  --△参数6293 医嘱核对时，阳性药品是否能核对 为 否 start	【且有阳性药品】
				and exists(select 1 from BQ_CQYZK a(nolock) inner join #yjm_bq_cqyzk wcq on a.syxh=wcq.syxh and wcq.xh=a.xh
						inner join BQ_BRGMJLK b (nolock)on a.syxh=b.syxh and a.gg_idm=b.gg_idm and b.gmlx in (1,6,7) and b.jlzt=0
					where a.yzzt=0 
					)
			begin
				set @shnr = '该病人医嘱存在阳性的过敏药品，造成相应医嘱没有核对通过！'
				
				delete wcq 
				from BQ_CQYZK a(nolock) inner join #yjm_bq_cqyzk wcq on a.syxh=wcq.syxh and wcq.xh=a.xh
					inner join BQ_BRGMJLK b (nolock)on a.syxh=b.syxh and a.gg_idm=b.gg_idm and b.gmlx in (1,6,7) and b.jlzt=0
				where a.yzzt=0 
			end  --△参数6293 医嘱核对时，阳性药品是否能核对 为 否 end
			
			if @config6480<>'是' --△△参数6480 是否使用医生(EMR医嘱核对)与护士分开核对的机制 为 否 start
			begin
				if @config0251='是'
				begin
					insert into #yshyz
					select distinct a.xh,1,1
					from BQ_CQYZK a(nolock) inner join #yjm_bq_cqyzk wcq on a.syxh=wcq.syxh and wcq.xh=a.xh 
					where a.yzzt=0 
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
				from BQ_CQYZK a inner join #yjm_bq_cqyzk wcq on a.syxh=wcq.syxh and wcq.xh=a.xh 
				where a.yzzt=0 
			end --△△参数6480 是否使用医生(EMR医嘱核对)与护士分开核对的机制 为 否 end
			else
			begin --△△参数6480 是否使用医生(EMR医嘱核对)与护士分开核对的机制 为 是 start
				if @emrsybz = 0  --- if @emrsybz = 0 start
				begin
					if @config0251='是'
					begin
						insert into #yshyz
						select distinct a.xh,1,1
						from BQ_CQYZK a(nolock) inner join #yjm_bq_cqyzk wcq on a.syxh=wcq.syxh and wcq.xh=a.xh 
						where a.yzzt=0 and isnull(a.yshdbz,0)=1
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
					from BQ_CQYZK a inner join #yjm_bq_cqyzk wcq on a.syxh=wcq.syxh and wcq.xh=a.xh
					where a.yzzt=0 and isnull(a.yshdbz,0)=1
				end  --- if @emrsybz = 0 end
				else if @emrsybz = 1   --- if @emrsybz = 1 start
				begin
					update BQ_CQYZK set yshdbz = 1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end 
					,gxrq=@now
					from BQ_CQYZK a inner join #yjm_bq_cqyzk wcq on a.syxh=wcq.syxh and wcq.xh=a.xh
					where a.yzzt=0 and isnull(a.yshdbz,0)=0
				end --- if @emrsybz = 1 end
			end --△△参数6480 是否使用医生(EMR医嘱核对)与护士分开核对的机制 为 是 end
			if @@error<>0
			begin
				rollback tran
				select "F","核对长期医嘱出错！"
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
				select (select NEWID()),1,(select patid from ZY_BRSYK(nolock) where syxh = a.syxh),a.syxh,1,a.xh,fzxh,
					null,ysdm,SUBSTRING(ksrq,1,8) + ' ' + SUBSTRING(ksrq,9,8), SUBSTRING(shrq,1,8) + ' ' + SUBSTRING(shrq,9,8),
					SUBSTRING(zxrq,1,8) + ' ' + SUBSTRING(zxrq,9,8),SUBSTRING(tzrq,1,8) + ' ' + SUBSTRING(tzrq,9,8),
					pcdm,(select zxcs from ZY_YZPCK(nolock) where id = a.pcdm),(select zxzq from ZY_YZPCK(nolock) where id = a.pcdm),
					(select zxzqdw from ZY_YZPCK(nolock) where id = a.pcdm),(select zbz from ZY_YZPCK(nolock) where id = a.pcdm),
					0,yzlb,1,ypdm,ypmc,ypgg,ypjl,jldw,ypsl,zxdw,ztnr,yznr,ypyf,memo,case zbybz when 1 then 1 else 0 end,zxksdm,
					GETDATE(),null,1
				from BQ_CQYZK a(nolock)inner join #yjm_bq_cqyzk wcq on a.syxh=wcq.syxh and wcq.xh=a.xh 
				where a.yzlb in (0,1,3,4,5,8,14,15) 
				if @@error<>0
				begin
					rollback tran
					select "F","写入平台中间表JK_ZY_ZYYZ出错！"
					return
				end
			end     
	/*****************************************************************************************************/		  
			select @shyzcount =@shyzcount + @@rowcount
		end --▲▲核对长期或全部 @yzbz 医嘱类别(1:长期, -1:全部) end
	         
			--▲▲停止医嘱 开始
		if exists(select 1 from BQ_LSYZK a(nolock)inner join #yjm_bq_lsyzk wls on a.syxh=wls.syxh and wls.xh=a.xh
			where a.yzzt=1 and a.yzlb=9
			)
		begin -- if TTTTTTTT1  start 
			declare cs_tzyz cursor for 
				select distinct a.syxh,a.yexh,b.fzxh, a.tzrq, a.lrczyh,b.yzlb,a.ypmc --谁停止医嘱，医嘱停止者显示谁,不再显示停止医嘱的核对者
				from BQ_LSYZK a(nolock)inner join #yjm_bq_lsyzk wls on a.syxh=wls.syxh and wls.xh=a.xh
					inner join BQ_CQYZK b(nolock)on b.xh=a.tzxh
				where a.yzzt=1 and a.yzlb=9 
				order by a.syxh
			for read only
			open cs_tzyz
			fetch cs_tzyz into @cs_syxh,@cs_yexh,@tzxh,@tzrq,@ysdm,@yzlb,@yznr
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
					select @ysdm = a.lrczyh 
					from BQ_CQYZK a(nolock) 
					where a.syxh=@cs_syxh and a.fzxh > @tzxh and a.yzzt = 2 and a.yzlb = 14 
						
					if exists(select 1 from BQ_CQYZK a(nolock) 
						where a.syxh=@cs_syxh and a.fzxh > @tzxh and a.yzzt = 2 and a.yzlb = 14 and ltrim(rtrim(a.shczyh)) = "" 
						)
					begin
						update BQ_CQYZK set shczyh = @czyh 
						from BQ_CQYZK a 
						where a.syxh=@cs_syxh and a.fzxh > @tzxh and a.yzzt = 2 and a.yzlb = 14 
						if @@ERROR <> 0
						begin
							rollback tran
							deallocate cs_ 
							select "F","更新术后医嘱状态出错"
							return
						end
					end
				end 
				-- add by hhy end
				exec usp_bq_tzyz @cs_syxh,@czyh,@tzrq,@ysdm,@tzyy,@errmsg output,1,@tzxh, 0, @cs_yexh
				if @errmsg like "F%"
				begin
					rollback tran
					deallocate cs_tzyz
					select "F",substring(@errmsg,2,49)
					return
				end
				if (@yzlb IN(14,15)) and (@configG435='否')  --zzk
				begin  
					if exists(select 1 from BQ_CQYZK a(nolock) where a.syxh=@cs_syxh and a.fzxh=@tzxh and a.yzzt<3) 
					begin 
						if @config0251='是'--医嘱闭环状态更新
						begin
							insert into #yshyz 
							select distinct xh,1,4
							from BQ_CQYZK a(nolock)
							where a.syxh=@cs_syxh and a.fzxh=@tzxh and a.yzzt<3 
						end  
						update BQ_CQYZK set yzzt=4 
						from BQ_CQYZK a 
						where a.syxh=@cs_syxh and a.fzxh=@tzxh and a.yzzt<3 
					end 
				end 
				fetch cs_tzyz into @cs_syxh,@cs_yexh,@tzxh,@tzrq,@ysdm,@yzlb,@yznr
			end ---游标 cs_tzyz while end
			close cs_tzyz
			deallocate cs_tzyz
			
			if @config0251='是'--医嘱闭环状态更新
			begin
				insert into #yshyz 
				select distinct a.xh,0,2
				from BQ_LSYZK a(nolock) inner join #yjm_bq_lsyzk wls on a.syxh=wls.syxh and wls.xh=a.xh
				where a.yzzt=1 and a.yzlb=9
			end  
			update BQ_LSYZK set zxrq=@now,
				zxczyh=@czyh,
				yzzt=2,
				@jajbz=case when (isnull(a.jajbz,0)=1 or @jajbz=1) then 1 else 0 end 
				,gxrq=@now
			from BQ_LSYZK a inner join #yjm_bq_lsyzk wls on a.syxh=wls.syxh and wls.xh=a.xh
			where a.yzzt=1 and a.yzlb=9
			if @@error<>0
			begin
				rollback tran
				select "F","核对停止医嘱出错！"
				return
			end
		end -- if TTTTTTTT1  end
		--▲▲停止医嘱 结束
	end  ---=======================▲核对类别 0=全部医嘱  end=====================================
	
	--add by kongwei 2017-10-09 需求195482  无锡锡山人民医院--1704病区管理
	if (@config6C54 <> '')
	begin
		declare @hs_yzxh ut_xh12,@hs_zxsj varchar(5),@hs_zxrq ut_rq16,@hs_ypjl ut_sl10,@errmsg_hszxyz varchar(200)
	    
		exec usp_bq_hszxyz @wkdz,1,@czyh,0,'','',@delphi=0,@errmsg=@errmsg_hszxyz
		declare cs_hszxyz cursor FOR 
			select a.xh,substring(a.shrq,9,5) zxsj,a.shrq,a.ypjl 
			from BQ_LSYZK a(nolock) inner join #yjm_bq_lsyzk wls on a.syxh=wls.syxh and wls.xh=a.xh
			where a.yzzt = 1 and a.shczyh = @czyh and a.shrq = @now 
				and charindex('"'+convert(varchar,a.yzlb)+'"',@config6C54) > 0
		open cs_hszxyz
		fetch cs_hszxyz into @hs_yzxh,@hs_zxsj,@hs_zxrq,@hs_ypjl
		while @@fetch_status=0
		BEGIN
			update BQ_LSYZK set zxczyh_hs=@czyh,zxrq_hs=shrq
			where xh = @hs_yzxh and yzzt = 1

			exec usp_bq_hszxyz @wkdz,2,@czyh,@hs_yzxh,'',@hs_zxsj,@hs_zxrq,@sjjl=@hs_ypjl,@zxks=@dlksdm,@delphi=0,@errmsg=@errmsg_hszxyz

			fetch cs_hszxyz into @hs_yzxh,@hs_zxsj,@hs_zxrq,@hs_ypjl
		end
		close cs_hszxyz
		deallocate cs_hszxyz
		exec usp_bq_hszxyz @wkdz,3,@czyh,0,'','',@yzbz=0,@delphi=0,@errmsg=@errmsg_hszxyz
	end	

	--swx 2015-10-14 for 需求47224 仙居县人民医院---病区护士站医嘱执行
	--医生站发送的医嘱不同步lyljfs，6538=否医嘱录入不提示时
	if (@config6949='是')and(@config6538='否')
	begin
		update BQ_CQYZK set lyljfs=1
		from BQ_CQYZK a inner join #yjm_bq_cqyzk wcq on a.syxh=wcq.syxh and wcq.xh=a.xh
		where a.yzzt=1 and shrq=@now and shczyh=@czyh			--当前操作员当前核对的医嘱
			and exists(SELECT lj.idm FROM BQ_LJLYMX lj(nolock) WHERE lj.jlzt=0 and lj.syxh=a.syxh and lj.idm=a.idm)	--药品存在有效累计记录
	end

	---------医嘱闭环开始-------------------------------------------------------------------------         
	declare cs_yzsh_bh_ls cursor for		--第二步
		select distinct b.syxh,a.yzxh,case isnull(@dlksdm,'') when '' then b.ksdm else @dlksdm end
			,b.bqdm,b.shczyh,a.yzzt  
		from BQ_LSYZK b (nolock) inner join  #yshyz a(nolock) on a.yzxh=b.xh and a.cqlsbz=0 
		where b.yzlb<>9 
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
		select distinct b.syxh,a.yzxh,case isnull(@dlksdm,'') when '' then b.ksdm else @dlksdm end,
			b.bqdm,b.shczyh,a.yzzt  
		from BQ_CQYZK b (nolock) inner join  #yshyz a(nolock) on a.yzxh=b.xh and a.cqlsbz=1 
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
		else if @yzzt=4  --停止核对
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
	
	if @config6800='1' --更新危重标志医嘱处理,危重医嘱只能做为临时医嘱下达--老流程 2014-03-06 caoshuang 增加6800为2的情况，根据yzlb判断
	begin
		update ZY_BRSYK set wzjb=1 
		from ZY_BRSYK br
		where exists (
			select 1 from BQ_LSYZK a(nolock)inner join #yjm_bq_lsyzk wls on a.syxh=wls.syxh and wls.xh=a.xh
			where a.yzzt=1 and a.idm=0 AND LTRIM(RTRIM(a.ypdm))<>'' AND  (a.ypdm=@configG107 or a.ypdm=@configG108)
				and a.syxh=br.syxh
			)
		if @@error<>0 --or @@rowcount=0
		begin
			rollback tran
			select "F","核对医嘱更新当前患者危重标志出错！"
			return
		end 
	end
	if @config6800='2'--按照yzlb来更新 wzjb  2014-03-06 caoshuang add  for 193728 
	begin
		select syxh,yzlb into #yzlb_6800 from BQ_LSYZK(nolock) where 1=2 --创建该病人yzlb临时表
	  
		insert into #yzlb_6800	--插入临嘱的所有yzlb
		select a.syxh,a.yzlb 
		from BQ_LSYZK a(nolock)inner join #yjm_bq_lsyzk wls on a.syxh=wls.syxh and wls.xh=a.xh
		where a.yzzt in(1,2) 
		group by a.syxh,a.yzlb

		insert into #yzlb_6800	--插入长嘱的所有yzlb
		select a.syxh,a.yzlb 
		from BQ_CQYZK a(nolock)inner join #yjm_bq_cqyzk wcq on a.syxh=wcq.syxh and wcq.xh=a.xh
		where a.yzzt in(1,2) 
			and not exists(select 1 from BQ_LSYZK b(nolock) where b.syxh=a.syxh and b.tzxh=a.xh and b.yzzt=2 and b.yzlb=9 ) --排除有停止医嘱申请的长期医嘱
		group by a.syxh,a.yzlb 

		update ZY_BRSYK set wzjb=2 
		from ZY_BRSYK br inner join #yzsh yz on br.syxh=yz.syxh
		where exists(select 1 from #yzlb_6800 a where a.syxh=br.syxh and yzlb=16) --只有16的情况
			and not exists(select 1 from #yzlb_6800 b where b.syxh=br.syxh and yzlb=17)
		if @@error<>0 --or @@rowcount=0
		begin
			rollback tran
			select "F","核对医嘱更新当前患者危重标志出错！"
			return
		end  
		
		update ZY_BRSYK set wzjb=3 
		from ZY_BRSYK br inner join #yzsh yz on br.syxh=yz.syxh
		where exists(select 1 from #yzlb_6800 a where a.syxh=br.syxh and yzlb=17) --只有17的情况
			and not exists(select 1 from #yzlb_6800 b where b.syxh=br.syxh and yzlb=16)
		if @@error<>0 --or @@rowcount=0
		begin
			rollback tran
			select "F","核对医嘱更新当前患者危重标志出错！"
			return
		end 
		
		update ZY_BRSYK set wzjb=1
		from ZY_BRSYK br inner join #yzsh yz on br.syxh=yz.syxh
		where exists(select 1 from #yzlb_6800 a where a.syxh=br.syxh and yzlb=17) --17 16共存的情况
			and exists(select 1 from #yzlb_6800 b where b.syxh=br.syxh and yzlb=16)
		if @@error<>0 --or @@rowcount=0
		begin
			rollback tran
			select "F","核对医嘱更新当前患者危重标志出错！"
			return
		end 
		
		update ZY_BRSYK set wzjb=0
		from ZY_BRSYK br inner join #yzsh yz on br.syxh=yz.syxh
		where not exists(select 1 from #yzlb_6800 a where a.syxh=br.syxh and yzlb=17)--17 16 都没有的情况
			and not exists(select 1 from #yzlb_6800 b where b.syxh=br.syxh and yzlb=16)
		if @@error<>0 --or @@rowcount=0
		begin
			rollback tran
			select "F","核对医嘱更新当前患者危重标志出错！"
			return
		end 
	end

	--更新辅助表已存在的sfqrxx列数据
	INSERT INTO BQ_LSYZK_FZ(syxh,yzxh,sfqrxx,tgbz)
	select distinct h.syxh,h.xh,1,1
	from BQ_LSYZK h(nolock)inner join #yjm_bq_lsyzk wls on h.syxh=wls.syxh and wls.xh=h.xh
	WHERE h.yzzt=1 and h.gxrq=@now
		and not exists(select 1 from BQ_LSYZK_FZ g(nolock) where g.syxh=h.syxh and g.yzxh=h.xh)

	INSERT INTO BQ_CQYZK_FZ(syxh,yzxh,sfqrxx,tgbz)
	select distinct h.syxh,h.xh,1,1
	from BQ_CQYZK h(nolock)inner join #yjm_bq_cqyzk wcq on h.syxh=wcq.syxh and wcq.xh=h.xh
	WHERE h.yzzt=1 and h.gxrq=@now
		and not exists(select 1 from BQ_CQYZK_FZ g(nolock) where g.syxh=h.syxh and g.yzxh=h.xh)

	UPDATE BQ_LSYZK_FZ SET sfqrxx = 1 
	from BQ_LSYZK_FZ g left join BQ_LSYZK h on g.yzxh = h.xh and g.syxh = h.syxh and h.yzzt=1 and h.gxrq=@now
		inner join #yjm_bq_lsyzk wls on h.syxh=wls.syxh and wls.xh=h.xh

	UPDATE BQ_CQYZK_FZ SET sfqrxx = 1 
	from BQ_CQYZK_FZ g left join BQ_CQYZK h on g.yzxh = h.xh and g.syxh = h.syxh and h.yzzt=1 and h.gxrq=@now
		inner join #yjm_bq_cqyzk wcq on h.syxh=wcq.syxh and wcq.xh=h.xh

	if @config6A19 = '4' 
	begin
		UPDATE BQ_LSYZK_FZ SET zxsj1 = case when h.yzlb=7 then convert(varchar(8)
			,dateadd(dd,1,substring(h.ksrq,1,8)+' '+substring(h.ksrq,9,8)),112) + '06:00:00' 
			else (convert(char(8),dateadd(minute,convert(int,@config6A95_ls)
			,substring(h.ksrq,1,8) + ' ' + substring(h.ksrq,9,8)),112) 
			+ convert(char(8),dateadd(minute,convert(int,@config6A95_ls),substring(h.ksrq,1,8) 
			+ ' ' + substring(h.ksrq,9,8)),8))  end
		from BQ_LSYZK_FZ g inner join BQ_LSYZK h on g.yzxh = h.xh and g.syxh = h.syxh and h.yzzt=1 and h.gxrq=@now
			inner join #yjm_bq_lsyzk wls on h.syxh=wls.syxh and wls.xh=h.xh

		UPDATE BQ_CQYZK_FZ SET zxsj1 = convert(char(8),dateadd(minute,convert(int,@config6A95_cq),substring(h.ksrq,1,8) + ' ' + substring(h.ksrq,9,8)),112) 
			+ convert(char(8),dateadd(minute,convert(int,@config6A95_cq),substring(h.ksrq,1,8) + ' ' + substring(h.ksrq,9,8)),8)
		from BQ_CQYZK_FZ g inner join BQ_CQYZK h on g.yzxh = h.xh and g.syxh = h.syxh and h.yzzt=1 and h.gxrq=@now
			inner join #yjm_bq_cqyzk wcq on h.syxh=wcq.syxh and wcq.xh=h.xh
	end
	
	--医嘱变更记录  start
	INSERT INTO BQ_BRYZDYDJ(syxh,yexh,qqlx,yzxh,jlzt,yzlb,bqdm,sqdxh,yzksrq,fzxh,ypmc,tzxh,dybz)
	SELECT a.syxh,isnull(a.yexh,0),0,a.xh,0,a.yzlb,a.bqdm,ISNULL(a.sqdxh,0),a.ksrq,a.fzxh,a.ypmc,isnull(a.tzxh,0),0
	from BQ_LSYZK a(NOLOCK) inner join #yjm_bq_lsyzk wls on a.syxh=wls.syxh and wls.xh=a.xh
	where a.yzzt in (1,2) and substring(a.shrq,1,10) =substring(@now,1,10) 
		AND not EXISTS(SELECT 1 FROM BQ_BRYZDYDJ c(NOLOCK) WHERE a.syxh=c.syxh AND a.yexh=c.yexh AND a.xh=c.yzxh AND c.qqlx=0) 
		AND a.blzbz=0 AND a.yzlb2<>1 --过滤术中医嘱单据
	
	INSERT INTO BQ_BRYZDYDJ(syxh,yexh,qqlx,yzxh,jlzt,yzlb,bqdm,sqdxh,yzksrq,fzxh,ypmc,tzxh,dybz)
	SELECT a.syxh,isnull(a.yexh,0),1,a.xh,0,a.yzlb,a.bqdm,0,a.ksrq,a.fzxh,a.ypmc,0,0
	from BQ_CQYZK a(NOLOCK) inner join #yjm_bq_cqyzk wcq on a.syxh=wcq.syxh and wcq.xh=a.xh
	where a.yzzt =1
		AND not EXISTS(SELECT 1 FROM BQ_BRYZDYDJ c(NOLOCK)WHERE a.syxh=c.syxh AND a.yexh=c.yexh AND a.xh=c.yzxh AND c.qqlx=1)	
	--医嘱变更记录  end
	
	
	commit tran   --=======●●●事务 结束============================

	if @config6A70 <> '0' 
	begin
		--处理医嘱核对批次
		declare @shxh ut_xh9
		if (select isnull((select 1  where @now in (select shrq from BQ_YZSHDYRZ(nolock) where czyh = @czyh)), 0)) = 0
		begin
			insert BQ_YZSHDYRZ(czyh,bqdm,dycs,dysj,scdy,shrq) values (@czyh,'',0,'',0,@now)  
			select @shxh=@@IDENTITY  
		end
		else
		begin
			select top 1 @shxh=shpc from BQ_YZSHDYRZ(nolock) where shrq = @now and czyh = @czyh
		end
		if @config6A70<>'2'    --add by kongwei for 188137  1 全部 2 只显示停止医嘱 
			insert into BQ_YZSHDYRZMX(shpc,yzbz,xh,syxh,yexh)  
			select @shxh,0,a.xh,a.syxh,a.yexh 
			from BQ_CQYZK a(nolock)inner join #yjm_bq_cqyzk wcq on a.syxh=wcq.syxh and wcq.xh=a.xh
			where a.yzzt=1 and a.shczyh=@czyh and a.shrq = @now
			and not exists (select 1 from BQ_YZSHDYRZMX b(nolock) where b.syxh=a.syxh and b.yzbz=0 and b.xh=a.xh )

		insert into BQ_YZSHDYRZMX(shpc,yzbz,xh,syxh,yexh)  
		select @shxh,1,a.xh,a.syxh,a.yexh 
		from BQ_LSYZK a(nolock)inner join #yjm_bq_lsyzk wls on a.syxh=wls.syxh and wls.xh=a.xh
		where (a.yzzt=1 or a.yzzt=2) and a.shczyh=@czyh  and a.shrq = @now
		and not exists (select 1 from BQ_YZSHDYRZMX b(nolock) where b.syxh=a.syxh and b.yzbz=1 and b.xh=a.xh )
		and (@config6A70<>'2' or (@config6A70='2' and yzlb = 9))                   --add by kongwei for 188137  1 全部 2 只显示停止医嘱   
		--处理医嘱核对批次结束  

		if not exists(select 1 from BQ_YZSHDYRZMX(nolock) where shpc = @shxh) --add by kongwei 如果没有对应明细则删除记录 不显示 
			delete from BQ_YZSHDYRZ where shpc = @shxh  
	end

	--医嘱核对调用移动条码，后期建议加参数控制  
	if exists(select 1 from YY_CONFIG(nolock) where id='6971' and config='是')
	begin
		-- 当前已核对医嘱，且已插入的不再插入
		insert into BQ_YDTMYZJLK(syxh,fzxh,cqlsbz,ydscbz)  
		select a.syxh,a.fzxh,0,0  
		from BQ_LSYZK a(nolock)inner join #yjm_bq_lsyzk wls on a.syxh=wls.syxh and wls.xh=a.xh
		where a.yzzt=1  
			and not exists (select 1 from BQ_YDTMYZJLK b(nolock) where a.syxh=b.syxh and a.fzxh=b.fzxh and b.cqlsbz=0)  

		insert into BQ_YDTMYZJLK(syxh,fzxh,cqlsbz,ydscbz)  
		select a.syxh,a.fzxh,1,0  
		from BQ_CQYZK a(nolock)inner join #yjm_bq_cqyzk wcq on a.syxh=wcq.syxh and wcq.xh=a.xh
		where a.yzzt=1  
			and not exists (select 1 from BQ_YDTMYZJLK b(nolock) where a.syxh=b.syxh and a.fzxh=b.fzxh and b.cqlsbz=1)    

		declare @ccsyxh varchar(12)
			,@ccfzxh varchar(12)
			,@ccyzbz varchar(1)

		declare cs_ydtm cursor for       
			select a.syxh,a.fzxh,a.cqlsbz 
			from BQ_YDTMYZJLK a(nolock) inner join #yzsh b on a.syxh=b.syxh    
			where isnull(a.ydscbz,0)=0 -- 当前病人移动生成标志为0的，调用移动接口生成条码  
		for read only      
		open cs_ydtm
		fetch cs_ydtm into @cs_syxh,@cs_fzxh,@cs_yzbz      
		while @@fetch_status=0   
		begin      
			select @ccsyxh=convert(varchar(12),@cs_syxh)
				,@ccfzxh=convert(varchar(12),@cs_fzxh)
				,@ccyzbz=convert(varchar(1),@cs_yzbz)
			exec('exec usp_nurse_yzzxjl '+@ccfzxh+','+@ccyzbz) 
			exec('exec usp_bq_CreatePlanAndBarcode 1,'+@ccsyxh+','+@ccfzxh)
			
			fetch cs_ydtm into @cs_syxh,@cs_fzxh,@cs_yzbz  
		end     
		close cs_ydtm      
		deallocate cs_ydtm      
	end
	-- end

	if exists(select 1 from sysobjects where name = 'usp_bq_crtdjdyjl') and 1=2 --打印采用新方式，原来的屏蔽掉
	begin
		declare @yzxh_wsh ut_xh12
			,@cqlsbz int
			
		declare cs_wshyz cursor for 
			select a.xh,0,a.syxh,a.yexh 
			from BQ_LSYZK a(nolock)inner join #yjm_bq_lsyzk wls on a.syxh=wls.syxh and wls.xh=a.xh 
			where a.yzzt in (1,2) and substring(a.shrq,1,10) =substring(@now,1,10) 
			union all
			select a.xh,1,a.syxh,a.yexh  
			from BQ_CQYZK a(nolock) inner join #yjm_bq_cqyzk wcq on a.syxh=wcq.syxh and wcq.xh=a.xh
			where a.yzzt = 1
		for read only
		open cs_wshyz
		fetch cs_wshyz into @yzxh_wsh,@cqlsbz,@cs_syxh,@cs_yexh
		while @@fetch_status=0
		begin 
			exec usp_bq_crtdjdyjl @bz=0			--0 单个医嘱生成  1 批量生产
				,@syxh=@cs_syxh
				,@yexh=@cs_yexh
				,@yzxh=@yzxh_wsh
				,@cqlsbz=@cqlsbz
			fetch cs_wshyz into @yzxh_wsh,@cqlsbz,@cs_syxh,@cs_yexh
		end
		close cs_wshyz
		deallocate cs_wshyz
	end

	if ((((@configG014 ='是') and (@configG106 ='是')) or ((@config6461='是' or @config6481='是') and @emrsybz=1)) and (@jajbz<>-1)) 
	begin --- if HHHH start
		select @fsip=ipdz from YY_USERIP(nolock) where czyh=@czyh
		
		declare cs_brlist cursor for   
			select distinct syxh,yexh from #yzsh  
		for read only  
		open cs_brlist  
		fetch cs_brlist into @cs_syxh,@cs_yexh  
		while @@fetch_status=0  
		begin   
			select @jsbq=bqdm,@brcw=cwdm,@hzxm=hzxm from ZY_BRSYK (nolock) where syxh=@cs_syxh
			select @msg=@brcw+'床患者：'+@hzxm+'有新医嘱已核对！'   --默认值

			if (object_id('tempdb..#msgxxlsb') is not null)
				drop table #msgxxlsb
			select convert(varchar(4000),'') as bz ,convert(varchar(4000),'') as tsxx into #msgxxlsb where 1=2
			
			insert into #msgxxlsb 
			exec('usp_yy_msgmemo 1,' + @cs_syxh + ',' + @cs_yexh) 
			
			select @msg=tsxx from  #msgxxlsb
			if (@emrsybz=1 and @config6481='是')
			begin --- if HHHH_aaaa1 start
				if @configG153='是' 
					select @execmsg='exec usp_yy_autosendmsg 2,"' + ltrim(rtrim(@czyh)) + '","' + @fsip + '","' + @jsbq + '","' + @msg + '",1,'
				else
					select @execmsg='exec usp_yy_autosendmsg 2,"' + ltrim(rtrim(@czyh)) + '","' + @fsip + '","' + @jsbq + '","' + @msg + '",0,'

				select @execmsg=@execmsg+convert(varchar(10),@jajbz)
			end --- if HHHH_aaaa1 end
			else
			begin --- if HHHH_aaaa2 start
				if @configG153='是' 
					exec usp_yy_autosendmsg 2,@czyh,@fsip,@jsbq,@msg,1,@jajbz
				else
					exec usp_yy_autosendmsg 2,@czyh,@fsip,@jsbq,@msg,0,@jajbz
			end --- if HHHH_aaaa2 end
			
			fetch cs_brlist into @cs_syxh,@cs_yexh
		end  
		close cs_brlist  
		deallocate cs_brlist  
	end --- if HHHH end

	if @shnr<>''
		select "F",@shnr,@execmsg 
	else
		select "T",@shnr,@execmsg
	return
end






