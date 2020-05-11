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
                        , @zxksdm ut_ksdm = '' --���뵥ִ�п���      
                        , @sqdbbid ut_dm4 = '' --���뵥ҽ����Ŀ�걾����      
                        , @sqdbbzl ut_mc64 = '' --���뵥ҽ����Ŀ�걾����      
                        , @yyts ut_bz = 0  --��Ժ��ҩ����ҩ����     
                        , @ypsl ut_sl10 = 0  --��Ժ��ҩר�õ�����     
                        , @zfybz ut_bz = 0      --�Է�ҩ��� 0 �����Է�ҩ 1 �Է�ҩ������ �� �� ��ҩ ҽ��ѡ�� Ϊ�ԷѴ���ʱ��aorigele 2013/7/4    
                        , @kzzd varchar(1000)='' --��չ�ֶΣ��Ժ������������ֶΣ������ֶ�ƴ����@kzzd �д��� �ָ��� | aorigele 2013/7/18    
                        as      
                        /*****************      
                        [�汾��]5.0.0.0.0      
                        [����ʱ��]2012.09.01      
                        [����]����         
                        [��Ȩ]Copyright ? 2004 - 2012 �Ϻ����˴� - ��������ɷ����޹�˾      
                        [����]ҽ��¼��      
                        [����˵��]      
                        ҽ��¼��      
         [����˵��]      
                        @wkdz varchar(32), ������ַ      
                        @jszt smallint, ����״̬1 = ������2 = ���룬3 = �ݽ�      
   @v5xh ut_xh12, 5.0 ҽ�����      
                        @syxh ut_syxh, ��ҳ���      
                        @czyh ut_czyh, ����Ա��      
                        @fzbz int, �����־ ÿ��ҽ����־��ͬ      
                        @ysdm ut_czyh, ҽ������      
                        @yzlb smallint, ҽ����� 0: ��ʱҽ����1������ҽ����2����ʱҽ���÷����ϣ�3������ҽ���÷�����      
                        @ksrq ut_rq16, ҽ���Ŀ�ʼʱ��      
                        @xmlb smallint, ��Ŀ��� 0: ҩƷҽ����1����ҩƷҽ����2: ����ҽ����8: ��Һҽ����9: ֹͣҽ��      
                        @idm ut_xh9, ����idm����ҩƷΪ0      
                        @ypdm ut_xmdm, ҩƷ�����������Ŀ����      
                        @yfdm ut_ksdm, ҩ������      
                        @ypjl ut_sl14_3, ҩƷ������������Ŀ������      
                        @jldw ut_unit, ������λ      
                        @dwlb smallint, ��λ���0������λ��3סԺ��λ      
                        @ypyf ut_dm2, �÷�����      
                        @yznr ut_mc256, ҽ������      
                        @ztnr ut_mc64, ҽ������      
                        @pcdm ut_dm2, ҽ��ִ��Ƶ�δ���      
                        @zdm char(7), �ܱ�־����һ��������1234567��ʾ��      
                        @zxsj ut_mc256, ҽ��ִ��ʱ��      
                        @zbybz smallint = 0, 0: ��ͨ��1: �Ա�ҩƷ��2: PRN      
                        @dybz smallint = 0, 0: ��ӡ��1: ����ӡ      
                        @xmdj numeric(12, 2) = null, �㵥����Ŀ�ĵ���      
                        @tzxh ut_xh12 = null, ֹͣҽ�����      
                        @jsrq ut_rq16 = null, ����ҽ��ֹͣʱ��      
                        @mzdm ut_xmdm = null, �������      
                        @yjqrbz smallint = 0 ҽ��ȷ�ϱ�־      
                        @zdys ut_czyh = null ����ҽ��      
                        @yyzxh ut_xh12 = -1,      
                        @yfzxh ut_xh12 = -1, --������ԭҽ������źͷ������      
                        @hzxm ut_mc64 = '', --��������,      
                        @yexh ut_syxh = 0 --Ӥ�����      
                        @mzxdfh ut_xh12 = 0 --����Э�������      
                        @njjbz ut_bz = -1 --������ɱ�־      
                        , @ybshbz ut_bz = 0 --ҽ�����־0�������1���ͨ��2��˲�ͨ��      
                        , @ybspbh ut_mc32 = null --ҽ���������      
                        , @sqzd ut_zddm = '' --��ǰ���      
                        , @sstyz ut_bz = 0 --����ͣҽ��      
                        , @lzbz ut_bz = 0 --������־      
                        , @sxysbz ut_bz = 0 --ʵϰҽ����־0: ��ͨ1: ��ʾ��ʵϰҽ��������ҽ����Ҫ���2: ���ʵϰҽ������ҽ��      
                        , @lcxmdm ut_xmdm = '0' --�ٴ���Ŀ����      
                        , @ssmc ut_mc256 = '' --��������      
                        , @systype ut_bz = 0 --ϵͳ��־ 0 סԺҽ�� 1 ��ʿվ�������ֵ�ǰ��ҽ�����û��ǻ�ʿ����      
                        , @ldpcbz --����Ƶ�α�־ 0 ��ҽ���� 1 ��Ŀ�����Դ�Ƶ��      
                        , @yzlbdy --ҽ������Ӧ      
                        , @blzbz ut_bz = 0 ��������־�����Ϊ1������ǰ̨ѡ����������ʱҽ��      
                        , @sqddm int ���뵥������      
                        , @kjslx ut_bz = 0 --���������ͣ�0��ͨ1Ԥ����2�����ԣ�      
                        , @kjsbz ut_bz = 0 --��������ϸ��־��0�ǿ�����1������2Ĭ����ý3��ѡ��ý��      
                        , @kjsssyz ut_xh12 = 0 --�����ض�Ӧ����ҽ�����      
                        @zddm ut_zddm = '', ��ϴ���      
                        @zjlx ut_bz = 0, ֤������      
                        @zjhm varchar(20) = '' ֤������      
                        @Jsdmbz --�������־      
                        , @yyts ut_bz = 0 --��Ժ��ҩ����ҩ����     
                         , @ypsl ut_sl10 = 0  --��Ժ��ҩר�õ�����      
                        [����ֵ]      
                        [�����������]      
                        [���õ�sp]      
                        [����ʵ��]    
                        [�޸ļ�¼]    
                        bug9512--ͣ����ҽ�����ɶ���ͣ����ʱҽ��      
                        bug10597---HP44Ϊ��ʱ����Ժ��ҩ��������    
                        ����10322--CIS����ҽ��������ҽ�����̶���(���η�崦��)    
                        bug10726--��Ժ��ҩ����ҩƷ    
                        ����899--����ҽ������    
                        bug17535--ҩƷ��������+��λ��ͬʱ,����his��ҽ�����ݹ��ͼ�����λȫ����������    
  ���� 22068:���������뵥�����������Ⱦ˵��    
                 ���� 25480:��������ҽԺ--�������뵥����    
                        Bug 25934:25480-¼��������������ҽ���˷��͹�ȥyzlb����ȥ1 ��ypmcҲ����    
                         Bug 26872:����26061�ϲ��ֳ��洢����    
                         Bug 30290:����29274-HP295 �򿪺����� BQ_LSYZK_FZû��ssksdm ssxh��    
                         ����:15881-����ҽ��ָ��ִ��ʱ��    
                         ����48009  �ɾ�������ҽԺ---��������    
                         Bug 68399 1601-HP176���õĺ�ʵ��Ч���෴    
                         ���� 57377 ��Ǩ�е�һ����ҽԺ������չ��λͬ��    
                    **********************/      
                    --set  nocount on      
                    --set ansi_defaults off    
                    --���ɵݽ�����ʱ��      
                        declare  @tablename varchar(32)      
                        declare @xcfhssh  varchar(32)     
                        select  @tablename = '##ysgzzyzlr' + @wkdz --+ @czyh ����ǰ̨�����ػ����Żᵼ�±���   
						                     

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
                                select  'F', '������ʱ��ʱ����'      
                                    return      
                            end      
                            --���뵥�Զ����շѴ���    
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
                    --����ݽ��ļ�¼      
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
, @cldpcbz varchar(2) --����Ƶ�α�־      
                            , @cyzlbdy varchar(9)      
                            , @cjzbz varchar(2)      
                            , @cblzbz varchar(2) --��������־      
                            , @config6139 varchar(8) --6139 ����      
                            , @configwzyz varchar(12) --G030����      
                            , @ckjslx varchar(20)      
                            , @ckjsbz varchar(20)      
                            , @ckjsssyz varchar(20)      
      , @cjajbz varchar(20)      
                            , @czddm ut_zddm --��ϴ���      
                            , @czjlx varchar(255) --֤������      
                            , @czjhm varchar(20) --֤������      
                            , @cJsdmbz varchar(255) --�������־      
                            , @cfjdwxs varchar(16) --�ּ���λϵ��      
                            , @czxksdm ut_ksdm --ִ�п��Ҵ���      
                            , @csqdbbid ut_dm4 --���뵥ҽ����Ŀ�걾����      
                            , @csqdbbzl ut_mc64 --���뵥ҽ����Ŀ�걾����      
     , @cyyts varchar(4) --��ҩ����     
                            , @cypsl varchar(12) --ҩƷ����     
                            , @czfybz varchar(2) --�Է�ҩ���    
                            , @cszyzbz varchar(2)       
                            , @cssxh varchar(12)     
                            , @sqbz varchar(1)    
                            , @szyzzxrq varchar(16)  --����ҽ��ִ��ʱ��      
                          -- , @zpdf utInt  --��ƿ����    
                            , @tcwbz ut_bz  --�ײ����ʾ    
                            , @kzdw ut_bz--�Ƿ�����չ��λ 1���ǡ�0����    
                            ,@drsssbz ut_bz --���������ұ�־    
                            ,@sssksdm ut_ksdm --�����ҿ��Ҵ���    
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
                            , @czddm = @zddm --��ϴ���      
                            , @czjlx = convert(varchar(255), @zjlx) --֤������      
                            , @czjhm = @zjhm --֤������      
                            , @cJsdmbz = convert(varchar(255), @Jsdmbz)      
                            , @czxksdm = @zxksdm      
                            , @csqdbbid = @sqdbbid --���뵥ҽ����Ŀ�걾����      
                            , @csqdbbzl = @sqdbbzl --���뵥ҽ����Ŀ�걾����      
                            , @cyyts = CONVERT(varchar(4), @yyts) --��Ժ��ҩר�õ���ҩ����     
                            , @cypsl = CONVERT(varchar(12),@ypsl) --��Ժ��ҩר�õ�ҩƷ����    
                            , @czfybz = convert(varchar(2), isnull(@zfybz, 0))    
                            if @lcxmdm = ''      
                            select @lcxmdm = '0'      
                            declare @ssyysj varchar(10) --������ҩʱ�����    
                            set @ssyysj='0'    
                            select @cszyzbz='-1'      
                            set @cssxh = '0'    
                            select @sssksdm =''    
                            if LEN(ltrim(rtrim(@kzzd)))>2      
                            select @ssyysj=[dbo].[fun_SplitString](@kzzd,'|',2)     
                            if LEN(ltrim(rtrim(@kzzd)))>=3       
                            select @cszyzbz=[dbo].[fun_SplitString](@kzzd,'|',3) --��ȡ����ҽ����־                              
                            if LEN(ltrim(rtrim(@kzzd)))>=4       
                            select @cssxh=[dbo].[fun_SplitString](@kzzd,'|',4)  --�������      
                            select @sqbz=[dbo].[fun_SplitString](@kzzd,'|',6)  --��ǰ��־    
                            select @szyzzxrq=''
							--[dbo].[fun_SplitString](@kzzd,'|',7)    lj20191127�������ڼ�����Ŀ��ע��������ַ�|����ǰ̨������ת�������Ƿ�����

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
                            if exists(select 1 from CISSVR.CISDB.dbo.CPOE_XCF_SZ where ID= '0013' AND VALUE='��')     
                            select @xcfhssh = '��'    
                      --ʹ�õڶ���ȫ��ģʽ(��ʼ)      
                            select @config6139 = ''      
                            select @config6139 = config + ':00' from YY_CONFIG where id = '6319'      
                            if (exists(select  1 from YY_CONFIG where id = '6068' and config = '��') --�Ƿ���ȫ��ģʽ      
                            and exists(select  1 from YY_CONFIG where id = '6318' and config = '��') --�Ƿ����õڶ���ȫ��ģʽ      
                            and exists(select  1 from YY_CONFIG where id = '6319' and config <> '00:00') --�ϵ�ʱ����Ϊ00��00��Ч      
                            and right(@ksrq, 8) > @config6139 --��ʼʱ�������ڶϵ�ʱ��      
                            and @yzlb = 1 --ֻ�ڳ���ҽ��ʱʹ��      
                            and convert(varchar(100), getdate(), 112) = left(@ksrq, 8) --��ʼ���ڱ���Ϊ����      
                            )      
                            select @ksrq = convert(varchar(100), dateadd(dd, 1, convert(datetime, left(@ksrq, 8))), 112) + '00:01:00' --����������������ʱ��ʼʱ��ʹ�õڶ���ȫ��ģʽ�����ڼ�1, ʱ��Ϊ��1�֣�      
                            --ʹ�õڶ���ȫ��ģʽ(����)      
                            select @cfjdwxs = ''      
                            if (@dwlb = 5) and (@idm <> 0)      
                      begin      
                       select distinct @cfjdwxs = convert(varchar(16), fjxs)from YF_YPFJBZDMK where cd_idm = @idm      
                        and sybz = 1 and bqyz = 1 and yfdm = @yfdm and fjdw = @jldw      
                        if @cfjdwxs = ''      
                       begin      
                        select  'F', '������ϸ�ּ���λ����'      
                         return      
                       end      
                      end      
                            --�������ݸ��ݲ��Բ�4.0��׼ varchar(100) aorigele bug 4189 2013/9/5    
                      declare @sztnr varchar(100)    
                      select @sztnr =CONVERT(varchar(100),@ztnr)    
                                
                            --����6287   �����Ƿ���ʾִ�п��� ����6202    
                            declare @showzxks varchar(1)    
                            select @showzxks=substring(config,3,1) from YY_CONFIG where id='6202'    
                            if @showzxks =1    
                                select  @yznr=@yznr+'['+name+']' from YY_KSBMK WHERE id=@yfdm    

                            declare @sqdxmbz varchar(128) --���뵥��Ŀ��ע    
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
                       select  'F', '������ʱ��ʱ����'      
                       return      
                      end      
                      select  'T2'      
                            return      
                    end      
      
                    if @jszt = 3      
                    begin      
                        --��ʼ����ҽ��      
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
, sqdbbid ut_dm4 null --���뵥ҽ����Ŀ�걾����      
                            , sqdbbzl ut_mc64 null --���뵥ҽ����Ŀ�걾����      
                            , yyts ut_bz null     --��Ժ��ҩר�õ���ҩ����    
                            , ypsl ut_sl10 null    --��Ժ��ҩר�õ�ҩƷ����    
                            , zfybz ut_bz null --�Է�ҩ��� 0 �����Է� 1�Է�ҩ    
                            , sqgyfl ut_bz null --������ҩ����    
                            , szyzbz ut_bz null       
                            , ssxh  ut_xh12 null    
                            ,sqdxmbz ut_mc64 null --���뵥��Ŀ��ע       
                            ,sqbz ut_bz null        --��ǰ��־     
                            ,szyzzxrq ut_rq16 --����ҽ��ִ������    
                           -- ,zpdf utInt --��ƿ����    
                            ,tcwbz ut_bz null--�ײ����ʾ    
                            ,kzdw ut_bz NULL    
                            ,drsssbz ut_bz null    
                            ,sssksdm ut_ksdm NULL    
                            )     
      
                        if exists(select  1 from YY_CONFIG where id = 'G112' and config = '��')      
                        begin      
                            exec('insert into  #yzlrtmp select  * from ' + @tablename + ' order by ksrq')      
                                if @@error <> 0      
                            begin      
                                select  'F', '������ʱ��ʱ����'      
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
                     select  'F', '������ʱ��ʱ����'      
                      return      
                            end      
                        end      


                        exec(' delete #yzlrtmp '      
                            + ' from #yzlrtmp , BQ_CQYZK (nolock)'      
                            + ' where #yzlrtmp.yyzxh=BQ_CQYZK.v5xh '      
                            + ' and BQ_CQYZK.yzzt not in (-1,0) and #yzlrtmp.yzlb=1 ')      
                            if @@error <> 0      
                        begin      
                            select  'F', 'ȥ����ʱ���е��Ѿ�����˵ĳ���ҽ��ʱ����'      
                                return      
                        end      
                        declare @HP405 varchar(2)    
       select @HP405= CONFIG from  CISSVR.CISDB.dbo.SYS_CONFIG with (nolock) where ID='HP405'     
                       select * into #yzlrtmp_ss from #yzlrtmp where 1=2    
                    if(@HP405='��' )    
                    begin    
                insert into  #yzlrtmp_ss     select * from #yzlrtmp where xmlb=2  --����ҽ���ȱ���,��Ϊ����ᱻɾ��(HISҽ�������Ѵ�����˹��ļ�¼)       
                    end    
                         
            exec(' delete #yzlrtmp '      
                            + ' from #yzlrtmp a, BQ_LSYZK b'      
                            + ' where a.yyzxh=b.v5xh '      
                            + ' and ((b.yzzt not in (-1,0) and b.yzlb<>12)or (b.yzzt>0 and b.yzlb=12)) and a.yzlb=0 and isnull(b.yzlb2,0)<>1 ')      
                            if @@error <> 0      
                        begin      
                            select  'F', 'ȥ����ʱ���е��Ѿ�����˵���ʱҽ��ʱ����'      
                                return      
                        end      

                        exec('drop table ' + @tablename)      
                            if exists(select  1 from YY_CONFIG where id = '6191' and config = '��')      
                        begin      
                            delete from #yzlrtmp where fzbz in (select  distinct fzbz from #yzlrtmp where jjbz = 3) --�ڵ�      
                                if @@error <> 0      
                            begin      
                                select  'F', 'ȥ����ʱ���е�������ɣ��ڵƣ���ҽ��ʱ����'      
                                    return      
                            end      
                        end      
                        declare @now ut_rq16,      
                            @ypbz smallint,      
                            @bqdm ut_ksdm, --��������      
                            @ksdm ut_ksdm --���Ҵ���      
      
                        declare @configg007 varchar(4),      
                            @configg075 varchar(2),     
                            @configg030 varchar(18),  --Ĭ������ҽ������    
  @btbz char(2),      
      
                  @configG107 ut_xmdm, 
                            @configG108 ut_xmdm,      
                            @config6432 varchar(2),    
                            @config7002 varchar(2)    
                            select @config7002 = config from YY_CONFIG where id = '7002'      
                            select @configg030 = config from YY_CONFIG where id = 'G030'  --ȡ��HIS��ߵ�Ĭ������ҽ������    
                            if ltrim(rtrim(@configg030))=''    
                            begin    
                       select  'F', 'HISû��ָ��Ĭ�ϵ�����ҽ�����룡'      
                       return      
                            end    
                            select @configg007 = config from YY_CONFIG where id = 'G007'      
                            select @configg075 = config from YY_CONFIG where id = 'G075' --�Ƿ���ҽ������֮��ʹ���ύ��ʽ�ύҽ��      
                            select @btbz = config from YY_CONFIG where id = '6122'      
                            select @configg007 = isnull(@configg007, '��')      
                            select @configg075 = isnull(@configg075, '��')      
                            select @configG107 = isnull(config, '')from YY_CONFIG where id = 'G107' --Σ������ҽ������      
                            select @configG108 = isnull(config, '')from YY_CONFIG where id = 'G108' --Σ������ҽ������      
                            select @config6432 = config from YY_CONFIG where id = '6432'      
                            select @config6432 = isnull(@config6432, '��')      
                            select @now = convert(char(8), getdate(), 112) + convert(char(8), getdate(), 8),  @ypbz = 0      
                            select @bqdm = bqdm, @ksdm = ksdm from ZY_BRSYK(nolock)where syxh = @syxh      
                            if @@rowcount = 0      
                      begin      
                       select  'F', '������ҳ��Ϣ�����ڣ�'      
                        return      
                      end     

                  --����10322:ҽ�������ģʽ��Ĭ��Ϊ0��������ģʽ���ͣ�����Ϊ1����yzlb���ͣ�����Ϊ0��ʱ��ҽ�����ʹ洢usp_his5_zyys_saveorder�޸����з��͹���������ҽ�������Ϊ1,��    
                  --����Ϊ1��ʱ�򣬰�yzlb���ͣ�ҽ�����ʹ洢usp_his5_zyys_saveorder������yzlb    

                   declare @hp44 varchar(4)--��Ժ��ҩ�Ƿ����ﵥλ����    
                         select @hp44= CONFIG from CISSVR.CISDB.dbo.SYS_CONFIG WHERE ID='HP44'    

                  declare @hp236 varchar(2)    
                        select  @hp236= isnull(CONFIG, '0') from CISSVR.CISDB.dbo.SYS_CONFIG WHERE ID='HP236'     
      
                        --�����ظ����͵�δִ�����뵥����      
                        if exists(select  1 from ZY_BRSQD(nolock)where syxh = @syxh and blsqdxh = @sqddm and jlzt = 0)      
                     begin      
      
                      delete from ZY_BRSQDMXK      
                       where sqdxh in (select  xh from ZY_BRSQD where syxh = @syxh and blsqdxh = @sqddm and jlzt = 0)      
                       delete from BQ_LSYZK where syxh = @syxh and sqdxh in (select  xh from ZY_BRSQD where syxh = @syxh and blsqdxh = @sqddm and jlzt = 0)      
                       delete from ZY_BRSQD where syxh = @syxh and blsqdxh = @sqddm      
                     end      
      
                        if exists(select  1 from ZY_BRSQD(nolock)where syxh = @syxh and blsqdxh = @sqddm and jlzt = 1)      
                        begin      
                            select  'F', '�Ѿ������˴����뵥�����Ѿ������ˣ�'      
                                return      
                        end      

                        create table #yzk      
                            (      
                            lrxh int not NULL, --¼��˳�� add by gzy at 20050904      
                            v5xh ut_xh12 not null, --5.0 ҽ�����      
                            fzxh ut_xh12 not null, --�����־      
                            ysdm ut_czyh not null, --ҽ������      
                            ksrq ut_rq16 null, --��ʼ����      
    pcdm ut_dm2 not null, --Ƶ��      
                            zxcs int not null default 1, --ִ�д���      
                            zxzq int not null default 1, --ִ������      
                            zxzqdw ut_bz not null, --ִ������ʱ�䵥λ(-1: ���������ڣ�0����, 1 ��Сʱ, 2 ������)      
                            zdm char(7)null, --�ܴ���      
                            zxsj ut_mc256 null, --ִ��ʱ��      
                            idm ut_xh9 not null, --ҩƷidm      
                            gg_idm ut_xh9 not null, --���idm      
                            lc_idm ut_xh9 not null, --�ٴ�idm      
                            ypdm ut_xmdm not null, --ҩƷ����Ŀ������      
                            ypmc ut_mc256 null, --ҩƷ����Ŀ������      
                            ypjl ut_sl14_3 null, --����      
                            jldw ut_unit null, --������λ      
                            dwlb smallint not null, --��λ���0������λ��2���ﵥλ 3 סԺ��λ      
                            ypsl ut_sl10 not null, --ҩƷ����      
                            ypgg ut_mc32 null, --ҩƷ���      
                            zxdw ut_unit null, --��С��λ      
                            ztnr ut_mc64 null, --����      
                            yznr ut_mc256 null, --ҽ������      
                            ypyf ut_dm2 null, --ҩƷ�÷�      
                            zxksdm ut_ksdm null, --ִ�п���      
                            yzlb ut_bz not null, --ҽ�����0: ҩƷ��1���ƣ�2������3��ʳ��4��Ѫ��5����6��飬      
                            --7 ���飬8��Һ��9ֹͣҽ����10ת�ƣ�11��Ժ��12��Ժ��ҩ��      
                            tzxh ut_xh12 null, --ֹͣ���      
                            tzrq ut_rq16 null, --ֹͣ����      
                            zbybz ut_bz not null, --�Ա�ҩ��־��0��ͨ��1�Ա���2PRN��      
                            zdydj ut_money not null, --�Զ��嵥��      
                            dybz ut_bz not null, --��ӡ��־��0δ��ӡ��1�Ѵ�ӡ��2����ӡ��      
                            djfl ut_dm4 not null, --BQ_YZDJFLK.idҽ�����ݷ������      
                            yzdjfl ut_dm4 null, --BQ_YZZXDJFLK.idҽ��ִ�е��ݷ���      
                            mzdm ut_xmdm null, --�������(����ҽ��ʱ)      
                            yzbz smallint not null, --0 ��ʱ��1����      
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
                            , ybshbz ut_bz null --ҽ����˱�־      
                            , ybspbh ut_mc32 null --ҽ���������      
                            , sstyz ut_bz null      
                            , sqzd ut_zddm null      
                            , lzbz ut_bz null      
                            , lcxmdm ut_xmdm null      
                            , sxysbz ut_bz null --0 ʵϰҽ�� 1 ����ҽ��      
                            , sybpno ut_xh12 null --��Һ������      
                            , systype ut_bz null      
                            , sqdxh ut_xh12 null --���뵥���      
                            , sqdxmbz ut_mc64 null --���뵥��Ŀ��ע      
                            , sqdsjxm ut_xmdm null --���뵥�ϼ���Ŀ      
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
                            , sqdbbid ut_dm4 null --���뵥ҽ����Ŀ�걾����      
                            , sqdbbzl ut_mc64 null --���뵥ҽ����Ŀ�걾����      
                            , yyts ut_bz null      --��Ժ��ҩר�õ���ҩ����    
                            , cydyypsl ut_sl10 null  --��Ժ��ҩר�õ�ҩƷ����    
                            , zfybz ut_bz null    
                            , sqgyfl ut_bz null --��ǰ��ҩ����    
                            , szyzbz ut_bz null       
                            , ssxh  ut_xh12 null     
                            , sqbz ut_bz null   --��ǰ��־      
                            ,szyzzxrq  ut_rq16 --����ҽ��ִ������    
                            --,zpdf utInt --��ƿ����    
                            , tcwbz ut_bz --�ײ����ʾ    
                            ,drsssbz ut_bz--���������ұ�־    
                            ,sssksdm ut_ksdm NULL    
                            )      
                            --����ҽ������Ĵ���,��Ҫ����Ϊ��������XXXXX��������,�޸����з��͹���������ҽ�������Ϊ1    
                            --ҽ�����(0ҩƷ��1���ƣ�2������3��ʳ��4��Ѫ��5����6������뵥��7�������뵥��8��Һ��9ֹͣҽ����10ת�ƣ�    
                            --11��Ժ��12��Ժ��ҩ��13ת��,14����ҽ����15����ҽ�� ��16�没�أ�17�没Σ��18ת����19��������,20����ٴ���Ŀ21�����ٴ���Ŀ23����ҽ��,24��ǰҽ��)    
                            update #yzlrtmp set ypdm=@configg030,yypdm=@configg030,lcxmdm='0' where ypdm='XXXXX' and (xmlb in (1,10,11,13,14,15,16,17,18,23,24,98,99) or xmlb>=100)    
                           declare @HP412 varchar(2)    
            declare @HP188 varchar(2)    
            select @HP412= CONFIG from  CISSVR.CISDB.dbo.SYS_CONFIG with (nolock) where ID='HP412'     
            select @HP188= CONFIG from  CISSVR.CISDB.dbo.SYS_CONFIG with (nolock) where ID='HP188'    
                      --ҩƷҽ���Ĵ���,����Ժ��ҩҽ��    

                      insert into  #yzk      
                            select  a.lrxh, a.v5xh, a.fzbz, a.ysdm, a.ksrq, a.pcdm, 1, 1, 0, a.zdm, a.zxsj, a.idm, c.gg_idm, c.lc_idm,      
                            c.ypdm, c.ypmc, a.ypjl, a.jldw, a.dwlb, CASE WHEN (a.kzdw=1 or (a.xmlb=97 and a.idm>0)) then a.ypsl else (case a.dwlb when 0 then a.ypjl / c.ggxs when 2 then a.ypjl * c.mzxs when 3 then a.ypjl * c.zyxs     
                            when 5 then a.ypjl * a.fjdwxs      
                      end) END,case when ltrim(rtrim(isnull(a.ypgg, ''))) = '' then c.ypgg else a.ypgg end, case a.xmlb when 97 then c.zydw else c.zxdw end, a.ztnr,    
                            --ҽ��������ҽ����ӡ���ÿ��ƣ����ɲ�������(�����2019-03-22)    
                            --aorigele 20130626    
--                           case when (@configg007 ='��' and ((@HP188='��' and @HP412 IN (0,1)) or (@HP188='��' and exists(SELECT 1 FROM CISSVR.CISDB.dbo.CPOE_YZNRSZ_DYK WHERE YZID=0 AND YSID='0002') )))     
--              then SUBSTRING(a.yznr,0,CHARINDEX(a.ypgg,a.yznr)) +RIGHT(a.yznr,LEN(a.yznr)-CHARINDEX(a.ypgg,a.yznr)-LEN(a.ypgg))     
--        when (@configg007 ='��' and ((@HP188='��' and @HP412 IN (2,3)) or (@HP188='��' and not exists(SELECT 1 FROM CISSVR.CISDB.dbo.CPOE_YZNRSZ_DYK WHERE YZID=0 AND YSID='0002') )))     
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
                            when 97 then 14 --С����ҽ�����̶�14 ��ʱҽ��4.0�У���ʷԭ��for  8974    
                      else 0 end,a.tzxh, isnull(a.jsrq, ''), a.zbybz, a.xmdj, (case a.dybz when 1 then 2 else 0 end), '', '', a.mzdm, case a.lzbz when 1 then 0      
                      else a.yzlb end, c.yplh, c.jxdm, convert(varchar(2), b.tsbz),c.ljlybz,     
                            case @hp44 when '��' then c.mzxs else c.zyxs end,                                 
                            --c.zyxs,    
                            0, 0, a.hzxm, a.yexh, '', a.mzxdfh, a.jjbz, a.ybshbz, a.ybspbh, a.sstyz, a.sqzd, a.lzbz, '0', 0, a.sybpno, a.systype, 0, '', '0', --agg 2004.09.10 ��lcxmdm      
                            a.yzlbdy, a.jzbz, a.blzbz, a.sqddm, a.yypdm, a.kjslx, a.kjsbz, a.kjsssyz, a.yyzxh, a.yfzxh, a.jajbz, '', a.zddm, a.zjlx,     
                            a.zjhm, a.Jsdmbz, a.sqdbbid, a.sqdbbzl, a.yyts,a.ypsl,a.zfybz,a.sqgyfl ,a.szyzbz,a.ssxh  ,a.sqbz,a.szyzzxrq --,a.zpdf      
                            ,a.tcwbz,a.drsssbz,a.sssksdm    
                      from #yzlrtmp a, YF_YFZKC b(nolock), YK_YPCDMLK c(nolock)      
                      where a.yzlb in (0, 1) and a.xmlb in (0, 8,22, 12,97) and b.cd_idm = a.idm and b.ksdm = a.yfdm and c.idm = a.idm      
                      if @@error <> 0      
                begin      
                       select  'F', '����ҽ����Ϣ����'      
                       return      
                      end      
  if exists(select  1 from #yzlrtmp where xmlb = 25)  --�������뵥��Ӧ������ҽ��    
                 BEGIN    
                        insert into  #yzk      
                            select  a.lrxh, a.v5xh, a.fzbz, a.ysdm, a.ksrq, a.pcdm, 1, 1, 0, a.zdm, a.zxsj, a.idm, '0', '0',      
                            '0',  a.yznr, a.ypjl, a.jldw, a.dwlb,'1','������Ӧ����ҽ��', '0', a.ztnr,    
                            a.yznr as yznr,    
                            a.ypyf, a.yfdm,  1,a.tzxh, isnull(a.jsrq, ''), a.zbybz, a.xmdj, (case a.dybz when 1 then 2 else 0 end), '', '', a.mzdm, case a.lzbz when 1 then 0      
                      else a.yzlb end, '0', '0', '0','0',     
                          '0',                                 
                            --c.zyxs,    
                            0, 0, a.hzxm, a.yexh, '0', a.mzxdfh, a.jjbz, a.ybshbz, a.ybspbh, a.sstyz, a.sqzd, a.lzbz, '0', 0, a.sybpno, a.systype, 0, '', '0', --agg 2004.09.10 ��lcxmdm      
                            a.yzlbdy, a.jzbz, a.blzbz, a.sqddm, a.yypdm, a.kjslx, a.kjsbz, a.kjsssyz, a.yyzxh, a.yfzxh, a.jajbz, '', a.zddm, a.zjlx,     
                            a.zjhm, a.Jsdmbz, a.sqdbbid, a.sqdbbzl, a.yyts,a.ypsl,a.zfybz,a.sqgyfl ,a.szyzbz,a.ssxh  ,a.sqbz ,a.szyzzxrq--,a.zpdf     
                            ,a.tcwbz ,a.drsssbz,a.sssksdm    
                      from #yzlrtmp a    
                      where a.yzlb in (0, 1) and a.xmlb=25     
                      if @@error <> 0      
                      begin      
                       select  'F', '����������Ӧ����ҽ������'      
                       return      
                      end      
                        END    
             
                    --�շ���Ŀ�Ĵ���      
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
                       select  'F', '����ҽ����Ϣ����'      
                        return      
                      end     
     
                    --�����ٴ���Ŀ    
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
                       select  'F', '����ҽ����Ϣ����'      
                        return      
                      end      

                    --����Ĭ���������ƣ�6438Ϊ�ջ�������򲻿���      
                      if exists(select  1 from YY_CONFIG(nolock)where id = '6438' and isnumeric(config) = 1)      
        begin      
                       declare @mrypsl ut_sl14_3      
                       select @mrypsl = convert(numeric(14, 3), config)from YY_CONFIG(nolock)where id = '6438'      
                       update #yzk set  ypsl = @mrypsl where ypsl = 0      
                      end      
      
                    --������ҽ��Ƶ��      
                      update #yzk set  zxcs = b.zxcs,      
                      zxzq = b.zxzq,      
                      zxzqdw = b.zxzqdw      
                      from #yzk a, ZY_YZPCK b(nolock)      
                      where a.yzbz in (0, 1) and a.pcdm = b.id --ǰ���Ѱ�����ת��Ϊ��ʱҽ��      
                      if @@error <> 0      
                      begin      
                       select  'F', '������ҽ����Ϣ����'      
                       return      
                      end      
      
                    --�޸����뵥������ҽ��Ϊ��ʱҽ��      
                      update #yzk set       
                      yzbz = 0,      
                      pcdm = '00',      
                      zxcs = 1,      
                      zxzq = 1,      
                      zxzqdw = '0'      
                      from #yzk a      
                      where sqddm > 0 --ǰ���Ѱ�����ת��Ϊ��ʱҽ��      
       
                    --�����ۼ���ҩ��־    
                            update a set  ljlybz=b.ljlybz    
                            from #yzk a,YK_LJLYFSSZ b where a.idm=b.cd_idm and a.zxksdm=b.yfdm and a.idm>0 and b.jlzt=0    
                      update #yzk set  ljlybz = 0      
                      where yzbz = 0 or zbybz > 0 --���ﵥλ�����ۼ���ҩ      
                      if @@error <> 0      
                      begin      
                       select  'F', '�����ۼ���ҩ��־����'      
                       return      
              end      

                      declare @error integer,@rowcount integer      
       --��������ҽ��      
                      if exists(select  1 from #yzlrtmp where xmlb = 2)      
                      begin      
                       if (select  config from YY_CONFIG(nolock)where id = '6036') = '��'      
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
                        select  'F', '�������벻���ڣ�'      
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
                        select  'F', '�������벻���ڣ�'      
                         return      
                       end      
                       if @rowcount = 0      
                       begin      
                        select  'F', '�������벻����3��'      
                         return      
                       end      
                      end      
      
                    --�������뵥ҽ��  (ҽ��ȷ�ϱ�־ȡ�շ�С��Ŀ��ģ���HISά����Ϊ��׼)    
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
                        select  'F', '�������뵥��Ϣ����'      
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
                        select  'F', '�������뵥��Ϣ����'      
                         return      
                       end      
                      end      
                      --����ֹͣҽ��        
                      if exists(select  1 from #yzlrtmp where xmlb = 9)      
                      begin      
                       insert into  #yzk      
                       select  a.lrxh, a.v5xh, b.fzxh, a.ysdm, a.ksrq, a.pcdm, 1, 1, 0, a.zdm, a.zxsj, a.idm, b.gg_idm, b.lc_idm,      
                       b.ypdm, convert(varchar(256), 'ͣ*' + b.ypmc), b.ypjl, b.jldw, b.dwlb, b.ypsl, b.ypgg, b.zxdw, b.ztnr,      
                       convert(varchar(256), 'ͣ*' + b.yznr), b.ypyf, b.zxksdm, 9, b.xh, isnull(a.jsrq, ''), b.zbybz, b.zdydj,      
                       b.dybz, b.djfl, b.yzdjfl, '', 0, '', '', '', 0, 1, b.cgyzbz, b.yjqrbz      
                       , a.hzxm, a.yexh, '', a.mzxdfh, a.jjbz, a.ybshbz, a.ybspbh, a.sstyz, a.sqzd, a.lzbz, a.lcxmdm, 0, a.sybpno, a.systype, 0, '', '0',      
                       9, a.jzbz, a.blzbz, a.sqddm, a.yypdm, a.kjslx, a.kjsbz, a.kjsssyz, a.yyzxh, a.yfzxh, a.jajbz, '', '', 0,    
                        '', 0, a.sqdbbid, a.sqdbbzl, a.yyts ,a.ypsl ,a.zfybz ,a.sqgyfl,a.szyzbz,a.ssxh,a.sqbz,a.szyzzxrq--,a.zpdf     
                                ,a.tcwbz ,a.drsssbz,a.sssksdm    
                       from #yzlrtmp a, BQ_CQYZK b(nolock)      
                       where a.yzlb = 0 and a.xmlb = 9 and b.syxh = @syxh and b.yexh = @yexh and a.tzxh = b.v5xh --ʹ��������������and a.ypdm = b.ypdm and a.idm = b.idm      
                       if @@error <> 0 --or @@rowcount = 0  ���5.0 δ���ͣ�ֹͣ�ˣ�4.0�Ҳ��������Ա�����    
                       begin      
                        select  'F', '����ֹͣҽ������'      
                        return      
                       end      
                                update #yzk set yplh=b.yplh from #yzk a,YK_YPCDMLK b where  b.idm = a.idm      
                      end      
      
                    --����ҩƷҽ�����ݷ��࣬5.0ҽ��վʹ��4.0����ר�õ�ҽ�����ݴ�����Ϊ����ҽ��վ��ҽ�����ԣ�    
                    --ҽ�����ݷ�������岻�����ڲ���ҽ��ִ�е�ʱ���������      
                        declare @yplh ut_kmdm, --ҩƷ����      
                        @ypjx ut_jxdm, --ҩƷ����      
                        @tsyp varchar(2), --�����־      
                        @errmsg varchar(50),      
                        @djfl ut_dm4, --���ݷ���      
                        @yzdjfl ut_dm4, --      
                        @yzmzxdfh ut_xh12,      
                        @yzsybz ut_bz,      
                        @syksdm ut_ksdm, --��Һ���Ҵ���      
                        @nysbz ut_bz, --ҽ����־ 1 ����ʿ      
                        @djbz ut_bz,      
                        @config6372 varchar(255), @config6419 varchar(255), @config6420 varchar(255), @config6421 varchar(255),    
                        @cydyyzzt ut_bz,      
                        @sydjfl_glcq ut_dm4,      
                        @tsbz varchar(2),  
        @cfid smallint, @config6451 varchar(2),@configcydydjfl varchar(2),    
                        @fzxh ut_xh12 --�������  
                     select @config6451 = '��'  ,@cydyyzzt=0    
                        select @config6451 = ltrim(rtrim(config))from YY_CONFIG where id = '6451'      
                        if len(ltrim(rtrim(@kzzd)))>=3    
                            select @configcydydjfl =  [dbo].[fun_SplitString](@kzzd,'|',3)     
                     select @nysbz = 1 --Ĭ����ҽ��      
                        select @nysbz = zglb from YY_ZGBMK where id = @czyh --�Ҳ���Ĭ���ǻ�ʿ����ҽ���Ĵ������ͻ�ʿ����һ��      
                        if not exists(select  * from tempdb..sysobjects where name='#getdjflbyfldm') --�������ݷ�����ʱ��    
       create table #getdjflbyfldm    
       (    
        tsbz varchar(2),  --�����־    
        djfl ut_dm4,  --���ݷ���    
        fzxh ut_xh12, --�������    
                                yzbz char(1)  --����/��ʱҽ��    
       )    
      else     
       drop table #getdjflbyfldm    
                     --��Ժ��ҩ����Ҫ�е��ݷ���    
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
                       if @config6451 = '��'      
                        exec usp_bq_djfl @yplh, @ypjx, @tsbz, @ypyf, @yzlb, @errmsg output, @yjqrbz, @yzsybz, @djbz, @cfid      
                       else      
                        exec usp_bq_djfl @yplh, @ypjx, @tsyp, @ypyf, @yzlb, @errmsg output, @yjqrbz, @yzsybz, @djbz      
                       if @errmsg like 'F%'      
                        select @djfl = ''      
                       else      
                        select @djfl = substring(@errmsg, 2, 4)      
       
                       update #yzk set  djfl = @djfl where current of cs_getdjfl      
                                declare @getdjflbytsbz ut_mc16    
        select @getdjflbytsbz=dbo.Get_djflfromconfig(LTRIM(RTRIM(@tsbz)),1)--����ҽ��    
        if rtrim(ltrim(@getdjflbytsbz))<>'' and @djfl=rtrim(ltrim(@getdjflbytsbz))    
         insert into #getdjflbyfldm select @tsbz,@getdjflbytsbz,@fzxh,1    
            
        set @getdjflbytsbz=''    
        select @getdjflbytsbz=dbo.Get_djflfromconfig(LTRIM(RTRIM(@tsbz)),0)--��ʱҽ��    
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
                    --����:29404 ���ڳ���ҩƷ���ݷ�����ݲ���ƥ��ɹ�֮��.�޸ĳ���ҩƷ�ĵ��ݷ���Ϊͬһ���ݷ���    
                    update #yzk set djfl=b.djfl from #yzk a,#getdjflbyfldm b where a.fzxh=b.fzxh AND a.yzbz=b.yzbz    
                    --������Һ���Ҵ��룬ͨ�������ж���Һ��־      
      
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
                        select  'F', 'C', '���ھ���ҽ���Ŀ�ʼʱ�䲻����' + @config6420 + '֮ǰ��' + @config6421 + '֮��'      
                        return      
                       end      
                       else      
                       begin      
                        select  'F', '���ھ���ҽ���Ŀ�ʼʱ�䲻����' + @config6420 + '֮ǰ��' + @config6421 + '֮��'      
                        return      
                       end      
                      end      
                     end      

                    --���ҽ��������־      
                     if @configg075 = '��' --��ʹ���ύ��ʽ��ʱ��ù��ܲ���      
                     begin      
                      update #yzk set  sxysbz = c.cfbz      
                      from #yzk b, YY_ZGBMK c where b.ysdm = c.id and b.yzbz in (0, 1)      
                     end      
                     if @configg075 = '��'      
               begin --ʹ���ύ��ʽ��ʱ�����⴦��      
                      if @sxysbz = 1      
                      update #yzk set  sxysbz = 0 where yzbz in (0, 1)      
                     else      
                      update #yzk set  sxysbz = 1 where yzbz in (0, 1)      
                     end      
                     create table #Fzxh      
                     (      
                      yzxh ut_xh12 not null,      
                      fzxh ut_xh12 not null,      
                      pcdm ut_dm2 null --��������д��������Ϣ��Ƶ�δ���      
                     )      
      
                     create table #sybpxh      
                     (      
                      fzxh ut_xh12 not null,      
                      sybpno ut_xh12 null      
                     )      
                    --����ҽ����memo2      
                        declare @password varchar(16),      
                        @result varchar(9)      
                        select @password = convert(varchar(16), @syxh)      
                        exec usp_yy_encrypt @password, @now, @result output      
                    --��̨������      
                     begin tran      
        
                        --��Ҫ����ԭ�����뵥��Ϣ      
                            update #yzk set  sqdxh = c.sqdxh, sqdxmbz = c.sqdxmbz, sqdsjxm = c.sqdsjxm, yzlb = 7 from #yzk a, #yzlrtmp b, BQ_LSYZK c (nolock)     
                            where a.lrxh = b.lrxh and b.yfzxh = c.xh and c.syxh = @syxh and c.yexh = @yexh and c.yzzt <= 0 and c.sqdxh <> 0 and c.yzzt <> -3      
                            and isnull(c.yzlb2, 0) <> 1      
            
                       --4.0��ҽ��ʼ������ɾ�󱣴棬ֻɾ������5.0���͹�����ҽ��    
                        delete BQ_LSYZK where syxh = @syxh and yexh = @yexh and yzzt <= 0 and v5xh in (select v5xh from #yzlrtmp where yzlb=0 )      
                        if @@error <> 0      
                        begin      
                            rollback tran      
                                select  'F', 'ɾ����ʱҽ��ʱ����'      
                                return      
                        end      
                      --4.0��ҽ��ʼ������ɾ�󱣴棬ֻɾ������5.0���͹�����ҽ��    
                        delete BQ_CQYZK where syxh = @syxh and yexh = @yexh and yzzt <= 0 and v5xh in (select v5xh from #yzlrtmp where yzlb=1 )      
                            if @@error <> 0      
                        begin      
  rollback tran      
                                select  'F', 'ɾ������ҽ��ʱ����'      
                                return      
                        end      
                        
                    --ҽ����Ĳ��봦��      
                         
                      if exists(select  1 from #yzk where yzbz = 0)      
                        begin      
                if exists(select  1 from #yzk where yzbz = 0 and yzlb=9)      
       begin      
        delete a from BQ_LSYZK a, #yzk b    
        where a.syxh=@syxh and a.tzxh = b.tzxh and a.yzlb=9 and b.yzlb = 9 and     
              b.yzbz = 0 and a.v5xh>0 and a.yzzt=0     
                  

                                --Ԥֹͣ    
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
                             if exists(select 1 from CISSVR.CISDB.dbo.CPOE_XCF_SZ where ID= '0013' AND VALUE='��')     
                            select @xcfhssh = '��'    
                            --С�������ģʽ�жϣ�    
                            declare @xcfhsshbz varchar(32)    
                            select @xcfhsshbz='��'    
                            if exists(select 1 from CISSVR.CISDB.dbo.CPOE_XCF_SZ where ID= '0013' AND VALUE='��')     
                                select  @xcfhsshbz='��'    
                            insert into  BQ_LSYZK(syxh, fzxh, bqdm, ksdm, ysdm, lrrq, lrczyh, ksrq, pcdm, idm, gg_idm,      
                            lc_idm, ypdm, ypmc, ypjl, jldw, dwlb, ypsl, ypgg, zxdw, ztnr, yznr, ypyf, zxksdm, yzlb,      
                            mzdm, tzxh, tzrq, yzzt, zbybz, zdydj, dybz, djfl, yzdjfl, cgyzbz, yjqrbz, hzxm, yexh, memo,      
                            mzxdfh, jjbz, ybshbz, ybspbh, sstyz, sqzd, sxysdm, lcxmdm, sybph, memo2, sqdxh, sqdxmbz, sqdsjxm, yzlbdy, jzbz, blzbz, sqdid, yypdm, kjslx, kjsbz, kjsssyz      
                            , jajbz, pxxh, dmjszd, dmjszjlx, dmjszjh, dmjsbz, yzlb2, v5xh, yshdbz,zfybz,sqgyfl,sqbz,zxrq,tcwbz,ssaprq)  --winnign-dingsong-chongqing add ,ssaprq   
                            select @syxh, fzxh, @bqdm, @ksdm, case when(@sxysbz = 2 and sxysbz = 0) then @czyh      
                            else ysdm end, @now, case when(@sxysbz = 2 and sxysbz = 0) then @czyh when(systype = 1) then @czyh when @nysbz = 2 then @czyh      
                      else ysdm  end, ksrq, pcdm, idm, gg_idm, lc_idm, ypdm, convert(varchar(256), ypmc) , ypjl, jldw, dwlb, ypsl, ypgg, zxdw,  (case when isnull(sstyz, 0) = 0 then ztnr      
                      else  ltrim(rtrim(ztnr)) + '[ͣ����ҽ��]' end),     
                      convert(varchar(256), yznr), ypyf, zxksdm, yzlb,  mzdm, tzxh, tzrq,     
                            --ҽ��״̬�ļ���    
                            case when @xcfhssh='��' and yzlb=97 then 0 when(@sxysbz = 1 and sxysbz = 0) then - 1      
                            --С���������� ����Ҫ���ִ�У����ǻ�ʿ��Ҫǩ�� for 8974 aorigele 2014/1/13    
        --С���������ģʽ ҽ��״̬0����ˡ�ִ�к������ҩ����� aorigele 2017/4/4    
                      when yzlb = 14 and idm>0  then (case when @xcfhsshbz='��' then 0 else 2 end)                     
                            when szyzbz=1 then -2 else 0  end,                          
                      zbybz, zdydj, dybz, djfl, yzdjfl, cgyzbz, yjqrbz, hzxm, yexh, case when szyzbz=1 then 'SZYZ' when @config6432 = '��' then '[' + convert(varchar(20), yyzxh) + ']' + memo      
                      else memo  end,  mzxdfh, jjbz, ybshbz, ybspbh, sstyz, sqzd, case when @sxysbz = 2 then ysdm      
                      else  ''  end, lcxmdm, sybpno, @result, isnull(sqddm,0), sqdxmbz, sqdsjxm, --����lcxmdm      
                       case when yzlbdy = -1 then yzlb when yzlbdy=20 then 6 when yzlbdy=21 then 7 else  yzlbdy  end, jzbz, blzbz, 0, yypdm, kjslx, kjsbz, kjsssyz      
                      , jajbz, 999999, zddm, zjlx, zjhm, Jsdmbz, case when szyzbz=1 then 1 else 0  end, v5xh, 1 ,zfybz,sqgyfl,sqbz,szyzzxrq,tcwbz,b.SQRQ --winnign-dingsong-chongqing add ,b.SQRQ   
                      from #yzk a
					  left join CISDB..CPOE_SSYZK  b on a.v5xh=b.YZXH and b.JLZT=0 --winnign-dingsong-chongqing
					  where a.yzbz = 0 and isnull(a.sqdxh, 0) = 0 and a.yzlb <> 12 order by a.fzxh      
                      if @@error <> 0      
                      begin      
                       rollback tran      
                        select  'F', '������ʱҽ��ʱ����'      
                        return      
                      end      
                         if(@xcfhsshbz='��')                          
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
                                if exists(select 1 from sysobjects where name='BQ_LSYZK_FZ') --���ӱ��ж���Ϊ��ص�HIS�汾���ǳ���    
                                begin    
             insert into BQ_LSYZK_FZ(syxh,yzxh,sssksdm,ssxh,tgbz,drsssbz)      
             select @syxh,a.xh,case WHEN b.sssksdm<>'' THEN b.sssksdm else c.ssksdm END,c.xh,1,b.drsssbz from BQ_LSYZK a (nolock),#yzk b ,SS_SSDJK c      
             where a.syxh = @syxh and a.v5xh=b.v5xh and c.xh = b.ssxh and a.yzlb2=1  AND b.yzlb!=6 AND b.yzlb!=7    
             if @@error <> 0        
             begin        
             rollback tran        
              select  'F', '������ʱ����ҽ��ʱ����'        
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
                select  'F', '������ʱ�����鸨��ҽ��ʱ����'        
                return     
              end    
                                end                             
                            end           
                            --����ҽ����ֱ�ӵǼǵ������Ǽǿ��У�ҽ������� aorigele �����������ҽ��վҽ��ֱ�Ӳ�����SS_SSDJK�У�ҽ�����ʱ�򲻲�����4.0�п���)    
                            --���� 7525    
                            --select * from YY_CONFIG WHERE id = 'G090'    
                            --if (select config from YY_CONFIG (nolock) where id='G090')='��'       
                            if LEN(ltrim(rtrim(@kzzd)))>=1   --ǰ̨�����������           
          begin            
                                  
        --if (select config from YY_CONFIG (nolock) where id='6036')='��'     
   DECLARE @jzss VARCHAR(2)      
                                DECLARE @fjzss VARCHAR(2)       
                                DECLARE @ss VARCHAR(5)       
                                SELECT @ss= [dbo].[fun_SplitString](@kzzd,'|',1) --��ȡ����ҽ����־              
                                SELECT @fjzss = SUBSTRING(@ss,1,1)--�Ǽ�������    
                                SELECT @jzss=SUBSTRING(@ss,3,1)--��������    
                                 DECLARE @fsSs VARCHAR(50)         
        if ((@jzss='1'  OR @fjzss='1')and @HP405='��')        
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
             select 'F','���������Ǽǿ����'              
             return              
           end        
                                          --���ҽԺ���Ը�����Ҫ����,    
                    --����ſ��Ƿ�����Ϣ����ǰ����,��ʿվ�����������Ϣ���վͿ��Բ鿴��,������    
         --������Ϣ����ǰ����    
                    declare @ysdmyy2 ut_czyh,@bqdm_curryy2 ut_ksdm,@send_msgyy2 varchar(100)    
                    select @bqdm_curryy2=b.bqdm,@send_msgyy2=c.HZXM+c.MEMO,@ysdmyy2=c.LRCZYH from BQ_LSYZK     
 a left join SS_SSDJK b on a.xh=b.yzxh left join     
 CISSVR.CISDB.dbo.CPOE_LSYZK c on c.XH=a.v5xh    
 where v5xh in (select v5xh from #yzlrtmp) and b.yzxh is not null      
if (isnull(@send_msgyy2,'') <> '')     
                    exec usp_yy_autosendmsg 2,@ysdmyy2,'',@bqdm_curryy2,@send_msgyy2     
           --����4.0��������ҽ��״̬����Ϊ��ִ��    
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
             select 'F','�������ҽ������'              
             return              
           end     
        end      
                               else    
                               begin    
                   
                                 if ( @HP405='��' and exists(select  1 from #yzlrtmp_ss  where  xmlb=2 ))----- ������˵�ʱ��Ų�Ǽ�-��Ϣ          
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
                                          select 'F','�������ҽ������'          
                                          return          
  end      
                                          --���ҽԺ���Ը�����Ҫ����,    
                    --����ſ��Ƿ�����Ϣ����ǰ����,��ʿվ�����������Ϣ���վͿ��Բ鿴��,������    
                    --������Ϣ����ǰ����    
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
      
                    --�����Ժ��ҩ��ҽ��      
                            --declare @hp44 varchar(4)--��Ժ��ҩ�Ƿ����ﵥλ����    
                            declare @hp123 varchar(4)--���ó�Ժ��ҩ��¼��ģʽ�Ƿ�Ϊ��ģʽ    
                           declare @config3180 varchar(4)--�����ۼ�ģʽ    
       select @config3180 = config from YY_CONFIG where id = '3180'    
                            select @hp123= CONFIG from CISSVR.CISDB.dbo.SYS_CONFIG WHERE ID='HP123'    
                            if exists(select 1 from YY_CONFIG(nolock)where id = '6584' and config='��')    
         select @cydyyzzt=0    
                      else    
     select @cydyyzzt=-2 --��Ժ��ҩ��ҽ��վ�ƷѲ��֣��Ѿ��Ƴ�ȥ��Ϊ�����ĺ�̨��    
       
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
                                 case @hp44 when '��' then a.cydyypsl *  b.mzxs else a.cydyypsl *  b.zyxs end--ʹ���Ǹ�ϵ���ɿ��ؾ���      
                            else    
                                  a.cydyypsl --������Ժ��ҩ����Ѿ�������ϵ�����˴�����Ҫ�ڳ���ϵ��    
                            end,    
                       case when ltrim(rtrim(isnull(a.ypgg, ''))) = '' then b.ypgg      
                      else  a.ypgg  end, /* b.mzdw*/    
                            --b.zxdw ,    
                            case @hp44 when '��' then b.mzdw else b.zydw end , --ʹ���Ǹ���λ�ɿ��ؾ���    
                         a.ztnr,  b.ypmc + ' ' + case @hp123 when '��' then '' else rtrim(d.name) end      
                      + case @hp123 when '��' then '' else ' ÿ��' + convert(varchar(18), a.ypjl) + ltrim(rtrim(a.jldw)) end     
                      + case @hp123 when '��' then '' else ' ' + ltrim(rtrim(c.name)) end     
                      + case @hp123 when '��' then '' else ' ' + convert(varchar(4), a.yyts) + '��' + ' ' end     
                            + convert(varchar(12), a.cydyypsl, 3) + case @hp44 when '��' then rtrim(ltrim(b.mzdw)) else RTRIM(LTRIM(b.zydw)) end,      
                      a.ypyf, a.zxksdm, 12, null, null,      
                      @cydyyzzt, a.zbybz, 0, null, 0, a.djfl,    
                      case @hp44 when '��' then convert(varchar(12),  b.mzxs) else convert(varchar(12),  b.zyxs) end ,      
                            --convert(varchar(12),  b.mzxs),     
                            a.ybshbz, a.ybspbh,     
                            case a.pcdm     
                            when '00'     
 then '1�죬ÿ��08,'    
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
                       select  'F', '�����Ժ��ҩ����'      
                       return      
                      end      
                        
                           --3180=2�����ۼ�ģʽ����Ժ��ҩ��涳��HIS�洢���Ѵ����˴����¶���    
                           IF @config7002='��' and @config3180<>2 and not exists(select 1 from YY_CONFIG(nolock)where id = '6584' and config='��')    
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
                             select 'F','��������(djsl)����'+@rtnmsg             
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
          select 'F','��������(djsl)����'    
          return    
         end    
                                end    
        END     

                    --���ϴ����Ժ��ҩ��ҽ��      


      
                      if @config6432 = '��'      
                      begin      
                       select  xh yzxh, convert(int, substring(memo, 2, charindex(']', memo) - 2))yyzxh into  #lsssyz_temp      
                       from BQ_LSYZK (nolock)    
                       where fzxh in (select fzxh from #yzk) and syxh = @syxh and yexh = @yexh and v5xh in (select v5xh from #yzlrtmp where yzlb=0 ) and    
                       yzzt <= 0 and yzzt <> -3 and isnull(sqdxh, 0) = 0 and charindex(']', memo) > 2      
                       and isnull(yzlb2, 0) <> 1      
                       if @@error <> 0      
                       begin      
                        rollback tran      
                        select  'F', '��ѯ��ʱҽ��ʱ����'      
                        return      
                       end      
   
                       update BQ_LSYZK set  kjsssyz = a.yzxh      
                       from #lsssyz_temp a      
                       where kjsssyz = a.yyzxh and kjslx > 0 and kjsbz > 0 and syxh = @syxh and yexh = @yexh      
                       and isnull(yzlb2, 0) <> 1      
                       if @@error <> 0      
                       begin      
                        rollback tran      
                        select  'F', '������ʱҽ��ʱ����'      
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
                        select  'F', '������ʱҽ��ʱ����'      
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
                       select  'F', '������ʱҽ��ʱ����'      
                       return      
                      end      
      
      
                    --�����ﴦ�������ı仯 ,�ų��Ժ��ҩ����������ǰ���Ѿ��������     
      
                      declare @retmsg2 int,      
                      @lz_pcdm ut_dm2,      
                      @lz_xh ut_xh12,      
                      @lz_ypjl ut_sl14_3,      
                      @lz_ypsl ut_sl10,      
                      @lz_zdm char(7), --�ܴ���      
                      @lz_zxsj ut_mc256, --ִ��ʱ��      
                      @lz_zxcs int, --ִ�д���      
                      @lz_ksrq ut_rq16, --��ʼ����      
                      @lz_zxrq ut_rq16, --ִ������      
                      @lz_tzrq ut_rq16, --ֹͣ����      
                      @lz_mcsl ut_sl14_3, --������ÿ������      
                      @lz_idm ut_xh9,      
                      @lz_ljlybz ut_bz --�ۼ���ҩ��־      
       
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
       
                       --��������ȡ���Ĵ���      
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
       
       
           if @configg007 = '��'      
                       begin      
                        update BQ_LSYZK set  ypjl = @lz_ypjl, ypsl = @lz_ypsl,      
                        yznr = case a.yzlb when 2 then a.yznr     
                                                       when 6 then a.yznr     
                                    else ( ypmc + ' ' + isnull(ypgg,'') + ' ' + isnull(convert(varchar(12), @lz_mcsl),'') + ' ' + isnull(ltrim(rtrim(jldw)),'') + ' ' + isnull(ltrim(rtrim(c.name)),'') + ' ' + isnull(d.name,'')) END ,       
                        lz_pcdm = @lz_pcdm, lz_mcsl = @lz_mcsl, lz_zxsj = @lz_zxsj --���Ӽ�¼������ԭʼƵ�δ����ÿ������      

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
                        else yznr  end,lz_pcdm = @lz_pcdm, lz_mcsl = @lz_mcsl, lz_zxsj = @lz_zxsj --���Ӽ�¼������ԭʼƵ�δ����ÿ������      
                            
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
                        select  'F', '������������'      
         
                        return      
                       end      
                       fetch cs_lz into @lz_xh, @lz_pcdm, @lz_ksrq, @lz_ypjl, @lz_ypsl, @lz_idm      
                      end;      
                      close cs_lz      
                      deallocate cs_lz      
       
                      update BQ_LSYZK set  fzxh = b.yzxh      
                      from BQ_LSYZK a, #Fzxh b      
                     where a.syxh = @syxh and a.yexh = @yexh and a.yzzt <= 0 and a.yzzt <> -3 and a.fzxh = b.fzxh and (isnull(a.yzlb2, 0) <> 1 or (isnull(a.yzlb2, 0)=1 and a.yzzt=-2))    
                      --������Զ��������շ���Ŀ��ֹͣ����Ĭ��Ϊ0001010100:00:00,������    
        update BQ_LSYZK set  tzrq=''      
                      from BQ_LSYZK a    
                      where a.syxh = @syxh and a.yexh = @yexh and a.yzzt = 0 and a.tzrq='0001010100:00:00'    
                            if @@error <> 0      
                      begin      
                       rollback tran      
                        select  'F', '������ʱҽ��ʱ����'      
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
                       select  'F', 'ҽ����������ʱ����'      
                       return      
                      end      
       
                      update BQ_LSYZK set  sybph = b.sybpno      
                      from BQ_LSYZK a, #sybpxh b      
                      where a.syxh = @syxh and a.yexh = @yexh and a.yzzt <= 0 and a.yzzt <> -3 and a.fzxh = b.fzxh and (isnull(a.yzlb2, 0) <> 1 or (isnull(a.yzlb2, 0)=1 and a.yzzt=-2))      
                      if @@error <> 0      
                      begin      
                       rollback tran      
                       select  'F', '������ʱҽ��ʱ����'      
                       return      
                      end      
       
                     /* ���������÷�������Ϣת����������ϼ�����Ϣ */      
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
                       select  'F', '������ʱҽ������ʱ����'      
                       return      
                      end      
                         --4.0�Ӽ���ʶ�Ĵ���    
                            declare @hp369 ut_mc256    
                            select @hp369= ','+RTRIM(CONFIG)+',' from CISSVR.CISDB.dbo.SYS_CONFIG WHERE ID='HP369'    
                            if(@hp369<>'')    
                            begin    
           update a set a.ypmc='(��)'+a.ypmc,a.yznr=a.yznr+'(��)'     
      from BQ_LSYZK a,#yzk b    
                                where a.syxh = @syxh and a.yexh = @yexh and a.jajbz=1 and a.v5xh = b.v5xh and CHARINDEX(','+convert(varchar(2),a.yzlb)+',',@hp369)>0    
                                if @@error <> 0      
                          begin      
                           rollback tran      
                           select  'F', '������ʱҽ��ʱ����'      
                           return      
                          end      
                            end    
                    end      
      
                    --���뵥����      
                     if exists(select  1 from #yzlrtmp where xmlb in (6, 7))      
                     begin      
                      insert into  ZY_BRSQD(syxh,yexh, mbxh, lrrq, czyh, sqks, yjlb, blsqdxh, txm,jzbz)      
                            select  distinct @syxh,@yexh, b.yypdm, @now, @czyh, @ksdm, case when b.yzlb = 6 then '02' when  b.yzlb = 7 then '01'  else '' end, sqddm,     
                            case when b.yzlb = 6     
                            then 'A6' + Replace(space(8 - len(abs(sqddm))), ' ', '0') + Convert(varchar, abs(sqddm))  end --ֻ�м�����뵥����Ҫ��������      
                            ,jzbz    
                   from #yzk b     
                            where isnull(sqddm, 0) <> 0 --ֻ�м�����뵥����Ҫ      
                            if @@error <> 0   
                      begin      
                       rollback tran      
                       select  'F', '�������뵥����1��'      
                       return      
                      end      
      
                      update ZY_BRSQD set  zxks = b.zxksdm, jzbz = b.jjbz      
                      from ZY_BRSQD a, #yzk b      
                      where a.blsqdxh = b.sqddm and isnull(b.sqddm, 0) <> 0 and a.syxh = @syxh      
                      if @@error <> 0      
                      begin      
                       rollback tran      
                       select  'F', '�������뵥����2��'      
                       return      
                      end     

                             --��ɾ���ٲ��룬����21155,ż���ظ�����    
             declare @sqdxh ut_xh12    
             select @sqdxh = a.xh from  ZY_BRSQD a, #yzk b        
                            where a.blsqdxh = b.sqddm and isnull(b.sqddm, 0) > 0 and a.syxh = @syxh        
             delete from ZY_BRSQDMXK where sqdxh= @sqdxh    

                      insert into  ZY_BRSQDMXK(sqdxh, zyxh, caption, valuedm, value, zlx, taborder, dykz, jlzt, lrczyh, lrrq)      
                            select  distinct a.xh, 16, '������', '', a.txm, 0, 0, 0, 0, @czyh, @now      
                            from ZY_BRSQD a, #yzk b      
                            where a.blsqdxh = b.sqddm and isnull(b.sqddm, 0) > 0 and a.syxh = @syxh      
                            if @@error <> 0      
                      begin      
                       rollback tran      
                       select  'F', '�������뵥��ϸ����1��'      
                       return      
                      end     
      
                      insert into  ZY_BRSQDMXK(sqdxh, zyxh, caption, valuedm, value, zlx, taborder, dykz, jlzt, lrczyh, lrrq)      
                            select  distinct a.xh, -1, 'BBZL', b.sqdbbid, b.sqdbbzl, 0, 0, 0, 0, @czyh, @now      
                            from ZY_BRSQD a, #yzk b      
                            where a.blsqdxh = b.sqddm and isnull(b.sqddm, 0) > 0 and a.syxh = @syxh      
                            if @@error <> 0      
                      begin      
                       rollback tran      
                       select  'F', '�������뵥��ϸ����1��'      
                       return      
                      end      
      
                      update BQ_LSYZK set sqdxh=b.xh    
                      from BQ_LSYZK a,ZY_BRSQD b    
                      where a.syxh=@syxh and b.syxh=@syxh and a.sqdxh=b.blsqdxh and     
                       b.blsqdxh in (select sqddm from #yzlrtmp where isnull(sqddm, 0) <> 0)    
                      if @@error <> 0    
                      begin    
                       rollback tran    
                       select  'F', '������ʱҽ�����뵥��ų���2��'    
    return    
                      end    
      

                      update ZY_BRSQD set  blsqdxh = 0 - a.blsqdxh      
                            from ZY_BRSQD a, #yzk b      
                            where a.blsqdxh = b.sqddm and isnull(b.sqddm, 0) <> 0 and a.syxh = @syxh and b.yzlb = 6      
                     end      
                    --����ҽ���Ĵ���      
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
                      yzlb, case when(@sxysbz = 1 and sxysbz = 0) then -1 else 0 end, --����ʵϰҽ������      
                      zbybz, zdydj, dybz, djfl, yzdjfl, cgyzbz, yjqrbz, ljlybz, hzxm, yexh, mzxdfh, jjbz,      
                      ybshbz, ybspbh, 0, case when @sxysbz = 2 then ysdm else '' end, lcxmdm, sybpno, @result, --����lcxmdm      
                       case when yzlbdy = -1 then yzlb when yzlbdy=20 then 6 when yzlbdy=21 then 7 else  yzlbdy  end, isnull(sqddm, 0), yypdm      
                      , jajbz, 999999, zddm, zjlx, zjhm, Jsdmbz, v5xh  ,zfybz,tcwbz --,zpdf    
                      from #yzk where yzbz = 1 and lzbz = 0 order by fzxh      
                      if @@error <> 0      
                      begin      
                       rollback tran      
                        select  'F', '���泤��ҽ��ʱ����'      
                        return      
                      end      
      
                      if exists(select  1 from #yzk where yzlb = 3 and yexh=0) --������ʳҽ������ҳ����      
                      begin      
                       update ZY_BRSYK      
                       set  ssyz = b.ypmc      
                       from ZY_BRSYK a(nolock), #yzk b      
                       where b.yzlb = 3 and a.syxh = @syxh     
                       if @@error <> 0      
                       begin      
                        rollback tran      
                         select  'F', '���²�����ҳ�����'      
                         return      
                       end      
                      end      
                      if exists(select  1 from #yzk where yzlb = 5) --���滤��ҽ������ҳ����      
                      begin      
                       update ZY_BRSYK      
                       set  hlyz = b.ypmc,hldm=b.ypdm      
                       from ZY_BRSYK a(nolock), #yzk b      
                       where b.yzlb = 5 and a.syxh = @syxh      
                       if @@error <> 0      
                       begin      
                        rollback tran      
                        select  'F', '���²�����ҳ�����'      
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
                       select  'F', '���泤��ҽ��ʱ����'      
                       return      
                      end      
      
                      update BQ_CQYZK set  fzxh = b.yzxh      
     from BQ_CQYZK a, #Fzxh b      
                      where a.syxh = @syxh and yexh = @yexh and a.yzzt <= 0 and a.fzxh = b.fzxh      
                      if @@error <> 0      
                      begin      
                       rollback tran      
                    select  'F', '���泤��ҽ��ʱ����'      
                       return      
                      end      
                    --סԺҽ��վ��ҽ���Ϳ�ͣ����ͬһ�����е�����ҽ����ֹͣ����δ������      
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
                        select  'F', '�޸ķ����г���ҽ��ֹͣ����Ϊ�յ����ݳ���'      
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
                       select  'F', 'ҽ����������ʱ����'      
                       return      
                      end      
      
                      update BQ_CQYZK set  sybph = b.sybpno      
                      from BQ_CQYZK a (nolock), #sybpxh b      
                      where a.syxh = @syxh and a.yexh = @yexh and a.yzzt <= 0 and a.fzxh = b.fzxh      
                      if @@error <> 0      
                      begin      
                       rollback tran      
                       select  'F', '���泤��ҽ��ʱ����'      
                       return      
                      end      
      
     
                     end      
      
                    --��Ϊ�����аѱ������@yzdjfl���������Լ�һ���ж�      
                     if exists(select  1 from BQ_LSYZK a (nolock) where syxh = @syxh and yzzt <= 0 and yzzt <> -3 and idm > 0 and a.yzlb<>12 and isnull(a.yzlb2, 0) <> 1 and not exists(select  1 from BQ_YZDJFLK b(nolock)where b.jlzt = 0 and a.djfl = b.id)



 




 



)      
                     begin      
                      insert into  YY_ERROR      
                            select  getdate(), 'ҽ�����ݷ���' + convert(varchar(12), a.xh) + '0 ' + a.djfl      
                            from BQ_LSYZK a where syxh = @syxh and yzzt <= 0 and yzzt <> -3 and isnull(a.yzlb2, 0) <> 1 and not exists(select  1 from BQ_YZDJFLK b(nolock)where a.djfl = b.id)      
                            if @@error <> 0      
                      begin      
                       rollback tran      
                       select  'F', '����ҽ�����ݷ��������Ϣʱ����'    
                       return      
                      end      
    end      
        --����ҽ��    
      if exists(select 1 from BQ_LSYZK a (nolock) where syxh=@syxh and yzzt=0 and idm>0  and isnull(a.yzlb2,0)=1 and not exists(select 1 from BQ_YZDJFLK b (nolock) where b.jlzt=0 and a.djfl=b.id))    
      begin    
       insert into YY_ERROR    
       select getdate(),'ҽ�����ݷ���'+convert(varchar(12),a.xh)+'0 '+a.djfl    
       from BQ_LSYZK a where syxh=@syxh and yzzt=0  and isnull(a.yzlb2,0)=1 and not exists(select 1 from BQ_YZDJFLK b (nolock) where a.djfl=b.id)    
       if @@error<>0    
       begin    
        rollback tran    
        select 'F','����ҽ�����ݷ��������Ϣʱ����'    
        return    
       end    
      end    
                     if exists(select  1 from BQ_CQYZK a (nolock) where syxh = @syxh and yzzt = 0 and idm > 0 and not exists(select  1 from BQ_YZDJFLK b(nolock)where b.jlzt = 0 and a.djfl = b.id))      
                     begin      
                      insert into  YY_ERROR      
                            select  getdate(), 'ҽ�����ݷ���' + convert(varchar(12), a.xh) + '1 ' + a.djfl      
                            from BQ_CQYZK a where syxh = @syxh and yzzt = 0 and not exists(select  1 from BQ_YZDJFLK b(nolock)where a.djfl = b.id)      
                            if @@error <> 0      
                      begin      
                       rollback tran      
                                select  'F', '����ҽ�����ݷ��������Ϣʱ����'      
                                return      
                      end      
                     end      
                    --���뵥�Զ����շѴ���    
     declare @result3 varchar(8),@msg3 ut_mc256    
     exec usp_his5_zyys_saveordercharge @wkdz=@wkdz,@jszt=3,@result=@result3 output,@msg=@msg3 output    
     if @result3='F'    
     begin    
     rollback tran     
     select @result3,@msg3    
     return    
     end    
                    commit tran     
                     --ҽ���պϲ���    
                    if exists(select 1 from CISSVR.CISDB.dbo.SYS_CONFIG where ID = 'HP457' and CONFIG = '��')    
                     Begin    
                     declare @hp361 ut_mc16    
                     select @hp361=CONFIG from CISSVR.CISDB.dbo.SYS_CONFIG where ID = 'HP361'    
                     declare @CurSor_Yzbh Cursor      
                     declare @nv5xh ut_xh12    
                     declare @nyzbz int--ҽ����־��1����0��ʱ    
                     declare @nypdm ut_xmdm  --ҩƷ����              
                     declare @ntzxh ut_xh12 --ֹͣҽ�����    
                     declare @nyzlb int --ҽ�����    
                     set @CurSor_Yzbh = Cursor for select v5xh,yzbz,tzxh,ypdm,yzlb from #yzk    
                     Open @CurSor_Yzbh    
                     Fetch Next From @CurSor_Yzbh into @nv5xh,@nyzbz,@ntzxh,@nypdm,@nyzlb    
                     While @@FETCH_STATUS = 0    
                     Begin    
                           if @nyzlb!=9--��ֹͣҽ���´�    
                           begin    
                            if @nyzbz=1--����ҽ��    
                              exec usp_his5_zyys_yzbhcz @syxh,@czyh,@nv5xh,@nyzbz,@ksdm,@bqdm,@ntzxh,@nypdm,0,@ksrq,1    
                            else --��ʱҽ��    
                              exec usp_his5_zyys_yzbhcz @syxh,@czyh,@nv5xh,@nyzbz,@ksdm,@bqdm,@ntzxh,@nypdm,0,@ksrq,1    
                           end    
                          if @nyzlb=9 and @hp361='��'--ֹͣҽ��ȡ����ҽ����Ϣ,������ȡ������ʱ���е���ʱҽ��    
                              exec usp_his5_zyys_yzbhcz @syxh,@czyh,@nv5xh,@nyzbz,@ksdm,@bqdm,@ntzxh,@nypdm,0,@ksrq,4    
                        Fetch Next From @CurSor_Yzbh into @nv5xh,@nyzbz,@ntzxh,@nypdm,@nyzlb    
          End    
                     CLose @CurSor_Yzbh    
                     Deallocate @CurSor_Yzbh    
                    End    
                --���ҽԺ���Ը�����Ҫ����, 
                    --����ſ��Ƿ�����Ϣ����ǰ����,��ʿվ�����������Ϣ���վͿ��Բ鿴��,������    
                    --������Ϣ����ǰ����    
                    declare @ksdm_curr ut_ksdm ,@bqdm_curr ut_ksdm,@hsdm ut_czyh,@ysmc ut_mc64,@send_msg varchar(100),@cwdm_cur ut_cwdm    
                    select top 1 @bqdm_curr = bq_id,@ysmc = name from YY_ZGBMK(nolock) where id = @ysdm    
                    select @bqdm_curr=bqdm from ZY_BRSYK (nolock) where syxh=@syxh    
                 select @cwdm_cur=CWDM from CISSVR.CISDB.dbo.CPOE_BRSYK where SYXH =@syxh and YEXH=@yexh    
                    select @send_msg = '��'+@cwdm_cur+'����ҽ����' + @ysmc + '���ѷ���ҽ��!'    
                    exec usp_yy_autosendmsg 2,@ysdm,'',@bqdm_curr,@send_msg    

                    declare @hp38 varchar(4)    
                    declare @hp347 varchar(4)    
                    declare @hp489 varchar(50)    
                    select @hp38= CONFIG from CISSVR.CISDB.dbo.SYS_CONFIG WHERE ID='HP38'    
                    select @hp347= CONFIG from CISSVR.CISDB.dbo.SYS_CONFIG WHERE ID='HP347'    
                    select @hp489= CONFIG from CISSVR.CISDB.dbo.SYS_CONFIG WHERE ID='HP489'    
                    ---����Ȩ    
                    declare @cfq varchar(4)                        
                    select @cfq= CONFIG from CISSVR.CISDB.dbo.SYS_USER_ATTRIB WHERE ZGDM=@czyh and (ROLE_CODE='0000' or ROLE_CODE='0001') and ID='0008'    
                     if((@hp347='��' and @cfq='��' and exists(select 1 from #yzk where yzbz = 0 and szyzbz = 1))    
                     or (@hp489<>'' and @cfq='��' and exists(select 1 from #yzk where yzbz=0 and szyzbz = 1 and yzlb in(select col from dbo.fun_Split(@hp489,',')) )))    
                    begin    
                          update a set a.shczyh = @czyh,a.shrq =@now     
                          from BQ_LSYZK a ,BQ_LSYZK_FZ b(nolock),SS_SSDJK c(nolock) ,#yzk d    
                          where a.syxh = @syxh and a.yexh=@yexh and a.syxh =b.syxh and a.yzzt=-2 and a.yzlb in (0,1,2,3,4,5,6,7,8) and a.zbybz in (0,1)     
                                and a.yzlb2=1 and a.xh=b.yzxh and b.ssxh=c.xh and a.v5xh=d.v5xh and d.szyzbz=1 and d.yzbz=0    
                          if @@error <> 0        
        begin        
        rollback tran        
        select  'F', '����ҽ���Զ����ʱ����'        
        return        
        end                
                    end    
                    if(@hp38='��' and @cfq='��')    
                         exec usp_bq_yzsh @syxh,@czyh,0,-1,0,@yexh,0,0    
                    --����ҽ��ִ��    
                    if(@hp489<>'' and @cfq='��' and exists(select 1 from #yzk where yzbz=0 and szyzbz = 1 and yzlb in(select col from dbo.fun_Split(@hp489,','))))    
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
              select  'F', '����ҽ���Զ�ִ�г���'        
              return        
               end    
              fetch CurSzyz into @ssksdm,@ssxh,@dyzfzxh    
           end    
          close CurSzyz      
                      deallocate CurSzyz     
      end      
--begin��Ժ��ҩ���⴦��add by winning-DSONG-chongqing on 20190705  
declare @cydy_bqdm varchar(16),@cydy_ksdm varchar(16)  
select @cydy_bqdm = bqdm, @cydy_ksdm = ksdm from ZY_BRSYK(nolock)where syxh = @syxh    
if EXISTS(SELECT  1 FROM BQ_LSYZK where syxh = @syxh and yexh=@yexh and yzlb=12 and yzzt=-2 and zbybz=0)  
BEGIN  
exec usp_his5_zyys_savecydy @syxh,@yexh,@czyh,@ysdm,@cydy_bqdm,@cydy_ksdm  
END    
--end��Ժ��ҩ���⴦��add by winning-DSONG-chongqing on 20190705  
                    select  'T3'      
                    end 






