--ҽ��ʱ���������
if not exists(select 1 from sysobjects where name='YY_CQYB_SHSPJG')
begin
	create table YY_CQYB_SHSPJG
	(   
		syxh			ut_syxh		    NOT null,	--��ҳ���
		spjg            VARCHAR(3)      NOT NULL,   --�������  0δ����  1ͨ��  2��ͨ��
		spyy            VARCHAR(1000)       NULL,   --����ԭ��
		czyh            VARCHAR(10)         NULL,   --�����û�
	    czrq            DATETIME        NOT NULL,   --��������     
 		constraint PK_YY_CQYB_SHSPJG primary key(syxh)
	)
	create index idx_yy_cqyb_shspje_syxh on YY_CQYB_SHSPJG(syxh)
end;
GO

