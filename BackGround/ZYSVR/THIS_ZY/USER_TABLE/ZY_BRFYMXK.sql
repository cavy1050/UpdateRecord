-------------------------------------------住院库表-------------------------------------------
if not exists(select 1 from syscolumns where id=object_id('ZY_BRFYMXK') and name='scbz')
	alter table ZY_BRFYMXK add scbz ut_bz null
GO

IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('ZY_BRFYMXK') AND name = 'ybzxrq')
	ALTER TABLE [dbo].[ZY_BRFYMXK] ADD [ybzxrq] [dbo].[ut_rq16] NULL
GO

--医保--转自费标识
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('ZY_BRFYMXK') AND name = 'ybzzfbz')
	ALTER table ZY_BRFYMXK add ybzzfbz ut_bz
GO
-------------------------------------------住院库表-------------------------------------------