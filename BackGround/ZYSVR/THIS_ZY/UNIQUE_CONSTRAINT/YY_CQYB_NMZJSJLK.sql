IF NOT EXISTS(SELECT 1 from sys.indexes where name='idx_yy_cqyb_nmzjsjlk_ddyljgbm' AND object_name(object_id) = 'YY_CQYB_NMZJSJLK')
	CREATE NONCLUSTERED INDEX idx_yy_cqyb_nmzjsjlk_ddyljgbm ON dbo.YY_CQYB_NMZJSJLK (ddyljgbm) INCLUDE (jssjh,xzlb,sylb,zxlsh)
GO