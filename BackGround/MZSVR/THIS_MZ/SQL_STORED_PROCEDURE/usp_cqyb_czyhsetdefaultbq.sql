if exists(select 1 from sysobjects where name='usp_cqyb_czyhsetdefaultbq')
  drop proc usp_cqyb_czyhsetdefaultbq
go
Create proc usp_cqyb_czyhsetdefaultbq
(
    @lb         VARCHAR(10),        --操作类别
    @czyh		VARCHAR(10),		--操作用户
    @bqdm		VARCHAR(10) 		--病区代码
)
as  
/*
    审核界面设置操作员默认选择病区
*/
set nocount on

IF @lb <> '01' and ISNULL(@bqdm,'') = ''  
BEGIN
   SELECT 'F','病区代码不能为空！'
   RETURN
end

IF @lb = '01' --查询操作员设置病区
BEGIN
    SELECT c.name '操作用户',b.name '病区名称',c.id '用户代码',b.id '病区代码'  FROM YY_CQYB_CZYHSETDEFAULTBQ a(NOLOCK),ZY_BQDMK b(NOLOCK),YY_ZGBMK c(NOLOCK)
    where a.bqdm = b.id AND a.czyh = c.id
END
ELSE IF @lb = '02' --保存病区
BEGIN
    IF EXISTS (SELECT 1 FROM YY_CQYB_CZYHSETDEFAULTBQ WHERE czyh = @czyh AND bqdm = @bqdm)
    BEGIN
        SELECT 'F', '该病区已存在!'  
		RETURN 
    END
    
    INSERT INTO YY_CQYB_CZYHSETDEFAULTBQ (czyh, bqdm)
    VALUES  (@czyh, @bqdm )
    if @@error <> 0 or @@rowcount = 0 
	BEGIN 
		SELECT 'F', '新增病区出错!'  
		RETURN
	END
    SELECT 'T',''
END
ELSE IF @lb = '03' --删除病区
BEGIN
    DELETE YY_CQYB_CZYHSETDEFAULTBQ where czyh= @czyh and bqdm = @bqdm
    if @@error <> 0 or @@rowcount = 0 
	BEGIN 
		SELECT 'F', '删除病区出错!'  
		RETURN
	END
    
    SELECT 'T',''
END
ELSE
BEGIN
    SELECT 'F','无输入参数类别值！'
END


RETURN
GO
