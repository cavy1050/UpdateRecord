IF OBJECT_ID('usp_cqyb_tybb_zybrdfcx','P') IS NOT NULL
DROP PROC usp_cqyb_tybb_zybrdfcx
GO

CREATE PROC usp_cqyb_tybb_zybrdfcx
@ksrq  ut_rq8,
@jsrq  ut_rq8,
@blh   ut_blh,
@jszt  ut_bz,   ---����״̬ 0:δ����(��ѯ����סԺ����δ����渶����ҽ���������Ŀ��Ҫ��1�ѽ��� (�ѽ��㲡�˵渶����ѯ����ҽ�����ϱ���Ҫ)
@yydm  ut_dm2
AS

/**************************
--add by yangdi 2019.12.26 ����ҽ��_סԺ���˵渶��ѯ  �������Ų�ѯ ���������ҽ���ӿ�
--add by yangdi 2020.1.21  ���ӿ�ʼʱ�䣬����ʱ���������ѯʱ������ѽ���סԺ���˵渶���
exec usp_cqyb_tybb_zybrdfcx '20190018181'
***************************/

SET NOCOUNT ON

--ߣһ����ʱ�������������ݶ�һ���
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
	SJLX  ut_bz        --�������� 0���½ӿ� 1���Ͻӿ�
)

--��ѯ�����ж�
IF @jszt=0
BEGIN
	--ߣһ���½ӿڣ����ݲ嵽�м��
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

	--����½ӿ�û�еĻ����Ͳ�ѯ�Ͻӿڵ����ݡ�
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
	--�½ӿ�
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
	
	--�Ͻӿ�
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

SELECT a.SYXH '��ҳ���',a.JSXH '�������',a.BLH '������',a.HZXM '����',a.YPDM'����',a.YPMC '����',a.DYDM 'ҽ����Ӧ����',a.DFJE '�渶���',a.SJLX '��������'
FROM #YB_CQYB_ZYBRDFXX a (NOLOCK)
ORDER BY a.SYXH,a.DFJE DESC

RETURN