ALTER procedure usp_yk_cx_lskccx
    @kslb ut_bz,     
    @ksdm ut_ksdm,     
    @rq ut_rq16,                   
    @yplb int = 0,    
    @jxdm ut_jxdm,               
    @tsbz ut_bz,
    @zmlb int = 0,
    @pdmbxh int =0,
    @cfwz  ut_mc64 ='-1'   
as --��268341 2017-09-23 19:50:37 4.0��׼��
/**********    
[�汾��]4.0.0.0.0    
[����ʱ��]2004.12.30
[����]½Խ��    
[��Ȩ] Copyright ? 2004-2008�Ϻ����˴�-��������ɷ����޹�˾
[����] ҩ��ϵͳ--��ʷ����ѯ    
[����˵��]    
  ҩ��ϵͳ--��ʷ����ѯ    
[����˵��]    
    @kslb        �������0--ҩ�⣬1--ҩ��    
    @ksdm        ���Ҵ���    
    @rq          ��Ҫ��ѯ������    
    @yplb int = 0 ҩƷ��־��0ȫ����1��ҩ��2�г�ҩ��3�в�ҩ    
    @jxdm        ���ʹ��룬YK_YPJXK.id ,����Һ���ȡ�     
    @tsbz        �����־��YK_TSBZK.id ,1����,2����,3�綾,4Σ��,5����,6�ȵ���,9������  
    @zmlb int = 0 ��Ŀ���00--ȫ�� 01--��ҩ 02--�г�ҩ 03--��ҩ 04--�Ƽ�	05--ҩƷ���� 06--��ҩʪ��
    @pdmbxh int =0 �̵�ģ����ţ�0û���̵�ģ��	  
[����ֵ]    
[�����������]    
[���õ�sp]    
[����ʵ��]    
	usp_yk_cx_lskccx 0, "4002", "2006022400:00:00","0","-1",-1,"00"--��Clientdataset��
	usp_yk_cx_lskccx 1, "4004", "2006022400:00:00","0","-1",-1,"00"--��Clientdataset��
[�޸ļ�¼]    
    2003-10-14 wfy ������һ�����������ҩƷ�����������Ӻϼ�    
    2003-11-05 szj ����������������������ʹ��룬�����־��
    2003-12-10 panlian ����һ�������������Ŀ���
    2004-01-07 panlian �޸�������ҩƷ����ܹ����BUG 
    2005-06-10 wangkun �޸�ҩ������ҩ����λ
	2007-7-11 yxp ͳ�ƺϼ�ʱ��������
    2010-06-09 xwm 1 ���Ӱ��̵�ģ���ѯ�Ĺ���
                   2 ���ڿ�������̫�࣬ԭ���Ĳ�ѯд��if else ̫�ർ�´洢����̫���ʸ�дΪ������ѯ��䷽ʽ�Լ������
    2012-3-29 grj ҩ�����Ӹ���3180������ѯ���� 
    2015-02-28 rxy for:13986 �Ƿ���ʾ���ۡ����۽��ͽ������                     
**********/    
set nocount on    

declare @ny char(6)  
declare @config4160 varchar(2) ,@config3194 varchar(2) 
select @config4160=config from YY_CONFIG where id='4160'
select @config3194=config from YY_CONFIG where id='3194'
	
declare @config4226 varchar(2),@config3280 varchar(2) 
select @config4226=config from YY_CONFIG where id='4226'
select @config3280=config from YY_CONFIG where id='3280'

declare @mzorzy ut_bz --0 ���� ,1 סԺ
select  @mzorzy = xtbz from YF_YFDMK (nolock) where id=@ksdm


create table #YK_CX_LSKCCX  
    (    
        cd_idm ut_xh9,     
        ypsl ut_sl14,     
        lsje ut_je14,     
        pfje ut_je14,
        jqpjjj ut_money,	--��Ȩƽ������
        jqpjjj_je ut_je14, --add by grj 2012-3-29  ��Ȩƽ�����۽��
        jjje ut_je14,	--add by grj 2012-3-29  ��Ȩƽ�����۽��	
        pdmbmxxh ut_xh12 null
        
    )    

create table #YF_CX_LSKCCX    
    (    
        cd_idm ut_xh9,     
        ypsl ut_sl14,     
        lsje ut_je14,
        pfje ut_je14,
        jqpjjj ut_money,--��Ȩƽ������
        jqpjjj_je ut_je14, --add by grj 2012-3-29  ��Ȩƽ�����۽��
        jjje ut_je14,	--add by grj 2012-3-29  ��Ȩƽ�����۽��
        pdmbmxxh ut_xh12 null    
    )  

declare @strOrderBy varchar(1000)
declare @strSQL1 varchar(4000),@strSQL2 varchar(4000),@strSQL varchar(8000),@strWhere varchar(2000)

select @strSQL1='',@strSQL2='',@strSQL='',@strWhere=''

if @pdmbxh=0 
    select @strOrderBy=' order by ҩƷ���� '
else
begin
   select @strOrderBy=' order by �̵�ģ����ϸ��� '	
end

--add by grj 2012-3-29 
--=============================begin================
--declare @3180 char(1)
--select @3180 = '0' 
--select @3180 = config from YY_CONFIG where id = "3180"
declare @ypxtslt int  
select @ypxtslt=dbo.f_get_ypxtslt()    
if @@error<>0  
begin  
  select "F","��ȡҩƷϵͳģʽ����"  
  return  
end  
--=============================end==================

if @kslb=0 --ҩ��
begin
	select @ny = ny from YK_TJQSZ (nolock) where ykdm = @ksdm and @rq between ksrq and jsrq    
		if @@rowcount = 0    
			select @ny = max(ny) from YK_TJQSZ (nolock) where ykdm = @ksdm 

		if @pdmbxh = 0 
        begin
			insert into #YK_CX_LSKCCX
            select cd_idm, ypsl, lsje, pfje,
            jqpjjj,jqpjjj_je,lsje-jxje,--add by grj 2012-3-29
            0
            from YK_YPTZK (nolock)    
			where ny = @ny and ksdm = @ksdm and lb = 1    
        end
        else  --���̵�ģ�� 
        begin
   insert into #YK_CX_LSKCCX(cd_idm,ypsl,lsje,pfje,
				jqpjjj,jqpjjj_je,jjje,--add by grj 2012-3-29
				pdmbmxxh) 
            select a.cd_idm, a.ypsl, a.lsje, a.pfje,
				jqpjjj,a.jqpjjj_je,a.lsje-a.jxje,--add by grj 2012-3-29
				m.xh 
            from YK_YPTZK a (nolock) inner join YF_PDMBMXK m (nolock) on a.cd_idm=m.idm
               left join YK_YKZKC z (nolock) on  a.cd_idm = z.cd_idm and z.ksdm=@ksdm
            where a.ny = @ny and a.ksdm = @ksdm and a.lb = 1 and m.mbxh=@pdmbxh
             				
       end

		update #YK_CX_LSKCCX set ypsl = isnull(a.ypsl,0) + isnull(b.ypsl,0), lsje = isnull(a.lsje,0) + isnull(b.lsje,0),     
			pfje = isnull(a.pfje,0) + isnull(b.pfje,0),    
			jqpjjj_je = ISNULL(a.jqpjjj_je, 0) + ISNULL(b.jqpjjj_je, 0),--add by grj 2012-3-29
			jjje = isnull(a.jjje, 0) + isnull(b.jjje, 0)--add by grj 2012-3-29
			from #YK_CX_LSKCCX a, (select cd_idm, ksdm,     
        			sum(rksl - cksl) ypsl, sum(rkje_ls - ckje_ls) lsje, sum(rkje_pf - ckje_pf) pfje,
        			SUM(rkje_jqpjjj - ckje_jqpjjj) jqpjjj_je, SUM(rkje_ls -ckje_ls - jxce) jjje--add by grj 2012-3-29    
 				from YK_YPTZMXK (nolock)    
 				where ksdm = @ksdm and ny = @ny and czrq <= @rq group by cd_idm, ksdm) b    
		 where a.cd_idm = b.cd_idm

	--��ϲ�ѯ���
     --select @strSQL1 = ' select b.ypdm "ҩƷ����", b.py "ƴ��", b.wb "���", b.ypmc + "[" + b.ypgg + "]" "ҩƷ����", b.cjmc "��������",'     
    select @strSQL1 = ' select b.ypdm "ҩƷ����", b.py "ƴ��", b.wb "���", b.ypmc "ҩƷ����", b.ypgg ҩƷ���, b.cjmc "��������",c.name "ҩƷ���",'     
   			         + '        b.ykdw "ҩ�ⵥλ", convert(numeric(14, 2), a.ypsl/b.ykxs) "�������",'     
   			         + '        b.ylsj "���ۼ�", convert(money, a.lsje) "���۽��"'
   	select @strSQL2 = ' select "" "ҩƷ����", "" "ƴ��", "" "���", "�ϼ�" "ҩƷ����","" "ҩƷ���", "" "��������","" "ҩƷ���",'     
			         + '        "" "ҩ�ⵥλ", convert(numeric(14, 2), sum(a.ypsl/b.ykxs)) "�������",'     
			         + '        0 "���ۼ�", convert(money, sum(a.lsje)) "���۽��"'		         
	if @config4160='��'  
	begin 			         
   		select @strSQL1 = @strSQL1 + ', b.ypfj "������", convert(money, a.pfje) "�������"'
   		--delete by grj 2012-3-29-- +'  ,b.mrjj "����", convert(money,b.mrjj*a.ypsl/b.ykxs) "���۽��"'
		select @strSQL2 = @strSQL2 + ', 0 "������",convert(money, sum(a.pfje)) "�������"'
			        --delete by grj 2012-3-29-- +' ,0 "����",convert(money, sum(b.mrjj*a.ypsl/b.ykxs)) "���۽��"'   		
	end   			        

			        
	 --add by grj 2012-3-29 
	 --=============================begin================
	if @config4226='��'
	begin
		if @ypxtslt = 0--ʹ�ý�����������۽��
		begin
			select @strSQL1 = @strSQL1 + ' ,b.mrjj "����", convert(money,b.mrjj*a.ypsl/b.ykxs) "���۽��"' 
			select @strSQL2 = @strSQL2 + ' ,0 "����",convert(money, sum(b.mrjj*a.ypsl/b.ykxs)) "���۽��"' 
		end
		else if @ypxtslt = 1--ʹ��ƽ������������۽��
		begin
			select @strSQL1 = @strSQL1 + ' ,a.jqpjjj "����", a.jqpjjj_je "���۽��"' 
			select @strSQL2 = @strSQL2 + ' ,0 "����", sum(a.jqpjjj_je) "���۽��"'
		end
		else if @ypxtslt >= 2--ʹ��ҩ�����ι���
		begin
			select @strSQL1 = @strSQL1 + ' ,case a.ypsl when 0 then 0 else convert(numeric(14, 4), a.jjje/a.ypsl*b.ykxs) end "����", a.jjje "���۽��"' 
			select @strSQL2 = @strSQL2 + ' ,0 "����",sum(a.jjje) "���۽��"'
		end		
	end        
	--=============================end==================		        

     if @pdmbxh=0--����ģ�巽ʽ
     begin
         select @strSQL1 = @strSQL1 + ',0 "�̵�ģ����ϸ���" '                  
     end else
     begin
         select @strSQL1 = @strSQL1 + ',a.pdmbmxxh "�̵�ģ����ϸ���" '                    
     end

     select @strSQL2 = @strSQL2 + ',0 "�̵�ģ����ϸ���" '
     
     select @strSQL1 = @strSQL1 + ',d.name as "ҩƷ����",b.pzwh as "��׼�ĺ�",e.name as "ҩƷ����" '
     select @strSQL2 = @strSQL2 + ',"" as "ҩƷ����","" as "��׼�ĺ�","" as "ҩƷ����" '
          
     select @strWhere = ' from #YK_CX_LSKCCX a inner join YK_YPCDMLK b (nolock) on a.cd_idm=b.idm '
                      + ' inner join  YY_SFDXMK c (nolock) on b.yplh=c.id '  
                      + ' left join YK_YPJXK d(nolock) on b.jxdm=d.id '
                      + ' left join YK_YPFLK e(nolock) on b.fldm=e.id'
                      + ' where 1=1 '
     
     if @yplb <>0 --����ҩƷ���
        select @strWhere = @strWhere  + ' and b.yplh=' + convert(varchar(12),@yplb)     
     
     select @strWhere = @strWhere       
                     + '    and (' + convert(varchar(12),@zmlb) + '= 0 or b.zmlb =' + convert(varchar(12),@zmlb) + ')'    
                     + '    and ("' + @jxdm + '" = "-1" or b.jxdm ="' + @jxdm + '")' -- szj 2003-11-05 '    
	                  --yxp and (@tsbz = '-1' or d.tsbz =@tsbz) -- szj 2003-11-05    
	                 + '    and ("' + convert(varchar(12),@tsbz) + '" = "-1" or b.tsbz ="' + convert(varchar(12),@tsbz) + '")' -- szj 2003-11-05'
     
     select @strSQL1 = @strSQL1 + @strWhere   

     select @strSQL2 = @strSQL2 + @strWhere
     
     select @strSQL=@strSQL1 + ' union '+ @strSQL2 + @strOrderBy

     Exec(@strSQL)
     
     return 		
end
if @kslb=1 --ҩ��
begin
	select @ny = ny from YF_TJQSZ (nolock) where yfdm = @ksdm and @rq between ksrq and jsrq    
		if @@rowcount = 0    
			select @ny = max(ny) from YF_TJQSZ (nolock) where yfdm = @ksdm  
	  
    if @pdmbxh=0
    begin
		insert into #YF_CX_LSKCCX
        select cd_idm, ypsl, lsje, pfje,
        jqpjjj,jqpjjj_je,jjje,--add by grj 2012-3-29
        0 
        from YF_YPTZK (nolock)    
		where ny = @ny and ksdm = @ksdm and lb = 1    
    end 
    else begin --���̵�ģ��
        insert into #YF_CX_LSKCCX(cd_idm,ypsl,lsje,pfje,
			jqpjjj,jqpjjj_je,jjje,--add by grj 2012-3-29
			pdmbmxxh) 
            select a.cd_idm, a.ypsl, a.lsje, a.pfje,
            a.jqpjjj,a.jqpjjj_je,a.jjje,--add by grj 2012-3-29
            m.xh 
            from YF_YPTZK a (nolock) inner join  YF_PDMBMXK m (nolock) on a.cd_idm=m.idm 
                 left join  YF_YFZKC z (nolock) on a.cd_idm = z.cd_idm and z.ksdm=@ksdm 
            where a.ny = @ny and a.ksdm = @ksdm and a.lb = 1
              and m.mbxh=@pdmbxh             			
    end

	update #YF_CX_LSKCCX set ypsl = isnull(a.ypsl,0) + isnull(b.ypsl,0), lsje = isnull(a.lsje,0) + isnull(b.lsje,0), 
				pfje = isnull(a.pfje,0) + isnull(b.pfje,0),
				jqpjjj_je = ISNULL(a.jqpjjj_je, 0) + ISNULL(b.jqpjjj_je, 0),--add by grj 2012-3-29
				jjje = isnull(a.jjje, 0) + isnull(b.jjje, 0)--add by grj 2012-3-29    
			from #YF_CX_LSKCCX a,     
				(select cd_idm, ksdm, sum(rksl - cksl) ypsl, sum(rkje_ls - ckje_ls) lsje, sum(rkje_pf - ckje_pf) pfje, 
        		SUM(rkje_jqpjjj - ckje_jqpjjj) jqpjjj_je, SUM(rkje_jj -ckje_jj) jjje--add by grj 2012-3-29    
	 			from YF_YPTZMXK (nolock) where ksdm = @ksdm and ny = @ny and czrq <= @rq group by cd_idm, ksdm) b    
		where a.cd_idm = b.cd_idm  

    select @strSQL1 = 'select b.ypdm "ҩƷ����", b.py "ƴ��", b.wb "���",'     
       				+ '       b.ypmc + "[" + b.ypgg + "]" "ҩƷ����",b.ypgg "ҩƷ���", b.cjmc "��������", c.name "ҩƷ���" , '

    select @strSQL2 = 'select "" "ҩƷ����", "" "ƴ��","" "���", "�ϼ�"  "ҩƷ����","" "ҩƷ���", "" "��������",  ""  "ҩƷ���", '
    
    --modity by grj 2012-3-29 ������ϵͳ, סԺϵͳ��ȡ����, ��Ϊ�������SQL
	 --=============================begin================
	declare @sql_xs varchar(10) 
	if @mzorzy=0 --����ҩ�� ȡ�ĵ�λ��ϵ����ͬ
		select @sql_xs = 'b.mzxs'
	else 
		select @sql_xs = 'b.zyxs'
	 
    --if @mzorzy=0 --����ҩ�� ȡ�ĵ�λ��ϵ����ͬ
    --begin
        select @strSQL1 = @strSQL1 + ' b.mzdw "ҩ����λ", convert(numeric(14, 2), a.ypsl/' + @sql_xs + ') "�������",'
        select @strSQL2 = @strSQL2 + ' "" "ҩ����λ", convert(numeric(14, 2), sum(a.ypsl/' + @sql_xs + ')) "�������", '
    /*    
    end else --סԺҩ��
    begin
        select @strSQL1 = @strSQL1 + ' b.zydw "ҩ����λ", convert(numeric(14, 2), a.ypsl/b.zyxs) "�������",'
        select @strSQL2 = @strSQL2 + ' "" "ҩ����λ", convert(numeric(14, 2), sum(a.ypsl/b.zyxs)) "�������",'
    end
	*/
	--=============================end==================
	
    select @strSQL1 = @strSQL1 + ' convert(numeric(14, 4),b.ylsj/b.ykxs*' + @sql_xs + ') "���ۼ�", convert(money, a.lsje) "���۽��"'
     
    select @strSQL2 = @strSQL2 + ' 0 "���ۼ�", convert(money, sum(a.lsje)) "���۽��" '
	if @config3194='��'
	begin
		select @strSQL1 = @strSQL1 + ', convert(numeric(14, 4),b.ypfj/b.ykxs*' + @sql_xs + ') "������", convert(money, a.pfje) "�������"' 
		select @strSQL2 = @strSQL2 + ', 0 "������", convert(money, sum(a.pfje)) "�������"' 
	end
    --add by grj 2012-3-29 
	--=============================begin================
	if @config3280='��'
	begin	
		if @ypxtslt = 0--ʹ�ý�����������۽��
		begin
			select @strSQL1 = @strSQL1 + ' ,convert(numeric(14, 4),b.mrjj/b.ykxs*' + @sql_xs + ') "����",convert(money,b.mrjj*a.ypsl/b.ykxs) "���۽��"' 
			select @strSQL2 = @strSQL2 + ' ,0 "����",convert(money, sum(b.mrjj*a.ypsl/b.ykxs)) "���۽��"' 
		end
		else if @ypxtslt = 1--ʹ��ƽ������������۽��
		begin
			select @strSQL1 = @strSQL1 + ' ,convert(numeric(14, 4),a.jqpjjj/b.ykxs*' + @sql_xs + ') "����", a.jqpjjj_je "���۽��"' 
			select @strSQL2 = @strSQL2 + ' ,0 "����", sum(a.jqpjjj_je) "���۽��"'
		end
		else if @ypxtslt >= 2--ʹ��ҩ�����ι���
		begin
			select @strSQL1 = @strSQL1 + ' ,case a.ypsl when 0 then 0 else convert(numeric(14, 4), a.jjje/a.ypsl*' + @sql_xs + ') end "����", a.jjje "���۽��"' 
			select @strSQL2 = @strSQL2 + ' ,0 "����",sum(a.jjje) "���۽��"'
		end		    
	end    
	--=============================end==================

    if @pdmbxh=0--����ģ�巽ʽ
     begin
         select @strSQL1 = @strSQL1 + ',0 "�̵�ģ����ϸ���" '                  
     end else
     begin
         select @strSQL1 = @strSQL1 + ',a.pdmbmxxh "�̵�ģ����ϸ���" '                    
     end

     select @strSQL2 = @strSQL2 + ',0 "�̵�ģ����ϸ���" '
 					  
     select @strSQL1 = @strSQL1 + ',d.name as "ҩƷ����",b.pzwh as "��׼�ĺ�",e.name as "ҩƷ����" '
     select @strSQL2 = @strSQL2 + ',"" as "ҩƷ����","" as "��׼�ĺ�","" as "ҩƷ����" '
     
      select @strSQL1 = @strSQL1 + ',isnull(f.cfwz,"") "���λ��" '
     select @strSQL2 = @strSQL2 + ',"" "���λ��"'
          
     select @strWhere = ' from #YF_CX_LSKCCX a inner join YK_YPCDMLK b (nolock) on a.cd_idm=b.idm '
                      + ' inner join  YY_SFDXMK c (nolock) on b.yplh=c.id '  
                      + ' left join YK_YPJXK d(nolock) on b.jxdm=d.id '
                      + ' left join YK_YPFLK e(nolock) on b.fldm=e.id'
                      + ' left join (select *from YF_YFZKC g(nolock) where  g.ksdm ="'+@ksdm+'" ) f on  a.cd_idm=f.cd_idm '
                      + ' where 1=1 '
                       
    if @yplb <>0 --����ҩƷ���
         select @strWhere = @strWhere  + ' and b.yplh=' + convert(varchar(12),@yplb)

     select @strWhere = @strWhere
					  + '   and (' + convert(varchar(12),@zmlb) + '= 0 or b.zmlb ='+ convert(varchar(12),@zmlb) + ')'    
        			  + '   and ("' + @jxdm + '" = "-1" or b.jxdm ="' + @jxdm + '")'     
        				    
				      + '   and ("' + convert(varchar(12),@tsbz) + '" = "-1" or b.tsbz ="' + convert(varchar(12),@tsbz) + '")' -- szj 2003-11-05    
     
     select @strWhere = @strWhere
                      + '   and ("' + @cfwz + '" = "-1" or charindex("'+@cfwz+'",f.cfwz)>0 )'   
     select @strSQL1 = @strSQL1 + @strWhere
     select @strSQL2 = @strSQL2 + @strWhere

     --�ϰ벿�� + union + �°벿�� + ��������
	 select @strSQL=@strSQL1  + ' union '+ @strSQL2 + @strOrderBy
             
	 Exec(@strSQL)
     
     return             
end





