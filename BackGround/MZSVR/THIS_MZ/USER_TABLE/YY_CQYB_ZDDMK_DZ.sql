--��϶��ձ�
if not exists(select 1 from sysobjects where name='YY_CQYB_ZDDMK_DZ')
begin
	create table YY_CQYB_ZDDMK_DZ
	(   
		xh				ut_xh12    IDENTITY(1,1)	NOT NULL,	--���
		hiszddm			VARCHAR(20)				NOT NULL,		--HIS��ϴ���(YY_ZDDMK.id)
		ybzddm			varchar(20)				NOT NULL,		--ҽ����ϴ���(YY_CQYB_ZDDMK.id)
		syfw			ut_bz					NOT NULL,		--ʹ�÷�Χ(0��ȫ����1�����ڡ�2��������)
		czyh            varchar(10)				NOT NULL,			--�����û�
		czrq            ut_rq16					NOT NULL			--��������
	)
	create INDEX idx_yy_cqyb_zddmk_dz_hiszddm on YY_CQYB_ZDDMK_DZ(hiszddm)
	create index idx_yy_cqyb_zddmk_dz_ybzddm on YY_CQYB_ZDDMK_DZ(ybzddm)
end;
GO
