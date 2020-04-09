if exists(select 1 from sysobjects where name = 'usp_cqyb_getdefaultybdm')
  drop proc usp_cqyb_getdefaultybdm
go
Create proc usp_cqyb_getdefaultybdm
(
	@xtbz				ut_bz,				--ϵͳ��־0�Һ�1סԺ
	@cblb				varchar(10),		--�α����1ְ���α�2����α�3���ݸɲ�
	@xzlb				varchar(10)			--�������
)
as
/****************************************
[�汾��]4.0.0.0.0
[����ʱ��]2017.03.05
[����]FerryMan
[��Ȩ]Copyright ? 1998-2017���������Ƽ����Źɷ����޹�˾
[����]��ȡĬ��ҽ������
[����˵��]
	��ȡĬ��ҽ������    
	xzlb    cblb    
	  1       1     ְ��
	  1       2     ����
	  1       3     ����
	  2             ����
	  3             ����
[����˵��]
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��]
[�޸ļ�¼]
****************************************/
set nocount on

declare @ybdm	ut_ybdm		--ҽ������
       ,@ybjkid VARCHAR(3)  --ҽ���ӿ�id 
select @ybdm = ''	

SELECT @ybjkid = config FROM YY_CONFIG WHERE id = 'CQ18' 

IF LTRIM(RTRIM(@ybjkid)) = '' 
    SELECT @ybjkid = '1'

if @xtbz = 0
begin
	--select @ybdm = ybdm from YY_YBFLK where xtbz = 0 and cblb = @cblb and jlzt = 0 and ybjkid=@ybjkid
	select @ybdm = ybdm from YY_YBFLK 
	WHERE xtbz = 0 
	  AND (
	         (@xzlb = '1' AND xzlb = @xzlb AND cblb = @cblb) OR 
	         (@xzlb = '2' AND xzlb = @xzlb) OR
	         (@xzlb = '3' AND xzlb = @xzlb) 
	      )
	  AND jlzt = 0 and ybjkid=@ybjkid
end
else if @xtbz = 1
begin
	SELECT TOP 1 @ybdm = ybdm from YY_YBFLK 
	WHERE xtbz = 1 
	  AND (
	         (@xzlb = '1' AND xzlb = @xzlb AND cblb = @cblb) OR 
	         (@xzlb = '2' AND xzlb = @xzlb) OR
	         (@xzlb = '3' AND xzlb = @xzlb) 
	      )
	  AND jlzt = 0 and ybjkid=@ybjkid
end

select "T",@ybdm

return
GO
