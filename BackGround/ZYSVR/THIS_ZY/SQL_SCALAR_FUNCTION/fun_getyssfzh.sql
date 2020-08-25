alter function fun_getyssfzh(@jsxh ut_sjh,@xtbz char(2))
returns varchar(20)
as
/******
示例：select dbo.fun_getyssfzh('','MZ')
说明：获取对应医生身份证号码，用于医保费用上传，结算
作者：winning-dongchuan-chongqing
时间：20200820
参数：门诊（jssjh,'MZ'）；住院（jsxh,'ZY'）
******/

begin
	declare @sfzh varchar(20)=''
	if(UPPER(@xtbz)='MZ')
	begin
		select top 1 @sfzh=d.sfzh
		--a.sjh,a.sfrq,b.jssjh jssjh_sf,c.jssjh jssjh_gh,ghsfbz,
		--case when len(b.ysdm)>0 then b.ysdm
		--	else (case when len(c.ysdm)>0 then c.ysdm
		--	else (case when len(c.ghysdm)>0 then c.ghysdm
		--	else (case when len(c.jzysdm)>0 then c.jzysdm
		--	else (case when len(c.scjzysdm)>0 then c.scjzysdm
		--	else (case when len(c.sdysdm)>0 then c.sdysdm else '' end) end) end) end) end) 
		--end ysdm,fzbz
		from VW_MZBRJSK a
		left join VW_MZCFK b on a.sjh=b.jssjh and a.ghsfbz=1
		left join VW_GHZDK c on a.sjh=c.jssjh and a.ghsfbz=0
		left join YY_ZGBMK d on 
		case when len(b.ysdm)>0 then b.ysdm
			else (case when len(c.ysdm)>0 then c.ysdm
			else (case when len(c.ghysdm)>0 then c.ghysdm
			else (case when len(c.jzysdm)>0 then c.jzysdm
			else (case when len(c.scjzysdm)>0 then c.scjzysdm
			else (case when len(c.sdysdm)>0 then c.sdysdm else '' end) end) end) end) end) 
		end=d.id
		where a.sjh=@jsxh
	end
	else if(UPPER(@xtbz)='ZY')
	begin
		select top 1 @sfzh=d.sfzh from ZY_BRJSK a
		left join ZY_BRSYK b on a.syxh=b.syxh
		left join VW_BRFYMXK c on a.syxh=c.syxh and len(c.ysdm)>0
		left join YY_ZGBMK d on case when len(b.ysdm)>0 then b.ysdm else c.ysdm end=d.id
		where convert(varchar(32),a.syxh)=@jsxh
	end
	else
	begin
		select @sfzh=''
	end
	return @sfzh
end
