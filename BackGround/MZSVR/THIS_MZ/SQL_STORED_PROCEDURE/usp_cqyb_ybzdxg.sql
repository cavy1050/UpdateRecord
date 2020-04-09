if exists(select 1 from sysobjects where name = 'usp_cqyb_ybzdxg')
  drop proc usp_cqyb_ybzdxg
GO

CREATE PROCEDURE usp_cqyb_ybzdxg 
(
	@bqid varchar(10)=''
)	
as
/*****************************
[�汾��]0.0.0.0.0  
[����ʱ��]2012.09.01  
[����]��گ  
[��Ȩ] Copyright ? 20012-2015�Ϻ����˴�-��������ɷ����޹�˾[����]  
[����˵��]   
[����˵��]  
[����ֵ]  
[�����������]  
[���õ�sp]  
[����ʵ��]  
[�޸�˵��]  
******************************/	
set nocount on

      select a.syxh as "��ҳ���",a.blh as "������",a.hzxm as "��������",
             a.bqdm as "��������",b.name as "��������",a.cwdm as "��λ����", 
             substring(a.ryrq,1,4)+'.'+substring(a.ryrq,5,2)+'.' +
             substring(a.ryrq,7,2)+' '+substring(a.ryrq,9,8)as "��Ժ����",
             a.sex as "�Ա�", 
             c.ybsm "��������",d.cyzd "ҽ����������",e.name "�������",
             d.bfzinfo "����֢",a.py as "ƴ��",a.wb as "���" 
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
