if exists(select 1 from sysobjects where name = 'usp_cqyb_savepatinfo')
  drop proc usp_cqyb_savepatinfo
go
Create proc usp_cqyb_savepatinfo
(
	@sbkh				varchar(20),		--社会保障号码
	@xzlb				varchar(10),		--险种类别
	@name				varchar(20),		--姓名
	@sex				varchar(20)='',		--性别
	@age				varchar(10)='',		--实足年龄
	@sfzh				varchar(18)='',		--身份证号
	@nation				varchar(20)='',		--民族
	@address			varchar(50)='',		--住址
	@rylb				varchar(10)='',		--人员类别
	@gwydy				varchar(10)='',		--是否享受公务员待遇
	@dwmc				varchar(50)='',		--单位名称
	@xzqhbm				varchar(14)='',		--行政区划编码
	@fszk				varchar(10)='',		--封锁状况
	@fsyy				varchar(128)='',	--封锁原因
	@rylxbg				varchar(10)='',		--人员类型变更
	@rylxbgsj			varchar(20)='',		--人员类型变更时间
	@dyfskssj			varchar(20)='',		--待遇封锁开始时间
	@dyfsjssj			varchar(20)='',		--待遇封锁终止时间
	@mzrylb				varchar(10)='',		--民政人员类别
	@jmjfdc				varchar(10)='',		--居民缴费档次
	@cblb				varchar(10)='',		--参保类别
	@lxdh				varchar(20)='',		--患者联系电话
	@gscbzt				varchar(10)='',		--工伤参保状态
	@gscbsj				varchar(20)='',		--工伤参保时间
	@gsfszk				varchar(10)='',		--工伤封锁状况
	@gsfsyy				varchar(128)='',	--工伤封锁原因
	@gsdyfskssj			varchar(20)='',		--工伤待遇封锁开始时间
	@gsdyfsjssj			varchar(20)='',		--工伤待遇封锁终止时间
	@zyzz				varchar(10)='',		--转院转诊
	@fzqjcbsp			varchar(10)='',		--辅助器具超标审批
	@sycbsj				varchar(20)='',		--生育参保时间
	@jydjzh				varchar(20)='',		--就医登记证号
	@xsjzbz				varchar(10)='',		--是否享受就诊标志
	@bxsjzyy			varchar(200)='',	--不能享受就诊原因
	@jydjjjbm			varchar(10)='',		--就医登记机构编码
	@bfzbz				varchar(10)='',		--并发症标志
	@dyxskssj			varchar(20)='',		--享受待遇实际开始时间
	@dyxsjssj			varchar(20)='',		--享受待遇实际结束时间
	@dqfprylb			varchar(50)=''		--当前扶贫人员类别
)
as
/****************************************
[版本号]4.0.0.0.0
[创建时间]2017.03.05
[作者]FerryMan
[版权]Copyright ? 1998-2017卫宁健康科技集团股份有限公司
[描述]保存医保病人基本信息
[功能说明]
	保存医保病人基本信息
[参数说明]
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]
[修改记录]
****************************************/
set nocount on
	
if not exists(select 1 from YY_CQYB_PATINFO where sbkh = @sbkh)
begin
	if @xzlb = '1'			--医疗保险
	begin
		insert into YY_CQYB_PATINFO(sbkh,name,sex,age,sfzh,nation,address,rylb,gwydy,dwmc,xzqhbm,fszk,fsyy,rylxbg,rylxbgsj,dyfskssj,
			dyfsjssj,mzrylb,jmjfdc,cblb,lxdh,dqfprylb)
		select @sbkh,@name,@sex,@age,@sfzh,@nation,@address,@rylb,@gwydy,@dwmc,@xzqhbm,@fszk,@fsyy,@rylxbg,@rylxbgsj,@dyfskssj,
			@dyfsjssj,@mzrylb,@jmjfdc,@cblb,@lxdh,@dqfprylb 
		if @@error<>0 or @@rowcount = 0 
		begin
			select "F","保存医保病人(医疗保险)基本信息失败!"
			return
		end;
	end
	else if @xzlb = '2'		--工伤保险
	begin
		insert into YY_CQYB_PATINFO(sbkh,name,sex,sfzh,dwmc,xzqhbm,gscbzt,gscbsj,gsfszk,gsfsyy,gsdyfskssj,gsdyfsjssj,zyzz,fzqjcbsp,dqfprylb)
		select @sbkh,@name,@sex,@sfzh,@dwmc,@xzqhbm,@gscbzt,@gscbsj,@gsfszk,@gsfsyy,@gsdyfskssj,@gsdyfsjssj,@zyzz,@fzqjcbsp,@dqfprylb
		if @@error<>0 or @@rowcount = 0 
		begin
			select "F","保存医保病人(工伤保险)基本信息失败!"
			return
		end;
	end
	else if @xzlb = '3'		--生育保险
	begin
		insert into YY_CQYB_PATINFO(sbkh,name,sex,sycbsj,sfzh,jydjzh,xsjzbz,bxsjzyy,jydjjjbm,bfzbz,dyxskssj,dyxsjssj,xzqhbm,dqfprylb)
		select @sbkh,@name,@sex,@sycbsj,@sfzh,@jydjzh,@xsjzbz,@bxsjzyy,@jydjjjbm,@bfzbz,@dyxskssj,@dyxsjssj,@xzqhbm,@dqfprylb
		if @@error<>0 or @@rowcount = 0 
		begin
			select "F","保存医保病人(生育保险)基本信息失败!"
			return
		end;
	end;
end
else
begin
	if @xzlb = '1'			--医疗保险
	begin
		update YY_CQYB_PATINFO set name = @name,sex = @sex,age = @age,sfzh = @sfzh,nation = @nation,address = @address,rylb = @rylb,
			gwydy = @gwydy,dwmc = @dwmc,xzqhbm = @xzqhbm,fszk = @fszk,fsyy = @fsyy,rylxbg = @rylxbg,rylxbgsj = @rylxbgsj,
			dyfskssj = @dyfskssj,dyfsjssj = @dyfsjssj,mzrylb = @mzrylb,jmjfdc = @jmjfdc,cblb = @cblb,lxdh = @lxdh,dqfprylb = @dqfprylb
		where sbkh = @sbkh
		if @@error<>0 or @@rowcount = 0 
		begin
			select "F","更新医保病人(医疗保险)基本信息失败!"
			return
		end;
	end
	else if @xzlb = '2'		--工伤保险
	begin
		update YY_CQYB_PATINFO set name = @name,sex = @sex,sfzh = @sfzh,dwmc = @dwmc,xzqhbm = @xzqhbm,gscbzt = @gscbzt,gscbsj = @gscbsj,
			gsfszk = @gsfszk,gsfsyy = @gsfsyy,gsdyfskssj = @gsdyfskssj,gsdyfsjssj = @gsdyfsjssj,zyzz = @zyzz,fzqjcbsp = @fzqjcbsp,
			dqfprylb = @dqfprylb
		where sbkh = @sbkh
		if @@error<>0 or @@rowcount = 0 
		begin
			select "F","更新医保病人(工伤保险)基本信息失败!"
			return
		end;
	end
	else if @xzlb = '3'		--生育保险
	begin
		update YY_CQYB_PATINFO set name = @name,sex = @sex,sycbsj = @sycbsj,sfzh = @sfzh,jydjzh = @jydjzh,xsjzbz = @xsjzbz,bxsjzyy = @bxsjzyy,
			jydjjjbm = @jydjjjbm,bfzbz = @bfzbz,dyxskssj = @dyxskssj,dyxsjssj = @dyxsjssj,xzqhbm = @xzqhbm,dqfprylb = @dqfprylb
		where sbkh = @sbkh
		if @@error<>0 or @@rowcount = 0 
		begin
			select "F","更新医保病人(生育保险)基本信息失败!"
			return
		end;
	end;
end

select "T"

return
GO
