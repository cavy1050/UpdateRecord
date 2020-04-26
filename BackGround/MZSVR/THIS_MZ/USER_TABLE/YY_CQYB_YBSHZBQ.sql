--医保审核组病区
if not exists(select 1 from sysobjects where name='YY_CQYB_YBSHZBQ')
begin
	create table YY_CQYB_YBSHZBQ
	(   
	    shzid			ut_xh12			NOT NULL,					--审核组id
		bqdm			VARCHAR(64)		NOT NULL,					--病区代码
		jlzt            ut_bz				NULL,					--记录状态0有效1无效
		czyh            VARCHAR(10)         NULL,					--操作用户
	    czrq            DATETIME        NOT NULL,					--操作日期     
 		constraint PK_YY_CQYB_YBSHZBQ primary key(shzid,bqdm)
	)
end;
GO

