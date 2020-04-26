--创建YY_CQYB_ZDDMK主建
IF not EXISTS (select 1 from sysobjects where parent_obj=object_id('YY_CQYB_ZDDMK') and xtype='PK' and name='PK_YY_CQYB_ZDDMK')
alter table YY_CQYB_ZDDMK add constraint PK_YY_CQYB_ZDDMK primary key(id)