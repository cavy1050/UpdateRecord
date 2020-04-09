if exists(select * from sysobjects where name='usp_cqyb_ddqq_yw_saveybfeeinfo')
  drop proc usp_cqyb_ddqq_yw_saveybfeeinfo
go
Create proc usp_cqyb_ddqq_yw_saveybfeeinfo
(
	@syxh			ut_syxh,			--首页序号
	@jsxh			ut_xh12,			--结算序号
	@lb				int = 0,			--0建立临时表1插入数据2取出数据
	@czyh			varchar(20) = '',	--操作员号
	@wkdz			varchar(50) = '',	--网卡地址
	@ZYMZH			varchar(50) = '',	-- 住院门诊号
	@CFH			varchar(20) = '',			--处方号
	@CFJYLSH		varchar(30) = '',	--处方交易流水号
	@KFRQ			varchar(20) = '',	--开方日期
	@YYNM			varchar(30) = '',	--院内码
	@YBLSH			varchar(30) = '',	--医保中心编码
	@XMMC			varchar(50) = '',	--项目名称
	@DJ				numeric(20,4) = 0,	--单价
	@SL				numeric(20,4) = 0,	--数量
	@JE				numeric(20,4) = 0,	--总金额
	@FYDJ			varchar(3) = '3',			--费用等级
	@ZFBL			numeric(20,4) = 0,	--自负比例
	@BZDJ			VARCHAR(20) = '',	--标准单价
	@ZFJE			numeric(20,4) = 0,	--自负金额
	@CBJE			numeric(20,4) = 0,	--超标金额
	@TYBZ			varchar(3) = '0',			--退药标志
	@JSBZ			varchar(3) = '0',			--结算标志
	@JSRQ			varchar(20) = '',	--结算日期
	@JSJYLSH		varchar(30) = '',	--结算交易流水号
	@CSBZ			varchar(3)	= '0'				--传输标志
)
as
/****************************************
[版本号]4.0.0.0.0
[创建时间]2017.03.05
[作者]FerryMan
[版权]Copyright ? 1998-2017卫宁健康科技集团股份有限公司
[描述]保存前置机医保费用明细信息
[功能说明]
	保存前置机医保费用明细信息
[参数说明]
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]
[修改记录]
****************************************/
set nocount on

declare @tablename varchar(32),
		@strsql varchar(8000)

select @tablename = '##cfmx' + @wkdz + @czyh

if @lb = 0 
begin
	exec('if exists(select * from tempdb..sysobjects where name = "'+@tablename+'") drop table '+@tablename)  
	
	exec('create table '+@tablename+' ( 
			XH		ut_xh12 identity not null,		--序号
			ZYMZH	varchar(50)			null,		-- 住院门诊号
			CFH		varchar(20)					null,		--处方号
			CFJYLSH varchar(30)			null,		--处方交易流水号
			KFRQ	varchar(20)			null,		--开方日期
			YYNM	varchar(30)			null,		--院内码
			YBLSH	varchar(30)			null,		--医保中心编码
			XMMC	varchar(50)			null,		--项目名称
			DJ		numeric(20,4)		null,		--单价
			SL		numeric(20,4)		null,		--数量
			JE		numeric(20,4)		null,		--总金额
			FYDJ	varchar(3)					null,		--费用等级
			ZFBL	numeric(20,4)		null,		--自负比例
			BZDJ	varchar(20)			null,		--标准单价
			ZFJE	numeric(20,4)		null,		--自负金额
			CBJE	numeric(20,4)		null,		--超标金额
			TYBZ	varchar(3)					null,		--退药标志
			JSBZ	varchar(3)					null,		--结算标志
			JSRQ	varchar(20)			null,		--结算日期
			JSJYLSH varchar(30)			null,		--结算交易流水号
			CSBZ	varchar(3)					null		--传输标志
		)') 
	if @@error <> 0  
	begin  
		select "F","创建临时表时出错!"  
		return  
	end  
	
	select "T"
	return
end
else if @lb = 1
begin
	exec('insert into '+@tablename+' values("'+@ZYMZH+'","'+@CFH+'","'+@CFJYLSH+'",
		"'+@KFRQ+'","'+@YYNM+'","'+@YBLSH+'","'+@XMMC+'","'+@DJ+'","'+@SL+'","'+@JE+'","'+@FYDJ+'","'+@ZFBL+'",
		"'+@BZDJ+'","'+@ZFJE+'","'+@CBJE+'","'+@TYBZ+'","'+@JSBZ+'","'+@JSRQ+'","'+@JSJYLSH+'","'+@CSBZ+'")')
	if @@error<>0 or @@rowcount = 0 
	begin
		select "F","插入临时表时出错!"
		return
	end

	select "T"
	return
end
else if @lb = 2
begin
	exec('select XH as "序号",YBLSH "医保代码" ,CFJYLSH as "中心流水号",CFH as "处方号",KFRQ as "开方日期",XMMC as "项目名称",JE as "金额" '
	   + 'from '+@tablename)
	return
end
else if @lb = 3
begin
	create table #temp_fymx        
	(        
		mxxh	ut_xh12		not null,			--1 明细序号
		cfh		ut_xh12			null,			--2 处方号
		cfrq    varchar(20)     null,			--3 处方日期
		xmmc	varchar(50)     null,			--4 医院收费项目名称
		xmgg    varchar(20)     null,			--5 规格	
		xmdj    ut_money		null,			--6 单价	
		xmsl	ut_sl10			null,			--7 数量
		xmdw    varchar(20)     null,			--8 单位
		xmje    ut_money	    null,			--9 金额
		ybbm	varchar(10)     null,			--10 项目医保流水号
		ybscbz	varchar(10)     null,			--11 医保上传标志
		sfxmdj	varchar(10)     null,			--12 医保项目等级
		spbz	varchar(10)     null,			--13 审批标志
		ybspbz	varchar(10)		null,			--14 医保审批标志
		qzfbz	varchar(10)		null,			--15 全自费标志
		zxlsh	varchar(20)		null			--16 中心流水号
	)

	insert into #temp_fymx(mxxh,cfh,cfrq,xmmc,xmje,ybscbz,zxlsh)
	select b.xh,b.cfh,dbo.fun_convertrq_cqyb(1,b.cfrq),b.xmmc,b.xmje,b.ybscbz,b.zxlsh
	from YY_CQYB_ZYJZJLK a(nolock) 
		inner join YY_CQYB_ZYFYMXK b(nolock) on a.syxh = b.syxh and b.jsxh = @jsxh and ybscbz = 1
	where a.syxh = @syxh and a.jlzt = 1
	
	set @strsql = 'select mxxh as "费用序号",cfh as "处方号",cfrq as "收费日期",xmmc as "药品名称",xmje as "药品金额",'
		        + '(case ybscbz when 1 then "已上传" when 2 then "无需上传" else "未上传" end) as "上传标志",'
		        + 'zxlsh as "中心流水号" from #temp_fymx b where  not EXISTS (select 1 from '+@tablename+' where isnull(b.zxlsh,"") = CFJYLSH)'
	exec(@strsql)
	return
end
else if @lb = 4
begin
	select * into #YY_CQYB_ZYFYMXK from YY_CQYB_ZYFYMXK where syxh = @syxh and jsxh = @jsxh and ybscbz = 1 
	
	set @strsql = 'select XH as "序号",CFJYLSH as "中心流水号",CFH as "处方号",KFRQ as "开方日期",XMMC as "项目名称",JE as "金额" '
	            + 'from '+@tablename+' where  not EXISTS (select 1 from #YY_CQYB_ZYFYMXK where CFJYLSH = zxlsh)'
	exec(@strsql)
	return
end
GO
