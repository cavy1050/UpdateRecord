ALTER proc usp_bq_bjzzf  
 @syxh ut_syxh,  
 @czyh ut_czyh,  
 @mxxh ut_xh12,  
 @yexh ut_xh9=null,  
 @memo ut_memo=null,  
 @zfbz ut_bz = 0,  
 @tfsl ut_sl10 = 0  
    ,@zfmk int =0  
    ,@IsEjk  ut_bz=0  ---0:��ʹ��HRP���������1:ʹ��HRP���������    
as --��410758 2018-08-23 19:05:04 4.0��׼��  
/**********  
[�汾��]4.0.0.0.0  
[����ʱ��]2004.12.1  
[����]����  
[��Ȩ] Copyright ? 2004-2008�Ϻ����˴�-��������ɷ����޹�˾[����]����������  
[����˵��]  
 ����������  
[����˵��]  
 @syxh ut_syxh,  ��ҳ���  
 @czyh ut_czyh,  ����Ա��  
 @mxxh ut_xh12  ������ϸ�����  
 @yexh ut_xh9  Ӥ�����--yxp add  
 @memo ut_memo=null ��ע��Ϣ  
 @zfbz ut_bz  ���ϱ�־ 0�����ϣ�1���˷�  
 @tfsl ut_sl10  zfbz = 1 ��Ч  
 @zfmk  int     ����ģ�� 1��bjzzf 3��fyxmzf  -- select substring(config,@zfmk,1)  from YY_CONFIG where id='6652'  
[����ֵ]  
[�����������]  
[���õ�sp]  
[����ʵ��]  
[�޸ļ�¼]  
 yxp 2003-08-15 ���Ӳ���Ӥ����ţ�����Ӥ���ܲ����˵Ĺ���  
 yxp 2003-08-25 Ӥ�������������ڽ�����ϸ����Ӧ������yeje  
**********/  
set nocount on  
  
declare @errmsg varchar(50)  
 ,@ysdm ut_czyh  
 ,@cd_idm ut_xh9  
 ,@ypdm ut_xmdm  
 ,@yfdm ut_ksdm  
 ,@fylb ut_bz  
 ,@ypdw ut_unit  
 ,@dwxs ut_dwxs  
 ,@txbz ut_bz  
 ,@ypdj ut_money  
 ,@qqxh numeric(12,0)  
 ,@now ut_rq16  
 ,@ykxs ut_dwxs  
 ,@zfdj money  
 ,@ybshbz ut_bz  
 ,@zxrq ut_rq16  
 ,@config6249  NUMERIC(9,2)   
 ,@ypqbsl ut_sl10  
 ,@fymxxh varchar(50)    
 ,@returnbz ut_bz   
 ,@pcxh ut_xh12  
 ,@tm ut_mc64  
 ,@wzqqxh numeric(12,0)  
 ,@yzxh ut_xh12  
 ,@config6A91 varchar(2)  
 ,@jfsj ut_rq16  
 ,@config6C69 varchar(500)  
 ,@config6C40 varchar(2)  
 ,@barCodeHRP varchar(500)  
 ,@qqrq ut_rq16  
  
--������ϸ�⣬�ظ���¼���ܳ���һ���������������ǳ���������ɣ��½�ʯ�������߷��ֹ������⣬�ᵼ�·�����ϸ�ⱬ������п��Ƽ��  --add by yangdi 2020.02.14 ABJA0001�������������Ŀ��¼��������7000 ��ȡ�����ж�
if exists(select 1 from (select syxh,ypdm,count(1) jls from ZY_BRFYMXK(nolock) where syxh=@syxh group by  syxh,ypdm) t where jls>7000) ---dc��������������쳣�����޸���jls��С 
begin  
 select "F","������ϸ��¼���쳣��"  
 return   
end  
  
SELECT @returnbz=0   
  
select @config6249=0  
select @config6249 = CONVERT(NUMERIC(9,2),isnull(config,0)) from YY_CONFIG where id= '6249'   
select @config6C69=''  
select @config6C69 = isnull(rtrim(config),'') from YY_CONFIG where id= '6C69'   
select @config6C40 = ISNULL(rtrim(config),'') from YY_CONFIG where id= '6C40'  --����HRP�ӿ� 230846  
SELECT @zxrq=isnull(zxrq,''),@ypqbsl=ypsl FROM ZY_BRFYMXK where xh =@mxxh  
IF (@config6249>0 )AND (@zxrq<>'')  
BEGIN  
 if (select datediff(Day,substring(@zxrq,1,4)+"-"+substring(@zxrq,5,2)+"-"+substring(@zxrq,7,2)+" "+substring(@zxrq,9,8),getdate()) )>@config6249   
 BEGIN  
  select "F","�������������ϵķ������ڳ�������6249�����ã�"  
  return  
 END  
   
END  
select @config6A91=config from YY_CONFIG where id= '6A91'   
if isnull(@config6A91,'')=''  
 select @config6A91='��'  
  
--add by kongwei for 218407 �½�ʯ���Ӵ�ѧ��һ����ҽԺ---NISϵͳ�����ճ�����������Ȩ�޿���  
declare @gwdm varchar(50),@zgxm ut_mc64,@czyh_gwdm varchar(200),@czyhxm varchar(200), @isTg ut_bz  --0 ͨ��   1 ��ͨ��  
select @isTg=1  
if (not exists(select 1 from ZY_BRFYMXK(nolock) where xh=@mxxh and czyh=@czyh) and @config6C69<>'')  
begin  
    select @czyh_gwdm=gwdm from czryk(nolock) where id=@czyh  
 while charindex(',',@czyh_gwdm)>0  
 begin  
  select @gwdm=substring(@czyh_gwdm,1,charindex(',',@czyh_gwdm)-1)  
  select @czyh_gwdm=substring(@czyh_gwdm,charindex(',',@czyh_gwdm)+1,255)  
  if exists(select 1 where charindex(rtrim(@gwdm),@config6C69)>0)   --�������õĸ�λ�ſ�����  
  begin  
      select @isTg=0  
      break;  
  end  
 end  
end  
else          --"ԭ¼�����Ա" ���� "����6C69δ���ø�λ����ʱ" ��ֱ������  
    select @isTg=0  
  
select @czyhxm=name from czryk(nolock) where id=@czyh  
  
if @isTg=1  
begin  
    select @zgxm=b.name from ZY_BRFYMXK a(nolock) left join czryk b(nolock) on a.czyh=b.id where a.xh=@mxxh  
    select "F","������Ŀֻ����ԭ��ʿ��" + @zgxm + "���ͻ�ʿ�����ϣ�"  
 return  
end  
 --************ ���ʲ�����Ŀ�Ƚ��пۿ�� start add by liu_ke ****************************    
begin tran  
if @tfsl<@ypqbsl and @zfbz=0   
begin  
 select @zfbz=1  
end  
if @zfbz=1 and @tfsl=0  
begin  
 select @tfsl=@ypqbsl  
END  
select @txbz = txbz from ZY_BCDMK a(NOLOCK),ZY_BRSYK b(NOLOCK)   
where a.bqdm = b.bqdm and a.id = b.cwdm and b.syxh = @syxh  
SELECT @tfsl = -@tfsl  
  
if (@IsEjk=1) --  wz Ϊ����HRP����  
    and exists (select 1 FROM BQ_LSCM_CLJLK b(NOLOCK) where b.fyxh=@mxxh AND b.kfdm not in ('','0') AND ISNULL(b.returnbz,'')='T') --AND b.jlzt=2   
 and exists(select 'x' from YY_CONFIG(nolock)where id='A234' and config='��')  
begin  
    update BQ_LSCM_CLJLK set jlzt=3 where fyxh=@mxxh  
    if @@error<>0 --or @@rowcount=0   
    begin  
    rollback tran  
    select "F","����BQ_LSCM_CLJLK״̬����"  
    return   
    end  
      
    declare @wzdm     ut_xh12,  
    @wz_pcxh  ut_xh12,  
    @wz_kfdm  ut_dm5,  
    @bqdm   ut_ksdm,  
    @ypsl   ut_sl10,  
    @errmsg1  varchar(5000),  
    @cljzxh     ut_xh12  
    ,@wzmxsl  ut_sl10  
      
 --select @wzdm=a.wzdm,@wz_kfdm=a.kfdm,@cljzxh=a.xh,@ypsl=a.wzzsl*(-1)   
 --from BQ_LSCM_CLJLK a(nolock),BQ_LSCM_CLJLK_MX b(nolock)  
 --where a.fyxh=@mxxh and a.xh=b.jzxh  
 --if @@error<>0 or @@rowcount=0   
 --begin  
 -- rollback tran  
 -- select "F","�������ݻ�ȡ����"  
 -- return   
 --end  
 --SELECT @ypsl=@tfsl  
    
    declare cs_wz cursor for  
    select a.wzdm,a.kfdm,a.xh,@tfsl*isnull(c.dysl,1)--,b.wzsl   
    from BQ_LSCM_CLJLK a(nolock) --inner join BQ_LSCM_CLJLK_MX b(nolock) on a.xh=b.jzxh  
  left join BQ_FJFWZXMDY c(nolock)on a.bqdm=c.bqdm and a.xmdm=c.xmdm and a.wzdm=c.wzdm  
    where a.fyxh=@mxxh  
    for read only  
    open cs_wz   
    fetch cs_wz into @wzdm,@wz_kfdm,@cljzxh,@ypsl--,@wzmxsl  
    while @@fetch_status=0  
 begin  
  --����ǿɵ����ʣ�������δ�����(������wzzslΪǰ̨������������ϸ��wzsl=0)�ļ�¼ʱӦ�ô�0  
  --if @wzmxsl=0  
  --begin  
  -- SELECT @ypsl=0  
  --end  
   
  
  exec USP_LSCM_IF_KC @ifid=@cljzxh  
   ,@ifid_t=@cljzxh  
   ,@kfdm=@wz_kfdm  
   ,@wzdm=@wzdm  
   ,@xmmc=''  
   ,@wzsl=@ypsl  
   ,@xhfs=1  
   ,@zxczy=@czyh  
   ,@zxczyxm=@czyhxm  
   ,@errmsg=@errmsg1 output  
  if @errmsg1 like "F%" OR @@ERROR<>0  
  begin  
   rollback tran  
   deallocate cs_wz  
   select "F",substring(@errmsg1,2,49)  
   return  
  end   
  fetch cs_wz into @wzdm,@wz_kfdm,@cljzxh,@ypsl--,@wzmxsl  
    end  
    close cs_wz  
    deallocate cs_wz  
      
end -- ����ԭ����  
else IF EXISTS (SELECT 1 FROM ZY_BRFYMXK a(NOLOCK),VW_WZ_CLDYXM b(NOLOCK)  
   WHERE a.xh=@mxxh AND a.jlzt=0 AND a.ypdm=b.idm AND 'B'+a.bqdm=b.ksdm)--���ϵ���Ŀ�ǲ���  
BEGIN       
 if exists(select 1 from BQ_WZCLJZJLK a(nolock),ZY_BRFYMXK b(NOLOCK)   
        where a.xh=b.qqxh AND b.xh=@mxxh)  --���ϼ�����������  
 begin       
  DECLARE  @jzxh ut_xh12,   
   @wzkfdm ut_dm5,    
   @wzzldm ut_dm2,    
   @wzny ut_ny,    
   @wzxxh ut_xh12,    
   @wzczdm ut_dm2,    
   @wzksdm ut_dm5,    
   @wzcgj ut_money  ,  
   @zxsl  ut_sl10,  
   @wzph ut_mc16,  
   @wzxq ut_rq8,  
   @wzlsj ut_money  
  SELECT @jzxh=qqxh,@ypdm=a.ypdm,@zxsl=-a.ypsl FROM ZY_BRFYMXK a(NOLOCK) WHERE a.xh=@mxxh AND jlzt=0  
  select @wzkfdm=kfdm,@wzzldm=zldm,@wzksdm=ksdm,@wzcgj=cgj,@wzph=ph,@wzxq=xq,@wzxxh=xxh,@wzlsj=lsj --��Ϣ�ź����ۼ۴�BQ_WZCLJZJLK��ȡ  
  from BQ_WZCLJZJLK(nolock) where xh=@jzxh   
  select @wzny=ny from WZ_TJQSZ(nolock) where kfdm=@wzkfdm and zldm=@wzzldm and jzbz=0    
     --select @wzxxh=xxh from YY_CLDYK(nolock) where idm=@ypdm    
     --if @zxsl>0    
  set @wzczdm='37'    
     --else    
     --set @wzczdm='38'    
          
  --����ж�    
  if not exists(select 1 from WZ_KSTZK(nolock) where sl>=@zxsl and xxh=@wzxxh and ksdm=@wzksdm and kfdm=@wzkfdm and zldm=@wzzldm    
   and ny=@wzny and ph=@wzph and xq=@wzxq and lb=2)    
  begin      
   select 'F','���ʲ��Ͽ�治�㣡'    
   rollback tran     
   return    
  end    
     --�����ʵĿ��         
  exec usp_wz_tzcl @wzkfdm, @wzzldm, @wzny, @wzxxh, @wzph, @wzxq, @wzcgj, @czyh, @zxsl,     
   @wzczdm, @jzxh, '', @jzxh, @errmsg output, 1, @wzksdm    
   ,'',0,0,@lsj=@wzlsj,@gxlsje=0    
  if @errmsg like 'F%'    
  begin        
   select 'F',substring(@errmsg,2,49)    
   rollback tran      
   return    
  end    
 end    
end  
--************ ���ʲ�����Ŀ�Ƚ��пۿ��  end  add by liu_ke ****************************    
--swx 2015-1-20 for 11700 ���������¼  
select @pcxh=0,@tm='',@wzqqxh=0  
IF exists(select 1 FROM YY_ZY_CLJLK b(NOLOCK)where b.fyxh=@mxxh AND b.jlzt=2 )  
 and exists(select 'x' from YY_CONFIG(nolock)where id='A234' and config='��')  
 and exists(select 'x' from YY_CONFIG(nolock)where id='A262' and config='��')  
 and exists(select 'x' from YY_CONFIG(nolock)where id='A219' and config='��')  
 and exists(select 'x' from YY_CONFIG(nolock)where id='A206' and config='1')  
BEGIN  
 --update YY_ZY_CLJLK set jlzt=3  --�м����brqf�и���  
 --where fyxh=@mxxh  
   
 select @pcxh=b.wzpcxh,@tm=b.txm,@wzqqxh=a.xh  
 from YY_ZY_CLJLK a(nolock)inner join YY_ZY_CLJLK_MX b(nolock) on a.xh=b.jlxh  
 where a.fyxh=@mxxh  
END  
  
select @ysdm = ysdm,@cd_idm = idm,@ypdm = ypdm,@yfdm = zxks,@fylb = fylb,@ypdw = ypdw,@dwxs = dwxs  
 ,@txbz = txbz,@ypdj = ypdj,@qqxh = qqxh,@qqrq=qqrq,@ykxs = ykxs,@zfdj = zfdj,@ybshbz = ybshbz,@yzxh=yzxh  
 ,@jfsj = case when @config6A91='��' then zxrq else null end   
from ZY_BRFYMXK   
where xh = @mxxh  
--0�����ϣ�1���˷�  
if @zfbz = 1  
begin  
 exec usp_zy_brqf @syxh, @czyh, @ysdm, @cd_idm, @ypdm, @yfdm, @fylb, 0, @ypdw, @dwxs, @tfsl, @txbz,   
  @errmsg output, @ypdj, @yzxh, @qqxh, @qqrq, @yexh, 2, @mxxh, @ykxs, null,@zfdj,@ybshbz,@jfsj=@jfsj  
  ,@fymxxh_out=@fymxxh output  
  ,@pcxh=@pcxh,@tm=@tm,@wzqqxh=@wzqqxh,@dyly=1  
 if @errmsg like "F%" OR @@ERROR<>0  
 begin  
  rollback tran  
  select "F",substring(@errmsg,2,49)  
  return  
 end  
end  
if @zfbz = 0  
begin  
 --yxp update  
 if (@yexh is null) or (@yexh = 0)  
  exec usp_zy_brqf @syxh, @czyh, '', 0, '', '', 6, 0, '', 1, @tfsl, 0,   
   @errmsg output, 0, @yzxh, null, null, @yexh, 1, @mxxh,null,@memo,@jfsj=@jfsj,@fymxxh_out=@fymxxh output  
   ,@pcxh=@pcxh,@tm=@tm,@wzqqxh=@wzqqxh,@dyly=1  
 else  
  exec usp_zy_brqf @syxh, @czyh, '', 0, '', '', 9, 0, '', 1, @tfsl, 0,   
   @errmsg output, 0, @yzxh, null, null, @yexh, 1, @mxxh,null,@memo,@jfsj=@jfsj,@fymxxh_out=@fymxxh output  
   ,@pcxh=@pcxh,@tm=@tm,@wzqqxh=@wzqqxh,@dyly=1  
 if @errmsg like "F%" OR @@ERROR<>0  
 begin  
  rollback tran  
  select "F",substring(@errmsg,2,49)  
  return  
 end  
END  
  
declare @cfymxxh_out VARCHAR(12)  
 ,@ctkxh VARCHAR(12)  
 ,@sql nVARCHAR(3000)  
 ,@hrperrmsg VARCHAR(50)  
 ,@ParmDefinition NVARCHAR(500)    
  
if (@IsEjk=1) and exists (select 1 FROM BQ_LSCM_CLJLK b(NOLOCK) where b.fyxh=@mxxh AND b.kfdm not in ('','0') AND ISNULL(b.returnbz,'')='T' )   
 and exists(select 'x' from YY_CONFIG(nolock)where id='A234' and config='��')  
begin  
 SELECT @ctkxh=convert(varchar(12),isnull(@cljzxh,0))  
        ,@cfymxxh_out=convert(varchar(12),isnull(@fymxxh,0))   
 SET @sql= N' exec USP_LSCM_IF_KC @ifid=' +@ctkxh+  
  ',@ifid_t='+@ctkxh+  
  ',@wzdm =0'+  
  ',@xmmc=""'+  
  ',@zxczy="'+@czyh+'"'+  
  ',@zxczyxm="'+@czyhxm+'"'+  
  ',@fymxh='+@cfymxxh_out+  
  ',@xhfs=1'+  
  ',@errmsg=@hrperrmsg OUTPUT'    
  
 SET  @ParmDefinition=N'  @hrperrmsg varchar(64) output'  
 exec sp_executesql @sql,@ParmDefinition,@hrperrmsg=@hrperrmsg OUTPUT      
 if @@ERROR<>0  OR @hrperrmsg LIKE 'F%'  
 begin  
  rollback tran  
  select "F","��д������ϸ��Ŵ���USP_LSCM_IF_KC��������Ϣ:"+@errmsg  
  return  
 END  
 SELECT @hrperrmsg=NULL   
end  
   
if (@zfmk=0) or exists (select 1 from YY_CONFIG where id='6652' and substring(config,@zfmk,1)>0)-- swx 199370 6652 Ϊ0ʱ���������˷�ԭ��  
begin  
    --add by hhy for bug208534 ����Ҫ�ж��Ƿ���ڣ����ܲ���  
    if not exists(select 1 from ZY_BRFYMXK_FZ where xh = @fymxxh)  
    begin  
        insert into ZY_BRFYMXK_FZ(xh,syxh,tfyy)values(@fymxxh,@syxh,@memo)  
    end  
    else  
    begin  
        update ZY_BRFYMXK_FZ set tfyy = @memo where syxh=@syxh and xh = @fymxxh    
    end        
    if @@error<>0 or @@rowcount=0   
    begin  
    rollback tran  
    select "F","ZY_BRFYMXK_FZ����(����)ʧ�ܣ�"  
    return   
    end   
end  
--�ǼƷ����������˿�����hrpkcbz=1   
if exists(select 1 from ZY_BRFYMXK a(nolock) where a.syxh=@syxh and a.xh=@fymxxh   
  and a.idm=0 and a.ypdm in (select b.xmdm from BQ_FJFWZXMDY b(nolock)where b.bqdm=a.bqdm))  
 and exists(select 1 from BQ_LSCM_CLJLK a(nolock) where a.syxh=@syxh   
  and a.fyxh in (select isnull(b.tfxh,0) from ZY_BRFYMXK b(nolock)where b.syxh=@syxh and b.xh=@fymxxh)  
  and a.jlzt=3  
 )  
begin  
 if not exists(select 1 from ZY_BRFYMXK_FZ where xh = @fymxxh)  
  insert into ZY_BRFYMXK_FZ(xh,syxh,hrpkcbz)values(@fymxxh,@syxh,1)  
 else  
  update ZY_BRFYMXK_FZ set hrpkcbz = 1 where syxh=@syxh and xh = @fymxxh    
end  
  
--����HRP�ӿ� 230846   
IF @config6C40 ='��'  
BEGIN   
    select @barCodeHRP = bar_code from ZY_BRFYMXK where xh = @mxxh  
 if @barCodeHRP <> ''  
 begin  
 update mate_inv_dict_view set sybz=0 where bar_code =@barCodeHRP   
 update ZY_BRFYMXK set bar_code =@barCodeHRP where xh= @fymxxh  
 end   
 if @@error<>0   
    begin  
    rollback tran  
    select "F","�����������"  
    return   
    end   
End   
commit tran  
select "T"  
return 

