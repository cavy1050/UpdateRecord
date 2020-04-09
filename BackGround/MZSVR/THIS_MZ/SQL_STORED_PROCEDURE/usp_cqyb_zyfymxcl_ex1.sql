if exists(select 1 from sysobjects where name='usp_cqyb_zyfymxcl_ex1')
  drop proc usp_cqyb_zyfymxcl_ex1
go
Create proc usp_cqyb_zyfymxcl_ex1
(
    @syxh		ut_syxh,		--首页序号
    @jsxh		ut_xh12,		--结算序号
    @delphi		smallint = 1,	--0=后台调用，1=前台调用 
    @errmsg		varchar(150) = null output
)
as
/****************************************
[版本号]4.0.0.0.0
[创建时间]2018.07.13
[作者]qinfj
[版权]Copyright ? 1998-2017卫宁健康科技集团股份有限公司
[描述]住院费用负明细处理,负费用及对冲不上传
[功能说明]
	HIS住院费用负明细处理
[参数说明]
    @syxh	 --首页序号
    @jsxh	 --结算序号
    @delphi	 --0=后台调用，1=前台调用 
    @errmsg	 --输出
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]
[修改纪录]
****************************************/  
set nocount ON

create table #fymx
(
	xh				ut_xh12		not null,		--明细序号
	txh				ut_xh12			null,		--退序号
	cfrq			ut_rq16			null,		--处方日期
	idm				ut_xh9			null,		--药品idm
	xmdm			ut_xmdm			null,		--项目代码
	xmmc			ut_mc64			null,		--项目名称
	xmgg			ut_mc32			null,		--规格
	xmdj			ut_money		null,		--单价
	xmsl			ut_sl10			null,		--数量
	xmdw			ut_unit			null,		--单位
	xmje			ut_money	    null,		--金额
	ksdm			ut_ksdm			null,		--科室代码
	ysdm			ut_czyh			null,		--医生代码
	jbr				ut_czyh			null,		--经办人
	jlzt			ut_bz			null		--记录状态
)
create index idx_xh on #fymx(xh)
create index idx_txh on #fymx(txh)

select * into #brfymxk from ZY_BRFYMXK(nolock) where syxh = @syxh and jsxh = @jsxh and isnull(ybscbz,0) in (0,2) and zje <> 0

UPDATE #brfymxk SET tfxh = 0 WHERE ypsl > 0

if @@rowcount>0
begin
    insert into #fymx(xh,txh,cfrq,idm,xmdm,xmmc,xmgg,xmdj,xmsl,xmdw,xmje,ksdm,ysdm,jbr,jlzt)
	select xh,tfxh,(case when isnull(ybzxrq,'') <> '' then ybzxrq else zxrq end),idm,ypdm,ypmc,ypgg,
		round((zje-yhje)/ypsl,4),ypsl,ypdw,zje-yhje,ksdm,ysdm,czyh,0
	from #brfymxk(nolock) order by xh

	--锁定上传标志为2
    update a set ybscbz = 2 from ZY_BRFYMXK a(nolock) inner join #fymx b on a.xh = b.xh where a.syxh = @syxh
    if @@error <> 0
	begin
        select @errmsg = "F更新ZY_BRFYMXK记录状态失败"
        if @delphi = 1 
			select "F","更新ZY_BRFYMXK记录状态失败"
		return
	end

    DECLARE @xh 		ut_xh12,
	        @txh		ut_xh12
	--将txh已经被冲抵使用的更新为0  即,如果发现该txh已经被冲抵使用,则将该退费记录的txh更新成0
	declare cs_temp cursor for
	select xh,isnull(txh,0) from #fymx WHERE xh <> txh AND ISNULL(txh,0) <> 0 order by xh
	open cs_temp
	fetch cs_temp into @xh,@txh
	while @@fetch_status = 0
	begin
	    IF EXISTS(SELECT 1 FROM YY_CQYB_ZYFYMXK a(NOLOCK) WHERE a.syxh = @syxh AND a.jsxh=@jsxh AND a.xh <> a.txh AND ISNULL(txh,0) =@txh)
	    BEGIN
	        UPDATE #fymx SET txh = 0 WHERE xh=@xh
	    END

	    FETCH cs_temp into @xh,@txh
	end
	close cs_temp
	deallocate cs_temp
	
	--插入已导入中间表正记录到#YY_CQYB_ZYFYMXK中
	select syxh,jsxh,xh,txh,cfrq,idm,xmdm,xmmc,xmgg,xmdj,xmsl,xmdw,xmje,ksdm,ysdm,jbr,isnull(ktsl,xmsl) as ktsl,
		isnull(ktje,xmje) as ktje,ybscbz
	into #YY_CQYB_ZYFYMXK 
	from YY_CQYB_ZYFYMXK(nolock)
	where syxh = @syxh and jsxh = @jsxh
	if @@error <> 0
	begin
        select @errmsg = "F插入#YY_CQYB_ZYFYMXK原有记录失败"
        if @delphi = 1
			select "F","插入#YY_CQYB_ZYFYMXK原有记录失败"
		return
	end
	
	insert into #YY_CQYB_ZYFYMXK(syxh,jsxh,xh,txh,cfrq,idm,xmdm,xmmc,xmgg,xmdj,xmsl,xmdw,xmje,ksdm,ysdm,jbr,ktsl,ktje,ybscbz)
	select @syxh,@jsxh,xh,txh,cfrq,idm,xmdm,xmmc,xmgg,xmdj,xmsl,xmdw,xmje,ksdm,ysdm,jbr,xmsl,xmje,0
	from #fymx(nolock) where xmje > 0
	if @@error <> 0
	begin
        select @errmsg = "F插入#YY_CQYB_ZYFYMXK正记录失败"
        if @delphi = 1
			select "F","插入#YY_CQYB_ZYFYMXK正记录失败"
		return
	END
    
	create index idx_xh on #YY_CQYB_ZYFYMXK(xh)

	delete from #fymx where xmje > 0
	if @@error <> 0
	begin
        select @errmsg = "F删除临时表正记录失败"
        if @delphi = 1
			select "F","删除临时表正记录失败"
		return
	end
	
	--负记录处理 
	declare 
		@dyxh		ut_xh12,	        
        @idm		ut_xh12,
		@xmdm		varchar(20),
		@xmdj		numeric(10,4),
		@xmsl		numeric(10,2),
		@xmje		numeric(18,2),
		@zxmdj		numeric(10,4),
		@zxmsl		numeric(10,2),
		@zxmje		numeric(18,2),
		@cfrq		ut_rq16,
		@xmmc       VARCHAR(100),
	    @ybscbz     ut_bz
	declare cs_fjlcl cursor for
	select xh,idm,xmdm,xmmc,xmsl,ISNULL(txh,0) from #fymx where isnull(jlzt,0) = 0 order by cfrq,xh
	open cs_fjlcl
	fetch cs_fjlcl into @xh,@idm,@xmdm,@xmmc,@xmsl,@txh
	while @@fetch_status = 0
	BEGIN
	    --判断正数量是否够冲抵
	    IF (SELECT SUM(a.ktsl) FROM #YY_CQYB_ZYFYMXK a WHERE a.idm = @idm AND a.xmdm = @xmdm AND a.xmsl > 0) < ABS(@xmsl)
		BEGIN
		    select @errmsg = "F费用异常“"+ @xmmc + "”正费用合计数量小于负费用合计["+ cast(@xh as varchar(20))+"]"
            if @delphi=1
				SELECT "F","费用异常“"+ @xmmc + "”正费用合计数量小于负费用合计["+ cast(@xh as varchar(20))+"]"
		END
		--循环寻找冲抵正记录
		while exists(select 1 from #fymx where xh = @xh and xmsl < 0 and isnull(jlzt,0) = 0)
		BEGIN
            select @xmdj = xmdj,@xmsl = xmsl,@xmje = xmje,@cfrq = cfrq from #fymx where xh = @xh
            select @zxmje = 0,@zxmsl = 0,@zxmdj = 0,@dyxh =0

			IF EXISTS(select 1 from #YY_CQYB_ZYFYMXK(nolock) where syxh = @syxh AND xh = @txh AND idm = @idm and xmdm = @xmdm AND ktsl > 0 )
			BEGIN
                select @dyxh = xh from #YY_CQYB_ZYFYMXK where syxh = @syxh and xh = @txh and idm = @idm and xmdm = @xmdm AND ktsl > 0  
			END
            ELSE
            BEGIN
				if exists(select 1 from #YY_CQYB_ZYFYMXK(nolock) where syxh = @syxh and idm = @idm and xmdm = @xmdm and xmdj = @xmdj and ktsl = abs(@xmsl)) 
				begin
					select @dyxh = (select top 1 xh from #YY_CQYB_ZYFYMXK(nolock) 
					where syxh = @syxh and idm = @idm and xmdm = @xmdm and xmdj = @xmdj and ktsl = abs(@xmsl) order by ktsl DESC,cfrq asc)
				end
				else
				begin
					if exists(select 1 from #YY_CQYB_ZYFYMXK(nolock) where syxh = @syxh and idm = @idm and xmdm = @xmdm and xmdj = @xmdj and ktsl > 0 ) 
					begin
						select @dyxh = (select top 1 xh from #YY_CQYB_ZYFYMXK(nolock) 
						where syxh = @syxh and idm = @idm and xmdm = @xmdm and xmdj = @xmdj and ktsl > 0 order by ktsl asc,cfrq asc)
					end
					else  
					begin
						IF EXISTS (select 1 from #YY_CQYB_ZYFYMXK(nolock) where syxh = @syxh and xmdm = @xmdm and idm = @idm and ktsl > 0 )      
							select @dyxh= (select top 1 xh from #YY_CQYB_ZYFYMXK(nolock) 
							where syxh = @syxh and xmdm = @xmdm and idm = @idm and ktsl > 0 order by ktsl asc,cfrq asc)
						ELSE
							select @dyxh= (select top 1 xh from #YY_CQYB_ZYFYMXK(nolock) 
							where syxh = @syxh and xmdm = @xmdm and idm = @idm and ktsl > 0 ORDER by ktsl asc,cfrq asc)
					end
				END
			END
			if (@@error<>0) or (@@rowcount=0) or (@dyxh is null)
			begin
                select @errmsg = "F费用“"+ @xmmc + "”找不到可被对冲的序号["+ cast(@xh as varchar(20))+"]"
                if @delphi=1
					SELECT "F","费用“"+ @xmmc + "”找不到可被对冲的序号["+ cast(@xh as varchar(20))+"]"
				close cs_fjlcl
				deallocate cs_fjlcl 
				return
			end
			
            --取对应的正记录的单价和金额信息
			select @zxmje = ktje,@zxmsl = ktsl,@zxmdj = xmdj from #YY_CQYB_ZYFYMXK(nolock) where xh = @dyxh
			--单价不一致时以正项目价格为基准价格，将负数的单价和数量更新为正数的单价，同时处理数量
			--此处有矛盾，理论上不存在这种情况，因为退费都是以原价退,不过半退计算单价时会出现四舍五入问题
            if @zxmdj <> @xmdj   
            begin
				select @xmdj = @zxmdj,@xmsl = convert(numeric(10,2),@xmje/@zxmdj)
                update #fymx set xmdj = @zxmdj,xmsl = convert(numeric(10,2),xmje/@zxmdj) where xh = @xh
				if @@error<>0
				begin
                    select @errmsg = "F更新负费用单价数量失败"
                    if @delphi = 1
						select "F","更新负费用单价数量失败"
					close cs_fjlcl
					deallocate cs_fjlcl 
					return
				end
            END
            
            --取到的正项目金额不够冲负，将正数量全减
			if @zxmsl+@xmsl <= 0
			BEGIN
			    SELECT @ybscbz = 3  --不上传
				update #YY_CQYB_ZYFYMXK set ktje = 0,ktsl = 0,ybscbz = @ybscbz where xh = @dyxh
				if @@error<>0
				begin
                    select @errmsg = "F冲正正费用失败"
                    if @delphi = 1
						select "F","冲正正费用失败"
					close cs_fjlcl
					deallocate cs_fjlcl 
					return
				end
                --记录还剩下多少没用冲掉
				update #fymx set xmsl = xmsl + @zxmsl,xmje = xmje + @zxmje
				where xh = @xh
				if @@error<>0
				begin
                    select @errmsg = "F更新负费用失败"
                    if @delphi = 1
						select "F","更新负费用失败"
					close cs_fjlcl
					deallocate cs_fjlcl 
					return
				END

                --插入已经冲掉的记录
				IF not EXISTS(SELECT 1 FROM #YY_CQYB_ZYFYMXK a WHERE a.xh = @xh )
				BEGIN
					insert into #YY_CQYB_ZYFYMXK(syxh,jsxh,xh,txh,cfrq,idm,xmdm,xmmc,xmgg,xmdj,xmsl,xmdw,xmje,ksdm,ysdm,jbr,ktsl,ktje,ybscbz)
					select syxh,jsxh,@xh,@dyxh,@cfrq,idm,xmdm,xmmc,xmgg,@zxmdj,-@zxmsl,xmdw,-@zxmje,ksdm,ysdm,jbr,0,0,3
					from #YY_CQYB_ZYFYMXK(nolock) where xh = @dyxh				
					if @@error<>0
					begin
						select @errmsg = "F插入负费用失败1"
						if @delphi=1
							select "F","插入负费用失败1"
						close cs_fjlcl
						deallocate cs_fjlcl 
						return
					END
				END
				ELSE
				BEGIN
				    UPDATE #YY_CQYB_ZYFYMXK SET xmsl = xmsl - @zxmsl,xmje = xmje - @zxmje WHERE xh = @xh 
					if @@error<>0
					begin
						SELECT @errmsg = "F更新负费用信息失败1"
						IF @delphi = 1
							select "F","更新负费用信息失败1"
						close cs_fjlcl
						deallocate cs_fjlcl 
						return
					END 
				END
			end
			else if @zxmsl + @xmsl > 0--取到的正项目数量足够冲负
			BEGIN
			    --已上传的需冲正后再上传未上传部分数量 
			    IF EXISTS (SELECT 1 FROM YY_CQYB_ZYFYMXK WHERE xh = @dyxh AND ISNULL(ybscbz,0) = 1 ) 
				    SELECT @ybscbz = 4  
				ELSE 
				    SELECT @ybscbz = 5
				update #YY_CQYB_ZYFYMXK set ktsl = @zxmsl + @xmsl,ktje = @zxmje + @xmje,ybscbz = @ybscbz where xh = @dyxh
				if @@error<>0
				begin
                    select @errmsg = "F冲正正费用失败2"
                    if @delphi = 1
						select "F","冲正正费用失败2"
					close cs_fjlcl
					deallocate cs_fjlcl 
					return
				END

                --更新已处理标志为1
				update #fymx set jlzt = 1 where xh = @xh
				if @@error<>0
				begin
                    SELECT @errmsg = "F更新负费用状态失败2"
                    IF @delphi = 1
						select "F","更新负费用状态失败2"
					close cs_fjlcl
					deallocate cs_fjlcl 
					return
				END
                --插入已经冲掉的记录
				IF NOT EXISTS(SELECT 1 FROM #YY_CQYB_ZYFYMXK a WHERE a.xh = @xh )
				BEGIN
					insert into #YY_CQYB_ZYFYMXK(syxh,jsxh,xh,txh,cfrq,idm,xmdm,xmmc,xmgg,xmdj,xmsl,xmdw,xmje,ksdm,ysdm,jbr,ktsl,ktje,ybscbz)
					select syxh,jsxh,@xh,@dyxh,@cfrq,idm,xmdm,xmmc,xmgg,@xmdj,@xmsl,xmdw,@xmje,ksdm,ysdm,jbr,0,0,3
					from #YY_CQYB_ZYFYMXK(nolock) where xh = @dyxh
					if @@error<>0
					begin
						select @errmsg = "F插入负费用失败"
						if @delphi = 1
							select "F","插入负费用失败"
						close cs_fjlcl
						deallocate cs_fjlcl 
						return
					end
				END
				ELSE
				BEGIN
				    UPDATE #YY_CQYB_ZYFYMXK SET xmsl = xmsl + @xmsl,xmje = xmje + @xmje WHERE xh = @xh
					if @@error<>0
					begin
						SELECT @errmsg = "F更新负费用信息失败"
						IF @delphi = 1
							select "F","更新负费用信息失败"
						close cs_fjlcl
						deallocate cs_fjlcl 
						return
					END 
				END                  
			END
		end
		fetch cs_fjlcl into @xh,@idm,@xmdm,@xmmc,@xmsl,@txh
	end
	close cs_fjlcl
	deallocate cs_fjlcl

	--和结算库核对总金额
    declare @jskzje ut_money,@mxkzje ut_money
    select @jskzje = 0,@mxkzje = 0
	select @jskzje = zje-yhje from ZY_BRJSK(nolock) where syxh = @syxh and xh = @jsxh
	--减去不上传的部分金额  由于无需上传部分可能没有先结算，就会做医保的预算
	select @jskzje = @jskzje - ISNULL(sum(zje-yhje),0) from ZY_BRFYMXK(nolock) where syxh = @syxh and jsxh = @jsxh AND ISNULL(ybscbz,0) = 3 
	
	select @mxkzje = isnull(sum(ktje),0) from #YY_CQYB_ZYFYMXK(nolock) where syxh = @syxh and jsxh = @jsxh
	if abs(@jskzje - @mxkzje) > 0.5
	begin
        select @errmsg = "F结算库金额"+convert(varchar(20),@jskzje)+"和明细库金额"+convert(varchar(20),@mxkzje)+"不一致"
        if @delphi = 1
			select "F","结算库金额"+convert(varchar(20),@jskzje)+"和明细库金额"+convert(varchar(20),@mxkzje)+"不一致"
		return
	end

	begin tran
	update YY_CQYB_ZYFYMXK set xmdj = b.xmdj,xmsl = b.xmsl,ktje = b.ktje,ktsl = b.ktsl
	      ,ybscbz = b.ybscbz  --将已经导入中间表的状态更新
		from YY_CQYB_ZYFYMXK a(nolock),#YY_CQYB_ZYFYMXK b(nolock)
			where a.syxh = @syxh and a.jsxh = @jsxh and a.xh = b.xh and b.xmsl > 0
	if @@error <> 0
	begin
        select @errmsg = "F更新表YY_CQYB_ZYFYMXK数据失败"
        if @delphi = 1
			select "F","更新表YY_CQYB_ZYFYMXK数据失败"
		rollback tran
		return
	end
	 
	--非草药费用明细
	insert into YY_CQYB_ZYFYMXK(syxh,jsxh,xh,txh,cfh,cfrq,idm,xmdm,xmmc,xmgg,xmdj,xmsl,xmdw,xmje,ksdm,ysdm,jbr,jzbz,zzfbz,
		ktsl,ktje,spbz,spclbz,ybscbz)
	select a.syxh,a.jsxh,a.xh,a.txh,a.xh,a.cfrq,a.idm,a.xmdm,a.xmmc,a.xmgg,a.xmdj,a.xmsl,a.xmdw,a.xmje,a.ksdm,a.ysdm,
		a.jbr,0,"",a.ktsl,a.ktje,0,0,a.ybscbz
	from #YY_CQYB_ZYFYMXK a(nolock) inner join ZY_BRFYMXK b(nolock) on a.xh = b.xh 
	inner join YY_SFDXMK c(nolock) on c.id=b.dxmdm and c.ypbz<>3
	where not exists(select 1 from YY_CQYB_ZYFYMXK c(nolock) where a.xh = c.xh and a.txh = c.txh)
	if @@error <> 0
	begin
        select @errmsg = "F插入表YY_CQYB_ZYFYMXK数据失败"
        if @delphi = 1
			select "F","插入表YY_CQYB_ZYFYMXK数据失败"
		rollback tran
		return
	end
	
	--草药费用明细
	insert into YY_CQYB_ZYFYMXK(syxh,jsxh,xh,txh,cfh,cfrq,idm,xmdm,xmmc,xmgg,xmdj,xmsl,xmdw,xmje,ksdm,ysdm,jbr,jzbz,zzfbz,
		ktsl,ktje,spbz,spclbz,ybscbz)
	select a.syxh,a.jsxh,a.xh,a.txh,(CASE ISNULL(b.yzxh,0) WHEN 0 THEN b.qqxh else b.yzxh END),a.cfrq,a.idm,a.xmdm,a.xmmc,a.xmgg,a.xmdj,a.xmsl,a.xmdw,a.xmje,a.ksdm,a.ysdm,
		a.jbr,0,"",a.ktsl,a.ktje,0,0,a.ybscbz
	from #YY_CQYB_ZYFYMXK a(nolock) inner join ZY_BRFYMXK b(nolock) on a.xh = b.xh 
	inner join YY_SFDXMK c(nolock) on c.id=b.dxmdm and c.ypbz=3
	where not exists(select 1 from YY_CQYB_ZYFYMXK c(nolock) where a.xh = c.xh and a.txh = c.txh)
	if @@error <> 0
	begin
        select @errmsg = "F插入表YY_CQYB_ZYFYMXK数据失败"
        if @delphi = 1
			select "F","插入表YY_CQYB_ZYFYMXK数据失败"
		rollback tran
		return
	end
	
    update ZY_BRFYMXK set ybscbz = 1 where syxh = @syxh and jsxh = @jsxh and isnull(ybscbz,0) = 2
	if @@error <> 0
	begin
        select @errmsg = "F更新ZY_BRFYMXK上传标志失败"
        if @delphi = 1
			select "F","更新ZY_BRFYMXK上传标志失败"
		rollback tran
		return
	end
	
    update YY_CQYB_ZYFYMXK set txh = xh where syxh = @syxh and jsxh = @jsxh and txh = 0 
	if @@error <> 0
	begin
        select @errmsg = "F更新表YY_CQYB_ZYFYMXK数据失败txh"
        if @delphi = 1
			select "F","更新表YY_CQYB_ZYFYMXK数据失败txh"
		rollback tran
		return
	END
        
	commit tran	
end

drop table #fymx

select @errmsg = "T处理负明细成功"
if @delphi = 1
	select "T","处理负明细成功"
	
return


GO
