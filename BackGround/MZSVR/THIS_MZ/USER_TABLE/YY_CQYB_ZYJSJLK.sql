--ҽ��סԺ������Ϣ
if not exists(select 1 from sysobjects where name='YY_CQYB_ZYJSJLK')
begin  
	create table YY_CQYB_ZYJSJLK
	(      
        jsxh			ut_xh12		not	null,	--�������
        syxh			ut_syxh		not null,	--��ҳ���
        sbkh            varchar(20)	not	null,	--��ᱣ�Ϻ���
        xzlb            ut_bz			null,   --�������
        jzlsh           varchar(20)	not	null,	--סԺ(������)��
        jslb            ut_bz			null,   --�������
        zhzfbz          ut_bz			null,   --�˻�֧����־
        zhdybz          ut_bz			null,	--�˻����ñ�־
        jsqzrq          varchar(19)		null,   --��;������ֹ����
        jszzrq          varchar(19)		null,   --��;������ֹ����
        gsrdbh          varchar(10)		null,   --�����϶����
        gsjbbm          varchar(200)	null,	--�����϶���������
        cfjslx          varchar(10)		null,   --���ν�������
        sylb			varchar(10)		null,	--�������
        sysj			varchar(10)		null,	--����ʱ��
        sybfz			varchar(10)		null,	--��������֢
        ncbz			varchar(10)		null,	--�Ѳ���־
        rslx			varchar(10)		null,	--��������
        dbtbz			varchar(10)		null,	--���̥��־
        syfwzh			varchar(50)		null,	--��������֤��
        jyjc			varchar(200)	null,	--�Ŵ�����������Ŀ
        jhzh			varchar(50)		null,	--���֤��
        gzcybz			ut_bz			null,	--���˳�Ժ��־0δ���˳�Ժ1���˳�Ժ
        jlzt			ut_bz		not null,	--��¼״̬0¼��1Ԥ��2����3ȡ������
        zxlsh           varchar(20)		null,   --������ˮ��
        zxjssj			varchar(20)		null,	--���Ľ���ʱ��
        czlsh           varchar(20)		null,   --����������ˮ��
        zxczsj			varchar(20)		null,	--���ĳ���ʱ��
		ddyljgbm        varchar(20)		null,    --����ҽ�ƻ�������
		lrsj			ut_rq16			null,	--¼��ʱ��
		cyzd			varchar(20)		null,	--��Ժ���
		bfzinfo         varchar(200)	null 	--����֢��Ϣ
		CONSTRAINT PK_YY_CQYB_ZYJSJLK primary key(jsxh)
	)
	create index idx_jsxh on YY_CQYB_ZYJSJLK(jsxh)	
	create index idx_syxh on YY_CQYB_ZYJSJLK(syxh)	
	create index idx_sbkh on YY_CQYB_ZYJSJLK(sbkh)	
end
GO

-- ����lrsj 
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('YY_CQYB_ZYJSJLK') AND name = 'lrsj')
BEGIN
	ALTER TABLE YY_CQYB_ZYJSJLK ADD lrsj ut_rq16 null;	
END

--����ҽ�ƻ�������
if not exists(select 1 from syscolumns where id=object_id('YY_CQYB_ZYJSJLK') and name='ddyljgbm')
	alter table YY_CQYB_ZYJSJLK add ddyljgbm varchar(20) null
go

-- ����cyzd
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('YY_CQYB_ZYJSJLK') AND name = 'cyzd')
BEGIN
	ALTER TABLE YY_CQYB_ZYJSJLK ADD cyzd VARCHAR(20) null;	
END
go

-- ����bfzinfo
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('YY_CQYB_ZYJSJLK') AND name = 'bfzinfo')
BEGIN
	ALTER TABLE YY_CQYB_ZYJSJLK ADD bfzinfo VARCHAR(200) null;	
END
GO
