--ҽ���Զ���������Ŀ�������־
if not exists(select 1 from sysobjects where name='YY_CQYB_ZDYSPXMLOG')
begin
	create table YY_CQYB_ZDYSPXMLOG
	(
		xh				int	   identity(1,1),	--���
		whxh            int         NOT NULL,   --YY_CQYB_ZDYSPXM.xh ά�����
		czyh			ut_czyh		not null,   --�����û�
		czlb			ut_bz		not null,   --������� 0������  1������ 2��ͣ��
		czrq			datetime		not null,	--��������
		memo			varchar(1024)	null    --˵��
	)
	create index idx_yy_cqyb_zdyspxmlog_whxh on YY_CQYB_ZDYSPXMLOG(whxh)
end;
GO

