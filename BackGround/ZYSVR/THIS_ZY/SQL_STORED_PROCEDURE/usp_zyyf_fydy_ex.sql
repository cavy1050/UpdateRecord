ALTER proc usp_zyyf_fydy_ex
@wkdz varchar(32),   --������ַ        
 @jszt smallint,    --����״̬ 1=������2=���룬3=�ݽ�        
 @fyxh ut_xh12=0,   --��ҩ�˵���š�0�������ݽ�ģʽYF_ZYFYZD.xh(����)�����������ʵ���ѯģʽYF_ZYFYD.xh(��ҩ��ӡ)        
 @hzlx smallint=1,   --�������͡�0����ϸ 1������ 2 ָ�����ݰ��ղ��˻���        
 @syxh ut_syxh = 0,   --ָ��������ҳ��š�0:ȫ����������ָ������        
 @cydy smallint=1,   --��ҩ�Ƿ��ӡ��0������ӡ 1����ӡ        
 @isdyphxq smallint=0,  --�Ƿ��ӡ����Ч�� 0������ӡ 1����ӡ        
 @isbd ut_bz =0,              --0ΪסԺ��ҩ�������(yf_zyfy_bd.dll)��        
        --1ΪסԺ��ҩ��ҩ�������������������(yf_zyfy.dll)        
 @filterlb ut_bz=0,          --0 ������ 1���˳�Ժ��ҩ����ؿ��� 2 ����С���� 3 ���˱�־ 1��2����������         
 @dylb ut_bz=0 ,             --0 ԭ���� 1,2 �ֳ��Լӽ�������          
 @isShowcydy ut_bz=0,      --�Ƿ�ֻ��ʾ��Ժ��ҩ 0 �� 1��         
 @dsybz ut_bz=0, --0Ϊԭ���̣�1Ϊ��ʾ����Һ ��@bdbz=1ʱ����Ч            
 @byjbz ut_bz=0,  --0Ϊ�˹���ҩ���ܵ� 1Ϊȫ�����ܵ�  --�ڴ�ӡ���ܵ�ʱ����Ч        
 @yhlcms ut_bz =0, --0Ϊ������ģʽ��1Ϊ�Ż���ģʽ        
 @fyxhlist varchar(8000) ='',  --��Ŵ�         
 @isjsdmbz ut_bz =0   --���˾������־ 0Ϊ�����ˣ�1Ϊֻ��ʾ������          
 ,@ypfzdybz ut_bz=0      --ҩƷ�����ӡ��־             
 ,@fsbzysjbz ut_bz=0  -- ���Ͱ�ҩ�����ݱ�־      
 ,@fyczyh ut_czyh='-1'  --��ҩ����Ա      
 ,@dybz ut_bz  =0 --0δ��ӡ��1Ϊȫ��������δ��ӡ���Ѵ�ӡ��      
 ,@cydybz ut_bz =0  ---0���ǣ�1Ϊ��Ժ��ҩ��־      
 ,@xcfdybz ut_bz =0   --0���ǣ�1ΪС������־      
 ,@djfljhlist VARCHAR(8000)='' --�����ݷ������      
 ,@tsbzjhlist VARCHAR(8000)=''  --�������־����         
 ,@isBrbyddy ut_bz=0 --�Ƿ��˰�ҩ�嵥��ӡ         
 ,@yzlxbz ut_bz=0    --0Ϊ��������ҽ�� 1��ʱҽ�� 2����ҽ��         
as--��74388 2010-06-24 9:36:52 4.0��׼�� 201007 ��������128    
/**********    
[�汾��]4.0.0.0.0    
[����ʱ��]2004.12.15    
[����]����    
[��Ȩ] Copyright ? 2004-2008�Ϻ����˴�-��������ɷ����޹�˾    
[����]סԺ��ҩ��ӡ(����)    
[����˵��]    
 סԺ��ҩ��ӡ    
[����CONFIG˵��]    
 7018 סԺ��ҩ��ӡ�Ƿ���ʾ�Ա�ҩƷ��Ϣ    
 7029 סԺ��ҩ��ҩƷ�����Ƿ�ͬʱ��ʾҩƷ����      
 7031 סԺ��ҩ��ҽ��ҩƷ�Ƿ�ֵ��ݷ�ҩ    
 7043 ��3.Xģʽ��ӡ��ҩ��ϸ����    
 7050 סԺ��ҩ������ҩƷ�Ƿ�ֵ��ݷ�ҩ    
[����ֵ]    
[�����������]    
[���õ�sp]    
[����ʵ��]    
exec usp_zyyf_fydy_ex "0020ED674C80",1,0,0--��Clientdataset��    
exec usp_zyyf_fydy_ex "0020ED674C80",2,68013,0--��Clientdataset��    
exec usp_zyyf_fydy_ex "0020ED674C80",3,0,1--��Clientdataset��    
exec usp_zyyf_fydy_ex "0020ED674C80",3,0,0--��Clientdataset��    
    
[�޸ļ�¼]    
 Modify By Koala In 2004-02-03 For :�����Ա�ҩ����ʾ(ͨ������7018����)    
 Modify By Koala In 2004-02-04 For :���ӹ�����Ϣ���    
 Modify By Wxp In 2004-03-29 For :���ӿ���ҽ�����š�������������    
 Modify By Koala In 2004-04-29 For :���Ӱ���ż�ҽ��¼��˳������    
 Modify By Koala In 2004-04-29 For :��ҩƷ���ƺ͹��ֿ���ʾ    
 Modify By Koala In 2004-06-08 For :����ҽ��������š�����/��ʱ��־����ʾ    
    Modify By agg   In 2004.0726    For :���ӶԲ�ҩ�Ĵ���    
 Modify By Koala In 2004-10-18 For :�޸�Ӥ�������Bug    
 Modify by mit, in 2oo4-11-26 , ���,��ҩ����ҩһ��    
 yxp 2005-2-19 ����ת����Ӧ����ʾ��ʱ�Ĵ�λ��Ϣ    
 zwj 2005-3-03 �޸�סԺ��ҩ��ӡ��ϸ�У���ʱҽ��ÿ������Ϊ�յ�bug    
    zyp 2005-3-4 �����Һͱ���������    
 Modify By : Tony In : 2005-04-18  For : �Ż����ܣ��ϲ��˲����ظ�����    
        Modify by : xujian      In : 2005-04-30  for : ��ӡʱ���Ӵ�������ҽ���ͷ�ҩ����Ա    
 yxp 2005-5-16 ����ҩ��ļ�¼Ӧ������ȷ��ʾlylx=8    
 yxp 2005-7-12 �޸�bug:����7018����Ϊ��ʱ��ҩƷ������Ϣ�᲻�����ܲ�ѯ    
 mly 2005-08-17 ���ӷ�ҩ����ӡ����3.Xģʽ    
 yxp 2006-3-2 ���ӹ��ܣ�����7050'סԺ��ҩ������ҩƷ�Ƿ�ֵ��ݷ�ҩ'  ��ʵ�������ֵ��ݷ�ҩ    
 yxp 2006-3-30 ��birthͳһ�ĳ�isnull(birth,'19700101')������birthΪnull����    
 yxp 2006-4-13 סԺ��ҩ��Ҫ��Ӧ�޸�,��Ҫ����ʱҽ����Ӧ��Ƶ�δ�����ʾ����    
 yxp 2006-4-27 ����'ת��ת����־'�Ĵ���,���㻤ʿУ�Դ�λ���� 2006-5-9 ��ҽ��ִ��ʱ��ʼ������ת��    
 yxp 2006-7-20 �ж�ת��Ӧ�ø���#tempypmx��yzzxrq���ж�    
 yxp 2006-9-20 ypjl���ֶ����͸�Ϊut_sl14_3    
 yxp 2006-11-21 ��ʱҽ�����ypjlͳһȡBQ_LSYZK��(case when b.lz_pcdm is null then b.ypjl else b.lz_mcsl end)    
     ��Ժ��ҩ���ypjlͳһȡBQ_LSYZK��convert(numeric(10,2),h.lz_mcsl)    
 yxp 2007-1-5 ���۸���ʾ��4λС��    
 yxp 2007-1-12 ����������usp_zyyf_fydy_ex2,usp_zyyf_fydy_ex2_hz�ϲ�����usp��    
 yxp 2007-1-16 ������Ϣ����ʱ���Ȱ����������ٰ�ҩƷ����    
 mly 2007-04-16 �޸�ȡ��ҩ�������distinct    
 insert into #fydy(fyxh) select distinct fyxh from YF_ZYFYDMX (nolock) where zdxh=@fyxh    
 mly 2007-05-21 ������ϴ���Ĵ���������YY_ZDDMK     
 yxp 2007-5-22 ��Ҫ��ZY_BRZDQK��ȡ���,zdlb=1����Ժ���;zdlx=0����Ҫ���    
 mly 2007-06-16 ���Ӳ�ҩҽ�����еĴ����������÷�����,�������д���    
 yxp 2007-09-05 ����7043����3.Xģʽ��ӡ��ҩ��ϸ���ݣ���Ϊ���ǡ�������6085��Ϊ��1��������£���ҩ�ͷ�ҩ�ܵ�����ӡ����ҩ�嵥���ڷ�ҩ�嵥����    
 yxp 2007-09-07 ���ӹ��ܣ�����7043Ϊ��ʱ���ܹ���������(BQ_FYQQK.blzbz=1)������ӡ������������ҩ֮ǰ    
 yxp 2007-09-13 ��ҩ��ӡ��ϸʱ��Ӧ�ù��˵�BQ_YZDJFLK.dybz=1�ļ�¼--��ӡ��־(0��ӡ��ϸ��1������ϸ)����ѯ����̶���ӡ    
 yxp 2007-10-18 �ϲ������ֳ��޸ĵ�����,���ӿ���7067,סԺ��ҩʱ������Ҫ��ӡ��Ժ��ҩ����Һ���õ�(����̶�Ϊ40)������    
 yxp 2007-10-21 ��3.xϰ���޸ģ�������7043�������������ĸ�ҩʱ��ָ���Ϊ-    
     ���ӿ���7070���ܣ�סԺ��ҩ��ϸ��ӡ����ʾҩƷ����    
     ����ggxs�Ĵ���, ��ϸ�����ܣ�������ҩƷƴ���Ĵ���    
     ��ϸ��ӡ˳�򣺳��ڣ���ʱ����Ժ��ҩ����λ����ʱת�����ֽ�������    
 yxp 2007-10-22  ������ypsl1����lz_mcsl��ȡʱ����Ҫ�ж�dwlb=3��ֱ�Ӵ���������lz_mcsl/ggxs    
        mly 2007-11-26 סԺ������ҩ��ӡ����ʽ1����+����2���λ��    
        yxp 2008-1-9 �ڿ���7070��ʱ,ʵ�ֽ���ҩ��Ϣ�������Ĺ���    
 yxp 2008-1-22 ��ҩ��ϸ�嵥������ҩƷ�Ĵ��λ���ֶεĴ���    
 yxp 2008-3-20 ������ҩ�񡯵Ļ���ҩƷ��¼��ʾʱ������ʾ������Ϊ0�ļ�¼    
        mly 2008-04-17 ����cwdm_row'��λ����_��'�Է����ӡ�̶��߶ȵĿ�Ƭ    
        mly 2008-04-25 ���ӻ�������ʾ��������    
 mly 2008-05-07 ���Ӳ���Ĭ��ֵ����ȡ���쳣����    
 mly 2008-07-24 ���ӿ�Ƭ�������Ƶ�order by �ĵ�һ��.    
 mly 2008-10-09 ���Ӵ�ӡ������Ժ��ҩ��С����ʱ����ҽ������ǩ��    
 mly 2009-05-21 סԺ��ҩ��ӡ����������޸ġ� ID:34634    
 jl 2009-06-17 �ּ����װ��λ���水�ּ���װ��񱣴�,�ϲ��ʼõ����汾��BUG    
 jl  2009-12-11 ת�������ӡ�´�λ��BUG    
 --winning-ds-chongqing-20190427�U���R�r��#tempypmx.zdname���L��varchar(32)��varchar(64)���R�r�����Kʹ�ñ������������������ӡ�ԭ�惦�����usp_zyyf_fydy_ex_bak    
 --winning-ds-chongqing-20190522�ı��R�r��#tempypmx.hzxm������ut_name��ut_mc32���R�r�����Kʹ�ñ������������������ӡ�   
**********/    
set nocount on    
--���ɵݽ�����ʱ��    
    
declare @tablename varchar(32)    
select @tablename='##fydy'+@wkdz    
if @jszt=1    
begin    
    exec('if exists(select * from tempdb..sysobjects where name="'+@tablename+'")    
        drop table '+@tablename)    
    exec('create table '+@tablename+'    
     (    
        fyxh ut_xh12 not null, --��ҩ�˵����    
        )')    
    if @@error<>0    
    begin    
select "F","������ʱ��ʱ����"    
     return    
    end    
    select "T"    
    return    
end    
--����ݽ��ļ�¼    
if @jszt=2    
begin    
    declare @cfyxh varchar(12)    
    select @cfyxh=convert(varchar(12),@fyxh)    
    exec('insert into '+@tablename+' values('+@cfyxh+')')    
    if @@error<>0    
    begin    
        select "F","������ʱ��ʱ����"    
        return    
    end    
    select "T"    
 return    
end    
    
declare @zby  ut_bz,  --�Ƿ���ʾ�Ա�ҩ��־ 0��-1��    
  @bmbz  ut_bz,  --�Ƿ���ʾҩƷ������־ 0��-1�ǡ�ת��usp_zyyf_fydy_ex2,usp_zyyf_fydy_ex2_hz    
  @yjflbz ut_bz,  --ҽ���ֵ��ݷ�ҩ��־    
  @ssflbz ut_bz,  --�����ֵ��ݷ�ҩ��־    
  @printfs ut_bz  --�Ƿ�3.Xģʽ��ӡ��ҩ��ϸ0��1��    
  ,@printhz ut_bz  --סԺ��ҩ��ϸ��ӡ����ʾҩƷ����    
                ,@printpxfs ut_bz       --סԺ������ҩ��ӡ����ʽ1����+����2���λ��    
  ,@cardlength int         --��Ƭ��ʾ�ļ�¼����     
select @zby = (case isnull(config,'��') when '��' then -1 else 0 end) from YY_CONFIG(nolock) where id = '7018'    
select @zby = isnull(@zby,'��')    
select @bmbz = (case isnull(config,'��') when '��' then -1 else 0 end) from YY_CONFIG(nolock) where id = '7029'    
select @bmbz = isnull(@bmbz,'��')    
SELECT @yjflbz = (CASE ISNULL(config,'��') WHEN '��' THEN 1 ELSE 0 END) FROM YY_CONFIG(nolock) WHERE id = '7031'    
select @yjflbz = isnull(@yjflbz,'��')    
SELECT @ssflbz = (CASE ISNULL(config,'��') WHEN '��' THEN 1 ELSE 0 END) FROM YY_CONFIG(nolock) WHERE id = '7050'    
select @ssflbz = isnull(@ssflbz,'��')    
Select @printfs = (CASE ISNULL(config,'��') WHEN '��' THEN 1 ELSE 0 END) FROM YY_CONFIG(nolock) WHERE id = '7043'    
select @printfs = isnull(@printfs,'��')    
Select @printhz = (CASE ISNULL(config,'��') WHEN '��' THEN 1 ELSE 0 END) FROM YY_CONFIG(nolock) WHERE id = '7070'    
select @printhz = isnull(@printhz,'��')    
Select @printpxfs = isnull(config,1) From YY_CONFIG(nolock) WHERE id = '7071'     
select @printpxfs = isnull(@printpxfs,1)    
select @cardlength = isnull(config,0) From YY_CONFIG(nolock) WHERE id = '7072'     
select @cardlength = isnull(@cardlength,0)    
--��ʼ�����˵�����ϸ��Ĵ�������    
create table #fydy    
(    
 fyxh  ut_xh12  not null, --��ҩ�˵����    
 lylx  smallint  null,  --��ҩ����(0��ҩ��1ҽ����2��Ժ��ҩ��3Ӥ�����ã�4С������5������ҩ����6ҽ����ҩ����,7��ҩ¼��,8����ҩ��)    
 lylx_sm varchar(16) null,  --��ҩ����˵��    
 djfl  ut_dm4   null,  --���ݷ���    
 djmc  ut_mc32  null,  --��������    
)    
if @fyxh=0--��ҩ�˵���š�0�������ݽ�ģʽYF_ZYFYZD.xh�����������ʵ���ѯģʽYF_ZYFYD.xh     
 exec('insert into #fydy(fyxh) select * from '+@tablename)    
else    
    --mly 2009-05-21 סԺ��ҩ��ӡ����������޸ġ�ȷ�������ύ������ٶ�ȡ��ӡ.�ж�YF_ZYFYZD.jzbz = 1    
 insert into #fydy(fyxh) select distinct fyxh from YF_ZYFYDMX a,YF_ZYFYZD b     
 where a.fyxh = b.xh and b.jzbz in (1,2) and  a.zdxh=@fyxh    
 if @@error<>0    
 begin    
  select "F","������ʱ��ʱ����"    
  return    
 end    
    
update #fydy set lylx=b.lylx,    
    lylx_sm=(case b.lylx when 1 then 'ҽ����ҩ' when 2 then '��Ժ��ҩ' when 3 then 'Ӥ������'    
  when 4 then 'С����' when 5 then '������ҩ' when 6 then 'ҽ����ҩ' when 7 then '��ҩ����'     
  when 8 then '����ҩ��' else '����' end),    
    djfl=CASE WHEN (@yjflbz = 0 AND b.lylx = 6) THEN null WHEN (@ssflbz = 0 AND b.lylx = 5) THEN null ELSE b.djfl END,     
    djmc=CASE WHEN (@yjflbz = 0 AND b.lylx = 6) THEN null WHEN (@ssflbz = 0 AND b.lylx = 5) THEN null ELSE c.name END    
from #fydy a, YF_ZYFYZD b (nolock), BQ_YZDJFLK c (nolock)    
where a.fyxh=b.xh and b.djfl*=c.id    
if @@error<>0    
begin    
    select "F","������ʱ��ʱ����"    
    return    
end    
    
--yxp 2007-10-18 �ϲ������ֳ��޸ĵ�����,���ӿ���7067,סԺ��ҩʱ������Ҫ��ӡ��Ժ��ҩ����Һ���õ�(����̶�Ϊ40)������    
if @fyxh<>0 and exists(select 1 from YY_CONFIG (nolock) where id='7067' and config='��')    
 delete from #fydy where lylx='2' or djfl='40'      
    
--���ɱ�����    
select idm,max(bmmc) bmmc into #temp_bm from YK_YPBMK (nolock) group by idm    
    
if @hzlx=0    --��ҩ��ϸ  ��������  סԺ��  ��λ��  ҩƷ����  ���  ����  ������λ  ʵ������ ��λ  �÷�  Ƶ�� ִ������  ִ��ʱ��    
begin    
 if @fyxh=0--��ҩ�˵���š�0�������ݽ�ģʽ�����������ʵ���ѯģʽ    
     exec('drop table '+@tablename)    
 else  --yxp 2007-09-13 ��ҩ��ӡ��ϸʱ��Ӧ�ù��˵�BQ_YZDJFLK.dybz=1�ļ�¼--��ӡ��־(0��ӡ��ϸ��1������ϸ)����ѯ����̶���ӡ    
  delete #fydy where lylx=1 and exists(select 1 from BQ_YZDJFLK where dybz=1 and BQ_YZDJFLK.id=#fydy.djfl)    
    
    create table #tempypmx    
    (    
     xh ut_xh12 identity(1,1),    
  ksmc ut_mc32 null,--��������    
  hzxm ut_mc32 null,    
  blh  ut_blh     null,    
  cwdm ut_cwdm    null,    
  ypmc ut_mc64 null,    
  ypgg ut_mc32    null,    
  ypjl ut_sl14_3 null,           --ҩƷ����    
  jldw varchar(24)  null,   --������λ---ut_dm4 ̫�̻�ut_mc   
  ypsl ut_sl10 null,           --ʵ������    
  ypdj numeric(12,4) default 0,       
  ypje numeric(12,2) default 0,    
  ypdw varchar(24)   null,   --ҩƷ��λ    
  yfmc ut_mc16 null,     --ҩƷ�÷�����    
  pcdm ut_dm2  null,               
  pc   ut_mc32    null,    
  zxrq ut_rq16 null,    
  zxsj ut_mc64 null,    
  cd_idm ut_xh9   null,    
  ypsl1 ut_sl10 null,           --ÿ������    
  lylx smallint  null,    
  lylx_sm varchar(16) null,    
  djfl ut_dm4  null,    
  djmc ut_mc32  null,    
  yeyz ut_mc16  null, --Ӥ��ҽ��    
  ztnr ut_mc64  null,    
  qqrq ut_rq16  null,    
  fyrq ut_mc32  null,   --���ӷ�ҩ�˵��ķ�ҩ����    
  gmxx varchar(100) null,    
  yzzxrq ut_rq16  null,   --ҽ��ִ������    
  ysdm  ut_czyh  null,  --ҽ������    
  hznl int default 30,   --��������    
  yzxh ut_xh12  null,  --ҽ�����    
  fzxh ut_xh12  null, --�������    
  qqlxsm ut_name  null,  --����/��ʱ    
  yfdm ut_ksdm  null, --ҩ������    
  fyyf  ut_mc32  null, --ҩ������    
      memo ut_memo    null  --��ʾ�Ƿ���� add by zyp    
  ,sex ut_sex  null --mit , 2oo4-1o-28 , �Ա�    
  ,cfts smallint  null --mit , 2oo4-1o-28 , ��ҩ������    
  ,fyczyh ut_czyh null    
      ,lb   int    null   --�����ֶ�1: 3.x��0(��ʱ)1(���ڿڷ�)2(�������)90(������)99(��ҩ�������)    4.0��lylx    
  ,yfdl   ut_dm4  null   --�����ֶ�2: 3.x���÷�����       4.0��djfl    
  ,zqzcbz ut_bz null --ת��ת����־     
  ,lrczyh ut_czyh null     --¼�����Ա�� ת��usp_zyyf_fydy_ex2,usp_zyyf_fydy_ex2_hz    
  ,ypyl  varchar(12) null    --ȥ��.000��ҩƷ����  ת��usp_zyyf_fydy_ex2,usp_zyyf_fydy_ex2_hz    
  ,dwlb   ut_bz   null --��λ��� ת��usp_zyyf_fydy_ex2,usp_zyyf_fydy_ex2_hz    
  ,ybdm   varchar(10) null   --ҽ������ ת��usp_zyyf_fydy_ex2,usp_zyyf_fydy_ex2_hz    
  ,zdname varchar(64) null    -- �������    
  ,ypyfdm ut_dm2 null         --��ϸ�÷�����    
  ,ypyfmc ut_mc32 null        --�����÷�����    
  --,cfztmc ut_mc32 null        --������������    
   ,cfztmc ut_mc256 null        --������������ 
  ,cardrow int    null        --��Ƭ�к�    
  ,dzyzimage image null       --����ӡ��ͼƬ    
  ,qqxh  ut_xh12 null   --�������     
    )        
    
 if exists(select 1 from #fydy where lylx=1)    --ҽ����ҩ��������    
    begin    
        insert into #tempypmx    
        select l.name as ksmc, b.hzxm, c.blh, c.cwdm, a.ypmc, x.ypgg,--m.ksmc a.ypgg    
   (case when b.lz_pcdm is null then b.ypjl else b.lz_mcsl end),b.jldw,    
   (case b.zbybz when 0 then convert(numeric(10,2),a.ypsl/a.dwxs) else 0 end),     
   convert(numeric(12,4),a.ylsj*a.dwxs/a.ykxs),         
            (case b.zbybz when 0 then convert(numeric(12,2),a.ypsl*a.ylsj/a.ykxs) else 0 end),a.ypdw,      
            d.name, b.pcdm, (case isnull(b.lz_pcdm,'') when '' then 'ST' else e.name end),     
            a.qqrq as zxrq,(case b.lz_zxsj when null then '' else b.lz_zxsj end) zxsj,     
            a.cd_idm, (case b.zbybz when 0 then (case when isnull(b.lz_mcsl,0)=0 then b.ypsl else     
   --yxp ������ypsl1����lz_mcsl��ȡʱ����Ҫ�ж�dwlb=3��ֱ�Ӵ���������lz_mcsl/ggxs b.lz_mcsl end) else 0 end ) ypsl,     
   (case when b.dwlb=3 then b.lz_mcsl else b.lz_mcsl/y.ggxs end) end) else 0 end ) ypsl1,    
            f.lylx, f.lylx_sm, f.djfl, f.djmc, (case when b.yexh > 0 then 'Ӥ��' else '' end) yeyz,     
            (case b.zbybz when 0 then b.ztnr else '�Ա�ҩ' end) ztnr, a.qqrq, g.fyrq,    
            (case when b.yexh > 0 then h.gmxx else c.gmxx end) gmxx, m.zxrq as yzzxrq,    
   b.ysdm,datediff(yy,isnull(c.birth,'19700101'),getdate())+1, b.xh, b.fzxh, '��ʱ',    
   --yxp o.name,'' as memo,c.sex,1,g.fyczyh,0 as lb,d.lb as yfdl,0,    
   n.yfdm,o.name,'' as memo,c.sex,1,g.fyczyh,(case when isnull(b.blzbz,0)=1 then 90 else 0 end) as lb,d.lb as yfdl,0,    
   b.lrczyh,'' as ypyl, b.dwlb, c.ybdm,z.zdmc,'','','',0,'',a.qqxh    
        from YF_ZYFYMX a (nolock), BQ_LSYZK b (nolock), ZY_BRSYK c (nolock), ZY_YPYFK d (nolock), ZY_YZPCK e (nolock), #fydy f (nolock),    
   YF_ZYFYD g(nolock), BQ_HZLYD m (nolock),YF_ZYFYZD n(nolock),YF_YFDMK o, ZY_BABYSYK h (nolock),    
   ZY_BRZDQK z(nolock), YK_YPCDMLK y (nolock),BQ_FYQQK x(nolock),ZY_BQDMK l(nolock)    
        where a.fyxh=f.fyxh and a.qqlx=0 and b.xh=a.yzxh and c.syxh=a.syxh and d.id=*b.ypyf and f.lylx=1 and a.zdxh=g.xh    
   and (b.zbybz = @zby or @zby = -1) and a.fyxh=n.xh and m.xh=n.lyxh and b.lz_pcdm*=e.id       
   and n.yfdm=o.id and b.yexh *= h.xh and c.syxh*=z.syxh and z.zdlb=1 and z.zdlx=0    
   and a.cd_idm=y.idm and x.bqdm=l.id and a.qqxh=x.xh    
    
        insert into #tempypmx    
        select l.name as ksmc, b.hzxm, c.blh, c.cwdm, a.ypmc, x.ypgg, --m.ksmc,a.ypgg    
         b.ypjl, b.jldw,     
         (case b.zbybz when 0 then convert(numeric(10,2),a.ypsl/a.dwxs) else 0 end),          
            convert(numeric(12,4),a.ylsj*a.dwxs/a.ykxs),    
            (case b.zbybz when 0 then convert(numeric(12,2),a.ypsl*a.ylsj/a.ykxs) else 0 end), a.ypdw,    
            d.name, b.pcdm, e.name,     
            a.qqrq, (case  when b.zxzqdw=1 then 'ÿ'+convert(varchar(4),b.zxzq)+'Сʱһ��' when b.zxzqdw=2 then 'ÿ'+convert(varchar(4),b.zxzq)+'����һ��' else  b.zxsj end),    
            a.cd_idm, b.ypsl, f.lylx, f.lylx_sm, f.djfl, f.djmc, case when b.yexh > 0 then 'Ӥ��' else '' end yeyz,     
            (case b.zbybz when 0 then b.ztnr else '�Ա�ҩ' end) ztnr ,a.qqrq, g.fyrq,    
   (case when b.yexh > 0 then h.gmxx else c.gmxx end) gmxx,m.zxrq    
   ,b.ysdm,datediff(yy,isnull(c.birth,'19700101'),getdate())+1,b.xh, b.fzxh, '����',    
   n.yfdm,o.name,'',c.sex ,1,g.fyczyh, (case when  b.ypyf  in ("03","04","05")  then 1  else  2  end),d.lb,0,    
   b.lrczyh,'' as ypyl, b.dwlb, c.ybdm,z.zdmc ,'','','',0,'',a.qqxh    
     from YF_ZYFYMX a (nolock), BQ_CQYZK b (nolock), ZY_BRSYK c (nolock), ZY_YPYFK d (nolock), ZY_YZPCK e (nolock), #fydy f (nolock),    
         YF_ZYFYD g(nolock) , BQ_HZLYD m (nolock),YF_ZYFYZD n(nolock),YF_YFDMK o, ZY_BABYSYK h (nolock),    
   ZY_BRZDQK z(nolock),BQ_FYQQK x(nolock),ZY_BQDMK l(nolock)    
        where a.fyxh=f.fyxh and a.qqlx=1 and b.xh=a.yzxh and c.syxh=a.syxh and d.id=*b.ypyf and f.lylx=1 and a.zdxh=g.xh    
   and (b.zbybz = @zby or @zby = -1) and a.fyxh=n.xh and m.xh=n.lyxh and e.id=b.pcdm     
   and n.yfdm=o.id and b.yexh *= h.xh and c.syxh*=z.syxh and z.zdlb=1 and z.zdlx=0 and a.qqxh=x.xh and x.bqdm=l.id    
    end    
    if exists(select 1 from #fydy where lylx in (2))  --��Ժ��ҩ    
    begin    
  insert into #tempypmx    
  select l.name as ksmc, b.hzxm, b.blh, b.cwdm, a.ypmc, x.ypgg  --a.ypgg    
   , convert(numeric(10,2),h.lz_mcsl), h.jldw    
   , convert(numeric(10,2),a.ypsl/a.dwxs)    
   , convert(numeric(12,4),a.ylsj*a.dwxs/a.ykxs),convert(numeric(12,2),a.ypsl*a.ylsj/a.ykxs),a.ypdw    
   , i.name, h.pcdm, case h.lz_pcdm when null then 'ST' else j.name end, a.qqrq, case h.lz_zxsj when null then '' else h.lz_zxsj end zxsj,       
   a.cd_idm,case h.lz_mcsl when 0 then h.ypsl else h.lz_mcsl end ypsl     
   , f.lylx, f.lylx_sm, f.djfl, f.djmc,case when h.yexh > 0 then 'Ӥ��' else '' end yeyz,     
   (case h.zbybz when 0 then h.ztnr else '�Ա�ҩ' end) ztnr      
   , a.qqrq, g.fyrq, b.gmxx,m.zxrq,h.ysdm    
   , datediff(yy,isnull(b.birth,'19700101'),getdate())+1,a.yzxh, a.yzxh, '��ʱ',    
   n.yfdm,o.name,'', b.sex, 1,g.fyczyh ,0 ,0 ,0,    
   h.lrczyh,'' as ypyl, 3 as dwlb, b.ybdm,z.zdmc,'','','',0,s.dzyzimage,a.qqxh    
  from YF_ZYFYMX a (nolock), ZY_BRSYK b (nolock),#fydy f (nolock),    
   YF_ZYFYD g(nolock), BQ_HZLYD m (nolock),YF_ZYFYZD n(nolock), YF_YFDMK o(nolock)    
   ,BQ_LSYZK h (nolock) ,ZY_YPYFK i (nolock), ZY_YZPCK j (nolock),ZY_BRZDQK z(nolock),BQ_FYQQK x(nolock),YY_ZGBMK s(nolock),ZY_BQDMK l(nolock)    
  where a.fyxh=f.fyxh and b.syxh=a.syxh and a.fyxh=n.xh and m.xh=n.lyxh     
   and f.lylx in (2) and a.zdxh=g.xh and n.yfdm=o.id    
   and h.xh=a.yzxh and i.id=*h.ypyf and j.id=*h.lz_pcdm and b.syxh*=z.syxh and z.zdlb=1 and z.zdlx=0    
   and a.qqxh = x.xh and x.ysdm *= s.id and x.bqdm=l.id    
    end    
    if exists(select 1 from #fydy where lylx in (3,4,8))  --Ӥ�����á�С����    
    begin    
        insert into #tempypmx    
        select l.name as ksmc, b.hzxm, b.blh, b.cwdm, a.ypmc, x.ypgg, --m.ksmc,a.ypgg     
         convert(numeric(10,2),a.ypsl/a.dwxs), a.ypdw, convert(numeric(10,2),a.ypsl/a.dwxs),    
            convert(numeric(12,4),a.ylsj*a.dwxs/a.ykxs),convert(numeric(12,2),a.ypsl*a.ylsj/a.ykxs),a.ypdw,    
            '', '', '', a.qqrq, '', a.cd_idm, convert(numeric(10,2),a.ypsl/a.dwxs), f.lylx, f.lylx_sm, f.djfl, f.djmc,'','',a.qqrq,    
   g.fyrq, b.gmxx,m.zxrq,'',datediff(yy,isnull(b.birth,'19700101'),getdate())+1,a.yzxh, a.yzxh, '��ʱ',    
   n.yfdm,o.name,''    
   ,b.sex ,1,g.fyczyh ,0 ,0 ,0,    
   '' as lrczyh,'' as ypyl, 3 as dwlb, b.ybdm,z.zdmc,'','','',0,s.dzyzimage,a.qqxh    
        from YF_ZYFYMX a (nolock), ZY_BRSYK b (nolock), #fydy f (nolock),    
         YF_ZYFYD g(nolock), BQ_HZLYD m (nolock),YF_ZYFYZD n(nolock),YF_YFDMK o(nolock),ZY_BRZDQK z(nolock),BQ_FYQQK x(nolock),YY_ZGBMK s(nolock),ZY_BQDMK l(nolock)    
        where a.fyxh=f.fyxh and b.syxh=a.syxh and a.fyxh=n.xh and m.xh=n.lyxh    
  and f.lylx in (3,4,8) and a.zdxh=g.xh and n.yfdm=o.id and b.syxh*=z.syxh and z.zdlb=1 and z.zdlx=0    
  and a.qqxh = x.xh and x.ysdm *= s.id and x.bqdm=l.id     
    end    
    if exists(select 1 from #fydy where lylx in (5,6))  --ҽ��������    
    begin    
       insert into #tempypmx    
        select l.name as ksmc,b.hzxm, b.blh, b.cwdm, a.ypmc, p.ypgg, --m.ksmc,a.ypgg    
        convert(numeric(10,2),a.ypsl/a.dwxs), a.ypdw, convert(numeric(10,2),a.ypsl/a.dwxs),    
            convert(numeric(12,4),a.ylsj*a.dwxs/a.ykxs),convert(numeric(12,2),a.ypsl*a.ylsj/a.ykxs),a.ypdw,    
            '', '', '', a.qqrq, '', a.cd_idm, convert(numeric(10,2),a.ypsl/a.dwxs), f.lylx, f.lylx_sm, f.djfl, f.djmc,case when p.yexh > 0 then 'Ӥ��' else '' end yeyz,'',a.qqrq,    
   g.fyrq, b.gmxx,m.zxrq,'',datediff(yy,isnull(b.birth,'19700101'),getdate())+1,a.yzxh, a.yzxh, '��ʱ',    
   n.yfdm,o.name,''    
   ,b.sex ,1,g.fyczyh ,0 ,0 ,0,    
   '' as lrczyh,'' as ypyl, 3 as dwlb, b.ybdm,z.zdmc,'','','',0,'',a.qqxh    
        from YF_ZYFYMX a (nolock), ZY_BRSYK b (nolock), #fydy f (nolock),    
         YF_ZYFYD g(nolock), BQ_HZLYD m (nolock),YF_ZYFYZD n(nolock),YF_YFDMK o(nolock),ZY_BRZDQK z(nolock),BQ_YJFYQQK p(nolock),ZY_BQDMK l(nolock)    
        where a.fyxh=f.fyxh and b.syxh=a.syxh and a.fyxh=n.xh and m.xh=n.lyxh    
  and f.lylx in (5,6) and a.zdxh=g.xh and n.yfdm=o.id and b.syxh*=z.syxh and z.zdlb=1 and z.zdlx=0 and a.qqxh=p.xh and p.bqdm=l.id     
    end    
    
    if exists(select 1 from #fydy where lylx in (7))  --��ҩ    
    begin--mit ,2oo4-11-26 ,�Ķ���ҩ,��������,�÷�,Ƶ��    
        insert into #tempypmx     
        select t.name as ksmc, b.hzxm, b.blh, b.cwdm, a.ypmc, k.ypgg  --m.ksmc,a.ypgg    
, convert(numeric(10,2),l.mcjl/a.dwxs), a.ypdw, convert(numeric(10,2),a.ypsl/a.dwxs)    
   , convert(numeric(12,4),a.ylsj*a.dwxs/a.ykxs),convert(numeric(12,2),a.ypsl*a.ylsj/a.ykxs),a.ypdw    
   , d.name, k.pcdm,e.name, a.qqrq, '', a.cd_idm, convert(numeric(10,2),k.mcsl/a.dwxs), f.lylx, f.lylx_sm, f.djfl, f.djmc,'',k.yzzt,a.qqrq    
   , g.fyrq, b.gmxx, m.zxrq,k.ysdm,datediff(yy,isnull(b.birth,'19700101'),getdate())+1,a.yzxh, a.yzxh, '��ʱ',    
   n.yfdm,o.name,m.memo    
      ,b.sex, l.cfts,g.fyczyh,0 ,0 ,0,    
      '' as lrczyh,'' as ypyl, 3 as dwlb, b.ybdm, z.zdmc,l.cfypyf,l.yfmc,l.cfzt,0,'',a.qqxh    
        from YF_ZYFYMX a (nolock), ZY_BRSYK b (nolock), ZY_YPYFK d (nolock)    
            , ZY_YZPCK e (nolock), #fydy f (nolock), YF_ZYFYD g(nolock), BQ_HZLYD m (nolock),YF_ZYFYZD n(nolock),ZY_BQDMK t(nolock)    
            , BQ_FYQQK k(nolock)--agg YF_ZYFYMXK�е�yzxh���ڲ�ҩ���Ӹ�����BQ_FYQQK�е�xh    
      , YF_YFDMK o(nolock), BQ_YS_ZY l(nolock), ZY_BRZDQK z(nolock)      
  where a.fyxh=f.fyxh and b.syxh=a.syxh and a.fyxh=n.xh and m.xh=n.lyxh and a.yzxh=k.xh     
            and k.ypyf*=d.id and k.pcdm*=e.id     
      and f.lylx in (7) and a.zdxh=g.xh and n.yfdm=o.id    
            and k.lyxh*=l.lyxh --yxp 2007-1-16 ��Ϊ*=�����ҩ¼������޸�ʱ������ɹ�������    
      and a.cd_idm*=l.cd_idm --mit , 2oo4-11-o4, �����������,������ظ�    
   and b.syxh*=z.syxh and z.zdlb=1 and z.zdlx=0  and t.id=k.bqdm    
       
 --add by mly 2007-06-15    
 --update #tempypmx set yfmc = b.name from #tempypmx a, ZY_YPYFK b where a.ypyfdm = b.id and b.jlzt = 0    
    end     
       
    if @bmbz=-1--�Ƿ���ʾҩƷ������־��0��-1��    
 begin    
  update b set ypmc=b.ypmc+'('+c.bmmc+')'    
  from #tempypmx b,#temp_bm c where b.cd_idm=c.idm    
 end     

 --add by yangdi 2021.2.23 ������ҩ��ע��Ϣ
 if exists(select 1 from #fydy where lylx in (7))  --��ҩ
 BEGIN
  UPDATE a SET a.ztnr=y.MEMO FROM #tempypmx a
	INNER JOIN dbo.BQ_FYQQK b ON a.qqxh=b.xh
	INNER JOIN dbo.BQ_LSYZK c ON b.yzxh=c.xh
	INNER JOIN CISDB.dbo.CPOE_LSYZK x (NOLOCK) ON c.v5xh=x.XH
	INNER JOIN CISDB.dbo.CPOE_ORDERITEM y (NOLOCK) ON x.XH=y.YZXH
 WHERE y.YPDM=b.ypdm
END
 
 --����ǻ���ֱ�ӴӲ��˷�����ϸ��ȡ jl 20091211    
 create table #tempcwdm(qqxh ut_xh12,cwdm ut_cwdm)    
 insert into #tempcwdm     
 select distinct a.qqxh,c.cwdm from #tempypmx a,ZY_BRSYK b,ZY_BRFYMXK c    
    where a.qqxh=c.qqxh and a.hzxm=b.hzxm and a.yzxh=c.yzxh and a.blh=b.blh and b.syxh=c.syxh and c.idm<>0    
      
 update a set a.cwdm=b.cwdm from #tempypmx a,#tempcwdm b where a.qqxh=b.qqxh     
 --yxp 2005-2-19 ����ת����Ӧ����ʾ��ʱ�Ĵ�λ��Ϣ    
 update a set cwdm=isnull(c.cwdm,a.cwdm), zqzcbz=1    
 from #tempypmx a, ZY_BRSYK b (nolock), BQ_BRZKQQK c (nolock)    
 where a.hzxm=b.hzxm and a.blh=b.blh and b.syxh=c.syxh and b.bqdm=c.bqdm1 and a.yzzxrq <c.qrrq --yxp 2006-5-9 and a.fyrq <c.qrrq     
  and c.jlzt=1    
      
 --mit ,2oo4-12-16 ,����Ѫ͸�ҵ����,���ݺ�ᵱicu����,��λҪ����Ѫ͸�ҵĴ�λ    
 if exists(select 1 from ZY_BQDMK b(nolock), YF_ZYFYZD d(nolock),#fydy c    
   where b.lb=3 and d.bqdm=b.id and d.xh=c.fyxh)    
 begin    
  select max(xh) xh,syxh into #icudjk from BQ_ICUDJK(nolock)  group by syxh    
  select a.syxh, a.icucwdm into #icucwdm from BQ_ICUDJK a(nolock) , #icudjk b where a.xh=b.xh    
     
  select c.hzxm, c.blh, isnull(b.icucwdm,c.cwdm) cwdm    
  into #icudjk1     
  from #icucwdm b, #tempypmx c, ZY_BRSYK d(nolock)     
  where c.hzxm=d.hzxm and c.blh=d.blh and brzt not in (0,3,8,9) and d.syxh=b.syxh    
     
  update #tempypmx    
  set cwdm=b.cwdm    
  from #tempypmx a, #icudjk1 b    
  where a.hzxm=b.hzxm and a.blh=b.blh and b.cwdm is not null      
 end    
    
 ---�ϲ�����ʡ�� 2006-03-08    
 update  a    
 set ypyl = (case when a.lylx = 2 then convert(varchar(12),convert(numeric(12,3),ypsl1))        
   else (case a.dwlb when 0 then convert(varchar(12),convert(numeric(12,3),(a.ypjl/b.ggxs)))         
   else convert(varchar(12),convert(numeric(12,3),(a.ypjl/b.zyxs))) end) end)    
 from #tempypmx a, YK_YPCDMLK b (nolock)    
 where a.cd_idm=b.idm                 
    
 --ȥ��ypyl�е�'.000'    
 update  #tempypmx  set ypyl=replace(ypyl,'.000','')    
    
 --���ӿ�Ƭ��ʾ�ļ�¼����    
 if @cardlength > 0     
 begin    
  declare @cardno int --��¼��Ƭ��    
  declare @i int      --��¼ÿ�ſ�Ƭ�м�����¼    
  declare @c_oldcwdm ut_cwdm    
      
  declare @c_count int      
  declare @c_cwdm ut_cwdm    
  declare @c_xh ut_xh12    
    
  --��ʱ��Ƭ ������ʱ���ڿ�Ƭ���֣������Ҫ��ʱ�������ֿ�Ƭ����Ҫ��������    
  select xh,cwdm into #card_ls from #tempypmx order by cwdm--where qqlxsm ='��ʱ'    
  select @cardno = 0,@i = 0,@c_oldcwdm = '0'        
  declare ypmx_cur cursor     
                for select xh,cwdm from #card_ls     
                order by cwdm     
  open ypmx_cur    
  fetch ypmx_cur into @c_xh,@c_cwdm    
  while (@@fetch_status = 0)    
  begin    
   if @c_cwdm <> @c_oldcwdm  --��λ���벻���ھɵĴ�λ���������¿�ʼ���ſ�Ƭ��    
   begin    
    select @i = 0    
    select @cardno = @cardno + 1    
   end    
   if @i >= @cardlength     --���һ�ſ�Ƭ�е����ݵ���ÿ�еļ�¼����Ƭ����1��¼��    
   begin       
        select @i = 0    
        select @cardno = @cardno + 1    
   end    
    
   update #tempypmx    
   set cardrow = @cardno    
   where xh = @c_xh    
       
        
   select @i = @i + 1    
   select @c_oldcwdm = @c_cwdm    
   fetch ypmx_cur into @c_xh,@c_cwdm    
  end    
  close ypmx_cur    
  deallocate ypmx_cur      
  /*    
  --���ڿ�Ƭ    
  select xh,cwdm into #card_cq from #tempypmx where qqlxsm ='����'    
  select @i = 0,@c_oldcwdm = '0'        
  declare ypmx_cur cursor     
                for select xh,cwdm from #card_cq     
                order by cwdm     
  open ypmx_cur    
  fetch ypmx_cur into @c_xh,@c_cwdm    
  while (@@fetch_status = 0)    
  begin    
   if @c_cwdm <> @c_oldcwdm  --��λ���벻���ھɵĴ�λ���������¿�ʼ���ſ�Ƭ��    
   begin    
    select @i = 0    
    select @cardno = @cardno + 1    
   end    
   if @i >= @cardlength     --���һ�ſ�Ƭ�е����ݵ���ÿ�еļ�¼����Ƭ����1��¼��    
   begin       
        select @i = 0    
        select @cardno = @cardno + 1    
   end    
             
   update #tempypmx    
   set cardrow = @cardno    
   where xh = @c_xh    
    
   select @i = @i + 1    
   select @c_oldcwdm = @c_cwdm    
   fetch ypmx_cur into @c_xh,@c_cwdm    
  end    
  close ypmx_cur    
  deallocate ypmx_cur     
  */    
     
 end    
      
 --yxp 2007-10-21 ���ӿ���7070���ܣ�סԺ��ҩ��ϸ��ӡ����ʾҩƷ����    
 if @printhz =1    
 begin    
  --yxp 2007-10-21 ��3.xϰ���޸ģ�������7043�������������ĸ�ҩʱ��ָ���Ϊ-    
  update #tempypmx  set zxsj=replace(substring(zxsj,1,(case when len(zxsj)>=1 then (len(zxsj)-1) else 0 end)),',','-')    
    
  update  #tempypmx  set  lb=99  where   ypsl<0--yxp 2008-1-9 �ڿ���7070��ʱ,ʵ�ֽ���ҩ��Ϣ�������Ĺ���    
  update  #tempypmx  set  lb=-1  where   lb in (1,2) and ypsl>=0--����Ϊ���ڣ���ʱ����Ժ��ҩ�����ڵ�����Ϊ-1    
  update  #tempypmx  set  yfdl='0'    
    
  select rtrim(cwdm)+'['+rtrim(hzxm)+']'+rtrim(blh) "����[��������]", blh "סԺ��",    
     rtrim(a.ypmc)+ '['+rtrim(a.ypgg)+']' "ҩƷ����[���]" , rtrim(convert(varchar(12),a.ypjl))+rtrim(jldw) "����",     
     convert(numeric(12,2),ypsl1)  "ÿ������",    
     a.yfmc "�÷�", a.pc "Ƶ��", a.zxsj "��ҩʱ��", rtrim(convert(varchar(12),sum(a.ypsl)))+rtrim(a.ypdw) "ʵ��",    
     a.lylx, a.lylx_sm "��ҩ����", 
	-- a.djfl, 
	 a.djmc "��������",a.ypdj "ҩƷ����",sum(a.ypje) "ҩƷ���",a.yeyz "�Ƿ�Ӥ��ҽ��",     
     a.ztnr "ҽ������",sum(ypsl) ypsl,ypdw,b.ggdw,b.ggxs*ypsl1 as ypjl , b.ggxs    
  ,b.ypdm,cwdm "����",cardrow--������λ�ţ�Add By Lingzhi ,2003.07.22    
  ,substring(a.fyrq,1,4)+'-'+substring(a.fyrq,5,2)+'-'+substring(a.fyrq,7,2)+' '+substring(a.fyrq,9,8) "��ҩ����"--סԺ��ҩ�˵��ķ�ҩ���� add by wuming 2004-02-01    
  , a.gmxx,a.ysdm ҽ������,a.hznl ��������, a.fzxh, a.qqlxsm,    
     a.memo "�Ƿ����",e.name "����ҽ��",f.name "��ҩ����Ա"--add by zyp   2004.11.03 ��ʾ����    
  ,a.sex "�Ա�", a.cfts "��������",a.lb,case when isnull(a.zqzcbz,0)=0 then "" else "ת" end "ת��ת����־"    
  ,b.cjmc "��������",a.lrczyh,a.ksmc ksmc,e.name "ҽ������",rtrim(a.ypmc) "ҩƷ����",    
  case charindex('*',a.ypgg) when 0 then a.ypgg else rtrim(left(a.ypgg,charindex('*',a.ypgg)-1)) end "ҩƷ���",     
     rtrim(a.hzxm) "��������",c.ybsm "ҽ��˵��" ,    
     case when (g.zxzqdw=0) then convert(varchar(5),g.zxzq)+'��'+convert(varchar(5),g.zxcs)+'��'    
     when (g.zxzqdw=-1) then 'ÿ��'+rtrim(ltrim(g.zbz))+',ÿ��'+convert(varchar(5),g.zxcs)+'��'    
     when (g.zxzqdw=1) then 'ÿ��'+rtrim(ltrim(g.zxzq))+'Сʱ'    
     when (g.zxzqdw=2) then 'ÿ��'+rtrim(ltrim(g.zxzq))+'��' end "ִ�д���", a.zdname "�������",a.ypyfmc "�����÷�",a.cfztmc "��������"     
  , a.pcdm,a.yzxh,a.yfdl,b.py--yxp 2007-10-21 ����ҩƷƴ���Ĵ���    
  , h.cfwz--yxp 2008-1-22 ��ҩ��ϸ�嵥������ҩƷ�Ĵ��λ���ֶεĴ���     
  from #tempypmx a,YK_YPCDMLK b (nolock),YY_YBFLK c (nolock), #temp_bm d (nolock),YY_ZGBMK e (nolock),czryk f (nolock)      
   ,ZY_YZPCK g (nolock), YF_YFZKC h (nolock)    
  where a.cd_idm = b.idm and a.ybdm=c.ybdm and a.cd_idm*=d.idm and a.ysdm*=e.id and a.fyczyh*=f.id    
   and a.pcdm*=g.id  and a.cd_idm=h.cd_idm and a.yfdm=h.ksdm    
  group by  g.zbz,b.ypdm,cwdm,cardrow,hzxm,blh,b.ggdw,a.ypmc,a.ypgg,a.yfmc,a.pc,a.zxsj,a.ypdw,a.lylx,a.lylx_sm
  ,a.djfl
  ,a.djmc,a.ypdj,    
   a.yeyz,a.ztnr,b.ggxs,  ypsl1,  a.fyrq, a.gmxx, a.ysdm, a.hznl, a.fzxh, a.qqlxsm,    
   a.memo, e.name, f.name, a.sex, a.cfts, a.lb, a.zqzcbz,b.cjmc, a.lrczyh,a.ksmc,e.name ,rtrim(a.ypmc) ,    
   c.ybsm , g.zxzqdw, g.zxzq, g.zxcs, a.zdname ,a.ypyfmc ,a.cfztmc , b.py, a.pcdm, a.yzxh, a.yfdl, a.ypjl, a.jldw    
   ,h.cfwz    
  order by a.lb, a.yfdl, convert(int,a.cwdm),a.yfmc,fzxh,a.yzxh, b.ypdm, a.pcdm  -- mly 2008-07-24 ���ӿ�Ƭ�������Ƶ���һ��     
  return    
 end    
      
 if @printfs =1 --�Ƿ�3.Xģʽ��ӡ��ҩ��ϸ0��1�� ��Ҫ������ʽ��һ��    
 begin    
  update  #tempypmx  set  lb=99  where   ypsl<0    --yxp update    
  update  #tempypmx  set  yfdl='0'  where  yfdl not in ('0','1','2','3')      
    
  --yxp 2007-10-21 ��3.xϰ���޸ģ�������7043�������������ĸ�ҩʱ��ָ���Ϊ-    
  update #tempypmx  set zxsj=replace(substring(zxsj,1,(case when len(zxsj)>=1 then (len(zxsj)-1) else 0 end)),',','-')    
 end    
 else    
 begin    
  update  #tempypmx  set  lb=lylx    
  update  #tempypmx  set  yfdl=djfl    
 end    
    
 select d.bmmc ,rtrim(cwdm)+'['+rtrim(hzxm)+']'+rtrim(blh) "����[��������]", blh "סԺ��",    
     rtrim(a.ypmc)+ '['+rtrim(a.ypgg)+']' "ҩƷ����[���]" , rtrim(convert(varchar(12),a.ypjl))+rtrim(jldw) "����",     
     convert(numeric(12,2),ypsl1)  "ÿ������",    
     a.yfmc "�÷�", a.pc "Ƶ��", a.zxsj "��ҩʱ��", rtrim(convert(varchar(12),a.ypsl))+rtrim(a.ypdw) "ʵ��",    
     a.lylx, a.lylx_sm "��ҩ����", a.djfl, a.djmc "��������",a.ypdj "ҩƷ����",a.ypje "ҩƷ���",a.yeyz "�Ƿ�Ӥ��ҽ��",     
     a.ztnr "ҽ������",a.qqrq "��������",ypsl,ypdw,b.ggdw,b.ggxs*ypsl1 as ypjl     
  ,b.ypdm,cwdm "����",cardrow--������λ�ţ�Add By Lingzhi ,2003.07.22    
  ,substring(a.fyrq,1,4)+'.'+substring(a.fyrq,5,2)+'.'+substring(a.fyrq,7,2)+' '+substring(a.fyrq,9,8) "��ҩ����"--סԺ��ҩ�˵��ķ�ҩ���� add by wuming 2004-02-01    
  , a.gmxx,a.yzzxrq "ҽ��ִ������",a.ysdm ҽ������,a.hznl ��������, a.fzxh, a.qqlxsm,    
    a.memo "�Ƿ����",e.name "����ҽ��",f.name "��ҩ����Ա",--add by zyp   2004.11.03 ��ʾ����    
  rtrim(a.ypmc)+ '['+     
      LTrim(RTrim(Case When b.ggxs>=1 And Floor(b.ggxs)*10=Floor(b.ggxs*10) Then  Str(b.ggxs,12,0)     
      When b.ggxs>=1 And Floor(b.ggxs*10)*10=Floor(b.ggxs*100) Then  Str(b.ggxs,12,1)      
      When b.ggxs<1 And Floor(b.ggxs*10)*10=Floor(b.ggxs*100) Then Str(b.ggxs,12,1)      
      When b.ggxs<1 And Floor(b.ggxs*100)*10=Floor(b.ggxs*1000) Then Str(b.ggxs,12,2)      
      When b.ggxs<1 And Floor(b.ggxs*1000)*10=Floor(b.ggxs*10000) Then Str(b.ggxs,12,3)     
      Else Str(b.ggxs,12,4) end ))+ LTrim(RTrim(b.ggdw))+ ']' "ҩƷ����[����]",a.fyyf "��ҩҩ��"    
  ,a.sex "�Ա�", a.cfts "��������",a.lb,case when isnull(a.zqzcbz,0)=0 then "" else "ת" end "ת��ת����־"    
  ,b.cjmc "��������",a.lrczyh,a.ksmc ksmc,e.name "ҽ������",rtrim(a.ypmc) "ҩƷ����",    
  case charindex('*',a.ypgg) when 0 then a.ypgg else rtrim(left(a.ypgg,charindex('*',a.ypgg)-1)) end "ҩƷ���",     
     rtrim(a.hzxm) "��������",c.ybsm "ҽ��˵��" ,    
     case when (g.zxzqdw=0) then convert(varchar(5),g.zxzq)+'��'+convert(varchar(5),g.zxcs)+'��'    
     when (g.zxzqdw=-1) then 'ÿ��'+rtrim(ltrim(g.zbz))+',ÿ��'+convert(varchar(5),g.zxcs)+'��'    
     when (g.zxzqdw=1) then 'ÿ��'+rtrim(ltrim(g.zxzq))+'Сʱ'    
     when (g.zxzqdw=2) then 'ÿ��'+rtrim(ltrim(g.zxzq))+'��' end "ִ�д���", a.zdname "�������",a.ypyfmc "�����÷�",a.cfztmc "��������"     
     ,b.py--yxp 2007-10-21 ����ҩƷƴ���Ĵ���    
  , h.cfwz--yxp 2008-1-22 ��ҩ��ϸ�嵥������ҩƷ�Ĵ��λ���ֶεĴ���    
  ,a.dzyzimage     
    from #tempypmx a,YK_YPCDMLK b (nolock),YY_YBFLK c (nolock), #temp_bm d (nolock),YY_ZGBMK e (nolock),czryk f (nolock)      
  ,ZY_YZPCK g (nolock), YF_YFZKC h (nolock)      
    where a.cd_idm = b.idm and a.ybdm=c.ybdm and a.cd_idm*=d.idm and a.ysdm*=e.id and a.fyczyh*=f.id    
  and a.pcdm*=g.id  and a.cd_idm=h.cd_idm and a.yfdm=h.ksdm    
 order by a.cardrow,a.lb, a.yfdl, a.cwdm,a.yfmc,fzxh,a.yzxh, b.ypdm, a.pcdm  -- mly 2008-07-24 ���ӿ�Ƭ�������Ƶ���һ��       
end    
    
if @hzlx=1    --������ϸ   ҩƷ����  ���  ����    ���� ��λ    
begin    
 --yxp 2007-3-22 declare @fyyfdm ut_ksdm    
 declare @ksmc varchar(50)    
     
     
 if @fyxh=0--��ҩ�˵���š�0�������ݽ�ģʽYF_ZYFYZD.xh�����������ʵ���ѯģʽYF_ZYFYD.xh    
  --yxp 2007-3-22 select @fyyfdm=''  --a.ksmc �ʼõ����汾������ʾ����ȷ,�����汾Ҳ����һ��     
  select @ksmc = d.name from BQ_HZLYD a(nolock) ,YF_ZYFYZD b(nolock) ,#fydy c(nolock),ZY_BQDMK d(nolock)     
  where a.xh=b.lyxh and c.fyxh=b.xh AND b.bqdm=d.id    
 else    
  --yxp 2007-3-22 select @fyyfdm=yfdm from YF_ZYFYD (nolock) where xh=@fyxh    
  select @ksmc = d.name from BQ_HZLYD a(nolock) ,YF_ZYFYZD b(nolock) ,YF_ZYFYDMX c(nolock),ZY_BQDMK d(nolock)     
  where a.xh=b.lyxh and c.fyxh=b.xh and c.zdxh = @fyxh AND b.bqdm=d.id    
     
 select g.yfdm, c.name jxmc, rtrim(a.ypmc)+(case isnull(a.memo,'') when '' then '' else '����'+rtrim(a.memo) end) ypmc,    
     sum(convert(numeric(10,2),a.ypsl/a.dwxs)) ypsl,a.ypdw, a.ypgg, b.cjmc,    
     convert(numeric(12,2),sum(a.ypsl*a.ylsj/a.ykxs)) je,f.lylx, f.lylx_sm, f.djfl, f.djmc,    
     b.ypdm,convert(numeric(12,4),avg(a.ylsj*a.dwxs/a.ykxs)) ypdj,b.idm cd_idm,h.ypmc ggmc, b.py    
 into #yphz    
 from YF_ZYFYMX a (nolock), YK_YPCDMLK b (nolock), YK_YPJXK c (nolock),#fydy f(nolock),    
  YF_ZYFYD g(nolock), YK_YPGGMLK h(nolock)     
 where a.fyxh=f.fyxh and b.idm=a.cd_idm and c.id=*b.jxdm and a.zdxh=g.xh and b.gg_idm=h.idm     
  and (a.syxh = @syxh or @syxh = 0 )    
  and (@zby = -1 or rtrim((isnull(a.memo,''))) <> '�Ա�ҩ')    
 group by g.yfdm, c.name, f.lylx, f.lylx_sm, f.djfl, f.djmc, a.ypmc, a.ypgg, a.ypdw, b.cjmc    
  ,b.ypdm, a.memo,b.idm,h.ypmc, b.py    
     
        if @bmbz=-1--�Ƿ���ʾҩƷ������־��0��-1��    
 begin    
  update b set ypmc=b.ypmc+'('+c.bmmc+')'    
  from #yphz b,#temp_bm c where b.cd_idm=c.idm    
 end     
    
 --���ݲ����ı��������һ��2��SQLֻ������ͬ    
 if @printpxfs = 1    
 begin 

 
       select a.cd_idm, a.ypdm, c.bmmc, a.jxmc "����",     
  a.ypmc  "ҩƷ����",         
  sum(a.ypsl) "����", a.ypdw "��λ", sum(a.ypsl)  ypsl, a.ypdw, a.ypgg "���"    
  , a.cjmc "����", sum(a.je) "���", a.lylx, a.lylx_sm "��ҩ����"    
  --, a.djfl
 -- , a.djmc "��������"
 , a.ypdm, a.ypdj "����", a.cd_idm     
  , b.cfwz, a.yfdm, @ksmc as ksmc,a.ggmc "ͨ����", a.py    
 from #yphz a, YF_YFZKC b(nolock), #temp_bm c     
 where a.yfdm=b.ksdm and a.cd_idm=b.cd_idm and a.cd_idm*=c.idm    
  and a.ypsl<>0 --yxp 2008-3-20 ������ҩ�񡯵Ļ���ҩƷ��¼��ʾʱ������ʾ������Ϊ0�ļ�¼    

  group by a.cd_idm, a.ypdm, c.bmmc, a.jxmc ,     
  a.ypmc ,   a.ypdw , a.ypdw, a.ypgg     
  , a.cjmc ,  a.lylx, a.lylx_sm  , 
 a.ypdm, a.ypdj , a.cd_idm     
  , b.cfwz, a.yfdm ,a.ggmc , a.py    
 order by a.lylx,b.cfwz    
 end

 else    
        select a.cd_idm, a.ypdm, c.bmmc, a.jxmc "����",     
  a.ypmc "ҩƷ����",         
sum(a.ypsl) "����", a.ypdw "��λ", sum(a.ypsl) ypsl, a.ypdw, a.ypgg "���"    
  , a.cjmc "����", sum(a.je)"���", a.lylx, a.lylx_sm "��ҩ����"    , 
  --a.djfl, 
  a.ypdm, a.ypdj "����", a.cd_idm     
  , b.cfwz, a.yfdm, @ksmc as ksmc,a.ggmc "ͨ����", a.py    
 from #yphz a, YF_YFZKC b(nolock), #temp_bm c     
 where a.yfdm=b.ksdm and a.cd_idm=b.cd_idm and a.cd_idm*=c.idm    
  and a.ypsl<>0 --yxp 2008-3-20 ������ҩ�񡯵Ļ���ҩƷ��¼��ʾʱ������ʾ������Ϊ0�ļ�¼    
  group by a.cd_idm, a.ypdm, c.bmmc, a.jxmc ,     
  a.ypmc ,   a.ypdw , a.ypdw, a.ypgg     
  , a.cjmc ,  a.lylx, a.lylx_sm  , 
 a.ypdm, a.ypdj , a.cd_idm     
  , b.cfwz, a.yfdm ,a.ggmc , a.py    


 order by a.lylx,b.cfwz    
    
end    
return    
    
    
    




