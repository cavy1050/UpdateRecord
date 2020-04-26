--ҽ�������Ϣ
if not exists(select 1 from sysobjects where name='YY_CQYB_ZDDMK')
begin  
	create table YY_CQYB_ZDDMK
	(      
        id				varchar(20)	not	null,	--��������
        name			varchar(80)	not	null,   --��������
        py				varchar(20)		null,   --ƴ��
        wb				varchar(20)		null,	--���
        bzfl			varchar(10)		not	null default ('') ,	--���ַ���
        jmbzfl			varchar(10)		not	null default ('') ,	--�����ַ���
        sybzfl			varchar(10)		not	null default ('') ,	--�������ַ���
        tjm				varchar(20)		null,	--ͳ����
		bgsj			varchar(20) NULL,		--���ʱ��
		timetemp		TIMESTAMP NOT NULL		--ʱ���
		constraint PK_YY_CQYB_ZDDMK primary key(id,bzfl,sybzfl,jmbzfl)
	)
	create index idx_id on YY_CQYB_ZDDMK(id)	
end
GO

--��ϱ����		���ַ���
if exists(select 1 from sys.syscolumns  where id=object_id('YY_CQYB_ZDDMK') and name='bzfl')
begin
	IF EXISTS(SELECT 1 FROM syscolumns a,systypes b WHERE a.xtype=b.xtype AND a.xusertype=b.xusertype  AND id=OBJECT_ID('YY_CQYB_ZDDMK') AND b.name='ut_bz' AND a.name ='bzfl')
		EXEC sp_unbindefault 'YY_CQYB_ZDDMK.bzfl'

	alter table YY_CQYB_ZDDMK ALTER COLUMN bzfl varchar(10) not null
	
	IF not exists(select  1 from syscolumns a,sysobjects b where a.id=object_id('YY_CQYB_ZDDMK') and b.id=a.cdefault and a.name='bzfl' and b.name like 'DF%')
		alter table YY_CQYB_ZDDMK add default ('') for bzfl with values
end
else
	ALTER table YY_CQYB_ZDDMK add bzfl varchar(10) not null

--��ϱ����		�����ַ���
if exists(select 1 from sys.syscolumns  where id=object_id('YY_CQYB_ZDDMK') and name='jmbzfl')
begin
	if exists(select 1 from syscolumns a,systypes b where a.xtype=b.xtype and a.xusertype=b.xusertype  and id=object_id('YY_CQYB_ZDDMK') and b.name='ut_bz' and a.name ='jmbzfl')
		EXEC sp_unbindefault 'YY_CQYB_ZDDMK.jmbzfl'

	alter table YY_CQYB_ZDDMK ALTER COLUMN jmbzfl varchar(10) not null
	if not exists(select  1 from syscolumns a,sysobjects b where a.id=object_id('YY_CQYB_ZDDMK') and b.id=a.cdefault and a.name='jmbzfl' and b.name like 'DF%')
		alter table YY_CQYB_ZDDMK add default ('') for jmbzfl with values
end
else
	ALTER table YY_CQYB_ZDDMK add jmbzfl varchar(10) default('')

--��ϱ����		�������ַ���
if exists(select 1 from sys.syscolumns  where id=object_id('YY_CQYB_ZDDMK') and name='sybzfl')
begin
	if exists(select 1 from syscolumns a,systypes b where a.xtype=b.xtype and a.xusertype=b.xusertype  and id=object_id('YY_CQYB_ZDDMK') and b.name='ut_bz' and a.name ='sybzfl')
		EXEC sp_unbindefault 'YY_CQYB_ZDDMK.sybzfl'

	alter table YY_CQYB_ZDDMK ALTER COLUMN sybzfl varchar(10)  not null  
	
	IF not exists(select  1 from syscolumns a,sysobjects b where a.id=object_id('YY_CQYB_ZDDMK') and b.id=a.cdefault and a.name='sybzfl' and b.name like 'DF%')
		ALTER table YY_CQYB_ZDDMK add default ('') for sybzfl with values
end
else
	ALTER table YY_CQYB_ZDDMK add sybzfl varchar(10) default('')
--���ʱ��
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('YY_CQYB_ZDDMK') AND name = 'bgsj')
BEGIN
	ALTER TABLE YY_CQYB_ZDDMK ADD bgsj VARCHAR(20) NULL;	
END

if not exists(select 1 from syscolumns where id=object_id('YY_CQYB_ZDDMK') and name='timetemp')
	ALTER TABLE YY_CQYB_ZDDMK add timetemp TIMESTAMP NOT NULL
GO