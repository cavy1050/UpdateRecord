--������Ŀ 
if not exists(select 1 from sysobjects where name='ZLXM')
CREATE TABLE [dbo].[ZLXM]
(
	[LBDM1] [varchar] (3) COLLATE Chinese_PRC_BIN NULL,
	[LBDM2] [varchar] (3) COLLATE Chinese_PRC_BIN NULL,
	[LBDM3] [varchar] (4) COLLATE Chinese_PRC_BIN NULL,
	[LBDM4] [varchar] (6) COLLATE Chinese_PRC_BIN NULL,	
	[XMLSH] [varchar] (14) COLLATE Chinese_PRC_BIN NOT NULL primary key,					--��Ŀ��ˮ��				   
	[XMBM] [varchar] (20) COLLATE Chinese_PRC_BIN NULL,						--��Ŀ����				   
	[XMMC] [varchar] (400) COLLATE Chinese_PRC_BIN NULL,					--��Ŀ����				   
	[ZJM] [varchar] (14) COLLATE Chinese_PRC_BIN NULL,						--������				   
	[TPJ] [varchar] (14) COLLATE Chinese_PRC_BIN NULL,						--������				   
	YLBZJ [varchar] (14) COLLATE Chinese_PRC_BIN NULL,						--ҽ�Ʊ�׼����
	GSBZJ [varchar] (14) COLLATE Chinese_PRC_BIN NULL,						--���˱�׼����
	SYBZJ	[varchar] (14) COLLATE Chinese_PRC_BIN NULL,					--������׼����						   
	[DW] [varchar] (40) COLLATE Chinese_PRC_BIN NULL,						--��λ	   
	[YLFYDJ] [varchar] (3) COLLATE Chinese_PRC_BIN NULL,					--ҽ�Ʒ��õȼ�
	[GSFYDJ] [varchar] (3) COLLATE Chinese_PRC_BIN NULL,					--���˷��õȼ�	
	[SYFYDJ] [varchar] (3) COLLATE Chinese_PRC_BIN NULL,					--�������õȼ�					   
	[YLZFBL] [varchar] (10) COLLATE Chinese_PRC_BIN NULL,					--ҽ���Ը�����							   
	[GSZFBL] [varchar] (10) COLLATE Chinese_PRC_BIN NULL,					--�����Ը�����							   
	[SYZFBL] [varchar] (10) COLLATE Chinese_PRC_BIN NULL,					--�����Ը�����							   
	[TXBL] [varchar] (10) COLLATE Chinese_PRC_BIN NULL,					--�����Ը�����								   
	[XJFS] [varchar] (3) COLLATE Chinese_PRC_BIN NULL,						--�޼۷�ʽ	   
	[LSF] [varchar] (50) COLLATE Chinese_PRC_BIN NULL,						--���շ�	   
	[BZ] [varchar] (1000) COLLATE Chinese_PRC_BIN NULL,						--��ע	   
	[BGSJ] [varchar] (20) NULL,													--���ʱ��	   
	[TPXMBZ] [varchar] (3) COLLATE Chinese_PRC_BIN NULL,					--������Ŀ��־	   
	[TQFYDJ] [varchar] (3) COLLATE Chinese_PRC_BIN NULL,					--��Ⱥ���õȼ�	   
	[TQZFBL] [varchar] (10) COLLATE Chinese_PRC_BIN NULL,					--��Ⱥ�Ը�����	   
	[TQBZDJ] [varchar] (10) COLLATE Chinese_PRC_BIN NULL,					--��Ⱥ��׼����
	CJFYDJ	[varchar] (3) COLLATE Chinese_PRC_BIN NULL,						--�Ǿӷ��õȼ�
	CJZFBL	 [varchar] (10) COLLATE Chinese_PRC_BIN NULL,					--�Ǿ��Ը�����
	[YJYYCRZFBL] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,				--һ��ҽԺ�����Ը�����
	EJYYCRZFBL [varchar] (30) COLLATE Chinese_PRC_BIN NULL,					--����ҽԺ�����Ը�����
	SJYYCRZFBL [varchar] (30) COLLATE Chinese_PRC_BIN NULL,					--����ҽԺ�����Ը�����
	YJYYETZFBL [varchar] (30) COLLATE Chinese_PRC_BIN NULL,					--һ��ҽԺ��ͯ�Ը�����
	EJYYETZFBL [varchar] (30) COLLATE Chinese_PRC_BIN NULL,					--����ҽԺ��ͯ�Ը�����
	SJYYETZFBL [varchar] (30) COLLATE Chinese_PRC_BIN NULL,					--����ҽԺ��ͯ�Ը�����
	YJYYDXSZFBL [varchar] (30) COLLATE Chinese_PRC_BIN NULL,				--һ��ҽԺ��ѧ���Ը�����
	EJYYDXSZFBL [varchar] (30) COLLATE Chinese_PRC_BIN NULL,				--����ҽԺ��ѧ���Ը�����
	SJYYDXSZFBL [varchar] (30) COLLATE Chinese_PRC_BIN NULL,				--����ҽԺ��ѧ���Ը�����
	CJBZDJ [varchar] (30) COLLATE Chinese_PRC_BIN NULL,						--�Ǿӱ�׼����
	TSYTBJ	[varchar] (30) COLLATE Chinese_PRC_BIN NULL,					--������;���
	XMNH [varchar] (1000) COLLATE Chinese_PRC_BIN NULL,						--��Ŀ�ں�
	CWNR [varchar] (1000) COLLATE Chinese_PRC_BIN NULL,						--��������
	GSFZQJBJ [varchar] (30) COLLATE Chinese_PRC_BIN NULL,					--���˸������߱�־
	GSKFXMBJ [varchar] (30) COLLATE Chinese_PRC_BIN NULL,					--���˿�����Ŀ��־
	GSFPGXXMBJ [varchar] (30) COLLATE Chinese_PRC_BIN NULL,					--���˷��ݹ�ϴ��Ŀ��־
	GSKTFBJ [varchar] (30) COLLATE Chinese_PRC_BIN NULL,					--���˿յ��ѱ�־
	NHYCXHC	[varchar] (1000) COLLATE Chinese_PRC_BIN NULL,					--�ں�һ���ԺĲ�
	JJSM	[varchar] (1000) COLLATE Chinese_PRC_BIN NULL,					--�Ƽ�˵��
	[ZGCFJL] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL  DEFAULT ((0)),	--ְ����ּ���	   
	[ZGCFYL15] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--ְ���������(15%)	   
	[ZGCFYL20] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--ְ���������(20%)	   
	[ZGCFCB] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--ְ����ֳ���	   
	[ZGCFZF] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--ְ������Է�
	[JMCFJL] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--�����ּ���
	[JMCFYL15] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--����������(15%)
	[JMCFYL20] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--����������(20%)
	[JMCFCB] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--�����ֳ���
	[JMCFZF] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--�������Է�
	[GSCFJL] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--���˲�ּ���
	[GSCFCB] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--���˲�ֳ���
	[GSCFZF] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--���˲���Է�
	[SYCFJL] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--������ּ���
	[SYCFYL15] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--�����������(15%)
	[SYCFYL20] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--�����������(20%)
	[SYCFCB] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--������ֳ���
	[SYCFZF] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--��������Է�
	[TQCFJL] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--��Ⱥ��ּ���
	[TQCFYL15] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--��Ⱥ�������(15%)
	[TQCFYL20] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--��Ⱥ�������(20%)
	[TQCFCB] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--��Ⱥ��ֳ���
	[TQCFZF] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--��Ⱥ����Է�
	ZZSJ	[varchar] (20) COLLATE Chinese_PRC_BIN NULL ,					--��ֹʱ��
	JBSJ	[varchar] (20) COLLATE Chinese_PRC_BIN NULL ,					--����ʱ��			
	[ZGDEBXBZ] varchar(20) NULL  DEFAULT ((0)),								--ְ���������׼
	[JMDEBXBZ] varchar(20) NULL  DEFAULT ((0)),								--���񶨶����׼
	[YLGGXMBJ] [varchar] (3) COLLATE Chinese_PRC_BIN NULL,					--ҽ�Ƹĸ���Ŀ���
	FYDJ [varchar] (10) COLLATE Chinese_PRC_BIN NULL,						--ԭҽ�Ʒ��õǼ�
	ZZBL [varchar] (10) COLLATE Chinese_PRC_BIN NULL,						--ԭҽ���Էѱ���
	BZJ [varchar] (10) COLLATE Chinese_PRC_BIN NULL							--ԭҽ�Ʊ�׼��
) 
GO

--������Ŀ		��ע
if exists(select 1 from sys.syscolumns  where id=object_id('ZLXM') and name='BZ')
	ALTER table ZLXM ALTER COLUMN BZ varchar(1000)
else
	ALTER table ZLXM add BZ varchar(1000)

--������Ŀ		��Ŀ�ں�
if exists(select 1 from sys.syscolumns  where id=object_id('ZLXM') and name='XMNH')
	ALTER table ZLXM ALTER COLUMN XMNH varchar(1000)
else
	ALTER table ZLXM add XMNH varchar(1000)

--������Ŀ		��������
if exists(select 1 from sys.syscolumns  where id=object_id('ZLXM') and name='CWNR')
	ALTER table ZLXM ALTER COLUMN CWNR varchar(1000)
else
	ALTER table ZLXM add CWNR varchar(1000)

--������Ŀ		�ں�һ���ԺĲ�
if exists(select 1 from sys.syscolumns  where id=object_id('ZLXM') and name='NHYCXHC')
	ALTER table ZLXM ALTER COLUMN NHYCXHC varchar(1000)
else
	ALTER table ZLXM add NHYCXHC varchar(1000)

--������Ŀ		�Ƽ�˵��
if exists(select 1 from sys.syscolumns  where id=object_id('ZLXM') and name='JJSM')
	ALTER table ZLXM ALTER COLUMN JJSM varchar(1000)
else
	ALTER table ZLXM add JJSM varchar(1000)

-- ZLXM����ԭ�����ֶ�	
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('ZLXM') AND name = 'FYDJ') 
alter table ZLXM  add 		FYDJ [varchar] (10) COLLATE Chinese_PRC_BIN NULL --ԭҽ�Ʒ��õǼ�
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('ZLXM') AND name = 'ZZBL') 	
alter table ZLXM  add 	ZZBL [varchar] (10) COLLATE Chinese_PRC_BIN NULL --ԭҽ���Էѱ���
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('ZLXM') AND name = 'BZJ') 	
alter table ZLXM  add 	BZJ [varchar] (10) COLLATE Chinese_PRC_BIN NULL --ԭҽ�Ʊ�׼��