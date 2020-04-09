if exists(select 1 from sysobjects where name = 'usp_cqyb_zyjs_mnjs')
  drop proc usp_cqyb_zyjs_mnjs
go
CREATE proc usp_cqyb_zyjs_mnjs
(
	@syxh			ut_syxh,		--��ҳ���
	@jsxh			ut_xh12,		--�������
	@jslb			ut_bz,			--0Ԥ��1����2ģ��Ԥ��3�߿�Ԥ����
	@zxlsh			varchar(20),	--������ˮ��
    @tczf	        ut_money, 		--ͳ��֧��
    @zhzf			ut_money,		--�˻�֧��
    @gwybz			ut_money,		--����Ա����
    @xjzf			ut_money, 		--�ֽ�֧��
    @delpje			ut_money, 		--���������
    @lsqfxgwyfh     ut_money, 		--��ʷ���߹���Ա����
    @zhye			ut_money,		--�˻����
    @dbzyljgdz		ut_money,		--������ҽ�ƻ�����֧
    @mzjzje			ut_money,		--�����������
    @mzjzmzye		ut_money,		--���������������
    @ndyxmzfje		ut_money,		--�Ͷ�ҩ��Ŀ֧�����
    @ybzlzfje       ut_money, 		--һ������֧����
    @shjzjjzfje		ut_money, 		--�񻪾�������֧����
    @bntczflj		ut_money,		--����ͳ��֧���ۼ�
    @bndezflj		ut_money,		--������֧���ۼ�
    @tbqfxzflj		ut_money, 		--�ز�����֧���ۼ�
    @ndyxmlj		ut_money,		--�Ͷ�ҩ��Ŀ�ۼ�
    @bnmzjzzyzflj	ut_money,		--������������סԺ֧���ۼ�
    @zxjssj			varchar(20),	--���Ľ���ʱ��
    @bcqfxzfje		ut_money,		--��������֧�����
    @bcjrybfwfy		ut_money,		--���ν���ҽ����Χ����
    @ysfwzfje		ut_money,		--ҩ�·����֧����
    @yycbkkje		ut_money,		--ҽԺ����ۿ���
    @syjjzf			ut_money,		--��������֧��
    @syxjzf			ut_money,		--�����ֽ�֧��
    @gsjjzf			ut_money,		--���˻���֧��
	@gsxjzf			ut_money,		--�����ֽ�֧��
    @gsdbzjgdz		ut_money,		--���˵����ֻ�����֧
	@gsqzfyy		varchar(100),	--����ȫ�Է�ԭ��
	@qtbz           ut_money,		--��������
	@syzhzf         ut_money,		--�����˻�֧��
	@gszhzf         ut_money,		--�����˻�֧��
	@bcjsfprylb     varchar(100),	--���ν����ƶ��Ա���	1.28��
	@jkfpyljj		ut_money,		--������ƶҽ�ƻ���		1.28��
	@jztpbxje		ut_money,		--��׼��ƶ���ս��		1.28��
	@qtfpbxje		ut_money,		--������ƶ�������		1.28��
	@zhdyje			ut_money		--�˻����ý��
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
	@jsxh	--�������
	@syxh	--��ҳ���
	@jslb	--0Ԥ��1����
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��]
exec usp_zjyb_zyjs_ex1
[�޸ļ�¼]
**********************/
set nocount on

declare	@now		ut_rq16,		--��ǰʱ��
		@zje		ut_money,		--�ܽ��
		@ybzje		ut_money,		--ҽ���ܽ��
		@sfje		ut_money,		--ʵ�ս��
		@sfje1		ut_money,		--ʵ�ս��
		@sfje2		ut_money,		--������ʵ�ս��
		@srbz		ut_bz,			--�����־
		@srje		ut_money,		--������		
		@xmzfbl		numeric(12,4),	--�Ը�����				
		@xmce		ut_money,		--�Ը����ʹ����Ը������ܵĲ��
		@ybzje_ys	ut_money,		--ҽ��Ԥ���ܽ��
		@ybxjzf_ys	ut_money,		--ҽ��Ԥ������Էѽ��
		@ybgwyfh_ys	ut_money, 		--ҽ��Ԥ�㹫��Ա����
		@zhdyje_ys	ut_money,		--ҽ��Ԥ���˻����ý��
		@zhdyje_hz	ut_money,		--�˻����ý���ܺ�
		@qzrq		ut_rq16,		--������ֹ����
		@zzrq		ut_rq16,		--������ֹ����
		@configCQ01 varchar(10)

select @now=convert(char(8),getdate(),112)+convert(char(8),getdate(),8),
	   @zje=0, @ybzje=0, @sfje=0, @sfje1=0, @sfje2=0, @srje=0, 
	   @xmzfbl=0, @xmce=0, @ybzje_ys=0, @ybxjzf_ys=0, @ybgwyfh_ys=0,
	   @zhdyje_ys=0, @zhdyje_hz=0

IF EXISTS (SELECT 1 FROM ZY_BRJSK a(NOLOCK) WHERE a.xh = @jsxh AND a.syxh = @syxh AND a.ybjszt = 2 )
BEGIN
    select "F","�ò��˽�������ѽ��㣬������Ԥ�����㣡" + CONVERT(VARCHAR(12),@jsxh)
	return
END

select @configCQ01 = ISNULL(config,'DR') from YY_CONFIG where id = 'CQ01'
	   
--����HIS�ܽ��
if exists(select 1 from ZY_BRSYK(nolock) where syxh = @syxh and brzt in (2,4))
begin
	select @zje = zje - yhje from ZY_BRJSK where syxh = @syxh and xh = @jsxh
	if @@rowcount=0
	begin
		select "F","��סԺ�����¼�����ڣ�"
		return
	END
    --��ȥ���ϴ��Ĳ��ֽ��  ���������ϴ����ֿ���û���Ƚ��㣬�ͻ���ҽ����Ԥ��
	select @zje = @zje - ISNULL(sum(zje-yhje),0) from ZY_BRFYMXK(nolock) where syxh = @syxh and jsxh = @jsxh AND ISNULL(ybscbz,0) = 3
end
else
begin
	--�����ܶ�   
	select @zje = isnull(sum(xmje),0) from YY_CQYB_ZYFYMXK(nolock) where syxh = @syxh and jsxh = @jsxh and isnull(ybscbz,0) = 1
	if @@rowcount=0
	begin
		select "F","��סԺ�����¼�����ڣ�"
		return
	end
end 

/********************
���ν����ܽ��=ͳ��֧��+�˻�֧��+����Ա����+�ֽ�֧��+���������+�����ֶ���ҽ�ƻ�����֧+�Ͷ�ҩ��Ŀ֧�����+һ������֧����
+�񻪾�������֧����+��������֧��+�����ֽ�֧��+���˻���֧��+�����ֽ�֧��+���˵����ֻ�����֧
********************/
select @ybzje = @tczf + @zhzf + @gwybz + @xjzf + @delpje + @dbzyljgdz + @ndyxmzfje + @ybzlzfje + @shjzjjzfje
			  + @syjjzf + @syxjzf + @gsjjzf + @gsxjzf + @gsdbzjgdz 

if @configCQ01 = 'WD'
begin
    select @ybzje = @ybzje + @mzjzje--+@ybzlzfje --20181016��ʱ��ȷ�������һ��ҽԺͳ���Ƿ����һ������֧��
END
	
--if abs(@zje - @ybzje)>0.1
--begin
--	select "F","HIS�ܶ��ҽ���ܶһ�£�"
--	return
--end

--����ҽ�������Ը����=HIS�ܽ��-(ҽ���ܽ��-�ֽ�֧��-�����ֽ�֧��-�����ֽ�֧��)-�˻����ý��-��ʷ���߹���Ա����
select @sfje = @zje - (@ybzje - @xjzf - @syxjzf - @gsxjzf) - @zhdyje - @lsqfxgwyfh 

if @zje > 0
	select @xmzfbl = @sfje/@zje

select @sfje1=@sfje
	
select @srbz=config from YY_CONFIG (nolock) where id='5007'
if @@error<>0 or @@rowcount=0
	select @srbz='0'

declare @srfs varchar(1)  --0����ȷ���֣�1����ȷ����--20150430
select @srfs = config from YY_CONFIG (nolock) where id='2235'
if @@error <> 0 or @@rowcount = 0
select @srfs = '0'
if @srfs = '1'---��1����ȷ����
begin 
	/*С�����봦�� begin*/
	if @srbz = '5'
		select @sfje2 = round(@sfje1, 1)
	else if @srbz = '6'
		exec usp_yy_wslr @sfje1,1,@sfje2 output
	else if @srbz >= '1' and @srbz <= '9'
		exec usp_yy_wslr @sfje1,1,@sfje2 output,@srbz
	else
		select @sfje2 = @sfje1

	select @srje = @sfje2 - @sfje1
	/*С�����봦�� begin*/
end
else 
	select @sfje2 = @sfje1

select dxmdm,round((xmje-zfje-yhje)*@xmzfbl,2) as zfje, zfje as zfyje
into #sfmx2
from ZY_BRJSMXK where jsxh = @jsxh
if @@rowcount>0
begin
	select @xmce=@sfje - sum(zfje) from #sfmx2
	update #sfmx2 set zfje = zfje + zfyje
		
	set rowcount 1
	update #sfmx2 set zfje = zfje + @xmce
	set rowcount 0
end
 
begin tran
	update ZY_BRJSK set zfje = @sfje2,
		zfyje = zje - @ybzje,
		sybybzje = @ybzje-@xjzf-@syxjzf-@gsxjzf			
	where syxh = @syxh and xh = @jsxh AND ybjszt <> 2 AND jlzt = 0
	if @@error <> 0 AND @@ROWCOUNT <> 1 
	begin
		select "F","�������2��Ϣ����"
		rollback tran
		return
	end	
	
	--update ZY_BRJSMXK set zfje = b.zfje
	--from ZY_BRJSMXK a,#sfmx2 b
	--	where a.jsxh = @jsxh and a.dxmdm = b.dxmdm
	--if @@error <> 0
	--begin
	--	select "F","�������2��Ϣ����"
	--	rollback tran
	--	return
	--end

	IF EXISTS(SELECT 1 FROM YY_YBMRJYK where syxh = @syxh and jsxh = @jsxh and fyrq = convert(varchar(8),getdate(),112) )
	BEGIN
		update YY_YBMRJYK set ybje = @ybzje, 
			zfyje = zje - @ybzje,
			jsxjzf = @xjzf + @syxjzf + @gsxjzf,
			jszhzf = @zhzf + @syzhzf + @gszhzf,
			jstczf = @tczf + @syjjzf + @gsjjzf + @qtbz,
			jsdbzf = @delpje,
			jsgwybz = @gwybz,
			jsgwyret = @lsqfxgwyfh,
			mzjzje = @mzjzje,
			mzjzmzye = @mzjzmzye,
			jlzt = 1
		where syxh = @syxh and jsxh = @jsxh and fyrq = convert(varchar(8),getdate(),112)		
	END
	ELSE
	BEGIN
		DECLARE @tmp_yjlj ut_money--Ѻ���ۼ�	
		SELECT @tmp_yjlj = isnull(sum(ISNULL(jje,0)-ISNULL(dje,0)),0) 
		FROM ZYB_BRYJK c WHERE c.syxh = @syxh AND c.jsxh = @jsxh;
  		
		INSERT INTO YY_YBMRJYK
		(syxh,centerid,jsxh,fyrq,jlzt,yjlj,zje,yhje,zfyje,ybje,jsxjzf,
		jszhzf,jstczf,jsdbzf,jsgwybz,jsgwyret,mzjzje,mzjzmzye)
		SELECT @syxh,a.centerid,@jsxh,convert(varchar(8),getdate(),112),1,@tmp_yjlj,b.zje,b.yhje,b.zje - @ybzje,@ybzje,@xjzf + @syxjzf + @gsxjzf,
		@zhzf + @syzhzf + @gszhzf,@tczf + @syjjzf + @gsjjzf + @qtbz,@delpje,@gwybz,@lsqfxgwyfh,@mzjzje,@mzjzmzye
		from ZY_BRSYK a (nolock) INNER JOIN ZY_BRJSK b (nolock) ON a.syxh = b.syxh  
		where a.syxh = @syxh AND b.xh = @jsxh and a.brzt in (1,5,6,7) and b.jlzt=0 and b.jszt=0 and b.ybjszt not in (2,5);			
	END;

	if @@error <> 0
	begin
		select "F","����YY_YBMRJYK��Ϣ����"
		rollback tran
		return
	end
	
	IF NOT EXISTS(SELECT 1 FROM ZY_BRJSK WHERE xh = @jsxh AND ybjszt = 2)
	BEGIN
        delete from ZY_BRJSJEK where jsxh = @jsxh
		if @@error <> 0
		begin
			select "F","ɾ��ZY_BRJSJEK��Ϣ����"
			rollback tran
			return
		end
	
		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, 'yb01', 'ͳ��֧��', @tczf, null)
		if @@error <> 0
		begin
			select "F","����ͳ��֧����Ϣ����"
			rollback tran
			return
		end
	
		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, 'yb02', '�˻�֧��', @zhzf, null)
		if @@error <> 0
		begin
			select "F","�����˻�֧����Ϣ����"
			rollback tran
			return
		end
	
		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, 'yb03', '����Ա����', @gwybz, null)
		if @@error <> 0
		begin
			select "F","���湫��Ա������Ϣ����"
			rollback tran
			return
		end
	
		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, 'yb04', '�ֽ�֧��', @xjzf, null)
		if @@error <> 0
		begin
			select "F","�����ֽ�֧����Ϣ����"
			rollback tran
			return
		end

		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, 'yb05', '���������', @delpje, null)
		if @@error <> 0
		begin
			select "F","��������������Ϣ����"
			rollback tran
			return
		end

		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, 'yb06', '��ʷ���߹���Ա����', @lsqfxgwyfh, null)
		if @@error <> 0
		begin
			select "F","������ʷ���߹���Ա������Ϣ����"
			rollback tran
			return
		end

		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, 'yb07', '�˻����', @zhye, null)
		if @@error <> 0
		begin
			select "F","�����˻������Ϣ����"
			rollback tran
			return
		end

		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, 'yb08', '������ҽ�ƻ�����֧', @dbzyljgdz, null)
		if @@error <> 0
		begin
			select "F","���浥����ҽ�ƻ�����֧��Ϣ����"
			rollback tran
			return
		end

		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, 'yb09', '�����������', @mzjzje, null)
		if @@error <> 0
		begin
			select "F","�����������������Ϣ����"
			rollback tran
			return
		end

		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, 'yb10', '���������������', @mzjzmzye, null)
		if @@error <> 0
		begin
			select "F","���������������������Ϣ����"
			rollback tran
			return
		end

		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, 'yb11', '�Ͷ�ҩ��Ŀ֧�����', @ndyxmzfje, null)
		if @@error <> 0
		begin
			select "F","�����Ͷ�ҩ��Ŀ֧�������Ϣ����"
			rollback tran
			return
		end

		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, 'yb12', 'һ������֧����', @ybzlzfje, null)
		if @@error <> 0
		begin
			select "F","����һ������֧������Ϣ����"
			rollback tran
			return
		end

		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, 'yb13', '�񻪾�������֧����', @shjzjjzfje, null)
		if @@error <> 0
		begin
			select "F","�����񻪾�������֧������Ϣ����"
			rollback tran
			return
		end

		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, 'yb14', '����ͳ��֧���ۼ�', @bntczflj, null)
		if @@error <> 0
		begin
			select "F","���汾��ͳ��֧���ۼ���Ϣ����"
			rollback tran
			return
		end

		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, 'yb15', '������֧���ۼ�', @bndezflj, null)
		if @@error <> 0
		begin
			select "F","���汾����֧���ۼ���Ϣ����"
			rollback tran
			return
		end

		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, 'yb16', '�ز�����֧���ۼ�', @tbqfxzflj, null)
		if @@error <> 0
		begin
			select "F","�����ز�����֧���ۼ���Ϣ����"
			rollback tran
			return
		end

		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, 'yb17', '�Ͷ�ҩ��Ŀ�ۼ�', @ndyxmlj, null)
		if @@error <> 0
		begin
			select "F","�����Ͷ�ҩ��Ŀ�ۼ���Ϣ����"
			rollback tran
			return
		end

		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, 'yb18', '������������סԺ֧���ۼ�', @bnmzjzzyzflj, null)
		if @@error <> 0
		begin
			select "F","���汾����������סԺ֧���ۼ���Ϣ����"
			rollback tran
			return
		end

		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, 'yb19', '���Ľ���ʱ��', 0, @zxjssj)
		if @@error <> 0
		begin
			select "F","�������Ľ���ʱ����Ϣ����"
			rollback tran
			return
		end

		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, 'yb20', '��������֧�����', @bcqfxzfje, null)
		if @@error <> 0
		begin
			select "F","���汾������֧�������Ϣ����"
			rollback tran
			return
		end

		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, 'yb21', '���ν���ҽ����Χ����', @bcjrybfwfy, null)
		if @@error <> 0
		begin
			select "F","���汾�ν���ҽ����Χ������Ϣ����"
			rollback tran
			return
		end
	
		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, 'yb22', 'ҩ�·����֧����', @ysfwzfje, null)
		if @@error <> 0
		begin
			select "F","����ҩ�·����֧������Ϣ����"
			rollback tran
			return
		end
	
		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, 'yb23', 'ҽԺ����ۿ���', @yycbkkje, null)
		if @@error <> 0
		begin
			select "F","����ҽԺ����ۿ�����Ϣ����"
			rollback tran
			return
		end
	
		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, 'yb24', '��������֧��', @syjjzf, null)
		if @@error <> 0
		begin
			select "F","������������֧����Ϣ����"
			rollback tran
			return
		end
	
		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, 'yb25', '�����ֽ�֧��', @syxjzf, null)
		if @@error <> 0
		begin
			select "F","���������ֽ�֧����Ϣ����"
			rollback tran
			return
		end
	
		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, 'yb26', '���˻���֧��', @gsjjzf, null)
		if @@error <> 0
		begin
			select "F","���湤�˻���֧����Ϣ����"
			rollback tran
			return
		end
	
		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, 'yb27', '�����ֽ�֧��', @gsxjzf, null)
		if @@error <> 0
		begin
			select "F","���湤���ֽ�֧����Ϣ����"
			rollback tran
			return
		end
	
		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, 'yb28', '���˵����ֻ�����֧', @gsdbzjgdz, null)
		if @@error <> 0
		begin
			select "F","���湤�˵����ֻ�����֧��Ϣ����"
			rollback tran
			return
		end
	
		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, 'yb29', '����ȫ�Է�ԭ��', 0, @gsqzfyy)
		if @@error <> 0
		begin
			select "F","���湤��ȫ�Է�ԭ����Ϣ����"
			rollback tran
			return
		end
	
		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, 'yb30', '��������', @qtbz, null)
		if @@error <> 0
		begin
			select "F","��������������Ϣ����!"
			rollback tran
			return
		END
	
		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, 'yb31', '�����˻�֧��', @syzhzf ,null)
		if @@error <> 0
		begin
			select "F","���������˻�֧����Ϣ����!"
			rollback tran
			return
		END
	
		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, 'yb32', '�����˻�֧��', @gszhzf, null)
		if @@error <> 0
		begin
			select "F","���湤���˻�֧����Ϣ����!"
			rollback tran
			return
		end

		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, 'yb33', '���ν����ƶ��Ա���', 0, @bcjsfprylb)
		if @@error <> 0
		begin
			select "F","���汾�ν����ƶ��Ա�����Ϣ����!"
			rollback tran
			return
		end

		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, 'yb34', '������ƶҽ�ƻ���', @jkfpyljj, NULL)
		if @@error <> 0
		begin
			select "F","���潡����ƶҽ�ƻ�����Ϣ����!"
			rollback tran
			return
		end
	
		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, 'yb35', '��׼��ƶ���ս��', @jztpbxje, NULL)
		if @@error <> 0
		begin
			select "F","���澫׼��ƶ���ս����Ϣ����!"
			rollback tran
			return
		end

		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, 'yb36', '������ƶ�������', @qtfpbxje, NULL)
		if @@error <> 0
		begin
			select "F","����������ƶ���������Ϣ����!"
			rollback tran
			return
		end
	
		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)                            
		values(@jsxh, 'yb98', 'ҽ�����', @zje-@ybzje, null)  ----����HIS�ܽ���ҽ�������ܽ��Ĳ��                                  
		if @@error<>0                                    
		begin                                   
		   select "F","����ҽ�������Ϣ����"                                    
		   rollback tran                                    
		   return                                    
		end

		insert into ZY_BRJSJEK(jsxh, lx, mc, je, memo)
		values(@jsxh, 'yb99', '�˻����ý��', @zhdyje, null)
		if @@error <> 0
		begin
			select "F","�����˻����ý����Ϣ����"
			rollback tran
			return
		end
	END
	 
commit tran
	
select "T", @sfje2

return
GO
