
alter  proc usp_cqyb_getmzysybxx
  @jssjh  ut_sjh 
as
/**********
[版本号]4.0.0.0.0
[创建时间]
[作者]qinfj
[版权]
[描述]
[功能说明]
     获取门诊医生填写特病生育医保信息
[返回值]
[结果集、排序]
exec usp_cqyb_getmzysybxx '20191107000003    '
**********/

set nocount ON

DECLARE @xzlb    varchar(3) ,   --险种类别
        @yllb    VARCHAR(3) ,     --医疗类别
		@zddm    VARCHAR(20) ,   --诊断
		@ybbfz   VARCHAR(200),  --并发症
        @sylb    varchar(3),    --生育类别代码
		@sysj    varchar(20) ,    --生育时间
		@bfzbz   varchar(3) ,    --并发症标志
		@ncbz    varchar(3) ,    --难产标志
		@zzrslx  varchar(3) ,    --终止妊娠类型
		@dbtbz   varchar(3) ,    --多胞胎标志
		@syfwzh  varchar(50) ,    --生育服务证号
		@jhzh    varchar(50) ,    --结婚证号
		@jyjc    varchar(200)      --遗传病基因检查项目

--写法一   医保信息返回 是在SF_HJCFK  新版


if exists(select 1 from syscolumns where id=object_id('SF_HJCFK') and name='xzlb')
BEGIN
	if exists(select 1 from SF_MZCFK where jssjh=@jssjh)
	begin
		SELECT TOP 1
			@xzlb = CASE when ISNULL(b.xzlb,1) <> 3 AND ISNULL(b.xzlb,1) <> 2 THEN 1 ELSE ISNULL(b.xzlb,1)END , 
			@yllb = CASE WHEN b.xzlb = 3 THEN b.syyllb else b.medtype END ,
			@zddm = CASE WHEN b.xzlb = 3 THEN b.sybzdm ELSE b.cftszddm END,
			@ybbfz = CASE WHEN b.xzlb = 3 THEN b.bfz ELSE b.ybbfz END,
			@sylb = b.sylbdm,
			@sysj = CASE when isnull(b.sysj,'') ='' then '' ELSE substring(sysj,1,4)+'-'+substring(sysj,5,2)+'-'+substring(sysj,7,2) end,                  
			@bfzbz = b.bfzbz,                  
			@ncbz = b.nc,                  
			@zzrslx = b.zzrslx,                  
			@dbtbz = b.dbt,                  
			@syfwzh = b.syfwzh,
			@jhzh = b.jhzh,
			@jyjc = isnull(b.ycbjyjcxmdm,'')                  
		FROM SF_MZCFK a(nolock),SF_HJCFK b(nolock),SF_BRXXK c(nolock)                  
		where a.jssjh = @jssjh and a.hjxh = b. xh and b.patid = c.patid 
		AND ( ISNULL(b.medtype,'') <> '' OR ISNULL(b.syyllb,'') <> '' OR ISNULL(b.sylbdm,'') <> '' AND ISNULL(b.xzlb,0) IN (1,2,3) ) 
	end
END



--写法二   
/*
BEGIN
	SELECT TOP 1 
		@yllb = b.medtype  ,
		@zddm = b.cftszddm ,
		@ybbfz = b.ybbfz        
	FROM SF_MZCFK a(nolock),SF_HJCFK b(nolock),SF_BRXXK c(nolock)                  
	where a.jssjh = @jssjh and a.hjxh = b. xh and b.patid = c.patid 
	  AND ( ISNULL(b.medtype,'') <> '' OR ISNULL(b.syyllb,'') <> '' OR ISNULL(b.sylbdm,'') <> '' AND ISNULL(b.xzlb,0) IN (1,2,3) ) 
END
*/
--写法三   
/*
BEGIN
	SELECT @yllb = ISNULL(a.medtype,''),@zddm = ISNULL(a.zddm,''),@ybbfz = ISNULL(a.ybbfz,'') from SF_BRJSK a(nolock) where a.sjh = @jssjh
END
*/

--最终返回
SELECT 'T',@xzlb ,@yllb,@zddm,@ybbfz, @sylb,@sysj ,@bfzbz,@ncbz ,@zzrslx ,@dbtbz ,@syfwzh ,@jhzh ,@jyjc

RETURN


