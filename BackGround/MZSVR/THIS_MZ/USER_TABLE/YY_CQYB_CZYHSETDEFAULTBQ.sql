if not exists(select 1 from sysobjects where name='YY_CQYB_CZYHSETDEFAULTBQ')
begin
	create table YY_CQYB_CZYHSETDEFAULTBQ
	(
		czyh       VARCHAR(10)     NOT NULL,       --�����û�
		bqdm       varchar(12)     NOT NULL        --��������
	)
	create index idx_yy_cqyb_czyhsetdefaultbq_czyh on YY_CQYB_CZYHSETDEFAULTBQ(czyh)
END
GO
--20180302   ���Ӹ��շѺ�ѪҺ�Զ�����������ҽ��Ҳ���ò���23CQ0009��
--20180905 ��ҽ����Ҫ����CQ52����