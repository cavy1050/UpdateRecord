ALTER PROC usp_yb_ty_ybzfxx    
@ksrq ut_rq8,        
@jsrq ut_rq8    
AS    
    
--add by yangdi 2019.12.7 医保接口升级，兼容新接口.    
    
SET NOCOUNT ON    
    
CREATE TABLE #YB_BRLIST    
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
 CONSTRAINT PK_YB_BRLIST PRIMARY KEY  CLUSTERED(syxh,jsxh) WITH (IGNORE_DUP_KEY = OFF)        
)    
    
INSERT INTO #YB_BRLIST (syxh,jsxh,blh,hzxm,sex,sfzh,ksdm,jzsj,jsczyh,sybkh,sybzyh,cblb,xzlb,zje)    
SELECT a.syxh,b.xh,a.blh,a.hzxm,a.sex,a.sfzh,a.ksdm,dbo.ufnConvertDateString(b.jsrq,'DT') jzsj,b.jsczyh,a.sybkh,a.sybzyh,b.ybcblb,b.ybxzbz,b.zje    
FROM dbo.ZY_BRSYK a (NOLOCK)    
 INNER JOIN dbo.ZY_BRJSK b (NOLOCK) ON a.syxh=b.syxh    
WHERE a.brzt not in (8,9)     
and b.ybjszt=2     
and b.jsrq between @ksrq and @jsrq+'24'    
AND b.ybdm<>'101'    
    
UPDATE a SET a.ksmc=b.name     
FROM #YB_BRLIST a    
 INNER JOIN dbo.YY_KSBMK b ON a.ksdm=b.id    
    
UPDATE a SET a.sybkh=b.sbkh,a.sybzyh=b.jzlsh,a.cblb=b.cblb,a.xzlb=b.xzlb    
FROM #YB_BRLIST a    
 INNER JOIN dbo.YY_CQYB_ZYJZJLK b ON a.syxh=b.syxh    
WHERE b.jlzt IN (1,2)    
    
WITH YB_ZFXX (jsxh,xjzf,zfzf,tczf,gwybz,delp,ybsr,mzjz,syjjzf,syxjzf,zfdy,ydbxje)    
AS    
(    
SELECT a.jsxh,    
   sum(case when b.lx='04' then b.je else 0 end) xjzf,        
            sum(case when b.lx IN ('02','32') then b.je else 0 end) zfzf,    
   SUM(case when b.lx='01' then b.je else 0 END)-SUM(CASE WHEN a.cblb=2 THEN case when b.lx='09' then b.je else 0 end ELSE 0 END) tczf,      
            sum(case when b.lx='03' then b.je else 0 end) gwybz,        
            sum(case when b.lx='05' then b.je else 0 end) delp,        
            sum(case when b.lx='99' then b.je else 0 end) ybsr,      
   sum(case when b.lx='09' then b.je else 0 end) mzjz,     
      sum(case when b.lx='25' AND b.mc='生育基金支付' then b.je else 0 end) syjjzf,      
      sum(case when b.lx='26' then b.je else 0 end) syxjzf,    
      sum(case when b.lx='24' then b.je else 0 end) zfdy,    
   sum(case when b.lx='GN48' then b.je else 0 end) ydbxje     
FROM #YB_BRLIST a    
 INNER JOIN dbo.ZY_BRJSJEK b (nolock) ON a.jsxh=b.jsxh    
GROUP BY a.jsxh    
HAVING (sum(case when b.lx='04' then b.je else 0 end)+    
         sum(case when b.lx IN ('02','32') then b.je else 0 end)+    
          SUM(case when b.lx='01' then b.je else 0 END)-SUM(CASE WHEN a.cblb=2 THEN case when b.lx='09' then b.je else 0 end ELSE 0 END)+    
     sum(case when b.lx='03' then b.je else 0 end)+    
      sum(case when b.lx='05' then b.je else 0 end)+  
	   sum(case when b.lx='09' then b.je else 0 end)+  
        sum(case when b.lx='25' AND b.mc='生育基金支付' then b.je else 0 end)+    
         sum(case when b.lx='26' then b.je else 0 end)+
		  sum(case when b.lx='24' then b.je else 0 end)+
		   sum(case when b.lx='GN48' then b.je else 0 end)<>0)    
UNION ALL    
SELECT a.jsxh,    
   sum(case when b.lx='yb04' then b.je else 0 end) xjzf,        
            sum(case when b.lx IN ('yb02','yb31') then b.je else 0 end) zfzf,    
   SUM(case when b.lx='yb01' then b.je else 0 END)-SUM(CASE WHEN a.cblb=2 THEN case when b.lx='yb09' then b.je else 0 end ELSE 0 END) tczf,        
            sum(case when b.lx='yb03' then b.je else 0 end) gwybz,        
            sum(case when b.lx='yb05' then b.je else 0 end) delp,        
            sum(case when b.lx='yb98' then b.je else 0 end) ybsr,      
   sum(case when b.lx='yb09' then b.je else 0 end) mzjz,     
      sum(case when b.lx='yb24' then b.je else 0 end) syjjzf,      
      sum(case when b.lx='yb25' then b.je else 0 end) syxjzf,    
      sum(case when b.lx='yb99' then b.je else 0 end) zfdy,    
   sum(case when b.lx='GN48' then b.je else 0 end) ydbxje     
FROM #YB_BRLIST a    
 INNER JOIN dbo.ZY_BRJSJEK b (nolock) ON a.jsxh=b.jsxh    
GROUP BY a.jsxh    
HAVING (sum(case when b.lx='yb04' then b.je else 0 end)+    
         sum(case when b.lx IN ('yb02','yb31') then b.je else 0 end)+    
          SUM(case when b.lx='yb01' then b.je else 0 END)-SUM(CASE WHEN a.cblb=2 THEN case when b.lx='yb09' then b.je else 0 end ELSE 0 END)+    
     sum(case when b.lx='yb03' then b.je else 0 end)+    
      sum(case when b.lx='yb05' then b.je else 0 end)+    
       sum(case when b.lx='yb24' then b.je else 0 end)+    
        sum(case when b.lx='yb25' then b.je else 0 end)<>0)    
)      
    
UPDATE a SET a.xjzf=b.xjzf,    
    a.zfzf=b.zfzf,    
    a.tczf=b.tczf,    
    a.gwybz=b.gwybz,    
    a.delp=b.delp,    
    a.ybsr=b.ybsr,    
    a.mzjz=b.mzjz,    
    a.syjjzf=b.syjjzf,    
    a.syxjzf=b.syxjzf,    
    a.zfdy=b.zfdy,    
    a.ydbxje=b.ydbxje    
FROM #YB_BRLIST a    
 INNER JOIN YB_ZFXX b ON a.jsxh=b.jsxh    

SELECT * FROM  #YB_BRLIST
    
RETURN 


