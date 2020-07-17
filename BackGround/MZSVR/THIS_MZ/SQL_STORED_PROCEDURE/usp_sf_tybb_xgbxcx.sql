IF OBJECT_ID('usp_sf_tybb_xgbxcx','P') IS NOT NULL
DROP PROC usp_sf_tybb_xgbxcx
GO

CREATE PROC usp_sf_tybb_xgbxcx
@ksrq ut_rq8,
@jsrq ut_rq8
AS

/*************************
--exec usp_sf_tybb_xgbxcx '20200501','20200710'
*************************/

SET NOCOUNT ON

DECLARE @bxje ut_money

CREATE TABLE #XMLIST
(
	xmdm ut_xmdm,
	xmmc ut_mc64
)

CREATE TABLE #BRLIST
(
	num      INT,
	sfrq     VARCHAR(10),
	sjh      ut_sjh,
	blh      ut_blh,
	hzxm     ut_mc32,
	lcxmdm   ut_xmdm,
	lcxmmc   ut_mc64,
	ypdj     ut_sl14
)

CREATE TABLE #BXLIST
(
	sfrq         VARCHAR(10),
	ybje         ut_sl14
)

CREATE TABLE #RETLIST
(
	sfrq         VARCHAR(10),
	lcxmdm       ut_xmdm,
	lcxmmc       ut_mc64,
	ypdj         ut_sl14,
	ypsl         ut_sl14,
	ypje         ut_sl14,
	ybje         ut_sl14
)

INSERT INTO #XMLIST (xmdm,xmmc)
SELECT id,name FROM dbo.YY_LCSFXMK
WHERE id='5873'

INSERT INTO #BRLIST (num,sfrq,sjh,blh,hzxm,lcxmdm,lcxmmc,ypdj)
SELECT DENSE_RANK() OVER (PARTITION BY b.lcxmdm,SUBSTRING(c.sfrq,1,4)+'-'+SUBSTRING(c.sfrq,5,2) ORDER BY c.patid,ISNULL(b.qrrq,a.lrrq)) num,
		 SUBSTRING(c.sfrq,1,4)+'-'+SUBSTRING(c.sfrq,5,2),sjh,c.blh,c.hzxm,b.lcxmdm,b.lcxmmc,b.ylsj
FROM dbo.VW_MZCFK a (NOLOCK)
	INNER JOIN dbo.VW_MZCFMXK b (NOLOCK) ON a.xh=b.cfxh
	INNER JOIN dbo.VW_MZBRJSK c (NOLOCK) ON a.jssjh=c.sjh
WHERE c.sfrq BETWEEN @ksrq AND @jsrq+'24'
AND c.ybjszt=2
AND a.jlzt=0
AND EXISTS (SELECT 1 FROM #XMLIST x WHERE b.lcxmdm=x.xmdm)

INSERT INTO #BXLIST (sfrq,ybje)
SELECT sfrq,SUM(y.je) je
FROM (SELECT DISTINCT sfrq,sjh FROM #BRLIST AS a) x
	INNER JOIN dbo.VW_MZJEMXK y (NOLOCK) ON x.sjh=y.jssjh
WHERE y.lx='yb08'
GROUP BY sfrq

INSERT INTO #RETLIST (sfrq,lcxmdm,lcxmmc,ypdj,ypsl,ypje)
SELECT sfrq,lcxmdm,lcxmmc,CONVERT(NUMERIC(9,2),SUM(ypdj)/MAX(num)) ypdj,MAX(num) ypsl,SUM(ypdj) ypje
FROM #BRLIST
GROUP BY sfrq,lcxmdm,lcxmmc

UPDATE a SET a.ybje=b.ybje FROM #RETLIST a INNER JOIN #BXLIST b ON a.sfrq=b.sfrq

SELECT sfrq '日期',lcxmdm '代码',lcxmmc '名称',ypdj '单价',ypsl '数量',ypje '金额',ybje '垫付金额'
FROM #RETLIST

RETURN