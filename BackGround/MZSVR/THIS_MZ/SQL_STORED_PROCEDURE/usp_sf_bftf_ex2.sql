Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE proc usp_sf_bftf_ex2
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
	,@bdyhkje ut_money = 0
	,@bdyhklsh ut_lsh = ''
	,@IsUseBdk ut_bz = 0
    ,@ysztfbz  ut_bz=0
	,@isQfbz   ut_bz=0
	,@sfywbzh ut_bz=0 -- �Ƿ����ⲿ�˻� 0 �� 1 �� add by aorigele     
    ,@jfje  ut_money=0 --�ⲿ�۷ѽ�� 
	,@yftfdybz ut_bz=1 --add by yjn 2013-07-26 ���ҩ���˷��Ƿ��ӡ��־ 0����ӡ 1��ӡ
	,@zzfs_tf ut_bz=1--֧����ʽ add by gxs  0:���ֽ�1����ԭ�з�ʽ���� 
	,@zffs	ut_bz=0
	,@sfksdm ut_ksdm=''	--�շѿ��Ҵ���
	,@isxjtf_paycenter ut_bz=0 --����֧�����İ��ֽ��˷�
	,@ipdz_gxzsj VARCHAR(30)=''
as --��51631 2019-04-24 18:20:35 4.0��׼��_201810����
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
	,@bdyhkje ut_money = 0   �����п�֧�����
	,@bdyhklsh ut_lsh = ''   �����п���ˮ�� 
	,@IsUseBdk ut_bz = 0  �Ƿ�ʹ�ð����п� 0 ��ʹ�� 1ʹ��
    ,@ysztfbz  ut_bz=0 ҽ��վ�˷ѱ�־��1 ҽ��վ����
	,@zffs ut_bz=0				--֧����ʽ0�����ֽ�1��ԭ·����
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��]

@sjh     �����վݺ�
@newsjh1  ����վݺ�
@newsjh  �����˷Ѻ�����վݺ�
[�޸ļ�¼]
ozb 20060622 ���ε��߷�Ʊ������ �ڴ�ӡ��Ʊǰ���� usp_sf_zfp���д�����Ϊ�շѺ�ŷַ�Ʊ
ozb 20060705 ���Ӽ����ԣ�������ǰ�ķ�Ʊ��ӡģʽ
yxp 2007-2-5 �������Զ����ۼ�¼,ykxs���治��ȷ���ᵼ�½���
yxp 2007-2-8 �����Զ����ۼ�¼ʱ���α�û��ʹ��distinct���ᵼ�µ��۵���¼����
mly 2007-04-29 ���ӵ���4��5ͳһ�ӿ� 0������ҩ�˷�
yxp 2007-8-28 ����usp_yf_jk_tjdzdsc��bug�޸ģ��������ò���
xwm 2011-12-03 3117�������ϣ�ֻ��ҩ����ҩ��������,
������Ȱ�˻��ǲ�����ҩ��ֻҪ��ҩƷ�Ƿ���ҩ�ļ�¼��Ҫ����usp_sf_bftf_fydcl�����ã������´�����Ӧ�ķ�ҩ���ݣ������ڴδ洢�����д���ҩ�����

�����˷ѣ����ռ�¼Ӧ�����¼֧����ʽ����һ�¡���Ȼ���ǲ�ƽ�ġ�
**********/
set nocount on

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
		@sfje_all ut_money,	--ʵ�ս��(�����Էѽ��)
		@errmsg varchar(50),
		@srbz char(1),		--�����־
		@srje ut_money,		--������
		@sfje2 ut_money,	--������ʵ�ս��
		@xhtemp ut_xh12,
		@ksmc ut_mc32,		--��������
		@ysmc ut_mc64,		--ҽ������
		@xmzfbl float,		--ҩƷ�Ը�����
		@xmzfbl1 float,		--��ҩƷ�Ը�����
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
		@djbz int,		--�����־
		@qkbz1 smallint,	--Ƿ���־0��������1�����ˣ�2��Ƿ��
		@yjbz ut_bz,		--�Ƿ�ʹ�ó�ֵ��
		@yjye ut_money		--Ԥ�������
		,@acfdfp ut_bz		--��������ӡmit 2oo3-11-o7
		,@sjyjye ut_money	--ʵ��Ѻ�����
		,@sjdjje ut_money	--ʵ�ʶ�����		--mit , 2oo3-11-19
		,@flzfje ut_money,	--�����Ը����
		@tcljbz ut_bz,		--ͳ���ۼƱ�־
		@tcljje ut_money,	--ͳ���ۼƽ��򱣡��½��ػ�ʹ�ã� 
		@tcljje1 ut_money,	--ͳ���ۼƽ��򱣡��½��ػ�ʹ�ã� 
 		@qkje_hc ut_money,
		@qkje_new ut_money,
		@qkje_view ut_money
		,@gyfpbz ut_bz		--���÷�Ʊ��־0:˽��1:����
		,@tsyhje ut_money  --�����Żݽ��
		,@gbje ut_money
		,@gbje1 ut_money
		,@ysybzfje  ut_money --ԭʼҽ���Ը����,2005-11-14�ɱ�Ҫ���ӡʵ�ʸɱ��Ը����
		,@gbje2 ut_money    --2005-11-14�ɱ�Ҫ���ӡ�Էѽ��2
		,@bdyhkje_old ut_money --ԭ��������֧�����
		,@gbbz ut_bz --�ɱ���־
		,@configdyms	ut_bz	--��ӡģʽ0 ��ģʽ 1 ��ģʽ	--add by ozb 20060704
		,@tcljybdm varchar(500)  --ͳ���ۼ�ҽ������
		,@lczje ut_money		--���ҩ���ܽ��	
		,@lcyhje ut_money       --����Żݽ��
		,@config3117 ut_bz		--ҩ����ҩʱ�Ƿ�����[����˷ѹ�ͬʵ�֣����������޸�] --add by sunyu 20080408 0:��1:��
		,@bdyfplb varchar(255)	--zfjeΪ0ʱ����ӡ��Ʊҽ�����뼯��
		,@yflsh integer  --ҩ����ˮ�� --add by xr 2010-09-17
		,@fyckdm1 ut_dm2 --��ҩ���ڴ���1 --add by xr 2010-09-17
		,@fyckxh  integer --��ҩ������� --add by xr 2010-09-17
        ,@now8 ut_rq16		
		,@hzdybz ut_bz --ȷ�ϱ�־ 0����ȷ�� 1δȷ�� 2��ȷ��
		,@fpdybz	ut_bz		--��Ʊ��ӡ��־
		,@fpdyczyh	ut_czyh		--��Ʊ��ӡ����Ա
		,@fpdyrq	ut_rq16		--��Ʊ��ӡ����

declare @jzxh ut_xh12,
		@czym ut_mc64,
		@pycfxh	ut_xh12,	--SF_PYQQK��Ӧ�Ĵ�����xh
		@pyhjxh	ut_xh12,	--SF_PYQQK��Ӧ�Ĵ�����hjxh
		@pyfybz	ut_bz,		--�����ⷢҩ��־
		@qqkpybz	ut_bz,	--SF_PYQQK����ҩ��־
		@havejl	ut_bz,		--������SF_PYQQK���Ƿ��м�¼
		@pyhcxh	ut_xh12,	--���������¼��xh
		@pyhcsjh	ut_sjh,	--���������¼��sjh
		@qqxh	ut_xh12,		--SF_PYQQK��xh
        @fpbz ut_bz ---0��ӡ1����ӡ
        ,@dbkzf1  ut_money   --���ҿ�ת�沿��ԭ֧�����
        ,@dbkzf   ut_money   --���ҿ�ת�沿����֧�����
        ,@dbkye   ut_money   --���ҿ�ת�沿�����
		,@yytbz ut_bz 
declare @yfdm ut_ksdm,
		@cd_idm			ut_xh9
		,@zpje_yyt		ut_money	--��ҽͨzpje add by gxs
		,@zpje_zfzx		ut_money	--֧������֧����(���ս��)
		,@zpje_zfzx1	ut_money	--֧������֧����(�����)
		,@config0220	ut_bz		--1�����źͿ��Ҵ����췢Ʊģʽ0��ͳģʽ
		,@configA234 ut_bz  -- ADD KCS �Ƿ�����HRPϵͳ
		,@fpdm varchar(16)
		,@yhyydm varchar(16)
		,@config2555 varchar(20) --�����˷ѽ���֧������ǿ�ư����ֽ��˷ѵ�֧����ʽ����
		,@oldzph	varchar(5)
		,@config2596	varchar(5)
select @now8 = convert(char(8),getdate(),112),@yflsh = 0
select @now=convert(char(8),getdate(),112)+convert(char(8),getdate(),8),
	@zje=0, @zfyje=0, @yhje=0, @ybje=0,
	@zje1=0, @zfyje1=0, @yhje1=0, @ybje1=0,
	@sfje=0, @sfje1=0, @sfje_all=0, @srje=0, @sfje2=0, 
	@xmzfbl=0, @xmzfbl1=0, @xmce=0, @print=0, @tfbz=0,
	@qkbz=0, @qkje=0, @qkje1=0, @zhje=0, @djbz=0, @qkbz1=0, @yjbz=0, @yjye=0
	,@sjyjye=0,@sjdjje=0, @flzfje=0, @tcljbz=0, @tcljje=0, @tcljje1=0
	,@qkje_hc=0, @qkje_new=0, @gyfpbz=0,@tsyhje = 0, @gbje=0, @gbje1=0,@ysybzfje = 0
	,@gbbz = '0',@lcyhje = 0,@lczje = 0,@fpbz =0,@yflsh=0,@hzdybz =0,@zpje_yyt = 0,
	@zpje_zfzx=0,@zpje_zfzx1=0,@yhyydm='0'
	
if (select config from YY_CONFIG (nolock) where id='0220')='��'      
	select @config0220=1      
else      
	select @config0220=0 
	
if (select config from YY_CONFIG (nolock) where id='2044')='��'
	set @acfdfp=0
else
	set @acfdfp=1
	
if (select config from YY_CONFIG (nolock) where id='A234')='��'      
	select @configA234=1      
else      
	select @configA234=0  
	
select @czym=name from czryk where id=@czyh

if (select config from YY_CONFIG (nolock) where id='2135')='��'
	select @gyfpbz = 1
else
	select @gyfpbz = 0 
select @config2555 =config  from YY_CONFIG (nolock) where id='2555' 
select @config2596=config from YY_CONFIG (nolock) where id='2596' 
--add by ozb �շ��Ƿ�ʹ���µĴ�ӡģʽ
if exists(select 1 from YY_CONFIG where id='2154' and config='��')
	select @configdyms=1 
else 
	select @configdyms=0

--add by sunyu 20080408
if exists(select 1 from YY_CONFIG where id='3117' and config='��')
	select @config3117=1
else
	select @config3117=0

if exists(select 1 from YY_CONFIG where id='0162' and config='1')    
  select @yytbz=1
else 
if exists (select 1 from YY_CONFIG where id='2258' and config='��')
  select @yytbz=1
 else
 select @yytbz=0


if @sfbz=2 --ʵʱҽ������2�����������˷�ȷ��
begin
	if (select config from YY_CONFIG (nolock) where id='2101')='��'
		select @djbz=1

	select @newsjh1=sjh from SF_BRJSK where tsjh=@sjh and ybjszt=0 and jlzt=2 and czyh=@czyh
	if @@error<>0 or @@rowcount=0
	begin
		select "F","��ȡ�˷���Ϣ����"
		return
	end
	
	--��ȡ����¼zph
	select @oldzph=zph from VW_MZBRJSK where sjh=@sjh and ybjszt=2
	 
    if @isxjtf_paycenter=1
    begin
        if @qtbz=1--ȫ��
        begin
            --ȫ�˸��º���¼
            --update SF_BRJSK set xjje=xjje+zpje,zpje=0,zph='S' where sjh=@newsjh1
			update SF_BRJSK set xjje=xjje+zpje,zpje=0,zph='' where sjh=@newsjh1    --֧Ʊ���0��֧Ʊ�ſ�
        end
        else
        begin
            --������ �������ռ�¼ --�ֽ��� ��������
            declare @zpje_old  ut_money                    
            --select @zpje_old=zpje from VW_MZBRJSK (nolock) where sjh=@sjh
			select @zpje_old=zfje-qkje from VW_MZBRJSK (nolock) where sjh=@newsjh
                        
			--����֧���������ֽ𣬲����˷����յ�ʱ��϶����ֽ����գ�zph���ܸ���ΪS��
            --update SF_BRJSK set zpje=@zpje_old,zph='S' where sjh=@newsjh
        end
    end	
    else if (@isxjtf_paycenter=0) and (@oldzph='S')
    begin
		declare @xjje_temp ut_money
		select @xjje_temp=isnull(sum(paymoney),0) from YY_PAYDETAILK (nolock) 
		where jssjh=@sjh and jlzt in (0,1) and zfzt=1 and charindex(rtrim(ltrim(paytype)),isnull(@config2555,''))>0 
		--add by mxd for bug :374071 ����2555�ڲ���0339=0ʱ��Ч
		and exists(select 1 from dbo.YY_CONFIG where id='0339' and substring(config,2,1)='0')
        if @qtbz=1--ȫ��
        begin
            --ȫ�˸��º���¼
            update SF_BRJSK set xjje=xjje-@xjje_temp,zpje=zpje+@xjje_temp,zph='S' where sjh=@newsjh1
        end
        else
        begin
			--������ �������ռ�¼ --�ֽ��� ��������
			update SF_BRJSK set xjje=xjje-@xjje_temp,zpje=zpje+@xjje_temp,zph='S' where sjh=@newsjh1
			select @zpje_old=zfje-qkje from SF_BRJSK (nolock) where sjh=@newsjh
		    
			
			----������ �������ռ�¼ --�ֽ��� ��������
			update SF_BRJSK set zpje=case when (@zpje_old-@xjje_temp>0) then @zpje_old-@xjje_temp else 0 end,zph='S' 
			where sjh=@newsjh
        end
    end	
	else if (@zffs = 1) and (@oldzph<>'')  --�жϱ���ԭ��ʽ�˷ѣ��������ռ�¼֧Ʊ���ֽ��������£����Ϊ���ֽ������ȸ���֧Ʊ�������ֽ�����㲻�ԣ�
	begin
		if @qtbz=0 --�ο��洢����usp_pay_autosetbftfzfinfo
		begin
			--��ȡ����Ҫ֧���ķ���
			declare @oldzpje ut_money,
					@newzpje ut_money,
					@newzfje ut_money
			select @oldzpje=case when zph<>'' then zpje else 0 end from VW_MZBRJSK(nolock) where sjh=@sjh
			select @newzfje=zfje-qkje from SF_BRJSK(nolock) where sjh=@newsjh

			--�µ�֧�����ܳ���ԭ����֧����������ܳ��ֲ���֧�������
			--Ĭ�����Ȱ��ֽ��ˣ����ղ�������ʹ�÷��ֽ�֧����ʽ
			if @newzfje<=@oldzpje
				select @newzpje=@newzfje
			else
				select @newzpje=@oldzpje

			update SF_BRJSK set zph=@oldzph,zpje=@newzpje where sjh = @newsjh
		end
	end
	else if (@zffs=0) and (@oldzph<>'')
	begin
		--����û��������2545�ڵĲ�����ǿ��ת��Ϊԭ��ʽ�˻�  20180627
		declare @config2545 varchar(200)
		select @config2545 = config from YY_CONFIG WHERE id='2545'
		if @qtbz=1 and CHARINDEX(','+@oldzph+',',@config2545)=0 and @oldzph <> '7'
		begin
			--ȫ�˸��º���¼
            update SF_BRJSK set xjje=0,zpje=xjje+zpje,zph=@oldzph where sjh=@newsjh1   
		end
	end
	
	

	select @qkbz=qkbz, @qkje1=-qkje, @patid=patid, @ybdm=ybdm, @tcljje=zje-zfyje, @tcljbz=tcljbz 
		,@tsyhje = tsyhje, @gbje1=-gbje,@yhje1=yhje,
		--@zpje_zfzx1=case when zph  in ('S') then -isnull(zpje,0) else 0 end 
		---ȡ���������ֽ𣬲����S
		@zpje_zfzx1=0
	from SF_BRJSK where sjh=@newsjh1
	if @@rowcount=0
	begin
		select "F","��ȡ�˷���Ϣ����"
		return
	end

	select @pzlx=pzlx from YY_YBFLK (nolock) where ybdm=@ybdm
	if @@rowcount=0 or @@error<>0
	begin
		select "F","���߷��������ȷ��"
		return
	end

	--mit ,, 2oo3-11-o7 ,,�����ж��Ƿ��г�ֵ��

	select @jzxh=case when isnull(zcbz,0)=0 then xh else isnull(zkxh,xh) end ,
         @fpbz =isnull(fpbz,0)
		from YY_JZBRK where patid=@patid and jlzt=0
	if @@rowcount>0
	begin
		select @yjye=yjye-isnull(djje,0) from YY_JZBRK where xh=@jzxh and jlzt=0
		if @@rowcount=0
        begin
			select @yjye=0
            select @fpbz=0
        end
		else
			select @yjbz=1
	end
    if (select config from YY_CONFIG (nolock) where id='0133')='��' and @fpbz ='1'
		select @print=2

	if (select config from YY_CONFIG (nolock) where id='1022')='��'
		select @fplx=0
	else
		select @fplx=1

	if @qtbz=0
	begin
		select @ybdm=ybdm, @qkbz1=qkbz,@qkje=qkje, @zje=zje, @sfje2=zfje, @zfyje=zfyje, @flzfje=flzfje,
			@tcljje1=zje-zfyje, @gbje=gbje,@gbbz = gbbz,@lcyhje = lcyhje,@lczje = @zje - lcyhje,@yhje=yhje
			,@hzdybz =hzdybz,@zpje_zfzx=case when zph='S' then isnull(zpje,0) else 0 end
			from SF_BRJSK(nolock) where sjh=@newsjh
		if @@rowcount=0
		begin
			select "F","��ȡ�˷���Ϣ����"
			return
		end

		if @qkbz=2 and @qkje1>0
			select @print=1
		
		select @bdyfplb=config from YY_CONFIG where id='2161'
		if @sfje2=0
			if charindex(','+ltrim(rtrim(@ybdm))+',', ','+@bdyfplb+',')>0
				select @print=1

		if (select config from YY_CONFIG (nolock) where id='2238')='��'





		begin 
			if @sfje2 = 0 
				select @print=1 
		end
        --�Ϸ�Ʊģʽ�����ӶԲ���2273�ܿ�
		if exists(select 1 from YY_CONFIG where id = '2273' and charindex(',' + LTrim(RTrim(@ybdm)) + ',',','+config+',')>0) 
			select @print=1
			
		--add wuwei for bug 104037 �Ϸ�Ʊģʽ��,qrbz=1�Ĳ����˷�,���ӡ,Ӧ�ò���ӡ�Ŷ�.
		if @hzdybz =1
		begin
			select @print =1

		end
		--add by will for bug 103404
		--add by sxm bug160918 1������2275��ҽ���������˻���־Ϊ2�Ĳ�������<����Ƿ��>�Ƿ��ӡ��Ʊ
        -- 2275=�ǣ�Ƿ�Ѳ��˲����˷�4�����ӡ��Ʊ��û���޸Ķ�Ӧ��usp_sf_bftf_ex2 
		
		if exists(select 1 from YY_CONFIG (NOLOCK)WHERE id='2275' and config='��') and 	@qkbz1=2 
		BEGIN
			select @print=0	
		END			
		
		declare @config2238 varchar(20)  
		select @config2238 =config from YY_CONFIG where id ='2238'
		if exists(select 1 from SF_BRJSK where sjh=@newsjh and zfje=0 and @config2238='��')
			set @isQfbz=1
			
		--add by yjn 2013-07-26 ���ҩ���˷��Ƿ��ӡ	
		if @yftfdybz=0
		begin
		    select @print=1
			if @qtbz =0
			begin	
				update SF_BRJSK set qrbz =case qrbz when 0 then 0 else 1 end where sjh =@newsjh
				if @@error <>0
				begin
					select "F","ҩ�����´�ӡ��־����"
					return
				end
			end			    
		end
		
		if @print=0 and @configdyms=0 and @isQfbz=0--add by ozb ���ݾɵĴ�ӡģʽand @configdyms=0
		begin
			--add by qxh 2003.5.27		
			if @acfdfp=0 



		    begin
				if @gyfpbz=0
				begin
					if @config0220=1
					select @fph=fpxz, @fpjxh=xh,@fpdm=isnull(fpdm,'') from SF_FPDJK(nolock) where lyry=@czyh and jlzt=1 and xtlb=@fplx and ksdm=@sfksdm
					else
					select @fph=fpxz, @fpjxh=xh,@fpdm=isnull(fpdm,'') from SF_FPDJK(nolock) where lyry=@czyh and jlzt=1 and xtlb=@fplx
					if @@rowcount=0
					begin
						select "F","û�п��÷�Ʊ��"


						return
					end
				end
				else
				begin
					select @fph=fpxz, @fpjxh=0,@fpdm=isnull(fpdm,'') from SF_GYFPK where czyh=@czyh and xtlb=@fplx
					if @@rowcount=0
					begin
						select "F","û�п��÷�Ʊ��"


						return
					end
				end
			end
			else
			begin
				--��������ӡ��Ʊʱ���߷�Ʊ����
				exec usp_sf_acfdfp_zfp @newsjh,1,@czyh,@errmsg output,@sfksdm
				if @errmsg like 'F%'
				begin
					select "F",substring(@errmsg,2,49)


					return
				end		
				select top 1 @fph=fph,@fpjxh=fpjxh from SF_MZCFK(nolock) where jssjh=@newsjh order by fph		















			end
		end		










	end
	else
		select @print=1

    if @ysztfbz=1
        select @print=3
	
	select xh, txh into #tfmzcf from SF_MZCFK where jssjh=@newsjh1
	if @@error<>0
	begin
		select "F","��ȡ�˷���Ϣ����"
		return
	end

	--�Ƿ�ⶳҩ�����
	
	if @djbz=1 and exists(select 1 from SF_MZCFK where jssjh=@sjh and cflx in (1,2,3) and fybz=0)
	begin
		select a.yfdm, b.cd_idm,b.cfts*b.ypsl ypsl,b.xh,0 cssl,0 csxh
		into #djtemp from SF_MZCFK a, SF_CFMXK b
		where a.jssjh=@sjh and a.cflx in (1,2,3) and a.fybz=0 and a.xh=b.cfxh

		if @@error<>0
		begin
			select "F","�ⶳҩ��������"
			return
		end

		update #djtemp set cssl=b.ypsl,csxh=b.xh
		from #djtemp a, (select a.yfdm, b.cd_idm, (b.cfts*b.ypsl) ypsl,b.xh from SF_MZCFK a, SF_CFMXK b
			where a.jssjh=@newsjh and a.cflx in (1,2,3) and a.fybz=0 and a.xh=b.cfxh
			--group by a.yfdm, b.cd_idm
			) b
			where a.cd_idm=b.cd_idm and a.yfdm=b.yfdm
		if @@error<>0
		begin
			select "F","�ⶳҩ��������"
			return
		end

		select @djbz=2
	end

	begin tran
	-- add kcs by 11439 �������ʿ��
	if (@configA234 = 1) and (exists (select 1 from SF_BRJSK a
					inner join SF_MZCFK b on a.sjh = b.jssjh
					inner join SF_CFMXK c on b.xh = c.cfxh
					inner join SF_HJCFMXK d on c.hjmxxh = d.xh
					where a.sjh = @newsjh1 and ISNULL(d.wzkfdm,'') <> '' and isnull(d.wzdm,'')<>''))   -- ����Ҫ��ͨ��SF_HJCFMXK.wzkfdm �Ƿ���ֵ�ж��Ƿ�۷ѿۿ��
	begin
	    declare 
		   @kc_ifid               ut_xh12,                --�ӿ�ȫ�ֱ�ʶ
		   @kc_ifid_t             ut_xh12,                --�����
		   @kc_kfdm               varchar(12),            --�����ҿⷿ
		   @kc_wzdm               ut_xh12,                --���ʴ���
		   @kc_xmmc               ut_mc64,    --��Ŀ����
		   @kc_pcxh               varchar(120),           --��ʱ,���벻��Ϊ��
		   @kc_wzsl               ut_sl10,            --����Ϊ��
		   @kc_xhfs               ut_zt,                  --���ķ�ʽ:0: ���ϼ���; 1: ���ϲ�����; 3. ҽ��ִ��; 4.ҽ���շ�; 5.��������,6.������������¼��; 9.����
		   @kc_ksdm               ut_ksdm,         --������  �۷ѿ��Ҵ���
		   @kc_ksmc               ut_mc32,         --�۷ѿ������
		   @kc_bqdm               ut_ksdm,
		   @kc_bqmc               ut_mc32,
		   @kc_pKsdmBr            ut_ksdm,         --���˿��Ҵ���,��Ƶ�סԺ����
		   @kc_pKsmcBr            ut_mc32,         --���˿�������
		   @kc_pDrName            ut_mc64,         --ҽ������������ǩ��
		   @kc_pNurseName         ut_mc64,         --��ʿ����������ǩ��
		   @kc_syxh               ut_syxh,
		   @kc_blh                ut_blh,
		   @kc_ch                 ut_mc16,         --����
		   @kc_patid              ut_syxh,
		   @kc_patname            ut_mc64,
		   @kc_zxczy              ut_czyh,
		   @kc_zxczyxm            ut_mc64,
		   @kc_lrczy              ut_czyh,         --¼�����Ա
		   @kc_lrczyxm            ut_mc64,         --¼�����Ա����
		   @kc_fymxh              ut_xh12,         --������ϸ��
		   @kc_pHjmxh             ut_xh12,  --������ϸ��
		   @kc_pTxmMaster         ut_mc64,         --��������
		   @kc_pTxmSlave          ut_mc64,         --��������
		   @kc_pNeedNewBill       ut_zt,            -- ��¼�����
		   @kc_memo               ut_memo,         -- ��ע
		   @outpcxh            ut_mc64,
		   @outpcsl            ut_mc64,
		   @hrperrmsg             ut_mc64,
		   @config6845            VARCHAR(20),
		   @sql                   nVARCHAR(3000),
		   @ParmDefinition        nvarchar(500)
		    
		
		select @kc_wzsl = 1,@kc_pHjmxh = -1,@kc_pNeedNewBill = '0'
		select @config6845 = config from YY_CONFIG where id = '6845'
		
		-- ��������վ��ѿ۵Ŀ��
		declare lscm_kc cursor for select c.xh from SF_BRJSK a
					inner join SF_MZCFK b on a.sjh = b.jssjh
					inner join SF_CFMXK c on b.xh = c.cfxh
					inner join SF_HJCFMXK d on c.hjmxxh = d.xh
					where a.sjh = @newsjh1 and ISNULL(d.wzkfdm,'') <> '' and isnull(d.wzdm,'')<>''
	    open lscm_kc
	    fetch lscm_kc into @kc_ifid
		while @@fetch_status=0 
	    begin        
	        select @kc_kfdm = b.wzkfdm,@kc_ifid_t=a.tmxxh,@kc_wzdm = b.wzdm,@kc_xmmc = a.ypmc,@kc_pcxh = b.wzpcxh,@kc_wzsl = a.ypsl,
	               @kc_ksdm = c.sfksdm,@kc_ksmc = d.name,@kc_fymxh = a.xh,@kc_pHjmxh = b.xh,@kc_pTxmMaster = b.tm,
	               @kc_pTxmSlave = b.ctxm,@kc_pKsdmBr = e.ksdm,@kc_pKsmcBr = f.name,@kc_pDrName = g.name,@kc_blh = h.blh,
	               @kc_patid = @patid,@kc_patname = h.hzxm,@kc_zxczy = e.qrczyh,@kc_zxczyxm = i.name  
	                 from SF_CFMXK a
	                 inner join SF_HJCFMXK b on a.hjmxxh = b.xh
	                 inner join SF_BRJSK c on c.sjh = @newsjh1
	                 inner join YY_KSBMK d on c.sfksdm = d.id
	                 left join SF_MZCFK e on a.cfxh = e.xh
	                 left join YY_KSBMK f on e.ksdm = f.id
	                 left join YY_ZGBMK g on e.ysdm = g.id
	                 left join SF_BRXXK h on e.patid = h.patid
	                 left join czryk i on e.qrczyh = i.id
					 where a.xh = @kc_ifid
					 
			select @sql = N'exec ' + @config6845 + 'dbo.USP_LSCM_IF4THIS_KC @ifid = ' + convert(varchar(12),isnull(@kc_ifid,0))
			            +', @ifid_t = ' + convert(varchar(12),isnull(@kc_ifid_t,0))
			            +', @kfdm = "' + convert(varchar(12),isnull(@kc_kfdm,''))
			            +'", @wzdm = ' + convert(varchar(12),isnull(@kc_wzdm,0))
			            +', @xmmc = "'+ convert(varchar(64),isnull(@kc_xmmc,''))
			            +'",@pcxh=' + convert(varchar(12),isnull(@kc_pcxh,0))
			            +',@wzsl=' + convert(varchar(12),isnull(@kc_wzsl,''))
			            +',@xhfs=7,'
			            +'@ksdm="' + convert(varchar(12),isnull(@kc_ksdm,''))
			            +'",@ksmc="'+ convert(varchar(64),isnull(@kc_ksmc,''))
			            +'",@pHjmxh='+ convert(varchar(12),isnull(@kc_pHjmxh,''))
			            +',@pTxmMaster="'+convert(varchar(64),isnull(@kc_pTxmMaster,''))
			            +'",@pTxmSlave="'+convert(varchar(64),isnull(@kc_pTxmSlave,''))
			            +'",@pKsdmBr="'+convert(varchar(12),isnull(@kc_pKsdmBr,''))
			            +'",@pKsmcBr="'+convert(varchar(12),isnull(@kc_pKsmcBr,''))
			            +'",@pDrName="'+convert(varchar(64),isnull(@kc_pDrName,''))
			            +'",@blh="'+convert(varchar(12),isnull(@kc_blh,''))
			            +'",@patid="'+convert(varchar(12),isnull(@kc_patid,0))
			            +'",@patname="'+convert(varchar(64),isnull(@kc_patname,''))
			            +'",@zxczy="'+convert(varchar(12),isnull(@kc_zxczy,''))
			            +'",@zxczyxm="'+convert(varchar(64),isnull(@kc_zxczyxm,''))
			            +'"'
			            
			select  @sql = @sql + N',@outpcxh = @outpcxh OUTPUT ,@outpcsl = @outpcsl output,@errmsg = @hrperrmsg output '
			set  @ParmDefinition = N' @outpcxh varchar(100) output,@outpcsl  varchar(100) output,  @hrperrmsg varchar(64) output '
			            
			exec sp_executesql @sql,@ParmDefinition,@outpcxh = @outpcxh OUTPUT,@outpcsl = @outpcsl OUTPUT ,@hrperrmsg=@hrperrmsg OUTPUT 		
            IF (@@ERROR<>0)or (@hrperrmsg like 'F%')
            begin
                select 'F','�۳����ʿ��ʧ�ܣ�'
				rollback tran
				DEALLOCATE lscm_kc
                return      
            end
            
			select @sql = N'exec ' + @config6845 + 'dbo.USP_LSCM_IF4THIS_KC @ifid = ' + convert(varchar(12),isnull(@kc_ifid,0))
			            +', @ifid_t = ' + convert(varchar(12),isnull(@kc_ifid_t,0))
			            +', @kfdm = "' + convert(varchar(12),isnull(@kc_kfdm,''))
			            +'", @wzdm = ' + convert(varchar(12),isnull(@kc_wzdm,0))
			            +', @xmmc = "'+ convert(varchar(64),isnull(@kc_xmmc,''))
			            +'",@pcxh=' + convert(varchar(12),isnull(@kc_pcxh,0))
			            +',@wzsl=' + convert(varchar(12),isnull(@kc_wzsl,''))
			            +',@xhfs=7,'
			            +'@ksdm="' + convert(varchar(12),isnull(@kc_ksdm,''))
			            +'",@ksmc="'+ convert(varchar(64),isnull(@kc_ksmc,''))
			            +'",@pHjmxh='+ convert(varchar(12),isnull(@kc_pHjmxh,''))
			            +',@pTxmMaster="'+convert(varchar(64),isnull(@kc_pTxmMaster,''))
			            +'",@pTxmSlave="'+convert(varchar(64),isnull(@kc_pTxmSlave,''))
			            +'",@pKsdmBr="'+convert(varchar(12),isnull(@kc_pKsdmBr,''))
			            +'",@pKsmcBr="'+convert(varchar(12),isnull(@kc_pKsmcBr,''))
			            +'",@pDrName="'+convert(varchar(64),isnull(@kc_pDrName,''))
			            +'",@blh="'+convert(varchar(12),isnull(@kc_blh,''))
			            +'",@patid="'+convert(varchar(12),isnull(@kc_patid,0))
			            +'",@patname="'+convert(varchar(64),isnull(@kc_patname,''))
			            +'",@zxczy="'+convert(varchar(12),isnull(@kc_zxczy,''))
			            +'",@zxczyxm="'+convert(varchar(64),isnull(@kc_zxczyxm,''))
			            +'",@fymxh="'+convert(varchar(12),isnull(@kc_fymxh,''))
			            +'"'
			            
			select  @sql = @sql + N',@outpcxh = @outpcxh OUTPUT ,@outpcsl = @outpcsl output,@errmsg = @hrperrmsg output '
			set  @ParmDefinition = N' @outpcxh varchar(100) output,@outpcsl  varchar(100) output,  @hrperrmsg varchar(64) output '
			            
			exec sp_executesql @sql,@ParmDefinition,@outpcxh = @outpcxh OUTPUT,@outpcsl = @outpcsl OUTPUT ,@hrperrmsg=@hrperrmsg OUTPUT 		
            IF (@@ERROR<>0)or (@hrperrmsg like 'F%')
            begin
                select 'F','�۳����ʿ��ʧ�ܣ�'
				rollback tran
				DEALLOCATE lscm_kc
                return      
            end            
            
            if exists(select 1 From sysobjects where name ='YY_SF_HRP_LOG')
            begin            
				insert into YY_SF_HRP_LOG(
				kc_ifid            
				,kc_ifid_t          
				,kc_kfdm            
				,kc_wzdm            
				,kc_xmmc            
				,kc_pcxh            
				,kc_wzsl            
				,kc_xhfs            
				,kc_ksdm            
				,kc_ksmc          
				,kc_bqdm            
				,kc_bqmc            
				,kc_pKsdmBr         
				,kc_pKsmcBr         
				,kc_pDrName         
				,kc_pNurseName      
				,kc_syxh            
				,kc_blh             
				,kc_ch              
				,kc_patid           
				,kc_patname         
				,kc_zxczy           
				,kc_zxczyxm         
				,kc_lrczy           
				,kc_lrczyxm         
				,kc_fymxh           
				,kc_pHjmxh          
				,kc_pTxmMaster      
				,kc_pTxmSlave       
				,kc_pNeedNewBill    
				,kc_memo            
				,outpcxh            
				,outpcsl            
				,hrperrmsg          
				 )
				 values
				 (
				 @kc_ifid          
				,@kc_ifid_t       
				,@kc_kfdm         
				,@kc_wzdm         
				,@kc_xmmc         
				,@kc_pcxh         
				,@kc_wzsl         
				,@kc_xhfs         
				,@kc_ksdm         
				,@kc_ksmc         
				,@kc_bqdm         
				,@kc_bqmc         
				,@kc_pKsdmBr      
				,@kc_pKsmcBr      
				,@kc_pDrName      
				,@kc_pNurseName   
				,@kc_syxh         
				,@kc_blh          
				,@kc_ch           
				,@kc_patid        
				,@kc_patname      
				,@kc_zxczy        
				,@kc_zxczyxm      
				,@kc_lrczy        
				,@kc_lrczyxm      
				,@kc_fymxh        
				,@kc_pHjmxh       
				,@kc_pTxmMaster   
				,@kc_pTxmSlave    
				,@kc_pNeedNewBill 
				,@kc_memo         
				,@outpcxh         
				,@outpcsl         
				,@hrperrmsg  
				 )            
				IF (@@ERROR<>0)
				begin
					select 'F','�۳����ʿ��ʧ�ܣ�'
					rollback tran
					DEALLOCATE lscm_kc
					return      
				end               
            end            
                                   
            fetch lscm_kc into @kc_ifid
        end
        close lscm_kc
        deallocate lscm_kc
        
        -- �������վݺ��ٿ�һ�ο��
        declare lscm_kc1 cursor for select c.xh from SF_BRJSK a
					inner join SF_MZCFK b on a.sjh = b.jssjh
					inner join SF_CFMXK c on b.xh = c.cfxh
					inner join SF_HJCFMXK d on c.hjmxxh = d.xh
					where a.sjh = @newsjh and ISNULL(d.wzkfdm,'') <> '' and isnull(d.wzdm,'')<>''
	    open lscm_kc1
	    fetch lscm_kc1 into @kc_ifid
		while @@fetch_status=0 
	    begin        
	        select @kc_kfdm = b.wzkfdm,@kc_ifid_t=a.tmxxh,@kc_wzdm = b.wzdm,@kc_xmmc = a.ypmc,@kc_pcxh = b.wzpcxh,@kc_wzsl = a.ypsl,
	               @kc_ksdm = c.sfksdm,@kc_ksmc = d.name,@kc_fymxh = a.xh,@kc_pHjmxh = b.xh,@kc_pTxmMaster = b.tm,
	               @kc_pTxmSlave = b.ctxm,@kc_pKsdmBr = e.ksdm,@kc_pKsmcBr = f.name,@kc_pDrName = g.name,@kc_blh = h.blh,
	               @kc_patid = @patid,@kc_patname = h.hzxm,@kc_zxczy = e.qrczyh,@kc_zxczyxm = i.name
	                 from SF_CFMXK a
	                 inner join SF_HJCFMXK b on a.hjmxxh = b.xh
	                 inner join SF_BRJSK c on c.sjh = @newsjh
	                 inner join YY_KSBMK d on c.sfksdm = d.id
	                 left join SF_MZCFK e on a.cfxh = e.xh
	                 left join YY_KSBMK f on e.ksdm = f.id
	                 left join YY_ZGBMK g on e.ysdm = g.id
	                 left join SF_BRXXK h on e.patid = h.patid
	                 left join czryk i on e.qrczyh = i.id
					 where a.xh = @kc_ifid
					 
			select @sql = N'exec ' + @config6845 + 'dbo.USP_LSCM_IF4THIS_KC @ifid = ' + convert(varchar(12),isnull(@kc_ifid,0))
			            +', @kfdm = "' + convert(varchar(12),isnull(@kc_kfdm,''))
			            +'", @wzdm = ' + convert(varchar(12),isnull(@kc_wzdm,0))
			            +', @xmmc = "'+ convert(varchar(64),isnull(@kc_xmmc,''))
			            +'",@pcxh=' + convert(varchar(12),isnull(@kc_pcxh,0))
			            +',@wzsl=' + convert(varchar(12),isnull(@kc_wzsl,''))
			            +',@xhfs=7,'
			            +'@ksdm="' + convert(varchar(12),isnull(@kc_ksdm,''))
			            +'",@ksmc="'+ convert(varchar(64),isnull(@kc_ksmc,''))
			            +'",@pHjmxh='+ convert(varchar(12),isnull(@kc_pHjmxh,''))
			            +',@pTxmMaster="'+convert(varchar(12),isnull(@kc_pTxmMaster,''))
			            +'",@pTxmSlave="'+convert(varchar(12),isnull(@kc_pTxmSlave,''))
			            +'",@pKsdmBr="'+convert(varchar(12),isnull(@kc_pKsdmBr,''))
			            +'",@pKsmcBr="'+convert(varchar(12),isnull(@kc_pKsmcBr,''))
			            +'",@pDrName="'+convert(varchar(64),isnull(@kc_pDrName,''))
			            +'",@blh="'+convert(varchar(12),isnull(@kc_blh,''))
			            +'",@patid="'+convert(varchar(12),isnull(@kc_patid,''))
			            +'",@patname="'+convert(varchar(64),isnull(@kc_patname,''))
			            +'",@zxczy="'+convert(varchar(12),isnull(@kc_zxczy,''))
			            +'",@zxczyxm="'+convert(varchar(64),isnull(@kc_zxczyxm,''))
			            +'"'
			 
			select  @sql = @sql + N',@outpcxh = @outpcxh OUTPUT ,@outpcsl = @outpcsl output,@errmsg = @hrperrmsg output '
			set  @ParmDefinition = N' @outpcxh varchar(100) output,@outpcsl  varchar(100) output,  @hrperrmsg varchar(64) output '
			            
			exec sp_executesql @sql,@ParmDefinition,@outpcxh = @outpcxh OUTPUT,@outpcsl = @outpcsl OUTPUT ,@hrperrmsg=@hrperrmsg OUTPUT 		
            IF (@@ERROR<>0)or (@hrperrmsg like 'F%')
            begin
                select 'F','�۳����ʿ��ʧ�ܣ�'
				rollback tran
				DEALLOCATE lscm_kc1
                return      
            end
            fetch lscm_kc1 into @kc_ifid
        end
        close lscm_kc1
        deallocate lscm_kc1
	end
	----------------------------���������˷Ѽ�¼
	declare @config2437 varchar(20)
	select @config2437 = config from YY_CONFIG where id = '2437'
	if @config2437='��'
	begin
	   if exists( select 1 from SF_TFSQK a(nolock),VW_MZCFK b(nolock) where a.cfxh = b.xh and a.jlzt = 1 and b.jssjh=@sjh)
	   begin
	       update a set a.jlzt=2,tfrq=@now from SF_TFSQK a(nolock),VW_MZCFK b(nolock) where a.cfxh = b.xh and a.jlzt = 1 and b.jssjh=@sjh
	       if @@ERROR <> 0 
	       begin 
	           rollback tran
			   select "F","�����˷�����״̬����"
			   return
		   end
	   end	
	end	
	------------------------
	
-- add kcs 20151104 �շѴ����Żݼ�¼��Ϣ�� ���ϴ��� begin
	declare @yhjlxh ut_xh12,         -- YY_HZYHFSJLK_MZ.xh
	        @sjhjh varchar(100)      -- �վݺż���
	        
	if exists(select 1 from YY_HZYHFSJLK_MZ where CHARINDEX(rtrim(ltrim(@sjh)),sjhjh) > 0 and jlzt = '2')
    begin
        select @yhjlxh = xh,@sjhjh = sjhjh from YY_HZYHFSJLK_MZ where CHARINDEX(rtrim(ltrim(@sjh)),sjhjh) > 0 and jlzt = '2'
        
        -- ����ԭ�Żݼ�¼��Ϣ
	    update YY_HZYHFSJLK_MZ set jlzt = 3 where xh = @yhjlxh
	    if @@ERROR <> 0 
	    begin
	        rollback tran
		    select "F","�����Ż�ԭ���¼�����"
		    return
	    end
	    
        --	�������Żݼ�¼��Ϣ    
        -- ȫ���Ҵ��ڶ���վݺŵ��Żݼ�¼ ֱ��ȥ����ǰ�˷ѵ�sjh
        -- ȫ�˵�һ�վݺŵ��Żݼ�¼������д����
        if (@qtbz = 1) and (2*LEN(rtrim(ltrim(@sjh))) < LEN(@sjhjh))
        begin
            insert into YY_HZYHFSJLK_MZ
            select cardno,patid,sfzh,REPLACE(@sjhjh,'"' + rtrim(ltrim(@sjh)) + '",',''),yhid,@now,@czyh,'2' from YY_HZYHFSJLK_MZ where xh = @yhjlxh    
        end
        -- �����˷�ֱ�Ӱ�sjhjh�е������վݺŻ������ռ�¼�վݺż���
        else if @qtbz = 0
        begin
            insert into YY_HZYHFSJLK_MZ
            select cardno,patid,sfzh,REPLACE(@sjhjh,rtrim(ltrim(@sjh)),rtrim(ltrim(@newsjh))),yhid,@now,@czyh,'2' from YY_HZYHFSJLK_MZ where xh = @yhjlxh
        end
	end
-- add kcs 20151104 �շѴ����Żݼ�¼��Ϣ�� ���ϴ��� end
	
	--���ԭ��¼
	update SF_MZCFK set jlzt=1,gxrq=@now where jssjh=@sjh  --add by yfq @20120528
	if @@error<>0
	begin
		rollback tran
		select "F","�������ﴦ�������"
		return
	end

	update SF_NMZCFK set jlzt=1,gxrq=@now where jssjh=@sjh  --add by yfq @20120528
	if @@error<>0
	begin
		rollback tran
		select "F","�������ﴦ�������"
		return
	end


----���Ʒ����շѳɹ�������շѱ�־  SF_HJCFMXK.sjzlfabdxh<>0  ZLFA_SJBDK.SFBZ=1
	select hjxh	into #sfcfk from VW_MZCFK (nolock)where jssjh=@sjh
	if @@rowcount=0
	begin
		select "F","�շ���Ϣ�����ڣ�"
		rollback tran
		return		
	end
	---ȥ�����յ�,ʣ�²�������Ҫ�˵ģ�Ҳ������Ҫ���µ�
	--delete  from #sfcfk where hjxh in (select hjxh from VW_MZCFK (nolock)where jssjh=@newsjh)
	--update l_cj by bug337364
    delete  from #sfcfk where hjxh in (select hjxh from dbo.SF_MZCFK (nolock)where jssjh=@newsjh)
	
	UPDATE a set a.sfbz=0 ,a.tempbz=0 ,a.hjmxxh =null,a.yrzt=0 from ZLFA_SJBDK a, VW_MZHJCFMXK b
		where b.cfxh  in (select hjxh from #sfcfk ) and a.xh=b.sjzlfabdxh
	if @@error<>0
	begin
		select "F","�����������շ���Ϣ����"
		rollback tran
		return
	end 
----end



	-- ������ҩ��־ ��ԭ������������һ�Ÿ�������Ҫ��ҩ����δ���򶼲�����
	update SF_MZCFK set czyh=@czyh,
		lrrq=(case when @jsrq_tf='' then @now else @jsrq_tf end),
		jlzt=2,
		jsbz=1,
		pybz = 1-pybz,
		gxrq=@now   --add by yfq @20120528
		where jssjh=@newsjh1
	if @@error<>0
	begin
		rollback tran
		select "F","������ﴦ�������"
		return
	end

    --����SF_HJCFMXK_TYSQ�м�¼״̬
	select b.hjmxxh,(b.ypsl-isnull(d.ypsl,0)) ypsl into #SF_HJCFMXK_TYSQ_TEMP 
	from VW_MZCFK a(nolock)
	join VW_MZCFMXK b(nolock) on a.xh = b.cfxh and a.jssjh = @sjh 
	left join VW_MZCFK c(nolock) on c.jssjh=@newsjh and a.xh=isnull(c.txh,0) and a.hjxh=isnull(c.hjxh,0)
	left join VW_MZCFMXK d(nolock) on c.xh = d.cfxh and b.hjmxxh=isnull(d.hjmxxh,0)
    where a.jssjh = @sjh and '0'=isnull(b.lcxmdm,'0') 
	if @@error<>0
	begin
		rollback tran
		select "F","ͳ���˷�������Ϣ����"
		return
	end
	insert into #SF_HJCFMXK_TYSQ_TEMP(hjmxxh,ypsl) 
	select b.hjmxxh,(b.lcxmsl-isnull(d.lcxmsl,0)) ypsl
	from VW_MZCFK a(nolock)
	join VW_MZCFMXK b(nolock) on a.xh = b.cfxh and a.jssjh = @sjh 
	left join VW_MZCFK c(nolock) on c.jssjh=@newsjh and a.xh=isnull(c.txh,0) and a.hjxh=isnull(c.hjxh,0)
	left join VW_MZCFMXK d(nolock) on c.xh = d.cfxh and b.hjmxxh=isnull(d.hjmxxh,0)
    where a.jssjh = @sjh and '0'<>isnull(b.lcxmdm,'0')
	group by  b.hjmxxh,b.lcxmsl,d.lcxmsl
	if @@error<>0
	begin
		rollback tran
		select "F","ͳ���˷�������Ϣ����"
		return
	end
    --update SF_HJCFMXK_TYSQ set jlzt = 2 from SF_HJCFMXK_TYSQ a(nolock),VW_MZCFK b(nolock),VW_MZCFMXK c(nolock) 
    --where b.jssjh = @sjh and b.xh = c.cfxh and a.hjcfmxxh = c.hjmxxh 
    update SF_HJCFMXK_TYSQ set jlzt = 2 from SF_HJCFMXK_TYSQ a(nolock),#SF_HJCFMXK_TYSQ_TEMP b
    where a.hjcfmxxh = b.hjmxxh and a.sqsl=b.ypsl and a.jlzt=0  -- add by zxm for bug 51681 ������ֻ����Ч�����ݣ�����ͬ������ȡ��������Ҳ�ᱻ����Ϊ2
	if @@error<>0
	begin
		rollback tran
		select "F","����SF_HJCFMXK_TYSQ�м�¼״̬����"
		return
	end
	--mit ,, 2oo3-o5-o8 ,, �������˷Ѵ���,Ĭ�����˿�,�����ֽ�

	declare @ylkje ut_money

	if exists(select 1 from SF_BRJSK where sjh=@sjh)
		update SF_BRJSK set jlzt=1, @sfje=zfje 
					,@ylkje=ylkje,@bdyhkje_old = bdyhkje
          ,gxrq=@now --add by yfq @20120528
		where sjh=@sjh
	else
		update SF_NBRJSK set jlzt=1, @sfje=zfje 
					,@ylkje=ylkje,@bdyhkje_old = bdyhkje
          ,gxrq=@now --add by yfq @20120528 
		where sjh=@sjh
	if @@error<>0
	begin
		rollback tran
		select "F","���������������"
		return
	end	
	--wxp ,, 2005-10-28  ���Ӷ԰����п��Ĵ���
	if @IsUseBdk = 0 and @bdyhkje_old <> 0
	begin
		update SF_BRJSK set xjje = xjje+bdyhkje,bdyhkje = 0,gxrq=@now where sjh = @newsjh1
		select @bdyhkje_old = 0
	end	
	--wxp ���°����п����׼�¼״̬
	if @IsUseBdk = 1 
	begin 
		update YY_BDYHKJLK set jlzt = 1	where jssjh = @sjh and jlzt = 0
		if @@error<>0
		begin
			rollback tran
			select "F","���°����п����׼�¼״̬����"
			return
		end
	end

	if @qtbz = 1 
	begin
		declare @zffsdm ut_mc32,
				@zpje	ut_money

		if exists (select 1 from YY_CONFIG (nolock) where id='2111')
		   select @zffsdm=config from YY_CONFIG(nolock) where id='2111'
		else
		   select @zffsdm = ''

		--add by chenwei 2004-09-01 ���Ӹ���ȫ���˷�ʱָ��֧����ʽ����Ϊ�ֽ�(��֧����ʽΪ����ת��֮��)
		if @zffsdm <> '' 
		begin
			if exists( select 1 from VW_MZBRJSK (nolock) where sjh=@sjh and substring(sfrq,1,8) <> substring(@now,1,8))
			begin
				select @zpje = zpje from VW_MZBRJSK(nolock) 
				 where sjh=@sjh and charindex(ltrim(rtrim(zph)),@zffsdm)>0
				if @zpje <> 0
				begin
					update SF_BRJSK set xjje = xjje + zpje, zpje = zpje - zpje,gxrq=@now where sjh=@newsjh1
					if @@error<>0
					begin
						select "F","�����˷��ֽ����"
						rollback tran
						return		
					end
				end
			end
		end
	end
    --���ﲿ���˷�ʱӦ�յ��ǲ��ַ����Ƿ���ΪPOS��֧����ʽ��ԭ�շѷ�ʽҲ��POS��֧����ʽ�� 
    declare @zffs_y varchar(2),@zpje_y ut_money,@zfje_y ut_money,@tzpfs ut_bz
    select @zffs_y='',@zpje_y=0,@zfje_y=0,@tzpfs=0
    select @zffs_y=zph,@zpje_y=isnull(zpje,0),@zfje_y=isnull(zfje,0),
		   @zpje_yyt=case when zph  in ('Y') then isnull(zpje,0) else 0 end
    from VW_MZBRJSK where sjh=@sjh
	
	--------add by gxs
	if @qtbz = 1 
	begin
		if ((@zffs_y='Y') and (@zpje_yyt>0) and (@zzfs_tf=0))
		begin
			update SF_BRJSK set zpje = 0, xjje=xjje+zpje,zph=''  where sjh=@newsjh1
			if @@error<>0
			begin
				select "F","�����շѽ�����Ϣ����1��"
				rollback tran
				return		
			end
			if ((@zffs_y='Y') and (@zpje_yyt>0) and (@zzfs_tf=0))
				select @zffs_y=''
			select @zpje_yyt=0
		end
	end
	else
	begin
		if (@zffs_y='Y') and (@zpje_yyt>0) and (@zzfs_tf=0)
		begin
			update SF_BRJSK set zpje = 0, xjje=xjje+zpje,zph=''  where sjh=@newsjh1
			if @@error<>0
			begin
				select "F","�����շѽ�����Ϣ����1��"
				rollback tran
				return		
			end
			if ((@zffs_y='Y') and (@zpje_yyt>0) and (@zzfs_tf=0))
				select @zffs_y=''
			select @zpje_yyt=0
		end
	end
	
	-----end add by gxs

 ---- begin add by yhw   
 declare @tje money
 select @tje=isnull(zpje,0) from VW_MZBRJSK where sjh=@sjh and zph in('7','12','13','14','15','S') 
 if ((@zffs_y in('7','12','13','14','15','S') and @tje>0) or @zffs_y in ('','1'))
 begin  
  update SF_BRJSK set xjje=xjje+zpje,zpje = 0,zph='' where sjh=@newsjh1            
  if @@error<>0            
  begin            
   select "F","�����շѽ�����Ϣ����2��"            
   rollback tran            
   return              
  end  
  select @tje=0   
 end  
 ----end      

    
--add by winning-dingsong-chongqing on 20191129-begin
--�������˷Ѻ���ȡ���֣�֧����ʽΪ�ֽ���Ϊ��Ϊ�ֽ����Բ�������ҲΪ�ֽ�
declare @zpzje money
select @zpzje=isnull(zpje,0) from VW_MZBRJSK where sjh=@sjh and zph in('7','12','13','14','15','S') 
if ((@zffs_y in('7','12','13','14','15','S') and @zpzje>0))
begin
	if exists(select 1 from SF_BRJSK WHERE tsjh=@newsjh1)
	begin
		update SF_BRJSK set xjje=xjje+zpje,zpje = 0,zph='' where tsjh=@newsjh1--sjh=@newsjh --
		if @@error<>0            
		begin            
			select "F","�����շѽ�����Ϣ����3��"            
			rollback tran            
			return              
		end 
	end 
	select @zpzje=0 
end
--add by winning-dingsong-chongqing on 20191129-end

    if (@qtbz = 0) and (@zffs_y='7') and (@zpje_y>0)
       and (exists (select 1 from YY_CONFIG (nolock) where id='2197' and config='��'))
    begin
        if @zfje_y<>@zpje_y 
        begin           
			select "F","����֧Ʊ֧��ʱ���ܲ����˷ѣ���ʹ��ȫ�ˣ�"
			rollback tran
			return
        end
        
		--if exists(select 1 from SF_BRJSK where sjh=@newsjh1 and xjje=zfje and zph='7' and zpje=0)
        if exists(select 1 from SF_BRJSK where tsjh=@newsjh1 and xjje=zfje and isnull(zph,'') in ('','1') and zpje=0)--winning-dingsong-chongqing-20191127
        select @tzpfs=0   --�����ֽ��˵ķ�ʽ
        else
        select @tzpfs=1   --������pos��ʽ
        /*if @tzpfs=1 
        begin
			del by aorigele 20100422
			update SF_BRJSK set xjje = 0, zpje = -zfje ,zph='7' where sjh=@newsjh1
			if @@error<>0
			begin
				select "F","�����˷��ֽ����"
				rollback tran
				return		
			end
        end*/        
    end
    select @fpdybz=fpdybz,@fpdyrq=fpdyrq,@fpdyczyh=fpdyczyh from VW_MZBRJSK(nolock) where sjh = @sjh
    
	update SF_BRJSK set
		sfrq=(case when @jsrq_tf='' then @now else @jsrq_tf end),
		ybjszt=2,
		zxlsh=@zxlsh_tf
		,ylksqxh=@ylkhcsqxh
		,ylkzxlsh=@ylkhczxlsh	--mit ,, 2oo3-o5-o8 ,, 
		,qrrq=@now
		,bdyhklsh = @bdyhklsh
		,lrrq=@now
		,gxrq=@now --add by yfq @20120528
		,fpdybz=@fpdybz
		,fpdyrq=@fpdyrq
		,fpdyczyh=@fpdyczyh
		where sjh=@newsjh1
	if @@error<>0
	begin
		rollback tran
		select "F","��������������"
		return
	end

	if exists(select 1 from SF_BRJSK where sjh=@sjh)
		insert into SF_JEMXK(jssjh, lx, mc, je, memo)
		select @newsjh1, lx, mc, -je, memo
			from SF_JEMXK where jssjh=@sjh
	else
		insert into SF_JEMXK(jssjh, lx, mc, je, memo)
		select @newsjh1, lx, mc, -je, memo
			from SF_NJEMXK where jssjh=@sjh
	if @@error<>0
	begin
		rollback tran
		select "F","����������������"
		return
	end
    --��忨֧����¼��
    if exists(select 1 from SF_BRJSK where sjh=@sjh)
		insert into SF_CARDZFJEK(jssjh, lx, mc, je, memo)
		select @newsjh1, lx, mc, -je, memo
			from SF_CARDZFJEK where jssjh=@sjh
	else
		insert into SF_NCARDZFJEK(jssjh, lx, mc, je, memo)
		select @newsjh1, lx, mc, -je, memo
			from SF_NCARDZFJEK where jssjh=@sjh
	if @@error<>0
	begin
		rollback tran
		select "F","���������㿨֧���������"
		return
	end
	--add by zwj 2004.02.02	���½�����ϸ��¼
	if @pzlx in ('10','11')
	begin
		update YY_YBJYMX set jssjh=@newsjh1
			where zxlsh=@zxlsh_tf
		if @@error<>0
		begin
			rollback tran
			select "F","����ҽ��������ϸ��Ϣ����"
			return
		end
	end

	--�Ƿ�ⶳҩ�����
	declare @isdlsjfa ut_bz, --�Ƿ���ö����ۼ۷�����0�����ã�1���ã�
			@ypxtslt int--���ۼ۷���
	select @isdlsjfa=0,@ypxtslt=0
	if exists(select 1 from sysobjects where name='f_get_ypxtslt')	
	begin
		select @ypxtslt=dbo.f_get_ypxtslt()  
		if @ypxtslt=3 
		select @isdlsjfa=1
	end


	if (@djbz=2) and (@isdlsjfa=0)
	begin
		if exists(select 1 from #djtemp where ypsl>0)
		begin
		/*
			update YF_YFZKC set djsl=a.djsl+b.ypsl
				from YF_YFZKC a, #djtemp b
				where a.cd_idm=b.cd_idm and a.ksdm=b.yfdm and b.ypsl<0
			if @@error<>0
			begin
				rollback tran
				select "F","�ⶳҩ��������"
				return
			end
		
		*/
			declare @yfdm_djkc_ex ut_ksdm,
			@mxtbname_djkc_ex ut_mc32,
			@hjmxxh_djkc_ex ut_xh12,
			@cfmxxh_djkc_ex ut_xh12,
			@idm_djkc_ex ut_xh9,
			@czls_djkc_ex ut_sl10,
			@yczls_djkc_ex ut_sl10,  --ԭ��������
			@rtnmsg_djkc_ex varchar(50)   

			--��ʼ������
			select @yfdm_djkc_ex = '',@mxtbname_djkc_ex = '',@hjmxxh_djkc_ex = 0,@cfmxxh_djkc_ex = 0,@idm_djkc_ex = 0,@czls_djkc_ex = 0,@yczls_djkc_ex = 0, @rtnmsg_djkc_ex = '';
			--ȡ������ȫ��
			declare cs_cfk_djkc_ex cursor for select distinct a.yfdm,a.xh,a.cd_idm,a.ypsl
				from #djtemp a
			open cs_cfk_djkc_ex
			fetch cs_cfk_djkc_ex INTO @yfdm_djkc_ex,@cfmxxh_djkc_ex,@idm_djkc_ex,@czls_djkc_ex
			while @@fetch_status=0 
			begin 
				if @idm_djkc_ex>0 
				begin  
					exec usp_yf_jk_yy_freeze 2,@yfdm_djkc_ex,'SF_CFMXK',@cfmxxh_djkc_ex,@idm_djkc_ex,@czls_djkc_ex,0,@rtnmsg_djkc_ex output
					if substring(@rtnmsg_djkc_ex,1,1)='F'
					begin
						select 'F','ȡ������ҩƷ������,'+substring(@rtnmsg_djkc_ex,2,len(@rtnmsg_djkc_ex)-1)
						rollback tran
						deallocate cs_cfk_djkc_ex
						return
					end
				end
				fetch cs_cfk_djkc_ex INTO @yfdm_djkc_ex,@cfmxxh_djkc_ex,@idm_djkc_ex,@czls_djkc_ex
			end
			close cs_cfk_djkc_ex
			deallocate cs_cfk_djkc_ex	
			--�������ղ���
			declare cs_cfk_djkc_ex cursor for select distinct a.yfdm,a.csxh,a.cd_idm,a.cssl
				from #djtemp a
			open cs_cfk_djkc_ex
			fetch cs_cfk_djkc_ex INTO @yfdm_djkc_ex,@cfmxxh_djkc_ex,@idm_djkc_ex,@czls_djkc_ex
			while @@fetch_status=0 
			begin 
				if @idm_djkc_ex>0 and @czls_djkc_ex>0
				begin  
					exec usp_yf_jk_yy_freeze 1,@yfdm_djkc_ex,'SF_CFMXK',@cfmxxh_djkc_ex,@idm_djkc_ex,@czls_djkc_ex,0,@rtnmsg_djkc_ex output
					if substring(@rtnmsg_djkc_ex,1,1)='F'
					begin
						select 'F','����ҩƷ������,'+substring(@rtnmsg_djkc_ex,2,len(@rtnmsg_djkc_ex)-1)
						rollback tran
						deallocate cs_cfk_djkc_ex
						return
					end
				end
				fetch cs_cfk_djkc_ex INTO @yfdm_djkc_ex,@cfmxxh_djkc_ex,@idm_djkc_ex,@czls_djkc_ex
			end
			close cs_cfk_djkc_ex
			deallocate cs_cfk_djkc_ex	

		end		
	end
	if exists (select 1 from YY_CONFIG(nolock) where id='2422' and config='��') and @isdlsjfa=0
	    and exists (select 1 from VW_MZCFK(nolock) where jssjh=@sjh and cflx in (1,2,3) and fybz=0)
	begin
	    declare @yfdm_djkc ut_ksdm,
	        @mxtbname_djkc ut_mc32,
	        @hjmxxh_djkc ut_xh12,
	        @cfmxxh_djkc ut_xh12,
	        @idm_djkc ut_xh9,
	        @czls_djkc ut_sl10,
	        @rtnmsg_djkc varchar(50)
	    declare cs_cfk_djkc cursor for select distinct a.yfdm,isnull(b.hjmxxh,0),b.xh,b.cd_idm,b.ypsl*b.cfts
			from VW_MZCFK a(nolock),VW_MZCFMXK b(nolock) 
			where a.jssjh=@sjh and a.cflx in (1,2,3) and a.xh=b.cfxh and a.fybz=0
        open cs_cfk_djkc
        fetch cs_cfk_djkc INTO @yfdm_djkc,@hjmxxh_djkc,@cfmxxh_djkc,@idm_djkc,@czls_djkc
		while @@fetch_status=0 
        begin
            if @idm_djkc>0 



	        begin
	            exec usp_yf_jk_yy_freeze 2,@yfdm_djkc,'SF_CFMXK',@cfmxxh_djkc,@idm_djkc,@czls_djkc,0,@rtnmsg_djkc output
				if substring(@rtnmsg_djkc,1,1)='F'
				begin
				    select 'F','�ⶳԭ����ҩƷ������,'+substring(@rtnmsg_djkc,2,len(@rtnmsg_djkc)-1)
				    rollback tran
					deallocate cs_cfk_djkc
					return
				end


	        end
            fetch cs_cfk_djkc INTO @yfdm_djkc,@hjmxxh_djkc,@cfmxxh_djkc,@idm_djkc,@czls_djkc  
        end
        close cs_cfk_djkc
		deallocate cs_cfk_djkc  
	    
	    declare cs_cfk_djkc cursor for select distinct a.yfdm,isnull(b.hjmxxh,0),b.xh,b.cd_idm,b.ypsl*b.cfts
			from SF_MZCFK a(nolock),SF_CFMXK b(nolock) 
			where a.jssjh=@newsjh and a.cflx in (1,2,3) and a.xh=b.cfxh and a.fybz=0
        open cs_cfk_djkc
        fetch cs_cfk_djkc INTO @yfdm_djkc,@hjmxxh_djkc,@cfmxxh_djkc,@idm_djkc,@czls_djkc
		while @@fetch_status=0 
        begin
            if @idm_djkc>0 
            begin
				exec usp_yf_jk_yy_freeze 1,@yfdm_djkc,'SF_CFMXK',@cfmxxh_djkc,@idm_djkc,@czls_djkc,0,@rtnmsg_djkc output
				if substring(@rtnmsg_djkc,1,1)='F'
				begin
					select 'F','����ҩƷ������,'+substring(@rtnmsg_djkc,2,len(@rtnmsg_djkc)-1)
					rollback tran
					deallocate cs_cfk_yfdm
					return
				end
            end
            fetch cs_cfk_djkc INTO @yfdm_djkc,@hjmxxh_djkc,@cfmxxh_djkc,@idm_djkc,@czls_djkc
        end
		close cs_cfk_djkc
		deallocate cs_cfk_djkc
	end
----------cjt �Ȱ�Ǯ�������������������
-------------cjt  ��û����ʱ���˷ѵĿۿ����ӽ����������ǲ���ѧ��
 if @yjbz=1 and ((@qkbz in(1,3)) or (@qkbz1 in (1,3)))    
 begin    
	--���ҿ�ת�沿�ֽ���    
	select @dbkzf1=isnull(dbkje,0) from YY_JZBRYJK where sjh=@sjh and jlzt=0    
	select @dbkye=isnull(dbkye,0) from YY_JZBRK where xh=@jzxh and jlzt=0    

	select @dbkye=@dbkye+@dbkzf1    
	if @dbkye>=@qkje    
	select @dbkzf=@qkje    
	else    
	select @dbkzf=@dbkye    



    
  update YY_JZBRK set yjye=yjye+@qkje1     
   ,@sjyjye=yjye+@qkje1, @sjdjje=djje,dbkye=isnull(dbkye,0)+@dbkzf1-@dbkzf    
  where xh=@jzxh and jlzt=0    
  if @@error<>0    
  begin    
   select "F","���¼��˲��˿�Ԥ����������"    
   rollback tran    

   return    
  end    
  if @qtbz=0    
  begin    
	--�����˷�ʱѺ����ú�巽ʽ    
	--1���    
   insert into YY_JZBRYJK(fpjxh,fph,jzxh,czyh,czym,lrrq,jje,dje,yje,zffs,czlb,hcxh,jlzt,memo,sjh,hcsjh,ybdm,dbkje)    
   values(0,0,@jzxh,@czyh,@czym,@now,0,@qkje1,@sjyjye,1,4,null,0,'',@newsjh1,@sjh, @ybdm,-@dbkzf1)    
            if @@error<>0    
   begin    
    select 'F','����YY_JZBRYJK��¼ʱ����'    
    rollback tran    
    return    
   end     
  end     
 end    
	--�����η���ʱ�ⶳ���
	if @isdlsjfa=1
	begin		
		--select b.xh,a.xh  from VW_MZCFK a,VW_MZCFMXK b where a.jssjh=@sjh and a.xh=b.cfxh and a.cflx in(1,2,3) and a.fybz=0
		--��һ�����ⶳ��
		--ҩƷ�����ε��ۼ��㴦���߼�
		declare 
			@cfmxxh_temp ut_xh12,@cfxh_temp ut_xh12,
			@djpcxh ut_xh12,--����ָ���������(Ĭ��Ϊ0����3183�������򣬶����Σ�
			@rtnmsg	varchar(50), --������Ϣ
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
			@yjzfje_cs ut_money,  --�����Ԥ����֧�����
			@tmxxh	ut_xh12,		--����ϸ��ţ�ԭ��¼��
			@djsl_cs	ut_sl10		--����Ԥ�㣬���¶��������
		if exists(select 1 from VW_MZCFK a,VW_MZCFMXK b where a.jssjh=@sjh and a.xh=b.cfxh and a.cflx in(1,2,3) and a.fybz=0)
		begin
			--�ȱ�����ʷ������ϸ�����μ�¼��Ϣ������ⶳ��ͱ�ɾ����
			--select a.* into #yf_ypdjjlk_old 
			--from YF_YPDJJLK a(NOLOCK)
			--	inner join VW_MZCFMXK b(nolock) on a.mxxh = b.xh
			--	inner join VW_MZCFK c(nolock) on b.cfxh = c.xh
			--where c.jssjh = @sjh and c.cflx in (1,2,3) and c.fybz = 0 and a.mxtbname in ('SF_CFMXK','SF_NCFMXK')
			--�շѴ������ᣬ��ҩ��δ��ҩ�ģ��˷�ʱ��Ҫ���ⶳ�ᣬ���ҩ���Ѿ���ҩ����ҩ�����нⶳ��
			declare cs_mzsf_dpcjgcl cursor for
			select b.xh,a.xh  from VW_MZCFK a,VW_MZCFMXK b where a.jssjh=@sjh and a.xh=b.cfxh and a.cflx in(1,2,3) and a.fybz=0
			for read only
			open cs_mzsf_dpcjgcl
			fetch cs_mzsf_dpcjgcl into @cfmxxh_temp,@cfxh_temp
			while @@fetch_status=0
			begin
				select @rtnmsg ='',@totalYplsje =0,@totalYpjjje =0,@avgYplsj =0,@avgYpjj =0,@yfpcxhlist ='',@yfpcsllist =''
				exec usp_yf_mzsf_ypdpcdj_inf 2,@cfmxxh_temp,0,0,@rtnmsg output,@totalYplsje output,@totalYpjjje output,@avgYplsj output,@avgYpjj output,@yfpcxhlist output,@yfpcsllist output
				if substring(@rtnmsg,1,1)<>'T'

				begin
					select 'F','ҩƷ�����νⶳ�����'+@rtnmsg
					deallocate cs_mzsf_dpcjgcl
					rollback tran

					return
				end
				fetch cs_mzsf_dpcjgcl into @cfmxxh_temp,@cfxh_temp







			end
			close cs_mzsf_dpcjgcl
			deallocate cs_mzsf_dpcjgcl
		end
		--�ڶ������ٶ���
		--ҩƷ�����ε��ۼ��㴦���߼�
		if exists(select 1 from SF_MZCFK a,SF_CFMXK b where a.jssjh=@newsjh and a.xh=b.cfxh and a.cflx in(1,2,3))
		begin
			if exists(select 1 from SF_MZCFK a,SF_CFMXK b where a.jssjh=@newsjh and a.xh=b.cfxh and a.cflx in(1,2,3) and a.fybz=0)
			begin
				declare cs_mzsf_dpcjgcl2 cursor for
				--select b.xh,a.xh,b.tmxxh  from SF_MZCFK a,SF_CFMXK b where a.jssjh=@newsjh and a.xh=b.cfxh and a.cflx in(1,2,3) and a.fybz=0
				select b.xh,a.xh,b.tmxxh,isnull(c.pcxh,0),c.djk_djsl from SF_MZCFK a(nolock)
					inner join SF_CFMXK b(nolock) on a.xh = b.cfxh
					inner join YF_YPCFPC_DYDJJLK c on b.xh = c.mxxh
				where a.jssjh=@newsjh and a.cflx in(1,2,3) and a.fybz=0
				for read only
				open cs_mzsf_dpcjgcl2
				fetch cs_mzsf_dpcjgcl2 into @cfmxxh_temp,@cfxh_temp,@tmxxh,@djpcxh,@djsl_cs
				while @@fetch_status=0
				begin
					select @rtnmsg ='',@totalYplsje =0,@totalYpjjje =0,@avgYplsj =0,@avgYpjj =0,@yfpcxhlist ='',@yfpcsllist =''									
					exec usp_yf_mzsf_ypdpcdj_inf 6,@cfmxxh_temp,@djpcxh,0,@rtnmsg output,@totalYplsje output,@totalYpjjje output,@avgYplsj output,@avgYpjj output,@yfpcxhlist output,@yfpcsllist output,@djsl_cs
					if substring(@rtnmsg,1,1)<>'T'
					begin
						select 'F','ҩƷ�����ε��ۼ������'+@rtnmsg
						rollback tran
						deallocate cs_mzsf_dpcjgcl2
						return
					end
					--update SF_CFMXK set zje=@totalYplsje,ylsj=@avgYplsj where xh=@cfmxxh_temp and cfxh=@cfxh_temp
					--if @@error<>0
					--begin
					--	select 'F','ҩƷ�����ε��ۼ���������´�����ϸ�����ۼ�ʱ����'
					--	rollback tran
					--	deallocate cs_mzsf_dpcjgcl2
					--	return
					--end
					fetch cs_mzsf_dpcjgcl2 into @cfmxxh_temp,@cfxh_temp,@tmxxh,@djpcxh,@djsl_cs
				end
				close cs_mzsf_dpcjgcl2
				deallocate cs_mzsf_dpcjgcl2
				--���봦����ϸ������			
				insert into SF_CFMXK_DPC(cfmxxh,cfxh,pcxh,cd_idm,ypmc,ypdm,ylsj,ypsl,memo)
				select b.xh,b.cfxh,c.pcxh,b.cd_idm,b.ypmc,b.ypdm,c.yplsj,c.djk_djsl,'' from SF_MZCFK a,SF_CFMXK b,YF_YPDJJLK c 
				where a.jssjh=@newsjh and a.xh=b.cfxh and a.cflx in(1,2,3)
						and b.xh=c.mxxh and b.cfxh=c.zd_xh and c.mxtbname='SF_CFMXK' 
				if @@error<>0
				begin
					select 'F','���봦����ϸ������SF_CFMXK_DPC����'
					rollback tran
					return
				end 
			end
			if exists (select 1 from SF_MZCFK a,SF_CFMXK b where a.jssjh=@newsjh1 and a.xh=b.cfxh and a.cflx in(1,2,3) and a.fybz=1)
			begin
			  --��ҩ������
				exec usp_sf_bftf_fydcl @sjh,@newsjh1,@newsjh,@czyh,1,@errmsg output
				if substring(@errmsg,1,1)='F'
				begin
					rollback tran
					select 'F','ִ�з�ҩ���������usp_sf_bftf_fydcl����['+@errmsg+']'
					return
				end
			end
			if exists(select 1 from SF_MZCFK a,SF_CFMXK b where a.jssjh=@newsjh and a.xh=b.cfxh and a.cflx in(1,2,3) and a.fybz=1)
			begin
				--ҩ���Ѿ�����ҩ�ģ�ֱ��ȥ��ҩ��ϸ�����ylsj
				update b set b.ylsj=c.ylsj,
							b.zje=c.lsje  --isnull(round(b.ypsl*c.ylsj*b.cfts/b.ykxs,2),0) 
				from SF_MZCFK a,SF_CFMXK b,YF_MZFYMX c
				where a.jssjh=@newsjh and a.xh=b.cfxh and a.cflx in(1,2,3) and a.fybz=1  
				and c.mxxh=b.xh and c.cfxh=a.xh
				if @@error<>0
				begin
					select 'F','ҩƷ�����ε��ۼ���������´�����ϸ�����ۼ�ʱ����'
					rollback tran
					return
				end 
				--���봦����ϸ������
				insert into SF_CFMXK_DPC(cfmxxh,cfxh,pcxh,cd_idm,ypmc,ypdm,ylsj,ypsl,memo)
				select b.xh,b.cfxh,d.yfpcxh,b.cd_idm,b.ypmc,b.ypdm,d.yplsj,-d.czsl,'' 
				from SF_MZCFK a,SF_CFMXK b,YF_MZFYMX c,YF_MZMXPCXX d 
					where a.jssjh=@newsjh and a.xh=b.cfxh and a.cflx in(1,2,3)
					and b.xh=c.mxxh and b.cfxh=c.cfxh and b.xh=c.mxxh and c.xh=d.zdmxxh
					and d.czsl<>0 
			end
						
			--�������㣬�۸�䶯
			--ע�⣺�Ϻ�ҽ����֧�֣�����̫���ӣ�ǣ��ҽ���㷨��ά�������Դ˴�δ����
			--exec usp_sf_sfcl_jecs @newsjh,@rtnmsg output,@zje_cs output, @sfje_cs output,@ybje_cs output, @flzfje_cs output, @yjzfje_cs output
			--if substring(@rtnmsg,1,1)<>'T'
			--begin
			--	select 'F','�����������'+@rtnmsg
			--	rollback tran
			--	return
			--end
			--�����Ա������д��¸�ֵ��ȷ����ʾ��Ϣ��ȷ
			--select @ybdm=ybdm, @qkbz1=qkbz,@qkje=qkje, @zje=zje, @sfje2=zfje, @zfyje=zfyje, @flzfje=flzfje,
			--		@tcljje1=zje-zfyje, @gbje=gbje,@gbbz = gbbz,@lcyhje = lcyhje,@lczje = @zje - lcyhje,@yhje=yhje
			--		,@hzdybz =hzdybz
			--from SF_BRJSK where sjh=@newsjh
			--if @@rowcount=0
			--begin
			--	select "F","������ȡ�˷���Ϣ����"
			--	rollback tran
			--	return
			--end
		end
	end
  --xwm 2011-12-03 3117�������ϣ�ֻ��ҩ����ҩ��������
  --ֻ�ڲ����˷�ʱ�����·�ҩ���������ʣ�
  --�����˷�ʱ�������·�ҩ��,ҲҪ��������ҩ���������ʣ���������������ѯҪ��  xwm 2012-02-23
  if @isdlsjfa=0 and exists(select 1 from SF_MZCFK a,SF_CFMXK b where a.jssjh=@newsjh1 and a.xh=b.cfxh and a.cflx in(1,2,3) and a.fybz=1)
  begin   		   
    exec usp_sf_bftf_fydcl @sjh,@newsjh1,@newsjh,@czyh,1,@errmsg output
  if substring(@errmsg,1,1)='F'
    begin
      rollback tran
      select 'F','ִ�з�ҩ���������usp_sf_bftf_fydcl����['+@errmsg+']'
      return
    end
  end 
	--ȷ����ҩ��¼
	--update YF_MZFYZD set tfqrbz=1, jzbz=1, sfrq=@now, fyrq=@now where jssjh=@sjh and tfbz=1 and tfqrbz=0 and jlzt=0
	--���3117����Ϊ1 ����ҩ���Ѿ�����jzbz
	if @config3117=0
	begin
		update YF_MZFYZD set tfqrbz=1, jzbz=case jzbz when 0 then 1 else jzbz end, sfrq=@now, fyrq=@now where jssjh=@sjh and tfbz=1 and tfqrbz=0 and jlzt=0
		if @@rowcount=0
		update YF_NMZFYZD set tfqrbz=1, jzbz=case jzbz when 0 then 1 else jzbz end, sfrq=@now, fyrq=@now where jssjh=@sjh and tfbz=1 and tfqrbz=0 and jlzt=0	
		if @@error<>0
		begin
			rollback tran
			select "F","ȷ���˷Ѽ�¼����"
			return
		end
	end
	else
	begin
		update YF_MZFYZD set tfqrbz=1, jzbz=case jzbz when 0 then 1 else jzbz end, sfrq=@now  where jssjh=@sjh and tfbz=1 and tfqrbz=0 and jlzt=0
		if @@rowcount=0
		update YF_NMZFYZD set tfqrbz=1, jzbz=case jzbz when 0 then 1 else jzbz end, sfrq=@now where jssjh=@sjh and tfbz=1 and tfqrbz=0 and jlzt=0	
		if @@error<>0
		begin
			rollback tran
			select "F","ȷ���˷Ѽ�¼����"
			return
		end
	end

	--�ָ�������ҩ��¼ zwj 2006.7.26
	--����ҩ��ʽ�ǲ�ɾ��ԭ������ҩ��¼����ֱ������һ����ҩ��¼���Բ����ٸ���jlzt
	/*
	update YF_MZFYZD set jlzt=0 where jssjh=@sjh and tfbz=1 and tfqrbz=0 and jlzt=1
	if @@rowcount=0
	update YF_NMZFYZD set jlzt=0 where jssjh=@sjh and tfbz=1 and tfqrbz=0 and jlzt=1
	if @@error<>0
	begin
		rollback tran
		select "F","�ָ�������ҩ��¼����"
		return
	end
	*/

	if @qkbz=1
	begin 
 		select @qkje_new = isnull(je,0) from SF_JEMXK where jssjh = @newsjh and lx in ( '01','yb01') 
 		select @qkje_hc = isnull(-je,0) from SF_JEMXK where jssjh = @newsjh1 and lx in ('01','yb01') 		
		update SF_BRXXK set zhje=zhje+ @qkje_hc- @qkje_new,gxrq=@now where patid = @patid --add by yfq @20120531
		if @@error<>0
		begin
			select "F","������Ϣ���˻�������"
			rollback tran
			return
		end
		select @zhje=zhje from SF_BRXXK where patid=@patid
		if @@error<>0
		begin
			select "F","�����˻�������"
			rollback tran
			return
		end	
	end

	if @tcljbz=1
	begin
		update SF_BRXXK set ljje=isnull(ljje,0)+@tcljje+@tcljje1,gxrq=@now --add by yfq @20120531
			where patid=@patid
		if @@error<>0
		begin
			select "F","���²�����Ϣ����"
			rollback tran
			return
		end
	end

	if @yjbz=1 and ((@qkbz in(1,3)) or (@qkbz1 in (1,3)))
	begin
        --���ҿ�ת�沿�ֽ���
        select @dbkzf1=isnull(dbkje,0) from YY_JZBRYJK where sjh=@sjh and jlzt=0
        select @dbkye=isnull(dbkye,0) from YY_JZBRK where xh=@jzxh and jlzt=0

        select @dbkye=@dbkye+@dbkzf1
        if @dbkye>=@qkje
        select @dbkzf=@qkje
        else
        select @dbkzf=@dbkye

		update YY_JZBRK set yjye=yjye-@qkje 
			,@sjyjye=yjye-@qkje, @sjdjje=djje,dbkye=isnull(dbkye,0)-@dbkzf
		where xh=@jzxh and jlzt=0

		if @@error<>0
		begin
			select "F","���¼��˲��˿�Ԥ����������"
			rollback tran
			return
		end
		if @qtbz=0
        begin
            --�����˷�ʱѺ����ú�巽ʽ
            --1���
	/* cjt �������Ⱥ��
			insert into YY_JZBRYJK(fpjxh,fph,jzxh,czyh,czym,lrrq,jje,dje,yje,zffs,czlb,hcxh,jlzt,memo,sjh,hcsjh,ybdm,dbkje)
			values(0,0,@jzxh,@czyh,@czym,@now,0,@qkje1,@sjyjye,1,4,null,0,'',@newsjh1,@sjh, @ybdm,-@dbkzf1)
            if @@error<>0
			begin
				select 'F','����YY_JZBRYJK��¼ʱ����'
				rollback tran
				return
			end
			*/
            --2�շ�
            insert into YY_JZBRYJK(fpjxh,fph,jzxh,czyh,czym,lrrq,jje,dje,yje,zffs,czlb,hcxh,jlzt,memo,sjh,hcsjh,ybdm,dbkje)
			values(0,0,@jzxh,@czyh,@czym,@now,@qkje,0,@sjyjye,1,3,null,0,'',@newsjh,@sjh, @ybdm,@dbkzf)
			if @@error<>0
			begin
				select 'F','����YY_JZBRYJK��¼ʱ����'
				rollback tran
				return
			end
            insert into SF_CARDZFJEK(jssjh,lx,mc,je,memo)
            values(@newsjh,'3','��ֵ��֧��',@qkje,'')
            if @@error<>0
			begin
				select 'F','����YY_JZBRYJK��¼ʱ����'
				rollback tran
				return
			end
        end
		else
        begin 
			insert into YY_JZBRYJK(fpjxh,fph,jzxh,czyh,czym,lrrq,jje,dje,yje,zffs,czlb,hcxh,jlzt,memo,sjh,hcsjh,ybdm)
			values(0,0,@jzxh,@czyh,@czym,@now,0,@qkje1-@qkje,@sjyjye,1,4,null,0,'',@newsjh1,@sjh, @ybdm)			
			if @@error<>0
			begin
				select 'F','����YY_JZBRYJK��¼ʱ����'
				rollback tran
				return
			end            
        end
	end

	if (@qkbz=4) or exists(select 1 from SF_CARDZFJEK where jssjh=@sjh and lx='4')
	begin
		declare @cardxh ut_xh12
               ,@dbkje ut_money 
		--select @cardxh= kxh,@qkje=@qkje1-@qkje from YY_CARDJEK where jssjh=@sjh
		select @cardxh= kxh from YY_CARDJEK where jssjh=@sjh

        if  exists(select 1 from SF_CARDZFJEK where jssjh=@sjh and lx='4')
		 select @dbkje=je from SF_CARDZFJEK where jssjh=@sjh and lx='4'
		else
            select @dbkje=@qkje1

		--add s_yh ���ҿ�֧������ӡ��Ʊ for BUG 160901
		if (select config from YY_CONFIG where id ='2243' ) ='��'
		begin
			if (@cardxh <>0) and (@dbkje<>0)
				select @print=1
		end
		

		--�Ⱥ��
		update YY_CARDXXK set yjye=yjye+@dbkje,zjrq=(case when @jsrq='' then @now else @jsrq end)
		where kxh=@cardxh and jlzt=0
		if @@error<>0
		begin
			select "F","���´��ҿ������ʻ�������"
			rollback tran
			return
		end		

		select @zhje=yjye from YY_CARDXXK(nolock) where kxh=@cardxh
		
		insert into YY_CARDJEK(kxh,jssjh,yjjxh,kdm,czyh,czym,lrrq,zje,zhye,yhje,yhje_zje,yhje_mx,jlzt,xtbz,memo)
		   select kxh,@newsjh1,0,kdm,@czyh,'',(case when @jsrq='' then @now else @jsrq end),-@dbkje,@zhje,@yhje1,0,0,1,0,''
			from YY_CARDJEK where jssjh=@sjh
		if @@error<>0
		begin
			rollback tran
			select "F","���´��ҿ��������"
			return
		end
		
		if @qtbz = 0	--�����˷� --add by gxf 2008-2-21
		begin
            --����֧����ʽʱ�޷������˷ѣ�������exists(select 1 from SF_CARDZFJEK where jssjh=@sjh and lx='4')
			insert into YY_CARDJEK(kxh,jssjh,yjjxh,kdm,czyh,czym,lrrq,zje,zhye,yhje,yhje_zje,yhje_mx,jlzt,xtbz,memo)
			select kxh,@newsjh,0,kdm,@czyh,'',(case when @jsrq='' then @now else @jsrq end),
				   @qkje,
				   @zhje - @qkje,@yhje,0,0,0,0,''
			from YY_CARDJEK where jssjh=@sjh
			if @@error<>0
			begin
				rollback tran
				select "F","���´��ҿ��������"
				return
			end		

			update YY_CARDXXK set yjye = yjye - @qkje
			where kxh=@cardxh and jlzt=0
			if @@error<>0
			begin
				select "F","���´��ҿ������ʻ�������"
				rollback tran
				return
			end	
            insert into SF_CARDZFJEK(jssjh,lx,mc,je,memo)
            values(@newsjh,'4','���ҿ�֧��',@qkje,'')
            if @@error<>0
			begin
				select 'F','����YY_JZBRYJK��¼ʱ����'
				rollback tran
				return
			end
		end
		
	end
	--add by l_jj 2012-07-13 ����119419 	
    if exists(select 1 from VW_MZBRJSK a,VW_MZCFK b where a.sjh=@sjh and b.jssjh=a.sjh and isnull(b.sqdxh,0)<>0)
    begin
		--�����ձ�
        update c set c.jlzt=1 from VW_MZBRJSK a,VW_MZCFK b,SF_MZSQD c
        where a.sjh=@sjh and b.jssjh=a.sjh and b.sqdxh=c.xh and isnull(b.sqdxh,0)<>0
		and ((@qtbz=0 and b.sqdxh not in(select e.sqdxh from SF_BRJSK d,SF_MZCFK e where d.sjh=@newsjh and e.jssjh=d.sjh and isnull(e.sqdxh,0)<>0))  --�����˷�
			or (@qtbz=1)) --ȫ��
	    if @@error<>0
	    begin
			select "F","�������뵥��Ϣ����"
		    rollback tran
		    return		
	    end 
		--�������
		update c set c.jlzt=1 from VW_MZBRJSK a,VW_MZCFK b,SF_NMZSQD c
        where a.sjh=@sjh and b.jssjh=a.sjh and b.sqdxh=c.xh and isnull(b.sqdxh,0)<>0
		and ((@qtbz=0 and b.sqdxh not in(select e.sqdxh from SF_BRJSK d,SF_MZCFK e where d.sjh=@newsjh and e.jssjh=d.sjh and isnull(e.sqdxh,0)<>0))  --�����˷�
			or (@qtbz=1)) --ȫ��
	    if @@error<>0
	    begin
			select "F","�������뵥��Ϣ����"
		    rollback tran
		    return		
	    end         
    end
    --yxc
	declare @yyt_tje ut_money,@yyt_sje ut_money -- ���������˷��˶���Ǯ����ҽͨ
	
	select @yyt_tje=ISNULL(@yyt_tje,0),@yyt_sje=ISNULL(@yyt_sje,0)
	
	select @yyt_tje = zpje  from SF_BRJSK WHERE sjh=@newsjh1 and zph='Y'
	if @qtbz=0
	begin
		--�����շ��¼�¼(�൱���´���)
		update SF_MZCFK set jlzt=0,
			lrrq=(case when @jsrq='' then @now else @jsrq end),
			czyh=@czyh,pybz = 0,gxrq=@now   --add by yfq @20120528
		where jssjh=@newsjh
		if @@error<>0
		begin
			rollback tran
			select "F","�������ﴦ����Ϣ����"
			return
		end
		
	    if @acfdfp=1 and @configdyms=0 --add by ozb and @configdyms=0 ��ӡģʽΪ��ģʽ
		begin	

			update SF_MZCFK  SET zfje=round(a.zfje+b.srje,2),srje=round(b.srje,2)  
			from SF_BRJSK b(nolock),SF_MZCFK a(nolock)  where a.jssjh=b.sjh and b.sjh=@newsjh  
				and a.cfxh=(select min(cfxh) from SF_MZCFK(nolock) where jssjh=@newsjh)
			if @@error<>0
			begin
				rollback tran
				select "F","�������ﴦ����Ϣ����"
				return
			end		
			--�ܽ���ƽ
			declare @jece ut_money
			select @jece=zfje-(select sum(isnull(zfje,0)) from SF_MZCFK(nolock) where jssjh=@newsjh ) 
				from SF_BRJSK(nolock)  where sjh=@newsjh  
			update SF_MZCFK  set zfje=round(isnull(zfje,0)+@jece,2) where jssjh=@newsjh 
				and cfxh=(select min(cfxh) from SF_MZCFK(nolock) where jssjh=@newsjh)
			if @@error<>0
			begin
				rollback tran
				select "F","�������ﴦ����Ϣ����"
				return
			end
	 
		end

		--ҩ����ˮ�Ŵ���  add by xr 2010-09-17
		if (select config from YY_CONFIG (nolock) where id='2132')='��'  
		begin  
			if (select config from YY_CONFIG (nolock) where id='0081')='2'   
			begin  
				declare cs_cfk_fyckxh cursor for select distinct fyckdm from SF_MZCFK(nolock) where jssjh=@newsjh and cflx in (1,2,3) -- add by gzy at 20050518  
				open cs_cfk_fyckxh  
				fetch cs_cfk_fyckxh into @fyckdm1  
				while @@fetch_status=0   
				begin  
					--copy by gxf 2011-1-27
					if not exists(select 1 from SF_YFLSHK nolock where rq = @now8 and fyckdm = @fyckdm1)
					begin
						insert into SF_YFLSHK(rq,xh,yfdm,fyckdm)
						select @now8,1,@fyckdm1,@fyckdm1
						select @yflsh =1
					end
					else 
					begin
						update SF_YFLSHK set xh =xh +1,@yflsh = isnull(xh,0)+1 where rq = @now8 and fyckdm = @fyckdm1
					end
					select @yflsh  = isnull(@yflsh,1)
					update SF_MZCFK set yflsh=@yflsh,fyckxh=@fyckxh+1 where jssjh = @newsjh AND fyckdm = @fyckdm1  -- modify by wfy 2007-03-16
					if @@ERROR<>0 OR @@ROWCOUNT = 0
					begin
						select 'F','������ˮ�Ŵ���'
						rollback tran 
						deallocate cs_cfk_fyckxh
						return      
					end
					--copy by gxf 2011-1-27
					fetch cs_cfk_fyckxh into @fyckdm1  
				end  
				close cs_cfk_fyckxh  
				deallocate cs_cfk_fyckxh  
			end  
			else if (select config from YY_CONFIG (nolock) where id='0081')='3'   
			begin  
				if exists(select 1 from SF_MZCFK where jssjh=@newsjh and cflx in (1,2,3))  
				begin  
					--select @yfdm=yfdm from SF_MZCFK   
					--select @yflsh=isnull(xh,0) from SF_YFLSHK(nolock) where rq =substring(@now,1,8)  
					select @yflsh = xh from SF_YFLSHK(nolock) where rq =substring(@now,1,8) and yfdm=''  
					if @@error<>0      
					begin       
						select "F","ȡ���ҩ����ˮ�ų���" 
						rollback tran      
						return      
					end       

					select @yflsh = isnull(@yflsh,0)+1 -- add by wfy 2007-03-15  

					if @yflsh<=1  
					insert SF_YFLSHK(rq,xh,yfdm)  
					values(substring(@now,1,8),@yflsh,'')    
					else  
					update SF_YFLSHK set xh=@yflsh where rq =substring(@now,1,8) and yfdm=''  
					if @@error<>0      
					begin      
						select "F","�������ݺų���" 
						rollback tran    
						return      
					end      
					update SF_MZCFK set yflsh=@yflsh where jssjh = @newsjh  -- modify by wfy 2007-03-16  
					if @@ERROR<>0 OR @@ROWCOUNT = 0  
					begin  
						select "F","����ҩ����ˮ�ų���"  
						rollback tran   
						return  
					end  
				end  
			end  
			else if (select config from YY_CONFIG (nolock) where id='0081')='1'   
			begin  
				declare cs_cfk_yfdm cursor for select distinct yfdm from SF_MZCFK(nolock) where jssjh=@newsjh and cflx in (1,2,3)  
				open cs_cfk_yfdm  
				fetch cs_cfk_yfdm into @yfdm  
				while @@fetch_status=0   
				begin  
					select @yflsh = xh from SF_YFLSHK(nolock) where rq =substring(@now,1,8) and yfdm=@yfdm  
					if @@error<>0      
					begin      
						select "F","ȡ���ҩ����ˮ�ų���"  
						rollback tran
						deallocate cs_cfk_yfdm      
						return      
					end       

					select @yflsh = isnull(@yflsh,0)+1 -- add by wfy 2007-03-15  

					if @yflsh<=1  
					insert SF_YFLSHK(rq,xh,yfdm)  
					values(substring(@now,1,8),@yflsh,@yfdm)    
					else  
					update SF_YFLSHK set xh=@yflsh where rq =substring(@now,1,8) and yfdm=@yfdm  
					if @@error<>0      
					begin      
						select "F","�������ݺų���"  
						rollback tran 
						deallocate cs_cfk_yfdm      
						return      
					end   
					update SF_MZCFK set yflsh=@yflsh where jssjh = @newsjh and yfdm=@yfdm  -- modify by wfy 2007-03-16  
					if @@ERROR<>0 OR @@ROWCOUNT = 0  
					begin  
						select "F","����ҩ����ˮ�ų���"  
						rollback tran  
						deallocate cs_cfk_yfdm  
						return  
					end  
					fetch cs_cfk_yfdm into @yfdm  
				end  
				close cs_cfk_yfdm  
				deallocate cs_cfk_yfdm  
			end  
		end 
		--����ԭ�շѽ��ж����յ�zfje��ԭ�շ����ݵ�xjje�Ƚ�
		--mod by yyc for BUG 153690
		if (@zffs_y='7') and (@zpje_y>0) and (@tzpfs=1) 
            and (exists (select 1 from YY_CONFIG (nolock) where id='2197' and config='��'))	
        begin	
			update SF_BRJSK set sfrq=(case when @jsrq='' then @now else @jsrq end),
				ybjszt=2,
				zxlsh=(case isnull(@zxlsh,'') when '' then zxlsh else @zxlsh end),
				fph=(case isnull(@fph,0) when 0 then fph else @fph end),
				fpjxh=(case isnull(@fpjxh,0) when 0 then fpjxh else @fpjxh end),
				--xjje=zfje-@qkje,
				xjje = 0,
				--xjje = (case @qkbz when 4 then 0 else zfje-@qkje-(@ylknewje)-@gbje-@bdyhkje end), --alter by gxf 2008-1-21
				--qkje = (case @qkbz when 4 then zfje else qkje end),--alter by gxf 2008-1-21
				dnzhye=(case when @qkbz=1 then @zhje else dnzhye end)
				,ylkje=@ylknewje
				,ylksqxh=@ylknewsqxh
				,yflsh=@yflsh --add by xr 2010-09-17
				,ylkzxlsh=@ylknewzxlsh
				,qrrq=@now
				,bdyhkje = @bdyhkje
				,bdyhklsh = @bdyhklsh
				,lrrq=@now
				,zpje =zfje-@qkje-(@ylknewje)-@gbje-@bdyhkje-(case when (@yytbz >0) and (@zffs_y = 'Y'  ) then @jfje else 0 end)
				,zph = '7'
				,gxrq=@now --add by yfq @20120528
				--,fpdybz=1
				,fpdybz=case when @print=0 and @configdyms=0 then 0 else 1 end
				,fpdyczyh=case when @print=0 and @configdyms=0 then @czyh else null end
				,fpdyrq=case when @print=0 and @configdyms=0 then @now else null end
				,hzdybz=0
				where sjh=@newsjh
		end
		else
		begin
			update SF_BRJSK set sfrq=(case when @jsrq='' then @now else @jsrq end),
				ybjszt=2,
				zxlsh=(case isnull(@zxlsh,'') when '' then zxlsh else @zxlsh end),
				fph=(case isnull(@fph,0) when 0 then fph else @fph end),
				fpjxh=(case isnull(@fpjxh,0) when 0 then fpjxh else @fpjxh end),
				--xjje=zfje-@qkje,
				xjje = zfje-@qkje-(@ylknewje)-@gbje-@bdyhkje
						-(case when (@yytbz >0) and (@zffs_y = 'Y'  ) then @jfje else 0 end)
						/*   -(case when zph='S' then zpje else 0 end),   */
						-(case when zph<>'' then zpje else 0 end),
				--xjje = (case @qkbz when 4 then 0 else zfje-@qkje-(@ylknewje)-@gbje-@bdyhkje end), --alter by gxf 2008-1-21
				--qkje = (case @qkbz when 4 then zfje else qkje end),--alter by gxf 2008-1-21
				dnzhye=(case when @qkbz=1 then @zhje else dnzhye end)
				,ylkje=@ylknewje
				,ylksqxh=@ylknewsqxh
				,yflsh=@yflsh --add by xr 2010-09-17
				,ylkzxlsh=@ylknewzxlsh
				,qrrq=@now
				,bdyhkje = @bdyhkje
				,bdyhklsh = @bdyhklsh
				,lrrq=@now
				,zpje =(case when (@yytbz >0) and (@zffs_y = 'Y'  ) then @jfje else zpje end)
				,zph = (case when (@yytbz >0) and (@zffs_y = 'Y'  ) then 'Y'
							 when qkbz=4 then '4' 
							 else zph end)
				,gxrq=@now --add by yfq @20120528
				--,fpdybz=1
				,fpdybz=case when @print=0 and @configdyms=0 then 0 else 1 end
				,fpdyczyh=case when @print=0 and @configdyms=0 then @czyh else null end
				,fpdyrq=case when @print=0 and @configdyms=0 then @now else null end
				,hzdybz=0
				where sjh=@newsjh		
		end
		if @@error<>0 or @@rowcount=0
		begin
			select "F","�����շѽ�����Ϣ����"
			rollback tran
			return
		end

		if @config2596='��' and @zffs <> 0 
		begin	--���� @newsjh������¼ @y_sjh, ����¼ @newsjh1
			declare @cs_zfje	ut_money,
					@cs_xjje	ut_money,
					@cs_zpje	ut_money,
					@cs_zph		varchar(5),
					@y_qkje		ut_money,
					@y_xjje		ut_money,
					@y_zpje		ut_money,
					@y_zph		varchar(5),
					@y_sjh		varchar(30)

			select @y_sjh=tsjh from SF_BRJSK where sjh=@newsjh1
			select @y_xjje=xjje,@y_zpje=zpje,@y_zph=zph,@y_qkje=qkje from VW_MZBRJSK (nolock) where sjh=@y_sjh
			select @cs_zfje=zfje from SF_BRJSK (nolock) where sjh=@newsjh
			--�ų���ֵ���Լ�֧Ʊ֧��
			if @y_qkje=0 and @y_zph<>'2'
			begin
				if @cs_zfje<=@y_xjje

				begin
					select @cs_xjje=@cs_zfje,@cs_zpje=0,@cs_zph=''


				end
				else
				begin
					select @cs_xjje=@y_xjje,@cs_zpje=@cs_zfje-@y_xjje,@cs_zph=@y_zph
				end

				update SF_BRJSK set
					xjje=@cs_xjje,
					zpje=@cs_zpje,
					zph=@cs_zph
				where sjh=@newsjh
			end;
		end

		if exists(select 1 from YY_CONFIG nolock where id='1584' and config='��')
			and exists(select 1 from SF_BRXXK_FZ nolock where patid=@patid and isnull(gbfsjh,'')=@sjh)
		begin
			if @qtbz=0
				update SF_BRXXK_FZ set gbfsjh=@newsjh where patid=@patid
			else if @qtbz = 1
				update SF_BRXXK_FZ set gbfsjh='' where patid=@patid
			if @@ERROR<>0
			begin
				select "F","���²��˹������վݳ���"
				rollback tran
				return
			end

		end
		if @qtbz = 0 
		begin
		    if exists (select 1 from sysobjects where name='SF_BRJSK_FZ' and xtype='U')

		    BEGIN		
		        select @yhyydm = isnull(yhyydm,'0') from SF_BRJSK_FZ where sjh = @sjh
		    
			    update  SF_BRJSK_FZ set fph=@fph,fpjxh=@fpjxh,fpdm=@fpdm,yhyydm = @yhyydm where sjh=@newsjh		 
			    if @@error<>0
			    begin
				    select "F","��������˵�����"
				    rollback tran
				    return		
			    end	
		    END

		end


		              
  IF  EXISTS (SELECT 1 FROM YY_ADZFPT_JYMX WHERE sjh=@newsjh)              
  begin              
   UPDATE YY_ADZFPT_JYMX SET jsbz = 2,tsjh=@sjh  WHERE sjh=@newsjh            
   if @@error<>0 or @@rowcount=0            
   begin            
    select "F","�����ǵ²��ռ�¼����"            
    rollback tran            
    return            
   END            
  END  
		--mod by yyc 
		if (@zffs_y='7') and (@zpje_y>0) and (@tzpfs=1) 
            and (exists (select 1 from YY_CONFIG (nolock) where id='2197' and config='��'))
		begin
			update SF_BRJSK set xjje = 0, zpje = zfje ,zph='7' where sjh=@newsjh
			if @@error<>0
			begin
				select "F","�����շѽ�����Ϣ����1��"
				rollback tran
				return		
			end
            --select @sfje=0,@sfje2=0
		end



        
  if @print=0 and @acfdfp=0 and @configdyms=0 --add by ozb and @configdyms=0 ��ӡģʽΪ��ģʽ            
  begin            
   exec usp_yy_gxzsj @fplx, @czyh, @errmsg output, @gyfpbz            
   if @errmsg like 'F%'            
   begin            
    select "F",substring(@errmsg,2,49)            
    rollback tran            
    return            
   end            
  end            
              
 END             
 IF @zffs_y='Y' AND @zzfs_tf=1            
 BEGIN            
  UPDATE YY_ADZFPT_JYMX SET jlzt=1 WHERE sjh=@sjh            
  if @@error<>0 or @@rowcount=0            
  begin            
   select "F","�����ǵ±��˼�¼����"            
   rollback tran            
   return            
  END             
              
  UPDATE YY_ADZFPT_JYMX SET jsbz = 2,sjh=@newsjh1  WHERE tsjh=@sjh AND jlzt=2            
  if @@error<>0 or @@rowcount=0            
  begin            
   select "F","�����ǵº�����"            
   rollback tran            
   return            
  END             
         

		if  @qtbz=0  
		begin
			select @yyt_sje = zpje  from SF_BRJSK WHERE sjh=@newsjh and zph='Y'
			select  @yyt_tje=@yyt_tje+@yyt_sje

		end
		if @print=0 and @acfdfp=0 and @configdyms=0 --add by ozb and @configdyms=0 ��ӡģʽΪ��ģʽ


		begin
			exec usp_yy_gxzsj @fplx, @czyh, @errmsg output, @gyfpbz,@fpjxh,@sfksdm,@ipdz_gxzsj
			if @errmsg like 'F%'
			begin
				select "F",substring(@errmsg,2,49)
				rollback tran
				return
			end
		end
	end
	
	
	

	--ȷ�ϳ����¼
	update SF_YBBFTFJKK set jlzt=1 where sjh=@sjh and jlzt=0 
	if @@error<>0
	begin
		rollback tran
		select "F","ȷ�ϳ����¼����"
		return
	end
	
	--ͳ���ۼƽ���
	select @tcljybdm = config from YY_CONFIG where id = '0115'
	if charindex('"'+rtrim(@ybdm)+'"',@tcljybdm) > 0
	begin
		declare @mzpatid ut_xh12,
				@m_cardno ut_cardno,
				@tcljje2 ut_money,
				@cardtype ut_dm2
		select @m_cardno = cardno,@cardtype = cardtype,
				@tcljje1=zje-(zfje-srje)-yhje-isnull(tsyhje,0)
				from SF_BRJSK nolock where sjh = @sjh
		select @mzpatid=mzpatid from YY_BRLJXXK nolock where cardno = @m_cardno and cardtype = @cardtype
		if @@rowcount <> 0
		begin
			select @tcljje2=zje-(zfje-srje)-yhje-isnull(tsyhje,0)
			from SF_BRJSK nolock where sjh = @newsjh
			select @tcljje = isnull(@tcljje2,0) -isnull(@tcljje1,0)

			exec usp_zy_tcljjegl @m_cardno,@mzpatid,@tcljje,0,0,0,3,@czyh
			if @@error <> 0 
			begin
				rollback tran
				select "F","����YY_BRLJXXK��ͳ���ۼƽ�����"
				return
			end
		end
	end	

	--add wuwei ���ܴ�ӡ��Ʊ�˷Ѵ���
	if exists(select 1 from VW_MZBRJSK where sjh =@sjh and hzdybz =1)


	begin
		declare @fph_hzdy bigint
		,@fpjxh_hzdy int
		,@updatefph ut_bz --0 ������ 1 ����
		,@fph_fymxdyk bigint
		,@fpjxh_fymxdyk int
		,@maxxh int

		select @updatefph =1
	
 
		select @fph_hzdy =fph,@fpjxh_hzdy =fpjxh from 	VW_MZBRJSK where sjh =@sjh

		if isnull(@fph_hzdy,0) =0--�����Ʊ��Ϊ�գ����Ѿ����¹����������
		begin
			select @updatefph =0
		end
		
		if @updatefph =1---��Ҫ���£�����·�Ʊ��
		begin
			if exists(select 1 from SF_BRJSK where fph =@fph_hzdy and ybjszt =2 and jlzt =0 and fpjxh =@fpjxh_hzdy)
			begin
				update SF_BRJSK set fph =null,qrbz =case qrbz when 0 then 0 else 1 end,fpjxh =null--,fpdybz = 1 
				where fph =@fph_hzdy and ybjszt =2 and jlzt =0 and fpjxh =@fpjxh_hzdy
				if @@error <>0
				begin
					rollback tran
					select "F","��ԭ fph,qrbz ����"
					return
				end
			end
			else
			begin
				update SF_NBRJSK set fph =null,qrbz =case qrbz when 0 then 0 else 1 end,fpjxh =null--,fpdybz = 1 
				 where fph =@fph_hzdy and ybjszt =2 and jlzt =0 and fpjxh =@fpjxh_hzdy
				if @@error <>0
				begin
					rollback tran
					select "F","��ԭ Nfph,qrbz����"
					return
				end
			end
		end
		else
		if @updatefph =0--������´����Ѿ�������ˣ��򽫷�Ʊ�Ŵ� SF_FPDYMXK_HZDY �з����»���
		begin
			select @maxxh =max(xh) 
			from SF_FPDYMXK_HZDY where jssjh =@sjh
			
			if isnull(@maxxh,0)<>0 
			begin
			    select @fph_fymxdyk =fph,@fpjxh_fymxdyk =fpjxh from SF_FPDYMXK_HZDY where xh =@maxxh
			    if @@rowcount =0
			    begin
				    select 'F','ȡ������ SF_FPDYMXK_HZDY.xh ����'
				    rollback tran
				    return
			    end
			
			    if exists(select 1 from SF_BRJSK where sjh =@sjh)
			    begin
				    update SF_BRJSK set fph =@fph_fymxdyk,fpjxh =@fpjxh_fymxdyk,qrbz =case qrbz when 0 then 0 else 2 end  where sjh =@sjh
				    if @@error <>0
				    begin
					    rollback tran
					    select "F","������ fph,qrbz ����"
					    return
				    end
    				
				    update SF_BRJSK set fph =@fph_fymxdyk,fpjxh =@fpjxh_fymxdyk,qrbz =case qrbz when 0 then 0 else 2 end  where sjh =@newsjh1
				    if @@error <>0
				    begin
					    rollback tran
					    select "F","������ fph,qrbz ����"
					    return
				    end
			    end
			 end
			else
			begin
				update SF_NBRJSK set fph=@fph_fymxdyk,fpjxh =@fpjxh_fymxdyk,qrbz =case qrbz when 0 then 0 else 2 end  where sjh =@sjh
				if @@error <>0
				begin
					rollback tran
					select "F","������ nfph,qrbz ����"
					return
				end				
				update SF_NBRJSK set fph =@fph_fymxdyk,fpjxh =@fpjxh_fymxdyk,qrbz =case qrbz when 0 then 0 else 2 end  where sjh =@newsjh1
				if @@error <>0
				begin
					rollback tran
					select "F","������ nfph,qrbz ����"
					return
				end
			end
		end
		
		if @qtbz =0
		begin	
			update SF_BRJSK set qrbz =case qrbz when 0 then 0 else 1 end where sjh =@newsjh
			if @@error <>0
			begin
				rollback tran
				select "F","��ԭSF_BRJSK.qrbz����"
				return
			end
		end		
	end
	
	--if exists(select 1 from SF_BRJSK(nolock) where sjh =@newsjh and zph='S' AND zpje=0) 
	--	update SF_BRJSK set zph='' where sjh =@newsjh

	if exists(select 1 from SF_BRJSK(nolock) where sjh =@newsjh and zph<>'' AND zpje=0) 
		update SF_BRJSK set zph='' where sjh =@newsjh

	--������ϵͳ�Զ������ 
	
	if ((select config from YY_CONFIG where id='A219')='��') and ((select config from YY_CONFIG where id='A234')='��')
		and ((select config from YY_CONFIG where id='A262')='��')and ((select config from YY_CONFIG where id='A206')='1') 
	begin
		--begin tran
		declare @pcxh ut_xh12  --�������  
			 ,@tm ut_mc64   --���� 
			 ,@pcfxh	ut_xh12 
			 ,@pcfmxxh	ut_xh12 
			 ,@phjcfxh	ut_xh12 
			 ,@phjcfmxxh	ut_xh12 
		

		declare cs_ejkc cursor for 
		select a.xh,b.xh,b.hjmxxh,c.cfxh  from SF_MZCFK a (nolock),SF_CFMXK b (nolock) ,SF_HJCFMXK c (nolock) 
			where a.xh=b.cfxh and b.hjmxxh=c.xh and  jssjh=@newsjh1 and cflx not in (1,2,3)
		for read only

		open cs_ejkc
		fetch cs_ejkc into @pcfxh,@pcfmxxh ,@phjcfmxxh,@phjcfxh 
		while @@fetch_status=0
		begin 
			---��ȡ����
			select @pcxh=0,@tm='0'
			select @pcxh=isnull(wzpcxh,'0'),@tm=isnull(txm,'0') from fun_yy_mz_cljlk(@phjcfxh,@phjcfmxxh,1) 
			---�������
			if isnull(@pcxh,0)<>0 or isnull( @tm,'0')<>'0'
			begin
				exec usp_wz_hisxhpcl @pcfxh,0,@errmsg output,@pcxh=@pcxh,@tm=@tm,@mxxh=@pcfmxxh   
				if @errmsg like 'F%' or @@error<>0  
				begin    
			 		rollback tran
					select "F","������ϵͳ�Զ��������ʱ����"+@errmsg
					deallocate cs_ejkc
					return
				END 
				---����״̬
				exec usp_yy_mz_updatecljlk @phjcfxh,@phjcfmxxh,@pcfmxxh,3,@errmsg output 
				if @errmsg like 'F%' or @@error<>0  
				begin    
			 		rollback tran
					select "F","������ϵͳ�Զ��������ʱ����--����״̬��"+@errmsg
					deallocate cs_ejkc
					return
				END  
			end
			fetch cs_ejkc into @pcfxh,@pcfmxxh ,@phjcfmxxh,@phjcfxh
		end
		close cs_ejkc
		deallocate cs_ejkc

		if @qtbz=0	--�����˷�ʱҪ�����¼�¼
		begin
			declare cs_ejkct cursor for 
			select a.xh,b.xh,b.hjmxxh,c.cfxh  from SF_MZCFK a (nolock),SF_CFMXK b (nolock) ,SF_HJCFMXK c (nolock) 
			where a.xh=b.cfxh and b.hjmxxh=c.xh and jssjh=@newsjh and cflx not in (1,2,3)
			for read only

			open cs_ejkct
			fetch cs_ejkct into @pcfxh,@pcfmxxh ,@phjcfmxxh,@phjcfxh
			while @@fetch_status=0
			begin 
				---��ȡ����
				select @pcxh=0,@tm='0'
				select @pcxh=isnull(wzpcxh,'0'),@tm=isnull(txm,'0') from fun_yy_mz_cljlk(@phjcfxh,@phjcfmxxh,0) 
				---�������
				if isnull(@pcxh,0)<>0 or isnull( @tm,'0')<>'0'
				begin			
					exec usp_wz_hisxhpcl @pcfxh,0,@errmsg output,@pcxh=@pcxh,@tm=@tm,@mxxh=@pcfmxxh  
					if @errmsg like 'F%' or @@error<>0  
					begin    
			 			rollback tran
						select "F","������ϵͳ�Զ��������ʱ����"+@errmsg
						deallocate cs_ejkct
						return
					END  

					---����״̬
					exec usp_yy_mz_updatecljlk @phjcfxh,@phjcfmxxh,@pcfmxxh,2,@errmsg output 
					if @errmsg like 'F%' or @@error<>0  
					begin    
			 			rollback tran
						select "F","������ϵͳ�Զ��������ʱ����--����״̬��"+@errmsg
						deallocate cs_ejkct
						return
					END   
				end

				fetch cs_ejkct into @pcfxh,@pcfmxxh,@phjcfmxxh,@phjcfxh
			end
			close cs_ejkct
			deallocate cs_ejkct
		end
		--commit tran
	end 
    
    --���� 347373 ����������ҽԺ--HRP��HIS�Խ� 
    if exists(select 1 from YY_CONFIG nolock where id='2590' and config='��') 
	begin
		declare @hrp_database	varchar(32)
		select @hrp_database = config from YY_CONFIG nolock where id='0252'
		if(@@ROWCOUNT = 1)and(RTRIM(@hrp_database)<>'')
		begin		
			declare @hrp_cfxh		ut_xh12,
					@hrp_cfmxxh		ut_xh12,
					@hrp_ncfxh		ut_xh12,
					@hrp_ncfmxxh	ut_xh12,
					@hrp_strsql		varchar(1000)
					
			declare cs_hrp_clhx cursor for 
			select a.txh,b.tmxxh,a.xh,b.xh
			from SF_MZCFK a (nolock) 
				inner join SF_CFMXK b (nolock) on a.xh = b.cfxh
			where a.jssjh=@newsjh and b.yjqrbz is not null and b.yjqrbz = 1
				and isnull(b.qrksdm,'')<>'' and isnull(b.qrczyh,'')<>''
				and isnull(b.cd_idm,0) = 0 and isnull(b.lcxmdm,'0')='0' 
				and a.patid=@patid
			for read only

			open cs_hrp_clhx
			fetch cs_hrp_clhx into @hrp_cfxh,@hrp_cfmxxh ,@hrp_ncfxh,@hrp_ncfmxxh 
			while @@fetch_status=0
			begin 
				select @hrp_strsql = 
					'	declare @hrp_result	varchar(2),'+
					'	@hrp_msg	varchar(64) '+
					'	exec '+RTRIM(@hrp_database)+'dbo.USP_LSCM_CLHXQR @patid='+CONVERT(varchar(12),@patid)+
					',@ycfxh='+CONVERT(varchar(12),@hrp_cfxh)+',@ycfmxxh='+CONVERT(varchar(12),@hrp_cfmxxh)+
					',@ncfxh='+CONVERT(varchar(12),@hrp_ncfxh)+',@ncfmxxh='+CONVERT(varchar(12),@hrp_ncfmxxh)+
					',@result=@hrp_result output,@cwxx=@hrp_msg output '+
					'if @hrp_result = ''F'' '+
					'	RAISERROR(''USP_LSCM_CLHXQR return error : %s '',16,1,@hrp_msg) '
				exec(@hrp_strsql)
				if(@@ERROR<>0)
				begin
					select 'F','����HRP���Ϻ���״̬�ذ�ʧ�ܣ�'
					rollback tran
					close cs_hrp_clhx
					deallocate cs_hrp_clhx
					return
				end
				fetch cs_hrp_clhx into @hrp_cfxh,@hrp_cfmxxh ,@hrp_ncfxh,@hrp_ncfmxxh 
			end
			close cs_hrp_clhx
			deallocate cs_hrp_clhx
		end
	end
	commit tran

	--����ҽ��վ��ҩ���̣���ҩд��SF_PYQQK��ʽ��
	
	if (select config from YY_CONFIG where id='0124')='��'
	begin
		begin tran          
		declare cs_pyqq1 cursor for 
		select xh,hjxh,fybz from SF_MZCFK(nolock) where jssjh=@sjh and fybz=0	--δ��ҩ�ļ�¼��Ҫ����
		for read only

		open cs_pyqq1
		fetch cs_pyqq1 into @pycfxh,@pyhjxh,@pyfybz
		while @@fetch_status=0
		begin
			select @qqkpybz=0,@havejl=0
			select @qqxh=xh,@qqkpybz=pybz from SF_PYQQK where jssjh=@sjh and (cfkxh=@pycfxh or hjxh=@pyhjxh) and patid=@patid
			if @@rowcount<>0	--SF_PYQQK���м�¼
			begin
				select @havejl=1
				if @qqkpybz=1	--δ��ҩ������ҩ
				begin
					select @pyhcxh=xh,@pyhcsjh=jssjh from SF_MZCFK(nolock) 
					where isnull(txh,0)=@pycfxh and jlzt=2

					insert into SF_PYQQK(jssjh,hjxh,cfxh,cfkxh,czyh,lrrq,patid,hzxm,ybdm,py,wb,ysdm,ksdm,yfdm,qrczyh,
					qrrq,qrksdm,pyczyh,pyrq,cfts,txh,sfckdm,pyckdm,fyckdm,jsbz,
					jlzt,fybz,cflx,sycfbz,tscfbz,pybz,jcxh,memo,zje,zfyje,yhje,zfje,srje,
					fph,fpjxh,tfbz,tfje,xzks_id ,spzfbl,spzfce,pyqr,sqdxh,yflsh,ejygksdm,
					ejygbz,ksfyzd_xh,fyckxh,dpxsbz,zpwzbh,zpbh)	
					select @pyhcsjh,hjxh,cfxh,@pyhcxh,czyh,@now,patid,hzxm,ybdm,py,wb,ysdm,ksdm,yfdm,qrczyh,
					qrrq,qrksdm,"","",cfts,xh,sfckdm,pyckdm,fyckdm,jsbz,
					2,fybz,cflx,sycfbz,tscfbz,0,jcxh,memo,zje,zfyje,yhje,zfje,srje,
					fph,fpjxh,tfbz,tfje,xzks_id ,spzfbl,spzfce,pyqr,sqdxh,yflsh,ejygksdm,
					ejygbz,ksfyzd_xh,fyckxh,dpxsbz,zpwzbh,zpbh
					from SF_PYQQK(nolock)
					where xh=@qqxh
					if @@error<>0
					begin
						rollback tran
						select "F","���SF_PYQQKʱ����"
						deallocate cs_pyqq1
						return
					end

					select @xhtemp=@@identity

					insert into SF_PYMXK(cfxh,cd_idm,gg_idm,dxmdm,ypmc,ypdm,ypgg,ypdw,dwxs,ykxs,ypfj,ylsj,ypsl,
					ts,cfts,zfdj,yhdj,shbz,memo,flzfdj,txbl,lcxmdm,lcxmmc,zbz,yjqrbz,qrksdm,clbz,hjmxxh,
					hy_idm,hy_pdxh,gbfwje,gbfwwje,gbtsbz,btsbl,hzlybz,bgdh,bgzt,txzt,bglx,fpzh,lcxmsl,
					dydm,yyrq,yydd,zysx,yylsj,yjspbz,lcjsdj)
					select @xhtemp,cd_idm,gg_idm,dxmdm,ypmc,ypdm,ypgg,ypdw,dwxs,ykxs,ypfj,ylsj,-1*ypsl,
					ts,cfts,zfdj,yhdj,shbz,memo,flzfdj,txbl,lcxmdm,lcxmmc,zbz,yjqrbz,qrksdm,clbz,hjmxxh,
					hy_idm,hy_pdxh,gbfwje,gbfwwje,gbtsbz,btsbl,hzlybz,bgdh,bgzt,txzt,bglx,fpzh,-1*lcxmsl,
					dydm,yyrq,yydd,zysx,yylsj,yjspbz,lcjsdj
					from SF_PYMXK(nolock)
					where cfxh=@qqxh
					if @@error<>0
					begin
						rollback tran
						select "F","���SF_PYMXKʱ����"
						deallocate cs_pyqq1
						return
					end
				end
				if @qqkpybz=0	--δ��ҩ��δ��ҩ
				begin
					delete from SF_PYQQK where xh=@qqxh
					if @@error<>0
					begin
						rollback tran
						select "F","ɾ��SF_PYQQK�ļ�¼ʱ����"
						deallocate cs_pyqq1
						return
					end
				end
			end
			fetch cs_pyqq1 into @pycfxh,@pyhjxh,@pyfybz
		end
		close cs_pyqq1
		deallocate cs_pyqq1

		if @qtbz=0	--�����˷�ʱҪ�����¼�¼
		begin
			declare cs_pyqq2 cursor for
			select xh,hjxh from SF_MZCFK(nolock) where jssjh=@newsjh and fybz=0

			open cs_pyqq2
			fetch cs_pyqq2 into @pycfxh,@pyhjxh
			while @@fetch_status=0
			begin
				insert into SF_PYQQK(jssjh,hjxh,cfxh,cfkxh,czyh,lrrq,patid,hzxm,ybdm,py,wb,ysdm,ksdm,yfdm,qrczyh,
				qrrq,qrksdm,pyczyh,pyrq,cfts,txh,sfckdm,pyckdm,fyckdm,jsbz,
				jlzt,fybz,cflx,sycfbz,tscfbz,pybz,jcxh,memo,zje,zfyje,yhje,zfje,srje,
				fph,fpjxh,tfbz,tfje,xzks_id ,spzfbl,spzfce,pyqr,sqdxh,yflsh,ejygksdm,
				ejygbz,ksfyzd_xh,fyckxh,dpxsbz,zpwzbh,zpbh)
				select jssjh,hjxh,cfxh,xh,czyh,lrrq,patid,hzxm,ybdm,py,wb,ysdm,ksdm,yfdm,qrczyh,
				qrrq,qrksdm,pyczyh,pyrq,cfts,null,sfckdm,pyckdm,fyckdm,1,
				jlzt,fybz,cflx,sycfbz,tscfbz,pybz,jcxh,memo,isnull(zje,0),isnull(zfyje,0),isnull(yhje,0),isnull(zfje,0),isnull(srje,0),
				fph,fpjxh,tfbz,tfje,xzks_id ,0,0,pyqr,sqdxh,yflsh,ejygksdm,
				ejygbz,ksfyzd_xh,fyckxh,dpxsbz,zpwzbh,zpbh
				from SF_MZCFK(nolock)
				where xh=@pycfxh
				if @@error<>0
				begin
					rollback tran
					select "F","����SF_PYQQK����"
					deallocate cs_pyqq2
					return
				end

				select @xhtemp=@@identity

				insert into SF_PYMXK(cfxh,cd_idm,gg_idm,dxmdm,ypmc,ypdm,ypgg,ypdw,dwxs,ykxs,ypfj,ylsj,ypsl,
				ts,cfts,zfdj,yhdj,shbz,memo,flzfdj,txbl,lcxmdm,lcxmmc,zbz,yjqrbz,qrksdm,clbz,hjmxxh,
				hy_idm,hy_pdxh,gbfwje,gbfwwje,gbtsbz,btsbl,hzlybz,bgdh,bgzt,txzt,bglx,fpzh,lcxmsl,
				dydm,yyrq,yydd,zysx,yylsj,yjspbz,lcjsdj)
				select @xhtemp,cd_idm,gg_idm,dxmdm,ypmc,ypdm,ypgg,ypdw,dwxs,ykxs,ypfj,ylsj,ypsl,
				ts,cfts,zfdj,yhdj,shbz,memo,flzfdj,txbl,lcxmdm,lcxmmc,zbz,yjqrbz,qrksdm,clbz,hjmxxh,
				hy_idm,hy_pdxh,gbfwje,gbfwwje,gbtsbz,gbtsbl,hzlybz,bgdh,bgzt,txzt,bglx,fpzh,lcxmsl,
				dydm,yyrq,yydd,zysx,yylsj,yjspbz,lcjsdj
				from SF_CFMXK(nolock)
				where cfxh=@pycfxh
				if @@error<>0
				begin
					rollback tran
					select "F","����SF_PYMXK����"
					deallocate cs_pyqq2
					return
				end

				fetch cs_pyqq2 into @pycfxh,@pyhjxh
			end
			close cs_pyqq2
			deallocate cs_pyqq2
		end
		commit tran
	end  
    
			

	if @qkbz = 1 
	begin
		select @qkje_view = @qkje_new
	end
	else
		select @qkje_view = @qkje




	select 	@ysybzfje = isnull(sum(je),0) from SF_JEMXK nolock where lx in ('20','22','yb25') and jssjh = @newsjh
	select 	@gbje2 = isnull(sum(je),0) from SF_JEMXK nolock where lx in ('24','yb99') and jssjh = @newsjh

	--��ͣ�õĿ��˷ѣ�qkje�˵�xjje��
	declare @tslc		ut_bz,
			@oldqkje	ut_money,
			@newqkje	ut_money
	if exists(select 1 from YY_JZBRK a(nolock),YY_JZBRYJK b(nolock) where a.xh = b.jzxh and isnull(b.sjh,'') = @sjh 
		and a.jlzt = 1)
	begin
		select @tslc = 1
	end
	else
	begin
		select @tslc = 0
	end
	if @tslc = 1
	begin
		select @oldqkje = xjje from SF_BRJSK (nolock) where sjh = @newsjh1
		if @qtbz = 0
			select @newqkje = xjje from SF_BRJSK (nolock) where sjh = @newsjh
		else 
			select @newqkje = 0
	end
	if @acfdfp=0 or @configdyms=1
	begin

		if (select config from YY_CONFIG (nolock) where id='2036')='��'
		begin
			select "T", @zje, case when @gbbz = '0' then @zfyje-@flzfje else @gbje2 end, convert(varchar(20),@fph), --0-3
				@print, @sfje2-@qkje-@gbje, @qfdnzhzfje+@qflnzhzfje+@tclnzhzfje+@fjlnzhzfje,  --4-6
				@tczfje, @dffjzfje, 
				case @tslc when 1 then abs(@oldqkje+@newqkje) else case when (@sfywbzh=0) and (@zffs_y='Y') then 0
				    else
					@sfje-isnull(@sfje2,0)-(@qkje1-@qkje)-
					(isnull(@ylkje,0)-isnull(@ylknewje,0))-(@gbje1-@gbje)-(isnull(@bdyhkje_old,0)-isnull(@bdyhkje,0))
					-case when @qkbz=4 then 0 else isnull(@dbkje,0) end +@yyt_tje
				 end end-@zpje_yyt-(@zpje_zfzx1-@zpje_zfzx), 
				 '', @qkbz, @qkje_view  --12
				,@sjyjye,@sjdjje,@tsyhje,@gbje,@ysybzfje,@lczje,@lcyhje,0,0,@qkje1-@qkje 'tqkje'  --13-19-22 
				,-@yyt_tje yyt_tje,@fpdm--23,24
			union all
			select fpxmmc, sum(xmje), 0, '0', 0, sum(zfje), sum(zfyje),sum(yhje), 0, 0, fpxmdm, 0, 0 ,0,0,0,0,0,sum(xmje-lcyhje),sum(lcyhje),0,0,@qkje1-@qkje 'tqkje'  -- -22 
				,-@yyt_tje yyt_tje,''--23,24
				from SF_BRJSMXK where jssjh=@newsjh group by fpxmdm, fpxmmc
		end
		else begin
			select "T", @zje, case when @gbbz = '0' then @zfyje-@flzfje else @gbje2 end, convert(varchar(20),@fph), @print, @sfje2-@qkje-@gbje, @qfdnzhzfje+@qflnzhzfje+@tclnzhzfje+@fjlnzhzfje,  --0,6
				@tczfje, @dffjzfje   --7,8
				,
				case @tslc when 1 then abs(@oldqkje+@newqkje) else case when (@sfywbzh=0) and (@zffs_y='Y') then 0 
				 else
					 @sfje-isnull(@sfje2,0)-(@qkje1-@qkje)-(isnull(@ylkje,0)-isnull(@ylknewje,0))-(@gbje1-@gbje)-(isnull(@bdyhkje_old,0)-isnull(@bdyhkje,0))
					 -case when @qkbz=4 then 0 else isnull(@dbkje,0) end + @yyt_tje
				 end end-@zpje_yyt-(@zpje_zfzx1-@zpje_zfzx), 
				'', @qkbz, @qkje_view  -- 10 ,12
				,@sjyjye,@sjdjje,@tsyhje,@gbje,@ysybzfje,@lczje,@lcyhje,0,0,@qkje1-@qkje 'tqkje'  --13-19-22 
				,-@yyt_tje yyt_tje,@fpdm--23,24
			union all
			select dxmmc, xmje, 0, '0', 0, zfje, zfyje,yhje, 0, 0, dxmdm, 0, 0 ,0,0,0,0,0,xmje-lcyhje,lcyhje,0,0,@qkje1-@qkje 'tqkje'   --22
				,-@yyt_tje yyt_tje,''--23,24
				from SF_BRJSMXK where jssjh=@newsjh
		end
	end
	else
	begin

		--�����˷ѵĴ�����ӡ����  qxh 2003.5.27
		if exists(select 1 from  SF_MZCFK  where jssjh=@newsjh  and tfbz=1 and jlzt=0 ) 
		        select  "T",sum(zje), sum(zfyje), convert(varchar(20),@fph), @print, sum(zfje), @qfdnzhzfje+@qflnzhzfje+@tclnzhzfje+@fjlnzhzfje,
				@tczfje, @dffjzfje,
				case @tslc when 1 then abs(@oldqkje+@newqkje) else  case when (@sfywbzh=0) and (@zffs_y='Y') then 0 
				 else
					 @sfje-isnull(@sfje2,0)-(@qkje1-@qkje)-(isnull(@ylkje,0)-isnull(@ylknewje,0))-(@gbje1-@gbje)-(isnull(@bdyhkje_old,0)-isnull(@bdyhkje,0))
					 -case when @qkbz=4 then 0 else isnull(@dbkje,0) end + @yyt_tje
				 end end-(@zpje_zfzx1-@zpje_zfzx)
                ,'', @qkbz, @qkje_view,max(xh),max(cfxh)  --14
				,@sjyjye,@sjdjje,@tsyhje,@gbje,@ysybzfje,@lczje,@lcyhje,@qkje1-@qkje 'tqkje' --15 -22
				,-@yyt_tje yyt_tje--23
				from SF_MZCFK  where jssjh=@newsjh  and tfbz=1  
				group by fph		
				order by fph 		 
		else
		        select  "T",0, 0, 0, 1, @sfje2-@qkje-@gbje, @qfdnzhzfje+@qflnzhzfje+@tclnzhzfje+@fjlnzhzfje,
				@tczfje, @dffjzfje, 
				case @tslc when 1 then abs(@oldqkje+@newqkje) else  case when (@sfywbzh=0) and (@zffs_y='Y') then 0
				 else	
					@sfje-isnull(@sfje2,0)-(@qkje1-@qkje)-(isnull(@ylkje,0)-isnull(@ylknewje,0))-(@gbje1-@gbje)-(isnull(@bdyhkje_old,0)-isnull(@bdyhkje,0))
					-case when @qkbz=4 then 0 else isnull(@dbkje,0) end + @yyt_tje
				 end end-(@zpje_zfzx1-@zpje_zfzx)
                , '',@qkbz, @qkje_view,0,0
				,@sjyjye,@sjdjje,@tsyhje,@gbje,@ysybzfje,@lczje,@lcyhje,@qkje1-@qkje 'tqkje' --15 -22
				,-@yyt_tje yyt_tje--23
	end
end

return








