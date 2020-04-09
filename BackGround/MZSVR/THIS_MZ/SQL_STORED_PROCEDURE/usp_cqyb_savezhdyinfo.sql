if exists(select 1 from sysobjects where name = 'usp_cqyb_savezhdyinfo')
  drop proc usp_cqyb_savezhdyinfo
go
CREATE proc usp_cqyb_savezhdyinfo
(
	@jsxh				ut_sjh,				--�������
	@syxh				ut_syxh=0,			--��ҳ���
	@xtbz				ut_bz,				--ϵͳ��־0�Һ�1�շ�2סԺ
	@czlb				ut_bz,				--�������0ɾ��1����
	@bcdykh				varchar(10)='',		--���ε��ÿ���
    @bcdyje				ut_money=0			--���ε��ý��
)
as
/****************************************
[�汾��]4.0.0.0.0
[����ʱ��]2017.03.05
[����]FerryMan
[��Ȩ]Copyright ? 1998-2017���������Ƽ����Źɷ����޹�˾
[����]����ҽ���˻�������Ϣ
[����˵��]
	����ҽ���˻�������Ϣ
[����˵��]
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��]
[�޸ļ�¼]
****************************************/
set nocount on

if @xtbz in (0,1)  
begin
	if @czlb = 0
	begin
		delete from YY_CQYB_MZDYJLK where jssjh = @jsxh
		if @@error <> 0 
		begin
			select "F","ɾ��YY_CQYB_MZDYJLK��ҽ���˻�������Ϣʧ��!"
			return
		end
	end
	else if @czlb = 1
	begin
		if exists(select 1 from YY_CQYB_MZDYJLK where jssjh = @jsxh and dykh = @bcdykh)
		begin
			select "F","�˱ʽ�����ʹ�ù�����Ϊ��"+@bcdykh+"����ҽ���������˻���֣��޷��ٴ�ʹ��!"
			return
		end
		
		insert into YY_CQYB_MZDYJLK(jssjh,jzlsh,sbkh,name,sfzh,xzqhbm,cblb,dykh,dyje,jlzt)
		select a.jssjh,a.jzlsh,a.sbkh,b.name,b.sfzh,b.xzqhbm,a.cblb,@bcdykh,@bcdyje,1
		from YY_CQYB_MZJZJLK a(nolock) inner join YY_CQYB_PATINFO b(nolock) on a.sbkh = b.sbkh
		where a.jssjh = @jsxh and a.jlzt = 1
		if @@error <> 0 or @@rowcount = 0
		begin
			select "F","���������˻�������Ϣʧ��!"
			return
		end;
	end
end
else if @xtbz = 2
begin
	if @czlb = 0
	begin
		delete from YY_CQYB_ZYDYJLK where syxh = @syxh and jsxh = @jsxh
		if @@error <> 0 
		begin
			select "F","ɾ��YY_CQYB_ZYDYJLK��ҽ���˻�������Ϣʧ��!"
			return
		end
	end
	else if @czlb = 1
	begin
		if exists(select 1 from YY_CQYB_ZYDYJLK where syxh = @syxh and jsxh = @jsxh and dykh = @bcdykh)
		begin
			select "F","�˱ʽ�����ʹ�ù�����Ϊ��"+@bcdykh+"����ҽ���������˻���֣��޷��ٴ�ʹ��!"
			return
		end
		
		insert into YY_CQYB_ZYDYJLK(jsxh,syxh,jzlsh,sbkh,name,sfzh,xzqhbm,cblb,dykh,dyje,jlzt)
		select @jsxh,a.syxh,a.jzlsh,a.sbkh,b.name,b.sfzh,b.xzqhbm,a.cblb,@bcdykh,@bcdyje,1
		from YY_CQYB_ZYJZJLK a(nolock) inner join YY_CQYB_PATINFO b(nolock) on a.sbkh = b.sbkh
		where a.syxh = @syxh and a.jlzt = 1
		if @@error <> 0 or @@rowcount = 0
		begin
			select "F","����סԺ�˻�������Ϣʧ��!"
			return
		end;
	end
end

select "T"

return
GO
