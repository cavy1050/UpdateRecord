-------------------------------------------������-------------------------------------------
--������ˮ��
if not exists(select 1 from syscolumns where id=object_id('GH_NGHMXK') and name='zxlsh')
	alter table GH_NGHMXK add zxlsh varchar(20) null
go
--��Ŀ����
if not exists(select 1 from syscolumns where id=object_id('GH_NGHMXK') and name='ybxmdj')
	alter table GH_NGHMXK add ybxmdj numeric(10,4) null
go
--�������
if not exists(select 1 from syscolumns where id=object_id('GH_NGHMXK') and name='ybspbz')
	alter table GH_NGHMXK add ybspbz varchar(10) null
go
--��Ŀ�����ܶ�
if not exists(select 1 from syscolumns where id=object_id('GH_NGHMXK') and name='ybzje')
	alter table GH_NGHMXK add ybzje numeric(10,4) null
go
--�շ���Ŀ�ȼ�
if not exists(select 1 from syscolumns where id=object_id('GH_NGHMXK') and name='sfxmdj')
	alter table GH_NGHMXK add sfxmdj varchar(10) null
go
--�Ը�����
if not exists(select 1 from syscolumns where id=object_id('GH_NGHMXK') and name='ybzfbl')
	alter table GH_NGHMXK add ybzfbl numeric(5,4) null
go
--��׼����
if not exists(select 1 from syscolumns where id=object_id('GH_NGHMXK') and name='ybbzdj')
	alter table GH_NGHMXK add ybbzdj numeric(10,4) null
go
--�Ը����
if not exists(select 1 from syscolumns where id=object_id('GH_NGHMXK') and name='ybzfje')
	alter table GH_NGHMXK add ybzfje numeric(10,4) null
go
--�Էѽ��
if not exists(select 1 from syscolumns where id=object_id('GH_NGHMXK') and name='ybzlje')
	alter table GH_NGHMXK add ybzlje numeric(10,4) null
go
sp_refreshview VW_GHMXK
go
--���ӱ���Һ��ϴ���ϸ�Ĺؼ���Ϣ�ֶα���
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('GH_NGHMXK') AND name = 'dydm') 
	ALTER table GH_NGHMXK add dydm VARCHAR(32) NULL --�ϴ���Ӧ����
go
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('GH_NGHMXK') AND name = 'scxmdj') 
	ALTER table GH_NGHMXK add scxmdj ut_money NULL --�ϴ�����
go
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('GH_NGHMXK') AND name = 'scxmsl') 
	ALTER table GH_NGHMXK add scxmsl ut_sl10 NULL --�ϴ�����
go
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('GH_NGHMXK') AND name = 'scxmje') 
	ALTER table GH_NGHMXK add scxmje ut_money NULL --�ϴ����
go

sp_refreshview VW_GHMXK
GO