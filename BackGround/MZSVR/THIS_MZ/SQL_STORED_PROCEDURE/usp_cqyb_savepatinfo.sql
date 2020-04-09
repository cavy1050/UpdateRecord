if exists(select 1 from sysobjects where name = 'usp_cqyb_savepatinfo')
  drop proc usp_cqyb_savepatinfo
go
Create proc usp_cqyb_savepatinfo
(
	@sbkh				varchar(20),		--��ᱣ�Ϻ���
	@xzlb				varchar(10),		--�������
	@name				varchar(20),		--����
	@sex				varchar(20)='',		--�Ա�
	@age				varchar(10)='',		--ʵ������
	@sfzh				varchar(18)='',		--���֤��
	@nation				varchar(20)='',		--����
	@address			varchar(50)='',		--סַ
	@rylb				varchar(10)='',		--��Ա���
	@gwydy				varchar(10)='',		--�Ƿ����ܹ���Ա����
	@dwmc				varchar(50)='',		--��λ����
	@xzqhbm				varchar(14)='',		--������������
	@fszk				varchar(10)='',		--����״��
	@fsyy				varchar(128)='',	--����ԭ��
	@rylxbg				varchar(10)='',		--��Ա���ͱ��
	@rylxbgsj			varchar(20)='',		--��Ա���ͱ��ʱ��
	@dyfskssj			varchar(20)='',		--����������ʼʱ��
	@dyfsjssj			varchar(20)='',		--����������ֹʱ��
	@mzrylb				varchar(10)='',		--������Ա���
	@jmjfdc				varchar(10)='',		--����ɷѵ���
	@cblb				varchar(10)='',		--�α����
	@lxdh				varchar(20)='',		--������ϵ�绰
	@gscbzt				varchar(10)='',		--���˲α�״̬
	@gscbsj				varchar(20)='',		--���˲α�ʱ��
	@gsfszk				varchar(10)='',		--���˷���״��
	@gsfsyy				varchar(128)='',	--���˷���ԭ��
	@gsdyfskssj			varchar(20)='',		--���˴���������ʼʱ��
	@gsdyfsjssj			varchar(20)='',		--���˴���������ֹʱ��
	@zyzz				varchar(10)='',		--תԺת��
	@fzqjcbsp			varchar(10)='',		--�������߳�������
	@sycbsj				varchar(20)='',		--�����α�ʱ��
	@jydjzh				varchar(20)='',		--��ҽ�Ǽ�֤��
	@xsjzbz				varchar(10)='',		--�Ƿ����ܾ����־
	@bxsjzyy			varchar(200)='',	--�������ܾ���ԭ��
	@jydjjjbm			varchar(10)='',		--��ҽ�Ǽǻ�������
	@bfzbz				varchar(10)='',		--����֢��־
	@dyxskssj			varchar(20)='',		--���ܴ���ʵ�ʿ�ʼʱ��
	@dyxsjssj			varchar(20)='',		--���ܴ���ʵ�ʽ���ʱ��
	@dqfprylb			varchar(50)=''		--��ǰ��ƶ��Ա���
)
as
/****************************************
[�汾��]4.0.0.0.0
[����ʱ��]2017.03.05
[����]FerryMan
[��Ȩ]Copyright ? 1998-2017���������Ƽ����Źɷ����޹�˾
[����]����ҽ�����˻�����Ϣ
[����˵��]
	����ҽ�����˻�����Ϣ
[����˵��]
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��]
[�޸ļ�¼]
****************************************/
set nocount on
	
if not exists(select 1 from YY_CQYB_PATINFO where sbkh = @sbkh)
begin
	if @xzlb = '1'			--ҽ�Ʊ���
	begin
		insert into YY_CQYB_PATINFO(sbkh,name,sex,age,sfzh,nation,address,rylb,gwydy,dwmc,xzqhbm,fszk,fsyy,rylxbg,rylxbgsj,dyfskssj,
			dyfsjssj,mzrylb,jmjfdc,cblb,lxdh,dqfprylb)
		select @sbkh,@name,@sex,@age,@sfzh,@nation,@address,@rylb,@gwydy,@dwmc,@xzqhbm,@fszk,@fsyy,@rylxbg,@rylxbgsj,@dyfskssj,
			@dyfsjssj,@mzrylb,@jmjfdc,@cblb,@lxdh,@dqfprylb 
		if @@error<>0 or @@rowcount = 0 
		begin
			select "F","����ҽ������(ҽ�Ʊ���)������Ϣʧ��!"
			return
		end;
	end
	else if @xzlb = '2'		--���˱���
	begin
		insert into YY_CQYB_PATINFO(sbkh,name,sex,sfzh,dwmc,xzqhbm,gscbzt,gscbsj,gsfszk,gsfsyy,gsdyfskssj,gsdyfsjssj,zyzz,fzqjcbsp,dqfprylb)
		select @sbkh,@name,@sex,@sfzh,@dwmc,@xzqhbm,@gscbzt,@gscbsj,@gsfszk,@gsfsyy,@gsdyfskssj,@gsdyfsjssj,@zyzz,@fzqjcbsp,@dqfprylb
		if @@error<>0 or @@rowcount = 0 
		begin
			select "F","����ҽ������(���˱���)������Ϣʧ��!"
			return
		end;
	end
	else if @xzlb = '3'		--��������
	begin
		insert into YY_CQYB_PATINFO(sbkh,name,sex,sycbsj,sfzh,jydjzh,xsjzbz,bxsjzyy,jydjjjbm,bfzbz,dyxskssj,dyxsjssj,xzqhbm,dqfprylb)
		select @sbkh,@name,@sex,@sycbsj,@sfzh,@jydjzh,@xsjzbz,@bxsjzyy,@jydjjjbm,@bfzbz,@dyxskssj,@dyxsjssj,@xzqhbm,@dqfprylb
		if @@error<>0 or @@rowcount = 0 
		begin
			select "F","����ҽ������(��������)������Ϣʧ��!"
			return
		end;
	end;
end
else
begin
	if @xzlb = '1'			--ҽ�Ʊ���
	begin
		update YY_CQYB_PATINFO set name = @name,sex = @sex,age = @age,sfzh = @sfzh,nation = @nation,address = @address,rylb = @rylb,
			gwydy = @gwydy,dwmc = @dwmc,xzqhbm = @xzqhbm,fszk = @fszk,fsyy = @fsyy,rylxbg = @rylxbg,rylxbgsj = @rylxbgsj,
			dyfskssj = @dyfskssj,dyfsjssj = @dyfsjssj,mzrylb = @mzrylb,jmjfdc = @jmjfdc,cblb = @cblb,lxdh = @lxdh,dqfprylb = @dqfprylb
		where sbkh = @sbkh
		if @@error<>0 or @@rowcount = 0 
		begin
			select "F","����ҽ������(ҽ�Ʊ���)������Ϣʧ��!"
			return
		end;
	end
	else if @xzlb = '2'		--���˱���
	begin
		update YY_CQYB_PATINFO set name = @name,sex = @sex,sfzh = @sfzh,dwmc = @dwmc,xzqhbm = @xzqhbm,gscbzt = @gscbzt,gscbsj = @gscbsj,
			gsfszk = @gsfszk,gsfsyy = @gsfsyy,gsdyfskssj = @gsdyfskssj,gsdyfsjssj = @gsdyfsjssj,zyzz = @zyzz,fzqjcbsp = @fzqjcbsp,
			dqfprylb = @dqfprylb
		where sbkh = @sbkh
		if @@error<>0 or @@rowcount = 0 
		begin
			select "F","����ҽ������(���˱���)������Ϣʧ��!"
			return
		end;
	end
	else if @xzlb = '3'		--��������
	begin
		update YY_CQYB_PATINFO set name = @name,sex = @sex,sycbsj = @sycbsj,sfzh = @sfzh,jydjzh = @jydjzh,xsjzbz = @xsjzbz,bxsjzyy = @bxsjzyy,
			jydjjjbm = @jydjjjbm,bfzbz = @bfzbz,dyxskssj = @dyxskssj,dyxsjssj = @dyxsjssj,xzqhbm = @xzqhbm,dqfprylb = @dqfprylb
		where sbkh = @sbkh
		if @@error<>0 or @@rowcount = 0 
		begin
			select "F","����ҽ������(��������)������Ϣʧ��!"
			return
		end;
	end;
end

select "T"

return
GO
