IF NOT EXISTS(SELECT 1 from sys.indexes where name='idx_yy_cqyb_mzjzjlk_xzlb_cblb' AND object_name(object_id) = 'YY_CQYB_MZJZJLK')
	CREATE NONCLUSTERED INDEX idx_yy_cqyb_mzjzjlk_xzlb_cblb ON dbo.YY_CQYB_MZJZJLK (xzlb,cblb)INCLUDE (jssjh,sbkh,zgyllb,jmyllb)
GO
