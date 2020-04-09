if exists(select 1 from sysobjects where name = 'usp_cqyb_saveqxjsinfo')
  drop proc usp_cqyb_saveqxjsinfo
go
Create proc usp_cqyb_saveqxjsinfo
(
	@syxh			ut_syxh,		--��ҳ���
	@jsxh			VARCHAR(20),		--�������
	@xtbz		    ut_bz,			--ϵͳ��־0�Һ�1�շ�2סԺ
	@czlsh          VARCHAR(20),    --������ˮ��
	@zxczsj         VARCHAR(20),    --���ĳ���ʱ��
	@ddyljgbm       varchar(10)     --����ҽ�ƻ�������
)
as
/**********************
[�汾��]4.0.0.0.0
[����ʱ��]2017.03.05
[����]FerryMan
[��Ȩ]Copyright ? 1998-2017���������Ƽ����Źɷ����޹�˾
[����]סԺ���㴦��
[����˵��]
	HISסԺ���㴦��
[����˵��]
    @syxh			ut_syxh,		--��ҳ���
	@jsxh			ut_xh12,		--�������
	@xtbz		    ut_bz,			--ϵͳ��־0�Һ�1�շ�2סԺ
	@czlsh          VARCHAR(20),    --������ˮ��
	@zxczsj         VARCHAR(20)     --���ĳ���ʱ��
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��]
exec usp_cqyb_saveqxjsinfo
[�޸ļ�¼]
**********************/
set nocount on

declare	@ybjsfs		varchar(3) --ҽ�����㷽ʽ
       ,@hisjsfs    varchar(3) --his���㷽ʽ
       ,@ybdm       ut_ybdm  
if @xtbz in (0,1)
BEGIN
    BEGIN TRAN
	
	update YY_CQYB_MZJSJLK set czlsh = @czlsh,zxczsj = @zxczsj ,jlzt = 3,ddyljgbm = @ddyljgbm where jssjh = @jsxh and jlzt = 2 
    if @@error <> 0 
	BEGIN
	    ROLLBACK TRAN
	    SELECT "F","����ҽ�����������Ϣ(�ձ�)ʧ��!" 
		RETURN
	END

    update YY_CQYB_NMZJSJLK set czlsh = @czlsh,zxczsj = @zxczsj,jlzt = 3,ddyljgbm = @ddyljgbm where jssjh = @jsxh and jlzt = 2 
    if @@error <> 0 
	BEGIN
	    ROLLBACK TRAN
		SELECT "F","����ҽ�����������Ϣ(���)ʧ��!" 
		RETURN
	END

    update YY_CQYB_MZJZJLK set jlzt = 1 where jssjh = @jsxh and jlzt = 2  
    if @@error <> 0 
	BEGIN
	    ROLLBACK TRAN
	    SELECT "F","����ҽ��סԺ�Ǽ���Ϣ(�ձ�)ʧ��!"
		RETURN
	END

    update YY_CQYB_NMZJZJLK set jlzt = 1 where jssjh = @jsxh and jlzt = 2  
    if @@error <> 0 
	BEGIN
	    ROLLBACK TRAN
	    SELECT "F","����ҽ��סԺ�Ǽ���Ϣ(���)ʧ��!"
		RETURN 
	END

    update YY_CQYB_MZDYJLK set jlzt = 3 where jssjh = @jsxh and jlzt = 2 
    if @@error <> 0 
	BEGIN
	    ROLLBACK TRAN
	    SELECT "F","����ҽ�������˻�������Ϣ(�ձ�)ʧ��!"
		RETURN
	END

    update YY_CQYB_NMZDYJLK set jlzt = 3 where jssjh = @jsxh and jlzt = 2 
    if @@error <> 0 
	BEGIN
	    ROLLBACK TRAN
	    SELECT "F","����ҽ�������˻�������Ϣ(���)ʧ��!" 
		RETURN
	END

    update SF_JEMXK set memo = "���˷�" where jssjh = @jsxh and lx in ("yb01","01") 
	if @@error <> 0 
	BEGIN
	    ROLLBACK TRAN
	    SELECT "F","�����ձ����˷ѱ�־ʧ��" 
	    RETURN
	END
    update SF_NJEMXK set memo = "���˷�" where jssjh = @jsxh and lx in ("yb01","01") 
    if @@error <> 0 
	BEGIN
	    ROLLBACK TRAN
	    SELECT "F","����������˷ѱ�־ʧ��" 
	    RETURN
	END

	COMMIT TRAN
END     
ELSE IF @xtbz = '2'
begin       
	select @ybjsfs = jslb from YY_CQYB_ZYJSJLK(nolock) where syxh = @syxh and jsxh = @jsxh and jlzt = 2
	select @hisjsfs = jszt,@ybdm = ybdm from ZY_BRJSK(nolock) where syxh = @syxh and xh = @jsxh   --1:��;��2:��Ժ

	begin tran 
	    update ZY_BRJSJEK set memo = "���˷�" where jsxh = @jsxh and lx in ("yb01","01") 
		if @@error <> 0
		begin
			rollback tran 
			select 'F','����ҽ��סԺ������Ϣʧ��!'
			return
		END
	    
		update YY_CQYB_ZYJSJLK set czlsh = @czlsh,zxczsj = @zxczsj,jlzt = 3,ddyljgbm=@ddyljgbm where syxh = @syxh and jsxh = @jsxh and jlzt = 2 
		if @@error <> 0 or @@rowcount = 0 
		begin
			rollback tran 
			select 'F','����ҽ��סԺ������Ϣʧ��!'
			return
		end


		update YY_CQYB_ZYJZJLK set jlzt = 1 where syxh = @syxh and jlzt = 2 
		if @@error <> 0 
		begin
			rollback tran 
			select 'F','����ҽ��סԺ������Ϣʧ��!'
			return
		end
	       
		update YY_CQYB_ZYDYJLK set jlzt = 3 where syxh = @syxh and jsxh = @jsxh and jlzt = 2 
		if @@error <> 0 
		begin   
			rollback tran 
			select 'F','����ҽ��סԺ�˻�������Ϣʧ��!'
			return
		end

		--���his����;���㣬ҽ���ǳ�Ժ���㣬��ԭZY_BRJSK��ZY_BRXXK��ybdmΪ����ȡ�������ҽ������
		if @ybjsfs = '0' and @hisjsfs = '1' 
		begin
			update ZY_BRSYK set ybdm = @ybdm where syxh = @syxh
			if @@error <> 0 
			begin   
				rollback tran 
				select 'F','������ҳ��ҽ������ʧ��!'
				return
			end
	    
			update ZY_BRXXK set ybdm = @ybdm where patid = (select patid from ZY_BRSYK(nolock) where syxh = @syxh)
			if @@error <> 0 
			begin   
				rollback tran 
				select 'F','������Ϣ��ҽ������ʧ��!'
				return
			end
		end
	commit tran 
end

select 'T'

return
GO
