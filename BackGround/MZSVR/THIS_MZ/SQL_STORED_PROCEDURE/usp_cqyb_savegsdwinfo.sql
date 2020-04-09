if exists(select 1 from sysobjects where name = 'usp_cqyb_savegsdwinfo')
  drop proc usp_cqyb_savegsdwinfo
go
Create proc usp_cqyb_savegsdwinfo
(
	@sbkh				varchar(20),		--��ᱣ�Ϻ���
	@grbh				varchar(10),		--���˱��
	@dwbh				varchar(10),		--��λ���
	@dwmc				varchar(50)			--��λ����
)
as
/****************************************
[�汾��]4.0.0.0.0
[����ʱ��]2017.03.05
[����]FerryMan
[��Ȩ]Copyright ? 1998-2017���������Ƽ����Źɷ����޹�˾
[����]����ҽ�����˵�λ��Ϣ
[����˵��]
	����ҽ�����˵�λ��Ϣ
[����˵��]
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��]
[�޸ļ�¼]
****************************************/
set nocount on
	
if not exists(select 1 from YY_CQYB_GSDWINFO where sbkh = @sbkh and grbh = @grbh and dwbh = @dwbh)
begin
	insert into YY_CQYB_GSDWINFO(sbkh,grbh,dwbh,dwmc,jlzt)
	select @sbkh,@grbh,@dwbh,@dwmc,0
	if @@error<>0 or @@rowcount = 0 
	begin
		select "F","����ҽ�����˵�λ��Ϣʧ��!"
		return
	end;
end
else
begin
	update YY_CQYB_GSDWINFO set dwmc = @dwmc,jlzt = 0 where sbkh = @sbkh and grbh = @grbh and dwbh = @dwbh
	if @@error<>0 or @@rowcount = 0 
	begin
		select "F","����ҽ�����˵�λ��Ϣʧ��!"
		return
	end;
end

select "T"

return
go
