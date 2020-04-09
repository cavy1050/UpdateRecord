if exists(select 1 from sysobjects where name = 'usp_cqyb_savegsrdinfo')
  drop proc usp_cqyb_savegsrdinfo
go
Create proc usp_cqyb_savegsrdinfo
(
	@sbkh				varchar(20),		--��ᱣ�Ϻ���
	@grbh				varchar(10),		--���˱��
	@dwbh				varchar(10),		--��λ���
	@rdbh				varchar(50),		--�϶����
	@tgbz				ut_bz,				--ͨ����־0δͨ��1ͨ��2�϶����δ�´�		
	@sssj				varchar(10),		--���������¼�
	@jssj				varchar(10),		--���Ʋο������¼�
	@bzinfo				varchar(200)		--�������˲�����Ϣ
)
as
/****************************************
[�汾��]4.0.0.0.0
[����ʱ��]2017.03.05
[����]FerryMan
[��Ȩ]Copyright ? 1998-2017���������Ƽ����Źɷ����޹�˾
[����]����ҽ�������϶���Ϣ
[����˵��]
	����ҽ�������϶���Ϣ
[����˵��]
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��]
[�޸ļ�¼]
****************************************/
set nocount on
	
if not exists(select 1 from YY_CQYB_GSRDINFO where sbkh = @sbkh and rdbh = @rdbh)
begin
	insert into YY_CQYB_GSRDINFO(sbkh,grbh,dwbh,rdbh,tgbz,sssj,jssj,bzinfo,jlzt)
	select @sbkh,@grbh,@dwbh,@rdbh,@tgbz,@sssj,@jssj,@bzinfo,0
	if @@error<>0 or @@rowcount = 0 
	begin
		select "F","����ҽ�������϶���Ϣʧ��!"
		return
	end;
end
else
begin
	update YY_CQYB_GSRDINFO set grbh = @grbh,dwbh = @dwbh,tgbz = @tgbz,sssj = @sssj,jssj = @jssj,
		bzinfo = @bzinfo,jlzt = 0 where sbkh = @sbkh and rdbh = @rdbh
	if @@error<>0 or @@rowcount = 0 
	begin
		select "F","����ҽ�������϶���Ϣʧ��!"
		return
	end;
end

select "T"

return
GO
