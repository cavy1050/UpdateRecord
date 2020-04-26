--过滤信息表，没有提供前台，现场后台维护
if not exists(select 1 from sysobjects where name='YY_CQYB_GLXX')
begin
	create table YY_CQYB_GLXX
	(   
	    id				ut_xh12			NOT NULL IDENTITY(1, 1),	--序号
		gllb			VARCHAR(3)		NOT NULL,					--过滤类别  详见 YY_CQYB_YBSJZD.zdlb='GLLB' 
		code            VARCHAR(32)     NOT NULL,					--代码  对应类别的代码值
		jlzt            ut_bz				NULL,					--记录状态0有效1无效
		czyh            VARCHAR(10)         NULL,					--操作用户
	    czrq            DATETIME        NOT NULL,					--操作日期     
 		constraint PK_YY_CQYB_GLXX primary key(id)
	)
	create index idx_yy_cqyb_glxx_syxh on YY_CQYB_GLXX(gllb,code)
end;
GO