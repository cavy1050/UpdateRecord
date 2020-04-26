-------------------------------------------公共库表-------------------------------------------
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('YY_YBFLK') AND name = 'xzlb')
	ALTER TABLE [dbo].[YY_YBFLK] ADD [xzlb] [INT] NULL
GO
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('YY_YBFLK') AND name = 'cblb')
	ALTER TABLE [dbo].[YY_YBFLK] ADD [cblb] [INT] NULL
GO

-------------------------------------------公共库表-------------------------------------------