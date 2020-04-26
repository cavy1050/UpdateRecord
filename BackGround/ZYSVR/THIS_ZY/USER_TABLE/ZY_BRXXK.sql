-------------------------------------------住院库表-------------------------------------------
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('ZY_BRXXK') AND name = 'pkhbz')
	ALTER TABLE ZY_BRXXK ADD pkhbz ut_bz NULL
GO
-------------------------------------------住院库表-------------------------------------------