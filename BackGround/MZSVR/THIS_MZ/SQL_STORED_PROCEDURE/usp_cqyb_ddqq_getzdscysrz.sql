if exists(select * from sysobjects where name='usp_cqyb_ddqq_getzdscysrz')
  drop proc usp_cqyb_ddqq_getzdscysrz
GO
SET ANSI_NULLS ON
SET ANSI_WARNINGS ON 
go
CREATE proc usp_cqyb_ddqq_getzdscysrz
(
	@ksrq	ut_rq16,
	@jsrq	ut_rq16
)
as
/****************************************
[版本号]4.0.0.0.0
[创建时间]2017.03.05
[作者]FerryMan
[版权]Copyright ? 1998-2017卫宁健康科技集团股份有限公司
[描述]住院医保审核获取自动上传预算日志
[功能说明]
[参数说明]
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]
usp_cqyb_ddqq_getzdscysrz '2018090200:00:00','2018090300:00:00'
[修改记录]
****************************************/
set nocount on 
 
 SELECT b.blh 病历号, b.hzxm 姓名, a.cznr 错误内容,c.name 操作用户,a.czrq 操作日期 
 FROM YY_CZLOG a(NOLOCK),ZY_BRSYK b(NOLOCK),YY_ZGBMK c(NOLOCK)
 WHERE a.tabname = 'YY_YBMRJYK' 
   AND a.field_xh = b.syxh 
   AND a.czyh = c.id
   AND a.czrq >= @ksrq 
   AND a.czrq <= @jsrq

return
GO

SET ANSI_NULLS off
SET ANSI_WARNINGS OFF

go
 