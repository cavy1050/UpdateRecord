--SELECT * FROM YY_LGYLSCSZ where jlzt=0

insert into YY_LGYLSCSZ(name,csvmc,procname,sqlcon,py,wb,procsource,cjsj,jlzt)
select '��HIS����������ӿ�1-������Ϣ','fever_cqdxcyy.csv','usp_frmzsjsb_blxx',
'Provider=SQLOLEDB.1;Password=sql2k8;Persist Security Info=True;User ID=sa;Initial Catalog=THIS_MZ;Data Source=172.20.0.40\MZ',
'','','HIS','20200828','0'
union all
select '��HIS����������ӿ�2-���ƴ���','drug_cqdxcyy.csv','usp_frmzsjsb_zlcf',
'Provider=SQLOLEDB.1;Password=sql2k8;Persist Security Info=True;User ID=sa;Initial Catalog=THIS_MZ;Data Source=172.20.0.40\MZ',
'','','HIS','20200828','0'
union all
select '��LIS����������ӿ�3-������Ϣ','lab_cqdxcyy.csv','usp_frmzsjsb_jyxxjl',
'Provider=SQLOLEDB.1;Password=sql2k8;Persist Security Info=True;User ID=sa;Initial Catalog=DBLis50;Data Source=172.20.0.43\LIS',
'','','HIS','20200828','0'
union all
select '��RIS����������ӿ�4-�����Ϣ','examine_cqdxcyy.csv','usp_frmzsjsb_jcxxjl',
'Provider=SQLOLEDB.1;Password=sql2k8;Persist Security Info=True;User ID=sa;Initial Catalog=DBRis50;Data Source=172.20.0.43\LIS',
'','','HIS','20200828','0'

exec usp_yy_getallpyzt 'YY_LGYLSCSZ','name','py','0'
go
exec usp_yy_getallpyzt 'YY_LGYLSCSZ','name','wb','1'
