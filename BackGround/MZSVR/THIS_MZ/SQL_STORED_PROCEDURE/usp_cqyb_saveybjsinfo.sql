if exists(select 1 from sysobjects where name = 'usp_cqyb_saveybjsinfo')
  drop proc usp_cqyb_saveybjsinfo
go
CREATE proc usp_cqyb_saveybjsinfo
(
	@jsxh				ut_sjh,				--�������
	@syxh				ut_syxh,			--��ҳ���
	@ddyljgbm           varchar(10),         --����ҽ�ƻ�������
    @sbkh				varchar(20),		--��ᱣ�Ϻ���
	@xtbz				ut_bz,				--ϵͳ��־0�Һ�1�շ�2סԺ
    @xzlb				ut_bz,				--�������
    @jzlsh				varchar(20),		--סԺ(������)��
    @jslb				ut_bz,				--�������
    @zhzfbz				ut_bz,				--�˻�֧����־
    @zhdybz				ut_bz,				--�˻����ñ�־
    @jsqzrq				varchar(19),		--��;������ֹ����
    @jszzrq				varchar(19),		--��;������ֹ����
    @gsrdbh				varchar(10),		--�����϶����
    @gsjbbm				varchar(200),		--�����϶���������
    @cfjslx				varchar(10),		--���ν�������
    @sylb				varchar(10),		--�������
    @sysj				varchar(10),		--����ʱ��
    @sybfz				varchar(10),		--��������֢
    @ncbz				varchar(10),		--�Ѳ���־
    @rslx				varchar(10),		--��������
    @dbtbz				varchar(10),		--���̥��־
    @syfwzh				varchar(50),		--��������֤��
    @jhzh				varchar(50),		--���֤��
    @jyjc				varchar(200),		--�Ŵ�����������Ŀ
    @zxlsh				varchar(20)  		--������ˮ��
)
as
/****************************************
[�汾��]4.0.0.0.0
[����ʱ��]2017.03.05
[����]FerryMan
[��Ȩ]Copyright ? 1998-2017���������Ƽ����Źɷ����޹�˾
[����]����ҽ��������Ϣ
[����˵��]
	����ҽ��������Ϣ
[����˵��]
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��]
[�޸ļ�¼]
****************************************/
set nocount on
declare @now ut_rq16,
	    @cyzd VARCHAR(20),
		@bfzinfo VARCHAR(200)

select @now=convert(char(8),getdate(),112)+convert(char(8),getdate(),8)

if @xtbz in (0,1)
begin
	declare @ghsfbz		ut_bz,	--�Һ��շѱ�־
			@bftfbz		ut_bz	--�����˷ѱ�־
			
	select @ghsfbz = ghsfbz from SF_BRJSK(nolock) where sjh = @jsxh
	if exists(select 1 from SF_BRJSK(nolock) where sjh in (select tsjh from SF_BRJSK(nolock) where sjh = @jsxh))
		select @bftfbz = 1
	else
		select @bftfbz = 0
	
	if exists(select 1 from YY_CQYB_MZJSJLK(nolock) where jssjh = @jsxh and jlzt = 2)
	begin
		select "F","��������Ϣ������Ч��ҽ���Ǽ���Ϣ!"
		return
	end

	if @ghsfbz = 0
	begin
		if not exists(select 1 from YY_CQYB_MZJSJLK(nolock) where jssjh = @jsxh and jlzt in (0,1))
		begin
			insert into YY_CQYB_MZJSJLK(jssjh,sbkh,xzlb,jzlsh,jslb,zhzfbz,zhdybz,jszzrq,gsrdbh,gsjbbm,cfjslx,
				sylb,sysj,sybfz,ncbz,rslx,dbtbz,syfwzh,jyjc,jhzh,jlzt,ddyljgbm)
			select @jsxh,@sbkh,@xzlb,@jsxh,@jslb,@zhzfbz,@zhdybz,@jszzrq,@gsrdbh,@gsjbbm,@cfjslx,
				@sylb,@sysj,@sybfz,@ncbz,@rslx,@dbtbz,@syfwzh,@jyjc,@jhzh,0,@ddyljgbm
			if @@error<>0 or @@rowcount = 0 
			begin
				select "F","����ҽ�����������Ϣʧ��!"
				return
			end;
		end
		else
		begin
			update YY_CQYB_MZJSJLK set sbkh = @sbkh,xzlb = @xzlb,jzlsh = @jzlsh,jslb = @jslb,zhzfbz = @zhzfbz,zhdybz = @zhdybz,
				jszzrq = @jszzrq,gsrdbh = @gsrdbh,gsjbbm = @gsjbbm,cfjslx = @cfjslx,sylb = @sylb,sysj = @sysj,sybfz = @sybfz,
				ncbz = @ncbz,rslx = @rslx,dbtbz = @dbtbz,syfwzh = @syfwzh,jyjc = @jyjc,jhzh = @jhzh,ddyljgbm = @ddyljgbm
			where jssjh = @jsxh and jlzt = 0
			if @@error<>0 or @@rowcount = 0 
			begin
				select "F","����ҽ�����������Ϣʧ��!"
				return
			end;
		end
	end
	else if @ghsfbz = 1
	begin
		if @bftfbz = 0 
		begin
			if not exists(select 1 from YY_CQYB_MZJSJLK(nolock) where jssjh = @jsxh and jlzt in (0,1))
			begin
				insert into YY_CQYB_MZJSJLK(jssjh,sbkh,xzlb,jzlsh,jslb,zhzfbz,zhdybz,jszzrq,gsrdbh,gsjbbm,cfjslx,
					sylb,sysj,sybfz,ncbz,rslx,dbtbz,syfwzh,jyjc,jhzh,jlzt,ddyljgbm)
				select @jsxh,@sbkh,@xzlb,@jsxh,@jslb,@zhzfbz,@zhdybz,@jszzrq,@gsrdbh,@gsjbbm,@cfjslx,
					@sylb,@sysj,@sybfz,@ncbz,@rslx,@dbtbz,@syfwzh,@jyjc,@jhzh,0,@ddyljgbm
				if @@error<>0 or @@rowcount = 0 
				begin
					select "F","����ҽ�����������Ϣʧ��!"
					return
				end;
			end
			else
			begin
				update YY_CQYB_MZJSJLK set sbkh = @sbkh,xzlb = @xzlb,jzlsh = @jzlsh,jslb = @jslb,zhzfbz = @zhzfbz,zhdybz = @zhdybz,
					jszzrq = @jszzrq,gsrdbh = @gsrdbh,gsjbbm = @gsjbbm,cfjslx = @cfjslx,sylb = @sylb,sysj = @sysj,sybfz = @sybfz,
					ncbz = @ncbz,rslx = @rslx,dbtbz = @dbtbz,syfwzh = @syfwzh,jyjc = @jyjc,jhzh = @jhzh,ddyljgbm = @ddyljgbm
				where jssjh = @jsxh and jlzt = 0
				if @@error<>0 or @@rowcount = 0 
				begin
					select "F","����ҽ�����������Ϣʧ��!"
					return
				end;
			end
		end
		else if @bftfbz = 1
		begin
			if not exists(select 1 from YY_CQYB_MZJSJLK(nolock) where jssjh = @jsxh and jlzt in (0,1))
			begin
				insert into YY_CQYB_MZJSJLK(jssjh,sbkh,xzlb,jzlsh,jslb,zhzfbz,zhdybz,jszzrq,gsrdbh,gsjbbm,cfjslx,
					sylb,sysj,sybfz,ncbz,rslx,dbtbz,syfwzh,jyjc,jhzh,jlzt,ddyljgbm)
				select @jsxh,c.sbkh,c.xzlb,@jsxh,c.jslb,c.zhzfbz,0,c.jszzrq,c.gsrdbh,c.gsjbbm,c.cfjslx,
					c.sylb,c.sysj,c.sybfz,c.ncbz,c.rslx,c.dbtbz,c.syfwzh,c.jyjc,c.jhzh,0,@ddyljgbm
				from SF_BRJSK a(nolock) inner join SF_BRJSK b(nolock) on a.tsjh = b.sjh
										inner join VW_CQYB_MZJSJLK c(nolock) on b.tsjh = c.jssjh
				where a.sjh = @jsxh
				if @@error<>0 or @@rowcount = 0 
				begin
					select "F","����ҽ�����������Ϣʧ��!"
					return
				end;
			end;									
		end
	end
end
else if @xtbz in (2,3)
BEGIN
	IF @xtbz = 3 
	BEGIN
		IF EXISTS(SELECT 1 FROM ZY_BRSYK a(NOLOCK) WHERE a.syxh = @syxh AND a.brzt =3)
		BEGIN
			SELECT 'F','�ѳ�Ժ���㣬�����ٸ�����Ϣ��'
			RETURN
		END
	END

	if exists(select 1 from ZY_BRSYK (nolock) where syxh=@syxh and brzt=2 and @jslb='10')
	begin
		select "F","����Ժ����ҽ����������;���㣬�����¸���ҽ����Ϣ��"
		return
	end
	if exists(select 1 from YY_CQYB_ZYJSJLK(nolock) where syxh = @syxh and jsxh = @jsxh and jlzt = 2)
	begin
		select "F","��סԺ��Ϣ������Ч��ҽ��������Ϣ!"
		return
	end
    
	SELECT @cyzd = a.cyzd,@bfzinfo = a.bfzinfo FROM YY_CQYB_ZYJZJLK a(NOLOCK) WHERE a.syxh = @syxh
	 
    IF (ISNULL(@jszzrq,'') = '') 
    BEGIN
    	IF EXISTS(SELECT 1 FROM ZY_BRSYK a (NOLOCK) WHERE a.syxh = @syxh AND brzt IN(2,4) AND ISNULL(LEN(cqrq),0) >=8)
		BEGIN
			SELECT @jszzrq = SUBSTRING(cqrq,1,4) + '-' + SUBSTRING(cqrq,5,2) + '-' + SUBSTRING(cqrq,7,2)
			FROM ZY_BRSYK a (NOLOCK) WHERE a.syxh = @syxh AND brzt IN(2,4) AND ISNULL(LEN(cqrq),0) >=8 		
		END		
    END
    
    IF LEN(RTRIM(@jszzrq)) = 8  SELECT @jszzrq = @jszzrq + ' 23:59:59'
    
	if not exists(select 1 from YY_CQYB_ZYJSJLK(nolock) where syxh = @syxh and jsxh = @jsxh and jlzt in (0,1,3))
	begin
		insert into YY_CQYB_ZYJSJLK(syxh,jsxh,sbkh,xzlb,jzlsh,jslb,zhzfbz,zhdybz,jsqzrq,jszzrq,gsrdbh,gsjbbm,cfjslx,
			sylb,sysj,sybfz,ncbz,rslx,dbtbz,syfwzh,jyjc,jhzh,jlzt,ddyljgbm,lrsj,cyzd,bfzinfo)
		select @syxh,@jsxh,@sbkh,@xzlb,@jzlsh,@jslb,@zhzfbz,@zhdybz,@jsqzrq,@jszzrq,@gsrdbh,@gsjbbm,@cfjslx,
			@sylb,@sysj,@sybfz,@ncbz,@rslx,@dbtbz,@syfwzh,@jyjc,@jhzh,0,@ddyljgbm,@now,@cyzd,@bfzinfo
		if @@error<>0 or @@rowcount = 0 
		begin
			select "F","����ҽ��סԺ������Ϣʧ��!"
			return
		end;
	end
	else
	begin
		update YY_CQYB_ZYJSJLK set sbkh = @sbkh,xzlb = @xzlb,jzlsh = @jzlsh,jslb = @jslb,zhzfbz = @zhzfbz,zhdybz = @zhdybz,
			jsqzrq = @jsqzrq,jszzrq = @jszzrq,gsrdbh = @gsrdbh,gsjbbm = @gsjbbm,cfjslx = @cfjslx,sylb = @sylb,sysj = @sysj,
			sybfz = @sybfz,ncbz = @ncbz,rslx = @rslx,dbtbz = @dbtbz,syfwzh = @syfwzh,jyjc = @jyjc,jhzh = @jhzh,ddyljgbm = @ddyljgbm,
			cyzd = @cyzd,bfzinfo = @bfzinfo
		where syxh = @syxh and jsxh = @jsxh and jlzt in (0,1,3)
		if @@error<>0 or @@rowcount = 0 
		begin
			select "F","����ҽ��סԺ������Ϣʧ��!"
			return		
		end;
	end
end

select "T"
return

go
