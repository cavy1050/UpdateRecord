ALTER proc usp_his5_outp_savesqd        
(        
@wkdz   varchar(32)   --������ַ              
,@czzt   int    --����״̬1=������2=�������뵥���ݣ�3=�����շ���Ϣ 4���ݽ� 9 =����              
,@xtlb   int=0   --��� 0= ����, 1=סԺ 3���        
,@yzxh   ut_xh12=0   --ҽ�����            
,@sqdxh   ut_xh12=0   --���뵥���              
,@mbxh   ut_xh12=0   --ģ����ϸ���              
,@ysdm   ut_czyh=''   --ҽ������              
,@sqks   ut_ksdm=''   --�������              
,@zxks   ut_ksdm=''   --ִ�п���              
,@ywxh   ut_xh12=0   --@lb =0 �Һ���ţ�1סԺ��ҳ��� 3�����Ա���        
,@cpatid  ut_xh12=0   --����patid        
,@emrsqdxh  ut_xh12=0   --emr�е����뵥��š����Ϊ��������Ϊ����          
,@frmcode  int=0    --���뵥������              
,@dataset  ut_mc64=''        
,@fieldname  ut_mc64=''        
,@vclcaption ut_mc64=''        
,@valuedm  varchar(200)=''        
,@value   varchar(1000)=''        
,@vcltype  ut_mc64=''        
,@vclname  ut_mc64=''        
,@taborder  ut_bz=0        
--������ǰ��              
-- @zhid   int          =0,   --��ϴ���              
-- @zhmc  varchar(200) ='',  --�������              
-- @memo   varchar(200) ='',  --��ע           
--          
--���뵥��Ŀ����          
,@kxmdm   ut_xmdm=''   --��Ŀ����            
,@kxmmc   ut_mc64=''   --��Ŀ����            
,@kxmlb   int=0    --��Ŀ��� 0 �շ���Ŀ 1 �ٴ���Ŀ            
,@kxmsl   int=0    --��Ŀ����            
--            
,@gxbz   ut_bz=0    --�����޸ı�־              
,@ghlb   ut_bz=-1   --�Һ����              
,@mjzsm   ut_name=''   --�ż���˵��                
,@yjjzbz  ut_bz=0    --�����־              
,@yexh   ut_xh12=0   --Ӥ�����            
,@copybz  ut_bz=0    --���Ʊ�־��0������1����           
,@bzdm   ut_zddm=null  --���ִ���        
,@bzmc   ut_mc32=null  --��������        
,@ybkz   varchar(200)=NULL --ҽ���������Ʊ�־        
,@groupno  INT=-1    --���        
,@kybz   ut_bz=0    --���б�־        
,@cfmedtype  ut_dm4=''   --����ҽ�����        
,@cfmedtypemc ut_mc32=''   --����ҽ���������        
,@cftszddm  ut_zddm=''   --�����������        
,@cftszdmc  ut_mc32=''   --�ز�����         
,@cfybbfz  ut_mc32=''   --����֢        
,@cfybbfzmc  ut_mc32=''   --����֢����        
,@v5xh   ut_xh12=0   --50�����뵥��ϸ���        
,@shbz7         ut_bz     --��˱�־7         
,@sqdlb         ut_dm4=''           --���뵥���        
,@mbbz          ut_bz=0    --������־        
,@zfbz          ut_bz=0    --���뵥�Էѱ�־        
,@yzxrq         ut_rq8=''           --Ԥִ������        
,@gsbz       ut_bz=0            --���˱�־        
,@lxbz        ut_bz=0            --���ݱ�־        
,@zfcfbz        ut_bz=0            --�ԷѴ�����־        
,@shid          varchar(max) = '' --���id         
,@cfybzddm  ut_mc64=''   --����ҽ����ϴ���           
,@cfybzdmc  ut_mc256=''   --����ҽ���������         
,@buweimemo  ut_memo=''   --��λ��ע��Ϣ          
)        
as        
declare  @tablename_sqd varchar(32),              
--   @tablename_sfzh varchar(32),             
@tabname_sfmx varchar(50),        
@tabname_ybkz varchar(50),           
@sql varchar(5000),              
@pxbz ut_xh9              
        
declare  @patid ut_xh12,              
@now varchar(16),              
@sqdxh2 ut_xh12,  --���뵥���              
@url ut_mc64,              
--�����������ﻮ�۴�����α긳ֵ              
@cxmdm ut_xmdm, --��Ŀ����              
@cxmsl int,     --��Ŀ����              
@clcxmdm ut_xmdm ,--�ٴ���Ŀ����              
@sfksdm ut_ksdm , --�շѿ��Ҵ���              
@bzsm ut_mc64,  --��ע˵��              
@xmdw ut_unit, --��Ŀ��λ                
@ylsj ut_money,  --ҩ���ۼ�              
@dxmdm ut_kmdm,  --����Ŀ����              
@cfysdm ut_czyh, -- ����ҽ������        
@cv5xh ut_xh12,        
@cmxjjbz ut_bz,   --��Ŀ��ϸ�Ӽ���־        
@cmemo  ut_mc256,  --��Ŀ��ϸ��ע        
@ypfj ut_money,  --ҩ������        
@yzxrq2 ut_rq8,        
@buweimemo2 ut_memo,         
@zfcfbz2 ut_bz        
--���¶������ﻮ�۴�������ı���                
declare  @djbz ut_bz,              
@djje ut_money,              
@is_prepay   int,       --�Ƿ�ʹ��Ԥ���� 0��1��              
@jzbz ut_bz,     --�Ƿ������۹�Ԥ���� 0��1��              
@config_1058 char(2),    --��ֵ�������Ƿ���������շ�              
@yzbrk_yjye  ut_money,  --���˲��˿��е�Ѻ�����              
@cfje ut_money,     --��ǰ�������              
@xhtemp ut_xh12,         
@mxxhtemp ut_xh12, --cfmxk.xh add by zc 20100705 for ҽ�����Ʊ�־            
@hzxm  ut_mc64,              
@py    ut_py,             
@wb  ut_py,              
@ybdm   ut_ybdm,              
@config_H125 char(2),   --��ֵ�������Ƿ������¼�롣              
@strmsg varchar(255),    --��ʾ��Ϣ         
@cshid varchar(max)            
--���¶��岡��ҽ����������ı���                
declare  @bqdm ut_ksdm,              
@ksdm ut_ksdm,              
--  @xmmc ut_mc32,              
@cgyzbz ut_bz,              
@yjqrbz ut_bz,              
@djfl ut_dm4, --���ݷ���              
@yzdjfl ut_dm4,         
@errmsg varchar(50),               
@yzzt ut_bz,              
@yzzxbz varchar(2)               
declare  @zkpatid ut_xh12,              
@config_9022 varchar(4)        
        
select @strmsg = ''         
        
--����Ϊ���� url����              
declare  @urlbz ut_bz,              
--����Ϊ����63251�����޸�����           
@config_2147 varchar(4), --�Ƿ���ƻ��۴�������ϸ��Ŀ        
@config_2149 int,   --�����ϸ��        
@hjcfxhtemp int,   --���۴��������        
@hjcfindex int    --���۴�����ϸ���        
--end add by lls        
        
if @copybz=1            
select @sqdxh=0,@yzxh=0      
    
DECLARE @config_H172 ut_bz      --���Ӵ���    
SELECT  @config_H172 = ( SELECT CASE WHEN config = '��' THEN 1      
     ELSE 0  END   FROM   YY_CONFIG  WHERE  id = 'H172' )    
    
        
if @czzt = 9 --���ϵ���              
begin           
if  not exists(select 1 from  SF_MZSQD where blsqdxh =@emrsqdxh )             
begin              
select 'F', 'û�����뵥�����ϣ�����ѡ�����뵥�����ϣ�'              
return              
end           
        
select @sqdxh =xh from SF_MZSQD where blsqdxh =@emrsqdxh           
select @now = convert(varchar(8),getdate(),112) + convert(varchar(8),getdate(),108)          
        
if @xtlb in (0,3)              
begin              
select @patid = patid from SF_MZSQD where xh = @sqdxh and jlzt = 0 ---and qrbz = 0              
if @@rowcount = 0              
begin              
select 'F','δ�ҵ���Ӧ�����뵥��Ϣ,�����Ѿ��շѻ�ȷ��!'              
return              
end         
if exists(select 1 from SF_HJCFK where patid = @patid and sqdxh = @sqdxh and jlzt=1)              
begin        
update SF_HJCFMXK set tfbz=1 where cfxh in (select xh from SF_HJCFK where patid = @patid and sqdxh = @sqdxh and jlzt=1)        
select 'F','�����뵥�Ѿ��շ�,�Ѹ����˷ѱ�־!'              
return                 
end             
if exists(select 1 from SF_HJCFK where patid = @patid and sqdxh = @sqdxh and jlzt not in (0,1,2))              
begin              
select 'F','�����뵥�Ѿ��շѻ�ȷ�ϣ���������!'              
return                 
end              
select @cfje = isnull(sum(djje),0) from SF_HJCFK (nolock)         
where patid = @patid and sqdxh = @sqdxh and jlzt = 0 and djbz = 1 and jzbz = 1          
if exists(select 1 from YY_CONFIG where id='H353' and config='��')        
select @cfje=0        
--����������Ϣ              
exec usp_yy_cxjzbrzk @patid, 1, @zkpatid output              
if @zkpatid = 0 select @zkpatid = @patid        
        
begin tran          
        
if @cfje <> 0               
begin              
update SF_HJCFK set djbz = 0,jzbz = 0 where patid = @patid and sqdxh = @sqdxh and jlzt = 0 and djbz = 1 and jzbz = 1              
if @@error <> 0               
begin              
select 'F','���¼��ʱ�־ʧ�ܣ�'              
rollback tran              
return              
end            
        
update YY_JZBRK set djje = djje - @cfje where patid = @zkpatid               
if @@error <> 0               
begin              
select 'F','���¼��ʽ��ʧ�ܣ�'            
rollback tran            
return            
end            
end            
        
update SF_HJCFK set jlzt = 2 where patid = @patid and sqdxh = @sqdxh and jlzt = 0            
if @@error <> 0            
begin            
select 'F','���»��۴���ʧ�ܣ�'              
rollback tran            
return  
end            
        
update SF_MZSQD set jlzt = 1,zfczyh=@ysdm,zfrq = @now where xh = @sqdxh              
if @@error <> 0               
begin            
select 'F','�������뵥״̬ʧ�ܣ�'              
rollback tran              
return              
end         
    
---������ϷѼ���                
IF @config_H172 = 1       
BEGIN                               
EXEC usp_mz_ys_jyclldcl @patid = @patid, @sqks = @sqks, @zxks = @zxks, @ghxh = @ywxh, @czyh = @ysdm              
IF @@error <> 0       
BEGIN                    
SELECT  'F', '�����������ϳ���1��'                    
ROLLBACK TRAN                            
RETURN                      
END                  
END     
  
        
commit tran              
select 'T','���³ɹ�!'             
return              
end              
else             
begin            
select @patid = syxh,@yexh=isnull(yexh,0) from ZY_BRSQD (nolock) where xh = @sqdxh and jlzt = 0 and qrbz = 0            
if @@rowcount = 0            
begin            
select 'F','δ�ҵ���Ӧ�����뵥��Ϣ,�����Ѿ��շѻ�ȷ��!'            
return            
end            
if exists(select 1 from BQ_LSYZK where syxh = @patid and sqdxh = @sqdxh and yzzt <> 0         
and yexh=@yexh)            
begin            
select 'F','�����뵥�Ѿ���ˣ���������!'            
return               
end            
        
begin tran            
        
delete from BQ_LSYZK where syxh = @patid and sqdxh = @sqdxh and yzzt = 0 and yexh=@yexh            
if @@error<>0            
begin            
select 'F','����ҽ����Ϣʧ�ܣ�'            
rollback tran            
return              
end         
        
update ZY_BRSQD set jlzt = 1,zfczyh=@ysdm,zfrq = @now where xh = @sqdxh            
if @@error <> 0             
begin            
select 'F','�������뵥״̬ʧ�ܣ�'            
rollback tran            
return            
end          
        
update BQ_YJQQK set jlzt = 4 where sqdxh = @sqdxh and isnull(yexh,0)=@yexh            
if @@error <> 0             
begin            
select 'F','�������뵥״̬ʧ�ܣ�'            
rollback tran            
return            
end           
        
commit tran            
select 'T','���³ɹ�!'            
return        
end        
select 'F','δ�����κ����뵥'        
return                  
end              
        
select @tablename_sqd='##sqdxx'+@wkdz,                  
@tabname_sfmx = '##sqdxmzhxy'+rtrim(@wkdz)+rtrim(@ysdm),        
@tabname_ybkz = '##ybkz'+rtrim(@wkdz)+rtrim(@ysdm)               
select @url=isnull(config,'') from YY_CONFIG (nolock) where id='0104'              
declare @month int        
declare @month_str varchar(2)        
set @month=DATEPART(month,GETDATE())        
set @month_str = CONVERT(varchar,@month)        
if @month < 10        
begin        
set @month_str='0'+CONVERT(varchar,@month)        
end        
        
if @url=''        
begin        
set @url='\'+convert(varchar,DATEPART(YEAR,GETDATE()))+'\'+@month_str+'\'        
end        
else        
begin        
if SUBSTRING(@url,len(@url),1) = '\'        
set @url= rtrim(ltrim(@url)) + convert(varchar,DATEPART(YEAR,GETDATE()))+'\'+@month_str+'\'        
else        
set @url= rtrim(ltrim(@url)) + '\' + convert(varchar,DATEPART(YEAR,GETDATE()))+'\'+@month_str+'\'        
end             
if @czzt=1              
begin         
exec('if exists(select * from tempdb..sysobjects where name='''+@tablename_sqd+''')        
drop table '+@tablename_sqd)         
        
exec('create table '+@tablename_sqd+'(              
zyxh  ut_xh9   not null, --ֵ�����(=TJ_XMZYK.xh)                 
caption  ut_mc32   null,  --��ʾ����              
valuedm  varchar(200) null,  --ֵ�����ݴ���              
value       varchar(1000) null,  --ֵ������              
zlx   ut_bz   not null,         
--ֵ������: 0�ַ���,1����,2������,3����Ŀ�ֵ��е�ѡ,4����Ŀ�ֵ��ж�ѡ              
taborder int    null  --��ӡ˳��              
)')              
if @@error<>0              
begin              
select 'F','����ȫ����ʱ��ʱ����1��'              
return            
end                  
        
--����ȫ����ʱ��         
exec('if exists(select 1 from tempdb..sysobjects where name ='''+@tabname_sfmx+''')             
drop table '+@tabname_sfmx)            
exec('create table '+@tabname_sfmx+' (           
xmdm ut_xmdm  not null, --��Ŀ����              
xmmc ut_mc64  not null, --��Ŀ����              
xmlb int   not null, --��Ŀ��� 0 �շ���Ŀ 1 �ٴ���Ŀ              
xmsl int   not null, --��Ŀ����              
sjxmdm  ut_xmdm  not null, --�ϼ���Ŀ����              
bzsm ut_mc64  null,  --��ע˵��              
sqdgroupno int         null, --���        
v5xh ut_xh12  null,  --50�����뵥��ϸ���         
mxjjbz  ut_bz       null,      --��ϸ�Ӽ���־  SF_HJCFMXK.ybjzbz        
memo    ut_mc256    null,       --��ϸ��ע      SF_HJCFMXK.memo        
yzxrq   ut_rq8      null,        --Ԥִ������        
zfcfbz  ut_bz       null,        
shid    varchar(max)    null,    --���id        
buweimemo ut_memo null           --��λ��ע        
)')            
if @@error<>0            
begin            
select 'F','����ȫ����ʱ��ʱ����3��'            
return            
end            
        
--����ȫ����ʱ��--ҽ������������ʱ��            
exec('if exists(select 1 from tempdb..sysobjects where name ='''+@tabname_ybkz+''')             
drop table '+@tabname_ybkz)            
exec('create table '+@tabname_ybkz+' (           
sfid ut_xmdm null, --��Ŀ����        
xmmc ut_mc64 null, --��Ŀ����        
ybkzbz ut_bz null --ҽ�����Ʊ�־             
)')            
if @@error<>0            
begin            
select 'F','����ȫ����ʱ��ʱ����4��'            
return            
end           
        
--���뵥�Զ����շѴ���          
declare @result1 varchar(8),@msg1 ut_mc256          
exec usp_his5_outp_savesqdcharge @wkdz=@wkdz,@jszt=1,@result=@result1 output,@msg=@msg1 output          
if @result1='F'          
begin          
select @result1,@msg1          
return          
end         
        
select 'T'              
return          
end            
        
if @czzt=2              
begin                
select @sql ='insert into '+@tablename_sqd+' values('              
+convert(varchar(14),@taborder)              
+ ',''' + isnull(@vclcaption,'') + ''''              
+ ',''' + isnull(@valuedm,'') + ''''              
+ ',''' + isnull(@value,'') + ''''              
+ ',' + convert(varchar(14),0)  --ֵ����Ŀǰ����0              
+ ',' + convert(varchar(14),isnull(@taborder,999))              
+')'            
exec(@sql)              
if @@error<>0              
begin              
select 'F','����ȫ����ʱ��ʱ����1��'              
return              
end              
select 'T'            
return              
end            
        
if @czzt=3              
begin               
if @kxmlb=0          
begin          
if not exists(select 1 from  YY_SFXXMK (nolock) where id =@kxmdm )           
begin          
select 'F', 'HIS��û�С�'+@kxmdm+'��С��Ŀ��Ŀ!'               
return            
end           
end          
else          
begin          
if not exists( select 1 from  YY_LCSFXMK (nolock) where id =@kxmdm )           
begin          
select 'F', 'HIS��û�С�'+@kxmdm+'���ٴ���Ŀ!'               
return            
end           
end        
        
--��Ŀͣ���ж� --add by lls for 75027        
if @kxmlb=0          
begin          
if not exists(select 1 from  YY_SFXXMK (nolock) where id =@kxmdm and sybz = 1 and mzbz = 1)           
begin          
select 'F', 'HIS�С�'+@kxmdm+'��С��Ŀ��Ŀ�Ѿ�ͣ��!'               
return            
end           
end          
else          
begin          
if not exists( select 1 from  YY_LCSFXMK (nolock) where id =@kxmdm and jlzt = 0)           
begin          
select 'F', 'HIS��û�С�'+@kxmdm+'���ٴ���Ŀ�Ѿ�ͣ��!'               
return            
end           
end        
        
--ҽ�����ƴ���        
if @kxmlb = 0        
begin        
select @sql ='insert into '+@tabname_ybkz+' select id,name,case ybkzbz when 0 then 0 else 2 end  from YY_SFXXMK (nolock) where id ='''+@kxmdm+''''          
end         
else     
begin       
select @sql ='insert into '+@tabname_ybkz+' select a.id,a.name,case a.ybkzbz when 0 then 0 else 2 end          
from YY_SFXXMK a (nolock),YY_LCSFXMK b (nolock),YY_LCSFXMDYK c (nolock)        
where b.id ='''+@kxmdm+''' and b.id=c.lcxmdm and c.xmdm=a.id'          
end          
exec(@sql)        
if @@error<>0              
begin              
select 'F','����ȫ��ҽ��������ʱ��ʱ����'              
return              
end            
--����ҽ���������ybkzbz          
if (isnull(@ybkz,'') <>'')        
begin        
select @sql='update '+@tabname_ybkz+' set ybkzbz=1 where sfid in ('+@ybkz+')'        
exec(@sql)          
if @@error<>0              
begin              
select 'F','����ȫ��ҽ��������ʱ��ʱ����'              
return              
end         
end          
--������ϸ           
select @sql ='insert into '+@tabname_sfmx+' values('              
+''''+convert(varchar(16),@kxmdm)+''''           --add by yangdi 2020.7.15 ��Ŀ����ض�  
+ ',''' + convert(varchar(64),@kxmmc)+''''             
+ ',' + convert(varchar,@kxmlb)          
+ ',' + convert(varchar,@kxmsl)            
+ ',' + convert(varchar(14),0) --ֵ����Ŀǰ����0              
+','''+convert(varchar(256),@value)+''''          
+','+convert(varchar(2),@groupno)        
+','+convert(varchar(12),@v5xh)        
+','+convert(varchar,@yjjzbz)         
+','''+convert(varchar(256),@value)+''''  --��Ŀ��ϸ�ı�ע����@value�ֶ�        
+','''+convert(varchar(256),@yzxrq)+''''         
+','+convert(varchar,@zfcfbz)         
+',''' + CONVERT(VARCHAR(256), @shid) + ''''         
+',''' + convert(varchar(24),@buweimemo) + ''''        
+')'              
exec(@sql)              
if @@error<>0              
begin              
select 'F','����ȫ����ʱ��ʱ����3��'              
return              
end              
select 'T'            
return                  
end                
if @czzt=4              
begin                 
--���Ҷ�Ӧ��ҽ��              
declare  @yjbbzl varchar(32),        
@maxzyxh int,        
@yjlb ut_xmdm,              
@dyyzlb ut_bz,              
@sjxmdm ut_xmdm,              
@xmmc ut_mc32,        
@fylb ut_mc32, --�������-add by lls for88846        
@tmpsqdgroupno INT,        
@c_idm  ut_xh9,        
@c_ypyf  ut_dm2,        
@c_pcdm  ut_dm2,        
@c_ypjl  ut_sl14_3,        
@c_jldw  ut_unit,        
@c_dwlb  ut_bz,        
@c_ts  smallint,        
@c_ypsl  ut_sl10,        
@c_cfts  smallint,        
@c_mxlb  ut_xmdm,        
@yhdj  ut_money,        
@config9052 ut_mc32        
        
select @cfysdm = SQYSDM from CISDB..OUTP_CFQSQK with  (nolock) where YSDM = @ysdm  --������Ȩҽ��        
if rtrim(isnull(@cfysdm, '')) = ''         
select @cfysdm = zgbm from czryk (nolock) where id = @ysdm         
if rtrim(isnull(@cfysdm, '')) = ''               
select @cfysdm = @ysdm                  
select @now = convert(varchar(8),getdate(),112) + convert(varchar(8),getdate(),108),@zxks = ltrim(rtrim(@zxks))           
select @mbxh=@frmcode              
if(@sqdlb='2')        
begin        
select @yjlb=id,@dyyzlb=dyyzlb from YJ_SQDYJFLK (nolock) where jchybz=0  and name ='ris'        
end        
else if(@sqdlb='1')        
begin        
select @yjlb=id,@dyyzlb=dyyzlb from YJ_SQDYJFLK (nolock) where jchybz=0  and name ='lis'        
end         
select @config9052=isnull(config,'��') from YY_CONFIG(nolock) where id='9052'        
select @config9052=isnull(@config9052,'��')        
if @config9052<>'��'        
select @kybz=0        
        
--У�����ֵ����Ϣ��д���            
exec usp_yj_sqdcheck @tablename_sqd,@xtlb,@frmcode,@errmsg output            
if @errmsg like 'F%'            
begin            
select 'F',substring(@errmsg,2,49)            
return            
end         
        
--4.1��ȫ����ʱ������ݸ��Ƶ���ʱ����            
create table #sqdxx            
(              
zyxh  ut_xh9   not null, --ֵ�����(=TJ_XMZYK.xh)                 
caption  ut_mc32   null,  --��ʾ����              
valuedm  varchar(200) null,  --ֵ�����ݴ���              
value       varchar(1000) null,  --ֵ������              
zlx   ut_bz   not null,         
--ֵ������: 0�ַ���,1����,2������,3����Ŀ�ֵ��е�ѡ,4����Ŀ�ֵ��ж�ѡ              
taborder int    null,  --��ӡ˳��              
memo  ut_memo   null            
)               
exec('insert into #sqdxx select *,'''' from '+@tablename_sqd)              
if @@error<>0              
begin              
select 'F','������ʱ��ʱ����1��'             
return               
end               
exec('drop table '+@tablename_sqd)              
        
select @zxks=rtrim(value) from #sqdxx (nolock) where caption='ִ�п��Ҵ���'         
        
/*        
if exists(select 1  from #sqdxx (nolock) where caption='ִ�п��Ҵ���' and  rtrim(value) <> '')              
begin              
select @zxks=rtrim(value) from #sqdxx (nolock) where caption='ִ�п��Ҵ���'              
end              
else              
begin              
select 'F','��ѡ��ִ�п��ң�'              
return               
end           
*/           
        
--����ֵ�����뵥��š�������            
if exists(select 1 from #sqdxx (nolock) where caption='���뵥���' and @sqdxh>0)            
begin            
update #sqdxx set value=convert(varchar,@sqdxh) where caption='���뵥���'            
if @@error<>0            
begin            
select 'F','�������뵥���ʧ�ܣ�'            
return            
end            
end            
        
select @maxzyxh= max(zyxh)+1 from #sqdxx (nolock)           
        
--������ϸ            
create table #sfxm            
(              
xmdm ut_xmdm  not null, --��Ŀ����              
xmmc ut_mc64  not null, --��Ŀ����              
xmlb int   not null, --��Ŀ��� 0 �շ���Ŀ 1 �ٴ���Ŀ              
xmsl int   not null, --��Ŀ����              
sjxmdm  ut_xmdm  not null, --�ϼ���Ŀ����              
bzsm ut_mc64  null,  --��ע˵��              
sqdgroupno INT         NULL,        --���            
tsbz ut_bz  null,        
v5xh ut_xh12  null,  --50�����뵥��ϸ���        
mxjjbz  ut_bz       null,  --��ϸ�����־ SF_HJCFMXK.ybjzbz         
memo    ut_mc256    null,       --��ϸ��ע      SF_HJCFMXK.memo          
yzxrq   ut_rq8      null,        
zfcfbz  ut_bz       null,        
shid    varchar(max) null,      --  ���id                  
buweimemo ut_memo    null       --��λ��ע��Ϣ        
)                                         
--exec('select distinct * from '+@tabname_sfmx)          
--select ('insert into #sfxm select distinct *,'''' from '+@tabname_sfmx)          
--exec('insert into #sfxm select distinct *,'''' from '+@tabname_sfmx)          
exec('insert into #sfxm select xmdm,xmmc,xmlb,xmsl,sjxmdm,bzsm,sqdgroupno,null tsbz,v5xh,mxjjbz,memo,yzxrq,zfcfbz,shid,buweimemo from '+@tabname_sfmx)            
if @@error<>0              
begin              
select 'F','������ʱ��ʱ����3��'              
return               
end               
exec('drop table '+@tabname_sfmx)        
        
--����ҽ�����Ʊ�׼         
create table #ybkzsfxm           
(              
xmdm ut_xmdm  not null, --��Ŀ����              
xmmc ut_mc64  not null, --��Ŀ����        
ybkzbz ut_bz null --ҽ�����Ʊ�־                   
)            
exec('insert into #ybkzsfxm select * from '+@tabname_ybkz)              
if @@error<>0              
begin              
select 'F','������ʱ��ʱ����3��'              
return               
end               
exec('drop table '+@tabname_ybkz)               
        
create table #outp_brsqddysfk            
(            
xmdm ut_xmdm  not null, --��Ŀ����             
xmlb int   not null, --��Ŀ��� 0 �շ���Ŀ 1 �ٴ���Ŀ            
v5xh ut_xh12  null,  --50�����뵥��ϸ���              
xmdj  ut_money null,  --��Ŀ����               
)            
insert into #outp_brsqddysfk select XMDM,XMLB,SQMXXH,XMDJ from CISDB..OUTP_BRSQDDYSFK            
where SQMXXH <>0 and SQMXXH in (select abs(v5xh) from #sfxm)          
if @@error<>0                      
begin                      
select 'F','������ʱ��#outp_brsqddysfkʱ����'                      
return                       
end            
        
        
/******************�������뵥������ҽ����Ϣ  zhangwei************************/      
declare        
@xzlb ut_bz,    --�������        
@bfzbz ut_bz,    --����֢��־        
@syyllb ut_dm5,    --����ҽ�����        
@sylbdm ut_dm5,    --����������        
@sylbmc ut_mc64,   --�����������        
@sybzdm varchar(20),  --������ϴ���        
@sybzmc  ut_mc64,   --�����������          
@bfz  varchar(10),  --����֢        
@zzrslx varchar(50),  --��ֹ��������        
@sysj ut_rq16,   --����ʱ���        
@ycbjyjcxmdm varchar(20), --�Ŵ���������Ŀ����        
@ycbjyjcxmmc varchar(100), --�Ŵ���������Ŀ����        
@syfwzh varchar(20),  --��������֤��        
@jhzh varchar(20)   --���֤��        
        
select         
@xzlb=cast(ta.XZLB as smallint),        
@bfzbz=cast(ta.BFZBZ as smallint),        
@syyllb=cast(ta.SYYLLB as varchar(5)),        
@sylbdm=cast(ta.SYLBDM as varchar(5)),        
@sylbmc=cast(ta.SYLBMC as varchar(64)),        
@sybzdm=cast(ta.SYZDDM as varchar(20)),        
@sybzmc=cast(ta.SYZDMC as varchar(64)),        
@bfz=cast(ta.BFZ as varchar(10)),        
@zzrslx=cast(ta.ZZRSLX as varchar(50)),        
@sysj=ta.SYSJ,        
@ycbjyjcxmdm=cast(ta.YCBJYJCXMDM as varchar(20)),        
@ycbjyjcxmmc=cast(ta.YCBJYJCXMMC as varchar(100)),        
@syfwzh=cast(ta.SYFWZH as varchar(100)),        
@jhzh=cast(ta.JHZH as varchar(20))        
from CISDB..OUTP_BRSQDK ta inner join CISDB..OUTP_BRSQDMXK tb on ta.XH=tb.SQXH        
inner join #outp_brsqddysfk tc on tb.XH=tc.v5xh           
/*******************�������뵥������ҽ����Ϣ************************/        
        
        
--��ʼ����              
begin tran              
        
--4.2��ʼ�������뵥              
--4.2.1 ��������ҽ�����뵥              
if @xtlb in(0,3)              
begin           
--���������뵥���������Ϣ           
if  not exists(select 1 from  SF_MZSQD (nolock) where blsqdxh =@emrsqdxh )             
begin           
if @ywxh<>0          
begin          
select @patid = patid from GH_GHZDK (nolock) where xh = @ywxh           
if @@rowcount = 0              
begin              
select 'F','δ�ҵ���Ч�ĹҺ��˵�,���ʵ!'        
rollback tran              
return              
end           
end          
else          
begin          
select  @patid=@cpatid          
end           
        
insert into SF_MZSQD (patid,ghxh,mbxh,lrrq,czyh,sqks,zxks,lb, ghlb, mjzsm,hjcfbz,yjlb,jzbz ,blsqdxh,kybz)              
values(@patid,@ywxh,@mbxh,@now,@ysdm,@sqks,@zxks,case @xtlb when 0 then 0 else 3 end, @ghlb, @mjzsm,0,@yjlb,@yjjzbz,@emrsqdxh,@kybz)              
if @@error<>0              
begin              
select 'F','��SF_MZSQD��������ʱ����'             
rollback tran              
return               
end        
        
select @sqdxh = @@identity              
        
--update YJ_YS_SQDZHMXK set sqdxh=@sqdxh,sqdid=@frmcode where sqdxh=-9999 and ghxh=@ywxh               
select @urlbz = 1              
select @url =@url + 'MZ'+convert(varchar(12),@emrsqdxh)+'.html'              
end              
else             
begin             
select  @sqdxh =xh from  SF_MZSQD (nolock) where blsqdxh =@emrsqdxh            
select @urlbz= 0              
        
select @patid = patid from SF_MZSQD (nolock) where xh = @sqdxh and jlzt = 0 and qrbz = 0              
if @@rowcount = 0              
begin              
select 'F','δ�ҵ���Ч�����뵥��Ϣ,������ȷ�ϻ�����!'              
rollback tran              
return              
end                 
update SF_MZSQD set zxks=@zxks,jzbz = @yjjzbz,kybz=@kybz where xh = @sqdxh              
end              
        
--   *****�������ʱ��֪����ʲô���壡��          
--  delete YJ_YS_SQDZHMXK where sqdxh=@sqdxh and ghxh=@ywxh and sqdid=@frmcode            
--  insert into YJ_YS_SQDZHMXK(ghxh,sqdxh,zhid,zhmc,memo,sqdid,sl)              
--  select @ywxh,@sqdxh,zhid,zhmc,memo,@frmcode,1 from #sfzh              
        
--����ԭ�����޸ļ�¼����              
select * into #tmpmzmxk from SF_MZSQDMXK (nolock) where sqdxh =@sqdxh              
--ɾ��ԭ�������뵥����              
delete SF_MZSQDMXK where sqdxh =@sqdxh              
if @@error<>0              
begin              
select 'F','ɾ��SF_MZSQDMXKʱ����'            
rollback tran              
return               
end            
        
--����ֵ�����뵥��š�������            
if exists(select 1 from #sqdxx (nolock) where caption='���뵥���' and @sqdxh>0)            
begin            
update #sqdxx set value=convert(varchar,@sqdxh) where caption='���뵥���'            
if @@error<>0            
begin            
select 'F','�������뵥���ʧ�ܣ�'            
return            
end            
end            
        
--�������뵥��ϸ����            
insert into SF_MZSQDMXK(sqdxh,zyxh,caption,valuedm,value,zlx,sjxh,taborder,dykz,lrczyh,lrrq,memo,kybz)              
select @sqdxh,zyxh,caption,valuedm,value,zlx,0,taborder,0, @ysdm, @now,memo,@kybz from #sqdxx              
if @@error<>0              
begin              
select 'F','����SF_MZSQDMXKʱ����'              
rollback tran              
return               
end            
        
--��ȡ�������-add by lls for88846        
select @fylb=isnull(valuedm,'') from #sqdxx(nolock) where caption='�ѱ�'        
select @fylb=isnull(@fylb,'')        
        
--�����ϼ����            
select a.xh,b.xh sjxh               
into #sjxh_mz              
from SF_MZSQDMXK a (nolock),SF_MZSQDMXK b (nolock)              
where a.sqdxh = @sqdxh and b.sqdxh = @sqdxh and a.sjxh >0 and a.sjxh = b.zyxh              
        
update SF_MZSQDMXK  set sjxh = b.sjxh from SF_MZSQDMXK a (nolock),#sjxh_mz b where a.xh = b.xh            
if @@error<>0              
begin              
select 'F','����SF_MZSQDMXKʱ����'              
rollback tran              
return     
end            
        
--���²�����¼              
update SF_MZSQDMXK set lrczyh = b.lrczyh,lrrq = b.lrrq from SF_MZSQDMXK a (nolock),#tmpmzmxk b (nolock)              
where a.sqdxh = @sqdxh and a.zyxh = b.zyxh and isnull(b.lrczyh,'') <> ''              
        
--����url·��              
if @urlbz = 1              
begin             
update SF_MZSQD set sqdurl = @url where xh = @sqdxh              
if @@error<>0              
begin              
select 'F','����SF_MZSQD url·��ʱ����'              
rollback tran              
return               
end              
end            
        
--begin add by lls for 84670 �������������롢���뵥���������뵥����        
update SF_MZSQD         
set sqdmc=(select top 1 value from #sqdxx(nolock) where caption='���뵥����')        
,txm=(select top 1 value from #sqdxx(nolock) where caption='������')        
where xh = @sqdxh              
if @@error<>0              
begin              
select 'F','����SF_MZSQD���뵥���ơ�������ʱ����'              
rollback tran              
return               
end          
--end add by lls for 84670        
        
select @config_9022=isnull(config,'��') from YY_CONFIG where id='9022'              
        
--�ж��Ƿ���ȷ��              
if exists(select 1 from SF_HJCFK (nolock) where patid = @patid  and sqdxh = @sqdxh and jlzt = 1)              
begin              
select @strmsg='���뵥�Ĵ�����Ϣ��ȷ��'              
select @xtlb = -1              
end              
end     --�����������ҽ�����뵥            
        
--4.3 ��ʼ�����շ���Ŀ              
if @xtlb = 0  --4.3.1 ���������շ���Ŀ              
begin              
if (@gxbz=0)               
begin              
select @hzxm=hzxm, @py=py, @wb=wb from SF_BRXXK (nolock) where patid=@patid           
        
--����������Ϣ              
exec usp_yy_cxjzbrzk @patid, 1, @zkpatid output              
if @zkpatid = 0         
select @zkpatid = @patid         
        
if (@sqdxh <> 0)               
begin              
select xh, djje, djbz, jzbz into #temphjcfk from SF_HJCFK (nolock) where patid = @patid and sqdxh = @sqdxh and jlzt = 0              
        
select @cfje = isnull(sum(djje), 0) from #temphjcfk (nolock) where djbz = 1 and jzbz = 1         
if exists(select 1 from YY_CONFIG where id='H353' and config='��')        
select @cfje=0             
--����ǰ�Ķ�����ָ�              
update YY_JZBRK set djje = djje - isnull(@cfje,0) where patid = @zkpatid               
if @@error <> 0               
begin              
select 'F','���¼��ʽ��ʧ�ܣ�'        
rollback tran              
return              
end              
        
delete SF_HJCFMXK  from #temphjcfk b (nolock) where cfxh=b.xh              
if @@error<>0              
begin              
select 'F','����SF_HJCFMXKʧ�ܣ�'              
rollback tran              
return               
end                      
        
delete SF_HJCFK from SF_HJCFK a,#temphjcfk b (nolock) where a.xh=b.xh              
if @@error<>0              
begin              
select 'F','����SF_HJCFKʧ�ܣ�'              
rollback tran              
return               
end              
--�ٴ��ж�              
if exists(select 1 from SF_HJCFK (nolock) where patid = @patid  and sqdxh = @sqdxh and jlzt = 0)              
begin              
select 'F','�Ѿ����ڸ����뵥�Ĵ�����Ϣ�����Ⱥ˶ԣ�'              
rollback tran              
return               
end              
end            
        
select @config_H125 = config from YY_CONFIG (nolock) where id = 'H125'        
        
--add by lls        
--����Ƿ�Ի��۴�����ϸ��Ŀ���п��Ƶ��ж�          
select @config_2147 = config from YY_CONFIG (nolock) where id = '2147'   --�ж��Ƿ��������        
select @config_2149 = isnull(config,0) from YY_CONFIG (nolock) where id = '2149'   --��ҳ��ӡ�������        
set @hjcfxhtemp = ''   --���۵����        
set @hjcfindex = 1     --���۵���ϸ��        
--end add by lls        
        
--�α�������ʱ��               
create table #cs_sfxm(              
xmdm  ut_xmdm  not null, --��Ŀ����                
xmxl  int   null,  --��Ŀ����               
sfksdm  ut_ksdm  null,  --�շѿ��Ҵ���              
xmdw  ut_unit  null,  --��Ŀ��λ              
lcxmdm  ut_xmdm  null,  --�ٴ���Ŀ����            
xmdj  ut_money null,  --��Ŀ����        
dxmdm  ut_kmdm  null,  --����Ŀ����        
sjxmdm  ut_xmdm  null,  --�ϼ���Ŀ����          
bzsm  ut_mc64  null,  --��ע˵��        
name  ut_mc64  NULL,  --��Ŀ����        
sqdgroupno  INT         NULL,       --���        
idm   ut_xh9  null,        
ypyf  ut_dm2  null,        
pcdm  ut_dm2      null,        
ypjl  ut_sl14_3 null,        
jldw  ut_unit  null,        
dwlb  ut_bz  null,        
ts   smallint null,        
ypsl  ut_sl10  null,        
cfts  smallint null,        
mxlb  ut_xmdm  null,        
v5xh  ut_xh12  null,        
mxjjbz      ut_bz       null,        
memo        ut_mc256    null,        
ypfj   ut_money null,  --������        
yzxrq  ut_rq8 null,        
zfcfbz  ut_bz null,        
shid varchar(max) null,        
buweimemo ut_memo null         
)              
if @@error<>0              
begin              
select 'F','����ȫ����ʱ��ʱ����1��'         
rollback tran             
return              
end         
        
insert into #cs_sfxm        
select a.xmdm, a.xmsl, (case when @zxks = '' then isnull(b.zxks_id,'') else @zxks end) sfksdm, isnull(b.xmdw,''), '0'as lcxmdm,        
b.xmdj, b.dxmdm,a.sjxmdm,a.bzsm ,(case when rtrim(a.xmmc)<>'' then a.xmmc else b.name end) name ,a.sqdgroupno          
,0,'', '', 0, '' , 0,1,  @cxmsl, 1,0,v5xh,a.mxjjbz,a.memo ,b.xmdj,a.yzxrq,a.zfcfbz,a.shid,a.buweimemo           
from #sfxm a (nolock), YY_SFXXMK b (nolock)              
where a.xmlb = 0 and a.xmdm = b.id               
union all            
select c.zxmdm,a.xmsl, (case when @zxks = '' then isnull(b.zxks_id,'') else @zxks end) sfksdm, isnull(b.xmdw,''), c.id as lcxmdm,        
c.xmdj, b.dxmdm,a.sjxmdm,a.bzsm,c.name,a.sqdgroupno             
,0,'', '', 0, '' , 0,1,  @cxmsl, 1 ,1,v5xh ,a.mxjjbz,a.memo ,c.xmdj,a.yzxrq,a.zfcfbz,a.shid,a.buweimemo                
from #sfxm a (nolock), YY_SFXXMK b (nolock), YY_LCSFXMK c (nolock)            
where a.xmlb = 1 and a.xmdm = c.id and c.zxmdm = b.id         
union all      
select b.ypdm,b.ypsl, (case when @zxks = '' then isnull(b.zxks,'') else @zxks end) sfksdm, b.jldw, b.lcxmdm lcxmdm,        
0, '',a.sjxmdm,a.bzsm,b.ypmc,a.sqdgroupno             
,b.idm,b.ypyf,b.pcdm,b.ypjl,b.jldw ,b.dwlb,b.ts,  @cxmsl*b.ypsl, b.cfts,2,v5xh,a.mxjjbz ,a.memo,0,a.yzxrq,a.zfcfbz,a.shid,a.buweimemo            
from #sfxm a (nolock), SF_YS_MZXDFMX b (nolock)          
where a.xmlb = 2 and a.xmdm = b.cfxh        
        
update a set a.xmdj=b.xmdj from #cs_sfxm a,#outp_brsqddysfk b where abs(a.v5xh)=b.v5xh  and a.mxlb=b.xmlb and ((b.xmlb=0 and a.xmdm=b.xmdm) or (b.xmlb=1 and a.lcxmdm=b.xmdm))            
        
--�������۴���               
declare cs_sfxmcl cursor for                
select * from #cs_sfxm (nolock)        
order by  sfksdm   --���շѿ��ҽ�������  --add by lls           
for read only                 
open cs_sfxmcl                 
fetch cs_sfxmcl into @cxmdm ,@cxmsl, @sfksdm, @xmdw, @clcxmdm ,@ylsj, @dxmdm,@sjxmdm,@bzsm,@xmmc ,@tmpsqdgroupno         
,@c_idm,@c_ypyf,@c_pcdm,@c_ypjl,@c_jldw,@c_dwlb,@c_ts,@c_ypsl,@c_cfts,@c_mxlb,@cv5xh,@cmxjjbz ,@cmemo,@ypfj,@yzxrq2,@zfcfbz2,@cshid,@buweimemo2        
while @@fetch_status=0                    
begin              
if @c_mxlb=2 and @c_idm>0        
begin        
select @cfje = @c_ypsl*ylsj*@c_cfts/ykxs from YK_YPCDMLK(nolock) where idm=@c_idm        
end        
else if @c_mxlb=2 and @c_idm=0 and @ylsj=0        
begin        
select @cfje = xmdj from YY_SFXXMK(nolock) where id=@cxmdm        
end        
else        
begin        
select @cfje = @ylsj        
end        
        
select @djje = 0 , @djbz = 0              
select @config_1058 = config from YY_CONFIG where id = '1058'              
select @is_prepay = 0               
        
--��ʼ�����ֵ������begin              
select @yzbrk_yjye = yjye-djje           
from YY_JZBRK (nolock) where patid = @zkpatid and jlzt = 0           
        
--     select @yzbrk_yjye          
--     select * from YY_JZBRK where patid = @zkpatid            
        
if @yzbrk_yjye is not null               
begin              
select @is_prepay = 1            
if exists(select 1 from YY_CONFIG where id='H353' and config <> '��')        
select @djje=@cfje , @djbz=1         
ELSE        
SELECT @djje=0,@djbz=0            
        
if @yzbrk_yjye - @cfje < 0              
begin              
--if isnull(@config_1058,'') <> '��' --��ֵ�������Ƿ���������շ�              
if isnull(@config_H125,'') = '2'              
begin --���ܿ�              
rollback tran              
deallocate cs_sfxmcl                  
select 'F', '������¼��,�����������Ԥ����' + convert(varchar(24), @cfje - @yzbrk_yjye)              
return                
end              
else if rtrim(@strmsg) = '' and isnull(@config_H125,'') = '1'              
select @strmsg = '����,����Ԥ����' + convert(varchar, @cfje-@yzbrk_yjye)              
end              
end              
        
--���������Ŀ�Żݵ���        
if @kybz=1 and @c_idm=0 and @config9052='��'        
begin        
if isnull(@clcxmdm,'0')='0'        
begin        
if exists(select 1 from YY_SFXXMK(nolock) where id=@cxmdm and iskybz=1)        
select @yhdj=@ylsj        
end        
else        
begin             
if (not exists(select 1 from YY_LCSFXMK a(nolock),YY_LCSFXMDYK b(nolock),YY_SFXXMK c(nolock)         
where a.id=@clcxmdm and a.id=b.lcxmdm and b.xmdm=c.id and a.jlzt=0 and isnull(c.iskybz,0)=0))        
select @yhdj=@ylsj             
end             
end            
        
--���ʹ��Ԥ�����޸�Ѻ�����              
select @jzbz = 0              
if @is_prepay = 1              
begin              
/*if isnull(@config_1058,'') <> '��' --��ֵ����������������շ�              
begin              
update YY_JZBRK               
set djje = djje + @cfje               
where patid = @zkpatid               
end              
else*/           
        
update YY_JZBRK               
set djje = djje + @djje               
where patid = @zkpatid            
if @@rowcount=0 or @@error<>0              
begin              
select 'F','����Ԥ�������ݳ���'              
rollback tran              
deallocate cs_sfxmcl                  
return              
end          
        
        
select @jzbz = 1              
end        
        
declare @tsbrshbz ut_bz        
if @mbbz+@gsbz+@lxbz>0        
set @tsbrshbz=1        
else        
set @tsbrshbz=0        
--��ʼ�����ֵ������end              
-- add by jeffrey 2007.3.12 split recipe by section office              
--���滮�ۿ�            
if @config_9022='��'              
begin          
      
      
 if (@cfmedtype='' or @cfmedtype is null)   --��������  by xieni       
    select @cftszddm='',@cftszdmc=''       
      
        
insert into SF_HJCFK( czyh, lrrq, patid, hzxm, py, wb,               
ysdm,  ksdm,  yfdm,  sfksdm, qrczyh, qrrq,   cfts, jlzt,  cflx, sycfbz,   tscfbz,  ghxh, memo,              
shbz1,  shbz2,  shbz3,  zfcfbz,  jzbz,shbz7              
,djje,djbz,ybshbz,sqdxh,sqdid,bzdm,bzmc,fylb ,medtype,medtypemc,cftszddm,cftszdmc,ybbfz,ybbfzmc,sqdlb ,zjbz,ismxb, --add fylb by lls for88846        
xzlb,bfzbz,syyllb,sylbdm,sylbmc,sybzdm,sybzmc,bfz,zzrslx,sysj,ycbjyjcxmdm,ycbjyjcxmmc,syfwzh,jhzh,sqdzfbz,tsbrshbz,cfybzddm,cfybzdmc) --add zhangwei ���� 87078 ���쿪������ҽԺ����ҽ�����뵥            
values(  @ysdm, @now, @patid, @hzxm,  @py, @wb,              
@cfysdm, @sqks , @sfksdm, @sfksdm,   null, null,  1,    0, 5 , 0, 0, @ywxh, @vclcaption,              
0, 0, 0, 0, @jzbz,@shbz7              
,@djje,@djbz,0,@sqdxh,@frmcode,@bzdm,@bzmc,@fylb,@cfmedtype,@cfmedtypemc,@cftszddm,@cftszdmc,@cfybbfz,@cfybbfzmc,@sqdlb,2,@mbbz,        
@xzlb,@bfzbz,@syyllb,@sylbdm,@sylbmc,@sybzdm,@sybzmc,@bfz,@zzrslx,@sysj,@ycbjyjcxmdm,@ycbjyjcxmmc,@syfwzh,@jhzh,@zfbz,@tsbrshbz,@cfybzddm,@cfybzdmc)                  
if @@error<>0 or @@rowcount=0              
begin              
select 'F','���滮�۴�������'              
rollback tran              
deallocate cs_sfxmcl                  
return              
end              
        
select @xhtemp=@@identity              
        
insert into SF_HJCFMXK(cfxh, cd_idm, gg_idm, dxmdm, ypdm,ypmc,               
ypdw,  ypxs,  ykxs,  ypfj, ylsj,               
ypyf, pcdm, ypjl, jldw, dwlb,              
ts,  ypsl,  cfts,  memo,   zbz,    mzdm,shbz,lcxmdm,sqdsjxm,sqdxmbz,sqdgroupno,yhdj,v5xh,ybjzbz,yzxrq,zfcfbz,shid,buweimemo)              
select @xhtemp, @c_idm, 0, @dxmdm, @cxmdm,@xmmc,              
@xmdw, 1,  1, @ypfj ,  @ylsj,              
@c_ypyf, @c_pcdm, @c_ypjl, @c_jldw , @c_dwlb,              
@c_ts,  @cxmsl, @c_cfts, @cmemo,   0,    '',0 ,@clcxmdm,@clcxmdm,@bzsm ,@tmpsqdgroupno ,@yhdj,@cv5xh,@cmxjjbz,@yzxrq2,@zfcfbz2,@cshid,@buweimemo2        
if @@error<>0              
begin              
select 'F','���滮�۴�����ϸ����'              
rollback tran              
deallocate cs_sfxmcl                  
return                
end        
select @mxxhtemp=@@identity           
end              
else           
--modify by lls            
begin        
if exists(select 1 from SF_HJCFK (nolock) where patid=@patid and sqdxh=@sqdxh and sfksdm=@sfksdm and        
(@config_2147 = '��') or ( (@config_2147 = '��') and (@hjcfindex % @config_2149 <> 1) ) )              
begin              
--modify by lls �����¼�¼�Ļ��۴�������Ÿ�����ʱֵ        
--select @xhtemp=xh from SF_HJCFK where patid=@patid and sqdxh=@sqdxh and sfksdm=@sfksdm              
set @xhtemp = @hjcfxhtemp        
--modify by lls        
        
if @@error<>0              
begin              
select 'F','���滮�۴�������'              
rollback tran              
deallocate cs_sfxmcl                  
return              
end              
insert into SF_HJCFMXK(cfxh, cd_idm, gg_idm, dxmdm, ypdm,ypmc,               
ypdw,  ypxs,  ykxs,  ypfj, ylsj,               
ypyf, pcdm, ypjl, jldw, dwlb,              
ts,  ypsl,  cfts,  memo,        
zbz,    mzdm,shbz,lcxmdm,sqdsjxm,sqdxmbz,sqdgroupno,yhdj,v5xh,ybjzbz,yzxrq,zfcfbz,shid,buweimemo)              
select @xhtemp, 0, 0, @dxmdm, @cxmdm,@xmmc,              
@xmdw, 1,  1, @ypfj ,  @ylsj,              
'', '', 0, '' , 0,              
1,  @cxmsl, 1, @cmemo,        
0,    '',0 ,@clcxmdm,@sjxmdm,@bzsm ,@tmpsqdgroupno,@yhdj,@cv5xh,@cmxjjbz,        
@yzxrq2,@zfcfbz2,@cshid,@buweimemo2            
if @@error<>0              
begin              
select 'F','���滮�۴�����ϸ����'              
rollback tran              
deallocate cs_sfxmcl                  
return                
end        
select @mxxhtemp=@@identity          
end              
else              
begin       
      
if (@cfmedtype='' or @cfmedtype is null)   --��������  by xieni       
      select @cftszddm='',@cftszdmc=''       
            
             
insert into SF_HJCFK( czyh, lrrq, patid, hzxm, py, wb,             
ysdm,  ksdm,  yfdm,  sfksdm, qrczyh, qrrq,        
cfts, jlzt,  cflx, sycfbz,   tscfbz,  ghxh, memo,              
shbz1,  shbz2,  shbz3,  zfcfbz,  jzbz,shbz7              
,djje,djbz,ybshbz,sqdxh,sqdid,bzdm,bzmc,fylb,medtype,medtypemc,cftszddm,cftszdmc,ybbfz,ybbfzmc,sqdlb,zjbz,ismxb,     --add fylb by lls for88846        
xzlb,bfzbz,syyllb,sylbdm,sylbmc,sybzdm,sybzmc,bfz,zzrslx,sysj,ycbjyjcxmdm,ycbjyjcxmmc,syfwzh,jhzh,sqdzfbz,tsbrshbz,cfybzddm,cfybzdmc)           
--add zhangwei ���� 87078 ���쿪������ҽԺ����ҽ�����뵥              
values(  @ysdm, @now, @patid, @hzxm,  @py, @wb,              
@cfysdm, @sqks , @sfksdm, @sfksdm,   null, null,        
1,    0, 5 , 0, 0, @ywxh, @vclcaption,              
0, 0, 0, 0, @jzbz,@shbz7              
,@djje,@djbz,0,@sqdxh,@frmcode,@bzdm,@bzmc,@fylb,@cfmedtype,@cfmedtypemc,        
@cftszddm,@cftszdmc,@cfybbfz,@cfybbfzmc,@sqdlb,2,@mbbz        
,@xzlb,@bfzbz,@syyllb,@sylbdm,@sylbmc,@sybzdm,@sybzmc,@bfz,@zzrslx,@sysj,@ycbjyjcxmdm,        
@ycbjyjcxmmc,@syfwzh,@jhzh,@zfbz,@tsbrshbz,@cfybzddm,@cfybzdmc)                   
if @@error<>0 or @@rowcount=0              
begin              
select 'F','���滮�۴�������'              
rollback tran              
deallocate cs_sfxmcl                  
return              
end              
        
select @xhtemp=@@identity          
set @hjcfxhtemp = @xhtemp  --add by lls ��¼���µĻ��۴������                    
        
insert into SF_HJCFMXK(cfxh, cd_idm, gg_idm, dxmdm, ypdm,ypmc,               
ypdw,  ypxs,  ykxs,  ypfj, ylsj,               
ypyf, pcdm, ypjl, jldw, dwlb,              
ts,  ypsl,  cfts,  memo,           
zbz,    mzdm,shbz,lcxmdm,sqdsjxm,sqdxmbz,sqdgroupno,yhdj,v5xh,ybjzbz,yzxrq,                      zfcfbz,shid,buweimemo)              
select @xhtemp, @c_idm, 0, @dxmdm, @cxmdm,@xmmc,              
@xmdw, 1,  1, @ypfj ,  @ylsj,              
@c_ypyf, @c_pcdm, @c_ypjl, @c_jldw , @c_dwlb,              
@c_ts,  @cxmsl, @c_cfts, @cmemo,        
0,    '',0 ,@clcxmdm,@sjxmdm,@bzsm,@tmpsqdgroupno,@yhdj,@cv5xh,@cmxjjbz,        
@yzxrq2,@zfcfbz2,@cshid,@buweimemo2             
if @@error<>0              
begin              
select 'F','���滮�۴�����ϸ����'              
rollback tran              
deallocate cs_sfxmcl                  
return                
end        
select @mxxhtemp=@@identity         
        
set @hjcfindex = 1   --������1        
        
end        
        
set @hjcfindex = @hjcfindex + 1   --��ͬһ���ҵ���ϸ�����ۼ�           
end        
--end modify by lls         
        
--����ҽ��������־        
if (isnull(@clcxmdm,'0') = '0')        
begin        
insert into MZ_LCMXYBSPJLK(cfxh,cfmxxh,patid,sfid,xmmc,ybspbz,lrrq)        
select @xhtemp,@mxxhtemp,@patid,xmdm,xmmc,ybkzbz,@now from #ybkzsfxm where         
xmdm=@cxmdm        
end else        
begin        
insert into MZ_LCMXYBSPJLK(cfxh,cfmxxh,patid,sfid,xmmc,ybspbz,lrrq)        
select @xhtemp,@mxxhtemp,@patid,a.xmdm,a.xmmc,a.ybkzbz,@now from #ybkzsfxm a,                YY_LCSFXMDYK b (nolock)          
where b.lcxmdm=@clcxmdm and b.xmdm=a.xmdm        
end        
if @@error<>0              
begin              
select 'F','����ҽ��������¼����'              
rollback tran              
deallocate cs_sfxmcl                  
return                
end        
    
    
        
fetch cs_sfxmcl into @cxmdm ,@cxmsl, @sfksdm, @xmdw, @clcxmdm ,@ylsj,@dxmdm,@sjxmdm,        
@bzsm,@xmmc,@tmpsqdgroupno         
,@c_idm,@c_ypyf,@c_pcdm,@c_ypjl,@c_jldw,@c_dwlb,@c_ts,@c_ypsl,@c_cfts,@c_mxlb,@cv5xh,@cmxjjbz,@cmemo,@ypfj,@yzxrq2,@zfcfbz2,@cshid,@buweimemo2             
end            
close cs_sfxmcl                
deallocate cs_sfxmcl                  
end              
end              
insert into SF_SQDYBSHBZ(sqdxh,xmdm,xmmc,idm,spbh,ybshbz,bxbl,bxsm,memo1,memo2,memo3,mxxh)         
select SQDXH,XMDM,XMMC,0,SPBH,YBSHBZ,BXBL,BXSM,MEMO1,MEMO2,MEMO3,0 from CISDB..OUTP_SQDYBSHBZ where SQDXH = @emrsqdxh / 100  and JLZT=0        
update CISDB..OUTP_SQDYBSHBZ set JLZT=1 where SQDXH = @emrsqdxh / 100  and JLZT=0         
        
--���뵥�Զ����շѴ���          
declare @result3 varchar(8),@msg3 ut_mc256          
exec usp_his5_outp_savesqdcharge @wkdz=@wkdz,@jszt=3,@result=@result3 output,@msg=@msg3 output          
if @result3='F'          
begin          
rollback tran       
select @result3,@msg3          
return          
end     
    
---������ϷѼ���                
IF @config_H172 = 1       
begin             
EXEC usp_mz_ys_jyclldcl @patid = @patid, @sqks = @sqks, @zxks = @zxks, @ghxh = @ywxh, @czyh = @ysdm              
IF @@error <> 0       
begin                    
SELECT  'F', '�����������ϳ���'                    
ROLLBACK TRAN     
end    
end    
        
commit tran            
select 'T'+isnull(@strmsg, ''),@sqdxh,@xhtemp        
return             
end 


