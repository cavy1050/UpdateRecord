--ҽ�������ֵ����
if not exists(select 1 from sysobjects where name='YY_CQYB_YBSJZD_DZ')
begin
	create table YY_CQYB_YBSJZD_DZ
	(
		zdlb			varchar(20)	not null,	--�ֵ����
		hiscode			varchar(20)	not null,	--his����ֵ
		ybcode			varchar(20)	not null,	--ҽ�����մ���ֵ
		constraint PK_YY_CQYB_YBSJZD_DZ primary key(zdlb,hiscode)
	)
	create index idx_yb_cqyb_ybsjzd_dz_zdlb on YY_CQYB_YBSJZD_DZ(zdlb)
	create index idx_yb_cqyb_ybsjzd_dz_hiscode on YY_CQYB_YBSJZD_DZ(hiscode)
	create index idx_yb_cqyb_ybsjzd_dz_ybcode on YY_CQYB_YBSJZD_DZ(ybcode)
end
go

