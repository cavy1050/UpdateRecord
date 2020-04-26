-------------------------------------------门诊库表-------------------------------------------
--医院审批标志
if not exists(select 1 from syscolumns where id=object_id('SF_NCFMXK') and name='spbz')
	alter table SF_NCFMXK add spbz ut_bz null
go
--医院审批处理标志
if not exists(select 1 from syscolumns where id=object_id('SF_NCFMXK') and name='spclbz')
	alter table SF_NCFMXK add spclbz ut_bz null
go
--交易流水号
if not exists(select 1 from syscolumns where id=object_id('SF_NCFMXK') and name='zxlsh')
	alter table SF_NCFMXK add zxlsh varchar(20) null
go
--项目单价
if not exists(select 1 from syscolumns where id=object_id('SF_NCFMXK') and name='ybxmdj')
	alter table SF_NCFMXK add ybxmdj numeric(10,4) null
go
--审批标记
if not exists(select 1 from syscolumns where id=object_id('SF_NCFMXK') and name='ybspbz')
	alter table SF_NCFMXK add ybspbz varchar(10) null
go
--项目费用总额
if not exists(select 1 from syscolumns where id=object_id('SF_NCFMXK') and name='ybzje')
	alter table SF_NCFMXK add ybzje numeric(10,4) null
go
--收费项目等级
if not exists(select 1 from syscolumns where id=object_id('SF_NCFMXK') and name='sfxmdj')
	alter table SF_NCFMXK add sfxmdj varchar(10) null
go
--自付比例
if not exists(select 1 from syscolumns where id=object_id('SF_NCFMXK') and name='ybzfbl')
	alter table SF_NCFMXK add ybzfbl numeric(5,4) null
go
--标准单价
if not exists(select 1 from syscolumns where id=object_id('SF_NCFMXK') and name='ybbzdj')
	alter table SF_NCFMXK add ybbzdj numeric(10,4) null
go
--自付金额
if not exists(select 1 from syscolumns where id=object_id('SF_NCFMXK') and name='ybzfje')
	alter table SF_NCFMXK add ybzfje numeric(10,4) null
go
--自费金额
if not exists(select 1 from syscolumns where id=object_id('SF_NCFMXK') and name='ybzlje')
	alter table SF_NCFMXK add ybzlje numeric(10,4) null
GO

--增加保存挂号上传明细的关键信息字段备查
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('SF_NCFMXK') AND name = 'dydm') 
	ALTER table SF_NCFMXK add dydm VARCHAR(32) NULL --上传对应代码
go
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('SF_NCFMXK') AND name = 'scxmdj') 
	ALTER table SF_NCFMXK add scxmdj ut_money NULL --上传单价
go
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('SF_NCFMXK') AND name = 'scxmsl') 
	ALTER table SF_NCFMXK add scxmsl ut_sl10 NULL --上传数量
go
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('SF_NCFMXK') AND name = 'scxmje') 
	ALTER table SF_NCFMXK add scxmje ut_money NULL --上传金额
go

sp_refreshview VW_MZCFMXK
GO