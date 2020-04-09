IF EXISTS(SELECT 1 FROM sysobjects WHERE name = 'usp_cqyb_saveybjzinfo_ex1')
  DROP PROC usp_cqyb_saveybjzinfo_ex1
GO
CREATE PROC usp_cqyb_saveybjzinfo_ex1
(
	@jsxh				ut_sjh,				--�������
	@syxh				ut_syxh,			--��ҳ���
	@xtbz				ut_bz,				--ϵͳ��־0�Һ�1�շ�2סԺ�Ǽ�3סԺ��Ϣ����
    @xzlb				ut_bz,				--�������
    @cblb				ut_bz,				--�α����
	@zxlsh              VARCHAR(30)        --������ˮ��
)
AS
/****************************************
[�汾��]4.0.0.0.0
[����ʱ��]2017.03.05
[����]FerryMan
[��Ȩ]Copyright ? 1998-2017���������Ƽ����Źɷ����޹�˾
[����]����ҽ������Ǽ���Ϣ
[����˵��]
	����ҽ������Ǽ���Ϣ���ӿڽ�����ɺ󱣴�
[����˵��]
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��]
[�޸ļ�¼]
****************************************/
SET NOCOUNT ON

IF @xtbz IN (0,1)
BEGIN
	DECLARE @bftfbz		ut_bz	--�����˷ѱ�־
	       ,@oldsjh     VARCHAR(20)
		   ,@oldcblb    ut_bz
		   ,@oldzgyllb     VARCHAR(3)
		   ,@oldjmyllb     VARCHAR(3)
			
	IF EXISTS(SELECT 1 FROM VW_MZBRJSK(NOLOCK) WHERE sjh IN (SELECT tsjh FROM VW_MZBRJSK(NOLOCK) WHERE sjh = @jsxh))
		SELECT @bftfbz = 1
	ELSE
		SELECT @bftfbz = 0
    
	BEGIN TRANSACTION 
			
    UPDATE YY_CQYB_MZJZJLK SET zxlsh = @zxlsh,cblb = @cblb,jlzt = 1 WHERE jssjh = @jsxh AND jlzt = 0 
    IF @@error<>0 OR @@rowcount = 0 
	BEGIN
        ROLLBACK TRANSACTION 
		SELECT "F","����ҽ������Ǽ���Ϣʧ��!"
		RETURN
	END;

    --ͨ���Ǽ�֮�󷵻���Ϣ��������ybdm
    UPDATE SF_BRJSK 
		SET ybdm = (SELECT TOP 1 a.ybdm FROM YY_YBFLK a(NOLOCK) 
    WHERE ( ( "1" = @xzlb and ISNULL(a.xzlb,0) = @xzlb AND ISNULL(a.cblb,0) = @cblb)
            or ("2" = @xzlb and ISNULL(a.xzlb,0) = @xzlb)
            or ("3" = @xzlb and ISNULL(a.xzlb,0) = @xzlb)
           ) 
      AND ISNULL(a.xtbz,-1) = 0  
      and a.jlzt = "0")  
      WHERE sjh = @jsxh
    IF @@error <> 0 or @@rowcount = 0 
	BEGIN
	      ROLLBACK TRANSACTION 
          SELECT "F","���������ҽ������ʧ��!" 
		  RETURN
    END

    UPDATE a SET a.ybdm = b.ybdm FROM SF_BRXXK a,SF_BRJSK b(NOLOCK) WHERE a.patid = b.patid AND b.sjh = @jsxh
    if @@error <> 0 or @@rowcount = 0 
	BEGIN
	    ROLLBACK TRANSACTION 
	    SELECT "F","����������Ϣ��ҽ������ʧ��!"
		RETURN
	END
    
	IF @xtbz = 0 
	BEGIN
        UPDATE a SET a.ybdm = b.ybdm FROM GH_GHZDK a,SF_BRJSK b(NOLOCK) WHERE a.patid = b.patid and a.jssjh = b.sjh AND b.sjh = @jsxh
		if @@error <> 0 or @@rowcount = 0 
		BEGIN
			ROLLBACK TRANSACTION 
			SELECT "F","�����Һ��˵���ҽ������ʧ��!"
			RETURN
		END
	END

	--�����˷Ѵ�����ǰ���շ�cblb��һ�����,��������ͨ����������ز����������δ�����ݲ�����
	IF @bftfbz = 1
	BEGIN
		select @oldsjh = tsjh from VW_MZBRJSK(nolock) where sjh in (select tsjh from VW_MZBRJSK(nolock) where sjh = @jsxh)
		SELECT @oldcblb = cblb,@oldzgyllb = zgyllb,@oldjmyllb = jmyllb FROM VW_CQYB_MZJZJLK(nolock) WHERE jssjh = @oldsjh

		IF @oldcblb = 1 AND @cblb = 2 
		BEGIN
            IF @oldzgyllb = '11' 
			    UPDATE YY_CQYB_MZJZJLK SET jmyllb = '12' WHERE jssjh = @jsxh 
		END

		IF @oldcblb = 2 AND @cblb = 1
		BEGIN
            IF @oldjmyllb = '12' 
			    UPDATE YY_CQYB_MZJZJLK SET zgyllb = '11' WHERE jssjh = @jsxh 
		END
	END

	COMMIT TRANSACTION 

	select "T"
	return
end
else if @xtbz = 2
begin
	select "T"
    RETURN
end
else if @xtbz = 3
begin
	select "T"
    RETURN
end

GO
