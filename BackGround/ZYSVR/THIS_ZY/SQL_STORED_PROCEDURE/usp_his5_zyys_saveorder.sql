Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE proc usp_his5_zyys_saveorder      
                        @wkdz varchar(32),      
                        @jszt smallint,      
                        @v5xh ut_xh12,      
                        @syxh ut_syxh,      
                        @czyh ut_czyh,      
                        @fzbz int,      
                        @ysdm ut_czyh,      
                        @yzlb int,      
                        @ksrq ut_rq16,      
                        @xmlb int,      
                        @idm ut_xh9,      
                        @ypdm ut_xmdm,      
                        @yfdm ut_ksdm,      
                        @ypjl ut_sl14_3,      
                        @jldw ut_unit,      
                        @dwlb smallint,      
                        @ypyf ut_dm2,      
                        @yznr ut_mc256,      
                        @ztnr ut_mc64,      
                        @pcdm ut_dm2,      
                        @zdm char(7),      
                        @zxsj ut_mc256,      
                        @zbybz smallint = 0,      
                        @dybz smallint = 0,      
                        @xmdj numeric(12, 2) = null,      
                        @tzxh ut_xh12 = null,      
                        @jsrq ut_rq16 = null,      
                        @mzdm ut_xmdm = null,      
                        @yjqrbz smallint = 0,      
                        @zdys ut_czyh = null,      
                        @yyzxh ut_xh12 = -1,      
                        @yfzxh ut_xh12 = -1,      
                        @hzxm ut_mc64 = '',      
                        @yexh ut_syxh = 0,      
                        @mzxdfh ut_xh12 = 0      
                        , @njjbz ut_bz = -1      
                        , @ybshbz ut_bz = 0      
                        , @ybspbh ut_mc32 = ''      
                        , @sqzd ut_zddm = ''      
                        , @sstyz ut_bz = 0      
                        , @lzbz ut_bz = 0      
                        , @sxysbz ut_bz = 0      
                        , @lcxmdm ut_xmdm = '0'      
                        , @ssmc ut_mc256 = ''      
                        , @sybpno ut_xh12 = 0      
                        , @systype ut_bz = 0      
                        , @wzyzmc varchar(255) = ''      
                        , @ldpcbz ut_bz = 0      
                        , @yzlbdy ut_bz = -1      
                        , @jzbz ut_bz = 0      
                        , @blzbz ut_bz = 0      
                        , @sqddm int = 0      
                        , @yypdm ut_xmdm = ''      
                        , @ypgg ut_mc32 = ''      
                        , @kjslx ut_bz = 0      
                        , @kjsbz ut_bz = 0      
                        , @kjsssyz ut_xh12 = 0      
                        , @jajbz ut_bz = 0      
                        , @xzbz ut_bz = 0      
                        , @zddm ut_zddm = ''      
                        , @zjlx ut_bz = 0      
                        , @zjhm varchar(20) = ''      
                        , @Jsdmbz ut_bz = 0      
                        , @zxksdm ut_ksdm = '' --申请单执行科室      
                        , @sqdbbid ut_dm4 = '' --申请单医嘱项目标本代码      
                        , @sqdbbzl ut_mc64 = '' --申请单医嘱项目标本名称      
                        , @yyts ut_bz = 0  --出院带药的用药天数     
                        , @ypsl ut_sl10 = 0  --出院带药专用的数量     
                        , @zfybz ut_bz = 0      --自费药标记 0 不是自费药 1 自费药（对于 甲 乙 类药 医生选择 为自费处理时）aorigele 2013/7/4    
                        , @kzzd varchar(1000)='' --扩展字段，以后不允许再增加字段，后期字段拼接在@kzzd 中传入 分隔符 | aorigele 2013/7/18    
                        as      
                        /*****************      
                        [版本号]5.0.0.0.0      
                        [创建时间]2012.09.01      
                        [作者]吴铭         
                        [版权]Copyright ? 2004 - 2012 上海金仕达 - 卫宁软件股份有限公司      
                        [描述]医嘱录入      
                        [功能说明]      
                        医嘱录入      
         [参数说明]      
                        @wkdz varchar(32), 网卡地址      
                        @jszt smallint, 结束状态1 = 创建表，2 = 插入，3 = 递交      
   @v5xh ut_xh12, 5.0 医嘱序号      
                        @syxh ut_syxh, 首页序号      
                        @czyh ut_czyh, 操作员号      
                        @fzbz int, 分组标志 每组医嘱标志不同      
                        @ysdm ut_czyh, 医生代码      
                        @yzlb smallint, 医嘱类别 0: 临时医嘱，1：长期医嘱，2：临时医嘱用法材料，3：长期医嘱用法材料      
                        @ksrq ut_rq16, 医嘱的开始时间      
                        @xmlb smallint, 项目类别 0: 药品医嘱，1：非药品医嘱，2: 手术医嘱，8: 输液医嘱，9: 停止医嘱      
                        @idm ut_xh9, 产地idm，非药品为0      
                        @ypdm ut_xmdm, 药品代码或治疗项目代码      
                        @yfdm ut_ksdm, 药房代码      
                        @ypjl ut_sl14_3, 药品剂量或治疗项目的数量      
                        @jldw ut_unit, 剂量单位      
                        @dwlb smallint, 单位类别0剂量单位，3住院单位      
                        @ypyf ut_dm2, 用法代码      
                        @yznr ut_mc256, 医嘱内容      
                        @ztnr ut_mc64, 医生嘱托      
                        @pcdm ut_dm2, 医嘱执行频次代码      
                        @zdm char(7), 周标志（周一到周七用1234567表示）      
                        @zxsj ut_mc256, 医嘱执行时间      
                        @zbybz smallint = 0, 0: 普通，1: 自备药品，2: PRN      
                        @dybz smallint = 0, 0: 打印，1: 不打印      
                        @xmdj numeric(12, 2) = null, 零单价项目的单价      
                        @tzxh ut_xh12 = null, 停止医嘱序号      
                        @jsrq ut_rq16 = null, 长期医嘱停止时间      
                        @mzdm ut_xmdm = null, 麻醉代码      
                        @yjqrbz smallint = 0 医技确认标志      
                        @zdys ut_czyh = null 主刀医生      
                        @yyzxh ut_xh12 = -1,      
                        @yfzxh ut_xh12 = -1, --增加了原医嘱的序号和分组序号      
                        @hzxm ut_mc64 = '', --患者姓名,      
                        @yexh ut_syxh = 0 --婴儿序号      
                        @mzxdfh ut_xh12 = 0 --麻醉协定方序号      
                        @njjbz ut_bz = -1 --配伍禁忌标志      
                        , @ybshbz ut_bz = 0 --医保审核志0不用审核1审核通过2审核不通过      
                        , @ybspbh ut_mc32 = null --医保审批编号      
                        , @sqzd ut_zddm = '' --术前诊断      
                        , @sstyz ut_bz = 0 --手术停医嘱      
                        , @lzbz ut_bz = 0 --临嘱标志      
                        , @sxysbz ut_bz = 0 --实习医生标志0: 普通1: 表示是实习医生，开的医嘱需要审核2: 审核实习医生开的医嘱      
                        , @lcxmdm ut_xmdm = '0' --临床项目代码      
                        , @ssmc ut_mc256 = '' --手术名称      
                        , @systype ut_bz = 0 --系统标志 0 住院医生 1 护士站加以区分当前是医生调用还是护士调用      
                        , @ldpcbz --联动频次标志 0 主医嘱的 1 项目联动自带频次      
                        , @yzlbdy --医嘱类别对应      
                        , @blzbz ut_bz = 0 补临嘱标志，如果为1代表是前台选择补临嘱的临时医嘱      
                        , @sqddm int 申请单表单代码      
                        , @kjslx ut_bz = 0 --抗菌素类型（0普通1预防性2治疗性）      
                        , @kjsbz ut_bz = 0 --抗菌素明细标志（0非抗菌素1抗菌素2默认溶媒3可选溶媒）      
                        , @kjsssyz ut_xh12 = 0 --抗菌素对应手术医嘱序号      
                        @zddm ut_zddm = '', 诊断代码      
                        @zjlx ut_bz = 0, 证件类型      
                        @zjhm varchar(20) = '' 证件号码      
                        @Jsdmbz --精神毒麻标志      
                        , @yyts ut_bz = 0 --出院带药的用药天数     
                         , @ypsl ut_sl10 = 0  --出院带药专用的数量      
                        [返回值]      
                        [结果集、排序]      
                        [调用的sp]      
                        [调用实例]    
                        [修改记录]    
                        bug9512--停长期医嘱生成多条停的临时医嘱      
                        bug10597---HP44为否时，出院带药金额算错了    
                        需求10322--CIS新增医嘱类别造成医嘱流程断了(本次封板处理)    
                        bug10726--出院带药冻结药品    
                        需求899--术中医嘱流程    
                        bug17535--药品规格与剂量+单位相同时,发送his后医嘱内容规格和剂量单位全部被过滤了    
  需求 22068:【手术申请单】增加特殊感染说明    
                 需求 25480:奉贤中心医院--手术申请单流程    
                        Bug 25934:25480-录入手术生成文字医嘱了发送过去yzlb传过去1 ，ypmc也传下    
                         Bug 26872:需求26061合并现场存储过程    
                         Bug 30290:需求29274-HP295 打开后插入的 BQ_LSYZK_FZ没有ssksdm ssxh的    
                         需求:15881-术中医嘱指定执行时间    
                         需求：48009  仙居县人民医院---急诊手术    
                         Bug 68399 1601-HP176设置的和实际效果相反    
                         需求 57377 宿迁市第一人民医院剂量扩展单位同步    
                    **********************/      
                    --set  nocount on      
                    --set ansi_defaults off    
                    --生成递交的临时表      
                        declare  @tablename varchar(32)      
                        declare @xcfhssh  varchar(32)     
                        select  @tablename = '##ysgzzyzlr' + @wkdz --+ @czyh 否则前台抗菌素换工号会导致报错   
						                     

                    if @jszt = 1      
                    begin      
                        exec('if exists(select  * from tempdb..sysobjects where name=''' + @tablename + ''')      
                            drop table '+@tablename)      
                            exec('create table ' + @tablename + '(      
                            lrxh int IDENTITY(1, 1),      
                            v5xh ut_xh12 null,      
                            fzbz int not null,      
                            ysdm ut_czyh not null,      
                            yzlb int not null,      
                            ksrq ut_rq16 not null,      
                            xmlb int not null,      
                            idm ut_xh9 not null,      
                            ypdm ut_xmdm not null,      
                            yfdm ut_ksdm not null,      
                            ypjl ut_sl14_3 not null,      
                            jldw ut_unit null,      
                            dwlb smallint not null,      
                            ypyf ut_dm2 null,      
                            yznr ut_mc256 null,      
                            ztnr ut_mc64 null,      
                            pcdm ut_dm2 not null,      
                            zdm char(7)null,      
                            zxsj ut_mc256 null,      
                            zbybz smallint not null,      
                            dybz smallint not null,      
                            xmdj numeric(12, 2)null,      
                            tzxh ut_xh12 null,      
                            jsrq ut_rq16 null,      
                            mzdm ut_xmdm null,      
                            yjqrbz smallint not null,      
                            zdys ut_czyh null,      
                            yyzxh ut_xh12 null,      
                            yfzxh ut_xh12 null,      
                            hzxm ut_mc64 not null,      
                            yexh ut_syxh not null,      
                            mzxdfh ut_xh12 null,      
                            jjbz ut_bz null      
                            , ybshbz ut_bz null      
                            , ybspbh ut_mc32 null      
                            , sqzd ut_zddm null      
                            , sstyz ut_bz null      
                            , lzbz ut_bz null      
                            , lcxmdm ut_xmdm null      
                            , ssmc ut_mc256 null      
                            , sybpno ut_xh12 null      
                            , systype ut_bz null      
                            , wzyzmc varchar(255)      
                            , ldpcbz ut_bz null   
          , yzlbdy ut_bz null      
                            , jzbz ut_bz null      
                            , blzbz ut_bz null      
                            , sqddm int null      
                            , yypdm ut_xmdm null      
                            , ypgg ut_mc32 null      
                            , kjslx ut_bz null      
                            , kjsbz ut_bz null      
   , kjsssyz ut_xh12 null      
                            , jajbz ut_bz null      
                            , zddm ut_zddm null      
                            , zjlx ut_bz null      
                            , zjhm varchar(20)null      
                            , Jsdmbz ut_bz null      
                            , fjdwxs ut_dwxs null      
                            , zxksdm ut_ksdm null      
                            , sqdbbid ut_dm4 null      
                            , sqdbbzl ut_mc64 null      
                            , yyts ut_bz null      
                            , ypsl ut_sl10  null    
                            , zfybz ut_bz  null    
                            , sqgyfl ut_bz null    
                            , szyzbz ut_bz null      
                            , ssxh ut_xh12 null      
                            , sqdxmbz ut_mc64 null     
                            , sqbz ut_bz null     
                            , zxrq ut_rq16 null      
                            --,zpdf utInt    
                            , tcwbz ut_bz null    
                            , kzdw ut_bz   null    
                            ,drsssbz ut_bz     
                            ,sssksdm ut_ksdm null    
                            )')      
                            if @@error <> 0      
                            begin      
                                select  'F', '创建临时表时出错！'      
                                    return      
                            end      
                            --申请单自定义收费处理    
       declare @result1 varchar(8),@msg1 ut_mc256    
        exec usp_his5_zyys_saveordercharge @wkdz=@wkdz,@jszt=1,@result=@result1 output,@msg=@msg1 output    
        if @result1='F'    
        begin    
        select @result1,@msg1    
        return    
        end    
      
                            select  'T1'      
                                return      
                    end      
                    --插入递交的记录      
                    if @jszt = 2      
                    begin      
                        declare  @cfzbz varchar(8),      
                            @cv5xh varchar(12),      
                            @cyzlb varchar(3),      
                            @cxmlb varchar(3),      
                            @cidm varchar(9),      
                            @cypjl varchar(14),      
                            @cdwlb varchar(2),      
                            @czbybz varchar(2),      
                            @cdybz varchar(2),      
                            @cxmdj varchar(12),      
                            @ctzxh varchar(12),      
                            @cyjqrbz varchar(2),      
                            @cyyzxh varchar(12),      
                            @cyfzxh varchar(12),      
                            @cyexh varchar(12),      
                            @cmzxdfh varchar(12),      
                            @cjjbz varchar(2),      
                            @cybshbz varchar(2),      
                            @cybspbh varchar(32)      
                            , @csstyz varchar(2)      
                            , @clzbz varchar(2)      
                            , @csybpno varchar(12)      
                            , @csystype varchar(2)      
                            , @cwzyzmc varchar(255)      
                            , @csqddm varchar(10)      
                            , @cyypdm ut_xmdm 
, @cldpcbz varchar(2) --连动频次标志      
                            , @cyzlbdy varchar(9)      
                            , @cjzbz varchar(2)      
                            , @cblzbz varchar(2) --补临嘱标志      
                            , @config6139 varchar(8) --6139 开关      
                            , @configwzyz varchar(12) --G030开关      
                            , @ckjslx varchar(20)      
                            , @ckjsbz varchar(20)      
                            , @ckjsssyz varchar(20)      
      , @cjajbz varchar(20)      
                            , @czddm ut_zddm --诊断代码      
                            , @czjlx varchar(255) --证件类型      
                            , @czjhm varchar(20) --证件号码      
                            , @cJsdmbz varchar(255) --精神毒麻标志      
                            , @cfjdwxs varchar(16) --分级单位系数      
                            , @czxksdm ut_ksdm --执行科室代码      
                            , @csqdbbid ut_dm4 --申请单医嘱项目标本代码      
                            , @csqdbbzl ut_mc64 --申请单医嘱项目标本名称      
     , @cyyts varchar(4) --用药天数     
                            , @cypsl varchar(12) --药品数量     
                            , @czfybz varchar(2) --自费药标记    
                            , @cszyzbz varchar(2)       
                            , @cssxh varchar(12)     
                            , @sqbz varchar(1)    
                            , @szyzzxrq varchar(16)  --术中医嘱执行时间      
                          -- , @zpdf utInt  --整瓶单发    
                            , @tcwbz ut_bz  --套餐外标示    
                            , @kzdw ut_bz--是否是扩展单位 1：是。0：否    
                            ,@drsssbz ut_bz --带入手术室标志    
                            ,@sssksdm ut_ksdm --手术室科室代码    
                            if @yzlb = 0      
                      begin      
                       if @pcdm = ''      
                        select  @pcdm = '00'      
                        if @zxsj = ''      
                        select  @zxsj = zxsj from ZY_YZPCK where id = @pcdm      
                      end      
                      else      
                      begin      
                       if @pcdm = ''      
                       begin      
                        select @pcdm = id, @zxsj = zxsj, @zdm = zbz      
                         from ZY_YZPCK      
                         where lower(name) = 'qd'      
                       end      
                       if @zxsj = ''      
                        select @zxsj = zxsj from ZY_YZPCK where id = @pcdm      
       
                       if (@zdm = '')      
                        select @zdm = zbz from ZY_YZPCK where id = @pcdm      
                      end      
                      select @ypgg = ltrim(rtrim(@ypgg))      
                            select @cfzbz = convert(varchar, @fzbz),      
                            @cv5xh = CONVERT(varchar(12), @v5xh),      
                            @cyzlb = convert(varchar(3), @yzlb),      
                            @cxmlb = convert(varchar(3), @xmlb),      
                            @cidm = convert(varchar(9), @idm),      
                            @cypjl = convert(varchar(14), @ypjl),      
                            @cdwlb = convert(varchar(2), @dwlb),      
                            @czbybz = convert(varchar(2), @zbybz),      
                            @cdybz = convert(varchar(2), @dybz),      
                            @cxmdj = convert(varchar(12), @xmdj),      
                            @ctzxh = convert(varchar(12), @tzxh),      
                            @cyjqrbz = convert(varchar(2), @yjqrbz),      
                            @cyyzxh = convert(varchar(12), @yyzxh),      
                            @cyfzxh = convert(varchar(12), @yfzxh),      
                            @cyexh = convert(varchar(12), @yexh),      
                            @cmzxdfh = convert(varchar(12), isnull(@mzxdfh, 0)),      
                            @cjjbz = convert(varchar(2), isnull(@njjbz, 0)),      
                            @cybshbz = convert(varchar(2), isnull(@ybshbz, 0)),      
                            @cybspbh = convert(varchar(32), @ybspbh)      
                            , @csstyz = convert(varchar(2), @sstyz)      
                            , @clzbz = convert(varchar(2), @lzbz)      
                            , @csybpno = convert(varchar(12), @sybpno)      
                            , @csystype = convert(varchar(2), @systype)      
                            , @cwzyzmc = convert(varchar(255), @wzyzmc)      
                     , @cldpcbz = convert(varchar(2), @ldpcbz)      
                            , @cyzlbdy = convert(varchar(9), @yzlbdy)      
                            , @cjzbz = convert(varchar(2), @jzbz)      
                            , @cblzbz = convert(varchar(2), @blzbz)      
                            , @csqddm = convert(varchar(10), @sqddm)      
                            , @cyypdm = @yypdm      
                            , @ckjslx = convert(varchar(20), @kjslx)      
                            , @ckjsbz = convert(varchar(20), @kjsbz)      
                            , @ckjsssyz = convert(varchar(20), @kjsssyz)      
                            , @cjajbz = convert(varchar(20), @jajbz)      
                            , @czddm = @zddm --诊断代码      
                            , @czjlx = convert(varchar(255), @zjlx) --证件类型      
                            , @czjhm = @zjhm --证件号码      
                            , @cJsdmbz = convert(varchar(255), @Jsdmbz)      
                            , @czxksdm = @zxksdm      
                            , @csqdbbid = @sqdbbid --申请单医嘱项目标本代码      
                            , @csqdbbzl = @sqdbbzl --申请单医嘱项目标本名称      
                            , @cyyts = CONVERT(varchar(4), @yyts) --出院带药专用的用药天数     
                            , @cypsl = CONVERT(varchar(12),@ypsl) --出院带药专用的药品数量    
                            , @czfybz = convert(varchar(2), isnull(@zfybz, 0))    
                            if @lcxmdm = ''      
                            select @lcxmdm = '0'      
                            declare @ssyysj varchar(10) --手术用药时间代码    
                            set @ssyysj='0'    
                            select @cszyzbz='-1'      
                            set @cssxh = '0'    
                            select @sssksdm =''    
                            if LEN(ltrim(rtrim(@kzzd)))>2      
                            select @ssyysj=[dbo].[fun_SplitString](@kzzd,'|',2)     
                            if LEN(ltrim(rtrim(@kzzd)))>=3       
                            select @cszyzbz=[dbo].[fun_SplitString](@kzzd,'|',3) --获取术中医嘱标志                              
                            if LEN(ltrim(rtrim(@kzzd)))>=4       
                            select @cssxh=[dbo].[fun_SplitString](@kzzd,'|',4)  --手术序号      
                            select @sqbz=[dbo].[fun_SplitString](@kzzd,'|',6)  --术前标志    
                            select @szyzzxrq=''
							--[dbo].[fun_SplitString](@kzzd,'|',7)    lj20191127处理由于检验项目备注后加特殊字符|导致前台抱日期转换错误是否修正

                          -- select @zpdf=[dbo].[fun_SplitString](@kzzd,'|',8)    
                            if len(ltrim(rtrim(@kzzd)))>=9    
                            select @tcwbz=[dbo].[fun_SplitString](@kzzd,'|',9)    
                           if len(ltrim(rtrim(@kzzd)))>=16    
                            select @kzdw=[dbo].[fun_SplitString](@kzzd,'|',10)    
                           if len(ltrim(rtrim(@kzzd)))>=11    
                            select @drsssbz=[dbo].[fun_SplitString](@kzzd,'|',11)    
                           if len(ltrim(rtrim(@kzzd)))>=12      
                            select @sssksdm=[dbo].[fun_SplitString](@kzzd,'|',12)    
                          -- if len(ltrim(rtrim(@kzzd)))>=13  
                   --  select @xcfhssh =  [dbo].[fun_SplitString](@kzzd,'|',13)     
                            if exists(select 1 from CISSVR.CISDB.dbo.CPOE_XCF_SZ where ID= '0013' AND VALUE='是')     
                            select @xcfhssh = '是'    
                      --使用第二天全领模式(开始)      
                            select @config6139 = ''      
                            select @config6139 = config + ':00' from YY_CONFIG where id = '6319'      
                            if (exists(select  1 from YY_CONFIG where id = '6068' and config = '是') --是否当天全领模式      
                            and exists(select  1 from YY_CONFIG where id = '6318' and config = '是') --是否启用第二天全领模式      
                            and exists(select  1 from YY_CONFIG where id = '6319' and config <> '00:00') --断点时间设为00：00无效      
                            and right(@ksrq, 8) > @config6139 --开始时间必须大于断点时间      
                            and @yzlb = 1 --只在长期医嘱时使用      
                            and convert(varchar(100), getdate(), 112) = left(@ksrq, 8) --开始日期必须为当天      
                            )      
                            select @ksrq = convert(varchar(100), dateadd(dd, 1, convert(datetime, left(@ksrq, 8))), 112) + '00:01:00' --满足以上六个条件时开始时间使用第二天全领模式（日期加1, 时间为零1分）      
                            --使用第二天全领模式(结束)      
                            select @cfjdwxs = ''      
                            if (@dwlb = 5) and (@idm <> 0)      
                      begin      
                       select distinct @cfjdwxs = convert(varchar(16), fjxs)from YF_YPFJBZDMK where cd_idm = @idm      
                        and sybz = 1 and bqyz = 1 and yfdm = @yfdm and fjdw = @jldw      
                        if @cfjdwxs = ''      
                       begin      
                        select  'F', '处理明细分级单位出错！'      
                         return      
                       end      
                      end      
                            --嘱托内容根据测试部4.0标准 varchar(100) aorigele bug 4189 2013/9/5    
                      declare @sztnr varchar(100)    
                      select @sztnr =CONVERT(varchar(100),@ztnr)    
                                
                            --补丁6287   控制是否显示执行科室 参数6202    
                            declare @showzxks varchar(1)    
                            select @showzxks=substring(config,3,1) from YY_CONFIG where id='6202'    
                            if @showzxks =1    
                                select  @yznr=@yznr+'['+name+']' from YY_KSBMK WHERE id=@yfdm    

                            declare @sqdxmbz varchar(128) --申请单项目备注    
                            set @sqdxmbz=''    
                            if LEN(ltrim(rtrim(@kzzd)))>=9      
                            select @sqdxmbz=[dbo].[fun_SplitString](@kzzd,'|',5)     
                            select @sqdxmbz=convert(varchar(64),@sqdxmbz)    
                      if @cfjdwxs = ''      
                            exec('insert into  ' + @tablename + ' values(' + @cv5xh + ',' + @cfzbz + ',''' + @ysdm + ''',' + @cyzlb + ',''' + @ksrq + ''','      
                            + @cxmlb + ',' + @cidm + ',''' + @ypdm + ''',''' + @yfdm + ''',' + @cypjl + ',''' + @jldw + ''',' + @cdwlb + ',''' + @ypyf + ''',''' + @yznr + ''',''' + @sztnr + ''','''      
                            + @pcdm + ''',''' + @zdm + ''',''' + @zxsj + ''',' + @czbybz + ',' + @cdybz + ',' + @cxmdj + ',' + @ctzxh + ',''' + @jsrq + ''',''' + @mzdm + ''',' + @cyjqrbz      
                            + ',''' + @zdys + '''' + ',' + @cyyzxh + ',' + @cyfzxh + ',''' + @hzxm + ''',' + @cyexh + ',' + @cmzxdfh + ',' + @cjjbz + ',' + @cybshbz + ','''      





                            + @cybspbh + ''',''' + @sqzd + '''' + ',' + @csstyz + ',' + @clzbz + ',''' + @lcxmdm + '''' + ',''' + @ssmc + ''',' + @csybpno + ',' + @csystype + ',''' + @cwzyzmc + ''','      
                            + @cldpcbz + ',' + @cyzlbdy + ',' + @cjzbz + ',' + @cblzbz + ',' + @csqddm + ',''' + @cyypdm + ''' ,''' + @ypgg + ''',' + @ckjslx + ',' + @ckjsbz + ',' + @ckjsssyz + ','    
                             + @cjajbz + ',''' + @czddm + ''',' + @czjlx + ',''' + @czjhm + ''',' + @cJsdmbz + ',null,''' + @czxksdm + ''',''' + @csqdbbid + ''',''' + @csqdbbzl + ''',' 
							 + @cyyts + ','+@cypsl+',' + @czfybz + ',''' + @ssyysj + ''','+@cszyzbz+','
							 +@cssxh+','''+@sqdxmbz+''','''+@sqbz+''','''+@szyzzxrq+''','''+@tcwbz+''','''+@kzdw+''','''+@drsssbz+''','''+@sssksdm+''' )') --,'''+@zpdf+'''       
                      else      
                      exec('insert into  ' + @tablename + ' values(' + @cv5xh + ',' + @cfzbz + ',''' + @ysdm + ''',' + @cyzlb + ',''' + @ksrq + ''','      
                            + @cxmlb + ',' + @cidm + ',''' + @ypdm + ''',''' + @yfdm + ''',' + @cypjl + ',''' + @jldw + ''',' + @cdwlb + ',''' + @ypyf + ''',''' + @yznr + ''',''' + @sztnr + ''','''      
                            + @pcdm + ''',''' + @zdm + ''',''' + @zxsj + ''',' + @czbybz + ',' + @cdybz + ',' + @cxmdj + ',' + @ctzxh + ',''' + @jsrq + ''',''' + @mzdm + ''',' + @cyjqrbz      
                            + ',''' + @zdys + '''' + ',' + @cyyzxh + ',' + @cyfzxh + ',''' + @hzxm + ''',' + @cyexh + ',' + @cmzxdfh + ',' + @cjjbz + ',' + @cybshbz + ','''      
                            + @cybspbh + ''',''' + @sqzd + '''' + ',' + @csstyz + ',' + @clzbz + ',''' + @lcxmdm + '''' + ',''' + @ssmc + ''',' + @csybpno + ',' + @csystype + ',''' + @cwzyzmc + ''','      
                            + @cldpcbz + ',' + @cyzlbdy + ',' + @cjzbz + ',' + @cblzbz + ',' + @csqddm + ',''' + @cyypdm + ''' ,''' + @ypgg + ''',' + @ckjslx + ',' + @ckjsbz + ',' 
							+ @ckjsssyz + ',' + @cjajbz + ',''' + @czddm + ''',' + @czjlx + ',''' + @czjhm + ''',' + @cJsdmbz + ','
							+ @cfjdwxs + ',''' + @czxksdm + ''',''' + @csqdbbid + ''',''' + @csqdbbzl + ''',' + @cyyts + ','+@cypsl+',' + @czfybz + ',''' + @ssyysj + ''','+@cszyzbz+','
							+@cssxh+','''+@sqdxmbz+''','''+@sqbz+''','''+@szyzzxrq+''','''+@tcwbz+''','''+@kzdw+''','''+@drsssbz+''','''+@sssksdm+''')')  --,'+@zpdf+'               
                            if @@error <> 0      
                      begin      
                       select  'F', '插入临时表时出错！'      
                       return      
                      end      
                      select  'T2'      
                            return      
                    end      
      
                    if @jszt = 3      
                    begin      
                        --开始插入医嘱      
                            create table #yzlrtmp      
                            (      
                            lrxh int not NULL,      
                            v5xh ut_xh12 null,      
                            fzbz int not null,      
                            ysdm ut_czyh not null,      
                            yzlb int not null,      
                            ksrq ut_rq16 not null,      
                            xmlb int not null,      
                            idm ut_xh9 not null,      
                            ypdm ut_xmdm not null,      
                            yfdm ut_ksdm not null,      
                            ypjl ut_sl14_3 not null,      
                            jldw ut_unit null,      
                            dwlb smallint not null,      
                            ypyf ut_dm2 null,      
                            yznr ut_mc256 null,      
                            ztnr ut_mc64 null,      
                            pcdm ut_dm2 not null,      
                            zdm char(7)null,      
                            zxsj ut_mc256 null,      
                            zbybz smallint not null,      
                            dybz smallint not null,      
                            xmdj numeric(12, 2)null,      
            tzxh ut_xh12 null, 
                            jsrq ut_rq16 null,      
                            mzdm ut_xmdm null,      
                            yjqrbz smallint not null,      
                            zdys ut_czyh null,      
                            yyzxh ut_xh12 null,      
                            yfzxh ut_xh12 null,      
                            hzxm ut_mc64 not null,      
                            yexh ut_syxh not null,      
                            mzxdfh ut_xh12 null      
                            , jjbz ut_bz null      
                            , ybshbz ut_bz      
                            , ybspbh ut_mc32      
                            , sqzd ut_zddm null      
                            , sstyz ut_bz null      
                            , lzbz ut_bz null      
                            , lcxmdm ut_xmdm null      
                            , ssmc ut_mc256 null      
                            , sybpno ut_xh12 null      
                            , systype ut_bz null      
                            , wzyzmc varchar(255)null      
                            , ldpcbz ut_bz null      
                            , yzlbdy ut_bz null      
                            , jzbz ut_bz null      
                            , blzbz ut_bz null      
                            , sqddm int null      
                            , yypdm ut_xmdm null      
                            , ypgg ut_mc32 null      
                            , kjslx ut_bz null      
                            , kjsbz ut_bz null      
                            , kjsssyz ut_xh12 null      
                            , jajbz ut_bz null      
                            , zddm ut_zddm null      
                            , zjlx ut_bz null      
                            , zjhm varchar(20)null      
                            , Jsdmbz ut_bz null      
                            , fjdwxs ut_dwxs null      
                            , zxksdm ut_ksdm null      
, sqdbbid ut_dm4 null --申请单医嘱项目标本代码      
                            , sqdbbzl ut_mc64 null --申请单医嘱项目标本名称      
                            , yyts ut_bz null     --出院带药专用的用药天数    
                            , ypsl ut_sl10 null    --出院带药专用的药品数量    
                            , zfybz ut_bz null --自费药标记 0 不是自费 1自费药    
                            , sqgyfl ut_bz null --手术给药分类    
                            , szyzbz ut_bz null       
                            , ssxh  ut_xh12 null    
                            ,sqdxmbz ut_mc64 null --申请单项目备注       
                            ,sqbz ut_bz null        --术前标志     
                            ,szyzzxrq ut_rq16 --术中医嘱执行日期    
                           -- ,zpdf utInt --整瓶单发    
                            ,tcwbz ut_bz null--套餐外标示    
                            ,kzdw ut_bz NULL    
                            ,drsssbz ut_bz null    
                            ,sssksdm ut_ksdm NULL    
                            )     
      
                        if exists(select  1 from YY_CONFIG where id = 'G112' and config = '是')      
                        begin      
                            exec('insert into  #yzlrtmp select  * from ' + @tablename + ' order by ksrq')      
                                if @@error <> 0      
                            begin      
                                select  'F', '插入临时表时出错！'      
                                    return      
                            end      


                            declare  cursor_ksrq cursor      
                                for select  fzbz from #yzlrtmp      
                                for update      
                                open cursor_ksrq      
                                declare @lsi int,      
                                @lsfzbz int      
                                set  @lsi = 0      
                        fetch from cursor_ksrq into @lsfzbz      
      
                            while @@fetch_status = 0      
                            begin      
                                if @lsfzbz > @lsi      
                                begin      
                                    set @lsi = @lsi + 1      
                                        update #yzlrtmp set  fzbz = 9999 where fzbz = @lsfzbz      
                                        update #yzlrtmp set  fzbz = @lsfzbz where fzbz = @lsi      
                                        update #yzlrtmp set  fzbz = @lsi where fzbz = 9999      
                                end      
                                fetch from cursor_ksrq into @lsfzbz      
                            end      
      
                            deallocate cursor_ksrq      
                        end      
                     else      
                        begin      
                            exec('insert into  #yzlrtmp select  * from ' + @tablename)      
                            if @@error <> 0      
                            begin      
                     select  'F', '插入临时表时出错！'      
                      return      
                            end      
                        end      


                        exec(' delete #yzlrtmp '      
                            + ' from #yzlrtmp , BQ_CQYZK (nolock)'      
                            + ' where #yzlrtmp.yyzxh=BQ_CQYZK.v5xh '      
                            + ' and BQ_CQYZK.yzzt not in (-1,0) and #yzlrtmp.yzlb=1 ')      
                            if @@error <> 0      
                        begin      
                            select  'F', '去除临时表中的已经被审核的长期医嘱时出错！'      
                                return      
                        end      
                        declare @HP405 varchar(2)    
       select @HP405= CONFIG from  CISSVR.CISDB.dbo.SYS_CONFIG with (nolock) where ID='HP405'     
                       select * into #yzlrtmp_ss from #yzlrtmp where 1=2    
                    if(@HP405='是' )    
                    begin    
                insert into  #yzlrtmp_ss     select * from #yzlrtmp where xmlb=2  --手术医嘱先保留,因为下面会被删除(HIS医嘱可能已存在审核过的记录)       
                    end    
                         
            exec(' delete #yzlrtmp '      
                            + ' from #yzlrtmp a, BQ_LSYZK b'      
                            + ' where a.yyzxh=b.v5xh '      
                            + ' and ((b.yzzt not in (-1,0) and b.yzlb<>12)or (b.yzzt>0 and b.yzlb=12)) and a.yzlb=0 and isnull(b.yzlb2,0)<>1 ')      
                            if @@error <> 0      
                        begin      
                            select  'F', '去除临时表中的已经被审核的临时医嘱时出错！'      
                                return      
                        end      

                        exec('drop table ' + @tablename)      
                            if exists(select  1 from YY_CONFIG where id = '6191' and config = '否')      
                        begin      
                            delete from #yzlrtmp where fzbz in (select  distinct fzbz from #yzlrtmp where jjbz = 3) --黑灯      
                                if @@error <> 0      
                            begin      
                                select  'F', '去除临时表中的配伍禁忌（黑灯）的医嘱时出错！'      
                                    return      
                            end      
                        end      
                        declare @now ut_rq16,      
                            @ypbz smallint,      
                            @bqdm ut_ksdm, --病区代码      
                            @ksdm ut_ksdm --科室代码      
      
                        declare @configg007 varchar(4),      
                            @configg075 varchar(2),     
                            @configg030 varchar(18),  --默认文字医嘱代码    
  @btbz char(2),      
      
                  @configG107 ut_xmdm, 
                            @configG108 ut_xmdm,      
                            @config6432 varchar(2),    
                            @config7002 varchar(2)    
                            select @config7002 = config from YY_CONFIG where id = '7002'      
                            select @configg030 = config from YY_CONFIG where id = 'G030'  --取得HIS这边的默认文字医嘱代码    
                            if ltrim(rtrim(@configg030))=''    
                            begin    
                       select  'F', 'HIS没有指定默认的文字医嘱代码！'      
                       return      
                            end    
                            select @configg007 = config from YY_CONFIG where id = 'G007'      
                            select @configg075 = config from YY_CONFIG where id = 'G075' --是否在医嘱保存之后使用提交方式提交医嘱      
                            select @btbz = config from YY_CONFIG where id = '6122'      
                            select @configg007 = isnull(@configg007, '是')      
                            select @configg075 = isnull(@configg075, '否')      
                            select @configG107 = isnull(config, '')from YY_CONFIG where id = 'G107' --危重文字医嘱代码      
                            select @configG108 = isnull(config, '')from YY_CONFIG where id = 'G108' --危重文字医嘱代码      
                            select @config6432 = config from YY_CONFIG where id = '6432'      
                            select @config6432 = isnull(@config6432, '否')      
                            select @now = convert(char(8), getdate(), 112) + convert(char(8), getdate(), 8),  @ypbz = 0      
                            select @bqdm = bqdm, @ksdm = ksdm from ZY_BRSYK(nolock)where syxh = @syxh      
                            if @@rowcount = 0      
                      begin      
                       select  'F', '病人首页信息不存在！'      
                        return      
                      end     

                  --需求10322:医嘱类别发送模式。默认为0，按现有模式发送，设置为1：按yzlb发送，设置为0的时候，医嘱推送存储usp_his5_zyys_saveorder修改所有发送过来的文字医嘱的类别为1,；    
                  --设置为1的时候，按yzlb发送，医嘱推送存储usp_his5_zyys_saveorder不更改yzlb    

                   declare @hp44 varchar(4)--出院带药是否开门诊单位开关    
                         select @hp44= CONFIG from CISSVR.CISDB.dbo.SYS_CONFIG WHERE ID='HP44'    

                  declare @hp236 varchar(2)    
                        select  @hp236= isnull(CONFIG, '0') from CISSVR.CISDB.dbo.SYS_CONFIG WHERE ID='HP236'     
      
                        --处理重复发送的未执行申请单问题      
                        if exists(select  1 from ZY_BRSQD(nolock)where syxh = @syxh and blsqdxh = @sqddm and jlzt = 0)      
                     begin      
      
                      delete from ZY_BRSQDMXK      
                       where sqdxh in (select  xh from ZY_BRSQD where syxh = @syxh and blsqdxh = @sqddm and jlzt = 0)      
                       delete from BQ_LSYZK where syxh = @syxh and sqdxh in (select  xh from ZY_BRSQD where syxh = @syxh and blsqdxh = @sqddm and jlzt = 0)      
                       delete from ZY_BRSQD where syxh = @syxh and blsqdxh = @sqddm      
                     end      
      
                        if exists(select  1 from ZY_BRSQD(nolock)where syxh = @syxh and blsqdxh = @sqddm and jlzt = 1)      
                        begin      
                            select  'F', '已经发送了此申请单，并已经处理了！'      
                                return      
                        end      

                        create table #yzk      
                            (      
                            lrxh int not NULL, --录入顺序 add by gzy at 20050904      
                            v5xh ut_xh12 not null, --5.0 医嘱序号      
                            fzxh ut_xh12 not null, --分组标志      
                            ysdm ut_czyh not null, --医生代码      
                            ksrq ut_rq16 null, --开始日期      
    pcdm ut_dm2 not null, --频次      
                            zxcs int not null default 1, --执行次数      
                            zxzq int not null default 1, --执行周期      
                            zxzqdw ut_bz not null, --执行周期时间单位(-1: 不规则周期，0：天, 1 ：小时, 2 ：分钟)      
                            zdm char(7)null, --周代码      
                            zxsj ut_mc256 null, --执行时间      
                            idm ut_xh9 not null, --药品idm      
                            gg_idm ut_xh9 not null, --规格idm      
                            lc_idm ut_xh9 not null, --临床idm      
                            ypdm ut_xmdm not null, --药品（项目）代码      
                            ypmc ut_mc256 null, --药品（项目）名称      
                            ypjl ut_sl14_3 null, --剂量      
                            jldw ut_unit null, --剂量单位      
                            dwlb smallint not null, --单位类别0剂量单位，2门诊单位 3 住院单位      
                            ypsl ut_sl10 not null, --药品数量      
                            ypgg ut_mc32 null, --药品规格      
                            zxdw ut_unit null, --最小单位      
                            ztnr ut_mc64 null, --嘱托      
                            yznr ut_mc256 null, --医嘱内容      
                            ypyf ut_dm2 null, --药品用法      
                            zxksdm ut_ksdm null, --执行科室      
                            yzlb ut_bz not null, --医嘱类别（0: 药品，1治疗，2手术，3膳食，4输血，5护理，6检查，      
                            --7 检验，8输液，9停止医嘱，10转科，11出院，12出院带药）      
                            tzxh ut_xh12 null, --停止序号      
                            tzrq ut_rq16 null, --停止日期      
                            zbybz ut_bz not null, --自备药标志（0普通，1自备，2PRN）      
                            zdydj ut_money not null, --自定义单价      
                            dybz ut_bz not null, --打印标志（0未打印，1已打印，2不打印）      
                            djfl ut_dm4 not null, --BQ_YZDJFLK.id医嘱单据分类代码      
                            yzdjfl ut_dm4 null, --BQ_YZZXDJFLK.id医嘱执行单据分类      
                            mzdm ut_xmdm null, --麻醉代码(手术医嘱时)      
                            yzbz smallint not null, --0 临时，1长期      
                            yplh ut_kmdm null,      
                            ypjx ut_jxdm null,      
                            tsyp varchar(2)null,      
                            ljlybz ut_bz not null,      
                            zyxs ut_dwxs not null,      
                            cgyzbz smallint not null,      
                            yjqrbz smallint not null,      
                            hzxm ut_mc64 not null,      
                            yexh ut_syxh not null,      
                            memo ut_memo null default '',      
                            mzxdfh ut_xh12 null      
               , jjbz ut_bz null      
                            , ybshbz ut_bz null --医保审核标志      
                            , ybspbh ut_mc32 null --医保审批编号      
                            , sstyz ut_bz null      
                            , sqzd ut_zddm null      
                            , lzbz ut_bz null      
                            , lcxmdm ut_xmdm null      
                            , sxysbz ut_bz null --0 实习医生 1 主任医生      
                            , sybpno ut_xh12 null --输液编批号      
                            , systype ut_bz null      
                            , sqdxh ut_xh12 null --申请单序号      
                            , sqdxmbz ut_mc64 null --申请单项目备注      
                            , sqdsjxm ut_xmdm null --申请单上级项目      
                            , yzlbdy ut_bz null      
                            , jzbz ut_bz null      
                            , blzbz ut_bz null      
                            , sqddm int null      
                            , yypdm ut_xmdm null      
                            , kjslx ut_bz null      
                            , kjsbz ut_bz null      
     , kjsssyz ut_xh12 null      
               , yyzxh ut_xh12 null      
              , yfzxh ut_xh12 null      
                            , jajbz ut_bz null      
                            , lszxks ut_ksdm null      
                            , zddm ut_zddm null      
                            , zjlx ut_bz null      
                            , zjhm varchar(20)null      
                            , Jsdmbz ut_bz null      
                            , sqdbbid ut_dm4 null --申请单医嘱项目标本代码      
                            , sqdbbzl ut_mc64 null --申请单医嘱项目标本名称      
                            , yyts ut_bz null      --出院带药专用的用药天数    
                            , cydyypsl ut_sl10 null  --出院带药专用的药品数量    
                            , zfybz ut_bz null    
                            , sqgyfl ut_bz null --术前给药分类    
                            , szyzbz ut_bz null       
                            , ssxh  ut_xh12 null     
                            , sqbz ut_bz null   --术前标志      
                            ,szyzzxrq  ut_rq16 --术中医嘱执行日期    
                            --,zpdf utInt --整瓶单发    
                            , tcwbz ut_bz --套餐外标示    
                            ,drsssbz ut_bz--带入手术室标志    
                            ,sssksdm ut_ksdm NULL    
                            )      
                            --文字医嘱内码的处理,主要是因为传过来的XXXXX编码问题,修改所有发送过来的文字医嘱的类别为1    
                            --医嘱类别(0药品，1治疗，2手术，3膳食，4输血，5护理，6检查申请单，7检验申请单，8输液，9停止医嘱，10转科，    
                            --11出院，12出院带药，13转床,14术后医嘱，15产后医嘱 ，16告病重，17告病危，18转区，19病历文书,20检查临床项目21检验临床项目23死亡医嘱,24术前医嘱)    
                            update #yzlrtmp set ypdm=@configg030,yypdm=@configg030,lcxmdm='0' where ypdm='XXXXX' and (xmlb in (1,10,11,13,14,15,16,17,18,23,24,98,99) or xmlb>=100)    
                           declare @HP412 varchar(2)    
            declare @HP188 varchar(2)    
            select @HP412= CONFIG from  CISSVR.CISDB.dbo.SYS_CONFIG with (nolock) where ID='HP412'     
            select @HP188= CONFIG from  CISSVR.CISDB.dbo.SYS_CONFIG with (nolock) where ID='HP188'    
                      --药品医嘱的处理,含出院带药医嘱    

                      insert into  #yzk      
                            select  a.lrxh, a.v5xh, a.fzbz, a.ysdm, a.ksrq, a.pcdm, 1, 1, 0, a.zdm, a.zxsj, a.idm, c.gg_idm, c.lc_idm,      
                            c.ypdm, c.ypmc, a.ypjl, a.jldw, a.dwlb, CASE WHEN (a.kzdw=1 or (a.xmlb=97 and a.idm>0)) then a.ypsl else (case a.dwlb when 0 then a.ypjl / c.ggxs when 2 then a.ypjl * c.mzxs when 3 then a.ypjl * c.zyxs     
                            when 5 then a.ypjl * a.fjdwxs      
                      end) END,case when ltrim(rtrim(isnull(a.ypgg, ''))) = '' then c.ypgg else a.ypgg end, case a.xmlb when 97 then c.zydw else c.zxdw end, a.ztnr,    
                            --医嘱内容由医嘱打印设置控制，不由参数控制(唐渝杰2019-03-22)    
                            --aorigele 20130626    
--                           case when (@configg007 ='否' and ((@HP188='否' and @HP412 IN (0,1)) or (@HP188='是' and exists(SELECT 1 FROM CISSVR.CISDB.dbo.CPOE_YZNRSZ_DYK WHERE YZID=0 AND YSID='0002') )))     
--              then SUBSTRING(a.yznr,0,CHARINDEX(a.ypgg,a.yznr)) +RIGHT(a.yznr,LEN(a.yznr)-CHARINDEX(a.ypgg,a.yznr)-LEN(a.ypgg))     
--        when (@configg007 ='是' and ((@HP188='否' and @HP412 IN (2,3)) or (@HP188='是' and not exists(SELECT 1 FROM CISSVR.CISDB.dbo.CPOE_YZNRSZ_DYK WHERE YZID=0 AND YSID='0002') )))     
--        then a.yznr+' '+a.ypgg    

--         else     
----                            (case when ltrim(rtrim(isnull(a.ypgg,'')))<>'' and charindex(a.ypgg,a.yznr)>0    
----             and ltrim(rtrim(isnull(a.ypgg, ''))) = (cast(CONVERT(float,a.ypjl) as varchar) + ltrim(rtrim(isnull(a.jldw,''))))    
----          then     
----             SUBSTRING(a.yznr, 1, charIndex(a.ypgg,a.yznr)-1) + SUBSTRING(a.yznr,charIndex(a.ypgg,a.yznr)+len(a.ypgg),len(a.yznr)-(charIndex(a.ypgg,a.yznr)+len(a.ypgg)))    
----          else     
----            REPLACE(a.yznr,a.ypgg,'')    
----            end)     
--                            a.yznr  end as yznr,    
                            a.yznr,    
                            a.ypyf, a.yfdm, case a.xmlb when 12 then 12      
                            when 97 then 14 --小处方医嘱类别固定14 临时医嘱4.0中，历史原因。for  8974    
                      else 0 end,a.tzxh, isnull(a.jsrq, ''), a.zbybz, a.xmdj, (case a.dybz when 1 then 2 else 0 end), '', '', a.mzdm, case a.lzbz when 1 then 0      
                      else a.yzlb end, c.yplh, c.jxdm, convert(varchar(2), b.tsbz),c.ljlybz,     
                            case @hp44 when '是' then c.mzxs else c.zyxs end,                                 
                            --c.zyxs,    
                            0, 0, a.hzxm, a.yexh, '', a.mzxdfh, a.jjbz, a.ybshbz, a.ybspbh, a.sstyz, a.sqzd, a.lzbz, '0', 0, a.sybpno, a.systype, 0, '', '0', --agg 2004.09.10 加lcxmdm      
                            a.yzlbdy, a.jzbz, a.blzbz, a.sqddm, a.yypdm, a.kjslx, a.kjsbz, a.kjsssyz, a.yyzxh, a.yfzxh, a.jajbz, '', a.zddm, a.zjlx,     
                            a.zjhm, a.Jsdmbz, a.sqdbbid, a.sqdbbzl, a.yyts,a.ypsl,a.zfybz,a.sqgyfl ,a.szyzbz,a.ssxh  ,a.sqbz,a.szyzzxrq --,a.zpdf      
                            ,a.tcwbz,a.drsssbz,a.sssksdm    
                      from #yzlrtmp a, YF_YFZKC b(nolock), YK_YPCDMLK c(nolock)      
                      where a.yzlb in (0, 1) and a.xmlb in (0, 8,22, 12,97) and b.cd_idm = a.idm and b.ksdm = a.yfdm and c.idm = a.idm      
                      if @@error <> 0      
                begin      
                       select  'F', '处理医嘱信息出错！'      
                       return      
                      end      
  if exists(select  1 from #yzlrtmp where xmlb = 25)  --手术申请单对应的文字医嘱    
                 BEGIN    
                        insert into  #yzk      
                            select  a.lrxh, a.v5xh, a.fzbz, a.ysdm, a.ksrq, a.pcdm, 1, 1, 0, a.zdm, a.zxsj, a.idm, '0', '0',      
                            '0',  a.yznr, a.ypjl, a.jldw, a.dwlb,'1','手术对应文字医嘱', '0', a.ztnr,    
                            a.yznr as yznr,    
                            a.ypyf, a.yfdm,  1,a.tzxh, isnull(a.jsrq, ''), a.zbybz, a.xmdj, (case a.dybz when 1 then 2 else 0 end), '', '', a.mzdm, case a.lzbz when 1 then 0      
                      else a.yzlb end, '0', '0', '0','0',     
                          '0',                                 
                            --c.zyxs,    
                            0, 0, a.hzxm, a.yexh, '0', a.mzxdfh, a.jjbz, a.ybshbz, a.ybspbh, a.sstyz, a.sqzd, a.lzbz, '0', 0, a.sybpno, a.systype, 0, '', '0', --agg 2004.09.10 加lcxmdm      
                            a.yzlbdy, a.jzbz, a.blzbz, a.sqddm, a.yypdm, a.kjslx, a.kjsbz, a.kjsssyz, a.yyzxh, a.yfzxh, a.jajbz, '', a.zddm, a.zjlx,     
                            a.zjhm, a.Jsdmbz, a.sqdbbid, a.sqdbbzl, a.yyts,a.ypsl,a.zfybz,a.sqgyfl ,a.szyzbz,a.ssxh  ,a.sqbz ,a.szyzzxrq--,a.zpdf     
                            ,a.tcwbz ,a.drsssbz,a.sssksdm    
                      from #yzlrtmp a    
                      where a.yzlb in (0, 1) and a.xmlb=25     
                      if @@error <> 0      
                      begin      
                       select  'F', '处理手术对应文字医嘱出错！'      
                       return      
                      end      
                        END    
             
                    --收费项目的处理      
                      insert into  #yzk      
                      select  a.lrxh, a.v5xh, a.fzbz, a.ysdm, a.ksrq, a.pcdm, 1, 1, 0, a.zdm, a.zxsj, 0, 0, 0,      
                      a.ypdm, (case a.wzyzmc when '' then b.name      
                      else a.wzyzmc end), a.ypjl, a.jldw, a.dwlb, a.ypjl,      
                      b.xmgg, b.xmdw, a.ztnr, a.yznr, a.ypyf, a.yfdm,      
                     (case @hp236 when '1' then     
     (case when a.xmlb in (10,11,13,14,15,16,17,18,23,24,98,99,109) then a.xmlb    
                              when a.xmlb>=100 then 1    




         else    
         (case b.xmlb when 3 then 3 when 4 then 4 when 5 then 5 when 7 then 6 when 8 then 7 else  1  end)    
         end)    
        else (    
        (case when a.xmlb in (10,11,13,14,15,16,17,18,23,24,98,99,109) then 1    
                                   when a.xmlb>=100 then 1    




         else    
         (case b.xmlb when 3 then 3 when 4 then 4 when 5 then 5 when 7 then 6 when 8 then 7 else  1  end)    
         end)    
        )     
        end)    
                            , a.tzxh, isnull(a.jsrq, ''), a.zbybz, a.xmdj, (case a.dybz when 1 then 2      
                      else 0 end), '', '', a.mzdm,case a.lzbz when 1 then 0  else  a.yzlb      
                      end, b.dxmdm, '', '0', 0, 1, b.cgyzbz, a.yjqrbz      
                      , a.hzxm, a.yexh, '', a.mzxdfh, a.jjbz, a.ybshbz, a.ybspbh, a.sstyz, a.sqzd, a.lzbz, '0', 0, a.sybpno, a.systype, 0, '', '0',     
                      a.yzlbdy, a.jzbz, a.blzbz, a.sqddm, a.yypdm, a.kjslx, a.kjsbz, a.kjsssyz, a.yyzxh, a.yfzxh, a.jajbz, '',    
                       '', 0, '', 0, a.sqdbbid, a.sqdbbzl, a.yyts,a.ypsl,a.zfybz ,a.sqgyfl,a.szyzbz,a.ssxh,a.sqbz,a.szyzzxrq--,a.zpdf     
                            ,a.tcwbz ,a.drsssbz,a.sssksdm    
                      from #yzlrtmp a, YY_SFXXMK b(nolock)      
                      where a.yzlb in (0, 1) and (a.xmlb in(1,3,4,5,20,21,10,11,13,14,15,16,17,18,23,24,98,99,109) or a.xmlb>=100) and a.lcxmdm = '0'      
                      and ((a.sqddm = 0 and b.id = a.ypdm) or (a.sqddm > 0 and b.id = a.yypdm))      
          if @@error <> 0      
                      begin      
                       select  'F', '处理医嘱信息出错！'      
                        return      
                      end     
     
                    --处理临床项目    
                      insert into  #yzk      
                      select  a.lrxh, a.v5xh, a.fzbz, a.ysdm, a.ksrq, a.pcdm, 1, 1, 0, a.zdm, a.zxsj, 0, 0, 0,      
                      a.ypdm, (case a.wzyzmc when '' then c.name      
                      else a.wzyzmc  end), a.ypjl, a.jldw, a.dwlb, a.ypjl,  d.xmgg, d.xmdw, a.ztnr, a.yznr, a.ypyf, a.yfdm,      
                      (case c.xmlb when 3 then 3 when 4 then 4 when 5 then 5 when 7 then 6 when 8 then 7  else 1  end),      
                      a.tzxh, isnull(a.jsrq, ''), a.zbybz, a.xmdj, (case a.dybz when 1 then 2 else  0 end), '', '', a.mzdm,      
                      case a.lzbz when 1 then 0 else  a.yzlb  end, d.dxmdm, '', '0', 0, 1, d.cgyzbz, d.yjqrbz      
                      , a.hzxm, a.yexh, '', a.mzxdfh, a.jjbz, a.ybshbz, a.ybspbh, a.sstyz, a.sqzd, a.lzbz, a.lcxmdm, 0, a.sybpno, a.systype, 0, '', '0', --agg 2004.09.10      
                      a.yzlbdy, a.jzbz, a.blzbz, a.sqddm, a.yypdm, a.kjslx, a.kjsbz, a.kjsssyz, a.yyzxh, a.yfzxh, a.jajbz, '',    
                       '', 0, '', 0, a.sqdbbid, a.sqdbbzl, a.yyts,a.ypsl ,a.zfybz,a.sqgyfl,a.szyzbz,a.ssxh  ,a.sqbz,a.szyzzxrq--,a.zpdf     
                            ,a.tcwbz ,a.drsssbz,a.sssksdm    
                      from #yzlrtmp a, YY_SFXXMK b(nolock), YY_LCSFXMK c(nolock), YY_SFXXMK d(nolock)      
                      where a.yzlb in (0, 1) and a.xmlb in (1,3,4,5,20,21) and a.lcxmdm <> '0'      
                      and ((a.sqddm = 0 and b.id = a.ypdm) or (a.sqddm > 0 and b.id = a.yypdm)) and a.lcxmdm = c.id and c.zxmdm = d.id      
                      if @@error <> 0      
                      begin      
                       select  'F', '处理医嘱信息出错！'      
                        return      
                      end      

                    --增加默认数量控制，6438为空或非数字则不控制      
                      if exists(select  1 from YY_CONFIG(nolock)where id = '6438' and isnumeric(config) = 1)      
        begin      
                       declare @mrypsl ut_sl14_3      
                       select @mrypsl = convert(numeric(14, 3), config)from YY_CONFIG(nolock)where id = '6438'      
                       update #yzk set  ypsl = @mrypsl where ypsl = 0      
                      end      
      
                    --处理长期医嘱频次      
                      update #yzk set  zxcs = b.zxcs,      
                      zxzq = b.zxzq,      
                      zxzqdw = b.zxzqdw      
                      from #yzk a, ZY_YZPCK b(nolock)      
                      where a.yzbz in (0, 1) and a.pcdm = b.id --前面已把临嘱转换为临时医嘱      
                      if @@error <> 0      
                      begin      
                       select  'F', '处理长期医嘱信息出错！'      
                       return      
                      end      
      
                    --修改申请单的文字医嘱为临时医嘱      
                      update #yzk set       
                      yzbz = 0,      
                      pcdm = '00',      
                      zxcs = 1,      
                      zxzq = 1,      
                      zxzqdw = '0'      
                      from #yzk a      
                      where sqddm > 0 --前面已把临嘱转换为临时医嘱      
       
                    --处理累计领药标志    
                            update a set  ljlybz=b.ljlybz    
                            from #yzk a,YK_LJLYFSSZ b where a.idm=b.cd_idm and a.zxksdm=b.yfdm and a.idm>0 and b.jlzt=0    
                      update #yzk set  ljlybz = 0      
                      where yzbz = 0 or zbybz > 0 --门诊单位不用累计领药      
                      if @@error <> 0      
                      begin      
                       select  'F', '处理累计领药标志出错！'      
                       return      
              end      

                      declare @error integer,@rowcount integer      
       --处理手术医嘱      
                      if exists(select  1 from #yzlrtmp where xmlb = 2)      
                      begin      
                       if (select  config from YY_CONFIG(nolock)where id = '6036') = '是'      
                        select @ypbz = 3      
                       else      
                        select @ypbz = 1      
                       insert into  #yzk      
                       select  a.lrxh, a.v5xh, a.fzbz, a.ysdm, a.ksrq, a.pcdm, 1, 1, 0, a.zdm, a.zxsj, a.idm, b.gg_idm, b.lc_idm,      
                       b.ypdm, case when a.ssmc = '' then b.ypmc  else  a.ssmc  end, a.ypjl, a.jldw, a.dwlb, 1, case when ltrim(rtrim(isnull(a.ypgg, ''))) = '' then b.ypgg      
                       else a.ypgg  end, b.zxdw, a.ztnr, a.yznr, a.ypyf,  a.yfdm, 2, a.tzxh, isnull(a.jsrq, ''), a.zbybz, a.xmdj, a.dybz, '', '', a.mzdm, 0, '', '', '', 0, 1, 0, 0      
                       , a.hzxm, a.yexh, a.zdys, a.mzxdfh, a.jjbz, a.ybshbz, a.ybspbh, a.sstyz, a.sqzd, a.lzbz, a.lcxmdm, 0, a.sybpno, a.systype, 0, '', '0',      
                       2, a.jzbz, a.blzbz, a.sqddm, a.yypdm, a.kjslx, a.kjsbz, a.kjsssyz, a.yyzxh, a.yfzxh, a.jajbz, '',    
                        '', 0, '', 0, a.sqdbbid, a.sqdbbzl, a.yyts,a.ypsl,a.zfybz ,a.sqgyfl,a.szyzbz,a.ssxh  ,a.sqbz,a.szyzzxrq--,a.zpdf     
                                ,a.tcwbz ,a.drsssbz,a.sssksdm    
                       from #yzlrtmp a, VW_ZYJGK_YS_ALL b(nolock)      
                       where a.yzlb = 0 and a.xmlb = 2 and a.lcxmdm = '0' and a.idm = 0      
                       and ((a.sqddm = 0 and b.ypdm = a.ypdm) or (a.sqddm > 0 and b.ypdm = a.yypdm)) and b.ypbz = @ypbz      
                       select @error = @@error, @rowcount = @@rowcount      
            if @error <> 0      
                       begin      
                        select  'F', '手术代码不存在！'      
                         return      
                       end      
      
                       insert into  #yzk      
                       select  a.lrxh, a.v5xh, a.fzbz, a.ysdm, a.ksrq, a.pcdm, 1, 1, 0, a.zdm, a.zxsj, a.idm, b.gg_idm, b.lc_idm,      
                       d.id, d.name, a.ypjl, a.jldw, a.dwlb, 1, d.xmgg, b.zxdw, a.ztnr, a.yznr, a.ypyf,      
                       a.yfdm, 2, a.tzxh, isnull(a.jsrq, ''), a.zbybz, a.xmdj, a.dybz, '', '', a.mzdm, 0, '', '', '', 0, 1, 0, 0      
                       , a.hzxm, a.yexh, a.zdys, a.mzxdfh, a.jjbz, a.ybshbz, a.ybspbh, a.sstyz, a.sqzd, a.lzbz, a.lcxmdm, 0, a.sybpno, a.systype, 0, '', '0',      
                       2, a.jzbz, a.blzbz, a.sqddm, a.yypdm, a.kjslx, a.kjsbz, a.kjsssyz, a.yyzxh, a.yfzxh, a.jajbz,     
                       '', '', 0, '', 0, a.sqdbbid, a.sqdbbzl, a.yyts ,a.ypsl ,a.zfybz ,a.sqgyfl,a.szyzbz,a.ssxh,a.sqbz,a.szyzzxrq--,a.zpdf    
                                ,a.tcwbz ,a.drsssbz,a.sssksdm     
                       from #yzlrtmp a, VW_ZYJGK_YS_ALL b(nolock), YY_LCSFXMK c(nolock), YY_SFXXMK d(nolock)      
                       where a.yzlb = 0 and a.xmlb = 2 and a.lcxmdm <> '0' and a.lcxmdm = b.lcxmdm and a.idm = 0      
                       and ((a.sqddm = 0 and b.ypdm = a.ypdm) or (a.sqddm > 0 and b.ypdm = a.yypdm)) and a.lcxmdm = c.id and c.zxmdm = d.id and b.ypbz = @ypbz      
                       select @error = @@error, @rowcount = @rowcount + @@rowcount      
                       if @error <> 0      
                       begin      
                        select  'F', '手术代码不存在！'      
                         return      
                       end      
                       if @rowcount = 0      
                       begin      
                        select  'F', '手术代码不存在3！'      
                         return      
                       end      
                      end      
      
                    --处理申请单医嘱  (医技确认标志取收费小项目库的，按HIS维护的为标准)    
                      if exists(select  1 from #yzlrtmp where xmlb in (6, 7))      
                      begin      
                       insert into  #yzk      
                        select  a.lrxh, a.v5xh, a.fzbz, a.ysdm, a.ksrq, a.pcdm, 1, 1, 0, a.zdm, a.zxsj, 0, 0, 0,      
                        a.ypdm,(case a.wzyzmc when '' then b.name          
                                   else  a.wzyzmc  end), a.ypjl, a.jldw, a.dwlb, a.ypjl,      
                       b.xmgg, b.xmdw, a.ztnr, a.yznr , a.ypyf, a.zxksdm, a.xmlb,      
                       a.tzxh, isnull(a.jsrq, ''), a.zbybz, a.xmdj, (case a.dybz when 1 then 2      
                       else  0  end), '', '', a.mzdm,  case a.lzbz when 1 then 0  else  a.yzlb  end, b.dxmdm, '', '0', 0, 1, b.cgyzbz, b.yjqrbz      
                       , a.hzxm, a.yexh, '', a.mzxdfh, a.jjbz, a.ybshbz, a.ybspbh, a.sstyz, a.sqzd, a.lzbz, '0', 0, a.sybpno, a.systype, 0, a.sqdxmbz, '0', --agg 2004.09.10      
                       a.yzlbdy, a.jzbz, a.blzbz, a.sqddm, a.yypdm, a.kjslx, a.kjsbz, a.kjsssyz, a.yyzxh, a.yfzxh, a.jajbz,     
                       '', '', 0, '', 0, a.sqdbbid, a.sqdbbzl, a.yyts ,a.ypsl,a.zfybz  ,a.sqgyfl,a.szyzbz,a.ssxh,a.sqbz,a.szyzzxrq--,a.zpdf     
                                ,a.tcwbz ,a.drsssbz,a.sssksdm    
                       from #yzlrtmp a, YY_SFXXMK b(nolock)      
                       where a.yzlb = 0 and a.xmlb in (6, 7) and a.lcxmdm = '0' and a.idm = 0 and b.id = a.ypdm and a.sqddm > 0      
                       if @@error <> 0      
                       begin      
                        select  'F', '处理申请单信息出错！'      
                         return      
                       end      
      
                       insert into  #yzk      
                        select  a.lrxh, a.v5xh, a.fzbz, a.ysdm, a.ksrq, a.pcdm, 1, 1, 0, a.zdm, a.zxsj, 0, 0, 0,      
                        c.zxmdm, c.name, a.ypjl, a.jldw, a.dwlb, a.ypjl,      
                       d.xmgg, d.xmdw, a.ztnr, a.yznr , a.ypyf, a.zxksdm, a.xmlb,  a.tzxh, isnull(a.jsrq, ''), a.zbybz, a.xmdj, (case a.dybz when 1 then 2      
                 else  0  end), '', '', a.mzdm, case a.lzbz when 1 then 0  else  a.yzlb  end, d.dxmdm, '', '0', 0, 1, d.cgyzbz, d.yjqrbz      
                       , a.hzxm, a.yexh, '', a.mzxdfh, a.jjbz, a.ybshbz, a.ybspbh, a.sstyz, a.sqzd, a.lzbz, a.lcxmdm, 0, a.sybpno, a.systype, 0, a.sqdxmbz, '0', --agg 2004.09.10      
                       a.yzlbdy, a.jzbz, a.blzbz, a.sqddm, a.yypdm, a.kjslx, a.kjsbz, a.kjsssyz, a.yyzxh, a.yfzxh, a.jajbz, '',    
                        '', 0, '', 0, a.sqdbbid, a.sqdbbzl, a.yyts ,a.ypsl,a.zfybz ,a.sqgyfl,a.szyzbz,a.ssxh,a.sqbz,a.szyzzxrq--,a.zpdf    
                                ,a.tcwbz  ,a.drsssbz,a.sssksdm    
                       from #yzlrtmp a, YY_LCSFXMK c(nolock), YY_SFXXMK d(nolock)      
                       where a.yzlb = 0 and a.xmlb in (6, 7) and a.lcxmdm <> '0' and a.lcxmdm = c.id and c.zxmdm = d.id and a.sqddm > 0      
                       if @@error <> 0      
                       begin      
                        select  'F', '处理申请单信息出错！'      
                         return      
                       end      
                      end      
                      --处理停止医嘱        
                      if exists(select  1 from #yzlrtmp where xmlb = 9)      
                      begin      
                       insert into  #yzk      
                       select  a.lrxh, a.v5xh, b.fzxh, a.ysdm, a.ksrq, a.pcdm, 1, 1, 0, a.zdm, a.zxsj, a.idm, b.gg_idm, b.lc_idm,      
                       b.ypdm, convert(varchar(256), '停*' + b.ypmc), b.ypjl, b.jldw, b.dwlb, b.ypsl, b.ypgg, b.zxdw, b.ztnr,      
                       convert(varchar(256), '停*' + b.yznr), b.ypyf, b.zxksdm, 9, b.xh, isnull(a.jsrq, ''), b.zbybz, b.zdydj,      
                       b.dybz, b.djfl, b.yzdjfl, '', 0, '', '', '', 0, 1, b.cgyzbz, b.yjqrbz      
                       , a.hzxm, a.yexh, '', a.mzxdfh, a.jjbz, a.ybshbz, a.ybspbh, a.sstyz, a.sqzd, a.lzbz, a.lcxmdm, 0, a.sybpno, a.systype, 0, '', '0',      
                       9, a.jzbz, a.blzbz, a.sqddm, a.yypdm, a.kjslx, a.kjsbz, a.kjsssyz, a.yyzxh, a.yfzxh, a.jajbz, '', '', 0,    
                        '', 0, a.sqdbbid, a.sqdbbzl, a.yyts ,a.ypsl ,a.zfybz ,a.sqgyfl,a.szyzbz,a.ssxh,a.sqbz,a.szyzzxrq--,a.zpdf     
                                ,a.tcwbz ,a.drsssbz,a.sssksdm    
                       from #yzlrtmp a, BQ_CQYZK b(nolock)      
                       where a.yzlb = 0 and a.xmlb = 9 and b.syxh = @syxh and b.yexh = @yexh and a.tzxh = b.v5xh --使用序号相等来处理and a.ypdm = b.ypdm and a.idm = b.idm      
                       if @@error <> 0 --or @@rowcount = 0  如果5.0 未发送，停止了，4.0找不到，所以报错误    
                       begin      
                        select  'F', '处理停止医嘱出错！'      
                        return      
                       end      
                                update #yzk set yplh=b.yplh from #yzk a,YK_YPCDMLK b where  b.idm = a.idm      
                      end      
      
                    --处理药品医嘱单据分类，5.0医生站使用4.0病区专用的医嘱单据处理，因为对于医生站的医嘱而言，    
                    --医嘱单据分类的意义不大，是在病区医嘱执行的时候才有作用      
                        declare @yplh ut_kmdm, --药品大类      
                        @ypjx ut_jxdm, --药品剂型      
                        @tsyp varchar(2), --特殊标志      
                        @errmsg varchar(50),      
                        @djfl ut_dm4, --单据分类      
                        @yzdjfl ut_dm4, --      
                        @yzmzxdfh ut_xh12,      
                        @yzsybz ut_bz,      
                        @syksdm ut_ksdm, --输液科室代码      
                        @nysbz ut_bz, --医生标志 1 代表护士      
                        @djbz ut_bz,      
                        @config6372 varchar(255), @config6419 varchar(255), @config6420 varchar(255), @config6421 varchar(255),    
                        @cydyyzzt ut_bz,      
                        @sydjfl_glcq ut_dm4,      
                        @tsbz varchar(2),  
        @cfid smallint, @config6451 varchar(2),@configcydydjfl varchar(2),    
                        @fzxh ut_xh12 --分组序号  
                     select @config6451 = '否'  ,@cydyyzzt=0    
                        select @config6451 = ltrim(rtrim(config))from YY_CONFIG where id = '6451'      
                        if len(ltrim(rtrim(@kzzd)))>=3    
                            select @configcydydjfl =  [dbo].[fun_SplitString](@kzzd,'|',3)     
                     select @nysbz = 1 --默认是医生      
                        select @nysbz = zglb from YY_ZGBMK where id = @czyh --找不到默认是护士，则医生的代码必须和护士保持一致      
                        if not exists(select  * from tempdb..sysobjects where name='#getdjflbyfldm') --创建单据分类临时表    
       create table #getdjflbyfldm    
       (    
        tsbz varchar(2),  --特殊标志    
        djfl ut_dm4,  --单据分类    
        fzxh ut_xh12, --分组序号    
                                yzbz char(1)  --长期/临时医嘱    
       )    
      else     
       drop table #getdjflbyfldm    
                     --出院带药不需要有单据分类    
                     if exists(select  1 from #yzk where yzlb in (0, 1, 2, 3, 4, 5, 6, 7, 8) or (@configcydydjfl=1 and yzlb=12))      
                     begin      
                       declare  cs_getdjfl cursor for      
                            select  a.yplh, a.ypjx, a.tsyp, a.ypyf, a.yzbz, a.djfl, a.yzdjfl, a.yjqrbz, a.mzxdfh, isnull(b.bqdjbz, 0), c.tsbz, isnull(c.cfid, 1)cfid ,a.fzxh     

                            from #yzk a    
                            left join YK_YPCDMLK b(nolock) on  (a.yzlb in (0, 1, 2, 3, 4, 5, 6, 7, 8) or (@configcydydjfl=1 and yzlb=12)) and a.idm = b.idm and b.tybz = 0     
                            left join YF_YFZKC c(nolock) on  a.zxksdm = c.ksdm and a.idm = c.cd_idm     
                            where   1=1 and (a.yzlb in (0, 1, 2, 3, 4, 5, 6, 7, 8) or (@configcydydjfl=1 and yzlb=12))     

     

                            for update of djfl, yzdjfl      
      
                      open cs_getdjfl      
fetch cs_getdjfl into @yplh, @ypjx, @tsyp, @ypyf, @yzlb, @djfl, @yzdjfl, @yjqrbz, @yzmzxdfh, @djbz, @tsbz, @cfid,@fzxh      
       while @@fetch_status = 0      
                      begin      
                       select @yzsybz = 0      
                        if @yzmzxdfh > 0      
                       select @yzsybz = 2      
                       if @config6451 = '是'      
                        exec usp_bq_djfl @yplh, @ypjx, @tsbz, @ypyf, @yzlb, @errmsg output, @yjqrbz, @yzsybz, @djbz, @cfid      
                       else      
                        exec usp_bq_djfl @yplh, @ypjx, @tsyp, @ypyf, @yzlb, @errmsg output, @yjqrbz, @yzsybz, @djbz      
                       if @errmsg like 'F%'      
                        select @djfl = ''      
                       else      
                        select @djfl = substring(@errmsg, 2, 4)      
       
                       update #yzk set  djfl = @djfl where current of cs_getdjfl      
                                declare @getdjflbytsbz ut_mc16    
        select @getdjflbytsbz=dbo.Get_djflfromconfig(LTRIM(RTRIM(@tsbz)),1)--长期医嘱    
        if rtrim(ltrim(@getdjflbytsbz))<>'' and @djfl=rtrim(ltrim(@getdjflbytsbz))    
         insert into #getdjflbyfldm select @tsbz,@getdjflbytsbz,@fzxh,1    
            
        set @getdjflbytsbz=''    
        select @getdjflbytsbz=dbo.Get_djflfromconfig(LTRIM(RTRIM(@tsbz)),0)--临时医嘱    
        if rtrim(ltrim(@getdjflbytsbz))<>'' and @djfl=rtrim(ltrim(@getdjflbytsbz))    
         insert into #getdjflbyfldm select @tsbz,@getdjflbytsbz,@fzxh,0    
       
                       exec usp_bq_yzdjfl @yplh, @ypjx, @tsyp, @ypyf, @yzlb, @errmsg output, @yjqrbz, @yzsybz      
                       if @errmsg like 'F%'      
                        select @yzdjfl = ''      
                       else      
                        select @yzdjfl = substring(@errmsg, 2, 4)      
      
                       update #yzk set  yzdjfl = @yzdjfl where current of cs_getdjfl      
       fetch cs_getdjfl into @yplh, @ypjx, @tsyp, @ypyf, @yzlb, @djfl, @yzdjfl, @yjqrbz, @yzmzxdfh, @djbz, @tsbz, @cfid,@fzxh      
                      end      
                      close cs_getdjfl      
                      deallocate cs_getdjfl      
                     end      
                    --需求:29404 长期成组药品单据分类根据参数匹配成功之后.修改成组药品的单据分类为同一单据分类    
                    update #yzk set djfl=b.djfl from #yzk a,#getdjflbyfldm b where a.fzxh=b.fzxh AND a.yzbz=b.yzbz    
                    --更新输液科室代码，通过科室判断输液标志      
      
                     update #yzk set  lszxks = zxksdm where zbybz = 1      
                     select @syksdm = ''      
                     select @config6372 = ',,'      
                     select @syksdm = config from YY_CONFIG(nolock)where id = '6037'      
                     select @config6372 = ',' + ltrim(rtrim(config)) + ',' from YY_CONFIG(nolock)where id = '6372'      
                     if (@config6372 <> ',,') and (@syksdm <> '')      
                        update #yzk set  zxksdm = @syksdm where yzbz = 1      
                        and fzxh in (select  fzxh from #yzk where yzbz = 1 and charindex(',' + ltrim(rtrim(ypyf)) + ',', @config6372) > 0     
                        group by fzxh having count(fzxh) >= 2)      
                        if @syksdm <> ''      
                     begin      
                      update #yzk set  djfl = b.id      
                       from #yzk a, BQ_YZDJFLK b      
                       where a.zxksdm = @syksdm and b.sybz = 1 and b.jlzt = 0      
       
                      update #yzk set  yzdjfl = b.id      
                       from #yzk a, BQ_YZZXDJFLK b      
                       where a.zxksdm = @syksdm and b.sybz = 1 and b.jlzt = 0      
                     end      
      
                     update #yzk set  zxksdm = lszxks where zbybz = 1      

      
                     select @config6419 = '0'      
                        select @config6419 = ltrim(rtrim(config))from YY_CONFIG where id = '6419'      
        
                        if @config6419 <> '0' and @xzbz = 0      
                     begin      
                     select @config6420 = '00:00:00', @config6421 = '24:00:00'      
                            select @config6420 = ltrim(rtrim(config))from YY_CONFIG where id = '6420' and ltrim(rtrim(isnull(config, ''))) <> ''      
                            select @config6421 = ltrim(rtrim(config))from YY_CONFIG where id = '6421' and ltrim(rtrim(isnull(config, ''))) <> ''      
      
                      select @sydjfl_glcq = id from BQ_YZDJFLK(nolock)where sybz = 1 and jlzt = 0      
                            if exists(select  1 from #yzk where yzbz = 1 and djfl = @sydjfl_glcq and (right(ksrq, 8) < @config6420 or right(ksrq, 8) > @config6421))      
                      begin      
                       if @config6419 = '1'      
                       begin      
                        select  'F', 'C', '长期静滴医嘱的开始时间不能在' + @config6420 + '之前或' + @config6421 + '之后'      
                        return      
                       end      
                       else      
                       begin      
                        select  'F', '长期静滴医嘱的开始时间不能在' + @config6420 + '之前或' + @config6421 + '之后'      
                        return      
                       end      
                      end      
                     end      

                    --检测医生处方标志      
                     if @configg075 = '否' --在使用提交方式的时候该功能不用      
                     begin      
                      update #yzk set  sxysbz = c.cfbz      
                      from #yzk b, YY_ZGBMK c where b.ysdm = c.id and b.yzbz in (0, 1)      
                     end      
                     if @configg075 = '是'      
               begin --使用提交方式的时候特殊处理      
                      if @sxysbz = 1      
                      update #yzk set  sxysbz = 0 where yzbz in (0, 1)      
                     else      
                      update #yzk set  sxysbz = 1 where yzbz in (0, 1)      
                     end      
                     create table #Fzxh      
                     (      
                      yzxh ut_xh12 not null,      
                      fzxh ut_xh12 not null,      
                      pcdm ut_dm2 null --用于重新写入联动信息的频次代码      
                     )      
      
                     create table #sybpxh      
                     (      
                      fzxh ut_xh12 not null,      
                      sybpno ut_xh12 null      
                     )      
                    --加密医嘱到memo2      
                        declare @password varchar(16),      
                        @result varchar(9)      
                        select @password = convert(varchar(16), @syxh)      
                        exec usp_yy_encrypt @password, @now, @result output      
                    --后台事务开启      
                     begin tran      
        
                        --需要保留原来申请单信息      
                            update #yzk set  sqdxh = c.sqdxh, sqdxmbz = c.sqdxmbz, sqdsjxm = c.sqdsjxm, yzlb = 7 from #yzk a, #yzlrtmp b, BQ_LSYZK c (nolock)     
                            where a.lrxh = b.lrxh and b.yfzxh = c.xh and c.syxh = @syxh and c.yexh = @yexh and c.yzzt <= 0 and c.sqdxh <> 0 and c.yzzt <> -3      
                            and isnull(c.yzlb2, 0) <> 1      
            
                       --4.0的医嘱始终是先删后保存，只删除本次5.0发送过来的医嘱    
                        delete BQ_LSYZK where syxh = @syxh and yexh = @yexh and yzzt <= 0 and v5xh in (select v5xh from #yzlrtmp where yzlb=0 )      
                        if @@error <> 0      
                        begin      
                            rollback tran      
                                select  'F', '删除临时医嘱时出错！'      
                                return      
                        end      
                      --4.0的医嘱始终是先删后保存，只删除本次5.0发送过来的医嘱    
                        delete BQ_CQYZK where syxh = @syxh and yexh = @yexh and yzzt <= 0 and v5xh in (select v5xh from #yzlrtmp where yzlb=1 )      
                            if @@error <> 0      
                        begin      
  rollback tran      
                                select  'F', '删除长期医嘱时出错！'      
                                return      
                        end      
                        
                    --医嘱库的插入处理      
                         
                      if exists(select  1 from #yzk where yzbz = 0)      
                        begin      
                if exists(select  1 from #yzk where yzbz = 0 and yzlb=9)      
       begin      
        delete a from BQ_LSYZK a, #yzk b    
        where a.syxh=@syxh and a.tzxh = b.tzxh and a.yzlb=9 and b.yzlb = 9 and     
              b.yzbz = 0 and a.v5xh>0 and a.yzzt=0     
                  

                                --预停止    
        select distinct a.tzxh into #tempshwtzxh    
        from BQ_LSYZK a (nolock), #yzk b    
        where a.syxh=@syxh and a.tzxh = b.tzxh and a.yzlb=9 and b.yzlb = 9 and     
              a.yzzt in (1,2) and a.v5xh>0 and b.yzbz = 0 and     
                                      substring(a.tzrq,1,8) > substring(a.lrrq,1,8) and    
              not exists(select 1 from BQ_CQYZK c(nolock) where c.syxh=@syxh and c.xh=a.tzxh and c.v5xh>0 and c.yzzt=4)    
                  
        if exists (select 1 from #tempshwtzxh)    
        begin            
          update BQ_LSYZK set yzzt = 3     
          where  syxh=@syxh and yzlb=9 and yzzt in(1,2) and v5xh>0 and tzxh in(select tzxh from #tempshwtzxh)    
              
          update BQ_CQYZK set tzrq='',tzczyh='',tzysdm=''  
          where syxh=@syxh and xh in(select tzxh from #tempshwtzxh) and v5xh>0 and yzzt<>4       
 end    
       end    
                           -- if len(ltrim(rtrim(@kzzd)))>=2    
                           -- select @xcfhssh =  [dbo].[fun_SplitString](@kzzd,'|',2)     
                             if exists(select 1 from CISSVR.CISDB.dbo.CPOE_XCF_SZ where ID= '0013' AND VALUE='是')     
                            select @xcfhssh = '是'    
                            --小处方审核模式判断；    
                            declare @xcfhsshbz varchar(32)    
                            select @xcfhsshbz='否'    
                            if exists(select 1 from CISSVR.CISDB.dbo.CPOE_XCF_SZ where ID= '0013' AND VALUE='是')     
                                select  @xcfhsshbz='是'    
                            insert into  BQ_LSYZK(syxh, fzxh, bqdm, ksdm, ysdm, lrrq, lrczyh, ksrq, pcdm, idm, gg_idm,      
                            lc_idm, ypdm, ypmc, ypjl, jldw, dwlb, ypsl, ypgg, zxdw, ztnr, yznr, ypyf, zxksdm, yzlb,      
                            mzdm, tzxh, tzrq, yzzt, zbybz, zdydj, dybz, djfl, yzdjfl, cgyzbz, yjqrbz, hzxm, yexh, memo,      
                            mzxdfh, jjbz, ybshbz, ybspbh, sstyz, sqzd, sxysdm, lcxmdm, sybph, memo2, sqdxh, sqdxmbz, sqdsjxm, yzlbdy, jzbz, blzbz, sqdid, yypdm, kjslx, kjsbz, kjsssyz      
                            , jajbz, pxxh, dmjszd, dmjszjlx, dmjszjh, dmjsbz, yzlb2, v5xh, yshdbz,zfybz,sqgyfl,sqbz,zxrq,tcwbz,ssaprq)  --winnign-dingsong-chongqing add ,ssaprq   
                            select @syxh, fzxh, @bqdm, @ksdm, case when(@sxysbz = 2 and sxysbz = 0) then @czyh      
                            else ysdm end, @now, case when(@sxysbz = 2 and sxysbz = 0) then @czyh when(systype = 1) then @czyh when @nysbz = 2 then @czyh      
                      else ysdm  end, ksrq, pcdm, idm, gg_idm, lc_idm, ypdm, convert(varchar(256), ypmc) , ypjl, jldw, dwlb, ypsl, ypgg, zxdw,  (case when isnull(sstyz, 0) = 0 then ztnr      
                      else  ltrim(rtrim(ztnr)) + '[停长期医嘱]' end),     
                      convert(varchar(256), yznr), ypyf, zxksdm, yzlb,  mzdm, tzxh, tzrq,     
                            --医嘱状态的计算    
                            case when @xcfhssh='是' and yzlb=97 then 0 when(@sxysbz = 1 and sxysbz = 0) then - 1      
                            --小处方产生的 不需要审核执行，但是护士需要签名 for 8974 aorigele 2014/1/13    
        --小处方走审核模式 医嘱状态0，审核、执行后产生发药请求库 aorigele 2017/4/4    
                      when yzlb = 14 and idm>0  then (case when @xcfhsshbz='是' then 0 else 2 end)                     
                            when szyzbz=1 then -2 else 0  end,                          
                      zbybz, zdydj, dybz, djfl, yzdjfl, cgyzbz, yjqrbz, hzxm, yexh, case when szyzbz=1 then 'SZYZ' when @config6432 = '是' then '[' + convert(varchar(20), yyzxh) + ']' + memo      
                      else memo  end,  mzxdfh, jjbz, ybshbz, ybspbh, sstyz, sqzd, case when @sxysbz = 2 then ysdm      
                      else  ''  end, lcxmdm, sybpno, @result, isnull(sqddm,0), sqdxmbz, sqdsjxm, --增加lcxmdm      
                       case when yzlbdy = -1 then yzlb when yzlbdy=20 then 6 when yzlbdy=21 then 7 else  yzlbdy  end, jzbz, blzbz, 0, yypdm, kjslx, kjsbz, kjsssyz      
                      , jajbz, 999999, zddm, zjlx, zjhm, Jsdmbz, case when szyzbz=1 then 1 else 0  end, v5xh, 1 ,zfybz,sqgyfl,sqbz,szyzzxrq,tcwbz,b.SQRQ --winnign-dingsong-chongqing add ,b.SQRQ   
                      from #yzk a
					  left join CISDB..CPOE_SSYZK  b on a.v5xh=b.YZXH and b.JLZT=0 --winnign-dingsong-chongqing
					  where a.yzbz = 0 and isnull(a.sqdxh, 0) = 0 and a.yzlb <> 12 order by a.fzxh      
                      if @@error <> 0      
                      begin      
                       rollback tran      
                        select  'F', '保存临时医嘱时出错！'      
                        return      
                      end      
                         if(@xcfhsshbz='是')                          
                        update ZY_XCFMXK    
                        set yzxh=a.xh    
       from BQ_LSYZK a    
               join CISSVR.CISDB.dbo.CPOE_LSYZK b    
                        on a.v5xh=b.XH    
    join CISSVR.CISDB.dbo.CPOE_XCFMXK c    
                       on b.XH=c.YZXH    
                       join ZY_XCFMXK d    
                       on c.XH=d.v5xh    
                       join #yzk f    
                       on a.v5xh=f.v5xh    
                      if exists(select 1 from #yzk where szyzbz = 1 )        
                            begin        
                                if exists(select 1 from sysobjects where name='BQ_LSYZK_FZ') --增加表判断因为外地的HIS版本都非常老    
                                begin    
             insert into BQ_LSYZK_FZ(syxh,yzxh,sssksdm,ssxh,tgbz,drsssbz)      
             select @syxh,a.xh,case WHEN b.sssksdm<>'' THEN b.sssksdm else c.ssksdm END,c.xh,1,b.drsssbz from BQ_LSYZK a (nolock),#yzk b ,SS_SSDJK c      
             where a.syxh = @syxh and a.v5xh=b.v5xh and c.xh = b.ssxh and a.yzlb2=1  AND b.yzlb!=6 AND b.yzlb!=7    
             if @@error <> 0        
             begin        
             rollback tran        
              select  'F', '保存临时辅助医嘱时出错！'        
              return        
             end     
                                     insert into BQ_LSYZK_FZ(syxh,yzxh,sssksdm,ssxh,tgbz,drsssbz)    
          SELECT @syxh,a.xh,case WHEN a.sssksdm<>'' THEN a.sssksdm else c.ssksdm END,c.xh,1,a.drsssbz FROM     
          (    
               SELECT a.xh,b.ssxh,b.drsssbz,b.sssksdm   FROM BQ_LSYZK a INNER JOIN  #yzk b ON  a.v5xh=b.v5xh     
               where a.syxh = @syxh and a.yzlb2=1 and(b.yzlb=6 or b.yzlb=7)    
               GROUP BY a.xh,ssxh,b.drsssbz,b.sssksdm      
          ) a INNER JOIN SS_SSDJK c   ON c.xh=a.ssxh     
          if @@error <> 0        
             begin        
                rollback tran        
                select  'F', '保存临时检查检验辅助医嘱时出错！'        
                return     
              end    
                                end                             
                            end           
                            --手术医嘱的直接登记到手术登记库中，医嘱不审核 aorigele 这个需求用于医生站医嘱直接产生到SS_SSDJK中，医嘱审核时候不产生（4.0有开关)    
                            --需求 7525    
                            --select * from YY_CONFIG WHERE id = 'G090'    
                            --if (select config from YY_CONFIG (nolock) where id='G090')='是'       
                            if LEN(ltrim(rtrim(@kzzd)))>=1   --前台参数传入过来           
          begin            
                                  
        --if (select config from YY_CONFIG (nolock) where id='6036')='是'     
   DECLARE @jzss VARCHAR(2)      
                                DECLARE @fjzss VARCHAR(2)       
                                DECLARE @ss VARCHAR(5)       
                                SELECT @ss= [dbo].[fun_SplitString](@kzzd,'|',1) --获取术中医嘱标志              
                                SELECT @fjzss = SUBSTRING(@ss,1,1)--非急诊手术    
                                SELECT @jzss=SUBSTRING(@ss,3,1)--急诊手术    
                                 DECLARE @fsSs VARCHAR(50)         
        if ((@jzss='1'  OR @fjzss='1')and @HP405='否')        
        begin      
                                 IF (@jzss=1)    
                                BEGIN    
                                  SET @fsSs='  v.ISQJ IN(1)'    
                                END    
                                 IF (@fjzss=1)    
                                BEGIN    
                                 SET @fsSs='  v.ISQJ IN(0,2)'    
                                END    
                                 IF (@jzss=1 and @fjzss=1)    
                                BEGIN    
                                   SET @fsSs=' v.ISQJ IN(0,1,2)'    
                                END            
           --insert into SS_SSDJK(syxh, yzxh, patid, blh, hzxm, py, wb, bqdm, ksdm,cwdm, djrq, djczyh, sqrq, ssdm, ssmc, mzdm, mzmc, ssksdm,               
           --      glbz, qkdj, jlzt, slbz, sslb, memo, ysdm,sqzd,haabz)              
          -- select @syxh, c.xh, a.patid, a.blh, a.hzxm, a.py, a.wb, a.bqdm, a.ksdm,a.cwdm, @now, @czyh, c.ksrq, c.ypdm, c.ypmc, c.mzdm,isnull((select name from  SS_SSMZK b (nolock) where b.id=c.mzdm),''), c.zxksdm,    
          --       0, null,0, 0, 0, convert(varchar(24),c.ztnr), case isnull(c.memo,'') when '' then (case isnull((select name from  SS_SSMZK b (nolock) where b.id=c.mzdm),'') when '' then '' else c.ysdm end) else c.memo end as ysdm,c.sqzd,'-1'          









  




          -- from ZY_BRSYK a (nolock), BQ_LSYZK c(nolock) ,#yzk d     
          -- where a.syxh=@syxh and c.syxh=@syxh and c.yexh = @yexh  and c.yzzt=0 and c.yzlb=2      
           --  and c.v5xh = d.v5xh      
                                   EXEC (' insert into SS_SSDJK(syxh, yzxh, patid, blh, hzxm, py, wb, bqdm, ksdm,cwdm, djrq, djczyh, sqrq, ssdm, ssmc, mzdm, mzmc, ssksdm,                   
                                         glbz, qkdj, jlzt, slbz, sslb, memo, ysdm,sqzd,haabz,dcnyjbz,bwid,ysksdm,zssdmjh,zssmcjh,fssdmjh,fssmcjh)                  
                                        select CAST('+@syxh+' AS VARCHAR(10)), c.xh, a.patid, a.blh, a.hzxm, a.py, a.wb, a.bqdm, a.ksdm,a.cwdm, '''+@now+''', '''+@czyh+''', c.ksrq, c.ypdm, c.ypmc, c.mzdm,isnull((select name from  SS_SSMZK b (nolock) where




  
 b.id=c.mzdm),''''), case isnull(v.SSKSDM,'''') when '''' then c.zxksdm ELSE v.SSKSDM end as ssksdm ,        
                                         0, null,0, 0, 0, convert(varchar(24),c.ztnr), case isnull(c.memo,'''') when '''' then (case isnull((select name from  SS_SSMZK b (nolock) where b.id=c.mzdm),'''') when '''' then '''' else c.ysdm end) else replace(c




  
.memo, left(c.memo,charindex('']'',c.memo)),'''') end as ysdm,c.sqzd,''-1'',v.DCNYJBZ,v.TW ,v.YSKSDM,v.ZSSDM,v.ZSSMC,v.FSSDM,v.FSSMC            




                                   from ZY_BRSYK a (nolock), BQ_LSYZK c(nolock) ,#yzk  d  ,V5_SSYZK v    
                                   where a.syxh=CAST('+@syxh+' AS VARCHAR(10)) and c.syxh=CAST('+@syxh+' AS VARCHAR(10)) and c.yexh =CAST('+@yexh+' AS VARCHAR(10)) AND d.v5xh=v.YZXH AND v.SYXH=CAST('+@syxh+' AS VARCHAR(10))  and c.yzzt=0 and c.yzlb=2     







  
     
                                     and c.v5xh = d.v5xh and '+ @fsSs)    
           if @@error<>0              
           begin              
             rollback tran              
             select 'F','插入手术登记库出错！'              
             return              
           end        
                                          --这个医院可以根据需要调整,    
                    --这里放开是发送消息给当前病区,护士站如果启用了消息就收就可以查看到,否则不行    
         --发送消息给当前病区    
                    declare @ysdmyy2 ut_czyh,@bqdm_curryy2 ut_ksdm,@send_msgyy2 varchar(100)    
                    select @bqdm_curryy2=b.bqdm,@send_msgyy2=c.HZXM+c.MEMO,@ysdmyy2=c.LRCZYH from BQ_LSYZK     
 a left join SS_SSDJK b on a.xh=b.yzxh left join     
 CISSVR.CISDB.dbo.CPOE_LSYZK c on c.XH=a.v5xh    
 where v5xh in (select v5xh from #yzlrtmp) and b.yzxh is not null      
if (isnull(@send_msgyy2,'') <> '')     
                    exec usp_yy_autosendmsg 2,@ysdmyy2,'',@bqdm_curryy2,@send_msgyy2     
           --更新4.0本次手术医嘱状态更新为已执行    
          -- update c set c.yzzt = 2,shczyh = c.ysdm,zxczyh=c.ysdm,shrq =c.lrrq,zxrq = SUBSTRING(c.lrrq,1,8)    
            -- from BQ_LSYZK c(nolock) ,#yzk d     
           -- where c.syxh=@syxh and c.yexh = @yexh and c.yzzt=0 and c.yzlb=2  and c.v5xh = d.v5xh      
                EXEC (' update c set c.yzzt = 2,shczyh = c.ysdm,zxczyh=c.ysdm,shrq =c.lrrq,zxrq = SUBSTRING(c.lrrq,1,8)    
             from BQ_LSYZK c(nolock) ,#yzk d ,V5_SSYZK v    
            where c.syxh=CAST('+@syxh+' AS VARCHAR(10)) and c.yexh = CAST('+@yexh+' AS VARCHAR(10))  and c.yzzt=0 and c.yzlb=2  and c.v5xh = d.v5xh AND   d.v5xh=v.YZXH AND  v.SYXH=CAST('+@syxh+' AS VARCHAR(10))    
            AND'+ @fsSs)    
   if @@error<>0              
           begin              
             rollback tran              
             select 'F','审核手术医嘱出错！'              
             return              
           end     
        end      
                               else    
                               begin    
                   
                                 if ( @HP405='是' and exists(select  1 from #yzlrtmp_ss  where  xmlb=2 ))----- 主任审核的时候才插登记-信息          
                                    begin        
                                     insert into SS_SSDJK(        
                                      syxh, yzxh, patid, blh, hzxm, py, wb, bqdm, ksdm,           
                                            cwdm, djrq, djczyh, sqrq, ssdm, ssmc,ssdjdm, mzdm, mzmc, ssksdm,           
                                            glbz, qkdj, jlzt, slbz, sslb, memo, ysdm,sqzd,haabz,aprq,dcnyjbz,bwid,ysksdm,zssdmjh,zssmcjh,fssdmjh,fssmcjh)          
                                        select         
                                      @syxh, c.xh, a.patid, a.blh, a.hzxm, a.py, a.wb, a.bqdm, a.ksdm,          
                                            a.cwdm, @now, @czyh, c.ksrq, d.ypdm, c.ypmc,isnull((select djdm from  SS_SSMZK b(nolock) where b.id=d.ypdm),''), c.mzdm,isnull((select name from  SS_SSMZK b(nolock) where b.id=c.mzdm),'')        
                                            , case isnull(v.SSKSDM,'''') when '''' then c.zxksdm ELSE v.SSKSDM end as ssksdm,0, null,0, 0, 0, convert(varchar(24),c.ztnr),         
                                            case isnull(c.memo,'') when '' then (case isnull((select name from  SS_SSMZK b (nolock) where b.id=c.mzdm),'') when '' then '' else SUBSTRING(c.ysdm,1,6) end) else SUBSTRING(c.memo,1,6) end as ysdm,c.sqzd,'-1',



c

  
.ssaprq ,v.DCNYJBZ,v.TW,v.YSKSDM,v.ZSSDM,v.ZSSMC,v.FSSDM,v.FSSMC         






                                            from ZY_BRSYK a (nolock), BQ_LSYZK c(nolock),#yzlrtmp_ss d,V5_SSYZK v          
                                            where a.syxh=c.syxh and d.yzlb = 0 and d.xmlb = 2 and d.idm = 0 and c.v5xh=d.v5xh   and c.v5xh=v.YZXH     
         
                                         if @@error<>0          
                                         begin          
                                          rollback tran          
                                          select 'F','审核手术医嘱出错！'          
                                          return          
  end      
                                          --这个医院可以根据需要调整,    
                    --这里放开是发送消息给当前病区,护士站如果启用了消息就收就可以查看到,否则不行    
                    --发送消息给当前病区    
                    declare @ysdmyy1 ut_czyh,@bqdm_curryy1 ut_ksdm,@send_msgyy1 varchar(100)    
                    select @bqdm_curryy1=b.bqdm,@send_msgyy1=c.HZXM+c.MEMO,@ysdmyy1=c.LRCZYH from BQ_LSYZK     
 a left join SS_SSDJK b on a.xh=b.yzxh left join     
 CISSVR.CISDB.dbo.CPOE_LSYZK c on c.XH=a.v5xh    
 where v5xh in (select v5xh from #yzlrtmp) and b.yzxh is not null      
        if (isnull(@send_msgyy1,'') <> '')     
                    exec usp_yy_autosendmsg 2,@ysdmyy1,'',@bqdm_curryy1,@send_msgyy1     
                                     end    
                               end            
          end    
      
                    --处理出院带药的医嘱      
                            --declare @hp44 varchar(4)--出院带药是否开门诊单位开关    
                            declare @hp123 varchar(4)--设置出院带药的录入模式是否为简单模式    
                           declare @config3180 varchar(4)--多零售价模式    
       select @config3180 = config from YY_CONFIG where id = '3180'    
                            select @hp123= CONFIG from CISSVR.CISDB.dbo.SYS_CONFIG WHERE ID='HP123'    
                            if exists(select 1 from YY_CONFIG(nolock)where id = '6584' and config='是')    
         select @cydyyzzt=0    
                      else    
     select @cydyyzzt=-2 --出院带药在医生站计费部分，已经移出去成为单独的后台了    
       
                      insert into  BQ_LSYZK(syxh,hzxm, fzxh, bqdm, ksdm, ysdm, lrrq, lrczyh, shrq, shczyh,      
                      zxrq, zxczyh, dcczyh, xzczyh, ksrq, pcdm, idm, gg_idm, lc_idm, ypdm, ypmc,      
                      ypjl, jldw, dwlb, ypsl, ypgg, zxdw, ztnr, yznr, ypyf, zxksdm, yzlb, tzxh, tzrq,      
                      yzzt, zbybz, zdydj, dcysdm, dybz, djfl, memo, ybshbz, ybspbh, lz_zxsj, lz_mcsl,     
                      lz_pcdm, memo2, yexh, v5xh,sqdxh,zfybz,sqgyfl,sqbz,ssaprq)    --winnign-dingsong-chongqing add ,ssaprq     
                      select @syxh,@hzxm, fzxh, @bqdm, @ksdm, a.ysdm, @now, @czyh, null, null,      
                      null, null, null, null, a.ksrq, a.pcdm, a.idm, b.gg_idm, b.lc_idm, b.ypdm, convert(varchar(256), b.ypmc),      
                      a.ypjl,a.jldw, a.dwlb,    
                            case @cydyyzzt when -2    
                            then    
                                 case @hp44 when '是' then a.cydyypsl *  b.mzxs else a.cydyypsl *  b.zyxs end--使用那个系数由开关决定      
                            else    
                                  a.cydyypsl --病区出院带药审核已经乘以了系数，此处不需要在乘以系数    
                            end,    
                       case when ltrim(rtrim(isnull(a.ypgg, ''))) = '' then b.ypgg      
                      else  a.ypgg  end, /* b.mzdw*/    
                            --b.zxdw ,    
                            case @hp44 when '是' then b.mzdw else b.zydw end , --使用那个单位由开关决定    
                         a.ztnr,  b.ypmc + ' ' + case @hp123 when '是' then '' else rtrim(d.name) end      
                      + case @hp123 when '是' then '' else ' 每次' + convert(varchar(18), a.ypjl) + ltrim(rtrim(a.jldw)) end     
                      + case @hp123 when '是' then '' else ' ' + ltrim(rtrim(c.name)) end     
                      + case @hp123 when '是' then '' else ' ' + convert(varchar(4), a.yyts) + '天' + ' ' end     
                            + convert(varchar(12), a.cydyypsl, 3) + case @hp44 when '是' then rtrim(ltrim(b.mzdw)) else RTRIM(LTRIM(b.zydw)) end,      
                      a.ypyf, a.zxksdm, 12, null, null,      
                      @cydyyzzt, a.zbybz, 0, null, 0, a.djfl,    
                      case @hp44 when '是' then convert(varchar(12),  b.mzxs) else convert(varchar(12),  b.zyxs) end ,      
                            --convert(varchar(12),  b.mzxs),     
                            a.ybshbz, a.ybspbh,     
                            case a.pcdm     
                            when '00'     
 then '1天，每天08,'    
                            else     
                               convert(varchar(4), a.yyts)    
                            end,    
                            a.ypjl,      
                      a.pcdm, @result, @yexh, a.v5xh,0  ,zfybz ,sqgyfl,a.sqbz,e.SQRQ     --winnign-dingsong-chongqing add ,e.SQRQ
                        
                            from #yzk a 
							inner join YK_YPCDMLK b (nolock) on a.idm = b.idm     
                            left join ZY_YPYFK c (nolock) on a.ypyf = c.id      
                            left join ZY_YZPCK d (nolock) on a.pcdm = d.id   
							left join CISDB..CPOE_SSYZK e on a.v5xh=e.YZXH and e.JLZT=0 --winnign-dingsong-chongqing 
                            where a.yzlb = 12    


                      if @@error <> 0      
                      begin      
                       rollback tran      
                       select  'F', '保存出院带药出错！'      
                       return      
                      end      
                        
                           --3180=2多零售价模式，出院带药库存冻结HIS存储中已处理，此处更新多余    
                           IF @config7002='是' and @config3180<>2 and not exists(select 1 from YY_CONFIG(nolock)where id = '6584' and config='是')    
        BEGIN    
                        if dbo.f_get_ypxtslt() <> 3    
                    begin    
                                      declare @vIdm ut_xh9,    
                            @vmxxh ut_xh12,    
                            @vYfdm ut_ksdm,    
                            @vYpsl ut_sl10,    
                            @rtnmsg varchar(50)    
                             declare cs_cydykc cursor for               
                                         select distinct idm,zxksdm,v5xh, cydyypsl*zyxs as ypsl  from #yzk where  yzlb=12 and zbybz=0           
                                         for read only                     
                                         open cs_cydykc              
                                         fetch cs_cydykc into @vIdm, @vYfdm,@vmxxh ,@vYpsl         
                                         while @@fetch_status=0              
                                         begin          
                                           exec usp_yf_jk_yy_freeze 1,@vYfdm,'BQ_LSYZK',@vmxxh,@vIdm,@vYpsl,0,@rtnmsg output    
                                           if @@error<>0 or @rtnmsg<>'T'    
                                           begin    
                             rollback tran      
                             close cs_cydykc        
                             deallocate cs_cydykc    
                             select 'F','更新虚库存(djsl)出错：'+@rtnmsg             
                             return          
                                           end    
                                         fetch cs_cydykc into @vIdm, @vYfdm ,@vmxxh ,@vYpsl     
                                         end    
                                         close cs_cydykc              
                                         deallocate cs_cydykc     
                                end    
                                else    
                                begin    
         UPDATE YF_YFZKC SET djsl= a.djsl + b.cydyypsl*b.zyxs  FROM YF_YFZKC  a, #yzk b WHERE b.yzlb=12 and b.zbybz=0 and a.cd_idm=b.idm AND a.ksdm=b.zxksdm    
         if @@error<>0    
         begin    
          rollback tran    
          select 'F','更新虚库存(djsl)出错！'    
          return    
         end    
                                end    
        END     

                    --以上处理出院带药的医嘱      


      
                      if @config6432 = '是'      
                      begin      
                       select  xh yzxh, convert(int, substring(memo, 2, charindex(']', memo) - 2))yyzxh into  #lsssyz_temp      
                       from BQ_LSYZK (nolock)    
                       where fzxh in (select fzxh from #yzk) and syxh = @syxh and yexh = @yexh and v5xh in (select v5xh from #yzlrtmp where yzlb=0 ) and    
                       yzzt <= 0 and yzzt <> -3 and isnull(sqdxh, 0) = 0 and charindex(']', memo) > 2      
                       and isnull(yzlb2, 0) <> 1      
                       if @@error <> 0      
                       begin      
                        rollback tran      
                        select  'F', '查询临时医嘱时出错！'      
                        return      
                       end      
   
                       update BQ_LSYZK set  kjsssyz = a.yzxh      
                       from #lsssyz_temp a      
                       where kjsssyz = a.yyzxh and kjslx > 0 and kjsbz > 0 and syxh = @syxh and yexh = @yexh      
                       and isnull(yzlb2, 0) <> 1      
                       if @@error <> 0      
                       begin      
                        rollback tran      
                        select  'F', '更新临时医嘱时出错！'      
                        return      
                       end      
        
                       drop table #lsssyz_temp      
        
                       update BQ_LSYZK set  memo = substring(memo, charindex(']', memo) + 1, len(memo) - charindex(']', memo))      
        where fzxh in (select  fzxh from #yzk) and syxh = @syxh and yexh = @yexh and v5xh in (select v5xh from #yzlrtmp where yzlb=0 )     
                       and yzzt <= 0 and yzzt <> -3 and isnull(sqdxh, 0) = 0 and charindex(']', memo) > 2      
                       and isnull(yzlb2, 0) <> 1      
                       if @@error <> 0      
                       begin      
                        rollback tran      
                        select  'F', '更新临时医嘱时出错！'      
                        return      
                       end      
                      end      
      
                      insert into  #Fzxh      
                      select  min(xh), fzxh, pcdm from BQ_LSYZK (nolock) where syxh = @syxh and yexh = @yexh and yzzt <= 0  and    
                      v5xh in (select v5xh from #yzlrtmp where yzlb=0)     
                      and ((yzzt <> -3 and isnull(yzlb2, 0) <> 1) or (isnull(yzlb2, 0)=1 and yzzt=-2)) group by fzxh, pcdm      
                      if @@error <> 0      
                      begin      
                       rollback tran      
                       select  'F', '保存临时医嘱时出错！'      
                       return      
                      end      
      
      
                    --在这里处理临嘱的变化 ,排斥出院带药的临嘱处理，前面已经处理过了     
      
                      declare @retmsg2 int,      
                      @lz_pcdm ut_dm2,      
                      @lz_xh ut_xh12,      
                      @lz_ypjl ut_sl14_3,      
                      @lz_ypsl ut_sl10,      
                      @lz_zdm char(7), --周代码      
                      @lz_zxsj ut_mc256, --执行时间      
                      @lz_zxcs int, --执行次数      
                      @lz_ksrq ut_rq16, --开始日期      
                      @lz_zxrq ut_rq16, --执行日期      
                      @lz_tzrq ut_rq16, --停止日期      
                      @lz_mcsl ut_sl14_3, --临嘱的每次数量      
                      @lz_idm ut_xh9,      
                      @lz_ljlybz ut_bz --累计领药标志      
       
                      create table #hour(hr char(2) not null)      
                      create table #time(zxrq ut_rq8 not null, zxsj ut_rq16 not null)      
       
                      declare  cs_lz cursor for     
                      select  a.xh, a.pcdm, a.ksrq, a.ypjl, a.ypsl, a.idm from BQ_LSYZK a (nolock), #Fzxh b      
                      where a.syxh = @syxh and a.yexh = @yexh and a.yzzt <= 0 and a.yzzt <> -3 and a.yzlb<>12 and a.yzlb<>14 and    
                      a.fzxh = b.fzxh and (a.pcdm <> '00' and a.pcdm <> '' and a.pcdm <>'99')      
                      and (isnull(a.yzlb2, 0) <> 1 or (isnull(a.yzlb2, 0)=1 and a.yzzt=-2))    
                      for update of a.pcdm, ypjl, ypsl, yznr      
                      open cs_lz      
                      fetch cs_lz into @lz_xh, @lz_pcdm, @lz_ksrq, @lz_ypjl, @lz_ypsl, @lz_idm      
                      while @@fetch_status = 0      
                      begin      
                       select @lz_mcsl = @lz_ypjl      
                       select @lz_zdm = zbz, @lz_zxsj = zxsj, @lz_zxcs = zxcs from ZY_YZPCK where id = @lz_pcdm      
                                select @lz_ksrq=substring(@lz_ksrq,1,8)+'00:00:00'     
                       exec usp_bq_yzpcsf @lz_pcdm, @lz_zdm, @lz_zxsj, @lz_zxcs, @lz_ksrq, @lz_ksrq, '', @retmsg2 output      
       
                       --增加临嘱取整的处理      
                       if @lz_idm > 0      
                       begin      
                        select @lz_ljlybz = ljlybz from YK_YPCDMLK b(nolock)where idm = @lz_idm      
                        if @lz_ljlybz = 0      
                        select @lz_ypjl = @lz_ypjl * @retmsg2, @lz_ypsl = ceiling(@lz_ypsl) * @retmsg2      
                       else      
                        select @lz_ypjl = @lz_ypjl * @retmsg2, @lz_ypsl = @lz_ypsl * @retmsg2      
                    end      
      else      
                        select @lz_ypjl = @lz_ypjl * @retmsg2, @lz_ypsl = @lz_ypsl * @retmsg2      
       
       
           if @configg007 = '是'      
                       begin      
                        update BQ_LSYZK set  ypjl = @lz_ypjl, ypsl = @lz_ypsl,      
                        yznr = case a.yzlb when 2 then a.yznr     
                                                       when 6 then a.yznr     
                                    else ( ypmc + ' ' + isnull(ypgg,'') + ' ' + isnull(convert(varchar(12), @lz_mcsl),'') + ' ' + isnull(ltrim(rtrim(jldw)),'') + ' ' + isnull(ltrim(rtrim(c.name)),'') + ' ' + isnull(d.name,'')) END ,       
                        lz_pcdm = @lz_pcdm, lz_mcsl = @lz_mcsl, lz_zxsj = @lz_zxsj --增加纪录临嘱的原始频次代码和每次数量      

                                    from BQ_LSYZK a     
                                    left join ZY_YPYFK c on a.ypyf = c.id    
                                    left join ZY_YZPCK d on a.pcdm = d.id    
                        where a.xh = @lz_xh and a.pcdm <> '00'      
                         and a.pcdm <> ''  and (isnull(a.yzlb2, 0) <> 1 or (isnull(a.yzlb2, 0)=1 and a.yzzt=-2))     

                       end      
                       else      
                       begin      
                        update BQ_LSYZK set  ypjl = @lz_ypjl, ypsl = @lz_ypsl,      
                        yznr = case a.yzlb when 0 then isnull(ypmc,'') + ' ' + isnull(convert(varchar(12), @lz_mcsl),'') + ' ' + isnull(ltrim(rtrim(jldw)),'') + ' ' + isnull(ltrim(rtrim(c.name)),'') + ' ' + isnull(d.name,'')      
                        when 8 then ypmc + ' ' + isnull(convert(varchar(12), @lz_mcsl),'') + ' ' + isnull(ltrim(rtrim(jldw)),'') + ' ' + isnull(ltrim(rtrim(c.name)),'') + ' ' + isnull(d.name,'')      
                        else yznr  end,lz_pcdm = @lz_pcdm, lz_mcsl = @lz_mcsl, lz_zxsj = @lz_zxsj --增加纪录临嘱的原始频次代码和每次数量      
                            
                                    from BQ_LSYZK a     
                                    left join ZY_YPYFK c on a.ypyf = c.id    
                                    left join ZY_YZPCK d on a.pcdm = d.id    
                        where a.xh = @lz_xh and a.pcdm <> '00'      
                         and a.pcdm <> ''  and (isnull(a.yzlb2, 0) <> 1 or (isnull(a.yzlb2, 0)=1 and a.yzzt=-2))     


                       end      
                       if @@error <> 0 and @@rowcount = 0      
                       begin      
                        rollback tran      
                        close cs_lz      
                        deallocate cs_lz      
                        select  'F', '计算临嘱错误！'      
         
                        return      
                       end      
                       fetch cs_lz into @lz_xh, @lz_pcdm, @lz_ksrq, @lz_ypjl, @lz_ypsl, @lz_idm      
                      end;      
                      close cs_lz      
                      deallocate cs_lz      
       
                      update BQ_LSYZK set  fzxh = b.yzxh      
                      from BQ_LSYZK a, #Fzxh b      
                     where a.syxh = @syxh and a.yexh = @yexh and a.yzzt <= 0 and a.yzzt <> -3 and a.fzxh = b.fzxh and (isnull(a.yzlb2, 0) <> 1 or (isnull(a.yzlb2, 0)=1 and a.yzzt=-2))    
                      --会诊答复自动产生的收费项目，停止日期默认为0001010100:00:00,有问题    
        update BQ_LSYZK set  tzrq=''      
                      from BQ_LSYZK a    
                      where a.syxh = @syxh and a.yexh = @yexh and a.yzzt = 0 and a.tzrq='0001010100:00:00'    
                            if @@error <> 0      
                      begin      
                       rollback tran      
                        select  'F', '保存临时医嘱时出错！'      
                        return      
                      end      
       
                      insert into  #sybpxh      
                      select  distinct a.xh, a.sybph   
                      from BQ_LSYZK a (nolock), #Fzxh b 
                      where a.syxh = @syxh      
                      and a.yexh = @yexh      
                      and a.yzzt <= 0 and a.yzzt <> -3      
                      and a.xh = b.yzxh and (isnull(a.yzlb2, 0) <> 1 or (isnull(a.yzlb2, 0)=1 and a.yzzt=-2))    
                      if @@error <> 0      
                      begin      
                       rollback tran      
                       select  'F', '医嘱编批处理时出错！'      
                       return      
                      end      
       
                      update BQ_LSYZK set  sybph = b.sybpno      
                      from BQ_LSYZK a, #sybpxh b      
                      where a.syxh = @syxh and a.yexh = @yexh and a.yzzt <= 0 and a.yzzt <> -3 and a.fzxh = b.fzxh and (isnull(a.yzlb2, 0) <> 1 or (isnull(a.yzlb2, 0)=1 and a.yzzt=-2))      
                      if @@error <> 0      
                      begin      
                       rollback tran      
                       select  'F', '保存临时医嘱时出错！'      
                       return      
                      end      
       
                     /* 将联动的用法材料信息转入龙华版材料记账信息 */      
                      insert into  BQ_CLJZK(syxh, xmdm, xmmc, xmgg, xmdw, xmdj, xmsl, jzbq, zxksdm, zxksmc, lrry, tzry, lrrq, ksrq, jsrq, zxrq, tzrq, jlzt,      
                      islong, bz, pcdm, zdm, zxsj, zxcs, memo, yexh, fzxh)      
                      select @syxh, a.ypdm, a.yznr, d.xmgg, a.jldw, d.xmdj, a.ypjl, @bqdm, '', '', @czyh, null, @now, a.ksrq, a.jsrq, null,      
                      convert(char(8), dateadd(day, 365, substring(a.ksrq, 1, 8)), 112), -1, 0, 1, b.pcdm, c.zbz, c.zxsj, c.zxcs, null, @yexh, b.yzxh      

                            from  #yzlrtmp a     
                            inner join #Fzxh b  on a.fzbz = b.fzxh    
                            left  join  ZY_YZPCK c(nolock) on b.pcdm = c.id    
                            inner join  YY_SFXXMK d(nolock) on a.ypdm = d.id    
                            where a.yzlb in (2, 3)    
      
                      if @@error <> 0      
                      begin      
                       rollback tran      
                       select  'F', '保存临时医嘱材料时出错！'      
                       return      
                      end      
                         --4.0加急标识的处理    
                            declare @hp369 ut_mc256    
                            select @hp369= ','+RTRIM(CONFIG)+',' from CISSVR.CISDB.dbo.SYS_CONFIG WHERE ID='HP369'    
                            if(@hp369<>'')    
                            begin    
           update a set a.ypmc='(急)'+a.ypmc,a.yznr=a.yznr+'(急)'     
      from BQ_LSYZK a,#yzk b    
                                where a.syxh = @syxh and a.yexh = @yexh and a.jajbz=1 and a.v5xh = b.v5xh and CHARINDEX(','+convert(varchar(2),a.yzlb)+',',@hp369)>0    
                                if @@error <> 0      
                          begin      
                           rollback tran      
                           select  'F', '保存临时医嘱时出错！'      
                           return      
                          end      
                            end    
                    end      
      
                    --申请单处理      
                     if exists(select  1 from #yzlrtmp where xmlb in (6, 7))      
                     begin      
                      insert into  ZY_BRSQD(syxh,yexh, mbxh, lrrq, czyh, sqks, yjlb, blsqdxh, txm,jzbz)      
                            select  distinct @syxh,@yexh, b.yypdm, @now, @czyh, @ksdm, case when b.yzlb = 6 then '02' when  b.yzlb = 7 then '01'  else '' end, sqddm,     
                            case when b.yzlb = 6     
                            then 'A6' + Replace(space(8 - len(abs(sqddm))), ' ', '0') + Convert(varchar, abs(sqddm))  end --只有检查申请单才需要生成条码      
                            ,jzbz    
                   from #yzk b     
                            where isnull(sqddm, 0) <> 0 --只有检查申请单才需要      
                            if @@error <> 0   
                      begin      
                       rollback tran      
                       select  'F', '插入申请单出错1！'      
                       return      
                      end      
      
                      update ZY_BRSQD set  zxks = b.zxksdm, jzbz = b.jjbz      
                      from ZY_BRSQD a, #yzk b      
                      where a.blsqdxh = b.sqddm and isnull(b.sqddm, 0) <> 0 and a.syxh = @syxh      
                      if @@error <> 0      
                      begin      
                       rollback tran      
                       select  'F', '插入申请单出错2！'      
                       return      
                      end     

                             --先删除再插入，需求21155,偶发重复问题    
             declare @sqdxh ut_xh12    
             select @sqdxh = a.xh from  ZY_BRSQD a, #yzk b        
                            where a.blsqdxh = b.sqddm and isnull(b.sqddm, 0) > 0 and a.syxh = @syxh        
             delete from ZY_BRSQDMXK where sqdxh= @sqdxh    

                      insert into  ZY_BRSQDMXK(sqdxh, zyxh, caption, valuedm, value, zlx, taborder, dykz, jlzt, lrczyh, lrrq)      
                            select  distinct a.xh, 16, '条形码', '', a.txm, 0, 0, 0, 0, @czyh, @now      
                            from ZY_BRSQD a, #yzk b      
                            where a.blsqdxh = b.sqddm and isnull(b.sqddm, 0) > 0 and a.syxh = @syxh      
                            if @@error <> 0      
                      begin      
                       rollback tran      
                       select  'F', '插入申请单明细出错1！'      
                       return      
                      end     
      
                      insert into  ZY_BRSQDMXK(sqdxh, zyxh, caption, valuedm, value, zlx, taborder, dykz, jlzt, lrczyh, lrrq)      
                            select  distinct a.xh, -1, 'BBZL', b.sqdbbid, b.sqdbbzl, 0, 0, 0, 0, @czyh, @now      
                            from ZY_BRSQD a, #yzk b      
                            where a.blsqdxh = b.sqddm and isnull(b.sqddm, 0) > 0 and a.syxh = @syxh      
                            if @@error <> 0      
                      begin      
                       rollback tran      
                       select  'F', '插入申请单明细出错1！'      
                       return      
                      end      
      
                      update BQ_LSYZK set sqdxh=b.xh    
                      from BQ_LSYZK a,ZY_BRSQD b    
                      where a.syxh=@syxh and b.syxh=@syxh and a.sqdxh=b.blsqdxh and     
                       b.blsqdxh in (select sqddm from #yzlrtmp where isnull(sqddm, 0) <> 0)    
                      if @@error <> 0    
                      begin    
                       rollback tran    
                       select  'F', '更新临时医嘱申请单序号出错2！'    
    return    
                      end    
      

                      update ZY_BRSQD set  blsqdxh = 0 - a.blsqdxh      
                            from ZY_BRSQD a, #yzk b      
                            where a.blsqdxh = b.sqddm and isnull(b.sqddm, 0) <> 0 and a.syxh = @syxh and b.yzlb = 6      
                     end      
                    --长期医嘱的处理      
                     if exists(select  1 from #yzk where yzbz = 1)      
                     begin      
                      insert into  BQ_CQYZK(syxh, fzxh, bqdm, ksdm, ysdm, lrrq, lrczyh, ksrq,      
                            zxrq, yzxrq, tzrq, pcdm, zxcs, zxzq, zxzqdw, zdm, zxsj,      
                            idm, gg_idm, lc_idm, ypdm, ypmc, ypjl, jldw, dwlb, ypsl, ypgg, zxdw, ztnr, yznr, ypyf, zxksdm,      
                            yzlb, yzzt, zbybz, zdydj, dybz, djfl, yzdjfl, cgyzbz, yjqrbz, ljlybz, hzxm, yexh, mzxdfh, jjbz,      
  ybshbz, ybspbh, lzbz, sxysdm, lcxmdm, sybph, memo2, yzlbdy, sqdid, yypdm      
                            , jajbz, pxxh, dmjszd, dmjszjlx, dmjszjh, dmjsbz, v5xh,zfybz,tcwbz) --,zpdf    
                            select @syxh, fzxh, @bqdm, @ksdm, case when(@sxysbz = 2 and sxysbz = 0) then @czyh      
                      else ysdm  end, @now, case when(@sxysbz = 2 and sxysbz = 0) then @czyh when(systype = 1) then @czyh when @nysbz = 2 then @czyh      
                      else ysdm end, ksrq,convert(char(8), dateadd(dd, (case zxzqdw when 0 then -zxzq else -1 end), substring(ksrq, 1, 8)), 112),      
                      convert(char(8), dateadd(dd, (case zxzqdw when 0 then -zxzq else -1 end), substring(ksrq, 1, 8)), 112),      
                      tzrq, pcdm, zxcs, zxzq, zxzqdw, zdm, zxsj,idm, gg_idm, lc_idm, ypdm, convert(varchar(256), ypmc) , ypjl, jldw, dwlb, ypsl, ypgg, zxdw, ztnr, convert(varchar(256), yznr), ypyf, zxksdm,      
                      yzlb, case when(@sxysbz = 1 and sxysbz = 0) then -1 else 0 end, --增加实习医生处理      
                      zbybz, zdydj, dybz, djfl, yzdjfl, cgyzbz, yjqrbz, ljlybz, hzxm, yexh, mzxdfh, jjbz,      
                      ybshbz, ybspbh, 0, case when @sxysbz = 2 then ysdm else '' end, lcxmdm, sybpno, @result, --增加lcxmdm      
                       case when yzlbdy = -1 then yzlb when yzlbdy=20 then 6 when yzlbdy=21 then 7 else  yzlbdy  end, isnull(sqddm, 0), yypdm      
                      , jajbz, 999999, zddm, zjlx, zjhm, Jsdmbz, v5xh  ,zfybz,tcwbz --,zpdf    
                      from #yzk where yzbz = 1 and lzbz = 0 order by fzxh      
                      if @@error <> 0      
                      begin      
                       rollback tran      
                        select  'F', '保存长期医嘱时出错！'      
                        return      
                      end      
      
                      if exists(select  1 from #yzk where yzlb = 3 and yexh=0) --保存膳食医嘱到首页库中      
                      begin      
                       update ZY_BRSYK      
                       set  ssyz = b.ypmc      
                       from ZY_BRSYK a(nolock), #yzk b      
                       where b.yzlb = 3 and a.syxh = @syxh     
                       if @@error <> 0      
                       begin      
                        rollback tran      
                         select  'F', '更新病人首页库出错！'      
                         return      
                       end      
                      end      
                      if exists(select  1 from #yzk where yzlb = 5) --保存护理医嘱到首页库中      
                      begin      
                       update ZY_BRSYK      
                       set  hlyz = b.ypmc,hldm=b.ypdm      
                       from ZY_BRSYK a(nolock), #yzk b      
                       where b.yzlb = 5 and a.syxh = @syxh      
                       if @@error <> 0      
                       begin      
                        rollback tran      
                        select  'F', '更新病人首页库出错！'      
                        return      
                       end      
                      end      
      
                      delete #Fzxh      
                      delete #sybpxh      
      
                      insert into  #Fzxh      
                      select  min(xh), fzxh, pcdm from BQ_CQYZK (nolock) where syxh = @syxh and yexh = @yexh      
                      and v5xh in (select v5xh from #yzlrtmp where yzlb=1)  and yzzt <= 0 group by fzxh, pcdm      
                      if @@error <> 0      
                      begin      
                       rollback tran      
                       select  'F', '保存长期医嘱时出错！'      
                       return      
                      end      
      
                      update BQ_CQYZK set  fzxh = b.yzxh      
     from BQ_CQYZK a, #Fzxh b      
                      where a.syxh = @syxh and yexh = @yexh and a.yzzt <= 0 and a.fzxh = b.fzxh      
                      if @@error <> 0      
                      begin      
                       rollback tran      
                    select  'F', '保存长期医嘱时出错！'      
                       return      
                      end      
                    --住院医生站开医嘱就开停，在同一分组中的其他医嘱的停止日期未保存上      
                      select  a.fzxh, a.tzrq into  #tzyzdata      
                      from BQ_CQYZK a (nolock), #Fzxh b      
                      where a.syxh = @syxh and yexh = @yexh and a.yzzt <= 0 and a.fzxh = b.yzxh and (ltrim(rtrim(a.tzrq)) <> '' or a.tzrq is not null)      
                      delete from #tzyzdata where(ltrim(rtrim(tzrq)) = '' or tzrq is null)      
                      declare       
                      @nYzxh ut_xh9, @str_tzrq ut_rq16      
                      declare  cs_tzyzrq cursor for      
                      select  fzxh, tzrq      
                      from #tzyzdata      
                      open cs_tzyzrq      
                      fetch cs_tzyzrq into @nYzxh, @str_tzrq      
                      while @@fetch_status = 0      
                      begin      
                       update BQ_CQYZK set  tzrq = @str_tzrq where fzxh = @nYzxh and      
                       syxh = @syxh and yexh = @yexh and yzzt <= 0 and (ltrim(rtrim(tzrq)) = '' or tzrq is null)      
                       if @@error <> 0      
                       begin      
                        rollback tran      
                        close cs_tzyzrq      
                        deallocate cs_tzyzrq      
                        select  'F', '修改分组中长期医嘱停止日期为空的数据出错！'      
                        return      
                       end      
                       fetch cs_tzyzrq into @nYzxh, @str_tzrq      
                      end;      
                      close cs_tzyzrq      
                      deallocate cs_tzyzrq      
      
      
      
                      insert into  #sybpxh      
                      select  distinct a.xh, a.sybph      
                      from BQ_CQYZK a (nolock), #Fzxh b      
                      where a.syxh = @syxh      
                      and a.yexh = @yexh      
                      and a.yzzt <= 0      
                      and a.xh = b.yzxh      
                      if @@error <> 0      
                      begin      
                       rollback tran      
                       select  'F', '医嘱编批处理时出错！'      
                       return      
                      end      
      
                      update BQ_CQYZK set  sybph = b.sybpno      
                      from BQ_CQYZK a (nolock), #sybpxh b      
                      where a.syxh = @syxh and a.yexh = @yexh and a.yzzt <= 0 and a.fzxh = b.fzxh      
                      if @@error <> 0      
                      begin      
                       rollback tran      
                       select  'F', '保存长期医嘱时出错！'      
                       return      
                      end      
      
     
                     end      
      
                    --因为发现有把保存成了@yzdjfl的现象，所以加一段判断      
                     if exists(select  1 from BQ_LSYZK a (nolock) where syxh = @syxh and yzzt <= 0 and yzzt <> -3 and idm > 0 and a.yzlb<>12 and isnull(a.yzlb2, 0) <> 1 and not exists(select  1 from BQ_YZDJFLK b(nolock)where b.jlzt = 0 and a.djfl = b.id)



 




 



)      
                     begin      
                      insert into  YY_ERROR      
                            select  getdate(), '医嘱单据分类' + convert(varchar(12), a.xh) + '0 ' + a.djfl      
                            from BQ_LSYZK a where syxh = @syxh and yzzt <= 0 and yzzt <> -3 and isnull(a.yzlb2, 0) <> 1 and not exists(select  1 from BQ_YZDJFLK b(nolock)where a.djfl = b.id)      
                            if @@error <> 0      
                      begin      
                       rollback tran      
                       select  'F', '保存医嘱单据分类出错信息时出错！'    
                       return      
                      end      
    end      
        --术中医嘱    
      if exists(select 1 from BQ_LSYZK a (nolock) where syxh=@syxh and yzzt=0 and idm>0  and isnull(a.yzlb2,0)=1 and not exists(select 1 from BQ_YZDJFLK b (nolock) where b.jlzt=0 and a.djfl=b.id))    
      begin    
       insert into YY_ERROR    
       select getdate(),'医嘱单据分类'+convert(varchar(12),a.xh)+'0 '+a.djfl    
       from BQ_LSYZK a where syxh=@syxh and yzzt=0  and isnull(a.yzlb2,0)=1 and not exists(select 1 from BQ_YZDJFLK b (nolock) where a.djfl=b.id)    
       if @@error<>0    
       begin    
        rollback tran    
        select 'F','保存医嘱单据分类出错信息时出错！'    
        return    
       end    
      end    
                     if exists(select  1 from BQ_CQYZK a (nolock) where syxh = @syxh and yzzt = 0 and idm > 0 and not exists(select  1 from BQ_YZDJFLK b(nolock)where b.jlzt = 0 and a.djfl = b.id))      
                     begin      
                      insert into  YY_ERROR      
                            select  getdate(), '医嘱单据分类' + convert(varchar(12), a.xh) + '1 ' + a.djfl      
                            from BQ_CQYZK a where syxh = @syxh and yzzt = 0 and not exists(select  1 from BQ_YZDJFLK b(nolock)where a.djfl = b.id)      
                            if @@error <> 0      
                      begin      
                       rollback tran      
                                select  'F', '保存医嘱单据分类出错信息时出错！'      
                                return      
                      end      
                     end      
                    --申请单自定义收费处理    
     declare @result3 varchar(8),@msg3 ut_mc256    
     exec usp_his5_zyys_saveordercharge @wkdz=@wkdz,@jszt=3,@result=@result3 output,@msg=@msg3 output    
     if @result3='F'    
     begin    
     rollback tran     
     select @result3,@msg3    
     return    
     end    
                    commit tran     
                     --医嘱闭合操作    
                    if exists(select 1 from CISSVR.CISDB.dbo.SYS_CONFIG where ID = 'HP457' and CONFIG = '是')    
                     Begin    
                     declare @hp361 ut_mc16    
                     select @hp361=CONFIG from CISSVR.CISDB.dbo.SYS_CONFIG where ID = 'HP361'    
                     declare @CurSor_Yzbh Cursor      
                     declare @nv5xh ut_xh12    
                     declare @nyzbz int--医嘱标志，1长期0临时    
                     declare @nypdm ut_xmdm  --药品代码              
                     declare @ntzxh ut_xh12 --停止医嘱序号    
                     declare @nyzlb int --医嘱类别    
                     set @CurSor_Yzbh = Cursor for select v5xh,yzbz,tzxh,ypdm,yzlb from #yzk    
                     Open @CurSor_Yzbh    
                     Fetch Next From @CurSor_Yzbh into @nv5xh,@nyzbz,@ntzxh,@nypdm,@nyzlb    
                     While @@FETCH_STATUS = 0    
                     Begin    
                           if @nyzlb!=9--非停止医嘱下达    
                           begin    
                            if @nyzbz=1--长期医嘱    
                              exec usp_his5_zyys_yzbhcz @syxh,@czyh,@nv5xh,@nyzbz,@ksdm,@bqdm,@ntzxh,@nypdm,0,@ksrq,1    
                            else --临时医嘱    
                              exec usp_his5_zyys_yzbhcz @syxh,@czyh,@nv5xh,@nyzbz,@ksdm,@bqdm,@ntzxh,@nypdm,0,@ksrq,1    
                           end    
                          if @nyzlb=9 and @hp361='否'--停止医嘱取长期医嘱信息,而不是取生成临时表中的临时医嘱    
                              exec usp_his5_zyys_yzbhcz @syxh,@czyh,@nv5xh,@nyzbz,@ksdm,@bqdm,@ntzxh,@nypdm,0,@ksrq,4    
                        Fetch Next From @CurSor_Yzbh into @nv5xh,@nyzbz,@ntzxh,@nypdm,@nyzlb    
          End    
                     CLose @CurSor_Yzbh    
                     Deallocate @CurSor_Yzbh    
                    End    
                --这个医院可以根据需要调整, 
                    --这里放开是发送消息给当前病区,护士站如果启用了消息就收就可以查看到,否则不行    
                    --发送消息给当前病区    
                    declare @ksdm_curr ut_ksdm ,@bqdm_curr ut_ksdm,@hsdm ut_czyh,@ysmc ut_mc64,@send_msg varchar(100),@cwdm_cur ut_cwdm    
                    select top 1 @bqdm_curr = bq_id,@ysmc = name from YY_ZGBMK(nolock) where id = @ysdm    
                    select @bqdm_curr=bqdm from ZY_BRSYK (nolock) where syxh=@syxh    
                 select @cwdm_cur=CWDM from CISSVR.CISDB.dbo.CPOE_BRSYK where SYXH =@syxh and YEXH=@yexh    
                    select @send_msg = '【'+@cwdm_cur+'床】医生【' + @ysmc + '】已发送医嘱!'    
                    exec usp_yy_autosendmsg 2,@ysdm,'',@bqdm_curr,@send_msg    

                    declare @hp38 varchar(4)    
                    declare @hp347 varchar(4)    
                    declare @hp489 varchar(50)    
                    select @hp38= CONFIG from CISSVR.CISDB.dbo.SYS_CONFIG WHERE ID='HP38'    
                    select @hp347= CONFIG from CISSVR.CISDB.dbo.SYS_CONFIG WHERE ID='HP347'    
                    select @hp489= CONFIG from CISSVR.CISDB.dbo.SYS_CONFIG WHERE ID='HP489'    
                    ---处方权    
                    declare @cfq varchar(4)                        
                    select @cfq= CONFIG from CISSVR.CISDB.dbo.SYS_USER_ATTRIB WHERE ZGDM=@czyh and (ROLE_CODE='0000' or ROLE_CODE='0001') and ID='0008'    
                     if((@hp347='是' and @cfq='是' and exists(select 1 from #yzk where yzbz = 0 and szyzbz = 1))    
                     or (@hp489<>'' and @cfq='是' and exists(select 1 from #yzk where yzbz=0 and szyzbz = 1 and yzlb in(select col from dbo.fun_Split(@hp489,',')) )))    
                    begin    
                          update a set a.shczyh = @czyh,a.shrq =@now     
                          from BQ_LSYZK a ,BQ_LSYZK_FZ b(nolock),SS_SSDJK c(nolock) ,#yzk d    
                          where a.syxh = @syxh and a.yexh=@yexh and a.syxh =b.syxh and a.yzzt=-2 and a.yzlb in (0,1,2,3,4,5,6,7,8) and a.zbybz in (0,1)     
                                and a.yzlb2=1 and a.xh=b.yzxh and b.ssxh=c.xh and a.v5xh=d.v5xh and d.szyzbz=1 and d.yzbz=0    
                          if @@error <> 0        
        begin        
        rollback tran        
        select  'F', '术中医嘱自动审核时出错！'        
        return        
        end                
                    end    
                    if(@hp38='是' and @cfq='是')    
                         exec usp_bq_yzsh @syxh,@czyh,0,-1,0,@yexh,0,0    
                    --术中医嘱执行    
                    if(@hp489<>'' and @cfq='是' and exists(select 1 from #yzk where yzbz=0 and szyzbz = 1 and yzlb in(select col from dbo.fun_Split(@hp489,','))))    
       begin    
       declare @ssksdm ut_ksdm,@ssxh ut_xh12,@dyzfzxh ut_xh12    
       select distinct b.sssksdm,a.fzxh,b.ssxh into #TempSzyz from BQ_LSYZK a left join BQ_LSYZK_FZ b on a.xh=b.yzxh and a.syxh=b.syxh     
        where exists(select 1 from SS_SSDJK s where s.xh=b.ssxh) and a.syxh=@syxh and a.yexh=@yexh and a.yzlb in(select col from dbo.fun_Split(@hp489,',')) and a.yzzt=-2    
        declare CurSzyz cursor for select sssksdm,ssxh,fzxh from #TempSzyz    
        open CurSzyz    
        fetch CurSzyz into @ssksdm,@ssxh,@dyzfzxh    
        while @@FETCH_STATUS=0    
           begin    
             exec usp_bq_szyzzx @syxh,@czyh,@wkdz,@ssksdm,@dyzfzxh,@ssxh,@yexh     
             if @@ERROR<>0    
               begin    
                 rollback tran        
              select  'F', '术中医嘱自动执行出错！'        
              return        
               end    
              fetch CurSzyz into @ssksdm,@ssxh,@dyzfzxh    
           end    
          close CurSzyz      
                      deallocate CurSzyz     
      end      
--begin出院带药问题处理，add by winning-DSONG-chongqing on 20190705  
declare @cydy_bqdm varchar(16),@cydy_ksdm varchar(16)  
select @cydy_bqdm = bqdm, @cydy_ksdm = ksdm from ZY_BRSYK(nolock)where syxh = @syxh    
if EXISTS(SELECT  1 FROM BQ_LSYZK where syxh = @syxh and yexh=@yexh and yzlb=12 and yzzt=-2 and zbybz=0)  
BEGIN  
exec usp_his5_zyys_savecydy @syxh,@yexh,@czyh,@ysdm,@cydy_bqdm,@cydy_ksdm  
END    
--end出院带药问题处理，add by winning-DSONG-chongqing on 20190705  
                    select  'T3'      
                    end 






