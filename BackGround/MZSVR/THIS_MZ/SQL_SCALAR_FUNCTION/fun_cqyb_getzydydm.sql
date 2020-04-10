if exists (select 1 from sysobjects where name='fun_cqyb_getzydydm' and xtype='FN') 
	drop function fun_cqyb_getzydydm
go
Create function fun_cqyb_getzydydm
(
	@xh ut_xh12,
	@idm ut_xh9,
	@configCQ36 VARCHAR(20),
	@configCQ39 VARCHAR(20),
	@configCQ40 VARCHAR(20)
)
returns varchar(20)
/*******************************
函数功能：获取住院上传医保流水号
*********************************/
as
begin
    DECLARE @yblsh VARCHAR(20) 

	IF @idm <> 0 
	BEGIN
		SELECT 
		    @yblsh = 
		    CASE WHEN ISNULL(d.spjg,'0')='1' THEN (CASE WHEN @configCQ39 = a.dydm THEN b.dydm ELSE a.dydm END) --如果审批通过则不管全自费标志和医生站选择的是否自费，直接按对照的医保正常上传
				 ELSE
					 CASE WHEN ( ISNULL(d.spjg,'0') = '2' OR ISNULL(c.qzfbz,0) = 1 ) THEN @configCQ39 --审批不通过或全自费/*or isnull((CASE @configCQ36 WHEN '1' THEN b.dydm ELSE a.dydm END),'') = ''*/
						  ELSE
							 ( 
								 CASE WHEN ( @configCQ36 = '1') THEN b.dydm
									  WHEN ( @configCQ36 = '2' AND ISNULL(a.dydm,'') = '' ) THEN b.dydm 
									  WHEN ( @configCQ36 = '3' AND a.dydm <> @configCQ39 ) THEN b.dydm
									  ELSE a.dydm
								 END 
							 )
					 END
	        END
		FROM ZY_BRFYMXK a(NOLOCK) INNER JOIN YK_YPCDMLK b(NOLOCK) ON a.idm = b.idm
		                          INNER JOIN YY_CQYB_ZYFYMXK c(NOLOCK) ON a.xh = c.xh
		                          LEFT JOIN YY_CQYB_ZDYSPFYMX d(NOLOCK) ON a.xh = d.xh
		WHERE a.xh = @xh
	END
	ELSE IF @idm = 0 
	BEGIN
        SELECT 
		    @yblsh = 
		    CASE WHEN ISNULL(d.spjg,'0')='1' THEN CASE WHEN @configCQ40 = a.dydm THEN b.dydm ELSE a.dydm end --如果审批通过则不管全自费标志和医生站选择的是否自费，直接按对照的医保正常上传
				 ELSE
					CASE when ( ISNULL(d.spjg,'0')='2' OR ISNULL(c.qzfbz,0) = 1  ) THEN @configCQ40  --审批不通过或全自费 /*or isnull((CASE @configCQ36 WHEN '1' THEN b.dydm ELSE a.dydm END),'') = '' */
						 ELSE 
							( 
								CASE WHEN ( @configCQ36 = '1') THEN b.dydm
									 WHEN ( @configCQ36 = '2' AND ISNULL(a.dydm,'') = '' ) THEN b.dydm 
									 WHEN ( @configCQ36 = '3' AND a.dydm <> @configCQ40 ) THEN b.dydm
									 ELSE a.dydm
								END 
							)
					END
	        END
		FROM ZY_BRFYMXK a(NOLOCK) INNER JOIN YY_SFXXMK b(NOLOCK) ON a.ypdm = b.id 
		                          INNER JOIN YY_CQYB_ZYFYMXK c(NOLOCK) ON a.xh = c.xh
		                          LEFT JOIN YY_CQYB_ZDYSPFYMX d(NOLOCK) ON a.xh = d.xh
		WHERE a.xh = @xh
	END

	RETURN(@yblsh)
end

GO
