USE [THIS_MZ]
GO

/****** Object:  StoredProcedure [dbo].[usp_yk_cx_qykccx]    Script Date: 2022/3/10 9:24:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


ALTER  procedure [dbo].[usp_yk_cx_qykccx]     
	@cxlb  ut_bz = 0,      --查询类型，0全部，1药库，2药房 
	@IsDisplayKcslFlag ut_bz=1, --0不显示实际库存，1显示实际库存
	@GroupSortField varchar(200)='', --sang+++ 2011-11-09 分组排序字段
	@GroupSortFs varchar(200)='', --sang+++ 2011-11-09 分组排序方式
	@m_filter2_tybz ut_bz=0,--//停用标识：0所有 1停用 2未停用
	@m_filter3_kcbz ut_bz=0,--//库存标识：0所有 1有库存 2无库存
	@m_filter4_kzbz ut_bz=0,--//控制标识：0所有 1控制  2不控制
	@m_filter5_flzfbz ut_bz=0,--//分类自负标识：0所有 1甲内药 2乙类药 3丙类药
	@m_filter6_cfwzStart varchar(80)='',@m_filter6_cfwzEnd varchar(80)='',-- //存放位置开始，结束
	@m_filter7_OTCbz ut_bz=0,--//OTC标识：0所有 1OTC 2非OTC
	@m_filter8_zfbz ut_bz=0,--//自费标识：0所有 1自费
	@m_filter9_gzbz ut_bz=0,--//贵重标识：0所有 1贵重
	@str_filter10_tsypList varchar(200)='', --//特殊药品 YK_TSBZK.id 以逗号分隔
	@str_filter11_ypflList varchar(200)='',-- //所属大类 YK_YPFLK.id 以逗号分隔
	@str_filter12_zmlbList varchar(200)='',-- //账目类别 YK_ZMLBK.id  以逗号分隔
	@str_filter13_ypjxList varchar(200)='',--//药品剂型 YK_YPJXK.id   以逗号分隔
	@m_filter14_YlsjStart varchar(80)='',@m_filter14_YlsjEnd varchar(80)='', --//零售价开始，结束
	@cgjh_idm int=0,--采购计划查询全院库存使用, 其它默认=0.
	@curr_yydm ut_ksdm='', --调用科室所属医院代码
	@m_filter15_xlyybz ut_bz=0, --是否限量用药 0否 1是
	@m_filter17_Cyypbz ut_bz=0 ,--常用药品标志 0否 1是
	@m_filter18_qjyybz    ut_bz=0----抢救用药  0否 1是
as --集433715 2018-10-16 17:33:34 4.0标准版
/**********      
[版本号]4.0.0.0.1   
[创建时间]2004.12.30
[作者] yxp   
[版权] Copyright ? 2004-2008上海金仕达-卫宁软件股份有限公司
[描述] 药库系统--全院库存查询      
[功能说明]      
  药库系统--全院库存查询    (便于建立关键字，方便前台调用显示)  
[参数说明]      
      
[返回值]      
[结果集、排序]      
[调用的sp]      
[调用实例]      
   usp_yk_cx_qykccx 0  
[修改记录] 
sang+++ 2011-11-09 分组排序规则
sang 2011-09-21 3181参数控制 门诊医生站调用时是否显示库存实际值  
rxy 2014-06-06 对kzbz过滤有误 bug:204341
**********/      
set nocount on 

if isnull(@curr_yydm,'')=''
  select top 1 @curr_yydm=id from YY_JBCONFIG(nolock)

declare @lsjjehj varchar(32)
declare @jjjehj varchar(32)

declare @xtyydmbz ut_bz --是否要求与@ksdm对应的yydm一致， 0不要求一致 1要求一致 默认要求一致
select @xtyydmbz=1

--获取零售方案
declare @ypxtslt int  
select @ypxtslt=dbo.f_get_ypxtslt()  
if @@error<>0  
begin
	select 'F','获取药品系统模式出错!'
    return	
end


declare @sqlstr varchar(2000),
		@split_source varchar(1000),
		@split_str varchar(10),
		@split_left varchar(100),
		@split_index int

if isnull(@IsDisplayKcslFlag,-1)<>0
select @IsDisplayKcslFlag=1     
  
create table #qykc  
(  
	 xh   ut_xh12  identity    not null,  --序号  
	 cd_idm      ut_xh9              not null,  --产地idm  
	 py     varchar(64)      null,  --拼音  
	 wb     varchar(64)     null,  --五笔   
	 ypsm  varchar(1000)  null,  --药品说明  
	 ksmc  varchar(64)      null,  --科室名称  
	 kcsl  ut_sl10    null,  --库存数量  
	 ypdw  ut_unit    null,  --单位  
	 ypje  varchar(32)    null,  --金额  
	 ypdm  ut_xmdm    null,  --药品代码  
	 ylsj  varchar(32)   null,  --药品单价  
	 yplb  ut_bz null,	--查询类型 1药库，2药房 
	 ksdm ut_ksdm null,
	 jjje varchar(32)    null,  --进价金额
	 ypjj  varchar(32)   null ,  --进价
	 cjmc varchar(256) null,--厂家名称y.cfwz,c.ykdw,f.ybdm,c.basicdrug_flag,f.gjxjje
	 cfwz varchar(256) null,--存放位置
	 ykdw varchar(32) null,--药库单位
	 ybmc varchar(32) null,--医保类别
	 basicdrug_flag varchar(32) null, --基药标志  
	 gjxjje money null, --国家限价
	 djsl ut_sl10 null, --冻结数量
	 kykcsl ut_sl10 null, --可用数量
	 kzbz ut_bz null,     --控制标志
	 yjypbz_memo varchar(8) null,--应急药品标志
	 yjypsl ut_sl10 null  --应急药品数量
) 

delete from #qykc


--===================获取进价 （按cd_idm不按批次）start=================================
-------获取取药库进价----------
    select idm,convert(numeric(18,4),0) as ypjj into #tmp_price_yk from YK_YPCDMLK a(nolock)  
    --有库存，取有库存的平均进价  
    update #tmp_price_yk set ypjj=t1.ypjj   
    from #tmp_price_yk a inner join (select cd_idm,avg(ypjj) ypjj from YK_YPPCK(nolock) where  kcsl>0 group by cd_idm  ) t1 on t1.cd_idm=a.idm   
    where a.ypjj=0  
    --然后没库存的，取所有批次的平均价  
    update #tmp_price_yk set ypjj=t1.ypjj   
    from #tmp_price_yk a inner join (select cd_idm,avg(ypjj) ypjj from YK_YPPCK(nolock) group by cd_idm  ) t1 on t1.cd_idm=a.idm   
    where a.ypjj=0 
        
------获取药房进价------------------        
    select idm,convert(numeric(18,4),0) as ypjj into #tmp_price_yf from YK_YPCDMLK a(nolock)  
    if @ypxtslt in (0,1)  
    begin  
		update #tmp_price_yf set ypjj=(c.lsje-c.jxje)/(c.kcsl3/b.ykxs)   
		from #tmp_price_yf a inner join YK_YPCDMLK b(nolock) on a.idm=b.idm   
            inner join YF_YFZKC c(nolock) on c.cd_idm=b.idm  
		where (c.lsje-c.jxje)>0 and c.kcsl3>0 and a.ypjj=0  
      --取默认进价  
      update #tmp_price_yf set ypjj=b.mrjj   
      from #tmp_price_yf a inner join YK_YPCDMLK b(nolock) on a.idm=b.idm   
      where b.mrjj>0 and a.ypjj=0  
    end  
    if @ypxtslt in (2,3)  
    begin  
       --有库存，取有库存的平均进价  
       update #tmp_price_yf set ypjj=t1.ypjj   
       from #tmp_price_yf a inner join (select cd_idm,avg(ypjj) ypjj from YF_YFPCK(nolock) where kcsl>0 group by cd_idm,ksdm  ) t1 on t1.cd_idm=a.idm   
       where a.ypjj=0  
       --然后没库存的，取所有批次的平均价  
       update #tmp_price_yf set ypjj=t1.ypjj   
       from #tmp_price_yf a inner join (select cd_idm,avg(ypjj) ypjj from YF_YFPCK(nolock) group by cd_idm,ksdm  ) t1 on t1.cd_idm=a.idm   
       where a.ypjj=0                  
    end 
 ----获取单位系数--------
 create table #tmp_ypdw(cd_idm ut_xh12 null,gg_idm ut_xh12 null,ypdw ut_unit null,dwxs ut_dwxs null) 
 if exists(select 1 from YF_YFDMK a(nolock) where xtbz=0 )  --0：门诊,1=住院  
  begin  
       insert into #tmp_ypdw(cd_idm,gg_idm,ypdw,dwxs)  
       select a.idm,a.gg_idm,a.mzdw,a.mzxs from YK_YPCDMLK a(nolock)  
  end  
  else  
  begin  
       insert into #tmp_ypdw(cd_idm,gg_idm,ypdw,dwxs)  
       select a.idm,a.gg_idm,a.zydw,a.zyxs from YK_YPCDMLK a(nolock)  
  end  
--============= 获取进价end================================================


if @cgjh_idm=0
begin
	if @cxlb in (0,1) 
	begin 
	 insert into #qykc(cd_idm,py,wb,ypsm,ksmc,kcsl,ypdw,ypje,ypdm,ylsj,yplb,ksdm,jjje,ypjj,cjmc,
	 cfwz,ykdw,ybmc,basicdrug_flag,gjxjje,djsl,kykcsl,yjypbz_memo,yjypsl)  
	 select y.cd_idm,rtrim(c.py),rtrim(c.wb),  
	  '名称:'+rtrim(c.ypmc)+', 厂家:'+rtrim(c.cjmc)+', 规格:'+rtrim(c.ypgg)+', 内码：'+rtrim(ltrim(convert(varchar,y.cd_idm))) as ypsm,
	  m.name as ksmc,  
	  convert(numeric(14,2),y.kcsl/c.ykxs) as kcsl, c.ykdw as ypdw,  
	   str(y.kcsl * c.ylsj/c.ykxs,14,2)  as ypje, c.ypdm, str(c.ylsj,14,4) as ylsj,1 as yplb ,y.ksdm ,
	   str((y.kcsl * c.ylsj/c.ykxs -y.jxje),14,2) ,str(t.ypjj,14,4)
	   ,c.cjmc,y.cfwz,c.ykdw,b.name,case c.basicdrug_flag when 1 then "是" when 0 then "否" end ,f.gjxjje
	   ,CONVERT(numeric(14,2),y.djsl/c.ykxs) as djsl,CONVERT(numeric(14,2),(y.kcsl-y.djsl)/c.ykxs) as kykcsl
	   ,case f.yjypbz when 1 then '是' else '' end as yjypbz_memo,isnull(f.yjypsl,0)/c.ykxs as yjypsl
	 from YK_YKZKC y (nolock) inner join YK_YPCDMLK c(nolock) on y.cd_idm = c.idm
           inner join   YK_YKDMK a(nolock) on  a.id=y.ksdm
           inner join YY_KSBMK m (nolock) on y.ksdm = m.id
           inner join #tmp_price_yk t(nolock) on y.cd_idm= t.idm
           left join YK_YPCDMLKZK f(nolock) on c.idm=f.idm
            left join YY_YPYBFLK b(nolock) on c.ybmc=b.name
           where (0=@xtyydmbz or (1=@xtyydmbz and m.yydm=@curr_yydm)) 
	 end  
	  
	if @cxlb in (0,2)
	begin  
	 insert into #qykc(cd_idm,py,wb,ypsm,ksmc,kcsl,ypdw,ypje,ypdm,ylsj,yplb,ksdm,jjje,
	   ypjj,cjmc,cfwz,ykdw,ybmc,basicdrug_flag,gjxjje,djsl,kykcsl,yjypbz_memo,yjypsl)  
	 select y.cd_idm,rtrim(c.py),rtrim(c.wb),  
	  '名称:'+rtrim(c.ypmc)+', 厂家:'+rtrim(c.cjmc)+', 规格:'+rtrim(c.ypgg) +', 内码：'+rtrim(ltrim(convert(varchar,y.cd_idm))) as ypsm,
	  m.name as ksmc,  
	  convert(numeric(14,2),y.kcsl3/c.ykxs) as kcsl, c.ykdw as ypdw,  
	   str(y.kcsl2 * c.ylsj/c.ykxs,14,2)  as ypje, c.ypdm, str(c.ylsj,14,4) as ylsj,2 as yplb,y.ksdm,
	  case @ypxtslt when 0 then (str((y.kcsl2 * c.ylsj/c.ykxs-y.jxje),14,2)) when 1 then (str((y.kcsl2 * c.ylsj/c.ykxs-y.jxje),14,2)) when 2 then str(y.jjje,14,2) when 3 then str(y.jjje,14,2) end,
	  str(t.ypjj/c.ykxs*D1.dwxs,14,4) ,c.cjmc,y.cfwz,c.ykdw,b.name,
	  case c.basicdrug_flag when 1 then "是" when 0 then "否" end ,f.gjxjje 
	  ,CONVERT(numeric(14,2),y.djsl/c.ykxs) as djsl,CONVERT(numeric(14,2),(y.kcsl3-y.djsl)/c.ykxs) as kykcsl   
	 ,case f.yjypbz when 1 then '是' else '' end as yjypbz_memo,isnull(f.yjypsl,0)/c.ykxs as yjypsl
	 from YF_YFZKC y (nolock) inner join YK_YPCDMLK c(nolock) on y.cd_idm = c.idm 
             inner join YF_YFDMK a(nolock) on a.id=y.ksdm
             inner join YY_KSBMK m (nolock) on y.ksdm = m.id
             inner join #tmp_price_yf t(nolock) on y.cd_idm= t.idm 
             inner join #tmp_ypdw D1(nolock) on D1.cd_idm=y.cd_idm 
             left join YK_YPCDMLKZK f(nolock) on c.idm=f.idm  
             left join YY_YPYBFLK b(nolock) on c.ybmc=b.name
	 where   (0=@xtyydmbz or (1=@xtyydmbz and m.yydm=@curr_yydm)) 
	end
end 
else
begin
	if @cxlb in (0,1) 
	begin 
	 insert into #qykc(cd_idm,py,wb,ypsm,ksmc,kcsl,ypdw,ypje,ypdm,ylsj,yplb,ksdm,jjje,ypjj,cjmc,
	 cfwz,ykdw,ybmc,basicdrug_flag,gjxjje,djsl,kykcsl,yjypbz_memo,yjypsl)    
	 select y.cd_idm,rtrim(c.py),rtrim(c.wb),  
	  '名称:'+rtrim(c.ypmc)+', 厂家:'+rtrim(c.cjmc)+', 规格:'+rtrim(c.ypgg)+', 内码：'+rtrim(ltrim(convert(varchar,y.cd_idm))) as ypsm,
	  m.name as ksmc,  
	  convert(numeric(14,2),y.kcsl/c.ykxs) as kcsl, c.ykdw as ypdw,  
	   str(y.kcsl * c.ylsj/c.ykxs,14,2)  as ypje, c.ypdm, str(c.ylsj,14,4) as ylsj ,1 as yplb ,y.ksdm ,
	    str((y.kcsl * c.ylsj/c.ykxs -y.jxje),14,2) ,str(t.ypjj,14,4)
	    ,c.cjmc,y.cfwz,c.ykdw,b.name,case c.basicdrug_flag when 1 then "是" when 0 then "否" end ,f.gjxjje 
	    ,CONVERT(numeric(14,2),y.djsl/c.ykxs) as djsl,CONVERT(numeric(14,2),(y.kcsl-y.djsl)/c.ykxs) as kykcsl
	   ,case f.yjypbz when 1 then '是' else '' end as yjypbz_memo,isnull(f.yjypsl,0)/c.ykxs as yjypsl
	 from YK_YKZKC y (nolock) inner join  YK_YPCDMLK c(nolock) on y.cd_idm = c.idm 
            inner join YY_KSBMK m (nolock) on  y.ksdm = m.id 
            inner join #tmp_price_yk t(nolock) on y.cd_idm= t.idm
            left join YK_YPCDMLKZK f(nolock) on c.idm=f.idm 
           left join YY_YPYBFLK b(nolock) on c.ybmc=b.name
	 where   c.idm=@cgjh_idm and (0=@xtyydmbz or (1=@xtyydmbz and m.yydm=@curr_yydm)) 
	end  
	  
	if @cxlb in (0,2)
	begin  
	 insert into #qykc(cd_idm,py,wb,ypsm,ksmc,kcsl,ypdw,ypje,ypdm,ylsj,yplb,ksdm,jjje,ypjj,cjmc,
	 cfwz,ykdw,ybmc,basicdrug_flag,gjxjje,djsl,kykcsl,yjypbz_memo,yjypsl)   
	 select y.cd_idm,rtrim(c.py),rtrim(c.wb),  
	  '名称:'+rtrim(c.ypmc)+', 厂家:'+rtrim(c.cjmc)+', 规格:'+rtrim(c.ypgg)+', 内码：'+rtrim(ltrim(convert(varchar,y.cd_idm))) as ypsm,
	  m.name as ksmc,  
	  convert(numeric(14,2),y.kcsl3/c.ykxs) as kcsl, c.ykdw as ypdw,  
	   str(y.kcsl2 * c.ylsj/c.ykxs,14,2)  as ypje, c.ypdm, str(c.ylsj,14,4) as ylsj,2 as yplb ,y.ksdm,
	   case @ypxtslt when 0 then (str((y.kcsl2 * c.ylsj/c.ykxs-y.jxje),14,2)) when 1 then (str((y.kcsl2 * c.ylsj/c.ykxs-y.jxje),14,2)) when 2 then str(y.jjje,14,2) when 3 then str(y.jjje,14,2) end,
	  str(t.ypjj/c.ykxs*D1.dwxs,14,4),c.cjmc,y.cfwz,c.ykdw,b.name,case c.basicdrug_flag when 1 then "是" when 0 then "否" end ,f.gjxjje   
	  ,CONVERT(numeric(14,2),y.djsl/c.ykxs) as djsl,CONVERT(numeric(14,2),(y.kcsl3-y.djsl)/c.ykxs) as kykcsl         
	 ,case f.yjypbz when 1 then '是' else '' end as yjypbz_memo,isnull(f.yjypsl,0)/c.ykxs as yjypsl
	 from YF_YFZKC y (nolock) inner join YK_YPCDMLK c(nolock) on y.cd_idm = c.idm  
          inner join YY_KSBMK m (nolock) on y.ksdm = m.id 
          inner join #tmp_price_yf t(nolock) on y.cd_idm= t.idm 
          inner join #tmp_ypdw D1(nolock) on D1.cd_idm=y.cd_idm
          left join YK_YPCDMLKZK f(nolock) on c.idm=f.idm  
          left join YY_YPYBFLK b(nolock) on c.ybmc=b.name
	 where  c.idm=@cgjh_idm  and (0=@xtyydmbz or (1=@xtyydmbz and m.yydm=@curr_yydm)) 
	end
end;	   

 

if object_id('tempdb..#tmp_result') is not null                                                                  
begin                                                                      
    drop table #tmp_result                                                                      
end  
/*这里用sign有什么意思，无聊
select convert(numeric(15),xh) xh,cd_idm,py as "拼音",ypsm as "药品",ksmc as "科室",(case sign(kcsl) when 1 then 1 else 0 end)  As "库存",   
            ypdw As "单位",(case sign(ypje) when 1 then ylsj else 0 end)  As "金额",ypdm "药品代码" ,ylsj "零售价" 
*/ 
select convert(numeric(15),xh) xh,cd_idm,py as "拼音",ypsm as "药品",ksmc as "科室",kcsl As "库存",   
            ypdw As "单位",ypje As "金额",ypdm "药品代码" ,ylsj "零售价",jjje "进价金额",ypjj "进价", 
			yplb,ksdm,cjmc,cfwz,ykdw,ybmc,basicdrug_flag,gjxjje ,djsl,kykcsl,kzbz,yjypbz_memo,yjypsl 
into  #tmp_result 
from #qykc (nolock) 
where 1=2 

delete from #tmp_result
    
if @IsDisplayKcslFlag=0 --0不显示实际库存，1显示实际库存
begin
	insert into  #tmp_result
	(xh,cd_idm,拼音,药品,科室,库存,单位,金额,药品代码,零售价,进价金额,进价,yplb,ksdm,
	cjmc,cfwz,ykdw,ybmc,basicdrug_flag,gjxjje,djsl,kykcsl,yjypbz_memo,yjypsl,kzbz)
	select xh,cd_idm,py as "拼音",ypsm as "药品",ksmc as "科室",(case sign(kcsl) when 1 then 1 else 0 end)  As "库存",   
			ypdw As "单位",(case sign(ypje) when 1 then ylsj else 0 end)  As "金额",ypdm "药品代码" ,ylsj "零售价" , 
			jjje As "进价金额",ypjj As "进价",yplb ,ksdm,cjmc,cfwz,ykdw,ybmc,basicdrug_flag,gjxjje,
			0 as djsl,0 as kykcsl,yjypbz_memo, yjypsl,0 as kzbz 
	from #qykc (nolock)  
end 
else
begin
	insert into  #tmp_result
	(xh,cd_idm,拼音,药品,科室,库存,单位,金额,药品代码,零售价,进价金额,进价,yplb,ksdm,
	cjmc,cfwz,ykdw,ybmc,basicdrug_flag,gjxjje,djsl,kykcsl,yjypbz_memo,yjypsl,kzbz)
	select xh,cd_idm,py as "拼音",ypsm as "药品",ksmc as "科室",kcsl As "库存",   
			ypdw As "单位",ypje As "金额",ypdm "药品代码" ,ylsj "零售价",jjje As "进价金额",ypjj As "进价", 
			yplb ,ksdm,cjmc,cfwz,ykdw,ybmc,basicdrug_flag,gjxjje ,djsl,kykcsl,yjypbz_memo, yjypsl,0 as kzbz  
	from #qykc (nolock)  
end

--过滤条件处理 start
--//停用标识：0所有 1停用 2未停用
if @m_filter2_tybz=1
begin
  delete #tmp_result from #tmp_result a
  where not exists (select 1 from YK_YPCDMLK b(nolock) where b.tybz=1 and b.idm=a.cd_idm )
end
if @m_filter2_tybz=2
begin
  delete #tmp_result from #tmp_result a
  where not exists (select 1 from YK_YPCDMLK b(nolock) where b.tybz=0 and b.idm=a.cd_idm )
end
--//库存标识：0所有 1有库存 2无库存
if @m_filter3_kcbz=1
begin
    delete #tmp_result from #tmp_result a where a.库存<=0
end

if @m_filter3_kcbz=2
begin
    select a.cd_idm,sum(a.库存) as kcsl 
	into #qyypkc_temp
	from #tmp_result a(nolock) where 1=1 
	group by a.cd_idm
	having sum(a.库存)<=0

	delete #tmp_result 
	from #tmp_result a
	where not exists(select 1 from #qyypkc_temp b where a.cd_idm=b.cd_idm)
end


--更新kzbz
--update #tmp_result set kzbz=0 

update a set a.kzbz=1 from #tmp_result a
where  (exists (select 1 from YK_YKZKC b(nolock) where b.kzbz=1 and a.ksdm=b.ksdm  and b.cd_idm=a.cd_idm and a.yplb=1))

update a set a.kzbz=1 from #tmp_result a
where  (exists(select 1 from YF_YFZKC b(nolock) where b.kzbz=1 and a.ksdm=b.ksdm  and b.cd_idm=a.cd_idm and a.yplb=2))

--//控制标识：0所有 1控制  2不控制
if @m_filter4_kzbz=1
begin
  --delete #tmp_result from #tmp_result a
  --where  (exists (select 1 from YK_YKZKC b(nolock) where b.kzbz=1 and b.cd_idm=a.cd_idm)
  --  or  exists (select 1 from YF_YFZKC b(nolock) where b.kzbz=1 and b.cd_idm=a.cd_idm))
    delete #tmp_result from #tmp_result a
    where  (exists (select 1 from YK_YKZKC b(nolock) where b.kzbz=0 and a.ksdm=b.ksdm and b.cd_idm=a.cd_idm and a.yplb=1))
    
        delete #tmp_result from #tmp_result a
    where  (exists(select 1 from YF_YFZKC b(nolock) where b.kzbz=0 and a.ksdm=b.ksdm and b.cd_idm=a.cd_idm and a.yplb=2))
end
if @m_filter4_kzbz=2
begin
  --delete #tmp_result from #tmp_result a
  --where  (exists (select 1 from YK_YKZKC b(nolock) where b.kzbz=0 and b.cd_idm=a.cd_idm)
  --  or  exists (select 1 from YF_YFZKC b(nolock) where b.kzbz=0 and b.cd_idm=a.cd_idm))
    delete #tmp_result from #tmp_result a
    where  (exists (select 1 from YK_YKZKC b(nolock) where b.kzbz=1 and a.ksdm=b.ksdm  and b.cd_idm=a.cd_idm and a.yplb=1))
    
        delete #tmp_result from #tmp_result a
    where  (exists(select 1 from YF_YFZKC b(nolock) where b.kzbz=1 and a.ksdm=b.ksdm  and b.cd_idm=a.cd_idm and a.yplb=2))
end
--//分类自负标识：0所有 1甲内药 2乙类药 3丙类药
if @m_filter5_flzfbz=1
begin
  delete #tmp_result from #tmp_result a
  where  exists (select 1 from YK_YPCDMLK b(nolock) where b.flzfbz=1 and (b.zfbl >0 and b.zfbl<1)and b.idm=a.cd_idm ) --乙类
  delete #tmp_result from #tmp_result a
  where  exists (select 1 from YK_YPCDMLK b(nolock) where b.zfbz=1 and b.zfbl =1 and b.idm=a.cd_idm ) --丙类
end
if @m_filter5_flzfbz=2
begin
  delete #tmp_result from #tmp_result a
  where  not exists (select 1 from YK_YPCDMLK b(nolock) where b.flzfbz=1 and (b.zfbl >0 and b.zfbl<1)and b.idm=a.cd_idm ) --乙类
end
if @m_filter5_flzfbz=3
begin
  delete #tmp_result from #tmp_result a
  where not exists (select 1 from YK_YPCDMLK b(nolock) where b.zfbz=1 and b.zfbl =1 and b.idm=a.cd_idm ) --丙类
end
--//存放位置开始，结束  
if rtrim(@m_filter6_cfwzStart)<>'' and rtrim(@m_filter6_cfwzEnd)<>''
begin
  delete #tmp_result from #tmp_result a
  where not exists (select 1 from YK_YKZKC b(nolock) where b.cfwz between rtrim(@m_filter6_cfwzStart) and rtrim(@m_filter6_cfwzEnd) and b.cd_idm=a.cd_idm)
    and not exists (select 1 from YF_YFZKC b(nolock) where b.cfwz between rtrim(@m_filter6_cfwzStart) and rtrim(@m_filter6_cfwzEnd) and b.cd_idm=a.cd_idm)  
end
--//OTC标识：0所有 1OTC 2非OTC
if @m_filter7_OTCbz=1
begin
  delete #tmp_result from #tmp_result a
  where exists (select 1 from YK_YPCDMLK b(nolock) where b.otcbz=0 and b.idm=a.cd_idm )
end
if @m_filter7_OTCbz=2
begin
  delete #tmp_result from #tmp_result a
  where not exists (select 1 from YK_YPCDMLK b(nolock) where b.otcbz=0 and b.idm=a.cd_idm )
end
--//自费标识：0所有 1自费
if @m_filter8_zfbz=1
begin
  delete #tmp_result from #tmp_result a
  where not exists (select 1 from YK_YPCDMLK b(nolock) where b.zfbz=1 and b.idm=a.cd_idm )
end
--//抢救药品 ：1是
if @m_filter18_qjyybz   =1
begin
  delete #tmp_result from #tmp_result a
  where not exists (select 1 from YK_YPCDMLK  b(nolock) where b.qjyybz=1 and b.idm=a.cd_idm )
end


--//贵重标识：0所有 1贵重
if @m_filter9_gzbz=1
begin
  delete #tmp_result from #tmp_result a
  where exists (select 1 from YK_YPCDMLK b(nolock) where b.gzbz=0 and b.idm=a.cd_idm )
end
--
--//特殊药品 YK_TSBZK.id 以逗号分隔
if rtrim(@str_filter10_tsypList)<>'' 
begin
  create table #tsyplist(id ut_bz null)
  select @split_source=@str_filter10_tsypList+',',@split_str=','    
  while charindex(@split_str,@split_source) > 0        
  begin        
    select @split_index = charindex(@split_str,@split_source);        
    select @split_left = substring(@split_source,1,@split_index-1);        
    if @split_left<>@split_str and isnull(@split_left,'')<>''        
    insert into #tsyplist select @split_left rs;        
    select @split_source = stuff(@split_source,charindex(@split_left+@split_str,@split_source),len(@split_left+@split_str),'')        
 end        
 if @split_source <> ''        
 begin        
   insert into #tsyplist select @split_source rs        
 end   
 delete #tmp_result from #tmp_result a
 where not exists (select 1 from YK_YPCDMLK b(nolock),#tsyplist c where b.tsbz=c.id and b.idm=a.cd_idm )          
end

-- //所属大类 YK_YPFLK.id 以逗号分隔
if rtrim(@str_filter11_ypflList)<>'' 
begin
  create table #ypflList(id ut_fldm null)
  select @split_source=@str_filter11_ypflList+',',@split_str=','    
  while charindex(@split_str,@split_source) > 0        
  begin        
    select @split_index = charindex(@split_str,@split_source);        
    select @split_left = substring(@split_source,1,@split_index-1);        
    if @split_left<>@split_str and isnull(@split_left,'')<>''        
    insert into #ypflList select @split_left rs;        
    select @split_source = stuff(@split_source,charindex(@split_left+@split_str,@split_source),len(@split_left+@split_str),'')        
 end        
 if @split_source <> ''        
 begin        
   insert into #ypflList select @split_source rs        
 end   
 delete #tmp_result from #tmp_result a
 where not exists (select 1 from YK_YPCDMLK b(nolock),#ypflList c where b.fldm=c.id and b.idm=a.cd_idm )          
end

-- //账目类别 YK_ZMLBK.id  以逗号分隔
if rtrim(@str_filter12_zmlbList)<>'' 
begin
  create table #zmlbList(id ut_dm2 null)
  select @split_source=@str_filter12_zmlbList+',',@split_str=','    
  while charindex(@split_str,@split_source) > 0        
  begin        
    select @split_index = charindex(@split_str,@split_source);        
    select @split_left = substring(@split_source,1,@split_index-1);        
    if @split_left<>@split_str and isnull(@split_left,'')<>''        
    insert into #zmlbList select @split_left rs;        
    select @split_source = stuff(@split_source,charindex(@split_left+@split_str,@split_source),len(@split_left+@split_str),'')        
 end        
 if @split_source <> ''        
 begin        
   insert into #zmlbList select @split_source rs        
 end   
 delete #tmp_result from #tmp_result a
 where not exists (select 1 from YK_YPCDMLK b(nolock),#zmlbList c where b.zmlb=c.id and b.idm=a.cd_idm )          
end

--//药品剂型 YK_YPJXK.id   以逗号分隔
if rtrim(@str_filter13_ypjxList)<>'' 
begin
  create table #ypjxLis(id ut_jxdm null)
  select @split_source=@str_filter13_ypjxList+',',@split_str=','    
  while charindex(@split_str,@split_source) > 0        
  begin        
    select @split_index = charindex(@split_str,@split_source);        
    select @split_left = substring(@split_source,1,@split_index-1);        
    if @split_left<>@split_str and isnull(@split_left,'')<>''        
    insert into #ypjxLis select @split_left rs;        
    select @split_source = stuff(@split_source,charindex(@split_left+@split_str,@split_source),len(@split_left+@split_str),'')        
 end        
 if @split_source <> ''        
 begin        
   insert into #ypjxLis select @split_source rs        
 end   
 delete #tmp_result from #tmp_result a
 where not exists (select 1 from YK_YPCDMLK b(nolock),#ypjxLis c where b.jxdm=c.id and b.idm=a.cd_idm )          
end

--//零售价开始，结束
if rtrim(@m_filter14_YlsjStart)<>'' and rtrim(@m_filter14_YlsjEnd)<>''
begin
 delete #tmp_result from #tmp_result a
 where not exists (select 1 from YK_YPCDMLK b(nolock) where b.ylsj between convert(numeric(18,4),rtrim(@m_filter14_YlsjStart)) and convert(numeric(18,4),rtrim(@m_filter14_YlsjEnd))  and b.idm=a.cd_idm )    
end

if @m_filter15_xlyybz=1 
begin
   delete #tmp_result from #tmp_result a
   inner join YK_YPCDMLKZK b(nolock) on b.idm=a.cd_idm 
   where  isnull(b.xlyy,0)=0   
end
if @m_filter17_Cyypbz=1
begin
    delete #tmp_result from #tmp_result a
    inner join YK_YPCDMLKZK b(nolock) on b.idm=a.cd_idm 
    where  isnull(b.cyypbz,0)=0
end

--过滤条件处理 end

--最终结果集
if object_id('tempdb..#tmp_zz_result') is not null                                                                  
begin                                                                      
    drop table #tmp_zz_result                                                                      
end  

 

	select a.xh,a.cd_idm,b.dydm_si21 gjgbm_id,g.zcmc gjgbm_name,a.拼音,a.药品,a.科室,a.库存,a.单位,a.金额,a.药品代码,a.零售价,a.进价金额,
		   a.进价,d.fl_mc 分类大类,c.name 药品剂型,e.name 账目类别,f.name 特殊药品,a.ksdm ,
		   a.cjmc,a.cfwz,a.ykdw,a.ybmc,a.basicdrug_flag,a.gjxjje ,a.djsl,a.kykcsl,a.kzbz,
		   a.yjypbz_memo,a.yjypsl , b.mzdw,(a.库存*b.ykxs/b.mzxs) as mzdwdykcsl,b.zydw,
		   (a.库存*b.ykxs/b.zyxs) as zydwdykcsl
	into #tmp_zz_result
	from #tmp_result a(nolock) 
		  inner join YK_YPCDMLK b(nolock) on a.cd_idm=b.idm 
		  left join YB_SI21_XYZCYXXK g(nolock) on  convert(varchar,b.dydm_si21)=g.med_list_codg
		  left join YK_YPJXK c(nolock) on b.jxdm=c.id
		  left join  YK_YPFLK d(nolock) on b.fldm=d.id
		  inner join YK_ZMLBK e(nolock) on b.zmlb=e.id 
		  left join YK_TSBZK f(nolock) on  b.tsbz=f.id
		  where b.yplh=1
   
	insert into #tmp_zz_result select a.xh,a.cd_idm,b.dydm_si21 gjgbm_id,g.sindrug_name gjgbm_name,a.拼音,a.药品,a.科室,a.库存,a.单位,a.金额,a.药品代码,a.零售价,a.进价金额,
		   a.进价,d.fl_mc 分类大类,c.name 药品剂型,e.name 账目类别,f.name 特殊药品,a.ksdm ,
		   a.cjmc,a.cfwz,a.ykdw,a.ybmc,a.basicdrug_flag,a.gjxjje ,a.djsl,a.kykcsl,a.kzbz,
		   a.yjypbz_memo,a.yjypsl , b.mzdw,(a.库存*b.ykxs/b.mzxs) as mzdwdykcsl,b.zydw,
		   (a.库存*b.ykxs/b.zyxs) as zydwdykcsl
	from #tmp_result a(nolock) 
		  inner join YK_YPCDMLK b(nolock) on a.cd_idm=b.idm 
		  left join YB_SI21_ZYYPXXK g(nolock) on  convert(varchar,b.dydm_si21)=g.med_list_codg
		  left join YK_YPJXK c(nolock) on b.jxdm=c.id
		  left join  YK_YPFLK d(nolock) on b.fldm=d.id
		  inner join YK_ZMLBK e(nolock) on b.zmlb=e.id 
		  left join YK_TSBZK f(nolock) on  b.tsbz=f.id
		  where b.yplh=2 or b.yplh=3

                                                           
	                                                                   


 
 --order by 拼音,cd_idm,科室 


if @GroupSortField=''
begin
 select @GroupSortFs=''
 select @GroupSortField='药品'  --默认分组排序
end

if(@GroupSortField='库存') or (@GroupSortField='金额') or (@GroupSortField='科室') --不能按这三个分组
begin
  if @GroupSortFs<>'' select @GroupSortFs='分组,'+@GroupSortField+' '+@GroupSortFs+','
  select @GroupSortField='药品'  --默认分组排序
end
else
begin
  if @GroupSortFs<>''  select @GroupSortFs='分组 '+@GroupSortFs+','
end

if @GroupSortField<>'' 
begin
  if @GroupSortField='零售价' 
    select @GroupSortField='convert(varchar(20),isnull(a.'+@GroupSortField+',0))+" "+a.药品'
  else if  @GroupSortField <> '药品'
    select @GroupSortField='isnull(CAST (a.'+@GroupSortField+' as varchar),"")  +" "+a.药品' 
  else
	 select @GroupSortField='isnull(a.'+@GroupSortField+',"")+" " '
end

if  charindex('科室',@GroupSortFs,1)>0
  select @GroupSortFs=@GroupSortFs+' 拼音,cd_idm'
else
   select @GroupSortFs=@GroupSortFs+' 拼音,cd_idm,科室'
 
select @lsjjehj = (select str(isnull(sum(convert(numeric(14,2),金额)),0),14,2) from #tmp_zz_result (nolock) )
select @jjjehj = (select str(isnull(sum(convert(numeric(14,2),进价金额)),0),14,2) from #tmp_zz_result (nolock) )

select @sqlstr=
' select a.xh,a.cd_idm,a.gjgbm_id,a.gjgbm_name,a.拼音,a.药品,a.科室,a.库存,a.单位,a.金额 "零售金额",a.药品代码,a.零售价,isnull(a.进价金额,0.00) 进价金额,a.进价,a.分类大类,a.药品剂型,'
+' a.账目类别,a.特殊药品,'+@GroupSortField+' 分组,'+@lsjjehj+' 零售金额合计,'+@jjjehj+' 进价金额合计,a.ksdm,a.cjmc,a.cfwz,a.ykdw,a.ybmc,'
+' a.basicdrug_flag,a.gjxjje,a.djsl,a.kykcsl,a.kzbz,a.yjypbz_memo,a.yjypsl '
+' ,a.mzdw,CONVERT(numeric(14,2),a.mzdwdykcsl) as mzdwdykcsl,a.zydw,CONVERT(numeric(14,2),a.zydwdykcsl) as zydwdykcsl '
+' from #tmp_zz_result a(nolock)  order by '+@GroupSortFs 
             

exec(@sqlstr)
   
return



GO


