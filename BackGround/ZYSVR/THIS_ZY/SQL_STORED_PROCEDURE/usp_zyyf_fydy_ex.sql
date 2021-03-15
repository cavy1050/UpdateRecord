ALTER proc usp_zyyf_fydy_ex
@wkdz varchar(32),   --网卡地址        
 @jszt smallint,    --结束状态 1=创建表，2=插入，3=递交        
 @fyxh ut_xh12=0,   --发药账单序号　0：三步递交模式YF_ZYFYZD.xh(补打)　其它：单帐单查询模式YF_ZYFYD.xh(发药打印)        
 @hzlx smallint=1,   --汇总类型　0：明细 1：汇总 2 指定单据按照病人汇总        
 @syxh ut_syxh = 0,   --指定病人首页序号　0:全部　其它：指定病人        
 @cydy smallint=1,   --草药是否打印，0：不打印 1：打印        
 @isdyphxq smallint=0,  --是否打印批号效期 0：不打印 1：打印        
 @isbd ut_bz =0,              --0为住院发药补打界面(yf_zyfy_bd.dll)，        
        --1为住院发药发药单补打界面点击病区汇总(yf_zyfy.dll)        
 @filterlb ut_bz=0,          --0 不过滤 1过滤出院带药及相关科室 2 过滤小处方 3 过滤标志 1和2的其他数据         
 @dylb ut_bz=0 ,             --0 原流程 1,2 现场自加结果集输出          
 @isShowcydy ut_bz=0,      --是否只显示出院带药 0 否 1是         
 @dsybz ut_bz=0, --0为原流程，1为显示大输液 在@bdbz=1时候有效            
 @byjbz ut_bz=0,  --0为人工摆药汇总单 1为全部汇总单  --在打印汇总单时候有效        
 @yhlcms ut_bz =0, --0为兼容老模式，1为优化后模式        
 @fyxhlist varchar(8000) ='',  --序号串         
 @isjsdmbz ut_bz =0   --过滤精神毒麻标志 0为不过滤，1为只显示精神毒麻          
 ,@ypfzdybz ut_bz=0      --药品分组打印标志             
 ,@fsbzysjbz ut_bz=0  -- 发送摆药机数据标志      
 ,@fyczyh ut_czyh='-1'  --发药操作员      
 ,@dybz ut_bz  =0 --0未打印，1为全部（包含未打印、已打印）      
 ,@cydybz ut_bz =0  ---0不是，1为出院带药标志      
 ,@xcfdybz ut_bz =0   --0不是，1为小处方标志      
 ,@djfljhlist VARCHAR(8000)='' --按单据分类过滤      
 ,@tsbzjhlist VARCHAR(8000)=''  --按特殊标志过滤         
 ,@isBrbyddy ut_bz=0 --是否病人摆药清单打印         
 ,@yzlxbz ut_bz=0    --0为所有类型医嘱 1临时医嘱 2长期医嘱         
as--集74388 2010-06-24 9:36:52 4.0标准版 201007 升级发布128    
/**********    
[版本号]4.0.0.0.0    
[创建时间]2004.12.15    
[作者]王奕    
[版权] Copyright ? 2004-2008上海金仕达-卫宁软件股份有限公司    
[描述]住院发药打印(汇总)    
[功能说明]    
 住院发药打印    
[参数CONFIG说明]    
 7018 住院发药打印是否显示自备药品信息    
 7029 住院发药中药品名称是否同时显示药品别名      
 7031 住院发药中医技药品是否分单据发药    
 7043 按3.X模式打印发药明细单据    
 7050 住院发药中手术药品是否分单据发药    
[返回值]    
[结果集、排序]    
[调用的sp]    
[调用实例]    
exec usp_zyyf_fydy_ex "0020ED674C80",1,0,0--【Clientdataset】    
exec usp_zyyf_fydy_ex "0020ED674C80",2,68013,0--【Clientdataset】    
exec usp_zyyf_fydy_ex "0020ED674C80",3,0,1--【Clientdataset】    
exec usp_zyyf_fydy_ex "0020ED674C80",3,0,0--【Clientdataset】    
    
[修改记录]    
 Modify By Koala In 2004-02-03 For :增加自备药的显示(通过设置7018开启)    
 Modify By Koala In 2004-02-04 For :增加过敏信息输出    
 Modify By Wxp In 2004-03-29 For :增加开方医生工号、病人年龄的输出    
 Modify By Koala In 2004-04-29 For :增加按组号及医嘱录入顺序排序    
 Modify By Koala In 2004-04-29 For :将药品名称和规格分开显示    
 Modify By Koala In 2004-06-08 For :增加医嘱分组序号、长期/临时标志的显示    
    Modify By agg   In 2004.0726    For :增加对草药的处理    
 Modify By Koala In 2004-10-18 For :修改婴儿处理的Bug    
 Modify by mit, in 2oo4-11-26 , 红会,与药房发药一致    
 yxp 2005-2-19 病人转区后应该显示当时的床位信息    
 zwj 2005-3-03 修改住院发药打印明细中，临时医嘱每次数量为空的bug    
    zyp 2005-3-4 将厂家和别名传出来    
 Modify By : Tony In : 2005-04-18  For : 优化性能，合并了部分重复代码    
        Modify by : xujian      In : 2005-04-30  for : 打印时增加传出开方医生和发药操作员    
 yxp 2005-5-16 二级药柜的记录应该能正确显示lylx=8    
 yxp 2005-7-12 修改bug:参数7018设置为是时，药品汇总信息会不按汇总查询    
 mly 2005-08-17 增加发药单打印兼容3.X模式    
 yxp 2006-3-2 增加功能：参数7050'住院发药中手术药品是否分单据发药'  来实现手术分单据发药    
 yxp 2006-3-30 将birth统一改成isnull(birth,'19700101')以免因birth为null报错    
 yxp 2006-4-13 住院发药需要对应修改,需要将临时医嘱对应的频次代码显示出来    
 yxp 2006-4-27 增加'转区转床标志'的传出,方便护士校对床位病人 2006-5-9 从医嘱执行时开始即算作转床    
 yxp 2006-7-20 判断转床应该根据#tempypmx的yzzxrq来判断    
 yxp 2006-9-20 ypjl的字段类型改为ut_sl14_3    
 yxp 2006-11-21 临时医嘱里的ypjl统一取BQ_LSYZK的(case when b.lz_pcdm is null then b.ypjl else b.lz_mcsl end)    
     出院带药里的ypjl统一取BQ_LSYZK的convert(numeric(10,2),h.lz_mcsl)    
 yxp 2007-1-5 单价改显示成4位小数    
 yxp 2007-1-12 代码整理，将usp_zyyf_fydy_ex2,usp_zyyf_fydy_ex2_hz合并到本usp中    
 yxp 2007-1-16 汇总信息传出时，先按剂型排序，再按药品排序    
 mly 2007-04-16 修改取发药序号增加distinct    
 insert into #fydy(fyxh) select distinct fyxh from YF_ZYFYDMX (nolock) where zdxh=@fyxh    
 mly 2007-05-21 增加诊断代码的传出。关联YY_ZDDMK     
 yxp 2007-5-22 需要从ZY_BRZDQK中取诊断,zdlb=1：入院诊断;zdlx=0：主要诊断    
 mly 2007-06-16 增加草药医嘱嘱托的传出，处方用法传出,处方嘱托传出    
 yxp 2007-09-05 参数7043（按3.X模式打印发药明细单据）改为‘是’，参数6085改为‘1’的情况下；退药和发药能单独打印，退药清单打在发药清单下面    
 yxp 2007-09-07 增加功能：参数7043为是时，能够将补临嘱(BQ_FYQQK.blzbz=1)单独打印出来，放在退药之前    
 yxp 2007-09-13 发药打印明细时，应该过滤掉BQ_YZDJFLK.dybz=1的记录--打印标志(0打印明细，1不打明细)；查询补打固定打印    
 yxp 2007-10-18 合并常州现场修改的内容,增加开关7067,住院发药时，不需要打印出院带药与输液领用单(代码固定为40)的内容    
 yxp 2007-10-21 按3.x习惯修改，按开关7043来决定，传出的给药时间分隔符为-    
     增加开关7070功能：住院发药明细打印按显示药品汇总    
     增加ggxs的传出, 明细，汇总，都增加药品拼音的传出    
     明细打印顺序：长期，临时，出院带药。床位排序时转成数字进行排序    
 yxp 2007-10-22  传出的ypsl1，按lz_mcsl来取时，需要判断dwlb=3则直接传出，否则lz_mcsl/ggxs    
        mly 2007-11-26 住院汇总领药打印排序方式1剂型+代码2存放位置    
        yxp 2008-1-9 在开关7070打开时,实现将退药信息排在最后的功能    
 yxp 2008-1-22 发药明细清单中增加药品的存放位置字段的传出    
 yxp 2008-3-20 ‘二级药柜’的汇总药品记录显示时，不显示汇总数为0的记录    
        mly 2008-04-17 增加cwdm_row'床位代码_行'以方便打印固定高度的卡片    
        mly 2008-04-25 增加汇总里显示别名名称    
 mly 2008-05-07 增加参数默认值避免取得异常数据    
 mly 2008-07-24 增加卡片号排序移到order by 的第一个.    
 mly 2008-10-09 增加打印输出项出院带药和小处方时传出医生电子签名    
 mly 2009-05-21 住院发药打印并发处理的修改。 ID:34634    
 jl 2009-06-17 分级别包装单位保存按分级包装规格保存,合并仁济单独版本的BUG    
 jl  2009-12-11 转床补打打印新床位号BUG    
 --winning-ds-chongqing-20190427擴充臨時表#tempypmx.zdname的長度varchar(32)到varchar(64)，臨時表為最終使用表，數據不會往後面流動。原存儲備份至usp_zyyf_fydy_ex_bak    
 --winning-ds-chongqing-20190522改变臨時表#tempypmx.hzxm的类型ut_name到ut_mc32，臨時表為最終使用表，數據不會往後面流動。   
**********/    
set nocount on    
--生成递交的临时表    
    
declare @tablename varchar(32)    
select @tablename='##fydy'+@wkdz    
if @jszt=1    
begin    
    exec('if exists(select * from tempdb..sysobjects where name="'+@tablename+'")    
        drop table '+@tablename)    
    exec('create table '+@tablename+'    
     (    
        fyxh ut_xh12 not null, --发药账单序号    
        )')    
    if @@error<>0    
    begin    
select "F","创建临时表时出错！"    
     return    
    end    
    select "T"    
    return    
end    
--插入递交的记录    
if @jszt=2    
begin    
    declare @cfyxh varchar(12)    
    select @cfyxh=convert(varchar(12),@fyxh)    
    exec('insert into '+@tablename+' values('+@cfyxh+')')    
    if @@error<>0    
    begin    
        select "F","插入临时表时出错！"    
        return    
    end    
    select "T"    
 return    
end    
    
declare @zby  ut_bz,  --是否显示自备药标志 0否-1是    
  @bmbz  ut_bz,  --是否显示药品别名标志 0否-1是　转自usp_zyyf_fydy_ex2,usp_zyyf_fydy_ex2_hz    
  @yjflbz ut_bz,  --医技分单据发药标志    
  @ssflbz ut_bz,  --手术分单据发药标志    
  @printfs ut_bz  --是否按3.X模式打印发药明细0否1是    
  ,@printhz ut_bz  --住院发药明细打印按显示药品汇总    
                ,@printpxfs ut_bz       --住院汇总领药打印排序方式1剂型+代码2存放位置    
  ,@cardlength int         --卡片显示的记录条数     
select @zby = (case isnull(config,'否') when '是' then -1 else 0 end) from YY_CONFIG(nolock) where id = '7018'    
select @zby = isnull(@zby,'否')    
select @bmbz = (case isnull(config,'否') when '是' then -1 else 0 end) from YY_CONFIG(nolock) where id = '7029'    
select @bmbz = isnull(@bmbz,'否')    
SELECT @yjflbz = (CASE ISNULL(config,'否') WHEN '是' THEN 1 ELSE 0 END) FROM YY_CONFIG(nolock) WHERE id = '7031'    
select @yjflbz = isnull(@yjflbz,'否')    
SELECT @ssflbz = (CASE ISNULL(config,'否') WHEN '是' THEN 1 ELSE 0 END) FROM YY_CONFIG(nolock) WHERE id = '7050'    
select @ssflbz = isnull(@ssflbz,'否')    
Select @printfs = (CASE ISNULL(config,'否') WHEN '是' THEN 1 ELSE 0 END) FROM YY_CONFIG(nolock) WHERE id = '7043'    
select @printfs = isnull(@printfs,'否')    
Select @printhz = (CASE ISNULL(config,'否') WHEN '是' THEN 1 ELSE 0 END) FROM YY_CONFIG(nolock) WHERE id = '7070'    
select @printhz = isnull(@printhz,'否')    
Select @printpxfs = isnull(config,1) From YY_CONFIG(nolock) WHERE id = '7071'     
select @printpxfs = isnull(@printpxfs,1)    
select @cardlength = isnull(config,0) From YY_CONFIG(nolock) WHERE id = '7072'     
select @cardlength = isnull(@cardlength,0)    
--开始插入账单、明细表的处理流程    
create table #fydy    
(    
 fyxh  ut_xh12  not null, --发药账单序号    
 lylx  smallint  null,  --领药类型(0退药，1医嘱，2出院带药，3婴儿费用，4小处方，5手术发药请求，6医技发药请求,7草药录入,8二级药柜)    
 lylx_sm varchar(16) null,  --领药类型说明    
 djfl  ut_dm4   null,  --单据分类    
 djmc  ut_mc32  null,  --单据名称    
)    
if @fyxh=0--发药账单序号　0：三步递交模式YF_ZYFYZD.xh　其它：单帐单查询模式YF_ZYFYD.xh     
 exec('insert into #fydy(fyxh) select * from '+@tablename)    
else    
    --mly 2009-05-21 住院发药打印并发处理的修改。确保事务都提交完成了再读取打印.判断YF_ZYFYZD.jzbz = 1    
 insert into #fydy(fyxh) select distinct fyxh from YF_ZYFYDMX a,YF_ZYFYZD b     
 where a.fyxh = b.xh and b.jzbz in (1,2) and  a.zdxh=@fyxh    
 if @@error<>0    
 begin    
  select "F","插入临时表时出错！"    
  return    
 end    
    
update #fydy set lylx=b.lylx,    
    lylx_sm=(case b.lylx when 1 then '医嘱领药' when 2 then '出院带药' when 3 then '婴儿费用'    
  when 4 then '小处方' when 5 then '手术发药' when 6 then '医技发药' when 7 then '草药处方'     
  when 8 then '二级药柜' else '其它' end),    
    djfl=CASE WHEN (@yjflbz = 0 AND b.lylx = 6) THEN null WHEN (@ssflbz = 0 AND b.lylx = 5) THEN null ELSE b.djfl END,     
    djmc=CASE WHEN (@yjflbz = 0 AND b.lylx = 6) THEN null WHEN (@ssflbz = 0 AND b.lylx = 5) THEN null ELSE c.name END    
from #fydy a, YF_ZYFYZD b (nolock), BQ_YZDJFLK c (nolock)    
where a.fyxh=b.xh and b.djfl*=c.id    
if @@error<>0    
begin    
    select "F","更新临时表时出错！"    
    return    
end    
    
--yxp 2007-10-18 合并常州现场修改的内容,增加开关7067,住院发药时，不需要打印出院带药与输液领用单(代码固定为40)的内容    
if @fyxh<>0 and exists(select 1 from YY_CONFIG (nolock) where id='7067' and config='否')    
 delete from #fydy where lylx='2' or djfl='40'      
    
--生成别名库    
select idm,max(bmmc) bmmc into #temp_bm from YK_YPBMK (nolock) group by idm    
    
if @hzlx=0    --发药明细  病人姓名  住院号  床位号  药品名称  规格  剂量  剂量单位  实发数量 单位  用法  频次 执行日期  执行时间    
begin    
 if @fyxh=0--发药账单序号　0：三步递交模式　其它：单帐单查询模式    
     exec('drop table '+@tablename)    
 else  --yxp 2007-09-13 发药打印明细时，应该过滤掉BQ_YZDJFLK.dybz=1的记录--打印标志(0打印明细，1不打明细)；查询补打固定打印    
  delete #fydy where lylx=1 and exists(select 1 from BQ_YZDJFLK where dybz=1 and BQ_YZDJFLK.id=#fydy.djfl)    
    
    create table #tempypmx    
    (    
     xh ut_xh12 identity(1,1),    
  ksmc ut_mc32 null,--科室名称    
  hzxm ut_mc32 null,    
  blh  ut_blh     null,    
  cwdm ut_cwdm    null,    
  ypmc ut_mc64 null,    
  ypgg ut_mc32    null,    
  ypjl ut_sl14_3 null,           --药品计量    
  jldw varchar(24)  null,   --计量单位---ut_dm4 太短换ut_mc   
  ypsl ut_sl10 null,           --实发数量    
  ypdj numeric(12,4) default 0,       
  ypje numeric(12,2) default 0,    
  ypdw varchar(24)   null,   --药品单位    
  yfmc ut_mc16 null,     --药品用法名称    
  pcdm ut_dm2  null,               
  pc   ut_mc32    null,    
  zxrq ut_rq16 null,    
  zxsj ut_mc64 null,    
  cd_idm ut_xh9   null,    
  ypsl1 ut_sl10 null,           --每次数量    
  lylx smallint  null,    
  lylx_sm varchar(16) null,    
  djfl ut_dm4  null,    
  djmc ut_mc32  null,    
  yeyz ut_mc16  null, --婴儿医嘱    
  ztnr ut_mc64  null,    
  qqrq ut_rq16  null,    
  fyrq ut_mc32  null,   --增加发药账单的发药日期    
  gmxx varchar(100) null,    
  yzzxrq ut_rq16  null,   --医嘱执行日期    
  ysdm  ut_czyh  null,  --医生代码    
  hznl int default 30,   --患者年龄    
  yzxh ut_xh12  null,  --医嘱序号    
  fzxh ut_xh12  null, --分组序号    
  qqlxsm ut_name  null,  --长期/临时    
  yfdm ut_ksdm  null, --药房代码    
  fyyf  ut_mc32  null, --药房名称    
      memo ut_memo    null  --显示是否代煎 add by zyp    
  ,sex ut_sex  null --mit , 2oo4-1o-28 , 性别    
  ,cfts smallint  null --mit , 2oo4-1o-28 , 草药用帖数    
  ,fyczyh ut_czyh null    
      ,lb   int    null   --排序字段1: 3.x：0(临时)1(长期口服)2(长期针剂)90(补临嘱)99(退药排在最后)    4.0：lylx    
  ,yfdl   ut_dm4  null   --排序字段2: 3.x：用法大类       4.0：djfl    
  ,zqzcbz ut_bz null --转区转床标志     
  ,lrczyh ut_czyh null     --录入操作员号 转自usp_zyyf_fydy_ex2,usp_zyyf_fydy_ex2_hz    
  ,ypyl  varchar(12) null    --去掉.000的药品剂量  转自usp_zyyf_fydy_ex2,usp_zyyf_fydy_ex2_hz    
  ,dwlb   ut_bz   null --单位类别 转自usp_zyyf_fydy_ex2,usp_zyyf_fydy_ex2_hz    
  ,ybdm   varchar(10) null   --医保代码 转自usp_zyyf_fydy_ex2,usp_zyyf_fydy_ex2_hz    
  ,zdname varchar(64) null    -- 诊断名称    
  ,ypyfdm ut_dm2 null         --明细用法代码    
  ,ypyfmc ut_mc32 null        --处方用法名称    
  --,cfztmc ut_mc32 null        --处方嘱托名称    
   ,cfztmc ut_mc256 null        --处方嘱托名称 
  ,cardrow int    null        --卡片行号    
  ,dzyzimage image null       --电子印章图片    
  ,qqxh  ut_xh12 null   --请求序号     
    )        
    
 if exists(select 1 from #fydy where lylx=1)    --医嘱领药，到单据    
    begin    
        insert into #tempypmx    
        select l.name as ksmc, b.hzxm, c.blh, c.cwdm, a.ypmc, x.ypgg,--m.ksmc a.ypgg    
   (case when b.lz_pcdm is null then b.ypjl else b.lz_mcsl end),b.jldw,    
   (case b.zbybz when 0 then convert(numeric(10,2),a.ypsl/a.dwxs) else 0 end),     
   convert(numeric(12,4),a.ylsj*a.dwxs/a.ykxs),         
            (case b.zbybz when 0 then convert(numeric(12,2),a.ypsl*a.ylsj/a.ykxs) else 0 end),a.ypdw,      
            d.name, b.pcdm, (case isnull(b.lz_pcdm,'') when '' then 'ST' else e.name end),     
            a.qqrq as zxrq,(case b.lz_zxsj when null then '' else b.lz_zxsj end) zxsj,     
            a.cd_idm, (case b.zbybz when 0 then (case when isnull(b.lz_mcsl,0)=0 then b.ypsl else     
   --yxp 传出的ypsl1，按lz_mcsl来取时，需要判断dwlb=3则直接传出，否则lz_mcsl/ggxs b.lz_mcsl end) else 0 end ) ypsl,     
   (case when b.dwlb=3 then b.lz_mcsl else b.lz_mcsl/y.ggxs end) end) else 0 end ) ypsl1,    
            f.lylx, f.lylx_sm, f.djfl, f.djmc, (case when b.yexh > 0 then '婴儿' else '' end) yeyz,     
            (case b.zbybz when 0 then b.ztnr else '自备药' end) ztnr, a.qqrq, g.fyrq,    
            (case when b.yexh > 0 then h.gmxx else c.gmxx end) gmxx, m.zxrq as yzzxrq,    
   b.ysdm,datediff(yy,isnull(c.birth,'19700101'),getdate())+1, b.xh, b.fzxh, '临时',    
   --yxp o.name,'' as memo,c.sex,1,g.fyczyh,0 as lb,d.lb as yfdl,0,    
   n.yfdm,o.name,'' as memo,c.sex,1,g.fyczyh,(case when isnull(b.blzbz,0)=1 then 90 else 0 end) as lb,d.lb as yfdl,0,    
   b.lrczyh,'' as ypyl, b.dwlb, c.ybdm,z.zdmc,'','','',0,'',a.qqxh    
        from YF_ZYFYMX a (nolock), BQ_LSYZK b (nolock), ZY_BRSYK c (nolock), ZY_YPYFK d (nolock), ZY_YZPCK e (nolock), #fydy f (nolock),    
   YF_ZYFYD g(nolock), BQ_HZLYD m (nolock),YF_ZYFYZD n(nolock),YF_YFDMK o, ZY_BABYSYK h (nolock),    
   ZY_BRZDQK z(nolock), YK_YPCDMLK y (nolock),BQ_FYQQK x(nolock),ZY_BQDMK l(nolock)    
        where a.fyxh=f.fyxh and a.qqlx=0 and b.xh=a.yzxh and c.syxh=a.syxh and d.id=*b.ypyf and f.lylx=1 and a.zdxh=g.xh    
   and (b.zbybz = @zby or @zby = -1) and a.fyxh=n.xh and m.xh=n.lyxh and b.lz_pcdm*=e.id       
   and n.yfdm=o.id and b.yexh *= h.xh and c.syxh*=z.syxh and z.zdlb=1 and z.zdlx=0    
   and a.cd_idm=y.idm and x.bqdm=l.id and a.qqxh=x.xh    
    
        insert into #tempypmx    
        select l.name as ksmc, b.hzxm, c.blh, c.cwdm, a.ypmc, x.ypgg, --m.ksmc,a.ypgg    
         b.ypjl, b.jldw,     
         (case b.zbybz when 0 then convert(numeric(10,2),a.ypsl/a.dwxs) else 0 end),          
            convert(numeric(12,4),a.ylsj*a.dwxs/a.ykxs),    
            (case b.zbybz when 0 then convert(numeric(12,2),a.ypsl*a.ylsj/a.ykxs) else 0 end), a.ypdw,    
            d.name, b.pcdm, e.name,     
            a.qqrq, (case  when b.zxzqdw=1 then '每'+convert(varchar(4),b.zxzq)+'小时一次' when b.zxzqdw=2 then '每'+convert(varchar(4),b.zxzq)+'分钟一次' else  b.zxsj end),    
            a.cd_idm, b.ypsl, f.lylx, f.lylx_sm, f.djfl, f.djmc, case when b.yexh > 0 then '婴儿' else '' end yeyz,     
            (case b.zbybz when 0 then b.ztnr else '自备药' end) ztnr ,a.qqrq, g.fyrq,    
   (case when b.yexh > 0 then h.gmxx else c.gmxx end) gmxx,m.zxrq    
   ,b.ysdm,datediff(yy,isnull(c.birth,'19700101'),getdate())+1,b.xh, b.fzxh, '长期',    
   n.yfdm,o.name,'',c.sex ,1,g.fyczyh, (case when  b.ypyf  in ("03","04","05")  then 1  else  2  end),d.lb,0,    
   b.lrczyh,'' as ypyl, b.dwlb, c.ybdm,z.zdmc ,'','','',0,'',a.qqxh    
     from YF_ZYFYMX a (nolock), BQ_CQYZK b (nolock), ZY_BRSYK c (nolock), ZY_YPYFK d (nolock), ZY_YZPCK e (nolock), #fydy f (nolock),    
         YF_ZYFYD g(nolock) , BQ_HZLYD m (nolock),YF_ZYFYZD n(nolock),YF_YFDMK o, ZY_BABYSYK h (nolock),    
   ZY_BRZDQK z(nolock),BQ_FYQQK x(nolock),ZY_BQDMK l(nolock)    
        where a.fyxh=f.fyxh and a.qqlx=1 and b.xh=a.yzxh and c.syxh=a.syxh and d.id=*b.ypyf and f.lylx=1 and a.zdxh=g.xh    
   and (b.zbybz = @zby or @zby = -1) and a.fyxh=n.xh and m.xh=n.lyxh and e.id=b.pcdm     
   and n.yfdm=o.id and b.yexh *= h.xh and c.syxh*=z.syxh and z.zdlb=1 and z.zdlx=0 and a.qqxh=x.xh and x.bqdm=l.id    
    end    
    if exists(select 1 from #fydy where lylx in (2))  --出院带药    
    begin    
  insert into #tempypmx    
  select l.name as ksmc, b.hzxm, b.blh, b.cwdm, a.ypmc, x.ypgg  --a.ypgg    
   , convert(numeric(10,2),h.lz_mcsl), h.jldw    
   , convert(numeric(10,2),a.ypsl/a.dwxs)    
   , convert(numeric(12,4),a.ylsj*a.dwxs/a.ykxs),convert(numeric(12,2),a.ypsl*a.ylsj/a.ykxs),a.ypdw    
   , i.name, h.pcdm, case h.lz_pcdm when null then 'ST' else j.name end, a.qqrq, case h.lz_zxsj when null then '' else h.lz_zxsj end zxsj,       
   a.cd_idm,case h.lz_mcsl when 0 then h.ypsl else h.lz_mcsl end ypsl     
   , f.lylx, f.lylx_sm, f.djfl, f.djmc,case when h.yexh > 0 then '婴儿' else '' end yeyz,     
   (case h.zbybz when 0 then h.ztnr else '自备药' end) ztnr      
   , a.qqrq, g.fyrq, b.gmxx,m.zxrq,h.ysdm    
   , datediff(yy,isnull(b.birth,'19700101'),getdate())+1,a.yzxh, a.yzxh, '临时',    
   n.yfdm,o.name,'', b.sex, 1,g.fyczyh ,0 ,0 ,0,    
   h.lrczyh,'' as ypyl, 3 as dwlb, b.ybdm,z.zdmc,'','','',0,s.dzyzimage,a.qqxh    
  from YF_ZYFYMX a (nolock), ZY_BRSYK b (nolock),#fydy f (nolock),    
   YF_ZYFYD g(nolock), BQ_HZLYD m (nolock),YF_ZYFYZD n(nolock), YF_YFDMK o(nolock)    
   ,BQ_LSYZK h (nolock) ,ZY_YPYFK i (nolock), ZY_YZPCK j (nolock),ZY_BRZDQK z(nolock),BQ_FYQQK x(nolock),YY_ZGBMK s(nolock),ZY_BQDMK l(nolock)    
  where a.fyxh=f.fyxh and b.syxh=a.syxh and a.fyxh=n.xh and m.xh=n.lyxh     
   and f.lylx in (2) and a.zdxh=g.xh and n.yfdm=o.id    
   and h.xh=a.yzxh and i.id=*h.ypyf and j.id=*h.lz_pcdm and b.syxh*=z.syxh and z.zdlb=1 and z.zdlx=0    
   and a.qqxh = x.xh and x.ysdm *= s.id and x.bqdm=l.id    
    end    
    if exists(select 1 from #fydy where lylx in (3,4,8))  --婴儿费用、小处方    
    begin    
        insert into #tempypmx    
        select l.name as ksmc, b.hzxm, b.blh, b.cwdm, a.ypmc, x.ypgg, --m.ksmc,a.ypgg     
         convert(numeric(10,2),a.ypsl/a.dwxs), a.ypdw, convert(numeric(10,2),a.ypsl/a.dwxs),    
            convert(numeric(12,4),a.ylsj*a.dwxs/a.ykxs),convert(numeric(12,2),a.ypsl*a.ylsj/a.ykxs),a.ypdw,    
            '', '', '', a.qqrq, '', a.cd_idm, convert(numeric(10,2),a.ypsl/a.dwxs), f.lylx, f.lylx_sm, f.djfl, f.djmc,'','',a.qqrq,    
   g.fyrq, b.gmxx,m.zxrq,'',datediff(yy,isnull(b.birth,'19700101'),getdate())+1,a.yzxh, a.yzxh, '临时',    
   n.yfdm,o.name,''    
   ,b.sex ,1,g.fyczyh ,0 ,0 ,0,    
   '' as lrczyh,'' as ypyl, 3 as dwlb, b.ybdm,z.zdmc,'','','',0,s.dzyzimage,a.qqxh    
        from YF_ZYFYMX a (nolock), ZY_BRSYK b (nolock), #fydy f (nolock),    
         YF_ZYFYD g(nolock), BQ_HZLYD m (nolock),YF_ZYFYZD n(nolock),YF_YFDMK o(nolock),ZY_BRZDQK z(nolock),BQ_FYQQK x(nolock),YY_ZGBMK s(nolock),ZY_BQDMK l(nolock)    
        where a.fyxh=f.fyxh and b.syxh=a.syxh and a.fyxh=n.xh and m.xh=n.lyxh    
  and f.lylx in (3,4,8) and a.zdxh=g.xh and n.yfdm=o.id and b.syxh*=z.syxh and z.zdlb=1 and z.zdlx=0    
  and a.qqxh = x.xh and x.ysdm *= s.id and x.bqdm=l.id     
    end    
    if exists(select 1 from #fydy where lylx in (5,6))  --医技、手术    
    begin    
       insert into #tempypmx    
        select l.name as ksmc,b.hzxm, b.blh, b.cwdm, a.ypmc, p.ypgg, --m.ksmc,a.ypgg    
        convert(numeric(10,2),a.ypsl/a.dwxs), a.ypdw, convert(numeric(10,2),a.ypsl/a.dwxs),    
            convert(numeric(12,4),a.ylsj*a.dwxs/a.ykxs),convert(numeric(12,2),a.ypsl*a.ylsj/a.ykxs),a.ypdw,    
            '', '', '', a.qqrq, '', a.cd_idm, convert(numeric(10,2),a.ypsl/a.dwxs), f.lylx, f.lylx_sm, f.djfl, f.djmc,case when p.yexh > 0 then '婴儿' else '' end yeyz,'',a.qqrq,    
   g.fyrq, b.gmxx,m.zxrq,'',datediff(yy,isnull(b.birth,'19700101'),getdate())+1,a.yzxh, a.yzxh, '临时',    
   n.yfdm,o.name,''    
   ,b.sex ,1,g.fyczyh ,0 ,0 ,0,    
   '' as lrczyh,'' as ypyl, 3 as dwlb, b.ybdm,z.zdmc,'','','',0,'',a.qqxh    
        from YF_ZYFYMX a (nolock), ZY_BRSYK b (nolock), #fydy f (nolock),    
         YF_ZYFYD g(nolock), BQ_HZLYD m (nolock),YF_ZYFYZD n(nolock),YF_YFDMK o(nolock),ZY_BRZDQK z(nolock),BQ_YJFYQQK p(nolock),ZY_BQDMK l(nolock)    
        where a.fyxh=f.fyxh and b.syxh=a.syxh and a.fyxh=n.xh and m.xh=n.lyxh    
  and f.lylx in (5,6) and a.zdxh=g.xh and n.yfdm=o.id and b.syxh*=z.syxh and z.zdlb=1 and z.zdlx=0 and a.qqxh=p.xh and p.bqdm=l.id     
    end    
    
    if exists(select 1 from #fydy where lylx in (7))  --草药    
    begin--mit ,2oo4-11-26 ,改动草药,传出付数,用法,频次    
        insert into #tempypmx     
        select t.name as ksmc, b.hzxm, b.blh, b.cwdm, a.ypmc, k.ypgg  --m.ksmc,a.ypgg    
, convert(numeric(10,2),l.mcjl/a.dwxs), a.ypdw, convert(numeric(10,2),a.ypsl/a.dwxs)    
   , convert(numeric(12,4),a.ylsj*a.dwxs/a.ykxs),convert(numeric(12,2),a.ypsl*a.ylsj/a.ykxs),a.ypdw    
   , d.name, k.pcdm,e.name, a.qqrq, '', a.cd_idm, convert(numeric(10,2),k.mcsl/a.dwxs), f.lylx, f.lylx_sm, f.djfl, f.djmc,'',k.yzzt,a.qqrq    
   , g.fyrq, b.gmxx, m.zxrq,k.ysdm,datediff(yy,isnull(b.birth,'19700101'),getdate())+1,a.yzxh, a.yzxh, '临时',    
   n.yfdm,o.name,m.memo    
      ,b.sex, l.cfts,g.fyczyh,0 ,0 ,0,    
      '' as lrczyh,'' as ypyl, 3 as dwlb, b.ybdm, z.zdmc,l.cfypyf,l.yfmc,l.cfzt,0,'',a.qqxh    
        from YF_ZYFYMX a (nolock), ZY_BRSYK b (nolock), ZY_YPYFK d (nolock)    
            , ZY_YZPCK e (nolock), #fydy f (nolock), YF_ZYFYD g(nolock), BQ_HZLYD m (nolock),YF_ZYFYZD n(nolock),ZY_BQDMK t(nolock)    
            , BQ_FYQQK k(nolock)--agg YF_ZYFYMXK中的yzxh对于草药方子复用填BQ_FYQQK中的xh    
      , YF_YFDMK o(nolock), BQ_YS_ZY l(nolock), ZY_BRZDQK z(nolock)      
  where a.fyxh=f.fyxh and b.syxh=a.syxh and a.fyxh=n.xh and m.xh=n.lyxh and a.yzxh=k.xh     
            and k.ypyf*=d.id and k.pcdm*=e.id     
      and f.lylx in (7) and a.zdxh=g.xh and n.yfdm=o.id    
            and k.lyxh*=l.lyxh --yxp 2007-1-16 改为*=，因草药录入调出修改时，会造成关联不到    
      and a.cd_idm*=l.cd_idm --mit , 2oo4-11-o4, 增加这个条件,否则会重复    
   and b.syxh*=z.syxh and z.zdlb=1 and z.zdlx=0  and t.id=k.bqdm    
       
 --add by mly 2007-06-15    
 --update #tempypmx set yfmc = b.name from #tempypmx a, ZY_YPYFK b where a.ypyfdm = b.id and b.jlzt = 0    
    end     
       
    if @bmbz=-1--是否显示药品别名标志　0否-1是    
 begin    
  update b set ypmc=b.ypmc+'('+c.bmmc+')'    
  from #tempypmx b,#temp_bm c where b.cd_idm=c.idm    
 end     

 --add by yangdi 2021.2.23 更新中药备注信息
 if exists(select 1 from #fydy where lylx in (7))  --草药
 BEGIN
  UPDATE a SET a.ztnr=y.MEMO FROM #tempypmx a
	INNER JOIN dbo.BQ_FYQQK b ON a.qqxh=b.xh
	INNER JOIN dbo.BQ_LSYZK c ON b.yzxh=c.xh
	INNER JOIN CISDB.dbo.CPOE_LSYZK x (NOLOCK) ON c.v5xh=x.XH
	INNER JOIN CISDB.dbo.CPOE_ORDERITEM y (NOLOCK) ON x.XH=y.YZXH
 WHERE y.YPDM=b.ypdm
END
 
 --如果是换床直接从病人费用明细中取 jl 20091211    
 create table #tempcwdm(qqxh ut_xh12,cwdm ut_cwdm)    
 insert into #tempcwdm     
 select distinct a.qqxh,c.cwdm from #tempypmx a,ZY_BRSYK b,ZY_BRFYMXK c    
    where a.qqxh=c.qqxh and a.hzxm=b.hzxm and a.yzxh=c.yzxh and a.blh=b.blh and b.syxh=c.syxh and c.idm<>0    
      
 update a set a.cwdm=b.cwdm from #tempypmx a,#tempcwdm b where a.qqxh=b.qqxh     
 --yxp 2005-2-19 病人转区后应该显示当时的床位信息    
 update a set cwdm=isnull(c.cwdm,a.cwdm), zqzcbz=1    
 from #tempypmx a, ZY_BRSYK b (nolock), BQ_BRZKQQK c (nolock)    
 where a.hzxm=b.hzxm and a.blh=b.blh and b.syxh=c.syxh and b.bqdm=c.bqdm1 and a.yzzxrq <c.qrrq --yxp 2006-5-9 and a.fyrq <c.qrrq     
  and c.jlzt=1    
      
 --mit ,2oo4-12-16 ,处理血透室的情况,广州红会当icu处理,床位要保留血透室的床位    
 if exists(select 1 from ZY_BQDMK b(nolock), YF_ZYFYZD d(nolock),#fydy c    
   where b.lb=3 and d.bqdm=b.id and d.xh=c.fyxh)    
 begin    
  select max(xh) xh,syxh into #icudjk from BQ_ICUDJK(nolock)  group by syxh    
  select a.syxh, a.icucwdm into #icucwdm from BQ_ICUDJK a(nolock) , #icudjk b where a.xh=b.xh    
     
  select c.hzxm, c.blh, isnull(b.icucwdm,c.cwdm) cwdm    
  into #icudjk1     
  from #icucwdm b, #tempypmx c, ZY_BRSYK d(nolock)     
  where c.hzxm=d.hzxm and c.blh=d.blh and brzt not in (0,3,8,9) and d.syxh=b.syxh    
     
  update #tempypmx    
  set cwdm=b.cwdm    
  from #tempypmx a, #icudjk1 b    
  where a.hzxm=b.hzxm and a.blh=b.blh and b.cwdm is not null      
 end    
    
 ---合并福州省立 2006-03-08    
 update  a    
 set ypyl = (case when a.lylx = 2 then convert(varchar(12),convert(numeric(12,3),ypsl1))        
   else (case a.dwlb when 0 then convert(varchar(12),convert(numeric(12,3),(a.ypjl/b.ggxs)))         
   else convert(varchar(12),convert(numeric(12,3),(a.ypjl/b.zyxs))) end) end)    
 from #tempypmx a, YK_YPCDMLK b (nolock)    
 where a.cd_idm=b.idm                 
    
 --去掉ypyl中的'.000'    
 update  #tempypmx  set ypyl=replace(ypyl,'.000','')    
    
 --增加卡片显示的记录条数    
 if @cardlength > 0     
 begin    
  declare @cardno int --记录卡片数    
  declare @i int      --记录每张卡片有几条记录    
  declare @c_oldcwdm ut_cwdm    
      
  declare @c_count int      
  declare @c_cwdm ut_cwdm    
  declare @c_xh ut_xh12    
    
  --临时卡片 这里临时长期卡片不分，如果需要临时长期区分卡片，则要单独处理    
  select xh,cwdm into #card_ls from #tempypmx order by cwdm--where qqlxsm ='临时'    
  select @cardno = 0,@i = 0,@c_oldcwdm = '0'        
  declare ypmx_cur cursor     
                for select xh,cwdm from #card_ls     
                order by cwdm     
  open ypmx_cur    
  fetch ypmx_cur into @c_xh,@c_cwdm    
  while (@@fetch_status = 0)    
  begin    
   if @c_cwdm <> @c_oldcwdm  --床位代码不等于旧的床位代码则重新开始编排卡片号    
   begin    
    select @i = 0    
    select @cardno = @cardno + 1    
   end    
   if @i >= @cardlength     --如果一张卡片中的内容等于每行的记录数卡片数加1记录数    
   begin       
        select @i = 0    
        select @cardno = @cardno + 1    
   end    
    
   update #tempypmx    
   set cardrow = @cardno    
   where xh = @c_xh    
       
        
   select @i = @i + 1    
   select @c_oldcwdm = @c_cwdm    
   fetch ypmx_cur into @c_xh,@c_cwdm    
  end    
  close ypmx_cur    
  deallocate ypmx_cur      
  /*    
  --长期卡片    
  select xh,cwdm into #card_cq from #tempypmx where qqlxsm ='长期'    
  select @i = 0,@c_oldcwdm = '0'        
  declare ypmx_cur cursor     
                for select xh,cwdm from #card_cq     
                order by cwdm     
  open ypmx_cur    
  fetch ypmx_cur into @c_xh,@c_cwdm    
  while (@@fetch_status = 0)    
  begin    
   if @c_cwdm <> @c_oldcwdm  --床位代码不等于旧的床位代码则重新开始编排卡片号    
   begin    
    select @i = 0    
    select @cardno = @cardno + 1    
   end    
   if @i >= @cardlength     --如果一张卡片中的内容等于每行的记录数卡片数加1记录数    
   begin       
        select @i = 0    
        select @cardno = @cardno + 1    
   end    
             
   update #tempypmx    
   set cardrow = @cardno    
   where xh = @c_xh    
    
   select @i = @i + 1    
   select @c_oldcwdm = @c_cwdm    
   fetch ypmx_cur into @c_xh,@c_cwdm    
  end    
  close ypmx_cur    
  deallocate ypmx_cur     
  */    
     
 end    
      
 --yxp 2007-10-21 增加开关7070功能：住院发药明细打印按显示药品汇总    
 if @printhz =1    
 begin    
  --yxp 2007-10-21 按3.x习惯修改，按开关7043来决定，传出的给药时间分隔符为-    
  update #tempypmx  set zxsj=replace(substring(zxsj,1,(case when len(zxsj)>=1 then (len(zxsj)-1) else 0 end)),',','-')    
    
  update  #tempypmx  set  lb=99  where   ypsl<0--yxp 2008-1-9 在开关7070打开时,实现将退药信息排在最后的功能    
  update  #tempypmx  set  lb=-1  where   lb in (1,2) and ypsl>=0--排序为长期，临时，出院带药，长期的类别改为-1    
  update  #tempypmx  set  yfdl='0'    
    
  select rtrim(cwdm)+'['+rtrim(hzxm)+']'+rtrim(blh) "床号[患者姓名]", blh "住院号",    
     rtrim(a.ypmc)+ '['+rtrim(a.ypgg)+']' "药品名称[规格]" , rtrim(convert(varchar(12),a.ypjl))+rtrim(jldw) "剂量",     
     convert(numeric(12,2),ypsl1)  "每次数量",    
     a.yfmc "用法", a.pc "频次", a.zxsj "给药时间", rtrim(convert(varchar(12),sum(a.ypsl)))+rtrim(a.ypdw) "实发",    
     a.lylx, a.lylx_sm "领药类型", 
	-- a.djfl, 
	 a.djmc "单据名称",a.ypdj "药品单价",sum(a.ypje) "药品金额",a.yeyz "是否婴儿医嘱",     
     a.ztnr "医嘱嘱托",sum(ypsl) ypsl,ypdw,b.ggdw,b.ggxs*ypsl1 as ypjl , b.ggxs    
  ,b.ypdm,cwdm "床号",cardrow--传出床位号，Add By Lingzhi ,2003.07.22    
  ,substring(a.fyrq,1,4)+'-'+substring(a.fyrq,5,2)+'-'+substring(a.fyrq,7,2)+' '+substring(a.fyrq,9,8) "发药日期"--住院发药账单的发药日期 add by wuming 2004-02-01    
  , a.gmxx,a.ysdm 医生代码,a.hznl 患者年龄, a.fzxh, a.qqlxsm,    
     a.memo "是否代煎",e.name "开方医生",f.name "发药操作员"--add by zyp   2004.11.03 显示代煎    
  ,a.sex "性别", a.cfts "处方帖数",a.lb,case when isnull(a.zqzcbz,0)=0 then "" else "转" end "转区转床标志"    
  ,b.cjmc "厂家名称",a.lrczyh,a.ksmc ksmc,e.name "医生姓名",rtrim(a.ypmc) "药品名称",    
  case charindex('*',a.ypgg) when 0 then a.ypgg else rtrim(left(a.ypgg,charindex('*',a.ypgg)-1)) end "药品规格",     
     rtrim(a.hzxm) "患者姓名",c.ybsm "医保说明" ,    
     case when (g.zxzqdw=0) then convert(varchar(5),g.zxzq)+'天'+convert(varchar(5),g.zxcs)+'次'    
     when (g.zxzqdw=-1) then '每周'+rtrim(ltrim(g.zbz))+',每天'+convert(varchar(5),g.zxcs)+'次'    
     when (g.zxzqdw=1) then '每次'+rtrim(ltrim(g.zxzq))+'小时'    
     when (g.zxzqdw=2) then '每次'+rtrim(ltrim(g.zxzq))+'秒' end "执行次数", a.zdname "诊断名称",a.ypyfmc "处方用法",a.cfztmc "处方嘱托"     
  , a.pcdm,a.yzxh,a.yfdl,b.py--yxp 2007-10-21 增加药品拼音的传出    
  , h.cfwz--yxp 2008-1-22 发药明细清单中增加药品的存放位置字段的传出     
  from #tempypmx a,YK_YPCDMLK b (nolock),YY_YBFLK c (nolock), #temp_bm d (nolock),YY_ZGBMK e (nolock),czryk f (nolock)      
   ,ZY_YZPCK g (nolock), YF_YFZKC h (nolock)    
  where a.cd_idm = b.idm and a.ybdm=c.ybdm and a.cd_idm*=d.idm and a.ysdm*=e.id and a.fyczyh*=f.id    
   and a.pcdm*=g.id  and a.cd_idm=h.cd_idm and a.yfdm=h.ksdm    
  group by  g.zbz,b.ypdm,cwdm,cardrow,hzxm,blh,b.ggdw,a.ypmc,a.ypgg,a.yfmc,a.pc,a.zxsj,a.ypdw,a.lylx,a.lylx_sm
  ,a.djfl
  ,a.djmc,a.ypdj,    
   a.yeyz,a.ztnr,b.ggxs,  ypsl1,  a.fyrq, a.gmxx, a.ysdm, a.hznl, a.fzxh, a.qqlxsm,    
   a.memo, e.name, f.name, a.sex, a.cfts, a.lb, a.zqzcbz,b.cjmc, a.lrczyh,a.ksmc,e.name ,rtrim(a.ypmc) ,    
   c.ybsm , g.zxzqdw, g.zxzq, g.zxcs, a.zdname ,a.ypyfmc ,a.cfztmc , b.py, a.pcdm, a.yzxh, a.yfdl, a.ypjl, a.jldw    
   ,h.cfwz    
  order by a.lb, a.yfdl, convert(int,a.cwdm),a.yfmc,fzxh,a.yzxh, b.ypdm, a.pcdm  -- mly 2008-07-24 增加卡片号排序移到第一个     
  return    
 end    
      
 if @printfs =1 --是否按3.X模式打印发药明细0否1是 主要是排序方式不一样    
 begin    
  update  #tempypmx  set  lb=99  where   ypsl<0    --yxp update    
  update  #tempypmx  set  yfdl='0'  where  yfdl not in ('0','1','2','3')      
    
  --yxp 2007-10-21 按3.x习惯修改，按开关7043来决定，传出的给药时间分隔符为-    
  update #tempypmx  set zxsj=replace(substring(zxsj,1,(case when len(zxsj)>=1 then (len(zxsj)-1) else 0 end)),',','-')    
 end    
 else    
 begin    
  update  #tempypmx  set  lb=lylx    
  update  #tempypmx  set  yfdl=djfl    
 end    
    
 select d.bmmc ,rtrim(cwdm)+'['+rtrim(hzxm)+']'+rtrim(blh) "床号[患者姓名]", blh "住院号",    
     rtrim(a.ypmc)+ '['+rtrim(a.ypgg)+']' "药品名称[规格]" , rtrim(convert(varchar(12),a.ypjl))+rtrim(jldw) "剂量",     
     convert(numeric(12,2),ypsl1)  "每次数量",    
     a.yfmc "用法", a.pc "频次", a.zxsj "给药时间", rtrim(convert(varchar(12),a.ypsl))+rtrim(a.ypdw) "实发",    
     a.lylx, a.lylx_sm "领药类型", a.djfl, a.djmc "单据名称",a.ypdj "药品单价",a.ypje "药品金额",a.yeyz "是否婴儿医嘱",     
     a.ztnr "医嘱嘱托",a.qqrq "请求日期",ypsl,ypdw,b.ggdw,b.ggxs*ypsl1 as ypjl     
  ,b.ypdm,cwdm "床号",cardrow--传出床位号，Add By Lingzhi ,2003.07.22    
  ,substring(a.fyrq,1,4)+'.'+substring(a.fyrq,5,2)+'.'+substring(a.fyrq,7,2)+' '+substring(a.fyrq,9,8) "发药日期"--住院发药账单的发药日期 add by wuming 2004-02-01    
  , a.gmxx,a.yzzxrq "医嘱执行日期",a.ysdm 医生代码,a.hznl 患者年龄, a.fzxh, a.qqlxsm,    
    a.memo "是否代煎",e.name "开方医生",f.name "发药操作员",--add by zyp   2004.11.03 显示代煎    
  rtrim(a.ypmc)+ '['+     
      LTrim(RTrim(Case When b.ggxs>=1 And Floor(b.ggxs)*10=Floor(b.ggxs*10) Then  Str(b.ggxs,12,0)     
      When b.ggxs>=1 And Floor(b.ggxs*10)*10=Floor(b.ggxs*100) Then  Str(b.ggxs,12,1)      
      When b.ggxs<1 And Floor(b.ggxs*10)*10=Floor(b.ggxs*100) Then Str(b.ggxs,12,1)      
      When b.ggxs<1 And Floor(b.ggxs*100)*10=Floor(b.ggxs*1000) Then Str(b.ggxs,12,2)      
      When b.ggxs<1 And Floor(b.ggxs*1000)*10=Floor(b.ggxs*10000) Then Str(b.ggxs,12,3)     
      Else Str(b.ggxs,12,4) end ))+ LTrim(RTrim(b.ggdw))+ ']' "药品名称[剂量]",a.fyyf "发药药房"    
  ,a.sex "性别", a.cfts "处方帖数",a.lb,case when isnull(a.zqzcbz,0)=0 then "" else "转" end "转区转床标志"    
  ,b.cjmc "厂家名称",a.lrczyh,a.ksmc ksmc,e.name "医生姓名",rtrim(a.ypmc) "药品名称",    
  case charindex('*',a.ypgg) when 0 then a.ypgg else rtrim(left(a.ypgg,charindex('*',a.ypgg)-1)) end "药品规格",     
     rtrim(a.hzxm) "患者姓名",c.ybsm "医保说明" ,    
     case when (g.zxzqdw=0) then convert(varchar(5),g.zxzq)+'天'+convert(varchar(5),g.zxcs)+'次'    
     when (g.zxzqdw=-1) then '每周'+rtrim(ltrim(g.zbz))+',每天'+convert(varchar(5),g.zxcs)+'次'    
     when (g.zxzqdw=1) then '每次'+rtrim(ltrim(g.zxzq))+'小时'    
     when (g.zxzqdw=2) then '每次'+rtrim(ltrim(g.zxzq))+'秒' end "执行次数", a.zdname "诊断名称",a.ypyfmc "处方用法",a.cfztmc "处方嘱托"     
     ,b.py--yxp 2007-10-21 增加药品拼音的传出    
  , h.cfwz--yxp 2008-1-22 发药明细清单中增加药品的存放位置字段的传出    
  ,a.dzyzimage     
    from #tempypmx a,YK_YPCDMLK b (nolock),YY_YBFLK c (nolock), #temp_bm d (nolock),YY_ZGBMK e (nolock),czryk f (nolock)      
  ,ZY_YZPCK g (nolock), YF_YFZKC h (nolock)      
    where a.cd_idm = b.idm and a.ybdm=c.ybdm and a.cd_idm*=d.idm and a.ysdm*=e.id and a.fyczyh*=f.id    
  and a.pcdm*=g.id  and a.cd_idm=h.cd_idm and a.yfdm=h.ksdm    
 order by a.cardrow,a.lb, a.yfdl, a.cwdm,a.yfmc,fzxh,a.yzxh, b.ypdm, a.pcdm  -- mly 2008-07-24 增加卡片号排序移到第一个       
end    
    
if @hzlx=1    --汇总明细   药品名称  规格  剂型    数量 单位    
begin    
 --yxp 2007-3-22 declare @fyyfdm ut_ksdm    
 declare @ksmc varchar(50)    
     
     
 if @fyxh=0--发药账单序号　0：三步递交模式YF_ZYFYZD.xh　其它：单帐单查询模式YF_ZYFYD.xh    
  --yxp 2007-3-22 select @fyyfdm=''  --a.ksmc 仁济单独版本病区显示不正确,公共版本也控制一下     
  select @ksmc = d.name from BQ_HZLYD a(nolock) ,YF_ZYFYZD b(nolock) ,#fydy c(nolock),ZY_BQDMK d(nolock)     
  where a.xh=b.lyxh and c.fyxh=b.xh AND b.bqdm=d.id    
 else    
  --yxp 2007-3-22 select @fyyfdm=yfdm from YF_ZYFYD (nolock) where xh=@fyxh    
  select @ksmc = d.name from BQ_HZLYD a(nolock) ,YF_ZYFYZD b(nolock) ,YF_ZYFYDMX c(nolock),ZY_BQDMK d(nolock)     
  where a.xh=b.lyxh and c.fyxh=b.xh and c.zdxh = @fyxh AND b.bqdm=d.id    
     
 select g.yfdm, c.name jxmc, rtrim(a.ypmc)+(case isnull(a.memo,'') when '' then '' else '－－'+rtrim(a.memo) end) ypmc,    
     sum(convert(numeric(10,2),a.ypsl/a.dwxs)) ypsl,a.ypdw, a.ypgg, b.cjmc,    
     convert(numeric(12,2),sum(a.ypsl*a.ylsj/a.ykxs)) je,f.lylx, f.lylx_sm, f.djfl, f.djmc,    
     b.ypdm,convert(numeric(12,4),avg(a.ylsj*a.dwxs/a.ykxs)) ypdj,b.idm cd_idm,h.ypmc ggmc, b.py    
 into #yphz    
 from YF_ZYFYMX a (nolock), YK_YPCDMLK b (nolock), YK_YPJXK c (nolock),#fydy f(nolock),    
  YF_ZYFYD g(nolock), YK_YPGGMLK h(nolock)     
 where a.fyxh=f.fyxh and b.idm=a.cd_idm and c.id=*b.jxdm and a.zdxh=g.xh and b.gg_idm=h.idm     
  and (a.syxh = @syxh or @syxh = 0 )    
  and (@zby = -1 or rtrim((isnull(a.memo,''))) <> '自备药')    
 group by g.yfdm, c.name, f.lylx, f.lylx_sm, f.djfl, f.djmc, a.ypmc, a.ypgg, a.ypdw, b.cjmc    
  ,b.ypdm, a.memo,b.idm,h.ypmc, b.py    
     
        if @bmbz=-1--是否显示药品别名标志　0否-1是    
 begin    
  update b set ypmc=b.ypmc+'('+c.bmmc+')'    
  from #yphz b,#temp_bm c where b.cd_idm=c.idm    
 end     
    
 --根据参数改变排序规则，一下2句SQL只有排序不同    
 if @printpxfs = 1    
 begin 

 
       select a.cd_idm, a.ypdm, c.bmmc, a.jxmc "剂型",     
  a.ypmc  "药品名称",         
  sum(a.ypsl) "数量", a.ypdw "单位", sum(a.ypsl)  ypsl, a.ypdw, a.ypgg "规格"    
  , a.cjmc "厂家", sum(a.je) "金额", a.lylx, a.lylx_sm "领药类型"    
  --, a.djfl
 -- , a.djmc "单据名称"
 , a.ypdm, a.ypdj "单价", a.cd_idm     
  , b.cfwz, a.yfdm, @ksmc as ksmc,a.ggmc "通用名", a.py    
 from #yphz a, YF_YFZKC b(nolock), #temp_bm c     
 where a.yfdm=b.ksdm and a.cd_idm=b.cd_idm and a.cd_idm*=c.idm    
  and a.ypsl<>0 --yxp 2008-3-20 ‘二级药柜’的汇总药品记录显示时，不显示汇总数为0的记录    

  group by a.cd_idm, a.ypdm, c.bmmc, a.jxmc ,     
  a.ypmc ,   a.ypdw , a.ypdw, a.ypgg     
  , a.cjmc ,  a.lylx, a.lylx_sm  , 
 a.ypdm, a.ypdj , a.cd_idm     
  , b.cfwz, a.yfdm ,a.ggmc , a.py    
 order by a.lylx,b.cfwz    
 end

 else    
        select a.cd_idm, a.ypdm, c.bmmc, a.jxmc "剂型",     
  a.ypmc "药品名称",         
sum(a.ypsl) "数量", a.ypdw "单位", sum(a.ypsl) ypsl, a.ypdw, a.ypgg "规格"    
  , a.cjmc "厂家", sum(a.je)"金额", a.lylx, a.lylx_sm "领药类型"    , 
  --a.djfl, 
  a.ypdm, a.ypdj "单价", a.cd_idm     
  , b.cfwz, a.yfdm, @ksmc as ksmc,a.ggmc "通用名", a.py    
 from #yphz a, YF_YFZKC b(nolock), #temp_bm c     
 where a.yfdm=b.ksdm and a.cd_idm=b.cd_idm and a.cd_idm*=c.idm    
  and a.ypsl<>0 --yxp 2008-3-20 ‘二级药柜’的汇总药品记录显示时，不显示汇总数为0的记录    
  group by a.cd_idm, a.ypdm, c.bmmc, a.jxmc ,     
  a.ypmc ,   a.ypdw , a.ypdw, a.ypgg     
  , a.cjmc ,  a.lylx, a.lylx_sm  , 
 a.ypdm, a.ypdj , a.cd_idm     
  , b.cfwz, a.yfdm ,a.ggmc , a.py    


 order by a.lylx,b.cfwz    
    
end    
return    
    
    
    




