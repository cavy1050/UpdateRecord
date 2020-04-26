if not exists(select 1 from sysobjects where name='YY_CQYB_SETYBZDSP')
begin
	create table YY_CQYB_SETYBZDSP
	(
	xzlb ut_bz,			--�������  1��ҽ�Ʊ��� 2�����˱��� 3����������
	cblb ut_bz,			--�α����  1�� ְ���α� 2�� ����α� 3�� ���ݸɲ�
	ybdm ut_ybdm,		--ҽ�����루���ο���
	gsfzdspbz ut_bz,	--���շ�����,0���Զ���1�Զ�����ͨ����2�Զ�������ͨ��
	xyzdspbz ut_bz,		--ѪҺ������0���Զ���1�Զ�����ͨ����2�Զ�������ͨ��
	xtbz ut_bz			--ϵͳ��־��1�����շѣ�2סԺ
	)
end
GO

-- ����xtbz 1�����շ�2סԺ
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('YY_CQYB_SETYBZDSP') AND name = 'xtbz')
BEGIN
	ALTER TABLE YY_CQYB_SETYBZDSP ADD xtbz	ut_bz;	
END
