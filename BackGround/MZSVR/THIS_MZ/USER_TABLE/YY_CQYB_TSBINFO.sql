--ҽ�����ⲡ������Ϣ
if not exists(select 1 from sysobjects where name='YY_CQYB_TSBINFO')
begin  
	create table YY_CQYB_TSBINFO
	(      
        sbkh			varchar(20)	not	null,	--��ᱣ�Ϻ���
        bzbm			varchar(20)	not	null,   --���ֱ���
        bzmc			varchar(80)		null,   --��������
        bfz				varchar(200)	null,	--����֢
        jlzt			ut_bz			null,	--��¼״̬0��Ч1��Ч
		id				INT	IDENTITY(1,1),		--���
		timetemp		TIMESTAMP	NOT NULL	--ʱ���
		constraint PK_YY_CQYB_TSBINFO PRIMARY KEY (id)
	)
	create index idx_sbkh on YY_CQYB_TSBINFO(sbkh)
end
GO

if not exists(select 1 from syscolumns where id=object_id('YY_CQYB_TSBINFO') and name='timetemp')
	ALTER TABLE YY_CQYB_TSBINFO add timetemp TIMESTAMP NOT NULL
GO