use THIS_MZ
GO
alter proc usp_frmzsjsb_zlcf
@ksrq ut_rq16='',
@jsrq ut_rq16='',
@yydm varchar(4)='0000' 
as
/******
ʾ����exec usp_frmzsjsb_zlcf '2020010100:00:00','2020013123:59:59','01'
˵�������ƴ���(usp_frmzsjsb_zlcf)
���ߣ�winning-dingsong-chongqing
ʱ�䣺20200828
�������Һ����� between @ksrq and @jsrq  
		@yyid��ҽԺ����
exec usp_hqms_frmzblxx_jbxx @ksrq,@jsrq,@yyid
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

insert into #fepailist
exec usp_hqms_frmzblxx_jbxx @ksrq,@jsrq,@yydm

create table #temp
(
P7502	varchar(50)	not null	,--	���￨��		�ż��￨��
P7506	varchar(20)	not null	,--	��������		�ż��ﻼ����д�Һ�����ʱ�䣬��yyyy-MM-dd HH:mm:ss����ʽ
P7000	varchar(50)	not null	,--	���������ˮ��		ͬ�������ﲡ����Ϣ����
P4	varchar(40)	not null	,--	����		
P7800	varchar(50)	not null	,--	������		�������š����ϡ�������ϸ���롿Ψһ��ʶ��¼�ֶ�
P7801	varchar(20)		,--	��������ʱ��		��yyyy-MM-dd HH:mm:ss����ʽ
P7802	varchar(2)		,--	����������	��CT05.10.007���������롿	
P7803	varchar(30)		,--	������Ŀ�������	��CV06.00.229ҽ����Ŀ�����롿	
P7804	varchar(100)		,--	������Ŀ��������		
P7805	varchar(30)	not null	,--	������ϸ����		ҽԺ�ڲ�ҩƷ����
P7806	varchar(100)	not null	,--	������ϸ����		ҽԺ�ڲ�ҩƷ����
P7807	varchar(20)		,--	��ҩ�������		
P7808	varchar(2)		,--	��ҩ������	��CV06.00.101��ҩʹ�������롿	
P7809	varchar(200)		,--	��ҩ��ע		
P7810	varchar(100)		,--	ҩ�����ʹ���	��CV5301.06ҩ�����ʹ��롿	
P7811	varchar(100)		,--	ҩ������		
P7812	varchar(2)		,--	ҩ����ʹ���	��CV08.50.002ҩ����ʹ��롿	
P7813	varchar(110)		,--	ҩ���������		
P7814	varchar(50)		,--	ҩƷ���		
P7815	varchar(20)	not null	,--	ҩ��ʹ��-Ƶ��		
P7816	numeric(30,4)		,--	ҩ��ʹ��-�ܼ���		����Ϊ��ֵ���Ҿ���С�ڵ���4
P7817	numeric(30,4)	not null	,--	ҩ��ʹ��-�μ���		����Ϊ��ֵ���Ҿ���С�ڵ���4
P7818	varchar(10)	not null	,--	ҩ��ʹ��-������λ		
P7819	varchar(3)		,--	ҩ��ʹ��-;������	��CV06.00.102��ҩ;�����롿	
P7820	varchar(30)		,--	ҩ��ʹ��-;��		
P7821	varchar(10)		,--	Ƥ���б�(�Ƿ����)	"��RC016��1=��2=��"	
P7822	varchar(20)		,--	��ҩ��ʼʱ��		��yyyy-MM-dd HH:mm:ss����ʽ
P7823	varchar(20)		,--	��ҩֹͣ����ʱ��		��yyyy-MM-dd HH:mm:ss����ʽ
P7824	numeric(5)		,--	��ҩ����		����Ϊ����
P7825	varchar(1)		,--	�Ƿ���ҩ	"��RC016��1=��2=��"	
P7826	varchar(1)		,--	�Ƿ�Ӽ�	"��RC016��1=��2=��"	
P7827	varchar(70)		,--	���Ҵ���	��RC023���Ҵ��롿	
P7828	varchar(50)		,--	��������		
P7829	varchar(1)		,--	�Ƿ�ͳһ�ɹ�ҩƷ	"��RC016��1=��2=��"	
P7830	varchar(20)		,--	ҩƷ�ɹ���		��дҽ�ƻ������ڵ���ҩƷ�ɹ�ƽ̨��ҩƷ����
P7831	varchar(50)		,--	ҩ��ƽ̨��		
P7832	varchar(2)		--	�Ƿ����ҩ��	"��RC016��1=��2=��"	
)

insert into #temp
select distinct--a.xh,
isnull(a.CARDNO,'') P7502,
isnull(stuff(stuff(stuff(a.JZRQ,5,0,'-'),8,0,'-'),11,0,' '),'') P7506,
isnull(a.BLH,'') P7000,
isnull(a.HZXM,'') P4,--P4
isnull(b.xh,0) P7800,
stuff(stuff(stuff(b.lrrq,5,0,'-'),8,0,'-'),11,0,' ') P7801,
'' P7802,--b.cflx P7802,
'' P7803,--c.dxmdm P7803,
'' P7804,--d.mzfp_mc P7804,--P7804
isnull(c.ypdm,0) P7805,
isnull(c.ypmc,'') P7806,
case c.dxmdm when '02' then '�г�ҩ' when '03' then '�в�ҩ' else 'δʹ��' end P7807,--P7807
'' P7808,--case c.dxmdm when '02' then '2' when '03' then '3' else '1' end,--P7808
c.memo P7809,
'' P7810,--e.fldm P7810,
ypfl.name P7811,
'' P7812,--e.jxdm P7812,
jx.name P7813,
c.ypgg P7814,
isnull(yzpc.xsmc,'') P7815,
case when c.ypsl>0 then c.ypsl else null end P7816,
isnull(hjmx.ypjl,0) P7817,
isnull(hjmx.jldw,'') P7818,--P7818
'' P7819,--hjmx.ypyf P7819,
ypyf.name P7820,
case gmjl.gmlx when 0 then 2 when 1 then 1 end P7821,--P7821
case when isnull(b.pyrq,'')<>'' then stuff(stuff(stuff(b.pyrq,5,0,'-'),8,0,'-'),11,0,' ') else null end P7822,
'' P7823,
hjmx.ts P7824,
'' P7825,
'' P7826,
'' P7827,--b.ksdm P7827,
ks.name P7828,
'' P7829,
'' P7830,'' P7831,'' P7832
from #fepailist a(nolock)
left join VW_MZCFK b(nolock) on a.PATID=b.patid and a.GHXH=b.ghxh
left join VW_MZCFMXK c(nolock) on b.xh=c.cfxh
left join VW_HJCFMXK hjmx(nolock) on c.hjmxxh=hjmx.xh
--left join YY_SFDXMK d on c.dxmdm=d.mzfp_id
left join YK_YPCDMLK e(nolock) on c.cd_idm=e.idm
left join YK_YPFLK ypfl(nolock) on e.fldm=ypfl.id
left join YK_YPJXK jx(nolock) on e.jxdm=jx.id
left join SF_YS_YZPCK yzpc(nolock) on hjmx.pcdm=yzpc.id
left join SF_YPYFK ypyf(nolock) on hjmx.ypyf=ypyf.id
left join SF_YS_BRGMJLK gmjl(nolock) on hjmx.xh=gmjl.hjmxxh and a.PATID=b.patid and hjmx.cd_idm=gmjl.cd_idm
left join YY_KSBMK ks(nolock) on b.ksdm=ks.id

--�滻���з�
declare @sql varchar(max)=''
select @sql=@sql+'replace(replace('+name+',char(10),''��''),char(13),''��'') '+name+',' from tempdb.sys.all_columns where object_id=object_id('tempdb.dbo.#temp')
select @sql=substring(@sql,1,len(@sql)-1)
exec('select '+@sql+' from #temp')
--select * from #temp

drop table #temp


