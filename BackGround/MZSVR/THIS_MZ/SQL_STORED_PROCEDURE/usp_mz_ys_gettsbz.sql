ALTER procedure usp_mz_ys_gettsbz
        @ghxh          ut_xh12=0,                                                 
        @patid         ut_xh12=0,          
        @ybdm          ut_ybdm='',          
        @pyfield       ut_memo='',            
        @searchstr     ut_memo='',          
        @cftszddm      ut_zddm='',          
        @medtype       ut_zddm=''---医疗类别          
/**********            
[版本号]4.5.0.0.0            
[创建时间]2010.07.15          
[作者] qianqing          
[版权] Copyright ? 2004-2008上海金仕达-卫宁软件股份有限公司 usp_mz_ys_gettsbz @cftszddm='01'          
[描述] 门诊医生站——录入病种时改为存储模式          
[功能说明]            
        返回当前病人可以录入的病种          
        实施根据现场情况修改,但是必须按顺序传出id "代码", name "诊断", py "拼音", wb "五笔"          
[参数说明]            
          
[返回值]            
            
[结果集、排序]            
  成功：结果集            
[调用的sp]            
            
select * from YY_SYB_BRJBBMK where shbzh='512222194812124404'          
          
select sybkh,* from SF_BRJSK where patid=1168997          
          
          
[调用实例]            
          
[修改记录]          
**********/          
as          
set nocount on          
          
        
begin          
 declare @shbzh varchar(30)          
           
 select top 1 @shbzh = b.cardno from SF_BRJSK a  
 left join SF_BRXXK b on a.patid=b.patid and a.blh=b.blh  
 where sjh in (select jssjh from GH_GHZDK where xh = @ghxh and patid = @patid)        
   
 if @cftszddm=''--录入的时候用           
 begin          
  select A.bzbm "代码", A.bzmc "诊断", '' "拼音", '' "五笔"           
      from YY_CQYB_TSBINFO A   
      where A.sbkh = @shbzh          

 end          
 else          
 begin--重新load的时候用          
     exec('select top 1 bzmc from YY_CQYB_TSBINFO where bzbm="'+@cftszddm+'"' )           
 end               
end       
    
    
----调用并发症       
--exec usp_mz_ys_getbfz  @ghxh,@patid,@ybdm,@pyfield,@searchstr,@cftszddm,@medtype 


