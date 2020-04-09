if exists(select 1 from sysobjects where name = 'usp_cqyb_savetsbinfo')
  drop proc usp_cqyb_savetsbinfo
go
CREATE proc usp_cqyb_savetsbinfo
(
	@sbkh				varchar(20),		--��ᱣ�Ϻ���
	@bzbm				varchar(20),		--���ֱ���
	@bzmc				varchar(80),		--��������
	@bfz				varchar(200)=''		--����֢
)
as
/****************************************
[�汾��]4.0.0.0.0
[����ʱ��]2017.03.05
[����]FerryMan
[��Ȩ]Copyright ? 1998-2017���������Ƽ����Źɷ����޹�˾
[����]����ҽ�����ⲡ������Ϣ
[����˵��]
	����ҽ�����ⲡ������Ϣ
[����˵��]
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��]
[�޸ļ�¼]
****************************************/
set nocount on
	
BEGIN TRAN

if not exists(select 1 from YY_CQYB_TSBINFO where sbkh = @sbkh and bzbm = @bzbm and bfz = @bfz)
begin
	insert into YY_CQYB_TSBINFO(sbkh,bzbm,bzmc,bfz)
	select @sbkh,@bzbm,@bzmc,@bfz
	if @@error<>0 or @@rowcount = 0 
	BEGIN
        ROLLBACK TRAN
		select "F","����ҽ�����ⲡ������Ϣʧ��1!"
		return
	end;
end
else
begin
	update YY_CQYB_TSBINFO set bzmc = @bzmc,jlzt = 0 where sbkh = @sbkh and bzbm = @bzbm and bfz = @bfz
	if @@error<>0 or @@rowcount = 0 
	BEGIN
        ROLLBACK TRAN
		select "F","����ҽ�����ⲡ������Ϣʧ��!"
		return
	end;
END

DELETE YY_SYB_BRJBBMK WHERE shbzh = @sbkh --AND bzbm = @bzbm AND @bzmc = @bzmc AND bfz = @bfz

insert into YY_SYB_BRJBBMK ( shbzh, bzbm, bzmc,  bfz ,py,wb)
SELECT @sbkh,a.bzbm,convert(varchar(40),a.bzmc),a.bfz,ISNULL(b.py, ' '),ISNULL(b.wb, ' ')--bzmc�ضϣ���ҽԺ����varchar40
FROM YY_CQYB_TSBINFO a(NOLOCK) LEFT JOIN YY_CQYB_ZDDMK b(NOLOCK) ON a.bzbm = b.id 
WHERE a.sbkh = @sbkh AND a.jlzt = 0
if @@error<>0 or @@rowcount = 0 
BEGIN
    ROLLBACK TRAN
	select "F","����ҽ�����ⲡ������Ϣʧ��2!"
	return
end;

COMMIT TRAN

select "T"

return
GO
