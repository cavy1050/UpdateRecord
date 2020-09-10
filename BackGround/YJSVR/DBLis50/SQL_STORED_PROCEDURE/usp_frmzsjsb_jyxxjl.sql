use DBlis50
go
alter proc usp_frmzsjsb_jyxxjl
@ksrq varchar(16)='',
@jsrq varchar(16)='',   
@yydm varchar(4)='0000' 
as
/******
ʾ����exec usp_frmzsjsb_jyxxjl '2020010100:00:00','2020013123:59:59','01'
˵����������ϸ��¼(usp_frmzsjsb_jyxxjl)
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
P7502	varchar(50)	not null	,	--	���￨��
P7506	varchar(50)	not null	,	--	��������
P7000	varchar(50)	not null 	,	--	���������ˮ��
P4	    varchar(40) not null    ,	--	����
P7601	varchar(50)	         	,	--	�����������
P7602	varchar(700)		    ,	--	�����������
P7603	varchar(50)	         	,	--	���鱨�浥�������
P7604	varchar(30)	         	,	--	���鱨�浥������
P7605   varchar(50)	        	,	--	�������뵥��
P7606   varchar(50)	        	,	--	�������뵥������
P7607   varchar(20)	        	,	--	��������
P7608   varchar(20)		        ,	--	���鱨������
P7609   varchar(20)	            ,	--	�����ͼ�����
P7610	varchar(20)	            ,	--	�����������
P7611   varchar(30)	         	,	--	����걾��
P7612	varchar(30)	        	,	--	����걾����
P7613   varchar(30)	        	,	--	����-��Ŀ����
P7614	varchar(64)             ,	--	����-��Ŀ����
P7615	varchar(30)	not null	,	--	����Ժ�ڼ���-��Ŀ����
P7616	varchar(300)not null	,	--	����Ժ�ڼ���-��Ŀ����
P7617  	varchar(50)		        ,	--	���鷽��
P7618  	varchar(20)		        ,	--	����ο�ֵ
P7619  	varchar(200)		    ,	--	����-������λ
P7620  	varchar(64)	not null    ,	--	����-���(��ֵ)
P7621 	varchar(2000)not null   ,	--	����-���(����)
P7622  	varchar(30)	not null	,	--	���鱨�浥��
P7623  	varchar(30)		        ,	--	����-��Ŀ��ϸ����
P7624	varchar(300)		    ,	--	����-��Ŀ��ϸ����
P7625	varchar(10)	not null	,	--	�������쳣��ʶ
)

insert into #temp
select distinct
case when isnull(a.CARDNO,'')='' then a.BLH else a.CARDNO end P7502,
isnull(stuff(stuff(stuff(a.JZRQ,5,0,'-'),8,0,'-'),11,0,' '),'') P7506,
isnull(a.BLH,'') P7000,
isnull(a.HZXM,'') P4,
@jgdm P7601,
@yymc P7602,
'' P7603,--f.InstName P7603,
'' P7604,--f.InstCode P7604,
c.ApplyNo P7605,
c.HisOrderName P7606,
convert(varchar(20),b.ExecTime,120) P7607,
convert(varchar(20),b.ReportTime,120) P7608,
convert(varchar(20),b.ApplyTime,120) P7609,
convert(varchar(20),b.SampleTime,120) P7610,
c.Specimen P7611,
c.SpecimenDesc P7612,
c.HisOrderCode P7613,
c.HisOrderName P7614,
isnull(c.HisOrderCode,'-') P7615,
isnull(c.HisOrderName,'-') P7616,
f.InstName P7617,
cast(d.REFERENCERANGE as varchar(20)) P7618,
d.UNIT P7619,
isnull(d.ResultValue,0) P7620,
isnull(d.ResultChar,'-') P7621,
isnull(d.SerialNo,'-') P7622, 
d.ItemCode P7623,
e.ItemName P7624,
case isnull(d.HIGHLOWFLAG,'') when '' then '1' when 'H' then '21' when 'L' then '22' when 'P' then '2' else '23' end P7625
from #fepailist a(nolock)
left join Lis_list b(nolock) on a.BLH=b.HospNo
left join Lis_AcceptItems c(nolock) on b.ApplyNo=c.ApplyNo
left join Lis_result d(nolock) on c.ApplyNo=d.ApplyNo
left join lis_item e(nolock) on d.ItemCode=e.ItemCode
left join INSTRUMENT f(nolock) on d.InstID=f.InstID

--�滻���з�
declare @sql varchar(max)=''
select @sql=@sql+'replace(replace('+name+',char(10),''��''),char(13),''��'') '+name+',' from tempdb.sys.all_columns where object_id=object_id('tempdb.dbo.#temp')
select @sql=substring(@sql,1,len(@sql)-1)
exec('select '+@sql+' from #temp')
--select * from #temp

drop table #temp
