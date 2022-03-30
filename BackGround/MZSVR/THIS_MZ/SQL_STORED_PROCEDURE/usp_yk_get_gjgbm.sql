USE [THIS_MZ]
GO

/****** Object:  StoredProcedure [dbo].[usp_yk_get_gjgbm]    Script Date: 2022/3/11 11:48:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


alter procedure [dbo].[usp_yk_get_gjgbm]	
	@cd_idm 	ut_xh9  	--药品idm
as --集414747 2021-08-19 16:11:38 4.0标准版_201810补丁
/**********
[版本号]4.0.0.0.1
[创建时间]2021.08.14
[作者]x.wl
[版权] Copyright ? 2018-2022 卫宁健康科技集团股份有限公司
[描述] 药库系统--获取“国家贯标编码”和“国家贯标名称”
[功能说明]
	获取“国家贯标编码”和“国家贯标名称”
[参数说明]
	
[返回值]
[结果集、排序]
	
[调用的sp]
	

[调用实例]
exec usp_yk_get_gjgbm "1"

[修改]

**********/
set nocount on
 
 --SELECT "abc" gjgbm_id,"ABC" gjgbm_name
 --SELECT b.op_gjbm gjgbm_id 
 --      ,b.op_gjbmmc  gjgbm_name 
 --FROM dbo.YK_YPCDMLK a,YY_SYB_YBYPK b 
 --WHERE a.syb_jbdydm=b.op_zxdypypbm  AND a.idm=@cd_idm


IF object_id('tempdb..#tmp_zz_result') is not null                                                                  
BEGIN                                                                      
    DROP TABLE #tmp_zz_result                                                                      
END 

SELECT   a.dydm_si21 id 
       ,b.zcmc  name 
	   INTO  #tmp_zz_result
 FROM dbo.YK_YPCDMLK a(nolock) left join YB_SI21_XYZCYXXK b(nolock) 
 ON a.dydm_si21=b.med_list_codg  
 WHERE a.idm=@cd_idm and yplh=1
 
	
INSERT INTO #tmp_zz_result	
	 SELECT a.dydm_si21 id 
		   ,c.sindrug_name  name 
	 FROM  dbo.YK_YPCDMLK a(nolock) left join YB_SI21_ZYYPXXK c(nolock) 
	 ON a.dydm_si21=c.med_list_codg 
	 WHERE a.idm=@cd_idm and yplh<>1

SELECT id gjgbm_id,name gjgbm_name FROM  #tmp_zz_result 



return


GO


