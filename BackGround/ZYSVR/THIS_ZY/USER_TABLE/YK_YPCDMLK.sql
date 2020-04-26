-------------------------------------------公共库表-------------------------------------------
IF EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('YK_YPCDMLK') AND name = 'memo')
	ALTER TABLE YK_YPCDMLK ALTER COLUMN memo VARCHAR(1000)
ELSE
	ALTER TABLE YK_YPCDMLK ADD memo VARCHAR(1000)
GO
-------------------------------------------公共库表-------------------------------------------