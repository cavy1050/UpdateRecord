Text
CREATE proc usp_dzfp_getjycs_zy
(           
    @lb        ut_bz=0,         --类别
    @jsxh      ut_sjh='',       --结算序号
    @kpd       varchar(32)='',  --开票点
    @czyh      ut_czyh=''       --操作员号
)    
as    
/*****************************    
[版本号]4.0.0.0.0      
[创建时间]2019.10.10      
[作者]刘君君      
[版权] Copyright ? 2004-2012上海金仕达-卫宁软件股份有限公司
[描述]      
[功能说明]
     住院开票       
[参数说明]        
[返回值]     
[结果集、排序]      
[调用的sp]      
[调用实例]      
[修改说明]     
******************************/    
set nocount on    

--到此位置的数据说明该走电子发票
update ZY_BRJSK set dzfpbz=1 where xh=@jsxh

if exists(select 1 from ZY_BRJSK where xh=@jsxh and dzfpbz=1 and isnull(fph,0)<>0 and exists(select 1 from YY_DZFP_ZYFP WHERE jsxh=@jsxh))
begin
select 'F','该交易已生成电子发票，无需重复生成！请刷新界面'
return
end
if exists(select 1 from ZY_BRJSK a(nolock)
inner join YY_KSBMK b(nolock) on a.sfksdm=b.id
inner join YY_KSBMK c(nolock) on a.ksdm=c.id 
where xh=@jsxh and c.yydm='01'
and b.yydm<>'01'
and ybjszt=2)
begin
	select 'F','收费科室与出院科室不在同一院区，请人工核实处理后再补开电子票'
	return
end

declare @czyxm      ut_mc64,     
        @now        ut_rq16,
        @nowrq      ut_rq8,
        @syxh       ut_syxh,
        @ybjkid     ut_bz,
        @jkcom      ut_mc64,
        @zje        ut_money,
        @yhje       ut_money,
        @zfje       ut_money,
        @srje       ut_money,
        @yjj_xj     ut_money,
        @yjj_zp     ut_money,
        @yjj_zz     ut_money,
        @sxj        ut_money,
        @szp        ut_money,
        @szz        ut_money,
        @txj        ut_money,
        @tzp        ut_money,
        @tzz        ut_money,
        @memo       ut_mc256,
        @ybzje      ut_money,   --医保总金额
        @ybzhzf     ut_money,   --医保账户支付
        @ybtczf     ut_money,   --医保统筹支付
        @ybxjzf     ut_money,   --医保现金支付
        @ybqtzf     ut_money,   --医保其它支付
        @ybzfje     ut_money,   --医保自费金额
        @ybzhye     ut_money,   --医保账户余额
        @ybyycd     ut_money    --医保医院承担    
select @now=convert(char(8),getdate(),112)+convert(char(8),getdate(),8) 
select @nowrq=substring(@now,1,8) 
select @ybzje=0,@ybzhzf=0,@ybtczf=0,@ybxjzf=0,@ybqtzf=0,@ybzfje=0,@ybzhye=0,@ybyycd=0,@memo=''

--取业务办理操作员
select @czyh=rtrim(jsczyh) from ZY_BRJSK where xh=@jsxh
select @czyxm=name from czryk where id=@czyh  

--开票点
if exists(select 1 from YY_CONFIG (nolock) where id='50CQ0002' and config='1')
begin
    select @kpd=rtrim(jsczyh) from ZY_BRJSK where xh=@jsxh
end

select @syxh=a.syxh,
       @zje=a.zje,
       @yhje=a.yhje,
       @zfje=a.zfje,
       @srje=a.srje,
       @ybjkid=b.ybjkid,
       @jkcom=isnull(c.jkcomname,'')
from ZY_BRJSK a (nolock) inner join YY_YBFLK b (nolock) on (a.ybdm=b.ybdm) 
                         left  join YY_YBJKDMK c (nolock) on (b.ybjkid=c.ybjkid)
where a.xh=@jsxh

select * into #jemx from ZY_BRJSJEK (nolock) where jsxh=@jsxh
select * into #yjj  from ZYB_BRYJK (nolock) where syxh=@syxh and jsxh=@jsxh

if @lb=1--主信息
begin
    --重庆市医保
    if @jkcom='Cqdrybjk.Cqdryb'
    begin
        select @ybzje= je from #jemx (nolock) where jsxh=@jsxh and 
        lx in ('yb01','yb02','yb03','yb04','yb05','yb08','yb09','yb24','yb25','yb26','yb27','yb28','yb30','yb31','yb32')--医保总金额
        select @ybzhzf=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb02','yb31','yb32')--医保账户支付
        select @ybtczf=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb01','yb24','25')--医保统筹支付(包含生育基金，(儿保学保)少儿住院基金支付)
        select @ybxjzf=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb04','yb25','yb27')--医保现金支付
        select @ybqtzf=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb30','yb08','yb28','yb03','yb99','yb05','yb06','FS01')--医保其它支付(包含医疗机构垫付、公务员补助、其他账户抵扣、大额理赔、公务员返还、交通救助)
        select @ybzfje=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb02','yb31','yb32','yb04','yb25','yb27')--医保自费金额
        select @ybzhye=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb07')--医保账户余额
        select @ybyycd=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb08','yb28')--医保医院承担							  
    end

	--市医保（新）                               
    if lower(@jkcom)='si21ybjk.si21yb'          
	begin                              
		select @ybzje=sum(je) from #jemx(nolock) where jsxh=@jsxh and lx in ('01')--医疗费总额01  
        select @ybzhzf=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('17')     --个人账户支出 
		select @ybtczf=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('07')  --基金支付总额15   
        select @ybxjzf=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('18')    --个人现金支出     
		select @ybqtzf=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('09','10','11','12','13','14','19','21','97') --医保其他支付
		select @ybzfje=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('16')--个人负担总金额    
        select @ybzhye=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('20')     --余额     
        select @ybyycd=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('19')     --医院负担金额(其他)19     
    end   
    
    else if @jkcom='Tdrsybybjk.Tdrsybybjk'
    begin
        select @ybzje= je from #jemx (nolock) where jsxh=@jsxh and 
        lx in ('yb01','yb02','yb03','yb04','yb05','yb08','yb09','yb24','yb25','yb26','yb27','yb28','yb30','yb31','yb32')--医保总金额
        select @ybzhzf=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb02','yb31','yb32')--医保账户支付
        select @ybtczf=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb01','yb24','25')--医保统筹支付(包含生育基金，(儿保学保)少儿住院基金支付)
        select @ybxjzf=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb04','yb25','yb27')--医保现金支付
        select @ybqtzf=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb30','yb08','yb28','yb03','yb99','yb05','yb06','FS01')--医保其它支付(包含医疗机构垫付、公务员补助、其他账户抵扣、大额理赔、公务员返还、交通救助)
        select @ybzfje=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb02','yb31','yb32','yb04','yb25','yb27')--医保自费金额
        select @ybzhye=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb07')--医保账户余额
        select @ybyycd=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb08','yb28')--医保医院承担	
    end

	else if @jkcom='Winybproxy.Winyb'--工伤
    begin
        select @ybzje= je from #jemx (nolock) where jsxh=@jsxh and 
        lx in ('yb01','yb02','yb03','yb04','yb05','yb08','yb09','yb24','yb25','yb26','yb27','yb28','yb30','yb31','yb32')--医保总金额
        select @ybzhzf=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb02','yb31','yb32')--医保账户支付
        select @ybtczf=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb01','yb24','25')--医保统筹支付(包含生育基金，(儿保学保)少儿住院基金支付)
        select @ybxjzf=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb04','yb25','yb27')--医保现金支付
        select @ybqtzf=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb30','yb08','yb28','yb03','yb99','yb05','yb06','FS01')--医保其它支付(包含医疗机构垫付、公务员补助、其他账户抵扣、大额理赔、公务员返还、交通救助)
        select @ybzfje=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb02','yb31','yb32','yb04','yb25','yb27')--医保自费金额
        select @ybzhye=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb07')--医保账户余额
        select @ybyycd=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb08','yb28')--医保医院承担	
    end

	else if @jkcom='Cqfssybjk.Cqfssyb'--非实时医保
    begin
        select @ybzje= je from #jemx (nolock) where jsxh=@jsxh and 
        lx in ('yb01','yb02','yb03','yb04','yb05','yb08','yb09','yb24','yb25','yb26','yb27','yb28','yb30','yb31','yb32')--医保总金额
        select @ybzhzf=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb02','yb31','yb32')--医保账户支付
        select @ybtczf=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb01','yb24','25')--医保统筹支付(包含生育基金，(儿保学保)少儿住院基金支付)
        select @ybxjzf=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb04','yb25','yb27')--医保现金支付
        select @ybqtzf=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb30','yb08','yb28','yb03','yb99','yb05','yb06','FS01')--医保其它支付(包含医疗机构垫付、公务员补助、其他账户抵扣、大额理赔、公务员返还、交通救助)
        select @ybzfje=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb02','yb31','yb32','yb04','yb25','yb27')--医保自费金额
        select @ybzhye=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb07')--医保账户余额
        select @ybyycd=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb08','yb28')--医保医院承担	
    end
	
    --电子健康卡
    else if @jkcom='Cqdzjkkjk.Cqdzjkk'
    begin
        select @ybzje= je from #jemx (nolock) where jsxh=@jsxh and 
        lx in ('yb01','yb02','yb03','yb04','yb05','yb08','yb09','yb24','yb25','yb26','yb27','yb28','yb30','yb31','yb32')--医保总金额
        select @ybzhzf=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb02','yb31','yb32')--医保账户支付
        select @ybtczf=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb01','yb24','25')--医保统筹支付(包含生育基金，(儿保学保)少儿住院基金支付)
        select @ybxjzf=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb04','yb25','yb27')--医保现金支付
        select @ybqtzf=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb30','yb08','yb28','yb03','yb99','yb05','yb06','FS01')--医保其它支付(包含医疗机构垫付、公务员补助、其他账户抵扣、大额理赔、公务员返还、交通救助)
        select @ybzfje=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb02','yb31','yb32','yb04','yb25','yb27')--医保自费金额
        select @ybzhye=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb07')--医保账户余额
        select @ybyycd=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb08','yb28')--医保医院承担	
    end
	
	--国家农合接口
    else if @jkcom='Cqgjnh.Cqnhyb'
    begin
        select @ybzje= je from #jemx (nolock) where jsxh=@jsxh and 
        lx in ('yb01','yb02','yb03','yb04','yb05','yb08','yb09','yb24','yb25','yb26','yb27','yb28','yb30','yb31','yb32')--医保总金额
        select @ybzhzf=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb02','yb31','yb32')--医保账户支付
        select @ybtczf=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb01','yb24','25')--医保统筹支付(包含生育基金，(儿保学保)少儿住院基金支付)
        select @ybxjzf=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb04','yb25','yb27')--医保现金支付
        select @ybqtzf=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb30','yb08','yb28','yb03','yb99','yb05','yb06','FS01')--医保其它支付(包含医疗机构垫付、公务员补助、其他账户抵扣、大额理赔、公务员返还、交通救助)
        select @ybzfje=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb02','yb31','yb32','yb04','yb25','yb27')--医保自费金额
        select @ybzhye=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb07')--医保账户余额
        select @ybyycd=sum(je) from #jemx (nolock) where jsxh=@jsxh and lx in ('yb08','yb28')--医保医院承担	
    end


    if @ybzje<>0 and abs(@ybzje-@ybzhzf-@ybtczf-@ybqtzf-@ybxjzf)>0.5
    begin
        select 'F','医保金额计算有误！'
        return
    end
       
    --备注
	if lower(@jkcom)='si21ybjk.si21yb'                                  
	begin
		select @memo+=(case when b.ybdm='147' then '道路交通事故救助基金垫付' else mc end+'：'+convert(varchar(16),je))+'，' 
		from #jemx a
		inner join ZY_BRJSK b on a.jsxh=b.xh
		where jsxh=@jsxh
		and lx in ('09','10','11','12','13','14','19','21','97') 
		and je>0 
	end
	else
	begin
		select @memo+=(case when b.ybdm='147' then '道路交通事故救助基金垫付' else mc end+'：'+convert(varchar(16),je))+'，' 
		from #jemx a
		inner join ZY_BRJSK b on a.jsxh=b.xh
		where jsxh=@jsxh
		and lx in ('yb30','yb08','yb28','yb03','yb99','yb05','yb24','yb06','25','FS01','19') 
		and je>0 
	end
	
	if @memo<>'' select @memo=substring(@memo,1,len(@memo)-1)
	--print @ybzhzf
	--print @ybtczf
	--print @ybqtzf
	if((select (@ybzhzf+@ybtczf+@ybqtzf+zfje-srje)-(zje-yhje) from ZY_BRJSK where xh=@jsxh) <> 0 )
	begin
		select 'F','总金额【'+convert(varchar(16),zje-yhje)+'】 <> 医保账户支付【'+convert(varchar(16),@ybzhzf)+'】+'
		+'医保统筹支付【'+convert(varchar(16),@ybtczf)+'】+'
		+'医保其他支付【'+convert(varchar(16),@ybqtzf)+'】+'
		+'个人现金支付【'+convert(varchar(16),zfje-srje)+'】'
		from ZY_BRJSK where xh=@jsxh
		return
	end

    --押金信息
    select @yjj_xj=sum(a.jje-a.dje) from #yjj a inner join YY_ZFFSK b (nolock) on (a.zffs=b.id) where a.czlb in (0,1,3,4) and substring(b.memo,1,1)='1'
    select @yjj_zp=sum(a.jje-a.dje) from #yjj a inner join YY_ZFFSK b (nolock) on (a.zffs=b.id) where a.czlb in (0,1,3,4) and substring(b.memo,1,1)<>'1'
    select @yjj_zz=0

    select @sxj=sum(a.jje) from #yjj a inner join YY_ZFFSK b (nolock) on (a.zffs=b.id) where a.czlb=2 and substring(b.memo,1,1)='1'
    select @szp=sum(a.jje) from #yjj a inner join YY_ZFFSK b (nolock) on (a.zffs=b.id) where a.czlb=2 and substring(b.memo,1,1)<>'1'
    select @szz=0

    select @txj=sum(a.dje) from #yjj a inner join YY_ZFFSK b (nolock) on (a.zffs=b.id) where a.czlb=2 and substring(b.memo,1,1)='1'
    select @tzp=sum(a.dje) from #yjj a inner join YY_ZFFSK b (nolock) on (a.zffs=b.id) where a.czlb=2 and substring(b.memo,1,1)<>'1'
    select @tzz=0

    select distinct a.xh                        busNo,               --业务流水号
           '01'                        busType,             --业务标识
           sy.hzxm                      payer,               --患者姓名
           replace(a.jsrq,':','')+'000' busDateTime,         --业务发生时间
           @kpd                        placeCode,           --开票点编码
           c.name                      payee,               --收费员
           @czyxm                      author,              --票据编制人
           isnull(a.zje-a.yhje,0)                totalAmt,   --开票总金额
           '备注：                 '+@memo                       remark,         --备注
           ''                          alipayCode,          --患者支付宝账户
           ''                          weChatOrderNo,       --微信支付订单号
           ''                          weChatMedTransNo,    --微信医保支付订单号
           ''                          openID,              --微信公众号或小程序用户ID
           case when len(b.lxdh)<>11 or (left(b.lxdh,1)<>'1' and left(b.lxdh,3)<>'023') then '' else b.lxdh end        tel,                 --患者手机号码
           case when b.email='无' then '' else b.email end                     email,               --患者邮箱地址
           1                           payerType,           --交款人类型
           sy.sfzh                      idCardNo,            --患者身份证号码
           case when d.ybjkid<>0 then '1102'
                when sy.cardno<>'' then '3101'
                when sy.sfzh<>'' then '1101'
                else '3101' end        cardType,            --卡类型
           case when sy.cardno<>'' then a.cardno
                when sy.sfzh<>'' then b.sfzh 
                else sy.blh end         cardNo,              --卡号           
           '综合医院'                  medicalInstitution,  --医疗机构类型
           ''                          medCareInstitution,  --医保机构编码           
           d.ybdm                      medCareTypeCode,     --医保类型编码
           d.ybsm                      medicalCareType,     --医保类型名称
           case when d.ybjkid=0 then '' else sy.cardno end  medicalInsuranceID,  --患者医保编号
           f.name                      category,            --入院科室名称
           f.id                        categoryCode,        --入院科室编码
           f.name                      leaveCategory,       --出院科室名称
           f.id                        leaveCategoryCode,   --出院科室编码
           sy.syxh                      hospitalNo,          --患者住院号
           a.xh                        visitNo,             --住院就诊编号
           sy.patid                     patientId,           --患者唯一ID
           sy.syxh                      patientNo,           --患者就诊编号
           ltrim(rtrim(sy.sex))         sex,                 --性别
           dbo.FUN_GETBRNL_ex(b.birth,convert(char(8),getdate(),112)+convert(char(8),getdate(),8),0,1,null,'','') age,                 --年龄
           g.name                      hospitalArea,        --病区
           e.cwdm        bedNo,               --床号
           sy.blh                       caseNumber,          --病历号
           substring(e.ryrq,1,4)+'-'+substring(e.ryrq,5,2)+'-'+substring(e.ryrq,7,2) inHospitalDate, --住院日期
           case when e.brzt=1 then null 
		   else 
		   substring(e.cqrq,1,4)+'-'+substring(e.cqrq,5,2)+'-'+substring(e.cqrq,7,2)
		   end outHospitalDate,--出院日期
           a.zyts                      hospitalDays,        --住院天数
           ''                          payMentVoucher,      --预交金凭证消费扣款列表
           isnull(@ybzhzf,0)                     accountPay,          --个人账户支付
           isnull(@ybtczf,0) fundPay,   --医保统筹基金支付
           isnull(@ybqtzf,0)                     otherfundPay,        --其它医保支付
           isnull(@ybzfje,0)                     ownPay,              --自费金额
           isnull(a.zfje-a.srje,0)               selfConceitedAmt,    --个人自负
           0                           selfPayAmt,          --个人自付
           isnull(a.zfje-a.srje,0)               selfCashPay,         --个人现金支付
           isnull(@yjj_xj,0)                     cashPay,             --现金预交款金额
           isnull(@yjj_zp,0)                     chequePay,           --支票预交款金额
           isnull(@yjj_zz,0)                     transferAccountPay,  --转账预交款金额
           isnull(@sxj,0)                        cashRecharge,        --补交金额(现金)
           isnull(@szp,0)                        chequeRecharge,      --补交金额(支票)
           isnull(@szz,0)                        transferRecharge,    --补交金额（转账）
           isnull(@txj,0)      cashRefund,       --退还金额(现金)
           isnull(@tzp,0)          chequeRefund,        --退交金额(支票)
           isnull(@tzz,0)                        transferRefund,      --退交金额(转账)
    isnull(@ybzhye,0)                     ownAcBalance,        --个人账户余额
           isnull(@ybtczf,0)                     reimbursementAmt,    --报销总金额
           ''                          balancedNumber,      --结算号
           ''                          otherInfo,           --其它扩展信息列表
           ''                          otherMedicalList,    --其它医保信息列表
           ''                          payChannelDetail,    --交费渠道列表
           a.xh                        eBillRelateNo,       --业务票据关联号
           1                           isArrears,           --是否可流通
           ''                          arrearsReason,       --不可流通原因
           ''                          chargeDetail,        --收费项目明细
           ''                          listDetail           --清单项目明细
	into #temp_lb1
    from ZY_BRJSK a (nolock) 
	inner join ZY_BRSYK sy(nolock) on (a.syxh=sy.syxh and sy.brzt<>9)
	inner join ZY_BRXXK b (nolock) on (a.patid=b.patid)
	left  join czryk c    (nolock) on (a.jsczyh=c.id)
	inner join YY_YBFLK d (nolock) on (a.ybdm=d.ybdm)
	inner join ZY_BRSYK e (nolock) on (a.syxh=e.syxh)
	left  join YY_KSBMK f (nolock) on (e.ksdm=f.id)
	left  join ZY_BQDMK g (nolock) on (e.bqdm=g.id)
    where a.xh=@jsxh
	select * from #temp_lb1
	drop table #temp_lb1
    return      
end
if @lb=2--收费项目明细
begin
    select identity(int,1,1)   sortNo,        --序号
           b.dzfp_zydydm       chargeCode,    --收费项目代码
           b.dzfp_zydymc       chargeName,    --收费项目名称
           ' '                 unit,          --计量单位
           sum(a.xmje-a.yhje)  std,           --收费标准
           1                   number,        --数量
           sum(a.xmje-a.yhje)  amt,           --金额
           0                   selfAmt,       --自费金额
           ''                  remark        --备注
	into #temp_lb2
    from ZY_BRJSMXK a (nolock) inner join YY_SFDXMK b (nolock) on (a.dxmdm=b.id)
    where a.jsxh=@jsxh --and a.xmje-a.yhje<>0
    group by b.dzfp_zydydm,b.dzfp_zydymc
	select * from #temp_lb2
	drop table #temp_lb2
    return      
end
if @lb=3--清单项目明细
begin
    select distinct a.xh        listDetailNo,        --明细流水号
           e.dzfp_zydydm        chargeCode,          --收费项目代码
           e.dzfp_zydymc        chargeName,          --收费项目名称
           0                    prescribeCode,       --处方编码
           d.id                 listTypeCode,        --药品类别编码
           d.name               listTypeName,    --药品类别名称
           case a.idm when 0 then a.ypdm else convert(varchar(9),a.idm) end          code,                --编码
           replace(a.ypmc,'\','\\') name,              --药品名称
           f.name               form,                --剂型
           replace(a.ypgg,'\','\\')               specification,       --规格
           a.ypdw     unit,     --计量单位 
  convert(numeric(16,6),(a.ypdj-a.yhdj)/a.ykxs*a.dwxs)          std,                 --单价
           convert(numeric(16,6),sum(a.ypsl/a.dwxs))                          number,              --数量
           --convert(numeric(16,2),sum((a.ypdj-a.yhdj)/a.ykxs*a.ypsl))          amt,                 --金额
		   sum(a.zje) amt,                 --金额
           0                    selfAmt,             --自费金额
           0                    receivableAmt,       --应收费用
           ''                   medicalCareType,     --医保药品分类
           ''                   medCareItemType,     --医保项目类型
           ''                   medReimburseRate,    --医保报销比例
           ''                   remark,              --备注
           identity(int,1,1)	sortNo,              --序号
           ''                   chrgtype             --费用类型
    into #temp_lb3
    from VW_BRFYMXK a (nolock) left  join YK_YPCDMLK c (nolock) on (a.idm=c.idm)
                          left  join YK_YPFLK   d (nolock) on (c.fldm=d.id)
                         inner join YY_SFDXMK  e (nolock) on (a.dxmdm=e.id)
                      left  join YK_YPJXK   f (nolock) on (c.jxdm=f.id)
    where a.syxh=@syxh and a.jsxh=@jsxh
    group by e.dzfp_zydydm,e.dzfp_zydymc,d.id,d.name,a.idm,a.ypdm,
	a.ypmc,f.name,a.ypgg,a.ypdw,a.ypdj,a.yhdj,a.ykxs,a.dwxs,a.xh
	
	declare @zje_jy numeric(16,2)=0,@zje_sc numeric(16,2)=0
	select top 1 @zje_jy=zje from ZY_BRJSK where xh=@jsxh  -- -yhje
	select @zje_sc=sum(amt) from #temp_lb3
	if exists(select 1 from ZY_BRJSK where xh=@jsxh and jlzt<>0 and ybjszt=2)
	begin
		select @zje_sc=zje-yhje from ZY_BRJSK where xh=@jsxh and jlzt<>0 and ybjszt=2
	end 
	--print @zje_jy
	--print @zje_sc
	if(abs(@zje_jy-@zje_sc)>0.1)
	begin
		select 'F','上传明细金额总计与总金额的差额大于0.1元！'
        return
	end

	select * from #temp_lb3
	drop table #temp_lb3
    return      
end
if @lb=4--其它信息
begin
    select distinct 1     infoNo,       --序号
           ''    infoName,     --扩展信息名称
           ''    infoValue     --扩展信息值
    where 1=2
end
if @lb=5--其它医保信息
begin
    select distinct 1     infoNo,       --序号
           ''    infoName,     --医保信息名称
           ''    infoValue,    --医保信息值
           ''    infoOther     --医保其它信息
    where 1=2
end
if @lb=6--交费渠道
begin
    declare @yjj        ut_money,
            @st         ut_money,
            @jf_xj      ut_money,--现金
            @jf_zp      ut_money,--支票
            @jf_pos     ut_money,--pos
            @jf_Y       ut_money,--软pos
            @jf_zfb     ut_money,--支付宝
            @jf_wx      ut_money --微信
    select @yjj   =isnull(sum(jje-dje),0) from #yjj where czlb in (0,1,3,4)
    select @st    =isnull(sum(jje-dje),0) from #yjj where czlb in (2,6)
    select @jf_xj =isnull(sum(jje-dje),0) from #yjj where czlb in (2,6) and zffs='1'
    select @jf_pos=isnull(sum(jje-dje),0) from #yjj where czlb in (2,6) and zffs='7'
    select @jf_Y  =isnull(sum(jje-dje),0) from #yjj where czlb in (2,6) and zffs='Y'
    select @jf_zfb=isnull(sum(jje-dje),0) from #yjj where czlb in (2,6) and zffs='S' and exists(select 1 from YY_PAYDETAILK (nolock) where zflb=3 and jsxh=@jsxh and paytype='8')
    select @jf_wx =isnull(sum(jje-dje),0) from #yjj where czlb in (2,6) and zffs='S' and exists(select 1 from YY_PAYDETAILK (nolock) where zflb=3 and jsxh=@jsxh and paytype='9')
    select @jf_zp =@st-@jf_xj-@jf_pos-@jf_Y-@jf_zfb-@jf_wx

    --现金
    select '02' payChannelCode,@jf_xj payChannelValue where isnull(@jf_xj,0)<>0
    --POS刷卡
    union all
    select '01' payChannelCode,@jf_pos payChannelValue where isnull(@jf_pos,0)<>0
    --软pos
 union all
    select '10' payChannelCode,@jf_Y payChannelValue where isnull(@jf_Y,0)<>0
    --支付宝
    union all
    select '04' payChannelCode,@jf_zfb payChannelValue where isnull(@jf_zfb,0)<>0
    --微信
    union all
    select '05' payChannelCode,@jf_wx payChannelValue where isnull(@jf_wx,0)<>0
    --支票
    union all
    select '06' payChannelCode,@jf_zp payChannelValue where isnull(@jf_zp,0)<>0
    --医保支付
    union all
    select '11' payChannelCode,@zje-@yhje-@zfje+@srje payChannelValue where @zje-@yhje-@zfje+@srje<>0
    --预交金
    union all
    select '12' payChannelCode,@yjj payChannelValue where isnull(@yjj,0)<>0
	union all
	--现金(0元交易)
    select '02' payChannelCode,@jf_xj payChannelValue where @jf_xj=0
end
if @lb=7--预交金
begin
    select xh voucherBatchCode,xh voucherNo,jje-dje voucherAmt from #yjj where czlb in (0,1,3,4) and 1=2
end
return





















