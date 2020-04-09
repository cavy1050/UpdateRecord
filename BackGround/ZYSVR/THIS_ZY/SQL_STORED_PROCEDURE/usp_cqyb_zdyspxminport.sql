IF exists(SELECT 1 FROM sysobjects WHERE name = 'usp_cqyb_zdyspxminport')
  DROP PROC usp_cqyb_zdyspxminport
GO
CREATE PROC usp_cqyb_zdyspxminport
	@czyh ut_czyh	--操作员号
AS
/****************************************
[版本号]4.0.0.0.0
[创建时间]2019.2.25
[作者]Zhuhb
[版权]Copyright ? 1998-2017卫宁健康科技集团股份有限公司
[描述]医保审批项目自定义导入
[功能说明]
	提供医保审批项目自定义导入功能，现场自定义存储，现场维护；
[参数说明]
	--
[返回值]
	--
[结果集、排序]
[调用的sp]
[调用实例]
[修改记录]

****************************************/
SET NOCOUNT ON

SELECT "T"

RETURN
GO
