if exists(select 1 from sysobjects where name='usp_cqyb_ybzddz')
  drop proc usp_cqyb_ybzddz
GO

CREATE proc usp_cqyb_ybzddz
(
    @code		varchar(30),	          --交易代码 GET_ZDLBLB 获取字典类别列表 GET_ZDXX取his 
    @zdlb         VARCHAR(12)='',         --字典类别 
    @hisid		VARCHAR(30)='',			  --his字典编码
    @ybid       VARCHAR(30)=''            --医保字典编码 
)
/*
本过程字段别名不能随意修改
*/
as  


DECLARE @czsj datetime

SET @czsj = GETDATE()
    
IF @code = 'GET_ZDLBLB'  --获取字典类别列表
BEGIN
    SELECT DISTINCT zdlb + '-' + zdsm '字典类别' FROM YY_CQYB_YBSJZD
    WHERE zdlb IN ('JX','DCJLDW','ZXJLDW','YYTJ','SYPC','CYYY','YLLB') AND ISNULL(jlzt,0) = 0
END
ELSE IF @code = 'GET_ZDXX' --根据zdlb获取医保字典信息
BEGIN
    SELECT code '代码',name '名称',CASE xtbz WHEN 0 THEN '门诊' WHEN 1 THEN '住院' ELSE '未知' END '系统标志'
    FROM YY_CQYB_YBSJZD WHERE zdlb = @zdlb AND ISNULL(jlzt,0) = 0
END
ELSE IF @code = 'GET_HISZDXX' --获取His字典
BEGIN
    IF @zdlb IN ('JX','CBLB')
    BEGIN
        SELECT id '代码',name '名称',py '拼音码',wb '五笔码' FROM YK_YPJXK 
        where id NOT IN (SELECT hiscode FROM YY_CQYB_YBSJZD_DZ WHERE zdlb = @zdlb)
    END
    ELSE IF @zdlb = 'DCJLDW' 
    BEGIN
        SELECT id '代码',name '名称',py '拼音码',wb '五笔码' FROM YY_UNIT WHERE lb = 1 
        and id NOT IN (SELECT hiscode FROM YY_CQYB_YBSJZD_DZ WHERE zdlb = @zdlb)                        
	END 
	ELSE IF @zdlb = 'ZXJLDW'
	BEGIN
	    SELECT id '代码',name '名称',py '拼音码',wb '五笔码' FROM YY_UNIT WHERE lb = 0
	    and id NOT IN (SELECT hiscode FROM YY_CQYB_YBSJZD_DZ WHERE zdlb = @zdlb)
	END 
	ELSE IF @zdlb = 'YYTJ' 
	BEGIN
	    SELECT id '代码',name '名称',py '拼音码',wb '五笔码' FROM SF_YPYFK WHERE jlzt = 0
	    and id NOT IN (SELECT hiscode FROM YY_CQYB_YBSJZD_DZ WHERE zdlb = @zdlb)
	END
	ELSE IF @zdlb = 'SYPC'
	BEGIN
	    SELECT id '代码',xsmc+'('+name+')' '名称',py '拼音码',wb '五笔码' FROM SF_YS_YZPCK WHERE jlzt = 0
	    and id NOT IN (SELECT hiscode FROM YY_CQYB_YBSJZD_DZ WHERE zdlb = @zdlb)
	END
    ELSE IF @zdlb = 'CYYY'
    BEGIN
        SELECT id '代码',name '名称',py '拼音码',wb '五笔码' FROM ZYB_CYFSK
		WHERE  id NOT IN (SELECT hiscode FROM YY_CQYB_YBSJZD_DZ WHERE zdlb = @zdlb)
	END
    ELSE IF @zdlb = 'YLLB'
    BEGIN
        SELECT id '代码',name '名称',py '拼音码',wb '五笔码' FROM ZYB_RYFSK
		WHERE  id NOT IN (SELECT hiscode FROM YY_CQYB_YBSJZD_DZ WHERE zdlb = @zdlb)
	END
    RETURN   
END
ELSE IF @code = 'GET_YDZXX' --根据zdlb获取已对照信息
BEGIN
    SELECT zdlb, hiscode 'His代码' ,ybcode '医保代码' FROM YY_CQYB_YBSJZD_DZ 
    WHERE zdlb = @zdlb 
    
    /*
    IF @zdlb = 'JX'
    BEGIN
        SELECT id '代码',name '名称',py '拼音码',wb '五笔码' FROM YK_YPJXK 
    END
    ELSE IF @zdlb = 'DCJLDW' 
    BEGIN
        SELECT id '代码',name '名称',py '拼音码',wb '五笔码' FROM YY_UNIT WHERE lb = 1                         
	END 
	ELSE IF @zdlb = 'ZXJLDW'
	BEGIN
	    SELECT id '代码',name '名称',py '拼音码',wb '五笔码' FROM YY_UNIT WHERE lb = 0
	END 
	ELSE IF @zdlb = 'YYTJ' 
	BEGIN
	    SELECT id '代码',name '名称',py '拼音码',wb '五笔码' FROM SF_YPYFK WHERE jlzt = 0
	END
	ELSE IF @zdlb = 'SYPC'
	BEGIN
	    SELECT id '代码',xsmc+'('+name+')' '名称',py '拼音码',wb '五笔码' FROM SF_YS_YZPCK WHERE jlzt = 0
	END
	*/
END
ELSE IF @code = 'SAVE_DZXX' --保存对照信息
BEGIN
    INSERT INTO YY_CQYB_YBSJZD_DZ (zdlb, hiscode, ybcode)
    VALUES  (@zdlb, -- zdlb - varchar(20)
             @hisid, -- hiscode - varchar(20)
             @ybid  -- ybcode - varchar(20)
             )
    if @@error <> 0 AND @@ROWCOUNT < 1
	begin
        ROLLBACK TRAN
        SELECT 'F','对照保存失败！'
		return
	END
	SELECT 'T',''
    RETURN     
END
ELSE IF @code = 'DEL_DZXX' --删除对照信息
BEGIN
    DELETE YY_CQYB_YBSJZD_DZ WHERE zdlb = @zdlb AND hiscode =@hisid
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
