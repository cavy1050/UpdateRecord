ALTER PROC usp_mz_ys_report  
@patid    ut_xh12,     --����ID        
@hzxm     ut_mc64,     --��������        
@kssj     ut_rq16,                   --��ʼʱ��        
@jssj     ut_rq16,                   --����ʱ��        
@type     ut_mc64,     --LIS, RIS        
@xtbz     ut_bz = 1,        
@qqlb     ut_bz = 0,        
@cxqb     ut_bz = 0,        
@yexh  ut_syxh=-1,        
@repkssj  ut_rq16='',    --���濪ʼʱ��  add 20120628         
@repjssj  ut_rq16='',    --�������ʱ��  add 20120628        
      
@cxfw  ut_mc16 = '1',     --��ѯ��Χ 0��ȫԺ��1�����ң�2������ add by zhengyong 2012.10.26         
@ysdmTemp  VARCHAR(8)='',                   --��ǰ��ҽ������  add by xia 139773        
@ksdmTemp  VARCHAR(8)=''                   --��ǰҽ������        
AS                      --��78192 2010-8-6 15:43:16 4.0��׼��_����ҽ��վ4.5 ���Ի����72475        
/**********        
[�汾��]4.5.0.0.0        
[����ʱ��]2007.07.02        
[����] cll        
[��Ȩ] Copyright ? 2004-2008�Ϻ����˴�-��������ɷ����޹�˾        
[����]        
[����˵��]        
���ز��˵ļ�黯�鱨���б�        
[����˵��]        
@patid ut_xh12, --����ID        
@hzxm   ut_mc64, --��������        
@kssj   ut_rq16, --��ʼʱ��        
@jssj   ut_rq16, --����ʱ��        
@type ut_mc64 --LIS, RIS        
@xtbz ut_bz,  --1���� 2סԺ 11�����ѯ��Ŀ 21סԺ������� 22סԺ�������� 31סԺ���뵥��ѯ        
@qqlb ut_bz = 0 --������� -1 ȡBQ_YS_JCSQ ����ȡYJQQK        
@cxqb  0:��@type��ѯ   1����ѯȫ��������LIS/RIS,סԺϵͳ�ã����ݷ���ʱ�������ˣ�        
@cxfw 0:ȫԺ����ʾ�ò����ڱ�Ժ���п��ҿ��ļ�黯�鵥�ļ����1:���ң�ֻ��ʾ�����ҿ��ļ����鵥���2:���ˣ�ֻ��ʾ���˿��ļ����鵥���        
@ysdmTemp  VARCHAR(8)         
      
[����ֵ]        
      
[�����������]        
�ɹ��������        
[���õ�sp]        
      
[����ʵ��]        
usp_mz_ys_jchybg '48118', 'LIS','1'        
usp_mz_ys_jchybg "1"," "," "," ", "LIS","1"        
**********/        
--**add by winning-ds-cq on 20190321 begin  
set @hzxm=convert(varchar(12),@hzxm) --20200518 by ����� �����뻼����Ϣ�뱨��洢�еĻ�����Ϣ�нض����

DECLARE @SQLSTR varchar(254)=''  
DECLARE @SQLSTR1 varchar(254)=''  
DECLARE @SQLSTR2 varchar(254)=''  
DECLARE @SQLSTR3 varchar(254)=''  
set @SQLSTR='select * into ##VW_MZHJCFK from VW_MZHJCFK'  
set @SQLSTR1='select * into ##SF_BRXXK from SF_BRXXK'  
set @SQLSTR2='select * into ##VW_YJ_REPORT from THIS4_REPORT..VW_YJ_REPORT'  
set @SQLSTR3='select * into ##VW_MZSQD from VW_MZSQD'  
IF(ISNULL('411597','0')<>'0')  
BEGIN  
set @SQLSTR=@SQLSTR+' where patid='+convert(varchar(32),@patid)  
set @SQLSTR1=@SQLSTR1+' where patid='+convert(varchar(32),@patid)  
set @SQLSTR2=@SQLSTR2+' where patid='+convert(varchar(32),@patid)  
set @SQLSTR3=@SQLSTR3+' where patid='+convert(varchar(32),@patid)  
END  
exec(@SQLSTR)  
exec(@SQLSTR1)  
exec(@SQLSTR2)  
exec(@SQLSTR3)  
--**add by winning-ds-cq on 20190321 end  
  
DECLARE @type2 SMALLINT, @config VARCHAR (1)        
DECLARE @yznr VARCHAR (8000), @yznr2 VARCHAR (8000)        
SELECT @yznr = '' --add by yzp for 75946 20100927        
SELECT @yznr2 = ''--add by yzp for 75946 20100927        
declare @repno_old ut_xh12,@repno_new ut_xh12,@yznr_sum varchar(200),@yznr_new varchar(200)        
SELECT @config = config        
FROM YY_CONFIG        
WHERE id = '0113'                                            --add 20070628        
      
IF @cxqb = 1        
SELECT @xtbz = 2        
      
IF @type = 'RIS'        
SELECT @type2 = 0        
ELSE        
SELECT @type2 = 1        
      
IF @xtbz = 11                                                      --�����ѯ��Ŀ        
BEGIN        
SELECT isnull (e.bgdh, 0) bgdh,        
    CONVERT (VARCHAR (10), isnull (e.bglx, " ")) bglx,        
    c.name xmmc,        
    CASE e.bgzt WHEN 1 THEN "�ѷ���" ELSE "δ����" END bgzt,        
    CASE e.txzt WHEN 1 THEN "����" ELSE "δ����" END txzt        
INTO #tmpmzxm        
FROM ##VW_MZHJCFK a (NOLOCK),        
    VW_MZHJCFMXK b (NOLOCK),        
    YY_SFXXMK c (NOLOCK),        
    VW_MZYJXMZTK e (NOLOCK),        
    ##VW_MZSQD n (nolock)        
            
WHERE     a.xh = b.cfxh        
    AND b.lcxmdm = "0"        
    AND b.ypdm = c.id     
    AND a.patid = @patid        
    AND b.xh = e.hjmxxh        
    AND c.id = e.xmdm        
    and ((@cxfw="0" ) or (@cxfw="1" and n.sqks=@ksdmTemp and a.ghxh=n.ghxh ) or (@cxfw="2" and n.czyh=@ysdmTemp and n.sqks=@ksdmTemp and a.ghxh=n.ghxh))        
UNION ALL        
SELECT isnull (e.bgdh, 0) bgdh,        
    CONVERT (VARCHAR (10), isnull (e.bglx, " ")) bglx,        
    c.name xmmc,        
    CASE e.bgzt WHEN 1 THEN "�ѷ���" ELSE "δ����" END bgzt,        
    CASE e.txzt WHEN 1 THEN "����" ELSE "δ����" END txzt        
FROM ##VW_MZHJCFK a (NOLOCK),        
    VW_MZHJCFMXK b (NOLOCK),        
    YY_LCSFXMK c (NOLOCK),        
    VW_MZYJXMZTK e (NOLOCK),        
    ##VW_MZSQD n (nolock)        
            
WHERE     a.xh = b.cfxh        
    AND b.lcxmdm <> "0"        
    AND a.patid = @patid        
    AND b.lcxmdm = c.id        
    AND b.xh = e.hjmxxh        
    AND c.id = e.xmdm        
    and ((@cxfw="0" ) or (@cxfw="1" and n.sqks=@ksdmTemp and a.ghxh=n.ghxh ) or (@cxfw="2" and n.czyh=@ysdmTemp and n.sqks=@ksdmTemp and a.ghxh=n.ghxh))        
UNION ALL        
SELECT isnull (e.bgdh, 0) bgdh,        
    CONVERT (VARCHAR (10), isnull (e.bglx, " ")) bglx,        
    c.name xmmc,        
    CASE e.bgzt WHEN 1 THEN "�ѷ���" ELSE "δ����" END bgzt,        
    CASE e.txzt WHEN 1 THEN "����" ELSE "δ����" END txzt        
FROM VW_MZCFK a (NOLOCK),        
   VW_MZCFMXK b (NOLOCK),         
    YY_SFXXMK c (NOLOCK),        
    VW_MZYJXMZTK e (NOLOCK),        
    ##VW_MZSQD n (nolock)        
WHERE     a.xh = b.cfxh        
    AND b.lcxmdm = "0"        
    AND a.patid = @patid        
    AND b.ypdm = c.id       
    AND a.hjxh NOT IN (SELECT xh        
                         FROM ##VW_MZHJCFK        
                        WHERE patid = @patid)        
    AND b.xh = e.cfmxxh        
    AND c.id = e.xmdm        
    and ((@cxfw="0" ) or (@cxfw="1" and n.sqks=@ksdmTemp and a.ghxh=n.ghxh ) or (@cxfw="2" and n.czyh=@ysdmTemp and n.sqks=@ksdmTemp and a.ghxh=n.ghxh))        
UNION ALL        
SELECT isnull (e.bgdh, 0) bgdh,        
    CONVERT (VARCHAR (10), isnull (e.bglx, " ")) bglx,        
    c.name xmmc,        
    CASE e.bgzt WHEN 1 THEN "�ѷ���" ELSE "δ����" END bgzt,        
    CASE e.txzt WHEN 1 THEN "����" ELSE "δ����" END txzt        
FROM VW_MZCFK a (NOLOCK),        
    VW_MZCFMXK b (NOLOCK),        
    YY_LCSFXMK c (NOLOCK),        
    VW_MZYJXMZTK e (NOLOCK),        
    ##VW_MZSQD n (nolock)        
WHERE     a.xh = b.cfxh        
    AND b.lcxmdm <> "0"        
    AND b.lcxmdm = c.id        
    AND a.patid = @patid        
    AND a.hjxh NOT IN (SELECT xh        
                         FROM ##VW_MZHJCFK        
                        WHERE patid = @patid)        
    AND b.xh = e.cfmxxh        
    AND c.id = e.xmdm        
    and ((@cxfw="0" ) or (@cxfw="1" and n.sqks=@ksdmTemp and a.ghxh=n.ghxh ) or (@cxfw="2" and n.czyh=@ysdmTemp and n.sqks=@ksdmTemp and a.ghxh=n.ghxh))        
ORDER BY bgdh         
      
      
SELECT a.*,        
    b.xh AS classxh,        
    b.qylb,        
    b.dyfs,        
    b.IP,        
    b.htmlfile,        
    b.company        
FROM #tmpmzxm a left join SF_YS_REPORT_CLASS b on a.bglx = b.id        
ORDER BY a.bgdh         
  
drop table ##VW_MZHJCFK  
drop table ##SF_BRXXK  
drop table ##VW_YJ_REPORT  
drop table ##VW_MZSQD      
RETURN        
      
END        
ELSE        
IF @xtbz = 1        
BEGIN        
IF @config = '1'                      --��ģʽ ��Ҫ�м����ݿ�THIS4_REPORT��֧��        
BEGIN        
if @patid<>'0'        
begin        
SELECT distinct r.xh,        
ltrim (rtrim (CONVERT (VARCHAR (32), r.repno)))        
repno,        
r.replb,        
r.cardno "����",        
s.sfzh "���֤��",        
r.hzxm "����",        
r.sex "�Ա�",        
r.age "����",        
r.replbmc "���浥���",        
r.jcksmc "������",         
CASE r.isly        
WHEN 0 THEN "�±���"        
WHEN 1 THEN "�Ѳ鿴"        
ELSE "δ֪"        
END        
"�鿴״̬",        
r.blh, -- case r.xtbz when "0" then r.blh when "1" then r.syxh else " " end        
r.fph "��Ʊ��",        
r.sjrq "�ͼ�����",                     --add 20120628        
c.xh AS classxh,        
c.qylb,        
c.dyfs,        
c.IP,        
c.htmlfile,        
r.pubtime "��������",        
r.sjksmc "�ͼ����",    --Add by zhengyong 2013.1.15 By ����150767        
c.company,        
r.jcbw "��鲿λ",c.dylx         
FROM SF_YS_REPORT r left join ##SF_BRXXK s on r.patid=s.patid ,         
SF_YS_REPORT_CLASS c,        
##VW_MZSQD n (nolock)        
                        
WHERE   r.replb = c.id        
AND r.syxh = convert(varchar(12),@patid) --ҽ������patidд��syxh��        
AND (@hzxm = '' OR r.hzxm = @hzxm)        
AND (@kssj = '' OR r.sjrq BETWEEN @kssj AND @jssj)        
AND (@repkssj = '' OR r.reprq BETWEEN @repkssj AND @repjssj) -- add 20120628         
AND c.type = @type        
AND r.xtbz = "0"   --xtbz char(1) null, --'0'���'1'����        
and ((@cxfw="0" ) or (@cxfw="1" and n.sqks=@ksdmTemp and r.patid=n.patid ) or (@cxfw="2" and n.czyh=@ysdmTemp and n.sqks=@ksdmTemp and r.patid=n.patid ))        
UNION ALL        
SELECT distinct r.xh,        
r.repno repno,        
r.replb,        
r.cardno "����",        
s.sfzh "���֤��",               
r.hzxm "����",        
r.sex "�Ա�",        
r.age "����",        
r.replbmc "���浥���",        
r.jcksmc "������",         
CASE r.isly        
WHEN 0 THEN "�±���"        
WHEN 1 THEN "�Ѳ鿴"        
ELSE "δ֪"        
END        
"�鿴״̬",        
r.blh, -- case r.xtbz when "0" then r.blh when "1" then r.syxh else " " end        
r.fph "��Ʊ��",        
r.sjrq "�ͼ�����",                     --add 20120628        
c.xh AS classxh,        
c.qylb,        
c.dyfs,        
c.IP,        
c.htmlfile,        
r.pubtime "��������",        
r.sjksmc "�ͼ����",    --Add by zhengyong 2013.1.15 By ����150767        
c.company,        
r.jcbw "��鲿λ",c.dylx         
FROM ##VW_YJ_REPORT r left join ##SF_BRXXK s on r.patid=s.patid ,        
THIS4_REPORT..YJ_REPORT_CLASS c,        
##VW_MZSQD n (nolock)        
                         
WHERE r.replb = c.id        
AND r.bsxh = convert(varchar(12),@patid) --ҽ������patidд��syxh��        
AND (@hzxm = '' OR r.hzxm = @hzxm)        
AND (@kssj = '' OR r.sjrq BETWEEN @kssj AND @jssj)        
AND (@repkssj = '' OR r.reprq BETWEEN @repkssj AND @repjssj) -- add 20120628         
AND c.type = @type2        
AND r.bgbz = 0        
AND r.xtbz = 0        
and ((@cxfw="0" ) or (@cxfw="1" and n.sqks=@ksdmTemp and r.patid=n.patid ) or (@cxfw="2" and n.czyh=@ysdmTemp and n.sqks=@ksdmTemp and r.patid=n.patid ))        
end        
else        
begin        
SELECT distinct r.xh,        
ltrim (rtrim (CONVERT (VARCHAR (32), r.repno)))        
repno,        
r.replb,        
r.cardno "����",        
s.sfzh "���֤��",               
r.hzxm "����",        
r.sex "�Ա�",        
r.age "����",        
r.replbmc "���浥���",        
r.jcksmc "������",         
CASE r.isly        
WHEN 0 THEN "�±���"        
WHEN 1 THEN "�Ѳ鿴"        
ELSE "δ֪"        
END        
"�鿴״̬",        
r.blh, -- case r.xtbz when "0" then r.blh when "1" then r.syxh else " " end        
r.fph "��Ʊ��",        
r.sjrq "�ͼ�����",                     --add 20120628        
c.xh AS classxh,        
c.qylb,        
c.dyfs,        
c.IP,        
c.htmlfile,        
r.pubtime "��������",        
r.sjksmc "�ͼ����",    --Add by zhengyong 2013.1.15 By ����150767        
c.company,        
r.jcbw "��鲿λ",c.dylx         
FROM SF_YS_REPORT r left join ##SF_BRXXK s on r.patid=s.patid ,        
SF_YS_REPORT_CLASS c,        
##VW_MZSQD n (nolock)        
                         
WHERE r.replb = c.id        
AND (@patid = '0' OR r.syxh = convert(varchar(12),@patid)) --ҽ������patidд��syxh��        
AND (@hzxm = '' OR r.hzxm = @hzxm)        
AND (@kssj = '' OR r.sjrq BETWEEN @kssj AND @jssj)        
AND (@repkssj = '' OR r.reprq BETWEEN @repkssj AND @repjssj) -- add 20120628         
AND c.type = @type        
AND r.xtbz = "0"   --xtbz char(1) null, --'0'���'1'����        
and ((@cxfw="0" ) or (@cxfw="1" and n.sqks=@ksdmTemp and r.patid=n.patid ) or (@cxfw="2" and n.czyh=@ysdmTemp and n.sqks=@ksdmTemp and r.patid=n.patid ))        
UNION ALL        
SELECT distinct r.xh,        
r.repno repno,        
r.replb,        
r.cardno "����",        
s.sfzh "���֤��",               
r.hzxm "����",        
r.sex "�Ա�",        
r.age "����",        
r.replbmc "���浥���",        
r.jcksmc "������",         
CASE r.isly        
WHEN 0 THEN "�±���"        
WHEN 1 THEN "�Ѳ鿴"        
ELSE "δ֪"        
END        
"�鿴״̬",        
r.blh, -- case r.xtbz when "0" then r.blh when "1" then r.syxh else " " end        
r.fph "��Ʊ��",        
r.sjrq "�ͼ�����",                     --add 20120628        
c.xh AS classxh,        
c.qylb,        
c.dyfs,        
c.IP,        
c.htmlfile,        
r.pubtime "��������",        
r.sjksmc "�ͼ����",    --Add by zhengyong 2013.1.15 By ����150767        
c.company,        
r.jcbw "��鲿λ",c.dylx         
FROM ##VW_YJ_REPORT r left join ##SF_BRXXK s on r.patid=s.patid ,         
THIS4_REPORT..YJ_REPORT_CLASS c,        
##VW_MZSQD n (nolock)        
                
WHERE   r.replb = c.id        
AND (@patid = '0' OR r.bsxh = convert(varchar(12),@patid)) --ҽ������patidд��syxh��        
AND (@hzxm = '' OR r.hzxm = @hzxm)        
AND (@kssj = '' OR r.sjrq BETWEEN @kssj AND @jssj)        
AND (@repkssj = '' OR r.reprq BETWEEN @repkssj AND @repjssj) -- add 20120628         
AND c.type = @type2        
AND r.bgbz = 0        
AND r.xtbz = 0        
and ((@cxfw="0" ) or (@cxfw="1" and n.sqks=@ksdmTemp and r.patid=n.patid ) or (@cxfw="2" and n.czyh=@ysdmTemp and n.sqks=@ksdmTemp and r.patid=n.patid ))           
end        
END        
ELSE        
BEGIN        
if @patid<>'0'        
begin        
SELECT distinct r.xh,        
ltrim (rtrim (CONVERT (VARCHAR (32), r.repno)))        
repno,        
r.replb,        
r.cardno "����",        
s.sfzh "���֤��",               
r.hzxm "����",        
r.sex "�Ա�",        
r.age "����",        
r.replbmc "���浥���",        
r.jcksmc "������",         
CASE r.isly        
WHEN 0 THEN "�±���"        
WHEN 1 THEN "�Ѳ鿴"        
ELSE "δ֪"        
END        
"�鿴״̬",        
r.blh, -- case r.xtbz when "0" then r.blh when "1" then r.syxh else " " end        
r.fph "��Ʊ��",        
r.sjrq "�ͼ�����",                     --add 20120628        
c.xh AS classxh,        
c.qylb,        
c.dyfs,        
c.IP,        
c.htmlfile,        
r.pubtime "��������",        
r.sjksmc "�ͼ����",    --Add by zhengyong 2013.1.15 By ����150767        
c.company,        
r.jcbw "��鲿λ",c.dylx         
FROM SF_YS_REPORT r left join ##SF_BRXXK s on r.patid=s.patid ,         
SF_YS_REPORT_CLASS c,        
##VW_MZSQD n (nolock)        
                         
WHERE   r.replb = c.id        
AND r.syxh = convert(varchar(12),@patid) --ҽ������patidд��syxh��        
AND (@hzxm = '' OR r.hzxm = @hzxm)        
AND (@kssj = '' OR r.sjrq BETWEEN @kssj AND @jssj)        
AND (@repkssj = '' OR r.reprq BETWEEN @repkssj AND @repjssj) -- add 20120628         
AND c.type = @type        
AND r.xtbz = "0"   --xtbz char(1) null, --'0'���'1'����        
and ((@cxfw="0" ) or (@cxfw="1" and n.sqks=@ksdmTemp and r.patid=n.patid ) or (@cxfw="2" and n.czyh=@ysdmTemp and n.sqks=@ksdmTemp and r.patid=n.patid ))        
end        
else         
begin        
SELECT distinct r.xh,        
ltrim (rtrim (CONVERT (VARCHAR (32), r.repno)))        
repno,        
r.replb,        
r.cardno "����",        
s.sfzh "���֤��",               
r.hzxm "����",        
r.sex "�Ա�",        
r.age "����",        
r.replbmc "���浥���",        
r.jcksmc "������",         
CASE r.isly        
WHEN 0 THEN "�±���"        
WHEN 1 THEN "�Ѳ鿴"        
ELSE "δ֪"        
END        
"�鿴״̬",        
r.blh, -- case r.xtbz when "0" then r.blh when "1" then r.syxh else " " end        
r.fph "��Ʊ��",        
r.sjrq "�ͼ�����",                     --add 20120628        
c.xh AS classxh,        
c.qylb,        
c.dyfs,        
c.IP,        
c.htmlfile,        
r.pubtime "��������",        
r.sjksmc "�ͼ����",    --Add by zhengyong 2013.1.15 By ����150767        
c.company,        
r.jcbw "��鲿λ",c.dylx         
FROM SF_YS_REPORT r left join ##SF_BRXXK s on r.patid=s.patid ,         
SF_YS_REPORT_CLASS c,        
##VW_MZSQD n (nolock)        
                         
WHERE   r.replb = c.id        
AND (@patid = '0' OR r.syxh = convert(varchar(12),@patid)) --ҽ������patidд��syxh��        
AND (@hzxm = '' OR r.hzxm = @hzxm)        
AND (@kssj = '' OR r.sjrq BETWEEN @kssj AND @jssj)        
AND (@repkssj = '' OR r.reprq BETWEEN @repkssj AND @repjssj) -- add 20120628        
AND c.type = @type        
AND r.xtbz = "0"   --xtbz char(1) null, --'0'���'1'����        
and ((@cxfw="0" ) or (@cxfw="1" and n.sqks=@ksdmTemp and r.patid=n.patid ) or (@cxfw="2" and n.czyh=@ysdmTemp and n.sqks=@ksdmTemp and r.patid=n.patid ))        
      
end        
END        
  
drop table ##VW_MZHJCFK  
drop table ##SF_BRXXK  
drop table ##VW_YJ_REPORT  
drop table ##VW_MZSQD     
RETURN        
END        
ELSE        
IF @xtbz = 2       --סԺ��ѯ��Ŀ        
BEGIN        
   create table #temprepnr_org            
   ( xh ut_xh12,            
       yznr varchar(3000)            
    )            
      
create table #temprepnr        
( xh ut_xh12,        
  yznr varchar(3000)        
)        
   IF @config = '1'                   --��ģʽ ��Ҫ�м����ݿ�THIS4_REPORT��֧��        
      BEGIN        
      
       SELECT blh,        
                cardno,        
                hzxm,        
                sex,        
                ltrim (rtrim (CONVERT (VARCHAR (32), repno)))        
                   repno,        
                replb,        
                c.type AS sbglb,        
                isnull (r.pubtime, '') AS bgfbsj,        
                sjrq,        
                replbmc,        
                CASE isnull (r.wjbz, 2)        
                   WHEN 1 THEN 'Σ������'        
                   ELSE ''        
                END        
                   wjbz,        
                reprq,        
                jcbw,        
                jcksmc,        
                c.xh AS classxh,        
                c.qylb,        
                c.dyfs,        
                c.IP,        
                c.htmlfile,        
                c.company,        
                0 AS tabtype,        
                r.xh repxh,        
                r.bgpjnr,        
                r.bgpjysdm,        
                r.bgpjsj,        
                c.id,        
                isnull(r.dybz,0) dybz,isnull(c.dylx,0) dylx         
                into #tempyznr2        
           FROM SF_YS_REPORT r (NOLOCK), SF_YS_REPORT_CLASS c        
          WHERE syxh = @patid AND r.replb = c.id        
                AND ( (@cxqb = 0        
                       AND (c.type = @type        
                            OR (@type = "LIS" AND c.type = "MIS")))        
                     OR (@cxqb = 1        
                         AND (   c.type = "RIS"        
                              OR c.type = "MIS"        
                              OR c.type = "LIS")))        
                AND xtbz = "1"        
                AND (ltrim (rtrim (@kssj)) = ''        
                     OR r.reprq BETWEEN ltrim (rtrim (@kssj))        
                                    AND ltrim (rtrim (@jssj)))        
AND (isnull(r.yexh,0)=@yexh or @yexh=-1)        
--and z.sqks=r.sjksdm        
--and ((@cxfw="0") or (@cxfw="1" and z.sqks=@ksdmTemp) or (@cxfw="2" and z.czyh=@ysdmTemp and z.sqks=@ksdmTemp))        
         UNION ALL        
         SELECT isnull (r.blh, 0) blh,        
                isnull (r.cardno, '') cardno,        
                isnull (r.hzxm, '') hzxm,        
                isnull (r.sex, '') sex,        
                isnull (r.repno, '') repno,        
                isnull (replb, '') replb,        
                CASE c.type WHEN 0 THEN 'RIS' ELSE 'LIS' END        
                   AS sbglb,        
                isnull (r.pubtime, '') AS bgfbsj,        
                isnull (sjrq, '') sjrq,        
                replbmc,        
                CASE isnull (r.wjbz, 2)        
                   WHEN 1 THEN 'Σ������'        
                   ELSE ''        
                END        
                   wjbz,        
                reprq,        
                jcbw,        
                jcksmc,        
                c.xh AS classxh,        
                c.qylb,        
                c.dyfs,        
                c.IP,        
                c.htmlfile,        
                c.company,        
                1 AS tabtype,        
                r.xh repxh,        
                r.bgpjnr,        
                r.bgpjysdm,        
                r.bgpjsj,        
c.id,        
               isnull(r.dybz,0) dybz,isnull(c.dylx,0) dylx         
           FROM ##VW_YJ_REPORT r (NOLOCK),        
                THIS4_REPORT..YJ_REPORT_CLASS c,ZY_BRSYK a(nolock)        
                --##VW_MZSQD n (nolock),        
--SF_YS_YSKSDY y(nolock)        
          WHERE bsxh = @patid AND r.replb = c.id and r.blh=a.blh        
                AND ( (@cxqb = 0 AND c.type = @type2)        
                     OR (@cxqb = 1))        
                AND xtbz = 1        
                AND r.bgbz = 0        
                AND (ltrim (rtrim (@kssj)) = ''        
                     OR r.reprq BETWEEN ltrim (rtrim (@kssj))        
                                    AND ltrim (rtrim (@jssj)))        
AND (isnull(r.yexh,0)=@yexh or @yexh=-1)        
      
--and ((@cxfw="0") or (@cxfw="1" and n.sqks=@ksdmTemp) or (@cxfw="2" and n.czyh=@ysdmTemp and n.sqks=@ksdmTemp))        
--add by zzk begin        
insert into    #temprepnr_org        
select e.repxh,a.yznr        
FROM BQ_LSYZK a,             
##VW_YJ_REPORT b,             
VW_YJQQK c,            
--BQ_YJXMZTK d,            
#tempyznr2 e        
--YY_KSBMK m (nolock),            
--       ##VW_MZSQD n (nolock)            
WHERE     a.xh = c.yzxh  AND a.syxh =@patid          
--AND d.qqxh=c.xh          
AND c.syxh =@patid        
--AND d.bgdh=b.repno  AND d.bgzt=1          
AND b.xtbz = '1'            
and b.xh=e.repxh            
--     and ((@cxfw=0) or (@cxfw=1 and a.ksdm=n.sqks) or (@cxfw=2 and a.ysdm=n.czyh))            
      
declare cur_yznr cursor for         
select xh,yznr from #temprepnr_org order by xh        
open cur_yznr            
--declare @repno_old ut_xh12,@repno_new ut_xh12,@yznr_sum varchar(200),@yznr_new varchar(200)           
select @repno_new=-1,@yznr_sum=''        
      
fetch next from cur_yznr into @repno_new,@yznr_new            
select @repno_old=@repno_new        
while (@@fetch_status =0 )            
begin           
if @repno_old=@repno_new        
begin          
 if @yznr_sum<>''        
select @yznr_sum=@yznr_sum+'��'+@yznr_new            
else          
select @yznr_sum=@yznr_new            
end else begin        
insert into #temprepnr values(@repno_old,@yznr_sum)                
select @yznr_sum=''        
select @repno_old=@repno_new        
end        
      
fetch next from cur_yznr into @repno_new,@yznr_new            
end            
close cur_yznr         
deallocate cur_yznr           
if @repno_old<>-1 --�������һ��repno����        
begin        
insert into #temprepnr values(@repno_old,@yznr_sum)                
end        
--add by zzk end        
select 0 selected,a.*,b.yznr yznr from #tempyznr2 a,#temprepnr b where a.repxh=b.xh         
      
      END        
   ELSE        
      BEGIN        
               
         SELECT blh,   
                cardno,        
                hzxm,        
                sex,        
                ltrim (rtrim (CONVERT (VARCHAR (32), repno)))        
                   repno,        
                replb,        
                c.type AS sbglb,        
                isnull (r.pubtime, '') AS bgfbsj,        
                sjrq,        
                replbmc,        
                CASE isnull (r.wjbz, 2)        
                   WHEN 1 THEN 'Σ������'        
                   ELSE ''        
                END        
                   wjbz,        
                reprq,        
                jcbw,        
                jcksmc,        
                c.xh AS classxh,        
                c.qylb,        
                c.dyfs,        
                c.IP,        
                c.htmlfile,        
                c.company,        
                0 AS tabtype,        
              r.xh repxh,        
                r.bgpjnr,        
                r.bgpjysdm,        
                r.bgpjsj,        
                c.id,        
                isnull(r.dybz,0) dybz,isnull(c.dylx,0) dylx         
                        
into #tempyznr         
           FROM SF_YS_REPORT r (NOLOCK), SF_YS_REPORT_CLASS c        
          WHERE syxh = @patid AND r.replb = c.id        
                AND ( (@cxqb = 0        
           AND (c.type = @type        
                            OR (@type = "LIS" AND c.type = "MIS")))        
                     OR (@cxqb = 1        
                         AND (   c.type = "RIS"        
                              OR c.type = "MIS"        
                              OR c.type = "LIS")))        
                AND xtbz = "1"        
                AND (ltrim (rtrim (@kssj)) = ''        
                     OR r.reprq BETWEEN ltrim (rtrim (@kssj))        
                                    AND ltrim (rtrim (@jssj)))        
AND (isnull(r.yexh,0)=@yexh or @yexh=-1)        
--and z.sqks=r.sjksdm        
--and ((@cxfw="0") or (@cxfw="1" and z.sqks=@ksdmTemp) or (@cxfw="2" and z.czyh=@ysdmTemp and z.sqks=@ksdmTemp))        
--add by zzk begin        
insert into    #temprepnr_org        
select e.repxh,a.yznr        
FROM BQ_LSYZK a,             
SF_YS_REPORT b,             
VW_YJQQK c,            
--BQ_YJXMZTK d,            
#tempyznr e        
--YY_KSBMK m (nolock),            
--       ##VW_MZSQD n (nolock)            
WHERE     a.xh = c.yzxh  AND a.syxh =@patid          
--AND d.qqxh=c.xh          
AND c.syxh =@patid        
--AND d.bgdh=b.repno  AND d.bgzt=1          
AND b.xtbz = '1'            
and b.xh=e.repxh            
--     and ((@cxfw=0) or (@cxfw=1 and a.ksdm=n.sqks) or (@cxfw=2 and a.ysdm=n.czyh))            
      
declare cur_yznr1 cursor for         
select xh,yznr from #temprepnr_org order by xh        
open cur_yznr1            
--declare @repno_old ut_xh12,@repno_new ut_xh12,@yznr_sum varchar(200),@yznr_new varchar(200)           
select @repno_new=-1,@yznr_sum=''        
      
fetch next from cur_yznr1 into @repno_new,@yznr_new            
select @repno_old=@repno_new        
while (@@fetch_status =0 )            
begin           
if @repno_old=@repno_new        
begin          
 if @yznr_sum<>''        
select @yznr_sum=@yznr_sum+'��'+@yznr_new            
else          
select @yznr_sum=@yznr_new            
end else begin        
insert into #temprepnr values(@repno_old,@yznr_sum)                
select @yznr_sum=''        
select @repno_old=@repno_new        
end        
      
fetch next from cur_yznr1 into @repno_new,@yznr_new            
end            
close cur_yznr1        
deallocate cur_yznr1            
if @repno_old<>-1 --�������һ��repno����        
begin        
insert into #temprepnr values(@repno_old,@yznr_sum)                
end        
--add by zzk end        
select 0 selected,a.*,b.yznr yznr from #tempyznr a,#temprepnr b where a.repxh=b.xh            
      
      END        
      
drop table ##VW_MZHJCFK  
drop table ##SF_BRXXK  
drop table ##VW_YJ_REPORT  
drop table ##VW_MZSQD  
RETURN        
END        
ELSE        
IF @xtbz = 21        
   BEGIN        
      IF @qqlb = -1        
         SELECT   substring (b.sqrq, 1, 4)        
                + "-"        
                + substring (b.sqrq, 5, 2)        
                + "-"        
                + substring (b.sqrq, 7, 2)        
                + " "        
                + substring (b.sqrq, 9, 5)        
                   qqrq,        
                b.xmdm,        
                b.xmmc,        
                CONVERT (NUMERIC (10, 2), b.xmdj) jcf,        
                b.qqxh,        
                b.xh sqxh,        
                b.xmsl,        
                b.xmdj,        
                b.xmdw,        
                "�Ѵ�" jlzt,        
                e.bgdh "���浥��",        
                e.bglx "��������", --c.bgzt "����״̬",c.txzt "ͼ��״̬"        
                CASE        
                   WHEN e.bgzt = 1 THEN "�ѷ���"        
                   ELSE "δ����"        
                END        
                   "����״̬",        
                CASE        
                   WHEN e.txzt = 1 THEN "�ѷ���"        
                   ELSE "δ����"        
                END        
                   "ͼ��״̬"        
           FROM BQ_YS_JCSQ b (NOLOCK),         
VW_BQYJXMZTK e (NOLOCK)        
--SF_YS_YSKSDY k(nolock)        
      
      
          WHERE     b.syxh = @patid        
          AND b.qqxh = e.qqxh        
                AND b.xmdm = e.xmdm        
                --and b.sqys=k.ysdm        
             --and ((@cxfw="0") or (@cxfw="1" and k.ksdm=@ksdmTemp) or (@cxfw="2" and b.sqys=@ysdmTemp and k.ksdm=@ksdmTemp))        
         ORDER BY qqrq        
      ELSE        
         SELECT   substring (a.qqrq, 1, 4)        
                + "-"        
                + substring (a.qqrq, 5, 2)        
                + "-"        
                + substring (a.qqrq, 7, 2)        
                + " "        
                + substring (a.qqrq, 9, 5)        
                   qqrq,        
                a.xmdm,        
                a.xmmc,        
                CONVERT (NUMERIC (10, 2), a.xmdj) jcf,        
                a.xh qqxh,        
                0 sqxh,        
                a.xmsl,        
                a.xmdj,        
                a.xmdw,        
                CASE a.jlzt        
                   WHEN 0 THEN "¼��"        
                   WHEN 1 THEN "ȷ��"        
                   WHEN 2 THEN "�ܾ�"        
                END        
                   jlzt,        
                e.bgdh "���浥��",        
                e.bglx "��������",        
                CASE        
                   WHEN e.bgzt = 1 THEN "�ѷ���"        
                   ELSE "δ����"        
                END        
                   "����״̬",        
                CASE        
                   WHEN e.txzt = 1 THEN "�ѷ���"        
                   ELSE "δ����"        
                END        
                   "ͼ��״̬",        
                c.xh AS classxh,        
                c.qylb,        
                c.dyfs,        
                c.IP,        
                c.htmlfile,        
                c.company        
           FROM BQ_YJQQK a (NOLOCK) inner join         
                --SF_YS_REPORT_CLASS c,        
                VW_BQYJXMZTK e (NOLOCK) on a.xh = e.qqxh AND  a.xmdm = e.xmdm        
                left join SF_YS_REPORT_CLASS c on a.bglx = c.id        
                --SF_YS_YSKSDY y(nolock)        
          WHERE     a.syxh = @patid        
                AND a.jlzt IN (0, 1, 2)        
                AND a.qqlb = @qqlb        
                AND a.xh NOT IN (SELECT qqxh        
                     FROM BQ_YS_JCSQ b (NOLOCK)        
                                  WHERE a.syxh = b.syxh)        
                --AND a.bglx *= c.id        
                --AND a.xh = e.qqxh        
                --AND a.xmdm = e.xmdm        
                --and a.ksdm=y.ksdm        
                --and ((@cxfw="0") or (@cxfw="1" and a.ksdm=@ksdmTemp) or (@cxfw="2" and y.ysdm=@ysdmTemp and a.ksdm=@ksdmTemp))        
         ORDER BY qqrq        
      
drop table ##VW_MZHJCFK  
drop table ##SF_BRXXK  
drop table ##VW_YJ_REPORT  
drop table ##VW_MZSQD  
RETURN        
   END        
ELSE        
   IF @xtbz = 22        
      BEGIN        
         IF @qqlb = -1        
            SELECT   substring (b.sqrq, 1, 4)        
+ "-"        
                   + substring (b.sqrq, 5, 2)        
                   + "-"        
                   + substring (b.sqrq, 7, 2)        
                   + " "        
                   + substring (b.sqrq, 9, 5)        
                      qqrq,        
                   b.xmdm,        
                   b.xmmc,        
                   CONVERT (NUMERIC (10, 2), b.xmdj) jcf,        
                   b.qqxh,        
                   b.xh sqxh,        
                   b.xmsl,        
                   b.xmdj,        
                   b.xmdw,        
                   b.bbdm,        
                   b.bbmc,        
                   c.name sqys,        
                   "�Ѵ�" jlzt,        
                   e.bgdh "���浥��",        
                   e.bglx "��������",        
                   CASE        
                      WHEN e.bgzt = 1 THEN "�ѷ���"        
                      ELSE "δ����"        
                   END        
                      "����״̬",        
           CASE        
                      WHEN e.txzt = 1 THEN "�ѷ���"        
                      ELSE "δ����"        
                   END        
                      "ͼ��״̬"        
              FROM BQ_YS_HYSQ b (NOLOCK),        
                   czryk c (NOLOCK),        
                   VW_BQYJXMZTK e (NOLOCK)        
                           
                           
             WHERE     b.syxh = @patid        
                   AND b.sqys = c.id        
                   AND b.qqxh = e.qqxh        
                   AND b.xmdm = e.xmdm        
                           
                   --and ((@cxfw="0") or (@cxfw="1" and c.ks_id=@ksdmTemp) or (@cxfw="2" and b.sqys=@ysdmTemp and c.ks_id=@ksdmTemp))        
            ORDER BY qqrq        
         ELSE        
            SELECT   substring (a.qqrq, 1, 4)        
                   + "-"        
                   + substring (a.qqrq, 5, 2)        
                   + "-"        
                   + substring (a.qqrq, 7, 2)        
                   + " "        
                   + substring (a.qqrq, 9, 5)        
                      qqrq,        
                   a.xmdm,        
                   a.xmmc,        
                   CONVERT (NUMERIC (10, 2), a.xmdj) jcf,        
                   a.xh qqxh,        
                   0 sqxh,        
                   a.xmsl,        
                   a.xmdj,        
                   a.xmdw,        
                   "            " bbdm,        
                   "                               " bbmc,        
                   "            " sqys,        
                   CASE a.jlzt        
                      WHEN 0 THEN "¼��"        
                      WHEN 1 THEN "ȷ��"        
                      WHEN 2 THEN "�ܾ�"        
                   END        
                      jlzt,        
                   e.bgdh "���浥��",        
                   e.bglx "��������",        
                   CASE        
                      WHEN e.bgzt = 1 THEN "�ѷ���"        
                      ELSE "δ����"        
                   END        
              "����״̬",        
                   CASE        
                      WHEN e.txzt = 1 THEN "�ѷ���"        
                      ELSE "δ����"        
                   END        
                      "ͼ��״̬",        
                   c.xh AS classxh,        
                   c.qylb,        
                   c.dyfs,        
                   c.IP,        
                   c.htmlfile,        
                   c.company        
              FROM BQ_YJQQK a (NOLOCK)        
                   --SF_YS_REPORT_CLASS c,        
                   inner join VW_BQYJXMZTK e (NOLOCK) on a.xh = e.qqxh and a.xmdm = e.xmdm        
                   left join SF_YS_REPORT_CLASS c on a.bglx = c.id        
                   --BQ_YS_HYSQ h(nolock),        
                   --SF_YS_YSKSDY k(nolock)        
                           
             WHERE     a.syxh = @patid        
                   AND a.jlzt IN (0, 1, 2)        
                   AND a.qqlb = @qqlb        
                   AND a.xh NOT IN (SELECT qqxh        
                                      FROM BQ_YS_HYSQ b (NOLOCK)        
                                     WHERE a.syxh = b.syxh)        
                  -- AND a.bglx *= c.id        
                  -- AND a.xh = e.qqxh        
                   --AND a.xmdm = e.xmdm        
                   --and a.syxh=h.syxh        
                   --and h.sqys=k.ysdm        
                   --and ((@cxfw="0") or (@cxfw="1" and k.ksdm=@ksdmTemp) or (@cxfw="2" and h.sqys=@ysdmTemp and k.ksdm=@ksdmTemp))        
            ORDER BY qqrq        
      
drop table ##VW_MZHJCFK  
drop table ##SF_BRXXK  
drop table ##VW_YJ_REPORT  
drop table ##VW_MZSQD  
RETURN        
      END        
   ELSE        
      IF @xtbz = 31                                        --���뵥��ѯ        
         BEGIN        
            SELECT CONVERT (BIT, 0) AS choose,        
                   a.xh,        
          a.mbxh,        
                   a.lrrq,        
                   b.name mbmc,        
                   b.caption,        
                   c.name sqks,        
                   d.name zxks,        
                   a.qrbz,        
                   '2008033100:00:00' yysj,        
                   syxh,        
                   a.jlzt        
              INTO #temp        
              FROM VW_ZYSQD a (NOLOCK) inner join          
                   YJ_SQDMBK b (NOLOCK)on a.mbxh = b.xh and a.mbxh = b.xh        
                   inner join          
YY_KSBMK c (NOLOCK) on  a.sqks =c.id        
left join YY_KSBMK d (NOLOCK) on a.zxks = d.id        
                 --  YY_KSBMK d (NOLOCK)        
                           
                           
             WHERE             
                   a.jlzt = 0        
                  -- AND a.sqks =c.id        
                  -- AND a.zxks *= d.id        
                   AND syxh = @patid        
                   --and ((@cxfw="0") or (@cxfw="1" and a.sqks=@ksdmTemp) or (@cxfw="2" and a.czyh=@ysdmTemp and a.sqks=@ksdmTemp))        
      
            UPDATE #temp        
               SET yysj = ''        
      
            UPDATE #temp        
               SET yysj = isnull (b.aprq, '')        
              FROM #temp a,        
                   BQ_YJQQK b (NOLOCK)        
             WHERE a.xh = b.sqdxh AND a.syxh = b.syxh --һ�����뵥���ܶ�Ӧ�����Ŀ���Ե�һ����ĿΪ׼        
      
            UPDATE #temp        
               SET qrbz = 9        
              FROM #temp a,        
                   BQ_YJQQK b (NOLOCK)        
             WHERE     a.xh = b.sqdxh        
                   AND a.syxh = b.syxh        
                   AND b.jlzt = 2        
      
            SELECT choose "ѡ��",        
                   xh "���",        
                   mbxh "ģ�����",        
                   lrrq "¼������",        
  mbmc "ģ������",        
                   caption "��ʾ����",        
                   sqks "�������",        
                   zxks "ִ�п���",        
                   CASE        
                      WHEN     (qrbz = 0)        
                       AND (jlzt = 0)        
                           AND (yysj = '')        
                      THEN        
                         "δȷ��"        
                      WHEN (qrbz = 1) AND (jlzt = 0)        
                      THEN        
                         "��ȷ��"        
                      WHEN qrbz = 0 AND (yysj <> '')        
                      THEN        
                         "��ԤԼ"        
                      WHEN jlzt = 1        
                      THEN        
                         "����"        
                      WHEN qrbz = 9        
                      THEN        
                         "�ܾ�"        
                   END        
                      "״̬",        
                   yysj "ԤԼʱ��"        
              FROM #temp        
            ORDER BY lrrq DESC        
         END        
drop table ##VW_MZHJCFK  
drop table ##SF_BRXXK  
drop table ##VW_YJ_REPORT  
drop table ##VW_MZSQD    
RETURN 

