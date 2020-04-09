if exists(select 1 from sysobjects where name='usp_cqyb_getbftfybxx')
  drop proc usp_cqyb_getbftfybxx
go
CREATE proc usp_cqyb_getbftfybxx
	@jssjh  ut_sjh 
as
/**********
[�汾��]4.0.0.0.0
[����ʱ��]
[����]qinfj
[��Ȩ]
[����]
[����˵��]
     ��ȡ�����˷�ԭҽ����Ϣ
[����ֵ]
[�����������]

**********/

set nocount ON
DECLARE @xzlb    varchar(3),   --�������
        @yllb    VARCHAR(3),     --ҽ�����
		@zddm    VARCHAR(20),   --���
		@ybbfz   VARCHAR(200),  --����֢
        @sylb    varchar(3),    --����������
		@sysj    varchar(20) ,    --����ʱ��
		@bfzbz   varchar(20) ,    --����֢��־
		@ncbz    varchar(20) ,    --�Ѳ���־
		@zzrslx  varchar(20) ,    --��ֹ��������
		@dbtbz   varchar(20) ,    --���̥��־
		@syfwzh  varchar(20) ,    --��������֤��
		@jhzh    varchar(20) ,    --���֤��
		@jyjc    varchar(20)      --�Ŵ�����������Ŀ
SELECT @xzlb = '1',@yllb = '',@zddm ='',@ybbfz='',@sylb=''
--����ǲ����˷ѷ���
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

