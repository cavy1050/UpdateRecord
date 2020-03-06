ALTER PROC usp_yy_qgydybjssbb
@ksrq ut_rq8,
@jsrq ut_rq8,
@yydm ut_dm2,
@cblb VARCHAR(3)

AS

/************************************
--add by yangdi 2017.8.17 全国异地医保结算申报表，作为医保对账使用，在对账时不区分行政区域。
[修改记录]
--add by yangdi 2017.12.4 修改报表按照医院代码进行查询，没有考虑康复医院情况。
************************************/


SET NOCOUNT ON

CREATE TABLE #temp_qgydjssbb
(
	lb    VARCHAR(2),
	TCZF  ut_money,
	ZHZF  ut_money,
	DEZF  ut_money,
	GWYBZ ut_money
)

INSERT INTO #temp_qgydjssbb (lb,TCZF,ZHZF,DEZF,GWYBZ)
SELECT 'zy',
	   ISNULL(SUM(CASE WHEN b.lx='yb01' THEN je ELSE 0 END),0) TCZF,
	   ISNULL(SUM(CASE WHEN b.lx='yb02' THEN je ELSE 0 END),0) ZHZF,
	   ISNULL(SUM(CASE WHEN b.lx='yb05' THEN je ELSE 0 END),0) DEZF,
	   ISNULL(SUM(CASE WHEN b.lx='yb03' THEN je ELSE 0 END),0) GWYBZ
FROM dbo.ZY_BRJSK a (NOLOCK) 
	INNER JOIN dbo.ZY_BRJSJEK b (NOLOCK) ON a.xh=b.jsxh
	INNER JOIN dbo.YY_CQYB_ZYJZJLK c (NOLOCK) ON a.syxh=c.syxh
	INNER JOIN dbo.YY_CQYB_ZYJSJLK d (NOLOCK) ON a.xh=d.jsxh AND c.jzlsh=d.jzlsh 
	INNER JOIN dbo.YY_KSBMK e (NOLOCK) ON a.ksdm=e.id
WHERE c.sbkh LIKE '#%' AND a.jsrq BETWEEN @ksrq AND @jsrq+'24'
AND a.ybjszt=2
AND e.yydm=@yydm
AND c.xzlb=1
AND ((@cblb=1 AND c.cblb<>2) OR (@cblb=2 AND c.cblb=2))
UNION ALL
SELECT 'zy',
	   ISNULL(SUM(CASE WHEN b.lx='yb01' THEN je ELSE 0 END),0) TCZF,
	   ISNULL(SUM(CASE WHEN b.lx='yb02' THEN je ELSE 0 END),0) ZHZF,
	   ISNULL(SUM(CASE WHEN b.lx='yb05' THEN je ELSE 0 END),0) DEZF,
	   ISNULL(SUM(CASE WHEN b.lx='yb03' THEN je ELSE 0 END),0) GWYBZ
FROM dbo.ZY_BRJSK a (NOLOCK) 
	INNER JOIN dbo.ZY_BRJSJEK b (NOLOCK) ON a.xh=b.jsxh
	INNER JOIN dbo.YY_CQYB_ZYJZJLK c (NOLOCK) ON a.syxh=c.syxh
	INNER JOIN dbo.YY_CQYB_ZYJSJLK d (NOLOCK) ON a.hcxh=d.jsxh AND c.jzlsh=d.jzlsh 
	INNER JOIN dbo.YY_KSBMK e (NOLOCK) ON a.ksdm=e.id
WHERE c.sbkh LIKE '#%' AND a.jsrq BETWEEN @ksrq AND @jsrq+'24'
AND a.ybjszt=2
AND e.yydm=@yydm
AND c.xzlb=1
AND ((@cblb=1 AND c.cblb<>2) OR (@cblb=2 AND c.cblb=2))

/*
SELECT 'mz' lb,
	   ISNULL(SUM(CASE WHEN b.lx='yb01' THEN je ELSE 0 END),0) TCZF,
	   ISNULL(SUM(CASE WHEN b.lx='yb02' THEN je ELSE 0 END),0) ZHZF,
	   ISNULL(SUM(CASE WHEN b.lx='yb05' THEN je ELSE 0 END),0) DEZF,
	   ISNULL(SUM(CASE WHEN b.lx='yb03' THEN je ELSE 0 END),0) GWYBZ
FROM MZSVR.THIS_MZ.dbo.VW_MZBRJSK a (nolock)
	INNER JOIN MZSVR.THIS_MZ.dbo.VW_MZJEMXK b (nolock) ON a.sjh=b.jssjh
	INNER JOIN MZSVR.THIS_MZ.dbo.YY_CQYB_MZJZJLK c (NOLOCK) ON a.sjh=c.jssjh
	INNER JOIN dbo.YY_KSBMK e (NOLOCK) ON a.ksdm=e.id
WHERE a.sfrq BETWEEN @ksrq AND @jsrq+'24' and c.sbkh LIKE '#%'
AND a.ybjszt=2 AND e.yydm=@yydm
AND c.cblb=@cblb
AND a.jlzt IN (0,1)
*/

select @yydm yydm,substring(@ksrq,1,4)+'年'+substring(@ksrq,5,2)+'月'+substring(@ksrq,7,2)+'日'+'--'
+substring(@jsrq,1,4)+'年'+substring(@jsrq,5,2)+'月'+substring(@jsrq,7,2)+'日' fkssq,'统筹基金支付' xm,
sum(case when lb = 'mz' then TCZF else 0 end) mz ,
sum(case when lb = 'zy' THEN TCZF else 0 end) zy,
sum(TCZF) zje
from #temp_qgydjssbb (nolock)
UNION ALL
select @yydm yydm,substring(@ksrq,1,4)+'年'+substring(@ksrq,5,2)+'月'+substring(@ksrq,7,2)+'日'+'--'
+substring(@jsrq,1,4)+'年'+substring(@jsrq,5,2)+'月'+substring(@jsrq,7,2)+'日' fkssq,'个人帐户支付' xm,
sum(case when lb = 'mz' then ZHZF else 0 end) mz ,
sum(case when lb = 'zy' THEN ZHZF else 0 end) zy,
sum(ZHZF) zje
from #temp_qgydjssbb (nolock)
UNION ALL
select @yydm yydm,substring(@ksrq,1,4)+'年'+substring(@ksrq,5,2)+'月'+substring(@ksrq,7,2)+'日'+'--'
+substring(@jsrq,1,4)+'年'+substring(@jsrq,5,2)+'月'+substring(@jsrq,7,2)+'日' fkssq,'大额保险支付' xm,
sum(case when lb = 'mz' then DEZF else 0 end) mz ,
sum(case when lb = 'zy' THEN DEZF else 0 end) zy,
sum(DEZF) zje
from #temp_qgydjssbb (nolock)
UNION ALL
select @yydm yydm,substring(@ksrq,1,4)+'年'+substring(@ksrq,5,2)+'月'+substring(@ksrq,7,2)+'日'+'--'
+substring(@jsrq,1,4)+'年'+substring(@jsrq,5,2)+'月'+substring(@jsrq,7,2)+'日' fkssq,'市级公务员补助' xm,
sum(case when lb = 'mz' then GWYBZ else 0 end) mz ,
sum(case when lb = 'zy' THEN GWYBZ else 0 end) zy,
sum(GWYBZ) zje
from #temp_qgydjssbb (nolock)


RETURN

