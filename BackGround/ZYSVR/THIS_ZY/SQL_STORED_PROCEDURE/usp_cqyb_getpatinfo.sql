if exists(select 1 from sysobjects where name = 'usp_cqyb_getpatinfo')
  drop proc usp_cqyb_getpatinfo
go
Create proc usp_cqyb_getpatinfo
(
	@sbkh				varchar(20)			--��ᱣ�Ϻ���
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
	����������Ӻ�ɾ����ǰ̨չʾ˳�����ֶ��Ⱥ�˳�����������CQ04��CQ24���
[����˵��]
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��]
[�޸ļ�¼] 
****************************************/
set nocount on 

select a.sbkh as "�籣����",a.name as "����",a.sex as "�Ա�",a.age+'��' as "����",a.sfzh as "���֤��",a.nation as "����",
a.rylb as "��ְ",a.dwmc as "��λ����",c.name as "��������",case when a.fszk = '0' then '' else d.name end as "����״��",
fsyy as "����ԭ��",e.name as "�α����",b.zhye as "�˻����",bnzycs as "����סԺ����",
case when b.zyzt = '0' then "δסԺ" else "��סԺ" end as "סԺ״̬",ISNULL(f.name,a.mzrylb) "������Ա���",
b.bntczflj  as "ͳ��֧���ۻ�",b.bntsmzybflj as "��������ҽ�����ۼ�",b.bntsmzqfbzljzf as "�������������𸶱�׼�ۼ�"
,b.bnexzlzyqfbzzflj as "�����������סԺ�𸶱�׼�ۼ�",b.bnfhgwyfwmzfylj as "������Ϲ���Ա��Χ��������ۼ�" ,
a.address AS "סַ" ,a.dqfprylb "��ǰ��ƶ��Ա���"
from YY_CQYB_PATINFO a(nolock)
	left join YY_CQYB_ACCINFO b(nolock) on a.sbkh = b.sbkh
	left join YY_CQYB_YBSJZD c(nolock) on a.xzqhbm = c.code and c.zdlb = 'XZQH'
	left join YY_CQYB_YBSJZD d(nolock) on a.fszk = d.code and d.zdlb = 'FSZK'
	left join YY_CQYB_YBSJZD e(nolock) on a.cblb = e.code and e.zdlb = 'CBLB'
	left join YY_CQYB_YBSJZD f(nolock) on a.mzrylb = f.code and f.zdlb = 'MZRYLB'
where a.sbkh = @sbkh

return
GO
