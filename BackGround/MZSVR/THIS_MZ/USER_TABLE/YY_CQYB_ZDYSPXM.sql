--医保自定义审批项目库
if not exists(select 1 from sysobjects where name='YY_CQYB_ZDYSPXM')
begin
	create table YY_CQYB_ZDYSPXM
	(   
		xh				INT	       IDENTITY(1,1),            --序号
		xmlb            VARCHAR(3)      NOT NULL,            --项目类别 0药品 1诊疗 2诊断
		xmdm			VARCHAR(30)		NOT NULL,	         --项目代码
		xmmc			VARCHAR(100)	 	NULL,	         --项目名称
		jlzt            ut_bz           NOT NULL,            --记录状态 0有效  1无效       
        czyh            varchar(10)     NOT NULL,            --操作用户
		czsj            datetime        NOT NULL             --操作时间
 		constraint PK_YY_CQYB_ZDYSPXM primary key(xh)
	)
	create index idx_yy_cqyb_zdyspxm_xmlb_xmdm on YY_CQYB_ZDYSPXM(xmlb,xmdm)
end;
GO
