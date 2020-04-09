if exists(select 1 from sysobjects where name = 'usp_cqyb_saveget38tqcf')
  drop proc usp_cqyb_saveget38tqcf
go
CREATE proc usp_cqyb_saveget38tqcf
@opertype VARCHAR(3),  --1:保存、2：查询 
@ybkh VARCHAR(20),
@yllb VARCHAR(3),
@patid VARCHAR(20),    
@input VARCHAR(8000)   
as      
/*
   保存特群处方  
    EXECUTE usp_cqyb_save38tqcf 'ybkh','11','1231','1232131|2$were|3' 
   
*/      
  
set nocount on   
DECLARE 
@str VARCHAR(8000),
@seq1 VARCHAR(1),
@seq2 VARCHAR(1),
@i NUMERIC(8),
@yearMonth VARCHAR(6),
@count NUMERIC(8);

SET @seq1 = '$'
SET @seq2 = '|'
SET @yearMonth = CONVERT(VARCHAR(6),GETDATE(),112)
SET @i = 1

IF @opertype = '1' 
BEGIN
	SET @count = ( (len(@input)-len(replace(@input,@seq1,''))) / LEN(@seq1) ) + 1;
	BEGIN TRANSACTION 

	DELETE YY_CQYB_TQCFCX WHERE patid=@patid AND yearmonth = @yearMonth;

	WHILE @i <= @count
	BEGIN
		SET @str = dbo.fun_cqyb_getvalbyseq(@input,@seq1,@i);

		INSERT INTO YY_CQYB_TQCFCX (patid,ybkh, yllb,  yearmonth,xmyblsh, sl,operdate)
				VALUES  (@patid,@ybkh, -- ybkh - varchar(20)
						 @yllb, -- yllb - varchar(3)
						 @yearMonth,
						 dbo.fun_cqyb_getvalbyseq(@str,@seq2,1), -- xmyblsh - varchar(32)
						 dbo.fun_cqyb_getvalbyseq(@str,@seq2,2),  -- code - numeric
						 GETDATE()
						 )
		if @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION 
			SELECT 'F',''
			RETURN
	                
		END
	       
		SET @i = @i + 1;
	END

	COMMIT TRANSACTION

	 
	SELECT 'T',''
END
ELSE IF @opertype = '2'
BEGIN
   SELECT a.ybkh ,a.yearmonth, b.yblsh,b.xmmc ,a.sl,a.operdate
	FROM YY_CQYB_TQCFCX a,
		VW_YBYPXM b
	WHERE a.xmyblsh = b.yblsh 
	  AND a.patid = @patid AND yearmonth = @yearMonth;
END



     