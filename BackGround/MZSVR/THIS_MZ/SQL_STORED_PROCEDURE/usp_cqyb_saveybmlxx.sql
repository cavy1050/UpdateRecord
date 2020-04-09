if exists(select 1 from sysobjects where name = 'usp_cqyb_saveybmlxx')
  drop proc usp_cqyb_saveybmlxx
go
CREATE proc usp_cqyb_saveybmlxx
@lb ut_bz,
@strs varchar(8000)
as
/****************************************
[版本号]4.0.0.0.0
[创建时间]2018.05.21
[作者]bdd
[版权]Copyright ? 1998-2018卫宁健康科技集团股份有限公司
[描述]保存医保三大目录信息
[功能说明]
	保存医保三大目录信息
[参数说明]
@lb:1药品;2项目;3诊断
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]
[修改记录]
****************************************/
declare @temp_key varchar(8000),@seq varchar(2)
select  @seq='|'
if @lb='1'
begin
	select @temp_key=dbo.fun_cqyb_getvalbyseq(@strs,@seq,1)
    delete from YPML where YPLSH=@temp_key
	insert into YPML(YPLSH, YPBM, TYM, TYMZJM, SPM, SPMZJM, YWM, LBDM, CFYBZ, YLFYDJ, GSFYDJ, SYFYDJ, PFJ, YLBZDJ, GSBZDJ, SYBZDJ, YLZFBL, GSZFBL, SYZFBL, JX, BZSL, BZDW, HL, HLDW, RL, RLDW, GMP, YCMC, YPXJFS, BGSJ, TQFYDJ, TQZFBL, TQBZDJ, CJFYDJ, CJZFBL, YJYYCRZFBL, EJYYCRZFBL, SJYYCRZFBL, YJYYETZFBL, EJYYETZFBL, SJYYETZFBL, YJYYDXSZFBL, EJYYDXSZFBL, SJYYDXSZFBL, CJBZDJ, WSSSYBZ, XETSYBZ, XMZSYBZ, JCYBZ, ZZSJBZ, ZZSJSBJG, BZ, GSFZQJBJ, GSKFXMBJ, GSFPGXXMBJ)
   VALUES  (dbo.fun_cqyb_getvalbyseq(@strs,@seq,1), -- YPLSH - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,2), -- YPBM - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,3), -- TYM - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,4), -- TYMZJM - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,5), -- SPM - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,6), -- SPMZJM - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,7), -- YWM - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,8), -- LBDM - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,9), -- CFYBZ - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,10), -- YLFYDJ - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,11), -- GSFYDJ - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,12), -- SYFYDJ - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,13), -- PFJ - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,14), -- YLBZDJ - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,15), -- GSBZDJ - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,16), -- SYBZDJ - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,17), -- YLZFBL - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,18), -- GSZFBL - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,19), -- SYZFBL - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,20), -- JX - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,21), -- BZSL - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,22), -- BZDW - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,23), -- HL - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,24), -- HLDW - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,25), -- RL - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,26), -- RLDW - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,27), -- GMP - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,28), -- YCMC - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,29), -- YPXJFS - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,30), -- BGSJ - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,31), -- TQFYDJ - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,32), -- TQZFBL - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,33), -- TQBZDJ - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,34), -- CJFYDJ - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,35), -- CJZFBL - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,36), -- YJYYCRZFBL - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,37), -- EJYYCRZFBL - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,38), -- SJYYCRZFBL - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,39), -- YJYYETZFBL - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,40), -- EJYYETZFBL - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,41), -- SJYYETZFBL - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,42), -- YJYYDXSZFBL - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,43), -- EJYYDXSZFBL - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,44), -- SJYYDXSZFBL - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,45), -- CJBZDJ - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,46), -- CWSSSYBZ - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,47), -- XETSYBZ - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,48), -- XMZSYBZ - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,49), -- JCYBZ - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,50), -- ZZSJBZ - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,51), -- ZZSJSBYLJG - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,52), -- BZ - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,53), -- GSFZQJBZ - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,54), -- GSKFXMBZ - 
            dbo.fun_cqyb_getvalbyseq(@strs,@seq,55)  -- GSFPGXXMBZ - 
            )
    if @@ROWCOUNT>0
     select 'T'  
    else
     select 'F' ,@temp_key   
    return  
end
if @lb='2'
begin
	select @temp_key=dbo.fun_cqyb_getvalbyseq(@strs,@seq,1)
    delete from ZLXM where XMLSH=@temp_key
    insert into ZLXM (LBDM1, LBDM2, LBDM3, LBDM4, XMLSH, XMBM, XMMC, ZJM, TPJ, YLBZJ, GSBZJ, SYBZJ, DW, YLFYDJ, GSFYDJ, SYFYDJ, YLZFBL, GSZFBL, SYZFBL, TXBL, XJFS, LSF, BZ, BGSJ, TPXMBZ, TQFYDJ, TQZFBL, TQBZDJ, CJFYDJ, CJZFBL, YJYYCRZFBL, EJYYCRZFBL, SJYYCRZFBL, YJYYETZFBL, EJYYETZFBL, SJYYETZFBL, YJYYDXSZFBL, EJYYDXSZFBL, SJYYDXSZFBL, CJBZDJ, TSYTBJ, XMNH, CWNR, GSFZQJBJ, GSKFXMBJ, GSFPGXXMBJ, GSKTFBJ, NHYCXHC, JJSM, ZGCFJL, ZGCFYL15, ZGCFYL20, ZGCFCB, ZGCFZF, JMCFJL, JMCFYL15, JMCFYL20, JMCFCB, JMCFZF, GSCFJL, GSCFCB, GSCFZF, SYCFJL, SYCFYL15, SYCFYL20, SYCFCB, SYCFZF, TQCFJL, TQCFYL15, TQCFYL20, TQCFCB, TQCFZF, ZZSJ, JBSJ, ZGDEBXBZ, JMDEBXBZ, YLGGXMBJ)
    VALUES  ('', -- LBDM1 - varchar(3)
             '', -- LBDM2 - varchar(3)
             '', -- LBDM3 - varchar(4)
             '', -- LBDM4 - varchar(6)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,1), -- XMLSH - varchar(14)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,2), -- XMBM - varchar(20)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,3), -- XMMC - varchar(400)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,4), -- ZJM - varchar(14)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,5), -- TPJ - varchar(14)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,6), -- YLBZDJ - varchar(14)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,7), -- GSBZDJ - varchar(14)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,8), -- SYBZDJ - varchar(14)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,9), -- DW - varchar(40)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,10), -- YLFYDJ - varchar(3)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,11), -- GSFYDJ - varchar(3)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,12), -- SYFYDJ - varchar(3)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,13), -- YLZFBL - varchar(10)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,14), -- GSZFBL - varchar(10)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,15), -- SYZFBL - varchar(10)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,16), -- TXZFBL - varchar(10)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,17), -- XJFS - varchar(3)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,18), -- LSF - varchar(50)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,19), -- BZ - varchar(500)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,20), -- BGSJ - datetime
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,21), -- TPXMBZ - varchar(3)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,22), -- TQFYDJ - varchar(3)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,23), -- TQZFBL - varchar(10)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,24), -- TQBZDJ - varchar(10)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,25), -- CJFYDJ - varchar(3)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,26), -- CJZFBL - varchar(10)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,27), -- YJYYCRZFBL - varchar(30)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,28), -- EJYYCRZFBL - varchar(30)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,29), -- SJYYCRZFBL - varchar(30)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,30), -- YJYYETZFBL - varchar(30)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,31), -- EJYYETZFBL - varchar(30)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,32), -- SJYYETZFBL - varchar(30)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,33), -- YJYYDXSZFBL - varchar(30)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,34), -- EJYYDXSZFBL - varchar(30)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,35), -- SJYYDXSZFBL - varchar(30)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,36), -- CJBZDJ - varchar(30)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,37), -- TSYTBJ - varchar(30)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,38), -- XMNH - varchar(500)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,39), -- CWNR - varchar(500)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,40), -- GSFZQJBZ - varchar(30)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,41), -- GSKFXMBZ - varchar(30)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,42), -- GSFPGXXMBZ - varchar(30)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,43), -- GSKDFBZ - varchar(30)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,44), -- NHYCXHC - varchar(500)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,45), -- JJSM - varchar(500)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,46), -- ZGCFJL - nvarchar(50)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,47), -- ZGCFYL15 - nvarchar(50)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,48), -- ZGCFYL20 - nvarchar(50)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,49), -- ZGCFCB - nvarchar(50)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,50), -- ZGCFZF - nvarchar(50)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,51), -- JMCFJL - nvarchar(50)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,52), -- JMCFYL15 - nvarchar(50)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,53), -- JMCFYL20 - nvarchar(50)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,54), -- JMCFCB - nvarchar(50)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,55), -- JMCFZF - nvarchar(50)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,56), -- GSCFJL - nvarchar(50)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,57), -- GSCFCB - nvarchar(50)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,58), -- GSCFZF - nvarchar(50)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,59), -- SYCFJL - nvarchar(50)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,60), -- SYCFYL15 - nvarchar(50)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,61), -- SYCFYL20 - nvarchar(50)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,62), -- SYCFCB - nvarchar(50)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,63), -- SYCFZF - nvarchar(50)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,64), -- TQCFJL - nvarchar(50)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,65), -- TQCFYL15 - nvarchar(50)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,66), -- TQCFYL20 - nvarchar(50)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,67), -- TQCFCB - nvarchar(50)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,68), -- TQCFZF - nvarchar(50)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,69), -- ZZSJ - varchar(20)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,70), -- JBSJ - varchar(20)
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,71), -- ZGDEBXBZ - numeric
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,72), -- JMDEBXBZ - numeric
             dbo.fun_cqyb_getvalbyseq(@strs,@seq,73)  -- YLGGXMBJ - varchar(3)
             )
	if @@ROWCOUNT>0
	 select 'T'  
	else
	 select 'F' ,@temp_key 
	return    
end
if @lb='3'
begin
	select @temp_key=dbo.fun_cqyb_getvalbyseq(@strs,@seq,1)
    delete from YY_CQYB_ZDDMK where id=@temp_key
	insert into YY_CQYB_ZDDMK (id, name, py, wb, bzfl, jmbzfl, sybzfl, tjm, bgsj)
	VALUES  (dbo.fun_cqyb_getvalbyseq(@strs,@seq,1), -- id - varchar(20)
				 dbo.fun_cqyb_getvalbyseq(@strs,@seq,2), -- name - varchar(80)
				 '', -- py - varchar(20)
				 '', -- wb - varchar(20)
				 dbo.fun_cqyb_getvalbyseq(@strs,@seq,4), -- bzfl - ut_bz
				 dbo.fun_cqyb_getvalbyseq(@strs,@seq,5), -- jmbzfl - ut_bz
				 dbo.fun_cqyb_getvalbyseq(@strs,@seq,8), -- sybzfl - ut_bz
				 dbo.fun_cqyb_getvalbyseq(@strs,@seq,6), -- tjm - varchar(20)
				 dbo.fun_cqyb_getvalbyseq(@strs,@seq,7)  -- bgsj - varchar(20)
				 )
	if @@ROWCOUNT>0
	begin			 
		declare @name varchar(200),@outpy varchar(200),@outwb varchar(200)	
		select @name=dbo.fun_cqyb_getvalbyseq(@strs,@seq,2)		 
		exec  usp_yy_getpyzt @name,'0',@outpy output
		exec  usp_yy_getpyzt @name,'1',@outwb output
		update YY_CQYB_ZDDMK set py=@outpy,wb=@outwb  where id=@temp_key
		select 'T'
     end
     else
        select 'F' ,@temp_key 
     return   
end