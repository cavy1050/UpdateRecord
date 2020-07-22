ALTER PROCEDURE [dbo].[statisticBB_yygzbb2]
    @fyydmstr VARCHAR(100) ,
    @freportdatestr VARCHAR(100) ,    --��������
    @ftykh VARCHAR(30) ,--ͳһ�ƺ�
    @dateType TINYINT ,    --��������,1Ϊ"�±�"��2Ϊ"����"��3Ϊ"�걨"��4Ϊ"����ʽ" , 5Ϊ"Ժ���ñ�" 
    @ftyyhbh VARCHAR(30) ,    --ͳһ�û����
    @fusername VARCHAR(30) ,    --�û�����
    @date1 DATETIME ,    --���ܵ���ʼ���� '2008-01-01'
    @date2 DATETIME ,    --���ܵ���ֹ���� '2008-01-01'
    @calendarDay INT = 31 ,    --��������
    @workDay INT = 31 ,    --��������
    @week INT = 4 ,    --����
    @zjerrcode TINYINT OUT ,     --������Ϣ
    @zjerrmsg VARCHAR(200) OUT    --��������     
AS --2.�ڲ���������

    DECLARE @freportcode VARCHAR(100) --��Ӧtmzreportmain�е�freportcode,������ 
    set  @freportcode = 'bb_yygzbb2'
    DECLARE @zySQL VARCHAR(6000)

	
	--������ʱ��
    SELECT  FREPORTCODE ,
            FREPORTDATESTR ,
            FTYKH ,
            FPX ,
            FKSNAME ,
            FENDBED ,
            FBEGIN ,
            FIN ,
            FTRANSFERIN ,
            FOUT ,
            FOUTYZLY ,
            FOUTYZZY ,
            FOUTSQXZ ,
            FOUTFYZLY ,
            FOUTSW ,
            FOUTOTHER ,
            FTRANSFEROUT ,
            FEND ,
            FSJKFZCRS ,
            FSJZYZCRS ,
            FPJKFCWS ,
            FCYZZYZCRS ,
            FBSL ,
            FBCZZCS ,
            FPJBCGZR ,
            FBCSYL ,
            FCYZPJZYR ,
            FSSRS ,
            NULL AS FAVERBEDS ,
            NULL AS FCAL ,
            fyydmstr
    INTO    #bb_yygzbb2
    FROM    bb_yygzbb2
    WHERE   1 = 2
    ALTER TABLE #bb_yygzbb2 ADD FRS INT	
		
    IF ( @datetype = 1 )
        OR ( @datetype = 5 ) 
        BEGIN
		--1:��������
            INSERT  INTO #bb_yygzbb2
                    ( FREPORTCODE ,
                      FREPORTDATESTR ,
                      FTYKH ,
                      FKSNAME ,
                      fpx
                    )
                    SELECT  @freportcode ,
                            @freportdatestr ,
                            ftykh ,
                            REPLICATE(' ', fblanks) + fksname ,
                            fpx
                    FROM    tworkroom
                    WHERE   ftype = 2
                            AND fifstat = 1
                            AND FKH = 'QY'
            INSERT  INTO #bb_yygzbb2
                    ( FREPORTCODE ,
                      FREPORTDATESTR ,
                      FTYKH ,
                      FKSNAME ,
                      fpx
                    )
                    SELECT  @freportcode ,
                            @freportdatestr ,
                            ftykh ,
                            REPLICATE(' ', fblanks) + fksname ,
                            fpx
                    FROM    tworkroom
                    WHERE   ftype = 2
                            AND fifstat = 1
                            AND fyydm = @fyydmstr 
   
            UPDATE  #bb_yygzbb2
            SET     fyydmstr = @fyydmstr

            UPDATE  #bb_yygzbb2
            SET     FTYKH = 'Z020803'
            WHERE   FTYKH = 'Z020308'
            UPDATE  #bb_yygzbb2
            SET     FTYKH = 'Z051602'
            WHERE   FTYKH = 'Znew9'
            SELECT  *
            INTO    #TZYWARDWORKLOG
            FROM    TZYWARDWORKLOG
            WHERE   FRQ >= @date1
                    AND FRQ < @date2

            UPDATE  #TZYWARDWORKLOG
            SET     FTYKH = 'Z020803'
            WHERE   FTYKH = 'Z020308'
 
		--2:ͳ������
		/*
		update #bb_yygz
bb2 set 
			FBEGIN=FQCRS from #bb_yygzbb2 a,XZY_ZYSJ b where frq=@date1 and a.FTYKH=b.FKSDM   --ԭ��
		
		update #bb_yygzbb2 set 
			FBEGIN=b.FEND from #bb_yygzbb2 a,bb_yygzbb2 b where  a.FTYKH=b.FTYKH and b.FREPORTDATESTR= convert(varchar(7),dateadd(MM,-1,
@date1),120) and a.FTYKH<>'TZYQY'  --ԭ��

	*/
            UPDATE  #bb_yygzbb2
            SET     FBEGIN = FYRS
            FROM    #bb_yygzbb2 a ,
                    #TZYWARDWORKLOG b
            WHERE   frq = @date1
                    AND a.FTYKH = b.FTYKH   --ԭ��

            UPDATE  #bb_yygzbb2
            SET     FENDBED = ( SELECT TOP 1
                                        FBEDSUM
                                FROM    #TZYWARDWORKLOG
                                WHERE   CONVERT(VARCHAR(10), frq, 120) = ( SELECT
                                                              MAX(CONVERT(VARCHAR(10), frq, 120))
                                                              FROM
                                                              #TZYWARDWORKLOG
                                                              WHERE
                                                              frq >= @date1
                                                              AND frq < @date2
                                                              )
                                        AND FTYKH = #bb_yygzbb2.FTYKH
                              )
            UPDATE  #bb_yygzbb2
            SET     FIN = FRYRS ,
                    FTRANSFERIN = FTKZR ,
                    FTRANSFEROUT = FZRTK ,
                    FEND = FXYRS
            FROM    #bb_yygzbb2 a ,
                    ( SELECT    FTYKH ,
                                SUM(FRYRS) AS FRYRS ,
                                SUM(FTKZR) AS FTKZR ,
                                SUM(FZRTK) AS FZRTK ,
                                SUM(FXYRS) AS FXYRS
                      FROM      #TZYWARDWORKLOG
                      WHERE     FRQ >= @date1
                                AND FRQ < @date2
                      GROUP BY  FTYKH
                    ) b
            WHERE   a.FTYKH = b.FTYKH

            UPDATE  #bb_yygzbb2
            SET     FSJKFZCRS = FSJ
            FROM    #bb_yygzbb2 a ,
                    ( SELECT    FKSDM ,
                                SUM(CONVERT(INT, FSJ)) FSJ
                      FROM      XZY_ZYSJ
                      WHERE     FRQ >= @date1
                                AND FRQ < @date2
                      GROUP BY  FKSDM
                    ) b
            WHERE   a.FTYKH = b.FKSDM --ʵ�ʿ��Ŵ�λ��
	
            UPDATE  #bb_yygzbb2
            SET     FSJZYZCRS = a.FXYRS
            FROM    ( SELECT    FTYKH ,
                                SUM(FXYRS) AS FXYRS
                      FROM      #TZYWARDWORKLOG
                      WHERE     FRQ >= @date1
                                AND FRQ < @date2
                      GROUP BY  FTYKH
                    ) a
            WHERE   #bb_yygzbb2.FTYKH = a.FTYKH
            UPDATE  #bb_yygzbb2
            SET     FEND = FBEGIN + FIN + FTRANSFERIN - FOUT - FTRANSFEROUT

            UPDATE  #bb_yygzbb2
            SET     Fout = nums ,
                    FOUTYZLY = t.FBest ,
                    FOUTYZZY = t.FOUTYZZY ,
                    FOUTSQXZ = t.FOUTSQXZ ,
                    FOUTFYZLY = t.FOUTFYZLY ,
                    FOUTSW = t.FOUTSW ,
                    FOUTOTHER = t.FOUTOTHER ,
                    FCYZZYZCRS = t.DayTotal ,
                    FRS = t.FRS
            FROM    ( SELECT    FCYTYKH ,
                                COUNT(*) AS nums ,
                                SUM(FDAYS) AS DayTotal ,     --��Ժ����Ժ��ռ���ܴ�����
                                SUM(CASE WHEN FLYFSBH = '1' THEN 1
                                         ELSE 0
                                    END) AS FBest ,   --ҽ����Ժ
                                SUM(CASE WHEN FLYFSBH = '2' THEN 1
                                         ELSE 0
                                    END) AS FOUTYZZY , --ҽ��תԺ
                                SUM(CASE WHEN FLYFSBH = '3' THEN 1
                                         ELSE 0
                                    END) AS FOUTSQXZ ,    --ת��������ҽ�ƻ���/��������Ժ
                                SUM(CASE WHEN FLYFSBH = '4' THEN 1
                      ELSE 0
                                    END) AS FOUTFYZLY ,   --��ҽ����Ժ
                                SUM(CASE WHEN FLYFSBH = '5' THEN 1
                                         ELSE 0
                                    END) AS FOUTSW ,  --����
                                SUM(CASE WHEN FLYFSBH = '9' THEN 1
                                         ELSE 0
                                    END) AS FOUTOTHER , --����
                                SUM(CASE WHEN fcydate = frydate THEN 1
                                         ELSE 0
                                    END) AS FRS --�������Ժ
                      FROM      HIS_BA1
                      WHERE     fcydate >= @Date1
                                AND fcydate < @date2 and fyydm=@fyydmstr
		--and FCYDEPT not like '�󹫹�%' and  FCYDEPT not like '��ˮ%' and  FCYDEPT not like '������%'and  FCYDEPT not like '�����%'
                      GROUP BY  FCYTYKH
                    ) t
            WHERE   #bb_yygzbb2.FTYKH = t.FCYTYKH

            UPDATE  #bb_yygzbb2
            SET     Fout = nums ,
                    FOUTYZLY = t.FBest ,
                    FOUTYZZY = t.FOUTYZZY ,
                    FOUTSQXZ = t.FOUTSQXZ ,
                    FOUTFYZLY = t.FOUTFYZLY ,
                    FOUTSW = t.FOUTSW ,
                    FOUTOTHER = t.FOUTOTHER ,
                    FCYZZYZCRS = t.DayTotal ,
                    FRS = t.FRS
            FROM    ( SELECT    FCYTYKH ,
                                COUNT(*) AS nums ,
                                SUM(FDAYS) AS DayTotal ,     --��Ժ����Ժ��ռ���ܴ�����
                                SUM(CASE WHEN FLYFSBH = '1' THEN 1
                                         ELSE 0
                                    END) AS FBest ,   --ҽ����Ժ
                                SUM(CASE WHEN FLYFSBH = '2' THEN 1
                                         ELSE 0
                                    END) AS FOUTYZZY , --ҽ��תԺ
                                SUM(CASE WHEN FLYFSBH = '3' THEN 1
                                         ELSE 0
                                    END) AS FOUTSQXZ ,    --ת��������ҽ�ƻ���/��������Ժ
                                SUM(CASE WHEN FLYFSBH = '4' THEN 1
                                         ELSE 0
                                    END) AS FOUTFYZLY ,   --��ҽ����Ժ
                                SUM(CASE WHEN FLYFSBH = '5' THEN 1
                                         ELSE 0
                                    END) AS FOUTSW ,  --����
                                SUM(CASE WHEN FLYFSBH = '9' THEN 1
                                         ELSE 0
                                    END) AS FOUTOTHER , --����
                                SUM(CASE WHEN fcydate = frydate THEN 1
                                         ELSE 0
                                    END) AS FRS --�������Ժ
                      FROM      HIS_BA1
                      WHERE     fcydate >= @Date1
                                AND fcydate < @date2
                                AND FCYTYKH = 'Z020308'
                      GROUP BY  FCYTYKH
                    ) t
            WHERE   #bb_yygzbb2.FTYKH = 'Z020803'
	    
		--update #bb_yygzbb2 set FOUTYZLY=FOUT-FOUTYZZY-FOUTSQXZ-FOUTFYZLY-FOUTSW-FOUTOTHER
            UPDATE  #bb_yygzbb2
            SET     FSJZYZCRS = FSJZYZCRS + FRS
            FROM    #bb_yygzbb2 a
            UPDATE  #bb_yygzbb2
            SET     FSSRS = ISNULL(b.ssrs, 0)
            FROM    #bb_yygzbb2 a ,
                    ( SELECT    'Z' + ksdm ksdm ,
                                SUM(sz1) ssrs
                      FROM      [172.20.0.43\LIS].THIS_BAGL.dbo.BA_TJSJ
                      WHERE     sjlb = 6
                                AND tjrq BETWEEN CONVERT(VARCHAR(20), @date1, 112)
                                         AND     CONVERT(VARCHAR(20), DATEADD(dd,
                                                              -1, @date2), 112)
                                AND kslb = 1
                                AND yydm = '01'
                      GROUP BY  ksdm
                    ) b
            WHERE   a.FTYKH = b.ksdm
		--update #bb_yygzbb2 set FSJKFZCRS = a.FSJKFZCRS FROM(
		--	select sum(convert(int,FSJ)) as FSJKFZCRS,FKSDM from (select DISTINCT FKSDM,FSJ,frq from XZY_ZYSJ where FRQ>=@date1 and FRQ<@date2) aa GROUP BY aa.FKSDM)a where #bb_yygzbb2.FTYKH = a.FKSDM
	

	
	--20191209LLL
	--ʵ��ռ���ܴ�����
            UPDATE  #bb_yygzbb2
            SET     FSJZYZCRS = a.FXYRS
            FROM    ( SELECT    FTYKH ,
                                SUM(FXYRS) AS FXYRS
                      FROM      #TZYWARDWORKLOG
                      WHERE     FRQ >= @date1
                                AND FRQ < @date2
                      GROUP BY  FTYKH
                    ) a
            WHERE   #bb_yygzbb2.FTYKH = a.FTYKH
			--select sum(FXYRS) as FXYRS from TZYWARDWORKLOG where FRQ>='20191101' and FRQ<'20191201' AND FTYKH='Z020308' 
						/*
						
						update #bb_yygzbb2 set Fout= a.FCYRS from (
						 select FTYKH,sum(FCYRS) as FCYRS from #TZYWARDWORKL
OG where FRQ>=@date1 and FRQ<@date2 group by FTYKH 
			) a where #bb_yygzbb2.FTYKH = a.FTYKH
			*/
				--update #bb_yygzbb2 set FOUTYZLY=FOUT-FOUTYZZY-FOUTSQXZ-FOUTFYZLY-FOUTSW-FOUTOTHER
	
		
		--3:��������
		
            UPDATE  #bb_yygzbb2
            SET     FBSL = CASE FOUT
                             WHEN 0 THEN 0
                             ELSE CONVERT(NUMERIC(9, 1), FOUTSW / FOUT * 100)
                           END ,
                    FBCZZCS = CASE FENDBED
                                WHEN 0 THEN 0
                                ELSE CONVERT(NUMERIC(9, 1), FOUT / FENDBED)
                              END ,
                    FPJBCGZR = CASE FENDBED
                                 WHEN 0 THEN 0
                                 ELSE CONVERT(NUMERIC(9, 1), FSJZYZCRS
                                      / FENDBED)
                               END ,
                    FBCSYL = CASE FSJKFZCRS
                               WHEN 0 THEN 0
                               ELSE CONVERT(NUMERIC(9, 1), FSJZYZCRS
                                    / FSJKFZCRS)
                             END ,
                    FCYZPJZYR = CASE FOUT
                                  WHEN 0 THEN 0
                                  ELSE CONVERT(NUMERIC(9, 1), FCYZZYZCRS
                                       / FOUT)
                                END ,
                    FPJKFCWS = CONVERT(NUMERIC(9, 1), FSJKFZCRS / @calendarDay)

            UPDATE  #bb_yygzbb2
            SET     FEND = FBEGIN + FIN + FTRANSFERIN - FOUT - FTRANSFEROUT
            SELECT  *
            INTO    #bb_yygzbb2_total
            FROM    #bb_yygzbb2



	--4������ӵ�й�ʽ�Ŀ���
		--declare @tykh varchar(30),@Cal varchar(3000)
		--declare Cursor1 Cursor for 
		--select ftykh,fCal from  #bb_yygzbb2_total where FTYKH <> fcal
		--open Cursor1
		--fetch Cursor1 into @tykh,@Cal
		--while @@fetch_status = 0 
		--begin  



		--	set @zySQL='update #bb_yygzbb2 set FENDBED=t.FENDBED,FBEGIN=t.FBEGIN,FIN=t.FIN,FTRANSFERIN=t.FTRANSFERIN,FOUT=t.FOUT,FOUTBEST=t.FOUTBEST,FOUTBETTER=t.FOUTBETTER,
		--	FOUTBAD=t.FOUTBAD,FOUTDEAD=t.FOUTDEAD,FOUTOTHER=t.FOUTOTHER,FTRANSFEROUT=t.FTRANSFEROUT,FEND=t.FEND,FOUTBEDDAY=t.FOUTBEDDAY,FREALBEDS=t.FREALBEDS,
		--	FREALBEDDAY=t.FREALBEDDAY,FBESTPER=t.FBESTPER,FBETTERPER=t.FBETTERPER,FDEADPER=t.FDEADPER,FBEDUSEPER=t.FBEDUSEPER,FBEDWEEkUSE=t.FBEDWEEkUSE,
		--	FAVERDAYIN=t.FAVERDAYIN,FBEDDAY=t.FBEDDAY from (
		--	select sum(isnull(FENDBED,0)) FENDBED,sum(isnull(FBEGIN,0)) FBEGIN,sum(isnull(FIN,0)) FIN,sum(isnull(FTRANSFERIN,0)) FTRANSFERIN,sum(isnull(FOUT,0)) FOUT,sum(isnull(FOUTBEST,0)) FOUTBEST,sum(isnull(FOUTBETTER,0)) FOUTBETTER,
		--	sum(isnull(FOUTBAD,0)) FOUTBAD,sum(isnull(FOUTDEAD,0)) FOUTDEAD,sum(isnull(FOUTOTHER,0)) FOUTOTHER,sum(isnull(FTRANSFEROUT,0))
		--	FTRANSFEROUT,sum(isnull(FEND,0)) FEND,sum(isnull(FOUTBEDDAY,0)) FOUTBEDDAY,sum(isnull(FREALBEDS,0)) FREALBEDS,
		--	sum(isnull(FREALBEDDAY,0)) FREALBEDDAY,sum(isnull(FBESTPER,0)) FBESTPER,sum(isnull(FBETTERPER,0)) FBETTERPER,sum(isnull(FDEADPER,0)) FDEADPER,sum(isnull(FBEDUSEPER,0)) FBEDUSEPER,sum(isnull(FBEDWEEkUSE,0)) FBEDWEEkUSE,sum(isnull(FAVERDAYIN,0)) FAVERDAYIN,sum(isnull(FBEDDAY,0)) FBEDDAY 
		--	from #bb_yygzbb2_total a where a.FTYKH in '+dbo.TransStrQuoted(@Cal)+') t
  --          where FTYKH = '''+@tykh+'''' 
		--	exec(@zySQL)   
		--	fetch Cursor1 into @tykh,@Cal
		--end
		--close Cursor1
		--deallocate Cursor1


            UPDATE  #bb_yygzbb2
            SET     FENDBED = t.FENDBED ,
                    FBEGIN = t.FBEGIN ,
                    FIN = t.FIN ,
                    FTRANSFERIN = t.FTRANSFERIN ,
                    FOUT = t.FOUT ,
                    FOUTYZLY = t.FOUTYZLY ,
                    FOUTYZZY = t.FOUTYZZY ,
                    FOUTSQXZ = t.FOUTSQXZ ,
                    FOUTFYZLY = t.FOUTFYZLY ,
                    FOUTSW = t.FOUTSW ,
                    FOUTOTHER = t.FOUTOTHER ,
                    FTRANSFEROUT = t.FTRANSFEROUT ,
                    FEND = t.FEND ,
                    FSJKFZCRS = t.FSJKFZCRS ,
                    FSJZYZCRS = t.FSJZYZCRS ,
                    FPJKFCWS = t.FPJKFCWS ,
                    FCYZZYZCRS = t.FCYZZYZCRS ,
                    FBSL = t.FBSL ,
                    FBCZZCS = t.FBCZZCS ,
                    FPJBCGZR = t.FPJBCGZR ,
                    FCYZPJZYR = t.FCYZPJZYR ,
                    FSSRS = t.FSSRS
            FROM    ( SELECT    SUM(ISNULL(FENDBED, 0)) FENDBED ,
                                SUM(ISNULL(FBEGIN, 0)) FBEGIN ,
                                SUM(ISNULL(FIN, 0)) FIN ,
                                SUM(ISNULL(FTRANSFERIN, 0)) FTRANSFERIN ,
                                SUM(ISNULL(FOUT, 0)) FOUT ,
                                SUM(ISNULL(FOUTYZLY, 0)) FOUTYZLY ,
                                SUM(ISNULL(FOUTYZZY, 0)) FOUTYZZY ,
                                SUM(ISNULL(FOUTSQXZ, 0)) FOUTSQXZ ,
                                SUM(ISNULL(FOUTFYZLY, 0)) FOUTFYZLY ,
                                SUM(ISNULL(FOUTSW, 0)) FOUTSW ,
                                SUM(ISNULL(FOUTOTHER, 0)) FOUTOTHER ,
                                SUM(ISNULL(FTRANSFEROUT, 0)) FTRANSFEROUT ,
                                SUM(ISNULL(FEND, 0)) FEND ,
                                SUM(ISNULL(FSJKFZCRS, 0)) FSJKFZCRS ,
                                SUM(ISNULL(FSJZYZCRS, 0)) FSJZYZCRS ,
                                SUM(ISNULL(FPJKFCWS, 0)) FPJKFCWS ,
                                SUM(ISNULL(FCYZZYZCRS, 0)) FCYZZYZCRS ,
                                SUM(ISNULL(FBSL, 0)) FBSL ,
                                SUM(ISNULL(FBCZZCS, 0)) FBCZZCS ,
                                SUM(ISNULL(FPJBCGZR, 0)) FPJBCGZR ,
                                SUM(ISNULL(FCYZPJZYR, 0)) FCYZPJZYR ,
                                SUM(ISNULL(FSSRS, 0)) FSSRS
                      FROM      #bb_yygzbb2_total
                    ) t
            WHERE   FTYKH = 'TZYQY'
	
		--5:�������
            UPDATE  #bb_yygzbb2
            SET     FENDBED = ISNULL(FENDBED, 0) ,
                    FBEGIN = ISNULL(FBEGIN, 0) ,
                    FIN = ISNULL(FIN, 0) ,
                    FTRANSFERIN = ISNULL(FTRANSFERIN, 0) ,
                    FOUT = ISNULL(FOUT, 0) ,
                    FOUTYZZY = ISNULL(FOUTYZZY, 0) ,
                    FOUTYZLY = ISNULL(FOUTYZLY, 0) ,
                    FOUTSQXZ = ISNULL(FOUTSQXZ, 0) ,
                    FOUTFYZLY = ISNULL(FOUTFYZLY, 0) ,
                    FOUTSW = ISNULL(FOUTSW, 0) ,
                    FOUTOTHER = ISNULL(FOUTOTHER, 0) ,
                    FTRANSFEROUT = ISNULL(FTRANSFEROUT, 0) ,
                    FEND = ISNULL(FEND, 0) ,
            FSJKFZCRS = ISNULL(FSJKFZCRS, 0) ,
                    FSJZYZCRS = ISNULL(FSJZYZCRS, 0) ,
                    FPJKFCWS = ISNULL(FPJKFCWS, 0) ,
                    FCYZZYZCRS = ISNULL(FCYZZYZCRS, 0) ,
                    FBSL = ISNULL(FBSL, 0) ,
                    FBCZZCS = ISNULL(FBCZZCS, 0) ,
                    FPJBCGZR = ISNULL(FPJBCGZR, 0) ,
                    FBCSYL = ISNULL(FBCSYL, 0) ,
                    FCYZPJZYR = ISNULL(FCYZPJZYR, 0) ,
                    FSSRS = ISNULL(FSSRS, 0)
			
            UPDATE  #bb_yygzbb2
            SET     FBSL = CASE FOUT
                             WHEN 0 THEN 0
                             ELSE CONVERT(NUMERIC(9, 1), FOUTSW / FOUT * 100)
                           END ,
                    FBCZZCS = CASE FENDBED
                                WHEN 0 THEN 0
                                ELSE CONVERT(NUMERIC(9, 1), FOUT / FENDBED)
                              END ,
                    FPJBCGZR = CASE FENDBED
                                 WHEN 0 THEN 0
                                 ELSE CONVERT(NUMERIC(9, 1), FSJZYZCRS
                                      / FENDBED)
                               END ,
                    FBCSYL = CASE FSJKFZCRS
                               WHEN 0 THEN 0
                               ELSE CONVERT(NUMERIC(9, 1), FSJZYZCRS
                                    / FSJKFZCRS * 100)
                             END ,
                    FCYZPJZYR = CASE FOUT
                                  WHEN 0 THEN 0
                                  ELSE CONVERT(NUMERIC(9, 1), FCYZZYZCRS
                                       / FOUT)
                                END ,
                    FPJKFCWS = CONVERT(NUMERIC(9, 1), FSJKFZCRS / @calendarDay)		

            UPDATE  #bb_yygzbb2
            SET     FEND = FBEGIN + FIN + FTRANSFERIN - FOUT - FTRANSFEROUT
	--select*from #bb_yygzbb2
	--return
        END
    ELSE 



--�����ꡢ����ʽ����ֱ�Ӵ��±��в�ѯ����
        BEGIN
            DECLARE @productCode VARCHAR(100)--ִ���±��Ĵ洢��������
            DECLARE @freportdatestrs VARCHAR(2000)--����±������ڼ���
            DECLARE @sql VARCHAR(8000)--����±������ڼ���
            SELECT  @productCode = 'statisticbb_yygzbb2'
	        --��ѯ�Ƿ���ڶ�Ӧʱ��֮����±���������������Զ�������Ӧ���±�
            EXEC statisticTzyFromMonth @date1, @date2, @freportcode, @ftyyhbh,
                @fusername, @productCode, 1, @ftykh, @freportdatestrs OUTPUT,
                @zjerrcode OUTPUT, @zjerrmsg OUTPUT
            IF @zjerrcode <> 0 
                GOTO Err    
            IF @@error <> 0 
                BEGIN
                    SET @zjerrmsg = '����statisticTzyFromMonth�洢���̲�ѯ�±�����'
                    GOTO Err
                END 
		

		--�������ɱ�������
            SET @SQL = 'insert into #bb_yygzbb2(fyydmstr,FREPORTCODE,FREPORTDATESTR,FTYKH,FPX,FKSNAME,FENDBED,FBEGIN,FIN,FTRANSFERIN,FOUT,FOUTYZLY,
		FOUTYZZY,FOUTSQXZ,FOUTFYZLY,FOUTSW,FOUTOTHER,FTRANSFEROUT,FEND,FSJKFZCRS,FSJZYZCRS,FPJKFCWS,FCYZZYZCRS,
		FBSL,FBCZZCS,FPJBCGZR,FBCSYL,FCYZPJZYR,FSSRS)
            select  ''' + @fyydmstr + ''' as fyydm, ''' + @freportcode + ''' as freportcode,'''
                + @freportdatestr
                + ''' as freportdatestr,FTYKH,max(fpx),max(FKSNAME),sum(isnull(FENDBED,0)) FENDBED,sum(isnull(FBEGIN,0)) FBEGIN,
			sum(isnull(FIN,0)) FIN,sum(isnull(FTRANSFERIN,0)) FTRANSFERIN,sum(isnull(FOUT,0)) FOUT,sum(isnull(FOUTYZLY,0)) FOUTYZLY,sum(isnull(FOUTYZZY,0)) FOUTYZZY,
			sum(isnull(FOUTSQXZ,0)) FOUTSQXZ,sum(isnull(FOUTFYZLY,0)) FOUTFYZLY,sum(isnull(FOUTSW,0)) FOUTSW,sum(isnull(FOUTOTHER,0)) FOUTOTHER,sum(isnull(FTRANSFEROUT,0)) FTRANSFEROUT,		
			sum(isnull(FEND,0)) FEND,sum(isnull(FSJKFZCRS,0)) FSJKFZCRS,sum(isnull(FSJZYZCRS,0)) FSJZYZCRS,sum(isnull(FPJKFCWS,0)) FPJKFCWS,	
			sum(isnull(FCYZZYZCRS,0)) FCYZZYZCRS,sum(isnull(FBSL,0)) FBSL,sum(isnull(FBCZZCS,0)) FBCZZCS,sum(isnull(FPJBCGZR,0)) FPJBCGZR,
			sum(isnull(FBCSYL,0)) FBCSYL,sum(isnull(FCYZPJZYR,0)) FCYZPJZYR,sum(isnull(FSSRS,0)) FSSRS from bb_yygzbb2 a where a.freportdatestr in (' + @freportdatestrs + ') and fyydmstr='''+@fyydmstr+'''group by FTYKH'
            EXEC(@SQL)

            UPDATE  #bb_yygzbb2
            SET     FENDBED = b.FENDBED
            FROM    #bb_yygzbb2 a ,
                    ( SELECT    *
                      FROM      bb_yygzbb2
                      WHERE     freportdatestr = SUBSTRING(CONVERT(VARCHAR(20), DATEADD(MM,
                                                              -1, @date2), 120),
                                                           1, 7)
                    ) b
            WHERE   a.FTYKH = b.FTYKH
            UPDATE  #bb_yygzbb2
            SET     FBEGIN = b.FBEGIN
            FROM    #bb_yygzbb2 a ,
                    ( SELECT    *
                      FROM      bb_yygzbb2
                      WHERE     freportdatestr = SUBSTRING(CONVERT(VARCHAR(20), @date1, 120),
                                                           1, 7)
                    ) b
            WHERE   a.FTYKH = b.FTYKH
            UPDATE  #bb_yygzbb2
            SET     FEND = b.FEND
            FROM    #bb_yygzbb2 a ,
                    ( SELECT    *
                      FROM      bb_yygzbb2
                      WHERE     freportdatestr = SUBSTRING(CONVERT(VARCHAR(20), DATEADD(MM,
                                                              -1, @date2), 120),
                                                           1, 7)
                    ) b
            WHERE   a.FTYKH = b.FTYKH

	

            UPDATE  #bb_yygzbb2
            SET     FBSL = CASE FOUT
                             WHEN 0 THEN 0
                             ELSE CONVERT(NUMERIC(9, 1), FOUTSW / FOUT * 100)
                           END ,
                    FBCZZCS = CASE FENDBED
                                WHEN 0 THEN 0
                                ELSE CONVERT(NUMERIC(9, 1), FOUT / FENDBED)
                              END ,
                    FPJBCGZR = CASE FENDBED
                                 WHEN 0 THEN 0
                                 ELSE CONVERT(NUMERIC(9, 1), FSJZYZCRS
                                      / FENDBED)
                               END ,
                    FBCSYL = CASE FSJKFZCRS
                               WHEN 0 THEN 0
                               ELSE CONVERT(NUMERIC(9, 1), FSJZYZCRS
                                    / FSJKFZCRS * 100)
                             END ,
                    FCYZPJZYR = CASE FOUT
                                  WHEN 0 THEN 0
                                  ELSE CONVERT(NUMERIC(9, 1), FCYZZYZCRS
                                       / FOUT)
                                END ,
                    FPJKFCWS = CONVERT(NUMERIC(9, 1), FSJKFZCRS / @calendarDay)	
			--update #bb_yygzbb2 set FEND=FBEGIN+FIN+FTRANSFERIN-FOUT-FTRANSFEROUT
			--update #bb_yygzbb2 set FIN=FOUT+FTRANSFEROUT+FEND-FBEGIN-FTRANSFERIN
			
        END
		


	--3.Ժ���ñ��ñ���ֱ�ӷ���
    IF @datetype = 5 
        BEGIN
            SELECT  *
            FROM    #bb_yygzbb2
            ORDER BY FPX
            DROP TABLE #bb_yygzbb2
            RETURN
        END
    ELSE 
        BEGIN
		--��ʽ��������
            BEGIN TRANSACTION 
		
		--ɾ����ϸ����
   
            DELETE  FROM bb_yygzbb2
            WHERE   freportdatestr = @freportdatestr
            IF @@error <> 0 
                BEGIN
                    SET @zjerrmsg = 'ɾ��ԭ����ϸ�������'
                    GOTO Err
                END 
		
		--ɾ��������
            DELETE  FROM TZYReportMain
            WHERE   freportcode = @freportcode
                    AND freporttype = @dateType
                    AND freportdatestr = @freportdatestr
            IF @@error <> 0 
                BEGIN
                    SET @zjerrmsg = 'ɾ��ԭ�����������'
                    GOTO Err
                END 
		
		--����������
            INSERT  INTO TZYReportMain
               ( freportdatestr ,
                      freportstate ,
                      freporttype ,
                      freportcode ,
                      fusername ,
                      ftyyhbh ,
                      fworktime ,
                      Fbegindate1 ,
                      Fenddate1 ,
                      ftykh ,
                      fiffk ,
                      fyydmstr
                    )
                    SELECT  @freportdatestr ,
                            0 ,
                            @dateType ,
                            @freportcode ,
                            @fusername ,
                            @ftyyhbh ,
                            GETDATE() ,
                            @date1 ,
                            @date2 ,
                            @ftykh ,
                            0 ,
                            @fyydmstr
            IF @@error <> 0 
                BEGIN
                    SET @zjerrmsg = '��������ʱ���ݳ���'
                    GOTO Err
                END 
		
		--��������ϸ����
            INSERT  INTO bb_yygzbb2
                    ( FREPORTCODE ,
                      FREPORTDATESTR ,
                      FTYKH ,
                      FPX ,
                      FKSNAME ,
                      FENDBED ,
                      FBEGIN ,
                      FIN ,
                      FTRANSFERIN ,
                      FOUT ,
                      FOUTYZLY ,
                      FOUTYZZY ,
                      FOUTSQXZ ,
                      FOUTFYZLY ,
                      FOUTSW ,
                      FOUTOTHER ,
                      FTRANSFEROUT ,
                      FEND ,
                      FSJKFZCRS ,
                      FSJZYZCRS ,
                      FPJKFCWS ,
                      FCYZZYZCRS ,
                      FBSL ,
                      FBCZZCS ,
                      FPJBCGZR ,
                      FBCSYL ,
                      FCYZPJZYR ,
                      FSSRS ,
                      fyydmstr
                    )
                    SELECT  FREPORTCODE ,
                            FREPORTDATESTR ,
                            FTYKH ,
                            FPX ,
                            FKSNAME ,
                            FENDBED ,
                            FBEGIN ,
                            FIN ,
                            FTRANSFERIN ,
                            FOUT ,
                            FOUTYZLY ,
                            FOUTYZZY ,
                            FOUTSQXZ ,
                            FOUTFYZLY ,
                            FOUTSW ,
                            FOUTOTHER ,
                            FTRANSFEROUT ,
                            FEND ,
                            FSJKFZCRS ,
                            FSJZYZCRS ,
                            FPJKFCWS ,
                            FCYZZYZCRS ,
                            FBSL ,
                            FBCZZCS ,
                            FPJBCGZR ,
                            FBCSYL ,
                            FCYZPJZYR ,
                            FSSRS ,
                            fyydmstr
                    FROM    #bb_yygzbb2 where fyydmstr=@fyydmstr	
            IF @@error <> 0 
                BEGIN
                    SET @zjerrmsg = '��̬���뱨�����ݳ���'
                    GOTO Err
                END 
			
		--�ύ����
            COMMIT TRAN
            SET @zjerrcode = 0
            RETURN     
        END
	
    Err:
	--�ع�����
    ROLLBACK TRAN
    SET @zjerrcode = 1
    RETURN



    SET QUOTED_IDENTIFIER OFF 






