--ҽ�����ղ�����־
if not exists(select 1 from sysobjects where name='YY_CQYB_CZYHLOG')
begin
	create table YY_CQYB_CZYHLOG
	(
		xh				int	   identity(1,1),	--���
		czyh			ut_czyh		not null,   --�����û�
		czlb			ut_bz		not null,   --������� 0������  1��ȡ������ 2������
		czrq			ut_rq16		not null,	--��������
		hisxmdm			varchar(20)		null,   --his��Ŀ����
		ybxmdm			varchar(20)		null,   --ҽ����Ŀ����
		memo			varchar(1024)	null    --˵��
	)
	create index idx_hisxmdm on YY_CQYB_CZYHLOG(hisxmdm)
	create index idx_ybxmdm on YY_CQYB_CZYHLOG(ybxmdm)
	
end;
go

