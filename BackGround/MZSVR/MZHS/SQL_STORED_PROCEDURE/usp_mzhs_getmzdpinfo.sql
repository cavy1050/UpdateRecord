alter proc usp_mzhs_getmzdpinfo
/********************************************************
[功能说明]
         获取诊区汇总信息
[参数说明]      
[返回值]       
[调用的sp]  
exec usp_mzhs_getmzdpinfo
********************************************************/
as              
set nocount on    

declare @Nowtime varchar(8)          
select @Nowtime= convert(char(8),getdate(),112)    

--创建临时表
create table #TemBase   
	 (      
		 KSDM u5_ksdm,    
		 KSMC u5_mc32,    
		 ZJDM u5_ksdm,    
		 ZJMC u5_mc32,    
		 YSDM u5_czyh,    
		 YSMC u5_mc32,    
		 JZZPAT u5_mc32,    --就诊中患者
		 YJZCOT u5_mc32,    --已就诊数量
		 WAITCOT u5_mc32,   --等候数量
	 )    
	 
	 --以医生登陆信息为基础获取数据源
	INSERT INTO #TemBase
	SELECT A.KSDM,A.KSMC,A.ZJDM,A.ZJMC,A.ZJYSDM AS YSDM,A.ZJYSMC+' '+SUBSTRING(A.DLSJ,9,5) AS YSMC
	,'' AS JZZPAT,'' AS YJZCOT,'' AS WAITCOT
	from OUTP_FZ_YSDLXX  A(NOLOCK) 
	left join OUTP_FZ_ZJK B(NOLOCK) ON A.ZJDM = B.ID
	WHERE A.DLZT=1 AND DLSJ>@Nowtime  --AND B.ZQDM = @zqdm

     --创建游标，循环获取不同诊间，科室，医生的相关数据
	 declare cur_baseinfo cursor for   
	 select KSDM,ZJDM,YSDM   
	 from #TemBase   
	 
	 declare @ksdm  u5_ksdm,@zjdm u5_ksdm,@ysdm u5_czyh
	 declare @jzzpat  u5_mc32,@yjzcot u5_mc32,@waitcot u5_mc32
	 
	 open cur_baseinfo  
	 fetch cur_baseinfo into @ksdm,@zjdm,@ysdm
	 while @@fetch_status = 0   
	 begin
	     select @jzzpat = '' ,@yjzcot = 0,@waitcot = 0
	     
	     --获取诊间就诊中患者信息 暂取BRZT IN (2,6)
	     --BRZT 0：候诊 1：护士站已叫号 2：就诊中 3：检查 4：错过就诊 5：结束就诊 6：医生已叫号 7：弃号
		 --update by winning-dingsong-chongqing on 20200812 
		 --HZXM  >  case when len(HZXM)<3 then stuff(HZXM,2,0,'*') else stuff(HZXM,2,1,'*') end
	     select top 1 @jzzpat = (case when len(HZXM)<3 then stuff(HZXM,2,0,'*') else stuff(HZXM,2,1,'*') end)
	     +'('+case when ISNULL(MEMO,'')='' then '' else MEMO+'-' end
	     +convert(varchar(12),GHHX)+')' from OUTP_FZ_ZJJHJL (NOLOCK) 
	     where JLRQ>@Nowtime
	           and BRZT in (2,6) 
	           and ZJDM=@zjdm 
	           and KSDM=@ksdm 
	           and YSDM=@ysdm
	     order by ZJDLXH desc
	     

	     --计算已就诊数量 暂取brzt=5
	     select @yjzcot = COUNT(1) from OUTP_FZ_ZJJHJL (NOLOCK) 
	     where JLRQ>@Nowtime 
	     and BRZT in (5) 
	     and ZJDM=@zjdm 
	     and KSDM=@ksdm 
	     and YSDM=@ysdm
	     
	     --计算候诊数量 暂取BRZT IN (0,1)
	     select @waitcot = COUNT(1) from OUTP_FZ_ZJJHJL (NOLOCK) 
	     where JLRQ>@Nowtime 
	     and BRZT in (0,1) 
	     and ZJDM=@zjdm 
	     and KSDM=@ksdm 
	     and YSDM=@ysdm
	     
	     --更新临时表相关信息
		 update  #TemBase 
		 set JZZPAT = @jzzpat  
		 ,YJZCOT=@yjzcot
		 ,WAITCOT = @waitcot   
		 where ZJDM=@zjdm and KSDM=@ksdm and YSDM=@ysdm
				if @@error <> 0  
				begin  
					rollback tran  
					close cur_baseinfo  
					deallocate cur_baseinfo  
				end     
		 fetch cur_baseinfo into @ksdm,@zjdm,@ysdm
	 end
	 close cur_baseinfo  
	 deallocate cur_baseinfo  
	 
	select * from #TemBase

	DROP TABLE #TemBase   

