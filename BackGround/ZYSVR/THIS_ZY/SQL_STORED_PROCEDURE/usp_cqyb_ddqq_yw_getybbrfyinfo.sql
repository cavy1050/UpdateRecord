Text

CREATE proc usp_cqyb_ddqq_yw_getybbrfyinfo
(
	@syxh			ut_syxh,		--��ҳ���
	@jsxh			ut_xh12,		--�������
	@cxlb			ut_bz 			--��ѯ���0������Ϣ1������Ϣ2������Ϣ3�쳣����У�������ϸ4����������Ϣ5�Զ���������Ŀ������Ϣ6�Զ���������Ŀ���û�����Ϣ
)
as
/****************************************
[�汾��]4.0.0.0.0
[����ʱ��]2017.03.05
[����]FerryMan
[��Ȩ]Copyright ? 1998-2017���������Ƽ����Źɷ����޹�˾
[����]סԺҽ����˻�ȡ�����б�
[����˵��]
	סԺҽ����˻�ȡ�����б�
[����˵��]
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��]
[�޸ļ�¼]
****************************************/
set nocount on 

declare @qzrq	ut_rq16,				--������ֹ����
		@zzrq	ut_rq8,				--������ֹ����
		@errmsg varchar(150),				--������Ϣ
		@configCQ36 VARCHAR(3)     --ȡdydm��ʽ
		,@zje ut_money

set @zje = 0.00
SELECT @configCQ36 = config FROM YY_CONFIG where id = 'CQ36'

IF ISNULL(@configCQ36,'') <> '2'
BEGIN
    SELECT @configCQ36 = '1' 
END

	select @zzrq=substring(jszzrq,1,4)+substring(jszzrq,6,2)+substring(jszzrq,9,2) from YY_CQYB_ZYJSJLK WHERE syxh=@syxh and jsxh=@jsxh

create table #temp_fymx        
(        
	mxxh	ut_xh12		not null,			--1 ��ϸ���
	cfh		ut_xh12			null,			--2 ������
	cfrq    varchar(20)     null,			--3 ��������
	xmmc	varchar(50)     null,			--4 ҽԺ�շ���Ŀ����
	xmgg    ut_mc32         null,			--5 ���	
	xmdj    ut_money		null,			--6 ����	
	xmsl	ut_sl10			null,			--7 ����
	xmdw    varchar(20)     null,			--8 ��λ
	xmje    ut_money	    null,			--9 ���
	ybbm	varchar(10)     null,			--10 ��Ŀҽ����ˮ��
	ybscbz	varchar(10)     null,			--11 ҽ���ϴ���־
	sfxmdj	varchar(10)     null,			--12 ҽ����Ŀ�ȼ�
	spbz	varchar(10)     null,			--13 ������־
	ybspbz	varchar(10)		null,			--14 ҽ��������־
	ybbzdj	ut_money		null,			--15 ҽ����׼����
	ybzlje	ut_money		null,			--16 ҽ��������
	qzfbz	varchar(10)		null,			--17 ȫ�Էѱ�־
	zxlsh	varchar(20)		null,			--19 ������ˮ��
	cbbz	ut_bz			null,			--20 �����־
	ybxybz  VARCHAR(1000)   null            --21 ҽ�����ñ�ע
)

if @cxlb = 0		--������Ϣ
BEGIN
    --�������
	if exists(select * from sysobjects where name='usp_zy_brfymxjec')
	begin
		SELECT @zje = zje FROM ZY_BRJSK(NOLOCK) WHERE syxh = @syxh AND xh = @jsxh
		if @zje <> (SELECT sum(zje) from ZY_BRFYMXK(NOLOCK) WHERE syxh=@syxh and jsxh=@jsxh) 
		begin  
			EXEC usp_zy_brfymxjec @syxh,@jsxh,@zje output   
		END
	END
    
	exec usp_cqyb_zyfymxcl @syxh,@jsxh,0,@errmsg out  
	if substring(@errmsg,1,1)='F'   
	begin  
		select 'F',@errmsg  
		return  
	END
	 	
	--����ҽ�����ϴ��ķ�����ϸbegin
	IF EXISTS(SELECT 1 FROM YY_JBCONFIG(NOLOCK) WHERE yydm IN ('10017','10018'))
	begin
		select * into #temp_fymxk from ZY_BRFYMXK(nolock)  where syxh = @syxh and jsxh = @jsxh
		--��������һ
		update a set ybscbz = 0
		from YY_CQYB_ZYFYMXK a(nolock) inner join #temp_fymxk b(nolock) on a.xh = b.xh and b.scbz in (-1,0,3,4)
		where a.syxh = @syxh and a.jsxh = @jsxh and a.ybscbz <> 1 and a.ybscbz <> 0
	
		update a set ybscbz = 1,zxlsh = b.mxlsh
		from YY_CQYB_ZYFYMXK a(nolock) inner join #temp_fymxk b(nolock) on a.xh = b.xh and b.scbz = 1
		where a.syxh = @syxh and a.jsxh = @jsxh and a.ybscbz <> 1
    
		UPDATE ZY_BRFYMXK SET scbz = 0 WHERE syxh = @syxh 
    end
	--�����汾�ӿ�,�ڴ�����������䣬���Ͻӿ��м������ȡ���ݸ��£������д���Ͻӿ����ϴ����ֱ�־������д��ȷ���������µǼǺ����ϴ���ϸ
	--�����

	--����ҽ�����ϴ��ķ�����ϸend  
		 
	insert into #temp_fymx(mxxh,cfh,cfrq,xmmc,xmgg,xmdj,xmsl,xmdw,xmje,ybbm,ybscbz,sfxmdj,spbz,ybspbz,ybbzdj,ybzlje,qzfbz,zxlsh,cbbz,ybxybz)
	select b.xh,b.cfh,dbo.fun_convertrq_cqyb(1,b.cfrq),b.xmmc,b.xmgg,b.xmdj,b.xmsl,c.zxdw,b.xmje,
		c.dydm,b.ybscbz,ISNULL(c.ybfydj,'0'),b.spbz,b.ybspbz,isnull(b.ybbzdj,0),isnull(b.ybzlje,0),b.qzfbz,b.zxlsh,1,d.BZ
	from YY_CQYB_ZYJZJLK a(nolock) 
		inner join YY_CQYB_ZYFYMXK b(nolock) on a.syxh = b.syxh and b.jsxh = @jsxh and idm <> 0
		inner join YK_YPCDMLK c(nolock) on b.idm = c.idm
		LEFT JOIN YPML d(NOLOCK) ON c.dydm = d.YPLSH 
	where a.syxh = @syxh and a.jlzt = 1
	
	insert into #temp_fymx(mxxh,cfh,cfrq,xmmc,xmgg,xmdj,xmsl,xmdw,xmje,ybbm,ybscbz,sfxmdj,spbz,ybspbz,ybbzdj,ybzlje,qzfbz,zxlsh,cbbz,ybxybz)
	select b.xh,b.cfh,dbo.fun_convertrq_cqyb(1,b.cfrq),b.xmmc,'',b.xmdj,b.xmsl,b.xmdw,b.xmje,
		c.dydm,b.ybscbz,ISNULL(c.ybfydj,'0'),b.spbz,b.ybspbz,isnull(b.ybbzdj,0),isnull(b.ybzlje,0),b.qzfbz,b.zxlsh,0,d.BZ
	from YY_CQYB_ZYJZJLK a(nolock) 
		inner join YY_CQYB_ZYFYMXK b(nolock) on a.syxh = b.syxh and b.jsxh = @jsxh and idm = 0 
		inner join YY_SFXXMK c(nolock) on b.xmdm = c.id
		LEFT JOIN ZLXM d(NOLOCK) ON c.dydm = d.XMLSH 
	where a.syxh = @syxh and a.jlzt = 1
	 
	 update #temp_fymx set cbbz = 2 where sfxmdj in ('1','2') and ybzlje > 0 and cbbz = 1
	 --lj20200331������ybzzfbzΪ1ʱǰ̨��ʾ
	update  a set a.sfxmdj='3',a.qzfbz='1' from #temp_fymx a , ZY_BRFYMXK b(NOLOCK)
	 where b.xh = a.mxxh and b.ybzzfbz='1'and a.sfxmdj in('1','2')
		
	select a.mxxh as "�������",a.cfrq as "�շ�����",
		(CASE WHEN ISNULL(a.ybxybz,'') = '' THEN '' ELSE '��' END) + ' '+ xmmc as "ҩƷ����",
		xmgg as "ҩƷ���",a.xmdj as "ҩƷ����",a.xmsl as "ҩƷ����",
		xmdw as "ҩƷ��λ",a.xmje as "ҩƷ���",(case a.ybscbz when 1 then "���ϴ�" when 2 then "�����ϴ�" when 3 then "���ϴ�" else "δ�ϴ�" end) as "�ϴ���־",
		CASE @configCQ36 WHEN '1' THEN a.ybbm ELSE b.dydm end  AS  "ҽ������",
		CASE a.sfxmdj when '1' then "����" when '2' then "����" when '3' then "�Է�" else "" end as "���õȼ�",
		a.ybbzdj as "ҽ����׼����",a.ybzlje as "ҽ���Էѽ��",
		case when a.ybspbz in (1,2) then (case isnull(a.spbz,0) when 1 then "����ͨ��" when 2 then "������ͨ��" else "δ����" end) else "��������" end as "������־",
		case when isnull(a.qzfbz,0) = 1 then "ȫ�Է�" else "����" end as "ȫ�Էѱ�־",a.zxlsh as "������ˮ��",a.cbbz as "�����־",a.ybxybz AS "ҽ����ע"
 	from #temp_fymx a INNER JOIN ZY_BRFYMXK b(NOLOCK) ON b.xh = a.mxxh 
	ORDER by a.cfrq
end
else if @cxlb = 1	--������Ϣ
begin 

	SELECT @configCQ36 = ISNULL(config,'1') FROM YY_CONFIG(NOLOCK) WHERE id= 'CQ36'
    IF @configCQ36 = ''  SELECT @configCQ36 = '1'

	select 'False' as "ѡ��",a.xh as "�������",a.cfrq as "�շ�����",a.xmdm as "ҩƷ����",a.xmmc as "ҩƷ����",a.xmgg as "ҩƷ���",
		a.xmdj as "ҩƷ����",a.xmsl as "ҩƷ����",a.xmje as "ҩƷ���",
		(CASE @configCQ36 WHEN '2' THEN b.dydm 
		     ELSE  CASE b.idm WHEN 0 THEN (SELECT c.dydm FROM YY_SFXXMK c(NOLOCK) where c.id = b.ypdm) 
					    ELSE (SELECT e.dydm FROM YK_YPCDMLK e(NOLOCK) WHERE b.idm = e.idm ) 
				   END    
		END) "ҽ������",
		case isnull(a.spbz,0) when 1 then "����ͨ��" when 2 then "������ͨ��" else "δ����" end as "������־",
		case isnull(a.spclbz,0) when 1 then "���ϴ�" else "δ�ϴ�" end as "�ϴ���־" 
	from YY_CQYB_ZYFYMXK a(NOLOCK) INNER JOIN ZY_BRFYMXK b(NOLOCK) ON a.xh = b.xh
	where a.syxh = @syxh and a.jsxh = @jsxh and a.ybscbz = 1 and isnull(a.ybspbz,0) in (1,2) --and a.cfrq<=@zzrq+'24' --and isnull(spclbz,0) = 1
end
else if @cxlb = 2	--������Ϣ
begin 
	select lx as "����",mc as "����˵��",je as "���",case when lx in('yb09') and je>0 then '$0000FF' else '' end as "��ɫ"
	from ZY_BRJSJEK(NOLOCK) where jsxh = @jsxh 
end
else if @cxlb = 3		--������Ϣ
begin
	exec usp_cqyb_zyfymxcl @syxh,@jsxh,0,@errmsg out  
	if substring(@errmsg,1,1)='F'   
	begin  
		select 'F',@errmsg  
		return  
	end 	
	
	--����ҽ�����ϴ��ķ�����ϸbegin
    /*
	select * into #temp_fymxk from ZY_BRFYMXK(nolock)  where syxh = @syxh and jsxh = @jsxh
	--����
	update a set ybscbz = 0
	from YY_CQYB_ZYFYMXK a(nolock) inner join #temp_fymxk b(nolock) on a.xh = b.xh and b.scbz in (-1,0,3,4)
	where a.syxh = @syxh and a.jsxh = @jsxh and a.ybscbz <> 1 and a.ybscbz <> 0
	
	update a set ybscbz = 1,zxlsh = b.mxlsh
	from YY_CQYB_ZYFYMXK a(nolock) inner join #temp_fymxk b(nolock) on a.xh = b.xh and b.scbz = 1
	where a.syxh = @syxh and a.jsxh = @jsxh and a.ybscbz <> 1
	*/

	--�����汾�ӿ�,�ڴ�����������䣬���Ͻӿ��м������ȡ���ݸ��£������д���Ͻӿ����ϴ����ֱ�־������д��ȷ���������µǼǺ����ϴ���ϸ
	
	--����ҽ�����ϴ��ķ�����ϸend
	 
	insert into #temp_fymx(mxxh,cfh,cfrq,xmmc,xmje,ybscbz,zxlsh)
	select b.xh,b.cfh,dbo.fun_convertrq_cqyb(1,b.cfrq),b.xmmc,b.xmje,b.ybscbz,b.zxlsh
	from YY_CQYB_ZYJZJLK a(nolock) 
		inner join YY_CQYB_ZYFYMXK b(nolock) on a.syxh = b.syxh and b.jsxh = @jsxh  
	where a.syxh = @syxh and a.jlzt = 1-- and ybscbz=1
	
	select mxxh as "�������",cfh as "������",cfrq as "�շ�����",xmmc as "ҩƷ����",xmje as "ҩƷ���",
		(case ybscbz when 1 then "���ϴ�" when 2 then "�����ϴ�" when 3 then "���ϴ�" else "δ�ϴ�" end) as "�ϴ���־",
		zxlsh as "������ˮ��"
	from #temp_fymx order by cfrq
END
else if @cxlb = 4	--����������Ϣ
BEGIN
    select xmdm as "ҩƷ����",xmmc as "ҩƷ����",SUM(xmsl) as "ҩƷ����"
	from YY_CQYB_ZYFYMXK(NOLOCK)
	where syxh = @syxh and jsxh = @jsxh and ybscbz = 1 and isnull(ybspbz,0) in (1,2) --and cfrq<=@zzrq+'24'
	GROUP BY xmdm,xmmc
END
ELSE if @cxlb = 5		--�Զ���������Ŀ������Ϣ
begin
	exec usp_cqyb_zyfymxcl @syxh,@jsxh,0,@errmsg out  
	if substring(@errmsg,1,1)='F'   
	begin  
		select 'F',@errmsg  
		return  
	end 	
	
	select * into #temp_zdyspfymxk from ZY_BRFYMXK(nolock)  where syxh = @syxh and jsxh = @jsxh 
	
	insert into #temp_fymx(mxxh,cfh,cfrq,xmmc,xmgg,xmdj,xmsl,xmdw,xmje,ybbm,ybscbz,sfxmdj,spbz,ybspbz,ybbzdj,ybzlje,qzfbz,zxlsh,cbbz,ybxybz)
	select b.xh,b.cfh,dbo.fun_convertrq_cqyb(1,b.cfrq),b.xmmc,b.xmgg,b.xmdj,b.xmsl,c.zxdw,b.xmje,
		c.dydm,b.ybscbz,ISNULL(c.ybfydj,'0'),b.spbz,b.ybspbz,isnull(b.ybbzdj,0),isnull(b.ybzlje,0),b.qzfbz,b.zxlsh,1,c.memo
	from YY_CQYB_ZYJZJLK a(nolock) 
		inner join YY_CQYB_ZYFYMXK b(nolock) on a.syxh = b.syxh and b.jsxh = @jsxh and idm <> 0
		inner join YK_YPCDMLK c(nolock) on b.idm = c.idm
		LEFT JOIN YPML d(NOLOCK) ON c.dydm = d.YPLSH 
		inner join YY_CQYB_ZDYSPXM e(NOLOCK) on c.idm = e.xmdm AND e.xmlb = '0'
	where a.syxh = @syxh and a.jlzt = 1 
	
	insert into #temp_fymx(mxxh,cfh,cfrq,xmmc,xmgg,xmdj,xmsl,xmdw,xmje,ybbm,ybscbz,sfxmdj,spbz,ybspbz,ybbzdj,ybzlje,qzfbz,zxlsh,cbbz,ybxybz)
	select b.xh,b.cfh,dbo.fun_convertrq_cqyb(1,b.cfrq),b.xmmc,'',b.xmdj,b.xmsl,b.xmdw,b.xmje,
		c.dydm,b.ybscbz,ISNULL(c.ybfydj,'0'),b.spbz,b.ybspbz,isnull(b.ybbzdj,0),isnull(b.ybzlje,0),b.qzfbz,b.zxlsh,0,c.memo
	from YY_CQYB_ZYJZJLK a(nolock) 
		inner join YY_CQYB_ZYFYMXK b(nolock) on a.syxh = b.syxh and b.jsxh = @jsxh and idm = 0 
		inner join YY_SFXXMK c(nolock) on b.xmdm = c.id
		inner join YY_CQYB_ZDYSPXM e(NOLOCK) on c.id = e.xmdm AND e.xmlb = '1'
	where a.syxh = @syxh and a.jlzt = 1 
	 
	update #temp_fymx set cbbz = 2 where sfxmdj in ('1','2') and ybzlje > 0 and cbbz = 1 

	select 'False' as "ѡ��",a.mxxh as "�������",a.cfrq as "�շ�����",a.xmmc as "ҩƷ����",a.xmgg as "ҩƷ���",a.xmdj as "ҩƷ����",a.xmsl as "ҩƷ����",
		a.xmdw as "ҩƷ��λ",a.xmje as "ҩƷ���",(case a.ybscbz when 1 then "���ϴ�" when 2 then "�����ϴ�" when 3 then "���ϴ�" else "δ�ϴ�" end) as "�ϴ���־",
		CASE @configCQ36 WHEN '1' THEN a.ybbm ELSE c.dydm end  AS  "ҽ������",
		CASE a.sfxmdj when '1' then "����" when '2' then "����" when '3' then "�Է�" else "" end as "���õȼ�",
		a.ybbzdj as "ҽ����׼����",a.ybzlje as "ҽ���Էѽ��",
		--case when ybspbz in (1,2) then (case isnull(spbz,0) when 1 then "����ͨ��" when 2 then "������ͨ��" else "δ����" end) else "��������" end as "������־",
		CASE b.spjg WHEN  '1' THEN '����ͨ��' WHEN '2' THEN '������ͨ��' ELSE 'δ����' END as "������־",
        -- b.spyy "Ժ������ԭ��"
		case when isnull(a.qzfbz,0) = 1 then "ȫ�Է�" else "����" end as "ȫ�Էѱ�־",a.zxlsh as "������ˮ��",a.cbbz as "�����־",a.ybxybz "����˵��"
 	from #temp_fymx a LEFT JOIN YY_CQYB_ZDYSPFYMX b(NOLOCK) ON mxxh = b.xh
	                INNER JOIN ZY_BRFYMXK c(NOLOCK) ON c.xh = a.mxxh 
	order by a.cfrq
end
ELSE if @cxlb = 6		--�Զ���������Ŀ���û�����Ϣ
BEGIN
	SELECT b.xmdm as "ҩƷ����",b.xmmc as "ҩƷ����",SUM(b.xmsl) as "ҩƷ����"
	from  YY_CQYB_ZYFYMXK b(nolock) inner join YK_YPCDMLK c(nolock) on b.idm = c.idm and b.idm <> 0
	INNER JOIN  YY_CQYB_ZDYSPXM d(NOLOCK) ON b.idm = d.xmdm AND d.xmlb = 0
	where b.syxh = @syxh and b.jsxh = @jsxh
	GROUP BY b.xmdm,b.xmmc
	UNION ALL
	select b.xmdm as "ҩƷ����",b.xmmc as "ҩƷ����",SUM(b.xmsl) as "ҩƷ����"
	FROM YY_CQYB_ZYFYMXK b(nolock) inner join YY_SFXXMK c(nolock) on b.xmdm = c.id and b.idm = 0
	INNER JOIN YY_CQYB_ZDYSPXM d(NOLOCK) ON b.xmdm = d.xmdm AND d.xmlb = 1 
	where b.syxh = @syxh and b.jsxh = @jsxh
	GROUP BY b.xmdm,b.xmmc 		
END

return


