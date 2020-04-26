IF NOT EXISTS(SELECT 1 from sys.indexes where name='idx_yy_cqyb_zyjzjlk_jzlsh' AND object_name(object_id) = 'YY_CQYB_ZYJZJLK')
	CREATE NONCLUSTERED INDEX idx_yy_cqyb_zyjzjlk_jzlsh ON dbo.YY_CQYB_ZYJZJLK (jzlsh) INCLUDE (sbkh,xzlb,cblb,zgyllb,jmyllb)
GO
