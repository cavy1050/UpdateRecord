IF exists(SELECT 1 FROM sysobjects WHERE name = 'usp_cqyb_checkzdyxx')
  DROP PROC usp_cqyb_checkzdyxx
GO
CREATE PROC usp_cqyb_checkzdyxx
(
	@czlb				VARCHAR(10),			--操作类别
	@str				VARCHAR(500) = '',
	@str1				VARCHAR(500) = '',
	@str2				VARCHAR(500) = '',
	@str3				VARCHAR(500) = '',
	@str4				VARCHAR(500) = '',
	@str5				VARCHAR(500) = '',
	@str6				VARCHAR(500) = '',
	@str7				VARCHAR(500) = '',
	@str8				VARCHAR(500) = '',
	@str9				VARCHAR(500) = ''
)
AS
/****************************************
[版本号]4.0.0.0.0
[创建时间]2018.12.31
[作者]Zhuhb
[版权]Copyright ? 1998-2017卫宁健康科技集团股份有限公司
[描述]检查自定义信息
[功能说明]
	检查自定义信息
[参数说明]
	@czlb	1:医保退费时如果账户抵用是否提示
			2:判断病人在院是否超365天需要中结
			3:对当前扶贫人员类别进行提示
			4:时候审批异常提示
[返回值]
	开发时固定返回值格式；
[结果集、排序]
[调用的sp]
[调用实例]
[修改记录]

****************************************/
SET NOCOUNT ON

DECLARE @ybdm		ut_ybdm,			--医保代码
		@cblb_his	VARCHAR(10)			--参保类别
IF @czlb = 1
BEGIN
	IF NOT EXISTS(SELECT 1 FROM YY_CQYB_MZDYJLK a(NOLOCK) WHERE a.jssjh = @str AND a.jlzt = 2)
	BEGIN
		SELECT "T",""
		RETURN
	END
	ELSE
	BEGIN
		SELECT "F","该笔交易存在账户抵用"
		RETURN
	END

END
IF @czlb = 2
BEGIN
	--@str1 首页序号、@str2 结算序号
	--标准版本1
	--DECLARE @rqrq VARCHAR(30),
	--		@cqrq VARCHAR(30);
	--IF EXISTS(SELECT 1 FROM ZY_BRSYK a(NOLOCK) WHERE a.syxh = @str1 AND a.brzt = 2 )
	--BEGIN
	--	SELECT	@rqrq = SUBSTRING(a.rqrq,1,8) + ' ' + SUBSTRING(a.rqrq,10,8),
	--			@cqrq = SUBSTRING(a.cqrq,1,8) + ' ' + SUBSTRING(a.cqrq,10,8)
	--	FROM ZY_BRSYK a(NOLOCK) WHERE a.syxh = @str1 AND a.brzt = 2		
	--END
	--ELSE
	--BEGIN
	--	SELECT "F","获取患者数据异常"
	--	RETURN		
	--END	
	--IF (ISDATE(@rqrq) = 0) OR (ISDATE(@cqrq) = 0)
	--BEGIN
	--	SELECT "F","入区时间或出区时间格式有误"
	--	RETURN
	--END
	
	--IF CONVERT(datetime,@cqrq,101) > DATEADD(YEAR,1,CONVERT(datetime,@rqrq,101))
	--BEGIN
	--	SELECT "F","该患者在院时间超过365天，请先进行中途结算"
	--	RETURN
	--END

	--标准版本2
	SELECT "T",""
	RETURN
END
IF @czlb = 3--对当前扶贫人员类别进行提示
BEGIN
	--标准版本
	SELECT 'T',''
	RETURN
	--附二版本
	--IF EXISTS(SELECT 1 FROM YY_CQYB_PATINFO a(NOLOCK) WHERE a.sbkh = @str AND ISNULL(a.dqfprylb,'') <> '')
	--BEGIN
	--	SELECT 'T','请注意：该病人（' + a.sbkh + '）为' + a.dqfprylb FROM YY_CQYB_PATINFO a(NOLOCK) 
	--	WHERE a.sbkh = @str AND ISNULL(a.dqfprylb,'') <> ''
	--	RETURN	
	--END
	--ELSE
	--BEGIN
	--	SELECT 'T',''
	--	RETURN	
	--END
END
IF @czlb = 4--时候审批异常提示
BEGIN
	declare @cnt INT,
			@spjg	VARCHAR(10),
			@spyy	VARCHAR(1000);
	--标准版本
	SELECT 'T',''
	RETURN
	/*
	--开州人民医院
	IF NOT EXISTS(SELECT 1 FROM YY_CQYB_SHSPJG a(NOLOCK) WHERE a.syxh= @str)
	BEGIN
		SELECT 'T',''
	END
	ELSE
	BEGIN
		SELECT @cnt = COUNT(0) FROM YY_CQYB_SHSPJG a(NOLOCK) WHERE a.syxh= @str
		IF @cnt > 1
		BEGIN
			SELECT 'R','事后审批异常，查询返回数据集大于1条！'	
		END
		ELSE
		BEGIN
			SELECT @spjg = spjg,@spyy = a.spyy FROM YY_CQYB_SHSPJG a(NOLOCK) WHERE a.syxh= @str
			IF @spjg = '2'
			BEGIN
				SELECT 'R','事后审批未通过【'+ @spyy + '】，' + '请到窗口处理！'	
			END	
			ELSE
			BEGIN
				SELECT 'T',''
			END		
		END
	END
	RETURN
	*/
END
IF @czlb = 5--后台获取360视图地址
BEGIN
	--标准版本
	SELECT 'T',''
	RETURN
	/*
	--开州人民医院版本
	SELECT 'T','http://www.winning.com.cn'
	RETURN	
	*/
END

SELECT "T",""

RETURN
GO
