Text
CREATE proc usp_sf_bftf
	@wkdz varchar(32),
	@jszt smallint,
	@sfbz smallint,
	@qtbz smallint,
	@rqbz smallint,
  	@sjh ut_sjh,
	@czyh ut_czyh,
	@cfxh ut_xh12,
	@mxxh ut_xh12, 
	@tysl ut_sl10, 
	@cfts integer,
	@newsjh ut_sjh = null,
	@zxlsh_tf ut_lsh = null,
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
	@jsrq ut_rq16 = '',
	@jsrq_tf ut_rq16 = ''
	,@ylknewje ut_money=0
	,@ylkhcsqxh ut_lsh=''
	,@ylkhczxlsh ut_lsh=''
	,@ylknewsqxh ut_lsh=''
	,@ylknewzxlsh ut_lsh=''
	,@zffs ut_bz=0
	,@tfksdm     ut_ksdm=''--add by wudong 2015-06-19 Ҫ��29652
	,@isxjtf_paycenter ut_bz=0 --����֧�����İ��ֽ��˷�
as --��160146 2019-12-26 16:23:45 4.0��׼��_201810����
/**********
[�汾��]4.0.0.0.0
[����ʱ��]2004.11.3
[����]����
[��Ȩ] Copyright ? 2004-2008�Ϻ����˴�-��������ɷ����޹�˾[����]�շѲ����˷�
[����˵��]
	�շѲ����˷ѣ�֧���˷�ҩ�ѣ�֧��ҩ����ҩ���շ�ȷ��
[����˵��]
	@wkdz varchar(32),	������ַ
	@jszt smallint,		����״̬	1=������2=���룬3=�ݽ�
	@sfbz smallint,		�շѱ�־0=Ԥ�㣬1=�ݽ�(����1), 2=��ʽ�ݽ�(����2)
	@qtbz smallint,		ȫ�˱�־0=���֣�1=ȫ��(�˱�־ֻ��@sfbz=2ʱ��Ч)
	@rqbz smallint,		���ڱ�־0=�տ⣬1=���
  	@sjh ut_sjh,		�վݺ�
	@czyh ut_czyh,		����Ա��
	@cfxh ut_xh12,		�������
	@mxxh ut_xh12,		��ϸ���
	@tysl ut_sl10,		��ҩ����
	@cfts integer,		��������
	@newsjh ut_sjh = null,		���վݺ�
	@zxlsh_tf ut_lsh = null,	�˷ѷ��ص�������ˮ��
	@zhbz ut_zhbz = null,		�˻���־	
	@zddm ut_zddm = null,		��ϴ���
	@zxlsh ut_lsh = null,		������ˮ��
	@jslsh ut_lsh = null,		������ˮ��
	@xmlb ut_dm2 = null,		����Ŀ
	@qfdnzhzfje numeric(12,2) = null, 	�𸶶ε����˻�֧��
	@qflnzhzfje numeric(12,2) = null,	�𸶶������ʻ�֧��
	@qfxjzfje numeric(12,2) = null,		�𸶶��ֽ�֧��
	@tclnzhzfje numeric(12,2) = null,	ͳ��������ʻ�֧��
	@tcxjzfje numeric(12,2) = null,		ͳ����ֽ�֧��
	@tczfje numeric(12,2) = null,		ͳ���ͳ��֧��
	@fjlnzhzfje numeric(12,2) = null,	���Ӷ������ʻ�֧��
	@fjxjzfje numeric(12,2) = null,		���Ӷ�����֧��
	@dffjzfje numeric(12,2) = null		���Ӷεط�����֧��
	@dnzhye numeric(12,2) = null,		�����˻����
	@lnzhye numeric(12,2) = null		�����˻����
	@jsrq ut_rq16 = ''					��������
	@jsrq_tf ut_rq16 = ''				��������(�˷�)
--mit ,, 2oo3-o5-o8 ,, ����������
	,@ylknewje ut_money=0		--���������
	,@ylkhcsqxh ut_lsh=''		--���������������
	,@ylkhczxlsh ut_lsh=''		--��������������ˮ��
	,@ylknewsqxh ut_lsh=''		--���������������
	,@ylknewzxlsh ut_lsh=''		--��������������ˮ��
	,@zffs ut_bz=0				--֧����ʽ0�����ֽ�1����֧Ʊ
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��]
[�޸���־]
qxh 2003.5.29 ���˰�������Ʊ��ʽ�µ��˲��ִ�������
tony 2003.8.21 �޸���ҽ�������Ը�����
tony 2003.12.8 С����ҽ���޸�
gzy 20050330 ���Ӳ����˷�ʱ�´����Ĵ��������ϵķ�ҩ���
zwj 20050616 ���ӻ�����ϸ��ŵĴ���
ozb 20060320 ���Ӷ���ҩ��Ĵ���
ozb 20060622 ���ӷ�Ʊ��ŵĺ�弰��ش������ӷ�Ʊ��ϸ��Ӧ��ĺ��
ozb 20060704 ���ӶԾɵĴ�ӡģʽ�ļ��ݵĴ���
sunyu 20061206 ���Ӷ԰������˲��Ʒ����Ը��Ĵ���
**********/
set nocount on

--���ɵݽ�����ʱ��
declare @tablename varchar(32),@acfdfp ut_bz,@bcdwtffp ut_bz
	,@configdyms	ut_bz	--��ӡģʽ0 ��ģʽ 1 ��ģʽ	--add by ozb 20060704
	,@bkybdmjh		varchar(255)
    ,@isbftfall     ut_bz ---һ�ŷ�Ʊ0����1����������
    ,@qtbz_cf      ut_bz
	,@postffs		ut_bz	--��2181Ϊ�ǵ������ 0:��ѡ�������� 1:���ո���Ĭ�϶���pos  2:���ո���Ĭ�϶����ֽ� 3:������pos�����˽�
	,@ntfts			int		--�˷�����
	,@acfdfp_dyfs	varchar(2)	--��������ӡʱ��ӡ��ʽ��0����������ӡ1�ϲ���ҩ��������2�Ͳ���ͬ��ִ�п��Һʹ�������
    ,@zdgrjzsj varchar(20) --���ĸò���Ա��������
    ,@yczyh ut_czyh  --�˷Ѽ�¼�Ĳ���Ա�� 
    ,@ysfrq varchar(20) --�˷Ѽ�¼���շ�����
    ,@config2545 varchar(500)--�����շѳ�POS�����������ֽ��˷ѵ�֧����ʽ���� Ĭ��Ϊ�գ���������ö��ŷָ����Զ��ſ�ͷ���Ž�β

,@sfly ut_bz  --�շ���Դ
declare	@outmsg varchar(200)
declare @yjclfbz   ut_bz,
		@yjqxyy ut_mc64
exec usp_yy_ldjzq @outmsg output
if substring(@outmsg,1,1)='F'
begin
	select	'F',substring(@outmsg,2,200)
	return
end

select @tablename='##sfbftf'+@wkdz+@czyh

if (select config from YY_CONFIG (nolock) where id='2044')='��'
 	set   @acfdfp=0
else
 	set   @acfdfp=1
 	

--add by ozb
if exists(select 1 from YY_CONFIG where id='2153'and config='��') 
	select @bcdwtffp=1
else
	select @bcdwtffp=0

--add by ozb �շ��Ƿ�ʹ���µĴ�ӡģʽ
if exists(select 1 from YY_CONFIG where id='2154' and config='��')
	select @configdyms=1 
else 
	select @configdyms=0

if exists(select 1 from YY_CONFIG where id='2192' and config='��')
	select @isbftfall=1 
else 
	select @isbftfall=0

select @acfdfp_dyfs=config from YY_CONFIG (nolock) where id='2270'
if @@rowcount=0 or isnull(@acfdfp_dyfs,'')=''
select @acfdfp_dyfs='0'

--add by sunyu 2006-12-06
select @bkybdmjh=config from YY_CONFIG (nolock) where id='0102'

select @postffs=config from YY_CONFIG (nolock) where id='2204'
select @postffs=isnull(@postffs,0)

select @config2545=config from YY_CONFIG(nolock) where id='2545'

if (@sjh='zzj' or @sjh='zzsf') select @sfly=1
	if @sjh='yszdy' select @sfly=2
	if @sjh='mzyj'  select @sfly=3
	if ltrim(rtrim(@sjh))='000' select @sfly=0 

--cjt �ж�����Ȩ�����ֽ�	alter by liuchun 20140523
declare @gwdm	varchar(50),@config0205 varchar(50),@strMess varchar(5),@isCross smallint
select @gwdm = isnull(gwdm,'') from czryk(nolock) where id = @czyh
select @config0205 = isnull(config,'') from YY_CONFIG(nolock) where id = '0205'
select @isCross = 0
if exists(select 1 from SF_BRJSK where sjh=@sjh and jlzt=0 and ybjszt=2 and xjje<>0)
   and @config0205 <> ''
begin
	--���ո�λ�������жϣ�ĳЩ����Ա���ܴ��ڶ����λ���룬��Ҫ������� ����202881
	while ltrim(@gwdm)<>'' 
	begin
		select @strMess = SUBSTRING(@gwdm,1,CHARINDEX(',',@gwdm)-1)
		select @gwdm = SUBSTRING(@gwdm,CHARINDEX(',',@gwdm)+1,LEN(@gwdm)-CHARINDEX(',',@gwdm))
		if CHARINDEX('"'+@strMess+'"',@config0205)>0
		begin
			select @isCross=1
			break
		end
	end
	if @isCross <> 1
	begin
		select 'F','����Աû�����ֽ�Ȩ��'
		return
	end
end
if exists (select 1 from YY_CONFIG(nolock) where id='0236' and config='��')
begin
    if exists (select 1 from VW_MZBRJSK where sjh=@sjh and isnull(fph,0)=0 and fpdybz <> 2)
    begin
        select 'F','�˽����¼δ��ӡ��Ʊ�������˷ѣ�'
        return
    end
end
if @jszt=1
begin
	exec('if exists(select * from tempdb..sysobjects where name="'+@tablename+'")
		drop table '+@tablename)
	exec('create table '+@tablename+'(
		cfxh ut_xh12 not null,
		mxxh ut_xh12 not null,
		cfts int not null,
		tysl ut_sl10 not null
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
if @jszt=2
begin
	declare @ccfxh varchar(12),
		@cmxxh varchar(12),
		@ccfts varchar(8),
		@ctysl varchar(12)

	select @ccfxh=convert(varchar(12),@cfxh),
		@cmxxh=convert(varchar(12),@mxxh),
		@ccfts=convert(varchar(8),@cfts),
		@ctysl=convert(varchar(12),@tysl)

	exec('insert into '+@tablename+' values('+@ccfxh+','+@cmxxh+','+@ccfts+','+@ctysl+')')
	if @@error<>0
	begin
		select "F","������ʱ��ʱ����"
		return
	end 
    if exists(select 1 from YF_MZFYZD b(nolock) where b.jssjh=@sjh and b.cfxh=@cfxh and b.fybz=1  )
	if not exists(select 1 from YF_MZFYZD b(nolock) where b.jssjh=@sjh and b.cfxh=@cfxh and b.fybz=1 and b.tfbz=1 and b.jlzt=0 and b.tfqrbz = 0 )
	begin
		select "F","�˴��������ѷ�ҩ��Ϣ,������ҩ��"
		return
	end 
	select "T"
	return
end

declare	@now ut_rq16,		--��ǰʱ��
		@ybdm ut_ybdm,		--ҽ������
		@zfbz smallint,		--������־
		@rowcount int,
		@error int,
		@zje ut_money,		--ҩ���ܽ��
		@zje1 ut_money,		--��ҩ���ܽ��
		@zfyje ut_money,	--�Է�ҩ�ѽ��
		@zfyje1 ut_money,	--�Էѷ�ҩ�ѽ��
		@yhje ut_money,		--�Ż�ҩ�ѽ��
		@yhje1 ut_money,	--�Żݷ�ҩ�ѽ��
		@ybje ut_money,		--������ҽ�������ҩ�ѽ��
		@ybje1 ut_money,	--������ҽ������ķ�ҩ�ѽ��
		@pzlx ut_dm2,		--ƾ֤����
		@sfje ut_money,		--ʵ�ս��(ҩƷ)
		@sfje1 ut_money,	--ʵ�ս��(��ҩƷ)
		@flzfje ut_money,	--�����Էѽ��(ҩƷ)
		@flzfje1 ut_money,	--�����Էѽ��(��ҩƷ)
		@flzfjedbxm ut_money, --�����Ը����(�󲡷�Χ��Ŀ)
		@sfje_all ut_money,	--ʵ�ս��(�����Էѽ��)
		@errmsg varchar(50),
		@srbz char(1),		--�����־
		@srje ut_money,		--������
		@sfje2 ut_money,	--������ʵ�ս��
		@xhtemp ut_xh12,
		@ksmc ut_mc32,		--��������
		@ysmc ut_mc32,		--ҽ������
		@xmzfbl float,		--ҩƷ�Ը�����
		@xmzfbl1 float,		--��ҩƷ�Ը�����
		@xmzfbltf float,	--ҩƷ�Ը�����
		@xmzfbltf1 float,	--��ҩƷ�Ը�����
		@xmce ut_money,		--�Ը����ʹ����Ը������ܵĲ��
		@fplx smallint,		--��Ʊ����
		@fph bigint,			--��Ʊ��
		@fpjxh ut_xh12,		--��Ʊ�����
		@print smallint,	--�Ƿ��ӡ0��ӡ��1����
		@tfbz smallint,		--�˷ѱ�־0=��һ���ˣ�1=����ʧ�ܹ�
		@newsjh1 ut_sjh,
		@qkbz smallint,		--Ƿ���־0��������1�����ˣ�2��Ƿ��
		@qkje ut_money,		--Ƿ������˽�
		@qkje1 ut_money,	--Ƿ������˽�
		@zhje ut_money,		--�˻����
		@patid ut_xh12,		--����Ψһ��־
		@djbz int,			--�����־
		@qkbz1 smallint,	--Ƿ���־0��������1�����ˣ�2��Ƿ��
		@sfrq 	ut_rq16,		--�˷ѵ��շ�����
		@qkje2 ut_money, 		--������� ������λС��
		@sfje_bkall ut_money,	--����ʵ�ս��(�����Էѽ��)
		@tcljbz1 int,		--ͳ���ۼƱ�־
		@tcljje1 ut_money,	--ͳ���ۼƽ��򱣡��½��ػ�ʹ�ã�
		@config3291 varchar(5),
		@config2395 varchar(500),  --�󲡼�����Χ�ڵ���Ŀ���뼯��
		@ccfbz ut_bz --��������־,

declare @ybzje	ut_money,	--ҽ�����׷����ܶ�
	@ybjszje ut_money,	--ҽ�����㷶Χ�����ܶ�
	@ybzlf ut_money,	--���Ʒ�
	@ybssf ut_money,	--�������Ϸ�
	@ybjcf ut_money,	--����
	@ybhyf ut_money,	--�����
	@ybspf ut_money,	--��Ƭ��
	@ybtsf ut_money,	--͸�ӷ�
	@ybxyf ut_money,	--��ҩ��
	@ybzyf ut_money,	--�г�ҩ��
	@ybcyf ut_money,	--�в�ҩ��
	@ybqtf ut_money,	--������
	@ybgrzf ut_money,	--��ҽ�����㷶Χ�����Է�
	@yjbz ut_bz,		--�Ƿ�ʹ�ó�ֵ��
	@yjye ut_money,		--Ԥ�������
	@bdyhkje ut_money --�����п����
	,@ylkysje ut_money	--POS��������IC�����	add by gzy at 20050501
	--,@posfph	int	--add by gzy at 20061101 ����POS���ķ���
	,@posfph	varchar(32)	--modify by zyh 20090610 ֧Ʊ�ſ��ܰ�����ĸ
	,@yplcjs2169 varchar(6)  --�Ƿ�ʹ��ҩƷ����
	,@lcyhje ut_money   --����Żݽ��
	,@jfbz varchar(2)
	,@jfje ut_money
	,@config2471 smallint
--tony 2003.12.8 С����ҽ���޸�
declare @tcljje numeric(12,2),	--ͳ���ۼƽ��
		@jsfs ut_bz,				--���㷽ʽ
		@tcljbz ut_bz		--ͳ���ۼƱ�־
--��Ա�������޸��������� zwj 2006.12.12
		,@hykmsbz ut_bz		--��Ա��ģʽ��־
		,@hysybz ut_bz		--��Աʹ�ñ�־(YY_YBFLK��hysybz)
		,@xjje	ut_money
		,@qrbz	ut_bz
		,@zpje ut_money
		,@zph varchar(32)
		,@tslc	ut_bz	--�˻�ͣ�ú�,�˷���������,����6233 add by liuchun 20140926
		,@qkje_ts1 ut_money
		,@qkje_ts ut_money
		,@qrbznew ut_bz		--�����ɵļ�¼��qrbz
		,@tfspbz ut_bz		--�����ɵļ�¼��tfspbz

if exists(select 1 from YY_JZBRK a(nolock),YY_JZBRYJK b(nolock) where a.xh = b.jzxh and isnull(b.sjh,'') = @sjh 
	and a.jlzt = 1)
begin
	select @tslc = 1
end
else
begin
	select @tslc = 0
end


select @now=convert(char(8),getdate(),112)+convert(char(8),getdate(),8),
	@zje=0, @zfyje=0, @yhje=0, @ybje=0,
	@zje1=0, @zfyje1=0, @yhje1=0, @ybje1=0,
	@sfje=0, @sfje1=0, @sfje_all=0, @srje=0, @sfje2=0, 
	@xmzfbl=0, @xmzfbl1=0, @xmce=0, @print=0, @tfbz=0,
	@qkbz=0, @qkje=0, @qkje1=0, @zhje=0, @djbz=0,@xmzfbltf=0, @xmzfbltf1=0,
	@flzfje=0, @flzfje1=0,@sfje_bkall = 0,@bdyhkje = 0
	, @tcljje1=0,@jfbz = '0',@jfje = 0,@xjje=0,@qrbz=0,@zpje=0,@zph='',@qrbznew=0,@config2471=0

select  @ybzje=0, @ybjszje=0, @ybzlf=0, @ybssf=0,
	@ybjcf=0, @ybhyf=0, @ybspf=0, @ybtsf=0,
	@ybxyf=0, @ybzyf=0, @ybcyf=0, @ybqtf=0,
	@ybgrzf=0, @yjbz=0, @yjye=0,
	@ylkysje = 0,@config2395='',@flzfjedbxm=0	--add by gzy at 20050501

select @tcljje=0, @jsfs=0, @tcljbz=0, @hykmsbz=0,@yplcjs2169 = '',@lcyhje = 0
declare @srfs varchar(1)  --0����ȷ���֣�1����ȷ����
select @srfs = 0
select @srfs = config from YY_CONFIG (nolock) where id='2235'
if @@error<>0 or @@rowcount=0
	select @srfs='0'
if exists (select 1 from YY_CONFIG(nolock) where id='3291' and config='��')
    select @config3291='��'
else
    select @config3291='��'
if exists (select 1 from YY_CONFIG(nolock) where id='2395')
    select @config2395=isnull(config,'') from YY_CONFIG(nolock) where id='2395'
else
    select  @config2395=''

if exists(select 1 from YY_CONFIG nolock where id = '2471' and config='��')
	select @config2471 = 1
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

--�˷�Ԥ��
if @sfbz=0
begin
	--��ʼ�����˵�����ϸ��Ĵ�������
	create table #cfmx_tf
	(
		cfxh ut_xh12 not null,
		mxxh ut_xh12 not null,
		cfts int not null,
		tysl ut_sl10 not null
	)
	exec('insert into #cfmx_tf select * from '+@tablename)
	if @@error<>0
	begin
		select "F","������ʱ��ʱ����"
		return
	end
	
	exec('drop table '+@tablename)
	
	select xh, jssjh, hjxh,	cfxh, czyh, lrrq, patid, hzxm, ybdm, py, wb, ysdm, ksdm,
    	yfdm, qrczyh, qrrq, qrksdm, pyczyh, pyrq, cfts, txh, sfckdm, pyckdm, fyckdm,
    	jsbz, jlzt, fybz, cflx, sycfbz, tscfbz, pybz, jcxh, memo,zje,zfyje,yhje,zfje,srje,fph,fpjxh,tfbz,tfje,
		fyckxh, sqdxh	-- add by gzy at 20050530
		,ejygbz, ejygksdm,xzks_id,ylxzbh,tmhdbz	--add by ozb 20060320 ���Ӷ���ҩ��Ĵ���
		,ghxh,wsbz,wsts,cftszddm,cftszdmc,yscfbz  --add by yfq @20120528
		into #mzcf_old from SF_NMZCFK where 1=2

	select xh, cfxh, cd_idm, gg_idm, dxmdm,	ypmc, ypdm, ypgg, ypdw, dwxs, ykxs,
    	ypfj, ylsj, ypsl, ts, cfts, zfdj, yhdj, memo, flzfdj, hjmxxh,
		gbfwje, gbfwwje, gbtsbz
		,fpzh			--add fpzh by ozb 20060602 ���ӷ�Ʊ���
		,lcxmdm, lcxmmc,lcxmsl,dydm,yjqrbz,zbz,lcjsdj,yjspbz --add "dydm" 20070119
     ,qrczyh,qrksdm,ssbfybz   -- add by sqf 20110323
		,zje,tmxxh,shbz,yqrsl,ktsl,wsbz,ldcfxh,ldmxxh,tfbz,0 gjybz,convert(money,0) gjydeje  --@#$
		into #cfmx_old from SF_NCFMXK where 1=2
    
	--ԭ������ϸ
	insert into #mzcf_old 
	select xh, jssjh, hjxh,	cfxh, czyh, lrrq, patid, hzxm, ybdm, py, wb, ysdm, ksdm,
    	yfdm, qrczyh, qrrq, qrksdm, pyczyh, pyrq, cfts, txh, sfckdm, pyckdm, fyckdm,
    	jsbz, jlzt, fybz, cflx, sycfbz, tscfbz, pybz, jcxh, memo,zje,zfyje,yhje,zfje,srje,fph,fpjxh,0,0,
		fyckxh, sqdxh	-- add by gzy at 20050530
		, isnull(ejygbz,0), isnull(ejygksdm,""),xzks_id,ylxzbh,tmhdbz	--add by ozb 20060320 ���Ӷ���ҩ��Ĵ���
		,ghxh,isnull(wsbz,0),isnull(wsts,0),cftszddm,cftszdmc,yscfbz --add by yfq @20120528
		from VW_MZCFK where jssjh=@sjh and jlzt=0 and jsbz=1
	if @@rowcount=0 or @@error<>0
	begin
		select "F","û����Ч�Ĵ�����Ϣ��"
		return
	end   
	insert into #cfmx_old 
	select xh, cfxh, cd_idm, gg_idm, dxmdm,	ypmc, ypdm, ypgg, ypdw, dwxs, ykxs,
    	ypfj, ylsj, ypsl, ts, cfts, zfdj, yhdj, memo, flzfdj, hjmxxh,
		gbfwje, gbfwwje, gbtsbz
		,fpzh			--add by ozb 20060602 ���ӷ�Ʊ���
		, lcxmdm, lcxmmc,lcxmsl,dydm,yjqrbz,zbz,lcjsdj,yjspbz --add "dydm" 20070119
        ,qrczyh,qrksdm,ssbfybz,zje,tmxxh,shbz,yqrsl,ktsl,isnull(wsbz,0),ldcfxh,ldmxxh,tfbz,0,0  --@#$ 
		from VW_MZCFMXK where cfxh in (select xh from #mzcf_old)
	if @@rowcount=0 or @@error<>0
	begin
		select "F","û����Ч�Ĵ�����Ϣ��"
		return
	end 
	--������Ŀ������У��
	declare @sqdxh	ut_xh12
	if exists(select 1 from YY_CONFIG nolock where id='0392' and config='��')
	begin
		select a.sqdxh,a.xh as cfxh,b.xh as mxxh,b.ypsl*b.dwxs as ypsl,isnull(d.cfts*d.tysl,0) as tysl,
			dbo.fun_yy_getsqddzbz(0,a.patid,0,0,a.sqdxh,a.ybdm) as dzbz,b.lcxmdm as lcxmdm,
			a.hjxh,b.hjmxxh
		into #tfmx_tf_sqd
		from #mzcf_old a(nolock)
			inner join #cfmx_old b(nolock) on a.xh=b.cfxh
			inner join VW_MZHJCFMXK c(nolock) on b.hjmxxh = c.xh
			left join #cfmx_tf d on b.xh=d.mxxh and a.xh=d.cfxh
		where isnull(c.sfms,0)=1 and b.hjmxxh is not null and b.hjmxxh>0
			and a.sqdxh is not null and a.sqdxh > 0
		
		declare m_cursor_sqd cursor scroll for
		select distinct sqdxh from  #tfmx_tf_sqd
		where tysl>0

		open m_cursor_sqd
		 
		fetch next from m_cursor_sqd into @sqdxh
		while @@FETCH_STATUS=0
		begin
			if exists(select 1 from #tfmx_tf_sqd where sqdxh=@sqdxh and ypsl<>tysl and dzbz=1)
			begin
				select 'F','������Ŀ���ɲ����˷�!'
				close m_cursor_sqd
				deallocate m_cursor_sqd
				return
			end
			select * from SF_HJCFMXSFK a(nolock) ,#tfmx_tf_sqd b
				where a.patid=@patid and a.sqdxh=@sqdxh and a.cfxh=b.hjxh and a.cfmxxh=b.hjmxxh and a.sqdxh=b.sqdxh
					and b.ypsl<>b.tysl and b.dzbz=0
					
			if exists(select 1 from SF_HJCFMXSFK a(nolock) ,#tfmx_tf_sqd b
				where a.patid=@patid and a.sqdxh=@sqdxh and a.cfxh=b.hjxh and a.cfmxxh=b.hjmxxh and a.sqdxh=b.sqdxh
					and b.ypsl<>b.tysl and b.dzbz=0)
			begin
				select 'F','�ٴ���Ŀ�ڲ����ɲ����˷�!'
				close m_cursor_sqd
				deallocate m_cursor_sqd
				return
			end
			fetch next from m_cursor_sqd into @sqdxh
		end
		 
		close m_cursor_sqd
		deallocate m_cursor_sqd
		
		drop table #tfmx_tf_sqd
	end
	--����һ���´����е�dydm
	update a set dydm=b.dydm
	from #cfmx_old a,YY_SFXXMK b(nolock)
	where a.cd_idm=0 and a.ypdm=b.id	
	if @@error<>0
	begin
	    select 'F','���´�����ϸ��Ӧ�������!'
	    return
	end
	update a set dydm=b.dydm
	from #cfmx_old a,YK_YPCDMLK b(nolock)
	where a.cd_idm>0 and a.cd_idm=b.idm	
	if @@error<>0
	begin
	    select 'F','���´�����ϸ��Ӧ�������!'
	    return
	end
	select * into #cfmx_old_fz from SF_CFMXK_FZ where cfxh in (select xh from #mzcf_old) --add by wangmiao
	select * into #mzcf_old_fz from VW_MZCFK_FZ where jssjh=@sjh
	if @@error<>0--update by winning-dingsong-chongqing with @@rowcount>>@@error
	begin
	    select 'F','��ѯ�����⸨�������!'
	    return
	end
	select distinct cfxh, cfts into #mzcf_tf from #cfmx_tf
	--�õ��˷Ѻ�ʣ�µĴ�������ϸ
	select * into #mzcf_new from #mzcf_old
	select * into #cfmx_new from #cfmx_old
	select * into #cfmx_new_fz from #cfmx_old_fz -- add by wangmiao
	if exists(select 1 from YY_CONFIG where id='3115' and config='��')
	begin
		update #cfmx_new set cfts=a.cfts-(case when a.cfts>1 and a.ypsl=b.tysl*a.dwxs then b.cfts when a.cfts>1 and a.ypsl<>b.tysl*a.dwxs then 0 else 0 end),
				ypsl=a.ypsl-(case when a.cfts>1 and a.ypsl=b.tysl*a.dwxs then 0 when a.cfts>1 and a.ypsl<>b.tysl*dwxs then b.tysl*a.dwxs  else b.tysl*a.dwxs end),
				ktsl=case when a.ktsl>0 then 
					 a.ktsl-(case when a.cfts>1 and a.ypsl=b.tysl*a.dwxs then 0 when a.cfts>1 and a.ypsl<>b.tysl*dwxs then b.tysl*a.dwxs  else b.tysl*a.dwxs end)
					 else 0 end
		from #cfmx_new a, #cfmx_tf b
		where a.xh=b.mxxh
		if @@error<>0
		begin
			select "F","��ѯ�˷Ѵ�����ϸ����"
			return
		end
	end
	else begin
		update #cfmx_new set cfts=a.cfts-(case when a.cfts>1 then b.cfts else 0 end),
			ypsl=a.ypsl-(case when a.cfts>1 then 0 else b.tysl*a.dwxs end),
			ktsl=case when a.ktsl>0 then 
					 a.ktsl-(case when a.cfts>1 and a.ypsl=b.tysl*a.dwxs then 0 when a.cfts>1 and a.ypsl<>b.tysl*dwxs then b.tysl*a.dwxs  else b.tysl*a.dwxs end)
					 else 0 end
		from #cfmx_new a, #cfmx_tf b
		where a.xh=b.mxxh
		if @@error<>0
		begin
			select "F","��ѯ�˷Ѵ�����ϸ����"
			return
		end
	end

	update b set b.cfts = a.cfts from #cfmx_new a,#mzcf_new b where a.cfxh = b.xh

	delete #cfmx_new_fz where cfxh in (select cfxh from #cfmx_new where cfts=0 or ypsl=0) -- add by wangmiao
	delete #cfmx_new where cfts=0 or ypsl=0
	delete #mzcf_new where not exists(select 1 from #cfmx_new b where #mzcf_new.xh=b.cfxh)
	--�ж�δ�������Ƿ����С��0�����������������ԭ����ʱ��
	if exists(select 1 from #cfmx_new where ypsl<0)
	begin
		select 'F','�����˷���������ȷ�����������ܴ���ԭ����!'
	    return
	end
	--������͵Ĵ���,�������������˷�
	if @config3291='��' and exists (select 1 from #cfmx_old where isnull(wsbz,0)=1)
	begin
	    if exists (select 1 from #cfmx_old a,#mzcf_new b where a.xh=b.xh and isnull(a.wsbz,0)=1)
	    begin
	        select 'F','�˷Ѵ�����������ҩƷ,���ܲ����˷�!'
	        return
	    end
	end

	--����ҽ�����ϷѲ����˷ѵ���ϸ
	if exists(select 1 from YY_CONFIG where id='2291' and config='��') --ֻ�нӿ�ģʽʱ����
		and exists(select 1 from SF_CFMXK_FZ a(nolock),#cfmx_tf b where a.mxxh=b.mxxh and a.yjclfbz=1)
	begin
		--������δ�˵�����Ŀ
		if exists(select 1 from SF_CFMXK_FZ a(nolock),#cfmx_new b where a.mxxh=b.xh and yjclfbz=0 and b.cd_idm=0)
		begin
			select @errmsg=''
			select @errmsg=@errmsg+c.ypmc+',' from SF_CFMXK_FZ a(nolock),#cfmx_tf b,#cfmx_old c 
				where a.mxxh=b.mxxh and yjclfbz=1 and a.mxxh=c.xh and c.cd_idm=0
			select 'F','ҽ�����Ϸ�['+@errmsg+']�����˷�'
			return
		end
	end
	--ͨ����������δ�����˷���������Ŀ�����˷�
	if	exists(select 1 from YY_CONFIG where id='2356' and config='��')	
	begin
		if exists(select 1 from VW_MZCFMXK_FZ a(nolock),#cfmx_tf b where a.mxxh=b.mxxh and isnull(a.tfspbz,0)=0)
		begin
			select @errmsg=''
			select @errmsg=@errmsg+c.ypmc+',' from VW_MZCFMXK_FZ a(nolock),#cfmx_tf b,#cfmx_old c 
				where a.mxxh=b.mxxh and isnull(a.tfspbz,0)=0 and a.mxxh=c.xh
			select 'F','['+@errmsg+']δ���������������˷�'
			return
		end
	end
	
	--ͨ����������ҽ��ԤԼ��Ŀ�Ƿ������˷�
	if	exists(select 1 from YY_CONFIG where id='2462' and config='��')	
	begin
		if exists(select 1 from VW_MZCFMXK a(nolock),#cfmx_tf b where a.xh=b.mxxh and isnull(a.yyzt,0)=1)
		begin
			select @errmsg=''
			select @errmsg=@errmsg+c.ypmc+',' from VW_MZCFMXK a(nolock),#cfmx_tf b,#cfmx_old c 
				where a.xh=b.mxxh and isnull(a.yyzt,0)=1 and a.xh=c.xh
			select 'F','�Ѿ�ԤԼ��ҽ����Ŀ['+@errmsg+']�����˷�,��ȡ��ԤԼ���˷�'
			return
		end
	end
	------------------------------- 
	--���˷ѱ�־ qxh 2003.5.27
	if @acfdfp=1 
	begin
		--jjw 2003-12-22 modify bug:һ�����������ĳ��ҩֻ��һ��������Դ�ӡ�������ȫ�������ҩ��������Ͳ������
		--update #mzcf_new set tfbz=1 where xh in (select cfxh from #cfmx_new a  where xh in (select mxxh from  #cfmx_tf where mxxh=a.xh and tysl>0))
--		update #mzcf_new set tfbz=1 where xh in 
--		(select cfxh from #cfmx_new a  where xh in (select mxxh from  #cfmx_tf where cfxh=a.cfxh and tysl>0))
		--by ydj 2004-11-04
		update #mzcf_new set tfbz=1 where xh  in (select cfxh from #cfmx_tf)
		--��ҩ�����ϲ�ʱ��ֻ��δ�˷ѵĴ���������Ҫ���´�ӡ
		--����ͬ��Ʊ�õĴ�����ͬʱ�����˷ѱ�־
		if (@acfdfp_dyfs<>'0')
		begin
			select a.fph,b.xh,0 as tfbz into #mzcf_new_temp from SF_MZCFK a,#mzcf_new b where a.xh=b.xh
			select a.fph,b.cfxh into #cfmx_tf_temp from SF_MZCFK a,#cfmx_tf b where a.xh=b.cfxh
			update #mzcf_new_temp set tfbz=1 where fph in (select fph from #cfmx_tf_temp)
			update a set a.tfbz=b.tfbz from #mzcf_new a,#mzcf_new_temp b where a.xh=b.xh
		end 
		/*
		if (@acfdfp_cflx=1) 
			and exists(select 1 from #mzcf_new where cflx=1)	--����δ�˵���ҩ���� 
			and exists(select 1 from #mzcf_tf a,#mzcf_old b where a.cfxh=b.xh and b.cflx=1)	--�������˵���ҩ����
		begin
			update #mzcf_new set tfbz=1 where cflx=1
		end
		*/
	end

	--���ʲô��ûʣ�£�˵����ȫ���˷�,��ʱ#cfmx_new��#mzcf_new ʣ����Ҫ������ȡ�ĵĴ�����ϸ
	if not exists(select 1 from #mzcf_new)
		select @qtbz=1
	else
		select @qtbz=0
	
	if @qtbz=0
	begin
		if exists(select 1 from #cfmx_new where isnull(lcxmdm,'0')<>'0')
		begin		
			update #cfmx_new set lcxmsl=a.ypsl/b.xmsl
				from #cfmx_new a,YY_LCSFXMDYK b
				where a.lcxmdm=b.lcxmdm and a.ypdm=b.xmdm
			--�����ٴ���Ŀ����,bug54034
			update a set a.lcxmsl=a.ypsl/(b.ypsl/b.lcxmsl) 
			from #cfmx_new a,#cfmx_old b 
			where a.xh=b.xh and isnull(a.lcxmdm,'0')<>'0' and isnull(b.lcxmdm,'0')<>'0' and b.ypsl/b.lcxmsl>0 
		end
	end
	   
--cjt
	------���Ʒ����˷Ѳ��������˷�  ���ж������ɵ�������û�У����ж��˷�������û��
	if   exists(select 1 from #cfmx_new a ,VW_MZHJCFMXK b(nolock) where a.hjmxxh=b.xh and b.sjzlfabdxh<>0) 
	begin
		if 	exists(select 1 from #cfmx_tf a ,VW_MZCFMXK b(nolock) ,VW_MZHJCFMXK c(nolock) where a.mxxh=b.xh and b.hjmxxh=c.xh and c.sjzlfabdxh<>0)
		begin
			
			declare @zlfamxmc_tmp varchar(80),@zlfamxmc varchar(8000)  
			select @zlfamxmc='',@zlfamxmc_tmp=''
			--�����е����Ʒ�����ϸ��ʾ��ǰ̨
			declare cs_sftf_zlfa cursor for
			select ypmc from VW_MZHJCFMXK (nolock) where cfxh in (select hjxh from #mzcf_old) and sjzlfabdxh<>0
			for read only 
			open cs_sftf_zlfa
			fetch cs_sftf_zlfa into @zlfamxmc_tmp
			while @@fetch_status=0
			begin 
				if @zlfamxmc='' 
				begin
					select @zlfamxmc=@zlfamxmc_tmp  
				end
				else
				begin
					select @zlfamxmc=@zlfamxmc+':' +@zlfamxmc_tmp  
				end
				fetch cs_sftf_zlfa into @zlfamxmc_tmp
			end
			close cs_sftf_zlfa
			deallocate cs_sftf_zlfa


			select  "F", '�����а�����'+@zlfamxmc+'�����Ʒ�����ϸ����ȫ�ˣ����Ʒ�����ϸ���������˷ѣ�'  
			return
		end
	end 
----------------- 

	select sjh, patid, ghsjh, ghxh, fph, fpjxh, czyh, sfrq, sfksdm, ksdm, hzxm, blh, ybdm, pzh, 
		sfzh, ylxm, zddm, dnzhye, lnzhye, dwbm, brlx, zje, zfyje, yhje, deje, zfje, zpje, zph, 
		xjje, srje, qkbz, qkje, zxlsh, jslsh, ybjszt, zhbz, tsjh, jlzt, cardno, cardtype, ghsfbz, 
		mjzbz, jcxh, memo 
		,ylkje,ylkysje	--mit ,, 2oo3-o5-14 ,, ��ҽͨ
		,flzfje			--zwj 2003.08.19 �����Էѽ��
		,qrbz,qrczyh,qrrq,tcljje,tcljbz,0 ljje,yflsh,tsyhje,spzlx
		,gbje, gbbz, gbtsbz,gbfwwje,bdyhkje,bdyhklsh,lcyhje,hzdybz
		,yhdm,appjkdm,syldyhbz,syldyhje --add by yjn 2015-03-21
		into #brjsk from SF_BRJSK where 1=2
	if @tslc = 0
	begin
		insert into #brjsk 
		select a.sjh, a.patid, a.ghsjh, a.ghxh, a.fph, a.fpjxh, a.czyh, a.sfrq, a.sfksdm, a.ksdm, a.hzxm, a.blh, a.ybdm, a.pzh, 
			a.sfzh, a.ylxm, a.zddm, a.dnzhye, a.lnzhye, a.dwbm, a.brlx, a.zje, a.zfyje, a.yhje, a.deje, a.zfje, a.zpje, a.zph, 
			a.xjje, a.srje, a.qkbz, a.qkje, a.zxlsh, a.jslsh, a.ybjszt, a.zhbz, a.tsjh, a.jlzt, b.cardno, b.cardtype, a.ghsfbz, 
			a.mjzbz, a.jcxh, a.memo 
			,a.ylkje,a.ylkysje	--mit ,, 2oo3-o5-14 ,, ��ҽͨ
			,a.flzfje,a.qrbz,a.qrczyh,a.qrrq,a.tcljje,a.tcljbz,b.ljje,a.yflsh,tsyhje,b.spzlx
			,gbje, gbbz, gbtsbz,gbfwwje,bdyhkje,bdyhklsh,a.lcyhje,a.hzdybz
			,a.yhdm,a.appjkdm,syldyhbz,syldyhje --add by yjn 2015-03-21
			from VW_MZBRJSK a (nolock),SF_BRXXK b (nolock) where a.sjh=@sjh and a.patid=b.patid
		if @@error<>0 or @@rowcount=0
		begin
			select "F","���������¼�����ڣ�"
			return
		end
	end
	else
	begin
		insert into #brjsk 
		select a.sjh, a.patid, a.ghsjh, a.ghxh, a.fph, a.fpjxh, a.czyh, a.sfrq, a.sfksdm, a.ksdm, a.hzxm, a.blh, a.ybdm, a.pzh, 
			a.sfzh, a.ylxm, a.zddm, a.dnzhye, a.lnzhye, a.dwbm, a.brlx, a.zje, a.zfyje, a.yhje, a.deje, a.zfje-a.srje, a.zpje, a.zph, 
			a.xjje-a.srje+a.qkje,0, 0, 0, a.zxlsh, a.jslsh, a.ybjszt, a.zhbz, a.tsjh, a.jlzt, b.cardno, b.cardtype, a.ghsfbz, 
			a.mjzbz, a.jcxh, a.memo 
			,a.ylkje,a.ylkysje	--mit ,, 2oo3-o5-14 ,, ��ҽͨ
			,a.flzfje,a.qrbz,a.qrczyh,a.qrrq,a.tcljje,a.tcljbz,b.ljje,a.yflsh,tsyhje,b.spzlx
			,gbje, gbbz, gbtsbz,gbfwwje,bdyhkje,bdyhklsh,a.lcyhje,a.hzdybz
			,a.yhdm,a.appjkdm,syldyhbz,syldyhje --add by yjn 2015-03-21
			from VW_MZBRJSK a (nolock),SF_BRXXK b (nolock) where a.sjh=@sjh and a.patid=b.patid
		if @@error<>0 or @@rowcount=0
		begin
			select "F","���������¼�����ڣ�"
			return
		end
		select @qkje_ts = xjje from #brjsk
		select @srbz=config from YY_CONFIG (nolock) where id='2016'
		if @@error<>0 or @@rowcount=0
			select @srbz='0'
		--��Ҫ���봦��liuchun��bug6369
		/*С�����봦�� begin*/
		if @srbz='5'
			select @qkje_ts1=round(@qkje_ts, 1)
		else if @srbz='6'
			exec usp_yy_wslr @qkje_ts,1,@qkje_ts1 output
		else if @srbz>='1' and @srbz<='9'
			exec usp_yy_wslr @qkje_ts,1,@qkje_ts1 output,@srbz
		else
			select @qkje_ts1=@qkje_ts

		select @srje=@qkje_ts1-@qkje_ts
		/*С�����봦�� begin*/
		update #brjsk set xjje = @qkje_ts1,srje = @srje,zfje = zfje + @srje
	end
	
	-----add by sqf 20090602 begin	һ�ŷ�Ʊ�Ƿ��������˷�
	if  @isbftfall=1 and exists(select 1 from #brjsk where sjh=@sjh and isnull(fph,0)<>0)---����������
	begin 
		if @acfdfp=1 and @configdyms=0 --����ǰ�������ӡ�ģ���ÿһ�Ŵ�������һ�ŷ�Ʊ����cfxh��У���Ƿ���ȫ��
		begin
			select cfxh,sum(1) cfsl  into #temp_cfmxnew1 from #cfmx_new group by cfxh      
			select cfxh,sum(1) cfsl  into #temp_cfmxold1 from #cfmx_old where cfxh in (select cfxh from #cfmx_new) group by cfxh      

			select cfxh,xh,ypsl into #temp_cfmxnew from #cfmx_new       
			select cfxh,xh ,ypsl into #temp_cfmxold from #cfmx_old 
			where cfxh in (select cfxh from #cfmx_new)       

			if not  exists (select 1 from #temp_cfmxnew a,#temp_cfmxold b where a.cfxh=b.cfxh and a.xh=b.xh and a.ypsl<>b.ypsl)      
			and  not exists (select 1 from #temp_cfmxnew1 a,#temp_cfmxold1 b where a.cfxh=b.cfxh and a.cfsl<>b.cfsl )      
				select @qtbz_cf=1          
			else          
				select @qtbz_cf=0       

			if @qtbz_cf=0     
			begin    
				select 'F','���������˷ѣ����������������˷�'    
				return    
			end 
		end
		else---�����������������վݾ���һ�ŷ�Ʊ�ţ�ֻҪ��Ҫ�ж��ǲ���ȫ�˾Ϳ�����
		begin
			--�Ϸ�Ʊģʽʱ
			if @configdyms=0
			begin
				if not exists(select 1 from #mzcf_new)
					select @qtbz=1
				else
					select @qtbz=0    
				       
				if @qtbz=0     
				begin    
					select 'F','���������˷ѣ����������������˷�'    
					return    
				end                    
			end
			else if @configdyms=1  --�·�Ʊģʽ
			begin
				--��ʣ��Ĵ�����ϸ���淢Ʊ����Ƿ�һ��
				select fpzh,sum(round(ylsj*ypsl*ts*cfts/ykxs,2)) as zje into #temp_fpzh from #cfmx_new group by fpzh
				if exists(select 1 from VW_SFFPMXDYK a,#temp_fpzh b where a.jssjh=@sjh and a.zh=b.fpzh and round(a.zje,2)<>b.zje)
				begin
					select 'F','ͬһ�ŷ�Ʊ���������˷ѣ����������������˷�'    
					return 
				end
			end
		end
			
	end  
		
	select @ylkysje = ylkysje, @posfph=zph, @patid = patid,@ybdm=ybdm, @qkbz=qkbz, @qkje1=qkje, @tcljje=ljje-(zje-zfyje),
	  @tcljje1=ljje-(zje-zfyje),@tcljbz=tcljbz,@sfrq=sfrq,@bdyhkje = bdyhkje,@xjje=xjje,@qrbz=qrbz,
	  @qrbznew=case qrbz when 1 then 1 else 0 end,
	  @zpje=zpje,@zph=zph
	from #brjsk	-- modify by gzy in 20050501
	--����ǰ�����������ȡ�˻�֧��
	if @qkbz = 1 
		select @qkje1 = isnull(je,0) from SF_JEMXK where jssjh = @sjh and lx = '01'
	--����Ǻ󸶷�ģʽʱ�������δ�ɷѵļ�¼���������˷� by xxl 2012-05-06
	if exists(select 1 from YY_CONFIG where id='H233' and charindex(','+rtrim(ltrim(@ybdm))+',',','+config+',')>0)
	begin
		if (@xjje>0) and (@qrbz in(1,3))
		begin
			select "F","�󸶷�ģʽʱ����ǰ�����¼��δ�ɷѣ��������˷ѣ�"
			return
		end
	end
    --�Ż�����ģʽ��ͬʱʹ�þ��￨�ʹ��ҿ�ʱ��֧�ֲ����˷�
    if (@qkbz=3) and exists(select 1 from SF_CARDZFJEK where jssjh=@sjh and lx='4') and (@qtbz=0)
    begin
    	select "F","ͬʱʹ�þ��￨�ʹ��ҿ�ʱ��֧�ֲ����˷�,��ȫ�˺�������ȡδ�˷Ѳ��֣�"
		return
    end
	--�ѹ�ʧ�����˷�
	if (@qkbz=3) and (@qkje1>0) and exists(select 1 from YY_JZBRK where patid=@patid and jlzt=0 and gsbz=1)
	begin
    	select "F","��ֵ���ѹ�ʧ,�����˷ѣ�"
		return
	end
	select @zfbz=zfbz, @pzlx=pzlx, @jsfs=jsfs, @hysybz=hysybz from YY_YBFLK where ybdm=@ybdm
	if @@rowcount=0 or @@error<>0
	begin
		select "F","���߷��������ȷ��"
		return
	end

	select @hykmsbz = config from YY_CONFIG where id='0099'
	if @@error<>0
	begin
		select "F","�����Ա��ģʽ���ò���ȷ��"
		return
	end
/*
	if @hykmsbz=1
	begin
		if @hysybz=1 and @qtbz=0
		begin
			select "F","��Ա��ģʽ��ֻ��ȫ�ˣ�"
			return
		end
	end
*/
	if exists(select ybdm from YY_YBFLK nolock where ybdm = @ybdm and lcyhbz = 1)
		select @yplcjs2169 = '��'
	else 
		select @yplcjs2169 = '��'
	--�����վݺ�
	exec usp_yy_createsjh 'SF_BRJSK','sjh','czyh',@czyh,@errmsg output
	if @errmsg like 'F%'
	begin
		select "F",substring(@errmsg,2,49)
		return
	end
	else
		select @newsjh=rtrim(substring(@errmsg,2,32))

	if exists(select 1 from SF_BRJSK where tsjh=@sjh and ybjszt=2)
		select @tfbz=1
	else begin
		select @newsjh1=@newsjh
		exec usp_yy_getnextsjh @newsjh1, @newsjh output
	end

	--add by zyh 20100223
	if exists(select * from YY_CONFIG where id='2181' and config='��') and @postffs>0 and @zph='7'
	begin
		select @ntfts=datediff(day,left(sfrq,8),left(@now,8)) from #brjsk

		if @postffs=1
			select @zffs=1
		if @postffs=2
			select @zffs=0
		if @postffs=3 and @ntfts=0
			select @zffs=1
		if @postffs=3 and @ntfts>0
			select @zffs=0
	    if @postffs=4  --����sjh�Ų�����Ա���˵����в�ѯ�ý����¼�Ƿ��Ѿ�����,���������������˷ѷ�ʽ.
	    begin
	        select @yczyh=czyh,@ysfrq=sfrq from SF_BRJSK(nolock) where sjh=@sjh  --����˷�������¼�Ĳ���Ա�ź��շ�����
	        --����������Ա������������  
	        if exists( select 1 from SF_CZRYRZD(nolock) where czyh=@yczyh and jzbz>=1)
	        begin
	            select top 1 @zdgrjzsj=grjzsj from SF_CZRYRZD(nolock) where czyh=@yczyh and jzbz>=1 order by xh desc 	            
	            if @ysfrq>@zdgrjzsj 
	                select @zffs=1 
	            else 
	                select @zffs=0  --�շ����ڴ������������ڱ�ʾû�н���,��pos���˷� ��֮��ʾ���� ��pos���ֽ��˷�
            end
            else  
	            select @zffs=1  --�ò���Աһֱû�н��� ��pos���˷�
	    end 			
	end
  
	--ȫ�˲�����
	if @qtbz=0
	begin
		--{TODO -oyfq -c2016-12 : ҽ���߼�ҩ���߸��� as @#$ begin}
		--ִ�и߼�ҩ����
		if @config2451='��' and dbo.fun_judgeybdm4gjy(0,@ybdm,@xmlb,@zhbz)='TF'
		begin
		    /**
			if exists (select 1 from sysobjects(nolock) where id=object_id('YB_SH_YBDYK'))
			begin
				update a set dydm=b.dydm 
				from #cfmx_new a,YB_SH_YBDYK b(nolock)
				where a.cd_idm=0 and a.ypdm=b.xmdm and b.jlzt=1 and @now between b.qyrq+'00:00:00' and b.yxqx+'23:59:59'
				update a set dydm=b.dydm 
				from #cfmx_new a,YB_SH_YBDYK b(nolock)
				where a.cd_idm>0 and a.cd_idm=b.idm and b.jlzt=1 and @now between b.qyrq+'00:00:00' and b.yxqx+'23:59:59'
			end
			**/
			update a set gjybz=1,gjydeje=isnull(b.zfdeje,0)
			from #cfmx_new a,YY_YBYPK b(nolock)
			where a.dydm=b.mc_code and isnull(b.tsbz,0)<>0 and @now between b.ksrq+'00:00:00' and b.jzrq+'23:59:59'
			--�и߼�ҩ,��������߼�ҩ�Ը����
			if exists (select 1 from #cfmx_new where gjybz=1)
			begin
				select @gjybz=1
				select @gjyzje=isnull(sum(round(ypsl*ylsj*cfts/ykxs,2)),0),
					@gjyzfje=isnull(sum(round(ypsl*gjydeje*cfts/ykxs,2)),0)
				from #cfmx_new where cd_idm>0 and gjybz=1
				select @gjyzje1=isnull(sum(round(ypsl*ylsj*cfts/ykxs,2)),0),
					@gjyzfje1=isnull(sum(round(ypsl*gjydeje*cfts/ykxs,2)),0)
				from #cfmx_new where cd_idm=0 and gjybz=1
			end
			else
				select @gjybz=0
		end
		--{TODO -oyfq -c2016-12 : ҽ���߼�ҩ���߸��� as @#$ end}
		--ͳ����������õ�ҽ������
		if exists(select 1 from YY_CONFIG (nolock) where charindex('"'+rtrim(@ybdm)+'"',config)>0 and id='0115')
		begin
			select @tcljje1=tcljje from YY_BRLJXXK nolock where mzpatid = @patid
		end		

	    --add by qxh 2003.5.27 
		if @acfdfp=1 
		begin
			--�����շѷ���
			select @zje=isnull(sum(round(ypsl*ylsj*cfts/ykxs,2)),0),
				@zfyje=isnull(sum(round(ypsl*zfdj*cfts/ykxs,2)),0),
				@yhje=isnull(sum(round(ypsl*yhdj*cfts/ykxs,2)),0)
				--from #cfmx_old where cd_idm>0 jjw 2004-01-06 modify �������˷Ѽ�¼���´���
				from #cfmx_new where cd_idm>0 
                and cfxh in (select distinct cfxh from #cfmx_tf) --jjw 2004-01-06 modify �������˷Ѽ�¼���´����Ų������¼���
			if isnull(@yplcjs2169,'') = '��'
			begin
				select 	@zje=isnull(sum(round(ypsl*ylsj*cfts/ykxs,2)),0),
						@zfyje=isnull(sum(round(ypsl*zfdj*cfts/ykxs,2)),0),
						@yhje= isnull(sum(case when lcjsdj <>0 and yhdj = ylsj - lcjsdj then round(ypsl*ylsj*cfts/ykxs,2) - round(ypsl*lcjsdj*cfts/ykxs,2)
								else round(ypsl*yhdj*cfts/ykxs,2) end),0),
						@lcyhje = isnull(sum( case when lcjsdj <>0  then round(ypsl*ylsj*cfts/ykxs,2) - round(ypsl*lcjsdj*cfts/ykxs,2) else 0 end ),0)
					from #cfmx_new where cd_idm>0
	                and cfxh in (select distinct cfxh from #cfmx_tf) 
			end
			select @zje1=isnull(sum(round(ypsl*ylsj*cfts/ykxs,2)),0),
				@zfyje1=isnull(sum(round(ypsl*zfdj*cfts/ykxs,2)),0),
				@yhje1=isnull(sum(round(ypsl*yhdj*cfts/ykxs,2)),0)
				--from #cfmx_old where cd_idm=0 jjw 2004-01-06 modify
				from #cfmx_new where cd_idm=0
                and cfxh in (select distinct cfxh from #cfmx_tf) --jjw 2004-01-06 modify �������˷Ѽ�¼���´����Ų������¼���
	        if @gjybz=1  --@#$
			    select @ybje=@zje-@zfyje-@yhje-@gjyzje,@ybje1=@zje1-@zfyje1-@yhje1-@gjyzje1
			else
			select @ybje=@zje-@zfyje-@yhje, @ybje1=@zje1-@zfyje1-@yhje1
	
			--ȡ��ʵ�ս��
			if @pzlx not in (10,11)
			begin
				--ҩƷ������
				execute usp_yy_ybjs @ybdm,0,@ybje,0,@errmsg output
				if @errmsg like "F%"
				begin
					select "F",substring(@errmsg,2,49)
					return
				end
				else
					select @sfje=convert(numeric(10,2),substring(@errmsg,2,11))
	
				execute usp_yy_ybjs @ybdm,0,0,@ybje1,@errmsg output
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
				begin	
					select @xmzfbltf=(@sfje+@zfyje)/@ybje
					select @xmzfbl=@sfje/@ybje
				end
	
				if @ybje1>0
				begin
					select @xmzfbltf1=(@sfje1+@zfyje1)/@ybje1
					select @xmzfbl1=@sfje1/@ybje1
				end
	
				select @sfje_all=@sfje+@sfje1+@zfyje+@zfyje1
				select @srbz=config from YY_CONFIG (nolock) where id='2016'
				if @@error<>0 or @@rowcount=0
					select @srbz='0'
				if @srfs = '1' and @qkbz in(3)---��1����ȷ����
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
	
				/*
				if @qkbz in(1,3)
				begin
					if @qkje1>@sfje2
						select @qkje=@sfje2
					else
						select @qkje=@qkje1
	
					select @qkje1=@qkje1-@qkje
				end
				else if @qkbz=2
					select @qkje=@sfje2
				*/
			end

			/*jjw 2003-01-06 modify
			update 	#mzcf_old  set  tfje=b.tfje 
				from    #mzcf_old a ,(select c.cfxh, 
		   	        isnull(round(sum(round((c.ylsj-c.zfdj-c.yhdj)*d.tysl*c.dwxs*d.cfts*(case when c.cd_idm>0 then @xmzfbltf else @xmzfbltf1 end)/c.ykxs,2)),2),0) as tfje
	        		from  #cfmx_old c,#cfmx_tf d where c.xh=d.mxxh group by c.cfxh ) b
				where a.xh=b.cfxh  
			*/
		end	

		if charindex('"'+@ybdm+'",',@bkybdmjh)>0
			update #cfmx_new set flzfdj=0

		--�����շѷ���
		select @zje=isnull(sum(round(ypsl*ylsj*cfts/ykxs,2)),0),
			@zfyje=isnull(sum(round(ypsl*zfdj*cfts/ykxs,2)),0),
			@yhje=isnull(sum(round(ypsl*yhdj*cfts/ykxs,2)),0),
			@flzfje=isnull(sum(round(ypsl*flzfdj*cfts/ykxs,2)),0)
			from #cfmx_new where cd_idm>0
		if isnull(@yplcjs2169,'') = '��'
		begin
			select 	@zje=isnull(sum(round(ypsl*ylsj*cfts/ykxs,2)),0),
					@zfyje=isnull(sum(round(ypsl*zfdj*cfts/ykxs,2)),0),
					@yhje= isnull(sum(case when lcjsdj <>0 and yhdj = ylsj - lcjsdj then round(ypsl*ylsj*cfts/ykxs,2) - round(ypsl*lcjsdj*cfts/ykxs,2)
							else round(ypsl*yhdj*cfts/ykxs,2) end),0),
					@lcyhje = isnull(sum( case when lcjsdj <>0  then round(ypsl*ylsj*cfts/ykxs,2) - round(ypsl*lcjsdj*cfts/ykxs,2) else 0 end ),0)
				from #cfmx_new where cd_idm>0
		end
		select @zje1=isnull(sum(round(ypsl*ylsj*cfts/ykxs,2)),0),
			@zfyje1=isnull(sum(round(ypsl*zfdj*cfts/ykxs,2)),0),
			@yhje1=isnull(sum(round(ypsl*yhdj*cfts/ykxs,2)),0),
			@flzfje1=isnull(sum(round(ypsl*flzfdj*cfts/ykxs,2)),0)
			from #cfmx_new where cd_idm=0
        if @gjybz=1  --@#$
            select @ybje=@zje-@zfyje-@yhje-@gjyzje,@ybje1=@zje1-@zfyje1-@yhje1-@gjyzje1
        else
		select @ybje=@zje-@zfyje-@yhje, @ybje1=@zje1-@zfyje1-@yhje1

   		 --add by qxh 2003.5.29
		if @acfdfp=1 
			update 	#mzcf_new  set  zje=b.zje,zfyje=b.zfyje,yhje=b.yhje 
		       	from  #mzcf_new a , (select cfxh,isnull(round(sum(round(ypsl*ylsj*cfts/ykxs,2)),2),0) as zje ,
		            isnull(round(sum(round(ypsl*zfdj*cfts/ykxs,2)),2),0) as zfyje,
                    isnull(round(sum(round(ypsl*yhdj*cfts/ykxs,2)),2),0) as yhje  
                from  #cfmx_new group by cfxh ) b  where a.xh=b.cfxh  

		--ȡ��ʵ�ս��
		select @sfje_all=@sfje+@sfje1+@zfyje+@zfyje1
			select @srbz=config from YY_CONFIG (nolock) where id='2016'
			if @@error<>0 or @@rowcount=0
				select @srbz='0'
		select @sfje2=@sfje_all

		if @pzlx not in (10,11)
		begin
			--tony 2003.12.8 С����ҽ���޸�
			if @tcljbz=1
			begin
				select @ybje=@ybje+@ybje1,@ybje1=0,@sfje=0,@sfje1=0
	
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
			else begin
				--ҩƷ������
				execute usp_yy_ybjs @ybdm,0,@ybje,0,@errmsg output
				if @errmsg like "F%"
				begin
					select "F",substring(@errmsg,2,49)
					return
				end
				else
					select @sfje=convert(numeric(10,2),substring(@errmsg,2,11))
	
				execute usp_yy_ybjs @ybdm,0,0,@ybje1,@errmsg output
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
			if @srfs = '1' and @qkbz in(3)---��1����ȷ����
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
			
			if @qkbz in(1)
			begin
				--�Էѷ����Լ�����(������ʼ)
				if exists(select 1 from YY_CONFIG (nolock) where charindex('"'+rtrim(@ybdm)+'"',config)>0 and id='0053')
				begin
					if @qkje1>@sfje2-@zfyje-@zfyje1+@flzfje+@flzfje1
						select @qkje=round(@sfje2-@zfyje-@zfyje1+@flzfje+@flzfje1,1),
								@qkje2 = @sfje_all-@zfyje-@zfyje1+@flzfje+@flzfje1
					else
						select @qkje=round(@qkje1,1),@qkje2 =@qkje1
				end
				else
				begin
					if @qkje1>@sfje2
						select @qkje=round(@sfje2,1),@qkje2 =@sfje_all
					else
						select @qkje=round(@qkje1,1),@qkje2 =@qkje1
				end

				insert into SF_JEMXK(jssjh, lx, mc, je, memo)
				values(@newsjh, '01', '�𸶶ε����˻�֧��',@qkje2 , null)
				if @@error<>0
				begin
					select "F","�������01��Ϣ����"
					rollback tran
					return
				end
				
				/*
				select @sfje_bkall = @sfje_all - @qkje2,@qkje = 0
				--С�����봦��
				if @srbz='5'
					select @sfje2=round(@sfje_bkall, 1)
				else if @srbz='6'
					exec usp_yy_wslr @sfje_bkall,1,@sfje2 output 
				else if @srbz>='1' and @srbz<='9'
					exec usp_yy_wslr @sfje_bkall,1,@sfje2 output,@srbz
				else
					select @sfje2=@sfje_bkall

				select @srje = @sfje2 - (@sfje_all - @qkje2)
				if @ybje>0
					select @xmzfbl=(@ybje - @qkje2)/@ybje
				select @sfje = @ybje - @qkje2
				*/
				--��������
			end
			else 
			begin
				if @qkbz=2
					select @qkje=@sfje2
				if @qkbz=3
				begin
					if @qkje1>@sfje2
						select @qkje=@sfje2
					else
					begin
						select @qkje=@qkje1	
						if @srfs = '1'---1����ȷ������������20110426sqf
						begin
							select @qkje=round(@qkje1, 1,1) ---ȥ��С��λ
						end 						
					end				
				end
				if @qkbz=4	--���ҿ�
				begin
					if @qkje1>@sfje2
						select @qkje=@sfje2
					else
						select @qkje=@qkje1					
				end
			end	
		end

		--���������ܽ��
		select dxmdm, round(ylsj*ypsl*cfts/ykxs,2) as xmje, 
			round((ylsj-zfdj-yhdj)*ypsl,2) as zfje,
			round(zfdj*ypsl*cfts/ykxs,2) as zfyje, 
			round(yhdj*ypsl*cfts/ykxs,2) as yhje,
			round(flzfdj*ypsl*cfts/ykxs,2) as flzfje,
			round(flzfdj*ypsl*cfts/ykxs,2) as lcyhje
			into #sfmx1
			from #cfmx_new where 1=2 

		if isnull(@yplcjs2169,'') = '��'
			insert into #sfmx1(dxmdm, xmje,zfje,zfyje,yhje,flzfje,lcyhje)
			select dxmdm, sum(round(ylsj*ypsl*cfts/ykxs,2)) as xmje, 
				sum(round((ylsj-zfdj-yhdj)*ypsl*cfts*(case when cd_idm>0 then @xmzfbl else @xmzfbl1 end)/ykxs,2)) as zfje,
				sum(round(zfdj*ypsl*cfts/ykxs,2)) as zfyje, 
				sum(case when lcjsdj <>0 and yhdj = ylsj - lcjsdj then round(ylsj*ypsl*cfts/ykxs,2) - round(lcjsdj*ypsl*cfts/ykxs,2)
					     else round(yhdj*ypsl*cfts/ykxs,2) end ) as yhje,
				sum(round(flzfdj*ypsl*cfts/ykxs,2)) as flzfje,
				sum( case when lcjsdj = 0 then 0 else round(ylsj*ypsl*cfts/ykxs,2) - round(lcjsdj*ypsl*cfts/ykxs,2) end) lcyhje
				from #cfmx_new group by dxmdm		
		else
			insert 	into #sfmx1(dxmdm,xmje,zfje,zfyje,yhje,flzfje,lcyhje)
			select dxmdm, sum(round(ylsj*ypsl*cfts/ykxs,2)) as xmje, 
				sum(round((ylsj-zfdj-yhdj)*ypsl*cfts*(case when cd_idm>0 then @xmzfbl else @xmzfbl1 end)/ykxs,2)) as zfje,
				sum(round(zfdj*ypsl*cfts/ykxs,2)) as zfyje, 
				sum(round(yhdj*ypsl*cfts/ykxs,2)) as yhje,
				sum(round(flzfdj*ypsl*cfts/ykxs,2)) as flzfje,0
			from #cfmx_new group by dxmdm

		if exists (select 1 from #sfmx1)
		begin
			select @xmce=@sfje+@sfje1-sum(zfje) from #sfmx1
			update #sfmx1 set zfje=zfje+zfyje
			set rowcount 1
			update #sfmx1 set zfje=zfje+@xmce
			set rowcount 0
		end

		--jjw 2003-01-06 add �������˷Ѽ�¼���´�����zfje
		if @acfdfp=1
			update #mzcf_new  set  zfje=b.zfje
	       	from #mzcf_new a, (select c.cfxh, isnull(round(sum(round((c.ylsj-c.zfdj-c.yhdj)*c.ypsl*c.cfts*(case when c.cd_idm>0 then @xmzfbltf else @xmzfbltf1 end)/c.ykxs,2)),2),0) as zfje
            	 from  #cfmx_new c where cfxh in (select cfxh from #cfmx_tf) group by c.cfxh) b
			where a.xh=b.cfxh
	end
	if @qkbz in (1,3,4) and @srfs = '0'
	begin
		select @sfje2=@sfje_all-@qkje
		if @srbz='5'
			select @sfje2=round(@sfje2, 1)
		else if @srbz='6'
			exec usp_yy_wslr @sfje2,1,@sfje2 output
		else if @srbz>='1' and @srbz<='9'
			exec usp_yy_wslr @sfje2,1,@sfje2 output,@srbz
		else
			select @sfje2=@sfje2
		select @sfje2=@sfje2+@qkje
		select @srje=@sfje2-@sfje_all
	end
	else if (@srfs = '0' or @srfs = '1') and @qkbz not in (1,3,4)
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
    --jjw 2004-01-06 add  
	if @acfdfp=1 
	begin
		update 	#mzcf_old  set  tfje=zfje
        update  #mzcf_old  set  tfje=a.tfje-b.zfje 
		from    #mzcf_old a ,#mzcf_new b
		where a.xh=b.xh
    end


	if @pzlx in (10,11) and @qtbz=0
	begin
		--update by zwj 2003-09-09	ҽ�������޸�
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
		if (@pzlx = 11) and exists(select 1 from #brjsk where substring(zhbz,12,1)='0')----�󲡼���
		begin
		    select @xmlb=isnull(ylxm,'0') from #brjsk
			declare @msg varchar(300)
			exec usp_yy_yb_getylxm '0','0',@xmlb,@jfbz output,@msg output
			if @jfbz <>'0' and @msg <>'R'
			begin
			    if @config2395<>''
			    begin
			        select @flzfjedbxm=isnull(sum(round(ypsl*flzfdj*cfts/ykxs,2)),0)
			        from #cfmx_new
			        where cd_idm=0 and charindex('"'+rtrim(ltrim(ypdm))+'"',@config2395)>0			        
			    end
				select @ybzje=@ybje+@ybje1+@flzfje+@flzfjedbxm ---------ҽ�����׽�����ҩƷ��flzfje
				select @jfje= @flzfje+@flzfjedbxm
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

    if @zph='S'
  begin        
        if not exists(select 1 from YY_PAYDETAILK where zflb=1 and jssjh=@sjh and zfzt=1 and jlzt in (0,1))
           and @isxjtf_paycenter=0
        begin
            --ֻ�в����˷ѲŴ���
            select 'F','��һ�β����˷�֧���˿���ʧ�ܣ��뵽�쳣֧�������д���ʧ�ܼ�¼���ɹ��󼴿ɼ����˷ѣ�'
            return
        end
    end

	begin tran
	declare cs_sfbftf cursor for
	select xh from #mzcf_old
	for read only

	open cs_sfbftf
	fetch cs_sfbftf into @cfxh
	while @@fetch_status=0
	begin
		--���˷Ѳ��ٺ��
		if @tfbz=0
		begin
			--���ԭ��¼
			insert into SF_MZCFK(jssjh, hjxh, czyh, lrrq, patid, hzxm, ybdm, py, wb, 
				ysdm, ksdm, yfdm, qrczyh, qrrq, qrksdm, pyczyh, pyrq, cfts, txh, sfckdm, 
				pyckdm, fyckdm, jsbz, jlzt, fybz, cflx, sycfbz, tscfbz, pybz, jcxh, memo, cfxh,
				zje,zfyje,yhje,zfje,srje,fph,fpjxh,tfje, sqdxh,ejygbz, ejygksdm,xzks_id,ylxzbh,tmhdbz,ghxh,gxrq,wsbz,wsts,cftszddm,cftszdmc,yscfbz)	--mod by ozb 20060320����ejygbz, ejygksdm
			select @newsjh1, hjxh, @czyh, @now, patid, hzxm, ybdm, py, wb, 
				ysdm, ksdm, yfdm, qrczyh, qrrq, qrksdm, pyczyh, pyrq, cfts, xh, sfckdm, --����Ų��������� , Modify By Agg , 2003.08.12
				pyckdm, fyckdm, jsbz, 9, fybz, cflx, sycfbz, tscfbz, pybz, jcxh, memo, cfxh,
				-zje,-zfyje,-yhje,-zfje,-srje,fph,fpjxh,tfje, sqdxh,isnull(ejygbz,0), isnull(ejygksdm,""),xzks_id,ylxzbh,tmhdbz--����¼�óɸ��� , Modify By Agg , 2003.08.12 --mod by ozb 20060320����ejygbz, ejygksdm
				,ghxh,@now,isnull(wsbz,0),isnull(wsts,0),cftszddm,cftszdmc,yscfbz  --add by yfq @20120528
				from #mzcf_old where xh=@cfxh
			if @@error<>0 or @@rowcount=0
			begin
				select "F","����շѴ�������"
				rollback tran
				deallocate cs_sfbftf
				return
			end

			select @xhtemp=@@identity

			insert into SF_CFMXK(cfxh, cd_idm, gg_idm, dxmdm, ypmc, ypdm, ypdw, dwxs, ykxs, ypfj, ylsj, 
				ypsl, ts, cfts, zfdj, yhdj, memo, ypgg, flzfdj, hjmxxh,
				gbfwje, gbfwwje, gbtsbz,fpzh, lcxmdm, lcxmmc,lcxmsl,dydm,yjqrbz,zbz,
				lcjsdj,yjspbz,ssbfybz,zje,tmxxh,shbz,yqrsl,ktsl,wsbz,ldcfxh,ldmxxh,tfbz) --add "dydm" 20070119 --add fpzh by ozb 20060622 ���ӷ�Ʊ���
			select @xhtemp, cd_idm, gg_idm, dxmdm, ypmc, ypdm, ypdw, dwxs, ykxs, ypfj, ylsj, 
				-ypsl, ts, cfts, zfdj, yhdj, memo, ypgg, flzfdj, hjmxxh,
				-gbfwje, -gbfwwje, gbtsbz,fpzh, lcxmdm, lcxmmc,-lcxmsl,dydm,yjqrbz,zbz 
				,lcjsdj,yjspbz,ssbfybz,-zje,xh,shbz,-yqrsl,-ktsl,wsbz,ldcfxh,ldmxxh,tfbz--add "dydm" 20070119 --add fpzh by ozb 20060622 ���ӷ�Ʊ���
				from #cfmx_old where cfxh=@cfxh
			if @@error<>0
			begin
				select "F","����շѴ�����ϸ����"
				rollback tran
				deallocate cs_sfbftf
				return		
			end
			--���븨����
			insert into SF_MZCFK_FZ(jssjh,hjxh,cfxh,patid,ccfbz)
			select @newsjh1,hjxh,@xhtemp,@patid,ccfbz
			from #mzcf_old_fz where cfxh=@cfxh
			if @@error<>0
			begin
				select "F","�����շѴ�����ϸ����"
				rollback tran
				deallocate cs_mzsf
				return		
			end
		end

		--ȫ�˲�����
		if @qtbz=0
		begin
			--����ʣ�µĴ�����ϸ
			declare @hjxh ut_xh12
			insert into SF_MZCFK(jssjh, hjxh, czyh, lrrq, patid, hzxm, ybdm, py, wb, 
				ysdm, ksdm, yfdm, qrczyh, qrrq, qrksdm, pyczyh, pyrq, cfts, txh, sfckdm, 
				pyckdm, fyckdm, jsbz, jlzt, fybz, cflx, sycfbz, tscfbz, pybz, jcxh, memo, cfxh,
				zje,zfyje,yhje,zfje,srje,fph,fpjxh,tfje,tfbz,fyckxh, sqdxh, ejygbz, ejygksdm,xzks_id,ylxzbh,tmhdbz,ghxh,gxrq,wsbz,wsts,cftszddm,cftszdmc,yscfbz)--mod by ozb 20060320����ejygbz, ejygksdm
			select @newsjh, hjxh, @czyh, @now, patid, hzxm, ybdm, py, wb, 
				ysdm, ksdm, yfdm, qrczyh, qrrq, qrksdm, pyczyh, pyrq, cfts, xh, sfckdm,  --����Ų��������� , Modify By Agg , 2003.08.12
				pyckdm, fyckdm, jsbz, 9, fybz, cflx, sycfbz, tscfbz, pybz, jcxh, memo, cfxh,
				zje,zfyje,yhje,zfje,srje,fph,fpjxh,tfje,tfbz,fyckxh, sqdxh, isnull(ejygbz,0), isnull(ejygksdm,""),xzks_id,ylxzbh--mod by ozb 20060320����ejygbz, ejygksdm
				,case when cfts>0 and cflx = 3 and cfts%7 = 0 then '1' else '0' end,ghxh,@now,isnull(wsbz,0),isnull(wsts,0),cftszddm,cftszdmc,yscfbz --add by yfq @20120528
				from #mzcf_new where xh=@cfxh
			if @@error<>0
			begin
				select "F","�����շѴ�������"
				rollback tran
				deallocate cs_sfbftf
				return
			end

			select @xhtemp=@@identity

			insert into SF_CFMXK(cfxh, cd_idm, gg_idm, dxmdm, ypmc, ypdm, ypdw, dwxs, ykxs, ypfj, ylsj, 
				ypsl, ts, cfts, zfdj, yhdj, memo, ypgg, flzfdj, hjmxxh,fpzh, lcxmdm, lcxmmc,lcxmsl,dydm,
				yjqrbz,zbz,lcjsdj,yjspbz,qrczyh,qrksdm,ssbfybz,zje,tmxxh,shbz,yqrsl,ktsl,wsbz,ldcfxh,ldmxxh --add "dydm" 20070119	--add fpzh by ozb 20060622 ���ӷ�Ʊ���
				,tfbz)
			select @xhtemp, cd_idm, gg_idm, dxmdm, ypmc, ypdm, ypdw, dwxs, ykxs, ypfj, ylsj, 
				ypsl, ts, cfts, zfdj, yhdj, memo, ypgg, flzfdj, hjmxxh,fpzh, lcxmdm, lcxmmc,lcxmsl,dydm,yjqrbz,zbz,
				lcjsdj,yjspbz,qrczyh,qrksdm,ssbfybz,isnull(round(ypsl*ylsj*cfts/ykxs,2),0),xh,shbz,yqrsl,case @config2471 when 0 then ktsl else ktsl end,isnull(wsbz,0),ldcfxh,ldmxxh  --add "dydm" 20070119	--add fpzh by ozb 20060622 ���ӷ�Ʊ���
				,case when @config2471=0 and ktsl > 0 then 1 else tfbz end
				from #cfmx_new where cfxh=@cfxh
			if @@error<>0
			begin
				select "F","�����շѴ�����ϸ����"
				rollback tran
				deallocate cs_sfbftf
				return		
			end
			--���븨����
			
			--bug 137298 add z_wm
			if exists(select 1 from #cfmx_new where cfxh=@cfxh)
			begin		
			    select @hjxh=hjxh from SF_MZCFK  where xh=@cfxh	
				insert into SF_MZCFK_FZ(jssjh,hjxh,cfxh,patid,ccfbz)
				select @newsjh,@hjxh,@xhtemp,@patid,ccfbz
				from #mzcf_old_fz where cfxh=@cfxh
				if @@error<>0
				begin
					select "F","�����շѴ�����ϸ����"
					rollback tran
					deallocate cs_mzsf
					return		
				end
			end 
			select @tfspbz=tfspbz,@yjqxyy=qxyy from #cfmx_old_fz where cfxh=@cfxh
			--wangmiao
			select @yjclfbz=yjclfbz from #cfmx_new_fz where cfxh=@cfxh
			insert into SF_CFMXK_FZ(cfxh,mxxh,hjmxxh,yjclfbz,tfspbz,qxyy)
			select @xhtemp,xh,hjmxxh,@yjclfbz,@tfspbz,@yjqxyy from SF_CFMXK where cfxh= @xhtemp  
			if @@error<>0
			begin
				select "F","�����շѴ�����ϸ����"
				rollback tran
				deallocate cs_mzsf
				return		
			end
		end

		fetch cs_sfbftf into @cfxh
	end
	close cs_sfbftf
	deallocate cs_sfbftf

	--���˷Ѳ��ٺ��
	if @tfbz=0
	begin
		--�����������
		IF @ylkysje<>0	-- add by gzy at 20050501
		BEGIN
			insert into SF_BRJSK(sjh, patid, ghsjh, ghxh, fph, fpjxh, czyh, sfrq, sfksdm, ksdm, 
				hzxm, blh, ybdm, pzh, sfzh, ylxm, zddm, dwbm, zje, zfyje, yhje, deje, zfje, 
				zpje, zph, xjje, srje, qkbz, qkje, zxlsh, jslsh, ybjszt, zhbz, tsjh, jlzt, cardno,
				cardtype, ghsfbz, jcxh, memo, mjzbz, brlx
				,ylkje,ylkysje, flzfje
				,qrbz,qrczyh,qrrq,tcljje,tcljbz,yflsh,tsyhje,spzlx
				,gbje, gbbz, gbtsbz,gbfwwje,bdyhkje,bdyhklsh,lcyhje,hzdybz,gxrq
				,yhdm,appjkdm,syldyhbz,syldyhje)	--mit ,2oo3-11-14
			select @newsjh1, patid, ghsjh, ghxh, fph, fpjxh, @czyh, @now, /*sfksdm*/@tfksdm, ksdm, --wudong alter sfksdm to @tfksdm 2015-06-19 ����29652
				hzxm, blh, ybdm, pzh, sfzh, ylxm, zddm, dwbm, -zje, -zfyje, -yhje, -deje, -zfje, 
				-zpje, zph, -xjje-ylkysje, -srje, qkbz, -qkje, zxlsh, jslsh, 0, zhbz, @sjh, 2, cardno,
				cardtype, ghsfbz, jcxh, memo, mjzbz, brlx
				,0,0, -flzfje
				,qrbz,@czyh,@now,tcljje,tcljbz,yflsh,-tsyhje,spzlx
				,-gbje, gbbz, gbtsbz,-gbfwwje,-bdyhkje,bdyhklsh,-lcyhje,hzdybz--mit ,2oo3-11-14
                ,@now
                ,yhdm,appjkdm,syldyhbz,-syldyhje --add by yjn 2015-03-21
				from #brjsk
			if @@error<>0
			begin
				select "F","�������˵�����"
				rollback tran
				return		
			end
		END
		ELSE
		IF @posfph='7' or CHARINDEX(','+@posfph+',',@config2545)>0
		BEGIN
			insert into SF_BRJSK(sjh, patid, ghsjh, ghxh, fph, fpjxh, czyh, sfrq, sfksdm, ksdm, 
				hzxm, blh, ybdm, pzh, sfzh, ylxm, zddm, dwbm, zje, zfyje, yhje, deje, zfje, 
				zpje, zph, xjje, srje, qkbz, qkje, zxlsh, jslsh, ybjszt, zhbz, tsjh, jlzt, cardno,
				cardtype, ghsfbz, jcxh, memo, mjzbz, brlx
				,ylkje,ylkysje, flzfje
				,qrbz,qrczyh,qrrq,tcljje,tcljbz,yflsh,tsyhje,spzlx
				,gbje, gbbz, gbtsbz,gbfwwje,bdyhkje,bdyhklsh,lcyhje,hzdybz,gxrq
				,yhdm,appjkdm,syldyhbz,syldyhje)	--mit ,2oo3-11-14
			select @newsjh1, patid, ghsjh, ghxh, fph, fpjxh, @czyh, @now, /*sfksdm*/@tfksdm, ksdm,  --wudong alter sfksdm to @tfksdm 2015-06-19 ����29652
				hzxm, blh, ybdm, pzh, sfzh, ylxm, zddm, dwbm, -zje, -zfyje, -yhje, -deje, -zfje, 
				case when @zffs=0 then 0 else -zpje end, case when @zffs=0 then '' else zph end, case when @zffs=0 then -xjje-zpje else -xjje end, 
				-srje, qkbz, -qkje, zxlsh, jslsh, 0, zhbz, @sjh, 2, cardno,
				cardtype, ghsfbz, jcxh, memo, mjzbz, brlx
				,-ylkje,-ylkysje, -flzfje
				,qrbz,@czyh,@now,tcljje,tcljbz,yflsh,-tsyhje,spzlx
				,-gbje, gbbz, gbtsbz,-gbfwwje,-bdyhkje,bdyhklsh	,-lcyhje,hzdybz--mit ,2oo3-11-14
                ,@now --add by yfq @20120528
                ,yhdm,appjkdm,syldyhbz,-syldyhje--add by yjn 2015-03-21
				from #brjsk
			if @@error<>0
			begin
				select "F","�������˵�����"
				rollback tran
				return		
			end
		END
		ELSE  if @zph<>'' -- @zph='S'
		BEGIN
			insert into SF_BRJSK(sjh, patid, ghsjh, ghxh, fph, fpjxh, czyh, sfrq, sfksdm, ksdm, 
				hzxm, blh, ybdm, pzh, sfzh, ylxm, zddm, dwbm, zje, zfyje, yhje, deje, zfje, 
				zpje, zph, xjje, srje, qkbz, qkje, zxlsh, jslsh, ybjszt, zhbz, tsjh, jlzt, cardno,
				cardtype, ghsfbz, jcxh, memo, mjzbz, brlx
				,ylkje,ylkysje, flzfje
				,qrbz,qrczyh,qrrq,tcljje,tcljbz,yflsh,tsyhje,spzlx
				,gbje, gbbz, gbtsbz,gbfwwje,bdyhkje,bdyhklsh,lcyhje,hzdybz,gxrq
				,yhdm,appjkdm,syldyhbz,syldyhje)	--mit ,2oo3-11-14
			select @newsjh1, patid, ghsjh, ghxh, fph, fpjxh, @czyh, @now, /*sfksdm*/@tfksdm, ksdm, --wudong alter sfksdm to @tfksdm 2015-06-19 ����29652 
				hzxm, blh, ybdm, pzh, sfzh, ylxm, zddm, dwbm, -zje, -zfyje, -yhje, -deje, -zfje, 
				--û���ж�@zffs,�����˷�ʱ��尴ԭ��ʽ����㣬���հ��ֽ�����������
				case when @zffs=0 then 0 else -zpje end, case when @zffs=0 then '' else zph end, case when @zffs=0 then -xjje-zpje else -xjje end, -srje, qkbz, -qkje, zxlsh, jslsh, 0, zhbz, @sjh, 2, cardno, 
				--Դ���� -zpje, zph, -xjje, -srje, qkbz, -qkje, zxlsh, jslsh, 0, zhbz, @sjh, 2, cardno,
				cardtype, ghsfbz, jcxh, memo, mjzbz, brlx
				,-ylkje,-ylkysje, -flzfje
				,qrbz,@czyh,@now,tcljje,tcljbz,yflsh,-tsyhje,spzlx
				,-gbje, gbbz, gbtsbz,-gbfwwje,-bdyhkje,bdyhklsh,-lcyhje,hzdybz	--mit ,2oo3-11-14
                ,@now --add by yfq @20120528
                ,yhdm,appjkdm,syldyhbz,-syldyhje --add by yjn 2015-03-21        
				from #brjsk
			if @@error<>0
			begin
				select "F","�������˵�����"
				rollback tran
				return		
			end
		END
		ELSE
		BEGIN
			insert into SF_BRJSK(sjh, patid, ghsjh, ghxh, fph, fpjxh, czyh, sfrq, sfksdm, ksdm, 
				hzxm, blh, ybdm, pzh, sfzh, ylxm, zddm, dwbm, zje, zfyje, yhje, deje, zfje, 
				zpje, zph, xjje, srje, qkbz, qkje, zxlsh, jslsh, ybjszt, zhbz, tsjh, jlzt, cardno,
				cardtype, ghsfbz, jcxh, memo, mjzbz, brlx
				,ylkje,ylkysje, flzfje
				,qrbz,qrczyh,qrrq,tcljje,tcljbz,yflsh,tsyhje,spzlx
				,gbje, gbbz, gbtsbz,gbfwwje,bdyhkje,bdyhklsh,lcyhje,hzdybz,gxrq
				,yhdm,appjkdm,syldyhbz,syldyhje)	--mit ,2oo3-11-14
			select @newsjh1, patid, ghsjh, ghxh, fph, fpjxh, @czyh, @now, /*sfksdm*/@tfksdm, ksdm, --wudong alter sfksdm to @tfksdm 2015-06-19 ����29652 
				hzxm, blh, ybdm, pzh, sfzh, ylxm, zddm, dwbm, -zje, -zfyje, -yhje, -deje, -zfje, 
				-zpje, zph, -xjje, -srje, qkbz, -qkje, zxlsh, jslsh, 0, zhbz, @sjh, 2, cardno,
				cardtype, ghsfbz, jcxh, memo, mjzbz, brlx
				,-ylkje,-ylkysje, -flzfje
				,qrbz,@czyh,@now,tcljje,tcljbz,yflsh,-tsyhje,spzlx
				,-gbje, gbbz, gbtsbz,-gbfwwje,-bdyhkje,bdyhklsh,-lcyhje,hzdybz	--mit ,2oo3-11-14
                ,@now --add by yfq @20120528
                ,yhdm,appjkdm,syldyhbz,-syldyhje --add by yjn 2015-03-21        
				from #brjsk
			if @@error<>0
			begin
				select "F","�������˵�����"
				rollback tran
				return		
			end
		END

		insert into SF_BRJSMXK(jssjh, dxmdm, dxmmc, fpxmdm, fpxmmc, xmje, zfje, zfyje, yhje, memo, flzfje
			,tsyhje, gbzfje,gbfwje,gbfwwje,gbtsfwje,gbtsfwwje,gbtszfje ,lcyhje,syldyhje)
		select @newsjh1, dxmdm, dxmmc, fpxmdm, fpxmmc, -xmje, -zfje, -zfyje, -yhje, memo,- flzfje
			,-tsyhje, -gbzfje,-gbfwje,-gbfwwje,-gbtsfwje,-gbtsfwwje,-gbtszfje,-lcyhje,-syldyhje 
			from VW_MZBRJSMXK where jssjh=@sjh
		if @@error<>0
		begin
			select "F","��������ϸ����"
			rollback tran
			return		
		end

		--add by ozb ��巢Ʊ��ϸ begin
		delete from SF_FPMXDYK	where jssjh=@newsjh1
		insert into SF_FPMXDYK(jssjh,zh,fph,fpjxh,zje,zfje,flzfje,yhje,zfyje,bcdbz,wtpbz)
		select @newsjh1,zh,fph,fpjxh,-zje,-zfje,-flzfje,-yhje,-zfyje,bcdbz,wtpbz
			from VW_SFFPMXDYK where jssjh=@sjh
		if @@error<>0
		begin
			select "F","��巢Ʊ��ϸ��Ӧ��¼����"
			rollback tran
			return		
		end
		--add by ozb ��巢Ʊ��ϸ end

		--add by ozb 20060602 begin    
		if @bcdwtffp=1    
		begin			    
			update SF_FPMXDYK set wtpbz=1 where jssjh=@newsjh1 and zh not in (select fpzh from #cfmx_old a,#cfmx_tf b where a.xh=b.mxxh)  		
			select @fph=max(fph),@fpjxh=max(fpjxh) from SF_FPMXDYK(nolock) where jssjh=@newsjh1 and wtpbz=1			
		end
		--add by ozb 20060602 end    
		--add by ozb ��巢Ʊ��ϸ end    
	end

	--ȫ�˲�����
	if @qtbz=0
	begin

		--����ʣ�µ����������Ϣ cjt 20111122 dfbz=2��ʾ�˷�����
		insert into SF_BRJSK(sjh, patid, ghsjh, ghxh, fph, fpjxh, czyh, sfrq, sfksdm, ksdm, 
			hzxm, blh, ybdm, pzh, sfzh, ylxm, zddm, dwbm, zje, zfyje, yhje, deje, zfje, 
			zpje, zph, xjje, srje, qkbz, qkje, zxlsh, jslsh, ybjszt, zhbz, tsjh, jlzt, cardno,
			cardtype, ghsfbz, jcxh, memo, mjzbz, brlx, flzfje, qrbz, qrczyh, qrrq, tcljje, 
			tcljbz, yflsh,spzlx,lcyhje,hzdybz,dfbz,gxrq,yhdm,appjkdm)
		select @newsjh, patid, ghsjh, ghxh, isnull(@fph,0), isnull(@fpjxh,0), @czyh, @now, /*sfksdm*/@tfksdm, ksdm,  --wudong alter sfksdm to @tfksdm 2015-06-19 ����29652
			hzxm, blh, ybdm, pzh, sfzh, ylxm, zddm, dwbm, @zje+@zje1, @zfyje+@zfyje1, @yhje+@yhje1, 0, @sfje2,
			0, '', 0, @srje, @qkbz, @qkje, '', '', 0, zhbz, @newsjh1, 0, cardno,
			cardtype, ghsfbz, jcxh, memo, mjzbz, brlx, @flzfje+@flzfje1, @qrbznew , 
			@czyh,@now,@tcljje1,@tcljbz, yflsh,spzlx,@lcyhje,hzdybz,'2',@now --add by yfq @20120528
			,yhdm,appjkdm --add by yjn 2015-03-21
		from #brjsk
		if @@error<>0
		begin
			select "F","��������˵�����"
			rollback tran
			return		
		end
		insert into SF_BRJSMXK(jssjh, dxmdm, dxmmc, fpxmdm, fpxmmc, xmje, zfje, zfyje, yhje, memo, flzfje,lcyhje)
		select @newsjh, a.dxmdm, b.name, b.mzfp_id, b.mzfp_mc, a.xmje, a.zfje, a.zfyje, a.yhje, null, flzfje,lcyhje
			from #sfmx1 a, YY_SFDXMK b (nolock) where a.dxmdm=b.id
		if @@error<>0
		begin
			select "F","���������ϸ����"
			rollback tran
			return		
		end
		
		-- ���븨����.
		if exists (select 1 from sysobjects where name='SF_BRJSK_FZ' and xtype='U')
		BEGIN
		    if exists(select 1 from SF_BRJSK_FZ where sjh = @newsjh)
		    begin
			    delete from SF_BRJSK_FZ where sjh = @newsjh
			    if @@error<>0
			    begin
				    select "F","���SF_BRJSK_FZ�ظ���¼����"
				    rollback tran
				    return		
			    end	
		    end		
		    insert into SF_BRJSK_FZ
		    (sjh,patid,ghsjh,ghxh,fph,fpjxh,ip,mac,sfly)
		    select                
		    @newsjh, @patid, ghsjh, ghxh, null, null,'',@wkdz,@sfly
		    from #brjsk
		    if @@error<>0
		    begin
			    select "F","��������˵�����"
			    rollback tran
			    return		
		    end	
	   END
		
	end

	/*if @configdyms=0 and @acfdfp=1
	begin
		--zwj 2006.7.26 ����������ҩ�嵥
		update YF_MZFYZD set jlzt=1 
		from YF_MZFYZD a where a.jssjh=@sjh and a.tfbz=1 and a.tfqrbz=0 and not exists(select 1 from #mzcf_tf b where a.cfxh=b.cfxh) and jlzt=0
		if @@error<>0
		begin
			select "F","������ҩ��Ϣ����"
			rollback tran
			return		
		end
	end*/
	--�����ۼۿ����β����˷����⴦������44612,2015-10-27
	declare @isdlsjfa ut_bz, --�Ƿ���ö����ۼ۷�����0�����ã�1���ã�
			@ypxtslt int,--���ۼ۷���
			@cfmxxh_cs	ut_xh12,--�������
			@tcfmxxh_cs	ut_xh12,--����ϸ���
			@ypsl_cs	ut_xh12,--��������
			@zje_cs ut_money, 
			@sfje_cs ut_money,
			@ybje_cs ut_money, 
			@flzfje_cs ut_money, 
			@yjzfje_cs ut_money,
			
			@cfxh_ty	ut_xh12,
			@mxxh_ty	ut_xh12,
			@tmxxh_ty	ut_xh12,
			@pjlsj_ty	ut_money,
			@ypsl_ty	ut_sl10
	select @isdlsjfa=0,@ypxtslt=0,@cfmxxh_cs=0,@tcfmxxh_cs=0,@ypsl_cs=0,@zje_cs=0, @sfje_cs=0,@ybje_cs=0, @flzfje_cs=0, @yjzfje_cs=0
			,@cfxh_ty=0,@mxxh_ty=0,@tmxxh_ty=0,@pjlsj_ty=0,@ypsl_ty=0
	if exists(select 1 from sysobjects where name='f_get_ypxtslt')	
	begin
		select @ypxtslt=dbo.f_get_ypxtslt()  
		if @ypxtslt=3 
		select @isdlsjfa=1
	end
	if (@isdlsjfa = 1)and(@qtbz = 0)
	begin
		if exists(select 1 from SF_MZCFK a(nolock),SF_CFMXK b(nolock) where a.jssjh = @newsjh and a.xh=b.cfxh and a.cflx in(1,2,3) and a.fybz=0)
		begin
			declare cs_mzsf_dpcjgcl_ys cursor for
			select b.xh,b.tmxxh,b.ypsl*b.cfts  from SF_MZCFK a(nolock)
				inner join SF_CFMXK b(nolock) on a.xh = b.cfxh
			where a.jssjh=@newsjh and a.cflx in(1,2,3) and a.fybz=0
			for read only
			open cs_mzsf_dpcjgcl_ys
			fetch cs_mzsf_dpcjgcl_ys into @cfmxxh_cs,@tcfmxxh_cs,@ypsl_cs
			while @@fetch_status=0
			begin							
				exec usp_yf_sfjk_bftf_cfdypc_cl @cfmxxh_cs,@ypsl_cs,@tcfmxxh_cs,@czyh,0,@errmsg output
				if substring(@errmsg,1,1)<>'T'
				begin
					select 'F','ҩƷ�����ε��ۼ������'+@errmsg
					rollback tran
					deallocate cs_mzsf_dpcjgcl_ys
					return
				end
				fetch cs_mzsf_dpcjgcl_ys into @cfmxxh_cs,@tcfmxxh_cs,@ypsl_cs
			end
			close cs_mzsf_dpcjgcl_ys
			deallocate cs_mzsf_dpcjgcl_ys
			
			select b.xh mxxh,sum((a.yplsj/a.ykxs)*a.djk_djsl) lsje into #yf_ypcfpc_dydjjlk
			from YF_YPCFPC_DYDJJLK a(nolock)
			inner join SF_CFMXK b(nolock) on a.mxxh = b.xh
			inner join SF_MZCFK c(nolock) on b.cfxh = c.xh
			where c.jssjh = @newsjh and c.cflx in(1,2,3) and c.fybz=0
			group by b.xh

			
			
			update a set a.ylsj= convert(numeric(10,4),(c.lsje/(a.ypsl*a.cfts))*a.ykxs),
				a.zje = convert(numeric(10,2),(((c.lsje/(a.ypsl*a.cfts))*a.ykxs)*a.dwxs*a.cfts/a.ykxs)*(a.ypsl/a.dwxs))
			from SF_CFMXK a
			inner join SF_MZCFK b(nolock) on a.cfxh = b.xh
			inner join #yf_ypcfpc_dydjjlk c(nolock) on a.xh = c.mxxh
			where b.jssjh = @newsjh and b.cflx in(1,2,3) and b.fybz=0
			if @@ERROR <> 0
			begin
				select 'F','�����ۼ۷���������ҩƷ��ϸ�����ۼ۳���'
				rollback tran
				return
			end
			
			--�������
			exec usp_sf_sfcl_jecs @newsjh,@errmsg output,@zje_cs output, @sfje_cs output,@ybje_cs output, @flzfje_cs output, @yjzfje_cs output
			if substring(@errmsg,1,1)<>'T'
			begin
				select 'F','�����������'+@errmsg
				rollback tran
				return
			end
		end
		if exists(select 1 from SF_MZCFK a(nolock),SF_CFMXK b(nolock) where a.jssjh = @newsjh and a.xh=b.cfxh and a.cflx in(1,2,3) and a.fybz=1)
		begin
			select b.xh cfxh,a.xh mxxh,a.tmxxh tmxxh,ypsl ypsl,@sjh jssjh,a.cfts into #cfmx_fyty	--���յĴ�����ϸ
			from SF_CFMXK a(nolock)
				inner join SF_MZCFK b(nolock) on a.cfxh = b.xh
				inner join #cfmx_tf c on a.tmxxh = c.mxxh
			where b.jssjh  = @newsjh and b.fybz = 1 and b.cflx in (1,2,3)
			
			select a.ylsj,a.ypsl,a.ykxs,a.mxxh,a.cfts into #yf_mzfymx									--��ҩ��ϸ
			from YF_MZFYMX a(nolock)
				inner join YF_MZFYZD b(nolock) on a.fyxh = b.xh
			where b.jssjh = @sjh
			--if @@ROWCOUNT = 0 --note by mxd for bug:21272 and pdms:30686
			begin
				insert into #yf_mzfymx
				select a.ylsj,a.ypsl,a.ykxs ,a.mxxh,a.cfts
				from YF_NMZFYMX a(nolock)
					inner join YF_NMZFYZD b(nolock) on a.fyxh = b.xh
				where b.jssjh = @sjh
			end
			
			declare cs_mzsf_dpcjgcl_ty cursor for
			select cfxh,mxxh,tmxxh,ypsl*cfts
			from #cfmx_fyty
			for read only
			open cs_mzsf_dpcjgcl_ty
			fetch cs_mzsf_dpcjgcl_ty into @cfxh_ty,@mxxh_ty,@tmxxh_ty,@ypsl_ty
			while @@fetch_status=0
			begin						
				select @pjlsj_ty = SUM(ylsj*ypsl*cfts)/@ypsl_ty
				from #yf_mzfymx
				where mxxh = @tmxxh_ty 
				
				update SF_CFMXK set ylsj=@pjlsj_ty,zje = @pjlsj_ty*@ypsl_ty/ykxs
				where xh = @mxxh_ty
				if @@ROWCOUNT=0 or @@ERROR<>0
				begin
					select 'F','��������ҩƷ���ۼ�ʧ�ܣ�'
					rollback tran
					close cs_mzsf_dpcjgcl_ty
					deallocate cs_mzsf_dpcjgcl_ty
					return
				end
				fetch cs_mzsf_dpcjgcl_ty into @cfxh_ty,@mxxh_ty,@tmxxh_ty,@ypsl_ty
			end
			close cs_mzsf_dpcjgcl_ty
			deallocate cs_mzsf_dpcjgcl_ty
			
			--�������
			exec usp_sf_sfcl_jecs @newsjh,@errmsg output,@zje_cs output, @sfje_cs output,@ybje_cs output, @flzfje_cs output, @yjzfje_cs output
			if substring(@errmsg,1,1)<>'T'
			begin
				select 'F','�����������'+@errmsg
				rollback tran
				return
			end
		end
	end
	commit tran	
	UPDATE dbo.SF_CFMXK_FZ SET hxbz = '1' WHERE mxxh IN (
	SELECT a.xh FROM dbo.SF_CFMXK a
	LEFT JOIN dbo.SF_CFMXK b ON a.tmxxh=b.xh
	LEFT JOIN dbo.SF_MZCFK c ON a.cfxh = c.xh
	LEFT JOIN dbo.SF_CFMXK_FZ fz ON b.xh=fz.mxxh
	WHERE fz.hxbz = '1' AND c.jssjh = @newsjh)--�����µ�sf_cfmxk_fz�е�hxbz

	if @qtbz=0
	begin
		select "T", 0, @newsjh, @zje+@zje1, @sfje2-@qkje, @ybje+@ybje1,  --0-5
				@flzfje+@flzfje1,@ybzje, @ybjszje, @ybzlf, @ybssf, @ybjcf, --6-11
				@ybhyf, @ybspf, @ybtsf, @ybxyf, @ybzyf, @ybcyf, @ybqtf, -- 12-18
				@ybgrzf,@patid,round(isnull(@bdyhkje,0.00),2) -- 19-21
				,@jfbz,@jfje --22-23
				,@zffs --24
	end
	else
		select "T", 1,@newsjh,@zffs
end

return






