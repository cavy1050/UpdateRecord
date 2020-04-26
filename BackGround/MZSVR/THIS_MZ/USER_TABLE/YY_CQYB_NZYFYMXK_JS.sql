--ҽ��סԺ�����¼������ϸ��Ϣ(���)
if not exists(select 1 from sysobjects where name='YY_CQYB_NZYFYMXK_JS')
begin
	create table YY_CQYB_NZYFYMXK_JS
	(   
		syxh			ut_syxh		not null,	--��ҳ���
		jsxh			ut_xh12		not null,	--�������
		xh				ut_xh12		not null,	--��ϸ���
		txh				ut_xh12		not	null,	--����ϸ���
		cfh				ut_xh12		    null,	--������
		cfrq			ut_rq16			null,	--��������
		idm				ut_xh9			null,	--ҩƷidm
		xmdm			ut_xmdm			null,	--��Ŀ����
		xmmc			ut_mc64			null,	--��Ŀ����
		xmgg			ut_mc32			null,	--���
		xmdj			ut_money		null,	--����
		xmsl			ut_sl10			null,	--����
		xmdw			ut_unit			null,	--��λ
		xmje			ut_money	    null,	--���		
		ksdm			ut_ksdm			null,	--���Ҵ���
		ysdm			ut_czyh			null,	--ҽ������
		jbr				ut_czyh			null,	--������
		jzbz			varchar(3)      null,	--�����־		
		zzfbz			varchar(10)		null,   --ת�Էѱ�ʶ
		ktsl			ut_sl10			null,	--��������
		ktje			ut_money		null,	--���˽��
		spbz			ut_bz			null,	--ҽԺ���շ�������־0δ����1����ͨ��2������ͨ��
		spclbz			ut_bz			null,	--ҽԺ���շѴ����־(����21�Ž���)0δ����1�Ѵ���
		qzfbz			ut_bz			null,	--ҽԺȫ�Էѱ�־0��������1ȫ�Է�
		ybscbz			ut_bz			null,	--ҽ���ϴ���־0δ�ϴ�1���ϴ�2�����ϴ� 3���ϴ���������������4�����˺��������ϴ�  5 ����������ϴ��Ͳ����˺��ϴ�				
		zxlsh			varchar(20)     null,	--������ϸ��ˮ��
		ybxmdj			numeric(10,4)	null,	--ҽ����Ŀ����
		ybspbz			varchar(10)		null,	--ҽ��������־ 1 ���շ����� 2 ѪҺ�׵�������
		ybzje			numeric(10,4)	null,	--ҽ���ܽ��
		sfxmdj			varchar(10)		null,	--�շ���Ŀ�ȼ�
		ybzfbl			numeric(5,4)	null,	--ҽ���Ը�����
		ybbzdj			numeric(10,4)	null,	--ҽ����׼����
		ybzfje			numeric(10,4)	null,	--ҽ���Ը����
		ybzlje			numeric(10,4)	null,	--ҽ���Էѽ��
		dydm            VARCHAR(32)     null,   --�ϴ���ҽ����ˮ��
		scxmdj			ut_money		null,	--�ϴ�����
		scxmsl			ut_sl10			null,	--�ϴ�����
		scxmje			ut_money	    null	--�ϴ����
		constraint PK_YY_CQYB_NZYFYMXK_JS primary key(xh,jsxh)
	)
	create index idx_syxh on YY_CQYB_NZYFYMXK_JS(syxh)
	create index idx_jsxh on YY_CQYB_NZYFYMXK_JS(jsxh)
	create index idx_xh on YY_CQYB_NZYFYMXK_JS(xh)
	create index idx_txh on YY_CQYB_NZYFYMXK_JS(txh)
	create index idx_cfh on YY_CQYB_NZYFYMXK_JS(cfh)
end;
GO

