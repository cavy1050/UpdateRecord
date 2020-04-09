if exists(select 1 from sysobjects where name = 'usp_cqyb_finally')
  drop proc usp_cqyb_finally
go

Create proc usp_cqyb_finally
(
	@lb     VARCHAR(50),       --操作类别   定义规则  dll名+_+自定义编码
	@input1 VARCHAR(8000),     --信息1 可以是主信息  比如  czyh|syxh|jsxh|sjh||...每个交易自行定义并截取使用
	@input2 VARCHAR(8000)='',  --信息2 在输入串较长时补充input1参数信息 
	@input3 VARCHAR(8000)=''   --信息3 在输入串较长时补充input1参数信息
)
as
/**********************
[版本号]4.0.0.0.0
[创建时间]2019.10.31
[作者]qfj
[版权]Copyright ? 1998-2017卫宁健康科技集团股份有限公司
[描述]
重庆医保的最后增加的存储,之后不再新增存储
[功能说明]
[参数说明]
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]
[修改纪录]
**********************/
set nocount on

DECLARE @seq VARCHAR(1),@seq1 VARCHAR(1)
SELECT @seq = '|' ,@seq1 = '$'

declare	@now ut_rq16,		--当前时间
        @czyh ut_czyh,
		@syxh ut_syxh,
		@jsxh ut_xh12,
		@sjh ut_sjh,
		@CQ64 VARCHAR(14),
		@cyzd VARCHAR(30),
		@cyzdmc VARCHAR(150),
		@ybjkid varchar(3)

select @ybjkid = config from YY_CONFIG where id = 'CQ18'		
select @now=convert(char(8),getdate(),112)+convert(char(8),getdate(),8)

IF @lb = 'yy_cqybddqq_yw_ybshyydzts' --医保审核时检查医院垫支提示
BEGIN
    DECLARE @dbzdzje NUMERIC(12,2)
	        
	SELECT @CQ64 = a.config FROM YY_CONFIG a(NOLOCK) WHERE a.id = 'CQ64'
	SELECT @CQ64 = ISNULL(@CQ64,'')
    IF @CQ64 = '-1' OR @CQ64 = ''
	BEGIN
	    SELECT 'T',''  --参数没有启用直接返回
		RETURN
	END

	select @jsxh = dbo.fun_cqyb_getvalbyseq(@input1,@seq,1)
	
	IF NOT EXISTS(SELECT 1 from ZY_BRJSJEK a(NOLOCK) WHERE a.lx = 'yb08' AND jsxh = @jsxh)
	BEGIN
       SELECT 'F','没有预算信息'
	   RETURN
	END

	SELECT @dbzdzje = a.je from ZY_BRJSJEK a(NOLOCK) WHERE a.lx = 'yb08' AND jsxh = @jsxh

	IF EXISTS(SELECT 1 FROM YY_CONFIG a(NOLOCK) WHERE a.id = 'CQ01' AND a.config = 'WD')
	BEGIN
        SELECT @dbzdzje = a.je  from ZY_BRJSJEK a(NOLOCK) WHERE a.lx = 'yb23' AND jsxh = @jsxh
	END

	IF @dbzdzje > CONVERT(NUMERIC(12,2),@CQ64) 
	BEGIN
	    SELECT 'R','请注意：该患者医院垫支金额：'+CONVERT(VARCHAR(20),@dbzdzje)+'，已超过限额：'+@CQ64+'，是否继续审核？'
		RETURN
	END

	SELECT 'T',''  --没有操作限额
	RETURN
END
ELSE IF @lb = 'yy_cqybddqq_yw_ybshcyzd' --医保审核时检查出院诊断
BEGIN
    SELECT @CQ64 = a.config FROM YY_CONFIG a(NOLOCK) WHERE a.id = 'CQ64'
	SELECT @CQ64 = ISNULL(@CQ64,'')
    IF @CQ64 = '-1' OR @CQ64 = ''
	BEGIN
	    SELECT 'T',''  --参数没有启用直接返回
		RETURN
	END
    
    select @syxh = dbo.fun_cqyb_getvalbyseq(@input1,@seq,2)

    SELECT @cyzd = a.cyzd ,@cyzdmc = b.name from YY_CQYB_ZYJZJLK a(NOLOCK),YY_CQYB_ZDDMK b(NOLOCK) WHERE a.cyzd = b.id AND a.syxh = @syxh
	IF ISNULL(@cyzd,'') = '' 
	    SELECT 'T','没有填写诊断！'
	ELSE 
        select 'R','已填写诊断：“'+ @cyzd+'”,名称：“' + @cyzdmc + '”；是否继续审核通过？'
	RETURN    
END
ELSE IF @lb = 'yy_cqybdzsmxzhcl' --三目下载后处理
BEGIN
	SELECT 'T',''
	RETURN
    --附一版本
    --DELETE YY_CQYB_ZDDMK WHERE id IN (SELECT code FROM YY_CQYB_GLXX a(NOLOCK) WHERE a.gllb = '1' AND a.jlzt = 0 )
    
END
ELSE IF @lb = 'yy_cqybddqq_yw_saveShz' --保存审核组
BEGIN
    IF dbo.fun_cqyb_getvalbyseq(@input1,@seq,1) NOT IN ('0','')
	BEGIN
	    UPDATE YY_CQYB_YBSHZ 
		SET mc = dbo.fun_cqyb_getvalbyseq(@input1,@seq,2),
		    czyh = dbo.fun_cqyb_getvalbyseq(@input1,@seq,3),
			czrq = GETDATE() 
		WHERE id = dbo.fun_cqyb_getvalbyseq(@input1,@seq,1) 
	END 
    ELSE
    BEGIN
		INSERT INTO YY_CQYB_YBSHZ( mc,jlzt,czyh,czrq) 
		VALUES(dbo.fun_cqyb_getvalbyseq(@input1,@seq,2),0,dbo.fun_cqyb_getvalbyseq(@input1,@seq,3),GETDATE())
    END
    IF @@ERROR <> 0 
	BEGIN
        SELECT 'F','保存审核组失败！'
	    RETURN
	END 
    SELECT 'T',''
	RETURN
END
ELSE IF @lb = 'yy_cqybddqq_yw_deleteShz' --删除审核组
BEGIN
    BEGIN TRAN

    DELETE YY_CQYB_YBSHZBQ WHERE shzid = dbo.fun_cqyb_getvalbyseq(@input1,@seq,1) 
	IF @@ERROR <> 0 
	BEGIN
	    ROLLBACK TRAN
        SELECT 'F','删除审核组病区失败！'
	    RETURN
	END

	DELETE YY_CQYB_YBSHZ WHERE id = dbo.fun_cqyb_getvalbyseq(@input1,@seq,1) 
    IF @@ERROR <> 0 
	BEGIN
	    ROLLBACK TRAN
        SELECT 'F','删除审核组失败！'
	    RETURN
	END
	COMMIT TRAN

	SELECT 'T','成功'
	RETURN 
END
ELSE IF @lb = 'yy_cqybddqq_yw_selectShz' --查询审核组
BEGIN
	select a.id 审核组id,a.mc 审核组名称,a.jlzt 记录状态 ,b.name 操作人,a.czrq 操作日期
	FROM YY_CQYB_YBSHZ a(NOLOCK) LEFT JOIN YY_ZGBMK b(NOLOCK) ON a.czyh = b.id
	
	RETURN 
END
ELSE IF @lb = 'yy_cqybddqq_yw_selectShzbq' --查询审核组病区
BEGIN
	select a.shzid 审核组id,a.bqdm 病区代码,b.name 病区名称,a.jlzt 记录状态 ,c.name 操作人,a.czrq 操作日期
	FROM YY_CQYB_YBSHZBQ a(NOLOCK) INNER JOIN ZY_BQDMK b(NOLOCK) ON a.bqdm = b.id 
								   LEFT JOIN YY_ZGBMK c(NOLOCK) ON a.czyh = c.id
	WHERE  a.shzid = dbo.fun_cqyb_getvalbyseq(@input1,@seq,1)
	
	RETURN 
END
ELSE IF @lb = 'yy_cqybddqq_yw_saveShzbq' --保存审核组
BEGIN
    IF EXISTS(SELECT 1 FROM YY_CQYB_YBSHZBQ(NOLOCK) WHERE bqdm = dbo.fun_cqyb_getvalbyseq(@input1,@seq,2))
	BEGIN
        SELECT 'F','该病区已被分配审核组，无需再分配！'
		RETURN 
	END

	INSERT INTO YY_CQYB_YBSHZBQ(shzid, bqdm,jlzt,czyh,czrq)
	VALUES(dbo.fun_cqyb_getvalbyseq(@input1,@seq,1),dbo.fun_cqyb_getvalbyseq(@input1,@seq,2),0,dbo.fun_cqyb_getvalbyseq(@input1,@seq,3),GETDATE())
    IF @@ERROR <> 0 
	BEGIN
        SELECT 'F','保存审核组失败！'
	    RETURN
	END 
    SELECT 'T',''
	RETURN
END
ELSE IF @lb = 'yy_cqybddqq_yw_deleteShzbq' --删除审核组病区
BEGIN
    BEGIN TRAN

    DELETE YY_CQYB_YBSHZBQ WHERE shzid = dbo.fun_cqyb_getvalbyseq(@input1,@seq,1) AND bqdm = dbo.fun_cqyb_getvalbyseq(@input1,@seq,2)
	IF @@ERROR <> 0 
	BEGIN
	    ROLLBACK TRAN
        SELECT 'F','删除审核组病区失败！'
	    RETURN
	END

	COMMIT TRAN

	SELECT 'T','成功'
	RETURN 
END
ELSE IF @lb = 'yy_cqybddqq_yw_ShzReport' --审核组报表
BEGIN
    create table #shzreport       
	(        
		类别	VARCHAR(64)		not null,			--首页序号
		审核组	VARCHAR(64)		not null,			--结算序号
		人数    NUMERIC(10)			null
	) 
	
	INSERT INTO  #shzreport
	SELECT '出院' 类别, d.mc 医疗组, COUNT(1) 人数
	from ZY_BRSYK a(nolock) inner join ZY_BRJSK b(nolock) on a.syxh = b.syxh and b.jlzt = 0 and b.ybjszt <> 2 AND b.ybjszt <> 5
							inner join YY_CQYB_YBSHZBQ c(NOLOCK) on a.bqdm = c.bqdm AND c.jlzt = 0
							INNER JOIN YY_CQYB_YBSHZ d(NOLOCK) ON c.shzid = d.id AND d.jlzt = 0
	where a.brzt in (2,4) and a.ybdm in (select ybdm from YY_YBFLK(NOLOCK) where xtbz = 1 and ybjkid = @ybjkid) 
	GROUP BY d.mc

	INSERT INTO  #shzreport
	SELECT '临时出院' 类别, d.mc 医疗组, COUNT(1) 人数
	from ZY_BRSYK a(nolock) 
		inner join ZY_BRJSK b(nolock) on a.syxh = b.syxh and b.jlzt = 0 and b.ybjszt <> 2 AND b.ybjszt <> 5
		inner join YY_CQYB_YBSHZBQ c(NOLOCK) on a.bqdm = c.bqdm AND c.jlzt = 0
		INNER JOIN YY_CQYB_YBSHZ d(NOLOCK) ON c.shzid = d.id AND d.jlzt = 0
		inner join VW_CQYB_LSCY e(nolock) on a.syxh = e.syxh
	where a.brzt in (1,5,6,7) and a.ybdm in (select ybdm from YY_YBFLK(NOLOCK) where xtbz = 1 and ybjkid = @ybjkid)
	GROUP BY d.mc

	INSERT INTO  #shzreport
	SELECT '在区已有出院记录' 类别,d.mc 医疗组, COUNT(1) 人数
	from ZY_BRSYK a(nolock) 
		inner join ZY_BRJSK b(nolock) on a.syxh = b.syxh and b.jlzt = 0 and b.ybjszt <> 2 AND b.ybjszt <> 5
		inner join YY_CQYB_YBSHZBQ c(NOLOCK) on a.bqdm = c.bqdm AND c.jlzt = 0
		INNER JOIN YY_CQYB_YBSHZ d(NOLOCK) ON c.shzid = d.id AND d.jlzt = 0
		inner join VW_CQYB_CYJLYJSH e(nolock) on a.syxh = e.syxh
	where a.brzt in (1,5,6,7) and a.ybdm in (select ybdm from YY_YBFLK(NOLOCK) where xtbz = 1 and ybjkid = @ybjkid) 
	GROUP BY d.mc

	--测试
	/* 
	INSERT INTO  #shzreport
	SELECT '临时出院' 类别, d.mc 医疗组, COUNT(1)+2 人数
	from ZY_BRSYK a(nolock) inner join ZY_BRJSK b(nolock) on a.syxh = b.syxh and b.jlzt = 0 and b.ybjszt <> 2 AND b.ybjszt <> 5
							inner join YY_CQYB_YBSHZBQ c(NOLOCK) on a.bqdm = c.bqdm AND c.jlzt = 0
							INNER JOIN YY_CQYB_YBSHZ d(NOLOCK) ON c.shzid = d.id AND d.jlzt = 0
	where a.brzt in (2,4) and a.ybdm in (select ybdm from YY_YBFLK(NOLOCK) where xtbz = 1 and ybjkid = @ybjkid) 
	GROUP BY d.mc
	
	INSERT INTO  #shzreport
	SELECT '在区已有出院记录' 类别, d.mc 医疗组, COUNT(1)+3 人数
	from ZY_BRSYK a(nolock) inner join ZY_BRJSK b(nolock) on a.syxh = b.syxh and b.jlzt = 0 and b.ybjszt <> 2 AND b.ybjszt <> 5
							inner join YY_CQYB_YBSHZBQ c(NOLOCK) on a.bqdm = c.bqdm AND c.jlzt = 0
							INNER JOIN YY_CQYB_YBSHZ d(NOLOCK) ON c.shzid = d.id AND d.jlzt = 0
	where a.brzt in (2,4) and a.ybdm in (select ybdm from YY_YBFLK(NOLOCK) where xtbz = 1 and ybjkid = @ybjkid) 
	GROUP BY d.mc
	*/
	
	SELECT 
			a.审核组, 
			IDENTITY(INT,0,1) X,
			MAX(CASE a.类别 WHEN '出院' THEN a.人数 ELSE 0 END) AS '出院',
			MAX(CASE a.类别 WHEN '临时出院' THEN a.人数 ELSE 0 END) AS '临时出院',
			MAX(CASE a.类别 WHEN '在区已有出院记录' THEN a.人数 ELSE 0 END) AS '在区已有出院记录'
	INTO #result_hz	 
	FROM #shzreport a
	GROUP BY a.审核组

	select a.* from  #result_hz a

    RETURN
END
ELSE IF @lb = 'yy_cqybddqq_cftf' --处方退方
BEGIN
	--此功能谨慎使用,处方退方后,请自行处理HIS本地数据(多用于跨年退费);
	--select	dbo.fun_cqyb_getvalbyseq(@input1,'|',2),		--退掉的处方明细的记录数
	--		dbo.fun_cqyb_getvalbyseq(@input1,'|',3)			--所退总金额

	SELECT 'T','成功'
	RETURN 
END
ELSE
BEGIN
   SELECT 'F','类别错误，请联系管理员！'
   RETURN
END  

GO
