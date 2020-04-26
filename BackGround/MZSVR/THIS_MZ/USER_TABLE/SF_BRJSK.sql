-------------------------------------------√≈’Ôø‚±Ì-------------------------------------------
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('SF_BRJSK') AND name = 'medtype')
	ALTER TABLE SF_BRJSK ADD medtype VARCHAR(3) NULL
GO
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('SF_BRJSK') AND name = 'zddm')
	ALTER TABLE SF_BRJSK ADD zddm VARCHAR(30) NULL
GO
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('SF_BRJSK') AND name = 'ybbfz')
	ALTER TABLE SF_BRJSK ADD ybbfz VARCHAR(300) NULL
GO
sp_refreshview VW_MZBRJSK
GO