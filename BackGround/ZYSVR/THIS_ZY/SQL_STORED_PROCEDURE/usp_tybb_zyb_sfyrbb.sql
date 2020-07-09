ALTER procedure usp_tybb_zyb_sfyrbb
  @czyh ut_czyh,                                         
  @xh  ut_xh9                              
as                      
declare   @lb ut_bz,@jzbz ut_xh9 ,@ksdm ut_ksdm                      
select @lb=1,@jzbz=1,@ksdm=''                      
                             
/**********                         
--by 向国庆  2018-08-11 根据住院收费原交款日报表明细 制作该报表  
usp_tybb_zyb_sfyrbb '8A0077','11755'

-- add by yangdi 2020.7.9 日期取的是结账日期，需要改为收费日期
                            
**********/                                
set nocount on                                
                                
declare                                
 @now  ut_rq16,  --当前日期                                
 @now1 varchar(8),                                
 @czym   ut_name,   --操作员名                                
 @ksxh   ut_xh12,   --开始序号                                
 @jsxh   ut_xh12,   --结束序号                                
 @yjkxh ut_xh12,  --押金库序号                                
 @cksxh   varchar(12),   --开始序号                                
 @cjsxh   varchar(12),   --结束序号                                
 @cyjkxh varchar(12),  --押金库序号                                
 @errmsg varchar(50),                      
 @sqlstr varchar(8000),                                
 @sqlstr4 varchar(8000),                                
 @tablename varchar(32),                                
 @dxmdm ut_kmdm,                                
 @dxmmc varchar(32),                                
 @brjk money,                                 
 @jsxh1 ut_xh12,                                
 @jsxh2 varchar(12),                                
 @xmdm ut_kmdm,                                
 @xmje numeric(12,2),                                
 @xmje1 varchar(16),                                
 @jzje numeric(12,2),                                
 @jzje1 varchar(16),                                
 @yhje numeric(12,2),                                
 @yhje1 varchar(16),                                
 @ksrq ut_rq16,                                
 @jsrq ut_rq16,                                
 @minfph int,                                
 @maxfph int,                                
 @cminfph char(20),                                
 @cmaxfph char(20),                                
 @fph int,                                
 @strdelfph varchar(8000),                                
 @minsjh varchar(12) ,                                
 @maxsjh varchar(12) ,                                
 @hcsjh varchar(4000),                                
 @sjh varchar(12)                                 
 ,@cdyjjbz ut_bz  --冲抵预交金标志  0-单独显示冲抵预交金，1-不单独显示冲抵预交金 add by sunyu 2004-12-13 滨州需求                              
                                
                                
select @now1=convert(char(8),getdate(),8)                                
select @now1=substring(@now1,1,2)+substring(@now1,4,2)+substring(@now1,7,2)                                
                                
select  @now=convert(char(8),getdate(),112)+convert(char(8),getdate(),8)                                
select  @czym=name from czryk where id=@czyh                                
select  @yjkxh=0                                
                              
select @cdyjjbz=1                              
if (select config from YY_CONFIG where id='5180')='是'                              
 select @cdyjjbz=0                                
                                
set rowcount 1                                 
select @yjkxh=isnull(jsxh,0)                                
 from ZYB_SFJZK where czyh=@czyh order by xh desc                                
if @@error<>0                                
begin                                
  select "F","无操作员结帐信息，请确认！"                                
  set rowcount 0                                
  return                                
end               
set rowcount 0                                
                                
select @cyjkxh=convert(varchar(12),@yjkxh)   
                                
declare @cyzxm varchar(12)                  
                  
select @cyzxm=czym from  ZYB_SFJZK where xh=@xh and jlzt>0                        
if @jzbz=1                                
begin                                
  select @ksxh=ksxh,@jsxh=jsxh,@ksrq=ksrq,@jsrq=jzrq from ZYB_SFJZK                                
    where xh=@xh and jlzt>0                                
  if @@rowcount=0                                
  begin                                
    select "F","没有这条历史结帐记录!"                                
    return                                
  end                      
  select @cksxh=convert(varchar(12),@ksxh), @cjsxh=convert(varchar(12),@jsxh)                                
end                                
else                                
begin                                
   select @ksrq=isnull(min(lrrq),@now),@jsrq=@now                                
    from ZYB_BRYJK a with (nolock, index(PK_ZYB_BRYJK))                                
     where a.xh>@yjkxh and a.jlzt in (0,1) and a.czyh=@czyh                                
end                                
                      
select * into #YY_JZMBK from YY_JZMBK where xtbz in (2) AND id in(01,03)                      
update #YY_JZMBK set name='市级医保' where id='01'                      
update #YY_JZMBK set name='居民医保' where id='03'                      
                      
if @lb=1                      
 begin                                
  --创建临时表                                
  declare cs_zydxm cursor                          
  for select id, name from #YY_JZMBK (nolock) where xtbz in (2)  and id in ('01','03')                               
  for read only                                
  select  @tablename='##temp_tybb_zyb_sfyrbb'+@now1                                
  select  @sqlstr='create table '+@tablename+'(syxh ut_syxh not null,fph int null,    
  hzxm varchar(32) null,                                
        blh varchar(18) null,     
        ybsm varchar(32) null,    
        sfzh varchar(64) null,                                
        yyj numeric(12,2) default 0,    
        ssje numeric(12,2) default 0,    
        zpje numeric(12,2) default 0,                                
        fpjxh ut_xh12 null,    
        posje numeric(12,2) default 0,    
        ybsr numeric(12,2) default 0,    
        syjj numeric(12,2) default 0,    
        dyje numeric(12,2) default 0,    
        ztjsbz ut_bz,                      
        dfje numeric(12,2) default 0,                      
        tczf numeric(12,2) default 0,                      
        zhzf numeric(12,2) default 0,                      
        gwybz numeric(12,2) default 0,                      
        delp numeric(12,2) default 0,                      
        mzjz numeric(12,2) default 0,                      
  jtsgjz numeric(12,2) default 0,                      
        tfbz ut_bz,' ---wxp0317   zwb  2015-3-14 添加生育基金支付金额   --zwb2015.7.16添加垫付金额                      
  select @sqlstr4=''                               
  open cs_zydxm                                
  fetch cs_zydxm into @dxmdm, @dxmmc                                
  while @@fetch_status=0                                
  begin                                
    select @sqlstr=@sqlstr+'id'+@dxmdm+' numeric(12,2) default 0,'                                
    select @sqlstr4=@sqlstr4+',id'+@dxmdm+' "'+@dxmmc+'"'                                
    fetch cs_zydxm into @dxmdm, @dxmmc                                
  end                                
  close cs_zydxm                                
  deallocate cs_zydxm                        
                                
  drop table #YY_JZMBK --删除创建表使用的临时表               
          
  select @sqlstr=@sqlstr+'zfje numeric(12,2) null,yhje numeric(12,2) null,wxje numeric(12,2) null,jhje numeric(12,2) null' --增加起付金额字段, add by Wang Yi, 20030807                                
    + ', zje numeric(12,2) null,srje numeric(12,2) null,qkje numeric(12,2) default 0,jsxh ut_xh12 null,zzjs numeric(9,2) null,jsrq ut_rq16 null)'                              
  EXEC(@sqlstr)                                
  exec('create clustered index idx_jsxh on '+@tablename+'(jsxh)')                               
                                
  create table #zybjztemp                              
  (                      
 jsxh ut_xh12   not null, --结算序号                      
 ybdm ut_ybdm not null, --医保代码                      
 xjje ut_money not null, --现金金额                      
 jzje ut_money not null, --记帐金额                      
 yhje ut_money not null --优惠金额                      
  )                      
  --exec ('select * from '+@tablename)                      
 exec('insert into '+@tablename+'(syxh, fph, hzxm, blh, ybsm,sfzh, zje, zfje, qkje, srje, jsxh, wxje,jhje,posje,ztjsbz,tfbz,jsrq)   ---zwb 2015-5-8 添加中途结算标志                                
 select a.syxh, a.fph, a.hzxm, a.blh, b.ybsm,a.sfzh, a.zje, a.zfje, a.qfje, a.srje, a.xh, 0,0,0,a.jszt,a.jlzt,a.jsrq                        
 from ZY_BRJSK a (nolock), YY_YBFLK b (nolock)                             
 where exists(select 1 from ZYB_BRYJK c (nolock)                                
 where c.jlzt in (0,1) and c.xh between '+@cksxh+' and '+@cjsxh+'                                
 and c.czyh="'+@czyh+'" and c.czlb in (8,9) and a.xh=c.jsxh)                                
and a.ybjszt=2 and a.jlzt<>3 and b.ybdm=a.ybdm and a.jsrq between "'+@ksrq+'" and "'+@jsrq+'" and a.jsczyh="'+@czyh+'"')                      
    
 --   select @ksrq,@jsrq
 insert into #zybjztemp                                
 select a.xh,a.ybdm,a.zfje,isnull(a.zje-a.zfje-a.yhje+a.srje,0) jzje,                                
 isnull(a.yhje,0) yhje                         
 from ZY_BRJSK a (nolock)                                
 where exists(select 1 from ZYB_BRYJK c (nolock)                                
 where c.jlzt in (0,1) and c.xh between @ksxh and @jsxh and c.czyh=@czyh                                
 and c.czlb in (8,9) and a.xh=c.jsxh)                                
 and a.ybjszt=2 and a.jlzt<>3 and a.jsrq between @ksrq and @jsrq and a.jsczyh=@czyh         
       
                              
-----add by yangdi 2012.4.9 医保病人医保支付金额不包括医保舍入部分，此部分单独体现                              
                      
 Update a set a.jzje=a.jzje-isnull(b.je,0) from #zybjztemp a,ZY_BRJSJEK b (nolock),YY_YBFLK c (nolock)                              
 where a.jsxh*=b.jsxh and a.ybdm=c.ybdm and c.ybjkid>0                              
 and b.lx in ('99','NZ')             
                         
----begin add by 向国庆 2015.7.16 去除医保金额账户抵用部分                            
 Update a set a.jzje=a.jzje-isnull(b.je,0) from #zybjztemp a,ZY_BRJSJEK b (nolock),YY_YBFLK c (nolock)                              
 where a.jsxh*=b.jsxh and a.ybdm=c.ybdm and c.ybjkid>0                             
 -- and a.ybdm in ('12DR','161' )                            
 and b.lx in ('24','yb99')                       
                             
 Update a set a.jzje=a.jzje-isnull(b.je,0) from #zybjztemp a,ZY_BRJSJEK b (nolock),YY_YBFLK c (nolock)                              
 where a.jsxh*=b.jsxh and a.ybdm=c.ybdm and c.ybjkid>0                             
--and a.ybdm in ('12DR','161' )                            
 and b.lx in ('08','yb08')                         
                           
---end                         
/*Begin by 2018-08-11 向国庆 */                      
--统筹支付               
       --exec('select * from '+@tablename  )        
exec ('update a set a.tczf=isnull(b.je,0) from '+@tablename +' a,ZY_BRJSJEK b (nolock),    
ZY_BRJSK c (nolock),YY_YBFLK d (nolock) where 
a.jsxh*=b.jsxh and b.lx in ("01","yb01")                       
and a.jsxh=c.xh                       
and c.ybdm=d.ybdm                       
        
')               
  /*  exec ('update a set a.tczf=isnull(b.je,0) from '+@tablename +' a,ZY_BRJSJEK b (nolock),                      
ZY_BRJSK c (nolock),YY_YBFLK d (nolock) where                       
a.jsxh*=b.jsxh and b.lx in ("01","GN31","GN36")                       
and a.jsxh=c.xh                       
and c.ybdm=d.ybdm                       
        
')        */           
--账户支付                      
exec ('update a set a.zhzf=isnull(b.je,0) from '+@tablename +' a,ZY_BRJSJEK b (nolock),                      
ZY_BRJSK c (nolock),YY_YBFLK d (nolock) where         
a.jsxh*=b.jsxh and b.lx in ("02","yb02")                       
and a.jsxh=c.xh        
and c.ybdm=d.ybdm        
')            
           
exec ('update a set a.zhzf=a.zhzf+isnull(b.je,0) from '+@tablename +' a,ZY_BRJSJEK b (nolock),                      
ZY_BRJSK c (nolock),YY_YBFLK d (nolock) where                       
a.jsxh*=b.jsxh and b.lx in ("32","yb31")                       
and a.jsxh=c.xh                       
and c.ybdm=d.ybdm                       
')          
         
exec ('update a set a.zhzf=a.zhzf+isnull(b.je,0) from '+@tablename +' a,ZY_BRJSJEK b (nolock),                      
ZY_BRJSK c (nolock),YY_YBFLK d (nolock) where                       
a.jsxh*=b.jsxh and b.lx in ("33","yb32")                       
and a.jsxh=c.xh                       
and c.ybdm=d.ybdm                       
')                  
--公务员补助                      
exec ('update a set a.gwybz=isnull(b.je,0) from '+@tablename +' a,ZY_BRJSJEK b (nolock),                      
ZY_BRJSK c (nolock),YY_YBFLK d (nolock) where                       
a.jsxh*=b.jsxh and b.lx in ("03","yb03")                       
and a.jsxh=c.xh                       
and c.ybdm=d.ybdm                       
')                      
--大额理赔金额                      
exec ('update a set a.delp=isnull(b.je,0) from '+@tablename +' a,ZY_BRJSJEK b (nolock),                      
ZY_BRJSK c (nolock),YY_YBFLK d (nolock) where                       
a.jsxh*=b.jsxh and b.lx in ("05","yb05")                       
and a.jsxh=c.xh                 and c.ybdm=d.ybdm                       
')                      
--民政救助金额                      
exec ('update a set a.mzjz=isnull(b.je,0) from '+@tablename +' a,ZY_BRJSJEK b (nolock),                      
ZY_BRJSK c (nolock),YY_YBFLK d (nolock) where                       
a.jsxh*=b.jsxh and b.lx in ("09","yb09")                       
and a.jsxh=c.xh                       
and c.ybdm=d.ybdm                       
')                      
exec ('update a set a.jtsgjz=isnull(b.je,0) from '+@tablename +' a,ZY_BRJSJEK b (nolock),                      
ZY_BRJSK c (nolock),YY_YBFLK d (nolock) where                       
a.jsxh*=b.jsxh and b.lx in ("gs02")                       
and a.jsxh=c.xh                       
and c.ybdm=d.ybdm                      
and c.ybdm="147"                       
')                      
/*End by 2018-08-11*/                      
                       
 exec ('update a set a.ybsr=isnull(b.je,0) from '+@tablename +' a,ZY_BRJSJEK b (nolock),ZY_BRJSK c (nolock),YY_YBFLK d (nolock) where a.jsxh*=b.jsxh and b.lx in ("99","NZ") and a.jsxh=c.xh and c.ybdm=d.ybdm and d.ybjkid>0')                      
-----zwb 2015-3-14 计算生育报销金额和抵用金额  


--exec('select  *  from  '+@tablename +' a,ZY_BRJSJEK b (nolock),ZY_BRJSK c (nolock),YY_YBFLK d (nolock) 
-- where a.jsxh=b.jsxh and b.lx in("26")  and a.jsxh=c.xh and c.ybdm=d.ybdm and d.ybjkid>0')
--    return
if exists (select  1 where  @jsrq>'2019112223:59:59' )
    
	begin   
    
 	  exec ('update a set a.syjj=isnull(b.je,0) from '+@tablename +' a,ZY_BRJSJEK b (nolock),ZY_BRJSK c (nolock),YY_YBFLK d (nolock) 
 where a.jsxh=b.jsxh and b.lx in("yb24")  and a.jsxh=c.xh and c.ybdm=d.ybdm and d.ybjkid>0 ')
end
else
  exec ('update a set a.syjj=isnull(b.je,0) from '+@tablename +' a,ZY_BRJSJEK b (nolock),ZY_BRJSK c (nolock),YY_YBFLK d (nolock) 
 where a.jsxh=b.jsxh and b.lx in("25")  and a.jsxh=c.xh and c.ybdm=d.ybdm and d.ybjkid>0 ')

 
  
  exec ('update a set a.dyje=isnull(b.je,0) from '+@tablename +' a,ZY_BRJSJEK b (nolock),ZY_BRJSK c (nolock),YY_YBFLK d (nolock) where a.jsxh=b.jsxh and b.lx in ("24","yb99") and a.jsxh=c.xh and c.ybdm=d.ybdm and d.ybjkid>0 ')                            


  
 
 --zwb 2015-7-16添加垫付金额                              
 exec ('update a set a.dfje=isnull(b.je,0) from '+@tablename +' a,ZY_BRJSJEK b (nolock),ZY_BRJSK c (nolock),YY_YBFLK d (nolock) where a.jsxh=b.jsxh and b.lx in ("08","yb08") and a.jsxh=c.xh and c.ybdm=d.ybdm and d.ybjkid>0 ')                              



 
    --add by yangdi 2017.9.26 生育医保开通职工账户支付功能，按照普通医保处理，结账报表中已经体现生育基金金额，将生育账户支付在“普通医保"栏显示。                         
    update #zybjztemp set jzje=isnull(c.je,0) from #zybjztemp a, ZY_BRJSK b (NOLOCK),ZY_BRJSJEK c (nolock)                        
    where a.jsxh=b.xh AND b.xh=c.jsxh and b.ybxzbz=3                        
    AND c.lx in ('32','yb31')                      
  declare cs_zysfjz insensitive cursor for                                
  select b.id,a.jsxh,xjje,jzje,yhje                                
    from #zybjztemp a, YY_JZMBK b                             
     where charindex(rtrim(a.ybdm),b.ybdmjh)>0 and b.xtbz=2                   
                                
  open cs_zysfjz                                
  fetch cs_zysfjz into @xmdm,@jsxh1,@xmje,@jzje,@yhje                                
  while @@fetch_status=0                                
  begin                                
    select  @xmje1=convert(varchar(16),@xmje),                                 
       @jzje1=convert(varchar(16),@jzje),                                 
       @yhje1=convert(varchar(16),@yhje),                                 
       @jsxh2=convert(varchar(12),@jsxh1)                                
    exec('update '+@tablename+' set id'+@xmdm+'='+@jzje1+',yhje='+@yhje1+'                                 
      where jsxh='+@jsxh2)                                
    fetch cs_zysfjz into @xmdm,@jsxh1,@xmje,@jzje,@yhje                                
  end                                
  deallocate cs_zysfjz                      
 exec('update '+@tablename+' set yhje=isnull(a.yhje,0)+isnull(b.yhje,0) from '+@tablename                              
   +' a(nolock),#zybjztemp b(nolock) where a.jsxh=b.jsxh                              and not exists(select 1 from YY_JZMBK c(nolock) where charindex(rtrim(b.ybdm),c.ybdmjh)>0 and c.xtbz=2) ')                         
                    
                                
if (select config from YY_CONFIG (nolock) where id='5024')='0'                                
  begin                           
  --add by yangdi 2016.8.2 考虑正常情况，即正常结算且未退费或退费红冲的记录。                            
  exec('update '+@tablename+' set yyj=b.je                                 
  from '+@tablename+' a,(select jsxh,syxh,isnull(sum(jje-dje),0) je                                 
  from ZYB_BRYJK b (nolock) where czlb in (0,1,3,4,5,6) group by jsxh,syxh) b                                 
  where a.syxh=b.syxh and a.jsxh=b.jsxh')                                
  ---zwb 2014-12-26 中途结算预交金金额显示为冲抵金额                            
  --add by yangdi 2016.8.2 考虑特殊情况，即中途结算记录。                          
  exec('update '+@tablename+' set yyj=b.je                                 
  from '+@tablename+' a,(select jsxh,syxh,sum(case when czlb in(8) then jje-dje when czlb in(2) then -jje else 0 end )                               
  from ZYB_BRYJK  group by jsxh,syxh) b  where a.syxh=b.syxh and a.jsxh=b.jsxh and a.ztjsbz=1')                            
  --add by yangdi 2016.8.2 考虑特殊情况，即退费记录。        
  exec('update '+@tablename+' set yyj=b.je                                 
  from '+@tablename+' a,(select jsxh,syxh,isnull(sum(jje-dje),0) je                                 
  from ZYB_BRYJK b (nolock) where czlb in (5) group by jsxh,syxh) b where a.syxh=b.syxh and a.jsxh=b.jsxh and a.tfbz=1')                             
                      
  exec('update '+@tablename+' set ssje=b.je                                 
  from '+@tablename+' a,(select jsxh,syxh,isnull(sum(jje-dje),0) je                                 
  from ZYB_BRYJK b (nolock),YY_ZFFSK c (nolock) where czlb in (2) and b.zffs = c.id and b.zffs=''1'' group by jsxh,syxh) b                                 
  where a.syxh=b.syxh and a.jsxh=b.jsxh')                      
  exec('update '+@tablename+' set zpje=b.je                      
  from '+@tablename+' a,(select jsxh,syxh,isnull(sum(jje-dje),0) je                                 
  from ZYB_BRYJK b (nolock),YY_ZFFSK c (nolock) where czlb in (2) and b.zffs = c.id and b.zffs=''2'' group by jsxh,syxh) b                                 
  where a.syxh=b.syxh and a.jsxh=b.jsxh')                         
  --update by wingning-Dsong-chongqing add  begin         
	exec('update '+@tablename+' set zzjs=b.je                       
      from '+@tablename+' a,(select jsxh,syxh,isnull(sum(jje-dje),0) je                       
        from ZYB_BRYJK b (nolock),YY_ZFFSK c (nolock) where czlb in (2) and b.zffs = c.id and b.zffs =''3'' group by jsxh,syxh) b                       
        where a.syxh=b.syxh and a.jsxh=b.jsxh')              
--update by wingning-Dsong-chongqing add  end 
  --add by yangdi 2018.1.22 结账单增加微信支付方式，替换原有欠费显示。                                  
  exec('update '+@tablename+' set wxje=b.je                                 
  from '+@tablename+' a,(select jsxh,syxh,isnull(sum(jje-dje),0) je                                 
  from ZYB_BRYJK b (nolock),YY_ZFFSK c (nolock) where czlb in (2) and b.zffs = c.id and b.zffs=''12'' group by jsxh,syxh) b                           
  where a.syxh=b.syxh and a.jsxh=b.jsxh')        
  --add by 向国庆 2018.12.12 结账单增加聚会支付方式，替换原有欠费显示。     
  exec('update '+@tablename+' set jhje=b.je                                 
  from '+@tablename+' a,(select jsxh,syxh,isnull(sum(jje-dje),0) je                                 
  from ZYB_BRYJK b (nolock),YY_ZFFSK c (nolock) where czlb in (2) and b.zffs = c.id and b.zffs=''15'' group by jsxh,syxh) b                                 
  where a.syxh=b.syxh and a.jsxh=b.jsxh')                      
                       
  exec('update '+@tablename+' set posje=b.je                              
  from '+@tablename+' a,(select jsxh,syxh,isnull(sum(jje-dje),0)je                               
  from ZYB_BRYJK b (nolock),YY_ZFFSK c (nolock) where czlb in (2) and b.zffs=c.id and substring(c.memo,1,1)=1 and substring(c.memo,2,1)=8 group by jsxh,syxh) b                               
  where a.syxh=b.syxh and a.jsxh=b.jsxh')                              
 end                                
  else                      
 begin                              
  --add by yangdi 2016.8.2 考虑正常情况，即正常结算且未退费或退费红冲的记录。                                
  exec('update '+@tablename+' set yyj=b.je                                 
  from '+@tablename+' a,(select jsxh,syxh,isnull(sum(jje-dje),0) je                                 
  from ZYB_BRYJK b (nolock) where czlb in (0,1,3,4,5,6) group by jsxh,syxh) b                               
  where a.syxh=b.syxh and a.jsxh=b.jsxh and (a.ztjsbz=2 and a.tfbz in (0,2)) ') ----by xdw 20140306 修改中途结账病人预交金错误，取消类别为3的                           
  ----add by yangdi 2015.7.31 中途结算病人需要增加类别为3的，否则中途结算病人 出院结算时预交金与实际不符。                             
  ---zwb 2014-12-26 预交金金额显示为冲抵金额                           
  --add by yangdi 2016.8.2 考虑特殊情况，即中途结算记录。                           
  exec('update '+@tablename+' set yyj=b.je                                 
  from '+@tablename+' a,(select jsxh,syxh,sum(case when czlb in(8) then jje-dje when czlb in(2) then -jje else 0 end ) je from ZYB_BRYJK                               
  group by jsxh,syxh) b                                
  where a.syxh=b.syxh and a.jsxh=b.jsxh and a.ztjsbz=1')                            
  --取消结算                        
  exec('update '+@tablename+' set yyj=b.je                                 
  from '+@tablename+' a,(select jsxh,syxh,isnull(sum(jje-dje),0) je                                 
  from ZYB_BRYJK b (nolock) where czlb in (5) group by jsxh,syxh) b where a.syxh=b.syxh and a.jsxh=b.jsxh and a.tfbz=1')  
                      
  exec('update '+@tablename+' set ssje=b.je                                 
  from '+@tablename+' a,(select jsxh,syxh,isnull(sum(jje-dje),0) je                                 
  from ZYB_BRYJK b (nolock),YY_ZFFSK c (nolock) where czlb in (2,6) and b.zffs = c.id  and b.zffs=''1'' group by jsxh,syxh) b                                 
  where a.syxh=b.syxh and a.jsxh=b.jsxh')                                    
  exec('update '+@tablename+' set zpje=b.je                                 
  from '+@tablename+' a,(select jsxh,syxh,isnull(sum(jje-dje),0) je               
  from ZYB_BRYJK b (nolock),YY_ZFFSK c (nolock) where czlb in (2,6) and b.zffs = c.id and b.zffs=''2'' group by jsxh,syxh) b                                 
  where a.syxh=b.syxh and a.jsxh=b.jsxh')    
  
--update by wingning-Dsong-chongqing add begin                     
    exec('update '+@tablename+' set zzjs=b.je                       
      from '+@tablename+' a,(select jsxh,syxh,isnull(sum(jje-dje),0) je                       
        from ZYB_BRYJK b (nolock),YY_ZFFSK c (nolock) where czlb in (2,6) and b.zffs = c.id and b.zffs =''3'' group by jsxh,syxh) b                       
     where a.syxh=b.syxh and a.jsxh=b.jsxh')               
--update by wingning-Dsong-chongqing add end                     
                      
  --add by yangdi 2018.1.22 结账单增加微信支付方式，替换原有欠费显示。                                  
  exec('update '+@tablename+' set wxje=b.je                                 
  from '+@tablename+' a,(select jsxh,syxh,isnull(sum(jje-dje),0) je                                 
  from ZYB_BRYJK b (nolock),YY_ZFFSK c (nolock) where czlb in (2,6) and b.zffs = c.id and b.zffs=''12'' group by jsxh,syxh) b                                 
  where a.syxh=b.syxh and a.jsxh=b.jsxh')         
       
   --add by 向国庆 2018.12.12 结账单增加聚会支付方式，替换原有欠费显示。     
  exec('update '+@tablename+' set jhje=b.je                                 
  from '+@tablename+' a,(select jsxh,syxh,isnull(sum(jje-dje),0) je                                 
  from ZYB_BRYJK b (nolock),YY_ZFFSK c (nolock) where czlb in (2) and b.zffs = c.id and b.zffs=''15'' group by jsxh,syxh) b                                 
  where a.syxh=b.syxh and a.jsxh=b.jsxh')       
  --add by 向国庆 2019.01.11 处理聚合支付取消结算收退  
    
    exec('update '+@tablename+' set jhje=b.je                                 
  from '+@tablename+' a,(select jsxh,syxh,isnull(sum(jje-dje),0) je                                 
  from ZYB_BRYJK b (nolock),YY_ZFFSK c (nolock) where czlb in (6) and b.zffs = c.id and b.zffs=''15'' group by jsxh,syxh) b                                 
  where a.syxh=b.syxh and a.jsxh=b.jsxh')   
    
                      
  exec('update '+@tablename+' set posje=b.je                                 
  from '+@tablename+' a,(select jsxh,syxh,isnull(sum(jje-dje),0) je                                 
  from ZYB_BRYJK b (nolock),YY_ZFFSK c (nolock) where czlb in (2,6) and b.zffs = c.id  and substring(c.memo,1,1)=1 and substring(c.memo,2,1)=8 group by jsxh,syxh) b                                 
  where a.syxh=b.syxh and a.jsxh=b.jsxh')               
 end          
 


             
 /*排除统筹支付金额中包含民政救助金额20180813 by 向国庆*/                   
exec('select "'+@cyzxm+ '" as "收费员姓名",convert(varchar(8),a.jsrq) as "收费日期",        
     a.fph "发票号",                
     a.blh "住院号",                      
 a.hzxm "姓名",                       
 a.ybsm "费别",                       
 a.yyj "预交金",                  
 a.ssje "实收现金",                    
 a.dfje "垫付",                   
 a.posje "POS",                   
 a.wxje "微信",     
 a.jhje "聚合支付",  
  isnull(zzjs,0) "转账金额"  ,                 
 a.zpje "支票",                   
 isnull(zhzf,0) "账户支付",                  
 case  when a.ybsm=''重庆市医保''then isnull(tczf,0) else  isnull(tczf-mzjz,0) end   "统筹支付",                    
 isnull(mzjz,0) "民政救助",                  
 isnull(gwybz,0) "公务员补助",                  
 isnull(delp,0) "大额理赔",                  
 a.syjj "生育医保",                     
 a.dyje "抵用",                   
 isnull(jtsgjz,0) "交通事故医保报销金额" ,                
    "" as "AA",                  
 a.zje "总金额"                            
 from '+@tablename+' a order by a.fph, a.jsxh, a.blh')                     
   /*                
    print('select syxh,jsxh,a.blh "住院号",                    
  a.fph "发票号",                    
  a.hzxm "姓名",                     
  a.ybsm "费别",                     
  a.zje "总金额",                 
  a.zfje "个人支付",                    
  a.yyj "预交金",                    
  a.ssje "实收现金",                    
  a.posje "POS",                    
  a.zpje "支票",                    
  a.wxje "微信",                    
  a.srje "舍入金额",                     
  a.qkje "起付金额"                   
  '+@sqlstr4+',                    
  a.syjj "生育医保",                    
  a.dyje "抵用",                    
  isnull(a.ybsr,0) "医保舍入" ,                    
  a.dfje "垫付",                    
  isnull(a.yhje,0) "优惠金额",                   
  isnull(tczf,0) "统筹支付",                    
  isnull(zhzf,0) "账户支付",                    
  isnull(gwybz,0) "公务员补助",                    
  isnull(delp,0) "大额理赔",                    
  isnull(mzjz,0) "民政救助",                    
  isnull(jtsgjz,0) "交通事故医保报销金额"                     
                          
  from '+@tablename+' a order by a.fph, a.jsxh, a.blh')                  
  */                              
  exec('drop table '+@tablename)                               
  return                                
end 









