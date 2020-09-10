use DBris50
go
alter proc usp_frmzsjsb_jcxxjl
@ksrq varchar(16)='',
@jsrq varchar(16)='',   
@yydm varchar(4)='0000' 
as
/******
ʾ����exec usp_frmzsjsb_jcxxjl '2020010100:00:00','2020013123:59:59','01'
˵���������ϸ��¼(usp_frmzsjsb_jyxxjl)
���ߣ�winning-dingsong-chongqing
ʱ�䣺20200818
�������Һ����� between @ksrq and @jsrq  
		@yyid��ҽԺ����
exec usp_hqms_frmzblxx_jbxx @ksrq,@jsrq,@yyid,1
******/
set nocount on

IF(ISNULL(@ksrq,'')='' OR ISNULL(@jsrq,'')='') ---Ĭ��ǰ7�쵽ǰһ��֮������ڶ�  
BEGIN  
SELECT @ksrq = CONVERT(VARCHAR(8),DATEADD(DAY,-7,GETDATE()),112)+'00:00:00'
SELECT @jsrq = CONVERT(VARCHAR(8),DATEADD(DAY,-1,GETDATE()),112)+'23:59:59'  
END  
else  
begin  
select @ksrq=LEFT(@ksrq,8)+'00:00:00'  
select @jsrq=LEFT(@jsrq,8)+'23:59:59'  
end

create table #fepailist                      
(GHXH varchar(16) ,--�Һ����                      
 HZXM varchar(32) NOT NULL, --��������                      
 SEX  varchar(8) NULL,  --�Ա�                      
 GHLB INT NOT NULL,  -- �Һ����                                 
 PATID varchar(16) NOT NULL, -- ���ߵ�ΨһID������ȡVW_JZJLK.PATID,סԺȡCPOE_BRSYK.CPOE_BRSYK                                     
 BLH varchar(32) NULL,  --- ������                      
 CARDTYPE varchar(8) NULL, --- ������                      
 CARDNO varchar(32) NULL, --- ����                      
 SFZH varchar(32) NULL, --- ���֤��                      
 BIRTH varchar(16) NULL, ---��������                                       
 GHKSDM varchar(16) NULL,   ---���Ҵ���                      
 KSMC varchar(32) NULL,   ---��������                                      
 JZRQ varchar(32) NOT NULL, ----�������ڣ����� VW_JZJLK.GHRQ, סԺCPOE_BRSYK.RYRQ    
 JSSJH varchar(100),--�����վݺ�                    
 YBDM varchar(10)--ҽ������  
) 

declare @jgdm varchar(32),@yymc varchar(32)
if(@yydm='01' or @yydm='0000')
begin
select @jgdm=yydm,@yymc=name from [MZSVR].THIS_MZ.dbo.YY_JBCONFIG(nolock) where id='01'
select @jgdm='67866859X'
end
else if(@yydm='02')
begin
select @jgdm=yydm,@yymc=name from [MZSVR].THIS_MZ.dbo.YY_JBCONFIG(nolock) where id='02'
select @jgdm='07882355X'
end
else
begin
select 'F','ҽԺ���벻ƥ�䣡'
return
end

exec [MZSVR].THIS_MZ.dbo.usp_hqms_frmzblxx_jbxx @ksrq,@jsrq,@yydm,1

insert into #fepailist
select * from [MZSVR].THIS_MZ.dbo.frmzsb_pailist(nolock)
delete [MZSVR].THIS_MZ.dbo.frmzsb_pailist

 
create table #temp  
(  
P7502 varchar(50) not null ,-- ���￨��  �ż��￨��  
P7506 varchar(20) not null ,-- ��������  �ż��ﻼ����д�Һ�����ʱ�䡣��yyyy-MM-dd HH:mm:ss����ʽ  
P7000 varchar(50) not null ,-- ���������ˮ��  ͬ�������ﲡ����Ϣ����  
P4 varchar(40) not null ,-- ����    
P7701 varchar(50)  ,-- ��������������    
P7702 varchar(700)  ,-- ��������������    
P7703 varchar(50)  ,-- �������-���뵥��  �ɶ���  
P7704 varchar(30) not null ,-- �������-���浥��  ���������-���浥�š����ϡ��������-Ժ�ڼ��-��Ŀ���롿Ψһ��ʶ��¼�ֶ�  
P7705 varchar(50)  ,-- �������-��鱨�浥����    
P7706 varchar(20)  ,-- �������-�������  ��yyyy-MM-dd HH:mm:ss����ʽ  
P7707 varchar(10)  ,-- �������-������ ��CV5199.01�����������롿   
P7708 varchar(30)  ,-- �������-��Ŀ����    
P7709 varchar(100)  ,-- �������-�������    
P7710 varchar(300)  ,-- �������-��Ŀ����    
P7711 varchar(30) not null ,-- �������-Ժ�ڼ��-��Ŀ����  ���������-���浥�š����ϡ��������-Ժ�ڼ��-��Ŀ���롿Ψһ��ʶ��¼�ֶ�  
P7712 varchar(300) not null ,-- �������-Ժ�ڼ��-��Ŀ����    
P7713 varchar(500) not null ,-- �������-��鲿λ    
P7714 varchar(2)  ,-- �������-����Ƿ����� "��RC016��1=��2=��"   
P7715 varchar(max) not null ,-- �������-�������    
P7716 varchar(10)  ,-- �������-������쳣��ʶ ��CT01.00.006���/�������쳣��ʶ��   
P7717 varchar(max) not null -- �������-������    
)
insert into #temp 
select distinct
isnull(a.CARDNO,'-') P7502,
isnull(stuff(stuff(stuff(a.JZRQ,5,0,'-'),8,0,'-'),11,0,' '),'-') P7506,
isnull(a.BLH,'-') P7000,
isnull(a.HZXM,'-') P4,
@yymc P7701,
@jgdm P7702,
b.ApplyNo P7703,
isnull(b.ApplyNo,'-') P7704,
c.ItemName P7705,
convert(varchar(20),b.ExecTime,120) P7706,
'-' P7707,--f.replb P7707,
c.ItemCode P7708,
f.replbmc P7709,
c.ItemName P7710,
isnull(c.ItemCode,'-') P7711,
isnull(c.ItemName,'-') P7712,
isnull(f.jcbw,'-') P7713,
'' P7714,
isnull(f.jcsj,'-') P7715,
'' P7716,
isnull(f.jcjl,'-') P7717
from #fepailist a(nolock)
left join Ris_list b(nolock) on a.BLH=b.HospNo
left join Ris_AcceptItems c(nolock) on b.ApplyNo=c.ApplyNo
left join Ris_result d(nolock) on c.ApplyNo=d.ApplyNo
left join RIS_ItemDic e(nolock) on d.ItemCode=e.ItemCode
left join SF_YS_REPORT f(nolock) on f.xh=d.ApplyNo 

--select max(len(jcjl)) from SF_YS_REPORT
  
--�滻���з�
declare @sql varchar(max)=''
select @sql=@sql+'replace(replace('+name+',char(10),''��''),char(13),''��'') '+name+',' from tempdb.sys.all_columns where object_id=object_id('tempdb.dbo.#temp')
select @sql=substring(@sql,1,len(@sql)-1)
exec('select '+@sql+' from #temp')
  
drop table #temp 

