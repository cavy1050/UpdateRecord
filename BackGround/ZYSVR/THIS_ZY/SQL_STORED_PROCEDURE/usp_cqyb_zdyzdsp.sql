if exists(select 1 from sysobjects where name='usp_cqyb_zdyzdsp')
  drop proc usp_cqyb_zdyzdsp
GO

CREATE proc usp_cqyb_zdyzdsp
(
	@syxh       VARCHAR(20),                --首页序号
	@spjg       VARCHAR(3),                 --审批结果  1 通过  2 不通过  0取消审批（未审批）,99查询需审批病人,
	                                        --			98 手工新增需审批的病人(即sjly=1)
	                                        --			97 电子病历添加需审批的病人(sjly=1)
	                                        --			96 查询出院病人审批结果
    @spyy       VARCHAR(500),               --审批原因 
    @czyh       VARCHAR(10),                --操作用户
    @ksrq       VARCHAR(30)='',             --开始日期
    @jsrq       VARCHAR(30)='',             --结束日期
	@spbz       VARCHAR(3)='0',             --0全部,1通过,2未通过,3未审批
	@xmzyh      VARCHAR(30)='',             --姓名住院号
	@bqdmlist   VARCHAR(300)='',            --病区代码列表     
	@addtype	ut_bz	= 0,				--spjg=97时有效,0 添加、1：删除
	@kygjz		VARCHAR(1000)=''			--可疑关键字(审核辅助信息)
)
as  

DECLARE @czsj datetime

IF @spjg = '99'  --查询需诊断审批病人
BEGIN
    CREATE TABLE #temp 
	(
	   病历号 varchar(30) null,
	   诊断信息 varchar(200) null,
	   费别     VARCHAR(20) NULL, 
	   患者姓名 varchar(30) null,
	   入院日期 varchar(30) null,
	   科室 varchar(50) null,
	   病区 varchar(50) null,
	   出院日期 varchar(30) null,
	   审核结果 varchar(30) null,
	   审批原因 varchar(500) null,
	   审核人 varchar(30) null,
	   审核日期 datetime null,
	   首页序号 varchar(30) null,
	   住院号 varchar(30) NULL,
	   可疑关键字 VARCHAR(1000) NULL
	)
    INSERT INTO #temp 
	SELECT a.blh "病历号",d.zddm + d.zdmc "诊断信息",h.ybsm "费别",
		   a.hzxm "患者姓名",
		   a.ryrq "入院日期",b.name "科室",g.name "病区",a.cyrq "出院日期",
		   CASE ISNULL(c.spjg,'0') WHEN '1' THEN '通过' WHEN '2' THEN '不通过' ELSE '' end "审核结果",c.spyy "审批原因",
		   f.name "审核人",c.czrq "审核日期",a.syxh "首页序号",a.blh "住院号",c.kygjz "可疑关键字"
    FROM ZY_BRSYK a(NOLOCK) INNER JOIN YY_KSBMK b(NOLOCK) ON a.ksdm = b.id 
							LEFT JOIN YY_CQYB_ZDYZDSPJG c(NOLOCK) ON a.syxh = c.syxh AND ISNULL(c.sjly ,'0') = '0'
							INNER JOIN VW_CQYB_ZYBRRYZD d(NOLOCK) ON a.syxh = d.syxh
							INNER JOIN YY_CQYB_ZDYSPXM e(NOLOCK) ON e.xmdm = d.zddm AND e.xmlb = '2'  
							LEFT JOIN YY_ZGBMK f(NOLOCK) ON c.czyh = f.id
							LEFT JOIN ZY_BQDMK g(NOLOCK) ON a.bqdm = g.id
							LEFT JOIN YY_YBFLK h(NOLOCK) ON a.ybdm = h.ybdm
	WHERE a.brzt NOT IN (3,8,9)
	  and a.ryrq >= @ksrq
	  AND a.ryrq <= @jsrq
	  AND (ISNULL(c.spjg,'3') = @spbz OR '0' = @spbz)
	  AND (a.hzxm LIKE +@xmzyh+'%' OR a.blh = @xmzyh)
	  AND ( charindex(convert(varchar(12),RTRIM(a.bqdm)),@bqdmlist) > 0 OR @bqdmlist = '' )
	
	INSERT INTO #temp
	SELECT a.blh "病历号",d.zddm + d.zdmc "诊断信息",h.ybsm "费别",
		   a.hzxm "患者姓名",
		   a.ryrq "入院日期",b.name "科室",g.name "病区",a.cyrq "出院日期",
		   CASE ISNULL(c.spjg,'0') WHEN '1' THEN '通过' WHEN '2' THEN '不通过' ELSE '' end "审核结果",c.spyy "审批原因",
		   f.name "审核人",c.czrq "审核日期",a.syxh "首页序号",a.blh "住院号",c.kygjz "可疑关键字"
    FROM ZY_BRSYK a(NOLOCK) INNER JOIN YY_KSBMK b(NOLOCK) ON a.ksdm = b.id 
							INNER JOIN YY_CQYB_ZDYZDSPJG c(NOLOCK) ON a.syxh = c.syxh AND ISNULL(c.sjly ,'0') <> '0'
							LEFT JOIN VW_CQYB_ZYBRRYZD d(NOLOCK) ON a.syxh = d.syxh 
							LEFT JOIN YY_ZGBMK f(NOLOCK) ON c.czyh = f.id
							LEFT JOIN ZY_BQDMK g(NOLOCK) ON a.bqdm = g.id
							LEFT JOIN YY_YBFLK h(NOLOCK) ON a.ybdm = h.ybdm
	WHERE a.brzt NOT IN (3,8,9)
	  and a.ryrq >= @ksrq
	  AND a.ryrq <= @jsrq
	  AND (CASE ISNULL(c.spjg,'3') WHEN '0' THEN '3' ELSE c.spjg END = @spbz OR '0' = @spbz)
	  AND (a.hzxm LIKE +@xmzyh+'%' OR a.blh = @xmzyh)
	  AND ( charindex(convert(varchar(12),RTRIM(a.bqdm)),@bqdmlist) > 0 OR @bqdmlist = '' )
	 	  
	SELECT a.病历号,
		CONVERT(VARCHAR(1000),STUFF((select ','+CONVERT(varchar(100), b.诊断信息) FROM #temp b 
		    WHERE b.首页序号=a.首页序号  order by b.诊断信息 for xml path('') ), 1, 1, '')) "诊断信息",a.费别,
		a.患者姓名,a.入院日期,a.科室,a.病区,a.出院日期,a.审核结果,a.审批原因,a.审核人,a.审核日期,a.首页序号,a.住院号,a.可疑关键字
	FROM  #temp a
	GROUP BY a.病历号,患者姓名,a.入院日期,a.科室,a.病区,出院日期,a.审核结果,a.审批原因,a.审核人,a.审核日期,
			 a.首页序号,a.住院号,a.费别,a.可疑关键字
	ORDER BY a.病区,a.科室,a.病历号,a.入院日期
END
ELSE IF @spjg = '98' --手工新增需审批的病人(即sjly=1)
BEGIN
    IF NOT EXISTS(SELECT 1 FROM YY_CQYB_ZDYZDSPJG(NOLOCK) WHERE syxh = @syxh) 
	BEGIN
	    SET @czsj = GETDATE()
		INSERT INTO YY_CQYB_ZDYZDSPJG (syxh,  spjg, spyy, czyh, czrq,sjly,kygjz)
		VALUES  (@syxh, -- syxh - ut_syxh
				 '2', -- spjg - varchar(3)  --默认为不通过
				 '手工加入需审批', -- spyy - varchar(1000)
				 @czyh, -- czyh - varchar(10)
				 @czsj,  -- czrq - datetime
				 '1',
				 @kygjz
				 )
		if @@error <> 0 AND @@ROWCOUNT <> 1 
		begin
			ROLLBACK TRAN
			SELECT 'F','新增诊断审批结果失败！'
			return
		end
	END
	ELSE
    BEGIN
	    SELECT 'F','该病人已添加过！'
		RETURN
    END
    SELECT 'T',''
	RETURN
END
ELSE IF @spjg = '97' --电子病历添加需审批的病人(sjly=1)
BEGIN
	IF @addtype = 0
	BEGIN
		IF NOT EXISTS(SELECT 1 FROM YY_CQYB_ZDYZDSPJG(NOLOCK) WHERE syxh = @syxh) 
		BEGIN
			SET @czsj = GETDATE()
			INSERT INTO YY_CQYB_ZDYZDSPJG (syxh,  spjg, spyy, czyh, czrq,sjly,kygjz)
			VALUES  (@syxh, -- syxh - ut_syxh
					 '0', -- spjg - varchar(3)  --默认为未审核
					 CASE ISNULL(@spyy,'') WHEN '' then '电子病历加入需审批' ELSE @spyy END,
					 @czyh, -- czyh - varchar(10)
					 @czsj,  -- czrq - datetime
					 '1',
					 @kygjz
					 )
			if @@error <> 0 AND @@ROWCOUNT <> 1 
			begin
				ROLLBACK TRAN
				SELECT 'F','新增审批失败！'
				return
			end
		END
		ELSE
		BEGIN
			SELECT 'F','该病人已添加过！'
			RETURN
		END		
	END
	ELSE IF @addtype = 1 
	BEGIN
		IF EXISTS(SELECT 1 FROM YY_CQYB_ZDYZDSPJG(NOLOCK) WHERE syxh = @syxh) 
		BEGIN
			DELETE FROM YY_CQYB_ZDYZDSPJG WHERE syxh = @syxh
			if @@error <> 0 AND @@ROWCOUNT <> 1 
			begin
				ROLLBACK TRAN
				SELECT 'F','删除审批失败！'
				return
			end
		END
	END
	ELSE
	BEGIN
		SELECT 'F','未定义的参数类型！'
		return
	END	
    SELECT 'T',''
	RETURN
END
ELSE IF @spjg = '96'  --查询出院病人审批结果
BEGIN	
    CREATE TABLE #temp1 
	(
	   病历号 varchar(30) null,
	   诊断信息 varchar(200) null,
	   费别     VARCHAR(20) NULL,
	   患者姓名 varchar(30) null,
	   入院日期 varchar(30) null,
	   科室 varchar(50) null,
	   病区 varchar(50) null,
	   出院日期 varchar(30) null,
	   审核结果 varchar(30) null,
	   审批原因 varchar(500) null,
	   审核人 varchar(30) null,
	   审核日期 datetime null,
	   首页序号 varchar(30) null,
	   住院号 varchar(30) null,
	   可疑关键字 VARCHAR(1000) NULL
	)
    INSERT INTO #temp1 
	SELECT a.blh "病历号",d.zddm + d.zdmc "诊断信息",h.ybsm "费别",
		   a.hzxm "患者姓名",
		   a.ryrq "入院日期",b.name "科室",g.name "病区",a.cyrq "出院日期",
		   CASE ISNULL(c.spjg,'0') WHEN '1' THEN '通过' WHEN '2' THEN '不通过' ELSE '' end "审核结果",c.spyy "审批原因",
		   f.name "审核人",c.czrq "审核日期",a.syxh "首页序号",a.blh "住院号",c.kygjz "可疑关键字"
    FROM ZY_BRSYK a(NOLOCK) INNER JOIN YY_KSBMK b(NOLOCK) ON a.ksdm = b.id 
							LEFT JOIN YY_CQYB_ZDYZDSPJG c(NOLOCK) ON a.syxh = c.syxh AND ISNULL(c.sjly ,'0') = '0'
							INNER JOIN VW_CQYB_ZYBRRYZD d(NOLOCK) ON a.syxh = d.syxh
							INNER JOIN YY_CQYB_ZDYSPXM e(NOLOCK) ON e.xmdm = d.zddm AND e.xmlb = '2'  
							LEFT JOIN YY_ZGBMK f(NOLOCK) ON c.czyh = f.id
							LEFT JOIN ZY_BQDMK g(NOLOCK) ON a.bqdm = g.id
							LEFT JOIN YY_YBFLK h(NOLOCK) ON a.ybdm = h.ybdm
	WHERE a.brzt IN (3,8,9)
	  and a.ryrq >= @ksrq
	  AND a.ryrq <= @jsrq
	  AND (ISNULL(c.spjg,'3') = @spbz OR '0' = @spbz)
	  AND (a.hzxm LIKE +@xmzyh+'%' OR a.blh = @xmzyh)
	  AND ( charindex(convert(varchar(12),RTRIM(a.bqdm)),@bqdmlist) > 0 OR @bqdmlist = '' )

	INSERT INTO #temp1
	SELECT a.blh "病历号",d.zddm + d.zdmc "诊断信息",h.ybsm "费别",
		   a.hzxm "患者姓名",
		   a.ryrq "入院日期",b.name "科室",g.name "病区",a.cyrq "出院日期",
		   CASE ISNULL(c.spjg,'0') WHEN '1' THEN '通过' WHEN '2' THEN '不通过' ELSE '' end "审核结果",c.spyy "审批原因",
		   f.name "审核人",c.czrq "审核日期",a.syxh "首页序号",a.blh "住院号",c.kygjz "可疑关键字"
    FROM ZY_BRSYK a(NOLOCK) INNER JOIN YY_KSBMK b(NOLOCK) ON a.ksdm = b.id 
							INNER JOIN YY_CQYB_ZDYZDSPJG c(NOLOCK) ON a.syxh = c.syxh AND ISNULL(c.sjly ,'0') <> '0'
							LEFT JOIN VW_CQYB_ZYBRRYZD d(NOLOCK) ON a.syxh = d.syxh 
							LEFT JOIN YY_ZGBMK f(NOLOCK) ON c.czyh = f.id
							LEFT JOIN ZY_BQDMK g(NOLOCK) ON a.bqdm = g.id
							LEFT JOIN YY_YBFLK h(NOLOCK) ON a.ybdm = h.ybdm
	WHERE a.brzt IN (3,8,9)
	  and a.ryrq >= @ksrq
	  AND a.ryrq <= @jsrq
	  AND (CASE ISNULL(c.spjg,'3') WHEN '0' THEN '3' ELSE c.spjg END = @spbz OR '0' = @spbz)
	  AND (a.hzxm LIKE +@xmzyh+'%' OR a.blh = @xmzyh)
	  AND ( charindex(convert(varchar(12),RTRIM(a.bqdm)),@bqdmlist) > 0 OR @bqdmlist = '' )

	SELECT a.病历号,
		CONVERT(VARCHAR(1000),STUFF((select ','+CONVERT(varchar(100), b.诊断信息) FROM #temp1 b 
		    WHERE b.首页序号=a.首页序号  order by b.诊断信息 for xml path('') ), 1, 1, '')) "诊断信息",a.费别,
		a.患者姓名,a.入院日期,a.科室,a.病区,a.出院日期,a.审核结果,a.审批原因,a.审核人,a.审核日期,a.首页序号,a.住院号,a.可疑关键字 
	FROM  #temp1 a
	GROUP BY a.病历号,患者姓名,a.入院日期,a.科室,a.病区,出院日期,a.审核结果,a.审批原因,a.审核人,a.审核日期,
			 a.首页序号,a.住院号,a.费别,a.可疑关键字
	ORDER BY a.病区,a.科室,a.病历号,a.入院日期	
END
ELSE
BEGIN
    SET @czsj = GETDATE()
	IF LTRIM(RTRIM(@syxh)) = ''
	BEGIN
		SELECT 'F','首页序号为空！'
		RETURN		
	END		
    BEGIN TRAN
	IF NOT EXISTS(SELECT 1 FROM YY_CQYB_ZDYZDSPJG(NOLOCK) WHERE syxh = @syxh) 
	BEGIN
		INSERT INTO YY_CQYB_ZDYZDSPJG (syxh,  spjg, spyy, czyh, czrq,sjly,kygjz)
		VALUES  (@syxh, -- syxh - ut_syxh
				 @spjg, -- spjg - varchar(3)
				 @spyy, -- spyy - varchar(1000)
				 @czyh, -- czyh - varchar(10)
				 @czsj,  -- czrq - datetime
				 '0',
				 @kygjz
				 )
		if @@error <> 0 AND @@ROWCOUNT <> 1 
		begin
			ROLLBACK TRAN
			SELECT 'F','新增诊断审批结果失败！'
			return
		END
	END
	ELSE
	BEGIN
		IF @spjg = '0' 
		BEGIN
			DELETE YY_CQYB_ZDYZDSPJG where syxh=@syxh
			if @@error <> 0 AND @@ROWCOUNT <> 1 
			begin
				ROLLBACK TRAN
				SELECT 'F','取消医保项目审批结果失败！'
				return
			end
		END
		ELSE
		BEGIN 
			UPDATE YY_CQYB_ZDYZDSPJG SET spjg = @spjg,spyy=@spyy,czyh=@czyh,czrq=@czsj WHERE syxh = @syxh
			if @@error <> 0 AND @@ROWCOUNT <> 1 
			begin
				ROLLBACK TRAN
				SELECT 'F','修改医保项目审批结果失败！'
				return
			end
		END
	end
    COMMIT TRAN

	SELECT 'T',''
END

RETURN
GO
