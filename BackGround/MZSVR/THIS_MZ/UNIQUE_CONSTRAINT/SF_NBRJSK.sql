IF NOT EXISTS(SELECT 1 from sys.indexes where name='idx_sf_nbrjsk_sfrq' AND object_name(object_id) = 'SF_NBRJSK')
	CREATE NONCLUSTERED INDEX idx_sf_nbrjsk_sfrq ON SF_NBRJSK (ybjszt,jlzt,sfrq) INCLUDE (sjh,czyh,hzxm,blh,ybdm,tsjh)
GO