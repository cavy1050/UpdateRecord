ALTER VIEW VW_YPXMMATCHED
    (    
      hisxmdm ,hisxmmc ,ypdm ,hisypjx ,hisypgg ,hisdw ,hisdj ,hisbzsl ,hiscd ,    
      ybdxmdm ,yblsh ,ybxmdm ,ybxmmc ,ybypjx ,dybz ,fydj ,sflb ,py ,xmzl ,    
      isdy ,ypbz1 ,zfbl ,isyp ,ybypgg ,ybypcj ,ybfydj ,dxmdm ,zyfp_id,ybdj,memo,ypbz,tybz,cjfydj
    )    
AS    
    SELECT  CONVERT(VARCHAR(12), a.idm) ,    
            a.ypmc ,    
            a.ypdm ,    
            b.name ,    
            a.ypgg ,    
            a.ykdw ,    
            a.ylsj ,    
            a.ykxs ,    
            a.cjmc ,    
            d.mzyb_id ,    
            c.yblsh ,    
            c.xmdm ,    
            c.xmmc + CASE WHEN c.ylfydj = 1 THEN '[甲]'    
                          WHEN c.ylfydj = 2 THEN '[乙]'    
                          WHEN c.ylfydj = 3 THEN '[非]'    
                          ELSE ''    
                     END tym ,    
            c.jx ,    
            1 ,    
            c.ylfydj ,    
            c.xjfs ,    
            a.py ,    
            '1' ,    
            a.isdy ,    
            d.ypbz ,    
            a.zyzfbl ,    
            0 ,    
            c.hl + c.hldw + ' ' + c.rl + c.rldw + ' ' + c.sl + c.dw ,    
            c.cjmc ,    
            ybfydj ,    
            LTRIM(RTRIM(d.id)) ,    
            d.zyfp_id  ,  
            CONVERT(VARCHAR(20), c.ylbzdj) AS ybdj,
            c.memo ,d.ypbz, 
            CASE WHEN a.tybz = 0 THEN '正在使用'
				 WHEN a.tybz = 1 THEN '已停用'
				 ELSE '未知状态'
			END tybz,''
								 	
    FROM    YK_YPCDMLK a(NOLOCK) INNER JOIN VW_YBYPXM c(NOLOCK) ON a.dydm = c.yblsh   
								INNER JOIN YK_YPJXK b(NOLOCK) ON a.jxdm = b.id    
								INNER JOIN YY_SFDXMK d(NOLOCK) ON a.yplh = d.id    
    WHERE   a.isdy = 1 
    UNION ALL    
    SELECT  a.id ,    
            a.name ,    
            a.id ,    
            NULL ,    
            NULL ,    
            a.xmdw ,    
            a.xmdj ,    
            NULL ,    
            NULL ,    
            c.mzyb_id ,    
            b.yblsh ,    
            b.xmdm ,    
            b.xmmc + CASE WHEN b.ylfydj = 1 THEN '[甲]'    
                          WHEN b.ylfydj = 2 THEN '[乙]'    
                          WHEN b.ylfydj = 3 THEN '[非]'    
                          ELSE ''    
                     END xmmc ,    
            '' ,    
            0 ,    
            b.ylfydj ,    
            b.xjfs ,    
            a.py ,    
            '0' ,    
            a.isdy ,    
            c.ypbz ,    
            a.zyzfbl ,    
            1 ,    
            '' ,    
            '' ,    
            ybfydj ,    
            LTRIM(RTRIM(c.id)) ,    
            c.zyfp_id  ,  
            CONVERT(VARCHAR(20), b.ylbzdj) AS ybdj,
            b.memo  ,'0' ypbz,
            CASE WHEN a.sybz = 0 THEN '已停用'
				 WHEN a.sybz = 1 THEN '正在使用'
				 ELSE '未知状态'
			END tybz,''
            
    FROM    YY_SFXXMK a(NOLOCK) INNER JOIN VW_YBYPXM b(NOLOCK) ON  a.dydm = b.yblsh   
				                INNER JOIN YY_SFDXMK c(NOLOCK) ON a.dxmdm = c.id    
    WHERE   a.isdy = 1    




