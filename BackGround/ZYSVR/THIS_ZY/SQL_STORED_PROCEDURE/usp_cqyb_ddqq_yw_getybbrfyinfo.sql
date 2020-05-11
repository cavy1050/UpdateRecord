Text

CREATE proc usp_cqyb_ddqq_yw_getybbrfyinfo
(
	@syxh			ut_syxh,		--首页序号
	@jsxh			ut_xh12,		--结算序号
	@cxlb			ut_bz 			--查询类别0费用信息1审批信息2结算信息3异常费用校验费用明细4审批汇总信息5自定义审批项目费用信息6自定义审批项目费用汇总信息
)
as
/****************************************
[版本号]4.0.0.0.0
[创建时间]2017.03.05
[作者]FerryMan
[版权]Copyright ? 1998-2017卫宁健康科技集团股份有限公司
[描述]住院医保审核获取病人列表
[功能说明]
	住院医保审核获取病人列表
[参数说明]
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]
[修改记录]
****************************************/
set nocount on 

declare @qzrq	ut_rq16,				--费用起止日期
		@zzrq	ut_rq8,				--费用终止日期
		@errmsg varchar(150),				--错误信息
		@configCQ36 VARCHAR(3)     --取dydm方式
		,@zje ut_money

set @zje = 0.00
SELECT @configCQ36 = config FROM YY_CONFIG where id = 'CQ36'

IF ISNULL(@configCQ36,'') <> '2'
BEGIN
    SELECT @configCQ36 = '1' 
END

	select @zzrq=substring(jszzrq,1,4)+substring(jszzrq,6,2)+substring(jszzrq,9,2) from YY_CQYB_ZYJSJLK WHERE syxh=@syxh and jsxh=@jsxh

create table #temp_fymx        
(        
	mxxh	ut_xh12		not null,			--1 明细序号
	cfh		ut_xh12			null,			--2 处方号
	cfrq    varchar(20)     null,			--3 处方日期
	xmmc	varchar(50)     null,			--4 医院收费项目名称
	xmgg    ut_mc32         null,			--5 规格	
	xmdj    ut_money		null,			--6 单价	
	xmsl	ut_sl10			null,			--7 数量
	xmdw    varchar(20)     null,			--8 单位
	xmje    ut_money	    null,			--9 金额
	ybbm	varchar(10)     null,			--10 项目医保流水号
	ybscbz	varchar(10)     null,			--11 医保上传标志
	sfxmdj	varchar(10)     null,			--12 医保项目等级
	spbz	varchar(10)     null,			--13 审批标志
	ybspbz	varchar(10)		null,			--14 医保审批标志
	ybbzdj	ut_money		null,			--15 医保标准单价
	ybzlje	ut_money		null,			--16 医保自理金额
	qzfbz	varchar(10)		null,			--17 全自费标志
	zxlsh	varchar(20)		null,			--19 中心流水号
	cbbz	ut_bz			null,			--20 超标标志
	ybxybz  VARCHAR(1000)   null            --21 医保限用备注
)

if @cxlb = 0		--费用信息
BEGIN
    --处理金额不等
	if exists(select * from sysobjects where name='usp_zy_brfymxjec')
	begin
		SELECT @zje = zje FROM ZY_BRJSK(NOLOCK) WHERE syxh = @syxh AND xh = @jsxh
		if @zje <> (SELECT sum(zje) from ZY_BRFYMXK(NOLOCK) WHERE syxh=@syxh and jsxh=@jsxh) 
		begin  
			EXEC usp_zy_brfymxjec @syxh,@jsxh,@zje output   
		END
	END
    
	exec usp_cqyb_zyfymxcl @syxh,@jsxh,0,@errmsg out  
	if substring(@errmsg,1,1)='F'   
	begin  
		select 'F',@errmsg  
		return  
	END
	 	
	--处理医保已上传的费用明细begin
	IF EXISTS(SELECT 1 FROM YY_JBCONFIG(NOLOCK) WHERE yydm IN ('10017','10018'))
	begin
		select * into #temp_fymxk from ZY_BRFYMXK(nolock)  where syxh = @syxh and jsxh = @jsxh
		--附二、附一
		update a set ybscbz = 0
		from YY_CQYB_ZYFYMXK a(nolock) inner join #temp_fymxk b(nolock) on a.xh = b.xh and b.scbz in (-1,0,3,4)
		where a.syxh = @syxh and a.jsxh = @jsxh and a.ybscbz <> 1 and a.ybscbz <> 0
	
		update a set ybscbz = 1,zxlsh = b.mxlsh
		from YY_CQYB_ZYFYMXK a(nolock) inner join #temp_fymxk b(nolock) on a.xh = b.xh and b.scbz = 1
		where a.syxh = @syxh and a.jsxh = @jsxh and a.ybscbz <> 1
    
		UPDATE ZY_BRFYMXK SET scbz = 0 WHERE syxh = @syxh 
    end
	--其他版本接口,在此增加两个语句，从老接口中间表来获取数据更新，如果不写，老接口已上传部分标志将不能写正确，必须重新登记后在上传明细
	--待添加

	--处理医保已上传的费用明细end  
		 
	insert into #temp_fymx(mxxh,cfh,cfrq,xmmc,xmgg,xmdj,xmsl,xmdw,xmje,ybbm,ybscbz,sfxmdj,spbz,ybspbz,ybbzdj,ybzlje,qzfbz,zxlsh,cbbz,ybxybz)
	select b.xh,b.cfh,dbo.fun_convertrq_cqyb(1,b.cfrq),b.xmmc,b.xmgg,b.xmdj,b.xmsl,c.zxdw,b.xmje,
		c.dydm,b.ybscbz,ISNULL(c.ybfydj,'0'),b.spbz,b.ybspbz,isnull(b.ybbzdj,0),isnull(b.ybzlje,0),b.qzfbz,b.zxlsh,1,d.BZ
	from YY_CQYB_ZYJZJLK a(nolock) 
		inner join YY_CQYB_ZYFYMXK b(nolock) on a.syxh = b.syxh and b.jsxh = @jsxh and idm <> 0
		inner join YK_YPCDMLK c(nolock) on b.idm = c.idm
		LEFT JOIN YPML d(NOLOCK) ON c.dydm = d.YPLSH 
	where a.syxh = @syxh and a.jlzt = 1
	
	insert into #temp_fymx(mxxh,cfh,cfrq,xmmc,xmgg,xmdj,xmsl,xmdw,xmje,ybbm,ybscbz,sfxmdj,spbz,ybspbz,ybbzdj,ybzlje,qzfbz,zxlsh,cbbz,ybxybz)
	select b.xh,b.cfh,dbo.fun_convertrq_cqyb(1,b.cfrq),b.xmmc,'',b.xmdj,b.xmsl,b.xmdw,b.xmje,
		c.dydm,b.ybscbz,ISNULL(c.ybfydj,'0'),b.spbz,b.ybspbz,isnull(b.ybbzdj,0),isnull(b.ybzlje,0),b.qzfbz,b.zxlsh,0,d.BZ
	from YY_CQYB_ZYJZJLK a(nolock) 
		inner join YY_CQYB_ZYFYMXK b(nolock) on a.syxh = b.syxh and b.jsxh = @jsxh and idm = 0 
		inner join YY_SFXXMK c(nolock) on b.xmdm = c.id
		LEFT JOIN ZLXM d(NOLOCK) ON c.dydm = d.XMLSH 
	where a.syxh = @syxh and a.jlzt = 1
	 
	 update #temp_fymx set cbbz = 2 where sfxmdj in ('1','2') and ybzlje > 0 and cbbz = 1
	 --lj20200331处理单独ybzzfbz为1时前台显示
	update  a set a.sfxmdj='3',a.qzfbz='1' from #temp_fymx a , ZY_BRFYMXK b(NOLOCK)
	 where b.xh = a.mxxh and b.ybzzfbz='1'and a.sfxmdj in('1','2')
		
	select a.mxxh as "费用序号",a.cfrq as "收费日期",
		(CASE WHEN ISNULL(a.ybxybz,'') = '' THEN '' ELSE '△' END) + ' '+ xmmc as "药品名称",
		xmgg as "药品规格",a.xmdj as "药品单价",a.xmsl as "药品数量",
		xmdw as "药品单位",a.xmje as "药品金额",(case a.ybscbz when 1 then "已上传" when 2 then "无需上传" when 3 then "不上传" else "未上传" end) as "上传标志",
		CASE @configCQ36 WHEN '1' THEN a.ybbm ELSE b.dydm end  AS  "医保代码",
		CASE a.sfxmdj when '1' then "甲类" when '2' then "乙类" when '3' then "自费" else "" end as "费用等级",
		a.ybbzdj as "医保标准单价",a.ybzlje as "医保自费金额",
		case when a.ybspbz in (1,2) then (case isnull(a.spbz,0) when 1 then "审批通过" when 2 then "审批不通过" else "未审批" end) else "无需审批" end as "审批标志",
		case when isnull(a.qzfbz,0) = 1 then "全自费" else "正常" end as "全自费标志",a.zxlsh as "中心流水号",a.cbbz as "超标标志",a.ybxybz AS "医保备注"
 	from #temp_fymx a INNER JOIN ZY_BRFYMXK b(NOLOCK) ON b.xh = a.mxxh 
	ORDER by a.cfrq
end
else if @cxlb = 1	--审批信息
begin 

	SELECT @configCQ36 = ISNULL(config,'1') FROM YY_CONFIG(NOLOCK) WHERE id= 'CQ36'
    IF @configCQ36 = ''  SELECT @configCQ36 = '1'

	select 'False' as "选择",a.xh as "费用序号",a.cfrq as "收费日期",a.xmdm as "药品代码",a.xmmc as "药品名称",a.xmgg as "药品规格",
		a.xmdj as "药品单价",a.xmsl as "药品数量",a.xmje as "药品金额",
		(CASE @configCQ36 WHEN '2' THEN b.dydm 
		     ELSE  CASE b.idm WHEN 0 THEN (SELECT c.dydm FROM YY_SFXXMK c(NOLOCK) where c.id = b.ypdm) 
					    ELSE (SELECT e.dydm FROM YK_YPCDMLK e(NOLOCK) WHERE b.idm = e.idm ) 
				   END    
		END) "医保代码",
		case isnull(a.spbz,0) when 1 then "审批通过" when 2 then "审批不通过" else "未审批" end as "审批标志",
		case isnull(a.spclbz,0) when 1 then "已上传" else "未上传" end as "上传标志" 
	from YY_CQYB_ZYFYMXK a(NOLOCK) INNER JOIN ZY_BRFYMXK b(NOLOCK) ON a.xh = b.xh
	where a.syxh = @syxh and a.jsxh = @jsxh and a.ybscbz = 1 and isnull(a.ybspbz,0) in (1,2) --and a.cfrq<=@zzrq+'24' --and isnull(spclbz,0) = 1
end
else if @cxlb = 2	--结算信息
begin 
	select lx as "类型",mc as "类型说明",je as "金额",case when lx in('yb09') and je>0 then '$0000FF' else '' end as "颜色"
	from ZY_BRJSJEK(NOLOCK) where jsxh = @jsxh 
end
else if @cxlb = 3		--费用信息
begin
	exec usp_cqyb_zyfymxcl @syxh,@jsxh,0,@errmsg out  
	if substring(@errmsg,1,1)='F'   
	begin  
		select 'F',@errmsg  
		return  
	end 	
	
	--处理医保已上传的费用明细begin
    /*
	select * into #temp_fymxk from ZY_BRFYMXK(nolock)  where syxh = @syxh and jsxh = @jsxh
	--附二
	update a set ybscbz = 0
	from YY_CQYB_ZYFYMXK a(nolock) inner join #temp_fymxk b(nolock) on a.xh = b.xh and b.scbz in (-1,0,3,4)
	where a.syxh = @syxh and a.jsxh = @jsxh and a.ybscbz <> 1 and a.ybscbz <> 0
	
	update a set ybscbz = 1,zxlsh = b.mxlsh
	from YY_CQYB_ZYFYMXK a(nolock) inner join #temp_fymxk b(nolock) on a.xh = b.xh and b.scbz = 1
	where a.syxh = @syxh and a.jsxh = @jsxh and a.ybscbz <> 1
	*/

	--其他版本接口,在此增加两个语句，从老接口中间表来获取数据更新，如果不写，老接口已上传部分标志将不能写正确，必须重新登记后在上传明细
	
	--处理医保已上传的费用明细end
	 
	insert into #temp_fymx(mxxh,cfh,cfrq,xmmc,xmje,ybscbz,zxlsh)
	select b.xh,b.cfh,dbo.fun_convertrq_cqyb(1,b.cfrq),b.xmmc,b.xmje,b.ybscbz,b.zxlsh
	from YY_CQYB_ZYJZJLK a(nolock) 
		inner join YY_CQYB_ZYFYMXK b(nolock) on a.syxh = b.syxh and b.jsxh = @jsxh  
	where a.syxh = @syxh and a.jlzt = 1-- and ybscbz=1
	
	select mxxh as "费用序号",cfh as "处方号",cfrq as "收费日期",xmmc as "药品名称",xmje as "药品金额",
		(case ybscbz when 1 then "已上传" when 2 then "无需上传" when 3 then "不上传" else "未上传" end) as "上传标志",
		zxlsh as "中心流水号"
	from #temp_fymx order by cfrq
END
else if @cxlb = 4	--审批汇总信息
BEGIN
    select xmdm as "药品代码",xmmc as "药品名称",SUM(xmsl) as "药品数量"
	from YY_CQYB_ZYFYMXK(NOLOCK)
	where syxh = @syxh and jsxh = @jsxh and ybscbz = 1 and isnull(ybspbz,0) in (1,2) --and cfrq<=@zzrq+'24'
	GROUP BY xmdm,xmmc
END
ELSE if @cxlb = 5		--自定义审批项目费用信息
begin
	exec usp_cqyb_zyfymxcl @syxh,@jsxh,0,@errmsg out  
	if substring(@errmsg,1,1)='F'   
	begin  
		select 'F',@errmsg  
		return  
	end 	
	
	select * into #temp_zdyspfymxk from ZY_BRFYMXK(nolock)  where syxh = @syxh and jsxh = @jsxh 
	
	insert into #temp_fymx(mxxh,cfh,cfrq,xmmc,xmgg,xmdj,xmsl,xmdw,xmje,ybbm,ybscbz,sfxmdj,spbz,ybspbz,ybbzdj,ybzlje,qzfbz,zxlsh,cbbz,ybxybz)
	select b.xh,b.cfh,dbo.fun_convertrq_cqyb(1,b.cfrq),b.xmmc,b.xmgg,b.xmdj,b.xmsl,c.zxdw,b.xmje,
		c.dydm,b.ybscbz,ISNULL(c.ybfydj,'0'),b.spbz,b.ybspbz,isnull(b.ybbzdj,0),isnull(b.ybzlje,0),b.qzfbz,b.zxlsh,1,c.memo
	from YY_CQYB_ZYJZJLK a(nolock) 
		inner join YY_CQYB_ZYFYMXK b(nolock) on a.syxh = b.syxh and b.jsxh = @jsxh and idm <> 0
		inner join YK_YPCDMLK c(nolock) on b.idm = c.idm
		LEFT JOIN YPML d(NOLOCK) ON c.dydm = d.YPLSH 
		inner join YY_CQYB_ZDYSPXM e(NOLOCK) on c.idm = e.xmdm AND e.xmlb = '0'
	where a.syxh = @syxh and a.jlzt = 1 
	
	insert into #temp_fymx(mxxh,cfh,cfrq,xmmc,xmgg,xmdj,xmsl,xmdw,xmje,ybbm,ybscbz,sfxmdj,spbz,ybspbz,ybbzdj,ybzlje,qzfbz,zxlsh,cbbz,ybxybz)
	select b.xh,b.cfh,dbo.fun_convertrq_cqyb(1,b.cfrq),b.xmmc,'',b.xmdj,b.xmsl,b.xmdw,b.xmje,
		c.dydm,b.ybscbz,ISNULL(c.ybfydj,'0'),b.spbz,b.ybspbz,isnull(b.ybbzdj,0),isnull(b.ybzlje,0),b.qzfbz,b.zxlsh,0,c.memo
	from YY_CQYB_ZYJZJLK a(nolock) 
		inner join YY_CQYB_ZYFYMXK b(nolock) on a.syxh = b.syxh and b.jsxh = @jsxh and idm = 0 
		inner join YY_SFXXMK c(nolock) on b.xmdm = c.id
		inner join YY_CQYB_ZDYSPXM e(NOLOCK) on c.id = e.xmdm AND e.xmlb = '1'
	where a.syxh = @syxh and a.jlzt = 1 
	 
	update #temp_fymx set cbbz = 2 where sfxmdj in ('1','2') and ybzlje > 0 and cbbz = 1 

	select 'False' as "选择",a.mxxh as "费用序号",a.cfrq as "收费日期",a.xmmc as "药品名称",a.xmgg as "药品规格",a.xmdj as "药品单价",a.xmsl as "药品数量",
		a.xmdw as "药品单位",a.xmje as "药品金额",(case a.ybscbz when 1 then "已上传" when 2 then "无需上传" when 3 then "不上传" else "未上传" end) as "上传标志",
		CASE @configCQ36 WHEN '1' THEN a.ybbm ELSE c.dydm end  AS  "医保代码",
		CASE a.sfxmdj when '1' then "甲类" when '2' then "乙类" when '3' then "自费" else "" end as "费用等级",
		a.ybbzdj as "医保标准单价",a.ybzlje as "医保自费金额",
		--case when ybspbz in (1,2) then (case isnull(spbz,0) when 1 then "审批通过" when 2 then "审批不通过" else "未审批" end) else "无需审批" end as "审批标志",
		CASE b.spjg WHEN  '1' THEN '审批通过' WHEN '2' THEN '审批不通过' ELSE '未审批' END as "审批标志",
        -- b.spyy "院内审批原因"
		case when isnull(a.qzfbz,0) = 1 then "全自费" else "正常" end as "全自费标志",a.zxlsh as "中心流水号",a.cbbz as "超标标志",a.ybxybz "限用说明"
 	from #temp_fymx a LEFT JOIN YY_CQYB_ZDYSPFYMX b(NOLOCK) ON mxxh = b.xh
	                INNER JOIN ZY_BRFYMXK c(NOLOCK) ON c.xh = a.mxxh 
	order by a.cfrq
end
ELSE if @cxlb = 6		--自定义审批项目费用汇总信息
BEGIN
	SELECT b.xmdm as "药品代码",b.xmmc as "药品名称",SUM(b.xmsl) as "药品数量"
	from  YY_CQYB_ZYFYMXK b(nolock) inner join YK_YPCDMLK c(nolock) on b.idm = c.idm and b.idm <> 0
	INNER JOIN  YY_CQYB_ZDYSPXM d(NOLOCK) ON b.idm = d.xmdm AND d.xmlb = 0
	where b.syxh = @syxh and b.jsxh = @jsxh
	GROUP BY b.xmdm,b.xmmc
	UNION ALL
	select b.xmdm as "药品代码",b.xmmc as "药品名称",SUM(b.xmsl) as "药品数量"
	FROM YY_CQYB_ZYFYMXK b(nolock) inner join YY_SFXXMK c(nolock) on b.xmdm = c.id and b.idm = 0
	INNER JOIN YY_CQYB_ZDYSPXM d(NOLOCK) ON b.xmdm = d.xmdm AND d.xmlb = 1 
	where b.syxh = @syxh and b.jsxh = @jsxh
	GROUP BY b.xmdm,b.xmmc 		
END

return


