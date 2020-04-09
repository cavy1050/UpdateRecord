if exists(select 1 from sysobjects where name = 'usp_cqyb_getqueryinfo')
  drop proc usp_cqyb_getqueryinfo
go
CREATE proc usp_cqyb_getqueryinfo
(
	@cxlb				ut_bz,				--��ѯ���1ҽ��������Ϣ���˻���Ϣ2ҽ���ز���Ϣ3���˵�λ��Ϣ4�����϶���Ϣ
	@sbkh				varchar(20),		--��ᱣ�Ϻ���
	@xzlb				ut_bz=0				--�������
)
as
/****************************************
[�汾��]4.0.0.0.0
[����ʱ��]2017.03.05
[����]FerryMan
[��Ȩ]Copyright ? 1998-2017���������Ƽ����Źɷ����޹�˾
[����]��ȡҽ�����˻�����Ϣ���˻���Ϣ
[����˵��]
	��ȡҽ�����˻�����Ϣ���˻���Ϣ
[����˵��]
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��]
[�޸ļ�¼] 
****************************************/
set nocount on 

if @cxlb = 1	--1ҽ��������Ϣ���˻���Ϣ
begin
	if @xzlb = 1
	begin
		select "T",a.sbkh,name,(case sex when '1' then '��' when '2' then 'Ů' else sex end),age,sfzh,nation,address,rylb,gwydy,
			dwmc,xzqhbm,fszk,fsyy,rylxbg,rylxbgsj,dyfskssj,dyfsjssj,mzrylb,jmjfdc,cblb,lxdh,dqfprylb,zhye,bntczflj,bntsmzqfbzljzf,
			bntsmzybflj,bnexzlzyqfbzzflj,bnfhgwyfwmzfylj,bnzycs,zyzt,bntbmzxbzzfje,bnzyxbzzfje,bnfsgexzlbz,bndbzflj,jbzdjbfsbz,
			bnywshzflj,bnndyjhzflj,bnetlbzflj,bnkfxmzflj,ndmzzyzflj,ndmzmzzflj,jxbzlj,ndptmzzflj,yddjbz,zhxxyly,zhxxyle
		from YY_CQYB_PATINFO a(nolock) inner join YY_CQYB_ACCINFO b(nolock) on a.sbkh = b.sbkh
		where a.sbkh = @sbkh 
	end
	else if @xzlb = 2
	begin
		select "T",a.sbkh,name,(case sex when '1' then '��' when '2' then 'Ů' else sex end),sfzh,dwmc,xzqhbm,gscbzt,gscbsj,
			gsfszk,gsfsyy,gsdyfskssj,gsdyfsjssj,zyzz,fzqjcbsp,cfxmtslj,gszyzt
		from YY_CQYB_PATINFO a(nolock) inner join YY_CQYB_ACCINFO b(nolock) on a.sbkh = b.sbkh
		where a.sbkh = @sbkh 
	end
	else if @xzlb = 3
	begin
		select "T",a.sbkh,name,(case sex when '1' then '��' when '2' then 'Ů' else sex end),sycbsj,sfzh,jydjzh,xsjzbz,bxsjzyy,
			jydjjjbm,bfzbz,dyxskssj,dyxsjssj,xzqhbm,byqcqjczflj,byqycbjyjczflj,byqjhsysszflj,byqfmzzrsylfzflj,byqbfzzflj,
			syzyzt	 
		from YY_CQYB_PATINFO a(nolock) inner join YY_CQYB_ACCINFO b(nolock) on a.sbkh = b.sbkh
		where a.sbkh = @sbkh 
	end
end  
else if @cxlb = 2	--2ҽ���ز���Ϣ
begin
	select "T",bzbm,bzmc,bfz from YY_CQYB_TSBINFO(nolock) where sbkh = @sbkh and jlzt = 0
end
else if @cxlb = 3	--3���˵�λ��Ϣ
begin
	select "T",grbh,dwbh,dwmc from YY_CQYB_GSDWINFO(nolock) where sbkh = @sbkh and jlzt = 0
end
else if @cxlb = 4	--4�����϶���Ϣ
begin
	select "T",a.grbh,a.dwbh,b.dwmc,a.rdbh,a.tgbz,a.sssj,a.jssj,bzinfo  
	from YY_CQYB_GSRDINFO a(nolock) inner join YY_CQYB_GSDWINFO b(nolock) on a.dwbh = b.dwbh 
	where a.sbkh = @sbkh and a.jlzt = 0
end

return
GO
