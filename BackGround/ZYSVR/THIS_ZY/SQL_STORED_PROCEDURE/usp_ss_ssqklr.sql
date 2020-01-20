IF EXISTS (SELECT 1
             FROM sysobjects
            WHERE [name] = 'usp_ss_ssqklr'
              AND [type] = 'P')
    DROP PROC usp_ss_ssqklr;
GO
CREATE PROCEDURE usp_ss_ssqklr
    @wkdz VARCHAR(32),
    @jszt TINYINT,
    @czyh ut_czyh,
    @ssxh ut_xh12,
    @xssdm ut_xmdm,
    @mzdm ut_xmdm,
    @shzd ut_zddm,
    @shzd1 ut_zddm,
    @shzd2 ut_zddm,
    @shzd3 ut_zddm,
    @kssj ut_rq16,
    @jssj ut_rq16,
    @bqsm ut_mc64,
    @glbz ut_bz,
    @slbz ut_bz,
    @qkdj ut_mc32,
    @rydm ut_czyh,
    @rylb TINYINT,
    @ssdjdm ut_dm2,
    @sfsx ut_dm2,
    @memo VARCHAR(1000),
    @isjb ut_bz = NULL,
    @isqj ut_bz = NULL,
    @sstc CHAR(2),
    @mzkssj ut_rq16 = NULL,
    @mzjssj ut_rq16 = NULL,
    @tw ut_mc32 = NULL,
    @mzdm1 ut_xmdm = NULL,
    @mzdm2 ut_xmdm = NULL,
    @mzjbdm ut_dm2 = NULL,
    @ztfsdm ut_dm2 = NULL,
    @ssxgfj ut_dm2,
    @mzfyqxgsj ut_mc64,
    @ztsx ut_mc32,
    @sshzt ut_bz,
    @mzfs ut_bz,
    @mzfspf ut_dm2,
    @jzss ut_bz,
    @shsw ut_bz,
    @yc ut_bz,
    @dd ut_bz,
    @zc ut_bz,
    @yycw ut_bz,
    @sx ut_bz,
    @syfy ut_bz,
    @szywyl ut_bz,
    @zxjmjc ut_bz,
    @piccojc ut_bz,
    @ycdmyjc ut_bz,
    @mzbfz ut_mc32,
    @zqss ut_bz,
    @fjhzcss ut_bz,
    @mzblsj ut_mc64,
    @mzxgfj ut_dm2,
    @asaxgfj ut_dm2,
    @ssgl ut_xh12 = NULL,
    @ssfxpg ut_mc32 = '',
    @ssbwlb ut_mc32 = '',
    @qkwrcd ut_dm4 = '',
    @ssdm2 ut_xmdm = '',
    @ssdm3 ut_xmdm = '',
    @ssdm4 ut_xmdm = '',
    @ssdm5 ut_xmdm = '',
    @rssj ut_rq16 = NULL,
    @cssj ut_rq16 = NULL,
    @sxss ut_mc256 = '',
    @jhssbz ut_bz = 0,
    @ybbz ut_bz = 0,
    @dkssbz ut_bz = 0,
    @kssjdbz ut_bz = 0,
    @fmssbz ut_bz = 0,
    @xdssbz ut_bz = 0,
    @qx ut_mc64 = '',
    @ssbwid ut_dm2 = NULL,
    @ssbw ut_mc32 = NULL,
    @crb VARCHAR(2) = NULL,
    @crbmc ut_mc32 = NULL,
    @sszh VARCHAR(6) = NULL,
    @sslx VARCHAR(2) = NULL,
    @yyxsu VARCHAR(1) = NULL,
    @ssly VARCHAR(1) = NULL,
    @zcbz VARCHAR(1) = NULL,
    @yygrbz VARCHAR(1) = NULL,
    @jrwmc VARCHAR(100) = '',
    @ylbz VARCHAR(1) = NULL,
    @sscxl ut_sl10 = NULL,
    @mzzybz VARCHAR(2) = NULL, --for 23218、22698 begin
    @rjssbz VARCHAR(2) = NULL,
    @mzfy VARCHAR(1) = NULL,
    @ssbfzdm VARCHAR(10) = NULL,
    @ssbfzmc VARCHAR(50) = NULL,
    @szblzdbm VARCHAR(10) = NULL,
    @szblzdmc VARCHAR(64) = NULL,
    @shblzdbm VARCHAR(10) = NULL,
    @shblzdmc VARCHAR(64) = NULL, --for 23218、22698 end
    --for 麻醉情况录入tab页  新增字段 by WQ
    @mzff2 VARCHAR(50) = NULL,
    @mzsb ut_dm2 = NULL,
    @sqhz ut_dm2 = NULL,
    @shsf ut_dm2 = NULL,
    @ttmz ut_dm2 = NULL,
    @mzsg ut_dm2 = NULL,
    @hyz ut_dm2 = NULL,
    @mzcc VARCHAR(50) = NULL,
    @mzh VARCHAR(50) = NULL,
    @jkxx VARCHAR(50) = NULL,
    @dylb INT = -1,
    @sqsfyy ut_dm2 = NULL,
    @kjyw ut_dm2 = NULL,
    @dg ut_dm2 = NULL,
    @mjbz VARCHAR(2) = NULL, --灭菌标志
    @mjff ut_mc32 = NULL, --灭菌方法
    @qjbh ut_mc32 = NULL, --腔镜编号
    @qjlx ut_mc32 = NULL, --腔镜类型
    @wcbz ut_bz = NULL, --微创标志
    @wjssbz ut_bz = NULL, --无菌手术标志
    @qxkssj ut_rq16 = NULL, --清洗开始时间  
    @qxjssj ut_rq16 = NULL, --清洗结束时间
    @qczrw ut_mc256 = NULL, --取出植入物
    @qcsl CHAR(2) = NULL, --数量
    @sxfy ut_mc64 = NULL, --输血反应
    @ssls ut_mc64 = NULL, --手术例数
    @qcfs VARCHAR(4) = NULL, --切除方式   
    @sybz ut_bz = NULL, --输液标志 
    @szcxcg ut_bz = NULL, --术中出血超过1500ml 
    @zjkjyw ut_bz = NULL, --追加抗菌药物
    @sszt VARCHAR(4) = NULL, --手术状态 -2'核对通过'-1'手术前' 0'未开始' 1'手术中'2'手术后'3'手术取消'4'出手术室'5'手术延迟' 
    ---add wq for 天津总院 2017-01-05  148209
    @xssmc ut_mc64 = NULL, --手术名称1
    @ssmc2 ut_mc64 = NULL, --手术名称2
    @ssmc3 ut_mc64 = NULL, --手术名称3
    @ssmc4 ut_mc64 = NULL, --手术名称4
    @ssmc5 ut_mc64 = NULL, --手术名称5
    --add wq for 天津 20170110  135972
    @shzdmc ut_mc64 = NULL, --术后诊断 
    @shzdmc1 ut_mc64 = NULL, --术后诊断1 
    @shzdmc2 ut_mc64 = NULL, --术后诊断1 
    @shzdmc3 ut_mc64 = NULL, --术后诊断1  
    @iszc INT = 0, --是否暂存,0不暂存
    --add wq 
    @sxly ut_mc64 = NULL, --输血来源
    @xuanhong_ztx ut_mc64 = NULL, --悬红     
    @xj_ztx ut_mc64 = NULL, --血浆     
    @xxb_ztx ut_mc64 = NULL, --血小板    
    @lcd_ztx ut_mc64 = NULL, --冷沉淀     
    @xuanhong_ytx ut_mc64 = NULL, --悬红     
    @xj_ytx ut_mc64 = NULL, --血浆     
    @xxb_ytx ut_mc64 = NULL, --血小板     
    @lcd_ytx ut_mc64 = NULL, --冷沉淀     
    @sqsfsykjyw ut_mc64 = NULL, --术前是否使用抗菌药物
    @zssj ut_rq16 = NULL, --输注时间
    @kjywmc ut_mc64 = NULL, --抗菌药物
    @fmzt ut_mc64 = NULL, --分娩镇疼
    @ssrykssj ut_rq16 = NULL, --手术人员开始时间
    @ssryjssj ut_rq16 = NULL,  --手术人员结束时间
	--add by panjunyi for 319041
	@ssdjdm2 ut_dm2='', --手术等级代码2
	@ssdjdm3 ut_dm2='', --手术等级代码3
	@ssdjdm4 ut_dm2='', --手术等级代码4
	@ssdjdm5 ut_dm2='', --手术等级代码5
	@ssdj ut_dm2='', --手术等级1
	@qkdj2 ut_mc32='',--切口等级2
	@qkdj3 ut_mc32='',--切口等级3
	@qkdj4 ut_mc32='',--切口等级4
	@qkdj5 ut_mc32='', --切口等级5
	@ssrq ut_mc32=NULL, --手术日期
	@xx1 ut_mc16=null, --血型
	@rh1 ut_mc16=null, --RH
	@xx2 ut_mc16=null, --血型
	@rh2 ut_mc16=null, --RH
	@blbb ut_mc16=NULL, --病理标本
	@gd ut_mc16=NULL, --管道
	@ssylg ut_mc16=NULL, --手术引流管
	@jbss ut_mc16=NULL, --加班手术
	@jrss ut_mc16=NULL, --介入手术
	@qcgj ut_mc16=NULL, --是否需取出工具
	@sxgj ut_mc32=NULL, --内固定取出物所需工具
	@ngdzrw ut_mc16=NULL, --内固定植入物
	@ngdzrwgs ut_mc16=NULL, --内固定植入物公司
	@sqdn ut_mc16=NULL, --术前导尿
	@kjywdm ut_dm12=NULL, --术前抗菌药物代码
	@jl1 ut_mc16=NULL, --剂量1
	@jldw1 ut_mc16=NULL, -- 剂量单位1
	@sqyysj ut_mc16=NULL, --术前用药时机
	@sqyycj ut_mc16=NULL, --术前用药场景
	@zjkjywdm ut_dm12=NULL, --追加抗菌药物代码
	@zjkjywmc ut_mc64=NULL, --追加抗菌药物名称
	@jl2 ut_mc16=NULL, --剂量2
	@jldw2 ut_mc16=NULL, --剂量单位2
	@szyysj ut_mc16=NULL, --术中用药时机
	@szyycj ut_mc16=NULL, --术中用药场景
	@sjyysj ut_rq16=NULL, --实际用药时间
	@qczrw1 ut_mc64=NULL, --取出植入物
	@qczrwsl ut_mc16=NULL, --取出植入物数量
	@crbmc2 ut_mc32=NULL, --传染病
	@kkss ut_mc16=NULL, --跨科手术
	@yyzt ut_mc16=NULL, --用药状态
	@wqzj ut_mc16=NULL, --外请专家
	@ssmc6 ut_ssmc=NULL, --手术名称6
	@ssmc7 ut_ssmc=NULL, --手术名称7
	@ssmc8 ut_ssmc=NULL, --手术名称8
	@ssmc9 ut_ssmc=NULL, --手术名称9
	@ssmc10 ut_ssmc=NULL, --手术名称10
	@ssmc11 ut_ssmc=NULL, --手术名称11
	@ssmc12 ut_ssmc=NULL, --手术名称12
	@ssmc13 ut_ssmc=NULL, --手术名称13
	@ssmc14 ut_ssmc=NULL, --手术名称14
	@ssmc15 ut_ssmc=NULL, --手术名称15
	@ssdm6 ut_xmdm='', --手术代码6
	@ssdm7 ut_xmdm='', --手术代码7
	@ssdm8 ut_xmdm='', --手术代码8
	@ssdm9 ut_xmdm='', --手术代码9
	@ssdm10 ut_xmdm='', --手术代码10
	@ssdm11 ut_xmdm='', --手术代码11
	@ssdm12 ut_xmdm='', --手术代码12
	@ssdm13 ut_xmdm='', --手术代码13
	@ssdm14 ut_xmdm='', --手术代码14
	@ssdm15 ut_xmdm='', --手术代码15
	@sszc1 VARCHAR(1)='', --手术主次1
	@sszc2 VARCHAR(1)='', --手术主次2
	@sszc3 VARCHAR(1)='', --手术主次3
	@sszc4 VARCHAR(1)='', --手术主次4
	@sszc5 VARCHAR(1)='', --手术主次5
	@sszc6 VARCHAR(1)='', --手术主次6
	@sszc7 VARCHAR(1)='', --手术主次7
	@sszc8 VARCHAR(1)='', --手术主次8
	@sszc9 VARCHAR(1)='', --手术主次9
	@sszc10 VARCHAR(1)='', --手术主次10
	@sszc11 VARCHAR(1)='', --手术主次11
	@sszc12 VARCHAR(1)='', --手术主次12
	@sszc13 VARCHAR(1)='', --手术主次13
	@sszc14 VARCHAR(1)='', --手术主次14
	@sszc15 VARCHAR(1)='', --手术主次15
	@ssys ut_mc64=NULL, --手术医生
	@sshs ut_mc64=NULL, --手术护士
	@lrczyxm ut_mc16=NULL, -- 录入操作员姓名
	@sfcs ut_mc16=NULL, --是否超时
	@qcfs2 ut_mc64=NULL,--切除方式2
	--add for 34996 40177
	@hzzy ut_mc16=NULL, --患者转运
	@ssfy ut_mc16=NULL, --手术费用
	@qkqk ut_mc16=NULL, --切口情况
	@ywzqtys ut_mc16=NULL, --有无知情同意书
	@ywsqxj ut_mc16=NULL, --有无术前小结
	@ywssbwbs ut_mc16=NULL, --有无手术部位标识
	@ssbwsfzq ut_mc16=NULL, --手术部位是否正确
	@sfhg ut_mc16=NULL, --是否合格
	@jcr ut_mc16=NULL, --检查人
	@jjss ut_bz=NULL, --紧急手术
	@xqss ut_bz=NULL, --限期手术
	@sqfs ut_mc16=NULL, --术前访视
	@aqjc ut_mc16=NULL --安全检查
AS
    /**********
[版本号]4.0.0.0.0
[创建时间]2004.12.06
[作者]朱伟杰
[版权] Copyright ? 2004-2008上海金仕达-卫宁软件股份有限公司[描述]  手术情况录入
[功能说明]
	手术情况录入(包括手术人员、术后诊断、手术结果)
[参数说明]
	@wkdz		网卡地址
	@jszt 		结束状态	1=创建表，2=插入，3=递交
	@czyh 		操作员号
	@ssxh 		手术序号
	@ssdm 		实际手术代码
	@mzdm 		实际麻醉代码
	@shzd 		术后诊断
	@shzd1 		术后诊断1
	@shzd2 		术后诊断2
	@shzd3 		术后诊断3
	@ksrq		开始时间
	@jsrq 		结束时间
	@bqsm 		病情说明
	@glbz 		隔离标志（0正常，1隔离，2放射）
    @slbz           顺利标志（0顺利，1不顺利）
	@qkdj 		切口等级
	@rydm 		医生代码
	@rylb 		医生类别
    @ssdjdm         手术等级代码 
    @sfsx           是否输血 （0输入  1不输入）
    @sqsfyy         术前是否用药（0是、1否）
    @kjyw            抗菌药物（ 0预防、1治疗、2预防+治疗）
    @isjb ut_bz =null 是否接班
	@isqj iu_bz =null 是否抢救
	@ssgl ut_dm4 手术自定义归类    

[返回值]

[结果集、排序]
	成功："T"
	错误："F","错误信息"


[调用的sp]

[调用实例]

**********/
    SET NOCOUNT ON;

    --生成递交的临时表
    DECLARE @tablename VARCHAR(32);
    SELECT @tablename = '##ssqklr' + @wkdz;
    DECLARE @config8262 VARCHAR(20),
            @config8264 VARCHAR(20);
    SELECT @config8262 = LTRIM(RTRIM(config))
      FROM YY_CONFIG
     WHERE id = '8262'; --手术名称修改后是否后台保存                   
    SELECT @config8264 = LTRIM(RTRIM(config))
      FROM YY_CONFIG
     WHERE id = '8264'; --手术情况录入界面的术后诊断修改后是否后台保存       
    DECLARE @jlzt_old ut_bz;
    IF (@iszc = 1)
        SELECT @jlzt_old = jlzt
          FROM SS_SSDJK
         WHERE xh = @ssxh;
    ELSE
        SELECT @jlzt_old = 2;

    IF @jszt = 1
    BEGIN
        EXEC ('if exists(select * from tempdb..sysobjects where name=''' + @tablename + ''')drop table ' + @tablename);
        EXEC ('create table ' + @tablename + '(
			rydm ut_czyh not null,
			rylb tinyint not null,
			isjb ut_bz null,
			kssj ut_rq16 NULL,
			jssj ut_rq16 NULL
			)');
        IF @@error <> 0
        BEGIN
            SELECT 'F',
                   0,
                   '创建临时表时出错！';
            RETURN;
        END;

    END;
    --插入递交的记录
    DECLARE @crylb CHAR(2);
    SELECT @crylb = CONVERT(CHAR(2), @rylb);
    DECLARE @cisjb CHAR(2);
    SELECT @cisjb = CONVERT(CHAR(2), @isjb);

    IF @jszt = 2
    BEGIN
        EXEC ('insert into ' + @tablename + ' values(''' + @rydm + ''',' + @crylb + ',' + @cisjb + ',''' + @ssrykssj + ''',''' + @ssryjssj + ''')');
        IF @@error <> 0
        BEGIN
            SELECT 'F',
                   0,
                   '插入临时表时出错！';
            RETURN;
        END;
    END;

    IF @jszt = 1
    OR @jszt = 2
    BEGIN
        SELECT 'T';
        RETURN;
    END;

    --开始处理流程
    CREATE TABLE #ssrytmp (
        rydm ut_czyh NOT NULL,
        rylb TINYINT NOT NULL,
        isjb ut_bz NULL,
        kssj ut_rq16 NULL,
        jssj ut_rq16 NULL);


    EXEC ('insert into #ssrytmp select * from ' + @tablename);
    IF @@error <> 0
    BEGIN
        SELECT 'F',
               0,
               '插入临时表时出错！';
        RETURN;
    END;
    EXEC ('drop table ' + @tablename);

    DECLARE @now  ut_rq16,
            @syxh ut_xh12,
            @mzmc ut_mc32, --麻醉名称
            @yzxh ut_xh12;

    SELECT @now = CONVERT(VARCHAR(8), GETDATE(), 112) + CONVERT(VARCHAR(8), GETDATE(), 8);

    IF @config8262 <> '是'
    BEGIN
        SELECT @xssmc = name
          FROM SS_SSMZK
         WHERE id = @xssdm
           AND lb = 0;
        IF @@rowcount = 0
        BEGIN
            SELECT 'F',
                   '手术1不存在！';
            RETURN;
        END;

        IF (@ssdm2 <> '')
        BEGIN
            SELECT @ssmc2 = name
              FROM SS_SSMZK
             WHERE id = @ssdm2
               AND lb = 0;
            IF @@rowcount = 0
            BEGIN
                SELECT 'F',
                       '手术2不存在！';
                RETURN;
            END;
        END;
        IF (@ssdm3 <> '')
        BEGIN
            SELECT @ssmc3 = name
              FROM SS_SSMZK
             WHERE id = @ssdm3
               AND lb = 0;
            IF @@rowcount = 0
            BEGIN
                SELECT 'F',
                       '手术3不存在！';
                RETURN;
            END;
        END;
        IF (@ssdm4 <> '')
        BEGIN
            SELECT @ssmc4 = name
              FROM SS_SSMZK
             WHERE id = @ssdm4
               AND lb = 0;
            IF @@rowcount = 0
            BEGIN
                SELECT 'F',
                       '手术4不存在！';
                RETURN;
            END;
        END;
        IF (@ssdm5 <> '')
        BEGIN
            SELECT @ssmc5 = name
              FROM SS_SSMZK
             WHERE id = @ssdm5
               AND lb = 0;
            IF @@rowcount = 0
            BEGIN
                SELECT 'F',
                       '手术5不存在！';
                RETURN;
            END;
        END;
    END;
    SELECT @mzmc = name
      FROM SS_SSMZK
     WHERE id = @mzdm
       AND lb = 1;
    IF @@rowcount = 0 AND @mzmc != ''
    BEGIN
        SELECT 'F',
               '这种麻醉不存在！';
        RETURN;
    END;

    BEGIN TRANSACTION;

    /*更新手术登记库*/
    DECLARE @yssdm ut_xmdm,
            @yssmc ut_mc32;
    SELECT @yssdm = yssdm,
           @yssmc = yssmc
      FROM SS_SSDJK
     WHERE xh = @ssxh;

    IF ( ( ( @yssdm = '')
       AND (@yssmc = ''))
      OR ( (@yssdm = NULL)
       AND (@yssmc = NULL)))
    BEGIN
        IF (@dylb = 1)
        BEGIN
            UPDATE SS_SSDJK
               SET @syxh = syxh,
                   @yzxh = yzxh,
                   djrq = (CASE
                                WHEN jlzt = 2 THEN djrq
                                ELSE @now END),
                   xssdm = @xssdm,
                   xssmc = @xssmc,
                   mzdm = @mzdm,
                   mzmc = @mzmc,
                   kssj = @kssj,
                   jssj = @jssj,
                   jlzt = @jlzt_old,
                   bqsm = @bqsm,
                   glbz = @glbz,
                   qkdj = @qkdj,
                   slbz = @slbz,
                   ssdjdm = @ssdjdm,
                   sfsx = @sfsx,
                   sqsfyy = @sqsfyy,
                   kjyw = @kjyw,
                   memo = @memo,
                   sstc = @sstc,
                   isqj = @isqj,
                   mzkssj = @mzkssj,
                   mzjssj = @mzjssj,
                   tw = @tw, -- add by gzy at 20041208
                   yssdm = @xssdm,
                   yssmc = @xssmc,
                   mzdm1 = @mzdm1,
                   mzdm2 = @mzdm2, ----add by cyh
                   mzjbdm = @mzjbdm,
                   ztfsdm = @ztfsdm,
                   ssgl = @ssgl,
                   ssfxpg = @ssfxpg,
                   ssbwlb = @ssbwlb,
                   xssdm2 = @ssdm2,
                   xssmc2 = @ssmc2,
                   xssdm3 = @ssdm3,
                   xssmc3 = @ssmc3,
                   xssdm4 = @ssdm4,
                   xssmc4 = @ssmc4,
                   xssdm5 = @ssdm5,
                   xssmc5 = @ssmc5,
                   bwid = @ssbwid,
                   ssbw = @ssbw,
                   crb = @crb,
                   crbmc = @crbmc,
                   dg = @dg, --add by weiqiang for 41811
                   mjbz = @mjbz,
                   mjff = @mjff,
                   qjbh = @qjbh,
                   qjlx = @qjlx, ----add by weiqiang for 51029
                   wcbz = @wcbz,
                   wjssbz = @wjssbz, ----add by weiqiang for 62514 2016-01-08
                   qxkssj = @qxkssj, --清洗开始时间
                   qxjssj = @qxjssj, --清洗结束时间
                   qczrw = @qczrw, --取出植入物
                   qcsl = @qcsl, --数量
                   sxfy = @sxfy, --输血反应
                   ssls = @ssls, --手术例数 
                   qcfs = @qcfs, --切除方式 
                   qcfs2 = @qcfs2, --切除方式2
                   sybz = @sybz, --输液标志
                   sszt = @sszt,
                   sxly = @sxly, --输血来源
                   xuanhong = @xuanhong_ztx, --悬红     
                   xj = @xj_ztx, --血浆     
                   xxb = @xxb_ztx, --血小板     
                   lcd = @lcd_ztx, --冷沉淀     
                   xuanhong2 = @xuanhong_ytx, --悬红     
                   xj2 = @xj_ytx, --血浆     
                   xxb2 = @xxb_ytx, --血小板     
                   lcd2 = @lcd_ytx, --冷沉淀
                   sqsfsykjyw = @sqsfsykjyw, --术前是否使用抗菌药物
                   zssj = @zssj, --输注时间
                   kjywmc = @kjywmc, --抗菌药物
                   fmzt = @fmzt, --分娩镇疼
				   ssdjdm2 = @ssdjdm2,
				   ssdjdm3 = @ssdjdm3,
				   ssdjdm4 = @ssdjdm4,
				   ssdjdm5 = @ssdjdm5,
				   ssdj = @ssdj,
				   qkdj2 = @qkdj2,
				   qkdj3 = @qkdj3,
				   qkdj4 = @qkdj4,
				   qkdj5 = @qkdj5,
				   ssrq = @ssrq,
				   xx1 = @xx1,
				   rh1 = @rh1,
				   xx2 = @xx2,
				   rh2 = @rh2,
				   blbb = @blbb,
				   gd = @gd,
				   ssylg = @ssylg,
				   jbss = @jbss,
				   jrss = @jrss,
				   qcgj = @qcgj,
				   sxgj = @sxgj,
				   ngdzrw = @ngdzrw,
				   ngdzrwgs = @ngdzrwgs,
				   sqdn = @sqdn,
				   kjywdm = @kjywdm,
				   jl1 = @jl1,
				   jldw1 = @jldw1,
				   sqyysj = @sqyysj,
				   sqyycj = @sqyycj,
				   zjkjywdm = @zjkjywdm,
				   zjkjywmc = @zjkjywmc,
				   jl2 = @jl2,
				   jldw2 = @jldw2,
				   szyysj = @szyysj,
				   szyycj = @szyycj,
				   sjyysj = @sjyysj,
				   qczrw1 = @qczrw1,
				   qczrwsl = @qczrwsl,
				   crbmc2 = @crbmc2,
				   kkss = @kkss,
				   yyzt = @yyzt,
				   wqzj = @wqzj,
				   xssmc6 = @ssmc6,
				   xssmc7 = @ssmc7,
				   xssmc8 = @ssmc8,
				   xssmc9 = @ssmc9,
				   xssmc10 = @ssmc10,
				   xssmc11 = @ssmc11,
				   xssmc12 = @ssmc12,
				   xssmc13 = @ssmc13,
				   xssmc14 = @ssmc14,
				   xssmc15 = @ssmc15,
				   xssdm6 = @ssdm6,
				   xssdm7 = @ssdm7,
				   xssdm8 = @ssdm8,
				   xssdm9 = @ssdm9,
				   xssdm10 = @ssdm10,
				   xssdm11 = @ssdm11,
				   xssdm12 = @ssdm12,
				   xssdm13 = @ssdm13,
				   xssdm14 = @ssdm14,
				   xssdm15 = @ssdm15,
				   sszc1 = @sszc1,
				   sszc2 = @sszc2,
				   sszc3 = @sszc3,
				   sszc4 = @sszc4,
				   sszc5 = @sszc5,
				   sszc6 = @sszc6,
				   sszc7 = @sszc7,
				   sszc8 = @sszc8,
				   sszc9 = @sszc9,
				   sszc10 = @sszc10,
				   sszc11 = @sszc11,
				   sszc12 = @sszc12,
				   sszc13 = @sszc13,
				   sszc14 = @sszc14,
				   sszc15 = @sszc15,
				   ssys = @ssys,
				   sshs = @sshs,
				   sslrczyxm = @lrczyxm,
				   sfcs = @sfcs,
				   hzzy = @hzzy,
				   ssfy = @ssfy,
				   qkqk = @qkqk,
				   ywzqtys = @ywzqtys,
				   ywsqxj = @ywsqxj,
				   ywssbwbs = @ywssbwbs,
				   ssbwsfzq = @ssbwsfzq,
				   sfhg = @sfhg,
				   jcr = @jcr,
				   sqfs = @sqfs,
				   aqjc = @aqjc
             WHERE xh = @ssxh;
        END;
        IF NOT EXISTS (SELECT 1
                         FROM SS_SSDJK_FZ a (NOLOCK),
                              SS_SSDJK b (NOLOCK)
                        WHERE a.ssxh = b.xh
                          AND a.ssxh = @ssxh)
        BEGIN
            INSERT INTO SS_SSDJK_FZ (ssxh,
                                     ssxgfj,
                                     mzxgfj,
                                     asaxgfj,
                                     mzfyqxgsj,
                                     ztsx,
                                     sshzt,
                                     mzfs,
                                     mzfspf,
                                     jzss,
                                     shsw,
                                     yc,
                                     dd,
                                     zc,
                                     yycw,
                                     sx,
                                     syfy,
                                     szywyl,
                                     zxjmjc,
                                     piccojc,
                                     ycdmyjc,
                                     mzbfz,
                                     zqss,
                                     fjhzcss,
                                     mzblsj,
                                     qkwrcd,
                                     rssj,
                                     cssj,
                                     sxss,
                                     jhssbz,
                                     ybbz,
                                     dkssbz,
                                     kssjdbz,
                                     fmssbz,
                                     xdssbz,
                                     qx,
                                     sszh,
                                     sslx,
                                     yyxsu,
                                     ssly,
                                     zcbz,
                                     yygrbz,
                                     jrwmc,
                                     ylbz,
                                     sscxl,
                                     mzzybz,
                                     rjssbz,
                                     mzfy,
                                     ssbfzdm,
                                     ssbfzmc,
                                     szblzdbm,
                                     szblzdmc,
                                     shblzdbm,
                                     shblzdmc, --for 23218、22698
                                     mzff2,
                                     mzsb,
                                     sqhz,
                                     shsf,
                                     ttmz,
                                     mzsg,
                                     hyz,
                                     mzcc,
                                     mzh,
                                     jkxx, --for麻醉情况录入tab页 新增字段  
                                     szcxcg,
                                     zjkjyw,
									 jjss,
									 xqss)
            VALUES (@ssxh,
                    @ssxgfj,
                    @mzxgfj,
                    @asaxgfj,
                    @mzfyqxgsj,
                    @ztsx,
                    @sshzt,
                    @mzfs,
                    @mzfspf,
                    @jzss,
                    @shsw,
                    @yc,
                    @dd,
                    @zc,
                    @yycw,
                    @sx,
                    @syfy,
                    @szywyl,
                    @zxjmjc,
                    @piccojc,
                    @ycdmyjc,
                    @mzbfz,
                    @zqss,
                    @fjhzcss,
                    @mzblsj,
                    @qkwrcd,
                    @rssj,
                    @cssj,
                    @sxss,
                    @jhssbz,
                    @ybbz,
                    @dkssbz,
                    @kssjdbz,
                    @fmssbz,
                    @xdssbz,
                    @qx,
                    @sszh,
                    @sslx,
                    @yyxsu,
                    @ssly,
                    @zcbz,
                    @yygrbz,
                    @jrwmc,
                    @ylbz,
                    @sscxl,
                    @mzzybz,
                    @rjssbz,
                    @mzfy,
                    @ssbfzdm,
                    @ssbfzmc,
                    @szblzdbm,
                    @szblzdmc,
                    @shblzdbm,
                    @shblzdmc, --for 23218、22698
                    @mzff2,
                    @mzsb,
                    @sqhz,
                    @shsf,
                    @ttmz,
                    @mzsg,
                    @hyz,
                    @mzcc,
                    @mzh,
                    @jkxx, --for麻醉情况录入tab页 新增字段
                    @szcxcg,
                    @zjkjyw,
					@jjss,
					@xqss);
        END;
        ELSE
        BEGIN
            UPDATE SS_SSDJK_FZ
               SET ssxgfj = @ssxgfj,
                   mzxgfj = @mzxgfj,
                   asaxgfj = @asaxgfj,
                   mzfyqxgsj = @mzfyqxgsj,
                   ztsx = @ztsx,
                   sshzt = @sshzt,
                   mzfs = @mzfs,
                   mzfspf = @mzfspf,
                   jzss = @jzss,
                   shsw = @shsw,
                   yc = @yc,
                   dd = @dd,
                   zc = @zc,
                   yycw = @yycw,
                   sx = @sx,
                   syfy = @syfy,
                   szywyl = @szywyl,
                   zxjmjc = @zxjmjc,
                   piccojc = @piccojc,
                   ycdmyjc = @ycdmyjc,
                   mzbfz = @mzbfz,
                   zqss = @zqss,
                   fjhzcss = @fjhzcss,
                   mzblsj = @mzblsj,
                   qkwrcd = @qkwrcd,
                   rssj = @rssj,
                   cssj = @cssj,
                   sxss = @sxss,
                   jhssbz = @jhssbz,
                   ybbz = @ybbz,
                   dkssbz = @dkssbz,
                   kssjdbz = @kssjdbz,
                   fmssbz = @fmssbz,
                   xdssbz = @xdssbz,
                   qx = @qx,
                   sszh = @sszh,
                   sslx = @sslx,
                   yyxsu = @yyxsu,
                   ssly = @ssly,
                   zcbz = @zcbz,
                   yygrbz = @yygrbz,
                   jrwmc = @jrwmc,
                   ylbz = @ylbz,
                   sscxl = @sscxl,
                   mzzybz = @mzzybz, --for 23218、22698 begin
                   rjssbz = @rjssbz,
                   mzfy = @mzfy,
                   ssbfzdm = @ssbfzdm,
                   ssbfzmc = @ssbfzmc,
                   szblzdbm = @szblzdbm,
                   szblzdmc = @szblzdmc,
                   shblzdbm = @shblzdbm,
                   shblzdmc = @shblzdmc, --for 23218、22698 end
                   mzff2 = @mzff2, --for 113237
                   szcxcg = @szcxcg, --术中出血超过1500ml 
                   zjkjyw = @zjkjyw, --追加抗菌药物 
				   jjss = @jjss,
				   xqss = @xqss
             WHERE ssxh = @ssxh;
        END;
    END;
    ELSE
    BEGIN
        IF (@dylb = 1)
        BEGIN
            UPDATE SS_SSDJK
               SET @syxh = syxh,
                   @yzxh = yzxh,
                   djrq = (CASE
                                WHEN jlzt = 2 THEN djrq
                                ELSE @now END),
                   xssdm = @xssdm,
                   xssmc = @xssmc,
                   mzdm = @mzdm,
                   mzmc = @mzmc,
                   kssj = @kssj,
                   jssj = @jssj,
                   jlzt = @jlzt_old,
                   bqsm = @bqsm,
                   glbz = @glbz,
                   qkdj = @qkdj,
                   slbz = @slbz,
                   ssdjdm = @ssdjdm,
                   sfsx = @sfsx,
                   sqsfyy = @sqsfyy,
                   kjyw = @kjyw,
                   memo = @memo,
                   sstc = @sstc,
                   isqj = @isqj,
                   mzkssj = @mzkssj,
                   mzjssj = @mzjssj,
                   tw = @tw, -- add by gzy at 20041208
                   mzdm1 = @mzdm1,
                   mzdm2 = @mzdm2, ----add by cyh
                   mzjbdm = @mzjbdm,
                   ztfsdm = @ztfsdm,
                   ssgl = @ssgl,
                   ssfxpg = @ssfxpg,
                   ssbwlb = @ssbwlb,
                   xssdm2 = @ssdm2,
                   xssmc2 = @ssmc2,
                   xssdm3 = @ssdm3,
                   xssmc3 = @ssmc3,
                   xssdm4 = @ssdm4,
                   xssmc4 = @ssmc4,
                   xssdm5 = @ssdm5,
                   xssmc5 = @ssmc5,
                   bwid = @ssbwid,
                   ssbw = @ssbw,
                   crb = @crb,
                   crbmc = @crbmc,
                   dg = @dg, --add by weiqiang for 41811 
                   mjbz = @mjbz,
                   mjff = @mjff,
                   qjbh = @qjbh,
                   qjlx = @qjlx, ----add by weiqiang for 51029
                   wcbz = @wcbz,
                   wjssbz = @wjssbz, ----add by weiqiang for 62514 2016-01-08    
                   qxkssj = @qxkssj, --清洗开始时间
                   qxjssj = @qxjssj, --清洗结束时间
                   qczrw = @qczrw, --取出植入物
                   qcsl = @qcsl, --数量
                   sxfy = @sxfy, --输血反应
                   ssls = @ssls, --手术例数 
                   qcfs = @qcfs, --切除方式 
                   qcfs2 = @qcfs2, --切除方式 2 
                   sybz = @sybz, --输液标志
                   sszt = @sszt,
                   sxly = @sxly, --输血来源
                   xuanhong = @xuanhong_ztx, --悬红    
                   xj = @xj_ztx, --血浆    
                   xxb = @xxb_ztx, --血小板    
                   lcd = @lcd_ztx, --冷沉淀    
                   xuanhong2 = @xuanhong_ytx, --悬红    
                   xj2 = @xj_ytx, --血浆    
                   xxb2 = @xxb_ytx, --血小板    
                   lcd2 = @lcd_ytx, --冷沉淀    
                   sqsfsykjyw = @sqsfsykjyw, --术前是否使用抗菌药物
                   zssj = @zssj, --输注时间
                   kjywmc = @kjywmc, --抗菌药物
                   fmzt = @fmzt, --分娩镇疼
				   ssdjdm2 = @ssdjdm2,
				   ssdjdm3 = @ssdjdm3,
				   ssdjdm4 = @ssdjdm4,
				   ssdjdm5 = @ssdjdm5,
				   ssdj = @ssdj,
				   qkdj2 = @qkdj2,
				   qkdj3 = @qkdj3,
				   qkdj4 = @qkdj4,
				   qkdj5 = @qkdj5,
				   ssrq = @ssrq,
				   xx1 = @xx1,
				   rh1 = @rh1,
				   xx2 = @xx2,
				   rh2 = @rh2,
				   blbb = @blbb,
				   gd = @gd,
				   ssylg = @ssylg,
				   jbss = @jbss,
				   jrss = @jrss,
				   qcgj = @qcgj,
				   sxgj = @sxgj,
				   ngdzrw = @ngdzrw,
				   ngdzrwgs = @ngdzrwgs,
				   sqdn = @sqdn,
				   kjywdm = @kjywdm,
				   jl1 = @jl1,
				   jldw1 = @jldw1,
				   sqyysj = @sqyysj,
				   sqyycj = @sqyycj,
				   zjkjywdm = @zjkjywdm,
				   zjkjywmc = @zjkjywmc,
				   jl2 = @jl2,
				   jldw2 = @jldw2,
				   szyysj = @szyysj,
				   szyycj = @szyycj,
				   sjyysj = @sjyysj,
				   qczrw1 = @qczrw1,
				   qczrwsl = @qczrwsl,
				   crbmc2 = @crbmc2,
				   kkss = @kkss,
				   yyzt = @yyzt,
				   wqzj = @wqzj,
				   xssmc6 = @ssmc6,
				   xssmc7 = @ssmc7,
				   xssmc8 = @ssmc8,
				   xssmc9 = @ssmc9,
				   xssmc10 = @ssmc10,
				   xssmc11 = @ssmc11,
				   xssmc12 = @ssmc12,
				   xssmc13 = @ssmc13,
				   xssmc14 = @ssmc14,
				   xssmc15 = @ssmc15,
				   xssdm6 = @ssdm6,
				   xssdm7 = @ssdm7,
				   xssdm8 = @ssdm8,
				   xssdm9 = @ssdm9,
				   xssdm10 = @ssdm10,
				   xssdm11 = @ssdm11,
				   xssdm12 = @ssdm12,
				   xssdm13 = @ssdm13,
				   xssdm14 = @ssdm14,
				   xssdm15 = @ssdm15,
				   sszc1 = @sszc1,
				   sszc2 = @sszc2,
				   sszc3 = @sszc3,
				   sszc4 = @sszc4,
				   sszc5 = @sszc5,
				   sszc6 = @sszc6,
				   sszc7 = @sszc7,
				   sszc8 = @sszc8,
				   sszc9 = @sszc9,
				   sszc10 = @sszc10,
				   sszc11 = @sszc11,
				   sszc12 = @sszc12,
				   sszc13 = @sszc13,
				   sszc14 = @sszc14,
				   sszc15 = @sszc15,
				   ssys = @ssys,
				   sshs = @sshs,
				   sslrczyxm = @lrczyxm,
				   sfcs = @sfcs,
				   hzzy = @hzzy,
				   ssfy = @ssfy,
				   qkqk = @qkqk,
				   ywzqtys = @ywzqtys,
				   ywsqxj = @ywsqxj,
				   ywssbwbs = @ywssbwbs,
				   ssbwsfzq = @ssbwsfzq,
				   sfhg = @sfhg,
				   jcr = @jcr,
				   sqfs = @sqfs,
				   aqjc = @aqjc
             WHERE xh = @ssxh;
        END;
        IF NOT EXISTS (SELECT 1
                         FROM SS_SSDJK_FZ a (NOLOCK),
                              SS_SSDJK b (NOLOCK)
                        WHERE a.ssxh = b.xh
                          AND a.ssxh = @ssxh)
        BEGIN
            INSERT INTO SS_SSDJK_FZ (ssxh,
                                     ssxgfj,
                                     mzxgfj,
                                     asaxgfj,
                                     mzfyqxgsj,
                                     ztsx,
                                     sshzt,
                                     mzfs,
                                     mzfspf,
                                     jzss,
                                     shsw,
                                     yc,
                                     dd,
                                     zc,
                                     yycw,
                                     sx,
                                     syfy,
                                     szywyl,
                                     zxjmjc,
                                     piccojc,
                                     ycdmyjc,
                                     mzbfz,
                                     zqss,
                                     fjhzcss,
                                     mzblsj,
                                     qkwrcd,
                                     rssj,
                                     cssj,
                                     sxss,
                                     jhssbz,
                                     ybbz,
                                     dkssbz,
                                     kssjdbz,
                                     fmssbz,
                                     xdssbz,
                                     qx,
                                     sszh,
                                     sslx,
                                     yyxsu,
                                     ssly,
                                     zcbz,
                                     yygrbz,
                                     jrwmc,
                                     ylbz,
                                     sscxl,
                                     mzzybz,
                                     rjssbz,
                                     mzfy,
                                     ssbfzdm,
                                     ssbfzmc,
                                     szblzdbm,
                                     szblzdmc,
                                     shblzdbm,
                                     shblzdmc, --for 23218、22698
                                     mzff2,
                                     mzsb,
                                     sqhz,
                                     shsf,
                                     ttmz,
                                     mzsg,
                                     hyz,
                                     mzcc,
                                     mzh,
                                     jkxx, --for麻醉情况录入tab页 新增字段  39988
                                     szcxcg,
                                     zjkjyw,
									 jjss,
									 xqss)
            VALUES (@ssxh,
                    @ssxgfj,
                    @mzxgfj,
                    @asaxgfj,
                    @mzfyqxgsj,
                    @ztsx,
                    @sshzt,
                    @mzfs,
                    @mzfspf,
                    @jzss,
                    @shsw,
                    @yc,
                    @dd,
                    @zc,
                    @yycw,
                    @sx,
                    @syfy,
                    @szywyl,
                    @zxjmjc,
                    @piccojc,
                    @ycdmyjc,
                    @mzbfz,
                    @zqss,
                    @fjhzcss,
                    @mzblsj,
                    @qkwrcd,
                    @rssj,
                    @cssj,
                    @sxss,
                    @jhssbz,
                    @ybbz,
                    @dkssbz,
                    @kssjdbz,
                    @fmssbz,
                    @xdssbz,
                    @qx,
                    @sszh,
                    @sslx,
                    @yyxsu,
                    @ssly,
                    @zcbz,
                    @yygrbz,
                    @jrwmc,
                    @ylbz,
                    @sscxl,
                    @mzzybz,
                    @rjssbz,
                    @mzfy,
                    @ssbfzdm,
                    @ssbfzmc,
                    @szblzdbm,
                    @szblzdmc,
                    @shblzdbm,
                    @shblzdmc, --for 23218、22698
                    @mzff2,
                    @mzsb,
                    @sqhz,
                    @shsf,
                    @ttmz,
                    @mzsg,
                    @hyz,
                    @mzcc,
                    @mzh,
                    @jkxx, --for麻醉情况录入tab页 新增字段  39988
                    @szcxcg,
                    @zjkjyw,
					@jjss,
					@xqss);
        END;
        ELSE
        BEGIN
            UPDATE SS_SSDJK_FZ
               SET ssxgfj = @ssxgfj,
                   mzxgfj = @mzxgfj,
                   asaxgfj = @asaxgfj,
                   mzfyqxgsj = @mzfyqxgsj,
                   ztsx = @ztsx,
                   sshzt = @sshzt,
                   mzfs = @mzfs,
                   mzfspf = @mzfspf,
                   jzss = @jzss,
                   shsw = @shsw,
                   yc = @yc,
                   dd = @dd,
                   zc = @zc,
                   yycw = @yycw,
                   sx = @sx,
                   syfy = @syfy,
                   szywyl = @szywyl,
                   zxjmjc = @zxjmjc,
                   piccojc = @piccojc,
                   ycdmyjc = @ycdmyjc,
                   mzbfz = @mzbfz,
                   zqss = @zqss,
                   fjhzcss = @fjhzcss,
                   mzblsj = @mzblsj,
                   qkwrcd = @qkwrcd,
                   rssj = @rssj,
                   cssj = @cssj,
                   sxss = @sxss,
                   jhssbz = @jhssbz,
                   ybbz = @ybbz,
                   dkssbz = @dkssbz,
                   kssjdbz = @kssjdbz,
                   fmssbz = @fmssbz,
                   xdssbz = @xdssbz,
                   qx = @qx,
                   sszh = @sszh,
                   sslx = @sslx,
                   yyxsu = @yyxsu,
                   ssly = @ssly,
                   zcbz = @zcbz,
                   yygrbz = @yygrbz,
                   jrwmc = @jrwmc,
                   ylbz = @ylbz,
                   sscxl = @sscxl,
                   mzzybz = @mzzybz, --for 23218、22698 begin
                   rjssbz = @rjssbz,
                   mzfy = @mzfy,
                   ssbfzdm = @ssbfzdm,
                   ssbfzmc = @ssbfzmc,
                   szblzdbm = @szblzdbm,
                   szblzdmc = @szblzdmc,
                   shblzdbm = @shblzdbm,
                   shblzdmc = @shblzdmc, --for 23218、22698 end
                   mzff2 = @mzff2, --for 113237
                   szcxcg = @szcxcg, --术中出血超过1500ml 
                   zjkjyw = @zjkjyw, --追加抗菌药物
				   jjss = @jjss,
				   xqss = @xqss
             WHERE ssxh = @ssxh;
        END;
    END;

    IF @@error <> 0
    BEGIN
        ROLLBACK TRANSACTION;
        SELECT 'F',
               '手术记录出错！';
        RETURN;
    END;

    /*记录术后诊断*/
    IF @shzd IS NOT NULL
    OR LTRIM(RTRIM(@shzd)) <> ''
    BEGIN
        DELETE SS_SSZDK
         WHERE ssxh = @ssxh
           AND zdlb = 1;
        IF @@error <> 0
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 'F',
                   '记录术后诊断出错!';
            RETURN;
        END;
        IF @config8264 <> '是'
            INSERT SS_SSZDK (ssxh,
                             zdlb,
                             zdlx,
                             zddm,
                             zdmc,
                             memo)
            SELECT @ssxh,
                   1,
                   0,
                   id,
                   name,
                   NULL
              FROM YY_ZDDMK
             WHERE id = @shzd;
        ELSE
            INSERT SS_SSZDK (ssxh,
                             zdlb,
                             zdlx,
                             zddm,
                             zdmc,
                             memo)
            VALUES (@ssxh, 1, 0, @shzd, @shzdmc, NULL);
        IF @@error <> 0
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 'F',
                   '记录术后诊断出错!';
            RETURN;
        END;
    END;

    IF @shzd1 IS NOT NULL
    OR LTRIM(RTRIM(@shzd1)) <> ''
    BEGIN
        IF @config8264 <> '是'
            INSERT SS_SSZDK (ssxh,
                             zdlb,
                             zdlx,
                             zddm,
                             zdmc,
                             memo)
            SELECT @ssxh,
                   1,
                   1,
                   id,
                   name,
                   NULL
              FROM YY_ZDDMK
             WHERE id = @shzd1;
        ELSE
            INSERT SS_SSZDK (ssxh,
                             zdlb,
                             zdlx,
                             zddm,
                             zdmc,
                             memo)
            VALUES (@ssxh, 1, 1, @shzd1, @shzdmc1, NULL);
        IF @@error <> 0
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 'F',
                   '记录术后诊断1出错!';
            RETURN;
        END;
    END;

    IF @shzd2 IS NOT NULL
    OR LTRIM(RTRIM(@shzd2)) <> ''
    BEGIN
        IF @config8264 <> '是'
            INSERT SS_SSZDK (ssxh,
                             zdlb,
                             zdlx,
                             zddm,
                             zdmc,
                             memo)
            SELECT @ssxh,
                   1,
                   2,
                   id,
                   name,
                   NULL
              FROM YY_ZDDMK
             WHERE id = @shzd2;
        ELSE
            INSERT SS_SSZDK (ssxh,
                             zdlb,
                             zdlx,
                             zddm,
                             zdmc,
                             memo)
            VALUES (@ssxh, 1, 2, @shzd2, @shzdmc2, NULL);
        IF @@error <> 0
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 'F',
                   '记录术后诊断2出错!';
            RETURN;
        END;
    END;

    IF @shzd3 IS NOT NULL
    OR LTRIM(RTRIM(@shzd3)) <> ''
    BEGIN
        IF @config8264 <> '是'
            INSERT SS_SSZDK (ssxh,
                             zdlb,
                             zdlx,
                             zddm,
                             zdmc,
                             memo)
            SELECT @ssxh,
                   1,
                   3,
                   id,
                   name,
                   NULL
              FROM YY_ZDDMK
             WHERE id = @shzd3;
        ELSE
            INSERT SS_SSZDK (ssxh,
                             zdlb,
                             zdlx,
                             zddm,
                             zdmc,
                             memo)
            VALUES (@ssxh, 1, 3, @shzd3, @shzdmc3, NULL);
        IF @@error <> 0
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 'F',
                   '记录术后诊断3出错!';
            RETURN;
        END;
    END;

    DELETE SS_SSRYK
     WHERE ssxh = @ssxh;
    IF @@error <> 0
    BEGIN
        SELECT 'F',
               '录入手术人员时出错！';
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    INSERT INTO SS_SSRYK (ssxh,
                          rylb,
                          rydm,
                          ryxm,
                          memo,
                          isjb,
                          kssj,
                          jssj)
    SELECT @ssxh,
           a.rylb,
           a.rydm,
           b.name,
           NULL,
           a.isjb,
           a.kssj,
           a.jssj
      FROM #ssrytmp a inner join YY_ZGBMK b on b.id = a.rydm;
    IF @@error <> 0
    BEGIN
        SELECT 'F',
               '录入手术人员时出错！';
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    UPDATE BQ_LSYZK
       SET yzzt = 2
     WHERE syxh = @syxh
       AND xh   = @yzxh;
    IF @@error <> 0
    BEGIN
        SELECT 'F',
               '手术记录时出错！';
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    COMMIT TRAN;
    SELECT 'T';


GO