ALTER procedure usp_bb_yb_syybbb_zy_fytj  
 @ksrq ut_rq8, ---ͳ������      
 @jsrq ut_rq8, ----�������� 
 @yydm ut_dm5     
as--��77409 2010-07-29 16:47:34 4.0��׼�� 201007 ��������128      
/**********      
[�汾��]4.0.0.0.0      
[����ʱ��]2004.11.19      
[����]��ΰ��      
[��Ȩ] Copyright ? 2004-2008�Ϻ����˴�-��������ɷ����޹�˾[����] סԺϵͳ--�����Ǽ�      
[����˵��]      
 ��Ժ���������Ǽ�      
[����˵��]      
     --Add In : 2005-06-04  By : Koala For :���ӽ贲����      
@ksrq ut_rq8 ͳ������      
      
[����ֵ]      
      
[�����������]      
 �ɹ���"T"      
 ����"F","������Ϣ"      
      
[���õ�sp]      
      
[����ʵ��]      
exec usp_bb_yb_syybbb_zy '20150201','20150228'      
      
[�޸�˵��]      
      
**********/      
set nocount on      

SELECT f.name '��������',SUM(d.je) '���'
FROM dbo.YY_CQYB_ZYJZJLK a (NOLOCK)
	INNER JOIN dbo.YY_CQYB_ZYJSJLK b (NOLOCK) ON a.syxh=b.syxh
	INNER JOIN dbo.ZY_BRJSK c (NOLOCK) ON b.jsxh=c.xh
	INNER JOIN dbo.ZY_BRJSJEK d (NOLOCK) ON c.xh=d.jsxh
	INNER JOIN dbo.YY_KSBMK e (NOLOCK) ON c.ksdm=e.id
	INNER JOIN dbo.YY_CQYB_YBSJZD f (NOLOCK) ON b.sylb=f.code
WHERE c.jsrq BETWEEN @ksrq AND @jsrq+'24'
AND c.ybjszt=2
AND e.yydm=@yydm
AND a.xzlb=3
AND a.cblb=1
AND f.zdlb = 'SYLB' AND f.xtbz = 1
AND d.lx='yb24'
AND c.jlzt IN (0,1)
GROUP BY f.name

RETURN