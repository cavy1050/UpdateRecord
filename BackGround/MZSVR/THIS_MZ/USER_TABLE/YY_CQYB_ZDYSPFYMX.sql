--医保自定义审批费用明细
if not exists(select 1 from sysobjects where name='YY_CQYB_ZDYSPFYMX')
begin
	create table YY_CQYB_ZDYSPFYMX
	(   
		syxh			ut_syxh		    NOT null,	--首页序号
		jsxh			ut_xh12		    NOT null,	--结算序号
		xh				ut_xh12		    NOT null,	--明细序号
		spjg            VARCHAR(3)      NOT NULL,   --审批结果  0未审批  1通过  2不通过
		spyy            VARCHAR(1000)        NULL,   --审批原因
		czyh            VARCHAR(10)         NULL,   --操作用户
	    czrq            DATETIME        NOT NULL,   --操作日期  
 		sftb			ut_bz				NULL,	--是否同步并上传医保
		constraint PK_YY_CQYB_ZDYSPFYMX primary key(xh)
	)
	create index idx_yy_cqyb_zdyspfymx_syxh_jsxh on YY_CQYB_ZDYSPFYMX(syxh,jsxh)
end;
GO

--是否同步并上传医保
if not exists(select 1 from syscolumns where id=object_id('YY_CQYB_ZDYSPFYMX') and name='sftb')
	alter table YY_CQYB_ZDYSPFYMX add sftb ut_bz null
go
