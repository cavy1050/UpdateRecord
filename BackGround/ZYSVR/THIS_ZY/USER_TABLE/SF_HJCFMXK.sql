-------------------------------------------门诊库表-------------------------------------------
--医保--转自费标识
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('SF_HJCFMXK') AND name = 'ybzzfbz')
	ALTER table SF_HJCFMXK add ybzzfbz ut_bz
GO
--审核id
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('SF_HJCFMXK') AND name = 'shid')
	ALTER table SF_HJCFMXK add shid VARCHAR(30)
GO
sp_refreshview  VW_MZHJCFMXK 
GO
-------------------------------------------门诊库表-------------------------------------------