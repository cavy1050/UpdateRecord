Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE proc usp_cqyb_gettransinfo
(
  @code		varchar(15),	--���״���
  @jsxh		ut_sjh,			--�����վݺ�
  @syxh		ut_syxh,		--��ҳ���
  @xtbz		ut_bz,			--ϵͳ��־0�Һ�1�շ�2סԺ
  @cxbz		ut_bz,			--��ѯ��־0�Ǽ���Ϣ1������Ϣ
  @zgdm		ut_czyh,		--����Ա��
  @jzrq		varchar(20)=''	--��ֹ����
)
as --��317365 2018-01-16 02:55:28 ������
/**********************
[�汾��]4.0.0.0.0
[����ʱ��]2017.03.05
[����]FerryMan
[��Ȩ]Copyright ? 1998-2017���������Ƽ����Źɷ����޹�˾
[����]��ȡҽ�����ײ���
[����˵��]
	HIS��ȡҽ�����ײ���
[����˵��]
@code	���״���
@jssjh	�վݺ�
@syxh	��ҳ���
@xtbz	ϵͳ��־0�Һ�1�շ�2סԺ
@zgdm	����Ա��
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��] 
[�޸ļ�¼]
**********************/       
set nocount on    
    
declare @hisbm	varchar(10),			--HIS�����̱���
		@fyze	ut_money,				--�����ܶ�
		@qzrq	ut_rq16,				--������ֹ����
		@zzrq	ut_rq16,				--������ֹ����
		@cqrq	ut_rq16,				--��������
		@mxts	int,					--������ϸ����
		@zmxts	int,					--��������ϸ����
		@fmxts	int,					--��������ϸ����
		@zyts	int,					--סԺ����
		@ysdm	ut_czyh,				--ҽ������
		@ysmc	ut_name,				--ҽ������
		@gxbz	varchar(16),			--���±�־
		@cyrq	varchar(10),			--��Ժ����
		@zybz	ut_bz,					--תԺ��־
		@czym	ut_name, 				--����Ա��
		@gcys	ut_czyh,					--�ܴ�ҽ��
		@errmsg varchar(150),
        @ryrq_old ut_rq16,	--�ϴ����շ����� 
		@jsxh_temp varchar(30),
		@cfrq_old ut_rq16	--�ϴ����շ�����
		,@sjh_ysjl ut_sjh
		,@configCQ31 VARCHAR(10)  --סԺ�Զ����������������ͨ���Ĳ�����ҽ���ǼǺ�ҽ������
		,@configCQ32 VARCHAR(10)  --סԺ�Զ���ҩƷ������δ�������ܽ���
		,@configCQ36 VARCHAR(10)
		,@configCQ39 VARCHAR(10)
		,@configCQ40 VARCHAR(10)
		,@configCQ18 VARCHAR(10)
		,@now ut_rq16		--��ǰʱ��
		,@zjldj ut_money
		,@strSql VARCHAR(500)
		,@configCQ01 VARCHAR(10)
		,@configCQ49 VARCHAR(10)
		,@gcys_mc VARCHAR(20)
		,@ydbz VARCHAR(3)  --���ҽ����־
		,@configCQ19 VARCHAR(10)
		,@configCQ50 VARCHAR(10)
		,@m_mrsfzh varchar(20) --Ĭ�ϵ����֤��
		,@configCQ58 VARCHAR(10)
        ,@patid numeric(12)
		,@configCQ64 VARCHAR(10)
		,@dbzdzje NUMERIC(12,2)
		,@ybshbz INT
		,@ybcyzdshbz INT

select @now=convert(char(8),getdate(),112)+convert(char(8),getdate(),8),@m_mrsfzh='50000020170901TY05'
--HIS�����̱���		
select @hisbm = '00114'

--����Ա��
select @czym = name from czryk where id = @zgdm 
SELECT @configCQ36 = ISNULL(config,'1') FROM YY_CONFIG(NOLOCK) WHERE id= 'CQ36'
    IF @configCQ36 = ''  SELECT @configCQ36 = '1'       

SELECT @configCQ39 = ISNULL(config,'1') FROM YY_CONFIG(NOLOCK) WHERE id= 'CQ39'
    IF ISNULL(@configCQ39,'') = ''  SELECT @configCQ39 = '197827'  
SELECT @configCQ40 = ISNULL(config,'1') FROM YY_CONFIG(NOLOCK) WHERE id= 'CQ40'
    IF ISNULL(@configCQ40,'') = ''  SELECT @configCQ40 = '67790' 

SELECT @configCQ18 = ISNULL(config,'1') FROM YY_CONFIG(NOLOCK) WHERE id= 'CQ18'
    IF @configCQ18 = ''  SELECT @configCQ18 = '1'  

SELECT @configCQ01 = ISNULL(config,'') FROM YY_CONFIG(NOLOCK) WHERE id= 'CQ01'
    IF @configCQ01 = ''  SELECT 'F','��������CQ01������' 

SELECT @configCQ49 = ISNULL(config,'��') FROM YY_CONFIG(NOLOCK) WHERE id= 'CQ49'
    IF ISNULL(@configCQ49,'') = ''  SELECT @configCQ49 = '��' 

SELECT @configCQ58 = ISNULL(config,'��') FROM YY_CONFIG(NOLOCK) WHERE id= 'CQ58'
    IF ISNULL(@configCQ58,'') = ''  SELECT @configCQ58 = '��' 
create table #tempdcxg 
( 
	sjh_ysjl varchar(20)
)

if @code = '02'		--����Ǽ�       
begin   
    --����Ǽ�
	if @xtbz in (0,1)
	BEGIN
		IF @xtbz = 0 
		BEGIN
			IF EXISTS(SELECT 1 FROM GH_GHZDK(nolock) WHERE jssjh = @jsxh AND ghlb = 9)
			BEGIN
				SELECT @ryrq_old = czrq FROM GH_GHZDK(nolock) WHERE jssjh = @jsxh AND ghlb = 9 	
			END
		END
  		  
		if @xtbz in(1)
		BEGIN
            select @patid = patid from SF_BRJSK(NOLOCK) WHERE sjh = @jsxh 
		    select * into #vw_mzbrjsk_02 from VW_MZBRJSK(NOLOCK) WHERE patid = @patid
		    
			select @ryrq_old = '',@jsxh_temp = @jsxh
			WHILE exists(select 1 from #vw_mzbrjsk_02(NOLOCK) where sjh = @jsxh_temp and isnull(tsjh,'') <> '')
			begin
				SELECT @ryrq_old = sfrq ,@jsxh_temp = sjh from #vw_mzbrjsk_02(NOLOCK) 
				WHERE sjh in (select tsjh from #vw_mzbrjsk_02(NOLOCK) where sjh in (select tsjh from #vw_mzbrjsk_02(NOLOCK) where sjh = @jsxh_temp))
				--���������۵����޸�
				--if @ryrq_old > '2017090900:00:00'
				--	select @ryrq_old = ''
			end
						
			--���ڸ�һ���ӵ����޸ĵ�sjhȡԭʼ�վݺŵĴ���������Ϊ�������� 
			if  exists(select 1 from syscolumns where id=object_id('SF_BRJSK') and name='sjh_ysjl')
			begin
				EXEC('insert into #tempdcxg select isnull(sjh_ysjl,"") sjh_ysjl from #vw_mzbrjsk_02(nolock) where sjh = "'+@jsxh+'"')
				select @sjh_ysjl = isnull(sjh_ysjl,'') from #tempdcxg
				if @sjh_ysjl <> ''
				begin
					select @ryrq_old = sfrq from #vw_mzbrjsk_02(NOLOCK) where sjh = @sjh_ysjl
				end
			end
		end
		
		select "T", a.jzlsh,						--1 �����/סԺ��
					case when a.zgyllb = '' then (case when a.jmyllb = '13' then '13' when a.jmyllb = '15' then '13' else '11' end) else a.zgyllb end,
												--2 ҽ�����
					a.sbkh,						--3	�籣����
					a.ksdm,						--4 ���ұ���
					--case when isnull(ltrim(b.sfzh),'')='' THEN @m_mrsfzh ELSE b.sfzh END sfzh,--5 ҽ������--update by winning-dingsong-chongqing on 20200820
					case when isnull(ltrim(dbo.fun_getyssfzh(a.jssjh,'MZ')),'')='' THEN @m_mrsfzh ELSE dbo.fun_getyssfzh(a.jssjh,'MZ') END sfzh,
					(case when isnull(@ryrq_old,'')='' then a.ryrq else dbo.fun_convertrq_cqyb(2,@ryrq_old) end),						--6 ��Ժ����
					a.ryzd,						--7 ��Ժ���
					@czym as jbr,				--8 ������
					a.bfzinfo,					--9 ����֢
					a.jzzzysj,					--10 ����תסԺ����ʱ��
					a.bah,						--11 ������
					a.syzh,						--12 ����֤����
					a.xsecsrq,					--13 ��������������
					case when a.jmyllb = '' then (case when a.zgyllb = '13' then '13' else '12' end) else a.jmyllb end,						
												--14 �������������
					a.xzlb,						--15 �������
					a.gsgrbh,					--16 ���˸��˱��
					a.gsdwbh					--17 ���˵�λ���
		from YY_CQYB_MZJZJLK a(nolock) left join YY_ZGBMK b(nolock) on a.ysdm = b.id
		where a.jssjh = @jsxh and a.jlzt = 0
	end
	--סԺ�Ǽ�
	else if @xtbz = 2
	BEGIN
	    SELECT @configCQ31 = '��'
	    SELECT @configCQ31 = config FROM YY_CONFIG(nolock) WHERE id = 'CQ31'
	    IF @configCQ31 = '��'
	    begin
			if not exists(select 1 from YY_CQYB_ZDYZDSPJG(nolock) WHERE syxh = @syxh)
			begin
				if exists(select 1 FROM ZY_BRSYK a(nolock) inner join VW_CQYB_ZYBRRYZD b(nolock) on a.syxh = b.syxh
														   inner join YY_CQYB_ZDYSPXM c(nolock) on b.zddm = c.xmdm AND c.xmlb = '2'
					where a.syxh = @syxh and a.brzt not in (3,8,9))
				begin
					select "F","�ò���Ϊ���˲���,ҽ������δ���,���ܽ�����ҽ���Ǽǣ�"
					return	
				end								     
			end
			else
			begin
				if exists(select 1 FROM YY_CQYB_ZDYZDSPJG(nolock) where syxh = @syxh AND isnull(spjg,'0') = 2)
				begin
					select "F","�ò����ѱ�ҽ���Ʊ��Ϊ��ϲ�����ҽ�����������ܽ�����ҽ���Ǽǣ�"
					return
				end
				if exists(select 1 FROM YY_CQYB_ZDYZDSPJG(nolock) where syxh = @syxh AND isnull(spjg,'0') = 0)
				begin
					select "F","�ò����Ƿ����ҽ��������Ҫҽ�������������ܽ�����ҽ���Ǽǣ�"
					return
				end
			end
	    end
        
		IF EXISTS(SELECT 1 FROM YY_CQYB_ZYJZJLK a(NOLOCK) ,YY_CQYB_PATINFO b(NOLOCK) WHERE a.sbkh = b.sbkh AND ISNULL(b.dqfprylb,'') <> '')
            UPDATE a SET a.pkhbz = 1 FROM ZY_BRXXK a,ZY_BRSYK b(nolock) WHERE a.patid = b.patid AND b.syxh = @syxh
		ELSE
		    UPDATE a SET a.pkhbz = 0 FROM ZY_BRXXK a,ZY_BRSYK b(nolock) WHERE a.patid = b.patid AND b.syxh = @syxh
if @syxh='116494'
begin 

select "T", a.jzlsh,						--1 �����/סԺ��
					case when ISNULL(a.zgyllb,'')='' then a.jmyllb else a.zgyllb end zgyllb,						--2 ҽ�����
					a.sbkh,						--3	�籣����
					a.ksdm,						--4 ���ұ���
					--isnull((select top 1 (case when isnull(ltrim(b.sfzh),'')='' then @m_mrsfzh else b.sfzh end) 
					--from ZY_BRSYK c(nolock), YY_ZGBMK b(NOLOCK) 
					--where (case when isnull(ysdm,'')<>'' then c.ysdm else c.mzzdys end)=b.id 
					--and a.syxh=c.syxh),@m_mrsfzh),	--5 ҽ������--update by winning-dingsong-chongqing on 20200820
					case when isnull(ltrim(dbo.fun_getyssfzh(a.syxh,'ZY')),'')='' THEN @m_mrsfzh ELSE dbo.fun_getyssfzh(a.syxh,'ZY') END sfzh,
					'2019-11-29'ryrq,						--6 ��Ժ����
					a.ryzd,						--7 ��Ժ���
					@czym as jbr,				--8 ������
					a.bfzinfo,					--9 ����֢
					a.jzzzysj,					--10 ����תסԺ����ʱ��
					a.bah,						--11 ������
					a.syzh,						--12 ����֤����
					a.xsecsrq,					--13 ��������������
					case when ISNULL(a.jmyllb,'')='' then a.zgyllb else a.jmyllb END jmyllb,					--14 �������������
					a.xzlb,						--15 �������
					a.gsgrbh,					--16 ���˸��˱��
					a.gsdwbh					--17 ���˵�λ���
		from YY_CQYB_ZYJZJLK a(nolock) --left join YY_ZGBMK b(nolock) on a.ysdm = b.id
		where a.syxh = @syxh and a.jlzt = 0
end
else
		select "T", a.jzlsh,						--1 �����/סԺ��
					case when ISNULL(a.zgyllb,'')='' then a.jmyllb else a.zgyllb end zgyllb,						--2 ҽ�����
					a.sbkh,						--3	�籣����
					a.ksdm,						--4 ���ұ���
					--isnull((select top 1 (case when isnull(ltrim(b.sfzh),'')='' then @m_mrsfzh else b.sfzh end) 
					--from ZY_BRSYK c(nolock), YY_ZGBMK b(NOLOCK) 
					--where (case when isnull(ysdm,'')<>'' then c.ysdm else c.mzzdys end)=b.id 
					--and a.syxh=c.syxh),@m_mrsfzh),	--5 ҽ������--update by winning-dingsong-chongqing on 20200820
					case when isnull(ltrim(dbo.fun_getyssfzh(a.syxh,'ZY')),'')='' THEN @m_mrsfzh ELSE dbo.fun_getyssfzh(a.syxh,'ZY') END sfzh,
					a.ryrq,						--6 ��Ժ����
					a.ryzd,						--7 ��Ժ���
					@czym as jbr,				--8 ������
					a.bfzinfo,					--9 ����֢
					a.jzzzysj,					--10 ����תסԺ����ʱ��
					a.bah,						--11 ������
					a.syzh,						--12 ����֤����
					a.xsecsrq,					--13 ��������������
					case when ISNULL(a.jmyllb,'')='' then a.zgyllb else a.jmyllb END jmyllb,					--14 �������������
					a.xzlb,						--15 �������
					a.gsgrbh,					--16 ���˸��˱��
					a.gsdwbh					--17 ���˵�λ���
		from YY_CQYB_ZYJZJLK a(nolock) --left join YY_ZGBMK b(nolock) on a.ysdm = b.id
		where a.syxh = @syxh and a.jlzt = 0
	end;      
end   
else if @code = '03'	--���¾�����Ϣ
BEGIN  
	if @xtbz in (0,1)
	BEGIN		
		IF @xtbz = 0 
		BEGIN
			IF EXISTS(SELECT 1 FROM GH_GHZDK(nolock) WHERE jssjh = @jsxh AND ghlb = 9)
			BEGIN
				SELECT @ryrq_old = czrq FROM GH_GHZDK(nolock) WHERE jssjh = @jsxh AND ghlb = 9 	
			END
		END
		
		IF @xtbz in (1)
		BEGIN
            select @patid = patid from SF_BRJSK(NOLOCK) WHERE sjh = @jsxh 
		    select * into #vw_mzbrjsk_03 from VW_MZBRJSK(NOLOCK) WHERE patid = @patid

			select @ryrq_old = '',@jsxh_temp = @jsxh
			WHILE exists(select 1 from #vw_mzbrjsk_03(NOLOCK) where sjh = @jsxh_temp and isnull(tsjh,'') <> '')
			begin
				SELECT @ryrq_old = sfrq ,@jsxh_temp = sjh from #vw_mzbrjsk_03(NOLOCK) 
				WHERE sjh in (select tsjh from #vw_mzbrjsk_03(NOLOCK) where sjh in (select tsjh from #vw_mzbrjsk_03(NOLOCK) where sjh = @jsxh_temp))
				--���������۵����޸�
				--if @ryrq_old > '2017090900:00:00'
					--select @ryrq_old = ''
			end
			
			--���ڸ�һ���ӵ����޸ĵ�sjhȡԭʼ�վݺŵĴ���������Ϊ�������� 
			if  exists(select 1 from syscolumns where id=object_id('SF_BRJSK') and name='sjh_ysjl')
			begin
				EXEC('insert into #tempdcxg select isnull(sjh_ysjl,"") sjh_ysjl from #vw_mzbrjsk_03 where sjh = "'+@jsxh+'"')
				select @sjh_ysjl = isnull(sjh_ysjl,'') from #tempdcxg
				if @sjh_ysjl <> ''
				begin
					select @ryrq_old = sfrq from #vw_mzbrjsk_03(NOLOCK) where sjh = @sjh_ysjl
				end
			end
		end
		
		if exists(select 1 from YY_CQYB_MZJZJLK(nolock)  where jssjh = @jsxh and jlzt in (0,1) and isnull(cyzd,'') <> '')
			select @gxbz = '0000011000000000'
		else
			select @gxbz = '0000010000000000';
		
		IF @configCQ01 = 'DR'
		BEGIN
			select "T", jzlsh,						--1 �����/סԺ��
						@gxbz as gxbz,				--2 ���±�־
						case when zgyllb = '' then (case when jmyllb = '13' then '13' when jmyllb = '15' then '13' else '11' end) else zgyllb end,
													--3 ҽ�����
						ksdm,						--4 ���ұ���
						--case when isnull(ltrim(b.sfzh),'')='' then @m_mrsfzh else b.sfzh end,--5 ҽ������--update by winning-dingsong-chongqing on 20200820
					case when isnull(ltrim(dbo.fun_getyssfzh(a.jssjh,'MZ')),'')='' THEN @m_mrsfzh ELSE dbo.fun_getyssfzh(a.jssjh,'MZ') END sfzh,
						(case when isnull(@ryrq_old,'')='' then ryrq else dbo.fun_convertrq_cqyb(2,@ryrq_old) end),	--6 ��Ժ����
						ryzd,						--7 ��Ժ���
						CASE WHEN (@xtbz = 0) AND (isnull(@ryrq_old,'') <> '') THEN dbo.fun_convertrq_cqyb(2,@ryrq_old) 
						ELSE cyrq END,				--8 ��Ժ����
						cyzd,						--9 ��Ժ���
						cyyy,						--10 ��Ժԭ��
						@czym as jbr,				--11 ������
						bfzinfo,					--12 ����֢
						bah,						--13 ������
						syzh,						--14 ����֤����
						xsecsrq,					--15 ��������������
						case when jmyllb = '' then (case when zgyllb = '13' then '13' else '12' end) else jmyllb end,						
													--16 �������������
						xzlb,						--17 �������
						zryydm 						--18 ת��ҽԺ����
			from YY_CQYB_MZJZJLK a(nolock) left join YY_ZGBMK b(nolock) on a.ysdm = b.id
			where jssjh = @jsxh and a.jlzt in (0,1)
		END
        ELSE
        BEGIN
            select "T", jzlsh,						--1 �����/סԺ��
						SUBSTRING(@gxbz,1,15) as gxbz,				--2 ���±�־
						case when zgyllb = '' then (case when jmyllb = '13' then '13' when jmyllb = '15' then '13' else '11' end) else zgyllb end,
													--3 ҽ�����
						ksdm,						--4 ���ұ���
						--case when isnull(ltrim(b.sfzh),'')='' then @m_mrsfzh else b.sfzh end,--5 ҽ������--update by winning-dingsong-chongqing on 20200820
					case when isnull(ltrim(dbo.fun_getyssfzh(a.jssjh,'MZ')),'')='' THEN @m_mrsfzh ELSE dbo.fun_getyssfzh(a.jssjh,'MZ') END sfzh,
						(case when isnull(@ryrq_old,'')='' then ryrq else dbo.fun_convertrq_cqyb(2,@ryrq_old) end),	--6 ��Ժ����
						ryzd,						--7 ��Ժ���
						CASE WHEN (@xtbz IN (0,1) ) AND (isnull(@ryrq_old,'') <> '') THEN dbo.fun_convertrq_cqyb(2,@ryrq_old) 
						ELSE cyrq END,				--8 ��Ժ����
						cyzd,						--9 ��Ժ���
						cyyy,						--10 ��Ժԭ��
						@czym as jbr,				--11 ������
						bfzinfo,					--12 ����֢
						bah,						--13 ������
						syzh,						--14 ����֤����
						xsecsrq,					--15 ��������������
						case when jmyllb = '' then (case when zgyllb = '13' then '13' else '12' end) else jmyllb end,						
													--16 �������������
						xzlb						--17 �������
			from YY_CQYB_MZJZJLK a(nolock) left join YY_ZGBMK b(nolock) on a.ysdm = b.id
			where jssjh = @jsxh and a.jlzt in (0,1)
		END
	end
	else if @xtbz = 3
	begin
		declare @zgjmbz	ut_bz,					--ְ�������־
				@ryzd	varchar(20),			--��Ժ���
				@brzt	ut_bz,					--����״̬
				@cyyy	ut_bz					--��Ժԭ��
				,@gxryzd_bz	varchar(2)='0'			--������Ժ��ϱ�־
				,@gxcyrq_bz varchar(2)='0'		--���³�Ժ���ڱ�־
				,@03cyrq varchar(20)=''			--�жϳ�Ժ����
		
		select @zgjmbz = cblb,
			   @gxryzd_bz=case when isnull(ltrim(ryzd),'')='' then '0' else '1' end, 
			   @03cyrq=isnull(ltrim(cyrq),'')
		from YY_CQYB_ZYJZJLK(nolock) where syxh = @syxh and jlzt = 1

		select @brzt = brzt from ZY_BRSYK(nolock) where syxh = @syxh 
		IF @brzt =3 
		BEGIN
			SELECT 'F','�ѳ�Ժ���㣬�����ٸ�����Ϣ��'
			RETURN
		END

		select @ryzd = zdmc from ZY_BRZDQK(nolock) where syxh = @syxh and zdlb = 1 and zdlx = 0
		 
		
		if @brzt in (2,4) 
		begin
			select @gxcyrq_bz='1'
			select @cyrq = dbo.fun_convertrq_cqyb(2,a.cqrq),@cyyy = a.cyfs
			from ZY_BRSYK a(nolock) where a.syxh = @syxh and a.brzt not in (3,8,9)
		end
		else
		begin--��Ժ���ڱ�־���������
			if EXISTS(select 1 from YY_CQYB_ZYJSJLK a(nolock) where a.syxh=@syxh and a.jsxh=@jsxh and a.jlzt in(0,1) and a.jslb='0') and isnull(ltrim(@03cyrq),'')<>''
			begin
			--jlzt in(0,1) and jslb='0' HIS��;���㣬ҽ���������������
			----03cyrq<>'',����������Ժ����û�й���;����ʱ�䣬cyrq��Ϊ��
				select @gxcyrq_bz='1'
			end
			else
				select @gxcyrq_bz='0'
			SELECT @cyrq = dbo.fun_convertrq_cqyb(2,convert(varchar(8),dateadd(day,-1,getdate()),112)),@cyyy = '9'
		END

         if @zgjmbz in (1,3)
			    select @gxbz = '1110'+@gxryzd_bz+@gxcyrq_bz+'1111110000'
		else
				select @gxbz = '0110'+@gxryzd_bz+@gxcyrq_bz+'1111110100'
		--�����Ժԭ�����ת��
		IF EXISTS (SELECT 1 FROM YY_CQYB_YBSJZD_DZ a(NOLOCK) WHERE a.zdlb = 'CYYY')
		BEGIN
            SELECT @cyyy = CASE WHEN ISNULL(a.ybcode,'') <> '' THEN a.ybcode ELSE '9' END 
			FROM YY_CQYB_YBSJZD_DZ a(NOLOCK)
			WHERE a.zdlb = 'CYYY' AND a.hiscode = @cyyy
		END

		DECLARE @tmp_zddm			VARCHAR(20),	--��ϴ���
				@tmp_bfzinfo			VARCHAR(200)	--����֢��Ϣ
		
		IF NOT EXISTS(SELECT 1 FROM VW_CQYB_ZYBRZDQK(nolock) WHERE syxh = @syxh AND zdlb IN (2,4) AND zdlx  = 0)
		BEGIN
			select @tmp_zddm = ''
		END
		ELSE
		BEGIN
			SELECT @tmp_zddm = zddm FROM VW_CQYB_ZYBRZDQK(nolock) WHERE syxh = @syxh AND zdlb IN (2,4) AND zdlx  = 0
		END
		IF NOT EXISTS(SELECT 1 FROM VW_CQYB_ZYBRBFZ(nolock) WHERE syxh = @syxh)
		BEGIN
			SELECT @tmp_bfzinfo = '';	
		END
		ELSE
		BEGIN
			SELECT @tmp_bfzinfo = bfz FROM VW_CQYB_ZYBRBFZ(nolock) WHERE syxh = @syxh
		END

	--winning-dingsong-chongqing-add on 20200311 begin
		--��ȡ��Ժ����еĸ������Ϊ����֢
		if(replace(@tmp_bfzinfo,' ','')='')
		begin
			declare @zdms varchar(64),@bfz varchar(200)=''
			DECLARE cursor_ZY_BRZDQK CURSOR FOR --�����α�
			SELECT  zdms from ZY_BRZDQK where syxh =@syxh and  zdlb = 2 and zdlx<>0 order by zdlx 
			OPEN cursor_ZY_BRZDQK --���α�
			FETCH NEXT FROM cursor_ZY_BRZDQK INTO  @zdms
			WHILE @@FETCH_STATUS = 0
			begin
			select @bfz=@bfz+case len(@bfz) when 0 then '' else '  ' end+@zdms
			FETCH NEXT FROM cursor_ZY_BRZDQK INTO  @zdms
			end
			CLOSE cursor_ZY_BRZDQK --�ر��α�
			DEALLOCATE cursor_ZY_BRZDQK --�ͷ��α�
			select @tmp_bfzinfo=@bfz
			--print @bfz
		end
		--winning-dingsong-chongqing-add on 20200311 end
		if @cxbz = 0 
		begin
			select "T", b.sbkh,					--1 �籣����
						b.xzlb,					--2 �������
						b.cblb,					--3 �α����
						b.jzlsh,				--4 ������ˮ��
						b.zgyllb,				--5 ҽ�����
						b.ryrq,					--6 ��Ժ����
						case when isnull(b.ryzd,'')='' then  @ryzd else b.ryzd end as ryzd,			--7 ��Ժ���	
						@cyrq as cyrq,			--8 ��Ժ����						
						case when b.cyzd = '' then @tmp_zddm else b.cyzd end as cyzd,	--9 ��Ժ���		
						@cyyy AS cyyy,     --10 ��Ժԭ��
case when isnull(replace(b.bfzinfo,' ',''),'') = ''  then @tmp_bfzinfo else b.bfzinfo end as bfzinfo,   --11 ����֢
						b.bah,					--12 ������
						b.syzh,					--13 ����֤����
						b.xsecsrq,				--14 ��������������
						b.jmyllb, 				--15 �������������
						b.zhye,                 --16 �˻����
						b.yzcyymc               --17 ԭת��ҽԺ����
			from ZY_BRSYK a(nolock)
				inner join YY_CQYB_ZYJZJLK b(nolock) on a.syxh = b.syxh and b.jlzt = 1
			where a.syxh = @syxh and a.brzt not in (3,8,9)
		end
		else
		if @cxbz = 1
		begin
			if exists(select 1 from YY_CONFIG(nolock) where id='CQ51' and config='��') and  @gxryzd_bz='0'
			begin
				select "F","����¼����Ժ���"
				RETURN	 
			end
			if @configCQ01 = 'DR'
			begin
				select "T", b.jzlsh,			--1 �����/סԺ��
							@gxbz as gxbz,		--2 ���±�־
							b.zgyllb,			--3 ҽ�����
							a.ksdm,				--4 ���ұ���
							--case when isnull(ltrim(c.sfzh),'')='' then @m_mrsfzh else c.sfzh end,	--5 ҽ������isnull(c.sfzh,'50000020170901TY05')--update by winning-dingsong-chongqing on 20200820
					case when isnull(ltrim(dbo.fun_getyssfzh(a.syxh,'ZY')),'')='' THEN @m_mrsfzh ELSE dbo.fun_getyssfzh(a.syxh,'ZY') END sfzh,
							b.ryrq,				--6 ��Ժ����
							b.ryzd,				--7 ��Ժ���
							b.cyrq,				--8 ��Ժ����
							b.cyzd,				--9 ��Ժ���
							b.cyyy as cyyy,		--10 ��Ժԭ��
							@czym as jbr,		--11 ������
							b.bfzinfo ,			--12 ����֢
							b.bah,				--13 ������
							b.syzh,				--14 ����֤����
							b.xsecsrq,			--15 ��������������
							b.jmyllb,			--16 �������������
							b.xzlb,				--17 �������
							b.zryydm 			--18 ת��ҽԺ����
				from ZY_BRSYK a(nolock) inner join YY_CQYB_ZYJZJLK b(nolock) on a.syxh = b.syxh and b.jlzt = 1
										left join YY_ZGBMK c(nolock) on a.ysdm = c.id
				where a.syxh = @syxh and brzt not in (3,8,9)
			end
			else IF @configCQ01 = 'WD'
			begin
				select @gxbz = substring(@gxbz,1,15);
				IF EXISTS(SELECT 1 FROM ZY_BRSYK(nolock) WHERE syxh = @syxh AND cardno LIKE '#%')
				BEGIN
					SELECT @ydbz = '1';
				END
				IF @ydbz = '1'  --����������֤�Ų�����
				BEGIN
				    SELECT @gxbz = SUBSTRING(@gxbz,1,11) + '0' + SUBSTRING(@gxbz,13,3)
				END 
				select "T", b.jzlsh,			--1 �����/סԺ��
							@gxbz as gxbz,		--2 ���±�־
							b.zgyllb,			--3 ҽ�����
							a.ksdm,				--4 ���ұ���
							--case when isnull(ltrim(c.sfzh),'')='' then @m_mrsfzh else c.sfzh end,--5 ҽ������--update by winning-dingsong-chongqing on 20200820
					case when isnull(ltrim(dbo.fun_getyssfzh(a.syxh,'ZY')),'')='' THEN @m_mrsfzh ELSE dbo.fun_getyssfzh(a.syxh,'ZY') END sfzh,
							b.ryrq,				--6 ��Ժ����
							b.ryzd,				--7 ��Ժ���
							b.cyrq,				--8 ��Ժ����
							CASE ISNULL(b.cyzd,'') WHEN '' THEN 'J00 03' ELSE b.cyzd END cyzd,				--9 ��Ժ���
							CASE ISNULL(b.cyyy,'') WHEN  '' THEN '9' ELSE b.cyyy END as cyyy,				--10 ��Ժԭ��
							@czym as jbr,		--11 ������
							case b.xzlb when '3' then 
							case ISNULL(b.bfzinfo,'') when '' then '��' else b.bfzinfo end 
							else
							case ISNULL(b.bfzinfo,'') when '' then @tmp_bfzinfo else b.bfzinfo end   
							end,				--12 ����֢
							--CASE WHEN ISNULL(b.bfzinfo,'')='' and b.xzlb = '3' THEN '��' ELSE b.bfzinfo END ,			--12 ����֢
							CASE WHEN ISNULL(b.bah,'') = '' THEN a.blh ELSE b.bah END ,				--13 ������
							b.syzh,				--14 ����֤����
							b.xsecsrq,			--15 ��������������
							b.jmyllb,			--16 �������������
							b.xzlb				--17 �������
				from ZY_BRSYK a(nolock) inner join YY_CQYB_ZYJZJLK b(nolock) on a.syxh = b.syxh and b.jlzt = 1
										inner join YY_ZGBMK c(nolock) on a.ysdm = c.id
				where a.syxh = @syxh and brzt not in (3,8,9)			
			end
		end
	end
end            
else if @code = '04'	--��Ӵ�����ϸ       
begin        
	create table #temp_fymx        
    (        
		jzlsh		varchar(18)	not null,			--1 �����/סԺ��
		cfh			varchar(20)     null,			--2 ������
		cfrq		varchar(20)     null,			--3 ��������
		ybbm		varchar(10)     null,			--4 ��Ŀҽ����ˮ��
		xmdm		varchar(20)     null,			--5 ҽԺ�շ���Ŀ����
		xmmc		varchar(50)     null,			--6 ҽԺ�շ���Ŀ����
		xmdj		ut_money		null,			--7 ����
		xmsl		ut_sl10			null,			--8 ����
		jzbz		varchar(3)      null,			--9 �����־
		cfys		varchar(50)     null,			--10 ����ҽ��
		jbr			varchar(20)     null,			--11 ������
		xmdw		varchar(20)     null,			--12 ��λ
		xmgg		varchar(50)     null,			--13 ���
		xmjx		varchar(20)     null,			--14 ����
		zxlsh		varchar(20)     null,			--15 ������ϸ��ˮ��
		xmje		ut_money	    null,			--16 ���
		ksdm		varchar(10)		null,			--17 ���ұ���
		ksmc		varchar(40)     null,			--18 ��������
		ysbm		varchar(20)		null,			--19 ҽʦ����
		mcyl		varchar(20)		null,			--20 ÿ������
		yfbz		varchar(20)     null,			--21 �÷���׼
		zxzq		varchar(20)		null,			--22 ִ������
		xzlb		varchar(10)     null,			--23 �������
		zzfbz		varchar(10)		null,    		--24 ת�Էѱ�ʶ
		dcyyjl		VARCHAR(20)		null,    		--25������ҩ����
		dcyyjldw	VARCHAR(10)		null,    		--26������ҩ������λ
		dcyl		VARCHAR(20)		null,    		--27��������
		zxjldw		VARCHAR(20)		null,    		--28��С������λ
		qyzl		VARCHAR(20)		null,    		--29ȡҩ����
		yytj		VARCHAR(10)		null,    		--30��ҩ;��
		sypc		VARCHAR(10)		null,    		--31ʹ��Ƶ��
		shid		VARCHAR(50)		null,    		--32��� ID
		mxxh		ut_xh12		not null			--��ϸ���
     )         
           
    --����Һ�    
    if @xtbz = 0      
	BEGIN
		IF EXISTS(SELECT 1 FROM GH_GHZDK(nolock) WHERE jssjh = @jsxh AND ghlb = 9)
		BEGIN
			SELECT @ryrq_old = czrq FROM GH_GHZDK(nolock) WHERE jssjh = @jsxh AND ghlb = 9 	
		END
			        
		select @ysdm = isnull(ysdm,"") from GH_GHZDK(nolock) where jssjh = @jsxh and isnull(ysdm,"") <> ''
		
		if ltrim(rtrim(@ysdm)) = ''
		begin
			select 'f','�Һ�ҽ�����벻��Ϊ��'
			return
		end
		else
		    select @ysmc = name from YY_ZGBMK(nolock) where id = @ysdm
		   
		insert into #temp_fymx(jzlsh,cfh,cfrq,ybbm,xmdm,xmmc,xmdj,xmsl,jzbz,cfys,jbr,xmdw,xmgg,xmjx,zxlsh,xmje,
			ksdm,ksmc,ysbm,mcyl,yfbz,zxzq,xzlb,zzfbz,mxxh)
		select a.jzlsh,c.xh,CASE WHEN (@xtbz = 0) AND (isnull(@ryrq_old,'') <> '') 
			THEN dbo.fun_convertrq_cqyb(1,@ryrq_old) ELSE dbo.fun_convertrq_cqyb(1,b.ghrq) END,
			(case when isnull(d.dydm,'') = '' then '67790' else d.dydm end),
			c.xmdm,c.xmmc,c.xmdj-c.yhdj,c.xmsl,'0',@ysmc,
			@czym,d.xmdw,d.xmgg,'','',(c.xmdj-c.yhdj)*c.xmsl,b.ksdm,b.ksmc,@ysdm,'','','',a.xzlb,'',c.xh
		from YY_CQYB_MZJZJLK a(nolock) 
			inner join GH_GHZDK b(nolock) on a.jssjh = b.jssjh
			inner join GH_GHMXK c(nolock) on b.xh = c.ghxh and c.xmdj>0 AND c.xmsl > 0 --0���ò��ϴ�
			inner join YY_SFXXMK d(nolock) on c.xmdm = d.id
		where a.jssjh = @jsxh

		update #temp_fymx set cfys=case when @xtbz=0 then '��ͨ����ҽʦ' else cfys end  where isnull(cfys,'')=''--�Һ�û����ҽ���Ͼ�Ĭ��

		--��dydm���ص�δ�ϴ���ϸ��dydm���浽�м����,�ڴ����ϴ������ﲻ�ø㣬���Է�������������
		UPDATE a SET a.dydm = b.ybbm,
					 a.scxmdj = b.xmdj,
					 a.scxmsl = b.xmsl,
					 a.scxmje = b.xmje					      
		FROM GH_GHMXK a(NOLOCK),#temp_fymx b,GH_GHZDK c(NOLOCK) 
		WHERE a.ghxh = c.xh and a.xh = b.mxxh AND c.jssjh = @jsxh  
		IF @@ERROR <> 0 
		BEGIN
            SELECT 'F','����dydmʧ��'
			RETURN
		END
	end      
	--�����շ� 
	else if @xtbz = 1        
	begin     
	    select @patid = patid from SF_BRJSK(NOLOCK) WHERE sjh = @jsxh 
		select * into #vw_mzbrjsk_04 from VW_MZBRJSK(NOLOCK) WHERE patid = @patid

		select @cfrq_old = '',@jsxh_temp = @jsxh
		
		--��������ҽ�ģ������˷�ҽ��֮ǰ������ȡԭʼ��¼���շ�������Ϊ�������� 
		WHILE exists(select 1 from #vw_mzbrjsk_04(NOLOCK) where sjh = @jsxh_temp and isnull(tsjh,'') <> '')
		BEGIN
			SELECT @cfrq_old = sfrq ,@jsxh_temp = sjh from #vw_mzbrjsk_04(NOLOCK) 
			  WHERE sjh in (select tsjh from #vw_mzbrjsk_04(NOLOCK) where sjh in (select tsjh from #vw_mzbrjsk_04(NOLOCK) where sjh = @jsxh_temp))
			--���������۵����޸�
			--if @cfrq_old > '2017090900:00:00'
			--	select @cfrq_old = ''
		END

		--���ڸ�һ���ӵ����޸ĵ�sjhȡԭʼ�վݺŵĴ���������Ϊ�������� 
        if  exists(select 1 from syscolumns where id=object_id('SF_BRJSK') and name='sjh_ysjl')
		BEGIN
		    EXEC('insert into #tempdcxg select isnull(sjh_ysjl,"") sjh_ysjl from #vw_mzbrjsk_04 where sjh = "'+@jsxh+'"')
			select @sjh_ysjl = isnull(sjh_ysjl,'') from #tempdcxg
			IF @sjh_ysjl <> ''
			BEGIN
                SELECT @cfrq_old = sfrq from #vw_mzbrjsk_04(NOLOCK) WHERE sjh = @sjh_ysjl
				--if @cfrq_old > '2017090900:00:00'
				--    SELECT @cfrq_old = ''
			END
		END
		--�ɰ汾�洢���̺ϲ�
		if(@cfrq_old<'2020010100:00:00')
		select @cfrq_old = ''

		insert into #temp_fymx(jzlsh,cfh,cfrq,ybbm,xmdm,xmmc,xmdj,xmsl,jzbz,cfys,jbr,xmdw,xmgg,xmjx,zxlsh,xmje,
			ksdm,ksmc,ysbm,mcyl,yfbz,zxzq,xzlb,zzfbz,dcyyjl,dcyyjldw,dcyl,zxjldw,qyzl,yytj,sypc,shid,mxxh)
		select a.jzlsh,(case when g.ypbz=3 then c.cfxh else c.xh end),
			dbo.fun_convertrq_cqyb(1,case when isnull(@cfrq_old,'') <> '' then @cfrq_old else b.lrrq end),
			(case when isnull(d.dydm,'') = '' then '197827' else d.dydm end),c.cd_idm,
			SUBSTRING(CONVERT(VARCHAR(50),c.ypmc),1,50) xmmc,
				round((c.ylsj-c.yhdj)*(case when isnull(ltrim(h.shid),'') not in('0','','9999999999') then c.dwxs else 1 end)/c.ykxs,4),
				c.ypsl*c.cfts/(case when isnull(ltrim(h.shid),'') not in('0','','9999999999') then c.dwxs else 1 end),
			'0',f.name,@czym,d.zxdw,c.ypgg,i.name,'',
			round((c.ylsj-c.yhdj)*c.ypsl*c.cfts/c.ykxs,2),b.ksdm,e.name,b.ysdm,'','','',a.xzlb,ISNULL(h.ybzzfbz,0),
			CONVERT(VARCHAR(20),ROUND(ISNULL(h.ypjl,0),2)) as dcyyjl , --������ҩ����
			(select TOP 1 k.ybcode FROM YY_CQYB_YBSJZD_DZ k(nolock) where k.zdlb = 'DCJLDW' 
				AND k.hiscode=(SELECT TOP 1 j.id FROM YY_UNIT j(NOLOCK) WHERE j.lb = 1 AND j.name = h.jldw ))  as dcyyjldw,  --������ҩ������λ
			SUBSTRING(CONVERT(VARCHAR(50),ISNULL(convert(decimal(18,2),h.ypjl/d.ggxs),0)),1,20) AS dcyl ,         --��������
			(select TOP 1 k.ybcode FROM YY_CQYB_YBSJZD_DZ k(nolock) where k.zdlb = 'ZXJLDW' 
				AND k.hiscode=(SELECT TOP 1 n.id FROM YY_UNIT n(NOLOCK) WHERE n.lb = 0 AND n.name = z.zxdw )) as zxjldw ,       --��С������λ
			CONVERT(VARCHAR(20),CONVERT(NUMERIC(16,4),round(c.cfts*c.ts*c.ypsl/c.dwxs,2))) as qyzl,  --ȡҩ����
			CASE ISNULL(h.ypyf,'') WHEN '' THEN '900' ELSE 
			(select TOP 1 k.ybcode FROM YY_CQYB_YBSJZD_DZ k(nolock) where k.zdlb = 'YYTJ' AND k.hiscode = h.ypyf) END as yytj,      --��ҩ;��
			CASE ISNULL(h.pcdm,'') WHEN '' THEN '61' ELSE
			(select TOP 1 k.ybcode FROM YY_CQYB_YBSJZD_DZ k(NOLOCK) WHERE k.zdlb = 'SYPC' AND k.hiscode = h.pcdm) END AS sypc,      --ʹ��Ƶ��
			ISNULL(h.shid,'9999999999') shid,
			c.xh
		from YY_CQYB_MZJZJLK a(nolock) 
			inner join SF_MZCFK b(nolock) on a.jssjh = b.jssjh
			inner join SF_CFMXK c(nolock) on b.xh = c.cfxh and c.cd_idm <> 0
			inner join YY_SFDXMK g(nolock) on c.dxmdm=g.id
			inner join YK_YPCDMLK d(nolock) on c.cd_idm = d.idm
			left join YY_KSBMK e(nolock) on a.ksdm = e.id
			left join YY_ZGBMK f(nolock) on a.ysdm = f.id
			LEFT JOIN SF_HJCFMXK h(NOLOCK) ON h.xh = c.hjmxxh
			LEFT JOIN YK_YPJXK i(NOLOCK) ON d.jxdm = i.id
			LEFT JOIN YK_YPGGMLK z(NOLOCK) ON c.gg_idm = z.idm
		where a.jssjh = @jsxh and a.jlzt = 1
		
		insert into #temp_fymx(jzlsh,cfh,cfrq,ybbm,xmdm,xmmc,xmdj,xmsl,jzbz,cfys,jbr,xmdw,xmgg,xmjx,zxlsh,xmje,
			ksdm,ksmc,ysbm,mcyl,yfbz,zxzq,xzlb,zzfbz,dcyyjl,dcyyjldw,dcyl,zxjldw,qyzl,yytj,sypc,shid,mxxh)
		select a.jzlsh,c.xh,dbo.fun_convertrq_cqyb(1,case when isnull(@cfrq_old,'') <> '' then @cfrq_old else b.lrrq end),
			(case when isnull(d.dydm,'') = '' then '67790' else d.dydm end),
            c.ypdm,SUBSTRING(CONVERT(VARCHAR(50),c.ypmc),1,50) xmmc,round((c.ylsj-c.yhdj)/c.ykxs,4),
			c.ypsl*c.cfts,'0',f.name,@czym,c.ypdw,c.ypgg,'','',round((c.ylsj-c.yhdj)*c.ypsl*c.cfts/c.ykxs,4),
			b.ksdm,e.name,b.ysdm,'','','',a.xzlb,ISNULL(h.ybzzfbz,0),
			'' as dcyyjl,'' as dcyyjldw,'' as dcyl,'' as zxjldw,'' as qyzl ,'' as yytj ,'' as sypc,
			CASE WHEN ISNULL(c.lcxmdm,'0')= '0' OR ISNULL(c.lcxmdm,'') = '' THEN ISNULL(h.shid,'9999999999') 
				 WHEN ISNULL(dbo.fun_cqyb_getlcxmshid(h.shid,c.ypdm),'') <> '' THEN dbo.fun_cqyb_getlcxmshid(h.shid,c.ypdm)
				 ELSE ISNULL(h.shid,'9999999999') 
			END AS shid,--ISNULL(h.shid,'9999999999') shid,
			c.xh
		from YY_CQYB_MZJZJLK a(nolock) 
			inner join SF_MZCFK b(nolock) on a.jssjh = b.jssjh
			inner join SF_CFMXK c(nolock) on b.xh = c.cfxh and c.cd_idm = 0 
			and (c.zje<>0 or round((c.ylsj-c.yhdj)/c.ykxs,4)*c.ypsl*c.cfts<>0)--0���ò��ϴ�
			inner join YY_SFXXMK d(nolock) on c.ypdm = d.id
			left join YY_KSBMK e(nolock) on a.ksdm = e.id
			left join YY_ZGBMK f(nolock) on a.ysdm = f.id
			LEFT JOIN SF_HJCFMXK h(NOLOCK) ON h.xh = c.hjmxxh
		where a.jssjh = @jsxh and a.jlzt = 1  
		
		--��dydm���ص�δ�ϴ���ϸ��dydm���浽�м����,�ڴ����ϴ������ﲻ�ø㣬���Է�������������
		UPDATE a SET a.dydm = b.ybbm,
					 a.scxmdj = b.xmdj,
					 a.scxmsl = b.xmsl,
					 a.scxmje = b.xmje					      
		FROM SF_CFMXK a(NOLOCK),#temp_fymx b,SF_MZCFK c(NOLOCK),SF_BRJSK d(NOLOCK) 
		WHERE a.cfxh = c.xh AND c.jssjh = d.sjh and a.xh = b.mxxh AND d.sjh = @jsxh  
		IF @@ERROR <> 0 
		BEGIN
            SELECT 'F','����dydmʧ��'
			RETURN
		END       
	end
	--סԺ����
	else --if @xtbz in (2,3,4)
	begin	
		--������ֹ����
		select @qzrq = replace(ryrq,'-','') + '00:00:00' from YY_CQYB_ZYJZJLK(nolock) where syxh = @syxh and jlzt = 1
		select @qzrq = ksrq from ZY_BRJSK(nolock) where xh = @jsxh
		--���ý�ֹ����
		/*
		if @jzrq = ''
			select @zzrq = convert(varchar(8),getdate(),112) + '23:59:59'
		else
		begin
	        IF len(rtrim(@jzrq))=8  --����δ��չǰ������
			   select @zzrq = @jzrq + '23:59:59'
			else
			   select @zzrq = @jzrq 
  	    END
        */
        select @zzrq = 
			CASE when ISNULL(jszzrq,'') = '' THEN  
				CASE WHEN b.brzt not IN ('2','4') THEN @now ELSE b.cqrq  end
			else  
				CASE LEN(RTRIM(a.jszzrq)) when 10 THEN REPLACE(a.jszzrq,'-','') + '23:59:59' ELSE REPLACE(REPLACE(a.jszzrq,'-',''),' ','') end 
			end
		FROM YY_CQYB_ZYJSJLK a(nolock),ZY_BRSYK b(NOLOCK) WHERE a.syxh = b.syxh and a.syxh = @syxh and a.jsxh = @jsxh and a.jlzt in (0,1,3)
        if isnull(@zzrq,'') = ''
			select @zzrq = @now

		if @cxbz = 0	--���û�����Ϣ
		begin
			---declare @errmsg varchar(50)  
			exec usp_cqyb_zyfymxcl @syxh,@jsxh,0,@errmsg out  
			if substring(@errmsg,1,1)='F'   
			begin  
				select 'F',@errmsg  
				return  
			end  
			
			if exists(select 1 from ZY_BRSYK(nolock) where syxh = @syxh and brzt in (2,4))
			begin
				select @cqrq = isnull(cqrq,'') from ZY_BRSYK(nolock) where syxh = @syxh and brzt in (2,4)
				
				if exists(select 1 from YY_CQYB_ZYFYMXK(nolock) where syxh = @syxh and jsxh = @jsxh and cfrq > @cqrq) 
					and @cqrq <> ''
				begin
					update YY_CQYB_ZYFYMXK set cfrq = @cqrq where syxh = @syxh and jsxh = @jsxh and cfrq > @cqrq
					if @@error <> 0 
					begin
						select 'F','����YY_CQYB_ZYFYMXK�е�cfrq����!';
						return
					end
				end
			end
			
			--����ҽ�����ϴ��ķ�����ϸbegin
			IF EXISTS(select 1 from syscolumns where id=object_id('ZY_BRFYMXK') and name='mxlsh')
			BEGIN
			    IF EXISTS (SELECT 1 FROM ZY_BRSYK(nolock) WHERE syxh = @syxh AND centerid LIKE 'zy%')
				BEGIN
					select * into #temp_fymxk from ZY_BRFYMXK(nolock) where syxh = @syxh and jsxh = @jsxh
					update a set ybscbz = 0
					from YY_CQYB_ZYFYMXK a(nolock) inner join #temp_fymxk b(nolock) on a.xh = b.xh and b.scbz in (-1,0,3,4)
					where a.syxh = @syxh and a.jsxh = @jsxh and a.ybscbz not in (0,1)
			
					update a set ybscbz = 1,zxlsh = b.mxlsh
					from YY_CQYB_ZYFYMXK a(nolock) inner join #temp_fymxk b(nolock) on a.xh = b.xh and b.scbz = 1
					where a.syxh = @syxh and a.jsxh = @jsxh and a.ybscbz <> 1
				END
			END
			--����ҽ�����ϴ��ķ�����ϸend
			
			IF @configCQ49 = '��'
			begin
				select @mxts = count(1) from YY_CQYB_ZYFYMXK (nolock) 
				where syxh = @syxh and jsxh = @jsxh and isnull(ybscbz,0) = 0 and cfrq between @qzrq and @zzrq
			
				select @zmxts= count(1) from YY_CQYB_ZYFYMXK (nolock) 
				where syxh = @syxh and jsxh = @jsxh and isnull(ybscbz,0) = 0 and xmje > 0 and cfrq between @qzrq and @zzrq
			
				select @fmxts= count(1) from YY_CQYB_ZYFYMXK (nolock) 
				where syxh = @syxh and jsxh = @jsxh and isnull(ybscbz,0) = 0 and xmje < 0 and cfrq between @qzrq and @zzrq
		    END
            ELSE
            BEGIN
                select @mxts = 0
			
				select @zmxts= count(1) from YY_CQYB_ZYFYMXK (nolock) 
				where syxh = @syxh and jsxh = @jsxh and isnull(ybscbz,0) in (0,5) and xmje > 0 and cfrq between @qzrq and @zzrq
			
				select @fmxts= 0

				SELECT @mxts = @zmxts + @fmxts
			end
			select "T",@mxts as mxts,@zmxts as zmxts,@fmxts as fmxts
			return
		end
		else if @cxbz = 1	--������ϸ��Ϣ
		begin
			insert into #temp_fymx(jzlsh,cfh,cfrq,ybbm,xmdm,xmmc,xmdj,xmsl,jzbz,cfys,jbr,xmdw,xmgg,xmjx,zxlsh,xmje,
				ksdm,ksmc,ysbm,mcyl,yfbz,zxzq,xzlb,zzfbz,mxxh)
				select a.jzlsh,b.cfh,dbo.fun_convertrq_cqyb(1,b.cfrq),
					dbo.fun_cqyb_getzydydm(b.xh,b.idm,@configCQ36,@configCQ39,@configCQ40) ,
					b.idm,SUBSTRING(CONVERT(VARCHAR(50),b.xmmc),1,50) xmmc,b.xmdj,(CASE b.ybscbz WHEN 5 THEN b.ktsl ELSE b.xmsl END) xmsl,b.jzbz,f.name,@czym,c.zxdw,b.xmgg,d.name,'',
					(CASE b.ybscbz WHEN 5 THEN b.ktje ELSE b.xmje END) xmje,b.ksdm,e.name,b.ysdm,
					'','','',a.xzlb,
					CASE WHEN @configCQ36 <> '3' THEN '0' ELSE dbo.fun_cqyb_getzyybzzfbz(b.xh) END,
					b.xh
				from YY_CQYB_ZYJZJLK a(nolock) 
					inner join YY_CQYB_ZYFYMXK b(nolock) on a.syxh = b.syxh and b.jsxh = @jsxh and idm <> 0 and xmje > 0
														and isnull(b.ybscbz,0) in (0,5) and b.cfrq between @qzrq and @zzrq
					inner join YK_YPCDMLK c(nolock) on b.idm = c.idm
					left join YK_YPJXK d(nolock) on c.jxdm = d.id
					left join YY_KSBMK e(nolock) on b.ksdm = e.id
					left join YY_ZGBMK f(nolock) on b.ysdm = f.id
					INNER JOIN ZY_BRFYMXK h(nolock) ON b.xh = h.xh
					LEFT JOIN YY_CQYB_ZDYSPFYMX i(NOLOCK) ON b.xh=i.xh
				where a.syxh = @syxh and a.jlzt = 1
			
			insert into #temp_fymx(jzlsh,cfh,cfrq,ybbm,xmdm,xmmc,xmdj,xmsl,jzbz,cfys,jbr,xmdw,xmgg,xmjx,zxlsh,xmje,
				ksdm,ksmc,ysbm,mcyl,yfbz,zxzq,xzlb,zzfbz,mxxh)
				select a.jzlsh,b.cfh,dbo.fun_convertrq_cqyb(1,b.cfrq),
					dbo.fun_cqyb_getzydydm(b.xh,b.idm,@configCQ36,@configCQ39,@configCQ40) ,
					b.xmdm,SUBSTRING(CONVERT(VARCHAR(50),b.xmmc),1,50) xmmc,b.xmdj,(CASE b.ybscbz WHEN 5 THEN b.ktsl ELSE b.xmsl END) xmsl,b.jzbz,e.name,@czym,c.xmdw,'','','',
					(CASE b.ybscbz WHEN 5 THEN b.ktje ELSE b.xmje END) xmje,b.ksdm,d.name,b.ysdm,
					'','','',a.xzlb,
					CASE WHEN @configCQ36 <> '3' THEN '0' ELSE dbo.fun_cqyb_getzyybzzfbz(b.xh) END,
					b.xh
				from YY_CQYB_ZYJZJLK a(nolock) 
					inner join YY_CQYB_ZYFYMXK b(nolock) on a.syxh = b.syxh and b.jsxh = @jsxh and idm = 0 and xmje > 0
														and isnull(b.ybscbz,0) IN (0,5) AND b.cfrq between @qzrq and @zzrq
					inner join YY_SFXXMK c(nolock) on b.xmdm = c.id
					left join YY_KSBMK d(nolock) on b.ksdm = d.id
					left join YY_ZGBMK e(nolock) on b.ysdm = e.id
					inner join ZY_BRFYMXK h(nolock) on b.xh=h.xh
					LEFT JOIN YY_CQYB_ZDYSPFYMX i(NOLOCK) ON b.xh=i.xh
				where a.syxh = @syxh and a.jlzt = 1
		end
		else if @cxbz = 2
		begin
			insert into #temp_fymx(jzlsh,cfh,cfrq,ybbm,xmdm,xmmc,xmdj,xmsl,jzbz,cfys,jbr,xmdw,xmgg,xmjx,zxlsh,xmje,
				ksdm,ksmc,ysbm,mcyl,yfbz,zxzq,xzlb,zzfbz,mxxh)
				select a.jzlsh,b.cfh,dbo.fun_convertrq_cqyb(1,b.cfrq),
				    dbo.fun_cqyb_getzydydm(b.xh,b.idm,@configCQ36,@configCQ39,@configCQ40),
					b.idm,SUBSTRING(CONVERT(VARCHAR(50),b.xmmc),1,50) xmmc,b.xmdj,b.xmsl,b.jzbz,f.name,@czym,c.zxdw,b.xmgg,d.name,b.zxlsh,b.xmje,b.ksdm,e.name,b.ysdm,
					'','','',a.xzlb,
					CASE WHEN @configCQ36 <> '3' THEN '0' ELSE dbo.fun_cqyb_getzyybzzfbz(b.xh) END,
					b.xh
				from YY_CQYB_ZYJZJLK a(nolock) 
					inner join YY_CQYB_ZYFYMXK b(nolock) on a.syxh = b.syxh and b.jsxh = @jsxh and idm <> 0 and xmje < 0
														and isnull(b.ybscbz,0) = 0 and b.cfrq between @qzrq and @zzrq
					inner join YK_YPCDMLK c(nolock) on b.idm = c.idm
					left join YK_YPJXK d(nolock) on c.jxdm = d.id
					left join YY_KSBMK e(nolock) on b.ksdm = e.id
					left join YY_ZGBMK f(nolock) on b.ysdm = f.id
					inner join ZY_BRFYMXK h(nolock) on b.xh=h.xh
					LEFT JOIN YY_CQYB_ZDYSPFYMX i(NOLOCK) ON b.xh=i.xh
				where a.syxh = @syxh and a.jlzt = 1
			 
			insert into #temp_fymx(jzlsh,cfh,cfrq,ybbm,xmdm,xmmc,xmdj,xmsl,jzbz,cfys,jbr,xmdw,xmgg,xmjx,zxlsh,xmje,
				ksdm,ksmc,ysbm,mcyl,yfbz,zxzq,xzlb,zzfbz,mxxh)
				select a.jzlsh,b.cfh,dbo.fun_convertrq_cqyb(1,b.cfrq),
					dbo.fun_cqyb_getzydydm(b.xh,b.idm,@configCQ36,@configCQ39,@configCQ40) ,
					b.xmdm,SUBSTRING(CONVERT(VARCHAR(50),b.xmmc),1,50) xmmc,b.xmdj,b.xmsl,b.jzbz,e.name,@czym,c.xmdw,'','',b.zxlsh,b.xmje,b.ksdm,d.name,b.ysdm,
					'','','',a.xzlb,
					CASE WHEN @configCQ36 <> '3' THEN '0' ELSE dbo.fun_cqyb_getzyybzzfbz(b.xh) END,
					b.xh
				from YY_CQYB_ZYJZJLK a(nolock) 
					inner join YY_CQYB_ZYFYMXK b(nolock) on a.syxh = b.syxh and b.jsxh = @jsxh and idm = 0 and xmje < 0
														and isnull(b.ybscbz,0) = 0 and b.cfrq between @qzrq and @zzrq
					inner join YY_SFXXMK c(nolock) on b.xmdm = c.id
					left join YY_KSBMK d(nolock) on b.ksdm = d.id
					left join YY_ZGBMK e(nolock) on b.ysdm = e.id
					inner join ZY_BRFYMXK h(nolock) on b.xh=h.xh
					LEFT JOIN YY_CQYB_ZDYSPFYMX i(NOLOCK) ON b.xh=i.xh
				where a.syxh = @syxh and a.jlzt = 1
			
			update #temp_fymx set zxlsh = c.zxlsh
			from #temp_fymx a inner join YY_CQYB_ZYFYMXK b(nolock) on b.syxh = @syxh and b.jsxh = @jsxh and a.mxxh = b.xh
							  inner join YY_CQYB_ZYFYMXK c(nolock) on b.syxh = c.syxh and b.jsxh = c.jsxh and b.txh = c.xh
		end

		select @gcys = isnull(a.ysdm,'null'),@gcys_mc = isnull(b.name,'null') from ZY_BRSYK a(nolock),YY_ZGBMK b(NOLOCK) WHERE a.ysdm = b.id AND a.syxh = @syxh
		
        update #temp_fymx set ysbm = @gcys from #temp_fymx a WHERE ISNULL(a.ysbm,'') = ''
		update #temp_fymx set cfys = @gcys_mc from #temp_fymx a WHERE ISNULL(a.cfys,'') = ''
		update #temp_fymx set ysbm = @gcys
		from #temp_fymx a INNER join YY_ZGBMK b(nolock) on a.ysbm = b.id AND (isnull(b.sfzh,'') = '' or b.cfbz <> '1')

		DECLARE @i_fjl INTEGER,@count_fjl INTEGER ,@xh_fjl INTEGER,@txh INTEGER,@idm ut_xh9,@dydm VARCHAR(20),@cfrq_z VARCHAR(19),@cfrq_f VARCHAR(19) ,@cfh_z ut_xh12  
  
		SELECT IDENTITY(int ,1,1) i,mxxh,cfrq INTO #temp_fymx_fjl FROM #temp_fymx a WHERE a.xmje < 0
		SELECT @i_fjl=1 ,@count_fjl = 0 
		SELECT @count_fjl = COUNT(1) FROM #temp_fymx_fjl
    
		WHILE @i_fjl <= @count_fjl
		BEGIN
			SELECT @xh_fjl = mxxh,@cfrq_f = cfrq FROM #temp_fymx_fjl WHERE i = @i_fjl
			--�ҵ�����¼��Ӧ������¼xh
			SELECT @txh = a.txh,@idm = a.idm FROM YY_CQYB_ZYFYMXK a(NOLOCK) WHERE a.xh = @xh_fjl  
			--�ҵ�����¼��Ӧ������¼xh��ҽ��ת�Էѱ�ʶ
			UPDATE #temp_fymx SET zzfbz = (SELECT zzfbz FROM #temp_fymx WHERE mxxh = @txh) WHERE mxxh = @xh_fjl

			IF @idm = 0 
			begin
				SELECT @dydm = dbo.fun_cqyb_getzydydm(b.xh,b.idm,@configCQ36,@configCQ39,@configCQ40)
					,@cfrq_z = dbo.fun_convertrq_cqyb(1,b.cfrq) ,@zjldj = b.xmdj
					,@cfh_z = @txh
				FROM YY_CQYB_ZYFYMXK b(NOLOCK) INNER JOIN YY_SFXXMK c(NOLOCK) ON b.xmdm = c.id
											   LEFT JOIN  YY_CQYB_ZDYSPFYMX i(NOLOCK) ON b.xh = i.xh
											   INNER JOIN ZY_BRFYMXK h(NOLOCK) ON b.xh = h.xh AND h.syxh = b.syxh
				WHERE b.xh = @txh AND b.syxh = @syxh
			end
			ELSE
			begin
				SELECT @dydm = dbo.fun_cqyb_getzydydm(b.xh,b.idm,@configCQ36,@configCQ39,@configCQ40)
					,@cfrq_z = dbo.fun_convertrq_cqyb(1,b.cfrq),@zjldj = b.xmdj
					,@cfh_z = CASE d.ypbz WHEN 3 THEN b.cfh ELSE @txh END
				FROM YY_CQYB_ZYFYMXK b(NOLOCK) INNER JOIN YK_YPCDMLK c(NOLOCK) ON b.idm = c.idm
											   LEFT JOIN  YY_CQYB_ZDYSPFYMX i(NOLOCK) ON b.xh = i.xh
											   INNER JOIN ZY_BRFYMXK h(NOLOCK) ON b.xh = h.xh AND h.syxh = b.syxh
											   INNER JOIN YY_SFDXMK d(NOLOCK) ON d.id = h.dxmdm
				WHERE b.xh = @txh AND b.syxh = @syxh
			END
        
			UPDATE #temp_fymx SET ybbm = @dydm,xmdj = @zjldj WHERE mxxh = @xh_fjl

			IF @cfrq_f < @cfrq_z 
				UPDATE #temp_fymx SET cfrq=@cfrq_z WHERE mxxh= @xh_fjl

			IF @configCQ01 = 'WD'  --��︺��¼������Ҫ����ԭ����¼�Ĵ����� ʯ�����Է���
			BEGIN
				UPDATE #temp_fymx SET cfrq=@cfrq_z WHERE mxxh= @xh_fjl
				UPDATE #temp_fymx SET cfh =@cfh_z WHERE mxxh = @xh_fjl 
			END
        
			SELECT @i_fjl = @i_fjl + 1
		END

		--��dydm���ص�δ�ϴ���ϸ��dydm���浽�м����,�ڴ����ϴ������ﲻ�ø㣬���Է�������������
		UPDATE a SET a.dydm = b.ybbm,
					 a.scxmdj = b.xmdj,
					 a.scxmsl = b.xmsl,
					 a.scxmje = b.xmje,	
					 a.zzfbz = b.zzfbz				      
		FROM YY_CQYB_ZYFYMXK a(NOLOCK),#temp_fymx b 
		WHERE a.syxh = @syxh and a.xh = b.mxxh AND ISNULL(a.ybscbz,0) = 0
		IF @@ERROR <> 0 
		BEGIN
            SELECT 'F','����dydmʧ��'
			RETURN
		END
	end           
	 
	if exists(select 1 from #temp_fymx where isnull(ybbm,'') = '')  
	begin
		select 'F','ҩƷ����Ŀ��'+xmmc+'��δ���գ��������ҽ����Ŀ���պ��ٽ���!' from #temp_fymx where isnull(ybbm,'') = ''
		return
	end
       
	update #temp_fymx set dcyyjl = '' where isnull(ltrim(dcyyjldw),'')='' --������ҩ������λΪ�յ�ʱ�򲻴����μ���    
	update #temp_fymx set dcyl = '' where isnull(ltrim(zxjldw),'')='' --��С������λΪ�յ�ʱ�򲻴����μ���

	if @xtbz in (0,1) 
	BEGIN
		IF EXISTS(  SELECT 1 FROM YY_CQYB_MZJZJLK a(NOLOCK) WHERE a.jssjh = @jsxh AND a.jlzt = 1 
					AND CASE ISNULL(a.zgyllb,'') WHEN '' THEN ISNULL(a.jmyllb,'') ELSE ISNULL(a.zgyllb,'') END NOT IN ('13','15') )
		BEGIN
			UPDATE #temp_fymx SET shid = NULL
		END
	END

	IF @configCQ01 = 'WD'--������Ʋ���̫��(ע����Ӣ�ĵ����)
	BEGIN		
		update #temp_fymx SET xmmc = SUBSTRING(CONVERT(TEXT,xmmc),1,50) WHERE DATALENGTH(xmmc) > 50
	END

	if rtrim(@configCQ58)<>'��' --δ����ҩ�����м�أ�һ��Ҫ����Ϊ��
	begin 
		update #temp_fymx set dcyyjl='',dcyyjldw='', dcyl='',zxjldw='',qyzl='' , yytj='' ,sypc='',shid=''
	end

	if @xtbz in (1) --1.27�汾����ıش�
	begin
            if @syxh in (56889)
		begin
		select a.jzlsh,a.cfh,a.cfrq, a.ybbm,a.xmdm,a.xmmc,a.xmdj,a.xmsl,a.jzbz,a.cfys,a.jbr,a.xmdw,
			(CONVERT(VARCHAR(20),CASE WHEN ISNULL(a.xmgg,'')= '' THEN a.xmdw ELSE a.xmgg end)) xmgg,  --���ӿڲ�����Ϊ��
			(CASE WHEN ISNULL(a.xmjx,'')= '' THEN '��' ELSE a.xmjx END) xmjx,
			a.zxlsh,a.xmje, a.ksdm,a.ksmc,(case when isnull(ltrim(b.sfzh),'')='' then @m_mrsfzh else b.sfzh end) as ysbm,a.mcyl,a.yfbz,a.zxzq,a.xzlb,a.zzfbz,
			a.dcyyjl,a.dcyyjldw, a.dcyl,a.zxjldw,a.qyzl , a.yytj ,a.sypc,a.shid,a.mxxh
		from #temp_fymx a left join YY_ZGBMK b(nolock) on a.ysbm = b.id
	end
	else
	begin
		select a.jzlsh,a.cfh,a.cfrq, a.ybbm,a.xmdm,a.xmmc,a.xmdj,a.xmsl,a.jzbz,a.cfys,a.jbr,a.xmdw,
			(CONVERT(VARCHAR(20),CASE WHEN ISNULL(a.xmgg,'')= '' THEN a.xmdw ELSE a.xmgg end)) xmgg,  --���ӿڲ�����Ϊ��
			(CASE WHEN ISNULL(a.xmjx,'')= '' THEN '��' ELSE a.xmjx END) xmjx,
			a.zxlsh,a.xmje, a.ksdm,a.ksmc,(case when isnull(ltrim(b.sfzh),'')='' then @m_mrsfzh else b.sfzh end) as ysbm,a.mcyl,a.yfbz,a.zxzq,a.xzlb,a.zzfbz,
	a.dcyyjl,a.dcyyjldw, a.dcyl,a.zxjldw,a.qyzl , a.yytj ,a.sypc,a.shid,a.mxxh
			from #temp_fymx a left join YY_ZGBMK b(nolock) on a.ysbm = b.id
		end
	end
	else
	begin
		if @syxh in (56889)
		begin
			select a.jzlsh,a.cfh,a.cfrq, a.ybbm,a.xmdm,a.xmmc,a.xmdj,a.xmsl,a.jzbz,a.cfys,a.jbr,a.xmdw,
			(CONVERT(VARCHAR(20),CASE WHEN ISNULL(a.xmgg,'')= '' THEN a.xmdw ELSE a.xmgg end)) xmgg,  --���ӿڲ�����Ϊ��
			(CASE WHEN ISNULL(a.xmjx,'')= '' THEN '��' ELSE a.xmjx END) xmjx,
			a.zxlsh,a.xmje, a.ksdm,a.ksmc,(case when isnull(ltrim(b.sfzh),'')='' then @m_mrsfzh else b.sfzh end) as ysbm,a.mcyl,a.yfbz,a.zxzq,a.xzlb,a.zzfbz,
			a.mxxh
		from #temp_fymx a left join YY_ZGBMK b(nolock) on a.ysbm = b.id
                end
		else
		begin
			select a.jzlsh,a.cfh,a.cfrq, a.ybbm,a.xmdm,a.xmmc,a.xmdj,a.xmsl,a.jzbz,a.cfys,a.jbr,a.xmdw,
			(CONVERT(VARCHAR(20),CASE WHEN ISNULL(a.xmgg,'')= '' THEN a.xmdw ELSE a.xmgg end)) xmgg,  --���ӿڲ�����Ϊ��
			(CASE WHEN ISNULL(a.xmjx,'')= '' THEN '��' ELSE a.xmjx END) xmjx,
			a.zxlsh,a.xmje, a.ksdm,a.ksmc,(case when isnull(ltrim(b.sfzh),'')='' then @m_mrsfzh else b.sfzh end) as ysbm,a.mcyl,a.yfbz,a.zxzq,a.xzlb,a.zzfbz,
			a.mxxh
			from #temp_fymx a left join YY_ZGBMK b(nolock) on a.ysbm = b.id
		end
	end
end
else if @code = '06'	--Ԥ����
BEGIN
	if @xtbz = 0
	begin
		--�����ܶ�
		select @fyze = a.zje - a.yhje,@patid=patid from SF_BRJSK a(nolock) where sjh = @jsxh
         
		--��ϸ����
		select @mxts = count(1) from GH_GHMXK(nolock) where ghxh in (select xh from GH_GHZDK(nolock) where jssjh = @jsxh) and xmdj>0
		
		--����Ժ��ְ���Ż�
        exec usp_cqyb_ynzg_gh '01',@jsxh,0,@errmsg OUTPUT
		if @errmsg like "F%"
		begin
			select "F",@errmsg
			return 
		end
            
		select "T", a.jzlsh,					--1 �����/סԺ��
					'' as jzrq,					--2 ��ֹ����
					'0' as zycr,					--3	סԺ����		        
					@fyze as fyze,				--4 ���ν����ܽ��
					zhzfbz,						--5 �˻�֧����־
					@mxts as mxts,				--6 ���ν�����ϸ����
					a.xzlb,						--7 �������
					gsrdbh,						--8 �����϶����
					gsjbbm,						--9 �����϶���������
					cfjslx,						--10 ���ν�������
					b.ksdm,                     --11 ��Ժ���ұ���  
					--case when isnull(ltrim(c.sfzh),'')='' THEN @m_mrsfzh ELSE c.sfzh END sfzh --15 ��Ժҽ������--update by winning-dingsong-chongqing on 20200820
					case when isnull(ltrim(dbo.fun_getyssfzh(a.jssjh,'MZ')),'')='' THEN @m_mrsfzh ELSE dbo.fun_getyssfzh(a.jssjh,'MZ') END sfzh
		from YY_CQYB_MZJSJLK a(nolock) inner join YY_CQYB_MZJZJLK b(nolock) on a.jssjh = b.jssjh AND a.jzlsh = b.jzlsh
									   left join YY_ZGBMK c(nolock) on b.ysdm = c.id  --�Һſ��ܲ���ҽ��
		where a.jssjh = @jsxh and a.jlzt = 0
	end
	else if @xtbz = 1
	begin
		--�����ܶ�   
		select @fyze = zje - yhje,@patid=patid from SF_BRJSK(nolock) where sjh = @jsxh

		--IF @patid=1328772 SELECT @fyze=214.20	
		--��ϸ����
		select @mxts = count(1) from SF_CFMXK(nolock) where cfxh in (select xh from SF_MZCFK(nolock) where jssjh = @jsxh)  
		and (zje<>0 or round((ylsj-yhdj)/ykxs,4)*ypsl*cfts<>0)
		
		select "T", a.jzlsh,					--1 �����/סԺ��
					'' as jzrq,					--2 ��ֹ����
					'0' as zycr,					--3	סԺ����		        
					@fyze as fyze,				--4 ���ν����ܽ��
					zhzfbz,						--5 �˻�֧����־
					@mxts as mxts,				--6 ���ν�����ϸ����
					a.xzlb,						--7 �������
					gsrdbh,						--8 �����϶����
					gsjbbm,						--9 �����϶���������
					cfjslx,						--10 ���ν�������
					b.ksdm,                     --11 ��Ժ���ұ���  
					--case when isnull(ltrim(c.sfzh),'')='' THEN @m_mrsfzh ELSE c.sfzh END sfzh --15 ��Ժҽ������--update by winning-dingsong-chongqing on 20200820
					case when isnull(ltrim(dbo.fun_getyssfzh(a.jssjh,'MZ')),'')='' THEN @m_mrsfzh ELSE dbo.fun_getyssfzh(a.jssjh,'MZ') END sfzh
		from YY_CQYB_MZJSJLK a(nolock) inner join YY_CQYB_MZJZJLK b(nolock) on a.jssjh = b.jssjh and a.jzlsh = b.jzlsh
									   left join YY_ZGBMK c(nolock) on b.ysdm = c.id
		where a.jssjh = @jsxh and a.jlzt = 0
	end
	else if @xtbz in (2,3)
	begin	
	    IF EXISTS (SELECT 1 FROM ZY_BRJSK a(NOLOCK) WHERE a.xh = @jsxh AND a.syxh = @syxh AND a.ybjszt = 2 )
		BEGIN
			select "F","�ò��˽�������ѽ��㣬������Ԥ�����㣡" + CONVERT(VARCHAR(12),@jsxh)
			return
		END
	    --ֻ���ƽ�������Ԥ��
		DECLARE @strYbdm VARCHAR(10)
		SELECT @strYbdm = ltrim(rtrim(ybdm)) FROM ZY_BRJSK a(NOLOCK) WHERE a.xh = @jsxh
	    if @xtbz = 2 AND EXISTS(SELECT 1 FROM YY_CONFIG(NOLOCK) WHERE id = 'CQ47' AND config = '��')
			AND NOT EXISTS (SELECT 1 FROM YY_CONFIG a(NOLOCK) WHERE a.id = 'CQ53' AND CHARINDEX('"'+@strYbdm+'"',a.config)> 0)
		begin
		    if exists(select 1 from  ZY_BRFYMXK a(nolock) WHERE  syxh = @syxh and jsxh = @jsxh AND idm = 0
			              AND ypdm in (SELECT xmdm FROM YY_CQYB_YBDXMJSWH(nolock) WHERE xmlb = '1' AND jlzt = 0 )  )
			begin
			    select 'F','���˴����赥���������Ʒ��ã����Ƚ��е�����㣡'
				return
			end 

			if exists(select 1 from  ZY_BRFYMXK a(nolock) WHERE  syxh = @syxh and jsxh = @jsxh AND idm <> 0
			AND idm in (SELECT xmdm FROM YY_CQYB_YBDXMJSWH(nolock) WHERE xmlb = '0' AND jlzt = 0 ) )
			begin
			    select 'F','���˴����赥������ҩƷ���ã����Ƚ��е�����㣡'
				return
			end
		end

	    --�������
	    DECLARE @zje ut_money 
		set @zje = 0.00
		if exists(select * from sysobjects where name='usp_zy_brfymxjec')
		begin
			SELECT @zje = zje FROM ZY_BRJSK(nolock) WHERE syxh = @syxh AND xh = @jsxh
			if @zje <> (SELECT sum(zje) from ZY_BRFYMXK(nolock) WHERE syxh=@syxh and jsxh=@jsxh) 
			begin  
				EXEC usp_zy_brfymxjec @syxh,@jsxh,@zje output 
			END
		end
	    
		--������ֹ����
		select @qzrq = case len(rtrim(jsqzrq)) when 10 then replace(jsqzrq,'-','') + '00:00:00' else replace(replace(jsqzrq,'-',''),' ','') end
		from YY_CQYB_ZYJSJLK(nolock) where syxh = @syxh and jsxh = @jsxh and jlzt in (0,1,3)
		--���ý�ֹ����
		/*
		select @zzrq = case len(rtrim(a.jszzrq)) when 10 then replace(a.jszzrq,'-','') + '23:59:59' else replace(replace(a.jszzrq,'-',''),' ','') end
		from YY_CQYB_ZYJSJLK a(nolock) where a.syxh = @syxh and a.jsxh = @jsxh and a.jlzt in (0,1,3) 
		*/
		select @zzrq = 
			CASE when ISNULL(jszzrq,'') = '' THEN  
				CASE WHEN b.brzt not IN ('2','4') THEN @now ELSE b.cqrq  end
			else  
				CASE LEN(RTRIM(a.jszzrq)) when 10 THEN REPLACE(a.jszzrq,'-','') + '23:59:59' ELSE REPLACE(REPLACE(a.jszzrq,'-',''),' ','') end 
			end
		FROM YY_CQYB_ZYJSJLK a(nolock),ZY_BRSYK b(NOLOCK) WHERE a.syxh = b.syxh and a.syxh = @syxh and a.jsxh = @jsxh and a.jlzt in (0,1,3)
		if isnull(@zzrq,'') = ''
			select @zzrq = @now
		--סԺ����
		select @zyts = datediff(day,jsqzrq,dbo.fun_convertrq_cqyb(2,@zzrq)) + 1
		from YY_CQYB_ZYJSJLK(nolock) where syxh = @syxh and jsxh = @jsxh and jlzt in (0,1,3)  
		 
		if exists(select 1 from ZY_BRSYK(nolock) where syxh = @syxh and brzt in (2,4))
		begin
			--�����ܶ�   
			--select @fyze = zje - yhje from ZY_BRJSK(nolock) where xh = @jsxh and jlzt = 0 and jszt = 0 and ybjszt <> 2
			--���м���ȡ�ܽ���ZY_BRJSJEK����ҽ����HIS�Ĳ��  
			select @fyze = sum(isnull( case when @configCQ49='��' then ktje else  xmje end,0)) 
			from YY_CQYB_ZYFYMXK(nolock) where syxh = @syxh and jsxh = @jsxh 
			and  (isnull(ybscbz,0) = 1 or (@configCQ49='��' and isnull(ybscbz,0) = 4))		
			--��ϸ����
			select @mxts = count(1) from YY_CQYB_ZYFYMXK(nolock) where syxh = @syxh and jsxh = @jsxh 
			and  (isnull(ybscbz,0) = 1 or (@configCQ49='��' and isnull(ybscbz,0) = 4))
		end
		else
		BEGIN
			--�����ܶ�   
			--select @fyze = sum(zje-yhje) from ZY_BRFYMXK(nolock) 
			--where syxh = @syxh and jsxh = @jsxh and ISNULL(ybzxrq,zxrq) between @qzrq and @zzrq
			--���м���ȡ�ܽ���ZY_BRJSJEK����ҽ����HIS�Ĳ��  
			select @fyze = sum(isnull( case when @configCQ49='��' then ktje else  xmje end,0)) 
			from YY_CQYB_ZYFYMXK(nolock) where syxh = @syxh and jsxh = @jsxh 
				and cfrq between @qzrq and @zzrq 
				and  (isnull(ybscbz,0) = 1 or (@configCQ49='��' and isnull(ybscbz,0) = 4))	
			--��ϸ����
			select @mxts = count(1) from YY_CQYB_ZYFYMXK(nolock) 
			where syxh = @syxh and jsxh = @jsxh  and cfrq between @qzrq and @zzrq
			and  (isnull(ybscbz,0) = 1 or (@configCQ49='��' and isnull(ybscbz,0) = 4))
		end
		--��ȥ���ϴ��Ĳ��ֽ��  ���������ϴ����ֿ���û���Ƚ��㣬�ͻ���ҽ����Ԥ��
	    SELECT @fyze = @fyze - ISNULL(sum(zje-yhje),0) from ZY_BRFYMXK(nolock) where syxh = @syxh and jsxh = @jsxh AND ISNULL(ybscbz,0) = 3
		--���²���ҽ������
		if exists(select 1 from YY_CQYB_ZYJZJLK(nolock) where syxh = @syxh and isnull(ysdm,'') = '')
		begin
			update a set ysdm = b.ysdm
			from YY_CQYB_ZYJZJLK a inner join ZY_BRSYK b(nolock) on a.syxh = b.syxh 
			where a.syxh=@syxh
		end

		select "T", a.jzlsh,					--1 �����/סԺ��
					substring(jszzrq,1,10) as jzrq,	
												--2 ��ֹ����
					@zyts as zycr,				--3	סԺ����		        
					@fyze as fyze,				--4 ���ν����ܽ��
					zhzfbz,						--5 �˻�֧����־
					@mxts as mxts,				--6 ���ν�����ϸ����
					a.xzlb,						--7 �������
					gsrdbh,						--8 �����϶����
					gsjbbm,						--9 �����϶���������
					cfjslx,						--10 ���ν�������
					b.ksdm,                     --11 ��Ժ���ұ���  
					--case when isnull(ltrim(c.sfzh),'')='' THEN @m_mrsfzh ELSE c.sfzh END sfzh --15 ��Ժҽ������--update by winning-dingsong-chongqing on 20200820
					case when isnull(ltrim(dbo.fun_getyssfzh(a.syxh,'ZY')),'')='' THEN @m_mrsfzh ELSE dbo.fun_getyssfzh(a.syxh,'ZY') END sfzh
		from YY_CQYB_ZYJSJLK a(nolock) inner join YY_CQYB_ZYJZJLK b(nolock) on a.syxh = b.syxh and a.jzlsh = b.jzlsh
									   left join YY_ZGBMK c(nolock) on b.ysdm = c.id
		where a.syxh = @syxh and a.jsxh = @jsxh and a.jlzt in (0,1,3)
	end
	else if @xtbz = 4  --�߿�Ԥ��
	BEGIN
	    IF EXISTS (SELECT 1 FROM ZY_BRJSK a(NOLOCK) WHERE a.xh = @jsxh AND a.syxh = @syxh AND a.ybjszt = 2 )
		BEGIN
			select "F","�ò��˽�������ѽ��㣬������Ԥ�����㣡" + CONVERT(VARCHAR(12),@jsxh)
			return
		END	
		--������ֹ����
		select @qzrq = replace(ksrq,'-','') + '00:00:00' 
		from ZY_BRJSK(nolock) where syxh = @syxh and xh = @jsxh 
		--���ý�ֹ����
		select @zzrq = convert(varchar(19),getdate(),112)
		select @zzrq = substring(@zzrq,1,4)+substring(@zzrq,5,2)+substring(@zzrq,7,2) + '23:59:59' 
		
		--סԺ����
		select @zyts = datediff(day,substring(ksrq,1,8),convert(varchar(8),getdate(),112)) + 1 
		from ZY_BRJSK(nolock) where syxh = @syxh and xh = @jsxh  
		
		if exists(select 1 from ZY_BRSYK(nolock) where syxh = @syxh and brzt in (2,4))	--2��������Ժ��4��ȡ������
		begin
			--�����ܶ�   
			--select @fyze = zje - yhje from ZY_BRJSK(nolock) where xh = @jsxh and jlzt = 0 and jszt = 0 and ybjszt <> 2
			--���м���ȡ�ܽ���ZY_BRJSJEK����ҽ����HIS�Ĳ��  
			select @fyze = sum(isnull( case when @configCQ49='��' then ktje else  xmje end,0)) 
			from YY_CQYB_ZYFYMXK(nolock) where syxh = @syxh and jsxh = @jsxh 
			and  (isnull(ybscbz,0) = 1 or (@configCQ49='��' and isnull(ybscbz,0) = 4))
			--��ϸ����
			select @mxts = count(1) from YY_CQYB_ZYFYMXK(nolock) where syxh = @syxh and jsxh = @jsxh 
			and  (isnull(ybscbz,0) = 1 or (@configCQ49='��' and isnull(ybscbz,0) = 4))
		end
		else
		begin
			--�����ܶ�   
			--select @fyze = sum(zje-yhje) from ZY_BRFYMXK(nolock) 
			--where syxh = @syxh and jsxh = @jsxh and ISNULL(ybzxrq,zxrq) between @qzrq and @zzrq
			--���м���ȡ�ܽ���ZY_BRJSJEK����ҽ����HIS�Ĳ��  
			select @fyze = sum(isnull( case when @configCQ49='��' then ktje else  xmje end,0)) 
			from YY_CQYB_ZYFYMXK(nolock) 
			where syxh = @syxh and jsxh = @jsxh  and cfrq between @qzrq and @zzrq
			and  (isnull(ybscbz,0) = 1 or (@configCQ49='��' and isnull(ybscbz,0) = 4))
			--��ϸ����
			select @mxts = count(1) from YY_CQYB_ZYFYMXK(nolock) 
			where syxh = @syxh and jsxh = @jsxh and cfrq between @qzrq and @zzrq 
			and  (isnull(ybscbz,0) = 1 or (@configCQ49='��' and isnull(ybscbz,0) = 4))
		end
		select @zzrq = substring(@zzrq,1,4)+'-'+substring(@zzrq,5,2)+'-'+substring(@zzrq,7,2)
		select "T", a.jzlsh,					--1 �����/סԺ��
					@zzrq as jzrq,				--2 ��ֹ����
					@zyts as zycr,				--3	סԺ����		        
					@fyze as fyze,				--4 ���ν����ܽ��
					0 as zhzfbz,				--5 �˻�֧����־
					@mxts as mxts,				--6 ���ν�����ϸ����
					a.xzlb,						--7 �������
					'' as gsrdbh,				--8 �����϶����
					'' as gsjbbm,				--9 �����϶���������
					'' as cfjslx,				--10 ���ν�������
					a.ksdm,                     --11 ��Ժ���ұ���  
					--case when isnull(ltrim(b.sfzh),'')='' THEN @m_mrsfzh ELSE b.sfzh END sfzh --15 ��Ժҽ������--update by winning-dingsong-chongqing on 20200820
					case when isnull(ltrim(dbo.fun_getyssfzh(a.syxh,'ZY')),'')='' THEN @m_mrsfzh ELSE dbo.fun_getyssfzh(a.syxh,'ZY') END sfzh
		from YY_CQYB_ZYJZJLK a(nolock) left join YY_ZGBMK b(nolock) on a.ysdm = b.id
		where a.syxh = @syxh and a.jlzt = '1'
	end       
end       
else if @code = '05'	--����        
begin        
	if @xtbz = 0
	begin
		--�����ܶ�   
		select @fyze = zje - yhje from SF_BRJSK(nolock) where sjh = @jsxh
		--��ϸ����
		select @mxts = count(1) from GH_GHMXK(nolock) where ghxh in (select xh from GH_GHZDK(nolock) where jssjh = @jsxh) and xmdj>0
		
		--����Ժ��ְ���Ż�
        exec usp_cqyb_ynzg_gh '01',@jsxh,0,@errmsg output
		if @errmsg like "F%"
		begin
			select "F",@errmsg
			return 
		end

		select "T", a.jzlsh,					--1 �����/סԺ��
					jslb,						--2 �������
					'0' as zycr,					--3	סԺ����
					@czym as jbr,				--4 ������ 
					zhzfbz,						--5 �˻�֧����־
					jszzrq,						--6 ��;������ֹ����
					@fyze as fyze,				--7 ���ν����ܽ��
					@mxts as mxts,				--8 ���ν�����ϸ����
					a.xzlb,						--9 �������
					@hisbm as hisbm,			--10 HIS�����̱���					
					gsrdbh,						--11 �����϶����
					gsjbbm,						--12 �����϶���������
					cfjslx,						--13 ���ν�������
					b.ksdm,                     --14 ��Ժ���ұ���  
					--case when isnull(ltrim(c.sfzh),'')='' THEN @m_mrsfzh ELSE c.sfzh END sfzh --15 ��Ժҽ������--update by winning-dingsong-chongqing on 20200820
					case when isnull(ltrim(dbo.fun_getyssfzh(a.jssjh,'MZ')),'')='' THEN @m_mrsfzh ELSE dbo.fun_getyssfzh(a.jssjh,'MZ') END sfzh
		from YY_CQYB_MZJSJLK a(nolock) inner join YY_CQYB_MZJZJLK b(NOLOCK) on a.jssjh = b.jssjh and a.jzlsh = b.jzlsh
									   left join YY_ZGBMK c(nolock) on b.ysdm = c.id
		where a.jssjh = @jsxh and a.jlzt in (0,1)
	end
	else if @xtbz = 1
	begin
		--�����ܶ�   
		select @fyze = zje - yhje,@patid=patid from SF_BRJSK(nolock) where sjh = @jsxh

		--IF @patid=1328772 SELECT @fyze=214.20	
		--��ϸ����
		select @mxts = count(1) from SF_CFMXK(nolock) where cfxh in (select xh from SF_MZCFK(nolock) where jssjh = @jsxh) 
		and (zje<>0 or round((ylsj-yhdj)/ykxs,4)*ypsl*cfts<>0)
		
		select "T", a.jzlsh,					--1 �����/סԺ��
					jslb,						--2 �������
					'0' as zycr,					--3	סԺ����
					@czym as jbr,				--4 ������ 
					zhzfbz,						--5 �˻�֧����־
					jszzrq,						--6 ��;������ֹ����
					@fyze as fyze,				--7 ���ν����ܽ��
					@mxts as mxts,				--8 ���ν�����ϸ����
					a.xzlb,						--9 �������
					@hisbm as hisbm,			--10 HIS�����̱���					
					gsrdbh,						--11 �����϶����
					gsjbbm,						--12 �����϶���������
					cfjslx,						--13 ���ν�������
					b.ksdm,                     --14 ��Ժ���ұ���  
					--case when isnull(ltrim(c.sfzh),'')='' THEN @m_mrsfzh ELSE c.sfzh END sfzh --15 ��Ժҽ������--update by winning-dingsong-chongqing on 20200820
					case when isnull(ltrim(dbo.fun_getyssfzh(a.jssjh,'MZ')),'')='' THEN @m_mrsfzh ELSE dbo.fun_getyssfzh(a.jssjh,'MZ') END sfzh
		from YY_CQYB_MZJSJLK a(nolock) inner join YY_CQYB_MZJZJLK b(nolock) on a.jssjh = b.jssjh and a.jzlsh = b.jzlsh
									   left join YY_ZGBMK c(nolock) on b.ysdm = c.id
		where a.jssjh = @jsxh and a.jlzt in (0,1)
	end
	else if @xtbz in (2,3)
	begin	
	    IF EXISTS (SELECT 1 FROM ZY_BRJSK a(NOLOCK) WHERE a.xh = @jsxh AND a.syxh = @syxh AND a.ybjszt = 2 )
		BEGIN
			select "F","�ò��˽�������ѽ��㣬������Ԥ�����㣡" + CONVERT(VARCHAR(12),@jsxh)
			return
		END
	    SELECT @configCQ31 = config FROM YY_CONFIG(NOLOCK) WHERE id = 'CQ31'
	    SELECT @configCQ31 = ISNULL(@configCQ31,'��')
	    IF @configCQ31 = '��'
	    BEGIN
	        IF EXISTS(SELECT 1 FROM YY_CQYB_ZDYZDSPJG(NOLOCK) WHERE syxh = @syxh AND ISNULL(spjg,'0') = 2 )
	        BEGIN
	            SELECT "F","�ò����ѱ�ҽ���Ʊ��Ϊ��ϲ�����ҽ�����������ܽ���ҽ�����㣡"
	            return
	        END
			if EXISTS(select 1 FROM YY_CQYB_ZDYZDSPJG(NOLOCK) where syxh = @syxh AND isnull(spjg,'0') = 0)
			begin
				select "F","�ò����Ƿ����ҽ��������Ҫҽ�������������ܽ�����ҽ���Ǽǣ�"
				return
			end	        
	    END
	    
	    SELECT @configCQ32 = config FROM YY_CONFIG(NOLOCK) WHERE id = 'CQ32'
	    SELECT @configCQ32 = ISNULL(@configCQ32,'��')
	    IF @configCQ32 = '��'
	    BEGIN
	    	IF EXISTS (SELECT 1 FROM YY_CQYB_ZYFYMXK a(NOLOCK) 
						INNER JOIN YY_CQYB_ZDYSPXM b(NOLOCK) 
						        ON (CASE WHEN a.idm = 0 then  a.xmdm ELSE CONVERT(VARCHAR(30),a.idm) END) = b.xmdm 
							   AND b.xmlb IN ('0','1') AND b.jlzt = '0'
						LEFT JOIN YY_CQYB_ZDYSPFYMX c(NOLOCK) ON a.xh = c.xh 
		    WHERE a.syxh = @syxh AND a.jsxh = @jsxh )
		    BEGIN
		        SELECT "F","�ò��˴��ڻ�δ�����ķ��ã����ȵ�ҽ���ƽ���������"
	            return
		    END
	    END
	    
		SELECT @configCQ19 = config FROM YY_CONFIG(NOLOCK) WHERE id = 'CQ19'
		IF @configCQ19 = '��' 
		BEGIN
		    SELECT @configCQ50 = config FROM YY_CONFIG(NOLOCK) WHERE id = 'CQ50'
			SELECT @ybshbz = isnull(shbz,0),@ybcyzdshbz = ISNULL(ybcyzdshbz,0) from ZY_BRJSK(nolock) where syxh=@syxh and xh = @jsxh
			IF @configCQ50 = '1'
			BEGIN
				if @ybshbz <> 1
				begin
					SELECT "F","�ò���δҽ�����ͨ�������ȵ�ҽ���ƽ�����ˣ�"
					RETURN
				end
			END
			--���δ�����ҽ�������ͨ�����ܽ���
			if NOT (@ybcyzdshbz = 1 AND @ybshbz = 1)
			BEGIN
				SELECT @configCQ64 = config FROM YY_CONFIG(NOLOCK) WHERE id = 'CQ64'
				IF @configCQ64 = '1'
				    SELECT @configCQ64 = ISNULL(@configCQ64,'')
				IF @configCQ64 <> '-1' and @configCQ64 <> ''
				BEGIN
					SELECT @dbzdzje = a.je from ZY_BRJSJEK a(NOLOCK) WHERE a.lx = 'yb08' AND jsxh = @jsxh

					IF EXISTS(SELECT 1 FROM YY_CONFIG a(NOLOCK) WHERE a.id = 'CQ01' AND a.config = 'WD')
					BEGIN
						SELECT @dbzdzje = @dbzdzje + a.je  from ZY_BRJSJEK a(NOLOCK) WHERE a.lx = 'yb23' AND jsxh = @jsxh
					END

					IF @dbzdzje > CONVERT(NUMERIC(12,2),@configCQ64) AND (@ybcyzdshbz = 0 OR @ybshbz = 0)
					BEGIN
					    BEGIN TRAN
					    UPDATE ZY_BRJSK SET ybcyzdshbz = 0,@ybshbz = 0 WHERE xh = @jsxh
					    IF @@error <> 0 or @@rowcount = 0 
						BEGIN
						    ROLLBACK TRAN
							SELECT 'F','����ҽ����˱�־����' 
							RETURN
						END
						INSERT INTO YY_CQYB_YBSHLOG(syxh,jsxh,shbz,czyh,czrq) 
						VALUES(@syxh,@jsxh,0,@zgdm,@now) 
						IF @@error <> 0 or @@rowcount = 0 
                        BEGIN
						    ROLLBACK TRAN
							SELECT 'F','��¼�����־ʧ��' 
							RETURN
						END
						COMMIT TRAN
						
						SELECT 'F','��ע�⣺�û���ҽԺ��֧��'+CONVERT(VARCHAR(20),@dbzdzje)+'���ѳ����޶'+@configCQ64+'����ҽ�������ͨ�����ܽ��㣡'
						RETURN
					END
				END
			END
		END   

		--������ֹ����
		select @qzrq = case len(rtrim(jsqzrq)) when 10 then replace(jsqzrq,'-','') + '00:00:00' else replace(replace(jsqzrq,'-',''),' ','') end
		from YY_CQYB_ZYJSJLK(nolock) where syxh = @syxh and jsxh = @jsxh and jlzt in (1,3)
		--���ý�ֹ����
		/*
		select @zzrq = case len(rtrim(jszzrq)) when 10 then replace(jszzrq,'-','') + '23:59:59' else replace(replace(jszzrq,'-',''),' ','') end
		from YY_CQYB_ZYJSJLK(nolock) where syxh = @syxh and jsxh = @jsxh and jlzt in (1,3) 
		*/
		select @zzrq = 
			CASE when ISNULL(jszzrq,'') = '' THEN  
				CASE WHEN b.brzt not IN ('2','4') THEN @now ELSE b.cqrq  end
			else  
				CASE LEN(RTRIM(a.jszzrq)) when 10 THEN REPLACE(a.jszzrq,'-','') + '23:59:59' ELSE REPLACE(REPLACE(a.jszzrq,'-',''),' ','') end 
			end
		FROM YY_CQYB_ZYJSJLK a(nolock),ZY_BRSYK b(NOLOCK) WHERE a.syxh = b.syxh and a.syxh = @syxh and a.jsxh = @jsxh and a.jlzt in (1,3) 
		
		--סԺ����
		select @zyts = datediff(day,jsqzrq,dbo.fun_convertrq_cqyb(2,@zzrq)) + 1
		from YY_CQYB_ZYJSJLK(nolock) where syxh = @syxh and jsxh = @jsxh and jlzt in (1,3)  
							
		if exists(select 1 from ZY_BRSYK(NOLOCK) where syxh = @syxh and brzt in (2,4))
		begin
			--�����ܶ�  
			--select @fyze = zje - yhje from ZY_BRJSK(nolock) where xh = @jsxh and jlzt = 0 and jszt = 0 and ybjszt <> 2
			--���м���ȡ�ܽ���ZY_BRJSJEK����ҽ����HIS�Ĳ��  
			select @fyze = sum(isnull( case when @configCQ49='��' then ktje else  xmje end,0)) 
			from YY_CQYB_ZYFYMXK(nolock) where syxh = @syxh and jsxh = @jsxh 
			and  (isnull(ybscbz,0) = 1 or (@configCQ49='��' and isnull(ybscbz,0) = 4))
			--��ϸ����
			select @mxts = count(1) from YY_CQYB_ZYFYMXK(nolock) where syxh = @syxh and jsxh = @jsxh 
			and  (isnull(ybscbz,0) = 1 or (@configCQ49='��' and isnull(ybscbz,0) = 4))
		end
		else
		begin
			--�����ܶ�   
			--select @fyze = sum(zje-yhje) from ZY_BRFYMXK(nolock) 
			--where syxh = @syxh and jsxh = @jsxh and ISNULL(ybzxrq,zxrq) between @qzrq and @zzrq
			--���м���ȡ�ܽ���ZY_BRJSJEK����ҽ����HIS�Ĳ��  
			select @fyze = sum(isnull( case when @configCQ49='��' then ktje else  xmje end,0)) 
			from YY_CQYB_ZYFYMXK(nolock) 
			where syxh = @syxh and jsxh = @jsxh and cfrq between @qzrq and @zzrq
			and  (isnull(ybscbz,0) = 1 or (@configCQ49='��' and isnull(ybscbz,0) = 4))
			--��ϸ����
			select @mxts = count(1) from YY_CQYB_ZYFYMXK(nolock) 
			where syxh = @syxh and jsxh = @jsxh and cfrq between @qzrq and @zzrq
			and  (isnull(ybscbz,0) = 1 or (@configCQ49='��' and isnull(ybscbz,0) = 4))
		END
        
        --����ÿ�ν�����ϴ�������ϸ
		IF NOT EXISTS (SELECT 1 FROM ZY_BRJSK(NOLOCK) WHERE syxh = @syxh AND xh = @jsxh AND ybjszt = 2)
		BEGIN
			BEGIN TRAN
			DELETE YY_CQYB_ZYFYMXK_JS WHERE syxh = @syxh and jsxh = @jsxh
			if @@error <> 0
			begin
				select 'F','��ʼ���ν����ϴ���ϸʧ�ܣ�'
				ROLLBACK TRAN
				return
			END
			DELETE YY_CQYB_NZYFYMXK_JS WHERE syxh = @syxh and jsxh = @jsxh
			if @@error <> 0
			begin
				select 'F','��ʼ���ν����ϴ���ϸʧ��(N)��'
				ROLLBACK TRAN
				return
			END
			INSERT INTO YY_CQYB_ZYFYMXK_JS
			(
				syxh,jsxh,xh,txh,cfh,cfrq,idm,xmdm,xmmc,xmgg,xmdj,xmsl,xmdw,xmje,ksdm,ysdm,jbr,jzbz,
				zzfbz,ktsl,ktje,spbz,spclbz,qzfbz,ybscbz,zxlsh,ybxmdj,ybspbz,ybzje,sfxmdj,ybzfbl,
				ybbzdj,ybzfje,ybzlje,dydm,scxmdj,scxmsl,scxmje
			)
			SELECT 
				syxh,jsxh,xh,txh,cfh,cfrq,idm,xmdm,xmmc,xmgg,xmdj,xmsl,xmdw,xmje,ksdm,ysdm,jbr,jzbz,
				zzfbz,ktsl,ktje,spbz,spclbz,qzfbz,ybscbz,zxlsh,ybxmdj,ybspbz,ybzje,sfxmdj,ybzfbl,
				ybbzdj,ybzfje,ybzlje,dydm,scxmdj,scxmsl,scxmje
			FROM YY_CQYB_ZYFYMXK(NOLOCK) 
			WHERE syxh = @syxh AND jsxh = @jsxh AND ISNULL(ybscbz,0) = 1
			  AND cfrq between @qzrq and @zzrq
			  AND  (isnull(ybscbz,0) = 1 or (@configCQ49='��' and isnull(ybscbz,0) = 4))
			if @@error <> 0
			begin
				select 'F','���汾�ν����ϴ���ϸʧ�ܣ�'
				ROLLBACK TRAN
				return
			end
			COMMIT TRAN
		END
		ELSE
        BEGIN
           SELECT 'F','�û����ѽ��㣬�����ٴν���'
		   RETURN 
        END

		select "T", a.jzlsh,					--1 �����/סԺ��
					a.jslb,						--2 �������
					@zyts as zycr,				--3	סԺ����
					@czym as jbr,				--4 ������ 
					zhzfbz,						--5 �˻�֧����־
					substring(jszzrq,1,10),		--6 ��;������ֹ����
					@fyze as fyze,				--7 ���ν����ܽ��
					@mxts as mxts,				--8 ���ν�����ϸ����
					a.xzlb,						--9 �������
					@hisbm as hisbm,			--10 HIS�����̱���					
					a.gsrdbh,						--11 �����϶����
					a.gsjbbm,						--12 �����϶���������
					a.cfjslx,						--13 ���ν�������
					d.ksdm,                     --14 ��Ժ���ұ���  
					--case when isnull(ltrim(c.sfzh),'')='' THEN @m_mrsfzh ELSE c.sfzh END sfzh --15 ��Ժҽ������--update by winning-dingsong-chongqing on 20200820
					case when isnull(ltrim(dbo.fun_getyssfzh(a.syxh,'ZY')),'')='' THEN @m_mrsfzh ELSE dbo.fun_getyssfzh(a.syxh,'ZY') END sfzh
		from YY_CQYB_ZYJSJLK a(nolock) inner join YY_CQYB_ZYJZJLK b(nolock) on a.syxh = b.syxh and a.jzlsh = b.jzlsh
									   inner join YY_ZGBMK c(nolock) on b.ysdm = c.id 
									   INNER join ZY_BRJSK d(nolock) on a.syxh=d.syxh and a.jsxh=d.xh 
		where a.syxh = @syxh and a.jsxh = @jsxh and a.jlzt in (1,3)and a.jsxh=d.xh
	end       
end 
else if @code = '21'	--ҽ�����շ�(�׵���)��������
begin
	if @xtbz = 1
	begin
		select "T",	a.jzlsh,					--1	�����/סԺ��
					c.zxlsh,					--2 ������ϸ��ˮ��
					(case when c.spbz = 1 then 1 else 0 end) as spbz,			
												--3 �������
					a.xzlb					 	--4 �������
			from YY_CQYB_MZJZJLK a(nolock)
				inner join SF_MZCFK b(nolock) on a.jssjh = b.jssjh
				inner join SF_CFMXK c(nolock) on c.xh = c.cfxh and isnull(c.ybspbz,0) <> 0 and c.spclbz = 0
			where a.jssjh = @jsxh and a.jlzt = 1  
	end
	else --if @xtbz in (2,3)
	begin
		select "T",	a.jzlsh,					--1	�����/סԺ��
					b.zxlsh,					--2 ������ϸ��ˮ��
					(case when b.spbz = 1 then 1 else 0 end) as spbz,			
												--3 �������
					a.xzlb						--4 �������
			from YY_CQYB_ZYJZJLK a(nolock)
				inner join YY_CQYB_ZYFYMXK b(nolock) on a.syxh = b.syxh and b.jsxh = @jsxh and isnull(b.ybscbz,0) = 1 
														and b.spbz <> 0 
														and ((@cxbz not in(1,2) and isnull(b.ybspbz,0) <> 0) or (@cxbz in(1,2)  and isnull(b.ybspbz,0) =@cxbz)) --AND b.spclbz = 0
			where a.syxh = @syxh and jlzt = 1 AND ( (@configCQ01 = 'DR') OR (@configCQ01 = 'WD' AND b.spclbz = 0) )
	end
end
else if @code = '22'	--ҽ��δ������Ŀ��ѯ
BEGIN
    --�����ز���������ѯ�ӿڲ��ܱ�����
    IF @configCQ01 = 'WD' 
	BEGIN
		IF @xtbz in (0,1) and EXISTS (SELECT 1 FROM YY_CQYB_MZJZJLK a(NOLOCK) WHERE jssjh = @jsxh AND a.sbkh LIKE '#%')
		BEGIN
            SELECT 'N',''
			RETURN
		END  
		ELSE IF EXISTS (SELECT 1 FROM YY_CQYB_ZYJZJLK a(NOLOCK) WHERE syxh = @syxh AND a.sbkh LIKE '#%') 
		BEGIN
            SELECT 'N',''
			RETURN
		END
	END

	if @xtbz in (0,1)
	BEGIN
		select "T",	jzlsh,						--1	�����/סԺ��
					@cxbz,						--2 ��������
					dbo.fun_convertrq_cqyb(2,''),
												--3 ��ѯ����
					xzlb						--4 �������
			from YY_CQYB_MZJZJLK(nolock)
			where jssjh = @jsxh and jlzt = 1
	end
	else --if @xtbz in (2,3)
	begin
		select "T",	jzlsh,						--1	�����/סԺ��
					@cxbz,						--2 ��������
					dbo.fun_convertrq_cqyb(2,''),
												--3 ��ѯ����
					xzlb						--4 �������
			from YY_CQYB_ZYJZJLK(nolock)
			where syxh = @syxh and jlzt = 1
	end
end
else if @code = '23'	--ҽ���˻�����
begin
	if @xtbz in (0,1)
	begin
		select "T",	jzlsh,						--1	�����/סԺ��
					sbkh,						--2 ��ҽ�˱��
					name,						--3 ��ҽ������
					sfzh,						--4 ��ҽ�����֤��
					xzqhbm,						--5 ��ҽ����������
					dykh,						--6 �������籣��
					dyje,						--7 �����ý��
					@czym as jbr,				--8 ������
					zxlsh,						--9 ���㽻����ˮ��(�����ý����¼)
					cblb						--10 ��ҽ�˲α����
			from YY_CQYB_MZDYJLK(nolock)
			where jssjh = @jsxh and jlzt = 1
	end
	else if @xtbz in (2,3)
	begin
		select "T",	jzlsh,						--1	�����/סԺ��
					sbkh,						--2 ��ҽ�˱��
					name,						--3 ��ҽ������
					sfzh,						--4 ��ҽ�����֤��
					xzqhbm,						--5 ��ҽ����������
					dykh,						--6 �������籣��
					dyje,						--7 �����ý��
					@czym as jbr,				--8 ������
					zxlsh,						--9 ���㽻����ˮ��(�����ý����¼)
					cblb						--10 ��ҽ�˲α����
			from YY_CQYB_ZYDYJLK(nolock)
			where syxh = @syxh and jsxh = @jsxh and jlzt = 1
	end
end
else if @code = '33'	--����������Ա���������Ϣ
begin
	if @cxbz = 0		--��ȡҽ��վ��������Ϣ
	begin
		select 1
	end
	else if @cxbz = 1	--ҽ��������Ϣ
	begin
		if @xtbz in (0,1)
		begin
			select "T",	jzlsh,					--1	�����/סԺ��
						sylb,					--2 �����������
						sysj,					--3 ����ʱ���
						sybfz,					--4 ����֢
						ncbz,					--5 �Ѳ�
						rslx,					--6 ��ֹ��������
						dbtbz,					--7 ���̥��־
						syfwzh,					--8 ��������֤��
						jyjc,					--9 �Ŵ�����������Ŀ
						jhzh					--10 ���֤��
				from YY_CQYB_MZJSJLK(nolock)
				where jssjh = @jsxh and jlzt in (0,1)
		end
		else --if @xtbz in (2,3)
		begin
			select "T",	jzlsh,					--1	�����/סԺ��
						sylb,					--2 �����������
						sysj,					--3 ����ʱ���
						sybfz,					--4 ����֢
						ncbz,					--5 �Ѳ�
						rslx,					--6 ��ֹ��������
						dbtbz,					--7 ���̥��־
						syfwzh,					--8 ��������֤��
						jyjc,					--9 �Ŵ�����������Ŀ
						jhzh					--10 ���֤��
				from YY_CQYB_ZYJSJLK(nolock)
				where syxh = @syxh and jsxh = @jsxh and jlzt in (0,1,3)
		end;
	end;
end
else if @code = '43'	--���㽻����ˮ�Ų�ѯ
begin
	if @xtbz in (0,1)
	begin
		select "T",	isnull(sbkh,""),			--1 ����
					cblb,						--2 �α����
					dbo.fun_convertrq_cqyb(2,''),
												--3	��������			        
					xzlb,						--4 �������
					jzlsh						--5 �����/סԺ��
		from YY_CQYB_MZJZJLK(nolock) 
		where jssjh = @jsxh and jlzt = 1
	end
	else if @xtbz = 2
	begin
		select "T",	isnull(sbkh,""),			--1 ����
					cblb,						--2 �α����
					dbo.fun_convertrq_cqyb(2,''),
												--3	��������			        
					xzlb,						--4 �������
					jzlsh						--5 �����/סԺ��
		from YY_CQYB_ZYJZJLK(nolock) 
		where syxh = @syxh and jlzt = 1
	end
end
else if @code = '99'	--��������     
begin       
    declare @error_qx varchar(200) 
	if @xtbz in (0,1)
	begin
		if exists (select 1 FROM VW_MZBRJSK a(NOLOCK) ,YY_YBFLK b(NOLOCK) WHERE a.ybdm = b.ybdm AND b.ybjkid = @configCQ18 and a.sjh=@jsxh)
		--��������
		begin
			exec usp_cqyb_ybxlsjzh 0,@jsxh,@xtbz,@error_qx output
			if @error_qx like "F%"
			begin
				select "F",@error_qx
				return 
			end
		end

		if @cxbz = 0 
		begin
			select "T",	isnull(zxlsh,""),		--1 ������ˮ��
						@czym as jbr,			--2 ������
						jzlsh,					--3	�����/סԺ��
						0 as czlx,				--4 ��������0��ͨ����1���˳���(����������)
						xzlb					--5 �������
			from VW_CQYB_MZJZJLK(nolock) 
			where jssjh = @jsxh and jlzt = 1
		end
		else if @cxbz = 1
		begin
			select "T",	isnull(zxlsh,""),		--1 ������ˮ��
						@czym as jbr,			--2 ������
						jzlsh,					--3	�����/סԺ��
						0 as czlx,				--4 ��������0��ͨ����1���˳���(����������)
						xzlb					--5 �������
			from VW_CQYB_MZJSJLK(nolock)
			where jssjh = @jsxh	and jlzt = 2	
		end
	end
	else if @xtbz = 2
	begin
		if @cxbz = 0 
		begin
			select "T",	isnull(zxlsh,""),		--1 ������ˮ��
						@czym as jbr,			--2 ������
						jzlsh,					--3	�����/סԺ��
						0 as czlx,				--4 ��������0��ͨ����1���˳���(����������)
						xzlb					--5 �������
			from YY_CQYB_ZYJZJLK(nolock) 
			where syxh = @syxh and jlzt = 1
		end
		else if @cxbz = 1
		begin
            --��������
			if exists (select 1 FROM ZY_BRSYK a(NOLOCK) ,YY_YBFLK b(NOLOCK) WHERE a.ybdm = b.ybdm AND b.ybjkid = @configCQ18 and a.syxh=@syxh)
			begin
				exec usp_cqyb_ybxlsjzh @syxh,0,@xtbz,@error_qx output
				if @error_qx like "F%"
				begin
					select "F",@error_qx
					return 
				end
			END
            
			select "T",	isnull(zxlsh,""),		--1 ������ˮ��
						@czym as jbr,			--2 ������
						jzlsh,					--3	�����/סԺ��
						0 as czlx,				--4 ��������0��ͨ����1���˳���(����������)
						xzlb					--5 �������
			from YY_CQYB_ZYJSJLK(nolock) 
			where syxh = @syxh and jsxh = @jsxh	and jlzt = 2
		end
	end;   
end
ELSE IF @code = '99ZYHCMX' --סԺ�����ϸ ����Ѿ��ϴ��Ĳ���Ҫ�ϴ�����ϸ
BEGIN
    SELECT "T", a.xh,a.ybscbz,
	        	isnull(a.zxlsh,''),		--1 ������ˮ��
				@czym as jbr,			--2 ������
				jzlsh,					--3	�����/סԺ��
				0 as czlx,				--4 ��������0��ͨ����1���˳���(����������)
				xzlb					--5 �������
    FROM YY_CQYB_ZYFYMXK a(NOLOCK),YY_CQYB_ZYJZJLK b(NOLOCK) 
	WHERE a.syxh = @syxh AND a.jsxh = @jsxh AND ISNULL(a.ybscbz,0) in (3,4) AND ISNULL(a.zxlsh,'') <> '' 
	  AND a.syxh = b.syxh AND b.jlzt = 1
END
ELSE IF @code = '99ZYHCMXOTHER' --סԺ�����ϸ ���������Ҫ������ϸ
BEGIN
	SELECT "T",b.xh,b.ybscbz,
	isnull(b.zxlsh,''),					--1 ������ˮ��
	@czym as jbr,						--2 ������
	c.jzlsh,							--3	�����/סԺ��
	0 AS czlx,							--4 ��������0��ͨ����1���˳���(����������)
	c.xzlb								--5 �������
	FROM YY_CQYB_ZDYSPFYMX a(NOLOCK) INNER JOIN YY_CQYB_ZYFYMXK b(NOLOCK)
	ON a.xh = b.xh INNER JOIN YY_CQYB_ZYJZJLK c(NOLOCK) ON b.syxh = c.syxh 
	WHERE b.syxh = @syxh AND b.jsxh = @jsxh AND ISNULL(sftb,0) = 0 AND c.jlzt = 1
	AND ISNULL(b.ybscbz,0) = 1 AND ISNULL(b.zxlsh,'') <> '' ORDER BY b.xmsl ASC;
END
ELSE IF LTRIM(rtrim(@code)) = 'T10'       
BEGIN    
    IF @xtbz = 1
	begin 
		SELECT DISTINCT 
			   d.jzlsh,
			   c.cfxh,    
			   d.xzlb 
		FROM SF_BRJSK a(NOLOCK),SF_MZCFK b(NOLOCK),SF_CFMXK c(NOLOCK) ,YY_CQYB_MZJZJLK d(NOLOCK) 
		WHERE a.sjh = b.jssjh AND b.xh = c.cfxh AND a.ybjszt <> 2 AND ISNULL(c.zxlsh,'') <> '' 
		  AND SUBSTRING(a.sfrq,1,8) = REPLACE(CONVERT(VARCHAR(10),GETDATE(),120),'-','') 
		  AND a.ghsfbz = 1
		  AND a.sjh <> @jsxh
		  AND a.sjh = b.jssjh
	end     
END
ELSE
begin
	select "F","δ����Ľ�������!"
	return;
end;

return




