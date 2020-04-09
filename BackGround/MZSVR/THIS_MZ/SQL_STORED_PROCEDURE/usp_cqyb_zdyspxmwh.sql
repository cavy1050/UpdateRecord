if exists(select 1 from sysobjects where name='usp_cqyb_zdyspxmwh')
  drop proc usp_cqyb_zdyspxmwh
GO

CREATE proc usp_cqyb_zdyspxmwh
(
    @code		varchar(10),	          --交易代码 01新增，02启用/停用,03查询维护信息,04查询日志
    @xh         VARCHAR(12)='',           --序号 
    @xmlb		VARCHAR(30)='',			  --项目类别 0药品 1诊疗 2诊断
    @xmdm       VARCHAR(30)='',           --项目代码 
	@xmmc       VARCHAR(100)='',          --项目名称
    @jlzt       ut_bz = 0,                --记录状态
    @czyh       VARCHAR(10)=''               --操作用户
)
as  

DECLARE @czsj datetime

SET @czsj = GETDATE()
    
IF @code = '01'  --新增
BEGIN
    
    IF EXISTS(SELECT 1 FROM YY_CQYB_ZDYSPXM WHERE xmlb = @xmlb AND xmdm = @xmdm)
    BEGIN
        SELECT 'F','该项目已存在,不能重复添加！'
        RETURN
    END
    
    BEGIN TRAN
    
    INSERT INTO YY_CQYB_ZDYSPXM (xmlb, xmdm, xmmc, jlzt,czyh,czsj)
    VALUES  (@xmlb, @xmdm, @xmmc, 0,@czyh,@czsj )
    if @@error <> 0
	begin
        ROLLBACK TRAN
        SELECT 'F','新增失败'
		return
	end
    
    INSERT INTO YY_CQYB_ZDYSPXMLOG (whxh, czyh, czlb, czrq, memo)
    VALUES  (@@IDENTITY,  @czyh,  0,  @czsj, '新增' )
    if @@error <> 0
	begin
        ROLLBACK TRAN
        SELECT 'F','新增失败log'
		return
	END
	
    COMMIT TRAN
    SELECT 'T',''
	RETURN
END
ELSE IF @code = '02' --启用/停用
BEGIN
    BEGIN TRAN
    
    UPDATE YY_CQYB_ZDYSPXM SET jlzt = @jlzt WHERE xh = @xh
    if @@error <> 0
	begin
        ROLLBACK TRAN
        SELECT 'F','更新失败'
		return
	end
    
    INSERT INTO YY_CQYB_ZDYSPXMLOG (whxh, czyh, czlb, czrq, memo)
    VALUES  (@xh,  @czyh,  CASE @jlzt WHEN '1' THEN 2 WHEN '0' THEN 1 ELSE NULL END ,
             @czsj, CASE @jlzt WHEN '1' THEN '停用' WHEN '0' THEN '启用' ELSE NULL END)
    if @@error <> 0
	begin
        ROLLBACK TRAN
        SELECT 'F','更新失败log'
		return
	END
    
    COMMIT TRAN
    SELECT 'T',''
    RETURN   
END
ELSE IF @code = '03' --查询维护信息
BEGIN
    SELECT CASE a.xmlb WHEN '0' THEN '药品' WHEN '1' THEN '诊疗' WHEN '2' THEN '诊断' ELSE '' END "项目类型",
           a.xmdm "项目代码",a.xmmc "项目名称",
           CASE a.jlzt WHEN 1 then "停用" WHEN 0 THEN "在用" end AS "记录状态",
           a.xh "xh",
		   CASE a.xmlb WHEN '0' THEN (SELECT c.BZ FROM YK_YPCDMLK b(NOLOCK),YPML c(NOLOCK) WHERE b.dydm = c.YPLSH AND a.xmdm = b.idm)
		               WHEN '1' THEN (SELECT e.BZ FROM YY_SFXXMK d(NOLOCK),ZLXM e(NOLOCK)  where d.dydm = e.XMLSH and a.xmdm = d.id)
					   ELSE ''   
		   END as "备注"
    FROM YY_CQYB_ZDYSPXM a(NOLOCK) 
	WHERE (xmlb = @xmlb OR "-1" = @xmlb) 
	  AND (a.xmmc LIKE '%'+@xmmc+'%')
    
    RETURN   
END
ELSE IF @code = '04' --查询日志
BEGIN
    SELECT a.czlb "操作类别", a.memo "操作说明",a.czyh "修改人",a.czrq "修改时间" 
    FROM YY_CQYB_ZDYSPXMLOG a(NOLOCK) INNER JOIN YY_CQYB_ZDYSPXM b(NOLOCK) ON a.whxh = b.xh 
    WHERE a.whxh = @xh ORDER BY a.czrq
    
    RETURN   
END
ELSE
BEGIN
	SELECT 'F','没有该交易代码'
	RETURN
END

go
