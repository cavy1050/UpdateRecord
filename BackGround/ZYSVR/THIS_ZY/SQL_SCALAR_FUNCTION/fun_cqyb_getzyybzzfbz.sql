if exists (select 1 from sysobjects where name='fun_cqyb_getzyybzzfbz' and xtype='FN') 
	drop function fun_cqyb_getzyybzzfbz
go
Create function fun_cqyb_getzyybzzfbz
(
	@xh ut_xh12
)
returns varchar(3)
/*******************************
函数功能：获取住院转自费标识
*********************************/
as
begin
    DECLARE @ybzzfbz VARCHAR(3) 

	SELECT 
		@ybzzfbz = 
		CASE WHEN ISNULL(d.spjg,'0')='1' THEN '0' --如果审批通过则不管全自费标志和医生站选择的是否自费，直接按对照的医保正常上传
		ELSE
			CASE when isnull(c.qzfbz,0) = 1 OR ISNULL(d.spjg,'0')='2' THEN '1'  --如果转了全自费或者审批不通过，则转自费
			ELSE ISNULL(a.ybzzfbz,'0')    --按医生选择的决定是否转
			END
	    END
	FROM ZY_BRFYMXK a(NOLOCK) INNER JOIN YY_CQYB_ZYFYMXK c(NOLOCK) ON a.xh = c.xh
		                      LEFT JOIN YY_CQYB_ZDYSPFYMX d(NOLOCK) ON a.xh = d.xh
	WHERE a.xh = @xh
	
	RETURN(@ybzzfbz)
end

GO
