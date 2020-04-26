-------------------------------------------门诊库表-------------------------------------------
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('SF_NBRJSK') AND name = 'medtype')
	ALTER TABLE SF_NBRJSK ADD medtype VARCHAR(3) NULL
GO
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('SF_NBRJSK') AND name = 'zddm')
	ALTER TABLE SF_NBRJSK ADD zddm VARCHAR(30) NULL
GO
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('SF_NBRJSK') AND name = 'ybbfz')
	ALTER TABLE SF_NBRJSK ADD ybbfz VARCHAR(300) NULL
GO
IF NOT EXISTS(SELECT 1 from sys.indexes where name='idx_sf_nbrjsk_sfrq' AND object_name(object_id) = 'SF_NBRJSK')
	CREATE NONCLUSTERED INDEX idx_sf_nbrjsk_sfrq ON SF_NBRJSK (ybjszt,jlzt,sfrq) INCLUDE (sjh,czyh,hzxm,blh,ybdm,tsjh)
GO
sp_refreshview VW_MZBRJSK
GO
-------------------------------------------门诊库表-------------------------------------------