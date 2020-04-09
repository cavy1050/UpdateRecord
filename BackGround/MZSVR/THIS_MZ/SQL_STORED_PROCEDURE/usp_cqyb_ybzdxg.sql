if exists(select 1 from sysobjects where name = 'usp_cqyb_ybzdxg')
  drop proc usp_cqyb_ybzdxg
GO

CREATE PROCEDURE usp_cqyb_ybzdxg 
(
	@bqid varchar(10)=''
)	
as
/*****************************
[版本号]0.0.0.0.0  
[创建时间]2012.09.01  
[作者]闵诏  
[版权] Copyright ? 20012-2015上海金仕达-卫宁软件股份有限公司[描述]  
[功能说明]   
[参数说明]  
[返回值]  
[结果集、排序]  
[调用的sp]  
[调用实例]  
[修改说明]  
******************************/	
set nocount on

      select a.syxh as "首页序号",a.blh as "病历号",a.hzxm as "患者姓名",
             a.bqdm as "病区代码",b.name as "病区名称",a.cwdm as "床位代码", 
             substring(a.ryrq,1,4)+'.'+substring(a.ryrq,5,2)+'.' +
             substring(a.ryrq,7,2)+' '+substring(a.ryrq,9,8)as "入院日期",
             a.sex as "性别", 
             c.ybsm "病人类型",d.cyzd "医保疾病编码",e.name "诊断名称",
             d.bfzinfo "并发症",a.py as "拼音",a.wb as "五笔" 
             from ZY_BRSYK a inner JOIN ZY_BQDMK b ON a.bqdm = b.id
             INNER JOIN YY_YBFLK c ON a.ybdm=c.ybdm
             INNER JOIN YY_CQYB_ZYJZJLK d ON a.syxh=d.syxh
             LEFT JOIN YY_CQYB_ZDDMK e ON d.cyzd=e.id                        
             where a.brzt not in (0,3,8,9) and d.jlzt=1 
			 and CONVERT(VARCHAR(10),c.ybjkid) IN (select config from YY_CONFIG WHERE id = 'CQ18')
             and a.bqdm=@bqid
             order by a.bqdm,a.cwdm,a.blh
 
 return 

GO
