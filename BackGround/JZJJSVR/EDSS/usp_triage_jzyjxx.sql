USE [EDSS]
GO
/****** Object:  StoredProcedure [dbo].[usp_triage_jzyjxx]    Script Date: 2022-01-29 14:04:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[usp_triage_jzyjxx]
(
	@ghlb int,
	@patid VARCHAR(50),
	@ksdm VARCHAR(32)
)
/********** 
[修改] 
@ghlb  挂号类别 ,0普通挂号,1急诊挂号
@patid VARCHAR(50),
@ksdm VARCHAR(50)
exec usp_triage_jzyjxx 1,'1711945','020902'
**********/  
as
	
declare @IDNumber varchar(50),
        @CardNumber varchar(50),
        @datetime datetime,
	    @TriageDepCode VARCHAR(100)
select  @datetime= dateadd(HH,-24,GETDATE())
select patid,hzxm,sfzh,cardno 
into #temp0
from [172.20.0.40\MZ].THIS_MZ.dbo.SF_BRXXK where patid=@patid
select @IDNumber=(select sfzh from #temp0)
select @CardNumber=(select cardno from #temp0)

drop table #temp0

if @ghlb=1 and @ksdm in ('020901','020902')--急诊号，挂急诊内科，急诊外科
begin
	select c.HISPatientId,
		Name,
		TriageTime,
		FeeType,
		a.CreateTime,
		TriageDep,
		TriageDepCode,
		PatientId,
		TriageId
	into #temp
	from Triage.Triage_Master a 
		left join Triage.Triage_Details b on a.Id=b.TriageId 
		left join PatientInfo c on a.PatientId=c.Id 
	where IDNumber=@IDNumber
		and a.CreateTime>@datetime

	if exists (select 1 from #temp )
	begin
		select @TriageDepCode= replace(TriageDepCode,'["','') from #temp
		select @TriageDepCode=replace(@TriageDepCode,'"]','')
		--select @TriageDepCode

		if (@ksdm!=@TriageDepCode)
		begin
			select 'F','预检科室与挂号科室不匹配,请核对信息'
			return
		end
	end

else if not exists (select 1 from #temp )
	begin 
	 select c.HISPatientId,
		Name,
		TriageTime,
		FeeType,
		a.CreateTime,
		TriageDep,
		TriageDepCode,
		PatientId,
		TriageId
	into #temp1
	from Triage.Triage_Master a 
		left join Triage.Triage_Details b on a.Id=b.TriageId 
		left join PatientInfo c on a.PatientId=c.Id 
	where CardNumber=@CardNumber
		and a.CreateTime>@datetime

      if exists (select 1 from #temp1 )
	  begin
		select @TriageDepCode= replace(TriageDepCode,'["','') from #temp
		select @TriageDepCode=replace(@TriageDepCode,'"]','')
		--select @TriageDepCode

		if (@ksdm!=@TriageDepCode)
		begin
			select 'F','预检科室与挂号科室不匹配,请核对信息'
			return
		end
	  end

	else
	begin 
		select 'F','无预检信息，请到预检分诊处进行分诊'
		return
	end
	drop table #temp1
	end

	drop table #temp
end

select 'T'--其他ghlb就不管


