--ҽ���Զ�������������ϸ
if not exists(select 1 from sysobjects where name='YY_CQYB_ZDYSPFYMX')
begin
	create table YY_CQYB_ZDYSPFYMX
	(   
		syxh			ut_syxh		    NOT null,	--��ҳ���
		jsxh			ut_xh12		    NOT null,	--�������
		xh				ut_xh12		    NOT null,	--��ϸ���
		spjg            VARCHAR(3)      NOT NULL,   --�������  0δ����  1ͨ��  2��ͨ��
		spyy            VARCHAR(1000)        NULL,   --����ԭ��
		czyh            VARCHAR(10)         NULL,   --�����û�
	    czrq            DATETIME        NOT NULL,   --��������  
 		sftb			ut_bz				NULL,	--�Ƿ�ͬ�����ϴ�ҽ��
		constraint PK_YY_CQYB_ZDYSPFYMX primary key(xh)
	)
	create index idx_yy_cqyb_zdyspfymx_syxh_jsxh on YY_CQYB_ZDYSPFYMX(syxh,jsxh)
end;
GO

--�Ƿ�ͬ�����ϴ�ҽ��
if not exists(select 1 from syscolumns where id=object_id('YY_CQYB_ZDYSPFYMX') and name='sftb')
	alter table YY_CQYB_ZDYSPFYMX add sftb ut_bz null
go