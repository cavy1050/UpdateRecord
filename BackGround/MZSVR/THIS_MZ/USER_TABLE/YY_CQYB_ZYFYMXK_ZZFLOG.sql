--ҽ��סԺ������ϸ��Ϣ_ת�Է���־
if not exists(select 1 from sysobjects where name='YY_CQYB_ZYFYMXK_ZZFLOG')
begin
	create table YY_CQYB_ZYFYMXK_ZZFLOG
	(   
		syxh			ut_syxh		not null,	--��ҳ���
		jsxh			ut_xh12		not null,	--�������
		xh				ut_xh12		not NULL,	--��ϸ���
		lb              VARCHAR(3)       NOT NULL,   --�������1ת�Էѣ�2תҽ��
		czyh            varchar(10)     NULL,   --�����û�
		czrq            DATETIME        NULL    --��������
	)
	create index idx_yy_cqyb_zyfymxk_zzflog_syxh on YY_CQYB_ZYFYMXK_ZZFLOG(syxh)
	create index idx_yy_cqyb_zyfymxk_zzflog_jsxh on YY_CQYB_ZYFYMXK_ZZFLOG(jsxh)
	create index idx_yy_cqyb_zyfymxk_zzflog_xh on YY_CQYB_ZYFYMXK_ZZFLOG(xh)
end;
GO
