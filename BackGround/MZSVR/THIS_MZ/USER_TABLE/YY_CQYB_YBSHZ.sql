--ҽ�������
if not exists(select 1 from sysobjects where name='YY_CQYB_YBSHZ')
begin
	create table YY_CQYB_YBSHZ
	(   
	    id				ut_xh12			NOT NULL IDENTITY(1, 1),	--�����id
		mc			    VARCHAR(64)		NOT NULL,					--��������� 
		jlzt            ut_bz				NULL,					--��¼״̬0��Ч1��Ч
		czyh            VARCHAR(10)         NULL,					--�����û�
	    czrq            DATETIME        NOT NULL,					--��������     
 		constraint PK_YY_CQYB_YBSHZ primary key(id)
	)
end;
GO