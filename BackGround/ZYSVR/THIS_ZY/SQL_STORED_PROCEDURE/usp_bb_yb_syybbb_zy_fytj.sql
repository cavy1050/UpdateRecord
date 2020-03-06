ALTER procedure usp_bb_yb_syybbb_zy_fytj  
 @ksrq ut_rq8, ---统计日期      
 @jsrq ut_rq8, ----结算日期 
 @yydm ut_dm5     
as--集77409 2010-07-29 16:47:34 4.0标准版 201007 升级发布128      
/**********      
[版本号]4.0.0.0.0      
[创建时间]2004.11.19      
[作者]朱伟杰      
[版权] Copyright ? 2004-2008上海金仕达-卫宁软件股份有限公司[描述] 住院系统--入区登记      
[功能说明]      
 入院病人入区登记      
[参数说明]      
     --Add In : 2005-06-04  By : Koala For :增加借床处理      
@ksrq ut_rq8 统计日期      
      
[返回值]      
      
[结果集、排序]      
 成功："T"      
 错误："F","错误信息"      
      
[调用的sp]      
      
[调用实例]      
exec usp_bb_yb_syybbb_zy '20150201','20150228'      
      
[修改说明]      
      
**********/      
set nocount on      

SELECT f.name '生育类型',SUM(d.je) '金额'
FROM dbo.YY_CQYB_ZYJZJLK a (NOLOCK)
	INNER JOIN dbo.YY_CQYB_ZYJSJLK b (NOLOCK) ON a.syxh=b.syxh
	INNER JOIN dbo.ZY_BRJSK c (NOLOCK) ON b.jsxh=c.xh
	INNER JOIN dbo.ZY_BRJSJEK d (NOLOCK) ON c.xh=d.jsxh
	INNER JOIN dbo.YY_KSBMK e (NOLOCK) ON c.ksdm=e.id
	INNER JOIN dbo.YY_CQYB_YBSJZD f (NOLOCK) ON b.sylb=f.code
WHERE c.jsrq BETWEEN @ksrq AND @jsrq+'24'
AND c.ybjszt=2
AND e.yydm=@yydm
AND a.xzlb=3
AND a.cblb=1
AND f.zdlb = 'SYLB' AND f.xtbz = 1
AND d.lx='yb24'
AND c.jlzt IN (0,1)
GROUP BY f.name

RETURN