alter proc usp_mzhs_external_gethzghinfo
 @in_ipdz  u5_name,   ---诊区代码    
 @in_type  ut_dm4,    --1:候诊 2：回诊 3:过号  
 @in_count ut_dm4     --"":代表返回所有  数字代表返回几条数据
as          

/**********          
[版本号]5.5.0                        
[创建时间]2018-11-20                         
[作者]                         
[版权] Copyright ? 2017-2022上海金仕达-卫宁软件股份有限公司                        
[描述] 5.5门诊护士站                     
[功能说明]                        
[参数说明]                        
 @@in_ipdz u5_name                  
[返回值]                        
[结果集、排序]                        
 数据集                        
[调用的sp]                  

[调用实例]   
  exec usp_mzhs_external_gethzghinfo  '172.20.24.39' ,'1',''                           
[修改历史]          
**********/          
set nocount on   

	declare @zqdm ut_ksdm,  ---诊区代码  
	        @zjdm ut_ksdm,   ---诊间代码
			@sql varchar(max)

   create table  #temphzinfo                
  (                
      HZHZHX u5_xh12   null,   --候诊回诊过号病人号序                
      HZHZXM nvarchar(50)  null,   --候诊回诊过号病人姓名    
	  NOTICE nvarchar(50)  null,   --通知  
	  HZMEMO nvarchar(50)  null,    --HZMEMO                 
	  SJD   nvarchar(50)   null,    --时间段
	  YJDJ       u5_int    null,   --预检登记 0否  1  是
	  JZFJPX     u5_int    null,   --急诊分级排序
	  JZFJMC     u5_mc16   null  ,  --急诊分级名称  
	  ZJDLXH  u5_xh12   null,   --召回时排序病人号序    
  ) 



   declare @fzms int,--分诊
           @DZBZ u5_bz 

	SELECT top 1 @zqdm=ID,@fzms=FZMS,@DZBZ=DZBZ  FROM  OUTP_FZ_ZQK a(nolock) left join OUTP_FZ_ZQDYDPIP b(nolock) on a.ID=b.ZQDM  
	WHERE  a.SDIP=@in_ipdz or a.DPIPDZ=@in_ipdz or  b.DPIP=@in_ipdz 

	set @sql=' insert into #temphzinfo '

	if isnull(@in_count,0)>0
	begin
	  set @sql=@sql+ 'select top '+@in_count ;
	end else
	begin
	  set @sql=@sql+'select  ';
	end

   if (isnull(@zqdm,'')<>'')  
   begin  
  		set @sql=@sql+' distinct(ISNULL(a.GHHX,'''')),case when a.GHLB=1 and a.MEMO='''' 
		THEN ISNULL((case when len(a.HZXM)<3 then stuff(a.HZXM,2,0,"*") else stuff(a.HZXM,2,1,"*") end),'''')+''(急诊)''  
		when a.MEMO=''检查''then  ISNULL((case when len(a.HZXM)<3 then stuff(a.HZXM,2,0,"*") else stuff(a.HZXM,2,1,"*") end),'''')+ ''(复诊)'' 
		else ISNULL((case when len(a.HZXM)<3 then stuff(a.HZXM,2,0,"*") else stuff(a.HZXM,2,1,"*") end),'''') end,'''',a.MEMO,'''',
		b.YJDJ,ISNULL(b.JZFJPX,5),b.JZFJMC ,a.ZJDLXH'
		set @sql=@sql+'  from  OUTP_FZ_ZJJHJL a(NOLOCK) '
		set @sql=@sql+' left join  OUTP_FZ_ZQJHJL b(NOLOCK) on a.GHXH=b.GHXH '
		if @fzms=0 
		begin
		  set @sql=@sql+' left join  OUTP_FZ_YSDLXX c(nolock) on  a.ZJDM=c.ZJDM '
		end
		else if @fzms=1 
		begin
		  set @sql=@sql+' left join  OUTP_FZ_YSDLXX c(nolock) on   (a.ZJDM=''zj''+c.KSDM  or a.ZJDM=c.ZJDM)' 
		end  

		set @sql=@sql+' left join  OUTP_FZ_ZJDPDYK d(nolock) on  c.ZJDM=d.ZJDM ' 
		set @sql=@sql+' where  a.ZQDM='''+@zqdm+'''  and a.JLRQ>Convert(char(8),GETDATE(),112) '
		set @sql=@sql+' and c.DLZT=1 and c.DLSJ>CONVERT(char(8),getdate(),112)'
		set @sql=@sql+' and isnull(d.DPIP,'''')=(case when exists( select 1 from  OUTP_FZ_ZJDPDYK where DPIP= '''+@in_ipdz+''' ) then '''+@in_ipdz+'''  else '''' end )'  

	   if @in_type='1'
	   begin 
   		 set @sql=@sql+'  and a.BRZT IN(0,1)  ' 
	   end 
	   else if @in_type='2'
	   begin
   		 set @sql=@sql+'  and a.BRZT=3  '  
	   end
	   else if @in_type='3'
	   begin
  		 set @sql=@sql+'  and a.BRZT=4   '
	   end	
   end  
   else  
   begin  
       select @zqdm=ZQDM,@zjdm=ID FROM dbo.OUTP_FZ_ZJK WHERE DPDZ=@in_ipdz  
	   if @in_type='1'
	   begin  
			set @sql=@sql+' distinct(ISNULL(a.GHHX,'''')),case when a.GHLB=1 and a.MEMO='''' 
			THEN ISNULL((case when len(HZXM)<3 then stuff(HZXM,2,0,"*") else stuff(HZXM,2,1,"*") end),'''')+''(急诊)''  
			when a.MEMO=''检查''then  ISNULL((case when len(HZXM)<3 then stuff(HZXM,2,0,"*") else stuff(HZXM,2,1,"*") end),'''')+ ''(复诊)'' 
			else ISNULL((case when len(HZXM)<3 then stuff(HZXM,2,0,"*") else stuff(HZXM,2,1,"*") end),'''') end ,a.ZJDLXH,MEMO,'''','''','''','''' ,a.ZJDLXH   
			from OUTP_FZ_ZJJHJL a(NOLOCK) where ZQDM='''+@zqdm+''' and ZJDM='''+@zjdm+''' and BRZT IN(0,1) and JLRQ>Convert(char(8),GETDATE(),112) ' --desc 
	   end 
	   else if @in_type='2'
	   BEGIN
       			set @sql=@sql+' distinct(ISNULL(a.GHHX,'''')), ISNULL((case when len(HZXM)<3 then stuff(HZXM,2,0,"*") else stuff(HZXM,2,1,"*") end),'''') ,
				a.ZJDLXH,MEMO,'''','''','''',''''      
			from OUTP_FZ_ZJJHJL a(NOLOCK) where ZQDM='''+@zqdm+''' and ZJDM='''+@zjdm+''' and BRZT=3  and JLRQ>Convert(char(8),GETDATE(),112) '  --desc 
	   end
	   else if @in_type='3'
	   BEGIN
       		set @sql=@sql+' distinct(ISNULL(a.GHHX,'''')),ISNULL((case when len(HZXM)<3 then stuff(HZXM,2,0,"*") else stuff(HZXM,2,1,"*") end),''''),
			a.ZJDLXH,MEMO,'''','''','''',''''      
			from OUTP_FZ_ZJJHJL a(NOLOCK) where ZQDM='''+@zqdm+''' and ZJDM='''+@zjdm+''' and BRZT=4  and JLRQ>Convert(char(8),GETDATE(),112) ' --desc 
	   end
   end  

	if isnull(@in_count,0)>0
	begin
	 	set @sql=replace(@sql,'distinct','')
	end 

	exec(@sql)

   if (isnull(@zqdm,'')<>'')  
   begin  
	  --候诊回诊过号
	  select  * from  #temphzinfo order by JZFJPX,ZJDLXH
	  --HZHZHX
	  --ZJDLXH
   end else
   begin
	  --候诊回诊过号
	  select  * from  #temphzinfo order by NOTICE
   end













         

    












