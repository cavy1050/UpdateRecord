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
    @mzzybz VARCHAR(2) = NULL, --for 23218��22698 begin
    @rjssbz VARCHAR(2) = NULL,
    @mzfy VARCHAR(1) = NULL,
    @ssbfzdm VARCHAR(10) = NULL,
    @ssbfzmc VARCHAR(50) = NULL,
    @szblzdbm VARCHAR(10) = NULL,
    @szblzdmc VARCHAR(64) = NULL,
    @shblzdbm VARCHAR(10) = NULL,
    @shblzdmc VARCHAR(64) = NULL, --for 23218��22698 end
    --for �������¼��tabҳ  �����ֶ� by WQ
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
    @mjbz VARCHAR(2) = NULL, --�����־
    @mjff ut_mc32 = NULL, --�������
    @qjbh ut_mc32 = NULL, --ǻ�����
    @qjlx ut_mc32 = NULL, --ǻ������
    @wcbz ut_bz = NULL, --΢����־
    @wjssbz ut_bz = NULL, --�޾�������־
    @qxkssj ut_rq16 = NULL, --��ϴ��ʼʱ��  
    @qxjssj ut_rq16 = NULL, --��ϴ����ʱ��
    @qczrw ut_mc256 = NULL, --ȡ��ֲ����
    @qcsl CHAR(2) = NULL, --����
    @sxfy ut_mc64 = NULL, --��Ѫ��Ӧ
    @ssls ut_mc64 = NULL, --��������
    @qcfs VARCHAR(4) = NULL, --�г���ʽ   
    @sybz ut_bz = NULL, --��Һ��־ 
    @szcxcg ut_bz = NULL, --���г�Ѫ����1500ml 
    @zjkjyw ut_bz = NULL, --׷�ӿ���ҩ��
    @sszt VARCHAR(4) = NULL, --����״̬ -2'�˶�ͨ��'-1'����ǰ' 0'δ��ʼ' 1'������'2'������'3'����ȡ��'4'��������'5'�����ӳ�' 
    ---add wq for �����Ժ 2017-01-05  148209
    @xssmc ut_mc64 = NULL, --��������1
    @ssmc2 ut_mc64 = NULL, --��������2
    @ssmc3 ut_mc64 = NULL, --��������3
    @ssmc4 ut_mc64 = NULL, --��������4
    @ssmc5 ut_mc64 = NULL, --��������5
    --add wq for ��� 20170110  135972
    @shzdmc ut_mc64 = NULL, --������� 
    @shzdmc1 ut_mc64 = NULL, --�������1 
    @shzdmc2 ut_mc64 = NULL, --�������1 
    @shzdmc3 ut_mc64 = NULL, --�������1  
    @iszc INT = 0, --�Ƿ��ݴ�,0���ݴ�
    --add wq 
    @sxly ut_mc64 = NULL, --��Ѫ��Դ
    @xuanhong_ztx ut_mc64 = NULL, --����     
    @xj_ztx ut_mc64 = NULL, --Ѫ��     
    @xxb_ztx ut_mc64 = NULL, --ѪС��    
    @lcd_ztx ut_mc64 = NULL, --�����     
    @xuanhong_ytx ut_mc64 = NULL, --����     
    @xj_ytx ut_mc64 = NULL, --Ѫ��     
    @xxb_ytx ut_mc64 = NULL, --ѪС��     
    @lcd_ytx ut_mc64 = NULL, --�����     
    @sqsfsykjyw ut_mc64 = NULL, --��ǰ�Ƿ�ʹ�ÿ���ҩ��
    @zssj ut_rq16 = NULL, --��עʱ��
    @kjywmc ut_mc64 = NULL, --����ҩ��
    @fmzt ut_mc64 = NULL, --��������
    @ssrykssj ut_rq16 = NULL, --������Ա��ʼʱ��
    @ssryjssj ut_rq16 = NULL,  --������Ա����ʱ��
	--add by panjunyi for 319041
	@ssdjdm2 ut_dm2='', --�����ȼ�����2
	@ssdjdm3 ut_dm2='', --�����ȼ�����3
	@ssdjdm4 ut_dm2='', --�����ȼ�����4
	@ssdjdm5 ut_dm2='', --�����ȼ�����5
	@ssdj ut_dm2='', --�����ȼ�1
	@qkdj2 ut_mc32='',--�пڵȼ�2
	@qkdj3 ut_mc32='',--�пڵȼ�3
	@qkdj4 ut_mc32='',--�пڵȼ�4
	@qkdj5 ut_mc32='', --�пڵȼ�5
	@ssrq ut_mc32=NULL, --��������
	@xx1 ut_mc16=null, --Ѫ��
	@rh1 ut_mc16=null, --RH
	@xx2 ut_mc16=null, --Ѫ��
	@rh2 ut_mc16=null, --RH
	@blbb ut_mc16=NULL, --����걾
	@gd ut_mc16=NULL, --�ܵ�
	@ssylg ut_mc16=NULL, --����������
	@jbss ut_mc16=NULL, --�Ӱ�����
	@jrss ut_mc16=NULL, --��������
	@qcgj ut_mc16=NULL, --�Ƿ���ȡ������
	@sxgj ut_mc32=NULL, --�ڹ̶�ȡ�������蹤��
	@ngdzrw ut_mc16=NULL, --�ڹ̶�ֲ����
	@ngdzrwgs ut_mc16=NULL, --�ڹ̶�ֲ���﹫˾
	@sqdn ut_mc16=NULL, --��ǰ����
	@kjywdm ut_dm12=NULL, --��ǰ����ҩ�����
	@jl1 ut_mc16=NULL, --����1
	@jldw1 ut_mc16=NULL, -- ������λ1
	@sqyysj ut_mc16=NULL, --��ǰ��ҩʱ��
	@sqyycj ut_mc16=NULL, --��ǰ��ҩ����
	@zjkjywdm ut_dm12=NULL, --׷�ӿ���ҩ�����
	@zjkjywmc ut_mc64=NULL, --׷�ӿ���ҩ������
	@jl2 ut_mc16=NULL, --����2
	@jldw2 ut_mc16=NULL, --������λ2
	@szyysj ut_mc16=NULL, --������ҩʱ��
	@szyycj ut_mc16=NULL, --������ҩ����
	@sjyysj ut_rq16=NULL, --ʵ����ҩʱ��
	@qczrw1 ut_mc64=NULL, --ȡ��ֲ����
	@qczrwsl ut_mc16=NULL, --ȡ��ֲ��������
	@crbmc2 ut_mc32=NULL, --��Ⱦ��
	@kkss ut_mc16=NULL, --�������
	@yyzt ut_mc16=NULL, --��ҩ״̬
	@wqzj ut_mc16=NULL, --����ר��
	@ssmc6 ut_ssmc=NULL, --��������6
	@ssmc7 ut_ssmc=NULL, --��������7
	@ssmc8 ut_ssmc=NULL, --��������8
	@ssmc9 ut_ssmc=NULL, --��������9
	@ssmc10 ut_ssmc=NULL, --��������10
	@ssmc11 ut_ssmc=NULL, --��������11
	@ssmc12 ut_ssmc=NULL, --��������12
	@ssmc13 ut_ssmc=NULL, --��������13
	@ssmc14 ut_ssmc=NULL, --��������14
	@ssmc15 ut_ssmc=NULL, --��������15
	@ssdm6 ut_xmdm='', --��������6
	@ssdm7 ut_xmdm='', --��������7
	@ssdm8 ut_xmdm='', --��������8
	@ssdm9 ut_xmdm='', --��������9
	@ssdm10 ut_xmdm='', --��������10
	@ssdm11 ut_xmdm='', --��������11
	@ssdm12 ut_xmdm='', --��������12
	@ssdm13 ut_xmdm='', --��������13
	@ssdm14 ut_xmdm='', --��������14
	@ssdm15 ut_xmdm='', --��������15
	@sszc1 VARCHAR(1)='', --��������1
	@sszc2 VARCHAR(1)='', --��������2
	@sszc3 VARCHAR(1)='', --��������3
	@sszc4 VARCHAR(1)='', --��������4
	@sszc5 VARCHAR(1)='', --��������5
	@sszc6 VARCHAR(1)='', --��������6
	@sszc7 VARCHAR(1)='', --��������7
	@sszc8 VARCHAR(1)='', --��������8
	@sszc9 VARCHAR(1)='', --��������9
	@sszc10 VARCHAR(1)='', --��������10
	@sszc11 VARCHAR(1)='', --��������11
	@sszc12 VARCHAR(1)='', --��������12
	@sszc13 VARCHAR(1)='', --��������13
	@sszc14 VARCHAR(1)='', --��������14
	@sszc15 VARCHAR(1)='', --��������15
	@ssys ut_mc64=NULL, --����ҽ��
	@sshs ut_mc64=NULL, --������ʿ
	@lrczyxm ut_mc16=NULL, -- ¼�����Ա����
	@sfcs ut_mc16=NULL, --�Ƿ�ʱ
	@qcfs2 ut_mc64=NULL,--�г���ʽ2
	--add for 34996 40177
	@hzzy ut_mc16=NULL, --����ת��
	@ssfy ut_mc16=NULL, --��������
	@qkqk ut_mc16=NULL, --�п����
	@ywzqtys ut_mc16=NULL, --����֪��ͬ����
	@ywsqxj ut_mc16=NULL, --������ǰС��
	@ywssbwbs ut_mc16=NULL, --����������λ��ʶ
	@ssbwsfzq ut_mc16=NULL, --������λ�Ƿ���ȷ
	@sfhg ut_mc16=NULL, --�Ƿ�ϸ�
	@jcr ut_mc16=NULL, --�����
	@jjss ut_bz=NULL, --��������
	@xqss ut_bz=NULL, --��������
	@sqfs ut_mc16=NULL, --��ǰ����
	@aqjc ut_mc16=NULL --��ȫ���
AS
    /**********
[�汾��]4.0.0.0.0
[����ʱ��]2004.12.06
[����]��ΰ��
[��Ȩ] Copyright ? 2004-2008�Ϻ����˴�-��������ɷ����޹�˾[����]  �������¼��
[����˵��]
	�������¼��(����������Ա��������ϡ��������)
[����˵��]
	@wkdz		������ַ
	@jszt 		����״̬	1=������2=���룬3=�ݽ�
	@czyh 		����Ա��
	@ssxh 		�������
	@ssdm 		ʵ����������
	@mzdm 		ʵ���������
	@shzd 		�������
	@shzd1 		�������1
	@shzd2 		�������2
	@shzd3 		�������3
	@ksrq		��ʼʱ��
	@jsrq 		����ʱ��
	@bqsm 		����˵��
	@glbz 		�����־��0������1���룬2���䣩
    @slbz           ˳����־��0˳����1��˳����
	@qkdj 		�пڵȼ�
	@rydm 		ҽ������
	@rylb 		ҽ�����
    @ssdjdm         �����ȼ����� 
    @sfsx           �Ƿ���Ѫ ��0����  1�����룩
    @sqsfyy         ��ǰ�Ƿ���ҩ��0�ǡ�1��
    @kjyw            ����ҩ� 0Ԥ����1���ơ�2Ԥ��+���ƣ�
    @isjb ut_bz =null �Ƿ�Ӱ�
	@isqj iu_bz =null �Ƿ�����
	@ssgl ut_dm4 �����Զ������    

[����ֵ]

[�����������]
	�ɹ���"T"
	����"F","������Ϣ"


[���õ�sp]

[����ʵ��]

**********/
    SET NOCOUNT ON;

    --���ɵݽ�����ʱ��
    DECLARE @tablename VARCHAR(32);
    SELECT @tablename = '##ssqklr' + @wkdz;
    DECLARE @config8262 VARCHAR(20),
            @config8264 VARCHAR(20);
    SELECT @config8262 = LTRIM(RTRIM(config))
      FROM YY_CONFIG
     WHERE id = '8262'; --���������޸ĺ��Ƿ��̨����                   
    SELECT @config8264 = LTRIM(RTRIM(config))
      FROM YY_CONFIG
     WHERE id = '8264'; --�������¼��������������޸ĺ��Ƿ��̨����       
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
                   '������ʱ��ʱ����';
            RETURN;
        END;

    END;
    --����ݽ��ļ�¼
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
                   '������ʱ��ʱ����';
            RETURN;
        END;
    END;

    IF @jszt = 1
    OR @jszt = 2
    BEGIN
        SELECT 'T';
        RETURN;
    END;

    --��ʼ��������
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
               '������ʱ��ʱ����';
        RETURN;
    END;
    EXEC ('drop table ' + @tablename);

    DECLARE @now  ut_rq16,
            @syxh ut_xh12,
            @mzmc ut_mc32, --��������
            @yzxh ut_xh12;

    SELECT @now = CONVERT(VARCHAR(8), GETDATE(), 112) + CONVERT(VARCHAR(8), GETDATE(), 8);

    IF @config8262 <> '��'
    BEGIN
        SELECT @xssmc = name
          FROM SS_SSMZK
         WHERE id = @xssdm
           AND lb = 0;
        IF @@rowcount = 0
        BEGIN
            SELECT 'F',
                   '����1�����ڣ�';
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
                       '����2�����ڣ�';
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
                       '����3�����ڣ�';
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
                       '����4�����ڣ�';
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
                       '����5�����ڣ�';
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
               '�����������ڣ�';
        RETURN;
    END;

    BEGIN TRANSACTION;

    /*���������Ǽǿ�*/
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
                   qxkssj = @qxkssj, --��ϴ��ʼʱ��
                   qxjssj = @qxjssj, --��ϴ����ʱ��
                   qczrw = @qczrw, --ȡ��ֲ����
                   qcsl = @qcsl, --����
                   sxfy = @sxfy, --��Ѫ��Ӧ
                   ssls = @ssls, --�������� 
                   qcfs = @qcfs, --�г���ʽ 
                   qcfs2 = @qcfs2, --�г���ʽ2
                   sybz = @sybz, --��Һ��־
                   sszt = @sszt,
                   sxly = @sxly, --��Ѫ��Դ
                   xuanhong = @xuanhong_ztx, --����     
                   xj = @xj_ztx, --Ѫ��     
                   xxb = @xxb_ztx, --ѪС��     
                   lcd = @lcd_ztx, --�����     
                   xuanhong2 = @xuanhong_ytx, --����     
                   xj2 = @xj_ytx, --Ѫ��     
                   xxb2 = @xxb_ytx, --ѪС��     
                   lcd2 = @lcd_ytx, --�����
                   sqsfsykjyw = @sqsfsykjyw, --��ǰ�Ƿ�ʹ�ÿ���ҩ��
                   zssj = @zssj, --��עʱ��
                   kjywmc = @kjywmc, --����ҩ��
                   fmzt = @fmzt, --��������
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
                                     shblzdmc, --for 23218��22698
                                     mzff2,
                                     mzsb,
                                     sqhz,
                                     shsf,
                                     ttmz,
                                     mzsg,
                                     hyz,
                                     mzcc,
                                     mzh,
                                     jkxx, --for�������¼��tabҳ �����ֶ�  
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
                    @shblzdmc, --for 23218��22698
                    @mzff2,
                    @mzsb,
                    @sqhz,
                    @shsf,
                    @ttmz,
                    @mzsg,
                    @hyz,
                    @mzcc,
                    @mzh,
                    @jkxx, --for�������¼��tabҳ �����ֶ�
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
                   mzzybz = @mzzybz, --for 23218��22698 begin
                   rjssbz = @rjssbz,
                   mzfy = @mzfy,
                   ssbfzdm = @ssbfzdm,
                   ssbfzmc = @ssbfzmc,
                   szblzdbm = @szblzdbm,
                   szblzdmc = @szblzdmc,
                   shblzdbm = @shblzdbm,
                   shblzdmc = @shblzdmc, --for 23218��22698 end
                   mzff2 = @mzff2, --for 113237
                   szcxcg = @szcxcg, --���г�Ѫ����1500ml 
                   zjkjyw = @zjkjyw, --׷�ӿ���ҩ�� 
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
                   qxkssj = @qxkssj, --��ϴ��ʼʱ��
                   qxjssj = @qxjssj, --��ϴ����ʱ��
                   qczrw = @qczrw, --ȡ��ֲ����
                   qcsl = @qcsl, --����
                   sxfy = @sxfy, --��Ѫ��Ӧ
                   ssls = @ssls, --�������� 
                   qcfs = @qcfs, --�г���ʽ 
                   qcfs2 = @qcfs2, --�г���ʽ 2 
                   sybz = @sybz, --��Һ��־
                   sszt = @sszt,
                   sxly = @sxly, --��Ѫ��Դ
                   xuanhong = @xuanhong_ztx, --����    
                   xj = @xj_ztx, --Ѫ��    
                   xxb = @xxb_ztx, --ѪС��    
                   lcd = @lcd_ztx, --�����    
                   xuanhong2 = @xuanhong_ytx, --����    
                   xj2 = @xj_ytx, --Ѫ��    
                   xxb2 = @xxb_ytx, --ѪС��    
                   lcd2 = @lcd_ytx, --�����    
                   sqsfsykjyw = @sqsfsykjyw, --��ǰ�Ƿ�ʹ�ÿ���ҩ��
                   zssj = @zssj, --��עʱ��
                   kjywmc = @kjywmc, --����ҩ��
                   fmzt = @fmzt, --��������
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
                                     shblzdmc, --for 23218��22698
                                     mzff2,
                                     mzsb,
                                     sqhz,
                                     shsf,
                                     ttmz,
                                     mzsg,
                                     hyz,
                                     mzcc,
                                     mzh,
                                     jkxx, --for�������¼��tabҳ �����ֶ�  39988
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
                    @shblzdmc, --for 23218��22698
                    @mzff2,
                    @mzsb,
                    @sqhz,
                    @shsf,
                    @ttmz,
                    @mzsg,
                    @hyz,
                    @mzcc,
                    @mzh,
                    @jkxx, --for�������¼��tabҳ �����ֶ�  39988
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
                   mzzybz = @mzzybz, --for 23218��22698 begin
                   rjssbz = @rjssbz,
                   mzfy = @mzfy,
                   ssbfzdm = @ssbfzdm,
                   ssbfzmc = @ssbfzmc,
                   szblzdbm = @szblzdbm,
                   szblzdmc = @szblzdmc,
                   shblzdbm = @shblzdbm,
                   shblzdmc = @shblzdmc, --for 23218��22698 end
                   mzff2 = @mzff2, --for 113237
                   szcxcg = @szcxcg, --���г�Ѫ����1500ml 
                   zjkjyw = @zjkjyw, --׷�ӿ���ҩ��
				   jjss = @jjss,
				   xqss = @xqss
             WHERE ssxh = @ssxh;
        END;
    END;

    IF @@error <> 0
    BEGIN
        ROLLBACK TRANSACTION;
        SELECT 'F',
               '������¼����';
        RETURN;
    END;

    /*��¼�������*/
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
                   '��¼������ϳ���!';
            RETURN;
        END;
        IF @config8264 <> '��'
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
                   '��¼������ϳ���!';
            RETURN;
        END;
    END;

    IF @shzd1 IS NOT NULL
    OR LTRIM(RTRIM(@shzd1)) <> ''
    BEGIN
        IF @config8264 <> '��'
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
                   '��¼�������1����!';
            RETURN;
        END;
    END;

    IF @shzd2 IS NOT NULL
    OR LTRIM(RTRIM(@shzd2)) <> ''
    BEGIN
        IF @config8264 <> '��'
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
                   '��¼�������2����!';
            RETURN;
        END;
    END;

    IF @shzd3 IS NOT NULL
    OR LTRIM(RTRIM(@shzd3)) <> ''
    BEGIN
        IF @config8264 <> '��'
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
                   '��¼�������3����!';
            RETURN;
        END;
    END;

    DELETE SS_SSRYK
     WHERE ssxh = @ssxh;
    IF @@error <> 0
    BEGIN
        SELECT 'F',
               '¼��������Աʱ����';
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
               '¼��������Աʱ����';
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
               '������¼ʱ����';
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    COMMIT TRAN;
    SELECT 'T';


GO