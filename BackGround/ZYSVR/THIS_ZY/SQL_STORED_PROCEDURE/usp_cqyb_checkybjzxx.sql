if exists(select 1 from sysobjects where name = 'usp_cqyb_checkybjzxx' and xtype='P')
  drop proc usp_cqyb_checkybjzxx
go
CREATE proc usp_cqyb_checkybjzxx
(
	@jsxh				ut_sjh,				--�������
	@syxh				ut_syxh,			--��ҳ���
    @sbkh				varchar(20),		--��ᱣ�Ϻ���
	@xtbz				ut_bz,				--ϵͳ��־0�Һ�1�շ�2סԺ�Ǽ�3סԺ��Ϣ����
    @xzlb				ut_bz,				--�������
    @cblb				ut_bz,				--�α����
    @jzlsh				varchar(20),		--סԺ(������)��
    @zgyllb				varchar(10),		--ҽ�����
    @ksdm				ut_ksdm,			--���Ҵ���
    @ysdm				ut_czyh,			--ҽ������
    @ryrq				varchar(10),		--��Ժ����
    @ryzd				varchar(20),		--��Ժ���
    @cyrq				varchar(10),		--��Ժ����
    @cyzd				varchar(20),		--��Ժ��� 
    @cyyy				varchar(10),		--��Ժԭ��
    @bfzinfo			varchar(200),		--����֢��Ϣ
    @jzzzysj			varchar(10),		--����תסԺʱ��
    @bah				varchar(20),		--������
    @syzh				varchar(20),		--����֤��
    @xsecsrq			varchar(10),		--��������������
    @jmyllb				varchar(10),		--�������������
    @gsgrbh				varchar(10),		--���˸��˱��
    @gsdwbh				varchar(10),		--���˵�λ���
    @zryydm				varchar(14),		--ת��ҽԺ����
    @zxlsh              varchar(20)='',     --������ˮ��
    @zhye               varchar(20)='',     --�˻����
    @yzcyymc            varchar(50)=''		--ԭת��ҽԺ����
    ,@retcode			varchar(20)=''		output --���ش���
    ,@retMsg			varchar(1000)=''	output --������Ϣ    
)
as
/****************************************
[�汾��]4.0.0.0.0
[����ʱ��]2018.11.02
[����]FerryMan
[��Ȩ]Copyright ? 1998-2017���������Ƽ����Źɷ����޹�˾
[����]У��ҽ���Ǽ���Ϣ�����û��У����Բ���Ҫ����洢
[����˵��]
	У��ҽ���Ǽ���Ϣ�����û��У����Բ���Ҫ����洢
[����˵��]
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��]
[�޸ļ�¼]
****************************************/
set nocount on
declare @zgjmbz ut_bz, --ְ�������־        
		 @nl int,  --����        
		 @hisryrq ut_rq16, --��Ժ����        
		 @now  ut_rq16, --��ǰʱ�� ,      
		 @mzrylb varchar(5)  ---������ʶ 
/*��������ҽԺ���ж�		     
if @xtbz in(2,3)
begin    
	select @zgjmbz=cblb ,@nl=convert(int,age),@mzrylb=mzrylb from YY_CQYB_PATINFO (nolock) where sbkh=@sbkh       
	select @hisryrq = ryrq from ZY_BRSYK(nolock) where syxh = @syxh        
	select @now = convert(char(8),getdate(),112) + convert(char(8),getdate(),114)           
	
	--if  @op_mzrylb='112'      
	--begin        
	--	select @retcode='T',@retMsg='�ò������� ����ƶ���� ��������';              
	--end    
	      
	if @zgjmbz = '2' and @nl < 18 and @cyzd = 'O00.901'        
	begin        
		select @retcode='R',@retMsg='�þ���ҽ���α�����Ϊδ��18�����λ���ﲡ�ˣ�';        
		return;        
	end;        
	        
	if exists(select 1 from VW_MZBRJSK (nolock) where cardno = @sbkh and sfrq 
			between @hisryrq and @now and ybjszt = 2 AND jlzt = 0)        
	begin        
		select @retcode='R',@retMsg='�ò���סԺ�ڼ�������ʹ�ù�ҽ������';        
		return;        
	end      
	if exists(select 1 from ZY_BRSYK (nolock) where syxh=@syxh and brlx in (1,4)) and @cyzd not like 'DBZ.%'        
	begin        
		select @retcode='F',@retMsg='�û��߱��ٴ���ʶΪ�����֣��뱾�θ�����ϲ��������ʵ�����';        
		return;        
	end      
	if exists(select 1 from ZY_BRSYK (nolock) where syxh=@syxh and brlx not in (1,4,5)) and @cyzd like 'DBZ.%'        
	begin        
		select @retcode='F',@retMsg='���θ������Ϊ�����ִ��룬���ٴ���ʶ���������ʵ�����';        
		return;        
	end        
	      
	if exists(select 1 from ZY_BRSYK(nolock) WHERE syxh=@syxh and ISNULL(zddm,'')='')       
	begin      
	 update ZY_BRSYK set zddm=@cyzd where syxh=@syxh      
	end      
 end    
 */     
select @retcode='T' ,@retMsg=''       
return
GO
