--ҽ�������־
if not exists(select 1 from sysobjects where name='YY_CQYB_YBSHLOG')
begin
	create table YY_CQYB_YBSHLOG
	(   
		xh				ut_xh12    identity	not null , --���
		syxh			ut_syxh		not null,	--��ҳ���
		jsxh			ut_xh12		not null,	--�������
		shbz			ut_bz		NOT NULL,	--��˱�־	0 δ��˻�δ����, 1 ��ˡ����˾�ͨ��, 2 δͨ��(��Ҫ2�󸴺�)
		czyh            varchar(10)     NULL,   --�����û�
		czrq            ut_rq16        NULL    --��������
	)
	create index idx_yy_cqyb_ybshlog_syxh on YY_CQYB_YBSHLOG(syxh)
	create index idx_yy_cqyb_ybshlog_jsxh on YY_CQYB_YBSHLOG(jsxh)
end;
GO
