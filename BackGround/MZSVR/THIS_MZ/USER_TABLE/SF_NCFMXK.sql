-------------------------------------------������-------------------------------------------
--ҽԺ������־
if not exists(select 1 from syscolumns where id=object_id('SF_NCFMXK') and name='spbz')
	alter table SF_NCFMXK add spbz ut_bz null
go
--ҽԺ���������־
if not exists(select 1 from syscolumns where id=object_id('SF_NCFMXK') and name='spclbz')
	alter table SF_NCFMXK add spclbz ut_bz null
go
--������ˮ��
if not exists(select 1 from syscolumns where id=object_id('SF_NCFMXK') and name='zxlsh')
	alter table SF_NCFMXK add zxlsh varchar(20) null
go
--��Ŀ����
if not exists(select 1 from syscolumns where id=object_id('SF_NCFMXK') and name='ybxmdj')
	alter table SF_NCFMXK add ybxmdj numeric(10,4) null
go
--�������
if not exists(select 1 from syscolumns where id=object_id('SF_NCFMXK') and name='ybspbz')
	alter table SF_NCFMXK add ybspbz varchar(10) null
go
--��Ŀ�����ܶ�
if not exists(select 1 from syscolumns where id=object_id('SF_NCFMXK') and name='ybzje')
	alter table SF_NCFMXK add ybzje numeric(10,4) null
go
--�շ���Ŀ�ȼ�
if not exists(select 1 from syscolumns where id=object_id('SF_NCFMXK') and name='sfxmdj')
	alter table SF_NCFMXK add sfxmdj varchar(10) null
go
--�Ը�����
if not exists(select 1 from syscolumns where id=object_id('SF_NCFMXK') and name='ybzfbl')
	alter table SF_NCFMXK add ybzfbl numeric(5,4) null
go
--��׼����
if not exists(select 1 from syscolumns where id=object_id('SF_NCFMXK') and name='ybbzdj')
	alter table SF_NCFMXK add ybbzdj numeric(10,4) null
go
--�Ը����
if not exists(select 1 from syscolumns where id=object_id('SF_NCFMXK') and name='ybzfje')
	alter table SF_NCFMXK add ybzfje numeric(10,4) null
go
--�Էѽ��
if not exists(select 1 from syscolumns where id=object_id('SF_NCFMXK') and name='ybzlje')
	alter table SF_NCFMXK add ybzlje numeric(10,4) null
GO

--���ӱ���Һ��ϴ���ϸ�Ĺؼ���Ϣ�ֶα���
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('SF_NCFMXK') AND name = 'dydm') 
	ALTER table SF_NCFMXK add dydm VARCHAR(32) NULL --�ϴ���Ӧ����
go
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('SF_NCFMXK') AND name = 'scxmdj') 
	ALTER table SF_NCFMXK add scxmdj ut_money NULL --�ϴ�����
go
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('SF_NCFMXK') AND name = 'scxmsl') 
	ALTER table SF_NCFMXK add scxmsl ut_sl10 NULL --�ϴ�����
go
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('SF_NCFMXK') AND name = 'scxmje') 
	ALTER table SF_NCFMXK add scxmje ut_money NULL --�ϴ����
go

sp_refreshview VW_MZCFMXK
GO