--ҽ�������˻�������Ϣ
if not exists(select 1 from sysobjects where name='YY_CQYB_ACCINFO')
begin  
	create table YY_CQYB_ACCINFO
	(      
        sbkh			varchar(20)	not	null,	--��ᱣ�Ϻ���
        --ҽ�Ʊ��շ��ز���
        zhye			ut_money		null,   --�˻����
        bntczflj		ut_money		null,   --����ͳ��֧���ۼ�
        bntsmzqfbzljzf  ut_money		null,	--�������������𸶱�׼֧���ۼ�
        bntsmzybflj		ut_money		null,   --������������ҽ�����ۼ�
        bnexzlzyqfbzzflj ut_money		null,	--�����������סԺ�𸶱�׼֧���ۼ�
        bnfhgwyfwmzfylj ut_money		null,	--������Ϲ���Ա��Χ��������ۼ�
        bnzycs			varchar(10)		null,   --����סԺ����
        zyzt			varchar(2)		null,   --סԺ״̬
        bntbmzxbzzfje   ut_money		null,	--�����ز����ﻹ�貹�����Ը����
        bnzyxbzzfje		ut_money		null,   --����סԺ���貹�����Ը����
        bnfsgexzlbz		varchar(10)		null,   --���귢��������������־
        bndbzflj		ut_money		null,   --�����֧���ۼ�
        jbzdjbfsbz		varchar(10)		null,   --�ӱ��ش󼲲�������־
        bnywshzflj		ut_money		null,   --���������˺�֧���ۼ�
        bnndyjhzflj		ut_money		null,   --�����Ͷ�ҩ���֧���ۼ�
        bnetlbzflj		ut_money		null,   --�����ͯ����֧���ۼ�
        bnkfxmzflj		ut_money		null,   --���꿵����Ŀ֧���ۼ�
        ndmzzyzflj		ut_money		null,   --�������סԺ֧���ۼ�
        ndmzmzzflj		ut_money		null,   --�����������֧���ۼ�
        jxbzlj			ut_money		null,   --���������ۼ�
        ndptmzzflj		ut_money		null,   --�����ͨ����֧���ۼ�
        yddjbz			varchar(10)		null,   --��صǼǱ�־
        zhxxyly			ut_money		null,   --�˻���ϢԤ��1
        zhxxyle			ut_money		null,   --�˻���ϢԤ��2
        --���˱��շ��ز���
        cfxmtslj		ut_money		null,   --������Ŀ�����ۼ�
        gszyzt			varchar(2)		null,   --����סԺ״̬
        --�������շ��ز���
        byqcqjczflj		ut_money		null,   --�����ڲ�ǰ���֧���ۼ�
        byqycbjyjczflj  ut_money		null,   --�������Ŵ������֧���ۼ�
        byqjhsysszflj   ut_money		null,	--�����ڼƻ���������֧���ۼ�
        byqfmzzrsylfzflj ut_money    	null,   --�����ڷ������ֹ����ҽ�Ʒ�֧���ۼ�
        byqbfzzflj		ut_money		null,   --�����ڲ���֢֧���ۼ�
        syzyzt			varchar(2)		null,   --����סԺ״̬        
		constraint PK_YY_CQYB_ACCINFO primary key(sbkh)
	)
	create index idx_sbkh on YY_CQYB_ACCINFO(sbkh)	
end
go 

