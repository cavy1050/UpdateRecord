ALTER proc usp_ss_tybb_ssylb
@ksrq       ut_rq8, --��ʼ����  
@jsrq       ut_rq8,    --��������  
@ssksdm    ut_ksdm = '-1'  
as  
/**********  
[�汾��]4.0.0.0.0  
[����ʱ��]2004.08.26  
[����]�ƿ˻�  
[��Ȩ] Copyright ? 1998-2001�Ϻ����˴�-����ҽ����Ϣ�������޹�˾  
[����] ����һ����  
[����˵��]  
סԺת��ͳ��  
[����˵��]  
@ksrq       ��ʼ����  
@jsrq       ��������  
@ksdm  ut_ksdm = '0' �����Ҵ���  
[����ֵ]  
[�����������]  
�ɹ��������  
����"F","������Ϣ"  
[���õ�sp]  
usp_ss_tybb_ssylb '20191101','20191131','-1'  
update SS_SSDJK set memo='' where xh='4672'  
select ssdjdm,memo,* from SS_SSDJK where xh='4672'  
select  * from SS_SSDJDMK  
  
  exec usp_ss_tybb_ssylb '20200301','20200330','021101'
  
[����ʵ��]  
**********/  
set nocount on  
  
declare @ssmc ut_mc32  
if @ssksdm='-1'  
select @ssmc='����������'  
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
convert(varchar(64),'') sqzd,ssmc,convert(varchar(512),'') shzd,mzmc,case when slbz=0 then '˳��' else '��˳��' end ssqk,--by tangxi �����ֶγ���  
convert(varchar(12),'') zdys,convert(varchar(12),'') ssyz,convert(varchar(12),'') ssez,convert(varchar(12),'') sssz,  
convert(varchar(12),'') mzys,convert(varchar(12),'') qxhs,convert(varchar(12),'') xhhs,convert(varchar(12),'') xshs,  
convert(varchar(12),'') dexhhs,convert(varchar(12),'') dexshs,  
case when a.jlzt=0 then 'δ����' when a.jlzt=1 then '�Ѱ���' when a.jlzt=2 then '�����' end sszt,  
case when a.jzssbz=1 then '����' when a.jzssbz=2 then '����' else '��ͨ' end jzssbz,  
d.name ssjb,a.memo memo  
into #ssdj  
from SS_SSDJK a (nolock),YY_KSBMK b (nolock),ZY_BRSYK c (nolock),SS_SSDJDMK d(nolock)  
where a.kssj between @ksrq and @jsrq+'24' and (@ssksdm='-1' or a.ssksdm=@ssksdm)  
and a.shzt in (0,1) --and a.shzt = 1  --add by yangdi 2014.4.30 ��סԺҽ��վ�����޸�������˲���  
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
  
---add by yangdi 2016.3.28 �����������˼�������Էѽ����Ϣ  
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
  
--add by yangdi 2017.4.18 ����ϴ�ֻ�ʿ���ڶ�Ѳ�ػ�ʿ���ڶ�ϴ�ֻ�ʿ  
update #ssdj set xshs=b.ryxm from #ssdj a,SS_SSRYK b (nolock) where a.xh=b.ssxh and rylb=22  
update #ssdj set dexhhs=b.ryxm from #ssdj a,SS_SSRYK b (nolock) where a.xh=b.ssxh and rylb=23  
update #ssdj set dexshs=b.ryxm from #ssdj a,SS_SSRYK b (nolock) where a.xh=b.ssxh and rylb=24  
  
  
select id '���',xh '���1', blh 'סԺ��',ksmc '����',hzxm '��������',  
case when ybdm='101' then 'סԺ�Է�' when ybdm='12DR' then '�м�ҽ��' when ybdm='161' then '����ҽ��' when ybdm='162' then '����' else '' end 'ҽ������',  
sex '�Ա�',age '����',substring(kssj,1,4)+'-'+substring(kssj,5,2)+'-'+substring(kssj,7,2) '�������ڼ�ʱ��',  
ssss '����ʱ��',sszje '��������',ssje '������',mzypje '����ҩƷ����',mzzje '�������',jylje '��������',zfje '������', sqzd '��ǰ���',ssmc '��������',shzd '�������',  
zdys '����ҽ��',ssyz '����һ��',ssez '��������',sssz '��������',mzmc '����ʽ',mzys '����ҽ��',qxhs '��е��ʿ',xhhs 'Ѳ�ػ�ʿ',xshs 'ϴ�ֻ�ʿ',dexhhs '�ڶ�Ѳ�ػ�ʿ',dexshs '�ڶ�ϴ�ֻ�ʿ',ssqk '�������', @ssmc '������',  
substring(@ksrq,1,4)+'-'+substring(@ksrq,5,2)+'-'+substring(@ksrq,7,2)+'��'+substring(@jsrq,1,4)+'-'+substring(@jsrq,5,2)+'-'+substring(@jsrq,7,2) '���ڷ�Χ',  
sszt '����״̬',jzssbz '�������',ssjb '��������',memo '��ע'  
from #ssdj  
order by id,ksmc,sszt,blh  
  
return  

