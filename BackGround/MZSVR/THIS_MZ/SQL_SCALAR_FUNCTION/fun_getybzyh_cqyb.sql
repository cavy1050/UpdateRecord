 if exists (select 1 from sysobjects where name = 'fun_getybzyh_cqyb' and xtype = 'FN') 
	drop function fun_getybzyh_cqyb
go
Create function fun_getybzyh_cqyb(@lb integer,@syxh ut_syxh)
returns varchar(18)
/*********************************
�������ܣ���ȡҽ��סԺ��
���ؽ����˵����
@lb 0:�����µ�סԺ�Ų�����1:��ȡҽ����Ժ���˵�סԺ��
select dbo.fun_getybzyh_yb(0,1)
*********************************/
as
begin
    declare @now varchar(16),
	        @ybzyh varchar(16),
			@now_xt DATETIME,
			@blh ut_blh  
    select @ybzyh = ''   
    select @now_xt = curdate from VW_GETDATE
    select @now = convert(char(8),@now_xt,8)
    if @lb = 0 
    BEGIN
        SELECT @blh = blh FROM ZY_BRSYK WHERE syxh = @syxh
		--select @ybzyh = cast(@syxh as varchar(10)) + substring(@now,1,2) + substring(@now,4,2) + substring(@now,7,2)
        select @ybzyh = @blh + '-' + SUBSTRING(@now,1,2) + substring(@now,4,2) + substring(@now,7,2) 
    END
	/*
    if @lb = 1
    begin
        select @ybzyh = isnull(jzlsh,"") from YY_CQYB_ZYJZINFO where syxh = @syxh
    end
	*/
	return(@ybzyh)
end

go
