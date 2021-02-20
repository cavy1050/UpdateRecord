Text
CREATE proc usp_yy_createblh  
 @tablename varchar(32),  
 @fieldblh varchar(16),  
 @errmsg  varchar(50) output,  
 @type  smallint=0,  
 @xt_flag smallint=0,  
 @ybdm  ut_ybdm='',  
 @yydm  ut_dm2='',  
 @patid  ut_xh12=0,  
 @cardno     ut_cardno='',  
 @cardtype   ut_bz=0,  
 @sfzh       ut_sfzh='',  
 @czyh       ut_czyh='',  
 @dlksdm     ut_ksdm='',  
 @isquery    ut_bz=0  
as --��388738 2018-07-09 09:58:59 4.0��׼��  
/**********  
[�汾��]4.0.0.0.0  
[����ʱ��]2004.11.17  
[����]����  
[��Ȩ] Copyright ? 2004-2008�Ϻ����˴�-��������ɷ����޹�˾  
[����]�Զ������վݺ�  
[����˵��]  
 �Զ����ɸ��ֵ��ݵ��վݺ�  
[����˵��]  
 @tablename varchar(32), Ҫ���ɲ����ŵı���  
 @fieldblh varchar(16), �����ŵ��ֶ���  
 @errmsg varchar(50) output  
 @type smallint = 0  0=�������ɣ�1=�������ɣ�2=��������  
 @xt_flag smallint = 0 (0:��Ժ�Ǽ� 1�����۵Ǽ� 2:�Ҵ��Ǽ� 3���ռ������Ǽ�)   
[����ֵ]  
[�����������]  
[���õ�usp]  
 declare @errmsg varchar(50)  
 exec usp_yy_createblh 'ZY_BRXXK','blh',@errmsg output,0,2  
 select @errmsg   
  
T2009021555   
 select max(blh) from SF_BRXXK where blh like '2007%'  
[����ʵ��]  
[�޸ļ�¼]  
 yxp 2007-09-11 �ϲ������ٶ��Ż����޸ģ���չ����5034������סԺ�����ɷ�ʽ2:����ȡ���ֵ(�ٶȿ�)  
 zyh 2008-01-07 ���ۺŵ�������  
 cj 2009-06-25  �Ҵ������ŵ�������  
    chenwei 2014-01-06 �ռ������Ǽǵ�������     
**********/  
set nocount on  
if exists(select 1 from YY_CONFIG where id='1583' and config='��') and @tablename ='SF_BRXXK'  
begin  
 declare @data ut_rq16,@djxh_zzl bigint  
 select @data = convert(varchar(8),getdate(),112) + convert(char(8),getdate(),8)  
   
    if @isquery = 0   
    begin  
        select @djxh_zzl = isnull(max(xh),0) + 1 from GH_BLH   
        where substring(data,1,8) = convert(varchar(8),getdate(),112)  
    end  
    else  
    begin   
        insert into GH_BLH values(@data)  
        if @@error <> 0 or @@rowcount <> 1   
        begin  
            select @errmsg = 'F���ɵ��ݺų���'  
            return  
        end  
  
  select @djxh_zzl = SCOPE_IDENTITY()  
    end  
      
    select @errmsg='T'+rtrim(substring(@data,1,8)) + stuff('000000',7-datalength(rtrim(convert(char(10),@djxh_zzl))),datalength(rtrim(convert(char(10),@djxh_zzl))),convert(char(10),@djxh_zzl))  
    return  
end  
  
if exists(select 1 from YY_CONFIG where id='0199' and config='��')  
begin  
 --�Զ��岡�������ɷ�ʽ  
 exec usp_yy_createblh_zdy @tablename,@fieldblh,@errmsg output,@type,@xt_flag,@ybdm,@yydm,@patid,@cardno,@cardtype,@sfzh  
 return  
end  
  
if @tablename='ZY_BRXXK' and exists(select 1 from ZY_BLHHSK where jlzt=0 and (yydm=@yydm or isnull(yydm,'')=''))  
begin  
 select @errmsg='T'+min(blh) from ZY_BLHHSK where jlzt=0 and (yydm=@yydm or isnull(yydm,'')='')  
 return  
end  
  
declare @date varchar(8),  
  @djscfs varchar(2),--yxp 2007-09-11 �ϲ������ٶ��Ż����޸ģ���չ����5034������סԺ�����ɷ�ʽ2:ֱ�Ӱ���ȡ���ֵ  
  @djxh bigint,  
  @djxh1 bigint,  
  @djxh_jc varchar(30),  
  @scfs int,  
  @cpatid varchar(12)   
  
select @date=convert(char(8),getdate(),112)  
if @type=1  
 select @date=substring(@date,1,6)  
else  
 select @date=substring(@date,1,4)  
  
create table #blh  
(  
 djxh bigint not null  
)  
  
select @djscfs=config from YY_CONFIG (nolock) where id='5034'  
  
if @djscfs='1' and @tablename='ZY_BRXXK'   
begin  
 select @scfs=1  
 select @djxh1=convert(bigint,config) from YY_CONFIG (nolock) where id='5197'  
 select @djxh1=isnull(@djxh1,0)  
    select @djxh_jc=convert(varchar(30),config) from YY_CONFIG (nolock) where id='5261'  
    select @djxh_jc=substring(convert(char(8),getdate(),112),3,2)+@djxh_jc  
 if @xt_flag=0  
  select @djxh=convert(bigint,config) from YY_CONFIG (nolock) where id='5035'  
 else if @xt_flag=1  
  select @djxh=@djxh1  
    else if @xt_flag=2           
     select @djxh=@djxh_jc  
          else if @xt_flag=3    
                 select  @djxh=isnull(convert(bigint,config),0) from YY_CONFIG  WHERE id='5088'   
  
 --���δ�����ۺų�ֵ�������ۺŲ���������  
 if @djxh1>0 and @xt_flag=1  
 begin  
  if @xt_flag=0  
   INSERT INTO #blh SELECT ISNULL(CONVERT(BIGINT,MAX(RIGHT(REPLICATE("0", 10)+RTRIM(dqblh),10))),0)  
   from ZY_BLHXXK WITH (TABLOCKX) where ISNUMERIC(dqblh)>0 AND xtflag=0 and (yydm=@yydm or isnull(yydm,'')='')  
  if @xt_flag=1  
   INSERT INTO #blh SELECT ISNULL(CONVERT(BIGINT,MAX(RIGHT(REPLICATE("0", 10)+RTRIM(dqblh),10))),0)  
   from ZY_BLHXXK WITH (TABLOCKX) where ISNUMERIC(dqblh)>0 AND xtflag=1 and (yydm=@yydm or isnull(yydm,'')='')  
 end  
 IF @@ERROR<>0  
 BEGIN  
  SELECT @errmsg="F���ɵ��ݺų���"  
  RETURN  
 END  
    --���δ���üҴ������ų�ֵ����Ҵ������Ų���������  
    if @djxh_jc>0 and @xt_flag=2   
    begin  
         if @xt_flag=0  
            INSERT INTO #blh SELECT ISNULL(CONVERT(BIGINT,MAX(RIGHT(REPLICATE("0", 10)+RTRIM(dqblh),10))),0)  
   from ZY_BLHXXK WITH (TABLOCKX) where ISNUMERIC(dqblh)>0 AND xtflag=0 and (yydm=@yydm or isnull(yydm,'')='')  
         if @xt_flag=2  
            INSERT INTO #blh SELECT ISNULL(CONVERT(BIGINT,MAX(RIGHT(REPLICATE("0", 10)+RTRIM(dqblh),10))),0)  
   from ZY_BLHXXK WITH (TABLOCKX) where ISNUMERIC(dqblh)>0 AND xtflag=2 and (yydm=@yydm or isnull(yydm,'')='')  
        
    end  
 IF @@ERROR<>0  
 BEGIN  
  SELECT @errmsg="F���ɵ��ݺų���"  
  RETURN  
 END  
   --���δ���ռ������ų�ֵ�����ռ������Ų���������   
 if @djxh1>0 and @xt_flag=3     
    begin      
       if @xt_flag=0      
          INSERT INTO #blh SELECT ISNULL(CONVERT(BIGINT,MAX(RIGHT(REPLICATE("0", 10)+RTRIM(dqblh),10))),0)      
          from ZY_BLHXXK WITH (TABLOCKX) where ISNUMERIC(dqblh)>0 AND xtflag=0 and (yydm=@yydm or isnull(yydm,'')='')      
       if @xt_flag=3      
          INSERT INTO #blh SELECT ISNULL(CONVERT(BIGINT,MAX(RIGHT(REPLICATE("0", 10)+RTRIM(dqblh),10))),0)      
          from ZY_BLHXXK WITH (TABLOCKX) where ISNUMERIC(dqblh)>0 AND xtflag=3 and (yydm=@yydm or isnull(yydm,'')='')      
    end      
    IF @@ERROR<>0      
  BEGIN      
   SELECT @errmsg="F���ɵ��ݺų���"      
   RETURN      
  END      
     
     
 if @xt_flag=0  
  INSERT INTO #blh SELECT ISNULL(CONVERT(BIGINT,MAX(RIGHT(REPLICATE("0", 10)+RTRIM(dqblh),10))),0)  
  FROM ZY_BLHXXK WITH (TABLOCKX) WHERE ISNUMERIC(dqblh)>0 AND xtflag=0 and (yydm=@yydm or isnull(yydm,'')='')  
 IF @@ERROR<>0  
 BEGIN  
  SELECT @errmsg="F���ɵ��ݺų���"  
  RETURN  
 END  
end  
else if @djscfs='2'--yxp 2007-09-11 �ϲ������ٶ��Ż����޸ģ���չ����5034������סԺ�����ɷ�ʽ2:ֱ�Ӱ���ȡ���ֵ  
begin  
 select @djxh=0, @scfs=0  
 if @tablename='SF_BRXXK'  
 begin   
  select @cpatid=convert(varchar(12),max(patid)-30) from SF_BRXXK  --�����Ӧ�������patid-30 ��patid֮��    
  if @cpatid is null  
   select @cpatid='0'    
  exec('declare @maxblh ut_blh   
   select @maxblh=max('+@fieldblh+')  
   from '+ @tablename+' where patid>= '+@cpatid+' and '+@fieldblh+' like "'+@date+'%" and isnumeric('+@fieldblh+')>0    
   insert into #blh select isnull(convert(bigint,convert(bigint,right(rtrim(@maxblh),len(ltrim(rtrim(@maxblh)))-4))),0)'  
   )  
  if @@error<>0  
  begin  
   select @errmsg="F���ɵ��ݺų���"  
   return  
  end  
 end  
 else  
 begin  
  INSERT INTO #blh  
  SELECT ISNULL(CONVERT(BIGINT,RIGHT(RTRIM(dqblh),LEN(LTRIM(RTRIM(dqblh)))-4)),0)  
  FROM ZY_BLHXXK WITH (TABLOCKX) WHERE dqblh LIKE @date+"%" AND ISNUMERIC(dqblh)>0 AND xtflag=0 and (yydm=@yydm or isnull(yydm,'')='')  
  IF @@ERROR<>0  
  BEGIN  
   SELECT @errmsg="F���ɵ��ݺų���"  
   RETURN  
  END  
 end  
end  
else   
begin  
 select @djxh=0, @scfs=0  
 if  @tablename='SF_BRXXK'-- agg 20080926 ����ר���Ż�    
 begin    
  select @cpatid=convert(varchar(12),max(patid)-30) from SF_BRXXK  --�����Ӧ�������patid-30 ��patid֮��    
  if @cpatid is null  
   select @cpatid='0'      
  exec('insert into #blh select isnull(convert(bigint,max(convert(bigint,right(rtrim('+@fieldblh+'),len(ltrim(rtrim('+@fieldblh+')))-4)))),0)      
  from '+ @tablename+' where  patid>= '+@cpatid+' and '+@fieldblh+' like "'+@date+'%" and isnumeric('+@fieldblh+')>0')--and jlzt>0')      
  if @@error<>0      
  begin      
   select @errmsg="F���ɵ��ݺų���"      
   return      
end      
 end    
 else   
 begin  
  INSERT INTO #blh  
  SELECT ISNULL(CONVERT(BIGINT,RIGHT(RTRIM(dqblh),LEN(LTRIM(RTRIM(dqblh)))-4)),0)  
  FROM ZY_BLHXXK WITH (TABLOCKX) WHERE dqblh LIKE @date+"%" AND ISNUMERIC(dqblh)>0 AND xtflag=0 and (yydm=@yydm or isnull(yydm,'')='')  
  IF @@ERROR<>0  
  BEGIN  
   SELECT @errmsg="F���ɵ��ݺų���"  
   RETURN  
  END  
 end  
end  
  
if exists(select 1 from #blh where djxh>=@djxh)  
 select @djxh=djxh+1 from #blh  
else  
 select @djxh=@djxh+1  
  
if @djscfs='1' and @tablename='ZY_BRXXK'   
begin  
 if exists(select 1 from ZY_BRXXK where blh=convert(varchar(12),@djxh))  
  select @errmsg="F���ɵ��ݺų���"  
end  
  
 -----------------------------------add by z_wm 20160923  blhΪ0��ͷ����,����10λǰ�油0--------------------  
declare  @l_en int,@length int  
select @length=(select config  from YY_CONFIG where id='5050')  
if @scfs=1 and @tablename='ZY_BRXXK'  
  
begin  
 if @xt_flag=2  
 begin  
    
  if len(@djxh)<=@length and @length<>0    
  begin  
    select @l_en =@length-len(@djxh)  
    select @errmsg="T"+RIGHT(REPLICATE('0',@l_en),@l_en)+substring(convert(varchar(12),@djxh),0,10)    
     
  end  
  else  if  @length=0  
  begin  
    select @errmsg="T"+substring(convert(char(8),getdate(),112),3,2)+substring(convert(varchar(12),@djxh),2,5)    
  end  
  else  
  begin  
   select @errmsg="F����5050���ó���Ϊ"+cast(@length as varchar(10))+",����������סԺ�ų�ʼֵ."  
   return  
  end  
    
 end  
    else --if @xt_flag<>2  
    begin  
     
  if len(@djxh)<=@length and @length<>0     
  begin  
     
   select @l_en =@length-len(@djxh)  
   select @errmsg="T"+RIGHT(REPLICATE('0',@l_en),@l_en)+convert(varchar(12),@djxh)  
  end  
  else  if  @length=0  
  begin  
     
    select @errmsg="T"+convert(varchar(12),@djxh)  
  end  
  else  
  begin  
   select @errmsg="F����5050���ó���Ϊ"+cast(@length as varchar(10))+",����������סԺ�ų�ʼֵ."  
   return  
  end  
 end  
end  
else  
begin  
 if @djxh>9999999999     
 begin      
   select @errmsg="F���ɵ��ݺų���������󳤶����ƣ�"      
   RETURN      
 end    
     
 select @errmsg="T"+rtrim(@date)+stuff('0000000',8-datalength(rtrim(convert(char(10),@djxh))),datalength(rtrim(convert(char(10),@djxh))),convert(char(10),@djxh))  

/*
--add by yangdi 2021.2.7 ���������ź�ÿ�����˶���ʾ������ϸ������������
--add by winning-dingsong-chongqing on 20210204 begin
/*��֤�������Ƿ��ظ�*/
declare @blh ut_blh
select @blh=substring(@errmsg,2,len(@errmsg)-1)
if exists(select 1 from YY_CONFIG where id='1133' and config='��')
begin
	if(@tablename='SF_BRXXK')
	begin
		if exists(select 1 from SF_BRXXK(nolock) where upper(blh)=upper(@blh))
		begin
			select @errmsg='F������['+@blh+']���ظ�ʹ�ã������µǼǣ�'
			return
		end
	end
	else if(@tablename='ZY_BRXXK')
	begin
		if exists(select 1 from ZY_BRXXK(nolock) where upper(blh)=upper(@blh))
		begin
			select @errmsg='F������['+@blh+']���ظ�ʹ�ã������µǼǣ�'
			return
		end
	end
end
--add by winning-dingsong-chongqing on 20210204 end

*/

end  
  
if (SELECT config FROM YY_CONFIG WHERE id='5252')='��' and @tablename='ZY_BRXXK'   
begin  
 IF (SELECT RTRIM(config) FROM YY_CONFIG WHERE id='5197')<>''  
  UPDATE ZY_BLHXXK SET dqblh=substring(@errmsg,2,len(@errmsg)-1) WHERE xtflag=@xt_flag and (yydm=@yydm or isnull(yydm,'')='')  
 ELSE  
  UPDATE ZY_BLHXXK SET dqblh=substring(@errmsg,2,len(@errmsg)-1) WHERE xtflag=0 and (yydm=@yydm or isnull(yydm,'')='')  
end  
  
  
return  



