Text
CREATE proc usp_yf_brty  
	@wkdz varchar(32),  
	@jszt smallint,  
	@rqbz smallint,  
	@sjh ut_sjh,  
	@czyh ut_czyh,  
	@yfdm ut_ksdm,  
	@cfxh ut_xh12,  
	@mxxh ut_xh12,  
	@tysl ut_sl10,  
	@cfts int,  
	@tyyy ut_mc32='',  
	@tyys ut_czyh=null,  --��ҩҽ��  
	@fzzr ut_czyh=null , --��������  
	@tyrq varchar(20)='', --��ҩ���ڡ�  
	@yjs  ut_czyh=null, --ҩ��ҩ��ʦ
	@memo1 ut_memo='',  --��ע1 xq90338
	@memo2 ut_memo='',  --��ע2 xq90338
	@tfyydm ut_dm2='', --��ҩԭ�����
	@delphi smallint = 1,	--0=��̨���ã� 1=ǰ̨����
	@errmsg varchar(500) = null output 
as --��118087 2019-09-27 15:04:36 4.0��׼��_201810����
/**********  
[�汾��]4.0.0.0.0  
[����ʱ��]2004.11.9  
[����]����  
[��Ȩ] Copyright ? 2004-2008�Ϻ����˴�-��������ɷ����޹�˾
[����]ҩ��������ҩ  
[����˵��]  
 �ѷ�ҩ��������ҩ���ܣ������ż��ﲡ�˺ͼҴ����˵���ҩ  
[����˵��]  
	@wkdz varchar(32), ������ַ  
	@jszt smallint,  ����״̬ 1=������2=���룬3=�ݽ�  
	@rqbz smallint,  ���ڱ�־0=�տ⣬1=���  
	@sjh ut_sjh,  �վݺ�  
	@czyh ut_czyh,  ����Ա��  
	@yfdm ut_ksdm,  ҩ������  
	@cfxh ut_xh12,  �������  
	@mxxh ut_xh12,  ��ϸ���  
	@tysl ut_sl10,  ��ҩ����  
	@cfts integer,  ��������  
	@tyyy ut_bz  ��ҩԭ��  
	@tyys ut_czyh=null,  --��ҩҽ��  
	@fzzr ut_czyh=null , --��������  
	@tyrq varchar(20)='', --��ҩ���ڡ�  
	@yjs  ut_czyh=null --ҩ��ҩ��ʦ
[����ֵ]  
[�����������]  
[���õ�sp]  
[����ʵ��]  
[�޸ļ�¼]  
 yxp 2006-6-23 ����ͣ�õ��жϷŵ���̨ʵ��  
xiaoyan 2007-5-17 ����ԭ����ҽ�� ����ҩҽ��  ����ҩ��������  ����������  �� ��ҩ���ڡ�  
xiaoyan 2007-7-2  ԭ����ҽ�� ����ҩ��������  ��������Ҫ��������
mly 2007-09-15 ����ҩƷ4.5�ӿ�  ����������
yxp 2007-10-26 �ɽ�������ҽԺҩƷ�����HISʵ��
yxp 2007-10-31 �ɽ�������ҽԺҩƷ�����HISʵ��:����SF_CFMXK.yylsj�Ĵ���
yxp 2007-10-31 �ɽ�������ҽԺҩƷ���������ҩ���޸ģ�yylsj����ʹ�ã���ȡSF_CFMXK.lcjsdj'�����㵥��'����ӡʱ����lcjsdj��ԭ�����޸�����
JL 2008-03-23 ���ӿ���3117�Ŀ��ƣ�ʵ����ҩ���˷ѵ�ʱ��ӿ��
add by mly 2008-09-19 �������﷢ҩ�˵�3007�����򿪺�ۿ��ͬʱ����SF_MZFYZD.jzbz =1 ��������ˣ�̨��û�и���
mly 2010-10-14 �޸�BUG ���﷢ҩ�˵�ʹ��jssjh ������ظ��ۿ������������xh + jzbz = 0 �����ˡ�
xwm 2011-07-26 ����ҩ�����ι���
xwm 2011-12-29 �������뷢ҩ����Ǩ�ƿ��ܲ�ͬ�������ȡ��ҩ��Ϣֱ��ʹ����ͼ
xwm 2012-02-23 ��ҩԭ��@tyyy����ut_bz���ԣ�ӦΪut_dm2
liu_ke 2012-09-13 ���Ӷ����ۼ۴���
liu_ke 2012-12-04 ����ͬ����������ͬҩƷʱ����ҩ����
caoshuang 2012-03-20 ��ҩԭ��@tyyy��Ϊut_memo ֧����ҩԭ����д������3207����
**********/  
set nocount on  

CREATE TABLE [#result](
	[rettype] [varchar](1)  NULL,
	[retmsg] [varchar](500)  NULL,--sjh
	[sjh] [ut_sjh]  NULL,
	[ypmc] [ut_mc256]  NULL,
	[ypgg] [ut_mc256] NULL,
	[ypdj] [numeric](12, 4) NULL,
	tysl ut_sl10 NULL,
	[sl]  ut_sl10 NULL,
	[ypdw] [ut_mc32]  NULL,
	tyje ut_je14 NULL,
	[lsje] ut_je14 NULL,
	[��Ʊ��] [int] NULL,
	[�����] [ut_blh] NULL,
	[����] [ut_mc64] NULL,
	[����] [ut_cardno] NULL,
	[�Ա�] [ut_mc64] NULL,
	[����] varchar(50) NULL,
	[��������] [ut_mc64] NULL,
	[���] [ut_zdmc] NULL,
	[lrrq] [ut_rq16]  NULL,
	[zxrq] [ut_rq16] NULL,
	tysl1 ut_sl10 NULL,
	[ypsl1] ut_sl10 NULL,
	[lcjsdj]  [ut_money] NULL,
	xh  ut_xh12 NULL,--������ϸ���
	[mxxh]  ut_xh12 NULL,
	[zje] [ut_money] NULL,
	[ypsl2] ut_sl10 NULL,
	[cfts] [smallint]  NULL,
	[cfxh] ut_xh12  NULL,
	[ypyf] [varchar](500) NULL,
	[memo1] [ut_mc256] NULL,
	[memo2] [ut_mc256] NULL
)

declare @now ut_rq16  --��ǰʱ��    
select @now=convert(char(8),getdate(),112)+convert(char(8),getdate(),8)  
declare @m2550 varchar(2)
select @m2550=isnull(config,'��') from YY_CONFIG where id='2550'  

declare @patid ut_xh12,	@errmsg50 varchar(50)
--add liu_ke 2012-09-13 for �����ۼ�
declare @ypxtslt int--ҩƷϵͳ��־:0ͳһ�۸� 1���ۼ�Ȩƽ�� 2����� 3�����ۼ�
select @ypxtslt=dbo.f_get_ypxtslt() 
if @@error<>0 or @ypxtslt not in(0,1,2,3)
begin
	select @errmsg='F��ȡҩƷϵͳ��������'
    goto err
end

if exists(select 1 from YF_YFDMK a(nolock) where a.id=@yfdm and isnull(a.zdyjtzwcbz,0)=1)
begin
	select @errmsg='Fҩ������̨���Զ��½�״̬�����ܽ���������������'
    goto err
end

if not exists(select 1 from YF_TJQSZ a(nolock) where a.yfdm=@yfdm and a.jzbz=0)
begin
	select @errmsg='Fҩ��δ���ã����ܽ��п�������'
    goto err
end

declare @config3117 varchar(20)
select @config3117=config from YY_CONFIG(nolock) where id='3117'
if not (isnull(@config3117,'')='��' or isnull(@config3117,'')='��')
begin
	select @errmsg='F3117����δ��ȷ���ã�'
    goto err
end

--if (@ypxtslt=2) and (@config3117<>'��') 
--begin
--   select @errmsg='F�����ģʽ3117�����������ó��ǣ�'
--   goto err
--end

if (@ypxtslt=3) and (@config3117<>'��') 
begin
   select @errmsg='F�����ۼ�ģʽ3117�����������ó��ǣ�'
   goto err
end

declare @config3249 varchar(2)
select @config3249='��'
select @config3249 = isnull(config,'��') from YY_CONFIG(nolock) where id ='3249' 
if (ltrim(rtrim(isnull(@config3249,'')))='')
begin
    select @config3249='��'
end 

if not (isnull(@config3249,'')='��' or isnull(@config3249,'')='��')
begin
	select @errmsg='F3249����δ��ȷ���ã�'
    goto err
end

declare @config3291 varchar(2)
select @config3291='��'
select @config3291 = isnull(config,'��') from YY_CONFIG(nolock) where id ='3291' 
if (ltrim(rtrim(isnull(@config3291,'')))='')
begin
    select @config3291='��'
end 
if not (isnull(@config3291,'')='��' or isnull(@config3291,'')='��')
begin
	select @errmsg='F3291����δ��ȷ���ã�'
    goto err
end

if (@ypxtslt in(3)) and (@config3249='��')
begin
   select @errmsg='F�����ۼ�ģʽ3249������������Ϊ��'
   goto err
end

if (@ypxtslt in(3)) and (@config3291='��')
begin
   select @errmsg='F�����ۼ�ģʽ3249������������Ϊ��'
   goto err
end 

if (@config3291='��') and  (@config3249='��')
begin
   select @errmsg='F����3291��3249������ͬʱΪ�ǣ�'
   goto err
end

declare @config0325 varchar(2)
select @config0325='��'
select @config0325=config from YY_CONFIG(nolock) where id='0325'
if (ltrim(rtrim(isnull(@config0325,'')))='')
begin
    select @config0325='��'
end 
if not (isnull(@config0325,'')='��' or isnull(@config0325,'')='��')
begin
   select @errmsg='F0325����δ��ȷ���ã�'
   goto err
end

declare @config3414 varchar(2)
select @config3414='��'
select @config3414=config from YY_CONFIG(nolock) where id='3414'
if (@ypxtslt<>2) or ((ltrim(rtrim(isnull(@config3414,'')))=''))
begin
    select @config3414='��'
end 

declare @config3554 varchar(20)
select @config3554=config from YY_CONFIG(nolock) where id='3554'
if not (isnull(@config3554,'')='��' or isnull(@config3554,'')='��')
begin
    select @config3554='��'
end

declare @cnt int,@isnb ut_bz

declare @cfxh0 ut_xh12,--�״δ���
        @curr_sychxh ut_xh12,--��ǰʣ�ദ��
        @lbcfxh ut_xh12, --������
        @lbcfxh_type ut_bz, --����������   0ʣ�� 1���
        @lbcfxh_isnb ut_bz, --����־ 0�� 1�����
        @lbtxh ut_xh12 --�����

declare @lbfyzdxh ut_xh12, --����ҩ�����
        @lbfyzdxh_czdm ut_dm2, --����ҩ���������  09��ҩ 10��ҩ 
        @lbfyzdxh_jzbz ut_bz, --����ҩ�����˱�־
        @lbfyzdxh_isnb ut_bz, --����ҩ������־ 0�� 1�����
        @lbfyzdxh_memo ut_memo, --����ҩ��memo
        @lbfyzdxh_cfdybz ut_bz --����ҩ��������Ӧ��־

declare @ypmc ut_mc64 

declare @cfmx_tmxxh ut_xh12,@cfmx_tmxxh_dycfxh ut_xh12 --������ϸ ����ϸ���   �� ����ϸ��Ŷ�Ӧ�Ĵ������

declare @tmpxh ut_xh12 

declare @error int, @rowcount int

declare @maxloop ut_xh12
declare @yb_fymxxh ut_xh12,@tmp_fymxxh ut_xh12,@tmp_tfymxxh ut_xh12 


 --mly 2007-09-15
declare @czdm varchar(2)      --�����������
if exists(select 1 from xtdldm where xtdldm='3' and vertion='4.5')     
select @czdm = '32'
else
select @czdm = '10'

declare @xhtemp ut_xh12	--��ҩ�ʵ����

declare @config3183 ut_bz
select @config3183=0
select @config3183=isnull(config,0) from YY_CONFIG (nolock) where id='3183'

--���ɵݽ�����ʱ��  
declare @tablename varchar(32)  
select @tablename='##yfty'+ltrim(rtrim(isnull(@wkdz,'')))+ltrim(rtrim(isnull(@czyh,'')))
  
if @jszt=1  
begin  
	exec('if exists(select * from tempdb..sysobjects where name="'+@tablename+'")  
	drop table '+@tablename)  
	exec('create table '+@tablename+'(  
	cfxh ut_xh12 not null,  
	mxxh ut_xh12 not null,  
	cfts int not null,  
	tysl ut_sl10 not null 
	,memo1 ut_memo null
	,memo2 ut_memo null 
	)')  
	if @@error<>0  
	begin  
		select @errmsg='������ʱ��ʱ����'
        goto err  
	end  

	delete from #result
	insert into #result(rettype,retmsg) select 'T' rettype,'' retmsg
	goto success 
end  
--����ݽ��ļ�¼  
if @jszt=2  
begin  
	declare @ccfxh varchar(12),  
			@cmxxh varchar(12),  
			@ccfts varchar(8),  
			@ctysl varchar(12)  

	select  @ccfxh=convert(varchar(12),@cfxh),  
			@cmxxh=convert(varchar(12),@mxxh),  
			@ccfts=convert(varchar(8),@cfts),  
			@ctysl=convert(varchar(12),@tysl)  

	exec('insert into '+@tablename+' values('+@ccfxh+','+@cmxxh+','+@ccfts+','+@ctysl+',"'+@memo1+'","'+@memo2+'"'+')')  
	if @@error<>0 
	begin  
		select @errmsg='������ʱ��ʱ����'
        goto err  
	end  

	delete from #result
	insert into #result(rettype,retmsg) select 'T' rettype,'' retmsg
	goto success  
end  
  
if @jszt=3  --- if @jszt=3   start
begin 
 
declare @acfdfp ut_bz       --�Ƿ񰴴�����Ʊ 0 ���ǣ� 1 ��  
if (select config from YY_CONFIG (nolock) where id='2044')='��' 
begin 
   select @acfdfp=0 
end  
else
begin  
   select @acfdfp=1
end  
  
 --��ʼ�����˵�����ϸ��Ĵ�������  
 create table #cfmx_tf  
 (  
  cfxh ut_xh12 not null,  
  mxxh ut_xh12 not null,  
  cfts int not null,  
  tysl ut_sl10 not null 
  ,memo1 ut_memo null
  ,memo2 ut_memo null  
 )  
   
 exec('insert into #cfmx_tf select * from '+@tablename)  
 if @@error<>0   
 begin  
    select @errmsg='F������ʱ��ʱ����'
    goto err 
 end  
   
 exec('drop table '+@tablename)  
 
 --�����ۼ�ģʽ��ʹ�ô˱�����¼�շ�ʱÿ�����εļ۸�
 create table #mzmxpcxxjlb
 (
  xh ut_xh12 identity not null,
  yfpcxh ut_xh12 not null,
  yplsj ut_money not null
 )
  
 select distinct cfxh, cfts 
 into #mzcf_tf 
 from #cfmx_tf (nolock) 

 --�жϵ�ǰҪ�˵�ҩƷ���ǲ���Ŀǰ���һ����Чʣ�ദ��start
 select distinct cfxh,convert(smallint,-1) isnb --�Ƿ�����־ 0�� 1��  -1δ֪
 into #tycfxhlist 
 from #cfmx_tf (nolock)

 update #tycfxhlist set isnb=0  --�ձ�
 from SF_MZCFK a(nolock),#tycfxhlist b
 where a.xh=b.cfxh

 select @cnt=count(1) from #tycfxhlist b(nolock) where isnb=-1
 if isnull(@cnt,0)>0
 begin
	update #tycfxhlist set isnb=1 --���
	from SF_NMZCFK a(nolock),#tycfxhlist b
	where a.xh=b.cfxh 
 end

 select @cnt=count(1) from #tycfxhlist b(nolock) where isnb=-1
 if isnull(@cnt,0)>0
 begin
    select @errmsg='F�������ݲ����ڣ�'
    goto err 
 end
 
 select @cnt=count(1) from #tycfxhlist b(nolock) where isnb=1
 if isnull(@cnt,0)>0 --���������
 begin
   select top 1 @patid=a.patid from VW_MZCFK a(nolock) inner join #tycfxhlist b(nolock) on a.xh=b.cfxh
   if exists (select 1 from VW_MZCFK a(nolock),#tycfxhlist b(nolock) where a.xh=b.cfxh and a.jlzt=1 and a.patid=@patid )
   begin
	   select @errmsg='F��ǰ�����ѽ��в����˷ѣ����ܽ�����ҩ0��'
       goto err   
   end
   if exists(select 1 from (
     select b.cfxh,count(1) jls from VW_MZCFK a(nolock),#tycfxhlist b(nolock)
     where a.xh=b.cfxh and a.jlzt=0 and a.patid=@patid  --�ǲ���Ŀǰ���һ����Чʣ�ദ��
     group by b.cfxh ) t1 where t1.jls<>1)
   begin
	   select @errmsg='F��ǰ�������ܽ�����ҩ1��'
       goto err  
   end
 end
 else -- ���������
 begin
   select top 1 @patid=a.patid from SF_MZCFK a(nolock) inner join #tycfxhlist b(nolock) on a.xh=b.cfxh
   if exists (select 1 from SF_MZCFK a(nolock),#tycfxhlist b(nolock) where a.xh=b.cfxh and a.jlzt=1 and a.patid=@patid )
   begin
	   select @errmsg='F��ǰ�����ѽ��в����˷ѣ����ܽ�����ҩ0��'
       goto err  
   end
   
   if exists(select 1 from (
     select b.cfxh,count(1) jls from SF_MZCFK a(nolock),#tycfxhlist b(nolock)
     where a.xh=b.cfxh and a.jlzt=0 and a.patid=@patid --�ǲ���Ŀǰ���һ����Чʣ�ദ��
     group by b.cfxh ) t1 where t1.jls<>1)
   begin
	   select @errmsg='F��ǰ�������ܽ�����ҩ1��'
       goto err   
   end   
 end
 --�жϵ�ǰҪ�˵�ҩƷ���ǲ���Ŀǰ���һ����Чʣ�ദ��end
 
--begin�ж��˷�������־�������ǰ�������˷Ѵ������������������ҩ����ȡ����ҩ����
 if exists(select 1 from VW_MZCFK a(nolock) inner join #tycfxhlist b(nolock) on a.xh=b.cfxh
            where isnull(a.tfsdbz,0)=1 and a.jlzt=0 and a.patid=@patid )
 begin
	   select @errmsg='F��ǰ�������˷Ѵ�����,���ܽ�����ҩ7��'
       goto err 
 end        
--end�ж��˷�������־�������ǰ�������˷Ѵ������������������ҩ����ȡ����ҩ����

--begin�жϲ�����ҩ�Ƿ��ж�������ҩ��־
declare @config3326 varchar(10)
select @config3326='��'
select @config3326=isnull(config,'��') from YY_CONFIG (nolock) where id='3326'
if (@config3326='��')
begin
    if exists (select 1 from VW_MZCFK a(nolock) inner join #tycfxhlist b(nolock) on a.xh=b.cfxh
      where ISNULL(a.yxtybz,0)=0 and a.jlzt=0 and a.patid=@patid )
    begin
	   select @errmsg='F��ǰ�д���δ�����ͨ�����������ͨ������������ҩ��'
       goto err      
    end           
end
--end�жϲ�����ҩ�Ƿ��ж�������ҩ��־


--������������start
--��������
create table #tmp_cflianb(
recno ut_xh12  identity(1,1) not null,
cfxh0 ut_xh12 null,--�״δ���
curr_sychxh ut_xh12 null,--��ǰʣ�ദ��
lbcfxh ut_xh12 null, --������
lbcfxh_type ut_bz null, --����������   0ʣ�� 1���
lbcfxh_isnb ut_bz null  --����־ 0�� 1�����
)
--����������
create table #tmp_cflianb_daoxu(
recno ut_xh12  identity(1,1) not null,
cfxh0 ut_xh12 null,--�״δ���
curr_sychxh ut_xh12 null,--��ǰʣ�ദ��
lbcfxh ut_xh12 null, --������
lbcfxh_type ut_bz null, --����������   0ʣ�� 1���
lbcfxh_isnb ut_bz null, --����־ 0�� 1�����
dy_fyzdxh_czdm ut_dm2 null --��Ӧ��ҩ���������  09��ҩ 10��ҩ 
)

--���������Ӧ��ҩ��
create table #tmp_cflianb_tmpdyfyd(
recno ut_xh12  identity(1,1) not null,
cfxh0 ut_xh12 null,--�״δ���
curr_sychxh ut_xh12 null,--��ǰʣ�ദ��
lbcfxh ut_xh12 null, --������
lbcfxh_type ut_bz null, --����������   0ʣ�� 1���
lbcfxh_isnb ut_bz null, --����־ 0�� 1�����
dy_fyzdxh ut_xh12 null, --��Ӧ��ҩ�����
dy_fyzdxh_czdm ut_dm2 null, --��Ӧ��ҩ���������  09��ҩ 10��ҩ 
dy_fyzdxh_isnb ut_bz null, --��Ӧ��ҩ������־ 0�� 1�����
dy_fyzdxh_memo ut_memo null, --��Ӧ��ҩ��memo
dy_fyzdxh_cfdybz ut_bz null --��Ӧ��ҩ��������Ӧ��־
)
create table #tmp_cflianb_dyfyd(
recno ut_xh12  identity(1,1) not null,
cfxh0 ut_xh12 null,--�״δ���
curr_sychxh ut_xh12 null,--��ǰʣ�ദ��
lbcfxh ut_xh12 null, --������
lbcfxh_type ut_bz null, --����������   0ʣ�� 1���
lbcfxh_isnb ut_bz null, --����־ 0�� 1�����
dy_fyzdxh ut_xh12 null, --��Ӧ��ҩ�����
dy_fyzdxh_czdm ut_dm2 null, --��Ӧ��ҩ���������  09��ҩ 10��ҩ 
dy_fyzdxh_isnb ut_bz null, --��Ӧ��ҩ������־ 0�� 1�����
dy_fyzdxh_memo ut_memo null, --��Ӧ��ҩ��memo
dy_fyzdxh_cfdybz ut_bz null --��Ӧ��ҩ��������Ӧ��־
)

create table #tycfxhlist_order
(
  cfxh ut_xh12 null,
  isnb ut_bz null
)
delete from #tycfxhlist_order

create table #tmp_sytk_pc_cfmx3183_order
(
yfpcxh ut_xh12 null,
sykt_ypsl ut_sl10 null
)
delete from #tmp_sytk_pc_cfmx3183_order

INSERT into #tycfxhlist_order(cfxh,isnb)
select cfxh,isnb from #tycfxhlist(nolock) 
order by cfxh

declare cs_crbflb cursor 
for select cfxh,isnb from #tycfxhlist_order(nolock) 
for read only
   
open cs_crbflb
fetch cs_crbflb into @cfxh,@isnb
while @@fetch_status=0
begin  --�α꿪ʼ
   select @lbtxh=0
   if @isnb=0
     select @lbtxh=txh from SF_MZCFK a(nolock) where xh=@cfxh and a.patid=@patid
   else
     select @lbtxh=txh from VW_MZCFK a(nolock) where xh=@cfxh and a.patid=@patid
   if isnull(@lbtxh,0)=0  ---- if isnull(@lbtxh,0)=0 start
   begin
     --û������ţ�˵�����״δ�����ֻ��ʣ�࣬�޺��
     --��ǰʣ��
     select @cfxh0=@cfxh, @lbcfxh=@cfxh,@lbcfxh_type=0,@lbcfxh_isnb=@isnb
     if isnull(@lbcfxh,0)>0
     begin
       --ÿһ��ʣ�඼������ һ��09 һ��10 �ȷ��ţ�������ɾ
       insert into #tmp_cflianb_daoxu(cfxh0,curr_sychxh,lbcfxh,lbcfxh_type,lbcfxh_isnb,dy_fyzdxh_czdm)
       select @cfxh0,@lbcfxh,@lbcfxh,@lbcfxh_type,@lbcfxh_isnb,'10'
       insert into #tmp_cflianb_daoxu(cfxh0,curr_sychxh,lbcfxh,lbcfxh_type,lbcfxh_isnb,dy_fyzdxh_czdm)
       select @cfxh0,@lbcfxh,@lbcfxh,@lbcfxh_type,@lbcfxh_isnb,'09'
     end
   end  ---- if isnull(@lbtxh,0)=0 end
   else
   begin ---- if isnull(@lbtxh,0)<>0 start
      select @lbcfxh=@cfxh --��ǰʣ��
      --�ӵ�ǰʣ�࿪ʼ����
      while(@lbtxh>0) --while start
      begin
         --ʣ��
         if exists(select 1 from SF_MZCFK a(nolock) where txh=@lbtxh and xh=@lbcfxh and a.patid=@patid)
           select @lbcfxh=xh,@lbcfxh_type=0,@lbcfxh_isnb=0 from SF_MZCFK a(nolock) where txh=@lbtxh and xh=@lbcfxh and a.patid=@patid
         else
           select @lbcfxh=xh,@lbcfxh_type=0,@lbcfxh_isnb=1 from VW_MZCFK a(nolock) where txh=@lbtxh and xh=@lbcfxh and a.patid=@patid
         if isnull(@lbcfxh,0)>0
         begin
           --ÿһ��ʣ�඼������ һ��09 һ��10 �ȷ��ţ�������ɾ
           insert into #tmp_cflianb_daoxu(curr_sychxh,lbcfxh,lbcfxh_type,lbcfxh_isnb,dy_fyzdxh_czdm)
           select @cfxh,@lbcfxh,@lbcfxh_type,@lbcfxh_isnb,'10'
           insert into #tmp_cflianb_daoxu(curr_sychxh,lbcfxh,lbcfxh_type,lbcfxh_isnb,dy_fyzdxh_czdm)
           select @cfxh,@lbcfxh,@lbcfxh_type,@lbcfxh_isnb,'09'
         end
         --���
         if exists(select 1 from SF_MZCFK a(nolock) where a.patid=@patid and a.txh=@lbtxh and a.xh<>@lbcfxh)
           select @lbcfxh=xh,@lbcfxh_type=1,@lbcfxh_isnb=0 from SF_MZCFK a(nolock) where a.patid=@patid and a.txh=@lbtxh and a.xh<>@lbcfxh
         else
         begin
            if exists(select 1 from VW_MZCFK a(nolock) where a.patid=@patid and a.txh=@lbtxh and a.xh<>@lbcfxh)
              select @lbcfxh=xh,@lbcfxh_type=1,@lbcfxh_isnb=1 from VW_MZCFK a(nolock) where a.patid=@patid and a.txh=@lbtxh and a.xh<>@lbcfxh
            else
              select @lbcfxh=0
         end
         if isnull(@lbcfxh,0)>0
         begin
           insert into #tmp_cflianb_daoxu(curr_sychxh,lbcfxh,lbcfxh_type,lbcfxh_isnb)
           select @cfxh,@lbcfxh,@lbcfxh_type,@lbcfxh_isnb
         end
 
         --@lbtxhδ���¸�ֵǰ����ʾ��һ��ʣ��
         --������һ��ʣ�࣬�Ƿ���txh,���û�У���ʾ�ѵ��״δ���������������ѭ��
         select @lbcfxh=0
         select @lbtxh=txh,@lbcfxh=xh,@lbcfxh_isnb=0 from SF_MZCFK a(nolock) where xh=@lbtxh and a.patid=@patid
         if isnull(@lbcfxh,0)=0
         begin
           select @lbtxh=txh,@lbcfxh=xh,@lbcfxh_isnb=1 from VW_MZCFK a(nolock) where xh=@lbtxh and a.patid=@patid
         end
         if @lbcfxh=0 
         begin
           select @lbtxh=0
         end
         if isnull(@lbtxh,0)=0 --��ʾ�ѵ��״δ���������һ��ʣ�༴��
         begin
             --ÿһ��ʣ�඼������ һ��09 һ��10 �ȷ��ţ�������ɾ
            insert into #tmp_cflianb_daoxu(curr_sychxh,lbcfxh,lbcfxh_type,lbcfxh_isnb,dy_fyzdxh_czdm)
            select @cfxh,@lbcfxh,0,@lbcfxh_isnb,'10' 
            insert into #tmp_cflianb_daoxu(curr_sychxh,lbcfxh,lbcfxh_type,lbcfxh_isnb,dy_fyzdxh_czdm)
            select @cfxh,@lbcfxh,0,@lbcfxh_isnb,'09' 
            update #tmp_cflianb_daoxu set cfxh0=@lbcfxh where curr_sychxh=@cfxh
         end
      end --while end
   end  ---- if isnull(@lbtxh,0)<>0 end
   fetch cs_crbflb into @cfxh,@isnb  
end   --�α����
close cs_crbflb
deallocate cs_crbflb

insert into #tmp_cflianb(cfxh0,curr_sychxh,lbcfxh,lbcfxh_type,lbcfxh_isnb)
select distinct cfxh0,curr_sychxh,lbcfxh,lbcfxh_type,lbcfxh_isnb 
from #tmp_cflianb_daoxu (nolock)
order by cfxh0,curr_sychxh,lbcfxh

insert into #tmp_cflianb_tmpdyfyd(cfxh0,curr_sychxh,lbcfxh,lbcfxh_type,lbcfxh_isnb,dy_fyzdxh_czdm)
select cfxh0,curr_sychxh,lbcfxh,lbcfxh_type,lbcfxh_isnb,dy_fyzdxh_czdm 
from #tmp_cflianb_daoxu (nolock)
order by recno desc
--������������end

--select * from #tmp_cflianb
--select * from #tmp_cflianb_tmpdyfyd
--return

--������ҩ������start
--��ҩ������
create table #tmp_fydlianb(
recno ut_xh12  identity(1,1) not null,
cfxh0 ut_xh12 null,--�״δ���
curr_sychxh ut_xh12 null,--��ǰʣ�ദ��
lbcfxh ut_xh12 null, --������
lbfyzdxh ut_xh12 null, --����ҩ�����
lbfyzdxh_czdm ut_dm2 null, --����ҩ���������  09��ҩ 10��ҩ 
lbfyzdxh_jzbz ut_bz null, --����ҩ�����˱�־
lbfyzdxh_isnb ut_bz null, --����ҩ������־ 0�� 1�����
lbfyzdxh_memo ut_memo null, --����ҩ��memo
lbfyzdxh_cfdybz ut_bz null --����ҩ��������Ӧ��־
)

select xh as lbfyzdxh,jzbz as lbfyzdxh_jzbz,0 lbfyzdxh_isnb,
      convert(varchar(10),'') as lbfyzdxh_czdm,memo as lbfyzdxh_memo,
	  cfdybz as lbfyzdxh_cfdybz 
into #tmp_getfydlist
from YF_NMZFYZD (nolock)
where 1=2

--select * from #tmp_getfydlist
--return

create table #tmp_cflianb_order
(
  cfxh0 ut_xh12 null,
  curr_sychxh ut_xh12 null,
  lbcfxh ut_xh12 null,
  lbcfxh_isnb ut_bz null
)
delete from #tmp_cflianb_order

create table #tmp_pdktsl_ff2_order
(
  cfxh ut_xh12 null,
  mxxh ut_xh12 null,
  lbcfxh_isnb ut_bz null
)
delete from #tmp_pdktsl_ff2_order


INSERT into #tmp_cflianb_order
( cfxh0,curr_sychxh, lbcfxh,lbcfxh_isnb)
select cfxh0,curr_sychxh,lbcfxh,lbcfxh_isnb 
from #tmp_cflianb (nolock) 
order by recno

declare cs_crfydlb cursor 
for select a.cfxh0,a.curr_sychxh,a.lbcfxh,a.lbcfxh_isnb 
from #tmp_cflianb_order a(nolock) 

for read only

open cs_crfydlb
fetch cs_crfydlb into @cfxh0,@curr_sychxh,@lbcfxh,@lbcfxh_isnb
while @@fetch_status=0
begin  --�α꿪ʼ
   delete from #tmp_getfydlist
   if @lbcfxh_isnb=0 --//���紦����ͷ�ҩ��Ǩ��һ��
   begin
     insert into #tmp_getfydlist
     select xh as lbfyzdxh,jzbz as lbfyzdxh_jzbz,0 lbfyzdxh_isnb,'' as lbfyzdxh_czdm ,memo as lbfyzdxh_memo,cfdybz as lbfyzdxh_cfdybz 
     from YF_MZFYZD a(nolock) 
	 where cfxh=@lbcfxh  and tfbz in(0,1) and jlzt=0 and a.patid=@patid --add by guo 1207
     update #tmp_getfydlist set lbfyzdxh_czdm=b.czdm
     from #tmp_getfydlist a,YF_MZFYMX b(nolock)
     where a.lbfyzdxh=b.fyxh 
   end
   select @cnt=count(1) from #tmp_getfydlist
   if isnull(@cnt,0)=0--�����
   begin
     insert into #tmp_getfydlist
     select xh as lbfyzdxh,jzbz as lbfyzdxh_jzbz,0 lbfyzdxh_isnb,'' as lbfyzdxh_czdm,memo as lbfyzdxh_memo,cfdybz as lbfyzdxh_cfdybz 
     from VW_MZFYZD a(nolock) 
	 where cfxh=@lbcfxh and tfbz in(0,1) and jlzt=0 and a.patid=@patid --add by guo 1207
     update #tmp_getfydlist set lbfyzdxh_czdm=b.czdm
     from #tmp_getfydlist a,VW_MZFYMX b(nolock)
     where a.lbfyzdxh=b.fyxh
   end
   select @cnt=count(1) from #tmp_getfydlist
   if isnull(@cnt,0)>0
   begin
     insert into #tmp_fydlianb(cfxh0,curr_sychxh,lbcfxh,lbfyzdxh,lbfyzdxh_jzbz,lbfyzdxh_isnb,lbfyzdxh_czdm,lbfyzdxh_memo,lbfyzdxh_cfdybz)
     select @cfxh0,@curr_sychxh,@lbcfxh,lbfyzdxh,lbfyzdxh_jzbz,lbfyzdxh_isnb,lbfyzdxh_czdm,lbfyzdxh_memo,lbfyzdxh_cfdybz
     from #tmp_getfydlist
     order by lbfyzdxh
   end
   fetch cs_crfydlb into @cfxh0,@curr_sychxh,@lbcfxh,@lbcfxh_isnb 
end   --�α����
close cs_crfydlb
deallocate cs_crfydlb
--������ҩ������end

--���´��������ж�Ӧ�ķ�ҩ��start
update #tmp_cflianb_tmpdyfyd set dy_fyzdxh=b.lbfyzdxh,dy_fyzdxh_czdm=b.lbfyzdxh_czdm,dy_fyzdxh_isnb=b.lbfyzdxh_isnb,
                        dy_fyzdxh_memo=b.lbfyzdxh_memo,dy_fyzdxh_cfdybz=b.lbfyzdxh_cfdybz
 from #tmp_cflianb_tmpdyfyd a,#tmp_fydlianb b
where a.cfxh0=b.cfxh0 and a.curr_sychxh=b.curr_sychxh and a.lbcfxh=b.lbcfxh  and isnull(a.dy_fyzdxh_czdm,'')=b.lbfyzdxh_czdm

update #tmp_cflianb_tmpdyfyd set dy_fyzdxh=b.lbfyzdxh,dy_fyzdxh_czdm=b.lbfyzdxh_czdm,dy_fyzdxh_isnb=b.lbfyzdxh_isnb,
                        dy_fyzdxh_memo=b.lbfyzdxh_memo,dy_fyzdxh_cfdybz=b.lbfyzdxh_cfdybz
 from #tmp_cflianb_tmpdyfyd a,#tmp_fydlianb b
where a.cfxh0=b.cfxh0 and a.curr_sychxh=b.curr_sychxh and a.lbcfxh=b.lbcfxh  and isnull(a.dy_fyzdxh_czdm,'')=''


--ʣ�ദ����ɾ��û�ж�Ӧ����ҩ
delete #tmp_cflianb_tmpdyfyd
  from #tmp_cflianb_tmpdyfyd a
where lbcfxh_type=0 and isnull(dy_fyzdxh,0)=0 and isnull(dy_fyzdxh_czdm,'')='10'

update #tmp_cflianb_tmpdyfyd set dy_fyzdxh_czdm=null
  from #tmp_cflianb_tmpdyfyd a
where lbcfxh_type=0 and isnull(dy_fyzdxh,0)=0


insert into #tmp_cflianb_dyfyd(cfxh0,curr_sychxh,lbcfxh,lbcfxh_type,lbcfxh_isnb,dy_fyzdxh,dy_fyzdxh_czdm,dy_fyzdxh_isnb,dy_fyzdxh_memo,dy_fyzdxh_cfdybz)
select cfxh0,curr_sychxh,lbcfxh,lbcfxh_type,lbcfxh_isnb,dy_fyzdxh,dy_fyzdxh_czdm,dy_fyzdxh_isnb,dy_fyzdxh_memo,dy_fyzdxh_cfdybz
from #tmp_cflianb_tmpdyfyd
order by recno

--���´��������ж�Ӧ�ķ�ҩ��end

----��ҩ���������������ݣ���ҩ�˵�����ϸ���������Ƿ��Ӱ���棩start

select memo into #tmp_memo from (select  '���󲹷�ҩ' memo union select '������ҩ������' memo) t1

select cfdybz into #tmp_cfdybz from 
(select  1 cfdybz --1������ҩ
 union 
 select  2 cfdybz --2ҽ���Ҹ�
 union 
 select  3 cfdybz --3�Ҵ�����
) t1

select xh,jssjh,cfxh,patid,yfdm,sfrq,sfczry,pyrq,pyczry,fyrq,fyczyh,cfts,tfbz,tfqrbz,jzbz,
jlzt,tfxh,memo,ejygbz,tfys,zrys,yfyjs,fybz,jjje,jqpjjj_je,yszbz,cfdybz
into #tmp_mzfyzd_data from YF_NMZFYZD where 1=2

select xh,fyxh,czdm,cfxh,mxxh,cd_idm,gg_idm,ypmc,ypdm,ypgg,ykxs,ypdw,dwxs,ylsj,ypfj,jxce,
cfts,ypsl,memo,jjje,mztybz,tfymxxh,lsje,jqpjjj_je,cfdybz,wsbz,CONVERT(numeric(12,0),0) as fymxxh0 --�״η�ҩ��ϸ��� 
into #tmp_mzfymx_data from YF_NMZFYMX where 1=2

select xh,jssjh,cfxh,patid,yfdm,sfrq,sfczry,pyrq,pyczry,fyrq,fyczyh,cfts,tfbz,tfqrbz,jzbz,
jlzt,tfxh,memo,ejygbz,tfys,zrys,yfyjs,fybz,jjje,jqpjjj_je,yszbz,cfdybz 
into #tmp_mzfyzd_data_valid from YF_NMZFYZD where 1=2

select xh,fyxh,czdm,cfxh,mxxh,cd_idm,gg_idm,ypmc,ypdm,ypgg,ykxs,ypdw,dwxs,ylsj,ypfj,jxce,
cfts,ypsl,memo,jjje,mztybz,tfymxxh,lsje,jqpjjj_je,cfdybz,wsbz,CONVERT(numeric(12,0),0) as fymxxh0 --�״η�ҩ��ϸ��� 
into #tmp_mzfymx_data_valid from YF_NMZFYMX where 1=2

insert into #tmp_mzfyzd_data(xh,jssjh,cfxh,patid,yfdm,sfrq,sfczry,pyrq,pyczry,fyrq,fyczyh,cfts,tfbz,tfqrbz,jzbz,
jlzt,tfxh,memo,ejygbz,tfys,zrys,yfyjs,fybz,jjje,jqpjjj_je,yszbz,cfdybz)
select b.xh,b.jssjh,b.cfxh,b.patid,b.yfdm,b.sfrq,b.sfczry,b.pyrq,b.pyczry,b.fyrq,b.fyczyh,b.cfts,b.tfbz,b.tfqrbz,b.jzbz,
b.jlzt,b.tfxh,b.memo,b.ejygbz,b.tfys,b.zrys,b.yfyjs,b.fybz,b.jjje,b.jqpjjj_je,b.yszbz,b.cfdybz
from #tmp_fydlianb a,YF_MZFYZD b(nolock)
where a.lbfyzdxh=b.xh and b.tfbz in(0,1) and b.jlzt=0 and b.patid=@patid --1207 guo

insert into #tmp_mzfymx_data(xh,fyxh,czdm,cfxh,mxxh,cd_idm,gg_idm,ypmc,ypdm,ypgg,ykxs,ypdw,dwxs,ylsj,ypfj,jxce,
cfts,ypsl,memo,jjje,mztybz,tfymxxh,lsje,jqpjjj_je,cfdybz,wsbz )
select c.xh,c.fyxh,c.czdm,c.cfxh,c.mxxh,c.cd_idm,c.gg_idm,c.ypmc,c.ypdm,c.ypgg,c.ykxs,c.ypdw,c.dwxs,
c.ylsj,c.ypfj,c.jxce,c.cfts,c.ypsl,c.memo,c.jjje,c.mztybz,c.tfymxxh,c.lsje,c.jqpjjj_je,c.cfdybz,
isnull(c.wsbz,0) as wsbz
from #tmp_fydlianb a,YF_MZFYZD b(nolock),YF_MZFYMX c(nolock)
where a.lbfyzdxh=b.xh and b.xh=c.fyxh and b.tfbz in(0,1)and b.jlzt=0 and b.patid=@patid --1207 guo

if exists(select 1 from #tmp_fydlianb a
where not exists(select 1 from  #tmp_mzfyzd_data b where a.lbfyzdxh=b.xh))
begin
  insert into #tmp_mzfyzd_data(xh,jssjh,cfxh,patid,yfdm,sfrq,sfczry,pyrq,pyczry,fyrq,fyczyh,cfts,tfbz,tfqrbz,jzbz,
jlzt,tfxh,memo,ejygbz,tfys,zrys,yfyjs,fybz,jjje,jqpjjj_je,yszbz,cfdybz)
  select b.xh,b.jssjh,b.cfxh,b.patid,b.yfdm,b.sfrq,b.sfczry,b.pyrq,b.pyczry,b.fyrq,b.fyczyh,b.cfts,b.tfbz,b.tfqrbz,b.jzbz,
  b.jlzt,b.tfxh,b.memo,b.ejygbz,b.tfys,b.zrys,b.yfyjs,b.fybz,b.jjje,b.jqpjjj_je,b.yszbz,b.cfdybz
  from #tmp_fydlianb a,VW_MZFYZD b(nolock)
  where a.lbfyzdxh=b.xh and not exists(select 1 from  #tmp_mzfyzd_data c where a.lbfyzdxh=c.xh)
  and b.tfbz in(0,1)and b.jlzt=0 and b.patid=@patid

  insert into #tmp_mzfymx_data(xh,fyxh,czdm,cfxh,mxxh,cd_idm,gg_idm,ypmc,ypdm,ypgg,ykxs,ypdw,dwxs,ylsj,ypfj,jxce,
  cfts,ypsl,memo,jjje,mztybz,tfymxxh,lsje,jqpjjj_je,cfdybz,wsbz )
  select c.xh,c.fyxh,c.czdm,c.cfxh,c.mxxh,c.cd_idm,c.gg_idm,c.ypmc,c.ypdm,c.ypgg,c.ykxs,c.ypdw,c.dwxs,
  c.ylsj,c.ypfj,c.jxce,c.cfts,c.ypsl,c.memo,c.jjje,c.mztybz,c.tfymxxh,c.lsje,c.jqpjjj_je,c.cfdybz,
  isnull(c.wsbz,0) as wsbz
  from #tmp_fydlianb a,VW_MZFYZD b(nolock),VW_MZFYMX c(nolock)
  where a.lbfyzdxh=b.xh and b.xh=c.fyxh  and not exists(select 1 from #tmp_mzfymx_data x1 where x1.xh=c.xh )
  and b.tfbz in(0,1)and b.jlzt=0  and b.patid=@patid   
end

-- #tmp_mzfymx_data �״η�ҩ��ϸ��� ���� start
select @maxloop=COUNT(1) from #tmp_mzfymx_data
select @maxloop=ISNULL(@maxloop,0)

declare cs_fymxxh0 cursor 
for select xh from #tmp_mzfymx_data(nolock)
for read only

open cs_fymxxh0
fetch cs_fymxxh0 into @yb_fymxxh
while @@fetch_status=0
begin  --�α꿪ʼ
  select @tmp_fymxxh=0,@tmp_tfymxxh=0
  select @tmp_fymxxh=xh,@tmp_tfymxxh=tfymxxh from #tmp_mzfymx_data where xh=@yb_fymxxh
  select @tmp_tfymxxh=isnull(@tmp_tfymxxh,0)
  while(@tmp_tfymxxh>0 and @maxloop>0)
  begin
     select @tmp_fymxxh=xh,@tmp_tfymxxh=tfymxxh from #tmp_mzfymx_data where xh=@tmp_tfymxxh
     select @tmp_tfymxxh=isnull(@tmp_tfymxxh,0)
     select @maxloop=@maxloop-1
  end
  update #tmp_mzfymx_data set fymxxh0=isnull(@tmp_fymxxh,0) where xh=@yb_fymxxh 
 fetch cs_fymxxh0 into @yb_fymxxh 
end   --�α����
close cs_fymxxh0
deallocate cs_fymxxh0
-- #tmp_mzfymx_data �״η�ҩ��ϸ��� ���� end

select  recno,cfxh0,curr_sychxh,lbcfxh,lbfyzdxh,lbfyzdxh_jzbz,lbfyzdxh_isnb,lbfyzdxh_czdm,
lbfyzdxh_memo,lbfyzdxh_cfdybz into #tmp_fydlianb_valid 
from #tmp_fydlianb a
where not exists(select 1 from #tmp_memo w1 where w1.memo=a.lbfyzdxh_memo)
and not exists(select 1 from #tmp_cfdybz w2 where w2.cfdybz=a.lbfyzdxh_cfdybz)


insert into #tmp_mzfyzd_data_valid(xh,jssjh,cfxh,patid,yfdm,sfrq,sfczry,pyrq,pyczry,fyrq,fyczyh,cfts,tfbz,tfqrbz,jzbz,
jlzt,tfxh,memo,ejygbz,tfys,zrys,yfyjs,fybz,jjje,jqpjjj_je,yszbz,cfdybz )
select a.xh,a.jssjh,a.cfxh,a.patid,a.yfdm,a.sfrq,a.sfczry,a.pyrq,a.pyczry,a.fyrq,a.fyczyh,a.cfts,a.tfbz,a.tfqrbz,a.jzbz,
a.jlzt,a.tfxh,a.memo,a.ejygbz,a.tfys,a.zrys,a.yfyjs,a.fybz,a.jjje,a.jqpjjj_je,a.yszbz,a.cfdybz
from #tmp_mzfyzd_data a(nolock)
where exists(select 1 from #tmp_fydlianb_valid b(nolock) where b.lbfyzdxh=a.xh)

insert into #tmp_mzfymx_data_valid
(xh,fyxh,czdm,cfxh,mxxh,cd_idm,gg_idm,ypmc,ypdm,ypgg,ykxs,ypdw,dwxs,ylsj,ypfj,jxce,
cfts,ypsl,memo,jjje,mztybz,tfymxxh,lsje,jqpjjj_je,cfdybz )
select xh,fyxh,czdm,cfxh,mxxh,cd_idm,gg_idm,ypmc,ypdm,ypgg,ykxs,ypdw,dwxs,ylsj,ypfj,jxce,
cfts,ypsl,memo,jjje,mztybz,tfymxxh,lsje,jqpjjj_je,cfdybz 
from #tmp_mzfymx_data a(nolock)
where exists(select 1 from #tmp_fydlianb_valid b(nolock) where b.lbfyzdxh=a.fyxh)
----��ҩ���������������ݣ���ҩ�˵�����ϸ���������Ƿ��Ӱ���棩end


--��ǰҪ�˵Ĵ������� start
-- currtycfts  currtysl��ǰ̨¼�������(��������)����typsl����С��λ���������������� 
select xh,jssjh,hjxh,cfxh,czyh,lrrq,patid,hzxm,ybdm,py,wb,ysdm,
ksdm,yfdm,qrczyh,qrrq,qrksdm,pyczyh,pyrq,cfts,txh,sfckdm,pyckdm,
fyckdm,jsbz,jlzt,fybz,cflx,sycfbz,tscfbz,pybz,jcxh,memo,zje,zfyje,
yhje,zfje,srje,fph,fpjxh,tfbz,tfje,fyckxh,sqdxh,yflsh,ejygksdm,
ejygbz,ksfyzd_xh,dpxsbz,pyqr,zpwzbh,zpbh,fptfbz,fptfje,xzks_id,
ylxzbh,ydybz,tmqrbz_yf,tmhdbz,ghxh,gxrq,wsbz
into #tmp_currty_mzcfk_data 
from SF_NMZCFK(nolock) where 1=2

select @cfts currtycfts,@tysl currtysl,@tysl typsl,
xh,cfxh,cd_idm,gg_idm,dxmdm,ypmc,ypdm,ypgg,ypdw,dwxs,ykxs,ypfj,ylsj,ypsl,ts,cfts,zfdj,yhdj,
memo,shbz,flzfdj,txbl,lcxmdm,lcxmmc,zbz,yjqrbz,qrczyh,qrrq,yylsj,qrksdm,clbz,hjmxxh,hy_idm,
hy_pdxh,gbfwje,gbfwwje,gbtsbz,gbtsbl,fpzh,bgdh,bgzt,txzt,hzlybz,bglx,lcxmsl,dydm,yyrq,yydd,
zysx,lcjsdj,yjspbz,sbid,sbclbz,ktsl,tjbz,sqdgroupno,ssbfybz,zje,tmxxh,wsbz,cfts as wsts
into #tmp_currty_cfmx_data 
from SF_NCFMXK(nolock) where 1=2

if exists(select 1 from #tmp_cflianb a(nolock),#cfmx_tf b(nolock)
where a.lbcfxh=b.cfxh and a.lbcfxh_isnb=0)
begin
	insert into #tmp_currty_mzcfk_data(xh,jssjh,hjxh,cfxh,czyh,lrrq,patid,hzxm,ybdm,py,wb,ysdm,
	ksdm,yfdm,qrczyh,qrrq,qrksdm,pyczyh,pyrq,cfts,txh,sfckdm,pyckdm,
	fyckdm,jsbz,jlzt,fybz,cflx,sycfbz,tscfbz,pybz,jcxh,memo,zje,zfyje,
	yhje,zfje,srje,fph,fpjxh,tfbz,tfje,fyckxh,sqdxh,yflsh,ejygksdm,
	ejygbz,ksfyzd_xh,dpxsbz,pyqr,zpwzbh,zpbh,fptfbz,fptfje,xzks_id,
	ylxzbh,ydybz,tmqrbz_yf,tmhdbz,ghxh,gxrq,wsbz)
	select b.xh,b.jssjh,b.hjxh,b.cfxh,b.czyh,b.lrrq,b.patid,b.hzxm,b.ybdm,b.py,b.wb,b.ysdm,
	b.ksdm,b.yfdm,b.qrczyh,b.qrrq,b.qrksdm,b.pyczyh,b.pyrq,b.cfts,b.txh,b.sfckdm,b.pyckdm,
	b.fyckdm,b.jsbz,b.jlzt,b.fybz,b.cflx,b.sycfbz,b.tscfbz,b.pybz,b.jcxh,b.memo,b.zje,b.zfyje,
	b.yhje,b.zfje,b.srje,b.fph,b.fpjxh,b.tfbz,b.tfje,b.fyckxh,b.sqdxh,b.yflsh,b.ejygksdm,
	b.ejygbz,b.ksfyzd_xh,b.dpxsbz,b.pyqr,b.zpwzbh,b.zpbh,b.fptfbz,b.fptfje,b.xzks_id,
	b.ylxzbh,b.ydybz,b.tmqrbz_yf,b.tmhdbz,b.ghxh,b.gxrq,isnull(b.wsbz,0) as wsbz
	from #cfmx_tf a(nolock),SF_MZCFK b(nolock) 
	where a.cfxh=b.xh and b.patid=@patid
  
	insert into #tmp_currty_cfmx_data(currtycfts,currtysl,typsl,
	xh,cfxh,cd_idm,gg_idm,dxmdm,ypmc,ypdm,ypgg,ypdw,dwxs,ykxs,ypfj,ylsj,ypsl,ts,cfts,zfdj,yhdj,
	memo,shbz,flzfdj,txbl,lcxmdm,lcxmmc,zbz,yjqrbz,qrczyh,qrrq,yylsj,qrksdm,clbz,hjmxxh,hy_idm,
	hy_pdxh,gbfwje,gbfwwje,gbtsbz,gbtsbl,fpzh,bgdh,bgzt,txzt,hzlybz,bglx,lcxmsl,dydm,yyrq,yydd,
	zysx,lcjsdj,yjspbz,sbid,sbclbz,ktsl,tjbz,sqdgroupno,ssbfybz,zje,tmxxh,wsbz,wsts)
	select a.cfts,a.tysl,a.tysl*b.dwxs,
	b.xh,b.cfxh,b.cd_idm,b.gg_idm,b.dxmdm,b.ypmc,b.ypdm,b.ypgg,b.ypdw,b.dwxs,b.ykxs,b.ypfj,b.ylsj,b.ypsl,b.ts,b.cfts,b.zfdj,b.yhdj,
	b.memo,b.shbz,b.flzfdj,b.txbl,b.lcxmdm,b.lcxmmc,b.zbz,b.yjqrbz,b.qrczyh,b.qrrq,b.yylsj,b.qrksdm,b.clbz,b.hjmxxh,b.hy_idm
	,b.hy_pdxh,b.gbfwje,b.gbfwwje,b.gbtsbz,b.gbtsbl,b.fpzh,b.bgdh,b.bgzt,b.txzt,b.hzlybz,b.bglx,b.lcxmsl,b.dydm,b.yyrq,b.yydd,
	b.zysx,b.lcjsdj,b.yjspbz,b.sbid,b.sbclbz,b.ktsl,b.tjbz,b.sqdgroupno,b.ssbfybz,b.zje,b.tmxxh,
	isnull(b.wsbz,0),isnull(c.wsts,0)
	from #cfmx_tf a(nolock),SF_CFMXK b(nolock),SF_MZCFK c(nolock) 
	where a.mxxh=b.xh and b.cfxh=c.xh and c.patid=@patid
end

if exists(select 1 from #cfmx_tf a
where not exists(select 1 from #tmp_currty_cfmx_data b where a.mxxh=b.xh))
begin
	insert into #tmp_currty_mzcfk_data(xh,jssjh,hjxh,cfxh,czyh,lrrq,patid,hzxm,ybdm,py,wb,ysdm,
	ksdm,yfdm,qrczyh,qrrq,qrksdm,pyczyh,pyrq,cfts,txh,sfckdm,pyckdm,
	fyckdm,jsbz,jlzt,fybz,cflx,sycfbz,tscfbz,pybz,jcxh,memo,zje,zfyje,
	yhje,zfje,srje,fph,fpjxh,tfbz,tfje,fyckxh,sqdxh,yflsh,ejygksdm,
	ejygbz,ksfyzd_xh,dpxsbz,pyqr,zpwzbh,zpbh,fptfbz,fptfje,xzks_id,
	ylxzbh,ydybz,tmqrbz_yf,tmhdbz,ghxh,gxrq,wsbz)
	select b.xh,b.jssjh,b.hjxh,b.cfxh,b.czyh,b.lrrq,b.patid,b.hzxm,b.ybdm,b.py,b.wb,b.ysdm,
	b.ksdm,b.yfdm,b.qrczyh,b.qrrq,b.qrksdm,b.pyczyh,b.pyrq,b.cfts,b.txh,b.sfckdm,b.pyckdm,
	b.fyckdm,b.jsbz,b.jlzt,b.fybz,b.cflx,b.sycfbz,b.tscfbz,b.pybz,b.jcxh,b.memo,b.zje,b.zfyje,
	b.yhje,b.zfje,b.srje,b.fph,b.fpjxh,b.tfbz,b.tfje,b.fyckxh,b.sqdxh,b.yflsh,b.ejygksdm,
	b.ejygbz,b.ksfyzd_xh,b.dpxsbz,b.pyqr,b.zpwzbh,b.zpbh,b.fptfbz,b.fptfje,b.xzks_id,
	b.ylxzbh,b.ydybz,b.tmqrbz_yf,b.tmhdbz,b.ghxh,b.gxrq,isnull(b.wsbz,0) as wsbz
	from #cfmx_tf a(nolock),VW_MZCFK b(nolock) 
    where a.cfxh=b.xh and b.patid=@patid
	and not exists(select 1 from #tmp_currty_mzcfk_data x(nolock) where x.xh=b.xh)
 
	insert into #tmp_currty_cfmx_data(currtycfts,currtysl,typsl,
	xh,cfxh,cd_idm,gg_idm,dxmdm,ypmc,ypdm,ypgg,ypdw,dwxs,ykxs,ypfj,ylsj,ypsl,ts,cfts,zfdj,yhdj,
	memo,shbz,flzfdj,txbl,lcxmdm,lcxmmc,zbz,yjqrbz,qrczyh,qrrq,yylsj,qrksdm,clbz,hjmxxh,hy_idm,
	hy_pdxh,gbfwje,gbfwwje,gbtsbz,gbtsbl,fpzh,bgdh,bgzt,txzt,hzlybz,bglx,lcxmsl,dydm,yyrq,yydd,
	zysx,lcjsdj,yjspbz,sbid,sbclbz,ktsl,tjbz,sqdgroupno,ssbfybz,zje,tmxxh,wsbz,wsts)
	select a.cfts,a.tysl,a.tysl*b.dwxs,
	b.xh,b.cfxh,b.cd_idm,b.gg_idm,b.dxmdm,b.ypmc,b.ypdm,b.ypgg,b.ypdw,b.dwxs,b.ykxs,b.ypfj,b.ylsj,b.ypsl,b.ts,b.cfts,b.zfdj,b.yhdj,
	b.memo,b.shbz,b.flzfdj,b.txbl,b.lcxmdm,b.lcxmmc,b.zbz,b.yjqrbz,b.qrczyh,b.qrrq,b.yylsj,b.qrksdm,b.clbz,b.hjmxxh,b.hy_idm
	,b.hy_pdxh,b.gbfwje,b.gbfwwje,b.gbtsbz,b.gbtsbl,b.fpzh,b.bgdh,b.bgzt,b.txzt,b.hzlybz,b.bglx,b.lcxmsl,b.dydm,b.yyrq,b.yydd,
	b.zysx,b.lcjsdj,b.yjspbz,b.sbid,b.sbclbz,b.ktsl,b.tjbz,b.sqdgroupno,b.ssbfybz,b.zje,b.tmxxh,isnull(b.wsbz,0) as wsbz,
	isnull(c.wsts,0) as wsts
	from #cfmx_tf a(nolock),VW_MZCFMXK b(nolock),VW_MZCFK c(nolock) 
	where a.mxxh=b.xh and b.cfxh=c.xh and c.patid=@patid
	and not exists(select 1 from #tmp_currty_cfmx_data x(nolock) where x.xh=b.xh)
end

if exists(select 1 from #cfmx_tf a(nolock)
where not exists(select 1 from #tmp_currty_cfmx_data b(nolock) 
where a.mxxh=b.xh and a.cfts=b.currtycfts and a.tysl=b.currtysl))
begin
   select @errmsg='F������ǰҪ�˵Ĵ������ݳ���'
   goto err 
end

--��ǰҪ�˵Ĵ������� end

--�жϵ�ǰҪ�˴�����ϸ�Ƿ��Ѿ��Ѿ����� ��ҩ��ϸ�������ɵģ������ٴ����� start
if exists(select 1 from(
select a.mxxh,count(1) jls
 from #tmp_mzfymx_data_valid a(nolock)
where  exists(select 1 from #tmp_currty_cfmx_data b(nolock) where a.mxxh=b.xh )
group by a.mxxh having count(1)>1) t1)
begin
	select @errmsg='F��ǰ�����ѽ�����ҩȷ�ϣ������ظ�ȷ�ϣ�'
    goto err 
end
--�жϵ�ǰҪ�˴�����ϸ�Ƿ��Ѿ��Ѿ����� ��ҩ��ϸ�������ɵģ������ٴ����� end

select cd_idm,@tysl ytsl,@tysl ktsl into #tmp_pdktsl_ff1 
from #tmp_currty_cfmx_data 
where 1=2

insert into #tmp_pdktsl_ff1
select cd_idm,sum(currtycfts*typsl) ytsl,0 ktsl
from #tmp_currty_cfmx_data
group by cd_idm

update #tmp_pdktsl_ff1 set ktsl=t2.ktsl
from #tmp_pdktsl_ff1 t1,(select cd_idm,sum(cfts*ypsl) ktsl 
from #tmp_mzfymx_data_valid 
group by cd_idm) t2
where t1.cd_idm=t2.cd_idm


if exists(select 1 from #tmp_pdktsl_ff1(nolock) where ytsl>ktsl)
begin
   select top 1 @ypmc=b.ypmc from #tmp_pdktsl_ff1 a(nolock),YK_YPCDMLK b(nolock) 
   where a.cd_idm=b.idm and a.ytsl>a.ktsl 

   select @errmsg='F'+isnull(@ypmc,'')+',��������������'
   goto err
end

--�жϷ���2 mxxh (��Ҫ�����ڣ�һ�������У�����ͬһ��ҩƷ)
select convert(numeric(12,0),xh) as mxxh,cd_idm,@tysl ytsl,@tysl ktsl into #tmp_pdktsl_ff2 from #tmp_currty_cfmx_data where 1=2

insert into #tmp_pdktsl_ff2
select xh,cd_idm,sum(currtycfts*typsl) ytsl,0 ktsl
from #tmp_currty_cfmx_data (nolock)
group by xh,cd_idm

--��ȡ��ǰҪ�˵Ĵ�����ϸ��Ӧ�ķ�ҩ����ϸ���� start
select @mxxh currty_mxxh,xh,fyxh,czdm,cfxh,mxxh,cd_idm,gg_idm,ypmc,
        ypdm,ypgg,ykxs,ypdw,dwxs,ylsj,ypfj,jxce,
        cfts,ypsl,memo,jjje,mztybz,tfymxxh,lsje,jqpjjj_je,cfdybz 
into #tmp_currty_fycfmx_lianb 
from #tmp_mzfymx_data where 1=2 

delete from #tmp_pdktsl_ff2_order
INSERT into #tmp_pdktsl_ff2_order(cfxh,mxxh,lbcfxh_isnb)
select b.cfxh,a.mxxh,c.lbcfxh_isnb
from #tmp_pdktsl_ff2 a(nolock),#tmp_currty_cfmx_data b(nolock),#tmp_cflianb c(nolock)
where a.mxxh=b.xh and b.cfxh=c.lbcfxh
order by b.cfxh,a.mxxh

 declare cs_crtycfmxlb cursor 
 for select a.cfxh,a.mxxh,a.lbcfxh_isnb
     from #tmp_pdktsl_ff2_order a(nolock)

 for read only
   
 open cs_crtycfmxlb
 fetch cs_crtycfmxlb into @cfxh,@mxxh,@isnb
 while @@fetch_status=0
 begin  --�α꿪ʼ    
    insert into #tmp_currty_fycfmx_lianb (currty_mxxh,xh,fyxh,czdm,cfxh,mxxh,cd_idm,gg_idm,ypmc,ypdm,ypgg,ykxs,ypdw,dwxs,ylsj,ypfj,jxce,
	cfts,ypsl,memo,jjje,mztybz,tfymxxh,lsje,jqpjjj_je,cfdybz)
    select @mxxh,a.xh,a.fyxh,a.czdm,a.cfxh,a.mxxh,a.cd_idm,a.gg_idm,a.ypmc,a.ypdm,a.ypgg,a.ykxs,a.ypdw,a.dwxs,a.ylsj,a.ypfj,a.jxce,
	a.cfts,a.ypsl,a.memo,a.jjje,a.mztybz,a.tfymxxh,a.lsje,a.jqpjjj_je,a.cfdybz
	from #tmp_mzfymx_data_valid a (nolock)
    where mxxh=@mxxh and not exists (select 1 from #tmp_currty_fycfmx_lianb b (nolock) where b.xh=a.xh)

    select @tmpxh=0
    if @isnb=0
      select @tmpxh=isnull(tmxxh,0) from SF_CFMXK(nolock) where xh=@mxxh 
    else
      select @tmpxh=isnull(tmxxh,0) from VW_MZCFMXK(nolock) where xh=@mxxh   
    select @cfmx_tmxxh=isnull(@tmpxh,0)
    if (isnull(@cfmx_tmxxh,0)>0)
    begin
       insert into #tmp_currty_fycfmx_lianb (currty_mxxh,xh,fyxh,czdm,cfxh,mxxh,cd_idm,gg_idm,ypmc,ypdm,ypgg,ykxs,ypdw,dwxs,ylsj,ypfj,jxce,
		cfts,ypsl,memo,jjje,mztybz,tfymxxh,lsje,jqpjjj_je,cfdybz)
       select @mxxh,a.xh,a.fyxh,a.czdm,a.cfxh,a.mxxh,a.cd_idm,a.gg_idm,a.ypmc,a.ypdm,a.ypgg,a.ykxs,a.ypdw,a.dwxs,a.ylsj,a.ypfj,a.jxce,
		a.cfts,a.ypsl,a.memo,a.jjje,a.mztybz,a.tfymxxh,a.lsje,a.jqpjjj_je,a.cfdybz 
	   from #tmp_mzfymx_data_valid a
       where mxxh=@cfmx_tmxxh and not exists (select 1 from #tmp_currty_fycfmx_lianb b where b.xh=a.xh) 
    end
    while(isnull(@cfmx_tmxxh,0)>0)--while start
    begin 
       select @cfmx_tmxxh_dycfxh=0
       select top 1 @cfmx_tmxxh_dycfxh=cfxh from #tmp_mzfymx_data where mxxh=@cfmx_tmxxh
       if isnull(@cfmx_tmxxh_dycfxh,0)=0
       begin
         select @cfmx_tmxxh_dycfxh=cfxh from VW_MZCFMXK where xh=@cfmx_tmxxh
       end
       select @isnb=-1
       select top 1 @isnb=lbcfxh_isnb from #tmp_cflianb where lbcfxh=@cfmx_tmxxh_dycfxh
       select @tmpxh=0
       if @isnb=0
         select @tmpxh=isnull(tmxxh,0),@cfmx_tmxxh_dycfxh=cfxh from SF_CFMXK(nolock) where xh=@cfmx_tmxxh
       else
         select @tmpxh=isnull(tmxxh,0),@cfmx_tmxxh_dycfxh=cfxh from VW_MZCFMXK(nolock) where xh=@cfmx_tmxxh
       select @cfmx_tmxxh=isnull(@tmpxh,0)
       if (isnull(@cfmx_tmxxh,0)>0)
       begin
         insert into #tmp_currty_fycfmx_lianb (currty_mxxh,xh,fyxh,czdm,cfxh,mxxh,cd_idm,gg_idm,ypmc,ypdm,ypgg,ykxs,ypdw,dwxs,ylsj,ypfj,jxce,
		 cfts,ypsl,memo,jjje,mztybz,tfymxxh,lsje,jqpjjj_je,cfdybz)
         select @mxxh,a.xh,a.fyxh,a.czdm,a.cfxh,a.mxxh,a.cd_idm,a.gg_idm,a.ypmc,a.ypdm,a.ypgg,a.ykxs,a.ypdw,a.dwxs,a.ylsj,a.ypfj,a.jxce,
		 a.cfts,a.ypsl,a.memo,a.jjje,a.mztybz,a.tfymxxh,a.lsje,a.jqpjjj_je,a.cfdybz 
		 from #tmp_mzfymx_data_valid a(nolock)
         where a.mxxh=@cfmx_tmxxh and not exists (select 1 from #tmp_currty_fycfmx_lianb b where b.xh=a.xh) 
       end
    end  --while end
    fetch cs_crtycfmxlb into @cfxh,@mxxh,@isnb 
 end   --�α����
 close cs_crtycfmxlb
 deallocate cs_crtycfmxlb
 --��ȡ��ǰҪ�˵Ĵ�����ϸ��Ӧ�ķ�ҩ����ϸ���� end

update #tmp_pdktsl_ff2 set ktsl=t2.ktsl
from #tmp_pdktsl_ff2 t1,(select currty_mxxh,cd_idm,sum(cfts*ypsl) ktsl 
from #tmp_currty_fycfmx_lianb
group by currty_mxxh,cd_idm) t2
where t1.mxxh=t2.currty_mxxh and t1.cd_idm=t2.cd_idm


if exists(select 1 from #tmp_pdktsl_ff1(nolock) where ytsl>ktsl)
begin
   select top 1 @ypmc=b.ypmc from #tmp_pdktsl_ff1 a,YK_YPCDMLK b(nolock) 
   where a.cd_idm=b.idm and a.ytsl>a.ktsl 
   select @errmsg='F'+isnull(@ypmc,'')+',������������.��'
   goto err
end

--�жϿ�������end

select xh,jssjh,hjxh,cfxh,czyh,lrrq,patid,hzxm,ybdm,py,wb,ysdm,ksdm,yfdm,qrczyh,qrrq,qrksdm,pyczyh,pyrq,
	cfts,txh,sfckdm,pyckdm,fyckdm,jsbz,jlzt,fybz,cflx,sycfbz,tscfbz,pybz,jcxh,memo,zje,zfyje,yhje,zfje,srje,
	fph,fpjxh,tfbz,tfje,fyckxh,sqdxh,yflsh,ejygksdm,ejygbz,ksfyzd_xh,dpxsbz,pyqr,zpwzbh,zpbh,fptfbz,fptfje,
	xzks_id,ylxzbh,ydybz,tmqrbz_yf,tmhdbz,ghxh,gxrq,wsbz,tcfts,0 gfbz 
into #mzcfk 
from
	(select distinct a.xh,a.jssjh,a.hjxh,a.cfxh,a.czyh,a.lrrq,a.patid,a.hzxm,a.ybdm,a.py,a.wb,a.ysdm,a.ksdm,a.yfdm,a.qrczyh,a.qrrq,a.qrksdm,a.pyczyh,a.pyrq,
	a.cfts,a.txh,a.sfckdm,a.pyckdm,a.fyckdm,a.jsbz,a.jlzt,a.fybz,a.cflx,a.sycfbz,a.tscfbz,a.pybz,a.jcxh,a.memo,a.zje,a.zfyje,a.yhje,a.zfje,a.srje,
	a.fph,a.fpjxh,a.tfbz,a.tfje,a.fyckxh,a.sqdxh,a.yflsh,a.ejygksdm,a.ejygbz,a.ksfyzd_xh,a.dpxsbz,a.pyqr,a.zpwzbh,a.zpbh,a.fptfbz,a.fptfje,
	a.xzks_id,a.ylxzbh,a.ydybz,a.tmqrbz_yf,a.tmhdbz,a.ghxh,a.gxrq,isnull(a.wsbz,0) as wsbz,b.currtycfts as tcfts 
	from #tmp_currty_mzcfk_data a(nolock),#tmp_currty_cfmx_data b(nolock)
	where a.xh=b.cfxh ) tbl
select @error=@@error,@rowcount=@@rowcount  
if @error<>0  
begin  
	select @errmsg='F��ȡ��ҩ����ʱ����'
    goto err    
end 
if @rowcount = 0 
begin  
	select @errmsg='Fδ�ҵ���ҩ������'
    goto err     
end  
---
 if  @ypxtslt in (0,1) ---����෽��ʶ
begin
   if exists (select 1 from YY_CONFIG where id='3430' and config ='��')
   begin 
    update a set gfbz=1 
    from #mzcfk a inner join SF_MZCFK b(nolock) on a.xh=b.xh
    where (b.xdfxh is not null) and (b.dyxdf_idm is not null) and b.patid=@patid

   end
end
    
    select xh,jssjh,hjxh,cfxh,czyh,lrrq,patid,hzxm,ybdm,py,wb,ysdm,ksdm,yfdm,qrczyh,qrrq,qrksdm,pyczyh,pyrq,
	cfts,txh,sfckdm,pyckdm,fyckdm,jsbz,jlzt,fybz,cflx,sycfbz,tscfbz,pybz,jcxh,memo,zje,zfyje,yhje,zfje,srje,
	fph,fpjxh,tfbz,tfje,fyckxh,sqdxh,yflsh,ejygksdm,ejygbz,ksfyzd_xh,dpxsbz,pyqr,zpwzbh,zpbh,fptfbz,fptfje,
	xzks_id,ylxzbh,ydybz,tmqrbz_yf,tmhdbz,ghxh,gxrq,wsbz,tcfts,1 gfbz,cfxh fyxh 
	into #mzcfk_gf from #mzcfk where gfbz=1
    update #mzcfk_gf set fyxh=0

---

select distinct a.currtycfts,a.currtysl,a.typsl,
  a.xh,a.cfxh,a.cd_idm,a.gg_idm,a.dxmdm,a.ypmc,a.ypdm,a.ypgg,a.ypdw,a.dwxs,a.ykxs,a.ypfj,a.ylsj,a.ypsl,a.ts,a.cfts,a.zfdj,a.yhdj,
  a.memo,a.shbz,a.flzfdj,a.txbl,a.lcxmdm,a.lcxmmc,a.zbz,a.yjqrbz,a.qrczyh,a.qrrq,a.yylsj,a.qrksdm,a.clbz,a.hjmxxh,a.hy_idm,
  a.hy_pdxh,a.gbfwje,a.gbfwwje,a.gbtsbz,a.gbtsbl,a.fpzh,a.bgdh,a.bgzt,a.txzt,a.hzlybz,a.bglx,a.lcxmsl,a.dydm,a.yyrq,a.yydd,
  a.zysx,a.lcjsdj,a.yjspbz,a.sbid,a.sbclbz,a.ktsl,a.tjbz,a.sqdgroupno,a.ssbfybz,a.zje,a.tmxxh, 
  b.cfts as tcfts,c.jjje as jxce,b.mxxh,--�˴���c.jjje as jxce��Ϊ�����ֶ��ã���������¼���
  c.ypsl as fysl,c.jjje,c.xh as fymxxh,c.memo as fymxmemo,a.wsbz,a.wsts
  into #cfmxk   
  from #tmp_currty_cfmx_data a (nolock), #cfmx_tf b,#tmp_mzfymx_data c(nolock),#tmp_mzfyzd_data d(nolock)   
  where b.cfxh=a.cfxh and b.mxxh=a.xh  and a.xh=c.mxxh and c.fyxh=d.xh and d.jlzt=0
select @error=@@error,@rowcount=@@rowcount 
 if @error<>0   
 begin  
	select @errmsg='F��ȡ��ҩ������ϸʱ����'
    goto err    
 end
 if @rowcount = 0  
 begin  
	select @errmsg='Fδ�ҵ���ҩ������ϸ��'
    goto err     
 end
   if  exists(
    select 1 from #cfmxk a inner join #mzcfk_gf b  on a.cfxh =b.xh  
    inner join SF_CFMXK c(nolock) on a.xh=c.xh  where a.currtysl<>c.ypsl or a.currtycfts<>c.cfts)
    begin
	  select @errmsg='F�෽ҩƷ����Ҫȫ�ˣ�'
      goto err    
    end
    if  exists(  
     select 1 from SF_CFMXK a inner join #mzcfk_gf b  on a.cfxh =b.xh   where a.xh not in (select xh from #cfmxk))
     begin
	  select @errmsg='F�෽ҩƷ����Ҫȫ�ˣ�'
      goto err    
     end
if exists(select 1 from 
(select cd_idm,sum(typsl) typsl from #tmp_currty_cfmx_data (nolock) group by cd_idm) t1,
(select cd_idm,sum(typsl) typsl from #cfmxk (nolock) group by cd_idm) t2
where t1.cd_idm=t2.cd_idm and t1.typsl<>t2.typsl)
begin
  select @errmsg='F������ҩ��ϸ�ظ�,��������ҩ��'
  goto err
end

 --yxp add 2006-6-23  ���ӹ��ܣ�ͣ�õ�ҩƷ��������  
 if exists(select 1 from #cfmxk a(nolock), YK_YPCDMLK b(nolock) where a.cd_idm=b.idm and b.tybz=1)  
 begin  
  set rowcount 1  
  select @errmsg='F'+'ҩƷ['+isnull(b.ypmc,'')+']��ͣ�ã���������ҩ������'
  from  #cfmxk a(nolock), YK_YPCDMLK b(nolock) where a.cd_idm=b.idm and b.tybz=1
  select @errmsg='F'+substring(isnull(@errmsg,''),2,499)
  goto err  
 end  

 update #cfmxk 
 set    jxce=b.typsl*a.jxce/a.ypsl,
        jjje=convert(numeric(14,2),b.typsl*a.jjje/a.ypsl)
 from #tmp_mzfymx_data a(nolock),#cfmxk b 
 where a.mxxh=b.mxxh and a.cd_idm=b.cd_idm 
 if @@error<>0  
 begin  
	select @errmsg='F��ȡ��ҩ������ϸ���ʱ����'
    goto err    
 end   
 
begin transaction ---���������ʼ�����  
    --ɾ����ҩ��ϸ
     select b.fyxh,b.xh as fymxxh
     into #fymx_del
     from YF_MZFYZD a(nolock),YF_MZFYMX b(nolock),#cfmxk c
     where a.xh=b.fyxh and b.mxxh=c.xh and a.cfxh=c.cfxh and a.jssjh=@sjh and a.tfbz=1 and a.tfqrbz=0 and a.jlzt=0 and a.yfdm=@yfdm
          and not exists(select 1 from #tmp_memo w1 where w1.memo=a.memo)
          and not exists(select 1 from #tmp_cfdybz w2 where w2.cfdybz=a.cfdybz)
          and a.tfbz in(0,1) and a.jlzt=0--1207 guo 
		  and a.patid=@patid
     if @@error<>0  
	 begin  
		 select @errmsg='F���ձ��г�ʼ����ɾ�����¼����'
		 rollback transaction
         goto err
	 end  
     if @rqbz=1 
     begin
        insert into #fymx_del(fyxh,fymxxh)
           select b.fyxh,b.xh as fymxxh
		   from YF_NMZFYZD a(nolock),YF_NMZFYMX b(nolock),#cfmxk c
		   where a.xh=b.fyxh and b.mxxh=c.xh and a.cfxh=c.cfxh and a.jssjh=@sjh and a.tfbz=1 and a.tfqrbz=0 and a.jlzt=0 and a.yfdm=@yfdm
                       and not exists(select 1 from #tmp_memo w1 where w1.memo=a.memo)
                       and not exists(select 1 from #tmp_cfdybz w2 where w2.cfdybz=a.cfdybz)
					   and a.patid=@patid
       if @@error<>0  
	   begin  
		   select @errmsg='F������г�ʼ����ɾ�����¼����'
		   rollback transaction
           goto err  
	   end  
     end        
     if exists(select 1 from #fymx_del )
     begin
		 delete YF_MZFYMX
			  from YF_MZFYMX a,#fymx_del b 				
			  where a.xh=b.fymxxh
		 if @@error<>0  
		 begin  
			 select @errmsg='Fɾ������ҩ��ϸ����'
		     rollback transaction
             goto err  
		 end  
		 --ɾ��û����ҩ��ϸ����ҩ����
		 delete YF_MZFYZD 
			 where jssjh=@sjh and yfdm=@yfdm and tfbz=1 and tfqrbz=0 and jlzt=0  
				 and xh in (select distinct fyxh from #fymx_del)
				 and not exists(select 1 from YF_MZFYMX c where c.fyxh = YF_MZFYZD.xh)
				 and patid=@patid
		 if @@error<>0  
		 begin  
			select @errmsg='Fɾ������ҩ�ʵ���Ϣ����'
		    rollback transaction
            goto err  
		 end  
     end  
     --����һ����Ʊ�Ű���������������
     declare @tyxh_begin ut_xh12 --��ʼ��ҩ���
     declare @ytycfsl  int  --Ӧ������ҩ������
     declare @stycfsl  int  --ʵ�ʲ�����ҩ������
     select @tyxh_begin= max(xh)+1 from YF_MZFYZD (nolock)
     select @ytycfsl = count(*) from #mzcfk (nolock)
  
	 insert into YF_MZFYZD(jssjh, cfxh, patid, yfdm, sfrq, sfczry, pyrq, pyczry, fyrq, fyczyh,  
	        cfts, tfbz, tfqrbz, jzbz, jlzt, tfxh, memo, zrys,tfys,yfyjs,fybz,wsbz,gfbz,tfyydm)  
	 select jssjh, xh, patid, @yfdm, lrrq, czyh, pyrq, pyczyh,
	        (case isnull(@tyrq,'') when '' then @now else @tyrq end) as fyrq,
			@czyh,tcfts, 1, 0, 0, 0, null, @tyyy,@fzzr,  @tyys, @yjs,1,wsbz,gfbz,@tfyydm
	  from #mzcfk (nolock)      
	 if @@error<>0 or  @@rowcount=0  
	 begin  
	    select @errmsg='F������ҩ�ʵ���Ϣ����'
		rollback transaction
        goto err   
	 end  
    
	 select @xhtemp=SCOPE_IDENTITY()
	 
	  update #mzcfk_gf set fyxh=b.xh  
	  from #mzcfk_gf a inner join YF_MZFYZD b(nolock) on a.xh=b.cfxh  
	  and b.gfbz=1  and b.xh=@xhtemp and b.patid=@patid
	 
     select @stycfsl=count(*) from YF_MZFYZD a where xh>=@tyxh_begin and xh<=@xhtemp and a.patid=@patid
     if @ytycfsl> @stycfsl
     begin
		  select @errmsg='F������ҩ��Ϣ����,���ڲ�����ҩ��ԭ����������ҩ���ɣ�'
		  rollback transaction
          goto err 
     end
     
    if @config3291='��'
	begin			
		insert into YF_MZFYMX(fyxh, czdm, cfxh, mxxh, cd_idm, gg_idm, ypmc, ypdm, ypgg, ykxs,   
							ypdw, dwxs, ylsj,ypfj,jxce, cfts, ypsl,memo,jjje,mztybz,tfymxxh,wsbz,wsts)  
		select c.xh, @czdm, a.cfxh, a.xh, a.cd_idm, a.gg_idm, a.ypmc, a.ypdm, a.ypgg, a.ykxs,  
			a.ypdw, a.dwxs, 
			convert(numeric(12,4),case when txbl > 1 then a.ylsj/a.txbl else a.ylsj end),
			convert(numeric(12,4),case when a.txbl>1 then a.ypfj/a.txbl else a.ypfj end),    
			convert(numeric(14,2),case when d.jxje=0 then  1*a.jxce else (a.typsl*a.tcfts*(d.jxje/case when d.kcsl3=0 then 1 else d.kcsl3 end)) end),
			a.tcfts, -a.typsl,'', 
			convert(numeric(14,2),-a.jjje),1,a.fymxxh,isnull(a.wsbz,0),isnull(a.wsts,0)   
			from #cfmxk a, YF_MZFYZD c,YF_YFZKC d  
			where (c.xh>=@tyxh_begin and c.xh<=@xhtemp) and c.cfxh=a.cfxh 
			and c.tfbz=1 and c.tfqrbz=0 and c.jlzt=0 and d.cd_idm=a.cd_idm and d.ksdm=@yfdm
			and ISNULL(a.wsbz,0)=0	and c.patid=@patid
		union all
		select c.xh, @czdm, a.cfxh, a.xh, a.cd_idm, a.gg_idm, a.ypmc, a.ypdm, a.ypgg, a.ykxs,  
			a.ypdw, a.dwxs, 
			convert(numeric(12,4),case when txbl > 1 then a.ylsj/a.txbl else a.ylsj end),
			convert(numeric(12,4),case when a.txbl>1 then a.ypfj/a.txbl else a.ypfj end),    
			convert(numeric(14,2),case when d.jxje=0 then  1*a.jxce else (a.typsl*(a.tcfts-a.wsts)*(d.jxje/case when d.kcsl3=0 then 1 else d.kcsl3 end)) end),
			a.tcfts, -a.typsl,'', 
			convert(numeric(14,2),-a.jjje),1,a.fymxxh,isnull(a.wsbz,0),isnull(a.wsts,0)   
			from #cfmxk a, YF_MZFYZD c,YF_YFZKC d  
			where (c.xh>=@tyxh_begin and c.xh<=@xhtemp) and c.cfxh=a.cfxh 
			and c.tfbz=1 and c.tfqrbz=0 and c.jlzt=0 and d.cd_idm=a.cd_idm and d.ksdm=@yfdm
			and ISNULL(a.wsbz,0)=1	and c.patid=@patid		 
		if @@error<>0 or  @@rowcount=0  
		begin  
			select @errmsg='F������ҩ��ϸ��Ϣ����'
		    rollback transaction
            goto err    
		end 		
	
	end
	else
	begin
		insert into YF_MZFYMX(fyxh, czdm, cfxh, mxxh, cd_idm, gg_idm, ypmc, ypdm, ypgg, ykxs,   
							ypdw, dwxs, ylsj,ypfj,jxce, cfts, ypsl,memo,jjje,mztybz,tfymxxh,wsbz,wsts)  
		select c.xh, @czdm, a.cfxh, a.xh, a.cd_idm, a.gg_idm, a.ypmc, a.ypdm, a.ypgg, a.ykxs,  
			a.ypdw, a.dwxs, 
			convert(numeric(12,4),case when txbl > 1 then a.ylsj/a.txbl else a.ylsj end),
			convert(numeric(12,4),case when a.txbl>1 then a.ypfj/a.txbl else a.ypfj end),    
			convert(numeric(14,2),case when d.jxje=0 then  1*a.jxce else   (a.typsl*a.tcfts*(d.jxje/case when d.kcsl3=0 then 1 else d.kcsl3 end)) end),
			a.tcfts, -a.typsl,'', 
			convert(numeric(14,2),-a.jjje),1,a.fymxxh,isnull(a.wsbz,0),isnull(a.wsts,0)   
			from #cfmxk a, YF_MZFYZD c,YF_YFZKC d  
			where (c.xh>=@tyxh_begin and c.xh<=@xhtemp) and c.cfxh=a.cfxh 
			and c.tfbz=1 and c.tfqrbz=0 and c.jlzt=0 and d.cd_idm=a.cd_idm and d.ksdm=@yfdm
			and c.patid=@patid	    
		if @@error<>0 or  @@rowcount=0  
		begin  
			select @errmsg='F������ҩ��ϸ��Ϣ����'
		    rollback transaction
            goto err   
		end   
	end
	--����YF_ZYFYMXʱSF_CFMXK.tffs����2550=�� �������Ƿ����
	if @m2550='��'
	begin 
	  update a set a.tffs=abs(b.tcfts) from SF_CFMXK a join #cfmxk b on a.xh=b.xh 
	end
  ------------����SF_CFMXK_FZ--start------------------
  if @config3414='��' 
  begin
	  if @rqbz =0 
	  begin
		 update a set a.memo1=b.memo1,a.memo2=b.memo2
		 from SF_CFMXK_FZ a ,#cfmx_tf b 
		 where a.cfxh=b.cfxh and a.mxxh=b.mxxh
	  end
	  else if @rqbz =1 
	  begin
		 update a set a.memo1=b.memo1,a.memo2=b.memo2
		 from SF_NCFMXK_FZ a ,#cfmx_tf b 
		 where a.cfxh=b.cfxh and a.mxxh=b.mxxh
	  end
  end
  ------------����SF_CFMXK_FZ--end------------------
  
  if  ((@ypxtslt =2) and (@config3117='��')) 
begin
      declare @tmp_cfmxxh9 ut_xh12,  --�˴���Ҫ���������ݱ�֤ �˷ѵ�ʱ����Ի�ȡ��ָ������������
      @tmp_idm9 ut_xh12,
      @tmp_fymxxh9  ut_xh12,
      @tmp_ypsl9 ut_sl10,
      @tmp_cnt int
      
      declare @cur_pcxh9 ut_xh12,
              @cur_pcsl9 ut_sl10,
              @sysl9 ut_sl10  --��ǰ������ţ���ǰ����������ʣ������
       
      create table #yftyzdmx_kcjl
    (
      cd_idm ut_xh9 not null,
      ypsl  ut_sl10 not null,
      yfdm  ut_ksdm not null,
      fymxxh ut_xh12 not null,
      cfmxxh  ut_xh12 null
    ) 
      CREATE TABLE [#tmp_sytk_pc_cfmx_kcjl](
		[yfpcxh] [numeric](12, 0) NULL,
		[cd_idm] [numeric](9, 0)  NULL,
		[ykxs] [numeric](12, 4)  NULL,
		[sykt_ypsl] [numeric](38, 2) NULL,
		[avgylsj] [money] NULL,
		[avgypjj] [money] NULL,
		[ypfj] [money]  NULL,
		[sykt_lsje] [numeric](38, 2) NULL,
		[sykt_jjje] [numeric](38, 2) NULL
	) 
	
	CREATE TABLE [#tmp_sytk_pc_cfmx_kcjl3183](
	    [recno] ut_xh12 identity not null,
		[yfpcxh] [numeric](12, 0) NULL,
		[sykt_ypsl] [numeric](38, 2) NULL,
	) 
	
	 if @config3291='��'
    begin
  		INSERT into #yftyzdmx_kcjl(cd_idm,ypsl,yfdm,fymxxh,cfmxxh)
		select b.cd_idm, case when b.wsbz=1 then (-b.ypsl*(b.cfts-b.wsts)) else (-b.ypsl*b.cfts) end , 
		a.yfdm,b.xh,b.mxxh as mxxh
		from YF_MZFYZD a(nolock),YF_MZFYMX b(nolock),#tmp_mzfymx_data d(nolock)
		where a.xh=b.fyxh  and b.tfymxxh=d.xh and a.tfbz=1 and a.jlzt=0
		and a.xh>=@tyxh_begin and a.xh<=@xhtemp   and a.gfbz<>1 --�෽��ϸ���ۿ��
		and a.patid=@patid
    end
    else
    begin
		INSERT into #yftyzdmx_kcjl(cd_idm,ypsl,yfdm,fymxxh,cfmxxh)
		select b.cd_idm, -b.ypsl*b.cfts,a.yfdm,b.xh,b.mxxh as mxxh
		from YF_MZFYZD a(nolock),YF_MZFYMX b(nolock),#tmp_mzfymx_data d(nolock)
		where a.xh=b.fyxh  and b.tfymxxh=d.xh and a.tfbz=1 and a.jlzt=0
		and a.xh>=@tyxh_begin and a.xh<=@xhtemp
		and (@config3249='��' or (@config3249='��' and a.wsbz=0)) and a.gfbz<>1 --�෽��ϸ���ۿ��
		and a.patid=@patid   
    end
		   
	declare cs_yfty_mzty_tmp cursor for 
		select a.cd_idm,a.ypsl,a.cfmxxh,a.fymxxh 
		from #yftyzdmx_kcjl a(nolock)
		where a.cd_idm<>0 and a.ypsl<>0
		
	for read only
	open cs_yfty_mzty_tmp
	fetch cs_yfty_mzty_tmp  into @tmp_idm9, @tmp_ypsl9,@tmp_cfmxxh9,@tmp_fymxxh9
	while @@fetch_status=0
	begin
	    
	    delete from #tmp_sytk_pc_cfmx_kcjl	 --�����
        insert into #tmp_sytk_pc_cfmx_kcjl exec usp_yf_mzbftf_sycfmxinfo @tmp_cfmxxh9,3 --ȫ����Ϣ
        
        delete from #tmp_sytk_pc_cfmx_kcjl3183 --���
        if @config3183=0
		begin
		   insert into #tmp_sytk_pc_cfmx_kcjl3183(yfpcxh,sykt_ypsl)
		   select  a.yfpcxh,a.sykt_ypsl
		   from #tmp_sytk_pc_cfmx_kcjl a,YF_YFPCK b(nolock) 
		   where a.yfpcxh=b.xh 
		   order by b.sxrq desc
		end
		else
		begin
		  insert into #tmp_sytk_pc_cfmx_kcjl3183(yfpcxh,sykt_ypsl)
		   select a.yfpcxh,a.sykt_ypsl
		   from #tmp_sytk_pc_cfmx_kcjl a,YF_YFPCK b(nolock) 
		   where a.yfpcxh=b.xh 
		   order by b.rkrq desc
		end
				
		select @cnt=count(1) from #tmp_sytk_pc_cfmx_kcjl3183
		if isnull(@cnt,0)=0
		begin
			select @errmsg='Fȡʣ����˵ļ�¼ʧ��2��'
			rollback transaction
			close cs_yfty_mzty_tmp
            deallocate cs_yfty_mzty_tmp
			goto err
		end
		
		select @sysl9 =@tmp_ypsl9

		declare cs_yfty_mzty_pc_tmp cursor for  
			 select yfpcxh,sykt_ypsl as czsl 
			 from #tmp_sytk_pc_cfmx_kcjl3183
			 order by recno  --ע������czslǰ���üӸ���
		for read only
		
		--Ӧ��ȡʣ����˵ļ�¼ end
		open cs_yfty_mzty_pc_tmp
		fetch cs_yfty_mzty_pc_tmp into @cur_pcxh9,@cur_pcsl9
		while @@fetch_status=0 and @sysl9>0
		begin
			if @sysl9 - isnull(@cur_pcsl9,0)<=0  --��ǰ�����ܷ���
				select @cur_pcsl9=@sysl9	
   
			insert into YF_BRTYPCXX (fymxxh,cfmxxh,yfpcxh ,tysl )
            select @tmp_fymxxh9,@tmp_cfmxxh9,@cur_pcxh9,@cur_pcsl9 
            		        
			select @sysl9=@sysl9-@cur_pcsl9
			
			fetch cs_yfty_mzty_pc_tmp into @cur_pcxh9,@cur_pcsl9
		end
		close cs_yfty_mzty_pc_tmp
		deallocate cs_yfty_mzty_pc_tmp	
     	
     	fetch cs_yfty_mzty_tmp into @tmp_idm9, @tmp_ypsl9,@tmp_cfmxxh9,@tmp_fymxxh9
	end
	close cs_yfty_mzty_tmp
	deallocate cs_yfty_mzty_tmp

end 
  
  
/*---===========================xwm 2011-12-08  ҩ�����ν��۴��� begin ===============================================---*/
------���ӿ�ʼ
    --xwm 2011-12-06 3117����������ֻ������ҩʱ�����棨�˷Ѵ��������棩
	--if exists(select 1 from YY_CONFIG where id="3117" and config="��")
	--begin
        --����ҩ�ʵ���ϸ���пۿ��

--����171429 �����޸ģ�֧��ģʽ0��1��2��3117=�����ҩ����
--�����ģ�ҩ����ҩ��Ҫ���п�洦�����ӿ�������У�
-- ģʽ3
--ģʽ0��1��2 �� 3117Ϊ�ǵ�ʱ��
if ((@ypxtslt in (0,1,2)) and (@config3117='��')) or (@ypxtslt in (3))  ----�Ƿ���Ҫ���п�洦���ж� start  ģʽ0��1,2��3117=��ʱ�����ﲻ��Ҫ���п�洦��͵��۴��� start
begin
	declare @cd_idm ut_xh9,
			@ypsl ut_sl10,
			@tymxxh ut_xh12,
			@fymxxh ut_xh12,
			@ylsj   ut_money,  --ҩƷ���ۼۣ�ƽ����
			@lsje   ut_je14,  --���۽�� 
			@jjje   ut_je14,   --���۽��  
			@czdmfy ut_dm2,
			@czdmty ut_dm2
			,@fymxylsj ut_money		--��ҩ��ϸ���ۼ�
			,@fymxyypjj_ts ut_money	--����(����)
			,@tmptfymxxh1 ut_xh12
			,@tmptfymxxh1_czdm ut_dm2
    
	declare @cur_pcxh ut_xh12,@cur_pcsl ut_sl10,@sysl ut_sl10  --��ǰ������ţ���ǰ����������ʣ������
	declare @pcjj1 ut_money,@ylsj1 ut_money,@lsje1 ut_je14,@jjje1 ut_je14  --���й�����

	select @ylsj=0,@lsje=0,@jjje=0
    
    CREATE TABLE [#tmp_sytk_pc_cfmx](
		[yfpcxh] [numeric](12, 0) NULL,
		[cd_idm] [numeric](9, 0)  NULL,
		[ykxs] [numeric](12, 4)  NULL,
		[sykt_ypsl] [numeric](38, 2) NULL,
		[avgylsj] [money] NULL,
		[avgypjj] [money] NULL,
		[ypfj] [money]  NULL,
		[sykt_lsje] [numeric](38, 2) NULL,
		[sykt_jjje] [numeric](38, 2) NULL
	) 

	 CREATE TABLE [#tmp_sytk_pc_cfmx3183](
	    [recno] ut_xh12 identity not null,
		[yfpcxh] [numeric](12, 0) NULL,
		[cd_idm] [numeric](9, 0)  NULL,
		[ykxs] [numeric](12, 4)  NULL,
		[sykt_ypsl] [numeric](38, 2) NULL,
		[avgylsj] [money] NULL,
		[avgypjj] [money] NULL,
		[ypfj] [money]  NULL,
		[sykt_lsje] [numeric](38, 2) NULL,
		[sykt_jjje] [numeric](38, 2) NULL
	) 

    create table #yftyzdmx
    (
      cd_idm ut_xh9 not null,
      ypsl  ut_sl10 not null,
      yfdm  ut_ksdm not null,
      tymxxh ut_xh12 not null,
      fymxxh ut_xh12 not null,
      czdmty ut_dm2 null,
      czdmfy ut_dm2 null,
      fymxylsj ut_money null,
      mxxh  ut_xh12 null
    ) 
	
    if @config3291='��'
    begin
  		INSERT into #yftyzdmx(cd_idm,ypsl,yfdm,tymxxh,fymxxh,czdmty,czdmfy,fymxylsj,mxxh)
		select b.cd_idm, case when b.wsbz=1 then (-b.ypsl*(b.cfts-b.wsts)) else (-b.ypsl*b.cfts) end , 
		a.yfdm,b.xh as tymxxh,d.xh as fymxxh,b.czdm as czdmty,
		d.czdm as czdmfy,b.ylsj  as fymxylsj,b.mxxh as mxxh
		from YF_MZFYZD a(nolock),YF_MZFYMX b(nolock),#tmp_mzfymx_data d(nolock)
		where a.xh=b.fyxh  and b.tfymxxh=d.xh and a.tfbz=1 and a.jlzt=0
		and a.xh>=@tyxh_begin and a.xh<=@xhtemp   and a.gfbz<>1 --�෽��ϸ���ۿ��
		and a.patid=@patid
    end
    else
    begin
		INSERT into #yftyzdmx(cd_idm,ypsl,yfdm,tymxxh,fymxxh,czdmty,czdmfy,fymxylsj,mxxh)
		select b.cd_idm, -b.ypsl*b.cfts, a.yfdm,b.xh as tymxxh,d.xh as fymxxh,b.czdm as czdmty,
		d.czdm as czdmfy,b.ylsj  as fymxylsj,b.mxxh as mxxh
		from YF_MZFYZD a(nolock),YF_MZFYMX b(nolock),#tmp_mzfymx_data d(nolock)
		where a.xh=b.fyxh  and b.tfymxxh=d.xh and a.tfbz=1 and a.jlzt=0
		and a.xh>=@tyxh_begin and a.xh<=@xhtemp
		and (@config3249='��' or (@config3249='��' and a.wsbz=0)) and a.gfbz<>1 --�෽��ϸ���ۿ��
		and a.patid=@patid   
    end
		   
	declare cs_yfty_mzty cursor for 
		select a.cd_idm,a.ypsl,a.yfdm,a.tymxxh,a.fymxxh,a.czdmty,a.czdmfy,a.fymxylsj,a.mxxh
		from #yftyzdmx a(nolock)
		where a.cd_idm<>0 and a.ypsl<>0	
			   
	for read only
	open cs_yfty_mzty
	fetch cs_yfty_mzty into @cd_idm, @ypsl, @yfdm,@tymxxh,@fymxxh,@czdmty,@czdmfy,@fymxylsj,@mxxh
	while @@fetch_status=0
	begin
		select @ylsj=0,@lsje=0,@jjje=0
		select @tmptfymxxh1=0,@tmptfymxxh1_czdm=''
		--if @config3180=2 
		if @ypxtslt in(2,3)
		begin
		    select @cur_pcxh=0
            select @tmptfymxxh1=tfymxxh,@tmptfymxxh1_czdm=czdm from #tmp_mzfymx_data where xh=@fymxxh
            --���ж��Ƿ��������ν�������ǰ����ҩ��û��YF_MZMXPCXX��¼��
            if not exists(select 1 from YF_MZMXPCXX(nolock) where zdmxxh=@fymxxh and czdm=@czdmfy)
				and not exists(select 1 from YF_MZMXPCXX(nolock) where zdmxxh=@tmptfymxxh1 and czdm=@tmptfymxxh1_czdm)
            begin
                if @ypxtslt=3 ----if @ypxtslt=3  start  ����ӵ� ��ͬ�۸�������ϣ����û�У�������ҩ
				begin
					select @cur_pcxh=0
					select top 1 @fymxyypjj_ts=@fymxylsj*(a.ypjj/a.yplsj) from YF_YFPCK a(nolock) where a.ksdm=@yfdm and a.cd_idm=@cd_idm 
					select top 1 @cur_pcxh=xh from YF_YFPCK a(nolock) where a.ksdm=@yfdm and a.cd_idm=@cd_idm and a.yplsj=@fymxylsj and a.ypjj=@fymxyypjj_ts
					if isnull(@cur_pcxh,0)=0
					begin
						insert into YF_YFPCK
						(ksdm,cd_idm,ykpcxh,ph,ykxs,dwxs,kcsl,pcdjsl,yplsj,ypjj,lsje,jjje,rkrq,sxrq,scrq,jlzt,memo) 
						select top 1 ksdm,cd_idm,0 ykpcxh,'mzbrty',ykxs,dwxs,0 kcsl,0 pcdjsl,@fymxylsj,@fymxyypjj_ts,0,0,convert(char(8),getdate(),112),convert(char(8),dateadd(year,2,getdate()),112),null,0,'' 
						from YF_YFPCK a(nolock) where a.ksdm=@yfdm and a.cd_idm=@cd_idm
						select @cur_pcxh=SCOPE_IDENTITY()
					end  
				end ---if @ypxtslt=3  end 
                exec usp_yf_kccl @cd_idm,@yfdm,@ypsl,0,@errmsg50 output ,0,@yfdm,0
					,@cur_pcxh,@tymxxh,@czdmty,@ylsj output,@lsje output,@jjje output
				if @errmsg50 like 'F%'
				begin
					select @errmsg='F'+substring(isnull(@errmsg50,''),2,49)
					rollback transaction
					close cs_yfty_mzty
                    deallocate cs_yfty_mzty
					goto err		
				end
            end
            else --��ҩ�����ν������ú�
            begin
				--�ҵ���ҩ�����ζ�Ӧ�ϣ�Ҫ��������ҩ�����
				select @sysl=@ypsl,@cur_pcxh=0,@cur_pcsl=0

				--Ӧ��ȡʣ����˵ļ�¼ start  ������
                delete from #tmp_sytk_pc_cfmx
				delete from #tmp_sytk_pc_cfmx3183
                insert into #tmp_sytk_pc_cfmx exec usp_yf_mzbftf_sycfmxinfo @mxxh,3
				if @@error<>0 or @@rowcount=0
				begin
					select @errmsg='Fȡʣ����˵ļ�¼ʧ�ܣ�'
					rollback transaction
					close cs_yfty_mzty
                    deallocate cs_yfty_mzty
					goto err
				end

				if @config3183=0
				begin
				   insert into #tmp_sytk_pc_cfmx3183(yfpcxh,cd_idm,ykxs,sykt_ypsl,avgylsj,avgypjj,ypfj,sykt_lsje,sykt_jjje)
				   select  a.yfpcxh,a.cd_idm,a.ykxs,a.sykt_ypsl,a.avgylsj,a.avgypjj,a.ypfj,a.sykt_lsje,a.sykt_jjje
				   from #tmp_sytk_pc_cfmx a,YF_YFPCK b(nolock) 
				   where a.yfpcxh=b.xh 
				   order by b.sxrq desc
				end
				else
				begin
				  insert into #tmp_sytk_pc_cfmx3183(yfpcxh,cd_idm,ykxs,sykt_ypsl,avgylsj,avgypjj,ypfj,sykt_lsje,sykt_jjje)
				   select a.yfpcxh,a.cd_idm,a.ykxs,a.sykt_ypsl,a.avgylsj,a.avgypjj,a.ypfj,a.sykt_lsje,a.sykt_jjje
				   from #tmp_sytk_pc_cfmx a,YF_YFPCK b(nolock) 
				   where a.yfpcxh=b.xh 
				   order by b.rkrq desc
				end
				
				select @cnt=count(1) from #tmp_sytk_pc_cfmx3183
				if isnull(@cnt,0)=0
				begin
					select @errmsg='Fȡʣ����˵ļ�¼ʧ��2��'
					rollback transaction
					close cs_yfty_mzty
                    deallocate cs_yfty_mzty
					goto err
				end

				delete from #tmp_sytk_pc_cfmx3183_order
				INSERT into #tmp_sytk_pc_cfmx3183_order(yfpcxh,sykt_ypsl)
				select yfpcxh,sykt_ypsl
				from #tmp_sytk_pc_cfmx3183 
				order by recno --ע������czslǰ���üӸ���

				declare cs_yfty_mzty_pc cursor for  
					--select yfpcxh,-czsl from YF_MZMXPCXX(nolock) where zdmxxh=@fymxxh and czdm=@czdmfy order by yfpcxh
					 select yfpcxh,sykt_ypsl as czsl from #tmp_sytk_pc_cfmx3183_order --ע������czslǰ���üӸ���

				for read only
				--Ӧ��ȡʣ����˵ļ�¼ end
				open cs_yfty_mzty_pc
				fetch cs_yfty_mzty_pc into @cur_pcxh,@cur_pcsl
				while @@fetch_status=0 and @sysl>0
				begin
					if @sysl - isnull(@cur_pcsl,0)<=0  --��ǰ�����ܷ���
						select @cur_pcsl=@sysl	
	       
					exec usp_yf_kccl @cd_idm,@yfdm,@cur_pcsl,0,@errmsg50 output ,0,@yfdm,0--1
									 ,@cur_pcxh,@tymxxh,@czdmty,@ylsj1 output,@lsje1 output,@jjje1 output

					if @errmsg50 like 'F%'
					begin
						select @errmsg='F'+substring(isnull(@errmsg50,''),2,49)
						rollback transaction
						close cs_yfty_mzty_pc
						deallocate cs_yfty_mzty_pc
						close cs_yfty_mzty
						deallocate cs_yfty_mzty
						goto err		
					end				        
					select @sysl=@sysl-@cur_pcsl,@lsje=@lsje+@lsje1,@jjje=@jjje+@jjje1 
					fetch cs_yfty_mzty_pc into @cur_pcxh,@cur_pcsl   
				end
				close cs_yfty_mzty_pc
				deallocate cs_yfty_mzty_pc
				
				if @ypxtslt=3  ---��ԭ����ҩʱ�յķ������˷�д��ҵ���
				begin						    
					delete from #mzmxpcxxjlb
					INSERT into #mzmxpcxxjlb(yfpcxh,yplsj) 
					select a.yfpcxh,a.yplsj 
					from YF_MZMXPCXX a(nolock) 
						inner join #tmp_mzfymx_data b on a.zdmxxh=b.fymxxh0
                    where b.xh=@fymxxh and a.czdm='09'
					if @@error<>0
					begin
						select @errmsg='F������ҩ�ʵ���ϸ'+isnull(convert(varchar(12),@tymxxh),'')+'���½��ʧ�ܣ�'
						rollback transaction
						close cs_yfty_mzty
						deallocate cs_yfty_mzty
						goto err
					end
					if @@ROWCOUNT=0  --û���ҵ�����������
					begin
						INSERT into #mzmxpcxxjlb(yfpcxh,yplsj)
						select a.yfpcxh,a.yplsj 
						from YF_NMZMXPCXX a(nolock) 
						   inner join #tmp_mzfymx_data b on a.zdmxxh=b.fymxxh0
                        where b.xh=@fymxxh and a.czdm='09' 
						if @@error<>0
						begin
							select @errmsg='F������ҩ�ʵ���ϸ'+isnull(convert(varchar(12),@tymxxh),'')+'���½��ʧ�ܣ�'
							rollback transaction
							close cs_yfty_mzty
							deallocate cs_yfty_mzty
							goto err
						end				        
					end
					----������ҩ���ݰ��ֵļ۸�����
					update a set a.yplsj=b.yplsj,
								 a.lsje=CONVERT(numeric(14,2),b.yplsj*a.czsl/a.ykxs)
					from YF_MZMXPCXX a,#mzmxpcxxjlb b
					where a.zdmxxh=@tymxxh and a.yfpcxh=b.yfpcxh and a.czdm='10' 
					if @@error<>0 or @@rowcount=0
					begin
						select @errmsg='F������ҩ�ʵ���ϸ'+isnull(convert(varchar(12),@tymxxh),'')+'���½��ʧ�ܣ�'
						rollback transaction
						close cs_yfty_mzty
						deallocate cs_yfty_mzty
						goto err
					end			    
					select @lsje=SUM(a.lsje)
					from YF_MZMXPCXX a
					where a.zdmxxh=@tymxxh and a.czdm='10' 
				end					
            end 
	    		    
			if @ypxtslt=3
			begin
				update YF_MZFYMX 
				set ylsj=abs(convert(money,(-@lsje)/(ypsl*isnull(cfts,1)/ykxs))),
				    lsje=-@lsje,
					jjje=-@jjje,
					jxce=(-1)*((-@lsje)-(-@jjje))
				where xh=@tymxxh
			end	 
            else --ͳһ���ۼ�
            begin
				update  YF_MZFYMX 
				set ylsj=b.ylsj,
				    lsje=-@lsje,
					jjje=-@jjje,
					jxce=(-1)*((-@lsje)-(-@jjje))
				from YF_MZFYMX a,YK_YPCDMLK b(nolock)
				where a.cd_idm=b.idm and  a.xh=@tymxxh 
			end	
			if @@error<>0 or @@rowcount=0
			begin
				select @errmsg='F������ҩ�ʵ���ϸ'+isnull(convert(varchar(12),@tymxxh),'')+'���½��ʧ�ܣ�'
				rollback transaction
				close cs_yfty_mzty
				deallocate cs_yfty_mzty
				goto err
			end

			update #cfmxk 
			set ylsj=b.ylsj 
			from #cfmxk a,YF_MZFYMX b(nolock) 
			where a.xh=b.mxxh and b.xh=@tymxxh
		   	if @@error<>0 or @@rowcount=0
			begin
				select @errmsg='F������ҩ�ʵ���ϸ'+isnull(convert(varchar(12),@tymxxh),'')+'���½��ʧ�ܣ�'
				rollback transaction
				close cs_yfty_mzty
				deallocate cs_yfty_mzty
				goto err
			end

		end else
	    begin
			exec usp_yf_kccl @cd_idm,@yfdm,@ypsl,0,@errmsg50 output,0,'',0--1
			if @errmsg50 like 'F%'
			begin
				select @errmsg='F'+substring(isnull(@errmsg50,''),2,49)
				rollback transaction
				close cs_yfty_mzty
				deallocate cs_yfty_mzty
				goto err
			end		
		end
		fetch cs_yfty_mzty into @cd_idm, @ypsl, @yfdm,@tymxxh,@fymxxh,@czdmty,@czdmfy,@fymxylsj,@mxxh
	end
	close cs_yfty_mzty
	deallocate cs_yfty_mzty

	if @ypxtslt in(2,3)
	begin
		update YF_MZFYZD set jjje=t1.jjje from (
		select a.xh,sum(b.jjje) jjje
			from  YF_MZFYZD a,YF_MZFYMX b(nolock)
		where a.xh=b.fyxh and a.xh>=@tyxh_begin and a.patid=@patid and a.xh<=@xhtemp group by a.xh) t1, YF_MZFYZD t2
		where t1.xh=t2.xh 
		if @@error<>0 or @@rowcount=0
		begin
			select @errmsg='F���·�ҩ�ʵ����۽�����'
		    rollback transaction
            goto err
		end
	end

	update YF_MZFYZD set jzbz=1
		where xh>=@tyxh_begin and xh<=@xhtemp and patid=@patid
	if @@error<>0 or @@rowcount=0
	begin
		select @errmsg='F���·�ҩ�ʵ����ʱ�־����'
		rollback transaction
        goto err
	end

/*---========================xwm 2011-12-08  ҩ�����ν��۴��� end ===============================================---*/

--��ʱ��ҩ����
if (@config0325='��')
begin
	declare @cur_ls_yfdm ut_ksdm,
			@cur_ls_czyh ut_czyh,
			@cur_ls_czlb int,
			@cur_ls_idm ut_xh9,
			@cur_ls_czsl ut_sl10,
			@cur_ls_sqks ut_ksdm,
			@cur_ls_sqys ut_czyh  
	        
	create table #lsypkzcl
	(
		yfdm ut_ksdm,--ҩ������
		czyh ut_czyh,--����Ա��
		czlb ut_bz, --0Ϊ���﷢ҩ��1Ϊ������ҩ��2ΪסԺ��ҩ��3ΪסԺ��ҩ
		idm ut_xh9,   --����idm
		czsl ut_sl10, --ҩƷ����
		sqks ut_ksdm, --�������
		sqys ut_czyh,  --����ҽ��
	)	
    delete from #lsypkzcl
    
	INSERT into #lsypkzcl
	(yfdm,czyh,czlb,idm,czsl,sqks,sqys)
	select @yfdm as yfdm,@czyh as czyh,1 as czlb,a.cd_idm as idm,
		  a.ypsl as czsl,c.ksdm as sqks,c.ysdm as sqys		   
	from #yftyzdmx a(nolock)
		  inner join  SF_CFMXK b(nolock) on a.mxxh=b.xh
		  inner join  SF_MZCFK c(nolock) on b.cfxh=c.xh
	where a.cd_idm<>0 and a.ypsl<>0	and c.patid=@patid  
		
		 	
	declare cs_ls_kckzcl cursor for 
		 select a.yfdm,a.czyh,a.czlb,a.idm,a.czsl,a.sqks,a.sqys 
		 from #lsypkzcl a(nolock)  
		 where a.czsl<>0  
	for read only

	open cs_ls_kckzcl
	fetch cs_ls_kckzcl into @cur_ls_yfdm,@cur_ls_czyh,@cur_ls_czlb,@cur_ls_idm,@cur_ls_czsl,@cur_ls_sqks,@cur_ls_sqys
	while @@fetch_status=0
	begin 
		exec usp_yy_lsyygz_kccl @cur_ls_yfdm,@cur_ls_czyh,@cur_ls_czlb,@cur_ls_idm,@cur_ls_czsl,@cur_ls_sqks,@cur_ls_sqys,
								0,@errmsg50 output			
		if @errmsg50 like 'F%'
		begin
			select @errmsg='F'+substring(isnull(@errmsg50,''),2,49)
			rollback transaction
			close cs_ls_kckzcl
			deallocate cs_ls_kckzcl
			goto err
		end      
		fetch cs_ls_kckzcl into @cur_ls_yfdm,@cur_ls_czyh,@cur_ls_czlb,@cur_ls_idm,@cur_ls_czsl,@cur_ls_sqks,@cur_ls_sqys
	end
	close cs_ls_kckzcl
	deallocate cs_ls_kckzcl      
end
---------------����෽ҩƷbegin
if exists(select 1 from #mzcfk_gf )
begin
     declare @cfxh_gf ut_xh12,@fyzdxh_gf ut_xh12,@idm_gf ut_xh12,@tcfts_gf ut_sl10
     declare cur_gf cursor for 
		 select xh from  #mzcfk_gf 	
	for read only

	open cur_gf
	fetch cur_gf into @cfxh_gf
	while @@fetch_status=0
	begin 
	       insert into YF_MZFYZD(jssjh, cfxh, patid, yfdm, sfrq, sfczry, pyrq, pyczry, fyrq, fyczyh,  
	                    cfts, tfbz, tfqrbz, jzbz, jlzt, tfxh, memo, zrys,tfys,yfyjs,fybz,wsbz,gfbz)  
	       select a.jssjh,a.xh,a.patid,a.yfdm,a.lrrq,a.czyh,a.pyrq,a.pyczyh,@tyrq,@czyh,b.tcfts,1,0,1,0,null,
		          @tyyy,@fzzr,@tyys,@yjs,1,b.wsbz,2
	       from SF_MZCFK a (nolock) inner join #mzcfk_gf b(nolock) on a.xh=b.xh
	       where a.xh=@cfxh_gf and a.patid=@patid 
	        IF @@ERROR<>0 OR  @@ROWCOUNT=0  
	       BEGIN  
				select @errmsg='F����෽��ҩ�ʵ���Ϣ����'
				rollback transaction
				close cur_gf
				deallocate cur_gf
				goto err   
		   END    
		   select @fyzdxh_gf=SCOPE_IDENTITY()

		   update a  set gfzdxh=@fyzdxh_gf 
		   from YF_MZFYZD a inner join #mzcfk_gf b(nolock) on a.xh=b.fyxh
		   where a.patid=@patid
	       IF @@ERROR<>0 OR  @@ROWCOUNT=0  
	       BEGIN  
				select @errmsg='F��д�෽�˵����ʧ�ܣ�'
				rollback transaction
				close cur_gf
				deallocate cur_gf
				goto err     
		   END 
		   
		   select @idm_gf=dyxdf_idm from SF_MZCFK a(nolock) where a.xh=@cfxh_gf and a.patid=@patid

		   if @idm_gf is null 
		   begin
				select @errmsg='Fȡ�෽idmʧ�ܣ�'
				rollback transaction
				close cur_gf
				deallocate cur_gf
				goto err 
		   end
		 select  @tcfts_gf= tcfts from #mzcfk_gf (nolock)  where xh=@cfxh_gf
		   IF @@ERROR<>0 OR  @@ROWCOUNT=0  
	       BEGIN  
				select @errmsg='Fȡ�˴������ʧ�ܣ�'
				rollback transaction
				close cur_gf
				deallocate cur_gf
				goto err    
		   END 
	    insert into YF_MZFYMX(fyxh, czdm, cfxh, mxxh, cd_idm, gg_idm, ypmc, ypdm, ypgg, ykxs,   
							ypdw, dwxs, ylsj,ypfj,jxce, cfts, ypsl,memo,jjje,mztybz,tfymxxh,wsbz,wsts) 
			     select @fyzdxh_gf,@czdm,@cfxh_gf,0,a.idm,a.gg_idm,a.ypmc,a.ypdm,a.ypgg,a.ykxs,a.mzdw
			     ,a.mzxs,a.ylsj,a.ypfj, @tcfts_gf*(d.jxje/case when d.kcsl3=0 then 1 else d.kcsl3 end),
			     @tcfts_gf,-1,'',@tcfts_gf*a.ylsj - @tcfts_gf*(d.jxje/case when d.kcsl3=0 then 1 else d.kcsl3 end),
			     1,0,0,0
			     from YK_YPCDMLK a(nolock),YF_YFZKC d (nolock)  
	  		     where a.idm=@idm_gf and a.idm=d.cd_idm and d.ksdm=@yfdm
          IF @@ERROR<>0 OR  @@ROWCOUNT=0  
	       BEGIN  
				select @errmsg='F���뷢ҩ��ϸʧ�ܣ�'
				rollback transaction
				close cur_gf
				deallocate cur_gf
				goto err    
		   END 
        --select @tcfts_gf=@tcfts_gf*-1
      	exec usp_yf_kccl @idm_gf,@yfdm,@tcfts_gf,0,@errmsg50 output,0,'',0--1
			if @errmsg50 like 'F%'
			begin
				select @errmsg='F'+substring(isnull(@errmsg50,''),2,49)
				rollback transaction
				close cur_gf
				deallocate cur_gf
				goto err  
			end		
		   
	fetch cur_gf into @cfxh_gf
	end
	close cur_gf
	deallocate cur_gf     
						 
	
end						  
---------------����෽ҩƷend
--�����ڲ�����ҩ��ʱ�򶳽���������������=��������+��ҩ���� begin ---------------------------------
if (@config3554='��')
begin
	declare @yfdm_tydj ut_ksdm,
	        @czyh_tydj ut_czyh,
			@mxxh_tydj ut_xh12,
			@cd_idm_tydj ut_xh9,
			@ypsl_tydj ut_sl10  
	        
	create table #tydjkztmp
	(
		yfdm ut_ksdm,--ҩ������
		czyh ut_czyh,--����Ա��
		mxxh ut_xh12 null,--YF_MZFYMX.xh
		idm ut_xh9,   --����idm
		ypsl ut_sl10, --ҩƷ����
	)	
    delete from #tydjkztmp
    
	INSERT into #tydjkztmp
	(yfdm,czyh,mxxh,idm,ypsl)
	select a.yfdm,@czyh as czyh,b.xh as mxxh,b.cd_idm,(-1)*b.cfts*b.ypsl 
    from YF_MZFYZD a(nolock)
	     inner join YF_MZFYMX b(nolock) on a.xh=b.fyxh	  		   
    where a.xh>=@tyxh_begin and a.xh<=@xhtemp and a.patid=@patid 
		 	
	declare cs_tydj_kz cursor for 
		 select a.yfdm,a.czyh,a.mxxh,a.idm,a.ypsl 
		 from #tydjkztmp a(nolock)  
		 where a.ypsl<>0  
	for read only

	open cs_tydj_kz
	fetch cs_tydj_kz into @yfdm_tydj,@czyh_tydj,@mxxh_tydj,@cd_idm_tydj,@ypsl_tydj
	while @@fetch_status=0
	begin 
	    --����
		exec usp_yf_jk_yy_freeze '1',@yfdm_tydj,'YF_MZFYMX',@mxxh_tydj,@cd_idm_tydj,@ypsl_tydj,0,@errmsg50 output			
		if @errmsg50 like 'F%'
		begin
			select @errmsg='F'+substring(isnull(@errmsg50,''),2,49)
			rollback transaction
			close cs_tydj_kz
			deallocate cs_tydj_kz
			goto err  
		end      
		fetch cs_tydj_kz into @yfdm_tydj,@czyh_tydj,@mxxh_tydj,@cd_idm_tydj,@ypsl_tydj
	end
	close cs_tydj_kz
	deallocate cs_tydj_kz  

end
--�����ڲ�����ҩ��ʱ�򶳽���������������=��������+��ҩ���� end ---------------------------------
-------�������
    commit transaction ---����������������� 
   	
	declare @xh     ut_xh12   --���
	declare @fyczyh ut_czyh   --��ҩ����Ա
	declare @jssjh  ut_sjh    --�����վݺ�
	declare @ypdw   ut_unit   --ҩƷ��λ
	declare @dwxs   ut_dwxs   --��λϵ��	 
	declare @qpfj	ut_money  --ǰ������
	declare	@qlsj	ut_money 	--ǰ���ۼ�
	declare @xpfj	ut_money	--��������
	declare @xlsj	ut_money        --�����ۼ�
	declare @tzje_pf ut_money       --�����������
	declare @tzje_ls ut_money       --�������۽��
	declare @memo	ut_memo	        --��ϸ��ע
	declare @pcxh   ut_xh12         --�������(�ⷿʵ�����ι���ʱ��Ҫ����)
	declare @cursor_yfpcxh ut_xh12  --ҩ���������
	
	if exists(select 1 from YF_MZFYZD a, YF_MZFYMX b, YK_YPCDMLK c (nolock) 
		where a.xh>=@tyxh_begin and a.xh<=@xhtemp and a.tfbz=1  and b.fyxh=a.xh and c.idm=b.cd_idm and a.patid=@patid
		and (b.ylsj<>c.ylsj or b.ypfj<>c.ypfj)) and (@ypxtslt<>3) 
	begin	--���۴��� start
	
		declare TJ_Cursor cursor for 
		select a.yfdm, a.xh, a.fyczyh, a.jssjh, b.cd_idm,  b.ypsl * (case isnull(b.wsbz,0) when 1 then(b.cfts-b.wsts) else b.cfts end) as ypsl ,b.ypdw, b.dwxs,--yxp 2007-8-28 ����usp_yf_jk_tjdzdsc��bug�޸�
			c.ypfj as q_ypfj,c.ylsj as q_ylsj ,b.ypfj as x_ypfj,b.ylsj as x_ylsj,  
			(c.ypfj-b.ypfj)*b.ypsl*(case isnull(b.wsbz,0) when 1 then(b.cfts-b.wsts) else b.cfts end)/c.ykxs as tzje_pf, 
			(c.ylsj-b.ylsj)*b.ypsl*(case isnull(b.wsbz,0) when 1 then(b.cfts-b.wsts) else b.cfts end)/c.ykxs as tzje_ls 
		from YF_MZFYZD a, YF_MZFYMX b, YK_YPCDMLK c (nolock) 
			where a.xh>=@tyxh_begin and a.xh<=@xhtemp and a.patid=@patid
			   and a.tfbz=1 and b.fyxh=a.xh and c.idm=b.cd_idm 
			   and (b.ylsj<>c.ylsj or b.ypfj<>c.ypfj)

		if @@error<>0
		begin
			select @errmsg='F���۵���ʱ����'
            goto err
		end

		open TJ_Cursor 
		
		fetch TJ_Cursor into @yfdm,@xh,@fyczyh,@jssjh,@cd_idm,@ypsl,@ypdw,@dwxs,@qpfj,@qlsj,@xpfj,@xlsj,@tzje_pf,@tzje_ls


		while @@fetch_status=0
		begin
			--����4.5ҩƷ���۽ӿ� 0������ҩ��
			exec usp_yf_jk_tjdzdsc @yfdm,@xh,@fyczyh,@jssjh,0,@cd_idm,@ypsl,@ypdw,@dwxs,@qpfj,@qlsj,@xpfj,@xlsj,'',@errmsg50 output
			
			if @errmsg50 like 'F%'
			begin
				select @errmsg='F'+substring(isnull(@errmsg50,''),2,49)
				close TJ_Cursor
                deallocate TJ_Cursor
                goto err
			end
		
			fetch TJ_Cursor into @yfdm,@xh,@fyczyh,@jssjh,@cd_idm,@ypsl,@ypdw,@dwxs,@qpfj,@qlsj,@xpfj,@xlsj,@tzje_pf,@tzje_ls

		end  --end while
	
		close TJ_Cursor
		deallocate TJ_Cursor
	
	end  --���۴��� end
	
	if exists(select 1 from YF_MZFYZD a, YF_MZFYMX b, YK_YPCDMLK c (nolock),YF_MZMXPCXX d(nolock),YF_YFPCK e(nolock) 
	where a.xh>=@tyxh_begin and a.xh<=@xhtemp and a.tfbz=1  and b.fyxh=a.xh and c.idm=b.cd_idm  and a.patid=@patid
	 and b.xh=d.zdmxxh and d.czdm='10' and d.yfpcxh=e.xh
	and (d.yplsj<>e.yplsj )) and (@ypxtslt=3)
	begin	--���۴��� start
			
		declare TJ_Cursor cursor for 
		select a.yfdm, a.xh, a.fyczyh, a.jssjh, b.cd_idm, (-1)*d.czsl as ypsl ,b.ypdw, b.dwxs,--yxp 2007-8-28 ����usp_yf_jk_tjdzdsc��bug�޸�
			c.ypfj as q_ypfj,e.yplsj as q_ylsj ,c.ypfj as x_ypfj,d.yplsj as x_ylsj,  
			(c.ypfj-c.ypfj)*(-1)*d.czsl/c.ykxs as tzje_pf, 
			(e.yplsj-d.yplsj)*(-1)*d.czsl/c.ykxs as tzje_ls,e.xh as yfpcxh 
		from YF_MZFYZD a(nolock), YF_MZFYMX b(nolock), YK_YPCDMLK c (nolock),YF_MZMXPCXX d(nolock),YF_YFPCK e(nolock)
		where a.xh>=@tyxh_begin and a.xh<=@xhtemp and a.patid=@patid
			   and a.tfbz=1 and b.fyxh=a.xh and c.idm=b.cd_idm 
			   and (d.yplsj<>e.yplsj ) and b.xh=d.zdmxxh and d.czdm='10' and d.yfpcxh=e.xh

		if @@error<>0
		begin
			select @errmsg='F���۵���ʱ����'
            goto err
		end

		open TJ_Cursor 
		
		fetch TJ_Cursor into @yfdm,@xh,@fyczyh,@jssjh,@cd_idm,@ypsl,@ypdw,@dwxs,@qpfj,@qlsj,@xpfj,@xlsj,@tzje_pf,@tzje_ls,@cursor_yfpcxh


		while @@fetch_status=0
		begin
			--����4.5ҩƷ���۽ӿ� 0������ҩ��
			exec usp_yf_jk_tjdzdsc @yfdm,@xh,@fyczyh,@jssjh,0,@cd_idm,@ypsl,@ypdw,@dwxs,@qpfj,@qlsj,@xpfj,@xlsj,'',@errmsg50 output,0,@cursor_yfpcxh
			
			if @errmsg50 like 'F%'
			begin
				select @errmsg='F'+substring(isnull(@errmsg50,''),2,49)
				close TJ_Cursor
                deallocate TJ_Cursor
                goto err
			end
		
			fetch TJ_Cursor into @yfdm,@xh,@fyczyh,@jssjh,@cd_idm,@ypsl,@ypdw,@dwxs,@qpfj,@qlsj,@xpfj,@xlsj,@tzje_pf,@tzje_ls,@cursor_yfpcxh

		end  --end while
	
		close TJ_Cursor
		deallocate TJ_Cursor
	
	end  --���۴��� end

end ----�Ƿ���Ҫ���п�洦���ж� end ģʽ0��1,2��3117=��ʱ�����ﲻ��Ҫ���п�洦��͵��۴��� end
else
begin --����Ҫ���п�洦�� start
   --ģʽ 2,3,  ��֧�� 3117 Ϊ������ 
   commit transaction ---����������������� 
end --����Ҫ���п�洦�� end

	 
declare @fph int, @blh ut_blh, @hzxm ut_mc64, @cardno ut_cardno ,@hzxb ut_mc64,@hznl int ,@kfks ut_mc64,@brzd ut_zdmc    
select  @fph = a.fph, @hzxm = b.hzxm, @blh = b.blh,@cardno = b.cardno,@hzxb = b.sex, @hznl = datediff(yy,birth,getdate())    
from SF_BRJSK a (nolock),SF_BRXXK b (nolock)      
where a.patid=b.patid and a.sjh=@sjh and a.patid=@patid   
    
select top 1 @kfks = a.yjks_mc 
from YY_KSBMK a(nolock),VW_MZCFK b(nolock),#tycfxhlist c(nolock)  
where a.id = b.ksdm and b.patid=@patid  and b.xh=c.cfxh     
    
select @brzd = b.zdmc 
from VW_MZHJCFK  a(nolock) 
    inner join VW_MZCFK c(nolock) on a.xh=c.hjxh and a.patid=c.patid
	inner join #tycfxhlist d(nolock) on c.xh=d.cfxh
    left join VW_SF_YS_MZBLZDK b (nolock) on a.ghxh=b.ghxh and isnull(b.cfxh,0)=0  
where a.ghxh=b.ghxh and a.patid=@patid
order by b.zdlx     
    
 if not exists(select 1 from YY_CONFIG where id ='3398' and config='��')   ---  ����3398 ������ҩ��ӡʱ���Ƿ��ӡԭ��ҩ��Ϣ Ϊ �� start
 begin 
    delete from #result 
    insert into #result(rettype,retmsg,sjh,
	  ypmc,ypgg,ypdj,
	  tysl,sl,
	  ypdw,tyje,lsje,
	  ��Ʊ��,�����,����,����,�Ա�,����,��������,���,
	  lrrq,zxrq,tysl1,ypsl1,
	  lcjsdj,xh,mxxh,zje,ypsl2,cfts,cfxh,ypyf,memo1,memo2)  
	select distinct 'T', @sjh,@sjh sjh, 
	  b.ypmc, b.ypgg, convert(numeric(12,4), b.ylsj*b.dwxs/b.ykxs) ypdj,       
	  convert(numeric(10,2),b.typsl/b.dwxs) tysl,convert(numeric(10,2),b.typsl/b.dwxs) sl, 
	  b.ypdw, convert(numeric(12,2), b.ylsj*typsl/b.ykxs*tcfts) tyje,convert(numeric(12,2), b.ylsj*b.typsl/b.ykxs*b.tcfts) lsje,      
	  @fph '��Ʊ��', @blh '�����', @hzxm '����', @cardno '����',@hzxb '�Ա�',rtrim(convert(varchar,@hznl))  '����',@kfks '��������',@brzd '���',
	  a.lrrq ,@now as zxrq,convert(numeric(10,2),b.typsl/b.dwxs*b.tcfts) tysl1,convert(numeric(10,2),b.typsl/b.dwxs*b.tcfts) ypsl1,       
	  --yxp del 2007-10-31,convert(numeric(12,4), b.yylsj*dwxs/ykxs) yylsj --yxp 2007-10-31 �ɽ�������ҽԺҩƷ�����HISʵ��:����SF_CFMXK.yylsj�Ĵ���    
	  convert(numeric(12,4), b.lcjsdj*b.dwxs/b.ykxs) lcjsdj,b.mxxh xh,b.mxxh,mx.zje,mx.ypsl/mx.dwxs ypsl2,mx.cfts,b.cfxh,'' ypyf,c.memo1,c.memo2   
	from #cfmxk b(nolock)
	    inner join VW_MZCFMXK mx(nolock) on b.xh=mx.xh  
		inner join #tmp_currty_mzcfk_data a(nolock) on  a.xh=b.cfxh   
		left join VW_MZCFMXK_FZ c(nolock) on b.cfxh=c.cfxh and b.mxxh=c.mxxh
	select top 1 @errmsg=rettype+retmsg from #result
	goto success  
 end   ---  ����3398 ������ҩ��ӡʱ���Ƿ��ӡԭ��ҩ��Ϣ Ϊ �� end     
 else    
 begin   ---  ����3398 ������ҩ��ӡʱ���Ƿ��ӡԭ��ҩ��Ϣ Ϊ �� start  
    delete from #result 
   insert into #result(rettype,retmsg,sjh,
	  ypmc,ypgg,ypdj,
	  tysl,sl,
	  ypdw,tyje,lsje,
	  ��Ʊ��,�����,����,����,�Ա�,����,��������,���,
	  lrrq,zxrq,tysl1,ypsl1,
	  lcjsdj,xh,mxxh,zje,ypsl2,cfts,cfxh,ypyf,memo1,memo2)     
	select distinct 'T', @sjh,@sjh sjh, 
	   c.ypmc, c.ypgg, convert(numeric(12,4), c.ylsj*c.dwxs/c.ykxs) ypdj,      
	   convert(numeric(10,2),c.ypsl/c.dwxs) tysl,convert(numeric(10,2),c.ypsl/c.dwxs) sl, 
	   c.ypdw, convert(numeric(12,2), c.ylsj*c.ypsl/c.ykxs*c.cfts) tyje,convert(numeric(12,2), c.ylsj*c.ypsl/c.ykxs*c.cfts) lsje,    
	   @fph '��Ʊ��', @blh '�����', @hzxm '����', @cardno '����',@hzxb '�Ա�',rtrim(convert(varchar,@hznl)) '����',@kfks '��������',@brzd '���',
	   b.lrrq ,@now as zxrq,convert(numeric(10,2),a.ypsl/a.dwxs*a.cfts) tysl1, convert(numeric(10,2),a.ypsl/a.dwxs*a.cfts) ypsl1,      
	   convert(numeric(12,4), c.lcjsdj*c.dwxs/c.ykxs) lcjsdj,c.xh xh,c.xh mxxh,c.zje zje,c.ypsl/c.dwxs ypsl2,  
	   c.cfts cfts,b.xh as cfxh,  
	   rtrim(convert(varchar(14),e.ypjl))+rtrim(e.jldw)+' '+rtrim(f.xsmc)+'*'+rtrim(convert(varchar(3),e.ts))+' '+g.name as ypyf,
	   h.memo1,h.memo2  
	from #cfmxk a 
		inner join VW_MZCFK b(nolock) on a.cfxh=b.xh--ԭ���Ĵ���    
		inner join VW_MZCFMXK c(nolock) on c.cfxh=b.xh and a.xh=c.xh  
		left join VW_MZHJCFMXK e (nolock) on b.hjxh = e.cfxh and c.hjmxxh=e.xh  
		left join SF_YS_YZPCK f (nolock) on e.pcdm = f.id  
		left join SF_YPYFK g (nolock) on e.ypyf = g.id 
		left join VW_MZCFMXK_FZ h(nolock) on a.cfxh=h.cfxh and a.mxxh=h.mxxh
	where b.patid=@patid
	
	insert into #result(rettype,retmsg,sjh,
	  ypmc,ypgg,ypdj,
	  tysl,sl,
	  ypdw,tyje,lsje,
	  ��Ʊ��,�����,����,����,�Ա�,����,��������,���,
	  lrrq,zxrq,tysl1,ypsl1,
	  lcjsdj,xh,mxxh,zje,ypsl2,cfts,cfxh,ypyf,memo1,memo2)       
	select distinct 'T', @sjh,@sjh sjh,  
	  b.ypmc, b.ypgg, convert(numeric(12,4), b.ylsj*dwxs/b.ykxs) ypdj,  --��ǰ��ҩ     
	  convert(numeric(10,2),-1*typsl/dwxs) tysl,convert(numeric(10,2),-1*typsl/dwxs) sl, 
	  b.ypdw, convert(numeric(12,2),-1*e.ylsj*typsl/b.ykxs*tcfts) tyje,convert(numeric(12,2),-1*e.ylsj*typsl/b.ykxs*tcfts) lsje,      
	  @fph '��Ʊ��', @blh '�����', @hzxm '����', @cardno '����',@hzxb '�Ա�',rtrim(convert(varchar,@hznl)) '����',@kfks '��������',@brzd '���',
	  a.lrrq ,@now as zxrq,convert(numeric(10,2),-1*typsl/dwxs*tcfts) tysl1,convert(numeric(10,2),-1*typsl/dwxs*tcfts) ypsl1,       
	  convert(numeric(12,4), b.lcjsdj*dwxs/b.ykxs) lcjsdj,b.mxxh xh,b.mxxh,b.zje,b.ypsl ypsl2,  
	  b.cfts cfts,b.cfxh,  
	  rtrim(convert(varchar(14),e.ypjl))+rtrim(e.jldw)+' '+rtrim(f.xsmc)+'*'+rtrim(convert(varchar(3),e.ts))+' '+g.name as ypyf, 
	  c.memo1,c.memo2    
	from #cfmxk b  
		inner join #tmp_currty_mzcfk_data a on b.cfxh =a.xh  
		left join VW_MZHJCFMXK e (nolock) on a.hjxh = e.cfxh and b.hjmxxh=e.xh  
		left join SF_YS_YZPCK f (nolock) on e.pcdm = f.id  
		left join SF_YPYFK g (nolock) on e.ypyf = g.id
		left join VW_MZCFMXK_FZ c(nolock) on b.cfxh=c.cfxh and b.mxxh=c.mxxh
    where  a.xh=b.cfxh
	 
    select top 1 @errmsg=rettype+retmsg from #result
	goto success    
 end ---  ����3398 ������ҩ��ӡʱ���Ƿ��ӡԭ��ҩ��Ϣ Ϊ �� end  
 
end  --- if @jszt=3   end

delete from #result
insert into #result(rettype,retmsg) select 'T' rettype,'' retmsg
goto success 

--=============���ؽ��==================
err:
  select @errmsg='F'+ltrim(rtrim(substring(isnull(@errmsg,''),2,499)))
  if @delphi=1
  begin
     delete from #result

	 insert into #result(rettype,retmsg)
	 select 'F' rettype,ltrim(rtrim(substring(isnull(@errmsg,''),2,499))) retmsg

	 select 'F' rettype,a.retmsg,a.sjh,
	        a.ypmc,a.ypgg,a.ypdj,a.tysl,a.sl,a.ypdw,a.tyje,a.lsje,a.��Ʊ��,a.�����,a.����,a.����,a.�Ա�,a.����,a.��������,a.���,
			a.lrrq,a.zxrq,a.tysl1,a.ypsl1,a.lcjsdj,a.xh,a.mxxh,a.zje,a.ypsl2,a.cfts,a.cfxh,a.ypyf,a.memo1,a.memo2
	 from #result a
  end
return 


success:
  select @errmsg='T'+ltrim(rtrim(substring(isnull(@errmsg,''),2,499)))
  if @delphi=1
  begin
    select 'T' rettype,a.retmsg,a.sjh,
	        a.ypmc,a.ypgg,a.ypdj,a.tysl,a.sl,a.ypdw,a.tyje,a.lsje,a.��Ʊ��,a.�����,a.����,a.����,a.�Ա�,a.����,a.��������,a.���,
			a.lrrq,a.zxrq,a.tysl1,a.ypsl1,a.lcjsdj,a.xh,a.mxxh,a.zje,a.ypsl2,a.cfts,a.cfxh,a.ypyf,a.memo1,a.memo2
	 from #result a
  end
return





