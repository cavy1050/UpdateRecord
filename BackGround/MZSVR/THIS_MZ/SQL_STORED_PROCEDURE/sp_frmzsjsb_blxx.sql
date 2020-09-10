use THIS_MZ
GO
alter proc usp_frmzsjsb_blxx
@ksrq ut_rq16='',
@jsrq ut_rq16='',
@yydm varchar(4)='0000' 
as
/******
ʾ����exec usp_frmzsjsb_blxx '2020010100:00:00','2020013123:59:59','01'
˵�����������ﲡ����Ϣ(usp_frmzsjsb_blxx)
���ߣ�winning-dingsong-chongqing
ʱ�䣺20200818
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
P900	varchar(50)	not null	,	--	ҽ�ƻ�������
P6891	varchar(80)	not null	,	--	��������
P686	varchar(50)	 	,	        --	ҽ�Ʊ����ֲᣨ������
P800	varchar(50)		,	        --	��������
P7501	varchar(2)	not null	,	--	��������--01����02����03סԺ04���05��Ӫ09����
P7502	varchar(50)	not null	,	--	���￨��
P7000	varchar(50)	not null	,	--	���������ˮ��
P4	    varchar(40)	not null	,	--	����
P5   	varchar(2)	not null	,	--	�Ա�
P6   	varchar(20)	not null	,	--	��������
P7   	varchar(3)	not null	,	--	����
P12   	varchar(40)		        ,	--	����
P11   	varchar(20)	not null	,	--	����
P8	    varchar(2)	not null	,	--	����״��
P9   	varchar(2)	         	,	--	ְҵ
P7503	varchar(2)	not null	,	--	ע��֤�����ʹ���
P13   	varchar(18)	not null	,	--	ע��֤������
P801	varchar(200)  not null    ,	--	��סַ
P802	varchar(40)	not null	,	--	סլ�绰
P803	varchar(6)	not null	,	--	��סַ��������
P14  	varchar(200)		    ,	--	������λ����ַ
P15  	varchar(40)		        ,	--	������λ�绰
P16  	varchar(6)		        ,	--	������λ��������
P18  	varchar(20)	         	,	--	��ϵ������
P19 	varchar(1)		        ,	--	��ϵ
P20  	varchar(200)		    ,	--	��ϵ�˵�ַ
P21  	varchar(40)		        ,	--	��ϵ�˵绰
P7505	varchar(4)	not null	,	--	�������
P7520	varchar(2)		        ,	--	�Ƿ����
P7521	varchar(2)	            ,	--	�Ƿ�ת��
P7504	varchar(70)	        	,	--	������Ҵ���
P7522   varchar(50)	        	,	--	�����������
P7506   varchar(20)	not null	,	--	��������
P7507   varchar(2000) not null  ,	--	����
P7523   varchar(2000)           ,	--	�ֲ�ʷ
P7524   varchar(2000)           ,	--	�����(����)
P7525   varchar(50)             ,	--	֢״����
P7526   varchar(1000)           ,	--	֢״����
P7527   varchar(1000)           ,	--	֢״����
P7528   varchar(20)		        ,	--	��������
P7529   varchar(2)	not null	,	--	�Ƿ�����
P28     varchar(100)	        ,	--	�ţ���������ϱ���
P281    varchar(1000) not null	,	--	�ţ��������������
P7530   varchar(2) 	            ,	--	ȷ����
P1      varchar(2) not null	    ,	--	ҽ�Ƹ��ʽ
P7508   numeric(10,2) not null	,	--	�ܷ���
P7509   numeric(10,2) 	        ,	--	�Һŷ�
P7510   numeric(10,2) 	        ,	--	ҩƷ��
P7511   numeric(10,2)          	,	--	����
P7512   numeric(10,2)         	,	--	�Ը�����
)

insert into #temp
select distinct
cast(@jgdm as varchar(50)) P900,
cast(@yymc as varchar(80)) P6891,
cast('' as varchar(50)) P686,
cast('' as varchar(50)) P800,
cast(case a.GHLB when 0 then '01' when 1 then '02' else '09' end as varchar(2)) P7501,
cast(a.CARDNO as varchar(50)) P7502,
cast(a.BLH as varchar(50)) P7000,
cast(a.HZXM as varchar(40)) P4,
cast(case a.SEX when '��' then '1' when 'Ů' then '2' else '9' end as varchar(2)) P5,
stuff(stuff(stuff(a.BIRTH,5,0,'-'),8,0,'-'),11,0,' ') P6,
cast(datediff(year,stuff(stuff(a.BIRTH,5,0,'-'),8,0,'-'),getdate()) as varchar(3)) P7,
cast(gj.name as varchar(40)) P12,
'' P11,
'' P8,
'' P9,
'01' P7503,
cast(case when isnull(b.sfzh,'')='' then '-' else b.sfzh end as varchar(18)) P13,
cast(g.jzd_sname+g.jzd_xname+g.jzd_addr as varchar(200)) as P801,--��סַ    
cast(b.lxdh as varchar(40)) as P802,--��ϵ�绰    
'-' as P803,'' as P14,'' as P15,'' as P16,'' as P18,'' as P19,'' as P20,'' as P21,    
'1' as P7505,    
'' as P7520,    
'' as P7521,    
'' as P7504,    
'' as P7522,    
substring(a.JZRQ,1,4)+'-'+substring(a.JZRQ,5,2)+'-'+substring(a.JZRQ,7,2)+' '+substring(a.JZRQ,9,8) as  P7506,--��������    
cast(case when isnull(c.zsnr,'')='' then '-' else c.zsnr end as varchar(2000)) as P7507,--����     
'' as P7523,    
'' as P7524,    
'' as P7525,    
'-' as P7526,    
'' as P7527,    
'' as P7528,    
'2' as P7529,    
cast(STUFF ((select'|'+zddm from VW_SF_YS_MZBLZDK nn(nolock) where nn.ghxh=a.GHXH for xml path('')),1,1,'') as varchar(100))  as P28,    
cast(isnull(STUFF ((select'|'+zdmc from VW_SF_YS_MZBLZDK ww(nolock) where ww.ghxh=a.GHXH for xml path('')),1,1,''),'-') as varchar(100)) as P281,    
'' as P7530,    
cast(isnull(e.ybdydm,'') as varchar(2))  as P1,--ҽ��֧����ʽ    
cast(isnull(sum(f.zje),0) as numeric(10,2)) as P7508,--�ܷ���    
cast((select sum(h.zje) From VW_MZBRJSK h(nolock) where h.ghsjh=a.JSSJH and h.ghsfbz=0 and h.ybjszt=2 and h.jlzt=0) as numeric(10,2))  as P7509,    
cast((select isnull(sum(ff.xmje),0) from VW_MZBRJSK hh(nolock),VW_MZBRJSMXK ff(nolock) where a.JSSJH=hh.ghsjh and hh.sjh=ff.jssjh and ff.fpxmmc='ҩƷ��' and hh.ybjszt=2 and hh.jlzt=0  ) as numeric(10,2)) as P7510,    
cast((select isnull(sum(kk.xmje),0) from VW_MZBRJSK gg(nolock),VW_MZBRJSMXK kk(nolock) where a.JSSJH=gg.ghsjh and gg.sjh=kk.jssjh and kk.fpxmmc like '%���%' and gg.ybjszt=2 and gg.jlzt=0  ) as numeric(10,2)) as P7511,    
cast(case when isnull(sum(f.zfje),0)<0 then '0' else isnull(sum(f.zfje),0) end  as numeric(10,2)) as P7512                
from  #fepailist a(nolock)     
inner join  SF_BRXXK b (nolock) on a.PATID=b.patid  
left join  VW_SF_YS_MZBLK c(nolock) on a.GHXH=c.ghxh   
left join  VW_SF_YS_MZBLZDK  d(nolock) on a.GHXH=d.ghxh     
left join YY_YBDY_DYMXK e(nolock) on a.YBDM=e.hisdydm and e.dyfl='RC032'
left join YY_GJDMK gj(nolock) on b.gjbm=gj.id
left join YY_ZYDMK zy(nolock) on b.zydm=zy.id     
inner join VW_MZBRJSK f(nolock) on a.JSSJH=f.ghsjh and f.ybjszt=2 and f.jlzt=0   
inner join SF_BRXXK_FZ g(nolock) on b.patid=g.patid   
group by a.GHXH,a.BLH, a.CARDNO,a.HZXM,b.sfzh,a.BIRTH,a.SEX,a.JZRQ, a.JSSJH,e.ybdydm , c.zsnr ,a.GHLB ,     
a.GHKSDM ,c.ysdm  ,b.lxdz  ,b.lxdh,  d.zdmc   ,b.zydm  ,g.jzd_sname,g.jzd_xname,g.jzd_addr,gj.name,zy.name 

--exec usp_frmzsjsb_blxx '2020010100:00:00','2020013123:59:59','01'
--select * from YY_YBDY_DYMXK

--�滻���з�
declare @sql varchar(max)=''
select @sql=@sql+'replace(replace('+name+',char(10),''��''),char(13),''��'') '+name+',' from tempdb.sys.all_columns where object_id=object_id('tempdb.dbo.#temp')
select @sql=substring(@sql,1,len(@sql)-1)
exec('select '+@sql+' from #temp')
--select * from #temp

drop table #temp







