if exists(select 1 from sysobjects where name = 'fun_cqyb_getlcxmshid')
  drop FUNCTION fun_cqyb_getlcxmshid
go

create function fun_cqyb_getlcxmshid
(
	@input varchar(1024),    --临床项目审核id
	@xxmdm VARCHAR(30)        --临床项目小项目代码
)
RETURNS varchar(50)
as
/* 
	获取临床项目内小项目的审核id
	小项目id1:审核id1|小项目id2:审核id3|小项目id1:审核id4 。。。。
*/
begin
	declare @seq1		VARCHAR(1),
	        @seq2		VARCHAR(1),
	        @count		INT,
	        @i			INT,
	        @shid       varchar(50),
	        @temp       VARCHAR(100)
	
	SELECT @seq1 = '|',@seq2=':'
    SELECT @count = ( (len(@input)-len(replace(@input,@seq1,''))) / LEN(@seq1) ) + 1;
    
    SELECT @i=1
    WHILE @i <= @count
    BEGIN
        SELECT @temp = dbo.fun_cqyb_getvalbyseq(@input,@seq1,@i)
        IF charindex (@xxmdm+@seq2,@temp)>0 
        BEGIN
            SELECT @shid = dbo.fun_cqyb_getvalbyseq(@temp,@seq2,2)
            BREAK
        END
        
        SELECT @i = @i+1
    end
    
	return ltrim(rtrim(@shid))
end
                     


GO