--ҽ�����˻�����Ϣ��
if not exists(select 1 from sysobjects where name='YY_CQYB_PATINFO')
begin  
	create table YY_CQYB_PATINFO
	(      
		sbkh			varchar(20) not null,	--��ᱣ�Ϻ���
		name			varchar(60)	not	null,	--����
		sex				varchar(20)		null,	--�Ա�
		age				varchar(10)		null,	--ʵ������
		sfzh			varchar(18)		null,	--���֤��
		nation			varchar(20)		null,	--����
		address			varchar(50)		null,   --סַ
		rylb			varchar(10)		null,   --��Ա���
		gwydy			varchar(10)		null,   --�Ƿ����ܹ���Ա����
		dwmc			varchar(50)		null,   --��λ����
		xzqhbm			varchar(14)		null,   --������������
		fszk			varchar(10)		null,   --����״��
		fsyy			varchar(128)	null,   --����ԭ��
		rylxbg			varchar(10)		null,   --��Ա���ͱ��
		rylxbgsj		varchar(20)		null,   --��Ա���ͱ��ʱ��
		dyfskssj		varchar(20)		null,   --����������ʼʱ��
		dyfsjssj		varchar(20)		null,   --����������ֹʱ��
		mzrylb			varchar(10)		null,   --������Ա���
		jmjfdc			varchar(10)		null,   --����ɷѵ���
		cblb			varchar(10)		null,   --�α����
		lxdh			varchar(20)		null,   --������ϵ�绰
		gscbzt			varchar(10)		null,   --���˲α�״̬
		gscbsj			varchar(20)		null,   --���˲α�ʱ��
		gsfszk			varchar(10)		null,   --���˷���״��
		gsfsyy			varchar(128)	null,   --���˷���ԭ��
		gsdyfskssj		varchar(20)		null,   --���˴���������ʼʱ��
		gsdyfsjssj		varchar(20)		null,   --���˴���������ֹʱ��
		zyzz			varchar(10)		null,   --תԺת��
		fzqjcbsp		varchar(10)		null,   --�������߳�������
		sycbsj			varchar(20)		null,   --�����α�ʱ��
		jydjzh			varchar(20)		null,   --��ҽ�Ǽ�֤��
		xsjzbz			varchar(10)		null,   --�Ƿ����ܾ����־
		bxsjzyy			varchar(200)	null,   --�������ܾ���ԭ��
		jydjjjbm		varchar(10)		null,   --��ҽ�Ǽǻ�������
		bfzbz			varchar(10)		null,   --����֢��־
		dyxskssj		varchar(20)		null,   --���ܴ���ʵ�ʿ�ʼʱ��
		dyxsjssj		varchar(20)		null,   --���ܴ���ʵ�ʽ���ʱ��
		dqfprylb		varchar(50)     NULL	--��ǰ��ƶ��Ա���
		constraint PK_YY_CQYB_PATINFO primary key(sbkh)
	)
	create index idx_sbkh on YY_CQYB_PATINFO(sbkh)
	create index idx_name on YY_CQYB_PATINFO(name)
end
go

--01�����޸���������
alter table YY_CQYB_PATINFO ALTER COLUMN name varchar(60) null
go

--20181128   ����1.28�浱ǰ��ƶ��Ա���
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('YY_CQYB_PATINFO') AND name = 'dqfprylb') 	
alter table YY_CQYB_PATINFO  add 	dqfprylb varchar(50)  NULL --��ǰ��ƶ��Ա���