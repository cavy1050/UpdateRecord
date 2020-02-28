if exists(select 1 from sysobjects where name='usp_sf_sfxmcx_bygh' and type='P')
	drop proc usp_sf_sfxmcx_bygh
go 
create proc usp_sf_sfxmcx_bygh  
  @patid  ut_xh12,  
  @ghxh ut_xh12,
  @cxlb VARCHAR(3)='1'  
as--��104221 2011-05-09 14:32:32 4.0��׼�� ���Ի����93008  
/**********  
[�汾��]4.0.0.0.0  
[����ʱ��]2009.05.10  
[����]xxl  
[��Ȩ] Copyright ? 1998-2001�Ϻ����˴�-����ҽ����Ϣ�������޹�˾  
[����] ����ϵͳ--  
[����˵��]  
 ��Ŀȷ��  
[����˵��]  
@lb     ut_bz,    --0����sjh��ȡ������Ϣ1����patid��ȡ������Ϣ2��ȡȷ����ϸ  
@patid  ut_xh12=0,  
@sjh    ut_sjh='',      
@qrxh   ut_xh12=0,     --ȷ�����  
@ksrq   ut_rq8='',     --���˿�ʼʱ��  
@jsrq   ut_rq8='',     --���˽���ʱ��  
@yqr    ut_bz=0        --�Ƿ���ʾ��ȷ���꣬Ĭ��Ϊ����ʾ  
[����ֵ]  
[�����������]  
 �ɹ���"T"  
 ����"F","������Ϣ"  
[���õ�sp]  
   usp_sf_sfxmcx_bygh 9763,11442,'2'
   usp_sf_sfxmcx_bygh 4610,11279,'2'
   
[����ʵ��]  
*****/  
set nocount on  

IF @cxlb = '1'
BEGIN
    select sjh,sfrq into #sjh from VW_MZBRJSK(nolock) 
	where patid=@patid and ghxh=@ghxh and ghsfbz=1 and jlzt=0

	select c.ypdm 'ҩƷ����',c.ypmc 'ҩƷ����',ROUND(c.ypsl/c.dwxs,2) 'ҩƷ����',c.ypdw '��λ',
	  substring(a.sfrq,1,4)+'-'+substring(a.sfrq,5,2)+'-'+substring(a.sfrq,7,2)+ ' ' + substring(a.sfrq,9,8) '�շ�����'  
	from #sjh a,VW_MZCFK b(nolock),VW_MZCFMXK c(nolock)
	where a.sjh=b.jssjh and b.xh=c.cfxh and b.jlzt=0
END
ELSE IF @cxlb = '2' 
BEGIN
    select sjh,sfrq into #sjh2 from VW_MZBRJSK(nolock) 
	where patid=@patid and ghxh=@ghxh and ghsfbz=1 and ybjszt = 2

    select b.xh AS mxxh,b.cfxh,b.ypdm,b.ypmc,ROUND(b.ypsl/b.ypxs,2) ypsl,b.ypdw
	into #hjcfk 
	from VW_MZHJCFK a(nolock) ,VW_MZHJCFMXK b(NOLOCK) 
	where a.xh = b.cfxh and patid=@patid and ghxh=@ghxh

	select b.hjxh,c.hjmxxh,b.jlzt,a.sfrq
	into #mzcfk 
	from #sjh2 a,VW_MZCFK b(nolock),VW_MZCFMXK c(nolock)
	where a.sjh=b.jssjh and b.xh=c.cfxh and b.jlzt IN (0,1)

	select a.ypdm 'ҩƷ����',a.ypmc 'ҩƷ����',CONVERT(DECIMAL(13,2),a.ypsl) 'ҩƷ����',a.ypdw '��λ',
			SUBSTRING(b.sfrq,1,4)+'-'+substring(b.sfrq,5,2)+'-'+substring(b.sfrq,7,2)+ ' ' + substring(b.sfrq,9,8) '�շ�����',
			CASE WHEN b.jlzt IS NULL THEN 'δ�շ�' WHEN b.jlzt = 0 THEN '���շ�' WHEN b.jlzt = 1 THEN '���˷�' ELSE '' end '�շѱ�־'
	FROM #hjcfk a LEFT JOIN #mzcfk b ON a.cfxh = b.hjxh AND a.mxxh = b.hjmxxh
END

return
go