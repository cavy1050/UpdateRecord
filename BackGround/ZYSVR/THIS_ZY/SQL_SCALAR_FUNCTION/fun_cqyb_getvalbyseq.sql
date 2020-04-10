if exists (select 1 from sysobjects where name='fun_cqyb_getvalbyseq' and xtype='FN') 
	drop function fun_cqyb_getvalbyseq
go
Create function fun_cqyb_getvalbyseq(@inPut varchar(8000),@seq VARCHAR(1),@i int)returns varchar(1000)
as
/* 
	返回字符串中的@i位置的字符串
	@i从1开始
*/
begin
	declare @j int,
			@psi int,
			@value varchar(8000)
	set @j = 0
	set @psi = 0
	
	SET @inPut = REPLACE(@inPut,@seq,' '+@seq+' ') + ' '+@seq

	if datalength(@inPut)-datalength(replace(@inPut,@seq,'')) < @i  --判断大于位数就返回空
	begin
	    RETURN ''
	end
	while @j < @i - 1
	begin
		set @psi = charindex(@seq,@inPut,@psi)
		set @psi = @psi + 1
		set @j = @j + 1
	end
	set @value = substring(@inPut,@psi,charindex(@seq,@inPut,@psi+1) -@psi )
	if @@error <> 0 
		set  @value = '取值出错'
	return ltrim(rtrim(@value))
end
                     


GO