ALTER proc usp_his5_cis_zyys_getypxmjgk_job  
as     
/**********      
[�汾��]5.0    
[����ʱ��]2012.09.01     
[����] ����    
[��Ȩ] Copyright ? 2009-2012�Ϻ����˴�-��������ɷ����޹�˾    
[����] 5.0ҽ��վ��ȡ4.0ҩƷ��Ŀ�۸��    
[����˵��]      
his�� YK_YPCDMLK ͬ�����ݵ�his�� CPOE_CIS_DRUGITEM�С�����洢������Ҫ����������ִ�У�һ����Ϊ���6Сʱִ��һ�μ���    
ע������Ҫ������THIS4�����ݿ���    
[����˵��]      

[����ֵ]      

[�����������]      

[���õ�sp]      

[����ʵ��]      
exec usp_his5_cis_zyys_getypxmjgk_job   

[�޸ļ�¼]    

**********/    

declare @now ut_rq16,    
@oldnow ut_rq16    
select @now=convert(char(8),getdate(),112)+convert(char(8),getdate(),8)    

declare @nshowbm ut_bz, -- ��ʾ����    
@nrepeat ut_bz,  -- 0061�ٴ���Ŀ�а������շ���Ŀ�Ƿ���ѡ����    
@isybbl  ut_bz, --�Ƿ��ڴ���¼���ͨ�ò�ѯ����ʾҽ�����������ҽ������    
@isyfdw  ut_bz, -- �Ƿ�ʹ��ҩ����λ 0070    
@HP1037 varchar(1),  
@HP1121  varchar(2)  
set @HP1037=''  
set @HP1121='��'  
select @HP1037 =isnull(CONFIG,'0') from CISSVR.CISDB.dbo.SYS_CONFIG where ID='HP1037'  
select @HP1121 =isnull(CONFIG,'��') from CISSVR.CISDB.dbo.SYS_CONFIG where ID='HP1121'  
select @nshowbm = 1    
select @nrepeat = 1    
select @isyfdw = 1     
-- set nocount on     
-- set ansi_defaults off    
-- ��ȡ������ҩ������    
select a.id as yfdm, a.name as ksmc     
into #tmpyfdm    
from  YY_KSBMK a  with (nolock)    
where exists(select 1 from  SF_YFDYK where charindex(rtrim(a.id),sql) > 0 and kslb in (1))    
create index idx_ksbm on #tmpyfdm(yfdm)    

--��ȡҩƷ��Ϣ    
select a.cd_idm as idm, a.gg_idm, a.lc_idm, (a.kcsl2 - a.djsl) as kcsl, a.ksdm as yfdm,y.ksmc yfmc,    
convert(int, 0) as jbdyfw,    
convert(varchar(32),c.ypdm) ypdm, convert(varchar(256),c.ypmc) ypmc, (c.py+rtrim(f.py)) as py,   -- by q_gy 20190513 convert(varchar(256),c.ypmc) ypmc
(c.wb+rtrim(f.wb)) as wb,(case when c.islcjsyp=1 then '(��)' else '' end)+c.ypgg ypgg, c.yplh as dxmdm,     
(case when @isyfdw = 1 then a.mzdw else c.mzdw end) as mzdw,     
(case when @isyfdw = 1 then a.mzxs else c.mzxs end) as mzxs,     
(case when @isyfdw = 1 then a.zydw else c.zydw end) as zydw,     
(case when @isyfdw = 1 then a.zyxs else c.zyxs end) as zyxs,     
c.ykdw, c.ykxs, c.ggdw, c.ggxs, c.zxdw, c.psbz, c.tsbz, isnull(c.ybkzbz, 0) ybkzbz, c.bxbz, c.ylsj, c.cjmc, c.memo, c.fldm,     
c.flzfbz, c.zfbz as mzzfbz, c.zyzfbz as zyzfbz, c.dydm, a.kzbz, convert(int, 1-c.tybz) as mzsybz, convert(int, 1-c.tybz) as zysybz,    
c.dbcybz,convert(varchar(5), c.jxdm) jxdm, f.name as flmc, f.fl_mc as fldlmc,     
l.ypmc as yplcmc, l.py as yplcpy, l.wb as yplcwb,     
convert(int, 0) as ypbz, convert(varchar(4), '-1') as xmlb, convert(varchar(32), '0') as lcxmdm,    
convert(int, 0) as pos, convert(varchar(6),'') as pos_bz, convert(money, 0.00) as lcxmdj, convert(varchar(64), '') as lcxmmc,    
convert(varchar(32), '') as zxmdm, convert(int, 0) as bmbz, convert(int, 0) as yjqrbz --������ҽ��ȷ��    
,c.ekdw,c.ekxs,isnull(c.mzlybz,0) mzlybz,isnull(c.ljlybz,0) zylybz ,convert(char(8),'') as lcxmdw,    
CONVERT(varchar(32),'') as jxmc,CONVERT(varchar(32),'') as dxmmc,CONVERT(int,0) as dxmypbz,c.ypfj,c.bqdjbz,j.ypmc as ypggmc,j.py as ypggpy,j.wb as ypggwb,c.isqfkz    
,a.cyfybz,isnull(c.zyzfbl,0) as zyzfbl ,c.otcbz,c.zbybz ,convert(int,0) yzglbz,convert(int,0) cgyzbz     
,isnull(c.gwypjb,0) as gwypjb ,isnull(c.basicdrug_flag,0) as gjjbywbz ,isnull(c.jbywml_shi,0) as sjjbywbz,c.sjbywml as shenjjbywbz,isnull(q.fzyybz,0) as fzyybz,convert(int,0) as sshcbz  
,isnull(s.yydm,'-1') as yydm ,q.glbs_name,q.glbs_id ,CONVERT(money,NULL) as etjsje,q.ybbz_sheng,q.ybbz_shi,q.ybbz_nh,q.ybbz_tielu,q.fyyybz,isnull(c.kjhyp_flag,0) as kjhypbz,q.tmbz         
into #tmpdrugs    
from  YF_YFZKC a  with (nolock)   
left join YY_KSBMK s with (nolock) on a.ksdm = s.id   
left join YK_YPGGMLK j with (nolock) on a.gg_idm=j.idm, #tmpyfdm y,  YK_YPCDMLK c  with (nolock) left join YK_YPFLK f  with (nolock) on c.fldm = f.id     
left join  YK_YPLCMLK l  with (nolock) on c.lc_idm = l.idm    
left join YK_YPCDMLKZK q  with (nolock) on c.idm = q.idm  

where a.ksdm = y.yfdm and a.cd_idm = c.idm  and c.ylsj >= 0 and a.kzbz=0 and c.tybz=0 --and a.jbdyfw<>2    
create index idx_idm on #tmpdrugs(idm)   

--��ṹ    
select top 0 *    
into #tmpdrugitems    
from #tmpdrugs where -1=0    

create index idx_xmdm on #tmpdrugitems(idm, ypdm, lcxmdm)    
create index idx_yfdm on #tmpdrugitems(yfdm)    

--�ٴ���Ŀ��Ϣ    

if @HP1037 = '' or @HP1037 = '0'  
begin  
insert into #tmpdrugitems(idm, gg_idm, lc_idm, kcsl, yfdm, yfmc,    
ypdm, ypmc, py, wb, ypgg, dxmdm,     
mzdw, mzxs, zydw, zyxs, ykdw, ykxs, ggdw, ggxs, zxdw,     
psbz, tsbz, ybkzbz, bxbz, ylsj, cjmc, memo, fldm,    
flzfbz, mzzfbz, zyzfbz, dydm, kzbz, mzsybz, zysybz,    
flmc, fldlmc, yplcmc, yplcpy, yplcwb,     
ypbz, xmlb, lcxmdm, pos, pos_bz,     
lcxmdj, lcxmmc, zxmdm, bmbz, yjqrbz, dbcybz, jxdm,ekdw,ekxs,mzlybz,zylybz,lcxmdw,ypfj,isqfkz,zyzfbl,yzglbz,cgyzbz,gwypjb,gjjbywbz,sjjbywbz,shenjjbywbz,fzyybz,sshcbz,yydm,glbs_name,glbs_id,  
etjsje,kjhypbz)    
select 0, 0, 0, 999999, isnull(e.zxks_id, ''), isnull(k.name, ''),    
a.id, convert(varchar(64),rtrim(c.name)+(case d.pos when 0 then '��' when 1 then '��' when 1000 then '��' else '��' end)+a.name),c.py, c.wb, a.xmgg, a.dxmdm,    
isnull(a.xmdw,isnull(c.xmdw,'')), 1, isnull(a.xmdw,isnull(c.xmdw,'')), 1, isnull(a.xmdw,isnull(c.xmdw,'')), 1, isnull(a.xmdw,isnull(c.xmdw,'')), 1, isnull(a.xmdw,isnull(c.xmdw,'')),    
0, 0, isnull(a.ybkzbz,0), a.bxbz, a.xmdj, '', a.memo, '',    
a.flzfbz, a.mzzfbz, a.zyzfbz, a.dydm, 0 as kzbz, 1 as mzsybz, 1 as zysybz,    
h.name, h.name, '', '', '',    
1, a.xmlb, c.id, d.pos, (case d.pos when 0 then '' when 1 then '��' when 1000 then '��' else '��' end),    
c.xmdj,c.name,c.zxmdm,0, a.yjqrbz, 0, '',a.xmdw,1,0,0,c.xmdw,a.xmdj,a.isqfkz,isnull(a.zyzfbl,0),a.yzgl,a.cgyzbz,0,0,0,0,0,c.sshcbz,isnull(a.yydm,'-1'),'',''  ,  
a.etjsje,0  
from  YY_SFXXMK a  with (nolock) left join YY_SFXMLBK h  with (nolock) on a.xmlb = h.lb, YY_LCSFXMK c  with (nolock),     
YY_LCSFXMDYK d  with (nolock), YY_SFXXMK e  with (nolock) left join YY_KSBMK k  with (nolock) on e.zxks_id = k.id    
where c.id = d.lcxmdm and c.jlzt=0 and c.syfw in (0,1,2) and a.id=d.xmdm and  c.zxmdm=e.id and a.zybz=1    
and   a.xmdj >= 0     
end  
else  
begin  
insert into #tmpdrugitems(idm, gg_idm, lc_idm, kcsl, yfdm, yfmc,    
ypdm, ypmc, py, wb, ypgg, dxmdm,     
mzdw, mzxs, zydw, zyxs, ykdw, ykxs, ggdw, ggxs, zxdw,     
psbz, tsbz, ybkzbz, bxbz, ylsj, cjmc, memo, fldm,    
flzfbz, mzzfbz, zyzfbz, dydm, kzbz, mzsybz, zysybz,    
flmc, fldlmc, yplcmc, yplcpy, yplcwb,     
ypbz, xmlb, lcxmdm, pos, pos_bz,     
lcxmdj, lcxmmc, zxmdm, bmbz, yjqrbz, dbcybz, jxdm,ekdw,ekxs,mzlybz,zylybz,lcxmdw,ypfj,isqfkz,zyzfbl,yzglbz,cgyzbz,gwypjb,gjjbywbz,sjjbywbz,shenjjbywbz,fzyybz,sshcbz,yydm,glbs_name,glbs_id,  
etjsje,kjhypbz)    
select 0, 0, 0, 999999, isnull(e.zxks_id, ''), isnull(k.name, ''),    
a.id, convert(varchar(64),rtrim(c.name)),c.py, c.wb, a.xmgg, a.dxmdm,    
isnull(c.xmdw,isnull(a.xmdw,'')), 1, isnull(c.xmdw,isnull(a.xmdw,'')), 1, isnull(c.xmdw,isnull(a.xmdw,'')), 1, isnull(c.xmdw,isnull(a.xmdw,'')), 1, isnull(c.xmdw,isnull(a.xmdw,'')),    
0, 0, isnull(a.ybkzbz,0), a.bxbz, a.xmdj, '', a.memo, '',    
a.flzfbz, a.mzzfbz, a.zyzfbz, a.dydm, 0 as kzbz, 1 as mzsybz, 1 as zysybz,    
h.name, h.name, '', '', '',    
1, a.xmlb, c.id, d.pos, '',    
c.xmdj,c.name,c.zxmdm,0, a.yjqrbz, 0, '',a.xmdw,1,0,0,c.xmdw,a.xmdj,a.isqfkz,isnull(a.zyzfbl,0),a.yzgl,a.cgyzbz,0,0,0,0,0,c.sshcbz,isnull(a.yydm,'-1'),'',''  ,  
a.etjsje,0  
from  YY_SFXXMK a  with (nolock) left join YY_SFXMLBK h  with (nolock) on a.xmlb = h.lb, YY_LCSFXMK c  with (nolock),     
YY_LCSFXMDYK d  with (nolock), YY_SFXXMK e  with (nolock) left join YY_KSBMK k  with (nolock) on e.zxks_id = k.id    
where c.id = d.lcxmdm and c.jlzt=0 and c.syfw in (0,1,2) and a.id=d.xmdm and  c.zxmdm=e.id and a.zybz=1    
and   a.xmdj >= 0   and d.pos in (0,1)  
end  


--�շ���Ŀ��Ϣ    
insert into #tmpdrugitems(idm, gg_idm, lc_idm, kcsl, yfdm, yfmc,     
ypdm, ypmc, py, wb, ypgg, dxmdm,     
mzdw, mzxs, zydw, zyxs, ykdw, ykxs, ggdw, ggxs, zxdw,     
psbz, tsbz, ybkzbz, bxbz, ylsj, cjmc, memo, fldm,    
flzfbz, mzzfbz, zyzfbz, dydm, kzbz, mzsybz, zysybz,    
flmc, fldlmc, yplcmc, yplcpy, yplcwb,     
ypbz, xmlb, lcxmdm, pos, pos_bz,     
lcxmdj, lcxmmc, zxmdm, bmbz, yjqrbz, dbcybz, jxdm,ekdw,ekxs,mzlybz,zylybz,lcxmdw,ypfj,isqfkz,zyzfbl,yzglbz,cgyzbz,gwypjb,gjjbywbz,sjjbywbz,shenjjbywbz,fzyybz,sshcbz,yydm,glbs_name,glbs_id,  
etjsje,kjhypbz)    
select 0, 0, 0, 999999, isnull(a.zxks_id, ''), isnull(k.name, ''),    
a.id, a.name, a.py, a.wb, a.xmgg, a.dxmdm,    
isnull(a.xmdw,''), 1, isnull(a.xmdw,''), 1, isnull(a.xmdw,''), 1, isnull(a.xmdw,''), 1, isnull(a.xmdw,''),    
0, 0, isnull(a.ybkzbz,0), a.bxbz, a.xmdj, '', a.memo, '',    
a.flzfbz, a.mzzfbz, a.zyzfbz, a.dydm, 0, a.mzbz, a.zybz,    
h.name, h.name, '', '', '',    
1, case a.xmlb when 1 then 0 else a.xmlb end, '0', 0, '',    
0, '', '', 0, a.yjqrbz, 0, '',a.xmdw,1,0,0,'',a.xmdj,a.isqfkz,isnull(a.zyzfbl,0) ,a.yzgl,a.cgyzbz,0,0,0,0,0,a.sshcbz ,isnull(a.yydm,'-1'),'','',  
a.etjsje,0  
from  YY_SFXXMK a  with (nolock)left join YY_SFXMLBK h  with (nolock) on a.xmlb = h.lb left join YY_KSBMK k  with (nolock) on a.zxks_id = k.id    
where a.sybz = 1 and  a.xmdj >= 0 and    a.zybz=1  
--add by yangdi 2019.11.25 ��������������Ҫ��������ã�330100005.03 ȫ������(�������ܲ�ܡ�����ʱ��30��������) ����ҽ��ȷ�ϣ�ע���¾䣬�ϲ�δ����ǰ����.
--and a.xmlb not in (2) --�ų��������������� alter aorigele 2013/10/18    
and ((a.cgyzbz=0 or a.xmlb=5) or (a.cgyzbz=1 or a.xmlb!=5)) and a.yzxm=0    
and (@nrepeat = 1 or not exists(select 1 from #tmpdrugitems c where idm = 0 and a.id = c.ypdm and c.lcxmdm <> '0' and ypbz = 1) )    
--����    
if @nshowbm = 1     
begin    
insert into #tmpdrugitems(idm, gg_idm, lc_idm, kcsl, yfdm, yfmc,     
ypdm, ypmc, py, wb, ypgg, dxmdm,     
mzdw, mzxs, zydw, zyxs, ykdw, ykxs, ggdw, ggxs, zxdw,     
psbz, tsbz, ybkzbz, bxbz, ylsj, cjmc, memo, fldm,    
flzfbz, mzzfbz, zyzfbz, dydm, kzbz, mzsybz, zysybz,    
flmc, fldlmc, yplcmc, yplcpy, yplcwb,     
ypbz, xmlb, lcxmdm, pos, pos_bz,     
lcxmdj, lcxmmc, zxmdm, bmbz, yjqrbz, dbcybz, jxdm,ekdw,ekxs,mzlybz,zylybz,lcxmdw,ypfj,isqfkz,zyzfbl,yzglbz,cgyzbz,gwypjb,gjjbywbz,sjjbywbz,shenjjbywbz,fzyybz,sshcbz,yydm,glbs_name,glbs_id,  
etjsje,kjhypbz)    
select 0, 0, 0, 999999, isnull(a.zxks_id, ''), isnull(k.name, ''),    
a.id, m.bmmc, m.py, m.wb, a.xmgg, a.dxmdm,    
isnull(a.xmdw,''), 1, isnull(a.xmdw,''), 1, isnull(a.xmdw,''), 1, isnull(a.xmdw,''), 1, isnull(a.xmdw,''),    
0, 0, isnull(a.ybkzbz, 0), a.bxbz, a.xmdj, '', a.memo, '',    
a.flzfbz, a.mzzfbz, a.zyzfbz, a.dydm, 0, a.mzbz, a.zybz,    
h.name, h.name, '', '', '',    
1, a.xmlb, '0', 0, '',    
0, '', '', 1, a.yjqrbz, 0, '',a.xmdw,1,0,0,'',a.xmdj,a.isqfkz,isnull(a.zyzfbl,0) ,a.yzgl,a.cgyzbz,0,0,0,0,0,a.sshcbz,isnull(a.yydm,'-1'),'','',  
a.etjsje,0  
from YY_SFXXMK a  with (nolock) left join  YY_SFXMLBK h  with (nolock) on a.xmlb = h.lb left join YY_KSBMK k  with (nolock) on a.zxks_id = k.id,    
YY_SFXXMBMK m  with (nolock) where a.sybz = 1 and a.id = m.id   and a.xmdj >= 0 and    a.zybz=1    
and exists(select 1 from #tmpdrugitems g where g.idm = 0 and a.id = g.ypdm and g.lcxmdm = '0')    
end   
 

--����ҽ���Ĵ���   
if @HP1121='��'   
begin  
insert into #tmpdrugitems(idm, gg_idm, lc_idm, kcsl, yfdm, yfmc,     
ypdm, ypmc, py, wb, ypgg, dxmdm,     
mzdw, mzxs, zydw, zyxs, ykdw, ykxs, ggdw, ggxs, zxdw,     
psbz, tsbz, ybkzbz, bxbz, ylsj, cjmc, memo, fldm,    
flzfbz, mzzfbz, zyzfbz, dydm, kzbz, mzsybz, zysybz,    
flmc, fldlmc, yplcmc, yplcpy, yplcwb,     
ypbz, xmlb, lcxmdm, pos, pos_bz,     
lcxmdj, lcxmmc, zxmdm, bmbz, yjqrbz, dbcybz, jxdm,ekdw,ekxs,mzlybz,zylybz,lcxmdw,ypfj,zyzfbl,gwypjb,gjjbywbz,sjjbywbz,shenjjbywbz,fzyybz,yydm,glbs_name,glbs_id,  
etjsje,kjhypbz)    
select 0, 0, 0, 999999, '', '',    
a.id, a.name, a.py, a.wb, '', '',    
'', 1, '', 1, '', 1, '', 1, '',    
0, 0, 0, 0,0, '', '', '',    
0, 0, 0, 0, 0, 0, 1,    
'', '', a.bmmc, '', '',    
3, 1, '0', 0, '',    
0, '', '', 0, 0, 0, '','',1,0,0,'',0,0,0,0,0,0 ,0,'-1','','',  
0,0  
from  SS_SSMZK a  with (nolock) where lb=0 and ISNULL(tybz,0)!=1 and ssgl_id=0 and ssgl_id!='' and ssgl_id is not null    
end  
else  
begin  
insert into #tmpdrugitems(idm, gg_idm, lc_idm, kcsl, yfdm, yfmc,     
ypdm, ypmc, py, wb, ypgg, dxmdm,     
mzdw, mzxs, zydw, zyxs, ykdw, ykxs, ggdw, ggxs, zxdw,     
psbz, tsbz, ybkzbz, bxbz, ylsj, cjmc, memo, fldm,    
flzfbz, mzzfbz, zyzfbz, dydm, kzbz, mzsybz, zysybz,    
flmc, fldlmc, yplcmc, yplcpy, yplcwb,     
ypbz, xmlb, lcxmdm, pos, pos_bz,     
lcxmdj, lcxmmc, zxmdm, bmbz, yjqrbz, dbcybz, jxdm,ekdw,ekxs,mzlybz,zylybz,lcxmdw,ypfj,zyzfbl,gwypjb,gjjbywbz,sjjbywbz,shenjjbywbz,fzyybz,yydm,glbs_name,glbs_id,  
etjsje,kjhypbz)    
select 0, 0, 0, 999999, '', '',    
a.id, a.name, a.py, a.wb, '', '',    
'', 1, '', 1, '', 1, '', 1, '',    
0, 0, 0, 0,0, '', '', '',    
0, 0, 0, 0, 0, 0, 1,    
'', '', a.bmmc, '', '',    
3, 1, '0', 0, '',    
0, '', '', 0, 0, 0, '','',1,0,0,'',0,0,0,0,0,0 ,0,'-1','','',  
0,0  
from  SS_SSMZK a  with (nolock) where lb=0 and ISNULL(tybz,0)!=1  
end  


--ҩƷ��Ϣ    
insert into #tmpdrugitems(idm, gg_idm, lc_idm, kcsl, yfdm, yfmc,    
ypdm, ypmc, py, wb, ypgg, dxmdm,     
mzdw, mzxs, zydw, zyxs, ykdw, ykxs, ggdw, ggxs, zxdw,     
psbz, tsbz, ybkzbz, bxbz, ylsj, cjmc, memo, fldm,    
flzfbz, mzzfbz, zyzfbz, dydm, kzbz, mzsybz, zysybz,    
flmc, fldlmc, yplcmc, yplcpy, yplcwb,     
ypbz, xmlb, lcxmdm, pos, pos_bz,     
lcxmdj, lcxmmc, zxmdm, bmbz, yjqrbz, dbcybz, jxdm,ekdw,ekxs,mzlybz,zylybz,lcxmdw,ypfj,bqdjbz,ypggmc,ypggpy,ypggwb,isqfkz,cyfybz,zyzfbl,otcbz,zbybz,gwypjb,gjjbywbz,sjjbywbz,shenjjbywbz,fzyybz,yydm,glbs_name,glbs_id,  
etjsje,ybbz_sheng,ybbz_shi,ybbz_nh,ybbz_tielu,fyyybz,kjhypbz,tmbz)    
select idm, gg_idm, lc_idm, kcsl, yfdm, yfmc,    
ypdm, ypmc, py, wb, ypgg, dxmdm,     
mzdw, mzxs, zydw, zyxs, ykdw, ykxs, ggdw, ggxs, zxdw,     
psbz, tsbz, ybkzbz, bxbz, ylsj, cjmc, memo, fldm,    
flzfbz, mzzfbz, zyzfbz, dydm, kzbz, mzsybz, zysybz,    
flmc, fldlmc, yplcmc, yplcpy, yplcwb,     
ypbz, xmlb, lcxmdm, pos, pos_bz,     
lcxmdj, lcxmmc, zxmdm, bmbz, yjqrbz, dbcybz, jxdm,ekdw,ekxs,mzlybz,zylybz,lcxmdw,ypfj,bqdjbz,ypggmc,ypggpy,ypggwb,isqfkz    
,cyfybz,zyzfbl,otcbz,zbybz,gwypjb,gjjbywbz ,sjjbywbz,shenjjbywbz,fzyybz -- add for aorigele 20130411 for rj    
,yydm,glbs_name,glbs_id,  
etjsje,ybbz_sheng,ybbz_shi,ybbz_nh,ybbz_tielu,fyyybz,kjhypbz,tmbz  
from #tmpdrugs    

--����    
if @nshowbm = 1     
begin    
insert into #tmpdrugitems(idm, gg_idm, lc_idm, kcsl, yfdm, yfmc,    
ypdm, ypmc, py, wb, ypgg, dxmdm,     
mzdw, mzxs, zydw, zyxs, ykdw, ykxs, ggdw, ggxs, zxdw,     
psbz, tsbz, ybkzbz, bxbz, ylsj, cjmc, memo, fldm,    
flzfbz, mzzfbz, zyzfbz, dydm, kzbz, mzsybz, zysybz,    
flmc, fldlmc, yplcmc, yplcpy, yplcwb,     
ypbz, xmlb, lcxmdm, pos, pos_bz,     
lcxmdj, lcxmmc, zxmdm, bmbz, yjqrbz, dbcybz, jxdm,ekdw,ekxs,mzlybz,zylybz,lcxmdw,ypfj,bqdjbz,ypggmc,ypggpy,ypggwb,isqfkz,cyfybz    
,zyzfbl,gwypjb,gjjbywbz,sjjbywbz,shenjjbywbz,fzyybz,yydm,glbs_name,glbs_id,  
etjsje,ybbz_sheng,ybbz_shi,ybbz_nh,ybbz_tielu,fyyybz,kjhypbz,tmbz)    
select a.idm, a.gg_idm, a.lc_idm, a.kcsl, a.yfdm, a.yfmc,    
a.ypdm, d.bmmc, d.py, d.wb, a.ypgg, a.dxmdm,     
a.mzdw, a.mzxs, a.zydw, a.zyxs, a.ykdw, a.ykxs, a.ggdw, a.ggxs, a.zxdw,     
a.psbz, a.tsbz, a.ybkzbz, a.bxbz, a.ylsj, a.cjmc, a.memo, a.fldm,    
a.flzfbz, a.mzzfbz, a.zyzfbz, a.dydm, a.kzbz, a.mzsybz, a.zysybz,    
a.flmc, a.fldlmc, a.yplcmc, a.yplcpy, a.yplcwb,     
a.ypbz, a.xmlb, a.lcxmdm, a.pos, a.pos_bz,     
a.lcxmdj, a.lcxmmc, a.zxmdm, 1 bmbz, a.yjqrbz, a.dbcybz, a.jxdm,a.ekdw,a.ekxs,a.mzlybz,a.zylybz,a.lcxmdw,a.ypfj,a.bqdjbz,a.ypggmc,a.ypggpy,a.ypggwb,a.isqfkz    
,a.cyfybz,a.zyzfbl,a.gwypjb,a.gjjbywbz,a.sjjbywbz,a.shenjjbywbz,a.fzyybz,a.yydm ,a.glbs_name,a.glbs_id ,  
a.etjsje,a.ybbz_sheng,a.ybbz_shi,a.ybbz_nh,a.ybbz_tielu,a.fyyybz,a.kjhypbz,a.tmbz  
from #tmpdrugs a, YK_YPBMK d  with (nolock)    
where a.idm = d.idm    

if exists(select 1 from YY_CONFIG where id = '0072' and config = '��')  --�ٴ�����    
begin    
insert into #tmpdrugitems(idm, gg_idm, lc_idm, kcsl, yfdm, yfmc,    
ypdm, ypmc, py, wb, ypgg, dxmdm,     
mzdw, mzxs, zydw, zyxs, ykdw, ykxs, ggdw, ggxs, zxdw,     
psbz, tsbz, ybkzbz, bxbz, ylsj, cjmc, memo, fldm,    
flzfbz, mzzfbz, zyzfbz, dydm, kzbz, mzsybz, zysybz,    
flmc, fldlmc, yplcmc, yplcpy, yplcwb,     
ypbz, xmlb, lcxmdm, pos, pos_bz,     
lcxmdj, lcxmmc, zxmdm, bmbz, yjqrbz, dbcybz, jxdm,ekdw,ekxs,mzlybz,zylybz,lcxmdw,ypfj,ypggmc,ypggpy,ypggwb,isqfkz,cyfybz    
,zyzfbl,gwypjb,gjjbywbz,sjjbywbz,shenjjbywbz,fzyybz,yydm,glbs_name,glbs_id,  
etjsje,ybbz_sheng,ybbz_shi,ybbz_nh,ybbz_tielu,fyyybz,kjhypbz,tmbz)    
select a.idm, a.gg_idm, a.lc_idm, a.kcsl, a.yfdm, a.yfmc,    
a.ypdm, a.ypmc, a.py, a.wb, a.ypgg, a.dxmdm,     
a.mzdw, a.mzxs, a.zydw, a.zyxs, a.ykdw, a.ykxs, a.ggdw, a.ggxs, a.zxdw,     
a.psbz, a.tsbz, a.ybkzbz, a.bxbz, a.ylsj, a.cjmc, a.memo, a.fldm,    
a.flzfbz, a.mzzfbz, a.zyzfbz, a.dydm, a.kzbz, a.mzsybz, a.zysybz,    
a.flmc, a.fldlmc, d.lcbm yplcmc, d.py yplcpy, d.wb yplcwb,     
a.ypbz, a.xmlb, a.lcxmdm, a.pos, a.pos_bz,     
a.lcxmdj, a.lcxmmc, a.zxmdm, 1 bmbz, a.yjqrbz,a.dbcybz, a.jxdm,a.ekdw,a.ekxs,a.mzlybz,a.zylybz,a.lcxmdw,a.ypfj,a.ypggmc,a.ypggpy,a.ypggwb,a.isqfkz    
,a.cyfybz,a.zyzfbl,a.gwypjb,a.gjjbywbz,a.sjjbywbz,a.shenjjbywbz,a.fzyybz,a.yydm,a.glbs_name,a.glbs_id  ,  
a.etjsje,a.ybbz_sheng,a.ybbz_shi,a.ybbz_nh,a.ybbz_tielu,a.fyyybz,a.kjhypbz,a.tmbz  
from #tmpdrugs a, YK_YLCBMK d  with (nolock)    
where a.lc_idm = d.idm    
end    
end    


if not exists(select 1 from #tmpdrugitems)     
begin    
select 'F','�������û���ҵ�ת������ʱ�ļ���'    
return    
end    

--����ҩƷ��С��ĿҩƷ��־    
update #tmpdrugitems set dxmypbz= b.yptjbz   
from #tmpdrugitems a,YY_SFDXMK b where a.dxmdm=b.id and a.idm > 0-- and a.ypbz < 2     

update #tmpdrugitems set dxmmc=b.name    
from #tmpdrugitems a,YY_SFDXMK b where a.dxmdm=b.id --and a.idm > 0-- and a.ypbz < 2     

--���¼�������    
update #tmpdrugitems set jxmc=b.name    
from #tmpdrugitems a,YK_YPJXK b where a.jxdm=b.id and a.idm > 0 and a.ypbz < 2     

--��������������py��wb   
update #tmpdrugitems set yplcpy = b.py ,yplcwb = b.wb    
from #tmpdrugitems a,SS_SSMZBMK b where a.yplcmc = b.name    

if not exists(select 1 from sysobjects where name = 'V5_DRUGITEM' AND xtype = 'U')    
begin    
CREATE TABLE V5_DRUGITEM    
(    
IDM   ut_xh9 not null, --ҩƷidm    
GG_IDM  ut_xh9 not null, --���idm    
LC_IDM  ut_xh9 not null, --�ٴ�idm    
KCSL  ut_sl10 not null, --�������    
YFDM  ut_ksdm not null,  --ҩ������    
YFMC  ut_mc32 null,  --ҩ������    
YPDM  ut_xmdm not null, --ҩƷ����    
YPMC  ut_mc256 null,  --ҩƷ����    
PY   ut_mc256 null,  --ƴ��    
WB   ut_mc256 null,  --���    
YPGG  ut_mc32 null,  --ҩƷ���    
DXMDM  ut_kmdm null,  --����Ŀ����    
MZDW   ut_unit null,  --���ﵥλ    
MZXS  ut_dwxs null,  --����ϵ��    
ZYDW  ut_unit null,  --סԺ��λ    
ZYXS  ut_dwxs null,  --סԺϵ��    
EKDW  ut_unit null,  --���Ƶ�λ    
EKXS  ut_dwxs null,  --����ϵ��    
YKDW  ut_unit null,  --ҩ�ⵥλ    
YKXS  ut_dwxs null,  --ҩ��ϵ��    
GGDW  ut_unit null,  --���λ    
GGXS  ut_dwxs null,  --���ϵ��    
ZXDW  ut_unit null,  --��С��λ    
PSBZ  ut_bz null,  --Ƥ�Ա�־    
TSBZ  ut_bz null,  --�����־����ҩƷ��־  0:��ͨ,1����,2����,3�綾,4Σ��,5����,6�ȵ���,9������    
YBKZBZ  ut_bz null,  --ҽ�����Ʊ�־    
BXBZ  ut_bz null,  --������־    
YLSJ  ut_money null, --����    
YPFJ  ut_money null, --������    
CJMC  ut_mc256  null, --��������    
MEMO  varchar(1024)  null, --��ע    
FLDM  ut_fldm  null, --�������    
FLZFBZ  ut_bz  null, --�����Ը���־    
ZYZFBZ     ut_bz  null, --סԺ�Էѱ�־    
MZZFBZ     ut_bz  null, --�����Էѱ�־    
DYDM  varchar(32) null, --ҽ����Ӧ����    
KZBZ  ut_bz  null, --���Ʊ�־false:�����ƣ�True������    
DBCYBZ  ut_bz  null, --�Ƿ�Ϊ�����ҩ    
JXDM  ut_jxdm  null, --���ʹ���    
JXMC  ut_mc32  null, --��������    
FLMC  ut_mc32  null, --��������    
FLDLMC  ut_mc32  null, --�����������    
YPLCMC  ut_mc64  null, --ҩƷ�ٴ�����    
YPLCPY  ut_py  null, --ҩƷ�ٴ�ƴ��    
YPLCWB  ut_py  null, --ҩƷ�ٴ����    
YPGGMC  ut_mc64  null, --ҩƷ�������    
YPGGPY  ut_py  null, --ҩƷ���ƴ��    
YPGGWB  ut_py  null, --ҩƷ������    
QFKZBZ  ut_bz  null, --Ƿ�ѿ��Ʊ�־ true ��Ƿ�ѿ��� false ����Ƿ�ѿ���    
YPBZ  ut_bz  null, --ҩƷ��־    
XMLB  ut_bz  null, --��Ŀ���    
LCXMDM  ut_mc32  not null, --�ٴ���Ŀ����    
LCXMMC  ut_mc64  null, --�ٴ���Ŀ����    
LCXMDJ  ut_money null, --�ٴ���Ŀ����    
POS   ut_bz  null, --�ٴ���Ŀ���־    
POS_BZ  ut_dm4  null, --�ٴ���Ŀ���־��ʾ    
ZXMDM  ut_xmdm  null, --����Ŀ����    
BMBZ  ut_bz  not null, --������־    
YJQRBZ  ut_bz  null, --ҽ��ȷ�ϱ�־    
BQDJBZ  ut_bz  null, --�������ݱ�־  0 ��ͨ 1Ƭ���뷢 2 ���Ƭ��     
ZYLYBZ  ut_bz  null, --סԺ��ҩ��־0:��ͨ(��������Ƶ�Ρ����� ) 1������ȡ����ÿ����ҩȡ����    
MZLYBZ  ut_bz  null, --������ҩ��־0:��ͨ(��������Ƶ�Ρ����� ) 1������ȡ����ÿ����ҩȡ����     
DXMMC  ut_mc32  null, --����Ŀ����    
DXM_YPBZ int  null, --����ĿҩƷ��־    
CGYZBZ  ut_bz  null, --����ҽ����־    
YZGLBZ  ut_bz  null, --ҽ�������־    
LCXMLB  ut_bz   null,--�ٴ���Ŀ���    
SSHCBZ      ut_bz       null,    ----0:������ʳ������� 1:��������ʳ�������   
YYDM  ut_dm2 null, --yydmΪ-1ʱ����ʾȫ��Ժ�����ã�yydm��Ϊ-1��yydmΪԺ�������   
YBBZ_SHENG ut_bz               null ,--ʡҽ��  
YBBZ_SHI    ut_bz               null ,--��ҽ��  
YBBZ_NH     ut_bz               null ,--ũ��ҽ��  
YBBZ_TIELU  ut_bz               null,--��·ҽ��     
FYYYBZ      int                 null, --������ҩ��־  
TMBZ       ut_bz                null  --������־    
)    


end    
else    
begin    
alter table V5_DRUGITEM alter column MEMO varchar(1024) null    
alter table V5_DRUGITEM alter column PY ut_mc256 null    
alter table V5_DRUGITEM alter column WB ut_mc256 null    
alter table V5_DRUGITEM alter column CJMC ut_mc256 null  
alter table V5_DRUGITEM alter column YPMC ut_mc256 null  
end    
if not exists(select 1 from syscolumns where id = object_id('V5_DRUGITEM') and name = 'SSHCBZ')    
ALTER TABLE V5_DRUGITEM ADD SSHCBZ ut_bz    
if not exists(select 1 from syscolumns where id = object_id('V5_DRUGITEM') and name = 'CYFYBZ')    
ALTER TABLE V5_DRUGITEM ADD CYFYBZ ut_bz    
if not exists(select 1 from syscolumns where id = OBJECT_ID('V5_DRUGITEM') and name = 'ZYZFBL')    
ALTER TABLE V5_DRUGITEM ADD ZYZFBL ut_zfbl    

if  exists(select 1 from syscolumns WHERE name ='PY' and id=object_id('V5_DRUGITEM'))     
alter table V5_DRUGITEM alter column PY ut_mc256 null    
if  exists(select 1 from syscolumns WHERE name ='WB' and id=object_id('V5_DRUGITEM'))     
alter table V5_DRUGITEM alter column WB ut_mc256 null    

if not exists(select 1 from syscolumns WHERE name ='OTCBZ' and id=object_id('V5_DRUGITEM'))    
alter table V5_DRUGITEM add OTCBZ ut_bz null      
if not exists(select 1 from syscolumns WHERE name ='ZBYBZ' and id=object_id('V5_DRUGITEM'))    
alter table V5_DRUGITEM add ZBYBZ ut_bz null      

if not exists(select 1 from syscolumns WHERE name ='YBBL' and id=object_id('V5_DRUGITEM'))    
alter table V5_DRUGITEM add YBBL ut_mc256 null  --ҽ������    
if not exists(select 1 from syscolumns WHERE name ='YBSM' and id=object_id('V5_DRUGITEM'))    
alter table V5_DRUGITEM add YBSM ut_mc256 null  --ҽ��˵��    
if not exists(select 1 from syscolumns WHERE name ='GWYPJB' and id=object_id('V5_DRUGITEM'))    
alter table V5_DRUGITEM add GWYPJB ut_bz null  --��ΣҩƷ����    
if not exists(select 1 from syscolumns WHERE name ='GJJBYWBZ' and id=object_id('V5_DRUGITEM'))    
alter table V5_DRUGITEM add GJJBYWBZ ut_bz null  --���һ���ҩ���־    
if not exists(select 1 from syscolumns WHERE name ='JBYWML_SHI' and id=object_id('V5_DRUGITEM'))    
alter table V5_DRUGITEM add JBYWML_SHI ut_bz null  --�л���ҩ���־    
if not exists(select 1 from syscolumns WHERE name ='JBYWML_SHEN' and id=object_id('V5_DRUGITEM'))    
    alter table V5_DRUGITEM add JBYWML_SHEN ut_bz null  --ʡ����ҩ���־    
if not exists(select 1 from syscolumns WHERE name ='FZYYBZ' and id=object_id('V5_DRUGITEM'))    
    alter table V5_DRUGITEM add FZYYBZ ut_bz null  --������ҩ��־  
if not exists(select 1 from syscolumns WHERE name ='YYDM' and id=object_id('V5_DRUGITEM'))    
alter table V5_DRUGITEM add YYDM  ut_dm2 null  --Ժ������    
if not exists(select 1 from syscolumns WHERE name ='GLBS_NAME' and id=object_id('V5_DRUGITEM'))    
alter table V5_DRUGITEM add GLBS_NAME  ut_mc64 null  --�����ʶ����   
if not exists(select 1 from syscolumns WHERE name ='GLBS_ID' and id=object_id('V5_DRUGITEM'))    
alter table V5_DRUGITEM add GLBS_ID  ut_mc16 null  --�����ʶͼƬid  
if not exists(select 1 from syscolumns WHERE name ='ETJSJE' and id=object_id('V5_DRUGITEM'))    
alter table V5_DRUGITEM add ETJSJE  ut_money null  --��ͯ������  
if not exists(select 1 from syscolumns WHERE name ='FYYYBZ' and id=object_id('V5_DRUGITEM'))    
alter table V5_DRUGITEM add FYYYBZ  int null  --������ҩ��־  
if not exists(select 1 from syscolumns WHERE name ='KJHYPBZ' and id=object_id('V5_DRUGITEM'))    
alter table V5_DRUGITEM add KJHYPBZ  ut_bz null  --�����ҩƷ��־  
if not exists(select 1 from syscolumns WHERE name ='KJHYPBZ' and id=object_id('V5_DRUGITEM'))    
alter table V5_DRUGITEM add TMBZ  ut_bz null  --������־  
truncate table V5_DRUGITEM    

insert into V5_DRUGITEM    
(IDM,GG_IDM,LC_IDM,KCSL,YFDM,YFMC,YPDM,YPMC,PY,WB,YPGG,DXMDM,MZDW,MZXS,ZYDW,ZYXS,YKDW,YKXS,    
GGDW,GGXS,ZXDW,PSBZ,TSBZ,YBKZBZ,BXBZ,YLSJ,CJMC,MEMO
,FLDM,FLZFBZ,MZZFBZ,ZYZFBZ,DYDM,KZBZ,DBCYBZ,JXDM,    
JXMC,FLMC,FLDLMC,YPLCMC,YPLCPY,YPLCWB,QFKZBZ,YPBZ,XMLB,LCXMDM,LCXMMC,LCXMDJ,POS,POS_BZ,ZXMDM,BMBZ,    
YJQRBZ,EKDW,EKXS,MZLYBZ,ZYLYBZ,DXMMC,DXM_YPBZ,YPFJ,BQDJBZ,YPGGMC,YPGGPY,YPGGWB,CYFYBZ,ZYZFBL,OTCBZ,ZBYBZ,CGYZBZ,YZGLBZ,GWYPJB,GJJBYWBZ,JBYWML_SHI,JBYWML_SHEN,FZYYBZ,SSHCBZ,YYDM,GLBS_NAME,GLBS_ID,  
ETJSJE,YBBZ_SHENG,YBBZ_SHI,YBBZ_NH,YBBZ_TIELU,FYYYBZ,KJHYPBZ,TMBZ)    
select idm, gg_idm, lc_idm, kcsl, yfdm, yfmc,ypdm, ypmc, py, wb, ypgg,dxmdm,mzdw, mzxs, zydw, zyxs, ykdw, ykxs,    
ggdw,ggxs,zxdw, psbz, tsbz, ybkzbz, bxbz, ylsj, cjmc,substring(rtrim(ltrim(memo)),1,128)  memo
, fldm,flzfbz,mzzfbz,zyzfbz,dydm,kzbz,dbcybz,jxdm,    
jxmc,flmc,fldlmc, yplcmc, yplcpy,yplcwb,0,ypbz,xmlb,lcxmdm, lcxmmc ,lcxmdj,pos,pos_bz,zxmdm, bmbz,    
yjqrbz,ekdw,ekxs,mzlybz,zylybz,dxmmc,isnull(dxmypbz,0),ypfj,bqdjbz,ypggmc,ypggpy,ypggwb,cyfybz,zyzfbl,otcbz,zbybz,cgyzbz,yzglbz,gwypjb,gjjbywbz,sjjbywbz,shenjjbywbz,fzyybz,sshcbz,yydm ,glbs_name,glbs_id,  
etjsje,ybbz_sheng,ybbz_shi,ybbz_nh,ybbz_tielu,fyyybz ,kjhypbz,tmbz  
from #tmpdrugitems    

select a.id as yfdm, a.name as ksmc     
into #tmpyfdm2    
from YY_KSBMK a  with (nolock)    
where 1=2    

select a.cd_idm as idm, a.gg_idm, a.lc_idm, (a.kcsl2 - a.djsl) as kcsl, a.ksdm as yfdm,y.ksmc yfmc,    
convert(int, 0) as jbdyfw,    
convert(varchar(32),c.ypdm) ypdm, c.ypmc, (c.py+rtrim(f.py)) as py, (c.wb+rtrim(f.wb)) as wb,(case when c.islcjsyp=1 then '(��)' else '' end)+c.ypgg ypgg, c.yplh as dxmdm,     
(case when @isyfdw = 1 then a.mzdw else c.mzdw end) as mzdw,     
(case when @isyfdw = 1 then a.mzxs else c.mzxs end) as mzxs,     
(case when @isyfdw = 1 then a.zydw else c.zydw end) as zydw,     
(case when @isyfdw = 1 then a.zyxs else c.zyxs end) as zyxs,     
c.ykdw, c.ykxs, c.ggdw, c.ggxs, c.zxdw, c.psbz, c.tsbz, isnull(c.ybkzbz, 0) ybkzbz, c.bxbz, c.ylsj, c.cjmc, c.memo, c.fldm,     
c.flzfbz, c.zfbz as mzzfbz, c.zyzfbz as zyzfbz, c.dydm, a.kzbz, convert(int, 1-c.tybz) as mzsybz, convert(int, 1-c.tybz) as zysybz,    
c.dbcybz,convert(varchar(5), c.jxdm) jxdm, f.name as flmc, f.fl_mc as fldlmc,     
l.ypmc as yplcmc, l.py as yplcpy, l.wb as yplcwb,     
convert(int, 0) as ypbz, convert(varchar(4), '-1') as xmlb, convert(varchar(32), '0') as lcxmdm,    
convert(int, 0) as pos, convert(varchar(6),'') as pos_bz, convert(money, 0.00) as lcxmdj, convert(varchar(64), '') as lcxmmc,    
convert(varchar(32), '') as zxmdm, convert(int, 0) as bmbz, convert(int, 0) as yjqrbz --������ҽ��ȷ��    
,c.ekdw,c.ekxs,isnull(c.mzlybz,0) mzlybz,isnull(c.ljlybz,0) zylybz ,convert(char(8),'') as lcxmdw,    
CONVERT(varchar(32),'') as jxmc,CONVERT(varchar(32),'') as dxmmc,CONVERT(int,0) as dxmypbz,c.ypfj,c.bqdjbz,j.ypmc as ypggmc,j.py as ypggpy,j.wb as ypggwb,c.isqfkz     
,convert(varchar(2000), '') as kdksdmjh,c.otcbz,c.gwypjb,c.basicdrug_flag as gjjbywbz ,c.jbywml_shi as sjjbywbz,c.sjbywml,q.fzyybz -- add for aorigele 20130411   
,'-1' as yydm ,q.glbs_name,q.glbs_id   ,CONVERT(money,NULL) as etjsje ,q.ybbz_sheng,q.ybbz_shi,q.ybbz_nh,q.ybbz_tielu,q.fyyybz,isnull(c.kjhyp_flag,0) as kjhypbz,q.tmbz      
into #tmpdrugitems2  
from  YF_YFZKC a  with (nolock), #tmpyfdm2 y,YK_YPCDMLK c  with (nolock),YK_YPFLK f  with (nolock), YK_YPLCMLK l  with (nolock),YK_YPGGMLK j with (nolock),YK_YPCDMLKZK q with (nolock)    
where 1=2    
create index idx_idm on #tmpdrugitems2(idm)     



--�������뵥��ҩƷ��־=5    

insert into #tmpdrugitems2(idm, gg_idm, lc_idm, kcsl, yfdm, yfmc,     
ypdm, ypmc, py, wb, ypgg, dxmdm,     
mzdw, mzxs, zydw, zyxs, ykdw, ykxs, ggdw, ggxs, zxdw,     
psbz, tsbz, ybkzbz, bxbz, ylsj, cjmc, memo, fldm,    
flzfbz, mzzfbz, zyzfbz, dydm, kzbz, mzsybz, zysybz,    
flmc, fldlmc, yplcmc, yplcpy, yplcwb,     
ypbz, xmlb, lcxmdm, pos, pos_bz,     
lcxmdj, lcxmmc, zxmdm, bmbz, yjqrbz, dbcybz, jxdm,ekdw,ekxs,mzlybz,zylybz,lcxmdw,ypfj,ypggmc,kdksdmjh,otcbz,gwypjb,gjjbywbz,sjjbywbz,fzyybz,yydm,glbs_name,glbs_id,etjsje,kjhypbz)    

select 0, 0, 0, 999999, '', '',    
a.sqddm, a.name, '', '', '', '',    
'', 1, '', 1, '', 1, '', 1, '',    
0, 0, 0, 0,0, '', '', '',    
0, 0, 0, 0, 0, 0, 1,    
'','','','', '',    
5, 1, '-1', 0, '',    
0, '', '', 0, 0, 0, '','',1,0,0,'',0,'',isnull(a.kdksdmjh,''),'',0,0,0,0,'-1','','' ,0,0   
from TF_JYSQD a left join TF_JYSQDXZ b on (a.lxdm=b.lxdm)     
        where a.yxjl=1     
        AND (    
isnull(a.kdlbjh,'') = ''     
or     
charindex('002',a.kdlbjh)>0    
)    
        order by a.mbsx  

--������뵥��ҩƷ��־=6    

insert into #tmpdrugitems2(idm, gg_idm, lc_idm, kcsl, yfdm, yfmc,     
ypdm, ypmc, py, wb, ypgg, dxmdm,     
mzdw, mzxs, zydw, zyxs, ykdw, ykxs, ggdw, ggxs, zxdw,     
psbz, tsbz, ybkzbz, bxbz, ylsj, cjmc, memo, fldm,    
flzfbz, mzzfbz, zyzfbz, dydm, kzbz, mzsybz, zysybz,    
flmc, fldlmc, yplcmc, yplcpy, yplcwb,     
ypbz, xmlb, lcxmdm, pos, pos_bz,     
lcxmdj, lcxmmc, zxmdm, bmbz, yjqrbz, dbcybz, jxdm,ekdw,ekxs,mzlybz,zylybz,lcxmdw,ypfj,ypggmc,kdksdmjh,otcbz,gwypjb,gjjbywbz,sjjbywbz,fzyybz,yydm,glbs_name,glbs_id,etjsje,kjhypbz)    
select 0, 0, 0, 999999, '', '',    
sqdmbid, sqdmbmc, '','', '', '',    
'', 1, '', 1, '', 1, '', 1, '',    
0, 0, 0, 0,0,'','','',    
0, 0, 0, 0, 0, 0, 1,    
'','', '','', '',    
6, 1, '-1', 0, '',    
0, '', '', 0, 0, 0, '','',1,0,0,'',0,'',isnull(kdksdmjh,''),'',0,0,0,0,'-1','','',0,0    
from CL_Template   with (nolock)  where     
yxjl=1 and     
fmbid>0     
and      
(     
 (isnull(kdlbjh,'')  = '')    
 or     
 (    
charindex('002',kdlbjh)>0    
 )     
)   



--�����շ���Ŀ��dxmypbz    
update #tmpdrugitems2 set dxmmc=b.name,dxmypbz=0    
from #tmpdrugitems2 a, YY_SFDXMK b where a.dxmdm=b.id and a.idm = 0    

--����ҽ���Ĵ���    


delete from CISSVR.CISDB.dbo.CPOE_TEXTORDER    

insert into CISSVR.CISDB.dbo.CPOE_TEXTORDER(XMDM,XMMC,PY,WB,XMDW,XMLB,CGYZBZ)    
select id,name,py,wb,xmdw,xmlb,cgyzbz from  YY_SFXXMK where  yzxm =1 and  sybz =1 and xmdj<=0    

update CISSVR.CISDB.dbo.CPOE_TEXTORDER set XMDW='��'     

insert into CISSVR.CISDB.dbo.CPOE_TEXTORDER(XMDM,XMMC,PY,WB,XMDW,XMLB)    
values ('XXXXX','����ҽ��','wzyz','wzyz','',0)     

if @@error<>0    
begin    
select 'F','��������ʧ�ܣ�'    

return    
end    


delete from CPOE_CIS_DRUGITEM    

DECLARE @sql NVARCHAR (MAX);  

SET @sql = 'insert into CPOE_CIS_DRUGITEM    
(IDM,GG_IDM,LC_IDM,KCSL,YFDM,YFMC,YPDM,YPMC,PY,WB,YPGG,DXMDM,MZDW,MZXS,ZYDW,ZYXS,YKDW,YKXS,    
GGDW,GGXS,ZXDW,PSBZ,TSBZ,YBKZBZ,BXBZ,YLSJ,CJMC,MEMO,FLDM,FLZFBZ,MZZFBZ,ZYZFBZ,DYDM,KZBZ,DBCYBZ,JXDM,    
JXMC,FLMC,FLDLMC,YPLCMC,YPLCPY,YPLCWB,QFKZBZ,YPBZ,XMLB,LCXMDM,LCXMMC,LCXMDJ,POS,POS_BZ,ZXMDM,BMBZ,    
YJQRBZ,EKDW,EKXS,MZLYBZ,ZYLYBZ,DXMMC,DXM_YPBZ,YPFJ,BQDJBZ,YPGGMC,YPGGPY,YPGGWB,CYFYBZ,ZYZFBL,OTCBZ,ZBYBZ,CGYZBZ,YZGLBZ,YBBL,YBSM,GWYPJB,GJJBYWBZ,JBYWML_SHI,JBYWML_SHEN,FZYYBZ,SSHCBZ,YYDM,GLBS_NAME,GLBS_ID,  
ETJSJE,YBBZ_SHENG,YBBZ_SHI,YBBZ_NH,YBBZ_TIELU,FYYYBZ,KJHYPBZ,TMBZ)    
select IDM,GG_IDM,LC_IDM,KCSL,YFDM,YFMC,LTRIM(RTRIM(YPDM)),YPMC,convert(varchar(32),PY) PY,convert(varchar(32),WB)  WB,YPGG,DXMDM,MZDW,MZXS,ZYDW,ZYXS,YKDW,YKXS,    
GGDW,GGXS,ZXDW,PSBZ,TSBZ,YBKZBZ,BXBZ,YLSJ,CJMC,MEMO,FLDM,FLZFBZ,MZZFBZ,ZYZFBZ,DYDM,KZBZ,DBCYBZ,JXDM,    
JXMC,FLMC,FLDLMC,YPLCMC,YPLCPY,YPLCWB,0,YPBZ,XMLB,LCXMDM,LCXMMC,LCXMDJ,POS,POS_BZ,ZXMDM,BMBZ,    
YJQRBZ,EKDW,EKXS,MZLYBZ,ZYLYBZ,DXMMC,DXM_YPBZ,YPFJ,BQDJBZ,YPGGMC,YPGGPY,YPGGWB,1,ZYZFBL,OTCBZ,ZBYBZ,CGYZBZ,YZGLBZ,YBBL,YBSM,GWYPJB,GJJBYWBZ,JBYWML_SHI,JBYWML_SHEN,FZYYBZ,isnull(SSHCBZ,0) ,YYDM,GLBS_NAME,GLBS_ID ,  
ETJSJE,YBBZ_SHENG,YBBZ_SHI,YBBZ_NH,YBBZ_TIELU,FYYYBZ,KJHYPBZ,TMBZ   
from V5_DRUGITEM '  
EXEC(@sql);  


if @@error<>0    
begin    
select 'F','��������ʧ�ܣ�'    

return    
end     

insert into CPOE_CIS_DRUGITEM    
(IDM,GG_IDM,LC_IDM,KCSL,YFDM,YFMC,YPDM,YPMC,PY,WB,YPGG,DXMDM,MZDW,MZXS,ZYDW,ZYXS,YKDW,YKXS,    
GGDW,GGXS,ZXDW,PSBZ,TSBZ,YBKZBZ,BXBZ,YLSJ,CJMC,MEMO,FLDM,FLZFBZ,MZZFBZ,ZYZFBZ,DYDM,KZBZ,DBCYBZ,JXDM,    
JXMC,FLMC,FLDLMC,YPLCMC,YPLCPY,YPLCWB,QFKZBZ,YPBZ,XMLB,LCXMDM,LCXMMC,LCXMDJ,POS,POS_BZ,ZXMDM,BMBZ,    
YJQRBZ,EKDW,EKXS,MZLYBZ,ZYLYBZ,DXMMC,DXM_YPBZ,YPFJ,BQDJBZ,YPGGMC,YPGGPY,YPGGWB,KDKSDMJH,OTCBZ,GWYPJB,GJJBYWBZ,JBYWML_SHI,JBYWML_SHEN,FZYYBZ,SSHCBZ,YYDM,GLBS_NAME,GLBS_ID,  
ETJSJE,YBBZ_SHENG,YBBZ_SHI,YBBZ_NH,YBBZ_TIELU,FYYYBZ,KJHYPBZ,TMBZ)    
select idm, gg_idm, lc_idm, kcsl, yfdm, yfmc,LTRIM(RTRIM(ypdm)), ypmc,convert(varchar(32),py) py,convert(varchar(32),wb) wb, ypgg,dxmdm,mzdw, mzxs, zydw, zyxs, ykdw, ykxs,    
ggdw,ggxs,zxdw, psbz, tsbz, ybkzbz, bxbz, ylsj, cjmc,LEFT(memo,99) memo, fldm,flzfbz,mzzfbz,zyzfbz,dydm,kzbz,dbcybz,jxdm,    
jxmc,flmc,fldlmc, yplcmc, yplcpy,yplcwb,0,ypbz,xmlb,lcxmdm, lcxmmc ,lcxmdj,pos,pos_bz,zxmdm, bmbz,    
yjqrbz,ekdw,ekxs,mzlybz,zylybz,dxmmc,isnull(dxmypbz,0),ypfj,bqdjbz,ypggmc,ypggpy,ypggwb,kdksdmjh,otcbz,gwypjb,gjjbywbz,sjjbywbz,sjbywml,fzyybz,0 ,yydm,glbs_name,glbs_id ,  
etjsje,ybbz_sheng,ybbz_shi,ybbz_nh,ybbz_tielu,fyyybz,kjhypbz,tmbz  
from #tmpdrugitems2    

if @@error<>0    
begin    
select 'F','��������ʧ�ܣ�'    

return    
end    


select a.id into #tid    
from YY_LCSFXMK a join YY_LCSFXMDYK b on a.id=b.lcxmdm    
group by a.id    
having count(1)=1     

update CPOE_CIS_DRUGITEM set LCXMLB=XMLB where LCXMDM='0' or LCXMDM=''     

update A set A.POS=0,A.POS_BZ='',A.YPMC=REPLACE(A.YPMC,'��','��'),A.LCXMLB=A.XMLB    
from CPOE_CIS_DRUGITEM A JOIN #tid X ON A.LCXMDM =X.id    

select LCXMDM,XMLB into #tabxmlb from CPOE_CIS_DRUGITEM where LCXMDM<>'0' and ZXMDM=YPDM    

update a set  a.LCXMLB=b.XMLB from CPOE_CIS_DRUGITEM a,#tabxmlb b where a.LCXMDM=b.LCXMDM    


if exists(select 1 from sysobjects where name = 'TF_JYXM' and xtype = 'U')    
begin    
update a set a.sfxmmc = b.name    
from  TF_JYXM a inner join  YY_SFXXMK b on a.sfxmdm = b.id    
where a.sfxmlb = 0 and ltrim(rtrim(a.sfxmmc)) <> ltrim(rtrim(b.name))    

update a set a.sfxmmc = b.name    
from  TF_JYXM a inner join YY_LCSFXMK b on a.sfxmdm = b.id    
where a.sfxmlb = 1 and ltrim(rtrim(a.sfxmmc)) <> ltrim(rtrim(b.name))    
end    
if exists(select 1 from  sysobjects where name = 'CL_JCXMDYSFK' and xtype = 'U')    
begin    
update a set a.sfxmmc = b.name    
from  CL_JCXMDYSFK a inner join YY_SFXXMK b on a.sfxmdm = b.id    
where a.sfxmlb = 0 and ltrim(rtrim(a.sfxmmc)) <> ltrim(rtrim(b.name))    

update a set a.sfxmmc = b.name    
from  CL_JCXMDYSFK a inner join YY_LCSFXMK b on a.sfxmdm = b.id    
where a.sfxmlb = 1 and ltrim(rtrim(a.sfxmmc)) <> ltrim(rtrim(b.name))    


update a set a.SFXMMC = b.name    
from CISSVR.CISDB.dbo.CPOE_CZYZ_BRJCSQDMX a inner join  YY_SFXXMK b on a.SFXMID = b.id  
where a.SFXMLB = 0 and ltrim(rtrim(a.SFXMMC)) <> ltrim(rtrim(b.name))    

update a set a.SFXMMC = b.name    
from CISSVR.CISDB.dbo.CPOE_CZYZ_BRJCSQDMX a inner join YY_LCSFXMK b on a.SFXMID = b.id    
where a.SFXMLB = 1 and ltrim(rtrim(a.SFXMMC)) <> ltrim(rtrim(b.name))    

end    

select 'T'    
return    










