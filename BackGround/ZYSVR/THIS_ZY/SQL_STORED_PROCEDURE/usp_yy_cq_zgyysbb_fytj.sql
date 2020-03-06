ALTER proc usp_yy_cq_zgyysbb_fytj
@ksrq ut_rq8,  
@jsrq ut_rq8,
@yydm ut_dm5    
as  
  
/****************************  
  
  
exec usp_yy_cq_zgyysbb_zwb '20150201','20150228'  
exec usp_yy_cq_zgyysbb_fytj '20161201','20161220','02'  
报表说明：重庆市职工医保结算申报表  
    报表数据从下载的医保数据出，为保证医保数据与本地数据一致。  
--add by yangdi 2018.3.8 增加区级公务员补助金额处理。
****************************/  
  
set nocount on  

DECLARE @yydm_yb ut_dm12,@yymc ut_mc64
SELECT @yydm_yb=yydm,@yymc=name FROM YY_JBCONFIG (NOLOCK) WHERE id=@yydm
  
declare @tcjjzfbl numeric(9,1),     --统筹基金实际支付比例  
  @yyzje    numeric(14,2),    --本地医保总额  
  @ybzje    numeric(14,2)     --医保总额  
set @tcjjzfbl=1  
  
--在出入院管理--市医保对账（重庆）下载医保结算明细后生成申报表  
if not exists (select 1 from VW_SYB_JSMX (nolock)   
 where JSRQ between @ksrq and @jsrq+'24'  
 and CBLB=1)  
begin  
 select 'F','请先下载医保数据再查询！'  
 return  
end
  
---账户抵用金额 zwb 2015-3-4  
/*  
  
账户抵用的金额全部计算到职工医保病人头上  
  
*/  
declare @dyje_pb    numeric(14,2), ---抵用金额普病  
        @dyje_tb    numeric(14,2), ---抵用金额特病  
        @dyje_zy    numeric(14,2)  
          
select @dyje_pb=0, @dyje_tb=0,@dyje_zy=0  
  
--门诊普通门诊账户抵用金额  
select @dyje_pb=SUM(c.je) FROM MZSVR.THIS_MZ.dbo.YY_CQYB_MZJZJLK a (NOLOCK)
	INNER JOIN MZSVR.THIS_MZ.dbo.VW_MZBRJSK b (NOLOCK) ON a.jssjh=b.sjh
	INNER JOIN MZSVR.THIS_MZ.dbo.VW_MZJEMXK c (NOLOCK) ON b.sjh=c.jssjh
	INNER JOIN dbo.YY_KSBMK d (NOLOCK) ON b.ksdm=d.id
WHERE b.sfrq BETWEEN @ksrq and @jsrq+'24'
AND b.ybjszt=2
AND c.je<>0
AND c.lx='yb99'
AND d.yydm=@yydm
AND (a.zgyllb='11' OR a.jmyllb='12')          
  
----门诊特病门诊账户抵用金额  
select @dyje_tb=SUM(c.je) FROM MZSVR.THIS_MZ.dbo.YY_CQYB_MZJZJLK a (NOLOCK)
	INNER JOIN MZSVR.THIS_MZ.dbo.VW_MZBRJSK b (NOLOCK) ON a.jssjh=b.sjh
	INNER JOIN MZSVR.THIS_MZ.dbo.VW_MZJEMXK c (NOLOCK) ON b.sjh=c.jssjh
	INNER JOIN dbo.YY_KSBMK d (NOLOCK) ON b.ksdm=d.id
WHERE b.sfrq BETWEEN '20200201' and '20200229'+'24'
AND b.ybjszt=2
AND c.je<>0
AND c.lx='yb99'
AND d.yydm=@yydm
AND NOT (a.zgyllb='11' OR a.jmyllb='12')   
        
--住院普通门诊账户抵用金额  
select @dyje_zy=isnull(sum(b.je),0)  
from ZY_BRJSK a (nolock),ZY_BRJSJEK b (nolock)  
where a.xh=b.jsxh and b.lx='yb99'   
and a.jsrq between @ksrq and @jsrq+'24' and a.ybjszt=2 and b.je<>0 
and a.ksdm in(select id from YY_KSBMK where yydm=@yydm)   
  
---生育统筹不计算在职工统筹支付里面 zwb 2015-03-06  
declare @sytc    numeric(14,2) ---生育统筹支付  

SELECT @sytc=0

CREATE TABLE #SYBRLIST
(
	SYXH ut_xh12,
	JSXH ut_xh12
)

INSERT INTO #SYBRLIST (SYXH,JSXH)
SELECT a.syxh,b.xh FROM dbo.ZY_BRSYK a (NOLOCK)
	INNER JOIN dbo.ZY_BRJSK b (NOLOCK) ON a.syxh=b.syxh
	INNER JOIN dbo.YY_CQYB_ZYJSJLK c (NOLOCK) ON a.syxh=c.syxh AND b.xh=c.jsxh
	INNER JOIN dbo.YY_KSBMK d (NOLOCK) ON a.ksdm=d.id
WHERE b.jsrq BETWEEN @ksrq AND @jsrq+'24'
AND b.ybjszt=2
AND d.yydm=@yydm
AND c.xzlb=3

select @sytc=SUM(b.je) from #SYBRLIST a,ZY_BRJSJEK b      
where a.JSXH=b.jsxh and b.lx='yb24'


--SELECT @sytc=0

    
select @yydm_yb yydm,@yymc yymc,
		substring(@ksrq,1,4)+'年'+substring(@ksrq,5,2)+'月'+substring(@ksrq,7,2)+'日'+'--'      
       +substring(@jsrq,1,4)+'年'+substring(@jsrq,5,2)+'月'+substring(@jsrq,7,2)+'日' fkssq,'统筹基金支付' xm,  
 sum(case when YLLB = '11' then TCZF else 0 end) ptmz ,  
 sum(case when YLLB = '13' then TCZF else 0 end) tbmz,  
 sum(case when YLLB in ('21','22') then TCZF else 0 end)-@sytc zy,  
 sum(case when YLLB in ('11','13','21','22') then TCZF else 0 end)-@sytc zje,  
 (sum(case when YLLB in ('11','13','21','22') then TCZF else 0 end)-@sytc)*@tcjjzfbl zfje  
from VW_SYB_JSMX (nolock)  
where JSRQ between @ksrq and @jsrq+'24'  
 and CBLB=1 and YBDM in(select yydm from YY_JBCONFIG where id=@yydm) 
union all  
select @yydm_yb yydm,@yymc yymc,
       substring(@ksrq,1,4)+'年'+substring(@ksrq,5,2)+'月'+substring(@ksrq,7,2)+'日'+'--'      
       +substring(@jsrq,1,4)+'年'+substring(@jsrq,5,2)+'月'+substring(@jsrq,7,2)+'日' fkssq,'个人帐户支付' xm,  
 sum(case when YLLB = '11' then ZHZF else 0 end)+@dyje_pb ptmz,  
 sum(case when YLLB = '13' then ZHZF else 0 end)+@dyje_tb tbmz,  
 sum(case when YLLB in ('21','22') then ZHZF else 0 end) + @dyje_zy zy,  
 sum(ZHZF)+@dyje_tb+@dyje_pb + @dyje_zy zje,  
 sum(ZHZF)+@dyje_tb+@dyje_pb + @dyje_zy zfje  
from VW_SYB_JSMX (nolock)   
where JSRQ between @ksrq and @jsrq+'24'  
 and CBLB=1  and YBDM in(select yydm from YY_JBCONFIG where id=@yydm) 
union all  
select @yydm_yb yydm,@yymc yymc,
	substring(@ksrq,1,4)+'年'+substring(@ksrq,5,2)+'月'+substring(@ksrq,7,2)+'日'+'--'      
       +substring(@jsrq,1,4)+'年'+substring(@jsrq,5,2)+'月'+substring(@jsrq,7,2)+'日' fkssq,'大额保险支付' xm,  
 sum(case when YLLB = '11' then DELP else 0 end) ptmz,  
 sum(case when YLLB = '13' then DELP else 0 end) tbmz,  
 sum(case when YLLB in ('21','22') then DELP else 0 end) zy,  
 sum(DELP) zje,  
 sum(DELP) zfje  
from VW_SYB_JSMX (nolock)   
where JSRQ between @ksrq and @jsrq+'24'  
 and CBLB=1  and YBDM in(select yydm from YY_JBCONFIG where id=@yydm) 
union ALL
/*
select @yydm_yb yydm,@yymc yymc,
		substring(@ksrq,1,4)+'年'+substring(@ksrq,5,2)+'月'+substring(@ksrq,7,2)+'日'+'--'      
	   +substring(@jsrq,1,4)+'年'+substring(@jsrq,5,2)+'月'+substring(@jsrq,7,2)+'日' fkssq,'市级公务员补助' xm,  
 sum(case when YLLB = '11' then GWYBZ+GWYFH else 0 end) ptmz,  
 sum(case when YLLB = '13' then GWYBZ+GWYFH else 0 end) tbmz,  
 sum(case when YLLB in ('21','22') then GWYBZ+GWYFH else 0 end) zy,  
 sum(GWYBZ+GWYFH) zje,  
 sum(GWYBZ+GWYFH) zfje  
from VW_SYB_JSMX (nolock)   
where JSRQ between @ksrq and @jsrq+'24'  
 and CBLB=1 and YBDM in(select yydm from YY_JBCONFIG where id=@yydm)
 */ 
SELECT a.yydm,a.yymc,a.fkssq,a.xm,SUM(a.ptmz) ptmz,SUM(a.tbmz) tbmz,SUM(a.zy) zy,SUM(a.zje) zje,SUM(a.zfje) zfje
FROM 
(
	select @yydm_yb yydm,@yymc yymc,
			substring(@ksrq,1,4)+'年'+substring(@ksrq,5,2)+'月'+substring(@ksrq,7,2)+'日'+'--'      
		   +substring(@jsrq,1,4)+'年'+substring(@jsrq,5,2)+'月'+substring(@jsrq,7,2)+'日' fkssq,'市级公务员补助' xm,  
	 sum(case when YLLB = '11' then GWYBZ+GWYFH else 0 end) ptmz,  
	 sum(case when YLLB = '13' then GWYBZ+GWYFH else 0 end) tbmz,  
	 sum(case when YLLB in ('21','22') then GWYBZ+GWYFH else 0 end) zy,  
	 sum(GWYBZ+GWYFH) zje,  
	 sum(GWYBZ+GWYFH) zfje  
	from VW_SYB_JSMX (nolock)   
	where JSRQ between @ksrq and @jsrq+'24'  
	 and CBLB=1 and YBDM in(select yydm from YY_JBCONFIG where id=@yydm) 
   UNION ALL
	select @yydm_yb yydm,@yymc yymc,
			substring(@ksrq,1,4)+'年'+substring(@ksrq,5,2)+'月'+substring(@ksrq,7,2)+'日'+'--'      
		   +substring(@jsrq,1,4)+'年'+substring(@jsrq,5,2)+'月'+substring(@jsrq,7,2)+'日' fkssq,'市级公务员补助' xm,  
	 sum(case when a.YLLB = '11' then b.GWYBZ else 0 end) ptmz,  
	 sum(case when a.YLLB = '13' then b.GWYBZ else 0 end) tbmz,  
	 sum(case when a.YLLB in ('21','22') then b.GWYBZ else 0 end) zy,  
	 sum(b.GWYBZ) zje,  
	 sum(b.GWYBZ) zfje  
	from VW_SYB_JSMX a (nolock) 
		INNER JOIN VW_SYB_JSMX_EX b (nolock) ON a.JSJYLSH=b.JSJYLSH
	where a.JSRQ between @ksrq and @jsrq+'24'  
	 and a.CBLB=1 and a.YBDM in(select yydm from YY_JBCONFIG where id=@yydm) 
) AS a
GROUP BY a.yydm,a.yymc,a.fkssq,a.xm
UNION ALL
 select @yydm_yb yydm,@yymc yymc,
	    substring(@ksrq,1,4)+'年'+substring(@ksrq,5,2)+'月'+substring(@ksrq,7,2)+'日'+'--'      
       +substring(@jsrq,1,4)+'年'+substring(@jsrq,5,2)+'月'+substring(@jsrq,7,2)+'日' fkssq,'民政救助' xm,  
 sum(case when YLLB = '11' then MZJZ else 0 end) ptmz,  
 sum(case when YLLB = '13' then MZJZ else 0 end) tbmz,  
 sum(case when YLLB in ('21','22') then MZJZ else 0 end) zy,  
 sum(MZJZ) zje,  
 sum(MZJZ) zfje  
from VW_SYB_JSMX (nolock)   
where JSRQ between @ksrq and @jsrq+'24'  
 and CBLB=1 and YBDM in(select yydm from YY_JBCONFIG where id=@yydm)  
union ALL
/*
select @yydm_yb yydm,@yymc yymc,
	   substring(@ksrq,1,4)+'年'+substring(@ksrq,5,2)+'月'+substring(@ksrq,7,2)+'日'+'--'   
	   +substring(@jsrq,1,4)+'年'+substring(@jsrq,5,2)+'月'+substring(@jsrq,7,2)+'日' fkssq,'总计' xm,  
 sum(case when YLLB = '11' then TCZF+ZHZF+DELP+GWYBZ+GWYFH else 0 end)+@dyje_pb ptmz,  
 sum(case when YLLB = '13' then TCZF+ZHZF+DELP+GWYBZ+GWYFH  else 0 end)+@dyje_tb tbmz,  
 sum(case when YLLB in ('21','22') then TCZF+ZHZF+DELP+GWYBZ+GWYFH  else 0 end)-@sytc zy,  
 sum(case when YLLB in ('11','13','21','22') then TCZF else 0 end)-@sytc+sum(ZHZF)+@dyje_tb+@dyje_pb + @dyje_zy+sum(DELP)+sum(GWYBZ+GWYFH) zje,  
  sum(case when YLLB in ('11','13','21','22') then TCZF else 0 end)-@sytc+sum(ZHZF)+@dyje_tb+@dyje_pb + @dyje_zy+sum(DELP)+sum(GWYBZ+GWYFH) zfje  
from VW_SYB_JSMX (nolock)   
where JSRQ between @ksrq and @jsrq+'24'  
 and CBLB=1  and YBDM in(select yydm from YY_JBCONFIG where id=@yydm) 
*/

SELECT a.yydm,a.yymc,a.fkssq,a.xm,SUM(a.ptmz) ptmz,SUM(a.tbmz) tbmz,SUM(a.zy) zy,SUM(a.zje) zje,SUM(a.zfje) zfje
FROM
(
	select @yydm_yb yydm,@yymc yymc,
		   substring(@ksrq,1,4)+'年'+substring(@ksrq,5,2)+'月'+substring(@ksrq,7,2)+'日'+'--'   
		   +substring(@jsrq,1,4)+'年'+substring(@jsrq,5,2)+'月'+substring(@jsrq,7,2)+'日' fkssq,'总计' xm,  
	 sum(case when YLLB = '11' then TCZF+ZHZF+DELP+GWYBZ+GWYFH else 0 end)+@dyje_pb ptmz,  
	 sum(case when YLLB = '13' then TCZF+ZHZF+DELP+GWYBZ+GWYFH  else 0 end)+@dyje_tb tbmz,  
	 sum(case when YLLB in ('21','22') then TCZF+ZHZF+DELP+GWYBZ+GWYFH  else 0 end)-@sytc zy,  
	 sum(case when YLLB in ('11','13','21','22') then TCZF else 0 end)-@sytc+sum(ZHZF)+@dyje_tb+@dyje_pb + @dyje_zy+sum(DELP)+sum(GWYBZ+GWYFH) zje,  
	  sum(case when YLLB in ('11','13','21','22') then TCZF else 0 end)-@sytc+sum(ZHZF)+@dyje_tb+@dyje_pb + @dyje_zy+sum(DELP)+sum(GWYBZ+GWYFH) zfje  
	from VW_SYB_JSMX (nolock)   
	where JSRQ between @ksrq and @jsrq+'24'  
	 and CBLB=1  and YBDM in(select yydm from YY_JBCONFIG where id=@yydm) 
	UNION ALL
	select @yydm_yb yydm,@yymc yymc,
			substring(@ksrq,1,4)+'年'+substring(@ksrq,5,2)+'月'+substring(@ksrq,7,2)+'日'+'--'      
		   +substring(@jsrq,1,4)+'年'+substring(@jsrq,5,2)+'月'+substring(@jsrq,7,2)+'日' fkssq,'总计' xm,  
	 sum(case when a.YLLB = '11' then b.GWYBZ else 0 end) ptmz,  
	 sum(case when a.YLLB = '13' then b.GWYBZ else 0 end) tbmz,  
	 sum(case when a.YLLB in ('21','22') then b.GWYBZ else 0 end) zy,  
	 sum(b.GWYBZ) zje,  
	 sum(b.GWYBZ) zfje  
	from VW_SYB_JSMX a (nolock) 
		INNER JOIN VW_SYB_JSMX_EX b (nolock) ON a.JSJYLSH=b.JSJYLSH
	where a.JSRQ between @ksrq and @jsrq+'24'  
	 and a.CBLB=1 and a.YBDM in(select yydm from YY_JBCONFIG where id=@yydm) 
) AS a
GROUP BY a.yydm,a.yymc,a.fkssq,a.xm   
   
return  
  
  
  
  
  
  
  
  
  
  
  


	






