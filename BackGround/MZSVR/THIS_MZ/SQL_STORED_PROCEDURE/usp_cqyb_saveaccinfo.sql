if exists(select 1 from sysobjects where name = 'usp_cqyb_saveaccinfo')
  drop proc usp_cqyb_saveaccinfo
go

CREATE proc usp_cqyb_saveaccinfo
(
	@sbkh				varchar(20),		--��ᱣ�Ϻ���
	@xzlb				varchar(10),		--�������
    --ҽ�Ʊ��շ��ز���
    @zhye				ut_money=0,			--�˻����
    @bntczflj			ut_money=0,			--����ͳ��֧���ۼ�
    @bntsmzqfbzljzf		ut_money=0,			--�������������𸶱�׼֧���ۼ�
    @bntsmzybflj		ut_money=0,			--������������ҽ�����ۼ�
    @bnexzlzyqfbzzflj	ut_money=0,			--�����������סԺ�𸶱�׼֧���ۼ�
    @bnfhgwyfwmzfylj	ut_money=0,			--������Ϲ���Ա��Χ��������ۼ�
    @bnzycs				varchar(10)='',		--����סԺ����
    @zyzt				varchar(2)='',		--סԺ״̬
    @bntbmzxbzzfje		ut_money=0,			--�����ز����ﻹ�貹�����Ը����
    @bnzyxbzzfje		ut_money=0,			--����סԺ���貹�����Ը����
    @bnfsgexzlbz		varchar(10)='',		--���귢��������������־
    @bndbzflj			ut_money=0,			--�����֧���ۼ�
    @jbzdjbfsbz			varchar(10)='',		--�ӱ��ش󼲲�������־
    @bnywshzflj			ut_money=0,			--���������˺�֧���ۼ�
    @bnndyjhzflj		ut_money=0,			--�����Ͷ�ҩ���֧���ۼ�
    @bnetlbzflj			ut_money=0,			--�����ͯ����֧���ۼ�
    @bnkfxmzflj			ut_money=0,			--���꿵����Ŀ֧���ۼ�
    @ndmzzyzflj			ut_money=0,			--�������סԺ֧���ۼ�
    @ndmzmzzflj			ut_money=0,			--�����������֧���ۼ�
    @jxbzlj				ut_money=0,			--���������ۼ�
    @ndptmzzflj			ut_money=0,			--�����ͨ����֧���ۼ�
    @yddjbz				varchar(10)='',		--��صǼǱ�־
    @zhxxyly			ut_money=0,			--�˻���ϢԤ��1
    @zhxxyle			ut_money=0,			--�˻���ϢԤ��2
    --���˱��շ��ز���
    @cfxmtslj			ut_money=0,			--������Ŀ�����ۼ�
    @gszyzt				varchar(2)='',		--����סԺ״̬
    --�������շ��ز���
    @byqcqjczflj		ut_money=0,			--�����ڲ�ǰ���֧���ۼ�
    @byqycbjyjczflj		ut_money=0,			--�������Ŵ������֧���ۼ�
    @byqjhsysszflj		ut_money=0,			--�����ڼƻ���������֧���ۼ�
    @byqfmzzrsylfzflj	ut_money=0,			--�����ڷ������ֹ����ҽ�Ʒ�֧���ۼ�
    @byqbfzzflj			ut_money=0,			--�����ڲ���֢֧���ۼ�
    @syzyzt				varchar(2)=''		--����סԺ״̬
)
as
/****************************************
[�汾��]4.0.0.0.0
[����ʱ��]2017.03.05
[����]FerryMan
[��Ȩ]Copyright ? 1998-2017���������Ƽ����Źɷ����޹�˾
[����]����ҽ�������˻�������Ϣ
[����˵��]
	 ����ҽ�������˻�������Ϣ
[����˵��]
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��]
[�޸ļ�¼]
****************************************/
set nocount on
	
if not exists(select 1 from YY_CQYB_ACCINFO where sbkh = @sbkh)
begin
	if @xzlb = '1'			--ҽ�Ʊ���
	begin
		insert into YY_CQYB_ACCINFO(sbkh,zhye,bntczflj,bntsmzqfbzljzf,bntsmzybflj,bnexzlzyqfbzzflj,bnfhgwyfwmzfylj,bnzycs,zyzt,bntbmzxbzzfje,
			bnzyxbzzfje,bnfsgexzlbz,bndbzflj,jbzdjbfsbz,bnywshzflj,bnndyjhzflj,bnetlbzflj,bnkfxmzflj,ndmzzyzflj,ndmzmzzflj,jxbzlj,ndptmzzflj,
			yddjbz,zhxxyly,zhxxyle)
		select @sbkh,@zhye,@bntczflj,@bntsmzqfbzljzf,@bntsmzybflj,@bnexzlzyqfbzzflj,@bnfhgwyfwmzfylj,@bnzycs,@zyzt,@bntbmzxbzzfje,@bnzyxbzzfje,
			@bnfsgexzlbz,@bndbzflj,@jbzdjbfsbz,@bnywshzflj,@bnndyjhzflj,@bnetlbzflj,@bnkfxmzflj,@ndmzzyzflj,@ndmzmzzflj,@jxbzlj,@ndptmzzflj,
			@yddjbz,@zhxxyly,@zhxxyle 
		if @@error<>0 or @@rowcount = 0 
		begin
			select "F","����ҽ������(ҽ�Ʊ���)�˻�������Ϣʧ��!"
			return
		end;
	end
	else if @xzlb = '2'		--���˱���
	begin
		insert into YY_CQYB_ACCINFO(sbkh,cfxmtslj,gszyzt)
		select @sbkh,@cfxmtslj,@gszyzt
		if @@error<>0 or @@rowcount = 0 
		begin
			select "F","����ҽ������(���˱���)�˻�������Ϣʧ��!"
			return
		end;
	end
	else if @xzlb = '3'		--��������
	begin
		insert into YY_CQYB_ACCINFO(sbkh,byqcqjczflj,byqycbjyjczflj,byqjhsysszflj,byqfmzzrsylfzflj,byqbfzzflj,syzyzt)
		select @sbkh,@byqcqjczflj,@byqycbjyjczflj,@byqjhsysszflj,@byqfmzzrsylfzflj,@byqbfzzflj,@syzyzt
		if @@error<>0 or @@rowcount = 0 
		begin
			select "F","����ҽ������(��������)�˻�������Ϣʧ��!"
			return
		end;
	end;
end
else
begin
	if @xzlb = '1'			--ҽ�Ʊ���
	begin
		update YY_CQYB_ACCINFO set zhye = @zhye,bntczflj= @bntczflj,bntsmzqfbzljzf = @bntsmzqfbzljzf,bntsmzybflj = @bntsmzybflj,
			bnexzlzyqfbzzflj = @bnexzlzyqfbzzflj,bnfhgwyfwmzfylj = @bnfhgwyfwmzfylj,bnzycs = @bnzycs,zyzt = @zyzt,bntbmzxbzzfje = @bntbmzxbzzfje,
			bnzyxbzzfje = @bnzyxbzzfje,bnfsgexzlbz = @bnfsgexzlbz,bndbzflj = @bndbzflj,jbzdjbfsbz = @jbzdjbfsbz,bnywshzflj = @bnywshzflj,
			bnndyjhzflj= @bnndyjhzflj,bnetlbzflj = @bnetlbzflj,bnkfxmzflj = @bnkfxmzflj,ndmzzyzflj = @ndmzzyzflj,ndmzmzzflj = @ndmzmzzflj,
			jxbzlj = @jxbzlj,ndptmzzflj = @ndptmzzflj,yddjbz = @yddjbz,zhxxyly = @zhxxyly,zhxxyle = @zhxxyle
		where sbkh = @sbkh
		if @@error<>0 or @@rowcount = 0 
		begin
			select "F","����ҽ������(ҽ�Ʊ���)�˻�������Ϣʧ��!"
			return
		end;
	end
	else if @xzlb = '2'		--���˱���
	begin
		update YY_CQYB_ACCINFO set cfxmtslj = @cfxmtslj,gszyzt = @gszyzt
		where sbkh = @sbkh
		if @@error<>0 or @@rowcount = 0 
		begin
			select "F","����ҽ������(���˱���)�˻�������Ϣʧ��!"
			return
		end;
	end
	else if @xzlb = '3'		--��������
	begin
		update YY_CQYB_ACCINFO set byqcqjczflj = @byqcqjczflj,byqycbjyjczflj = @byqycbjyjczflj,byqjhsysszflj = @byqjhsysszflj,
			byqfmzzrsylfzflj = @byqfmzzrsylfzflj,byqbfzzflj = @byqbfzzflj,syzyzt = @syzyzt
		where sbkh = @sbkh
		if @@error<>0 or @@rowcount = 0 
		begin
			select "F","����ҽ������(��������)�˻�������Ϣʧ��!"
			return
		end;
	end;
end

select "T"
return
GO
