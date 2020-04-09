ALTER PROCEDURE [dbo].[statisticBB_dbz_szx2]
    @freportdatestr VARCHAR(100) ,    	--报表日期
    @ftykh VARCHAR(30) ,								--统一科号
    @dateType TINYINT ,    						--日期类型,1为"月报"，2为"季报"，3为"年报"，4为"非正式" , 5为"院内用表" 
    @ftyyhbh VARCHAR(30) ,   				 	--统一用户编号
    @fusername VARCHAR(30) ,    				--用户姓名
    @date1 DATETIME ,    							--汇总的起始日期 '2008-01-01'
    @date2 DATETIME ,    							--汇总的终止日期 '2008-01-01'
    @calendarDay INT = 31 ,    					--日历天数
    @workDay INT = 31 ,    							--工作日数
    @week INT = 4 ,    									--周数
    @errcode TINYINT OUT ,     				--错误消息
    @errmsg VARCHAR(200) OUT    			--错误内容  
AS --exec statisticBB_dbz_szx2 '2020-01-16','','5','','','2019-04-01','2019-04-30','30','','',null,null
 --单病种

    DECLARE @freportcode VARCHAR(100)
    DECLARE @execSql VARCHAR(6000)
    SET @freportcode = 'BB_dbz_szx2'

    SELECT  *
    INTO    #BB_dbz_szx2
    FROM    BB_dbz_szx2
    WHERE   ( 1 = 2 )
    ALTER TABLE #BB_dbz_szx2 ADD fwheresql VARCHAR(6000)

    IF ( @datetype = 1 )
        OR ( @datetype = 5 ) 
        BEGIN
            SELECT  *
            INTO    #THQMSSET
            FROM    dbo.THQMSSET a
            WHERE   FREPORTDATESTR = @freportdatestr
		--1.出院患者总人次数
            INSERT  INTO #BB_dbz_szx2
                    ( freportdatestr ,
                      freportcode ,
                      fpx ,
                      FKEY ,
                      FNAME ,
                      FVALUE
                    )
                    SELECT  @freportdatestr freportdatestr ,
                            @freportcode freportcode ,
                            '01' fpx ,
                            '01' FBH ,
                            '出院患者总人次数' FNAME ,
                            CONVERT(VARCHAR(10), COUNT(1)) FVALUE
                    FROM    #THQMSSET

		--2.出院患者总手术人数
            INSERT  INTO #BB_dbz_szx2
                    ( freportdatestr ,
                      freportcode ,
                      fpx ,
                      FKEY ,
                      FNAME ,
                      FVALUE
                    )
                    SELECT  @freportdatestr freportdatestr ,
                            @freportcode freportcode ,
                            '02' fpx ,
                            '02' FBH ,
                            '出院患者总手术人数' FNAME ,
                            CONVERT(VARCHAR(10), COUNT(1)) FVALUE
                    FROM    #THQMSSET
                    WHERE   NOT ( C03C BETWEEN 'O00' AND 'O84'
                                  OR C03C BETWEEN 'O94' AND 'O99'
                                  OR C03C BETWEEN 'O00' AND 'O84'
                                )
                            AND C14x01C != '-'
                            AND ( A14 > 1
                                  OR ISNULL(A14, 0) = 0
                                  AND A14 > 28
                                )

		--3.出院微创手术人数
		    INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '03' fpx ,
                    '03' FBH ,
                    '出院微创手术人数' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
				INNER JOIN dbo.TOPERATE b (NOLOCK) ON a.C14x01C=b.FOPCODE
            WHERE   NOT ( C03C BETWEEN 'O00' AND 'O84'
                            OR C03C BETWEEN 'O94' AND 'O99'
                            OR C03C BETWEEN 'O00' AND 'O84'
                        )
                    AND ( A14 > 1
                            OR ISNULL(A14, 0) = 0
                            AND A14 > 28
                        )
					AND CHARINDEX('微创',b.FOPLB)>0

		--4.出院四级手术人数
		    INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '04' fpx ,
                    '04' FBH ,
                    '出院四级手术人数' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
				INNER JOIN dbo.TOPERATE b (NOLOCK) ON a.C14x01C=b.FOPCODE
            WHERE   NOT ( C03C BETWEEN 'O00' AND 'O84'
                            OR C03C BETWEEN 'O94' AND 'O99'
                            OR C03C BETWEEN 'O00' AND 'O84'
                        )
                    AND ( A14 > 1
                            OR ISNULL(A14, 0) = 0
                            AND A14 > 28
                        )
					AND CHARINDEX('四级',b.FOPLB)>0

		--5.择期手术总人数
		    INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '05' fpx ,
                    '05' FBH ,
                    '择期手术总人数' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE   NOT ( C03C BETWEEN 'O00' AND 'O84'
                            OR C03C BETWEEN 'O94' AND 'O99'
                            OR C03C BETWEEN 'O00' AND 'O84'
                        )
                    AND C14x01C != '-'
                    AND ( A14 > 1
                            OR ISNULL(A14, 0) = 0
                            AND A14 > 28
                        )
					AND a.B11C != 1

		--6.择期手术患者并发症发生人次数
		    INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '06' fpx ,
                    '06' FBH ,
                    '择期手术患者并发症发生人次数' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
				INNER JOIN dbo.TICD b (NOLOCK) ON a.C03C=b.FICDM
            WHERE   NOT ( C03C BETWEEN 'O00' AND 'O84'
                            OR C03C BETWEEN 'O94' AND 'O99'
                            OR C03C BETWEEN 'O00' AND 'O84'
                        )
                    AND ( A14 > 1
                            OR ISNULL(A14, 0) = 0
                            AND A14 > 28
                        )
					AND a.B11C!=1
					AND b.fyscode='手术并发症' 
					AND a.C05C=4
		
		--7.I类切口手术总人数
		    INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '07' fpx ,
                    '07' FBH ,
                    'I类切口手术总人数' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE   NOT ( C03C BETWEEN 'O00' AND 'O84'
                            OR C03C BETWEEN 'O94' AND 'O99'
                            OR C03C BETWEEN 'O00' AND 'O84'
                        )
                    AND C14x01C != '-'
                    AND ( A14 > 1
                            OR ISNULL(A14, 0) = 0
                            AND A14 > 28
                        )
					AND a.C21x01C IN (1,2,3,10)

		--8.I类切口手术总感染人数
		    INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '08' fpx ,
                    '08' FBH ,
                    'I类切口手术总感染人数' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE   NOT ( C03C BETWEEN 'O00' AND 'O84'
                            OR C03C BETWEEN 'O94' AND 'O99'
                            OR C03C BETWEEN 'O00' AND 'O84'
                        )
                    AND C14x01C != '-'
                    AND ( A14 > 1
                            OR ISNULL(A14, 0) = 0
                            AND A14 > 28
                        )
					AND a.C21x01C = 3

		--单病种
		--9.急性心肌梗死收治总例数
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '09' fpx ,
                    '09' FBH ,
                    '急性心肌梗死收治总例数' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C03C,3)='I21'

		--10.急性心肌梗死出院患者占用总床日数
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '10' fpx ,
                    '10' FBH ,
                    '急性心肌梗死出院患者占用总床日数' FNAME ,
                    CONVERT(VARCHAR(10), SUM(CONVERT(INT,B20))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C03C,3)='I21'

		--11.急性心肌梗死平均住院日
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '11' fpx ,
                    '11' FBH ,
                    '急性心肌梗死平均住院日' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),B20)))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C03C,3)='I21'

		--12.急性心肌梗死总住院费用
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '12' fpx ,
                    '12' FBH ,
                    '急性心肌梗死总住院费用' FNAME ,
                    CONVERT(VARCHAR(50), SUM((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C03C,3)='I21'

		--13.急性心肌梗死次均费用
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '13' fpx ,
                    '13' FBH ,
                    '急性心肌梗死次均费用' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C03C,3)='I21'

		--14.急性心肌梗死亡人数
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '14' fpx ,
                    '14' FBH ,
                    '急性心肌梗死亡人数' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C03C,3)='I21'
					AND B34C=5

		--15.心力衰竭收治总例数
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '15' fpx ,
                    '15' FBH ,
                    '心力衰竭收治总例数' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C03C,5)='I11.0' OR LEFT(C03C,5)='I13.0' OR LEFT(C03C,5)='I13.2' OR LEFT(C03C,3)='I50'

		--16.心力衰竭出院患者占用总床日数
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '16' fpx ,
                    '16' FBH ,
                    '心力衰竭出院患者占用总床日数' FNAME ,
                    CONVERT(VARCHAR(10), SUM(CONVERT(INT,B20))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C03C,5)='I11.0' OR LEFT(C03C,5)='I13.0' OR LEFT(C03C,5)='I13.2' OR LEFT(C03C,3)='I50'

		--17.心力衰竭平均住院日
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '17' fpx ,
                    '17' FBH ,
                    '心力衰竭平均住院日' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),B20)))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C03C,5)='I11.0' OR LEFT(C03C,5)='I13.0' OR LEFT(C03C,5)='I13.2' OR LEFT(C03C,3)='I50'

		--18.心力衰竭总住院费用
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '18' fpx ,
                    '18' FBH ,
                    '心力衰竭总住院费用' FNAME ,
                    CONVERT(VARCHAR(50), SUM((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C03C,5)='I11.0' OR LEFT(C03C,5)='I13.0' OR LEFT(C03C,5)='I13.2' OR LEFT(C03C,3)='I50'

		--19.心力衰竭次均费用
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '19' fpx ,
                    '19' FBH ,
                    '心力衰竭次均费用' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C03C,5)='I11.0' OR LEFT(C03C,5)='I13.0' OR LEFT(C03C,5)='I13.2' OR LEFT(C03C,3)='I50'

		--20.心力衰竭死亡人数
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '20' fpx ,
                    '20' FBH ,
                    '心力衰竭死亡人数' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE  ( LEFT(C03C,5)='I11.0' OR LEFT(C03C,5)='I13.0' OR LEFT(C03C,5)='I13.2' OR LEFT(C03C,3)='I50' )
					AND B34C=5

		--21.肺炎(成人)收治总例数
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '21' fpx ,
                    '21' FBH ,
                    '肺炎(成人)收治总例数' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE   ( LEFT(C03C,3)='J13' OR LEFT(C03C,3)='J14' OR LEFT(C03C,3)='J15' OR LEFT(C03C,3)='J18' )
					AND A14 >=18

		--22.肺炎(成人)出院患者占用总床日数
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '22' fpx ,
                    '22' FBH ,
                    '肺炎(成人)出院患者占用总床日数' FNAME ,
                    CONVERT(VARCHAR(10), SUM(CONVERT(INT,B20))) FVALUE
            FROM    #THQMSSET a
            WHERE   ( LEFT(C03C,3)='J13' OR LEFT(C03C,3)='J14' OR LEFT(C03C,3)='J15' OR LEFT(C03C,3)='J18' )
					AND A14 >=18

		--23.肺炎(成人)平均住院日
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '23' fpx ,
                    '23' FBH ,
                    '肺炎(成人)平均住院日' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),B20)))) FVALUE
            FROM    #THQMSSET a
            WHERE   ( LEFT(C03C,3)='J13' OR LEFT(C03C,3)='J14' OR LEFT(C03C,3)='J15' OR LEFT(C03C,3)='J18' )
					AND A14 >=18

		--24.肺炎(成人)总住院费用
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '24' fpx ,
                    '24' FBH ,
                    '肺炎(成人)总住院费用' FNAME ,
                    CONVERT(VARCHAR(50), SUM((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE   ( LEFT(C03C,3)='J13' OR LEFT(C03C,3)='J14' OR LEFT(C03C,3)='J15' OR LEFT(C03C,3)='J18' )
					AND A14 >=18

		--25.肺炎(成人)次均费用
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '25' fpx ,
                    '25' FBH ,
                    '肺炎(成人)次均费用' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE   ( LEFT(C03C,3)='J13' OR LEFT(C03C,3)='J14' OR LEFT(C03C,3)='J15' OR LEFT(C03C,3)='J18' )
					AND A14 >=18

		--26.肺炎(成人)死亡人数
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '26' fpx ,
                    '26' FBH ,
                    '肺炎(成人)死亡人数' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE  ( LEFT(C03C,3)='J13' OR LEFT(C03C,3)='J14' OR LEFT(C03C,3)='J15' OR LEFT(C03C,3)='J18' )
					AND A14 >=18
					AND B34C=5

		--27.肺炎(儿童)收治总例数
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '27' fpx ,
                    '27' FBH ,
                    '肺炎(儿童)收治总例数' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE   (LEFT(C03C,3)='J13' OR LEFT(C03C,3)='J14' OR LEFT(C03C,3)='J15' OR LEFT(C03C,3)='J18')
					AND A14 >1 
					AND A14 < 18

		--28.肺炎(儿童)出院患者占用总床日数
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '28' fpx ,
                    '28' FBH ,
                    '肺炎(儿童)出院患者占用总床日数' FNAME ,
                    CONVERT(VARCHAR(10), SUM(CONVERT(INT,B20))) FVALUE
            FROM    #THQMSSET a
            WHERE   (LEFT(C03C,3)='J13' OR LEFT(C03C,3)='J14' OR LEFT(C03C,3)='J15' OR LEFT(C03C,3)='J18')
					AND A14 >1 
					AND A14 < 18

		--29.肺炎(儿童)平均住院日
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '29' fpx ,
                    '29' FBH ,
                    '肺炎(儿童)平均住院日' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),B20)))) FVALUE
            FROM    #THQMSSET a
            WHERE   (LEFT(C03C,3)='J13' OR LEFT(C03C,3)='J14' OR LEFT(C03C,3)='J15' OR LEFT(C03C,3)='J18')
					AND A14 >1 
					AND A14 < 18

		--30.肺炎(儿童)总住院费用
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '30' fpx ,
                    '30' FBH ,
                    '肺炎(儿童)总住院费用' FNAME ,
                    CONVERT(VARCHAR(50), SUM((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE   (LEFT(C03C,3)='J13' OR LEFT(C03C,3)='J14' OR LEFT(C03C,3)='J15' OR LEFT(C03C,3)='J18')
					AND A14 >1 
					AND A14 < 18

		--31.肺炎(儿童)次均费用
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '31' fpx ,
                    '31' FBH ,
                    '肺炎(儿童)次均费用' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE   (LEFT(C03C,3)='J13' OR LEFT(C03C,3)='J14' OR LEFT(C03C,3)='J15' OR LEFT(C03C,3)='J18')
					AND A14 >1 
					AND A14 < 18

		--32.肺炎(儿童)死亡人数
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '32' fpx ,
                    '32' FBH ,
                    '肺炎(儿童)死亡人数' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE  (LEFT(C03C,3)='J13' OR LEFT(C03C,3)='J14' OR LEFT(C03C,3)='J15' OR LEFT(C03C,3)='J18')
					AND A14 >1 
					AND A14 < 18
					AND B34C=5

		--33.脑梗死收治总例数
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '33' fpx ,
                    '33' FBH ,
                    '脑梗死收治总例数' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C03C,3)='I63'
					AND NOT ( LEFT(C03C,7)='I63.301' OR LEFT(C03C,7)='I63.302' OR LEFT(C03C,7)='I63.401' OR LEFT(C03C,7)='I63.801' OR LEFT(C03C,7)='I63.802' )

		--34.脑梗死出院患者占用总床日数
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '34' fpx ,
                    '34' FBH ,
                    '脑梗死出院患者占用总床日数' FNAME ,
                    CONVERT(VARCHAR(10), SUM(CONVERT(INT,B20))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C03C,3)='I63'
					AND NOT ( LEFT(C03C,7)='I63.301' OR LEFT(C03C,7)='I63.302' OR LEFT(C03C,7)='I63.401' OR LEFT(C03C,7)='I63.801' OR LEFT(C03C,7)='I63.802' )

		--35.脑梗死平均住院日
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '35' fpx ,
                    '35' FBH ,
                    '脑梗死平均住院日' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),B20)))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C03C,3)='I63'
					AND NOT ( LEFT(C03C,7)='I63.301' OR LEFT(C03C,7)='I63.302' OR LEFT(C03C,7)='I63.401' OR LEFT(C03C,7)='I63.801' OR LEFT(C03C,7)='I63.802' )

		--36.脑梗死总住院费用
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '36' fpx ,
                    '36' FBH ,
                    '脑梗死总住院费用' FNAME ,
                    CONVERT(VARCHAR(50), SUM((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C03C,3)='I63'
					AND NOT ( LEFT(C03C,7)='I63.301' OR LEFT(C03C,7)='I63.302' OR LEFT(C03C,7)='I63.401' OR LEFT(C03C,7)='I63.801' OR LEFT(C03C,7)='I63.802' )

		--37.脑梗死次均费用
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '37' fpx ,
                    '37' FBH ,
                    '脑梗死次均费用' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C03C,3)='I63'
					AND NOT ( LEFT(C03C,7)='I63.301' OR LEFT(C03C,7)='I63.302' OR LEFT(C03C,7)='I63.401' OR LEFT(C03C,7)='I63.801' OR LEFT(C03C,7)='I63.802' )

		--38.脑梗死死亡人数
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '38' fpx ,
                    '38' FBH ,
                    '脑梗死死亡人数' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C03C,3)='I63'
					AND NOT ( LEFT(C03C,7)='I63.301' OR LEFT(C03C,7)='I63.302' OR LEFT(C03C,7)='I63.401' OR LEFT(C03C,7)='I63.801' OR LEFT(C03C,7)='I63.802' )
					AND B34C=5

		--39.髋关节置换术收治总例数
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '39' fpx ,
                    '39' FBH ,
                    '髋关节置换术收治总例数' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C14x01C,7)='81.5100' OR LEFT(C14x01C,7)='81.5200'

		--40.髋关节置换术出院患者占用总床日数
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '40' fpx ,
                    '40' FBH ,
                    '髋关节置换术出院患者占用总床日数' FNAME ,
                    CONVERT(VARCHAR(10), SUM(CONVERT(INT,B20))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C14x01C,7)='81.5100' OR LEFT(C14x01C,7)='81.5200'

		--41.髋关节置换术平均住院日
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '41' fpx ,
                    '41' FBH ,
                    '髋关节置换术平均住院日' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),B20)))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C14x01C,7)='81.5100' OR LEFT(C14x01C,7)='81.5200'

		--42.髋关节置换术总住院费用
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '42' fpx ,
                    '42' FBH ,
                    '髋关节置换术总住院费用' FNAME ,
                    CONVERT(VARCHAR(50), SUM((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C14x01C,7)='81.5100' OR LEFT(C14x01C,7)='81.5200'

		--43.髋关节置换术次均费用
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '43' fpx ,
                    '43' FBH ,
                    '髋关节置换术次均费用' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C14x01C,7)='81.5100' OR LEFT(C14x01C,7)='81.5200'

		--44.髋关节置换术死亡人数
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '44' fpx ,
                    '44' FBH ,
                    '髋关节置换术死亡人数' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE   ( LEFT(C14x01C,7)='81.5100' OR LEFT(C14x01C,7)='81.5200' )
					AND B34C=5

		--45.膝关节置换术收治总例数
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '45' fpx ,
                    '45' FBH ,
                    '膝关节置换术收治总例数' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C14x01C,5)='81.54'

		--46.膝关节置换术出院患者占用总床日数
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '46' fpx ,
                    '46' FBH ,
                    '膝关节置换术出院患者占用总床日数' FNAME ,
                    CONVERT(VARCHAR(10), SUM(CONVERT(INT,B20))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C14x01C,5)='81.54'

		--47.膝关节置换术平均住院日
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '47' fpx ,
                    '47' FBH ,
                    '膝关节置换术平均住院日' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),B20)))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C14x01C,5)='81.54'

		--48.膝关节置换术总住院费用
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '48' fpx ,
                    '48' FBH ,
                    '膝关节置换术总住院费用' FNAME ,
                    CONVERT(VARCHAR(50), SUM((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C14x01C,5)='81.54'

		--49.膝关节置换术次均费用
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '49' fpx ,
                    '49' FBH ,
                    '膝关节置换术次均费用' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C14x01C,5)='81.54'

		--50.膝关节置换术死亡人数
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '50' fpx ,
                    '50' FBH ,
                    '膝关节置换术死亡人数' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C14x01C,5)='81.54'
					AND B34C=5

		--51.冠状动脉旁路移植术收治总例数
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '51' fpx ,
                    '51' FBH ,
                    '冠状动脉旁路移植术收治总例数' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C14x01C,4)='36.1'

		--52.冠状动脉旁路移植术出院患者占用总床日数
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '52' fpx ,
                    '52' FBH ,
                    '冠状动脉旁路移植术出院患者占用总床日数' FNAME ,
                    CONVERT(VARCHAR(10), SUM(CONVERT(INT,B20))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C14x01C,4)='36.1'

		--53.冠状动脉旁路移植术平均住院日
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '53' fpx ,
                    '53' FBH ,
                    '冠状动脉旁路移植术平均住院日' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),B20)))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C14x01C,4)='36.1'

		--54.冠状动脉旁路移植术总住院费用
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '54' fpx ,
                    '54' FBH ,
                    '冠状动脉旁路移植术总住院费用' FNAME ,
                    CONVERT(VARCHAR(50), SUM((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C14x01C,4)='36.1'

		--55.冠状动脉旁路移植术次均费用
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '55' fpx ,
                    '55' FBH ,
                    '冠状动脉旁路移植术次均费用' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C14x01C,4)='36.1'

		--56.冠状动脉旁路移植术死亡人数
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '56' fpx ,
                    '56' FBH ,
                    '冠状动脉旁路移植术死亡人数' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C14x01C,4)='36.1'
					AND B34C=5

		--57.剖宫产收治总例数
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '57' fpx ,
                    '57' FBH ,
                    '剖宫产收治总例数' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE   ( LEFT(C14x01C,4)='74.0' OR LEFT(C14x01C,4)='74.1' OR LEFT(C14x01C,4)='74.2' )

		--58.剖宫产出院患者占用总床日数
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '58' fpx ,
                    '58' FBH ,
                    '剖宫产出院患者占用总床日数' FNAME ,
                    CONVERT(VARCHAR(10), SUM(CONVERT(INT,B20))) FVALUE
            FROM    #THQMSSET a
            WHERE   ( LEFT(C14x01C,4)='74.0' OR LEFT(C14x01C,4)='74.1' OR LEFT(C14x01C,4)='74.2' )

		--59.剖宫产平均住院日
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '59' fpx ,
                    '59' FBH ,
                    '剖宫产平均住院日' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),B20)))) FVALUE
            FROM    #THQMSSET a
            WHERE   ( LEFT(C14x01C,4)='74.0' OR LEFT(C14x01C,4)='74.1' OR LEFT(C14x01C,4)='74.2' )

		--60.剖宫产总住院费用
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '60' fpx ,
                    '60' FBH ,
                    '剖宫产总住院费用' FNAME ,
                    CONVERT(VARCHAR(50), SUM((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE   ( LEFT(C14x01C,4)='74.0' OR LEFT(C14x01C,4)='74.1' OR LEFT(C14x01C,4)='74.2' )

		--61.剖宫产次均费用
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '61' fpx ,
                    '61' FBH ,
                    '剖宫产次均费用' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE  ( LEFT(C14x01C,4)='74.0' OR LEFT(C14x01C,4)='74.1' OR LEFT(C14x01C,4)='74.2' )

		--62.剖宫产死亡人数
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '62' fpx ,
                    '62' FBH ,
                    '剖宫产死亡人数' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE   ( LEFT(C14x01C,4)='74.0' OR LEFT(C14x01C,4)='74.1' OR LEFT(C14x01C,4)='74.2' )
					AND B34C=5

		--63.慢性阻塞性肺疾病收治总例数
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '63' fpx ,
                    '63' FBH ,
                    '慢性阻塞性肺疾病收治总例数' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE   ( LEFT(C03C,5)='J44.0' OR LEFT(C03C,5)='J44.1' OR LEFT(C03C,5)='J44.9' )

		--64.慢性阻塞性肺疾病出院患者占用总床日数
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '64' fpx ,
                    '64' FBH ,
                    '慢性阻塞性肺疾病出院患者占用总床日数' FNAME ,
                    CONVERT(VARCHAR(10), SUM(CONVERT(INT,B20))) FVALUE
            FROM    #THQMSSET a
            WHERE   ( LEFT(C03C,5)='J44.0' OR LEFT(C03C,5)='J44.1' OR LEFT(C03C,5)='J44.9' )

		--65.慢性阻塞性肺疾病平均住院日
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '65' fpx ,
                    '65' FBH ,
                    '慢性阻塞性肺疾病平均住院日' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),B20)))) FVALUE
            FROM    #THQMSSET a
            WHERE   ( LEFT(C03C,5)='J44.0' OR LEFT(C03C,5)='J44.1' OR LEFT(C03C,5)='J44.9' )

		--66.慢性阻塞性肺疾病总住院费用
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '66' fpx ,
                    '66' FBH ,
                    '慢性阻塞性肺疾病总住院费用' FNAME ,
                    CONVERT(VARCHAR(50), SUM((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE   ( LEFT(C03C,5)='J44.0' OR LEFT(C03C,5)='J44.1' OR LEFT(C03C,5)='J44.9' )

		--67.慢性阻塞性肺疾病次均费用
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '67' fpx ,
                    '67' FBH ,
                    '慢性阻塞性肺疾病次均费用' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE  ( LEFT(C03C,5)='J44.0' OR LEFT(C03C,5)='J44.1' OR LEFT(C03C,5)='J44.9' )

		--68.慢性阻塞性肺疾病死亡人数
			INSERT  INTO #BB_dbz_szx2
            ( freportdatestr ,
                freportcode ,
                fpx ,
                FKEY ,
                FNAME ,
                FVALUE
            )
            SELECT  @freportdatestr freportdatestr ,
                    @freportcode freportcode ,
                    '68' fpx ,
                    '68' FBH ,
                    '慢性阻塞性肺疾病死亡人数' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE   ( LEFT(C03C,5)='J44.0' OR LEFT(C03C,5)='J44.1' OR LEFT(C03C,5)='J44.9' )
					AND B34C=5


        END
    ELSE 
        BEGIN 
            DECLARE @productCode VARCHAR(1000)
            DECLARE @freportdatestrs VARCHAR(2000)
            DECLARE @sql VARCHAR(8000)
            SELECT  @productCode = 'statisticBB_dbz_szx2'
            EXEC statisticTzyFromMonth @date1, @date2, @freportcode, @ftyyhbh,
                @fusername, @productCode, 1, @ftykh, @freportdatestrs OUTPUT,
                @errcode OUTPUT, @errmsg OUTPUT
            IF @errcode <> 0 
                GOTO Err		
            IF @@error <> 0 
                BEGIN
                    SET @errmsg = '调用statisticZyFromMonth存储过程查询月报出错'
                    GOTO Err
                END 
            SET @SQL = 'insert into #BB_dbz_szx2(freportdatestr,freportcode,ftykh,fksname,fpx,FKEY,FNAME,FVALUE)
				select ''' + @freportdatestr + ''' as freportdatestr,'''
                + @freportcode
                + ''' as freportcode,max(ftykh),max(fksname),max(fpx),max(FVALUE)
				from BB_dbz_szx2 a where a.freportdatestr in ('
                + @freportdatestrs + ') group by FKEY '
            EXEC(@SQL)
        END
	
	
		
    IF @datetype = 5 
        BEGIN
            SELECT  *
            FROM    #BB_dbz_szx2
            WHERE   ftykh = 'ZZZZZ'
            ORDER BY CAST(fpx AS INT)
		--select * from #BB_dbz_szx2 order by cast(fpx as int),ftykh 
            DROP TABLE #BB_dbz_szx2
            RETURN
        END
    ELSE 
        BEGIN
            BEGIN TRANSACTION 
            DELETE  FROM BB_dbz_szx2
            WHERE   freportdatestr = @freportdatestr
            IF @@error <> 0 
                BEGIN
                    SET @errmsg = '删除原有明细报表出错'
                    GOTO Err
                END 
            DELETE  FROM TZYREPORTMAIN
            WHERE   freportcode = @freportcode
                    AND freporttype = @dateType
                    AND freportdatestr = @freportdatestr
            IF @@error <> 0 
                BEGIN
                    SET @errmsg = '删除原有主报表出错'
                    GOTO Err
                END 
            INSERT  INTO TZYREPORTMAIN
                    ( freportdatestr ,
                      freportstate ,
                      freporttype ,
                      freportcode ,
                      fusername ,
                      ftyyhbh ,
                      fworktime ,
                      FBEGINDATE1 ,
                      FENDDATE1 ,
                      ftykh ,
                      fiffk
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
                            0 
            IF @@error <> 0 
                BEGIN
                    SET @errmsg = '插入主表时数据出错'
                    GOTO Err
                END 
            INSERT  INTO BB_dbz_szx2
                    ( freportcode ,
                      freportdatestr ,
                      fpx ,
                      FKEY ,
                      FNAME ,
                      FVALUE
                    )
                    SELECT  freportcode ,
                            freportdatestr ,
                            fpx ,
                            FKEY ,
                            FNAME ,
                            FVALUE
                    FROM    #BB_dbz_szx2
                    ORDER BY FKEY

            IF @@error <> 0 
                BEGIN
                    SET @errmsg = '动态插入报表数据出错'
                    GOTO Err
                END 
            COMMIT TRAN
            DROP TABLE #BB_dbz_szx2
            SET @errcode = 0
            RETURN     
        END
    Err:
	--回滚事务
    ROLLBACK TRAN
    SET @errcode = 1
    RETURN






