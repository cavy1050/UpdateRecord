
/*
生成HQMS数据存储
*/
ALTER PROCEDURE usp_ba_getbasj
  @ksrq varchar(16),
  @jsrq varchar(16)
  --@zjerrcode tinyint out,    --错误消息
  --@zjerrmsg  varchar(200) out--错误内容
AS




  declare @rq1 varchar(10), @rq2 varchar(10)
  set @rq1=convert(date,LEFT
(@ksrq,8),112)
  set @rq2=convert(date,LEFT(@jsrq,8),112)
	--exec usp_ba_getbasj '20190101','20190601'
	--@author xie_peng

	--1:获取机构代码及机构名称
  declare @dwdm varchar(200),@dwmc varchar(200),@icdver varchar(2),@opver varchar(2),@execSql varchar(6000)
  select @dwdm = fvalue from tparam where fcode = 'hospitalCode'
  select @dwmc = fvalue from tparam where fcode = 'hospitalName'
	select @icdver = fvalue from tparam where fcode = 'hqmsIcd10ZdVersion'
	select @opver = fvalue from tparam where fcode = 'hqmsIcd9
OpVersion'

	--2:新建临时表数据
	select * into #Tupdata_hqms from Tupdata_hqms where 1=2
    select a.* into #tpatientvisit from tpatientvisit a where a.fcydate>=@rq1 and a.fcydate<@rq2
	and FCYDEPT not like '大公馆%' and  FCYDEPT not like '黄水%' and  FCYDEPT not like '三病区%'and  FCYDEPT not like '精神科%'  
	and FCYBS NOT LIKE '黄水%'  and  FCYBS not like '大公馆%'  and fyydm='01'
	
	--ADD BY QGY 排除大公馆黄水数据病房
	and fprn<>'20190005860'

	alter table #Tupdata_hqms
	alter column P66 int

	--3:抓取数据
	insert into #Tupdata_hqms(P900,P6891,P686,P800,P1,P2,P3,P4,P5,P6,P7,P8,P9,P101,P102,P103,P11,
	P12,P13,P801,P802,P803,P14,P15,P16,P17,P171,P18,P19,P20,P804,P21,P22,
	P23,P231,P24,P25,P26,P261,P27,P28,P281,P29,P30,P301,P31,P321,P322,
	P805,P323,P324,P325,P806,P326,P327,P328,P807,P329,P3291,P3292,P808,
	P3293,P3294,P3295,P809,P3296,P3297,P3298,P810,P3299,P3281,P3282,P811,
	P3283,P3284,P3285,P812,P3286,P3287,P3288,P813,P3289,P3271,P3272,P814,
	P3273,P3274,P3275,P815,P3276,P689,P351,P352,P816,P353,P354,P817,P355,
	P356,P818,P361,P362,P363,P364,P365,P366,P371,P372,P38,P39,P40,P411,
	P412,P413,P414,P415,P421,P422,P687,P688,P431,P432,P433,P434,P819,P435,
	P436,P437,P438,P44,P45,P46,P47,P490,P491,P820,P492,P493,P494,P495,P496,
	P497,P498,P4981,P499,P4910,P4911,P4912,P821,P4913,P4914,P4915,P4916,
	P4917,P4918,P4919,P4982,P4920,P4921,P4922,P4923,P822,P4924,P4925,P4526,
	P4527,P4528,P4529,P4530,P4983,P4531,P4532,P4533,P4534,P823,P4535,P4536,
	P4537,P4538,P4539,P4540,P4541,P4984,P4542,P4543,P4544,P4545,P824,P4546,
	P4547,P4548,P4549,P4550,P4551,P4552,P4985,P4553,P4554,P45002,P45003,P825,
	p45004,p45005,p45006,p45007,p45008,p45009,p45010,p45011,p45012,p45013,
	p45014,p45015,P826,p45016,p45017,p45018,p45019,p45020,p45021,p45022,
	p45023,p45024,p45025,p45026,p45027,P827,p45028,p45029,p45030,p45031,

	p45032,p45033,p45034,p45035,p45036,p45037,p45038,p45039,P828,p45040,
	p45041,p45042,p45043,p45044,p45045,p45046,p45047,p45048,p45049,p45050,
	p45051,P829,p45052,p45053,p45054,p45055,p45056,p45057,p45058,p45059,
	p45060,p45061,P561,P562,P563,P564,P6911,P6912,P6913,P6914,P6915,
	P6916,P6917,P6918,P6919,P6920,P6921,P6922,P6923,P6924,P6925,P57,P58,
	P581,P60,P611,P612,P613,P59,P62,P63,P64,P651,P652,P653,P654,P655,
	P656,P66,P681,P682,P683,P684,P685,P67,P731,P732,P733,P734,P72,P830,
	P831,P741,P742,P743,P782,P751,P752,P754,P755,P756,P757,P758,P759,
	P760,P761,P762,P763,P764,P765,P767,P768,P769,P770,P771,P772,P773,
	P774,P775,P776,P777,P778,P779,P780,P781,P901,P902,p903,P904,P905,P906,P907,P908
	
	
	)  --ADD BY QGY P11 插入民族代码 P902籍贯代码
	select @dwdm P900,@dwmc 
P6891,'' P686,fascard1 P800,ffbbhnew P1,#tpatientvisit.ftimes P2,#tpatientvisit.fprn P3,fname P4,fsexbh P5,
	convert(varchar(10),fbirthday,120) P6,datediff(year,fbirthday,frydate) P7,
	fstatusbh P8,fjobbh P9,fbirthplacep P101,fbirthplacec P102,fbirthplaced P103,FNATIONALITYBH P11, 
	fcountry P12,fidcard P13,isnull(fcurraddr,'')+isnull(FCURRADDRBZ,'') P801,
	CASE WHEN ISNULL(fcurrtele,'')='' THEN FLXTELE ELSE fcurrtele END  P802, --联系电话
	fcurrpost P803,isnull(fdwaddr,'')+isnull(fdwname,'') P14,fdwtele P15,

	fdwpost P16,--fhkaddr P17
	case  when isnull(FHKADDRBZ,'')='' then fhkaddr
		 else FHKADDRBZ
	end P17
	,fhkpost P171,flxname P18,frelate P19,flxaddr P20,frytjbh P804,flxtele P21,
	convert(varchar(10),frydate,120)+' '+FRYTIME P22,
	frytykh P23,frybs P231
,fzktykh P24,convert(varchar(10),fcydate,120)+' '+FCYTIME P25,fcytykh P26,fcybs P261,fdays P27,fmzzdbh P28,
	fmzzd P281,fryinfobh P29,fryzdbh P30,fryzd P301,convert(varchar(10),fzyzdqzdate,120) P31,'' P321,'' P322,
	'' P805,'' P323,'' P324,'' P325,'' P806
,'' P326,'' P327,'' P328,'' P807,'' P329,'' P3291,'' P3292,'' P808,
	'' P3293,'' P3294,'' P3295,'' P809,'' P3296,'' P3297,'' P3298,'' P810,'' P3299,'' P3281,'' P3282,'' P811,
	'' P3283,'' P3284,'' P3285,'' P812,'' P3286,'' P3287,'' P3288,'' P813,'' P3289,
'' P3271,'' P3272,'' P814,
	'' P3273,'' P3274,'' P3275,'' P815,'' P3276,fyngr P689,fphzdbh P351,fphzd P352,fphzdnum P816,'' P353,'' P354,
	'' P817,'' P355,'' P356,'' P818,'' P361,'' P362,'' P363,'' P364,'' P365,'' P366,'' P371,fgmyw P372,fhbsagbh P38,
	fhcvabbh P39,fhivabbh P40,fmzcyaccobh P411,frycyaccobh P412,fopaccobh P413,flcblaccobh P414,ffsblaccobh P415,
	fqjtimes P421,fqjsuctimes P422,'' P687,'' P688,fkzr P431,fzrdoctor P432,fzzdoct P433,fzydoct P434,fnurse P819,
	fjxdoct P435,fyjssxdoct P436,fsxdoct P437,fbmy P438,fqualitybh P44,fzkdoct P45,fzknurse P46,
	convert(varchar(10),fzkrq,120) P47,'' P490,null P491,'' P820,'' P492,'' P493,null P494,'' P495,'' P496,
	'' P497,'' P498,'' P4981,'' P499,'' P4910,'' P4911,null P4912,'' P821,'' P4913,'' P4914,null P4915,'' P4916,
	'' P4917,'' P4918,'' P4919,'' P4982,'' P4920,'' P4921,'' P4922,null P4923,'' P822,'' P4924,'' P4925,null P4526,
	'' P4527,'' P4528,'' P4529,'' P4530,'' P4983,'' P4531,'' P4532,'' P4533,null P4534,'' P823,'' P4535,'' P4536,
	null P4537,
'' P4538,'' P4539,'' P4540,'' P4541,'' P4984,'' P4542,'' P4543,'' P4544,null P4545,'' P824,'' P4546,
	'' P4547,null P4548,'' P4549,'' P4550,'' P4551,'' P4552,'' P4985,'' P4553,'' P4554,'' P45002,null P45003,'' P825,
	'' p45004,'' p45005,0 p45006,'' p45007
,'' p45008,'' p45009,'' p45010,'' p45011,'' p45012,'' p45013,
	'' p45014,null p45015,'' P826,'' p45016,'' p45017,0 p45018,'' p45019,'' p45020,'' p45021,'' p45022,
	'' p45023,'' p45024,'' p45025,'' p45026,null p45027,'' P827,'' p45028,'' p45029,0 p45030,''
 p45031,
	'' p45032,'' p45033,'' p45034,'' p45035,'' p45036,'' p45037,'' p45038,null p45039,'' P828,'' p45040,
	'' p45041,0 p45042,'' p45043,'' p45044,'' p45045,'' p45046,'' p45047,'' p45048,'' p45049,'' p45050,
	null p45051,'' P829,'' p45052,'' p45053,null p45054,'' p45055,'' p45056,'' p45057,'' p45058,'' p45059,
	'' p45060,'' p45061,fhlts P561,fhl1 P562,fhl2 P563,fhl3 P564,'' P6911,null P6912,null P6913,'' P6914,null P6915,
	null P6916,'' P6917,null P6918,null P6919,'' P6920,null P6921,null P6922,'' P6923,null P6924,null P6925,
	fbodybh P57,'' P58,'' P581,fisszbh P60,fszqx P611,
	fszqxy P612,fszqxn P613,fsamplebh P59,fbloodbh P62,frhbh P63,(case when fsxfybh = '3' then 0 else fsxfybh end) P64,
	fredcell P651,fplaque P652,fserous P653,fallblood P654,0 P655,fotherblood P656,
	fnlbzyzs P66,fcstz P681,fcstz2 P682,null P683,null P684,null P685,frytz P67,fryqhmhours P731,fryqhmmins P732,fryhmhours P733,
	fryhmmins P734,0 P72,fisagainrybh P830,fisagainrymd P831,flyfsbh P741,
	case when flyfsbh=2 then fyzouthostital
		when  flyfsbh=3 then fsqouthostital
  	end P742,
	fsqouthostital P743,
	fsum1 P782,(case when fzfje>fsum1 then fsum1 else  fzfje end ) P751,fzhfwlylf P752,fzhfwlczf P754,fzhfwlhlf P755,
	fzhfwlqtf P756,fzdlblf P757,fzdlsssf P758,fzdlyxf P759,fzdllcf P760,fzllffssf P761,
	(case when fzllfwlzwlf>fzllffssf then fzllffssf else fzllfwlzwlf end) P762,fzllfssf P763,fzllfmzf P764,
	(case when (fzllfmzf+fzllfsszlf)>fzllfssf then (fzllfssf-fzllfmzf) else fzllfsszlf end ) P765,fkflkff P767,fzylzf P768,
	fxyf
 P769,(case when fxylgjf>fxyf then fxyf else fxylgjf end) P770,fzchyf P771,fzcyf P772,fxylxf P773,fxylbqbf P774,
	fxylqdbf P775,fxylyxyzf P776,fxylxbyzf P777,fhclcjf P778,fhclzlf P779,fhclssf P780,fqtf P781,FBIRTHPLACE P901 --ADD BY QGY出生地
	,
	--b.fjgss
	
'' P902,'' p903,FBODYBH P904,case when isnull(FBLOODBH,'')='' then 6 else FBLOODBH end   P905,
	
	
	case when isnull(FRHBH,'')='' then 4 else FRHBH end   P906,
	FRYQHMDAYS P907,FRYHMDAYS P908
	 --add by qgy P902籍贯代码 p903是否过敏 P904死亡尸检，P905 ABO血型，P906 RH血型

	from #tpatientvisit  --left  join BASYFJ b on #tpatientvisit.fprn=b.FPRN 
	
	--


	--fzdlx = '1'
	update a set a.P321 = b.ficdm,a.P322 = b.fjbname,a.P805 = b.frybqbh,a.P323 = b.fzljgbh from #Tupdata_hqms a,tdiagnose b 
	where b.fzdlx = '1' and b.fpx = 1 and a.P3 = b.fprn and a.P2 = b.ftimes
	--fzdlx = '2' and fpx = '1'
	update a set a.P324 = b.ficdm,a.P325 = b.fjbname,a.P806 = b.frybqbh,a.P326 = b.fzljgbh from #Tupdata_hqms a,tdiagnose b 
	where b.fzdlx = '2' and b.fpx = 1 and a.P3 = b.fprn and a.P2 = b.ftimes
	--fzdlx = '2' and fpx = '2'
	update a set a.P327 = b.ficdm,a.P328 = b.fjbname,a.P807 = b.frybqbh,a.P329 = b.fzljgbh from #Tupdata_hqms a,tdiagnose b 
	where b.fzdlx = '2' and b.fpx = 2 and a.P3 = b.fprn and a.P2 = b.ftimes
	--fzdlx = '2' and fpx ='3'
	update a set a.P3291 = b.ficdm,a.P3292 = b.fjbname,a.P808 = b.frybqbh,a.P3293 = b.fzljgbh from #Tupdata_hqms a,tdiagnose b 
	where b.fzdlx = '2' and b.fpx = 3 and a.P3 = b.fprn and a.P2 = b.ftimes
	--fzdlx = '2' and fpx = '4'
	update a set a.P3294 =b.ficdm,a.P3295 = b.fjbname,a.P809 = b.frybqbh,a.P3296 = b.fzljgbh from #Tupdata_hqms a,tdiagnose b 
	where b.fzdlx = '2' and b.fpx = 4 and a.P3 = b.fprn and a.P2 = b.ftimes
	--fzdlx = '2' and fpx = '5'
	update a set a.P3297 = b.ficdm,a.P3298 = b.fjbname,a.P810 = b.frybqbh,a.P3299 = b.fzljgbh from #Tupdata_hqms a,tdiagnose b 
	where b.fzdlx = '2' and b.fpx = 5 and a.P3 = b.fprn and a.P2 = b.ftimes
	--fzdlx = '2' and fpx = '6'
	update a set a.P3281 = b.ficdm,a.P3282 = b.fjbname,a.P811 = b.frybqbh,a.P3283 = b.fzljgbh from #Tupdata_hqms a,tdiagnose b 
	where b.fzdlx = '2' and b.fpx = 6 and a.P3 = b.fprn and a.P2 = b.ftimes
	--fzdlx = '2' and fpx = '7'
	update a set a.P3284 = b.ficdm,a.P3285 = b.fjbname,a.P812 = b.frybqbh,a.P3286 = b.fzljgbh from #Tupdata_hqms a,tdiagnose b 
	where b.fzdlx = '2' and b.fpx = 7 and a.P3 = b.fprn and a.P2 = b.ftimes
	--fzdlx = '2' and fpx = '8'
	update a set a.P3287 = b.ficdm,a.P3288 = b.fjbname,a.P813 = b.frybqbh,a.P3289 = b.fzljgbh from #Tupdata_hqms a,tdiagnose b 
	where b.fzdlx = '2' and b.fpx = 8 and a.P3 = b.fprn and a.P2 = b.ftimes
	--fzdlx = '2' and fpx = '9'
	update a set a.P3271 = b.ficdm,a.P3272 = b.fjbname,a.P814 = b.frybqbh,a.P3273 = b.fzljgbh from #Tupdata_hqms a,tdiagnose b 
	where b.fzdlx = '2' and b.fpx = 9 AND a.P3 = b.fprn and a.P2 = b.ftimes
	--fzdlx = '2' and fpx = '10'
	update a set a.P3274 = b.ficdm,a.P3275 = b.fjbname,a.P815 = b.frybqbh,a.P3276 = b.fzljgbh from #Tupdata_hqms a,tdiagnose b 
	where b.fzdlx = '2' and b.fpx = 10 and a.P3 = b.fprn and a.P2 = b.ftimes
	----add by qgy诊断 
		--fzdlx = '2' and fpx = '11'

   update a set a.C06x11C = b.ficdm,a.C07x11N = b.fjbname,a.C08x11C = b.frybqbh from #Tupdata_hqms a,tdiagnose b 
	where b.fzdlx = '2' and b.fpx = 11 and a.P3 = b.fprn and a.P2 = b.ftimes
	UPDATE a set a.C06x11C = b.fupicdm,a.C07x11N = b.fupjbname from #Tupdata_hqms a,tupicd10set b where b.fflag = '0'
	and b.ficdm = a.C06x11C 
	
	update a set a.C06x12C = b.ficdm,a.C07x12N = b.fjbname,a.C08x12C = b.frybqbh from #Tupdata_hqms a,tdiagnose b 
	where b.fzdlx = '2' and b.fpx = 12 and a.P3 = b.fprn and a.P2 = b.ftimes
		update a set a.C06x12C = b.fupicdm,a.C07x12N = b.fupjbname from #Tupdata_hqms a,tupicd10set b where b.fflag = '0'
	and b.ficdm = a.C06x12C 
	

	update a set a.C06x13C = b.ficdm,a.C07x13N
 = b.fjbname,a.C08x13C = b.frybqbh from #Tupdata_hqms a,tdiagnose b 
	where b.fzdlx = '2' and b.fpx = 13 and a.P3 = b.fprn and a.P2 = b.ftimes
	update a set a.C06x13C = b.fupicdm,a.C07x13N = b.fupjbname from #Tupdata_hqms a,tupicd10set b where b.fflag = '0' 
	and b.ficdm = a.C06x13C 

	update a set a.C06x14C = b.ficdm,a.C07x14N = b.fjbname,a.C08x14C = b.frybqbh from #Tupdata_hqms a,tdiagnose b 
	where b.fzdlx = '2' and b.fpx = 14 and a.P3 = b.fprn and a.P2 = b.ftimes
	update a set a.C06x14C = b.fupicdm,a.C07x14N = b.fupjbname from #Tupdata_hqms a,tupicd10set b where b.fflag = '0' 
	and b.ficdm = a.C06x14C 
--其他诊断15
	update a set a.C06x15C = b.ficdm,a.C07x15N = b.fjbname,a.C08x15C = b.frybqbh from #Tupdata_hqms a,tdiagnose b 
	where b.fzdlx = '2' and b.fpx
 = 15 and a.P3 = b.fprn and a.P2 = b.ftimes
	update a set a.C06x15C = b.fupicdm,a.C07x15N = b.fupjbname from #Tupdata_hqms a,tupicd10set b where b.fflag = '0' 
	and b.ficdm = a.C06x15C 
--其他诊断16
   update a set a.C06x16C = b.ficdm,a.C07x16N = b.fjbname,a.C08x16C = b.frybqbh from #Tupdata_hqms a,tdiagnose b 
	where b.fzdlx = '2' and b.fpx = 16 and a.P3 = b.fprn and a.P2 = b.ftimes
	update a set a.C06x16C = b.fupicdm,a.C07x16N = b.fupjbname from #Tupdata_hqms a,tupicd10set b where b.fflag = '0' 
	and b.ficdm = a.C06x16C  
   
    update a set a.C06x17C = b.ficdm,a.C07x17N = b.fjbname,a.C08x17C = b.frybqbh from #Tupdata_hqms a,tdiagnose b 
	where b.fzdlx = '2' and b.fpx = 17 and a.P3 = b.fprn and a.P2 = b.ftimes
	update a set a.C06x17C = b.fupicdm,a.C07x17N = b.fupjbname from #Tupdata_hqms a,tupicd10set b where b.fflag = '0' 
	and b.ficdm = a.C06x17C              
  --其他诊断18
   update a set a.C06x18C = b.ficdm,a.C07x18N = b.fjbname,a.C08x18C = b.frybqbh from #Tupdata_hqms a,tdiagnose b 
	where b.fzdlx = '2' and b.fpx = 18 and a.P3 = b.fprn and a.P2 = b.ftimes
	update a set a.C06x18C = b.fupicdm,a.C07x18N = b.fupjbname from #Tupdata_hqms a,tupicd10set b where b.fflag = '0' 
	and b.ficdm = a.C06x18C              
    --             
	update a set a.C06x19C = b.ficdm,a.C07x19N = b.fjbname,a.C08x19C = b.frybqbh from #Tupdata_hqms a,tdiagnose b 
	where b.fzdlx = '2' and b.fpx = 19 and a.P3 = b.fprn and a.P2 = b.ftimes
	update a set a.C06x19C = b.fupicdm,a.C07x19N = b.fupjbname from #Tupdata_hqms a,tupicd10set b where b.fflag = '0' 
	and b.ficdm = a.C06x19C
	 
	update a set a. C06x20C   = b.ficdm,a.C07x20N = b.fjbname,a.C08x20C = b.frybqbh from #Tupdata_hqms a,tdiagnose b 
	where b.fzdlx = '2' and b.fpx = 20 and a.P3 = b.fprn and a.P2 = b.ftimes
	update a set a. C06x20C   = b.fupicdm,a.C07x20N = b.fupjbname from #Tupdata_hqms a,tupicd10set b where b.fflag = '0' 
	and b.ficdm = a. C06x20C     
	                 
    update a set a. C06x21C   = b.ficdm,a.C07x21N = b.fjbname,a.C08x21C = b.frybqbh from #Tupdata_hqms a,tdiagnose b 
	where b.fzdlx = '2' and b.fpx = 21 and a.P3 = b.fprn and a.P2 = b.ftimes
	update a set a. C06x21C   = b.fupicdm,a.C07x21N = b.fupjbname 
from #Tupdata_hqms a,tupicd10set b where b.fflag = '0' 
	and b.ficdm = a. C06x21C              
                        
    update a set a. C06x22C   = b.ficdm,a.C07x22N = b.fjbname,a.C08x22C = b.frybqbh from #Tupdata_hqms a,tdiagnose b 
	where b.fzdlx = '2' and b.fpx = 22 and a.P3 = b.fprn and a.P2 = b.ftimes
	update a set a. C06x22C   = b.fupicdm,a.C07x22N = b.fupjbname 
from #Tupdata_hqms a,tupicd10set b where b.fflag = '0' 
	and b.ficdm = a. C06x22C                
                 


	----end by qgy
	--fzdlx = 's' and fpx = '1' 损伤中毒
	update a set a.P361 = b.ficdm,a.P362 = b.fjbname from #Tupdata_hqms a,tdiagnose b where b.fzdlx in ('s','S') and b.fpx = 1 and a.P3 = b.fprn and a.P2 = b.ftimes
	

	--operate foptimes = '1'
	update a set a.P490 = b.fopcode,a.P491 = convert(varchar(20),b.fopdate,120),a.P820 = b.fssjbbh,a.P492 = b.fop,a.P495 = b.fdocname,a.P496 = b.fopdoct1,
	a.P497 = b.fopdoct2,a.P498 =  b.FMAZUIBH --case when isnull(b.fmazuibh,'')='' then b.FMAZUI elseb.FMAZUIBH end  --麻醉编号为空麻醉名称为横线时
	,a.P499 = (case when (select id from YY_QKYHDJ c where c.qkdj=b.fqiekoubh and c.yhlb=b.fyuhebh)>0 then (select id from YY_QKYHDJ c where c.qkdj=b.fqiekoubh and c.yhlb=b.fyuhebh)else 0 end)--b.fqiekoubh
	,a.P4910 = b.fmzdoct
	from #Tupdata_hqms a,toperation b where b.fpx = 1 and a.P3 = b.fprn and a.P2 = b.ftimes
	
	--operate foptimes = '2'
	update a set a.P4911 = b.fopcode,a.P4912 = convert(varchar(20),b.fopdate,120),a.P821 = b.fssjbbh,a.P4913 = b.fop,a.P4916 = b.fdocname,a.P4917 = b.fopdoct1,
	a.P4918 = b.fopdoct2,a.P4919 = b.fmazuibh,a.P4920 =(case when (select id from YY_QKYHDJ c where c.qkdj=b.fqiekoubh and c.yhlb=b.fyuhebh)>0 then (select id from YY_QKYHDJ c where c.qkdj=b.fqiekoubh and c.yhlb=b.fyuhebh)else 0 end)
	

	,a.P4921 = b.fmzdoct
	from #Tupdata_hqms a,toperation b where b.fpx = 2 and a.P3 = b.fprn and a.P2 = b.ftimes

	--operate foptimes = '3'
	update a set a.P4922 = b.fopcode,a.P4923 = convert(varchar(20),b.fopdate,120),a.P822 = b.fssjbbh,a.P4924 = b.fop,a.P4527 = b.fdocname,a.P4528 = b.fopdoct1,
	a.P4529 = b.fopdoct2,a.P4530 = b.fmazuibh,a.P4531 = (case when (select id from YY_QKYHDJ c where c.qkdj=b.fqiekoubh and c.yhlb=b.fyuhebh)>0 then (select id from YY_QKYHDJ c where c.qkdj=b.fqiekoubh and c.yhlb=b.fyuhebh)else 0 end)
	,a.P4532 = b.fmzdoct
	from #Tupdata_hqms a,toperation b where b.fpx = 3 and a.P3 = b.fprn and a.P2 = b.ftimes

	--operate foptimes = '4'
	update a set a.P4533 = b.fopcode,a.P4534 = convert(varchar(20),b.fopdate,120),a.P823 = b.fssjbbh,a.P4535 = b.fop,a.P4538 = b.fdocname,a.P4539 = b.fopdoct1,
	a.P4540 = b.fopdoct2,a.P4541 = b.fmazuibh,a.P4542 = (case when (select id from YY_QKYHDJ c where c.qkdj=b.fqiekoubh and c.yhlb=b.fyuhebh)>0 then (select id from YY_QKYHDJ c where c.qkdj=b.fqiekoubh and c.yhlb=b.fyuhebh)else 0 end)
	
	,a.P4543 = b.fmzdoct
	from #Tupdata_hqms a,toperation b where b.fpx = 4 and a.P3 = b.fprn and a.P2 = b.ftimes

	--operate foptimes = '5'
	update a set a.P4544 = b.fopcode,a.P4545 = convert(varchar(20),b.fopdate,120),a.P824 = b.fssjbbh,a.P4546 = b.fop,a.P4549 = b.fdocname,a.P4550 = b.fopdoct1,
	a.P4551 = b.fopdoct2,a.P4552 = b.fmazuibh,a.P4553 = (case when (select id from YY_QKYHDJ c where c.qkdj=b.fqiekoubh and c.yhlb=b.fyuhebh)>0 then (select id from YY_QKYHDJ c where c.qkdj=b.fqiekoubh and c.yhlb=b.fyuhebh)else 0 end)
	,a.P4554 = b.fmzdoct
	from #Tupdata_hqms a,toperation b where b.fpx = 5 and a.P3 = b.fprn and a.P2 = b.ftimes

	--opearte foptimes = '6'
	update a set a.P45002 = b.fopcode,a.P45003 = convert(varchar(10),b.fopdate,120),a.P825 = b.fssjbbh,a.p45004 = b.fop,a.p45007 = b.fdocname,a.p45008 = b.fopdoct1,
	a.p45009 = b.fopdoct2,a.p45010 = b.fmazuibh,a.p45012 = (case when (select id from YY_QKYHDJ c where c.qkdj=b.fqiekoubh and c.yhlb=b.fyuhebh)>0 then (select
 id from YY_QKYHDJ c where c.qkdj=b.fqiekoubh and c.yhlb=b.fyuhebh)else 0 end)
	,a.p45013 = b.fmzdoct
	from #Tupdata_hqms a,toperation b where b.fpx = 6 and a.P3 = b.fprn and a.P2 = b.ftimes

	--opearte foptimes = '7'
	update a set a.p45014 = b.fopcode,a.p45015 = convert(varchar(20),b.fopdate,120),a.P826 = b.fssjbbh,a.p45016 = b.fop,a.p45019 = b.fdocname,a.p45020 = b.fopdoct1,
	a.p45021 = b.fopdoct2,a.p45022 = b.fmazuibh,a.p45024 = (case when (select id from YY_QKYHDJ c where c.qkdj=b.fqiekoubh and c.yhlb
=b.fyuhebh)>0 then (select id from YY_QKYHDJ c where c.qkdj=b.fqiekoubh and c.yhlb=b.fyuhebh)else 0 end)
	,a.p45025 = b.fmzdoct
	from #Tupdata_hqms a,toperation b where b.fpx = 7 and a.P3 = b.fprn and a.P2 = b.ftimes
	
	--opearte foptimes = '8'
	update a set a.p45026 = b.fopcode,a.p45027 = convert(varchar(20),b.fopdate,120),a.P827 = b.fssjbbh,a.p45028 = b.fop,a.p45031 = b.fdocname,a.p45032 = b.fopdoct1,
	a.p45033 = b.fopdoct2,a.p45034 = b.fmazuibh,a.p45036 = (case when (select id from YY_QKYHDJ c where c.qkdj=b.fqiekoubh and c.yhlb=b.fyuhebh)>0 then (select id from YY_QKYHDJ c where c.qkdj=b.fqiekoubh and c.yhlb=b.fyuhebh)else 0 end)
	
	,a.p45037 = b.fmzdoct
	from #Tupdata_hqms a,toperation b where b.fpx = 8 and a.P3 = b.fprn and a.P2 = b.ftimes

	--opearte foptimes = '9'
	update a set a.p45038 = b.fopcode,a.p45039 = convert(varchar(20),b.fopdate,120),a.P828 = b.fssjbbh,a.p45040 = b.fop,a.p45043 = b.fdocname,a.p45044 = b.fopdoct1,
	a.p45045 = b.fopdoct2,a.p45046 = b.fmazuibh,a.p45048 = (case when (select id from YY_QKYHDJ c where c.qkdj=b.fqiekoubh and c.yhlb=b.fyuhebh)>0 then (select id from YY_QKYHDJ c where c.qkdj=b.fqiekoubh and c.yhlb=b.fyuhebh)else 0 end)
	,a.p45049 = b.fmzdoct
	from #Tupdata_hqms a,toperation b where b.fpx = 9 and a.P3 = b.fprn AND a.P2 = b.ftimes
	
	--opearte foptimes = '10'
	update a set a.p45050 = b.fopcode,a.p45051 = convert(varchar(20),b.fopdate,120),a.P829 = b.fssjbbh,a.p45052 = b.fop,a.p45055 = b.fdocname,a.p45056 = b.fopdoct1,
	a.p45057 = b.fopdoct2,a.p45058 = b.fmazuibh,a.
p45060 = (case when (select id from YY_QKYHDJ c where c.qkdj=b.fqiekoubh and c.yhlb=b.fyuhebh)>0 then (select id from YY_QKYHDJ c where c.qkdj=b.fqiekoubh and c.yhlb=b.fyuhebh)else 0 end),a.p45061 = b.fmzdoct
	from #Tupdata_hqms a,toperation b where b.fpx
 = 10 and a.P3 = b.fprn and a.P2 = b.ftimes
	--其他手术10到17
	update a set a.C35x10C = b.fopcode,a.C36x10N=b.FOP,a.C37x10 = convert(varchar(20),b.fopdate,120),a.C38x10 = b.fssjbbh,a.C39x10 = b.fdocname,a.C40x10 = b.fopdoct1,
	a.C41x10 = b.fopdoct2,a.C42x10C =
 
(case when (select id from YY_QKYHDJ c where c.qkdj=b.fqiekoubh and c.yhlb=b.fyuhebh)>0 then (select id from YY_QKYHDJ c where c.qkdj=b.fqiekoubh and c.yhlb=b.fyuhebh)else 0 end)
,a.C43x10C = b.fmazuibh,a.C44x10 = b.fmzdoct from #Tupdata_hqms a,toperation
 b where b.fpx = 11 and a.P3 = b.fprn and a.P2 = b.ftimes

  --更新手术代码名称
   update a set a.C35x10C = b.fupopcode,a.C36x10N = b.fupopname  from #Tupdata_hqms a,tupicd9set b where b.fflag = '0'
	and b.fopcode = a.C35x10C 

	--麻醉方式
	update a set a.C43x10C = b
.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC013' and a.C43x10C = b.fbh 
	--手术级别
    update a set a.C38x10 = b.fdsfbh  from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC029' and a.C38x10 = b.fbh and isnull(b.fdsfbh,'')<>''




	update a set a.C35x11C = b.fopcode,a.C36x11N=b.FOP,a.C37x11 = convert(varchar(20),b.fopdate,120),a.C38x11 = b.fssjbbh,a.C39x11 = b.fdocname,a.C40x11 = b.fopdoct1,
	a.C41x11 = b.fopdoct2,a.C42x11C = 
(case when (select id from YY_QKYHDJ c where c.qkdj=b.fqiekoubh and c.yhlb=b.fyuhebh)>0 then (select id from YY_QKYHDJ c where c.qkdj=b.fqiekoubh and c.yhlb=b.fyuhebh)else 0 end)
,a.C43x11C = b.fmazuibh,a.C44x11 = b.fmzdoct from #Tupdata_hqms a,toperation
 b where b.fpx = 12 and a.P3 = b.fprn and a.P2 = b.ftimes

  --更新手术代码名称
   update a set a.C35x11C = b.fupopcode,a.C36x11N = b.fupopname  from #Tupdata_hqms a,tupicd9set b where b.fflag = '0'
	and b.fopcode = a.C35x11C 

	--麻醉方式1
	update a set a.C43x11C = 
b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC013' and a.C43x11C = b.fbh 
	--手术级别1
    update a set a.C38x11 = b.fdsfbh  from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC029' and a.C38x11 = b.fbh and isnull(b.fdsfbh,'')<>''
	
--获取手术数据
	update a set a.C35x12C = b.fopcode,a.C36x12N=b.FOP,a.C37x12 = convert(varchar(20),b.fopdate,120),a.C38x12 = b.fssjbbh,a.C39x12 = b.fdocname,a.C40x12 = b.fopdoct1,
	a.C41x12 = b.fopdoct2,a.C42x11C = 
(case when (select id from YY_QKYHDJ c where c.qkdj=b.fqiekoubh and c.yhlb=b.fyuhebh)>0 then (select id from YY_QKYHDJ c where c.qkdj=b.fqiekoubh and c.yhlb=b.fyuhebh)else 0 end)
,a.C43x12C = b.fmazuibh,a.C44x12 = b.fmzdoct from #Tupdata_hqms a,toperation
 b where b.fpx = 13 and a.P3 = b.fprn and a.P2 = b.ftimes

  --更新手术代码名称
   update a set a.C35x12C = b.fupopcode,a.C36x12N = b.fupopname  from #Tupdata_hqms a,tupicd9set b where b.fflag = '0'
	and b.fopcode = a.C35x12C 

	--麻醉方式1
	update a set a.C43x12C = 
b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC013' and a.C43x12C = b.fbh 
	--手术级别1
    update a set a.C38x12 = b.fdsfbh  from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC029' and a.C38x12 = b.fbh and isnull(b.fdsfbh,'')<>''

--获取手术数据
	update a set a.C35x13C = b.fopcode,a.C36x13N=b.FOP,a.C37x13 = convert(varchar(20),b.fopdate,120),a.C38x13 = b.fssjbbh,a.C39x13 = b.fdocname,a.C40x13 = b.fopdoct1,
	a.C41x13 = b.fopdoct2,a.C42x13C = 
(case when (select id from YY_QKYHDJ c where c.qkdj=b.fqiekoubh and c.yhlb=b.fyuhebh)>0 then (select id from YY_QKYHDJ c where c.qkdj=b.fqiekoubh and c.yhlb=b.fyuhebh)else 0 end)
,a.C43x13C = b.fmazuibh,a.C44x13 = b.fmzdoct from #Tupdata_hqms a,toperation
 b where b.fpx = 14 and a.P3 = b.fprn and a.P2 = b.ftimes

  --更新手术代码名称
   update a set a.C35x13C = b.fupopcode,a.C36x13N = b.fupopname  from #Tupdata_hqms a,tupicd9set b where b.fflag = '0' 
	and b.fopcode = a.C35x13C 

	--麻醉方式1
	update a set a.C43x13C =
 b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC013' and a.C43x13C = b.fbh 
	--手术级别1
    update a set a.C38x13 = b.fdsfbh  from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC029' and a.C38x13 = b.fbh and isnull(b.fdsfbh,'')<>''




--获取手术数据 14
	update a set a.C35x14C = b.fopcode,a.C36x14N=b.FOP,a.C37x14 = convert(varchar(20),b.fopdate,120),a.C38x14 = b.fssjbbh,a.C39x14 = b.fdocname,a.C40x14 = b.fopdoct1,
	a.C41x14 = b.fopdoct2,a.C42x14C = 
(case when (select id from YY_QKYHDJ c where c.qkdj=b.fqiekoubh and c.yhlb=b.fyuhebh)>0 then (select id from YY_QKYHDJ c where c.qkdj=b.fqiekoubh and c.yhlb=b.fyuhebh)else 0 end)
,a.C43x14C = b.fmazuibh,a.C44x14 = b.fmzdoct from #Tupdata_hqms a,toperation
 b where b.fpx = 15 and a.P3 = b.fprn and a.P2 = b.ftimes

  --更新手术代码名称
   update a set a.C35x14C = b.fupopcode,a.C36x14N = b.fupopname  from #Tupdata_hqms a,tupicd9set b where b.fflag = '0'
	and b.fopcode = a.C35x14C 

	--麻醉方式1
	update a set a.C43x14C = 
b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC013' and a.C43x14C = b.fbh 
	--手术级别1
    update a set a.C38x14 = b.fdsfbh  from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC029' and a.C38x14 = b.fbh and isnull(b.fdsfbh,'')<>''

--获取手术数据 15
	update a set a.C35x15C = b.fopcode,a.C36x15N=b.FOP,a.C37x15 = convert(varchar(20),b.fopdate,120),a.C38x15 = b.fssjbbh,a.C39x15 = b.fdocname,a.C40x15 = b.fopdoct1,
	a.C41x15 = b.fopdoct2,a.C42x15C = 
(case when (select id from YY_QKYHDJ c where c.qkdj=b.fqiekoubh and c.yhlb=b.fyuhebh)>0 then (select id from YY_QKYHDJ c where c.qkdj=b.fqiekoubh and c.yhlb=b.fyuhebh)else 0 end)
,a.C43x15C = b.fmazuibh,a.C44x15 = b.fmzdoct from #Tupdata_hqms a,toperation
 b where b.fpx = 16 and a.P3 = b.fprn and a.P2 = b.ftimes

  --更新手术代码名称
   update a set a.C35x15C = b.fupopcode,a.C36x15N = b.fupopname  from #Tupdata_hqms a,tupicd9set b where b.fflag = '0' 
	and b.fopcode = a.C35x15C 

	--麻醉方式1
	update a set a.C43x15C =
 b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC013' and a.C43x15C = b.fbh 
	--手术级别1
    update a set a.C38x15 = b.fdsfbh  from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC029' and a.C38x15 = b.fbh and isnull(b.fdsfbh,'')<>''


--获取手术数据 16
	update a set a.C35x16C = b.fopcode,a.C36x16N=b.FOP,a.C37x16 = convert(varchar(20),b.fopdate,120),a.C38x16 = b.fssjbbh,a.C39x16 = b.fdocname,a.C40x16 = b.fopdoct1,
	a.C41x16 = b.fopdoct2,a.C42x16C = 
(case when (select id from YY_QKYHDJ c where c.qkdj=b.fqiekoubh and c.yhlb=b.fyuhebh)>0 then (select id from YY_QKYHDJ c where c.qkdj=b.fqiekoubh and c.yhlb=b.fyuhebh)else 0 end)
,a.C43x16C = b.fmazuibh,a.C44x16 = b.fmzdoct from #Tupdata_hqms a,toperation
 b where b.fpx = 17 and a.P3 = b.fprn and a.P2 = b.ftimes

  --更新手术代码名称
   update a set a.C35x16C = b.fupopcode,a.C36x16N = b.fupopname  from #Tupdata_hqms a,tupicd9set b where b.fflag = '0'
	and b.fopcode = a.C35x16C 

	--麻醉方式1
	update a set a.C43x16C = 
b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC013' and a.C43x16C = b.fbh 
	--手术级别1
    update a set a.C38x16 = b.fdsfbh  from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC029' and a.C38x16 = b.fbh and isnull(b.fdsfbh,'')<>''


	-- baby fage
	--update #Tupdata_hqms set P66 = 0 where P66 is null  --QGY20190916

	--fbabynum = 1
	update a set a.P681 = (case when  b.ftz is null then a.p681 else  b.ftz end) from #Tupdata_hqms a,tbabycard b where a.P3 = b.fprn and a.P2 = b.ftimes and 
b.fbabynum = 1
	--fbabynum = 2
	update a set a.P682 = (case when  b.ftz is null then a.p682 else  b.ftz end) from #Tupdata_hqms a,tbabycard b where a.P3 = b.fprn and a.P2 = b.ftimes and b.fbabynum = 2
	--fbabynum = 3
	update a set a.P683 =(case when  b.ftz is null then a.p683 else  b.ftz end)  from #Tupdata_hqms a,tbabycard b where a.P3 = b.fprn and a.P2 = b.ftimes and b.fbabynum = 3
	--fbabynum = 4
	update a set a.P684 =(case when  b.ftz is null then a.p684 else  b.ftz end)   from #Tupdata_hqms a,tbabycard b where a.P3 = b.fprn and a.P2 = b.ftimes and b.fbabynum = 4
	--fbabynum = 5
	update a set a.P685 =(case when  b.ftz is null then a.p685 else  b.ftz end)  from #Tupdata_hqms a,tbabycard b where a.P3 = b.fprn and a.P2 = b.ftimes and b.fbabynum = 5

	--医疗付款方式
	--update a set a.P1 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC032' and a.P1 = b.fbh and isnull(b.fdsfbh,'')<>''
	--医疗付费方式更新处理
	 update a set a.P1  =b.fdsfbh from #Tupdata_hqms a,thisdictdsf b WHERE   b.fzdbh = 'HQMSRC032'
 and RIGHT(a.P1,1)  = b.fbh and isnull(b.fdsfbh,'')<>''
	
	--性别
	update a set a.P5 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC001' and a.P5 = b.fbh and isnull(b.fdsfbh,'')<>''
	--婚姻状况
	update a set a.P8 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC002' and a.P8 = b.fbh and isnull(b.fdsfbh,'')<>''
	--职业
	update a set a.P9 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC003' and a.P9 = b.fbh and isnull(b.fdsfbh,'')<>''
	--关系
	update a set a.p19 = b.fbh from #Tupdata_hqms a,tstandardmx b  where a.p19 = b.fmc and b.fcode = 'GBRELATION'
	update a set a.P19 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC033' and a.P19 = b.fbh and isnull(b.fdsfbh,'')<>''
	--入院途径
	update a set a.P804 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC026' and a.P804 = b.fbh and isnull(b.fdsfbh,'')<>''
	--入院科别
	update a set a.P23 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC023' and a.P23 = b.fbh and isnull(b.fdsfbh,'')<>''
	--转科科别
	update a set a.P24 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC023' and a.P24 = b.fbh and isnull(b.fdsfbh,'')<>''
	--出院科别
	update a set a.P26 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC023' and a.P26 = b.fbh and isnull(b.fdsfbh,'')<>''
	--ADD BY QGY 历史数据中门诊诊断为空
	update a set a.P28=MZZD from #Tupdata_hqms a,MZZDDM_TEMP_HQMS b where a.P3=b.ZYHM and isnull(P28,'')=''
	--门急诊诊断编码 门急诊诊断描述


	set @execSql = 'update a set a.P28
 = b.fupicdm ,a.P281 = b.fupjbname from #Tupdata_hqms a,tupicd10set b where b.fflag = ''0'' 
	and b.ficdm = a.P28 and isnull(b.fupicdm,'''')<>'''''-- and b.ftype = '''+@icdver+''' '
	exec(@execSql)
	--门急诊诊断描述
	--入院时情况
	update a set a.P29 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC004' and a.P29 = b.fbh and isnull(b.fdsfbh,'')<>''
	--入院诊断编码

	set @execSql = 'update a set a.P30 = b.fupicdm, a.P301 = b.fupjbname  from #Tupdata_hqms a,tupicd10set b where b.fflag = ''0'' 
	and b.ficdm
 = a.P30 and isnull(b.fupicdm,'''')<>'''''-- and b.ftype = '''+@icdver+''' '
	
	exec(@execSql)
	
	--主要诊断编码
	--处理住院主要诊断为空重新关联CISDB数据

	SELECT * INTO #C03C_temp from (select a.p3,c.* FROM #Tupdata_hqms  a LEFT JOIN [172.20.0.41\ZY].CISDB.dbo.EMR_BRSYK b  
	

	 ON a.P3=b.BAHM  collate Chinese_PRC_CI_AS
	LEFT JOIN [172.20.0.41\ZY].CISDB.dbo.EMR_BASY_ZDK c ON b.SYXH=c.syxh where isnull(a.p321,'')=''  ) aa 

   UPDATE a SET a.P321=b.BZDM,P805=b.RYBQ FROM #Tupdata_hqms a,#C03C_temp b where a.p3=b.p3 collate Chinese_PRC_CI_AS
	
	set @execSql = 'update a set a.P321 = b.fupicdm,a.P322 = b.fupjbname from #Tupdata_hqms a,tupicd10set b where b.fflag = ''0'' 
	and b.ficdm = a.P321 and isnull(b.fupicdm,'''')<>'''''-- and b.ftype = '''+@icdver+''' '
	exec(@execSql)


	--主要诊断入院病情
	update a set a.P805 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC027' and a.P805 = b.fbh and isnull(b.fdsfbh,'')<>''
	--主要诊断出院情况
	update a set a.P323 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC005' and a.P323 = b.fbh and isnull(b.fdsfbh,'')<>''
	--其他诊断编码1
	set @execSql = 'update a set a.P324 = b.fupicdm,a.P325 = b.fupjbname from #Tupdata_hqms a,tupicd10set b where b.fflag = ''0'' 
	and b.ficdm = a.P324 and isnull(b.fupicdm,'''')<>'''''-- and b.ftype = '''+@icdver+''' '
	exec(@execSql)
	--其他诊断疾病描述1
	--set @execSql = 'update a set a.P325 = b.fupjbname from #Tupdata_hqms a,tupicd10set b where b.fflag = ''0'' 
	--and b.ficdm = a.P324 and isnull(b.fupjbname,'''')<>''''' --and b.ftype = '''+@icdver+''''

	--exec(@execSql)
	--其他诊断入院病情1
	update a set a.P806 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC027' and a.P806 = b.fbh and isnull(b.fdsfbh,'')<>''
	--其他诊断出院情况1
	update a set a.P326 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC005' and a.P326 = b.fbh and isnull(b.fdsfbh,'')<>''
	--其他诊断编码2
	set @execSql = 'update a set a.P327 = b.fupicdm,a.P328 = b.fupjbname from #Tupdata_hqms a,tupicd10set b where b.fflag = ''0'' 
	and a.P327 = b.ficdm and isnull(b.fupicdm
,'''')<>'''''-- and b.ftype = '''+@icdver+''' '
	exec(@execSql)
	--其他诊断疾病描述2
	--set @execSql = 'update a set a.P328 = b.fupjbname from #Tupdata_hqms a,tupicd10set b where b.fflag = ''0'' 
	--and a.P327 = b.ficdm and isnull(b.fupjbname,'''')<>'''''-- and b.ftype = '''+@icdver+''''
	--exec(@execSql)
	--其他诊断入院病情2
	update a set a.P807 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC027' and a.P807 = b.fbh and isnull(b.fdsfbh,'')<>''
	--其他诊断出院情况2
	update a set a.P329 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC005' and a.P329 = b.fbh and isnull(b.fdsfbh,'')<>''
	--其他诊断编码3
	set @execSql = 'update a set a.P3291 = b.fupicdm,a.P3292 = b.fupjbname  from #Tupdata_hqms a,tupicd10set b where b.fflag = ''0'' 
	and b.ficdm =
 a.P3291 and isnull(b.fupicdm,'''')<>'''''-- and b.ftype = '''+@icdver+''' '
	exec(@execSql)
	--其他诊断疾病描述3
	--set @execSql = 'update a set a.P3292 = b.fupjbname from #Tupdata_hqms a,tupicd10set b where b.fflag = ''0'' 
	--and b.fjbname = a.P281 and isnull(b.fupjbname,'''')<>'''' and b.ftype = '''+@icdver+''''
	--exec(@execSql)
	--其他诊断入院病情3
	update a set a.P808 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC027' and a.P808 = b.fbh and isnull(b.fdsfbh,'')<>''
	--其他诊断出院情况3
	update a set 
a.P3293 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC005' and a.P3293 = b.fbh and isnull(b.fdsfbh,'')<>''
	--其他诊断编码4
	set @execSql = 'update a set a.P3294 = b.fupicdm,a.P3295 = b.fupjbname from #Tupdata_hqms a,tupicd10set b where b
.fflag = ''0'' 
	and b.ficdm = a.P3294 and isnull(b.fupicdm,'''')<>'''''-- and b.ftype = '''+@icdver+''' '
	exec(@execSql)
	--其他诊断疾病描述4
	--set @execSql = 'update a set a.P3295 = b.fupjbname from #Tupdata_hqms a,tupicd10set b where b.fflag = ''0'' 
	--and b.fjbname = a.P281 and isnull(b.fupjbname,'''')<>'''' and b.ftype = '''+@icdver+''''
	--exec(@execSql)
	--其他诊断入院病情4
	update a set a.P809 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC027' and a.P809 = b.fbh and isnull(b.fdsfbh,'')<>
''
	--其他诊断出院情况4
	update a set a.P3296 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC005' and a.P3296 = b.fbh and isnull(b.fdsfbh,'')<>''
	--其他诊断编码5
	set @execSql = 'update a set a.P3297 = b.fupicdm,a.P3298 = b.fupjbname from #Tupdata_hqms a,tupicd10set b where b.fflag = ''0'' 
	and b.ficdm = a.P3297 and isnull(b.fupicdm,'''')<>'''''-- and b.ftype = '''+@icdver+''' '
	exec(@execSql)
	--其他诊断疾病描述5
	--set @execSql = 'update a set a.P3298 = b.fupjbname from #Tupdata_hqms a,tupicd10set b where b.fflag = ''0'' 
	--and b.fjbname = a.P281 and isnull(b.fupjbname,'''')<>'''' and b.ftype = '''+@icdver+''''
	--exec(@execSql)
	--其他诊断入院病情5
	update a set a.P810 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC027' and a.P810 = b.fbh and isnull(b.fdsfbh,'')<>''
	--其他诊断出院情况5
	update a set a.P3299 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC005' and a.P3299 = b.fbh and isnull(b.fdsfbh,'')<>''
	--其他诊断编码6
	set @execSql = 'update a set a.P3281 = b.fupicdm,a.P3282 = b.fupjbname from #Tupdata_hqms a,tupicd10set b where b.fflag = ''0'' 
	and b.ficdm = a.P3281 and isnull(b.fupicdm,'''')<>'''''-- and b.ftype = '''+@icdver+''' '
	exec(@execSql)
	--其他诊断疾病描述6
	--set @execSql = 'update a set a.P3282 = b.fupjbname from #Tupdata_hqms a,tupicd10set b where b.fflag = ''0'' 
	--and b.fjbname = a.P281 and isnull(b.fupjbname,'''')<>'''' and b.ftype = '''+@icdver+''''
	--exec(@execSql)
	--其他诊断入院病情6
	update a set a.P811 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC027' and a.P811 = b.fbh and isnull(b.fdsfbh,'')<>''
	--其他诊断出院情况6
	update a set a.P3283 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC005' and a.P3283 = b.fbh and isnull(b.fdsfbh,'')<>''
	--其他诊断编码7
	set @execSql = 'update a set a.P3284 = b.fupicdm,a.P3285 = b.fupjbname from #Tupdata_hqms a,tupicd10set b where b.fflag = ''0'' 
	and b.ficdm = a.P3284 and isnull(b.fupicdm,'''')<>'''''-- and b.ftype = '''+@icdver+''' '
	exec(@execSql)
	--其他诊断疾病描述7
	--set @execSql = 'update a set a.P3285 = b.fupjbname from #Tupdata_hqms a,tupicd10set b where b.fflag = ''0'' 
	--and b.fjbname = a.P281 and isnull(b.fupjbname,'''')<>'''' and b.ftype = '''+@icdver+''''
	--exec(@execSql)
	--其他诊断入院病情7
	update a set a.P812 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC027' and a.P812 = b.fbh and isnull(b.fdsfbh,'')<>''
	--其他诊断出院情况7
	update a set a.P3286 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC005' and a.P3286 = b.fbh and isnull(b.fdsfbh,'')<>''
	--其他诊断编码8
	set @execSql = 'update a set a.P3287 = b.fupicdm,a.P3288 = b.fupjbname from #Tupdata_hqms a,tupicd10set b where b.fflag = ''0'' 
	and b.ficdm = a.P3287 and isnull(b.fupicdm,'''')<>'''''-- and b.ftype = '''+@icdver+''' '
	exec(@execSql)
	--其他诊断疾病描述8

	--set @execSql = 'update a set a.P3288 = b.fupjbname from #Tupdata_hqms a,tupicd10set b where b.fflag = ''0'' 
	--and b.fjbname = a.P281 and isnull(b.fupjbname,'''')<>'''' and b.ftype = '''+@icdver+''''
	--exec(@execSql)
	--其他诊断入院病情8
	update a set a.P813 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC027' and a.P813 = b.fbh and isnull(b.fdsfbh,'')<>''
	--其他诊断出院情况8
	update a set a.P3289 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC005' and a.P3289  = b.fbh and isnull(b.fdsfbh,'')<>''
	--其他诊断编码9
	set @execSql = 'update a set a.P3271 = b.fupicdm,a.P3272 = b.fupjbname  from #Tupdata_hqms a,tupicd10set b where b.fflag = ''0'' 
	and b.ficdm = a.P3271 and isnull(b.fupicdm,'''')<>'''''-- and b.ftype = '''+@icdver+''' '
	exec(@execSql)
	--其他诊断疾病描述9
	--set @execSql = 'update a set a.P3272 = b.fupjbname from #Tupdata_hqms a,tupicd10set b where b.fflag = ''0'' 
	--and b.fjbname = a.P281 and isnull(b.fupjbname,'''')<>'''' and b.ftype = '''+@icdver+''''
	--exec(@execSql)

	--其他诊断入院病情9
	update a set a.P814 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC027' and a.P814 = b.fbh and isnull(b.fdsfbh,'')<>''
	--其他诊断出院情况9
	update a set a.P3273 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC005' and a.P3273 = b.fbh and isnull(b.fdsfbh,'')<>''
	--其他诊断编码10
	set @execSql = 'update a set a.P3274 = b.fupicdm,a.P3275 = b.fupjbname from #Tupdata_hqms a,tupicd10set b where b.fflag = ''0'' 
	and b.ficdm = a.P3274 and isnull(b.fupicdm,'''')<>'''''
-- and b.ftype = '''+@icdver+''' '
	exec(@execSql)
	--其他诊断疾病描述10
	--set @execSql = 'update a set a.P3275 = b.fupjbname from #Tupdata_hqms a,tupicd10set b where b.fflag = ''0'' 
	--and b.fjbname = a.P281 and isnull(b.fupjbname,'''')<>'''' and b.ftype = '''+@icdver+''''
	--exec(@execSql)
	--其他诊断入院病情10
	update a set a.P815 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC027' and a.P815 = b.fbh and isnull(b.fdsfbh,'')<>''
	--其他诊断出院情况10
	update a set a.P3276 = b.fdsfbh from #Tupdata_hqms a
,thisdictdsf b where b.fzdbh = 'HQMSRC005' and a.P3276 = b.fbh and isnull(b.fdsfbh,'')<>''
	--病理诊断编码1 
	set @execSql = 'update a set a.P351 = b.fupicdm,a.P352 = b.fupjbname from #Tupdata_hqms a,tupicd10set b 
	where b.ficdm = a.P351 '-- and b.ftype = '''+@icdver+''' '


	exec(@execSql)
	
	--病理诊断名称1
	--set @execSql = 'update a set a.P352 = b.fupjbname from #Tupdata_hqms a,tupicd10set b where b.fflag = ''0'' 
	--and b.fjbname = a.P281 and isnull(b.fupjbname,'''')<>'''' and b.ftype = '''+@icdver+''''
	--exec(@execSql)
	--病理诊断编码2
	set @execSql = 'update a set a.P353 = b.fupicdm,a.P354 = b.fupjbname from #Tupdata_hqms a,tupicd10set b where b.fflag = ''0'' 
	and b.ficdm = a.P28 and isnull(b.fupicdm,'''')<>'''' '--and b.ftype = '''+@icdver+''' '
	exec(@execSql)

	--病理诊断名称2 
	set @execSql = 'update a set a.P354 = b.fupjbname from #Tupdata_hqms a,tupicd10set b where b.fflag = ''0'' 
	and b.fjbname = a.P281 and isnull(b.fupjbname,'''')<>'''''-- and b.ftype = '''+@icdver+''''
	exec(@execSql)
	--病理诊断编码3
	set @execSql = 'update a set a.P355 = b.fupicdm from #Tupdata_hqms a,tupicd10set b where b.fflag = ''0'' 
	and b.ficdm = a.P28 and isnull(b.fupicdm,'''')<>'''''-- and b.ftype = '''+@icdver+''' '
	exec(@execSql)
	--病理诊断名称3
	set @execSql = 'update a set a.P356 = b.fupjbname from #Tupdata_hqms a,tupicd10set b where b.fflag = ''0'' 
	and b.fjbname = a.P281 and isnull(b.fupjbname,'''')<>'''''-- and b.ftype = '''+@icdver+''''
	exec(@execSql)
	
	
	--损伤、中毒的外部因素编码
	set @execSql = 'update a set a.P361 = b.fupicdm, a.P362 = b.fupjbname from #Tupdata_hqms a,tupicd10set b where b.fflag = ''0'' 
	and b.ficdm = a.P361 and isnull(b.fupicdm,'''')<>'''''-- and b.ftype = '''+@icdver+''' '
	exec(@execSql)
	--损伤、中毒的外部因素名称
	--set @execSql = 'update a set a.P362 = b.fupjbname from #Tupdata_hqms a,tupicd10set b where b.fflag = ''0'' 
	--and b.fjbname = a.P281 and isnull(b.fupjbname,'''')<>'''' and b.ftype = '''+@icdver+''''
	--exec(@execSql)
	--过敏源
	update a set a.P371 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC006'
 and a.P371 = b.fbh and isnull(b.fdsfbh,'')<>''
	--HBsAg
	update a set a.P38 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC007' and a.P38 = b.fbh and isnull(b.fdsfbh,'')<>''
	--HCV-Ab
	update a set a.P39 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC007' and a.P39 = b.fbh and isnull(b.fdsfbh,'')<>''
	--HIV-Ab
	update a set a.P40 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC007' and a.P40 = b.fbh and isnull(b.fdsfbh,'')<>''
	--门诊与出院诊断符合情况
	update a set a.P411 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC008' and a.P411 = b.fbh and isnull(b.fdsfbh,'')<>''
	--入院与出院诊断符合情况
	update a set a.P412 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC008' and a.P412 = b.fbh and isnull(b.fdsfbh,'')<>''
	--术前与术后诊断符合情况
	update a set a.P413 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC008' and a.P413 = b.fbh and isnull(b.fdsfbh,'')<>''
	--临床与病理诊断符合情况
	update a set a.P414 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC008' and a.P414 = b.fbh and isnull(b.fdsfbh,'')<>''
	--放射与病理诊断符合情况
	update a set a.P415 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC008' and a.P415 = b.fbh and isnull(b.fdsfbh,'')<>''
	--最高诊断依据
	update a set a.P687 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC009' and a.P687 = b.fbh and isnull(b.fdsfbh,'')<>''
	--分化程度
	update a set a.P688 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC010' and a.P688 = b.fbh and isnull(b.fdsfbh,'')<>''
	--病案质量
	update a set a.P44 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC011' and a.P44 = b.fbh and isnull(b.fdsfbh,'')<>''
	--手术操作编码1
	set @execSql = 'update a set a.P490 = b.fupopcode,a.P492 = b.fupopname from #Tupdata_hqms a,tupicd9set b where b.fflag = ''0'' 
	and b.fopcode = a.P490 and isnull(b.fupopcode,'''')<>'''''-- and b.ftype = '''+@opver+''' '
	exec(@execSql)
	update #Tupdata_hqms set p490='-',p492='-',P491='-' where isnull(p490,'')=''   --P490 'C14x01C',P492 'C15x01N',P491 'C16x01'
	
	--手术级别1
	update a set a.P820 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC029' and a.P820 = b.fbh and isnull(b.fdsfbh,'')<>''
	--麻醉方式1
	update a set a.P498 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC013' and a.P498 = b.fbh 
	--切口愈合等级1
	--update a set a.P499 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC014' and a.P499 = b.fbh and isnull(b.fdsfbh,'')<>''
	--手术操作编码2

	set @execSql = 'update a set a.P4911 = b.fupopcode,a.P4913 = b.fupopname from #Tupdata_hqms a,tupicd9set b where b.fflag = ''0'' 
	and b.fopcode = a.P4911 and isnull(b.fupopcode,'''')<>'''''-- and b.ftype = '''+@opver+''' '
	exec(@execSql)
	--手术操作名称2
	--
set @execSql = 'update a set a.P4913 = b.fupopname from #Tupdata_hqms a,tupicd9set b where b.fflag = ''0'' 
	--and b.fopname = a.P492 and isnull(b.fupopname,'''')<>'''' and b.ftype = '''+@opver+''' '
	--exec(@execSql)
	--手术级别2
	update a set a.P821 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC029' and a.P821 = b.fbh and isnull(b.fdsfbh,'')<>''
	--手术操作部位2
	update a set a.P4914 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC012' and a.P4914 = b.fbh and isnull(b.fdsfbh,'')<>''
	--麻醉方式2
	update a set a.P4919 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC013' and a.P4919 = b.fbh and isnull(b.fdsfbh,'')<>''
	--切口愈合等级2
	--update a set a.P4920 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC014' and a.P4920 = b.fbh and isnull(b.fdsfbh,'')<>''
	--手术操作编码3
	set @execSql = 'update a set a.P4922 = b.fupopcode,a.P4924 = b.fupopname from #Tupdata_hqms a,tupicd9set b where b.fflag = ''0'' 
	and b.fopcode = a.P4922 and isnull(b.fupopcode,'''')<>'''''-- and b.ftype = '''+@opver+''' '
	exec(@execSql)
	--手术操作名称3
	--set @execSql = 'update a set a.P4924 = b.fupopname from #Tupdata_hqms a,tupicd9set b where b.fflag = ''0'' 
	--and b.fopname = a.P492 and isnull(b.fupopname,'''')<>'''' and b.ftype = '''+@opver+''' '
	--exec(@execSql)
	--手术级别3
	update a set a.P822 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC029' and a.P822 = b.fbh and isnull(b.fdsfbh,'')<>''
	--手术操作部位3
	update a set a.P4925 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC012' and a.P4925 = b.fbh and isnull(b.fdsfbh,'')<>''
	--麻醉方式3
	update a set a.P4530 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC013' and a.P4530 = b.fbh and isnull(b.fdsfbh,'')<>''
	--切口愈合等级3
	--update a set a.P4531 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC014' and a.P4531 = b.fbh and isnull(b.fdsfbh,'')<>''
	--手术操作编码4
	set @execSql = 'update a set a.P4533 = b.fupopcode,a.P4535 = b.fupopname from #Tupdata_hqms a,tupicd9set b where b.fflag = ''0'' 
	and b.fopcode = a.P4533 and isnull(b.fupopcode,'''')<>'''''-- and b.ftype = '''+@opver+''' '
	exec(@execSql)
	--手术操作名称4
	--set @execSql = 'update a set a.P4535 = b.fupopname from #Tupdata_hqms a,tupicd9set b where b.fflag = ''0'' 
	--and b.fopname = a.P492 and isnull(b.fupopname,'''')<>'''' and b.ftype = '''+@opver+''' '
	--exec(@execSql)
	--手术级别4
	update a set a.P823 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC029' and a.P823 = b.fbh and isnull(b.fdsfbh,'')<>''
	--手术操作部位4
	update a set a.P4535 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC012' and a.P4535 = b.fbh and isnull(b.fdsfbh,'')<>''
	--麻醉方式4
	update a set a.P4541 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC013' and a.P4541 = b.fbh and isnull(b.fdsfbh,'')<>''
	--切口愈合等级4
	--update a set a.P4542 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC014' and a.P4542 = b.fbh and isnull(b.fdsfbh,'')<>''
	--手术操作编码5
	set @execSql =
 'update a set a.P4544 = b.fupopcode,a.P4546 = b.fupopname from #Tupdata_hqms a,tupicd9set b where b.fflag = ''0'' 
	and b.fopcode = a.P4544 and isnull(b.fupopcode,'''')<>''''' --and b.ftype = '''+@opver+''' '
	exec(@execSql)
	--手术操作名称5
	--set @execSql = 'update a set a.P4546 = b.fupopname from #Tupdata_hqms a,tupicd9set b where b.fflag = ''0'' 
	--and b.fopname = a.P492 and isnull(b.fupopname,'''')<>'''' and b.ftype = '''+@opver+''' '
	--exec(@execSql)
	--手术级别5
	update a set a.P824 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC029' and a.P824 = b.fbh and isnull(b.fdsfbh,'')<>''
	--手术操作部位5
	update a set a.P4547 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC012' and a.P4547 = b.fbh and isnull(b.fdsfbh,'')<>''
	
--麻醉方式5
	update a set a.P4552 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC013' and a.P4552 = b.fbh and isnull(b.fdsfbh,'')<>''
	----切口愈合等级5
	--update a set a.P4553 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC014' and a.P4553 = b.fbh and isnull(b.fdsfbh,'')<>''
	--手术操作编码6
	set @execSql = 'update a set a.P45002 = b.fupopcode ,a.p45004 = b.fupopname from #Tupdata_hqms a,tupicd9set b where b.fflag = ''0'' 
	and b.fopcode = a.P45002 and isnull(b.fupopcode,'''')
<>'''''-- and b.ftype = '''+@opver+''' '
	exec(@execSql)
	--手术操作名称6
	--set @execSql = 'update a set a.p45004 = b.fupopname from #Tupdata_hqms a,tupicd9set b where b.fflag = ''0'' 
	--and b.fopname = a.P492 and isnull(b.fupopname,'''')<>'''' and b.ftype = '''+@opver+''' '
	--exec(@execSql)
	--手术级别6
	update a set a.P825 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC029' and a.P825 = b.fbh and isnull(b.fdsfbh,'')<>''
	--手术操作部位6
	update a set a.p45005 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC012' and a.p45005 = b.fbh and isnull(b.fdsfbh,'')<>''
	--麻醉方式6
	update a set a.p45010 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC013' and a.p45010 = b.fbh and isnull(b.fdsfbh,'')<>''
	----切口愈合等级6

	--update a set a.p45012 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC014' and a.p45012 = b.fbh and isnull(b.fdsfbh,'')<>''
	--手术操作编码7
	set @execSql = 'update a set a.p45014 = b.fupopcode,a.p45016 = b.fupopname from #Tupdata_hqms a,tupicd9set b where b.fflag = ''0'' 
	and b.fopcode = a.p45014 and isnull(b.fupopcode,'''')<>'''''-- and b.ftype = '''+@opver+''' '
	exec(@execSql)
	--手术操作名称7
	--set @execSql = 'update a set a.p45016 = b.fupopname from #Tupdata_hqms a,tupicd9set b where b.fflag = ''0'' 
	--and b.fopname = a.P492 and isnull(b.fupopname,'''')<>'''' and b.ftype = '''+@opver+''' '
	--exec(@execSql)
	--手术级别7
	update a set a.P826 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC029' and a.P826 = b.fbh and isnull(b.fdsfbh,'')<>''
	--手术操作部位7
	update a set a.p45017 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC012' and a.p45017 = b.fbh and isnull(b.fdsfbh,'')<>''
	--麻醉方式7
	update a set a.p45022 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf
 b where b.fzdbh = 'HQMSRC013' and a.p45022 = b.fbh and isnull(b.fdsfbh,'')<>''
	----切口愈合等级7
	--update a set a.p45024 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC014' and a.p45024 = b.fbh and isnull(b.fdsfbh,'')<>''
	--手术操作编码8
	set @execSql = 'update a set a.p45026 = b.fupopcode,a.p45028 = b.fupopname from #Tupdata_hqms a,tupicd9set b where b.fflag = ''0'' 
	and b.fopcode = a.p45026 and isnull(b.fupopcode,'''')<>'''''-- and b.ftype = '''+@opver+''' '
	exec(@execSql)
	--手术操作名称8
	--
set @execSql = 'update a set a.p45028 = b.fupopname from #Tupdata_hqms a,tupicd9set b where b.fflag = ''0'' 
	--and b.fopname = a.P492 and isnull(b.fupopname,'''')<>'''' and b.ftype = '''+@opver+''' '
	--exec(@execSql)
	--手术级别8
	update a set a.P827 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC029' and a.P827 = b.fbh and isnull(b.fdsfbh,'')<>''
	--手术操作部位8
	update a set a.p45029 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC012' and a.p45029 = b.fbh and isnull(b.fdsfbh,'')<>''
	--麻醉方式8
	update a set a.p45034 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC013' and a.p45034 = b.fbh and isnull(b.fdsfbh,'')<>''
	----切口愈合等级8
	--update a set a.p45036 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC014' and a.p45036 = b.fbh and isnull(b.fdsfbh,'')<>''
	--手术操作编码9
	set @execSql = 'update a set a.p45038 = b.fupopcode,a.p45040 = b.fupopname from #Tupdata_hqms a,tupicd9set b where b.fflag = ''0'' 
	and b.fopcode = a.p45038 and isnull(b.fupopcode,'''')<>'''''-- and b.ftype = '''+@opver+''' '
	exec(@execSql)
	--手术操作名称9
	--set @execSql = 'update a set a.p45040 = b.fupopname from #Tupdata_hqms a,tupicd9set b where b.fflag = ''0'' 
	--and b.fopname = a.P492 and isnull(b.fupopname,'''')<>'''' and b.ftype = '''+@opver+''' '
	--exec(@execSql)
	--手术级别9
	update a set a.P828 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC029' and a.P828 = b.fbh and isnull(b.fdsfbh,'')<>''
	--手术操作部位9
	update a set a.p45041 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC012' and a.p45041 = b.fbh and isnull(b.fdsfbh,'')<>''
	--麻醉方式9
	update a set a.p45046 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC013' and a.p45046 = b.fbh and isnull(b.fdsfbh,'')<>''
	----切口愈合等级9
	--update a set a.p45048 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC014' and a.p45048 = b.fbh and isnull(b.fdsfbh,'')<>''
	--手术操作编码10
	set @execSql = 'update a set a.p45050 = b.fupopcode,a.p45052 = b.fupopname from #Tupdata_hqms a,tupicd9set b where b.fflag = ''0'' 
	and b.fopcode = a.p45050 and isnull(b.fupopcode,'''')<>'''''-- and b.ftype = '''+@opver+''' '
	exec(@execSql)
	--手术操作名称10
	--set @execSql = 'update a set a.p45052 = b.fupopname from #Tupdata_hqms a,tupicd9set b where b.fflag = ''0'' 
	--and b.fopname = a.P492 and isnull(b.fupopname,'''')<>'''' and b.ftype = '''+@opver+''' '
	--exec(@execSql)
	--手术级别10
	update a set a.P829 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC029' and a.P829 = b.fbh and isnull(b.fdsfbh,'')<>''
	--手术操作部位10
	update a set a.p45053 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC012' and a.p45053 = b.fbh and isnull(b.fdsfbh,'')<>''
	--麻醉方式10
	update a set a.p45058 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC013' and a.p45058 = b.fbh and isnull(b.fdsfbh,'')<>''
	----切口愈合等级10
	--update a set a.p45060 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC014' and a.p45060 = b.fbh and isnull(b.fdsfbh,'')<>''
	--手术10到16





	--死亡患者尸检
	--update a set a.P57 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC016' and a.P57 = b.fbh and isnull(b.fdsfbh,'')<>''
		update a set a.P904 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC016' and a.P57 = b.fbh and isnull(b.fdsfbh,'')<>''
	--死亡患者尸检离院方式为5的才尸检
update a set a.P904 = '-' from #Tupdata_hqms a where a.P741<>'5'


	--手术、治疗、检查、诊断为本院第一例
	update a set a.P58 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh
 = 'HQMSRC016' and a.P58 = b.fbh and isnull(b.fdsfbh,'')<>''
	--随诊
	update a set a.P60 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC017' and a.P60 = b.fbh and isnull(b.fdsfbh,'')<>''
	--示教病例
	update a set a.P59 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC016' and a.P59 = b.fbh and isnull(b.fdsfbh,'')<>''
	--ABO血型
	update a set a.P62 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC030' and a.P62 = b.fbh and isnull(b.fdsfbh,'')<>''
	--Rh血型
	update a set a.P63  = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC031' and a.P63  = b.fbh and isnull(b.fdsfbh,'')<>''
	--输血反应
	update a set a.P64  = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC018' and a.P64  = b.fbh and isnull(b.fdsfbh,'')<>''
	--是否有出院31天内再住院计划
	update a set a.P830  = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC028' and a.P830  = b.fbh and isnull(b.fdsfbh,'')<>''
	 --出院后31天内是否有诊疗需要的再住院安排

    update a set a.P830='1' 
from #Tupdata_hqms a where isnull(a.P831,'')=''
	--离院方式
	update a set a.P741  = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC019' and a.P741  = b.fbh and isnull(b.fdsfbh,'')<>''
	 --离院方式为空
  update a set a.P741='1' from #Tupdata_hqms a where isnull(a.P741,'')=''
	--民族转换
	--update a set a.P11  = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC035' and a.P11  = b.fbh and isnull(b.fdsfbh,'')<>''
	update a set a.P11  =RIGHT(rtrim(P11),1) from #Tupdata_hqms a WHERE a.P11 BETWEEN '01' AND '09'
	--处理病房数字问题映射到对应病房 qgy
	update a set a.P261  ='A栋五病房' from #Tupdata_hqms a where a.p261='0110'
	update a set a.P261  ='B栋七病房' from #Tupdata_hqms a where a.p261='0207'
	--籍贯代码
	update a set a.P902  = b.FJGSS from #Tupdata_hqms a,BASYFJ b where b.FPRN = a.p3
	update a set a.P902  = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC036' and a.P902  = b.fbh and isnull(b.fdsfbh,'')<>''
	--处理过敏药物老数据导入
		update a set a.P372  = b.gmywtotal from #Tupdata_hqms a,gmywmc_temp_hqms b where b.FPRN =a.p3
 --有无过敏药物判定第一步全部为无
 update a set a.p903   =1  from #Tupdata_hqms a
 --有无过敏药物判定第二步若存在过敏药物判定为有
 update a set a.p903   =2  from #Tupdata_hqms a where isnull(a.p372,'')<>'' and a.p372<>'-'
 --处理掉工作单位为空地址为空'——'
 update a set a.P14='-'
 from #Tupdata_hqms a where a.P14='——'  or isnull(a.p14,'')='' --or a.P14='--'
 update a set a.p15='-',P16='-'  from #Tupdata_hqms a where a.P14='—' or a.P14='无'
 update a set a.p15='-'  from #Tupdata_hqms a where a.P15='—' or a.P15='无' or isnull(a.p15,''
)=''
 update a set a.p16='-'  from #Tupdata_hqms a where a.P16='—' or a.P16='无' or isnull(a.p16,'')=''
 --fdwaddr P14,fdwtele P15,
 
 --处理存在病理号没有病理诊断（取医生站信息）
 update a set P351=c.BLZD ,P352=substring(c.BLZDMC,1,30) from #Tupdata_hqms a,[172.20.0.41\ZY].CISDB.dbo.EMR_BRSYK b,[172.20.0.41\ZY].CISDB.dbo.EMR_BASYK c
 where a.P3=b.ZYHM collate Chinese_PRC_CI_AS 
 and a.P2=b.RYCS and b.SYXH=c.SYXH   
 and isnull(P816,'')<>'' and isnull(P816,'')<>'-'
 AND isnull(P351,'')=''
 and (P321 like 'C%' or P321  like 'D0
%' or P321 like 'D10%' or P321  like 'D45%' or P321  like 'D46%' or P321 like 'D47%')
 --select p351,p352,p816 from  #Tupdata_hqms where p3='20190007267'
 -- select p351,p352,p816 from  #Tupdata_hqms where p3='20190015616'
 -- return

 --处理年龄不足一周岁(月转天)
 update a set a.P66=abs(DATEDIFF(dd,P22,P6)) from #Tupdata_hqms a where a.P66<>0
 --处理户口地址邮编为空
 update a set a.P171='-'  from #Tupdata_hqms a where isnull(a.P171,'')=''
 --处理身份为空的数据

	
update a set a.P23 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC023' and a.P23 = b.fbh and isnull(b.fdsfbh,'')<>''
update a set a.P24 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC023' and a.P24 = b.fbh and isnull(b.fdsfbh,'')<>''
update a set a.P26 = b.fdsfbh from #Tupdata_hqms a,thisdictdsf b where b.fzdbh = 'HQMSRC023' and a.P26 = b.fbh and isnull(b.fdsfbh,'')<>''
--离园方式为2，3转院时 b35为空默认为横线

update  #Tupdata_hqms set P742='-' where P741  IN(2,3) and ISNULL(P742,'')=''

----update #Tupdata_hqms set P23 = '0303' where P23 = '020803' 
----update #Tupdata_hqms set P24 = '0303' where P24 = '020803' 
----update #Tupdata_hqms set P26 = '0303' where P26 = '020803'


--更新出院科室分内外科
  --肾病中心分内外
    update a set a.P23='0404' from #Tupdata_hqms a where a.P23='0306' and isnull(P490,'')<>'-'  and P490 IS NOT NULL 
    update a set a.P26='0404' from #Tupdata_hqms a where a.P26='0306' and isnull(P490,'')<>'-'  and P490 IS NOT NULL--外科

	--神经中心

	 update a set a.P23='0402' from #Tupdata_hqms a where a.P23='0303' and isnull(P490,'')<>'-'  and P490 IS NOT NULL AND P820 IN (3,4) --外科
     update a set a.P26='0402' from #Tupdata_hqms a where a.P26='0303' and isnull(P490,'')<>'-'  and P490 IS NOT NULL AND P820 IN (3,4) --外科
	--消化中心
	
	 update a set a.P23='0401' from #Tupdata_hqms a where a.P23='0302'and isnull(P490,'')<>'-'  and P490 IS NOT NULL--外科
    update a set a.P26='0401' from #Tupdata_hqms a where a.P26='0302'and isnull(P490,'')<>'-'  and P490 IS NOT NULL--外科

	--呼吸中心
	  update a set a.P23='0405' from #Tupdata_hqms a where a.P23='0301' and isnull(P490,'')<>'-'  and P490 IS NOT NULL --外科
    update a set a.P26='0405' from #Tupdata_hqms a where a.P26='0301' and isnull(P490,'')<>'-'  and P490 IS NOT NULL --外科
	
	
	--年龄不足一周岁患者根据A16数据去更新A14数据为0
	update #Tupdata_hqms SET P7=0 WHERE isnull(P66,'')<>'' and isnull(P66,'')<>'-'

	--当出生日期跟入院日期相隔365天时改为364天
update #Tupdata_hqms set P7=0,P66=DATEDIFF(DD,convert(datetime,p6)+1,convert(datetime,p22)) where DATEDIFF(DD,convert(datetime,p6)+1,convert(datetime,p22))<365 and DATEDIFF(DD,convert(datetime,p6),convert(datetime,p22))=365

	
	    select 
		P900 'A01',P6891 'A02',P3 'A48',P2 'A49',P22 'B12',P25 'B15',P800 'A47',P1 'A46C',P4 'A11',P5 'A12C',P6 'A13',P7 'A14',
		P12 'A15C',P8 'A21C',P9 'A38C',P11 'A19C',P13 'A20',P901 'A22',P902 'A23C',
		replace(replace(P17,char(10),''),char(13),'') 'A24',
		
		P171 'A25C',
		
		replace(replace(P801,char(10),''),char(13),'') 'A26',
		
		P802 'A27',
		P803 'A28C',
		replace(replace(isnull(P14,'-'),char(10),''),char(13),'') 'A29',
		
		isnull(P15,'') 'A30',isnull(P16,'') 'A31C',P18 'A32',P19 'A33C',replace(replace(P20,char(10),''),char(13),'') 'A34',P21 'A35',P804 'B11C',P23 'B13C',P231 'B14',
		P24 'B21C',P26 'B16C',P261 'B17',P27 'B20',P28 'C01C',P281 'C02N',
		--主要诊断
		P321 'C03C',P322 'C04N',P805 'C05C',
		--其他诊断
		P324 'C06x01C',P325 'C07x01N',P806 'C08x01C',P327 'C06x02C',P328 'C07x02N',P807 'C08x02C',P3291 'C06x03C',P3292 'C07x03N',P808 'C08x03C',
		P3294 'C06x04C',P3295 'C07x04N',P809 'C08x04C',P3297 'C06x05C',P3298 'C07x05N',P810 'C08x05C',P3281 'C06x06C',P3282 'C07x06N',
		P811 'C08x06C',P3284 'C06x07C',P3285 'C07x07N',P812 'C08x07C',P3287 'C06x08C',P3288 'C07x08N',P813 'C08x08C',P3271 'C06x09C',
		P3272 'C07x09N',P814 'C08x09C',P3274 'C06x10C',P3275 'C07x10N',P815 'C08x10C',
		 C06x11C,C07x11N ,  C08x11C,C06x12C ,C07x12N , C08x12C,C06x13C,  C07x13N,C08x13C ,C06x14C, C07x14N, C08x14C , C06x15C ,C07x15N,C08x15C ,C06x16C,C07x16N  ,C08x16C,C06x17C , C07x17N , C08x17C 
        ,C06x18C ,C07x18N ,C08x18C ,C06x19C , C07x19N ,C08x19C ,C06x20C ,C07x20N ,C08x20C ,C06x21C , C07x21N, C08x21C ,C06x22C ,C07x22N ,C08x22C ,C06x23C ,C07x23N ,C08x23C ,C06x24C ,C07x24N ,C08x24C 
       ,C06x25C ,C07x25N ,C08x25C ,C06x26C , C07x26N ,C08x26C ,C06x27C ,C07x27N ,C08x27C ,C06x28C , C07x28N , C08x28C , C06x29C, C07x29N ,C08x29C,C06x30C ,C07x30N ,C08x30C ,C06x31C ,C07x31N , C08x31C 
      , C06x32C ,C07x32N ,C08x32C , C06x33C , C07x33N, C08x33C , C06x34C , C07x34N ,C08x34C , C06x35C , C07x35N , C08x35C , C06x36C ,C07x36N, C08x36C ,C06x37C ,C07x37N , C08x37C , C06x38C ,C07x38N ,C08x38C 
       , C06x39C , C07x39N , C08x39C , C06x40C , C07x40N , C08x40C, 
		--end其他诊断
		P351 'C09C',P352 'C10N',P816 'C11',P361 'C12C',
		P362 'C13N',P903 'C24C',P372 'C25',P431 'B22',P432 'B23',P433 'B24',P434 'B25',P819 'B26',P435 'B27',P437 'B28',P438 'B29',
		P44 'B30C',P45 'B31',P46 'B32',P47 'B33',P904 C34C,P905 C26C,P906 C27C,
		--主要手术
		P490 'C14x01C',P492 'C15x01N',P491 'C16x01',P820 'C17x01',P495 'C18x01',P496 'C19x01',P497 'C20x01',P499 'C21x01C',P498 'C22x01C',P4910 'C23x01',

		--其他手术
		P4911 'C35x01C',P4913 'C36x01N',P4912 'C37x01',P821 'C38x01',P4916 'C39x01',P4917 'C40x01',P4918 'C41x01',P4920 'C42x01C',P4919 'C43x01C',P4921 'C44x01',
		P4922 'C35x02C',P4924 'C36x02N',P4923 'C37x02',P822 'C38x02',P4527 'C39x02',P4528 'C40x02',P4529 'C41x02',P4531 'C42x02C',P4530 'C43x02C',P4532 'C44x02',
		P4533 'C35x03C',P4535 'C36x03N',P4534 'C37x03',P823 'C38x03',P4538 'C39x03',P4539 'C40x03',P4540 'C41x03',P4542 'C42x03C',P4541 'C43x03C',P4543 'C44x03',
		P4544 'C35x04C',P4546 'C36x04N',P4545 'C37x04',P824 'C38x04',P4549 'C39x04',P4550 'C40x04',P4551 'C41x04',P4553 'C42x04C',P4552 'C43x04C',P4554 'C44x04',
		P45002 'C35x05C',P45004 'C36x05N',P45003 'C37x05',P825 'C38x05',P45007 'C39x05',P45008 'C40x05',P45009 'C41x05',P45012 'C42x05C',P45010 'C43x05C',P45013 'C44x05',
		P45014 'C35x06C',P45016 'C36x06N',P45015 'C37x06',P826 'C38x06',P45019 'C39x06',P45020 'C40x06',P45021 'C41x06',P45024 'C42x06C',P45022 'C43x06C',P45025 'C44x06',
		P45026 'C35x07C',P45028 'C36x07N',P45027 'C37x07',P827 'C38x07',P45031 'C39x07',P45032 'C40x07',P45033 'C41x07',P45036 'C42x07C',P45034 'C43x07C',P45037 'C44x07',
		P45038 'C35x08C',P45040 'C36x08N',P45039 'C37x08',P828 'C38x08',P45043 'C39x08',P45044 'C40x08',P45045 'C41x08',P45048 'C42x08C',P45046 'C43x08C',P45049 'C44x08',
		P45050 'C35x09C',P45052 'C36x09N',P45051 'C37x09',P829 'C38x09',P45055 'C39x09',P45056 'C40x09',P45057 'C41x09',P45060 'C42x09C',P45058 'C43x09C',P45061 'C44x09',

		C35x10C,C36x10N,C37x10,C38x10,C39x10,C40x10,C41x10,C42x10C,C43x10C,C44x10,C35x11C,C36x11N,
C37x11,C38x11,C39x11,C40x11,C41x11,C42x11C,C43x11C,C44x11,
C35x12C,C36x12N,C37x12,C38x12,C39x12,C40x12,C41x12,C42x12C,C43x12C,C44x12,C35x13C,C36x13N,C37x13,C38x13,C39x13,C40x13,C41x13,C42x13C,C43x13C,C44x13,C35x14C,C36x14N,C37x14,C38x14,C39x14,
C40x14,C41x14,C42x14C,C43x14C,C44x14,C35x15C,C36x15N,C37x15,C38x15,C39x15,C40x15,C41x15,C42x15C,C43x15C,C44x15,C35x16C,C36x16N,C37x16,C38x16,C39x16,C40x16,C41x16,C42x16C,C43x16C,C44x16,
C35x17C,C36x17N,C37x17,C38x17,C39x17,C40x17,C41x17,C42x17C,C43x17C,C44x17,C35x18C,C36x18N,C37x18,C38x18,C39x18,C40x18,C41x18,C42x18C,C43x18C,C44x18,C35x19C,C36x19N,C37x19,C38x19,C39x19,C40x19,C41x19,C42x19C,C43x19C,C44x19,
C35x20C,C36x20N,C37x20,C38x20,C39x20,C40x20,C41x20,C42x20C,C43x20C,C44x20,C35x21C,C36x21N,C37x21,C38x21,C39x21,C40x21,C41x21,C42x21C,C43x21C,C44x21,C35x22C,C36x22N,C37x22,C38x22,C39x22,C40x22,C41x22,C42x22C,C43x22C,C44x22,
C35x23C,C36x23N,C37x23,C38x23,C39x23,C40x23,C41x23,C42x23C,C43x23C,C44x23,C35x24C,C36x24N,C37x24,C38x24,C39x24,C40x24,C41x24,C42x24C,C43x24C,C44x24,C35x25C,C36x25N,C37x25,C38x25,C39x25,C40x25,C41x25,C42x25C,C43x25C,C44x25,
C35x26C,C36x26N,C37x26,C38x26,C39x26,C40x26,C41x26,C42x26C,C43x26C,C44x26,C35x27C,C36x27N,C37x27,C38x27,C39x27,C40x27,C41x27,C42x27C,C43x27C,C44x27,C35x28C,C36x28N,C37x28,C38x28,C39x28,C40x28,C41x28,C42x28C,C43x28C,C44x28,
C35x29C,C36x29N,C37x29,C38x29,C39x29,C40x29,C41x29,C42x29C,C43x29C,C44x29,C35x30C,C36x30N,C37x30,C38x30,C39x30,C40x30,C41x30,C42x30C,C43x30C,C44x30,C35x31C,C36x31N,C37x31,C38x31,C39x31,C40x31,C41x31,C42x31C,C43x31C,C44x31,
C35x32C,C36x32N,C37x32,C38x32,C39x32,C40x32,C41x32,C42x32C,C43x32C,C44x32,C35x33C,C36x33N,C37x33,C38x33,C39x33,C40x33,C41x33,C42x33C,C43x33C,C44x33,C35x34C,C36x34N,C37x34,C38x34,C39x34,C40x34,C41x34,C42x34C,C43x34C,C44x34,
C35x35C,C36x35N,C37x35,C38x35,C39x35,C40x35,C41x35,C42x35C,C43x35C,C44x35,C35x36C,C36x36N,C37x36,C38x36,C39x36,C40x36,C41x36,C42x36C,C43x36C,C44x36,C35x37C,C36x37N,C37x37,C38x37,C39x37,C40x37,C41x37,C42x37C,C43x37C,C44x37,
C35x38C,C36x38N,C37x38,C38x38,C39x38,C40x38,C41x38,C42x38C,C43x38C,C44x38,C35x39C,C36x39N,C37x39,C38x39,C39x39,C40x39,C41x39,C42x39C,C43x39C,C44x39,C35x40C,C36x40N,C37x40,C38x40,C39x40,C40x40,C41x40,C42x40C,C43x40C,C44x40,

	--end 其他手术
		
		P66 'A16',
		P681 'A18x01',P682 'A18x02',P683 'A18x03',P684 'A18x04',P685 'A18x05',P67 'A17',isnull(P907,0) 'C28',isnull(P731,0) 'C29',ISNULL(P732,0) 'C30',ISNULL(P908,0) 'C31',ISNULL(P733,0) 'C32',
		ISNULL(P734,0) 'C33',
		P830 'B36C',P831 'B37',P741 'B34C',P742 'B35',P782 'D01',P751 'D09',P752 'D11',P754 'D12',P755 'D13',P756 'D14',P757 'D15',
		P758 'D16',P759 'D17',P760 'D18',P761 'D19',P762 'D19x01',P763 'D20',P764 'D20x01',P765 'D20x02',P767 'D21',P768 'D22',
		P769 'D23',P770 'D23x01',P771 'D24',P772 'D25',P773'D26',P774 'D27',P775 'D28',P776 'D29',P777 'D30',P778 'D31',P779 'D32',
		P780 'D33',P781 'D34'

		INTO #syjbk_bak
		from  #Tupdata_hqms order by p3
		--delete syjbk_bak
		--insert into syjbk_bak select * from #syjbk_bak

		--D20老病案数据取值老病案库手术麻醉费
		--select * from [172.20.0.43\lis].THIS_BAGL.dbo.HQMS_SSZLF 
		--update a set a.D20=b.sszlf from #syjbk_bak a,[172.20.0.43\lis].THIS_BAGL.dbo.HQMS_SSZLF b where a.A48=b.fprn

	   --获取老病案损伤中毒数据
		update a set a.C12C = b.sszd,a.C13N = b.sswymc from #syjbk_bak a,HQMS_LBA_SSZD b where a.A48=b.bahm
		update a set a.C12C = b.sszd,a.C13N = b.sswymc from syjbk_bak a,HQMS_LBA_SSZD b where a.A48=b.bahm
		--手术二助为空默认横线
		update a set a.C20x01 ='-' from #syjbk_bak a where isnull(C19x01,'')<>'' and isnull(C20x01,'')=''
		
		
--非新生儿患者通过年龄大于1或者天数大于28天将新生儿入院体重置为空2020-1-9
		--update a set a.A17 =null from #syjbk_bak a where a.A14>1 AND a.A17=0
		--	update a set a.A17 =null,A18x01=null from #syjbk_bak a where  a.A16>30  AND a.A17=0
		----非新生儿患者通过年龄大于1将新生儿入院体重置为空
		
		--update a set a.A18x01 =null from #syjbk_bak a where a.A12C='1' and a.A14>1
		--update a set a.A18x01 =null from #syjbk_bak a where a.A14>1 and  a.A18x01 =0
		----非新生儿患者A14>0时 A16不为空A17为空
		--update a set a.A17 =null,A16=null from #syjbk_bak a where a.A14>1 and A16 is not null
		--A19C民族为空默认横线
		
		update a set a.A19C ='-' from #syjbk_bak a where ISNULL(a.A19C,'')=''
		--A22 出生地址为空默认横线
		
		update a set a.A22 ='-' from #syjbk_bak a where ISNULL(a.A22,'')=''
		--A23C 籍贯外籍和空的默认横线
		
		update a set a.A23C ='-' from #syjbk_bak a where ISNULL(a.A23C,'')=''
		update a set a.A23C ='-' from #syjbk_bak a where a.A23C='Wj'
		UPDATE  #syjbk_bak SET A23C='-' where A23C NOT IN  (select FDSFBH from  thisdictdsf where fzdbh='HQMSRC036') AND A23C<>'-'
		--A25C户口地址邮编为空或者不详
		update a set a.A25C ='-' from #syjbk_bak a where (len(a.A25C)<4 or len(a.A25C)>6) AND a.A25C<>'-' 
		--A26现住址为空
		update a set a.A26 ='-' from #syjbk_bak a where isnull(a.A26,'')=''
		--A27现住址电话为空
		update a set a.A27 ='-' from #syjbk_bak a where isnull(a.A27,'')=''
		--A29去掉工作单位前后横线
		 update a set a.A29 ='-' from #syjbk_bak a where A29='---'
		  update a set a.A29 ='-' from #syjbk_bak a where A29='----'
		  update a set a.A29 ='-' from #syjbk_bak a where A29='--'
		 update a set a.A29 =right(A29,LEN(A29)-1) from #syjbk_bak a where LEN(A29)>2 and LEFT(A29,1)='-'
		 update a set a.A29 =LEFT(A29,LEN(A29)-1) from #syjbk_bak a where LEN(A29)>2 and RIGHT(A29,1)='-'
		  update a set a.A29 ='-' from #syjbk_bak a where isnull(A29,'')=''

		 
		--A31工作单位邮编为空或者不详汉字
	
		 update a set a.A31C ='-' from #syjbk_bak a where (len(a.A31C)<4 or len(a.A31C)>6) AND a.A31C<>'-' 
		 
		 update a set a.A31C ='-' from #syjbk_bak a  WHERE ISNUMERIC(A31C)=0
       --A33C联系人关系为空默认为9其他
	   update a set a.A33C ='-' from #syjbk_bak a where isnull(a.A33C,'')=''
	   --A35联系人电话
	   update a set a.A35 ='-' from #syjbk_bak a where isnull(a.A35,'')=''

	   --A46C医疗付费方式为空默认为9-其他
	    update a set a.A46C =9 from #syjbk_bak a where isnull(a.A46C,'')=''
		--B29编码员为空默认王唯
		update a set a.B29 ='王唯' from #syjbk_bak a where isnull(a.B29,'')=''  
		--D09自付金额老病案数据

		update a set a.D09 =b.zfje from #syjbk_bak a , HQMS_TEMP_ZFJE b where a.A48=b.blh and b.zfje>'0'
		--自付金额大于总费用时
		update a set a.D09 ='0.00' from #syjbk_bak a where D09>D01
		--D13护理费为负数的默认为0.00
		update a set a.D13 ='0.00' from #syjbk_bak a where a.D13<0
		--A38C职业为空的数据默认为90其他

		update a set a.A38C ='90' from #syjbk_bak a where isnull(A38C,'')=''
		
		--A17大于9999
		 update a set a.A17='' from #syjbk_bak a WHERE A17>9999
		 --A26现住址最后一位数据为横线的
		 update   a set A26=LEFT(A26,LEN(A26)-1) from #syjbk_bak a WHERE LEN(A26)>4 AND RIGHT(A26,1)='-'

		 --C22x01C 麻醉方式,c23x01麻醉医生为空默认横线
		  		 update a set a.C22x01C='-' from #syjbk_bak a WHERE isnull(C22x01C,'')='' and C14x01C<>'-' 
				 update a set a.C23x01='-' from #syjbk_bak a WHERE isnull(C23x01,'')='' and C14x01C<>'-' 
     --健康卡号A47横线
	     update a set a.A47='-' from #syjbk_bak a 
		 --A15C国籍外国的默认为外籍
		 update a set a.A15C='外籍' from #syjbk_bak a  where A22 LIKE '%外籍%'
		update a set a.A15C='-' from #syjbk_bak a  where A48='20190018785'
	   update a set a.A19C='99' from #syjbk_bak a  where a.A19C='97' --其他民族
	--获取入院专业
	update a set a.B13C = b.FRYZLKM from #syjbk_bak a,BASYFJ b where a.A48=b.FPRN and a.A49=b.FTIMES AND isnull(b.FRYZLKM,'')<>''
	--获取转科专业
		update a set a.B21C = b.FZKZLKM from #syjbk_bak a,BASYFJ b where a.A48=b.FPRN and a.A49=b.FTIMES AND isnull(b.FZKZLKM,'')<>''

--获取出院专业
		update a set a.B16C = b.FCYZLKM from #syjbk_bak a,BASYFJ b where a.A48=b.FPRN and a.A49=b.FTIMES AND isnull(b.FCYZLKM,'')<>''
--mod by qgy 从病案首页数据取诊疗科目
	--获取入院专业
	update a set a.B13C = b.fryzlkmbh from #syjbk_bak a,#tpatientvisit b where a.A48=b.FPRN and a.A49=b.FTIMES AND isnull(b.fryzlkmbh,'')<>''
	--获取转科专业
		update a set a.B21C = b.fzkzlkmbh from #syjbk_bak a,#tpatientvisit b where a.A48=b.FPRN and a.A49=b.FTIMES AND isnull(b.fzkzlkmbh,'')<>''

--获取出院专业
		update a set a.B16C = b.fcyzlkmbh from #syjbk_bak a,#tpatientvisit b where a.A48=b.FPRN and a.A49=b.FTIMES AND isnull(b.fcyzlkmbh,'')<>''


		 --a49住院次数大于100改为1次
		  update a set a.A49='1' from #syjbk_bak a  where A49>100
		  --A19C外籍人士改为99
		 update a set a.A19C='99' from #syjbk_bak a  where a.A15C='外籍'

/********处理身份证校验位**********/--add by yangdi 2019.4.29
UPDATE  #syjbk_bak
    SET     A20 = '-'
    WHERE   LEN(A20)<15
UPDATE  a
SET     a.A20 = CASE WHEN LEN(a.A20) = 18
                           AND ISNUMERIC(LEFT(a.A20, 17)) = 0
                      THEN '-'
					  WHEN LEN(a.A20) = 18
					       AND ISNUMERIC(LEFT(a.A20, 17)) = 1
						   AND dbo.FUN_CALCAGE(SUBSTRING(a.A20,7,8),CONVERT(VARCHAR(8),GETDATE(),112),1)=0
					  THEN '-'
					  WHEN LEN(a.A20) = 18
                           AND ISNUMERIC(LEFT(a.A20, 17)) = 1
						   AND dbo.FUN_CALCAGE(SUBSTRING(a.A20,7,8),CONVERT(VARCHAR(8),GETDATE(),112),1)>0
                      THEN LEFT(a.A20, 17) + dbo.getCheckCode(a.A20)
                      ELSE a.A20
                 END
FROM    #syjbk_bak a

    UPDATE  #syjbk_bak
    SET     A20 = '-'
    WHERE   ISNULL(A20, '') = ''
	--处理病理诊断为 横线无诊断问题
UPDATE  #syjbk_bak
    SET     C10N = '-'
    WHERE   ISNULL(C09C, '') = '-' and isnull(C10N,'')=''

--20190016667
  -- update  #syjbk_bak set A14=0,A16=364


	IF EXISTS (SELECT 1 FROM THQMSSET WHERE FREPORTDATESTR=CONVERT(VARCHAR(7),CONVERT(SMALLDATETIME,LEFT(@ksrq,8)),120))
	BEGIN
		DELETE FROM THQMSSET WHERE FREPORTDATESTR=CONVERT(VARCHAR(7),CONVERT(SMALLDATETIME,LEFT(@ksrq,8)),120)
	END
	
	INSERT INTO THQMSSET (FREPORTDATESTR,
	A01,A02,A48,A49,B12,B15,A47,A46C,A11,A12C,
     A13,A14,A15C,A21C,A38C,A19C,A20,A22,A23C,A24,
	  A25C,A26,A27,A28C,A29,A30,A31C,A32,A33C,A34,
	   A35,B11C,B13C,B14,B21C,B16C,B17,B20,C01C,C02N,
		C03C,C04N,C05C,C06x01C,C07x01N,C08x01C,C06x02C,C07x02N,C08x02C,C06x03C,
		 C07x03N,C08x03C,C06x04C,C07x04N,C08x04C,C06x05C,C07x05N,C08x05C,C06x06C,C07x06N,
		  C08x06C,C06x07C,C07x07N,C08x07C,C06x08C,C07x08N,C08x08C,C06x09C,C07x09N,C08x09C,
		   C06x10C,C07x10N,C08x10C,C06x11C,C07x11N,C08x11C,C06x12C,C07x12N,C08x12C,C06x13C,
			C07x13N,C08x13C,C06x14C,C07x14N,C08x14C,C06x15C,C07x15N,C08x15C,C06x16C,C07x16N,
			 C08x16C,C06x17C,C07x17N,C08x17C,C06x18C,C07x18N,C08x18C,C06x19C,C07x19N,C08x19C,
			  C06x20C,C07x20N,C08x20C,C06x21C,C07x21N,C08x21C,C06x22C,C07x22N,C08x22C,C06x23C,
			   C07x23N,C08x23C,C06x24C,C07x24N,C08x24C,C06x25C,C07x25N,C08x25C,C06x26C,C07x26N,
				C08x26C,C06x27C,C07x27N,C08x27C,C06x28C,C07x28N,C08x28C,C06x29C,C07x29N,C08x29C,
				 C06x30C,C07x30N,C08x30C,C06x31C,C07x31N,C08x31C,C06x32C,C07x32N,C08x32C,C06x33C,
				  C07x33N,C08x33C,C06x34C,C07x34N,C08x34C,C06x35C,C07x35N,C08x35C,C06x36C,C07x36N,
				   C08x36C,C06x37C,C07x37N,C08x37C,C06x38C,C07x38N,C08x38C,C06x39C,C07x39N,C08x39C,
					C06x40C,C07x40N,C08x40C,C09C,C10N,C11,C12C,C13N,C24C,C25,
					 B22,B23,B24,B25,B26,B27,B28,B29,B30C,B31,
					  B32,B33,C34C,C26C,C27C,C14x01C,C15x01N,C16x01,C17x01,C18x01,
					   C19x01,C20x01,C21x01C,C22x01C,C23x01,C35x01C,C36x01N,C37x01,C38x01,C39x01,
						C40x01,C41x01,C42x01C,C43x01C,C44x01,C35x02C,C36x02N,C37x02,C38x02,C39x02,
						 C40x02,C41x02,C42x02C,C43x02C,C44x02,C35x03C,C36x03N,C37x03,C38x03,C39x03,
						  C40x03,C41x03,C42x03C,C43x03C,C44x03,C35x04C,C36x04N,C37x04,C38x04,C39x04,
						   C40x04,C41x04,C42x04C,C43x04C,C44x04,C35x05C,C36x05N,C37x05,C38x05,C39x05,
							C40x05,C41x05,C42x05C,C43x05C,C44x05,C35x06C,C36x06N,C37x06,C38x06,C39x06,
							 C40x06,C41x06,C42x06C,C43x06C,C44x06,C35x07C,C36x07N,C37x07,C38x07,C39x07,
							  C40x07,C41x07,C42x07C,C43x07C,C44x07,C35x08C,C36x08N,C37x08,C38x08,C39x08,
							   C40x08,C41x08,C42x08C,C43x08C,C44x08,C35x09C,C36x09N,C37x09,C38x09,C39x09,
								C40x09,C41x09,C42x09C,C43x09C,C44x09,C35x10C,C36x10N,C37x10,C38x10,C39x10,
								 C40x10,C41x10,C42x10C,C43x10C,C44x10,C35x11C,C36x11N,C37x11,C38x11,C39x11,
							      C40x11,C41x11,C42x11C,C43x11C,C44x11,C35x12C,C36x12N,C37x12,C38x12,C39x12,
								   C40x12,C41x12,C42x12C,C43x12C,C44x12,C35x13C,C36x13N,C37x13,C38x13,C39x13,
									C40x13,C41x13,C42x13C,C43x13C,C44x13,C35x14C,C36x14N,C37x14,C38x14,C39x14,
									 C40x14,C41x14,C42x14C,C43x14C,C44x14,C35x15C,C36x15N,C37x15,C38x15,C39x15,
									  C40x15,C41x15,C42x15C,C43x15C,C44x15,C35x16C,C36x16N,C37x16,C38x16,C39x16,
									   C40x16,C41x16,C42x16C,C43x16C,C44x16,C35x17C,C36x17N,C37x17,C38x17,C39x17,
										C40x17,C41x17,C42x17C,C43x17C,C44x17,C35x18C,C36x18N,C37x18,C38x18,C39x18,
										 C40x18,C41x18,C42x18C,C43x18C,C44x18,C35x19C,C36x19N,C37x19,C38x19,C39x19,
										  C40x19,C41x19,C42x19C,C43x19C,C44x19,C35x20C,C36x20N,C37x20,C38x20,C39x20,
										   C40x20,C41x20,C42x20C,C43x20C,C44x20,C35x21C,C36x21N,C37x21,C38x21,C39x21,
											C40x21,C41x21,C42x21C,C43x21C,C44x21,C35x22C,C36x22N,C37x22,C38x22,C39x22,
											 C40x22,C41x22,C42x22C,C43x22C,C44x22,C35x23C,C36x23N,C37x23,C38x23,C39x23,
											  C40x23,C41x23,C42x23C,C43x23C,C44x23,C35x24C,C36x24N,C37x24,C38x24,C39x24,
											   C40x24,C41x24,C42x24C,C43x24C,C44x24,C35x25C,C36x25N,C37x25,C38x25,C39x25,
												C40x25,C41x25,C42x25C,C43x25C,C44x25,C35x26C,C36x26N,C37x26,C38x26,C39x26,
												 C40x26,C41x26,C42x26C,C43x26C,C44x26,C35x27C,C36x27N,C37x27,C38x27,C39x27,
												  C40x27,C41x27,C42x27C,C43x27C,C44x27,C35x28C,C36x28N,C37x28,C38x28,C39x28,
												   C40x28,C41x28,C42x28C,C43x28C,C44x28,C35x29C,C36x29N,C37x29,C38x29,C39x29,
												    C40x29,C41x29,C42x29C,C43x29C,C44x29,C35x30C,C36x30N,C37x30,C38x30,C39x30,
													 C40x30,C41x30,C42x30C,C43x30C,C44x30,C35x31C,C36x31N,C37x31,C38x31,C39x31,
													  C40x31,C41x31,C42x31C,C43x31C,C44x31,C35x32C,C36x32N,C37x32,C38x32,C39x32,
													   C40x32,C41x32,C42x32C,C43x32C,C44x32,C35x33C,C36x33N,C37x33,C38x33,C39x33,
													    C40x33,C41x33,C42x33C,C43x33C,C44x33,C35x34C,C36x34N,C37x34,C38x34,C39x34,
														 C40x34,C41x34,C42x34C,C43x34C,C44x34,C35x35C,C36x35N,C37x35,C38x35,C39x35,
														  C40x35,C41x35,C42x35C,C43x35C,C44x35,C35x36C,C36x36N,C37x36,C38x36,C39x36,
														   C40x36,C41x36,C42x36C,C43x36C,C44x36,C35x37C,C36x37N,C37x37,C38x37,C39x37,
														    C40x37,C41x37,C42x37C,C43x37C,C44x37,C35x38C,C36x38N,C37x38,C38x38,C39x38,
															 C40x38,C41x38,C42x38C,C43x38C,C44x38,C35x39C,C36x39N,C37x39,C38x39,C39x39,
															  C40x39,C41x39,C42x39C,C43x39C,C44x39,C35x40C,C36x40N,C37x40,C38x40,C39x40,
															   C40x40,C41x40,C42x40C,C43x40C,C44x40,A16,A18x01,A18x02,A18x03,A18x04,
															    A18x05,A17,C28,C29,C30,C31,C32,C33,B36C,B37,
																 B34C,B35,D01,D09,D11,D12,D13,D14,D15,D16,
																  D17,D18,D19,D19x01,D20,D20x01,D20x02,D21,D22,D23,
																   D23x01,D24,D25,D26,D27,D28,D29,D30,D31,D32,
																    D33,D34)
	select CONVERT(VARCHAR(7),CONVERT(SMALLDATETIME,LEFT(@ksrq,8)),120),
	A01,A02,A48,A49,B12,B15,A47,A46C,A11,A12C,
     A13,A14,A15C,A21C,A38C,A19C,A20,A22,A23C,A24,
	  A25C,A26,A27,A28C,A29,A30,A31C,A32,A33C,A34,
	   A35,B11C,B13C,B14,B21C,B16C,B17,B20,C01C,C02N,
		C03C,C04N,C05C,C06x01C,C07x01N,C08x01C,C06x02C,C07x02N,C08x02C,C06x03C,
		 C07x03N,C08x03C,C06x04C,C07x04N,C08x04C,C06x05C,C07x05N,C08x05C,C06x06C,C07x06N,
		  C08x06C,C06x07C,C07x07N,C08x07C,C06x08C,C07x08N,C08x08C,C06x09C,C07x09N,C08x09C,
		   C06x10C,C07x10N,C08x10C,C06x11C,C07x11N,C08x11C,C06x12C,C07x12N,C08x12C,C06x13C,
			C07x13N,C08x13C,C06x14C,C07x14N,C08x14C,C06x15C,C07x15N,C08x15C,C06x16C,C07x16N,
			 C08x16C,C06x17C,C07x17N,C08x17C,C06x18C,C07x18N,C08x18C,C06x19C,C07x19N,C08x19C,
			  C06x20C,C07x20N,C08x20C,C06x21C,C07x21N,C08x21C,C06x22C,C07x22N,C08x22C,C06x23C,
			   C07x23N,C08x23C,C06x24C,C07x24N,C08x24C,C06x25C,C07x25N,C08x25C,C06x26C,C07x26N,
				C08x26C,C06x27C,C07x27N,C08x27C,C06x28C,C07x28N,C08x28C,C06x29C,C07x29N,C08x29C,
				 C06x30C,C07x30N,C08x30C,C06x31C,C07x31N,C08x31C,C06x32C,C07x32N,C08x32C,C06x33C,
				  C07x33N,C08x33C,C06x34C,C07x34N,C08x34C,C06x35C,C07x35N,C08x35C,C06x36C,C07x36N,
				   C08x36C,C06x37C,C07x37N,C08x37C,C06x38C,C07x38N,C08x38C,C06x39C,C07x39N,C08x39C,
					C06x40C,C07x40N,C08x40C,C09C,C10N,C11,C12C,C13N,C24C,C25,
					 B22,B23,B24,B25,B26,B27,B28,B29,B30C,B31,
					  B32,B33,C34C,C26C,C27C,C14x01C,C15x01N,C16x01,C17x01,C18x01,
					   C19x01,C20x01,C21x01C,C22x01C,C23x01,C35x01C,C36x01N,C37x01,C38x01,C39x01,
						C40x01,C41x01,C42x01C,C43x01C,C44x01,C35x02C,C36x02N,C37x02,C38x02,C39x02,
						 C40x02,C41x02,C42x02C,C43x02C,C44x02,C35x03C,C36x03N,C37x03,C38x03,C39x03,
						  C40x03,C41x03,C42x03C,C43x03C,C44x03,C35x04C,C36x04N,C37x04,C38x04,C39x04,
						   C40x04,C41x04,C42x04C,C43x04C,C44x04,C35x05C,C36x05N,C37x05,C38x05,C39x05,
							C40x05,C41x05,C42x05C,C43x05C,C44x05,C35x06C,C36x06N,C37x06,C38x06,C39x06,
							 C40x06,C41x06,C42x06C,C43x06C,C44x06,C35x07C,C36x07N,C37x07,C38x07,C39x07,
							  C40x07,C41x07,C42x07C,C43x07C,C44x07,C35x08C,C36x08N,C37x08,C38x08,C39x08,
							   C40x08,C41x08,C42x08C,C43x08C,C44x08,C35x09C,C36x09N,C37x09,C38x09,C39x09,
								C40x09,C41x09,C42x09C,C43x09C,C44x09,C35x10C,C36x10N,C37x10,C38x10,C39x10,
								 C40x10,C41x10,C42x10C,C43x10C,C44x10,C35x11C,C36x11N,C37x11,C38x11,C39x11,
							      C40x11,C41x11,C42x11C,C43x11C,C44x11,C35x12C,C36x12N,C37x12,C38x12,C39x12,
								   C40x12,C41x12,C42x12C,C43x12C,C44x12,C35x13C,C36x13N,C37x13,C38x13,C39x13,
									C40x13,C41x13,C42x13C,C43x13C,C44x13,C35x14C,C36x14N,C37x14,C38x14,C39x14,
									 C40x14,C41x14,C42x14C,C43x14C,C44x14,C35x15C,C36x15N,C37x15,C38x15,C39x15,
									  C40x15,C41x15,C42x15C,C43x15C,C44x15,C35x16C,C36x16N,C37x16,C38x16,C39x16,
									   C40x16,C41x16,C42x16C,C43x16C,C44x16,C35x17C,C36x17N,C37x17,C38x17,C39x17,
										C40x17,C41x17,C42x17C,C43x17C,C44x17,C35x18C,C36x18N,C37x18,C38x18,C39x18,
										 C40x18,C41x18,C42x18C,C43x18C,C44x18,C35x19C,C36x19N,C37x19,C38x19,C39x19,
										  C40x19,C41x19,C42x19C,C43x19C,C44x19,C35x20C,C36x20N,C37x20,C38x20,C39x20,
										   C40x20,C41x20,C42x20C,C43x20C,C44x20,C35x21C,C36x21N,C37x21,C38x21,C39x21,
											C40x21,C41x21,C42x21C,C43x21C,C44x21,C35x22C,C36x22N,C37x22,C38x22,C39x22,
											 C40x22,C41x22,C42x22C,C43x22C,C44x22,C35x23C,C36x23N,C37x23,C38x23,C39x23,
											  C40x23,C41x23,C42x23C,C43x23C,C44x23,C35x24C,C36x24N,C37x24,C38x24,C39x24,
											   C40x24,C41x24,C42x24C,C43x24C,C44x24,C35x25C,C36x25N,C37x25,C38x25,C39x25,
												C40x25,C41x25,C42x25C,C43x25C,C44x25,C35x26C,C36x26N,C37x26,C38x26,C39x26,
												 C40x26,C41x26,C42x26C,C43x26C,C44x26,C35x27C,C36x27N,C37x27,C38x27,C39x27,
												  C40x27,C41x27,C42x27C,C43x27C,C44x27,C35x28C,C36x28N,C37x28,C38x28,C39x28,
												   C40x28,C41x28,C42x28C,C43x28C,C44x28,C35x29C,C36x29N,C37x29,C38x29,C39x29,
												    C40x29,C41x29,C42x29C,C43x29C,C44x29,C35x30C,C36x30N,C37x30,C38x30,C39x30,
													 C40x30,C41x30,C42x30C,C43x30C,C44x30,C35x31C,C36x31N,C37x31,C38x31,C39x31,
													  C40x31,C41x31,C42x31C,C43x31C,C44x31,C35x32C,C36x32N,C37x32,C38x32,C39x32,
													   C40x32,C41x32,C42x32C,C43x32C,C44x32,C35x33C,C36x33N,C37x33,C38x33,C39x33,
													    C40x33,C41x33,C42x33C,C43x33C,C44x33,C35x34C,C36x34N,C37x34,C38x34,C39x34,
														 C40x34,C41x34,C42x34C,C43x34C,C44x34,C35x35C,C36x35N,C37x35,C38x35,C39x35,
														  C40x35,C41x35,C42x35C,C43x35C,C44x35,C35x36C,C36x36N,C37x36,C38x36,C39x36,
														   C40x36,C41x36,C42x36C,C43x36C,C44x36,C35x37C,C36x37N,C37x37,C38x37,C39x37,
														    C40x37,C41x37,C42x37C,C43x37C,C44x37,C35x38C,C36x38N,C37x38,C38x38,C39x38,
															 C40x38,C41x38,C42x38C,C43x38C,C44x38,C35x39C,C36x39N,C37x39,C38x39,C39x39,
															  C40x39,C41x39,C42x39C,C43x39C,C44x39,C35x40C,C36x40N,C37x40,C38x40,C39x40,
															   C40x40,C41x40,C42x40C,C43x40C,C44x40,A16,A18x01,A18x02,A18x03,A18x04,
															    A18x05,A17,C28,C29,C30,C31,C32,C33,B36C,B37,
																 B34C,B35,D01,D09,D11,D12,D13,D14,D15,D16,
																  D17,D18,D19,D19x01,D20,D20x01,D20x02,D21,D22,D23,
																   D23x01,D24,D25,D26,D27,D28,D29,D30,D31,D32,
																    D33,D34
	from #syjbk_bak
    --set @zjerrcode = 0
    --return 

    --Err:
    --rollback tran

    --set @zjerrcode = 1
    --PRINT @zjerrmsg
    --select 0
    --return

	
CREATE TABLE #syjbk_error ( ms  VARCHAR(300),syxh VARCHAR(20))
-----PPT1
IF EXISTS (SELECT top 1 * FROM #syjbk_bak WHERE ISNULL(REPLACE(D01,'-',''),'')='')
INSERT #syjbk_error 
	SELECT 'D01住院总费用为空',A48 
	FROM #syjbk_bak WHERE ISNULL(REPLACE(D01,'-',''),'')=''
	
	---B20REPLACE(,-,'')
	IF EXISTS (SELECT top 1 * FROM #syjbk_bak WHERE ISNULL(REPLACE(B20,'-',''),'')='') 
  INSERT #syjbk_error 
	SELECT 'B20实际住院天数为空',A48 
	FROM #syjbk_bak WHERE ISNULL(REPLACE(B20,'-',''),'')='' 
	
	IF EXISTS (SELECT top 1 * FROM #syjbk_bak WHERE  B20<'0')
  INSERT #syjbk_error 
	SELECT 'B20实际住院天数小于零',A48 
	FROM #syjbk_bak WHERE  B20<'0'
	
	
	IF EXISTS (SELECT top 1 * FROM #syjbk_bak WHERE ISNULL(REPLACE(C03C,'-',''),'')='')
	INSERT #syjbk_error 
	SELECT 'C03C出院主要诊断编码为空',A48 
	FROM #syjbk_bak WHERE ISNULL(REPLACE(C03C,'-',''),'')=''
	
	IF EXISTS (SELECT top 1 * FROM #syjbk_bak WHERE ISNULL(REPLACE(C04N,'-',''),'')='')
	INSERT #syjbk_error 
	SELECT 'C04N出院主要诊断名称为空',A48 
	FROM #syjbk_bak WHERE ISNULL(REPLACE(C04N,'-',''),'')=''
	
	IF EXISTS (SELECT top 1 * FROM #syjbk_bak WHERE  A14<'0')
    INSERT #syjbk_error 
	SELECT 'A14年龄小于零',A48 
	FROM #syjbk_bak WHERE  A14<'0'
 
	
    IF EXISTS (SELECT 1 FROM #syjbk_bak WHERE B34C NOT IN ( SELECT  FDSFBH FROM dbo.thisdictdsf WHERE FZDBH='HQMSRC019' ))
	INSERT #syjbk_error 
	SELECT 'B34C离院方式不在字典范围内',A48 
	FROM #syjbk_bak WHERE B34C NOT IN ( SELECT  FDSFBH FROM dbo.thisdictdsf WHERE FZDBH='HQMSRC019' )
	
	IF EXISTS (SELECT 1 FROM #syjbk_bak WHERE A21C NOT IN ( SELECT   FDSFBH FROM dbo.thisdictdsf where FZDBH='HQMSRC002' ))
	INSERT #syjbk_error 
	SELECT 'A21C婚姻状况不在字典范围内',A48 
	FROM #syjbk_bak WHERE A21C NOT IN ( SELECT   FDSFBH FROM dbo.thisdictdsf where FZDBH='HQMSRC002')
	
--PPT2
	--SELECT Value_Standard,* FROM dbo.T_Map_Mapping

    IF EXISTS (SELECT 1 FROM #syjbk_bak WHERE C03C NOT IN ( SELECT  FUPICDM FROM dbo.tupicd10set )  )
	INSERT #syjbk_error 
	SELECT C03C+' 出院主要诊断编码不在字典范围内',A48 
	FROM #syjbk_bak WHERE C03C NOT IN ( SELECT  FUPICDM FROM dbo.tupicd10set   )
	
	--C04N
	IF EXISTS (SELECT 1 FROM #syjbk_bak a,tupicd10set b WHERE a.C03C=b.FUPICDM and a.C04N <>b.FUPJBNAME )
	INSERT #syjbk_error 
	SELECT 'C04N与C03C出院主要诊断名称与编码不符',A48 
	FROM #syjbk_bak a,tupicd10set b WHERE a.C03C=b.FUPICDM and a.C04N <>b.FUPJBNAME  


IF EXISTS (SELECT 1 FROM #syjbk_bak WHERE C01C NOT IN ( SELECT  FUPICDM FROM dbo.tupicd10set  ))
	INSERT #syjbk_error 
	SELECT 'C01C门（急）诊诊断编码',A48 
	FROM #syjbk_bak WHERE C01C NOT IN ( SELECT   FUPICDM FROM dbo.tupicd10set  )	
	
 
 --入院时间晚于出院时间、出生日期
 if exists(select 1 from #syjbk_bak where B12>B15 or B12<A13)
 begin 
   INSERT #syjbk_error
   select A48+'入院时间晚于出院时间、出生日期',A48
   from #syjbk_bak where B12>B15 or B12<A13
 end 
 --出现O80-O84编码，且流产结局编码未出现O00-O08时，其他诊断无分娩结局编码 Z37 ？
 select * into  #syjbk_37 from #syjbk_bak where 1=2
  insert into #syjbk_37 
 select * from #syjbk_bak where (C03C LIKE 'O81%' or C06x01C  LIKE 'O81%' 
 OR C06x02C  LIKE 'O81%' OR C06x03C LIKE 'O81%' OR C06x04C  LIKE 'O81%'
  OR C06x05C  LIKE 'O81%' OR C06x06C  LIKE 'O81%' OR C06x07C  LIKE 'O81%') and  ( C06x01C NOT LIKE 'O0%' 
 OR C06x02C NOT LIKE 'O0%' OR C06x03C NOT LIKE 'O0%' OR C06x04C NOT LIKE 'O0%'
  OR C06x05C NOT LIKE 'O0%' OR C06x06C NOT LIKE 'O0%' OR C06x07C NOT LIKE 'O0%')
    insert into #syjbk_37 
 select * from #syjbk_bak where (C03C LIKE 'O82%' or C06x01C  LIKE 'O82%' 
 OR C06x02C  LIKE 'O82%' OR C06x03C LIKE 'O82%' OR C06x04C  LIKE 'O82%'
  OR C06x05C  LIKE 'O82%' OR C06x06C  LIKE 'O82%' OR C06x07C  LIKE 'O82%') and  ( C06x01C NOT LIKE 'O00%' 
 OR C06x02C NOT LIKE 'O0%' OR C06x03C NOT LIKE 'O0%' OR C06x04C NOT LIKE 'O0%'
  OR C06x05C NOT LIKE 'O0%' OR C06x06C NOT LIKE 'O0%' OR C06x07C NOT LIKE 'O0%')

    insert into #syjbk_37 
 select * from #syjbk_bak where (C03C LIKE 'O83%' or C06x01C  LIKE 'O83%' 
 OR C06x02C  LIKE 'O83%' OR C06x03C LIKE 'O83%' OR C06x04C  LIKE 'O83%'
  OR C06x05C  LIKE 'O83%' OR C06x06C  LIKE 'O83%' OR C06x07C  LIKE 'O83%') and  ( C06x01C NOT LIKE 'O0%' 
 OR C06x02C NOT LIKE 'O0%' OR C06x03C NOT LIKE 'O0%' OR C06x04C NOT LIKE 'O0%'
  OR C06x05C NOT LIKE 'O0%' OR C06x06C NOT LIKE 'O0%' OR C06x07C NOT LIKE 'O0%')


    insert into #syjbk_37 
 select * from #syjbk_bak where (C03C LIKE 'O84%' or C06x01C  LIKE 'O84%' 
 OR C06x02C  LIKE 'O84%' OR C06x03C LIKE 'O84%' OR C06x04C  LIKE 'O84%'
  OR C06x05C  LIKE 'O84%' OR C06x06C  LIKE 'O84%' OR C06x07C  LIKE 'O84%') and  ( C06x01C NOT LIKE 'O0%' 
 OR C06x02C NOT LIKE 'O0%' OR C06x03C NOT LIKE 'O0%' OR C06x04C NOT LIKE 'O0%'
  OR C06x05C NOT LIKE 'O0%' OR C06x06C NOT LIKE 'O0%' OR C06x07C NOT LIKE 'O0%')




 insert into #syjbk_37 
 select * from #syjbk_bak where C03C LIKE 'O80%' and ( C06x01C NOT LIKE 'O00%' 
 OR C06x02C NOT LIKE 'O00%' OR C06x03C NOT LIKE 'O00%' OR C06x04C NOT LIKE 'O00%'
  OR C06x05C NOT LIKE 'O00%' OR C06x06C NOT LIKE 'O00%' OR C06x07C NOT LIKE 'O00%')
   insert into #syjbk_37 
 select * from #syjbk_bak where C03C LIKE 'O80%' and ( C06x01C NOT LIKE 'O08%' 
 OR C06x02C NOT LIKE 'O08%' OR C06x03C NOT LIKE 'O08%' OR C06x04C NOT LIKE 'O08%'
  OR C06x05C NOT LIKE 'O08%' OR C06x06C NOT LIKE 'O08%' OR C06x07C NOT LIKE 'O08%')
    
     insert into #syjbk_37 
	select * from #syjbk_bak where  C06X01C LIKE 'O80%' AND  (C03C NOT LIKE 'O00%' OR C06X02C NOT LIKE 'O00%' OR C06X03C NOT LIKE 'O00%' OR C06X04C NOT LIKE 'O00%'
   OR C06X05C NOT LIKE 'O00%' OR C06X06C NOT LIKE 'O00%' OR C06X07C NOT LIKE 'O00%')
      insert into #syjbk_37 
	select * from #syjbk_bak where  C06X01C LIKE 'O80%' AND  (C03C NOT LIKE 'O08%' OR C06X02C NOT LIKE 'O08%' OR C06X03C NOT LIKE 'O08%' OR C06X04C NOT LIKE 'O08%'
   OR C06X05C NOT LIKE 'O08%' OR C06X06C NOT LIKE 'O08%' OR C06X07C NOT LIKE 'O08%')

    insert into #syjbk_37 
   select * from #syjbk_bak where C06X02C  LIKE 'O80%' AND ( C03C NOT LIKE 'O00%' OR C06X01C NOT LIKE 'O00%' OR C06X03C NOT LIKE 'O00%' OR C06X04C NOT LIKE 'O00%'
   OR C06X05C NOT LIKE 'O00%' OR C06X06C NOT LIKE 'O00%' OR C06X07C NOT LIKE 'O00%')
         insert into #syjbk_37 
	select * from #syjbk_bak where  C06X02C LIKE 'O80%' AND  (C03C NOT LIKE 'O08%' OR C06X01C NOT LIKE 'O08%' OR C06X03C NOT LIKE 'O08%' OR C06X04C NOT LIKE 'O08%'
   OR C06X05C NOT LIKE 'O08%' OR C06X06C NOT LIKE 'O08%' OR C06X07C NOT LIKE 'O08%')

       insert into #syjbk_37 
   select * from #syjbk_bak where C06X03C  LIKE 'O80%' AND ( C03C NOT LIKE 'O00%' OR C06X01C NOT LIKE 'O00%' OR C06X02C NOT LIKE 'O00%' OR C06X04C NOT LIKE 'O00%'
   OR C06X05C NOT LIKE 'O00%' OR C06X06C NOT LIKE 'O00%' OR C06X07C NOT LIKE 'O00%')
         insert into #syjbk_37 
	select * from #syjbk_bak where  C06X03C LIKE 'O80%' AND  (C03C NOT LIKE 'O08%' OR C06X01C NOT LIKE 'O08%' OR C06X02C NOT LIKE 'O08%' OR C06X04C NOT LIKE 'O08%'
   OR C06X05C NOT LIKE 'O08%' OR C06X06C NOT LIKE 'O08%' OR C06X07C NOT LIKE 'O08%')

      insert into #syjbk_37 
   select * from #syjbk_bak where C06X04C  LIKE 'O80%' AND ( C03C NOT LIKE 'O00%' OR C06X01C NOT LIKE 'O00%' OR C06X02C NOT LIKE 'O00%' OR C06X03C NOT LIKE 'O00%'
   OR C06X05C NOT LIKE 'O00%' OR C06X06C NOT LIKE 'O00%' OR C06X07C NOT LIKE 'O00%')
         insert into #syjbk_37 
	select * from #syjbk_bak where  C06X04C LIKE 'O80%' AND  (C03C NOT LIKE 'O08%' OR C06X01C NOT LIKE 'O08%' OR C06X02C NOT LIKE 'O08%' OR C06X03C NOT LIKE 'O08%'
   OR C06X05C NOT LIKE 'O08%' OR C06X06C NOT LIKE 'O08%' OR C06X07C NOT LIKE 'O08%')
   
       insert into #syjbk_37 
   select * from #syjbk_bak where C06X05C  LIKE 'O80%' AND ( C03C NOT LIKE 'O00%' OR C06X01C NOT LIKE 'O00%' OR C06X02C NOT LIKE 'O00%' OR C06X03C NOT LIKE 'O00%'
   OR C06X04C NOT LIKE 'O00%' OR C06X06C NOT LIKE 'O00%' OR C06X07C NOT LIKE 'O00%')
         insert into #syjbk_37 
	select * from #syjbk_bak where  C06X05C LIKE 'O80%' AND  (C03C NOT LIKE 'O08%' OR C06X01C NOT LIKE 'O08%' OR C06X02C NOT LIKE 'O08%' OR C06X03C NOT LIKE 'O08%'
   OR C06X04C NOT LIKE 'O08%' OR C06X06C NOT LIKE 'O08%' OR C06X07C NOT LIKE 'O08%')

       insert into #syjbk_37 
   select * from #syjbk_bak where C06X06C  LIKE 'O80%' AND ( C03C NOT LIKE 'O00%' OR C06X01C NOT LIKE 'O00%' OR C06X02C NOT LIKE 'O00%' OR C06X03C NOT LIKE 'O00%'
   OR C06X04C NOT LIKE 'O00%' OR C06X05C NOT LIKE 'O00%' OR C06X07C NOT LIKE 'O00%')
         insert into #syjbk_37 
	select * from #syjbk_bak where  C06X06C LIKE 'O80%' AND  (C03C NOT LIKE 'O08%' OR C06X01C NOT LIKE 'O08%' OR C06X02C NOT LIKE 'O08%' OR C06X03C NOT LIKE 'O08%'
   OR C06X04C NOT LIKE 'O08%' OR C06X05C NOT LIKE 'O08%' OR C06X07C NOT LIKE 'O08%')
            insert into #syjbk_37 
	select * from #syjbk_bak where  C06X07C LIKE 'O80%' AND  (C03C NOT LIKE 'O08%' OR C06X01C NOT LIKE 'O08%' OR C06X02C NOT LIKE 'O08%' OR C06X03C NOT LIKE 'O08%'
   OR C06X04C NOT LIKE 'O08%' OR C06X05C NOT LIKE 'O08%' OR C06X06C NOT LIKE 'O08%')
   insert into #syjbk_37 
   select * from #syjbk_bak where C06X07C  LIKE 'O80%' AND ( C03C NOT LIKE 'O00%' OR C06X01C NOT LIKE 'O00%' OR C06X02C NOT LIKE 'O00%' OR C06X03C NOT LIKE 'O00%'
   OR C06X04C NOT LIKE 'O00%' OR C06X05C NOT LIKE 'O00%' OR C06X06C NOT LIKE 'O00%')

 


  if exists(select 1 from #syjbk_37 where  C03C  not LIKE 'Z37%' and  C06X01C NOT LIKE 'Z37%'  and C06X02C NOT LIKE 'Z37%'  and C06X03C NOT LIKE 'Z37%'  and C06X04C NOT LIKE 'Z37%' 
   and C06X05C NOT LIKE 'Z37%'  and C06X06C NOT LIKE 'Z37%'  and C06X07C NOT LIKE 'Z37%' and C06X08C  LIKE 'Z37%'  and C06X09C  LIKE 'Z37%' and C06X10C  LIKE 'Z37%' and C06X11C  LIKE 'Z37%'
  
  )
 begin 
   INSERT #syjbk_error
   select A48+'无分娩结局',A48
   from #syjbk_37 where C03C  not LIKE 'Z37%' and  C06X01C NOT LIKE 'Z37%'  and C06X02C NOT LIKE 'Z37%'  and C06X03C NOT LIKE 'Z37%'  and C06X04C NOT LIKE 'Z37%' 
   and C06X05C NOT LIKE 'Z37%'  and C06X06C NOT LIKE 'Z37%'  and C06X07C NOT LIKE 'Z37%'  and  C06X08C  LIKE 'Z37%' and C06X09C  LIKE 'Z37%' and C06X10C  LIKE 'Z37%' and C06X11C  LIKE 'Z37%' 
 end 

   if exists(select 1 from #syjbk_37 where (C03C   LIKE 'Z37%' OR  C06X01C  LIKE 'Z37%'  OR C06X02C LIKE 'Z37%'  OR C06X03C LIKE 'Z37%'  OR C06X04C  LIKE 'Z37%' 
   OR C06X05C  LIKE 'Z37%'  OR C06X06C  LIKE 'Z37%'  OR C06X07C  LIKE 'Z37%'  OR C06X08C  LIKE 'Z37%' OR C06X09C  LIKE 'Z37%' OR C06X10C  LIKE 'Z37%' OR C06X11C  LIKE 'Z37%'   )AND ISNULL(A18x01,'')=''
  
  )
 begin 
   INSERT #syjbk_error
   select A48+'有分娩结局无新生儿体重',A48
   from #syjbk_37 where  ISNULL(A18x01,'')='' AND  (C03C   LIKE 'Z37%' OR  C06X01C  LIKE 'Z37%'  OR C06X02C LIKE 'Z37%'  OR C06X03C LIKE 'Z37%'  OR C06X04C  LIKE 'Z37%' 
   OR C06X05C  LIKE 'Z37%'  OR C06X06C  LIKE 'Z37%'  OR C06X07C  LIKE 'Z37%'  OR C06X08C  LIKE 'Z37%' OR C06X09C  LIKE 'Z37%' OR C06X10C  LIKE 'Z37%' OR C06X11C  LIKE 'Z37%') 
 end 






 --出院主要诊断ICD-10首字母为C或D00-D48时，病理诊断编码为空
 if exists(select 1 from  #syjbk_bak where (C03C like 'C%' or C03C like 'D00%' or C03C LIKE  'D48%') and isnull(C09C,'-')='-')
 begin 
    INSERT #syjbk_error
   select '出院主要诊断ICD-10首字母为C或D00-D48时，病理诊断编码为空',A48
   from #syjbk_bak where (C03C like 'C%' or C03C like 'D00%' or C03C LIKE 'D48%') and isnull(C09C,'-')='-'
 end 
 --病理诊断编码不为M肿瘤形态学数据
 if exists(select 1 from  #syjbk_bak where C09C is not null and C09C not like 'M%')
 begin 
    INSERT #syjbk_error
   select '病理诊断编码不为M开头肿瘤形态学编码',A48
   from #syjbk_bak where isnull(C09C,'')<>'-'  AND isnull(C09C,'')<>''and C09C not like 'M%' 
 end 



 --无病理编码或者病理编号或者病理诊断
 --if exists(select 1 from  #syjbk_bak where ISNULL(C09C,'')<>'' and  (ISNULL(REPLACE(C10N,'-',''),'')='' OR ISNULL(REPLACE(C11,'-',''),'')=''))
 --begin 
 --   INSERT #syjbk_error
 --  select A48+'无病理编码或者病理编号或者病理诊断',A48
 --  from #syjbk_bak where isnull(C09C,'')<>''and (ISNULL(REPLACE(C10N,'-',''),'')='' OR ISNULL(REPLACE(C11,'-',''),'')='')
 --end 
 --if exists(select 1 from  #syjbk_bak where ISNULL(C10N,'')<>'' and (ISNULL(REPLACE(C09C,'-',''),'')='' OR ISNULL(REPLACE(C11,'-',''),'')=''))
 --begin 
 --   INSERT #syjbk_error
 --  select A48+'无病理编码或者病理编号或者病理诊断',A48
 --  from #syjbk_bak where  ISNULL(C10N,'')<>'' and (ISNULL(REPLACE(C09C,'-',''),'')='' OR ISNULL(REPLACE(C11,'-',''),'')='')
 --end 
 -- if exists(select 1 from  #syjbk_bak where ISNULL(C11,'')<>'' and (ISNULL(REPLACE(C09C,'-',''),'')='' OR ISNULL(REPLACE(C10N,'-',''),'')=''))
 --begin 
 --   INSERT #syjbk_error
 --  select A48+'无病理编码或者病理编号或者病理诊断',A48
 --  from #syjbk_bak where  ISNULL(C11,'')<>'' and (ISNULL(REPLACE(C09C,'-',''),'')='' OR ISNULL(REPLACE(C10N,'-',''),'')='')
 --end 


 --出院主要诊断ICD-10首字母为S或T时，损伤、中毒外部原因编码为空
  if exists(select 1 from  #syjbk_bak where (C03C like 'S%' or C03C like 'T%' ) and isnull(C12C,'-')='-')
 begin 
    INSERT #syjbk_error
   select A48+'出院主要诊断ICD-10首字母为S或T时，损伤、中毒外部原因编码为空',A48
   from #syjbk_bak where (C03C like 'S%' or C03C like 'T%' ) and isnull(C12C,'-')='-'
 end 
 --住院总费用应<自付金额、住院总费用小于分项之和
----------------------以下为条件必填------------------------------------------
-- 离院方式为医嘱转院或医嘱转社区患者必填B35

-- 年龄不足1周岁的年龄（天）：A16按照实足年龄的天数填写。年龄不足1周岁时填写，年龄值A14应为0，取值范围：大于或等于0小于365，入院时间减出生日期后取整数，不足一天按0天计算。
--新生儿出生体重(克):A18x01 测量新生儿体重要求精确到10克；应在活产后一小时内称取重量。1、产妇和新生儿病案填写，从出生到28天为新生儿期，双胎及以上不同胎儿体重则继续填写下面的新生儿出生体重。2、新生儿体重范围：100克-9999克，产妇的主要诊断或其他诊断编码中含有Z37.0,Z37.2, Z37.3, Z37.5, Z37.6编码时，必须填写新生儿出生体重
--新生儿入院体重（克）:A17 100克-9999克，精确到10克；新生儿入院当日的体重；小于等于28天的新生儿必填，填写了新生儿入出院体重的，必须填写年龄不足1周岁的年龄（天），且必须小于等于28天。
--过敏药物名称:C25  有无药物过敏”为“有”时必填；多种药物用英文逗号进行分隔
if exists(select  1 from #syjbk_bak where C24C='2' and isnull(C25,'')='' )
begin 
   INSERT #syjbk_error
   select A48+'有无药物过敏”为“有”时必填；多种药物用英文逗号进行分隔',A48
   from #syjbk_bak where C24C='2' and isnull(C25,'')=''
end 


--------------必填项目-----------------------------------
--组织机构代码	A01
if exists(select 1 from #syjbk_bak where isnull(A01,'')='')
begin 
 INSERT #syjbk_error
 select  '组织机构代码为空',A48
   from #syjbk_bak where isnull(A01,'')=''
end 
--医疗机构名称	A02
if exists(select 1 from #syjbk_bak where isnull(A02,'')='')
begin 
 INSERT #syjbk_error
 select  '医疗机构名称为空',A48
   from #syjbk_bak where isnull(A02,'')=''
end 
--病案号	A48
if exists(select 1 from #syjbk_bak where isnull(A48,'')='')
begin 
 INSERT #syjbk_error
 select  '病案号为空',A48
   from #syjbk_bak where isnull(A48,'')=''
end 
--住院次数	A49
if exists(select 1 from #syjbk_bak where isnull(A49,'')='')
begin 
 INSERT #syjbk_error
 select  '住院次数为空',A48
   from #syjbk_bak where isnull(A49,'')=''
end 
--入院时间	B12
if exists(select 1 from #syjbk_bak where isnull(B12,'')='')
begin 
 INSERT #syjbk_error
 select  '入院时间为空',A48
   from #syjbk_bak where isnull(B12,'')=''
end 

--出院时间	B15
if exists(select 1 from #syjbk_bak where isnull(B15,'')='')
begin 
 INSERT #syjbk_error
 select  '出院时间为空',A48
   from #syjbk_bak where isnull(B15,'')=''
end 
--医疗付费方式	A46C
if exists(select 1 from #syjbk_bak where isnull(A46C,'')='')
begin 
 INSERT #syjbk_error
 select  '医疗付费方式为空',A48
   from #syjbk_bak where isnull(A46C,'')=''
end 
--姓名	A11
if exists(select 1 from #syjbk_bak where isnull(A11,'')='')
begin 
 INSERT #syjbk_error
 select  '姓名为空',A48
   from #syjbk_bak where isnull(A11,'')=''
end 

--性别	A12C
if exists(select 1 from #syjbk_bak where isnull(A12C,'')='')
begin 
 INSERT #syjbk_error
 select  '性别为空',A48
   from #syjbk_bak where isnull(A12C,'')=''
end 
--出生日期	A13
if exists(select 1 from #syjbk_bak where isnull(A13,'')='')
begin 
 INSERT #syjbk_error
 select  '出生日期为空',A48
   from #syjbk_bak where isnull(A13,'')=''
end 

--年龄（岁）	A14
if exists(select 1 from #syjbk_bak where isnull(A14,'')='')
begin 
 INSERT #syjbk_error
 select  '年龄（岁）为空',A48
   from #syjbk_bak where isnull(A14,'')=''
end 
--国籍	A15C
if exists(select 1 from #syjbk_bak where isnull(A15C,'')='')
begin 
 INSERT #syjbk_error
 select  '国籍为空',A48
   from #syjbk_bak where isnull(A15C,'')=''
end 
--婚姻	A21C
if exists(select 1 from #syjbk_bak where isnull(A21C,'')='')
begin 
 INSERT #syjbk_error
 select  '婚姻为空',A48
   from #syjbk_bak where isnull(A21C,'')=''
end 
--职业	A38C
if exists(select 1 from #syjbk_bak where isnull(A38C,'')='')
begin 
 INSERT #syjbk_error
 select  '职业为空',A48
   from #syjbk_bak where isnull(A38C,'')=''
end 
--民族	A19C
if exists(select 1 from #syjbk_bak where isnull(A19C,'')='')
begin 
 INSERT #syjbk_error
 select  '民族为空',A48
   from #syjbk_bak where isnull(A19C,'')=''
end 
--身份证号	A20
if exists(select 1 from #syjbk_bak where isnull(A20,'')='')
begin 
 INSERT #syjbk_error
 select  '身份证号为空或者小于15位数',A48
   from #syjbk_bak where (isnull(A20,'')='' or LEN(A20)<15 )OR( LEN(A20) <18 AND LEN(A20)>15)
end 
--出生地址	A22
if exists(select 1 from #syjbk_bak where isnull(A22,'')='')
begin 
 INSERT #syjbk_error
 select  '出生地址为空',A48
   from #syjbk_bak where isnull(A22,'')=''
end 
--籍贯省（自治区、直辖市）	A23C
if exists(select 1 from #syjbk_bak where isnull(A23C,'')='')
begin 
 INSERT #syjbk_error
 select  '籍贯省（自治区、直辖市）为空',A48
   from #syjbk_bak where isnull(A23C,'')=''
end 

--户口地址	A24
if exists(select 1 from #syjbk_bak where isnull(A24,'')='')
begin 
 INSERT #syjbk_error
 select  '户口地址为空',A48
   from #syjbk_bak where isnull(A24,'')=''
end 
--户口地址邮政编码	A25C
if exists(select 1 from #syjbk_bak where isnull(A25C,'')='')
begin 
 INSERT #syjbk_error
 select  '户口地址邮政编码为空',A48
   from #syjbk_bak where isnull(A25C,'')=''
end 
--现住址	A26
if exists(select 1 from #syjbk_bak where isnull(A26,'')='')
begin 
 INSERT #syjbk_error
 select  '现住址为空',A48
   from #syjbk_bak where isnull(A26,'')=''
end 
--现住址电话	A27
if exists(select 1 from #syjbk_bak where isnull(A27,'')='')
begin 
 INSERT #syjbk_error
 select  '现住址电话为空',A48
   from #syjbk_bak where isnull(A27,'')=''
end 
--现住址邮政编码	A28C
if exists(select 1 from #syjbk_bak where isnull(A28C,'')='')
begin 
 INSERT #syjbk_error
 select  '现住址邮政编码为空',A48
   from #syjbk_bak where isnull(A28C,'')=''
end 
--工作单位及地址	A29
if exists(select 1 from #syjbk_bak where isnull(A29,'')='')
begin 
 INSERT #syjbk_error
 select  '工作单位及地址为空',A48
   from #syjbk_bak where isnull(A29,'')=''
end 
--工作单位电话	A30
if exists(select 1 from #syjbk_bak where isnull(A30,'')='')
begin 
 INSERT #syjbk_error
 select  '工作单位电话为空',A48
   from #syjbk_bak where isnull(A30,'')=''
end 
--工作单位邮政编码	A31C
if exists(select 1 from #syjbk_bak where isnull(A31C,'')='')
begin 
 INSERT #syjbk_error
 select  '工作单位邮政编码为空',A48
   from #syjbk_bak where isnull(A31C,'')=''
end 
--联系人姓名	A32
if exists(select 1 from #syjbk_bak where isnull(A32,'')='')
begin 
 INSERT #syjbk_error
 select  '联系人姓名为空',A48
   from #syjbk_bak where isnull(A32,'')=''
end 
--联系人关系	A33C
if exists(select 1 from #syjbk_bak where isnull(A33C,'')='')
begin 
 INSERT #syjbk_error
 select  '联系人关系为空',A48
   from #syjbk_bak where isnull(A33C,'')=''
end 
--联系人地址	A34
if exists(select 1 from #syjbk_bak where isnull(A34,'')='')
begin 
 INSERT #syjbk_error
 select  '联系人地址为空',A48
   from #syjbk_bak where isnull(A34,'')=''
end 

--联系人电话	A35
if exists(select 1 from #syjbk_bak where isnull(A35,'')='')
begin 
 INSERT #syjbk_error
 select  '联系人电话为空',A48
   from #syjbk_bak where isnull(A35,'')=''
end 
--入院途径	B11C
if exists(select 1 from #syjbk_bak where isnull(B11C,'')='')
begin 
 INSERT #syjbk_error
 select  '入院途径为空',A48
   from #syjbk_bak where isnull(B11C,'')=''
end 
--入院科别	B13C
if exists(select 1 from #syjbk_bak where isnull(B13C,'')='')
begin 
 INSERT #syjbk_error
 select  '入院科别为空',A48
   from #syjbk_bak where isnull(B13C,'')=''
end 
--入院病房	B14
if exists(select 1 from #syjbk_bak where isnull(B14,'')='')
begin 
 INSERT #syjbk_error
 select  '入院病房为空',A48
   from #syjbk_bak where isnull(B14,'')=''
end 
--出院科别	B16C
if exists(select 1 from #syjbk_bak where isnull(B16C,'')='')
begin 
 INSERT #syjbk_error
 select  '出院科别为空',A48
   from #syjbk_bak where isnull(B16C,'')=''
end 
--出院病房	B17
if exists(select 1 from #syjbk_bak where isnull(B17,'')='')
begin 
 INSERT #syjbk_error
 select  '出院病房为空',A48
   from #syjbk_bak where isnull(B17,'')=''
end 
--实际住院（天）	B20
if exists(select 1 from #syjbk_bak where isnull(B20,'')='')
begin 
 INSERT #syjbk_error
 select  '实际住院（天）为空',A48
   from #syjbk_bak where isnull(B20,'')=''
end
--门（急）诊诊断编码	C01C
if exists(select 1 from #syjbk_bak where isnull(C01C,'')='')
begin 
 INSERT #syjbk_error
 select  '门（急）诊诊断编码为空',A48
   from #syjbk_bak where isnull(C01C,'')=''
end
--门（急）诊诊断名称	C02N
if exists(select 1 from #syjbk_bak where isnull(C02N,'')='')
begin 
 INSERT #syjbk_error
 select  '门（急）诊诊断名称为空',A48
   from #syjbk_bak where isnull(C02N,'')=''
end
--出院主要诊断编码	C03C
if exists(select 1 from #syjbk_bak where isnull(C03C,'')='')
begin 
 INSERT #syjbk_error
 select  '出院主要诊断编码为空',A48
   from #syjbk_bak where isnull(C03C,'')=''
end
--出院主要诊断名称	C04N
if exists(select 1 from #syjbk_bak where isnull(C04N,'')='')
begin 
 INSERT #syjbk_error
 select  '出院主要诊断名称为空',A48
   from #syjbk_bak where isnull(C04N,'')=''
end
--出院主要诊断入院病情	C05C
if exists(select 1 from #syjbk_bak where isnull(C05C,'')='')
begin 
 INSERT #syjbk_error
 select  '出院主要诊断入院病情为空',A48
   from #syjbk_bak where isnull(C05C,'')=''
end
--有无药物过敏	C24C
if exists(select 1 from #syjbk_bak where isnull(C24C,'')='')
begin 
 INSERT #syjbk_error
 select  '有无药物过敏为空',A48
   from #syjbk_bak where isnull(C24C,'')=''
end
--科主任	B22
if exists(select 1 from #syjbk_bak where isnull(B22,'')='')
begin 
 INSERT #syjbk_error
 select  '科主任为空',A48
   from #syjbk_bak where isnull(B22,'')=''
end

--主（副主）任医师	B23
if exists(select 1 from #syjbk_bak where isnull(B23,'')='')
begin 
 INSERT #syjbk_error
 select  '主（副主）任医师为空',A48
   from #syjbk_bak where isnull(B23,'')=''
end
--主治医师	B24
if exists(select 1 from #syjbk_bak where isnull(B24,'')='')
begin 
 INSERT #syjbk_error
 select  '主治医师为空',A48
   from #syjbk_bak where isnull(B24,'')=''
end
--住院医师	B25
if exists(select 1 from #syjbk_bak where isnull(B25,'')='')
begin 
 INSERT #syjbk_error
 select  '住院医师为空',A48
   from #syjbk_bak where isnull(B25,'')=''
end
--责任护士	B26
if exists(select 1 from #syjbk_bak where isnull(B26,'')='')
begin 
 INSERT #syjbk_error
 select  '责任护士为空',A48
   from #syjbk_bak where isnull(B26,'')=''
end
--编码员	B29
if exists(select 1 from #syjbk_bak where isnull(B29,'')='')
begin 
 INSERT #syjbk_error
 select  '编码员为空',A48
   from #syjbk_bak where isnull(B29,'')=''
end
--ABO血型	C26C
if exists(select 1 from #syjbk_bak where isnull(C26C,'')='')
begin 
 INSERT #syjbk_error
 select  'ABO血型为空',A48
   from #syjbk_bak where isnull(C26C,'')=''
end
--Rh血型	C27C
if exists(select 1 from #syjbk_bak where isnull(C27C,'')='')
begin 
 INSERT #syjbk_error
 select  'Rh血型为空',A48
   from #syjbk_bak where isnull(C27C,'')=''
end
--主要手术操作编码	C14x01C
if exists(select 1 from #syjbk_bak where isnull(C14x01C,'')='')
begin 
 INSERT #syjbk_error
 select  '主要手术操作编码为空',A48
   from #syjbk_bak where isnull(C14x01C,'')=''
end
if exists(select 1 from #syjbk_bak where isnull(C14x01C,'')<>'' AND isnull(C14x01C,'')<>'-' and C14x01C NOT IN (SELECT FUPOPCODE FROM tupicd9set ))
begin 
 INSERT #syjbk_error
 select  '主要手术操作编码不在值域范围',A48
   from #syjbk_bak where isnull(C14x01C,'')<>'' AND isnull(C14x01C,'')<>'-' and C14x01C NOT IN (SELECT FUPOPCODE FROM tupicd9set )
end
--主要手术操作名称	C15x01N
if exists(select 1 from #syjbk_bak where isnull(C15x01N,'')='')
begin 
 INSERT #syjbk_error
 select  '主要手术操作名称为空',A48
   from #syjbk_bak where  isnull(C15x01N,'')='' 
end

if exists(select 1 from #syjbk_bak where isnull(C15x01N,'')<>'' AND  isnull(C15x01N,'')<>'-' AND C15x01N  NOT IN (SELECT FUPOPNAME FROM tupicd9set ))
begin 
 INSERT #syjbk_error
 select  '主要手术操作名称不在值域范围',A48
   from #syjbk_bak where isnull(C15x01N,'')<>'' AND  isnull(C15x01N,'')<>'-' AND C15x01N  NOT IN (SELECT FUPOPNAME FROM tupicd9set )
end
--主要手术操作日期	C16x01
if exists(select 1 from #syjbk_bak where isnull(C16x01,'')='')
begin 
 INSERT #syjbk_error
 select  '主要手术操作日期为空',A48
   from #syjbk_bak where isnull(C16x01,'')=''
end
--主要手术操作级别 C17x01
if exists(select 1 from #syjbk_bak where isnull(C16x01,'')<>'-' and isnull(C17x01,'')='')
begin 
 INSERT #syjbk_error
 select  '主要手术操作级别为空',A48
   from #syjbk_bak where isnull(C16x01,'')<>'-' and isnull(C17x01,'')=''
end

----主要手术操作术者 C18x01
--if exists(select 1 from #syjbk_bak where isnull(C16x01,'')<>'-' and isnull(C18x01,'')='')
--begin 
-- INSERT #syjbk_error
-- select  '主要手术操作术者',A48
--   from #syjbk_bak where isnull(C16x01,'')<>'-' and isnull(C18x01,'')=''
--end

----主要手术操作Ⅰ助 C19x01
--if exists(select 1 from #syjbk_bak where isnull(C16x01,'')<>'-' and isnull(C19x01,'')='')
--begin 
-- INSERT #syjbk_error
-- select  '主要手术操作Ⅰ助',A48
--   from #syjbk_bak where isnull(C16x01,'')<>'-' and isnull(C19x01,'')=''
--end
----主主要手术操作Ⅱ助C20x01
--if exists(select 1 from #syjbk_bak where isnull(C16x01,'')<>'-' and isnull(C20x01,'')='')
--begin 
-- INSERT #syjbk_error
-- select  '主要手术操作Ⅱ助',A48
--   from #syjbk_bak where isnull(C16x01,'')<>'-' and isnull(C20x01,'')=''
--end
----主要手术操作切口愈合等级 C21x01C
--if exists(select 1 from #syjbk_bak where isnull(C16x01,'')<>'-' and isnull(C21x01C,'')='')
--begin 
-- INSERT #syjbk_error
-- select  '主要手术操作切口愈合等级',A48
--   from #syjbk_bak where isnull(C16x01,'')<>'-' and isnull(C21x01C,'')=''
--end
----主要手术操作麻醉方式 C22x01C
--if exists(select 1 from #syjbk_bak where isnull(C16x01,'')<>'-' and isnull(C22x01C,'')='')
--begin 
-- INSERT #syjbk_error
-- select  '主要手术操作麻醉方式',A48
--   from #syjbk_bak where isnull(C16x01,'')<>'-' and isnull(C22x01C,'')=''
--end
----主要手术操作麻醉医师
--if exists(select 1 from #syjbk_bak where isnull(C16x01,'')<>'-' and isnull(C23x01,'')='')
--begin 
-- INSERT #syjbk_error
-- select  '主要手术操作麻醉医师',A48
--   from #syjbk_bak where isnull(C16x01,'')<>'-' and isnull(C23x01,'')=''
--end
--颅脑损伤患者入院前昏迷时间（天）	C28
if exists(select 1 from #syjbk_bak where isnull(C28,'')='')
begin 
 INSERT #syjbk_error
 select  '颅脑损伤患者入院前昏迷时间（天）为空',A48
   from #syjbk_bak where isnull(C28,'')=''
end
--颅脑损伤患者入院前昏迷时间(小时)	C29
if exists(select 1 from #syjbk_bak where isnull(C29,'')='')
begin 
 INSERT #syjbk_error
 select  '颅脑损伤患者入院前昏迷时间(小时)为空',A48
   from #syjbk_bak where isnull(C29,'')=''
end
--颅脑损伤患者入院前昏迷时间(分钟)	C30
if exists(select 1 from #syjbk_bak where isnull(C30,'')='')
begin 
 INSERT #syjbk_error
 select  '颅脑损伤患者入院前昏迷时间(分钟)为空',A48
   from #syjbk_bak where isnull(C30,'')=''
end

--颅脑损伤患者入院后昏迷时间（天）	C31
if exists(select 1 from #syjbk_bak where isnull(C31,'')='')
begin 
 INSERT #syjbk_error
 select  '颅脑损伤患者入院后昏迷时间（天）为空',A48
   from #syjbk_bak where isnull(C31,'')=''
end
--颅脑损伤患者入院后昏迷时间(小时)	C32
if exists(select 1 from #syjbk_bak where isnull(C32,'')='')
begin 
 INSERT #syjbk_error
 select  '颅脑损伤患者入院后昏迷时间(小时)为空',A48
   from #syjbk_bak where isnull(C32,'')=''
end
--颅脑损伤患者入院后昏迷时间(分钟)	C33
if exists(select 1 from #syjbk_bak where isnull(C33,'')='')
begin 
 INSERT #syjbk_error
 select  '颅脑损伤患者入院后昏迷时间(分钟)为空',A48
   from #syjbk_bak where isnull(C33,'')=''
end

--是否有出院31日内再住院计划	B36C
if exists(select 1 from #syjbk_bak where isnull(B36C,'')='')
begin 
 INSERT #syjbk_error
 select  '是否有出院31日内再住院计划为空',A48
   from #syjbk_bak where isnull(B36C,'')=''
end
--离院方式	B34C
if exists(select 1 from #syjbk_bak where isnull(B34C,'')='')
begin 
 INSERT #syjbk_error
 select  '离院方式为空',A48
   from #syjbk_bak where isnull(B34C,'')=''
end

--住院总费用	D01
--if exists(select 1 from #syjbk_bak where isnull(D01,'')='')
--begin 
-- INSERT #syjbk_error
-- select  '住院总费用为空',A48
--   from #syjbk_bak where isnull(D01,'')=''
--end

----住院总费用其中自付金额	D09
--if exists(select 1 from #syjbk_bak where isnull(D09,'')='')
--begin 
-- INSERT #syjbk_error
-- select  '住院总费用其中自付金额为空',A48
--   from #syjbk_bak where isnull(D09,'')=''
--end


DECLARE @i INT,@b INT
SELECT @i=COUNT(*) FROM TPATIENTVISIT a WHERE    a.fcydate>=@rq1 and a.fcydate<@rq2 and FCYDEPT not like '大公馆%' and  FCYDEPT not like '黄水%' and  FCYDEPT not like '三病区%'and  FCYDEPT not like '精神科%'  
	and FCYBS NOT LIKE '黄水%'  and  FCYBS not like '大公馆%' --ADD BY QGY 排除大公馆黄水数据病房
SELECT @b=COUNT(*) FROM #syjbk_bak b 
IF @i<>@b   
INSERT #syjbk_error 
SELECT  @i,@b 
-- --SELECT '数量不符','123' 

              
--IF EXISTS (SELECT 1 FROM #syjbk_error)
--SELECT a.*,b.FRYDEPT,b.FCYDEPT,FZYDOCT FROM #syjbk_error a 
--LEFT JOIN TPATIENTVISIT b on a.syxh=b.FPRN and b.FCYDATE>='20190101'
--ELSE
  SELECT * FROM #syjbk_bak 


SET QUOTED_IDENTIFIER OFF 

SET QUOTED_IDENTIFIER OFF 


