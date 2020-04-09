if exists(select 1 from sysobjects where name = 'usp_cqyb_checkybjzxx' and xtype='P')
  drop proc usp_cqyb_checkybjzxx
go
CREATE proc usp_cqyb_checkybjzxx
(
	@jsxh				ut_sjh,				--结算序号
	@syxh				ut_syxh,			--首页序号
    @sbkh				varchar(20),		--社会保障号码
	@xtbz				ut_bz,				--系统标志0挂号1收费2住院登记3住院信息更新
    @xzlb				ut_bz,				--险种类别
    @cblb				ut_bz,				--参保类别
    @jzlsh				varchar(20),		--住院(或门诊)号
    @zgyllb				varchar(10),		--医疗类别
    @ksdm				ut_ksdm,			--科室代码
    @ysdm				ut_czyh,			--医生代码
    @ryrq				varchar(10),		--入院日期
    @ryzd				varchar(20),		--入院诊断
    @cyrq				varchar(10),		--出院日期
    @cyzd				varchar(20),		--出院诊断 
    @cyyy				varchar(10),		--出院原因
    @bfzinfo			varchar(200),		--并发症信息
    @jzzzysj			varchar(10),		--急诊转住院时间
    @bah				varchar(20),		--病案号
    @syzh				varchar(20),		--生育证号
    @xsecsrq			varchar(10),		--新生儿出生日期
    @jmyllb				varchar(10),		--居民特殊就诊标记
    @gsgrbh				varchar(10),		--工伤个人编号
    @gsdwbh				varchar(10),		--工伤单位编号
    @zryydm				varchar(14),		--转入医院代码
    @zxlsh              varchar(20)='',     --交易流水号
    @zhye               varchar(20)='',     --账户余额
    @yzcyymc            varchar(50)=''		--原转出医院名称
    ,@retcode			varchar(20)=''		output --返回代码
    ,@retMsg			varchar(1000)=''	output --返回消息    
)
as
/****************************************
[版本号]4.0.0.0.0
[创建时间]2018.11.02
[作者]FerryMan
[版权]Copyright ? 1998-2017卫宁健康科技集团股份有限公司
[描述]校验医保登记信息，如果没有校验可以不需要这个存储
[功能说明]
	校验医保登记信息，如果没有校验可以不需要这个存储
[参数说明]
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]
[修改记录]
****************************************/
set nocount on
declare @zgjmbz ut_bz, --职工居民标志        
		 @nl int,  --年龄        
		 @hisryrq ut_rq16, --入院日期        
		 @now  ut_rq16, --当前时间 ,      
		 @mzrylb varchar(5)  ---民政标识 
/*开州人民医院的判断		     
if @xtbz in(2,3)
begin    
	select @zgjmbz=cblb ,@nl=convert(int,age),@mzrylb=mzrylb from YY_CQYB_PATINFO (nolock) where sbkh=@sbkh       
	select @hisryrq = ryrq from ZY_BRSYK(nolock) where syxh = @syxh        
	select @now = convert(char(8),getdate(),112) + convert(char(8),getdate(),114)           
	
	--if  @op_mzrylb='112'      
	--begin        
	--	select @retcode='T',@retMsg='该病人属于 建卡贫困户 民政对象！';              
	--end    
	      
	if @zgjmbz = '2' and @nl < 18 and @cyzd = 'O00.901'        
	begin        
		select @retcode='R',@retMsg='该居民医保参保病人为未满18岁的异位妊娠病人！';        
		return;        
	end;        
	        
	if exists(select 1 from VW_MZBRJSK (nolock) where cardno = @sbkh and sfrq 
			between @hisryrq and @now and ybjszt = 2 AND jlzt = 0)        
	begin        
		select @retcode='R',@retMsg='该病人住院期间在门诊使用过医保卡！';        
		return;        
	end      
	if exists(select 1 from ZY_BRSYK (nolock) where syxh=@syxh and brlx in (1,4)) and @cyzd not like 'DBZ.%'        
	begin        
		select @retcode='F',@retMsg='该患者被临床标识为单病种，与本次更新诊断不符！请核实后办理。';        
		return;        
	end      
	if exists(select 1 from ZY_BRSYK (nolock) where syxh=@syxh and brlx not in (1,4,5)) and @cyzd like 'DBZ.%'        
	begin        
		select @retcode='F',@retMsg='本次更新诊断为单病种代码，与临床标识不符！请核实后办理。';        
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
