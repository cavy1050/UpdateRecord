if exists(select 1 from sysobjects where name = 'usp_cqyb_getdefaultybdm')
  drop proc usp_cqyb_getdefaultybdm
go
Create proc usp_cqyb_getdefaultybdm
(
	@xtbz				ut_bz,				--系统标志0挂号1住院
	@cblb				varchar(10),		--参保类别1职工参保2居民参保3离休干部
	@xzlb				varchar(10)			--险种类别
)
as
/****************************************
[版本号]4.0.0.0.0
[创建时间]2017.03.05
[作者]FerryMan
[版权]Copyright ? 1998-2017卫宁健康科技集团股份有限公司
[描述]获取默认医保代码
[功能说明]
	获取默认医保代码    
	xzlb    cblb    
	  1       1     职工
	  1       2     居民
	  1       3     离休
	  2             工伤
	  3             生育
[参数说明]
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]
[修改记录]
****************************************/
set nocount on

declare @ybdm	ut_ybdm		--医保代码
       ,@ybjkid VARCHAR(3)  --医保接口id 
select @ybdm = ''	

SELECT @ybjkid = config FROM YY_CONFIG WHERE id = 'CQ18' 

IF LTRIM(RTRIM(@ybjkid)) = '' 
    SELECT @ybjkid = '1'

if @xtbz = 0
begin
	--select @ybdm = ybdm from YY_YBFLK where xtbz = 0 and cblb = @cblb and jlzt = 0 and ybjkid=@ybjkid
	select @ybdm = ybdm from YY_YBFLK 
	WHERE xtbz = 0 
	  AND (
	         (@xzlb = '1' AND xzlb = @xzlb AND cblb = @cblb) OR 
	         (@xzlb = '2' AND xzlb = @xzlb) OR
	         (@xzlb = '3' AND xzlb = @xzlb) 
	      )
	  AND jlzt = 0 and ybjkid=@ybjkid
end
else if @xtbz = 1
begin
	SELECT TOP 1 @ybdm = ybdm from YY_YBFLK 
	WHERE xtbz = 1 
	  AND (
	         (@xzlb = '1' AND xzlb = @xzlb AND cblb = @cblb) OR 
	         (@xzlb = '2' AND xzlb = @xzlb) OR
	         (@xzlb = '3' AND xzlb = @xzlb) 
	      )
	  AND jlzt = 0 and ybjkid=@ybjkid
end

select "T",@ybdm

return
GO
