if not exists(select 1 from sysobjects where name='YY_CQYB_CZYHSETDEFAULTBQ')
begin
	create table YY_CQYB_CZYHSETDEFAULTBQ
	(
		czyh       VARCHAR(10)     NOT NULL,       --操作用户
		bqdm       varchar(12)     NOT NULL        --病区代码
	)
	create index idx_yy_cqyb_czyhsetdefaultbq_czyh on YY_CQYB_CZYHSETDEFAULTBQ(czyh)
END
GO
--20180302   增加高收费和血液自动审批，（老医保也适用参数23CQ0009）
--20180905 新医保需要参数CQ52开启