if exists (select 1 from sysobjects where name='fun_cqyb_getzyybzzfbz' and xtype='FN') 
	drop function fun_cqyb_getzyybzzfbz
go
Create function fun_cqyb_getzyybzzfbz
(
	@xh ut_xh12
)
returns varchar(3)
/*******************************
�������ܣ���ȡסԺת�Էѱ�ʶ
*********************************/
as
begin
    DECLARE @ybzzfbz VARCHAR(3) 

	SELECT 
		@ybzzfbz = 
		CASE WHEN ISNULL(d.spjg,'0')='1' THEN '0' --�������ͨ���򲻹�ȫ�Էѱ�־��ҽ��վѡ����Ƿ��Էѣ�ֱ�Ӱ����յ�ҽ�������ϴ�
		ELSE
			CASE when isnull(c.qzfbz,0) = 1 OR ISNULL(d.spjg,'0')='2' THEN '1'  --���ת��ȫ�Էѻ���������ͨ������ת�Է�
			ELSE ISNULL(a.ybzzfbz,'0')    --��ҽ��ѡ��ľ����Ƿ�ת
			END
	    END
	FROM ZY_BRFYMXK a(NOLOCK) INNER JOIN YY_CQYB_ZYFYMXK c(NOLOCK) ON a.xh = c.xh
		                      LEFT JOIN YY_CQYB_ZDYSPFYMX d(NOLOCK) ON a.xh = d.xh
	WHERE a.xh = @xh
	
	RETURN(@ybzzfbz)
end

GO
