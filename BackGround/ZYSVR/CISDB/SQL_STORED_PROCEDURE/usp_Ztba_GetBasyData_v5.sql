ALTER procedure [dbo].[usp_Ztba_GetBasyData_v5] 
  @date1 AS varchar(10),	--开始时间yyyy-MM-dd
  @date2 AS varchar(10),	--结束时间yyyy-MM-dd
  @type  AS INT,			--查询类型，0-全部，1-费用
  @sjlx AS INT,				--时间类型，0-出院时间 1-提交时间
  @yydm AS varchar(100),     --医院代码
  @bah AS varchar(50),		--病案号/@type = 1表示的是hissyxh
  @zycs AS INT,				--住院次数
  @errcode AS INT OUTPUT,	
  @errmsg AS VARCHAR(1000) OUTPUT    
as                                      
/*********                                
[版本号]1.0.0.0.0                                      
[创建时间]2012.12.25                          
[作者]gong_wei                             
[版权] Copyright ? 2012-?上海金仕达卫宁软件股份有限公司                                      
[描述] 电子病历系统病案首页--数据导出                                      
[功能说明]                                      
 批量到导出病人数据                                      
[参数说明]         
          
[返回值]                                      
      fzyzdqzdate        
[结果集、排序]             
       exec  usp_Ztba_GetBasyData '2019-06-01','2019-09-18',1,NULL,NULL      
       exec  usp_Ztba_GetBasyData_v5 '2020-01-01','2020-01-31',0,0,'02','','',NULL,NULL                                     
[调用的sp]                                      
        
[调用实例]            
         
                              
**********/          
set nocount on          
set XACT_ABORT ON --使用存储过程执行事务需要开启XACT_ABORT参数(默认为OFF)        
begin tran --开启事物        
declare @jsrq varchar(20)             
declare @ksrq varchar(20)         
        
set @ksrq=@date1        
set @jsrq=@date2        
        
--set @ksrq=@date1        
--set @jsrq=convert(varchar(10),DATEADD(day,1,@date2),120)        
        
--创建临时表        
if exists(select * from sysobjects where name='#ba1' and xtype='U')         
BEGIN        
 DROP TABLE #ba1        
END        
ELSE        
BEGIN         
 --病案首页信息表        
 create table #ba1                                      
 (        

  FSYXH varchar(20) NOT NULL,    --首页序号                                      
  FIFINPUT bit NOT NULL default(0),    --是否输入         
  FPRN varchar(20) NOT NULL,   --病案号         
  FTIMES int NULL,      --住院次数         
  FICDVERSION tinyint NULL,    --ICD版本         
  FZYID varchar(20) NULL,    --住院流水号         
  FAGE varchar(20) NULL,    --年龄（Y/M/D 开头）        
  FAGENEW varchar(20) NULL,    --年龄（岁）        
  FNLBZYZS NUMERIC(4,2) NULL,    --年龄不足一周岁 按月取          
  FNAME varchar(100) NULL,    --病人姓名         
  FSEXBH varchar(20) NULL,    --性别编号         
  FSEX varchar(20) NULL,    --性别         
  FBIRTHDAY datetime NULL,    --出生日期         
  FBIRTHPLACE varchar(100) NULL,   --出生地_省市        
  FBIRTHPLACE_QX varchar(100) NULL,  --出生地_区县         
  FIDCARD varchar(30) NULL,    --身份证号         
  FCOUNTRYBH varchar(20) NULL,   --国籍编号         
  FCOUNTRY varchar(100) NULL,   --国籍         
  FNATIONALITYBH varchar(20) NULL,  --民族编号         
  FNATIONALITY varchar(50) NULL,  --民族         
  FJOB varchar(100) NULL,    --职业         
  FSTATUSBH varchar(20) NULL,   --婚姻状况编号         
  FSTATUS varchar(20) NULL,    --婚姻状况         
  FDWNAME varchar(200) NULL,    --单位名称         
  FDWADDR varchar(200) NULL,    --单位地址        
  FDWADDRBZ varchar(200) NULL,    --单位地址1
  FHKADDRBZ varchar(200) NULL,    --户口地址(标准第一格)  
  FDWTELE varchar(40) NULL,    --单位电话         
  FDWPOST varchar(20) NULL,    --单位邮编         
  FHKADDR varchar(200) NULL,    --户口地址         
  FHKPOST varchar(20) NULL,    --户口邮编         
  FLXNAME varchar(100) NULL,    --联系人         
  FRELATE varchar(100) NULL,    --与病人关系         
  FLXADDR varchar(200) NULL,    --联系人地址         
  FLXTELE varchar(40) NULL,    --联系人电话         
  FASCARD1 varchar(100) NULL,   --健康卡号         
  FRYDATE datetime NULL,     --入院日期         
  FRYTIME varchar(10) NULL,    --入院时间         
  FRYTYKH varchar(30) NULL,    --入院统一科号         
  FRYDEPT varchar(30) NULL,    --入院科别         
  FRYBS varchar(30) NULL,    --入院病室 
  FCYDATE datetime NULL,     --出院日期         
  FCYTIME varchar(16) NULL,    --出院时间         
  FCYTYKH varchar(30) NULL,    --出院统一科号         
  FCYDEPT varchar(30) NULL,    --出院科别         
  FCYBS varchar(30) NULL,    --出院病室         
  FDAYS int NULL,      --实际住院天数         
  FMZZDBH varchar(20) NULL,    --门（急）诊诊断编码         
  FMZZD varchar(100) NULL,    --门（急）诊诊断疾病名         
  FMZDOCTBH varchar(20) NULL,   --门、急诊医生编号         
  FMZDOCT varchar(50) NULL,    --门、急诊医生     
  FRYINFOBH varchar(20) NULL,   --入院时情况编号        
  FRYINFO  varchar(20) NULL,   --入院时情况        
  FRYZDBH  varchar(20) NULL,   --入院诊断编码        
  FRYZD varchar(100) NULL,   --入院诊断疾病名        
  FZYZDQZDATE datetime NULL,    --确诊日期        
  FPHZD varchar(200) NULL,    --病理诊断         
  FGMYW varchar(1000) NULL,    --过敏药物         
  FMZCYACCOBH varchar(20) NULL,   --门诊与出院诊断符合情况编号         
  FMZCYACCO varchar(20) NULL,   --门诊与出院诊断符合        
  FRYCYACCOBH varchar(20) NULL,   --入院与出院诊断符合情况编号        
  FRYCYACCO varchar(20) NULL,   --入院与出院诊断符合         
  FLCBLACCOBH varchar(20) NULL,   --临床与病理诊断符合情况编号         
  FLCBLACCO varchar(20) NULL,   --临床与病理诊断符合        
  FFSBLACCOBH varchar(20) NULL,   --放射与病理诊断符合情况编号        
  FFSBLACCO varchar(20) NULL,   --放射与病理诊断符合情况        
  FOPACCOBH varchar(20) NULL,   --手术符合编号        
  FOPACCO  varchar(20) NULL,   --手术符合
  FBDYSLBH   varchar(20) NULL,   --冰冻与石蜡诊断符合情况编号  
  FBDYSL   varchar(20) NULL,   --冰冻与石蜡诊断符合情况        
  FQJTIMES int NULL,     --抢救次数         
  FQJSUCTIMES int NULL,     --抢救成功次数         
  FKZRBH varchar(20) NULL,    --科主任编号         
  FKZR varchar(30) NULL,    --科主任         
  FZRDOCTBH varchar(30) NULL,   --主（副主）任医生编号         
  FZRDOCTOR varchar(30) NULL,   --主（副主）任医生         
  FZZDOCTBH varchar(30) NULL,   --主治医生编号         
  FZZDOCT varchar(30) NULL,    --主治医生         
  FZYDOCTBH varchar(30) NULL,   --住院医生编号         
  FZYDOCT varchar(30) NULL,    --住院医生         
  FJXDOCTBH varchar(30) NULL,   --进修医师编号         
  FJXDOCT varchar(30) NULL,    --进修医师         
  FSXDOCTBH varchar(30) NULL,   --实习医师编号         
  FSXDOCT varchar(30) NULL,    --实习医师         
  FBMYBH varchar(30) NULL,    --编码员编号         
  FBMY varchar(30) NULL,    --编码员         
  FZLRBH varchar(20) NULL,    --病案整理者编号         
  FZLR varchar(20) NULL,    --病案整理者         
  FQUALITYBH varchar(20) NULL,   --病案质量编号         
  FQUALITY varchar(20) NULL,   --病案质量         
  FZKDOCTBH varchar(20) NULL,   --质控医师编号         
  FZKDOCT varchar(30) NULL,    --质控医师         
  FZKNURSEBH varchar(20) NULL,   --质控护士编号         
  FZKNURSE varchar(30) NULL,   --质控护士         
  FZKRQ datetime NULL,     --质控日期         
  FSUM1 numeric(18,4) default(0.0000) NULL,    --总费用         
  FXYF numeric(18,4) default(0.0000) NULL,    --西药费         
  FZYF numeric(18,4) default(0.0000) NULL,    --中药费         
  FZCHYF numeric(18,4) default(0.0000) NULL,    --中成药费         
  FZCYF numeric(18,4) default(0.0000) NULL,    --中草药费         
  FQTF numeric(18,4) default(0.0000) NULL,    --其他费         
  FBODYBH varchar(20) NULL,    --是否尸检编号         
  FBODY varchar(20) NULL,    --是否尸检         
  FBLOODBH varchar(20) NULL,   --血型编号         
  FBLOOD varchar(20) NULL,    --血型         
  FRHBH varchar(20) NULL,    --RH编号         
  FRH varchar(20) NULL,     --RH         
  FBABYNUM int NULL,     --婴儿数         
  FTWILL bit NULL,      --是否部分病种         
  FZKTYKH varchar(30) NULL,    --首次转科统一科号         
  FZKDEPT varchar(30) NULL,    --首次转科科别         
  FZKDATE datetime NULL,     --首次转科日期         
  FZKTIME varchar(10) NULL,    --首次转科时间         
  FSRYBH varchar(20) NULL,    --输入员编号         
  FSRY varchar(30) NULL,    --输入员         
  FWORKRQ datetime default(getdate()) NULL,     --输入日期         
  FJBFXBH varchar(20) NULL,    --疾病分型编号    1 一般 2 急 3疑难  4 病重  5 病危         
  FJBFX varchar(20) NULL,    --疾病分型         
  FFHGDBH varchar(20) NULL,    --复合归档编号         
  FFHGD varchar(20) NULL,    --复合归档      
  FSOURCEBH varchar(20) NULL,   --病人来源编号         
  FSOURCE varchar(100) NULL,    --病人来源         
  FIFSS bit NULL,      --是否手术         
  FIFFYK bit NULL,      --是否输入妇婴卡         
  FYNGR int NULL,      --医院感染次数         
  FEXTEND1 varchar(20) NULL,   --扩展1         
  FEXTEND2 varchar(20) NULL,   --扩展2         
  FEXTEND3 varchar(20) NULL,   --扩展3         
  FEXTEND4 varchar(20) NULL,   --扩展4         
  FEXTEND5 varchar(20) NULL,   --扩展5         
  FEXTEND6 varchar(20) NULL,   --扩展6         
  FEXTEND7 varchar(20) NULL,   --扩展7         
  FEXTEND8 varchar(20) NULL,   --扩展8         
  FEXTEND9 varchar(20) NULL,   --扩展9         
  FEXTEND10 varchar(20) NULL,   --扩展10         
  FEXTEND11 varchar(20) NULL,   --扩展11        
  FEXTEND12 varchar(20) NULL,   --扩展12         
  FEXTEND13 varchar(20) NULL,   --扩展13         
  FEXTEND14 varchar(20) NULL,   --扩展14         
  FEXTEND15 varchar(20) NULL,   --扩展15         
  FNATIVE varchar(100) NULL,    --籍贯        
  FNATIVE_QX varchar(100) NULL,   --籍贯_区县         
  FCURRADDR varchar(100) NULL,   --现住址_省        
  FCURRADDR_X varchar(100) NULL,   --现住址_县        
  FCURRADDR_JD varchar(100) NULL,   --现住址_街道        
  FCURRADDRBZ varchar(200) NULL,   --现住址_前         
  FCURRTELE varchar(40) NULL,   --现电话         
  FCURRPOST varchar(20) NULL,   --现邮编         
  FJOBBH varchar(20) NULL,    --职业编号         
  FCSTZ float NULL,      --新生儿出生体重         
  FRYTZ float NULL,      --新生儿入院体重         
  FRYTJBH varchar(20) NULL,    --入院途径编号         
  FRYTJ varchar(20) NULL,    --入院途径         
  FYCLJBH varchar(20) NULL,    --临床路径病例编号         
  FYCLJ varchar(20) NULL,    --临床路径病例         
  FPHZDBH varchar(30) NULL,    --病理疾病编码         
  FPHZDNUM varchar(50) NULL,   --病理号         
  FIFGMYWBH varchar(20) NULL,   --是否药物过敏编号         
  FIFGMYW varchar(20) NULL,    --是否药物过敏         
  FNURSEBH varchar(30) NULL,   --责任护士编号         
  FNURSE varchar(30) NULL,    --责任护士         
  FLYFSBH varchar(20) NULL,    --离院方式编号         
  FLYFS varchar(100) NULL,    --离院方式         
  FYZOUTHOSTITAL varchar(200) NULL,  --离院方式为医嘱转院，拟接收医疗机构名称         
  FSQOUTHOSTITAL varchar(200) NULL,  --离院方式为转社区卫生服务器机构/乡镇卫生院，拟接收医疗机构名称         
  FISAGAINRYBH varchar(20) NULL,  --是否有出院31天内再住院计划编号         
  FISAGAINRY varchar(20) NULL,   --是否有出院31天内再住院计划         
  FISAGAINRYMD varchar(400) NULL,  --再住院目的         
  FRYQHMDAYS int NULL,     --颅脑损伤患者昏迷时间：入院前 天         
  FRYQHMHOURS int NULL,     --颅脑损伤患者昏迷时间：入院前 小时         
  FRYQHMMINS int NULL,     --颅脑损伤患者昏迷时间：入院前 分钟         
  FRYQHMCOUNTS int NULL,    --入院前昏迷总分钟         
  FRYHMDAYS int NULL,     --颅脑损伤患者昏迷时间：入院后 天         
  FRYHMHOURS int NULL,     --颅脑损伤患者昏迷时间：入院后 小时         
  FRYHMMINS int NULL,     --颅脑损伤患者昏迷时间：入院后 分钟 
  FHMSJ   varchar(30) NULL, --昏迷时间      
  FRYHMCOUNTS int NULL,     --入院后昏迷总分钟         
  FFBBHNEW varchar(20) NULL,   --付款方式编号         
  FFBNEW varchar(30) NULL,    --付款方式         
  FZFJE numeric(18,4) default(0.0000) NULL,    --住院总费用：自费金额         
  FZHFWLYLF numeric(18,4) default(0.0000) NULL,   --综合医疗服务类：（1）一般医疗服务费         
  FZHFWLCZF numeric(18,4) default(0.0000) NULL,   --综合医疗服务类：（2）一般治疗操作费         
  FZHFWLHLF numeric(18,4) default(0.0000) NULL,   --综合医疗服务类：（3）护理费         
  FZHFWLQTF numeric(18,4) default(0.0000) NULL,   --综合医疗服务类：（4）其他费用         
  FZDLBLF numeric(18,4) default(0.0000) NULL,    --诊断类：(5) 病理诊断费         
  FZDLSSSF numeric(18,4) default(0.0000) NULL,   --诊断类：(6) 实验室诊断费         
  FZDLYXF numeric(18,4) default(0.0000) NULL,    --诊断类：(7) 影像学诊断费         
  FZDLLCF numeric(18,4) default(0.0000) NULL,    --诊断类：(8) 临床诊断项目费         
  FZLLFFSSF numeric(18,4) default(0.0000) NULL,   --治疗类：(9) 非手术治疗项目费         
  FZLLFWLZWLF numeric(18,4) default(0.0000) NULL,   --治疗类：非手术治疗项目费 其中临床物理治疗费         
  FZLLFSSF numeric(18,4) default(0.0000) NULL,   --治疗类：(10) 手术治疗费         
  FZLLFMZF numeric(18,4) default(0.0000) NULL,   --治疗类：手术治疗费 其中麻醉费         
  FZLLFSSZLF numeric(18,4) default(0.0000) NULL,   --治疗类：手术治疗费 其中手术费         
  FKFLKFF numeric(18,4) default(0.0000) NULL,    --康复类：(11) 康复费         
  FZYLZF numeric(18,4) default(0.0000) NULL,    --中医类：中医治疗类         
  FXYLGJF numeric(18,4) default(0.0000) NULL,    --西药类： 西药费 其中抗菌药物费用         
  FXYLXF numeric(18,4) default(0.0000) NULL,    --血液和血液制品类： 血费         
  FXYLBQBF numeric(18,4) default(0.0000) NULL,   --血液和血液制品类： 白蛋白类制品费         
  FXYLQDBF numeric(18,4) default(0.0000) NULL,   --血液和血液制品类： 球蛋白制品费         
  FXYLYXYZF numeric(18,4) default(0.0000) NULL,   --血液和血液制品类：凝血因子类制品费         
  FXYLXBYZF numeric(18,4) default(0.0000) NULL,   --血液和血液制品类： 细胞因子类费         
  FHCLCJF numeric(18,4) default(0.0000) NULL,    --耗材类：检查用一次性医用材料费         
  FHCLZLF numeric(18,4) default(0.0000) NULL,    --耗材类：治疗用一次性医用材料费         
  FHCLSSF numeric(18,4) default(0.0000) NULL,    --耗材类：手术用一次性医用材料费         
  FZHFWLYLF01 numeric(18,4) default(0.0000) NULL,   --综合医疗服务类：一般医疗服务费 其中中医辨证论治费（中医）         
  FZHFWLYLF02 numeric(18,4) default(0.0000) NULL,   --综合医疗服务类：一般医疗服务费 其中中医辨证论治会诊费（中医）         
  FZYLZDF numeric(18,4) default(0.0000) NULL,    --中医类：诊断（中医）         
  FZYLZLF numeric(18,4) default(0.0000) NULL,    --中医类：治疗（中医）         
  FZYLZLF01 numeric(18,4) default(0.0000) NULL,   --中医类：治疗 其中外治（中医）         
  FZYLZLF02 numeric(18,4) default(0.0000) NULL,   --中医类：治疗 其中骨伤（中医）         
  FZYLZLF03 numeric(18,4) default(0.0000) NULL,   --中医类：治疗 其中针刺与灸法（中医）         
  FZYLZLF04 numeric(18,4) default(0.0000) NULL,   --中医类：治疗推拿治疗（中医）         
  FZYLZLF05 numeric(18,4) default(0.0000) NULL,   --中医类：治疗 其中肛肠治疗（中医）         
  FZYLZLF06 numeric(18,4) default(0.0000) NULL,   --中医类：治疗 其中特殊治疗（中医）         
  FZYLQTF numeric(18,4) default(0.0000) NULL,    --中医类：其他（中医）         
  FZYLQTF01 numeric(18,4) default(0.0000) NULL,   --中医类：其他 其中中药特殊调配加工（中医）         
  FZYLQTF02 numeric(18,4) default(0.0000) NULL,   --中医类：其他 其中辨证施膳（中医）         
  FZCLJGZJF numeric(18,4) default(0.0000) NULL,   --中药类：中成药费 其中医疗机构中药制剂费（中医）         
  NLDAYS int NULL,          --年龄（按天算）        
  FCURRADDRBH  varchar(100) null,       --现住址编号        
  fhkaddrbh varchar(100) null,       --户口地址编号        
  fdwaddrbh varchar(100) null,       --单位地址编号        
  flxaddrbh varchar(100) null,       --联系地址编号        
  FBIRTHPLACEBH varchar(100) null,      --出生地址编号        
  FNATIVEBH varchar(100) null,        --籍贯地址编号    
  --石柱省区版本字段
    FCFFMFSBH VARCHAR (20) null,  --分娩方式
	FHBSAGBH VARCHAR (20) null,  --常规检查:HBsAg
	FHCVABBH VARCHAR (20) null,  --常规检查:HCV-Ab
	FHIVABBH VARCHAR (20) null,  --常规检查:HIV-Ab
	FREDCELL INT null,  --红细胞（单位）
	FPLAQUE INT null,  --血小板（袋）
	FSEROUS INT null,  --血浆（ml）
	FALLBLOOD NUMERIC (18) null,  --全血（ml）
	FQTXHS INT null,  --自体血回收（ml）
	FOTHERBLOOD INT null,  --其他（ml）
	FHLTJ NUMERIC (18,1) null,  --特级护理（天）
	FHL1 NUMERIC (18,1) null,  --一级护理（天）
	FHL2 NUMERIC (18,1) null,  --二级护理（天）
	FHL3 NUMERIC (18,1) null,  --三级护理（天）
	FISOPFIRSTBH VARCHAR (20) null,  --手术、治疗、检查、诊断为本院第一例
	FSZQX VARCHAR (20) null,  --随诊期限：周
	FSZQXY VARCHAR (20) null,  --随诊期限：月
	FSZQXN VARCHAR (20) null,  --随诊期限：年
	FHZQKBH VARCHAR (20) null,  --有无会诊记录
	FCFFMFS VARCHAR (20) null,  --分娩方式
	FHBSAG VARCHAR (20) null,  --常规检查:HBsAg
	FHCVAB VARCHAR (20) null,  --常规检查:HCV-Ab
	FHIVAB VARCHAR (20) null,  --常规检查:HIV-Ab
	FISOPFIRST VARCHAR (20) null,  --手术、治疗、检查、诊断为本院第一例   
	FISSZBH VARCHAR(8) null,  --随诊
	FMZXYSXZD VARCHAR(200) null,  --手写诊断
	FRYXYSXZD VARCHAR(200) null,  --手写诊断
	fphsxzd VARCHAR(200) null,  --手写诊断
    [fryzlkmbh] [varchar](30) NULL,
	[fryzlkm] [varchar](30) NULL,
	[fzkzlkmbh] [varchar](30) NULL,
	[fzkzlkm] [varchar](30) NULL,
	[fcyzlkmbh] [varchar](30) NULL,
	[fcyzlkm] [varchar](30) NULL,
			fyydm          varchar(100) NULL   --医院代码
  )          
END        
if exists(select * from sysobjects where name='#ba2' and xtype='U')         
BEGIN        
 DROP TABLE #ba2        
END        
ELSE        
BEGIN        
 --病案转科表        
 create table #ba2                                 
 (                         
  FSYXH varchar(20) NOT NULL,    --首页序号                      
  FPRN varchar(20) NULL,  --病案号        
  FTIMES int NOT NULL,    --次数        
  FZKTYKH varchar(30) NULL,  --转科统一科号        
  FZKDEPT varchar(30) NULL,  --转科科别        
  FZKDATE datetime NULL,   --转科日期        
  FZKTIME varchar(10) NULL,  --转科时间   
    fyydm          varchar(100) NULL   --医院代码                  
                      
 )           
END        
if exists(select * from sysobjects where name='#ba3' and xtype='U')         
BEGIN        
 DROP TABLE #ba3        
END        
ELSE        
BEGIN        
 --病案诊断表        
 create table #ba3                                      
 (             
  FSYXH varchar(20) NOT NULL,    --首页序号                         
  FPRN varchar(20) NULL,  --病案号        
  FTIMES int NULL,    --次数        
  FZDLX varchar(20) NULL,  --诊断类型        
  FICDVERSION tinyint NULL,  --ICD版本        
  FICDM varchar(30) NULL,  --ICD码        
  FJBNAME varchar(200) NULL,  --疾病名称        
  FRYBQBH varchar(20) NULL,  --入院病情编号        
  FRYBQ varchar(20) NULL,  --入院病情          
  FZLJGBH    varchar(20) NULL ,        
  FZLJG      varchar(20) NULL ,
  FSXZD      varchar(200) NULL ,
  fyydm          varchar(100) NULL   --医院代码        
 )           
END        
if exists(select * from sysobjects where name='#ba4' and xtype='U')         
BEGIN        
 DROP TABLE #ba4        
END        
ELSE        
BEGIN        
 --病案手术表        
 create table #ba4                                      
 (                         
  FSYXH varchar(20) NOT NULL,    --首页序号                      
  FPRN varchar(20) NULL,  --病案号        
  FTIMES int NULL,    --次数        
  FNAME varchar(30) NULL,  --病人姓名        
  FOPTIMES int NULL,   --手术次数        
  FOPCODE varchar(30) NULL,  --手术码        
  FOP varchar(200) NULL,   --手术码对应名称        
  FOPDATE datetime NULL,   --手术日期        
  FQIEKOUBH varchar(20) NULL, --切口编号        
  FQIEKOU varchar(20) NULL,  --切口        
  FYUHEBH varchar(20) NULL,  --愈合编号        
  FYUHE varchar(20) NULL,  --愈合        
  FDOCBH varchar(30) NULL,  --手术医生编号        
  FDOCNAME varchar(30) NULL, --手术医生        
  FMAZUIBH varchar(20) NULL, --麻醉方式编号        
  FMAZUI varchar(30) NULL,  --麻醉方式        
  FIFFSOP bit NULL,    --是否附加手术        
  FOPDOCT1BH varchar(30) NULL, --I助编号        
  FOPDOCT1 varchar(30) NULL, --I助姓名        
  FOPDOCT2BH varchar(30) NULL, --II助编号        
  FOPDOCT2 varchar(30) NULL, --II助姓名        
  FMZDOCTBH varchar(30) NULL, --麻醉医生编号          
  FMZDOCT varchar(30) NULL,  --麻醉医生        
  FZQSSBH varchar(20) NULL,  --择期手术编号   1 择期        
  FZQSS varchar(20) NULL,  --择期手术        
  FSSJBBH varchar(20) NULL,  --手术级别编号        
  FSSJB varchar(20) NULL,  --手术级别        
  FOPKSNAME varchar(30) NULL, --手术医生所在科室名称        
  FOPTYKH varchar(30) NULL,  --手术医生所在科室编号             
  FZYID varchar(20) NULL,      ---his首页序号     
 -- FZQSSBH VARCHAR(20) null,  --择期手术
FFJHZSSBH VARCHAR(20) null,  --是否非计划再手术
FIFSHBFZBH VARCHAR(20) null,  --是否有术后并发症
FSHBFZBH VARCHAR(20) null,  --术后并发症
FIFOPBH VARCHAR(20) null,  --是否手术
FIFJRSSBH VARCHAR(20) null,  --是否介入手术
FSSKSSJ datetime null,  --手术开始时间
FSSJSSJ datetime null,  --手术结束时间
FSSCXSJ VARCHAR(20) null,  --持续时间
FSSXZBH VARCHAR(20) null,  --手术性质
FSSLBBH VARCHAR(20) null,  --手术类别
FIFXJSXMBH VARCHAR(20) null,  --开展手术是否为新技术
FMZKSSJ datetime null,  --麻醉开始时间
FMZJSSJ datetime null,  --麻醉结束时间
FMZFJBH VARCHAR(20) null,  --麻醉分级
FMZBFZBH VARCHAR(20) null,  --麻醉并发症
FSSLTZZSBJBH VARCHAR(20) null,  --手术离体组织是否送病检
FSSFXFJBH VARCHAR(20) null,  --手术风险分级
FIFYFDSSBH VARCHAR(20) null,  --是否有附带手术
FSSFLBH VARCHAR(20) null,  --手术分类
FSSBWGRBH VARCHAR(20) null,  --手术部分是否感染
FGRBWBH VARCHAR(20) null,  --感染部位
FIFSHSWBH VARCHAR(20) null,  --术后是否死亡
FSHSWSJ VARCHAR(20) null,  --术后死亡时间
FSQYFSYKJYWBH VARCHAR(20) null,  --术前是否预防使用抗菌药物
FSQSYYFKJYWSJ VARCHAR(20) null,  --术前预防用抗菌药物时间
FSZZJKJYWBH VARCHAR(20) null,  --术中是否追加1剂抗菌药物
FSZZJKJYWYYBH VARCHAR(20) null,  --术中追加1剂抗菌药物原因
FSHYFSYKJYWBH VARCHAR(20) null,  --术后是否预防使用抗菌药物
FSHYFYKJYWSJ VARCHAR(20) null,  --术后预防用抗菌药物时间
FSSYPFZBFFBH VARCHAR(20) null,  --手术野皮肤准备方法
FSZBDJCBH VARCHAR(20) null,  --术中冰冻检查
FYWFJHZSSBH VARCHAR(20) null,  --有无非计划再手术
FIFSZSXBH VARCHAR(20) null,  --是否术中输血
FSZCXL VARCHAR(30) null,  --术中出血量
FSZSXPZBH VARCHAR(20) null,  --术中输血品种
--FSZSXL VARCHAR(30) null,  --术中输血量
FSSBDYSLBLZDBH VARCHAR(20) null,  --手术冰冻与石蜡病理诊断符合情况
FSQYSHBLZDBH VARCHAR(20) null,  --手术前和术后理诊断符合情况
FIFSZYWYLBH VARCHAR(20) null,  --术中是否有异物遗留
FQSMZSFTWXHBH VARCHAR(20) null,  --全身麻醉中是否属体外循环
FMZYSZTZLBH VARCHAR(20) null,  --是否由麻醉医师实施镇痛治疗
FMZYSZTZLSJBH VARCHAR(20) null,  --由麻醉师镇痛治疗时间
FMZYSXFFSZLBH VARCHAR(20) null,  --是否由麻醉医师实施心肺复苏治疗
FIFXFFSCGBH VARCHAR(20) null,  --心肺复苏是否成功
FIFSTEWARDBH VARCHAR(20) null,  --是否麻醉复苏（Steward苏醒评分）管理 
FJRMZFSSBH VARCHAR(20) null,  --是否进入麻醉复苏室
FSTEWARDPF VARCHAR(20) null,  --离室时Steward评分
FFSMZFYQSJBH VARCHAR(20) null,  --是否发生麻醉非预期的相关事件
FMZFYQXGSJBH VARCHAR(20) null,  --麻醉非预期的相关事件
--FZQSS VARCHAR(20) null,  --择期手术
FFJHZSS VARCHAR(20) null,  --是否非计划再手术
FIFSHBFZ VARCHAR(20) null,  --是否有术后并发症
FSHBFZ VARCHAR(20) null,  --术后并发症
FIFOP VARCHAR(20) null,  --是否手术
FIFJRSS VARCHAR(20) null,  --是否介入手术
FSSXZ VARCHAR(20) null,  --手术性质
FSSLB VARCHAR(20) null,  --手术类别
FIFXJSXM VARCHAR(20) null,  --开展手术是否为新技术
FMZFJ VARCHAR(200) null,  --麻醉分级
FMZBFZ VARCHAR(20) null,  --麻醉并发症
FSSLTZZSBJ VARCHAR(20) null,  --手术离体组织是否送病检
FSSFXFJ VARCHAR(20) null,  --手术风险分级
FIFYFDSS VARCHAR(20) null,  --是否有附带手术
FSSFL VARCHAR(20) null,  --手术分类
FSSBWGR VARCHAR(20) null,  --手术部分是否感染
FGRBW VARCHAR(20) null,  --感染部位
FIFSHSW VARCHAR(20) null,  --术后是否死亡
FSQYFSYKJYW VARCHAR(20) null,  --术前是否预防使用抗菌药物
FSZZJKJYW VARCHAR(20) null,  --术中是否追加1剂抗菌药物
FSZZJKJYWYY VARCHAR(50) null,  --术中追加1剂抗菌药物原因
FSHYFSYKJYW VARCHAR(20) null,  --术后是否预防使用抗菌药物
FSSYPFZBFF VARCHAR(50) null,  --手术野皮肤准备方法
FSZBDJC VARCHAR(20) null,  --术中冰冻检查
FYWFJHZSS VARCHAR(20) null,  --有无非计划再手术
FIFSZSX VARCHAR(20) null,  --是否术中输血
FSZSXPZ VARCHAR(200) null,  --术中输血品种
FSSBDYSLBLZD VARCHAR(20) null,  --手术冰冻与石蜡病理诊断符合情况
FSQYSHBLZD VARCHAR(20) null,  --手术前和术后理诊断符合情况
FIFSZYWYL VARCHAR(20) null,  --术中是否有异物遗留
FQSMZSFTWXH VARCHAR(20) null,  --全身麻醉中是否属体外循环
FMZYSZTZL VARCHAR(20) null,  --是否由麻醉医师实施镇痛治疗
FMZYSZTZLSJ VARCHAR(20) null,  --由麻醉师镇痛治疗时间
FMZYSXFFSZL VARCHAR(20) null,  --是否由麻醉医师实施心肺复苏治疗
FIFXFFSCG VARCHAR(20) null,  --心肺复苏是否成功
FIFSTEWARD VARCHAR(20) null,  --是否麻醉复苏（Steward苏醒评分）管理 
FJRMZFSS VARCHAR(20) null,  --是否进入麻醉复苏室
FFSMZFYQSJ VARCHAR(20) null, --是否发生麻醉非预期的相关事件
FMZFYQXGSJ VARCHAR(50) null , --麻醉非预期的相关事件 
fyydm       varchar(100) NULL   --医院代码          
 )           
END        
if exists(select * from sysobjects where name='#ba5' and xtype='U')         
BEGIN        
 DROP TABLE #ba5        
END        
ELSE        
BEGIN        
 --病案妇婴卡        
 create table #ba5                                      
 (              
  FSYXH varchar(20) NOT NULL,    --首页序号                                 
  FPRN varchar(20) NULL,  --病案号        
  FTIMES int NULL,    --次数        
  FBABYNUM int NULL,   --婴儿序号        
  FNAME varchar(30) NULL,  --病人姓名        
  FBABYSEXBH varchar(20) NULL, --婴儿性别编号        
  FBABYSEX varchar(4) NULL, --婴儿性别        
  FTZ float NULL,     --婴儿体重        
  FRESULTBH varchar(20) NULL, --分娩结果编号        
  FRESULT varchar(20) NULL,  --分娩结果        
  FZGBH varchar(20) NULL,  --转归编号        
  FZG varchar(20) NULL,   --转归        
  FBABYSUC int NULL,   --婴儿抢救成功次数        
  FHXBH varchar(20) NULL,  --呼吸编号        
  FHX varchar(20) NULL,   --呼吸 
  fyydm       varchar(100) NULL   --医院代码                       
 )           
END        
if exists(select * from sysobjects where name='#ba8' and xtype='U')         
BEGIN        
 DROP TABLE #ba8        
END        
ELSE        
BEGIN        
 --病案中医表        
 create table #ba8                  
 (        
  FSYXH varchar(20) NOT NULL,    --首页序号                                 
  FPRN varchar(20) NULL,   --病案号        
  FTIMES int NULL,     --次数        
  FZLLBBH varchar(20) NULL,   --治疗类别编号        
  FZLLB varchar(20) NULL,   --治疗类别        
  FZZZYBH varchar(20) NULL,   --自制中药制剂编号        
  FZZZY varchar(20) NULL,   --自制中药制剂        
  FRYCYBH varchar(20) NULL,   --中医入院与出院符合编号        
  FRYCY varchar(20) NULL,   --中医入院与出院符合        
  FMZZDZBBH varchar(20) NULL,  --中医门诊诊断(主病)编号        
  FMZZDZB varchar(100) NULL,   --中医门诊诊断(主病)名称        
  FMZZDZZBH varchar(20) NULL,  --中医门诊诊断(主证)编号        
  FMZZDZZ varchar(100) NULL,   --中医门诊诊断(主证)名称        
  FMZZYZDBH varchar(30) NULL,  --门（急）诊中医诊断编码        
  FMZZYZD varchar(200) NULL,   --门（急）诊中医诊断        
  FSSLCLJBH varchar(20) NULL,  --实施临床路径编号        
  FSSLCLJ varchar(20) NULL,   --实施临床路径        
  FSYJGZJBH varchar(20) NULL,  --使用医疗机构中药制剂编号        
  FSYJGZJ varchar(20) NULL,   --使用医疗机构中药制剂        
  FSYZYSBBH varchar(20) NULL,  --使用中医诊疗设备编号        
  FSYZYSB varchar(20) NULL,   --使用中医诊疗设备        
  FSYZYJSBH varchar(20) NULL,  --使用中医诊疗技术编号        
  FSYZYJS varchar(20) NULL,   --使用中医诊疗技术        
  FBZSHBH varchar(20) NULL,   --辨证施护编号        
  FBZSH varchar(20) NULL,   --辨证施护
  fyydm       varchar(100) NULL   --医院代码                       
 )           
END      


if exists(select * from sysobjects where name='#His_ba_ahfy' and xtype='U')         
BEGIN        
 DROP TABLE #His_ba_ahfy        
END        
ELSE        
BEGIN    
 create table #His_ba_ahfy                                      
 (   
  FSYXH varchar(20) NOT NULL,    --首页序号
  FPRN varchar(20) NULL,   --病案号        
  FTIMES int NULL,     --次数 
  FKSSSYFA VARCHAR(4) null,  --治疗用药方案
FKSSSYSJ INT null,  --治疗使用时间（小时）
FJRSJ DATETIME null,  --入室时间
FZCSJ DATETIME null,  --出室时间
fyydm       varchar(100) NULL   --医院代码 
  )  
END   

if exists(select * from sysobjects where name='#His_BaFy' and xtype='U')         
BEGIN        
 DROP TABLE #His_BaFy        
END        
ELSE        
BEGIN    
 create table #His_BaFy                                      
 (   
  FSYXH varchar(20) NOT NULL,    --首页序号
  FPRN varchar(20) NULL,   --病案号        
  FTIMES int NULL,     --次数 
FIFFMBH VARCHAR(20) null,  --产科患者是否分娩
FCS VARCHAR(20) null,  --产科病人是否发生产伤
FCSDSBH VARCHAR(20) null,  --产伤度数
FHCXSES INT null,  --活产儿新生儿数
FXSETZDY2KBH VARCHAR(20) null,  --新生儿出生体重是否低于2000克
FIFZCBH VARCHAR(20) null,  --是否早产儿
FXSECSBH VARCHAR(20) null,  --新生儿是否发生产伤
FXSECSGS INT null,  --新生儿发生产伤个数
FISZRY VARCHAR(20) null,  --是否再入院病人
FBCYSCCYJG VARCHAR(50) null,  --本次住院与上次出院间隔
FZRYYYBH VARCHAR(20) null,  --再入院原因
FRYBQFJBH VARCHAR(20) null,  --入院病情分级
FZYZDLXBH VARCHAR(20) null,  --主要诊断疗效
FCYZDLXBH VARCHAR(20) null,  --次要诊断疗效
FZGZDYJBH VARCHAR(20) null,  --病理诊断最高诊断依据
FLCLJBL VARCHAR(20) null,  --是否进入临床路径管理
FSYFYFSCS INT null,  --  输液反应发生次数
FSYFY_FY VARCHAR(20) null,  --有无输液反应
FSXFY_FY VARCHAR(20) null,  --有无输血反应
FSXFYFSCS INT null,  --输血反应发生次数
F24HSXLBH VARCHAR(20) null,  --24小时内输血量是否＞1600ml
FWZBL VARCHAR(20) null,  --危重病例
FYNBL VARCHAR(20) null,  --疑难病例
FISSZBH VARCHAR(8) null,  --随诊
FDBZ_HN VARCHAR(20) null,  --单病种质量控制病例
FDRGGL VARCHAR(20) null,  --相关疾病诊断分组（DRGs）
FIFABZFFBLBH VARCHAR(20) null,  --是否按病种付费病例
FSSKJYW VARCHAR(20) null,  --是否抗菌药物治疗
FIFYFXSYBH VARCHAR(20) null,  --是否预防性使用
FZYKJYW_VALUE VARCHAR(200) null,  --抗菌药物名称
FSFZJKJYWBH VARCHAR(20) null,  --是否特殊级抗菌药物
FKJYWSBYXJC VARCHAR(20) null,  --是否有病原学检测
FWSWJCJGBH VARCHAR(20) null,  --微生物检测结果
FYYXSS VARCHAR(20) null,  --是否有医源性伤害
FHZAQSJ VARCHAR(20) null,  --医源性伤害类型
FZZJH VARCHAR(20) null,  --重症监护时间
FSFYNGR VARCHAR(20) null,  --是否发生医院内感染
FSYZXJMZG VARCHAR(20) null,  --是否使用中心静脉置管
FZXJMZGSYTS INT null,  --使用中心静脉置管总日数（天）
FGLHTZXJMGBH VARCHAR(20) null,  --是否发生管路滑脱
FDGHTYZC VARCHAR(20) null,  --是否再插入
FSYZXJMZGGR VARCHAR(20) null,  --是否发生中心静脉置管相关血流感染
FSYLZDNG VARCHAR(20) null,  --是否使用留置导尿管
FLZDNGSYTS INT null,  --使用留置导尿管总日数（天）
FIFGLHTBH VARCHAR(20) null,  --是否发生管路滑脱
FIFZCRBH VARCHAR(20) null,  --是否再插入
FSYLZDNGGR VARCHAR(20) null,  --是否发生留置导尿管相关泌尿系感染
FXYTX VARCHAR(20) null,  --是否血液透析治疗
FXYTXTS INT null,  --血液透析总日数（天）
FSFXYTXGR VARCHAR(20) null,  --是否发生血液透析感染
FSYHXJ VARCHAR(20) null,  --是否使用呼吸机
FSYHXJGR VARCHAR(20) null,  --是否发生使用呼吸机相关肺炎感染
FSYXHJTS INT null,  --使用呼吸机总日数(天）
FYHXJSJ INT null,  --呼吸机使用时间（小时）
FZRICU VARCHAR(20) null,  --是否进入ICU
FRZICUCS VARCHAR(20) null,  --ICU入住次数
FIFJHRZBH VARCHAR(20) null,  --再次入住是否属计划入住
FZRICUSW VARCHAR(20) null,  --患者是否再ICU期死亡
FSFCFZZYXK VARCHAR(20) null,  --非预期24/48小时重返情况
FTGCTTS INT null,  --在使用呼吸机情况下抬高床头部＞=30度（每日2次）
FYYCWSW VARCHAR(20) null,  --是否死亡
FFSYC VARCHAR(20) null,  --进入ICU前是否有压疮
FSFFSYC VARCHAR(20) null,  --在ICU期间是否发生压疮
FIFAPACCHEBH VARCHAR(20) null,  --是否APACCHE II评分
FAPACCHEPF INT null,  --APACCHE II评分
FSFQDTC VARCHAR(20) null,  --是否发生人工气道脱出
FZRYYY VARCHAR(20) null,  --EMR_BASYK_FB.ZZYYY
FRYBQFJ VARCHAR(20) null,  --EMR_BASYK.RYQK
FZYZDLX VARCHAR(20) null,  --EMR_BASYK.ZLJG
FCYZDLX VARCHAR(20) null,  --EMR_BASYK_FB.ZDYJ
FZGZDYJ VARCHAR(200) null,  --EMR_BASYK_FB.BLZGZDYJ
F24HSXL VARCHAR(20) null,  --EMR_BASYK_FB.SXLDY
FISSZ VARCHAR(8) null,  --EMR_BASYK.SZQK
FIFABZFFBL VARCHAR(20) null,  --EMR_BASYK_FB.SFSRJJXFBZ
FGLHTZXJMG VARCHAR(20) null,  --EMR_BASYK_FB.JZGSFGLHT
FSY VARCHAR(2) null,  --是否输液
FSX VARCHAR(2) null,  --是否输血
FHMSJ   varchar(50) NULL, --昏迷时间  
fyydm       varchar(100) NULL   --医院代码 
  )  
END  


--if exists(select * from sysobjects where name='#his_ba13' and xtype='U')         
--BEGIN        
-- DROP TABLE #his_ba13        
--END        
--ELSE        
--BEGIN    
-- create table #his_ba13                                      
-- (   
--  FPRN varchar(20) NULL,   --病案号        
--  FTIMES int NULL,     --次数 

--  )   
--END  
        
if exists(select * from sysobjects where name='#ba101' and xtype='U')         
BEGIN        
 DROP TABLE #ba101        
END        
ELSE        
BEGIN         
 --病案首页信息表(费用)        
 create table #ba101         
 (            
  --FSYXH varchar(20) NOT NULL,    --首页序号                                   
  FIFINPUT bit NOT NULL default(0),    --是否输入        
  FICDVERSION tinyint NULL,    --ICD版本        
  FZYID varchar(20) NULL,    --住院流水号        
  FPRN varchar(20) NOT NULL,   --病案号         
  FTIMES int NULL,      --住院次数         
  FSUM1 numeric(18,4) default(0.0000) NULL,    --总费用         
  FXYF numeric(18,4) default(0.0000) NULL,    --西药费         
  FZYF numeric(18,4) default(0.0000) NULL,    --中药费         
  FZCHYF numeric(18,4) default(0.0000) NULL,    --中成药费         
  FZCYF numeric(18,4) default(0.0000) NULL,    --中草药费         
  FQTF numeric(18,4) default(0.0000) NULL,    --其他费         
  FZFJE numeric(18,4) default(0.0000) NULL,    --住院总费用：自费金额         
  FZHFWLYLF numeric(18,4) default(0.0000) NULL,   --综合医疗服务类：（1）一般医疗服务费         
  FZHFWLCZF numeric(18,4) default(0.0000) NULL,   --综合医疗服务类：（2）一般治疗操作费         
  FZHFWLHLF numeric(18,4) default(0.0000) NULL,   --综合医疗服务类：（3）护理费         
  FZHFWLQTF numeric(18,4) default(0.0000) NULL,   --综合医疗服务类：（4）其他费用         
  FZDLBLF numeric(18,4) default(0.0000) NULL,    --诊断类：(5) 病理诊断费         
  FZDLSSSF numeric(18,4) default(0.0000) NULL,   --诊断类：(6) 实验室诊断费         
  FZDLYXF numeric(18,4) default(0.0000) NULL,    --诊断类：(7) 影像学诊断费         
  FZDLLCF numeric(18,4) default(0.0000) NULL,    --诊断类：(8) 临床诊断项目费         
  FZLLFFSSF numeric(18,4) default(0.0000) NULL,   --治疗类：(9) 非手术治疗项目费         
  FZLLFWLZWLF numeric(18,4) default(0.0000) NULL,   --治疗类：非手术治疗项目费 其中临床物理治疗费         
  FZLLFSSF numeric(18,4) default(0.0000) NULL,   --治疗类：(10) 手术治疗费         
  FZLLFMZF numeric(18,4) default(0.0000) NULL,   --治疗类：手术治疗费 其中麻醉费         
  FZLLFSSZLF numeric(18,4) default(0.0000) NULL,   --治疗类：手术治疗费 其中手术费         
  FKFLKFF numeric(18,4) default(0.0000) NULL,    --康复类：(11) 康复费         
  FZYLZF numeric(18,4) default(0.0000) NULL,    --中医类：中医治疗类         
  FXYLGJF numeric(18,4) default(0.0000) NULL,    --西药类： 西药费 其中抗菌药物费用         
  FXYLXF numeric(18,4) default(0.0000) NULL,    --血液和血液制品类： 血费         
  FXYLBQBF numeric(18,4) default(0.0000) NULL,   --血液和血液制品类： 白蛋白类制品费         
  FXYLQDBF numeric(18,4) default(0.0000) NULL,   --血液和血液制品类： 球蛋白制品费         
  FXYLYXYZF numeric(18,4) default(0.0000) NULL,   --血液和血液制品类：凝血因子类制品费         
  FXYLXBYZF numeric(18,4) default(0.0000) NULL,   --血液和血液制品类： 细胞因子类费         
  FHCLCJF numeric(18,4) default(0.0000) NULL,    --耗材类：检查用一次性医用材料费         
  FHCLZLF numeric(18,4) default(0.0000) NULL,    --耗材类：治疗用一次性医用材料费         
  FHCLSSF numeric(18,4) default(0.0000) NULL,    --耗材类：手术用一次性医用材料费         
  FZHFWLYLF01 numeric(18,4) default(0.0000) NULL,   --综合医疗服务类：一般医疗服务费 其中中医辨证论治费（中医）         
  FZHFWLYLF02 numeric(18,4) default(0.0000) NULL,   --综合医疗服务类：一般医疗服务费 其中中医辨证论治会诊费（中医）         
  FZYLZDF numeric(18,4) default(0.0000) NULL,    --中医类：诊断（中医）         
  FZYLZLF numeric(18,4) default(0.0000) NULL,    --中医类：治疗（中医）         
  FZYLZLF01 numeric(18,4) default(0.0000) NULL,   --中医类：治疗 其中外治（中医）         
  FZYLZLF02 numeric(18,4) default(0.0000) NULL,   --中医类：治疗 其中骨伤（中医）         
  FZYLZLF03 numeric(18,4) default(0.0000) NULL,   --中医类：治疗 其中针刺与灸法（中医）         
  FZYLZLF04 numeric(18,4) default(0.0000) NULL,   --中医类：治疗推拿治疗（中医）         
  FZYLZLF05 numeric(18,4) default(0.0000) NULL,   --中医类：治疗 其中肛肠治疗（中医）         
  FZYLZLF06 numeric(18,4) default(0.0000) NULL,   --中医类：治疗 其中特殊治疗（中医）         
  FZYLQTF numeric(18,4) default(0.0000) NULL,    --中医类：其他（中医）         
  FZYLQTF01 numeric(18,4) default(0.0000) NULL,   --中医类：其他 其中中药特殊调配加工（中医）         
  FZYLQTF02 numeric(18,4) default(0.0000) NULL,   --中医类：其他 其中辨证施膳（中医）         
  FZCLJGZJF numeric(18,4) default(0.0000) NULL  --中药类：中成药费 其中医疗机构中药制剂费（中医）
                 
  )          
END        
        
if exists(select * from sysobjects where name='#brfymxk' and xtype='U')         
BEGIN        
 DROP TABLE #brfymxk        
END        
ELSE        
BEGIN         
CREATE TABLE #brfymxk (        
  FSYXH varchar(30) NULL ,  --首页序号        
  FPRN varchar(20) NULL ,   --病案号        
  FTIMES int NULL ,      --住院次数        
  FIDM numeric(9) NULL ,   --药IDM        
  FYPDM varchar(24) NULL ,  --药品代码        
  FYPMC varchar(128) NULL ,  --药品名称        
  FDXMDM varchar(12) NULL ,  --大项目代码        
  FZJE decimal(15,2) NULL ,  --总金额        
  FZFJE decimal(15,2) NULL , --自费金额        
  FYHJE decimal(15,2) NULL , --优惠金额        
  FJLZT smallint NULL    --记录状态(0有效记录, 1作废记录, 2退费记录)        
)        
END        
        
        
--select A.HISSYXH HISSYXH, A.SYXH EMRSYXH, A.ZYHM ZYHM,-1 QTBLJLXH into #PAT from EMR_BRSYK A         
--where BRZT in (1502,1503,1504) and A.YEXH=0 and convert(varchar(10),CQRQ,126) between  @ksrq and @jsrq        
        
--获得emr首页病历序号                                   
--UPDATE A SET A.QTBLJLXH=B.QTBLJLXH FROM #PAT A,(select QTBLJLXH,SYXH from EMR_QTBLJLK where YXJL=1 and MXFLDM='B-F7') B WHERE A.EMRSYXH=B.SYXH        
UPDATE EMR_BASYK SET HMMIN1='0' WHERE  HMMIN1 ='数'                  
UPDATE EMR_BASYK SET HMMIN2='0' WHERE  HMMIN2 ='数'        
         
--DELETE FROM #PAT WHERE ISNULL(QTBLJLXH,0)<=0          
        
--select A.BRZT, A.HISSYXH HISSYXH, A.SYXH EMRSYXH, A.ZYHM ZYHM,QTBLJLXH INTO #PAT  from EMR_BRSYK A,(select QTBLJLXH,SYXH,TJSJ from EMR_QTBLJLK where YXJL=1 and MXFLDM='B-F7') B        
--WHERE A.SYXH=B.SYXH AND BRZT in (1502,1503,1504) and  A.YEXH=0 AND TJSJ >=@ksrq AND TJSJ<@jsrq        
        
        
        
if @type=0        
 begin        
  select A.BRZT, A.HISSYXH HISSYXH, A.SYXH EMRSYXH, A.ZYHM ZYHM,QTBLJLXH, A.BAHM FPRN, A.RYCS FTIMES        
  INTO #PAT  from EMR_BRSYK A(nolock),(select QTBLJLXH,SYXH,TJSJ from EMR_QTBLJLK(nolock) where YXJL=1 and MXFLDM='B-F7') B        
  WHERE A.SYXH=B.SYXH AND BRZT in (1502,1503,1504) and  A.YEXH=0 AND CONVERT(varchar(10),TJSJ,126) between @ksrq and dateadd(dd,7,@jsrq) --and A.SYXH='624582'
  --  ---zzz
  -- select A.BRZT, A.HISSYXH HISSYXH, A.SYXH EMRSYXH, A.ZYHM ZYHM,QTBLJLXH, A.BAHM FPRN, A.RYCS FTIMES        
  --INTO PAT  from EMR_BRSYK A,(select QTBLJLXH,SYXH,TJSJ from EMR_QTBLJLK where YXJL=1 and MXFLDM='B-F7') B        
  --WHERE A.SYXH=B.SYXH AND BRZT in (1502,1503,1504) and  A.YEXH=0 AND CONVERT(varchar(10),TJSJ,126) between @ksrq and @jsrq
   
  --处理特殊字段        
  select A.HMDAY1,A.HMMIN1,A.HMHOUR1,A.HMDAY2,A.HMMIN2,A.HMHOUR2,A.XSECSTZ,A.XSERYTZ,A.SYXH into #TSZDCL from EMR_BASYK A(nolock),#PAT B WHERE A.SYXH=B.EMRSYXH        
  update #TSZDCL set XSECSTZ='' where PATINDEX('%[^0-9]%',XSECSTZ)<>0            
  update #TSZDCL set XSERYTZ='' where PATINDEX('%[^0-9]%',XSERYTZ)<>0                                                
  update #TSZDCL set HMDAY1=''  where PATINDEX('%[^0-9]%',HMDAY1)<>0                                                
  update #TSZDCL set HMMIN1=''  where PATINDEX('%[^0-9]%',HMMIN1)<>0                                                
  update #TSZDCL set HMHOUR1='' where PATINDEX('%[^0-9]%',HMHOUR1)<>0                                                
  update #TSZDCL set HMDAY2=''  where PATINDEX('%[^0-9]%',HMDAY2)<>0                                                
  update #TSZDCL set HMHOUR2='' where PATINDEX('%[^0-9]%',HMHOUR2)<>0                                                
  update #TSZDCL set HMHOUR2=''  where PATINDEX('%[^0-9]%',HMHOUR2)<>0         
 end        
         
if @type=1        
 begin        
  select A.BRZT, A.HISSYXH HISSYXH, A.SYXH EMRSYXH, A.ZYHM ZYHM,QTBLJLXH, A.BAHM FPRN, A.RYCS FTIMES        
  INTO #PAT2  from EMR_BRSYK A(nolock),(select QTBLJLXH,SYXH,TJSJ from EMR_QTBLJLK (nolock) where YXJL=1 and MXFLDM='B-F7') B        
  WHERE A.SYXH=B.SYXH AND BRZT in (1502,1503,1504) and  A.YEXH=0 AND CONVERT(varchar(10),CQRQ,126) between @ksrq and @jsrq        
 end        
  
   
        
 IF @type=0  
 begin           
       
 --HIS_病人住院信息（HIS_BA1）                  
 insert into #ba1(FSYXH,FIFINPUT, FPRN, FTIMES, FICDVERSION, FZYID, FAGE, FAGENEW,FNAME, FSEXBH, FSEX
  ,FBIRTHDAY, FBIRTHPLACE, FBIRTHPLACE_QX,FIDCARD, FCOUNTRYBH, FCOUNTRY, FNATIONALITYBH, FNATIONALITY, FJOB
  ,FSTATUSBH, FSTATUS, FDWNAME,FDWADDR , FDWADDRBZ, FDWTELE, FDWPOST, FHKADDR, FHKPOST, FLXNAME, FRELATE, FLXADDR  
  ,FLXTELE, FASCARD1, FRYDATE, FRYTIME, FRYTYKH, FRYDEPT, FRYBS,FCYDATE, FCYTIME, FCYTYKH, FCYDEPT, FCYBS, FDAYS
  ,FMZZDBH, FMZZD, FMZDOCTBH, FMZDOCT, FZYZDQZDATE, FPHZD, FGMYW  
  ,FMZCYACCOBH, FMZCYACCO, FRYCYACCOBH, FRYCYACCO, FLCBLACCOBH, FLCBLACCO,FFSBLACCOBH,FFSBLACCO,FOPACCOBH,FOPACCO,FBDYSLBH,FBDYSL, FQJTIMES, FQJSUCTIMES                  
  ,FKZRBH,FKZR, FZRDOCTBH, FZRDOCTOR, FZZDOCTBH, FZZDOCT, FZYDOCTBH, FZYDOCT                   
  ,FJXDOCTBH, FJXDOCT, FSXDOCTBH, FSXDOCT, FBMYBH, FBMY, FZLRBH, FZLR, FQUALITYBH, FQUALITY                  
  ,FZKDOCTBH, FZKDOCT, FZKNURSEBH, FZKNURSE, FZKRQ,FBODYBH, FBODY, FBLOODBH, FBLOOD                  
  ,FRHBH, FRH, FBABYNUM, FTWILL, FJBFXBH, FJBFX, FSOURCEBH, FSOURCE, FIFSS, FIFFYK, FYNGR                  
  ,FNATIVE, FNATIVE_QX, FCURRADDR,FCURRADDR_X,FCURRADDR_JD,FCURRTELE, FCURRPOST, FJOBBH, FCSTZ, FRYTZ, FRYTJBH, FRYTJ                  
  ,FYCLJBH, FYCLJ, FPHZDBH, FPHZDNUM,FIFGMYWBH, FIFGMYW, FNURSEBH
  , FNURSE, FLYFSBH, FLYFS,FYZOUTHOSTITAL, FSQOUTHOSTITAL                   
  ,FISAGAINRYBH,FISAGAINRY, FISAGAINRYMD, FRYQHMDAYS, FRYQHMHOURS, FRYQHMMINS                  
  ,FRYQHMCOUNTS                  
  ,FRYHMDAYS, FRYHMHOURS, FRYHMMINS, FRYHMCOUNTS                   
  ,FFBBHNEW, FFBNEW ,FRYZDBH,FRYZD
  ,FCFFMFSBH,FHBSAGBH,FHCVABBH,FHIVABBH,FREDCELL,FPLAQUE,FSEROUS,FALLBLOOD,FQTXHS,FOTHERBLOOD,FHLTJ,FHL1,FHL2,FHL3,FISOPFIRSTBH,FSZQX,FSZQXY,FSZQXN,FHZQKBH,FISSZBH,FMZXYSXZD,FRYXYSXZD,fphsxzd,FHKADDRBZ ,fryzlkmbh,fzkzlkmbh,fcyzlkmbh  ,fyydm            
 )                      
select A.SYXH FSYXH,'0' FIFINPUT, A.BAHM FPRN,B.RYCS FTIMES,'11' FICDVERSION,A.HISSYXH FZYID,A.XSNL FAGE,A.XSNL FAGENEW,A.HZXM FNAME ,A.BRXB FSEXBH ,'' FSEX,                  
  A.CSRQ FBIRTHDAY ,isnull(SSDM,'-') FBIRTHPLACE,isnull(QXDM,'-') FBIRTHPLACE_QX,isnull(A.SFZH,'-') FIDCARD ,A.GJDM FCOUNTRYBH ,'中国' FCOUNTRY,A.MZDM FNATIONALITYBH ,
  '' FNATIONALITY,'' FJOB,                  
  A.HYZK FSTATUSBH,'' FSTATUS,isnull(substring(A.GZDW,1,30),'-') FDWNAME,isnull(substring(A.GZDW,1,30),'-') FDWADDR,isnull(substring(A.DWDZ,1,30),'-') FDWADDRBZ,isnull(A.DWDH,'-') FDWTELE,isnull(A.DWYB,'-') FDWPOST,
  A.HKDZ FHKADDR,isnull(A.HKYB,'-') FHKPOST,A.LXRM FLXNAME,A.LXGX FRELATE,isnull(substring(A.LXDZ,1,30),'-') FLXADDR,                  
  A.LXDH FLXTELE,B.JKKH FASCARD1,substring(A.RQRQ,1,10) FRYDATE,substring(A.RQRQ,12,5) FRYTIME,A.RYKS FRYTYKH,'' FRYDEPT,A.RYBQ FRYBS
  ,substring(A.CQRQ,1,10) FCYDATE,substring(A.CQRQ,12,5) FCYTIME ,A.CYKS FCYTYKH,'' FCYDEPT,A.CYBQ FCYBS,isnull(B.ZYTS,A.ZYTS) FDAYS
  ,B.MZZD FMZZDBH,isnull(convert(varchar(100),substring(B.MZZDMC,1,30)),'-') FMZZD,B.MZYS FMZDOCTBH,'' FMZDOCT,isnull(dateadd(dd,1,A.RYRQ),B.QZRQ) FZYZDQZDATE,
  isnull(substring(B.BLZDMC,1,30),'-') FPHZD,isnull(B.GMYWMC,'-') FGMYW  
  , B.MCFH FMZCYACCOBH ,'' FMZCYACCO,B.RCFH FRYCYACCOBH,'' FRYCYACCO,B.BLFH FLCBLACCOBH ,'' FLCBLACCO,B.FSFH FFSBLACCOBH,'' FFSBLACCO,B.QHFH FOPACCOBH,'' FOPACCO,B.BDFH FBDYSLBH,'' FBDYSL,B.QJCS FQJTIMES,B.CGCS FQJSUCTIMES,                 
  B.KZR FKZRBH,'' FKZR,B.ZRYS FZRDOCTBH ,'' FZRDOCTBH,B.ZZYS FZZDOCTBH,'' FZZDOCT,B.ZYYS FZYDOCTBH,'' FZYDOCT,                  
  B.JXYS FJXDOCTBH,'' FJXDOCT,B.SXYS2 FSXDOCTBH,'' FSXDOCT,B.BMY FBMYBH,'' FBMY,B.ZLRY FZLRBH,'' FZLR,B.BAZL FQUALITYBH,'' FQUALITY,                  
  B.ZKYS FZKDOCTBH,'' FZKDOCT,B.ZKHS FZKNURSEBH,'' FZKNURSE,CASE WHEN ISNULL(B.BARQ,'')='' THEN NULL ELSE B.BARQ END FZKRQ,B.SJQK FBODYBH,'' FBODY,        
  CASE WHEN B.XXDM='3' THEN '4' WHEN B.XXDM='4' THEN '3' ELSE B.XXDM END FBLOODBH ,'' FBLOOD,                  
  B.RHJY FRHBH,'' FRH,B.YETB FBABYNUM,0 FTWILL,B.BLFX FJBFXBH,'' FJBFX,B.BRLY FSOURCEBH,'' FSOURCE ,B.SSBZ FIFSS ,0 FIFFYK,isnull(GRCS,0) FYNGR,                  
  JGSSDM FNATIVE ,JGQXDM FNATIVE_QX,A.DQDZ_S FCURRADDR,A.DQDZ_X FCURRADDR_X,substring(A.DQDZ,1,30) FCURRADDR_JD,A.DQDZDH FCURRTELE,isnull(A.DQDZYB,'-') FCURRPOST,A.ZYDM FJOBBH,CASE WHEN B.XSECSTZ LIKE '%-%' then null  WHEN isnumeric(B.XSECSTZ)=0 THEN NULL ELSE B.XSECSTZ END FCSTZ,                
  CASE WHEN isnumeric(B.XSERYTZ)=0 THEN NULL ELSE B.XSERYTZ  END FRYTZ,B.RYTJ FRYTJBH ,'' FRYTJ,                  
  B.SSLCLJ FYCLJBH,'' FYCLJ,case isnumeric(B.BLZD) when 0 then NULL else B.BLZD end FPHZDBH,B.BLBH FPHZDNUM,B.YWGM FIFGMYWBH ,'' FIFGMYW,B.ZRHS FNURSEBH,'' FNURSE,B.LYFS FLYFSBH ,'' FLYFS,B.JSYLJG1 FYZOUTHOSTITAL,JSYLJG2 FSQOUTHOSTITAL,                  


  B.ZZYJH FISAGAINRYBH,'' FISAGAINRY,B.ZZYMD FISAGAINRYMD,Q.HMDAY1 FRYQHMDAYS,Q.HMHOUR1 FRYQHMHOURS,Q.HMMIN1 FRYQHMMINS,                  
  cast(isnull(Q.HMDAY1,0) as int)*24*60 + cast(isnull(Q.HMHOUR1,0) as int)*60 + cast(isnull(Q.HMMIN1,0) as int) FRYQHMCOUNTS,                  
  Q.HMDAY2 FRYHMDAYS,Q.HMHOUR2 FRYHMHOURS,Q.HMMIN2 FRYHMMINS,                  
  cast(isnull(Q.HMDAY2,0) as int)*24*60 + cast(isnull(Q.HMHOUR2,0) as int)*60 + cast(isnull(Q.HMMIN2,0) as int) FRYHMCOUNTS,                  
  A.BRXZ FFBBHNEW,'' FFBNEW ,B.RYZD FRYZDBH,convert(varchar(40),substring(B.RYZDMC,1,30)) FRYZD
  ,
  D.CFMFFS FCFFMFSBH,	B.HY1 FHBSAGBH,	B.HY2 FHCVABBH,	B.HY3 FHIVABBH,
  case when isnumeric(B.SXPZ1)=0 then NULL else round(B.SXPZ1,0) end  FREDCELL,case when isnumeric(B.SXPZ2)=0 then NULL else B.SXPZ2 end FPLAQUE,
  case when isnumeric(B.SXPZ3)=0 then NULL else B.SXPZ3 end FSEROUS,case when isnumeric(B.SXPZ4)=0 then NULL else B.SXPZ4 end FALLBLOOD,
  D.ZTXHS FQTXHS,B.SXPZ5 FOTHERBLOOD,REPLACE(REPLACE(ISNULL(D.TJHL,'0'),'','0'),'-','0') FHLTJ,REPLACE(REPLACE(ISNULL(D.YJHL,'0'),'','0'),'-','0') FHL1,REPLACE(REPLACE(ISNULL(D.EJHL,'0'),'','0'),'-','0') FHL2,REPLACE(REPLACE(ISNULL(D.SJHL,'0'),'','0'),'-','0') FHL3,B.DYCZL FISOPFIRSTBH,case when B.SZDW='0' THEN B.SZQX ELSE 0 END FSZQX,case when B.SZDW='1' THEN B.SZQX ELSE 0 END FSZQXY,case when B.SZDW='2' THEN B.SZQX ELSE 0 END FSZQXN,
  D.SFHZ FHZQKBH ,B.SZQK FISSZBH,convert(varchar(100),substring(B.MZZDMC,1,30)) FMZXYSXZD,convert(varchar(100),substring(B.RYZDMC,1,30)) FRYXYSXZD,substring(B.BLZDMC,1,30) fphsxzd , '-' FHKADDRBZ,convert(varchar(30),B.RYZLKM) fryzlkmbh,convert(varchar(30)
,B.ZKZLKM) fzkzlkmbh,convert(varchar(30),B.CYZLKM) fcyzlkmbh  ,
  CASE WHEN A.CYKS LIKE '02%' THEN '01'WHEN  A.CYKS LIKE '05%' THEN '02' WHEN A.CYKS LIKE '32%' THEN '03' ELSE null END  fyydm         
  from EMR_BRSYK A (nolock)        
 inner join #PAT P on A.HISSYXH = P.HISSYXH AND A.SYXH=P.EMRSYXH             
 inner join #TSZDCL Q ON A.SYXH=Q.SYXH         
 inner join EMR_BASYK_FB D (nolock) on D.QTBLJLXH=P.QTBLJLXH and D.SYXH=A.SYXH    
 left join EMR_BASYK B (nolock) on B.QTBLJLXH=P.QTBLJLXH and B.SYXH=P.EMRSYXH          
 where A.YEXH = 0     
     
 --更新过敏药物    
 update  A set FGMYW=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FGMYW=B.MXDM  and B.LBDM='10'      
        

 --1 一般  3 危重        
 UPDATE A SET A.FJBFXBH='3',A.FJBFX='C' FROM #ba1 A WHERE EXISTS (SELECT 1 FROM CPOE_CQYZK where  SYXH=A.FZYID and (YPMC Like  '%病危%' or YPMC Like  '%病重%'))        
         
 --根据字典代码获取名称字段                 
 update #ba1 set FSEX= (case FSEXBH when '1' then '男' when '2' then '女'  else '' end)               
 update  A set FCOUNTRYBH=B.MXDM,FCOUNTRY=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FCOUNTRYBH=B.MXDM  and B.LBDM='43'          
 --更改国家编号        
 --update  A SET FCOUNTRY=B.NAME FROM #ba1 A,PUB_GJDMK B WHERE A.FCOUNTRYBH=B.ID           
 --update  A set FCOUNTRYBH='CHN' from #ba1 A where FCOUNTRY='中国'            
 update  A set FNATIONALITY=B.NAME,FNATIONALITYBH=B.MXDM from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FNATIONALITYBH=B.MXDM  and B.LBDM='42'            
 ---更改民族编号
 update #ba1 set FNATIONALITY=b.name from #ba1 a,[172.20.0.41\ZY].THIS_ZY.dbo.YY_MZDMK b where a.FNATIONALITYBH=b.id collate Chinese_PRC_CI_AS
 update #ba1 set FNATIONALITYBH=b.FBH from #ba1 a,[172.20.9.200].BAGL_JAVA.dbo.TSTANDARDMX b where a.FNATIONALITY=b.FMC collate Chinese_PRC_CI_AS and FCODE='GBNATIONALITY'        
 --update  A set FNATIONALITYBH=B.MXDM from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FNATIONALITY=B.NAME  and B.LBDM='42'                  
 
 update  A set FJOB=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  replace(A.FJOBBH,' ','')=B.MXDM  and B.LBDM='41'
 update A set FJOB='幼托儿童',FJOBBH='72' from #ba1 A where FJOBBH='C1'
update A set FJOB='散居儿童',FJOBBH='71' from #ba1 A where FJOBBH='C2'    
update A set FJOB='职员',FJOBBH='17' from #ba1 A where FJOBBH='C3'    
update A set FJOB='其他',FJOBBH='90' from #ba1 A where FJOBBH='C4'    
update A set FJOB='个体经营者',FJOBBH='54' from #ba1 A where FJOBBH='C5'    
update A set FJOB='个体经营者',FJOBBH='54' from #ba1 A where FJOBBH='C6'    
update A set FJOB='专业技术人员',FJOBBH='13' from #ba1 A where FJOBBH='C7'    
update A set FJOB='其他',FJOBBH='90' from #ba1 A where FJOBBH='C8'    
update A set FJOB='其他',FJOBBH='90' from #ba1 A where FJOBBH='C9'
update A set FJOB='其他',FJOBBH='90' from #ba1 A where FJOBBH='C10'    
update A set FJOB='职员',FJOBBH='17' from #ba1 A where FJOBBH='C11'    
update A set FJOB='无业人员',FJOBBH='70' from #ba1 A where FJOBBH='C12'    
update A set FJOB='其他',FJOBBH='90' from #ba1 A where FJOBBH='C13'    
update A set FJOB='其他',FJOBBH='90' from #ba1 A where FJOBBH='C14'       
 --更改婚姻编号         
 UPDATE  A set FSTATUS=B.NAME from  #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where A.FSTATUSBH=B.MXDM  AND B.LBDM='4'               
  --      update #ba1 set FSTATUSBH='10' where FSTATUS LIKE '%未婚%'   
  --      update #ba1 set FSTATUSBH='20' where FSTATUS LIKE '%已婚%'       
  --      update #ba1 set FSTATUSBH='20' where FSTATUS LIKE '%再婚%' 
  --      update #ba1 set FSTATUSBH='30' where FSTATUS LIKE '%丧偶%'    
  --      update #ba1 set FSTATUSBH='40' where FSTATUS LIKE '%离婚%'  
  --      update #ba1 set FSTATUSBH='40' where FSTATUS LIKE '%离异%'  
  --      update #ba1 set FSTATUSBH='90' where FSTATUS LIKE '%其他%'
		--update #ba1 set FSTATUSBH='90' where FSTATUS LIKE '%同居%'
		update #ba1 set FSTATUSBH='1' where FSTATUS LIKE '%未婚%'   
        update #ba1 set FSTATUSBH='2' where FSTATUS LIKE '%已婚%'       
        update #ba1 set FSTATUSBH='2' where FSTATUS LIKE '%再婚%' 
        update #ba1 set FSTATUSBH='3' where FSTATUS LIKE '%丧偶%'    
        update #ba1 set FSTATUSBH='4' where FSTATUS LIKE '%离婚%'  
        update #ba1 set FSTATUSBH='4' where FSTATUS LIKE '%离异%'  
        update #ba1 set FSTATUSBH='9' where FSTATUS LIKE '%其他%'
		update #ba1 set FSTATUSBH='9' where FSTATUS LIKE '%同居%'           
           
 update  A set FRYDEPT =B.NAME from #ba1 A , EMR_SYS_KSDMK B (nolock) where  A.FRYTYKH=B.KSDM                    
 update  A set FRYBS =B.NAME from #ba1 A , EMR_SYS_BQDMK B (nolock) where  A.FRYBS=B.BQDM                    
 update  A set FCYDEPT =B.NAME from #ba1 A , EMR_SYS_KSDMK B (nolock) where  A.FCYTYKH=B.KSDM                     
 update  A set FCYBS =B.NAME from #ba1 A , EMR_SYS_BQDMK B (nolock) where  A.FCYBS=B.BQDM                      
 --lr20141108                   
 update  A set FMZDOCTBH =B.mzzdys from #ba1 A , [172.20.0.41\ZY].[THIS_ZY].[dbo].ZY_BRSYK B (nolock) where  B.syxh=A.FZYID        
         
 update  A set FMZDOCT =isnull(B.NAME,'-') from #ba1 A , EMR_SYS_ZGDMK B (nolock) where  A.FMZDOCTBH=B.ZGDM          
 --更新符合情况                   
 update  A set FMZCYACCO=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FMZCYACCOBH=B.MXDM  and B.LBDM='12'                  
 update  A set FLCBLACCO=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FLCBLACCOBH=B.MXDM  and B.LBDM='12'             
 update  A set FRYCYACCO=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FRYCYACCOBH=B.MXDM  and B.LBDM='12'                  
 update  A set FFSBLACCO=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FFSBLACCOBH=B.MXDM  and B.LBDM='12'           
 update  A set FOPACCO=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FOPACCOBH=B.MXDM  and B.LBDM='12'
 update  A set FBDYSL=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FBDYSLBH=B.MXDM  and B.LBDM='12'

 update  A set FMZCYACCO='未做',FMZCYACCOBH='0' from #ba1 A  where  A.FMZCYACCOBH='4'                  
 update  A set FLCBLACCO='未做',FLCBLACCOBH='0' from #ba1 A  where  A.FLCBLACCOBH='4'         
 update  A set FRYCYACCO='未做',FRYCYACCOBH='0' from #ba1 A  where  A.FRYCYACCOBH='4'                 
 update  A set FFSBLACCO='未做',FFSBLACCOBH='0' from #ba1 A where  A.FFSBLACCOBH='4'          
 update  A set FOPACCO='未做',FOPACCOBH='0' from #ba1 A  where  A.FOPACCOBH='4'
 update  A set FBDYSL='未做',FBDYSLBH='0' from #ba1 A  where  A.FBDYSLBH='4'                    
              
 update  A set FKZR =isnull(B.NAME,'-') from #ba1 A , EMR_SYS_ZGDMK B (nolock) where  A.FKZRBH=B.ZGDM                    
 update  A set FZRDOCTOR =isnull(B.NAME,'-') from #ba1 A , EMR_SYS_ZGDMK B (nolock) where  A.FZRDOCTBH=B.ZGDM                    
 update  A set FZZDOCT =isnull(B.NAME,'-') from #ba1 A , EMR_SYS_ZGDMK B (nolock) where  A.FZZDOCTBH=B.ZGDM                    
 update  A set FZYDOCT =isnull(B.NAME,'-') from #ba1 A , EMR_SYS_ZGDMK B (nolock) where  A.FZYDOCTBH=B.ZGDM                    
 update  A set FJXDOCT =isnull(B.NAME,'-') from #ba1 A , EMR_SYS_ZGDMK B (nolock) where  A.FJXDOCTBH=B.ZGDM                    
 update  A set FSXDOCT =isnull(B.NAME,'-') from #ba1 A , EMR_SYS_ZGDMK B (nolock) where  A.FSXDOCTBH=B.ZGDM                    
 update  A set FBMY =isnull(B.NAME,'-') from #ba1 A , EMR_SYS_ZGDMK B (nolock) where  A.FBMYBH=B.ZGDM                    
 update A set FZLR =isnull(B.NAME,'-') from #ba1 A , EMR_SYS_ZGDMK B (nolock) where  A.FZLRBH=B.ZGDM          
         
    update  A set FQUALITY=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FQUALITYBH=B.MXDM  and B.LBDM='16'                  
    update  A set FZKDOCT =B.NAME from #ba1 A , EMR_SYS_ZGDMK B (nolock) where  A.FZKDOCTBH=B.ZGDM                    
    update  A set FZKNURSE =B.NAME from #ba1 A , EMR_SYS_ZGDMK B (nolock) where  A.FZKNURSEBH=B.ZGDM                    
    update  A set FBODY=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FBODYBH=B.MXDM  and B.LBDM='95'                  
    update  A set FBLOOD=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FBLOODBH=B.MXDM  and B.LBDM='96'                  
    update  A set FJBFXBH=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FJBFXBH=B.MXDM  and B.LBDM='70'                  
    update  A set FSOURCE=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FSOURCEBH=B.MXDM  and B.LBDM='2'                  
    --update  A set FBIRTHPLACE=B.NAME from #ba1 A , EMR_SYS_DQDMK B (nolock) where  A.FBIRTHPLACE=B.DQDM        
            
 update  A set FRYTJ=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FRYTJBH=B.MXDM  and B.LBDM='6'                  
 update  #ba1 set FRYTJBH='1' where FRYTJ='急诊'                  
 update  #ba1 set FRYTJBH='2' where FRYTJ='门诊'                  
 update  A set FYCLJ=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FYCLJBH=B.MXDM  and B.LBDM='95'                  
 update  A set FIFGMYW=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FIFGMYWBH=B.MXDM  and B.LBDM='95'                  
 update  A set FNURSE =isnull(B.NAME,'-') from #ba1 A , EMR_SYS_ZGDMK B (nolock) where  A.FNURSEBH=B.ZGDM         
                  
 --select B.NAME,* from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FLYFSBH=B.MXDM  and B.LBDM='98' return   --lius                   
 update  A set FLYFS=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FLYFSBH=B.MXDM  and B.LBDM='98'                  
 update  A set FISAGAINRY=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FISAGAINRYBH=B.MXDM and B.LBDM='95'                  
 update  A set FFBNEW=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FFBBHNEW=B.MXDM  and B.LBDM='1'
        update #ba1 set FFBBHNEW='01' where FFBNEW='城镇职工基本医疗保险'    
        update #ba1 set FFBBHNEW='02' where FFBNEW='城镇居民基本医疗保险'    
        update #ba1 set FFBBHNEW='03' where FFBNEW='新型农村合作医疗'    
        update #ba1 set FFBBHNEW='04' where FFBNEW='贫困救助'    
        update #ba1 set FFBBHNEW='05' where FFBNEW='商业医疗保险'    
        update #ba1 set FFBBHNEW='06' where FFBNEW='全公费'    
        update #ba1 set FFBBHNEW='07' where FFBNEW='全自费'    
        update #ba1 set FFBBHNEW='08' where FFBNEW='其他社会保险'    
        update #ba1 set FFBBHNEW='99' where FFBNEW='其他'                        
 UPDATE  A set FRELATE=B.NAME from  #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where A.FRELATE=B.MXDM  AND B.LBDM='44'
        update #ba1 SET FRELATE = '子' where FRELATE='01'
	    update #ba1 SET FRELATE = '子' where FRELATE ='02' 
        update #ba1 SET FRELATE = '配偶' where FRELATE = '03'    
        update #ba1 SET FRELATE = '兄、弟、姐、妹' where FRELATE='04'
        update #ba1 SET FRELATE = '其他' where FRELATE='05'  
        update #ba1 SET FRELATE = '其他' where FRELATE='06'        
        update #ba1 SET FRELATE = '其他' where FRELATE='07'   
        update #ba1 SET FRELATE = '本人或户主' where FRELATE = '08'                       
 --        
 UPDATE  A set FRH=B.NAME from  #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where A.FRHBH=B.MXDM  AND B.LBDM='97'                  
 --UPDATE  A set FRYTYKH=B.ba_id,FRYDEPT=B.ba_name,FRYBS=B.ba_id  from  #ba1 A , THIS_MZ..baksdyk B (nolock) where A.FRYTYKH=B.id                   
 --UPDATE  A set FCYTYKH=B.ba_id,FCYDEPT=B.ba_name,FCYBS=B.ba_id  from  #ba1 A , THIS_MZ..baksdyk B (nolock) where A.FCYTYKH=B.id                   
 --UPDATE  A set FNATIVE=B.name  FROM  #ba1 A ,THIS_MZ..YY_DQDMK B (nolock) WHERE A.FNATIVE=B.id               
--籍贯处理        
 UPDATE  A set FNATIVE=B.NAME  FROM  #ba1 A ,EMR_SYS_DQDMK B (nolock) WHERE A.FNATIVE=B.DQDM           
 UPDATE  A set FNATIVE_QX=B.NAME  FROM  #ba1 A ,EMR_SYS_DQDMK B (nolock) WHERE A.FNATIVE_QX=B.DQDM            
 UPDATE  A set FNATIVE=FNATIVE+FNATIVE_QX  FROM  #ba1 A          
 --现住址处理        
 UPDATE  A set FCURRADDR=B.NAME  FROM  #ba1 A ,EMR_SYS_DQDMK B (nolock) WHERE A.FCURRADDR=B.DQDM          
 UPDATE  A set FCURRADDR_X=B.NAME  FROM  #ba1 A ,EMR_SYS_DQDMK B (nolock) WHERE A.FCURRADDR_X=B.DQDM            
 --UPDATE  A set FCURRADDR=A.FCURRADDR+A.FCURRADDR_X+A.FCURRADDR_JD  FROM  #ba1 A        
 UPDATE  A set FCURRADDRBZ=A.FCURRADDR+A.FCURRADDR_X  FROM  #ba1 A        
 UPDATE  A set FCURRADDR=A.FCURRADDR_JD  FROM  #ba1 A        
 --出生地处理        
 update  A set FBIRTHPLACE=B.NAME from #ba1 A , EMR_SYS_DQDMK B (nolock) where  A.FBIRTHPLACE=B.DQDM        
 update  A set FBIRTHPLACE_QX=B.NAME from #ba1 A , EMR_SYS_DQDMK B (nolock) where  A.FBIRTHPLACE_QX=B.DQDM         
 UPDATE  A set FBIRTHPLACE=A.FBIRTHPLACE+A.FBIRTHPLACE_QX  FROM  #ba1 A        
 --  UPDATE  A set FFBBHNEW=B.BA_ID from #ba1 A , THIS_MZ..fkdyk B (nolock) where  A.FFBBHNEW=B.MXDM                    
 --UPDATE  A set FFBBHNEW=B.babm from #ba1 A , zt_badzk B (nolock) where  A.FFBBHNEW=B.hisbm and lbdm=1                    
 --  UPDATE  A set FRELATE=B.BA_NAME from #ba1 A , THIS_MZ..lxrdyk B (nolock) where  A.FRELATE=B.MXDM                   
 --  UPDATE  A set FSTATUSBH=B.BA_ID,FSTATUS=B.BA_NAME from #ba1 A , THIS_MZ..hydyk B (nolock) where  A.FSTATUSBH=B.ID
 
 --将''转换为'-'
 update #ba1 set FDWTELE='-' where FDWTELE=''
 update #ba1 set FIDCARD='-' where FIDCARD=''
 update #ba1 set FDWADDR='-' where FDWADDR=''
 update #ba1 set FDWADDRBZ='-' where FDWADDRBZ=''
 update #ba1 set FDWPOST='-' where FDWPOST=''
 update #ba1 set FHKPOST='-' where FHKPOST=''
 update #ba1 set FLXADDR='-' where FLXADDR=''
 update #ba1 set FMZZD='-' where FMZZD=''
 update #ba1 set FPHZD='-' where FPHZD=''
 update #ba1 set FGMYW='-' where FGMYW=''
 update #ba1 set FMZDOCT='-' where FMZDOCT=''
 update #ba1 set FKZR='-' where FKZR=''
 update #ba1 set FZRDOCTOR='-' where FZRDOCTOR=''
 update #ba1 set FZZDOCT='-' where FZZDOCT=''
 update #ba1 set FZYDOCT='-' where FZYDOCT=''
 update #ba1 set FJXDOCT='-' where FJXDOCT=''
 update #ba1 set FSXDOCT='-' where FSXDOCT=''
 update #ba1 set FBMY='-' where FBMY=''
 update #ba1 set FZLR='-' where FZLR=''
 update #ba1 set FZKDOCT='-' where FZKDOCT=''
 update #ba1 set FZKNURSE='-' where FZKNURSE=''
 update #ba1 set FNURSE='-' where FNURSE=''
 update #ba1 set FCURRPOST='-' where FCURRPOST=''
 update #ba1 set FPHZDBH='-' where FPHZDBH=''
 update #ba1 set FPHZDNUM='-' where FPHZDNUM=''
 update #ba1 set FJXDOCTBH='-' where FJXDOCTBH=''
 update #ba1 set FSXDOCTBH='-' where FSXDOCTBH=''
 update #ba1 set FYZOUTHOSTITAL='-' where FYZOUTHOSTITAL=''
 update #ba1 set FSQOUTHOSTITAL='-' where FSQOUTHOSTITAL=''
 update #ba1 set FISAGAINRYMD='-' where FISAGAINRYMD=''
 update #ba1 set FMZCYACCO='-' where FMZCYACCO=''
 update #ba1 set FMZCYACCOBH='-' where FMZCYACCOBH=''
 update #ba1 set FRYCYACCO='-' where FRYCYACCO=''
 update #ba1 set FRYCYACCOBH='-' where FRYCYACCOBH=''
 update #ba1 set FLCBLACCO='-' where FLCBLACCO=''
 update #ba1 set FLCBLACCOBH='-' where FLCBLACCOBH=''
 update #ba1 set FFSBLACCO='-' where FFSBLACCO=''
 update #ba1 set FFSBLACCOBH='-' where FFSBLACCOBH=''
 update #ba1 set FOPACCO='-' where FOPACCO=''
 update #ba1 set FOPACCOBH='-' where FOPACCOBH=''
 update #ba1 set FBDYSL='-' where FBDYSL=''
 update #ba1 set FBDYSLBH='-' where FBDYSLBH=''
 update #ba1 set FBODY='否' where FBODY=''
 update #ba1 set FBODYBH='2' where FBODYBH=''
 update #ba1 set FYCLJ='否' where FYCLJ=''
 update #ba1 set FYCLJBH='2' where FYCLJBH='' 
 update #ba1 set FASCARD1='-' where FASCARD1='' 
 update #ba1 set FCURRADDR='-' where FCURRADDR='' 
 update #ba1 set FDWADDRBZ='-' where FDWADDRBZ='' 
 update #ba1 set FBODY='否' where FBODY is NULL
 update #ba1 set FBODYBH='2' where FBODYBH is NULL
 update #ba1 set FYCLJ='否' where FYCLJ is NULL
 update #ba1 set FYCLJBH='2' where FYCLJBH is NULL
 --update #ba1 set FNLBZYZS='-' where FNLBZYZS='' 
 --update #ba1 set FCSTZ='-' where FCSTZ='' 
 --update #ba1 set FRYTZ='-' where FRYTZ='' 
 
 --将NULL转换为'-'
 update #ba1 set FDWTELE='-' where FDWTELE is NULL
 update #ba1 set FIDCARD='-' where FIDCARD is NULL
 update #ba1 set FDWADDR='-' where FDWADDR is NULL
 update #ba1 set FDWADDRBZ='-' where FDWADDRBZ is NULL
 update #ba1 set FDWPOST='-' where FDWPOST is NULL
 update #ba1 set FHKPOST='-' where FHKPOST is NULL
 update #ba1 set FLXADDR='-' where FLXADDR is NULL
 update #ba1 set FMZZD='-' where FMZZD is NULL
 update #ba1 set FPHZD='-' where FPHZD is NULL
 update #ba1 set FGMYW='-' where FGMYW is NULL
 update #ba1 set FMZDOCT='-' where FMZDOCT is NULL
 update #ba1 set FKZR='-' where FKZR is NULL
 update #ba1 set FZRDOCTOR='-' where FZRDOCTOR is NULL
 update #ba1 set FZZDOCT='-' where FZZDOCT is NULL
 update #ba1 set FZYDOCT='-' where FZYDOCT is NULL
 update #ba1 set FJXDOCT='-' where FJXDOCT is NULL
 update #ba1 set FSXDOCT='-' where FSXDOCT is NULL
 update #ba1 set FBMY='-' where FBMY is NULL
 update #ba1 set FZLR='-' where FZLR is NULL
 update #ba1 set FZKDOCT='-' where FZKDOCT is NULL
 update #ba1 set FZKNURSE='-' where FZKNURSE is NULL
 update #ba1 set FNURSE='-' where FNURSE is NULL
 update #ba1 set FCURRPOST='-' where FCURRPOST is NULL
 update #ba1 set FPHZDBH='-' where FPHZDBH is NULL
 update #ba1 set FPHZDNUM='-' where FPHZDNUM is NULL
 update #ba1 set FJXDOCTBH='-' where FJXDOCTBH is NULL
 update #ba1 set FSXDOCTBH='-' where FSXDOCTBH is NULL
 update #ba1 set FYZOUTHOSTITAL='-' where FYZOUTHOSTITAL is NULL
 update #ba1 set FSQOUTHOSTITAL='-' where FSQOUTHOSTITAL is NULL
 update #ba1 set FISAGAINRYMD='-' where FISAGAINRYMD is NULL
 update #ba1 set FMZCYACCO='-' where FMZCYACCO is NULL
 update #ba1 set FMZCYACCOBH='-' where FMZCYACCOBH is NULL
 update #ba1 set FRYCYACCO='-' where FRYCYACCO is NULL
 update #ba1 set FRYCYACCOBH='-' where FRYCYACCOBH is NULL
 update #ba1 set FLCBLACCO='-' where FLCBLACCO is NULL
 update #ba1 set FLCBLACCOBH='-' where FLCBLACCOBH is NULL
 update #ba1 set FFSBLACCO='-' where FFSBLACCO is NULL
 update #ba1 set FFSBLACCOBH='-' where FFSBLACCOBH is NULL
 update #ba1 set FOPACCO='-' where FOPACCO is NULL
 update #ba1 set FOPACCOBH='-' where FOPACCOBH is NULL
 update #ba1 set FBDYSL='-' where FBDYSL is NULL
 update #ba1 set FBDYSLBH='-' where FBDYSLBH is NULL
 update #ba1 set FBODY='-' where FBODY is NULL
 update #ba1 set FBODYBH='-' where FBODYBH is NULL
 update #ba1 set FYCLJ='-' where FYCLJ is NULL
 update #ba1 set FYCLJBH='-' where FYCLJBH is NULL 
 update #ba1 set FASCARD1='-' where FASCARD1 is NULL 

--  insert into #His_BaFy     (FSYXH,FPRN, FTIMES,FIFFMBH,	FCS,FCSDSBH,FHCXSES,FXSETZDY2KBH,FIFZCBH,FXSECSBH,FXSECSGS,FISZRY,FBCYSCCYJG,FZRYYYBH,FRYBQFJBH,
--   FZYZDLXBH,FCYZDLXBH,FZGZDYJBH,FLCLJBL,FSYFYFSCS,FSYFY_FY,FSXFY_FY,FSXFYFSCS,F24HSXLBH,FWZBL,FYNBL,FISSZBH,FDBZ_HN,FDRGGL,FIFABZFFBLBH,FSSKJYW,
--   FIFYFXSYBH,FZYKJYW_VALUE,FSFZJKJYWBH,FKJYWSBYXJC,FWSWJCJGBH,	FYYXSS,	FHZAQSJ,FZZJH,FSFYNGR,FSYZXJMZG,FZXJMZGSYTS,FGLHTZXJMGBH,FDGHTYZC,FSYZXJMZGGR,
--   FSYLZDNG,FLZDNGSYTS,FIFGLHTBH,FIFZCRBH,FSYLZDNGGR,FXYTX,FXYTXTS,FSFXYTXGR,FSYHXJ,FSYHXJGR,FSYXHJTS,FYHXJSJ,FZRICU,FRZICUCS,FIFJHRZBH,FZRICUSW,FSFCFZZYXK,
--   FTGCTTS,	FYYCWSW,FFSYC,FSFFSYC,FIFAPACCHEBH,	FAPACCHEPF,	FSFQDTC,FSY,FSX)  --,FHMSJ
--  SELECT A.SYXH FSYXH,A.BAHM FPRN,A.RYCS FTIMES,D.CKHZSFFM FIFFMBH,D.SFFSCS FCS,	D.CSDS FCSDSBH,	D.HCYES FHCXSES,D.XSETZDY2KG FXSETZDY2KBH,D.SFZCE FIFZCBH,
--  D.XSRSFFSCS FXSECSBH,	D.XSEFSCSGS FXSECSGS,D.SFZZY FISZRY,D.CFJGSJ FBCYSCCYJG,D.ZZYYY FZRYYYBH,B.RYQK FRYBQFJBH,B.ZLJG FZYZDLXBH,	D.ZDYJ FCYZDLXBH,
--  D.BLZGZDYJ FZGZDYJBH,	B.LCLJGL FLCLJBL,B.SYCS FSYFYFSCS,B.SYFY FSYFY_FY,B.SXFY FSXFY_FY,B.SXQK FSXFYFSCS,D.SXLDY F24HSXLBH,B.ZYWZ FWZBL,B.ZYYN FYNBL,
--  B.SZQK FISSZBH,D.DWZBL FDBZ_HN,D.SSDRGSGL FDRGGL,D.SFSRJJXFBZ FIFABZFFBLBH,D.SFSQYFSYKJYW FSSKJYW,D.KSSSFYF FIFYFXSYBH,D.KSSYW FZYKJYW_VALUE,	
--  D.TSJYW FSFZJKJYWBH,D.SFZBYXJC FKJYWSBYXJC,D.WSWJCJG FWSWJCJGBH,D.SFYYXSH FYYXSS,D.YYXSHLX FHZAQSJ,D.JHZSJHOUR FZZJH,	D.SFYYGR FSFYNGR,
--  D.SFSYZXJMZG FSYZXJMZG,D.SYZXJMZGTS FZXJMZGSYTS,D.JZGSFGLHT FGLHTZXJMGBH,D.JZGSFZCR FDGHTYZC,	D.SFZXJMZGGR FSYZXJMZGGR,D.SFSYZLDNG FSYLZDNG,
--  D.SYZLDNGTS FLZDNGSYTS,D.DNGSFGLHT FIFGLHTBH,	D.DNGSFZCR FIFZCRBH,D.SFZLDNGTS FSYLZDNGGR,	D.SFXYTXZL FXYTX,D.XYGRZTS FXYTXTS,	D.SFXYGR FSFXYTXGR,
--  	D.SFSYHXJ FSYHXJ,D.SFHXJGR FSYHXJGR,D.JHZSJDAY FSYXHJTS,D.SYHXJSS FYHXJSJ,B.SRSS FZRICU,D.ICURZCS FRZICUCS,D.ICUSFJHRZ FIFJHRZBH,D.ICUSW FZRICUSW,
--	D.SFCFICU FSFCFZZYXK,D.HXJTGCTBRS FTGCTTS,D.SFSW FYYCWSW,B.YWYC FFSYC,D.SFZYQJFSYC FSFFSYC,	D.SFAPACCHEII FIFAPACCHEBH,	D.APACCHEIIPF FAPACCHEPF,
--	D.SFRGQDTC FSFQDTC,D.SFSY FSY,D.SFSX FSX--,D.HMSJ FHMSJ
--   from  EMR_BRSYK A (nolock)        
-- inner join #PAT P on A.SYXH=P.EMRSYXH  
-- inner join EMR_BASYK_FB D (nolock)  on  D.QTBLJLXH=P.QTBLJLXH and D.SYXH=A.SYXH 
-- left join EMR_BASYK B (nolock) on B.QTBLJLXH=P.QTBLJLXH and B.SYXH=P.EMRSYXH 
----lzm修改  




 --输液反应转换
  update #His_BaFy set FSYFY_FY='3' from #His_BaFy (nolock)  where FSYFY_FY='1'  
  update #His_BaFy set FSYFY_FY='1' from #His_BaFy (nolock)  where FSYFY_FY='2' 
  update #His_BaFy set FSYFY_FY='2' from #His_BaFy (nolock)  where FSYFY_FY='3'  
  --修改临床路径信息
  update #His_BaFy set FLCLJBL=''   from #His_BaFy (nolock)  where FLCLJBL='4' 
        
 --病人转科情况（HIS_BA2）                  
 insert into #ba2(FSYXH,FPRN,FTIMES,FZKTYKH,FZKDEPT,FZKDATE,FZKTIME)                      
 select A.SYXH FSYXH,A.BAHM,B1.RYCS,B.XKSDM,D.KSLB,substring(B.JSRQ,1,10),replace(substring(B.JSRQ,11,10),' ','')                   
 from  EMR_BRSYK A (nolock)        
 inner join #PAT P ON A.SYXH=P.EMRSYXH                 
 inner join EMR_BRCWXXK B (nolock) on B.SYXH=A.SYXH and B.ISDQCW=2                 
 inner join EMR_SYS_KSDMK D (nolock) on D.KSDM=B.XKSDM       
 left join EMR_BASYK B1 (nolock) on B1.QTBLJLXH=P.QTBLJLXH and B1.SYXH=P.EMRSYXH              
 where ISNULL(B.XKSDM,'')<>'' and B.KSDM<>B.XKSDM                  
 order by CWXXXH asc          
         
 --病人诊断信息（HIS_BA3）                  
 insert into #ba3(FSYXH,FPRN, FTIMES, FZDLX, FICDVERSION, FICDM, FJBNAME, FRYBQBH, FRYBQ,FZLJGBH,FZLJG,FSXZD)                      
 select A.SYXH FSYXH,A.BAHM,B1.RYCS,case ZDXH when 0 then 1 else 2 end ,11,B.ZDDM,substring(B.BZDMMC,1,40),B.RYBQ,E.NAME, B.ZGQK,'',substring(ZDMC,1,50)                  
 from  EMR_BRSYK A (nolock)        
 inner join #PAT P ON A.SYXH=P.EMRSYXH                  
 inner join EMR_BASY_ZDK B (nolock) on B.QTBLJLXH=P.QTBLJLXH and B.SYXH=A.SYXH                  
 left join EMR_SYS_ZDFLMXK E (nolock) on E.MXDM=B.RYBQ and E.LBDM = '103'  
 left join EMR_BASYK B1 (nolock) on B1.QTBLJLXH=P.QTBLJLXH and B1.SYXH=P.EMRSYXH                              
 order by ZDXH asc             
 ----add by z_jx 2017年3月9日18:34:33 增加出院情况        
 update a set a.FZLJG=b.NAME    from #ba3  a ,EMR_SYS_ZDFLMXK b where a.FZLJGBH=b.MXDM  and b.LBDM=8          
         
 INSERT into #ba3(FSYXH,FPRN, FTIMES, FZDLX, FICDVERSION, FICDM, FJBNAME, FRYBQBH, FRYBQ,FZLJGBH,FZLJG)                  
 select A.SYXH FSYXH,A.BAHM,K.RYCS,'s',11,substring(K.SSZD,1,7),substring(K.SSZDMC,1,40),'','','2','好转'                 
 from  EMR_BRSYK A (nolock)         
 INNER JOIN #PAT P ON A.SYXH=P.EMRSYXH                 
 INNER JOIN EMR_BASYK K (nolock) on A.SYXH=K.SYXH                  
 where K.SSZD<>'' AND K.SYXH=P.EMRSYXH        
 --根据医院要求导入病案的数据不能加以修饰  -mwg        
 --update A set FJBNAME=B.name from #ba3 A,THIS_MZ..YY_ZDDMK B (nolock) WHERE A.FICDM=B.id        
   
   

     
-- --病人手术信息（HIS_BA4）        
 insert into #ba4(FSYXH,FPRN, FTIMES, FNAME, FOPTIMES,FOPCODE,   
 FOP, 
 FOPDATE,       
 FQIEKOUBH, FQIEKOU, FYUHEBH,                   
 FYUHE, FDOCBH, FDOCNAME, FMAZUIBH, FMAZUI, FIFFSOP, FOPDOCT1BH, FOPDOCT1, FOPDOCT2BH,                   
 FOPDOCT2, FMZDOCTBH, FMZDOCT, FZQSSBH, FZQSS, FSSJBBH, FSSJB, FOPKSNAME, FOPTYKH  ,FZYID,
 FFJHZSSBH,FIFSHBFZBH,FSHBFZBH,FIFOPBH,FIFJRSSBH,FSSKSSJ,FSSJSSJ,FSSCXSJ,FSSXZBH,FSSLBBH,FIFXJSXMBH,FMZKSSJ,FMZJSSJ,FMZFJBH,FMZBFZBH,FSSLTZZSBJBH,
 FSSFXFJBH,FIFYFDSSBH,FSSFLBH,FSSBWGRBH,FGRBWBH,FIFSHSWBH,FSHSWSJ,FSQYFSYKJYWBH,FSQSYYFKJYWSJ,FSZZJKJYWBH,FSZZJKJYWYYBH,FSHYFSYKJYWBH,FSHYFYKJYWSJ,
 FSSYPFZBFFBH,FSZBDJCBH,FYWFJHZSSBH,FIFSZSXBH,FSZCXL,FSZSXPZBH,	FSSBDYSLBLZDBH,	FSQYSHBLZDBH,FIFSZYWYLBH,FQSMZSFTWXHBH,FMZYSZTZLBH,FMZYSZTZLSJBH,
 FMZYSXFFSZLBH,FIFXFFSCGBH,FIFSTEWARDBH,FJRMZFSSBH,FSTEWARDPF,FFSMZFYQSJBH,FMZFYQXGSJBH
 )                      
 select A.SYXH FSYXH,A.BAHM FPRN,B1.RYCS FTIMES,A.HZXM FNAME,B.SSXH FOPTIMES,substring(B.SSDM,1,12) FOPCODE,      
 B.SSMC FOP,
 B.SSRQ FOPDATE,      
 B.QKDJ FQIEKOUBH,D.NAME FQIEKOU,B.YHLB FYUHEBH,        
 E.NAME FYUHE,B.SSYS FDOCBH,B.SSYSMC FDOCNAME,B.MZFS FMAZUIBH,F.NAME FMAZUI,1/*B.SFJRSS*/ FIFFSOP,        
 B.SSYZ FOPDOCT1BH,B.SSYZMC FOPDOCT1,B.SSEZ FOPDOCT2BH,B.SSEZMC FOPDOCT2,        
 B.MZYS FMZDOCTBH,B.MZYSMC FMZDOCT,'0' FZQSSBH,'否' FZQSS,B.SSJB FSSJBBH,H.NAME FSSJB,        
 I.NAME FOPKSNAME,B.SSKS FOPTYKH,P.HISSYXH FZYID  ,
 B.YWZSSJH FFJHZSSBH,B.SFYSHBFZ FIFSHBFZBH,B.SHBFZ FSHBFZBH,B.SFSS FIFOPBH,B.SFJRSS FIFJRSSBH,case when B.SSKSSJ like '%-%' and B.SSKSSJ not like  '%+%' then B.SSKSSJ   else null  end FSSKSSJ,
case when B.SSJSSJ like '%-%'and B.SSJSSJ not like  '%+%' then B.SSKSSJ else null  end FSSJSSJ,
 left(B.SSCSSJ,20) FSSCXSJ,B.SSXZ FSSXZBH,B.SSLB FSSLBBH,B.SFXJS FIFXJSXMBH,
case when B.MZKSSJ like '%-%'and B.MZKSSJ not like  '%+%' then B.MZKSSJ else null  end  FMZKSSJ,
case when B.MZJSSJ like '%-%' and B.MZJSSJ not like  '%+%'then B.MZJSSJ else null  end  FMZJSSJ,
 B.MZFJ FMZFJBH,B.MZBFZ FMZBFZBH,
 B.BBSFBJ FSSLTZZSBJBH,	B.SSFXFJ FSSFXFJBH,	B.SFYFDSS FIFYFDSSBH,B.SSFL FSSFLBH,B.BWSFGR FSSBWGRBH,	B.GRBW FGRBWBH,	B.SHSFSW FIFSHSWBH,	B.SHSWSJ FSHSWSJ,
 B.SQSFYFSYKJYW FSQYFSYKJYWBH,B.SQYFSYSJ FSQSYYFKJYWSJ,B.SFSZZJDJKJYW FSZZJKJYWBH,B.SZZJDEJKJYWYY FSZZJKJYWYYBH,B.SHSFYFSYKJYW FSHYFSYKJYWBH,
 B.SHYFSYSJ FSHYFYKJYWSJ,B.SSYPFZBFF FSSYPFZBFFBH,B.SZBDJC FSZBDJCBH,B.YWZSSJH FYWFJHZSSBH,B.SFSZSX FIFSZSXBH,B.SHCXL FSZCXL,B.SZSXPZ FSZSXPZBH,
 B.BDFH FSSBDYSLBLZDBH,	B.QHFH FSQYSHBLZDBH,B.YWSZYWYL FIFSZYWYLBH,	B.QMSFTWXH FQSMZSFTWXHBH,B.SFMZYSZTZL FMZYSZTZLBH,B.MZYSZLSJ FMZYSZTZLSJBH,	
 B.SFMZYSXFFS FMZYSXFFSZLBH,B.XFFSSFCG FIFXFFSCGBH,B.SFMZFSGL FIFSTEWARDBH,B.SFJRMZFSS FJRMZFSSBH,B.STEWARDPF FSTEWARDPF,B.SFFSMZFYQSJ FFSMZFYQSJBH,
 B.MZFYQSJ FMZFYQXGSJBH             
 from  EMR_BRSYK A (nolock)        
 inner join #PAT P ON A.SYXH=P.EMRSYXH                  
 inner join EMR_BASY_SSK B (nolock) on B.QTBLJLXH=P.QTBLJLXH and B.SYXH=A.SYXH                  
 left join EMR_SYS_ZDFLMXK D (nolock) on D.MXDM=B.QKDJ and D.LBDM = '27'                    
 left join EMR_SYS_ZDFLMXK E (nolock)on E.MXDM=B.YHLB and E.LBDM = '28'                   
 left join EMR_SYS_MZDMK F (nolock) on F.MZDM=B.MZFS                  
 left join EMR_SYS_ZDFLMXK G (nolock) on G.MXDM=B.ZQSS and G.LBDM = '95'                   
 left join EMR_SYS_ZDFLMXK H (nolock) on H.MXDM=B.SSJB and H.LBDM = '120'                  
 left join EMR_SYS_KSDMK I (nolock) on I.KSDM=B.SSKS       
 left join EMR_BASYK B1 (nolock) on B1.QTBLJLXH=P.QTBLJLXH and B1.SYXH=P.EMRSYXH   
       
 -- UPDATE #ba4 SET FOPDATE=B.SSRQ,FOPCODE=B.SSDM from  EMR_BRSYK A (nolock)        
 --inner join #PAT P ON A.SYXH=P.EMRSYXH                  
 --inner join EMR_BASY_SSK B (nolock) on B.QTBLJLXH=P.QTBLJLXH and B.SYXH=A.SYXH                  
 --left join EMR_SYS_ZDFLMXK D (nolock) on D.MXDM=B.QKDJ and D.LBDM = '27'                    
 --left join EMR_SYS_ZDFLMXK E (nolock)on E.MXDM=B.YHLB and E.LBDM = '28'                   
 --left join EMR_SYS_MZDMK F (nolock) on F.MZDM=B.MZFS                  
 --left join EMR_SYS_ZDFLMXK G (nolock) on G.MXDM=B.ZQSS and G.LBDM = '95'                   
 --left join EMR_SYS_ZDFLMXK H (nolock) on H.MXDM=B.SSJB and H.LBDM = '120'                  
 --left join EMR_SYS_KSDMK I (nolock) on I.KSDM=B.SSKS       
 --where #ba4.FZYID=P.HISSYXH      
 /*
 update  A set FSSKSSJ=NULL from  #ba4  A (nolock) where  A.FSSKSSJ not like '%-%'
 update  A set FSSJSSJ=NULL from  #ba4  A (nolock) where A. FSSJSSJ not like '%-%'
 update  A set FMZKSSJ=NULL from  #ba4  A (nolock) where  A.FMZKSSJ not like '%-%'
 update  A set FMZJSSJ=NULL from  #ba4  A (nolock) where  A.FMZJSSJ not like '%-%'
 */

 --更新手术字典 ltrim(rtrim(xserytz))
 UPDATE  A set FFJHZSSBH=B.MXDM,FFJHZSS=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FFJHZSSBH=B.MXDM AND B.LBDM='112' 
 UPDATE  A set FIFSHBFZBH=B.MXDM,FIFSHBFZ=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FIFSHBFZBH=B.MXDM AND B.LBDM='112'  
 UPDATE  A set FSHBFZBH=B.MXDM,FSHBFZ=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FSHBFZBH=B.MXDM AND B.LBDM='149' 
 UPDATE  A set FIFOPBH=B.MXDM,FIFOP=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FIFOPBH=B.MXDM AND B.LBDM='112'  
 UPDATE  A set FIFJRSSBH=B.MXDM,FIFJRSS=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FIFJRSSBH=B.MXDM AND B.LBDM='112'  
 UPDATE  A set FSSXZBH=B.MXDM,FSSXZ=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FSSXZBH=B.MXDM AND B.LBDM='144' 
 UPDATE  A set FSSLBBH=B.MXDM,FSSLB=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FSSLBBH=B.MXDM AND B.LBDM='145'  
 UPDATE  A set FIFXJSXMBH=B.MXDM,FIFXJSXM=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FIFXJSXMBH=B.MXDM AND B.LBDM='112' 
 UPDATE  A set FMZFJBH=B.MXDM,FMZFJ=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FMZFJBH=B.MXDM AND B.LBDM='146' 
 UPDATE  A set FMZBFZBH=B.MXDM,FMZBFZ=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FMZBFZBH=B.MXDM AND B.LBDM='147' 
 UPDATE  A set FSSLTZZSBJBH=B.MXDM,FSSLTZZSBJ=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FSSLTZZSBJBH=B.MXDM AND B.LBDM='112'  
 UPDATE  A set FSSFXFJBH=B.MXDM,FSSFXFJ=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FSSFXFJBH=B.MXDM AND B.LBDM='71' 
 UPDATE  A set FIFYFDSSBH=B.MXDM,FIFYFDSS=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FIFYFDSSBH=B.MXDM AND B.LBDM='112' 
 UPDATE  A set FSSFLBH=B.MXDM,FSSFL=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FSSJBBH=B.MXDM AND B.LBDM='235'
 UPDATE  A set FSSBWGRBH=B.MXDM,FSSBWGR=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FSSBWGRBH=B.MXDM AND B.LBDM='112' 
 UPDATE  A set FGRBWBH=B.MXDM,FGRBW=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FGRBWBH=B.MXDM AND B.LBDM='150' 
 UPDATE  A set FIFSHSWBH=B.MXDM,FIFSHSW=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FIFSHSWBH=B.MXDM AND B.LBDM='112' 
 UPDATE  A set FSQYFSYKJYWBH=B.MXDM,FSQYFSYKJYW=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FSQYFSYKJYWBH=B.MXDM AND B.LBDM='112'  
 UPDATE  A set FSZZJKJYWBH=B.MXDM,FSZZJKJYW=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FSZZJKJYWBH=B.MXDM AND B.LBDM='112' 
 UPDATE  A set FSZZJKJYWYYBH=B.MXDM,FSZZJKJYWYY=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FSZZJKJYWYYBH=B.MXDM AND B.LBDM='152'  
 UPDATE  A set FSHYFSYKJYWBH=B.MXDM,FSHYFSYKJYW=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FSHYFSYKJYWBH=B.MXDM AND B.LBDM='112'  
 UPDATE  A set FSSYPFZBFFBH=B.MXDM,FSSYPFZBFF=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FSSYPFZBFFBH=B.MXDM AND B.LBDM='153'  
 UPDATE  A set FSZBDJCBH=B.MXDM,FSZBDJC=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FSZBDJCBH=B.MXDM AND B.LBDM='112'  
 UPDATE  A set FYWFJHZSSBH=B.MXDM,FYWFJHZSS=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FYWFJHZSSBH=B.MXDM AND B.LBDM='94'  
 UPDATE  A set FIFSZSXBH=B.MXDM,FIFSZSX=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FIFSZSXBH=B.MXDM AND B.LBDM='112'  
 UPDATE  A set FSZSXPZBH=B.MXDM,FSZSXPZ=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FSZSXPZBH=B.MXDM AND B.LBDM='154'  
 UPDATE  A set FSSBDYSLBLZDBH=B.MXDM,FSSBDYSLBLZD=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FSSBDYSLBLZDBH=B.MXDM AND B.LBDM='140' 
 UPDATE  A set FSQYSHBLZDBH=B.MXDM,FSQYSHBLZD=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FSQYSHBLZDBH=B.MXDM AND B.LBDM='140' 
 UPDATE  A set FIFSZYWYLBH=B.MXDM,FIFSZYWYL=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FIFSZYWYLBH=B.MXDM AND B.LBDM='112' 
 UPDATE  A set FQSMZSFTWXHBH=B.MXDM,FQSMZSFTWXH=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FQSMZSFTWXHBH=B.MXDM AND B.LBDM='112'  
 UPDATE  A set FMZYSZTZLBH=B.MXDM,FMZYSZTZL=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FMZYSZTZLBH=B.MXDM AND B.LBDM='112' 
 UPDATE  A set FMZYSZTZLSJBH=B.MXDM,FMZYSZTZLSJ=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FMZYSZTZLSJBH=B.MXDM AND B.LBDM='237' 
 UPDATE  A set FMZYSXFFSZLBH=B.MXDM,FMZYSXFFSZL=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FMZYSXFFSZLBH=B.MXDM AND B.LBDM='112'  
 UPDATE  A set FIFXFFSCGBH=B.MXDM,FIFXFFSCG=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FIFXFFSCGBH=B.MXDM AND B.LBDM='112'  
 UPDATE  A set FIFSTEWARDBH=B.MXDM,FIFSTEWARD=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FIFSTEWARDBH=B.MXDM AND B.LBDM='112' 
 UPDATE  A set FJRMZFSSBH=B.MXDM,FJRMZFSS=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FJRMZFSSBH=B.MXDM AND B.LBDM='112' 
 UPDATE  A set FFSMZFYQSJBH=B.MXDM,FFSMZFYQSJ=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FFSMZFYQSJBH=B.MXDM AND B.LBDM='112'  
 UPDATE  A set FMZFYQXGSJBH=B.MXDM,FMZFYQXGSJ=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FMZFYQXGSJBH=B.MXDM AND B.LBDM='238' 
 --更新手术显示信息

update A set FSHYFYKJYWSJ='小于24小时' from #ba4 A where FSHYFYKJYWSJ='1'
update A set FSHYFYKJYWSJ='24-48小时' from #ba4 A where FSHYFYKJYWSJ='2'
update A set FSHYFYKJYWSJ='48-72小时' from #ba4 A where FSHYFYKJYWSJ='3'
update A set FSHYFYKJYWSJ='大于72小时' from #ba4 A where FSHYFYKJYWSJ='4'         

update A set FSQSYYFKJYWSJ='0.5小时' from #ba4 A where FSQSYYFKJYWSJ='1'
update A set FSQSYYFKJYWSJ='1小时' from #ba4 A where FSQSYYFKJYWSJ='2'
update A set FSQSYYFKJYWSJ='2小时' from #ba4 A where FSQSYYFKJYWSJ='3'
update A set FSQSYYFKJYWSJ='2小时及以上' from #ba4 A where FSQSYYFKJYWSJ='4'    

update A set FSHSWSJ='小于24小时' from #ba4 A where FSHSWSJ='1'
update A set FSHSWSJ='24-48小时' from #ba4 A where FSHSWSJ='2'
update A set FSHSWSJ='48-72小时' from #ba4 A where FSHSWSJ='3'
update A set FSHSWSJ='大于72小时' from #ba4 A where FSHSWSJ='4'    
   
 --默认第一个手术为主要手术                                 
 update #ba4 set FIFFSOP=0 where FOPTIMES=1        
 update #ba4 set FIFFSOP=1 where FOPTIMES<>1        
        
 update #ba4 set FZQSSBH=1 ,FZQSS='是' from  #ba4 a,CPOE_SSYZK b                  
 where  a.FZYID=b.SYXH AND a.FOPCODE=b.SSDM  AND  b.SSFL<>1                ------by  lius        
         
 --更新手术级别        
 UPDATE  A set FSSJBBH=B.MXDM,FSSJB=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FSSJBBH=B.MXDM AND B.LBDM='120'
 	update A set FSSJB='一级' from #ba4 A where FSSJBBH='1'
	update A set FSSJB='二级' from #ba4 A where FSSJBBH='2'
	update A set FSSJB='三级' from #ba4 A where FSSJBBH='3'
	update A set FSSJB='四级' from #ba4 A where FSSJBBH='4'
 
--更新切口等级
update A set FQIEKOU='0类' from #ba4 A where FQIEKOUBH='0'
update A set FQIEKOU='Ⅰ' from #ba4 A where FQIEKOUBH='1'
update A set FQIEKOU='Ⅱ' from #ba4 A where FQIEKOUBH='2'
update A set FQIEKOU='Ⅲ' from #ba4 A where FQIEKOUBH='3'         
update A set FQIEKOUBH='' from #ba4 A where FQIEKOUBH='无' 

--更新麻醉方式
update A set FMAZUIBH='35',FMAZUI='局部浸润麻醉' from #ba4 A where FMAZUIBH='0302'  

--将''转换为'-'
 update #ba4 set FMAZUI='-' where FMAZUI='' 
 update #ba4 set FMAZUI='-' where FMAZUI is NULL
 update #ba4 set FOPDOCT1BH='-' where FOPDOCT1BH='' and FOPCODE<>''
 update #ba4 set FOPDOCT1='-' where FOPDOCT1='' and FOPCODE<>''
 update #ba4 set FOPDOCT2BH='-' where FOPDOCT2BH='' and FOPCODE<>''
 update #ba4 set FOPDOCT2='-' where FOPDOCT2='' and FOPCODE<>''
 update #ba4 set FMZDOCTBH='-' where FMZDOCTBH='' and FOPCODE<>''
 update #ba4 set FMZDOCT='-' where FMZDOCT='' and FOPCODE<>''

       
 --HIS_妇婴卡（HIS_BA5）                  
 insert into #ba5(FSYXH, FPRN, FTIMES, FBABYNUM, FNAME, FBABYSEXBH, FBABYSEX, FTZ, FRESULTBH, FRESULT, FZGBH, FZG, FBABYSUC, FHXBH, FHX)                      
 select A.SYXH FSYXH,A.BAHM,B.YEXH,B.YEXH,A.HZXM,B.YEXB,D.NAME,CAST(ISNULL(YETZ,0.0) AS FLOAT) YETZ,B.CCQK,E.NAME,B.CYQK,F.NAME,null,null,null                  
 from  EMR_BRSYK A (nolock)         
 inner join #PAT P ON A.SYXH=P.EMRSYXH                 
 inner join  EMR_BASY_YEK B (nolock)  on B.QTBLJLXH=P.QTBLJLXH and B.SYXH=B.QTBLJLXH                  
 left join EMR_SYS_ZDFLMXK D (nolock) on D.MXDM=B.YEXB and D.LBDM = '3'                    
 left join EMR_SYS_ZDFLMXK E (nolock) on E.MXDM=B.CCQK and E.LBDM = '32'                  
 left join EMR_SYS_ZDFLMXK F (nolock) on E.MXDM=B.CYQK and E.LBDM = '34'            
         
 --中医院病人附加信息（HIS_BA8）                  
 insert into #ba8(FSYXH, FPRN, FTIMES, FZLLBBH, FZLLB, FZZZYBH, FZZZY, FRYCYBH, FRYCY,                  
 FMZZDZBBH, FMZZDZB, FMZZDZZBH,FMZZDZZ, FMZZYZDBH, FMZZYZD, FSSLCLJBH, FSSLCLJ, FSYJGZJBH, FSYJGZJ,                   
 FSYZYSBBH, FSYZYSB, FSYZYJSBH, FSYZYJS, FBZSHBH, FBZSH)                      
 select A.SYXH FSYXH,A.BAHM FPRN,A.RYCS FTIMES,B.ZLLB FZLLBBH,'' FZLLB,B.SYYLJGZYZJ FZZZYBH,'' FZZZY,B.RCFH_ZY FRYCYBH,'' FRYCY,                  
 B.MZZD_ZY FMZZDZBBH,B.MZZDMC_ZY FMZZDZB,B.MZZH_ZY FMZZDZZBH,B.MZZHMC_ZY FMZZDZZ,                  
 B.MZZD_ZY FMZZYZDBH,B.MZZDMC_ZY FMZZYZD,B.SSLCLJ FSSLCLJBH,'' FSSLCLJ,B.SYYLJGZYZJ FSYJGZJBH,'' FSYJGZJ,        
 B.SYZYZLSB FSYZYSBBH,'' FSYZYSB,B.SYZYZLJS FSYZYJSBH,'' FSYZYJS,B.BZSH FBZSHBH,'' FBZSH                  
 from  EMR_BRSYK A (nolock)        
 inner join #PAT P on A.SYXH=P.EMRSYXH                  
 left join EMR_BASYK B on B.QTBLJLXH=P.QTBLJLXH and B.SYXH=P.EMRSYXH                  
 where ISNULL(ZLLB,'')<>''     
 
  --根据字典代码获取名称字段                  
 update  A set FZLLB=B.NAME from #ba8 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FZLLBBH=B.MXDM  and B.LBDM='110'        
 update  A set FZZZY=B.NAME from #ba8 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FZZZYBH=B.MXDM  and B.LBDM='95'        
 update  A set FRYCY=B.NAME from #ba8 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FRYCYBH=B.MXDM  and B.LBDM='12'         
 update  A set FSSLCLJ=B.NAME from #ba8 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FSSLCLJBH=B.MXDM  and B.LBDM='111'         
 update  A set FSYJGZJ=B.NAME from #ba8 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FSYJGZJBH=B.MXDM  and B.LBDM='95'         
 update  A set FSYZYSB=B.NAME from #ba8 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FSYZYSBBH=B.MXDM  and B.LBDM='95'         
 update  A set FSYZYJS=B.NAME from #ba8 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FSYZYJSBH=B.MXDM  and B.LBDM='95'         
 update  A set FBZSH=B.NAME from #ba8 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FBZSHBH=B.MXDM  and B.LBDM='95'    
 
  insert into #His_ba_ahfy     (FSYXH,FPRN, FTIMES, FKSSSYFA,	FKSSSYSJ,	FJRSJ,	FZCSJ)
  SELECT A.SYXH SYXH ,A.BAHM FPRN,A.RYCS FTIMES,D.KSSZLFA FKSSSYFA,'',	D.ICURZSJ FJRSJ,D.ICUZCSJ FZCSJ
   from  EMR_BRSYK A (nolock)        
 inner join #PAT P on A.SYXH=P.EMRSYXH 
 inner join EMR_BASYK_FB D (nolock)  on  D.QTBLJLXH=P.QTBLJLXH and D.SYXH=A.SYXH 

  update  A set FJRSJ=NULL from #His_ba_ahfy  A (nolock) where  A.FJRSJ='1900-01-01 00:00:00.000'
  update  A set FZCSJ=NULL from #His_ba_ahfy  A (nolock) where  A.FZCSJ='1900-01-01 00:00:00.000'


  

 --  insert into #his_ba13     (FPRN, FTIMES)
 -- SELECT A.BAHM FPRN,A.RYCS FTIMES
 --  from  EMR_BRSYK A (nolock)        
 --inner join #PAT P on A.SYXH=P.EMRSYXH  
 -- inner join EMR_BASYK_FB D (nolock)  on D.QTBLJLXH=P.QTBLJLXH and D.SYXH=A.SYXH 

         
          
        
 --是否手术                                                  
 update #ba1 set FIFSS=1 where exists (select 1 from #ba4 where #ba4.FSYXH=#ba1.FSYXH)               
 --更新转科科室信息        
 update  A set FZKDEPT =B.NAME from #ba2 A , EMR_SYS_KSDMK B (nolock) where  A.FZKTYKH=B.KSDM                                            
 --首次转科                                                  
 --update #ba1 set FZKTYKH=B.FZKTYKH,FZKDEPT=B.FZKDEPT, FZKDATE=B.FZKDATE,FZKTIME=B.FZKTIME from #ba2 B where B.FTIMES=1           
 update A SET A.FZKTYKH=B.FZKTYKH,A.FZKDEPT=B.FZKDEPT,A.FZKDATE=B.FZKDATE,A.FZKTIME=B.FZKTIME FROM #ba1 A,(select t.* from        
 (select *,row_number() over (partition by FPRN,FTIMES order by FPRN,FTIMES,FZKDATE,FZKTIME desc) rn from #ba2) t        
 where rn=1) B WHERE A.FPRN=B.FPRN AND A.FTIMES=B.FTIMES          
 --delete #ba2 where FTIMES=1         
        
 --年龄 按天算        
 update a set a.NLDAYS = datediff(dd,a.FBIRTHDAY,a.FRYDATE) from #ba1 a        
 --新年龄计算        
 select dbo.CalculateAge(FBIRTHDAY,FRYDATE) ba into #aa from #ba1 a        
 update a set a.FAGENEW=dbo.CalculateAge(FBIRTHDAY,FRYDATE) from #ba1 a        
 --年龄不足一周岁计算        
 update a set FNLBZYZS=dbo.CalculateAgeDetails(FBIRTHDAY,FRYDATE) from #ba1 a where a.NLDAYS<365        
 --年龄计算（以Y/M/D开头）        
 update a set FAGE=case when FLOOR(a.NLDAYS/365.00)>=1 then 'Y'+cast(FLOOR(a.NLDAYS/365.00) as varchar(4))        
 when a.NLDAYS/30>=1 then 'M'+cast(a.NLDAYS/30 as varchar(4))        
 when a.NLDAYS>=1 then 'D'+cast(a.NLDAYS as varchar(4))         
 else 'D0' end        
 from #ba1 a        
-- --默认不足一天婴儿年龄--mwg        
 update a set FNLBZYZS=0.03 from #ba1 a where FAGE='D0'        
        
 --强制将质控日期调整为出院日期后一天 (质控日期小于出院日期)       
 update A SET A.FZKRQ=dateadd(dd,1,A.FCYDATE) from #ba1 A where A.FZKRQ<A.FCYDATE       
 --汉江 强制将病案质量调整为甲级病案(本院未要求-mwg)        
 --update A SET A.FQUALITYBH='1',A.FQUALITY='甲' from #ba1 A        
         
 --处理费用                  
 if exists(select * from sysobjects where name='#BRFYMXK' and xtype='U')                   
 BEGIN                  
  DROP TABLE #BRFYMXK                  
 END                  
 select a.syxh as syxh,convert(varchar(12),idm) idm,zje,ypdm,dxmdm,jlzt 
 into #BRFYMXK 
 from [172.20.0.41\ZY].[THIS_ZY].[dbo].XZY_BRFYMXK as a,#PAT p where a.syxh=p.HISSYXH
 
 create  index  idx_idm_ypdm on  #BRFYMXK(idm,ypdm)                      
 -------add lr20140909 总费用;                  
 
 update a set FSUM1=b.FSUM1 from #ba1 a,                      
 (select c.syxh,sum(c.zje) FSUM1 from #BRFYMXK c         
 group by c.syxh) b                   
 where a.FZYID=b.syxh                  --alter by z_jx 2017年2月25日17:44:14              

        
 ----西药费                                                 
 update a set FXYF=b.FXYF from #ba1 a,                                                                                    
 (select c.syxh,sum(c.zje) FXYF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d  on  convert(varchar,c.idm)=d.xmdm and d.fylb='0' and c.idm<>'0'                                        
 where d.id='13'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                  
        
 ---add lr20170217 中成药费;                                                                                              
 update a set FZCHYF=b.FZCHYF from #ba1 a,                                                                                    
 (select c.syxh,sum(c.zje) FZCHYF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d  on  convert(varchar,c.idm)=d.xmdm and d.fylb='0' and c.idm<>'0'                   
 where d.id='14'  group by c.syxh) b                
 where a.FZYID=convert(varchar(20),b.syxh)               
        
 ---add lr20170217 中草药费;                                                                                                                              
 update a set FZCYF=b.FZCYF from #ba1 a,                                                                                    
 (select c.syxh,sum(c.zje) FZCYF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on convert(varchar,c.idm)=d.xmdm and d.fylb='0' and c.idm<>'0'                                        
 where d.id='15'   group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)               
 ------------------------------------------              
        
 ---add lr20170217 其他费;                                                                                              
 update a set FQTF=b.FQTF from #ba1 a,                                                                                    
 (select c.syxh,sum(c.zje) FQTF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                         
 where d.id='24'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                                               
 ---add lr20170217 自付金额;                                                       
 update a set FZFJE=b.FZFJE from #ba1 a,                                                          
 (select c.syxh,sum(c.zfje) FZFJE from [172.20.0.41\ZY].[THIS_ZY].[dbo].ZY_BRJSK c                                                      
 group by c.syxh) b                                                       
 where a.FZYID=convert(varchar(20),b.syxh)                                                                                 
 ---add lr20170217 一般医疗服务费;                                                                                                                               
 update a set FZHFWLYLF=b.FZHFWLYLF from #ba1 a,                                                                                    
 (select c.syxh,sum(c.zje) FZHFWLYLF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                         
 where d.id='1'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                                               
 ---add lr20170217 一般治疗操作费;                                                                                                                    
 update a set FZHFWLCZF=b.FZHFWLCZF from #ba1 a,                                                                                    
 (select c.syxh,sum(c.zje) FZHFWLCZF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                         
 where d.id='2'  group by c.syxh) b                                    
 where a.FZYID=convert(varchar(20),b.syxh)                                                               
 ---add lr20170217 护理费;                                                          
 update a set FZHFWLHLF=b.FZHFWLHLF from #ba1 a,                                              
 (select c.syxh,sum(c.zje) FZHFWLHLF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                         
 where d.id='3'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                                                            
 ---add lr20170217 综合医疗服务其他费;                                                          
 update a set FZHFWLQTF=b.FZHFWLQTF from #ba1 a,                                                                                    
 (select c.syxh,sum(c.zje) FZHFWLQTF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                         
 where d.id='4'  group by c.syxh) b                     
 where a.FZYID=convert(varchar(20),b.syxh)                    
 ---add lr20170217 病理诊断费;                           
 update a set FZDLBLF=b.FZDLBLF from #ba1 a,                                                                                    
 (select c.syxh,sum(c.zje) FZDLBLF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                         
 where d.id='5'  group by c.syxh) b                       
 where a.FZYID=convert(varchar(20),b.syxh)                
 ---add lr20170217 实验室诊断费;                                                          
 update a set FZDLSSSF=b.FZDLSSSF from #ba1 a,                                                                                    
 (select c.syxh,sum(c.zje) FZDLSSSF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                         
 where d.id='6'  group by c.syxh) b          
 where a.FZYID=convert(varchar(20),b.syxh)                                                          
 ---add lr20170217 影像学诊断费;                                                          
 update a set FZDLYXF=b.FZDLYXF from #ba1 a,                                                                                    
 (select c.syxh,sum(c.zje) FZDLYXF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                         
 where d.id='7'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                    
 ---add lr20170217 临床诊断项目费;                                                          
 update a set FZDLLCF=b.FZDLLCF from #ba1 a,                                                                                      
 (select c.syxh,sum(c.zje) FZDLLCF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                       
 where d.id='8'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                    
 ---add lr20170217 非手术治疗项目费;                                                          
 update a set FZLLFFSSF=b.FZLLFFSSF from #ba1 a,                                                                                     
 (select c.syxh,sum(c.zje) FZLLFFSSF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                     
 where d.id='9'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                            
 ---add lr20170217 临床物理治疗费;                                                         
 update a set FZLLFWLZWLF=b.FZLLFWLZWLF from #ba1 a,                
 (select c.syxh,sum(c.zje) FZLLFWLZWLF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                     
 where d.id='9-1'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                            
 ---add lr20170217 手术治疗费;                                                          
 update a set FZLLFSSF=b.FZLLFSSF from #ba1 a,                                                                                      
 (select c.syxh,sum(c.zje) FZLLFSSF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                     
 where d.id='10'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                            
 ---add lr20170217 麻醉费;                                                          
 update a set FZLLFMZF=b.FZLLFMZF from #ba1 a,                                                                                     
 (select c.syxh,sum(c.zje) FZLLFMZF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                  
 where d.id='10-1'  group by c.syxh) b                                
 where a.FZYID=convert(varchar(20),b.syxh)                                                        
 ---add lr20170217 手术费;                                                          
 update a set FZLLFSSZLF=b.FZLLFSSZLF from #ba1 a,                                                                                      
 (select c.syxh,sum(c.zje) FZLLFSSZLF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                   
 where d.id='10-2'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                  
 ---add lr20170217 康复费;                                        
 update a set FKFLKFF=b.FKFLKFF from #ba1 a,                                                                                     
 (select c.syxh,sum(c.zje) FKFLKFF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                      
 where d.id='11'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                          
 ---add lr20170217 抗菌药物费;                                                          
 update a set  FXYLGJF=b.FXYLGJF from #ba1 a,                                        
 (select c.syxh,sum(c.zje) FXYLGJF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on  convert(varchar,c.idm)=d.xmdm and d.fylb='0' and c.idm<>'0'                                                        
 where d.id='13-1' group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                           
 ---add lr20170217 血费;                                           
 update a set FXYLXF=b.FXYLXF from #ba1 a,                                                                                       
 (select c.syxh,sum(c.zje) FXYLXF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                      
 where d.id='16'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                         
 ---add lr20170217 白蛋白类制品费;  (未对应)                                                        
 update a set FXYLBQBF=b.FXYLBQBF from #ba1 a,                                                             
 (select c.syxh,sum(c.zje) FXYLBQBF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                   
 where d.id='17'   group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                         
 ---add lr20170217 球蛋白类制品费;                                                          
 update a set FXYLQDBF=b.FXYLQDBF from #ba1 a,                                
 (select c.syxh,sum(c.zje) FXYLQDBF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                    
 where d.id='18' group by c.syxh) b                              
 where a.FZYID=convert(varchar(20),b.syxh)                                                         
 ---add lr20170217 凝血因子类制品费;                                             
 update a set FXYLYXYZF=b.FXYLYXYZF from #ba1 a,                                                                                    
 (select c.syxh,sum(c.zje) FXYLYXYZF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                      
 where d.id='38'  group by c.syxh) b                                 
 where a.FZYID=convert(varchar(20),b.syxh)                                                          
 ---add lr20170217 细胞因子类制品费;                  
 update a set FXYLXBYZF=b.FXYLXBYZF from #ba1 a,                                  
 (select c.syxh,sum(c.zje) FXYLXBYZF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                       
 where d.id='20'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                         
 ---add lr20170217 检查用一次性医用材料费;                           
 update a set FHCLCJF=b.FHCLCJF from #ba1 a,                
 (select c.syxh,sum(c.zje) FHCLCJF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                     
 where d.id='21'  group by c.syxh) b                                         
 where a.FZYID=convert(varchar(20),b.syxh)                                                      
 ---add lr20170217 治疗用一次性医用材料;                                                          
 update a set FHCLZLF=b.FHCLZLF from #ba1 a,                                                                                     
 (select c.syxh,sum(c.zje) FHCLZLF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                 
 where d.id='22'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                          
 ---add lr20170217 手术用一次性医用材料费;                                           
 update a set FHCLSSF=b.FHCLSSF from #ba1 a,                     
 (select c.syxh,sum(c.zje) FHCLSSF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                   
 where d.id='23' group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                       
 ---add lr20170217 中医辨证论治费;                                                          
 update a set  FZHFWLYLF01=b.FZHFWLYLF01 from #ba1 a,                                                                                      
 (select c.syxh,sum(c.zje) FZHFWLYLF01 from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                     
 where d.id='02'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                      
 ---add lr20170217 中医辨证论治会诊费;                                             
 update a set  FZHFWLYLF02=b.FZHFWLYLF02 from #ba1 a,                                                                                    
 (select c.syxh,sum(c.zje) FZHFWLYLF02 from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                       
 where d.id='03'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                      
 ---add lr20170217 中医诊断费;                    
 update a set FZYLZDF=b.FZYLZDF from #ba1 a,                                                                   
 (select c.syxh,sum(c.zje) FZYLZDF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                       
 where d.id='18'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                          
 ---add lr20170217 中医治疗费;   （未对应）                                                      
 update a set FZYLZF=b.FZYLZLF from #ba1 a,                                                                                       
 (select c.syxh,sum(c.zje) FZYLZLF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                      
 where d.id='19'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                  
 ---add lr20170217 中医外治费;          
 update a set FZYLZLF01=b.FZYLZLF01 from #ba1 a,                                         
 (select c.syxh,sum(c.zje) FZYLZLF01 from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                     
 where d.id='20'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                      
 ---add lr20170217 中医骨伤费;                                                  
 update a set FZYLZLF02=b.FZYLZLF02 from #ba1 a,                                                                          
 (select c.syxh,sum(c.zje) FZYLZLF02 from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                     
 where d.id='22'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                
 ---add lr20170217 中医针灸费;                                                          
 update a set FZYLZLF03=b.FZYLZLF03 from #ba1 a,                                                                                     
 (select c.syxh,sum(c.zje) FZYLZLF03 from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                       
 where d.id='23'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                         
 ---add lr20170217 中医推拿治疗费;                                                          
 update a set FZYLZLF04=b.FZYLZLF04 from #ba1 a,                                                                        
 (select c.syxh,sum(c.zje) FZYLZLF04 from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                       
 where d.id='24'  group by c.syxh) b                             
 where a.FZYID=convert(varchar(20),b.syxh)                                                       
 ---add lr20170217 中医肛肠治疗费;                                                          
 update a set FZYLZLF05=b.FZYLZLF05 from #ba1 a,                   
 (select c.syxh,sum(c.zje) FZYLZLF05 from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                   
 where d.id='25'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                        
 ---add lr20170217 中医特殊治疗费;                                                          
 update a set FZYLZLF06=b.FZYLZLF06 from #ba1 a,                                                                                        
 (select c.syxh,sum(c.zje) FZYLZLF06 from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                      
 where d.id='26'  group by c.syxh) b                                  
 where a.FZYID=convert(varchar(20),b.syxh)                       
 ---add lr20170217 中医其他费;                                                            
 update a set FZYLQTF=b.FZYLQTF from #ba1 a,                                                                                      
 (select c.syxh,sum(c.zje) FZYLQTF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                       
 where d.id='27'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                    
 ---add lr20170217 中医特殊调配加工费;                                                          
 update a set FZYLQTF01=b.FZYLQTF01 from #ba1 a,                                                                           
 (select c.syxh,sum(c.zje) FZYLQTF01 from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                          
 where d.id='28'  group by c.syxh) b                 
 where a.FZYID=convert(varchar(20),b.syxh)                                         
 ---add lr20170217 中医辨证施膳费;                                                          
 update a set FZYLQTF02=b.FZYLQTF02 from #ba1 a,                                                                                       
 (select c.syxh,sum(c.zje) FZYLQTF02 from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                           
 where d.id='29'  group by c.syxh) b                                                
 where a.FZYID=convert(varchar(20),b.syxh)                                                      
 ---add lr20170217 中医制剂费;                                                          
 update a set FZCLJGZJF=b.FZCLJGZJF from #ba1 a,                                                                          
 (select c.syxh,sum(c.zje) FZCLJGZJF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on  convert(varchar,c.idm)=d.xmdm and d.fylb='1' and c.idm<>'0'                                                    
 where d.id='33'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                  
            ---zzz   
update #ba1 set FZHFWLYLF='29750.00'  where FPRN='20190000521'
update #ba1 set FZHFWLCZF='9705.30'  where FPRN='20190000521'
update #ba1 set FZHFWLHLF='1023.60'  where FPRN='20190000521'
update #ba1 set FZHFWLQTF='1818.00'  where FPRN='20190000521'
update #ba1 set FZDLSSSF='2471.40'  where FPRN='20190000521'
update #ba1 set FZDLYXF='5396.20'  where FPRN='20190000521'
update #ba1 set FZDLLCF='947.60'  where FPRN='20190000521'
update #ba1 set FZLLFFSSF='4048.00'  where FPRN='20190000521'
update #ba1 set FZLLFWLZWLF='3898.40'  where FPRN='20190000521'
update #ba1 set FZLLFSSF='16996.00'  where FPRN='20190000521'
update #ba1 set FZLLFMZF='797.50'  where FPRN='20190000521'
update #ba1 set FZLLFSSZLF='10655.50'  where FPRN='20190000521'
update #ba1 set FKFLKFF='2640.00'  where FPRN='20190000521'
update #ba1 set FSUM1='160407.34'  where FPRN='20190000521'
update #ba1 set FXYF='61316.24'  where FPRN='20190000521'
update #ba1 set FZCHYF='3299.51'  where FPRN='20190000521'
update #ba1 set FXYLGJF='1845.76'  where FPRN='20190000521'
update #ba1 set FXYLXF='315.00'  where FPRN='20190000521'
update #ba1 set FHCLCJF='168.56'  where FPRN='20190000521'
update #ba1 set FHCLZLF='12917.73'  where FPRN='20190000521'
update #ba1 set FHCLSSF='7544.20'  where FPRN='20190000521'
update #ba1 set FQTF='50.00'  where FPRN='20190000521'

update #ba1 set FXYF=FXYF+FXYLGJF
update #ba1 set FZLLFSSF=FZLLFMZF+FZLLFSSF+FZLLFSSZLF
update #ba1 set FZLLFFSSF=FZLLFFSSF+FZLLFWLZWLF 
update #ba1 set FZFJE=0 where FZFJE<0
  update #ba1 set  FQTF=FSUM1-(FZHFWLYLF+FZHFWLCZF+FZHFWLHLF+FZHFWLQTF+FZDLBLF+FZDLSSSF+FZDLYXF+FZDLLCF+FZLLFFSSF+FZLLFSSF+FKFLKFF+FZYLZF+FXYLXF+
FXYLBQBF+FXYLQDBF+FXYLYXYZF+FXYLXBYZF+FHCLCJF+FHCLZLF+FHCLSSF+FXYF+FZCYF+FZCHYF) where
 FSUM1-(FZHFWLYLF+FZHFWLCZF+FZHFWLHLF+FZHFWLQTF+FZDLBLF+FZDLSSSF+FZDLYXF+FZDLLCF+FZLLFFSSF+FZLLFSSF+FKFLKFF+FZYLZF+FXYLXF+
FXYLBQBF+FXYLQDBF+FXYLYXYZF+FXYLXBYZF+FHCLCJF+FHCLZLF+FHCLSSF+FXYF+FZCYF+FZCHYF)>0          
       
END        
ELSE IF (@type=1)        
BEGIN         
 --PRINT(1)        
 --HIS_病人住院信息（HIS_BA1）                  
 insert into #ba101(FIFINPUT, FICDVERSION, FZYID, FPRN, FTIMES)                      
 select '0' FIFINPUT, '11' FICDVERSION, A.HISSYXH, A.BAHM FPRN,A.RYCS FTIMES                  
 from EMR_BRSYK A (nolock)         
 inner join #PAT2 P ON A.SYXH=P.EMRSYXH                 
 left join EMR_BASYK B (nolock) on B.QTBLJLXH=P.QTBLJLXH and B.SYXH=P.EMRSYXH                  
 --处理费用                  
 if exists(select * from sysobjects where name='#BRFYMXK1' and xtype='U')                   
 BEGIN                  
  DROP TABLE #BRFYMXK1                 
 END                  
 select a.syxh as syxh,convert(varchar(12),idm) idm,zje,ypdm,dxmdm,jlzt 
 into #BRFYMXK1 
 from [172.20.0.41\ZY].[THIS_ZY].[dbo].XZY_BRFYMXK as a,#PAT2 p where a.syxh=p.HISSYXH     
                    
 ---add lr20140909 总费用;                  
 update a set FSUM1=b.FSUM1 from #ba101 a,                      
 (select c.syxh,sum(c.zje) FSUM1 from #BRFYMXK1 c         
 group by c.syxh) b        
 where a.FZYID=b.syxh                  
 --- alter by z_jx 2017年2月25日17:44:14              
        
        
 ----西药费                                                 
 update a set FXYF=b.FXYF from #ba101 a,                                                                                    
 (select c.syxh,sum(c.zje) FXYF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d  on  convert(varchar,c.idm)=d.xmdm and d.fylb='0' and c.idm<>'0'                                        
 where d.id='13'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)        
                 
        
 ---add lr20170217 中成药费;                                                                                              
 update a set FZCHYF=b.FZCHYF from #ba101 a,                                                                                    
 (select c.syxh,sum(c.zje) FZCHYF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d  on convert(varchar,c.idm)=d.xmdm and d.fylb='0' and c.idm<>'0'                   
 where d.id='14'  group by c.syxh) b                 
 where a.FZYID=convert(varchar(20),b.syxh)               
        
 ---add lr20170217 中草药费;                                                                                                       
 update a set FZCYF=b.FZCYF from #ba101 a,                                                                                    
 (select c.syxh,sum(c.zje) FZCYF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on convert(varchar,c.idm)=d.xmdm and d.fylb='0' and c.idm<>'0'                                        
 where d.id='15'   group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)               
 ------------------------------------------              
        
 ---add lr20170217 其他费;                                                                                              
 update a set FQTF=b.FQTF from #ba101 a,                                                                
 (select c.syxh,sum(c.zje) FQTF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                         
 where d.id='24'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                                               
 ---add lr20170217 自付金额;                                                       
 update a set FZFJE=b.FZFJE from #ba101 a,                                                          
 (select c.syxh,sum(c.zfje) FZFJE from [172.20.0.41\ZY].[THIS_ZY].[dbo].ZY_BRJSK c                                                      
 group by c.syxh) b                                                       
 where a.FZYID=convert(varchar(20),b.syxh)                                                                                 
 ---add lr20170217 一般医疗服务费;                                                                                                                               
 update a set FZHFWLYLF=b.FZHFWLYLF from #ba101 a,                                                                                    
 (select c.syxh,sum(c.zje) FZHFWLYLF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                         
 where d.id='1'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                                               
 ---add lr20170217 一般治疗操作费;                                                                                                                    
 update a set FZHFWLCZF=b.FZHFWLCZF from #ba101 a,                                                                                    
 (select c.syxh,sum(c.zje) FZHFWLCZF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                         
 where d.id='2'  group by c.syxh) b         
 where a.FZYID=convert(varchar(20),b.syxh)                                                               
 ---add lr20170217 护理费;                                                          
 update a set FZHFWLHLF=b.FZHFWLHLF from #ba101 a,                                              
 (select c.syxh,sum(c.zje) FZHFWLHLF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                         
 where d.id='3'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                                                            
 ---add lr20170217 综合医疗服务其他费;                                                          
 update a set FZHFWLQTF=b.FZHFWLQTF from #ba101 a,                                                                                    
 (select c.syxh,sum(c.zje) FZHFWLQTF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                         
 where d.id='4'  group by c.syxh) b                     
 where a.FZYID=convert(varchar(20),b.syxh)                    
 ---add lr20170217 病理诊断费;                           
 update a set FZDLBLF=b.FZDLBLF from #ba101 a,             
 (select c.syxh,sum(c.zje) FZDLBLF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                         
 where d.id='5'  group by c.syxh) b                       
 where a.FZYID=convert(varchar(20),b.syxh)                
 ---add lr20170217 实验室诊断费;                                                          
 update a set FZDLSSSF=b.FZDLSSSF from #ba101 a,                                                                                    
 (select c.syxh,sum(c.zje) FZDLSSSF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                         
 where d.id='6'  group by c.syxh) b                                                      
 where a.FZYID=convert(varchar(20),b.syxh)                                                          
 ---add lr20170217 影像学诊断费;                                                          
 update a set FZDLYXF=b.FZDLYXF from #ba101 a,                                                                                    
 (select c.syxh,sum(c.zje) FZDLYXF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                         
 where d.id='7'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                    
 ---add lr20170217 临床诊断项目费;                                                          
 update a set FZDLLCF=b.FZDLLCF from #ba101 a,                                                                                      
 (select c.syxh,sum(c.zje) FZDLLCF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                       
 where d.id='8'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                    
 ---add lr20170217 非手术治疗项目费;                                                          
 update a set FZLLFFSSF=b.FZLLFFSSF from #ba101 a,                                                                                     
 (select c.syxh,sum(c.zje) FZLLFFSSF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                     
 where d.id='9'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                            
 ---add lr20170217 临床物理治疗费;                                                         
 update a set FZLLFWLZWLF=b.FZLLFWLZWLF from #ba101 a,                
 (select c.syxh,sum(c.zje) FZLLFWLZWLF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                    
 where d.id='9-1'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                            
 ---add lr20170217 手术治疗费;                                                          
 update a set FZLLFSSF=b.FZLLFSSF from #ba101 a,                                                                                      
 (select c.syxh,sum(c.zje) FZLLFSSF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                     
 where d.id='10'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                            
 ---add lr20170217 麻醉费;                                                          
 update a set FZLLFMZF=b.FZLLFMZF from #ba101 a,                                                                                     
 (select c.syxh,sum(c.zje) FZLLFMZF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                  
 where d.id='10-1'  group by c.syxh) b                                
 where a.FZYID=convert(varchar(20),b.syxh)                                                        
 ---add lr20170217 手术费;          
 update a set FZLLFSSZLF=b.FZLLFSSZLF from #ba101 a,                                                                                      
 (select c.syxh,sum(c.zje) FZLLFSSZLF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                   
 where d.id='10-2'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                  
 ---add lr20170217 康复费;                                                        
 update a set FKFLKFF=b.FKFLKFF from #ba101 a,                                                                                     
 (select c.syxh,sum(c.zje) FKFLKFF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                      
 where d.id='11'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                          
 ---add lr20170217 抗菌药物费;                                                          
 update a set  FXYLGJF=b.FXYLGJF from #ba101 a,                                        
 (select c.syxh,sum(c.zje) FXYLGJF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on  convert(varchar,c.idm)=d.xmdm and d.fylb='0' and c.idm<>'0'                                                        
 where d.id='13-1' group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                           
 ---add lr20170217 血费;                                           
 update a set FXYLXF=b.FXYLXF from #ba101 a,                                                                                       
 (select c.syxh,sum(c.zje) FXYLXF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                      
 where d.id='16'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                         
 ---add lr20170217 白蛋白类制品费;  (未对应)                                                        
 update a set FXYLQDBF=b.FXYLQDBF from #ba101 a,                                                                
 (select c.syxh,sum(c.zje) FXYLQDBF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                   
 where d.id='17'   group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                              
 ---add lr20170217 球蛋白类制品费;                                                          
 update a set FXYLQDBF=b.FXYLQDBF from #ba101 a,                                                                                      
 (select c.syxh,sum(c.zje) FXYLQDBF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                    
 where d.id='18' group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)  
 ---add lr20170217 凝血因子类制品费;                                             
 update a set FXYLYXYZF=b.FXYLYXYZF from #ba101 a,                                                                                    
 (select c.syxh,sum(c.zje) FXYLYXYZF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                      
 where d.id='38'  group by c.syxh) b                                 
 where a.FZYID=convert(varchar(20),b.syxh)                                                          
 ---add lr20170217 细胞因子类制品费;                  
 update a set FXYLXBYZF=b.FXYLXBYZF from #ba101 a,                                  
 (select c.syxh,sum(c.zje) FXYLXBYZF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                       
 where d.id='20'  group by c.syxh) b             
 where a.FZYID=convert(varchar(20),b.syxh)                                                         
 ---add lr20170217 检查用一次性医用材料费;                           
 update a set FHCLCJF=b.FHCLCJF from #ba101 a,                                                                            
 (select c.syxh,sum(c.zje) FHCLCJF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                     
 where d.id='21'  group by c.syxh) b                                         
 where a.FZYID=convert(varchar(20),b.syxh)                                                      
 ---add lr20170217 治疗用一次性医用材料;                                                          
 update a set FHCLZLF=b.FHCLZLF from #ba101 a,                                                                                     
 (select c.syxh,sum(c.zje) FHCLZLF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                 
 where d.id='22'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                          
 ---add lr20170217 手术用一次性医用材料费;                                           
 update a set FHCLSSF=b.FHCLSSF from #ba101 a,                     
 (select c.syxh,sum(c.zje) FHCLSSF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                   
 where d.id='23' group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                       
 ---add lr20170217 中医辨证论治费;                                                          
 update a set  FZHFWLYLF01=b.FZHFWLYLF01 from #ba101 a,                                                                                      
 (select c.syxh,sum(c.zje) FZHFWLYLF01 from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                     
 where d.id='02'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                      
 ---add lr20170217 中医辨证论治会诊费;                                                          
 update a set  FZHFWLYLF02=b.FZHFWLYLF02 from #ba101 a,                                                                                    
 (select c.syxh,sum(c.zje) FZHFWLYLF02 from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                       
 where d.id='03'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)  
 ---add lr20170217 中医诊断费;                    
 update a set FZYLZDF=b.FZYLZDF from #ba101 a,                                                                                       
 (select c.syxh,sum(c.zje) FZYLZDF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                       
 where d.id='18'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                          
 ---add lr20170217 中医治疗费;   （未对应）                                                      
 update a set FZYLZF=b.FZYLZLF from #ba101 a,                                                                                       
 (select c.syxh,sum(c.zje) FZYLZLF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                      
 where d.id='19'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                  
 ---add lr20170217 中医外治费;          
 update a set FZYLZLF01=b.FZYLZLF01 from #ba101 a,                                         
 (select c.syxh,sum(c.zje) FZYLZLF01 from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                   
 where d.id='20'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                      
 ---add lr20170217 中医骨伤费;                                                          
 update a set FZYLZLF02=b.FZYLZLF02 from #ba101 a,                                                                          
 (select c.syxh,sum(c.zje) FZYLZLF02 from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                     
 where d.id='22'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                
 ---add lr20170217 中医针灸费;                                                          
 update a set FZYLZLF03=b.FZYLZLF03 from #ba101 a,                                                                                     
 (select c.syxh,sum(c.zje) FZYLZLF03 from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                       
 where d.id='23'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                         
 ---add lr20170217 中医推拿治疗费;                                                          
 update a set FZYLZLF04=b.FZYLZLF04 from #ba101 a,                                                                        
 (select c.syxh,sum(c.zje) FZYLZLF04 from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                       
 where d.id='24'  group by c.syxh) b                             
 where a.FZYID=convert(varchar(20),b.syxh)                                                       
 ---add lr20170217 中医肛肠治疗费;                                                          
 update a set FZYLZLF05=b.FZYLZLF05 from #ba101 a,                                                                                       
 (select c.syxh,sum(c.zje) FZYLZLF05 from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                   
 where d.id='25'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                               
 ---add lr20170217 中医特殊治疗费;                                                          
 update a set FZYLZLF06=b.FZYLZLF06 from #ba101 a,                                                                                        
 (select c.syxh,sum(c.zje) FZYLZLF06 from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                      
 where d.id='26'  group by c.syxh) b                                  
 where a.FZYID=convert(varchar(20),b.syxh)                                                     
 ---add lr20170217 中医其他费;                                                            
 update a set FZYLQTF=b.FZYLQTF from #ba101 a,                                                                                      
 (select c.syxh,sum(c.zje) FZYLQTF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                       
 where d.id='27'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                    
 ---add lr20170217 中医特殊调配加工费;                                                          
 update a set FZYLQTF01=b.FZYLQTF01 from #ba101 a,                                                                           
 (select c.syxh,sum(c.zje) FZYLQTF01 from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                          
 where d.id='28'  group by c.syxh) b                 
 where a.FZYID=convert(varchar(20),b.syxh)                                         
 ---add lr20170217 中医辨证施膳费;                            
 update a set FZYLQTF02=b.FZYLQTF02 from #ba101 a,                                                                            
 (select c.syxh,sum(c.zje) FZYLQTF02 from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                       
 where d.id='29'  group by c.syxh) b                                                
 where a.FZYID=convert(varchar(20),b.syxh)                                                      
 ---add lr20170217 中医制剂费;                                                          
 update a set FZCLJGZJF=b.FZCLJGZJF from #ba101 a,                                                                          
 (select c.syxh,sum(c.zje) FZCLJGZJF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on  convert(varchar,c.idm)=d.xmdm and d.fylb='1' and c.idm<>'0'                                                    
 where d.id='33'  group by c.syxh) b           
 where a.FZYID=convert(varchar(20),b.syxh)         
END        
 
update #ba101 set FXYF=FXYF+FXYLGJF
update #ba101 set FZLLFSSF=FZLLFMZF+FZLLFSSF+FZLLFSSZLF
update #ba101 set FZLLFFSSF=FZLLFFSSF+FZLLFWLZWLF 
 update #ba101 set FZFJE=0 where FZFJE<0
 update #ba101 set  FQTF=FSUM1-(FZHFWLYLF+FZHFWLCZF+FZHFWLHLF+FZHFWLQTF+FZDLBLF+FZDLSSSF+FZDLYXF+FZDLLCF+FZLLFFSSF+FZLLFSSF+FKFLKFF+FZYLZF+FXYLXF+
FXYLBQBF+FXYLQDBF+FXYLYXYZF+FXYLXBYZF+FHCLCJF+FHCLZLF+FHCLSSF+FXYF+FZCYF+FZCHYF) where
 FSUM1-(FZHFWLYLF+FZHFWLCZF+FZHFWLHLF+FZHFWLQTF+FZDLBLF+FZDLSSSF+FZDLYXF+FZDLLCF+FZLLFFSSF+FZLLFSSF+FKFLKFF+FZYLZF+FXYLXF+
FXYLBQBF+FXYLQDBF+FXYLYXYZF+FXYLXBYZF+FHCLCJF+FHCLZLF+FHCLSSF+FXYF+FZCYF+FZCHYF)>0          
      
update A set fyydm=B.fyydm from #ba2 A,#ba1 B where A.FSYXH=B.FSYXH
update A set fyydm=B.fyydm from #ba3 A,#ba1 B where A.FSYXH=B.FSYXH
update A set fyydm=B.fyydm from #ba4 A,#ba1 B where A.FSYXH=B.FSYXH
update A set fyydm=B.fyydm from #ba5 A,#ba1 B where A.FSYXH=B.FSYXH
update A set fyydm=B.fyydm from #ba8 A,#ba1 B where A.FSYXH=B.FSYXH
update A set fyydm=B.fyydm from #His_ba_ahfy A,#ba1 B where A.FSYXH=B.FSYXH
update A set fyydm=B.fyydm from #His_BaFy A,#ba1 B where A.FSYXH=B.FSYXH  
if @type = 0        
 begin        
  update b set b.FZYID = a.EMRSYXH from #PAT a,#ba1 b  where a.HISSYXH = b.FZYID        
  DROP TABLE #PAT        
 end        
        
if @type = 1        
 begin        
  update b set b.FZYID = a.EMRSYXH from #PAT2 a,#ba1 b  where a.HISSYXH = b.FZYID        
  DROP TABLE #PAT2        
 end        
         
COMMIT TRAN        
SET XACT_ABORT OFF        
        
--返回结果集        
IF(@type = 0)        
BEGIN        
SELECT 'his_ba1,his_ba2,his_ba3,his_ba4,his_ba5,his_ba8,his_ba_ahfy,his_bafy' tables        -- 
select * from #ba1    --WHERE FPRN='201906919'     
select * from #ba2       
select * from #ba3       
select * from #ba4      
select * from #ba5      
select * from #ba8  
select * from #His_ba_ahfy   
select * from #His_BaFy --WHERE FPRN='201906919'
--select * from #his_ba13 
END        

ELSE        
BEGIN        
 SELECT 'his_ba1' tables        
select * from #ba101 -- where FPRN='20190012530'      
        
END          
SET nocount off         
        

