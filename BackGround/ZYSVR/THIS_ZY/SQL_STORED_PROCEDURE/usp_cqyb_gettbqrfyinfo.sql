if exists(select * from sysobjects where name='usp_cqyb_gettbqrfyinfo')
  drop proc usp_cqyb_gettbqrfyinfo
go
CREATE PROC usp_cqyb_gettbqrfyinfo
	@blh	ut_blh,
	@kssj	VARCHAR(20),
	@jssj	VARCHAR(20)
AS
/****************************************
[�汾��]4.0.0.0.0
[����ʱ��]2018.03.21
[����]Zhuhb
[��Ȩ]Copyright ? 1998-2017���������Ƽ����Źɷ����޹�˾
[����]����ҽ�����ⲡ������Ϣ
[����˵��]
    �����ز����� ����
	�ز����������ȷ�ϵȷ�����ϸ��ѯ
	�ô洢Ϊ�ֳ��Զ���洢�����������޸ģ�
	�����ֶ�[HZXM]�����У��ֶ�[I]�����籣����
[����˵��]
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��]
exec usp_cqyb_gettbqrfyinfo "20170036437","2009030100:00:00","2018033000:00:00"
[�޸ļ�¼]

****************************************/
 select row_number() over(order by c.xh)   as  "ID",              
 '0' "A",'0' "B",'0' as "C",c.ylsj "D",c.ylsj "E",c.ypsl "F",                
 e.dydm "G",d.blh "H",'' "I",                  
 d.hzxm "J",                     
 substring(a.sfrq,1,4)+'-'+substring(a.sfrq,5,2)+'-'+substring(a.sfrq,7,2) "K",c.ypdw  "L",                  
 row_number() over(order by c.xh)  AS "M" ,              
 '10997' as "N" ,0 AS "Z",c.ypmc XMMC,d.hzxm "HZXM"               
 into #tempbrbp                     
 from VW_MZBRJSK a(nolock) inner join VW_MZCFK b(nolock) on a.sjh = b.jssjh                       
 inner join VW_MZCFMXK c(nolock) on b.xh = c.cfxh inner join SF_BRXXK d(nolock) on a.patid = d.patid                       
 inner join YY_SFXXMK e(nolock) on c.ypdm = e.id                      
  where --b.ksdm = '1310' AND       
  a.ybjszt = 2 and d.blh = @blh AND a.sfrq BETWEEN @kssj  AND  @jssj             
                
               
  select CAST(ID AS CHAR(5)) ID,A,B,C,D,E,F,G,H,I,J,CAST(K AS DATETIME) K,L,
  CAST(M AS CHAR(5)) M,N,Z,XMMC,HZXM from #tempbrbp

	