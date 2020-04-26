--医保自定义诊断病人审批结果
if not exists(select 1 from sysobjects where name='YY_CQYB_ZDYZDSPJG')
begin
	create table YY_CQYB_ZDYZDSPJG
	(   
		syxh			ut_syxh		    NOT null,	--首页序号
		spjg            VARCHAR(3)      NOT NULL,   --审批结果  0未审批  1通过  2不通过
		spyy            VARCHAR(1000)        NULL,   --审批原因
		czyh            VARCHAR(10)         NULL,   --操作用户
	    czrq            DATETIME        NOT NULL,   --操作日期 
		sjly            VARCHAR(3)          NULL,   --数据来源，0：审批增加，1：人工指定加入可疑患者
		kygjz			VARCHAR(1000)		NULL,	--可疑关键字      
 		constraint PK_YY_CQYB_ZDYZDSPJG primary key(syxh)
	)
	create index idx_yy_cqyb_zdyzdspjg_syxh on YY_CQYB_ZDYZDSPJG(syxh)
end;
GO

--可疑关键字
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('YY_CQYB_ZDYZDSPJG') AND name = 'kygjz')
BEGIN
	ALTER TABLE YY_CQYB_ZDYZDSPJG
	ADD kygjz	VARCHAR(1000) NULL;	
END