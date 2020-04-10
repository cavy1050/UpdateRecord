if exists (select 1 from sysobjects where name='fun_convertrq_cqyb' and xtype='FN') 
	drop function fun_convertrq_cqyb
go
Create function fun_convertrq_cqyb(@lb integer,@rq varchar(18))
returns varchar(19)
/*******************************
函数功能：格式化医保需要的日期格式
返回结果集说明：
@lb 0:返回当前时间1:返回指定时间
时间格式：必须是yyyy-MM-dd hhmmss (年4位，月、日、时、分、秒均2位)
select dbo.fun_convertrq_cqyb(2,'')
*********************************/
as
begin
    declare @now varchar(16),@rq_ok varchar(19)
    select @now = convert(varchar(8),getdate(),112)+convert(varchar(8),getdate(),114)
    if (@lb = 0) or (isnull(@rq,'') = '') select @rq = @now
    if @lb = 0 or @lb = 1    
		select @rq_ok = substring(@rq,1,4)+'-'+substring(@rq,5,2)+'-'+substring(@rq,7,2)+' '+substring(@rq,9,8)
	else if @lb = 2
	    select @rq_ok = substring(@rq,1,4)+'-'+substring(@rq,5,2)+'-'+substring(@rq,7,2)
	return(@rq_ok)
end

GO
