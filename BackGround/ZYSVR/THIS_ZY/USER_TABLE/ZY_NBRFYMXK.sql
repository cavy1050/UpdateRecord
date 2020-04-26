-------------------------------------------住院库表-------------------------------------------
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('ZY_NBRFYMXK') AND name = 'ybzxrq')
	ALTER TABLE [dbo].[ZY_NBRFYMXK] ADD [ybzxrq] [dbo].[ut_rq16] NULL
GO

sp_refreshview VW_BRFYMXK
go
-------------------------------------------住院库表-------------------------------------------