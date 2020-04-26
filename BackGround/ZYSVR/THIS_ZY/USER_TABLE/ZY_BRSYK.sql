-------------------------------------------住院库表-------------------------------------------
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('ZY_BRSYK') AND name = 'ybdjrq')
	ALTER TABLE ZY_BRSYK ADD ybdjrq ut_rq16 NULL
GO
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('ZY_BRSYK') AND name = 'ybtbrq')
	ALTER TABLE ZY_BRSYK ADD ybtbrq ut_rq16 NULL
GO
-------------------------------------------住院库表-------------------------------------------