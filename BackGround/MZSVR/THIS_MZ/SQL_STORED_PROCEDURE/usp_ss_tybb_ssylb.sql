ALTER proc usp_ss_tybb_ssylb
@ksrq       ut_rq8, --开始日期  
@jsrq       ut_rq8,    --结束日期  
@ssksdm    ut_ksdm = '-1'  
as  
/**********  
[版本号]4.0.0.0.0  
[创建时间]2004.08.26  
[作者]黄克华  
[版权] Copyright ? 1998-2001上海金仕达-卫宁医疗信息技术有限公司  
[描述] 手术一览表  
[功能说明]  
住院转科统计  
[参数说明]  
@ksrq       开始日期  
@jsrq       结束日期  
@ksdm  ut_ksdm = '0' 手术室代码  
[返回值]  
[结果集、排序]  
成功：结果集  
错误："F","错误信息"  
[调用的sp]  
usp_ss_tybb_ssylb '20191101','20191131','-1'  
update SS_SSDJK set memo='' where xh='4672'  
select ssdjdm,memo,* from SS_SSDJK where xh='4672'  
select  * from SS_SSDJDMK  
  
  exec usp_ss_tybb_ssylb '20200301','20200330','021101'
  
[调用实例]  
**********/  
set nocount on  
  
declare @ssmc ut_mc32  
if @ssksdm='-1'  
select @ssmc='所有手术室'  
else  
select @ssmc=name from SS_SSDMK where id=@ssksdm  
  
select identity(int,1,1) as id,a.xh,a.blh,a.hzxm,c.ybdm,b.name ksmc,c.sex,substring(convert(char(8),dateadd(year,1,getdate())-convert(datetime,c.birth),112),3,2) age,  
a.kssj,convert(varchar(3),datediff(n,convert(datetime,substring(a.kssj,1,8)+' '+substring(a.kssj,9,8),112),  
convert(datetime,substring(a.jssj,1,8)+' '+substring(a.jssj,9,8),112))/60)+':'+  
convert(char(2),datediff(n,convert(datetime,substring(a.kssj,1,8)+' '+substring(a.kssj,9,8),112),  
convert(datetime,substring(a.jssj,1,8)+' '+substring(a.jssj,9,8),112))-  
datediff(n,convert(datetime,substring(a.kssj,1,8)+' '+substring(a.kssj,9,8),112),  
convert(datetime,substring(a.jssj,1,8)+' '+substring(a.jssj,9,8),112))/60*60) ssss,  
convert(numeric(9,2),0) as sszje,
convert(numeric(9,2),0) as ssje,
CONVERT(numeric(9,2),0) as mzypje,  
convert(numeric(9,2),0) as mzzje,  
convert(numeric(9,2),0) as jylje,  
convert(numeric(9,2),0) as zfje,  
convert(varchar(64),'') sqzd,ssmc,convert(varchar(512),'') shzd,mzmc,case when slbz=0 then '顺利' else '不顺利' end ssqk,--by tangxi 增加字段长度  
convert(varchar(12),'') zdys,convert(varchar(12),'') ssyz,convert(varchar(12),'') ssez,convert(varchar(12),'') sssz,  
convert(varchar(12),'') mzys,convert(varchar(12),'') qxhs,convert(varchar(12),'') xhhs,convert(varchar(12),'') xshs,  
convert(varchar(12),'') dexhhs,convert(varchar(12),'') dexshs,  
case when a.jlzt=0 then '未安排' when a.jlzt=1 then '已安排' when a.jlzt=2 then '已完成' end sszt,  
case when a.jzssbz=1 then '急诊' when a.jzssbz=2 then '择期' else '普通' end jzssbz,  
d.name ssjb,a.memo memo  
into #ssdj  
from SS_SSDJK a (nolock),YY_KSBMK b (nolock),ZY_BRSYK c (nolock),SS_SSDJDMK d(nolock)  
where a.kssj between @ksrq and @jsrq+'24' and (@ssksdm='-1' or a.ssksdm=@ssksdm)  
and a.shzt in (0,1) --and a.shzt = 1  --add by yangdi 2014.4.30 新住院医生站上线修改手术审核参数  
and a.jlzt = 2  
and a.ksdm=b.id and a.syxh=c.syxh  
and a.ssdjdm*=d.id  
order by id,b.name,a.jlzt  
  
create index idx_ssdj on #ssdj (id)  
  
update A set A.sszje=B.sszje,A.ssje=B.ssje,A.mzypje=B.mzypje,A.mzzje=B.mzzje from #ssdj A,(  
select b.ssxh,sum(case when b.fylb=2 then convert(numeric(9,2),isnull(b.ylsj*b.ypsl/b.ykxs*isnull(b.kl/100,1),1)) else 0 end ) sszje,  
			  sum(case when b.fylb=2 AND c.dxmdm='15' then convert(numeric(9,2),isnull(b.ylsj*b.ypsl/b.ykxs*isnull(b.kl/100,1),1)) else 0 end ) ssje,  
              sum(case when b.fylb=0 then convert(numeric(9,2),isnull(b.ylsj*b.ypsl/b.ykxs*isnull(b.kl/100,1),1)) else 0 end ) mzypje,  
              sum(case when b.fylb=1 then convert(numeric(9,2),isnull(b.ylsj*b.ypsl/b.ykxs*isnull(b.kl/100,1),1)) else 0 end ) mzzje  
from VW_SSJZD b  INNER JOIN dbo.YY_SFXXMK c (NOLOCK) ON b.ypdm=c.id
group by b.ssxh) as B  
where A.xh=B.ssxh  
  
---add by yangdi 2016.3.28 计算手术病人甲乙类金额、自费金额信息  
update A set A.jylje=B.jylje,A.zfje=B.zfje  
from #ssdj A,  
(  
 select ssxh,sum(jylje) jylje,sum(zfje) zfje  
 from  
 (  
  select a.ssxh,  
   sum(case when b.fydj in (1,2,4) then convert(numeric(9,2),isnull(a.ylsj*a.ypsl/a.ykxs*isnull(a.kl/100,1),1)) else 0 end) jylje,  
   sum(case when b.fydj = 3 then convert(numeric(9,2),isnull(a.ylsj*a.ypsl/a.ykxs*isnull(a.kl/100,1),1)) else 0 end) zfje  
    from VW_SSJZD a (nolock),VW_YPXMMATCHED b (nolock),#ssdj c  
  where convert(varchar,a.cd_idm)=b.hisxmdm and a.ssxh=c.xh  
  group by a.ssxh  
  union all  
  select a.ssxh,  
   sum(case when b.fydj in (1,2) then convert(numeric(9,2),isnull(a.ylsj*a.ypsl/a.ykxs*isnull(a.kl/100,1),1)) else 0 end) jylje,  
   sum(case when b.fydj = 3 then convert(numeric(9,2),isnull(a.ylsj*a.ypsl/a.ykxs*isnull(a.kl/100,1),1)) else 0 end) zfje  
    from VW_SSJZD a (nolock),VW_YPXMMATCHED b (nolock),#ssdj c  
  where a.ypdm=b.hisxmdm and a.ssxh=c.xh  
  group by a.ssxh  
 ) as a  
 group by a.ssxh  
) as B  
where A.xh=B.ssxh  
 
  
update #ssdj set sqzd=b.zdmc from #ssdj a,SS_SSZDK b (nolock) where a.xh=b.ssxh and zdlb=0 and zdlx=0  
update #ssdj set shzd=b.zdmc from #ssdj a,SS_SSZDK b (nolock) where a.xh=b.ssxh and zdlb=1 and zdlx=0  
  
update #ssdj set zdys=b.ryxm from #ssdj a,SS_SSRYK b (nolock) where a.xh=b.ssxh and rylb=1  
update #ssdj set ssyz=b.ryxm from #ssdj a,SS_SSRYK b (nolock) where a.xh=b.ssxh and rylb=2  
update #ssdj set ssez=b.ryxm from #ssdj a,SS_SSRYK b (nolock) where a.xh=b.ssxh and rylb=3  
update #ssdj set sssz=b.ryxm from #ssdj a,SS_SSRYK b (nolock) where a.xh=b.ssxh and rylb=4  
update #ssdj set mzys=b.ryxm from #ssdj a,SS_SSRYK b (nolock) where a.xh=b.ssxh and rylb=11  
update #ssdj set qxhs=b.ryxm from #ssdj a,SS_SSRYK b (nolock) where a.xh=b.ssxh and rylb=20  
update #ssdj set xhhs=b.ryxm from #ssdj a,SS_SSRYK b (nolock) where a.xh=b.ssxh and rylb=21  
  
--add by yangdi 2017.4.18 增加洗手护士、第二巡回护士、第二洗手护士  
update #ssdj set xshs=b.ryxm from #ssdj a,SS_SSRYK b (nolock) where a.xh=b.ssxh and rylb=22  
update #ssdj set dexhhs=b.ryxm from #ssdj a,SS_SSRYK b (nolock) where a.xh=b.ssxh and rylb=23  
update #ssdj set dexshs=b.ryxm from #ssdj a,SS_SSRYK b (nolock) where a.xh=b.ssxh and rylb=24  
  
  
select id '序号',xh '序号1', blh '住院号',ksmc '科室',hzxm '患者姓名',  
case when ybdm='101' then '住院自费' when ybdm='12DR' then '市级医保' when ybdm='161' then '居民医保' when ybdm='162' then '离休' else '' end '医保类型',  
sex '性别',age '年龄',substring(kssj,1,4)+'-'+substring(kssj,5,2)+'-'+substring(kssj,7,2) '手术日期及时间',  
ssss '手术时数',sszje '手术费用',ssje '手术费',mzypje '麻醉药品费用',mzzje '麻醉费用',jylje '甲乙类金额',zfje '丙类金额', sqzd '术前诊断',ssmc '手术名称',shzd '术后诊断',  
zdys '主刀医生',ssyz '手术一助',ssez '手术二助',sssz '手术三助',mzmc '麻醉方式',mzys '麻醉医生',qxhs '器械护士',xhhs '巡回护士',xshs '洗手护士',dexhhs '第二巡回护士',dexshs '第二洗手护士',ssqk '手术情况', @ssmc '手术室',  
substring(@ksrq,1,4)+'-'+substring(@ksrq,5,2)+'-'+substring(@ksrq,7,2)+'至'+substring(@jsrq,1,4)+'-'+substring(@jsrq,5,2)+'-'+substring(@jsrq,7,2) '日期范围',  
sszt '手术状态',jzssbz '手术类别',ssjb '手术级别',memo '备注'  
from #ssdj  
order by id,ksmc,sszt,blh  
  
return  

