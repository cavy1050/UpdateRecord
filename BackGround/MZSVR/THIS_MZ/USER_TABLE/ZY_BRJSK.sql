-------------------------------------------סԺ���-------------------------------------------
--ҽ�����ԭ�� add by Zhb for 2018-05-11
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('ZY_BRJSK') AND name = 'ybshyy')
	ALTER TABLE ZY_BRJSK ADD ybshyy VARCHAR(500) NULL
GO

IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('ZY_BRJSK') AND name = 'sybybzje')
	ALTER TABLE ZY_BRJSK ADD sybybzje NUMERIC(12,2) NULL
GO

--��Ժ�����˱�־
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('ZY_BRJSK') AND name = 'ybcyzdshbz')
	ALTER TABLE ZY_BRJSK ADD ybcyzdshbz ut_bz NULL
GO

--��¼hisԤ���ܽ������Żݲ��֣������ڸ�ҽ����ϸ�ܽ��Ա�(usp_cqyb_zyjs_ex1)
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('ZY_BRJSK') AND name = 'ys_zje')
	ALTER TABLE ZY_BRJSK ADD ys_zje ut_money
go
-------------------------------------------סԺ���-------------------------------------------