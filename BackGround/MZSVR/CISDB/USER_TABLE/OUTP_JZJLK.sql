IF OBJECT_ID('tr_OUTP_JZJLK','TR') IS NOT NULL
DROP TRIGGER tr_OUTP_JZJLK
GO

--转诊更新OUTP_JZJLK.KSDM时，同步更新THIS_MZ.ksdm
CREATE trigger [dbo].[tr_OUTP_JZJLK] on [dbo].OUTP_JZJLK      
for update      
as      
      
if @@rowcount=0 return      
      
 if update(KSDM)    
 begin    
 update a set ksdm=b.KSDM from THIS_MZ..GH_GHZDK a
 inner join OUTP_JZJLK b on a.xh=b.GHXH   
 inner join inserted c on b.GHXH=c.GHXH 
 end    
 IF(@@ERROR>0)
 BEGIN
	return
 END