ALTER PROC usp_yb_tybb_ybzfxx    
@ksrq ut_rq8,        
@jsrq ut_rq8    
AS    
    
--add by yangdi 2019.12.7 医保接口升级，兼容新接口.    
    
SET NOCOUNT ON    
    
CREATE TABLE #YB_YBZFXX     
(    
 syxh   ut_xh12 NOT NULL,    
 jsxh   ut_xh12 NOT NULL,    
 blh    ut_blh,    
 hzxm   ut_mc64,    
 sex    ut_sex,    
 ksdm   ut_ksdm,    
 ksmc   ut_mc64,    
 jzsj   VARCHAR(19),    
 sfzh   ut_sfzh,    
 jsczyh ut_czyh,    
 sybkh  VARCHAR(20),    
 sybzyh VARCHAR(20),    
 cblb   ut_bz,    
 xzlb   ut_bz,    
 zje    numeric(9,2) DEFAULT 0,    
 xjzf   numeric(9,2) DEFAULT 0,    
 zfzf   numeric(9,2) DEFAULT 0,    
 tczf   numeric(9,2) DEFAULT 0,    
 gwybz  numeric(9,2) DEFAULT 0,    
 delp   numeric(9,2) DEFAULT 0,    
 ybsr   numeric(9,2) DEFAULT 0,    
 mzjz   numeric(9,2) DEFAULT 0,    
 syjjzf numeric(9,2) DEFAULT 0,    
 syxjzf numeric(9,2) DEFAULT 0,    
 zfdy   numeric(9,2) DEFAULT 0,    
 ydbxje numeric(9,2) DEFAULT 0,
)    

INSERT INTO #YB_YBZFXX 
EXEC usp_yb_ty_ybzfxx  @ksrq, @jsrq

SELECT syxh '首页序号',jsxh '结算序号',sybzyh '医保住院号',    
  blh '住院号',hzxm '姓名',sex '性别',sfzh '身份证号',ksmc '科室名称',    
   jzsj '结算时间',jsczyh '结算操作员',    
       CASE WHEN cblb=1 THEN '职工' WHEN cblb=2 THEN '居民' WHEN cblb=3 THEN '离休' END '参保类别',    
     zje '总金额',    
     xjzf '现金支付',zfzf '账户支付',tczf '统筹支付',delp '大额理赔金额',gwybz '公务员补助',    
      mzjz '民政救助',ybsr '医保舍入',      
             syjjzf '生育基金支付',zfdy '账户抵用',ydbxje '异地报销总额'    
FROM #YB_YBZFXX    
    
RETURN 

