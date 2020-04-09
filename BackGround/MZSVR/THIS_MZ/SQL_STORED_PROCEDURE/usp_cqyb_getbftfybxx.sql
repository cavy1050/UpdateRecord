if exists(select 1 from sysobjects where name='usp_cqyb_getbftfybxx')
  drop proc usp_cqyb_getbftfybxx
go
CREATE proc usp_cqyb_getbftfybxx
	@jssjh  ut_sjh 
as
/**********
[版本号]4.0.0.0.0
[创建时间]
[作者]qinfj
[版权]
[描述]
[功能说明]
     获取部分退费原医保信息
[返回值]
[结果集、排序]

**********/

set nocount ON
DECLARE @xzlb    varchar(3),   --险种类别
        @yllb    VARCHAR(3),     --医疗类别
		@zddm    VARCHAR(20),   --诊断
		@ybbfz   VARCHAR(200),  --并发症
        @sylb    varchar(3),    --生育类别代码
		@sysj    varchar(20) ,    --生育时间
		@bfzbz   varchar(20) ,    --并发症标志
		@ncbz    varchar(20) ,    --难产标志
		@zzrslx  varchar(20) ,    --终止妊娠类型
		@dbtbz   varchar(20) ,    --多胞胎标志
		@syfwzh  varchar(20) ,    --生育服务证号
		@jhzh    varchar(20) ,    --结婚证号
		@jyjc    varchar(20)      --遗传病基因检查项目
SELECT @xzlb = '1',@yllb = '',@zddm ='',@ybbfz='',@sylb=''
--如果是部分退费返回
IF exists( SELECT 1 FROM VW_MZBRJSK a(nolock), VW_MZBRJSK b(nolock),VW_MZBRJSK c(nolock),VW_CQYB_MZJZJLK d(NOLOCK)                          
								WHERE a.sjh = b.tsjh and b.sjh = c.tsjh and a.sjh = d.jssjh and c.sjh = @jssjh)
BEGIN
    SELECT @xzlb = d.xzlb,
		   @yllb = CASE d.cblb WHEN '2' THEN d.jmyllb ELSE d.zgyllb END, @zddm = d.ryzd, @ybbfz = d.bfzinfo,
		   @sylb = e.sylb,@sysj = e.sysj,@bfzbz =e.sybfz,@ncbz = e.ncbz,@zzrslx=e.rslx,@dbtbz=e.dbtbz,@syfwzh=e.syfwzh,@jhzh=e.jhzh,@jyjc=e.jyjc
	  FROM VW_MZBRJSK a(nolock), VW_MZBRJSK b(nolock),VW_MZBRJSK c(nolock),VW_CQYB_MZJZJLK d(NOLOCK),VW_CQYB_MZJSJLK e(NOLOCK)                          
	 WHERE a.sjh = b.tsjh and b.sjh = c.tsjh and a.sjh = d.jssjh AND d.jssjh = e.jssjh
	   AND c.sjh = @jssjh
END

SELECT 'T', @xzlb ,@yllb,@zddm,@ybbfz, @sylb,@sysj ,@bfzbz,@ncbz ,@zzrslx ,@dbtbz ,@syfwzh ,@jhzh ,@jyjc


RETURN
go

