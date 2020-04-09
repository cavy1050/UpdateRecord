if exists(select 1 from sysobjects where name = 'usp_cqyb_saveybjzinfo')
  drop proc usp_cqyb_saveybjzinfo
go
CREATE proc usp_cqyb_saveybjzinfo
(
	@jsxh				ut_sjh,				--�������
	@syxh				ut_syxh,			--��ҳ���
    @sbkh				varchar(20),		--��ᱣ�Ϻ���
	@xtbz				ut_bz,				--ϵͳ��־0�Һ�1�շ�2סԺ�Ǽ�3סԺ��Ϣ����
    @xzlb				ut_bz,				--�������
    @cblb				ut_bz,				--�α����
    @jzlsh				varchar(20),		--סԺ(������)��
    @zgyllb				varchar(10),		--ҽ�����
    @ksdm				ut_ksdm,			--���Ҵ���
    @ysdm				ut_czyh,			--ҽ������
    @ryrq				varchar(10),		--��Ժ����
    @ryzd				varchar(20),		--��Ժ���
    @cyrq				varchar(10),		--��Ժ����
    @cyzd				varchar(20),		--��Ժ��� 
    @cyyy				varchar(10),		--��Ժԭ��
    @bfzinfo			varchar(200),		--����֢��Ϣ
    @jzzzysj			varchar(10),		--����תסԺʱ��
    @bah				varchar(20),		--������
    @syzh				varchar(20),		--����֤��
    @xsecsrq			varchar(10),		--��������������
    @jmyllb				varchar(10),		--�������������
    @gsgrbh				varchar(10),		--���˸��˱��
    @gsdwbh				varchar(10),		--���˵�λ���
    @zryydm				varchar(14),		--ת��ҽԺ����
    @zxlsh              varchar(20)='',     --������ˮ��
    @zhye               varchar(20)='',     --�˻����
    @yzcyymc            varchar(50)=''   --ԭת��ҽԺ����       
)
as
/****************************************
[�汾��]4.0.0.0.0
[����ʱ��]2017.03.05
[����]FerryMan
[��Ȩ]Copyright ? 1998-2017���������Ƽ����Źɷ����޹�˾
[����]����ҽ������Ǽ���Ϣ
[����˵��]
	����ҽ������Ǽ���Ϣ
[����˵��]
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��]
[�޸ļ�¼]
****************************************/
set nocount on
	declare @now ut_rq16,@retcode varchar(10)='T',@retMsg varchar(1000)=''
	select @now=convert(char(8),getdate(),112)+convert(char(8),getdate(),8)
	if exists(select 1 from sysobjects where name = 'usp_cqyb_checkybjzxx' and xtype='P')
	begin
	exec usp_cqyb_checkybjzxx @jsxh,@syxh,@sbkh,@xtbz,@xzlb,@cblb,@jzlsh,@zgyllb,
							@ksdm,@ysdm,@ryrq,@ryzd,@cyrq,@cyzd,@cyyy,@bfzinfo,@jzzzysj,@bah,
							@syzh,@xsecsrq,@jmyllb,@gsgrbh,@gsdwbh,@zryydm,@zxlsh,@zhye,@yzcyymc,@retcode output, @retMsg output
		if @retcode='F'--���ʧ��ֱ�ӷ�����ʾ
		begin
			select @retcode,@retMsg
			return
		end
		--R��Tʱ��ֱ����󷵻�
	end
if @xtbz in (0,1)
begin
	declare @ghsfbz		ut_bz,	--�Һ��շѱ�־
			@bftfbz		ut_bz	--�����˷ѱ�־
			
	select @ghsfbz = ghsfbz from SF_BRJSK(nolock) where sjh = @jsxh
	if exists(select 1 from SF_BRJSK where sjh in (select tsjh from SF_BRJSK where sjh = @jsxh))
		select @bftfbz = 1
	else
		select @bftfbz = 0
	
	if exists(select 1 from YY_CQYB_MZJZJLK where jssjh = @jsxh and jlzt = 1)
	begin
		select "F","��������Ϣ������Ч��ҽ���Ǽ���Ϣ!"
		return
	end
	--����SF_BRJSK�е�medtype
	update SF_BRJSK set medtype = 
	CASE WHEN @cblb IN (1,3,4) THEN @zgyllb WHEN @cblb IN (2,5) THEN @jmyllb ELSE medtype END	
	where sjh =@jsxh

	if @ghsfbz = 0 
	begin 
		select @ryrq = substring(ghrq,1,4)+'-'+substring(ghrq,5,2)+'-'+substring(ghrq,7,2),@ksdm = isnull(ksdm,""),
			   @ysdm = isnull(ysdm,"") 
		from GH_GHZDK(nolock) where jssjh = @jsxh
		if not exists(select 1 from YY_CQYB_MZJZJLK where jssjh = @jsxh and jlzt = 0)
		begin
			insert into YY_CQYB_MZJZJLK(jssjh,sbkh,xzlb,cblb,jzlsh,zgyllb,ksdm,ysdm,ryrq,ryzd,cyrq,cyzd,cyyy,bfzinfo,
				jzzzysj,bah,syzh,xsecsrq,jmyllb,gsgrbh,gsdwbh,zryydm,jlzt)
			select @jsxh,@sbkh,@xzlb,@cblb,@jsxh,@zgyllb,@ksdm,@ysdm,@ryrq,@cyzd,@ryrq,@cyzd,@cyyy,@bfzinfo,
				@jzzzysj,@bah,@syzh,@xsecsrq,@jmyllb,@gsgrbh,@gsdwbh,@zryydm,0
			if @@error<>0 or @@rowcount = 0 
			begin
				select "F","����ҽ������Ǽ���Ϣʧ��!"
				return
			end;
		end
		else
		begin
			update YY_CQYB_MZJZJLK set sbkh = @sbkh,xzlb = @xzlb,cblb = @cblb,jzlsh = @jzlsh,zgyllb = @zgyllb,ksdm = @ksdm,ysdm = @ysdm,
				ryrq = @ryrq,ryzd = @cyzd,cyrq = @ryrq,cyzd = @cyzd,cyyy = @cyyy,bfzinfo = @bfzinfo,jzzzysj = @jzzzysj,
				bah = @bah,syzh = @syzh,xsecsrq = @xsecsrq,jmyllb = @jmyllb,gsgrbh = @gsgrbh,gsdwbh = @gsdwbh,zryydm = @zryydm
			where jssjh = @jsxh and jlzt = 0
			if @@error<>0 or @@rowcount = 0 
			begin
				select "F","����ҽ������Ǽ���Ϣʧ��!"
				return
			end;
		end
	end
	else if @ghsfbz = 1
	begin
		if @bftfbz = 0 
		begin
			select @ryrq = substring(a.sfrq,1,4)+'-'+substring(a.sfrq,5,2)+'-'+substring(a.sfrq,7,2),
				@ksdm = isnull(b.ksdm,""),@ysdm = isnull(b.ysdm,"") 
			from SF_BRJSK a(nolock) inner join SF_MZCFK b(nolock) on a.sjh = b.jssjh
			where sjh = @jsxh
			
			if not exists(select 1 from YY_CQYB_MZJZJLK where jssjh = @jsxh and jlzt = 0)
			begin
				insert into YY_CQYB_MZJZJLK(jssjh,sbkh,xzlb,cblb,jzlsh,zgyllb,ksdm,ysdm,ryrq,ryzd,cyrq,cyzd,cyyy,bfzinfo,
					jzzzysj,bah,syzh,xsecsrq,jmyllb,gsgrbh,gsdwbh,zryydm,jlzt)
				select @jsxh,@sbkh,@xzlb,@cblb,@jsxh,@zgyllb,@ksdm,@ysdm,@ryrq,@cyzd,@ryrq,@cyzd,@cyyy,@bfzinfo,
					@jzzzysj,@bah,@syzh,@xsecsrq,@jmyllb,@gsgrbh,@gsdwbh,@zryydm,0
				if @@error<>0 or @@rowcount = 0 
				begin
					select "F","����ҽ������Ǽ���Ϣʧ��!"
					return
				end;
			end
			else
			begin
				update YY_CQYB_MZJZJLK set sbkh = @sbkh,xzlb = @xzlb,cblb = @cblb,jzlsh = @jzlsh,zgyllb = @zgyllb,ksdm = @ksdm,ysdm = @ysdm,
				ryrq = @ryrq,ryzd = @cyzd,cyrq = @ryrq,cyzd = @cyzd,cyyy = @cyyy,bfzinfo = @bfzinfo,jzzzysj = @jzzzysj,
				bah = @bah,syzh = @syzh,xsecsrq = @xsecsrq,jmyllb = @jmyllb,gsgrbh = @gsgrbh,gsdwbh = @gsdwbh,zryydm = @zryydm
				where jssjh = @jsxh and jlzt = 0
				if @@error<>0 or @@rowcount = 0 
				begin
					select "F","����ҽ������Ǽ���Ϣʧ��!"
					return
				end;
			end;
		end
		else if @bftfbz = 1
		begin
			select @ryrq = substring(sfrq,1,4)+'-'+substring(sfrq,5,2)+'-'+substring(sfrq,7,2)
			from SF_BRJSK(nolock) where sjh = @jsxh
			
			if not exists(select 1 from YY_CQYB_MZJZJLK where jssjh = @jsxh and jlzt = 0)
			begin
				insert into YY_CQYB_MZJZJLK(jssjh,sbkh,xzlb,cblb,jzlsh,zgyllb,ksdm,ysdm,ryrq,ryzd,cyrq,cyzd,cyyy,bfzinfo,
					jzzzysj,bah,syzh,xsecsrq,jmyllb,gsgrbh,gsdwbh,zryydm,jlzt)
				select @jsxh,c.sbkh,c.xzlb,c.cblb,@jsxh,c.zgyllb,c.ksdm,c.ysdm,@ryrq,c.ryzd,@ryrq,c.cyzd,c.cyyy,c.bfzinfo,
					c.jzzzysj,c.bah,c.syzh,c.xsecsrq,c.jmyllb,c.gsgrbh,c.gsdwbh,c.zryydm,0
				from SF_BRJSK a(nolock) inner join SF_BRJSK b(nolock) on a.tsjh = b.sjh
										inner join VW_CQYB_MZJZJLK c(nolock) on b.tsjh = c.jssjh
				where a.sjh = @jsxh
			end
		end
	end
end
else if @xtbz = 2
begin
	if exists(select 1 from YY_CQYB_ZYJZJLK where syxh = @syxh and jlzt = 1)
	begin
		select "F","��סԺ��Ϣ������Ч��ҽ���Ǽ���Ϣ!"
		return
	end

	select @ksdm = isnull(ksdm,""),@ysdm = isnull(ysdm,"") from ZY_BRSYK(nolock) where syxh = @syxh
	
	if isnull(@ryrq,"") = "" 
		select @ryrq = dbo.fun_convertrq_cqyb(0,'')
		
	if not exists(select 1 from YY_CQYB_ZYJZJLK where syxh = @syxh and jlzt = 0)
	begin
		--ҽ��ת�Է���תҽ����ʱ������Ҫ����Ϣ
		select top (1) @ryzd= CASE WHEN ISNULL(@ryzd,'') = '' 
								   THEN CASE WHEN SUBSTRING(ryzd,1,5) = 'RJSS.' THEN '' ELSE ryzd END 
		                           ELSE @ryzd END,
					   @cyzd=cyzd,@bfzinfo=bfzinfo 
		FROM YY_CQYB_ZYJZJLK(nolock) 
		WHERE syxh = @syxh and jlzt = 3 order by lrsj DESC
        
		insert into YY_CQYB_ZYJZJLK(syxh,sbkh,xzlb,cblb,jzlsh,zgyllb,ksdm,ysdm,ryrq,ryzd,cyrq,cyzd,cyyy,bfzinfo,
			jzzzysj,bah,syzh,xsecsrq,jmyllb,gsgrbh,gsdwbh,zryydm,jlzt,lrsj)
		select @syxh,@sbkh,@xzlb,@cblb,dbo.fun_getybzyh_cqyb(0,@syxh),@zgyllb,@ksdm,@ysdm,@ryrq,@ryzd,@cyrq,@cyzd,@cyyy,@bfzinfo,
			@jzzzysj,@bah,@syzh,@xsecsrq,@jmyllb,@gsgrbh,@gsdwbh,@zryydm,0,@now
		if @@error<>0 or @@rowcount = 0 
		begin
			select "F","����ҽ��סԺ�Ǽ���Ϣʧ��!"
			return
		end;
	end
	else
	begin
		if isnull(@jzlsh,"") = ""
		    select @jzlsh = dbo.fun_getybzyh_cqyb(0,@syxh)
		 
		update YY_CQYB_ZYJZJLK set sbkh = @sbkh,xzlb = @xzlb,cblb = @cblb,jzlsh = @jzlsh,zgyllb = @zgyllb,ksdm = @ksdm,ysdm = @ysdm,
				ryrq = @ryrq,ryzd = @ryzd,cyrq = @cyrq,cyzd = @cyzd,cyyy = @cyyy,bfzinfo = @bfzinfo,jzzzysj = @jzzzysj,
				bah = @bah,syzh = @syzh,xsecsrq = @xsecsrq,jmyllb = @jmyllb,gsgrbh = @gsgrbh,gsdwbh = @gsdwbh,zryydm = @zryydm
		where syxh = @syxh and jlzt = 0
		if @@error<>0 or @@rowcount = 0 
		begin
			select "F","����ҽ��סԺ�Ǽ���Ϣʧ��!"
			return
		end;
	end;
end
else if @xtbz = 3
begin
	if not exists(select 1 from YY_CQYB_ZYJZJLK where syxh = @syxh and jlzt = 1)
	begin
		select "F","��סԺ��Ϣû����Ч��ҽ���Ǽ���Ϣ!"
		return
	end
	
	update YY_CQYB_ZYJZJLK set sbkh = @sbkh,xzlb = @xzlb,cblb = @cblb,jzlsh = @jzlsh,zgyllb = @zgyllb,ksdm = @ksdm,ysdm = @ysdm,
			ryrq = @ryrq,ryzd = @ryzd,cyrq = @cyrq,cyzd = @cyzd,cyyy = @cyyy,bfzinfo = @bfzinfo,jzzzysj = @jzzzysj,
			bah = @bah,syzh = @syzh,xsecsrq = @xsecsrq,jmyllb = @jmyllb,gsgrbh = @gsgrbh,gsdwbh = @gsdwbh,zryydm = @zryydm
	where syxh = @syxh and jlzt = 1
	if @@error<>0 or @@rowcount = 0 
	begin
		select "F","����ҽ��סԺ�Ǽ���Ϣʧ��!"
		return
	end;
end

select @retcode,@retMsg
return
GO
