if exists(select 1 from sysobjects where name = 'usp_cqyb_savetsbinfo')
  drop proc usp_cqyb_savetsbinfo
go
CREATE proc usp_cqyb_savetsbinfo
(
	@sbkh				varchar(20),		--社会保障号码
	@bzbm				varchar(20),		--病种编码
	@bzmc				varchar(80),		--病种名称
	@bfz				varchar(200)=''		--并发症
)
as
/****************************************
[版本号]4.0.0.0.0
[创建时间]2017.03.05
[作者]FerryMan
[版权]Copyright ? 1998-2017卫宁健康科技集团股份有限公司
[描述]保存医保特殊病审批信息
[功能说明]
	保存医保特殊病审批信息
[参数说明]
[返回值]
[结果集、排序]
[调用的sp]
[调用实例]
[修改记录]
****************************************/
set nocount on
	
BEGIN TRAN

if not exists(select 1 from YY_CQYB_TSBINFO where sbkh = @sbkh and bzbm = @bzbm and bfz = @bfz)
begin
	insert into YY_CQYB_TSBINFO(sbkh,bzbm,bzmc,bfz)
	select @sbkh,@bzbm,@bzmc,@bfz
	if @@error<>0 or @@rowcount = 0 
	BEGIN
        ROLLBACK TRAN
		select "F","保存医保特殊病审批信息失败1!"
		return
	end;
end
else
begin
	update YY_CQYB_TSBINFO set bzmc = @bzmc,jlzt = 0 where sbkh = @sbkh and bzbm = @bzbm and bfz = @bfz
	if @@error<>0 or @@rowcount = 0 
	BEGIN
        ROLLBACK TRAN
		select "F","更新医保特殊病审批信息失败!"
		return
	end;
END

DELETE YY_SYB_BRJBBMK WHERE shbzh = @sbkh --AND bzbm = @bzbm AND @bzmc = @bzmc AND bfz = @bfz

insert into YY_SYB_BRJBBMK ( shbzh, bzbm, bzmc,  bfz ,py,wb)
SELECT @sbkh,a.bzbm,convert(varchar(40),a.bzmc),a.bfz,ISNULL(b.py, ' '),ISNULL(b.wb, ' ')--bzmc截断，很医院都是varchar40
FROM YY_CQYB_TSBINFO a(NOLOCK) LEFT JOIN YY_CQYB_ZDDMK b(NOLOCK) ON a.bzbm = b.id 
WHERE a.sbkh = @sbkh AND a.jlzt = 0
if @@error<>0 or @@rowcount = 0 
BEGIN
    ROLLBACK TRAN
	select "F","保存医保特殊病审批信息失败2!"
	return
end;

COMMIT TRAN

select "T"

return
GO
