if exists(select 1 from sysobjects where name = 'usp_cqyb_checkmedcode')
  drop proc usp_cqyb_checkmedcode
go
Create proc usp_cqyb_checkmedcode
(
	@jsxh				ut_sjh,				--�������
	@syxh				ut_syxh,			--��ҳ���
	@xtbz				ut_bz,				--ϵͳ��־0,1����2סԺ
	@cblb				varchar(10)			--�α����
)
as
/****************************************
[�汾��]4.0.0.0.0
[����ʱ��]2017.03.05
[����]FerryMan
[��Ȩ]Copyright ? 1998-2017���������Ƽ����Źɷ����޹�˾
[����]У�黼��ҽ��������Ϣ
[����˵��]
	У�黼��ҽ��������Ϣ
[����˵��]
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��]
[�޸ļ�¼]
****************************************/
set nocount on

declare @ybdm		ut_ybdm,			--ҽ������
		@cblb_his	varchar(10)			--�α����

if @xtbz in(0 ,1)
begin
	select @ybdm = ybdm from SF_BRJSK(nolock) where sjh = @jsxh

	select @cblb_his = cblb from YY_YBFLK(nolock) where ybdm = @ybdm

	if @cblb <> ISNULL(@cblb_his,'')
	begin
		select "F","���ߵ�ǰҽ�����벻��ȷ�����Ƚ���ƾ֤�޸Ļ�����ѡ��ҽ����������շ�!"
		return
	end
end
else if @xtbz = 2
begin
	select @ybdm = ybdm from ZY_BRSYK(nolock) where syxh = @syxh

	select @cblb_his = cblb from YY_YBFLK(nolock) where ybdm = @ybdm

	if @cblb <> ISNULL(@cblb_his,'')
	begin
		select "F","���ߵ�ǰҽ�����벻��ȷ��������ѡ��ҽ��������ٽ���ҽ���Ǽ�!"
		return
	end
end

select "T"

return
GO
