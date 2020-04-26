-------------------------------------------公共库表-------------------------------------------
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('YY_SYB_BRJBBMK') AND name = 'bfz')
	ALTER table YY_SYB_BRJBBMK add bfz VARCHAR(1000)
go 

IF  EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('YY_SYB_BRJBBMK') AND name = 'bfz')
	ALTER table YY_SYB_BRJBBMK ALTER COLUMN bfz VARCHAR(1000)
go 

IF  EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('YY_SYB_BRJBBMK') AND name = 'bzmc')
	ALTER table YY_SYB_BRJBBMK ALTER COLUMN  bzmc VARCHAR(256)
go 
-------------------------------------------公共库表-------------------------------------------