if exists (select 1 from sysobjects where name='fun_convertrq_cqyb' and xtype='FN') 
	drop function fun_convertrq_cqyb
go
Create function fun_convertrq_cqyb(@lb integer,@rq varchar(18))
returns varchar(19)
/*******************************
�������ܣ���ʽ��ҽ����Ҫ�����ڸ�ʽ
���ؽ����˵����
@lb 0:���ص�ǰʱ��1:����ָ��ʱ��
ʱ���ʽ��������yyyy-MM-dd hhmmss (��4λ���¡��ա�ʱ���֡����2λ)
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
