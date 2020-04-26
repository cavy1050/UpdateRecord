--ҽ�������ֵ�
if not exists(select 1 from sysobjects where name='YY_CQYB_YBSJZD')
begin
	create table YY_CQYB_YBSJZD
	(
		zdlb			varchar(20)	not null,	--�ֵ����
		zdsm			varchar(32)	not null,	--�ֵ�˵��
		code			varchar(20)	not null,	--����ֵ
		name			varchar(64)	not null,	--����˵��	
		xtbz			ut_bz			null,	--ϵͳ��־0����1סԺ
		cblb			ut_bz			null,	--�α����1ְ��ҽ��2����ҽ��3���ݸɲ�	
		xzlb			ut_bz			null,	--�������1ҽ�Ʊ���2���˱���3��������
		py				ut_py			null,	--ƴ��
		wb				ut_py			null,	--���
		jlzt			ut_bz		not	null,	--��Ч��ʶ
	)
	create index idx_yb_cqyb_ybsjzd_zdlb on YY_CQYB_YBSJZD(zdlb)
	create index idx_yb_cqyb_ybsjzd_code on YY_CQYB_YBSJZD(code)
	create index idx_yb_cqyb_ybsjzd_xtbz on YY_CQYB_YBSJZD(xtbz)
	create index idx_yb_cqyb_ybsjzd_cblb on YY_CQYB_YBSJZD(cblb)
	create index idx_yb_cqyb_ybsjzd_xzlb on YY_CQYB_YBSJZD(xzlb)
end
go
