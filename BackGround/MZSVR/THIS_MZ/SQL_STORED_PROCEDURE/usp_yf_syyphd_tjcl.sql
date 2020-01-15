if exists(select * from sysobjects where name='usp_yf_syyphd_tjcl')
	drop proc usp_yf_syyphd_tjcl
go
create procedure usp_yf_syyphd_tjcl    
 @wkdz     varchar(32),           --������ַ      
 @jszt     ut_bz,                 --����״̬ 1=������2=���룬3=�ݽ�      
 @dxmdm    ut_xmdm = '',          --����Ŀ����      
 @xmdm     ut_xmdm = '',          --��Ŀ����    
 @xmmc     ut_mc64 = '',          --��Ŀ����        
 @xmdw     ut_unit  = '',         --��Ŀ��λ    
 @xmdj     ut_money = 0,          --����     
 @sl       ut_sl10 = 0 ,          --����    
 @czyh     ut_czyh='',            --����Ա��        
 @patid    ut_xh12 = 0,           --���˱�ʶ       
 @hzxm     ut_mc64 = '',          --��������     
 @lrrq     ut_rq16 = '',          --¼������    
 @ysdm     ut_czyh ='',           --ҽ������     
 @ksdm     ut_ksdm =''            --���Ҵ���    
 ,@yfdm    ut_ksdm =''  
 ,@lcxmdm  ut_xmdm ='0'           --�ٴ���Ŀ���� --add by guo 20131226 for ����187999  
 ,@cftszddm ut_zddm=''   --������ϴ���  
 ,@memo    ut_memo=''    --��ע  
 ,@wztxm ut_mc64=''   --������  
 ,@wzpcxh   ut_xh12=0  --�����������  
 ,@wzkfdm ut_dm5=''    --���ʿⷿ����  
 ,@selectedGhxh ut_xh12 = -1 --ѡ�еĹҺ����
 ,@isejk     ut_bz=0   --0:������HRP��������ϵͳ��1������HRP��������ϵͳ  
 ,@wzctxm  ut_mc64=''  --������  
 ,@wzdm  ut_mc32=''  --���ʴ���  
as --��141306 2019-11-21 16:58:40 ������Һ��_201803
/**********      
[�汾��]4.0.0      
[����ʱ��]20080603       
[����] majun      
[��Ȩ] Copyright ? 2004-2008�Ϻ����˴�-��������ɷ����޹�˾    
[����] ��Һ�Ҳ���ҩƷ�˶�-��������      
[����˵��]      
    ��Һ�Ҳ���ҩƷ�˶�-��������     
[����˵��]    
 @wkdz   varchar(32),--������ַ      
 @jszt   ut_bz,--����״̬ 1=������2=���룬3=�ݽ�    
     
 @dxmdm   ut_xmdm = '', --����Ŀ����      
 @xmdm   ut_xmdm = '',--��Ŀ����    
    @xmmc           ut_mc64 = '', --��Ŀ����        
 @xmdw   ut_unit  = '',--��Ŀ��λ    
 @xmdj           ut_money = 0, --����     
 @sl             ut_sl10 = 0 ,--����    
    
 @czyh   ut_czyh='', --����Ա��        
 @patid   ut_xh12 = 0, --���˱�ʶ       
 @hzxm           ut_name = '',--��������     
 @lrrq           ut_rq16 = '',--¼������    
 @ysdm           ut_czyh ='', --ҽ������     
 @ksdm           ut_ksdm =''--���Ҵ���     
   
 @memo    ut_memo=''    --��ע   
   
 @wztxm ut_mc64=''   --������  
 @wzpcxh   ut_mc32='0'  --�����������  
 @wzkfdm ut_dm5=''    --���ʿⷿ����   
 @selectedGhxh ut_xh12 = -1 --ѡ�еĹҺ����
 @isejk     ut_bz=0   --0:������HRP��������ϵͳ��1������HRP��������ϵͳ  
 @wzctxm  ut_mc64=''  --������  
 @wzdm  ut_mc32=''  --���ʴ���  
[����ֵ]      
[�����������]       
[���õ�sp]        
[����ʵ��]       
[�޸���ʷ]   
 jl   2008-07-10 �޸� SF_HJCFK���޸�    
**********/      
set nocount on      
declare @tablename varchar(32),@configK047 varchar(10),@configK094 varchar(10),@configK100 varchar(10),@configK123 varchar(10)      
select @tablename='##syyphd_tjcl'+@wkdz   
select @configK047=config from YY_CONFIG where id='K047'   
select @configK094=config from YY_CONFIG where id='K094'   
select @configK100=isnull(config,'') from YY_CONFIG where id='K100'  
select @configK123=isnull(config,'0') from YY_CONFIG where id='K123'  
  
    
--���ɵݽ�����ʱ��      
if @jszt = '1'      
begin      
 exec(' if exists (select 1 from tempdb..sysobjects where name = "' +@tablename+ '")       
      drop table '+@tablename)      
 exec('create table '+@tablename+      
  '(   
  dxmdm         ut_xmdm            not null,    --����Ŀ����  
  xmdm          ut_xmdm            not null, --��Ŀ����      
  xmmc          ut_mc64             not null, --��Ŀ����      
  xmdw          ut_unit                 not null, --��Ŀ��λ      
  sl            ut_sl10                not null, --����      
  xmdj          ut_money            not null, --��Ŀ����      
  lcxmdm        ut_xmdm            not null,--�ٴ���Ŀ���� --add by guo 20131226 for ����187999  
  cftszddm      ut_zddm   not null, --������ϴ���  
  memo          ut_memo   not null, --��ע  
  wztxm   ut_mc64 null,   --������  
  wzpcxh     ut_xh12 null,  --�����������  
  wzkfdm  ut_dm5  null,    --���ʿⷿ����  
  ysdm          ut_czyh null,    --ҽ������     
  ksdm          ut_ksdm null,     --���Ҵ���   
  wzdm			ut_mc32 null,  --���ʴ���  
  wzctxm        ut_mc64 null  --������  
              )')      

if @@error<>0      
begin      
  select "F","������ʱ��ʱ����"      
  return      
end      
    
 select "T"      
 return      
end      
    
    
--����ݽ��ļ�¼      
if @jszt = 2      
begin     
 declare @csl varchar(12),       
    @cxmdj varchar(12)      
 select    @csl=convert(varchar(12),@sl),      
       @cxmdj=convert(varchar(12),@xmdj,2)      
 exec(' insert into '+@tablename+' values("'+@dxmdm+'","'+@xmdm+'","' +@xmmc+ '","' +@xmdw+ '",' +@csl+ ',' +@cxmdj+ ',"'+@lcxmdm+'","'+@cftszddm+'","'+@memo+  
    '","'+@wztxm+'","'+@wzpcxh+'","'+@wzkfdm+'","'+@ysdm+'","'+@ksdm+'","'+@wzdm+'","'+@wzctxm+'")')  --add by guo 20131226 for ����187999   
       
 if @@error<>0      
 begin      
  select "F","������ʱ��ʱ����"      
  return      
 end      
    
 select "T"      
 return     
end      
    
    
    
if @jszt = 3      
begin    
 create table #tjcltmp      
 (   
 dxmdm         ut_xmdm            not null, --����Ŀ����      
 xmdm          ut_xmdm            not null, --��Ŀ����      
 xmmc          ut_mc64             not null, --��Ŀ����      
 xmdw          ut_unit                 not null, --��Ŀ��λ      
 sl            ut_sl10                not null, --����      
 xmdj          ut_money            not null, --��Ŀ����  
 lcxmdm        ut_xmdm             not null,--�ٴ���Ŀ����   --add by guo 20131226 for ����187999   
 cftszddm      ut_zddm   not null,  --������ϴ���  
 memo          ut_memo    not null,   --��ע  
 wztxm     ut_mc64 null,   --������  
 wzpcxh        ut_xh12 null,  --�����������  
 wzkfdm     ut_dm5  null,    --���ʿⷿ����  
 ysdm          ut_czyh null,    --ҽ������     
 ksdm          ut_ksdm null,     --���Ҵ���   
 wzdm			ut_mc32 null,  --���ʴ���  
 wzctxm        ut_mc64 null  --������  
 )    
    
    
    
 exec(' insert into #tjcltmp select * from '+@tablename)      
 if @@error<>0       
 begin      
  select "F","������ʱ��ʱ����"      
  return      
 end     
    
    
 exec(' drop table '+@tablename)        
   
 begin tran    
    
 declare @cfxh  ut_xh12,  
   @ghxh  ut_xh12,  
   @wzjlxh ut_xh12,  
   @count int  
 declare @mxxh  ut_xh12  
 declare @ypdm ut_xmdm,  
         @lcxmdm_temp ut_xmdm ,--guo  
         @cwztxm  ut_mc64 ,   --������  
	     @cwzpcxh     ut_xh12 ,  --�����������  
	     @cwzkfdm  ut_dm5,
	     @cwzdm	 ut_mc32 , 
	     @cwzctxm  ut_mc64  
 declare  @cftszdmc ut_mc64  
   
 declare @jlxh ut_xh12  
 if (@configK094="��")  
    select @cftszdmc=name from YY_YLXMK where id=@cftszddm   
 else  
 select @cftszdmc=name from YY_BZDMK where id=@cftszddm  
   
 if (@configK047="��")  
 begin  
 select @count=COUNT(1) from #tjcltmp  
 if @count<=0   
 begin  
  select "T" 
  commit tran  -- add by  yzy 20191111   
  return  
 end  
   
 if (@configK100<>'��')  
 begin  
  --�ж��Ƿ���δ�շѵ���Ŀ���������ȡ��ǰδ�շ���Ŀ�Ĵ������    
  if exists (select 1 from SF_HJCFK where patid =@patid and jlzt = 0 and zjbz=3 and ysdm = @ysdm and ksdm = @ksdm)    
  begin    
	   select @cfxh=max(xh) from SF_HJCFK where patid =@patid and jlzt =0  and zjbz=3 and ysdm = @ysdm and ksdm = @ksdm  
	   update SF_HJCFK set ysdm=@ysdm,cftszddm=@cftszddm,cftszdmc=@cftszdmc,lrrq=@lrrq where patid=@patid and jlzt=0 and zjbz=3 and ysdm = @ysdm and ksdm = @ksdm  
		if @@rowcount=0 and @@error<>0  
		begin      
			select "F","���»��۴�������"      
			rollback tran      
			return      
		end      
  end   
  else    
  begin   
  if @configK123<>'1' or @selectedGhxh<1
       select @ghxh=max(xh) from GH_GHZDK where patid = @patid and jlzt=0 
  else
       select @ghxh= @selectedGhxh
	   insert into SF_HJCFK(czyh,lrrq,patid,hzxm,py,wb,ysdm,ksdm,yfdm,sfksdm,cfts,jlzt    
      ,cflx,sycfbz,tscfbz,ghxh,shbz1,shbz2,shbz3,zfcfbz,jzbz,djbz,djje,ybbz,ybshbz,zjbz,    
      qxjlzt,jsdjfbz,shbz5,shbz4,ekbz,dmjsbz,ejygbz,cftszddm,cftszdmc)    
      values(@czyh,@lrrq,@patid,@hzxm,"","",@ysdm,@ksdm,@yfdm,"",1,0  
      ,5,0,0,@ghxh,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,@cftszddm,@cftszdmc)     
   if @@rowcount=0 and @@error<>0      
   begin      
    select "F","���뻮�۴�������"      
    rollback tran      
    return      
   end     
   select @cfxh=@@identity    
  end    
    
  --ɾ����ͨ��Ŀ   
  if exists (select 1 from SF_HJCFMXK where cfxh =@cfxh and ypdm in (select xmdm from #tjcltmp WHERE ISNULL(lcxmdm,0)=0))    
  begin    
    delete from SF_HJCFMXK where cfxh =@cfxh and ypdm in (select xmdm from #tjcltmp WHERE ISNULL(lcxmdm,0)=0 ) AND isnull(lcxmdm,0)=0    
     
    if exists (select 1 from YY_MZ_CLJLK where jlzt=0 and hjcfxh =@cfxh and xmdm in (select xmdm from #tjcltmp WHERE ISNULL(lcxmdm,0)=0) and qqlb=0 and patid=@patid)  
    begin  
    select @wzjlxh=xh from  YY_MZ_CLJLK  where jlzt=0 and hjcfxh =@cfxh and xmdm in (select xmdm from #tjcltmp WHERE ISNULL(lcxmdm,0)=0) and qqlb=0 and patid=@patid  
       
    delete from  YY_MZ_CLJLK  where jlzt=0 and hjcfxh =@cfxh and xmdm in (select xmdm from #tjcltmp WHERE ISNULL(lcxmdm,0)=0) and qqlb=0 and patid=@patid  
              
    if @@ERROR<>0  
	begin  
	 select "F","ɾ�����ʲ����������"      
	 rollback tran      
	 return     
	end  
	         
	delete from YY_MZ_CLJLK_MX  where jlxh=@wzjlxh and exists (select 1 from #tjcltmp b where wzpcxh=b.wzpcxh and txm=b.wztxm and kfdm=b.wzkfdm)  
	if @@ERROR<>0  
	begin  
	 select "F","ɾ�����ʲ�����ϸ����"      
	 rollback tran      
	 return     
	end    
	             
	delete from SF_HJCFMXK_FZ  where cfxh=@cfxh and exists (select 1 from #tjcltmp b where pcxh=b.wzpcxh and txm=b.wztxm)  
	if @@ERROR<>0  
	begin  
	 select "F","ɾ������������ϸ����"      
	 rollback tran      
	 return     
	end    
   end  
     
   end    
    
   --ɾ���ٴ���Ŀ  
   if exists (select 1 from SF_HJCFMXK where cfxh =@cfxh and lcxmdm in (select lcxmdm from #tjcltmp WHERE ISNULL(lcxmdm,0)<>0))    
   begin    
      delete from SF_HJCFMXK where cfxh =@cfxh and lcxmdm in (select lcxmdm from #tjcltmp WHERE ISNULL(lcxmdm,0)<>0 ) AND isnull(lcxmdm,0)<>0    
		if @@ERROR<>0  -- add by yzy 20191111
			begin
			   select "F","ɾ������������ϸ����"    
			   rollback tran    
			   return   
			end  
   end    
 end  
      
 declare authors_cursor cursor for select distinct xmdm,lcxmdm,wztxm,wzpcxh,wzkfdm,ysdm,ksdm,cftszddm,wzdm,wzctxm from #tjcltmp  
 open authors_cursor  
 fetch authors_cursor into @ypdm,@lcxmdm_temp,@cwztxm,@cwzpcxh,@cwzkfdm,@ysdm,@ksdm,@cftszddm,@cwzdm,@cwzctxm  
 while @@fetch_status = 0  
 begin  
  if (@configK100='��')  
  begin  
    if (@configK094="��")  
        select @cftszdmc=name from YY_YLXMK where id=@cftszddm   
    else  
        select @cftszdmc=name from YY_BZDMK where id=@cftszddm  
   --�ж��Ƿ���δ�շѵ���Ŀ���������ȡ��ǰδ�շ���Ŀ�Ĵ������    
   if exists (select 1 from SF_HJCFK where patid =@patid and jlzt = 0 and zjbz=3 and ysdm = @ysdm and ksdm = @ksdm and (@configK094<>'��' or (@configK094='��' and cftszddm=@cftszddm)))    
   begin    
    select @cfxh=max(xh) from SF_HJCFK where patid =@patid and jlzt =0  and zjbz=3 and ysdm = @ysdm and ksdm = @ksdm and (@configK094<>'��' or (@configK094='��' and cftszddm=@cftszddm))  
    update SF_HJCFK set ysdm=@ysdm,cftszddm=@cftszddm,cftszdmc=@cftszdmc,lrrq=@lrrq where patid=@patid and jlzt=0 and zjbz=3 and ysdm = @ysdm and ksdm = @ksdm and (@configK094<>'��' or (@configK094='��' and cftszddm=@cftszddm))  
    if @@rowcount=0 and @@error<>0  
    begin      
     select "F","���»��۴�������"      
     rollback tran      
     return      
    end      
   end   
   else    
   begin   
    if @configK123<>'1' or @selectedGhxh<1
       select @ghxh=max(xh) from GH_GHZDK where patid = @patid and jlzt=0 
    else
       select @ghxh= @selectedGhxh
     insert into SF_HJCFK(czyh,lrrq,patid,hzxm,py,wb,ysdm,ksdm,yfdm,sfksdm,cfts,jlzt    
       ,cflx,sycfbz,tscfbz,ghxh,shbz1,shbz2,shbz3,zfcfbz,jzbz,djbz,djje,ybbz,ybshbz,zjbz,    
       qxjlzt,jsdjfbz,shbz5,shbz4,ekbz,dmjsbz,ejygbz,cftszddm,cftszdmc)    
      values(@czyh,@lrrq,@patid,@hzxm,"","",@ysdm,@ksdm,@yfdm,"",1,0  
       ,5,0,0,@ghxh,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,@cftszddm,@cftszdmc)     
    if @@rowcount=0 and @@error<>0      
    begin      
     select "F","���뻮�۴�������"      
     rollback tran      
     return      
    end     
    select @cfxh=@@identity    
   end    
  end  
     
   if exists (select 1 from SF_HJCFMXK where ypdm = @ypdm AND lcxmdm=@lcxmdm_temp and  cfxh=@cfxh)  
   -- ע�� cfxh in(select xh from SF_HJCFK where patid =@patid and jlzt =0 and zjbz=3))      
   begin  
     select @mxxh = max(xh) from SF_HJCFMXK where ypdm = @ypdm AND lcxmdm=@lcxmdm_temp and cfxh=@cfxh 
   -- ע��  cfxh in (select xh from SF_HJCFK where patid =@patid and jlzt =0 and zjbz=3)  
   update SF_HJCFMXK set ypsl = (select sum(sl) from #tjcltmp where xmdm = @ypdm and lcxmdm=@lcxmdm_temp group by xmdm,lcxmdm),  
       memo=(select top 1 isnull(memo,'') from #tjcltmp where xmdm = @ypdm and lcxmdm=@lcxmdm_temp and ysdm = @ysdm and ksdm = @ksdm)   
    where xh = @mxxh

	if @@ERROR<>0  -- add by yzy 20191111
	begin
	   select "F","���´�����ϸ����"    
	   rollback tran    
	   return   
	end 	
  end  
  else  
  begin  
   if @isejk=0
   begin
	   insert into SF_HJCFMXK (cfxh,cd_idm,gg_idm,dxmdm,ypdm,ypdw,ypxs,ykxs,ypfj,ylsj,    
		ypjl,dwlb,ts,ypsl,cfts,shbz,zbz,lcxmdm,clbz,ybspbz,ypmc,memo)    
	   select @cfxh,0,0,dxmdm,xmdm,xmdw,1,1,xmdj,xmdj,    
		0,0,1,sl,1,0,0,@lcxmdm_temp,0,0,xmmc,memo   
	   from #tjcltmp   
	   where xmdm = @ypdm AND lcxmdm=@lcxmdm_temp 
	   and (@configK100<>'��' or (@configK100='��' and ysdm=@ysdm and (@configK094<>'��' or (@configK094='��' and cftszddm=@cftszddm))))  
   end
   else
   begin
        insert into SF_HJCFMXK (cfxh,cd_idm,gg_idm,dxmdm,ypdm,ypdw,ypxs,ykxs,ypfj,ylsj,    
		ypjl,dwlb,ts,ypsl,cfts,shbz,zbz,lcxmdm,clbz,ybspbz,ypmc,memo,wzdm,wzkfdm,wzpcxh,tm,ctxm)    
	   select @cfxh,0,0,dxmdm,xmdm,xmdw,1,1,xmdj,xmdj,    
		0,0,1,sl,1,0,0,@lcxmdm_temp,0,0,xmmc,memo,wzdm,wzkfdm,wzpcxh,wztxm,wzctxm  
	   from #tjcltmp   
	   where xmdm = @ypdm AND lcxmdm=@lcxmdm_temp 
	   and (@configK100<>'��' or (@configK100='��' and ysdm=@ysdm and (@configK094<>'��' or (@configK094='��' and cftszddm=@cftszddm))))  
   end  
   select @mxxh=IDENT_CURRENT('SF_HJCFMXK')  
   if @@rowcount=0 and @@error<>0      
   begin      
   select "F","���뻮�۴�����ϸ����"      
   rollback tran      
   return      
   end         
        
  end   
    
  if isnull(@cwzpcxh,0)>0 and @isejk=0  
  begin  
   insert into SF_HJCFMXK_FZ(cfxh,mxxh,xxh,wzmc,ggxh,pcxh,wzdw,ph,sxrq,txm,fzxh)  
   select @cfxh,@mxxh,b.xxh,b.wzmc,b.ggxh,@cwzpcxh,b.zxdw,b.ph,b.xq,b.txm,0   
   from #tjcltmp a,VW_WZ_CLDYXM_KSK b(nolock)  
   where a.xmdm=@ypdm and  lcxmdm=@lcxmdm_temp and a.xmdm=b.xmdm and (b.txm=@cwztxm or ISNULL(@cwztxm,'')='') and b.kfdm=@cwzkfdm and b.pcxh=@cwzpcxh  
    and (@configK100<>'��' or (@configK100='��' and ysdm=@ysdm and (@configK094<>'��' or (@configK094='��' and cftszddm=@cftszddm))))  
   if @@rowcount=0 and @@error<>0      
   begin      
   select "F","���뻮�۴���������ϸ����"      
   rollback tran      
   return      
   end     
     
   insert into YY_MZ_CLJLK(patid, hjcfxh,hjmxxh,qqlb,czy,ksdm,xmdm,sfsl,lrrq,jlzt,fzxh,lcxmdm)  
   select @patid,@cfxh,@mxxh,0,@czyh,@ksdm,@ypdm,a.sl,@lrrq,0,0,0  
   from #tjcltmp a  
   where a.xmdm=@ypdm and  a.lcxmdm=@lcxmdm_temp   
    and (@configK100<>'��' or (@configK100='��' and ysdm=@ysdm and (@configK094<>'��' or (@configK094='��' and cftszddm=@cftszddm))))  
     
   select @jlxh=IDENT_CURRENT('YY_MZ_CLJLK')  
   if @@rowcount=0 and @@error<>0      
   begin      
    select "F","������ϼ�¼���������"      
    rollback tran      
    return      
   end    
     
   insert into YY_MZ_CLJLK_MX(jlxh,wzpcxh,wzsl,txm,kfdm)  
   select @jlxh,@cwzpcxh,a.sl,b.txm,@wzkfdm  
   from #tjcltmp a,VW_WZ_CLDYXM_KSK b(nolock)  
   where a.xmdm=@ypdm and  lcxmdm=@lcxmdm_temp and a.xmdm=b.xmdm and (b.txm=@cwztxm or ISNULL(@cwztxm,'')='') and b.kfdm=@cwzkfdm and b.pcxh=@cwzpcxh  
    and (@configK100<>'��' or (@configK100='��' and ysdm=@ysdm and (@configK094<>'��' or (@configK094='��' and cftszddm=@cftszddm))))  
   if @@rowcount=0 and @@error<>0      
   begin      
    select "F","������ϼ�¼����ϸ����"      
    rollback tran      
    return      
   end    
     
     
  end  
  fetch authors_cursor into @ypdm,@lcxmdm_temp,@cwztxm,@cwzpcxh,@cwzkfdm,@ysdm,@ksdm,@cftszddm,@cwzdm,@cwzctxm     
  end  
  close authors_cursor  
  deallocate authors_cursor  
  commit tran     
 end  
 else  
 begin  
 declare @cdxmdm ut_xmdm      
 declare authors_cursor cursor for select distinct xmdm,dxmdm,lcxmdm,wztxm,wzpcxh,wzkfdm,ysdm,ksdm,cftszddm,wzdm,wzctxm from #tjcltmp  
 open authors_cursor  
 fetch authors_cursor into @ypdm,@cdxmdm,@lcxmdm_temp,@cwztxm,@cwzpcxh,@cwzkfdm,@ysdm,@ksdm,@cftszddm,@cwzdm,@cwzctxm    
 while @@fetch_status = 0  
 begin  
  if (@configK094="��")  
   select @cftszdmc=name from YY_YLXMK where id=@cftszddm   
   else  
   select @cftszdmc=name from YY_BZDMK where id=@cftszddm  
  --�ж��Ƿ���δ�շѵ���Ŀ,����Ŀ�����Ƿ�Ϊ@cdxmdm  
  if exists (select 1 from SF_HJCFK a,SF_HJCFMXK b where a.patid =@patid and a.jlzt = 0 and a.zjbz in(3,0) and a.ysdm = @ysdm and a.ksdm = @ksdm and a.xh=b.cfxh and b.dxmdm=@cdxmdm  
   and (@configK100<>'��' or (@configK100='��' and (@configK094<>'��' or (@configK094='��' and cftszddm=@cftszddm)))))    
  begin    
   select @cfxh=max(a.xh) from SF_HJCFK a,SF_HJCFMXK b where a.patid =@patid and a.jlzt =0  and a.zjbz in(3,0) and a.ysdm = @ysdm and a.ksdm = @ksdm and a.xh=b.cfxh and b.dxmdm=@cdxmdm  
    and (@configK100<>'��' or (@configK100='��' and (@configK094<>'��' or (@configK094='��' and cftszddm=@cftszddm))))  
   update SF_HJCFK set ysdm=@ysdm,cftszddm=@cftszddm,cftszdmc=@cftszdmc,lrrq=@lrrq where patid=@patid and jlzt=0 and zjbz=3 and ysdm = @ysdm and ksdm = @ksdm   
    and (@configK100<>'��' or (@configK100='��' and (@configK094<>'��' or (@configK094='��' and cftszddm=@cftszddm))))  
   if @@rowcount=0 and @@error<>0  
   begin      
    select "F","���»��۴�������"      
    rollback tran      
    return      
   end      
  end   
  else    
  begin   
   if @configK123<>'1' or @selectedGhxh<1
       select @ghxh=max(xh) from GH_GHZDK where patid = @patid and jlzt=0 
   else
       select @ghxh= @selectedGhxh
   insert into SF_HJCFK(czyh,lrrq,patid,hzxm,py,wb,ysdm,ksdm,yfdm,sfksdm,cfts,jlzt    
   ,cflx,sycfbz,tscfbz,ghxh,shbz1,shbz2,shbz3,zfcfbz,jzbz,djbz,djje,ybbz,ybshbz,zjbz,    
   qxjlzt,jsdjfbz,shbz5,shbz4,ekbz,dmjsbz,ejygbz,cftszddm,cftszdmc)    
   values(@czyh,@lrrq,@patid,@hzxm,"","",@ysdm,@ksdm,@yfdm,"",1,0  
   ,5,0,0,@ghxh,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,@cftszddm,@cftszdmc)       
   if @@rowcount=0 and @@error<>0      
   begin      
    select "F","���뻮�۴�������"      
    rollback tran      
    return      
   end     
   select @cfxh=@@identity    
  end    
    
  if exists (select 1 from SF_HJCFMXK where cfxh =@cfxh and ypdm=@ypdm and lcxmdm=@lcxmdm_temp)    
  begin    
   delete from SF_HJCFMXK where cfxh =@cfxh and ypdm =@ypdm  AND lcxmdm=@lcxmdm_temp  
      if exists (select 1 from YY_MZ_CLJLK where jlzt=0 and hjcfxh =@cfxh and xmdm in (select xmdm from #tjcltmp WHERE ISNULL(lcxmdm,0)=0) and qqlb=0 and patid=@patid)  
   begin  
    select @wzjlxh=xh from  YY_MZ_CLJLK  where jlzt=0 and hjcfxh =@cfxh and xmdm in (select xmdm from #tjcltmp WHERE ISNULL(lcxmdm,0)=0) and qqlb=0 and patid=@patid  
      
    delete from  YY_MZ_CLJLK  where jlzt=0 and hjcfxh =@cfxh and xmdm in (select xmdm from #tjcltmp WHERE ISNULL(lcxmdm,0)=0) and qqlb=0 and patid=@patid  
             
    if @@ERROR<>0  
    begin  
     select "F","ɾ�����ʲ����������"      
     rollback tran      
     return     
    end  
        
    delete from YY_MZ_CLJLK_MX  where jlxh=@wzjlxh and exists (select 1 from #tjcltmp b where wzpcxh=b.wzpcxh and txm=b.wztxm and kfdm=b.wzkfdm)  
    if @@ERROR<>0  
    begin  
     select "F","ɾ�����ʲ�����ϸ����"      
     rollback tran      
     return     
    end    
            
    delete from SF_HJCFMXK_FZ  where cfxh=@cfxh and exists (select 1 from #tjcltmp b where pcxh=b.wzpcxh and txm=b.wztxm)  
    if @@ERROR<>0  
     begin  
     select "F","ɾ������������ϸ����"      
     rollback tran      
     return     
    end    
   end  
    
  end    
    
   if exists (select 1 from SF_HJCFMXK where ypdm = @ypdm and lcxmdm=@lcxmdm_temp and cfxh =@cfxh )  
   begin  
   select @mxxh = max(xh) from SF_HJCFMXK where ypdm = @ypdm and lcxmdm=@lcxmdm_temp and cfxh in(select xh from SF_HJCFK where patid =@patid and jlzt =0 and zjbz=3)  
   update SF_HJCFMXK set ypsl = (select sum(sl) from #tjcltmp where ypdm = @ypdm and lcxmdm=@lcxmdm_temp and (@configK100<>'��' or (@configK100='��' and ysdm=@ysdm  and (@configK094<>'��' or (@configK094='��' and cftszddm=@cftszddm)))) group by xmdm,lcxmdm),
  
                        memo =(select memo from #tjcltmp where ypdm = @ypdm and lcxmdm=@lcxmdm_temp and (@configK100<>'��' or (@configK100='��' and ysdm=@ysdm and (@configK094<>'��' or (@configK094='��' and cftszddm=@cftszddm)))))  
   where xh = @mxxh  
   
	if @@ERROR<>0  -- add by yzy 20191111
	begin
	   select "F","���´�����ϸ����"    
	   rollback tran    
	   return   
	end 
  end  
  else  
  begin 
    if @isejk=0
    begin 
	   insert into SF_HJCFMXK (cfxh,cd_idm,gg_idm,dxmdm,ypdm,ypdw,ypxs,ykxs,ypfj,ylsj,    
	   ypjl,dwlb,ts,ypsl,cfts,shbz,zbz,lcxmdm,clbz,ybspbz,ypmc,memo)    
	   select @cfxh,0,0,dxmdm,xmdm,xmdw,1,1,xmdj,xmdj,    
	   0,0,1,sl,1,0,0,@lcxmdm_temp,0,0,xmmc,memo from #tjcltmp   
	   where xmdm = @ypdm AND lcxmdm=@lcxmdm_temp and (@configK100<>'��' or (@configK100='��' and ysdm=@ysdm and (@configK094<>'��' or (@configK094='��' and cftszddm=@cftszddm))))  
    end
    else
    begin
       insert into SF_HJCFMXK (cfxh,cd_idm,gg_idm,dxmdm,ypdm,ypdw,ypxs,ykxs,ypfj,ylsj,    
	   ypjl,dwlb,ts,ypsl,cfts,shbz,zbz,lcxmdm,clbz,ybspbz,ypmc,memo, wzdm,wzkfdm,wzpcxh,tm,ctxm)    
	   select @cfxh,0,0,dxmdm,xmdm,xmdw,1,1,xmdj,xmdj,    
	   0,0,1,sl,1,0,0,@lcxmdm_temp,0,0,xmmc,memo,wzdm,wzkfdm,wzpcxh,wztxm,wzctxm from #tjcltmp   
	   where xmdm = @ypdm AND lcxmdm=@lcxmdm_temp and (@configK100<>'��' or (@configK100='��' and ysdm=@ysdm and (@configK094<>'��' or (@configK094='��' and cftszddm=@cftszddm))))  
    end  
       select @mxxh=IDENT_CURRENT('SF_HJCFMXK')  
   if @@rowcount=0 and @@error<>0      
   begin      
    select "F","���뻮�۴�����ϸ����"      
    rollback tran      
    return      
   end        
    
   if isnull(@cwzpcxh,0)>0  and @isejk=0
   begin  
    insert into SF_HJCFMXK_FZ(cfxh,mxxh,xxh,wzmc,ggxh,pcxh,wzdw,ph,sxrq,txm,fzxh)  
    select @cfxh,@mxxh,b.xxh,b.wzmc,b.ggxh,@cwzpcxh,b.zxdw,b.ph,b.xq,b.txm,0   
    from #tjcltmp a,VW_WZ_CLDYXM_KSK b(nolock)  
    where a.xmdm=@ypdm and  lcxmdm=@lcxmdm_temp and a.xmdm=b.xmdm and (b.txm=@cwztxm or ISNULL(@cwztxm,'')='') and b.kfdm=@cwzkfdm and b.pcxh=@cwzpcxh  
     and (@configK100<>'��' or (@configK100='��' and ysdm=@ysdm and (@configK094<>'��' or (@configK094='��' and cftszddm=@cftszddm))))  
    if @@rowcount=0 and @@error<>0      
    begin      
     select "F","���뻮�۴���������ϸ����"      
     rollback tran      
     return      
    end     
     
    insert into YY_MZ_CLJLK(patid, hjcfxh,hjmxxh,qqlb,czy,ksdm,xmdm,sfsl,lrrq,jlzt,fzxh,lcxmdm)  
    select @patid,@cfxh,@mxxh,0,@czyh,@ksdm,@ypdm,a.sl,@lrrq,0,0,0  
    from #tjcltmp a  
    where a.xmdm=@ypdm and  a.lcxmdm=@lcxmdm_temp  and (@configK100<>'��' or (@configK100='��' and ysdm=@ysdm and (@configK094<>'��' or (@configK094='��' and cftszddm=@cftszddm))))  
      
    select @jlxh=IDENT_CURRENT('YY_MZ_CLJLK')  
    if @@rowcount=0 and @@error<>0      
    begin      
     select "F","������ϼ�¼���������"      
     rollback tran      
     return      
    end    
     
    insert into YY_MZ_CLJLK_MX(jlxh,wzpcxh,wzsl,txm,kfdm)  
    select @jlxh,@cwzpcxh,a.sl,b.txm,@wzkfdm  
    from #tjcltmp a,VW_WZ_CLDYXM_KSK b(nolock)  
    where a.xmdm=@ypdm and  lcxmdm=@lcxmdm_temp and a.xmdm=b.xmdm and (b.txm=@cwztxm or ISNULL(@cwztxm,'')='') and b.kfdm=@cwzkfdm and b.pcxh=@cwzpcxh  
     and (@configK100<>'��' or (@configK100='��' and ysdm=@ysdm and (@configK094<>'��' or (@configK094='��' and cftszddm=@cftszddm))))  
    if @@rowcount=0 and @@error<>0      
    begin      
     select "F","������ϼ�¼����ϸ����"      
     rollback tran      
     return      
    end    
   end  
  end   
  fetch authors_cursor into @ypdm,@cdxmdm,@lcxmdm_temp,@cwztxm,@cwzpcxh,@cwzkfdm,@ysdm,@ksdm,@cftszddm,@cwzdm,@cwzctxm    
 end  
 close authors_cursor  
 deallocate authors_cursor   
 commit tran     
 end  
 select "T"      
 return     
 end    
 go
