IF NOT EXISTS(SELECT 1 from sys.indexes where name='idx_yy_cqyb_mzjsjlk_ddyljgbm' AND object_name(object_id) = 'YY_CQYB_MZJSJLK')
	CREATE NONCLUSTERED INDEX idx_yy_cqyb_mzjsjlk_ddyljgbm ON dbo.YY_CQYB_MZJSJLK (ddyljgbm) INCLUDE (jssjh,xzlb,sylb,zxlsh)
GO