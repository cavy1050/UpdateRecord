if not exists(select 1 from sysobjects where name='YY_CQYB_ZYFYYBDMBGMX')
BEGIN
	--סԺ����ҽ����������ϸ
	CREATE TABLE YY_CQYB_ZYFYYBDMBGMX
	(
		xh		ut_xh12,		--ZY_BRFYMXK.xh
		syxh	ut_syxh,		--��ҳ���
		jsxh	ut_xh12,		--�������
		oldybdm	VARCHAR(32),	--��ҽ������
		newybdm VARCHAR(32),	--��ҽ������
		czyh	ut_czyh,		--����Ա��
		czrq	ut_rq16,		--��������
		sfcl	ut_bz			--�Ƿ��� 0 δ����1 �Ѵ���
	)	
END
GO
