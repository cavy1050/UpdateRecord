alter proc usp_mzhs_external_gethzghinfo
 @in_ipdz  u5_name,   ---��������    
 @in_type  ut_dm4,    --1:���� 2������ 3:����  
 @in_count ut_dm4     --"":����������  ���ִ����ؼ�������
as          

/**********          
[�汾��]5.5.0                        
[����ʱ��]2018-11-20                         
[����]                         
[��Ȩ] Copyright ? 2017-2022�Ϻ����˴�-��������ɷ����޹�˾                        
[����] 5.5���ﻤʿվ                     
[����˵��]                        
[����˵��]                        
 @@in_ipdz u5_name                  
[����ֵ]                        
[�����������]                        
 ���ݼ�                        
[���õ�sp]                  

[����ʵ��]   
  exec usp_mzhs_external_gethzghinfo  '172.20.24.39' ,'1',''                           
[�޸���ʷ]          
**********/          
set nocount on   

	declare @zqdm ut_ksdm,  ---��������  
	        @zjdm ut_ksdm,   ---������
			@sql varchar(max)

   create table  #temphzinfo                
  (                
      HZHZHX u5_xh12   null,   --���������Ų��˺���                
      HZHZXM nvarchar(50)  null,   --���������Ų�������    
	  NOTICE nvarchar(50)  null,   --֪ͨ  
	  HZMEMO nvarchar(50)  null,    --HZMEMO                 
	  SJD   nvarchar(50)   null,    --ʱ���
	  YJDJ       u5_int    null,   --Ԥ��Ǽ� 0��  1  ��
	  JZFJPX     u5_int    null,   --����ּ�����
	  JZFJMC     u5_mc16   null  ,  --����ּ�����  
	  ZJDLXH  u5_xh12   null,   --�ٻ�ʱ�����˺���    
  ) 



   declare @fzms int,--����
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
		THEN ISNULL((case when len(a.HZXM)<3 then stuff(a.HZXM,2,0,"*") else stuff(a.HZXM,2,1,"*") end),'''')+''(����)''  
		when a.MEMO=''���''then  ISNULL((case when len(a.HZXM)<3 then stuff(a.HZXM,2,0,"*") else stuff(a.HZXM,2,1,"*") end),'''')+ ''(����)'' 
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
			THEN ISNULL((case when len(HZXM)<3 then stuff(HZXM,2,0,"*") else stuff(HZXM,2,1,"*") end),'''')+''(����)''  
			when a.MEMO=''���''then  ISNULL((case when len(HZXM)<3 then stuff(HZXM,2,0,"*") else stuff(HZXM,2,1,"*") end),'''')+ ''(����)'' 
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
	  --����������
	  select  * from  #temphzinfo order by JZFJPX,ZJDLXH
	  --HZHZHX
	  --ZJDLXH
   end else
   begin
	  --����������
	  select  * from  #temphzinfo order by NOTICE
   end













         

    












