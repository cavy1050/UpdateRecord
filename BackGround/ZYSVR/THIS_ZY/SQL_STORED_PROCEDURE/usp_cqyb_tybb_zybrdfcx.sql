IF OBJECT_ID('usp_cqyb_tybb_zybrdfcx','P') IS NOT NULL
DROP PROC usp_cqyb_tybb_zybrdfcx
GO

CREATE PROC usp_cqyb_tybb_zybrdfcx
@ksrq  ut_rq8,
@jsrq  ut_rq8,
@blh   ut_blh,
@jszt  ut_bz,   ---结算状态 0:未结算(查询单个住院病人未结算垫付金额，供医保办调整价目需要）1已结算 (已结算病人垫付金额查询，供医保办上报需要)
@yydm  ut_dm2
AS

/**************************
--add by yangdi 2019.12.26 重庆医保_住院病人垫付查询  按病历号查询 需兼容新老医保接口
--add by yangdi 2020.1.21  增加开始时间，结束时间参数，查询时间段内已结算住院病人垫付金额
exec usp_cqyb_tybb_zybrdfcx '20190018181'
***************************/

SET NOCOUNT ON

--撸一个临时表，把两部分数据都一起插
CREATE TABLE #YB_CQYB_ZYBRDFXX
(
	SYXH  ut_syxh,
	JSXH  ut_xh12,
	BLH   ut_blh,
	HZXM  ut_mc32,
	YPDM  ut_xmdm,
	YPMC  ut_mc64,
	DYDM  ut_xmdm,
	DFJE  ut_money,
	SJLX  ut_bz        --数据类型 0，新接口 1，老接口
)

--查询参数判断
IF @jszt=0
BEGIN
	--撸一把新接口，数据插到中间表
	INSERT INTO #YB_CQYB_ZYBRDFXX (SYXH,JSXH,BLH,HZXM,YPDM,YPMC,DYDM,DFJE,SJLX)
	SELECT a.syxh,a.xh,a.blh,a.hzxm,b.ypdm,b.ypmc,b.dydm,convert(numeric(9,2),c.ybzlje),0
	FROM dbo.ZY_BRJSK a (NOLOCK)
		INNER JOIN dbo.VW_BRFYMXK b (NOLOCK) ON a.syxh=b.syxh AND a.xh=b.jsxh
		INNER JOIN dbo.VW_CQYB_ZYFYMXK c (NOLOCK) ON b.xh=c.cfh
		INNER JOIN dbo.YY_YBFLK d (NOLOCK) ON a.ybdm=d.ybdm
	where d.ybjkid>0
	AND c.idm>0
	AND c.ybzlje<>0
	and c.sfxmdj in (1,2)
	AND a.ybjszt<>2
	AND a.blh=@blh

	--如果新接口没有的话，就查询老接口的数据。
	INSERT INTO #YB_CQYB_ZYBRDFXX (SYXH,JSXH,BLH,HZXM,YPDM,YPMC,DYDM,DFJE,SJLX)
	SELECT a.syxh,a.xh,a.blh,a.hzxm,b.ypdm,b.ypmc,b.dydm,convert(numeric(9,2),c.fop_zfje2),1
	FROM dbo.ZY_BRJSK a (NOLOCK)
		INNER JOIN dbo.VW_BRFYMXK b (NOLOCK) ON a.syxh=b.syxh AND a.xh=b.jsxh
		INNER JOIN dbo.VW_YB_BRFYMXK c (NOLOCK) ON b.xh=c.hismxxh
		INNER JOIN dbo.YY_YBFLK d (NOLOCK) ON a.ybdm=d.ybdm
	where d.ybjkid>0
	AND c.idm>0
	AND convert(numeric(9,2),c.fop_zfje2)<>0
	and c.fop_bzdj in (1,2) 
	AND a.ybjszt<>2
	AND a.blh=@blh
	AND NOT EXISTS 
	(SELECT 1 FROM #YB_CQYB_ZYBRDFXX x (NOLOCK) WHERE a.syxh=x.SYXH AND a.xh=x.JSXH)
END
ELSE
IF @jszt=1
BEGIN
	--新接口
	INSERT INTO #YB_CQYB_ZYBRDFXX (SYXH,JSXH,BLH,HZXM,YPDM,YPMC,DYDM,DFJE,SJLX)
	SELECT a.syxh,a.xh,a.blh,a.hzxm,b.ypdm,b.ypmc,b.dydm,convert(numeric(9,2),c.ybzlje),1
	FROM dbo.ZY_BRJSK a (NOLOCK)
		INNER JOIN dbo.VW_BRFYMXK b (NOLOCK) ON a.syxh=b.syxh AND a.xh=b.jsxh
		INNER JOIN dbo.VW_CQYB_ZYFYMXK c (NOLOCK) ON b.xh=c.cfh
		INNER JOIN dbo.YY_YBFLK d (NOLOCK) ON a.ybdm=d.ybdm
		INNER JOIN dbo.YY_KSBMK e (NOLOCK) ON a.ksdm=e.id
	where  d.ybjkid>0
	AND c.idm>0
	AND c.ybzlje<>0
	and c.sfxmdj in (1,2)
	AND a.ybjszt=2
	AND e.yydm=@yydm
	AND a.jsrq BETWEEN @ksrq AND @jsrq+'24'
	
	--老接口
	INSERT INTO #YB_CQYB_ZYBRDFXX (SYXH,JSXH,BLH,HZXM,YPDM,YPMC,DYDM,DFJE,SJLX)
	SELECT a.syxh,a.xh,a.blh,a.hzxm,b.ypdm,b.ypmc,b.dydm,convert(numeric(9,2),c.fop_zfje2),0
	FROM dbo.ZY_BRJSK a (NOLOCK)
		INNER JOIN dbo.VW_BRFYMXK b (NOLOCK) ON a.syxh=b.syxh AND a.xh=b.jsxh
		INNER JOIN dbo.VW_YB_BRFYMXK c (NOLOCK) ON b.xh=c.hismxxh
		INNER JOIN dbo.YY_YBFLK d (NOLOCK) ON a.ybdm=d.ybdm
		INNER JOIN dbo.YY_KSBMK e (NOLOCK) ON a.ksdm=e.id
	where d.ybjkid>0
	AND c.idm>0
	AND convert(numeric(9,2),c.fop_zfje2)<>0
	and c.fop_bzdj in (1,2) 
	AND a.ybjszt=2
	AND a.jsrq BETWEEN @ksrq AND @jsrq+'24'
	AND e.yydm=@yydm
	AND NOT EXISTS 
	(SELECT 1 FROM #YB_CQYB_ZYBRDFXX x (NOLOCK) WHERE a.syxh=x.SYXH AND a.xh=x.JSXH)
END

SELECT a.SYXH '首页序号',a.JSXH '结算序号',a.BLH '病历号',a.HZXM '姓名',a.YPDM'代码',a.YPMC '名称',a.DYDM '医保对应代码',a.DFJE '垫付金额',a.SJLX '数据类型'
FROM #YB_CQYB_ZYBRDFXX a (NOLOCK)
ORDER BY a.SYXH,a.DFJE DESC

RETURN