IF EXISTS(SELECT 1 FROM sysobjects WHERE name = 'usp_cqyb_saveybjzinfo_ex1')
  DROP PROC usp_cqyb_saveybjzinfo_ex1
GO
CREATE PROC usp_cqyb_saveybjzinfo_ex1
(
	@jsxh				ut_sjh,				--结算序号
	@syxh				ut_syxh,			--首页序号
	@xtbz				ut_bz,				--系统标志0挂号1收费2住院登记3住院信息更新
    @xzlb				ut_bz,				--险种类别
    @cblb				ut_bz,				--参保类别
	@zxlsh              VARCHAR(30)        --中心流水号
)
AS
/****************************************
[版本号]4.0.0.0.0
[创建时间]2017.03.05
[作者]FerryMan
[版权]Copyright ? 1998-2017卫宁健康科技集团股份有限公司
[描述]保存医保就诊登记信息
[功能说明]
	保存医保就诊登记信息，接口交易完成后保存
[参数说明]
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]
[修改记录]
****************************************/
SET NOCOUNT ON

IF @xtbz IN (0,1)
BEGIN
	DECLARE @bftfbz		ut_bz	--部分退费标志
	       ,@oldsjh     VARCHAR(20)
		   ,@oldcblb    ut_bz
		   ,@oldzgyllb     VARCHAR(3)
		   ,@oldjmyllb     VARCHAR(3)
			
	IF EXISTS(SELECT 1 FROM VW_MZBRJSK(NOLOCK) WHERE sjh IN (SELECT tsjh FROM VW_MZBRJSK(NOLOCK) WHERE sjh = @jsxh))
		SELECT @bftfbz = 1
	ELSE
		SELECT @bftfbz = 0
    
	BEGIN TRANSACTION 
			
    UPDATE YY_CQYB_MZJZJLK SET zxlsh = @zxlsh,cblb = @cblb,jlzt = 1 WHERE jssjh = @jsxh AND jlzt = 0 
    IF @@error<>0 OR @@rowcount = 0 
	BEGIN
        ROLLBACK TRANSACTION 
		SELECT "F","更新医保门诊登记信息失败!"
		RETURN
	END;

    --通过登记之后返回信息修正更新ybdm
    UPDATE SF_BRJSK 
		SET ybdm = (SELECT TOP 1 a.ybdm FROM YY_YBFLK a(NOLOCK) 
    WHERE ( ( "1" = @xzlb and ISNULL(a.xzlb,0) = @xzlb AND ISNULL(a.cblb,0) = @cblb)
            or ("2" = @xzlb and ISNULL(a.xzlb,0) = @xzlb)
            or ("3" = @xzlb and ISNULL(a.xzlb,0) = @xzlb)
           ) 
      AND ISNULL(a.xtbz,-1) = 0  
      and a.jlzt = "0")  
      WHERE sjh = @jsxh
    IF @@error <> 0 or @@rowcount = 0 
	BEGIN
	      ROLLBACK TRANSACTION 
          SELECT "F","修正结算库医保代码失败!" 
		  RETURN
    END

    UPDATE a SET a.ybdm = b.ybdm FROM SF_BRXXK a,SF_BRJSK b(NOLOCK) WHERE a.patid = b.patid AND b.sjh = @jsxh
    if @@error <> 0 or @@rowcount = 0 
	BEGIN
	    ROLLBACK TRANSACTION 
	    SELECT "F","修正病人信息库医保代码失败!"
		RETURN
	END
    
	IF @xtbz = 0 
	BEGIN
        UPDATE a SET a.ybdm = b.ybdm FROM GH_GHZDK a,SF_BRJSK b(NOLOCK) WHERE a.patid = b.patid and a.jssjh = b.sjh AND b.sjh = @jsxh
		if @@error <> 0 or @@rowcount = 0 
		BEGIN
			ROLLBACK TRANSACTION 
			SELECT "F","修正挂号账单库医保代码失败!"
			RETURN
		END
	END

	--部分退费处理与前次收费cblb不一致情况,发现有普通门诊情况，特病情况复杂暂未发现暂不处理
	IF @bftfbz = 1
	BEGIN
		select @oldsjh = tsjh from VW_MZBRJSK(nolock) where sjh in (select tsjh from VW_MZBRJSK(nolock) where sjh = @jsxh)
		SELECT @oldcblb = cblb,@oldzgyllb = zgyllb,@oldjmyllb = jmyllb FROM VW_CQYB_MZJZJLK(nolock) WHERE jssjh = @oldsjh

		IF @oldcblb = 1 AND @cblb = 2 
		BEGIN
            IF @oldzgyllb = '11' 
			    UPDATE YY_CQYB_MZJZJLK SET jmyllb = '12' WHERE jssjh = @jsxh 
		END

		IF @oldcblb = 2 AND @cblb = 1
		BEGIN
            IF @oldjmyllb = '12' 
			    UPDATE YY_CQYB_MZJZJLK SET zgyllb = '11' WHERE jssjh = @jsxh 
		END
	END

	COMMIT TRANSACTION 

	select "T"
	return
end
else if @xtbz = 2
begin
	select "T"
    RETURN
end
else if @xtbz = 3
begin
	select "T"
    RETURN
end

GO
