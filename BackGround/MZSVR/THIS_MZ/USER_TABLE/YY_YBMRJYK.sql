if not exists(select 1 from sysobjects where name='YY_YBMRJYK')
begin
	CREATE TABLE [dbo].[YY_YBMRJYK]
	(
		[xh] [dbo].[ut_xh12] NOT NULL IDENTITY(1, 1),--���
		[syxh] [dbo].[ut_syxh] NOT NULL,--��ҳ���
		[centerid] [dbo].[ut_lsh] NULL,--����סԺ�ǼǺ�
		[jsxh] [dbo].[ut_xh12] NOT NULL,--�������
		[fyrq] [dbo].[ut_rq8] NOT NULL,--Ԥ������
		[jlzt] [dbo].[ut_bz] NULL,---��¼״̬ 0 ʧ�� 1�ɹ�
		[yjlj] [dbo].[ut_money] NULL,--Ѻ���ۼ�
		[zje] [dbo].[ut_money] NULL,--�ܽ��
		[yhje] [dbo].[ut_money] NULL,--�Żݽ��
		[zfyje] [dbo].[ut_money] NULL,--�Էѽ��
		[ybje] [dbo].[ut_money] NULL,--ҽ�����
		[jsxjzf] [dbo].[ut_money] NULL,--�ֽ�֧��
		[jszhzf] [dbo].[ut_money] NULL,--�˻�֧��
		[jstczf] [dbo].[ut_money] NULL,--ͳ��֧��
		[jsdbzf] [dbo].[ut_money] NULL,--���㵥����֧��
		[jsgwybz] [dbo].[ut_money] NULL,---����Ա����
		[jsgwyret] [dbo].[ut_money] NULL,---����Ա����
		[mzjzje] [dbo].[ut_money] NULL,----��������
		[mzjzmzye] [dbo].[ut_money] NULL----�����������
	) ON [PRIMARY]
	ALTER TABLE [dbo].[YY_YBMRJYK] ADD CONSTRAINT [PK_YY_YBMRJYK] PRIMARY KEY CLUSTERED ([syxh], [jsxh], [fyrq]) WITH (FILLFACTOR=100) ON [PRIMARY]
END
GO

