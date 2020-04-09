if exists(select 1 from sysobjects where name = 'usp_cqyb_saveqxjsinfo')
  drop proc usp_cqyb_saveqxjsinfo
go
Create proc usp_cqyb_saveqxjsinfo
(
	@syxh			ut_syxh,		--首页序号
	@jsxh			VARCHAR(20),		--结算序号
	@xtbz		    ut_bz,			--系统标志0挂号1收费2住院
	@czlsh          VARCHAR(20),    --冲正流水号
	@zxczsj         VARCHAR(20),    --中心冲正时间
	@ddyljgbm       varchar(10)     --定点医疗机构编码
)
as
/**********************
[版本号]4.0.0.0.0
[创建时间]2017.03.05
[作者]FerryMan
[版权]Copyright ? 1998-2017卫宁健康科技集团股份有限公司
[描述]住院结算处理
[功能说明]
	HIS住院结算处理
[参数说明]
    @syxh			ut_syxh,		--首页序号
	@jsxh			ut_xh12,		--结算序号
	@xtbz		    ut_bz,			--系统标志0挂号1收费2住院
	@czlsh          VARCHAR(20),    --冲正流水号
	@zxczsj         VARCHAR(20)     --中心冲正时间
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]
exec usp_cqyb_saveqxjsinfo
[修改纪录]
**********************/
set nocount on

declare	@ybjsfs		varchar(3) --医保结算方式
       ,@hisjsfs    varchar(3) --his结算方式
       ,@ybdm       ut_ybdm  
if @xtbz in (0,1)
BEGIN
    BEGIN TRAN
	
	update YY_CQYB_MZJSJLK set czlsh = @czlsh,zxczsj = @zxczsj ,jlzt = 3,ddyljgbm = @ddyljgbm where jssjh = @jsxh and jlzt = 2 
    if @@error <> 0 
	BEGIN
	    ROLLBACK TRAN
	    SELECT "F","更新医保门诊结算信息(日表)失败!" 
		RETURN
	END

    update YY_CQYB_NMZJSJLK set czlsh = @czlsh,zxczsj = @zxczsj,jlzt = 3,ddyljgbm = @ddyljgbm where jssjh = @jsxh and jlzt = 2 
    if @@error <> 0 
	BEGIN
	    ROLLBACK TRAN
		SELECT "F","更新医保门诊结算信息(年表)失败!" 
		RETURN
	END

    update YY_CQYB_MZJZJLK set jlzt = 1 where jssjh = @jsxh and jlzt = 2  
    if @@error <> 0 
	BEGIN
	    ROLLBACK TRAN
	    SELECT "F","更新医保住院登记信息(日表)失败!"
		RETURN
	END

    update YY_CQYB_NMZJZJLK set jlzt = 1 where jssjh = @jsxh and jlzt = 2  
    if @@error <> 0 
	BEGIN
	    ROLLBACK TRAN
	    SELECT "F","更新医保住院登记信息(年表)失败!"
		RETURN 
	END

    update YY_CQYB_MZDYJLK set jlzt = 3 where jssjh = @jsxh and jlzt = 2 
    if @@error <> 0 
	BEGIN
	    ROLLBACK TRAN
	    SELECT "F","更新医保门诊账户抵用信息(日表)失败!"
		RETURN
	END

    update YY_CQYB_NMZDYJLK set jlzt = 3 where jssjh = @jsxh and jlzt = 2 
    if @@error <> 0 
	BEGIN
	    ROLLBACK TRAN
	    SELECT "F","更新医保门诊账户抵用信息(年表)失败!" 
		RETURN
	END

    update SF_JEMXK set memo = "已退费" where jssjh = @jsxh and lx in ("yb01","01") 
	if @@error <> 0 
	BEGIN
	    ROLLBACK TRAN
	    SELECT "F","更新日表已退费标志失败" 
	    RETURN
	END
    update SF_NJEMXK set memo = "已退费" where jssjh = @jsxh and lx in ("yb01","01") 
    if @@error <> 0 
	BEGIN
	    ROLLBACK TRAN
	    SELECT "F","更新年表已退费标志失败" 
	    RETURN
	END

	COMMIT TRAN
END     
ELSE IF @xtbz = '2'
begin       
	select @ybjsfs = jslb from YY_CQYB_ZYJSJLK(nolock) where syxh = @syxh and jsxh = @jsxh and jlzt = 2
	select @hisjsfs = jszt,@ybdm = ybdm from ZY_BRJSK(nolock) where syxh = @syxh and xh = @jsxh   --1:中途；2:出院

	begin tran 
	    update ZY_BRJSJEK set memo = "已退费" where jsxh = @jsxh and lx in ("yb01","01") 
		if @@error <> 0
		begin
			rollback tran 
			select 'F','更新医保住院结算信息失败!'
			return
		END
	    
		update YY_CQYB_ZYJSJLK set czlsh = @czlsh,zxczsj = @zxczsj,jlzt = 3,ddyljgbm=@ddyljgbm where syxh = @syxh and jsxh = @jsxh and jlzt = 2 
		if @@error <> 0 or @@rowcount = 0 
		begin
			rollback tran 
			select 'F','更新医保住院结算信息失败!'
			return
		end


		update YY_CQYB_ZYJZJLK set jlzt = 1 where syxh = @syxh and jlzt = 2 
		if @@error <> 0 
		begin
			rollback tran 
			select 'F','更新医保住院结算信息失败!'
			return
		end
	       
		update YY_CQYB_ZYDYJLK set jlzt = 3 where syxh = @syxh and jsxh = @jsxh and jlzt = 2 
		if @@error <> 0 
		begin   
			rollback tran 
			select 'F','更新医保住院账户抵用信息失败!'
			return
		end

		--如果his是中途结算，医保是出院结算，则还原ZY_BRJSK、ZY_BRXXK的ybdm为本次取消结算的医保代码
		if @ybjsfs = '0' and @hisjsfs = '1' 
		begin
			update ZY_BRSYK set ybdm = @ybdm where syxh = @syxh
			if @@error <> 0 
			begin   
				rollback tran 
				select 'F','更新首页库医保代码失败!'
				return
			end
	    
			update ZY_BRXXK set ybdm = @ybdm where patid = (select patid from ZY_BRSYK(nolock) where syxh = @syxh)
			if @@error <> 0 
			begin   
				rollback tran 
				select 'F','更新信息库医保代码失败!'
				return
			end
		end
	commit tran 
end

select 'T'

return
GO
