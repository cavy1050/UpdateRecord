--�����˻����ü�¼��(���)
if not exists(select 1 from sysobjects where name='YY_CQYB_NMZDYJLK')
begin  
	create table YY_CQYB_NMZDYJLK
	(      
        jssjh			ut_sjh		not	null,	--�վݺ�
        jzlsh           varchar(18)	not	null,	--סԺ(������)��
        zxlsh			varchar(20)		null,	--���㽻����ˮ��(�����ý����¼)
        sbkh            varchar(20)	not	null,	--��ᱣ�Ϻ���
        name            varchar(20)		null,   --��ҽ������
        sfzh            varchar(18)		null,	--סԺ(������)��
		xzqhbm			varchar(10)		null,   --������������
        dykh            varchar(10)	NOT NULL,   --���ÿ���
        dyje			ut_money		null,	--�����ý��
        cblb            ut_bz			null,   --�α����
        jlzt			ut_bz		not null,	--��¼״̬0¼��1Ԥ��2����3ȡ������
        dyzxlsh			varchar(20)		null,	--���ý�����ˮ��	
        bcdyje          ut_money		null,   --���ε��ý��
        dyrxm           varchar(20)		null,   --����������
        dyrsfzh         varchar(18)		null,	--���������֤��
        dyrzhye         ut_money		null,   --�������˻����
        ydyzje			ut_money		null,   --�ѵ����ܽ��
		constraint PK_YY_CQYB_NMZDYJLK primary key(jssjh,dykh)
	)
	create index idx_jssjh on YY_CQYB_NMZDYJLK(jssjh)	
	create index idx_sbkh on YY_CQYB_NMZDYJLK(sbkh)
end
go

