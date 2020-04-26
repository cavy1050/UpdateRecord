-------------------------------------------公共库表-------------------------------------------
if not exists(select 1 from syscolumns where id=object_id('YY_JBCONFIG') and name='qzjconstr')
	alter table YY_JBCONFIG add qzjconstr VARCHAR(1000)
GO

IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('YY_JBCONFIG') AND name = 'cqyb_ddyljgbm')
begin
	ALTER TABLE YY_JBCONFIG ADD cqyb_ddyljgbm ut_dm12 NULL
end
GO

update YY_JBCONFIG set cqyb_ddyljgbm = yydm WHERE ISNULL(cqyb_ddyljgbm,'') = ''
GO

-------------------------------------------公共库表-------------------------------------------