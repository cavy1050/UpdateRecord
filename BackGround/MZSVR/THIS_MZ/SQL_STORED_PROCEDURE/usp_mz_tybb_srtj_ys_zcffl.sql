ALTER PROC usp_mz_tybb_srtj_ys_zcffl
@ksrq ut_rq8,
@jsrq ut_rq8
AS

/**********************
exec usp_mz_tybb_srtj_ys_zcffl '20190601','20190630'
--核对收入数据
SELECT SUM(convert(numeric(14,2),(c.xmdj-c.yhdj)*c.xmsl))
FROM #tmp_ghlist a
	INNER JOIN dbo.VW_GHMXK c ON a.ghxh=c.ghxh
--
*********************/

SET NOCOUNT ON

CREATE TABLE #tmp_ghlist
(
	ghxh  ut_xh12,
	ksdm  ut_ksdm,
	ysdm  ut_czyh,
	ghrq  VARCHAR(10),
	sjly  ut_bz
)

--先插入挂号记录，在做更新，保证数据一致
INSERT INTO #tmp_ghlist (ghxh,ksdm,ysdm,ghrq,sjly)
select a.xh,a.ghksdm,ISNULL(a.scjzysdm,''),dbo.ufnConvertDateString(a.ghrq,'D'),0 sjly
from VW_GHZDK a (nolock), VW_MZBRJSK b (nolock)
where b.sfrq between @ksrq and @jsrq+'24' and b.ybjszt=2 and b.ghsfbz = 0 and a.jssjh=b.sjh

--处理结构化电子病历
UPDATE a SET a.ysdm=c.CJYS,a.sjly=1
FROM #tmp_ghlist a
	INNER JOIN CISDB.dbo.EMR_BRSYK_OUTP b (NOLOCK) ON a.ghxh=b.HISSYXH
	INNER JOIN CISDB.dbo.EMR_QTBLJLK c (NOLOCK) ON b.SYXH=c.SYXH

--处理标准病历
UPDATE a SET a.ysdm=b.YSDM,a.sjly=2
FROM #tmp_ghlist a
	INNER JOIN CISDB..VW_OUTP_NMZBLK b (NOLOCK) ON a.ghxh=b.GHXH
	INNER JOIN (SELECT c.GHXH,MIN(c.LRRQ) LRRQ FROM CISDB..VW_OUTP_NMZBLK c (NOLOCK)  GROUP BY c.GHXH) AS d ON b.GHXH=d.GHXH AND b.LRRQ=d.LRRQ

--处理住院单
UPDATE a SET a.ysdm=b.LRYSDM,a.sjly=3
FROM #tmp_ghlist a
	INNER JOIN CISDB.dbo.OUTP_RYDJK b (NOLOCK) ON a.ghxh=b.GHXH


SELECT  e.id '科室代码',e.name '科室名称',ISNULL(d.id,'xxx') '医生代码',ISNULL(d.name,'') '医生名称',a.ghrq '挂号日期',
		  c.xmdm '项目代码',c.xmmc '项目名称',c.xmdj '项目单价',SUM(c.xmsl) '项目数量',SUM(convert(numeric(14,2),(c.xmdj-c.yhdj)*c.xmsl)) '总金额',
		    CASE WHEN a.sjly IN (1,2) THEN '病历' WHEN a.sjly = 3 THEN '转住院' ELSE '啥都没有' END '类别'
FROM #tmp_ghlist a
	INNER JOIN dbo.VW_GHMXK c ON a.ghxh=c.ghxh
	LEFT JOIN dbo.YY_ZGBMK d (nolock) ON a.ysdm=d.id
	INNER JOIN dbo.YY_KSBMK e (NOLOCK) ON a.ksdm=e.id
WHERE c.isghf=2 AND c.xmsl!=0
GROUP BY e.id,e.name,ISNULL(d.id,'xxx'),ISNULL(d.name,''),a.ghrq,
			c.xmdm,c.xmmc,c.xmdj,CASE WHEN a.sjly IN (1,2) THEN '病历' WHEN a.sjly = 3 THEN '转住院' ELSE '啥都没有' END
HAVING SUM(convert(numeric(14,2),(c.xmdj-c.yhdj)*c.xmsl))!=0          
UNION ALL
SELECT  e.id '科室代码',e.name '科室名称',ISNULL(d.id,'xxx') '医生代码',ISNULL(d.name,'') '医生名称',a.ghrq '挂号日期',
		  c.xmdm '项目代码',c.xmmc '项目名称',0 '项目单价',SUM(1) '项目数量',SUM(convert(numeric(14,2),(c.xmdj-c.yhdj)*c.xmsl)) '总金额',
		    CASE WHEN a.sjly IN (1,2) THEN '病历' WHEN a.sjly = 3 THEN '转住院' ELSE '啥都没有' END '类别'
FROM #tmp_ghlist a
	INNER JOIN dbo.VW_GHMXK c ON a.ghxh=c.ghxh
	LEFT JOIN dbo.YY_ZGBMK d (nolock) ON a.ysdm=d.id
	INNER JOIN dbo.YY_KSBMK e (NOLOCK) ON a.ksdm=e.id
WHERE c.isghf=2 AND c.xmsl=0
GROUP BY e.id,e.name,ISNULL(d.id,'xxx'),ISNULL(d.name,''),a.ghrq,
			c.xmdm,c.xmmc,c.xmdj,CASE WHEN a.sjly IN (1,2) THEN '病历' WHEN a.sjly = 3 THEN '转住院' ELSE '啥都没有' END

RETURN


