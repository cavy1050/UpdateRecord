--诊疗项目 
if not exists(select 1 from sysobjects where name='ZLXM')
CREATE TABLE [dbo].[ZLXM]
(
	[LBDM1] [varchar] (3) COLLATE Chinese_PRC_BIN NULL,
	[LBDM2] [varchar] (3) COLLATE Chinese_PRC_BIN NULL,
	[LBDM3] [varchar] (4) COLLATE Chinese_PRC_BIN NULL,
	[LBDM4] [varchar] (6) COLLATE Chinese_PRC_BIN NULL,	
	[XMLSH] [varchar] (14) COLLATE Chinese_PRC_BIN NOT NULL primary key,					--项目流水号				   
	[XMBM] [varchar] (20) COLLATE Chinese_PRC_BIN NULL,						--项目编码				   
	[XMMC] [varchar] (400) COLLATE Chinese_PRC_BIN NULL,					--项目名称				   
	[ZJM] [varchar] (14) COLLATE Chinese_PRC_BIN NULL,						--助记码				   
	[TPJ] [varchar] (14) COLLATE Chinese_PRC_BIN NULL,						--特批价				   
	YLBZJ [varchar] (14) COLLATE Chinese_PRC_BIN NULL,						--医疗标准单价
	GSBZJ [varchar] (14) COLLATE Chinese_PRC_BIN NULL,						--工伤标准单价
	SYBZJ	[varchar] (14) COLLATE Chinese_PRC_BIN NULL,					--生育标准单价						   
	[DW] [varchar] (40) COLLATE Chinese_PRC_BIN NULL,						--单位	   
	[YLFYDJ] [varchar] (3) COLLATE Chinese_PRC_BIN NULL,					--医疗费用等级
	[GSFYDJ] [varchar] (3) COLLATE Chinese_PRC_BIN NULL,					--工伤费用等级	
	[SYFYDJ] [varchar] (3) COLLATE Chinese_PRC_BIN NULL,					--生育费用等级					   
	[YLZFBL] [varchar] (10) COLLATE Chinese_PRC_BIN NULL,					--医疗自付比例							   
	[GSZFBL] [varchar] (10) COLLATE Chinese_PRC_BIN NULL,					--工伤自付比例							   
	[SYZFBL] [varchar] (10) COLLATE Chinese_PRC_BIN NULL,					--生育自付比例							   
	[TXBL] [varchar] (10) COLLATE Chinese_PRC_BIN NULL,					--退休自付比例								   
	[XJFS] [varchar] (3) COLLATE Chinese_PRC_BIN NULL,						--限价方式	   
	[LSF] [varchar] (50) COLLATE Chinese_PRC_BIN NULL,						--另收费	   
	[BZ] [varchar] (1000) COLLATE Chinese_PRC_BIN NULL,						--备注	   
	[BGSJ] [varchar] (20) NULL,													--变更时间	   
	[TPXMBZ] [varchar] (3) COLLATE Chinese_PRC_BIN NULL,					--特批项目标志	   
	[TQFYDJ] [varchar] (3) COLLATE Chinese_PRC_BIN NULL,					--特群费用等级	   
	[TQZFBL] [varchar] (10) COLLATE Chinese_PRC_BIN NULL,					--特群自付比例	   
	[TQBZDJ] [varchar] (10) COLLATE Chinese_PRC_BIN NULL,					--特群标准单价
	CJFYDJ	[varchar] (3) COLLATE Chinese_PRC_BIN NULL,						--城居费用等级
	CJZFBL	 [varchar] (10) COLLATE Chinese_PRC_BIN NULL,					--城居自付比例
	[YJYYCRZFBL] [varchar] (30) COLLATE Chinese_PRC_BIN NULL,				--一级医院成人自付比例
	EJYYCRZFBL [varchar] (30) COLLATE Chinese_PRC_BIN NULL,					--二级医院成人自付比例
	SJYYCRZFBL [varchar] (30) COLLATE Chinese_PRC_BIN NULL,					--三级医院成人自付比例
	YJYYETZFBL [varchar] (30) COLLATE Chinese_PRC_BIN NULL,					--一级医院儿童自付比例
	EJYYETZFBL [varchar] (30) COLLATE Chinese_PRC_BIN NULL,					--二级医院儿童自付比例
	SJYYETZFBL [varchar] (30) COLLATE Chinese_PRC_BIN NULL,					--三级医院儿童自付比例
	YJYYDXSZFBL [varchar] (30) COLLATE Chinese_PRC_BIN NULL,				--一级医院大学生自付比例
	EJYYDXSZFBL [varchar] (30) COLLATE Chinese_PRC_BIN NULL,				--二级医院大学生自付比例
	SJYYDXSZFBL [varchar] (30) COLLATE Chinese_PRC_BIN NULL,				--三级医院大学生自付比例
	CJBZDJ [varchar] (30) COLLATE Chinese_PRC_BIN NULL,						--城居标准单价
	TSYTBJ	[varchar] (30) COLLATE Chinese_PRC_BIN NULL,					--特殊用途标记
	XMNH [varchar] (1000) COLLATE Chinese_PRC_BIN NULL,						--项目内含
	CWNR [varchar] (1000) COLLATE Chinese_PRC_BIN NULL,						--除外内容
	GSFZQJBJ [varchar] (30) COLLATE Chinese_PRC_BIN NULL,					--工伤辅助器具标志
	GSKFXMBJ [varchar] (30) COLLATE Chinese_PRC_BIN NULL,					--工伤康复项目标志
	GSFPGXXMBJ [varchar] (30) COLLATE Chinese_PRC_BIN NULL,					--工伤肺泡灌洗项目标志
	GSKTFBJ [varchar] (30) COLLATE Chinese_PRC_BIN NULL,					--工伤空调费标志
	NHYCXHC	[varchar] (1000) COLLATE Chinese_PRC_BIN NULL,					--内涵一次性耗材
	JJSM	[varchar] (1000) COLLATE Chinese_PRC_BIN NULL,					--计价说明
	[ZGCFJL] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL  DEFAULT ((0)),	--职工拆分甲类	   
	[ZGCFYL15] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--职工拆分乙类(15%)	   
	[ZGCFYL20] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--职工拆分乙类(20%)	   
	[ZGCFCB] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--职工拆分超标	   
	[ZGCFZF] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--职工拆分自费
	[JMCFJL] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--居民拆分甲类
	[JMCFYL15] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--居民拆分乙类(15%)
	[JMCFYL20] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--居民拆分乙类(20%)
	[JMCFCB] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--居民拆分超标
	[JMCFZF] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--居民拆分自费
	[GSCFJL] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--工伤拆分甲类
	[GSCFCB] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--工伤拆分超标
	[GSCFZF] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--工伤拆分自费
	[SYCFJL] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--生育拆分甲类
	[SYCFYL15] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--生育拆分乙类(15%)
	[SYCFYL20] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--生育拆分乙类(20%)
	[SYCFCB] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--生育拆分超标
	[SYCFZF] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--生育拆分自费
	[TQCFJL] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--特群拆分甲类
	[TQCFYL15] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--特群拆分乙类(15%)
	[TQCFYL20] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--特群拆分乙类(20%)
	[TQCFCB] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--特群拆分超标
	[TQCFZF] [nvarchar] (50) COLLATE Chinese_PRC_BIN NULL DEFAULT ((0)),	--特群拆分自费
	ZZSJ	[varchar] (20) COLLATE Chinese_PRC_BIN NULL ,					--终止时间
	JBSJ	[varchar] (20) COLLATE Chinese_PRC_BIN NULL ,					--经办时间			
	[ZGDEBXBZ] varchar(20) NULL  DEFAULT ((0)),								--职工定额报销标准
	[JMDEBXBZ] varchar(20) NULL  DEFAULT ((0)),								--居民定额报销标准
	[YLGGXMBJ] [varchar] (3) COLLATE Chinese_PRC_BIN NULL,					--医疗改革项目标记
	FYDJ [varchar] (10) COLLATE Chinese_PRC_BIN NULL,						--原医疗费用登记
	ZZBL [varchar] (10) COLLATE Chinese_PRC_BIN NULL,						--原医疗自费比例
	BZJ [varchar] (10) COLLATE Chinese_PRC_BIN NULL							--原医疗标准价
) 
GO

--诊疗项目		备注
if exists(select 1 from sys.syscolumns  where id=object_id('ZLXM') and name='BZ')
	ALTER table ZLXM ALTER COLUMN BZ varchar(1000)
else
	ALTER table ZLXM add BZ varchar(1000)

--诊疗项目		项目内含
if exists(select 1 from sys.syscolumns  where id=object_id('ZLXM') and name='XMNH')
	ALTER table ZLXM ALTER COLUMN XMNH varchar(1000)
else
	ALTER table ZLXM add XMNH varchar(1000)

--诊疗项目		除外内容
if exists(select 1 from sys.syscolumns  where id=object_id('ZLXM') and name='CWNR')
	ALTER table ZLXM ALTER COLUMN CWNR varchar(1000)
else
	ALTER table ZLXM add CWNR varchar(1000)

--诊疗项目		内涵一次性耗材
if exists(select 1 from sys.syscolumns  where id=object_id('ZLXM') and name='NHYCXHC')
	ALTER table ZLXM ALTER COLUMN NHYCXHC varchar(1000)
else
	ALTER table ZLXM add NHYCXHC varchar(1000)

--诊疗项目		计价说明
if exists(select 1 from sys.syscolumns  where id=object_id('ZLXM') and name='JJSM')
	ALTER table ZLXM ALTER COLUMN JJSM varchar(1000)
else
	ALTER table ZLXM add JJSM varchar(1000)

-- ZLXM增加原来的字段	
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('ZLXM') AND name = 'FYDJ') 
alter table ZLXM  add 		FYDJ [varchar] (10) COLLATE Chinese_PRC_BIN NULL --原医疗费用登记
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('ZLXM') AND name = 'ZZBL') 	
alter table ZLXM  add 	ZZBL [varchar] (10) COLLATE Chinese_PRC_BIN NULL --原医疗自费比例
IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('ZLXM') AND name = 'BZJ') 	
alter table ZLXM  add 	BZJ [varchar] (10) COLLATE Chinese_PRC_BIN NULL --原医疗标准价