--������Ϣ��û���ṩǰ̨���ֳ���̨ά��
if not exists(select 1 from sysobjects where name='YY_CQYB_GLXX')
begin
	create table YY_CQYB_GLXX
	(   
	    id				ut_xh12			NOT NULL IDENTITY(1, 1),	--���
		gllb			VARCHAR(3)		NOT NULL,					--�������  ��� YY_CQYB_YBSJZD.zdlb='GLLB' 
		code            VARCHAR(32)     NOT NULL,					--����  ��Ӧ���Ĵ���ֵ
		jlzt            ut_bz				NULL,					--��¼״̬0��Ч1��Ч
		czyh            VARCHAR(10)         NULL,					--�����û�
	    czrq            DATETIME        NOT NULL,					--��������     
 		constraint PK_YY_CQYB_GLXX primary key(id)
	)
	create index idx_yy_cqyb_glxx_syxh on YY_CQYB_GLXX(gllb,code)
end;
GO