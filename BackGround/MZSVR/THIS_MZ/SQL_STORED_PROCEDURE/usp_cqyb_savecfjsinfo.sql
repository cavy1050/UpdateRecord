if exists(select 1 from sysobjects where name = 'usp_cqyb_savecfjsinfo')
  drop proc usp_cqyb_savecfjsinfo
go
CREATE proc usp_cqyb_savecfjsinfo
(
	@jsxh				ut_sjh,				--�������
	@syxh				ut_syxh,			--��ҳ���
	@xtbz				ut_bz,				--ϵͳ��־0�Һ�1�շ�2סԺ
    @mxxh				ut_xh12,			--������ϸ���
    @zxlsh				varchar(20),		--������ˮ��
    @xmdj				numeric(10,4),		--��Ŀ����
    @spbz				varchar(10),		--�������
    @xmje				numeric(10,4),		--��Ŀ�����ܶ�
    @xmbz				varchar(10),		--��Ŀ�ȼ�
    @zfbl				numeric(5,4),		--�Ը�����
    @bzdj				numeric(10,4),		--��׼����
    @zfje				numeric(10,4),		--�Ը����
    @zlje				numeric(10,4)		--�Էѽ��
)
as
/****************************************
[�汾��]4.0.0.0.0
[����ʱ��]2017.03.05
[����]FerryMan
[��Ȩ]Copyright ? 1998-2017���������Ƽ����Źɷ����޹�˾
[����]���洦����ϸ�ϴ���ҽ��������Ϣ
[����˵��]
	���洦����ϸ�ϴ���ҽ��������Ϣ
[����˵��]
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��]
[�޸ļ�¼]
****************************************/
set nocount on

if @xtbz = 0  
begin
	update GH_GHMXK set zxlsh = @zxlsh,ybxmdj = @xmdj,ybspbz = @spbz,ybzje = @xmje,sfxmdj = @xmbz,ybzfbl = @zfbl,
		ybbzdj = @bzdj,ybzfje = @zfje,ybzlje = @zlje
	where xh = @mxxh
	if @@error <> 0 
	begin
		select "F","����GH_GHMXK��ҽ��������ϸ��Ϣʧ��!"
	end
end
else if @xtbz = 1
begin
	update SF_CFMXK set zxlsh = @zxlsh,ybxmdj = @xmdj,ybspbz = @spbz,ybzje = @xmje,sfxmdj = @xmbz,ybzfbl = @zfbl,
		ybbzdj = @bzdj,ybzfje = @zfje,ybzlje = @zlje
	where xh = @mxxh
	if @@error <> 0 
	begin
		select "F","����SF_CFMXK��ҽ��������ϸ��Ϣʧ��!"
	end
end
else --if @xtbz in (2,3,4)
begin
	update YY_CQYB_ZYFYMXK set zxlsh = @zxlsh,ybxmdj = @xmdj,ybspbz = 0,ybzje = @xmje,sfxmdj = @xmbz,ybzfbl = @zfbl,
		ybbzdj = @bzdj,ybzfje = @zfje,ybzlje = @zlje,ybscbz = 1
	where @syxh = @syxh and jsxh = @jsxh and xh = @mxxh
	if @@error <> 0 
	begin
		select "F","����YY_CQYB_ZYFYMXK��ҽ��������ϸ��Ϣʧ��!"
	end
	
	update YY_CQYB_NZYFYMXK set zxlsh = @zxlsh,ybxmdj = @xmdj,ybspbz = 0,ybzje = @xmje,sfxmdj = @xmbz,ybzfbl = @zfbl,
		ybbzdj = @bzdj,ybzfje = @zfje,ybzlje = @zlje,ybscbz = 1
	where @syxh = @syxh and jsxh = @jsxh and xh = @mxxh
	if @@error <> 0 
	begin
		select "F","����YY_CQYB_NZYFYMXK��ҽ��������ϸ��Ϣʧ��!"
	end
end

select "T"
return
GO
