--סԺ�˻����ü�¼��
if not exists(select 1 from sysobjects where name='YY_CQYB_ZYDYJLK')
begin  
	create table YY_CQYB_ZYDYJLK
	(      
        jsxh			ut_xh12		not	null,	--�������
        syxh			ut_syxh		not null,	--��ҳ���
        jzlsh           varchar(18)	not	null,	--סԺ(������)��
        zxlsh			varchar(20)		null,	--���㽻����ˮ��(�����ý����¼)
        sbkh            varchar(20)	not	null,	--��ᱣ�Ϻ���
        name            varchar(20)		null,   --��ҽ������
        sfzh            varchar(18)		null,	--סԺ(������)��
		xzqhbm			varchar(10)		null,   --������������
        dykh            varchar(10)	NOT NULL,   --���ÿ���
        dyje			ut_money		null,	--�����ý��
        cblb            varchar(10)		null,   --�α����
        jlzt			ut_bz		not null,	--��¼״̬0¼��1Ԥ��2����3ȡ������
        dyzxlsh			varchar(20)		null,	--���ý�����ˮ��	
        bcdyje          ut_money		null,   --���ε��ý��
        dyrxm           varchar(20)		null,   --����������
        dyrsfzh         varchar(18)		null,	--���������֤��
        dyrzhye         ut_money		null,   --�������˻����
        ydyzje			ut_money		null,   --�ѵ����ܽ��
		constraint PK_YY_CQYB_ZYDYJLK primary key(jsxh,dykh)
	)
	create index idx_jsxh on YY_CQYB_ZYDYJLK(jsxh)	
	create index idx_syxh on YY_CQYB_ZYDYJLK(syxh)	
	create index idx_sbkh on YY_CQYB_ZYDYJLK(sbkh)	
end
GO
