--ҽ�������϶���Ϣ
if not exists(select 1 from sysobjects where name='YY_CQYB_GSRDINFO')
begin  
	create table YY_CQYB_GSRDINFO
	(      
        sbkh			varchar(20)	not	null,	--��ᱣ�Ϻ���
        grbh			varchar(10)	not	null,   --���˱��
        dwbh			varchar(10)	not	null,   --��λ���
        rdbh			varchar(10)	not	null,   --�϶����
        tgbz			varchar(3)	 	null,   --ͨ����־
        sssj			varchar(10)	 	null,   --��������ʱ��
        jssj			varchar(10)	 	null,   --���Ʋο�����ʱ��
        bzinfo			varchar(200)	null,	--�������˲�����Ϣ
        jlzt			ut_bz			null,	--��¼״̬0��Ч1��Ч
	)
	create index idx_sbkh on YY_CQYB_GSRDINFO(sbkh)	
	create index idx_grbh on YY_CQYB_GSRDINFO(grbh)	
	create index idx_dwbh on YY_CQYB_GSRDINFO(dwbh)	
	create index idx_rdbh on YY_CQYB_GSRDINFO(rdbh)
end
go
