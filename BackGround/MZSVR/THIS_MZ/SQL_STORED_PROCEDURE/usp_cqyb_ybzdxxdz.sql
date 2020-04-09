if exists(select 1 from sysobjects where name='usp_cqyb_ybzdxxdz')
  drop proc usp_cqyb_ybzdxxdz
GO

CREATE proc usp_cqyb_ybzdxxdz
(
    @code			varchar(30)				,--���״���
	@hiszddm		VARCHAR(20)			=''	,--HIS��ϴ���(YY_ZDDMK.id)
	@ybzddm			varchar(20)			=''	,--ҽ����ϴ���(YY_CQYB_ZDDMK.id)
	@czyh           varchar(10)			=''	,--�����û�
	@syfw			ut_bz				=0	 --ʹ�÷�Χ(0��ALL��1�����ڡ�2��������)
)
/****************************************
[�汾��]4.0.0.0.0
[����ʱ��]2019.07.03
[����]Zhuhb
[��Ȩ]Copyright ? 1998-2017���������Ƽ����Źɷ����޹�˾
[����]ҽ����϶�����ع���
[����˵��]
	��ȡHIS��ϴ��롢ҽ����ϴ��롢��ϴ�����ա��Ѷ�����ϲ�ѯ�ȣ�
[����˵��]
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��]
[�޸ļ�¼] 
****************************************/

AS  

DECLARE @czsj datetime

SET @czsj = GETDATE()
    
IF @code = 'SAVEDZXX' --���������Ϣ
BEGIN
	IF EXISTS(SELECT 1 FROM YY_CQYB_ZDDMK_DZ WHERE hiszddm = @hiszddm AND ybzddm = @ybzddm)
	BEGIN
			SELECT 'F','���ձ���ʧ��(������Ѿ�����)��'
			return		
	END
	ELSE
	BEGIN		
		INSERT INTO YY_CQYB_ZDDMK_DZ(hiszddm,ybzddm,syfw,czyh,czrq)
		VALUES  (@hiszddm,@ybzddm,@syfw,@czyh,@czsj)
		if @@error <> 0 AND @@ROWCOUNT < 1
		begin
			ROLLBACK TRAN
			SELECT 'F','���ձ���ʧ�ܣ�'
			return
		END
		SELECT 'T',''
		RETURN  		
	END
   
END
ELSE IF @code = 'DELDZXX' --ɾ��������Ϣ
BEGIN
    DELETE YY_CQYB_ZDDMK_DZ WHERE hiszddm = @hiszddm AND ybzddm = @ybzddm
    if @@error <> 0 AND @@ROWCOUNT < 1
	begin
        ROLLBACK TRAN
        SELECT 'F','ȡ������ʧ�ܣ�'
		return
	END
	SELECT 'T',''
    RETURN   
END
ELSE
BEGIN
	SELECT 'F','û�иý��״���'
	RETURN
END

RETURN
go
