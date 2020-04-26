-------------------------------------------门诊库表-------------------------------------------
--交易流水号
if not exists(select 1 from syscolumns where id=object_id('GH_NGHMXK') and name='zxlsh')
	alter table GH_NGHMXK add zxlsh varchar(20) null
go
--项目单价
if not exists(select 1 from syscolumns where id=object_id('GH_NGHMXK') and name='ybxmdj')
	alter table GH_NGHMXK add ybxmdj numeric(10,4) null
go
--审批标记
if not exists(select 1 from syscolumns where id=object_id('GH_NGHMXK') and name='ybspbz')
	alter table GH_NGHMXK add ybspbz varchar(10) null
go
--项目费用总额
if not exists(select 1 from syscolumns where id=object_id('GH_NGHMXK') and name='ybzje')
	alter table GH_NGHMXK add ybzje numeric(10,4) null
go
--收费项目等级
if not exists(select 1 from syscolumns where id=object_id('GH_NGHMXK') and name='sfxmdj')
	alter table GH_NGHMXK add sfxmdj varchar(10) null
go
--自付比例
if not exists(select 1 from syscolumns where id=object_id('GH_NGHMXK') and name='ybzfbl')
	alter table GH_NGHMXK add ybzfbl numeric(5,4) null
go
--标准单价
if not exists(select 1 from syscolumns where id=object_id('GH_NGHMXK') and name='ybbzdj')
	alter table GH_NGHMXK add ybbzdj numeric(10,4) null
go
--自付金额
if not exists(select 1 from syscolumns where id=object_id('GH_NGHMXK') and name='ybzfje')
	alter table GH_NGHMXK add ybzfje numeric(10,4) null
go
--自费金额
if not exists(select 1 from syscolumns where id=object_id('GH_NGHMXK') and name='ybzlje')
	alter table GH_NGHMXK add ybzlje numeric(10,4) null
go
sp_refreshview VW_GHMXK
go
--增加保存挂号上传明细的关键信息字段备查
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('GH_NGHMXK') AND name = 'dydm') 
	ALTER table GH_NGHMXK add dydm VARCHAR(32) NULL --上传对应代码
go
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('GH_NGHMXK') AND name = 'scxmdj') 
	ALTER table GH_NGHMXK add scxmdj ut_money NULL --上传单价
go
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('GH_NGHMXK') AND name = 'scxmsl') 
	ALTER table GH_NGHMXK add scxmsl ut_sl10 NULL --上传数量
go
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('GH_NGHMXK') AND name = 'scxmje') 
	ALTER table GH_NGHMXK add scxmje ut_money NULL --上传金额
go

sp_refreshview VW_GHMXK
GO