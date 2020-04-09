if exists(select 1 from sysobjects where name = 'usp_cqyb_queryhisjsje')
  drop proc usp_cqyb_queryhisjsje
go
Create proc usp_cqyb_queryhisjsje
(
	@kssj		varchar(16),   
	@jssj		varchar(16),    
	@type	    VARCHAR(10), --1 ְ�� ,  2 ���� , 3 ���� ,  5 ���� ,  4 ���� ,   6 ���ְ�� ,  7 ��ؾ���
	@ddyljgbm	varchar(10) --ҽԺҽ������  yy_jbconfig.yydm
)   
as 
/****************************************
[�汾��]4.0.0.0.0
[����ʱ��]2018.05.02
[����]qfj
[��Ȩ]Copyright ? 1998-2017���������Ƽ����Źɷ����޹�˾
[����]HISҽ�����˻���
[����˵��]
	HISҽ�����˻���
[����˵��]
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��]

	exec usp_cqyb_queryhisjsje '2018070100:00:00','2018073123:59:59','1','10017'
   
[�޸ļ�¼] 
****************************************/
set nocount on 
DECLARE @strtc VARCHAR(3),
        @strzhzf VARCHAR(3),
		@strgwy VARCHAR(3),
		@strgwyfh VARCHAR(3),
		@strde VARCHAR(3),
		@strmzjz VARCHAR(3),
		@strsyjj VARCHAR(3),
		@strsyzh VARCHAR(3),
		@strgsjj VARCHAR(3),
		@strgszh VARCHAR(3),
		@strzhdy VARCHAR(3),
		@strqtbz VARCHAR(3)
DECLARE @strtc_zy VARCHAR(3),
        @strzhzf_zy VARCHAR(3),
		@strgwy_zy VARCHAR(3),
		@strgwyfh_zy VARCHAR(3),
		@strde_zy VARCHAR(3),
		@strmzjz_zy VARCHAR(3),
		@strsyjj_zy VARCHAR(3),
		@strsyzh_zy VARCHAR(3),
		@strgsjj_zy VARCHAR(3),
		@strgszh_zy VARCHAR(3),
		@strzhdy_zy VARCHAR(3),
		@strqtbz_zy VARCHAR(3)

IF EXISTS (SELECT 1 FROM YY_JBCONFIG (NOLOCK) WHERE yydm IN ('10017'))  --��һ  --���ڸ�Ժ�Ͻӿڲ�һ�� ,�����Ǵ������������ݼ���
BEGIN
	SELECT @strtc = '02',@strzhzf= '01',@strgwy = '03',@strgwyfh = '10' ,@strde = '05' ,@strmzjz = '14' ,
		   @strsyjj = '42' ,@strsyzh = '50' ,@strgsjj = '' ,@strgszh = '' ,@strzhdy = '24' ,@strqtbz = ''
	SELECT @strtc_zy = '02',@strzhzf_zy= '01',@strgwy_zy = '03',@strgwyfh_zy = '10' ,@strde_zy = '05' ,@strmzjz_zy = '14' ,
		   @strsyjj_zy = '42' ,@strsyzh_zy = '50' ,@strgsjj_zy = '44' ,@strgszh_zy = '51' ,@strzhdy_zy = '48',@strqtbz_zy = '49' 
END
ELSE IF EXISTS (SELECT 1 FROM YY_JBCONFIG WHERE yydm IN ('10018'))  --����
BEGIN
	SELECT @strtc = '02',@strzhzf= '01',@strgwy = '03',@strgwyfh = '10' ,@strde = '05' ,@strmzjz = '14' ,
		   @strsyjj = '42' ,@strsyzh = '' ,@strgsjj = '44' ,@strgszh = '' ,@strzhdy = '46' ,@strqtbz = ''
	SELECT @strtc_zy = '02',@strzhzf_zy= '01',@strgwy_zy = '03',@strgwyfh_zy = '10' ,@strde_zy = '05' ,@strmzjz_zy = '14' ,
		   @strsyjj_zy = '42' ,@strsyzh_zy = '' ,@strgsjj_zy = '44' ,@strgszh_zy = '' ,@strzhdy_zy = '46' ,@strqtbz_zy = ''
END
ELSE  --����ҽԺ�Ͻӿ�
BEGIN
	SELECT @strtc = '01',@strzhzf= '02',@strgwy = '03',@strgwyfh = '06' ,@strde = '05' ,@strmzjz = '09' ,
		   @strsyjj = '19' ,@strsyzh = '29' ,@strgsjj = '' ,@strgszh = '' ,@strzhdy = '24',@strqtbz = '30' 
	SELECT @strtc_zy = '01',@strzhzf_zy= '02',@strgwy_zy = '03',@strgwyfh_zy = '06' ,@strde_zy = '05' ,@strmzjz_zy = '09' ,
		   @strsyjj_zy = '25' ,@strsyzh_zy = '32' ,@strgsjj_zy = '27' ,@strgszh_zy = '33' ,@strzhdy_zy = '24' ,@strqtbz_zy = '31'
END

DECLARE @xzlb VARCHAR(3),@cblb VARCHAR(3)
IF @type in ('1','3','6','7')
    SELECT @xzlb = '1' ,@cblb = '1'
ELSE IF @type = '2'
    SELECT @xzlb = '1' ,@cblb = '2'
ELSE IF @type = '4'
    SELECT @xzlb = '3' ,@cblb = '1'
ELSE IF @type = '5'
    SELECT @xzlb = '2' ,@cblb = '1'
ELSE
    SELECT @xzlb = '1' ,@cblb = '1'

select a.* INTO #YY_CQYB_YBSJZD  from YY_CQYB_YBSJZD a(NOLOCK) WHERE a.zdlb = 'YLLB' AND a.xzlb = @xzlb AND a.cblb = @cblb

select a.* INTO #YY_CQYB_SYLB  from YY_CQYB_YBSJZD a(NOLOCK) WHERE a.zdlb = 'SYLB' AND a.xtbz = 1

DECLARE @cq18Config VARCHAR(10),
        @cq01Config varchar(10)
SELECT @cq18Config = a.config FROM YY_CONFIG a(NOLOCK) WHERE a.id = 'CQ18'
IF ISNULL(@cq18Config,'') = '' 
BEGIN
    SELECT 'F','CQ18�������ò���ȷ��' +@cq18Config
    RETURN
END

SELECT @cq01Config = a.config FROM YY_CONFIG a(NOLOCK) WHERE a.id = 'CQ01'

CREATE TABLE #templateTable
(
	���			VARCHAR(30)		NULL,
	ҽ�����		VARCHAR(50)		NULL,
	�������		VARCHAR(50)		NULL,  
	ͳ����		NUMERIC(12,2)		NULL,  
	�˻�֧��		NUMERIC(12,2)		NULL,
	�˻����ý��	NUMERIC(12,2)		NULL,
	���������	NUMERIC(12,2)		NULL,
	����Ա���		NUMERIC(12,2)		NULL,
	�����������	NUMERIC(12,2)		NULL,
	��������֧��	NUMERIC(12,2)		NULL,
	�����˻�֧��	NUMERIC(12,2)		NULL,
	���˻���֧��	NUMERIC(12,2)		NULL,
	�����˻�֧��	NUMERIC(12,2)		NULL
)
--׼����ʱ��
SELECT * into #reslutMz FROM #templateTable
SELECT * into #reslutZy FROM #templateTable
SELECT * into #reslutHj FROM #templateTable
SELECT * into #reslutMzDy FROM #templateTable   --��ְ����������ϼ�
SELECT * into #reslutZyDy FROM #templateTable   --��ְ������סԺ�ϼ�

--��������׼��
SELECT * INTO #HisMzJsmx FROM 
(
	SELECT a.jssjh �վݺ�,a.zxlsh ������ˮ��,a.xzlb �������,jzjl.cblb �α����, 
		CASE jzjl.cblb WHEN '2' THEN jzjl.jmyllb ELSE jzjl.zgyllb END ҽ�����, 
		b.sfrq �շ�����, b.czyh ����Ա,b.hzxm ����,b.blh ������,jzjl.sbkh �籣����, 
		CASE b.jlzt WHEN 0 THEN '����' WHEN 1 THEN '�˷�' WHEN 2 THEN '���' end ��¼״̬,(CASE WHEN a.xzlb<> 3 THEN '' else a.sylb END ) �������
	FROM VW_CQYB_MZJSJLK a(nolock), VW_CQYB_MZJZJLK jzjl(nolock),VW_MZBRJSK b(nolock) ,YY_YBFLK c(NOLOCK)
	where a.jssjh = b.sjh 
	AND a.ddyljgbm = @ddyljgbm
	AND jzjl.jssjh = a.jssjh 
	AND b.ybjszt = '2'  
	AND b.jlzt <> '2' 
	AND b.ybdm = c.ybdm
	AND c.ybjkid = @cq18Config
	AND b.sfrq >= @kssj  
	AND b.sfrq <= @jssj 
	AND (
			   ( '1' = @type AND  jzjl.xzlb = '1'  and  jzjl.cblb = '1' AND jzjl.sbkh NOT LIKE '#%' )
			OR ( '2' = @type AND  jzjl.xzlb = '1'  and  jzjl.cblb = '2' AND jzjl.sbkh NOT LIKE '#%' )
			OR ( '3' = @type AND  jzjl.xzlb = '1'  and  jzjl.cblb = '3' AND jzjl.sbkh NOT LIKE '#%' )	
			OR ( '5' = @type AND jzjl.xzlb = '2' AND jzjl.sbkh NOT LIKE '#%')
			OR ( '4' = @type AND jzjl.xzlb = '3' AND jzjl.sbkh NOT LIKE '#%')
			OR ( '6' = @type AND  jzjl.xzlb = '1'  and  jzjl.cblb <> '2' AND jzjl.sbkh LIKE '#%' )
			OR ( '7' = @type AND  jzjl.xzlb = '1'  and  jzjl.cblb = '2' AND jzjl.sbkh LIKE '#%' )
		)
		
	union all 
	SELECT b.sjh �վݺ�,a.czlsh ������ˮ��,a.xzlb �������,jzjl.cblb �α����, 
		CASE jzjl.cblb WHEN '2' THEN jzjl.jmyllb ELSE jzjl.zgyllb END ҽ�����, 
		b.sfrq �շ�����, b.czyh ����Ա,b.hzxm ����,b.blh ������,jzjl.sbkh �籣����, 
		CASE b.jlzt WHEN 0 THEN '����' WHEN 1 THEN '�˷�' WHEN 2 THEN '���' end ��¼״̬ ,(CASE WHEN a.xzlb<> 3 THEN '' else a.sylb END) ������� 
	FROM VW_CQYB_MZJSJLK a(nolock), VW_CQYB_MZJZJLK jzjl(nolock),VW_MZBRJSK b(nolock),YY_YBFLK c(NOLOCK) 
	where a.jssjh = b.tsjh  
	AND a.ddyljgbm = @ddyljgbm  
	AND jzjl.jssjh = a.jssjh 
	AND b.ybjszt = '2' 
	AND b.jlzt = '2' 
	AND b.ybdm = c.ybdm
	AND c.ybjkid = @cq18Config 
	AND b.sfrq >= @kssj 
	AND b.sfrq <= @jssj  
	AND (
			   ( '1' = @type AND  jzjl.xzlb = '1'  and  jzjl.cblb = '1' AND jzjl.sbkh NOT LIKE '#%' )
			OR ( '2' = @type AND  jzjl.xzlb = '1'  and  jzjl.cblb = '2' AND jzjl.sbkh NOT LIKE '#%' )
			OR ( '3' = @type AND  jzjl.xzlb = '1'  and  jzjl.cblb = '3' AND jzjl.sbkh NOT LIKE '#%' )	
			OR ( '5' = @type AND jzjl.xzlb = '2' AND jzjl.sbkh NOT LIKE '#%')
			OR ( '4' = @type AND jzjl.xzlb = '3' AND jzjl.sbkh NOT LIKE '#%')
			OR ( '6' = @type AND  jzjl.xzlb = '1'  and  jzjl.cblb <> '2' AND jzjl.sbkh LIKE '#%' )
			OR ( '7' = @type AND  jzjl.xzlb = '1'  and  jzjl.cblb = '2' AND jzjl.sbkh LIKE '#%' )
		)
) mzjsmx  		

select a.*,
       SUM(CASE WHEN b.lx IN('yb01',@strtc) THEN b.je ELSE 0 END) ͳ����,
       SUM(CASE WHEN b.lx IN('yb02',@strzhzf) THEN b.je ELSE 0 END) �˻�֧��,
       SUM(CASE WHEN b.lx IN('yb03',@strgwy) THEN b.je ELSE 0 END) ����Ա����,
       SUM(CASE WHEN b.lx IN('yb06',@strgwyfh) THEN b.je ELSE 0 END) ��ʷ���߹���Ա����,
       SUM(CASE WHEN b.lx IN('yb05',@strde) THEN b.je ELSE 0 END) ���������,
       SUM(CASE WHEN b.lx IN('yb09',@strmzjz) THEN b.je ELSE 0 END) �����������,
       SUM(CASE WHEN b.lx IN('yb24',@strsyjj) THEN b.je ELSE 0 END) ��������֧��,
       SUM(CASE WHEN b.lx IN('yb31',@strsyzh) THEN b.je ELSE 0 END) �����˻�֧��,
       SUM(CASE WHEN b.lx IN('yb26',@strgsjj) THEN b.je ELSE 0 END) ���˻���֧��,
       SUM(CASE WHEN b.lx IN('yb32',@strgszh) THEN b.je ELSE 0 END) �����˻�֧��,
	   SUM(CASE WHEN b.lx IN('yb30',@strqtbz) THEN b.je ELSE 0 END) ��������,
       SUM(CASE WHEN b.lx IN('yb99',@strzhdy) THEN b.je ELSE 0 END) �˻����ý��
INTO #HisMzJemx
FROM #HisMzJsmx a,VW_MZJEMXK b(NOLOCK) WHERE a.�վݺ� = b.jssjh 
GROUP BY �վݺ� , ������ˮ��, �������, �α����,ҽ�����,�շ�����,����Ա,����,������,�籣����,��¼״̬ ,�������

--סԺ����׼��
SELECT * INTO #HisZyJsmx FROM
( 
    SELECT CONVERT(VARCHAR(20),b.xh) �վݺ�,a.zxlsh ������ˮ��,a.xzlb �������,jzjl.cblb �α����,  
		CASE jzjl.cblb WHEN '2' THEN jzjl.jmyllb ELSE jzjl.zgyllb END ҽ�����, 
		b.jsrq �շ�����, b.jsczyh ����Ա,b.hzxm ����,b.blh ������,jzjl.sbkh �籣����,
		CASE b.jlzt WHEN 0 THEN '����' WHEN 1 THEN '���' WHEN 2 THEN '�����' end ��¼״̬ ,(CASE WHEN a.xzlb<> 3 THEN '' else a.sylb END) �������
	FROM YY_CQYB_ZYJSJLK a(nolock), YY_CQYB_ZYJZJLK jzjl(nolock),ZY_BRJSK b(nolock),YY_YBFLK c(NOLOCK) 
	where a.jsxh = b.xh 
	AND a.ddyljgbm = @ddyljgbm  
	AND a.syxh = b.syxh  
	AND jzjl.jzlsh = a.jzlsh 
	AND b.ybjszt = '2'
	AND b.jlzt <> '1'
	AND b.ybdm = c.ybdm
	AND c.ybjkid = @cq18Config
	AND b.jsrq >= @kssj 
	AND b.jsrq <= @jssj
	AND (
			   ( '1' = @type AND  jzjl.xzlb = '1'  and  jzjl.cblb = '1' AND jzjl.sbkh NOT LIKE '#%' )
			OR ( '2' = @type AND  jzjl.xzlb = '1'  and  jzjl.cblb = '2' AND jzjl.sbkh NOT LIKE '#%' )
			OR ( '3' = @type AND  jzjl.xzlb = '1'  and  jzjl.cblb = '3' AND jzjl.sbkh NOT LIKE '#%' )	
			OR ( '5' = @type AND jzjl.xzlb = '2' AND jzjl.sbkh NOT LIKE '#%')
			OR ( '4' = @type AND jzjl.xzlb = '3' AND jzjl.sbkh NOT LIKE '#%')
			OR ( '6' = @type AND  jzjl.xzlb = '1'  and  jzjl.cblb <> '2' AND jzjl.sbkh LIKE '#%' )
			OR ( '7' = @type AND  jzjl.xzlb = '1'  and  jzjl.cblb = '2' AND jzjl.sbkh LIKE '#%' )
		)
	union all
	SELECT CONVERT(VARCHAR(20),b.xh) �վݺ�,a.czlsh ������ˮ��,a.xzlb �������,jzjl.cblb �α����, 
		CASE jzjl.cblb WHEN '2' THEN jzjl.jmyllb ELSE jzjl.zgyllb END ҽ����� , 
		b.jsrq �շ�����, b.jsczyh ����Ա,b.hzxm ����,b.blh ������,jzjl.sbkh �籣����, 
		CASE b.jlzt WHEN 0 THEN '����' WHEN 1 THEN '���' WHEN 2 THEN '�����' end ��¼״̬ ,(CASE WHEN a.xzlb<> 3 THEN '' else a.sylb END) �������
	FROM YY_CQYB_ZYJSJLK a(nolock), YY_CQYB_ZYJZJLK jzjl(nolock),ZY_BRJSK b(nolock),YY_YBFLK c(NOLOCK) 
	WHERE a.jsxh = b.hcxh                                
	and a.ddyljgbm = @ddyljgbm  
	AND a.syxh = b.syxh 
	AND jzjl.jzlsh = a.jzlsh  
	AND b.ybjszt = '2'
	AND b.jlzt = '1'
	AND b.ybdm = c.ybdm
	AND c.ybjkid = @cq18Config
	AND b.jsrq >= @kssj
	AND b.jsrq <= @jssj
	AND (
			   ( '1' = @type AND  jzjl.xzlb = '1'  and  jzjl.cblb = '1' AND jzjl.sbkh NOT LIKE '#%' )
			OR ( '2' = @type AND  jzjl.xzlb = '1'  and  jzjl.cblb = '2' AND jzjl.sbkh NOT LIKE '#%' )
			OR ( '3' = @type AND  jzjl.xzlb = '1'  and  jzjl.cblb = '3' AND jzjl.sbkh NOT LIKE '#%' )	
			OR ( '5' = @type AND jzjl.xzlb = '2' AND jzjl.sbkh NOT LIKE '#%')
			OR ( '4' = @type AND jzjl.xzlb = '3' AND jzjl.sbkh NOT LIKE '#%')
			OR ( '6' = @type AND  jzjl.xzlb = '1'  and  jzjl.cblb <> '2' AND jzjl.sbkh LIKE '#%' )
			OR ( '7' = @type AND  jzjl.xzlb = '1'  and  jzjl.cblb = '2' AND jzjl.sbkh LIKE '#%' )
		)
) zyjsmx		

select a.* ,
       SUM(CASE WHEN b.lx IN('yb01',@strtc_zy) THEN b.je ELSE 0 END) ͳ����,
       SUM(CASE WHEN b.lx IN('yb02',@strzhzf_zy) THEN b.je ELSE 0 END) �˻�֧��,
       SUM(CASE WHEN b.lx IN('yb03',@strgwy_zy) THEN b.je ELSE 0 END) ����Ա����,
       SUM(CASE WHEN b.lx IN('yb06',@strgwyfh_zy) THEN b.je ELSE 0 END) ��ʷ���߹���Ա����,
       SUM(CASE WHEN b.lx IN('yb05',@strde_zy) THEN b.je ELSE 0 END) ���������,
       SUM(CASE WHEN b.lx IN('yb09',@strmzjz_zy) THEN b.je ELSE 0 END) �����������,
       SUM(CASE WHEN b.lx IN('yb24',@strsyjj_zy) THEN b.je ELSE 0 END) ��������֧��,
       SUM(CASE WHEN b.lx IN('yb31',@strsyzh_zy) THEN b.je ELSE 0 END) �����˻�֧��,
       SUM(CASE WHEN b.lx IN('yb26',@strgsjj_zy) THEN b.je ELSE 0 END) ���˻���֧��,
       SUM(CASE WHEN b.lx IN('yb32',@strgszh_zy) THEN b.je ELSE 0 END) �����˻�֧��,
	   SUM(CASE WHEN b.lx IN('yb30',@strqtbz_zy) THEN b.je ELSE 0 END) ��������,
       SUM(CASE WHEN b.lx IN('yb99',@strzhdy_zy) THEN b.je ELSE 0 END) �˻����ý��
INTO #HisZyJemx
FROM #HisZyJsmx a,ZY_BRJSJEK b(NOLOCK)
WHERE a.�վݺ� = b.jsxh
GROUP BY �վݺ� , ������ˮ��, �������, �α����,ҽ�����,�շ�����,����Ա,����,������,�籣����,��¼״̬ ,�������

--��������׼��
IF @type = '1'  --�����ְ������
BEGIN
    --������ý�����ϸ
    SELECT * INTO #HisMzDyMx FROM 
	(
		SELECT a.jssjh �վݺ�,a.zxlsh ������ˮ��,a.xzlb �������,jzjl.cblb �α����, 
			CASE jzjl.cblb WHEN '2' THEN jzjl.jmyllb ELSE jzjl.zgyllb END ҽ�����, 
			b.sfrq �շ�����, b.czyh ����Ա,b.hzxm ����,b.blh ������,jzjl.sbkh �籣����, 
			CASE b.jlzt WHEN 0 THEN '����' WHEN 1 THEN '�˷�' WHEN 2 THEN '���' end ��¼״̬,(CASE WHEN a.xzlb<> 3 THEN '' else a.sylb END ) �������
		FROM VW_CQYB_MZJSJLK a(nolock), VW_CQYB_MZJZJLK jzjl(nolock),VW_MZBRJSK b(nolock) ,YY_YBFLK c(NOLOCK),VW_CQYB_MZDYJLK d(NOLOCK)
		where a.jssjh = b.sjh AND b.sjh = d.jssjh AND d.jlzt IN (2,3) 
		AND a.ddyljgbm = @ddyljgbm
		AND jzjl.jssjh = a.jssjh 
		AND b.ybjszt = '2'  
		AND b.jlzt <> '2' 
		AND b.ybdm = c.ybdm
		AND c.ybjkid = @cq18Config
		AND b.sfrq >= @kssj  
		AND b.sfrq <= @jssj 
		AND (
				NOT ( jzjl.xzlb = '1'  and  jzjl.cblb = '1' AND jzjl.sbkh NOT LIKE '#%' )
			)
		
		union all 
		SELECT b.sjh �վݺ�,a.czlsh ������ˮ��,a.xzlb �������,jzjl.cblb �α����, 
			CASE jzjl.cblb WHEN '2' THEN jzjl.jmyllb ELSE jzjl.zgyllb END ҽ�����, 
			b.sfrq �շ�����, b.czyh ����Ա,b.hzxm ����,b.blh ������,jzjl.sbkh �籣����, 
			CASE b.jlzt WHEN 0 THEN '����' WHEN 1 THEN '�˷�' WHEN 2 THEN '���' end ��¼״̬ ,a.sylb ������� 
		FROM VW_CQYB_MZJSJLK a(nolock), VW_CQYB_MZJZJLK jzjl(nolock),VW_MZBRJSK b(nolock),YY_YBFLK c(NOLOCK) ,VW_CQYB_MZDYJLK d(NOLOCK)
		where a.jssjh = b.tsjh AND a.jssjh = d.jssjh AND d.jlzt IN (2,3) 
		AND a.ddyljgbm = @ddyljgbm  
		AND jzjl.jssjh = a.jssjh 
		AND b.ybjszt = '2' 
		AND b.jlzt = '2' 
		AND b.ybdm = c.ybdm
		AND c.ybjkid = @cq18Config 
		AND b.sfrq >= @kssj 
		AND b.sfrq <= @jssj  
		AND (
				NOT ( jzjl.xzlb = '1'  and  jzjl.cblb = '1' AND jzjl.sbkh NOT LIKE '#%' )
			)
	) mzdymx  	
	--������ý����ϸ
	select a.*,
		   0.00 ͳ����,
		   0.00 �˻�֧��,
		   0.00 ����Ա����,
		   0.00 ��ʷ���߹���Ա����,
		   0.00 ���������,
		   0.00 �����������,
		   0.00 ��������֧��,
		   0.00 �����˻�֧��,
		   0.00 ���˻���֧��,
		   0.00 �����˻�֧��,
		   0.00 ��������,
		   SUM(CASE WHEN b.lx IN('yb99',@strzhdy) THEN b.je ELSE 0 END) �˻����ý��
	INTO #HisMzDyJemx
	FROM #HisMzDyMx a,VW_MZJEMXK b(NOLOCK) WHERE a.�վݺ� = b.jssjh 
	GROUP BY �վݺ� , ������ˮ��, �������, �α����,ҽ�����,�շ�����,����Ա,����,������,�籣����,��¼״̬ ,�������

	--סԺ���ý�����ϸ
	SELECT * INTO #HisZyDyMx FROM
	( 
		SELECT CONVERT(VARCHAR(20),b.xh) �վݺ�,a.zxlsh ������ˮ��,a.xzlb �������,jzjl.cblb �α����,  
			CASE jzjl.cblb WHEN '2' THEN jzjl.jmyllb ELSE jzjl.zgyllb END ҽ�����, 
			b.jsrq �շ�����, b.jsczyh ����Ա,b.hzxm ����,b.blh ������,jzjl.sbkh �籣����,
			CASE b.jlzt WHEN 0 THEN '����' WHEN 1 THEN '���' WHEN 2 THEN '�����' end ��¼״̬ ,(CASE WHEN a.xzlb<> 3 THEN '' else a.sylb END )�������
		FROM YY_CQYB_ZYJSJLK a(nolock), YY_CQYB_ZYJZJLK jzjl(nolock),ZY_BRJSK b(nolock),YY_YBFLK c(NOLOCK),YY_CQYB_ZYDYJLK d(NOLOCK)
		where a.jsxh = b.xh AND a.jsxh = d.jsxh AND d.jlzt IN (2,3) 
		AND a.ddyljgbm = @ddyljgbm  
		AND a.syxh = b.syxh  
		AND jzjl.jzlsh = a.jzlsh 
		AND b.ybjszt = '2'
		AND b.jlzt <> '1'
		AND b.ybdm = c.ybdm
		AND c.ybjkid = @cq18Config
		AND b.jsrq >= @kssj 
		AND b.jsrq <= @jssj
		AND (
				NOT ( jzjl.xzlb = '1'  and  jzjl.cblb = '1' AND jzjl.sbkh NOT LIKE '#%' )
			)
		union all
		SELECT CONVERT(VARCHAR(20),b.xh) �վݺ�,a.czlsh ������ˮ��,a.xzlb �������,jzjl.cblb �α����, 
			CASE jzjl.cblb WHEN '2' THEN jzjl.jmyllb ELSE jzjl.zgyllb END ҽ����� , 
			b.jsrq �շ�����, b.jsczyh ����Ա,b.hzxm ����,b.blh ������,jzjl.sbkh �籣����, 
			CASE b.jlzt WHEN 0 THEN '����' WHEN 1 THEN '���' WHEN 2 THEN '�����' end ��¼״̬ ,a.sylb �������
		FROM YY_CQYB_ZYJSJLK a(nolock), YY_CQYB_ZYJZJLK jzjl(nolock),ZY_BRJSK b(nolock),YY_YBFLK c(NOLOCK) ,YY_CQYB_ZYDYJLK d(NOLOCK)
		WHERE a.jsxh = b.hcxh  AND a.jsxh = d.jsxh AND d.jlzt IN (2,3)                              
		and a.ddyljgbm = @ddyljgbm  
		AND a.syxh = b.syxh 
		AND jzjl.jzlsh = a.jzlsh  
		AND b.ybjszt = '2'
		AND b.jlzt = '1'
		AND b.ybdm = c.ybdm
		AND c.ybjkid = @cq18Config
		AND b.jsrq >= @kssj
		AND b.jsrq <= @jssj
		AND (
				NOT ( jzjl.xzlb = '1'  and  jzjl.cblb = '1' AND jzjl.sbkh NOT LIKE '#%' )
			)
	) zyjsmx	
	----סԺ���ý����ϸ
	select a.* ,
		   0.00 ͳ����,
		   0.00 �˻�֧��,
		   0.00 ����Ա����,
		   0.00 ��ʷ���߹���Ա����,
		   0.00 ���������,
		   0.00 �����������,
		   0.00 ��������֧��,
		   0.00 �����˻�֧��,
		   0.00 ���˻���֧��,
		   0.00 �����˻�֧��,
		   0.00 ��������,
		   SUM(CASE WHEN b.lx IN('yb99',@strzhdy_zy) THEN b.je ELSE 0 END) �˻����ý��
	INTO #HisZyDyJemx
	FROM #HisZyDyMx a,ZY_BRJSJEK b(NOLOCK)
	WHERE a.�վݺ� = b.jsxh
	GROUP BY �վݺ� , ������ˮ��, �������, �α����,ҽ�����,�շ�����,����Ա,����,������,�籣����,��¼״̬ ,�������

	--SELECT * FROM #HisMzDyJemx
	--SELECT * FROM #HisZyDyJemx

	INSERT INTO #reslutMzDy   --��ְ����������ϼ�
	SELECT '�������' ��� ,'' ҽ����� ,'' �������, SUM(ͳ����-�����������) ͳ����,  SUM(�˻�֧��) �˻�֧��,SUM(�˻����ý��) �˻����ý��,
		   SUM(���������) ���������,SUM(����Ա����+��ʷ���߹���Ա����+��������) ����Ա��� ,SUM(�����������) �����������
		   ,SUM(��������֧��) ��������֧��,SUM(�����˻�֧��) �����˻�֧��
		   ,SUM(���˻���֧��) ���˻���֧��,SUM(�����˻�֧��) �����˻�֧��
	FROM #HisMzDyJemx a
	INSERT INTO #reslutMzDy   --��ְ������סԺ�ϼ�
	SELECT 'סԺ����' ���, '' ҽ����� ,'' ������� , SUM(ͳ����-�����������) ͳ����,  SUM(�˻�֧��) �˻�֧��,SUM(�˻����ý��) �˻����ý��,
		   SUM(���������) ���������,SUM(����Ա����+��ʷ���߹���Ա����+��������) ����Ա��� ,SUM(�����������) �����������
		   ,SUM(��������֧��) ��������֧��,SUM(�����˻�֧��) �����˻�֧��
		   ,SUM(���˻���֧��) ���˻���֧��,SUM(�����˻�֧��) �����˻�֧�� 
	FROM #HisZyDyJemx a
	
	--SELECT * FROM #reslutMzDy
	--SELECT * FROM #reslutZyDy 

	INSERT INTO  #reslutMz SELECT * FROM #reslutMzDy
	INSERT INTO  #reslutMz SELECT * FROM #reslutZyDy 
END 

--�ϼ�
INSERT INTO #reslutMz
SELECT '����' ��� ,b.code + b.name ҽ����� ,c.name �������, 
       SUM(CASE WHEN @cq01Config = 'DR' then (ͳ����-�����������) ELSE ͳ���� end) ͳ����,
       SUM(�˻�֧��) �˻�֧��,SUM(�˻����ý��) �˻����ý��,
       SUM(���������) ���������,SUM(����Ա����+��ʷ���߹���Ա����+��������) ����Ա��� ,SUM(�����������) �����������,
       SUM(��������֧��) ��������֧��,SUM(�����˻�֧��) �����˻�֧��,
       SUM(���˻���֧��) ���˻���֧��,SUM(�����˻�֧��) �����˻�֧�� 
FROM #HisMzJemx a LEFT JOIN #YY_CQYB_YBSJZD b ON a.ҽ����� = b.code
                  LEFT JOIN #YY_CQYB_SYLB c ON a.������� = c.code
GROUP BY b.code,b.name,c.name  ORDER BY b.code

INSERT INTO #reslutZy
SELECT 'סԺ' ���,b.code + b.name ҽ����� ,c.name ������� , 
       SUM(CASE WHEN @cq01Config = 'DR' then (ͳ����-�����������) ELSE ͳ���� end) ͳ����,  
       SUM(�˻�֧��) �˻�֧��,SUM(�˻����ý��) �˻����ý��,
       SUM(���������) ���������,SUM(����Ա����+��ʷ���߹���Ա����+��������) ����Ա��� ,SUM(�����������) �����������,
       SUM(��������֧��) ��������֧��,SUM(�����˻�֧��) �����˻�֧��,
       SUM(���˻���֧��) ���˻���֧��,SUM(�����˻�֧��) �����˻�֧�� 
FROM #HisZyJemx a LEFT JOIN #YY_CQYB_YBSJZD b ON a.ҽ����� = b.code
                  LEFT JOIN #YY_CQYB_SYLB c ON a.������� = c.code
GROUP BY b.code,b.name,c.name  ORDER BY b.code

INSERT INTO #reslutHj
SELECT '�ϼ�' ���, ''ҽ�����,'' �������,  SUM(ͳ����) ͳ����,  SUM(�˻�֧��) �˻�֧��,SUM(�˻����ý��) �˻����ý��,
       SUM(���������) ���������,SUM(����Ա���) ����Ա��� ,SUM(�����������) �����������
       ,SUM(��������֧��) ��������֧��,SUM(�����˻�֧��) �����˻�֧��
       ,SUM(���˻���֧��) ���˻���֧��,SUM(�����˻�֧��) �����˻�֧�� 
FROM 
(
	SELECT '����' ��� ,SUM(ͳ����) ͳ����,  SUM(�˻�֧��) �˻�֧��,SUM(�˻����ý��) �˻����ý��,
       SUM(���������) ���������,SUM(����Ա���) ����Ա���,SUM(�����������) ����������� 
       ,SUM(��������֧��) ��������֧��,SUM(�����˻�֧��) �����˻�֧��
       ,SUM(���˻���֧��) ���˻���֧��,SUM(�����˻�֧��) �����˻�֧�� 
	FROM #reslutMz
	UNION ALL
	SELECT 'סԺ' ���, SUM(ͳ����) ͳ����,  SUM(�˻�֧��) �˻�֧��,SUM(�˻����ý��) �˻����ý��,
       SUM(���������) ���������,SUM(����Ա���) ����Ա���,SUM(�����������) ����������� 
       ,SUM(��������֧��) ��������֧��,SUM(�����˻�֧��) �����˻�֧��
       ,SUM(���˻���֧��) ���˻���֧��,SUM(�����˻�֧��) �����˻�֧�� 
    FROM #reslutZy 
) aa

--���, ҽ�����,�������, ͳ����, �˻�֧��, �˻����ý��,���������, ����Ա��� , 
--����������� , ��������֧��, �����˻�֧�� , ���˻���֧��, �����˻�֧��

IF @type = '1'  --ְ��
BEGIN
    SELECT ���, ҽ�����, ͳ����, �˻�֧��, �˻����ý��,���������, ����Ա��� , 
	       ����������� , ��������֧��, �����˻�֧�� , ���˻���֧��, �����˻�֧��  
    FROM #reslutMz
	UNION ALL
	SELECT '--����С��' ���, '' ҽ�����, SUM(ͳ����), SUM(�˻�֧��), SUM(�˻����ý��),SUM(���������), SUM(����Ա���), 
	       SUM(�����������) , SUM(��������֧��), SUM(�����˻�֧��), SUM(���˻���֧��), SUM(�����˻�֧��)  
    FROM #reslutMz
	UNION ALL
	SELECT ���, ҽ�����, ͳ����, �˻�֧��, �˻����ý��,���������, ����Ա��� , 
	       ����������� , ��������֧��, �����˻�֧�� , ���˻���֧��, �����˻�֧�� 
    FROM #reslutZy
	UNION ALL
	SELECT '--סԺС��' ���, '' ҽ�����, SUM(ͳ����), SUM(�˻�֧��), SUM(�˻����ý��),SUM(���������), SUM(����Ա���), 
	       SUM(�����������) , SUM(��������֧��), SUM(�����˻�֧��), SUM(���˻���֧��), SUM(�����˻�֧��)  
    FROM #reslutZy
	UNION ALL
	SELECT ���, ҽ�����, ͳ����, �˻�֧��, �˻����ý��,���������, ����Ա��� , 
	       ����������� , ��������֧��, �����˻�֧�� , ���˻���֧��, �����˻�֧�� 
    FROM #reslutHj
END
ELSE

IF @type = '4'  --����
BEGIN
    SELECT ���, ҽ�����,�������, ͳ����, �˻�֧��,���������, ����Ա��� ,��������֧��, �����˻�֧��   
	FROM #reslutMz
	UNION ALL
	SELECT ���, ҽ�����, �������,ͳ����, �˻�֧��,���������, ����Ա��� ,��������֧��, �����˻�֧��   
	FROM #reslutZy
	UNION ALL
	SELECT ���, ҽ�����,�������,ͳ����, �˻�֧�� ,���������, ����Ա��� ,��������֧��, �����˻�֧��  
	FROM #reslutHj
END
else
BEGIN
    SELECT ���, ҽ�����, ͳ����, �˻�֧��,���������, ����Ա��� , 
	       ����������� , ��������֧��, �����˻�֧�� , ���˻���֧��, �����˻�֧��  
    FROM #reslutMz
	UNION ALL
	SELECT '--����С��' ���, '' ҽ�����, SUM(ͳ����), SUM(�˻�֧��),SUM(���������), SUM(����Ա���), 
	       SUM(�����������) , SUM(��������֧��), SUM(�����˻�֧��), SUM(���˻���֧��), SUM(�����˻�֧��)  
    FROM #reslutMz
	UNION ALL
	SELECT ���, ҽ�����, ͳ����, �˻�֧��,���������, ����Ա��� , 
	       ����������� , ��������֧��, �����˻�֧�� , ���˻���֧��, �����˻�֧�� 
    FROM #reslutZy
	UNION ALL
	SELECT '--סԺС��' ���, '' ҽ�����, SUM(ͳ����), SUM(�˻�֧��),SUM(���������), SUM(����Ա���), 
	       SUM(�����������) , SUM(��������֧��), SUM(�����˻�֧��), SUM(���˻���֧��), SUM(�����˻�֧��)  
    FROM #reslutZy
	UNION ALL
	SELECT ���, ҽ�����, ͳ����, �˻�֧��, ���������, ����Ա��� , 
	       ����������� , ��������֧��, �����˻�֧�� , ���˻���֧��, �����˻�֧�� 
    FROM #reslutHj
END

return
go