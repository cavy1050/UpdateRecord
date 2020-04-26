--未对应药品项目视图
if exists(select 1 from sysobjects where type='V' and name='VW_THISYPXM')
begin
    DROP VIEW VW_THISYPXM
end
go

SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS OFF
GO
CREATE VIEW VW_THISYPXM  
    (  
      xmdm ,  
      xmmc ,  
      py ,  
      wb ,  
      ypgg ,  
      jxmc ,  
      cjmc ,  
      ylsj ,  
      ykdw ,  
      ypdm ,  
      ypbz ,  
      dybz ,  
      dydm ,  
      isdy ,  
      ykxs ,  
      lcypmc ,  
      dxmdm ,  
      zyfp_id  
    )  
AS  
    SELECT  CONVERT(VARCHAR(12), a.idm) ,  
            a.ypmc ,  
            a.py ,  
            a.wb ,  
            a.ypgg ,  
            b.name ,  
            cjmc ,  
            a.ylsj ,  
            a.ykdw ,  
            a.ypdm ,  
            c.ypbz ,  
            1 dybz ,  
            a.dydm ,  
            a.isdy ,  
            a.ykxs ,  
            d.ypmc AS lcypmc ,  
            LTRIM(RTRIM(c.id)) ,  
            c.zyfp_id  
    FROM    YK_YPCDMLK a(NOLOCK) ,  
            YK_YPJXK b(NOLOCK) ,  
            YY_SFDXMK c(NOLOCK) ,  
            YK_YPLCMLK d(NOLOCK)  
    WHERE   a.jxdm = b.id  
            AND a.yplh = c.id  
            AND a.tybz = 0  
            AND a.lc_idm = d.idm  --and a.ypdm not in ('60','62','63','64','65')    
            AND a.ypmc NOT LIKE '%试纸%'  
    UNION ALL  
    SELECT  a.id ,  
            a.name ,  
            a.py ,  
            a.wb ,  
            a.xmgg ,  
            NULL ,  
            NULL ,  
            a.xmdj ,  
            a.xmdw ,  
            '0' ,  
            '0' ypbz ,  
            0 dybz ,  
            a.dydm ,  
            a.isdy ,  
            NULL ,  
            NULL ,  
            LTRIM(RTRIM(dxmdm)) ,  
            b.zyfp_id  
    FROM    YY_SFXXMK a ( NOLOCK ) ,  
            YY_SFDXMK b ( NOLOCK )  
    WHERE   a.sybz = 1  
            AND a.dxmdm = b.id  
            AND ISNULL(a.xmgg, '') <> '文字医嘱'      

GO
