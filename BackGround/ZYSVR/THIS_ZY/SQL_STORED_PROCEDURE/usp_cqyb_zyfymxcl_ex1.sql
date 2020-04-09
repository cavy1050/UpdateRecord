if exists(select 1 from sysobjects where name='usp_cqyb_zyfymxcl_ex1')
  drop proc usp_cqyb_zyfymxcl_ex1
go
Create proc usp_cqyb_zyfymxcl_ex1
(
    @syxh		ut_syxh,		--��ҳ���
    @jsxh		ut_xh12,		--�������
    @delphi		smallint = 1,	--0=��̨���ã�1=ǰ̨���� 
    @errmsg		varchar(150) = null output
)
as
/****************************************
[�汾��]4.0.0.0.0
[����ʱ��]2018.07.13
[����]qinfj
[��Ȩ]Copyright ? 1998-2017���������Ƽ����Źɷ����޹�˾
[����]סԺ���ø���ϸ����,�����ü��Գ岻�ϴ�
[����˵��]
	HISסԺ���ø���ϸ����
[����˵��]
    @syxh	 --��ҳ���
    @jsxh	 --�������
    @delphi	 --0=��̨���ã�1=ǰ̨���� 
    @errmsg	 --���
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��]
[�޸ļ�¼]
****************************************/  
set nocount ON

create table #fymx
(
	xh				ut_xh12		not null,		--��ϸ���
	txh				ut_xh12			null,		--�����
	cfrq			ut_rq16			null,		--��������
	idm				ut_xh9			null,		--ҩƷidm
	xmdm			ut_xmdm			null,		--��Ŀ����
	xmmc			ut_mc64			null,		--��Ŀ����
	xmgg			ut_mc32			null,		--���
	xmdj			ut_money		null,		--����
	xmsl			ut_sl10			null,		--����
	xmdw			ut_unit			null,		--��λ
	xmje			ut_money	    null,		--���
	ksdm			ut_ksdm			null,		--���Ҵ���
	ysdm			ut_czyh			null,		--ҽ������
	jbr				ut_czyh			null,		--������
	jlzt			ut_bz			null		--��¼״̬
)
create index idx_xh on #fymx(xh)
create index idx_txh on #fymx(txh)

select * into #brfymxk from ZY_BRFYMXK(nolock) where syxh = @syxh and jsxh = @jsxh and isnull(ybscbz,0) in (0,2) and zje <> 0

UPDATE #brfymxk SET tfxh = 0 WHERE ypsl > 0

if @@rowcount>0
begin
    insert into #fymx(xh,txh,cfrq,idm,xmdm,xmmc,xmgg,xmdj,xmsl,xmdw,xmje,ksdm,ysdm,jbr,jlzt)
	select xh,tfxh,(case when isnull(ybzxrq,'') <> '' then ybzxrq else zxrq end),idm,ypdm,ypmc,ypgg,
		round((zje-yhje)/ypsl,4),ypsl,ypdw,zje-yhje,ksdm,ysdm,czyh,0
	from #brfymxk(nolock) order by xh

	--�����ϴ���־Ϊ2
    update a set ybscbz = 2 from ZY_BRFYMXK a(nolock) inner join #fymx b on a.xh = b.xh where a.syxh = @syxh
    if @@error <> 0
	begin
        select @errmsg = "F����ZY_BRFYMXK��¼״̬ʧ��"
        if @delphi = 1 
			select "F","����ZY_BRFYMXK��¼״̬ʧ��"
		return
	end

    DECLARE @xh 		ut_xh12,
	        @txh		ut_xh12
	--��txh�Ѿ������ʹ�õĸ���Ϊ0  ��,������ָ�txh�Ѿ������ʹ��,�򽫸��˷Ѽ�¼��txh���³�0
	declare cs_temp cursor for
	select xh,isnull(txh,0) from #fymx WHERE xh <> txh AND ISNULL(txh,0) <> 0 order by xh
	open cs_temp
	fetch cs_temp into @xh,@txh
	while @@fetch_status = 0
	begin
	    IF EXISTS(SELECT 1 FROM YY_CQYB_ZYFYMXK a(NOLOCK) WHERE a.syxh = @syxh AND a.jsxh=@jsxh AND a.xh <> a.txh AND ISNULL(txh,0) =@txh)
	    BEGIN
	        UPDATE #fymx SET txh = 0 WHERE xh=@xh
	    END

	    FETCH cs_temp into @xh,@txh
	end
	close cs_temp
	deallocate cs_temp
	
	--�����ѵ����м������¼��#YY_CQYB_ZYFYMXK��
	select syxh,jsxh,xh,txh,cfrq,idm,xmdm,xmmc,xmgg,xmdj,xmsl,xmdw,xmje,ksdm,ysdm,jbr,isnull(ktsl,xmsl) as ktsl,
		isnull(ktje,xmje) as ktje,ybscbz
	into #YY_CQYB_ZYFYMXK 
	from YY_CQYB_ZYFYMXK(nolock)
	where syxh = @syxh and jsxh = @jsxh
	if @@error <> 0
	begin
        select @errmsg = "F����#YY_CQYB_ZYFYMXKԭ�м�¼ʧ��"
        if @delphi = 1
			select "F","����#YY_CQYB_ZYFYMXKԭ�м�¼ʧ��"
		return
	end
	
	insert into #YY_CQYB_ZYFYMXK(syxh,jsxh,xh,txh,cfrq,idm,xmdm,xmmc,xmgg,xmdj,xmsl,xmdw,xmje,ksdm,ysdm,jbr,ktsl,ktje,ybscbz)
	select @syxh,@jsxh,xh,txh,cfrq,idm,xmdm,xmmc,xmgg,xmdj,xmsl,xmdw,xmje,ksdm,ysdm,jbr,xmsl,xmje,0
	from #fymx(nolock) where xmje > 0
	if @@error <> 0
	begin
        select @errmsg = "F����#YY_CQYB_ZYFYMXK����¼ʧ��"
        if @delphi = 1
			select "F","����#YY_CQYB_ZYFYMXK����¼ʧ��"
		return
	END
    
	create index idx_xh on #YY_CQYB_ZYFYMXK(xh)

	delete from #fymx where xmje > 0
	if @@error <> 0
	begin
        select @errmsg = "Fɾ����ʱ������¼ʧ��"
        if @delphi = 1
			select "F","ɾ����ʱ������¼ʧ��"
		return
	end
	
	--����¼���� 
	declare 
		@dyxh		ut_xh12,	        
        @idm		ut_xh12,
		@xmdm		varchar(20),
		@xmdj		numeric(10,4),
		@xmsl		numeric(10,2),
		@xmje		numeric(18,2),
		@zxmdj		numeric(10,4),
		@zxmsl		numeric(10,2),
		@zxmje		numeric(18,2),
		@cfrq		ut_rq16,
		@xmmc       VARCHAR(100),
	    @ybscbz     ut_bz
	declare cs_fjlcl cursor for
	select xh,idm,xmdm,xmmc,xmsl,ISNULL(txh,0) from #fymx where isnull(jlzt,0) = 0 order by cfrq,xh
	open cs_fjlcl
	fetch cs_fjlcl into @xh,@idm,@xmdm,@xmmc,@xmsl,@txh
	while @@fetch_status = 0
	BEGIN
	    --�ж��������Ƿ񹻳��
	    IF (SELECT SUM(a.ktsl) FROM #YY_CQYB_ZYFYMXK a WHERE a.idm = @idm AND a.xmdm = @xmdm AND a.xmsl > 0) < ABS(@xmsl)
		BEGIN
		    select @errmsg = "F�����쳣��"+ @xmmc + "�������úϼ�����С�ڸ����úϼ�["+ cast(@xh as varchar(20))+"]"
            if @delphi=1
				SELECT "F","�����쳣��"+ @xmmc + "�������úϼ�����С�ڸ����úϼ�["+ cast(@xh as varchar(20))+"]"
		END
		--ѭ��Ѱ�ҳ������¼
		while exists(select 1 from #fymx where xh = @xh and xmsl < 0 and isnull(jlzt,0) = 0)
		BEGIN
            select @xmdj = xmdj,@xmsl = xmsl,@xmje = xmje,@cfrq = cfrq from #fymx where xh = @xh
            select @zxmje = 0,@zxmsl = 0,@zxmdj = 0,@dyxh =0

			IF EXISTS(select 1 from #YY_CQYB_ZYFYMXK(nolock) where syxh = @syxh AND xh = @txh AND idm = @idm and xmdm = @xmdm AND ktsl > 0 )
			BEGIN
                select @dyxh = xh from #YY_CQYB_ZYFYMXK where syxh = @syxh and xh = @txh and idm = @idm and xmdm = @xmdm AND ktsl > 0  
			END
            ELSE
            BEGIN
				if exists(select 1 from #YY_CQYB_ZYFYMXK(nolock) where syxh = @syxh and idm = @idm and xmdm = @xmdm and xmdj = @xmdj and ktsl = abs(@xmsl)) 
				begin
					select @dyxh = (select top 1 xh from #YY_CQYB_ZYFYMXK(nolock) 
					where syxh = @syxh and idm = @idm and xmdm = @xmdm and xmdj = @xmdj and ktsl = abs(@xmsl) order by ktsl DESC,cfrq asc)
				end
				else
				begin
					if exists(select 1 from #YY_CQYB_ZYFYMXK(nolock) where syxh = @syxh and idm = @idm and xmdm = @xmdm and xmdj = @xmdj and ktsl > 0 ) 
					begin
						select @dyxh = (select top 1 xh from #YY_CQYB_ZYFYMXK(nolock) 
						where syxh = @syxh and idm = @idm and xmdm = @xmdm and xmdj = @xmdj and ktsl > 0 order by ktsl asc,cfrq asc)
					end
					else  
					begin
						IF EXISTS (select 1 from #YY_CQYB_ZYFYMXK(nolock) where syxh = @syxh and xmdm = @xmdm and idm = @idm and ktsl > 0 )      
							select @dyxh= (select top 1 xh from #YY_CQYB_ZYFYMXK(nolock) 
							where syxh = @syxh and xmdm = @xmdm and idm = @idm and ktsl > 0 order by ktsl asc,cfrq asc)
						ELSE
							select @dyxh= (select top 1 xh from #YY_CQYB_ZYFYMXK(nolock) 
							where syxh = @syxh and xmdm = @xmdm and idm = @idm and ktsl > 0 ORDER by ktsl asc,cfrq asc)
					end
				END
			END
			if (@@error<>0) or (@@rowcount=0) or (@dyxh is null)
			begin
                select @errmsg = "F���á�"+ @xmmc + "���Ҳ����ɱ��Գ�����["+ cast(@xh as varchar(20))+"]"
                if @delphi=1
					SELECT "F","���á�"+ @xmmc + "���Ҳ����ɱ��Գ�����["+ cast(@xh as varchar(20))+"]"
				close cs_fjlcl
				deallocate cs_fjlcl 
				return
			end
			
            --ȡ��Ӧ������¼�ĵ��ۺͽ����Ϣ
			select @zxmje = ktje,@zxmsl = ktsl,@zxmdj = xmdj from #YY_CQYB_ZYFYMXK(nolock) where xh = @dyxh
			--���۲�һ��ʱ������Ŀ�۸�Ϊ��׼�۸񣬽������ĵ��ۺ���������Ϊ�����ĵ��ۣ�ͬʱ��������
			--�˴���ì�ܣ������ϲ����������������Ϊ�˷Ѷ�����ԭ����,�������˼��㵥��ʱ�����������������
            if @zxmdj <> @xmdj   
            begin
				select @xmdj = @zxmdj,@xmsl = convert(numeric(10,2),@xmje/@zxmdj)
                update #fymx set xmdj = @zxmdj,xmsl = convert(numeric(10,2),xmje/@zxmdj) where xh = @xh
				if @@error<>0
				begin
                    select @errmsg = "F���¸����õ�������ʧ��"
                    if @delphi = 1
						select "F","���¸����õ�������ʧ��"
					close cs_fjlcl
					deallocate cs_fjlcl 
					return
				end
            END
            
            --ȡ��������Ŀ�����帺����������ȫ��
			if @zxmsl+@xmsl <= 0
			BEGIN
			    SELECT @ybscbz = 3  --���ϴ�
				update #YY_CQYB_ZYFYMXK set ktje = 0,ktsl = 0,ybscbz = @ybscbz where xh = @dyxh
				if @@error<>0
				begin
                    select @errmsg = "F����������ʧ��"
                    if @delphi = 1
						select "F","����������ʧ��"
					close cs_fjlcl
					deallocate cs_fjlcl 
					return
				end
                --��¼��ʣ�¶���û�ó��
				update #fymx set xmsl = xmsl + @zxmsl,xmje = xmje + @zxmje
				where xh = @xh
				if @@error<>0
				begin
                    select @errmsg = "F���¸�����ʧ��"
                    if @delphi = 1
						select "F","���¸�����ʧ��"
					close cs_fjlcl
					deallocate cs_fjlcl 
					return
				END

                --�����Ѿ�����ļ�¼
				IF not EXISTS(SELECT 1 FROM #YY_CQYB_ZYFYMXK a WHERE a.xh = @xh )
				BEGIN
					insert into #YY_CQYB_ZYFYMXK(syxh,jsxh,xh,txh,cfrq,idm,xmdm,xmmc,xmgg,xmdj,xmsl,xmdw,xmje,ksdm,ysdm,jbr,ktsl,ktje,ybscbz)
					select syxh,jsxh,@xh,@dyxh,@cfrq,idm,xmdm,xmmc,xmgg,@zxmdj,-@zxmsl,xmdw,-@zxmje,ksdm,ysdm,jbr,0,0,3
					from #YY_CQYB_ZYFYMXK(nolock) where xh = @dyxh				
					if @@error<>0
					begin
						select @errmsg = "F���븺����ʧ��1"
						if @delphi=1
							select "F","���븺����ʧ��1"
						close cs_fjlcl
						deallocate cs_fjlcl 
						return
					END
				END
				ELSE
				BEGIN
				    UPDATE #YY_CQYB_ZYFYMXK SET xmsl = xmsl - @zxmsl,xmje = xmje - @zxmje WHERE xh = @xh 
					if @@error<>0
					begin
						SELECT @errmsg = "F���¸�������Ϣʧ��1"
						IF @delphi = 1
							select "F","���¸�������Ϣʧ��1"
						close cs_fjlcl
						deallocate cs_fjlcl 
						return
					END 
				END
			end
			else if @zxmsl + @xmsl > 0--ȡ��������Ŀ�����㹻�帺
			BEGIN
			    --���ϴ�������������ϴ�δ�ϴ��������� 
			    IF EXISTS (SELECT 1 FROM YY_CQYB_ZYFYMXK WHERE xh = @dyxh AND ISNULL(ybscbz,0) = 1 ) 
				    SELECT @ybscbz = 4  
				ELSE 
				    SELECT @ybscbz = 5
				update #YY_CQYB_ZYFYMXK set ktsl = @zxmsl + @xmsl,ktje = @zxmje + @xmje,ybscbz = @ybscbz where xh = @dyxh
				if @@error<>0
				begin
                    select @errmsg = "F����������ʧ��2"
                    if @delphi = 1
						select "F","����������ʧ��2"
					close cs_fjlcl
					deallocate cs_fjlcl 
					return
				END

                --�����Ѵ����־Ϊ1
				update #fymx set jlzt = 1 where xh = @xh
				if @@error<>0
				begin
                    SELECT @errmsg = "F���¸�����״̬ʧ��2"
                    IF @delphi = 1
						select "F","���¸�����״̬ʧ��2"
					close cs_fjlcl
					deallocate cs_fjlcl 
					return
				END
                --�����Ѿ�����ļ�¼
				IF NOT EXISTS(SELECT 1 FROM #YY_CQYB_ZYFYMXK a WHERE a.xh = @xh )
				BEGIN
					insert into #YY_CQYB_ZYFYMXK(syxh,jsxh,xh,txh,cfrq,idm,xmdm,xmmc,xmgg,xmdj,xmsl,xmdw,xmje,ksdm,ysdm,jbr,ktsl,ktje,ybscbz)
					select syxh,jsxh,@xh,@dyxh,@cfrq,idm,xmdm,xmmc,xmgg,@xmdj,@xmsl,xmdw,@xmje,ksdm,ysdm,jbr,0,0,3
					from #YY_CQYB_ZYFYMXK(nolock) where xh = @dyxh
					if @@error<>0
					begin
						select @errmsg = "F���븺����ʧ��"
						if @delphi = 1
							select "F","���븺����ʧ��"
						close cs_fjlcl
						deallocate cs_fjlcl 
						return
					end
				END
				ELSE
				BEGIN
				    UPDATE #YY_CQYB_ZYFYMXK SET xmsl = xmsl + @xmsl,xmje = xmje + @xmje WHERE xh = @xh
					if @@error<>0
					begin
						SELECT @errmsg = "F���¸�������Ϣʧ��"
						IF @delphi = 1
							select "F","���¸�������Ϣʧ��"
						close cs_fjlcl
						deallocate cs_fjlcl 
						return
					END 
				END                  
			END
		end
		fetch cs_fjlcl into @xh,@idm,@xmdm,@xmmc,@xmsl,@txh
	end
	close cs_fjlcl
	deallocate cs_fjlcl

	--�ͽ����˶��ܽ��
    declare @jskzje ut_money,@mxkzje ut_money
    select @jskzje = 0,@mxkzje = 0
	select @jskzje = zje-yhje from ZY_BRJSK(nolock) where syxh = @syxh and xh = @jsxh
	--��ȥ���ϴ��Ĳ��ֽ��  ���������ϴ����ֿ���û���Ƚ��㣬�ͻ���ҽ����Ԥ��
	select @jskzje = @jskzje - ISNULL(sum(zje-yhje),0) from ZY_BRFYMXK(nolock) where syxh = @syxh and jsxh = @jsxh AND ISNULL(ybscbz,0) = 3 
	
	select @mxkzje = isnull(sum(ktje),0) from #YY_CQYB_ZYFYMXK(nolock) where syxh = @syxh and jsxh = @jsxh
	if abs(@jskzje - @mxkzje) > 0.5
	begin
        select @errmsg = "F�������"+convert(varchar(20),@jskzje)+"����ϸ����"+convert(varchar(20),@mxkzje)+"��һ��"
        if @delphi = 1
			select "F","�������"+convert(varchar(20),@jskzje)+"����ϸ����"+convert(varchar(20),@mxkzje)+"��һ��"
		return
	end

	begin tran
	update YY_CQYB_ZYFYMXK set xmdj = b.xmdj,xmsl = b.xmsl,ktje = b.ktje,ktsl = b.ktsl
	      ,ybscbz = b.ybscbz  --���Ѿ������м���״̬����
		from YY_CQYB_ZYFYMXK a(nolock),#YY_CQYB_ZYFYMXK b(nolock)
			where a.syxh = @syxh and a.jsxh = @jsxh and a.xh = b.xh and b.xmsl > 0
	if @@error <> 0
	begin
        select @errmsg = "F���±�YY_CQYB_ZYFYMXK����ʧ��"
        if @delphi = 1
			select "F","���±�YY_CQYB_ZYFYMXK����ʧ��"
		rollback tran
		return
	end
	 
	--�ǲ�ҩ������ϸ
	insert into YY_CQYB_ZYFYMXK(syxh,jsxh,xh,txh,cfh,cfrq,idm,xmdm,xmmc,xmgg,xmdj,xmsl,xmdw,xmje,ksdm,ysdm,jbr,jzbz,zzfbz,
		ktsl,ktje,spbz,spclbz,ybscbz)
	select a.syxh,a.jsxh,a.xh,a.txh,a.xh,a.cfrq,a.idm,a.xmdm,a.xmmc,a.xmgg,a.xmdj,a.xmsl,a.xmdw,a.xmje,a.ksdm,a.ysdm,
		a.jbr,0,"",a.ktsl,a.ktje,0,0,a.ybscbz
	from #YY_CQYB_ZYFYMXK a(nolock) inner join ZY_BRFYMXK b(nolock) on a.xh = b.xh 
	inner join YY_SFDXMK c(nolock) on c.id=b.dxmdm and c.ypbz<>3
	where not exists(select 1 from YY_CQYB_ZYFYMXK c(nolock) where a.xh = c.xh and a.txh = c.txh)
	if @@error <> 0
	begin
        select @errmsg = "F�����YY_CQYB_ZYFYMXK����ʧ��"
        if @delphi = 1
			select "F","�����YY_CQYB_ZYFYMXK����ʧ��"
		rollback tran
		return
	end
	
	--��ҩ������ϸ
	insert into YY_CQYB_ZYFYMXK(syxh,jsxh,xh,txh,cfh,cfrq,idm,xmdm,xmmc,xmgg,xmdj,xmsl,xmdw,xmje,ksdm,ysdm,jbr,jzbz,zzfbz,
		ktsl,ktje,spbz,spclbz,ybscbz)
	select a.syxh,a.jsxh,a.xh,a.txh,(CASE ISNULL(b.yzxh,0) WHEN 0 THEN b.qqxh else b.yzxh END),a.cfrq,a.idm,a.xmdm,a.xmmc,a.xmgg,a.xmdj,a.xmsl,a.xmdw,a.xmje,a.ksdm,a.ysdm,
		a.jbr,0,"",a.ktsl,a.ktje,0,0,a.ybscbz
	from #YY_CQYB_ZYFYMXK a(nolock) inner join ZY_BRFYMXK b(nolock) on a.xh = b.xh 
	inner join YY_SFDXMK c(nolock) on c.id=b.dxmdm and c.ypbz=3
	where not exists(select 1 from YY_CQYB_ZYFYMXK c(nolock) where a.xh = c.xh and a.txh = c.txh)
	if @@error <> 0
	begin
        select @errmsg = "F�����YY_CQYB_ZYFYMXK����ʧ��"
        if @delphi = 1
			select "F","�����YY_CQYB_ZYFYMXK����ʧ��"
		rollback tran
		return
	end
	
    update ZY_BRFYMXK set ybscbz = 1 where syxh = @syxh and jsxh = @jsxh and isnull(ybscbz,0) = 2
	if @@error <> 0
	begin
        select @errmsg = "F����ZY_BRFYMXK�ϴ���־ʧ��"
        if @delphi = 1
			select "F","����ZY_BRFYMXK�ϴ���־ʧ��"
		rollback tran
		return
	end
	
    update YY_CQYB_ZYFYMXK set txh = xh where syxh = @syxh and jsxh = @jsxh and txh = 0 
	if @@error <> 0
	begin
        select @errmsg = "F���±�YY_CQYB_ZYFYMXK����ʧ��txh"
        if @delphi = 1
			select "F","���±�YY_CQYB_ZYFYMXK����ʧ��txh"
		rollback tran
		return
	END
        
	commit tran	
end

drop table #fymx

select @errmsg = "T������ϸ�ɹ�"
if @delphi = 1
	select "T","������ϸ�ɹ�"
	
return


GO
