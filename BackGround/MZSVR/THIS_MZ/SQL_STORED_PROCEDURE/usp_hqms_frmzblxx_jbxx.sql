use THIS_MZ
GO
alter proc usp_hqms_frmzblxx_jbxx                                  
(                                        
 @ksrq varchar(16)='',                                        
 @jsrq varchar(16)='',   
 @yydm ut_dm4='0000',
 @bz ut_bz=0  --0:��������1:��������                                  
)                                        
as                                     
/******
ʾ����exec usp_hqms_frmzblxx_jbxx '2020010100:00:00','2020010123:59:59','01','1'
˵�����������ﲡ����Ϣ(usp_hqms_frmzblxx_jbxx)
���ߣ�winning-dingsong-chongqing
ʱ�䣺20200828
�������Һ����� between @ksrq and @jsrq  
		@yyid��ҽԺ����
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
(GHXH ut_xh12 ,--�Һ����                      
 HZXM varchar(32) NOT NULL, --��������                      
 SEX  varchar(8) NULL,  --�Ա�                      
 GHLB INT NOT NULL,  -- �Һ����                                 
 PATID varchar(16) NOT NULL, -- ���ߵ�ΨһID������ȡVW_JZJLK.PATID,סԺȡCPOE_BRSYK.CPOE_BRSYK                                     
 BLH varchar(32) NULL,  --- ������                      
 CARDTYPE varchar(8) NULL, --- ������                      
 CARDNO varchar(32) NULL, --- ����                      
 SFZH varchar(32) NULL, --- ���֤��                      
 BIRTH varchar(32) NULL, ---��������                                       
 GHKSDM u5_ksdm NULL,   ---���Ҵ���                      
 KSMC varchar(32) NULL,   ---��������                                      
 JZRQ varchar(32) NOT NULL, ----�������ڣ����� VW_JZJLK.GHRQ, סԺCPOE_BRSYK.RYRQ    
 JSSJH varchar(100),--�����վݺ�                    
 YBDM varchar(10)--ҽ������  
)                      
CREATE NONCLUSTERED INDEX TEMP_IDMS_LGYBL_PAT_LIST ON #fepailist (GHXH,PATID,CARDNO)      
    
--������Ϣ    
insert into  #fepailist(GHXH, HZXM,SEX,GHLB,PATID,BLH,CARDTYPE,CARDNO,SFZH,BIRTH,GHKSDM,KSMC,JZRQ,JSSJH,YBDM)    
select distinct 
a.xh, cast(a.hzxm as varchar(32)),b.sex,a.ghlb,a.patid,b.blh,b.cardtype,
case when isnull(b.cardno,'')='' then a.blh else b.cardno end,
isnull(b.sfzh,''),b.birth,a.ghksdm,a.ksmc,
a.ghrq ,a.jssjh,b.ybdm   
from  VW_GHZDK a (nolock) 
inner join SF_BRXXK b(nolock) on a.patid=b.patid           
where a.ghksdm in ('029803','052802','324102') 
and  a.ghlb<>8 and a.jlzt=0 
and  a.ghrq between @ksrq and @jsrq 
--order by len(a.hzxm) desc

--select * from GH_GHLBK
--select yydm,* from YY_KSBMK WHERE name LIKE '%����%'

if(@yydm in ('01','0000'))
begin
	delete FROM #fepailist where GHKSDM in (select id from YY_KSBMK(nolock) where yydm not in ('01'))--��ѧ��
end
else if(@yydm in ('02'))
begin
	delete FROM #fepailist where GHKSDM in (select id from YY_KSBMK(nolock) where yydm not in ('02'))--����
end
else if(@yydm in ('03'))
begin
	delete FROM #fepailist where GHKSDM in (select id from YY_KSBMK(nolock) where yydm not in ('03'))--��ˮ
end
else
begin
	delete FROM #fepailist
end 



if(@bz=0)
begin
	SELECT * FROM #fepailist
end
else if(@bz=1)
begin
	if not exists(select 1 from sys.tables where name = 'frmzsb_pailist')
	begin
		SELECT * into frmzsb_pailist FROM #fepailist(nolock)
	end
	else
	begin
		delete from frmzsb_pailist
		insert into frmzsb_pailist
		SELECT * FROM #fepailist  
	end
end
DROP TABLE #fepailist
