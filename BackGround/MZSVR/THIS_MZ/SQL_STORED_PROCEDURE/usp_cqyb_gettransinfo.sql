Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE proc usp_cqyb_gettransinfo
(
  @code		varchar(15),	--交易代码
  @jsxh		ut_sjh,			--结算收据号
  @syxh		ut_syxh,		--首页序号
  @xtbz		ut_bz,			--系统标志0挂号1收费2住院
  @cxbz		ut_bz,			--查询标志0登记信息1结算信息
  @zgdm		ut_czyh,		--操作员号
  @jzrq		varchar(20)=''	--截止日期
)
as --集317365 2018-01-16 02:55:28 单独版
/**********************
[版本号]4.0.0.0.0
[创建时间]2017.03.05
[作者]FerryMan
[版权]Copyright ? 1998-2017卫宁健康科技集团股份有限公司
[描述]获取医保交易参数
[功能说明]
	HIS获取医保交易参数
[参数说明]
@code	交易代码
@jssjh	收据号
@syxh	首页序号
@xtbz	系统标志0挂号1收费2住院
@zgdm	操作员号
[返回值]
[结果集、排序]
[调用的sp]
[调用实例] 
[修改纪录]
**********************/       
set nocount on    
    
declare @hisbm	varchar(10),			--HIS开放商编码
		@fyze	ut_money,				--费用总额
		@qzrq	ut_rq16,				--费用起止日期
		@zzrq	ut_rq16,				--费用终止日期
		@cqrq	ut_rq16,				--出区日期
		@mxts	int,					--费用明细条数
		@zmxts	int,					--正费用明细条数
		@fmxts	int,					--负费用明细条数
		@zyts	int,					--住院床日
		@ysdm	ut_czyh,				--医生代码
		@ysmc	ut_name,				--医生名称
		@gxbz	varchar(16),			--更新标志
		@cyrq	varchar(10),			--出院日期
		@zybz	ut_bz,					--转院标志
		@czym	ut_name, 				--操作员名
		@gcys	ut_czyh,					--管床医生
		@errmsg varchar(150),
        @ryrq_old ut_rq16,	--老处方收费日期 
		@jsxh_temp varchar(30),
		@cfrq_old ut_rq16	--老处方收费日期
		,@sjh_ysjl ut_sjh
		,@configCQ31 VARCHAR(10)  --住院自定义审批诊断审批不通过的不允许医保登记和医保结算
		,@configCQ32 VARCHAR(10)  --住院自定义药品，诊疗未审批不能结算
		,@configCQ36 VARCHAR(10)
		,@configCQ39 VARCHAR(10)
		,@configCQ40 VARCHAR(10)
		,@configCQ18 VARCHAR(10)
		,@now ut_rq16		--当前时间
		,@zjldj ut_money
		,@strSql VARCHAR(500)
		,@configCQ01 VARCHAR(10)
		,@configCQ49 VARCHAR(10)
		,@gcys_mc VARCHAR(20)
		,@ydbz VARCHAR(3)  --异地医保标志
		,@configCQ19 VARCHAR(10)
		,@configCQ50 VARCHAR(10)
		,@m_mrsfzh varchar(20) --默认的身份证号
		,@configCQ58 VARCHAR(10)
        ,@patid numeric(12)
		,@configCQ64 VARCHAR(10)
		,@dbzdzje NUMERIC(12,2)
		,@ybshbz INT
		,@ybcyzdshbz INT

select @now=convert(char(8),getdate(),112)+convert(char(8),getdate(),8),@m_mrsfzh='50000020170901TY05'
--HIS开放商编码		
select @hisbm = '00114'

--操作员名
select @czym = name from czryk where id = @zgdm 
SELECT @configCQ36 = ISNULL(config,'1') FROM YY_CONFIG(NOLOCK) WHERE id= 'CQ36'
    IF @configCQ36 = ''  SELECT @configCQ36 = '1'       

SELECT @configCQ39 = ISNULL(config,'1') FROM YY_CONFIG(NOLOCK) WHERE id= 'CQ39'
    IF ISNULL(@configCQ39,'') = ''  SELECT @configCQ39 = '197827'  
SELECT @configCQ40 = ISNULL(config,'1') FROM YY_CONFIG(NOLOCK) WHERE id= 'CQ40'
    IF ISNULL(@configCQ40,'') = ''  SELECT @configCQ40 = '67790' 

SELECT @configCQ18 = ISNULL(config,'1') FROM YY_CONFIG(NOLOCK) WHERE id= 'CQ18'
    IF @configCQ18 = ''  SELECT @configCQ18 = '1'  

SELECT @configCQ01 = ISNULL(config,'') FROM YY_CONFIG(NOLOCK) WHERE id= 'CQ01'
    IF @configCQ01 = ''  SELECT 'F','请先设置CQ01参数！' 

SELECT @configCQ49 = ISNULL(config,'否') FROM YY_CONFIG(NOLOCK) WHERE id= 'CQ49'
    IF ISNULL(@configCQ49,'') = ''  SELECT @configCQ49 = '否' 

SELECT @configCQ58 = ISNULL(config,'否') FROM YY_CONFIG(NOLOCK) WHERE id= 'CQ58'
    IF ISNULL(@configCQ58,'') = ''  SELECT @configCQ58 = '否' 
create table #tempdcxg 
( 
	sjh_ysjl varchar(20)
)

if @code = '02'		--就诊登记       
begin   
    --门诊登记
	if @xtbz in (0,1)
	BEGIN
		IF @xtbz = 0 
		BEGIN
			IF EXISTS(SELECT 1 FROM GH_GHZDK(nolock) WHERE jssjh = @jsxh AND ghlb = 9)
			BEGIN
				SELECT @ryrq_old = czrq FROM GH_GHZDK(nolock) WHERE jssjh = @jsxh AND ghlb = 9 	
			END
		END
  		  
		if @xtbz in(1)
		BEGIN
            select @patid = patid from SF_BRJSK(NOLOCK) WHERE sjh = @jsxh 
		    select * into #vw_mzbrjsk_02 from VW_MZBRJSK(NOLOCK) WHERE patid = @patid
		    
			select @ryrq_old = '',@jsxh_temp = @jsxh
			WHILE exists(select 1 from #vw_mzbrjsk_02(NOLOCK) where sjh = @jsxh_temp and isnull(tsjh,'') <> '')
			begin
				SELECT @ryrq_old = sfrq ,@jsxh_temp = sjh from #vw_mzbrjsk_02(NOLOCK) 
				WHERE sjh in (select tsjh from #vw_mzbrjsk_02(NOLOCK) where sjh in (select tsjh from #vw_mzbrjsk_02(NOLOCK) where sjh = @jsxh_temp))
				--重庆地区物价调整修改
				--if @ryrq_old > '2017090900:00:00'
				--	select @ryrq_old = ''
			end
						
			--由于附一增加调出修改的sjh取原始收据号的处方日期作为处方日期 
			if  exists(select 1 from syscolumns where id=object_id('SF_BRJSK') and name='sjh_ysjl')
			begin
				EXEC('insert into #tempdcxg select isnull(sjh_ysjl,"") sjh_ysjl from #vw_mzbrjsk_02(nolock) where sjh = "'+@jsxh+'"')
				select @sjh_ysjl = isnull(sjh_ysjl,'') from #tempdcxg
				if @sjh_ysjl <> ''
				begin
					select @ryrq_old = sfrq from #vw_mzbrjsk_02(NOLOCK) where sjh = @sjh_ysjl
				end
			end
		end
		
		select "T", a.jzlsh,						--1 门诊号/住院号
					case when a.zgyllb = '' then (case when a.jmyllb = '13' then '13' when a.jmyllb = '15' then '13' else '11' end) else a.zgyllb end,
												--2 医疗类别
					a.sbkh,						--3	社保卡号
					a.ksdm,						--4 科室编码
					--case when isnull(ltrim(b.sfzh),'')='' THEN @m_mrsfzh ELSE b.sfzh END sfzh,--5 医生编码--update by winning-dingsong-chongqing on 20200820
					case when isnull(ltrim(dbo.fun_getyssfzh(a.jssjh,'MZ')),'')='' THEN @m_mrsfzh ELSE dbo.fun_getyssfzh(a.jssjh,'MZ') END sfzh,
					(case when isnull(@ryrq_old,'')='' then a.ryrq else dbo.fun_convertrq_cqyb(2,@ryrq_old) end),						--6 入院日期
					a.ryzd,						--7 入院诊断
					@czym as jbr,				--8 经办人
					a.bfzinfo,					--9 并发症
					a.jzzzysj,					--10 急诊转住院发生时间
					a.bah,						--11 病案号
					a.syzh,						--12 生育证号码
					a.xsecsrq,					--13 新生儿出生日期
					case when a.jmyllb = '' then (case when a.zgyllb = '13' then '13' else '12' end) else a.jmyllb end,						
												--14 居民特殊就诊标记
					a.xzlb,						--15 险种类别
					a.gsgrbh,					--16 工伤个人编号
					a.gsdwbh					--17 工伤单位编号
		from YY_CQYB_MZJZJLK a(nolock) left join YY_ZGBMK b(nolock) on a.ysdm = b.id
		where a.jssjh = @jsxh and a.jlzt = 0
	end
	--住院登记
	else if @xtbz = 2
	BEGIN
	    SELECT @configCQ31 = '是'
	    SELECT @configCQ31 = config FROM YY_CONFIG(nolock) WHERE id = 'CQ31'
	    IF @configCQ31 = '是'
	    begin
			if not exists(select 1 from YY_CQYB_ZDYZDSPJG(nolock) WHERE syxh = @syxh)
			begin
				if exists(select 1 FROM ZY_BRSYK a(nolock) inner join VW_CQYB_ZYBRRYZD b(nolock) on a.syxh = b.syxh
														   inner join YY_CQYB_ZDYSPXM c(nolock) on b.zddm = c.xmdm AND c.xmlb = '2'
					where a.syxh = @syxh and a.brzt not in (3,8,9))
				begin
					select "F","该病人为外伤病人,医保办尚未审核,不能进行市医保登记！"
					return	
				end								     
			end
			else
			begin
				if exists(select 1 FROM YY_CQYB_ZDYZDSPJG(nolock) where syxh = @syxh AND isnull(spjg,'0') = 2)
				begin
					select "F","该病人已被医保科标记为诊断不符合医保报销，不能进行市医保登记！"
					return
				end
				if exists(select 1 FROM YY_CQYB_ZDYZDSPJG(nolock) where syxh = @syxh AND isnull(spjg,'0') = 0)
				begin
					select "F","该病人是否符合医保报销需要医保办审批，不能进行市医保登记！"
					return
				end
			end
	    end
        
		IF EXISTS(SELECT 1 FROM YY_CQYB_ZYJZJLK a(NOLOCK) ,YY_CQYB_PATINFO b(NOLOCK) WHERE a.sbkh = b.sbkh AND ISNULL(b.dqfprylb,'') <> '')
            UPDATE a SET a.pkhbz = 1 FROM ZY_BRXXK a,ZY_BRSYK b(nolock) WHERE a.patid = b.patid AND b.syxh = @syxh
		ELSE
		    UPDATE a SET a.pkhbz = 0 FROM ZY_BRXXK a,ZY_BRSYK b(nolock) WHERE a.patid = b.patid AND b.syxh = @syxh
if @syxh='116494'
begin 

select "T", a.jzlsh,						--1 门诊号/住院号
					case when ISNULL(a.zgyllb,'')='' then a.jmyllb else a.zgyllb end zgyllb,						--2 医疗类别
					a.sbkh,						--3	社保卡号
					a.ksdm,						--4 科室编码
					--isnull((select top 1 (case when isnull(ltrim(b.sfzh),'')='' then @m_mrsfzh else b.sfzh end) 
					--from ZY_BRSYK c(nolock), YY_ZGBMK b(NOLOCK) 
					--where (case when isnull(ysdm,'')<>'' then c.ysdm else c.mzzdys end)=b.id 
					--and a.syxh=c.syxh),@m_mrsfzh),	--5 医生编码--update by winning-dingsong-chongqing on 20200820
					case when isnull(ltrim(dbo.fun_getyssfzh(a.syxh,'ZY')),'')='' THEN @m_mrsfzh ELSE dbo.fun_getyssfzh(a.syxh,'ZY') END sfzh,
					'2019-11-29'ryrq,						--6 入院日期
					a.ryzd,						--7 入院诊断
					@czym as jbr,				--8 经办人
					a.bfzinfo,					--9 并发症
					a.jzzzysj,					--10 急诊转住院发生时间
					a.bah,						--11 病案号
					a.syzh,						--12 生育证号码
					a.xsecsrq,					--13 新生儿出生日期
					case when ISNULL(a.jmyllb,'')='' then a.zgyllb else a.jmyllb END jmyllb,					--14 居民特殊就诊标记
					a.xzlb,						--15 险种类别
					a.gsgrbh,					--16 工伤个人编号
					a.gsdwbh					--17 工伤单位编号
		from YY_CQYB_ZYJZJLK a(nolock) --left join YY_ZGBMK b(nolock) on a.ysdm = b.id
		where a.syxh = @syxh and a.jlzt = 0
end
else
		select "T", a.jzlsh,						--1 门诊号/住院号
					case when ISNULL(a.zgyllb,'')='' then a.jmyllb else a.zgyllb end zgyllb,						--2 医疗类别
					a.sbkh,						--3	社保卡号
					a.ksdm,						--4 科室编码
					--isnull((select top 1 (case when isnull(ltrim(b.sfzh),'')='' then @m_mrsfzh else b.sfzh end) 
					--from ZY_BRSYK c(nolock), YY_ZGBMK b(NOLOCK) 
					--where (case when isnull(ysdm,'')<>'' then c.ysdm else c.mzzdys end)=b.id 
					--and a.syxh=c.syxh),@m_mrsfzh),	--5 医生编码--update by winning-dingsong-chongqing on 20200820
					case when isnull(ltrim(dbo.fun_getyssfzh(a.syxh,'ZY')),'')='' THEN @m_mrsfzh ELSE dbo.fun_getyssfzh(a.syxh,'ZY') END sfzh,
					a.ryrq,						--6 入院日期
					a.ryzd,						--7 入院诊断
					@czym as jbr,				--8 经办人
					a.bfzinfo,					--9 并发症
					a.jzzzysj,					--10 急诊转住院发生时间
					a.bah,						--11 病案号
					a.syzh,						--12 生育证号码
					a.xsecsrq,					--13 新生儿出生日期
					case when ISNULL(a.jmyllb,'')='' then a.zgyllb else a.jmyllb END jmyllb,					--14 居民特殊就诊标记
					a.xzlb,						--15 险种类别
					a.gsgrbh,					--16 工伤个人编号
					a.gsdwbh					--17 工伤单位编号
		from YY_CQYB_ZYJZJLK a(nolock) --left join YY_ZGBMK b(nolock) on a.ysdm = b.id
		where a.syxh = @syxh and a.jlzt = 0
	end;      
end   
else if @code = '03'	--更新就诊信息
BEGIN  
	if @xtbz in (0,1)
	BEGIN		
		IF @xtbz = 0 
		BEGIN
			IF EXISTS(SELECT 1 FROM GH_GHZDK(nolock) WHERE jssjh = @jsxh AND ghlb = 9)
			BEGIN
				SELECT @ryrq_old = czrq FROM GH_GHZDK(nolock) WHERE jssjh = @jsxh AND ghlb = 9 	
			END
		END
		
		IF @xtbz in (1)
		BEGIN
            select @patid = patid from SF_BRJSK(NOLOCK) WHERE sjh = @jsxh 
		    select * into #vw_mzbrjsk_03 from VW_MZBRJSK(NOLOCK) WHERE patid = @patid

			select @ryrq_old = '',@jsxh_temp = @jsxh
			WHILE exists(select 1 from #vw_mzbrjsk_03(NOLOCK) where sjh = @jsxh_temp and isnull(tsjh,'') <> '')
			begin
				SELECT @ryrq_old = sfrq ,@jsxh_temp = sjh from #vw_mzbrjsk_03(NOLOCK) 
				WHERE sjh in (select tsjh from #vw_mzbrjsk_03(NOLOCK) where sjh in (select tsjh from #vw_mzbrjsk_03(NOLOCK) where sjh = @jsxh_temp))
				--重庆地区物价调整修改
				--if @ryrq_old > '2017090900:00:00'
					--select @ryrq_old = ''
			end
			
			--由于附一增加调出修改的sjh取原始收据号的处方日期作为处方日期 
			if  exists(select 1 from syscolumns where id=object_id('SF_BRJSK') and name='sjh_ysjl')
			begin
				EXEC('insert into #tempdcxg select isnull(sjh_ysjl,"") sjh_ysjl from #vw_mzbrjsk_03 where sjh = "'+@jsxh+'"')
				select @sjh_ysjl = isnull(sjh_ysjl,'') from #tempdcxg
				if @sjh_ysjl <> ''
				begin
					select @ryrq_old = sfrq from #vw_mzbrjsk_03(NOLOCK) where sjh = @sjh_ysjl
				end
			end
		end
		
		if exists(select 1 from YY_CQYB_MZJZJLK(nolock)  where jssjh = @jsxh and jlzt in (0,1) and isnull(cyzd,'') <> '')
			select @gxbz = '0000011000000000'
		else
			select @gxbz = '0000010000000000';
		
		IF @configCQ01 = 'DR'
		BEGIN
			select "T", jzlsh,						--1 门诊号/住院号
						@gxbz as gxbz,				--2 更新标志
						case when zgyllb = '' then (case when jmyllb = '13' then '13' when jmyllb = '15' then '13' else '11' end) else zgyllb end,
													--3 医疗类别
						ksdm,						--4 科室编码
						--case when isnull(ltrim(b.sfzh),'')='' then @m_mrsfzh else b.sfzh end,--5 医生编码--update by winning-dingsong-chongqing on 20200820
					case when isnull(ltrim(dbo.fun_getyssfzh(a.jssjh,'MZ')),'')='' THEN @m_mrsfzh ELSE dbo.fun_getyssfzh(a.jssjh,'MZ') END sfzh,
						(case when isnull(@ryrq_old,'')='' then ryrq else dbo.fun_convertrq_cqyb(2,@ryrq_old) end),	--6 入院日期
						ryzd,						--7 入院诊断
						CASE WHEN (@xtbz = 0) AND (isnull(@ryrq_old,'') <> '') THEN dbo.fun_convertrq_cqyb(2,@ryrq_old) 
						ELSE cyrq END,				--8 出院日期
						cyzd,						--9 出院诊断
						cyyy,						--10 出院原因
						@czym as jbr,				--11 经办人
						bfzinfo,					--12 并发症
						bah,						--13 病案号
						syzh,						--14 生育证号码
						xsecsrq,					--15 新生儿出生日期
						case when jmyllb = '' then (case when zgyllb = '13' then '13' else '12' end) else jmyllb end,						
													--16 居民特殊就诊标记
						xzlb,						--17 险种类别
						zryydm 						--18 转入医院编码
			from YY_CQYB_MZJZJLK a(nolock) left join YY_ZGBMK b(nolock) on a.ysdm = b.id
			where jssjh = @jsxh and a.jlzt in (0,1)
		END
        ELSE
        BEGIN
            select "T", jzlsh,						--1 门诊号/住院号
						SUBSTRING(@gxbz,1,15) as gxbz,				--2 更新标志
						case when zgyllb = '' then (case when jmyllb = '13' then '13' when jmyllb = '15' then '13' else '11' end) else zgyllb end,
													--3 医疗类别
						ksdm,						--4 科室编码
						--case when isnull(ltrim(b.sfzh),'')='' then @m_mrsfzh else b.sfzh end,--5 医生编码--update by winning-dingsong-chongqing on 20200820
					case when isnull(ltrim(dbo.fun_getyssfzh(a.jssjh,'MZ')),'')='' THEN @m_mrsfzh ELSE dbo.fun_getyssfzh(a.jssjh,'MZ') END sfzh,
						(case when isnull(@ryrq_old,'')='' then ryrq else dbo.fun_convertrq_cqyb(2,@ryrq_old) end),	--6 入院日期
						ryzd,						--7 入院诊断
						CASE WHEN (@xtbz IN (0,1) ) AND (isnull(@ryrq_old,'') <> '') THEN dbo.fun_convertrq_cqyb(2,@ryrq_old) 
						ELSE cyrq END,				--8 出院日期
						cyzd,						--9 出院诊断
						cyyy,						--10 出院原因
						@czym as jbr,				--11 经办人
						bfzinfo,					--12 并发症
						bah,						--13 病案号
						syzh,						--14 生育证号码
						xsecsrq,					--15 新生儿出生日期
						case when jmyllb = '' then (case when zgyllb = '13' then '13' else '12' end) else jmyllb end,						
													--16 居民特殊就诊标记
						xzlb						--17 险种类别
			from YY_CQYB_MZJZJLK a(nolock) left join YY_ZGBMK b(nolock) on a.ysdm = b.id
			where jssjh = @jsxh and a.jlzt in (0,1)
		END
	end
	else if @xtbz = 3
	begin
		declare @zgjmbz	ut_bz,					--职工居民标志
				@ryzd	varchar(20),			--入院诊断
				@brzt	ut_bz,					--病人状态
				@cyyy	ut_bz					--出院原因
				,@gxryzd_bz	varchar(2)='0'			--更新入院诊断标志
				,@gxcyrq_bz varchar(2)='0'		--更新出院日期标志
				,@03cyrq varchar(20)=''			--判断出院日期
		
		select @zgjmbz = cblb,
			   @gxryzd_bz=case when isnull(ltrim(ryzd),'')='' then '0' else '1' end, 
			   @03cyrq=isnull(ltrim(cyrq),'')
		from YY_CQYB_ZYJZJLK(nolock) where syxh = @syxh and jlzt = 1

		select @brzt = brzt from ZY_BRSYK(nolock) where syxh = @syxh 
		IF @brzt =3 
		BEGIN
			SELECT 'F','已出院结算，不能再更新信息！'
			RETURN
		END

		select @ryzd = zdmc from ZY_BRZDQK(nolock) where syxh = @syxh and zdlb = 1 and zdlx = 0
		 
		
		if @brzt in (2,4) 
		begin
			select @gxcyrq_bz='1'
			select @cyrq = dbo.fun_convertrq_cqyb(2,a.cqrq),@cyyy = a.cyfs
			from ZY_BRSYK a(nolock) where a.syxh = @syxh and a.brzt not in (3,8,9)
		end
		else
		begin--出院日期标志看情况更新
			if EXISTS(select 1 from YY_CQYB_ZYJSJLK a(nolock) where a.syxh=@syxh and a.jsxh=@jsxh and a.jlzt in(0,1) and a.jslb='0') and isnull(ltrim(@03cyrq),'')<>''
			begin
			--jlzt in(0,1) and jslb='0' HIS中途结算，医保正常结算的流程
			----03cyrq<>'',单独请求在院病人没有勾中途结算时间，cyrq会为空
				select @gxcyrq_bz='1'
			end
			else
				select @gxcyrq_bz='0'
			SELECT @cyrq = dbo.fun_convertrq_cqyb(2,convert(varchar(8),dateadd(day,-1,getdate()),112)),@cyyy = '9'
		END

         if @zgjmbz in (1,3)
			    select @gxbz = '1110'+@gxryzd_bz+@gxcyrq_bz+'1111110000'
		else
				select @gxbz = '0110'+@gxryzd_bz+@gxcyrq_bz+'1111110100'
		--处理出院原因对照转换
		IF EXISTS (SELECT 1 FROM YY_CQYB_YBSJZD_DZ a(NOLOCK) WHERE a.zdlb = 'CYYY')
		BEGIN
            SELECT @cyyy = CASE WHEN ISNULL(a.ybcode,'') <> '' THEN a.ybcode ELSE '9' END 
			FROM YY_CQYB_YBSJZD_DZ a(NOLOCK)
			WHERE a.zdlb = 'CYYY' AND a.hiscode = @cyyy
		END

		DECLARE @tmp_zddm			VARCHAR(20),	--诊断代码
				@tmp_bfzinfo			VARCHAR(200)	--并发症信息
		
		IF NOT EXISTS(SELECT 1 FROM VW_CQYB_ZYBRZDQK(nolock) WHERE syxh = @syxh AND zdlb IN (2,4) AND zdlx  = 0)
		BEGIN
			select @tmp_zddm = ''
		END
		ELSE
		BEGIN
			SELECT @tmp_zddm = zddm FROM VW_CQYB_ZYBRZDQK(nolock) WHERE syxh = @syxh AND zdlb IN (2,4) AND zdlx  = 0
		END
		IF NOT EXISTS(SELECT 1 FROM VW_CQYB_ZYBRBFZ(nolock) WHERE syxh = @syxh)
		BEGIN
			SELECT @tmp_bfzinfo = '';	
		END
		ELSE
		BEGIN
			SELECT @tmp_bfzinfo = bfz FROM VW_CQYB_ZYBRBFZ(nolock) WHERE syxh = @syxh
		END

	--winning-dingsong-chongqing-add on 20200311 begin
		--获取出院诊断中的辅助诊断为并发症
		if(replace(@tmp_bfzinfo,' ','')='')
		begin
			declare @zdms varchar(64),@bfz varchar(200)=''
			DECLARE cursor_ZY_BRZDQK CURSOR FOR --定义游标
			SELECT  zdms from ZY_BRZDQK where syxh =@syxh and  zdlb = 2 and zdlx<>0 order by zdlx 
			OPEN cursor_ZY_BRZDQK --打开游标
			FETCH NEXT FROM cursor_ZY_BRZDQK INTO  @zdms
			WHILE @@FETCH_STATUS = 0
			begin
			select @bfz=@bfz+case len(@bfz) when 0 then '' else '  ' end+@zdms
			FETCH NEXT FROM cursor_ZY_BRZDQK INTO  @zdms
			end
			CLOSE cursor_ZY_BRZDQK --关闭游标
			DEALLOCATE cursor_ZY_BRZDQK --释放游标
			select @tmp_bfzinfo=@bfz
			--print @bfz
		end
		--winning-dingsong-chongqing-add on 20200311 end
		if @cxbz = 0 
		begin
			select "T", b.sbkh,					--1 社保卡号
						b.xzlb,					--2 险种类别
						b.cblb,					--3 参保类别
						b.jzlsh,				--4 就诊流水号
						b.zgyllb,				--5 医疗类别
						b.ryrq,					--6 入院日期
						case when isnull(b.ryzd,'')='' then  @ryzd else b.ryzd end as ryzd,			--7 入院诊断	
						@cyrq as cyrq,			--8 出院日期						
						case when b.cyzd = '' then @tmp_zddm else b.cyzd end as cyzd,	--9 出院诊断		
						@cyyy AS cyyy,     --10 出院原因
case when isnull(replace(b.bfzinfo,' ',''),'') = ''  then @tmp_bfzinfo else b.bfzinfo end as bfzinfo,   --11 并发症
						b.bah,					--12 病案号
						b.syzh,					--13 生育证号码
						b.xsecsrq,				--14 新生儿出生日期
						b.jmyllb, 				--15 居民特殊就诊标记
						b.zhye,                 --16 账户余额
						b.yzcyymc               --17 原转出医院名称
			from ZY_BRSYK a(nolock)
				inner join YY_CQYB_ZYJZJLK b(nolock) on a.syxh = b.syxh and b.jlzt = 1
			where a.syxh = @syxh and a.brzt not in (3,8,9)
		end
		else
		if @cxbz = 1
		begin
			if exists(select 1 from YY_CONFIG(nolock) where id='CQ51' and config='是') and  @gxryzd_bz='0'
			begin
				select "F","必须录入入院诊断"
				RETURN	 
			end
			if @configCQ01 = 'DR'
			begin
				select "T", b.jzlsh,			--1 门诊号/住院号
							@gxbz as gxbz,		--2 更新标志
							b.zgyllb,			--3 医疗类别
							a.ksdm,				--4 科室编码
							--case when isnull(ltrim(c.sfzh),'')='' then @m_mrsfzh else c.sfzh end,	--5 医生编码isnull(c.sfzh,'50000020170901TY05')--update by winning-dingsong-chongqing on 20200820
					case when isnull(ltrim(dbo.fun_getyssfzh(a.syxh,'ZY')),'')='' THEN @m_mrsfzh ELSE dbo.fun_getyssfzh(a.syxh,'ZY') END sfzh,
							b.ryrq,				--6 入院日期
							b.ryzd,				--7 入院诊断
							b.cyrq,				--8 出院日期
							b.cyzd,				--9 出院诊断
							b.cyyy as cyyy,		--10 出院原因
							@czym as jbr,		--11 经办人
							b.bfzinfo ,			--12 并发症
							b.bah,				--13 病案号
							b.syzh,				--14 生育证号码
							b.xsecsrq,			--15 新生儿出生日期
							b.jmyllb,			--16 居民特殊就诊标记
							b.xzlb,				--17 险种类别
							b.zryydm 			--18 转入医院编码
				from ZY_BRSYK a(nolock) inner join YY_CQYB_ZYJZJLK b(nolock) on a.syxh = b.syxh and b.jlzt = 1
										left join YY_ZGBMK c(nolock) on a.ysdm = c.id
				where a.syxh = @syxh and brzt not in (3,8,9)
			end
			else IF @configCQ01 = 'WD'
			begin
				select @gxbz = substring(@gxbz,1,15);
				IF EXISTS(SELECT 1 FROM ZY_BRSYK(nolock) WHERE syxh = @syxh AND cardno LIKE '#%')
				BEGIN
					SELECT @ydbz = '1';
				END
				IF @ydbz = '1'  --万达异地生育证号不更新
				BEGIN
				    SELECT @gxbz = SUBSTRING(@gxbz,1,11) + '0' + SUBSTRING(@gxbz,13,3)
				END 
				select "T", b.jzlsh,			--1 门诊号/住院号
							@gxbz as gxbz,		--2 更新标志
							b.zgyllb,			--3 医疗类别
							a.ksdm,				--4 科室编码
							--case when isnull(ltrim(c.sfzh),'')='' then @m_mrsfzh else c.sfzh end,--5 医生编码--update by winning-dingsong-chongqing on 20200820
					case when isnull(ltrim(dbo.fun_getyssfzh(a.syxh,'ZY')),'')='' THEN @m_mrsfzh ELSE dbo.fun_getyssfzh(a.syxh,'ZY') END sfzh,
							b.ryrq,				--6 入院日期
							b.ryzd,				--7 入院诊断
							b.cyrq,				--8 出院日期
							CASE ISNULL(b.cyzd,'') WHEN '' THEN 'J00 03' ELSE b.cyzd END cyzd,				--9 出院诊断
							CASE ISNULL(b.cyyy,'') WHEN  '' THEN '9' ELSE b.cyyy END as cyyy,				--10 出院原因
							@czym as jbr,		--11 经办人
							case b.xzlb when '3' then 
							case ISNULL(b.bfzinfo,'') when '' then '无' else b.bfzinfo end 
							else
							case ISNULL(b.bfzinfo,'') when '' then @tmp_bfzinfo else b.bfzinfo end   
							end,				--12 并发症
							--CASE WHEN ISNULL(b.bfzinfo,'')='' and b.xzlb = '3' THEN '无' ELSE b.bfzinfo END ,			--12 并发症
							CASE WHEN ISNULL(b.bah,'') = '' THEN a.blh ELSE b.bah END ,				--13 病案号
							b.syzh,				--14 生育证号码
							b.xsecsrq,			--15 新生儿出生日期
							b.jmyllb,			--16 居民特殊就诊标记
							b.xzlb				--17 险种类别
				from ZY_BRSYK a(nolock) inner join YY_CQYB_ZYJZJLK b(nolock) on a.syxh = b.syxh and b.jlzt = 1
										inner join YY_ZGBMK c(nolock) on a.ysdm = c.id
				where a.syxh = @syxh and brzt not in (3,8,9)			
			end
		end
	end
end            
else if @code = '04'	--添加处方明细       
begin        
	create table #temp_fymx        
    (        
		jzlsh		varchar(18)	not null,			--1 门诊号/住院号
		cfh			varchar(20)     null,			--2 处方号
		cfrq		varchar(20)     null,			--3 处方日期
		ybbm		varchar(10)     null,			--4 项目医保流水号
		xmdm		varchar(20)     null,			--5 医院收费项目内码
		xmmc		varchar(50)     null,			--6 医院收费项目名称
		xmdj		ut_money		null,			--7 单价
		xmsl		ut_sl10			null,			--8 数量
		jzbz		varchar(3)      null,			--9 急诊标志
		cfys		varchar(50)     null,			--10 处方医生
		jbr			varchar(20)     null,			--11 经办人
		xmdw		varchar(20)     null,			--12 单位
		xmgg		varchar(50)     null,			--13 规格
		xmjx		varchar(20)     null,			--14 剂型
		zxlsh		varchar(20)     null,			--15 冲消明细流水号
		xmje		ut_money	    null,			--16 金额
		ksdm		varchar(10)		null,			--17 科室编码
		ksmc		varchar(40)     null,			--18 科室名称
		ysbm		varchar(20)		null,			--19 医师编码
		mcyl		varchar(20)		null,			--20 每次用量
		yfbz		varchar(20)     null,			--21 用法标准
		zxzq		varchar(20)		null,			--22 执行周期
		xzlb		varchar(10)     null,			--23 险种类别
		zzfbz		varchar(10)		null,    		--24 转自费标识
		dcyyjl		VARCHAR(20)		null,    		--25单次用药剂量
		dcyyjldw	VARCHAR(10)		null,    		--26单次用药剂量单位
		dcyl		VARCHAR(20)		null,    		--27单次用量
		zxjldw		VARCHAR(20)		null,    		--28最小计量单位
		qyzl		VARCHAR(20)		null,    		--29取药总量
		yytj		VARCHAR(10)		null,    		--30用药途径
		sypc		VARCHAR(10)		null,    		--31使用频次
		shid		VARCHAR(50)		null,    		--32审核 ID
		mxxh		ut_xh12		not null			--明细序号
     )         
           
    --门诊挂号    
    if @xtbz = 0      
	BEGIN
		IF EXISTS(SELECT 1 FROM GH_GHZDK(nolock) WHERE jssjh = @jsxh AND ghlb = 9)
		BEGIN
			SELECT @ryrq_old = czrq FROM GH_GHZDK(nolock) WHERE jssjh = @jsxh AND ghlb = 9 	
		END
			        
		select @ysdm = isnull(ysdm,"") from GH_GHZDK(nolock) where jssjh = @jsxh and isnull(ysdm,"") <> ''
		
		if ltrim(rtrim(@ysdm)) = ''
		begin
			select 'f','挂号医生代码不能为空'
			return
		end
		else
		    select @ysmc = name from YY_ZGBMK(nolock) where id = @ysdm
		   
		insert into #temp_fymx(jzlsh,cfh,cfrq,ybbm,xmdm,xmmc,xmdj,xmsl,jzbz,cfys,jbr,xmdw,xmgg,xmjx,zxlsh,xmje,
			ksdm,ksmc,ysbm,mcyl,yfbz,zxzq,xzlb,zzfbz,mxxh)
		select a.jzlsh,c.xh,CASE WHEN (@xtbz = 0) AND (isnull(@ryrq_old,'') <> '') 
			THEN dbo.fun_convertrq_cqyb(1,@ryrq_old) ELSE dbo.fun_convertrq_cqyb(1,b.ghrq) END,
			(case when isnull(d.dydm,'') = '' then '67790' else d.dydm end),
			c.xmdm,c.xmmc,c.xmdj-c.yhdj,c.xmsl,'0',@ysmc,
			@czym,d.xmdw,d.xmgg,'','',(c.xmdj-c.yhdj)*c.xmsl,b.ksdm,b.ksmc,@ysdm,'','','',a.xzlb,'',c.xh
		from YY_CQYB_MZJZJLK a(nolock) 
			inner join GH_GHZDK b(nolock) on a.jssjh = b.jssjh
			inner join GH_GHMXK c(nolock) on b.xh = c.ghxh and c.xmdj>0 AND c.xmsl > 0 --0费用不上传
			inner join YY_SFXXMK d(nolock) on c.xmdm = d.id
		where a.jssjh = @jsxh

		update #temp_fymx set cfys=case when @xtbz=0 then '普通门诊医师' else cfys end  where isnull(cfys,'')=''--挂号没挂在医生上就默认

		--将dydm返回的未上传明细的dydm保存到中间表中,在处方上传完哪里不好搞，所以放在这里来保存
		UPDATE a SET a.dydm = b.ybbm,
					 a.scxmdj = b.xmdj,
					 a.scxmsl = b.xmsl,
					 a.scxmje = b.xmje					      
		FROM GH_GHMXK a(NOLOCK),#temp_fymx b,GH_GHZDK c(NOLOCK) 
		WHERE a.ghxh = c.xh and a.xh = b.mxxh AND c.jssjh = @jsxh  
		IF @@ERROR <> 0 
		BEGIN
            SELECT 'F','保存dydm失败'
			RETURN
		END
	end      
	--门诊收费 
	else if @xtbz = 1        
	begin     
	    select @patid = patid from SF_BRJSK(NOLOCK) WHERE sjh = @jsxh 
		select * into #vw_mzbrjsk_04 from VW_MZBRJSK(NOLOCK) WHERE patid = @patid

		select @cfrq_old = '',@jsxh_temp = @jsxh
		
		--由于由于医改，部分退费医改之前的数据取原始记录的收费日期作为处方日期 
		WHILE exists(select 1 from #vw_mzbrjsk_04(NOLOCK) where sjh = @jsxh_temp and isnull(tsjh,'') <> '')
		BEGIN
			SELECT @cfrq_old = sfrq ,@jsxh_temp = sjh from #vw_mzbrjsk_04(NOLOCK) 
			  WHERE sjh in (select tsjh from #vw_mzbrjsk_04(NOLOCK) where sjh in (select tsjh from #vw_mzbrjsk_04(NOLOCK) where sjh = @jsxh_temp))
			--重庆地区物价调整修改
			--if @cfrq_old > '2017090900:00:00'
			--	select @cfrq_old = ''
		END

		--由于附一增加调出修改的sjh取原始收据号的处方日期作为处方日期 
        if  exists(select 1 from syscolumns where id=object_id('SF_BRJSK') and name='sjh_ysjl')
		BEGIN
		    EXEC('insert into #tempdcxg select isnull(sjh_ysjl,"") sjh_ysjl from #vw_mzbrjsk_04 where sjh = "'+@jsxh+'"')
			select @sjh_ysjl = isnull(sjh_ysjl,'') from #tempdcxg
			IF @sjh_ysjl <> ''
			BEGIN
                SELECT @cfrq_old = sfrq from #vw_mzbrjsk_04(NOLOCK) WHERE sjh = @sjh_ysjl
				--if @cfrq_old > '2017090900:00:00'
				--    SELECT @cfrq_old = ''
			END
		END
		--旧版本存储过程合并
		if(@cfrq_old<'2020010100:00:00')
		select @cfrq_old = ''

		insert into #temp_fymx(jzlsh,cfh,cfrq,ybbm,xmdm,xmmc,xmdj,xmsl,jzbz,cfys,jbr,xmdw,xmgg,xmjx,zxlsh,xmje,
			ksdm,ksmc,ysbm,mcyl,yfbz,zxzq,xzlb,zzfbz,dcyyjl,dcyyjldw,dcyl,zxjldw,qyzl,yytj,sypc,shid,mxxh)
		select a.jzlsh,(case when g.ypbz=3 then c.cfxh else c.xh end),
			dbo.fun_convertrq_cqyb(1,case when isnull(@cfrq_old,'') <> '' then @cfrq_old else b.lrrq end),
			(case when isnull(d.dydm,'') = '' then '197827' else d.dydm end),c.cd_idm,
			SUBSTRING(CONVERT(VARCHAR(50),c.ypmc),1,50) xmmc,
				round((c.ylsj-c.yhdj)*(case when isnull(ltrim(h.shid),'') not in('0','','9999999999') then c.dwxs else 1 end)/c.ykxs,4),
				c.ypsl*c.cfts/(case when isnull(ltrim(h.shid),'') not in('0','','9999999999') then c.dwxs else 1 end),
			'0',f.name,@czym,d.zxdw,c.ypgg,i.name,'',
			round((c.ylsj-c.yhdj)*c.ypsl*c.cfts/c.ykxs,2),b.ksdm,e.name,b.ysdm,'','','',a.xzlb,ISNULL(h.ybzzfbz,0),
			CONVERT(VARCHAR(20),ROUND(ISNULL(h.ypjl,0),2)) as dcyyjl , --单次用药剂量
			(select TOP 1 k.ybcode FROM YY_CQYB_YBSJZD_DZ k(nolock) where k.zdlb = 'DCJLDW' 
				AND k.hiscode=(SELECT TOP 1 j.id FROM YY_UNIT j(NOLOCK) WHERE j.lb = 1 AND j.name = h.jldw ))  as dcyyjldw,  --单次用药剂量单位
			SUBSTRING(CONVERT(VARCHAR(50),ISNULL(convert(decimal(18,2),h.ypjl/d.ggxs),0)),1,20) AS dcyl ,         --单次用量
			(select TOP 1 k.ybcode FROM YY_CQYB_YBSJZD_DZ k(nolock) where k.zdlb = 'ZXJLDW' 
				AND k.hiscode=(SELECT TOP 1 n.id FROM YY_UNIT n(NOLOCK) WHERE n.lb = 0 AND n.name = z.zxdw )) as zxjldw ,       --最小计量单位
			CONVERT(VARCHAR(20),CONVERT(NUMERIC(16,4),round(c.cfts*c.ts*c.ypsl/c.dwxs,2))) as qyzl,  --取药总量
			CASE ISNULL(h.ypyf,'') WHEN '' THEN '900' ELSE 
			(select TOP 1 k.ybcode FROM YY_CQYB_YBSJZD_DZ k(nolock) where k.zdlb = 'YYTJ' AND k.hiscode = h.ypyf) END as yytj,      --用药途径
			CASE ISNULL(h.pcdm,'') WHEN '' THEN '61' ELSE
			(select TOP 1 k.ybcode FROM YY_CQYB_YBSJZD_DZ k(NOLOCK) WHERE k.zdlb = 'SYPC' AND k.hiscode = h.pcdm) END AS sypc,      --使用频次
			ISNULL(h.shid,'9999999999') shid,
			c.xh
		from YY_CQYB_MZJZJLK a(nolock) 
			inner join SF_MZCFK b(nolock) on a.jssjh = b.jssjh
			inner join SF_CFMXK c(nolock) on b.xh = c.cfxh and c.cd_idm <> 0
			inner join YY_SFDXMK g(nolock) on c.dxmdm=g.id
			inner join YK_YPCDMLK d(nolock) on c.cd_idm = d.idm
			left join YY_KSBMK e(nolock) on a.ksdm = e.id
			left join YY_ZGBMK f(nolock) on a.ysdm = f.id
			LEFT JOIN SF_HJCFMXK h(NOLOCK) ON h.xh = c.hjmxxh
			LEFT JOIN YK_YPJXK i(NOLOCK) ON d.jxdm = i.id
			LEFT JOIN YK_YPGGMLK z(NOLOCK) ON c.gg_idm = z.idm
		where a.jssjh = @jsxh and a.jlzt = 1
		
		insert into #temp_fymx(jzlsh,cfh,cfrq,ybbm,xmdm,xmmc,xmdj,xmsl,jzbz,cfys,jbr,xmdw,xmgg,xmjx,zxlsh,xmje,
			ksdm,ksmc,ysbm,mcyl,yfbz,zxzq,xzlb,zzfbz,dcyyjl,dcyyjldw,dcyl,zxjldw,qyzl,yytj,sypc,shid,mxxh)
		select a.jzlsh,c.xh,dbo.fun_convertrq_cqyb(1,case when isnull(@cfrq_old,'') <> '' then @cfrq_old else b.lrrq end),
			(case when isnull(d.dydm,'') = '' then '67790' else d.dydm end),
            c.ypdm,SUBSTRING(CONVERT(VARCHAR(50),c.ypmc),1,50) xmmc,round((c.ylsj-c.yhdj)/c.ykxs,4),
			c.ypsl*c.cfts,'0',f.name,@czym,c.ypdw,c.ypgg,'','',round((c.ylsj-c.yhdj)*c.ypsl*c.cfts/c.ykxs,4),
			b.ksdm,e.name,b.ysdm,'','','',a.xzlb,ISNULL(h.ybzzfbz,0),
			'' as dcyyjl,'' as dcyyjldw,'' as dcyl,'' as zxjldw,'' as qyzl ,'' as yytj ,'' as sypc,
			CASE WHEN ISNULL(c.lcxmdm,'0')= '0' OR ISNULL(c.lcxmdm,'') = '' THEN ISNULL(h.shid,'9999999999') 
				 WHEN ISNULL(dbo.fun_cqyb_getlcxmshid(h.shid,c.ypdm),'') <> '' THEN dbo.fun_cqyb_getlcxmshid(h.shid,c.ypdm)
				 ELSE ISNULL(h.shid,'9999999999') 
			END AS shid,--ISNULL(h.shid,'9999999999') shid,
			c.xh
		from YY_CQYB_MZJZJLK a(nolock) 
			inner join SF_MZCFK b(nolock) on a.jssjh = b.jssjh
			inner join SF_CFMXK c(nolock) on b.xh = c.cfxh and c.cd_idm = 0 
			and (c.zje<>0 or round((c.ylsj-c.yhdj)/c.ykxs,4)*c.ypsl*c.cfts<>0)--0费用不上传
			inner join YY_SFXXMK d(nolock) on c.ypdm = d.id
			left join YY_KSBMK e(nolock) on a.ksdm = e.id
			left join YY_ZGBMK f(nolock) on a.ysdm = f.id
			LEFT JOIN SF_HJCFMXK h(NOLOCK) ON h.xh = c.hjmxxh
		where a.jssjh = @jsxh and a.jlzt = 1  
		
		--将dydm返回的未上传明细的dydm保存到中间表中,在处方上传完哪里不好搞，所以放在这里来保存
		UPDATE a SET a.dydm = b.ybbm,
					 a.scxmdj = b.xmdj,
					 a.scxmsl = b.xmsl,
					 a.scxmje = b.xmje					      
		FROM SF_CFMXK a(NOLOCK),#temp_fymx b,SF_MZCFK c(NOLOCK),SF_BRJSK d(NOLOCK) 
		WHERE a.cfxh = c.xh AND c.jssjh = d.sjh and a.xh = b.mxxh AND d.sjh = @jsxh  
		IF @@ERROR <> 0 
		BEGIN
            SELECT 'F','保存dydm失败'
			RETURN
		END       
	end
	--住院结算
	else --if @xtbz in (2,3,4)
	begin	
		--费用起止日期
		select @qzrq = replace(ryrq,'-','') + '00:00:00' from YY_CQYB_ZYJZJLK(nolock) where syxh = @syxh and jlzt = 1
		select @qzrq = ksrq from ZY_BRJSK(nolock) where xh = @jsxh
		--费用截止日期
		/*
		if @jzrq = ''
			select @zzrq = convert(varchar(8),getdate(),112) + '23:59:59'
		else
		begin
	        IF len(rtrim(@jzrq))=8  --兼容未扩展前老数据
			   select @zzrq = @jzrq + '23:59:59'
			else
			   select @zzrq = @jzrq 
  	    END
        */
        select @zzrq = 
			CASE when ISNULL(jszzrq,'') = '' THEN  
				CASE WHEN b.brzt not IN ('2','4') THEN @now ELSE b.cqrq  end
			else  
				CASE LEN(RTRIM(a.jszzrq)) when 10 THEN REPLACE(a.jszzrq,'-','') + '23:59:59' ELSE REPLACE(REPLACE(a.jszzrq,'-',''),' ','') end 
			end
		FROM YY_CQYB_ZYJSJLK a(nolock),ZY_BRSYK b(NOLOCK) WHERE a.syxh = b.syxh and a.syxh = @syxh and a.jsxh = @jsxh and a.jlzt in (0,1,3)
        if isnull(@zzrq,'') = ''
			select @zzrq = @now

		if @cxbz = 0	--费用汇总信息
		begin
			---declare @errmsg varchar(50)  
			exec usp_cqyb_zyfymxcl @syxh,@jsxh,0,@errmsg out  
			if substring(@errmsg,1,1)='F'   
			begin  
				select 'F',@errmsg  
				return  
			end  
			
			if exists(select 1 from ZY_BRSYK(nolock) where syxh = @syxh and brzt in (2,4))
			begin
				select @cqrq = isnull(cqrq,'') from ZY_BRSYK(nolock) where syxh = @syxh and brzt in (2,4)
				
				if exists(select 1 from YY_CQYB_ZYFYMXK(nolock) where syxh = @syxh and jsxh = @jsxh and cfrq > @cqrq) 
					and @cqrq <> ''
				begin
					update YY_CQYB_ZYFYMXK set cfrq = @cqrq where syxh = @syxh and jsxh = @jsxh and cfrq > @cqrq
					if @@error <> 0 
					begin
						select 'F','更新YY_CQYB_ZYFYMXK中的cfrq出错!';
						return
					end
				end
			end
			
			--处理医保已上传的费用明细begin
			IF EXISTS(select 1 from syscolumns where id=object_id('ZY_BRFYMXK') and name='mxlsh')
			BEGIN
			    IF EXISTS (SELECT 1 FROM ZY_BRSYK(nolock) WHERE syxh = @syxh AND centerid LIKE 'zy%')
				BEGIN
					select * into #temp_fymxk from ZY_BRFYMXK(nolock) where syxh = @syxh and jsxh = @jsxh
					update a set ybscbz = 0
					from YY_CQYB_ZYFYMXK a(nolock) inner join #temp_fymxk b(nolock) on a.xh = b.xh and b.scbz in (-1,0,3,4)
					where a.syxh = @syxh and a.jsxh = @jsxh and a.ybscbz not in (0,1)
			
					update a set ybscbz = 1,zxlsh = b.mxlsh
					from YY_CQYB_ZYFYMXK a(nolock) inner join #temp_fymxk b(nolock) on a.xh = b.xh and b.scbz = 1
					where a.syxh = @syxh and a.jsxh = @jsxh and a.ybscbz <> 1
				END
			END
			--处理医保已上传的费用明细end
			
			IF @configCQ49 = '否'
			begin
				select @mxts = count(1) from YY_CQYB_ZYFYMXK (nolock) 
				where syxh = @syxh and jsxh = @jsxh and isnull(ybscbz,0) = 0 and cfrq between @qzrq and @zzrq
			
				select @zmxts= count(1) from YY_CQYB_ZYFYMXK (nolock) 
				where syxh = @syxh and jsxh = @jsxh and isnull(ybscbz,0) = 0 and xmje > 0 and cfrq between @qzrq and @zzrq
			
				select @fmxts= count(1) from YY_CQYB_ZYFYMXK (nolock) 
				where syxh = @syxh and jsxh = @jsxh and isnull(ybscbz,0) = 0 and xmje < 0 and cfrq between @qzrq and @zzrq
		    END
            ELSE
            BEGIN
                select @mxts = 0
			
				select @zmxts= count(1) from YY_CQYB_ZYFYMXK (nolock) 
				where syxh = @syxh and jsxh = @jsxh and isnull(ybscbz,0) in (0,5) and xmje > 0 and cfrq between @qzrq and @zzrq
			
				select @fmxts= 0

				SELECT @mxts = @zmxts + @fmxts
			end
			select "T",@mxts as mxts,@zmxts as zmxts,@fmxts as fmxts
			return
		end
		else if @cxbz = 1	--费用明细信息
		begin
			insert into #temp_fymx(jzlsh,cfh,cfrq,ybbm,xmdm,xmmc,xmdj,xmsl,jzbz,cfys,jbr,xmdw,xmgg,xmjx,zxlsh,xmje,
				ksdm,ksmc,ysbm,mcyl,yfbz,zxzq,xzlb,zzfbz,mxxh)
				select a.jzlsh,b.cfh,dbo.fun_convertrq_cqyb(1,b.cfrq),
					dbo.fun_cqyb_getzydydm(b.xh,b.idm,@configCQ36,@configCQ39,@configCQ40) ,
					b.idm,SUBSTRING(CONVERT(VARCHAR(50),b.xmmc),1,50) xmmc,b.xmdj,(CASE b.ybscbz WHEN 5 THEN b.ktsl ELSE b.xmsl END) xmsl,b.jzbz,f.name,@czym,c.zxdw,b.xmgg,d.name,'',
					(CASE b.ybscbz WHEN 5 THEN b.ktje ELSE b.xmje END) xmje,b.ksdm,e.name,b.ysdm,
					'','','',a.xzlb,
					CASE WHEN @configCQ36 <> '3' THEN '0' ELSE dbo.fun_cqyb_getzyybzzfbz(b.xh) END,
					b.xh
				from YY_CQYB_ZYJZJLK a(nolock) 
					inner join YY_CQYB_ZYFYMXK b(nolock) on a.syxh = b.syxh and b.jsxh = @jsxh and idm <> 0 and xmje > 0
														and isnull(b.ybscbz,0) in (0,5) and b.cfrq between @qzrq and @zzrq
					inner join YK_YPCDMLK c(nolock) on b.idm = c.idm
					left join YK_YPJXK d(nolock) on c.jxdm = d.id
					left join YY_KSBMK e(nolock) on b.ksdm = e.id
					left join YY_ZGBMK f(nolock) on b.ysdm = f.id
					INNER JOIN ZY_BRFYMXK h(nolock) ON b.xh = h.xh
					LEFT JOIN YY_CQYB_ZDYSPFYMX i(NOLOCK) ON b.xh=i.xh
				where a.syxh = @syxh and a.jlzt = 1
			
			insert into #temp_fymx(jzlsh,cfh,cfrq,ybbm,xmdm,xmmc,xmdj,xmsl,jzbz,cfys,jbr,xmdw,xmgg,xmjx,zxlsh,xmje,
				ksdm,ksmc,ysbm,mcyl,yfbz,zxzq,xzlb,zzfbz,mxxh)
				select a.jzlsh,b.cfh,dbo.fun_convertrq_cqyb(1,b.cfrq),
					dbo.fun_cqyb_getzydydm(b.xh,b.idm,@configCQ36,@configCQ39,@configCQ40) ,
					b.xmdm,SUBSTRING(CONVERT(VARCHAR(50),b.xmmc),1,50) xmmc,b.xmdj,(CASE b.ybscbz WHEN 5 THEN b.ktsl ELSE b.xmsl END) xmsl,b.jzbz,e.name,@czym,c.xmdw,'','','',
					(CASE b.ybscbz WHEN 5 THEN b.ktje ELSE b.xmje END) xmje,b.ksdm,d.name,b.ysdm,
					'','','',a.xzlb,
					CASE WHEN @configCQ36 <> '3' THEN '0' ELSE dbo.fun_cqyb_getzyybzzfbz(b.xh) END,
					b.xh
				from YY_CQYB_ZYJZJLK a(nolock) 
					inner join YY_CQYB_ZYFYMXK b(nolock) on a.syxh = b.syxh and b.jsxh = @jsxh and idm = 0 and xmje > 0
														and isnull(b.ybscbz,0) IN (0,5) AND b.cfrq between @qzrq and @zzrq
					inner join YY_SFXXMK c(nolock) on b.xmdm = c.id
					left join YY_KSBMK d(nolock) on b.ksdm = d.id
					left join YY_ZGBMK e(nolock) on b.ysdm = e.id
					inner join ZY_BRFYMXK h(nolock) on b.xh=h.xh
					LEFT JOIN YY_CQYB_ZDYSPFYMX i(NOLOCK) ON b.xh=i.xh
				where a.syxh = @syxh and a.jlzt = 1
		end
		else if @cxbz = 2
		begin
			insert into #temp_fymx(jzlsh,cfh,cfrq,ybbm,xmdm,xmmc,xmdj,xmsl,jzbz,cfys,jbr,xmdw,xmgg,xmjx,zxlsh,xmje,
				ksdm,ksmc,ysbm,mcyl,yfbz,zxzq,xzlb,zzfbz,mxxh)
				select a.jzlsh,b.cfh,dbo.fun_convertrq_cqyb(1,b.cfrq),
				    dbo.fun_cqyb_getzydydm(b.xh,b.idm,@configCQ36,@configCQ39,@configCQ40),
					b.idm,SUBSTRING(CONVERT(VARCHAR(50),b.xmmc),1,50) xmmc,b.xmdj,b.xmsl,b.jzbz,f.name,@czym,c.zxdw,b.xmgg,d.name,b.zxlsh,b.xmje,b.ksdm,e.name,b.ysdm,
					'','','',a.xzlb,
					CASE WHEN @configCQ36 <> '3' THEN '0' ELSE dbo.fun_cqyb_getzyybzzfbz(b.xh) END,
					b.xh
				from YY_CQYB_ZYJZJLK a(nolock) 
					inner join YY_CQYB_ZYFYMXK b(nolock) on a.syxh = b.syxh and b.jsxh = @jsxh and idm <> 0 and xmje < 0
														and isnull(b.ybscbz,0) = 0 and b.cfrq between @qzrq and @zzrq
					inner join YK_YPCDMLK c(nolock) on b.idm = c.idm
					left join YK_YPJXK d(nolock) on c.jxdm = d.id
					left join YY_KSBMK e(nolock) on b.ksdm = e.id
					left join YY_ZGBMK f(nolock) on b.ysdm = f.id
					inner join ZY_BRFYMXK h(nolock) on b.xh=h.xh
					LEFT JOIN YY_CQYB_ZDYSPFYMX i(NOLOCK) ON b.xh=i.xh
				where a.syxh = @syxh and a.jlzt = 1
			 
			insert into #temp_fymx(jzlsh,cfh,cfrq,ybbm,xmdm,xmmc,xmdj,xmsl,jzbz,cfys,jbr,xmdw,xmgg,xmjx,zxlsh,xmje,
				ksdm,ksmc,ysbm,mcyl,yfbz,zxzq,xzlb,zzfbz,mxxh)
				select a.jzlsh,b.cfh,dbo.fun_convertrq_cqyb(1,b.cfrq),
					dbo.fun_cqyb_getzydydm(b.xh,b.idm,@configCQ36,@configCQ39,@configCQ40) ,
					b.xmdm,SUBSTRING(CONVERT(VARCHAR(50),b.xmmc),1,50) xmmc,b.xmdj,b.xmsl,b.jzbz,e.name,@czym,c.xmdw,'','',b.zxlsh,b.xmje,b.ksdm,d.name,b.ysdm,
					'','','',a.xzlb,
					CASE WHEN @configCQ36 <> '3' THEN '0' ELSE dbo.fun_cqyb_getzyybzzfbz(b.xh) END,
					b.xh
				from YY_CQYB_ZYJZJLK a(nolock) 
					inner join YY_CQYB_ZYFYMXK b(nolock) on a.syxh = b.syxh and b.jsxh = @jsxh and idm = 0 and xmje < 0
														and isnull(b.ybscbz,0) = 0 and b.cfrq between @qzrq and @zzrq
					inner join YY_SFXXMK c(nolock) on b.xmdm = c.id
					left join YY_KSBMK d(nolock) on b.ksdm = d.id
					left join YY_ZGBMK e(nolock) on b.ysdm = e.id
					inner join ZY_BRFYMXK h(nolock) on b.xh=h.xh
					LEFT JOIN YY_CQYB_ZDYSPFYMX i(NOLOCK) ON b.xh=i.xh
				where a.syxh = @syxh and a.jlzt = 1
			
			update #temp_fymx set zxlsh = c.zxlsh
			from #temp_fymx a inner join YY_CQYB_ZYFYMXK b(nolock) on b.syxh = @syxh and b.jsxh = @jsxh and a.mxxh = b.xh
							  inner join YY_CQYB_ZYFYMXK c(nolock) on b.syxh = c.syxh and b.jsxh = c.jsxh and b.txh = c.xh
		end

		select @gcys = isnull(a.ysdm,'null'),@gcys_mc = isnull(b.name,'null') from ZY_BRSYK a(nolock),YY_ZGBMK b(NOLOCK) WHERE a.ysdm = b.id AND a.syxh = @syxh
		
        update #temp_fymx set ysbm = @gcys from #temp_fymx a WHERE ISNULL(a.ysbm,'') = ''
		update #temp_fymx set cfys = @gcys_mc from #temp_fymx a WHERE ISNULL(a.cfys,'') = ''
		update #temp_fymx set ysbm = @gcys
		from #temp_fymx a INNER join YY_ZGBMK b(nolock) on a.ysbm = b.id AND (isnull(b.sfzh,'') = '' or b.cfbz <> '1')

		DECLARE @i_fjl INTEGER,@count_fjl INTEGER ,@xh_fjl INTEGER,@txh INTEGER,@idm ut_xh9,@dydm VARCHAR(20),@cfrq_z VARCHAR(19),@cfrq_f VARCHAR(19) ,@cfh_z ut_xh12  
  
		SELECT IDENTITY(int ,1,1) i,mxxh,cfrq INTO #temp_fymx_fjl FROM #temp_fymx a WHERE a.xmje < 0
		SELECT @i_fjl=1 ,@count_fjl = 0 
		SELECT @count_fjl = COUNT(1) FROM #temp_fymx_fjl
    
		WHILE @i_fjl <= @count_fjl
		BEGIN
			SELECT @xh_fjl = mxxh,@cfrq_f = cfrq FROM #temp_fymx_fjl WHERE i = @i_fjl
			--找到负记录对应的正记录xh
			SELECT @txh = a.txh,@idm = a.idm FROM YY_CQYB_ZYFYMXK a(NOLOCK) WHERE a.xh = @xh_fjl  
			--找到负记录对应的正记录xh的医保转自费标识
			UPDATE #temp_fymx SET zzfbz = (SELECT zzfbz FROM #temp_fymx WHERE mxxh = @txh) WHERE mxxh = @xh_fjl

			IF @idm = 0 
			begin
				SELECT @dydm = dbo.fun_cqyb_getzydydm(b.xh,b.idm,@configCQ36,@configCQ39,@configCQ40)
					,@cfrq_z = dbo.fun_convertrq_cqyb(1,b.cfrq) ,@zjldj = b.xmdj
					,@cfh_z = @txh
				FROM YY_CQYB_ZYFYMXK b(NOLOCK) INNER JOIN YY_SFXXMK c(NOLOCK) ON b.xmdm = c.id
											   LEFT JOIN  YY_CQYB_ZDYSPFYMX i(NOLOCK) ON b.xh = i.xh
											   INNER JOIN ZY_BRFYMXK h(NOLOCK) ON b.xh = h.xh AND h.syxh = b.syxh
				WHERE b.xh = @txh AND b.syxh = @syxh
			end
			ELSE
			begin
				SELECT @dydm = dbo.fun_cqyb_getzydydm(b.xh,b.idm,@configCQ36,@configCQ39,@configCQ40)
					,@cfrq_z = dbo.fun_convertrq_cqyb(1,b.cfrq),@zjldj = b.xmdj
					,@cfh_z = CASE d.ypbz WHEN 3 THEN b.cfh ELSE @txh END
				FROM YY_CQYB_ZYFYMXK b(NOLOCK) INNER JOIN YK_YPCDMLK c(NOLOCK) ON b.idm = c.idm
											   LEFT JOIN  YY_CQYB_ZDYSPFYMX i(NOLOCK) ON b.xh = i.xh
											   INNER JOIN ZY_BRFYMXK h(NOLOCK) ON b.xh = h.xh AND h.syxh = b.syxh
											   INNER JOIN YY_SFDXMK d(NOLOCK) ON d.id = h.dxmdm
				WHERE b.xh = @txh AND b.syxh = @syxh
			END
        
			UPDATE #temp_fymx SET ybbm = @dydm,xmdj = @zjldj WHERE mxxh = @xh_fjl

			IF @cfrq_f < @cfrq_z 
				UPDATE #temp_fymx SET cfrq=@cfrq_z WHERE mxxh= @xh_fjl

			IF @configCQ01 = 'WD'  --万达负记录处方号要求是原正记录的处方号 石柱测试发现
			BEGIN
				UPDATE #temp_fymx SET cfrq=@cfrq_z WHERE mxxh= @xh_fjl
				UPDATE #temp_fymx SET cfh =@cfh_z WHERE mxxh = @xh_fjl 
			END
        
			SELECT @i_fjl = @i_fjl + 1
		END

		--将dydm返回的未上传明细的dydm保存到中间表中,在处方上传完哪里不好搞，所以放在这里来保存
		UPDATE a SET a.dydm = b.ybbm,
					 a.scxmdj = b.xmdj,
					 a.scxmsl = b.xmsl,
					 a.scxmje = b.xmje,	
					 a.zzfbz = b.zzfbz				      
		FROM YY_CQYB_ZYFYMXK a(NOLOCK),#temp_fymx b 
		WHERE a.syxh = @syxh and a.xh = b.mxxh AND ISNULL(a.ybscbz,0) = 0
		IF @@ERROR <> 0 
		BEGIN
            SELECT 'F','保存dydm失败'
			RETURN
		END
	end           
	 
	if exists(select 1 from #temp_fymx where isnull(ybbm,'') = '')  
	begin
		select 'F','药品或项目【'+xmmc+'】未对照，请先完成医保项目对照后再结算!' from #temp_fymx where isnull(ybbm,'') = ''
		return
	end
       
	update #temp_fymx set dcyyjl = '' where isnull(ltrim(dcyyjldw),'')='' --单次用药剂量单位为空的时候不传单次剂量    
	update #temp_fymx set dcyl = '' where isnull(ltrim(zxjldw),'')='' --最小剂量单位为空的时候不传单次剂量

	if @xtbz in (0,1) 
	BEGIN
		IF EXISTS(  SELECT 1 FROM YY_CQYB_MZJZJLK a(NOLOCK) WHERE a.jssjh = @jsxh AND a.jlzt = 1 
					AND CASE ISNULL(a.zgyllb,'') WHEN '' THEN ISNULL(a.jmyllb,'') ELSE ISNULL(a.zgyllb,'') END NOT IN ('13','15') )
		BEGIN
			UPDATE #temp_fymx SET shid = NULL
		END
	END

	IF @configCQ01 = 'WD'--万达名称不能太长(注意中英文的组合)
	BEGIN		
		update #temp_fymx SET xmmc = SUBSTRING(CONVERT(TEXT,xmmc),1,50) WHERE DATALENGTH(xmmc) > 50
	END

	if rtrim(@configCQ58)<>'是' --未启用药物事中监控，一定要设置为空
	begin 
		update #temp_fymx set dcyyjl='',dcyyjldw='', dcyl='',zxjldw='',qyzl='' , yytj='' ,sypc='',shid=''
	end

	if @xtbz in (1) --1.27版本门诊的必传
	begin
            if @syxh in (56889)
		begin
		select a.jzlsh,a.cfh,a.cfrq, a.ybbm,a.xmdm,a.xmmc,a.xmdj,a.xmsl,a.jzbz,a.cfys,a.jbr,a.xmdw,
			(CONVERT(VARCHAR(20),CASE WHEN ISNULL(a.xmgg,'')= '' THEN a.xmdw ELSE a.xmgg end)) xmgg,  --万达接口不允许为空
			(CASE WHEN ISNULL(a.xmjx,'')= '' THEN '无' ELSE a.xmjx END) xmjx,
			a.zxlsh,a.xmje, a.ksdm,a.ksmc,(case when isnull(ltrim(b.sfzh),'')='' then @m_mrsfzh else b.sfzh end) as ysbm,a.mcyl,a.yfbz,a.zxzq,a.xzlb,a.zzfbz,
			a.dcyyjl,a.dcyyjldw, a.dcyl,a.zxjldw,a.qyzl , a.yytj ,a.sypc,a.shid,a.mxxh
		from #temp_fymx a left join YY_ZGBMK b(nolock) on a.ysbm = b.id
	end
	else
	begin
		select a.jzlsh,a.cfh,a.cfrq, a.ybbm,a.xmdm,a.xmmc,a.xmdj,a.xmsl,a.jzbz,a.cfys,a.jbr,a.xmdw,
			(CONVERT(VARCHAR(20),CASE WHEN ISNULL(a.xmgg,'')= '' THEN a.xmdw ELSE a.xmgg end)) xmgg,  --万达接口不允许为空
			(CASE WHEN ISNULL(a.xmjx,'')= '' THEN '无' ELSE a.xmjx END) xmjx,
			a.zxlsh,a.xmje, a.ksdm,a.ksmc,(case when isnull(ltrim(b.sfzh),'')='' then @m_mrsfzh else b.sfzh end) as ysbm,a.mcyl,a.yfbz,a.zxzq,a.xzlb,a.zzfbz,
	a.dcyyjl,a.dcyyjldw, a.dcyl,a.zxjldw,a.qyzl , a.yytj ,a.sypc,a.shid,a.mxxh
			from #temp_fymx a left join YY_ZGBMK b(nolock) on a.ysbm = b.id
		end
	end
	else
	begin
		if @syxh in (56889)
		begin
			select a.jzlsh,a.cfh,a.cfrq, a.ybbm,a.xmdm,a.xmmc,a.xmdj,a.xmsl,a.jzbz,a.cfys,a.jbr,a.xmdw,
			(CONVERT(VARCHAR(20),CASE WHEN ISNULL(a.xmgg,'')= '' THEN a.xmdw ELSE a.xmgg end)) xmgg,  --万达接口不允许为空
			(CASE WHEN ISNULL(a.xmjx,'')= '' THEN '无' ELSE a.xmjx END) xmjx,
			a.zxlsh,a.xmje, a.ksdm,a.ksmc,(case when isnull(ltrim(b.sfzh),'')='' then @m_mrsfzh else b.sfzh end) as ysbm,a.mcyl,a.yfbz,a.zxzq,a.xzlb,a.zzfbz,
			a.mxxh
		from #temp_fymx a left join YY_ZGBMK b(nolock) on a.ysbm = b.id
                end
		else
		begin
			select a.jzlsh,a.cfh,a.cfrq, a.ybbm,a.xmdm,a.xmmc,a.xmdj,a.xmsl,a.jzbz,a.cfys,a.jbr,a.xmdw,
			(CONVERT(VARCHAR(20),CASE WHEN ISNULL(a.xmgg,'')= '' THEN a.xmdw ELSE a.xmgg end)) xmgg,  --万达接口不允许为空
			(CASE WHEN ISNULL(a.xmjx,'')= '' THEN '无' ELSE a.xmjx END) xmjx,
			a.zxlsh,a.xmje, a.ksdm,a.ksmc,(case when isnull(ltrim(b.sfzh),'')='' then @m_mrsfzh else b.sfzh end) as ysbm,a.mcyl,a.yfbz,a.zxzq,a.xzlb,a.zzfbz,
			a.mxxh
			from #temp_fymx a left join YY_ZGBMK b(nolock) on a.ysbm = b.id
		end
	end
end
else if @code = '06'	--预结算
BEGIN
	if @xtbz = 0
	begin
		--费用总额
		select @fyze = a.zje - a.yhje,@patid=patid from SF_BRJSK a(nolock) where sjh = @jsxh
         
		--明细条数
		select @mxts = count(1) from GH_GHMXK(nolock) where ghxh in (select xh from GH_GHZDK(nolock) where jssjh = @jsxh) and xmdj>0
		
		--处理院内职工优惠
        exec usp_cqyb_ynzg_gh '01',@jsxh,0,@errmsg OUTPUT
		if @errmsg like "F%"
		begin
			select "F",@errmsg
			return 
		end
            
		select "T", a.jzlsh,					--1 门诊号/住院号
					'' as jzrq,					--2 截止日期
					'0' as zycr,					--3	住院床日		        
					@fyze as fyze,				--4 本次结算总金额
					zhzfbz,						--5 账户支付标志
					@mxts as mxts,				--6 本次结算明细条数
					a.xzlb,						--7 险种类别
					gsrdbh,						--8 工伤认定编号
					gsjbbm,						--9 工伤认定疾病编码
					cfjslx,						--10 尘肺结算类型
					b.ksdm,                     --11 出院科室编码  
					--case when isnull(ltrim(c.sfzh),'')='' THEN @m_mrsfzh ELSE c.sfzh END sfzh --15 出院医生编码--update by winning-dingsong-chongqing on 20200820
					case when isnull(ltrim(dbo.fun_getyssfzh(a.jssjh,'MZ')),'')='' THEN @m_mrsfzh ELSE dbo.fun_getyssfzh(a.jssjh,'MZ') END sfzh
		from YY_CQYB_MZJSJLK a(nolock) inner join YY_CQYB_MZJZJLK b(nolock) on a.jssjh = b.jssjh AND a.jzlsh = b.jzlsh
									   left join YY_ZGBMK c(nolock) on b.ysdm = c.id  --挂号可能不挂医生
		where a.jssjh = @jsxh and a.jlzt = 0
	end
	else if @xtbz = 1
	begin
		--费用总额   
		select @fyze = zje - yhje,@patid=patid from SF_BRJSK(nolock) where sjh = @jsxh

		--IF @patid=1328772 SELECT @fyze=214.20	
		--明细条数
		select @mxts = count(1) from SF_CFMXK(nolock) where cfxh in (select xh from SF_MZCFK(nolock) where jssjh = @jsxh)  
		and (zje<>0 or round((ylsj-yhdj)/ykxs,4)*ypsl*cfts<>0)
		
		select "T", a.jzlsh,					--1 门诊号/住院号
					'' as jzrq,					--2 截止日期
					'0' as zycr,					--3	住院床日		        
					@fyze as fyze,				--4 本次结算总金额
					zhzfbz,						--5 账户支付标志
					@mxts as mxts,				--6 本次结算明细条数
					a.xzlb,						--7 险种类别
					gsrdbh,						--8 工伤认定编号
					gsjbbm,						--9 工伤认定疾病编码
					cfjslx,						--10 尘肺结算类型
					b.ksdm,                     --11 出院科室编码  
					--case when isnull(ltrim(c.sfzh),'')='' THEN @m_mrsfzh ELSE c.sfzh END sfzh --15 出院医生编码--update by winning-dingsong-chongqing on 20200820
					case when isnull(ltrim(dbo.fun_getyssfzh(a.jssjh,'MZ')),'')='' THEN @m_mrsfzh ELSE dbo.fun_getyssfzh(a.jssjh,'MZ') END sfzh
		from YY_CQYB_MZJSJLK a(nolock) inner join YY_CQYB_MZJZJLK b(nolock) on a.jssjh = b.jssjh and a.jzlsh = b.jzlsh
									   left join YY_ZGBMK c(nolock) on b.ysdm = c.id
		where a.jssjh = @jsxh and a.jlzt = 0
	end
	else if @xtbz in (2,3)
	begin	
	    IF EXISTS (SELECT 1 FROM ZY_BRJSK a(NOLOCK) WHERE a.xh = @jsxh AND a.syxh = @syxh AND a.ybjszt = 2 )
		BEGIN
			select "F","该病人结算序号已结算，不能再预算或结算！" + CONVERT(VARCHAR(12),@jsxh)
			return
		END
	    --只控制结算界面的预算
		DECLARE @strYbdm VARCHAR(10)
		SELECT @strYbdm = ltrim(rtrim(ybdm)) FROM ZY_BRJSK a(NOLOCK) WHERE a.xh = @jsxh
	    if @xtbz = 2 AND EXISTS(SELECT 1 FROM YY_CONFIG(NOLOCK) WHERE id = 'CQ47' AND config = '是')
			AND NOT EXISTS (SELECT 1 FROM YY_CONFIG a(NOLOCK) WHERE a.id = 'CQ53' AND CHARINDEX('"'+@strYbdm+'"',a.config)> 0)
		begin
		    if exists(select 1 from  ZY_BRFYMXK a(nolock) WHERE  syxh = @syxh and jsxh = @jsxh AND idm = 0
			              AND ypdm in (SELECT xmdm FROM YY_CQYB_YBDXMJSWH(nolock) WHERE xmlb = '1' AND jlzt = 0 )  )
			begin
			    select 'F','病人存在需单项结算的诊疗费用，请先进行单项结算！'
				return
			end 

			if exists(select 1 from  ZY_BRFYMXK a(nolock) WHERE  syxh = @syxh and jsxh = @jsxh AND idm <> 0
			AND idm in (SELECT xmdm FROM YY_CQYB_YBDXMJSWH(nolock) WHERE xmlb = '0' AND jlzt = 0 ) )
			begin
			    select 'F','病人存在需单项结算的药品费用，请先进行单项结算！'
				return
			end
		end

	    --处理金额不等
	    DECLARE @zje ut_money 
		set @zje = 0.00
		if exists(select * from sysobjects where name='usp_zy_brfymxjec')
		begin
			SELECT @zje = zje FROM ZY_BRJSK(nolock) WHERE syxh = @syxh AND xh = @jsxh
			if @zje <> (SELECT sum(zje) from ZY_BRFYMXK(nolock) WHERE syxh=@syxh and jsxh=@jsxh) 
			begin  
				EXEC usp_zy_brfymxjec @syxh,@jsxh,@zje output 
			END
		end
	    
		--费用起止日期
		select @qzrq = case len(rtrim(jsqzrq)) when 10 then replace(jsqzrq,'-','') + '00:00:00' else replace(replace(jsqzrq,'-',''),' ','') end
		from YY_CQYB_ZYJSJLK(nolock) where syxh = @syxh and jsxh = @jsxh and jlzt in (0,1,3)
		--费用截止日期
		/*
		select @zzrq = case len(rtrim(a.jszzrq)) when 10 then replace(a.jszzrq,'-','') + '23:59:59' else replace(replace(a.jszzrq,'-',''),' ','') end
		from YY_CQYB_ZYJSJLK a(nolock) where a.syxh = @syxh and a.jsxh = @jsxh and a.jlzt in (0,1,3) 
		*/
		select @zzrq = 
			CASE when ISNULL(jszzrq,'') = '' THEN  
				CASE WHEN b.brzt not IN ('2','4') THEN @now ELSE b.cqrq  end
			else  
				CASE LEN(RTRIM(a.jszzrq)) when 10 THEN REPLACE(a.jszzrq,'-','') + '23:59:59' ELSE REPLACE(REPLACE(a.jszzrq,'-',''),' ','') end 
			end
		FROM YY_CQYB_ZYJSJLK a(nolock),ZY_BRSYK b(NOLOCK) WHERE a.syxh = b.syxh and a.syxh = @syxh and a.jsxh = @jsxh and a.jlzt in (0,1,3)
		if isnull(@zzrq,'') = ''
			select @zzrq = @now
		--住院床日
		select @zyts = datediff(day,jsqzrq,dbo.fun_convertrq_cqyb(2,@zzrq)) + 1
		from YY_CQYB_ZYJSJLK(nolock) where syxh = @syxh and jsxh = @jsxh and jlzt in (0,1,3)  
		 
		if exists(select 1 from ZY_BRSYK(nolock) where syxh = @syxh and brzt in (2,4))
		begin
			--费用总额   
			--select @fyze = zje - yhje from ZY_BRJSK(nolock) where xh = @jsxh and jlzt = 0 and jszt = 0 and ybjszt <> 2
			--从中间表获取总金额，在ZY_BRJSJEK增加医保与HIS的差额  
			select @fyze = sum(isnull( case when @configCQ49='是' then ktje else  xmje end,0)) 
			from YY_CQYB_ZYFYMXK(nolock) where syxh = @syxh and jsxh = @jsxh 
			and  (isnull(ybscbz,0) = 1 or (@configCQ49='是' and isnull(ybscbz,0) = 4))		
			--明细条数
			select @mxts = count(1) from YY_CQYB_ZYFYMXK(nolock) where syxh = @syxh and jsxh = @jsxh 
			and  (isnull(ybscbz,0) = 1 or (@configCQ49='是' and isnull(ybscbz,0) = 4))
		end
		else
		BEGIN
			--费用总额   
			--select @fyze = sum(zje-yhje) from ZY_BRFYMXK(nolock) 
			--where syxh = @syxh and jsxh = @jsxh and ISNULL(ybzxrq,zxrq) between @qzrq and @zzrq
			--从中间表获取总金额，在ZY_BRJSJEK增加医保与HIS的差额  
			select @fyze = sum(isnull( case when @configCQ49='是' then ktje else  xmje end,0)) 
			from YY_CQYB_ZYFYMXK(nolock) where syxh = @syxh and jsxh = @jsxh 
				and cfrq between @qzrq and @zzrq 
				and  (isnull(ybscbz,0) = 1 or (@configCQ49='是' and isnull(ybscbz,0) = 4))	
			--明细条数
			select @mxts = count(1) from YY_CQYB_ZYFYMXK(nolock) 
			where syxh = @syxh and jsxh = @jsxh  and cfrq between @qzrq and @zzrq
			and  (isnull(ybscbz,0) = 1 or (@configCQ49='是' and isnull(ybscbz,0) = 4))
		end
		--减去不上传的部分金额  由于无需上传部分可能没有先结算，就会做医保的预算
	    SELECT @fyze = @fyze - ISNULL(sum(zje-yhje),0) from ZY_BRFYMXK(nolock) where syxh = @syxh and jsxh = @jsxh AND ISNULL(ybscbz,0) = 3
		--重新插入医生代码
		if exists(select 1 from YY_CQYB_ZYJZJLK(nolock) where syxh = @syxh and isnull(ysdm,'') = '')
		begin
			update a set ysdm = b.ysdm
			from YY_CQYB_ZYJZJLK a inner join ZY_BRSYK b(nolock) on a.syxh = b.syxh 
			where a.syxh=@syxh
		end

		select "T", a.jzlsh,					--1 门诊号/住院号
					substring(jszzrq,1,10) as jzrq,	
												--2 截止日期
					@zyts as zycr,				--3	住院床日		        
					@fyze as fyze,				--4 本次结算总金额
					zhzfbz,						--5 账户支付标志
					@mxts as mxts,				--6 本次结算明细条数
					a.xzlb,						--7 险种类别
					gsrdbh,						--8 工伤认定编号
					gsjbbm,						--9 工伤认定疾病编码
					cfjslx,						--10 尘肺结算类型
					b.ksdm,                     --11 出院科室编码  
					--case when isnull(ltrim(c.sfzh),'')='' THEN @m_mrsfzh ELSE c.sfzh END sfzh --15 出院医生编码--update by winning-dingsong-chongqing on 20200820
					case when isnull(ltrim(dbo.fun_getyssfzh(a.syxh,'ZY')),'')='' THEN @m_mrsfzh ELSE dbo.fun_getyssfzh(a.syxh,'ZY') END sfzh
		from YY_CQYB_ZYJSJLK a(nolock) inner join YY_CQYB_ZYJZJLK b(nolock) on a.syxh = b.syxh and a.jzlsh = b.jzlsh
									   left join YY_ZGBMK c(nolock) on b.ysdm = c.id
		where a.syxh = @syxh and a.jsxh = @jsxh and a.jlzt in (0,1,3)
	end
	else if @xtbz = 4  --催款预算
	BEGIN
	    IF EXISTS (SELECT 1 FROM ZY_BRJSK a(NOLOCK) WHERE a.xh = @jsxh AND a.syxh = @syxh AND a.ybjszt = 2 )
		BEGIN
			select "F","该病人结算序号已结算，不能再预算或结算！" + CONVERT(VARCHAR(12),@jsxh)
			return
		END	
		--费用起止日期
		select @qzrq = replace(ksrq,'-','') + '00:00:00' 
		from ZY_BRJSK(nolock) where syxh = @syxh and xh = @jsxh 
		--费用截止日期
		select @zzrq = convert(varchar(19),getdate(),112)
		select @zzrq = substring(@zzrq,1,4)+substring(@zzrq,5,2)+substring(@zzrq,7,2) + '23:59:59' 
		
		--住院床日
		select @zyts = datediff(day,substring(ksrq,1,8),convert(varchar(8),getdate(),112)) + 1 
		from ZY_BRJSK(nolock) where syxh = @syxh and xh = @jsxh  
		
		if exists(select 1 from ZY_BRSYK(nolock) where syxh = @syxh and brzt in (2,4))	--2：病区出院、4：取消结算
		begin
			--费用总额   
			--select @fyze = zje - yhje from ZY_BRJSK(nolock) where xh = @jsxh and jlzt = 0 and jszt = 0 and ybjszt <> 2
			--从中间表获取总金额，在ZY_BRJSJEK增加医保与HIS的差额  
			select @fyze = sum(isnull( case when @configCQ49='是' then ktje else  xmje end,0)) 
			from YY_CQYB_ZYFYMXK(nolock) where syxh = @syxh and jsxh = @jsxh 
			and  (isnull(ybscbz,0) = 1 or (@configCQ49='是' and isnull(ybscbz,0) = 4))
			--明细条数
			select @mxts = count(1) from YY_CQYB_ZYFYMXK(nolock) where syxh = @syxh and jsxh = @jsxh 
			and  (isnull(ybscbz,0) = 1 or (@configCQ49='是' and isnull(ybscbz,0) = 4))
		end
		else
		begin
			--费用总额   
			--select @fyze = sum(zje-yhje) from ZY_BRFYMXK(nolock) 
			--where syxh = @syxh and jsxh = @jsxh and ISNULL(ybzxrq,zxrq) between @qzrq and @zzrq
			--从中间表获取总金额，在ZY_BRJSJEK增加医保与HIS的差额  
			select @fyze = sum(isnull( case when @configCQ49='是' then ktje else  xmje end,0)) 
			from YY_CQYB_ZYFYMXK(nolock) 
			where syxh = @syxh and jsxh = @jsxh  and cfrq between @qzrq and @zzrq
			and  (isnull(ybscbz,0) = 1 or (@configCQ49='是' and isnull(ybscbz,0) = 4))
			--明细条数
			select @mxts = count(1) from YY_CQYB_ZYFYMXK(nolock) 
			where syxh = @syxh and jsxh = @jsxh and cfrq between @qzrq and @zzrq 
			and  (isnull(ybscbz,0) = 1 or (@configCQ49='是' and isnull(ybscbz,0) = 4))
		end
		select @zzrq = substring(@zzrq,1,4)+'-'+substring(@zzrq,5,2)+'-'+substring(@zzrq,7,2)
		select "T", a.jzlsh,					--1 门诊号/住院号
					@zzrq as jzrq,				--2 截止日期
					@zyts as zycr,				--3	住院床日		        
					@fyze as fyze,				--4 本次结算总金额
					0 as zhzfbz,				--5 账户支付标志
					@mxts as mxts,				--6 本次结算明细条数
					a.xzlb,						--7 险种类别
					'' as gsrdbh,				--8 工伤认定编号
					'' as gsjbbm,				--9 工伤认定疾病编码
					'' as cfjslx,				--10 尘肺结算类型
					a.ksdm,                     --11 出院科室编码  
					--case when isnull(ltrim(b.sfzh),'')='' THEN @m_mrsfzh ELSE b.sfzh END sfzh --15 出院医生编码--update by winning-dingsong-chongqing on 20200820
					case when isnull(ltrim(dbo.fun_getyssfzh(a.syxh,'ZY')),'')='' THEN @m_mrsfzh ELSE dbo.fun_getyssfzh(a.syxh,'ZY') END sfzh
		from YY_CQYB_ZYJZJLK a(nolock) left join YY_ZGBMK b(nolock) on a.ysdm = b.id
		where a.syxh = @syxh and a.jlzt = '1'
	end       
end       
else if @code = '05'	--结算        
begin        
	if @xtbz = 0
	begin
		--费用总额   
		select @fyze = zje - yhje from SF_BRJSK(nolock) where sjh = @jsxh
		--明细条数
		select @mxts = count(1) from GH_GHMXK(nolock) where ghxh in (select xh from GH_GHZDK(nolock) where jssjh = @jsxh) and xmdj>0
		
		--处理院内职工优惠
        exec usp_cqyb_ynzg_gh '01',@jsxh,0,@errmsg output
		if @errmsg like "F%"
		begin
			select "F",@errmsg
			return 
		end

		select "T", a.jzlsh,					--1 门诊号/住院号
					jslb,						--2 结算类别
					'0' as zycr,					--3	住院床日
					@czym as jbr,				--4 经办人 
					zhzfbz,						--5 账户支付标志
					jszzrq,						--6 中途结算终止日期
					@fyze as fyze,				--7 本次结算总金额
					@mxts as mxts,				--8 本次结算明细条数
					a.xzlb,						--9 险种类别
					@hisbm as hisbm,			--10 HIS开放商编码					
					gsrdbh,						--11 工伤认定编号
					gsjbbm,						--12 工伤认定疾病编码
					cfjslx,						--13 尘肺结算类型
					b.ksdm,                     --14 出院科室编码  
					--case when isnull(ltrim(c.sfzh),'')='' THEN @m_mrsfzh ELSE c.sfzh END sfzh --15 出院医生编码--update by winning-dingsong-chongqing on 20200820
					case when isnull(ltrim(dbo.fun_getyssfzh(a.jssjh,'MZ')),'')='' THEN @m_mrsfzh ELSE dbo.fun_getyssfzh(a.jssjh,'MZ') END sfzh
		from YY_CQYB_MZJSJLK a(nolock) inner join YY_CQYB_MZJZJLK b(NOLOCK) on a.jssjh = b.jssjh and a.jzlsh = b.jzlsh
									   left join YY_ZGBMK c(nolock) on b.ysdm = c.id
		where a.jssjh = @jsxh and a.jlzt in (0,1)
	end
	else if @xtbz = 1
	begin
		--费用总额   
		select @fyze = zje - yhje,@patid=patid from SF_BRJSK(nolock) where sjh = @jsxh

		--IF @patid=1328772 SELECT @fyze=214.20	
		--明细条数
		select @mxts = count(1) from SF_CFMXK(nolock) where cfxh in (select xh from SF_MZCFK(nolock) where jssjh = @jsxh) 
		and (zje<>0 or round((ylsj-yhdj)/ykxs,4)*ypsl*cfts<>0)
		
		select "T", a.jzlsh,					--1 门诊号/住院号
					jslb,						--2 结算类别
					'0' as zycr,					--3	住院床日
					@czym as jbr,				--4 经办人 
					zhzfbz,						--5 账户支付标志
					jszzrq,						--6 中途结算终止日期
					@fyze as fyze,				--7 本次结算总金额
					@mxts as mxts,				--8 本次结算明细条数
					a.xzlb,						--9 险种类别
					@hisbm as hisbm,			--10 HIS开放商编码					
					gsrdbh,						--11 工伤认定编号
					gsjbbm,						--12 工伤认定疾病编码
					cfjslx,						--13 尘肺结算类型
					b.ksdm,                     --14 出院科室编码  
					--case when isnull(ltrim(c.sfzh),'')='' THEN @m_mrsfzh ELSE c.sfzh END sfzh --15 出院医生编码--update by winning-dingsong-chongqing on 20200820
					case when isnull(ltrim(dbo.fun_getyssfzh(a.jssjh,'MZ')),'')='' THEN @m_mrsfzh ELSE dbo.fun_getyssfzh(a.jssjh,'MZ') END sfzh
		from YY_CQYB_MZJSJLK a(nolock) inner join YY_CQYB_MZJZJLK b(nolock) on a.jssjh = b.jssjh and a.jzlsh = b.jzlsh
									   left join YY_ZGBMK c(nolock) on b.ysdm = c.id
		where a.jssjh = @jsxh and a.jlzt in (0,1)
	end
	else if @xtbz in (2,3)
	begin	
	    IF EXISTS (SELECT 1 FROM ZY_BRJSK a(NOLOCK) WHERE a.xh = @jsxh AND a.syxh = @syxh AND a.ybjszt = 2 )
		BEGIN
			select "F","该病人结算序号已结算，不能再预算或结算！" + CONVERT(VARCHAR(12),@jsxh)
			return
		END
	    SELECT @configCQ31 = config FROM YY_CONFIG(NOLOCK) WHERE id = 'CQ31'
	    SELECT @configCQ31 = ISNULL(@configCQ31,'否')
	    IF @configCQ31 = '是'
	    BEGIN
	        IF EXISTS(SELECT 1 FROM YY_CQYB_ZDYZDSPJG(NOLOCK) WHERE syxh = @syxh AND ISNULL(spjg,'0') = 2 )
	        BEGIN
	            SELECT "F","该病人已被医保科标记为诊断不符合医保报销，不能进行医保结算！"
	            return
	        END
			if EXISTS(select 1 FROM YY_CQYB_ZDYZDSPJG(NOLOCK) where syxh = @syxh AND isnull(spjg,'0') = 0)
			begin
				select "F","该病人是否符合医保报销需要医保办审批，不能进行市医保登记！"
				return
			end	        
	    END
	    
	    SELECT @configCQ32 = config FROM YY_CONFIG(NOLOCK) WHERE id = 'CQ32'
	    SELECT @configCQ32 = ISNULL(@configCQ32,'否')
	    IF @configCQ32 = '是'
	    BEGIN
	    	IF EXISTS (SELECT 1 FROM YY_CQYB_ZYFYMXK a(NOLOCK) 
						INNER JOIN YY_CQYB_ZDYSPXM b(NOLOCK) 
						        ON (CASE WHEN a.idm = 0 then  a.xmdm ELSE CONVERT(VARCHAR(30),a.idm) END) = b.xmdm 
							   AND b.xmlb IN ('0','1') AND b.jlzt = '0'
						LEFT JOIN YY_CQYB_ZDYSPFYMX c(NOLOCK) ON a.xh = c.xh 
		    WHERE a.syxh = @syxh AND a.jsxh = @jsxh )
		    BEGIN
		        SELECT "F","该病人存在还未审批的费用，请先到医保科进行审批！"
	            return
		    END
	    END
	    
		SELECT @configCQ19 = config FROM YY_CONFIG(NOLOCK) WHERE id = 'CQ19'
		IF @configCQ19 = '是' 
		BEGIN
		    SELECT @configCQ50 = config FROM YY_CONFIG(NOLOCK) WHERE id = 'CQ50'
			SELECT @ybshbz = isnull(shbz,0),@ybcyzdshbz = ISNULL(ybcyzdshbz,0) from ZY_BRJSK(nolock) where syxh=@syxh and xh = @jsxh
			IF @configCQ50 = '1'
			BEGIN
				if @ybshbz <> 1
				begin
					SELECT "F","该病人未医保审核通过，请先到医保科进行审核！"
					RETURN
				end
			END
			--如果未审核需医保科审核通过才能结算
			if NOT (@ybcyzdshbz = 1 AND @ybshbz = 1)
			BEGIN
				SELECT @configCQ64 = config FROM YY_CONFIG(NOLOCK) WHERE id = 'CQ64'
				IF @configCQ64 = '1'
				    SELECT @configCQ64 = ISNULL(@configCQ64,'')
				IF @configCQ64 <> '-1' and @configCQ64 <> ''
				BEGIN
					SELECT @dbzdzje = a.je from ZY_BRJSJEK a(NOLOCK) WHERE a.lx = 'yb08' AND jsxh = @jsxh

					IF EXISTS(SELECT 1 FROM YY_CONFIG a(NOLOCK) WHERE a.id = 'CQ01' AND a.config = 'WD')
					BEGIN
						SELECT @dbzdzje = @dbzdzje + a.je  from ZY_BRJSJEK a(NOLOCK) WHERE a.lx = 'yb23' AND jsxh = @jsxh
					END

					IF @dbzdzje > CONVERT(NUMERIC(12,2),@configCQ64) AND (@ybcyzdshbz = 0 OR @ybshbz = 0)
					BEGIN
					    BEGIN TRAN
					    UPDATE ZY_BRJSK SET ybcyzdshbz = 0,@ybshbz = 0 WHERE xh = @jsxh
					    IF @@error <> 0 or @@rowcount = 0 
						BEGIN
						    ROLLBACK TRAN
							SELECT 'F','更新医保审核标志出错！' 
							RETURN
						END
						INSERT INTO YY_CQYB_YBSHLOG(syxh,jsxh,shbz,czyh,czrq) 
						VALUES(@syxh,@jsxh,0,@zgdm,@now) 
						IF @@error <> 0 or @@rowcount = 0 
                        BEGIN
						    ROLLBACK TRAN
							SELECT 'F','记录审核日志失败' 
							RETURN
						END
						COMMIT TRAN
						
						SELECT 'F','请注意：该患者医院垫支金额：'+CONVERT(VARCHAR(20),@dbzdzje)+'，已超过限额：'+@configCQ64+'，需医保科审核通过才能结算！'
						RETURN
					END
				END
			END
		END   

		--费用起止日期
		select @qzrq = case len(rtrim(jsqzrq)) when 10 then replace(jsqzrq,'-','') + '00:00:00' else replace(replace(jsqzrq,'-',''),' ','') end
		from YY_CQYB_ZYJSJLK(nolock) where syxh = @syxh and jsxh = @jsxh and jlzt in (1,3)
		--费用截止日期
		/*
		select @zzrq = case len(rtrim(jszzrq)) when 10 then replace(jszzrq,'-','') + '23:59:59' else replace(replace(jszzrq,'-',''),' ','') end
		from YY_CQYB_ZYJSJLK(nolock) where syxh = @syxh and jsxh = @jsxh and jlzt in (1,3) 
		*/
		select @zzrq = 
			CASE when ISNULL(jszzrq,'') = '' THEN  
				CASE WHEN b.brzt not IN ('2','4') THEN @now ELSE b.cqrq  end
			else  
				CASE LEN(RTRIM(a.jszzrq)) when 10 THEN REPLACE(a.jszzrq,'-','') + '23:59:59' ELSE REPLACE(REPLACE(a.jszzrq,'-',''),' ','') end 
			end
		FROM YY_CQYB_ZYJSJLK a(nolock),ZY_BRSYK b(NOLOCK) WHERE a.syxh = b.syxh and a.syxh = @syxh and a.jsxh = @jsxh and a.jlzt in (1,3) 
		
		--住院床日
		select @zyts = datediff(day,jsqzrq,dbo.fun_convertrq_cqyb(2,@zzrq)) + 1
		from YY_CQYB_ZYJSJLK(nolock) where syxh = @syxh and jsxh = @jsxh and jlzt in (1,3)  
							
		if exists(select 1 from ZY_BRSYK(NOLOCK) where syxh = @syxh and brzt in (2,4))
		begin
			--费用总额  
			--select @fyze = zje - yhje from ZY_BRJSK(nolock) where xh = @jsxh and jlzt = 0 and jszt = 0 and ybjszt <> 2
			--从中间表获取总金额，在ZY_BRJSJEK增加医保与HIS的差额  
			select @fyze = sum(isnull( case when @configCQ49='是' then ktje else  xmje end,0)) 
			from YY_CQYB_ZYFYMXK(nolock) where syxh = @syxh and jsxh = @jsxh 
			and  (isnull(ybscbz,0) = 1 or (@configCQ49='是' and isnull(ybscbz,0) = 4))
			--明细条数
			select @mxts = count(1) from YY_CQYB_ZYFYMXK(nolock) where syxh = @syxh and jsxh = @jsxh 
			and  (isnull(ybscbz,0) = 1 or (@configCQ49='是' and isnull(ybscbz,0) = 4))
		end
		else
		begin
			--费用总额   
			--select @fyze = sum(zje-yhje) from ZY_BRFYMXK(nolock) 
			--where syxh = @syxh and jsxh = @jsxh and ISNULL(ybzxrq,zxrq) between @qzrq and @zzrq
			--从中间表获取总金额，在ZY_BRJSJEK增加医保与HIS的差额  
			select @fyze = sum(isnull( case when @configCQ49='是' then ktje else  xmje end,0)) 
			from YY_CQYB_ZYFYMXK(nolock) 
			where syxh = @syxh and jsxh = @jsxh and cfrq between @qzrq and @zzrq
			and  (isnull(ybscbz,0) = 1 or (@configCQ49='是' and isnull(ybscbz,0) = 4))
			--明细条数
			select @mxts = count(1) from YY_CQYB_ZYFYMXK(nolock) 
			where syxh = @syxh and jsxh = @jsxh and cfrq between @qzrq and @zzrq
			and  (isnull(ybscbz,0) = 1 or (@configCQ49='是' and isnull(ybscbz,0) = 4))
		END
        
        --保存每次结算的上传费用明细
		IF NOT EXISTS (SELECT 1 FROM ZY_BRJSK(NOLOCK) WHERE syxh = @syxh AND xh = @jsxh AND ybjszt = 2)
		BEGIN
			BEGIN TRAN
			DELETE YY_CQYB_ZYFYMXK_JS WHERE syxh = @syxh and jsxh = @jsxh
			if @@error <> 0
			begin
				select 'F','初始本次结算上传明细失败！'
				ROLLBACK TRAN
				return
			END
			DELETE YY_CQYB_NZYFYMXK_JS WHERE syxh = @syxh and jsxh = @jsxh
			if @@error <> 0
			begin
				select 'F','初始本次结算上传明细失败(N)！'
				ROLLBACK TRAN
				return
			END
			INSERT INTO YY_CQYB_ZYFYMXK_JS
			(
				syxh,jsxh,xh,txh,cfh,cfrq,idm,xmdm,xmmc,xmgg,xmdj,xmsl,xmdw,xmje,ksdm,ysdm,jbr,jzbz,
				zzfbz,ktsl,ktje,spbz,spclbz,qzfbz,ybscbz,zxlsh,ybxmdj,ybspbz,ybzje,sfxmdj,ybzfbl,
				ybbzdj,ybzfje,ybzlje,dydm,scxmdj,scxmsl,scxmje
			)
			SELECT 
				syxh,jsxh,xh,txh,cfh,cfrq,idm,xmdm,xmmc,xmgg,xmdj,xmsl,xmdw,xmje,ksdm,ysdm,jbr,jzbz,
				zzfbz,ktsl,ktje,spbz,spclbz,qzfbz,ybscbz,zxlsh,ybxmdj,ybspbz,ybzje,sfxmdj,ybzfbl,
				ybbzdj,ybzfje,ybzlje,dydm,scxmdj,scxmsl,scxmje
			FROM YY_CQYB_ZYFYMXK(NOLOCK) 
			WHERE syxh = @syxh AND jsxh = @jsxh AND ISNULL(ybscbz,0) = 1
			  AND cfrq between @qzrq and @zzrq
			  AND  (isnull(ybscbz,0) = 1 or (@configCQ49='是' and isnull(ybscbz,0) = 4))
			if @@error <> 0
			begin
				select 'F','保存本次结算上传明细失败！'
				ROLLBACK TRAN
				return
			end
			COMMIT TRAN
		END
		ELSE
        BEGIN
           SELECT 'F','该患者已结算，不能再次结算'
		   RETURN 
        END

		select "T", a.jzlsh,					--1 门诊号/住院号
					a.jslb,						--2 结算类别
					@zyts as zycr,				--3	住院床日
					@czym as jbr,				--4 经办人 
					zhzfbz,						--5 账户支付标志
					substring(jszzrq,1,10),		--6 中途结算终止日期
					@fyze as fyze,				--7 本次结算总金额
					@mxts as mxts,				--8 本次结算明细条数
					a.xzlb,						--9 险种类别
					@hisbm as hisbm,			--10 HIS开放商编码					
					a.gsrdbh,						--11 工伤认定编号
					a.gsjbbm,						--12 工伤认定疾病编码
					a.cfjslx,						--13 尘肺结算类型
					d.ksdm,                     --14 出院科室编码  
					--case when isnull(ltrim(c.sfzh),'')='' THEN @m_mrsfzh ELSE c.sfzh END sfzh --15 出院医生编码--update by winning-dingsong-chongqing on 20200820
					case when isnull(ltrim(dbo.fun_getyssfzh(a.syxh,'ZY')),'')='' THEN @m_mrsfzh ELSE dbo.fun_getyssfzh(a.syxh,'ZY') END sfzh
		from YY_CQYB_ZYJSJLK a(nolock) inner join YY_CQYB_ZYJZJLK b(nolock) on a.syxh = b.syxh and a.jzlsh = b.jzlsh
									   inner join YY_ZGBMK c(nolock) on b.ysdm = c.id 
									   INNER join ZY_BRJSK d(nolock) on a.syxh=d.syxh and a.jsxh=d.xh 
		where a.syxh = @syxh and a.jsxh = @jsxh and a.jlzt in (1,3)and a.jsxh=d.xh
	end       
end 
else if @code = '21'	--医保高收费(白蛋白)费用审批
begin
	if @xtbz = 1
	begin
		select "T",	a.jzlsh,					--1	门诊号/住院号
					c.zxlsh,					--2 处方明细流水号
					(case when c.spbz = 1 then 1 else 0 end) as spbz,			
												--3 审批标记
					a.xzlb					 	--4 险种类别
			from YY_CQYB_MZJZJLK a(nolock)
				inner join SF_MZCFK b(nolock) on a.jssjh = b.jssjh
				inner join SF_CFMXK c(nolock) on c.xh = c.cfxh and isnull(c.ybspbz,0) <> 0 and c.spclbz = 0
			where a.jssjh = @jsxh and a.jlzt = 1  
	end
	else --if @xtbz in (2,3)
	begin
		select "T",	a.jzlsh,					--1	门诊号/住院号
					b.zxlsh,					--2 处方明细流水号
					(case when b.spbz = 1 then 1 else 0 end) as spbz,			
												--3 审批标记
					a.xzlb						--4 险种类别
			from YY_CQYB_ZYJZJLK a(nolock)
				inner join YY_CQYB_ZYFYMXK b(nolock) on a.syxh = b.syxh and b.jsxh = @jsxh and isnull(b.ybscbz,0) = 1 
														and b.spbz <> 0 
														and ((@cxbz not in(1,2) and isnull(b.ybspbz,0) <> 0) or (@cxbz in(1,2)  and isnull(b.ybspbz,0) =@cxbz)) --AND b.spclbz = 0
			where a.syxh = @syxh and jlzt = 1 AND ( (@configCQ01 = 'DR') OR (@configCQ01 = 'WD' AND b.spclbz = 0) )
	end
end
else if @code = '22'	--医保未审批项目查询
BEGIN
    --万达异地病人审批查询接口不能被调用
    IF @configCQ01 = 'WD' 
	BEGIN
		IF @xtbz in (0,1) and EXISTS (SELECT 1 FROM YY_CQYB_MZJZJLK a(NOLOCK) WHERE jssjh = @jsxh AND a.sbkh LIKE '#%')
		BEGIN
            SELECT 'N',''
			RETURN
		END  
		ELSE IF EXISTS (SELECT 1 FROM YY_CQYB_ZYJZJLK a(NOLOCK) WHERE syxh = @syxh AND a.sbkh LIKE '#%') 
		BEGIN
            SELECT 'N',''
			RETURN
		END
	END

	if @xtbz in (0,1)
	BEGIN
		select "T",	jzlsh,						--1	门诊号/住院号
					@cxbz,						--2 审批类型
					dbo.fun_convertrq_cqyb(2,''),
												--3 查询日期
					xzlb						--4 险种类别
			from YY_CQYB_MZJZJLK(nolock)
			where jssjh = @jsxh and jlzt = 1
	end
	else --if @xtbz in (2,3)
	begin
		select "T",	jzlsh,						--1	门诊号/住院号
					@cxbz,						--2 审批类型
					dbo.fun_convertrq_cqyb(2,''),
												--3 查询日期
					xzlb						--4 险种类别
			from YY_CQYB_ZYJZJLK(nolock)
			where syxh = @syxh and jlzt = 1
	end
end
else if @code = '23'	--医保账户抵用
begin
	if @xtbz in (0,1)
	begin
		select "T",	jzlsh,						--1	门诊号/住院号
					sbkh,						--2 就医人编号
					name,						--3 就医人姓名
					sfzh,						--4 就医人身份证号
					xzqhbm,						--5 就医人行政区划
					dykh,						--6 抵用人社保号
					dyje,						--7 待抵用金额
					@czym as jbr,				--8 经办人
					zxlsh,						--9 结算交易流水号(待抵用结算记录)
					cblb						--10 就医人参保类别
			from YY_CQYB_MZDYJLK(nolock)
			where jssjh = @jsxh and jlzt = 1
	end
	else if @xtbz in (2,3)
	begin
		select "T",	jzlsh,						--1	门诊号/住院号
					sbkh,						--2 就医人编号
					name,						--3 就医人姓名
					sfzh,						--4 就医人身份证号
					xzqhbm,						--5 就医人行政区划
					dykh,						--6 抵用人社保号
					dyje,						--7 待抵用金额
					@czym as jbr,				--8 经办人
					zxlsh,						--9 结算交易流水号(待抵用结算记录)
					cblb						--10 就医人参保类别
			from YY_CQYB_ZYDYJLK(nolock)
			where syxh = @syxh and jsxh = @jsxh and jlzt = 1
	end
end
else if @code = '33'	--更新生育人员生育相关信息
begin
	if @cxbz = 0		--获取医生站的生育信息
	begin
		select 1
	end
	else if @cxbz = 1	--医保交易信息
	begin
		if @xtbz in (0,1)
		begin
			select "T",	jzlsh,					--1	门诊号/住院号
						sylb,					--2 生育待遇类别
						sysj,					--3 生育时间点
						sybfz,					--4 并发症
						ncbz,					--5 难产
						rslx,					--6 终止妊娠类型
						dbtbz,					--7 多胞胎标志
						syfwzh,					--8 生育服务证号
						jyjc,					--9 遗传病基因检查项目
						jhzh					--10 结婚证号
				from YY_CQYB_MZJSJLK(nolock)
				where jssjh = @jsxh and jlzt in (0,1)
		end
		else --if @xtbz in (2,3)
		begin
			select "T",	jzlsh,					--1	门诊号/住院号
						sylb,					--2 生育待遇类别
						sysj,					--3 生育时间点
						sybfz,					--4 并发症
						ncbz,					--5 难产
						rslx,					--6 终止妊娠类型
						dbtbz,					--7 多胞胎标志
						syfwzh,					--8 生育服务证号
						jyjc,					--9 遗传病基因检查项目
						jhzh					--10 结婚证号
				from YY_CQYB_ZYJSJLK(nolock)
				where syxh = @syxh and jsxh = @jsxh and jlzt in (0,1,3)
		end;
	end;
end
else if @code = '43'	--结算交易流水号查询
begin
	if @xtbz in (0,1)
	begin
		select "T",	isnull(sbkh,""),			--1 卡号
					cblb,						--2 参保类别
					dbo.fun_convertrq_cqyb(2,''),
												--3	结算日期			        
					xzlb,						--4 险种类别
					jzlsh						--5 门诊号/住院号
		from YY_CQYB_MZJZJLK(nolock) 
		where jssjh = @jsxh and jlzt = 1
	end
	else if @xtbz = 2
	begin
		select "T",	isnull(sbkh,""),			--1 卡号
					cblb,						--2 参保类别
					dbo.fun_convertrq_cqyb(2,''),
												--3	结算日期			        
					xzlb,						--4 险种类别
					jzlsh						--5 门诊号/住院号
		from YY_CQYB_ZYJZJLK(nolock) 
		where syxh = @syxh and jlzt = 1
	end
end
else if @code = '99'	--冲正交易     
begin       
    declare @error_qx varchar(200) 
	if @xtbz in (0,1)
	begin
		if exists (select 1 FROM VW_MZBRJSK a(NOLOCK) ,YY_YBFLK b(NOLOCK) WHERE a.ybdm = b.ybdm AND b.ybjkid = @configCQ18 and a.sjh=@jsxh)
		--导老数据
		begin
			exec usp_cqyb_ybxlsjzh 0,@jsxh,@xtbz,@error_qx output
			if @error_qx like "F%"
			begin
				select "F",@error_qx
				return 
			end
		end

		if @cxbz = 0 
		begin
			select "T",	isnull(zxlsh,""),		--1 交易流水号
						@czym as jbr,			--2 经办人
						jzlsh,					--3	门诊号/住院号
						0 as czlx,				--4 冲账类型0普通冲正1改账冲正(需中心审批)
						xzlb					--5 险种类别
			from VW_CQYB_MZJZJLK(nolock) 
			where jssjh = @jsxh and jlzt = 1
		end
		else if @cxbz = 1
		begin
			select "T",	isnull(zxlsh,""),		--1 交易流水号
						@czym as jbr,			--2 经办人
						jzlsh,					--3	门诊号/住院号
						0 as czlx,				--4 冲账类型0普通冲正1改账冲正(需中心审批)
						xzlb					--5 险种类别
			from VW_CQYB_MZJSJLK(nolock)
			where jssjh = @jsxh	and jlzt = 2	
		end
	end
	else if @xtbz = 2
	begin
		if @cxbz = 0 
		begin
			select "T",	isnull(zxlsh,""),		--1 交易流水号
						@czym as jbr,			--2 经办人
						jzlsh,					--3	门诊号/住院号
						0 as czlx,				--4 冲账类型0普通冲正1改账冲正(需中心审批)
						xzlb					--5 险种类别
			from YY_CQYB_ZYJZJLK(nolock) 
			where syxh = @syxh and jlzt = 1
		end
		else if @cxbz = 1
		begin
            --导老数据
			if exists (select 1 FROM ZY_BRSYK a(NOLOCK) ,YY_YBFLK b(NOLOCK) WHERE a.ybdm = b.ybdm AND b.ybjkid = @configCQ18 and a.syxh=@syxh)
			begin
				exec usp_cqyb_ybxlsjzh @syxh,0,@xtbz,@error_qx output
				if @error_qx like "F%"
				begin
					select "F",@error_qx
					return 
				end
			END
            
			select "T",	isnull(zxlsh,""),		--1 交易流水号
						@czym as jbr,			--2 经办人
						jzlsh,					--3	门诊号/住院号
						0 as czlx,				--4 冲账类型0普通冲正1改账冲正(需中心审批)
						xzlb					--5 险种类别
			from YY_CQYB_ZYJSJLK(nolock) 
			where syxh = @syxh and jsxh = @jsxh	and jlzt = 2
		end
	end;   
end
ELSE IF @code = '99ZYHCMX' --住院红冲明细 红冲已经上传的不需要上传的明细
BEGIN
    SELECT "T", a.xh,a.ybscbz,
	        	isnull(a.zxlsh,''),		--1 交易流水号
				@czym as jbr,			--2 经办人
				jzlsh,					--3	门诊号/住院号
				0 as czlx,				--4 冲账类型0普通冲正1改账冲正(需中心审批)
				xzlb					--5 险种类别
    FROM YY_CQYB_ZYFYMXK a(NOLOCK),YY_CQYB_ZYJZJLK b(NOLOCK) 
	WHERE a.syxh = @syxh AND a.jsxh = @jsxh AND ISNULL(a.ybscbz,0) in (3,4) AND ISNULL(a.zxlsh,'') <> '' 
	  AND a.syxh = b.syxh AND b.jlzt = 1
END
ELSE IF @code = '99ZYHCMXOTHER' --住院红冲明细 红冲其他需要红冲的明细
BEGIN
	SELECT "T",b.xh,b.ybscbz,
	isnull(b.zxlsh,''),					--1 交易流水号
	@czym as jbr,						--2 经办人
	c.jzlsh,							--3	门诊号/住院号
	0 AS czlx,							--4 冲账类型0普通冲正1改账冲正(需中心审批)
	c.xzlb								--5 险种类别
	FROM YY_CQYB_ZDYSPFYMX a(NOLOCK) INNER JOIN YY_CQYB_ZYFYMXK b(NOLOCK)
	ON a.xh = b.xh INNER JOIN YY_CQYB_ZYJZJLK c(NOLOCK) ON b.syxh = c.syxh 
	WHERE b.syxh = @syxh AND b.jsxh = @jsxh AND ISNULL(sftb,0) = 0 AND c.jlzt = 1
	AND ISNULL(b.ybscbz,0) = 1 AND ISNULL(b.zxlsh,'') <> '' ORDER BY b.xmsl ASC;
END
ELSE IF LTRIM(rtrim(@code)) = 'T10'       
BEGIN    
    IF @xtbz = 1
	begin 
		SELECT DISTINCT 
			   d.jzlsh,
			   c.cfxh,    
			   d.xzlb 
		FROM SF_BRJSK a(NOLOCK),SF_MZCFK b(NOLOCK),SF_CFMXK c(NOLOCK) ,YY_CQYB_MZJZJLK d(NOLOCK) 
		WHERE a.sjh = b.jssjh AND b.xh = c.cfxh AND a.ybjszt <> 2 AND ISNULL(c.zxlsh,'') <> '' 
		  AND SUBSTRING(a.sfrq,1,8) = REPLACE(CONVERT(VARCHAR(10),GETDATE(),120),'-','') 
		  AND a.ghsfbz = 1
		  AND a.sjh <> @jsxh
		  AND a.sjh = b.jssjh
	end     
END
ELSE
begin
	select "F","未定义的交易类型!"
	return;
end;

return




