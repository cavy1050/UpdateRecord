if exists(select 1 from sysobjects where name = 'usp_cqyb_queryhisjsmx')
  drop proc usp_cqyb_queryhisjsmx
GO

Create proc usp_cqyb_queryhisjsmx
(
    @opertype   varchar(20),    --�������  'GetHisDetail'--��ȡHis��ϸ��         'SaveYbDetail'--���涫��ҽ����ϸ    --'GetYbDetail'--��ȡHis��ϸ��
	                            --          'GetYbExcept'--��ȡҽ���˶����ˮ��   'GetHisExcept'--��ȡhis�˶����ˮ 
	                            --          'GetYbSum'--��ȡҽ���ϼ�              'GetYbExceptSum'--��ȡҽ���쳣�ϼ�
								--           
	@kssj		varchar(30),   
	@jssj		varchar(30),    
	@xzlb		varchar(1), 
	@cblb		varchar(1),
	@mzzy		varchar(3),     --1����  2סԺ ,0����������סԺ(�����)
	@ddyljgbm	varchar(10),    --ҽԺҽ������  yy_jbconfig.yydm
	@str        varchar(8000),  --ҽ����ϸ��Ϣ  ������'|'  �ָ�     �ֶ���'$'�ָ�
	@wkdz       varchar(30),    --������ַ
	@czyh       varchar(10),     --�����û�
	@ydybbz     VARCHAR(3)      --���ҽ����־ 0��ҽ����1���ҽ��
)   
as 
/****************************************
[�汾��]4.0.0.0.0
[����ʱ��]2017.05.15
[����]qfj
[��Ȩ]Copyright ? 1998-2017���������Ƽ����Źɷ����޹�˾
[����]HISҽ��������ϸ��ѯ
[����˵��]
	HISҽ��������ϸ��ѯ
[����˵��]
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��]

   exec usp_cqyb_queryhisjsmx 'GetHisDetail','2018050100:00:00','2018050123:59:59','1','2','1','10017','','wkdz','czyh'
   EXEC  usp_cqyb_queryhisjsmx 'GetHisDetail', '2018050100:00:00', '2018050123:59:59', '1', '1', '2', '10017', '', 'C85B7673516A','00','0'
[�޸ļ�¼] 
****************************************/
set nocount on 

declare 
    @cq01Config VARCHAR(10) --������ҽ���ӿڿ����̣�DR-����WD-���
	,@YbTableName varchar(50)   --ҽ������ȫ����ʱ��
	,@YbExceptName VARCHAR(50)  --ҽ���쳣���
	,@HistableName VARCHAR(50)  --His����ȫ����ʱ��
	,@HisTempTable VARCHAR(50)  --his������ʱ��
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
    SELECT 'F','CQ01�������ò���ȷ��' +@cq01Config
    RETURN
END

SELECT @cq18Config = a.config FROM YY_CONFIG a WHERE a.id = 'CQ18'
IF ISNULL(@cq18Config,'') = '' 
BEGIN
    SELECT 'F','CQ18�������ò���ȷ��' +@cq18Config
    RETURN
END

IF @opertype = 'GetHisDetail'
BEGIN
	if exists(select 1 from tempdb..sysobjects where name = @HistableName)
	begin
		EXEC('DROP TABLE ' + @HistableName)
	END
	IF @mzzy = '1' --����
	BEGIN
		SELECT @HisTempTable = '#HisMzTempTable'

		SELECT * INTO #HisMzTempTable FROM (
			SELECT a.jssjh �վݺ�,a.zxlsh ������ˮ��,a.xzlb �������,jzjl.cblb �α����, 
					CASE jzjl.cblb WHEN '2' THEN jzjl.jmyllb ELSE jzjl.zgyllb END ҽ����� 
					,b.sfrq �շ�����, b.czyh ����Ա,b.hzxm ����,b.blh ������,jzjl.sbkh �籣����, 
					CASE b.jlzt WHEN 0 THEN '����' WHEN 1 THEN '�˷�' WHEN 2 THEN '���' end ��¼״̬
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
				SELECT b.sjh �վݺ�,a.czlsh ������ˮ��,a.xzlb �������,jzjl.cblb �α����, 
					CASE jzjl.cblb WHEN '2' THEN jzjl.jmyllb ELSE jzjl.zgyllb END ҽ�����, 
					b.sfrq �շ�����, b.czyh ����Ա,b.hzxm ����,b.blh ������,jzjl.sbkh �籣����, 
					CASE b.jlzt WHEN 0 THEN '����' WHEN 1 THEN '�˷�' WHEN 2 THEN '���' end ��¼״̬  
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
	ELSE IF @mzzy = '2' --סԺ
	BEGIN
		    SELECT @HisTempTable = '#HisZyTempTable'

		    SELECT * INTO #HisZyTempTable FROM (
				SELECT b.fph ��Ʊ��,a.zxlsh ������ˮ��,a.xzlb �������,jzjl.cblb �α����,  
					CASE jzjl.cblb WHEN '2' THEN jzjl.jmyllb ELSE jzjl.zgyllb END ҽ�����, 
					b.jsrq �շ�����, b.jsczyh ����Ա,b.hzxm ����,b.blh ������,jzjl.sbkh �籣����,
					CASE b.jlzt WHEN 0 THEN '����' WHEN 1 THEN '���' WHEN 2 THEN '�����' end ��¼״̬ 
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
			SELECT b.fph ��Ʊ��,a.czlsh ������ˮ��,a.xzlb �������,jzjl.cblb �α����, 
					CASE jzjl.cblb WHEN '2' THEN jzjl.jmyllb ELSE jzjl.zgyllb END ҽ����� , 
					b.jsrq �շ�����, b.jsczyh ����Ա,b.hzxm ����,b.blh ������,jzjl.sbkh �籣����, 
					CASE b.jlzt WHEN 0 THEN '����' WHEN 1 THEN '���' WHEN 2 THEN '�����' end ��¼״̬ 
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
	else if @mzzy='0' --����סԺ�ϲ�(�����)
	begin
		 SELECT @HisTempTable = '#HisMzZyTempTable'
	    SELECT * INTO #HisMzZyTempTable FROM (
			SELECT a.jssjh �վݺ�,a.zxlsh ������ˮ��,a.xzlb �������,jzjl.cblb �α����, 
					CASE jzjl.cblb WHEN '2' THEN jzjl.jmyllb ELSE jzjl.zgyllb END ҽ����� 
					,b.sfrq �շ�����, b.czyh ����Ա,b.hzxm ����,b.blh ������,jzjl.sbkh �籣����, 
					CASE b.jlzt WHEN 0 THEN '����' WHEN 1 THEN '�˷�' WHEN 2 THEN '���' end ��¼״̬,'����' ���
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
				SELECT b.sjh �վݺ�,a.czlsh ������ˮ��,a.xzlb �������,jzjl.cblb �α����, 
					CASE jzjl.cblb WHEN '2' THEN jzjl.jmyllb ELSE jzjl.zgyllb END ҽ�����, 
					b.sfrq �շ�����, b.czyh ����Ա,b.hzxm ����,b.blh ������,jzjl.sbkh �籣����, 
					CASE b.jlzt WHEN 0 THEN '����' WHEN 1 THEN '�˷�' WHEN 2 THEN '���' end ��¼״̬,'����' ���
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
				SELECT b.fph ��Ʊ��,a.zxlsh ������ˮ��,a.xzlb �������,jzjl.cblb �α����,  
					CASE jzjl.cblb WHEN '2' THEN jzjl.jmyllb ELSE jzjl.zgyllb END ҽ�����, 
					b.jsrq �շ�����, b.jsczyh ����Ա,b.hzxm ����,b.blh ������,jzjl.sbkh �籣����,
					CASE b.jlzt WHEN 0 THEN '����' WHEN 1 THEN '���' WHEN 2 THEN '�����' end ��¼״̬,'סԺ' ��� 
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
			SELECT b.fph ��Ʊ��,a.czlsh ������ˮ��,a.xzlb �������,jzjl.cblb �α����, 
					CASE jzjl.cblb WHEN '2' THEN jzjl.jmyllb ELSE jzjl.zgyllb END ҽ����� , 
					b.jsrq �շ�����, b.jsczyh ����Ա,b.hzxm ����,b.blh ������,jzjl.sbkh �籣����, 
					CASE b.jlzt WHEN 0 THEN '����' WHEN 1 THEN '���' WHEN 2 THEN '�����' end ��¼״̬,'סԺ' ���  
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
		
	--��his��ʱ������ת��hisȫ����ʱ��
	EXEC('select * INTO '+@HistableName+' from ' + @HisTempTable )
	--����His���
	exec('SELECT * FROM '+ @HistableName + ' order by �շ�����')

	--����ҽ������  ���ȴ���ҽ����ʱ��
	if exists(select 1 from tempdb..sysobjects where name = @YbTableName)
	begin
		EXEC('drop TABLE '+ @YbTableName)
    END
	
	IF @cq01Config = 'DR'
	begin
		EXEC('create table '+ @YbTableName    +         
			'(   ������ˮ��  VARCHAR(18) ,         '+
			'    ����        VARCHAR(30),          '+
			'    סԺ�����  VARCHAR(18) ,         '+
			'    ҽ�����    VARCHAR(30),          '+
			'    �ܽ��      numeric(12,2),        '+
			'    ͳ��        numeric(12,2),        '+
			'    �˻�֧��    numeric(12,2),        '+
			'    �˻�����    numeric(12,2),        '+
			'    �������    numeric(12,2),        '+
			'    ����Ա����  numeric(12,2),        '+
			'    ����Ա����  numeric(12,2),        '+
			'    �ֽ�֧��    numeric(12,2),      '+
			'    ��������    datetime ,          '+
			'    ��������ˮ�� VARCHAR(18),       '+
			'    �˱�־       VARCHAR(10),       '+
			'    ����ҽ����Χ numeric(12,2),     '+
			'    ��������     VARCHAR(14) ,      '+
			'    �α����     VARCHAR(3),        '+
			'    �������     VARCHAR(3),        '+
			'    ��ᱣ�Ϻ�   VARCHAR(20)  ) ')
	END
    ELSE
    BEGIN
        EXEC('create table '+ @YbTableName    +         
				'(  ������ˮ��  VARCHAR(18) ,         '+
				'   �ܽ��      numeric(12,2),        '+
				'   סԺ�����  VARCHAR(18) ) ');
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
			select 'F','������ʱ��ʱ����!'
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
			 (   ������ˮ��  VARCHAR(18) ,         
			     ����        VARCHAR(30),           
			     סԺ�����  VARCHAR(18) ,        
			     ҽ�����    VARCHAR(3),            
			     �ܽ��      numeric(12,2),         
			     ͳ��        numeric(12,2),       
			     �˻�֧��    numeric,             
			     �˻�����    numeric,             
			     �������    numeric(12,2),       
			     ����Ա����  numeric,             
			     ����Ա����  numeric,            
			     �ֽ�֧��    numeric(12,2),       
			     ��������    datetime ,          
			     ��������ˮ�� VARCHAR(18),        
			     �˱�־       VARCHAR(4),         
			     ����ҽ����Χ numeric(12,2),      
			     ��������     VARCHAR(14) ,       
			     �α����     VARCHAR(3),          
		         �������     VARCHAR(3),          
			     ��ᱣ�Ϻ�   VARCHAR(20)  )  
		
	end 
	ELSE 
	BEGIN
        SELECT @YbExceptName = '#YbExceptTableWD'
		create table  #YbExceptTableWD             
				(  ������ˮ��  VARCHAR(18) ,         
				   �ܽ��      numeric(12,2),        
				   סԺ�����  VARCHAR(18) )
	end
	
	SELECT @strSql = 'insert into '+@YbExceptName+' SELECT a.* from ' + @YbTableName + ' a WHERE NOT EXISTS (select 1 from ' + @HistableName + ' b WHERE a.������ˮ�� = b.������ˮ��) '
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
	SELECT @strSql = 'SELECT a.* from ' + @HistableName + ' a WHERE NOT EXISTS (select 1 from ' + @YbTableName + ' b WHERE a.������ˮ�� = b.������ˮ��) '
    exec(@strSql)
END
ELSE IF @opertype = 'GetYbSum'
BEGIN
    IF @cq01Config = 'DR'
	BEGIN
	    SELECT @strSql = 'select "�ϼ�" �ϼ�,sum(�ܽ��) �ܽ��,sum(ͳ��) ͳ��,sum(�˻�֧��) �˻�֧��,sum(�˻�����) �˻�����,sum(�������) ���, '
		               + ' SUM(����Ա����) ����Ա����,sum(����Ա����) ����Ա���� from '+ @YbTableName
	END
	ELSE
	BEGIN
	    SELECT @strSql = 'select "�ϼ�" �ϼ� ,sum(�ܽ��) �ܽ�� from '+ @YbTableName
	END
	exec(@strSql)
end
ELSE IF @opertype = 'GetYbExceptSum'
BEGIN
    IF @cq01Config = 'DR'
	BEGIN
	    SELECT @strSql = 'select "�ϼ�" as �ϼ� ,sum(a.�ܽ��) �ܽ��,sum(a.ͳ��) ͳ��,sum(a.�˻�֧��) �˻�֧��,sum(a.�˻�����) �˻�����,sum(a.�������) ���,'
		               + 'SUM(a.����Ա����) ����Ա����,sum(a.����Ա����) ����Ա����  '
	                   + ' from ' +@YbTableName + ' a where  not EXISTS (select 1 from ' + @HistableName + ' b where a.������ˮ�� = b.������ˮ��)'
	END
	ELSE
	BEGIN
	    SELECT @strSql = 'select "�ϼ�" as �ϼ� ,sum(a.�ܽ��) �ܽ�� from '+ @YbTableName + ' a '
		               + 'WHERE not EXISTS (select 1 from ' + @HistableName + ' b where a.������ˮ�� = b.������ˮ��)'
	END
	exec(@strSql)
end    

return
GO
