IF NOT EXISTS (select 1 from sysobjects where parent_obj=object_id('YY_CQYB_TSBINFO') and xtype='PK' and name='PK_YY_CQYB_TSBINFO')
	ALTER TABLE YY_CQYB_TSBINFO add constraint PK_YY_CQYB_TSBINFO PRIMARY KEY (id)
GO