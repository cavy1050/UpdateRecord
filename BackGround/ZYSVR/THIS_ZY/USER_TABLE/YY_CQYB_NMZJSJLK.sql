--ҽ�����������Ϣ(���)
if not exists(select 1 from sysobjects where name='YY_CQYB_NMZJSJLK')
begin  
	create table YY_CQYB_NMZJSJLK
	(      
        jssjh			ut_sjh		not	null,	--�վݺ�
        sbkh            varchar(20)	not	null,	--��ᱣ�Ϻ���
        xzlb            ut_bz			null,   --�������
        jzlsh           varchar(20)	not	null,	--סԺ(������)��
        jslb            ut_bz			null,   --�������
        zhzfbz          ut_bz			null,   --�˻�֧����־
        zhdybz          ut_bz			null,	--�˻����ñ�־
        jszzrq          varchar(10)		null,   --��;������ֹ����
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
        jlzt			ut_bz		not null,	--��¼״̬0¼��1Ԥ��2����3ȡ������
        zxlsh           varchar(20)		null,   --������ˮ��
        zxjssj			varchar(20)		null,	--���Ľ���ʱ��
        czlsh           varchar(20)		null,   --����������ˮ��
        zxczsj			varchar(20)		null,	--���ĳ���ʱ��
		ddyljgbm        varchar(10)     null    --����ҽ�ƻ�������
		constraint PK_YY_CQYB_NMZJSJLK primary key(jssjh)
	)
	create index idx_jssjh on YY_CQYB_NMZJSJLK(jssjh)	
	create index idx_sbkh on YY_CQYB_NMZJSJLK(sbkh)	
	CREATE NONCLUSTERED INDEX idx_yy_cqyb_nmzjsjlk_ddyljgbm ON dbo.YY_CQYB_NMZJSJLK (ddyljgbm) INCLUDE (jssjh,xzlb,sylb,zxlsh)
end
go

--����ҽ�ƻ�������
if not exists(select 1 from syscolumns where id=object_id('YY_CQYB_NMZJSJLK') and name='ddyljgbm')
	alter table YY_CQYB_NMZJSJLK add ddyljgbm varchar(20) null
go