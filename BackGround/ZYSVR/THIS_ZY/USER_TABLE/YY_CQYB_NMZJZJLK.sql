--ҽ������Ǽ���Ϣ(���)
if not exists(select 1 from sysobjects where name='YY_CQYB_NMZJZJLK')
begin  
	create table YY_CQYB_NMZJZJLK
	(      
        jssjh			ut_sjh		not	null,	--�վݺ�
        sbkh            varchar(20)	not	null,	--��ᱣ�Ϻ���
        xzlb            ut_bz			null,   --�������
        cblb            ut_bz			null,   --�α����
        jzlsh           varchar(20)	not	null,	--סԺ(������)��
        zgyllb          varchar(10)	    null,   --ҽ�����
        ksdm            ut_ksdm			null,   --���Ҵ���
        ysdm            ut_czyh			null,   --ҽ������
        ryrq            varchar(10)		null,   --��Ժ����
        ryzd            varchar(20)		null,	--��Ժ���
        cyrq			varchar(10)		null,	--��Ժ����
        cyzd			varchar(20)		null,	--��Ժ��� 
        cyyy			varchar(10)		null,	--��Ժԭ��
        bfzinfo         varchar(200)	null,	--����֢��Ϣ
        jzzzysj         varchar(10)		null,	--����תסԺʱ��
        bah             varchar(20)		null,   --������
        syzh            varchar(20)		null,   --����֤��
        xsecsrq         varchar(10)		null,	--��������������
        jmyllb          varchar(10)		null,   --�������������
        gsgrbh          varchar(10)		null,   --���˸��˱��
        gsdwbh          varchar(10)		null,   --���˵�λ���
        zryydm			varchar(14)		null,	--ת��ҽԺ����
        jlzt			ut_bz		not null,	--��¼״̬0¼��1�Ǽ�2ҽ������3�Ǽǳ���        
        zxlsh           varchar(20)		null,   --������ˮ��
	)
	create index idx_jssjh on YY_CQYB_NMZJZJLK(jssjh)	
	create index idx_sbkh on YY_CQYB_NMZJZJLK(sbkh)	
end
go

