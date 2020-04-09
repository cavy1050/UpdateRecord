if exists(select 1 from sysobjects where name = 'usp_cqyb_queryhisjsje')
  drop proc usp_cqyb_queryhisjsje
go
Create proc usp_cqyb_queryhisjsje
(
	@kssj		varchar(16),   
	@jssj		varchar(16),    
	@type	    VARCHAR(10), --1 职工 ,  2 居民 , 3 离休 ,  5 工伤 ,  4 生育 ,   6 异地职工 ,  7 异地居民
	@ddyljgbm	varchar(10) --医院医保代码  yy_jbconfig.yydm
)   
as 
/****************************************
[版本号]4.0.0.0.0
[创建时间]2018.05.02
[作者]qfj
[版权]Copyright ? 1998-2017卫宁健康科技集团股份有限公司
[描述]HIS医保对账汇总
[功能说明]
	HIS医保对账汇总
[参数说明]
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]

	exec usp_cqyb_queryhisjsje '2018070100:00:00','2018073123:59:59','1','10017'
   
[修改记录] 
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

IF EXISTS (SELECT 1 FROM YY_JBCONFIG (NOLOCK) WHERE yydm IN ('10017'))  --附一  --由于各院老接口不一样 ,这里是处理作废老数据兼容
BEGIN
	SELECT @strtc = '02',@strzhzf= '01',@strgwy = '03',@strgwyfh = '10' ,@strde = '05' ,@strmzjz = '14' ,
		   @strsyjj = '42' ,@strsyzh = '50' ,@strgsjj = '' ,@strgszh = '' ,@strzhdy = '24' ,@strqtbz = ''
	SELECT @strtc_zy = '02',@strzhzf_zy= '01',@strgwy_zy = '03',@strgwyfh_zy = '10' ,@strde_zy = '05' ,@strmzjz_zy = '14' ,
		   @strsyjj_zy = '42' ,@strsyzh_zy = '50' ,@strgsjj_zy = '44' ,@strgszh_zy = '51' ,@strzhdy_zy = '48',@strqtbz_zy = '49' 
END
ELSE IF EXISTS (SELECT 1 FROM YY_JBCONFIG WHERE yydm IN ('10018'))  --附二
BEGIN
	SELECT @strtc = '02',@strzhzf= '01',@strgwy = '03',@strgwyfh = '10' ,@strde = '05' ,@strmzjz = '14' ,
		   @strsyjj = '42' ,@strsyzh = '' ,@strgsjj = '44' ,@strgszh = '' ,@strzhdy = '46' ,@strqtbz = ''
	SELECT @strtc_zy = '02',@strzhzf_zy= '01',@strgwy_zy = '03',@strgwyfh_zy = '10' ,@strde_zy = '05' ,@strmzjz_zy = '14' ,
		   @strsyjj_zy = '42' ,@strsyzh_zy = '' ,@strgsjj_zy = '44' ,@strgszh_zy = '' ,@strzhdy_zy = '46' ,@strqtbz_zy = ''
END
ELSE  --其他医院老接口
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
    SELECT 'F','CQ18参数配置不正确！' +@cq18Config
    RETURN
END

SELECT @cq01Config = a.config FROM YY_CONFIG a(NOLOCK) WHERE a.id = 'CQ01'

CREATE TABLE #templateTable
(
	类别			VARCHAR(30)		NULL,
	医疗类别		VARCHAR(50)		NULL,
	生育类别		VARCHAR(50)		NULL,  
	统筹金额		NUMERIC(12,2)		NULL,  
	账户支付		NUMERIC(12,2)		NULL,
	账户抵用金额	NUMERIC(12,2)		NULL,
	大额理赔金额	NUMERIC(12,2)		NULL,
	公务员金额		NUMERIC(12,2)		NULL,
	民政救助金额	NUMERIC(12,2)		NULL,
	生育基金支付	NUMERIC(12,2)		NULL,
	生育账户支付	NUMERIC(12,2)		NULL,
	工伤基金支付	NUMERIC(12,2)		NULL,
	工伤账户支付	NUMERIC(12,2)		NULL
)
--准备临时表
SELECT * into #reslutMz FROM #templateTable
SELECT * into #reslutZy FROM #templateTable
SELECT * into #reslutHj FROM #templateTable
SELECT * into #reslutMzDy FROM #templateTable   --非职工抵用门诊合计
SELECT * into #reslutZyDy FROM #templateTable   --非职工抵用住院合计

--门诊数据准备
SELECT * INTO #HisMzJsmx FROM 
(
	SELECT a.jssjh 收据号,a.zxlsh 中心流水号,a.xzlb 险种类别,jzjl.cblb 参保类别, 
		CASE jzjl.cblb WHEN '2' THEN jzjl.jmyllb ELSE jzjl.zgyllb END 医疗类别, 
		b.sfrq 收费日期, b.czyh 操作员,b.hzxm 姓名,b.blh 病历号,jzjl.sbkh 社保卡号, 
		CASE b.jlzt WHEN 0 THEN '正常' WHEN 1 THEN '退费' WHEN 2 THEN '红冲' end 记录状态,(CASE WHEN a.xzlb<> 3 THEN '' else a.sylb END ) 生育类别
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
	SELECT b.sjh 收据号,a.czlsh 中心流水号,a.xzlb 险种类别,jzjl.cblb 参保类别, 
		CASE jzjl.cblb WHEN '2' THEN jzjl.jmyllb ELSE jzjl.zgyllb END 医疗类别, 
		b.sfrq 收费日期, b.czyh 操作员,b.hzxm 姓名,b.blh 病历号,jzjl.sbkh 社保卡号, 
		CASE b.jlzt WHEN 0 THEN '正常' WHEN 1 THEN '退费' WHEN 2 THEN '红冲' end 记录状态 ,(CASE WHEN a.xzlb<> 3 THEN '' else a.sylb END) 生育类别 
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
       SUM(CASE WHEN b.lx IN('yb01',@strtc) THEN b.je ELSE 0 END) 统筹金额,
       SUM(CASE WHEN b.lx IN('yb02',@strzhzf) THEN b.je ELSE 0 END) 账户支付,
       SUM(CASE WHEN b.lx IN('yb03',@strgwy) THEN b.je ELSE 0 END) 公务员补助,
       SUM(CASE WHEN b.lx IN('yb06',@strgwyfh) THEN b.je ELSE 0 END) 历史起付线公务员返还,
       SUM(CASE WHEN b.lx IN('yb05',@strde) THEN b.je ELSE 0 END) 大额理赔金额,
       SUM(CASE WHEN b.lx IN('yb09',@strmzjz) THEN b.je ELSE 0 END) 民政救助金额,
       SUM(CASE WHEN b.lx IN('yb24',@strsyjj) THEN b.je ELSE 0 END) 生育基金支付,
       SUM(CASE WHEN b.lx IN('yb31',@strsyzh) THEN b.je ELSE 0 END) 生育账户支付,
       SUM(CASE WHEN b.lx IN('yb26',@strgsjj) THEN b.je ELSE 0 END) 工伤基金支付,
       SUM(CASE WHEN b.lx IN('yb32',@strgszh) THEN b.je ELSE 0 END) 工伤账户支付,
	   SUM(CASE WHEN b.lx IN('yb30',@strqtbz) THEN b.je ELSE 0 END) 其他补助,
       SUM(CASE WHEN b.lx IN('yb99',@strzhdy) THEN b.je ELSE 0 END) 账户抵用金额
INTO #HisMzJemx
FROM #HisMzJsmx a,VW_MZJEMXK b(NOLOCK) WHERE a.收据号 = b.jssjh 
GROUP BY 收据号 , 中心流水号, 险种类别, 参保类别,医疗类别,收费日期,操作员,姓名,病历号,社保卡号,记录状态 ,生育类别

--住院数据准备
SELECT * INTO #HisZyJsmx FROM
( 
    SELECT CONVERT(VARCHAR(20),b.xh) 收据号,a.zxlsh 中心流水号,a.xzlb 险种类别,jzjl.cblb 参保类别,  
		CASE jzjl.cblb WHEN '2' THEN jzjl.jmyllb ELSE jzjl.zgyllb END 医疗类别, 
		b.jsrq 收费日期, b.jsczyh 操作员,b.hzxm 姓名,b.blh 病历号,jzjl.sbkh 社保卡号,
		CASE b.jlzt WHEN 0 THEN '正常' WHEN 1 THEN '红冲' WHEN 2 THEN '被红冲' end 记录状态 ,(CASE WHEN a.xzlb<> 3 THEN '' else a.sylb END) 生育类别
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
	SELECT CONVERT(VARCHAR(20),b.xh) 收据号,a.czlsh 中心流水号,a.xzlb 险种类别,jzjl.cblb 参保类别, 
		CASE jzjl.cblb WHEN '2' THEN jzjl.jmyllb ELSE jzjl.zgyllb END 医疗类别 , 
		b.jsrq 收费日期, b.jsczyh 操作员,b.hzxm 姓名,b.blh 病历号,jzjl.sbkh 社保卡号, 
		CASE b.jlzt WHEN 0 THEN '正常' WHEN 1 THEN '红冲' WHEN 2 THEN '被红冲' end 记录状态 ,(CASE WHEN a.xzlb<> 3 THEN '' else a.sylb END) 生育类别
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
       SUM(CASE WHEN b.lx IN('yb01',@strtc_zy) THEN b.je ELSE 0 END) 统筹金额,
       SUM(CASE WHEN b.lx IN('yb02',@strzhzf_zy) THEN b.je ELSE 0 END) 账户支付,
       SUM(CASE WHEN b.lx IN('yb03',@strgwy_zy) THEN b.je ELSE 0 END) 公务员补助,
       SUM(CASE WHEN b.lx IN('yb06',@strgwyfh_zy) THEN b.je ELSE 0 END) 历史起付线公务员返还,
       SUM(CASE WHEN b.lx IN('yb05',@strde_zy) THEN b.je ELSE 0 END) 大额理赔金额,
       SUM(CASE WHEN b.lx IN('yb09',@strmzjz_zy) THEN b.je ELSE 0 END) 民政救助金额,
       SUM(CASE WHEN b.lx IN('yb24',@strsyjj_zy) THEN b.je ELSE 0 END) 生育基金支付,
       SUM(CASE WHEN b.lx IN('yb31',@strsyzh_zy) THEN b.je ELSE 0 END) 生育账户支付,
       SUM(CASE WHEN b.lx IN('yb26',@strgsjj_zy) THEN b.je ELSE 0 END) 工伤基金支付,
       SUM(CASE WHEN b.lx IN('yb32',@strgszh_zy) THEN b.je ELSE 0 END) 工伤账户支付,
	   SUM(CASE WHEN b.lx IN('yb30',@strqtbz_zy) THEN b.je ELSE 0 END) 其他补助,
       SUM(CASE WHEN b.lx IN('yb99',@strzhdy_zy) THEN b.je ELSE 0 END) 账户抵用金额
INTO #HisZyJemx
FROM #HisZyJsmx a,ZY_BRJSJEK b(NOLOCK)
WHERE a.收据号 = b.jsxh
GROUP BY 收据号 , 中心流水号, 险种类别, 参保类别,医疗类别,收费日期,操作员,姓名,病历号,社保卡号,记录状态 ,生育类别

--抵用数据准备
IF @type = '1'  --如果是职工对账
BEGIN
    --门诊抵用结算明细
    SELECT * INTO #HisMzDyMx FROM 
	(
		SELECT a.jssjh 收据号,a.zxlsh 中心流水号,a.xzlb 险种类别,jzjl.cblb 参保类别, 
			CASE jzjl.cblb WHEN '2' THEN jzjl.jmyllb ELSE jzjl.zgyllb END 医疗类别, 
			b.sfrq 收费日期, b.czyh 操作员,b.hzxm 姓名,b.blh 病历号,jzjl.sbkh 社保卡号, 
			CASE b.jlzt WHEN 0 THEN '正常' WHEN 1 THEN '退费' WHEN 2 THEN '红冲' end 记录状态,(CASE WHEN a.xzlb<> 3 THEN '' else a.sylb END ) 生育类别
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
		SELECT b.sjh 收据号,a.czlsh 中心流水号,a.xzlb 险种类别,jzjl.cblb 参保类别, 
			CASE jzjl.cblb WHEN '2' THEN jzjl.jmyllb ELSE jzjl.zgyllb END 医疗类别, 
			b.sfrq 收费日期, b.czyh 操作员,b.hzxm 姓名,b.blh 病历号,jzjl.sbkh 社保卡号, 
			CASE b.jlzt WHEN 0 THEN '正常' WHEN 1 THEN '退费' WHEN 2 THEN '红冲' end 记录状态 ,a.sylb 生育类别 
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
	--门诊抵用金额明细
	select a.*,
		   0.00 统筹金额,
		   0.00 账户支付,
		   0.00 公务员补助,
		   0.00 历史起付线公务员返还,
		   0.00 大额理赔金额,
		   0.00 民政救助金额,
		   0.00 生育基金支付,
		   0.00 生育账户支付,
		   0.00 工伤基金支付,
		   0.00 工伤账户支付,
		   0.00 其他补助,
		   SUM(CASE WHEN b.lx IN('yb99',@strzhdy) THEN b.je ELSE 0 END) 账户抵用金额
	INTO #HisMzDyJemx
	FROM #HisMzDyMx a,VW_MZJEMXK b(NOLOCK) WHERE a.收据号 = b.jssjh 
	GROUP BY 收据号 , 中心流水号, 险种类别, 参保类别,医疗类别,收费日期,操作员,姓名,病历号,社保卡号,记录状态 ,生育类别

	--住院抵用结算明细
	SELECT * INTO #HisZyDyMx FROM
	( 
		SELECT CONVERT(VARCHAR(20),b.xh) 收据号,a.zxlsh 中心流水号,a.xzlb 险种类别,jzjl.cblb 参保类别,  
			CASE jzjl.cblb WHEN '2' THEN jzjl.jmyllb ELSE jzjl.zgyllb END 医疗类别, 
			b.jsrq 收费日期, b.jsczyh 操作员,b.hzxm 姓名,b.blh 病历号,jzjl.sbkh 社保卡号,
			CASE b.jlzt WHEN 0 THEN '正常' WHEN 1 THEN '红冲' WHEN 2 THEN '被红冲' end 记录状态 ,(CASE WHEN a.xzlb<> 3 THEN '' else a.sylb END )生育类别
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
		SELECT CONVERT(VARCHAR(20),b.xh) 收据号,a.czlsh 中心流水号,a.xzlb 险种类别,jzjl.cblb 参保类别, 
			CASE jzjl.cblb WHEN '2' THEN jzjl.jmyllb ELSE jzjl.zgyllb END 医疗类别 , 
			b.jsrq 收费日期, b.jsczyh 操作员,b.hzxm 姓名,b.blh 病历号,jzjl.sbkh 社保卡号, 
			CASE b.jlzt WHEN 0 THEN '正常' WHEN 1 THEN '红冲' WHEN 2 THEN '被红冲' end 记录状态 ,a.sylb 生育类别
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
	----住院抵用金额明细
	select a.* ,
		   0.00 统筹金额,
		   0.00 账户支付,
		   0.00 公务员补助,
		   0.00 历史起付线公务员返还,
		   0.00 大额理赔金额,
		   0.00 民政救助金额,
		   0.00 生育基金支付,
		   0.00 生育账户支付,
		   0.00 工伤基金支付,
		   0.00 工伤账户支付,
		   0.00 其他补助,
		   SUM(CASE WHEN b.lx IN('yb99',@strzhdy_zy) THEN b.je ELSE 0 END) 账户抵用金额
	INTO #HisZyDyJemx
	FROM #HisZyDyMx a,ZY_BRJSJEK b(NOLOCK)
	WHERE a.收据号 = b.jsxh
	GROUP BY 收据号 , 中心流水号, 险种类别, 参保类别,医疗类别,收费日期,操作员,姓名,病历号,社保卡号,记录状态 ,生育类别

	--SELECT * FROM #HisMzDyJemx
	--SELECT * FROM #HisZyDyJemx

	INSERT INTO #reslutMzDy   --非职工抵用门诊合计
	SELECT '门诊抵用' 类别 ,'' 医疗类别 ,'' 生育类别, SUM(统筹金额-民政救助金额) 统筹金额,  SUM(账户支付) 账户支付,SUM(账户抵用金额) 账户抵用金额,
		   SUM(大额理赔金额) 大额理赔金额,SUM(公务员补助+历史起付线公务员返还+其他补助) 公务员金额 ,SUM(民政救助金额) 民政救助金额
		   ,SUM(生育基金支付) 生育基金支付,SUM(生育账户支付) 生育账户支付
		   ,SUM(工伤基金支付) 工伤基金支付,SUM(工伤账户支付) 工伤账户支付
	FROM #HisMzDyJemx a
	INSERT INTO #reslutMzDy   --非职工抵用住院合计
	SELECT '住院抵用' 类别, '' 医疗类别 ,'' 生育类别 , SUM(统筹金额-民政救助金额) 统筹金额,  SUM(账户支付) 账户支付,SUM(账户抵用金额) 账户抵用金额,
		   SUM(大额理赔金额) 大额理赔金额,SUM(公务员补助+历史起付线公务员返还+其他补助) 公务员金额 ,SUM(民政救助金额) 民政救助金额
		   ,SUM(生育基金支付) 生育基金支付,SUM(生育账户支付) 生育账户支付
		   ,SUM(工伤基金支付) 工伤基金支付,SUM(工伤账户支付) 工伤账户支付 
	FROM #HisZyDyJemx a
	
	--SELECT * FROM #reslutMzDy
	--SELECT * FROM #reslutZyDy 

	INSERT INTO  #reslutMz SELECT * FROM #reslutMzDy
	INSERT INTO  #reslutMz SELECT * FROM #reslutZyDy 
END 

--合计
INSERT INTO #reslutMz
SELECT '门诊' 类别 ,b.code + b.name 医疗类别 ,c.name 生育类别, 
       SUM(CASE WHEN @cq01Config = 'DR' then (统筹金额-民政救助金额) ELSE 统筹金额 end) 统筹金额,
       SUM(账户支付) 账户支付,SUM(账户抵用金额) 账户抵用金额,
       SUM(大额理赔金额) 大额理赔金额,SUM(公务员补助+历史起付线公务员返还+其他补助) 公务员金额 ,SUM(民政救助金额) 民政救助金额,
       SUM(生育基金支付) 生育基金支付,SUM(生育账户支付) 生育账户支付,
       SUM(工伤基金支付) 工伤基金支付,SUM(工伤账户支付) 工伤账户支付 
FROM #HisMzJemx a LEFT JOIN #YY_CQYB_YBSJZD b ON a.医疗类别 = b.code
                  LEFT JOIN #YY_CQYB_SYLB c ON a.生育类别 = c.code
GROUP BY b.code,b.name,c.name  ORDER BY b.code

INSERT INTO #reslutZy
SELECT '住院' 类别,b.code + b.name 医疗类别 ,c.name 生育类别 , 
       SUM(CASE WHEN @cq01Config = 'DR' then (统筹金额-民政救助金额) ELSE 统筹金额 end) 统筹金额,  
       SUM(账户支付) 账户支付,SUM(账户抵用金额) 账户抵用金额,
       SUM(大额理赔金额) 大额理赔金额,SUM(公务员补助+历史起付线公务员返还+其他补助) 公务员金额 ,SUM(民政救助金额) 民政救助金额,
       SUM(生育基金支付) 生育基金支付,SUM(生育账户支付) 生育账户支付,
       SUM(工伤基金支付) 工伤基金支付,SUM(工伤账户支付) 工伤账户支付 
FROM #HisZyJemx a LEFT JOIN #YY_CQYB_YBSJZD b ON a.医疗类别 = b.code
                  LEFT JOIN #YY_CQYB_SYLB c ON a.生育类别 = c.code
GROUP BY b.code,b.name,c.name  ORDER BY b.code

INSERT INTO #reslutHj
SELECT '合计' 类别, ''医疗类别,'' 生育类别,  SUM(统筹金额) 统筹金额,  SUM(账户支付) 账户支付,SUM(账户抵用金额) 账户抵用金额,
       SUM(大额理赔金额) 大额理赔金额,SUM(公务员金额) 公务员金额 ,SUM(民政救助金额) 民政救助金额
       ,SUM(生育基金支付) 生育基金支付,SUM(生育账户支付) 生育账户支付
       ,SUM(工伤基金支付) 工伤基金支付,SUM(工伤账户支付) 工伤账户支付 
FROM 
(
	SELECT '门诊' 类别 ,SUM(统筹金额) 统筹金额,  SUM(账户支付) 账户支付,SUM(账户抵用金额) 账户抵用金额,
       SUM(大额理赔金额) 大额理赔金额,SUM(公务员金额) 公务员金额,SUM(民政救助金额) 民政救助金额 
       ,SUM(生育基金支付) 生育基金支付,SUM(生育账户支付) 生育账户支付
       ,SUM(工伤基金支付) 工伤基金支付,SUM(工伤账户支付) 工伤账户支付 
	FROM #reslutMz
	UNION ALL
	SELECT '住院' 类别, SUM(统筹金额) 统筹金额,  SUM(账户支付) 账户支付,SUM(账户抵用金额) 账户抵用金额,
       SUM(大额理赔金额) 大额理赔金额,SUM(公务员金额) 公务员金额,SUM(民政救助金额) 民政救助金额 
       ,SUM(生育基金支付) 生育基金支付,SUM(生育账户支付) 生育账户支付
       ,SUM(工伤基金支付) 工伤基金支付,SUM(工伤账户支付) 工伤账户支付 
    FROM #reslutZy 
) aa

--类别, 医疗类别,生育类别, 统筹金额, 账户支付, 账户抵用金额,大额理赔金额, 公务员金额 , 
--民政救助金额 , 生育基金支付, 生育账户支付 , 工伤基金支付, 工伤账户支付

IF @type = '1'  --职工
BEGIN
    SELECT 类别, 医疗类别, 统筹金额, 账户支付, 账户抵用金额,大额理赔金额, 公务员金额 , 
	       民政救助金额 , 生育基金支付, 生育账户支付 , 工伤基金支付, 工伤账户支付  
    FROM #reslutMz
	UNION ALL
	SELECT '--门诊小计' 类别, '' 医疗类别, SUM(统筹金额), SUM(账户支付), SUM(账户抵用金额),SUM(大额理赔金额), SUM(公务员金额), 
	       SUM(民政救助金额) , SUM(生育基金支付), SUM(生育账户支付), SUM(工伤基金支付), SUM(工伤账户支付)  
    FROM #reslutMz
	UNION ALL
	SELECT 类别, 医疗类别, 统筹金额, 账户支付, 账户抵用金额,大额理赔金额, 公务员金额 , 
	       民政救助金额 , 生育基金支付, 生育账户支付 , 工伤基金支付, 工伤账户支付 
    FROM #reslutZy
	UNION ALL
	SELECT '--住院小计' 类别, '' 医疗类别, SUM(统筹金额), SUM(账户支付), SUM(账户抵用金额),SUM(大额理赔金额), SUM(公务员金额), 
	       SUM(民政救助金额) , SUM(生育基金支付), SUM(生育账户支付), SUM(工伤基金支付), SUM(工伤账户支付)  
    FROM #reslutZy
	UNION ALL
	SELECT 类别, 医疗类别, 统筹金额, 账户支付, 账户抵用金额,大额理赔金额, 公务员金额 , 
	       民政救助金额 , 生育基金支付, 生育账户支付 , 工伤基金支付, 工伤账户支付 
    FROM #reslutHj
END
ELSE

IF @type = '4'  --生育
BEGIN
    SELECT 类别, 医疗类别,生育类别, 统筹金额, 账户支付,大额理赔金额, 公务员金额 ,生育基金支付, 生育账户支付   
	FROM #reslutMz
	UNION ALL
	SELECT 类别, 医疗类别, 生育类别,统筹金额, 账户支付,大额理赔金额, 公务员金额 ,生育基金支付, 生育账户支付   
	FROM #reslutZy
	UNION ALL
	SELECT 类别, 医疗类别,生育类别,统筹金额, 账户支付 ,大额理赔金额, 公务员金额 ,生育基金支付, 生育账户支付  
	FROM #reslutHj
END
else
BEGIN
    SELECT 类别, 医疗类别, 统筹金额, 账户支付,大额理赔金额, 公务员金额 , 
	       民政救助金额 , 生育基金支付, 生育账户支付 , 工伤基金支付, 工伤账户支付  
    FROM #reslutMz
	UNION ALL
	SELECT '--门诊小计' 类别, '' 医疗类别, SUM(统筹金额), SUM(账户支付),SUM(大额理赔金额), SUM(公务员金额), 
	       SUM(民政救助金额) , SUM(生育基金支付), SUM(生育账户支付), SUM(工伤基金支付), SUM(工伤账户支付)  
    FROM #reslutMz
	UNION ALL
	SELECT 类别, 医疗类别, 统筹金额, 账户支付,大额理赔金额, 公务员金额 , 
	       民政救助金额 , 生育基金支付, 生育账户支付 , 工伤基金支付, 工伤账户支付 
    FROM #reslutZy
	UNION ALL
	SELECT '--住院小计' 类别, '' 医疗类别, SUM(统筹金额), SUM(账户支付),SUM(大额理赔金额), SUM(公务员金额), 
	       SUM(民政救助金额) , SUM(生育基金支付), SUM(生育账户支付), SUM(工伤基金支付), SUM(工伤账户支付)  
    FROM #reslutZy
	UNION ALL
	SELECT 类别, 医疗类别, 统筹金额, 账户支付, 大额理赔金额, 公务员金额 , 
	       民政救助金额 , 生育基金支付, 生育账户支付 , 工伤基金支付, 工伤账户支付 
    FROM #reslutHj
END

return
go