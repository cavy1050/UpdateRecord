--ҽ��סԺ�Ǽ���Ϣ
if not exists(select 1 from sysobjects where name='YY_CQYB_ZYJZJLK')
begin  
	create table YY_CQYB_ZYJZJLK
	(      
        syxh			ut_syxh		not null,	--��ҳ���
        sbkh            varchar(20)	not	null,	--��ᱣ�Ϻ���
        xzlb            ut_bz			null,   --�������
        cblb            ut_bz			null,   --�α����
        jzlsh           varchar(20)	not	null,	--סԺ(������)��
        zgyllb          varchar(10)	    null,   --ҽ�����
        ksdm            ut_ksdm			null,   --���Ҵ���
        ysdm            ut_czyh			null,   --ҽ������
        ryrq            varchar(10)		null,   --��Ժ����
        ryzd            varchar(20)		null,	--��Ժ���
        cyrq			varchar(10)		null,	--��Ժ����
        cyzd			varchar(20)		null,	--��Ժ��� 
        cyyy			varchar(10)		null,	--��Ժԭ��
        bfzinfo         varchar(200)	null,	--����֢��Ϣ
        jzzzysj         varchar(10)		null,	--����תסԺʱ��
        bah             varchar(20)		null,   --������
        syzh            varchar(20)		null,   --����֤��
        xsecsrq         varchar(10)		null,	--��������������
        jmyllb          varchar(10)		null,   --�������������
        gsgrbh          varchar(10)		null,   --���˸��˱��
        gsdwbh          varchar(10)		null,   --���˵�λ���
        zryydm			varchar(14)		null,	--ת��ҽԺ����
        jlzt			ut_bz		not null,	--��¼״̬0¼��1�Ǽ�2ҽ������3�Ǽǳ���
        zxlsh           varchar(20)		null,   --������ˮ��
		scsdbz          varchar(3)      null,   --�ϴ���ϸ������־2�����㣬ҽ�����3:�����߿�
		scsdsj          varchar(20)     null,   --�ϴ���ϸ����ʱ��
		zhye            ut_money        null,   --�˻����
		yzcyymc         VARCHAR(50)     null,    --ԭת��ҽԺ����
		lrsj			ut_rq16			null,	--¼��ʱ��
		zzjdjbz			ut_bz			null,	--�Ƿ��������Ǽ�(0���ڡ�1������)
		czyh			ut_czyh         null    --ҽ���Ǽ���
	)
	create index idx_syxh on YY_CQYB_ZYJZJLK(syxh)	
	create index idx_sbkh on YY_CQYB_ZYJZJLK(sbkh)	
	CREATE NONCLUSTERED INDEX idx_yy_cqyb_zyjzjlk_jzlsh ON dbo.YY_CQYB_ZYJZJLK (jzlsh) INCLUDE (sbkh,xzlb,cblb,zgyllb,jmyllb)
end
GO

-- ����zzjdjbz
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('YY_CQYB_ZYJZJLK') AND name = 'zzjdjbz')
BEGIN
	ALTER TABLE YY_CQYB_ZYJZJLK ADD zzjdjbz ut_bz null;	
END
-- ����lrsj 
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('YY_CQYB_ZYJZJLK') AND name = 'lrsj')
BEGIN
	ALTER TABLE YY_CQYB_ZYJZJLK ADD lrsj ut_rq16 null;	
END

--ҽ���Ǽ���
if not exists(select 1 from syscolumns where id=object_id('YY_CQYB_ZYJZJLK') and name='czyh')
	ALTER TABLE YY_CQYB_ZYJZJLK add czyh ut_czyh NULL
GO