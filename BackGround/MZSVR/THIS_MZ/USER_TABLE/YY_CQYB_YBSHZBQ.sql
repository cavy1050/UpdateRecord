--ҽ������鲡��
if not exists(select 1 from sysobjects where name='YY_CQYB_YBSHZBQ')
begin
	create table YY_CQYB_YBSHZBQ
	(   
	    shzid			ut_xh12			NOT NULL,					--�����id
		bqdm			VARCHAR(64)		NOT NULL,					--��������
		jlzt            ut_bz				NULL,					--��¼״̬0��Ч1��Ч
		czyh            VARCHAR(10)         NULL,					--�����û�
	    czrq            DATETIME        NOT NULL,					--��������     
 		constraint PK_YY_CQYB_YBSHZBQ primary key(shzid,bqdm)
	)
end;
GO

