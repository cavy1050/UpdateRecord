ALTER procedure [dbo].[usp_Ztba_GetBasyData_v5] 
  @date1 AS varchar(10),	--��ʼʱ��yyyy-MM-dd
  @date2 AS varchar(10),	--����ʱ��yyyy-MM-dd
  @type  AS INT,			--��ѯ���ͣ�0-ȫ����1-����
  @sjlx AS INT,				--ʱ�����ͣ�0-��Ժʱ�� 1-�ύʱ��
  @yydm AS varchar(100),     --ҽԺ����
  @bah AS varchar(50),		--������/@type = 1��ʾ����hissyxh
  @zycs AS INT,				--סԺ����
  @errcode AS INT OUTPUT,	
  @errmsg AS VARCHAR(1000) OUTPUT    
as                                      
/*********                                
[�汾��]1.0.0.0.0                                      
[����ʱ��]2012.12.25                          
[����]gong_wei                             
[��Ȩ] Copyright ? 2012-?�Ϻ����˴���������ɷ����޹�˾                                      
[����] ���Ӳ���ϵͳ������ҳ--���ݵ���                                      
[����˵��]                                      
 ������������������                                      
[����˵��]         
          
[����ֵ]                                      
      fzyzdqzdate        
[�����������]             
       exec  usp_Ztba_GetBasyData '2019-06-01','2019-09-18',1,NULL,NULL      
       exec  usp_Ztba_GetBasyData_v5 '2020-01-01','2020-01-31',0,0,'02','','',NULL,NULL                                     
[���õ�sp]                                      
        
[����ʵ��]            
         
                              
**********/          
set nocount on          
set XACT_ABORT ON --ʹ�ô洢����ִ��������Ҫ����XACT_ABORT����(Ĭ��ΪOFF)        
begin tran --��������        
declare @jsrq varchar(20)             
declare @ksrq varchar(20)         
        
set @ksrq=@date1        
set @jsrq=@date2        
        
--set @ksrq=@date1        
--set @jsrq=convert(varchar(10),DATEADD(day,1,@date2),120)        
        
--������ʱ��        
if exists(select * from sysobjects where name='#ba1' and xtype='U')         
BEGIN        
 DROP TABLE #ba1        
END        
ELSE        
BEGIN         
 --������ҳ��Ϣ��        
 create table #ba1                                      
 (        

  FSYXH varchar(20) NOT NULL,    --��ҳ���                                      
  FIFINPUT bit NOT NULL default(0),    --�Ƿ�����         
  FPRN varchar(20) NOT NULL,   --������         
  FTIMES int NULL,      --סԺ����         
  FICDVERSION tinyint NULL,    --ICD�汾         
  FZYID varchar(20) NULL,    --סԺ��ˮ��         
  FAGE varchar(20) NULL,    --���䣨Y/M/D ��ͷ��        
  FAGENEW varchar(20) NULL,    --���䣨�꣩        
  FNLBZYZS NUMERIC(4,2) NULL,    --���䲻��һ���� ����ȡ          
  FNAME varchar(100) NULL,    --��������         
  FSEXBH varchar(20) NULL,    --�Ա���         
  FSEX varchar(20) NULL,    --�Ա�         
  FBIRTHDAY datetime NULL,    --��������         
  FBIRTHPLACE varchar(100) NULL,   --������_ʡ��        
  FBIRTHPLACE_QX varchar(100) NULL,  --������_����         
  FIDCARD varchar(30) NULL,    --���֤��         
  FCOUNTRYBH varchar(20) NULL,   --�������         
  FCOUNTRY varchar(100) NULL,   --����         
  FNATIONALITYBH varchar(20) NULL,  --������         
  FNATIONALITY varchar(50) NULL,  --����         
  FJOB varchar(100) NULL,    --ְҵ         
  FSTATUSBH varchar(20) NULL,   --����״�����         
  FSTATUS varchar(20) NULL,    --����״��         
  FDWNAME varchar(200) NULL,    --��λ����         
  FDWADDR varchar(200) NULL,    --��λ��ַ        
  FDWADDRBZ varchar(200) NULL,    --��λ��ַ1
  FHKADDRBZ varchar(200) NULL,    --���ڵ�ַ(��׼��һ��)  
  FDWTELE varchar(40) NULL,    --��λ�绰         
  FDWPOST varchar(20) NULL,    --��λ�ʱ�         
  FHKADDR varchar(200) NULL,    --���ڵ�ַ         
  FHKPOST varchar(20) NULL,    --�����ʱ�         
  FLXNAME varchar(100) NULL,    --��ϵ��         
  FRELATE varchar(100) NULL,    --�벡�˹�ϵ         
  FLXADDR varchar(200) NULL,    --��ϵ�˵�ַ         
  FLXTELE varchar(40) NULL,    --��ϵ�˵绰         
  FASCARD1 varchar(100) NULL,   --��������         
  FRYDATE datetime NULL,     --��Ժ����         
  FRYTIME varchar(10) NULL,    --��Ժʱ��         
  FRYTYKH varchar(30) NULL,    --��Ժͳһ�ƺ�         
  FRYDEPT varchar(30) NULL,    --��Ժ�Ʊ�         
  FRYBS varchar(30) NULL,    --��Ժ���� 
  FCYDATE datetime NULL,     --��Ժ����         
  FCYTIME varchar(16) NULL,    --��Ժʱ��         
  FCYTYKH varchar(30) NULL,    --��Ժͳһ�ƺ�         
  FCYDEPT varchar(30) NULL,    --��Ժ�Ʊ�         
  FCYBS varchar(30) NULL,    --��Ժ����         
  FDAYS int NULL,      --ʵ��סԺ����         
  FMZZDBH varchar(20) NULL,    --�ţ���������ϱ���         
  FMZZD varchar(100) NULL,    --�ţ���������ϼ�����         
  FMZDOCTBH varchar(20) NULL,   --�š�����ҽ�����         
  FMZDOCT varchar(50) NULL,    --�š�����ҽ��     
  FRYINFOBH varchar(20) NULL,   --��Ժʱ������        
  FRYINFO  varchar(20) NULL,   --��Ժʱ���        
  FRYZDBH  varchar(20) NULL,   --��Ժ��ϱ���        
  FRYZD varchar(100) NULL,   --��Ժ��ϼ�����        
  FZYZDQZDATE datetime NULL,    --ȷ������        
  FPHZD varchar(200) NULL,    --�������         
  FGMYW varchar(1000) NULL,    --����ҩ��         
  FMZCYACCOBH varchar(20) NULL,   --�������Ժ��Ϸ���������         
  FMZCYACCO varchar(20) NULL,   --�������Ժ��Ϸ���        
  FRYCYACCOBH varchar(20) NULL,   --��Ժ���Ժ��Ϸ���������        
  FRYCYACCO varchar(20) NULL,   --��Ժ���Ժ��Ϸ���         
  FLCBLACCOBH varchar(20) NULL,   --�ٴ��벡����Ϸ���������         
  FLCBLACCO varchar(20) NULL,   --�ٴ��벡����Ϸ���        
  FFSBLACCOBH varchar(20) NULL,   --�����벡����Ϸ���������        
  FFSBLACCO varchar(20) NULL,   --�����벡����Ϸ������        
  FOPACCOBH varchar(20) NULL,   --�������ϱ��        
  FOPACCO  varchar(20) NULL,   --��������
  FBDYSLBH   varchar(20) NULL,   --������ʯ����Ϸ���������  
  FBDYSL   varchar(20) NULL,   --������ʯ����Ϸ������        
  FQJTIMES int NULL,     --���ȴ���         
  FQJSUCTIMES int NULL,     --���ȳɹ�����         
  FKZRBH varchar(20) NULL,    --�����α��         
  FKZR varchar(30) NULL,    --������         
  FZRDOCTBH varchar(30) NULL,   --������������ҽ�����         
  FZRDOCTOR varchar(30) NULL,   --������������ҽ��         
  FZZDOCTBH varchar(30) NULL,   --����ҽ�����         
  FZZDOCT varchar(30) NULL,    --����ҽ��         
  FZYDOCTBH varchar(30) NULL,   --סԺҽ�����         
  FZYDOCT varchar(30) NULL,    --סԺҽ��         
  FJXDOCTBH varchar(30) NULL,   --����ҽʦ���         
  FJXDOCT varchar(30) NULL,    --����ҽʦ         
  FSXDOCTBH varchar(30) NULL,   --ʵϰҽʦ���         
  FSXDOCT varchar(30) NULL,    --ʵϰҽʦ         
  FBMYBH varchar(30) NULL,    --����Ա���         
  FBMY varchar(30) NULL,    --����Ա         
  FZLRBH varchar(20) NULL,    --���������߱��         
  FZLR varchar(20) NULL,    --����������         
  FQUALITYBH varchar(20) NULL,   --�����������         
  FQUALITY varchar(20) NULL,   --��������         
  FZKDOCTBH varchar(20) NULL,   --�ʿ�ҽʦ���         
  FZKDOCT varchar(30) NULL,    --�ʿ�ҽʦ         
  FZKNURSEBH varchar(20) NULL,   --�ʿػ�ʿ���         
  FZKNURSE varchar(30) NULL,   --�ʿػ�ʿ         
  FZKRQ datetime NULL,     --�ʿ�����         
  FSUM1 numeric(18,4) default(0.0000) NULL,    --�ܷ���         
  FXYF numeric(18,4) default(0.0000) NULL,    --��ҩ��         
  FZYF numeric(18,4) default(0.0000) NULL,    --��ҩ��         
  FZCHYF numeric(18,4) default(0.0000) NULL,    --�г�ҩ��         
  FZCYF numeric(18,4) default(0.0000) NULL,    --�в�ҩ��         
  FQTF numeric(18,4) default(0.0000) NULL,    --������         
  FBODYBH varchar(20) NULL,    --�Ƿ�ʬ����         
  FBODY varchar(20) NULL,    --�Ƿ�ʬ��         
  FBLOODBH varchar(20) NULL,   --Ѫ�ͱ��         
  FBLOOD varchar(20) NULL,    --Ѫ��         
  FRHBH varchar(20) NULL,    --RH���         
  FRH varchar(20) NULL,     --RH         
  FBABYNUM int NULL,     --Ӥ����         
  FTWILL bit NULL,      --�Ƿ񲿷ֲ���         
  FZKTYKH varchar(30) NULL,    --�״�ת��ͳһ�ƺ�         
  FZKDEPT varchar(30) NULL,    --�״�ת�ƿƱ�         
  FZKDATE datetime NULL,     --�״�ת������         
  FZKTIME varchar(10) NULL,    --�״�ת��ʱ��         
  FSRYBH varchar(20) NULL,    --����Ա���         
  FSRY varchar(30) NULL,    --����Ա         
  FWORKRQ datetime default(getdate()) NULL,     --��������         
  FJBFXBH varchar(20) NULL,    --�������ͱ��    1 һ�� 2 �� 3����  4 ����  5 ��Σ         
  FJBFX varchar(20) NULL,    --��������         
  FFHGDBH varchar(20) NULL,    --���Ϲ鵵���         
  FFHGD varchar(20) NULL,    --���Ϲ鵵      
  FSOURCEBH varchar(20) NULL,   --������Դ���         
  FSOURCE varchar(100) NULL,    --������Դ         
  FIFSS bit NULL,      --�Ƿ�����         
  FIFFYK bit NULL,      --�Ƿ����븾Ӥ��         
  FYNGR int NULL,      --ҽԺ��Ⱦ����         
  FEXTEND1 varchar(20) NULL,   --��չ1         
  FEXTEND2 varchar(20) NULL,   --��չ2         
  FEXTEND3 varchar(20) NULL,   --��չ3         
  FEXTEND4 varchar(20) NULL,   --��չ4         
  FEXTEND5 varchar(20) NULL,   --��չ5         
  FEXTEND6 varchar(20) NULL,   --��չ6         
  FEXTEND7 varchar(20) NULL,   --��չ7         
  FEXTEND8 varchar(20) NULL,   --��չ8         
  FEXTEND9 varchar(20) NULL,   --��չ9         
  FEXTEND10 varchar(20) NULL,   --��չ10         
  FEXTEND11 varchar(20) NULL,   --��չ11        
  FEXTEND12 varchar(20) NULL,   --��չ12         
  FEXTEND13 varchar(20) NULL,   --��չ13         
  FEXTEND14 varchar(20) NULL,   --��չ14         
  FEXTEND15 varchar(20) NULL,   --��չ15         
  FNATIVE varchar(100) NULL,    --����        
  FNATIVE_QX varchar(100) NULL,   --����_����         
  FCURRADDR varchar(100) NULL,   --��סַ_ʡ        
  FCURRADDR_X varchar(100) NULL,   --��סַ_��        
  FCURRADDR_JD varchar(100) NULL,   --��סַ_�ֵ�        
  FCURRADDRBZ varchar(200) NULL,   --��סַ_ǰ         
  FCURRTELE varchar(40) NULL,   --�ֵ绰         
  FCURRPOST varchar(20) NULL,   --���ʱ�         
  FJOBBH varchar(20) NULL,    --ְҵ���         
  FCSTZ float NULL,      --��������������         
  FRYTZ float NULL,      --��������Ժ����         
  FRYTJBH varchar(20) NULL,    --��Ժ;�����         
  FRYTJ varchar(20) NULL,    --��Ժ;��         
  FYCLJBH varchar(20) NULL,    --�ٴ�·���������         
  FYCLJ varchar(20) NULL,    --�ٴ�·������         
  FPHZDBH varchar(30) NULL,    --����������         
  FPHZDNUM varchar(50) NULL,   --�����         
  FIFGMYWBH varchar(20) NULL,   --�Ƿ�ҩ��������         
  FIFGMYW varchar(20) NULL,    --�Ƿ�ҩ�����         
  FNURSEBH varchar(30) NULL,   --���λ�ʿ���         
  FNURSE varchar(30) NULL,    --���λ�ʿ         
  FLYFSBH varchar(20) NULL,    --��Ժ��ʽ���         
  FLYFS varchar(100) NULL,    --��Ժ��ʽ         
  FYZOUTHOSTITAL varchar(200) NULL,  --��Ժ��ʽΪҽ��תԺ�������ҽ�ƻ�������         
  FSQOUTHOSTITAL varchar(200) NULL,  --��Ժ��ʽΪת������������������/��������Ժ�������ҽ�ƻ�������         
  FISAGAINRYBH varchar(20) NULL,  --�Ƿ��г�Ժ31������סԺ�ƻ����         
  FISAGAINRY varchar(20) NULL,   --�Ƿ��г�Ժ31������סԺ�ƻ�         
  FISAGAINRYMD varchar(400) NULL,  --��סԺĿ��         
  FRYQHMDAYS int NULL,     --­�����˻��߻���ʱ�䣺��Ժǰ ��         
  FRYQHMHOURS int NULL,     --­�����˻��߻���ʱ�䣺��Ժǰ Сʱ         
  FRYQHMMINS int NULL,     --­�����˻��߻���ʱ�䣺��Ժǰ ����         
  FRYQHMCOUNTS int NULL,    --��Ժǰ�����ܷ���         
  FRYHMDAYS int NULL,     --­�����˻��߻���ʱ�䣺��Ժ�� ��         
  FRYHMHOURS int NULL,     --­�����˻��߻���ʱ�䣺��Ժ�� Сʱ         
  FRYHMMINS int NULL,     --­�����˻��߻���ʱ�䣺��Ժ�� ���� 
  FHMSJ   varchar(30) NULL, --����ʱ��      
  FRYHMCOUNTS int NULL,     --��Ժ������ܷ���         
  FFBBHNEW varchar(20) NULL,   --���ʽ���         
  FFBNEW varchar(30) NULL,    --���ʽ         
  FZFJE numeric(18,4) default(0.0000) NULL,    --סԺ�ܷ��ã��Էѽ��         
  FZHFWLYLF numeric(18,4) default(0.0000) NULL,   --�ۺ�ҽ�Ʒ����ࣺ��1��һ��ҽ�Ʒ����         
  FZHFWLCZF numeric(18,4) default(0.0000) NULL,   --�ۺ�ҽ�Ʒ����ࣺ��2��һ�����Ʋ�����         
  FZHFWLHLF numeric(18,4) default(0.0000) NULL,   --�ۺ�ҽ�Ʒ����ࣺ��3�������         
  FZHFWLQTF numeric(18,4) default(0.0000) NULL,   --�ۺ�ҽ�Ʒ����ࣺ��4����������         
  FZDLBLF numeric(18,4) default(0.0000) NULL,    --����ࣺ(5) ������Ϸ�         
  FZDLSSSF numeric(18,4) default(0.0000) NULL,   --����ࣺ(6) ʵ������Ϸ�         
  FZDLYXF numeric(18,4) default(0.0000) NULL,    --����ࣺ(7) Ӱ��ѧ��Ϸ�         
  FZDLLCF numeric(18,4) default(0.0000) NULL,    --����ࣺ(8) �ٴ������Ŀ��         
  FZLLFFSSF numeric(18,4) default(0.0000) NULL,   --�����ࣺ(9) ������������Ŀ��         
  FZLLFWLZWLF numeric(18,4) default(0.0000) NULL,   --�����ࣺ������������Ŀ�� �����ٴ��������Ʒ�         
  FZLLFSSF numeric(18,4) default(0.0000) NULL,   --�����ࣺ(10) �������Ʒ�         
  FZLLFMZF numeric(18,4) default(0.0000) NULL,   --�����ࣺ�������Ʒ� ���������         
  FZLLFSSZLF numeric(18,4) default(0.0000) NULL,   --�����ࣺ�������Ʒ� ����������         
  FKFLKFF numeric(18,4) default(0.0000) NULL,    --�����ࣺ(11) ������         
  FZYLZF numeric(18,4) default(0.0000) NULL,    --��ҽ�ࣺ��ҽ������         
  FXYLGJF numeric(18,4) default(0.0000) NULL,    --��ҩ�ࣺ ��ҩ�� ���п���ҩ�����         
  FXYLXF numeric(18,4) default(0.0000) NULL,    --ѪҺ��ѪҺ��Ʒ�ࣺ Ѫ��         
  FXYLBQBF numeric(18,4) default(0.0000) NULL,   --ѪҺ��ѪҺ��Ʒ�ࣺ �׵�������Ʒ��         
  FXYLQDBF numeric(18,4) default(0.0000) NULL,   --ѪҺ��ѪҺ��Ʒ�ࣺ �򵰰���Ʒ��         
  FXYLYXYZF numeric(18,4) default(0.0000) NULL,   --ѪҺ��ѪҺ��Ʒ�ࣺ��Ѫ��������Ʒ��         
  FXYLXBYZF numeric(18,4) default(0.0000) NULL,   --ѪҺ��ѪҺ��Ʒ�ࣺ ϸ���������         
  FHCLCJF numeric(18,4) default(0.0000) NULL,    --�Ĳ��ࣺ�����һ����ҽ�ò��Ϸ�         
  FHCLZLF numeric(18,4) default(0.0000) NULL,    --�Ĳ��ࣺ������һ����ҽ�ò��Ϸ�         
  FHCLSSF numeric(18,4) default(0.0000) NULL,    --�Ĳ��ࣺ������һ����ҽ�ò��Ϸ�         
  FZHFWLYLF01 numeric(18,4) default(0.0000) NULL,   --�ۺ�ҽ�Ʒ����ࣺһ��ҽ�Ʒ���� ������ҽ��֤���ηѣ���ҽ��         
  FZHFWLYLF02 numeric(18,4) default(0.0000) NULL,   --�ۺ�ҽ�Ʒ����ࣺһ��ҽ�Ʒ���� ������ҽ��֤���λ���ѣ���ҽ��         
  FZYLZDF numeric(18,4) default(0.0000) NULL,    --��ҽ�ࣺ��ϣ���ҽ��         
  FZYLZLF numeric(18,4) default(0.0000) NULL,    --��ҽ�ࣺ���ƣ���ҽ��         
  FZYLZLF01 numeric(18,4) default(0.0000) NULL,   --��ҽ�ࣺ���� �������Σ���ҽ��         
  FZYLZLF02 numeric(18,4) default(0.0000) NULL,   --��ҽ�ࣺ���� ���й��ˣ���ҽ��         
  FZYLZLF03 numeric(18,4) default(0.0000) NULL,   --��ҽ�ࣺ���� ���������ķ�����ҽ��         
  FZYLZLF04 numeric(18,4) default(0.0000) NULL,   --��ҽ�ࣺ�����������ƣ���ҽ��         
  FZYLZLF05 numeric(18,4) default(0.0000) NULL,   --��ҽ�ࣺ���� ���иس����ƣ���ҽ��         
  FZYLZLF06 numeric(18,4) default(0.0000) NULL,   --��ҽ�ࣺ���� �����������ƣ���ҽ��         
  FZYLQTF numeric(18,4) default(0.0000) NULL,    --��ҽ�ࣺ��������ҽ��         
  FZYLQTF01 numeric(18,4) default(0.0000) NULL,   --��ҽ�ࣺ���� ������ҩ�������ӹ�����ҽ��         
  FZYLQTF02 numeric(18,4) default(0.0000) NULL,   --��ҽ�ࣺ���� ���б�֤ʩ�ţ���ҽ��         
  FZCLJGZJF numeric(18,4) default(0.0000) NULL,   --��ҩ�ࣺ�г�ҩ�� ����ҽ�ƻ�����ҩ�Ƽ��ѣ���ҽ��         
  NLDAYS int NULL,          --���䣨�����㣩        
  FCURRADDRBH  varchar(100) null,       --��סַ���        
  fhkaddrbh varchar(100) null,       --���ڵ�ַ���        
  fdwaddrbh varchar(100) null,       --��λ��ַ���        
  flxaddrbh varchar(100) null,       --��ϵ��ַ���        
  FBIRTHPLACEBH varchar(100) null,      --������ַ���        
  FNATIVEBH varchar(100) null,        --�����ַ���    
  --ʯ��ʡ���汾�ֶ�
    FCFFMFSBH VARCHAR (20) null,  --���䷽ʽ
	FHBSAGBH VARCHAR (20) null,  --������:HBsAg
	FHCVABBH VARCHAR (20) null,  --������:HCV-Ab
	FHIVABBH VARCHAR (20) null,  --������:HIV-Ab
	FREDCELL INT null,  --��ϸ������λ��
	FPLAQUE INT null,  --ѪС�壨����
	FSEROUS INT null,  --Ѫ����ml��
	FALLBLOOD NUMERIC (18) null,  --ȫѪ��ml��
	FQTXHS INT null,  --����Ѫ���գ�ml��
	FOTHERBLOOD INT null,  --������ml��
	FHLTJ NUMERIC (18,1) null,  --�ؼ������죩
	FHL1 NUMERIC (18,1) null,  --һ�������죩
	FHL2 NUMERIC (18,1) null,  --���������죩
	FHL3 NUMERIC (18,1) null,  --���������죩
	FISOPFIRSTBH VARCHAR (20) null,  --���������ơ���顢���Ϊ��Ժ��һ��
	FSZQX VARCHAR (20) null,  --�������ޣ���
	FSZQXY VARCHAR (20) null,  --�������ޣ���
	FSZQXN VARCHAR (20) null,  --�������ޣ���
	FHZQKBH VARCHAR (20) null,  --���޻����¼
	FCFFMFS VARCHAR (20) null,  --���䷽ʽ
	FHBSAG VARCHAR (20) null,  --������:HBsAg
	FHCVAB VARCHAR (20) null,  --������:HCV-Ab
	FHIVAB VARCHAR (20) null,  --������:HIV-Ab
	FISOPFIRST VARCHAR (20) null,  --���������ơ���顢���Ϊ��Ժ��һ��   
	FISSZBH VARCHAR(8) null,  --����
	FMZXYSXZD VARCHAR(200) null,  --��д���
	FRYXYSXZD VARCHAR(200) null,  --��д���
	fphsxzd VARCHAR(200) null,  --��д���
    [fryzlkmbh] [varchar](30) NULL,
	[fryzlkm] [varchar](30) NULL,
	[fzkzlkmbh] [varchar](30) NULL,
	[fzkzlkm] [varchar](30) NULL,
	[fcyzlkmbh] [varchar](30) NULL,
	[fcyzlkm] [varchar](30) NULL,
			fyydm          varchar(100) NULL   --ҽԺ����
  )          
END        
if exists(select * from sysobjects where name='#ba2' and xtype='U')         
BEGIN        
 DROP TABLE #ba2        
END        
ELSE        
BEGIN        
 --����ת�Ʊ�        
 create table #ba2                                 
 (                         
  FSYXH varchar(20) NOT NULL,    --��ҳ���                      
  FPRN varchar(20) NULL,  --������        
  FTIMES int NOT NULL,    --����        
  FZKTYKH varchar(30) NULL,  --ת��ͳһ�ƺ�        
  FZKDEPT varchar(30) NULL,  --ת�ƿƱ�        
  FZKDATE datetime NULL,   --ת������        
  FZKTIME varchar(10) NULL,  --ת��ʱ��   
    fyydm          varchar(100) NULL   --ҽԺ����                  
                      
 )           
END        
if exists(select * from sysobjects where name='#ba3' and xtype='U')         
BEGIN        
 DROP TABLE #ba3        
END        
ELSE        
BEGIN        
 --������ϱ�        
 create table #ba3                                      
 (             
  FSYXH varchar(20) NOT NULL,    --��ҳ���                         
  FPRN varchar(20) NULL,  --������        
  FTIMES int NULL,    --����        
  FZDLX varchar(20) NULL,  --�������        
  FICDVERSION tinyint NULL,  --ICD�汾        
  FICDM varchar(30) NULL,  --ICD��        
  FJBNAME varchar(200) NULL,  --��������        
  FRYBQBH varchar(20) NULL,  --��Ժ������        
  FRYBQ varchar(20) NULL,  --��Ժ����          
  FZLJGBH    varchar(20) NULL ,        
  FZLJG      varchar(20) NULL ,
  FSXZD      varchar(200) NULL ,
  fyydm          varchar(100) NULL   --ҽԺ����        
 )           
END        
if exists(select * from sysobjects where name='#ba4' and xtype='U')         
BEGIN        
 DROP TABLE #ba4        
END        
ELSE        
BEGIN        
 --����������        
 create table #ba4                                      
 (                         
  FSYXH varchar(20) NOT NULL,    --��ҳ���                      
  FPRN varchar(20) NULL,  --������        
  FTIMES int NULL,    --����        
  FNAME varchar(30) NULL,  --��������        
  FOPTIMES int NULL,   --��������        
  FOPCODE varchar(30) NULL,  --������        
  FOP varchar(200) NULL,   --�������Ӧ����        
  FOPDATE datetime NULL,   --��������        
  FQIEKOUBH varchar(20) NULL, --�пڱ��        
  FQIEKOU varchar(20) NULL,  --�п�        
  FYUHEBH varchar(20) NULL,  --���ϱ��        
  FYUHE varchar(20) NULL,  --����        
  FDOCBH varchar(30) NULL,  --����ҽ�����        
  FDOCNAME varchar(30) NULL, --����ҽ��        
  FMAZUIBH varchar(20) NULL, --����ʽ���        
  FMAZUI varchar(30) NULL,  --����ʽ        
  FIFFSOP bit NULL,    --�Ƿ񸽼�����        
  FOPDOCT1BH varchar(30) NULL, --I�����        
  FOPDOCT1 varchar(30) NULL, --I������        
  FOPDOCT2BH varchar(30) NULL, --II�����        
  FOPDOCT2 varchar(30) NULL, --II������        
  FMZDOCTBH varchar(30) NULL, --����ҽ�����          
  FMZDOCT varchar(30) NULL,  --����ҽ��        
  FZQSSBH varchar(20) NULL,  --�����������   1 ����        
  FZQSS varchar(20) NULL,  --��������        
  FSSJBBH varchar(20) NULL,  --����������        
  FSSJB varchar(20) NULL,  --��������        
  FOPKSNAME varchar(30) NULL, --����ҽ�����ڿ�������        
  FOPTYKH varchar(30) NULL,  --����ҽ�����ڿ��ұ��             
  FZYID varchar(20) NULL,      ---his��ҳ���     
 -- FZQSSBH VARCHAR(20) null,  --��������
FFJHZSSBH VARCHAR(20) null,  --�Ƿ�Ǽƻ�������
FIFSHBFZBH VARCHAR(20) null,  --�Ƿ������󲢷�֢
FSHBFZBH VARCHAR(20) null,  --���󲢷�֢
FIFOPBH VARCHAR(20) null,  --�Ƿ�����
FIFJRSSBH VARCHAR(20) null,  --�Ƿ��������
FSSKSSJ datetime null,  --������ʼʱ��
FSSJSSJ datetime null,  --��������ʱ��
FSSCXSJ VARCHAR(20) null,  --����ʱ��
FSSXZBH VARCHAR(20) null,  --��������
FSSLBBH VARCHAR(20) null,  --�������
FIFXJSXMBH VARCHAR(20) null,  --��չ�����Ƿ�Ϊ�¼���
FMZKSSJ datetime null,  --����ʼʱ��
FMZJSSJ datetime null,  --�������ʱ��
FMZFJBH VARCHAR(20) null,  --����ּ�
FMZBFZBH VARCHAR(20) null,  --������֢
FSSLTZZSBJBH VARCHAR(20) null,  --����������֯�Ƿ��Ͳ���
FSSFXFJBH VARCHAR(20) null,  --�������շּ�
FIFYFDSSBH VARCHAR(20) null,  --�Ƿ��и�������
FSSFLBH VARCHAR(20) null,  --��������
FSSBWGRBH VARCHAR(20) null,  --���������Ƿ��Ⱦ
FGRBWBH VARCHAR(20) null,  --��Ⱦ��λ
FIFSHSWBH VARCHAR(20) null,  --�����Ƿ�����
FSHSWSJ VARCHAR(20) null,  --��������ʱ��
FSQYFSYKJYWBH VARCHAR(20) null,  --��ǰ�Ƿ�Ԥ��ʹ�ÿ���ҩ��
FSQSYYFKJYWSJ VARCHAR(20) null,  --��ǰԤ���ÿ���ҩ��ʱ��
FSZZJKJYWBH VARCHAR(20) null,  --�����Ƿ�׷��1������ҩ��
FSZZJKJYWYYBH VARCHAR(20) null,  --����׷��1������ҩ��ԭ��
FSHYFSYKJYWBH VARCHAR(20) null,  --�����Ƿ�Ԥ��ʹ�ÿ���ҩ��
FSHYFYKJYWSJ VARCHAR(20) null,  --����Ԥ���ÿ���ҩ��ʱ��
FSSYPFZBFFBH VARCHAR(20) null,  --����ҰƤ��׼������
FSZBDJCBH VARCHAR(20) null,  --���б������
FYWFJHZSSBH VARCHAR(20) null,  --���޷Ǽƻ�������
FIFSZSXBH VARCHAR(20) null,  --�Ƿ�������Ѫ
FSZCXL VARCHAR(30) null,  --���г�Ѫ��
FSZSXPZBH VARCHAR(20) null,  --������ѪƷ��
--FSZSXL VARCHAR(30) null,  --������Ѫ��
FSSBDYSLBLZDBH VARCHAR(20) null,  --����������ʯ��������Ϸ������
FSQYSHBLZDBH VARCHAR(20) null,  --����ǰ����������Ϸ������
FIFSZYWYLBH VARCHAR(20) null,  --�����Ƿ�����������
FQSMZSFTWXHBH VARCHAR(20) null,  --ȫ���������Ƿ�������ѭ��
FMZYSZTZLBH VARCHAR(20) null,  --�Ƿ�������ҽʦʵʩ��ʹ����
FMZYSZTZLSJBH VARCHAR(20) null,  --������ʦ��ʹ����ʱ��
FMZYSXFFSZLBH VARCHAR(20) null,  --�Ƿ�������ҽʦʵʩ�ķθ�������
FIFXFFSCGBH VARCHAR(20) null,  --�ķθ����Ƿ�ɹ�
FIFSTEWARDBH VARCHAR(20) null,  --�Ƿ������գ�Steward�������֣����� 
FJRMZFSSBH VARCHAR(20) null,  --�Ƿ������������
FSTEWARDPF VARCHAR(20) null,  --����ʱSteward����
FFSMZFYQSJBH VARCHAR(20) null,  --�Ƿ��������Ԥ�ڵ�����¼�
FMZFYQXGSJBH VARCHAR(20) null,  --�����Ԥ�ڵ�����¼�
--FZQSS VARCHAR(20) null,  --��������
FFJHZSS VARCHAR(20) null,  --�Ƿ�Ǽƻ�������
FIFSHBFZ VARCHAR(20) null,  --�Ƿ������󲢷�֢
FSHBFZ VARCHAR(20) null,  --���󲢷�֢
FIFOP VARCHAR(20) null,  --�Ƿ�����
FIFJRSS VARCHAR(20) null,  --�Ƿ��������
FSSXZ VARCHAR(20) null,  --��������
FSSLB VARCHAR(20) null,  --�������
FIFXJSXM VARCHAR(20) null,  --��չ�����Ƿ�Ϊ�¼���
FMZFJ VARCHAR(200) null,  --����ּ�
FMZBFZ VARCHAR(20) null,  --������֢
FSSLTZZSBJ VARCHAR(20) null,  --����������֯�Ƿ��Ͳ���
FSSFXFJ VARCHAR(20) null,  --�������շּ�
FIFYFDSS VARCHAR(20) null,  --�Ƿ��и�������
FSSFL VARCHAR(20) null,  --��������
FSSBWGR VARCHAR(20) null,  --���������Ƿ��Ⱦ
FGRBW VARCHAR(20) null,  --��Ⱦ��λ
FIFSHSW VARCHAR(20) null,  --�����Ƿ�����
FSQYFSYKJYW VARCHAR(20) null,  --��ǰ�Ƿ�Ԥ��ʹ�ÿ���ҩ��
FSZZJKJYW VARCHAR(20) null,  --�����Ƿ�׷��1������ҩ��
FSZZJKJYWYY VARCHAR(50) null,  --����׷��1������ҩ��ԭ��
FSHYFSYKJYW VARCHAR(20) null,  --�����Ƿ�Ԥ��ʹ�ÿ���ҩ��
FSSYPFZBFF VARCHAR(50) null,  --����ҰƤ��׼������
FSZBDJC VARCHAR(20) null,  --���б������
FYWFJHZSS VARCHAR(20) null,  --���޷Ǽƻ�������
FIFSZSX VARCHAR(20) null,  --�Ƿ�������Ѫ
FSZSXPZ VARCHAR(200) null,  --������ѪƷ��
FSSBDYSLBLZD VARCHAR(20) null,  --����������ʯ��������Ϸ������
FSQYSHBLZD VARCHAR(20) null,  --����ǰ����������Ϸ������
FIFSZYWYL VARCHAR(20) null,  --�����Ƿ�����������
FQSMZSFTWXH VARCHAR(20) null,  --ȫ���������Ƿ�������ѭ��
FMZYSZTZL VARCHAR(20) null,  --�Ƿ�������ҽʦʵʩ��ʹ����
FMZYSZTZLSJ VARCHAR(20) null,  --������ʦ��ʹ����ʱ��
FMZYSXFFSZL VARCHAR(20) null,  --�Ƿ�������ҽʦʵʩ�ķθ�������
FIFXFFSCG VARCHAR(20) null,  --�ķθ����Ƿ�ɹ�
FIFSTEWARD VARCHAR(20) null,  --�Ƿ������գ�Steward�������֣����� 
FJRMZFSS VARCHAR(20) null,  --�Ƿ������������
FFSMZFYQSJ VARCHAR(20) null, --�Ƿ��������Ԥ�ڵ�����¼�
FMZFYQXGSJ VARCHAR(50) null , --�����Ԥ�ڵ�����¼� 
fyydm       varchar(100) NULL   --ҽԺ����          
 )           
END        
if exists(select * from sysobjects where name='#ba5' and xtype='U')         
BEGIN        
 DROP TABLE #ba5        
END        
ELSE        
BEGIN        
 --������Ӥ��        
 create table #ba5                                      
 (              
  FSYXH varchar(20) NOT NULL,    --��ҳ���                                 
  FPRN varchar(20) NULL,  --������        
  FTIMES int NULL,    --����        
  FBABYNUM int NULL,   --Ӥ�����        
  FNAME varchar(30) NULL,  --��������        
  FBABYSEXBH varchar(20) NULL, --Ӥ���Ա���        
  FBABYSEX varchar(4) NULL, --Ӥ���Ա�        
  FTZ float NULL,     --Ӥ������        
  FRESULTBH varchar(20) NULL, --���������        
  FRESULT varchar(20) NULL,  --������        
  FZGBH varchar(20) NULL,  --ת����        
  FZG varchar(20) NULL,   --ת��        
  FBABYSUC int NULL,   --Ӥ�����ȳɹ�����        
  FHXBH varchar(20) NULL,  --�������        
  FHX varchar(20) NULL,   --���� 
  fyydm       varchar(100) NULL   --ҽԺ����                       
 )           
END        
if exists(select * from sysobjects where name='#ba8' and xtype='U')         
BEGIN        
 DROP TABLE #ba8        
END        
ELSE        
BEGIN        
 --������ҽ��        
 create table #ba8                  
 (        
  FSYXH varchar(20) NOT NULL,    --��ҳ���                                 
  FPRN varchar(20) NULL,   --������        
  FTIMES int NULL,     --����        
  FZLLBBH varchar(20) NULL,   --���������        
  FZLLB varchar(20) NULL,   --�������        
  FZZZYBH varchar(20) NULL,   --������ҩ�Ƽ����        
  FZZZY varchar(20) NULL,   --������ҩ�Ƽ�        
  FRYCYBH varchar(20) NULL,   --��ҽ��Ժ���Ժ���ϱ��        
  FRYCY varchar(20) NULL,   --��ҽ��Ժ���Ժ����        
  FMZZDZBBH varchar(20) NULL,  --��ҽ�������(����)���        
  FMZZDZB varchar(100) NULL,   --��ҽ�������(����)����        
  FMZZDZZBH varchar(20) NULL,  --��ҽ�������(��֤)���        
  FMZZDZZ varchar(100) NULL,   --��ҽ�������(��֤)����        
  FMZZYZDBH varchar(30) NULL,  --�ţ���������ҽ��ϱ���        
  FMZZYZD varchar(200) NULL,   --�ţ���������ҽ���        
  FSSLCLJBH varchar(20) NULL,  --ʵʩ�ٴ�·�����        
  FSSLCLJ varchar(20) NULL,   --ʵʩ�ٴ�·��        
  FSYJGZJBH varchar(20) NULL,  --ʹ��ҽ�ƻ�����ҩ�Ƽ����        
  FSYJGZJ varchar(20) NULL,   --ʹ��ҽ�ƻ�����ҩ�Ƽ�        
  FSYZYSBBH varchar(20) NULL,  --ʹ����ҽ�����豸���        
  FSYZYSB varchar(20) NULL,   --ʹ����ҽ�����豸        
  FSYZYJSBH varchar(20) NULL,  --ʹ����ҽ���Ƽ������        
  FSYZYJS varchar(20) NULL,   --ʹ����ҽ���Ƽ���        
  FBZSHBH varchar(20) NULL,   --��֤ʩ�����        
  FBZSH varchar(20) NULL,   --��֤ʩ��
  fyydm       varchar(100) NULL   --ҽԺ����                       
 )           
END      


if exists(select * from sysobjects where name='#His_ba_ahfy' and xtype='U')         
BEGIN        
 DROP TABLE #His_ba_ahfy        
END        
ELSE        
BEGIN    
 create table #His_ba_ahfy                                      
 (   
  FSYXH varchar(20) NOT NULL,    --��ҳ���
  FPRN varchar(20) NULL,   --������        
  FTIMES int NULL,     --���� 
  FKSSSYFA VARCHAR(4) null,  --������ҩ����
FKSSSYSJ INT null,  --����ʹ��ʱ�䣨Сʱ��
FJRSJ DATETIME null,  --����ʱ��
FZCSJ DATETIME null,  --����ʱ��
fyydm       varchar(100) NULL   --ҽԺ���� 
  )  
END   

if exists(select * from sysobjects where name='#His_BaFy' and xtype='U')         
BEGIN        
 DROP TABLE #His_BaFy        
END        
ELSE        
BEGIN    
 create table #His_BaFy                                      
 (   
  FSYXH varchar(20) NOT NULL,    --��ҳ���
  FPRN varchar(20) NULL,   --������        
  FTIMES int NULL,     --���� 
FIFFMBH VARCHAR(20) null,  --���ƻ����Ƿ����
FCS VARCHAR(20) null,  --���Ʋ����Ƿ�������
FCSDSBH VARCHAR(20) null,  --���˶���
FHCXSES INT null,  --�������������
FXSETZDY2KBH VARCHAR(20) null,  --���������������Ƿ����2000��
FIFZCBH VARCHAR(20) null,  --�Ƿ������
FXSECSBH VARCHAR(20) null,  --�������Ƿ�������
FXSECSGS INT null,  --�������������˸���
FISZRY VARCHAR(20) null,  --�Ƿ�����Ժ����
FBCYSCCYJG VARCHAR(50) null,  --����סԺ���ϴγ�Ժ���
FZRYYYBH VARCHAR(20) null,  --����Ժԭ��
FRYBQFJBH VARCHAR(20) null,  --��Ժ����ּ�
FZYZDLXBH VARCHAR(20) null,  --��Ҫ�����Ч
FCYZDLXBH VARCHAR(20) null,  --��Ҫ�����Ч
FZGZDYJBH VARCHAR(20) null,  --�����������������
FLCLJBL VARCHAR(20) null,  --�Ƿ�����ٴ�·������
FSYFYFSCS INT null,  --  ��Һ��Ӧ��������
FSYFY_FY VARCHAR(20) null,  --������Һ��Ӧ
FSXFY_FY VARCHAR(20) null,  --������Ѫ��Ӧ
FSXFYFSCS INT null,  --��Ѫ��Ӧ��������
F24HSXLBH VARCHAR(20) null,  --24Сʱ����Ѫ���Ƿ�1600ml
FWZBL VARCHAR(20) null,  --Σ�ز���
FYNBL VARCHAR(20) null,  --���Ѳ���
FISSZBH VARCHAR(8) null,  --����
FDBZ_HN VARCHAR(20) null,  --�������������Ʋ���
FDRGGL VARCHAR(20) null,  --��ؼ�����Ϸ��飨DRGs��
FIFABZFFBLBH VARCHAR(20) null,  --�Ƿ񰴲��ָ��Ѳ���
FSSKJYW VARCHAR(20) null,  --�Ƿ񿹾�ҩ������
FIFYFXSYBH VARCHAR(20) null,  --�Ƿ�Ԥ����ʹ��
FZYKJYW_VALUE VARCHAR(200) null,  --����ҩ������
FSFZJKJYWBH VARCHAR(20) null,  --�Ƿ����⼶����ҩ��
FKJYWSBYXJC VARCHAR(20) null,  --�Ƿ��в�ԭѧ���
FWSWJCJGBH VARCHAR(20) null,  --΢��������
FYYXSS VARCHAR(20) null,  --�Ƿ���ҽԴ���˺�
FHZAQSJ VARCHAR(20) null,  --ҽԴ���˺�����
FZZJH VARCHAR(20) null,  --��֢�໤ʱ��
FSFYNGR VARCHAR(20) null,  --�Ƿ���ҽԺ�ڸ�Ⱦ
FSYZXJMZG VARCHAR(20) null,  --�Ƿ�ʹ�����ľ����ù�
FZXJMZGSYTS INT null,  --ʹ�����ľ����ù����������죩
FGLHTZXJMGBH VARCHAR(20) null,  --�Ƿ�����·����
FDGHTYZC VARCHAR(20) null,  --�Ƿ��ٲ���
FSYZXJMZGGR VARCHAR(20) null,  --�Ƿ������ľ����ù����Ѫ����Ⱦ
FSYLZDNG VARCHAR(20) null,  --�Ƿ�ʹ�����õ����
FLZDNGSYTS INT null,  --ʹ�����õ�������������죩
FIFGLHTBH VARCHAR(20) null,  --�Ƿ�����·����
FIFZCRBH VARCHAR(20) null,  --�Ƿ��ٲ���
FSYLZDNGGR VARCHAR(20) null,  --�Ƿ������õ�����������ϵ��Ⱦ
FXYTX VARCHAR(20) null,  --�Ƿ�ѪҺ͸������
FXYTXTS INT null,  --ѪҺ͸�����������죩
FSFXYTXGR VARCHAR(20) null,  --�Ƿ���ѪҺ͸����Ⱦ
FSYHXJ VARCHAR(20) null,  --�Ƿ�ʹ�ú�����
FSYHXJGR VARCHAR(20) null,  --�Ƿ���ʹ�ú�������ط��׸�Ⱦ
FSYXHJTS INT null,  --ʹ�ú�����������(�죩
FYHXJSJ INT null,  --������ʹ��ʱ�䣨Сʱ��
FZRICU VARCHAR(20) null,  --�Ƿ����ICU
FRZICUCS VARCHAR(20) null,  --ICU��ס����
FIFJHRZBH VARCHAR(20) null,  --�ٴ���ס�Ƿ����ƻ���ס
FZRICUSW VARCHAR(20) null,  --�����Ƿ���ICU������
FSFCFZZYXK VARCHAR(20) null,  --��Ԥ��24/48Сʱ�ط����
FTGCTTS INT null,  --��ʹ�ú����������̧�ߴ�ͷ����=30�ȣ�ÿ��2�Σ�
FYYCWSW VARCHAR(20) null,  --�Ƿ�����
FFSYC VARCHAR(20) null,  --����ICUǰ�Ƿ���ѹ��
FSFFSYC VARCHAR(20) null,  --��ICU�ڼ��Ƿ���ѹ��
FIFAPACCHEBH VARCHAR(20) null,  --�Ƿ�APACCHE II����
FAPACCHEPF INT null,  --APACCHE II����
FSFQDTC VARCHAR(20) null,  --�Ƿ����˹������ѳ�
FZRYYY VARCHAR(20) null,  --EMR_BASYK_FB.ZZYYY
FRYBQFJ VARCHAR(20) null,  --EMR_BASYK.RYQK
FZYZDLX VARCHAR(20) null,  --EMR_BASYK.ZLJG
FCYZDLX VARCHAR(20) null,  --EMR_BASYK_FB.ZDYJ
FZGZDYJ VARCHAR(200) null,  --EMR_BASYK_FB.BLZGZDYJ
F24HSXL VARCHAR(20) null,  --EMR_BASYK_FB.SXLDY
FISSZ VARCHAR(8) null,  --EMR_BASYK.SZQK
FIFABZFFBL VARCHAR(20) null,  --EMR_BASYK_FB.SFSRJJXFBZ
FGLHTZXJMG VARCHAR(20) null,  --EMR_BASYK_FB.JZGSFGLHT
FSY VARCHAR(2) null,  --�Ƿ���Һ
FSX VARCHAR(2) null,  --�Ƿ���Ѫ
FHMSJ   varchar(50) NULL, --����ʱ��  
fyydm       varchar(100) NULL   --ҽԺ���� 
  )  
END  


--if exists(select * from sysobjects where name='#his_ba13' and xtype='U')         
--BEGIN        
-- DROP TABLE #his_ba13        
--END        
--ELSE        
--BEGIN    
-- create table #his_ba13                                      
-- (   
--  FPRN varchar(20) NULL,   --������        
--  FTIMES int NULL,     --���� 

--  )   
--END  
        
if exists(select * from sysobjects where name='#ba101' and xtype='U')         
BEGIN        
 DROP TABLE #ba101        
END        
ELSE        
BEGIN         
 --������ҳ��Ϣ��(����)        
 create table #ba101         
 (            
  --FSYXH varchar(20) NOT NULL,    --��ҳ���                                   
  FIFINPUT bit NOT NULL default(0),    --�Ƿ�����        
  FICDVERSION tinyint NULL,    --ICD�汾        
  FZYID varchar(20) NULL,    --סԺ��ˮ��        
  FPRN varchar(20) NOT NULL,   --������         
  FTIMES int NULL,      --סԺ����         
  FSUM1 numeric(18,4) default(0.0000) NULL,    --�ܷ���         
  FXYF numeric(18,4) default(0.0000) NULL,    --��ҩ��         
  FZYF numeric(18,4) default(0.0000) NULL,    --��ҩ��         
  FZCHYF numeric(18,4) default(0.0000) NULL,    --�г�ҩ��         
  FZCYF numeric(18,4) default(0.0000) NULL,    --�в�ҩ��         
  FQTF numeric(18,4) default(0.0000) NULL,    --������         
  FZFJE numeric(18,4) default(0.0000) NULL,    --סԺ�ܷ��ã��Էѽ��         
  FZHFWLYLF numeric(18,4) default(0.0000) NULL,   --�ۺ�ҽ�Ʒ����ࣺ��1��һ��ҽ�Ʒ����         
  FZHFWLCZF numeric(18,4) default(0.0000) NULL,   --�ۺ�ҽ�Ʒ����ࣺ��2��һ�����Ʋ�����         
  FZHFWLHLF numeric(18,4) default(0.0000) NULL,   --�ۺ�ҽ�Ʒ����ࣺ��3�������         
  FZHFWLQTF numeric(18,4) default(0.0000) NULL,   --�ۺ�ҽ�Ʒ����ࣺ��4����������         
  FZDLBLF numeric(18,4) default(0.0000) NULL,    --����ࣺ(5) ������Ϸ�         
  FZDLSSSF numeric(18,4) default(0.0000) NULL,   --����ࣺ(6) ʵ������Ϸ�         
  FZDLYXF numeric(18,4) default(0.0000) NULL,    --����ࣺ(7) Ӱ��ѧ��Ϸ�         
  FZDLLCF numeric(18,4) default(0.0000) NULL,    --����ࣺ(8) �ٴ������Ŀ��         
  FZLLFFSSF numeric(18,4) default(0.0000) NULL,   --�����ࣺ(9) ������������Ŀ��         
  FZLLFWLZWLF numeric(18,4) default(0.0000) NULL,   --�����ࣺ������������Ŀ�� �����ٴ��������Ʒ�         
  FZLLFSSF numeric(18,4) default(0.0000) NULL,   --�����ࣺ(10) �������Ʒ�         
  FZLLFMZF numeric(18,4) default(0.0000) NULL,   --�����ࣺ�������Ʒ� ���������         
  FZLLFSSZLF numeric(18,4) default(0.0000) NULL,   --�����ࣺ�������Ʒ� ����������         
  FKFLKFF numeric(18,4) default(0.0000) NULL,    --�����ࣺ(11) ������         
  FZYLZF numeric(18,4) default(0.0000) NULL,    --��ҽ�ࣺ��ҽ������         
  FXYLGJF numeric(18,4) default(0.0000) NULL,    --��ҩ�ࣺ ��ҩ�� ���п���ҩ�����         
  FXYLXF numeric(18,4) default(0.0000) NULL,    --ѪҺ��ѪҺ��Ʒ�ࣺ Ѫ��         
  FXYLBQBF numeric(18,4) default(0.0000) NULL,   --ѪҺ��ѪҺ��Ʒ�ࣺ �׵�������Ʒ��         
  FXYLQDBF numeric(18,4) default(0.0000) NULL,   --ѪҺ��ѪҺ��Ʒ�ࣺ �򵰰���Ʒ��         
  FXYLYXYZF numeric(18,4) default(0.0000) NULL,   --ѪҺ��ѪҺ��Ʒ�ࣺ��Ѫ��������Ʒ��         
  FXYLXBYZF numeric(18,4) default(0.0000) NULL,   --ѪҺ��ѪҺ��Ʒ�ࣺ ϸ���������         
  FHCLCJF numeric(18,4) default(0.0000) NULL,    --�Ĳ��ࣺ�����һ����ҽ�ò��Ϸ�         
  FHCLZLF numeric(18,4) default(0.0000) NULL,    --�Ĳ��ࣺ������һ����ҽ�ò��Ϸ�         
  FHCLSSF numeric(18,4) default(0.0000) NULL,    --�Ĳ��ࣺ������һ����ҽ�ò��Ϸ�         
  FZHFWLYLF01 numeric(18,4) default(0.0000) NULL,   --�ۺ�ҽ�Ʒ����ࣺһ��ҽ�Ʒ���� ������ҽ��֤���ηѣ���ҽ��         
  FZHFWLYLF02 numeric(18,4) default(0.0000) NULL,   --�ۺ�ҽ�Ʒ����ࣺһ��ҽ�Ʒ���� ������ҽ��֤���λ���ѣ���ҽ��         
  FZYLZDF numeric(18,4) default(0.0000) NULL,    --��ҽ�ࣺ��ϣ���ҽ��         
  FZYLZLF numeric(18,4) default(0.0000) NULL,    --��ҽ�ࣺ���ƣ���ҽ��         
  FZYLZLF01 numeric(18,4) default(0.0000) NULL,   --��ҽ�ࣺ���� �������Σ���ҽ��         
  FZYLZLF02 numeric(18,4) default(0.0000) NULL,   --��ҽ�ࣺ���� ���й��ˣ���ҽ��         
  FZYLZLF03 numeric(18,4) default(0.0000) NULL,   --��ҽ�ࣺ���� ���������ķ�����ҽ��         
  FZYLZLF04 numeric(18,4) default(0.0000) NULL,   --��ҽ�ࣺ�����������ƣ���ҽ��         
  FZYLZLF05 numeric(18,4) default(0.0000) NULL,   --��ҽ�ࣺ���� ���иس����ƣ���ҽ��         
  FZYLZLF06 numeric(18,4) default(0.0000) NULL,   --��ҽ�ࣺ���� �����������ƣ���ҽ��         
  FZYLQTF numeric(18,4) default(0.0000) NULL,    --��ҽ�ࣺ��������ҽ��         
  FZYLQTF01 numeric(18,4) default(0.0000) NULL,   --��ҽ�ࣺ���� ������ҩ�������ӹ�����ҽ��         
  FZYLQTF02 numeric(18,4) default(0.0000) NULL,   --��ҽ�ࣺ���� ���б�֤ʩ�ţ���ҽ��         
  FZCLJGZJF numeric(18,4) default(0.0000) NULL  --��ҩ�ࣺ�г�ҩ�� ����ҽ�ƻ�����ҩ�Ƽ��ѣ���ҽ��
                 
  )          
END        
        
if exists(select * from sysobjects where name='#brfymxk' and xtype='U')         
BEGIN        
 DROP TABLE #brfymxk        
END        
ELSE        
BEGIN         
CREATE TABLE #brfymxk (        
  FSYXH varchar(30) NULL ,  --��ҳ���        
  FPRN varchar(20) NULL ,   --������        
  FTIMES int NULL ,      --סԺ����        
  FIDM numeric(9) NULL ,   --ҩIDM        
  FYPDM varchar(24) NULL ,  --ҩƷ����        
  FYPMC varchar(128) NULL ,  --ҩƷ����        
  FDXMDM varchar(12) NULL ,  --����Ŀ����        
  FZJE decimal(15,2) NULL ,  --�ܽ��        
  FZFJE decimal(15,2) NULL , --�Էѽ��        
  FYHJE decimal(15,2) NULL , --�Żݽ��        
  FJLZT smallint NULL    --��¼״̬(0��Ч��¼, 1���ϼ�¼, 2�˷Ѽ�¼)        
)        
END        
        
        
--select A.HISSYXH HISSYXH, A.SYXH EMRSYXH, A.ZYHM ZYHM,-1 QTBLJLXH into #PAT from EMR_BRSYK A         
--where BRZT in (1502,1503,1504) and A.YEXH=0 and convert(varchar(10),CQRQ,126) between  @ksrq and @jsrq        
        
--���emr��ҳ�������                                   
--UPDATE A SET A.QTBLJLXH=B.QTBLJLXH FROM #PAT A,(select QTBLJLXH,SYXH from EMR_QTBLJLK where YXJL=1 and MXFLDM='B-F7') B WHERE A.EMRSYXH=B.SYXH        
UPDATE EMR_BASYK SET HMMIN1='0' WHERE  HMMIN1 ='��'                  
UPDATE EMR_BASYK SET HMMIN2='0' WHERE  HMMIN2 ='��'        
         
--DELETE FROM #PAT WHERE ISNULL(QTBLJLXH,0)<=0          
        
--select A.BRZT, A.HISSYXH HISSYXH, A.SYXH EMRSYXH, A.ZYHM ZYHM,QTBLJLXH INTO #PAT  from EMR_BRSYK A,(select QTBLJLXH,SYXH,TJSJ from EMR_QTBLJLK where YXJL=1 and MXFLDM='B-F7') B        
--WHERE A.SYXH=B.SYXH AND BRZT in (1502,1503,1504) and  A.YEXH=0 AND TJSJ >=@ksrq AND TJSJ<@jsrq        
        
        
        
if @type=0        
 begin        
  select A.BRZT, A.HISSYXH HISSYXH, A.SYXH EMRSYXH, A.ZYHM ZYHM,QTBLJLXH, A.BAHM FPRN, A.RYCS FTIMES        
  INTO #PAT  from EMR_BRSYK A(nolock),(select QTBLJLXH,SYXH,TJSJ from EMR_QTBLJLK(nolock) where YXJL=1 and MXFLDM='B-F7') B        
  WHERE A.SYXH=B.SYXH AND BRZT in (1502,1503,1504) and  A.YEXH=0 AND CONVERT(varchar(10),TJSJ,126) between @ksrq and dateadd(dd,7,@jsrq) --and A.SYXH='624582'
  --  ---zzz
  -- select A.BRZT, A.HISSYXH HISSYXH, A.SYXH EMRSYXH, A.ZYHM ZYHM,QTBLJLXH, A.BAHM FPRN, A.RYCS FTIMES        
  --INTO PAT  from EMR_BRSYK A,(select QTBLJLXH,SYXH,TJSJ from EMR_QTBLJLK where YXJL=1 and MXFLDM='B-F7') B        
  --WHERE A.SYXH=B.SYXH AND BRZT in (1502,1503,1504) and  A.YEXH=0 AND CONVERT(varchar(10),TJSJ,126) between @ksrq and @jsrq
   
  --���������ֶ�        
  select A.HMDAY1,A.HMMIN1,A.HMHOUR1,A.HMDAY2,A.HMMIN2,A.HMHOUR2,A.XSECSTZ,A.XSERYTZ,A.SYXH into #TSZDCL from EMR_BASYK A(nolock),#PAT B WHERE A.SYXH=B.EMRSYXH        
  update #TSZDCL set XSECSTZ='' where PATINDEX('%[^0-9]%',XSECSTZ)<>0            
  update #TSZDCL set XSERYTZ='' where PATINDEX('%[^0-9]%',XSERYTZ)<>0                                                
  update #TSZDCL set HMDAY1=''  where PATINDEX('%[^0-9]%',HMDAY1)<>0                                                
  update #TSZDCL set HMMIN1=''  where PATINDEX('%[^0-9]%',HMMIN1)<>0                                                
  update #TSZDCL set HMHOUR1='' where PATINDEX('%[^0-9]%',HMHOUR1)<>0                                                
  update #TSZDCL set HMDAY2=''  where PATINDEX('%[^0-9]%',HMDAY2)<>0                                                
  update #TSZDCL set HMHOUR2='' where PATINDEX('%[^0-9]%',HMHOUR2)<>0                                                
  update #TSZDCL set HMHOUR2=''  where PATINDEX('%[^0-9]%',HMHOUR2)<>0         
 end        
         
if @type=1        
 begin        
  select A.BRZT, A.HISSYXH HISSYXH, A.SYXH EMRSYXH, A.ZYHM ZYHM,QTBLJLXH, A.BAHM FPRN, A.RYCS FTIMES        
  INTO #PAT2  from EMR_BRSYK A(nolock),(select QTBLJLXH,SYXH,TJSJ from EMR_QTBLJLK (nolock) where YXJL=1 and MXFLDM='B-F7') B        
  WHERE A.SYXH=B.SYXH AND BRZT in (1502,1503,1504) and  A.YEXH=0 AND CONVERT(varchar(10),CQRQ,126) between @ksrq and @jsrq        
 end        
  
   
        
 IF @type=0  
 begin           
       
 --HIS_����סԺ��Ϣ��HIS_BA1��                  
 insert into #ba1(FSYXH,FIFINPUT, FPRN, FTIMES, FICDVERSION, FZYID, FAGE, FAGENEW,FNAME, FSEXBH, FSEX
  ,FBIRTHDAY, FBIRTHPLACE, FBIRTHPLACE_QX,FIDCARD, FCOUNTRYBH, FCOUNTRY, FNATIONALITYBH, FNATIONALITY, FJOB
  ,FSTATUSBH, FSTATUS, FDWNAME,FDWADDR , FDWADDRBZ, FDWTELE, FDWPOST, FHKADDR, FHKPOST, FLXNAME, FRELATE, FLXADDR  
  ,FLXTELE, FASCARD1, FRYDATE, FRYTIME, FRYTYKH, FRYDEPT, FRYBS,FCYDATE, FCYTIME, FCYTYKH, FCYDEPT, FCYBS, FDAYS
  ,FMZZDBH, FMZZD, FMZDOCTBH, FMZDOCT, FZYZDQZDATE, FPHZD, FGMYW  
  ,FMZCYACCOBH, FMZCYACCO, FRYCYACCOBH, FRYCYACCO, FLCBLACCOBH, FLCBLACCO,FFSBLACCOBH,FFSBLACCO,FOPACCOBH,FOPACCO,FBDYSLBH,FBDYSL, FQJTIMES, FQJSUCTIMES                  
  ,FKZRBH,FKZR, FZRDOCTBH, FZRDOCTOR, FZZDOCTBH, FZZDOCT, FZYDOCTBH, FZYDOCT                   
  ,FJXDOCTBH, FJXDOCT, FSXDOCTBH, FSXDOCT, FBMYBH, FBMY, FZLRBH, FZLR, FQUALITYBH, FQUALITY                  
  ,FZKDOCTBH, FZKDOCT, FZKNURSEBH, FZKNURSE, FZKRQ,FBODYBH, FBODY, FBLOODBH, FBLOOD                  
  ,FRHBH, FRH, FBABYNUM, FTWILL, FJBFXBH, FJBFX, FSOURCEBH, FSOURCE, FIFSS, FIFFYK, FYNGR                  
  ,FNATIVE, FNATIVE_QX, FCURRADDR,FCURRADDR_X,FCURRADDR_JD,FCURRTELE, FCURRPOST, FJOBBH, FCSTZ, FRYTZ, FRYTJBH, FRYTJ                  
  ,FYCLJBH, FYCLJ, FPHZDBH, FPHZDNUM,FIFGMYWBH, FIFGMYW, FNURSEBH
  , FNURSE, FLYFSBH, FLYFS,FYZOUTHOSTITAL, FSQOUTHOSTITAL                   
  ,FISAGAINRYBH,FISAGAINRY, FISAGAINRYMD, FRYQHMDAYS, FRYQHMHOURS, FRYQHMMINS                  
  ,FRYQHMCOUNTS                  
  ,FRYHMDAYS, FRYHMHOURS, FRYHMMINS, FRYHMCOUNTS                   
  ,FFBBHNEW, FFBNEW ,FRYZDBH,FRYZD
  ,FCFFMFSBH,FHBSAGBH,FHCVABBH,FHIVABBH,FREDCELL,FPLAQUE,FSEROUS,FALLBLOOD,FQTXHS,FOTHERBLOOD,FHLTJ,FHL1,FHL2,FHL3,FISOPFIRSTBH,FSZQX,FSZQXY,FSZQXN,FHZQKBH,FISSZBH,FMZXYSXZD,FRYXYSXZD,fphsxzd,FHKADDRBZ ,fryzlkmbh,fzkzlkmbh,fcyzlkmbh  ,fyydm            
 )                      
select A.SYXH FSYXH,'0' FIFINPUT, A.BAHM FPRN,B.RYCS FTIMES,'11' FICDVERSION,A.HISSYXH FZYID,A.XSNL FAGE,A.XSNL FAGENEW,A.HZXM FNAME ,A.BRXB FSEXBH ,'' FSEX,                  
  A.CSRQ FBIRTHDAY ,isnull(SSDM,'-') FBIRTHPLACE,isnull(QXDM,'-') FBIRTHPLACE_QX,isnull(A.SFZH,'-') FIDCARD ,A.GJDM FCOUNTRYBH ,'�й�' FCOUNTRY,A.MZDM FNATIONALITYBH ,
  '' FNATIONALITY,'' FJOB,                  
  A.HYZK FSTATUSBH,'' FSTATUS,isnull(substring(A.GZDW,1,30),'-') FDWNAME,isnull(substring(A.GZDW,1,30),'-') FDWADDR,isnull(substring(A.DWDZ,1,30),'-') FDWADDRBZ,isnull(A.DWDH,'-') FDWTELE,isnull(A.DWYB,'-') FDWPOST,
  A.HKDZ FHKADDR,isnull(A.HKYB,'-') FHKPOST,A.LXRM FLXNAME,A.LXGX FRELATE,isnull(substring(A.LXDZ,1,30),'-') FLXADDR,                  
  A.LXDH FLXTELE,B.JKKH FASCARD1,substring(A.RQRQ,1,10) FRYDATE,substring(A.RQRQ,12,5) FRYTIME,A.RYKS FRYTYKH,'' FRYDEPT,A.RYBQ FRYBS
  ,substring(A.CQRQ,1,10) FCYDATE,substring(A.CQRQ,12,5) FCYTIME ,A.CYKS FCYTYKH,'' FCYDEPT,A.CYBQ FCYBS,isnull(B.ZYTS,A.ZYTS) FDAYS
  ,B.MZZD FMZZDBH,isnull(convert(varchar(100),substring(B.MZZDMC,1,30)),'-') FMZZD,B.MZYS FMZDOCTBH,'' FMZDOCT,isnull(dateadd(dd,1,A.RYRQ),B.QZRQ) FZYZDQZDATE,
  isnull(substring(B.BLZDMC,1,30),'-') FPHZD,isnull(B.GMYWMC,'-') FGMYW  
  , B.MCFH FMZCYACCOBH ,'' FMZCYACCO,B.RCFH FRYCYACCOBH,'' FRYCYACCO,B.BLFH FLCBLACCOBH ,'' FLCBLACCO,B.FSFH FFSBLACCOBH,'' FFSBLACCO,B.QHFH FOPACCOBH,'' FOPACCO,B.BDFH FBDYSLBH,'' FBDYSL,B.QJCS FQJTIMES,B.CGCS FQJSUCTIMES,                 
  B.KZR FKZRBH,'' FKZR,B.ZRYS FZRDOCTBH ,'' FZRDOCTBH,B.ZZYS FZZDOCTBH,'' FZZDOCT,B.ZYYS FZYDOCTBH,'' FZYDOCT,                  
  B.JXYS FJXDOCTBH,'' FJXDOCT,B.SXYS2 FSXDOCTBH,'' FSXDOCT,B.BMY FBMYBH,'' FBMY,B.ZLRY FZLRBH,'' FZLR,B.BAZL FQUALITYBH,'' FQUALITY,                  
  B.ZKYS FZKDOCTBH,'' FZKDOCT,B.ZKHS FZKNURSEBH,'' FZKNURSE,CASE WHEN ISNULL(B.BARQ,'')='' THEN NULL ELSE B.BARQ END FZKRQ,B.SJQK FBODYBH,'' FBODY,        
  CASE WHEN B.XXDM='3' THEN '4' WHEN B.XXDM='4' THEN '3' ELSE B.XXDM END FBLOODBH ,'' FBLOOD,                  
  B.RHJY FRHBH,'' FRH,B.YETB FBABYNUM,0 FTWILL,B.BLFX FJBFXBH,'' FJBFX,B.BRLY FSOURCEBH,'' FSOURCE ,B.SSBZ FIFSS ,0 FIFFYK,isnull(GRCS,0) FYNGR,                  
  JGSSDM FNATIVE ,JGQXDM FNATIVE_QX,A.DQDZ_S FCURRADDR,A.DQDZ_X FCURRADDR_X,substring(A.DQDZ,1,30) FCURRADDR_JD,A.DQDZDH FCURRTELE,isnull(A.DQDZYB,'-') FCURRPOST,A.ZYDM FJOBBH,CASE WHEN B.XSECSTZ LIKE '%-%' then null  WHEN isnumeric(B.XSECSTZ)=0 THEN NULL ELSE B.XSECSTZ END FCSTZ,                
  CASE WHEN isnumeric(B.XSERYTZ)=0 THEN NULL ELSE B.XSERYTZ  END FRYTZ,B.RYTJ FRYTJBH ,'' FRYTJ,                  
  B.SSLCLJ FYCLJBH,'' FYCLJ,case isnumeric(B.BLZD) when 0 then NULL else B.BLZD end FPHZDBH,B.BLBH FPHZDNUM,B.YWGM FIFGMYWBH ,'' FIFGMYW,B.ZRHS FNURSEBH,'' FNURSE,B.LYFS FLYFSBH ,'' FLYFS,B.JSYLJG1 FYZOUTHOSTITAL,JSYLJG2 FSQOUTHOSTITAL,                  


  B.ZZYJH FISAGAINRYBH,'' FISAGAINRY,B.ZZYMD FISAGAINRYMD,Q.HMDAY1 FRYQHMDAYS,Q.HMHOUR1 FRYQHMHOURS,Q.HMMIN1 FRYQHMMINS,                  
  cast(isnull(Q.HMDAY1,0) as int)*24*60 + cast(isnull(Q.HMHOUR1,0) as int)*60 + cast(isnull(Q.HMMIN1,0) as int) FRYQHMCOUNTS,                  
  Q.HMDAY2 FRYHMDAYS,Q.HMHOUR2 FRYHMHOURS,Q.HMMIN2 FRYHMMINS,                  
  cast(isnull(Q.HMDAY2,0) as int)*24*60 + cast(isnull(Q.HMHOUR2,0) as int)*60 + cast(isnull(Q.HMMIN2,0) as int) FRYHMCOUNTS,                  
  A.BRXZ FFBBHNEW,'' FFBNEW ,B.RYZD FRYZDBH,convert(varchar(40),substring(B.RYZDMC,1,30)) FRYZD
  ,
  D.CFMFFS FCFFMFSBH,	B.HY1 FHBSAGBH,	B.HY2 FHCVABBH,	B.HY3 FHIVABBH,
  case when isnumeric(B.SXPZ1)=0 then NULL else round(B.SXPZ1,0) end  FREDCELL,case when isnumeric(B.SXPZ2)=0 then NULL else B.SXPZ2 end FPLAQUE,
  case when isnumeric(B.SXPZ3)=0 then NULL else B.SXPZ3 end FSEROUS,case when isnumeric(B.SXPZ4)=0 then NULL else B.SXPZ4 end FALLBLOOD,
  D.ZTXHS FQTXHS,B.SXPZ5 FOTHERBLOOD,REPLACE(REPLACE(ISNULL(D.TJHL,'0'),'','0'),'-','0') FHLTJ,REPLACE(REPLACE(ISNULL(D.YJHL,'0'),'','0'),'-','0') FHL1,REPLACE(REPLACE(ISNULL(D.EJHL,'0'),'','0'),'-','0') FHL2,REPLACE(REPLACE(ISNULL(D.SJHL,'0'),'','0'),'-','0') FHL3,B.DYCZL FISOPFIRSTBH,case when B.SZDW='0' THEN B.SZQX ELSE 0 END FSZQX,case when B.SZDW='1' THEN B.SZQX ELSE 0 END FSZQXY,case when B.SZDW='2' THEN B.SZQX ELSE 0 END FSZQXN,
  D.SFHZ FHZQKBH ,B.SZQK FISSZBH,convert(varchar(100),substring(B.MZZDMC,1,30)) FMZXYSXZD,convert(varchar(100),substring(B.RYZDMC,1,30)) FRYXYSXZD,substring(B.BLZDMC,1,30) fphsxzd , '-' FHKADDRBZ,convert(varchar(30),B.RYZLKM) fryzlkmbh,convert(varchar(30)
,B.ZKZLKM) fzkzlkmbh,convert(varchar(30),B.CYZLKM) fcyzlkmbh  ,
  CASE WHEN A.CYKS LIKE '02%' THEN '01'WHEN  A.CYKS LIKE '05%' THEN '02' WHEN A.CYKS LIKE '32%' THEN '03' ELSE null END  fyydm         
  from EMR_BRSYK A (nolock)        
 inner join #PAT P on A.HISSYXH = P.HISSYXH AND A.SYXH=P.EMRSYXH             
 inner join #TSZDCL Q ON A.SYXH=Q.SYXH         
 inner join EMR_BASYK_FB D (nolock) on D.QTBLJLXH=P.QTBLJLXH and D.SYXH=A.SYXH    
 left join EMR_BASYK B (nolock) on B.QTBLJLXH=P.QTBLJLXH and B.SYXH=P.EMRSYXH          
 where A.YEXH = 0     
     
 --���¹���ҩ��    
 update  A set FGMYW=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FGMYW=B.MXDM  and B.LBDM='10'      
        

 --1 һ��  3 Σ��        
 UPDATE A SET A.FJBFXBH='3',A.FJBFX='C' FROM #ba1 A WHERE EXISTS (SELECT 1 FROM CPOE_CQYZK where  SYXH=A.FZYID and (YPMC Like  '%��Σ%' or YPMC Like  '%����%'))        
         
 --�����ֵ�����ȡ�����ֶ�                 
 update #ba1 set FSEX= (case FSEXBH when '1' then '��' when '2' then 'Ů'  else '' end)               
 update  A set FCOUNTRYBH=B.MXDM,FCOUNTRY=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FCOUNTRYBH=B.MXDM  and B.LBDM='43'          
 --���Ĺ��ұ��        
 --update  A SET FCOUNTRY=B.NAME FROM #ba1 A,PUB_GJDMK B WHERE A.FCOUNTRYBH=B.ID           
 --update  A set FCOUNTRYBH='CHN' from #ba1 A where FCOUNTRY='�й�'            
 update  A set FNATIONALITY=B.NAME,FNATIONALITYBH=B.MXDM from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FNATIONALITYBH=B.MXDM  and B.LBDM='42'            
 ---����������
 update #ba1 set FNATIONALITY=b.name from #ba1 a,[172.20.0.41\ZY].THIS_ZY.dbo.YY_MZDMK b where a.FNATIONALITYBH=b.id collate Chinese_PRC_CI_AS
 update #ba1 set FNATIONALITYBH=b.FBH from #ba1 a,[172.20.9.200].BAGL_JAVA.dbo.TSTANDARDMX b where a.FNATIONALITY=b.FMC collate Chinese_PRC_CI_AS and FCODE='GBNATIONALITY'        
 --update  A set FNATIONALITYBH=B.MXDM from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FNATIONALITY=B.NAME  and B.LBDM='42'                  
 
 update  A set FJOB=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  replace(A.FJOBBH,' ','')=B.MXDM  and B.LBDM='41'
 update A set FJOB='���ж�ͯ',FJOBBH='72' from #ba1 A where FJOBBH='C1'
update A set FJOB='ɢ�Ӷ�ͯ',FJOBBH='71' from #ba1 A where FJOBBH='C2'    
update A set FJOB='ְԱ',FJOBBH='17' from #ba1 A where FJOBBH='C3'    
update A set FJOB='����',FJOBBH='90' from #ba1 A where FJOBBH='C4'    
update A set FJOB='���徭Ӫ��',FJOBBH='54' from #ba1 A where FJOBBH='C5'    
update A set FJOB='���徭Ӫ��',FJOBBH='54' from #ba1 A where FJOBBH='C6'    
update A set FJOB='רҵ������Ա',FJOBBH='13' from #ba1 A where FJOBBH='C7'    
update A set FJOB='����',FJOBBH='90' from #ba1 A where FJOBBH='C8'    
update A set FJOB='����',FJOBBH='90' from #ba1 A where FJOBBH='C9'
update A set FJOB='����',FJOBBH='90' from #ba1 A where FJOBBH='C10'    
update A set FJOB='ְԱ',FJOBBH='17' from #ba1 A where FJOBBH='C11'    
update A set FJOB='��ҵ��Ա',FJOBBH='70' from #ba1 A where FJOBBH='C12'    
update A set FJOB='����',FJOBBH='90' from #ba1 A where FJOBBH='C13'    
update A set FJOB='����',FJOBBH='90' from #ba1 A where FJOBBH='C14'       
 --���Ļ������         
 UPDATE  A set FSTATUS=B.NAME from  #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where A.FSTATUSBH=B.MXDM  AND B.LBDM='4'               
  --      update #ba1 set FSTATUSBH='10' where FSTATUS LIKE '%δ��%'   
  --      update #ba1 set FSTATUSBH='20' where FSTATUS LIKE '%�ѻ�%'       
  --      update #ba1 set FSTATUSBH='20' where FSTATUS LIKE '%�ٻ�%' 
  --      update #ba1 set FSTATUSBH='30' where FSTATUS LIKE '%ɥż%'    
  --      update #ba1 set FSTATUSBH='40' where FSTATUS LIKE '%���%'  
  --      update #ba1 set FSTATUSBH='40' where FSTATUS LIKE '%����%'  
  --      update #ba1 set FSTATUSBH='90' where FSTATUS LIKE '%����%'
		--update #ba1 set FSTATUSBH='90' where FSTATUS LIKE '%ͬ��%'
		update #ba1 set FSTATUSBH='1' where FSTATUS LIKE '%δ��%'   
        update #ba1 set FSTATUSBH='2' where FSTATUS LIKE '%�ѻ�%'       
        update #ba1 set FSTATUSBH='2' where FSTATUS LIKE '%�ٻ�%' 
        update #ba1 set FSTATUSBH='3' where FSTATUS LIKE '%ɥż%'    
        update #ba1 set FSTATUSBH='4' where FSTATUS LIKE '%���%'  
        update #ba1 set FSTATUSBH='4' where FSTATUS LIKE '%����%'  
        update #ba1 set FSTATUSBH='9' where FSTATUS LIKE '%����%'
		update #ba1 set FSTATUSBH='9' where FSTATUS LIKE '%ͬ��%'           
           
 update  A set FRYDEPT =B.NAME from #ba1 A , EMR_SYS_KSDMK B (nolock) where  A.FRYTYKH=B.KSDM                    
 update  A set FRYBS =B.NAME from #ba1 A , EMR_SYS_BQDMK B (nolock) where  A.FRYBS=B.BQDM                    
 update  A set FCYDEPT =B.NAME from #ba1 A , EMR_SYS_KSDMK B (nolock) where  A.FCYTYKH=B.KSDM                     
 update  A set FCYBS =B.NAME from #ba1 A , EMR_SYS_BQDMK B (nolock) where  A.FCYBS=B.BQDM                      
 --lr20141108                   
 update  A set FMZDOCTBH =B.mzzdys from #ba1 A , [172.20.0.41\ZY].[THIS_ZY].[dbo].ZY_BRSYK B (nolock) where  B.syxh=A.FZYID        
         
 update  A set FMZDOCT =isnull(B.NAME,'-') from #ba1 A , EMR_SYS_ZGDMK B (nolock) where  A.FMZDOCTBH=B.ZGDM          
 --���·������                   
 update  A set FMZCYACCO=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FMZCYACCOBH=B.MXDM  and B.LBDM='12'                  
 update  A set FLCBLACCO=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FLCBLACCOBH=B.MXDM  and B.LBDM='12'             
 update  A set FRYCYACCO=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FRYCYACCOBH=B.MXDM  and B.LBDM='12'                  
 update  A set FFSBLACCO=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FFSBLACCOBH=B.MXDM  and B.LBDM='12'           
 update  A set FOPACCO=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FOPACCOBH=B.MXDM  and B.LBDM='12'
 update  A set FBDYSL=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FBDYSLBH=B.MXDM  and B.LBDM='12'

 update  A set FMZCYACCO='δ��',FMZCYACCOBH='0' from #ba1 A  where  A.FMZCYACCOBH='4'                  
 update  A set FLCBLACCO='δ��',FLCBLACCOBH='0' from #ba1 A  where  A.FLCBLACCOBH='4'         
 update  A set FRYCYACCO='δ��',FRYCYACCOBH='0' from #ba1 A  where  A.FRYCYACCOBH='4'                 
 update  A set FFSBLACCO='δ��',FFSBLACCOBH='0' from #ba1 A where  A.FFSBLACCOBH='4'          
 update  A set FOPACCO='δ��',FOPACCOBH='0' from #ba1 A  where  A.FOPACCOBH='4'
 update  A set FBDYSL='δ��',FBDYSLBH='0' from #ba1 A  where  A.FBDYSLBH='4'                    
              
 update  A set FKZR =isnull(B.NAME,'-') from #ba1 A , EMR_SYS_ZGDMK B (nolock) where  A.FKZRBH=B.ZGDM                    
 update  A set FZRDOCTOR =isnull(B.NAME,'-') from #ba1 A , EMR_SYS_ZGDMK B (nolock) where  A.FZRDOCTBH=B.ZGDM                    
 update  A set FZZDOCT =isnull(B.NAME,'-') from #ba1 A , EMR_SYS_ZGDMK B (nolock) where  A.FZZDOCTBH=B.ZGDM                    
 update  A set FZYDOCT =isnull(B.NAME,'-') from #ba1 A , EMR_SYS_ZGDMK B (nolock) where  A.FZYDOCTBH=B.ZGDM                    
 update  A set FJXDOCT =isnull(B.NAME,'-') from #ba1 A , EMR_SYS_ZGDMK B (nolock) where  A.FJXDOCTBH=B.ZGDM                    
 update  A set FSXDOCT =isnull(B.NAME,'-') from #ba1 A , EMR_SYS_ZGDMK B (nolock) where  A.FSXDOCTBH=B.ZGDM                    
 update  A set FBMY =isnull(B.NAME,'-') from #ba1 A , EMR_SYS_ZGDMK B (nolock) where  A.FBMYBH=B.ZGDM                    
 update A set FZLR =isnull(B.NAME,'-') from #ba1 A , EMR_SYS_ZGDMK B (nolock) where  A.FZLRBH=B.ZGDM          
         
    update  A set FQUALITY=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FQUALITYBH=B.MXDM  and B.LBDM='16'                  
    update  A set FZKDOCT =B.NAME from #ba1 A , EMR_SYS_ZGDMK B (nolock) where  A.FZKDOCTBH=B.ZGDM                    
    update  A set FZKNURSE =B.NAME from #ba1 A , EMR_SYS_ZGDMK B (nolock) where  A.FZKNURSEBH=B.ZGDM                    
    update  A set FBODY=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FBODYBH=B.MXDM  and B.LBDM='95'                  
    update  A set FBLOOD=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FBLOODBH=B.MXDM  and B.LBDM='96'                  
    update  A set FJBFXBH=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FJBFXBH=B.MXDM  and B.LBDM='70'                  
    update  A set FSOURCE=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FSOURCEBH=B.MXDM  and B.LBDM='2'                  
    --update  A set FBIRTHPLACE=B.NAME from #ba1 A , EMR_SYS_DQDMK B (nolock) where  A.FBIRTHPLACE=B.DQDM        
            
 update  A set FRYTJ=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FRYTJBH=B.MXDM  and B.LBDM='6'                  
 update  #ba1 set FRYTJBH='1' where FRYTJ='����'                  
 update  #ba1 set FRYTJBH='2' where FRYTJ='����'                  
 update  A set FYCLJ=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FYCLJBH=B.MXDM  and B.LBDM='95'                  
 update  A set FIFGMYW=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FIFGMYWBH=B.MXDM  and B.LBDM='95'                  
 update  A set FNURSE =isnull(B.NAME,'-') from #ba1 A , EMR_SYS_ZGDMK B (nolock) where  A.FNURSEBH=B.ZGDM         
                  
 --select B.NAME,* from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FLYFSBH=B.MXDM  and B.LBDM='98' return   --lius                   
 update  A set FLYFS=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FLYFSBH=B.MXDM  and B.LBDM='98'                  
 update  A set FISAGAINRY=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FISAGAINRYBH=B.MXDM and B.LBDM='95'                  
 update  A set FFBNEW=B.NAME from #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FFBBHNEW=B.MXDM  and B.LBDM='1'
        update #ba1 set FFBBHNEW='01' where FFBNEW='����ְ������ҽ�Ʊ���'    
        update #ba1 set FFBBHNEW='02' where FFBNEW='����������ҽ�Ʊ���'    
        update #ba1 set FFBBHNEW='03' where FFBNEW='����ũ�����ҽ��'    
        update #ba1 set FFBBHNEW='04' where FFBNEW='ƶ������'    
        update #ba1 set FFBBHNEW='05' where FFBNEW='��ҵҽ�Ʊ���'    
        update #ba1 set FFBBHNEW='06' where FFBNEW='ȫ����'    
        update #ba1 set FFBBHNEW='07' where FFBNEW='ȫ�Է�'    
        update #ba1 set FFBBHNEW='08' where FFBNEW='������ᱣ��'    
        update #ba1 set FFBBHNEW='99' where FFBNEW='����'                        
 UPDATE  A set FRELATE=B.NAME from  #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where A.FRELATE=B.MXDM  AND B.LBDM='44'
        update #ba1 SET FRELATE = '��' where FRELATE='01'
	    update #ba1 SET FRELATE = '��' where FRELATE ='02' 
        update #ba1 SET FRELATE = '��ż' where FRELATE = '03'    
        update #ba1 SET FRELATE = '�֡��ܡ��㡢��' where FRELATE='04'
        update #ba1 SET FRELATE = '����' where FRELATE='05'  
        update #ba1 SET FRELATE = '����' where FRELATE='06'        
        update #ba1 SET FRELATE = '����' where FRELATE='07'   
        update #ba1 SET FRELATE = '���˻���' where FRELATE = '08'                       
 --        
 UPDATE  A set FRH=B.NAME from  #ba1 A , EMR_SYS_ZDFLMXK B (nolock) where A.FRHBH=B.MXDM  AND B.LBDM='97'                  
 --UPDATE  A set FRYTYKH=B.ba_id,FRYDEPT=B.ba_name,FRYBS=B.ba_id  from  #ba1 A , THIS_MZ..baksdyk B (nolock) where A.FRYTYKH=B.id                   
 --UPDATE  A set FCYTYKH=B.ba_id,FCYDEPT=B.ba_name,FCYBS=B.ba_id  from  #ba1 A , THIS_MZ..baksdyk B (nolock) where A.FCYTYKH=B.id                   
 --UPDATE  A set FNATIVE=B.name  FROM  #ba1 A ,THIS_MZ..YY_DQDMK B (nolock) WHERE A.FNATIVE=B.id               
--���ᴦ��        
 UPDATE  A set FNATIVE=B.NAME  FROM  #ba1 A ,EMR_SYS_DQDMK B (nolock) WHERE A.FNATIVE=B.DQDM           
 UPDATE  A set FNATIVE_QX=B.NAME  FROM  #ba1 A ,EMR_SYS_DQDMK B (nolock) WHERE A.FNATIVE_QX=B.DQDM            
 UPDATE  A set FNATIVE=FNATIVE+FNATIVE_QX  FROM  #ba1 A          
 --��סַ����        
 UPDATE  A set FCURRADDR=B.NAME  FROM  #ba1 A ,EMR_SYS_DQDMK B (nolock) WHERE A.FCURRADDR=B.DQDM          
 UPDATE  A set FCURRADDR_X=B.NAME  FROM  #ba1 A ,EMR_SYS_DQDMK B (nolock) WHERE A.FCURRADDR_X=B.DQDM            
 --UPDATE  A set FCURRADDR=A.FCURRADDR+A.FCURRADDR_X+A.FCURRADDR_JD  FROM  #ba1 A        
 UPDATE  A set FCURRADDRBZ=A.FCURRADDR+A.FCURRADDR_X  FROM  #ba1 A        
 UPDATE  A set FCURRADDR=A.FCURRADDR_JD  FROM  #ba1 A        
 --�����ش���        
 update  A set FBIRTHPLACE=B.NAME from #ba1 A , EMR_SYS_DQDMK B (nolock) where  A.FBIRTHPLACE=B.DQDM        
 update  A set FBIRTHPLACE_QX=B.NAME from #ba1 A , EMR_SYS_DQDMK B (nolock) where  A.FBIRTHPLACE_QX=B.DQDM         
 UPDATE  A set FBIRTHPLACE=A.FBIRTHPLACE+A.FBIRTHPLACE_QX  FROM  #ba1 A        
 --  UPDATE  A set FFBBHNEW=B.BA_ID from #ba1 A , THIS_MZ..fkdyk B (nolock) where  A.FFBBHNEW=B.MXDM                    
 --UPDATE  A set FFBBHNEW=B.babm from #ba1 A , zt_badzk B (nolock) where  A.FFBBHNEW=B.hisbm and lbdm=1                    
 --  UPDATE  A set FRELATE=B.BA_NAME from #ba1 A , THIS_MZ..lxrdyk B (nolock) where  A.FRELATE=B.MXDM                   
 --  UPDATE  A set FSTATUSBH=B.BA_ID,FSTATUS=B.BA_NAME from #ba1 A , THIS_MZ..hydyk B (nolock) where  A.FSTATUSBH=B.ID
 
 --��''ת��Ϊ'-'
 update #ba1 set FDWTELE='-' where FDWTELE=''
 update #ba1 set FIDCARD='-' where FIDCARD=''
 update #ba1 set FDWADDR='-' where FDWADDR=''
 update #ba1 set FDWADDRBZ='-' where FDWADDRBZ=''
 update #ba1 set FDWPOST='-' where FDWPOST=''
 update #ba1 set FHKPOST='-' where FHKPOST=''
 update #ba1 set FLXADDR='-' where FLXADDR=''
 update #ba1 set FMZZD='-' where FMZZD=''
 update #ba1 set FPHZD='-' where FPHZD=''
 update #ba1 set FGMYW='-' where FGMYW=''
 update #ba1 set FMZDOCT='-' where FMZDOCT=''
 update #ba1 set FKZR='-' where FKZR=''
 update #ba1 set FZRDOCTOR='-' where FZRDOCTOR=''
 update #ba1 set FZZDOCT='-' where FZZDOCT=''
 update #ba1 set FZYDOCT='-' where FZYDOCT=''
 update #ba1 set FJXDOCT='-' where FJXDOCT=''
 update #ba1 set FSXDOCT='-' where FSXDOCT=''
 update #ba1 set FBMY='-' where FBMY=''
 update #ba1 set FZLR='-' where FZLR=''
 update #ba1 set FZKDOCT='-' where FZKDOCT=''
 update #ba1 set FZKNURSE='-' where FZKNURSE=''
 update #ba1 set FNURSE='-' where FNURSE=''
 update #ba1 set FCURRPOST='-' where FCURRPOST=''
 update #ba1 set FPHZDBH='-' where FPHZDBH=''
 update #ba1 set FPHZDNUM='-' where FPHZDNUM=''
 update #ba1 set FJXDOCTBH='-' where FJXDOCTBH=''
 update #ba1 set FSXDOCTBH='-' where FSXDOCTBH=''
 update #ba1 set FYZOUTHOSTITAL='-' where FYZOUTHOSTITAL=''
 update #ba1 set FSQOUTHOSTITAL='-' where FSQOUTHOSTITAL=''
 update #ba1 set FISAGAINRYMD='-' where FISAGAINRYMD=''
 update #ba1 set FMZCYACCO='-' where FMZCYACCO=''
 update #ba1 set FMZCYACCOBH='-' where FMZCYACCOBH=''
 update #ba1 set FRYCYACCO='-' where FRYCYACCO=''
 update #ba1 set FRYCYACCOBH='-' where FRYCYACCOBH=''
 update #ba1 set FLCBLACCO='-' where FLCBLACCO=''
 update #ba1 set FLCBLACCOBH='-' where FLCBLACCOBH=''
 update #ba1 set FFSBLACCO='-' where FFSBLACCO=''
 update #ba1 set FFSBLACCOBH='-' where FFSBLACCOBH=''
 update #ba1 set FOPACCO='-' where FOPACCO=''
 update #ba1 set FOPACCOBH='-' where FOPACCOBH=''
 update #ba1 set FBDYSL='-' where FBDYSL=''
 update #ba1 set FBDYSLBH='-' where FBDYSLBH=''
 update #ba1 set FBODY='��' where FBODY=''
 update #ba1 set FBODYBH='2' where FBODYBH=''
 update #ba1 set FYCLJ='��' where FYCLJ=''
 update #ba1 set FYCLJBH='2' where FYCLJBH='' 
 update #ba1 set FASCARD1='-' where FASCARD1='' 
 update #ba1 set FCURRADDR='-' where FCURRADDR='' 
 update #ba1 set FDWADDRBZ='-' where FDWADDRBZ='' 
 update #ba1 set FBODY='��' where FBODY is NULL
 update #ba1 set FBODYBH='2' where FBODYBH is NULL
 update #ba1 set FYCLJ='��' where FYCLJ is NULL
 update #ba1 set FYCLJBH='2' where FYCLJBH is NULL
 --update #ba1 set FNLBZYZS='-' where FNLBZYZS='' 
 --update #ba1 set FCSTZ='-' where FCSTZ='' 
 --update #ba1 set FRYTZ='-' where FRYTZ='' 
 
 --��NULLת��Ϊ'-'
 update #ba1 set FDWTELE='-' where FDWTELE is NULL
 update #ba1 set FIDCARD='-' where FIDCARD is NULL
 update #ba1 set FDWADDR='-' where FDWADDR is NULL
 update #ba1 set FDWADDRBZ='-' where FDWADDRBZ is NULL
 update #ba1 set FDWPOST='-' where FDWPOST is NULL
 update #ba1 set FHKPOST='-' where FHKPOST is NULL
 update #ba1 set FLXADDR='-' where FLXADDR is NULL
 update #ba1 set FMZZD='-' where FMZZD is NULL
 update #ba1 set FPHZD='-' where FPHZD is NULL
 update #ba1 set FGMYW='-' where FGMYW is NULL
 update #ba1 set FMZDOCT='-' where FMZDOCT is NULL
 update #ba1 set FKZR='-' where FKZR is NULL
 update #ba1 set FZRDOCTOR='-' where FZRDOCTOR is NULL
 update #ba1 set FZZDOCT='-' where FZZDOCT is NULL
 update #ba1 set FZYDOCT='-' where FZYDOCT is NULL
 update #ba1 set FJXDOCT='-' where FJXDOCT is NULL
 update #ba1 set FSXDOCT='-' where FSXDOCT is NULL
 update #ba1 set FBMY='-' where FBMY is NULL
 update #ba1 set FZLR='-' where FZLR is NULL
 update #ba1 set FZKDOCT='-' where FZKDOCT is NULL
 update #ba1 set FZKNURSE='-' where FZKNURSE is NULL
 update #ba1 set FNURSE='-' where FNURSE is NULL
 update #ba1 set FCURRPOST='-' where FCURRPOST is NULL
 update #ba1 set FPHZDBH='-' where FPHZDBH is NULL
 update #ba1 set FPHZDNUM='-' where FPHZDNUM is NULL
 update #ba1 set FJXDOCTBH='-' where FJXDOCTBH is NULL
 update #ba1 set FSXDOCTBH='-' where FSXDOCTBH is NULL
 update #ba1 set FYZOUTHOSTITAL='-' where FYZOUTHOSTITAL is NULL
 update #ba1 set FSQOUTHOSTITAL='-' where FSQOUTHOSTITAL is NULL
 update #ba1 set FISAGAINRYMD='-' where FISAGAINRYMD is NULL
 update #ba1 set FMZCYACCO='-' where FMZCYACCO is NULL
 update #ba1 set FMZCYACCOBH='-' where FMZCYACCOBH is NULL
 update #ba1 set FRYCYACCO='-' where FRYCYACCO is NULL
 update #ba1 set FRYCYACCOBH='-' where FRYCYACCOBH is NULL
 update #ba1 set FLCBLACCO='-' where FLCBLACCO is NULL
 update #ba1 set FLCBLACCOBH='-' where FLCBLACCOBH is NULL
 update #ba1 set FFSBLACCO='-' where FFSBLACCO is NULL
 update #ba1 set FFSBLACCOBH='-' where FFSBLACCOBH is NULL
 update #ba1 set FOPACCO='-' where FOPACCO is NULL
 update #ba1 set FOPACCOBH='-' where FOPACCOBH is NULL
 update #ba1 set FBDYSL='-' where FBDYSL is NULL
 update #ba1 set FBDYSLBH='-' where FBDYSLBH is NULL
 update #ba1 set FBODY='-' where FBODY is NULL
 update #ba1 set FBODYBH='-' where FBODYBH is NULL
 update #ba1 set FYCLJ='-' where FYCLJ is NULL
 update #ba1 set FYCLJBH='-' where FYCLJBH is NULL 
 update #ba1 set FASCARD1='-' where FASCARD1 is NULL 

--  insert into #His_BaFy     (FSYXH,FPRN, FTIMES,FIFFMBH,	FCS,FCSDSBH,FHCXSES,FXSETZDY2KBH,FIFZCBH,FXSECSBH,FXSECSGS,FISZRY,FBCYSCCYJG,FZRYYYBH,FRYBQFJBH,
--   FZYZDLXBH,FCYZDLXBH,FZGZDYJBH,FLCLJBL,FSYFYFSCS,FSYFY_FY,FSXFY_FY,FSXFYFSCS,F24HSXLBH,FWZBL,FYNBL,FISSZBH,FDBZ_HN,FDRGGL,FIFABZFFBLBH,FSSKJYW,
--   FIFYFXSYBH,FZYKJYW_VALUE,FSFZJKJYWBH,FKJYWSBYXJC,FWSWJCJGBH,	FYYXSS,	FHZAQSJ,FZZJH,FSFYNGR,FSYZXJMZG,FZXJMZGSYTS,FGLHTZXJMGBH,FDGHTYZC,FSYZXJMZGGR,
--   FSYLZDNG,FLZDNGSYTS,FIFGLHTBH,FIFZCRBH,FSYLZDNGGR,FXYTX,FXYTXTS,FSFXYTXGR,FSYHXJ,FSYHXJGR,FSYXHJTS,FYHXJSJ,FZRICU,FRZICUCS,FIFJHRZBH,FZRICUSW,FSFCFZZYXK,
--   FTGCTTS,	FYYCWSW,FFSYC,FSFFSYC,FIFAPACCHEBH,	FAPACCHEPF,	FSFQDTC,FSY,FSX)  --,FHMSJ
--  SELECT A.SYXH FSYXH,A.BAHM FPRN,A.RYCS FTIMES,D.CKHZSFFM FIFFMBH,D.SFFSCS FCS,	D.CSDS FCSDSBH,	D.HCYES FHCXSES,D.XSETZDY2KG FXSETZDY2KBH,D.SFZCE FIFZCBH,
--  D.XSRSFFSCS FXSECSBH,	D.XSEFSCSGS FXSECSGS,D.SFZZY FISZRY,D.CFJGSJ FBCYSCCYJG,D.ZZYYY FZRYYYBH,B.RYQK FRYBQFJBH,B.ZLJG FZYZDLXBH,	D.ZDYJ FCYZDLXBH,
--  D.BLZGZDYJ FZGZDYJBH,	B.LCLJGL FLCLJBL,B.SYCS FSYFYFSCS,B.SYFY FSYFY_FY,B.SXFY FSXFY_FY,B.SXQK FSXFYFSCS,D.SXLDY F24HSXLBH,B.ZYWZ FWZBL,B.ZYYN FYNBL,
--  B.SZQK FISSZBH,D.DWZBL FDBZ_HN,D.SSDRGSGL FDRGGL,D.SFSRJJXFBZ FIFABZFFBLBH,D.SFSQYFSYKJYW FSSKJYW,D.KSSSFYF FIFYFXSYBH,D.KSSYW FZYKJYW_VALUE,	
--  D.TSJYW FSFZJKJYWBH,D.SFZBYXJC FKJYWSBYXJC,D.WSWJCJG FWSWJCJGBH,D.SFYYXSH FYYXSS,D.YYXSHLX FHZAQSJ,D.JHZSJHOUR FZZJH,	D.SFYYGR FSFYNGR,
--  D.SFSYZXJMZG FSYZXJMZG,D.SYZXJMZGTS FZXJMZGSYTS,D.JZGSFGLHT FGLHTZXJMGBH,D.JZGSFZCR FDGHTYZC,	D.SFZXJMZGGR FSYZXJMZGGR,D.SFSYZLDNG FSYLZDNG,
--  D.SYZLDNGTS FLZDNGSYTS,D.DNGSFGLHT FIFGLHTBH,	D.DNGSFZCR FIFZCRBH,D.SFZLDNGTS FSYLZDNGGR,	D.SFXYTXZL FXYTX,D.XYGRZTS FXYTXTS,	D.SFXYGR FSFXYTXGR,
--  	D.SFSYHXJ FSYHXJ,D.SFHXJGR FSYHXJGR,D.JHZSJDAY FSYXHJTS,D.SYHXJSS FYHXJSJ,B.SRSS FZRICU,D.ICURZCS FRZICUCS,D.ICUSFJHRZ FIFJHRZBH,D.ICUSW FZRICUSW,
--	D.SFCFICU FSFCFZZYXK,D.HXJTGCTBRS FTGCTTS,D.SFSW FYYCWSW,B.YWYC FFSYC,D.SFZYQJFSYC FSFFSYC,	D.SFAPACCHEII FIFAPACCHEBH,	D.APACCHEIIPF FAPACCHEPF,
--	D.SFRGQDTC FSFQDTC,D.SFSY FSY,D.SFSX FSX--,D.HMSJ FHMSJ
--   from  EMR_BRSYK A (nolock)        
-- inner join #PAT P on A.SYXH=P.EMRSYXH  
-- inner join EMR_BASYK_FB D (nolock)  on  D.QTBLJLXH=P.QTBLJLXH and D.SYXH=A.SYXH 
-- left join EMR_BASYK B (nolock) on B.QTBLJLXH=P.QTBLJLXH and B.SYXH=P.EMRSYXH 
----lzm�޸�  




 --��Һ��Ӧת��
  update #His_BaFy set FSYFY_FY='3' from #His_BaFy (nolock)  where FSYFY_FY='1'  
  update #His_BaFy set FSYFY_FY='1' from #His_BaFy (nolock)  where FSYFY_FY='2' 
  update #His_BaFy set FSYFY_FY='2' from #His_BaFy (nolock)  where FSYFY_FY='3'  
  --�޸��ٴ�·����Ϣ
  update #His_BaFy set FLCLJBL=''   from #His_BaFy (nolock)  where FLCLJBL='4' 
        
 --����ת�������HIS_BA2��                  
 insert into #ba2(FSYXH,FPRN,FTIMES,FZKTYKH,FZKDEPT,FZKDATE,FZKTIME)                      
 select A.SYXH FSYXH,A.BAHM,B1.RYCS,B.XKSDM,D.KSLB,substring(B.JSRQ,1,10),replace(substring(B.JSRQ,11,10),' ','')                   
 from  EMR_BRSYK A (nolock)        
 inner join #PAT P ON A.SYXH=P.EMRSYXH                 
 inner join EMR_BRCWXXK B (nolock) on B.SYXH=A.SYXH and B.ISDQCW=2                 
 inner join EMR_SYS_KSDMK D (nolock) on D.KSDM=B.XKSDM       
 left join EMR_BASYK B1 (nolock) on B1.QTBLJLXH=P.QTBLJLXH and B1.SYXH=P.EMRSYXH              
 where ISNULL(B.XKSDM,'')<>'' and B.KSDM<>B.XKSDM                  
 order by CWXXXH asc          
         
 --���������Ϣ��HIS_BA3��                  
 insert into #ba3(FSYXH,FPRN, FTIMES, FZDLX, FICDVERSION, FICDM, FJBNAME, FRYBQBH, FRYBQ,FZLJGBH,FZLJG,FSXZD)                      
 select A.SYXH FSYXH,A.BAHM,B1.RYCS,case ZDXH when 0 then 1 else 2 end ,11,B.ZDDM,substring(B.BZDMMC,1,40),B.RYBQ,E.NAME, B.ZGQK,'',substring(ZDMC,1,50)                  
 from  EMR_BRSYK A (nolock)        
 inner join #PAT P ON A.SYXH=P.EMRSYXH                  
 inner join EMR_BASY_ZDK B (nolock) on B.QTBLJLXH=P.QTBLJLXH and B.SYXH=A.SYXH                  
 left join EMR_SYS_ZDFLMXK E (nolock) on E.MXDM=B.RYBQ and E.LBDM = '103'  
 left join EMR_BASYK B1 (nolock) on B1.QTBLJLXH=P.QTBLJLXH and B1.SYXH=P.EMRSYXH                              
 order by ZDXH asc             
 ----add by z_jx 2017��3��9��18:34:33 ���ӳ�Ժ���        
 update a set a.FZLJG=b.NAME    from #ba3  a ,EMR_SYS_ZDFLMXK b where a.FZLJGBH=b.MXDM  and b.LBDM=8          
         
 INSERT into #ba3(FSYXH,FPRN, FTIMES, FZDLX, FICDVERSION, FICDM, FJBNAME, FRYBQBH, FRYBQ,FZLJGBH,FZLJG)                  
 select A.SYXH FSYXH,A.BAHM,K.RYCS,'s',11,substring(K.SSZD,1,7),substring(K.SSZDMC,1,40),'','','2','��ת'                 
 from  EMR_BRSYK A (nolock)         
 INNER JOIN #PAT P ON A.SYXH=P.EMRSYXH                 
 INNER JOIN EMR_BASYK K (nolock) on A.SYXH=K.SYXH                  
 where K.SSZD<>'' AND K.SYXH=P.EMRSYXH        
 --����ҽԺҪ���벡�������ݲ��ܼ�������  -mwg        
 --update A set FJBNAME=B.name from #ba3 A,THIS_MZ..YY_ZDDMK B (nolock) WHERE A.FICDM=B.id        
   
   

     
-- --����������Ϣ��HIS_BA4��        
 insert into #ba4(FSYXH,FPRN, FTIMES, FNAME, FOPTIMES,FOPCODE,   
 FOP, 
 FOPDATE,       
 FQIEKOUBH, FQIEKOU, FYUHEBH,                   
 FYUHE, FDOCBH, FDOCNAME, FMAZUIBH, FMAZUI, FIFFSOP, FOPDOCT1BH, FOPDOCT1, FOPDOCT2BH,                   
 FOPDOCT2, FMZDOCTBH, FMZDOCT, FZQSSBH, FZQSS, FSSJBBH, FSSJB, FOPKSNAME, FOPTYKH  ,FZYID,
 FFJHZSSBH,FIFSHBFZBH,FSHBFZBH,FIFOPBH,FIFJRSSBH,FSSKSSJ,FSSJSSJ,FSSCXSJ,FSSXZBH,FSSLBBH,FIFXJSXMBH,FMZKSSJ,FMZJSSJ,FMZFJBH,FMZBFZBH,FSSLTZZSBJBH,
 FSSFXFJBH,FIFYFDSSBH,FSSFLBH,FSSBWGRBH,FGRBWBH,FIFSHSWBH,FSHSWSJ,FSQYFSYKJYWBH,FSQSYYFKJYWSJ,FSZZJKJYWBH,FSZZJKJYWYYBH,FSHYFSYKJYWBH,FSHYFYKJYWSJ,
 FSSYPFZBFFBH,FSZBDJCBH,FYWFJHZSSBH,FIFSZSXBH,FSZCXL,FSZSXPZBH,	FSSBDYSLBLZDBH,	FSQYSHBLZDBH,FIFSZYWYLBH,FQSMZSFTWXHBH,FMZYSZTZLBH,FMZYSZTZLSJBH,
 FMZYSXFFSZLBH,FIFXFFSCGBH,FIFSTEWARDBH,FJRMZFSSBH,FSTEWARDPF,FFSMZFYQSJBH,FMZFYQXGSJBH
 )                      
 select A.SYXH FSYXH,A.BAHM FPRN,B1.RYCS FTIMES,A.HZXM FNAME,B.SSXH FOPTIMES,substring(B.SSDM,1,12) FOPCODE,      
 B.SSMC FOP,
 B.SSRQ FOPDATE,      
 B.QKDJ FQIEKOUBH,D.NAME FQIEKOU,B.YHLB FYUHEBH,        
 E.NAME FYUHE,B.SSYS FDOCBH,B.SSYSMC FDOCNAME,B.MZFS FMAZUIBH,F.NAME FMAZUI,1/*B.SFJRSS*/ FIFFSOP,        
 B.SSYZ FOPDOCT1BH,B.SSYZMC FOPDOCT1,B.SSEZ FOPDOCT2BH,B.SSEZMC FOPDOCT2,        
 B.MZYS FMZDOCTBH,B.MZYSMC FMZDOCT,'0' FZQSSBH,'��' FZQSS,B.SSJB FSSJBBH,H.NAME FSSJB,        
 I.NAME FOPKSNAME,B.SSKS FOPTYKH,P.HISSYXH FZYID  ,
 B.YWZSSJH FFJHZSSBH,B.SFYSHBFZ FIFSHBFZBH,B.SHBFZ FSHBFZBH,B.SFSS FIFOPBH,B.SFJRSS FIFJRSSBH,case when B.SSKSSJ like '%-%' and B.SSKSSJ not like  '%+%' then B.SSKSSJ   else null  end FSSKSSJ,
case when B.SSJSSJ like '%-%'and B.SSJSSJ not like  '%+%' then B.SSKSSJ else null  end FSSJSSJ,
 left(B.SSCSSJ,20) FSSCXSJ,B.SSXZ FSSXZBH,B.SSLB FSSLBBH,B.SFXJS FIFXJSXMBH,
case when B.MZKSSJ like '%-%'and B.MZKSSJ not like  '%+%' then B.MZKSSJ else null  end  FMZKSSJ,
case when B.MZJSSJ like '%-%' and B.MZJSSJ not like  '%+%'then B.MZJSSJ else null  end  FMZJSSJ,
 B.MZFJ FMZFJBH,B.MZBFZ FMZBFZBH,
 B.BBSFBJ FSSLTZZSBJBH,	B.SSFXFJ FSSFXFJBH,	B.SFYFDSS FIFYFDSSBH,B.SSFL FSSFLBH,B.BWSFGR FSSBWGRBH,	B.GRBW FGRBWBH,	B.SHSFSW FIFSHSWBH,	B.SHSWSJ FSHSWSJ,
 B.SQSFYFSYKJYW FSQYFSYKJYWBH,B.SQYFSYSJ FSQSYYFKJYWSJ,B.SFSZZJDJKJYW FSZZJKJYWBH,B.SZZJDEJKJYWYY FSZZJKJYWYYBH,B.SHSFYFSYKJYW FSHYFSYKJYWBH,
 B.SHYFSYSJ FSHYFYKJYWSJ,B.SSYPFZBFF FSSYPFZBFFBH,B.SZBDJC FSZBDJCBH,B.YWZSSJH FYWFJHZSSBH,B.SFSZSX FIFSZSXBH,B.SHCXL FSZCXL,B.SZSXPZ FSZSXPZBH,
 B.BDFH FSSBDYSLBLZDBH,	B.QHFH FSQYSHBLZDBH,B.YWSZYWYL FIFSZYWYLBH,	B.QMSFTWXH FQSMZSFTWXHBH,B.SFMZYSZTZL FMZYSZTZLBH,B.MZYSZLSJ FMZYSZTZLSJBH,	
 B.SFMZYSXFFS FMZYSXFFSZLBH,B.XFFSSFCG FIFXFFSCGBH,B.SFMZFSGL FIFSTEWARDBH,B.SFJRMZFSS FJRMZFSSBH,B.STEWARDPF FSTEWARDPF,B.SFFSMZFYQSJ FFSMZFYQSJBH,
 B.MZFYQSJ FMZFYQXGSJBH             
 from  EMR_BRSYK A (nolock)        
 inner join #PAT P ON A.SYXH=P.EMRSYXH                  
 inner join EMR_BASY_SSK B (nolock) on B.QTBLJLXH=P.QTBLJLXH and B.SYXH=A.SYXH                  
 left join EMR_SYS_ZDFLMXK D (nolock) on D.MXDM=B.QKDJ and D.LBDM = '27'                    
 left join EMR_SYS_ZDFLMXK E (nolock)on E.MXDM=B.YHLB and E.LBDM = '28'                   
 left join EMR_SYS_MZDMK F (nolock) on F.MZDM=B.MZFS                  
 left join EMR_SYS_ZDFLMXK G (nolock) on G.MXDM=B.ZQSS and G.LBDM = '95'                   
 left join EMR_SYS_ZDFLMXK H (nolock) on H.MXDM=B.SSJB and H.LBDM = '120'                  
 left join EMR_SYS_KSDMK I (nolock) on I.KSDM=B.SSKS       
 left join EMR_BASYK B1 (nolock) on B1.QTBLJLXH=P.QTBLJLXH and B1.SYXH=P.EMRSYXH   
       
 -- UPDATE #ba4 SET FOPDATE=B.SSRQ,FOPCODE=B.SSDM from  EMR_BRSYK A (nolock)        
 --inner join #PAT P ON A.SYXH=P.EMRSYXH                  
 --inner join EMR_BASY_SSK B (nolock) on B.QTBLJLXH=P.QTBLJLXH and B.SYXH=A.SYXH                  
 --left join EMR_SYS_ZDFLMXK D (nolock) on D.MXDM=B.QKDJ and D.LBDM = '27'                    
 --left join EMR_SYS_ZDFLMXK E (nolock)on E.MXDM=B.YHLB and E.LBDM = '28'                   
 --left join EMR_SYS_MZDMK F (nolock) on F.MZDM=B.MZFS                  
 --left join EMR_SYS_ZDFLMXK G (nolock) on G.MXDM=B.ZQSS and G.LBDM = '95'                   
 --left join EMR_SYS_ZDFLMXK H (nolock) on H.MXDM=B.SSJB and H.LBDM = '120'                  
 --left join EMR_SYS_KSDMK I (nolock) on I.KSDM=B.SSKS       
 --where #ba4.FZYID=P.HISSYXH      
 /*
 update  A set FSSKSSJ=NULL from  #ba4  A (nolock) where  A.FSSKSSJ not like '%-%'
 update  A set FSSJSSJ=NULL from  #ba4  A (nolock) where A. FSSJSSJ not like '%-%'
 update  A set FMZKSSJ=NULL from  #ba4  A (nolock) where  A.FMZKSSJ not like '%-%'
 update  A set FMZJSSJ=NULL from  #ba4  A (nolock) where  A.FMZJSSJ not like '%-%'
 */

 --���������ֵ� ltrim(rtrim(xserytz))
 UPDATE  A set FFJHZSSBH=B.MXDM,FFJHZSS=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FFJHZSSBH=B.MXDM AND B.LBDM='112' 
 UPDATE  A set FIFSHBFZBH=B.MXDM,FIFSHBFZ=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FIFSHBFZBH=B.MXDM AND B.LBDM='112'  
 UPDATE  A set FSHBFZBH=B.MXDM,FSHBFZ=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FSHBFZBH=B.MXDM AND B.LBDM='149' 
 UPDATE  A set FIFOPBH=B.MXDM,FIFOP=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FIFOPBH=B.MXDM AND B.LBDM='112'  
 UPDATE  A set FIFJRSSBH=B.MXDM,FIFJRSS=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FIFJRSSBH=B.MXDM AND B.LBDM='112'  
 UPDATE  A set FSSXZBH=B.MXDM,FSSXZ=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FSSXZBH=B.MXDM AND B.LBDM='144' 
 UPDATE  A set FSSLBBH=B.MXDM,FSSLB=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FSSLBBH=B.MXDM AND B.LBDM='145'  
 UPDATE  A set FIFXJSXMBH=B.MXDM,FIFXJSXM=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FIFXJSXMBH=B.MXDM AND B.LBDM='112' 
 UPDATE  A set FMZFJBH=B.MXDM,FMZFJ=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FMZFJBH=B.MXDM AND B.LBDM='146' 
 UPDATE  A set FMZBFZBH=B.MXDM,FMZBFZ=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FMZBFZBH=B.MXDM AND B.LBDM='147' 
 UPDATE  A set FSSLTZZSBJBH=B.MXDM,FSSLTZZSBJ=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FSSLTZZSBJBH=B.MXDM AND B.LBDM='112'  
 UPDATE  A set FSSFXFJBH=B.MXDM,FSSFXFJ=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FSSFXFJBH=B.MXDM AND B.LBDM='71' 
 UPDATE  A set FIFYFDSSBH=B.MXDM,FIFYFDSS=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FIFYFDSSBH=B.MXDM AND B.LBDM='112' 
 UPDATE  A set FSSFLBH=B.MXDM,FSSFL=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FSSJBBH=B.MXDM AND B.LBDM='235'
 UPDATE  A set FSSBWGRBH=B.MXDM,FSSBWGR=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FSSBWGRBH=B.MXDM AND B.LBDM='112' 
 UPDATE  A set FGRBWBH=B.MXDM,FGRBW=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FGRBWBH=B.MXDM AND B.LBDM='150' 
 UPDATE  A set FIFSHSWBH=B.MXDM,FIFSHSW=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FIFSHSWBH=B.MXDM AND B.LBDM='112' 
 UPDATE  A set FSQYFSYKJYWBH=B.MXDM,FSQYFSYKJYW=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FSQYFSYKJYWBH=B.MXDM AND B.LBDM='112'  
 UPDATE  A set FSZZJKJYWBH=B.MXDM,FSZZJKJYW=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FSZZJKJYWBH=B.MXDM AND B.LBDM='112' 
 UPDATE  A set FSZZJKJYWYYBH=B.MXDM,FSZZJKJYWYY=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FSZZJKJYWYYBH=B.MXDM AND B.LBDM='152'  
 UPDATE  A set FSHYFSYKJYWBH=B.MXDM,FSHYFSYKJYW=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FSHYFSYKJYWBH=B.MXDM AND B.LBDM='112'  
 UPDATE  A set FSSYPFZBFFBH=B.MXDM,FSSYPFZBFF=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FSSYPFZBFFBH=B.MXDM AND B.LBDM='153'  
 UPDATE  A set FSZBDJCBH=B.MXDM,FSZBDJC=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FSZBDJCBH=B.MXDM AND B.LBDM='112'  
 UPDATE  A set FYWFJHZSSBH=B.MXDM,FYWFJHZSS=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FYWFJHZSSBH=B.MXDM AND B.LBDM='94'  
 UPDATE  A set FIFSZSXBH=B.MXDM,FIFSZSX=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FIFSZSXBH=B.MXDM AND B.LBDM='112'  
 UPDATE  A set FSZSXPZBH=B.MXDM,FSZSXPZ=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FSZSXPZBH=B.MXDM AND B.LBDM='154'  
 UPDATE  A set FSSBDYSLBLZDBH=B.MXDM,FSSBDYSLBLZD=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FSSBDYSLBLZDBH=B.MXDM AND B.LBDM='140' 
 UPDATE  A set FSQYSHBLZDBH=B.MXDM,FSQYSHBLZD=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FSQYSHBLZDBH=B.MXDM AND B.LBDM='140' 
 UPDATE  A set FIFSZYWYLBH=B.MXDM,FIFSZYWYL=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FIFSZYWYLBH=B.MXDM AND B.LBDM='112' 
 UPDATE  A set FQSMZSFTWXHBH=B.MXDM,FQSMZSFTWXH=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FQSMZSFTWXHBH=B.MXDM AND B.LBDM='112'  
 UPDATE  A set FMZYSZTZLBH=B.MXDM,FMZYSZTZL=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FMZYSZTZLBH=B.MXDM AND B.LBDM='112' 
 UPDATE  A set FMZYSZTZLSJBH=B.MXDM,FMZYSZTZLSJ=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FMZYSZTZLSJBH=B.MXDM AND B.LBDM='237' 
 UPDATE  A set FMZYSXFFSZLBH=B.MXDM,FMZYSXFFSZL=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FMZYSXFFSZLBH=B.MXDM AND B.LBDM='112'  
 UPDATE  A set FIFXFFSCGBH=B.MXDM,FIFXFFSCG=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FIFXFFSCGBH=B.MXDM AND B.LBDM='112'  
 UPDATE  A set FIFSTEWARDBH=B.MXDM,FIFSTEWARD=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FIFSTEWARDBH=B.MXDM AND B.LBDM='112' 
 UPDATE  A set FJRMZFSSBH=B.MXDM,FJRMZFSS=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FJRMZFSSBH=B.MXDM AND B.LBDM='112' 
 UPDATE  A set FFSMZFYQSJBH=B.MXDM,FFSMZFYQSJ=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FFSMZFYQSJBH=B.MXDM AND B.LBDM='112'  
 UPDATE  A set FMZFYQXGSJBH=B.MXDM,FMZFYQXGSJ=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FMZFYQXGSJBH=B.MXDM AND B.LBDM='238' 
 --����������ʾ��Ϣ

update A set FSHYFYKJYWSJ='С��24Сʱ' from #ba4 A where FSHYFYKJYWSJ='1'
update A set FSHYFYKJYWSJ='24-48Сʱ' from #ba4 A where FSHYFYKJYWSJ='2'
update A set FSHYFYKJYWSJ='48-72Сʱ' from #ba4 A where FSHYFYKJYWSJ='3'
update A set FSHYFYKJYWSJ='����72Сʱ' from #ba4 A where FSHYFYKJYWSJ='4'         

update A set FSQSYYFKJYWSJ='0.5Сʱ' from #ba4 A where FSQSYYFKJYWSJ='1'
update A set FSQSYYFKJYWSJ='1Сʱ' from #ba4 A where FSQSYYFKJYWSJ='2'
update A set FSQSYYFKJYWSJ='2Сʱ' from #ba4 A where FSQSYYFKJYWSJ='3'
update A set FSQSYYFKJYWSJ='2Сʱ������' from #ba4 A where FSQSYYFKJYWSJ='4'    

update A set FSHSWSJ='С��24Сʱ' from #ba4 A where FSHSWSJ='1'
update A set FSHSWSJ='24-48Сʱ' from #ba4 A where FSHSWSJ='2'
update A set FSHSWSJ='48-72Сʱ' from #ba4 A where FSHSWSJ='3'
update A set FSHSWSJ='����72Сʱ' from #ba4 A where FSHSWSJ='4'    
   
 --Ĭ�ϵ�һ������Ϊ��Ҫ����                                 
 update #ba4 set FIFFSOP=0 where FOPTIMES=1        
 update #ba4 set FIFFSOP=1 where FOPTIMES<>1        
        
 update #ba4 set FZQSSBH=1 ,FZQSS='��' from  #ba4 a,CPOE_SSYZK b                  
 where  a.FZYID=b.SYXH AND a.FOPCODE=b.SSDM  AND  b.SSFL<>1                ------by  lius        
         
 --������������        
 UPDATE  A set FSSJBBH=B.MXDM,FSSJB=B.NAME from  #ba4 A , EMR_SYS_ZDFLMXK B (nolock) where A.FSSJBBH=B.MXDM AND B.LBDM='120'
 	update A set FSSJB='һ��' from #ba4 A where FSSJBBH='1'
	update A set FSSJB='����' from #ba4 A where FSSJBBH='2'
	update A set FSSJB='����' from #ba4 A where FSSJBBH='3'
	update A set FSSJB='�ļ�' from #ba4 A where FSSJBBH='4'
 
--�����пڵȼ�
update A set FQIEKOU='0��' from #ba4 A where FQIEKOUBH='0'
update A set FQIEKOU='��' from #ba4 A where FQIEKOUBH='1'
update A set FQIEKOU='��' from #ba4 A where FQIEKOUBH='2'
update A set FQIEKOU='��' from #ba4 A where FQIEKOUBH='3'         
update A set FQIEKOUBH='' from #ba4 A where FQIEKOUBH='��' 

--��������ʽ
update A set FMAZUIBH='35',FMAZUI='�ֲ���������' from #ba4 A where FMAZUIBH='0302'  

--��''ת��Ϊ'-'
 update #ba4 set FMAZUI='-' where FMAZUI='' 
 update #ba4 set FMAZUI='-' where FMAZUI is NULL
 update #ba4 set FOPDOCT1BH='-' where FOPDOCT1BH='' and FOPCODE<>''
 update #ba4 set FOPDOCT1='-' where FOPDOCT1='' and FOPCODE<>''
 update #ba4 set FOPDOCT2BH='-' where FOPDOCT2BH='' and FOPCODE<>''
 update #ba4 set FOPDOCT2='-' where FOPDOCT2='' and FOPCODE<>''
 update #ba4 set FMZDOCTBH='-' where FMZDOCTBH='' and FOPCODE<>''
 update #ba4 set FMZDOCT='-' where FMZDOCT='' and FOPCODE<>''

       
 --HIS_��Ӥ����HIS_BA5��                  
 insert into #ba5(FSYXH, FPRN, FTIMES, FBABYNUM, FNAME, FBABYSEXBH, FBABYSEX, FTZ, FRESULTBH, FRESULT, FZGBH, FZG, FBABYSUC, FHXBH, FHX)                      
 select A.SYXH FSYXH,A.BAHM,B.YEXH,B.YEXH,A.HZXM,B.YEXB,D.NAME,CAST(ISNULL(YETZ,0.0) AS FLOAT) YETZ,B.CCQK,E.NAME,B.CYQK,F.NAME,null,null,null                  
 from  EMR_BRSYK A (nolock)         
 inner join #PAT P ON A.SYXH=P.EMRSYXH                 
 inner join  EMR_BASY_YEK B (nolock)  on B.QTBLJLXH=P.QTBLJLXH and B.SYXH=B.QTBLJLXH                  
 left join EMR_SYS_ZDFLMXK D (nolock) on D.MXDM=B.YEXB and D.LBDM = '3'                    
 left join EMR_SYS_ZDFLMXK E (nolock) on E.MXDM=B.CCQK and E.LBDM = '32'                  
 left join EMR_SYS_ZDFLMXK F (nolock) on E.MXDM=B.CYQK and E.LBDM = '34'            
         
 --��ҽԺ���˸�����Ϣ��HIS_BA8��                  
 insert into #ba8(FSYXH, FPRN, FTIMES, FZLLBBH, FZLLB, FZZZYBH, FZZZY, FRYCYBH, FRYCY,                  
 FMZZDZBBH, FMZZDZB, FMZZDZZBH,FMZZDZZ, FMZZYZDBH, FMZZYZD, FSSLCLJBH, FSSLCLJ, FSYJGZJBH, FSYJGZJ,                   
 FSYZYSBBH, FSYZYSB, FSYZYJSBH, FSYZYJS, FBZSHBH, FBZSH)                      
 select A.SYXH FSYXH,A.BAHM FPRN,A.RYCS FTIMES,B.ZLLB FZLLBBH,'' FZLLB,B.SYYLJGZYZJ FZZZYBH,'' FZZZY,B.RCFH_ZY FRYCYBH,'' FRYCY,                  
 B.MZZD_ZY FMZZDZBBH,B.MZZDMC_ZY FMZZDZB,B.MZZH_ZY FMZZDZZBH,B.MZZHMC_ZY FMZZDZZ,                  
 B.MZZD_ZY FMZZYZDBH,B.MZZDMC_ZY FMZZYZD,B.SSLCLJ FSSLCLJBH,'' FSSLCLJ,B.SYYLJGZYZJ FSYJGZJBH,'' FSYJGZJ,        
 B.SYZYZLSB FSYZYSBBH,'' FSYZYSB,B.SYZYZLJS FSYZYJSBH,'' FSYZYJS,B.BZSH FBZSHBH,'' FBZSH                  
 from  EMR_BRSYK A (nolock)        
 inner join #PAT P on A.SYXH=P.EMRSYXH                  
 left join EMR_BASYK B on B.QTBLJLXH=P.QTBLJLXH and B.SYXH=P.EMRSYXH                  
 where ISNULL(ZLLB,'')<>''     
 
  --�����ֵ�����ȡ�����ֶ�                  
 update  A set FZLLB=B.NAME from #ba8 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FZLLBBH=B.MXDM  and B.LBDM='110'        
 update  A set FZZZY=B.NAME from #ba8 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FZZZYBH=B.MXDM  and B.LBDM='95'        
 update  A set FRYCY=B.NAME from #ba8 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FRYCYBH=B.MXDM  and B.LBDM='12'         
 update  A set FSSLCLJ=B.NAME from #ba8 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FSSLCLJBH=B.MXDM  and B.LBDM='111'         
 update  A set FSYJGZJ=B.NAME from #ba8 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FSYJGZJBH=B.MXDM  and B.LBDM='95'         
 update  A set FSYZYSB=B.NAME from #ba8 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FSYZYSBBH=B.MXDM  and B.LBDM='95'         
 update  A set FSYZYJS=B.NAME from #ba8 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FSYZYJSBH=B.MXDM  and B.LBDM='95'         
 update  A set FBZSH=B.NAME from #ba8 A , EMR_SYS_ZDFLMXK B (nolock) where  A.FBZSHBH=B.MXDM  and B.LBDM='95'    
 
  insert into #His_ba_ahfy     (FSYXH,FPRN, FTIMES, FKSSSYFA,	FKSSSYSJ,	FJRSJ,	FZCSJ)
  SELECT A.SYXH SYXH ,A.BAHM FPRN,A.RYCS FTIMES,D.KSSZLFA FKSSSYFA,'',	D.ICURZSJ FJRSJ,D.ICUZCSJ FZCSJ
   from  EMR_BRSYK A (nolock)        
 inner join #PAT P on A.SYXH=P.EMRSYXH 
 inner join EMR_BASYK_FB D (nolock)  on  D.QTBLJLXH=P.QTBLJLXH and D.SYXH=A.SYXH 

  update  A set FJRSJ=NULL from #His_ba_ahfy  A (nolock) where  A.FJRSJ='1900-01-01 00:00:00.000'
  update  A set FZCSJ=NULL from #His_ba_ahfy  A (nolock) where  A.FZCSJ='1900-01-01 00:00:00.000'


  

 --  insert into #his_ba13     (FPRN, FTIMES)
 -- SELECT A.BAHM FPRN,A.RYCS FTIMES
 --  from  EMR_BRSYK A (nolock)        
 --inner join #PAT P on A.SYXH=P.EMRSYXH  
 -- inner join EMR_BASYK_FB D (nolock)  on D.QTBLJLXH=P.QTBLJLXH and D.SYXH=A.SYXH 

         
          
        
 --�Ƿ�����                                                  
 update #ba1 set FIFSS=1 where exists (select 1 from #ba4 where #ba4.FSYXH=#ba1.FSYXH)               
 --����ת�ƿ�����Ϣ        
 update  A set FZKDEPT =B.NAME from #ba2 A , EMR_SYS_KSDMK B (nolock) where  A.FZKTYKH=B.KSDM                                            
 --�״�ת��                                                  
 --update #ba1 set FZKTYKH=B.FZKTYKH,FZKDEPT=B.FZKDEPT, FZKDATE=B.FZKDATE,FZKTIME=B.FZKTIME from #ba2 B where B.FTIMES=1           
 update A SET A.FZKTYKH=B.FZKTYKH,A.FZKDEPT=B.FZKDEPT,A.FZKDATE=B.FZKDATE,A.FZKTIME=B.FZKTIME FROM #ba1 A,(select t.* from        
 (select *,row_number() over (partition by FPRN,FTIMES order by FPRN,FTIMES,FZKDATE,FZKTIME desc) rn from #ba2) t        
 where rn=1) B WHERE A.FPRN=B.FPRN AND A.FTIMES=B.FTIMES          
 --delete #ba2 where FTIMES=1         
        
 --���� ������        
 update a set a.NLDAYS = datediff(dd,a.FBIRTHDAY,a.FRYDATE) from #ba1 a        
 --���������        
 select dbo.CalculateAge(FBIRTHDAY,FRYDATE) ba into #aa from #ba1 a        
 update a set a.FAGENEW=dbo.CalculateAge(FBIRTHDAY,FRYDATE) from #ba1 a        
 --���䲻��һ�������        
 update a set FNLBZYZS=dbo.CalculateAgeDetails(FBIRTHDAY,FRYDATE) from #ba1 a where a.NLDAYS<365        
 --������㣨��Y/M/D��ͷ��        
 update a set FAGE=case when FLOOR(a.NLDAYS/365.00)>=1 then 'Y'+cast(FLOOR(a.NLDAYS/365.00) as varchar(4))        
 when a.NLDAYS/30>=1 then 'M'+cast(a.NLDAYS/30 as varchar(4))        
 when a.NLDAYS>=1 then 'D'+cast(a.NLDAYS as varchar(4))         
 else 'D0' end        
 from #ba1 a        
-- --Ĭ�ϲ���һ��Ӥ������--mwg        
 update a set FNLBZYZS=0.03 from #ba1 a where FAGE='D0'        
        
 --ǿ�ƽ��ʿ����ڵ���Ϊ��Ժ���ں�һ�� (�ʿ�����С�ڳ�Ժ����)       
 update A SET A.FZKRQ=dateadd(dd,1,A.FCYDATE) from #ba1 A where A.FZKRQ<A.FCYDATE       
 --���� ǿ�ƽ�������������Ϊ�׼�����(��ԺδҪ��-mwg)        
 --update A SET A.FQUALITYBH='1',A.FQUALITY='��' from #ba1 A        
         
 --�������                  
 if exists(select * from sysobjects where name='#BRFYMXK' and xtype='U')                   
 BEGIN                  
  DROP TABLE #BRFYMXK                  
 END                  
 select a.syxh as syxh,convert(varchar(12),idm) idm,zje,ypdm,dxmdm,jlzt 
 into #BRFYMXK 
 from [172.20.0.41\ZY].[THIS_ZY].[dbo].XZY_BRFYMXK as a,#PAT p where a.syxh=p.HISSYXH
 
 create  index  idx_idm_ypdm on  #BRFYMXK(idm,ypdm)                      
 -------add lr20140909 �ܷ���;                  
 
 update a set FSUM1=b.FSUM1 from #ba1 a,                      
 (select c.syxh,sum(c.zje) FSUM1 from #BRFYMXK c         
 group by c.syxh) b                   
 where a.FZYID=b.syxh                  --alter by z_jx 2017��2��25��17:44:14              

        
 ----��ҩ��                                                 
 update a set FXYF=b.FXYF from #ba1 a,                                                                                    
 (select c.syxh,sum(c.zje) FXYF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d  on  convert(varchar,c.idm)=d.xmdm and d.fylb='0' and c.idm<>'0'                                        
 where d.id='13'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                  
        
 ---add lr20170217 �г�ҩ��;                                                                                              
 update a set FZCHYF=b.FZCHYF from #ba1 a,                                                                                    
 (select c.syxh,sum(c.zje) FZCHYF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d  on  convert(varchar,c.idm)=d.xmdm and d.fylb='0' and c.idm<>'0'                   
 where d.id='14'  group by c.syxh) b                
 where a.FZYID=convert(varchar(20),b.syxh)               
        
 ---add lr20170217 �в�ҩ��;                                                                                                                              
 update a set FZCYF=b.FZCYF from #ba1 a,                                                                                    
 (select c.syxh,sum(c.zje) FZCYF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on convert(varchar,c.idm)=d.xmdm and d.fylb='0' and c.idm<>'0'                                        
 where d.id='15'   group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)               
 ------------------------------------------              
        
 ---add lr20170217 ������;                                                                                              
 update a set FQTF=b.FQTF from #ba1 a,                                                                                    
 (select c.syxh,sum(c.zje) FQTF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                         
 where d.id='24'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                                               
 ---add lr20170217 �Ը����;                                                       
 update a set FZFJE=b.FZFJE from #ba1 a,                                                          
 (select c.syxh,sum(c.zfje) FZFJE from [172.20.0.41\ZY].[THIS_ZY].[dbo].ZY_BRJSK c                                                      
 group by c.syxh) b                                                       
 where a.FZYID=convert(varchar(20),b.syxh)                                                                                 
 ---add lr20170217 һ��ҽ�Ʒ����;                                                                                                                               
 update a set FZHFWLYLF=b.FZHFWLYLF from #ba1 a,                                                                                    
 (select c.syxh,sum(c.zje) FZHFWLYLF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                         
 where d.id='1'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                                               
 ---add lr20170217 һ�����Ʋ�����;                                                                                                                    
 update a set FZHFWLCZF=b.FZHFWLCZF from #ba1 a,                                                                                    
 (select c.syxh,sum(c.zje) FZHFWLCZF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                         
 where d.id='2'  group by c.syxh) b                                    
 where a.FZYID=convert(varchar(20),b.syxh)                                                               
 ---add lr20170217 �����;                                                          
 update a set FZHFWLHLF=b.FZHFWLHLF from #ba1 a,                                              
 (select c.syxh,sum(c.zje) FZHFWLHLF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                         
 where d.id='3'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                                                            
 ---add lr20170217 �ۺ�ҽ�Ʒ���������;                                                          
 update a set FZHFWLQTF=b.FZHFWLQTF from #ba1 a,                                                                                    
 (select c.syxh,sum(c.zje) FZHFWLQTF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                         
 where d.id='4'  group by c.syxh) b                     
 where a.FZYID=convert(varchar(20),b.syxh)                    
 ---add lr20170217 ������Ϸ�;                           
 update a set FZDLBLF=b.FZDLBLF from #ba1 a,                                                                                    
 (select c.syxh,sum(c.zje) FZDLBLF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                         
 where d.id='5'  group by c.syxh) b                       
 where a.FZYID=convert(varchar(20),b.syxh)                
 ---add lr20170217 ʵ������Ϸ�;                                                          
 update a set FZDLSSSF=b.FZDLSSSF from #ba1 a,                                                                                    
 (select c.syxh,sum(c.zje) FZDLSSSF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                         
 where d.id='6'  group by c.syxh) b          
 where a.FZYID=convert(varchar(20),b.syxh)                                                          
 ---add lr20170217 Ӱ��ѧ��Ϸ�;                                                          
 update a set FZDLYXF=b.FZDLYXF from #ba1 a,                                                                                    
 (select c.syxh,sum(c.zje) FZDLYXF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                         
 where d.id='7'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                    
 ---add lr20170217 �ٴ������Ŀ��;                                                          
 update a set FZDLLCF=b.FZDLLCF from #ba1 a,                                                                                      
 (select c.syxh,sum(c.zje) FZDLLCF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                       
 where d.id='8'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                    
 ---add lr20170217 ������������Ŀ��;                                                          
 update a set FZLLFFSSF=b.FZLLFFSSF from #ba1 a,                                                                                     
 (select c.syxh,sum(c.zje) FZLLFFSSF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                     
 where d.id='9'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                            
 ---add lr20170217 �ٴ��������Ʒ�;                                                         
 update a set FZLLFWLZWLF=b.FZLLFWLZWLF from #ba1 a,                
 (select c.syxh,sum(c.zje) FZLLFWLZWLF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                     
 where d.id='9-1'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                            
 ---add lr20170217 �������Ʒ�;                                                          
 update a set FZLLFSSF=b.FZLLFSSF from #ba1 a,                                                                                      
 (select c.syxh,sum(c.zje) FZLLFSSF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                     
 where d.id='10'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                            
 ---add lr20170217 �����;                                                          
 update a set FZLLFMZF=b.FZLLFMZF from #ba1 a,                                                                                     
 (select c.syxh,sum(c.zje) FZLLFMZF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                  
 where d.id='10-1'  group by c.syxh) b                                
 where a.FZYID=convert(varchar(20),b.syxh)                                                        
 ---add lr20170217 ������;                                                          
 update a set FZLLFSSZLF=b.FZLLFSSZLF from #ba1 a,                                                                                      
 (select c.syxh,sum(c.zje) FZLLFSSZLF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                   
 where d.id='10-2'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                  
 ---add lr20170217 ������;                                        
 update a set FKFLKFF=b.FKFLKFF from #ba1 a,                                                                                     
 (select c.syxh,sum(c.zje) FKFLKFF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                      
 where d.id='11'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                          
 ---add lr20170217 ����ҩ���;                                                          
 update a set  FXYLGJF=b.FXYLGJF from #ba1 a,                                        
 (select c.syxh,sum(c.zje) FXYLGJF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on  convert(varchar,c.idm)=d.xmdm and d.fylb='0' and c.idm<>'0'                                                        
 where d.id='13-1' group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                           
 ---add lr20170217 Ѫ��;                                           
 update a set FXYLXF=b.FXYLXF from #ba1 a,                                                                                       
 (select c.syxh,sum(c.zje) FXYLXF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                      
 where d.id='16'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                         
 ---add lr20170217 �׵�������Ʒ��;  (δ��Ӧ)                                                        
 update a set FXYLBQBF=b.FXYLBQBF from #ba1 a,                                                             
 (select c.syxh,sum(c.zje) FXYLBQBF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                   
 where d.id='17'   group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                         
 ---add lr20170217 �򵰰�����Ʒ��;                                                          
 update a set FXYLQDBF=b.FXYLQDBF from #ba1 a,                                
 (select c.syxh,sum(c.zje) FXYLQDBF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                    
 where d.id='18' group by c.syxh) b                              
 where a.FZYID=convert(varchar(20),b.syxh)                                                         
 ---add lr20170217 ��Ѫ��������Ʒ��;                                             
 update a set FXYLYXYZF=b.FXYLYXYZF from #ba1 a,                                                                                    
 (select c.syxh,sum(c.zje) FXYLYXYZF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                      
 where d.id='38'  group by c.syxh) b                                 
 where a.FZYID=convert(varchar(20),b.syxh)                                                          
 ---add lr20170217 ϸ����������Ʒ��;                  
 update a set FXYLXBYZF=b.FXYLXBYZF from #ba1 a,                                  
 (select c.syxh,sum(c.zje) FXYLXBYZF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                       
 where d.id='20'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                         
 ---add lr20170217 �����һ����ҽ�ò��Ϸ�;                           
 update a set FHCLCJF=b.FHCLCJF from #ba1 a,                
 (select c.syxh,sum(c.zje) FHCLCJF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                     
 where d.id='21'  group by c.syxh) b                                         
 where a.FZYID=convert(varchar(20),b.syxh)                                                      
 ---add lr20170217 ������һ����ҽ�ò���;                                                          
 update a set FHCLZLF=b.FHCLZLF from #ba1 a,                                                                                     
 (select c.syxh,sum(c.zje) FHCLZLF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                 
 where d.id='22'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                          
 ---add lr20170217 ������һ����ҽ�ò��Ϸ�;                                           
 update a set FHCLSSF=b.FHCLSSF from #ba1 a,                     
 (select c.syxh,sum(c.zje) FHCLSSF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                   
 where d.id='23' group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                       
 ---add lr20170217 ��ҽ��֤���η�;                                                          
 update a set  FZHFWLYLF01=b.FZHFWLYLF01 from #ba1 a,                                                                                      
 (select c.syxh,sum(c.zje) FZHFWLYLF01 from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                     
 where d.id='02'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                      
 ---add lr20170217 ��ҽ��֤���λ����;                                             
 update a set  FZHFWLYLF02=b.FZHFWLYLF02 from #ba1 a,                                                                                    
 (select c.syxh,sum(c.zje) FZHFWLYLF02 from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                       
 where d.id='03'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                      
 ---add lr20170217 ��ҽ��Ϸ�;                    
 update a set FZYLZDF=b.FZYLZDF from #ba1 a,                                                                   
 (select c.syxh,sum(c.zje) FZYLZDF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                       
 where d.id='18'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                          
 ---add lr20170217 ��ҽ���Ʒ�;   ��δ��Ӧ��                                                      
 update a set FZYLZF=b.FZYLZLF from #ba1 a,                                                                                       
 (select c.syxh,sum(c.zje) FZYLZLF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                      
 where d.id='19'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                  
 ---add lr20170217 ��ҽ���η�;          
 update a set FZYLZLF01=b.FZYLZLF01 from #ba1 a,                                         
 (select c.syxh,sum(c.zje) FZYLZLF01 from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                     
 where d.id='20'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                      
 ---add lr20170217 ��ҽ���˷�;                                                  
 update a set FZYLZLF02=b.FZYLZLF02 from #ba1 a,                                                                          
 (select c.syxh,sum(c.zje) FZYLZLF02 from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                     
 where d.id='22'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                
 ---add lr20170217 ��ҽ��ķ�;                                                          
 update a set FZYLZLF03=b.FZYLZLF03 from #ba1 a,                                                                                     
 (select c.syxh,sum(c.zje) FZYLZLF03 from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                       
 where d.id='23'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                         
 ---add lr20170217 ��ҽ�������Ʒ�;                                                          
 update a set FZYLZLF04=b.FZYLZLF04 from #ba1 a,                                                                        
 (select c.syxh,sum(c.zje) FZYLZLF04 from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                       
 where d.id='24'  group by c.syxh) b                             
 where a.FZYID=convert(varchar(20),b.syxh)                                                       
 ---add lr20170217 ��ҽ�س����Ʒ�;                                                          
 update a set FZYLZLF05=b.FZYLZLF05 from #ba1 a,                   
 (select c.syxh,sum(c.zje) FZYLZLF05 from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                   
 where d.id='25'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                        
 ---add lr20170217 ��ҽ�������Ʒ�;                                                          
 update a set FZYLZLF06=b.FZYLZLF06 from #ba1 a,                                                                                        
 (select c.syxh,sum(c.zje) FZYLZLF06 from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                      
 where d.id='26'  group by c.syxh) b                                  
 where a.FZYID=convert(varchar(20),b.syxh)                       
 ---add lr20170217 ��ҽ������;                                                            
 update a set FZYLQTF=b.FZYLQTF from #ba1 a,                                                                                      
 (select c.syxh,sum(c.zje) FZYLQTF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                       
 where d.id='27'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                    
 ---add lr20170217 ��ҽ�������ӹ���;                                                          
 update a set FZYLQTF01=b.FZYLQTF01 from #ba1 a,                                                                           
 (select c.syxh,sum(c.zje) FZYLQTF01 from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                          
 where d.id='28'  group by c.syxh) b                 
 where a.FZYID=convert(varchar(20),b.syxh)                                         
 ---add lr20170217 ��ҽ��֤ʩ�ŷ�;                                                          
 update a set FZYLQTF02=b.FZYLQTF02 from #ba1 a,                                                                                       
 (select c.syxh,sum(c.zje) FZYLQTF02 from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                           
 where d.id='29'  group by c.syxh) b                                                
 where a.FZYID=convert(varchar(20),b.syxh)                                                      
 ---add lr20170217 ��ҽ�Ƽ���;                                                          
 update a set FZCLJGZJF=b.FZCLJGZJF from #ba1 a,                                                                          
 (select c.syxh,sum(c.zje) FZCLJGZJF from #BRFYMXK c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on  convert(varchar,c.idm)=d.xmdm and d.fylb='1' and c.idm<>'0'                                                    
 where d.id='33'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                  
            ---zzz   
update #ba1 set FZHFWLYLF='29750.00'  where FPRN='20190000521'
update #ba1 set FZHFWLCZF='9705.30'  where FPRN='20190000521'
update #ba1 set FZHFWLHLF='1023.60'  where FPRN='20190000521'
update #ba1 set FZHFWLQTF='1818.00'  where FPRN='20190000521'
update #ba1 set FZDLSSSF='2471.40'  where FPRN='20190000521'
update #ba1 set FZDLYXF='5396.20'  where FPRN='20190000521'
update #ba1 set FZDLLCF='947.60'  where FPRN='20190000521'
update #ba1 set FZLLFFSSF='4048.00'  where FPRN='20190000521'
update #ba1 set FZLLFWLZWLF='3898.40'  where FPRN='20190000521'
update #ba1 set FZLLFSSF='16996.00'  where FPRN='20190000521'
update #ba1 set FZLLFMZF='797.50'  where FPRN='20190000521'
update #ba1 set FZLLFSSZLF='10655.50'  where FPRN='20190000521'
update #ba1 set FKFLKFF='2640.00'  where FPRN='20190000521'
update #ba1 set FSUM1='160407.34'  where FPRN='20190000521'
update #ba1 set FXYF='61316.24'  where FPRN='20190000521'
update #ba1 set FZCHYF='3299.51'  where FPRN='20190000521'
update #ba1 set FXYLGJF='1845.76'  where FPRN='20190000521'
update #ba1 set FXYLXF='315.00'  where FPRN='20190000521'
update #ba1 set FHCLCJF='168.56'  where FPRN='20190000521'
update #ba1 set FHCLZLF='12917.73'  where FPRN='20190000521'
update #ba1 set FHCLSSF='7544.20'  where FPRN='20190000521'
update #ba1 set FQTF='50.00'  where FPRN='20190000521'

update #ba1 set FXYF=FXYF+FXYLGJF
update #ba1 set FZLLFSSF=FZLLFMZF+FZLLFSSF+FZLLFSSZLF
update #ba1 set FZLLFFSSF=FZLLFFSSF+FZLLFWLZWLF 
update #ba1 set FZFJE=0 where FZFJE<0
  update #ba1 set  FQTF=FSUM1-(FZHFWLYLF+FZHFWLCZF+FZHFWLHLF+FZHFWLQTF+FZDLBLF+FZDLSSSF+FZDLYXF+FZDLLCF+FZLLFFSSF+FZLLFSSF+FKFLKFF+FZYLZF+FXYLXF+
FXYLBQBF+FXYLQDBF+FXYLYXYZF+FXYLXBYZF+FHCLCJF+FHCLZLF+FHCLSSF+FXYF+FZCYF+FZCHYF) where
 FSUM1-(FZHFWLYLF+FZHFWLCZF+FZHFWLHLF+FZHFWLQTF+FZDLBLF+FZDLSSSF+FZDLYXF+FZDLLCF+FZLLFFSSF+FZLLFSSF+FKFLKFF+FZYLZF+FXYLXF+
FXYLBQBF+FXYLQDBF+FXYLYXYZF+FXYLXBYZF+FHCLCJF+FHCLZLF+FHCLSSF+FXYF+FZCYF+FZCHYF)>0          
       
END        
ELSE IF (@type=1)        
BEGIN         
 --PRINT(1)        
 --HIS_����סԺ��Ϣ��HIS_BA1��                  
 insert into #ba101(FIFINPUT, FICDVERSION, FZYID, FPRN, FTIMES)                      
 select '0' FIFINPUT, '11' FICDVERSION, A.HISSYXH, A.BAHM FPRN,A.RYCS FTIMES                  
 from EMR_BRSYK A (nolock)         
 inner join #PAT2 P ON A.SYXH=P.EMRSYXH                 
 left join EMR_BASYK B (nolock) on B.QTBLJLXH=P.QTBLJLXH and B.SYXH=P.EMRSYXH                  
 --�������                  
 if exists(select * from sysobjects where name='#BRFYMXK1' and xtype='U')                   
 BEGIN                  
  DROP TABLE #BRFYMXK1                 
 END                  
 select a.syxh as syxh,convert(varchar(12),idm) idm,zje,ypdm,dxmdm,jlzt 
 into #BRFYMXK1 
 from [172.20.0.41\ZY].[THIS_ZY].[dbo].XZY_BRFYMXK as a,#PAT2 p where a.syxh=p.HISSYXH     
                    
 ---add lr20140909 �ܷ���;                  
 update a set FSUM1=b.FSUM1 from #ba101 a,                      
 (select c.syxh,sum(c.zje) FSUM1 from #BRFYMXK1 c         
 group by c.syxh) b        
 where a.FZYID=b.syxh                  
 --- alter by z_jx 2017��2��25��17:44:14              
        
        
 ----��ҩ��                                                 
 update a set FXYF=b.FXYF from #ba101 a,                                                                                    
 (select c.syxh,sum(c.zje) FXYF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d  on  convert(varchar,c.idm)=d.xmdm and d.fylb='0' and c.idm<>'0'                                        
 where d.id='13'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)        
                 
        
 ---add lr20170217 �г�ҩ��;                                                                                              
 update a set FZCHYF=b.FZCHYF from #ba101 a,                                                                                    
 (select c.syxh,sum(c.zje) FZCHYF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d  on convert(varchar,c.idm)=d.xmdm and d.fylb='0' and c.idm<>'0'                   
 where d.id='14'  group by c.syxh) b                 
 where a.FZYID=convert(varchar(20),b.syxh)               
        
 ---add lr20170217 �в�ҩ��;                                                                                                       
 update a set FZCYF=b.FZCYF from #ba101 a,                                                                                    
 (select c.syxh,sum(c.zje) FZCYF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on convert(varchar,c.idm)=d.xmdm and d.fylb='0' and c.idm<>'0'                                        
 where d.id='15'   group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)               
 ------------------------------------------              
        
 ---add lr20170217 ������;                                                                                              
 update a set FQTF=b.FQTF from #ba101 a,                                                                
 (select c.syxh,sum(c.zje) FQTF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                         
 where d.id='24'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                                               
 ---add lr20170217 �Ը����;                                                       
 update a set FZFJE=b.FZFJE from #ba101 a,                                                          
 (select c.syxh,sum(c.zfje) FZFJE from [172.20.0.41\ZY].[THIS_ZY].[dbo].ZY_BRJSK c                                                      
 group by c.syxh) b                                                       
 where a.FZYID=convert(varchar(20),b.syxh)                                                                                 
 ---add lr20170217 һ��ҽ�Ʒ����;                                                                                                                               
 update a set FZHFWLYLF=b.FZHFWLYLF from #ba101 a,                                                                                    
 (select c.syxh,sum(c.zje) FZHFWLYLF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                         
 where d.id='1'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                                               
 ---add lr20170217 һ�����Ʋ�����;                                                                                                                    
 update a set FZHFWLCZF=b.FZHFWLCZF from #ba101 a,                                                                                    
 (select c.syxh,sum(c.zje) FZHFWLCZF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                         
 where d.id='2'  group by c.syxh) b         
 where a.FZYID=convert(varchar(20),b.syxh)                                                               
 ---add lr20170217 �����;                                                          
 update a set FZHFWLHLF=b.FZHFWLHLF from #ba101 a,                                              
 (select c.syxh,sum(c.zje) FZHFWLHLF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                         
 where d.id='3'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                                                            
 ---add lr20170217 �ۺ�ҽ�Ʒ���������;                                                          
 update a set FZHFWLQTF=b.FZHFWLQTF from #ba101 a,                                                                                    
 (select c.syxh,sum(c.zje) FZHFWLQTF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                         
 where d.id='4'  group by c.syxh) b                     
 where a.FZYID=convert(varchar(20),b.syxh)                    
 ---add lr20170217 ������Ϸ�;                           
 update a set FZDLBLF=b.FZDLBLF from #ba101 a,             
 (select c.syxh,sum(c.zje) FZDLBLF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                         
 where d.id='5'  group by c.syxh) b                       
 where a.FZYID=convert(varchar(20),b.syxh)                
 ---add lr20170217 ʵ������Ϸ�;                                                          
 update a set FZDLSSSF=b.FZDLSSSF from #ba101 a,                                                                                    
 (select c.syxh,sum(c.zje) FZDLSSSF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                         
 where d.id='6'  group by c.syxh) b                                                      
 where a.FZYID=convert(varchar(20),b.syxh)                                                          
 ---add lr20170217 Ӱ��ѧ��Ϸ�;                                                          
 update a set FZDLYXF=b.FZDLYXF from #ba101 a,                                                                                    
 (select c.syxh,sum(c.zje) FZDLYXF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                         
 where d.id='7'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                    
 ---add lr20170217 �ٴ������Ŀ��;                                                          
 update a set FZDLLCF=b.FZDLLCF from #ba101 a,                                                                                      
 (select c.syxh,sum(c.zje) FZDLLCF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                       
 where d.id='8'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                    
 ---add lr20170217 ������������Ŀ��;                                                          
 update a set FZLLFFSSF=b.FZLLFFSSF from #ba101 a,                                                                                     
 (select c.syxh,sum(c.zje) FZLLFFSSF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                     
 where d.id='9'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                            
 ---add lr20170217 �ٴ��������Ʒ�;                                                         
 update a set FZLLFWLZWLF=b.FZLLFWLZWLF from #ba101 a,                
 (select c.syxh,sum(c.zje) FZLLFWLZWLF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                    
 where d.id='9-1'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                            
 ---add lr20170217 �������Ʒ�;                                                          
 update a set FZLLFSSF=b.FZLLFSSF from #ba101 a,                                                                                      
 (select c.syxh,sum(c.zje) FZLLFSSF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                     
 where d.id='10'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                            
 ---add lr20170217 �����;                                                          
 update a set FZLLFMZF=b.FZLLFMZF from #ba101 a,                                                                                     
 (select c.syxh,sum(c.zje) FZLLFMZF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                  
 where d.id='10-1'  group by c.syxh) b                                
 where a.FZYID=convert(varchar(20),b.syxh)                                                        
 ---add lr20170217 ������;          
 update a set FZLLFSSZLF=b.FZLLFSSZLF from #ba101 a,                                                                                      
 (select c.syxh,sum(c.zje) FZLLFSSZLF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                   
 where d.id='10-2'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                  
 ---add lr20170217 ������;                                                        
 update a set FKFLKFF=b.FKFLKFF from #ba101 a,                                                                                     
 (select c.syxh,sum(c.zje) FKFLKFF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                      
 where d.id='11'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                          
 ---add lr20170217 ����ҩ���;                                                          
 update a set  FXYLGJF=b.FXYLGJF from #ba101 a,                                        
 (select c.syxh,sum(c.zje) FXYLGJF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on  convert(varchar,c.idm)=d.xmdm and d.fylb='0' and c.idm<>'0'                                                        
 where d.id='13-1' group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                           
 ---add lr20170217 Ѫ��;                                           
 update a set FXYLXF=b.FXYLXF from #ba101 a,                                                                                       
 (select c.syxh,sum(c.zje) FXYLXF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                      
 where d.id='16'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                         
 ---add lr20170217 �׵�������Ʒ��;  (δ��Ӧ)                                                        
 update a set FXYLQDBF=b.FXYLQDBF from #ba101 a,                                                                
 (select c.syxh,sum(c.zje) FXYLQDBF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                   
 where d.id='17'   group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                              
 ---add lr20170217 �򵰰�����Ʒ��;                                                          
 update a set FXYLQDBF=b.FXYLQDBF from #ba101 a,                                                                                      
 (select c.syxh,sum(c.zje) FXYLQDBF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                    
 where d.id='18' group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)  
 ---add lr20170217 ��Ѫ��������Ʒ��;                                             
 update a set FXYLYXYZF=b.FXYLYXYZF from #ba101 a,                                                                                    
 (select c.syxh,sum(c.zje) FXYLYXYZF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                      
 where d.id='38'  group by c.syxh) b                                 
 where a.FZYID=convert(varchar(20),b.syxh)                                                          
 ---add lr20170217 ϸ����������Ʒ��;                  
 update a set FXYLXBYZF=b.FXYLXBYZF from #ba101 a,                                  
 (select c.syxh,sum(c.zje) FXYLXBYZF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                       
 where d.id='20'  group by c.syxh) b             
 where a.FZYID=convert(varchar(20),b.syxh)                                                         
 ---add lr20170217 �����һ����ҽ�ò��Ϸ�;                           
 update a set FHCLCJF=b.FHCLCJF from #ba101 a,                                                                            
 (select c.syxh,sum(c.zje) FHCLCJF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                     
 where d.id='21'  group by c.syxh) b                                         
 where a.FZYID=convert(varchar(20),b.syxh)                                                      
 ---add lr20170217 ������һ����ҽ�ò���;                                                          
 update a set FHCLZLF=b.FHCLZLF from #ba101 a,                                                                                     
 (select c.syxh,sum(c.zje) FHCLZLF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                 
 where d.id='22'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                          
 ---add lr20170217 ������һ����ҽ�ò��Ϸ�;                                           
 update a set FHCLSSF=b.FHCLSSF from #ba101 a,                     
 (select c.syxh,sum(c.zje) FHCLSSF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                   
 where d.id='23' group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                       
 ---add lr20170217 ��ҽ��֤���η�;                                                          
 update a set  FZHFWLYLF01=b.FZHFWLYLF01 from #ba101 a,                                                                                      
 (select c.syxh,sum(c.zje) FZHFWLYLF01 from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                     
 where d.id='02'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                      
 ---add lr20170217 ��ҽ��֤���λ����;                                                          
 update a set  FZHFWLYLF02=b.FZHFWLYLF02 from #ba101 a,                                                                                    
 (select c.syxh,sum(c.zje) FZHFWLYLF02 from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                       
 where d.id='03'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)  
 ---add lr20170217 ��ҽ��Ϸ�;                    
 update a set FZYLZDF=b.FZYLZDF from #ba101 a,                                                                                       
 (select c.syxh,sum(c.zje) FZYLZDF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                       
 where d.id='18'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                          
 ---add lr20170217 ��ҽ���Ʒ�;   ��δ��Ӧ��                                                      
 update a set FZYLZF=b.FZYLZLF from #ba101 a,                                                                                       
 (select c.syxh,sum(c.zje) FZYLZLF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                      
 where d.id='19'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                  
 ---add lr20170217 ��ҽ���η�;          
 update a set FZYLZLF01=b.FZYLZLF01 from #ba101 a,                                         
 (select c.syxh,sum(c.zje) FZYLZLF01 from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                   
 where d.id='20'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                      
 ---add lr20170217 ��ҽ���˷�;                                                          
 update a set FZYLZLF02=b.FZYLZLF02 from #ba101 a,                                                                          
 (select c.syxh,sum(c.zje) FZYLZLF02 from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                     
 where d.id='22'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                
 ---add lr20170217 ��ҽ��ķ�;                                                          
 update a set FZYLZLF03=b.FZYLZLF03 from #ba101 a,                                                                                     
 (select c.syxh,sum(c.zje) FZYLZLF03 from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                       
 where d.id='23'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                         
 ---add lr20170217 ��ҽ�������Ʒ�;                                                          
 update a set FZYLZLF04=b.FZYLZLF04 from #ba101 a,                                                                        
 (select c.syxh,sum(c.zje) FZYLZLF04 from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                       
 where d.id='24'  group by c.syxh) b                             
 where a.FZYID=convert(varchar(20),b.syxh)                                                       
 ---add lr20170217 ��ҽ�س����Ʒ�;                                                          
 update a set FZYLZLF05=b.FZYLZLF05 from #ba101 a,                                                                                       
 (select c.syxh,sum(c.zje) FZYLZLF05 from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                   
 where d.id='25'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                               
 ---add lr20170217 ��ҽ�������Ʒ�;                                                          
 update a set FZYLZLF06=b.FZYLZLF06 from #ba101 a,                                                                                        
 (select c.syxh,sum(c.zje) FZYLZLF06 from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                      
 where d.id='26'  group by c.syxh) b                                  
 where a.FZYID=convert(varchar(20),b.syxh)                                                     
 ---add lr20170217 ��ҽ������;                                                            
 update a set FZYLQTF=b.FZYLQTF from #ba101 a,                                                                                      
 (select c.syxh,sum(c.zje) FZYLQTF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                       
 where d.id='27'  group by c.syxh) b                                                        
 where a.FZYID=convert(varchar(20),b.syxh)                                                    
 ---add lr20170217 ��ҽ�������ӹ���;                                                          
 update a set FZYLQTF01=b.FZYLQTF01 from #ba101 a,                                                                           
 (select c.syxh,sum(c.zje) FZYLQTF01 from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                          
 where d.id='28'  group by c.syxh) b                 
 where a.FZYID=convert(varchar(20),b.syxh)                                         
 ---add lr20170217 ��ҽ��֤ʩ�ŷ�;                            
 update a set FZYLQTF02=b.FZYLQTF02 from #ba101 a,                                                                            
 (select c.syxh,sum(c.zje) FZYLQTF02 from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on c.ypdm=d.xmdm and d.fylb='0'                                                       
 where d.id='29'  group by c.syxh) b                                                
 where a.FZYID=convert(varchar(20),b.syxh)                                                      
 ---add lr20170217 ��ҽ�Ƽ���;                                                          
 update a set FZCLJGZJF=b.FZCLJGZJF from #ba101 a,                                                                          
 (select c.syxh,sum(c.zje) FZCLJGZJF from #BRFYMXK1 c left join [172.20.0.41\ZY].[THIS_ZY].[dbo].BA_FYLBDYK d on  convert(varchar,c.idm)=d.xmdm and d.fylb='1' and c.idm<>'0'                                                    
 where d.id='33'  group by c.syxh) b           
 where a.FZYID=convert(varchar(20),b.syxh)         
END        
 
update #ba101 set FXYF=FXYF+FXYLGJF
update #ba101 set FZLLFSSF=FZLLFMZF+FZLLFSSF+FZLLFSSZLF
update #ba101 set FZLLFFSSF=FZLLFFSSF+FZLLFWLZWLF 
 update #ba101 set FZFJE=0 where FZFJE<0
 update #ba101 set  FQTF=FSUM1-(FZHFWLYLF+FZHFWLCZF+FZHFWLHLF+FZHFWLQTF+FZDLBLF+FZDLSSSF+FZDLYXF+FZDLLCF+FZLLFFSSF+FZLLFSSF+FKFLKFF+FZYLZF+FXYLXF+
FXYLBQBF+FXYLQDBF+FXYLYXYZF+FXYLXBYZF+FHCLCJF+FHCLZLF+FHCLSSF+FXYF+FZCYF+FZCHYF) where
 FSUM1-(FZHFWLYLF+FZHFWLCZF+FZHFWLHLF+FZHFWLQTF+FZDLBLF+FZDLSSSF+FZDLYXF+FZDLLCF+FZLLFFSSF+FZLLFSSF+FKFLKFF+FZYLZF+FXYLXF+
FXYLBQBF+FXYLQDBF+FXYLYXYZF+FXYLXBYZF+FHCLCJF+FHCLZLF+FHCLSSF+FXYF+FZCYF+FZCHYF)>0          
      
update A set fyydm=B.fyydm from #ba2 A,#ba1 B where A.FSYXH=B.FSYXH
update A set fyydm=B.fyydm from #ba3 A,#ba1 B where A.FSYXH=B.FSYXH
update A set fyydm=B.fyydm from #ba4 A,#ba1 B where A.FSYXH=B.FSYXH
update A set fyydm=B.fyydm from #ba5 A,#ba1 B where A.FSYXH=B.FSYXH
update A set fyydm=B.fyydm from #ba8 A,#ba1 B where A.FSYXH=B.FSYXH
update A set fyydm=B.fyydm from #His_ba_ahfy A,#ba1 B where A.FSYXH=B.FSYXH
update A set fyydm=B.fyydm from #His_BaFy A,#ba1 B where A.FSYXH=B.FSYXH  
if @type = 0        
 begin        
  update b set b.FZYID = a.EMRSYXH from #PAT a,#ba1 b  where a.HISSYXH = b.FZYID        
  DROP TABLE #PAT        
 end        
        
if @type = 1        
 begin        
  update b set b.FZYID = a.EMRSYXH from #PAT2 a,#ba1 b  where a.HISSYXH = b.FZYID        
  DROP TABLE #PAT2        
 end        
         
COMMIT TRAN        
SET XACT_ABORT OFF        
        
--���ؽ����        
IF(@type = 0)        
BEGIN        
SELECT 'his_ba1,his_ba2,his_ba3,his_ba4,his_ba5,his_ba8,his_ba_ahfy,his_bafy' tables        -- 
select * from #ba1    --WHERE FPRN='201906919'     
select * from #ba2       
select * from #ba3       
select * from #ba4      
select * from #ba5      
select * from #ba8  
select * from #His_ba_ahfy   
select * from #His_BaFy --WHERE FPRN='201906919'
--select * from #his_ba13 
END        

ELSE        
BEGIN        
 SELECT 'his_ba1' tables        
select * from #ba101 -- where FPRN='20190012530'      
        
END          
SET nocount off         
        

