-------------------------------------------住院库表-------------------------------------------
--医保审核原因 add by Zhb for 2018-05-11
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('ZY_BRJSK') AND name = 'ybshyy')
	ALTER TABLE ZY_BRJSK ADD ybshyy VARCHAR(500) NULL
GO

IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('ZY_BRJSK') AND name = 'sybybzje')
	ALTER TABLE ZY_BRJSK ADD sybybzje NUMERIC(12,2) NULL
GO

--出院诊断审核标志
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('ZY_BRJSK') AND name = 'ybcyzdshbz')
	ALTER TABLE ZY_BRJSK ADD ybcyzdshbz ut_bz NULL
GO

--记录his预算总金额（不含优惠部分），用于跟医保明细总金额对比(usp_cqyb_zyjs_ex1)
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('ZY_BRJSK') AND name = 'ys_zje')
	ALTER TABLE ZY_BRJSK ADD ys_zje ut_money
go
-------------------------------------------住院库表-------------------------------------------