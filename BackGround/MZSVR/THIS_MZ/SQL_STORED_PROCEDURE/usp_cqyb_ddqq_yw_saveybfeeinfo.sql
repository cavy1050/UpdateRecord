if exists(select * from sysobjects where name='usp_cqyb_ddqq_yw_saveybfeeinfo')
  drop proc usp_cqyb_ddqq_yw_saveybfeeinfo
go
Create proc usp_cqyb_ddqq_yw_saveybfeeinfo
(
	@syxh			ut_syxh,			--��ҳ���
	@jsxh			ut_xh12,			--�������
	@lb				int = 0,			--0������ʱ��1��������2ȡ������
	@czyh			varchar(20) = '',	--����Ա��
	@wkdz			varchar(50) = '',	--������ַ
	@ZYMZH			varchar(50) = '',	-- סԺ�����
	@CFH			varchar(20) = '',			--������
	@CFJYLSH		varchar(30) = '',	--����������ˮ��
	@KFRQ			varchar(20) = '',	--��������
	@YYNM			varchar(30) = '',	--Ժ����
	@YBLSH			varchar(30) = '',	--ҽ�����ı���
	@XMMC			varchar(50) = '',	--��Ŀ����
	@DJ				numeric(20,4) = 0,	--����
	@SL				numeric(20,4) = 0,	--����
	@JE				numeric(20,4) = 0,	--�ܽ��
	@FYDJ			varchar(3) = '3',			--���õȼ�
	@ZFBL			numeric(20,4) = 0,	--�Ը�����
	@BZDJ			VARCHAR(20) = '',	--��׼����
	@ZFJE			numeric(20,4) = 0,	--�Ը����
	@CBJE			numeric(20,4) = 0,	--������
	@TYBZ			varchar(3) = '0',			--��ҩ��־
	@JSBZ			varchar(3) = '0',			--�����־
	@JSRQ			varchar(20) = '',	--��������
	@JSJYLSH		varchar(30) = '',	--���㽻����ˮ��
	@CSBZ			varchar(3)	= '0'				--�����־
)
as
/****************************************
[�汾��]4.0.0.0.0
[����ʱ��]2017.03.05
[����]FerryMan
[��Ȩ]Copyright ? 1998-2017���������Ƽ����Źɷ����޹�˾
[����]����ǰ�û�ҽ��������ϸ��Ϣ
[����˵��]
	����ǰ�û�ҽ��������ϸ��Ϣ
[����˵��]
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��]
[�޸ļ�¼]
****************************************/
set nocount on

declare @tablename varchar(32),
		@strsql varchar(8000)

select @tablename = '##cfmx' + @wkdz + @czyh

if @lb = 0 
begin
	exec('if exists(select * from tempdb..sysobjects where name = "'+@tablename+'") drop table '+@tablename)  
	
	exec('create table '+@tablename+' ( 
			XH		ut_xh12 identity not null,		--���
			ZYMZH	varchar(50)			null,		-- סԺ�����
			CFH		varchar(20)					null,		--������
			CFJYLSH varchar(30)			null,		--����������ˮ��
			KFRQ	varchar(20)			null,		--��������
			YYNM	varchar(30)			null,		--Ժ����
			YBLSH	varchar(30)			null,		--ҽ�����ı���
			XMMC	varchar(50)			null,		--��Ŀ����
			DJ		numeric(20,4)		null,		--����
			SL		numeric(20,4)		null,		--����
			JE		numeric(20,4)		null,		--�ܽ��
			FYDJ	varchar(3)					null,		--���õȼ�
			ZFBL	numeric(20,4)		null,		--�Ը�����
			BZDJ	varchar(20)			null,		--��׼����
			ZFJE	numeric(20,4)		null,		--�Ը����
			CBJE	numeric(20,4)		null,		--������
			TYBZ	varchar(3)					null,		--��ҩ��־
			JSBZ	varchar(3)					null,		--�����־
			JSRQ	varchar(20)			null,		--��������
			JSJYLSH varchar(30)			null,		--���㽻����ˮ��
			CSBZ	varchar(3)					null		--�����־
		)') 
	if @@error <> 0  
	begin  
		select "F","������ʱ��ʱ����!"  
		return  
	end  
	
	select "T"
	return
end
else if @lb = 1
begin
	exec('insert into '+@tablename+' values("'+@ZYMZH+'","'+@CFH+'","'+@CFJYLSH+'",
		"'+@KFRQ+'","'+@YYNM+'","'+@YBLSH+'","'+@XMMC+'","'+@DJ+'","'+@SL+'","'+@JE+'","'+@FYDJ+'","'+@ZFBL+'",
		"'+@BZDJ+'","'+@ZFJE+'","'+@CBJE+'","'+@TYBZ+'","'+@JSBZ+'","'+@JSRQ+'","'+@JSJYLSH+'","'+@CSBZ+'")')
	if @@error<>0 or @@rowcount = 0 
	begin
		select "F","������ʱ��ʱ����!"
		return
	end

	select "T"
	return
end
else if @lb = 2
begin
	exec('select XH as "���",YBLSH "ҽ������" ,CFJYLSH as "������ˮ��",CFH as "������",KFRQ as "��������",XMMC as "��Ŀ����",JE as "���" '
	   + 'from '+@tablename)
	return
end
else if @lb = 3
begin
	create table #temp_fymx        
	(        
		mxxh	ut_xh12		not null,			--1 ��ϸ���
		cfh		ut_xh12			null,			--2 ������
		cfrq    varchar(20)     null,			--3 ��������
		xmmc	varchar(50)     null,			--4 ҽԺ�շ���Ŀ����
		xmgg    varchar(20)     null,			--5 ���	
		xmdj    ut_money		null,			--6 ����	
		xmsl	ut_sl10			null,			--7 ����
		xmdw    varchar(20)     null,			--8 ��λ
		xmje    ut_money	    null,			--9 ���
		ybbm	varchar(10)     null,			--10 ��Ŀҽ����ˮ��
		ybscbz	varchar(10)     null,			--11 ҽ���ϴ���־
		sfxmdj	varchar(10)     null,			--12 ҽ����Ŀ�ȼ�
		spbz	varchar(10)     null,			--13 ������־
		ybspbz	varchar(10)		null,			--14 ҽ��������־
		qzfbz	varchar(10)		null,			--15 ȫ�Էѱ�־
		zxlsh	varchar(20)		null			--16 ������ˮ��
	)

	insert into #temp_fymx(mxxh,cfh,cfrq,xmmc,xmje,ybscbz,zxlsh)
	select b.xh,b.cfh,dbo.fun_convertrq_cqyb(1,b.cfrq),b.xmmc,b.xmje,b.ybscbz,b.zxlsh
	from YY_CQYB_ZYJZJLK a(nolock) 
		inner join YY_CQYB_ZYFYMXK b(nolock) on a.syxh = b.syxh and b.jsxh = @jsxh and ybscbz = 1
	where a.syxh = @syxh and a.jlzt = 1
	
	set @strsql = 'select mxxh as "�������",cfh as "������",cfrq as "�շ�����",xmmc as "ҩƷ����",xmje as "ҩƷ���",'
		        + '(case ybscbz when 1 then "���ϴ�" when 2 then "�����ϴ�" else "δ�ϴ�" end) as "�ϴ���־",'
		        + 'zxlsh as "������ˮ��" from #temp_fymx b where  not EXISTS (select 1 from '+@tablename+' where isnull(b.zxlsh,"") = CFJYLSH)'
	exec(@strsql)
	return
end
else if @lb = 4
begin
	select * into #YY_CQYB_ZYFYMXK from YY_CQYB_ZYFYMXK where syxh = @syxh and jsxh = @jsxh and ybscbz = 1 
	
	set @strsql = 'select XH as "���",CFJYLSH as "������ˮ��",CFH as "������",KFRQ as "��������",XMMC as "��Ŀ����",JE as "���" '
	            + 'from '+@tablename+' where  not EXISTS (select 1 from #YY_CQYB_ZYFYMXK where CFJYLSH = zxlsh)'
	exec(@strsql)
	return
end
GO
