ALTER PROC usp_mz_tybb_srtj_ys_zcffl
@ksrq ut_rq8,
@jsrq ut_rq8
AS

/**********************
exec usp_mz_tybb_srtj_ys_zcffl '20190601','20190630'
--�˶���������
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

--�Ȳ���Һż�¼���������£���֤����һ��
INSERT INTO #tmp_ghlist (ghxh,ksdm,ysdm,ghrq,sjly)
select a.xh,a.ghksdm,ISNULL(a.scjzysdm,''),dbo.ufnConvertDateString(a.ghrq,'D'),0 sjly
from VW_GHZDK a (nolock), VW_MZBRJSK b (nolock)
where b.sfrq between @ksrq and @jsrq+'24' and b.ybjszt=2 and b.ghsfbz = 0 and a.jssjh=b.sjh

--����ṹ�����Ӳ���
UPDATE a SET a.ysdm=c.CJYS,a.sjly=1
FROM #tmp_ghlist a
	INNER JOIN CISDB.dbo.EMR_BRSYK_OUTP b (NOLOCK) ON a.ghxh=b.HISSYXH
	INNER JOIN CISDB.dbo.EMR_QTBLJLK c (NOLOCK) ON b.SYXH=c.SYXH

--�����׼����
UPDATE a SET a.ysdm=b.YSDM,a.sjly=2
FROM #tmp_ghlist a
	INNER JOIN CISDB..VW_OUTP_NMZBLK b (NOLOCK) ON a.ghxh=b.GHXH
	INNER JOIN (SELECT c.GHXH,MIN(c.LRRQ) LRRQ FROM CISDB..VW_OUTP_NMZBLK c (NOLOCK)  GROUP BY c.GHXH) AS d ON b.GHXH=d.GHXH AND b.LRRQ=d.LRRQ

--����סԺ��
UPDATE a SET a.ysdm=b.LRYSDM,a.sjly=3
FROM #tmp_ghlist a
	INNER JOIN CISDB.dbo.OUTP_RYDJK b (NOLOCK) ON a.ghxh=b.GHXH


SELECT  e.id '���Ҵ���',e.name '��������',ISNULL(d.id,'xxx') 'ҽ������',ISNULL(d.name,'') 'ҽ������',a.ghrq '�Һ�����',
		  c.xmdm '��Ŀ����',c.xmmc '��Ŀ����',c.xmdj '��Ŀ����',SUM(c.xmsl) '��Ŀ����',SUM(convert(numeric(14,2),(c.xmdj-c.yhdj)*c.xmsl)) '�ܽ��',
		    CASE WHEN a.sjly IN (1,2) THEN '����' WHEN a.sjly = 3 THEN 'תסԺ' ELSE 'ɶ��û��' END '���'
FROM #tmp_ghlist a
	INNER JOIN dbo.VW_GHMXK c ON a.ghxh=c.ghxh
	LEFT JOIN dbo.YY_ZGBMK d (nolock) ON a.ysdm=d.id
	INNER JOIN dbo.YY_KSBMK e (NOLOCK) ON a.ksdm=e.id
WHERE c.isghf=2 AND c.xmsl!=0
GROUP BY e.id,e.name,ISNULL(d.id,'xxx'),ISNULL(d.name,''),a.ghrq,
			c.xmdm,c.xmmc,c.xmdj,CASE WHEN a.sjly IN (1,2) THEN '����' WHEN a.sjly = 3 THEN 'תסԺ' ELSE 'ɶ��û��' END
HAVING SUM(convert(numeric(14,2),(c.xmdj-c.yhdj)*c.xmsl))!=0          
UNION ALL
SELECT  e.id '���Ҵ���',e.name '��������',ISNULL(d.id,'xxx') 'ҽ������',ISNULL(d.name,'') 'ҽ������',a.ghrq '�Һ�����',
		  c.xmdm '��Ŀ����',c.xmmc '��Ŀ����',0 '��Ŀ����',SUM(1) '��Ŀ����',SUM(convert(numeric(14,2),(c.xmdj-c.yhdj)*c.xmsl)) '�ܽ��',
		    CASE WHEN a.sjly IN (1,2) THEN '����' WHEN a.sjly = 3 THEN 'תסԺ' ELSE 'ɶ��û��' END '���'
FROM #tmp_ghlist a
	INNER JOIN dbo.VW_GHMXK c ON a.ghxh=c.ghxh
	LEFT JOIN dbo.YY_ZGBMK d (nolock) ON a.ysdm=d.id
	INNER JOIN dbo.YY_KSBMK e (NOLOCK) ON a.ksdm=e.id
WHERE c.isghf=2 AND c.xmsl=0
GROUP BY e.id,e.name,ISNULL(d.id,'xxx'),ISNULL(d.name,''),a.ghrq,
			c.xmdm,c.xmmc,c.xmdj,CASE WHEN a.sjly IN (1,2) THEN '����' WHEN a.sjly = 3 THEN 'תסԺ' ELSE 'ɶ��û��' END

RETURN


