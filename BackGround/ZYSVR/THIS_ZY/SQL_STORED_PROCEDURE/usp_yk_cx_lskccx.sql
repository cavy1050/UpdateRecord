ALTER procedure usp_yk_cx_lskccx
    @kslb ut_bz,     
    @ksdm ut_ksdm,     
    @rq ut_rq16,                   
    @yplb int = 0,    
    @jxdm ut_jxdm,               
    @tsbz ut_bz,
    @zmlb int = 0,
    @pdmbxh int =0,
    @cfwz  ut_mc64 ='-1'   
as --集268341 2017-09-23 19:50:37 4.0标准版
/**********    
[版本号]4.0.0.0.0    
[创建时间]2004.12.30
[作者]陆越明    
[版权] Copyright ? 2004-2008上海金仕达-卫宁软件股份有限公司
[描述] 药库系统--历史库存查询    
[功能说明]    
  药库系统--历史库存查询    
[参数说明]    
    @kslb        科室类别：0--药库，1--药房    
    @ksdm        科室代码    
    @rq          需要查询的日期    
    @yplb int = 0 药品标志，0全部，1西药，2中成药，3中草药    
    @jxdm        剂型代码，YK_YPJXK.id ,大输液，等。     
    @tsbz        特殊标志，YK_TSBZK.id ,1麻醉,2精神,3剧毒,4危险,5化试,6胰岛素,9抗菌素  
    @zmlb int = 0 帐目类别：00--全部 01--西药 02--中成药 03--草药 04--制剂	05--药品材料 06--中药湿敷
    @pdmbxh int =0 盘点模板序号，0没有盘点模板	  
[返回值]    
[结果集、排序]    
[调用的sp]    
[调用实例]    
	usp_yk_cx_lskccx 0, "4002", "2006022400:00:00","0","-1",-1,"00"--【Clientdataset】
	usp_yk_cx_lskccx 1, "4004", "2006022400:00:00","0","-1",-1,"00"--【Clientdataset】
[修改记录]    
    2003-10-14 wfy 增加了一个传入参数：药品类别，输出中增加合计    
    2003-11-05 szj 增加了两个传入参数：剂型代码，特殊标志。
    2003-12-10 panlian 增加一个传入参数：帐目类别
    2004-01-07 panlian 修改帐类别和药品类别不能共存的BUG 
    2005-06-10 wangkun 修改药房传出药房单位
	2007-7-11 yxp 统计合计时条件不对
    2010-06-09 xwm 1 增加按盘点模板查询的功能
                   2 由于可能条件太多，原来的查询写法if else 太多导致存储过程太长故改写为构建查询语句方式以减少语句
    2012-3-29 grj 药库增加根据3180参数查询进价 
    2015-02-28 rxy for:13986 是否显示进价、进价金额和进销差额                     
**********/    
set nocount on    

declare @ny char(6)  
declare @config4160 varchar(2) ,@config3194 varchar(2) 
select @config4160=config from YY_CONFIG where id='4160'
select @config3194=config from YY_CONFIG where id='3194'
	
declare @config4226 varchar(2),@config3280 varchar(2) 
select @config4226=config from YY_CONFIG where id='4226'
select @config3280=config from YY_CONFIG where id='3280'

declare @mzorzy ut_bz --0 门诊 ,1 住院
select  @mzorzy = xtbz from YF_YFDMK (nolock) where id=@ksdm


create table #YK_CX_LSKCCX  
    (    
        cd_idm ut_xh9,     
        ypsl ut_sl14,     
        lsje ut_je14,     
        pfje ut_je14,
        jqpjjj ut_money,	--加权平均进价
        jqpjjj_je ut_je14, --add by grj 2012-3-29  加权平均进价金额
        jjje ut_je14,	--add by grj 2012-3-29  加权平均进价金额	
        pdmbmxxh ut_xh12 null
        
    )    

create table #YF_CX_LSKCCX    
    (    
        cd_idm ut_xh9,     
        ypsl ut_sl14,     
        lsje ut_je14,
        pfje ut_je14,
        jqpjjj ut_money,--加权平均进价
        jqpjjj_je ut_je14, --add by grj 2012-3-29  加权平均进价金额
        jjje ut_je14,	--add by grj 2012-3-29  加权平均进价金额
        pdmbmxxh ut_xh12 null    
    )  

declare @strOrderBy varchar(1000)
declare @strSQL1 varchar(4000),@strSQL2 varchar(4000),@strSQL varchar(8000),@strWhere varchar(2000)

select @strSQL1='',@strSQL2='',@strSQL='',@strWhere=''

if @pdmbxh=0 
    select @strOrderBy=' order by 药品代码 '
else
begin
   select @strOrderBy=' order by 盘点模板明细序号 '	
end

--add by grj 2012-3-29 
--=============================begin================
--declare @3180 char(1)
--select @3180 = '0' 
--select @3180 = config from YY_CONFIG where id = "3180"
declare @ypxtslt int  
select @ypxtslt=dbo.f_get_ypxtslt()    
if @@error<>0  
begin  
  select "F","获取药品系统模式出错！"  
  return  
end  
--=============================end==================

if @kslb=0 --药库
begin
	select @ny = ny from YK_TJQSZ (nolock) where ykdm = @ksdm and @rq between ksrq and jsrq    
		if @@rowcount = 0    
			select @ny = max(ny) from YK_TJQSZ (nolock) where ykdm = @ksdm 

		if @pdmbxh = 0 
        begin
			insert into #YK_CX_LSKCCX
            select cd_idm, ypsl, lsje, pfje,
            jqpjjj,jqpjjj_je,lsje-jxje,--add by grj 2012-3-29
            0
            from YK_YPTZK (nolock)    
			where ny = @ny and ksdm = @ksdm and lb = 1    
        end
        else  --按盘点模板 
        begin
   insert into #YK_CX_LSKCCX(cd_idm,ypsl,lsje,pfje,
				jqpjjj,jqpjjj_je,jjje,--add by grj 2012-3-29
				pdmbmxxh) 
            select a.cd_idm, a.ypsl, a.lsje, a.pfje,
				jqpjjj,a.jqpjjj_je,a.lsje-a.jxje,--add by grj 2012-3-29
				m.xh 
            from YK_YPTZK a (nolock) inner join YF_PDMBMXK m (nolock) on a.cd_idm=m.idm
               left join YK_YKZKC z (nolock) on  a.cd_idm = z.cd_idm and z.ksdm=@ksdm
            where a.ny = @ny and a.ksdm = @ksdm and a.lb = 1 and m.mbxh=@pdmbxh
             				
       end

		update #YK_CX_LSKCCX set ypsl = isnull(a.ypsl,0) + isnull(b.ypsl,0), lsje = isnull(a.lsje,0) + isnull(b.lsje,0),     
			pfje = isnull(a.pfje,0) + isnull(b.pfje,0),    
			jqpjjj_je = ISNULL(a.jqpjjj_je, 0) + ISNULL(b.jqpjjj_je, 0),--add by grj 2012-3-29
			jjje = isnull(a.jjje, 0) + isnull(b.jjje, 0)--add by grj 2012-3-29
			from #YK_CX_LSKCCX a, (select cd_idm, ksdm,     
        			sum(rksl - cksl) ypsl, sum(rkje_ls - ckje_ls) lsje, sum(rkje_pf - ckje_pf) pfje,
        			SUM(rkje_jqpjjj - ckje_jqpjjj) jqpjjj_je, SUM(rkje_ls -ckje_ls - jxce) jjje--add by grj 2012-3-29    
 				from YK_YPTZMXK (nolock)    
 				where ksdm = @ksdm and ny = @ny and czrq <= @rq group by cd_idm, ksdm) b    
		 where a.cd_idm = b.cd_idm

	--组合查询语句
     --select @strSQL1 = ' select b.ypdm "药品代码", b.py "拼音", b.wb "五笔", b.ypmc + "[" + b.ypgg + "]" "药品名称", b.cjmc "厂家名称",'     
    select @strSQL1 = ' select b.ypdm "药品代码", b.py "拼音", b.wb "五笔", b.ypmc "药品名称", b.ypgg 药品规格, b.cjmc "厂家名称",c.name "药品类别",'     
   			         + '        b.ykdw "药库单位", convert(numeric(14, 2), a.ypsl/b.ykxs) "库存数量",'     
   			         + '        b.ylsj "零售价", convert(money, a.lsje) "零售金额"'
   	select @strSQL2 = ' select "" "药品代码", "" "拼音", "" "五笔", "合计" "药品名称","" "药品规格", "" "厂家名称","" "药品类别",'     
			         + '        "" "药库单位", convert(numeric(14, 2), sum(a.ypsl/b.ykxs)) "库存数量",'     
			         + '        0 "零售价", convert(money, sum(a.lsje)) "零售金额"'		         
	if @config4160='否'  
	begin 			         
   		select @strSQL1 = @strSQL1 + ', b.ypfj "批发价", convert(money, a.pfje) "批发金额"'
   		--delete by grj 2012-3-29-- +'  ,b.mrjj "进价", convert(money,b.mrjj*a.ypsl/b.ykxs) "进价金额"'
		select @strSQL2 = @strSQL2 + ', 0 "批发价",convert(money, sum(a.pfje)) "批发金额"'
			        --delete by grj 2012-3-29-- +' ,0 "进价",convert(money, sum(b.mrjj*a.ypsl/b.ykxs)) "进价金额"'   		
	end   			        

			        
	 --add by grj 2012-3-29 
	 --=============================begin================
	if @config4226='否'
	begin
		if @ypxtslt = 0--使用进销差额计算进价金额
		begin
			select @strSQL1 = @strSQL1 + ' ,b.mrjj "进价", convert(money,b.mrjj*a.ypsl/b.ykxs) "进价金额"' 
			select @strSQL2 = @strSQL2 + ' ,0 "进价",convert(money, sum(b.mrjj*a.ypsl/b.ykxs)) "进价金额"' 
		end
		else if @ypxtslt = 1--使用平均进价推算进价金额
		begin
			select @strSQL1 = @strSQL1 + ' ,a.jqpjjj "进价", a.jqpjjj_je "进价金额"' 
			select @strSQL2 = @strSQL2 + ' ,0 "进价", sum(a.jqpjjj_je) "进价金额"'
		end
		else if @ypxtslt >= 2--使用药房批次管理
		begin
			select @strSQL1 = @strSQL1 + ' ,case a.ypsl when 0 then 0 else convert(numeric(14, 4), a.jjje/a.ypsl*b.ykxs) end "进价", a.jjje "进价金额"' 
			select @strSQL2 = @strSQL2 + ' ,0 "进价",sum(a.jjje) "进价金额"'
		end		
	end        
	--=============================end==================		        

     if @pdmbxh=0--不按模板方式
     begin
         select @strSQL1 = @strSQL1 + ',0 "盘点模板明细序号" '                  
     end else
     begin
         select @strSQL1 = @strSQL1 + ',a.pdmbmxxh "盘点模板明细序号" '                    
     end

     select @strSQL2 = @strSQL2 + ',0 "盘点模板明细序号" '
     
     select @strSQL1 = @strSQL1 + ',d.name as "药品剂型",b.pzwh as "批准文号",e.name as "药品大类" '
     select @strSQL2 = @strSQL2 + ',"" as "药品剂型","" as "批准文号","" as "药品大类" '
          
     select @strWhere = ' from #YK_CX_LSKCCX a inner join YK_YPCDMLK b (nolock) on a.cd_idm=b.idm '
                      + ' inner join  YY_SFDXMK c (nolock) on b.yplh=c.id '  
                      + ' left join YK_YPJXK d(nolock) on b.jxdm=d.id '
                      + ' left join YK_YPFLK e(nolock) on b.fldm=e.id'
                      + ' where 1=1 '
     
     if @yplb <>0 --给定药品类别
        select @strWhere = @strWhere  + ' and b.yplh=' + convert(varchar(12),@yplb)     
     
     select @strWhere = @strWhere       
                     + '    and (' + convert(varchar(12),@zmlb) + '= 0 or b.zmlb =' + convert(varchar(12),@zmlb) + ')'    
                     + '    and ("' + @jxdm + '" = "-1" or b.jxdm ="' + @jxdm + '")' -- szj 2003-11-05 '    
	                  --yxp and (@tsbz = '-1' or d.tsbz =@tsbz) -- szj 2003-11-05    
	                 + '    and ("' + convert(varchar(12),@tsbz) + '" = "-1" or b.tsbz ="' + convert(varchar(12),@tsbz) + '")' -- szj 2003-11-05'
     
     select @strSQL1 = @strSQL1 + @strWhere   

     select @strSQL2 = @strSQL2 + @strWhere
     
     select @strSQL=@strSQL1 + ' union '+ @strSQL2 + @strOrderBy

     Exec(@strSQL)
     
     return 		
end
if @kslb=1 --药房
begin
	select @ny = ny from YF_TJQSZ (nolock) where yfdm = @ksdm and @rq between ksrq and jsrq    
		if @@rowcount = 0    
			select @ny = max(ny) from YF_TJQSZ (nolock) where yfdm = @ksdm  
	  
    if @pdmbxh=0
    begin
		insert into #YF_CX_LSKCCX
        select cd_idm, ypsl, lsje, pfje,
        jqpjjj,jqpjjj_je,jjje,--add by grj 2012-3-29
        0 
        from YF_YPTZK (nolock)    
		where ny = @ny and ksdm = @ksdm and lb = 1    
    end 
    else begin --按盘点模板
        insert into #YF_CX_LSKCCX(cd_idm,ypsl,lsje,pfje,
			jqpjjj,jqpjjj_je,jjje,--add by grj 2012-3-29
			pdmbmxxh) 
            select a.cd_idm, a.ypsl, a.lsje, a.pfje,
            a.jqpjjj,a.jqpjjj_je,a.jjje,--add by grj 2012-3-29
            m.xh 
            from YF_YPTZK a (nolock) inner join  YF_PDMBMXK m (nolock) on a.cd_idm=m.idm 
                 left join  YF_YFZKC z (nolock) on a.cd_idm = z.cd_idm and z.ksdm=@ksdm 
            where a.ny = @ny and a.ksdm = @ksdm and a.lb = 1
              and m.mbxh=@pdmbxh             			
    end

	update #YF_CX_LSKCCX set ypsl = isnull(a.ypsl,0) + isnull(b.ypsl,0), lsje = isnull(a.lsje,0) + isnull(b.lsje,0), 
				pfje = isnull(a.pfje,0) + isnull(b.pfje,0),
				jqpjjj_je = ISNULL(a.jqpjjj_je, 0) + ISNULL(b.jqpjjj_je, 0),--add by grj 2012-3-29
				jjje = isnull(a.jjje, 0) + isnull(b.jjje, 0)--add by grj 2012-3-29    
			from #YF_CX_LSKCCX a,     
				(select cd_idm, ksdm, sum(rksl - cksl) ypsl, sum(rkje_ls - ckje_ls) lsje, sum(rkje_pf - ckje_pf) pfje, 
        		SUM(rkje_jqpjjj - ckje_jqpjjj) jqpjjj_je, SUM(rkje_jj -ckje_jj) jjje--add by grj 2012-3-29    
	 			from YF_YPTZMXK (nolock) where ksdm = @ksdm and ny = @ny and czrq <= @rq group by cd_idm, ksdm) b    
		where a.cd_idm = b.cd_idm  

    select @strSQL1 = 'select b.ypdm "药品代码", b.py "拼音", b.wb "五笔",'     
       				+ '       b.ypmc + "[" + b.ypgg + "]" "药品名称",b.ypgg "药品规格", b.cjmc "厂家名称", c.name "药品类别" , '

    select @strSQL2 = 'select "" "药品代码", "" "拼音","" "五笔", "合计"  "药品名称","" "药品规格", "" "厂家名称",  ""  "药品类别", '
    
    --modity by grj 2012-3-29 将门诊系统, 住院系统提取出来, 作为变量组合SQL
	 --=============================begin================
	declare @sql_xs varchar(10) 
	if @mzorzy=0 --门诊药房 取的单位和系数不同
		select @sql_xs = 'b.mzxs'
	else 
		select @sql_xs = 'b.zyxs'
	 
    --if @mzorzy=0 --门诊药房 取的单位和系数不同
    --begin
        select @strSQL1 = @strSQL1 + ' b.mzdw "药房单位", convert(numeric(14, 2), a.ypsl/' + @sql_xs + ') "库存数量",'
        select @strSQL2 = @strSQL2 + ' "" "药房单位", convert(numeric(14, 2), sum(a.ypsl/' + @sql_xs + ')) "库存数量", '
    /*    
    end else --住院药房
    begin
        select @strSQL1 = @strSQL1 + ' b.zydw "药房单位", convert(numeric(14, 2), a.ypsl/b.zyxs) "库存数量",'
        select @strSQL2 = @strSQL2 + ' "" "药房单位", convert(numeric(14, 2), sum(a.ypsl/b.zyxs)) "库存数量",'
    end
	*/
	--=============================end==================
	
    select @strSQL1 = @strSQL1 + ' convert(numeric(14, 4),b.ylsj/b.ykxs*' + @sql_xs + ') "零售价", convert(money, a.lsje) "零售金额"'
     
    select @strSQL2 = @strSQL2 + ' 0 "零售价", convert(money, sum(a.lsje)) "零售金额" '
	if @config3194='否'
	begin
		select @strSQL1 = @strSQL1 + ', convert(numeric(14, 4),b.ypfj/b.ykxs*' + @sql_xs + ') "批发价", convert(money, a.pfje) "批发金额"' 
		select @strSQL2 = @strSQL2 + ', 0 "批发价", convert(money, sum(a.pfje)) "批发金额"' 
	end
    --add by grj 2012-3-29 
	--=============================begin================
	if @config3280='否'
	begin	
		if @ypxtslt = 0--使用进销差额计算进价金额
		begin
			select @strSQL1 = @strSQL1 + ' ,convert(numeric(14, 4),b.mrjj/b.ykxs*' + @sql_xs + ') "进价",convert(money,b.mrjj*a.ypsl/b.ykxs) "进价金额"' 
			select @strSQL2 = @strSQL2 + ' ,0 "进价",convert(money, sum(b.mrjj*a.ypsl/b.ykxs)) "进价金额"' 
		end
		else if @ypxtslt = 1--使用平均进价推算进价金额
		begin
			select @strSQL1 = @strSQL1 + ' ,convert(numeric(14, 4),a.jqpjjj/b.ykxs*' + @sql_xs + ') "进价", a.jqpjjj_je "进价金额"' 
			select @strSQL2 = @strSQL2 + ' ,0 "进价", sum(a.jqpjjj_je) "进价金额"'
		end
		else if @ypxtslt >= 2--使用药房批次管理
		begin
			select @strSQL1 = @strSQL1 + ' ,case a.ypsl when 0 then 0 else convert(numeric(14, 4), a.jjje/a.ypsl*' + @sql_xs + ') end "进价", a.jjje "进价金额"' 
			select @strSQL2 = @strSQL2 + ' ,0 "进价",sum(a.jjje) "进价金额"'
		end		    
	end    
	--=============================end==================

    if @pdmbxh=0--不按模板方式
     begin
         select @strSQL1 = @strSQL1 + ',0 "盘点模板明细序号" '                  
     end else
     begin
         select @strSQL1 = @strSQL1 + ',a.pdmbmxxh "盘点模板明细序号" '                    
     end

     select @strSQL2 = @strSQL2 + ',0 "盘点模板明细序号" '
 					  
     select @strSQL1 = @strSQL1 + ',d.name as "药品剂型",b.pzwh as "批准文号",e.name as "药品大类" '
     select @strSQL2 = @strSQL2 + ',"" as "药品剂型","" as "批准文号","" as "药品大类" '
     
      select @strSQL1 = @strSQL1 + ',isnull(f.cfwz,"") "存放位置" '
     select @strSQL2 = @strSQL2 + ',"" "存放位置"'
          
     select @strWhere = ' from #YF_CX_LSKCCX a inner join YK_YPCDMLK b (nolock) on a.cd_idm=b.idm '
                      + ' inner join  YY_SFDXMK c (nolock) on b.yplh=c.id '  
                      + ' left join YK_YPJXK d(nolock) on b.jxdm=d.id '
                      + ' left join YK_YPFLK e(nolock) on b.fldm=e.id'
                      + ' left join (select *from YF_YFZKC g(nolock) where  g.ksdm ="'+@ksdm+'" ) f on  a.cd_idm=f.cd_idm '
                      + ' where 1=1 '
                       
    if @yplb <>0 --给定药品类别
         select @strWhere = @strWhere  + ' and b.yplh=' + convert(varchar(12),@yplb)

     select @strWhere = @strWhere
					  + '   and (' + convert(varchar(12),@zmlb) + '= 0 or b.zmlb ='+ convert(varchar(12),@zmlb) + ')'    
        			  + '   and ("' + @jxdm + '" = "-1" or b.jxdm ="' + @jxdm + '")'     
        				    
				      + '   and ("' + convert(varchar(12),@tsbz) + '" = "-1" or b.tsbz ="' + convert(varchar(12),@tsbz) + '")' -- szj 2003-11-05    
     
     select @strWhere = @strWhere
                      + '   and ("' + @cfwz + '" = "-1" or charindex("'+@cfwz+'",f.cfwz)>0 )'   
     select @strSQL1 = @strSQL1 + @strWhere
     select @strSQL2 = @strSQL2 + @strWhere

     --上半部分 + union + 下半部分 + 排序条件
	 select @strSQL=@strSQL1  + ' union '+ @strSQL2 + @strOrderBy
             
	 Exec(@strSQL)
     
     return             
end





