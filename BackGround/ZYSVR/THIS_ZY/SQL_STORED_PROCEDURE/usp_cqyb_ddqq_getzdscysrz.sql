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
[�汾��]4.0.0.0.0
[����ʱ��]2017.03.05
[����]FerryMan
[��Ȩ]Copyright ? 1998-2017���������Ƽ����Źɷ����޹�˾
[����]סԺҽ����˻�ȡ�Զ��ϴ�Ԥ����־
[����˵��]
[����˵��]
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��]
usp_cqyb_ddqq_getzdscysrz '2018090200:00:00','2018090300:00:00'
[�޸ļ�¼]
****************************************/
set nocount on 
 
 SELECT b.blh ������, b.hzxm ����, a.cznr ��������,c.name �����û�,a.czrq �������� 
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
 