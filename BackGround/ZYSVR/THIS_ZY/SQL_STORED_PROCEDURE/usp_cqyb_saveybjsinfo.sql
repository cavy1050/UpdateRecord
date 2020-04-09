if exists(select 1 from sysobjects where name = 'usp_cqyb_saveybjsinfo')
  drop proc usp_cqyb_saveybjsinfo
go
CREATE proc usp_cqyb_saveybjsinfo
(
	@jsxh				ut_sjh,				--结算序号
	@syxh				ut_syxh,			--首页序号
	@ddyljgbm           varchar(10),         --定点医疗机构编码
    @sbkh				varchar(20),		--社会保障号码
	@xtbz				ut_bz,				--系统标志0挂号1收费2住院
    @xzlb				ut_bz,				--险种类别
    @jzlsh				varchar(20),		--住院(或门诊)号
    @jslb				ut_bz,				--结算类别
    @zhzfbz				ut_bz,				--账户支付标志
    @zhdybz				ut_bz,				--账户抵用标志
    @jsqzrq				varchar(19),		--中途结算起止日期
    @jszzrq				varchar(19),		--中途结算终止日期
    @gsrdbh				varchar(10),		--工伤认定编号
    @gsjbbm				varchar(200),		--工伤认定疾病编码
    @cfjslx				varchar(10),		--尘肺结算类型
    @sylb				varchar(10),		--生育类别
    @sysj				varchar(10),		--生育时间
    @sybfz				varchar(10),		--生育并发症
    @ncbz				varchar(10),		--难产标志
    @rslx				varchar(10),		--妊娠类型
    @dbtbz				varchar(10),		--多胞胎标志
    @syfwzh				varchar(50),		--生育服务证号
    @jhzh				varchar(50),		--结婚证号
    @jyjc				varchar(200),		--遗传病基因检查项目
    @zxlsh				varchar(20)  		--交易流水号
)
as
/****************************************
[版本号]4.0.0.0.0
[创建时间]2017.03.05
[作者]FerryMan
[版权]Copyright ? 1998-2017卫宁健康科技集团股份有限公司
[描述]保存医保结算信息
[功能说明]
	保存医保结算信息
[参数说明]
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]
[修改记录]
****************************************/
set nocount on
declare @now ut_rq16,
	    @cyzd VARCHAR(20),
		@bfzinfo VARCHAR(200)

select @now=convert(char(8),getdate(),112)+convert(char(8),getdate(),8)

if @xtbz in (0,1)
begin
	declare @ghsfbz		ut_bz,	--挂号收费标志
			@bftfbz		ut_bz	--部分退费标志
			
	select @ghsfbz = ghsfbz from SF_BRJSK(nolock) where sjh = @jsxh
	if exists(select 1 from SF_BRJSK(nolock) where sjh in (select tsjh from SF_BRJSK(nolock) where sjh = @jsxh))
		select @bftfbz = 1
	else
		select @bftfbz = 0
	
	if exists(select 1 from YY_CQYB_MZJSJLK(nolock) where jssjh = @jsxh and jlzt = 2)
	begin
		select "F","该门诊信息存在有效的医保登记信息!"
		return
	end

	if @ghsfbz = 0
	begin
		if not exists(select 1 from YY_CQYB_MZJSJLK(nolock) where jssjh = @jsxh and jlzt in (0,1))
		begin
			insert into YY_CQYB_MZJSJLK(jssjh,sbkh,xzlb,jzlsh,jslb,zhzfbz,zhdybz,jszzrq,gsrdbh,gsjbbm,cfjslx,
				sylb,sysj,sybfz,ncbz,rslx,dbtbz,syfwzh,jyjc,jhzh,jlzt,ddyljgbm)
			select @jsxh,@sbkh,@xzlb,@jsxh,@jslb,@zhzfbz,@zhdybz,@jszzrq,@gsrdbh,@gsjbbm,@cfjslx,
				@sylb,@sysj,@sybfz,@ncbz,@rslx,@dbtbz,@syfwzh,@jyjc,@jhzh,0,@ddyljgbm
			if @@error<>0 or @@rowcount = 0 
			begin
				select "F","保存医保门诊结算信息失败!"
				return
			end;
		end
		else
		begin
			update YY_CQYB_MZJSJLK set sbkh = @sbkh,xzlb = @xzlb,jzlsh = @jzlsh,jslb = @jslb,zhzfbz = @zhzfbz,zhdybz = @zhdybz,
				jszzrq = @jszzrq,gsrdbh = @gsrdbh,gsjbbm = @gsjbbm,cfjslx = @cfjslx,sylb = @sylb,sysj = @sysj,sybfz = @sybfz,
				ncbz = @ncbz,rslx = @rslx,dbtbz = @dbtbz,syfwzh = @syfwzh,jyjc = @jyjc,jhzh = @jhzh,ddyljgbm = @ddyljgbm
			where jssjh = @jsxh and jlzt = 0
			if @@error<>0 or @@rowcount = 0 
			begin
				select "F","更新医保门诊结算信息失败!"
				return
			end;
		end
	end
	else if @ghsfbz = 1
	begin
		if @bftfbz = 0 
		begin
			if not exists(select 1 from YY_CQYB_MZJSJLK(nolock) where jssjh = @jsxh and jlzt in (0,1))
			begin
				insert into YY_CQYB_MZJSJLK(jssjh,sbkh,xzlb,jzlsh,jslb,zhzfbz,zhdybz,jszzrq,gsrdbh,gsjbbm,cfjslx,
					sylb,sysj,sybfz,ncbz,rslx,dbtbz,syfwzh,jyjc,jhzh,jlzt,ddyljgbm)
				select @jsxh,@sbkh,@xzlb,@jsxh,@jslb,@zhzfbz,@zhdybz,@jszzrq,@gsrdbh,@gsjbbm,@cfjslx,
					@sylb,@sysj,@sybfz,@ncbz,@rslx,@dbtbz,@syfwzh,@jyjc,@jhzh,0,@ddyljgbm
				if @@error<>0 or @@rowcount = 0 
				begin
					select "F","保存医保门诊结算信息失败!"
					return
				end;
			end
			else
			begin
				update YY_CQYB_MZJSJLK set sbkh = @sbkh,xzlb = @xzlb,jzlsh = @jzlsh,jslb = @jslb,zhzfbz = @zhzfbz,zhdybz = @zhdybz,
					jszzrq = @jszzrq,gsrdbh = @gsrdbh,gsjbbm = @gsjbbm,cfjslx = @cfjslx,sylb = @sylb,sysj = @sysj,sybfz = @sybfz,
					ncbz = @ncbz,rslx = @rslx,dbtbz = @dbtbz,syfwzh = @syfwzh,jyjc = @jyjc,jhzh = @jhzh,ddyljgbm = @ddyljgbm
				where jssjh = @jsxh and jlzt = 0
				if @@error<>0 or @@rowcount = 0 
				begin
					select "F","更新医保门诊结算信息失败!"
					return
				end;
			end
		end
		else if @bftfbz = 1
		begin
			if not exists(select 1 from YY_CQYB_MZJSJLK(nolock) where jssjh = @jsxh and jlzt in (0,1))
			begin
				insert into YY_CQYB_MZJSJLK(jssjh,sbkh,xzlb,jzlsh,jslb,zhzfbz,zhdybz,jszzrq,gsrdbh,gsjbbm,cfjslx,
					sylb,sysj,sybfz,ncbz,rslx,dbtbz,syfwzh,jyjc,jhzh,jlzt,ddyljgbm)
				select @jsxh,c.sbkh,c.xzlb,@jsxh,c.jslb,c.zhzfbz,0,c.jszzrq,c.gsrdbh,c.gsjbbm,c.cfjslx,
					c.sylb,c.sysj,c.sybfz,c.ncbz,c.rslx,c.dbtbz,c.syfwzh,c.jyjc,c.jhzh,0,@ddyljgbm
				from SF_BRJSK a(nolock) inner join SF_BRJSK b(nolock) on a.tsjh = b.sjh
										inner join VW_CQYB_MZJSJLK c(nolock) on b.tsjh = c.jssjh
				where a.sjh = @jsxh
				if @@error<>0 or @@rowcount = 0 
				begin
					select "F","保存医保门诊结算信息失败!"
					return
				end;
			end;									
		end
	end
end
else if @xtbz in (2,3)
BEGIN
	IF @xtbz = 3 
	BEGIN
		IF EXISTS(SELECT 1 FROM ZY_BRSYK a(NOLOCK) WHERE a.syxh = @syxh AND a.brzt =3)
		BEGIN
			SELECT 'F','已出院结算，不能再更新信息！'
			RETURN
		END
	END

	if exists(select 1 from ZY_BRSYK (nolock) where syxh=@syxh and brzt=2 and @jslb='10')
	begin
		select "F","【出院病人医保不能做中途结算，请重新更新医保信息】"
		return
	end
	if exists(select 1 from YY_CQYB_ZYJSJLK(nolock) where syxh = @syxh and jsxh = @jsxh and jlzt = 2)
	begin
		select "F","该住院信息存在有效的医保结算信息!"
		return
	end
    
	SELECT @cyzd = a.cyzd,@bfzinfo = a.bfzinfo FROM YY_CQYB_ZYJZJLK a(NOLOCK) WHERE a.syxh = @syxh
	 
    IF (ISNULL(@jszzrq,'') = '') 
    BEGIN
    	IF EXISTS(SELECT 1 FROM ZY_BRSYK a (NOLOCK) WHERE a.syxh = @syxh AND brzt IN(2,4) AND ISNULL(LEN(cqrq),0) >=8)
		BEGIN
			SELECT @jszzrq = SUBSTRING(cqrq,1,4) + '-' + SUBSTRING(cqrq,5,2) + '-' + SUBSTRING(cqrq,7,2)
			FROM ZY_BRSYK a (NOLOCK) WHERE a.syxh = @syxh AND brzt IN(2,4) AND ISNULL(LEN(cqrq),0) >=8 		
		END		
    END
    
    IF LEN(RTRIM(@jszzrq)) = 8  SELECT @jszzrq = @jszzrq + ' 23:59:59'
    
	if not exists(select 1 from YY_CQYB_ZYJSJLK(nolock) where syxh = @syxh and jsxh = @jsxh and jlzt in (0,1,3))
	begin
		insert into YY_CQYB_ZYJSJLK(syxh,jsxh,sbkh,xzlb,jzlsh,jslb,zhzfbz,zhdybz,jsqzrq,jszzrq,gsrdbh,gsjbbm,cfjslx,
			sylb,sysj,sybfz,ncbz,rslx,dbtbz,syfwzh,jyjc,jhzh,jlzt,ddyljgbm,lrsj,cyzd,bfzinfo)
		select @syxh,@jsxh,@sbkh,@xzlb,@jzlsh,@jslb,@zhzfbz,@zhdybz,@jsqzrq,@jszzrq,@gsrdbh,@gsjbbm,@cfjslx,
			@sylb,@sysj,@sybfz,@ncbz,@rslx,@dbtbz,@syfwzh,@jyjc,@jhzh,0,@ddyljgbm,@now,@cyzd,@bfzinfo
		if @@error<>0 or @@rowcount = 0 
		begin
			select "F","保存医保住院结算信息失败!"
			return
		end;
	end
	else
	begin
		update YY_CQYB_ZYJSJLK set sbkh = @sbkh,xzlb = @xzlb,jzlsh = @jzlsh,jslb = @jslb,zhzfbz = @zhzfbz,zhdybz = @zhdybz,
			jsqzrq = @jsqzrq,jszzrq = @jszzrq,gsrdbh = @gsrdbh,gsjbbm = @gsjbbm,cfjslx = @cfjslx,sylb = @sylb,sysj = @sysj,
			sybfz = @sybfz,ncbz = @ncbz,rslx = @rslx,dbtbz = @dbtbz,syfwzh = @syfwzh,jyjc = @jyjc,jhzh = @jhzh,ddyljgbm = @ddyljgbm,
			cyzd = @cyzd,bfzinfo = @bfzinfo
		where syxh = @syxh and jsxh = @jsxh and jlzt in (0,1,3)
		if @@error<>0 or @@rowcount = 0 
		begin
			select "F","更新医保住院结算信息失败!"
			return		
		end;
	end
end

select "T"
return

go
