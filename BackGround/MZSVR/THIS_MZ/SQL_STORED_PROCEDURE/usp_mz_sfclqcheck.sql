Text
CREATE proc usp_mz_sfclqcheck
  @dyy          ut_mc32,--调用源： mzgh:门诊挂号   mzth:门诊退号  mzsf:门诊收费  mztf:门诊退费 
  @patid		ut_xh12,--病人内码(SF_BRXXK.patid)
  @ybdm         ut_ybdm, --病人医保代码（费别）
  @delphi smallint = 0,  --调用标志: 1-前台 0-后台
  @rettype      varchar(1)=''  output, --返回类型 T 成功  F错误  R提示
  @retmsg       varchar(256)='' output, --返回信息
  @tsxxlx       ut_bz=0 output, --提示信息类型 
                               --0：T 成功
                               --1：F 错误
                               --2：R 提示（a）仅提示
                               --3：R 提示（b）【是、否】选择提示，默认是
                               --4：R 提示（c）【是、否】选择提示，默认否
                               --5：R 提示（d）【确定、取消】选择提示，默认确定
                               --6：R 提示（e）【确定、取消】选择提示，默认取消
                               --7：R 提示（f）【是、否、取消】选择提示，默认是
                               --8：R 提示（g）【是、否、取消】选择提示，默认否
                               --9：R 提示（h）【是、否、取消】选择提示，默认取消 
  @hxdmzxkzbz  smallint=1 output, --后续代码执行控制标志   
                               --0：不控制可继续
                               --1：控制不可继续
                               --340: 当@tsxxlx=3或4时 （是可继续，否不可继续） 比如：是否继续取数据？
                               --341: 当@tsxxlx=3或4时 （是不可继续，否可继续） 比如：是否暂停取数据？
                               --560: 当@tsxxlx=5或6时 （确定可继续，取消不可继续） 比如：确定继续取数据？
                               --561: 当@tsxxlx=5或6时 （确定不可继续，取消可继续） 比如：确定暂停取数据？
                               --7890: 当@tsxxlx=7或8或9时  （是可继续，  否不可继续  取消可继续） 比如：是否继续取数据？
                               --7891: 当@tsxxlx=7或8或9时  （是不可继续，否可继续    取消可继续） 比如：是否暂停取数据？   
                               --7892: 当@tsxxlx=7或8或9时  （是可继续，  否不可继续  取消不可继续） 比如： 确定退出？
                               --7893: 当@tsxxlx=7或8或9时  （是不可继续，否可继续    取消不可继续） 比如： 作业执行取消？ 
  @sjh          ut_sjh=''              
as --集417469 2018-09-06 14:59:10 4.0标准版
/*****************************
[版本号]4.0.0.0.0  
[创建时间]  
[作者]  sang  
[版权] Copyright ? 上海卫宁健康科技集团股份有限公司
[描述]  门诊费用处理前检查并做相关限制
[功能说明]
	
[参数说明]  
										
[返回值]  
[结果集、排序]  
[调用的sp]  
[调用实例] 

	
[修改说明]  
******************************/
set nocount on

declare @config1556 varchar(2)
select @config1556=config from YY_CONFIG(nolock) where id='1556'
select @config1556=ltrim(rtrim(ISNULL(@config1556,'')))
if @config1556='' select @config1556='1'

declare @isInhosbz ut_bz --病人正在住院标志 0否 1是

--判断病人是否正在住院
select @isInhosbz=0
if @config1556<>'1'
begin
	if exists(select 1
		from SF_BRXXK a(nolock) 
		where a.patid=@patid and a.ybdm=@ybdm 
		and exists(select 1 from ZY_BRSYK w(nolock) where w.hzxm=a.hzxm and w.cardno=a.cardno and w.sfzh=a.sfzh and w.brzt not in (3,8,9)))
	begin
	   select @isInhosbz=1
	end
end

if(@dyy in ('mzgh','mzth'))--门诊收\退费在usp_sf_sfcl_ex2\bftf单独处理
begin
	if(@config1556='1')
	begin
		if exists(select 1 from SF_BRXXK where patid=@patid and left(cardno,4)='7777' and cardtype=3)
		begin
			select @retmsg='F该卡【'+cardno+'】为体检卡，不能用于门诊业务！',@tsxxlx=1,@hxdmzxkzbz=1
			from SF_BRXXK where patid=@patid and left(cardno,4)='7777' and cardtype=3
			goto errmsg
		end
	end
end

if @dyy='mzgh'
begin
    if @isInhosbz=1
    begin
		if @config1556='2'
		begin
		  select @retmsg='R此患者正在住院，是否继续挂号',@tsxxlx=3,@hxdmzxkzbz=340 --（默认是,是可继续，否不可继续）
		  goto warning 
		end
		if @config1556='3'
		begin
		  select @retmsg='R此患者正在住院，是否继续挂号',@tsxxlx=4,@hxdmzxkzbz=340 --（默认否,是可继续，否不可继续）
		  goto warning 
		end
		if @config1556='4'
		begin
		  select @retmsg='F此患者正在住院，不能进行医保挂号',@tsxxlx=1,@hxdmzxkzbz=1 
		  goto errmsg 
		end
	end
end


if @dyy='mzth'
begin
  if @isInhosbz=1
  begin
    if @config1556='2'
	begin
	  select @retmsg='R此患者正在住院，是否继续退号',@tsxxlx=3,@hxdmzxkzbz=340 --（默认是,是可继续，否不可继续）
	  goto warning 
	end
	if @config1556='3'
	begin
	  select @retmsg='R此患者正在住院，是否继续退号',@tsxxlx=4,@hxdmzxkzbz=340 --（默认否,是可继续，否不可继续）
	  goto warning 
	end
	if @config1556='4'
	begin
	  select @retmsg='F此患者正在住院，不能进行医保退号',@tsxxlx=1,@hxdmzxkzbz=1 
	  goto errmsg 
	end
  end
end

if @dyy='mzsf'
begin
  if @isInhosbz=1
  begin
    if @config1556='2'
	begin
	  select @retmsg='R此患者正在住院，是否继续收费',@tsxxlx=3,@hxdmzxkzbz=340 --（默认是,是可继续，否不可继续）
	  goto warning 
	end
	if @config1556='3'
	begin
	  select @retmsg='R此患者正在住院，是否继续收费',@tsxxlx=4,@hxdmzxkzbz=340 --（默认否,是可继续，否不可继续）
	  goto warning 
	end
	if @config1556='4'
	begin
	  select @retmsg='F此患者正在住院，不能进行医保收费',@tsxxlx=1,@hxdmzxkzbz=1 
	  goto errmsg 
	end
  end
end

if @dyy='mztf'
begin
  if @isInhosbz=1
  begin
    if @config1556='2'
	begin
	  select @retmsg='R此患者正在住院，是否继续退费',@tsxxlx=3,@hxdmzxkzbz=340 --（默认是,是可继续，否不可继续）
	  goto warning 
	end
	if @config1556='3'
	begin
	  select @retmsg='R此患者正在住院，是否继续退费',@tsxxlx=4,@hxdmzxkzbz=340 --（默认否,是可继续，否不可继续）
	  goto warning 
	end
	if @config1556='4'
	begin
	  select @retmsg='F此患者正在住院，不能进行医保退费',@tsxxlx=1,@hxdmzxkzbz=1 
	  goto errmsg 
	end
  end
end

select @retmsg='T',@tsxxlx=0,@hxdmzxkzbz=0
goto successmsg

--=============返回信息处理==================
errmsg:
if @delphi=1 
  select 'F' Rettype,substring(isnull(@retmsg,''),2,255) Retmsg,1 Tsxxlx,1 hxdmzxkzbz --控制不可继续
return 

warning:
if @delphi=1 
  select 'R' Rettype,substring(isnull(@retmsg,''),2,255) Retmsg,@tsxxlx Tsxxlx,@hxdmzxkzbz hxdmzxkzbz
return 

successmsg:
if @delphi=1 
  select 'T' Rettype,substring(isnull(@retmsg,''),2,255) Retmsg,0 Tsxxlx,0 hxdmzxkzbz --不控制可继续
return 




