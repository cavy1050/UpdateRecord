if exists(select 1 from sysobjects where name = 'usp_cqyb_getqueryinfo')
  drop proc usp_cqyb_getqueryinfo
go
CREATE proc usp_cqyb_getqueryinfo
(
	@cxlb				ut_bz,				--查询类别1医保基本信息及账户信息2医保特病信息3工伤单位信息4工伤认定信息
	@sbkh				varchar(20),		--社会保障号码
	@xzlb				ut_bz=0				--险种类别
)
as
/****************************************
[版本号]4.0.0.0.0
[创建时间]2017.03.05
[作者]FerryMan
[版权]Copyright ? 1998-2017卫宁健康科技集团股份有限公司
[描述]获取医保病人基本信息及账户信息
[功能说明]
	获取医保病人基本信息及账户信息
[参数说明]
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]
[修改记录] 
****************************************/
set nocount on 

if @cxlb = 1	--1医保基本信息及账户信息
begin
	if @xzlb = 1
	begin
		select "T",a.sbkh,name,(case sex when '1' then '男' when '2' then '女' else sex end),age,sfzh,nation,address,rylb,gwydy,
			dwmc,xzqhbm,fszk,fsyy,rylxbg,rylxbgsj,dyfskssj,dyfsjssj,mzrylb,jmjfdc,cblb,lxdh,dqfprylb,zhye,bntczflj,bntsmzqfbzljzf,
			bntsmzybflj,bnexzlzyqfbzzflj,bnfhgwyfwmzfylj,bnzycs,zyzt,bntbmzxbzzfje,bnzyxbzzfje,bnfsgexzlbz,bndbzflj,jbzdjbfsbz,
			bnywshzflj,bnndyjhzflj,bnetlbzflj,bnkfxmzflj,ndmzzyzflj,ndmzmzzflj,jxbzlj,ndptmzzflj,yddjbz,zhxxyly,zhxxyle
		from YY_CQYB_PATINFO a(nolock) inner join YY_CQYB_ACCINFO b(nolock) on a.sbkh = b.sbkh
		where a.sbkh = @sbkh 
	end
	else if @xzlb = 2
	begin
		select "T",a.sbkh,name,(case sex when '1' then '男' when '2' then '女' else sex end),sfzh,dwmc,xzqhbm,gscbzt,gscbsj,
			gsfszk,gsfsyy,gsdyfskssj,gsdyfsjssj,zyzz,fzqjcbsp,cfxmtslj,gszyzt
		from YY_CQYB_PATINFO a(nolock) inner join YY_CQYB_ACCINFO b(nolock) on a.sbkh = b.sbkh
		where a.sbkh = @sbkh 
	end
	else if @xzlb = 3
	begin
		select "T",a.sbkh,name,(case sex when '1' then '男' when '2' then '女' else sex end),sycbsj,sfzh,jydjzh,xsjzbz,bxsjzyy,
			jydjjjbm,bfzbz,dyxskssj,dyxsjssj,xzqhbm,byqcqjczflj,byqycbjyjczflj,byqjhsysszflj,byqfmzzrsylfzflj,byqbfzzflj,
			syzyzt	 
		from YY_CQYB_PATINFO a(nolock) inner join YY_CQYB_ACCINFO b(nolock) on a.sbkh = b.sbkh
		where a.sbkh = @sbkh 
	end
end  
else if @cxlb = 2	--2医保特病信息
begin
	select "T",bzbm,bzmc,bfz from YY_CQYB_TSBINFO(nolock) where sbkh = @sbkh and jlzt = 0
end
else if @cxlb = 3	--3工伤单位信息
begin
	select "T",grbh,dwbh,dwmc from YY_CQYB_GSDWINFO(nolock) where sbkh = @sbkh and jlzt = 0
end
else if @cxlb = 4	--4工伤认定信息
begin
	select "T",a.grbh,a.dwbh,b.dwmc,a.rdbh,a.tgbz,a.sssj,a.jssj,bzinfo  
	from YY_CQYB_GSRDINFO a(nolock) inner join YY_CQYB_GSDWINFO b(nolock) on a.dwbh = b.dwbh 
	where a.sbkh = @sbkh and a.jlzt = 0
end

return
GO
