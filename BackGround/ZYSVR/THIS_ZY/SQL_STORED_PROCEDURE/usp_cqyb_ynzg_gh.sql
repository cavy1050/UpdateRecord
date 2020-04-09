if exists(select 1 from sysobjects where name="usp_cqyb_ynzg_gh")
  drop proc usp_cqyb_ynzg_gh
go
CREATE proc usp_cqyb_ynzg_gh
(
    @code		varchar(10),	          --交易代码 01（预结算和结算前操作不是用医保账户支付）
    @jsxh		ut_sjh,			          --结算收据号
	@sfje       ut_money=0,                 --应收金额
    @errmsg     varchar(100)='' OUTPUT,   --错误信息
    @yhje       ut_money=0      OUTPUT    --优惠金额
)
as  

DECLARE @configCQ15 VARCHAR(20),
        @configCQ16 VARCHAR(10),
		@configCQ17 VARCHAR(20),
        @sfzh ut_sfzh,
		@strsql VARCHAR(500),
		@je     ut_money
		

SELECT @je = 0  
SELECT @errmsg='',@yhje = 0

SELECT @configCQ16 = config from YY_CONFIG WHERE id = 'CQ16'
IF ISNULL(@configCQ16,'') = '' OR @configCQ16 = '否' 
BEGIN
	SELECT @errmsg = 'T'
	RETURN
END
    
IF @code = '01'  --挂号时处理不使用医保账户
BEGIN
	select @sfzh = isnull(b.sfzh,'') FROM SF_BRJSK a(nolock) inner join SF_BRXXK b(nolock) on a.patid = b.patid WHERE sjh = @jsxh

	SELECT @configCQ15 = config from YY_CONFIG WHERE id = 'CQ15'
	IF ISNULL(@configCQ15,'') = '' 
	BEGIN
		SELECT @errmsg = 'F请配置CQ15参数'
		RETURN
	END

	SELECT @strsql = 'IF exists(select 1 from '+@configCQ15+' where sfzh = "'+@sfzh+'")'
					+ 'BEGIN '
					+ '    update YY_CQYB_MZJSJLK set zhzfbz = "1" where jssjh = "'+ @jsxh +'"'
					+ 'END '
    EXEC(@strsql)
	SELECT @errmsg = 'T'
	RETURN
END
ELSE IF @code = '02' --挂号处理优惠
BEGIN
    SELECT @configCQ17=config FROM YY_CONFIG WHERE id='CQ17'
	IF ISNULL(@configCQ17,'') = '' 
	BEGIN
	    SELECT @yhje = 0 ,@errmsg='T'
	end

	SELECT @je = CONVERT(NUMERIC(10,2),@configCQ17)

	IF @sfje > @je  --当收费金额大于应收接 
	BEGIN
	    SELECT @yhje = @sfje - @je
	END 
    ELSE
    BEGIN
        SELECT @yhje = 0
	END

	SELECT @errmsg = 'T'
	RETURN
END
ELSE
BEGIN
	SELECT @errmsg = 'F没有该交易代码'
	RETURN
END

go
