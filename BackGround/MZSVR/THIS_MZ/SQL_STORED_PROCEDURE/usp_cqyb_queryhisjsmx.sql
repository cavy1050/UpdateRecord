if exists(select 1 from sysobjects where name = 'usp_cqyb_queryhisjsmx')
  drop proc usp_cqyb_queryhisjsmx
GO

Create proc usp_cqyb_queryhisjsmx
(
    @opertype   varchar(20),    --操作类别  'GetHisDetail'--获取His明细；         'SaveYbDetail'--保存东软医保明细    --'GetYbDetail'--获取His明细；
	                            --          'GetYbExcept'--获取医保端多出流水；   'GetHisExcept'--获取his端多出流水 
	                            --          'GetYbSum'--获取医保合计              'GetYbExceptSum'--获取医保异常合计
								--           
	@kssj		varchar(30),   
	@jssj		varchar(30),    
	@xzlb		varchar(1), 
	@cblb		varchar(1),
	@mzzy		varchar(3),     --1门诊  2住院 ,0不区分门诊住院(万达用)
	@ddyljgbm	varchar(10),    --医院医保代码  yy_jbconfig.yydm
	@str        varchar(8000),  --医保明细信息  单条内'|'  分隔     分多条'$'分隔
	@wkdz       varchar(30),    --网卡地址
	@czyh       varchar(10),     --操作用户
	@ydybbz     VARCHAR(3)      --异地医保标志 0市医保，1异地医保
)   
as 
/****************************************
[版本号]4.0.0.0.0
[创建时间]2017.05.15
[作者]qfj
[版权]Copyright ? 1998-2017卫宁健康科技集团股份有限公司
[描述]HIS医保对账明细查询
[功能说明]
	HIS医保对账明细查询
[参数说明]
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]

   exec usp_cqyb_queryhisjsmx 'GetHisDetail','2018050100:00:00','2018050123:59:59','1','2','1','10017','','wkdz','czyh'
   EXEC  usp_cqyb_queryhisjsmx 'GetHisDetail', '2018050100:00:00', '2018050123:59:59', '1', '1', '2', '10017', '', 'C85B7673516A','00','0'
[修改记录] 
****************************************/
set nocount on 

declare 
    @cq01Config VARCHAR(10) --重庆市医保接口开发商：DR-东软；WD-万达
	,@YbTableName varchar(50)   --医保数据全局临时表
	,@YbExceptName VARCHAR(50)  --医保异常结果
	,@HistableName VARCHAR(50)  --His数据全局临时表
	,@HisTempTable VARCHAR(50)  --his数据临时表
    ,@seq VARCHAR(1)
	,@seqRow VARCHAR(1)
    ,@strSql VARCHAR(2000)
	,@cq18Config VARCHAR(10)
	,@rowcount NUMERIC(3)
    ,@rowStr VARCHAR(1000)
	,@row NUMERIC(3)

SELECT @YbTableName = '##Yb' + @wkdz + @czyh , @HistableName = '##His' + @wkdz + @czyh
SELECT @seq = '|',@seqRow = '$'

SELECT @cq01Config = a.config FROM YY_CONFIG a WHERE a.id = 'CQ01'
IF @cq01Config <> 'DR' and @cq01Config <> 'WD' 
BEGIN
    SELECT 'F','CQ01参数配置不正确！' +@cq01Config
    RETURN
END

SELECT @cq18Config = a.config FROM YY_CONFIG a WHERE a.id = 'CQ18'
IF ISNULL(@cq18Config,'') = '' 
BEGIN
    SELECT 'F','CQ18参数配置不正确！' +@cq18Config
    RETURN
END

IF @opertype = 'GetHisDetail'
BEGIN
	if exists(select 1 from tempdb..sysobjects where name = @HistableName)
	begin
		EXEC('DROP TABLE ' + @HistableName)
	END
	IF @mzzy = '1' --门诊
	BEGIN
		SELECT @HisTempTable = '#HisMzTempTable'

		SELECT * INTO #HisMzTempTable FROM (
			SELECT a.jssjh 收据号,a.zxlsh 中心流水号,a.xzlb 险种类别,jzjl.cblb 参保类别, 
					CASE jzjl.cblb WHEN '2' THEN jzjl.jmyllb ELSE jzjl.zgyllb END 医疗类别 
					,b.sfrq 收费日期, b.czyh 操作员,b.hzxm 姓名,b.blh 病历号,jzjl.sbkh 社保卡号, 
					CASE b.jlzt WHEN 0 THEN '正常' WHEN 1 THEN '退费' WHEN 2 THEN '红冲' end 记录状态
				FROM VW_CQYB_MZJSJLK a(nolock), VW_CQYB_MZJZJLK jzjl(nolock),VW_MZBRJSK b(nolock),YY_YBFLK c(NOLOCK) 
				where a.jssjh = b.sjh 
				AND a.ddyljgbm = @ddyljgbm 
				AND ( (jzjl.sbkh NOT LIKE '#%' AND @ydybbz = '0') OR (jzjl.sbkh LIKE '#%' AND @ydybbz = '1') ) 
				AND jzjl.jssjh = a.jssjh 
				AND b.ybjszt = '2'  
				AND b.jlzt <> '2'
				AND jzjl.jlzt in (1,2) 
				AND b.ybdm = c.ybdm
				AND c.ybjkid = @cq18Config
				AND b.sfrq >= @kssj  
				AND b.sfrq <= @jssj 
				AND (
						( '1' = @xzlb AND  jzjl.xzlb = @xzlb  and  jzjl.cblb = @cblb )
					OR ( '2' = @xzlb AND jzjl.xzlb = @xzlb)
					OR ( '3' = @xzlb AND jzjl.xzlb = @xzlb )
					)
				union all 
				SELECT b.sjh 收据号,a.czlsh 中心流水号,a.xzlb 险种类别,jzjl.cblb 参保类别, 
					CASE jzjl.cblb WHEN '2' THEN jzjl.jmyllb ELSE jzjl.zgyllb END 医疗类别, 
					b.sfrq 收费日期, b.czyh 操作员,b.hzxm 姓名,b.blh 病历号,jzjl.sbkh 社保卡号, 
					CASE b.jlzt WHEN 0 THEN '正常' WHEN 1 THEN '退费' WHEN 2 THEN '红冲' end 记录状态  
				FROM VW_CQYB_MZJSJLK a(nolock), VW_CQYB_MZJZJLK jzjl(nolock),VW_MZBRJSK b(nolock),YY_YBFLK c(NOLOCK) 
				where a.jssjh = b.tsjh  
				AND a.ddyljgbm = @ddyljgbm 
				AND ( (jzjl.sbkh NOT LIKE '#%' AND @ydybbz = '0') OR (jzjl.sbkh LIKE '#%' AND @ydybbz = '1') ) 
				AND jzjl.jssjh = a.jssjh 
				AND b.ybdm = c.ybdm
				AND c.ybjkid = @cq18Config
				AND b.ybjszt = '2' 
				AND b.jlzt = '2'
				AND jzjl.jlzt in (1,2)  
				AND b.sfrq >= @kssj 
				AND b.sfrq <= @jssj  
				AND (
						( '1' = @xzlb AND  jzjl.xzlb = @xzlb  and  jzjl.cblb = @cblb )
					OR ( '2' = @xzlb AND jzjl.xzlb = @xzlb)
					OR ( '3' = @xzlb AND jzjl.xzlb = @xzlb )
					) 
		) aa  		

	END
	ELSE IF @mzzy = '2' --住院
	BEGIN
		    SELECT @HisTempTable = '#HisZyTempTable'

		    SELECT * INTO #HisZyTempTable FROM (
				SELECT b.fph 发票号,a.zxlsh 中心流水号,a.xzlb 险种类别,jzjl.cblb 参保类别,  
					CASE jzjl.cblb WHEN '2' THEN jzjl.jmyllb ELSE jzjl.zgyllb END 医疗类别, 
					b.jsrq 收费日期, b.jsczyh 操作员,b.hzxm 姓名,b.blh 病历号,jzjl.sbkh 社保卡号,
					CASE b.jlzt WHEN 0 THEN '正常' WHEN 1 THEN '红冲' WHEN 2 THEN '被红冲' end 记录状态 
				FROM YY_CQYB_ZYJSJLK a(nolock), YY_CQYB_ZYJZJLK jzjl(nolock),ZY_BRJSK b(nolock),YY_YBFLK c(NOLOCK)
				where a.jsxh = b.xh AND a.ddyljgbm = @ddyljgbm  
				AND ( (jzjl.sbkh NOT LIKE '#%' AND @ydybbz = '0') OR (jzjl.sbkh LIKE '#%' AND @ydybbz = '1') )
				AND a.syxh = b.syxh  
				AND jzjl.jzlsh = a.jzlsh 
				AND b.ybjszt = '2'
				AND b.jlzt <> '1'
				AND b.ybdm = c.ybdm
				AND c.ybjkid = @cq18Config
				AND b.jsrq >= @kssj 
				AND b.jsrq <= @jssj
				AND (
						( '1' = @xzlb AND  jzjl.xzlb = @xzlb  and  jzjl.cblb = @cblb )
						OR ( '2' = @xzlb AND jzjl.xzlb = @xzlb)
						OR ( '3' = @xzlb AND jzjl.xzlb = @xzlb )
						)
				union all
			SELECT b.fph 发票号,a.czlsh 中心流水号,a.xzlb 险种类别,jzjl.cblb 参保类别, 
					CASE jzjl.cblb WHEN '2' THEN jzjl.jmyllb ELSE jzjl.zgyllb END 医疗类别 , 
					b.jsrq 收费日期, b.jsczyh 操作员,b.hzxm 姓名,b.blh 病历号,jzjl.sbkh 社保卡号, 
					CASE b.jlzt WHEN 0 THEN '正常' WHEN 1 THEN '红冲' WHEN 2 THEN '被红冲' end 记录状态 
				FROM YY_CQYB_ZYJSJLK a(nolock), YY_CQYB_ZYJZJLK jzjl(nolock),ZY_BRJSK b(nolock),YY_YBFLK c(NOLOCK)
				WHERE a.jsxh = b.hcxh                                
				and a.ddyljgbm = @ddyljgbm  
				AND ( (jzjl.sbkh NOT LIKE '#%' AND @ydybbz = '0') OR (jzjl.sbkh LIKE '#%' AND @ydybbz = '1') )
				AND a.syxh = b.syxh 
				AND jzjl.jzlsh = a.jzlsh  
				AND b.ybjszt = '2'
				AND b.jlzt = '1'
				AND b.ybdm = c.ybdm
				AND c.ybjkid = @cq18Config
				AND b.jsrq >= @kssj
				AND b.jsrq <= @jssj
				AND ( 
						( '1' = @xzlb AND  jzjl.xzlb = @xzlb  and  jzjl.cblb = @cblb )
						OR ( '2' = @xzlb AND jzjl.xzlb = @xzlb)
						OR ( '3' = @xzlb AND jzjl.xzlb = @xzlb )
					)
			) aa
	END	
	else if @mzzy='0' --门诊住院合并(万达用)
	begin
		 SELECT @HisTempTable = '#HisMzZyTempTable'
	    SELECT * INTO #HisMzZyTempTable FROM (
			SELECT a.jssjh 收据号,a.zxlsh 中心流水号,a.xzlb 险种类别,jzjl.cblb 参保类别, 
					CASE jzjl.cblb WHEN '2' THEN jzjl.jmyllb ELSE jzjl.zgyllb END 医疗类别 
					,b.sfrq 收费日期, b.czyh 操作员,b.hzxm 姓名,b.blh 病历号,jzjl.sbkh 社保卡号, 
					CASE b.jlzt WHEN 0 THEN '正常' WHEN 1 THEN '退费' WHEN 2 THEN '红冲' end 记录状态,'门诊' 类别
				FROM VW_CQYB_MZJSJLK a(nolock), VW_CQYB_MZJZJLK jzjl(nolock),VW_MZBRJSK b(nolock),YY_YBFLK c(NOLOCK) 
				where a.jssjh = b.sjh 
				AND a.ddyljgbm = @ddyljgbm 
				AND ( (jzjl.sbkh NOT LIKE '#%' AND @ydybbz = '0') OR (jzjl.sbkh LIKE '#%' AND @ydybbz = '1') )
				AND jzjl.jssjh = a.jssjh 
				AND b.ybjszt = '2'  
				AND b.jlzt <> '2' 
				AND b.ybdm = c.ybdm
				AND c.ybjkid = @cq18Config
				AND b.sfrq >= @kssj  
				AND b.sfrq <= @jssj 
				AND (
						( '1' = @xzlb AND  jzjl.xzlb = @xzlb  and  jzjl.cblb = @cblb )
					OR ( '2' = @xzlb AND jzjl.xzlb = @xzlb)
					OR ( '3' = @xzlb AND jzjl.xzlb = @xzlb )
					)
				union all 
				SELECT b.sjh 收据号,a.czlsh 中心流水号,a.xzlb 险种类别,jzjl.cblb 参保类别, 
					CASE jzjl.cblb WHEN '2' THEN jzjl.jmyllb ELSE jzjl.zgyllb END 医疗类别, 
					b.sfrq 收费日期, b.czyh 操作员,b.hzxm 姓名,b.blh 病历号,jzjl.sbkh 社保卡号, 
					CASE b.jlzt WHEN 0 THEN '正常' WHEN 1 THEN '退费' WHEN 2 THEN '红冲' end 记录状态,'门诊' 类别
				FROM VW_CQYB_MZJSJLK a(nolock), VW_CQYB_MZJZJLK jzjl(nolock),VW_MZBRJSK b(nolock),YY_YBFLK c(NOLOCK) 
				where a.jssjh = b.tsjh  
				AND a.ddyljgbm = @ddyljgbm 
				AND ( (jzjl.sbkh NOT LIKE '#%' AND @ydybbz = '0') OR (jzjl.sbkh LIKE '#%' AND @ydybbz = '1') ) 
				AND jzjl.jssjh = a.jssjh 
				AND b.ybdm = c.ybdm
				AND c.ybjkid = @cq18Config
				AND b.ybjszt = '2' 
				AND b.jlzt = '2'  
				AND b.sfrq >= @kssj 
				AND b.sfrq <= @jssj  
				AND (
						( '1' = @xzlb AND  jzjl.xzlb = @xzlb  and  jzjl.cblb = @cblb )
					OR ( '2' = @xzlb AND jzjl.xzlb = @xzlb)
					OR ( '3' = @xzlb AND jzjl.xzlb = @xzlb )
					) 
		) aa  	
		
		Insert INTO #HisMzZyTempTable select * FROM (
				SELECT b.fph 发票号,a.zxlsh 中心流水号,a.xzlb 险种类别,jzjl.cblb 参保类别,  
					CASE jzjl.cblb WHEN '2' THEN jzjl.jmyllb ELSE jzjl.zgyllb END 医疗类别, 
					b.jsrq 收费日期, b.jsczyh 操作员,b.hzxm 姓名,b.blh 病历号,jzjl.sbkh 社保卡号,
					CASE b.jlzt WHEN 0 THEN '正常' WHEN 1 THEN '红冲' WHEN 2 THEN '被红冲' end 记录状态,'住院' 类别 
				FROM YY_CQYB_ZYJSJLK a(nolock), YY_CQYB_ZYJZJLK jzjl(nolock),ZY_BRJSK b(nolock),YY_YBFLK c(NOLOCK)
				where a.jsxh = b.xh AND a.ddyljgbm = @ddyljgbm  
				AND ( (jzjl.sbkh NOT LIKE '#%' AND @ydybbz = '0') OR (jzjl.sbkh LIKE '#%' AND @ydybbz = '1') )
				AND a.syxh = b.syxh  
				AND jzjl.jzlsh = a.jzlsh 
				AND b.ybjszt = '2'
				AND b.jlzt <> '1'
				AND b.ybdm = c.ybdm
				AND c.ybjkid = @cq18Config
				AND b.jsrq >= @kssj 
				AND b.jsrq <= @jssj
				AND (
						( '1' = @xzlb AND  jzjl.xzlb = @xzlb  and  jzjl.cblb = @cblb )
						OR ( '2' = @xzlb AND jzjl.xzlb = @xzlb)
						OR ( '3' = @xzlb AND jzjl.xzlb = @xzlb )
						)
				union all
			SELECT b.fph 发票号,a.czlsh 中心流水号,a.xzlb 险种类别,jzjl.cblb 参保类别, 
					CASE jzjl.cblb WHEN '2' THEN jzjl.jmyllb ELSE jzjl.zgyllb END 医疗类别 , 
					b.jsrq 收费日期, b.jsczyh 操作员,b.hzxm 姓名,b.blh 病历号,jzjl.sbkh 社保卡号, 
					CASE b.jlzt WHEN 0 THEN '正常' WHEN 1 THEN '红冲' WHEN 2 THEN '被红冲' end 记录状态,'住院' 类别  
				FROM YY_CQYB_ZYJSJLK a(nolock), YY_CQYB_ZYJZJLK jzjl(nolock),ZY_BRJSK b(nolock),YY_YBFLK c(NOLOCK)
				WHERE a.jsxh = b.hcxh                                
				and a.ddyljgbm = @ddyljgbm  
				AND ( (jzjl.sbkh NOT LIKE '#%' AND @ydybbz = '0') OR (jzjl.sbkh LIKE '#%' AND @ydybbz = '1') )
				AND a.syxh = b.syxh 
				AND jzjl.jzlsh = a.jzlsh  
				AND b.ybjszt = '2'
				AND b.jlzt = '1'
				AND b.ybdm = c.ybdm
				AND c.ybjkid = @cq18Config
				AND b.jsrq >= @kssj
				AND b.jsrq <= @jssj
				AND ( 
						( '1' = @xzlb AND  jzjl.xzlb = @xzlb  and  jzjl.cblb = @cblb )
						OR ( '2' = @xzlb AND jzjl.xzlb = @xzlb)
						OR ( '3' = @xzlb AND jzjl.xzlb = @xzlb )
					)
			) aa	
	end
		
	--将his临时表数据转入his全局临时表
	EXEC('select * INTO '+@HistableName+' from ' + @HisTempTable )
	--返回His结果
	exec('SELECT * FROM '+ @HistableName + ' order by 收费日期')

	--处理医保表部分  ，先创建医保临时表
	if exists(select 1 from tempdb..sysobjects where name = @YbTableName)
	begin
		EXEC('drop TABLE '+ @YbTableName)
    END
	
	IF @cq01Config = 'DR'
	begin
		EXEC('create table '+ @YbTableName    +         
			'(   中心流水号  VARCHAR(18) ,         '+
			'    姓名        VARCHAR(30),          '+
			'    住院门诊号  VARCHAR(18) ,         '+
			'    医疗类别    VARCHAR(30),          '+
			'    总金额      numeric(12,2),        '+
			'    统筹        numeric(12,2),        '+
			'    账户支付    numeric(12,2),        '+
			'    账户抵用    numeric(12,2),        '+
			'    大额理赔    numeric(12,2),        '+
			'    公务员补助  numeric(12,2),        '+
			'    公务员返还  numeric(12,2),        '+
			'    现金支付    numeric(12,2),      '+
			'    结算日期    datetime ,          '+
			'    退中心流水号 VARCHAR(18),       '+
			'    退标志       VARCHAR(10),       '+
			'    符合医保范围 numeric(12,2),     '+
			'    行政区划     VARCHAR(14) ,      '+
			'    参保类别     VARCHAR(3),        '+
			'    险种类别     VARCHAR(3),        '+
			'    社会保障号   VARCHAR(20)  ) ')
	END
    ELSE
    BEGIN
        EXEC('create table '+ @YbTableName    +         
				'(  中心流水号  VARCHAR(18) ,         '+
				'   总金额      numeric(12,2),        '+
				'   住院门诊号  VARCHAR(18) ) ');
	END
end
else if @opertype = 'SaveYbDetail'
BEGIN
    SELECT @rowcount = DATALENGTH(@str)-datalength(replace(@str,@seqRow,'')) + 1
    
	SELECT @row = 1 
	WHILE(@row <= @rowcount)
	BEGIN
		SELECT @rowStr = dbo.fun_cqyb_getvalbyseq(@str,@seqRow,@row)
		--PRINT CONVERT(VARCHAR(10),@row) +'----'+ @rowStr
		if @cq01Config = 'DR'
		begin
			SELECT @strSql = 'insert into '+@YbTableName
			+' values("' +dbo.fun_cqyb_getvalbyseq(@rowStr,@seq,1)+'","'
						 +dbo.fun_cqyb_getvalbyseq(@rowStr,@seq,2)+'","'
						 +dbo.fun_cqyb_getvalbyseq(@rowStr,@seq,3)+'","'
						 +dbo.fun_cqyb_getvalbyseq(@rowStr,@seq,4)+'","'
						 +dbo.fun_cqyb_getvalbyseq(@rowStr,@seq,5)+'","'
						 +dbo.fun_cqyb_getvalbyseq(@rowStr,@seq,6)+'","'
						 +dbo.fun_cqyb_getvalbyseq(@rowStr,@seq,7)+'","'
						 +dbo.fun_cqyb_getvalbyseq(@rowStr,@seq,8)+'","'
						 +dbo.fun_cqyb_getvalbyseq(@rowStr,@seq,9)+'","'
						 +dbo.fun_cqyb_getvalbyseq(@rowStr,@seq,10)+'","'
						 +dbo.fun_cqyb_getvalbyseq(@rowStr,@seq,11)+'","'
						 +dbo.fun_cqyb_getvalbyseq(@rowStr,@seq,12)+'","'
						 +dbo.fun_cqyb_getvalbyseq(@rowStr,@seq,13)+'","'
						 +dbo.fun_cqyb_getvalbyseq(@rowStr,@seq,14)+'","'
						 +dbo.fun_cqyb_getvalbyseq(@rowStr,@seq,15)+'","'
						 +dbo.fun_cqyb_getvalbyseq(@rowStr,@seq,16)+'","'
						 +dbo.fun_cqyb_getvalbyseq(@rowStr,@seq,17)+'","'
						 +dbo.fun_cqyb_getvalbyseq(@rowStr,@seq,18)+'","'
						 +dbo.fun_cqyb_getvalbyseq(@rowStr,@seq,19)+'","'
						 +dbo.fun_cqyb_getvalbyseq(@rowStr,@seq,20)+'")'
	  
		END
		ELSE IF @cq01Config = 'WD'
		begin
			SELECT @strSql = 'insert into '+@YbTableName
							+' values("' +dbo.fun_cqyb_getvalbyseq(@rowStr,@seq,1)+'","'
										 +dbo.fun_cqyb_getvalbyseq(@rowStr,@seq,2)+'","'
										 +dbo.fun_cqyb_getvalbyseq(@rowStr,@seq,3)+'")'
		end
	
		exec(@strSql)

		if @@error<>0 or @@rowcount = 0 
		begin
			select 'F','插入临时表时出错!'
			return
		END
        SELECT @row = @row + 1,@rowStr = ''
	end
	SELECT 'T',''
END
ELSE IF @opertype = 'GetYbDetail'
BEGIN
    EXEC('SELECT * FROM '+@YbTableName)
end
else if @opertype = 'GetYbExcept'
BEGIN
    
    IF @cq01Config = 'DR'
	BEGIN
	    SELECT @YbExceptName = '#YbExceptTable'
        CREATE table  #YbExceptTable           
			 (   中心流水号  VARCHAR(18) ,         
			     姓名        VARCHAR(30),           
			     住院门诊号  VARCHAR(18) ,        
			     医疗类别    VARCHAR(3),            
			     总金额      numeric(12,2),         
			     统筹        numeric(12,2),       
			     账户支付    numeric,             
			     账户抵用    numeric,             
			     大额理赔    numeric(12,2),       
			     公务员补助  numeric,             
			     公务员返还  numeric,            
			     现金支付    numeric(12,2),       
			     结算日期    datetime ,          
			     退中心流水号 VARCHAR(18),        
			     退标志       VARCHAR(4),         
			     符合医保范围 numeric(12,2),      
			     行政区划     VARCHAR(14) ,       
			     参保类别     VARCHAR(3),          
		         险种类别     VARCHAR(3),          
			     社会保障号   VARCHAR(20)  )  
		
	end 
	ELSE 
	BEGIN
        SELECT @YbExceptName = '#YbExceptTableWD'
		create table  #YbExceptTableWD             
				(  中心流水号  VARCHAR(18) ,         
				   总金额      numeric(12,2),        
				   住院门诊号  VARCHAR(18) )
	end
	
	SELECT @strSql = 'insert into '+@YbExceptName+' SELECT a.* from ' + @YbTableName + ' a WHERE NOT EXISTS (select 1 from ' + @HistableName + ' b WHERE a.中心流水号 = b.中心流水号) '
    EXEC(@strSql)

	IF @cq01Config = 'DR'
	BEGIN
         exec('SELECT * FROM ' + @YbExceptName)
	END
	ELSE
    begin
		SELECT @strSql = 'select * from ' + @YbExceptName 
		EXEC(@strSql)
	END
END
else if @opertype = 'GetHisExcept'
begin
	SELECT @strSql = 'SELECT a.* from ' + @HistableName + ' a WHERE NOT EXISTS (select 1 from ' + @YbTableName + ' b WHERE a.中心流水号 = b.中心流水号) '
    exec(@strSql)
END
ELSE IF @opertype = 'GetYbSum'
BEGIN
    IF @cq01Config = 'DR'
	BEGIN
	    SELECT @strSql = 'select "合计" 合计,sum(总金额) 总金额,sum(统筹) 统筹,sum(账户支付) 账户支付,sum(账户抵用) 账户抵用,sum(大额理赔) 大额, '
		               + ' SUM(公务员补助) 公务员补助,sum(公务员返还) 公务员返还 from '+ @YbTableName
	END
	ELSE
	BEGIN
	    SELECT @strSql = 'select "合计" 合计 ,sum(总金额) 总金额 from '+ @YbTableName
	END
	exec(@strSql)
end
ELSE IF @opertype = 'GetYbExceptSum'
BEGIN
    IF @cq01Config = 'DR'
	BEGIN
	    SELECT @strSql = 'select "合计" as 合计 ,sum(a.总金额) 总金额,sum(a.统筹) 统筹,sum(a.账户支付) 账户支付,sum(a.账户抵用) 账户抵用,sum(a.大额理赔) 大额,'
		               + 'SUM(a.公务员补助) 公务员补助,sum(a.公务员返还) 公务员返还  '
	                   + ' from ' +@YbTableName + ' a where  not EXISTS (select 1 from ' + @HistableName + ' b where a.中心流水号 = b.中心流水号)'
	END
	ELSE
	BEGIN
	    SELECT @strSql = 'select "合计" as 合计 ,sum(a.总金额) 总金额 from '+ @YbTableName + ' a '
		               + 'WHERE not EXISTS (select 1 from ' + @HistableName + ' b where a.中心流水号 = b.中心流水号)'
	END
	exec(@strSql)
end    

return
GO
