if exists(select 1 from sysobjects where name = 'fun_cqyb_getlcxmshid')
  drop FUNCTION fun_cqyb_getlcxmshid
go

create function fun_cqyb_getlcxmshid
(
	@input varchar(1024),    --�ٴ���Ŀ���id
	@xxmdm VARCHAR(30)        --�ٴ���ĿС��Ŀ����
)
RETURNS varchar(50)
as
/* 
	��ȡ�ٴ���Ŀ��С��Ŀ�����id
	С��Ŀid1:���id1|С��Ŀid2:���id3|С��Ŀid1:���id4 ��������
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