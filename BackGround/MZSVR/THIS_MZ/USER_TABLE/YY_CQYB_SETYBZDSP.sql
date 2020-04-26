if not exists(select 1 from sysobjects where name='YY_CQYB_SETYBZDSP')
begin
	create table YY_CQYB_SETYBZDSP
	(
	xzlb ut_bz,			--险种类别  1、医疗保险 2、工伤保险 3、生育保险
	cblb ut_bz,			--参保类别  1、 职工参保 2、 居民参保 3、 离休干部
	ybdm ut_ybdm,		--医保代码（仅参考）
	gsfzdspbz ut_bz,	--高收费审批,0不自动，1自动审批通过，2自动审批不通过
	xyzdspbz ut_bz,		--血液审批，0不自动，1自动审批通过，2自动审批不通过
	xtbz ut_bz			--系统标志，1门诊收费，2住院
	)
end
GO

-- 增加xtbz 1门诊收费2住院
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('YY_CQYB_SETYBZDSP') AND name = 'xtbz')
BEGIN
	ALTER TABLE YY_CQYB_SETYBZDSP ADD xtbz	ut_bz;	
END
