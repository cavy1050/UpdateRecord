-------------------------------------------公共库表-------------------------------------------
IF EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('YY_SFXXMK') AND name = 'memo')
	ALTER TABLE YY_SFXXMK ALTER COLUMN memo VARCHAR(1000)
ELSE
	ALTER TABLE YY_SFXXMK ADD memo VARCHAR(1000)
GO
-------------------------------------------公共库表-------------------------------------------