alter proc usp_zy_brqf   
	@syxh ut_syxh,
	@czyh ut_czyh,
	@ysdm ut_czyh,
	@idm ut_xh9,
	@ypdm ut_xmdm,
	@yfdm ut_ksdm,
	@fylb smallint,
	@fyly smallint,
	@ypdw ut_unit,
	@dwxs ut_dwxs,
	@zxsl ut_sl10,
	@txbz smallint,
	@errmsg varchar(50) output,
	@xmdj money = null,
	@yzxh numeric(12,0) = null,
	@qqxh numeric(12,0) = null,
	@qqrq varchar(16) = null,
	@yexh ut_syxh = null,
	@tfbz smallint = 0,
	@tfxh ut_xh12 = null,
	@ykxs ut_dwxs = null,
	@memo ut_memo = null,
	@zfdj money = 0,
   	@shbz ut_bz = 0,
   	@spbh ut_mc32 = null,
	@jfsj ut_rq16=null,
	@kl ut_zfbl=1,
	@bljsbl ut_zfbl=1,
	@jzjsbl ut_zfbl=1,
	@lcxmdm ut_xmdm='0',  --agg 2004.09.10 
	@lcxmmc ut_mc64=null,  --agg 2004.09.10
	@zxmdm  ut_xh12=-1,--scr 2004.12.11 �����޸ģ�������Ŀ��Ӧ������Ŀ����
	@xedj money = 0, 	--�޶�� ����������Ŀ����
	@qrksdm ut_ksdm = '', --mly 2005-04-12 ȷ�Ͽ��Ҵ��� 
	@tdxmxh ut_xh12 = 0,  --Koala 2005-09-13 �ض���Ŀ 
	@ispreqf ut_bz = 0,	 --Koala	2005-08-11	�Ƿ�ȷ��Ԥ��
	@yjmxxh ut_xh12=0,
    @ybqdm ut_ksdm=null,
    @yksdm ut_ksdm=null,
    @fymxxh_out    ut_xh12 = null output,	--������ϸ���
    @qfzfyy varchar(60)='',
    @cq_fjxm ut_bz = 0,  --���ڲ��˳������ӹ̶���Ŀִ�У��ʼð��������̣� 
    @jzks_qf  ut_ksdm=''   --���˿��ң����ڱ���ͳ�ƣ�
    ,@gdzxbz ut_bz=0   --�̶���Ŀִ�б�־
    ,@txbl_hg ut_zfbl=null		--�������(���ڰ���ʱ���ûع�)
    ,@sbid_qf varchar(1000)=''
    ,@jzys_qf  ut_czyh=''    --����ҽ�������ڱ���ͳ�ƣ�
    ,@num  int=-1,    --�������ô���
    @cth  varchar(20)='',    --CT��
    @xxh  varchar(20)='',    --X�ߺ�
    @mrih  varchar(20)='',    --MRI��
    @bch  varchar(20)='',    --B����
	@wkdz varchar(32)='',    --������ַ
	@yzlb int = -1,			--ҽ�����
    ------ҩƷ�����ۼۺϲ�------
    @sffy int = 0,			--�Ƿ�ҩ��0����ҩ��1��ҩ,2 ��ҩ,3�ѷ�ҩȷ��
	@zxlb int = 0,			--@sffy = 1 ʱ��Ч,0 :BQ_FYQQK ,1:BQ_SYCFMXK 2:BQ_YJQQK 3:BQ_YZZJQFK 4:BQ_YJFYQQK
	@yfyzje ut_money =0,	--�ѷ�ҩҩƷ�ܽ��    
	@fyfzxh	ut_xh12=0,		--���÷������
	@zyfymxxh1 ut_xh12=0 
	,@ssbl_qf ut_zfbl =1  --ʵ�ձ���
	,@jsks_qf ut_mc32=''
	,@wzdj money = 0  --add by guo for ���ʵ���(��ʩҽԺר��)
	------ҩƷ�����ۼۺϲ�--------
	,@pcxh	ut_xh12=0		--�������
	,@tm	ut_mc64=''		--����
	,@kcdylb  int=0           --���������  Ĭ��0�� 0-ԭ����  1-delphi��������¼�� ɨ�����Ƿ�ۿ��  
	,@jzbq_qf  ut_ksdm=''	--���˲���
	,@sfbl	ut_zfbl=null	--�շѱ���  add by swx 2015-1-13 for 12179 ��ɽ���ӵڶ�����ҽԺ
	,@wzqqxh numeric(12,0) = 0
	,@tcwbz	ut_bz=0			--�ײ����־
	,@jzyy	ut_mc64=''		--����ԭ��
	,@lcxmdj money = null
	,@dyly	int	= 0			--������Դ 0 ���ж� 1 ���������� .....
	,@zxrq_xg varchar(16)=''-- ����74281 ��ɽ������ҽԺҽ���˷����� ҽ���˷��Ƿ�����޸�ʱ��
	,@bxbl	ut_zfbl=null	--80900 �ൺ����ҽԺ��ʿվ����¼���޶���Χ����ѡ��
	,@ybshbz ut_bz=1
	,@ylzdm ut_ksdm=''		--121877 �����ҽԺ - ����ȷ�Ѵ洢usp_zy_brqf������Ρ�ҽ��С����롱
	,@szbdj ut_money=0      --ʡ�б굥��
	,@qzzfbz ut_bz = 0       --ǿ���Էѱ�־  0 ԭ����  1 ǿ���Է�
	,@barcodehrp varchar(100)='' --����HRP���� 
	,@sfxdzf  ut_bz=0 --�շ��޶�֧����־  0�� 1��
as--��69222 2010-4-14 15:46:11 4.0��׼�� ���Ի����63096                             
/**********
[�汾��]4.0.0.0.0
[����ʱ��]2004.11.22
[����]����
[��Ȩ] Copyright ? 2004-2008�Ϻ����˴�-��������ɷ����޹�˾[����]����ȷ��
[����˵��]
	סԺ���˷���ȷ��
[����˵��]
	@syxh ut_syxh,	��ҳ���
	@czyh ut_czyh,	����Ա
	@ysdm ut_czyh,	ҽ������
	@idm ut_xh9,	ҩidm
	@ypdm ut_xmdm,	ҩƷ�������Ŀ����
	@yfdm ut_ksdm,	ִ�п��Ҵ���
	@fylb smallint,	ͬ���˷�����ϸ���fylb�ֶ�
	@fyly smallint,	0=YK_YPCDMLK, 1=YY_SFXXMK
	@ypdw ut_unit,	ҩƷ��λ
	@dwxs ut_dwxs,	��λϵ��
	@zxsl ut_sl10,	ִ������
	@txbz smallint,	�����־0=��ͨ��1=����
	@errmsg varchar(50) output,
	@xmdj money = null,			��Ŀ����(��Ŀ����Ϊ0ʱ��@tfbz=2)
	@yzxh numeric(12,0) = null,	ҽ�����
	@qqxh numeric(12,0) = null,	�������
	@qqrq varchar(16) = null,	��������
	@yexh ut_syxh = null,		Ӥ�����
	@tfbz smallint = 0,			�˷ѱ�־0=������1=���ϣ�2=�˷�
	@tfxh ut_xh12 = null		�˷����(@tfbz=1)
	@ykxs ut_dwxs,				ҩ��ϵ��
	@memo ut_memo,				��ע��Ϣ
	@zfdj money=null,			�Էѵ���
    @shbz ut_bz,                ��˱�־
    @spbh ut_mc32,              ������� 
	@jfsj ut_rq16=null			�Ƿ�ʱ��
    @lcxmdm ut_xmmd                         �ٴ���Ŀ����
	@lcxmmc ut_mc64                         �ٴ���Ŀ����
	@pcxh ut_xh12=0				�������
	@tm	ut_mc64=''				����
	,@sfxdzf  ut_bz=0 --�շ��޶�֧����־  0�� 1��
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��]
[�޸ļ�¼]
tony 2003.8.21 �޸���ҽ�������Ը�����
chenwei 2003.11.7 ��Ӵ������zfdj,�˷�ʱ��ԭ�Էѵ��ۼ���ҽ�������Ը����
Modify By : Koala In : 2005-01-24	For �����������Ӵ�λ�޶�
mit ,2oo4-12-21,����txbl
modify by wxp 2005-02-18 copy by mly   �޸�Ӥ�������Ը����Ϊ0
			  2005-03-13 ������ҽԺ���˽���Ҫ�󳬹������ȫ���Է�
modify by mly 2005-04-12 ����ȷ�Ͽ��ҵĴ���
Modify By : Koala	In : 2005-09-11	For :����ʡ������,Ƿ�ѿ��Ʒ����޸�,����@ispreqf ut_bz = 0	 --Koala	2005-08-11	�Ƿ�ȷ��Ԥ��
Modify By : tony	In : 2005-10-25	For :ypmc��Ϊut_mc64
Modify by : gujun	In : 2005-12-27	For :����ҽ��С��ģʽ.�����Ҫ���.
Modify by : ydj		In : 2006-3-22	For : ���ӱ���BQ_YJFYQQK �з�xh��ZY_BRFYMXK 
Modify by : sunyu	In : 2006-4-18	For :���Ӷ�����������ҩƷ����ȫ�����flzfje�Ĵ���
modify by gzy at 20060809 for: �Զ�������ֻ����zfje��������flzfje
Modify By : Koala	In : 2006-11-08	For :������� 13730 ����ʡ������,��ҽ����ĸ�ֵ�ŵ�ǰ�洦��������@@error���ж� 
Modify By : Koala	In : 2007-01-15	For :������� 14347 ������Ժ����,��ʹ��ҽ���飬����ҽ����Ϊ��ʱ������ȷ��
   xwm  2011-07-29 Ҫ��֤�˷ѵ��۷�������������������������������
yjf 2013-06-04 ȷ��ʱ�Զ��۳����ʲ��Ͽ��  
Modify By : wyh	In : 2014-04-24	For :������� 196585 
**********/
set nocount on

declare @lsjms	ut_bz	  --���ۼ�ģʽ��3Ϊ�����ۼ�ģʽ
select @lsjms = dbo.f_get_ypxtslt() --add by shiyong 2012-04-08 ��ȡ���ۼ�ģʽ
--�����ۼӵ�ҩƷȷ��
if (@lsjms=3 and @idm>0) and (@dyly<>1)		-- ����������ҩƷ�޷�ҩ�޶�����ģʽ
begin
	exec usp_zy_brqf_dpc @syxh,@czyh,@ysdm,@idm,@ypdm,@yfdm,@fylb,@fyly,@ypdw,@dwxs
		,@zxsl,@txbz,@errmsg output,@xmdj,@yzxh,@qqxh,@qqrq,@yexh,@tfbz,@tfxh
		,@ykxs,@memo,@zfdj,@shbz,@spbh,@jfsj,@kl,@bljsbl,@jzjsbl
		,@lcxmdm,@lcxmmc,@zxmdm,@xedj,@qrksdm,@tdxmxh,@ispreqf,@yjmxxh
		,@ybqdm,@yksdm,@fymxxh_out output,@qfzfyy,@cq_fjxm,@jzks_qf,@gdzxbz
		,@txbl_hg,@sbid_qf,@jzys_qf,@num,@cth,@xxh,@mrih,@bch
		,@wkdz,@yzlb,@sffy,@zxlb,@yfyzje,@fyfzxh,@zyfymxxh1,@ssbl_qf,@jsks_qf,@jzbq_qf,@szbdj,@sfxdzf
	return								  
end	

declare @config7245 varchar(2)
select @config7245='��'
if @lsjms in(0,1,2)
begin
     select @config7245=config from YY_CONFIG(nolock) where id='7245'
end
	
--���·Ƕ����ۼ�ģʽ
select @jzks_qf=ltrim(rtrim(@jzks_qf)),@jzys_qf=ltrim(rtrim(@jzys_qf)),@jzbq_qf=ltrim(rtrim(@jzbq_qf))
declare @hzxm varchar(64),
		@ybdm	ut_ybdm,		--ҽ������
		@now	ut_rq16,		--��ǰʱ��
		@zfbz	smallint,		--������־
		@tybqdm	ut_ksdm,	--��ҩ��������	-- add by gzy at 20041208
		@bqdm	ut_ksdm,		--��������
        @tyksdm	ut_ksdm,
		@ksdm	ut_ksdm,		--���Ҵ���
		@ypdj	ut_money,		--ҩƷ����
		@sxjg	ut_money,		--���޼۸�
--		@zfdj	ut_money,		--�Էѵ���
		@yhdj	ut_money,		--�Żݵ���
--		@ykxs	ut_dwxs,		--ҩ��ϵ��
		@zfbl	ut_zfbl,		--�Էѱ���
		@yhbl	ut_zfbl,		--�Żݱ���
		@txbl	ut_zfbl,		--�������
		@dxmdm	ut_kmdm,		--�������
		@zje	ut_money,		--��Ŀ���
		@zfje	ut_money,		--�Էѽ��
		@yhje	ut_money,		--�Żݽ��
		@flzfje ut_money,	--�����Ը����
		@flzfbz ut_bz,		--�����Ը���־
		@yeje	ut_money,		--Ӥ�����
		@srce	numeric(16,4), --������
		@fyce	numeric(16,4),	--���ò�Ϊ�˼��㲿���˷�ʱ��һ�εķ��ò������շ�ʱ��Ӧ�Ĳ��
		@ypmc	ut_mc64,		--ҩƷ����
		@ypgg	ut_mc32,		--ҩƷ���
		@jsxh	ut_xh12,		--�������
		@old_ykxs	ut_dwxs,	--�ϵ�ҩ��ϵ��
		@old_zfdj	money,	--�ϵ��Էѵ���
		@cwdm	ut_cwdm,		--��λ����
		@dffbz	ut_bz,		--��������־
		@czyks	ut_ksdm,     --����Ա���ң�ȷ�Ͽ��ң�
		@djrq	ut_rq16
		,@zrysdm	ut_czyh    --����ҽ������
		,@zzysdm	ut_czyh    --����ҽ������
		,@age	numeric
		,@xh_temp	ut_xh12
		,@pzlx	ut_dm2
		,@yjbj	ut_money
		,@isusebj	char(4)
        ,@ysks_temp	ut_ksdm  --ҽ������
        ,@czybq_temp	ut_ksdm   --����Ա����
		,@gbbz	ut_bz		--�ɱ���־
		,@gbfwje	ut_money	--�ɱ���Χ�ڽ��
		,@gbfwwje	ut_money	--�ɱ���Χ����
		,@gbtsbz	ut_bz		--�ɱ������־
		,@gbtsfwje	ut_money	--�ɱ����ⷶΧ���
		,@gbtsfwwje ut_money	--�ɱ����ⷶΧ����
		,@gbtsbl	ut_zfbl	--�ɱ������Ը�����
        ,@gbzfbl_tf ut_zfbl    --�ɱ��˷��Էѱ���
		,@ylxzdm	ut_ksdm	--ҽ��С�����
		,@fzrysdm	ut_czyh   --������ҽ������
		,@flzfbl	ut_zfbl	--�����Ը�����
		,@flzfdj	ut_money	--�����Ը�����
		,@yzshkz	CHAR(4)	--����5223 ��Ժ�����Ƿ�ʹ��ҽ����˹���	add by gzy in 20061215
		,@jskzbz	ut_bz	--������˿��Ʊ�־	add by gzy in 20061215
		,@yzshbz	ut_bz	--ҽ����˱�־		add by gzy in 20061215
		,@isuseylz  char(4)
		,@dydm		varchar(32)      --YK_YPCDMLK��YY_SFXXMK���dydm����ҽ��ϵͳ��ҩƷ��С��Ŀ�Ĵ��� add 20070119
		,@lcjsdj	ut_money    	--ZY_BRFYMXK .lcjsdj
		,@lcyhje	ut_money	--ZY_BRJSMXK .lcyhje 
		,@xzks_id	ut_ksdm    --�������Ҵ��� 
		,@yyhdj		ut_money    --ԭ�Żݵ���
		,@flzfje_is3  varchar(2) --�����Ը�����Ƿ���3λС����
		,@cwtxbz	ut_bz        --�����־ ZY_BCDMK.txbz
		,@yzczh		ut_mc64    --ҽ��ҩƷ��Ŀע���  --add by cyh 2012-06-19
		,@config6623	varchar(2),
		@config6661		varchar(10),
		@config6809		varchar(2), --add by hhy �Ƿ�ʹ���߼�����
        @config6A21		VARCHAR(2), --add by cyh ��ʯ���ӵ������̣����ü���ҽ��������Ƿ��������ZY_BRJSK.shbz=1��ZY_BRSYK.ybjsbz=1��Ĭ��Ϊ��
        @brybjsbz		ut_bz       --add by cyh ����һ������־ybjsbz��0-δ���㣬1-�ѽ��㣩
        ,@config9177	varchar(2)-- ����74281 ��ɽ������ҽԺҽ���˷����� ҽ���˷��Ƿ�����޸�ʱ��
		,@sfxmmrsx		int --�շ���Ŀÿ���շ�����
		,@config6A33	char(1)
		,@config6B01	varchar(2)
		,@config6B06	varchar(2)
		,@etjsb			ut_zfbl
		,@txdj			ut_money
		,@djjsbz		INT
		,@yzxrq        VARCHAR(16)  ---ԭִ������
		,@etjsje ut_money  --��ͯ���ս��
		,@etjsbz ut_money  --��ͯ���ձ�־
		,@config6B96 int   --���㽭�����ö�ͯ������Ŀ�Ӽ����̵Ķ�ͯ����
		,@config6B60 int   --���ö�ͯ������Ŀ�Ӽ�ģʽ
	    ,@now_time   varchar(19) --��ǰʱ��time��ʽ 2017-12-26 08��56��00
		,@djrq_time  varchar(19) --����ʱ��time��ʽ 2017-12-26 08��56��00
		,@pkdj		 ut_bz		--ƶ���ȼ�  YY_PKRKXXB.pkdj
		,@pk_yhbl	 ut_zfbl	--�Żݱ���  YY_PKSFXMK.yhbl

--��ȡ����
-- 5188 by ydj 20050411 ���ӿ��Ʊ�����Ϊ����ҽԺ
select @now=convert(char(8),getdate(),112)+convert(char(8),getdate(),8)
select @isusebj=isnull(config,'��') from  YY_CONFIG (nolock)where id='5188'
--add by hhy �Ƿ�ʹ���߼�����
select @config6809 = isnull(config,'��') from YY_CONFIG(nolock) where id = '6809'
select @flzfje_is3 = config from YY_CONFIG (nolock) where id='5241'
if isnull(@flzfje_is3,'') = '' 
	select @flzfje_is3 = '��'
select @config6623=isnull(config,'��') from YY_CONFIG (nolock) where id='6623'  
-- add by gzy in 20061215 �жϳ�Ժ�����Ƿ�Ҫ���ҽ�������Ҫ���жϽ�����е�kzbz�����Ʊ�־�����Ʊ�־ 0 δ����(������ı����), 1 ����(����ı����)
SELECT @yzshkz=ISNULL(config,"��") FROM YY_CONFIG (nolock)WHERE id="5223"
SELECT @config6A21= isnull(config,'��') from YY_CONFIG(nolock) where id = '6A21'
SELECT @config6A21= isnull(@config6A21,'��')
select @config6661=config from YY_CONFIG(nolock) where id='6661' 
select @config9177=isnull(config,'��') from YY_CONFIG(nolock) where id='9177'
select @config6A33=isnull(config,'0') from YY_CONFIG(nolock) where id='6A33'
SELECT @config6A33= isnull(@config6A33,'0')
select @config6B01=isnull(config,'��') from YY_CONFIG(nolock) where id='6B01'
SELECT @config6B01= isnull(@config6B01,'��')
select @config6B06=isnull(config,'��') from YY_CONFIG(nolock) where id='6B06'
select @config6B06= isnull(@config6B06,'��')
select @config6B60=convert(int, isnull(config,'0')) from YY_CONFIG (nolock) where id='6B60'
--�㽭ʡ��ͯ���ﲿ����Ŀ�Ӽ���ȡ-סԺ����ȷ�Ѹ���
select @config6B96=convert(int, isnull(config,'0')) from YY_CONFIG (nolock) where id='6B96'  
if @config6B96 < 0
   select @config6B96 = 0

--������Ϣ�ж�
select @bqdm=bqdm, @ksdm=ksdm, @ybdm=ybdm, @cwdm=cwdm,@yjbj=yjbj,@gbbz=isnull(gbbz,0) 
	,@hzxm = hzxm,@brybjsbz=ISNULL(ybjsbz,0) 
from ZY_BRSYK (nolock)	--���Ӹɱ���־
where syxh=@syxh and brzt not in (3,8,9)
if @@rowcount=0
begin
	select @errmsg='Fû�иò�����Ϣ��'
	return
end

select @pzlx=pzlx from YY_YBFLK (nolock)where ybdm=@ybdm
if @@rowcount=0 
begin
	select @errmsg='Fҽ������û�н���ƥ��'
	return
end		

if exists (select 1 from ZY_BRSYK (nolock) where syxh=@syxh and gzbz=1)  ---�ѹ��˲���
begin
	select @errmsg= 'F'+@cwdm+'�����ˡ�'+@hzxm+'���ѹ���,���ܼ���!'
	return
end		

if exists(select 1 from ZY_BRSYK(nolock) where syxh=@syxh and bqdm=@bqdm)  
    select @zzysdm=a.zzysdm,@zrysdm=a.zrysdm,@fzrysdm=a.fzrysdm,@ylxzdm=a.id 
	from BQ_YS_YLZXX a(nolock),ZY_BRSYK b(nolock) where a.id=b.ylzdm and b.syxh=@syxh
else
    select @zzysdm=a.zzysdm,@zrysdm=a.zrysdm,@fzrysdm=a.fzrysdm,@ylxzdm=a.id 
    from BQ_YS_YLZXX a (nolock),BQ_BRZKQQK b (nolock) 
    where a.id=b.yylxzid and b.syxh=@syxh and b.bqdm=@bqdm and b.jlzt<>2
if @@error<>0 
begin
	select @errmsg='Fȡ����ҽ������Ϣʧ�ܣ�����ϵͳ����Ա��ϵ��'
	return	
end

--��ʹ��ҽ���飬��Ϊ�գ�������ȷ��
select @isuseylz ='��'
select @isuseylz = isnull(config,'��') from YY_CONFIG(nolock) where id ='6237'
if @@error<>0 
begin
	select @errmsg='Fȡҽ�������ó���'
	return	
end

if @isuseylz = '��'
begin
	if isnull(@ylxzdm,'') = ''
	begin
		select @errmsg='F����ҽ������ϢΪ�գ�������ά�������շѣ�'
		return	
	end

	if isnull(@ylzdm,'')<>''
		select @ylxzdm=@ylzdm

	if exists (select 1 from BQ_YS_YLZXX where id=@ylxzdm and isnull(jlzt,0)<>0)
	begin
		select @errmsg='F����ҽ��С����ֹͣ��������ά�������շѣ�'
		return	
	end
end

--������������������� = 6 +����¼��+����С��0+ �������ô���
if (ltrim(rtrim(@isusebj))='��') and (@zxsl < 0) and (@fylb=6 ) and (@tfbz = 0)
begin
	select @errmsg='F����5188=���ǡ����Բ�����¼�븺�����������Ϲ���'
	return
END

if exists (select 1 from ZY_BRJSK (nolock)where syxh=@syxh and jlzt=0 and ybjszt=1)
begin
	select @errmsg= "F�ò������ڽ���!���ܼ���!"
	return
end

SELECT @jskzbz=kzbz, @yzshbz=shbz FROM ZY_BRJSK (nolock)WHERE syxh=@syxh AND jlzt=0
IF (@yzshkz="��") AND (@jskzbz=1)
BEGIN
	SELECT @errmsg= "F�ò������ڳ�Ժ�����!���ܼ���!"
	RETURN
END
if (@config6A21='��')
begin
	IF(@yzshbz=1) AND(@brybjsbz=1)
	BEGIN
		SELECT @errmsg= "F��Ժ������˸ò��˵ķ���!���ܼ���!"
		RETURN
	END
end
else 
begin
	IF (@yzshkz="��") AND (@yzshbz=1)
	BEGIN
		SELECT @errmsg= "F�ò��˵�����ҽ�������!���ܼ���!"
		RETURN
	END
end
if exists(select 'x' from YY_CONFIG where id ='6A44' and config='��')
begin
	if exists(select 1 from ZY_BRFYMXK a (nolock) where a.syxh=@syxh and a.xh=isnull(@tfxh,0) and a.ybscbz=1 )
	begin
		select @errmsg='F���ַ������ϴ����볷���������޸ģ�'
		return
	end
end

if @jfsj is not null
begin
	select @djrq=ksrq from ZY_BRJSK (nolock)where syxh=@syxh and jszt=0 and ybjszt=0 and jlzt=0
	if @@error<>0 or @@rowcount=0
	begin
		select @errmsg='F���˵�ǰ�����¼�����ã�����ϵͳ����Ա��ϵ��'
		return	
	END
	
select @now_time=CONVERT(VARCHAR(10),GETDATE(),120)+' '+convert(char(8),getdate(),8)
select @djrq_time=case when len(ltrim(rtrim(isnull(@djrq,''))))=16 then 
                 	substring(@djrq,1,4)+'-'+substring(@djrq,5,2)+'-'+substring(@djrq,7,2)+' '+substring(@djrq,9,8) 
                 ELSE @djrq END
                 	
	if @jfsj<@djrq
	begin
		--select @errmsg='F���ܲ����˽���ǰ���ʣ�'
		select @errmsg='F���ܲ����˽���'+@djrq_time+'ʱ��ǰ���ʣ�'
		return	
	end
	if @jfsj>@now
	begin
		--select @errmsg='F���ܲ���ǰʱ�����ʣ�'
		select @errmsg='F���ܲ�'+@now_time+'ʱ�����ʣ�'
		return	
	end
end


 --[��fylb �������(0����ʱҽ������ 1������ҽ������ 3��ҽ������ 4���̶����� 5����ҩ���� 
                                --              6����ҽ����Ŀ¼��ʱ����(�շ�), �������ֱ������)
                                --              7����������(�������������������)
                                --              8����Ժ��ҩ 9��Ӥ������(ĸӤͬ����ʱ��Ӥ������fylb=9)
                                --              10��С�������� 11������ 12����ҩ]

if @fylb=3 --3��ҽ������
begin
	if ((@yfdm='') or (@ysdm is null))
	begin
		select @ysdm = ysdm from BQ_YJQQK(nolock) where xh=@qqxh
	end
end

if (@isuseylz = '��') and (@config6B01='��') and ((@fylb=0)or(@fylb=1))
	select @ysdm=@zrysdm

select @old_ykxs=@ykxs,@old_zfdj=isnull(@zfdj,0)
select @gbbz=0, @gbfwje=0, @gbfwwje=0, @gbtsbz=0, @gbtsfwje=0, @gbtsfwwje=0,@lcjsdj =0,@lcyhje = 0
	,@yyhdj = 0
--������� ҽ����ʱ���ң������Ժ��ת�ƣ�������Ա���ڲ���
select @ysks_temp=ks_id from YY_ZGBMK(nolock) where id =@ysdm
--10970 201810��������  סԺ�˷���ҩʱ�����˷�����ϸ����ҽ�����Ҵ���ΪNULL��ZY_BRFYMXK.ysks��
if(isnull(@ysks_temp,'')='') and isnull(@tfxh,0)<>'0'
begin
	select @ysks_temp=ysks from ZY_BRFYMXK where xh=@tfxh
end
-- add by cyh for 146486  ��Сʱ�շѵ���Ŀ�˷��޸�
--select @czybq_temp=bq_id from YY_ZGBMK (nolock)where zglb=2 and id in (select zgbm from czryk(nolock) where id =@czyh)
select @czybq_temp=a.bq_id from YY_ZGBMK a (nolock) where a.zglb=2 and exists(select 1 from  czryk b(nolock) where a.id=b.zgbm and b.id=@czyh)

--������ѧ�����۶��Ǻ��ҽԺ���������־
select @cwtxbz=isnull(txbz,0) from ZY_BCDMK(nolock) where syxh=@syxh 
if not exists(select 1 from YY_CONFIG (nolock)where id='6383' and config='��')
begin
	if not exists(select 1 from YY_CONFIG (nolock)where id='6384' and config='��')
	    select @cq_fjxm=0
end

if @qqrq is null
	select @qqrq=@now
if  (select config from YY_CONFIG (nolock)where id='6242')='��'  
	if @fylb=1 
		select @qqrq=zxrq from BQ_CQYZK (nolock)WHERE xh=@yzxh

--�жϵ�ǰ��ZY_BRJSK��ybjszt=0��xh�Ƿ��ZY_BRFYMXXMK�е�jsxhһ�£������һ�£����ܺ�壬���һ�£�����Ժ�塣
if (@tfbz=1) and (exists (select 1 from YY_CONFIG (nolock)where id='5231' and config='��'))   
begin  
    if not exists (select 1 from ZY_BRJSK a (nolock),ZY_BRFYMXK b (nolock)  
					where a.syxh=@syxh and a.jlzt=0 and a.ybjszt=0 and a.xh=b.jsxh and b.syxh=a.syxh and b.xh=@tfxh)  
    begin  
		select @errmsg= "F������;���ʵķ��ò�������!"  
		return  
    end  
end 


if @ybqdm is not null
select @bqdm=@ybqdm
if @yksdm is not null
select @ksdm=@yksdm
if @idm>0
	select @fyly=0
else
begin
	select @fyly=1
end

--add by kongwei for  96509 �ָĳ���ǰ̨¼��ʱ����
--select @sfxmmrsx = ISNULL(mrsxsl,0),@ypmc=name from YY_SFXXMK (nolock) where id =@ypdm 
--if @sfxmmrsx > 0 
--begin
--	if (@zxsl > @sfxmmrsx or exists(select 1 from ZY_BRFYMXK a(nolock) where a.syxh =@syxh and ypdm =@ypdm and SUBSTRING(qqrq,1,8)=SUBSTRING(@now,1,8)
--		group by syxh,ypdm,SUBSTRING(qqrq,1,8) having SUM(ypsl)+@zxsl > @sfxmmrsx)) 
--	begin
--		select @errmsg='F���˵��ա�'+@ypmc+'���Ʒ������Ѿ��������ޣ�'
--		return
--	end
--end

if @config9177 = '��' 
begin 
	if isnull(@zxrq_xg,'') = ''
	select @zxrq_xg = @now
end 

IF ISNULL(@tfxh,0)>0
BEGIN
	SELECT TOP 1 @yzxrq=zxrq FROM ZY_BRFYMXK(nolock)  WHERE syxh=@syxh AND ISNULL(yexh,0)=ISNULL(@yexh,0) AND xh=@tfxh
END
else begin
   select @yzxrq=@now
end


if @tfbz=1 --������1=����  start ������
begin
	---add by cyh ����ע��֤��  ����:118862
	if exists(select 1 from ZY_BRFYMXK a (nolock) where a.syxh=@syxh and a.xh=@tfxh and a.jlzt=0  and idm=0 )
	begin
		update a  set a.yzczh=c.item_previousidl
		from ZY_BRFYMXK  a,YY_SFXXMK b,YY_YBXMK c
		where  a.ypdm=b.id and b.sybz=1 and  a.syxh=@syxh and a.xh=@tfxh and a.jlzt=0 
			and b.dydm=c.item_code and a.idm=0 and isnull(a.yzczh,'')<>''
		if @@error<>0 
		begin
			select @errmsg='F����ҽ��ע��֤��ʱ����'
			return
		end  
	end	        
	else 
	begin
		update a  set a.yzczh=c.previousidl
		from ZY_BRFYMXK  a,YK_YPCDMLK b,YY_YBYPK c
		where  a.idm=b.idm and b.tybz=0 and a.syxh=@syxh and a.xh=@tfxh and a.jlzt=0  
			and b.dydm=c.mc_code and a.idm>0 and isnull(a.yzczh,'')<>'' 
  		if @@error<>0
		begin
			select @errmsg='F����ҽ��ע��֤��ʱ����'
			return
		end          
	end       
               
	update ZY_BRFYMXK set jlzt=1,zfyy=@qfzfyy,
		@zje=-zje,
		@zfje=-zfje,
		@yhje=-yhje,
		@flzfje=-flzfje,
		@dxmdm=dxmdm,
		@yeje=(case when @fylb=9 or @yexh>0 then -zfje else 0 end),
		@gbtsbz =gbtsbz,
		@gbfwje =-gbfwje,
		@gbfwwje =-gbfwwje
		,@lcjsdj =-isnull(lcjsdj,0)
		,@lcyhje = case when lcjsdj <> 0 then -(round(zje,2) - round(lcjsdj*ypsl/ykxs, 2)) else 0 end 		
		where syxh=@syxh and xh=@tfxh and jlzt=0
	if @@error<>0 or @@rowcount=0
	begin
		select @errmsg='F����ȷ��ʱ����'
		return
	end

	select @srce = -srce,@sfxdzf=ISNULL(sfxdzf,0) from ZY_BRFYMXK_FZ(nolock) where syxh=@syxh and xh=@tfxh 
	if @gbtsbz=1
		select @gbtsfwje=@gbfwje, @gbtsfwwje=@gbfwwje
end --������1=����  end ������
else 
begin --������0=���� or 2=�˷� start ������
	select @zfbz=zfbz from YY_YBFLK (nolock)where ybdm=@ybdm

	if @fyly=0 --��ҩƷ start
	begin
	   	--select @ypdj=ylsj  ����ҩƷ����Ϊ0 zhouyi 201311.20
		 select @ypdj=case when ylsj=0 then isnull(@xmdj,0) else ylsj end, @ykxs=ykxs, @zfbl=zyzfbl, @yhbl=0, @txbl=1, @dxmdm=yplh, @ypmc=ypmc,  
				@ypgg=ypgg, @sxjg=sxjg, @flzfbz=zyflzfbz,@dffbz=isnull(dffbz,0),@flzfbl=zyzfbl,
				@dydm=dydm,@lcjsdj = isnull(lcjsdj,0) --add 20070119
			from YK_YPCDMLK (nolock) where idm=@idm
		if @@error<>0 or @@rowcount=0
		begin
			select @errmsg='F����idmΪ'+convert(varchar(9),@idm)+'��ҩƷ�����ڣ�'
			return
		end

		if (@config7245='��') 
		begin
			select @ypdj=dbo.FUN_GETCEIL(b.ylsj,2) 
			from YK_YPCDMLK b(nolock)  inner join YY_SFDXMK c(nolock) on b.yplh=c.id
			where b.idm=@idm and c.ypbz=3  --ֻ��Բ�ҩ
		end

		--�˷��߸���������
		if @zxsl<0 
		begin
		     select @ypdj=case @xmdj when 0 then @ypdj else @xmdj end
		end

		--���������������= 0 
		if exists(select ybdm from YY_YBFLK (nolock) where ybdm = @ybdm and lcyhbz = 0)
			select  @lcjsdj = 0
		select @tybqdm= (case when kslb = 1 then @bqdm else bqdm end), --mod by hhy 2014.08.27 for 2218 ��������ҩ�Ļ���bqdmӦ��д�������ڲ�����
		           @tyksdm=ksdm from BQ_BRTYD(nolock) 	-- add by gzy at 20041208 �����˷�ԭ����
			where xh in (select tyxh from BQ_BRTYMX (nolock)where syxh = @syxh AND qqxh = @qqxh) AND yfdm = @yfdm
		if @@error<>0
		begin
			select @errmsg='F��ȡ���ݲ����������'
			return
		end
	end --��ҩƷ end
	else 
	begin --����Ŀ start
		select @ypdj=(case when @config6661=@ypdm then(select xmdj from ZY_BRFJGDXMK (nolock) where syxh=@syxh and xmdm=@config6661) else 
							(case when @config6623='��' then (select dbo.fun_getjjcl(@ypdm,xmdj))else xmdj end )
						end), 
			@ykxs=1, @zfbl=zyzfbl, @yhbl=yhbl, @txbl=txbl, @dxmdm=dxmdm, @dwxs=1, 
			@ypmc=name, @ypgg=xmgg, @ypdw=xmdw, @sxjg=sxjg, @flzfbz=zyflzfbz,@dffbz=0,@flzfbl=zyzfbl,@dydm=dydm --add 20070119
			,@etjsb=isnull(etjsb,0),@etjsje=etjsje,@etjsbz=etjsbz
		from YY_SFXXMK (nolock) where id=@ypdm
		if @@error<>0 or @@rowcount=0
		begin
			select @errmsg='F��Ŀ����Ϊ'+@ypdm+'����Ŀ�����ڣ�'
			return
		end
		select @ypdj=@ypdj*sfbl,@lcxmdj=case when isnull(@lcxmdj,0)=0 then isnull(xmdj,0) else @lcxmdj end
		from YY_LCSFXMK(nolock) 
		where id=@lcxmdm and @lcxmdm<>'0' and sfbl>0

--		if (@xmdj is not null) and (@xmdj <> 0)
--			select @ypdj = @xmdj 

		if (@xedj <> 0) and (@xedj is not null)
			select @ypdj = @xedj
			
		if @ypdj=0
			select @ypdj=isnull(@xmdj,0)
			
		--add by guo for ���ʵ���(��ʩҽԺר��)
        --if (select config from YY_CONFIG (nolock) where id='6714')='��'	
	    --begin
          IF isnull(@wzdj,0)<>0 
            SELECT  @ypdj=ISNULL(@wzdj,0)
        --end
         --add by xhy for ���ʵ���(��ʩҽԺר��)
          if (select config from YY_CONFIG (nolock) where id='8129')='��'	 
	    begin
	      IF isnull(@wzdj,0)<>0 
               SELECT  @ypdj=ISNULL(@wzdj,0)
	    end
	    
	    if @etjsbz = 1 and @config6B96 > 0 and @config6B60 = 2
	    begin
	        if exists(select 1 from ZY_BRSYK where syxh = @syxh 
				--and (case when isnull(birth,'')='' then 0 else datediff(year,convert(datetime,birth),getdate()) end) <= @config6B96 
				--����6B96=6����ô6��01����datediff(year,convert(datetime,birth),getdate())�ж�ʱҲ��6��ʵ���ϳ���6������1��Ҳ�����6��
				--����������жϣ�����-1��ʱҪ��6�������Ͳ����6��01�����ȥ�ˣ�ֻ���ж�0-6�ܵ�Ӥ��
				and (cast(convert(char( 8 ),getdate(),112) as int) - cast(convert(char( 8 ),convert(datetime,birth),112) as int))/10000 <= @config6B96 
				and (cast(convert(char( 8 ),getdate(),112) as int) - cast(convert(char( 8 ),dateadd(dd,1,convert(datetime,birth)),112) as int))/10000 < @config6B96 
				)
	        --���ö�ͯ������Ŀ�Ӽ����̵Ķ�ͯ����,С�ڲ���ֵ�Ҳ�Ϊ0ʱ�߸�����
	        begin
	            SELECT  @ypdj=@ypdj + @etjsje
	        end
	    end

		if @yfdm is null or @yfdm=''   -- û��ִ�п��ҵ���Ŀ�Ѳ��˿��ҵ���ִ�п���
			select @yfdm=@ksdm
	end --����Ŀ end		

	--W20050313 �����շ���Ŀ���������޼۸�,������������ⲡ�˵����޼۸�����.
	--˳��:��ִ���շ�С��Ŀ�е����޼۸�,�ٸ���ִ�������շ���Ŀ�е����޼۸�
	if @fyly = 0 
		select @sxjg = isnull(sxjg,0) from YY_TSSFXMK (nolock)where idm= @idm and ybdm = @ybdm
	else
		select @sxjg = isnull(sxjg,0) from YY_TSSFXMK (nolock)where xmdm= @ypdm and ybdm = @ybdm

	if @old_ykxs is not null
		select @ykxs=@old_ykxs

	if @txbz=0
		select @txbl=1

    if @gdzxbz=2   --�������ûع�ʱ����Ϊ�޷��������־������ֱ��ʹ�ô������ı���
        select @txbl=@txbl_hg

	--select @ypdj=@ypdj*@txbl

	--Lexus , 2004-07-28 , 14�����¶�ͯ����20%,�����������
	if (select config from YY_CONFIG (nolock) where id='5172')='��'	--[���ݺ��]סԺ����С��14���Ƿ���ռ��Ѻ����Ʒ� Ϊ �� start
	begin
		if @fyly<>0
		begin
			if exists(select 1 from ZY_BRSYK (nolock)where --yxp datediff(year,convert(datetime,birth),getdate())<=14 and syxh=@syxh)
				(case when isnull(birth,'')='' then 0 else datediff(year,convert(datetime,birth),getdate()) end)<=14 and syxh=@syxh)
				select top 1 @txbl=txbl*@txbl from YY_TSSFXMK (nolock)WHERE xmdm=@ypdm and ybdm=@ybdm
		end

		if @txbl<1
			select @txbl=1

		select @ypdj=@ypdj*(@txbl-1)+@ypdj*(@jzjsbl-1)+@ypdj*@kl

	end 	--[���ݺ��]סԺ����С��14���Ƿ���ռ��Ѻ����Ʒ� Ϊ �� end
	else
	begin 	--[���ݺ��]סԺ����С��14���Ƿ���ռ��Ѻ����Ʒ� Ϊ �� start
		if @txbz=0
			select @txbl=1

		if @gdzxbz=2   --�������ûع�ʱ����Ϊ�޷��������־������ֱ��ʹ�ô������ı���
			select @txbl=@txbl_hg
		select @ypdj=@ypdj*@txbl
	end 	--[���ݺ��]סԺ����С��14���Ƿ���ռ��Ѻ����Ʒ� Ϊ �� end
	--�������28��С��6��Ĳ����Ƿ��ն�ͯ���ձ����Ʒ�
	if (@fyly<>0) 
	begin
		if @config6B60=1 
		begin
			if exists(select 1 from ZY_BRSYK (nolock) where syxh=@syxh 
					and (case when isnull(birth,'')='' then 0 else datediff(year,convert(datetime,birth),getdate()) end)<6	--С��6��
					and (case when isnull(birth,'')='' then 0 else datediff(day,convert(datetime,birth),getdate()) end)>28 --����28��
				)
				select @ypdj=@ypdj*(1+@etjsb)
		end
	end
	-- swx 2015-7-31 for 36039 ���ݶ�ͯҽԺ+��ʿ����
	if @fylb<>9	-- ���˻�ִ�Ӥ��
	begin
		if (@fyly<>0) 
			and exists(select 1 from ZY_BRSYK (nolock) where syxh=@syxh 
				and (case when isnull(birth,'')='' then 0 else datediff(year,convert(datetime,birth),getdate()) end)>6)
			and exists(select 1 from YY_SFXXMK (nolock) where id=@ypdm and ekbz=1)
		begin
			select @errmsg='F���Ʊ�־��С��Ŀ6�����ϻ��߲�����ʹ�ã�'
			return
		end	
	end
	else
	begin
		if (@fyly<>0) 
			and exists(select 1 from ZY_BABYSYK (nolock) where xh=@yexh 
				and (case when isnull(birth,'')='' then 0 else datediff(year,convert(datetime,substring(birth,1,8)),getdate()) end)>6)
			and exists(select 1 from YY_SFXXMK (nolock) where id=@ypdm and ekbz=1)
		begin
			select @errmsg='F���Ʊ�־��С��Ŀ6�����ϻ��߲�����ʹ�ã�'
			return
		end	
	end
	
	--Ҫ��֤�˷ѵ��۷�������������������������������  mod by xwm  2011-07-29
	if @tfbz=2 
		select @ypdj=@xmdj
	-- swx 2014-12-4 for 9804 �Ϻ�����ҽԺ  ������ʿվ   ҽ��ִ����Ŀ����
	if exists(select 1 from YY_CONFIG(nolock) where id='6872' and config='��')
	begin 
		if exists(select 1 from YY_CONFIG(nolock) where id='G073' and config='')
			and exists(select 1 from YY_TSSFXMK (nolock) WHERE xmdm=@ypdm and ybdm=@ybdm and idm=0 and @idm=0) -- ����@idm=0��xmdm=@ypdm�������շ���Ŀ
			and exists(select 1 from ZY_BCDMK where id =(select cwdm from ZY_BRSYK where syxh=@syxh) and isnull(txbz,0)<>1 -- 8555 ��λ��Ŀ����������������־�Ĳ��ߴ����̡�
				and bqdm=@bqdm ) 
			and exists(select 1 from YY_CONFIG (nolock) where id='5172' and config='��')	--5172Ϊ��ʱ���ߴ�����
			and exists(select 1 from YY_SFXXMK (nolock) where id=@ypdm and @idm=0 and xmdj<>0) --xmdj=0���Զ��嵥����Ŀ���ߴ�����
			and exists(select 1 from YY_YBFLK yb(nolock) inner join ZY_BRSYK sy(nolock) on sy.ybdm=yb.ybdm where sy.syxh=@syxh and yb.ybdm=@ybdm and yb.zfbz=3) 		 
		begin
			select @txbl=txbl from YY_TSSFXMK (nolock) WHERE xmdm=@ypdm and ybdm=@ybdm and idm=0
			if @txbl is null
			begin
				select @errmsg='F�����շ���Ŀ��������ά������ȷ��'
				return
			end
			select @ypdj=@ypdj*@txbl
		end
	end
	--�Ƿ����ù����ִ�ҽԺȷ��ģʽ
	if exists(select 1 from YY_CONFIG (nolock) where id='6B64' and config='��')
	begin
		if exists(select 1 from YY_TSSFXMK (nolock) WHERE ybdm=@ybdm 
			and ((@idm=0 and xmdm=@ypdm and idm=0)or(@idm>0 and idm=@idm)) 
			)
		begin
			select @djjsbz=isnull(djjsbz,0),@txdj=txdj,@txbl=txbl 
			from YY_TSSFXMK (nolock) 
			WHERE ybdm=@ybdm
				and ((@idm=0 and xmdm=@ypdm and idm=0)or(@idm>0 and idm=@idm)) 
			if @djjsbz=1
				select @ypdj=@txdj
			else
				select @ypdj=@ypdj*isnull(@txbl,1)
		end
	end
	--add by kongwei for 317278 ��ƶ���߸���
	if exists(select 1 from YY_PKRKXXB a inner join ZY_BRSYK b(nolock) on a.sfzh=b.sfzh and b.syxh=@syxh where a.jlzt=1 and a.shbz=1 and a.mzzybz in (0,2) )
	begin
		--�ֻ�ȡƶ���ȼ�  Ϊ�˻�ȡ�Żݱ��������Żݺ�ypdj
		select @pkdj=a.pkdj from YY_PKRKXXB a 
		inner join ZY_BRSYK b(nolock) on a.sfzh=b.sfzh and b.syxh=@syxh 
		where a.jlzt=1 and a.shbz=1 and a.mzzybz in (0,2)
		--��ȡ�Żݱ���
		select @pk_yhbl=isnull(a.yhbl,1)
		from YY_PKSFXMK a
		where a.idm=@idm and a.xmdm=@ypdm and a.pkdj=@pkdj and xtbz=1
		--�����Żݺ�ypdj
		select @ypdj=@ypdj*isnull(@pk_yhbl,1)
	end

	if @memo='6951����,һ��ֻ��һ��'
	begin
		select @ypdj=0
	end
	--add by Wang Yi, 2003.03.07��Ӥ��ҽ��Ҳ�鵽Ӥ��������
	if @yexh > 0 and @fylb in (0,1)
		select @fylb = 9

	if @fylb=9 or @yexh > 0		--Ӥ������ȫ�Է�
		select @yhbl=0, @zfbl=1
	else if @zfbz=0
		select @yhbl=0
	else if @zfbz=2 
	begin
		select @yhbl=0
		if @idm > 0
			select @zfbl=zfbl,@flzfbl=zfbl from YY_TSSFXMK (nolock)
				where idm=@idm and ybdm=@ybdm
		else
			select @zfbl=zfbl,@flzfbl=zfbl from YY_TSSFXMK (nolock)
				where idm=@idm and xmdm=@ypdm and ybdm=@ybdm

		if @@error<>0
		begin
			select @errmsg='F�������ʱ����'
			return
		end
	end
	else if @zfbz=3
	begin
		if @idm > 0
			select @zfbl=0,@yhbl=yhbl from YY_TSSFXMK (nolock)
				where idm=@idm and ybdm=@ybdm
		else
			select @zfbl=0,@yhbl=yhbl from YY_TSSFXMK (nolock)
				where idm=@idm and xmdm=@ypdm and ybdm=@ybdm

		if @@error<>0
		begin
			select @errmsg='F�������ʱ����'
			return
		end
	end

	if (@pzlx<>'8') or ((@zfbl<1) and (@zfbl>0))
		select @flzfbl=@zfbl
	/****������ҽԺ���˽���Ҫ�󳬹������ȫ���Է�   ��ʼ************/
    if (@isusebj='��') and (@pzlx<>0)and (@zfbl<>1) --��Ŀǰ���ƴ���ҽ�����˲���ͨ������5186���ؿ��� start
	begin
		declare   @dqbrzje money --ȷ��ǰ�����ܽ��
		select @dqbrzje = zje-zfyje-yhje+flzfje from ZY_BRJSK (nolock) where syxh=@syxh and jszt=0 and ybjszt=0 and jlzt=0
		if (@dqbrzje-@yjbj)>=0
			select @zfbl=1
        else
		begin
			if @dqbrzje+(@ypdj*@zxsl*(1-@zfbl)/@ykxs)>=@yjbj
				select @zfbl=(@ypdj*@zxsl*(1-@zfbl)/@ykxs-@yjbj+@dqbrzje+@ypdj*@zxsl*@zfbl/@ykxs)*0.0001/(round(@ypdj*@zxsl/@ykxs, 2)*0.0001)
			else
				select @zfbl=@zfbl
		end
	end  --��Ŀǰ���ƴ���ҽ�����˲���ͨ������5186���ؿ��� end
	/****������ҽԺ���˽���Ҫ�󳬹������ȫ���Է�   ����************/
	if @zfbz=4 and @fylb<>9
		select @zfbl = 0,@zfdj=0, @yhbl = 0,@yhdj=0, @flzfbl = 0 ,@flzfdj=0

	--��С�����ĵ������ɱ������ɱ�����begin
	--ֻ��С���������жϵ�����,�������ɱ����Ż�
	if @fylb=10 and @dffbz=1
	begin	
		if (select count(1) from ZY_XCFMXK (nolock) where 
				cfxh=(select cfxh from BQ_FYQQK (nolock) where xh=@qqxh))>1
			select @zfbl = 0,@zfdj=0,@flzfdj=0,@flzfbl = 0 
		else
			select @zfbl = 1,@zfdj=@ypdj,@yhbl = 0,@yhdj=0,@flzfdj=@ypdj,@flzfbl = 1
	end
	--��С�����ĵ������ɱ������ɱ�����end

	if @flzfbz=0 
		select @flzfdj=0,@flzfbl = 0
    
	if (select config from YY_CONFIG (nolock) where id='5055')='0'
	begin
		if @shbz=1
	  		select @zfdj=0, @zfje=0, @yhdj=0, @yhje=0, @flzfje=0,@flzfdj=0
					,@zfbl = 0, @yhbl = 0,@flzfbl = 0 --���ͨ����Ϊ�ɱ�����
	end
	else begin
		if @shbz=2
	  		select @zfdj=@ypdj, @zfje=@zje, @yhdj=0, @yhje=0, @flzfje=0,@flzfdj=0 	
            ,@zfbl = 1, @yhbl = 0,@flzfbl = 0 --��˲�ͨ����Ϊ���ɱ�����
	end

	--W20050119 ,����Ӥ��ʱ������������Ը����
	if @yexh > 0 
		select @flzfje = 0,@flzfbl = 0,@flzfbz=0
    if @cq_fjxm=1
        select @zfbl=1
    --add by kongwei 
	if @qzzfbz = 1    --ǿ���Է�  
    select @yhbl=0, @zfbl=1  

	if @sxjg<@ypdj and @sxjg>0 and @cq_fjxm=0
	begin
		select @zfdj=(@ypdj-@sxjg)+@sxjg*@zfbl, @yhdj=@sxjg*(1-@zfbl)*@yhbl 
		if (select rtrim(ltrim(config)) from YY_CONFIG (nolock) where id='5266')='0'
	        select @flzfdj=@sxjg*@flzfbl*@flzfbz 
		else
			select @flzfdj=(@ypdj-@sxjg)*@flzfbz	
	end
	else
		select @zfdj=@ypdj*@zfbl, @yhdj=@ypdj*(1-@zfbl)*@yhbl, @flzfdj=@ypdj*@flzfbl

	--W20071125 �ɽ������۴���,�ڼ�����ǰȷ������
	if (exists(select ybdm from YY_YBFLK (nolock) where ybdm = @ybdm and lcyhbz = 1)) and (@lcjsdj <> 0)
	begin
		if @sxjg<@lcjsdj and @sxjg>0
			select @zfdj=(@lcjsdj-@sxjg)+@sxjg*@zfbl, 
					@yhdj=@sxjg*(1-@zfbl)*@yhbl, 
					@flzfdj=@sxjg*@flzfbl
					--@flzfdj=(@ypdj-@sxjg)+@sxjg*@flzfbl
		else
			select @zfdj=@lcjsdj*@zfbl, 
					@yhdj=@lcjsdj*(1-@zfbl)*@yhbl,
					@flzfdj=@lcjsdj*@flzfbl
		select @yyhdj =@yhdj
		select @yhdj = @yhdj + @ypdj - isnull(@lcjsdj,0)
		select @lcyhje = round(@ypdj*@zxsl/@ykxs, 2) - round(@lcjsdj*@zxsl/@ykxs, 2)
	end
	--*******�Ժ�����Ϊ���� �͵��ۡ�������ķֽ�㣬������Ϊ������������ʹ�ã�������Ϊ�漰������	
	--add by chenwei 2003.11.7 �˷�ʱ��ԭ�Էѵ��ۼ���ҽ�������Ը����
	if @tfbz = 2 --��2=�˷� start
	begin
		select @zfdj=@old_zfdj
		select @flzfje = flzfje, @qqrq=zxrq,@yhdj=yhdj,@lcjsdj = isnull(lcjsdj,0)  FROM ZY_BRFYMXK (nolock) where syxh = @syxh and qqxh = @qqxh 
		       and fylb in(0,1,8,10) and idm = @idm  
		if @flzfje is not null
		begin
			if  @flzfje <> 0
				select @flzfbz = 1
			else
				select @flzfbz = 0		
		end
	end --��2=�˷� end
		
	if (exists(select ybdm from YY_YBFLK (nolock) where ybdm = @ybdm and lcyhbz = 1)) and (@lcjsdj <> 0)
	begin
		select @yhje=case when @lcjsdj = 0 then round(@yhdj*@zxsl/@ykxs,2) else 
						round(@ypdj*@zxsl/@ykxs,2)- round(@lcjsdj*@zxsl/@ykxs,2)+round(@yyhdj*@zxsl/@ykxs,2) 
					end
	end
	else begin
		select @yhje=round(@yhdj*@zxsl/@ykxs,2) 
	end
					
	select @zje=round(@ypdj*@zxsl/@ykxs, 2)	
	select @srce =ROUND(@ypdj*@zxsl/@ykxs - @zje,4)
    --ֻֻ������ҩ����ϸ�������������������ϸ������
	if  (@flzfje_is3 = '��') and (@flzfdj <> 0)   
		select @flzfje=round(@flzfdj*@zxsl/@ykxs,3)
			,@zfje=round(@zfdj*@zxsl/@ykxs, 3)
	else 
		select @flzfje=round(@flzfdj*@zxsl/@ykxs,2)
			,@zfje=round(@zfdj*@zxsl/@ykxs, 2)	

	if @fylb=9  or @yexh>0
		select @yeje=@zje
	else
		select @yeje=0
   
    if (@zje=@zfje) --AND (@pzlx='8')	-- add by gzy at 20060809
		select @flzfdj=0 ,@flzfbz=0,@flzfbl = 0, @flzfje=0

	--add by pin 41277 2009-8-4 begin
	if exists (select 1 from YY_CONFIG(nolock) where id='9052' and isnull(config,'��')='��') --���Ƿ�ʹ�ÿ��������뵥 Ϊ�� start
	begin
		if @qqxh is not null
		begin
			if exists (select 1 from BQ_YJQQK a(nolock),YY_SFXXMK b(nolock) where a.xmdm=b.id and isnull(a.lcxmdm,'0')='0' 
				and  a.kybz=1 and b.iskybz=1 and a.syxh=@syxh and a.xh=@qqxh)
			begin
				select @yhdj=@ypdj,@yhje=@zje,@zfdj=0,@zfje=0,@flzfje=0
			end
			else if exists (select 1 from BQ_YJQQK a(nolock),YY_SFXXMK b(nolock),YY_LCSFXMK e(nolock),YY_LCSFXMDYK f(nolock) 
				where isnull(a.lcxmdm,'0')<>'0' and a.lcxmdm=e.id and e.id=f.lcxmdm and f.xmdm=b.id  and  a.kybz=1 and b.iskybz=1 and a.syxh=@syxh and a.xh=@qqxh )
				and not exists (select 1 from BQ_YJQQK a(nolock),YY_SFXXMK b(nolock),YY_LCSFXMK e(nolock),YY_LCSFXMDYK f(nolock) 
				where isnull(a.lcxmdm,'0')<>'0' and a.lcxmdm=e.id and e.id=f.lcxmdm and f.xmdm=b.id  and  a.kybz=1 and isnull(b.iskybz,0)=0 and a.syxh=@syxh and a.xh=@qqxh )
			begin
				select @yhdj=@ypdj,@yhje=@zje,@zfdj=0,@zfje=0,@flzfje=0
			end
		end
		else begin
			if exists (select 1 from VW_LSYZK a(nolock),VW_ZYSQD b(nolock),YY_SFXXMK c(nolock) where a.sqdxh=b.xh and 
				a.ypdm=c.id and isnull(a.lcxmdm,'0')='0' and b.kybz=1 and c.iskybz=1 and a.syxh=@syxh and a.xh=@yzxh)
			begin
				select @yhdj=@ypdj,@yhje=@zje,@zfdj=0,@zfje=0,@flzfje=0
			end
			else if exists (select 1 from VW_LSYZK a(nolock),YY_SFXXMK b(nolock),VW_ZYSQD c(nolock),YY_LCSFXMK e(nolock),YY_LCSFXMDYK f(nolock) 
				where isnull(a.lcxmdm,'0')<>'0' and a.sqdxh=c.xh and a.lcxmdm=e.id and e.id=f.lcxmdm and f.xmdm=b.id  and  c.kybz=1 and b.iskybz=1 and a.syxh=@syxh and a.xh=@yzxh )
				and not exists (select 1 from VW_LSYZK a(nolock),YY_SFXXMK b(nolock),VW_ZYSQD c(nolock),YY_LCSFXMK e(nolock),YY_LCSFXMDYK f(nolock) 
				where isnull(a.lcxmdm,'0')<>'0' and a.sqdxh=c.xh and a.lcxmdm=e.id and e.id=f.lcxmdm and f.xmdm=b.id  and  c.kybz=1 and isnull(b.iskybz,0)=0 and a.syxh=@syxh and a.xh=@yzxh )
			begin
				select @yhdj=@ypdj,@yhje=@zje,@zfdj=0,@zfje=0,@flzfje=0
			end
		end
	end--end --���Ƿ�ʹ�ÿ��������뵥 Ϊ�� end

	--�ɱ�����
	if @gbbz=1 and ((@zfje-@flzfje>0 and @zfje >0 ) or (@zfje-@flzfje<0 and @zfje <0 )) --���ɱ����� start
	begin
        
        select @gbfwwje=@zfje-@flzfje

        if @tfbz = 2 and @zxsl<0 --if @tfbz = 2 and @zxsl<0 start
        begin
            select @gbzfbl_tf=gbtsbl 
            from ZY_BRFYMXK (nolock)
            where syxh = @syxh and qqxh = @qqxh and idm = @idm and ypsl>0
			if @@error<>0
			begin
			    select @errmsg="Fȡ�ɱ���Χ�����ʱ����"
				select "F","ȡ�ɱ���Χ�����ʱ����"
				return
			end
            if @gbzfbl_tf is not null
            begin
				select @gbfwwje=(@zfje-@flzfje)*@gbzfbl_tf,
						@gbtsbz=1,
						@gbtsbl=@gbzfbl_tf
				if @@error<>0
				begin
					select @errmsg="Fȡ�ɱ���Χ�����ʱ����1��"
					select "F","ȡ�ɱ���Χ�����ʱ����1��"
					return
				end
            end

        end --if @tfbz = 2 and @zxsl<0 end
        else
        begin -- if not (@tfbz = 2 and @zxsl<0) start
		
			if exists(select 1 from YY_GBTSSFXMK b (nolock)	where b.idm=@idm and b.xmdm=@ypdm and b.ybdm=@ybdm)
			begin
				select @gbfwwje=(@zfje-@flzfje)*b.zfbl,
						@gbtsbz=1,
						@gbtsbl=b.zfbl
					from YY_GBTSSFXMK b (nolock)
					where b.idm=@idm and b.xmdm=@ypdm and b.ybdm=@ybdm
				if @@error<>0
				begin
					select @errmsg="F����ɱ���Χ�����ʱ����"
					select "F","����ɱ���Χ�����ʱ����"
					return
				end
			end
			if exists(select 1	from YY_GBBRTSSFXMK b (nolock) where b.idm=@idm and b.xmdm=@ypdm and b.xtlb=1 and b.brxh=@syxh)
			begin
				select @gbfwwje=(@zfje-@flzfje)*b.zfbl,
						@gbtsbz=1,
						@gbtsbl=b.zfbl
					from YY_GBBRTSSFXMK b (nolock)
					where b.idm=@idm and b.xmdm=@ypdm and b.xtlb=1 and b.brxh=@syxh
				if @@error<>0
				begin
				    select @errmsg="F����ɱ���Χ�����ʱ����1��"
					select "F","����ɱ���Χ�����ʱ����1��"
					return
				end
			end
        end -- if not (@tfbz = 2 and @zxsl<0) end

		select @gbfwje=@zfje-@flzfje-@gbfwwje

		if @gbtsbz=1
			select @gbtsfwje=@gbfwje, @gbtsfwwje=@gbfwwje  
	end --���ɱ����� end
    if @tfbz=2  --��@tfbz 2=�˷� start--�˷ѷ��ö�����ҩ������ԭ���������ı���ȡ�����⵱�в����仯�������������,@zxsl����ʱ��Ϊ����  add by xwm 2011-07-29
    begin
        declare @flzfjexsw int
        if (@flzfje_is3 = '��') and (@flzfdj <> 0)
            select @flzfjexsw=3
        else
            select @flzfjexsw=2
        
		select @srce = -srce,@sfxdzf=ISNULL(sfxdzf,0) from ZY_BRFYMXK_FZ(nolock) where syxh=@syxh and xh=@tfxh 
		if exists(select 1 from ZY_BRFYMXK a(nolock) where a.syxh=@syxh and a.tfxh=@tfxh)
		begin
			select @srce = 0.0,@fyce=0.0
		end
		else
		begin
			select @fyce=round(zje-round(zje/ypsl,2)*ypsl,2) from ZY_BRFYMXK(nolock) where syxh=@syxh and xh=@tfxh and jlzt=0
		end
                  
        select @zje=round(round(zje/ypsl,2)*@zxsl,2)-@fyce,
            --@srce =round( ypdj*@zxsl/ykxs -round(zje*@zxsl/ypsl,2),4),
			@zfje=round(zfje*@zxsl/ypsl,@flzfjexsw),--add by guo 20140114 for bug190727
			@yhje=round(yhje*@zxsl/ypsl,2),
			@flzfje=round(flzfje*@zxsl/ypsl,@flzfjexsw),
			@dxmdm=dxmdm,
			@yeje=(case when @fylb=9 or @yexh>0 then round(zje*@zxsl/ypsl,2) else 0 end),
			@gbtsbz =gbtsbz,
			@gbfwje =round(gbfwje*@zxsl/ypsl,2),
			@gbfwwje =round(gbfwwje*@zxsl/ypsl,2)
			,@lcjsdj =isnull(lcjsdj,0)
			,@lcyhje = case when lcjsdj <> 0 then (round(zje*@zxsl/ypsl,2) - round(lcjsdj*@zxsl/ypsl, 2)) else 0 end 
        from ZY_BRFYMXK(nolock)
		where syxh=@syxh and xh=@tfxh and jlzt=0

		--select @srce = -srce,@sfxdzf=ISNULL(sfxdzf,0) from ZY_BRFYMXK_FZ(nolock) where syxh=@syxh and xh=@tfxh 
		if @gbtsbz=1
			select @gbtsfwje=@gbfwje, @gbtsfwwje=@gbfwwje
    end  --��@tfbz 2=�˷� end
end --������0=���� or 2=�˷� end ������

--modify by mly 2005-04-12 ����ȷ�Ͽ��ҵĴ�������д�������ô������,û�д�������ò���Ա���ڿ���
if @qrksdm <> ''  
	select @czyks = @qrksdm	
else
begin
	select @czyks =isnull(ks_id,'')  from czryk(nolock) where id =  @czyh and charindex('00',gwdm)<=0	
    if @czyks=''
	select @czyks=@ksdm
end

if @tfbz=0 --add zengtao 20121110
begin
	select @yhdj= @ypdj-(@ypdj-@yhdj)*@ssbl_qf 
	select @yhje= round(@yhdj*@zxsl/@ykxs,2) 
end 

-- swx 2015-1-20 for 12179
if exists(select 'x' from YY_CONFIG where id ='6881' and config='��')
	and exists(select 'x' from YY_CONFIG where id ='6882' and charindex(@dxmdm,config)>0)
	and (@tfbz=0)
begin
	select @yhdj= @ypdj*(1-isnull(@sfbl,1))
	select @yhje= round(@yhdj*@zxsl/@ykxs,2) 
end

update ZY_BRJSK set zje=isnull(zje,0)+isnull(@zje,0), 
	zfyje=isnull(zfyje,0)+isnull(@zfje,0), 
	yhje=isnull(yhje,0)+isnull(@yhje,0), 
	@jsxh=xh, 
	flzfje=isnull(flzfje,0)+isnull(@flzfje,0),
	lcyhje = isnull(lcyhje,0)+isnull(@lcyhje,0)
where syxh=@syxh and jszt=0 and ybjszt=0 and jlzt=0
if @@error<>0 or @@rowcount=0
begin
	select @errmsg='F���˵�ǰ�����¼�����ã�����ϵͳ����Ա��ϵ��'
	return	
end
if not exists(select 1 from ZY_BRJSK_FZ where jsxh =@jsxh and syxh =@syxh )
begin
	insert into  ZY_BRJSK_FZ(jsxh, syxh, patid, srce)
	select @jsxh ,@syxh,patid ,isnull(@srce,0)
	from ZY_BRSYK (nolock) where syxh =@syxh
	if @@error<>0 or @@rowcount=0
	begin
		select @errmsg='F����ȷ�ѳ���'
		return	
	end	
end
else
begin
	update  ZY_BRJSK_FZ set  srce  = isnull(srce ,0) + isnull(@srce,0) 
	where jsxh=@jsxh and syxh =@syxh
	if @@error<>0 or @@rowcount=0
	begin
		select @errmsg='F����ȷ�ѳ���'
		return	
	end	
end


if exists(select 1 from ZY_BRJSMXK (nolock)where jsxh=@jsxh and dxmdm=@dxmdm)
begin
	update ZY_BRJSMXK set xmje=isnull(xmje,0)+isnull(@zje,0),
		zfje=isnull(zfje,0)+isnull(@zfje,0),
		yhje=isnull(yhje,0)+isnull(@yhje,0),
		yeje=isnull(yeje,0)+isnull(@yeje,0),
		flzfje=isnull(flzfje,0)+isnull(@flzfje,0),
		gbfwje=isnull(gbfwje,0)+isnull(@gbfwje,0),
		gbfwwje=isnull(gbfwwje,0)+isnull(@gbfwwje,0),
		gbtsfwje=isnull(gbtsfwje,0)+isnull(@gbtsfwje,0),
		gbtsfwwje=isnull(gbtsfwwje,0)+isnull(@gbtsfwwje,0),
		lcyhje = isnull(lcyhje,0) +isnull(@lcyhje,0)		
	where jsxh=@jsxh and dxmdm=@dxmdm
	if @@error<>0 or @@rowcount=0
	begin
		select @errmsg='F����ȷ�ѳ���'
		return	
	end	
	if not exists(select 1 from ZY_BRJSMXK_FZ where jsxh =@jsxh and dxmdm =@dxmdm)
	begin
		insert into  ZY_BRJSMXK_FZ(jsxh, dxmdm,srce,fpxmdm)
		select @jsxh, @dxmdm, isnull(@srce,0), zyfp_id
		from YY_SFDXMK (nolock) 
		where id=@dxmdm
		if @@error<>0 or @@rowcount=0
		begin
			select @errmsg='F����ȷ�ѳ���'
			return	
		end	
	end
	else
	begin
		update  ZY_BRJSMXK_FZ set  srce  = isnull(srce ,0) + isnull(@srce,0) 
		where jsxh=@jsxh and dxmdm=@dxmdm
		if @@error<>0 or @@rowcount=0
		begin
			select @errmsg='F����ȷ�ѳ���'
			return	
		end	
	end
end
else begin
	insert into ZY_BRJSMXK(jsxh, dxmdm, dxmmc, fpxmdm, fpxmmc, xmje, zfje, yhje, yeje, memo, flzfje,
			gbfwje, gbfwwje, gbtsfwje, gbtsfwwje,lcyhje)
	select @jsxh, @dxmdm, name, zyfp_id, zyfp_mc, isnull(@zje,0), isnull(@zfje,0), isnull(@yhje,0), isnull(@yeje,0), null, isnull(@flzfje,0),
			isnull(@gbfwje,0), isnull(@gbfwwje,0), isnull(@gbtsfwje,0), isnull(@gbtsfwwje,0),isnull(@lcyhje,0)
	from YY_SFDXMK (nolock) 
	where id=@dxmdm
	if @@error<>0 or @@rowcount=0
	begin
		select @errmsg='F����Ŀ���ò���ȷ��ȷ�ѳ���'
		return	
	end
	insert into  ZY_BRJSMXK_FZ(jsxh, dxmdm,srce,fpxmdm)
	select @jsxh, @dxmdm, isnull(@srce,0), zyfp_id
	from YY_SFDXMK (nolock) 
	where id=@dxmdm
	if @@error<>0 or @@rowcount=0
	begin
		select @errmsg='F����Ŀ���ò���ȷ��ȷ�ѳ���'
		return	
	end	
end

if @tfbz=1 --������1=���� start ������ 
begin
	--add by shiyong 2012-11-12�ж��Ƿ����˷�
	declare @cfbz varchar(1)
	if @zxsl < 0
		select @cfbz = '1'
	else
		select @cfbz = '0'

	insert into ZY_BRFYMXK(syxh, zxrq, czyh, yzxh, qqxh, qqrq, bqdm, ksdm, ysdm, idm,
		ypdm, ypmc, dxmdm, zxks, ypgg, ypdw, dwxs, ykxs, ypsl, ypdj, zfdj, yhdj, zje, zfje,
		yhje, fylb, yexh, jsxh, jszt, jlzt, memo, cwdm, flzfje, ybshbz, ybspbh, qrks,zrysdm,zzysdm,lcxmdm,lcxmmc	--agg 2004.09.10 ����lcxmdm,lcxmmc
		,txbl, ysks,czybq, tdxmxh, gbfwje, gbfwwje, gbtsbz, gbtsbl, fzrysdm, ylxzdm,qqmxxh,dydm,lcjsdj,xzks_id,tfxh,
		zfyy,jzks,gdzxbz,sffjxm,sbid,jzys,yzlb,txbz,fyfzxh,jsks,bar_code) --add "dydm" 20070119 --add by shiyong 2010-08-06 yzlb
	select syxh,case isnull(@jfsj,'') when '' then (case when @config9177='��' then @zxrq_xg else @now end) else @jfsj end, @czyh, yzxh, qqxh, qqrq, bqdm, ksdm, ysdm, idm,
		ypdm, ypmc, dxmdm, zxks, ypgg, ypdw, dwxs, ykxs,case @cfbz when '0' then -ypsl else @zxsl end, ypdj, zfdj, yhdj, case @cfbz when '0' then -zje else Convert(decimal(9,2),@zxsl * ypdj/ykxs) end, -zfje, 
		-yhje, fylb, yexh, @jsxh, 0, 2, memo, cwdm, -flzfje, ybshbz, ybspbh, qrks,zrysdm,zzysdm,lcxmdm,lcxmmc  --agg 2004.09.10 ����lcxmdm,lcxmmc
		,txbl, ysks,@czybq_temp, tdxmxh, -gbfwje, -gbfwwje, gbtsbz, gbtsbl ,fzrysdm ,ylxzdm,qqmxxh,dydm,lcjsdj,xzks_id,@tfxh,zfyy,jzks,@gdzxbz, --edit by hqx @ysks_temp 2 ysks for 10970
		@cq_fjxm,sbid,jzys,yzlb,txbz,fyfzxh,jsks,@barcodehrp  --mit,2oo4-12-21,����txbl     -- Add Koaka, 2005-09-13	����tdxmxh --add by shiyong 2010-08-06 yzlb
	from ZY_BRFYMXK (nolock)
	where syxh=@syxh and xh=@tfxh
	if @@error<>0 or @@rowcount=0
	begin
		select @errmsg='F����ȷ��ʱ����'
		return
	end

	select @xh_temp =SCOPE_IDENTITY()

	--add by hhy 2014.04.17 for 206094 �߼���������
	if @isuseylz = '��' and @config6809 = '��'
	begin
		insert into ZY_BRFYMXK_FZ
			( xh ,syxh , ljbqdm,sfbl,tcwbz,jzyy,lcxmdj,srce,ybsl,yzxrq,szbdj,sfxdzf,hrptxm)
		select a.xh,a.syxh,b.ljbqdm,@sfbl,@tcwbz,@jzyy,@lcxmdj,isnull(@srce,0)
			,case when @config6A33='5' then isnull(c.ybsl,0) else null END,@yzxrq,@szbdj,@sfxdzf,@barcodehrp
		from ZY_BRFYMXK a(nolock) inner join ZY_BRSYK b(nolock)on a.syxh = b.syxh 
			left join YY_LCSFXMDYK c(nolock) on c.lcxmdm=@lcxmdm and @lcxmdm<>'0' and a.ypdm=c.xmdm and a.lcxmdm=c.lcxmdm
		where a.xh = @xh_temp 
		if @@ERROR <> 0 or @@ROWCOUNT = 0
		begin
			select @errmsg='F����ȷ��ʱ����'
			return
		end
	end
    else
	begin
		insert into ZY_BRFYMXK_FZ
			( xh ,syxh , ljbqdm,sfbl,tcwbz,jzyy,lcxmdj,srce,ybsl,yzxrq,szbdj,sfxdzf,hrptxm)
		select a.xh,a.syxh,null,@sfbl,@tcwbz,@jzyy,@lcxmdj,isnull(@srce,0)
			,case when @config6A33='5' then isnull(c.ybsl,0) else null END,@yzxrq,@szbdj,@sfxdzf,@barcodehrp
		from ZY_BRFYMXK a(nolock)
			left join YY_LCSFXMDYK c(nolock) on c.lcxmdm=@lcxmdm and @lcxmdm<>'0' and a.ypdm=c.xmdm and a.lcxmdm=c.lcxmdm
		where a.xh = @xh_temp 
		if @@ERROR <> 0 or @@ROWCOUNT = 0
		begin
			select @errmsg='F����ȷ��ʱ����'
			return
		end
	end
	
    if (isnull(@wzqqxh,0)<>0)
    begin 
		update YY_ZY_CLJLK set jlzt=3
		where fyxh=@tfxh
	end
	--yjf 2013-06-04 ȷ��ʱ�Զ��۳����ʲ��Ͽ��
	IF EXISTS(SELECT 1 FROM YY_CONFIG(nolock) WHERE id='A234' AND config<>'��')
	begin
		IF EXISTS(SELECT 1 FROM YY_CONFIG(nolock) WHERE id='A219' AND config='��')
			and ((isnull(@wzqqxh,0)<>0) or EXISTS(SELECT 1 FROM YY_CONFIG(nolock) WHERE id='A262' AND config<>'��')  )
		BEGIN
			if (@kcdylb=0) or (@kcdylb=1 and (LEFT(@tm,2) in ('GZ','DZ')))
			begin     
				exec usp_wz_hisxhpcl @xh_temp,1,@errmsg output,@pcxh=@pcxh,@tm=@tm
				if @errmsg like 'F%' or @@error<>0
				begin
					--select @errmsg;
					return
				END
			end
		END
	end      
	--yjf 2013-06-04 ȷ��ʱ�Զ��۳����ʲ��Ͽ��
    	
    if @zxmdm=-1
    begin
         select @zxmdm=@xh_temp
    end
    --add by shiyong 2012-11-12 �����е��˷Ѽ�¼ȫ����Ϊ״̬2
	if @cfbz='0'
	begin
		update ZY_BRFYMXK set jlzt = 2 WHERE syxh=@syxh AND tfxh = @tfxh
    end
    update ZY_BRFYMXK set prnxh=@zxmdm where xh=@xh_temp
	if @@error<>0 or @@rowcount=0
	begin
		select @errmsg='F����ȷ��ʱ����'
		return
	end
    	
	if exists(select 1 from ZY_BRFYMXK (nolock) where syxh=@syxh and xh=@xh_temp and idm=0 )
	begin
	   ---add by cyh ����ע��֤��  ����:118862
	   update a  set a.yzczh=c.item_previousidl
	   from ZY_BRFYMXK  a,YY_SFXXMK b,YY_YBXMK c
	   where  a.ypdm=b.id and b.sybz=1 and  a.syxh=@syxh and a.xh=@xh_temp  
			  and b.dydm=c.item_code and a.idm=0 and isnull(a.yzczh,'')<>''
		if @@error<>0 
		begin
			select @errmsg='F����ҽ��ע��֤��ʱ����'
			return
		end          
	end
	else begin
	   update a  set a.yzczh=c.previousidl
	   from ZY_BRFYMXK  a,YK_YPCDMLK b,YY_YBYPK c
	   where  a.idm=b.idm and b.tybz=0 and a.syxh=@syxh and a.xh=@xh_temp 
			  and b.dydm=c.mc_code and a.idm>0 and isnull(a.yzczh,'')<>'' 
		if @@error<>0
		begin
			select @errmsg='F����ҽ��ע��֤��ʱ����'
			return
		end         
	end	

end --������1=���� end ������ 
--panlian  2004-03-15 ����������ֻ�����ϱ����� �����ж������ֶ�qrks 
else begin --������0=���� or 2=�˷� start ������ 
    select @xzks_id=(select xzks_id from YY_ZGBMK (nolock)where id=@ysdm) 
	--������Ժҽ����������
	if exists(select 1 from ZY_LCMXYBSPJLK (nolock) where syxh=@syxh and qqxh=@qqxh and sfid=@ypdm and yzlx='1')
	begin
		select @shbz=ybspbz from ZY_LCMXYBSPJLK (nolock) where syxh=@syxh and qqxh=@qqxh and sfid=@ypdm and yzlx='1'	
	end
	
	if @idm=0 
       select @yzczh=b.item_previousidl  from YY_SFXXMK a(nolock),YY_YBXMK b(nolock) where a.id=@ypdm and a.dydm=b.item_code and a.sybz=1
	else
	   select @yzczh=b.previousidl  from YK_YPCDMLK a(nolock),YY_YBYPK b(nolock) where a.idm=@idm and a.dydm=b.mc_code and a.tybz=0
	   
	/* Move To Up */
	if @jfsj is null
	begin
        if  (select config from YY_CONFIG (nolock) where id='6242')='��'   
        begin			
			insert into ZY_BRFYMXK(syxh, zxrq, czyh, yzxh, qqxh, qqrq, bqdm, ksdm, ysdm, idm, 
				ypdm, ypmc, dxmdm, zxks, ypgg, ypdw, dwxs, ykxs, ypsl, ypdj, zfdj, yhdj, zje, zfje, 
				yhje, fylb, yexh, jsxh, jszt, jlzt, memo, cwdm, flzfje, ybshbz, ybspbh,qrks,zzysdm,zrysdm,lcxmdm,lcxmmc --agg 2004.09.10 ����lcxmdm,lcxmmc
				,txbl, ysks,czybq,tdxmxh, gbfwje, gbfwwje, gbtsbz, gbtsbl, fzrysdm, ylxzdm,qqmxxh,dydm,lcjsdj,xzks_id,tfxh,jzks,
				gdzxbz,sffjxm,sbid,jzys,yzlb,txbz,yzczh,fyfzxh,jsks,jzbq,bar_code )
			values(@syxh, case @gdzxbz when 1 then (case when @config9177='��' then @zxrq_xg else @now end) else @qqrq end, @czyh, @yzxh, @qqxh, @qqrq, ISNULL(@tybqdm,@bqdm), ISNULL(@tyksdm,@ksdm), @ysdm, @idm,	-- modify by gzy at 20041208 @bqdm
				@ypdm, @ypmc, @dxmdm, @yfdm, @ypgg, @ypdw, @dwxs, @ykxs, @zxsl, isnull(@ypdj,0), @zfdj, @yhdj, @zje, isnull(@zfje,0), 
				isnull(@yhje,0), @fylb, @yexh, @jsxh, 0, 0, @memo, @cwdm, isnull(@flzfje,0), @shbz, @spbh, @czyks,@zzysdm,@zrysdm,@lcxmdm,@lcxmmc --agg 2004.09.10 ����lcxmdm,lcxmmc
				,@txbl,@ysks_temp,@czybq_temp,@tdxmxh, @gbfwje, @gbfwwje, @gbtsbz, @gbtsbl, @fzrysdm, @ylxzdm,@yjmxxh,@dydm,@lcjsdj,@xzks_id,@tfxh,@jzks_qf,@gdzxbz,@cq_fjxm,
				case when @sbid_qf='' then null else convert(numeric(9,0),@sbid_qf) end,@jzys_qf,@yzlb,@cwtxbz,@yzczh,@fyfzxh,@jsks_qf,@jzbq_qf,@barcodehrp) --add "dydm" 20070119		--mit,2oo4-12-21,����������� -- Add Koaka, 2005-09-13	����tdxmxh
			
		end
		else
		begin
			insert into ZY_BRFYMXK(syxh, zxrq, czyh, yzxh, qqxh, qqrq, bqdm, ksdm, ysdm, idm, 
				ypdm, ypmc, dxmdm, zxks, ypgg, ypdw, dwxs, ykxs, ypsl, ypdj, zfdj, yhdj, zje, zfje, 
				yhje, fylb, yexh, jsxh, jszt, jlzt, memo, cwdm, flzfje, ybshbz, ybspbh,qrks,zzysdm,zrysdm,lcxmdm,lcxmmc --agg 2004.09.10 ����lcxmdm,lcxmmc
				,txbl, ysks,czybq,tdxmxh, gbfwje, gbfwwje, gbtsbz, gbtsbl, fzrysdm, ylxzdm,qqmxxh,dydm,lcjsdj,xzks_id,tfxh,jzks,
				gdzxbz,sffjxm,sbid,jzys,yzlb ,txbz,yzczh,fyfzxh,jsks,jzbq,bar_code) --add "dydm" 20070119 
			values(@syxh, case when @config9177='��' then @zxrq_xg else @now end, @czyh, @yzxh, @qqxh, @qqrq, ISNULL(@tybqdm,@bqdm), ISNULL(@tyksdm,@ksdm), @ysdm, @idm,	-- modify by gzy at 20041208 @bqdm
				@ypdm, @ypmc, @dxmdm, @yfdm, @ypgg, @ypdw, @dwxs, @ykxs, @zxsl, isnull(@ypdj,0), @zfdj, @yhdj, @zje, isnull(@zfje,0), 
				isnull(@yhje,0), @fylb, @yexh, @jsxh, 0, 0, @memo, @cwdm, isnull(@flzfje,0), @shbz, @spbh, @czyks,@zzysdm,@zrysdm,@lcxmdm,@lcxmmc --agg 2004.09.10 ����lcxmdm,lcxmmc
				,@txbl,@ysks_temp,@czybq_temp,@tdxmxh, @gbfwje, @gbfwwje, @gbtsbz, @gbtsbl, @fzrysdm, @ylxzdm,@yjmxxh,@dydm,@lcjsdj,@xzks_id,@tfxh,@jzks_qf,@gdzxbz,@cq_fjxm,
				case when @sbid_qf='' then null else convert(numeric(9,0),@sbid_qf) end,@jzys_qf,@yzlb,@cwtxbz,@yzczh,@fyfzxh,@jsks_qf,@jzbq_qf,@barcodehrp) --add "dydm" 20070119		--mit,2oo4-12-21,����������� -- Add Koaka, 2005-09-13	����tdxmxh
        end
	end
	else
	begin
		insert into ZY_BRFYMXK(syxh, zxrq, czyh, yzxh, qqxh, qqrq, bqdm, ksdm, ysdm, idm, 
			ypdm, ypmc, dxmdm, zxks, ypgg, ypdw, dwxs, ykxs, ypsl, ypdj, zfdj, yhdj, zje, zfje, 
			yhje, fylb, yexh, jsxh, jszt, jlzt, memo, cwdm, flzfje, ybshbz, ybspbh,qrks,zzysdm,zrysdm,lcxmdm,lcxmmc --agg 2004.09.10 ����lcxmdm,lcxmmc
			,txbl,ysks,czybq,tdxmxh, gbfwje, gbfwwje, gbtsbz, gbtsbl, fzrysdm, ylxzdm ,qqmxxh,dydm,lcjsdj,xzks_id,tfxh,jzks,gdzxbz,sffjxm,sbid,jzys,yzlb,txbz,yzczh,fyfzxh,jsks,jzbq,bar_code ,ybzzfbz) --add "dydm" 20070119 add "ybzzfbz"������ҽ��ת�Էѱ�־ lj
		values(@syxh, case @gdzxbz when 1 then (case when @config9177='��' then @zxrq_xg else @now end) else @jfsj end , @czyh, @yzxh, @qqxh, @qqrq, ISNULL(@tybqdm,@bqdm),  ISNULL(@tyksdm,@ksdm), @ysdm, @idm,	-- modify by gzy at 20041208 @bqdm
			@ypdm, @ypmc, @dxmdm, @yfdm, @ypgg, @ypdw, @dwxs, @ykxs, @zxsl, isnull(@ypdj,0), @zfdj, @yhdj, @zje, isnull(@zfje,0), 
			isnull(@yhje,0), @fylb, @yexh, @jsxh, 0, 0, @memo, @cwdm, isnull(@flzfje,0), @shbz, @spbh, @czyks,@zzysdm,@zrysdm,@lcxmdm,@lcxmmc --agg 2004.09.10 ����lcxmdm,lcxmmc
			,@txbl,@ysks_temp,@czybq_temp,@tdxmxh, @gbfwje, @gbfwwje, @gbtsbz, @gbtsbl, @fzrysdm, @ylxzdm ,@yjmxxh,@dydm,@lcjsdj,@xzks_id,@tfxh,@jzks_qf,@gdzxbz,@cq_fjxm,
			case when @sbid_qf='' then null else convert(numeric(9,0),@sbid_qf) end,@jzys_qf,@yzlb,@cwtxbz,@yzczh,@fyfzxh,@jsks_qf,@jzbq_qf,@barcodehrp,case when @shbz='2'then'1' else '0'end) --add "dydm" 20070119		--mit,2oo4-12-21,����������� -- Add Koaka, 2005-09-13	����tdxmxh
	end

	if @@error<>0 or @@rowcount=0
	begin
		select @errmsg='F����ȷ��ʱ����'
		return
	end
    	select @xh_temp =SCOPE_IDENTITY()
    	
	---add by cyh 20151227 for�ɾ�������ҽԺ---����Ҫ�����뵥�е���ϸ��Ŀ�Ƿ���Ա�����¼������������Ҫ����Ӧ�޸�	
	if (select config from YY_CONFIG (nolock) where id='6959')='��'
	BEGIN
		if (select config from YY_CONFIG (nolock) where id='5055')='0'
		begin
		    if exists(select 1 from sysobjects where name='usp_bq_gxybshbz' and type='P')
			begin
				IF isnull(@idm,0)=0 
				BEGIN			  
					 exec usp_bq_gxybshbz @syxh,@yexh,@xh_temp,@lcxmdm,@ypdm    
				END
			end
		END		
	END		
    ---add by cyh 20151227 for�ɾ�������ҽԺ---����Ҫ�����뵥�е���ϸ��Ŀ�Ƿ���Ա�����¼������������Ҫ����Ӧ�޸�

	--80900 �ൺ����ҽԺ��ʿվ����¼���޶���Χ����ѡ��
	if @config6A33='4'
	begin
		if ISNULL(@bxbl,0)<>0
		begin
			insert into ZY_BRFYMXK_SH
				( fyxh,shbz,spbh,bxbl,bxsm,shczyh,shsj)
			select a.xh,ISNULL(@ybshbz,1),'',ISNULL(@bxbl,0),'',a.czyh,a.zxrq
			from ZY_BRFYMXK a(nolock),ZY_BRSYK b(nolock)
			where a.xh = @xh_temp and a.syxh = b.syxh 
			if @@ERROR <> 0 or @@ROWCOUNT = 0
			begin
				select @errmsg='F����ȷ��ʱ����'
				return
			end
		end
	end
	
	--add by hhy 2014.04.17 for 206094 �߼���������
	if @isuseylz = '��' and @config6809 = '��'
	begin
		insert into ZY_BRFYMXK_FZ
			( xh ,syxh , ljbqdm,sfbl,tcwbz,jzyy,lcxmdj,srce,ybsl,yzxrq,szbdj,sfxdzf,hrptxm)
		select a.xh,a.syxh,b.ljbqdm,@sfbl,@tcwbz,@jzyy,@lcxmdj,isnull(@srce,0)
			,case when @config6A33='5' then isnull(c.ybsl,0) else null END,@yzxrq,@szbdj,@sfxdzf,@barcodehrp
		from ZY_BRFYMXK a(nolock) 
		    inner join ZY_BRSYK b(nolock)on a.syxh = b.syxh 
			left join YY_LCSFXMDYK c(nolock) on c.lcxmdm=@lcxmdm and @lcxmdm<>'0' and a.ypdm=c.xmdm and a.lcxmdm=c.lcxmdm
		where a.xh = @xh_temp 
		if @@ERROR <> 0 or @@ROWCOUNT = 0
		begin
			select @errmsg='F����ȷ��ʱ����'
			return
		end
	end
	else
	begin
		insert into ZY_BRFYMXK_FZ
			( xh ,syxh , ljbqdm,sfbl,tcwbz,jzyy,lcxmdj,srce,ybsl,yzxrq,szbdj,sfxdzf,hrptxm)
		select a.xh,a.syxh,null,@sfbl,@tcwbz,@jzyy,@lcxmdj,isnull(@srce,0)
			,case when @config6A33='5' then isnull(c.ybsl,0) else null END,@yzxrq,@szbdj,@sfxdzf,@barcodehrp
		from ZY_BRFYMXK a(nolock)
			left join YY_LCSFXMDYK c(nolock) on c.lcxmdm=@lcxmdm and @lcxmdm<>'0' and a.ypdm=c.xmdm and a.lcxmdm=c.lcxmdm
		where a.xh = @xh_temp
		if @@ERROR <> 0 or @@ROWCOUNT = 0
		begin
			select @errmsg='F����ȷ��ʱ����'
			return
		end
	end
	if (isnull(@wzqqxh,0)<>0) and (@tfbz=0)
	begin
		update YY_ZY_CLJLK set jlzt=2,fyxh=@xh_temp
		where xh = @wzqqxh 
	end
		    	
    --yjf 2013-06-04 ȷ��ʱ�Զ��۳����ʲ��Ͽ��
    IF EXISTS(SELECT 1 FROM YY_CONFIG(nolock) WHERE id='A234' AND config<>'��')
    begin
		IF EXISTS(SELECT 1 FROM YY_CONFIG(nolock) WHERE id='A219' AND config='��') 
			and ((isnull(@wzqqxh,0)<>0) or EXISTS(SELECT 1 FROM YY_CONFIG(nolock) WHERE id='A262' AND config<>'��')  )
		BEGIN 
			if (@kcdylb=0) or (@kcdylb=1 and (LEFT(@tm,2) in ('GZ','DZ')))
			begin 
				exec usp_wz_hisxhpcl @xh_temp,1,@errmsg output,@pcxh=@pcxh,@tm=@tm
				if @errmsg like 'F%' or @@error<>0
				begin
					--select @errmsg;
					return
				END
			end
		END
	end          
    --yjf 2013-06-04 ȷ��ʱ�Զ��۳����ʲ��Ͽ��
        
	if @zxmdm=-1
	begin
		select @zxmdm=@xh_temp
	end

	update ZY_BRFYMXK set prnxh=@zxmdm where xh=@xh_temp
	if @@error<>0 or @@rowcount=0
    begin
    	select @errmsg='F����ȷ��ʱ����'
    	return
    end

	--zwt 2010.05.23 ��@xh_temp������ʱ���б���,����BQ_JLHXXK������ begin
    declare @tablename varchar(32), @sql nvarchar(500), @TOTAL_COUNT int
    select @tablename='##tmp_xh_temp'+@wkdz+@czyh
    if @num = 0
    begin
        exec('if object_id(''tempdb..' + @tablename + ''') is not null      
            begin
                delete from ' + @tablename + '
                insert into ' + @tablename + ' values (' + @xh_temp + ')
            end
            else
            begin
                select ' + @xh_temp + ' as xh_temp into '+ @tablename + '
            end')
    end
    if @num >= 0 and (@cth <> '' or @xxh <> '' or @mrih <> '' or @bch <> '')
    begin
        declare @patid ut_syxh,@fzh ut_xh12
        select @patid = patid from ZY_BRSYK (nolock) where syxh = @syxh
        
        select @sql = 'select @fzh = xh_temp from ' + @tablename
        execute sp_executesql  @sql, N'@fzh ut_xh12 output', @fzh output

        insert into BQ_JLHXXK(syxh, fyxh, fzh, patid, cth, xxh, mrih, bch) 
            values(@syxh, @xh_temp, @fzh, @patid, @cth, @xxh, @mrih, @bch)
	    if @@error<>0 or @@rowcount=0
        begin
    	    select @errmsg='F����ȷ��ʱ����'
    	    return
        end
    end
	--zwt 2010.05.23 ��@xh_temp������ʱ���б���,����BQ_JLHXXK������ end

end --������0=���� or 2=�˷� end ������ 

--Add By : Koala	In : 2005-08-11		For :�Ƿ�ȷ��Ԥ��
if @ispreqf =1 
begin
	select @errmsg="T"+convert(varchar(16),@zje)+','+ convert(varchar(16),@zfje)+','+ convert(varchar(16),@yhje) +',',
	       @fymxxh_out = @xh_temp
	return
end
else
begin
	select @errmsg="T"+convert(varchar(16),@xh_temp) + ',',
	       @fymxxh_out = @xh_temp
	
end

--/*��������ҽ��ybzzfbz����*/

IF(select config from YY_CONFIG where id='CQ36')='3'

BEGIN

	/*��ʱҽ����ȡ�Էѱ�־||ҩƷ*/
	--����ϵͳ���Ƿ���yzxh��BQ_LSYZK����ҽ��xh�ظ�������b.idm>0
	UPDATE a set a.ybzzfbz=b.zfybz from ZY_BRFYMXK a , BQ_LSYZK b  

		where a.yzxh=b.xh and a.syxh=b.syxh  and a.idm>0 and b.idm>0 and a.syxh=@syxh

   /*����ҽ����ȡ�Էѱ�־||ҩƷ*/
   --����ϵͳ���Ƿ���yzxh��BQ_LSYZK����ҽ��xh�ظ�������b.idm>0
	UPDATE a set a.ybzzfbz=b.zfybz from ZY_BRFYMXK a , BQ_CQYZK b 

		where  a.yzxh=b.xh and a.syxh=b.syxh and  a.idm>0 and b.idm>0 and a.syxh=@syxh

END
return


