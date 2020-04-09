ALTER PROCEDURE [dbo].[statisticBB_dbz_szx2]
    @freportdatestr VARCHAR(100) ,    	--��������
    @ftykh VARCHAR(30) ,								--ͳһ�ƺ�
    @dateType TINYINT ,    						--��������,1Ϊ"�±�"��2Ϊ"����"��3Ϊ"�걨"��4Ϊ"����ʽ" , 5Ϊ"Ժ���ñ�" 
    @ftyyhbh VARCHAR(30) ,   				 	--ͳһ�û����
    @fusername VARCHAR(30) ,    				--�û�����
    @date1 DATETIME ,    							--���ܵ���ʼ���� '2008-01-01'
    @date2 DATETIME ,    							--���ܵ���ֹ���� '2008-01-01'
    @calendarDay INT = 31 ,    					--��������
    @workDay INT = 31 ,    							--��������
    @week INT = 4 ,    									--����
    @errcode TINYINT OUT ,     				--������Ϣ
    @errmsg VARCHAR(200) OUT    			--��������  
AS --exec statisticBB_dbz_szx2 '2020-01-16','','5','','','2019-04-01','2019-04-30','30','','',null,null
 --������

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
		--1.��Ժ�������˴���
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
                            '��Ժ�������˴���' FNAME ,
                            CONVERT(VARCHAR(10), COUNT(1)) FVALUE
                    FROM    #THQMSSET

		--2.��Ժ��������������
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
                            '��Ժ��������������' FNAME ,
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

		--3.��Ժ΢����������
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
                    '��Ժ΢����������' FNAME ,
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
					AND CHARINDEX('΢��',b.FOPLB)>0

		--4.��Ժ�ļ���������
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
                    '��Ժ�ļ���������' FNAME ,
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
					AND CHARINDEX('�ļ�',b.FOPLB)>0

		--5.��������������
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
                    '��������������' FNAME ,
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

		--6.�����������߲���֢�����˴���
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
                    '�����������߲���֢�����˴���' FNAME ,
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
					AND b.fyscode='��������֢' 
					AND a.C05C=4
		
		--7.I���п�����������
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
                    'I���п�����������' FNAME ,
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

		--8.I���п������ܸ�Ⱦ����
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
                    'I���п������ܸ�Ⱦ����' FNAME ,
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

		--������
		--9.�����ļ���������������
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
                    '�����ļ���������������' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C03C,3)='I21'

		--10.�����ļ�������Ժ����ռ���ܴ�����
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
                    '�����ļ�������Ժ����ռ���ܴ�����' FNAME ,
                    CONVERT(VARCHAR(10), SUM(CONVERT(INT,B20))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C03C,3)='I21'

		--11.�����ļ�����ƽ��סԺ��
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
                    '�����ļ�����ƽ��סԺ��' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),B20)))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C03C,3)='I21'

		--12.�����ļ�������סԺ����
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
                    '�����ļ�������סԺ����' FNAME ,
                    CONVERT(VARCHAR(50), SUM((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C03C,3)='I21'

		--13.�����ļ������ξ�����
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
                    '�����ļ������ξ�����' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C03C,3)='I21'

		--14.�����ļ�����������
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
                    '�����ļ�����������' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C03C,3)='I21'
					AND B34C=5

		--15.����˥������������
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
                    '����˥������������' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C03C,5)='I11.0' OR LEFT(C03C,5)='I13.0' OR LEFT(C03C,5)='I13.2' OR LEFT(C03C,3)='I50'

		--16.����˥�߳�Ժ����ռ���ܴ�����
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
                    '����˥�߳�Ժ����ռ���ܴ�����' FNAME ,
                    CONVERT(VARCHAR(10), SUM(CONVERT(INT,B20))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C03C,5)='I11.0' OR LEFT(C03C,5)='I13.0' OR LEFT(C03C,5)='I13.2' OR LEFT(C03C,3)='I50'

		--17.����˥��ƽ��סԺ��
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
                    '����˥��ƽ��סԺ��' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),B20)))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C03C,5)='I11.0' OR LEFT(C03C,5)='I13.0' OR LEFT(C03C,5)='I13.2' OR LEFT(C03C,3)='I50'

		--18.����˥����סԺ����
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
                    '����˥����סԺ����' FNAME ,
                    CONVERT(VARCHAR(50), SUM((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C03C,5)='I11.0' OR LEFT(C03C,5)='I13.0' OR LEFT(C03C,5)='I13.2' OR LEFT(C03C,3)='I50'

		--19.����˥�ߴξ�����
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
                    '����˥�ߴξ�����' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C03C,5)='I11.0' OR LEFT(C03C,5)='I13.0' OR LEFT(C03C,5)='I13.2' OR LEFT(C03C,3)='I50'

		--20.����˥����������
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
                    '����˥����������' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE  ( LEFT(C03C,5)='I11.0' OR LEFT(C03C,5)='I13.0' OR LEFT(C03C,5)='I13.2' OR LEFT(C03C,3)='I50' )
					AND B34C=5

		--21.����(����)����������
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
                    '����(����)����������' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE   ( LEFT(C03C,3)='J13' OR LEFT(C03C,3)='J14' OR LEFT(C03C,3)='J15' OR LEFT(C03C,3)='J18' )
					AND A14 >=18

		--22.����(����)��Ժ����ռ���ܴ�����
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
                    '����(����)��Ժ����ռ���ܴ�����' FNAME ,
                    CONVERT(VARCHAR(10), SUM(CONVERT(INT,B20))) FVALUE
            FROM    #THQMSSET a
            WHERE   ( LEFT(C03C,3)='J13' OR LEFT(C03C,3)='J14' OR LEFT(C03C,3)='J15' OR LEFT(C03C,3)='J18' )
					AND A14 >=18

		--23.����(����)ƽ��סԺ��
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
                    '����(����)ƽ��סԺ��' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),B20)))) FVALUE
            FROM    #THQMSSET a
            WHERE   ( LEFT(C03C,3)='J13' OR LEFT(C03C,3)='J14' OR LEFT(C03C,3)='J15' OR LEFT(C03C,3)='J18' )
					AND A14 >=18

		--24.����(����)��סԺ����
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
                    '����(����)��סԺ����' FNAME ,
                    CONVERT(VARCHAR(50), SUM((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE   ( LEFT(C03C,3)='J13' OR LEFT(C03C,3)='J14' OR LEFT(C03C,3)='J15' OR LEFT(C03C,3)='J18' )
					AND A14 >=18

		--25.����(����)�ξ�����
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
                    '����(����)�ξ�����' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE   ( LEFT(C03C,3)='J13' OR LEFT(C03C,3)='J14' OR LEFT(C03C,3)='J15' OR LEFT(C03C,3)='J18' )
					AND A14 >=18

		--26.����(����)��������
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
                    '����(����)��������' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE  ( LEFT(C03C,3)='J13' OR LEFT(C03C,3)='J14' OR LEFT(C03C,3)='J15' OR LEFT(C03C,3)='J18' )
					AND A14 >=18
					AND B34C=5

		--27.����(��ͯ)����������
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
                    '����(��ͯ)����������' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE   (LEFT(C03C,3)='J13' OR LEFT(C03C,3)='J14' OR LEFT(C03C,3)='J15' OR LEFT(C03C,3)='J18')
					AND A14 >1 
					AND A14 < 18

		--28.����(��ͯ)��Ժ����ռ���ܴ�����
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
                    '����(��ͯ)��Ժ����ռ���ܴ�����' FNAME ,
                    CONVERT(VARCHAR(10), SUM(CONVERT(INT,B20))) FVALUE
            FROM    #THQMSSET a
            WHERE   (LEFT(C03C,3)='J13' OR LEFT(C03C,3)='J14' OR LEFT(C03C,3)='J15' OR LEFT(C03C,3)='J18')
					AND A14 >1 
					AND A14 < 18

		--29.����(��ͯ)ƽ��סԺ��
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
                    '����(��ͯ)ƽ��סԺ��' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),B20)))) FVALUE
            FROM    #THQMSSET a
            WHERE   (LEFT(C03C,3)='J13' OR LEFT(C03C,3)='J14' OR LEFT(C03C,3)='J15' OR LEFT(C03C,3)='J18')
					AND A14 >1 
					AND A14 < 18

		--30.����(��ͯ)��סԺ����
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
                    '����(��ͯ)��סԺ����' FNAME ,
                    CONVERT(VARCHAR(50), SUM((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE   (LEFT(C03C,3)='J13' OR LEFT(C03C,3)='J14' OR LEFT(C03C,3)='J15' OR LEFT(C03C,3)='J18')
					AND A14 >1 
					AND A14 < 18

		--31.����(��ͯ)�ξ�����
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
                    '����(��ͯ)�ξ�����' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE   (LEFT(C03C,3)='J13' OR LEFT(C03C,3)='J14' OR LEFT(C03C,3)='J15' OR LEFT(C03C,3)='J18')
					AND A14 >1 
					AND A14 < 18

		--32.����(��ͯ)��������
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
                    '����(��ͯ)��������' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE  (LEFT(C03C,3)='J13' OR LEFT(C03C,3)='J14' OR LEFT(C03C,3)='J15' OR LEFT(C03C,3)='J18')
					AND A14 >1 
					AND A14 < 18
					AND B34C=5

		--33.�Թ�������������
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
                    '�Թ�������������' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C03C,3)='I63'
					AND NOT ( LEFT(C03C,7)='I63.301' OR LEFT(C03C,7)='I63.302' OR LEFT(C03C,7)='I63.401' OR LEFT(C03C,7)='I63.801' OR LEFT(C03C,7)='I63.802' )

		--34.�Թ�����Ժ����ռ���ܴ�����
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
                    '�Թ�����Ժ����ռ���ܴ�����' FNAME ,
                    CONVERT(VARCHAR(10), SUM(CONVERT(INT,B20))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C03C,3)='I63'
					AND NOT ( LEFT(C03C,7)='I63.301' OR LEFT(C03C,7)='I63.302' OR LEFT(C03C,7)='I63.401' OR LEFT(C03C,7)='I63.801' OR LEFT(C03C,7)='I63.802' )

		--35.�Թ���ƽ��סԺ��
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
                    '�Թ���ƽ��סԺ��' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),B20)))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C03C,3)='I63'
					AND NOT ( LEFT(C03C,7)='I63.301' OR LEFT(C03C,7)='I63.302' OR LEFT(C03C,7)='I63.401' OR LEFT(C03C,7)='I63.801' OR LEFT(C03C,7)='I63.802' )

		--36.�Թ�����סԺ����
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
                    '�Թ�����סԺ����' FNAME ,
                    CONVERT(VARCHAR(50), SUM((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C03C,3)='I63'
					AND NOT ( LEFT(C03C,7)='I63.301' OR LEFT(C03C,7)='I63.302' OR LEFT(C03C,7)='I63.401' OR LEFT(C03C,7)='I63.801' OR LEFT(C03C,7)='I63.802' )

		--37.�Թ����ξ�����
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
                    '�Թ����ξ�����' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C03C,3)='I63'
					AND NOT ( LEFT(C03C,7)='I63.301' OR LEFT(C03C,7)='I63.302' OR LEFT(C03C,7)='I63.401' OR LEFT(C03C,7)='I63.801' OR LEFT(C03C,7)='I63.802' )

		--38.�Թ�����������
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
                    '�Թ�����������' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C03C,3)='I63'
					AND NOT ( LEFT(C03C,7)='I63.301' OR LEFT(C03C,7)='I63.302' OR LEFT(C03C,7)='I63.401' OR LEFT(C03C,7)='I63.801' OR LEFT(C03C,7)='I63.802' )
					AND B34C=5

		--39.�Źؽ��û�������������
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
                    '�Źؽ��û�������������' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C14x01C,7)='81.5100' OR LEFT(C14x01C,7)='81.5200'

		--40.�Źؽ��û�����Ժ����ռ���ܴ�����
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
                    '�Źؽ��û�����Ժ����ռ���ܴ�����' FNAME ,
                    CONVERT(VARCHAR(10), SUM(CONVERT(INT,B20))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C14x01C,7)='81.5100' OR LEFT(C14x01C,7)='81.5200'

		--41.�Źؽ��û���ƽ��סԺ��
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
                    '�Źؽ��û���ƽ��סԺ��' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),B20)))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C14x01C,7)='81.5100' OR LEFT(C14x01C,7)='81.5200'

		--42.�Źؽ��û�����סԺ����
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
                    '�Źؽ��û�����סԺ����' FNAME ,
                    CONVERT(VARCHAR(50), SUM((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C14x01C,7)='81.5100' OR LEFT(C14x01C,7)='81.5200'

		--43.�Źؽ��û����ξ�����
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
                    '�Źؽ��û����ξ�����' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C14x01C,7)='81.5100' OR LEFT(C14x01C,7)='81.5200'

		--44.�Źؽ��û�����������
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
                    '�Źؽ��û�����������' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE   ( LEFT(C14x01C,7)='81.5100' OR LEFT(C14x01C,7)='81.5200' )
					AND B34C=5

		--45.ϥ�ؽ��û�������������
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
                    'ϥ�ؽ��û�������������' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C14x01C,5)='81.54'

		--46.ϥ�ؽ��û�����Ժ����ռ���ܴ�����
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
                    'ϥ�ؽ��û�����Ժ����ռ���ܴ�����' FNAME ,
                    CONVERT(VARCHAR(10), SUM(CONVERT(INT,B20))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C14x01C,5)='81.54'

		--47.ϥ�ؽ��û���ƽ��סԺ��
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
                    'ϥ�ؽ��û���ƽ��סԺ��' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),B20)))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C14x01C,5)='81.54'

		--48.ϥ�ؽ��û�����סԺ����
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
                    'ϥ�ؽ��û�����סԺ����' FNAME ,
                    CONVERT(VARCHAR(50), SUM((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C14x01C,5)='81.54'

		--49.ϥ�ؽ��û����ξ�����
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
                    'ϥ�ؽ��û����ξ�����' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C14x01C,5)='81.54'

		--50.ϥ�ؽ��û�����������
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
                    'ϥ�ؽ��û�����������' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C14x01C,5)='81.54'
					AND B34C=5

		--51.��״������·��ֲ������������
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
                    '��״������·��ֲ������������' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C14x01C,4)='36.1'

		--52.��״������·��ֲ����Ժ����ռ���ܴ�����
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
                    '��״������·��ֲ����Ժ����ռ���ܴ�����' FNAME ,
                    CONVERT(VARCHAR(10), SUM(CONVERT(INT,B20))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C14x01C,4)='36.1'

		--53.��״������·��ֲ��ƽ��סԺ��
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
                    '��״������·��ֲ��ƽ��סԺ��' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),B20)))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C14x01C,4)='36.1'

		--54.��״������·��ֲ����סԺ����
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
                    '��״������·��ֲ����סԺ����' FNAME ,
                    CONVERT(VARCHAR(50), SUM((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C14x01C,4)='36.1'

		--55.��״������·��ֲ���ξ�����
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
                    '��״������·��ֲ���ξ�����' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C14x01C,4)='36.1'

		--56.��״������·��ֲ����������
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
                    '��״������·��ֲ����������' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE   LEFT(C14x01C,4)='36.1'
					AND B34C=5

		--57.�ʹ�������������
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
                    '�ʹ�������������' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE   ( LEFT(C14x01C,4)='74.0' OR LEFT(C14x01C,4)='74.1' OR LEFT(C14x01C,4)='74.2' )

		--58.�ʹ�����Ժ����ռ���ܴ�����
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
                    '�ʹ�����Ժ����ռ���ܴ�����' FNAME ,
                    CONVERT(VARCHAR(10), SUM(CONVERT(INT,B20))) FVALUE
            FROM    #THQMSSET a
            WHERE   ( LEFT(C14x01C,4)='74.0' OR LEFT(C14x01C,4)='74.1' OR LEFT(C14x01C,4)='74.2' )

		--59.�ʹ���ƽ��סԺ��
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
                    '�ʹ���ƽ��סԺ��' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),B20)))) FVALUE
            FROM    #THQMSSET a
            WHERE   ( LEFT(C14x01C,4)='74.0' OR LEFT(C14x01C,4)='74.1' OR LEFT(C14x01C,4)='74.2' )

		--60.�ʹ�����סԺ����
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
                    '�ʹ�����סԺ����' FNAME ,
                    CONVERT(VARCHAR(50), SUM((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE   ( LEFT(C14x01C,4)='74.0' OR LEFT(C14x01C,4)='74.1' OR LEFT(C14x01C,4)='74.2' )

		--61.�ʹ����ξ�����
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
                    '�ʹ����ξ�����' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE  ( LEFT(C14x01C,4)='74.0' OR LEFT(C14x01C,4)='74.1' OR LEFT(C14x01C,4)='74.2' )

		--62.�ʹ�����������
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
                    '�ʹ�����������' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE   ( LEFT(C14x01C,4)='74.0' OR LEFT(C14x01C,4)='74.1' OR LEFT(C14x01C,4)='74.2' )
					AND B34C=5

		--63.���������Էμ�������������
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
                    '���������Էμ�������������' FNAME ,
                    CONVERT(VARCHAR(10), COUNT(1)) FVALUE
            FROM    #THQMSSET a
            WHERE   ( LEFT(C03C,5)='J44.0' OR LEFT(C03C,5)='J44.1' OR LEFT(C03C,5)='J44.9' )

		--64.���������Էμ�����Ժ����ռ���ܴ�����
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
                    '���������Էμ�����Ժ����ռ���ܴ�����' FNAME ,
                    CONVERT(VARCHAR(10), SUM(CONVERT(INT,B20))) FVALUE
            FROM    #THQMSSET a
            WHERE   ( LEFT(C03C,5)='J44.0' OR LEFT(C03C,5)='J44.1' OR LEFT(C03C,5)='J44.9' )

		--65.���������Էμ���ƽ��סԺ��
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
                    '���������Էμ���ƽ��סԺ��' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),B20)))) FVALUE
            FROM    #THQMSSET a
            WHERE   ( LEFT(C03C,5)='J44.0' OR LEFT(C03C,5)='J44.1' OR LEFT(C03C,5)='J44.9' )

		--66.���������Էμ�����סԺ����
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
                    '���������Էμ�����סԺ����' FNAME ,
                    CONVERT(VARCHAR(50), SUM((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE   ( LEFT(C03C,5)='J44.0' OR LEFT(C03C,5)='J44.1' OR LEFT(C03C,5)='J44.9' )

		--67.���������Էμ����ξ�����
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
                    '���������Էμ����ξ�����' FNAME ,
                    CONVERT(VARCHAR(50), AVG((CONVERT(NUMERIC(10,2),D01)))) FVALUE
            FROM    #THQMSSET a
            WHERE  ( LEFT(C03C,5)='J44.0' OR LEFT(C03C,5)='J44.1' OR LEFT(C03C,5)='J44.9' )

		--68.���������Էμ�����������
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
                    '���������Էμ�����������' FNAME ,
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
                    SET @errmsg = '����statisticZyFromMonth�洢���̲�ѯ�±�����'
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
                    SET @errmsg = 'ɾ��ԭ����ϸ�������'
                    GOTO Err
                END 
            DELETE  FROM TZYREPORTMAIN
            WHERE   freportcode = @freportcode
                    AND freporttype = @dateType
                    AND freportdatestr = @freportdatestr
            IF @@error <> 0 
                BEGIN
                    SET @errmsg = 'ɾ��ԭ�����������'
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
                    SET @errmsg = '��������ʱ���ݳ���'
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
                    SET @errmsg = '��̬���뱨�����ݳ���'
                    GOTO Err
                END 
            COMMIT TRAN
            DROP TABLE #BB_dbz_szx2
            SET @errcode = 0
            RETURN     
        END
    Err:
	--�ع�����
    ROLLBACK TRAN
    SET @errcode = 1
    RETURN






