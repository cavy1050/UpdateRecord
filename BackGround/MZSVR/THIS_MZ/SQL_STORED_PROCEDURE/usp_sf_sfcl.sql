CREATE proc usp_sf_sfcl --�շѴ�����  
 @wkdz varchar(32),  
 @jszt smallint,  
 @sfbz smallint,  
 @sflb smallint,  
 @czksfbz  int,     
 @qrbz ut_bz,  
 @patid ut_xh12,  
 @sjh ut_sjh,  
 @czyh ut_czyh,  
 @ksdm ut_ksdm,  
 @ysdm ut_czyh,  
 @sfksdm ut_ksdm,  
 @yfdm ut_ksdm,  
 @sfckdm ut_dm2,  
 @pyckdm ut_dm2,  
 @fyckdm ut_dm2,  
 @ybdm ut_ybdm,  
 @cfxh int,  
 @hjxh ut_xh12,  
 @cflx ut_bz,  
 @sycfbz ut_bz,  
 @tscfbz ut_bz,  
 @dxmdm ut_kmdm,  
 @xxmdm ut_xmdm,  
 @idm ut_xh9,  
 @ypdw ut_unit,  
 @dwxs ut_dwxs,  
 @fysl ut_sl10,  
 @cfts integer,  
 @ypdj ut_money,  
 @ghsjh ut_sjh = null,  
 @ghxh ut_xh12 = null,  
 @tcljje numeric(12,2) = 0,  
 @shbz ut_bz = 0,  
 @zph varchar(32) = null,  
 @zpje numeric(12,2) = null,  
 @zhbz ut_zhbz = null,  
 @zddm ut_zddm = null,  
 @zxlsh ut_lsh = null,  
 @jslsh ut_lsh = null,  
 @xmlb ut_dm2 = null,  
 @qfdnzhzfje numeric(12,2) = null,  
 @qflnzhzfje numeric(12,2) = null,  
 @qfxjzfje numeric(12,2) = null,  
 @tclnzhzfje numeric(12,2) = null,  
 @tcxjzfje numeric(12,2) = null,  
 @tczfje numeric(12,2) = null,  
 @fjlnzhzfje numeric(12,2) = null,  
 @fjxjzfje numeric(12,2) = null,  
 @dffjzfje numeric(12,2) = null,  
 @dnzhye numeric(12,2) = null,  
 @lnzhye numeric(12,2) = null,  
 @qkbz smallint = 0,  
 @jsrq ut_rq16 = ''  
 ,@ylcardno ut_cardno=''  
 ,@ylkje ut_money=0  
 ,@ylkhcysje ut_money=0  
 ,@ylksqxh ut_lsh=''  
 ,@ylkzxlsh ut_lsh=''  
 ,@ylkhcyssqxh ut_lsh=''  
 ,@ylkhcyszxlsh ut_lsh=''  
 ,@yhdj ut_money=0   --add by chenwei 2003.12.06   
 ,@ypmc ut_mc64=''  
 ,@lcxmdm ut_xmdm='0'                    --agg 2004.07.09    
 ,@hjmxxh ut_xh12='0'   --zwj 2005.6.16  
    ,@lcxmsl numeric(12,4)=0 --add by ctg at 2006.11.22 ������lcxmsl  
 ,@dfpzhzfje ut_money =0 --add wuwei 2011-06-08 ���෢Ʊ�Ѿ�ʹ�õ�zhzfje���������ж� for bug 95182  
 ,@fybz  ut_bz=0  --�Է�תҽ��ʱ,ԭ��¼��fybz  
 ,@yjqrbz ut_bz=0  --�Է�תҽ��ʱ,ԭ��¼��yjqrbz  
 ,@yjclfbz ut_bz=0  --ҽ�����Ϸѱ�־  
 ,@yhdm ut_ybdm='0'--�Ż����ʹ���  
 ,@tbzddm ut_mc32=''--�ز���ϴ���    
 ,@tbzdmc ut_mc32=''--�ز��������    
 ,@yhyy varchar(12)='' -- ZY_YHFSK.id  add kcs 20151102  
 ,@kfsdm      ut_ybdm=''  
    
   
as --��51409 2019-04-24 14:44:30 4.0��׼��_201810����  
/***********  
[�汾��]4.0.0.0.0  
[����ʱ��]2004.10.25  
[����]����  
[��Ȩ] Copyright ? 2004-2008�Ϻ����˴�-��������ɷ����޹�˾[����]�շѴ���  
[����˵��]  
 �շѴ�����  
[����˵��]  
 @wkdz varchar(32), ������ַ  
 @jszt smallint,  ����״̬ 1=������2=���룬3=�ݽ�  
 @sfbz smallint,  �շѱ�־0=Ԥ�㣬1=�ݽ�(����1), 2=��ʽ�ݽ�(����2)  
 @sflb smallint,  �շ����1=��ͨ��2=����  
 @czksfbz  int    ��ֵ���շѱ�־�� 0 :���ӳ�ֵ���շ�  ��1 �ӳ�ֵ���շ� add by szj  
 @qrbz ut_bz,  ȷ�ϱ�־0=��ͨ��1=����(ҽ���շ���)  
 @patid ut_xh12,  ����Ψһ��ʶ  
   @sjh ut_sjh,  �վݺ�  
 @czyh ut_czyh,  ����Ա��  
   @ksdm ut_ksdm,  ���Ҵ���  
   @ysdm ut_czyh,  ҽ������  
 @sfksdm ut_ksdm, �շѿ��Ҵ���  
 @yfdm ut_ksdm,  ҩ������  
 @sfckdm ut_dm2,  �շѴ��ڴ���  
 @pyckdm ut_dm2,  ��ҩ���ڴ���  
 @fyckdm ut_dm2,  ��ҩ���ڴ���  
 @ybdm ut_ybdm,  ҽ������  
 @cfxh int,   �������  
 @hjxh ut_xh12,  �������  
 @cflx ut_bz,  �������1:��ҩ����,2:��ҩ����,3:��ҩ����,4:���ƴ���  
 @sycfbz ut_bz,  ��Һ������־0:��ͨ������1:��Һ����  
 @tscfbz ut_bz,  ���⴦����־0:��ͨ������1:��֢����  
 @dxmdm ut_kmdm,  ����Ŀ����  
 @xxmdm ut_xmdm,  С��Ŀ���루ҩƷ���룩  
 @idm ut_xh9,  ����idm  
 @ypdw ut_unit,  ҩƷ��λ  
 @dwxs ut_dwxs,  ��λϵ��  
 @fysl ut_sl10,  ��ҩ����  
 @cfts integer,  ��������  
 @ypdj ut_money,  ҩƷ����  
 @ghsjh ut_sjh = null,  �Һ��վݺ�  
 @ghxh ut_xh12 = null,  �Һ����  
 @tcljje numeric(12,2) = 0, ͳ���ۼƽ��(�½��ػ���)  
 @shbz ut_bz = 0,  ��˱�־ 0 �������,1 ���,2 ��˲�ͨ��  
 @zph varchar(32) = null, ֧Ʊ��  
 @zpje numeric(12,2) = null, ֧Ʊ���  
 @zhbz ut_zhbz = null,  �˻���־   
 @zddm ut_zddm = null,  ��ϴ���  
 @zxlsh ut_lsh = null,  ������ˮ��  
 @jslsh ut_lsh = null,  ������ˮ��  
 @xmlb ut_dm2 = null,  ����Ŀ  
 @qfdnzhzfje numeric(12,2) = null,  �𸶶ε����˻�֧��  
 @qflnzhzfje numeric(12,2) = null, �𸶶������ʻ�֧��  
 @qfxjzfje numeric(12,2) = null,  �𸶶��ֽ�֧��  
 @tclnzhzfje numeric(12,2) = null, ͳ��������ʻ�֧��  
 @tcxjzfje numeric(12,2) = null,  ͳ����ֽ�֧��  
 @tczfje numeric(12,2) = null,  ͳ���ͳ��֧��  
 @fjlnzhzfje numeric(12,2) = null, ���Ӷ������ʻ�֧��  
 @fjxjzfje numeric(12,2) = null,  ���Ӷ�����֧��  
 @dffjzfje numeric(12,2) = null  ���Ӷεط�����֧��  
 @dnzhye numeric(12,2) = null,  �����˻����  
 @lnzhye numeric(12,2) = null,  �����˻����  
 @qkbz smallint = 0     Ƿ���־0��������2��Ƿ��  
 @jsrq ut_rq16 = ''     ��������  
 @lcxmdm ut_xmdm='0'                     �ٴ���Ŀ����  
 @hjmxxh ut_xh12='0'   ������ϸ���  
    @lcxmsl numeric(12,4)=0 --add by ctg at 2006.11.22 ������lcxmsl  
[����ֵ]  
[�����������]  
[���õ�sp]  
 usp_sf_getsfpck --ȡ�շѴ��ڶ�Ӧ���䡢��ҩ����  
[����ʵ��]  
[�޸�˵��]  
Modify By Koala 2003.02.13 for ��������ҽԺ   
 ���Ӽ����շѵķ�ҩ���ڴ����������Ϊ����ָ����ҩ���ڵģ��򽫷�ҩ��������ΪYY_CONFIG�����õķ�ҩ����  
  
Modify by qxh  2003.2.27    
 ���Ӱ�������ӡ��Ʊ�Ĵ���   
  
Modify by Koala  2003.03.11 for ����ҽԺ    
 ����ʵʱҽ�����˵���ҩ������סԺ��������  
  
tony 2003.8.21 �޸���ҽ�������Ը�����  
  
zwj 2003.09.09  ҽ�������޸�  
  ҩƷ��񱣴淽ʽ��������  
tony 2003.12.8 С����ҽ���޸�  
  
Modify by chenwei  2003.12.06 ����  
 �Żݴ������ɴ���  
modify by szj  2004.02.18 ��ֵ����Ҫ�ṩ��  
 ��ſ����շ������@czksfbz �����������Ƿ�ӳ�ֵ���Ͽ�Ǯ  
modify by agg   2004.07.09 ���Ӷ��ٴ���Ŀ��֧��  
yxp 2004-11-18 ���洦��ʱ����ʱû�б�����ȷ��yfdm��cflx���������жϣ��緢��yfdm��cflx����ȷʱ����ʾ  
zwj 20050616 ���ӻ�����ϸ��ŵĴ���  
ozb 20060321 ���Ӷ���ҩ��Ĵ���  
sunyu 20061206 ���Ӱ������˲��Ʒ����Ը����Ĵ���  
yxp 2007-5-15 ����3096����Ϊ��ʱ��������粡�˿�����Ŀ�����������ٿ�ҩƷ����ʱ�����䴰�ڻ�ȡ�������Ĵ��ڣ�����3096����ʵ�������޸�usp_sf_sfcl.sql��usp_sf_getsfpck.sql���������3096���ܸ���getsfpck��ͳһʵ��  
wfy 2007-5-18 ������2130���ô�����ǰ����Ҳ�ǰ����ﴦ����   
ozb 2007-07-02 ȡ�շ��䴰��ʱ�����Ӹ��ݷ�����Ϣ�ж��Ƿ�ɹ�  
ozb 2008-06-12 �޸���������Ĵ���  
**********/  
set nocount on  
  
---by dingsong ��������sfksdm��Ĭ��  
if(len(@sfksdm)=0) begin select @sfksdm=case when len(@ksdm)=0 then (select top 1 ks_id from YY_ZGBMK where id=@czyh) else @ksdm end end  
--by dingsong ������������������ҽ���ٴ��޸ı�����´����⻮�ۿ����ݲ�ƥ�䣬д�봦����ʱ������������Ϣ  
if(@czyh in ('999999','9999A9'))  
begin  
update SF_HJCFK set jlzt=5 where xh = @hjxh and jlzt=0  
end  
  
declare @config2490  varchar(5),  
  @config2491  varchar(5),  
  @config2490_js varchar(5), --��ͯ�Ƿ����  
  @etnl   varchar(5), --��ͯ����  
  @etbirth  varchar(10),--��ͯ��������  
  @nowdate  varchar(10),  
  @jsksdm   varchar(8), --��ͯ���տ��Ҵ���  
  @ghxhtmp  ut_xh12  
select @config2490=config from YY_CONFIG where id='2490'  
select @config2491=config from YY_CONFIG where id='2491'  
select @config2490_js='',@etbirth='',@nowdate='',@etnl='',@jsksdm=''  
if @config2490>'0'  
begin  
 select @etbirth=birth from SF_BRXXK where patid=@patid  
 select @nowdate=convert(char(8),getdate(),112)  
 select @etnl=DATEDIFF( YEAR, @etbirth, @nowdate)  
 if cast(@etnl as int)<=cast(@config2490 as int)  
  set @config2490_js='��'  
end  
--���ɵݽ�����ʱ��  
declare @tablename varchar(32)  
declare @newfyckdm ut_dm2,  
  @acfdfp ut_bz,       --�Ƿ񰴴�����Ʊ 0 ���ǣ� 1   
  @bkybdmjh varchar(255),  --�������뼯��config0102  
  @mjzsybz varchar(20)  
declare @outmsg varchar(200)  
exec usp_yy_ldjzq @outmsg output  
if substring(@outmsg,1,1)='F'  
begin  
 select 'F',substring(@outmsg,2,200)  
 return  
end    
if (select config from YY_CONFIG (nolock) where id='2044')='��'  
 set @acfdfp=0  
else  
 set @acfdfp=1  
   
/*add by zkh for xq 179616*********************************begin*/  
--���洦���Һ��Ƿ���ҽ����������Ӧ�ĹҺ���ű���  
if (select config from YY_CONFIG (nolock) where id='2505')='��' AND isnull(@hjxh,0) <> 0  
BEGIN  
 SELECT @ghxh=ghxh FROM SF_HJCFK (NOLOCK) WHERE xh=@hjxh  
 --modified for bug 31599  
 select @ghsjh = jssjh from GH_GHZDK where xh = @ghxh  
END   
/*add by zkh for xq 179616*********************************end*/   
  
select @bkybdmjh=config from YY_CONFIG (nolock) where id='0102'  
  
select @tablename='##mzsf'+@wkdz+@czyh  
  
if @jszt=1  --������  
begin  
 exec('if exists(select * from tempdb..sysobjects where name="'+@tablename+'")  
  drop table '+@tablename)  
 exec('create table '+@tablename+'(  
  xh ut_xh12 identity(1,1) not null,  
  ksdm ut_ksdm not null,  
  ysdm ut_czyh not null,  
  yfdm ut_ksdm not null,  
  cfxh int not null,  
  hjxh ut_xh12 null,  
  cflx ut_bz not null,  
  sycfbz ut_bz not null,  
  tscfbz ut_bz not null,  
  cfts int not null,  
  dxmdm ut_kmdm not null,  
  xxmdm ut_xmdm not null,  
  idm ut_xh9 not null,  
  ypdw ut_unit null,  
  dwxs ut_dwxs not null,  
  fysl ut_sl10 not null,  
  ypdj ut_money null,  
  pyckdm ut_dm2 null,  
  fyckdm ut_dm2 null,  
  shbz ut_bz null,  
  yhdj ut_money null,  
  ypmc ut_mc64 null,  
        lcxmdm ut_xmdm null,  
  lcxmmc ut_mc32 null,  
  zbz  ut_bz null,  
  hjmxxh ut_xh12 null ,  
  lcxmsl numeric(12,4) null,  
  fybz ut_bz null,  
  yjqrbz ut_bz null,  
  yjclfbz ut_bz null,  
  wsbz    ut_bz null,  
        wsts    ut_sl10 null,  
        tbzddm  ut_mc32 null,  
        tbzdmc  ut_zdmc null,  
     ghxh ut_xh12 null  
  )')  --agg 2004.07.09 ����lcxmdm,lcxmmc,zbz  
 if @@error<>0  
 begin  
  select "F","������ʱ��ʱ����"  
  return  
 end  
  
 select "T"  
 return  
end  
--����ݽ��ļ�¼  
if @jszt=2  
begin  
  
 declare @ccfxh varchar(8),  
  @chjxh varchar(12),  
  @ccflx varchar(2),  
  @csycfbz varchar(2),  
  @ctscfbz varchar(2),  
  @ccfts varchar(8),  
  @cidm varchar(9),  
  @cdwxs varchar(9),  
  @cfysl varchar(12),  
  @cypdj varchar(12),  
  @cshbz varchar(2),  
  @cyhdj varchar(12),  
  @cypmc varchar(64),  
  @clcxmmc varchar(32),  --agg 2004.07.09  
  @zbz ut_bz,             --agg 2004.07.09   
  @zxmdm ut_xmdm,         --agg 2004.07.09  
  @chjmxxh varchar(12),  
  @cfybz  varchar(2),  --�Է�תҽ��ʱ�õ���fybz  
  @cyjclfbz varchar(2),  
  @err_cfxx varchar(256),--���󴦷���Ϣ  
  @czbz varchar(5),  
  @clcxmsl varchar(20),  
  @cyjqrbz varchar(5),  
  @cghxh  varchar(12)  
    
 select @ccfxh=convert(varchar(8),@cfxh),  
  @chjxh=convert(varchar(12),@hjxh),  
  @ccflx=convert(varchar(2),@cflx),  
  @csycfbz=convert(varchar(2),@sycfbz),  
  @ctscfbz=convert(varchar(2),@tscfbz),  
  @ccfts=convert(varchar(8),@cfts),  
  @cidm=convert(varchar(9),@idm),  
  @cdwxs=convert(varchar(9),@dwxs),  
  @cfysl=convert(varchar(12),@fysl),  
  @cypdj=convert(varchar(12),@ypdj,2),  
  @cshbz=convert(varchar(2),@shbz),  
  @cyhdj=convert(varchar(12),@yhdj,2),  
  @cypmc=convert(varchar(64),@ypmc),  
  @chjmxxh=convert(varchar(12),@hjmxxh),  
  @cfybz=convert(varchar(2),@fybz),  
  @cyjclfbz=convert(varchar(2),@yjclfbz),  
  @err_cfxx=''  
    
  ,@clcxmsl=convert(varchar(12),@lcxmsl)   
  ,@cyjqrbz =convert(varchar(5),@yjqrbz)  
  ,@cghxh =convert(varchar(12),isnull(@ghxh,0))   
  , @czbz =convert(varchar,@zbz)  
  
  --agg 2004.07.09 ȡlcxmmc begin  
 if @lcxmdm='' select @lcxmdm='0'   
  
 if @lcxmdm='0'  
 begin  
   select @clcxmmc=''  
   select @czbz='0'  
 end  
 else begin   
  select @clcxmmc=name,@zxmdm=zxmdm from YY_LCSFXMK where id=@lcxmdm  
  if @xxmdm=@zxmdm   
   select @czbz='0'  
  else   
   select @czbz='1'   
 end  
  select @clcxmmc=name from YY_LCSFXMK where id=@lcxmdm  
  --agg 2004.07.09 ȡlcxmmc end  
  
 select @pyckdm='', @fyckdm=''  
   
   
 --add h_ww 20150305 for 14182 �жϰ��ﴦ����־(alcfbz),�������ת��������Ĵ������������շ�  
 if exists(select 1 from SF_HJCFK(nolock) where xh=@chjxh and ISNULL(alcfbz,0)<>0)  
 begin  
  select @err_cfxx="����ת��������Ĵ���,�����շѣ�������="+  @chjxh + ";��ϸ��Ϣ:"  
  select @err_cfxx = @err_cfxx + +char(13)+char(10)+ "����("+ ypmc +")"  
   from SF_HJCFMXK(nolock) where cfxh=@chjxh   
       
  select "F",@err_cfxx  
  return  
 end  
 --��Ŀ�����ҩƷidm��δ����ʱ�������ύ����������������  
 if @xxmdm='' and @cidm='0'  
 begin  
  select "T"  
  return  
 end  
  
  
 exec ('insert into '+@tablename+' values("'+@ksdm+'","'+@ysdm+'","'+@yfdm+'",'+@ccfxh+','  
  +@chjxh+','+@ccflx+','+@csycfbz+','+@ctscfbz+','+@ccfts+',"'+@dxmdm+'","'+@xxmdm+'",'  
  +@cidm+',"'+@ypdw+'",'+@cdwxs+','+@cfysl+','+@cypdj+',"'+@pyckdm+'","'+@fyckdm+'",' + @cshbz +','  
  +@cyhdj+',"'+@cypmc+'"'+',"'+@lcxmdm+'"'+',"'+@clcxmmc+'",'+@czbz+','+@chjmxxh+','+@clcxmsl+','  
  +@cfybz + ',' + @cyjqrbz + ',' + @cyjclfbz + ',0,0,"'+@tbzddm+'","'+@tbzdmc+'","'+@cghxh+'")')  --agg 2004.07.09 ����lcxmcm,lcxmmc,zbz    
    
 if @@error<>0  
 begin  
  select "F","������ʱ��ʱ����2��"  
  return  
 end  
  
 select "T"  
 return  
end  
  
declare @now ut_rq16,  --��ǰʱ��  
  @zfbz smallint,  --������־  
  @rowcount int,  
  @error int,  
  @zje ut_money,  --ҩ���ܽ��  
  @zje1 ut_money,  --��ҩ���ܽ��  
  @zfyje ut_money, --�Է�ҩ�ѽ��  
  @zfyje1 ut_money, --�Էѷ�ҩ�ѽ��  
  @yhje ut_money,  --�Ż�ҩ�ѽ��  
  @yhje1 ut_money, --�Żݷ�ҩ�ѽ��  
  @ybje ut_money,  --������ҽ�������ҩ�ѽ��  
  @ybje1 ut_money, --������ҽ������ķ�ҩ�ѽ��  
  @flzfje ut_money, --�����Ը����(ҩƷ)  
  @flzfje1 ut_money, --�����Ը����(��ҩƷ)  
  @flzfjedbxm ut_money, --�����Ը����(�󲡷�Χ��Ŀ)  
  @pzlx ut_dm2,  --ƾ֤����  
  @sfje ut_money,  --ʵ�ս��(ҩƷ)  
  @sfje1 ut_money, --ʵ�ս��(��ҩƷ)  
  @sfje_all ut_money, --ʵ�ս��(�����Էѽ��)  
  @errmsg varchar(50),  
  @srbz char(1),  --�����־  
  @srje ut_money,  --������  
  @sfje2 ut_money, --������ʵ�ս��  
  @xhtemp ut_xh12,  
  @ksmc ut_mc32,  --��������  
  @ysmc ut_mc32,  --ҽ������  
--  @xmzfbl float,  --ҩƷ�Ը�����  
--  @xmzfbl1 float,  --��ҩƷ�Ը�����  
  @xmzfbl numeric(12,4),    
  @xmzfbl1 numeric(12,4), --mit ,, 2oo3-o7-28 ,,float�Ļ���������������   
  @xmce ut_money,  --�Ը����ʹ����Ը������ܵĲ��  
  @fplx smallint,  --��Ʊ����  
  @fph bigint,   --��Ʊ��  
  @fpjxh ut_xh12,  --��Ʊ�����  
  @print smallint, --�Ƿ��ӡ0��ӡ��1����  
  @pzh ut_pzh,  --ƾ֤��  
  @brlx ut_dm2,  --��������  
  @qkbz1 smallint, --Ƿ���־0��������1�����ˣ�2��Ƿ��  
  @zhje ut_money,  --�˻����  
  @qkje ut_money,  --Ƿ������˽�  
  @jsfs ut_bz,  --���㷽ʽ  
  @mjzbz ut_bz,  --�ż����־  
         @zfje  ut_money,  
         @zjecf ut_money,  
  @zfyjecf ut_money,  
         @yhjecf  ut_money,  
  @ekbz ut_bz,  --���Ʊ�־  
    @nl int, --�չ˲�����������  
  @csybdm varchar(255),  
  @sqdxh ut_xh12,   
  @ejygbz ut_bz,  --����ҩ���־ add by ozb 20060320   
  @ejygksdm ut_ksdm --����ҩ����Ҵ��� add by sunyu 2006-03-24   
  ,@qkbz2  ut_bz  
  ,@yydjje ut_money  --ԤԼ������  
  ,@ybjkid ut_bz  
  ,@sfly   ut_bz --add by yxc �շ���Դ  
  ,@config2366 varchar(128)  
  ,@config2367 varchar(128)  
  ,@yscfbz ut_bz  --���촦����־  
  ,@ccfbz ut_bz   --��������־  
  ,@config2394 varchar(10)  
  ,@config2157 varchar(10)  
  ,@hjmxts int  
  ,@sfmxts int  
  ,@config2395 varchar(500)  
  ,@config2466 varchar(10)  
declare @brnl integer ,   --��������  
   @zcbz ut_bz,    
   @pyzc ut_dm2,    
   @fyzc ut_dm2    
  
  
declare @ybzje ut_money, --ҽ�����׷����ܶ�  
 @ybjszje ut_money, --ҽ�����㷶Χ�����ܶ�  
 @ybzlf ut_money, --���Ʒ�  
 @ybssf ut_money, --�������Ϸ�  
 @ybjcf ut_money, --����  
 @ybhyf ut_money, --�����  
 @ybspf ut_money, --��Ƭ��  
 @ybtsf ut_money, --͸�ӷ�  
 @ybxyf ut_money, --��ҩ��  
 @ybzyf ut_money, --�г�ҩ��  
 @ybcyf ut_money, --�в�ҩ��  
 @ybqtf ut_money, --������  
 @ybgrzf ut_money, --��ҽ�����㷶Χ�����Է�  
 @yjbz ut_bz,  --�Ƿ�ʹ�ó�ֵ��  
 @yjye ut_money,  --Ԥ�������  
 @yjzfje ut_money, --Ԥ����֧�����  
 @yjyebz varchar(2), --��ֵ�������Ƿ���������շ�  
 @ypggbz varchar(2), --�Ƿ�ʹ��ҩƷ���  
 @djje ut_money,  --������  
 @tcljbz ut_bz,  --ͳ���ۼƱ�־  
 @tcljje1 ut_money, --ͳ���ۼƽ��򱣡��½��ػ�ʹ�ã�   
 @qkje2 ut_money,  --������� ������λС��  
 @sfje_bkall ut_money, --����ʵ�ս��(�����Էѽ��)  
 @lcyhje ut_money, -- ����Żݽ��  
 @hjcfjlzt ut_bz,  
 @jfbz varchar(2),  
 @jfje ut_money,  
 @wsbz ut_bz,  --���ʹ�����־  
 @wsts ut_sl10  --���ʹ�������  
--��Ա�������޸��������� zwj 2006.12.12  
declare @hykmsbz ut_bz  --��Ա��ģʽ��־  
 ,@hysybz ut_bz  --��Աʹ�ñ�־(YY_YBFLK��hysybz)  
 ,@tjmfbz ut_bz  --����շѱ�ʾ����Ա����¼��������  
    ,@ylxzbh ut_xh9     --ҽ������  
 ,@gsbz ut_bz  --��ʧ��־  
declare @config2206 varchar(50)  
  ,@vipyxe ut_money  
  ,@vipfylj ut_money  
  ,@config2422   varchar(10) --2422��ҩƷ���᷽��  
select @now=convert(char(8),getdate(),112)+convert(char(8),getdate(),8),  
 @zje=0, @zfyje=0, @yhje=0, @ybje=0,  
 @zje1=0, @zfyje1=0, @yhje1=0, @ybje1=0,  
 @sfje=0, @sfje1=0, @sfje_all=0, @srje=0, @sfje2=0,   
 @xmzfbl=0, @xmzfbl1=0, @xmce=0, @print=0, @fplx=0,@flzfjedbxm=0,  
 @qkbz1=0, @qkje=0, @mjzbz=1, @jsfs=0, @ekbz=0,  
 @flzfje=0, @flzfje1=0, @tcljbz=0, @tcljje1=0, @hykmsbz=0, @tjmfbz=0  
 ,@lcyhje = 0,@jfbz = '0',@jfje = 0,@hjmxts = 0,@sfmxts = 0  
select  @ybzje=0, @ybjszje=0, @ybzlf=0, @ybssf=0,  
 @ybjcf=0, @ybhyf=0, @ybspf=0, @ybtsf=0,  
 @ybxyf=0, @ybzyf=0, @ybcyf=0, @ybqtf=0,  
 @ybgrzf=0, @yjbz=0, @yjye=0, @yjzfje=0,@yydjje = 0,  
 @hjcfjlzt=0  
 ,@ylxzbh=0  
declare @config2297 varchar(128)  
if exists(select 1 from YY_CONFIG where id='2297')  
    select @config2297=rtrim(config) from YY_CONFIG where id='2297'  
else  
    select @config2297=''  
  
if exists(select 1 from YY_CONFIG where id='2366')  
    select @config2366=rtrim(config) from YY_CONFIG where id='2366'  
else  
    select @config2366=''  
  
if exists(select 1 from YY_CONFIG where id='2367')  
    select @config2367=rtrim(config) from YY_CONFIG where id='2367'  
else  
    select @config2367=''  
  
if exists(select 1 from YY_CONFIG where id='2394')  
    select @config2394=rtrim(config) from YY_CONFIG where id='2394'  
else  
    select @config2394='��'  
      
 if exists(select 1 from YY_CONFIG where id='2157')  
    select @config2157 =rtrim(config) from YY_CONFIG where id='2157'  
else  
   select @config2157 ='��'     
     
if exists (select 1 from YY_CONFIG(nolock) where id='2395')  
    select @config2395=isnull(config,'') from YY_CONFIG(nolock) where id='2395'  
else  
    select  @config2395=''  
if exists (select 1 from YY_CONFIG(nolock) where id='2101' and config='��')  
    and exists (select 1 from YY_CONFIG(nolock) where id='2422' and config='��')  
begin  
    select 'F','ҩƷ���᷽��ֻ�ܶ�ѡһ,��ǰ������2101,2422�����ö�Ϊ��,���޸�����!'  
    return  
end  
select @config2466=config from YY_CONFIG(nolock) where id='2466'   
if exists(select 1 from YY_CONFIG where id='2422')  
    select @config2422=config from YY_CONFIG(nolock) where id='2422'  
else  
    select @config2422 ='��'   
--{TODO -oyfq -c2016-12 : ҽ���߼�ҩ���߸��� as @#$ begin}  
declare @config2451 char(2)  
 ,@gjybz ut_bz  
 ,@gjyzje ut_money  
 ,@gjyzfje ut_money  
 ,@gjyzje1 ut_money  
 ,@gjyzfje1 ut_money  
if exists (select 1 from YY_CONFIG where id='2451' and config='��')  
    select @config2451='��'  
else  
    select @config2451='��'  
select @gjybz=0,@gjyzje=0,@gjyzfje=0,@gjyzje1=0,@gjyzfje1=0  
--{TODO -oyfq -c2016-12 : ҽ���߼�ҩ���߸��� as @#$ end}   
--�շ�Ԥ��  
if @sfbz=0  
begin  
 --��ʼ�����˵�����ϸ��Ĵ�������  
 create table #mzsftmp  
 (  
  xh ut_xh12 not null,  
  ksdm ut_ksdm not null,  
  ysdm ut_czyh not null,  
  yfdm ut_ksdm not null,  
  cfxh int not null,  
  hjxh ut_xh12 null,  
  cflx ut_bz not null,  
  sycfbz ut_bz not null,  
  tscfbz ut_bz not null,  
  cfts int not null,  
  dxmdm ut_kmdm not null,  
  xxmdm ut_xmdm not null,  
  idm ut_xh9 not null,  
  ypdw ut_unit null,  
  dwxs ut_dwxs not null,  
  fysl ut_sl10 not null,  
  ypdj ut_money null,  
  pyckdm ut_dm2 null,  
  fyckdm ut_dm2 null,  
  shbz ut_bz null,  
  yhdj ut_money null,  
  ypmc ut_mc64 null,  
  lcxmdm ut_xmdm null,  --agg 2004.07.09    
  lcxmmc ut_mc32 null,  --agg 2004.07.09   
  zbz ut_bz null,       --agg 2004.07.09  
  hjmxxh ut_xh12 null,  
  lcxmsl numeric(12,4) null,  --ctg 2006.11.24   
  fybz ut_bz null, --�Է�תҽ����  
  yjqrbz ut_bz null, --�Է�תҽ����  
  yjclfbz ut_bz null,  
  wsbz ut_bz null,  
        wsts ut_sl10 null,  
        tbzddm  ut_mc32 null,  
        tbzdmc  ut_zdmc null,  
        ghxh ut_xh12 null  
 )   
    
 exec('insert into #mzsftmp select * from '+@tablename)  
 if @@error<>0  
 begin  
  select "F","������ʱ��ʱ����3��"  
  return  
 end  
   
 exec('drop table '+@tablename)  
   
  
 --add by yangdi 2012.6.26 ������죬�����շ���ϸʱ��ӡ���ŷ�Ʊ������bug����        
 if exists (select 1 from #mzsftmp where isnull(xxmdm,'')='')        
 begin        
  delete from #mzsftmp where isnull(xxmdm,'')=''        
 end        
  
 --��ʼ�����շ���Ŀ  
 create table #sfzd  
 (  
  cfxh int not null,  
  ksdm ut_ksdm not null,  
  ysdm ut_czyh not null,  
  yfdm ut_ksdm not null,  
  hjxh ut_xh12 null,  
  cflx ut_bz not null,  
  sycfbz ut_bz not null,  
  tscfbz ut_bz not null,  
  cfts int not null,  
  pyckdm ut_dm2 null,  
  fyckdm ut_dm2 null,  
  zje    ut_money null,           
  zfyje  ut_money null,  
  yhje   ut_money null,  
  zfje   ut_money null,  
  srje   ut_money null,    
  fph    bigint null,  
  fpjxh ut_xh12   null,  
  ejygbz ut_bz null, --add by ozb 20060320 ����ҩ���־  
  ejygksdm ut_ksdm null, --add by sunyu 2006-03-24 ����ҩ����Ҵ���  
  fybz ut_bz null, --�Է�תҽ����  
  wsbz ut_bz null,  
  wsts ut_sl10 null,  
  tbzddm  ut_mc32 null,  
        tbzdmc  ut_zdmc null,  
        yscfbz ut_bz null,  
        ccfbz ut_bz null,  
        ghxh ut_xh12 null  
 )  
  
  
 --�ż����־2002.10.21 / �˶δ������Ƶ��˴����Ա�ʹ��@mjzbz 2003.02.25  
   
 select @mjzsybz = config from YY_CONFIG where id = '2130'  
 if @mjzsybz = '��'  
  select @mjzbz = @sflb  
 else  
 begin  
  select @mjzbz=mjzbz from SF_BRJSK (nolock) where sjh=@ghsjh  
  if @@rowcount=0  
   select @mjzbz=1  --���ﲡ��  
    end  
  select @nl=isnull(convert(int,config),70) from YY_CONFIG where id='2109'  
  
   select @brnl = datediff(yy,birth,substring(@now,1,8))    
    from SF_BRXXK where patid = @patid    
    
   select @zcbz = 0    
 if (@sjh='zzj' or @sjh='zzsf') select @sfly=1  
 if @sjh='yszdy' select @sfly=2  
 if @sjh='mzyj'  select @sfly=3  
 if ltrim(rtrim(@sjh))='000' select @sfly=0   
 /*�������ô�����Ӧ���䡢��ҩ����, Wang Yi 2003.02.25, begin*/  
  
/*  
 if isnull(@qrbz,0)=0  
 begin  
  create table #tmp_sfpck(  
    yfdm ut_ksdm not null  
   ,pyckdm ut_dm2 null  
   ,fyckdm ut_dm2 null  
   )  
   
  declare cr_getpfck cursor for  
   --select distinct yfdm from #mzsftmp where cflx <> 4  
   select distinct yfdm from #mzsftmp where cflx in (1,2,3) --��촦����ҽ������Ҳ����Ҫȡ��ҩ��ҩ����  
  open cr_getpfck  
  fetch cr_getpfck into @yfdm  
  while @@fetch_status = 0   
  begin  
     if @brnl >= @nl     
     begin    
       if exists (select 1 from YF_FYCKDMK  where yfdm = @yfdm and zcbz = 1 and sybz = 0 )  
         select @zcbz = 1    
       else    
         select @zcbz = 0    
     end    
     --����70����������ר������  
     if @zcbz =1     
     begin    
       select @pyckdm = id from YF_PYCKDMK     
        where yfdm = @yfdm and zcbz = 1    
     
       select @fyckdm = id  from YF_FYCKDMK     
        where yfdm = @yfdm and zcbz = 1    
     end    
     else    
     begin         
    exec usp_sf_getsfpck @sfckdm, @yfdm, @mjzbz, @fyckdm output, @pyckdm output,@patid,@errmsg output  
   end  
   if @@error <> 0   
   begin  
    deallocate cr_getpfck  
    select "F", "ȡ��Ӧ�䡢��ҩ���ڳ���"  
    return  
   end  
   --add by ozb 20070702 ���Ӹ��ݷ�����Ϣ�ж�  
   if left(@errmsg,1)<>'T'  
   begin  
    deallocate cr_getpfck  
    select "F", substring(@errmsg,2,49)  
    return  
   end  
   insert into #tmp_sfpck( yfdm, pyckdm, fyckdm) values(@yfdm, @pyckdm, @fyckdm)  
   fetch cr_getpfck into @yfdm  
  end  
   
  deallocate cr_getpfck   
   
  update #mzsftmp set pyckdm = b.pyckdm, fyckdm = b.fyckdm  
   from #mzsftmp a, #tmp_sfpck b  
   where a.yfdm = b.yfdm  
   
  ----  2005-05-17 ���ӷѱ��Ӧ��ҩ���ڣ�����з�ҩ���ڣ���isnull(@cflx,0) in (1,2,3) �Ÿ���  
  if exists (select 1 from YY_YBFLK nolock where ybdm = @ybdm and (isnull(dypyckdm,'') <> '' or isnull(dyfyckdm,'') <> ''))  
  begin  
   update #mzsftmp set pyckdm = case when isnull(b.dypyckdm,'') <> '' then b.dypyckdm else a.pyckdm end,  
    fyckdm = case when isnull(b.dyfyckdm,'') <> '' then b.dyfyckdm  else a.fyckdm end   
    from #mzsftmp a,YY_YBFLK b  
    where b.ybdm = @ybdm and isnull(a.cflx,0) in (1,2,3)  
   if @@error<>0   
   begin  
    select "F","��ȡ�ѱ��Ӧ�Ĵ���ʱ����"  
    return  
   end  
  end  
 end  
*/  
 /*�������ô�����Ӧ���䡢��ҩ����, Wang Yi 2003.02.25, end*/  
  
 /*���շѴ���������ʱ�� begin*/  
 insert into #sfzd   
 select distinct cfxh, ksdm, ysdm, yfdm, hjxh, cflx, sycfbz, tscfbz, cfts, pyckdm, fyckdm,null,null,null,null,null,0,null,0,null,  
 fybz,wsbz,wsts,tbzddm,tbzdmc,0,0,ghxh from #mzsftmp   
 where isnull(xxmdm,'')<>'' and isnull(ypmc,'')<>''  
 order by cfxh -- add by ozb ���Ӷ���ҩ���־  
 if @@error<>0 or @@rowcount=0  
 begin  
  select "F","�����շѴ���ʱ����"  
  return  
 end  
 /*���շѴ���������ʱ�� end*/  
  
 /*�ж��շ���ϸ�����Ƿ��봦����ϸ����һ�� begin*/  
 if @config2394 = '��'  or @config2157 = '��'   
 begin  
   
  declare @wkcypxx varchar(8000),  
    @kcbgts  int  --��治��������  
  select @wkcypxx = char(10)+CHAR(13)+'�޿��ҩƷ��Ϣ��'   
  select @kcbgts =0  
    
    
  select @sfmxts = count(b.xh) from #mzsftmp a,SF_HJCFMXK b(nolock) where isnull(a.hjmxxh,0) <> 0 and a.hjmxxh = b.xh  
  select @hjmxts = count(b.xh) from #sfzd a,SF_HJCFMXK b(nolock) where a.hjxh = b.cfxh and isnull(b.lcxmdm,'0')='0'  
  select @hjmxts = @hjmxts + count(c.xmdm) from #sfzd a,SF_HJCFMXK b,YY_LCSFXMDYK c(nolock) where a.hjxh = b.cfxh and isnull(b.lcxmdm,'0')<>'0' and b.lcxmdm = c.lcxmdm   
  --  
    
  select  * into #hjmxk_tmp from  SF_HJCFMXK a(nolock) where a.cfxh  in (select b.hjxh from #mzsftmp b) and a.cd_idm > 0  
  select @wkcypxx = @wkcypxx+char(10)+CHAR(13)+'  ['+a.ypmc+']'    
      from #hjmxk_tmp a left join #mzsftmp b on a.xh = b.hjmxxh and b.idm > 0  
         inner join SF_HJCFK d(nolock) on a.cfxh = d.xh  
         left join YF_YFZKC c(nolock) on  a.cd_idm = c.cd_idm  
  where d.yfdm = c.ksdm and (a.ypsl*a.ypxs*a.cfts/c.mzxs) > (c.kcsl3-c.djsl)  
  select @kcbgts = @@ROWCOUNT  
       
  if @sfmxts <> @hjmxts and @config2394='��'  
  begin  
        
   select "F","������ϸ�������շ���ϸ������һ�£�������Ӧ����"+case when @kcbgts > 0 then  @wkcypxx else '' end  
   return  
  end   
    
  if  @kcbgts > 0 and @config2157 = '��' and @config2422<>'��'  
  begin  
   select "F","��治����"+@wkcypxx  
   return  
  end  
       
 end;  
 /*�ж��շ���ϸ�����Ƿ��봦����ϸ����һ�� end*/  
    
 /*�շ�ǰ��������ж� begin*/  
 select * into #brxxk from SF_BRXXK where patid=@patid  
 if @@rowcount=0 or @@error<>0  
 begin  
  select "F","���߻�����Ϣ�����ڣ�"  
  return  
 end  
 --add by winning-dingsong-chongqing on 20200213  
 if not exists(select 1 from #brxxk a inner join GH_GHZDK b on a.patid=b.patid and a.hzxm=b.hzxm where a.patid=@patid)  
 begin  
  update a set a.hzxm=b.hzxm from #brxxk a inner join GH_GHZDK b on a.patid=b.patid where a.patid=@patid  
 end  
  
 select @pzh=pzh, @zhje=zhje, @tcljje1=isnull(ljje,0) from #brxxk  
 select @zfbz=zfbz, @pzlx=pzlx, @brlx=brlxdm, @qkbz1=zhbz,@jsfs=jsfs, @hysybz=hysybz, @qkbz2  = zhbz, @ybjkid=isnull(ybjkid,0) from YY_YBFLK (nolock) where ybdm=@ybdm  
 if @@rowcount=0 or @@error<>0  
 begin  
  select "F","���߷��������ȷ��"  
  return  
 end  
  
   
   
 --ͳ����������õ�ҽ������  
 if exists(select 1 from YY_CONFIG (nolock) where charindex('"'+rtrim(@ybdm)+'"',config)>0 and id='0115')  
 begin  
  select @tcljje1=tcljje from YY_BRLJXXK nolock where mzpatid = @patid  
 end  
 select @hykmsbz = config from YY_CONFIG where id='0099'  
 if @@error<>0  
 begin  
  select "F","�����Ա��ģʽ���ò���ȷ��"  
  return  
 end  
  
 if @hykmsbz=0  
 begin  
  select @yydjje=sum(isnull(djje,0)) from GH_GHYYK(nolock) where patid=@patid and djbz=1 and jlzt = 0   
  
  select @yjye=isnull(yjye,0)-isnull(@yydjje,0),@gsbz=gsbz  from YY_JZBRK where patid=@patid and jlzt=0  
  if @@rowcount=0  
   select @yjye=0  --Ԥ�������  
  else  
   select @yjbz=1 --�Ƿ�ʹ�ó�ֵ��  
  
  if @gsbz=1  
  begin  
   select "F","��ֵ���ѹ�ʧ������ʹ�ã�"  
   return  
  end  
 end  
 else  
 begin  
  execute usp_yy_jzbryjye @patid, @ybdm, @hysybz, 0, @errmsg output  
  if @errmsg like "F%"  
  begin  
   select "F",substring(@errmsg,2,49)  
   return  
  end  
  else  
   select @yjye=convert(numeric(10,2),substring(@errmsg,2,11))  
  
  if @yjye=0  
   select @yjbz=0  
  else  
   select @yjbz=1  
 end  
  
 if @yjbz =1--add wuwei 2011-06-08 for bug 95182 �෢Ʊ����ģʽ�£��ȿ۳���ǰ���Ѿ�����Ԥ���yjye  
 begin  
  select @yjye =@yjye -@dfpzhzfje  
  if @yjye <0 --add wuwei �Է���һ���ж�һ��  
  begin  
   select 'F','�෢Ʊ�������Ѻ��������'  
   return  
  end  
 end  
 select @yjyebz = config from YY_CONFIG where id='2059'  
 if @@rowcount=0 or @@error<>0  
 begin  
  select "F","��ֵ�������Ƿ���������շ����ò���ȷ��"  
  return  
 end  
  
 select @ypggbz='��'  
  
 select @ypggbz = config from YY_CONFIG where id='2063'  
 if @@error<>0  
 begin  
  select "F","ҩƷ��񱣴淽ʽ���ò���ȷ��"  
  return  
 end  
  
 select @csybdm = ltrim(rtrim(config)) from YY_CONFIG where id = '1106'  
 if @@error<>0  
 begin  
  select "F","����ҽ���������ò���ȷ��"  
  return  
 end  
  
 /*�շ�ǰ��������ж� end*/  
  
 if exists(select 1 from GH_GHZDK a (nolock) where a.xh=@ghxh and exists(select 1 from YY_KSBMK b (nolock) where a.ksdm=b.id and b.ekbz=1))  
  select @ekbz=1  
  
 --Ƿ��ĵ�һ�εݽ�������  
 if @qkbz1=2  
  select @qkbz1=0  
  
 --�ʻ��޽����Ϊ��ͨ����  
 if @qkbz1=1 and @zhje=0  
  select @qkbz1=0  
  
 if @pzlx not in (10,11)  
  select @xmlb=ylxm, @zddm=zddm from SF_YBPZK (nolock) where pzh=@pzh and patid=@patid and pzlx=@pzlx  
   
 select a.cfxh, a.idm, b.gg_idm, b.ypmc, a.xxmdm, a.fysl*a.dwxs as fysl, a.cfts,   
     b.yplh as dxmdm, c.name as dxmmc, b.ylsj, b.ypfj, b.zfbz, b.zfbl,   
     0 as yhbz, convert(numeric(6,4),0) as yhbl, convert(money, 0) as zfdj, isnull(a.yhdj,convert(money, 0)) yhdj,  
     c.mzfp_id, c.mzfp_mc, a.ypdw, a.dwxs, b.ykxs, b.sxjg, b.ypgg, a.shbz, b.flzfbz,  
     convert(money, 0) as flzfdj,convert(money,0) as dffbz,convert(numeric(6,4),0) as txbl,a.lcxmdm,a.lcxmmc,a.zbz,a.hjmxxh, 0 as ejygbz,a.lcxmsl,b.dydm --add "dydm" 20070119 --agg 2004.07.09 ����lcxmdm,lcxmmc,zbz --add by ozb 20060320 ���Ӷ���ҩ���־  
  ,b.lcjsdj,b.ylsj*0  yyhdj,a.xh 'ind',a.yjqrbz yjqrbz,a.yfdm,convert(smallint,0) 'mxwsbz'  
  --,convert(varchar(24),'') as memo  
  --modified by mxd for bug:291335 ��������VW_MZHJCFMXK.memoȥ����#sfmx.memo���ᱨ�ض�  
  ,convert(varchar(256),'') as memo   
  ,convert(money, 0) txdj,0 djjsbz,a.ksdm  
  ,0 gjybz,convert(money,0) gjydeje  
  into #sfmx  
     from #mzsftmp a, YK_YPCDMLK b (nolock), YY_SFDXMK c (nolock)  
     where a.idm>0 and b.idm=a.idm and c.id=b.yplh and 1=2   
 if @@error<>0  
 begin  
  select "F","�����շѷ���ʱ����"  
  return  
 end  
  
 --�����շѷ���  
    /*�ж��Ƿ�Ϊ�����ʵʱҽ������ begin*/  
    if @pzlx in (10,11) and @mjzbz = 2 and (select config from YY_CONFIG (nolock) where id='2048')='��' --�����շ��Ƿ���סԺ�Էѱ���  
    begin  
  insert into #sfmx  
     select a.cfxh, a.idm, b.gg_idm, b.ypmc, a.xxmdm, a.fysl*a.dwxs as fysl, a.cfts,   
     b.yplh as dxmdm, c.name as dxmmc, b.ylsj, b.ypfj, b.zyzfbz, b.zyzfbl,  
     0 as yhbz, convert(numeric(6,4),0) as yhbl, convert(money, 0) as zfdj, isnull(a.yhdj*b.ykxs/a.dwxs,convert(money, 0)) yhdj,  
     c.mzfp_id, c.mzfp_mc, a.ypdw, a.dwxs, b.ykxs, b.sxjg,   
     case when (@ekbz=1 and @ypggbz='��') then (LTrim(RTrim(Case When b.ggxs>=1 And Floor(b.ggxs)*10=Floor(b.ggxs*10) Then  Str(b.ggxs,12,0)   
     When b.ggxs>=1 And Floor(b.ggxs*10)*10=Floor(b.ggxs*100) Then  Str(b.ggxs,12,1)    
     When b.ggxs<1 And Floor(b.ggxs*10)*10=Floor(b.ggxs*100) Then Str(b.ggxs,12,1)    
     When b.ggxs<1 And Floor(b.ggxs*100)*10=Floor(b.ggxs*1000) Then Str(b.ggxs,12,2)    
     When b.ggxs<1 And Floor(b.ggxs*1000)*10=Floor(b.ggxs*10000) Then Str(b.ggxs,12,3)   
     Else Str(b.ggxs,12,4) end ))   
          + LTrim(RTrim(b.ggdw))+'��'+LTrim(RTrim(str(b.ekxs,6,0)))      
          + LTrim(RTrim(b.zxdw))+'/' +LTrim(RTrim(b.ekdw)))  
     when (@ekbz=0 and @ypggbz='��') then (LTrim(RTrim(Case When b.ggxs>=1 And Floor(b.ggxs)*10=Floor(b.ggxs*10) Then  Str(b.ggxs,12,0)   
     When b.ggxs>=1 And Floor(b.ggxs*10)*10=Floor(b.ggxs*100) Then  Str(b.ggxs,12,1)    
     When b.ggxs<1 And Floor(b.ggxs*10)*10=Floor(b.ggxs*100) Then Str(b.ggxs,12,1)    
     When b.ggxs<1 And Floor(b.ggxs*100)*10=Floor(b.ggxs*1000) Then Str(b.ggxs,12,2)    
     When b.ggxs<1 And Floor(b.ggxs*1000)*10=Floor(b.ggxs*10000) Then Str(b.ggxs,12,3)   
     Else Str(b.ggxs,12,4) end ))   
          + LTrim(RTrim(b.ggdw))+'��'+LTrim(RTrim(str(b.mzxs,6,0)))      
          + LTrim(RTrim(b.zxdw))+'/' +  LTrim(RTrim(b.mzdw)))   
     else b.ypgg end, a.shbz, b.zyflzfbz, 0,isnull(b.dffbz,0),convert(numeric(6,4),0) as txbl,a.lcxmdm,a.lcxmmc,a.zbz,a.hjmxxh,0,a.lcxmsl,b.dydm --add "dydm" 20070119  --agg 2004.07.09 ����lcxmdm,lcxmmc,zbz --add by ozb 20060320 ejygbz  
   ,b.lcjsdj,0,a.xh,a.yjqrbz,a.yfdm,0,''  
   ,convert(money, 0) txdj,0 djjsbz,a.ksdm,0,0  
     from #mzsftmp a, YK_YPCDMLK b (nolock), YY_SFDXMK c (nolock)  
     where a.idm>0 and b.idm=a.idm and c.id=b.yplh   
    end  
    else begin  
        insert into #sfmx  
     select a.cfxh, a.idm, b.gg_idm, b.ypmc, a.xxmdm, a.fysl*a.dwxs as fysl, a.cfts,   
                                      --zxm 20190304 b.ylsj����ֱ��ȡ�����ԭb.ylsj=0���û���ǰ̨�����������Լ��ļ۸񣬴�������Ҫȡ����ļ۸�BUG 40045   
     b.yplh as dxmdm, c.name as dxmmc, case when isnull(b.ylsj,0)=0 then a.ypdj else b.ylsj end, b.ypfj, b.zfbz, b.zfbl,   
     0 as yhbz, convert(numeric(6,4),0) as yhbl, convert(money, 0) as zfdj, isnull(a.yhdj*b.ykxs/a.dwxs,convert(money, 0)) yhdj,  
     c.mzfp_id, c.mzfp_mc, a.ypdw, a.dwxs, b.ykxs, b.sxjg,   
     case when (@ekbz=1 and @ypggbz='��') then (LTrim(RTrim(Case When b.ggxs>=1 And Floor(b.ggxs)*10=Floor(b.ggxs*10) Then  Str(b.ggxs,12,0)   
     When b.ggxs>=1 And Floor(b.ggxs*10)*10=Floor(b.ggxs*100) Then  Str(b.ggxs,12,1)    
     When b.ggxs<1 And Floor(b.ggxs*10)*10=Floor(b.ggxs*100) Then Str(b.ggxs,12,1)    
     When b.ggxs<1 And Floor(b.ggxs*100)*10=Floor(b.ggxs*1000) Then Str(b.ggxs,12,2)    
     When b.ggxs<1 And Floor(b.ggxs*1000)*10=Floor(b.ggxs*10000) Then Str(b.ggxs,12,3)   
     Else Str(b.ggxs,12,4) end ))   
          + LTrim(RTrim(b.ggdw))+'��'+LTrim(RTrim(str(b.ekxs,6,0)))      
          + LTrim(RTrim(b.zxdw))+'/' +LTrim(RTrim(b.ekdw)))  
     when (@ekbz=0 and @ypggbz='��') then (LTrim(RTrim(Case When b.ggxs>=1 And Floor(b.ggxs)*10=Floor(b.ggxs*10) Then  Str(b.ggxs,12,0)   
     When b.ggxs>=1 And Floor(b.ggxs*10)*10=Floor(b.ggxs*100) Then  Str(b.ggxs,12,1)    
     When b.ggxs<1 And Floor(b.ggxs*10)*10=Floor(b.ggxs*100) Then Str(b.ggxs,12,1)    
     When b.ggxs<1 And Floor(b.ggxs*100)*10=Floor(b.ggxs*1000) Then Str(b.ggxs,12,2)    
     When b.ggxs<1 And Floor(b.ggxs*1000)*10=Floor(b.ggxs*10000) Then Str(b.ggxs,12,3)   
   Else Str(b.ggxs,12,4) end ))   
          + LTrim(RTrim(b.ggdw))+'��'+LTrim(RTrim(str(b.mzxs,6,0)))      
          + LTrim(RTrim(b.zxdw))+'/' +  LTrim(RTrim(b.mzdw)))   
     else b.ypgg end, a.shbz, b.flzfbz, 0,isnull(b.dffbz,0),convert(numeric(6,4),0) as txbl,a.lcxmdm,a.lcxmmc,a.zbz,a.hjmxxh,0,a.lcxmsl,b.dydm --add "dydm" 20070119   --agg 2004.07.09 ����lcxmdm,lcxmmc,zbz --add by ozb 20060320 ejygbz  
   ,b.lcjsdj,0,a.xh,a.yjqrbz,a.yfdm,0,''  
   ,convert(money, 0) txdj,0 djjsbz,a.ksdm,0,0  
     from #mzsftmp a, YK_YPCDMLK b (nolock), YY_SFDXMK c (nolock)  
     where a.idm>0 and b.idm=a.idm and c.id=b.yplh  
    end  
 select @error=@@error, @rowcount=@@rowcount  
 if @error<>0  
 begin  
  select "F","�����շѷ���ʱ����"  
  return  
 end  
  /*�ж��Ƿ�Ϊ�����ʵʱҽ������ end*/  
  
 insert into #sfmx  
 select a.cfxh, 0, 0, case when ltrim(rtrim(b.name))<>ltrim(rtrim(a.ypmc)) then a.ypmc else b.name end, a.xxmdm, a.fysl, a.cfts,   
  b.dxmdm, c.name as dxmmc, (case when (a.cflx=6) or (b.xmdj=0) then a.ypdj else b.xmdj end),   
  (case when b.xmdj=0 then a.ypdj else b.xmdj end),   
  b.mzzfbz, b.mzzfbl, (case when b.yhbl>0 then 1 else 0 end), b.yhbl, 0, isnull(a.yhdj,convert(money, 0)) yhdj,  
  c.mzfp_id, c.mzfp_mc, a.ypdw, a.dwxs, 1, b.sxjg, b.xmgg, a.shbz, b.flzfbz, 0,0,convert(numeric(6,4),0) as txbl,a.lcxmdm,a.lcxmmc,a.zbz,a.hjmxxh,0 ,a.lcxmsl,b.dydm --add "dydm" 20070119   --agg 2004.07.09 ����lcxmdm,lcxmmc,zbz --add by ozb 20060320 ejygbz 
  
  
  
  
   
   
   
  
  
   
   
  
  
  ,0 as lcjsdj,0,a.xh,a.yjqrbz,a.yfdm,0,''  
  ,convert(money, 0) txdj,0 djjsbz,a.ksdm,0,0  
  from #mzsftmp a, YY_SFXXMK b (nolock), YY_SFDXMK c (nolock)  
  where a.idm<=0 and b.id=a.xxmdm and c.id=b.dxmdm   
 select @error=@@error, @rowcount=@rowcount+@@rowcount  
 if @error<>0  
 begin  
  select "F","�����շѷ���ʱ����"  
  return  
 end  
  
 if @rowcount=0  
 begin  
  select "F","�շ���Ŀ�����ڣ��������շ���Ŀ��"  
  return  
 end  
 else   
 begin  
  --��ͯ����begin add by wang_qiang 20170704  
  if @config2490_js='��'  
  begin  
   if @config2491='��'  
   begin  
    update a set a.ylsj=a.ylsj+b.etjsje   
    from #sfmx a  
    inner join YK_YPCDMLKZK b(nolock) on b.idm=a.idm  
    inner join YY_KSJSXMDYK c(nolock) on c.ksdm=a.ksdm and c.idm=b.idm and c.idm>0  
    where a.idm>0 and b.etjsbz=1   
      
    update a set a.ylsj=a.ylsj+b.etjsje   
    from #sfmx a  
    inner join YY_SFXXMK b (nolock) on b.id=a.xxmdm  
    inner join YY_KSJSXMDYK c(nolock) on c.ksdm=a.ksdm and c.ypdm=b.id and c.idm<=0  
    where a.idm<=0 and b.etjsbz=1  
   end  
   else if @config2491='��'  
   begin  
    update a set a.ylsj=a.ylsj+b.etjsje   
    from #sfmx a  
    inner join YK_YPCDMLKZK b(nolock) on b.idm=a.idm  
    where a.idm>0 and b.etjsbz=1  
      
    update a set a.ylsj=a.ylsj+b.etjsje   
    from #sfmx a  
    inner join YY_SFXXMK b (nolock) on b.id=a.xxmdm  
    where a.idm<=0 and b.etjsbz=1  
   end  
  end  
  --��ͯ����end add by wang_qiang 20170704  
    
  /*�����շѷ��� begin */  
  if not ((select config from YY_CONFIG (nolock) where id='2254')='��' AND @cflx=6) -- add by h_wh bug 60660  
  begin  
   update #sfmx set ylsj=a.ylsj*b.sfbl,ypfj=a.ypfj*b.sfbl  
    from #sfmx a,YY_LCSFXMK b  
    where a.lcxmdm=b.id and isnull(a.lcxmdm,"0")<>"0" and b.sfbl>0  
   if @@error<>0  
   begin  
    select "F","�����շѷ���ʱ����"  
    return  
   end  
  end  
     --�����ٴ���Ŀ�е����շ���Ŀ��shbz     
     update a set shbz = e.ybshbz  
     from #sfmx a,SF_HJCFMXK b(nolock),SF_HJCFK c(nolock),dbo.SF_MZSQD d(nolock),SF_SQDYBSHBZ e(nolock)  
     where a.idm = 0 and a.hjmxxh = b.xh and b.cfxh = c.xh and c.sqdxh = d.xh and convert(numeric(12,0),d.blsqdxh/100) = e.sqdxh  
     and a.xxmdm = e.xmdm and isnull(a.lcxmdm,"0") <> "0"  
    
  if @zfbz=0  --������־  
   update #sfmx set yhbz=0, yhbl=0,txbl=0  
  else if @zfbz=2  
  begin  
   update #sfmx set yhbz=0, yhbl=0,txbl=0  
  
   update #sfmx set zfbz=1, zfbl=b.zfbl  
    from #sfmx a, YY_TSSFXMK b (nolock)  
    where b.idm=a.idm and b.xmdm=a.xxmdm and b.ybdm=@ybdm  
   if @@error<>0  
   begin  
    select "F","�����շѷ���ʱ����"  
    return  
   end  
  end  
  else if @zfbz=3     
  begin  
   if charindex('"'+ltrim(rtrim(@ybdm))+'"',@csybdm) > 0  
   begin  
    if @zhje > 0  
    begin  
     update #sfmx set yhbz=1, yhbl=b.yhbl  
      from #sfmx a, YY_TSSFXMK b (nolock)  
      where b.idm=a.idm and b.xmdm=a.xxmdm and b.ybdm=@ybdm  
    end  
    else begin  
     update #sfmx set yhbz=0, yhbl=0  
      from #sfmx a, YY_TSSFXMK b (nolock)  
      where b.idm=a.idm and b.xmdm=a.xxmdm and b.ybdm=@ybdm      
    end  
   end  
   else if charindex('"'+ltrim(rtrim(@ybdm))+'",',@bkybdmjh) > 0  
   begin  
    update #sfmx set yhbz=1, yhbl=b.yhbl  
     from #sfmx a, YY_TSSFXMK b (nolock)  
     where b.idm=a.idm and b.xmdm=a.xxmdm and b.ybdm=@ybdm  
   end  
   else   
    update #sfmx set zfbz=0, zfbl=0, yhbz=1, yhbl=b.yhbl,txbl=b.txbl,txdj = b.txdj,djjsbz=isnull(b.djjsbz,0)  
     from #sfmx a, YY_TSSFXMK b (nolock)  
     where b.idm=a.idm and b.xmdm=a.xxmdm and b.ybdm=@ybdm  
   if @@error<>0  
   begin  
    select "F","�����շѷ���ʱ����"  
    return  
   end  
  end  
  else if @zfbz=4  
   update #sfmx set zfbz=0, zfbl=0, yhbz=0, yhbl=0,txbl=0  
  
  --�������˹�������,��������ȷ��  
        --����2039����Ϊ0ʱ,����ҩ���ͨ������Էѱ�������Ϊ0,�����ϱ�������  
        --���Ա��2039����ֻ������Ϊ1,ֻ֧����˲�ͨ����Ϊ���ɱ�����ʽ  
        --ҩƷ���ù���:��Ҫҽ��������ҩƷ,��ҩƷ�ֵ��й�ѡҽ�����Ʊ�־  
        --�Էѱ���������ҽ����������ı�����������  
        --ҽ�������ʱ�������ҽ��������������ͨ��,�粻����ҽ�������������˲�ͨ��  
        if exists (select 1 from #sfmx where isnull(shbz,0)<>0)  
        begin  
            --�ж�ҽ��վ�Ƿ��ṩ��˹��ܼ���˹�����Ե�ҽ������  
            --��1,4,10,11(���շѴ��ֹ�����)��,��0022�����õ�ƾ֤����Ҳ��Ҫҽ������  
            declare @configH164 char(2),@config0022 varchar(500)  
            select @configH164=config from YY_CONFIG(nolock) where id='H164'  
            select @config0022=config from YY_CONFIG(nolock) where id='0022'  
            if exists (select 1 from #sfmx where isnull(hjmxxh,0)<>0) and charindex('"'+rtrim(ltrim(@pzlx))+'"',@config0022)<1  
            begin  
                select 'F','ҽ��������������,��ǰ���Ӵ�����ҽ������δ��������Χ��,���ܽ���!'  
                return   
            end  
            if exists (select 1 from #sfmx where isnull(hjmxxh,0)=0)  
               and charindex('"'+rtrim(ltrim(@pzlx))+'"',@config0022)<1 and @pzlx not in (1,4,10,11)  
            begin  
                select 'F','ҽ��������������,��ǰ�ֹ�������ҽ������δ��������Χ��,���ܽ���!'  
                return  
            end  
            else  
            begin  
                if @configH164='��' and exists (select 1 from #sfmx where isnull(hjmxxh,0)<>0 and isnull(shbz,0)<>0)  
    begin  
     select 'F','ҽ����������δ����,��ǰ�����д���ҽ����������,���ܽ���!'  
     return  
    end  
    if exists (select 1 from YK_YPCDMLK a(nolock),#sfmx b(nolock)  
     where a.idm=b.idm and b.idm>0 and isnull(shbz,0)<>0 and isnull(a.ybkzbz,0)=0   
     and isnull(b.hjmxxh,0)<>0)  
    begin  
     select 'F','ҽ��������������,��ǰ����(���ӷ�)�д��ڲ���Ҫҽ��������ҩƷ��������־,���ܽ���!'  
     return  
    end  
    if exists (select 1 from YK_YPCDMLK a(nolock),#sfmx b(nolock)  
        where a.idm=b.idm and b.idm>0 and isnull(shbz,0)<>0 and isnull(a.ybkzbz,0)=0   
        and isnull(b.hjmxxh,0)=0)  
    begin  
     select 'F','ҽ��������������,��ǰ����(�ֹ���)�д��ڲ���Ҫҽ��������ҩƷ��������־,���ܽ���!'  
     return      
    end  
    if exists (select 1 from YY_SFXXMK a(nolock),#sfmx b(nolock)  
     where a.id=b.xxmdm and b.idm=0 and isnull(shbz,0)<>0 and isnull(a.ybkzbz,0)=0   
     and isnull(b.hjmxxh,0)<>0)  
    begin  
     select 'F','ҽ��������������,��ǰ����(���ӷ�)�д��ڲ���Ҫҽ����������Ŀ��������־,���ܽ���!'  
     return  
    end  
    if exists (select 1 from YY_SFXXMK a(nolock),#sfmx b(nolock)  
        where a.id=b.xxmdm and b.idm=0 and isnull(shbz,0)<>0 and isnull(a.ybkzbz,0)=0   
        and isnull(b.hjmxxh,0)=0)  
    begin  
     select 'F','ҽ��������������,��ǰ����(�ֹ���)�д��ڲ���Ҫҽ����������Ŀ��������־,���ܽ���!'  
     return      
    end  
            end  
            --�жϲ���2039������  
            if exists (select 1 from YY_CONFIG(nolock) where id='2039' and config='0')  
            begin  
                select 'F','����2039����Ϊ0,�Ϻ����������ò���Ϊ1!'  
                return  
            end              
        end          
        update #sfmx set zfbz=1, zfbl=1, yhbz=0, yhbl=0, flzfbz=0  where shbz=2  
  --�����2039һ��Ҫ����Ϊ0�����Դ�����ע�ͣ���������  
  /*  
  if (select config from YY_CONFIG (nolock) where id='2039')='0'  
     update #sfmx set zfbz=0, zfbl=0, yhbz=0, yhbl=0 where shbz=1   --���ͨ����Ϊ�ɱ�����  
  else  
     update #sfmx set zfbz=1, zfbl=1, yhbz=0, yhbl=0, flzfbz=0  where shbz=2   --��˲�ͨ����Ϊ���ɱ�����  
    */  
  --update by zwj 2003.11.07 ҽ�����Ϊ���ǲ���Ϊ�����Է�ҩƷ����  
  
  --��ƶ���߸��� vsts 315326 begin  
  --ƶ���ȼ�  
  if exists(select 1 from YY_CONFIG where id ='0384' and config ='��')and  exists(select 1 from SF_BRXXK a(nolock),YY_PKRKXXB b(nolock) where a.patid =@patid and a.sfzh =b.sfzh and b.jlzt =1 and b.shbz =1)  
  begin  
   declare @pkdj ut_bz  
   select @pkdj =pkdj from SF_BRXXK a(nolock),YY_PKRKXXB b(nolock) where a.patid =@patid and a.sfzh =b.sfzh  
    
    update #sfmx set zfbz=0, zfbl=0, yhbz=1, yhbl=b.yhbl    
    from #sfmx a, YY_PKSFXMK b (nolock)    
    where b.idm=a.idm and b.xmdm=a.xxmdm and b.pkdj=@pkdj and isnull(b.xtbz,2)in(0,2)   
  end  
  --��ƶ���߸��� end  
  
  /*�����շѷ��� end */  
  
  --����ע��Ϣ  
  update #sfmx set memo = isnull(b.memo,'') from #sfmx a(nolock),VW_MZHJCFMXK b(nolock) where a.hjmxxh = b.xh  
   
      --����ɵ�����2366����2367����  
  if (@config2366 <> '') or (@config2367 <> '')  
  BEGIN  
   --�����շѴ�ֱ�ӿ��Ĵ���,ҲҪ�����жϣ����������շѴ�ֱ�ӿ��Ĵ�����Ҳ�ᰴ���Żݼ���  
   update #sfmx set zfbz=1, zfbl=1, yhbz=0, yhbl=0, flzfbz=0   
         where hjmxxh = 0 and (@config2367 <> '' and charindex('"'+rtrim(@ksdm)+'"',@config2367) = 0)  
     
   --����ɵ�����2366����  
   update #sfmx set zfbz=1, zfbl=1, yhbz=0, yhbl=0, flzfbz=0   
   from #sfmx a(nolock),SF_HJCFK b(nolock),SF_HJCFMXK c(nolock)  
   where a.hjmxxh = c.xh and b.xh = c.cfxh   
   and (@config2366 <> '' and ((charindex('"'+rtrim(b.ksdm)+'"',@config2366)>0 and isnull(c.echjbz,0)=0)   
   or charindex('"'+rtrim(b.ksdm)+'"',@config2366) = 0))  
         
   --����ɵ�����2367����  
   update #sfmx set zfbz=1, zfbl=1, yhbz=0, yhbl=0, flzfbz=0   
   from #sfmx a(nolock),SF_HJCFK b(nolock),SF_HJCFMXK c(nolock)  
   where a.hjmxxh = c.xh and b.xh = c.cfxh   
   and (@config2367 <> '' and charindex('"'+rtrim(b.ksdm)+'"',@config2367) = 0)  
  end   
  
    
  --�Դ����ĵ������ɱ������ɱ�����begin  
  select distinct cfxh   
  into #tempcfxh   
  from #sfmx where dffbz=1 group by cfxh  
    
  select cfxh,count(cfxh) recno  
  into #tempno  
  from #sfmx a where exists(select 1 from #tempcfxh b where a.cfxh=b.cfxh) group by cfxh  
    
   --�����ɱ�  
  update #sfmx set zfbz=0,zfbl=0,yhbz=0,yhbl=0,txbl=0  
  where dffbz=1 and exists(select 1 from #tempno where cfxh=#sfmx.cfxh and recno>1)  
   --�������ɱ����Ż�  
  update #sfmx set zfbz=1,zfbl=1,yhbz=0,yhbl=0,txbl=0  
  where dffbz=1 and exists(select 1 from #tempno where cfxh=#sfmx.cfxh and recno=1)  
  --�Դ����ĵ������ɱ������ɱ�����end  
  
  --add by chenwei 2004.02.28  
  if @zfbz = 3   
          update #sfmx set ylsj= case when isnull(djjsbz,0) =  1 then txdj else case when txbl <>0 then ylsj*txbl else ylsj end end,  
        ypfj=case when isnull(djjsbz,0) =  1 then txdj else case when txbl<>0 then ypfj*txbl else ypfj end end   
           
          
          
  
  --W20050313 �����շ���Ŀ���������޼۸�,������������ⲡ�˵����޼۸�����.  
  --˳��:��ִ���շ�С��Ŀ�е����޼۸�,�ٸ���ִ�������շ���Ŀ�е����޼۸�  
  update #sfmx set sxjg = b.sxjg  
   from #sfmx a,YY_TSSFXMK b   
   where a.xxmdm = b.xmdm and b.ybdm = @ybdm  
  --modify by chewei 2003.12.06 ����ǰ̨���õ��Żݵ���  
  update #sfmx set zfdj=(case when sxjg<ylsj and sxjg>0 then (ylsj-sxjg)+sxjg*zfbl else ylsj*zfbl end),  
   yhdj=case when yhdj<>0 then yhdj else (case when sxjg<ylsj and sxjg>0 then sxjg*(1-zfbl)*yhbl else ylsj*(1-zfbl)*yhbl end) end  
     
  
  update #sfmx set flzfdj=(case when flzfbz=0 then 0 else   
   zfdj-(case when sxjg<ylsj and sxjg>0 then (ylsj-sxjg) else 0 end)  end)   
  
  --W20071125 �ɽ����۴���,Ӱ�쵽zfdj,flzfdj,yhdj  
  --�漰��ԭʼ���������߼۸������Էѡ��Żݱ������������߼۸�  
  --���еı�����Ӧ�óˣ�ҩƷ����  
  if exists(select ybdm from YY_YBFLK nolock where ybdm = @ybdm and lcyhbz = 1)     
  begin  
   --�жϷ��������ҩ��������������ʱ��Ĭ������ҩ��  
   update #sfmx set lcjsdj=0 where charindex('"'+rtrim(ltrim(yfdm))+'"',@config2297)>0  
   update #sfmx set zfdj=(case when sxjg<lcjsdj and sxjg>0 then (lcjsdj-sxjg)+sxjg*zfbl else lcjsdj*zfbl end),  
        yhdj=case when sxjg<lcjsdj and sxjg>0 then sxjg*(1-zfbl)*yhbl else lcjsdj*(1-zfbl)*yhbl end  
    where lcjsdj <> 0   
   update #sfmx set yyhdj = yhdj --����ԭ�����Żݵ��ۣ����ż�����ʱʹ��  
   --��֤�Żݵ��Ľ�����ԭ���۽��a:ԭ���ۼ� b:�Żݺ��� k:ԭ���Żݱ��� bk+a-b <= a    
   update #sfmx set yhdj = yhdj + ylsj - lcjsdj where lcjsdj <> 0  
   update #sfmx set flzfdj=(case when flzfbz=0 then 0 else   
           zfdj-(case when sxjg<lcjsdj and sxjg>0 then (lcjsdj-sxjg) else 0 end)  end)   
    where lcjsdj <> 0  
   select @lcyhje = isnull(sum(round(fysl*ylsj*cfts/ykxs,2)),0) -   
       isnull(sum(round(fysl*lcjsdj*cfts/ykxs,2)),0)  
    from #sfmx where idm>0 and lcjsdj <>0   
  end  
  else   
   update #sfmx set lcjsdj = 0  
    
    
    
  --modify by sunyu 2006-12-06 ���Ӱ������Ʒ����Ը��Ĵ���  
  if charindex('"'+ltrim(rtrim(@ybdm))+'",',@bkybdmjh)>0  
   update #sfmx set flzfdj=0, zfdj=0 where flzfbz=1  
--------------begin���Ʒ�������ʱ�Ѿ��շѣ���������lsjeΪ0   
  update a set a.flzfdj=0, a.zfdj=0,a.yhdj=0,a.ylsj=0 from #sfmx a, SF_HJCFMXK b  
   WHERE a.hjmxxh=b.xh and b.sjzlfabdxh<>0  
--------------end    
        --{TODO -oyfq -c2016-12 : ҽ���߼�ҩ���߸��� as @#$ begin}  
  --ִ�и߼�ҩ����  
  if @config2451='��' and dbo.fun_judgeybdm4gjy(0,@ybdm,@xmlb,@zhbz)='TF'  
  begin  
      /**  
   if exists (select 1 from sysobjects(nolock) where id=object_id('YB_SH_YBDYK'))  
   begin  
    update a set dydm=b.dydm   
    from #sfmx a,YB_SH_YBDYK b(nolock)  
    where a.idm=0 and a.xxmdm=b.xmdm and b.jlzt=1 and @now between b.qyrq+'00:00:00' and b.yxqx+'23:59:59'  
    update a set dydm=b.dydm   
    from #sfmx a,YB_SH_YBDYK b(nolock)  
    where a.idm>0 and a.idm=b.idm and b.jlzt=1 and @now between b.qyrq+'00:00:00' and b.yxqx+'23:59:59'  
   end  
   **/  
   update a set gjybz=1,gjydeje=isnull(b.zfdeje,0),  
    zfdj=0,flzfdj=0,zfbl=0,flzfbz=0,yhdj=0,yhbl=0  
   from #sfmx a,YY_YBYPK b(nolock)  
   where a.dydm=b.mc_code and isnull(b.tsbz,0)<>0 and @now between b.ksrq+'00:00:00' and b.jzrq+'23:59:59'  
   --�и߼�ҩ,��������߼�ҩ�Ը����  
   if exists (select 1 from #sfmx where gjybz=1)  
   begin  
    select @gjybz=1  
    select @gjyzje=isnull(sum(round(fysl*ylsj*cfts/ykxs,2)),0),  
     @gjyzfje=isnull(sum(round(fysl*gjydeje*cfts/ykxs,2)),0)  
    from #sfmx where idm>0 and gjybz=1  
    select @gjyzje1=isnull(sum(round(fysl*ylsj*cfts/ykxs,2)),0),  
     @gjyzfje1=isnull(sum(round(fysl*gjydeje*cfts/ykxs,2)),0)  
    from #sfmx where idm=0 and gjybz=1  
   end  
   else  
    select @gjybz=0  
  end  
  --{TODO -oyfq -c2016-12 : ҽ���߼�ҩ���߸��� as @#$ end}  
  if exists(select ybdm from YY_YBFLK nolock where ybdm = @ybdm and lcyhbz = 1)     
  begin  
   select @zje=isnull(sum(round(fysl*ylsj*cfts/ykxs,2)),0),  
    @zfyje=isnull(sum(round(fysl*zfdj*cfts/ykxs,2)),0),  
    @yhje = isnull(sum(case when isnull(lcjsdj,0) = 0 then round(yhdj*fysl*cfts/ykxs,2) else   
               round(ylsj*fysl*cfts/ykxs,2) - round(lcjsdj*fysl*cfts/ykxs,2)+ round(yyhdj*fysl*cfts/ykxs,2) end ),0),  
    @flzfje=isnull(sum(round(fysl*flzfdj*cfts/ykxs,2)),0)  
    from #sfmx where idm>0  
  end  
  else begin  
   select @zje=isnull(sum(round(fysl*ylsj*cfts/ykxs,2)),0),  
    @zfyje=isnull(sum(round(fysl*zfdj*cfts/ykxs,2)),0),  
    @yhje =isnull(sum(round(yhdj*fysl*cfts/ykxs,2)),0),  
    @flzfje=isnull(sum(round(fysl*flzfdj*cfts/ykxs,2)),0)  
    from #sfmx where idm>0     
  end  
    
  select @zje1=isnull(sum(round(fysl*ylsj*cfts/ykxs,2)),0),  
   @zfyje1=isnull(sum(round(fysl*zfdj*cfts/ykxs,2)),0),  
   @yhje1=isnull(sum(round(fysl*yhdj*cfts/ykxs,2)),0),  
   @flzfje1=isnull(sum(round(fysl*flzfdj*cfts/ykxs,2)),0)  
   from #sfmx where idm=0  
        if @gjybz=1  --@#$  
      select @ybje=@zje-@zfyje-@yhje-@gjyzje,@ybje1=@zje1-@zfyje1-@yhje1-@gjyzje1  
  else  
  select @ybje=@zje-@zfyje-@yhje, @ybje1=@zje1-@zfyje1-@yhje1  
 end  
  
 --add by zyh 20100305  
 select @config2206=rtrim(config) from YY_CONFIG where id='2206'  
 select @vipyxe=convert(money,config) from YY_CONFIG where id='2207'  
 select @vipyxe=isnull(@vipyxe,0)  
 if charindex(','+rtrim(@ybdm)+',' , ','+@config2206+',')>0 and isnull(@vipyxe,0)>0  
 begin  
  if not exists(select 1 from SF_VIPBRSPJL where patid=@patid)  
  begin  
   select @vipfylj=sum(zje) from VW_MZBRJSK(nolock) where patid=@patid and ybjszt=2 and jlzt=0 and ghsfbz=1 and charindex(','+rtrim(ybdm)+',' , ','+rtrim(@config2206)+',')>0 and sfrq like left(@now,6)+'%'  
   select @vipfylj=isnull(@vipfylj,0)  
   if @vipfylj+@zje+@zje1>@vipyxe  
   begin  
    select "F","VIP���˱���������"+convert(varchar,@vipfylj)+",�����շѺ󳬳����޶�"+convert(varchar,@vipyxe)  
    return  
   end  
  end  
 end  
  
  
    --add by qxh 2003.2.27  
 if @acfdfp=1   
  update  #sfzd  set  zje=b.zje,zfyje=b.zfyje,yhje=b.yhje   
        from  #sfzd a , (select cfxh,isnull(sum(round(fysl*ylsj*cfts/ykxs,2)),0) as zje ,  
                                     isnull(sum(round(fysl*zfdj*cfts/ykxs,2)),0) as zfyje,  
                                     isnull(sum(round(fysl*yhdj*cfts/ykxs,2)),0) as yhje  
                       from  #sfmx group by cfxh ) b  where a.cfxh=b.cfxh    
 --�����վݺ�  
 declare @czyh_new ut_czyh  
 select   @czyh_new = @czyh  
 if CHARINDEX('_',@wkdz)>0  
   select @czyh_new = LTRIM(RTRIM(@czyh))+SUBSTRING(@wkdz,CHARINDEX('_',@wkdz)+1,LEN(@wkdz)-CHARINDEX('_',@wkdz))   
 exec usp_yy_createsjh 'SF_BRJSK','sjh','czyh',@czyh_new,@errmsg output  
 --exec usp_yy_createsjh 'SF_BRJSK','sjh','czyh',@czyh,@errmsg output  
 if @errmsg like 'F%'  
 begin  
  select "F",substring(@errmsg,2,49)  
  return  
 end  
 else  
  select @sjh=rtrim(substring(@errmsg,2,32))  
  
 --add by ozb 20080612 begin  
 select @srbz=config from YY_CONFIG (nolock) where id='2016'  
  if @@error<>0 or @@rowcount=0  
   select @srbz='0'  
 select @sfje_all=@zje-@yhje  
 --add by ozb 20080612 end  
 --ȡ��ʵ�ս��  
 if @pzlx not in (10,11)  
 begin  
  
  --tony 2003.12.8 С����ҽ���޸�  
  if exists(select 1 from YY_CONFIG (nolock) where charindex('"'+rtrim(@ybdm)+'"',config)>0 and id='2082')  
   select @tcljbz=1  
  
  if @tcljbz=1  --ͳ������  
  begin  
  
   select @ybje=@ybje+@ybje1,@ybje1=0  
  
   --������,��ͳ����Ĵ���  
   execute usp_yy_ybjs @ybdm,0,@ybje,0,@errmsg output,0,@tcljje1,@jsfs  
   if @errmsg like "F%"  
   begin  
    select "F",substring(@errmsg,2,49)  
    return  
   end  
   else  
    select @sfje=convert(numeric(10,2),substring(@errmsg,2,11))  
            if @gjybz=1  --@#$  
      begin  
       select @ybje=@ybje+@gjyzje+@gjyzje1,@sfje=@sfje+@gjyzfje+@gjyzfje1  
      end  
   if @ybje+@ybje1>0  
    select @xmzfbl=@sfje/@ybje,@xmzfbl1=@sfje/@ybje  
  end  
  else  
  begin  
   --ҩƷ������  
   execute usp_yy_ybjs @ybdm,0,@ybje,0,@errmsg output,0,@tcljje,@jsfs  
   if @errmsg like "F%"  
   begin  
    select "F",substring(@errmsg,2,49)  
    return  
   end  
   else  
    select @sfje=convert(numeric(10,2),substring(@errmsg,2,11))  
    
   execute usp_yy_ybjs @ybdm,0,0,@ybje1,@errmsg output,0,@tcljje,@jsfs  
   if @errmsg like "F%"  
   begin  
    select "F",substring(@errmsg,2,49)  
    return  
   end  
   else  
    select @sfje1=convert(numeric(10,2),substring(@errmsg,2,11))  
      if @gjybz=1  --@#$  
            begin  
                select @ybje=@ybje+@gjyzje,@sfje=@sfje+@gjyzfje  
                select @ybje1=@ybje1+@gjyzje1,@sfje1=@sfje1+@gjyzfje1  
            end  
   if @ybje>0  
    select @xmzfbl=@sfje/@ybje  
    
   if @ybje1>0  
    select @xmzfbl1=@sfje1/@ybje1  
  
  end  
  
  
  select @sfje_all=@sfje+@sfje1+@zfyje+@zfyje1  
  select @sfje2=@sfje_all  
  select @srbz=config from YY_CONFIG (nolock) where id='2016'  
  if @@error<>0 or @@rowcount=0  
   select @srbz='0'  
  
  declare @srfs varchar(1)  --0����ȷ���֣�1����ȷ����  
  select @srfs = config from YY_CONFIG (nolock) where id='2235'  
  if @@error<>0 or @@rowcount=0  
   select @srfs='0'  
  if @srfs = '1' and  @czksfbz = 1 and @yjbz=1 ---1����ȷ������������20110426sqf  
  begin  
   if @srbz='5'  
    select @sfje2=round(@sfje_all, 1)  
   else if @srbz='6'  
    exec usp_yy_wslr @sfje_all,1,@sfje2 output   
   else if @srbz>='1' and @srbz<='9'  
    exec usp_yy_wslr @sfje_all,1,@sfje2 output,@srbz  
   else  
    select @sfje2=@sfje_all  
  
   select @srje=@sfje2-@sfje_all  
  end  
  
  declare @srpdbz ut_bz  
   
  --���ƻ����ˣ���ҽԺ�и����˻��Ĳ��ˣ�  
  if @qkbz1=1 and @zhje>0  
  begin  
   --�Էѷ����Լ�����(������ʼ)  
   if exists(select 1 from YY_CONFIG (nolock) where charindex('"'+rtrim(@ybdm)+'"',config)>0 and id='0053')  
   begin  
      
    if @sfje2-@zfyje-@zfyje1+@flzfje+@flzfje1<=@zhje  
    BEGIN  
     SELECT @qkje=@sfje2-@zfyje-@zfyje1+@flzfje+@flzfje1,@qkje2 = @sfje_all-@zfyje-@zfyje1+@flzfje+@flzfje1  
     /*  
     select @srpdbz=0  
     IF @srbz="0"  
      SELECT @qkje=@sfje2-@zfyje-@zfyje1+@flzfje+@flzfje1,@qkje2 = @sfje_all-@zfyje-@zfyje1+@flzfje+@flzfje1  
     ELSE  
      select  @qkje = round(@sfje2-@zfyje-@zfyje1+@flzfje+@flzfje1,1),  
       @qkje2 = @sfje_all-@zfyje-@zfyje1+@flzfje+@flzfje1  
     */  
    END  
    else  
    BEGIN  
     SELECT @qkje=@zhje, @qkje2=@zhje  
     /*  
     select @srpdbz=1  
     IF @srbz="0"  
      SELECT @qkje=@zhje, @qkje2=@zhje  
     ELSE  
      select  @qkje = round(@zhje,1),@qkje2 = @zhje  
     */  
    END  
   end  
   else  
   begin  
    if @sfje2<=@zhje  
    BEGIN  
     SELECT @qkje=@sfje2, @qkje2=@sfje_all  
     /*  
     select @srpdbz=0  
     IF @srbz="0"  
      SELECT @qkje=@sfje2, @qkje2=@sfje_all  
     ELSE  
      select @qkje = round(@sfje2,1),@qkje2 = @sfje_all  
     */  
    END  
    ELSE  
    BEGIN  
     SELECT @qkje=@zhje, @qkje2=@zhje  
     /*  
     select @srpdbz=1  
     IF @srbz="0"  
      SELECT @qkje=@zhje, @qkje2=@zhje  
     ELSE  
      select @qkje = round(@zhje,1),@qkje2 = @zhje  
     */  
    END  
   end  
   /*  
   --add by sunyu 2008-2-29 ͳһ��@qkje����С�����봦��  
   if @srbz='5'  
    select @qkje=round(@qkje2, 1)  
   else if @srbz='6'  
    exec usp_yy_wslr @qkje2,1,@qkje output   
   else if @srbz>='1' and @srbz<='9'  
    exec usp_yy_wslr @qkje2,1,@qkje output,@srbz  
   else  
    select @qkje=@qkje2  
   */  
   insert into SF_JEMXK(jssjh, lx, mc, je, memo)  
   values(@sjh, '01', '�𸶶ε����˻�֧��',@qkje2 , null)  
   if @@error<>0  
   begin  
    select "F","�������01��Ϣ����"  
    return  
   end  
   /*  
   if @srpdbz=0  
    select @sfje_bkall = @sfje_all - @qkje2  
   else  
    select @sfje_bkall = @sfje_all - @qkje--,@qkje = 0  
     
   --С�����봦��  
   if @srbz='5'  
    select @sfje2=round(@sfje_bkall, 1)  
   else if @srbz='6'  
    exec usp_yy_wslr @sfje_bkall,1,@sfje2 output   
   else if @srbz>='1' and @srbz<='9'  
    exec usp_yy_wslr @sfje_bkall,1,@sfje2 output,@srbz  
   else  
    select @sfje2=@sfje_bkall  
   if @srpdbz=0  
    select @srje = @sfje2 - (@sfje_all - @qkje2)  
   else  
    select @srje = @sfje2 - (@sfje_all - @qkje)  
   */  
   select @sfje2=@sfje2+@qkje  
     
--    if @ybje>0  
--     select @xmzfbl=(@ybje - @qkje2)/@ybje  
--    select @sfje = @ybje - @qkje2  
       
   --��������  
  end  
  else if @czksfbz = 1 --2004.02.17 szj add ������ԲŽ��г�ֵ���շ�  
  begin  
   if @yjbz=1  
   begin  
    if @cflx=6 and @hykmsbz=1  
    begin  
     execute usp_yy_jzbrtjsf @patid, @ybdm, 0, @errmsg output  
     if @errmsg like "T%" --ΪFʱ�����������  
     begin  
      --zwj 2007.04.23 ��Ϊ�Żݷ�ʽ����  
      select @sfje2=0, @tjmfbz=1,@xmzfbl=0, @xmzfbl1=0,  
       @yhje=@zje, @yhje1=@zje1, @zfyje=0, @zfyje1=0, @srje=0  
      update #sfmx set yhdj=ylsj, zfdj=0, flzfdj=0  
     end  
    end  
  
--    if @yjyebz='��' and @yjye<@sfje2  
--    begin  
--     select "F","��ֵ�����㣬���ܼ����շѣ�"  
--     return  
--    end  
  
    if @yjye>0  
    begin  
     if @sfje2<=@yjye  
      select @qkje=@sfje2  
     else  
     begin  
  
  
  
  
  
  
  
  
  
  
  
      select @qkje=@yjye   
      if @srfs = '1'---1����ȷ������������20110426sqf  
      begin  
       select @qkje=round(@yjye, 1,1) ---ȥ��С��λ  
      end        
     end  
                    select @qkbz1=3,@yjzfje=@qkje  
    end  
   end  
  end  
 end  
 else if @czksfbz = 1 and @ybjkid > 0  
 begin  
  if @yjbz = 1  
  begin  
   select @qkbz1=3,@yjzfje=@yjye  
   if @srfs = '1'---1����ȷ������������20110426sqf  
    select @yjzfje=round(@yjye, 1,1) ---ȥ��С��λ --Ԥ��ʱ����Ѻ�����ڽ���һʱ����  
  end  
 end  
 else if @czksfbz = 1      --2004.02.17  szj add ������ԲŽ��г�ֵ���շ�  
 begin  
  if @yjbz=1  
  begin  
--   select @qkbz=1  
--  else  
   select @yjzfje=@yjye --Ԥ��ʱ����Ѻ�����ڽ���һʱ����  
   if @srfs = '1'---1����ȷ������������20110426sqf  
    select @yjzfje=round(@yjye, 1,1) ---ȥ��С��λ  
  end  
 end  
  
 --add by ozb 20080612 begin --mod by wuwei 20101109 �������ᵽqkje����֮ǰ  
 if (@qkbz1 = 3 and @srfs = '0') or (@qkbz1 in(1,4))---0����ȷ������������20110426sqf  
 begin   
  select @sfje2=@sfje_all-@qkje  
  if @srbz='5'  
   select @sfje2=round(@sfje_all-@qkje, 1)  
  else if @srbz='6'  
   exec usp_yy_wslr @sfje2,1,@sfje2 output   
  else if @srbz>='1' and @srbz<='9'  
   exec usp_yy_wslr @sfje2,1,@sfje2 output,@srbz  
  else  
   select @sfje2=@sfje_all-@qkje  
  select @sfje2=@sfje2+@qkje  
  select @srje=@sfje2-@sfje_all  
 end  
 else if @qkbz1 not in( 1,3,4) ------������˻�����  
 begin  
  if @srbz='5'  
   select @sfje2=round(@sfje_all, 1)  
  else if @srbz='6'  
   exec usp_yy_wslr @sfje_all,1,@sfje2 output   
  else if @srbz>='1' and @srbz<='9'  
   exec usp_yy_wslr @sfje_all,1,@sfje2 output,@srbz  
  else  
   select @sfje2=@sfje_all  
  select @srje=@sfje2-@sfje_all  
 end  
  
   
 --add by ozb 20080612 end  
 --���������ܽ��,20071125�������۴���  
  select dxmdm, dxmmc, mzfp_id, mzfp_mc,   
   round(ylsj*fysl*cfts/ykxs,2) as xmje,   
   round((ylsj-zfdj-yhdj)*fysl*cfts,2) as zfje,  
   round(zfdj*fysl*cfts/ykxs,2) as zfyje,   
   round(yhdj*fysl*cfts/ykxs,2) as yhje,  
   round(flzfdj*fysl*cfts/ykxs,2) as flzfje,  
   round(flzfdj*fysl*cfts/ykxs,2) as lcyhje  
   into #sfmx1  
   from #sfmx where 1= 2  
  
 if exists(select ybdm from YY_YBFLK nolock where ybdm = @ybdm and lcyhbz = 1)     
  insert into #sfmx1(dxmdm, dxmmc, mzfp_id, mzfp_mc,xmje,zfje,zfyje,yhje,flzfje,lcyhje)  
  select dxmdm, dxmmc, mzfp_id, mzfp_mc, sum(round(ylsj*fysl*cfts/ykxs,2)) as xmje,   
   sum(round((ylsj-zfdj-yhdj)*fysl*cfts*(case when idm>0 then @xmzfbl else @xmzfbl1 end)/ykxs,2)) as zfje,  
   sum(round(zfdj*fysl*cfts/ykxs,2)) as zfyje,   
   sum(case when lcjsdj = 0 then round(yhdj*fysl*cfts/ykxs,2) else   
              round(ylsj*fysl*cfts/ykxs,2) - round(lcjsdj*fysl*cfts/ykxs,2)+ round(yyhdj*fysl*cfts/ykxs,2) end ) as yhje,  
   sum(round(flzfdj*fysl*cfts/ykxs,2)) as flzfje,  
   sum( case when lcjsdj = 0 then 0 else round(ylsj*fysl*cfts/ykxs,2) - round(lcjsdj*fysl*cfts/ykxs,2) end) lcyhje  
   from #sfmx group by dxmdm, dxmmc, mzfp_id, mzfp_mc  
 else   
  insert into #sfmx1(dxmdm, dxmmc, mzfp_id, mzfp_mc,xmje,zfje,zfyje,yhje,flzfje,lcyhje)  
  select dxmdm, dxmmc, mzfp_id, mzfp_mc, sum(round(ylsj*fysl*cfts/ykxs,2)) as xmje,   
   sum(round((ylsj-zfdj-yhdj)*fysl*cfts*(case when idm>0 then @xmzfbl else @xmzfbl1 end)/ykxs,2)) as zfje,  
   sum(round(zfdj*fysl*cfts/ykxs,2)) as zfyje, sum(round(yhdj*fysl*cfts/ykxs,2)) as yhje,  
   sum(round(flzfdj*fysl*cfts/ykxs,2)) as flzfje,0  
   from #sfmx group by dxmdm, dxmmc, mzfp_id, mzfp_mc    
  
 if exists (select 1 from #sfmx1)  
 begin  
  select @xmce=@sfje+@sfje1-sum(zfje) from #sfmx1  
--   select @xmce=@sfje2-sum(zfje) from #sfmx1  
  update #sfmx1 set zfje=zfje+zfyje  
  set rowcount 1  
  update #sfmx1 set zfje=zfje+@xmce  
  set rowcount 0  
 end   
  
 --�䡢��ҩ���ڴ���ͳһ�� usp_sf_getsfpck ���أ������Ѿ�������������� Wang Yi 2003.02.25  
 /*�����жϣ����﷢ҩ�Ƿ�ָ����ҩ���� begin  
 if @mjzbz = 2   
 begin   
  if exists (select id from YY_CONFIG  where id = '3031' and config = '��')  
  begin  
   if exists (select id from YY_CONFIG  where id = '3032')    
    select @newfyckdm = config  from YY_CONFIG  where id = '3032'  
  end  
 end  
 �����жϣ����﷢ҩ�Ƿ�ָ����ҩ���� end*/  
  
 --add by qxh 2003.2.27  
 --���Ը�����̯��������  
 if @acfdfp=1   
  update  #sfzd  set  zfje=b.zfje+a.zfyje  
        from  #sfzd a , (select cfxh,  
   sum(round((ylsj-zfdj-yhdj)*fysl*cfts*(case when idm>0 then @xmzfbl else @xmzfbl1 end)/ykxs,2)) as zfje                                      
                        from  #sfmx group by cfxh ) b  where a.cfxh=b.cfxh    
  
   
 if @pzlx in (10,11)  
 begin  
  --update by zwj 2003-09-09 ҽ�������޸�  
  select b.mzyb_id as id, b.mzyb_mc as name, sum(round(a.xmje,2)) as xmje,   
   sum(round(zfje,2)) as zfje,  
   sum(round(zfyje,2)) as zfyje, sum(round(yhje,2)) as yhje,  
   sum(round(flzfje,2)) as flzfje  
   into #ybsfmx  
   from #sfmx1 a,YY_SFDXMK b  
   where a.dxmdm=b.id    
   group by b.mzyb_id, b.mzyb_mc  
  if @@error<>0  
  begin  
   select "F","����ҽ������ʱ����"  
   return  
  end  
   
  select @ybzje=@ybje+@ybje1,@ybjszje=@ybje+@ybje1+(@flzfje+@flzfje1)  
  ----add by sqf 20101103  
  --���ﻻ��SF_BRJSK���˻���־  
  --����SF_BRXXK���˻���־  
  if @pzlx = 11 and substring(@zhbz,12,1)='0'----�󲡼���  
  begin  
   declare @msg varchar(300)  
            select @xmlb=isnull(ylxm,'0') from SF_BRJSK (nolock) where sjh=@ghsjh  ----ǰ̨û�д�������������Ԥ������ȷû�д�����  
            select @xmlb=isnull(@xmlb,'0')  
   exec usp_yy_yb_getylxm '0','0',@xmlb,@jfbz output,@msg output  
   if @jfbz <>'0' and @msg <>'R'  
   begin  
       if @config2395<>''  
       begin  
           select @flzfjedbxm=isnull(sum(round(fysl*flzfdj*cfts/ykxs,2)),0)  
           from #sfmx  
           where idm=0 and charindex('"'+rtrim(ltrim(xxmdm))+'"',@config2395)>0             
       end  
    select @ybzje=@ybje+@ybje1+@flzfje+@flzfjedbxm ---------ҽ�����׽�����ҩƷ��flzfje�ʹ󲡼�����Χ�ڵ���Ŀ  
    select @jfje=@flzfje+@flzfjedbxm  
   end   
  end    
  select @ybzlf=isnull(xmje-zfyje-yhje+flzfje,0) from #ybsfmx where id='02'  
  select @ybssf=isnull(xmje-zfyje-yhje+flzfje,0) from #ybsfmx where id='03'  
  select @ybjcf=isnull(xmje-zfyje-yhje+flzfje,0) from #ybsfmx where id='04'  
  select @ybhyf=isnull(xmje-zfyje-yhje+flzfje,0) from #ybsfmx where id='05'  
  select @ybspf=isnull(xmje-zfyje-yhje+flzfje,0) from #ybsfmx where id='06'  
  select @ybtsf=isnull(xmje-zfyje-yhje+flzfje,0) from #ybsfmx where id='07'  
  select @ybxyf=isnull(xmje-zfyje-yhje+flzfje,0) from #ybsfmx where id='08'  
  select @ybzyf=isnull(xmje-zfyje-yhje+flzfje,0) from #ybsfmx where id='09'  
  select @ybcyf=isnull(xmje-zfyje-yhje+flzfje,0) from #ybsfmx where id='10'  
  select @ybqtf=isnull(xmje-zfyje-yhje+flzfje,0) from #ybsfmx where id='11'  
  select @ybgrzf=isnull(sum(zfyje-flzfje),0) from #ybsfmx   
 end  
   
 --����hjk���¶���ҩ���־   
 --update a set ejygbz=b.ejygbz,ejygksdm=b.ejygksdm from #sfzd a,SF_HJCFK b(nolock)  
 --where a.hjxh=b.xh and isnull(hjxh,0)<>0  
 update a set ejygbz=b.ejygbz,ejygksdm=b.ejygksdm,  
     wsbz=isnull(b.wsbz,0),  
        wsts=isnull(b.cydjts,0),  
        yscfbz=isnull(b.yscfbz,0),  
        ccfbz=isnull(b.ccfbz,0)  
 from #sfzd a,SF_HJCFK b(nolock)  
 where a.hjxh=b.xh and isnull(hjxh,0)<>0  
   
 update b set mxwsbz=a.wsbz from #sfzd a,#sfmx b where a.cfxh=b.cfxh  
  
 -----��Ҫ�ֳ����鴦���������ļ�����ҩ���  
 update a set ejygbz = 1 from #sfmx a, BQ_EJYGYPJLK b (nolock)  
 where a.idm = b.idm and b.ksdm = @ksdm and jlzt = 0 and isnull(hjmxxh,0)=0  
  
 declare @sqdlb   varchar(2) ----add by sqf   
   ,@yjclfbz_temp ut_bz  
   ,@pyrq ut_rq16  
   ,@pybz ut_bz  
   ,@pyczyh ut_czyh  
  
 select @yjclfbz_temp=0  
 /*�շ���Ϣ���� begin*/  
 begin tran  
 declare cs_mzsf cursor for  
 select cfxh, ksdm, ysdm, yfdm, hjxh, cflx, sycfbz, tscfbz, cfts, pyckdm, fyckdm,zje,zfyje,  
  yhje,zfje,ejygbz,ejygksdm,fybz,wsbz,wsts,tbzddm,tbzdmc,yscfbz,ccfbz,ghxh from #sfzd --add by ozb ���Ӷ���ҩ���־  
 for read only  
  
 open cs_mzsf  
 fetch cs_mzsf into @cfxh, @ksdm, @ysdm, @yfdm, @hjxh, @cflx, @sycfbz, @tscfbz, @cfts, @pyckdm, @fyckdm,@zjecf,@zfyjecf,  
  @yhjecf,@zfje,@ejygbz,@ejygksdm,@fybz,@wsbz,@wsts,@tbzddm,@tbzdmc,@yscfbz,@ccfbz,@ghxhtmp --add by ozb ���Ӷ���ҩ���־  
 while @@fetch_status=0  
 begin  
  --����Ҫ�жϣ�ǰ���Ѿ�������, Wang Yi 2003.02.25  
/*  if @mjzbz = 2   
   select @fyckdm = @newfyckdm*/  
  
  --yxp add 2005-2-28   
  if (isnull(@cflx,0) in (1,2,3)) and (not exists(select 1 from YF_YFDMK where id=@yfdm))  
  begin  
   select "F","��ǰ������¼��ҩ������["+(@yfdm)+"]������,���˳�������¼�룡"  
   rollback tran  
   deallocate cs_mzsf  
   return  
  end  
  if (isnull(@cflx,0) not in (1,2,3)) and (exists(select 1 from #sfmx a, YK_YPCDMLK b (nolock)      where a.cfxh=@cfxh and a.idm=b.idm))  
  begin  
   select @ypmc=a.ypmc from #sfmx a, YK_YPCDMLK b (nolock)   
   where a.cfxh=@cfxh and a.idm=b.idm  
     
   select "F","��ǰ�����д���ҩƷ["+ltrim(@ypmc)+"]�����������Ͳ���ȷ,���˳�������¼�룡"  
   rollback tran  
   deallocate cs_mzsf  
   return  
  end  
  
  --xxl 20080903 ����ҽ������Ϣ����  
        if exists(select 1 from BQ_YS_YLXZCYXXB where ysdm=@ysdm)  
         select @ylxzbh=bh from BQ_YS_YLXZCYXXB where ysdm=@ysdm   
        else  
            select @ylxzbh=0  
  
        set @sqdxh = 0  
        if @hjxh>0  
  begin  
            select @sqdxh=isnull(sqdxh,0) from SF_HJCFK where xh=@hjxh  
   if (@@ROWCOUNT = 0)   
       select @sqdxh=isnull(sqdxh,0) from SF_NHJCFK where xh=@hjxh   
  end  
  
  if @hjxh>0   
  begin  
   select @hjcfjlzt=jlzt,@sqdlb = isnull(sqdlb,''),@pybz = isnull(pybz,0),@pyczyh = isnull(pyczyh,''),@pyrq = isnull(pyrq,'') from SF_HJCFK where xh=@hjxh  
  
   insert into SF_MZCFK(jssjh, hjxh, czyh, lrrq, patid, hzxm, ybdm, py, wb,   
    ysdm, ksdm, yfdm, qrczyh, qrrq, qrksdm, pyczyh, pyrq, cfts, txh, sfckdm,   
    pyckdm, fyckdm, jsbz, jlzt, fybz, cflx, sycfbz, tscfbz, pybz, jcxh, memo, cfxh,zje,zfyje,yhje,zfje, sqdxh  
    ,ejygbz, ejygksdm,xzks_id,ylxzbh,tmhdbz,ghxh,gxrq,wsbz,wsts,cftszddm,cftszdmc,yscfbz)  
   select @sjh, @hjxh, @czyh, @now, a.patid, a.hzxm, @ybdm, a.py, a.wb,  
    @ysdm, @ksdm, @yfdm, '', '', '', @pyczyh, @pyrq, @cfts, null, @sfckdm,  
    @pyckdm, @fyckdm, 1, 9, @fybz, @cflx, @sycfbz, @tscfbz, @pybz, null, null, @cfxh,@zjecf,@zfyjecf,@yhjecf,@zfje, @sqdxh  
    ,@ejygbz, case when @ejygbz=1 then @ejygksdm else "" end,isnull(b.xzks_id,b.ks_id),@ylxzbh  
    ,case when @cfts>0 and @cflx = 3 and @cfts%7 = 0 then '1' else '0' end  
    ,isnull(@ghxhtmp,-1),@now,isnull(@wsbz,0),isnull(@wsts,0),@tbzddm,@tbzdmc,@yscfbz --add by yfq @20120528  
    from #brxxk a,YY_ZGBMK b(nolock)  
    where b.id=@ysdm  
   if @@error<>0 or @@rowcount=0  
   begin  
    select "F","�����շѴ�������"  
    rollback tran  
    deallocate cs_mzsf  
    return  
   end  
   
   select @xhtemp=@@identity  
    
   insert into SF_CFMXK(cfxh, cd_idm, gg_idm, dxmdm, ypmc, ypdm, ypdw, dwxs, ykxs, ypfj, ylsj,   
    ypsl, ts, cfts, zfdj, yhdj, memo, ypgg, shbz, flzfdj,txbl,lcxmdm,lcxmmc,zbz,hjmxxh,lcxmsl,dydm  
    ,lcjsdj,yjqrbz,zje,wsbz) --add "dydm" 20070119 --agg 2004.07.09 ����lcxmdm,lcxmmc,zbz  
   select @xhtemp, idm, gg_idm, dxmdm, ypmc, xxmdm, ypdw, dwxs, ykxs, ypfj, ylsj,   
    fysl, 1, cfts, zfdj, yhdj, convert(varchar(100),memo) memo, ypgg, shbz, flzfdj,txbl,lcxmdm,lcxmmc,zbz,hjmxxh,lcxmsl,dydm   
    ,lcjsdj,case when @hjcfjlzt in (3,8) and @cflx not in (1,2,3,7) and @sqdlb <> '99' then 1   
    when @sqdlb ='99' then 8 else yjqrbz end--add "dydm" 20070119  --agg 2004.07.09 ����lcxmdm,lcxmmc,zbz  
    ,isnull(round(fysl*ylsj*cfts/ykxs,2),0),isnull(mxwsbz,0)  
    from #sfmx where cfxh=@cfxh order by ind  
   if @@error<>0  
   begin  
    select "F","�����շѴ�����ϸ����"  
    rollback tran  
    deallocate cs_mzsf  
    return    
   end  
  end  
  else  
  begin  
   if exists(select 1 from #sfmx where cfxh=@cfxh and isnull(ejygbz,0)=0)  
   begin  
    insert into SF_MZCFK(jssjh, hjxh, czyh, lrrq, patid, hzxm, ybdm, py, wb,   
     ysdm, ksdm, yfdm, qrczyh, qrrq, qrksdm, pyczyh, pyrq, cfts, txh, sfckdm,   
     pyckdm, fyckdm, jsbz, jlzt, fybz, cflx, sycfbz, tscfbz, pybz, jcxh, memo, cfxh,zje,zfyje,yhje,zfje, sqdxh  
     ,ejygbz, ejygksdm,xzks_id,ylxzbh,tmhdbz,ghxh,gxrq,wsbz,wsts,cftszddm,cftszdmc,yscfbz)  
    select @sjh, @hjxh, @czyh, @now, a.patid, a.hzxm, @ybdm, a.py, a.wb,  
     @ysdm, @ksdm, @yfdm, '', '', '', '', '', @cfts, null, @sfckdm,  
     @pyckdm, @fyckdm, 1, 9, @fybz, @cflx, @sycfbz, @tscfbz, 0, null, null, @cfxh,@zjecf,@zfyjecf,@yhjecf,@zfje, @sqdxh  
     ,0,  "", isnull(b.xzks_id,b.ks_id),@ylxzbh  
     ,case when @cfts>0 and @cflx = 3 and @cfts%7 = 0 then '1' else '0' end  
     ,isnull(@ghxhtmp,-1),@now,isnull(@wsbz,0),isnull(@wsts,0),@tbzddm,@tbzdmc,@yscfbz  --add by yfq @20120528  
     from #brxxk a,YY_ZGBMK b(nolock)  
    where b.id=@ysdm   
    if @@error<>0 or @@rowcount=0  
    begin  
     select "F","�����շѴ�������"  
     rollback tran  
     deallocate cs_mzsf  
     return  
    end  
    
    select @xhtemp=@@identity  
     
    insert into SF_CFMXK(cfxh, cd_idm, gg_idm, dxmdm, ypmc, ypdm, ypdw, dwxs, ykxs, ypfj, ylsj,   
     ypsl, ts, cfts, zfdj, yhdj, memo, ypgg, shbz, flzfdj,txbl,lcxmdm,lcxmmc,zbz,hjmxxh,lcxmsl,dydm  
     ,lcjsdj,zje,yjqrbz,wsbz) --add "dydm" 20070119  --agg 2004.07.09 ����lcxmdm,lcxmmc,zbz  
    select @xhtemp, idm, gg_idm, dxmdm, ypmc, xxmdm, ypdw, dwxs, ykxs, ypfj, ylsj,   
     fysl, 1, cfts, zfdj, yhdj, memo, ypgg, shbz, flzfdj,txbl,lcxmdm,lcxmmc,zbz,hjmxxh,lcxmsl,dydm   
     ,lcjsdj--add "dydm" 20070119  --agg 2004.07.09 ����lcxmdm,lcxmmc,zbz  
     ,isnull(round(fysl*ylsj*cfts/ykxs,2),0),yjqrbz,isnull(mxwsbz,0)  
     from #sfmx where cfxh=@cfxh  and isnull(ejygbz,0)=0 order by ind  
    if @@error<>0  
    begin  
     select "F","�����շѴ�����ϸ����"  
     rollback tran  
     deallocate cs_mzsf  
     return    
    end  
   end  
  
   if exists(select 1 from #sfmx where cfxh=@cfxh and isnull(ejygbz,0)=1)  
   begin  
    insert into SF_MZCFK(jssjh, hjxh, czyh, lrrq, patid, hzxm, ybdm, py, wb,   
     ysdm, ksdm, yfdm, qrczyh, qrrq, qrksdm, pyczyh, pyrq, cfts, txh, sfckdm,   
     pyckdm, fyckdm, jsbz, jlzt, fybz, cflx, sycfbz, tscfbz, pybz, jcxh, memo, cfxh,zje,zfyje,yhje,zfje, sqdxh  
     ,ejygbz, ejygksdm,xzks_id,ylxzbh,tmhdbz,ghxh,gxrq,wsbz,wsts,cftszddm,cftszdmc,yscfbz)  
    select @sjh, @hjxh, @czyh, @now, a.patid, a.hzxm, @ybdm, a.py, a.wb,  
     @ysdm, @ksdm, @yfdm, '', '', '', '', '', @cfts, null, @sfckdm,  
     @pyckdm, @fyckdm, 1, 9, @fybz, @cflx, @sycfbz, @tscfbz, 0, null, null, @cfxh,@zjecf,@zfyjecf,@yhjecf,@zfje, @sqdxh  
     ,1,  @ksdm ,isnull(b.xzks_id,b.ks_id),@ylxzbh  
     ,case when @cfts>0 and @cflx = 3 and @cfts%7 = 0 then '1' else '0' end  
     ,isnull(@ghxhtmp,-1),@now,isnull(@wsbz,0),isnull(@wsts,0),@tbzddm,@tbzdmc,@yscfbz  --add by yfq @20120528  
     from #brxxk a,YY_ZGBMK b(nolock)  
    where b.id=@ysdm   
    if @@error<>0 or @@rowcount=0  
    begin  
     select "F","�����շѴ�������"  
     rollback tran  
     deallocate cs_mzsf  
     return  
    end  
    
    select @xhtemp=@@identity  
    
    insert into SF_CFMXK(cfxh, cd_idm, gg_idm, dxmdm, ypmc, ypdm, ypdw, dwxs, ykxs, ypfj, ylsj,   
     ypsl, ts, cfts, zfdj, yhdj, memo, ypgg, shbz, flzfdj,txbl,lcxmdm,lcxmmc,zbz,hjmxxh,lcxmsl,dydm  
     ,lcjsdj,zje,yjqrbz,wsbz) --add "dydm" 20070119  --agg 2004.07.09 ����lcxmdm,lcxmmc,zbz  
    select @xhtemp, idm, gg_idm, dxmdm, ypmc, xxmdm, ypdw, dwxs, ykxs, ypfj, ylsj,   
     fysl, 1, cfts, zfdj, yhdj, memo, ypgg, shbz, flzfdj,txbl,lcxmdm,lcxmmc,zbz,hjmxxh,lcxmsl,dydm   
     ,lcjsdj--add "dydm" 20070119  --agg 2004.07.09 ����lcxmdm,lcxmmc,zbz  
     ,isnull(round(fysl*ylsj*cfts/ykxs,2),0),yjqrbz,isnull(mxwsbz,0)  
     from #sfmx where cfxh=@cfxh  and isnull(ejygbz,0)=1 order by ind  
    if @@error<>0  
    begin  
     select "F","�����շѴ�����ϸ����"  
     rollback tran  
     deallocate cs_mzsf  
     return    
    end      
   end    
  end   
  
  --���븨����  
  insert into SF_MZCFK_FZ(jssjh,hjxh,cfxh,patid,ccfbz)  
  values(@sjh,@hjxh,@xhtemp,@patid,@ccfbz)  
  if @@error<>0  
  begin  
   select "F","�����շѴ�����ϸ����"  
   rollback tran  
   deallocate cs_mzsf  
   return    
  end  
    
  select @yjclfbz_temp=yjclfbz from #mzsftmp where cfxh=@cfxh  
  
  insert into SF_CFMXK_FZ(cfxh,mxxh,hjmxxh,yjclfbz,sl,se,sqje,shje)  
  select @xhtemp,a.xh,a.hjmxxh,@yjclfbz_temp   
   ,isnull(b.sl,0)              --˰��  
   ,round(a.ypsl*(a.ylsj-a.yhdj)*isnull(b.sl,0)*a.cfts/a.ykxs,2)  --˰��  
   ,round(a.ypsl*(a.ylsj-a.yhdj)*a.cfts/a.ykxs,2)      --˰ǰ���  
   ,round(a.ypsl*(a.ylsj-a.yhdj)*(1-isnull(b.sl,0))*a.cfts/a.ykxs,2) --˰����  
  from SF_CFMXK a  
   left join YY_SFXXMK b on  a.ypdm=b.id and a.cd_idm=0  
  where cfxh=@xhtemp  
    
  if @@error<>0  
  begin  
   select "F","�����շѴ�����ϸ����"  
   rollback tran  
   deallocate cs_mzsf  
   return    
  end    
    
     fetch cs_mzsf into @cfxh, @ksdm, @ysdm, @yfdm, @hjxh, @cflx, @sycfbz, @tscfbz, @cfts, @pyckdm, @fyckdm,@zjecf,@zfyjecf,  
     @yhjecf,@zfje,@ejygbz,@ejygksdm,@fybz,@wsbz,@wsts,@tbzddm,@tbzdmc,@yscfbz,@ccfbz,@ghxhtmp --add by ozb ���Ӷ���ҩ���־  
 end  
 close cs_mzsf  
 deallocate cs_mzsf  
 --��������ϸ������ݸ��µ�������ϸ��   
 update a set ssbfybz=b.ssbfybz,a.ldcfxh=b.ldcfxh,a.ldmxxh=b.ldmxxh  from SF_CFMXK a,SF_HJCFMXK b,#sfzd c where a.hjmxxh=b.xh and b.cfxh=c.hjxh  
 if @@error<>0  
 begin  
  select "F","���´�����ϸ�����"  
  rollback tran  
  return    
 end  
 --����131729 SF_HJCFMXK_FZ(fzxh��fzbz)   
 update a set fzbz=b.fzbz,fzxh=b.fzxh from SF_CFMXK_FZ a,SF_HJCFMXK_FZ b,#sfzd c where a.hjmxxh=b.mxxh and b.cfxh=c.hjxh  
 if @@error<>0  
 begin  
  select "F","���´�����ϸ���������"  
  rollback tran  
  return    
 end  
  
 IF @qkbz2=2  
  SELECT @sfje2=@sfje2-@srje, @srje=0  
  
 insert into SF_BRJSK(sjh, patid, ghsjh, ghxh, fph, fpjxh, czyh, sfrq, sfksdm, ksdm,   
  hzxm, blh, ybdm, pzh, sfzh, ylxm, zddm, dwbm, zje, zfyje, yhje, deje, zfje,   
  zpje, zph, xjje, srje, qkbz, qkje, zxlsh, jslsh, ybjszt, zhbz, tsjh, jlzt, cardno,  
  cardtype, ghsfbz, jcxh, memo, mjzbz, brlx, flzfje, qrbz, tcljje, tcljbz, tjmfbz,lcyhje,gxrq,lrrq  
  ,yhdm,appjkdm)  
 select @sjh, patid, @ghsjh, @ghxh, null, null, @czyh, @now, @sfksdm, @ksdm,  
  hzxm, blh, @ybdm, pzh, sfzh, @xmlb, @zddm, dwbm, @zje+@zje1, @zfyje+@zfyje1, @yhje+@yhje1, 0, @sfje2,  
  0, '', 0, @srje, @qkbz1, @qkje, null, null, 0, @zhbz, null, 0, cardno,  
  cardtype, 1, null, null, @mjzbz, @brlx, @flzfje+@flzfje1, @qrbz, @tcljje1, @tcljbz, @tjmfbz   
  ,@lcyhje,@now,@now,@yhdm,@kfsdm  
  from #brxxk  
 if @@error<>0  
 begin  
  select "F","��������˵�����"  
  rollback tran  
  return    
 end  
  
 insert into SF_BRJSMXK(jssjh, dxmdm, dxmmc, fpxmdm, fpxmmc, xmje, zfje, zfyje, yhje, memo, flzfje,lcyhje)  
 select @sjh, dxmdm, dxmmc, mzfp_id, mzfp_mc, xmje, zfje, zfyje, yhje, null, flzfje,lcyhje  
  from #sfmx1  
 if @@error<>0  
 begin  
  select "F","���������ϸ����"  
  rollback tran  
  return    
 end  
   
 if exists (select 1 from sysobjects where name='SF_BRJSK_FZ' and xtype='U')  
 BEGIN  
  if exists(select 1 from SF_BRJSK_FZ where sjh = @sjh)  
  begin  
   delete from SF_BRJSK_FZ where sjh = @sjh  
   if @@error<>0  
   begin  
    select "F","���SF_BRJSK_FZ�ظ���¼����"  
    rollback tran  
    return    
   end   
  end   
             
        -- add 20141104 kcs �����շѼ�¼������ϸ��û���Ż���˼�¼�������Ż�ԭ��    
  if not exists(select 1 from SF_CFMXK where cfxh in (select xh from SF_MZCFK where jssjh = @sjh) and yhdj <> 0)  
      select @yhyy = ''  
  
  insert into SF_BRJSK_FZ  
  (sjh,patid,ghsjh,ghxh,fph,fpjxh,ip,mac,sfly,yhyydm)  
  select                  
  @sjh, @patid, @ghsjh, @ghxh, null, null,'',@wkdz,@sfly,@yhyy  
  if @@error<>0  
  begin  
   select "F","��������˵�����"  
   rollback tran  
   return  
  end   
 END  
   
 --ҽ��������ص��ж�  
 if exists(select 1 from sysobjects where name='usp_sf_sfcl_ybkz' and type='P')   
 begin  
  exec usp_sf_sfcl_ybkz @patid,@sjh,0,@outmsg output  
  if substring(@outmsg,1,1)<>'T'  
  begin  
   select 'F',@outmsg  
   rollback tran  
   return  
  end  
 end  
 --ҩƷ�����ε��ۼ��㴦���߼�  
 declare @isdlsjfa ut_bz, --�Ƿ���ö����ۼ۷�����0�����ã�1���ã�  
  @ypxtslt int,--���ۼ۷���  
  @cfmxxh_temp ut_xh12,@cfxh_temp ut_xh12,  
  @djpcxh ut_xh12,--����ָ���������(Ĭ��Ϊ0����3183�������򣬶����Σ�  
  @rtnmsg varchar(50), --������Ϣ  
  @totalYplsje ut_je14, --�������β�ֺ������۽��  
  @totalYpjjje ut_je14, --�������β�ֺ��ܽ��۽��  
  @avgYplsj ut_money,  --�������β�ֺ�ƽ��ҩƷ���ۼ�  
  @avgYpjj ut_money,  --�������β�ֺ�ƽ��ҩƷ����  
  @yfpcxhlist  varchar(500), --�������β�ֺ�ҩ����������б� �Զ��ŷָ�  
  @yfpcsllist  varchar(500), --�������β�ֺ�ҩ�����������б� �Զ��ŷָ�  ˳���@yfpcxhlistһ��  
  @zje_cs  ut_money,   --������ܽ��  
  @sfje_cs ut_money,   --�����ʵ�ս��  
  @ybje_cs ut_money,   --�����ҽ�����   
  @flzfje_cs ut_money, --���������Ը����  
  @yjzfje_cs ut_money  --�����Ԥ����֧�����  
 select @isdlsjfa=0,@ypxtslt=0  
 if exists(select 1 from sysobjects where name='f_get_ypxtslt')   
 begin  
  select @ypxtslt=dbo.f_get_ypxtslt()    
  if @ypxtslt=3   
  select @isdlsjfa=1  
 end  
 if @isdlsjfa=1 and exists(select 1 from SF_MZCFK a,SF_CFMXK b where a.jssjh=@sjh and a.xh=b.cfxh and a.cflx in(1,2,3))  
 begin  
    --add by l_jj 2017-11-05 for 210848 �Ƚⶳҽ��  
        if exists(select 1 from YY_CONFIG (nolock) where id='3525' and config='��')  
           and exists(select 1 from SF_MZCFK (nolock) where jssjh=@sjh and cflx in(1,2,3) and isnull(hjxh,0)<>0)  
     begin  
            declare @hjxh_temp   ut_xh12,  
                    @i           ut_xh12,  
                    @count       int  
            create table #ypdj_hjxh  
 (  
                xh      ut_xh12 identity not null,  
                hjxh    ut_xh12          not null  
            )  
   create table #result  
   (  
       resultcode  ut_mc16,  
    resultmsg   ut_mc256  
   )  
            insert into #ypdj_hjxh(hjxh)  
            select distinct hjxh from SF_MZCFK (nolock) where jssjh=@sjh and cflx in(1,2,3) and isnull(hjxh,0)<>0  
  
            select @i=1  
            select @count=count(1) from #ypdj_hjxh  
          
            if isnull(@count,0)>0  
            begin  
                select @rtnmsg=''  
    delete from #result insert into #result exec usp_yf_mzys_ypdpcdj_undo @wkdz,1,0,@rtnmsg output  
                if @rtnmsg like 'F%'  
                begin  
                    select 'F','ҩƷ�ⶳ����1��'+@rtnmsg  
                    rollback tran  
                    return  
                end  
  
                while @i<=@count  
                begin  
                    select @hjxh_temp=hjxh from #ypdj_hjxh where xh=@i  
  
                    select @rtnmsg=''  
                    delete from #result insert into #result exec usp_yf_mzys_ypdpcdj_undo @wkdz,2,@hjxh_temp,@rtnmsg output  
                    if @rtnmsg like 'F%'  
                    begin  
                        select 'F','ҩƷ�ⶳ����2��'+@rtnmsg  
                        rollback tran  
                        return  
                    end  
  
                    select @i=@i+1  
                end  
  
                select @rtnmsg=''  
                delete from #result insert into #result exec usp_yf_mzys_ypdpcdj_undo @wkdz,3,0,@rtnmsg output  
                if @rtnmsg like 'F%'  
                begin  
                    select 'F','ҩƷ�ⶳ����3��'+@rtnmsg  
                    rollback tran  
                    return  
                end  
            end  
        end  
  
  declare cs_mzsf_dpcjgcl cursor for  
  select b.xh,a.xh  from SF_MZCFK a,SF_CFMXK b where a.jssjh=@sjh and a.xh=b.cfxh and a.cflx in(1,2,3)  
  for read only  
  open cs_mzsf_dpcjgcl  
  fetch cs_mzsf_dpcjgcl into @cfmxxh_temp,@cfxh_temp  
  while @@fetch_status=0  
  begin  
   select @rtnmsg ='',@totalYplsje =0,@totalYpjjje =0,@avgYplsj =0,@avgYpjj =0,@yfpcxhlist ='',@yfpcsllist =''  
  
   exec usp_yf_mzsf_ypdpcdj_inf 1,@cfmxxh_temp,0,0,@rtnmsg output,@totalYplsje output,@totalYpjjje output,@avgYplsj output,@avgYpjj output,@yfpcxhlist output,@yfpcsllist output  
   if substring(@rtnmsg,1,1)<>'T'  
   begin  
    select 'F','ҩƷ�����ε��ۼ������'+@rtnmsg  
    rollback tran  
    deallocate cs_mzsf_dpcjgcl  
    return  
   end  
   update SF_CFMXK set zje=@totalYplsje,ylsj=@avgYplsj where xh=@cfmxxh_temp and cfxh=@cfxh_temp  
   if @@error<>0  
   begin  
    select 'F','ҩƷ�����ε��ۼ���������´�����ϸ�����ۼ�ʱ����'  
    rollback tran  
    deallocate cs_mzsf_dpcjgcl  
    return  
   end  
   fetch cs_mzsf_dpcjgcl into @cfmxxh_temp,@cfxh_temp  
  end  
  close cs_mzsf_dpcjgcl  
  deallocate cs_mzsf_dpcjgcl  
    
  ---for vsts 225606 by maoyong 20171117 begin  
  declare @yhcs varchar(20)  
  select @yhcs='��'  
  if exists(select 1 from YY_CONFIG (nolock) where id='2534')  
   select @yhcs=ISNULL(config,'��') from YY_CONFIG (nolock) where id='2534'  
  
    
  if @yhcs='��'  and  @zfbz = 3   
  begin  
      select b.xh,a.jssjh,b.cd_idm,c.sxjg,c.yhbl  into #tempdpcyhcl  from SF_MZCFK a,SF_CFMXK b,YY_TSSFXMK c   
   where a.jssjh=@sjh and  a.xh=b.cfxh and a.cflx in(1,2,3) and b.cd_idm=c.idm and b.cd_idm>0 and c.ybdm =@ybdm   
     
   update a set yhdj = case when b.sxjg<a.ylsj and b.sxjg>0 then sxjg else convert(numeric(10,2),ylsj*yhbl) end   
    from  SF_CFMXK a   
   inner join #tempdpcyhcl b on a.xh =b.xh   
  
   update a set zfdj =ylsj-yhdj   
    from  SF_CFMXK a   
   inner join #tempdpcyhcl b on a.xh =b.xh   
  
  end  
    
  ---for vsts 225606 by maoyong 20171117 end  
    
    
  --���봦����ϸ������  
  insert into SF_CFMXK_DPC(cfmxxh,cfxh,pcxh,cd_idm,ypmc,ypdm,ylsj,ypsl,memo)  
  select b.xh,b.cfxh,c.pcxh,b.cd_idm,b.ypmc,b.ypdm,c.yplsj,c.djk_djsl,'' from SF_MZCFK a,SF_CFMXK b,YF_YPDJJLK c   
  where a.jssjh=@sjh and a.xh=b.cfxh and a.cflx in(1,2,3)  
    and b.xh=c.mxxh and b.cfxh=c.zd_xh and c.mxtbname='SF_CFMXK'   
  if @@error<>0  
  begin  
   select 'F','���봦����ϸ������SF_CFMXK_DPC����'  
   rollback tran  
   return  
  end   
    
    
    
    
    
  --�������㣬�۸�䶯  
  --ע�⣺�Ϻ�ҽ����֧�֣�����̫���ӣ�ǣ��ҽ���㷨��ά�������Դ˴�δ����  
  exec usp_sf_sfcl_jecs @sjh,@rtnmsg output,@zje_cs output, @sfje_cs output,@ybje_cs output, @flzfje_cs output, @yjzfje_cs output  
  if substring(@rtnmsg,1,1)<>'T'  
  begin  
   select 'F','�����������'+@rtnmsg  
   rollback tran  
   return  
  end  
 end  
 if @config2466='��'  
 begin  
  exec usp_sf_lcxmyhjs @sjh,@rtnmsg output,@zje_cs output, @sfje_cs output,@ybje_cs output, @flzfje_cs output, @yjzfje_cs output  
  if substring(@rtnmsg,1,1)<>'T'  
  begin  
   select 'F','�ٴ���Ŀ�Żݽ������'+@rtnmsg  
   rollback tran  
   return  
  end   
 end  
 commit tran  
 if (@isdlsjfa=1 and exists(select 1 from SF_MZCFK a,SF_CFMXK b where a.jssjh=@sjh and a.xh=b.cfxh and a.cflx in(1,2,3))) or (@config2466='��')  
  select "T",@sjh,@zje_cs, @sfje_cs,@ybje_cs, @flzfje_cs, @yjzfje_cs,  
  @ybzje, @ybjszje, @ybzlf, @ybssf, @ybjcf, @ybhyf, @ybspf, @ybtsf, @ybxyf, @ybzyf, @ybcyf, @ybqtf, @ybgrzf,@jfbz,@jfje --20--21  
 else  
  select "T", @sjh, @zje+@zje1, @sfje2-@qkje, @ybje+@ybje1, @flzfje+@flzfje1, @yjzfje,  
  @ybzje, @ybjszje, @ybzlf, @ybssf, @ybjcf, @ybhyf, @ybspf, @ybtsf, @ybxyf, @ybzyf, @ybcyf, @ybqtf, @ybgrzf,@jfbz,@jfje --20--21  
  
 /*�շ���Ϣ���� end*/  
  
end  
return  
  
  
  
  
  
  
  
  
  
  
  
  