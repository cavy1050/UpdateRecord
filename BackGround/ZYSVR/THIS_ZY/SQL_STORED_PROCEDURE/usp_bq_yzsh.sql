ALTER proc usp_bq_yzsh  
 @syxh ut_syxh,--��ҳ���   
    @czyh ut_czyh,--����Ա��  
 @shlb smallint = 0,--������0=ȫ��ҽ����1=����ҽ��  
 @yzbz smallint = 0,--ҽ�����0=��ʱ��1=����, -1, ȫ��  
 @fzxh ut_xh12 = null,--ҽ�����  
 @yexh ut_syxh = 0,--Ӥ�����  
 @maxcqyzxh ut_xh12 =0,--�����ҽ�����  
 @maxlsyzxh ut_xh12 =0,--�����ʱҽ�����  
 @LSfzxh varchar(200) = '',--��˲�ͨ������ʱҽ��������ż���  
 @CQfzxh varchar(200) = '',--��˲�ͨ���ĳ���ҽ��������ż���  
 @dqksdm ut_ksdm='',--��ǰ��¼���Ҵ���  
 @emrsybz ut_bz = 0 ,--���Դ 0:��ʿվ�� 1��ҽ��վ  
 @yzlbcondition varchar(100)='', --ҽ������ѯ����  
 @shsj ut_rq16 = '', --ָ�����ʱ�䣬Ϊ����ȡ��ǰʱ��  
 @guid   ut_mc64=''  --��ǰ����Ψһ��        
as --��416223 2018-09-04 14:15:42 4.0��׼��  
/**********  
[�汾��]4.0.0.0.0  
[����ʱ��]2004.12.1  
[����]����  
[��Ȩ] Copyright ? 2004-2008�Ϻ����˴�-��������ɷ����޹�˾[����]ҽ�����  
[����˵��]  
 ���˵���ҽ����ȫ��ҽ�����  
[����˵��]  
 @syxh ut_syxh,  ��ҳ���  
     @czyh ut_czyh,  ����Ա��  
 @shlb smallint = 0, ������0=ȫ��ҽ����1=����ҽ��  
 @yzbz smallint = 0, ҽ�����0=��ʱ��1=����, -1, ȫ��  
 @fzxh ut_xh12 = null, ҽ�����  
 @yexh ut_syxh = 0 Ӥ�����, Add by Wang Yi, 2003.03.03  
 @maxcqyzxh ut_xh12 =0,  �����ҽ�����   add by agg 2004.05.17  
 @maxlsyzxh ut_xh12 =0,  �����ʱҽ�����   add by agg 2004.05.17  
 @LSfzxh varchar(100) = '', ��˲�ͨ������ʱҽ��������ż���    
 @CQfzxh varchar(100) = ''  ��˲�ͨ���ĳ���ҽ��������ż���  
 @emrsybz ut_bz = 0 0:��ʿվҽ����ˣ� 1��ҽ��վҽ�����  
[����ֵ]  
[�����������]  
[���õ�sp]  
[����ʵ��]  
[�޸�˵��]  
Modify By Koala 2002.02.19 ���ʱ����ҽ�������жϣ���������˳���/��ʱҽ����  
          hkh 2003.11.13   ˭ֹͣҽ����ҽ��ֹͣ����ʾ˭,������ʾֹͣҽ���������  
         BQ_CQYZK.tzysdm ��Ϊ BQ_LSYZK.lrczyh ��ԭΪBQ_CQYZK.ysdm  
         ҽ��ֹͣ����ʾ:BQ_CQYZK.tzysdm,ԭΪBQ_CQYZK.tzczyh(�����ֹͣҽ�����ˣ�   
 gaowen 2003.12.29 isnull(c.memo,c.ysdm)��д�������⣬��Ϊcase����when  
 yxp 2004-02-25 ����memo��д��������usp_bq_tzyzʱû���ж�@@error  
        agg 2004.05.17 ���������ҽ����ź������ʱҽ����ţ����ʱ���ܴ��������ţ��Է�ֹҽ���ͻ�ʿͬʱ����ʱ����ҽ����ʿû��������.  
 hhr 2004-07-08 ��ʱҽ���������ϱ��浽BQ_LSJZK  
 mit, 2oo4-11-19 ,CLJZ  
 Modify By Koala 2005.04.13 Modify ������������״̬���ж�(����������˺���֪ͨ���������Ҳ��ܽ��ջ��������ҿ���ֱ�ӽ���)     
 wuming update ���ϼ���ȫ��תΪ��������ϼ��ˣ�ȥ����ģʽ��֧�� Modify  at 20050523  
 Modify By Koala 2006.08.07 ����ְ����˸��� �������12690  
**********/  
set nocount on  
if(isnull(@czyh,'')='')
begin
select 'F','����Ա���Ų���Ϊ�գ�'
return
end  
declare @now varchar(16),  
 @tzxh ut_xh12,  --ֹͣҽ���������  
 @ysdm ut_czyh,  --ҽ������  
 @tzrq ut_rq16,  --ֹͣ����  
 @yzlb smallint,  --ҽ�����  
 @ksrq ut_rq16,  --��ʼ����  
 @ypdm ut_xmdm,  --ҩƷ����  
 @mzdm ut_xmdm,  --�������  
 @ypmc ut_mc256,  --ҩƷ����  
 @zxksdm ut_ksdm, --���Ҵ���  
 @ztnr ut_memo, --��������  
 @errmsg varchar(50),  
 @btbz char(2),  
 @ispc char(2),  --�Ƿ�ʹ�ô�Ƶ�εĲ��ϼ���  
 @issh varchar(4),       --����ҩƷ�Ƿ������  
 @shnr varchar(255)    --ҩƷû��ͨ�������Ϣ  
 ,@execmsg varchar(8000)  
 ,@ssql varchar(1000)  
  
declare @iscansssq char(2),  
 @ssjlzt ut_bz,  
 @ssdj ut_bz  
declare @configG014 char(2),  --�Ƿ���סԺҽ��վ�����ҽ�����  
 @configG106 char(2),  --ҽ������Ƿ�����Ϣ����ʿվ(G014="��"��Ч)  
 @fsip varchar(32),   --���ͷ�IP��ַ  
 @jsbq varchar(32),  --������ ,������ְ�������ң�����  
 @brcw varchar(32),  --���˴�λ  
 @hzxm ut_mc64,  --��������  
 @msg varchar(255),   --��Ϣ����  
 @configG107 ut_xmdm,  
 @configG108 ut_xmdm,  
    @configG153 char(2)         --��Ϣ�Ƿ��Զ���ӡ  
    ,@config6461 char(2)         --����ҽ����˺��Ƿ�����Ϣ  
    ,@jajbz ut_bz   --�Ƿ��мӼ���ҽ��    0:��   1:��     -1:û��ҽ�������  
    ,@config6480 char(2)   --�Ƿ�ʹ��ҽ��(EMRҽ�����)�뻤ʿ�ֿ���˵Ļ���  
    ,@config6481 char(2)   --��Ժҽ����˷�����Ϣʱ�Ƿ�ŵ�ǰ̨����(������EMR��,����6461Ϊ��������)  
    ,@config6A70 char(2)   --ҽ����˳ɹ����Ƿ񵯳�������˵�ҽ����ϸ  
    ,@config6036 varchar(2)  
    ,@configG236 varchar(2)  
    ,@sfxyzlc int     --�Ƿ�ʹ����ҽ������   
    ,@config6501 varchar(2)  --�Ƿ�ʹ��Χ�����ڿ���  
    ,@configks20 int  
    ,@configG435 varchar(2)  
    ,@yznr varchar(255)  
    ,@tzyy int  
    ,@config6800 varchar(1)   
 ,@config6949 varchar(2) --lyljfs�Ƿ�Ĭ��Ϊ1�����ۼ�  
 ,@config6538 varchar(2) --�Ƿ���ʾ���˵ĳ���ҽ��������Ч���ۼ���ҩ��Ϣ(���ƻ�ʿվ��ҽ��վҽ��¼��)  
 ,@config6A03 varchar(255) --ѡ��������ҩ��ҩ������  
 ,@config6A71 varchar(2)  --�Ƿ��ƽ̨������Ϣ  
 ,@config6A19 varchar(2) --�¿�ҽ���Ƿ���������ģʽ  
 ,@config6A95_ls varchar(50)  --Ĭ�ϵ�ִ��ʱ��Ϊҽ����ʼʱ���Ӻ���ٷ���  ��ʱ  
 ,@config6A95_cq varchar(50)  --Ĭ�ϵ�ִ��ʱ��Ϊҽ����ʼʱ���Ӻ���ٷ���  ����  
 ,@config6142 varchar(2)    --С�����Ƿ����ɵ���ʱҽ��  
 ,@config6583 varchar(2)    --С�����Ƿ�Ҫ������˺��������ҩ��Ϣ  
 ,@config6C54 varchar(200)  --����ҽ�����ͬ�����»�ʿִ��ҽ����ִ�м���ʿǩ����ҽ����𼯺�  
 ,@config6A38 VARCHAR(2) --�Ƿ񽫲��˵�����д��ƽ̨�м��  
 ,@config6C58 varchar(64)  
 ,@brfyye  ut_money --���˷������  
 ,@qkbz   smallint  
 ,@cydyfyye  ut_money --���˷������  
 ,@error_count int   --ҽ����ͨ��ҽ���Ƿ����   1 ����   0 ������  
  
--add by kongwei ����6A38 ESB�ӿ�ר��  
declare @syxh_1 varchar(12),@yexh_1 varchar(12),@maxlsyzxh_1 varchar(12),@xhtemp_dyz_1 varchar(12),@xhtemp_1 varchar(12)   
  
declare @yzbh_cqlsbz ut_bz,   --������ʱ��־   
    @yzbh_syxh ut_xh12,  
    @yzbh_yzxh ut_xh12,  
    @yzbh_zxks ut_ksdm,  
    @yzbh_bqdm ut_ksdm,       
    @yzbh_xtbz ut_bz,  
    @yzbh_pcsj ut_dm5,  
    @shr ut_czyh,  
    @yzzt ut_bz  
declare @shyzcount int --���ҽ������  
DECLARE @config6788 BIT --add by zll for 189327�Ϻ��ж�ͯҽԺ����������ϵͳ ҽ����� �Ƿ����þܾ�ͨ����˹���  
SELECT @config6788=1                          
SELECT @config6788=(SELECT CASE WHEN isnull(config,'��')='��'then 0 else 1 end from YY_CONFIG where id='6788')                        
select @jajbz=-1 ,@execmsg=''     
  
select @shyzcount = 0  
select @config6480='��'  
select @config6480=isnull(config,'��') from YY_CONFIG where id='6480'  
select @config6142=isnull(config,'��') from YY_CONFIG where id='6142'  
select @config6583=isnull(config,'��') from YY_CONFIG where id='6583'  
select @configG014=isnull(config,'��') from YY_CONFIG where id='G014'  
select @configG106=isnull(config,'��') from YY_CONFIG where id='G106'  
select @configG107=isnull(config,'') from YY_CONFIG where id='G107' --Σ������ҽ������  
select @configG108=isnull(config,'') from YY_CONFIG where id='G108' --Σ������ҽ������    
select @config6800=isnull(config,'1') from YY_CONFIG where id='6800'--ҽ����˱��ZY_BRSYK.wzjb�ķ�ʽ 0:������ 1:���ݲ��� G107 �� G108 ���� 2: ����5.0ҽ��վ��yzlb=16,17����  
if @shsj = ''   
begin  
 select @now=convert(char(8),getdate(),112)+convert(char(8),getdate(),8)  
end  
else  
begin  
 select @now=@shsj  
end  
select @iscansssq=isnull(config,'��') from YY_CONFIG where id='G024'  
select @iscansssq = isnull(@iscansssq,'��')  
select @issh = isnull(config,'��') from YY_CONFIG where id='6293'  
select @shnr = ''  
if @iscansssq ='��'  
 select @ssjlzt = 0  
else  
 select @ssjlzt = -1  
  
select @configG153=isnull(config,'��') from YY_CONFIG where id='G153'  
select @configG153 = isnull(@configG153,'��')  
  
select @config6461=isnull(config,'��') from YY_CONFIG where id='6461'  
select @config6461 = isnull(@config6461,'��')  
  
select @config6481=isnull(config,'��') from YY_CONFIG where id='6481'  
select @config6481 = isnull(@config6481,'��')  
  
select @config6501=isnull(config,'��') from YY_CONFIG where id='6501'  
  
select @config6036 = config from YY_CONFIG where id = '6036'   
select @config6036 = isnull(@config6036,'��')  
select @configG236 = config from YY_CONFIG where id = 'G236'   
select @configG236 = isnull(@configG236,'��')  
  
select @config6A70 = config from YY_CONFIG where id = '6A70'  
select @config6A70 = isnull(@config6A70,'0')    
select @config6A71 = config from YY_CONFIG where id = '6A71'  
select @config6A71 = isnull(@config6A71,'��')    
select @config6A19 = config from YY_CONFIG where id = '6A19'  
select @config6A19 = ISNULL(@config6A19, '0')  
select @config6C54 = ISNULL(config,'') from YY_CONFIG where id = '6C54'  
if @config6C54 <> ''   
begin  
    select @config6C54 = replace(@config6C54, ',', '","')  
    select @config6C54 = '"' + @config6C54 +'"'  
end  
select @config6A38=config from YY_CONFIG where id='6A38'   
SELECT @config6A38=ISNULL(@config6A38,'��')  
----------Ĭ�ϵ�ִ��ʱ��Ϊҽ����ʼʱ���Ӻ���ٷ��� ������ʱ���Ʋ������---------  
if @config6A19 = '4'  
begin  
 declare @config6A95 varchar(100)  
 select @config6A95_cq = '0'  
 select @config6A95_ls = '0'  
 select @config6A95 = config from YY_CONFIG where id = '6A95'  
 if (charindex(',',@config6A95)<>0)   
 begin  
  select @config6A95_cq = substring(@config6A95,1,charindex(',',@config6A95)-1)  
  select @config6A95_ls = substring(@config6A95,charindex(',',@config6A95)+1,len(@config6A95)-charindex(',',@config6A95))  
 end  
 else  
 begin  
  select @config6A95_cq = @config6A95  
 end  
 if @config6A95_cq = ''  
     select @config6A95_cq = '0'  
 if @config6A95_ls = ''  
     select @config6A95_ls = '0'    
end  
-------Ĭ�ϵ�ִ��ʱ��Ϊҽ����ʼʱ���Ӻ���ٷ��� ������ʱ���Ʋ������   ����------  
  
select @configks20=isnull(config,0) from YY_CONFIG where id ='KS20'  
  
if (@config6036='��') and (@configG236='��')   
    select @sfxyzlc=1  
else  
    select @sfxyzlc=0  
  
if exists(select 1 from YY_CONFIG where id='G435' and isnull(config,'��')='��')   
 select @configG435='��'  
else  
 select @configG435='��'     
select @config6949=isnull(config,'��') from YY_CONFIG where id='6949'  
select @config6538=isnull(config,'��') from YY_CONFIG where id='6538'  
select @config6A03 = isnull(config,'') from YY_CONFIG where id='6A03'  
select @config6C58=config from YY_CONFIG where id='6C58'   
SELECT @config6C58=ISNULL(@config6C58,'')  
  
--��ǰ̨����0������˵�����ԣ��ָ������ֵ�������������������ʱ��ǰ̨�������ˣ�����̨û��������ǰ̨û��@maxcqyzxh��@maxlsyzxh��ֵ��  
--����������䣬�Ͳ������ǰ̨��ҽ��ִ���ˣ���ʵ��û����ִ�е����  
if @maxcqyzxh  =0   
 select @maxcqyzxh=999999999999  
  
if @maxlsyzxh  =0  
 select @maxlsyzxh=999999999999  
   
--KS20������6501������Ч  
IF(@configks20>0)  
BEGIN  
 select @config6501='��'   
END  
  
declare @tablename varchar(32)   
  
create table #sh_yzxh_ls  
(  
 xh ut_xh12  
)  
create table #sh_yzxh_cq  
(  
 xh ut_xh12  
)  
create table #yjm_bq_lsyzk  
(  
 xh ut_xh12  
)  
create table #yjm_bq_cqyzk  
(  
 xh ut_xh12  
)  
  
select @tablename='##sh_yzxh_ls'+convert(varchar(12),@syxh)  
select @ssql ='select xh into '+@tablename+' from BQ_LSYZK a(nolock) where syxh='+convert(varchar(12),@syxh)+' and yzzt = 0 '    
if  (@shlb=1)    
 select @ssql=@ssql+' and fzxh='+convert(varchar(12),@fzxh)    
exec (@ssql)    
exec('insert into #sh_yzxh_ls select * from '+@tablename) --select xh into #sh_yzxh_ls from ##sh_yzxh_ls    
exec('drop table '+@tablename)--drop table ##sh_yzxh_ls    
    
select @tablename='##sh_yzxh_cq'+convert(varchar(12),@syxh)  
select @ssql ='select xh into '+@tablename+' from BQ_CQYZK a(nolock) where syxh='+convert(varchar(12),@syxh)+' and yzzt = 0 '    
if  (@shlb=1)    
 select @ssql=@ssql+' and fzxh='+convert(varchar(12),@fzxh)    
exec (@ssql)    
exec('insert into #sh_yzxh_cq select * from '+@tablename) --select xh into #sh_yzxh_cq from ##sh_yzxh_cq    
exec('drop table '+@tablename)--drop table ##sh_yzxh_cq    
    
--sang+++2014-04-30 ֻ�ܶ�ǰ̨����ͨ����ҽ���������,�˶δ����ֳ����������޸ģ��޸���Ҫ��ѯ��˾������  
--ȡ�ѽ�����ʱҽ��  
--select xh   
--into #yjm_bq_lsyzk  
--from BQ_LSYZK(nolock)   
--where syxh=@syxh --xq205569 ���ڹ�˾���������漰���������ݻ�û�и������,����������ݲ���ҽ������,���Լ��ظò�������ҽ�������ѽ���ҽ����ʱ��  
----and ypsl2=ypsl3 and ypsl2<>'' --��ypsl2Ϊnullʱ��ypsl3ҲΪnull  ypsl2=ypsl3�ǲ�������  
--and yzlb<>15 --�ų���ҩ���ɵ���ʱҽ��  
--if @@error<>0  
--begin  
--  select "F","ȡ�ѽ�����ʱҽ��ʧ�ܣ�"  
--  return     
--end   
select @tablename='##yjm_bq_lsyzk_1'+convert(varchar(12),@syxh)  
if( @yzlbcondition<>'') and (@shlb=0)    
begin    
    select @ssql='select xh into '+@tablename+'  from BQ_LSYZK a(nolock) where syxh='+convert(varchar(12),@syxh)+' and yzlb<>15  and ' +@yzlbcondition    
end    
else    
begin    
    select @ssql='select xh into '+@tablename+'  from BQ_LSYZK a(nolock) where syxh='+convert(varchar(12),@syxh)+' and yzlb<>15  '    
end    
if  (@shlb=1)    
 select @ssql=@ssql+' and fzxh='+convert(varchar(12),@fzxh)    
    
exec (@ssql)    
exec('insert into #yjm_bq_lsyzk select * from '+@tablename) --select xh into #yjm_bq_lsyzk from ##yjm_bq_lsyzk_1    
exec('drop table '+@tablename)--drop table ##yjm_bq_lsyzk_1    
  
--ȡ�ѽ��ܳ���ҽ��  
--select xh   
--into #yjm_bq_cqyzk  
--from BQ_CQYZK(nolock)   
--where syxh=@syxh  --xq205569 ���ڹ�˾���������漰���������ݻ�û�и������,����������ݲ���ҽ������,���Լ��ظò�������ҽ�������ѽ���ҽ����ʱ��  
----and ypsl2=ypsl3 and ypsl2<>'' --��ypsl2Ϊnullʱ��ypsl3ҲΪnull  ypsl2=ypsl3�ǲ�������  
--if @@error<>0  
--begin  
--  select "F","ȡ�ѽ��ܳ���ҽ��ʧ�ܣ�"  
--  return     
--end    
select @tablename='##yjm_bq_cqyzk_1'+convert(varchar(12),@syxh)   
if( @yzlbcondition<>'') and (@shlb=0)    
begin    
    select @ssql='select xh into '+@tablename+'  from BQ_CQYZK a(nolock) where syxh='+convert(varchar(12),@syxh)+'  and ' +@yzlbcondition    
end    
else    
begin    
    select @ssql='select xh into '+@tablename+'  from BQ_CQYZK a(nolock) where syxh='+convert(varchar(12),@syxh)    
end    
if  (@shlb=1)    
 select @ssql=@ssql+' and fzxh='+convert(varchar(12),@fzxh)        
exec (@ssql)    
exec('insert into #yjm_bq_cqyzk select * from '+@tablename) --select xh into #yjm_bq_cqyzk from ##yjm_bq_cqyzk_1    
exec('drop table '+@tablename)--drop table ##yjm_bq_cqyzk_1    
    
delete from #yjm_bq_lsyzk where xh>@maxlsyzxh  
delete from #yjm_bq_cqyzk where xh>@maxcqyzxh  
  
--�����ʱ  
if @yzbz=0 and not exists(select 1 from #yjm_bq_lsyzk)  
begin  
  select "F","�޽��ܳɹ�����ʱҽ������ˣ�"  
  return     
end  
  
--��˳���  
if @yzbz=1 and not exists(select 1 from #yjm_bq_cqyzk)  
begin  
 select "F","�޽��ܳɹ��ĳ���ҽ������ˣ�"  
 return    
end  
  
--�����ʱ�ͳ���  
if not exists(select 1 from #yjm_bq_lsyzk) and not exists(select 1 from #yjm_bq_cqyzk)   
begin  
 select "F","�޽��ܳɹ���ҽ������ˣ�"  
 return      
end  
  
if exists(select 1 from YY_CONFIG (nolock) where id='6B88' and config='��')  
begin  
 select @error_count = 0  
 if exists (select 1 from BQ_LSYZK a (nolock) inner join #yjm_bq_lsyzk b on a.xh=b.xh   
  where  a.syxh=@syxh and a.yexh=@yexh and a.yzzt=0 and a.ksrq>@now  
  )  
 begin  
  select @error_count = 1  
  delete from  #yjm_bq_lsyzk where xh in (select a.xh from BQ_LSYZK a (nolock) inner join #yjm_bq_lsyzk b on a.xh=b.xh   
  where  a.syxh=@syxh and a.yexh=@yexh and a.yzzt=0 and a.ksrq>@now)  
  select @shnr='����δ��ҽ����ʼ���ڵ�ҽ����������ˣ�'  
 end  
 if exists (select 1 from BQ_CQYZK a (nolock) inner join #yjm_bq_cqyzk b on a.xh=b.xh   
  where  a.syxh=@syxh and a.yexh=@yexh and a.yzzt=0 and a.ksrq>@now  
  )  
 begin  
  select @error_count = 1  
  delete from #yjm_bq_cqyzk where xh in (select a.xh from BQ_CQYZK a (nolock) inner join #yjm_bq_cqyzk b on a.xh=b.xh    
  where  a.syxh=@syxh and a.yexh=@yexh and a.yzzt=0 and a.ksrq>@now)  
  select @shnr='����δ��ҽ����ʼ���ڵ�ҽ����������ˣ�'  
 end  
 if (@error_count=1) and (not exists (select 1 from BQ_LSYZK a (nolock) inner join #yjm_bq_lsyzk b on a.xh=b.xh where a.syxh=@syxh and a.yzzt=0)  
  and not exists (select 1 from BQ_CQYZK a (nolock) inner join #yjm_bq_cqyzk b on a.xh=b.xh  where a.syxh=@syxh and a.yzzt=0))  
 begin  
  select "T",@shnr  
  return  
 end  
end  
  
if (select config from  YY_CONFIG (nolock) where id = '6A04')='��'  
begin  
    if @shlb=0  --���ȫ��ҽ�� ֻ��� ysshbz=0��2��  
    begin  
  select @error_count = 0  
        if (@yzbz = 0) or (@yzbz = -1)  -- @yzbz ҽ�����(0:��ʱ, -1:ȫ��)   
        begin  
            if exists (select 1 from BQ_LSYZK a (nolock) inner join #yjm_bq_lsyzk b on a.xh=b.xh   
               where  a.syxh=@syxh and a.yexh=@yexh and a.xh<= @maxlsyzxh and a.yzzt=0 and (a.ysshbz not in (0,2) and isnull(a.v5xh,0)<>0))  
            begin  
    select @error_count = 1  
                delete from  #yjm_bq_lsyzk where xh in (select a.xh from BQ_LSYZK a (nolock) inner join #yjm_bq_lsyzk b on a.xh=b.xh   
                where  a.syxh=@syxh and a.yexh=@yexh and a.xh<= @maxlsyzxh and a.yzzt=0 and (a.ysshbz not in (0,2) and isnull(a.v5xh,0)<>0))            
            end     
               
        end  
        if (@yzbz = 1) or (@yzbz = -1) -- @yzbz ҽ�����(1:����, -1:ȫ��)   
        begin  
            if exists (select 1 from BQ_CQYZK a (nolock) inner join #yjm_bq_cqyzk b on a.xh=b.xh    
            where  a.syxh=@syxh and a.yexh=@yexh and a.xh<=@maxcqyzxh and a.yzzt=0 and (a.ysshbz not in (0,2) and isnull(a.v5xh,0)<>0))  
         begin  
    select @error_count = 1  
                delete from #yjm_bq_cqyzk where xh in (select a.xh from BQ_CQYZK a (nolock) inner join #yjm_bq_cqyzk b on a.xh=b.xh    
                where  a.syxh=@syxh and a.yexh=@yexh and a.xh<=@maxcqyzxh and a.yzzt=0 and (a.ysshbz not in (0,2) and isnull(a.v5xh,0)<>0))  
            end  
        end  
        if (@error_count=1) and (not exists (select 1 from BQ_LSYZK a (nolock) inner join #yjm_bq_lsyzk b on a.xh=b.xh where a.syxh=@syxh and a.yzzt=0)  
   and not exists (select 1 from BQ_CQYZK a (nolock) inner join #yjm_bq_cqyzk b on a.xh=b.xh  where a.syxh=@syxh and a.yzzt=0))  
  begin  
      select "F1","ҽ����ҩʦδ��ˣ�ҽ�����δͨ����"  
      return      
  end  
    end  
    else --������� ysshbz=1�Ĳ���� ҽ����ѯ��ʱ�� �Ѿ������� 0��1��2  
    begin  
  if exists (select 1 from BQ_LSYZK a (nolock) inner join #yjm_bq_lsyzk b on a.xh=b.xh where  a.syxh=@syxh and a.yexh=@yexh and a.xh=@fzxh and a.yzzt=0 and a.ysshbz=1)  
     or exists (select 1 from BQ_CQYZK a (nolock) inner join #yjm_bq_cqyzk b on a.xh=b.xh  where  a.syxh=@syxh and a.yexh=@yexh and a.xh=@fzxh and a.yzzt=0 and a.ysshbz=1)  
  begin  
   select "F1","ҽ����ҩʦδ��ˣ�ҽ�����δͨ����"  
   return  
  end  
    end   
end  
   
select @brfyye = 0 --���˷������  
exec usp_zy_bryjjbj @syxh, 1, 0, @errmsg output  -- ��Ժ����Ԥ���𱨾�����̨���ã�     
if @errmsg like 'F%'   
 select @qkbz=1 --Ƿ���־ 0�� 1��  
else  
 select @brfyye = convert(numeric(14,4),rtrim(ltrim(substring(@errmsg,2,49))))  
  
  
---�������ͨ��ҽ����ʱ������ҽ���ջ�--------------------------------  
declare @config0251 varchar(2), @config6D87 VARCHAR(2)      
select @config0251 =isnull(config,'��') from YY_CONFIG (nolock) where id='0251'   
select @config6D87 =isnull(config,'��') from YY_CONFIG (nolock) where id='6D87'    
  
create table #yshyz  
(  
 yzxh ut_xh12 null,  
 cqlsbz ut_bz null,  
 yzzt ut_bz null  
)  
--------------------------------------------------------------------------  
begin tran --=======�������� ��ʼ============================  
  
-----------------�Ϻ���ͯҽԺ��Ժ��ҩ���--swx 20140227-----  
if (@yzbz=0 or @yzbz=-1)   
 and exists(select 1 from BQ_LSYZK a(nolock) inner join #yjm_bq_lsyzk wls on wls.xh=a.xh   
    left join BQ_LSYZK_FZ b(nolock) on a.xh = b.yzxh   
   where a.syxh=@syxh and a.yzzt= 0 and a.yzlb=12   
    and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
    and (@config6788=1 OR isnull(b.tgbz,1) <> 0)  
    and (@shlb=0 or (@shlb=1 and a.fzxh= isnull(@fzxh,0)))  
 ) -- ȫ�����ʱ����Ժ��ҩҽ������  
begin  
 if exists(select 1 from YY_CONFIG where id='6C03' and config='��')  
 begin  
  select @cydyfyye=0  
  select @cydyfyye=sum(a.ypsl*cd.ylsj)   
  from BQ_LSYZK a(nolock) inner join #yjm_bq_lsyzk wls on wls.xh=a.xh   
   left join BQ_LSYZK_FZ b(nolock) on a.xh = b.yzxh   
   inner join YK_YPCDMLK cd(nolock) on a.idm=cd.idm  
  where a.syxh=@syxh and a.yzzt= 0 and a.yzlb=12   
   and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
   and (@config6788=1 OR isnull(b.tgbz,1) <> 0)  
   and (@shlb=0 or (@shlb=1 and a.fzxh= isnull(@fzxh,0)))  
    
  if @cydyfyye>@brfyye  
  begin  
   delete from  #yjm_bq_lsyzk   
   where xh in (select a.xh from BQ_LSYZK a (nolock) inner join #yjm_bq_lsyzk b on a.xh=b.xh   
    where  a.syxh=@syxh and a.yexh=@yexh and a.yzzt=0 and a.yzlb=12   
    )  
   select @shnr='��Ժ��ҩҩƷ�����ڲ�����������ˣ�'  
   if not exists (select 1 from BQ_LSYZK a (nolock) inner join #yjm_bq_lsyzk b on a.xh=b.xh where a.syxh=@syxh and a.yzzt=0)  
    and not exists (select 1 from BQ_CQYZK a (nolock) inner join #yjm_bq_cqyzk b on a.xh=b.xh  where a.syxh=@syxh and a.yzzt=0)  
   begin  
    rollback  tran  
    select "F",@shnr  
    return  
   end  
  end  
 end  
 if @shnr<>'��Ժ��ҩҩƷ�����ڲ�����������ˣ�'  
 begin  
  declare @syxh_cydy ut_syxh,  
    @yzxh_cydy ut_xh12   
  
  exec usp_bq_cydysh '',1,@syxh_cydy,@delphi = 0,@errmsg = @errmsg output,@usewbtran=1  --ʹ���ⲿ���� 0�� 1��  
  if @errmsg like "F%"  
  begin  
   rollback  tran  
   select "F",substring(@errmsg,2,50)  
   return        
  end    
  declare cs_cydy_yzsh cursor for  --�ڶ���  
   select distinct a.syxh,a.xh   -- ���˴���ĳ�Ժ��ҩ  
   from BQ_LSYZK a(nolock) inner join #yjm_bq_lsyzk wls on wls.xh=a.xh   
    left join BQ_LSYZK_FZ b(nolock) on a.xh = b.yzxh  
   where a.syxh=@syxh and a.yzzt= 0 and a.yzlb=12  
    and (@shlb=0 or (@shlb=1 and a.fzxh= isnull(@fzxh,0)))  
    and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
    and (@config6788=1 OR isnull(b.tgbz,1) <> 0)  
  for read only  
  open cs_cydy_yzsh   
  fetch cs_cydy_yzsh into @syxh_cydy,@yzxh_cydy  
  while @@fetch_status=0 ---�α� cs_cydy_yzsh while Start  
  begin  
   if @config0251='��' or @config6D87='��'--ҽ���ջ�״̬����  
   begin  
    insert into #yshyz   
    select distinct xh,0,2  
    from BQ_LSYZK   
    where syxh=@syxh and xh=@yzxh_cydy-- and yzlb=12 and xh in (select xh from #yjm_bq_lsyzk)   
   end     
   update BQ_LSYZK set yzzt=2,shrq=null,zxrq=null,shczyh=null,zxczyh=null   
   where syxh=@syxh and xh=@yzxh_cydy-- and yzlb=12 and xh in (select xh from #yjm_bq_lsyzk)   
           
   exec usp_bq_cydysh '',2,@syxh_cydy,@yzxh_cydy,@delphi = 0,@errmsg = @errmsg output,@usewbtran=1  --ʹ���ⲿ���� 0�� 1��    
   if @errmsg like "F%"  
   begin  
    rollback  tran  
    select "F",substring(@errmsg,2,50)  
    return        
   end     
       
   fetch cs_cydy_yzsh into @syxh_cydy,@yzxh_cydy  
  end   
  close cs_cydy_yzsh  
  deallocate cs_cydy_yzsh  
  
  exec usp_bq_cydysh '',3,@syxh_cydy,@yzxh_cydy,@czyh,@czyh,@delphi = 0,@errmsg = @errmsg output,@usewbtran=1  --ʹ���ⲿ���� 0�� 1��  
  if @errmsg like "F%"  
  begin  
   rollback  tran  
   select "F",substring(@errmsg,2,50)  
   return        
  end   
 end    
end  
------------------------------------------------------------  
if @shlb=0  ---=======================�������� 0=ȫ��ҽ��  start=====================================  
begin  
 if (select config from  YY_CONFIG (nolock) where id = 'Y002')='��'  --����Y002 (����)�Ƿ���Ҫҽ������ Ϊ �� start  
 begin  
  --�����õ�������¼����Ϊ����  
  update YY_BRSPXMK  
  set yyspsl = b.ypsl  , spbz = 2  
  from YY_BRSPXMK a, BQ_LSYZK b,#yjm_bq_lsyzk wls  
  where a.syxh = @syxh and b.xh=wls.xh  
  and a.syxh = b.syxh  
  and a.idm = b.idm  
  and a.ypdm = b.ypdm  
  and a.spbz = 1  
  and b.yzzt = 0  
  and charindex( ','+convert(varchar(100),b.fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
 end --����Y002 (����)�Ƿ���Ҫҽ������ Ϊ �� end  
 if @@error<>0  
 begin  
  rollback tran  
  select "F","����������Ϣʧ�ܣ�"  
  return  
 end  
  
 --�����õ�ְ��������¼����Ϊ����  
 if exists (select 1 from BQ_BRXZYYSQK(nolock) where syxh = @syxh and spbz = 1)  
 begin  
  --�����õ�������¼����Ϊ����  
  update BQ_BRXZYYSQK  
  set spbz = 2  
  from BQ_BRXZYYSQK a, BQ_CQYZK b,#yjm_bq_cqyzk wcq  
  where a.syxh = @syxh and b.xh=wcq.xh  
  and a.syxh = b.syxh  
  and a.idm = b.idm  
  and a.ypdm = b.ypdm  
  and a.spbz = 1  
  and b.yzzt=0  
  and a.sqry = b.ysdm  
  and charindex( ','+convert(varchar(100),b.fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
 end  
 if @@error<>0  
 begin  
  rollback tran  
  select "F","����ְ��������Ϣʧ�ܣ�"  
  return  
 end  
   
 if (@yzbz = 0) or (@yzbz = -1)  --�������ȫ���������ʱ @yzbz ҽ�����(0:��ʱ, -1:ȫ��) start  
 begin  
  if exists(select 1 from BQ_LSYZK a(nolock) inner join #yjm_bq_lsyzk wls on wls.xh=a.xh   
   where a.syxh=@syxh and a.yexh = @yexh and a.xh<= @maxlsyzxh  and a.yzzt=0 and a.yzlb=2   
    and ( (@sfxyzlc=0) or (isnull(a.ssyzzt,0)=2 )  )  
    )  
  begin ----��if LLLLLL start  
   if (select config from YY_CONFIG (nolock) where id="G090")='��' or @configks20>0  
   begin    
    ----��������G090 ����֪ͨ���Ƿ����� Ϊ ��  ���� KS20����>0 ʹ�ÿ�����ҩƷ����ϵͳ2.0 start  
/*    if exists (select 1 from SS_SSDJK where syxh = @syxh and jlzt = 0 and yzxh = 0 )  
    begin  
     update SS_SSDJK  
     set yzxh = b.xh  
     from SS_SSDJK a , BQ_LSYZK b,SS_SSDJDMK c, SS_SSMZK e    
     where a.syxh = b.syxh  
     and b.syxh = @syxh  
     and b.yexh = @yexh  
     and b.xh <= @maxlsyzxh   
     and b.yzzt = 0   
     and b.yzlb = 2  
     and a.jlzt = 0  
     and a.shzt = c.ssjs  
     and a.yzxh = 0  
     and a.ssdm = b.ypdm  
     and e.id = a.ssdm  
     and e.djdm = c.id   
     if (@@error<>0) or ( @@rowcount=0)  
     begin  
      rollback tran  
      select "F","��������֪ͨ��ʧ�ܣ�"  
      return  
     end  
    end  
    else  
    begin  
     rollback tran  
     select "F","����֪ͨ��δ�����ɣ�����¼������ҽ����"  
     return  
    end  
   end  
   else  
   begin  
      
*/  
      
    if (select config from YY_CONFIG (nolock) where id="6036")='��' and @config6501<>'��'  
    begin  ----����������6036 �Ƿ�ʹ����������ϵͳ Ϊ�� �� ����6501���Ƿ�ʹ��Χ���������ؿ��ƹ��� Ϊ�� start  
             insert into SS_SSDJK(syxh, yzxh, patid, blh, hzxm, py, wb, bqdm, ksdm,   
      cwdm, djrq, djczyh, sqrq, ssdm, ssmc, mzdm, mzmc, ssksdm,   
      glbz, qkdj, jlzt, slbz, sslb, memo, ysdm,sqzd,haabz,aprq,jzssbz,ssyzshrq  
      )  
     select @syxh, c.xh, a.patid, a.blh, a.hzxm, a.py, a.wb, a.bqdm, a.ksdm,  
         ---a.cwdm, @now, @czyh, c.ksrq, c.ypdm, c.ypmc, c.mzdm,isnull((select name from  SS_SSMZK b   
         a.cwdm,@now, @czyh,case when (exists(select 1 from YY_CONFIG where id='G256' and config='��')) and (isnull(c.ssaprq,'')<>'') then c.ssaprq else c.ksrq  end sqrq,  
         c.ypdm, convert(varchar(256),c.ypmc), c.mzdm,isnull((select name from  SS_SSMZK b (nolock) where b.id=c.mzdm),''), c.zxksdm,0, null,@ssjlzt, 0, 0,   
      convert(varchar(24),c.ztnr), case isnull(c.memo,'') when '' then (case isnull((select name from  SS_SSMZK b (nolock) where b.id=c.mzdm),'') when '' then '' else c.ysdm   
      --- end) else c.memo end as ysdm,c.sqzd,'-1',c.ssaprq  
      end) else c.memo end as ysdm,c.sqzd,c.haabz,c.ssaprq,c.jzssbz,@now  
           from ZY_BRSYK a (nolock)inner join BQ_LSYZK c(nolock) on a.syxh=c.syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh<=@maxlsyzxh and c.yzzt=0 and c.yzlb=2   
      inner join #yjm_bq_lsyzk wls on c.xh=wls.xh    
      left join BQ_LSYZK_FZ fz(nolock) on fz.yzxh=c.xh  
         where a.syxh=@syxh  
         AND not EXISTS(SELECT 1 FROM SS_SSDJK ss(NOLOCK) WHERE a.syxh=ss.syxh AND ss.yzxh=c.xh AND ss.sslb=0)   
     if @@error<>0  
     begin  
      rollback tran  
      select "F","�������ҽ������"  
      return  
     end  
                      
     DECLARE @xhtemp ut_xh12    
     SELECT @xhtemp = scope_identity()  --add by kongwei ���ڴ�����Ӱ�� @@identity   ---����SS_SSDJK.xh  
     SELECT @xhtemp=ISNULL(@xhtemp,0)  
     IF @xhtemp>0  
     BEGIN  
     --����ҽ��  
     --  
     --IF NOT EXISTS (SELECT 1 FROM SS_SSRYK a(NOLOCK),SS_SSDJK b(NOLOCK) WHERE a.ssxh=b.xh AND a.rylb=1 AND a.rydm=b.ysdm AND b.syxh=@syxh)  
     IF NOT EXISTS (SELECT 1 FROM SS_SSRYK a(NOLOCK),SS_SSDJK b(NOLOCK) WHERE a.ssxh=b.xh AND a.rylb=1 AND a.rydm=b.ysdm AND b.syxh=@syxh AND b.xh=@xhtemp)  
     begin ----if LLLLLL_aaaaa_111_iiii1 start  
      insert into SS_SSRYK(ssxh,rylb,rydm,ryxm,memo,isjb)  
      select e.xh,1,e.ysdm,d.name,null,0  
      from ZY_BRSYK a (nolock)  
       inner join BQ_LSYZK c(nolock) on a.syxh =c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh=e.yzxh   
       left join YY_ZGBMK d(nolock) on e.ysdm =d.id   
          where a.syxh=@syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh<=@maxlsyzxh and c.yzzt=0 and c.yzlb=2 AND e.xh=@xhtemp  
       and isnull(e.ysdm,'') != ''  
      if @@error<>0  
      begin  
       rollback tran  
       select "F","�������ҽ������"  
       return  
      END   
     END ----if LLLLLL_aaaaa_111_iiii1 end  
  
     --��������һ��  
     IF NOT EXISTS (SELECT 1 FROM SS_SSRYK a(NOLOCK),SS_SSDJK b(NOLOCK) WHERE a.ssxh=b.xh AND a.rylb=2 AND b.syxh=@syxh  AND b.xh=@xhtemp)  
     BEGIN ----if LLLLLL_aaaaa_111_iiii2 start  
      insert into SS_SSRYK(ssxh,rylb,rydm,ryxm,memo,isjb)  
      select e.xh,2,c.ssyzysdm,d.name,null,0  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh= c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh=e.yzxh   
       left join YY_ZGBMK d(nolock) on c.ssyzysdm=d.id   
          where a.syxh=@syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh<=@maxlsyzxh and c.yzzt=0 and c.yzlb=2 AND e.xh=@xhtemp  
        and isnull(c.ssyzysdm,'') != ''  
      if @@error<>0  
      begin  
       rollback tran  
       select "F","�������ҽ������"  
       return  
      END  
     END ----if LLLLLL_aaaaa_111_iiii2 end  
  
     --������������  
     IF NOT EXISTS (SELECT 1 FROM SS_SSRYK a(NOLOCK),SS_SSDJK b(NOLOCK) WHERE a.ssxh=b.xh AND a.rylb=3 AND b.syxh=@syxh  AND b.xh=@xhtemp)  
     BEGIN ----if LLLLLL_aaaaa_111_iiii3 start  
      insert into SS_SSRYK(ssxh,rylb,rydm,ryxm,memo,isjb)  
      select e.xh,3,c.ssezysdm,d.name,null,0  
      from ZY_BRSYK a (nolock)  
       inner join BQ_LSYZK c(nolock) on a.syxh=c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh         
       inner join SS_SSDJK e(nolock) on c.xh=e.yzxh  
                            left join YY_ZGBMK d(nolock) on c.ssezysdm = d.id           
          where a.syxh=@syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh<=@maxlsyzxh and c.yzzt=0 and c.yzlb=2 AND e.xh=@xhtemp  
        and isnull(c.ssezysdm,'') != ''  
      if @@error<>0  
      begin  
       rollback tran  
       select "F","�������ҽ������"  
       return  
      end  
                    END ----if LLLLLL_aaaaa_111_iiii3 end  
  
     --������������  
     IF NOT EXISTS (SELECT 1 FROM SS_SSRYK a(NOLOCK),SS_SSDJK b(NOLOCK) WHERE a.ssxh=b.xh AND a.rylb=4 AND b.syxh=@syxh  AND b.xh=@xhtemp)  
     BEGIN ----if LLLLLL_aaaaa_111_iiii4 start  
      insert into SS_SSRYK(ssxh,rylb,rydm,ryxm,memo,isjb)  
      select e.xh,4,c.ssszysdm,d.name,null,0  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh  
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh         
       inner join SS_SSDJK e(nolock) on c.xh=e.yzxh  
       left join YY_ZGBMK d(nolock) on c.ssszysdm=d.id    
          where a.syxh=@syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh<=@maxlsyzxh and c.yzzt=0 and c.yzlb=2 AND e.xh=@xhtemp  
        and isnull(c.ssszysdm,'') != ''  
      if @@error<>0  
      begin  
       rollback tran  
       select "F","�������ҽ������"  
       return  
      end  
                  END ----if LLLLLL_aaaaa_111_iiii4 end  
  
     --��ǰ���  
     insert into SS_SSZDK(ssxh,zdlb,zdlx,zddm,zdmc,memo)  
     select e.xh,0,0,e.sqzd,isnull(d.name,''),null  
     from ZY_BRSYK a (nolock)  
      inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh   
      inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
      inner join SS_SSDJK e(nolock) on c.xh =e.yzxh   
      left join YY_ZDDMK d(nolock) on e.sqzd = d.id   
     where a.syxh=@syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh<=@maxlsyzxh and c.yzzt=0 and c.yzlb=2  
       and isnull(e.sqzd,'') != ''  
     if @@error<>0  
     begin  
      rollback tran  
      select "F","�������ҽ������"  
      return  
     end  
       
     if exists(select 1 from sysobjects where name='V5_SSYZK')  
     begin  
      --�������һ  
      insert into SS_SSZDK(ssxh,zdlb,zdlx,zddm,zdmc,memo)  
      select e.xh,0,1,d.SQZD1,isnull(d.SQZDMC1,''),null  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh =e.yzxh   
       left join V5_SSYZK d(nolock) on c.v5xh = d.YZXH and d.SYXH=@syxh  
      where a.syxh=@syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh<=@maxlsyzxh and c.yzzt=0 and c.yzlb=2  
        and isnull(d.SQZD1,'') != ''   
        and not exists (select 1 from SS_SSZDK where ssxh = e.xh and zdlb = 0 and zdlx = 1)  
      if @@error<>0  
      begin  
       rollback tran  
       select "F","�������ҽ������"  
       return  
      end  
      --������϶�  
      insert into SS_SSZDK(ssxh,zdlb,zdlx,zddm,zdmc,memo)  
      select e.xh,0,2,d.SQZD2,isnull(d.SQZDMC2,''),null  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh =e.yzxh   
       left join V5_SSYZK d(nolock) on c.v5xh = d.YZXH and d.SYXH=@syxh   
      where a.syxh=@syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh<=@maxlsyzxh and c.yzzt=0 and c.yzlb=2  
        and isnull(d.SQZD2,'') != ''  
        and not exists (select 1 from SS_SSZDK where ssxh = e.xh and zdlb = 0 and zdlx = 2)  
      if @@error<>0  
      begin  
       rollback tran  
       select "F","�������ҽ������"  
       return  
      end  
      --���������  
      insert into SS_SSZDK(ssxh,zdlb,zdlx,zddm,zdmc,memo)  
      select e.xh,0,3,d.SQZD3,isnull(d.SQZDMC3,''),null  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh =e.yzxh   
       left join V5_SSYZK d(nolock) on c.v5xh = d.YZXH and d.SYXH=@syxh  
      where a.syxh=@syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh<=@maxlsyzxh and c.yzzt=0 and c.yzlb=2  
        and isnull(d.SQZD3,'') != ''  
        and not exists (select 1 from SS_SSZDK where ssxh = e.xh and zdlb = 0 and zdlx = 3)  
      if @@error<>0  
      begin  
       rollback tran  
       select "F","�������ҽ������"  
       return  
      end  
     end        
     END   
       
     if (@config6A38='��')  
     begin  
      select @syxh_1=convert(varchar,@syxh),@yexh_1=convert(varchar,@yexh)  
          ,@maxlsyzxh_1=convert(varchar,@maxlsyzxh),@xhtemp_1=convert(varchar,@xhtemp)  
      --������Ա��  
      exec('insert into '+@config6C58+'dbo.JK_SS_SSRYK (xh,eventtype,opeordernumber,emptype,empcode,empname,Facility,FacilityName,  
          memo,isclude,createtime,processstatus)  
      --����ҽ��  
      select NEWID(),1,e.xh,1   --��Ա���( 0��ָ��ҽ��,1����ҽ��,2������һ��3:��������,4����������  
      --  10������ָ��,11������ 12����   
      --  20����е��ʿ,21��Ѳ�ػ�ʿ,22��ϴ�ֻ�ʿ  
      --  30����Ѫ)  
      ,e.ysdm,d.name,d.ks_id,d.ks_mc,null,0  --1�������Ӱ���Ա��0������������Ա  
      ,CONVERT(DATETIME,GETDATE(),120),1 --1:���� 2-ƽ̨�Ѷ�ȡ 3-ƽ̨����ʧ�� 4-ƽ̨����ɹ� 5-��Ч����   
      from ZY_BRSYK a (nolock)  
       inner join BQ_LSYZK c(nolock) on a.syxh =c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh=e.yzxh   
       left join YY_ZGBMK d(nolock) on e.ysdm =d.id   
          where a.syxh='+@syxh_1+' and c.syxh='+@syxh_1+' and c.yexh = '+@yexh_1+' and c.xh<='+@maxlsyzxh_1+' and c.yzzt=0 and c.yzlb=2 AND e.xh='+@xhtemp_1+'  
       and isnull(e.ysdm,"") != ""  
      union all  
      --����һ��  
      select NEWID(),1,e.xh,2,e.ysdm,d.name,d.ks_id,d.ks_mc,null,0,CONVERT(DATETIME,GETDATE(),120),1  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh= c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh=e.yzxh   
       left join YY_ZGBMK d(nolock) on c.ssyzysdm=d.id   
          where a.syxh='+@syxh_1+' and c.syxh='+@syxh_1+' and c.yexh = '+@yexh_1+' and c.xh<='+@maxlsyzxh_1+' and c.yzzt=0 and c.yzlb=2 AND e.xh='+@xhtemp_1+'  
        and isnull(c.ssyzysdm,"") != ""  
      union all  
      --��������  
      select NEWID(),1,e.xh,3,e.ysdm,d.name,d.ks_id,d.ks_mc,null,0,CONVERT(DATETIME,GETDATE(),120),1  
      from ZY_BRSYK a (nolock)  
       inner join BQ_LSYZK c(nolock) on a.syxh=c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh         
       inner join SS_SSDJK e(nolock) on c.xh=e.yzxh  
                            left join YY_ZGBMK d(nolock) on c.ssezysdm = d.id           
          where a.syxh='+@syxh_1+' and c.syxh='+@syxh_1+' and c.yexh = '+@yexh_1+' and c.xh<='+@maxlsyzxh_1+' and c.yzzt=0 and c.yzlb=2 AND e.xh='+@xhtemp_1+'  
        and isnull(c.ssezysdm,"") != ""  
      union all  
      --��������  
      select NEWID(),1,e.xh,4,e.ysdm,d.name,d.ks_id,d.ks_mc,null,0,CONVERT(DATETIME,GETDATE(),120),1  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh  
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh         
       inner join SS_SSDJK e(nolock) on c.xh=e.yzxh  
       left join YY_ZGBMK d(nolock) on c.ssszysdm=d.id    
          where a.syxh='+@syxh_1+' and c.syxh='+@syxh_1+' and c.yexh = '+@yexh_1+' and c.xh<='+@maxlsyzxh_1+' and c.yzzt=0 and c.yzlb=2 AND e.xh='+@xhtemp_1+'  
        and isnull(c.ssszysdm,"") != "" ')  
        
      --�����Ǽǿ�  
      exec('insert into '+@config6C58+'dbo.JK_SS_SSDJK (xh,eventtype,PatID,PatientID,PatientName,DateTimeofBirth,AdministrativeSex,StreetOrMailingAddress,  
           ZipOrPostalCode,AddressType,PhoneNumberHome,PhoneNumberBusiness,MaritalStatusIdentifier,MaritalStatusText,  
        EthnicGroup,EthnicGroupText,BirthPlace,Nationality,NationalityText,IDCardNo,IDCardType,IDCardTypeName,IdentifyNO,  
        PatientClass,PointOfCare,PointOfCareName,Room,Bed,Facility,FacilityName,AttendingDoctor,ReAdmissionIndicator,  
        VisitNumber,AdmitDateTime,OperationOrderNumber,PlacerOrderNumber,RequestDateTime,ScheduleDateTime,FixupDateTime,  
        OrderingFacility,UniversalServiceIdentifier,UniversalServiceText,FillerStatusCode,Position,SpecialMaterial,  
        OperationSite,IsReadyBlood,CutsRating,HepatitisIndicator,SpecialInfect,OperationDept,OperationRoom,Sequence,  
        OperationScaleID,OperationScale,AnaesthesiaMethod,EmergencyIndicator,IsolationIndicator,Memo,RequestedDoctorID,  
        createtime,processstatus)  
      select NEWID(),1,a.patid,a.blh,a.hzxm,convert(datetime,substring(a.birth,1,4)+"-"+substring(a.birth,5,2)+"-"+substring(a.birth,7,2)),  
       case when a.sex="��" then "1" when a.sex="Ů" then "2" else "9" end,k.lxdz,k.lxyb,"",k.lxdh,k.dwdh,k.hyzk,  
       case when k.hyzk="0" then "δ��"  when k.hyzk="1" then "�ѻ�"  when k.hyzk="2" then "���"   when k.hyzk="3" then "ɥż"   else "δ֪" end,   --0δ��,1�ѻ�,2���,3ɥż  
       k.mzbm,d.name,l.name+m.name+n.name,k.gjbm,e.name,a.cardno,a.cardtype,o.name,substring(a.sfzh,1,18),b.sslb,---�������  
       b.bqdm,g.name,h.fjh,b.cwdm,b.ksdm,i.name,b.ysdm,a.zycs,a.syxh,  
       convert(datetime,substring(a.ryrq,1,4)+"-"+substring(a.ryrq,5,2)+"-"+substring(a.ryrq,7,2) + " " +substring(a.ryrq,9,8)),  
       b.xh,b.yzxh,convert(datetime,SUBSTRING(b.djrq,1,4)+"-"+SUBSTRING(b.djrq,5,2)+"-"+SUBSTRING(b.djrq,7,2) + " " + SUBSTRING(b.djrq,9,8)),  
       case when b.kssj is null or rtrim(b.kssj)="" then null else convert(datetime,SUBSTRING(b.kssj,1,4)+"-"+SUBSTRING(b.kssj,5,2)+"-"+SUBSTRING(b.kssj,7,2)+" "+SUBSTRING(b.kssj,9,8)) end,  
       case when b.aprq is null or rtrim(b.aprq)="" then null else convert(datetime,SUBSTRING(b.aprq,1,4)+"-"+SUBSTRING(b.aprq,5,2)+"-"+SUBSTRING(b.aprq,7,2)+" "+SUBSTRING(b.aprq,9,8)) end,  
       j.name,b.ssdm,b.ssmc,b.jlzt,b.tw,b.tsqx,b.bwid,case when isnull(b.bx,"")<>"" then 1 else 0 end,b.qkdj,b.haabz,b.tsgr,  
       b.ssksdm,b.roomno,b.sstc,b.ssdj,p.name,b.mzmc,b.jzssbz,b.glbz,b.memo,b.ysdm,CONVERT(DATETIME,GETDATE(),120),1  
      from ZY_BRSYK a (nolock)  
          inner join SS_SSDJK b(nolock) on a.syxh=b.syxh  
       inner join ZY_BRXXK k(nolock) on a.patid=k.patid  
       left join YY_MZDMK d(nolock) on k.mzbm=d.id  
       left join YY_GJDMK e(nolock) on k.gjbm=e.id  
       left join YY_YBFLK f(nolock) on a.ybdm=f.ybdm  
       inner join ZY_BQDMK g(nolock) on b.bqdm=g.id  
       inner join ZY_BCDMK h(nolock) on b.bqdm=h.bqdm and b.cwdm=h.id   
       inner join YY_KSBMK i(nolock) on b.ksdm=i.id  
       inner join YY_KSBMK j(nolock) on b.ssksdm=j.id  
          inner join BQ_LSYZK c(nolock) on a.syxh=c.syxh and c.syxh='+@syxh_1+' and c.yexh = '+@yexh_1+' and c.xh<='+@maxlsyzxh_1+' and c.yzzt=0 and c.yzlb=2   
       inner join #yjm_bq_lsyzk wls on c.xh=wls.xh    
       left join BQ_LSYZK_FZ fz(nolock) on fz.yzxh=c.xh  
       left join YY_DQDMK l(nolock) on k.csd_s=l.id and l.lb=0  
       left join YY_DQDMK m(nolock) on k.csd_djs=m.id and l.lb=1  
       left join YY_DQDMK n(nolock) on k.csd_x=n.id and l.lb=2  
       left join YY_CARDTYPE o(nolock) on a.cardtype=o.id  
       left join SS_SSDJDMK p(nolock) on b.ssdj=p.id  
          where a.syxh='+@syxh_1+'  
          AND b.xh='+@xhtemp_1+' ')  
  
      --������Ͽ�  
      exec('insert into '+@config6C58+'dbo.JK_SS_SSZDK (xh,eventtype,OperationOrderNumber,DiagnosisCode,DiagnosisDescription,DiagnosisType,DiagnosisFlag,  
          Memo,Description,createtime,processstatus)  
      --��ǰ���  
      select newid(),1,e.xh,e.sqzd,isnull(d.name,""),0  --������,(0����ǰ���,1���������,2���������)  
          ,0 --�������,(0������,1����һ����,2���ڶ�����,3����������,4�����ĸ���)  
       ,null,null,CONVERT(DATETIME,GETDATE(),120),1  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh =e.yzxh   
       left join YY_ZDDMK d(nolock) on e.sqzd = d.id   
      where a.syxh='+@syxh_1+' and c.syxh='+@syxh_1+' and c.yexh = '+@yexh_1+' and c.xh<='+@maxlsyzxh_1+' and c.yzzt=0 and c.yzlb=2  
        and isnull(e.sqzd,"") != ""  
      union all  
      --�������һ  
      select newid(),1,e.xh,d.SQZD1,isnull(d.SQZDMC1,""),0,1  
       ,null,null,CONVERT(DATETIME,GETDATE(),120),1  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh =e.yzxh   
       left join V5_SSYZK d(nolock) on c.v5xh = d.YZXH and d.SYXH='+@syxh_1+'  
      where a.syxh='+@syxh_1+' and c.syxh='+@syxh_1+' and c.yexh = '+@yexh_1+' and c.xh<='+@maxlsyzxh_1+' and c.yzzt=0 and c.yzlb=2  
        and isnull(d.SQZD1,"") != ""   
        and not exists (select 1 from SS_SSZDK where ssxh = e.xh and zdlb = 0 and zdlx = 1)  
      union all  
      --������϶�  
      select newid(),1,e.xh,d.SQZD2,isnull(d.SQZDMC2,""),0,2  
       ,null,null,CONVERT(DATETIME,GETDATE(),120),1  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh =e.yzxh   
       left join V5_SSYZK d(nolock) on c.v5xh = d.YZXH and d.SYXH='+@syxh_1+'   
      where a.syxh='+@syxh_1+' and c.syxh='+@syxh_1+' and c.yexh = '+@yexh_1+' and c.xh<='+@maxlsyzxh_1+' and c.yzzt=0 and c.yzlb=2  
        and isnull(d.SQZD2,"") != ""  
        and not exists (select 1 from SS_SSZDK where ssxh = e.xh and zdlb = 0 and zdlx = 2)  
      union all  
      --���������  
      select newid(),1,e.xh,d.SQZD3,isnull(d.SQZDMC3,""),0,3  
       ,null,null,CONVERT(DATETIME,GETDATE(),120),1  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh =e.yzxh   
       left join V5_SSYZK d(nolock) on c.v5xh = d.YZXH and d.SYXH='+@syxh_1+'  
      where a.syxh='+@syxh_1+' and c.syxh='+@syxh_1+' and c.yexh = '+@yexh_1+' and c.xh<='+@maxlsyzxh_1+' and c.yzzt=0 and c.yzlb=2  
        and isnull(d.SQZD3,"") != ""  
        and not exists (select 1 from SS_SSZDK where ssxh = e.xh and zdlb = 0 and zdlx = 3) ')  
     end  
    end  ----����������6036 �Ƿ�ʹ����������ϵͳ Ϊ�� �� ����6501���Ƿ�ʹ��Χ���������ؿ��ƹ��� Ϊ�� end  
   end  ----��������G090 ����֪ͨ���Ƿ����� Ϊ ��  ���� KS20����>0 ʹ�ÿ�����ҩƷ����ϵͳ2.0 end  
            else  
            begin ----��������G090 ����֪ͨ���Ƿ����� Ϊ ��  ���� KS20����=0 ��ʹ�ÿ�����ҩƷ����ϵͳ2.0 start  
                if (@sfxyzlc=1)  
                begin  
                    update SS_SSDJK set jlzt=0  
                    where yzxh in (select c.xh from ZY_BRSYK a, BQ_LSYZK c,#yjm_bq_lsyzk wls   
         where a.syxh=@syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh<=@maxlsyzxh and c.yzzt=0 and c.yzlb=2 and c.xh=wls.xh  
                           and isnull(c.ssyzzt,0)=2  )  
  
     if @@error<>0  
     begin  
      rollback tran  
      select "F","�������ҽ������"  
      return  
     end  
                end  
            end ----��������G090 ����֪ͨ���Ƿ����� Ϊ ��  ���� KS20����=0 ��ʹ�ÿ�����ҩƷ����ϵͳ2.0 end  
              
  end ----��if LLLLLL end  
  
        if @issh='��' --������6293 ҽ�����ʱ������ҩƷ�Ƿ������ Ϊ �� start  
        begin  
            --����if QQQQ start    
            if exists(select 1 from BQ_LSYZK a(nolock),BQ_BRGMJLK b (nolock),#yjm_bq_lsyzk wls  
    where a.syxh=@syxh and a.yexh = @yexh and a.xh=wls.xh and a.xh<=@maxlsyzxh and a.yzzt=0 and a.syxh=b.syxh and a.gg_idm=b.gg_idm   
    and b.gmlx in (1,6,7) and b.jlzt=0  
    )                     
                    set @shnr = '�ò���ҽ���������ԵĹ���ҩƷ�������Ӧҽ��û�����ͨ����'  
             -- ����if QQQQ end   
  
            if @config6480<>'��' --��������6480 �Ƿ�ʹ��ҽ��(EMRҽ�����)�뻤ʿ�ֿ���˵Ļ��� Ϊ �� start  
            begin  
    if @config0251='��' or @config6D87='��'  
    begin  
                    insert into #yshyz   
                    select distinct a.xh,0,1  
                    from BQ_LSYZK a inner join #yjm_bq_lsyzk wls on wls.xh=a.xh  
              where a.syxh=@syxh and a.yexh = @yexh and a.xh<=@maxlsyzxh and a.yzzt=0   
      and  not exists (  
                            select 1   
                            from BQ_LSYZK b,BQ_BRGMJLK c  
                            where b.syxh=@syxh and b.yexh = @yexh and b.xh<=@maxcqyzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
                            and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh)  
      and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
               and ( (@sfxyzlc=0) or (a.yzlb<>2) or (isnull(a.ssyzzt,0)=2 ) )  
                        AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
    end  
    update BQ_LSYZK set shrq=@now,  
     shczyh=@czyh,  
     yzzt=1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end  
     ,gxrq=@now  
                from BQ_LSYZK a inner join #yjm_bq_lsyzk wls on wls.xh=a.xh  
          where a.syxh=@syxh and a.yexh = @yexh and a.xh<=@maxlsyzxh and a.yzzt=0   
     and  not exists (  
                        select 1   
                        from BQ_LSYZK b,BQ_BRGMJLK c  
                        where b.syxh=@syxh and b.yexh = @yexh and b.xh<=@maxcqyzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
                        and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh)  
     and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
                    and ( (@sfxyzlc=0) or (a.yzlb<>2) or (isnull(a.ssyzzt,0)=2 ) )  
                    AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
            end --��������6480 �Ƿ�ʹ��ҽ��(EMRҽ�����)�뻤ʿ�ֿ���˵Ļ��� Ϊ �� end  
            else  
            begin --��������6480 �Ƿ�ʹ��ҽ��(EMRҽ�����)�뻤ʿ�ֿ���˵Ļ��� Ϊ �� start  
    if @emrsybz = 0 --- if @emrsybz = 0 start  
    begin  
     if @config0251='��' or @config6D87='��'  
     begin  
      insert into #yshyz   
      select distinct a.xh,0,1  
      from BQ_LSYZK a inner join #yjm_bq_lsyzk wls on wls.xh=a.xh  
      where a.syxh=@syxh and a.yexh = @yexh and a.xh<=@maxlsyzxh and a.yzzt=0   
       and  not exists (  
        select 1   
        from BQ_LSYZK b,BQ_BRGMJLK c  
        where b.syxh=@syxh and b.yexh = @yexh and b.xh<=@maxcqyzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
        and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh)  
       and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
       and isnull(a.yshdbz,0)=1  
                            and ( (@sfxyzlc=0) or (a.yzlb<>2) or (isnull(a.ssyzzt,0)=2 ) )  
                            AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
     end  
     update BQ_LSYZK set shrq=@now,  
     shczyh=@czyh,  
     yzzt=1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
     ,gxrq=@now  
     from BQ_LSYZK a inner join #yjm_bq_lsyzk wls on wls.xh=a.xh  
     where a.syxh=@syxh and a.yexh = @yexh and a.xh<=@maxlsyzxh and a.yzzt=0   
      and  not exists (  
        select 1   
        from BQ_LSYZK b,BQ_BRGMJLK c  
        where b.syxh=@syxh and b.yexh = @yexh and b.xh<=@maxcqyzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
        and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh)  
       and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
       and isnull(a.yshdbz,0)=1  
                            and ( (@sfxyzlc=0) or (a.yzlb<>2) or (isnull(a.ssyzzt,0)=2 ) )  
                            AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
    end  --- if @emrsybz = 0 end   
    else if @emrsybz = 1   --- if @emrsybz = 1 start  
    begin  
     update BQ_LSYZK set yshdbz = 1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
      ,gxrq=@now  
     from BQ_LSYZK a inner join #yjm_bq_lsyzk wls on wls.xh=a.xh  
     where a.syxh=@syxh and a.yexh = @yexh and a.xh<=@maxlsyzxh and a.yzzt=0   
      and  not exists (  
       select 1   
       from BQ_LSYZK b,BQ_BRGMJLK c  
       where b.syxh=@syxh and b.yexh = @yexh and b.xh<=@maxcqyzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
      and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh )  
      and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
      and isnull(a.yshdbz,0)=0  
     AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
         
    end  --- if @emrsybz = 1 end  
            end --��������6480 �Ƿ�ʹ��ҽ��(EMRҽ�����)�뻤ʿ�ֿ���˵Ļ��� Ϊ �� end  
  
        end --������6293 ҽ�����ʱ������ҩƷ�Ƿ������ Ϊ �� end  
        else  
        begin  --������6293 ҽ�����ʱ������ҩƷ�Ƿ������ Ϊ �� start  
            if @config6480<>'��' --��������6480 �Ƿ�ʹ��ҽ��(EMRҽ�����)�뻤ʿ�ֿ���˵Ļ��� Ϊ �� start  
            begin  
    if @config0251='��' or @config6D87='��'  
    begin  
     insert into #yshyz  
     select distinct xh,0,1   
     from BQ_LSYZK a  
     where syxh=@syxh and yexh = @yexh and xh<=@maxlsyzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
      and xh in (select xh from #yjm_bq_lsyzk)  
      and ( (@sfxyzlc=0) or (yzlb<>2) or (isnull(ssyzzt,0)=2 ) )  
      AND ((@config6788=1)OR( xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
    end  
    update BQ_LSYZK set shrq=@now,  
    shczyh=@czyh,  
    yzzt=1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
    ,gxrq=@now  
    from BQ_LSYZK a  
    where syxh=@syxh and yexh = @yexh and xh<=@maxlsyzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
     and xh in (select xh from #yjm_bq_lsyzk)  
                    and ( (@sfxyzlc=0) or (yzlb<>2) or (isnull(ssyzzt,0)=2 ) )  
     AND ((@config6788=1)OR( xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
            end --��������6480 �Ƿ�ʹ��ҽ��(EMRҽ�����)�뻤ʿ�ֿ���˵Ļ��� Ϊ �� end  
            else  
            begin --��������6480 �Ƿ�ʹ��ҽ��(EMRҽ�����)�뻤ʿ�ֿ���˵Ļ��� Ϊ �� start  
    if @emrsybz = 0 --- if @emrsybz = 0  start  
    begin  
     if @config0251='��' or @config6D87='��'  
     begin   
      insert into #yshyz  
      select distinct xh,0,1   
      from BQ_LSYZK a  
      where syxh=@syxh and yexh = @yexh and xh<=@maxlsyzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
       and isnull(yshdbz,0)=1  
       and xh in (select xh from #yjm_bq_lsyzk)  
       and ( (@sfxyzlc=0) or (yzlb<>2) or (isnull(ssyzzt,0)=2 ) )  
       AND ((@config6788=1)OR( xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
     end  
     update BQ_LSYZK set shrq=@now,  
     shczyh=@czyh,  
     yzzt=1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
     ,gxrq=@now  
     from BQ_LSYZK a  
     where syxh=@syxh and yexh = @yexh and xh<=@maxlsyzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
      and isnull(yshdbz,0)=1  
      and xh in (select xh from #yjm_bq_lsyzk)  
                        and ( (@sfxyzlc=0) or (yzlb<>2) or (isnull(ssyzzt,0)=2 ) )  
                        AND ((@config6788=1)OR( xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
    end --- if @emrsybz = 0  end  
    else if @emrsybz = 1 --- if @emrsybz = 1  start  
    begin  
     update BQ_LSYZK set yshdbz = 1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
     ,gxrq=@now  
     from BQ_LSYZK a  
     where syxh=@syxh and yexh = @yexh and xh<=@maxlsyzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
      and isnull(yshdbz,0)=0  
      and xh in (select xh from #yjm_bq_lsyzk)  
      AND ((@config6788=1)OR( xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
            
    end --- if @emrsybz = 1  end  
            end --��������6480 �Ƿ�ʹ��ҽ��(EMRҽ�����)�뻤ʿ�ֿ���˵Ļ��� Ϊ �� end  
  
        end--������6293 ҽ�����ʱ������ҩƷ�Ƿ������ Ϊ �� end  
    if @@error<>0  
  begin  
         rollback tran  
      select "F","�����ʱҽ������"  
      return  
  end  
/***********************************************��ʱҽ��д��ƽ̨�м��******************************************************/  
  if @config6A71 = '��'  
  begin  
   insert into JK_ZY_ZYYZ (xh,eventtype,patientid,syxh,isstandingorder,orderno,groupno,  
    isprimary,createdby,begintime,audittime,exectime,stoptime,  
    freqcode,execnumber,execfreq,execfequnit,execweek,  
    needskintest,ordertype,needcharge,phacode,phaname,spec,dosage,dosageunit,quantity,  
    quantityunit,ordermemo,ordercontent,usage,memo,isself,execdept,  
    createtime,updatetime,processstatus)  
   select (select NEWID()),1,(select patid from ZY_BRSYK where syxh = a.syxh),syxh,2,xh,fzxh,  
    null,ysdm,SUBSTRING(ksrq,1,8) + ' ' + SUBSTRING(ksrq,9,8), SUBSTRING(shrq,1,8) + ' ' + SUBSTRING(shrq,9,8),  
    SUBSTRING(zxrq,1,8) + ' ' + SUBSTRING(zxrq,9,8),SUBSTRING(tzrq,1,8) + ' ' + SUBSTRING(tzrq,9,8),  
    pcdm,(select zxcs from ZY_YZPCK where id = a.pcdm),(select zxzq from ZY_YZPCK where id = a.pcdm),  
    (select zxzqdw from ZY_YZPCK where id = a.pcdm),(select zbz from ZY_YZPCK where id = a.pcdm),  
    psbz,yzlb,1,ypdm,ypmc,ypgg,ypjl,jldw,ypsl,zxdw,ztnr,yznr,ypyf,memo,case zbybz when 1 then 1 else 0 end,zxksdm,  
    GETDATE(),null,1  
   from BQ_LSYZK a  
   where a.syxh=@syxh and xh in (select xh from #sh_yzxh_ls) and a.yzlb in (0,1,3,4,5,8,12)  
   if @@error<>0  
   begin  
    rollback tran  
    select "F","д��ƽ̨�м��JK_ZY_ZYYZ����"  
    return  
   end  
  end  
/*****************************************************************************************************/     
  select @shyzcount = @shyzcount + @@rowcount  
 end --�������ȫ���������ʱ @yzbz ҽ�����(0:��ʱ, -1:ȫ��) end  
   
 if (@yzbz = 1) or (@yzbz = -1) --������˳��ڻ�ȫ�� @yzbz ҽ�����(1:����, -1:ȫ��) start  
 begin  
        if @issh='��'  --������6293 ҽ�����ʱ������ҩƷ�Ƿ������ Ϊ �� start  
        begin  
            ---����if QQQQQ start  
            if exists(select 1 from BQ_CQYZK a(nolock),BQ_BRGMJLK b (nolock),#yjm_bq_cqyzk wcq  
    where a.syxh=@syxh and a.yexh = @yexh and a.xh<=@maxcqyzxh and a.yzzt=0 and a.xh=wcq.xh   
  and a.syxh=b.syxh and a.gg_idm=b.gg_idm and b.gmlx in (1,6,7) and b.jlzt=0  
    )  
                    set @shnr = '�ò���ҽ���������ԵĹ���ҩƷ�������Ӧҽ��û�����ͨ����'  
            ---����if QQQQQ end  
                      
            if @config6480<>'��' --��������6480 �Ƿ�ʹ��ҽ��(EMRҽ�����)�뻤ʿ�ֿ���˵Ļ��� Ϊ �� start  
            begin  
    if @config0251='��' or @config6D87='��'  
    begin  
     insert into #yshyz  
     select distinct a.xh,1,1  
     from BQ_CQYZK a inner join #yjm_bq_cqyzk wcq on wcq.xh=a.xh  
     where a.syxh=@syxh and a.yexh = @yexh and a.xh<=@maxcqyzxh and a.yzzt=0   
      and   not exists (  
        select 1   
        from BQ_CQYZK b,BQ_BRGMJLK c  
        where b.syxh=@syxh and b.yexh = @yexh and b.xh<=@maxcqyzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
        and c.gmlx in (1,6,7) and c.jlzt=0  and a.fzxh=b.fzxh)  
      and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
      AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
    end  
    --select zxksdm, * from BQ_CQYZK  
    update BQ_CQYZK set shrq=@now,  
     shczyh=@czyh,  
     yzzt=1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
     ,gxrq=@now  
     ,ksrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
       convert(char(8),dateadd(day,1,substring(substring(ksrq,1,8),1,8)),112) +'00:01:00'  
       else ksrq end  
     ,yzxrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
       convert(char(8),dateadd(day,1,substring(substring(yzxrq,1,8),1,8)),112)   
       else yzxrq end  
     ,zxrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
       convert(char(8),dateadd(day,1,substring(substring(zxrq,1,8),1,8)),112)   
       else zxrq end  
    from BQ_CQYZK a inner join #yjm_bq_cqyzk wcq on wcq.xh=a.xh  
    where a.syxh=@syxh and a.yexh = @yexh and a.xh<=@maxcqyzxh and a.yzzt=0   
     and   not exists (  
       select 1   
       from BQ_CQYZK b,BQ_BRGMJLK c  
       where b.syxh=@syxh and b.yexh = @yexh and b.xh<=@maxcqyzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
       and c.gmlx in (1,6,7) and c.jlzt=0  and a.fzxh=b.fzxh)  
     and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
     AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
            end --��������6480 �Ƿ�ʹ��ҽ��(EMRҽ�����)�뻤ʿ�ֿ���˵Ļ��� Ϊ �� end  
            else  
            begin --��������6480 �Ƿ�ʹ��ҽ��(EMRҽ�����)�뻤ʿ�ֿ���˵Ļ��� Ϊ �� start  
    if @emrsybz = 0  --- if @emrsybz = 0 start  
    begin  
     if @config0251='��' or @config6D87='��'  
     begin  
      insert into #yshyz  
      select distinct a.xh,1,1  
      from BQ_CQYZK a inner join #yjm_bq_cqyzk wcq on wcq.xh=a.xh  
      where a.syxh=@syxh and a.yexh = @yexh and a.xh<=@maxcqyzxh and a.yzzt=0   
       and  not exists (  
        select 1   
        from BQ_CQYZK b,BQ_BRGMJLK c  
        where b.syxh=@syxh and b.yexh = @yexh and b.xh<=@maxcqyzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
        and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh)  
       and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
       and isnull(a.yshdbz,0)=1  
       AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
     end  
     update BQ_CQYZK set shrq=@now,  
     shczyh=@czyh,  
     yzzt=1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
     ,gxrq=@now  
     ,ksrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
       convert(char(8),dateadd(day,1,substring(substring(ksrq,1,8),1,8)),112) +'00:01:00'  
       else ksrq end  
     ,yzxrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
       convert(char(8),dateadd(day,1,substring(substring(yzxrq,1,8),1,8)),112)   
       else yzxrq end  
     ,zxrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
       convert(char(8),dateadd(day,1,substring(substring(zxrq,1,8),1,8)),112)   
       else zxrq end  
     from BQ_CQYZK a inner join #yjm_bq_cqyzk wcq on wcq.xh=a.xh  
     where a.syxh=@syxh and a.yexh = @yexh and a.xh<=@maxcqyzxh and a.yzzt=0   
      and  not exists (  
       select 1   
       from BQ_CQYZK b,BQ_BRGMJLK c  
       where b.syxh=@syxh and b.yexh = @yexh and b.xh<=@maxcqyzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
       and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh)  
      and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
      and isnull(a.yshdbz,0)=1  
      AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
    end  --- if @emrsybz = 0 end  
    else if @emrsybz = 1   --- if @emrsybz = 1 start  
    begin  
     update BQ_CQYZK set yshdbz = 1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
     ,gxrq=@now  
     from BQ_CQYZK a inner join #yjm_bq_cqyzk wcq on wcq.xh=a.xh  
     where a.syxh=@syxh and a.yexh = @yexh and a.xh<=@maxcqyzxh and a.yzzt=0   
      and  not exists (  
        select 1   
        from BQ_CQYZK b,BQ_BRGMJLK c  
        where b.syxh=@syxh and b.yexh = @yexh and b.xh<=@maxcqyzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
        and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh )  
      and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
      and isnull(a.yshdbz,0)=0  
      AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
    end --- if @emrsybz = 1 end  
            end --��������6480 �Ƿ�ʹ��ҽ��(EMRҽ�����)�뻤ʿ�ֿ���˵Ļ��� Ϊ �� end  
        end  --������6293 ҽ�����ʱ������ҩƷ�Ƿ������ Ϊ �� end  
        else  
        begin  --������6293 ҽ�����ʱ������ҩƷ�Ƿ������ Ϊ �� start  
            if @config6480<>'��' --��������6480 �Ƿ�ʹ��ҽ��(EMRҽ�����)�뻤ʿ�ֿ���˵Ļ��� Ϊ �� start  
            begin  
    if @config0251='��' or @config6D87='��'  
    begin   
     insert into #yshyz  
     select distinct a.xh,1,1  
     from BQ_CQYZK a inner join #yjm_bq_cqyzk wcq on wcq.xh=a.xh  
        where a.syxh=@syxh and a.yexh = @yexh and a.xh<=@maxcqyzxh and a.yzzt=0   
      and  not exists (  
       select 1   
       from BQ_CQYZK b,BQ_BRGMJLK c  
       where b.syxh=@syxh and b.yexh = @yexh and b.xh<=@maxcqyzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
       and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh )  
      and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
      and isnull(a.yshdbz,0)=0  
      AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
    end  
    update BQ_CQYZK set shrq=@now,  
    shczyh=@czyh,  
    yzzt=1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
    ,gxrq=@now  
    ,ksrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
     convert(char(8),dateadd(day,1,substring(substring(ksrq,1,8),1,8)),112) +'00:01:00'  
     else ksrq end  
    ,yzxrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
     convert(char(8),dateadd(day,1,substring(substring(yzxrq,1,8),1,8)),112)   
     else yzxrq end  
    ,zxrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then       
     convert(char(8),dateadd(day,1,substring(substring(zxrq,1,8),1,8)),112)   
     else zxrq end  
    from BQ_CQYZK a  
    where syxh=@syxh  and yexh = @yexh and xh<=@maxcqyzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
     and xh in (select xh from #yjm_bq_cqyzk)  
    AND ((@config6788=1)OR( xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
            end --��������6480 �Ƿ�ʹ��ҽ��(EMRҽ�����)�뻤ʿ�ֿ���˵Ļ��� Ϊ �� end  
            else  
            begin --��������6480 �Ƿ�ʹ��ҽ��(EMRҽ�����)�뻤ʿ�ֿ���˵Ļ��� Ϊ �� start  
    if @emrsybz = 0 --- if @emrsybz = 0 start  
    begin  
     if @config0251='��' or @config6D87='��'  
     begin  
      insert into #yshyz  
      select distinct xh,1,1  
      from BQ_CQYZK a  
      where syxh=@syxh  and yexh = @yexh and xh<=@maxcqyzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
       and isnull(yshdbz,0)=1  
       and xh in (select xh from #yjm_bq_cqyzk)  
       AND ((@config6788=1)OR(xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
     end  
     update BQ_CQYZK set shrq=@now,  
     shczyh=@czyh,  
     yzzt=1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
     ,gxrq=@now  
     ,ksrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
       convert(char(8),dateadd(day,1,substring(substring(ksrq,1,8),1,8)),112) +'00:01:00'  
       else ksrq end  
     ,yzxrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
       convert(char(8),dateadd(day,1,substring(substring(yzxrq,1,8),1,8)),112)   
       else yzxrq end  
     ,zxrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
       convert(char(8),dateadd(day,1,substring(substring(zxrq,1,8),1,8)),112)   
       else zxrq end  
     from BQ_CQYZK a  
     where syxh=@syxh  and yexh = @yexh and xh<=@maxcqyzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
      and isnull(yshdbz,0)=1  
      and xh in (select xh from #yjm_bq_cqyzk)  
      AND ((@config6788=1)OR(xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
    end --- if @emrsybz = 0 end  
    else if @emrsybz = 1 ---- if @emrsybz = 1 start  
    begin  
     update BQ_CQYZK set yshdbz = 1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
     ,gxrq=@now  
     from BQ_CQYZK a  
     where syxh=@syxh  and yexh = @yexh and xh<=@maxcqyzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
      and isnull(yshdbz,0)=0  
      and xh in (select xh from #yjm_bq_cqyzk)  
     AND ((@config6788=1)OR(xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
    end ---- if @emrsybz = 1 end  
            end --��������6480 �Ƿ�ʹ��ҽ��(EMRҽ�����)�뻤ʿ�ֿ���˵Ļ��� Ϊ �� end  
        end --������6293 ҽ�����ʱ������ҩƷ�Ƿ������ Ϊ �� end  
  if @@error<>0  
  begin  
   rollback tran  
   select "F","��˳���ҽ������"  
   return  
  end  
    
/***********************************************����ҽ������ƽ̨�м��******************************************************/  
  if @config6A71= '��'  
  begin  
   insert into JK_ZY_ZYYZ (xh,eventtype,patientid,syxh,isstandingorder,orderno,groupno,  
    isprimary,createdby,begintime,audittime,exectime,stoptime,  
    freqcode,execnumber,execfreq,execfequnit,execweek,  
    needskintest,ordertype,needcharge,phacode,phaname,spec,dosage,dosageunit,quantity,  
    quantityunit,ordermemo,ordercontent,usage,memo,isself,execdept,  
    createtime,updatetime,processstatus)  
   select (select NEWID()),1,(select patid from ZY_BRSYK where syxh = a.syxh),syxh,1,xh,fzxh,  
    null,ysdm,SUBSTRING(ksrq,1,8) + ' ' + SUBSTRING(ksrq,9,8), SUBSTRING(shrq,1,8) + ' ' + SUBSTRING(shrq,9,8),  
    SUBSTRING(zxrq,1,8) + ' ' + SUBSTRING(zxrq,9,8),SUBSTRING(tzrq,1,8) + ' ' + SUBSTRING(tzrq,9,8),  
    pcdm,(select zxcs from ZY_YZPCK where id = a.pcdm),(select zxzq from ZY_YZPCK where id = a.pcdm),  
    (select zxzqdw from ZY_YZPCK where id = a.pcdm),(select zbz from ZY_YZPCK where id = a.pcdm),  
    0,yzlb,1,ypdm,ypmc,ypgg,ypjl,jldw,ypsl,zxdw,ztnr,yznr,ypyf,memo,case zbybz when 1 then 1 else 0 end,zxksdm,  
    GETDATE(),null,1  
   from BQ_CQYZK a  
   where a.syxh=@syxh and xh in (select xh from #sh_yzxh_cq) and a.yzlb in (0,1,3,4,5,8,14,15)   
   if @@error<>0  
   begin  
    rollback tran  
    select "F","д��ƽ̨�м��JK_ZY_ZYYZ����"  
    return  
   end  
  end       
/*****************************************************************************************************/      
  select @shyzcount =@shyzcount + @@rowcount  
 end --������˳��ڻ�ȫ�� @yzbz ҽ�����(1:����, -1:ȫ��) end  
           
        --����ֹͣҽ�� ��ʼ  
 if exists(select 1 from BQ_LSYZK a(nolock) inner join #yjm_bq_lsyzk wls on wls.xh=a.xh where a.syxh=@syxh and a.yexh = @yexh and a.yzzt=1 and a.yzlb=9)  
 begin -- if TTTTTTTT1  start   
  declare cs_tzyz cursor for   
--  select distinct b.fzxh, a.tzrq, a.ysdm from BQ_LSYZK a, BQ_CQYZK b   
  select distinct b.fzxh, a.tzrq, a.lrczyh,b.yzlb,a.ypmc from BQ_LSYZK a(nolock), BQ_CQYZK b(nolock),#yjm_bq_lsyzk wls,#yjm_bq_cqyzk wcq   --˭ֹͣҽ����ҽ��ֹͣ����ʾ˭,������ʾֹͣҽ���������  
  where a.syxh=@syxh and a.yzzt=1 and a.yzlb=9 and b.syxh=@syxh and b.xh=a.tzxh and a.xh=wls.xh and b.xh=wcq.xh  
  for read only  
  
  open cs_tzyz  
  fetch cs_tzyz into @tzxh,@tzrq,@ysdm,@yzlb,@yznr  
  while @@fetch_status=0 ---�α� cs_tzyz while Start  
  begin  
   select @tzyy=0    
   if SUBSTRING(@yznr,1,3)='��ͣ*'    
    select @tzyy=1    
   else if SUBSTRING(@yznr,1,3)='��ͣ*'    
    select @tzyy=4    
   else if SUBSTRING(@yznr,1,3)='��ͣ*'    
    select @tzyy=5  
   --add by hhy ���������ͣҽ��������ҽ����ֹͣҽ����Ӧ���ǿ�����ҽ����ҽ����������ԭ��¼��ҽ����ҽ��   
   --����������������ҽ����shczy��Ӧ�øĳɵ�ǰ����Ա  
   if @tzyy = 1  
   begin  
    select @ysdm = a.lrczyh from BQ_CQYZK a(nolock) inner join #yjm_bq_cqyzk wcq on wcq.xh=a.xh where a.syxh = @syxh and a.fzxh > @tzxh and a.yzzt = 2 and a.yzlb = 14   
    if exists(select 1 from BQ_CQYZK a(nolock) inner join #yjm_bq_cqyzk wcq on wcq.xh=a.xh where a.syxh = @syxh and a.fzxh > @tzxh and a.yzzt = 2 and a.yzlb = 14 and ltrim(rtrim(a.shczyh)) = "" )  
    update BQ_CQYZK set shczyh = @czyh where syxh = @syxh and fzxh > @tzxh and yzzt = 2 and yzlb = 14 and xh in (select xh from #yjm_bq_cqyzk)  
    if @@ERROR <> 0  
    begin  
     rollback tran  
     deallocate cs_   
     select "F","��������ҽ��״̬����"  
     return  
    end  
   end   
   
     --add by kongwei ��¼���ʱ�����tzrq  
   insert into BQ_TZRQLOG(cqfzxh,syxh,lstzxh,lstzrq,czyh) values  
   (@tzxh,@syxh,@tzxh,@tzrq,@czyh)  
   
   -- add by hhy end  
   exec usp_bq_tzyz @syxh,@czyh,@tzrq,@ysdm,@tzyy,@errmsg output,1,@tzxh, 0, @yexh  
   if @errmsg like "F%"  
   begin  
    rollback tran  
    deallocate cs_tzyz  
    select "F",substring(@errmsg,2,49)  
    return  
   end  
   if (@yzlb IN(14,15)) and (@configG435='��')  --zzk  
   begin    
    if exists(select 1 from BQ_CQYZK a(nolock) inner join #yjm_bq_cqyzk wcq on wcq.xh=a.xh where a.syxh=@syxh and a.fzxh=@tzxh and a.yzzt<3)   
    begin   
          
     if @config0251='��' or @config6D87='��'--ҽ���ջ�״̬����  
     begin  
      insert into #yshyz   
      select distinct xh,1,4  
      from BQ_CQYZK   
      where syxh=@syxh and fzxh=@tzxh and yzzt<3 and xh in (select xh from #yjm_bq_cqyzk)   
     end    
     update BQ_CQYZK set yzzt=4 where syxh=@syxh and fzxh=@tzxh and yzzt<3 and xh in (select xh from #yjm_bq_cqyzk)   
       end   
   end   
   fetch cs_tzyz into @tzxh,@tzrq,@ysdm,@yzlb,@yznr  
  end ---�α� cs_tzyz while end  
  close cs_tzyz  
  deallocate cs_tzyz  
  if @config0251='��' or @config6D87='��'--ҽ���ջ�״̬����  
  begin  
   insert into #yshyz   
   select distinct xh,0,2  
  from BQ_LSYZK   
   where syxh=@syxh and yexh = @yexh and yzzt=1 and yzlb=9 and xh in (select xh from #yjm_bq_lsyzk)  
   if @@error<>0  
   begin  
    rollback tran  
    select "F","���ֹͣҽ������"  
    return  
   end  
  end    
  update BQ_LSYZK set zxrq=@now,  
   zxczyh=@czyh,  
   yzzt=2,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
   ,gxrq=@now  
  where syxh=@syxh and yexh = @yexh and yzzt=1 and yzlb=9 and xh in (select xh from #yjm_bq_lsyzk)  
  if @@error<>0  
  begin  
   rollback tran  
   select "F","���ֹͣҽ������"  
   return  
  end  
 end -- if TTTTTTTT1  end  
 --����ֹͣҽ�� ����  
end  ---=======================�������� 0=ȫ��ҽ��  end=====================================  
else   
begin  ---=======================�������� 1=����ҽ��  start=====================================  
 if @yzbz=0 ----�������ҽ����� @yzbz (0:��ʱ) start  
 begin  
        --add by hhy 2014.04.17 for 198733  ��Ժ��ҩǰ����˹��ˣ�����ֱ�ӷ��ؾ���  
     if exists(select 1 from BQ_LSYZK a(nolock) inner join #yjm_bq_lsyzk wls on wls.xh=a.xh where a.xh = @fzxh and a.yzlb = 12)  
  begin  
   ---------ҽ���ջ���ʼ-------------------------------------------------------------------------  
    declare cs_yzsh_bh_ls cursor for  --�ڶ���  
   select distinct b.syxh,a.yzxh,case isnull(@dqksdm,'') when '' then b.ksdm else @dqksdm end,  
    b.bqdm,b.shczyh,a.yzzt    
   from BQ_LSYZK b (nolock)   inner join  #yshyz a(nolock) on a.yzxh=b.xh   
   where a.cqlsbz=0 and b.yzlb<>9   
   order by a.yzxh,a.yzzt  
   open cs_yzsh_bh_ls   
   fetch cs_yzsh_bh_ls into @yzbh_syxh,@yzbh_yzxh,@yzbh_zxks,@yzbh_bqdm,@shr,@yzzt  
   while @@fetch_status=0 ---�α� cs_cydy_yzsh while Start  
   begin  
    select @yzbh_pcsj=''   
    select @yzbh_cqlsbz=0     
    if @yzzt=1   
    begin  
     select @yzbh_xtbz=6  
    end  
    else if @yzzt=2  
    begin  
     select @yzbh_xtbz=7  
    end  
      --========������ҽ���ջ� ����1 ��ʱ������===========   
    exec usp_bq_yzbh_dy @yzbh_syxh,@yzbh_yzxh,@yzbh_cqlsbz,@yzbh_zxks,@yzbh_bqdm,  
     @shr,'',@yzbh_pcsj,@yzbh_xtbz,0,@errmsg output  
    if @errmsg like 'F%'  
    begin  
     rollback TRAN  
     deallocate cs_yzsh_bh_ls     
     select "F",substring(@errmsg,2,49)  
     return    
    end  
    fetch cs_yzsh_bh_ls into @yzbh_syxh,@yzbh_yzxh,@yzbh_zxks,@yzbh_bqdm,@shr,@yzzt  
   end   
   close cs_yzsh_bh_ls  
   deallocate cs_yzsh_bh_ls     
   declare cs_yzsh_bh_cq cursor for  
   select distinct b.syxh,a.yzxh,case isnull(@dqksdm,'') when '' then b.ksdm else @dqksdm end,  
    b.bqdm,b.shczyh,a.yzzt    
   from BQ_CQYZK b (nolock) inner join  #yshyz a(nolock) on a.yzxh=b.xh   
   where a.cqlsbz=1   
   order by a.yzxh,a.yzzt  
   open cs_yzsh_bh_cq   
   fetch cs_yzsh_bh_cq into @yzbh_syxh,@yzbh_yzxh,@yzbh_zxks,@yzbh_bqdm,@shr,@yzzt   
   while @@fetch_status=0 ---�α� cs_cydy_yzsh while Start  
   begin  
    select @yzbh_pcsj=''   
    select @yzbh_cqlsbz=1  
    if @yzzt=1   
    begin  
     select @yzbh_xtbz=6  
    end  
    else if @yzzt=2  
    begin  
     select @yzbh_xtbz=7  
    end  
    else if @yzzt=4  --ֹͣ���  
    begin  
     select @yzbh_xtbz=10  
    end  
      --========������ҽ���ջ� ����2 ���� ������===========      
    exec usp_bq_yzbh_dy @yzbh_syxh,@yzbh_yzxh,@yzbh_cqlsbz,@yzbh_zxks,@yzbh_bqdm,  
         @shr,'',@yzbh_pcsj,@yzbh_xtbz,0,@errmsg output  
    if @errmsg like 'F%'  
    begin  
      rollback tran   
      deallocate cs_yzsh_bh_cq    
      select "F",substring(@errmsg,2,49)  
      return    
    end  
    fetch cs_yzsh_bh_cq into @yzbh_syxh,@yzbh_yzxh,@yzbh_zxks,@yzbh_bqdm,@shr,@yzzt  
   end   
   close cs_yzsh_bh_cq  
   deallocate cs_yzsh_bh_cq   
   ---------------ҽ���ջ�����----------------------------------------------------------------------------------   
            commit tran  
     
   select "T",@shnr  
   return        
        end        
  if (select config from  YY_CONFIG (nolock) where id = 'Y002')='��' ----����Y002 (����)�Ƿ���Ҫҽ������ Ϊ �� start  
  begin  
   --�����õ�������¼����Ϊ����  
   update YY_BRSPXMK  
   set yyspsl = b.ypsl  , spbz = 2  
   from YY_BRSPXMK a, BQ_LSYZK b,#yjm_bq_lsyzk wls  
   where a.syxh = @syxh  
   and a.syxh = b.syxh  
   and b.xh=wls.xh  
   and a.idm = b.idm  
   and a.ypdm = b.ypdm  
   and a.spbz = 1  
   and b.xh=@fzxh and b.yzzt=0  
   and charindex( ','+convert(varchar(100),b.fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
  end ----����Y002 (����)�Ƿ���Ҫҽ������ Ϊ �� end  
  if @@error<>0  
  begin  
   rollback tran  
   select "F","����������Ϣʧ�ܣ�"  
   return  
  end  
  
  --�����õ�ְ��������¼����Ϊ����  
  if exists (select 1 from BQ_BRXZYYSQK(nolock) where syxh = @syxh and spbz = 1)  
  begin  
   --�����õ�������¼����Ϊ����  
   update BQ_BRXZYYSQK  
   set spbz = 2  
   from BQ_BRXZYYSQK a, BQ_CQYZK b,#yjm_bq_cqyzk wcq  
   where a.syxh = @syxh  
   and a.syxh = b.syxh  
   and b.xh=wcq.xh  
   and a.idm = b.idm  
   and a.ypdm = b.ypdm  
   and a.spbz = 1  
   and b.xh=@fzxh and b.yzzt=0  
   and a.sqry = b.ysdm  
   and charindex( ','+convert(varchar(100),b.fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
  end  
  if @@error<>0  
  begin  
   rollback tran  
   select "F","����ְ��������Ϣʧ�ܣ�"  
   return  
  end  
       
  select @yzlb=yzlb,  
--   @ysdm=ysdm,  
   @ysdm=lrczyh,  --˭ֹͣҽ����ҽ��ֹͣ����ʾ˭,������ʾֹͣҽ���������  
   @tzxh=tzxh,  
   @tzrq=tzrq,  
   @ksrq=ksrq,  
   @ypdm=ypdm,  
   @mzdm=mzdm,  
   @ypmc=ypmc,  
   @zxksdm=zxksdm,  
   @ztnr=convert(varchar(24),ztnr),  
   @yznr = ypmc  
  from BQ_LSYZK   
  where syxh=@syxh and yexh = @yexh and xh=@fzxh and yzzt in (0,3) and xh in (select xh from #yjm_bq_lsyzk)  
  if @@rowcount=0 or @@error<>0  
  begin  
   rollback tran  
   select "F","�����ʱҽ������"  
   return  
  end  
  
        if @issh='��' --������6293 ҽ�����ʱ������ҩƷ�Ƿ������ Ϊ �� start  
        begin  
            --����if QQQQ start  
            if exists(select 1 from BQ_LSYZK a(nolock),BQ_BRGMJLK b (nolock),#yjm_bq_lsyzk wls  
                where a.syxh=@syxh and a.yexh = @yexh and a.fzxh=@fzxh and a.yzzt=0 and a.xh=wls.xh and a.syxh=b.syxh and a.gg_idm=b.gg_idm   
    and b.gmlx in (1,6,7) and b.jlzt=0)  
                    set @shnr = '�ò���ҽ���������ԵĹ���ҩƷ�������Ӧҽ��û�����ͨ����'  
            -- ����if QQQQ end  
  
            if @config6480<>'��' --��������6480 �Ƿ�ʹ��ҽ��(EMRҽ�����)�뻤ʿ�ֿ���˵Ļ��� Ϊ �� start  
            begin  
    if @config0251='��' or @config6D87='��'  
    begin  
     insert into #yshyz  
     select distinct a.xh,0,1  
     from BQ_LSYZK a inner join #yjm_bq_lsyzk wls on wls.xh=a.xh  
        where a.syxh=@syxh and a.yexh = @yexh and a.fzxh=@fzxh and a.yzzt=0   
      and  not exists (  
       select 1   
       from BQ_LSYZK b,BQ_BRGMJLK c  
       where b.syxh=@syxh and b.yexh = @yexh and b.fzxh=@fzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
       and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh )  
      and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
      and ( (@sfxyzlc=0) or (a.yzlb<>2) or (isnull(a.ssyzzt,0)=2 ) )  
      AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))       
    end  
    update BQ_LSYZK set shrq=@now,  
     shczyh=@czyh,  
     yzzt=1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end  
     ,gxrq=@now  
    from BQ_LSYZK a inner join #yjm_bq_lsyzk wls on wls.xh=a.xh  
    where a.syxh=@syxh and a.yexh = @yexh and a.fzxh=@fzxh and a.yzzt=0   
     and  not exists (  
      select 1   
      from BQ_LSYZK b,BQ_BRGMJLK c  
      where b.syxh=@syxh and b.yexh = @yexh and b.fzxh=@fzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
      and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh )  
     and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
                    and ( (@sfxyzlc=0) or (a.yzlb<>2) or (isnull(a.ssyzzt,0)=2 ) )  
                    AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
            end --��������6480 �Ƿ�ʹ��ҽ��(EMRҽ�����)�뻤ʿ�ֿ���˵Ļ��� Ϊ �� end  
            else  
            begin --��������6480 �Ƿ�ʹ��ҽ��(EMRҽ�����)�뻤ʿ�ֿ���˵Ļ��� Ϊ �� start  
    if @emrsybz = 0 -- if if @emrsybz = 0 start  
    begin  
     if @config0251='��' or @config6D87='��'  
     begin  
      insert into #yshyz  
      select distinct a.xh,0,1  
      from BQ_LSYZK a inner join #yjm_bq_lsyzk wls on wls.xh=a.xh  
      where a.syxh=@syxh and a.yexh = @yexh and a.fzxh=@fzxh and a.yzzt=0 and  not exists (  
       select 1   
       from BQ_LSYZK b,BQ_BRGMJLK c  
       where b.syxh=@syxh and b.yexh = @yexh and b.fzxh=@fzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
       and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh)  
       and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
      and isnull(a.yshdbz,0)=1 and ( (@sfxyzlc=0) or (a.yzlb<>2) or (isnull(a.ssyzzt,0)=2 ) )  
      AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
     end  
     update BQ_LSYZK set shrq=@now,  
     shczyh=@czyh,  
     yzzt=1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
     ,gxrq=@now  
     from BQ_LSYZK a inner join #yjm_bq_lsyzk wls on wls.xh=a.xh  
     where a.syxh=@syxh and a.yexh = @yexh and a.fzxh=@fzxh and a.yzzt=1   
      and  not exists (  
        select 1   
        from BQ_LSYZK b,BQ_BRGMJLK c  
        where b.syxh=@syxh and b.yexh = @yexh and b.fzxh=@fzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
        and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh)  
      and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
      and isnull(a.yshdbz,0)=1 and ( (@sfxyzlc=0) or (a.yzlb<>2) or (isnull(a.ssyzzt,0)=2 ) )  
      AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
    end -- if if @emrsybz = 0 end  
    else if @emrsybz = 1 ---- if if @emrsybz = 1 start  
    begin  
     update BQ_LSYZK set yshdbz = 1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
     ,gxrq=@now  
     from BQ_LSYZK a inner join #yjm_bq_lsyzk wls on wls.xh=a.xh  
     where a.syxh=@syxh and a.yexh = @yexh and a.fzxh=@fzxh and a.yzzt=0   
      and  not exists (  
        select 1   
        from BQ_LSYZK b,BQ_BRGMJLK c  
        where b.syxh=@syxh and b.yexh = @yexh and b.fzxh=@fzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
        and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh)  
      and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @LSfzxh+ ',' )<=0 and isnull(a.yshdbz,0)=0  
      AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
    end -- if if @emrsybz = 1 end  
            end --��������6480 �Ƿ�ʹ��ҽ��(EMRҽ�����)�뻤ʿ�ֿ���˵Ļ��� Ϊ �� end  
        end --������6293 ҽ�����ʱ������ҩƷ�Ƿ������ Ϊ �� end  
        else  
        begin --������6293 ҽ�����ʱ������ҩƷ�Ƿ������ Ϊ �� start  
            if @config6480<>'��' ----��������6480 �Ƿ�ʹ��ҽ��(EMRҽ�����)�뻤ʿ�ֿ���˵Ļ��� Ϊ �� start  
            begin  
                if @config0251='��' or @config6D87='��'  
                begin  
                 insert into #yshyz  
                    select  distinct  xh,0,1   
                    from BQ_LSYZK a  
                    where syxh=@syxh and yexh = @yexh and fzxh=@fzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
      and xh in (select xh from #yjm_bq_lsyzk)  
                        and ( (@sfxyzlc=0) or (yzlb<>2) or (isnull(ssyzzt,0)=2 ) )  
                    AND ((@config6788=1)OR(xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
                end  
    update BQ_LSYZK set shrq=@now,  
    shczyh=@czyh,  
    yzzt=1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end  
    ,gxrq=@now  
    from BQ_LSYZK a  
    where syxh=@syxh and yexh = @yexh and fzxh=@fzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
     and xh in (select xh from #yjm_bq_lsyzk)  
                    and ( (@sfxyzlc=0) or (yzlb<>2) or (isnull(ssyzzt,0)=2 ) )  
     AND ((@config6788=1)OR(xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))         
            end ----��������6480 �Ƿ�ʹ��ҽ��(EMRҽ�����)�뻤ʿ�ֿ���˵Ļ��� Ϊ �� end  
            else  
            begin ----��������6480 �Ƿ�ʹ��ҽ��(EMRҽ�����)�뻤ʿ�ֿ���˵Ļ��� Ϊ �� start  
    if @emrsybz = 0 ----if @emrsybz = 0  start   
    begin  
     if @config0251='��' or @config6D87='��'  
     begin  
      insert into #yshyz  
      select  distinct  xh,0,1   
      from BQ_LSYZK a  
      where syxh=@syxh and yexh = @yexh and fzxh=@fzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
      and isnull(yshdbz,0)=1  
      and xh in (select xh from #yjm_bq_lsyzk)  
                        and ( (@sfxyzlc=0) or (yzlb<>2) or (isnull(ssyzzt,0)=2 ) )  
                        AND ((@config6788=1)OR(xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
     end  
     update BQ_LSYZK set shrq=@now,  
     shczyh=@czyh,  
     yzzt=1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
     ,gxrq=@now  
     from BQ_LSYZK a  
     where syxh=@syxh and yexh = @yexh and fzxh=@fzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
      and isnull(yshdbz,0)=1  
      and xh in (select xh from #yjm_bq_lsyzk)  
                        and ( (@sfxyzlc=0) or (yzlb<>2) or (isnull(ssyzzt,0)=2 ) )  
                        AND ((@config6788=1)OR(xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
    end  ----if @emrsybz = 0  end   
    else if @emrsybz = 1   ----if @emrsybz = 1  start   
    begin  
     update BQ_LSYZK set yshdbz = 1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
     ,gxrq=@now  
     from BQ_LSYZK a  
     where syxh=@syxh and yexh = @yexh and fzxh=@fzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @LSfzxh+ ',' )<=0   
      and isnull(yshdbz,0)=0  
      and xh in (select xh from #yjm_bq_lsyzk)  
      AND ((@config6788=1)OR(xh NOT in (SELECT yzxh FROM BQ_LSYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
    end  ----if @emrsybz = 1  end          
            end ----��������6480 �Ƿ�ʹ��ҽ��(EMRҽ�����)�뻤ʿ�ֿ���˵Ļ��� Ϊ �� start  
        end --������6293 ҽ�����ʱ������ҩƷ�Ƿ������ Ϊ �� end  
    if @@error<>0  
  begin  
         rollback tran  
      select "F","�����ʱҽ������"  
      return  
  END  
     
  select @shyzcount = @shyzcount + @@rowcount  
                  
  if @yzlb=9 --��ֹͣҽ�� ��ʼ  
  BEGIN  
      select @tzxh = fzxh  
      from BQ_CQYZK(nolock) where xh=@tzxh --and xh in (select xh from #yjm_bq_cqyzk)       
      if @@rowcount=0 or @@error<>0  
      begin  
       rollback tran  
       select "F","�����ʱҽ������"  
       return  
      end  
      select @tzyy=0    
   if SUBSTRING(@yznr,1,3)='��ͣ*'    
    select @tzyy=1    
   else if SUBSTRING(@yznr,1,3)='��ͣ*'    
    select @tzyy=4    
   else if SUBSTRING(@yznr,1,3)='��ͣ*'    
    select @tzyy=5  
   --add by hhy ���������ͣҽ��������ҽ����ֹͣҽ����Ӧ���ǿ�����ҽ����ҽ����������ԭ��¼��ҽ����ҽ��   
   --����������������ҽ����shczy��Ӧ�øĳɵ�ǰ����Ա  
   if @tzyy = 1  
   begin  
    select @ysdm = a.lrczyh from BQ_CQYZK a(nolock) inner join #yjm_bq_cqyzk wcq on wcq.xh=a.xh where a.syxh = @syxh and a.fzxh > @tzxh and a.yzzt = 2 and a.yzlb = 14   
    if exists(select 1 from BQ_CQYZK a(nolock) inner join #yjm_bq_cqyzk wcq on wcq.xh=a.xh where a.syxh = @syxh and a.fzxh > @tzxh and a.yzzt = 2 and a.yzlb = 14 and ltrim(rtrim(a.shczyh)) = "")  
     update BQ_CQYZK set shczyh = @czyh where syxh = @syxh and fzxh > @tzxh and yzzt = 2 and yzlb = 14 and xh in (select xh from #yjm_bq_cqyzk)  
    if @@ERROR <> 0  
    begin  
     rollback tran  
     deallocate cs_tzyz  
     select "F","��������ҽ��״̬����"  
     return  
    end  
   end  
   
      --add by kongwei ��¼���ʱ�����tzrq  
   insert into BQ_TZRQLOG(cqfzxh,syxh,lstzxh,lstzrq,czyh) values  
   (@tzxh,@syxh,@tzxh,@tzrq,@czyh)  
   
   -- add by hhy end  
   --exec usp_bq_tzyz @syxh,@czyh,@tzrq,@ysdm,0,@errmsg output,1,@tzxh, 0, @yexh  
   exec usp_bq_tzyz @syxh,@czyh,@tzrq,@ysdm,@tzyy,@errmsg output,1,@tzxh, 0, @yexh  
   if @errmsg like "F%"  
   begin  
    rollback tran  
    select "F",substring(@errmsg,2,49)  
    return  
   end  
           if @config0251='��' or @config6D87='��'  
        begin  
             insert into #yshyz  
    select  distinct  xh,0,2   
    from BQ_LSYZK   
    where syxh=@syxh and yexh = @yexh and fzxh=@fzxh and xh in (select xh from #yjm_bq_lsyzk)  
      if @@error<>0  
    begin  
     rollback tran  
     select "F","���ֹͣҽ������"  
     return  
    end  
     end  
   update BQ_LSYZK set zxrq=@now,  
    zxczyh=@czyh,  
    yzzt=2,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end  
    ,gxrq=@now  
   where syxh=@syxh and yexh = @yexh and fzxh=@fzxh and xh in (select xh from #yjm_bq_lsyzk)  
   if @@error<>0  
   begin  
    rollback tran  
    select "F","���ֹͣҽ������"  
    return  
   end  
  end --��ֹͣҽ�� ����  
  else if @yzlb=2 --��if [yzlb 2����] start  
  begin  
   if (select config from YY_CONFIG (nolock) where id="G090")='��' or @configks20>0  
   begin   
    ----��������G090 ����֪ͨ���Ƿ����� Ϊ ��  ���� KS20����>0 ʹ�ÿ�����ҩƷ����ϵͳ2.0 start  
/*  
    select @ssdj = 0  
    select @ssdj = isnull(a.ssjs,0) from SS_SSDJDMK a (nolock),  SS_SSMZK  b (nolock)  
    where b.id =@ypdm  
    and b.djdm = a.id  
    if (@@error<>0)   
    begin  
     rollback tran  
     select "F","ȡ�����ȼ�ʧ�ܣ�"  
     return  
    end  
      
    if exists (select 1 from SS_SSDJK where syxh = @syxh and jlzt = 0 and shzt = @ssdj and yzxh = 0 and ssdm = @ypdm)  
    begin  
     update SS_SSDJK  
     set yzxh =@fzxh  
     from SS_SSDJK a   
     where a.syxh = @syxh  
     and a.jlzt = 0  
     and a.shzt = @ssdj  
     and a.yzxh = 0  
     and a.ssdm = @ypdm  
     if (@@error<>0) or ( @@rowcount=0)  
     begin  
      rollback tran  
      select "F","��������֪ͨ��ʧ�ܣ�"  
      return  
     end  
    end  
    else  
    begin  
     rollback tran  
     select "F","����֪ͨ��δ�����ɣ�����¼������ҽ����"  
     return  
    end  
   end  
   else  
   begin  
*/  
    if (select config from YY_CONFIG (nolock) where id="6036")='��'  
    begin   
     ----����������6036 �Ƿ�ʹ����������ϵͳ Ϊ��  start  
     --insert into SS_SSDJK(syxh, yzxh, patid, blh, hzxm, py, wb, bqdm, ksdm,   
      --cwdm, djrq, djczyh, sqrq, ssdm, ssmc, mzdm, mzmc, ssksdm,   
      --glbz, qkdj, jlzt, slbz, sslb, memo, ysdm,haabz)  
     --select @syxh, @fzxh, a.patid, a.blh, a.hzxm, a.py, a.wb, a.bqdm, a.ksdm,  
      --a.cwdm, @now, @czyh, @ksrq, @ypdm, @ypmc, @mzdm, b.name, @zxksdm,  
      --0, null, @ssjlzt, 0, 0, @ztnr, @ysdm,'-1'  
      --from ZY_BRSYK a (nolock), SS_SSMZK b (nolock)  
      --where a.syxh=@syxh and b.id=@mzdm  
     --if @@error<>0  
     --begin  
      --rollback tran  
      --select "F","�������ҽ������"  
      --return  
     --end  
       
     insert into SS_SSDJK(syxh, yzxh, patid, blh, hzxm, py, wb, bqdm, ksdm,   
      cwdm, djrq, djczyh, sqrq, ssdm, ssmc, mzdm, mzmc, ssksdm,   
      glbz, qkdj, jlzt, slbz, sslb, memo, ysdm,sqzd,haabz,aprq,jzssbz,ssyzshrq  
      )  
           select @syxh, c.xh, a.patid, a.blh, a.hzxm, a.py, a.wb, a.bqdm, a.ksdm,  
         a.cwdm,@now, @czyh,case when exists(select 1 from YY_CONFIG where id='G256' and config='��') then c.ssaprq else c.ksrq  end sqrq, c.ypdm, convert(varchar(256),c.ypmc), c.mzdm,isnull((select name from  SS_SSMZK b   
      (nolock) where b.id=c.mzdm),''), c.zxksdm,0, null,@ssjlzt, 0, 0, convert(varchar(24),c.ztnr), case isnull(c.memo,'') when '' then (case isnull((select name from  SS_SSMZK b (nolock) where b.id=c.mzdm),'') when '' then '' else c.ysdm   
      end) else c.memo end as ysdm,c.sqzd,c.haabz,c.ssaprq,c.jzssbz,@now  
           from ZY_BRSYK a (nolock)inner join BQ_LSYZK c(nolock) on a.syxh=c.syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh=@fzxh and c.yzzt in (0,1) and c.yzlb=2   
      inner join #yjm_bq_lsyzk wls on c.xh=wls.xh  
      left join BQ_LSYZK_FZ fz(nolock) on fz.yzxh=c.xh  
         where a.syxh=@syxh   
         AND not EXISTS(SELECT 1 FROM SS_SSDJK ss(NOLOCK) WHERE a.syxh=ss.syxh AND ss.yzxh=c.xh AND ss.sslb=0 AND ss.yzxh=@fzxh)   
     if @@error<>0  
     begin  
      rollback tran  
      select "F","�������ҽ������"  
      return  
     end  
     DECLARE @xhtemp_dyz ut_xh12    
     SELECT @xhtemp_dyz = scope_identity()  --add by kongwei ���ڴ�����Ӱ�� @@identity   ---����SS_SSDJK.xh  
     SELECT @xhtemp_dyz=ISNULL(@xhtemp_dyz,0)  
       
     IF @xhtemp_dyz>0  
     BEGIN  
     IF NOT EXISTS (SELECT 1 FROM SS_SSRYK a(NOLOCK),SS_SSDJK b(NOLOCK) WHERE a.ssxh=b.xh AND a.rylb=1 AND a.rydm=b.ysdm AND b.syxh=@syxh AND b.xh=@xhtemp_dyz)  
     begin   
      insert into SS_SSRYK(ssxh,rylb,rydm,ryxm,memo,isjb)  
      select e.xh,1,e.ysdm,d.name,null,0  
      from ZY_BRSYK a (nolock)  
       inner join BQ_LSYZK c(nolock) on a.syxh =c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh=e.yzxh   
       left join YY_ZGBMK d(nolock) on e.ysdm =d.id   
          where a.syxh=@syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh<=@maxlsyzxh and c.yzzt in (0,1) and c.yzlb=2 and e.xh = @xhtemp_dyz  
       and isnull(e.ysdm,'') != ''  
      if @@error<>0  
      begin  
       rollback tran  
       select "F","�������ҽ������"  
       return  
      END   
     END   
  
     --��������һ��  
     IF NOT EXISTS (SELECT 1 FROM SS_SSRYK a(NOLOCK),SS_SSDJK b(NOLOCK) WHERE a.ssxh=b.xh AND a.rylb=2 AND b.syxh=@syxh AND b.xh=@xhtemp_dyz)  
     BEGIN   
      insert into SS_SSRYK(ssxh,rylb,rydm,ryxm,memo,isjb)  
      select e.xh,2,c.ssyzysdm,d.name,null,0  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh= c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh=e.yzxh   
       left join YY_ZGBMK d(nolock) on c.ssyzysdm=d.id   
          where a.syxh=@syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh<=@maxlsyzxh and c.yzzt in (0,1) and c.yzlb=2 and e.xh = @xhtemp_dyz  
        and isnull(c.ssyzysdm,'') != ''  
      if @@error<>0  
      begin  
       rollback tran  
       select "F","�������ҽ������"  
       return  
      END  
     END  
  
     --������������  
     IF NOT EXISTS (SELECT 1 FROM SS_SSRYK a(NOLOCK),SS_SSDJK b(NOLOCK) WHERE a.ssxh=b.xh AND a.rylb=3 AND b.syxh=@syxh  AND b.xh=@xhtemp_dyz)  
     BEGIN  
      insert into SS_SSRYK(ssxh,rylb,rydm,ryxm,memo,isjb)  
      select e.xh,3,c.ssezysdm,d.name,null,0  
      from ZY_BRSYK a (nolock)  
       inner join BQ_LSYZK c(nolock) on a.syxh=c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       left join YY_ZGBMK d(nolock) on c.ssezysdm = d.id   
       inner join SS_SSDJK e(nolock) on c.xh=e.yzxh   
          where a.syxh=@syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh<=@maxlsyzxh and c.yzzt in (0,1) and c.yzlb=2 and e.xh = @xhtemp_dyz  
        and isnull(c.ssezysdm,'') != ''  
      if @@error<>0  
      begin  
       rollback tran  
       select "F","�������ҽ������"  
       return  
      end  
     END   
  
     --������������  
     IF NOT EXISTS (SELECT 1 FROM SS_SSRYK a(NOLOCK),SS_SSDJK b(NOLOCK) WHERE a.ssxh=b.xh AND a.rylb=4 AND b.syxh=@syxh AND b.xh=@xhtemp_dyz)  
     BEGIN  
      insert into SS_SSRYK(ssxh,rylb,rydm,ryxm,memo,isjb)  
      select e.xh,4,c.ssszysdm,d.name,null,0  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh  
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       left join YY_ZGBMK d(nolock) on c.ssszysdm=d.id   
       inner join SS_SSDJK e(nolock) on c.xh=e.yzxh   
          where a.syxh=@syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh<=@maxlsyzxh and c.yzzt in (0,1) and c.yzlb=2 and e.xh = @xhtemp_dyz  
        and isnull(c.ssszysdm,'') != ''  
      if @@error<>0  
      begin  
       rollback tran  
       select "F","�������ҽ������"  
       return  
      end  
                  END  
     --��ǰ���  
     insert into SS_SSZDK(ssxh,zdlb,zdlx,zddm,zdmc,memo)  
     select e.xh,0,0,e.sqzd,isnull(d.name,''),null  
     from ZY_BRSYK a (nolock)  
      inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh   
      inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
      inner join SS_SSDJK e(nolock) on c.xh =e.yzxh   
      left join YY_ZDDMK d(nolock) on e.sqzd = d.id   
     where a.syxh=@syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh<=@maxlsyzxh and c.yzzt in (0,1) and c.yzlb=2  
       and isnull(e.sqzd,'') != ''  
     if @@error<>0  
     begin  
      rollback tran  
      select "F","�������ҽ������"  
      return  
     end  
       
     if exists(select 1 from sysobjects where name='V5_SSYZK')  
     begin  
      --�������һ  
      insert into SS_SSZDK(ssxh,zdlb,zdlx,zddm,zdmc,memo)  
      select e.xh,0,1,d.SQZD1,isnull(d.SQZDMC1,''),null  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh =e.yzxh   
       left join V5_SSYZK d(nolock) on c.v5xh = d.YZXH and d.SYXH=@syxh  
      where a.syxh=@syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh<=@maxlsyzxh and c.yzzt in (0,1) and c.yzlb=2  
        and isnull(d.SQZD1,'') != ''  
        and not exists (select 1 from SS_SSZDK where ssxh = e.xh and zdlb = 0 and zdlx = 1)  
      if @@error<>0  
      begin  
       rollback tran  
       select "F","�������ҽ������"  
       return  
      end  
      --������϶�  
      insert into SS_SSZDK(ssxh,zdlb,zdlx,zddm,zdmc,memo)  
      select e.xh,0,2,d.SQZD2,isnull(d.SQZDMC2,''),null  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh =e.yzxh   
       left join V5_SSYZK d(nolock) on c.v5xh = d.YZXH and d.SYXH=@syxh   
      where a.syxh=@syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh<=@maxlsyzxh and c.yzzt in (0,1) and c.yzlb=2  
        and isnull(d.SQZD2,'') != ''  
        and not exists (select 1 from SS_SSZDK where ssxh = e.xh and zdlb = 0 and zdlx = 2)  
      if @@error<>0  
      begin  
       rollback tran  
       select "F","�������ҽ������"  
       return  
      end  
      --���������  
      insert into SS_SSZDK(ssxh,zdlb,zdlx,zddm,zdmc,memo)  
      select e.xh,0,3,d.SQZD3,isnull(d.SQZDMC3,''),null  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh =e.yzxh   
       left join V5_SSYZK d(nolock) on c.v5xh = d.YZXH and d.SYXH=@syxh  
      where a.syxh=@syxh and c.syxh=@syxh and c.yexh = @yexh and c.xh<=@maxlsyzxh and c.yzzt in (0,1) and c.yzlb=2  
        and isnull(d.SQZD3,'') != ''  
        and not exists (select 1 from SS_SSZDK where ssxh = e.xh and zdlb = 0 and zdlx = 3)  
      if @@error<>0  
      begin  
       rollback tran  
       select "F","�������ҽ������"  
       return  
      end  
     end       
     END   
       
     if (@config6A38='��')  
     begin  
      select @syxh_1=convert(varchar,@syxh),@yexh_1=convert(varchar,@yexh)  
          ,@maxlsyzxh_1=convert(varchar,@maxlsyzxh),@xhtemp_dyz_1=convert(varchar,@xhtemp_dyz)  
      --������Ա��  
      exec('insert into '+@config6C58+'dbo.JK_SS_SSRYK (xh,eventtype,opeordernumber,emptype,empcode,empname,Facility,FacilityName,  
       memo,isclude,createtime,processstatus)  
      --����ҽ��  
      select NEWID(),1,e.xh,1   --��Ա���( 0��ָ��ҽ��,1����ҽ��,2������һ��3:��������,4����������  
      --  10������ָ��,11������ 12����   
      --  20����е��ʿ,21��Ѳ�ػ�ʿ,22��ϴ�ֻ�ʿ  
      --  30����Ѫ)  
      ,e.ysdm,d.name,d.ks_id,d.ks_mc,null,0  --1�������Ӱ���Ա��0������������Ա  
      ,CONVERT(DATETIME,GETDATE(),120),1 --1:���� 2-ƽ̨�Ѷ�ȡ 3-ƽ̨����ʧ�� 4-ƽ̨����ɹ� 5-��Ч����   
      from ZY_BRSYK a (nolock)  
       inner join BQ_LSYZK c(nolock) on a.syxh =c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh=e.yzxh   
       left join YY_ZGBMK d(nolock) on e.ysdm =d.id   
          where a.syxh='+@syxh_1+' and c.syxh='+@syxh_1+' and c.yexh = '+@yexh_1+' and c.xh<='+@maxlsyzxh_1+' and c.yzzt in (0,1) and c.yzlb=2 and e.xh = '+@xhtemp_dyz_1 +'  
       and isnull(e.ysdm,"") != ""  
      union all  
      --����һ��  
      select NEWID(),1,e.xh,2,e.ysdm,d.name,d.ks_id,d.ks_mc,null,0,CONVERT(DATETIME,GETDATE(),120),1  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh= c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh=e.yzxh   
       left join YY_ZGBMK d(nolock) on c.ssyzysdm=d.id   
          where a.syxh='+@syxh_1+' and c.syxh='+@syxh_1+' and c.yexh = '+@yexh_1+' and c.xh<='+@maxlsyzxh_1+' and c.yzzt in (0,1) and c.yzlb=2 and e.xh = '+@xhtemp_dyz_1 +'  
        and isnull(c.ssyzysdm,"") != ""  
      union all  
      --��������  
      select NEWID(),1,e.xh,3,e.ysdm,d.name,d.ks_id,d.ks_mc,null,0,CONVERT(DATETIME,GETDATE(),120),1  
      from ZY_BRSYK a (nolock)  
       inner join BQ_LSYZK c(nolock) on a.syxh=c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       left join YY_ZGBMK d(nolock) on c.ssezysdm = d.id   
       inner join SS_SSDJK e(nolock) on c.xh=e.yzxh   
          where a.syxh='+@syxh_1+' and c.syxh='+@syxh_1+' and c.yexh = '+@yexh_1+' and c.xh<='+@maxlsyzxh_1+' and c.yzzt in (0,1) and c.yzlb=2 and e.xh = '+@xhtemp_dyz_1 +'  
        and isnull(c.ssezysdm,"") != ""  
      union all  
      --��������  
      select NEWID(),1,e.xh,4,e.ysdm,d.name,d.ks_id,d.ks_mc,null,0,CONVERT(DATETIME,GETDATE(),120),1  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh  
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       left join YY_ZGBMK d(nolock) on c.ssszysdm=d.id   
       inner join SS_SSDJK e(nolock) on c.xh=e.yzxh   
          where a.syxh='+@syxh_1+' and c.syxh='+@syxh_1+' and c.yexh = '+@yexh_1+' and c.xh<='+@maxlsyzxh_1+' and c.yzzt in (0,1) and c.yzlb=2 and e.xh = '+@xhtemp_dyz_1 +'  
        and isnull(c.ssszysdm,"") != ""'  
      )  
        
      --�����Ǽǿ�  
      exec('insert into '+@config6C58+'dbo.JK_SS_SSDJK (xh,eventtype,PatID,PatientID,PatientName,DateTimeofBirth,AdministrativeSex,StreetOrMailingAddress,  
        ZipOrPostalCode,AddressType,PhoneNumberHome,PhoneNumberBusiness,MaritalStatusIdentifier,MaritalStatusText,  
        EthnicGroup,EthnicGroupText,BirthPlace,Nationality,NationalityText,IDCardNo,IDCardType,IDCardTypeName,IdentifyNO,  
        PatientClass,PointOfCare,PointOfCareName,Room,Bed,Facility,FacilityName,AttendingDoctor,ReAdmissionIndicator,  
        VisitNumber,AdmitDateTime,OperationOrderNumber,PlacerOrderNumber,RequestDateTime,ScheduleDateTime,FixupDateTime,  
        OrderingFacility,UniversalServiceIdentifier,UniversalServiceText,FillerStatusCode,Position,SpecialMaterial,  
        OperationSite,IsReadyBlood,CutsRating,HepatitisIndicator,SpecialInfect,OperationDept,OperationRoom,Sequence,  
        OperationScaleID,OperationScale,AnaesthesiaMethod,EmergencyIndicator,IsolationIndicator,Memo,RequestedDoctorID,  
        createtime,processstatus)  
      select NEWID(),1,a.patid,a.blh,a.hzxm,convert(datetime,substring(a.birth,1,4)+"-"+substring(a.birth,5,2)+"-"+substring(a.birth,7,2)),  
       case when a.sex="��" then "1" when a.sex="Ů" then "2" else "9" end,k.lxdz,k.lxyb,"",k.lxdh,k.dwdh,k.hyzk,  
       case when k.hyzk="0" then "δ��"  when k.hyzk="1" then "�ѻ�"  when k.hyzk="2" then "���"   when k.hyzk="3" then "ɥż"  else "δ֪" end,   --0δ��,1�ѻ�,2���,3ɥż  
       k.mzbm,d.name,l.name+m.name+n.name,k.gjbm,e.name,a.cardno,a.cardtype,o.name,substring(a.sfzh,1,18),b.sslb,---�������  
       b.bqdm,g.name,h.fjh,b.cwdm,b.ksdm,i.name,b.ysdm,a.zycs,a.syxh,  
       convert(datetime,substring(a.ryrq,1,4)+"-"+substring(a.ryrq,5,2)+"-"+substring(a.ryrq,7,2) + " " +substring(a.ryrq,9,8)),  
       b.xh,b.yzxh,convert(datetime,SUBSTRING(b.djrq,1,4)+"-"+SUBSTRING(b.djrq,5,2)+"-"+SUBSTRING(b.djrq,7,2) + " " + SUBSTRING(b.djrq,9,8)),  
       case when b.kssj is null or rtrim(b.kssj)="" then null else convert(datetime,SUBSTRING(b.kssj,1,4)+"-"+SUBSTRING(b.kssj,5,2)+"-"+SUBSTRING(b.kssj,7,2)+" "+SUBSTRING(b.kssj,9,8)) end,  
       case when b.aprq is null or rtrim(b.aprq)="" then null else convert(datetime,SUBSTRING(b.aprq,1,4)+"-"+SUBSTRING(b.aprq,5,2)+"-"+SUBSTRING(b.aprq,7,2)+" "+SUBSTRING(b.aprq,9,8)) end,  
       j.name,b.ssdm,b.ssmc,b.jlzt,b.tw,b.tsqx,b.bwid,case when isnull(b.bx,"")<>"" then 1 else 0 end,b.qkdj,b.haabz,b.tsgr,  
       b.ssksdm,b.roomno,b.sstc,b.ssdj,p.name,b.mzmc,b.jzssbz,b.glbz,b.memo,b.ysdm,CONVERT(DATETIME,GETDATE(),120),1  
      from ZY_BRSYK a (nolock)  
       inner join SS_SSDJK b(nolock) on a.syxh=b.syxh  
       inner join ZY_BRXXK k(nolock) on a.patid=k.patid  
       left join YY_MZDMK d(nolock) on k.mzbm=d.id  
       left join YY_GJDMK e(nolock) on k.gjbm=e.id  
       left join YY_YBFLK f(nolock) on a.ybdm=f.ybdm  
       inner join ZY_BQDMK g(nolock) on b.bqdm=g.id  
       inner join ZY_BCDMK h(nolock) on b.bqdm=h.bqdm and b.cwdm=h.id   
       inner join YY_KSBMK i(nolock) on b.ksdm=i.id  
       inner join YY_KSBMK j(nolock) on b.ssksdm=j.id  
       inner join BQ_LSYZK c(nolock) on a.syxh=c.syxh and c.syxh='+@syxh_1+' and c.yexh = '+@yexh_1+' and c.xh<='+@maxlsyzxh_1+' and c.yzzt in (0,1) and c.yzlb=2   
       inner join #yjm_bq_lsyzk wls on c.xh=wls.xh    
       left join BQ_LSYZK_FZ fz(nolock) on fz.yzxh=c.xh  
       left join YY_DQDMK l(nolock) on k.csd_s=l.id and l.lb=0  
       left join YY_DQDMK m(nolock) on k.csd_djs=m.id and l.lb=1  
       left join YY_DQDMK n(nolock) on k.csd_x=n.id and l.lb=2  
       left join YY_CARDTYPE o(nolock) on a.cardtype=o.id  
       left join SS_SSDJDMK p(nolock) on b.ssdj=p.id  
          where a.syxh='+@syxh_1+'  
          AND b.xh='+@xhtemp_dyz_1+' ')  
  
      --������Ͽ�  
      exec('insert into '+@config6C58+'dbo.JK_SS_SSZDK (xh,eventtype,OperationOrderNumber,DiagnosisCode,DiagnosisDescription,DiagnosisType,DiagnosisFlag,  
       Memo,Description,createtime,processstatus)  
      --��ǰ���  
      select newid(),1,e.xh,e.sqzd,isnull(d.name,""),0  --������,(0����ǰ���,1���������,2���������)  
       ,0 --�������,(0������,1����һ����,2���ڶ�����,3����������,4�����ĸ���)  
       ,null,null,CONVERT(DATETIME,GETDATE(),120),1  
      from ZY_BRSYK a (nolock)  
      inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh   
      inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
      inner join SS_SSDJK e(nolock) on c.xh =e.yzxh   
      left join YY_ZDDMK d(nolock) on e.sqzd = d.id   
      where a.syxh='+@syxh_1+' and c.syxh='+@syxh_1+' and c.yexh = '+@yexh_1+' and c.xh<='+@maxlsyzxh_1+' and c.yzzt in (0,1) and c.yzlb=2  
       and isnull(e.sqzd,"") != ""  
      union all  
      --�������һ  
      select newid(),1,e.xh,d.SQZD1,isnull(d.SQZDMC1,""),0,1  
       ,null,null,CONVERT(DATETIME,GETDATE(),120),1  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh =e.yzxh   
       left join V5_SSYZK d(nolock) on c.v5xh = d.YZXH and d.SYXH='+@syxh_1+'  
      where a.syxh='+@syxh_1+' and c.syxh='+@syxh_1+' and c.yexh = '+@yexh_1+' and c.xh<='+@maxlsyzxh_1+' and c.yzzt in (0,1) and c.yzlb=2  
        and isnull(d.SQZD1,"") != ""  
        and not exists (select 1 from SS_SSZDK where ssxh = e.xh and zdlb = 0 and zdlx = 1)  
      union all  
      --������϶�  
      select newid(),1,e.xh,d.SQZD2,isnull(d.SQZDMC2,""),0,2  
       ,null,null,CONVERT(DATETIME,GETDATE(),120),1  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh =e.yzxh   
       left join V5_SSYZK d(nolock) on c.v5xh = d.YZXH and d.SYXH='+@syxh_1+'   
      where a.syxh='+@syxh_1+' and c.syxh='+@syxh_1+' and c.yexh = '+@yexh_1+' and c.xh<='+@maxlsyzxh_1+' and c.yzzt in (0,1) and c.yzlb=2  
        and isnull(d.SQZD2,"") != ""  
        and not exists (select 1 from SS_SSZDK where ssxh = e.xh and zdlb = 0 and zdlx = 2)  
      union all  
      --���������  
      select newid(),1,e.xh,d.SQZD3,isnull(d.SQZDMC3,""),0,3  
       ,null,null,CONVERT(DATETIME,GETDATE(),120),1  
      from ZY_BRSYK a (nolock)  
       inner join  BQ_LSYZK c(nolock) on a.syxh=c.syxh   
       inner join #yjm_bq_lsyzk wls on wls.xh=c.xh  
       inner join SS_SSDJK e(nolock) on c.xh =e.yzxh   
       left join V5_SSYZK d(nolock) on c.v5xh = d.YZXH and d.SYXH='+@syxh_1+'  
      where a.syxh='+@syxh_1+' and c.syxh='+@syxh_1+' and c.yexh = '+@yexh_1+' and c.xh<='+@maxlsyzxh_1+' and c.yzzt in (0,1) and c.yzlb=2  
        and isnull(d.SQZD3,"") != ""  
        and not exists (select 1 from SS_SSZDK where ssxh = e.xh and zdlb = 0 and zdlx = 3) ')  
     end      
    end ----����������6036 �Ƿ�ʹ����������ϵͳ Ϊ��  end  
   end  ----��������G090 ����֪ͨ���Ƿ����� Ϊ ��  ���� KS20����>0 ʹ�ÿ�����ҩƷ����ϵͳ2.0 end  
            else  
            begin ----��������G090 ����֪ͨ���Ƿ����� Ϊ ��  ���� KS20����=0 ��ʹ�ÿ�����ҩƷ����ϵͳ2.0 start  
                if (@sfxyzlc=1)  
                begin  
                    update SS_SSDJK set jlzt=0  
                    where yzxh = @fzxh and syxh=@syxh  
     if @@error<>0  
     begin  
      rollback tran  
      select "F","�������ҽ������"  
      return  
     end  
                end  
            end ----��������G090 ����֪ͨ���Ƿ����� Ϊ ��  ���� KS20����=0 ��ʹ�ÿ�����ҩƷ����ϵͳ2.0 end  
  end --��if [yzlb 2����] end  
 end  ----�������ҽ����� @yzbz (0:��ʱ) end  
 else   
 begin  ----�������ҽ����� @yzbz (1:����) start  
     declare @dc_yzzt ut_bz   --ȡ��ҽ��״̬���ж���˵���dcҽ������������yzzt=0��ҽ��   dcҽ����������  
         ,@rowcount int,@error int --��¼update�����  
     select @dc_yzzt = 0  
     select @dc_yzzt = yzzt from BQ_CQYZK where syxh=@syxh and yexh = @yexh and fzxh=@fzxh and yzzt in (0,3)   
        if @issh='��' --������6293 ҽ�����ʱ������ҩƷ�Ƿ������ Ϊ �� start  
        begin  
            --����if QQQQ start    
            if exists(select 1 from BQ_CQYZK a(nolock),BQ_BRGMJLK b (nolock)  
    where a.syxh=@syxh and a.yexh = @yexh and fzxh=@fzxh and a.yzzt=0 and a.syxh=b.syxh and a.gg_idm=b.gg_idm and b.gmlx in (1,6,7) and b.jlzt=0  
    )  
    set @shnr = '�ò���ҽ���������ԵĹ���ҩƷ�������Ӧҽ��û�����ͨ����'  
            -- ����if QQQQ end   
  
            if @config6480<>'��' --��������6480 �Ƿ�ʹ��ҽ��(EMRҽ�����)�뻤ʿ�ֿ���˵Ļ��� Ϊ �� start  
            begin  
    if @config0251 ='��' or @config6D87='��'    
    begin  
     insert into #yshyz   
     select distinct a.xh,1,1   
     from BQ_CQYZK a inner join #yjm_bq_cqyzk wcq on wcq.xh=a.xh  
     where a.syxh=@syxh and a.yexh = @yexh and a.fzxh=@fzxh and a.yzzt=0   
      and  not exists (  
       select 1   
       from BQ_CQYZK b,BQ_BRGMJLK c  
       where b.syxh=@syxh and b.yexh = @yexh and b.fzxh=@fzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
       and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh)  
      and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
      AND ((@config6788=1)OR( a.xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
  end  
    update BQ_CQYZK set shrq=@now,  
     shczyh=@czyh,  
     yzzt=1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end  
     ,gxrq=@now  
     ,ksrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
       convert(char(8),dateadd(day,1,substring(substring(ksrq,1,8),1,8)),112) +'00:01:00'  
       else ksrq end  
     ,yzxrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
       convert(char(8),dateadd(day,1,substring(substring(yzxrq,1,8),1,8)),112)   
       else yzxrq end  
     ,zxrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
       convert(char(8),dateadd(day,1,substring(substring(zxrq,1,8),1,8)),112)   
       else zxrq end  
    from BQ_CQYZK a inner join #yjm_bq_cqyzk wcq on wcq.xh=a.xh  
    where a.syxh=@syxh and a.yexh = @yexh and a.fzxh=@fzxh and a.yzzt=0   
     and  not exists (select 1  from BQ_CQYZK b,BQ_BRGMJLK c where b.syxh=@syxh and b.yexh = @yexh and b.fzxh=@fzxh   
      and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh)  
     and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
     AND ((@config6788=1)OR( a.xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
              
    select @rowcount=@@rowcount,@error=@@error   --��¼update�����  
            end --��������6480 �Ƿ�ʹ��ҽ��(EMRҽ�����)�뻤ʿ�ֿ���˵Ļ��� Ϊ �� end  
            else  
            begin --��������6480 �Ƿ�ʹ��ҽ��(EMRҽ�����)�뻤ʿ�ֿ���˵Ļ��� Ϊ �� start  
    if @emrsybz = 0 --  if @emrsybz = 0 start  
    begin  
     if @config0251 ='��' or @config6D87='��'    
     begin  
      insert into #yshyz   
      select distinct a.xh,1,1  
      from BQ_CQYZK a inner join #yjm_bq_cqyzk wcq on wcq.xh=a.xh  
      where a.syxh=@syxh and a.yexh = @yexh and a.fzxh=@fzxh and a.yzzt=0   
       and  not exists (  
        select 1   
        from BQ_CQYZK b,BQ_BRGMJLK c  
        where b.syxh=@syxh and b.yexh = @yexh and b.fzxh=@fzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
        and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh)  
       and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
       and isnull(a.yshdbz,0)=1  
       AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
     end  
     update BQ_CQYZK set shrq=@now,  
      shczyh=@czyh,  
      yzzt=1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
      ,gxrq=@now  
      ,ksrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
       convert(char(8),dateadd(day,1,substring(substring(ksrq,1,8),1,8)),112) +'00:01:00'  
       else ksrq end  
      ,yzxrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
       convert(char(8),dateadd(day,1,substring(substring(yzxrq,1,8),1,8)),112)   
       else yzxrq end  
      ,zxrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
       convert(char(8),dateadd(day,1,substring(substring(zxrq,1,8),1,8)),112)   
       else zxrq end  
     from BQ_CQYZK a inner join #yjm_bq_cqyzk wcq on wcq.xh=a.xh  
     where a.syxh=@syxh and a.yexh = @yexh and a.fzxh=@fzxh and a.yzzt=0   
      and  not exists (  
       select 1   
       from BQ_CQYZK b,BQ_BRGMJLK c  
       where b.syxh=@syxh and b.yexh = @yexh and b.fzxh=@fzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
       and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh)  
      and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
      and isnull(a.yshdbz,0)=1  
  AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
      
     select @rowcount=@@rowcount,@error=@@error   --��¼update�����  
    end --  if @emrsybz = 0 end  
    else if @emrsybz = 1 ----  if @emrsybz = 1 start  
    begin  
     update BQ_CQYZK set yshdbz = 1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
     ,gxrq=@now  
     from BQ_CQYZK a inner join #yjm_bq_cqyzk wcq on wcq.xh=a.xh  
     where a.syxh=@syxh and a.yexh = @yexh and a.fzxh=@fzxh and a.yzzt=0   
      and  not exists (  
       select 1   
       from BQ_CQYZK b,BQ_BRGMJLK c  
       where b.syxh=@syxh and b.yexh = @yexh and b.fzxh=@fzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
       and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh)  
      and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
      and isnull(a.yshdbz,0)=0  
      AND ((@config6788=1)OR(a.xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
      
     select @rowcount=@@rowcount,@error=@@error   --��¼update�����  
    end  ----  if @emrsybz = 1 end  
    end --��������6480 �Ƿ�ʹ��ҽ��(EMRҽ�����)�뻤ʿ�ֿ���˵Ļ��� Ϊ �� end  
        end --������6293 ҽ�����ʱ������ҩƷ�Ƿ������ Ϊ �� end  
        else  
        begin --������6293 ҽ�����ʱ������ҩƷ�Ƿ������ Ϊ �� start  
            if @config6480<>'��'  --��������6480 �Ƿ�ʹ��ҽ��(EMRҽ�����)�뻤ʿ�ֿ���˵Ļ��� Ϊ �� start  
            begin  
    if @config0251 ='��' or @config6D87='��'    
    begin  
     insert into #yshyz  
     select xh,1,1  
     from BQ_CQYZK  
     where syxh=@syxh  and yexh = @yexh and fzxh=@fzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
     and xh in (select xh from #yjm_bq_cqyzk)  
    end  
    update BQ_CQYZK set shrq=@now,  
    shczyh=@czyh,  
    yzzt=1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end  
    ,gxrq=@now  
    where syxh=@syxh  and yexh = @yexh and fzxh=@fzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
     and xh in (select xh from #yjm_bq_cqyzk)     
              
    select @rowcount=@@rowcount,@error=@@error   --��¼update�����  
            end --��������6480 �Ƿ�ʹ��ҽ��(EMRҽ�����)�뻤ʿ�ֿ���˵Ļ��� Ϊ �� end  
            else  
            begin --��������6480 �Ƿ�ʹ��ҽ��(EMRҽ�����)�뻤ʿ�ֿ���˵Ļ��� Ϊ �� start  
    if @emrsybz = 0 ----  if @emrsybz = 0 start  
    begin  
     if @config0251 ='��' or @config6D87='��'    
     begin  
      insert into #yshyz  
      select xh,1,1  
      from BQ_CQYZK a  
      where syxh=@syxh  and yexh = @yexh and fzxh=@fzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
      and isnull(yshdbz,0)=1  
      and xh in (select xh from #yjm_bq_cqyzk)  
      AND ((@config6788=1)OR(xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
     end  
     update BQ_CQYZK set shrq=@now,  
     shczyh=@czyh,  
     yzzt=1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
     ,gxrq=@now  
     ,ksrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
       convert(char(8),dateadd(day,1,substring(substring(ksrq,1,8),1,8)),112) +'00:01:00'  
       else ksrq end  
     ,yzxrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
       convert(char(8),dateadd(day,1,substring(substring(yzxrq,1,8),1,8)),112)   
       else yzxrq end  
     ,zxrq = case when substring(ksrq,1,8)=substring(lrrq,1,8) and charindex('"'+rtrim(zxksdm)+'"',@config6A03)>0 then            
       convert(char(8),dateadd(day,1,substring(substring(zxrq,1,8),1,8)),112)   
       else zxrq end  
     from BQ_CQYZK a  
     where syxh=@syxh  and yexh = @yexh and fzxh=@fzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
      and isnull(yshdbz,0)=1  
      and xh in (select xh from #yjm_bq_cqyzk)  
     AND ((@config6788=1)OR(xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))  
      
     select @rowcount=@@rowcount,@error=@@error   --��¼update�����  
    end ----  if @emrsybz = 0 end  
    else  
    if @emrsybz = 1 ----  if @emrsybz = 1 start  
    begin    
     update BQ_CQYZK set yshdbz = 1,@jajbz=case when (isnull(jajbz,0)=1 or @jajbz=1) then 1 else 0 end   
     ,gxrq=@now  
     from BQ_CQYZK a  
     where syxh=@syxh  and yexh = @yexh and fzxh=@fzxh and yzzt=0 and charindex( ','+convert(varchar(100),fzxh)+',' , ','+ @CQfzxh+ ',' )<=0     
      and isnull(yshdbz,0)=0   
      and xh in (select xh from #yjm_bq_cqyzk)   
     AND ((@config6788=1)OR(xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))           
      
     select @rowcount=@@rowcount,@error=@@error   --��¼update�����  
    end ----  if @emrsybz = 1 end  
            end  --��������6480 �Ƿ�ʹ��ҽ��(EMRҽ�����)�뻤ʿ�ֿ���˵Ļ��� Ϊ �� start  
        end --������6293 ҽ�����ʱ������ҩƷ�Ƿ������ Ϊ �� end  
  if @dc_yzzt <> 3  --dcҽ�����ʱ�����ж�  
  begin  
   if @error<>0 or @rowcount=0  
   begin  
    rollback tran  
    select "F","��˳���ҽ������"  
    return  
   end  
  end   
  select @shyzcount = @shyzcount + @@rowcount  
 end  ----�������ҽ����� @yzbz (1:����) end  
end ---=======================�������� 1=����ҽ��  end=====================================  
  
--add by kongwei 2017-10-09 ����195482  ������ɽ����ҽԺ--1704��������  
if (@config6C54 <> '')  
begin  
    declare @wkdz ut_mc64,@hs_yzxh ut_xh12,@hs_zxsj varchar(5),@hs_zxrq ut_rq16,@hs_ypjl ut_sl10,@errmsg_hszxyz varchar(200)  
    select @wkdz = '#hszxyz'  
      
 exec usp_bq_hszxyz @wkdz,1,@czyh,0,'','',@delphi=0,@errmsg=@errmsg_hszxyz  
 declare cs_hszxyz cursor FOR   
   select xh,substring(shrq,9,5) zxsj,shrq,ypjl from BQ_LSYZK a where a.syxh=@syxh  
     and (a.yzzt = 1 or (a.yzzt=2 and a.yzlb=9)) and a.shczyh = @czyh and a.shrq = @now and charindex('"'+convert(varchar,a.yzlb)+'"',@config6C54) > 0  
     and a.xh in (select xh from #yjm_bq_lsyzk)  
 open cs_hszxyz  
 fetch cs_hszxyz into @hs_yzxh,@hs_zxsj,@hs_zxrq,@hs_ypjl  
 while @@fetch_status=0  
 BEGIN  
     update BQ_LSYZK set zxczyh_hs=@czyh,zxrq_hs=shrq  
         where xh = @hs_yzxh and syxh = @syxh and (yzzt = 1 or (yzzt=2 and yzlb=9))  
     exec usp_bq_hszxyz @wkdz,2,@czyh,@hs_yzxh,'',@hs_zxsj,@hs_zxrq,@sjjl=@hs_ypjl,@zxks=@dqksdm,@delphi=0,@errmsg=@errmsg_hszxyz  
  fetch cs_hszxyz into @hs_yzxh,@hs_zxsj,@hs_zxrq,@hs_ypjl  
 end  
 close cs_hszxyz  
 deallocate cs_hszxyz  
 exec usp_bq_hszxyz @wkdz,3,@czyh,0,'','',@yzbz=0,@delphi=0,@errmsg=@errmsg_hszxyz  
end   
  
--==============================סԺС�������   start=========================================  
if (@config6142 = '��') and (@config6583 = '��')  
begin  
    declare @stryzxh ut_xh12,  
            @strbqdm ut_ksdm  
 declare cs_bqdm cursor FOR select xh,bqdm from BQ_LSYZK a where a.syxh=@syxh  and  a.yzlb=14  
     and a.yzzt = 1 and a.shczyh = @czyh and a.shrq = @now  
     and not exists (select 1 from BQ_FYQQK b where b.yzxh=a.xh and a.syxh=b.syxh AND b.jlzt=0)   
     and a.xh in (select xh from #yjm_bq_lsyzk)  
 open cs_bqdm  
 fetch cs_bqdm into @stryzxh,@strbqdm  
 while @@fetch_status=0  
 BEGIN  
     update BQ_LSYZK set yzzt = 2,shrq = null,shczyh = null,zxrq=null,zxczyh=null   
     where xh = @stryzxh and syxh = @syxh and yzlb = 14 and yzzt = 1  
   and xh in (select xh from #yjm_bq_lsyzk)  
     --С�������  
        exec usp_zy_xcfsh @czyh,1,@syxh,@cflx =0   
        exec usp_zy_xcfsh @czyh,2,@syxh,@stryzxh,@czyh,@czyh,@strbqdm,@dqksdm  
        exec usp_zy_xcfsh @czyh,3,@syxh,0,@czyh,@czyh,'','',0   
  fetch cs_bqdm into @stryzxh,@strbqdm  
 end  
 close cs_bqdm  
 deallocate cs_bqdm   
end   
--==============================סԺС�������   end=========================================  
  
--swx 2015-10-14 for ����47224 �ɾ�������ҽԺ---������ʿվҽ��ִ��  
--ҽ��վ���͵�ҽ����ͬ��lyljfs��6538=��ҽ��¼�벻��ʾʱ  
if (@config6949='��')and(@config6538='��')  
begin  
 update BQ_CQYZK set lyljfs=1  
 from BQ_CQYZK a inner join #yjm_bq_cqyzk wcq on wcq.xh=a.xh  
 where a.syxh=@syxh and a.yexh = @yexh and a.xh<=@maxcqyzxh  
  and a.yzzt=1 and shrq=@now and shczyh=@czyh   --��ǰ����Ա��ǰ��˵�ҽ��  
  and  not exists (  
     select 1   
     from BQ_CQYZK b,BQ_BRGMJLK c  
     where b.syxh=@syxh and b.yexh = @yexh and b.fzxh=@fzxh and b.yzzt=0 and b.syxh=c.syxh and b.gg_idm=c.gg_idm   
     and c.gmlx in (1,6,7) and c.jlzt=0 and a.fzxh=b.fzxh  
     )  
  and charindex( ','+convert(varchar(100),a.fzxh)+',' , ','+ @CQfzxh+ ',' )<=0  
  AND ((@config6788=1)OR( a.xh NOT in (SELECT yzxh FROM BQ_CQYZK_FZ d WHERE a.syxh=d.syxh AND d.tgbz=0)))   
  and a.idm in (SELECT lj.idm FROM BQ_LJLYMX lj(nolock) WHERE lj.jlzt=0 and lj.syxh=a.syxh ) --ҩƷ������Ч�ۼƼ�¼  
end  
         
---------ҽ���ջ���ʼ-------------------------------------------------------------------------         
IF @config6D87='��'  
BEGIN  
 INSERT INTO BQ_JK_YZBHXX([guid],yzxh,cqlsbz,yzzt,zxczyh,zxsj)  
 SELECT DISTINCT @guid, a.yzxh,0,1,@czyh,  
 (SUBSTRING(@now,1,4)+'-'+SUBSTRING(@now,5,2)+'-'+SUBSTRING(@now,7,2)+' '+SUBSTRING(@now,9,8))  
 from BQ_LSYZK b (nolock)   inner join  #yshyz a(nolock) on a.yzxh=b.xh   
 where a.cqlsbz=0 and b.yzlb<>9   
  
 INSERT INTO BQ_JK_YZBHXX([guid],yzxh,cqlsbz,yzzt,zxczyh,zxsj)  
 SELECT DISTINCT @guid, a.yzxh,1,1,@czyh,  
 (SUBSTRING(@now,1,4)+'-'+SUBSTRING(@now,5,2)+'-'+SUBSTRING(@now,7,2)+' '+SUBSTRING(@now,9,8))  
 from BQ_CQYZK b (nolock) inner join  #yshyz a(nolock) on a.yzxh=b.xh   
 where a.cqlsbz=1   
END  
       
IF @config0251='��'  
BEGIN      
 declare cs_yzsh_bh_ls cursor for  --�ڶ���  
 select distinct b.syxh,a.yzxh,case isnull(@dqksdm,'') when '' then b.ksdm else @dqksdm end  
 ,b.bqdm,b.shczyh,a.yzzt    
 from BQ_LSYZK b (nolock)   inner join  #yshyz a(nolock) on a.yzxh=b.xh   
 where a.cqlsbz=0 and b.yzlb<>9   
 order by a.yzxh,a.yzzt  
 open cs_yzsh_bh_ls   
 fetch cs_yzsh_bh_ls into @yzbh_syxh,@yzbh_yzxh,@yzbh_zxks,@yzbh_bqdm,@shr,@yzzt  
 while @@fetch_status=0 ---�α� cs_cydy_yzsh while Start  
 begin  
 select @yzbh_pcsj=''   
 select @yzbh_cqlsbz=0     
 if @yzzt=1   
 begin  
 select @yzbh_xtbz=6  
 end  
 else if @yzzt=2  
 begin  
 select @yzbh_xtbz=7  
 end  
 --========������ҽ���ջ� ����1 ��ʱ������===========   
 exec usp_bq_yzbh_dy @yzbh_syxh,@yzbh_yzxh,@yzbh_cqlsbz,@yzbh_zxks,@yzbh_bqdm,  
 @shr,'',@yzbh_pcsj,@yzbh_xtbz,0,@errmsg output  
 if @errmsg like 'F%'  
 begin  
 rollback TRAN  
 deallocate cs_yzsh_bh_ls     
 select "F",substring(@errmsg,2,49)  
 return    
 end  
 fetch cs_yzsh_bh_ls into @yzbh_syxh,@yzbh_yzxh,@yzbh_zxks,@yzbh_bqdm,@shr,@yzzt  
 end   
 close cs_yzsh_bh_ls  
 deallocate cs_yzsh_bh_ls     
  
 declare cs_yzsh_bh_cq cursor for  
 select distinct b.syxh,a.yzxh,case isnull(@dqksdm,'') when '' then b.ksdm else @dqksdm end,  
 b.bqdm,b.shczyh,a.yzzt    
 from BQ_CQYZK b (nolock) inner join  #yshyz a(nolock) on a.yzxh=b.xh   
 where a.cqlsbz=1   
 order by a.yzxh,a.yzzt  
 open cs_yzsh_bh_cq   
 fetch cs_yzsh_bh_cq into @yzbh_syxh,@yzbh_yzxh,@yzbh_zxks,@yzbh_bqdm,@shr,@yzzt   
 while @@fetch_status=0 ---�α� cs_cydy_yzsh while Start  
 begin  
 select @yzbh_pcsj=''   
 select @yzbh_cqlsbz=1  
 if @yzzt=1   
 begin  
 select @yzbh_xtbz=6  
 end  
 else if @yzzt=2  
 begin  
 select @yzbh_xtbz=7  
 end  
 else if @yzzt=4  --ֹͣ���  
 begin  
 select @yzbh_xtbz=10  
 end  
 --========������ҽ���ջ� ����2 ���� ������===========      
 exec usp_bq_yzbh_dy @yzbh_syxh,@yzbh_yzxh,@yzbh_cqlsbz,@yzbh_zxks,@yzbh_bqdm,  
 @shr,'',@yzbh_pcsj,@yzbh_xtbz,0,@errmsg output  
 if @errmsg like 'F%'  
 begin  
 rollback tran   
 deallocate cs_yzsh_bh_cq    
 select "F",substring(@errmsg,2,49)  
 return    
 end  
 fetch cs_yzsh_bh_cq into @yzbh_syxh,@yzbh_yzxh,@yzbh_zxks,@yzbh_bqdm,@shr,@yzzt  
 end   
 close cs_yzsh_bh_cq  
 deallocate cs_yzsh_bh_cq   
END     
---------------ҽ���ջ�����----------------------------------------------------------------------------------   
if @config6800='1' --����Σ�ر�־ҽ������,Σ��ҽ��ֻ����Ϊ��ʱҽ���´�--������ 2014-03-06 caoshuang ����6800Ϊ2�����������yzlb�ж�  
begin  
 if exists(select 1 from BQ_LSYZK a(nolock) where a.syxh=@syxh and a.yzzt=1 and idm=0 AND  LTRIM(RTRIM(a.ypdm))<>'' AND  (a.ypdm=@configG107 or a.ypdm=@configG108))  
 begin  
  update ZY_BRSYK set wzjb=1 where syxh=@syxh  
  if @@error<>0 or @@rowcount=0  
  begin  
    rollback tran  
    select "F","���ҽ�����µ�ǰ����Σ�ر�־����"  
    return  
  end     
 end  
end  
if @config6800='2'--����yzlb������ wzjb  2014-03-06 caoshuang add  for 193728   
begin  
  select  yzlb  into #yzlb_6800 from BQ_LSYZK where 1=2 --�����ò���yzlb��ʱ��  
  insert into #yzlb_6800  
  select yzlb from BQ_LSYZK where syxh=@syxh and yzzt in(1,2) group by yzlb--��������������yzlb  
  insert into #yzlb_6800 --���볤��������yzlb  
  select yzlb from BQ_CQYZK a where syxh=@syxh and yzzt in(1,2)   
  and not exists(select 1 from BQ_LSYZK b where b.syxh=@syxh and b.yzzt=2 and b.yzlb=9 and b.tzxh=a.xh) --�ų���ֹͣҽ������ĳ���ҽ��  
  group by yzlb  
  if exists(select 1 from #yzlb_6800 where yzlb=16) and not exists(select 1 from #yzlb_6800 where yzlb=17)--ֻ��16�����  
  begin  
      update ZY_BRSYK set wzjb=2 where syxh=@syxh   
      if @@error<>0 or @@rowcount=0  
   begin  
   rollback tran  
   select "F","���ҽ�����µ�ǰ����Σ�ر�־����"  
   return  
   end     
  end  
   if exists(select 1 from #yzlb_6800 where yzlb=17) and not exists(select 1 from #yzlb_6800 where yzlb=16)--ֻ��17�����  
  begin  
      update ZY_BRSYK set wzjb=3 where syxh=@syxh   
      if @@error<>0 or @@rowcount=0  
   begin  
   rollback tran  
   select "F","���ҽ�����µ�ǰ����Σ�ر�־����"  
   return  
   end     
  end  
  if exists(select 1 from #yzlb_6800 where yzlb=17)  and  exists(select 1 from #yzlb_6800 where yzlb=16)--17 16��������  
  begin  
      update ZY_BRSYK set wzjb=1 where syxh=@syxh   
      if @@error<>0 or @@rowcount=0  
   begin  
   rollback tran  
   select "F","���ҽ�����µ�ǰ����Σ�ر�־����"  
   return  
   end     
  end  
   if (not exists(select 1 from #yzlb_6800 where yzlb=17))  and (not exists(select 1 from #yzlb_6800 where yzlb=16))--17 16 ��û�е����  
  begin  
      update ZY_BRSYK set wzjb=0 where syxh=@syxh   
      if @@error<>0 or @@rowcount=0  
   begin  
   rollback tran  
   select "F","���ҽ�����µ�ǰ����Σ�ر�־����"  
   return  
   end     
  end  
end  
  
--���¸������Ѵ��ڵ�sfqrxx������  
INSERT INTO BQ_LSYZK_FZ(syxh,yzxh,sfqrxx,tgbz)  
select h.syxh,h.xh,1,1  
from BQ_LSYZK h(nolock)  
WHERE  h.syxh = @syxh and h.yzzt=1 and h.gxrq=@now  
 and not exists(select 1 from BQ_LSYZK_FZ g(nolock) where g.syxh=h.syxh and g.yzxh=h.xh)  
  
INSERT INTO BQ_CQYZK_FZ(syxh,yzxh,sfqrxx,tgbz)  
select h.syxh,h.xh,1,1  
from BQ_CQYZK h(nolock)  
WHERE  h.syxh = @syxh and h.yzzt=1 and h.gxrq=@now  
 and not exists(select 1 from BQ_CQYZK_FZ g(nolock) where g.syxh=h.syxh and g.yzxh=h.xh)  
  
UPDATE BQ_LSYZK_FZ SET sfqrxx = 1   
from BQ_LSYZK_FZ g left join BQ_LSYZK h on g.yzxh = h.xh and g.syxh = h.syxh and h.yzzt=1 and h.gxrq=@now  
WHERE  g.syxh = @syxh   
  
UPDATE BQ_CQYZK_FZ SET sfqrxx = 1   
from BQ_CQYZK_FZ g left join BQ_CQYZK h on g.yzxh = h.xh and g.syxh = h.syxh and h.yzzt=1 and h.gxrq=@now  
WHERE  g.syxh = @syxh   
  
if @config6A19 = '4'   
begin  
 UPDATE BQ_LSYZK_FZ SET zxsj1 = case when h.yzlb=7 then convert(varchar(8),dateadd(dd,1,substring(h.ksrq,1,8)+' '+substring(h.ksrq,9,8)),112) + '06:00:00' else (convert(char(8),dateadd(minute,convert(int,@config6A95_ls),substring(h.ksrq,1,8) + ' ' + subs
tring(h.ksrq,9,8)),112)   
  + convert(char(8),dateadd(minute,convert(int,@config6A95_ls),substring(h.ksrq,1,8) + ' ' + substring(h.ksrq,9,8)),8))  end  
 from BQ_LSYZK_FZ g inner join BQ_LSYZK h on g.yzxh = h.xh and g.syxh = h.syxh and h.yzzt=1 and h.gxrq=@now  
 WHERE  g.syxh = @syxh   
  
 UPDATE BQ_CQYZK_FZ SET zxsj1 = convert(char(8),dateadd(minute,convert(int,@config6A95_cq),substring(h.ksrq,1,8) + ' ' + substring(h.ksrq,9,8)),112)   
  + convert(char(8),dateadd(minute,convert(int,@config6A95_cq),substring(h.ksrq,1,8) + ' ' + substring(h.ksrq,9,8)),8)  
 from BQ_CQYZK_FZ g inner join BQ_CQYZK h on g.yzxh = h.xh and g.syxh = h.syxh and h.yzzt=1 and h.gxrq=@now  
 WHERE  g.syxh = @syxh   
end  
  
  
commit tran   --=======�������� ����============================  
  
if @config6A70 <> '0'   
begin  
 --����ҽ���������  
 declare @shxh ut_xh9  
 if (select isnull((select 1  where @now in (select shrq from BQ_YZSHDYRZ where czyh = @czyh)), 0)) = 0  
 begin  
  insert BQ_YZSHDYRZ(czyh,bqdm,dycs,dysj,scdy,shrq) values (@czyh,'',0,'',0,@now)    
  select @shxh=@@IDENTITY    
 end  
 else  
 begin  
  select top 1 @shxh=shpc from BQ_YZSHDYRZ where shrq = @now and czyh = @czyh  
 end  
 insert into BQ_YZSHDYRZMX(shpc,yzbz,xh,syxh,yexh)    
 select @shxh,0,xh,syxh,yexh   
 from BQ_CQYZK (nolock)   
 where syxh=@syxh and yexh=@yexh and xh<=@maxcqyzxh and @config6A70<>'2'    --add by kongwei for 188137  1 ȫ�� 2 ֻ��ʾֹͣҽ��   
 and (yzzt=1 and xh not in (select xh from BQ_YZSHDYRZMX where  syxh=@syxh and yexh=@yexh and yzbz=0 ) and shczyh=@czyh and shrq = @now)   
  
 insert into BQ_YZSHDYRZMX(shpc,yzbz,xh,syxh,yexh)    
 select @shxh,1,xh,syxh,yexh   
 from BQ_LSYZK (nolock)   
 where syxh=@syxh and yexh=@yexh and xh<=@maxlsyzxh and (yzzt=1 or yzzt=2) and shczyh=@czyh  and shrq = @now  
 and xh not in (select xh from BQ_YZSHDYRZMX where  syxh=@syxh and yexh=@yexh and yzbz=1 )  
 and (@config6A70<>'2' or (@config6A70='2' and yzlb = 9))                   --add by kongwei for 188137  1 ȫ�� 2 ֻ��ʾֹͣҽ��     
 --����ҽ��������ν���    
   
 if not exists(select 1 from BQ_YZSHDYRZMX where shpc = @shxh) --add by kongwei ���û�ж�Ӧ��ϸ��ɾ����¼ ����ʾ   
        delete from BQ_YZSHDYRZ where shpc = @shxh    
end  
    
--ҽ����˵����ƶ����룬���ڽ���Ӳ�������    
if exists(select 1 from YY_CONFIG(nolock) where id='6971' and config='��')  
begin  
 if @shlb=0 --ȫ�����    
 begin    
  if (@yzbz = 0) or (@yzbz = -1)     
  begin    
   insert into BQ_YDTMYZJLK(syxh,fzxh,cqlsbz,ydscbz)    
   select a.syxh,a.fzxh,0,0    
   from BQ_LSYZK a(nolock) -- ��ǰ�����ҽ�������Ѳ���Ĳ��ٲ���    
   where a.syxh=@syxh and a.yzzt=1    
   and not exists (select 1 from BQ_YDTMYZJLK b(nolock) where a.syxh=b.syxh and a.fzxh=b.fzxh and b.cqlsbz=0)    
  end    
  if (@yzbz = 1) or (@yzbz = -1)    
  begin    
   insert into BQ_YDTMYZJLK(syxh,fzxh,cqlsbz,ydscbz)    
   select a.syxh,a.fzxh,1,0    
   from BQ_CQYZK a(nolock)    
   where a.syxh=@syxh and a.yzzt=1    
   and not exists (select 1 from BQ_YDTMYZJLK b(nolock) where a.syxh=b.syxh and a.fzxh=b.fzxh and b.cqlsbz=1)    
  end    
 end    
 else --��ҽ�����    
 begin    
  if @yzbz=0    
  begin    
   insert into BQ_YDTMYZJLK(syxh,fzxh,cqlsbz,ydscbz)    
   select a.syxh,a.fzxh,0,0    
   from BQ_LSYZK a(nolock)    
   where a.syxh=@syxh and a.fzxh=@fzxh and a.yzzt=1    
   and not exists (select 1 from BQ_YDTMYZJLK b(nolock) where a.syxh=b.syxh and a.fzxh=b.fzxh and b.cqlsbz=0)    
  end    
  if @yzbz = 1    
  begin    
   insert into BQ_YDTMYZJLK(syxh,fzxh,cqlsbz,ydscbz)    
   select a.syxh,a.fzxh,1,0    
   from BQ_CQYZK a(nolock)    
   where a.syxh=@syxh and a.fzxh=@fzxh and a.yzzt=1    
   and not exists (select 1 from BQ_YDTMYZJLK b(nolock) where a.syxh=b.syxh and a.fzxh=b.fzxh and b.cqlsbz=1)    
  end    
 end    
 declare @csyxh varchar(12)  
  ,@cfzxh varchar(12)  
  ,@cyzbz varchar(1)  
 declare cs_ydtm cursor for         
 select syxh,fzxh,cqlsbz from BQ_YDTMYZJLK     
 where syxh=@syxh and isnull(ydscbz,0)=0 -- ��ǰ�����ƶ����ɱ�־Ϊ0�ģ������ƶ��ӿ���������    
 for read only        
 open cs_ydtm        
 fetch cs_ydtm into @syxh,@fzxh,@yzbz        
 while @@fetch_status=0     
 begin        
  select @csyxh=convert(varchar(12),@syxh)  
   ,@cfzxh=convert(varchar(12),@fzxh)  
   ,@cyzbz=convert(varchar(1),@yzbz)  
  exec('exec usp_nurse_yzzxjl '+@cfzxh+','+@cyzbz)   
  --exec('exec usp_bq_CreatePlanAndBarcode 1,'+@csyxh+','+@cfzxh)  
  fetch cs_ydtm into @syxh,@fzxh,@yzbz    
 end       
 close cs_ydtm        
 deallocate cs_ydtm        
end  
-- end    
  
--if exists(select 1 from sysobjects where name = 'usp_bq_crtdjdyjl')  
--begin  
-- declare @yzxh_wsh ut_xh12  
--  ,@cqlsbz int  
-- declare cs_wshyz cursor for   
--  select a.xh,0 from BQ_LSYZK a inner join #yjm_bq_lsyzk b on a.xh=b.xh   
--  where a.syxh=@syxh and a.yexh=@yexh and a.yzzt in (1,2) and substring(a.shrq,1,10) =substring(@now,1,10)   
--  union all  
--  select a.xh,1 from BQ_CQYZK a inner join #yjm_bq_cqyzk b on a.xh=b.xh   
--  where a.syxh=@syxh and a.yexh=@yexh and a.yzzt = 1  
-- for read only  
-- open cs_wshyz  
-- fetch cs_wshyz into @yzxh_wsh,@cqlsbz  
-- while @@fetch_status=0  
-- begin   
--  exec usp_bq_crtdjdyjl @bz=0   --0 ����ҽ������  1 ��������  
--   ,@syxh=@syxh  
--   ,@yexh=@yexh  
--   ,@yzxh=@yzxh_wsh  
--   ,@cqlsbz=@cqlsbz  
--  fetch cs_wshyz into @yzxh_wsh,@cqlsbz  
-- end  
-- close cs_wshyz  
-- deallocate cs_wshyz  
--end  
  
if ((((@configG014 ='��') and (@configG106 ='��')) or ((@config6461='��' or @config6481='��') and @emrsybz=1)) and (@jajbz<>-1))   
begin --- if HHHH start  
 select @fsip=ipdz from YY_USERIP(nolock) where czyh=@czyh  
 select @jsbq=bqdm,@brcw=cwdm,@hzxm=hzxm from ZY_BRSYK (nolock) where syxh=@syxh  
 select @msg=@brcw+'�����ߣ�'+@hzxm+'����ҽ������ˣ�'   --Ĭ��ֵ  
  
 if (object_id('tempdb..#msgxxlsb') is not null)  
  drop table #msgxxlsb  
    select convert(varchar(4000),'') as bz ,convert(varchar(4000),'') as tsxx into #msgxxlsb where 1=2  
 insert into #msgxxlsb   
 exec('usp_yy_msgmemo 1,' + @syxh + ',' + @yexh)   
 select @msg=tsxx from  #msgxxlsb  
  
    if (@emrsybz=1 and @config6481='��')  
    begin --- if HHHH_aaaa1 start  
  --������ҽ�������  
  if (@LSfzxh<>'' or @CQfzxh<>'')   
  begin --- if HHHH_aaaa_AA start  
   if (@shyzcount > 0)  
   begin   
    if @configG153='��'   
                    select @execmsg='exec usp_yy_autosendmsg 2,"' + ltrim(rtrim(@czyh)) + '","' + @fsip + '","' + @jsbq + '","' + @msg + '",1,'  
     --@czyh,@fsip,@jsbq,@msg,1  
    else  
                    select @execmsg='exec usp_yy_autosendmsg 2,"' + ltrim(rtrim(@czyh)) + '","' + @fsip + '","' + @jsbq + '","' + @msg + '",0,'  
     --exec usp_yy_autosendmsg 2,@czyh,@fsip,@jsbq,@msg,0  
   end  
  end --- if HHHH_aaaa_AA end  
  else  
  begin --- if HHHH_aaaa_BB start  
   if @configG153='��'   
                select @execmsg='exec usp_yy_autosendmsg 2,"' + ltrim(rtrim(@czyh)) + '","' + @fsip + '","' + @jsbq + '","' + @msg + '",1,'  
    --@czyh,@fsip,@jsbq,@msg,1  
   else  
                select @execmsg='exec usp_yy_autosendmsg 2,"' + ltrim(rtrim(@czyh)) + '","' + @fsip + '","' + @jsbq + '","' + @msg + '",0,'  
/*  
   if @configG153='��'   
    exec usp_yy_autosendmsg 2,@czyh,@fsip,@jsbq,@msg,1  
   else  
    exec usp_yy_autosendmsg 2,@czyh,@fsip,@jsbq,@msg,0  
*/  
  end  --- if HHHH_aaaa_BB end  
        select @execmsg=@execmsg+convert(varchar(10),@jajbz)  
    end --- if HHHH_aaaa1 end  
    else  
    begin --- if HHHH_aaaa2 start  
  --������ҽ�������  
  if (@LSfzxh<>'' or @CQfzxh<>'')   
  begin  
   if (@shyzcount > 0)  
   begin  
    if @configG153='��'   
     exec usp_yy_autosendmsg 2,@czyh,@fsip,@jsbq,@msg,1,@jajbz  
    else  
     exec usp_yy_autosendmsg 2,@czyh,@fsip,@jsbq,@msg,0,@jajbz  
   end  
  end  
  else  
  begin  
   if @configG153='��'   
    exec usp_yy_autosendmsg 2,@czyh,@fsip,@jsbq,@msg,1,@jajbz  
   else  
    exec usp_yy_autosendmsg 2,@czyh,@fsip,@jsbq,@msg,0,@jajbz  
  end  
    end --- if HHHH_aaaa2 end  
end --- if HHHH end  
  
  
select "T",@shnr,@execmsg  
return  
  


