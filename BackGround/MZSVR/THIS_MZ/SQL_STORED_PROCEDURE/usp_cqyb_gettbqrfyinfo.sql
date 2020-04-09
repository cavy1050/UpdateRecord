if exists(select * from sysobjects where name='usp_cqyb_gettbqrfyinfo')
  drop proc usp_cqyb_gettbqrfyinfo
go
CREATE PROC usp_cqyb_gettbqrfyinfo
	@blh	ut_blh,
	@kssj	VARCHAR(20),
	@jssj	VARCHAR(20)
AS
/****************************************
[版本号]4.0.0.0.0
[创建时间]2018.03.21
[作者]Zhuhb
[版权]Copyright ? 1998-2017卫宁健康科技集团股份有限公司
[描述]保存医保特殊病审批信息
[功能说明]
    慢病特病报盘 调用
	特病、慢病检查确认等费用明细查询
	该存储为现场自定义存储、可以自行修改；
	其中字段[HZXM]必须有，字段[I]保存社保卡号
[参数说明]
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]
exec usp_cqyb_gettbqrfyinfo "20170036437","2009030100:00:00","2018033000:00:00"
[修改记录]

****************************************/
 select row_number() over(order by c.xh)   as  "ID",              
 '0' "A",'0' "B",'0' as "C",c.ylsj "D",c.ylsj "E",c.ypsl "F",                
 e.dydm "G",d.blh "H",'' "I",                  
 d.hzxm "J",                     
 substring(a.sfrq,1,4)+'-'+substring(a.sfrq,5,2)+'-'+substring(a.sfrq,7,2) "K",c.ypdw  "L",                  
 row_number() over(order by c.xh)  AS "M" ,              
 '10997' as "N" ,0 AS "Z",c.ypmc XMMC,d.hzxm "HZXM"               
 into #tempbrbp                     
 from VW_MZBRJSK a(nolock) inner join VW_MZCFK b(nolock) on a.sjh = b.jssjh                       
 inner join VW_MZCFMXK c(nolock) on b.xh = c.cfxh inner join SF_BRXXK d(nolock) on a.patid = d.patid                       
 inner join YY_SFXXMK e(nolock) on c.ypdm = e.id                      
  where --b.ksdm = '1310' AND       
  a.ybjszt = 2 and d.blh = @blh AND a.sfrq BETWEEN @kssj  AND  @jssj             
                
               
  select CAST(ID AS CHAR(5)) ID,A,B,C,D,E,F,G,H,I,J,CAST(K AS DATETIME) K,L,
  CAST(M AS CHAR(5)) M,N,Z,XMMC,HZXM from #tempbrbp

	