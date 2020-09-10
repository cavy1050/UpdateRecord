use THIS_MZ
GO
alter proc usp_hqms_frmzblxx_jbxx                                  
(                                        
 @ksrq varchar(16)='',                                        
 @jsrq varchar(16)='',   
 @yydm ut_dm4='0000',
 @bz ut_bz=0  --0:输出结果，1:不输出结果                                  
)                                        
as                                     
/******
示例：exec usp_hqms_frmzblxx_jbxx '2020010100:00:00','2020010123:59:59','01','1'
说明：发热门诊病例信息(usp_hqms_frmzblxx_jbxx)
作者：winning-dingsong-chongqing
时间：20200828
参数：挂号日期 between @ksrq and @jsrq  
		@yyid：医院代码
******/                                             
                                                                           
set nocount on  

IF(ISNULL(@ksrq,'')='' OR ISNULL(@jsrq,'')='') ---默认前7天到前一天之间的日期段  
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
(GHXH ut_xh12 ,--挂号序号                      
 HZXM varchar(32) NOT NULL, --患者姓名                      
 SEX  varchar(8) NULL,  --性别                      
 GHLB INT NOT NULL,  -- 挂号类别                                 
 PATID varchar(16) NOT NULL, -- 患者的唯一ID：门诊取VW_JZJLK.PATID,住院取CPOE_BRSYK.CPOE_BRSYK                                     
 BLH varchar(32) NULL,  --- 病历号                      
 CARDTYPE varchar(8) NULL, --- 卡类型                      
 CARDNO varchar(32) NULL, --- 卡号                      
 SFZH varchar(32) NULL, --- 身份证号                      
 BIRTH varchar(32) NULL, ---出生日期                                       
 GHKSDM u5_ksdm NULL,   ---科室代码                      
 KSMC varchar(32) NULL,   ---科室名称                                      
 JZRQ varchar(32) NOT NULL, ----就诊日期：门诊 VW_JZJLK.GHRQ, 住院CPOE_BRSYK.RYRQ    
 JSSJH varchar(100),--结算收据号                    
 YBDM varchar(10)--医保代码  
)                      
CREATE NONCLUSTERED INDEX TEMP_IDMS_LGYBL_PAT_LIST ON #fepailist (GHXH,PATID,CARDNO)      
    
--门诊信息    
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
--select yydm,* from YY_KSBMK WHERE name LIKE '%发热%'

if(@yydm in ('01','0000'))
begin
	delete FROM #fepailist where GHKSDM in (select id from YY_KSBMK(nolock) where yydm not in ('01'))--大学城
end
else if(@yydm in ('02'))
begin
	delete FROM #fepailist where GHKSDM in (select id from YY_KSBMK(nolock) where yydm not in ('02'))--康复
end
else if(@yydm in ('03'))
begin
	delete FROM #fepailist where GHKSDM in (select id from YY_KSBMK(nolock) where yydm not in ('03'))--黄水
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
