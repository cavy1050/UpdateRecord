if exists(select 1 from sysobjects where name='usp_cqyb_ybzdxxdz')
  drop proc usp_cqyb_ybzdxxdz
GO

CREATE proc usp_cqyb_ybzdxxdz
(
    @code			varchar(30)				,--交易代码
	@hiszddm		VARCHAR(20)			=''	,--HIS诊断代码(YY_ZDDMK.id)
	@ybzddm			varchar(20)			=''	,--医保诊断代码(YY_CQYB_ZDDMK.id)
	@czyh           varchar(10)			=''	,--操作用户
	@syfw			ut_bz				=0	 --使用范围(0：ALL、1：窗口、2：自助机)
)
/****************************************
[版本号]4.0.0.0.0
[创建时间]2019.07.03
[作者]Zhuhb
[版权]Copyright ? 1998-2017卫宁健康科技集团股份有限公司
[描述]医保诊断对照相关功能
[功能说明]
	获取HIS诊断代码、医保诊断代码、诊断代码对照、已对照诊断查询等；
[参数说明]
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]
[修改记录] 
****************************************/

AS  

DECLARE @czsj datetime

SET @czsj = GETDATE()
    
IF @code = 'SAVEDZXX' --保存对照信息
BEGIN
	IF EXISTS(SELECT 1 FROM YY_CQYB_ZDDMK_DZ WHERE hiszddm = @hiszddm AND ybzddm = @ybzddm)
	BEGIN
			SELECT 'F','对照保存失败(该诊断已经对照)！'
			return		
	END
	ELSE
	BEGIN		
		INSERT INTO YY_CQYB_ZDDMK_DZ(hiszddm,ybzddm,syfw,czyh,czrq)
		VALUES  (@hiszddm,@ybzddm,@syfw,@czyh,@czsj)
		if @@error <> 0 AND @@ROWCOUNT < 1
		begin
			ROLLBACK TRAN
			SELECT 'F','对照保存失败！'
			return
		END
		SELECT 'T',''
		RETURN  		
	END
   
END
ELSE IF @code = 'DELDZXX' --删除对照信息
BEGIN
    DELETE YY_CQYB_ZDDMK_DZ WHERE hiszddm = @hiszddm AND ybzddm = @ybzddm
    if @@error <> 0 AND @@ROWCOUNT < 1
	begin
        ROLLBACK TRAN
        SELECT 'F','取消对照失败！'
		return
	END
	SELECT 'T',''
    RETURN   
END
ELSE
BEGIN
	SELECT 'F','没有该交易代码'
	RETURN
END

RETURN
go
