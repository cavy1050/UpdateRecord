if exists(select 1 from sysobjects where name='usp_cqyb_zyfymxzzf')
  drop proc usp_cqyb_zyfymxzzf
go
CREATE proc usp_cqyb_zyfymxzzf
  @lb   VARCHAR(10),     --01��ת�Էѣ�02 תҽ������ 
  @syxh ut_xh12 = 0, 
  @jsxh  ut_xh12 = 0,   
  @xh ut_xh12,			--zy_fymxk.xh 
  @czyh varchar(10)      
as
/**********
[�汾��]4.0.0.0.0
[����ʱ��]
[����]
[��Ȩ]
[����]
[����˵��]

[����ֵ]
[�����������]

**********/

set nocount ON

IF @lb = '01'   --ת�Է�
BEGIN
	BEGIN TRAN
	update YY_CQYB_ZYFYMXK set qzfbz = 1 where syxh = @syxh and jsxh = @jsxh and xh = @xh
    if @@error <> 0 or @@rowcount = 0 
	BEGIN 
		SELECT 'F', '����תȫ�Էѱ�־����!' 
		ROLLBACK TRAN 
		RETURN
	END

	insert into YY_CQYB_ZYFYMXK_ZZFLOG(syxh,jsxh,xh,lb,czyh,czrq) 
              values (@syxh,@jsxh, @xh,'1',@czyh,GETDATE())
    if @@error <> 0 or @@rowcount = 0 
	BEGIN 
		SELECT 'F','����תȫ�Է���־��¼����!' 
		ROLLBACK TRAN 
		RETURN
	END

	COMMIT TRAN
	SELECT 'T',''
END
ELSE IF @lb = '02'  --תҽ������
BEGIN
    BEGIN TRAN
    update YY_CQYB_ZYFYMXK set qzfbz = 0 where syxh = @syxh and jsxh = @jsxh and xh = @xh
    if @@error <> 0 or @@rowcount = 0 
	BEGIN 
		SELECT 'F', '����תҽ����־����!' 
		ROLLBACK TRAN 
		RETURN
	END 

	insert into YY_CQYB_ZYFYMXK_ZZFLOG(syxh,jsxh,xh,lb,czyh,czrq) 
              values (@syxh,@jsxh, @xh,'2',@czyh,GETDATE())
    if @@error <> 0 or @@rowcount = 0 
	BEGIN 
		SELECT 'F','����תҽ����־��¼����!' 
		ROLLBACK TRAN 
		RETURN
	END

	COMMIT TRAN
	SELECT 'T',''
END

return 
GO
