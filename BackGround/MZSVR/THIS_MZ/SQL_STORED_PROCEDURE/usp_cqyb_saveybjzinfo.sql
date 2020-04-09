if exists(select 1 from sysobjects where name = 'usp_cqyb_saveybjzinfo')
  drop proc usp_cqyb_saveybjzinfo
go
CREATE proc usp_cqyb_saveybjzinfo
(
	@jsxh				ut_sjh,				--结算序号
	@syxh				ut_syxh,			--首页序号
    @sbkh				varchar(20),		--社会保障号码
	@xtbz				ut_bz,				--系统标志0挂号1收费2住院登记3住院信息更新
    @xzlb				ut_bz,				--险种类别
    @cblb				ut_bz,				--参保类别
    @jzlsh				varchar(20),		--住院(或门诊)号
    @zgyllb				varchar(10),		--医疗类别
    @ksdm				ut_ksdm,			--科室代码
    @ysdm				ut_czyh,			--医生代码
    @ryrq				varchar(10),		--入院日期
    @ryzd				varchar(20),		--入院诊断
    @cyrq				varchar(10),		--出院日期
    @cyzd				varchar(20),		--出院诊断 
    @cyyy				varchar(10),		--出院原因
    @bfzinfo			varchar(200),		--并发症信息
    @jzzzysj			varchar(10),		--急诊转住院时间
    @bah				varchar(20),		--病案号
    @syzh				varchar(20),		--生育证号
    @xsecsrq			varchar(10),		--新生儿出生日期
    @jmyllb				varchar(10),		--居民特殊就诊标记
    @gsgrbh				varchar(10),		--工伤个人编号
    @gsdwbh				varchar(10),		--工伤单位编号
    @zryydm				varchar(14),		--转入医院代码
    @zxlsh              varchar(20)='',     --交易流水号
    @zhye               varchar(20)='',     --账户余额
    @yzcyymc            varchar(50)=''   --原转出医院名称       
)
as
/****************************************
[版本号]4.0.0.0.0
[创建时间]2017.03.05
[作者]FerryMan
[版权]Copyright ? 1998-2017卫宁健康科技集团股份有限公司
[描述]保存医保就诊登记信息
[功能说明]
	保存医保就诊登记信息
[参数说明]
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]
[修改记录]
****************************************/
set nocount on
	declare @now ut_rq16,@retcode varchar(10)='T',@retMsg varchar(1000)=''
	select @now=convert(char(8),getdate(),112)+convert(char(8),getdate(),8)
	if exists(select 1 from sysobjects where name = 'usp_cqyb_checkybjzxx' and xtype='P')
	begin
	exec usp_cqyb_checkybjzxx @jsxh,@syxh,@sbkh,@xtbz,@xzlb,@cblb,@jzlsh,@zgyllb,
							@ksdm,@ysdm,@ryrq,@ryzd,@cyrq,@cyzd,@cyyy,@bfzinfo,@jzzzysj,@bah,
							@syzh,@xsecsrq,@jmyllb,@gsgrbh,@gsdwbh,@zryydm,@zxlsh,@zhye,@yzcyymc,@retcode output, @retMsg output
		if @retcode='F'--如果失败直接返回提示
		begin
			select @retcode,@retMsg
			return
		end
		--R和T时，直接最后返回
	end
if @xtbz in (0,1)
begin
	declare @ghsfbz		ut_bz,	--挂号收费标志
			@bftfbz		ut_bz	--部分退费标志
			
	select @ghsfbz = ghsfbz from SF_BRJSK(nolock) where sjh = @jsxh
	if exists(select 1 from SF_BRJSK where sjh in (select tsjh from SF_BRJSK where sjh = @jsxh))
		select @bftfbz = 1
	else
		select @bftfbz = 0
	
	if exists(select 1 from YY_CQYB_MZJZJLK where jssjh = @jsxh and jlzt = 1)
	begin
		select "F","该门诊信息存在有效的医保登记信息!"
		return
	end
	--更新SF_BRJSK中的medtype
	update SF_BRJSK set medtype = 
	CASE WHEN @cblb IN (1,3,4) THEN @zgyllb WHEN @cblb IN (2,5) THEN @jmyllb ELSE medtype END	
	where sjh =@jsxh

	if @ghsfbz = 0 
	begin 
		select @ryrq = substring(ghrq,1,4)+'-'+substring(ghrq,5,2)+'-'+substring(ghrq,7,2),@ksdm = isnull(ksdm,""),
			   @ysdm = isnull(ysdm,"") 
		from GH_GHZDK(nolock) where jssjh = @jsxh
		if not exists(select 1 from YY_CQYB_MZJZJLK where jssjh = @jsxh and jlzt = 0)
		begin
			insert into YY_CQYB_MZJZJLK(jssjh,sbkh,xzlb,cblb,jzlsh,zgyllb,ksdm,ysdm,ryrq,ryzd,cyrq,cyzd,cyyy,bfzinfo,
				jzzzysj,bah,syzh,xsecsrq,jmyllb,gsgrbh,gsdwbh,zryydm,jlzt)
			select @jsxh,@sbkh,@xzlb,@cblb,@jsxh,@zgyllb,@ksdm,@ysdm,@ryrq,@cyzd,@ryrq,@cyzd,@cyyy,@bfzinfo,
				@jzzzysj,@bah,@syzh,@xsecsrq,@jmyllb,@gsgrbh,@gsdwbh,@zryydm,0
			if @@error<>0 or @@rowcount = 0 
			begin
				select "F","保存医保门诊登记信息失败!"
				return
			end;
		end
		else
		begin
			update YY_CQYB_MZJZJLK set sbkh = @sbkh,xzlb = @xzlb,cblb = @cblb,jzlsh = @jzlsh,zgyllb = @zgyllb,ksdm = @ksdm,ysdm = @ysdm,
				ryrq = @ryrq,ryzd = @cyzd,cyrq = @ryrq,cyzd = @cyzd,cyyy = @cyyy,bfzinfo = @bfzinfo,jzzzysj = @jzzzysj,
				bah = @bah,syzh = @syzh,xsecsrq = @xsecsrq,jmyllb = @jmyllb,gsgrbh = @gsgrbh,gsdwbh = @gsdwbh,zryydm = @zryydm
			where jssjh = @jsxh and jlzt = 0
			if @@error<>0 or @@rowcount = 0 
			begin
				select "F","更新医保门诊登记信息失败!"
				return
			end;
		end
	end
	else if @ghsfbz = 1
	begin
		if @bftfbz = 0 
		begin
			select @ryrq = substring(a.sfrq,1,4)+'-'+substring(a.sfrq,5,2)+'-'+substring(a.sfrq,7,2),
				@ksdm = isnull(b.ksdm,""),@ysdm = isnull(b.ysdm,"") 
			from SF_BRJSK a(nolock) inner join SF_MZCFK b(nolock) on a.sjh = b.jssjh
			where sjh = @jsxh
			
			if not exists(select 1 from YY_CQYB_MZJZJLK where jssjh = @jsxh and jlzt = 0)
			begin
				insert into YY_CQYB_MZJZJLK(jssjh,sbkh,xzlb,cblb,jzlsh,zgyllb,ksdm,ysdm,ryrq,ryzd,cyrq,cyzd,cyyy,bfzinfo,
					jzzzysj,bah,syzh,xsecsrq,jmyllb,gsgrbh,gsdwbh,zryydm,jlzt)
				select @jsxh,@sbkh,@xzlb,@cblb,@jsxh,@zgyllb,@ksdm,@ysdm,@ryrq,@cyzd,@ryrq,@cyzd,@cyyy,@bfzinfo,
					@jzzzysj,@bah,@syzh,@xsecsrq,@jmyllb,@gsgrbh,@gsdwbh,@zryydm,0
				if @@error<>0 or @@rowcount = 0 
				begin
					select "F","保存医保门诊登记信息失败!"
					return
				end;
			end
			else
			begin
				update YY_CQYB_MZJZJLK set sbkh = @sbkh,xzlb = @xzlb,cblb = @cblb,jzlsh = @jzlsh,zgyllb = @zgyllb,ksdm = @ksdm,ysdm = @ysdm,
				ryrq = @ryrq,ryzd = @cyzd,cyrq = @ryrq,cyzd = @cyzd,cyyy = @cyyy,bfzinfo = @bfzinfo,jzzzysj = @jzzzysj,
				bah = @bah,syzh = @syzh,xsecsrq = @xsecsrq,jmyllb = @jmyllb,gsgrbh = @gsgrbh,gsdwbh = @gsdwbh,zryydm = @zryydm
				where jssjh = @jsxh and jlzt = 0
				if @@error<>0 or @@rowcount = 0 
				begin
					select "F","更新医保门诊登记信息失败!"
					return
				end;
			end;
		end
		else if @bftfbz = 1
		begin
			select @ryrq = substring(sfrq,1,4)+'-'+substring(sfrq,5,2)+'-'+substring(sfrq,7,2)
			from SF_BRJSK(nolock) where sjh = @jsxh
			
			if not exists(select 1 from YY_CQYB_MZJZJLK where jssjh = @jsxh and jlzt = 0)
			begin
				insert into YY_CQYB_MZJZJLK(jssjh,sbkh,xzlb,cblb,jzlsh,zgyllb,ksdm,ysdm,ryrq,ryzd,cyrq,cyzd,cyyy,bfzinfo,
					jzzzysj,bah,syzh,xsecsrq,jmyllb,gsgrbh,gsdwbh,zryydm,jlzt)
				select @jsxh,c.sbkh,c.xzlb,c.cblb,@jsxh,c.zgyllb,c.ksdm,c.ysdm,@ryrq,c.ryzd,@ryrq,c.cyzd,c.cyyy,c.bfzinfo,
					c.jzzzysj,c.bah,c.syzh,c.xsecsrq,c.jmyllb,c.gsgrbh,c.gsdwbh,c.zryydm,0
				from SF_BRJSK a(nolock) inner join SF_BRJSK b(nolock) on a.tsjh = b.sjh
										inner join VW_CQYB_MZJZJLK c(nolock) on b.tsjh = c.jssjh
				where a.sjh = @jsxh
			end
		end
	end
end
else if @xtbz = 2
begin
	if exists(select 1 from YY_CQYB_ZYJZJLK where syxh = @syxh and jlzt = 1)
	begin
		select "F","该住院信息存在有效的医保登记信息!"
		return
	end

	select @ksdm = isnull(ksdm,""),@ysdm = isnull(ysdm,"") from ZY_BRSYK(nolock) where syxh = @syxh
	
	if isnull(@ryrq,"") = "" 
		select @ryrq = dbo.fun_convertrq_cqyb(0,'')
		
	if not exists(select 1 from YY_CQYB_ZYJZJLK where syxh = @syxh and jlzt = 0)
	begin
		--医保转自费再转医保的时候保留必要的信息
		select top (1) @ryzd= CASE WHEN ISNULL(@ryzd,'') = '' 
								   THEN CASE WHEN SUBSTRING(ryzd,1,5) = 'RJSS.' THEN '' ELSE ryzd END 
		                           ELSE @ryzd END,
					   @cyzd=cyzd,@bfzinfo=bfzinfo 
		FROM YY_CQYB_ZYJZJLK(nolock) 
		WHERE syxh = @syxh and jlzt = 3 order by lrsj DESC
        
		insert into YY_CQYB_ZYJZJLK(syxh,sbkh,xzlb,cblb,jzlsh,zgyllb,ksdm,ysdm,ryrq,ryzd,cyrq,cyzd,cyyy,bfzinfo,
			jzzzysj,bah,syzh,xsecsrq,jmyllb,gsgrbh,gsdwbh,zryydm,jlzt,lrsj)
		select @syxh,@sbkh,@xzlb,@cblb,dbo.fun_getybzyh_cqyb(0,@syxh),@zgyllb,@ksdm,@ysdm,@ryrq,@ryzd,@cyrq,@cyzd,@cyyy,@bfzinfo,
			@jzzzysj,@bah,@syzh,@xsecsrq,@jmyllb,@gsgrbh,@gsdwbh,@zryydm,0,@now
		if @@error<>0 or @@rowcount = 0 
		begin
			select "F","保存医保住院登记信息失败!"
			return
		end;
	end
	else
	begin
		if isnull(@jzlsh,"") = ""
		    select @jzlsh = dbo.fun_getybzyh_cqyb(0,@syxh)
		 
		update YY_CQYB_ZYJZJLK set sbkh = @sbkh,xzlb = @xzlb,cblb = @cblb,jzlsh = @jzlsh,zgyllb = @zgyllb,ksdm = @ksdm,ysdm = @ysdm,
				ryrq = @ryrq,ryzd = @ryzd,cyrq = @cyrq,cyzd = @cyzd,cyyy = @cyyy,bfzinfo = @bfzinfo,jzzzysj = @jzzzysj,
				bah = @bah,syzh = @syzh,xsecsrq = @xsecsrq,jmyllb = @jmyllb,gsgrbh = @gsgrbh,gsdwbh = @gsdwbh,zryydm = @zryydm
		where syxh = @syxh and jlzt = 0
		if @@error<>0 or @@rowcount = 0 
		begin
			select "F","更新医保住院登记信息失败!"
			return
		end;
	end;
end
else if @xtbz = 3
begin
	if not exists(select 1 from YY_CQYB_ZYJZJLK where syxh = @syxh and jlzt = 1)
	begin
		select "F","该住院信息没有有效的医保登记信息!"
		return
	end
	
	update YY_CQYB_ZYJZJLK set sbkh = @sbkh,xzlb = @xzlb,cblb = @cblb,jzlsh = @jzlsh,zgyllb = @zgyllb,ksdm = @ksdm,ysdm = @ysdm,
			ryrq = @ryrq,ryzd = @ryzd,cyrq = @cyrq,cyzd = @cyzd,cyyy = @cyyy,bfzinfo = @bfzinfo,jzzzysj = @jzzzysj,
			bah = @bah,syzh = @syzh,xsecsrq = @xsecsrq,jmyllb = @jmyllb,gsgrbh = @gsgrbh,gsdwbh = @gsdwbh,zryydm = @zryydm
	where syxh = @syxh and jlzt = 1
	if @@error<>0 or @@rowcount = 0 
	begin
		select "F","更新医保住院登记信息失败!"
		return
	end;
end

select @retcode,@retMsg
return
GO
