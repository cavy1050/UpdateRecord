ALTER procedure usp_mz_ys_gettsbz
        @ghxh          ut_xh12=0,                                                 
        @patid         ut_xh12=0,          
        @ybdm          ut_ybdm='',          
        @pyfield       ut_memo='',            
        @searchstr     ut_memo='',          
        @cftszddm      ut_zddm='',          
        @medtype       ut_zddm=''---ҽ�����          
/**********            
[�汾��]4.5.0.0.0            
[����ʱ��]2010.07.15          
[����] qianqing          
[��Ȩ] Copyright ? 2004-2008�Ϻ����˴�-��������ɷ����޹�˾ usp_mz_ys_gettsbz @cftszddm='01'          
[����] ����ҽ��վ����¼�벡��ʱ��Ϊ�洢ģʽ          
[����˵��]            
        ���ص�ǰ���˿���¼��Ĳ���          
        ʵʩ�����ֳ�����޸�,���Ǳ��밴˳�򴫳�id "����", name "���", py "ƴ��", wb "���"          
[����˵��]            
          
[����ֵ]            
            
[�����������]            
  �ɹ��������            
[���õ�sp]            
            
select * from YY_SYB_BRJBBMK where shbzh='512222194812124404'          
          
select sybkh,* from SF_BRJSK where patid=1168997          
          
          
[����ʵ��]            
          
[�޸ļ�¼]          
**********/          
as          
set nocount on          
          
        
begin          
 declare @shbzh varchar(30)          
           
 select top 1 @shbzh = b.cardno from SF_BRJSK a  
 left join SF_BRXXK b on a.patid=b.patid and a.blh=b.blh  
 where sjh in (select jssjh from GH_GHZDK where xh = @ghxh and patid = @patid)        
   
 if @cftszddm=''--¼���ʱ����           
 begin          
  select A.bzbm "����", A.bzmc "���", '' "ƴ��", '' "���"           
      from YY_CQYB_TSBINFO A   
      where A.sbkh = @shbzh          

 end          
 else          
 begin--����load��ʱ����          
     exec('select top 1 bzmc from YY_CQYB_TSBINFO where bzbm="'+@cftszddm+'"' )           
 end               
end       
    
    
----���ò���֢       
--exec usp_mz_ys_getbfz  @ghxh,@patid,@ybdm,@pyfield,@searchstr,@cftszddm,@medtype 


