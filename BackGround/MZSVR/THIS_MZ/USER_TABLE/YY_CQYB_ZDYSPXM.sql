--ҽ���Զ���������Ŀ��
if not exists(select 1 from sysobjects where name='YY_CQYB_ZDYSPXM')
begin
	create table YY_CQYB_ZDYSPXM
	(   
		xh				INT	       IDENTITY(1,1),            --���
		xmlb            VARCHAR(3)      NOT NULL,            --��Ŀ��� 0ҩƷ 1���� 2���
		xmdm			VARCHAR(30)		NOT NULL,	         --��Ŀ����
		xmmc			VARCHAR(100)	 	NULL,	         --��Ŀ����
		jlzt            ut_bz           NOT NULL,            --��¼״̬ 0��Ч  1��Ч       
        czyh            varchar(10)     NOT NULL,            --�����û�
		czsj            datetime        NOT NULL             --����ʱ��
 		constraint PK_YY_CQYB_ZDYSPXM primary key(xh)
	)
	create index idx_yy_cqyb_zdyspxm_xmlb_xmdm on YY_CQYB_ZDYSPXM(xmlb,xmdm)
end;
GO
