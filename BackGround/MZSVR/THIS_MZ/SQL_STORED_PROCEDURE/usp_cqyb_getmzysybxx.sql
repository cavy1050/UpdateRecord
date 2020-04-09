
alter  proc usp_cqyb_getmzysybxx
  @jssjh  ut_sjh 
as
/**********
[�汾��]4.0.0.0.0
[����ʱ��]
[����]qinfj
[��Ȩ]
[����]
[����˵��]
     ��ȡ����ҽ����д�ز�����ҽ����Ϣ
[����ֵ]
[�����������]
exec usp_cqyb_getmzysybxx '20191107000003    '
**********/

set nocount ON

DECLARE @xzlb    varchar(3) ,   --�������
        @yllb    VARCHAR(3) ,     --ҽ�����
		@zddm    VARCHAR(20) ,   --���
		@ybbfz   VARCHAR(200),  --����֢
        @sylb    varchar(3),    --����������
		@sysj    varchar(20) ,    --����ʱ��
		@bfzbz   varchar(3) ,    --����֢��־
		@ncbz    varchar(3) ,    --�Ѳ���־
		@zzrslx  varchar(3) ,    --��ֹ��������
		@dbtbz   varchar(3) ,    --���̥��־
		@syfwzh  varchar(50) ,    --��������֤��
		@jhzh    varchar(50) ,    --���֤��
		@jyjc    varchar(200)      --�Ŵ�����������Ŀ

--д��һ   ҽ����Ϣ���� ����SF_HJCFK  �°�


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



--д����   
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
--д����   
/*
BEGIN
	SELECT @yllb = ISNULL(a.medtype,''),@zddm = ISNULL(a.zddm,''),@ybbfz = ISNULL(a.ybbfz,'') from SF_BRJSK a(nolock) where a.sjh = @jssjh
END
*/

--���շ���
SELECT 'T',@xzlb ,@yllb,@zddm,@ybbfz, @sylb,@sysj ,@bfzbz,@ncbz ,@zzrslx ,@dbtbz ,@syfwzh ,@jhzh ,@jyjc

RETURN


