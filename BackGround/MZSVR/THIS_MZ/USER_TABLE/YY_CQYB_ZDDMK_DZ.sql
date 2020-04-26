--诊断对照表
if not exists(select 1 from sysobjects where name='YY_CQYB_ZDDMK_DZ')
begin
	create table YY_CQYB_ZDDMK_DZ
	(   
		xh				ut_xh12    IDENTITY(1,1)	NOT NULL,	--序号
		hiszddm			VARCHAR(20)				NOT NULL,		--HIS诊断代码(YY_ZDDMK.id)
		ybzddm			varchar(20)				NOT NULL,		--医保诊断代码(YY_CQYB_ZDDMK.id)
		syfw			ut_bz					NOT NULL,		--使用范围(0：全部、1：窗口、2：自助机)
		czyh            varchar(10)				NOT NULL,			--操作用户
		czrq            ut_rq16					NOT NULL			--操作日期
	)
	create INDEX idx_yy_cqyb_zddmk_dz_hiszddm on YY_CQYB_ZDDMK_DZ(hiszddm)
	create index idx_yy_cqyb_zddmk_dz_ybzddm on YY_CQYB_ZDDMK_DZ(ybzddm)
end;
GO
