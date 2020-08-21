alter proc usp_mzhs_getmzdpinfo
/********************************************************
[����˵��]
         ��ȡ����������Ϣ
[����˵��]      
[����ֵ]       
[���õ�sp]  
exec usp_mzhs_getmzdpinfo
********************************************************/
as              
set nocount on    

declare @Nowtime varchar(8)          
select @Nowtime= convert(char(8),getdate(),112)    

--������ʱ��
create table #TemBase   
	 (      
		 KSDM u5_ksdm,    
		 KSMC u5_mc32,    
		 ZJDM u5_ksdm,    
		 ZJMC u5_mc32,    
		 YSDM u5_czyh,    
		 YSMC u5_mc32,    
		 JZZPAT u5_mc32,    --�����л���
		 YJZCOT u5_mc32,    --�Ѿ�������
		 WAITCOT u5_mc32,   --�Ⱥ�����
	 )    
	 
	 --��ҽ����½��ϢΪ������ȡ����Դ
	INSERT INTO #TemBase
	SELECT A.KSDM,A.KSMC,A.ZJDM,A.ZJMC,A.ZJYSDM AS YSDM,A.ZJYSMC+' '+SUBSTRING(A.DLSJ,9,5) AS YSMC
	,'' AS JZZPAT,'' AS YJZCOT,'' AS WAITCOT
	from OUTP_FZ_YSDLXX  A(NOLOCK) 
	left join OUTP_FZ_ZJK B(NOLOCK) ON A.ZJDM = B.ID
	WHERE A.DLZT=1 AND DLSJ>@Nowtime  --AND B.ZQDM = @zqdm

     --�����α꣬ѭ����ȡ��ͬ��䣬���ң�ҽ�����������
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
	     
	     --��ȡ�������л�����Ϣ ��ȡBRZT IN (2,6)
	     --BRZT 0������ 1����ʿվ�ѽк� 2�������� 3����� 4��������� 5���������� 6��ҽ���ѽк� 7������
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
	     

	     --�����Ѿ������� ��ȡbrzt=5
	     select @yjzcot = COUNT(1) from OUTP_FZ_ZJJHJL (NOLOCK) 
	     where JLRQ>@Nowtime 
	     and BRZT in (5) 
	     and ZJDM=@zjdm 
	     and KSDM=@ksdm 
	     and YSDM=@ysdm
	     
	     --����������� ��ȡBRZT IN (0,1)
	     select @waitcot = COUNT(1) from OUTP_FZ_ZJJHJL (NOLOCK) 
	     where JLRQ>@Nowtime 
	     and BRZT in (0,1) 
	     and ZJDM=@zjdm 
	     and KSDM=@ksdm 
	     and YSDM=@ysdm
	     
	     --������ʱ�������Ϣ
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

