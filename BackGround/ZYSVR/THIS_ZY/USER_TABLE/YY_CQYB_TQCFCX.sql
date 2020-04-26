--特群处方查询(交易类别代码： 38)
if not exists(select 1 from sysobjects where name='YY_CQYB_TQCFCX')
begin
create table YY_CQYB_TQCFCX
(
    patid           varchar(20)	not null,	--病人id
	ybkh			varchar(20)	not null,	--医保卡号
	yllb            varchar(20)	not null,   --医疗类别
	yearmonth       VARCHAR(6) NOT NULL,    --年月
	xmyblsh			varchar(32)	not null,	--项目医保流水号
	sl			    VARCHAR(20)	not NULL,	--数量
	operdate        DATETIME                --获取日期
)
create index IDX_YY_CQYB_TQCFCX_1 on YY_CQYB_TQCFCX(ybkh)
create index IDX_YY_CQYB_TQCFCX_2 on YY_CQYB_TQCFCX(yllb,xmyblsh)
create index IDX_YY_CQYB_TQCFCX_3 on YY_CQYB_TQCFCX(patid)

END
GO
