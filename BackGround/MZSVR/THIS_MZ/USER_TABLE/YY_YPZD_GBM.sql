USE [THIS_MZ]
GO

/****** Object:  Table [dbo].[YY_YPZD_GBM]    Script Date: 2022/3/24 11:00:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[YY_YPZD_GBM](
	[id] [dbo].[ut_mc64] NOT NULL,
	[name] [dbo].[ut_mc64] NOT NULL,
	[jlzt] [dbo].[ut_bz] NOT NULL,
	[py] [dbo].[ut_py] NULL,
	[wb] [dbo].[ut_py] NULL,
	[memo] [dbo].[ut_memo] NULL,
	[bbh] [dbo].[ut_mc64] NULL,
	[spmc] [dbo].[ut_mc64] NULL,
	[zcjx] [dbo].[ut_unit] NULL,
	[zcgg] [dbo].[ut_mc256] NULL,
	[bzcz] [dbo].[ut_mc64] NULL,
	[zxbzsl] [dbo].[ut_sl10] NULL,
	[zxzjdw] [dbo].[ut_unit] NULL,
	[zxbzdw] [dbo].[ut_unit] NULL,
	[ypqy] [dbo].[ut_mc256] NULL,
	[pzwh] [dbo].[ut_mc64] NULL,
	[ypbwm] [dbo].[ut_mc64] NULL,
	[gjybypmljyl] [dbo].[ut_mc64] NULL,
	[gjybypmlbh] [dbo].[ut_mc64] NULL,
	[gjybypmlypmc] [dbo].[ut_mc64] NULL,
	[gjybypmljx] [dbo].[ut_unit] NULL,
	[gjybypmlmemo] [varchar](2000) NULL,
 CONSTRAINT [PK_YY_YPZD_GBM] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING ON
GO


