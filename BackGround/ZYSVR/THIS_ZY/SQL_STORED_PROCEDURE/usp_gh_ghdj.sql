ALTER proc usp_gh_ghdj
	@wkdz varchar(32),
	@jszt smallint,
	@ghbz smallint,
	@ghlb smallint,
	@czksfbz  int, 
	@cfzbz smallint,
	@patid ut_xh12,
	@czyh ut_czyh,
	@ksdm ut_ksdm,
	@ysdm ut_czyh,--10
	@ghksdm ut_ksdm,
	@sjh ut_sjh = null,
	@lybz smallint = 0,
	@yyxh ut_xh12 = null,
	@zhbz ut_zhbz = null,
	@zddm ut_zddm = null,
	@zxlsh ut_lsh = null,
	@jslsh ut_lsh = null,
	@xmlb ut_dm2 = null,
	@qfdnzhzfje numeric(12,2) = null,--20
	@qflnzhzfje numeric(12,2) = null,
	@qfxjzfje numeric(12,2) = null,
	@tclnzhzfje numeric(12,2) = null,
	@tcxjzfje numeric(12,2) = null,
	@tczfje numeric(12,2) = null,
	@fjlnzhzfje numeric(12,2) = null,
	@fjxjzfje numeric(12,2) = null,
	@dffjzfje numeric(12,2) = null,
	@dnzhye numeric(12,2) = null,
	@lnzhye numeric(12,2) = null,--30
	@jsrq ut_rq16 = '',
	@qkbz smallint = 0
	,@ylcardno ut_cardno=''
	,@ylkje ut_money=0
	,@ylkysje ut_money=0
	,@ylksqxh ut_lsh=''
	,@ylkzxlsh ut_lsh=''
	,@ylkyssqxh ut_lsh=''
	,@ylkyszxlsh ut_lsh=''
	,@yslx int=0 --40
	,@ybdm ut_ybdm=''
	,@zjdm ut_ksdm = null
	,@zmdm ut_ksdm = null
	,@zm ut_mc32 =null
	,@yyrq	ut_rq16=''
	,@zqdm	ut_ksdm=null
	,@jmjsbz ut_bz=0
	,@zzdjh varchar(100) = ''
	,@inghzdxh	ut_xh12=0	
	,@zymzxh ut_xh12 = 0  --��ҽ��ר�Һŷ����
    ,@pbmxxh ut_xh12 = 0
    ,@xmldxx varchar(800)='' --������Ŀ�ַ���
    ,@ghfdm ut_xmdm = ''
    ,@kmdm	ut_xmdm=''
    ,@ghfselectbz varchar(12)=''
    ,@mfghyy	ut_dm2=''
	,@yhdm ut_ybdm=''--�Ż����ʹ���    
	,@kfsdm ut_ybdm=null--app�����̴���
	,@sfyf ut_bz=0 --�Ƿ��Ÿ�
	,@zbdm ut_zddm = '' -- ר������
	,@brlyid ut_czyh='' --������Դid
	,@wlzxyid ut_czyh=''--�������Աid  
	,@hrpbz    ut_bz=''  --1��HRP 
	,@zzdh varchar(100) = '' --ת�ﵥ��
	,@isQygh ut_bz =0 --�Ƿ�ǩԼ�Һ�
as  
/**********
[�汾��]4.0.0.0.0
[����ʱ��]2004.10.25
[����]����
[��Ȩ] Copyright ? 2004-2008�Ϻ����˴�-��������ɷ����޹�˾[����]�ҺŵǼ�
[����˵��]
	�ҺŵǼǹ���
[����˵��]
	@wkdz varchar(32),	������ַ
	@jszt smallint,		����״̬	1=������2=���룬3=�ݽ�
	@ghbz smallint,		�Һű�־: 0=Ԥ�㣬1=�ݽ�(����1), 2=��ʽ�ݽ�(����2)
	@ghlb smallint,		�Һ����0=��ͨ��1=���2=ר�ң�3=����ר�ң�4=����Һţ�5=���6=����Һ�,7= ��Һŷ�, 8=��ѹҺ�
	@czksfbz  int, 		��ֵ���շѱ�־�� 0 :���ӳ�ֵ���շ�  ��1 �ӳ�ֵ���շ� add by szj
	@cfzbz smallint,	�����־��0=���1=����
	@patid ut_xh12,		����Ψһ��ʶ
	@czyh ut_czyh,		����Ա��
  	@ksdm ut_ksdm,		���Ҵ���
  	@ysdm ut_czyh,		ר�Ҵ���
	@ghksdm ut_ksdm,	�Һſ��Ҵ���
 	@sjh ut_sjh = null,	������վݺ�
	@lybz smallint = 0,	�Һ���Դ0=��ͨ��1=ԤԼ 2=�����Һ�
	@yyxh ut_xh12 = null,	ԤԼ���
	@zhbz ut_zhbz = null,	�˻���־
	@zddm ut_zddm = null,	��ϴ���
	@zxlsh ut_lsh = null,	������ˮ��
	@jslsh ut_lsh = null,	������ˮ��
	@xmlb ut_dm2 = null,	����Ŀ
	@qfdnzhzfje numeric(12,2) = null, 	�𸶶ε����˻�֧��
	@qflnzhzfje numeric(12,2) = null,	�𸶶������ʻ�֧��
	@qfxjzfje numeric(12,2) = null,		�𸶶��ֽ�֧��
	@tclnzhzfje numeric(12,2) = null,	ͳ��������ʻ�֧��
	@tcxjzfje numeric(12,2) = null,		ͳ����ֽ�֧��
	@tczfje numeric(12,2) = null,		ͳ���ͳ��֧��
	@fjlnzhzfje numeric(12,2) = null,	���Ӷ������ʻ�֧��
	@fjxjzfje numeric(12,2) = null,		���Ӷ��ֽ�֧��
	@dffjzfje numeric(12,2) = null,		���Ӷεط�����֧��
	@dnzhye numeric(12,2) = null,		�����˻����
	@lnzhye numeric(12,2) = null,		�����˻����
	@jsrq ut_rq16 = ''					��������
	@qkbz smallint = 0					Ƿ���־0��������2��Ƿ��
	,@ylcardno ut_cardno=''
	,@ylkje ut_money=0
	,@ylkysje ut_money=0
	,@ylksqxh ut_lsh=''
	,@ylkzxlsh ut_lsh=''
	,@ylkyssqxh ut_lsh=''
	,@ylkyszxlsh ut_lsh=''
	,@yslx int=0 --40	ҽ������
	,@ybdm ut_ybdm=''	ҽ������
	,@zjdm ut_ksdm = null	������
	,@zmdm ut_ksdm = null	��������
	,@zm ut_mc32 =null	����
	,@yyrq	ut_rq16=''	ԤԼ����
	,@zqdm	ut_ksdm=null	��������
	,@jmjsbz ut_bz=0					��������־0:��������,1:ҽ������,2:��������
	,@zzdjh varchar(100) = ''  ������ҽԺת�ﵥ�ݺ�
	,@ghzdxh	ut_xh12=0		�Һ��˵���ţ��Һ��շ�ȷ�������õ�config(1151)=1��
[����ֵ]
[�����������]
[���õ�sp1]
[����ʵ��]
[�޸ļ�¼]
	modified by hkh  on 20030625  
		������ҺŷѹҺ� (1049)
	20030728 hcy  �Һź���ȡcount(ghhx)
	20030905 tony	ҽ�������޸ģ�
		1��@ghbz=0ʱ���������ֶΣ��Һŷѣ����Ʒѣ�Ԥ�������
		2���˲в��˹ҺŷѲ���
		3������Ԥ�����˴��˻����Ǯ
		4������ҺŹҿ���ʱ���ƷѰ�������ȡ
		5������Һű�־Ϊ1��2�ĳ���ӱ��洢����ɾ��
	20031128 mit ��������1065�жϿ��Լ��˵�ƾ֤����
	modify by szj	 2004.02.19 ��ֵ����Ҫ�ṩ��ghrq
		��ſ����շ������@czksfbz �����������Ƿ�ӳ�ֵ���Ͽ�Ǯ
	2004-03-12 panlian �����ж�70��������Һŷ�
	2004-05-25 ��������Һŵķ��ô�����Ҫ��������Ŀ������
	2004-06-09 lingzhi ���Ӵ�ǰ̨����ҽ�����룬����ʱ�޸Ĳ���ƾ֤����
	2004-06-19 lingzhi ���Ӵ�����������
	W20050313 �����շ���Ŀ���������޼۸�,������������ⲡ�˵����޼۸�����.
		      ˳��:��ִ���շ�С��Ŀ�е����޼۸�,�ٸ���ִ�������շ���Ŀ�е����޼۸�
	2008-01-07 zyh ����ҽ����Ӧ����������
	2008-02-19 zyh ����select @sfje2=@sfje3�����ҽ�������ڹҺ�ʱ���ԷѴ���ʱ�����շѽ��Ϊ0������
**********/
set nocount on

---by dingsong ��������sfksdm��Ĭ��
if(isnull(@ghksdm,'')='')
begin
select @ghksdm=case when isnull(@ksdm,'')='' then (select top 1 id from YY_KSBMK where name like '%����%') else @ksdm end
end

declare 	@config1662		varchar(5),	--��ͯ�Ƿ���գ�'��'or'��'��
		@config1662_js		varchar(5),	--��ͯ����
		@config1630_js     varchar(5), --�������
		@config1665		varchar(2000),	--���Ҽ���
		@config1665_js 		varchar(5),	--�����Ƿ����
		@etnl			varchar(5),	--��ͯ����
		@etbirth		varchar(10),--��ͯ��������
		@nowdate		varchar(10),
		@jsksdm			varchar(8),	--��ͯ���տ��Ҵ���
		@ghxhtmp  ut_xh12
		,@config2613 varchar(200) --add by liuquan vsts29479 ���2613=�񣬲�Ӧ�ý���
		,@config2604 varchar(8)--�����շ�ʱ�Ƿ����HRP�ӿڽ��м۸����㣨Ĭ��Ϊ��
		,@zlfjmlx varchar(8)--���ƷѼ������� 0:�Ÿ�����,1:60�����˼��⣬2��ת�����

select @config1630_js=config from YY_CONFIG(nolock) where id='1630'
select @config1662=config from YY_CONFIG(nolock) where id='1662'
select @config1665=config from YY_CONFIG(nolock) where id='1665'
select @config1662_js='',@etbirth='',@nowdate='',@etnl='',@jsksdm='',@config1665_js=''
select @config2613=ISNULL(config,'��') from YY_CONFIG WHERE id="2613" --add by liuquan vsts29479 ���2613=�񣬲�Ӧ�ý���

if cast(@config1630_js as int)>0 AND @config1662='��'
begin
	select @etbirth=birth from SF_BRXXK where patid=@patid
	select @nowdate=convert(char(8),getdate(),112)
	select @etnl=DATEDIFF( YEAR, @etbirth, @nowdate)
	if cast(@etnl as int)<=cast(@config1630_js as int)
		set @config1662_js='��'
end

if (ltrim(rtrim(@config1665))='' or charindex(','+ltrim(rtrim(@ksdm))+',',ltrim(rtrim(@config1665)))>0) and @config1662='��'
begin
		set @config1665_js='��'
end
--��ȡ����2604 ��ȥ�ո�
select @config2604=config from YY_CONFIG(nolock) where id='2604'
select @config2604=ltrim(rtrim(@config2604))

--���ɵݽ�����ʱ��
declare @tablename varchar(32),
		@ysbz smallint,
        @ksorys smallint,--ghf,zlfѡ���ҵĻ���ҽ����--������������
		@gfyyxh ut_xh12 
		,@config1151	VARCHAR(200)
        --,@fsdgh  ut_bz  --��ʱ��ιҺű�־
        ,@pbmxxh_temp ut_xh12
        ,@ghrq  ut_rq16
        ,@hxfs_new  smallint 		/*����ʽ	0 ռ�ŷ�ʽ����ԤԼ�˼��ŹҺž��Ǽ��ţ���ҽ��	
								1 ԤԼ�ź��ֳ��ŷ�����㣬������ԤԼ��Ϊ1 3 5 7 9��������ԤԼ����ֻ�ܹҺ�ԤԼ���ϣ��ֳ�����ֻ�ܹ�2 4 6 8�Ⱥ�
								2 ԤԼ�ź��ֳ����˺�������,���ֳ���ԤԼ���˶��������ȵ�
								3 ��ԤԼ����ԤԼ���ã���ԤԼ�����ֳ��ţ���ԤԼ����ԤԼ�ţ���ģʽ��
								*/
		,@yyghlb ut_bz
		,@kmmc	ut_mc64  
		,@zqmc	ut_mc64  
		,@fbdm	ut_xmdm  
		,@fbmc	ut_mc64  
		,@sfzh  ut_sfzh
		,@hzxm  ut_mc64
		,@fpdybz	ut_bz	--��Ʊ��ӡ��־
		,@zbdm_temp ut_zddm 
		,@yjksbz varchar(10)
		,@config1566 varchar(20)
		,@yjfhbz varchar(2)  			
declare	@outmsg varchar(200)
declare @yjksjh varchar(100)
exec usp_yy_ldjzq @outmsg output
if substring(@outmsg,1,1)='F'
begin
	select	'F',substring(@outmsg,2,200)
	return
end


if exists(select 1 from YY_CONFIG(nolock) where id='1601' and ltrim(rtrim(config))<>'')--���������1601������������Ԥ���������
begin
	select @yjksjh=config from YY_CONFIG(nolock) where id='1601'  --��ÿ��Ҽ���
	select @config1566=config from YY_CONFIG(nolock) where id='1566' --��û�ʿվ�����ݿ�����
	select @yjksbz=charindex(rtrim(@ksdm),@yjksjh)  --�жϴ����ksdm�Ƿ������õĿ��Ҽ�����
	if @yjksbz<>0 --�����˵��Ҫ�жϹ�������ҵĲ����Ƿ�Ԥ���
	begin
		 if object_id('tempdb..#temptableyjxx') is not null 
			 drop table #temptableyjxx
		 create table #temptableyjxx   --������ʱ����뻤ʿվ�洢���صĸò��˵�Ԥ����
			 (
				yjbz varchar(2),
				yjxh varchar(100)
			 )
         --ִ�л�ʿվ�Ĵ洢������ʱ��ʱ��  ��Ϊ����洢û��ʹ��output�����������������ս�� 
		 insert into #temptableyjxx(yjbz,yjxh) exec('exec '+ @config1566+'usp_his5_jzhs_getpatyjxh '+@patid )  
		 select @yjfhbz=yjbz from  #temptableyjxx     	
         --�ж�������ص���F ˵��û��Ԥ��������ܼ����Һ�
		 if @yjfhbz='F' 
		 begin
			 select 'F','���Ҫ�ҵ�ǰ������ң����˱�����Ԥ�죬��Ϊû��Ԥ����Ϣ�����Բ��ùҺ�.'  
			 return  		 
		 end	 
	end 
end


--�Ƿ�ֻ����Ժ��ְ����ѹҺ�
if exists(select 1 from YY_CONFIG(nolock) where id='1351' and config='��') and @ghlb=8
begin
	select @sfzh=sfzh,@hzxm=hzxm from SF_BRXXK (nolock) where patid=@patid
	if isnull(@sfzh,'')=''
	begin
        select 'F','���֤��Ϊ�գ����ܹ���Ѻ�'
        return
    end
    if not exists(select 1 from YY_ZGBMK (nolock) where name=@hzxm and sfzh=@sfzh and jlzt=0)
    begin
        select 'F','�Ǳ�Ժְ�������ܹ���Ѻ�'
        return
    end 
    if not exists(select 1 from SF_BRXXK (nolock) where patid=@patid and cardtype=2) and 
       not exists(select 1 from SF_BRCARD (nolock) where patid=@patid and cardtype=2)
    begin
        select 'F','���˿����Ͳ�Ϊ���Ͽ������ܹ���Ѻ�'
        return
    end
end
			
				
SELECT @config1151="0"
SELECT @config1151=ISNULL(config,0) FROM YY_CONFIG(nolock) WHERE id="1151"

--if (select config from YY_CONFIG (nolock) where id='1171')='��'
--    select @fsdgh=1
--else
--    select @fsdgh=0
    
select @hxfs_new = -1
select @hxfs_new = config from YY_CONFIG (nolock) where id = '1235'
if @hxfs_new is null
    select @hxfs_new = 0
    
--��ͨ�Һ��Ƿ�ѡҽ��
select @ysbz=(case when config='0' then 0 else 1 end) from YY_CONFIG (nolock) where id='1012'
--�ǣ�ghf��zlf��ȡ��ҽ���������ǿ���
select @ksorys=(case when config='��' then 0 else 1 end) from YY_CONFIG (nolock) where id='1105'--ֻ����1012Ϊ��ʱ����Ч

select @tablename='##mzgh'+@wkdz+@czyh
---cjt �Զ��Һų����ﴦ��
----if @lybz=2 
----begin
----	select @cfzbz=isnull(ghbz,'0') from SF_BRXXK where patid=@patid  
----end
--delete by yxc �Ժ��Զ��Һ�Ҳ����ѡ���������-----

/*add by mxd for vsts:237239 �Զ��Һſ��ܴ��ڲ�ѡ��������������-1 2017.12.05*/	
if @cfzbz=-1
begin
	select @cfzbz=isnull(ghbz,'0') from SF_BRXXK where patid=@patid  
end

declare @iskmgh ut_bz
select @iskmgh= case  when config= '��' then 1 else 0 end   from YY_CONFIG (nolock) where id='1319'   
select @iskmgh=ISNULL(@iskmgh,0)
if  @iskmgh=1 and exists (select 1 from YY_CONFIG WHERE id='1188' and config='��')
begin
	select 'F','�������ô�������ϵ����Ա������1188��1319����ͬʱΪ���ǡ���'
	return
end



 
declare @strmorning char(5),
@strnoon char(5),
@strnight char(5),
@sjdsm varchar(10),
@sjdjl ut_mc32,
@hour varchar(8)

set @hour=substring(convert(char(8),getdate(),8),1,5)

select @strmorning=isnull(convert(char(5),config),'07:30') from YY_CONFIG (nolock) where id='1018'   --��������ָ�ʱ��
select @strnoon=isnull(convert(char(5),config),'12:00') from YY_CONFIG (nolock) where id='1016'      --��������ָ�ʱ�� 
select @strnight=isnull(convert(char(5),config),'17:30') from YY_CONFIG (nolock) where id='1017'      --�������Ϸָ�ʱ��
if @hour>=@strmorning and @hour<@strnoon
	select @sjdsm='����',@sjdjl=@strmorning+'-'+@strnoon
else if @hour>=@strnoon and @hour<@strnight
	select @sjdsm='����',@sjdjl=@strnoon+'-'+@strnight
else if @hour>=@strnight
	select @sjdsm='����',@sjdjl=@strnight+'-23:00'
else
	select @sjdsm='δ֪',@sjdjl='00:00-00:00'

if @jszt=1
begin
	exec('if exists(select * from tempdb..sysobjects where name="'+@tablename+'")
		drop table '+@tablename)
	exec('create table '+@tablename+'(
		ghlb smallint not null,
		cfzbz smallint not null,
		ksdm ut_ksdm not null,
		ysdm ut_czyh not null,
		lybz smallint not null,
		yyxh ut_xh12 not null,
		yyrq ut_rq16 null
		,zqdm	ut_ksdm null
		,xzks_id ut_ksdm null
	    ,zymzxh ut_xh12  null --��ҽ��ר�Һŷ����
        ,pbmxxh ut_xh12  null
        ,xmldxx varchar(800) null  --������Ŀ��Ϣ
        ,kmdm  ut_xmdm null
        ,zbdm ut_zddm null
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
	declare @cghlb varchar(2),
			@ccfzbz varchar(2),
			@clybz varchar(2),
			@cyyxh varchar(12),
			@cyyrq varchar(16),
            @cpbmxxh ut_xh12,
            @ckmdm varchar(16),
            @czbdm ut_zddm 

	select 	@cghlb=convert(varchar(2),@ghlb),
			@ccfzbz=convert(varchar(2),@cfzbz),
			@clybz=convert(varchar(2),@lybz),
			@cyyxh=convert(varchar(12),@yyxh),
			@cyyrq=convert(varchar(16),@yyrq),
            @cpbmxxh=convert(varchar(12),@pbmxxh),   
            @ckmdm=convert(varchar(12),@kmdm)  
			,@czbdm = @zbdm
	exec('insert into '+@tablename+' values('+@cghlb+','+@ccfzbz+',"'+@ksdm+'","'+@ysdm+'",'+@clybz+','+@cyyxh+',"'+@cyyrq+
		'","'+@zqdm+'","'+@ksdm+'",'+@zymzxh+','+@cpbmxxh+',"'+@xmldxx+  '","'+@ckmdm+'","'+@czbdm+'")')
	if @@error<>0
	begin
		select "F","������ʱ��ʱ����"
		return
	end
	select "T"
	return
end
declare	@now ut_rq16,		--��ǰʱ��
		@brybdm ut_ybdm,	--����ҽ������
		@zfbz smallint,		--������־
		@rowcount int,
		@error int,
		@zje ut_money,		--�ܽ��
		@zfyje ut_money,	--�Էѽ��
		@yhje ut_money,		--�Żݽ��
		@ybje ut_money,		--������ҽ������Ľ��
		@pzlx ut_dm2,		--ƾ֤����
		@sfje ut_money,		--ʵ�ս��
		@sfje1 ut_money,	--ʵ�ս��(�����Էѽ��)
		@errmsg varchar(50),
		@srbz char(1),		--�����־
		@srje ut_money,		--������
		@sfje2 ut_money,	--������ʵ�ս��
		@xhtemp ut_xh12,
		@ksmc ut_mc32,		--��������
		@ysmc ut_mc64,		--ҽ������
		@xmzfbl float,		--��Ŀ�Ը�����
		@xmce ut_money,		--�Ը����ʹ����Ը������ܵĲ��
		@fph bigint,			--��Ʊ��
		@fpjxh ut_xh12,		--��Ʊ�����
		@print smallint,	--�Ƿ��ӡ0��ӡ��1����
		@ghhx int,			--�Һź���
		@ghzdxh ut_xh12,	--�Һ��˵����
		@brlx ut_dm2,		--��������
		@pzh ut_pzh,		--ƾ֤��
		@qkbz1 smallint,	--Ƿ���־0��������1�����ˣ�2��Ƿ��
		@zhje ut_money,		--�˻����
		@qkje ut_money,		--Ƿ������˽�
		@cardno ut_cardno,	--����
		@cardtype ut_dm2 ,	--������
		@config  varchar(255),   --YY_CONFIG�е�config
		@config1  varchar(255),   --YY_CONFIG�е�config '1051'��ͨ�Һ�ѡҽ���Ƿ�ֻ��ѡҽ��վֵ��ҽ��
		@config2  varchar(255),   --YY_CONFIG�е�config '1053'��'1051'Ϊ��ʱ�Һŷ����Ʒ�ȡ��ҽ�������ǿ���
		@scybdm ut_ybdm,	--�˲в���ҽ������
		@yjbz ut_bz,		--�Ƿ�ʹ�ó�ֵ��
		@yjye ut_money,		--Ԥ�������
		@ybldbz varchar(2),	--ҽ���Ƿ���������
		@ghf ut_money,		--�Һŷ�
		@zlf ut_money,		--���Ʒ�
		@qrbz ut_bz,		--ȷ�ϱ�־0����ȷ�ϣ�1δȷ�ϣ�2��ȷ��
		@yjyebz varchar(2),	--��ֵ�������Ƿ���������շ�
		@yjdybz varchar(2),	--��ֵ���Һ��Ƿ��ӡ��Ʊ
		@jsfs ut_bz,		--���㷽ʽ
		@tcljbz ut_bz,		--ͳ���ۼƱ�־
		@tcljje ut_money,	--ͳ���ۼƽ��򱣡��½��ػ�ʹ�ã� 
		@config3 varchar(2), 	--YY_CONFIG�е�1071
		@birth varchar(16),
		@yyxh_new ut_xh12,
		@mzlcbz  	ut_bz	--�������̱�־(0-��ͳģʽ��1-�Ż�ģʽ��2-����ģʽ)
		,@qkje2  ut_money   	--�����˻�֧��������λС��
		,@sfje_caclsr ut_money  --�������ʱ������������
		,@zfyje_sc ut_money  	--�˲в��˵��Է�ҩ���
		,@csybdm varchar(255)	--����ҽ������
		,@ghldbz varchar(2)	--�Һ��Ƿ�����
		,@issyzzgh ut_bz	--�Ƿ����������Һ�
		,@jmje	ut_money	--������
		,@tsrydm ut_dm2		--������Ա����
		,@yydj ut_bz		--ҽԺ�ȼ� 
		,@jmghf ut_money --����Һŷ�
		,@jmzlf ut_money --�������Ʒ�
		,@jmghfbl float
		,@jmzlfbl float 
		,@sfje_zzjsq ut_money		--ת�����ǰʵ�ս��
		,@xzks_id ut_ksdm
		,@sfje3 ut_money
		,@hznl   int ---�������� cjt 20110913  	
		,@sex   ut_sex ---�����Ա� 20121217
		--,@config1334 varchar(5)  --�Ƿ����zdfz
		,@ynyhje numeric(12,2) --Ժ���Żݽ��
		--��Ա�������޸��������� zwj 2006.12.12
		,@tsghksdm ut_ksdm  --����Һſ��Ҵ���ghlb=4ʱ
		,@tsghksmc ut_mc32 --����Һſ�������
declare @hykmsbz ut_bz		--��Ա��ģʽ��־
	,@hysybz ut_bz		--��Աʹ�ñ�־(YY_YBFLK��hysybz)
	,@yyxh1  ut_xh12	--ԤԼ���
	,@djje	 ut_money	--������
	,@gsbz	ut_bz		--��ʧ��־
	,@ghfdm_hb ut_xmdm
	,@zlfdm_hb ut_xmdm
	,@hbdm ut_xmdm -- �ű�
	,@isUsehb int -- �Ƿ�ʹ�úű���� 1 ʹ��0 ��ʹ��
	,@config1501 varchar(4)

select @now=convert(char(8),getdate(),112)+convert(char(8),getdate(),8),
	@zje=0, @zfyje=0, @yhje=0, @ybje=0,
	@sfje=0, @sfje1=0, @srje=0, @sfje2=0, 
	@xmzfbl=0, @xmce=0, @print=0, @ghhx=0,
	@qkbz1=0, @qkje=0, @yjbz=0, @yjye=0, @ghf=0, @zlf=0, @qrbz=0,
	@jsfs=0, @tcljbz=0, @tcljje=0,@zfyje_sc = 0,@issyzzgh=0,@jmje=0,@jmzlf = 0,@jmghf = 0 
	,@sfje_zzjsq = 0,@hznl=0,@fpdybz=0
if exists(select 1 from YY_CONFIG where id='1124' and config='��')
	select @issyzzgh=1
--ȡ��ҽԺ�ȼ�
select @yydj=c.yydj from YY_KSBMK k(nolock),YY_JBCONFIG c (nolock)
            where k.id= @ksdm and k.yydm=c.id 
select @yydj = isnull(@yydj,1)

if exists(select 1 from YY_CONFIG where id='1500' and config='��')
	select @isUsehb=1
else
	select @isUsehb = 0
	
select @config1501 = config from YY_CONFIG where id='1501'

declare @sfly ut_bz
	if (@sjh='zzj' or @sjh='zzsf') select @sfly=1
	if @sjh='yszdy' select @sfly=2
	if @sjh='mzyj'  select @sfly=3
	if @sjh='SJH' select @sfly=0
select @tsghksdm=rtrim(ltrim(isnull(config,''))) from YY_CONFIG(nolock) where id='1599'
if @tsghksdm<>''
  select @tsghksmc=name from YY_KSBMK(nolock) where id=@tsghksdm
/*if exists (select 1 from YY_CONFIG(nolock) where id='1334' and config='��')
  select @config1334='��'
else
  select @config1334='��'*/
--�Һ�Ԥ��
if @ghbz=0
begin
	--��ʼ�ҺŴ�������
	create table #mzghtmp        --��ʱ��ŹҺź����Ʒ���Ϣ
	(
		ghxh ut_xh12 identity not null,
		ghlb smallint not null,
		cfzbz smallint not null,
		ksdm ut_ksdm not null,
		ksmc ut_mc32 null,
		ysdm ut_czyh not null,
		ysmc ut_mc64 null,
		lybz smallint not null,
		yyxh ut_xh12 not null,
		yyrq ut_rq16 null
		,zqdm	ut_ksdm null
		,xzks_id ut_ksdm null
		,zymzxh ut_xh12 null --��ҽ��ר���
        ,pbmxxh ut_xh12 null --�Ű���ϸ���
        ,xmldxx varchar(800) null  --������Ŀ��Ϣ
         ,kmdm  ut_xmdm null  --��Ŀ����
		,kmmc	ut_mc64 null
		,zqmc	ut_mc64 null
		,fbdm	ut_xmdm null
		,fbmc	ut_mc64 null
		,zbdm ut_zddm null
	)
	
	exec('insert into #mzghtmp(ghlb, cfzbz, ksdm, ysdm, lybz, yyxh, yyrq, zqdm, xzks_id,zymzxh,pbmxxh,xmldxx,kmdm,zbdm) 
		  select * from '+@tablename)

	if @@error<>0
	begin
		select "F","������ʱ��ʱ����"
		return
	end
	
	exec('drop table '+@tablename)   --�ݽ��������
	create table #ghmx_ldxm   --������Ŀ��
	(
		ghxh ut_xh12 not null,
		xmdm ut_xmdm not null,
		xmsl ut_sl10 not null,
		xmdj varchar(12) null
	)
    declare @strtemp varchar(300),@xmdm_temp ut_xmdm,@xmsl_temp varchar(12),@ghzdxh_temp ut_xh12,@xmldxx_temp varchar(800),@xmdj_temp varchar(12)
    if exists(select 1 from #mzghtmp where xmldxx<>'')
	begin
		declare cs_mzgh_ld cursor for
		select ghxh,xmldxx from #mzghtmp for read only
		open cs_mzgh_ld
		fetch cs_mzgh_ld into @ghzdxh_temp,@xmldxx_temp
		while @@fetch_status=0
		begin  
			while charindex('$',@xmldxx_temp)>0 
			begin
				select @strtemp=substring(@xmldxx_temp,1,charindex('$',@xmldxx_temp)-1)
				select @strtemp  = substring(@strtemp,charindex('|',@strtemp)+1,len(@strtemp)-charindex('|',@strtemp))   --ȥ����һ��
				select @xmdm_temp=substring(@strtemp,1,charindex('|',@strtemp)-1) 
				select @strtemp  = substring(@strtemp,charindex('|',@strtemp)+1,len(@strtemp)-charindex('|',@strtemp))    --ȥ���ڶ���
				select @strtemp  = substring(@strtemp,charindex('|',@strtemp)+1,len(@strtemp)-charindex('|',@strtemp))    --ȥ��������
				select @xmsl_temp=substring(@strtemp,1,charindex('|',@strtemp)-1) 
				--ȡ���еĵ���
		        select @xmdj_temp=substring(@strtemp,charindex('|',@strtemp)+1,len(@strtemp)-charindex('|',@strtemp))
				select @xmdj_temp=substring(@xmdj_temp,1,charindex('|',@xmdj_temp)-1)
                insert into #ghmx_ldxm(ghxh,xmdm,xmsl,xmdj)  
				values(@ghzdxh_temp,@xmdm_temp,@xmsl_temp,@xmdj_temp)
				select @xmldxx_temp=substring(@xmldxx_temp,charindex('$',@xmldxx_temp)+1,len(@xmldxx_temp)-charindex('$',@xmldxx_temp))
			end 			
			fetch cs_mzgh_ld into @ghzdxh_temp,@xmldxx_temp
		end
		close cs_mzgh_ld
		deallocate cs_mzgh_ld  
	end
	/*�жϳ���֢*/
	if exists(select 1 from #mzghtmp where cfzbz=0)
	begin
		update #mzghtmp set cfzbz=0 where ghxh=1
		update #mzghtmp set cfzbz=1 where ghxh>1
	end

	select patid,blh,hzxm,wb,py,cardno,zypatid,sbh,qtkh,sfzh,sex,birth,lxdz,lxdh,yzbm,lxr,ybdm,pzh,dwbm,dwmc,qxdm,zhje,
	    ljje,zhszrq,zjrq,czyh,lrrq,tybz,cardtype,zhbz,memo,csd_s,csd_x,ghbz,ylxm,dyid,centerid,ekfmxm,czrq,gms,xgh,cth,
	    mrh,qth,hyzk,gjbm,email,lxsj,zcbm,zwbm,xlmc,ztqk,brjob,zydm,mzzyk,qysj,spzlx,gxybz,gxycbcs,gzdm,jgsrq,gxyszbz,
	    jkdabz,xl,brnldw,brnldw1,ssdw,tsbz,tyczyh,tyrq,lxr_s,qytt,qyys,rylb,fzid,grxp,tjlb_id,mzdm,bmmc,shhjh,lxdz_s,
	    lxdz_x,zggh,zl,xyclcs,chssid,bkh,mzdblh,zrysdm,ssks,nsccy,fzname,bjh,gwydm,sfzly,bmbz,bmhm,zzid,dahid,zcsq,zcbz,
	    zjghxh,tsbzdmjh,zjlx,empi,jhrxm,jhrzjlx,jhrsfzh,gxrq,qybrsyid,ay,birthtime,bmdm,
	    txfwbz,xxmc,yynr,tsts,qebzkh,yhdm,hfbz,lxrgx,lxrdh 
	into #brxxk from SF_BRXXK(nolock) where patid=@patid
	if @@rowcount=0 or @@error<>0
	begin
		select "F","�ҺŻ��߲����ڣ�"
		return
	end

	--add by yangdi 2020.1.1 ��������ͨ�������������㣬������ʵ�������.
	select @pzh=pzh, @zhje=zhje, @cardno=cardno, @cardtype=cardtype, @tcljje=isnull(ljje,0), @brybdm=ybdm ,
		@hznl=dbo.FUN_GETBRNL_EX(birth,CONVERT(CHAR(8),GETDATE(),112)+CONVERT(CHAR(8),GETDATE(),108),1,0,NULL),@sex=sex from #brxxk

	--qinfj  20180529  ����������ڲ���ֵʱ������Һţ��������������31ʱ������Ҷ���      
 if exists(select 1 from YY_CONFIG (nolock) where  charindex(rtrim(@ksdm),config)>0 and id='1231')      
 BEGIN      
  if exists(select 1 from YY_CONFIG (nolock) where id='1230' and config<>'-1' and config<=@hznl)       
   begin      
    --select "F","�ҺŻ����������14�꣨����14�꣩���ܹҶ��ơ���ͯ�����ƣ�"   
    select top 1 "F","�ҺŻ����������14�꣨����14�꣩���ܹ�"+name+"��" from YY_KSBMK where id=@ksdm    --winning-dsong-chongqing   
    return      
   end      
 END    

  --add by yangdi 2019.3.13 �Һ��������    
if exists(select 1 from YY_CONFIG (nolock) where  charindex(rtrim(@ksdm),config)>0 and id='X004')      
 BEGIN      
  if exists(select 1 from YY_CONFIG (nolock) where id='1230' and config<>'-1' and config>@hznl)       
   begin      
    --select "F","�ҺŻ�������С��14�꣡"   
    select top 1 "F","�ҺŻ�������С��14�꣡���ܹ�"+name+"��" from YY_KSBMK where id=@ksdm    --winning-dsong-chongqing     
    return      
   end      
 END    
 
 IF RTRIM(@sex) = '��'      
 BEGIN      
     if exists(select 1 from YY_CONFIG (nolock) where  charindex(rtrim(@ksdm),config)>0 and id='1294')      
  BEGIN      
      --select "F","���Ի��߲��ܹҸ��ơ����ƣ�"   
      select top 1 "F","���Ի��߲��ܹ�"+name+"��" from YY_KSBMK where id=@ksdm    --winning-dsong-chongqing         
  return      
  END      
 END         

	-- 14�����¶��Ʋ��˹��������һ�ҽ��Ҫ����  add by jch 20160818
	if (@config1501 = '��') and (exists(select 1 from YY_CONFIG (nolock) where id='1230' and config<>'-1' and config>=@hznl))
	--and (not exists(select 1 from YY_CONFIG (nolock) where  charindex('"'+rtrim(@ksdm)+'"',config)>0 and id='1231'))
	begin
		-- �ҵķǶ��ƿ���
		if (not exists(select 1 from YY_CONFIG (nolock) where  charindex('"'+rtrim(@ksdm)+'"',config)>0 and id='1231')) 
		begin
			--û��Ȩ�޵Ŀ��һ�û��Ȩ�޵�ҽ��
			if (not exists(select 1 from GH_ETKSYSSZK where pbkm = @ksdm and pblx = 1)) and 
			(not exists(select 1 from GH_ETKSYSSZK where pbkm = @ysdm and pblx = 0))
			begin
				select 'F','�����ҵĿ��һ�ҽ�������߱�����ͯ���ߵ�Ȩ��'
				return
			end
		end
	end 

	if (select config from YY_CONFIG (nolock) where id='1078')='��' or @ybdm=''
		select @ybdm=@brybdm

	--��ʼ����Һ���Ŀ
	create table #ghmx
	(
		ghxh ut_xh12 not null,
		xmdm ut_xmdm null,
		xmsl ut_sl10 not null,
		isghf  int   not null  --0:������1:�Һŷ�2:���Ʒ�
	)

	if (select config from YY_CONFIG where id = '1204') = '��'
	begin
		if exists(select 1 from YY_CONFIG (nolock) where id='1188' and config = '��')  
		begin 
			declare @ghsl int,@xzybdm varchar(100),@flag varchar(1)
		  --��ģʽ�ϲ� aorigele 2011-6-2	
	      --if not exists(select 1 from YY_CONFIG (nolock) where id='1218' and config = '��')
			if @hxfs_new = 3
			begin
				-- �°�ԤԼ�Һ�ʹ��(����ҽ������ÿ��ֻ�ܹ���������Ϊ������ͬ����/ҽ������Ҫ�˹��ܿ����α���)  add by sdb 2010-11-19  		   
				--��ȡ1203 �������õ�ֵ  
				--declare @xzybdm varchar(100);  
				select @xzybdm = config from YY_CONFIG where id = '1203'   
				if @ghlb = 0 --��ͨ����  
				begin  
					if exists(    
						select 1  from GH_GHZDK a(nolock)   
						where a.patid = @patid   
							and SUBSTRING(a.ghrq,1,8) = SUBSTRING(@now,1,8)     
							and ghlb = @ghlb      
							and ksdm = @ksdm  
							and ybdm not in (@xzybdm) ---lza0324   
							and fzbz in('0','1','2','3')  --0:δ���1���2���3�������� ��:�������������5:�����У�����)    
							and jlzt = 0    
						)     
					begin    
						if @lybz='2' --������ֱ����ʾ  
						begin  
							select 'F','���Ѿ��ҹ��ÿ��ң������ٹ�'  --ҽ������ÿ��ֻ�ܹ���������Ϊ������ͬ����    
							return  
						end  
					end    
				end    
				else if @ghlb = 2  --ҽ��    
				begin    
					if exists(    
						select 1 from GH_GHZDK a(nolock)   
						where a.patid = @patid   
						and SUBSTRING(a.ghrq,1,8) = SUBSTRING(@now,1,8)     
						and ghlb = @ghlb      
						and ysdm = @ysdm  
						and ybdm not in (@xzybdm) ---lza0324   
						and fzbz in('0','1','2','3')  --0:δ���1���2���3�������� ��:�������������5:�����У�����)    
						and jlzt = 0    
						)     
					begin    
						if @lybz='2' --������ֱ����ʾ  
						begin  
							select 'F','���Ѿ��ҹ���ҽ���������ٹ� '  --ҽ������ÿ��ֻ�ܹ���������Ϊ������ͬ����    
							return  
						end  
					end   
				end;     
			end              
		  -- �°�ԤԼ�Һ�ʹ��(����ҽ������ÿ��ֻ�ܹ���������Ϊ������ͬ����/ҽ������Ҫ�˹��ܿ����α���) add by sdb 2010-11-19 END 
		end
		else
		begin
			-- �°�ԤԼ�Һ�ʹ��(����ҽ������ÿ��ֻ�ܹ���������Ϊ������ͬ����/ҽ������Ҫ�˹��ܿ����α���)  add by sdb 2010-11-19
			if exists(select 1 from YY_CONFIG (nolock) where id='1188' and config = '��')
			begin				
				select @xzybdm = config from YY_CONFIG(nolock) where id = '1203'
				
				set @flag = '0' 
				
				if CHARINDEX('"' + RTrim(LTRIM(@ybdm)) + '"',@xzybdm) <> 0 
					select @flag = '1'	  
				 
				if @flag = '0'  
				begin
					if @ghlb = 0 --��ͨ����
					begin
						select @ghsl = COUNT(*) from GH_GHZDK a(nolock) where a.patid = @patid and SUBSTRING(a.ghrq,1,8) = SUBSTRING(@now,1,8)
						if @ghsl >= 2
						begin
							select 'F','ҽ������ÿ��ֻ�ܹ���������Ϊ������ͬ����'
							return 
						end

						if exists(
							select 1 from GH_GHZDK a(nolock) where a.patid = @patid and SUBSTRING(a.ghrq,1,8) = SUBSTRING(@now,1,8) 
								and ghlb = 0  
								and ksdm = @ksdm
								and fzbz in('0','1','2')  --0:δ���1���2���3�������� ��:�������������5:�����У�����)
								and jlzt = 0
						)
						begin
							select 'F','��������ϴξ���'  --ҽ������ÿ��ֻ�ܹ���������Ϊ������ͬ����
							return
						end
					end
					else if @ghlb = 2  --ҽ��
					begin
						select @ghsl = COUNT(*) from GH_GHZDK a(nolock) where a.patid = @patid and SUBSTRING(a.ghrq,1,8) = SUBSTRING(@now,1,8)
						if @ghsl >= 2
						begin
							select 'F','ҽ������ÿ��ֻ�ܹ���������Ϊ������ͬҽ��'
							return 
						end
						
						if exists(
							select 1 from GH_GHZDK a(nolock) where a.patid = @patid and SUBSTRING(a.ghrq,1,8) = SUBSTRING(@now,1,8) 
								and ghlb = 2 
								and ysdm = @ysdm 
								and fzbz in('0','1','2')  --0:δ���1���2���3�������� ��:�������������5:�����У�����)
								and jlzt = 0
						)
						begin
							select 'F','��������ϴξ���'
							return
						end  
					end		     
				end
			end	
			-- �°�ԤԼ�Һ�ʹ��(����ҽ������ÿ��ֻ�ܹ���������Ϊ������ͬ����/ҽ������Ҫ�˹��ܿ����α���) add by sdb 2010-11-19 END 
		end
	end
	
	select @config = config from YY_CONFIG(nolock) where id='1049'
	select @config1 = config from YY_CONFIG (nolock)where id='1051'
	select @config2 = config from YY_CONFIG(nolock) where id='1053'
	if @@rowcount=0 or @@error<>0
	begin
		select "F","��ҺŷѹҺ����ò���ȷ��"
		return
	end

	select @scybdm = config from YY_CONFIG(nolock) where id='1030'
	if @@rowcount=0 or @@error<>0
	begin
		select "F","�˲зѱ����ò���ȷ��"
		return
	end

	select @ybldbz = config from YY_CONFIG(nolock) where id='1059'
	if @@rowcount=0 or @@error<>0
	begin
		select "F","ҽ���Һ��������ò���ȷ��"
		return
	end

	select @ghldbz = config from YY_CONFIG(nolock) where id='1004'
	if @@rowcount=0 or @@error<>0
	begin
		select "F","�Һ��������ò���ȷ��"
		return
	end


	select @yjyebz = config from YY_CONFIG(nolock) where id='1058'
	if @@rowcount=0 or @@error<>0
	begin
		select "F","��ֵ�������Ƿ���������շ����ò���ȷ��"
		return
	end

	select @yjdybz = config from YY_CONFIG(nolock) where id='1056'
	if @@rowcount=0 or @@error<>0
	begin
		select "F","ʹ�ó�ֵ���Ƿ��ӡ�Һŷ�Ʊ���ò���ȷ��"
		return
	end

	select @mzlcbz = config from YY_CONFIG(nolock) where id='0037'
	if @@rowcount=0 or @@error<>0
	begin
		select "F","��������ģʽ���ò���ȷ��"
		return
	end
	
	select @csybdm = ltrim(rtrim(config)) from YY_CONFIG(nolock) where id = '1106'
	if @@error<>0
	begin
		select "F","����ҽ���������ò���ȷ��"
		return
	end
	
	--���ۿ���¼���������Ŀ
	if exists(select 1 from YY_CONFIG (nolock) where charindex('"'+rtrim(@ybdm)+'"',config)>0 and id='2082')
		select @tcljbz=1
	else
		select @tcljje=0
	--ͳ����������õ�ҽ������
	if exists(select 1 from YY_CONFIG (nolock) where charindex('"'+rtrim(@ybdm)+'"',config)>0 and id='0115')
	begin
		select @tcljje=tcljje from YY_BRLJXXK(nolock)  where cardno = @cardno and cardtype = @cardtype		
	end
	--������
	if (@cardtype='2') or (@cardtype='1' and datalength(@cardno)=28)
		insert into #ghmx select a.ghxh, b.config, 1,0 from #mzghtmp a, YY_CONFIG b  
		where a.cfzbz=0 and b.id in ('1002')  --����������
	else
		insert into #ghmx select a.ghxh, b.config, 1,0 from #mzghtmp a, YY_CONFIG b  
		where a.cfzbz=0 and b.id in ('1002', '1003')  
	-- ���ݲ�ͬ��Ҫ���빤���ѻ�ſ���
	INSERT INTO #ghmx SELECT a.ghxh, b.config, 1, 0 FROM #mzghtmp a, YY_CONFIG b
	WHERE a.cfzbz=2 AND b.id IN ("1002")	-- ���ﲹ�չ�����
	INSERT INTO #ghmx SELECT a.ghxh, b.config, 1, 0 FROM #mzghtmp a, YY_CONFIG b
	WHERE a.cfzbz=3 AND b.id IN ("1003")	-- ���ﲹ�մſ���

	select @zfbz=zfbz, @pzlx=pzlx, @brlx=brlxdm, @qkbz1=zhbz, @jsfs=jsfs,@tsrydm=tsrydm, @hysybz=hysybz from YY_YBFLK (nolock) where ybdm=@ybdm
	if @@rowcount=0 or @@error<>0
	begin
		select "F","���߷��������ȷ��"
		return
	end
	
	select @hykmsbz = config from YY_CONFIG(nolock) where id='0099'
	if @@error<>0
	begin
		select "F","�����Ա��ģʽ���ò���ȷ��"
		return
	end

	--ȡԤԼ����Ľ��
	select @djje=0
	select @djje=isnull(djje,0) from GH_GHYYK(nolock) where xh=@yyxh and djbz=1

	if @hykmsbz=0
	begin
		select @yjye=isnull(yjye,0)+@djje,@gsbz=gsbz from YY_JZBRK(nolock) where patid=@patid and jlzt=0
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
	if exists(select 1 from #mzghtmp where ghlb in (0,1,5,7,8)) and @iskmgh=0 --��ͨ,����,����Һ�, ��Һŷ�
	begin
		--��ģʽֱ��ʹ�ù�����ģʽ aorigele 2011-6-2
		--if exists(select  * from YY_CONFIG (nolock) where id='1218' and config = '��')		
        -- �°�ԤԼ�Һ�ʹ��aorigele 20100730
	
		if exists(select 1 from YY_CONFIG (nolock) where id='1188' and config = '��') 
		   and (exists(select 1 from #mzghtmp where pbmxxh>=0 and ghlb in (0,1,5,8)))--dingsong
		begin
			
			--�������Һš���Һŷ�  ���������ߣ���Ϊ1188�Ķ�û�����ü������Һŷ�
			insert into #ghmx select aa.ghxh, b.ghfdm, 1, 1
			 from #mzghtmp aa,GH_YY_PBZB a(nolock),GH_YY_PBZBMX b(nolock)  
			where a.pbzbid = b.pbzbid and b.pbmxid = aa.pbmxxh
--			  and ((aa.ysdm = a.pbkm)or(aa.ksdm = a.pbkm))   modfiy by yfq for:����ǰ̨��������pbmxidȡ�Ű��еĹҺŷ�
			insert into #ghmx select aa.ghxh, b.zlfdm, 1, 2
			 from #mzghtmp aa,GH_YY_PBZB a(nolock),GH_YY_PBZBMX b(nolock)  
			where a.pbzbid = b.pbzbid and b.pbmxid = aa.pbmxxh
--			  and ((aa.ysdm = a.pbkm)or(aa.ksdm = a.pbkm))   modfiy by yfq for:����ǰ̨��������pbmxidȡ�Ű��е�����
            ----add by sqf  for :���һ�ιҺ�ѡ����ң������е������Ű��е������Ű���Һŷ��㲻��
			insert into #ghmx select a.ghxh, (case a.ghlb when 0 then b.ghf_pt when 1 then b.ghf_jz when 5  then b.ghf_pt when 7 then b.ghf_pt when 8 then b.ghf_pt else b.ghf_ts end), 1,1 
				from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb in (0,1,4,5,7,8) and b.id=a.ksdm
                     and a.pbmxxh <= 0
			insert into #ghmx select a.ghxh, (case a.ghlb when 0 then b.zlf_pt when 1 then b.zlf_jz when 4 then b.zlf_ts else b.zlf_pt end), 1,2
			from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb in (0,1,4,5,7,8) and b.id=a.ksdm
                     and a.pbmxxh <= 0
			 
		end		
		else --��ģʽ����
		begin
			if @config1='��' and @config2='��' --����ȡ��ҽ����������,������Ϊҽ��û�м�����ã�����ȡ��ͨ���� --agg 2003.08.27
			begin
			    if @ghlb = 7
			    begin
		--			if @ybdm<>@scybdm
		--			begin
					if @config='��' --���Ѳ��˹ҵڶ��������չҺŷ�
				    begin
				    if isnull(@ysdm,'') <> ''  --ר��
				    begin
						insert into #ghmx select a.ghxh,'', 1,1 
							from #mzghtmp a, YY_ZGBMK b(nolock) where a.ghlb in (0,1,4,5,7,8) and b.id=a.ysdm
							
						insert into #ghmx select a.ghxh,b.zlf, 1,2 
							from #mzghtmp a, YY_ZGBMK b(nolock) where a.ghlb in (0,1,4,5,7,8) and b.id=a.ysdm
					end
					else  --����
					begin
					    insert into #ghmx select a.ghxh,'', 1,1 
							from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb in (0,1,4,5,7,8) and b.id=a.ksdm
						insert into #ghmx select a.ghxh,b.zlf_pt, 1,2
							from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb in (0,1,4,5,7,8) and b.id=a.ksdm
					end
				end
				else
					if isnull(@ysdm,'') <> ''  --ר��
					begin
						insert into #ghmx select a.ghxh,b.ghf, 1,1 
							from #mzghtmp a, YY_ZGBMK b(nolock) where a.ghlb in (0,1,4,5,7,8) and b.id=a.ysdm
							
						insert into #ghmx select a.ghxh,b.zlf, 1,2 
							from #mzghtmp a, YY_ZGBMK b(nolock) where a.ghlb in (0,1,4,5,7,8) and b.id=a.ysdm	
					end
					else  --����
					begin
					    insert into #ghmx select a.ghxh,'', 1,1 
							from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb in (0,1,4,5,7,8) and b.id=a.ksdm
						insert into #ghmx select a.ghxh,b.zlf_pt, 1,2
							from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb in (0,1,4,5,7,8) and b.id=a.ksdm
					end
				end
				else
				begin
				    if isnull(@ysdm,'')<>'' and @ysbz=1 and @ksorys=1 and exists(select 1 from #mzghtmp where ghlb in (0)) --��ͨ�Һţ�ѡҽ������ҽ����ghf��zlf�շ�
					begin
						insert into #ghmx select a.ghxh,  b.ghf , 1,1 
							from #mzghtmp a, YY_ZGBMK b(nolock) where a.ghlb in (0) and b.id=a.ysdm
						insert into #ghmx select a.ghxh,  b.zlf , 1,2 
							from #mzghtmp a, YY_ZGBMK b(nolock) where a.ghlb in (0) and b.id=a.ysdm
					end
					else
					begin 	
		--			if @ybdm<>@scybdm
		--			begin
						if @config='��'                     
							insert into #ghmx select a.ghxh, (case a.ghlb when 0 then b.ghf_pt when 1 then b.ghf_jz when 5  then b.ghf_pt when 7 then '' when 8 then b.ghf_pt else b.ghf_ts end), 1,1 
								from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb in (0,1,4,5,7,8) and b.id=a.ksdm

						else
							insert into #ghmx select a.ghxh, (case a.ghlb when 0 then b.ghf_pt when 1 then b.ghf_jz  when 5  then b.ghf_pt when 7 then b.ghf_pt when 8 then b.ghf_pt else b.ghf_ts end), 1,1 
								from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb in (0,1,4,5,7,8) and b.id=a.ksdm
		--			end

						insert into #ghmx select a.ghxh, (case a.ghlb when 0 then b.zlf_pt when 1 then b.zlf_jz when 4 then b.zlf_ts else b.zlf_pt end), 1,2
							from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb in (0,1,4,5,7,8) and b.id=a.ksdm
					end 
				end
			end
			else 
			begin
	-- 					select 't',@ksdm,@ysbz,@ksorys ,* from #mzghtmp where ghlb in (0) --hyh
	-- 			return  	
				 --if isnull(@ksdm,'')<>'' and @ysbz=1 and @ksorys=1 and exists(select 1 from #mzghtmp where ghlb in (0)) --��ͨ�Һţ�ѡҽ������ҽ����ghf��zlf�շ� 
				if isnull(@ysdm,'')<>'' and @ysbz=1 and @ksorys=1 and exists(select 1 from #mzghtmp where ghlb in (0)) --��ͨ�Һţ�ѡҽ������ҽ����ghf��zlf�շ�
				begin
					insert into #ghmx select a.ghxh,  b.ghf , 1,1 
						from #mzghtmp a, YY_ZGBMK b(nolock) where a.ghlb in (0) and b.id=a.ysdm
					insert into #ghmx select a.ghxh,  b.zlf , 1,2 
						from #mzghtmp a, YY_ZGBMK b(nolock) where a.ghlb in (0) and b.id=a.ysdm
				end
				else
				begin 	
	--			if @ybdm<>@scybdm
	--			begin
					if @config='��'                     
						insert into #ghmx select a.ghxh, (case a.ghlb when 0 then b.ghf_pt when 1 then b.ghf_jz  when 5  then b.ghf_pt when 7 then '' when 8 then isnull(b.ghf_pt,b.ghf_jz) else b.ghf_ts end), 1,1 
							from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb in (0,1,4,5,7,8) and b.id=a.ksdm

                    else
						insert into #ghmx select a.ghxh, (case a.ghlb when 0 then b.ghf_pt when 1 then b.ghf_jz  when 5  then b.ghf_pt when 7 then b.ghf_pt when 8 then isnull(b.ghf_pt,b.ghf_jz) else b.ghf_ts end), 1,1 
							from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb in (0,1,4,5,7,8) and b.id=a.ksdm
	--			end

					insert into #ghmx select a.ghxh, (case a.ghlb when 0 then b.zlf_pt when 1 then b.zlf_jz when 4 then b.zlf_ts when 8 then isnull(b.zlf_pt,b.zlf_jz) else b.zlf_pt end), 1,2
						from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb in (0,1,4,5,7,8) and b.id=a.ksdm
				end
			end
/*
            if exists(select 1 from #mzghtmp where ghlb in (7)) --��Һŷ�
	        begin
				if isnull(@ysdm,'')<>'' and exists(select 1 from YY_CONFIG WHERE id ='1105' and config = '��')
                begin
					delete from #ghmx --��Ҫɾ����ǰ���п����Ѿ������
					insert into #ghmx select a.ghxh,  b.zlf , 1,2 
						from #mzghtmp a, YY_ZGBMK b where a.ghlb in (7) and b.id=a.ysdm				
				end
			end
*/
		end;
		if (@ybldbz='��' or @pzlx='0') and @ghldbz='��' --ҽ�����˹Һ��Ƿ�����������Ŀ
			--insert into #ghmx select a.ghxh, b.ypdm, b.xmsl,0 
			--	from #mzghtmp a, GH_GHLDK b where a.ghlb in (0,1,4,7) and b.id=a.ksdm and b.lb=1
            insert into #ghmx(ghxh,xmdm,xmsl,isghf) select ghxh,xmdm,xmsl,0 from #ghmx_ldxm
		/*
        if (@ybldbz='��' or @pzlx='0') and @ghldbz='��' --ҽ�����˹Һ��Ƿ�����������Ŀ
			insert into #ghmx select a.ghxh, b.ypdm, b.xmsl,0 
				from #mzghtmp a, GH_GHLDK b 
				where a.ghlb in (0,1,4,7) and b.id=a.ysdm and b.lb=0
         */
	end
	
	if exists(select 1 from #mzghtmp where ghlb=2) and @iskmgh=0 --ר��
	begin 
		--��ģʽֱ��ʹ�ù�����ģʽ aorigele 2011-6-2
		--if exists(select 1 from YY_CONFIG (nolock) where id='1218' and config = '��')
		-- �°�ԤԼ�Һ�ʹ��aorigele 20100730
		if exists(select 1 from YY_CONFIG (nolock) where id='1188' and config = '��')
		   and (exists(select 1 from #mzghtmp where pbmxxh>=0 ))
		begin	
			--�������Һš���Һŷ�  ���������ߣ���Ϊ1188�Ķ�û�����ü������Һŷ�
			insert into #ghmx select aa.ghxh, b.ghfdm, 1, 1
			 from #mzghtmp aa,GH_YY_PBZB a(nolock),GH_YY_PBZBMX b(nolock)  
			where a.pbzbid = b.pbzbid and b.pbmxid = aa.pbmxxh
			  and ((aa.ysdm = a.pbkm)or(aa.ksdm = a.pbkm)) and aa.ghlb=2
			insert into #ghmx select aa.ghxh, b.zlfdm, 1, 2
			 from #mzghtmp aa,GH_YY_PBZB a(nolock),GH_YY_PBZBMX b(nolock)  
			where a.pbzbid = b.pbzbid and b.pbmxid = aa.pbmxxh
			  and ((aa.ysdm = a.pbkm)or(aa.ksdm = a.pbkm)) and aa.ghlb=2
		end
		else
		begin
			insert into #ghmx select a.ghxh, b.ghf, 1 ,1
				from #mzghtmp a, YY_ZGBMK b where a.ghlb=2 and b.id=a.ysdm
			insert into #ghmx select a.ghxh, b.zlf, 1 ,2
				from #mzghtmp a, YY_ZGBMK b where a.ghlb=2 and b.id=a.ysdm
		end;
		if exists(select 1 from #mzghtmp where zymzxh <> 0)
		begin
			update #ghmx set xmdm = b.ghf
				from #mzghtmp a, GH_ZYY_ZJGHFSZ b(nolock),#ghmx c
				where a.zymzxh = b.xh and b.jlzt = 0 and c.isghf = 1 
					and ltrim(rtrim(isnull(b.ghf,''))) <> ''
		end 		    
		--add by sdb 2011-04-25 �����Һ����Ƿ��Զ��ж�����ר�Ҵ��ڳ���͸���ҺŷѵĲ���(�Ϻ���ҽ��һ����û������ҽ���������) BEGIN
		if (select config from YY_CONFIG (nolock) where id = '1219') = '��'
		begin
			if exists (select 1 from GH_ZYY_ZJGHFSZ(nolock) where id = @ysdm and jlzt = 0 and isnull(ghf,'') <> '')
			begin
				declare @ghf_temp ut_xmdm
				
				if not exists(select 1 from GH_GHZDK_MZ(nolock) where patid = @patid and ysdm = @ysdm)
				begin--��һ����û������ҽ��������Ϊ����Һŷ���ȡ���ֵ
				    select @ghf_temp = a.ghf from GH_ZYY_ZJGHFSZ a(nolock), YY_SFXXMK b(nolock),#ghmx c 
						where a.ghf = b.id and a.jlzt = 0 and c.isghf = 1 and a.id = @ysdm order by b.xmdj asc				

					update #ghmx set xmdm = @ghf_temp where isghf = 1
				end
				else
				begin--������Ϊ���ﲡ�ˣ��Һŷ���ȡ��Сֵ
				    select @ghf_temp = a.ghf from GH_ZYY_ZJGHFSZ a(nolock), YY_SFXXMK b(nolock),#ghmx c 
						where a.ghf = b.id and a.jlzt = 0 and c.isghf = 1 and a.id = @ysdm order by b.xmdj desc				

					update #ghmx set xmdm = @ghf_temp where isghf = 1

				end
			end
		end
		--add by sdb 2011-04-25 �����Һ����Ƿ��Զ��ж�����ר�Ҵ��ڳ���͸���ҺŷѵĲ��� END
		
		if (@ybldbz='��' or @pzlx='0') and @ghldbz='��' --ҽ�����˹Һ��Ƿ�����������Ŀ
           insert into #ghmx(ghxh,xmdm,xmsl,isghf) select ghxh,xmdm,xmsl,0 from #ghmx_ldxm
	end
	
	if exists(select 1 from #mzghtmp where ghlb=3) and @iskmgh=0 --����ר��
	begin
		--20050302 ���Ӷ������������Ĵ���
		declare @zhdcsx ut_money   
select @zhdcsx=isnull(zhdcsx,0) 
    from SF_BRXXK a(nolock) 
    left join YY_YBFLK b(nolock) on a.ybdm=b.ybdm 
    where a.patid=@patid
	
		if @zhdcsx > 0   
		begin  
			insert into #ghmx select a.ghxh, b.ghfdm2, 1 ,1  
			from #mzghtmp a, GH_DMZJK b(nolock) where a.ghlb=3 and b.id=a.ysdm  and a.ksdm = b.ksdm
		end  
		else  
			insert into #ghmx select a.ghxh, b.ghfdm1, 1 ,1  
			from #mzghtmp a, GH_DMZJK b(nolock) where a.ghlb=3 and b.id=a.ysdm and a.ksdm = b.ksdm

		insert into #ghmx select a.ghxh, b.zlfdm, 1,2 
		from #mzghtmp a, GH_DMZJK b(nolock) where a.ghlb=3 and b.id=a.ysdm and a.ksdm = b.ksdm
		
		if (@ybldbz='��' or @pzlx='0') and @ghldbz='��' --ҽ�����˹Һ��Ƿ�����������Ŀ
            insert into #ghmx(ghxh,xmdm,xmsl,isghf) select ghxh,xmdm,xmsl,0 from #ghmx_ldxm
	end

	if exists(select 1 from #mzghtmp where ghlb=6) and @iskmgh=0 --����Һ�
	begin
		if exists (select 1 from YY_CONFIG b(nolock) where b.id in ('1019') and config <> '' )
			insert into #ghmx select a.ghxh, config, 1 ,1
			from #mzghtmp a, YY_CONFIG b(nolock) where a.ghlb=6 and b.id in ('1019')  --����Һ�ͳһ�ۣ��ҺŷѴ��룩
		else
		begin
			insert into #ghmx select a.ghxh, b.ghf, 1 ,1
				from #mzghtmp a, YY_ZGBMK b(nolock) where a.ghlb=6 and b.id=a.ysdm
			insert into #ghmx select a.ghxh, b.ghf_pt, 1,1
				from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb=6 and b.id=a.ksdm and not exists(select 1 from #ghmx c where a.ghxh=c.ghxh and c.isghf=1)
		end
		insert into #ghmx select a.ghxh, b.zlf, 1 ,2
			from #mzghtmp a, YY_ZGBMK b where a.ghlb=6 and b.id=a.ysdm
		--tony 2003.09.12 �������ר�ҹҺţ���ȡ���ҵ����Ʒ�
		insert into #ghmx select a.ghxh, b.zlf_pt, 1,2
			from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb=6 and b.id=a.ksdm and not exists(select 1 from #ghmx c where a.ghxh=c.ghxh and c.isghf=2)
			
		if (@ybldbz='��' or @pzlx='0') and @ghldbz='��' --ҽ�����˹Һ��Ƿ�����������Ŀ
            insert into #ghmx(ghxh,xmdm,xmsl,isghf) select ghxh,xmdm,xmsl,0 from #ghmx_ldxm
	end
	if exists(select 1 from #mzghtmp where ghlb=4) and @iskmgh=0 --����Һ� add by aorigele 20120210
	begin
		if exists(select 1 from YY_CONFIG (nolock) where id='1188' and config = '��')
		   and (exists(select 1 from #mzghtmp where pbmxxh>=0))
		begin	
			IF EXISTS(SELECT 1 FROM YY_CONFIG (NOLOCK) WHERE id = '1691' AND config = '��')
			BEGIN
				if isnull(@ysdm,'') <> ''  --ר��
				begin
						insert into #ghmx select a.ghxh,b.ghf1, 1,1 
						from #mzghtmp a, YY_ZGBMK b(nolock) where a.ghlb in (4) and b.id=a.ysdm
							
						insert into #ghmx select a.ghxh,b.zlf, 1,2 
						from #mzghtmp a, YY_ZGBMK b(nolock) where a.ghlb in (4) and b.id=a.ysdm	
				end
				else  --����
				begin
						insert into #ghmx select a.ghxh,b.ghf_ts, 1,1 
						from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb in (4) and b.id=a.ksdm
						insert into #ghmx select a.ghxh,b.zlf_ts, 1,2
						from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb in (4) and b.id=a.ksdm
				end				
			END
			ELSE
			BEGIN
				--�������Һš���Һŷ�  ���������ߣ���Ϊ1188�Ķ�û�����ü������Һŷ�
				insert into #ghmx select aa.ghxh, b.ghfdm, 1, 1
				 from #mzghtmp aa,GH_YY_PBZB a(nolock),GH_YY_PBZBMX b(nolock)  
				where a.pbzbid = b.pbzbid and b.pbmxid = aa.pbmxxh
						and ((aa.ysdm = a.pbkm)or(aa.ksdm = a.pbkm)) and aa.ghlb=4
				insert into #ghmx select aa.ghxh, b.zlfdm, 1, 2
				 from #mzghtmp aa,GH_YY_PBZB a(nolock),GH_YY_PBZBMX b(nolock)  
				where a.pbzbid = b.pbzbid and b.pbmxid = aa.pbmxxh
						and ((aa.ysdm = a.pbkm)or(aa.ksdm = a.pbkm)) and aa.ghlb=4				
			END
		end
		else
		begin
				if isnull(@ysdm,'') <> ''  --ר��
				begin
						insert into #ghmx select a.ghxh,b.ghf1, 1,1 
						from #mzghtmp a, YY_ZGBMK b(nolock) where a.ghlb in (4) and b.id=a.ysdm
							
						insert into #ghmx select a.ghxh,b.zlf, 1,2 
						from #mzghtmp a, YY_ZGBMK b(nolock) where a.ghlb in (4) and b.id=a.ysdm	
				end
				else  --����
				begin
						insert into #ghmx select a.ghxh,b.ghf_ts, 1,1 
						from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb in (4) and b.id=a.ksdm
						insert into #ghmx select a.ghxh,b.zlf_ts, 1,2
						from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb in (4) and b.id=a.ksdm
				end
		end;
		if (@ybldbz='��' or @pzlx='0') and @ghldbz='��' --ҽ�����˹Һ��Ƿ�����������Ŀ
            insert into #ghmx(ghxh,xmdm,xmsl,isghf) select ghxh,xmdm,xmsl,0 from #ghmx_ldxm
	end;
	if exists(select 1 from #mzghtmp where ghlb=9) and @iskmgh=0 --ԤԼ
	begin
		-- �°�ԤԼ�Һ�ʹ��aorigele 20100730
		if exists(select 1 from YY_CONFIG (nolock) where id='1188' and config = '��')
		begin
			select @gfyyxh = zjxh,@yyghlb = yyghlb from GH_SH_GHYYK(nolock) where xh = @yyxh

			insert into #ghmx select aa.ghxh, b.ghfdm, 1, 1
			 from #mzghtmp aa,GH_YY_PBZB a(nolock),GH_YY_PBZBMX b(nolock)  
			where a.pbzbid = b.pbzbid and b.pbmxid = @gfyyxh
			  and ((aa.ysdm = a.pbkm)or(aa.ksdm = a.pbkm))
			insert into #ghmx select aa.ghxh, b.zlfdm, 1, 2
			 from #mzghtmp aa,GH_YY_PBZB a(nolock),GH_YY_PBZBMX b(nolock)  
			where a.pbzbid = b.pbzbid and b.pbmxid = @gfyyxh
			  and ((aa.ysdm = a.pbkm)or(aa.ksdm = a.pbkm))
--			select * from GH_YY_PBZBMX
			if exists(select 1 from #ghmx_ldxm)	--add by liuchun ���ԤԼ�Һ�������Ŀ
			begin
				if (@ybldbz='��' or @pzlx='0') and @ghldbz='��' 
				begin
					insert into  #ghmx select ghxh,xmdm,xmsl,0 from #ghmx_ldxm   
					if @@ERROR <> 0 or @@ROWCOUNT = 0
					begin
						select 'F','�°�ԤԼ�Һ����������Ŀ����'
						return
					end
				end
			end
		end
		-- add by aorigele end;
		else --����
		begin
			select @gfyyxh = zjxh from GH_GHYYK(nolock) where xh = @yyxh
			insert into #ghmx select a.ghxh, b.ghfdm, 1, 1
				from #mzghtmp a, GH_YYZJK b(nolock) where a.ghlb=9 and (b.id=a.ysdm or (b.id='-1' and b.ksdm=a.ksdm)) and b.xh = @gfyyxh
			insert into #ghmx select a.ghxh, b.zlfdm, 1, 2 
				from #mzghtmp a, GH_YYZJK b(nolock) where a.ghlb=9 and (b.id=a.ysdm or (b.id='-1' and b.ksdm=a.ksdm)) and b.xh = @gfyyxh
			if exists(select 1 from #ghmx_ldxm)	--add by liuchun ���ԤԼ�Һ�������Ŀ
			begin
				if (@ybldbz='��' or @pzlx='0') and @ghldbz='��' 
				begin
					insert into  #ghmx select ghxh,xmdm,xmsl,0 from #ghmx_ldxm   
					if @@ERROR <> 0 or @@ROWCOUNT = 0
					begin
						select 'F','ԤԼ�Һ����������Ŀ����'
						return
					end
				end
			end
		end;
	end
	
	if @iskmgh=1--yxc
	begin
		update 	aa set aa.kmmc=a.kmmc,aa.fbdm=a.fbdm,aa.fbmc=a.fbmc,aa.zqmc=a.bmmc,aa.zqdm=a.bmdm
		from #mzghtmp aa,GH_GHKMK a(nolock) 
		where aa.kmdm = a.kmdm  
 		if @@error <>0 
		begin
			select 'F','���¿�Ŀ��Ϣ����'
			return
		end
		delete from #ghmx where isghf in (1,2) --yxc2 
		--�������Һš���Һŷ�  ���������ߣ���Ϊ1188�Ķ�û�����ü������Һŷ�
		insert into #ghmx select aa.ghxh, b.ghfdm, 1, 1
		 from #mzghtmp aa,GH_GHKMK a(nolock),GH_GHFBFLK b(nolock),GH_KM_PBZBMX c (nolock)
		where aa.kmdm = a.kmdm and a.fbdm = b.fbdm    and aa.pbmxxh=c.pbmxid and aa.kmdm=c.pbkm
--			  
		insert into #ghmx select aa.ghxh, b.zlfdm, 1, 2
		 from #mzghtmp aa,GH_GHKMK a(nolock),GH_GHFBFLK b(nolock)  ,GH_KM_PBZBMX c (nolock)
		where aa.kmdm = a.kmdm and a.fbdm = b.fbdm    and aa.pbmxxh=c.pbmxid and aa.kmdm=c.pbkm
		
		--insert into #ghmx select a.ghxh, (case a.ghlb when 0 then b.ghf_pt when 1 then b.ghf_jz when 7 then b.ghf_pt when 8 then b.ghf_pt else b.ghf_ts end), 1,1 
		--	from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb in (0,1,4,7,8) and b.id=a.ksdm
--                  and a.pbmxxh <= 0
		--insert into #ghmx select a.ghxh, (case a.ghlb when 0 then b.zlf_pt when 1 then b.zlf_jz when 4 then b.zlf_ts else b.zlf_pt end), 1,2
		--from #mzghtmp a, YY_KSBMK b(nolock) where a.ghlb in (0,1,4,7,8) and b.id=a.ksdm
--                  and a.pbmxxh <= 0

		if @ghlb=9
		begin
			if (@ybldbz='��' or @pzlx='0') and @ghldbz='��' --ҽ�����˹Һ��Ƿ�����������Ŀ
			   insert into #ghmx(ghxh,xmdm,xmsl,isghf) select ghxh,xmdm,xmsl,0 from #ghmx_ldxm
		end
	end	
	
	--�������ҽ���������ùҺŷ����ƷѴ��루�Ͼ�ҽ��������ҽ����Ŀ���룩
	--ע�����һ�ιҶ�����ţ��ҹҺ����ͬ�����޷����� 
	update a set xmdm=b.xmdm 
	from #ghmx a,GH_TSGHFZLF b(nolock)
	where b.ybdm=@ybdm and a.isghf=b.isghf and @ghlb=b.ghlb
	if @@error <>0 
	begin
		select 'F','������Һŷ����ƷѸ��¹Һŷ����Ʒ�ʱ����'
		return
	end 
	
	/*add by mxd for vsts:237239 2017.12.05*/
	--ҽ��վ�Һſ��� 0=��ͨ��1=���2=ר�ң�3=����ר�ң�4=����Һţ�5=���6=����Һ�,7= ��Һŷ�, 8=��ѹҺ�
	--and @ghlb<>'7' add by mxd for bug:290373 2018.04.23 @ghlb=7����������xmdmΪ�գ������滹��ɾ��@ghlb=7��ghf���������ﲻ���ж�@ghlb=7
	if not exists(select 1 from  #ghmx where  isnull(xmdm,'')<>'' and isghf = 1 ) and @ghlb<>'7'--and  (@ghlb in (0,1,2,3,4,6))
	begin 
		select "F","�Һŷ����ò��ԣ��������ùҺŷ�"  
		return 
	end
	if not exists(select 1 from  #ghmx where  isnull(xmdm,'')<>'' and isghf = 2 ) --and  (@ghlb in (0,1,2,3,4,6))
	begin 
		select "F","���Ʒ����ò��ԣ������������Ʒ�"  
		return 
	end
	/*end add by mxd for vsts:237239 2017.12.05*/	

    --add by lsz 2018-02-05 ��ͯ���Ʒ� Ҫ��201788
    declare @config1630 int
    if exists(select 1 from YY_CONFIG(nolock) where id='1630' and ltrim(rtrim(config))<>'')
    begin
       select @config1630=cast(rtrim(config) as int) from YY_CONFIG(nolock) where id='1630' 
	  if @config1630>0 and @config1662='��'
	   begin
           update #ghmx set xmdm=dbo.fun_gh_getetzlf(@patid,xmdm) where isghf=2
	   end
    end
			
    /*
	update #mzghtmp set ksdm=(case when a.ghlb in (2,3,6) then b.ks_id else a.ksdm end), ysmc=b.name, xzks_id=isnull(b.xzks_id,b.ks_id)
		from #mzghtmp a, YY_ZGBMK b (nolock)
		where b.id=a.ysdm
    */ 
	update #mzghtmp set ysmc=b.name, xzks_id=isnull(b.xzks_id,b.ks_id)--yyx 20090610
		from #mzghtmp a, YY_ZGBMK b (nolock)
		where b.id=a.ysdm
	/* panlian 2004-03-12 70��������Һŷ� */
	select @config3=config from YY_CONFIG where id='1071' 
	if @config3 = '��'
	begin
		select @birth=birth from SF_BRXXK(nolock) where patid=@patid
		if cast(substring(@now,1,4) as int ) - cast(substring(@birth,1,4)  as int ) >=70
			delete from  #ghmx where isghf=1
	end 

	if exists(select 1 from YY_CONFIG where id='1263' and config='��')
	begin
		delete from  #ghmx where isghf=2
	end
	--add by ozb 2007-12-17 begin
	
	/*�˶��ᵽ������#ghmx���������� by mxd for vsts:237239 2017.12.05
	--�������ҽ���������ùҺŷ����ƷѴ��루�Ͼ�ҽ��������ҽ����Ŀ���룩
	--ע�����һ�ιҶ�����ţ��ҹҺ����ͬ�����޷����� 
	update a set xmdm=b.xmdm 
	from #ghmx a,GH_TSGHFZLF b(nolock)
	where b.ybdm=@ybdm and a.isghf=b.isghf and @ghlb=b.ghlb
	if @@error <>0 
	begin
		select 'F','������Һŷ����ƷѸ��¹Һŷ����Ʒ�ʱ����'
		return
	end 
	*/	
    --cjt �˴����ڸ�����ѹҺ�ʱ����Ϊ�գ����Ƽ�������ĹҺŷ���Ϊ��
	if exists(select 1 from #mzghtmp where ghlb in(5,8)) 
	begin
	    --modi by yuliang 2012-11-23 for bug147514�˴��������������⣬���ͬʱ�Ҷ����,�м����ghlb=8�ģ��Ὣ���еķ��ø���Ϊ0
		--update #ghmx set xmsl=0 where isghf<>0
		update a set a.xmsl=0 from #ghmx a,#mzghtmp b  
		where a.isghf<>0 and a.ghxh=b.ghxh and b.ghlb in (5,8)
		--modi end
	end
	/*** ---chenhong add 20191124 Ժ��ְ���Һ� begin
	***/
	if exists(select 1 from YY_CONFIG (nolock) where id='1188' and config = '��') and exists (select 1 from #mzghtmp where ghlb=8)        
			begin      
				delete from #ghmx
			end	
			 if exists(select 1 from #mzghtmp where ghlb=8) --����Һ�        
			 begin        
			  insert into #ghmx select a.ghxh, config, 1 ,1        
			   from #mzghtmp a, YY_CONFIG b where a.ghlb=8 and b.id='X001'        
			  insert into #ghmx select a.ghxh, config, 1 ,2        
			   from #mzghtmp a, YY_CONFIG b where a.ghlb=8 and b.id='X002'     
			 end
			 /***
			 ***/---chenhong add 20191124 Ժ��ְ���Һ� begin
	if exists(select 1 from #mzghtmp where ghlb=7) 
	begin
	    delete a
	    from #ghmx a,#mzghtmp b 
	    where a.ghxh=b.ghxh and b.ghlb=7 and a.isghf=1
	end
	delete from #ghmx where ltrim(isnull(xmdm,''))=''
	--add by ozb 2007-12-17 end
	
	--add by xxl 20140702 ����ѡ���Ƿ���ȡ�Һŷѷ�ʽ ��һλ���Һŷѣ��ڶ�λ�����Ʒѣ�����λ���ſ������ѣ�����λ����������
	if @ghfselectbz<>''
	begin
	    --isghf 0:������1:�Һŷ�2:���Ʒ�
		if substring(@ghfselectbz,1,1)='0'	--���չҺŷ�
		begin
			update #ghmx set xmsl=0 where isghf=1
		end
		if substring(@ghfselectbz,2,1)='0'	--�������Ʒ�
		begin
			update #ghmx set xmsl=0 where isghf=2
		end
		--�����ѵļ�����¸��ݲ�������
		delete #ghmx where xmdm in (select config from YY_CONFIG where id in('1002','1003')) and isghf=0
		if substring(@ghfselectbz,3,1)='1'	--�մſ�������
		begin
			insert into #ghmx select top 1 a.ghxh, b.config, 1,0 from #mzghtmp a, YY_CONFIG b  
				where b.id in ('1003')  
		end
		if substring(@ghfselectbz,4,1)='1'	--�ղ���������
		begin
			insert into #ghmx select top 1 a.ghxh, b.config, 1,0 from #mzghtmp a, YY_CONFIG b  
				where b.id in ('1002')  
		end
		
	end
	
	update #mzghtmp set ksmc=b.name
		from #mzghtmp a, YY_KSBMK b (nolock)
		where b.id=a.ksdm

	--Ƿ��ĵ�һ�εݽ�������
	if @qkbz1=2
		select @qkbz1=0

	if @qkbz1=1 and @zhje=0 and isnull(@zhdcsx,0) = 0
		select @qkbz1=0


	if @pzlx not in (10,11)
		select @xmlb=ylxm, @zddm=zddm from SF_YBPZK (nolock) where pzh=@pzh and patid=@patid and pzlx=@pzlx

	--����Һŷ��� W20040525
	--select a.ybdm,case when @ghlb = 6 then isnull(a.txbl,1) else 1 end as txbl,a.xmdm,isnull(djjsbz,0) djjsbz,txdj into #txblxm  
	select a.ybdm,isnull(a.txbl,1) as txbl,a.xmdm,isnull(djjsbz,0) djjsbz,txdj into #txblxm  --ȥ��@ghlb=6��ȡtxbl������  for bug154246 alter by djs 2017-04-27
		from YY_TSSFXMK a,SF_BRXXK b(nolock) 
	where a.ybdm = b.ybdm and b.patid = @patid and a.idm=0
	if @@error <> 0 
	begin
		select "F","ѡȡ������Ŀ����ʱ����"
		return
	end
	
	--add by sdb 2012-11-22 �Ϻ���Ժ����Һŷ�
	if @ghfdm <> '' 
	    update #ghmx set xmdm = @ghfdm where isghf = 1
		     
	if exists(select 1 from YY_CONFIG(nolock) where id='1416' and config='��')
	begin
		select * into #ghmx_hff from #ghmx
		delete #ghmx
	end
	
	
	select a.ghxh, a.xmdm, b.name as xmmc, a.xmsl,case when d.djjsbz = 1 then d.txdj else b.xmdj*isnull(d.txbl,1) end xmdj,
		b.dxmdm, c.name as dxmmc, 
		b.mzzfbz as zfbz, b.mzzfbl as zfbl, (case when b.yhbl>0 then 1 else 0 end) as yhbz, b.yhbl, 
		convert(money, 0) as zfdj, convert(money, 0) as yhdj, c.mzfp_id, c.mzfp_mc, b.sxjg, a.isghf
		,convert(numeric(6,4),0) jmbl
	into #ghmx1
	from #ghmx a inner join YY_SFXXMK b (nolock) on a.xmdm=b.id
    inner join YY_SFDXMK c(nolock) on c.id=b.dxmdm
    left join #txblxm d on a.xmdm=d.xmdm
	select @error=@@error, @rowcount=@@rowcount
	if @error<>0
	begin
		select "F","����Һŷ���ʱ����"
		return
	end
	--IF @ghlb in (8)------chenhong add 20191124
	--begin
	--	update #ghmx1 set xmdj=1 where xmdj<>0
	--end
	if @rowcount=0 --��ǰ�޽�����
	begin
		select @zfyje=0, @yhje=0, @ybje=0, @sfje3=0
	end
	else 
	begin
		if @zfbz=0 --ҽ�����ó��Ի�
			update #ghmx1 set yhbz=0, yhbl=0
		else if @zfbz=2
		begin
			update #ghmx1 set yhbz=0, yhbl=0
			update #ghmx1 set zfbz=1, zfbl=b.zfbl
				from #ghmx1 a, YY_TSSFXMK b (nolock)
				where b.idm=0 and b.xmdm=a.xmdm and b.ybdm=@ybdm
			if @@error<>0
			begin
				select "F","����Һŷ���ʱ����"
				return
			end
		end
		else if @zfbz=3
		begin
			if charindex('"'+ltrim(rtrim(@ybdm))+'"',@csybdm) > 0
			begin
				if @zhje > 0
				begin
					update #ghmx1 set zfbz=0, zfbl=0, yhbz=1, yhbl=b.yhbl
						from #ghmx1 a, YY_TSSFXMK b (nolock)
						where b.idm=0 and b.xmdm=a.xmdm and b.ybdm=@ybdm
				end
				else 
				begin
					update #ghmx1 set zfbz=0, zfbl=0, yhbz=0, yhbl=0
						from #ghmx1 a, YY_TSSFXMK b (nolock)
						where b.idm=0 and b.xmdm=a.xmdm and b.ybdm=@ybdm
				end
			end
			else 
				update #ghmx1 set zfbz=0, zfbl=0, yhbz=1, yhbl=b.yhbl
					from #ghmx1 a, YY_TSSFXMK b (nolock)
					where b.idm=0 and b.xmdm=a.xmdm and b.ybdm=@ybdm
			if @@error<>0
			begin
				select "F","����Һŷ���ʱ����"
				return
			end
		end
		else if @zfbz=4
			update #ghmx1 set zfbz=0, zfbl=0, yhbz=0, yhbl=0

		--��ƶ���߸��� vsts 315326 begin
		--ƶ���ȼ�
		if exists(select 1 from YY_CONFIG where id ='0384' and config ='��')and  exists(select 1 from SF_BRXXK a(nolock),YY_PKRKXXB b(nolock) where a.patid =@patid and a.sfzh =b.sfzh and b.jlzt =1 and b.shbz =1)
		begin
			declare @pkdj ut_bz
			select @pkdj =pkdj from SF_BRXXK a(nolock),YY_PKRKXXB b(nolock) where a.patid =@patid and a.sfzh =b.sfzh
		
				update #ghmx1 set  zfbz=0, zfbl=0,yhbz=1, yhbl=b.yhbl  
				from #ghmx1 a, YY_PKSFXMK b (nolock)  
				where b.idm=0 and b.xmdm=a.xmdm and b.pkdj=@pkdj and isnull(b.xtbz,2)in(0,2)     
		end
		--��ƶ���߸��� end	

		if @config1662_js='��' and @config1665_js='��' --add by hwh 2018-8-9
		begin
			update a set a.xmdj=a.xmdj+b.etjsje 
			from #ghmx1 a
			inner join YY_SFXXMK b (nolock) on b.id=a.xmdm
			where b.etjsbz=1
		end			

		--WED20050608 �ж������ǩԼ���˾��������Ż�
		if charindex(rtrim(ltrim(@ybdm)),(select config from YY_CONFIG where id = '1099')) > 0
		begin
			update #ghmx1 set zfbz=0, zfbl=0, yhbz=1, yhbl=b.yhbl
				from #ghmx1 a, YY_TSSFXMK b (nolock)
				where b.idm=0 and b.xmdm=a.xmdm and b.ybdm=@ybdm
			if @@error<>0
			begin
				select "F","���¹Һŷ����Żݱ���ʱ����"
				return
			end			
		end

		--sunyu 2007-01-14 ����������ô���
		if @jmjsbz=2
		begin
			update #ghmx1 set zfbz=0, zfbl=0,yhbz=0,yhbl=0,jmbl=case when @tsrydm='1' then zfbl else 1 end
				where isghf in (1,2)
			if @@error<>0
			begin
				select "F","���¹Һŷ����Էѱ���ʱ����"
				return
			end
		end
		
		--W20050313 �����շ���Ŀ���������޼۸�,������������ⲡ�˵����޼۸�����.
		--˳��:��ִ���շ�С��Ŀ�е����޼۸�,�ٸ���ִ�������շ���Ŀ�е����޼۸�
		update #ghmx1 set sxjg = b.sxjg
			from #ghmx1 a,YY_TSSFXMK b
			where a.xmdm = b.xmdm and b.ybdm = @ybdm 

		update #ghmx1 set zfdj=(case when sxjg<xmdj and sxjg>0 then (xmdj-sxjg)+sxjg*zfbl else xmdj*zfbl end),
			yhdj=(case when sxjg<xmdj and sxjg>0 then sxjg*(1-zfbl)*yhbl else xmdj*(1-zfbl)*yhbl end)

		--Wxp20070317 �Զ�����ҽԺת�ﴦ�������ԷѺ������Ż�50%
		--������ @zzdjh <> '',�Ƕ�����ҽԺ����ͨ�Һŷѣ���Χ���ƣ��ҺŷѺ����Ʒ�
		if (@zzdjh <> '' and @yydj > 1 and @ghlb in (0,1)) 
		begin
			if @zfbz = 4 --�ԷѲ���ԭ������û���κ�������ñ��������ghfû��
			begin
				select @jmghf=isnull(sum(round(xmdj*xmsl*0.5,2)),0) from #ghmx1 where isghf=1
				select @jmzlf=isnull(sum(round(xmdj*xmsl*0.5,2)),0) from #ghmx1 where isghf=2				
				update #ghmx1 set zfdj= zfdj *0.5,yhdj= xmdj*0.5  where isghf in (1,2)
			end
			if @pzlx  in (10,11)
			begin
				if @zfbz = 3 
				begin 
					select @jmghf=isnull(sum(round((xmdj-yhdj)*xmsl*0.5,2)),0) from #ghmx1 where isghf=1
					select @jmzlf=isnull(sum(round((xmdj-yhdj)*xmsl*0.5,2)),0) from #ghmx1 where isghf=2					
					update #ghmx1 set zfdj= zfdj *0.5,yhdj= yhdj+(xmdj-yhdj) *0.5  where isghf in (1,2)
				end 
				else begin
					if @zfbz = 2
					begin
						--�Һŷѣ�ȡ�Է�ҩ���*0.5    ���Ʒѣ�ȡ�ɱ����*0.5
						select @jmghf=isnull(sum(round(zfdj*xmsl*0.5,2)),0) from #ghmx1 where isghf=1
						select @jmzlf=isnull(sum(round((xmdj-zfdj)*xmsl*0.5,2)),0) from #ghmx1 where isghf=2						
						update #ghmx1 set zfdj= zfdj *0.5,yhdj= zfdj *0.5  where isghf =1
						update #ghmx1 set yhdj= (xmdj-zfdj) *0.5  where isghf =2
					end
					else begin
						select @jmghf=isnull(sum(round(xmdj*xmsl*0.5,2)),0) from #ghmx1 where isghf=1
						select @jmzlf=isnull(sum(round(xmdj*xmsl*0.5,2)),0) from #ghmx1 where isghf=2						
						update #ghmx1 set zfdj= zfdj *0.5,yhdj= xmdj*0.5  where isghf in (1,2)
					end
				end		
			end
		end

		-- add kcs 20160808 by 98152 �Ÿ��������Ѽ��� ����Ѿ������� �Ͳ���Ҫ�ж��Ƿ���60����������
		if (@sfyf = 1) and (@ghlb in (0))
		begin
		    select @jmzlf=isnull(sum(round((xmdj-yhdj)*xmsl*0.5,2)),0) from #ghmx1 where isghf=2					
			update #ghmx1 set zfdj= zfdj *0.5,yhdj= yhdj+(xmdj-yhdj) *0.5  where isghf in (2)
			select @zlfjmlx=0
		end
        else
		begin
			if exists(select 1 from sysobjects where name='usp_gh_ghfyhcl' and type='P') --and 1=1
			AND EXISTS(SELECT 1 FROM dbo.YY_CONFIG WHERE id='1726' AND config='��')
			begin
				declare @tablename_ghmx varchar(100)
				select @tablename_ghmx ='##ghmx'+@wkdz+@czyh
				exec('if exists(select * from tempdb..sysobjects where name="'+@tablename_ghmx+'")
					drop table '+@tablename_ghmx)
				exec('select * into '+@tablename_ghmx+' from #ghmx1 where 1=2') --������ʱ�����Żݽ��
				exec('exec usp_gh_ghfyhcl @wkdz="'+@wkdz+'",@patid='+@patid+',@czyh="'+@czyh+'",@ksdm="'+@ksdm+'",@ysdm="'+@ysdm+'",@ghlb="'+@ghlb+'" ')  
				exec('delete from #ghmx1; insert into #ghmx1 select * from '+@tablename_ghmx)
				exec('drop table '+@tablename_ghmx)				
				--SELECT '�Żݺ�',* FROM #ghmx1
			end
			else--else usp_gh_ghfyhcl
			begin
				-- add kcs 20160805 by 97896
				declare @config1497 varchar(2),@config1693 numeric(10,2),@jmzlfzje numeric(10,2)
				select @config1497 = config from YY_CONFIG where id = '1497'
				select @config1693 = convert(numeric(10,2),config) from YY_CONFIG where id = '1693'
				if (@config1497 = '��') and (@ghlb in (0))
				begin
					select @birth=birth from SF_BRXXK(nolock) where patid=@patid
					--if cast(substring(@now,1,4) as int ) - cast(substring(@birth,1,4)  as int ) >= 60
					if dbo.FUN_GETBRNL(@birth,convert(char(8),getdate(),112)+convert(char(8),getdate(),8),1,1,null) >= 60
					begin
						if @config1693=0
						begin             
							select @jmzlf=isnull(sum(round((xmdj-yhdj)*xmsl*0.5,2)),0) from #ghmx1 where isghf=2					
							update #ghmx1 set zfdj= zfdj *0.5,yhdj= yhdj+(xmdj-yhdj) *0.5  where isghf in (2)
							select @zlfjmlx=1
						end
						else
						begin
							select @jmzlfzje=isnull(sum(round((xmdj-yhdj)*xmsl,2)),0),@jmzlf=case when isnull(sum(round((xmdj-yhdj)*xmsl-@config1693,2)),0)<0 then isnull(sum(round((xmdj-yhdj)*xmsl,2)),0) else @config1693 end from #ghmx1 where isghf=2					
							update #ghmx1 set zfdj= zfdj *(1-@jmzlf/@jmzlfzje),yhdj= yhdj+(xmdj-yhdj) *(@jmzlf/@jmzlfzje)  where isghf in (2)
							select @zlfjmlx=1
						end
					end
				end
			end--end else usp_gh_ghfyhcl
		end

		if substring(@ghfselectbz,5,1)='1'	--�������(����ҽԺ�Ĳ�ͬ�����޸�)
		begin
			update #ghmx1 set xmdj=1 where isghf=1
			update #ghmx1 set xmdj=3 where isghf=2
			update #ghmx1 set yhdj=0 where isghf=1
			update #ghmx1 set yhdj=0 where isghf=2
		end				
		--add HRP ������Ŀ�۸�����
		if @hrpbz='1'  and  @config2604='��'
		begin
		    update #ghmx1 set xmdj=b.xmdj from  #ghmx1 a,#ghmx_ldxm b  where a.xmdm=b.xmdm and a.isghf=0
		end
		
		select @zje=sum(round(xmsl*xmdj,2)),
			@zfyje=sum(round(xmsl*zfdj,2)),
			@yhje=sum(round(xmsl*yhdj,2)),
			@jmje=sum(round(xmsl*xmdj*jmbl,2))
			from #ghmx1
		
		select @ybje=@zje-@zfyje-@yhje-@jmje
		select @sfje3=@zje-@yhje-@jmje
	end
	--20050302 �������Ĵ���

	if @ghlb=3   	
	begin  
	if @zje<=@zhdcsx  
		select @zhje = @zje--,@ybje=@zje-@zfyje  --,@zfyje=0  
	else  
		select @zhje= @zhdcsx--,@ybje=@zje-@zfyje --@zfyje=@zje-@zhdcsx,  
	end 
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
	--ȡ��ʵ�ս��

	select @sfje2=@sfje3	--zyh 20071221 ҽ������Ҳ���ԷѼ���ʱ

	if @pzlx not in (10,11) --��ҽ��סԺ����ҽ�������
	begin
		execute usp_yy_ybjs @ybdm,0,0,@ybje,@errmsg output,0,@tcljje,@jsfs  --ҽ��������
		if @errmsg like "F%"
		begin
			select "F",substring(@errmsg,2,49)
			return
		end
		else
			select @sfje=convert(numeric(10,2),substring(@errmsg,2,11))

		select @sfje_zzjsq = @sfje
		--����һ�±��ؼ������
		if (@zzdjh <> '' and @yydj > 1 and @ghlb in (0,1) and @zfbz <> 4) 
		begin
			select @jmghfbl = 0,@jmzlfbl = 0
			if @ybje > 0
			begin
				select @jmghfbl = (xmdj-zfdj-yhdj-xmdj*jmbl)*xmsl/@ybje
					from #ghmx1 where isghf =1
				select @jmzlfbl = (xmdj-zfdj-yhdj-xmdj*jmbl)*xmsl/@ybje  
					from #ghmx1 where isghf =2
			end
			select @jmghf=(@sfje*@jmghfbl+zfdj*xmsl)* 0.5 from #ghmx1 where isghf in (1)
			select @jmzlf=(@sfje*@jmzlfbl+zfdj*xmsl)* 0.5 from #ghmx1 where isghf in (2)

			update #ghmx1 set yhdj= yhdj+@jmghf/xmsl,zfdj = zfdj*0.5,yhbz = 1 where isghf = 1
			update #ghmx1 set yhdj= yhdj+@jmzlf/xmsl,zfdj = zfdj*0.5,yhbz = 1 where isghf = 2
			select @sfje=@sfje*0.5,@zfyje = @zfyje-(zfdj*xmsl) from #ghmx1 where isghf in (1)
			select @yhje=sum(round(xmsl*yhdj,2))  from #ghmx1
		end

		select @sfje1=@sfje+@zfyje
		
		if exists (select 1 from sysobjects where name = 'usp_gh_ynyhcl') --70���������˹Һż���1Ԫ���ã�����Ҫ��¼�ŻݵĽ�� 
		begin  
			exec usp_gh_ynyhcl @patid,@ynyhje out,@errmsg out  
			if @sfje1 >= @ynyhje   
			begin  
				select @sfje1 = @sfje1 - @ynyhje,@yhje = @yhje+@ynyhje  
			end  
			else  
			begin  
				select @yhje = @yhje+@sfje1,@sfje1 = 0  
			end  
		end 
		
		select @srbz=config from YY_CONFIG (nolock) where id='1014' --��������������ֵ
		if @@error<>0 or @@rowcount=0
			select @srbz='0'

        declare @srfs varchar(1)  --0����ȷ���֣�1����ȷ����
		select @srfs = config from YY_CONFIG (nolock) where id='2235'
		if @@error<>0 or @@rowcount=0
			select @srfs='0'

		select @sfje2 = @sfje1  -----add by sqf ͳһ������������
        if @srfs = '1' or @qkbz1=1 ---1����ȷ������������20110426sqf
		begin		
			if @srbz='5'
				select @sfje2=round(@sfje1, 1)
			else if @srbz='6'
				exec usp_yy_wslr @sfje1,1,@sfje2 output
			else if @srbz>='1' and @srbz<='9'
				exec usp_yy_wslr @sfje1,1,@sfje2 output,@srbz
			else
				select @sfje2=@sfje1

			select @srje=@sfje2-@sfje1
		end

		if @ybje>0
		begin
			if (@zzdjh <> '' and @yydj > 1 and @ghlb in (0,1) and @zfbz <> 4 and @pzlx not in (10,11)) 
				select @xmzfbl=@sfje_zzjsq/@ybje
			else
				select @xmzfbl=@sfje/@ybje
		end
		--���ƻ����ˣ���ҽԺ�и����˻��Ĳ��ˣ�
		if @qkbz1=1
		begin
			--�漰����Щ�˵ĹҺŷ����˻���۳����е�Ҫ�Լ���
			declare @zfyje_zh   money --�˻����˵��Էѽ��
			if exists(select 1 from YY_CONFIG (nolock) 
				where charindex('"'+rtrim(@ybdm)+'"',config)>0 and id='1098')
				select @zfyje_zh = 0
			else
				select @zfyje_zh = @zfyje

			if @sfje2-@zfyje_zh<=@zhje
				select @qkje=@sfje2-@zfyje_zh,@qkje2=@sfje1-@zfyje_zh
			else
				select @qkje=round(@zhje,1),@qkje2 = @zhje

			insert into SF_JEMXK(jssjh, lx, mc, je, memo)
			values(@sjh, '01', '�𸶶ε����˻�֧��',@qkje2 , null)
			if @@error<>0
			begin
				select "F","�������01��Ϣ����"
				return
			end
			--(��������)
		end
		else if @czksfbz = 1
		begin
			if @yjbz=1
			begin
				if @yjyebz='��' and @yjye<@sfje2 and @lybz <> 2
				begin
					select "F","��ֵ�����㣬���ܼ����Һţ�"
					return
				end
	
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
					select @qkbz1=3
	
					if @yjdybz='��' and (@sfje2<=@yjye)
						--select @qrbz=1
						select @fpdybz=1
				end
			end
		end
		if @yjdybz='��' and @mzlcbz=1 and exists(select 1 from YY_CONFIG where id='1065' and charindex('"'+rtrim(@pzlx)+'"',config)>0)
			--select @qrbz=1
			select @fpdybz=1
		if @lybz = 2  --add by sdb 2010-11-2 �����ҺŲŻ��ж�GH_ZDGHJLK��������
		begin
			if @issyzzgh=1 and exists(select 1 from GH_ZDGHJLK where patid=@patid and jlzt=0 and ghlb=@ghlb)
				select @qrbz=3,@fpdybz=1
		end

		if @mzlcbz=1
		begin
			if @yjyebz='��' and @yjye<@sfje2 and @sfje2>0 and @yjbz=1 and @lybz <> 2
			begin
				select "F","��ֵ�����㣬���ܼ����Һţ�"
				return
			end
		end
	end
	else 
	begin
		--mit , 2oo3-11-28 , ���������ж��Ƿ����
		if @yjdybz='��' and @mzlcbz=1 and exists(select 1 from YY_CONFIG where id='1065' and charindex('"'+rtrim(@pzlx)+'"',config)>0)
			--select @qrbz=1
			select @fpdybz=1
		if @lybz = 2  --add by sdb 2010-11-2 �����ҺŲŻ��ж�GH_ZDGHJLK��������
		begin
			if @issyzzgh=1 and exists(select 1 from GH_ZDGHJLK where patid=@patid and jlzt=0)
				select @qrbz=3,@fpdybz=1
		end
	end
-----------add by sqf ͳһ������������	begin
	if @qkbz1 = 3 and @srfs = '0'---0����ȷ������������20110426sqf
	begin 
		select @sfje2=@sfje1-@qkje
		if @srbz='5'
			select @sfje2=round(@sfje1-@qkje, 1)
		else if @srbz='6'
			exec usp_yy_wslr @sfje2,1,@sfje2 output 
		else if @srbz>='1' and @srbz<='9'
			exec usp_yy_wslr @sfje2,1,@sfje2 output,@srbz
		else
			select @sfje2=@sfje1-@qkje
		select @sfje2=@sfje2+@qkje
		select @srje=@sfje2-@sfje1
		--add by cxl for bug 3945 
		if @yjdybz='��' and (@sfje2<=@yjye)
			--select @qrbz=1
			select @fpdybz=1		
	end
	else if @srfs = '0' and @qkbz1 <> 1
	begin
		if @srbz='5'
			select @sfje2=round(@sfje1, 1)
		else if @srbz='6'
			exec usp_yy_wslr @sfje1,1,@sfje2 output
		else if @srbz>='1' and @srbz<='9'
			exec usp_yy_wslr @sfje1,1,@sfje2 output,@srbz
		else
			select @sfje2=@sfje1
		select @srje=@sfje2-@sfje1
	end
	
-----------add by sqf ͳһ������������	end
	--����Һŷѡ����Ʒ�
	if (@ybdm=@scybdm) or (@jmjsbz=2)
	begin
--		if @ghlb not in (2,3)
		select @ghf=isnull(sum(round(xmdj*xmsl,2)),0) from #ghmx1 where isghf=1
	end
	else
		select @ghf=isnull(sum(round(zfdj*xmsl,2)),0) from #ghmx1 where isghf=1
	select @zlf=isnull(sum(round((xmdj-yhdj-zfdj)*xmsl,2)),0) from #ghmx1 where isghf=2

	--���������ܽ��
	select dxmdm, dxmmc, mzfp_id, mzfp_mc, sum(round(xmdj*xmsl,2)) as xmje, 
		sum(round((xmdj-zfdj-yhdj)*xmsl*@xmzfbl,2)) as zfje,
		sum(round(zfdj*xmsl,2)) as zfyje, sum(round(yhdj*xmsl,2)) as yhje,
		sum(round(xmdj*jmbl*xmsl,2)) as jmje
		into #ghmx2
		from #ghmx1 group by dxmdm, dxmmc, mzfp_id, mzfp_mc
	if @@rowcount>0
	begin
		select @xmce=@sfje-sum(zfje) from #ghmx2
		update #ghmx2 set zfje=zfje+zfyje
		set rowcount 1
		update #ghmx2 set zfje=zfje+@xmce
		set rowcount 0
	end	

	begin tran
	declare cs_mzgh cursor for
	select ghxh, ghlb, cfzbz, ksdm, ksmc, ysdm, ysmc, lybz, yyxh, yyrq, zqdm, xzks_id,pbmxxh,kmdm,kmmc,fbdm,fbmc,zqmc,zbdm from #mzghtmp
	for read only
--yxc2
	open cs_mzgh
	fetch cs_mzgh into @ghzdxh, @ghlb, @cfzbz, @ksdm, @ksmc, @ysdm, @ysmc, @lybz, @yyxh, @yyrq, @zqdm, @xzks_id,@pbmxxh_temp,@kmdm,@kmmc,@fbdm,@fbmc,@zqmc,@zbdm_temp
	while @@fetch_status=0
	begin
		if @pbmxxh_temp>0
		begin
			if @iskmgh=1 
			select @ghrq=zxrq+convert(char(8),getdate(),8) from GH_KM_PBZBMX where pbmxid=@pbmxxh_temp
			else
			select @ghrq=zxrq+convert(char(8),getdate(),8) from GH_YY_PBZBMX where pbmxid=@pbmxxh_temp
		end
		else
			select @ghrq=@now
		if isnull(@ghrq,'')=''---��ֵȡ���ڵ�����
		begin
			select @ghrq=@now
		end 
		select @yyxh_new=@yyxh
		IF (@config1151=1) AND (EXISTS(SELECT 1 FROM GH_GHZDK WHERE patid=@patid AND jlzt=8 AND jsbz=1))
		BEGIN
			if isnull(@inghzdxh,0)=0 
			begin
				SELECT "F","����Һ��˵���Ų���ȷ,������ǰ��̨��һ�µ��£�"
				ROLLBACK TRAN
				DEALLOCATE cs_mzgh
				RETURN
			end

			UPDATE GH_GHZDK SET jssjh=@sjh, czyh=@czyh, xzks_id=@xzks_id
			WHERE patid=@patid AND jlzt=8 AND jsbz=1 and xh=@inghzdxh
			IF @@ERROR<>0 OR @@ROWCOUNT=0
			BEGIN
				SELECT "F","����Һ��˵�����"
				ROLLBACK TRAN
				DEALLOCATE cs_mzgh
				RETURN
			END
			
			if exists (select 1 from GH_YY_PBZBMX(NOLOCK) where pbmxid = @pbmxxh_temp)
			select @sjdjl = b.kssj+'-'+b.jssj,@sjdsm = b.name
			from GH_YY_PBZBMX a(nolock)
			inner join GH_YY_ZZLX b(nolock) on a.zzlx=b.id
			where a.pbmxid = @pbmxxh_temp
			
			if exists (select 1 from GH_GHZDK_FZ(NOLOCK) where ghxh=@inghzdxh) 
			update GH_GHZDK_FZ set jssjh=@sjh,sjdjl=@sjdjl,sjdsm =@sjdsm,brlyid=@brlyid,wlzxyid=@wlzxyid
			---,zlfjmje=@jmzlf,zlfjmlx=@zlfjmlx,zzdh=@zzdh,isqygh=@isQygh
			where ghxh=@inghzdxh
			else
			insert into GH_GHZDK_FZ(ghxh,jssjh,patid,sjdjl,sjdsm,brlyid,wlzxyid) values(@inghzdxh,@sjh,@patid,@sjdjl,@sjdsm,@brlyid,@wlzxyid)
			if @@error<>0
			begin
				select "F","�Һ��ʵ��⸨�������"
				rollback tran
				deallocate cs_mzgh
				return		
			end

			select @xhtemp=@inghzdxh
			--select @xhtemp=xh FROM GH_GHZDK WHERE patid=@patid AND jssjh=@sjh
			DELETE FROM GH_GHMXK WHERE ghxh=@xhtemp
			insert into GH_GHMXK(ghxh, xmdm, xmmc, xmdj, xmsl, dxmdm, dxmmc, zfdj, yhdj, memo,isghf)
			select @xhtemp, xmdm, xmmc, xmdj, xmsl, dxmdm, dxmmc, zfdj, yhdj, null,isghf
				from #ghmx1 where ghxh=@ghzdxh
			if @@error<>0
			begin
				select "F","����Һ���ϸ����"
				rollback tran
				deallocate cs_mzgh
				return		
			end
			-- ����ű�
			if @isUsehb = 1 
			begin
				select @ghfdm_hb = xmdm from #ghmx1 where ghxh = @ghzdxh and isghf=1
				select @zlfdm_hb = xmdm from #ghmx1 where ghxh = @ghzdxh and isghf=2
				select @hbdm = isnull(id,'') from GH_GHHBK where ghfdm = @ghfdm_hb and zlfdm= @zlfdm_hb and jlzt =0
				if @hbdm <> ''
				begin
					update GH_GHZDK SET ghlx = @hbdm where xh =@inghzdxh
					if @@error<>0
					begin
						select "F","����Һ��˵�ghlx����"
						rollback tran
						deallocate cs_mzgh
						return		
					end
				end
			end
			
		END
		ELSE
		BEGIN
			insert into GH_GHZDK(jssjh, patid, blh, ybdm, cardno, yyxh, hzxm, py, wb, 
				czyh, czrq, ghrq, ksdm, ksmc, ysdm, ysmc, ghhx, cfzbz, lybz, ghlb, sfcs, txh, jlzt, 
				fzbz, fzrq, jsbz, memo
				,zjdm,zmdm,zm, zqdm,ghksdm,ghysdm,xzks_id,pbmxxh,yyghlb,kmdm,kmmc,fbdm,fbmc,zqmc,tsbzdm,mfghyy,appjkdm,sfyf,zbdm)
			select @sjh, patid, blh, @ybdm, cardno, @yyxh_new, hzxm, py, wb,
				@czyh, @now, @ghrq, case when @ghlb=4 and @tsghksdm<>'' then @tsghksdm else @ksdm end, case when @ghlb=4 and @tsghksdm<>'' then @tsghksmc else @ksmc end, @ysdm, @ysmc, 0, @cfzbz, @lybz, @ghlb, 0, null, 9,
				0, null, 1, null 
				,@zjdm,@zmdm,@zm, @zqdm,@ksdm,@ysdm,@xzks_id,@pbmxxh_temp,@yyghlb ,@kmdm,@kmmc,@fbdm,@fbmc,@zqmc,@zddm,@mfghyy,@kfsdm,@sfyf,@zbdm_temp
				from #brxxk
			if @@error<>0 or @@rowcount=0
			begin
				select "F","����Һ��˵�����"
				rollback tran
				deallocate cs_mzgh
				return
			end
			
			select @xhtemp=@@identity
			
			if exists (select 1 from GH_YY_PBZBMX(NOLOCK) where pbmxid = @pbmxxh_temp)
			select @sjdjl = b.kssj+'-'+b.jssj,@sjdsm = b.name
			from GH_YY_PBZBMX a(nolock)
			inner join GH_YY_ZZLX b(nolock) on a.zzlx=b.id
			where a.pbmxid = @pbmxxh_temp
			
			if exists (select 1 from GH_GHZDK_FZ(NOLOCK) where ghxh=@xhtemp) 
			update GH_GHZDK_FZ set jssjh=@sjh,sjdjl=@sjdjl,sjdsm =@sjdsm,brlyid=@brlyid,wlzxyid=@wlzxyid
			where ghxh=@xhtemp
			else
			insert into GH_GHZDK_FZ(ghxh,jssjh,patid,sjdjl,sjdsm,brlyid,wlzxyid) select @xhtemp,@sjh,patid,@sjdjl,@sjdsm,@brlyid,@wlzxyid from #brxxk
			if @@error<>0
			begin
				select "F","�Һ��ʵ��⸨�������"
				rollback tran
				deallocate cs_mzgh
				return		
			end

			insert into GH_GHMXK(ghxh, xmdm, xmmc, xmdj, xmsl, dxmdm, dxmmc, zfdj, yhdj, memo,isghf)
			select @xhtemp, xmdm, xmmc, xmdj, xmsl, dxmdm, dxmmc, zfdj, yhdj, null,isghf
				from #ghmx1 where ghxh=@ghzdxh
			if @@error<>0
			begin
				select "F","����Һ���ϸ����"
				rollback tran
				deallocate cs_mzgh
				return		
			end		
			-- ����ű� 
			if @isUsehb = 1 
			begin
				select @ghfdm_hb = xmdm from #ghmx1 where ghxh = @ghzdxh and isghf=1
				select @zlfdm_hb = xmdm from #ghmx1 where ghxh = @ghzdxh and isghf=2
				select @hbdm = isnull(id,'') from GH_GHHBK where ghfdm = @ghfdm_hb and zlfdm= @zlfdm_hb and jlzt =0
				if @hbdm <> ''
				begin
					update GH_GHZDK SET ghlx = @hbdm where xh =@xhtemp
					if @@error<>0
					begin
						select "F","����Һ��˵�ghlx����"
						rollback tran
						deallocate cs_mzgh
						return		
					end
				end
			end	
			/*if @config1334='��'
			begin
			  exec usp_gh_zdfz @xhtemp,@errmsg output
			  if substring(@errmsg,1,1)='F'
			  begin
			    select "F",substring(@errmsg,2,49)
				  rollback tran
				  deallocate cs_mzgh
				  return
			  end 
			end*/--add  by zyj  for 59904 
		END
		fetch cs_mzgh into @ghzdxh, @ghlb, @cfzbz, @ksdm, @ksmc, @ysdm, @ysmc, @lybz, @yyxh, @yyrq, @zqdm, @xzks_id,@pbmxxh_temp,@kmdm,@kmmc,@fbdm,@fbmc,@zqmc,@zbdm_temp
	end
	close cs_mzgh
	deallocate cs_mzgh  
	insert into SF_BRJSK(sjh, patid, ghsjh, ghxh, fph, fpjxh, czyh, sfrq, sfksdm, ksdm, 
		hzxm, blh, ybdm, pzh, sfzh, ylxm, zddm, dwbm, zje, zfyje, yhje, deje, zfje, 
		zpje, zph, xjje, srje, qkbz, qkje, zxlsh, jslsh, ybjszt, zhbz, tsjh, jlzt, cardno,
		cardtype, ghsfbz, jcxh, memo, mjzbz, brlx, qrbz, tcljbz, tcljje, jmje,gxrq,lrrq,yhdm,fpdybz,appjkdm)
	select @sjh, patid, @sjh, @xhtemp, null, null, @czyh, @now, @ghksdm, @ksdm,
		hzxm, blh, @ybdm, pzh, sfzh, @xmlb, @zddm, dwbm, @zje, @zfyje, @yhje, 0, @sfje2,
		0, '', 0, @srje, @qkbz1, @qkje, null, null, 0, @zhbz, null, 0, cardno,
		cardtype, 0, null, null, (case when @ghlb=1 then 2 else 1 end), @brlx, @qrbz, @tcljbz, @tcljje, @jmje,@now,@now,@yhdm
		,@fpdybz,@kfsdm
		from #brxxk
	if @@error<>0
	begin
		select "F","��������˵�����"
		rollback tran
		return		
	end

	insert into SF_BRJSMXK(jssjh, dxmdm, dxmmc, fpxmdm, fpxmmc, xmje, zfje, zfyje, yhje, jmje, memo)
	select @sjh, dxmdm, dxmmc, mzfp_id, mzfp_mc, xmje, zfje, zfyje, yhje, jmje, null
		from #ghmx2
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
		insert into SF_BRJSK_FZ
		(sjh,patid,ghsjh,ghxh,fph,fpjxh,ip,mac,sfly)
		select                
		@sjh, @patid, @sjh, @xhtemp, null, null,'',@wkdz,@sfly
		if @@error<>0
		begin
			select "F","��������˵�����"
			rollback tran
			return		
		end	
	END	
	--Wxp20070317 �Զ�����ҽԺת�ﴦ�������ԷѺ������Ż�50%
	--������ @zzdjh <> '',�Ƕ�����ҽԺ����ͨ�Һŷѣ���Χ���ƣ��ҺŷѺ����Ʒ�
	if (@zzdjh <> '' and @yydj > 1 and @ghlb in (0,1)) 
	begin
		delete from  GH_ZZBRJLK  where zzdjh = @zzdjh and jszt <> 2 --���ϴ�û�н�����ɵļ�¼ɾ����
		if @@error<>0
		begin
			select "F","ɾ������ת�ﵥʱ����"
			rollback tran
			return		
		end
		insert into GH_ZZBRJLK(zzdjh,czyh,czrq,jmghf,jmzlf,fjzfbl,jssjh,jszt,jlzt)
		select @zzdjh ,@czyh,@now,@jmghf,@jmzlf,0,@sjh,0,0		
		if @@error<>0
		begin
			select "F","����ת�ﵥ��¼ʱ����"
			rollback tran
			return		
		end
	end
	if exists(select 1 from YY_CONFIG(nolock) where id='1416' and config='��')	
	begin	
		if exists(select 1 from #ghmx_hff)	
		begin	
			insert into SF_HJCFK( czyh,lrrq,patid,hzxm,py,wb,ysdm,ksdm,yfdm,sfksdm,qrczyh,qrrq,cfts,jlzt,cflx,ghxh,qrksdm,
			cftszddm,cftszdmc,medtype,medtypemc,ybbfz,ybbfzmc,tsyxbz) 
			select case @czyh when '' then @ysdm else @czyh end,@now,patid,hzxm,py,wb,case @ysdm when '' then @czyh else @ysdm end,
			@ksdm,@ksdm,@ksdm,case @czyh when '' then @ysdm else @czyh end,@now,1,
			--CASE @config1151 WHEN 1 THEN 0 ELSE 3 END,
			--0,--modified by mxd for bug:29479
			case @config2613 when '��' then 0 else 3 end, --add by liuquan vsts29479 ���2613=�񣬲�Ӧ�ý���
			7,@xhtemp,@ksdm,  
			'','','','','','','1'			 
			from #brxxk			
			if @@error<>0
			begin
				select "F","����Һŷ����Ʒѵ����۴������г���"
				rollback tran
				return		
			end
			select @xhtemp=@@identity
			insert into SF_HJCFMXK(cfxh,cd_idm,gg_idm,dxmdm,ypdm,ypdw,ypxs,ykxs,ypfj,ylsj,ts,ypsl,cfts,yhdj,ypmc,lcxmdm)
			select @xhtemp,0,0,b.dxmdm,a.xmdm,'',1,1,case when isnull(d.djjsbz,0) =1 then d.txdj else b.xmdj*isnull(d.txbl,1) end,
				case when isnull(d.djjsbz,0) =1 then d.txdj else b.xmdj*isnull(d.txbl,1) end,1,a.xmsl,1,0,b.name,0 
			from #ghmx_hff a
			inner join YY_SFXXMK b (nolock) on a.xmdm=b.id
			inner join YY_SFDXMK c(nolock) on c.id=b.dxmdm
			left join #txblxm d on a.xmdm=d.xmdm
			if @@error<>0
			begin
				select "F","����Һŷ����Ʒѵ����۴�����ϸ���г���"
				rollback tran
				return		
			end	
		end		
	end
	--if exists (select 1 from YY_LXHZXXK a(NOLOCK),SF_BRJSK b(nolock) where b.sjh=@sjh and a.sfzh=b.sfzh and (@now between a.yxksrq and a.yxjsrq)) 
	--begin
	--	update GH_GHZDK_FZ set lxbz=1 where jssjh=@sjh
	--	if @@error<>0
	--	begin
	--		select "F","����GH_GHZDK_FZ�е�lxbz����"
	--		rollback tran
	--		return		
	--	end
	--end
	commit tran
	if ltrim(rtrim(@ybdm)) = ltrim(rtrim(@scybdm))
		select @zfyje_sc = case when @ghlb not in (0,1) then @ghf else 0 end
	else
		select @zfyje_sc = @ghf
	select "T", @sjh, @zje, @sfje2-@qkje, @ybje, @ghf, @zlf, @yjye,@zfyje_sc,@jmje,@qkje,@yjye-@qkje 
end

return






