if exists(select 1 from sysobjects where name = 'usp_cqyb_mzsf_updatemedtype')
  drop proc usp_cqyb_mzsf_updatemedtype
go

CREATE proc usp_cqyb_mzsf_updatemedtype
	@patid ut_xh12,
	@yxrq ut_rq8
as
/*

更新错误的医疗类别信息

*/
--收费有效期
if isnull(@yxrq,'')=''
  select @yxrq=convert(varchar(8),getdate(),112)

DECLARE @patid_str VARCHAR(20)
SELECT @patid_str = CONVERT(VARCHAR(20),@patid)
---职工医保病人更新错误的medtype
if exists(select 1  from SF_HJCFK a(nolock),SF_BRXXK b(nolock),YY_YBFLK c(nolock) 
            where a.jlzt in(0,3,5,8) and a.patid=@patid and a.lrrq>@yxrq and a.patid=b.patid and  b.ybdm=c.ybdm and 
                   c.xzlb=1 and c.cblb in(1,3) and (a.medtype in('12') or isnull(a.medtype,'')=''))
begin 
    update a set medtype='11' from SF_HJCFK a(nolock),SF_BRXXK b(nolock),YY_YBFLK c(nolock) 
            where a.jlzt in(0,3,5,8) and a.patid=@patid and a.lrrq>@yxrq and a.patid=b.patid and  b.ybdm=c.ybdm and 
                   c.xzlb=1 and c.cblb in(1,3) and (a.medtype in('12') or isnull(a.medtype,'')='')
end 


---职工医保病人更新错误的medtype
if exists(select 1  from SF_HJCFK a(nolock),SF_BRXXK b(nolock),YY_YBFLK c(nolock) 
            where a.jlzt in(0,3,5,8) and a.patid=@patid and a.lrrq>@yxrq and a.patid=b.patid and  b.ybdm=c.ybdm and 
                   c.xzlb=1 and c.cblb in(2) and (a.medtype in('11') or isnull(a.medtype,'')=''))
begin 
    update a set medtype='12' from SF_HJCFK a(nolock),SF_BRXXK b(nolock),YY_YBFLK c(nolock) 
            where a.jlzt in(0,3,5,8) and a.patid=@patid and a.lrrq>@yxrq and a.patid=b.patid and  b.ybdm=c.ybdm and 
                   c.xzlb=1 and c.cblb in(2) and (a.medtype in('11') or isnull(a.medtype,'')='')
end 

IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE id = OBJECT_ID('SF_HJCFK') AND name = 'zddm')
BEGIN
	--UPDATE  SF_HJCFK  SET zddm = NULL WHERE   jlzt in(0,3,5,8) AND patid = @patid AND LEN(LTRIM(RTRIM(ISNULL(zddm,'')))) = 0 and lrrq>@yxrq
	EXEC('UPDATE  SF_HJCFK  SET zddm = NULL WHERE jlzt in(0,3,5,8) AND patid = '+ @patid_str + ' AND LEN(LTRIM(RTRIM(ISNULL(zddm,"")))) = 0 and lrrq > "'+ @yxrq + '"')
END

UPDATE  SF_HJCFK  SET cftszddm = NULL WHERE jlzt in(0,3,5,8) AND  patid = @patid AND LEN(LTRIM(RTRIM(ISNULL(cftszddm,'')))) = 0 and lrrq>@yxrq 
UPDATE  SF_HJCFK  SET ybbfz = NULL WHERE jlzt in(0,3,5,8) AND  patid = @patid AND LEN(LTRIM(RTRIM(ISNULL(ybbfz,'')))) = 0 and lrrq>@yxrq 

UPDATE  SF_HJCFK  SET sylbdm = NULL
 WHERE jlzt in(0,3,5,8) 
   AND patid = @patid 
   AND LEN(LTRIM(RTRIM(ISNULL(sylbdm,'')))) = 0
   AND lrrq>@yxrq 
UPDATE  SF_HJCFK  SET sylbmc = NULL
 WHERE jlzt in(0,3,5,8) 
   AND patid = @patid 
   AND LEN(LTRIM(RTRIM(ISNULL(sylbmc,'')))) = 0
   AND lrrq>@yxrq 

return 

go

