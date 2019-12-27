CREATE TABLE [dbo].[SS_YYSJ](
	[id] [dbo].[ut_xh12] IDENTITY(1,1) NOT NULL,
	[name] [dbo].[ut_mc64] NOT NULL,
	[py] [dbo].[ut_py] NULL,
	[wb] [dbo].[ut_py] NULL,
	[memo] [dbo].[ut_memo] NULL,
 CONSTRAINT [pk_ss_yysj] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]