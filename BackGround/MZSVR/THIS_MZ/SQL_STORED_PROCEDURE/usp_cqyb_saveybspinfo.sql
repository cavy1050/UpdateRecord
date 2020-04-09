if exists(select 1 from sysobjects where name = 'usp_cqyb_saveybspinfo')
  drop proc usp_cqyb_saveybspinfo
go
CREATE proc usp_cqyb_saveybspinfo
(
	@jsxh				ut_sjh,				--�������
	@syxh				ut_syxh,			--��ҳ���
	@xtbz				ut_bz,				--ϵͳ��־0�Һ�1�շ�2סԺ3ҽ�����Ԥ��
	@cflsh				varchar(20),		--������ˮ��
    @splx				ut_bz				--��������1���շ�����2ѪҺ�׵�������

)
as
/****************************************
[�汾��]4.0.0.0.0
[����ʱ��]2017.03.05
[����]FerryMan
[��Ȩ]Copyright ? 1998-2017���������Ƽ����Źɷ����޹�˾
[����]����ҽ��δ������Ŀ��Ϣ
[����˵��]
	����ҽ��δ������Ŀ��Ϣ
[����˵��]
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��]
[�޸ļ�¼]
****************************************/
set nocount on

IF @xtbz = 1
begin
	update b set ybspbz = @splx from SF_MZCFK a(nolock) inner join SF_CFMXK b(nolock) on a.xh = b.cfxh and b.zxlsh = @cflsh
	where a.jssjh = @jsxh 
	if @@error <> 0 
	begin
		select "F","����YY_CQYB_ZYFYMXK��ybspbz����!"
		return;
	end;
end
else if @xtbz in (2,3,4)   
begin
	update YY_CQYB_ZYFYMXK set ybspbz = @splx where syxh = @syxh and jsxh = @jsxh and zxlsh = @cflsh
	if @@error <> 0 
	begin
		select "F","����YY_CQYB_ZYFYMXK��ybspbz����!"
		return;
	end;
end

select "T"

return
GO
