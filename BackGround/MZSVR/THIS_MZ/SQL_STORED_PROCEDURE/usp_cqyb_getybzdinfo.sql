if exists(select 1 from sysobjects where name='usp_cqyb_getybzdinfo')
  drop proc usp_cqyb_getybzdinfo
go
Create proc usp_cqyb_getybzdinfo
(
  @flag		varchar(40),
  @value	varchar(100)
)
as
/****************************************
[�汾��]4.0.0.0.0
[����ʱ��]2017.03.05
[����]FerryMan
[��Ȩ]Copyright ? 1998-2017���������Ƽ����Źɷ����޹�˾
[����]��ȡҽ������ֵ����
[����˵��]
	��ȡҽ������ֵ����
[����˵��]
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��]
[�޸ļ�¼] 
****************************************/
set nocount on 

if @flag = '��Ա���' 
begin
	if exists(select 1 from YY_CQYB_YBSJZD where zdlb = 'RYLB' and code = @value and jlzt = 0)
		select "T",name from YY_CQYB_YBSJZD where zdlb = 'RYLB' and code = @value and jlzt = 0
	else
		select "T",@value
end
else if @flag = '�Ƿ����ܹ���Ա����' 
begin
	if @value = '0'
		select "T","������"
	else if @value = '1'
		select "T","����"
	else
		select "T",@value
end
else if @flag = '������������' 
begin
	if exists(select 1 from YY_CQYB_YBSJZD where zdlb = 'XZQH' and code = @value and jlzt = 0)
		select "T",name from YY_CQYB_YBSJZD where zdlb = 'XZQH' and code = @value and jlzt = 0
	else
		select "T",@value
end
else if @flag = '����״��' 
begin
	if exists(select 1 from YY_CQYB_YBSJZD where zdlb = 'FSZK' and code = @value and jlzt = 0)
		select "T",name from YY_CQYB_YBSJZD where zdlb = 'FSZK' and code = @value and jlzt = 0
	else if ltrim(rtrim(@value)) = '' or @value = '0' 
		select "T","�޷���"
	else
		select "T",@value
end
else if @flag = '��Ա�������' 
begin
	if exists(select 1 from YY_CQYB_YBSJZD where zdlb = 'RYLXBG' and code = @value and jlzt = 0)
		select "T",name from YY_CQYB_YBSJZD where zdlb = 'RYLXBG' and code = @value and jlzt = 0
	else
		select "T",@value
end
else if @flag = '������Ա���' 
begin
	if exists(select 1 from YY_CQYB_YBSJZD where zdlb = 'MZRYLB' and code = @value and jlzt = 0)
		select "T",name from YY_CQYB_YBSJZD where zdlb = 'MZRYLB' and code = @value and jlzt = 0
	else
		select "T",@value
end
else if @flag = '����ɷѵ���' 
begin
	if @value = '1'
		select "T","һ��"
	else if @value = '2'
		select "T","����"
	else
		select "T",@value
end
else if @flag = '�α����'
begin
	if exists(select 1 from YY_CQYB_YBSJZD where zdlb = 'CBLB' and code = @value and jlzt = 0)
		select "T",name from YY_CQYB_YBSJZD where zdlb = 'CBLB' and code = @value and jlzt = 0
	else
		select "T",@value
end
else if @flag = '�α�״̬'
begin
	if @value = '1'
		select "T","�����α�"
	else if @value = '2'
		select "T","��ͣ�α�"
	else if @value = '3'
		select "T","��ֹ�α�"
	else
		select "T",@value
end
else if @flag = '�������߳�������'
begin
	if @value = '0'
		select "T","����Ҫ����"
	else if @value = '1'
		select "T","��Ҫ����"
	else
		select "T",@value
end
else if @flag = '�ɷ����ܾ����־'
begin
	if @value = '0'
		select "T","��������"
	else if @value = '1'
		select "T","��������"
	else
		select "T",@value
end
else if @flag = '����֢��־'
begin
	if @value = '0'
		select "T","�޲���֢"
	else if @value = '1'
		select "T","�в���֢"
	else
		select "T",@value
end
else if @flag = 'סԺ״̬'
begin
	if @value = '0'
		select "T","δסԺ"
	else if @value = '1'
		select "T","��סԺ"
	else
		select "T",@value
end
else
	select "T",@value

return
GO
