--医保药品、项目视图
if exists(select 1 from sysobjects where type='V' and name='VW_YBYPXM')
begin
	DROP VIEW VW_YBYPXM
end
go

SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS OFF
GO
CREATE  VIEW VW_YBYPXM (yblsh,xmdm,xmmc,py,spm,spmzjm,lbdm,cfybz,ylfydj,gsfydj,syfydj,ylbzdj,gsbzdj,sybzdj,pfj,
						ylzfbl,gszfbl,syzfbl,txbl,jx,sl,dw,xjfs,tpbz,tqfydj,tqzfbl,tqbzdj,
						xmzl,ypgg,cjmc,hl,hldw,rl,rldw,bgsj,ybxjfs, zgcfjl,
						zgcfyl15,zgcfyl20,zgcfcb,zgcfzf,jmcfjl,jmcfyl15,jmcfyl20,jmcfcb,jmcfzf,gscfjl,
						gscfcb,gscfzf,sycfjl,sycfyl15,sycfyl20,sycfcb,sycfzf,tqcfjl,tqcfyl15,tqcfyl20,
						tqcfcb,tqcfzf,memo,bhnr,cwnr,cjzfbl,cjfydj,cjbzdj  
) AS    
	SELECT  YPLSH,YPBM,TYM,TYMZJM,SPM,SPMZJM,LBDM,isnull(CFYBZ,0),YLFYDJ,GSFYDJ,SYFYDJ,YLBZDJ,GSBZDJ,SYBZDJ,PFJ,
			YLZFBL,GSZFBL,SYZFBL,'',JX,isnull(BZSL,0),BZDW,YPXJFS,convert(varchar(3),'') TPBZ,   TQFYDJ,TQZFBL,TQBZDJ,
			'1','',YCMC,HL,HLDW,RL,RLDW,BGSJ,'', convert(varchar(2),0),
			convert(varchar(2),0),convert(varchar(2),0),convert(varchar(2),0),convert(varchar(2),0),convert(varchar(2),0),convert(varchar(2),0),convert(varchar(2),0),convert(varchar(2),0),convert(varchar(2),0),convert(varchar(2),0),
			convert(varchar(2),0),convert(varchar(2),0),convert(varchar(2),0),convert(varchar(2),0),convert(varchar(2),0),convert(varchar(2),0),convert(varchar(2),0),convert(varchar(2),0),convert(varchar(2),0),convert(varchar(2),0),    
			convert(varchar(2),0),convert(varchar(2),0),BZ,0,0,CJZFBL,CJFYDJ,CJBZDJ       from YPML(NOLOCK)    
	UNION
	SELECT  XMLSH,XMBM,XMMC,ZJM,XMMC,ZJM,LBDM1,'0',YLFYDJ,GSFYDJ,SYFYDJ,YLBZJ,GSBZJ,SYBZJ,TPJ,
			YLZFBL,GSZFBL,SYZFBL,TXBL,'','1',DW,XJFS,TPXMBZ,   TQFYDJ,TQZFBL,TQBZDJ,
			'0','','','','','','' ,BGSJ,'', ZGCFJL,
			ZGCFYL15,ZGCFYL20,ZGCFCB,ZGCFZF,JMCFJL,JMCFYL15,JMCFYL20,JMCFCB,JMCFZF,GSCFJL,
			GSCFCB,GSCFZF,SYCFJL,SYCFYL15,SYCFYL20,SYCFCB,SYCFZF,TQCFJL, TQCFYL15,TQCFYL20,
			TQCFCB,TQCFZF,BZ,0,0 ,CJZFBL,CJFYDJ,CJBZDJ  
	FROM ZLXM(NOLOCK)      
        
GO