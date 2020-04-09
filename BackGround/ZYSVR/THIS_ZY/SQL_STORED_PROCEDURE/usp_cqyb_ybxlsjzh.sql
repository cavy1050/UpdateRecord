CREATE proc usp_cqyb_ybxlsjzh
  @syxh ut_xh12 = 0, 
  @sjh  ut_sjh = 0,   
  @xtbz ut_bz,			--系统标志0挂号1收费2住院       
  @error_qx varchar(200) output
as
/**********
[版本号]4.0.0.0.0
[创建时间]
[作者]
[版权]
[描述]
[功能说明]

[返回值]
[结果集、排序]
exec usp_yy_checkzyczyjz '8888','4008'
exec usp_yy_checkzyczyjz '8888','6909'

**********/

set nocount ON

DECLARE @ysdm ut_czyh
       ,@configCQ18 VARCHAR(10)
       ,@ddyljgdm VARCHAR(10)
		, @now ut_rq16
	select @now=convert(char(8),getdate(),112)+convert(char(8),getdate(),8)
--如果升级该版本的医保接口，不涉及作废老接口结算数据，直接返回成功，如果要作废老接口数据则消注释以下两句，
--下面包含附一、附二、及重庆十三院及涪陵等几个版本接口的用法部署时自行选择，有问题及时联系开发处理
--select @error_qx = "T"
--return

SELECT @configCQ18 = ISNULL(config,'') FROM YY_CONFIG(NOLOCK) WHERE id= 'CQ18'
IF @configCQ18 = ''  
BEGIN
	SELECT 'F','请先设置CQ18'
	RETURN
END

--十三版本 涪陵等老接口版本用  目前只有该版本了，所以默认打开
if @xtbz in (0,1) --门诊
BEGIN
	if @xtbz=1
	begin
		select top 1 @ysdm=ysdm from VW_MZCFK WHERE jssjh=@sjh
	end
	else
	begin
		select top 1 @ysdm=ghysdm from VW_GHZDK WHERE jssjh=@sjh
	end

    BEGIN TRAN
    if not exists(select 1 from VW_CQYB_MZJZJLK where jssjh = @sjh) 
	begin
		insert into YY_CQYB_MZJZJLK(jssjh,sbkh,xzlb,cblb,jzlsh,zgyllb,ksdm,ysdm,ryrq,ryzd,cyrq,cyzd,cyyy,bfzinfo,jzzzysj,
			bah,syzh,xsecsrq,jmyllb,gsgrbh,gsdwbh,zryydm,jlzt,zxlsh)
		select a.sjh,c.ybkh,c.ip_xzlb,c.op_cblb,a.sybzyh,c.iyllb,a.ksdm,@ysdm,
			substring(a.sfrq ,1,4) + '-' + substring(a.sfrq ,5,2)+ '-'+substring(a.sfrq ,7,2) as ryrq,a.zddm as ryzd,
			substring(a.sfrq ,1,4) + '-' + substring(a.sfrq ,5,2)+ '-'+substring(a.sfrq ,7,2) as cyrq,a.zddm as cyzd,
			'' as cyyy,'' as bfzinfo,'' as jzzzysj,a.blh as bah,'' as syzh,'' as xsecsrq,a.sybjylb as jmyllb,
			'' as gsgrbh,'' as gsdwbh,'' as zryydm,'2' as jlzt,c.odjjylsh as zxlsh
		from VW_MZBRJSK a inner join YY_YBFLK b(nolock) on a.ybdm = b.ybdm --and b.ybjkid = '1'
		                  inner join dbo.YY_SYB_YBMZJYJLK c(nolock) on a.sjh = c.jssjh       
		where a.sjh = @sjh and a.ybjszt = 2 and a.jlzt = 0 --and sfrq < '2017102700:00:00'
		if @@rowcount=0 or @@error<>0                  
		BEGIN                  
			select @error_qx="F插入YY_CQYB_MZJZJLK失败！" 
			rollback tran                 
			return            
		end
	end
	
	if not exists(select 1 from VW_CQYB_MZJSJLK where jssjh = @sjh) 
	begin
		insert into YY_CQYB_MZJSJLK(jssjh,sbkh,xzlb,jzlsh,jslb,zhzfbz,zhdybz,jszzrq,
		gsrdbh,gsjbbm,cfjslx,sylb,sysj,sybfz,ncbz,rslx,dbtbz,syfwzh,jyjc,jhzh,jlzt,zxlsh,zxjssj,czlsh,zxczsj,ddyljgbm)
		select a.sjh,a.cardno,a.sybxzlb,a.sybzyh,'0' as jslb,0 as zhzfbz,0 as zhdybz,'' as jszzrq,
			'' gsrdbh,'' gsbzinfo,'' cfjslx,
			b.sydylb as sylb,b.sysjd as sysj,b.sybfz as sybfz,b.sync as ncbz,b.syzxrslx as rslx,b.sydbt as dbtbz,
			b.syfwzh as syfwzh,b.syycjyjcxm as jyjc,b.syjhzh as jhzh,
			'2' as jlzt,b.op_ybjslsh,b.ybshjssj zxjssj,'' as czlsh,'' as zxczsj,'' ddyljgbm
		from VW_MZBRJSK a inner join YY_SYB_YBMZJYJLK b(nolock) on a.sjh=b.jslsh
		where a.sjh = @sjh and a.ybjszt = 2 and a.jlzt = 0 --and a.sfrq < '20171027000:00:00'
		if @@rowcount=0 or @@error<>0                  
		BEGIN                  
			select @error_qx="F插入YY_CQYB_MZJSJLK失败！"     
			rollback tran             
			return              
		end
	END
	
	COMMIT TRAN
	
	select @error_qx = "T"
END
ELSE IF @xtbz = 2 --住院
BEGIN
	if exists (select 1 from YY_CQYB_ZYJZJLK(nolock) WHERE syxh=@syxh)
	begin
		if exists (select 1 from YY_CQYB_ZYJSJLK(nolock) WHERE syxh=@syxh)
		begin
			select @error_qx="T已有医保数据，无需重新生成！"
			return
		end
	END
	
	begin TRAN
	--住院登记
	INSERT INTO YY_CQYB_ZYJZJLK(syxh,sbkh,xzlb,cblb,jzlsh,zgyllb,ksdm,ysdm,ryrq,ryzd,cyrq,cyzd,
		cyyy,bfzinfo,jzzzysj,bah,syzh,xsecsrq,jmyllb,gsgrbh,gsdwbh,zryydm,jlzt,zxlsh,lrsj)
	SELECT 
		RTRIM(a.syxh),RTRIM(a.cardno) sbkh,RTRIM(b.ip_xzlb),RTRIM(b.op_cblb),RTRIM(b.mzzyh) mzzyh,
		RTRIM(b.iyllb) zgyllb,RTRIM(a.ksdm) ksdm,RTRIM(a.ysdm) ysdm,
		b.fip_ryrq ryrq,
		SUBSTRING(RTRIM(b.fip_ryzd),1,10) ryzd,
		b.cyrq cyrq,
		SUBSTRING(RTRIM(qzjbbm),1,10) cyzd, b.cyyy cyyy ,SUBSTRING(RTRIM(b.fip_bfz),1,200) bfzinfo,'' jzzzysj,
		RTRIM(a.blh) bah,'' syzh,'' xsecsrq,RTRIM(b.ip_jmtsjzbj) jmyllb,
		'' gsgrbh,'' gsdwbh,'' zryydm, CASE WHEN a.brzt= '3' THEN '2' else  '1' end jlzt,
		RTRIM(b.odjjylsh) zxlsh,@now
	FROM ZY_BRSYK a left join YY_SYB_YBZYDJK b ON a.syxh=b.syxh and b.jlzt=0
	WHERE a.syxh=@syxh
	if @@rowcount=0 or @@error<>0                  
	begin                  
		select @error_qx="F插入YY_CQYB_ZYJZJLK失败！"  
		rollback tran                
		return           
	end  

	--住院结算
	INSERT INTO YY_CQYB_ZYJSJLK(jsxh, syxh, sbkh, xzlb, jzlsh, jslb, zhzfbz, zhdybz, jsqzrq, jszzrq, gsrdbh, gsjbbm, cfjslx, 
	sylb, sysj, sybfz, ncbz, rslx, dbtbz, syfwzh, jyjc, jhzh, gzcybz, jlzt, zxlsh, zxjssj, czlsh, zxczsj, ddyljgbm,lrsj)
	SELECT 
		c.xh jsxh,a.syxh,a.cardno sbkh,e.xzlb,(case when isnull(a.centerid,'') = '' then e.mzzyh else a.centerid end) jzlsh,
		d.jslb jslb, d.ip_zhzfbz zhzfbz,0 zhdybz ,
		SUBSTRING(c.ksrq,1,4) + '-' + SUBSTRING(c.ksrq,5,2)+ '-'+SUBSTRING(c.ksrq,7,2) jsqzrq,
		SUBSTRING(c.jsrq,1,4) + '-' + SUBSTRING(c.jsrq,5,2)+ '-'+SUBSTRING(c.jsrq,7,2) jszzrq,
		'' gsgrbh,'' gsdwbh,'' cfjslx,e.sydylb sylb ,e.sysjd sysj,e.sybfz sybfz,
		e.sync ncbz,e.syzxrslx rslx,e.sydbt dbtbz,e.syfwzh syfwzh,e.syycjyjcxm jyjc,e.syjhzh jhzh,
		'0' gzcybz,CASE WHEN a.brzt= '3' THEN '2' else  '1' end jlzt,
		d.op_ybjslsh zxlsh,
		SUBSTRING(c.jsrq,1,4) + '-' + SUBSTRING(c.jsrq,5,2)+ '-'+SUBSTRING(c.jsrq,7,2) zxjssj,
		'' czlsh,'' zxczsj,'' ddyljgbm,@now
	FROM ZY_BRSYK a ,YY_YBFLK b,ZY_BRJSK c 
		LEFT JOIN YY_SYB_YBJYJLK d on c.xh=d.jsxh
		LEFT JOIN YY_SYB_YBZYDJK e on e.mzzyh=d.mzzyh
	WHERE a.ybdm = b.ybdm  
	and a.syxh=@syxh
	AND a.syxh = c.syxh AND c.ybjszt = '2' AND c.jlzt = 0
	AND (c.op_ybjslsh IS NOT NULL OR c.op_ybjslsh <> '' ) 
	
	if @@rowcount=0 or @@error<>0                  
	begin                  
		select @error_qx="F插入YY_CQYB_ZYJSJLK失败！"   
		rollback tran                
		return              
	end 
	
	commit TRAN
	
	select @error_qx="T"
END


RETURN

--附一版本
/*	 

IF @xtbz in (0,1) --门诊
BEGIN
    IF @xtbz=1
	begin
		select top 1 @ysdm=ysdm from VW_MZCFK WHERE jssjh=@sjh
	end
	else
	begin
		select top 1 @ysdm=ghysdm from VW_GHZDK WHERE jssjh=@sjh
	end
    BEGIN TRAN
    if not exists(select 1 from VW_CQYB_MZJZJLK where jssjh = @sjh)
	begin
		insert into YY_CQYB_MZJZJLK(jssjh,sbkh,xzlb,cblb,jzlsh,zgyllb,ksdm,ysdm,ryrq,ryzd,cyrq,cyzd,cyyy,bfzinfo,jzzzysj,
			bah,syzh,xsecsrq,jmyllb,gsgrbh,gsdwbh,zryydm,jlzt,zxlsh)
		select a.sjh,a.cardno,b.xzlb,b.cblb,a.sjh,a.medtype,a.ksdm,@ysdm,
			substring(a.sfrq ,1,4) + '-' + substring(a.sfrq ,5,2)+ '-'+substring(a.sfrq ,7,2) as ryrq,a.zddm as ryzd,
			substring(a.sfrq ,1,4) + '-' + substring(a.sfrq ,5,2)+ '-'+substring(a.sfrq ,7,2) as cyrq,a.zddm as cyzd,
			'' as cyyy,'' as bfzinfo,'' as jzzzysj,a.blh as bah,'' as syzh,'' as xsecsrq,a.medtype as jmyllb,
			'' as gsgrbh,'' as gsdwbh,'' as zryydm,'2' as jlzt,jslsh as zxlsh
		from VW_MZBRJSK a inner join YY_YBFLK b(nolock) on a.ybdm = b.ybdm and b.ybjkid = @configCQ18 
		where a.sjh = @sjh and a.ybjszt = 2 and a.jlzt = 0 and sfrq < '2018012000:00:00'
		if @@rowcount=0 or @@error<>0                  
		BEGIN                  
			select @error_qx="F插入YY_CQYB_MZJZJLK失败！" 
			rollback tran                 
			return            
		end
	end

	if not exists(select 1 from VW_CQYB_MZJSJLK where jssjh = @sjh)
	BEGIN
        --根据科室获取老的定点医疗机构代码
		SELECT @ddyljgdm = yydm FROM YY_KSBMK a(NOLOCK) ,VW_MZBRJSK b(NOLOCK) WHERE a.id = b.ksdm AND b.sjh = @sjh
		SELECT @ddyljgdm = yydm from YY_JBCONFIG(NOLOCK) WHERE id = @ddyljgdm

		insert into YY_CQYB_MZJSJLK(jssjh,sbkh,xzlb,jzlsh,jslb,zhzfbz,zhdybz,jszzrq,gsrdbh,gsjbbm,cfjslx,sylb,sysj,sybfz,
			ncbz,rslx,dbtbz,syfwzh,jyjc,jhzh,jlzt,zxlsh,zxjssj,czlsh,zxczsj,ddyljgbm)
		select a.sjh,a.cardno,b.xzlb,a.sjh,'0' as jslb,0 as zhzfbz,0 as zhdybz,'' as jszzrq,'' AS gsrdbh,'' AS gsjbbm,'' AS cfjslx,
			CASE b.xzlb WHEN 3 THEN dbo.fun_cqyb_getvalbyseq(a.strsyxx,'|',2) ELSE '' END sylb ,
			'' as sysj,'' as sybfz,'' as ncbz,'' as rslx,'' as dbtbz,'' as syfwzh,'' as jyjc,'' as jhzh,
			'2' as jlzt,a.zxlsh,substring(a.sfrq ,1,4) + '-' + substring(a.sfrq ,5,2)+ '-'+substring(a.sfrq ,7,2) zxjssj,
			'' as czlsh,'' as zxczsj,@ddyljgdm
		from VW_MZBRJSK a(NOLOCK) inner join YY_YBFLK b(nolock) on a.ybdm = b.ybdm and b.ybjkid = @configCQ18 
		where a.sjh = @sjh and a.ybjszt = 2 and a.jlzt = 0 and sfrq < '2018012000:00:00'
		if @@rowcount=0 or @@error<>0                  
		BEGIN                  
			select @error_qx="F插入YY_CQYB_MZJSJLK失败！"     
			rollback tran             
			return              
		end
	END
	
	COMMIT TRAN
	
	select @error_qx = "T"
    RETURN
END
ELSE IF @xtbz = 2 
BEGIN
    if exists (select 1 from YY_CQYB_ZYJZJLK WHERE syxh=@syxh)
	begin
		if exists (select 1 from YY_CQYB_ZYJSJLK WHERE syxh=@syxh)
		begin
			select @error_qx="T已有医保数据，无需重新生成！"
			return
		end
	END
	--根据科室获取老的定点医疗机构代码
	SELECT @ddyljgdm = yydm FROM YY_KSBMK a(NOLOCK) ,ZY_BRSYK b(NOLOCK) WHERE a.id = b.ksdm AND b.syxh = @syxh
	SELECT @ddyljgdm = yydm from YY_JBCONFIG(NOLOCK) WHERE id = @ddyljgdm  

	begin TRAN
 
	INSERT INTO YY_CQYB_ZYJZJLK(syxh,sbkh,xzlb,cblb,jzlsh,zgyllb,ksdm,ysdm,ryrq,ryzd,cyrq,cyzd,
	cyyy,bfzinfo,jzzzysj,bah,syzh,xsecsrq,jmyllb,gsgrbh,gsdwbh,zryydm,jlzt,zxlsh)
	SELECT 
		   RTRIM(a.syxh),RTRIM(a.cardno) sbkh,RTRIM(b.xzlb),RTRIM(b.cblb),RTRIM(a.centerid) mzzyh,
		   RTRIM(a.medtype) zgyllb,RTRIM(a.ksdm) ksdm,RTRIM(a.ysdm) ysdm,
		   SUBSTRING(ryrq,1,4) + '-' + SUBSTRING(ryrq,5,2)+ '-'+SUBSTRING(ryrq,7,2) ryrq,
		   SUBSTRING(RTRIM(a.ybryzd),1,10) ryzd,
		   SUBSTRING(cyrq,1,4) + '-' + SUBSTRING(cyrq,5,2)+ '-'+SUBSTRING(cyrq,7,2) cyrq,
		   RTRIM(a.cyzddm) cyzd, '' cyyy ,SUBSTRING(RTRIM(a.ybbfz),1,200) bfzinfo,'' jzzzysj,
		   RTRIM(a.ip_bah) bah,'' syzh,'' xsecsrq,RTRIM(a.medtype) jmyllb,
		   '' gsgrbh,'' gsdwbh,'' zryydm, CASE   WHEN a.brzt= '3' THEN '2' else  '1' end jlzt,
		   RTRIM(a.ybdjlsh) zxlsh

	FROM ZY_BRSYK a ,YY_YBFLK b  
	WHERE a.ybdm = b.ybdm 
	--AND b.pzlx ='22'  
	and a.syxh=@syxh
	--AND LEN(a.cardno) <= 18 AND (a.centerid IS NOT NULL OR a.centerid <> '' )
	if @@rowcount=0 or @@error<>0                  
	begin                  
		select @error_qx="F插入YY_CQYB_ZYJZJLK失败！"  
		rollback tran                
		return 
		                 
	end  
	--住院结算

	INSERT INTO YY_CQYB_ZYJSJLK(jsxh, syxh, sbkh, xzlb, jzlsh, jslb, zhzfbz, zhdybz, jsqzrq, jszzrq, gsrdbh, gsjbbm, cfjslx, 
	sylb, sysj, sybfz, ncbz, rslx, dbtbz, syfwzh, jyjc, jhzh, gzcybz, jlzt, zxlsh, zxjssj, czlsh, zxczsj, ddyljgbm)
	SELECT 
		  c.xh jsxh,a.syxh,a.cardno sbkh,b.xzlb,a.centerid jzlsh,
		   c.zyjslb jslb, 0 zhzfbz,0 zhdybz ,
		   SUBSTRING(c.ksrq,1,4) + '-' + SUBSTRING(c.ksrq,5,2)+ '-'+SUBSTRING(c.ksrq,7,2) jsqzrq,
		   SUBSTRING(c.jsrq,1,4) + '-' + SUBSTRING(c.jsrq,5,2)+ '-'+SUBSTRING(c.jsrq,7,2) jszzrq,
		   c.gsrdbh,c.gsbzinfo,c.cfjslx,
		   CASE b.xzlb WHEN 3 THEN dbo.fun_cqyb_getvalbyseq(c.strsyxx,'|',2) ELSE '' END sylb ,
		   '' sysj,'' sybfz,
		   '' ncbz,'' rslx,NULL dbtbz,'' syfwzh,'' jyjc,'' jhzh,'0' gzcybz,CASE   WHEN a.brzt= '3' THEN '2' else  '1' end jlzt,
		   c.zxlsh zxlsh,
		   SUBSTRING(c.jsrq,1,4) + '-' + SUBSTRING(c.jsrq,5,2)+ '-'+SUBSTRING(c.jsrq,7,2) zxjssj,
		   '' czlsh,'' zxczsj,@ddyljgdm
	FROM ZY_BRSYK a ,YY_YBFLK b,ZY_BRJSK c 
	WHERE a.ybdm = b.ybdm 
	--AND b.pzlx ='22'  
	and a.syxh=@syxh
	--AND LEN(a.cardno) <= 18 AND (a.centerid IS NOT NULL OR a.centerid <> '' )
	AND a.syxh = c.syxh AND c.ybjszt = '2' AND c.jlzt = 0
	AND (c.zxlsh IS NOT NULL OR c.zxlsh <> '' ) 
	
	if @@rowcount=0 or @@error<>0                  
	begin                  
		select @error_qx="F插入YY_CQYB_ZYJSJLK失败！"   
		rollback tran                
		return              
	end 
	
	if exists (select 1 from ZY_BRJSK WHERE syxh=@syxh and ybjszt=5 and jlzt=0)
	begin
		--UPDATE a set zxlsh=b.zxlsh FROM YY_CQYB_ZYJSJLK a(nolock),ZY_BRJSK b(nolock) WHERE a.syxh=@syxh and b.ybjszt=5 and a.jsxh=b.ybjsxh
		UPDATE a set zxlsh=(SELECT c.zxlsh FROM ZY_BRJSK c(NOLOCK) WHERE c.xh = b.ybjsxh AND c.ybjszt = 5)
		FROM YY_CQYB_ZYJSJLK a(nolock),ZY_BRJSK b(nolock) 
		WHERE a.syxh=@syxh and b.ybjszt=2 and a.jsxh=b.xh
		if @@rowcount=0 or @@error<>0                  
		begin                  
			select @error_qx="F更新YY_CQYB_ZYJSJLK失败！"   
			rollback tran                
			return              
		end

	end
	
	commit TRAN
	
	select @error_qx="T"
END
*/

RETURN 

--重医附二版本
/*
if @xtbz in (0,1) --门诊
BEGIN
	if @xtbz=1
	begin
		select top 1 @ysdm=ysdm from VW_MZCFK WHERE jssjh=@sjh
	end
	else
	begin
		select top 1 @ysdm=ghysdm from VW_GHZDK WHERE jssjh=@sjh
	end
    BEGIN TRAN
    if not exists(select 1 from VW_CQYB_MZJZJLK where jssjh = @sjh)
	begin
	
		insert into YY_CQYB_MZJZJLK(jssjh,sbkh,xzlb,cblb,jzlsh,zgyllb,ksdm,ysdm,ryrq,ryzd,cyrq,cyzd,cyyy,bfzinfo,jzzzysj,
			bah,syzh,xsecsrq,jmyllb,gsgrbh,gsdwbh,zryydm,jlzt,zxlsh)
		select a.sjh,a.cardno,b.xzlb,b.cblb,a.sjh,a.medtype,a.ksdm,@ysdm,
			substring(a.sfrq ,1,4) + '-' + substring(a.sfrq ,5,2)+ '-'+substring(a.sfrq ,7,2) as ryrq,a.zddm as ryzd,
			substring(a.sfrq ,1,4) + '-' + substring(a.sfrq ,5,2)+ '-'+substring(a.sfrq ,7,2) as cyrq,a.zddm as cyzd,
			'' as cyyy,'' as bfzinfo,'' as jzzzysj,a.blh as bah,'' as syzh,'' as xsecsrq,a.medtype as jmyllb,
			'' as gsgrbh,'' as gsdwbh,'' as zryydm,'2' as jlzt,jslsh as zxlsh
		from VW_MZBRJSK a inner join YY_YBFLK b(nolock) on a.ybdm = b.ybdm and b.ybjkid = '1' 
		where a.sjh = @sjh and a.ybjszt = 2 and a.jlzt = 0 and sfrq < '2017052000:00:00'
		if @@rowcount=0 or @@error<>0                  
		BEGIN                  
			select @error_qx="F插入YY_CQYB_MZJZJLK失败！" 
			rollback tran                 
			return            
		end
	end
	
	if not exists(select 1 from VW_CQYB_MZJSJLK where jssjh = @sjh)
	begin
		insert into YY_CQYB_MZJSJLK(jssjh,sbkh,xzlb,jzlsh,jslb,zhzfbz,zhdybz,jszzrq,gsrdbh,gsjbbm,cfjslx,sylb,sysj,sybfz,
			ncbz,rslx,dbtbz,syfwzh,jyjc,jhzh,jlzt,zxlsh,zxjssj,czlsh,zxczsj)
		select a.sjh,a.cardno,b.xzlb,a.sjh,'0' as jslb,0 as zhzfbz,0 as zhdybz,'' as jszzrq,a.gsrdbh,a.gsbzinfo,a.cfjslx,
			'' as sylb,'' as sysj,'' as sybfz,'' as ncbz,'' as rslx,'' as dbtbz,'' as syfwzh,'' as jyjc,'' as jhzh,
			'2' as jlzt,a.zxlsh,substring(a.sfrq ,1,4) + '-' + substring(a.sfrq ,5,2)+ '-'+substring(a.sfrq ,7,2) zxjssj,
			'' as czlsh,'' as zxczsj
		from VW_MZBRJSK a inner join YY_YBFLK b(nolock) on a.ybdm = b.ybdm and b.ybjkid = '1' 
		where a.sjh = @sjh and a.ybjszt = 2 and a.jlzt = 0 and sfrq < '2017052000:00:00'
		if @@rowcount=0 or @@error<>0                  
		BEGIN                  
			select @error_qx="F插入YY_CQYB_MZJSJLK失败！"     
			rollback tran             
			return              
		end
	END
	
	COMMIT TRAN
	
	select @error_qx = "T"
END
ELSE IF @xtbz = 2 --住院
BEGIN
	if exists (select 1 from YY_CQYB_ZYJZJLK WHERE syxh=@syxh)
	begin
		if exists (select 1 from YY_CQYB_ZYJSJLK WHERE syxh=@syxh)
		begin
			select @error_qx="T已有医保数据，无需重新生成！"
			return
		end
	END
	
	begin TRAN
	
	INSERT INTO YY_CQYB_ZYJZJLK(syxh,sbkh,xzlb,cblb,jzlsh,zgyllb,ksdm,ysdm,ryrq,ryzd,cyrq,cyzd,
	cyyy,bfzinfo,jzzzysj,bah,syzh,xsecsrq,jmyllb,gsgrbh,gsdwbh,zryydm,jlzt,zxlsh)
	SELECT 
		   RTRIM(a.syxh),RTRIM(a.cardno) sbkh,RTRIM(b.xzlb),RTRIM(b.cblb),RTRIM(a.centerid) mzzyh,
		   RTRIM(a.medtype) zgyllb,RTRIM(a.ksdm) ksdm,RTRIM(a.ysdm) ysdm,
		   SUBSTRING(ryrq,1,4) + '-' + SUBSTRING(ryrq,5,2)+ '-'+SUBSTRING(ryrq,7,2) ryrq,
		   SUBSTRING(RTRIM(a.ybryzd),1,10) ryzd,
		   SUBSTRING(cyrq,1,4) + '-' + SUBSTRING(cyrq,5,2)+ '-'+SUBSTRING(cyrq,7,2) cyrq,
		   RTRIM(a.cyzddm) cyzd, '' cyyy ,SUBSTRING(RTRIM(a.ybbfz),1,200) bfzinfo,'' jzzzysj,
		   RTRIM(a.ip_bah) bah,'' syzh,'' xsecsrq,RTRIM(a.medtype) jmyllb,
		   RTRIM(a.gsgrbh) gsgrbh,RTRIM(a.gsdwbh) gsdwbh,'' zryydm, CASE   WHEN a.brzt= '3' THEN '2' else  '1' end jlzt,
		   RTRIM(a.ybdjlsh) zxlsh

	FROM ZY_BRSYK a ,YY_YBFLK b  
	WHERE a.ybdm = b.ybdm 
	AND b.pzlx ='22'  
	and a.syxh=@syxh
	--AND LEN(a.cardno) <= 18 AND (a.centerid IS NOT NULL OR a.centerid <> '' )
	if @@rowcount=0 or @@error<>0                  
	begin                  
		select @error_qx="F插入YY_CQYB_ZYJZJLK失败！"  
		rollback tran                
		return 
		                 
	end  
	--住院结算

	INSERT INTO YY_CQYB_ZYJSJLK(jsxh, syxh, sbkh, xzlb, jzlsh, jslb, zhzfbz, zhdybz, jsqzrq, jszzrq, gsrdbh, gsjbbm, cfjslx, 
	sylb, sysj, sybfz, ncbz, rslx, dbtbz, syfwzh, jyjc, jhzh, gzcybz, jlzt, zxlsh, zxjssj, czlsh, zxczsj, ddyljgbm)
	SELECT 
		  c.xh jsxh,a.syxh,a.cardno sbkh,b.xzlb,a.centerid jzlsh,
		   c.zyjslb jslb, 0 zhzfbz,0 zhdybz ,
		   SUBSTRING(c.ksrq,1,4) + '-' + SUBSTRING(c.ksrq,5,2)+ '-'+SUBSTRING(c.ksrq,7,2) jsqzrq,
		   SUBSTRING(c.jsrq,1,4) + '-' + SUBSTRING(c.jsrq,5,2)+ '-'+SUBSTRING(c.jsrq,7,2) jszzrq,
		   c.gsrdbh,c.gsbzinfo,c.cfjslx,'' sylb ,'' sysj,'' sybfz,
		   '' ncbz,'' rslx,NULL dbtbz,'' syfwzh,'' jyjc,'' jhzh,'0' gzcybz,CASE   WHEN a.brzt= '3' THEN '2' else  '1' end jlzt,
		   c.zxlsh zxlsh,
		   SUBSTRING(c.jsrq,1,4) + '-' + SUBSTRING(c.jsrq,5,2)+ '-'+SUBSTRING(c.jsrq,7,2) zxjssj,
		   '' czlsh,'' zxczsj,'' ddyljgbm
	FROM ZY_BRSYK a ,YY_YBFLK b,ZY_BRJSK c 
	WHERE a.ybdm = b.ybdm 
	AND b.pzlx ='22'  
	and a.syxh=@syxh
	--AND LEN(a.cardno) <= 18 AND (a.centerid IS NOT NULL OR a.centerid <> '' )
	AND a.syxh = c.syxh AND c.ybjszt = '2' AND c.jlzt = 0
	AND (c.zxlsh IS NOT NULL OR c.zxlsh <> '' ) 
	
	if @@rowcount=0 or @@error<>0                  
	begin                  
		select @error_qx="F插入YY_CQYB_ZYJSJLK失败！"   
		rollback tran                
		return              
	end 
	
	if exists (select 1 from ZY_BRJSK WHERE syxh=@syxh and ybjszt=5 and jlzt=0)
	begin
		UPDATE a set zxlsh=b.zxlsh FROM YY_CQYB_ZYJSJLK a(nolock),ZY_BRJSK b(nolock) WHERE a.syxh=@syxh and b.ybjszt=5 and a.jsxh=b.ybjsxh
		if @@rowcount=0 or @@error<>0                  
		begin                  
			select @error_qx="F更新YY_CQYB_ZYJSJLK失败！"   
			rollback tran                
			return              
		end

	end
	
	commit TRAN
	
	select @error_qx="T"
END
*/

RETURN


