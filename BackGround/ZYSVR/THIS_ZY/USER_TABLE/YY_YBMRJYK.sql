if not exists(select 1 from sysobjects where name='YY_YBMRJYK')
begin
	CREATE TABLE [dbo].[YY_YBMRJYK]
	(
		[xh] [dbo].[ut_xh12] NOT NULL IDENTITY(1, 1),--序号
		[syxh] [dbo].[ut_syxh] NOT NULL,--首页序号
		[centerid] [dbo].[ut_lsh] NULL,--中心住院登记号
		[jsxh] [dbo].[ut_xh12] NOT NULL,--结算序号
		[fyrq] [dbo].[ut_rq8] NOT NULL,--预算日期
		[jlzt] [dbo].[ut_bz] NULL,---记录状态 0 失败 1成功
		[yjlj] [dbo].[ut_money] NULL,--押金累计
		[zje] [dbo].[ut_money] NULL,--总金额
		[yhje] [dbo].[ut_money] NULL,--优惠金额
		[zfyje] [dbo].[ut_money] NULL,--自费金额
		[ybje] [dbo].[ut_money] NULL,--医保金额
		[jsxjzf] [dbo].[ut_money] NULL,--现金支付
		[jszhzf] [dbo].[ut_money] NULL,--账户支付
		[jstczf] [dbo].[ut_money] NULL,--统筹支付
		[jsdbzf] [dbo].[ut_money] NULL,--结算单病种支付
		[jsgwybz] [dbo].[ut_money] NULL,---公务员补助
		[jsgwyret] [dbo].[ut_money] NULL,---公务员返还
		[mzjzje] [dbo].[ut_money] NULL,----民政救助
		[mzjzmzye] [dbo].[ut_money] NULL----民政救助余额
	) ON [PRIMARY]
	ALTER TABLE [dbo].[YY_YBMRJYK] ADD CONSTRAINT [PK_YY_YBMRJYK] PRIMARY KEY CLUSTERED ([syxh], [jsxh], [fyrq]) WITH (FILLFACTOR=100) ON [PRIMARY]
END
GO

