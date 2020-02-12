ALTER PROC usp_yb_tybb_ybzfxx    
@ksrq ut_rq8,        
@jsrq ut_rq8    
AS    
    
--add by yangdi 2019.12.7 ҽ���ӿ������������½ӿ�.    
    
SET NOCOUNT ON    
    
CREATE TABLE #YB_YBZFXX     
(    
 syxh   ut_xh12 NOT NULL,    
 jsxh   ut_xh12 NOT NULL,    
 blh    ut_blh,    
 hzxm   ut_mc64,    
 sex    ut_sex,    
 ksdm   ut_ksdm,    
 ksmc   ut_mc64,    
 jzsj   VARCHAR(19),    
 sfzh   ut_sfzh,    
 jsczyh ut_czyh,    
 sybkh  VARCHAR(20),    
 sybzyh VARCHAR(20),    
 cblb   ut_bz,    
 xzlb   ut_bz,    
 zje    numeric(9,2) DEFAULT 0,    
 xjzf   numeric(9,2) DEFAULT 0,    
 zfzf   numeric(9,2) DEFAULT 0,    
 tczf   numeric(9,2) DEFAULT 0,    
 gwybz  numeric(9,2) DEFAULT 0,    
 delp   numeric(9,2) DEFAULT 0,    
 ybsr   numeric(9,2) DEFAULT 0,    
 mzjz   numeric(9,2) DEFAULT 0,    
 syjjzf numeric(9,2) DEFAULT 0,    
 syxjzf numeric(9,2) DEFAULT 0,    
 zfdy   numeric(9,2) DEFAULT 0,    
 ydbxje numeric(9,2) DEFAULT 0,
)    

INSERT INTO #YB_YBZFXX 
EXEC usp_yb_ty_ybzfxx  @ksrq, @jsrq

SELECT syxh '��ҳ���',jsxh '�������',sybzyh 'ҽ��סԺ��',    
  blh 'סԺ��',hzxm '����',sex '�Ա�',sfzh '���֤��',ksmc '��������',    
   jzsj '����ʱ��',jsczyh '�������Ա',    
       CASE WHEN cblb=1 THEN 'ְ��' WHEN cblb=2 THEN '����' WHEN cblb=3 THEN '����' END '�α����',    
     zje '�ܽ��',    
     xjzf '�ֽ�֧��',zfzf '�˻�֧��',tczf 'ͳ��֧��',delp '���������',gwybz '����Ա����',    
      mzjz '��������',ybsr 'ҽ������',      
             syjjzf '��������֧��',zfdy '�˻�����',ydbxje '��ر����ܶ�'    
FROM #YB_YBZFXX    
    
RETURN 

