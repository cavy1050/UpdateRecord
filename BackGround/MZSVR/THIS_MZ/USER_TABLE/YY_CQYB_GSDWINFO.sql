--ҽ�����˵�λ��Ϣ
if not exists(select 1 from sysobjects where name='YY_CQYB_GSDWINFO')
begin  
	create table YY_CQYB_GSDWINFO
	(      
        sbkh			varchar(20)	not	null,	--��ᱣ�Ϻ���
        grbh			varchar(10)	not	null,   --���˱��
        dwbh			varchar(10)	not	null,   --��λ���
        dwmc			varchar(50)		null,	--��λ����
        jlzt			ut_bz			null,	--��¼״̬0��Ч1��Ч
	)
	create index idx_sbkh on YY_CQYB_GSDWINFO(sbkh)	
	create index idx_grbh on YY_CQYB_GSDWINFO(grbh)	
	create index idx_dwbh on YY_CQYB_GSDWINFO(dwbh)	
end
go
