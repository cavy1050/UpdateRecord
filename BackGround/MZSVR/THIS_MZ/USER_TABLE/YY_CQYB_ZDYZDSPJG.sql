--ҽ���Զ�����ϲ����������
if not exists(select 1 from sysobjects where name='YY_CQYB_ZDYZDSPJG')
begin
	create table YY_CQYB_ZDYZDSPJG
	(   
		syxh			ut_syxh		    NOT null,	--��ҳ���
		spjg            VARCHAR(3)      NOT NULL,   --�������  0δ����  1ͨ��  2��ͨ��
		spyy            VARCHAR(1000)        NULL,   --����ԭ��
		czyh            VARCHAR(10)         NULL,   --�����û�
	    czrq            DATETIME        NOT NULL,   --�������� 
		sjly            VARCHAR(3)          NULL,   --������Դ��0���������ӣ�1���˹�ָ��������ɻ���
		kygjz			VARCHAR(1000)		NULL,	--���ɹؼ���      
 		constraint PK_YY_CQYB_ZDYZDSPJG primary key(syxh)
	)
	create index idx_yy_cqyb_zdyzdspjg_syxh on YY_CQYB_ZDYZDSPJG(syxh)
end;
GO

--���ɹؼ���
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('YY_CQYB_ZDYZDSPJG') AND name = 'kygjz')
BEGIN
	ALTER TABLE YY_CQYB_ZDYZDSPJG
	ADD kygjz	VARCHAR(1000) NULL;	
END