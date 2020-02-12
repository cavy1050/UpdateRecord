Text
CREATE proc usp_bb_xxgzbdfy_fyqktj
@ksrq ut_rq8,
@jsrq ut_rq8,
@yydm varchar(16)='',
@bz ut_bz=1,
@czyh varchar(16)=''
as
/******
说明：新型冠状病毒感染的肺炎费用情况统计时间
作者：winning-dingsong-chongqing
时间：20200205
@tjrq 统计日期
@bz 0：全部，1：自定义时间
示例：usp_bb_xxgzbdfy_fyqktj '20200204','20200204','01',0,''
******/
if(@yydm not in (select id from YY_JBCONFIG))
begin
select 'F','入参错误，没有找到id为'+@yydm+'的医院信息！'
return
end
if(@bz not in (0,1))
begin
select 'F','入参错误，标志只能为0或1！'
return
end
declare @ZYSVR varchar(32)='ZYSVR.'
declare @MZSVR varchar(32)='MZSVR.'

create table #jsxx
(
syxh varchar(16),--门诊ghxh，住院syxh
cardno varchar(32),
ybdm varchar(16),
qzbz int,--0：疑似，1：确诊
xtbz int,--1：门诊，2：住院
bqjsrc int,
bqylzfy money,
bqjbybzf money,
bqdbbxzf money,
bqyljzzf money,
bqgrfyfy money
)

declare @sql varchar(1024)=''
--门诊
select @sql=('
insert into #jsxx
select a.GHXH,(case when isnull(a.SHBZH,"")="" then b.cardno else a.SHBZH end),a.YBDM,(case when a.ZDDM="B99.901" then 0 when a.ZDDM="B99.900" then 1 end),
1,1,b.zje,
sum((case when c.lx in ("01","yb01") then c.je else 0 end)),0,
sum((case when c.lx in ("09","yb09","03","yb03","30","yb30") then c.je else 0 end)),
sum((case when c.lx in ("02","yb02","04","yb04") then c.je else 0 end))
from '+@MZSVR+'CISDB.dbo.OUTP_JZJLK a
inner join '+@MZSVR+'THIS_MZ.dbo.SF_BRJSK b on a.PATID=b.patid and a.GHXH=b.ghxh
inner join '+@MZSVR+'THIS_MZ.dbo.SF_JEMXK c on b.sjh=c.jssjh
where a.ZDDM in ("B99.901","B99.900") and b.ybjszt=2 
and a.KSDM in (select id from '+@MZSVR+'THIS_MZ.dbo.YY_KSBMK where yydm in ('+@yydm+'))'
)
if(@bz=1)
begin 
select @sql=@sql+' and left(a.GHRQ,8) between '+@ksrq+' and '+@jsrq
end
select @sql=@sql+' group by a.GHXH,a.SHBZH,b.cardno,a.YBDM,a.ZDDM,b.zje order by a.GHXH'
exec(@sql)

--住院
select @sql=('
insert into #jsxx
select a.syxh,b.sbkh,a.ybdm,(case when isnull(b.cyzd,b.ryzd)="B99.901" then 0 when isnull(b.cyzd,b.ryzd)="B99.900" then 1 end),
2,1,c.zje,
sum((case when d.lx in ("01","yb01") then d.je else 0 end)),
sum((case when d.lx in ("GN36","NK") then d.je else 0 end)),
sum((case when d.lx in ("09","yb09","03","yb03","30","yb30") then d.je else 0 end)),
sum((case when d.lx in ("yb02","yb04") then d.je else 0 end))
from '+@ZYSVR+'THIS_ZY.dbo.ZY_BRSYK a
inner join '+@ZYSVR+'THIS_ZY.dbo.YY_CQYB_ZYJZJLK b on a.syxh=b.syxh
inner join '+@ZYSVR+'THIS_ZY.dbo.ZY_BRJSK c on b.syxh=c.syxh
inner join '+@ZYSVR+'THIS_ZY.dbo.ZY_BRJSJEK d on c.xh=d.jsxh
where isnull(b.cyzd,b.ryzd) in ("B99.901","B99.900") and a.brzt=3 and c.ybjszt=2 
and a.bqdm in (select id from '+@ZYSVR+'THIS_ZY.dbo.ZY_BQDMK where yydm in ('+@yydm+'))' 
)
if(@bz=1)
begin 
select @sql=@sql+'and left(c.jsrq,8) between '+@ksrq+' and '+@jsrq
end
select @sql=@sql+' group by a.syxh,b.sbkh,a.ybdm,c.zje,b.cyzd,b.ryzd order by a.syxh'
exec(@sql)

select syxh,cardno,ybdm,qzbz,xtbz,bqjsrc,
sum(bqylzfy)/10000 bqylzfy,sum(bqjbybzf)/10000 bqjbybzf,
sum(bqdbbxzf)/10000 bqdbbxzf,sum(bqyljzzf)/10000 bqyljzzf,
sum(bqgrfyfy)/10000 bqgrfyfy
into #jsxx1
from #jsxx group by syxh,cardno,ybdm,qzbz,xtbz,bqjsrc

--本市--051居民--056居民
--疑似
select 'bdjmys' ybfl,sum(bqjsrc) bqjsrc,sum(bqylzfy) bqylzfy,sum(bqjbybzf) bqjbybzf,
sum(bqdbbxzf) bqdbbxzf,sum(bqyljzzf) bqyljzzf,
sum(bqgrfyfy) bqgrfyfy
from #jsxx1 where left(cardno,1)<>'#' and ybdm in ('051','161') and qzbz=0
select 'bdzgys' ybfl,sum(bqjsrc) bqjsrc,sum(bqylzfy) bqylzfy,sum(bqjbybzf) bqjbybzf,
sum(bqdbbxzf) bqdbbxzf,sum(bqyljzzf) bqyljzzf,
sum(bqgrfyfy) bqgrfyfy
from #jsxx1 where left(cardno,1)<>'#' and ybdm in ('056','12DR') and qzbz=0
--确诊
select 'bdjmqz' ybfl,sum(bqjsrc) bqjsrc,sum(bqylzfy) bqylzfy,sum(bqjbybzf) bqjbybzf,
sum(bqdbbxzf) bqdbbxzf,sum(bqyljzzf) bqyljzzf,
sum(bqgrfyfy) bqgrfyfy
from #jsxx1 where left(cardno,1)<>'#' and ybdm in ('051','161') and qzbz=1
select 'bdzgqz' ybfl,sum(bqjsrc) bqjsrc,sum(bqylzfy) bqylzfy,sum(bqjbybzf) bqjbybzf,
sum(bqdbbxzf) bqdbbxzf,sum(bqyljzzf) bqyljzzf,
sum(bqgrfyfy) bqgrfyfy
from #jsxx1 where left(cardno,1)<>'#' and ybdm in ('056','12DR') and qzbz=1

--异地--051居民--056居民
--疑似
select 'ydsnys' ybfl,sum(bqjsrc) bqjsrc,sum(bqylzfy) bqylzfy,sum(bqjbybzf) bqjbybzf,
sum(bqdbbxzf) bqdbbxzf,sum(bqyljzzf) bqyljzzf,
sum(bqgrfyfy) bqgrfyfy
from #jsxx1 where 1=2
select 'ydksys' ybfl,sum(bqjsrc) bqjsrc,sum(bqylzfy) bqylzfy,sum(bqjbybzf) bqjbybzf,
sum(bqdbbxzf) bqdbbxzf,sum(bqyljzzf) bqyljzzf,
sum(bqgrfyfy) bqgrfyfy
from #jsxx1 where left(cardno,1)='#' and qzbz=0
--确诊
select 'ydsnqz' ybfl,sum(bqjsrc) bqjsrc,sum(bqylzfy) bqylzfy,sum(bqjbybzf) bqjbybzf,
sum(bqdbbxzf) bqdbbxzf,sum(bqyljzzf) bqyljzzf,
sum(bqgrfyfy) bqgrfyfy
from #jsxx1 where 1=2
select 'ydksqz' ybfl,sum(bqjsrc) bqjsrc,sum(bqylzfy) bqylzfy,sum(bqjbybzf) bqjbybzf,
sum(bqdbbxzf) bqdbbxzf,sum(bqyljzzf) bqyljzzf,
sum(bqgrfyfy) bqgrfyfy
from #jsxx1 where left(cardno,1)='#' and qzbz=1


select 'HJ' ybfl,sum(bqjsrc) bqjsrc,sum(bqylzfy) bqylzfy,sum(bqjbybzf) bqjbybzf,
sum(bqdbbxzf) bqdbbxzf,sum(bqyljzzf) bqyljzzf,
sum(bqgrfyfy) bqgrfyfy
from #jsxx1

