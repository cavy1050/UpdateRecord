Text
CREATE proc usp_cqyb_sfcl_ex1
(
	@jssjh			ut_sjh,			--�վݺ�
	@jslb			ut_bz,			--0Ԥ��1����
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
/****************************************
[�汾��]4.0.0.0.0
[����ʱ��]2017.03.05
[����]FerryMan
[��Ȩ]Copyright ? 1998-2017���������Ƽ����Źɷ����޹�˾
[����]����ҽ����������Ϣ
[����˵��]
	����ҽ����������Ϣ
[����˵��]
	@jssjh	--�վݺ�
	@jslb	--0Ԥ��1����
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��]
[�޸ļ�¼]
ͳ��+�˻�+����Ա����+�ֽ�֧��+���������+�����ֶ���ҽ�ƻ�����֧+�Ͷ�ҩ��Ŀ֧�����+һ������֧����+�񻪾�������֧����
+��������֧��+�����ֽ�֧��+���˻���֧��+�����ֽ�֧��+���˵����ֻ�����֧
****************************************/
set nocount on

declare	@patid		ut_xh12,		--����id
		@now		ut_rq16,		--��ǰʱ��
		@srbz		ut_bz,			--�����־
		@zje		ut_money,		--�ܽ��
		@ybzje		ut_money,		--ҽ���ܽ��
		@sfje		ut_money,		--ʵ�ս��
		@sfje1		ut_money,		--ʵ�ս��
		@sfje2		ut_money,		--������ʵ�ս��
		@srje		ut_money,		--������
		@xmzfbl		numeric(8,4),	--�Ը�����	
		@xmce		ut_money,		--�Ը����ʹ����Ը������ܵĲ��
		@yjbz		ut_bz,			--�Ƿ�ʹ�ó�ֵ��
		@yjye		ut_money,		--Ԥ�������
		@yjzfje		ut_money,		--Ԥ����֧�����
		@yjyebz		varchar(2),  	--��ֵ�������Ƿ���������շ�
		@qkbz		ut_bz,			--Ƿ���־0��������1�����ˣ�2��Ƿ��
		@qkje		ut_money,		--Ƿ������˽�
		@ybzje_ys	ut_money,		--ҽ��Ԥ���ܽ��
		@ybxjzf_ys	ut_money,		--ҽ��Ԥ������Էѽ��
		@ybgwyfh_ys	ut_money,		--ҽ��Ԥ�㹫��Ա����
		@zhdyje_ys	ut_money,		--ҽ��Ԥ���˻����ý��
		@zhdyje_hz	ut_money,		--�˻����ý���ܺ�
		@czksfbz	ut_bz,			--��ֵ���շѱ�־
		@byzg_yhje	ut_money,		--��Ժְ���Żݽ��
        @errmsg      varchar(100),
		@configCQ01 varchar(10)
		,@config2136 varchar(10)='��'  --tsyhje�����Ż� 
		,@tsyhje	ut_money		--tsyhje�Ͳ���2136�й�,�ܽ��Ҫ����ҽ����������ҽ������֮�����Ż�

select @now=convert(char(8),getdate(),112) + convert(char(8),getdate(),8),
	   @zje=0, @ybzje=0, @sfje=0, @sfje1=0, @sfje2=0, @srje=0, @xmzfbl=0, 
	   @xmce=0, @yjbz=0, @yjye=0, @yjzfje=0, @qkbz=0, @qkje=0, @ybzje_ys=0,  
	   @ybxjzf_ys=0, @ybgwyfh_ys=0, @zhdyje_ys=0, @zhdyje_hz=0, @czksfbz=1,@byzg_yhje=0,@errmsg=''
	   ,@tsyhje=0

--����HIS�ܽ��
select @patid = patid,@zje = zje-yhje ,@tsyhje=tsyhje  
--(CASE ghsfbz WHEN 1 then zje-yhje ELSE zje END)  --�Һ�Ҳ���Ż�
 FROM SF_BRJSK(nolock) where sjh = @jssjh
if @@rowcount=0
begin
	select "F","���շѽ����¼������!"
	return
end

select @configCQ01 = ISNULL(config,'DR') from YY_CONFIG where id = 'CQ01'
select @config2136=ISNULL(config,'��') from YY_CONFIG where id = '2136'
/********************
���ν����ܽ��=ͳ��֧��+�˻�֧��+����Ա����+�ֽ�֧��+���������+�����ֶ���ҽ�ƻ�����֧+�Ͷ�ҩ��Ŀ֧�����+һ������֧����
+�񻪾�������֧����+��������֧��+�����ֽ�֧��+���˻���֧��+�����ֽ�֧��+���˵����ֻ�����֧+��������+�����˻�֧��+�����˻�֧��
(����)ͳ���������������һ������(һ��ҽԺ��)���Ͷ�ҩ  ���񻪾����Ѿ�û����
(���)ͳ�ﲻ��������������һ������(һ��ҽԺ��) 
********************/
select @ybzje = @tczf + @zhzf + @gwybz + @xjzf + @delpje + @dbzyljgdz --+ @ndyxmzfje + @ybzlzfje + @shjzjjzfje
			  + @syjjzf + @syxjzf + @gsjjzf + @gsxjzf + @gsdbzjgdz + @qtbz + @syzhzf + @gszhzf
if @configCQ01 = 'WD'
begin
    select @ybzje = @ybzje + @mzjzje --+@ybzlzfje --20181016��ʱ��ȷ�������һ��ҽԺͳ���Ƿ����һ������֧��
END

if abs(@zje - @ybzje)>0.1
begin
	select "F","HIS�ܶ��ҽ���ܶһ��!"
	return
end

----chenhong add 20191125 ����ҽԺҪ���޸� begin
if exists (select 1 from SF_JEMXK a(nolock) where jssjh=@jssjh and a.lx='yb23' and je>19)
begin
	select "F","ҽԺ�渶������1Ԫ�����ܽ��㣡"
	return
end
----chenhong add 20191125 ����ҽԺҪ���޸� end

if @jslb = 0
begin
    --У���˻����ý��
    IF EXISTS (SELECT 1 FROM YY_CQYB_MZDYJLK(nolock) where jssjh = @jssjh and jlzt = 1)
	begin
		select @zhdyje_hz = ISNULL(sum(isnull(dyje,0)),0) from YY_CQYB_MZDYJLK(nolock) where jssjh = @jssjh and jlzt = 1
	
		if @zhdyje <> @zhdyje_hz
		begin
			select "F","�˻����ý��������!"
			return
		END
    end
end
if @jslb = 1 
begin
	select @ybzje_ys = sum(isnull(je,0)) from SF_JEMXK(nolock) 
	where jssjh = @jssjh and lx in ('yb01','yb02','yb03','yb04','yb05','yb08','yb11','yb13','yb24','yb25','yb26','yb27','yb28','yb30','yb31','yb32')
	
	if @configCQ01 = 'WD'
	begin
		select @ybzje_ys = @ybzje_ys + sum(isnull(je,0)) from SF_JEMXK(nolock) where jssjh = @jssjh and lx in( 'yb09','yb12')--20181016��ʱ��ȷ��yb12,��д��
	end

	select @ybxjzf_ys = sum(isnull(je,0)) from SF_JEMXK(nolock) where jssjh = @jssjh and lx in ('yb04','yb25','yb27')
	
	select @ybgwyfh_ys = isnull(je,0) from SF_JEMXK(nolock) where jssjh = @jssjh and lx = 'yb06'
	
	select @zhdyje_ys = isnull(je,0) from SF_JEMXK(nolock) where jssjh = @jssjh and lx = 'yb99'
	
	--У���˻����ý��
	select @zhdyje_hz = ISNULL(sum(isnull(dyje,0)),0) from YY_CQYB_MZDYJLK(nolock) where jssjh = @jssjh and jlzt = 2
	
	if @zhdyje <> @zhdyje_hz
	begin
		select "F","�˻����ý��������!"
		return
	end
end;

--����ҽ�������Ը����=HIS�ܽ��-(ҽ���ܽ��-�ֽ�֧��-�����ֽ�֧��-�����ֽ�֧��)-�˻����ý��-��ʷ���߹���Ա���� -(�����Żݽ��)
select @sfje = @zje - (@ybzje - @xjzf - @syxjzf - @gsxjzf) - @zhdyje - @lsqfxgwyfh -(case when @config2136='��' and @jslb=1 then @tsyhje else 0 end )

--��Ժְ���Һ��Żݽ��@byzg_yhje
IF EXISTS(select 1 from SF_BRJSK(nolock) where sjh = @jssjh AND ISNULL(ghsfbz,0)=0)
BEGIN
    EXEC usp_cqyb_ynzg_gh '02',@jssjh,@sfje,@errmsg OUTPUT,@byzg_yhje OUTPUT
    if @errmsg like "F%"
	begin
		select "F",@errmsg
		return 
	END
	SELECT @sfje = @sfje - @byzg_yhje
END

select @yjye = yjye from YY_JZBRK(nolock) where patid = @patid and jlzt = 0
if @@rowcount = 0
	select @yjye = 0
else
	select @yjbz = 1

select @yjyebz = config from YY_CONFIG where id = '2059'
if @@rowcount = 0 or @@error <> 0
begin
	select "F","��ֵ�������Ƿ���������շ����ò���ȷ!"
	return
end

if @zje > 0
	select @xmzfbl = @sfje/@zje

select @sfje1 = @sfje
select @srbz = config from YY_CONFIG (nolock) where id='2016'
if @@error <> 0 or @@rowcount = 0
	select @srbz = '0'

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

--���������˷����    
if exists(select 1 from SF_BRJSK(nolock) where sjh = @jssjh and isnull(tsjh,'') <> '' and qkbz = 3)
begin
    select @yjye = @yjye - b.qkje
    from SF_BRJSK a(nolock),VW_MZBRJSK b(nolock)
    where a.sjh = @jssjh and a.tsjh = b.sjh
end 

if @czksfbz = 1 --�ӳ�ֵ���շ�
begin
	if @yjbz = 1
	begin
		if @yjyebz = '��' and @yjye < @sfje2
		begin
			select 'F','��ֵ������,���ȳ�ֵ:�Ը���'+convert(varchar(20),@sfje2)+'Ԫ����Ѻ����'+convert(varchar(20),@yjye)+'Ԫ������'+convert(varchar(20),@sfje2-@yjye)+'Ԫ��!' 
			return
		end
	
		if (@yjye > 0) and (@sfje2 > 0)
		begin
			if @sfje2 <= @yjye
				select @qkje = @sfje2
			else
			begin
				select @qkje = @yjye
				if @srfs = '1'---1����ȷ������������20110426
				begin
					select @qkje = round(@yjye,1,1) ---ȥ��С��λ
				end 
	        end
	        select @qkbz = 3,@yjzfje = @qkje
		end
	end
end

--���������ܽ��
select dxmdm,round((xmje-zfyje-yhje)*@xmzfbl,2) as zfje,zfyje
into #sfmx2
from SF_BRJSMXK(nolock) where jssjh = @jssjh
if @@rowcount>0
begin
	select @xmce = @sfje - sum(zfje) from #sfmx2
	update #sfmx2 set zfje = zfje + zfyje
		
	set rowcount 1
	update #sfmx2 set zfje = zfje + @xmce
	set rowcount 0
end
	
begin tran
	update SF_BRJSK set sfrq = @now,
		zfje = @sfje2,
		srje = @srje,
		ybjszt = 1,
		qkje = @qkje,
		qkbz = @qkbz,
		yhje = ISNULL(yhje,0) + @byzg_yhje,
		zxlsh = @zxlsh
	where sjh = @jssjh
	if @@error <> 0
	begin
		select "F","���������Ϣ����!"
		rollback tran
		return
	end

	update SF_BRJSMXK set zfje = b.zfje
	from SF_BRJSMXK a,#sfmx2 b
	where a.jssjh = @jssjh and a.dxmdm = b.dxmdm
	if @@error <> 0
	begin
		select "F","���������ϸ��Ϣ����!"
		rollback tran
		return
	end

	delete from SF_JEMXK where jssjh = @jssjh
	if @@error <> 0
	begin
		select "F","ɾ����������Ϣ����!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb01', 'ͳ��֧��', @tczf, null)
	if @@error <> 0
	begin
		select "F","����ͳ��֧����Ϣ����!"
		rollback tran
		return
	end
	
	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb02', '�˻�֧��', @zhzf, null)
	if @@error <> 0
	begin
		select "F","�����˻�֧����Ϣ����!"
		rollback tran
		return
	end
	
	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb03', '����Ա����', @gwybz, null)
	if @@error <> 0
	begin
		select "F","���湫��Ա������Ϣ����!"
		rollback tran
		return
	end
	
	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb04', '�ֽ�֧��', @xjzf, null)
	if @@error <> 0
	begin
		select "F","�����ֽ�֧����Ϣ����!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb05', '���������', @delpje, null)
	if @@error <> 0
	begin
		select "F","��������������Ϣ����!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb06', '��ʷ���߹���Ա����', @lsqfxgwyfh, null)
	if @@error <> 0
	begin
		select "F","������ʷ���߹���Ա������Ϣ����!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb07', '�˻����', @zhye, null)
	if @@error <> 0
	begin
		select "F","�����˻������Ϣ����!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb08', '������ҽ�ƻ�����֧', @dbzyljgdz, null)
	if @@error <> 0
	begin
		select "F","���浥����ҽ�ƻ�����֧��Ϣ����!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb09', '�����������', @mzjzje, null)
	if @@error <> 0
	begin
		select "F","�����������������Ϣ����!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb10', '���������������', @mzjzmzye, null)
	if @@error <> 0
	begin
		select "F","���������������������Ϣ����!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb11', '�Ͷ�ҩ��Ŀ֧�����', @ndyxmzfje, null)
	if @@error <> 0
	begin
		select "F","�����Ͷ�ҩ��Ŀ֧�������Ϣ����!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb12', 'һ������֧����', @ybzlzfje, null)
	if @@error <> 0
	begin
		select "F","����һ������֧������Ϣ����!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb13', '�񻪾�������֧����', @shjzjjzfje, null)
	if @@error <> 0
	begin
		select "F","�����񻪾�������֧������Ϣ����!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb14', '����ͳ��֧���ۼ�', @bntczflj, null)
	if @@error <> 0
	begin
		select "F","���汾��ͳ��֧���ۼ���Ϣ����!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb15', '������֧���ۼ�', @bndezflj, null)
	if @@error <> 0
	begin
		select "F","���汾����֧���ۼ���Ϣ����!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb16', '�ز�����֧���ۼ�', @tbqfxzflj, null)
	if @@error <> 0
	begin
		select "F","�����ز�����֧���ۼ���Ϣ����!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb17', '�Ͷ�ҩ��Ŀ�ۼ�', @ndyxmlj, null)
	if @@error <> 0
	begin
		select "F","�����Ͷ�ҩ��Ŀ�ۼ���Ϣ����!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb18', '������������סԺ֧���ۼ�', @bnmzjzzyzflj, null)
	if @@error <> 0
	begin
		select "F","���汾����������סԺ֧���ۼ���Ϣ����!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb19', '���Ľ���ʱ��', 0, @zxjssj)
	if @@error <> 0
	begin
		select "F","�������Ľ���ʱ����Ϣ����!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb20', '��������֧�����', @bcqfxzfje, null)
	if @@error <> 0
	begin
		select "F","���汾������֧�������Ϣ����!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb21', '���ν���ҽ����Χ����', @bcjrybfwfy, null)
	if @@error <> 0
	begin
		select "F","���汾�ν���ҽ����Χ������Ϣ����!"
		rollback tran
		return
	end
	
	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb22', 'ҩ�·����֧����', @ysfwzfje, null)
	if @@error <> 0
	begin
		select "F","����ҩ�·����֧������Ϣ����!"
		rollback tran
		return
	end
	
	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb23', 'ҽԺ����ۿ���', @yycbkkje, null)
	if @@error <> 0
	begin
		select "F","����ҽԺ����ۿ�����Ϣ����!"
		rollback tran
		return
	end
	
	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb24', '��������֧��', @syjjzf, null)
	if @@error <> 0
	begin
		select "F","������������֧����Ϣ����!"
		rollback tran
		return
	end
	
	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb25', '�����ֽ�֧��', @syxjzf, null)
	if @@error <> 0
	begin
		select "F","���������ֽ�֧����Ϣ����!"
		rollback tran
		return
	end
	
	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb26', '���˻���֧��', @gsjjzf, null)
	if @@error <> 0
	begin
		select "F","���湤�˻���֧����Ϣ����!"
		rollback tran
		return
	end
	
	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb27', '�����ֽ�֧��', @gsxjzf, null)
	if @@error <> 0
	begin
		select "F","���湤���ֽ�֧����Ϣ����!"
		rollback tran
		return
	end
	
	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb28', '���˵����ֻ�����֧', @gsdbzjgdz, null)
	if @@error <> 0
	begin
		select "F","���湤�˵����ֻ�����֧��Ϣ����!"
		rollback tran
		return
	end
	
	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb29', '����ȫ�Է�ԭ��', 0, @gsqzfyy)
	if @@error <> 0
	begin
		select "F","���湤��ȫ�Է�ԭ����Ϣ����!"
		rollback tran
		return
	END
	
	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb30', '��������', @qtbz, NULL)
	if @@error <> 0
	begin
		select "F","��������������Ϣ����!"
		rollback tran
		return
	END
	
	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb31', '�����˻�֧��', @syzhzf, NULL)
	if @@error <> 0
	begin
		select "F","���������˻�֧����Ϣ����!"
		rollback tran
		return
	END
	
	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb32', '�����˻�֧��', @gszhzf, NULL)
	if @@error <> 0
	begin
		select "F","���湤���˻�֧����Ϣ����!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb33', '���ν����ƶ��Ա���', 0, @bcjsfprylb)
	if @@error <> 0
	begin
		select "F","���汾�ν����ƶ��Ա�����Ϣ����!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb34', '������ƶҽ�ƻ���', @jkfpyljj, NULL)
	if @@error <> 0
	begin
		select "F","���潡����ƶҽ�ƻ�����Ϣ����!"
		rollback tran
		return
	end
	
	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb35', '��׼��ƶ���ս��', @jztpbxje, NULL)
	if @@error <> 0
	begin
		select "F","���澫׼��ƶ���ս����Ϣ����!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb36', '������ƶ�������', @qtfpbxje, NULL)
	if @@error <> 0
	begin
		select "F","����������ƶ���������Ϣ����!"
		rollback tran
		return
	end

	insert into SF_JEMXK(jssjh, lx, mc, je, memo)
	values(@jssjh, 'yb99', '�˻����ý��', @zhdyje, null)
	if @@error <> 0
	begin
		select "F","�����˻����ý����Ϣ����!"
		rollback tran
		return
	end
commit tran
	
if @jslb = 1
begin
	if abs(@ybzje - @ybzje_ys) > 0.1 or abs(@xjzf + @syxjzf + @gsxjzf - @ybxjzf_ys) > 0.1 or abs(@lsqfxgwyfh - @ybgwyfh_ys) > 0.1
		or abs(@zhdyje - @zhdyje_ys) > 0.1
	begin
	    select "R","ҽ����ʽ����ʱ�����ҽ��Ԥ��ʱ��һ��!�밴�����շѷ�Ʊ�ϵĽ���շ�!"
	    return
	end
end

select "T", @sfje2, @qkbz, @yjzfje

return


