--医保时候审批结果
if not exists(select 1 from sysobjects where name='YY_CQYB_SHSPJG')
begin
	create table YY_CQYB_SHSPJG
	(   
		syxh			ut_syxh		    NOT null,	--首页序号
		spjg            VARCHAR(3)      NOT NULL,   --审批结果  0未审批  1通过  2不通过
		spyy            VARCHAR(1000)       NULL,   --审批原因
		czyh            VARCHAR(10)         NULL,   --操作用户
	    czrq            DATETIME        NOT NULL,   --操作日期     
 		constraint PK_YY_CQYB_SHSPJG primary key(syxh)
	)
	create index idx_yy_cqyb_shspje_syxh on YY_CQYB_SHSPJG(syxh)
end;
GO

