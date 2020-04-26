--药品目录 
if not exists(select 1 from sysobjects where name='YPML')
CREATE TABLE [dbo].[YPML]
(
	[YPLSH] [varchar] (30) COLLATE Chinese_PRC_BIN NOT NULL primary key ,	--药品（对照）流水号
	[YPBM] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,			--药品编码
	[TYM] [varchar] (200) COLLATE Chinese_PRC_BIN NULL,			--通用名
	[TYMZJM] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--通用名助记码
	[SPM] [varchar] (100) COLLATE Chinese_PRC_BIN NULL,			--商品名
	[SPMZJM] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--商品名助记码
	[YWM] [varchar] (100) COLLATE Chinese_PRC_BIN NULL,			--英文名
	[LBDM] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,			--类别代码
	[CFYBZ] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--处方药标志
	[YLFYDJ] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--医疗费用等级
	[GSFYDJ] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--工伤费用等级
	[SYFYDJ] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--生育费用等级
	[PFJ] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,			--批发价(药品挂网价格)
	[YLBZDJ] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--医疗标准单价(药品国家限价)
	[GSBZDJ] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--工伤标准单价
	[SYBZDJ] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--生育标准单价
	[YLZFBL] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--医疗自付比例
	[GSZFBL] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--工伤自付比例
	[SYZFBL] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--生育自付比例
	[JX] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,			--剂型
	[BZSL] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,			--包装数量
	[BZDW] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,			--包装单位
	[HL] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,			--含量
	[HLDW] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,			--含量单位
	[RL] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,			--容量
	[RLDW] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,			--容量单位
	[GMP] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,			--GMP 标志
	[YCMC] [varchar] (200) COLLATE Chinese_PRC_BIN NULL,			--药厂名称
	[YPXJFS] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--药品限价方式
	[BGSJ] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,			--变更时间
	[TQFYDJ] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--特群费用等级
	[TQZFBL] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--特群自付比例
	[TQBZDJ] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--特群标准单价
	[CJFYDJ] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--城居费用等级
	[CJZFBL] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--城居自付比例
	[YJYYCRZFBL] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,	--一级医院成人自付比例
	EJYYCRZFBL [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--二级医院成人自付比例
	SJYYCRZFBL [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--三级医院成人自付比例
	YJYYETZFBL [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--一级医院儿童自付比例
	EJYYETZFBL [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--二级医院儿童自付比例
	SJYYETZFBL [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--三级医院儿童自付比例
	YJYYDXSZFBL [varchar] (30) COLLATE Chinese_PRC_BIN NULL,	--一级医院大学生自付比例
	EJYYDXSZFBL [varchar] (30) COLLATE Chinese_PRC_BIN NULL,	--二级医院大学生自付比例
	SJYYDXSZFBL [varchar] (30) COLLATE Chinese_PRC_BIN NULL,	--三级医院大学生自付比例
	CJBZDJ [varchar] (30) COLLATE Chinese_PRC_BIN NULL,			--城居标准单价
	WSSSYBZ [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--村（社区）卫生室使用标志
	XETSYBZ [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--限儿童使用标志
	XMZSYBZ [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--限门诊使用标志
	JCYBZ [varchar] (30) COLLATE Chinese_PRC_BIN NULL,			--基础药标识
	ZZSJBZ [varchar] (30) COLLATE Chinese_PRC_BIN NULL,			--自制试剂标志
	ZZSJSBJG [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--自制试剂申报医疗机构
	BZ [varchar] (1000) COLLATE Chinese_PRC_BIN NULL,				--备注
	GSFZQJBJ [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--工伤辅助器具标志
	GSKFXMBJ [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--工伤康复项目标志
	GSFPGXXMBJ [varchar] (30) COLLATE Chinese_PRC_BIN NULL,		--工伤肺泡灌洗项目标志
	FYDJ [varchar] (10) COLLATE Chinese_PRC_BIN NULL,			--原医疗费用登记
	ZFBL [varchar] (10) COLLATE Chinese_PRC_BIN NULL,			--原医疗自费比例
	BZDJ [varchar] (10) COLLATE Chinese_PRC_BIN NULL			--原医疗标准单价
)
GO

--药品目录		备注
if exists(select 1 from sys.syscolumns  where id=object_id('YPML') and name='BZ')
	ALTER table YPML ALTER COLUMN BZ varchar(1000)
else
	ALTER table YPML add BZ varchar(1000)

-- YPML增加原来的字段
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('YPML') AND name = 'FYDJ') 
alter table YPML  add 	FYDJ [varchar] (10) COLLATE Chinese_PRC_BIN NULL --原医疗费用登记
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('YPML') AND name = 'ZFBL') 
alter table YPML  add 	ZFBL [varchar] (10) COLLATE Chinese_PRC_BIN NULL --原医疗自费比例
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('YPML') AND name = 'BZDJ') 
alter table YPML  add 	BZDJ [varchar] (10) COLLATE Chinese_PRC_BIN NULL --原医疗标准单价