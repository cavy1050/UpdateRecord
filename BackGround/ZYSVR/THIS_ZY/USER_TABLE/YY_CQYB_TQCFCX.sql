--��Ⱥ������ѯ(���������룺 38)
if not exists(select 1 from sysobjects where name='YY_CQYB_TQCFCX')
begin
create table YY_CQYB_TQCFCX
(
    patid           varchar(20)	not null,	--����id
	ybkh			varchar(20)	not null,	--ҽ������
	yllb            varchar(20)	not null,   --ҽ�����
	yearmonth       VARCHAR(6) NOT NULL,    --����
	xmyblsh			varchar(32)	not null,	--��Ŀҽ����ˮ��
	sl			    VARCHAR(20)	not NULL,	--����
	operdate        DATETIME                --��ȡ����
)
create index IDX_YY_CQYB_TQCFCX_1 on YY_CQYB_TQCFCX(ybkh)
create index IDX_YY_CQYB_TQCFCX_2 on YY_CQYB_TQCFCX(yllb,xmyblsh)
create index IDX_YY_CQYB_TQCFCX_3 on YY_CQYB_TQCFCX(patid)

END
GO
