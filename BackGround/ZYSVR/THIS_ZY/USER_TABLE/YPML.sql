--ҩƷĿ¼ 
if not exists(select 1 from sysobjects where name='YPML')
CREATE TABLE [dbo].[YPML]
(
	[YPLSH] [varchar] (30) COLLATE Chinese_PRC_BIN NOT NULL primary key ,	--ҩƷ�����գ���ˮ��
	[YPBM] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,			--ҩƷ����
	[TYM] [varchar] (200) COLLATE Chinese_PRC_BIN NULL,			--ͨ����
	[TYMZJM] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--ͨ����������
	[SPM] [varchar] (100) COLLATE Chinese_PRC_BIN NULL,			--��Ʒ��
	[SPMZJM] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--��Ʒ��������
	[YWM] [varchar] (100) COLLATE Chinese_PRC_BIN NULL,			--Ӣ����
	[LBDM] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,			--������
	[CFYBZ] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--����ҩ��־
	[YLFYDJ] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--ҽ�Ʒ��õȼ�
	[GSFYDJ] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--���˷��õȼ�
	[SYFYDJ] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--�������õȼ�
	[PFJ] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,			--������(ҩƷ�����۸�)
	[YLBZDJ] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--ҽ�Ʊ�׼����(ҩƷ�����޼�)
	[GSBZDJ] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--���˱�׼����
	[SYBZDJ] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--������׼����
	[YLZFBL] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--ҽ���Ը�����
	[GSZFBL] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--�����Ը�����
	[SYZFBL] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--�����Ը�����
	[JX] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,			--����
	[BZSL] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,			--��װ����
	[BZDW] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,			--��װ��λ
	[HL] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,			--����
	[HLDW] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,			--������λ
	[RL] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,			--����
	[RLDW] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,			--������λ
	[GMP] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,			--GMP ��־
	[YCMC] [varchar] (200) COLLATE Chinese_PRC_BIN NULL,			--ҩ������
	[YPXJFS] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--ҩƷ�޼۷�ʽ
	[BGSJ] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,			--���ʱ��
	[TQFYDJ] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--��Ⱥ���õȼ�
	[TQZFBL] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--��Ⱥ�Ը�����
	[TQBZDJ] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--��Ⱥ��׼����
	[CJFYDJ] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--�Ǿӷ��õȼ�
	[CJZFBL] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--�Ǿ��Ը�����
	[YJYYCRZFBL] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,	--һ��ҽԺ�����Ը�����
	EJYYCRZFBL [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--����ҽԺ�����Ը�����
	SJYYCRZFBL [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--����ҽԺ�����Ը�����
	YJYYETZFBL [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--һ��ҽԺ��ͯ�Ը�����
	EJYYETZFBL [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--����ҽԺ��ͯ�Ը�����
	SJYYETZFBL [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--����ҽԺ��ͯ�Ը�����
	YJYYDXSZFBL [varchar] (30) COLLATE Chinese_PRC_BIN NULL,	--һ��ҽԺ��ѧ���Ը�����
	EJYYDXSZFBL [varchar] (30) COLLATE Chinese_PRC_BIN NULL,	--����ҽԺ��ѧ���Ը�����
	SJYYDXSZFBL [varchar] (30) COLLATE Chinese_PRC_BIN NULL,	--����ҽԺ��ѧ���Ը�����
	CJBZDJ [varchar] (30) COLLATE Chinese_PRC_BIN NULL,			--�Ǿӱ�׼����
	WSSSYBZ [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--�壨������������ʹ�ñ�־
	XETSYBZ [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--�޶�ͯʹ�ñ�־
	XMZSYBZ [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--������ʹ�ñ�־
	JCYBZ [varchar] (30) COLLATE Chinese_PRC_BIN NULL,			--����ҩ��ʶ
	ZZSJBZ [varchar] (30) COLLATE Chinese_PRC_BIN NULL,			--�����Լ���־
	ZZSJSBJG [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--�����Լ��걨ҽ�ƻ���
	BZ [varchar] (1000) COLLATE Chinese_PRC_BIN NULL,				--��ע
	GSFZQJBJ [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--���˸������߱�־
	GSKFXMBJ [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--���˿�����Ŀ��־
	GSFPGXXMBJ [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--���˷��ݹ�ϴ��Ŀ��־
	FYDJ [varchar] (10) COLLATE Chinese_PRC_BIN NULL,			--ԭҽ�Ʒ��õǼ�
	ZFBL [varchar] (10) COLLATE Chinese_PRC_BIN NULL,			--ԭҽ���Էѱ���
	BZDJ [varchar] (10) COLLATE Chinese_PRC_BIN NULL			--ԭҽ�Ʊ�׼����
)
GO

--ҩƷĿ¼		��ע
if exists(select 1 from sys.syscolumns  where id=object_id('YPML') and name='BZ')
	ALTER table YPML ALTER COLUMN BZ varchar(1000)
else
	ALTER table YPML add BZ varchar(1000)

-- YPML����ԭ�����ֶ�
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('YPML') AND name = 'FYDJ') 
alter table YPML  add 	FYDJ [varchar] (10) COLLATE Chinese_PRC_BIN NULL --ԭҽ�Ʒ��õǼ�
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('YPML') AND name = 'ZFBL') 
alter table YPML  add 	ZFBL [varchar] (10) COLLATE Chinese_PRC_BIN NULL --ԭҽ���Էѱ���
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('YPML') AND name = 'BZDJ') 
alter table YPML  add 	BZDJ [varchar] (10) COLLATE Chinese_PRC_BIN NULL --ԭҽ�Ʊ�׼����