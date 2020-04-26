-------------------------------------------门诊库表-------------------------------------------
--医院审批标志
if not exists(select 1 from syscolumns where id=object_id('SF_CFMXK') and name='spbz')
	alter table SF_CFMXK add spbz ut_bz null
go
--医院审批处理标志
if not exists(select 1 from syscolumns where id=object_id('SF_CFMXK') and name='spclbz')
	alter table SF_CFMXK add spclbz ut_bz null
go
--交易流水号
if not exists(select 1 from syscolumns where id=object_id('SF_CFMXK') and name='zxlsh')
	alter table SF_CFMXK add zxlsh varchar(20) null
go
--项目单价
if not exists(select 1 from syscolumns where id=object_id('SF_CFMXK') and name='ybxmdj')
	alter table SF_CFMXK add ybxmdj numeric(10,4) null
go
--审批标记
if not exists(select 1 from syscolumns where id=object_id('SF_CFMXK') and name='ybspbz')
	alter table SF_CFMXK add ybspbz varchar(10) null
go
--项目费用总额
if not exists(select 1 from syscolumns where id=object_id('SF_CFMXK') and name='ybzje')
	alter table SF_CFMXK add ybzje numeric(10,4) null
go
--收费项目等级
if not exists(select 1 from syscolumns where id=object_id('SF_CFMXK') and name='sfxmdj')
	alter table SF_CFMXK add sfxmdj varchar(10) null
go
--自付比例
if not exists(select 1 from syscolumns where id=object_id('SF_CFMXK') and name='ybzfbl')
	alter table SF_CFMXK add ybzfbl numeric(5,4) null
go
--标准单价
if not exists(select 1 from syscolumns where id=object_id('SF_CFMXK') and name='ybbzdj')
	alter table SF_CFMXK add ybbzdj numeric(10,4) null
go
--自付金额
if not exists(select 1 from syscolumns where id=object_id('SF_CFMXK') and name='ybzfje')
	alter table SF_CFMXK add ybzfje numeric(10,4) null
go
--自费金额
if not exists(select 1 from syscolumns where id=object_id('SF_CFMXK') and name='ybzlje')
	alter table SF_CFMXK add ybzlje numeric(10,4) null
go
--增加保存挂号上传明细的关键信息字段备查
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('SF_CFMXK') AND name = 'dydm') 
	ALTER table SF_CFMXK add dydm VARCHAR(32) NULL --上传对应代码
go
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('SF_CFMXK') AND name = 'scxmdj') 
	ALTER table SF_CFMXK add scxmdj ut_money NULL --上传单价
go
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('SF_CFMXK') AND name = 'scxmsl') 
	ALTER table SF_CFMXK add scxmsl ut_sl10 NULL --上传数量
go
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('SF_CFMXK') AND name = 'scxmje') 
	ALTER table SF_CFMXK add scxmje ut_money NULL --上传金额
go

sp_refreshview VW_MZCFMXK
GO