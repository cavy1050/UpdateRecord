--医保审核组
if not exists(select 1 from sysobjects where name='YY_CQYB_YBSHZ')
begin
	create table YY_CQYB_YBSHZ
	(   
	    id				ut_xh12			NOT NULL IDENTITY(1, 1),	--审核组id
		mc			    VARCHAR(64)		NOT NULL,					--审核组名称 
		jlzt            ut_bz				NULL,					--记录状态0有效1无效
		czyh            VARCHAR(10)         NULL,					--操作用户
	    czrq            DATETIME        NOT NULL,					--操作日期     
 		constraint PK_YY_CQYB_YBSHZ primary key(id)
	)
end;
GO