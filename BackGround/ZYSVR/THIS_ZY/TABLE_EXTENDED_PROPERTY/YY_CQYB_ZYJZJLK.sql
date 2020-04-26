-- Add comments to the table 
EXEC sys.sp_addextendedproperty @name=N'重庆市医保接口-住院就诊记录库', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'YY_CQYB_ZYJZJLK'
GO
-- Add comments to the columns
EXEC sys.sp_addextendedproperty @name=N'记录状态', @value=N'2正常，3作废' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'YY_CQYB_ZYJZJLK', @level2type=N'COLUMN',@level2name=N'jlzt'
GO