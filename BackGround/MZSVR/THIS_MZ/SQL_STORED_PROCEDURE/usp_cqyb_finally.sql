if exists(select 1 from sysobjects where name = 'usp_cqyb_finally')
  drop proc usp_cqyb_finally
go

Create proc usp_cqyb_finally
(
	@lb     VARCHAR(50),       --�������   �������  dll��+_+�Զ������
	@input1 VARCHAR(8000),     --��Ϣ1 ����������Ϣ  ����  czyh|syxh|jsxh|sjh||...ÿ���������ж��岢��ȡʹ��
	@input2 VARCHAR(8000)='',  --��Ϣ2 �����봮�ϳ�ʱ����input1������Ϣ 
	@input3 VARCHAR(8000)=''   --��Ϣ3 �����봮�ϳ�ʱ����input1������Ϣ
)
as
/**********************
[�汾��]4.0.0.0.0
[����ʱ��]2019.10.31
[����]qfj
[��Ȩ]Copyright ? 1998-2017���������Ƽ����Źɷ����޹�˾
[����]
����ҽ����������ӵĴ洢,֮���������洢
[����˵��]
[����˵��]
[����ֵ]
[�����������]
[���õ�sp]
[����ʵ��]
[�޸ļ�¼]
**********************/
set nocount on

DECLARE @seq VARCHAR(1),@seq1 VARCHAR(1)
SELECT @seq = '|' ,@seq1 = '$'

declare	@now ut_rq16,		--��ǰʱ��
        @czyh ut_czyh,
		@syxh ut_syxh,
		@jsxh ut_xh12,
		@sjh ut_sjh,
		@CQ64 VARCHAR(14),
		@cyzd VARCHAR(30),
		@cyzdmc VARCHAR(150),
		@ybjkid varchar(3)

select @ybjkid = config from YY_CONFIG where id = 'CQ18'		
select @now=convert(char(8),getdate(),112)+convert(char(8),getdate(),8)

IF @lb = 'yy_cqybddqq_yw_ybshyydzts' --ҽ�����ʱ���ҽԺ��֧��ʾ
BEGIN
    DECLARE @dbzdzje NUMERIC(12,2)
	        
	SELECT @CQ64 = a.config FROM YY_CONFIG a(NOLOCK) WHERE a.id = 'CQ64'
	SELECT @CQ64 = ISNULL(@CQ64,'')
    IF @CQ64 = '-1' OR @CQ64 = ''
	BEGIN
	    SELECT 'T',''  --����û������ֱ�ӷ���
		RETURN
	END

	select @jsxh = dbo.fun_cqyb_getvalbyseq(@input1,@seq,1)
	
	IF NOT EXISTS(SELECT 1 from ZY_BRJSJEK a(NOLOCK) WHERE a.lx = 'yb08' AND jsxh = @jsxh)
	BEGIN
       SELECT 'F','û��Ԥ����Ϣ'
	   RETURN
	END

	SELECT @dbzdzje = a.je from ZY_BRJSJEK a(NOLOCK) WHERE a.lx = 'yb08' AND jsxh = @jsxh

	IF EXISTS(SELECT 1 FROM YY_CONFIG a(NOLOCK) WHERE a.id = 'CQ01' AND a.config = 'WD')
	BEGIN
        SELECT @dbzdzje = a.je  from ZY_BRJSJEK a(NOLOCK) WHERE a.lx = 'yb23' AND jsxh = @jsxh
	END

	IF @dbzdzje > CONVERT(NUMERIC(12,2),@CQ64) 
	BEGIN
	    SELECT 'R','��ע�⣺�û���ҽԺ��֧��'+CONVERT(VARCHAR(20),@dbzdzje)+'���ѳ����޶'+@CQ64+'���Ƿ������ˣ�'
		RETURN
	END

	SELECT 'T',''  --û�в����޶�
	RETURN
END
ELSE IF @lb = 'yy_cqybddqq_yw_ybshcyzd' --ҽ�����ʱ����Ժ���
BEGIN
    SELECT @CQ64 = a.config FROM YY_CONFIG a(NOLOCK) WHERE a.id = 'CQ64'
	SELECT @CQ64 = ISNULL(@CQ64,'')
    IF @CQ64 = '-1' OR @CQ64 = ''
	BEGIN
	    SELECT 'T',''  --����û������ֱ�ӷ���
		RETURN
	END
    
    select @syxh = dbo.fun_cqyb_getvalbyseq(@input1,@seq,2)

    SELECT @cyzd = a.cyzd ,@cyzdmc = b.name from YY_CQYB_ZYJZJLK a(NOLOCK),YY_CQYB_ZDDMK b(NOLOCK) WHERE a.cyzd = b.id AND a.syxh = @syxh
	IF ISNULL(@cyzd,'') = '' 
	    SELECT 'T','û����д��ϣ�'
	ELSE 
        select 'R','����д��ϣ���'+ @cyzd+'��,���ƣ���' + @cyzdmc + '�����Ƿ�������ͨ����'
	RETURN    
END
ELSE IF @lb = 'yy_cqybdzsmxzhcl' --��Ŀ���غ���
BEGIN
	SELECT 'T',''
	RETURN
    --��һ�汾
    --DELETE YY_CQYB_ZDDMK WHERE id IN (SELECT code FROM YY_CQYB_GLXX a(NOLOCK) WHERE a.gllb = '1' AND a.jlzt = 0 )
    
END
ELSE IF @lb = 'yy_cqybddqq_yw_saveShz' --���������
BEGIN
    IF dbo.fun_cqyb_getvalbyseq(@input1,@seq,1) NOT IN ('0','')
	BEGIN
	    UPDATE YY_CQYB_YBSHZ 
		SET mc = dbo.fun_cqyb_getvalbyseq(@input1,@seq,2),
		    czyh = dbo.fun_cqyb_getvalbyseq(@input1,@seq,3),
			czrq = GETDATE() 
		WHERE id = dbo.fun_cqyb_getvalbyseq(@input1,@seq,1) 
	END 
    ELSE
    BEGIN
		INSERT INTO YY_CQYB_YBSHZ( mc,jlzt,czyh,czrq) 
		VALUES(dbo.fun_cqyb_getvalbyseq(@input1,@seq,2),0,dbo.fun_cqyb_getvalbyseq(@input1,@seq,3),GETDATE())
    END
    IF @@ERROR <> 0 
	BEGIN
        SELECT 'F','���������ʧ�ܣ�'
	    RETURN
	END 
    SELECT 'T',''
	RETURN
END
ELSE IF @lb = 'yy_cqybddqq_yw_deleteShz' --ɾ�������
BEGIN
    BEGIN TRAN

    DELETE YY_CQYB_YBSHZBQ WHERE shzid = dbo.fun_cqyb_getvalbyseq(@input1,@seq,1) 
	IF @@ERROR <> 0 
	BEGIN
	    ROLLBACK TRAN
        SELECT 'F','ɾ������鲡��ʧ�ܣ�'
	    RETURN
	END

	DELETE YY_CQYB_YBSHZ WHERE id = dbo.fun_cqyb_getvalbyseq(@input1,@seq,1) 
    IF @@ERROR <> 0 
	BEGIN
	    ROLLBACK TRAN
        SELECT 'F','ɾ�������ʧ�ܣ�'
	    RETURN
	END
	COMMIT TRAN

	SELECT 'T','�ɹ�'
	RETURN 
END
ELSE IF @lb = 'yy_cqybddqq_yw_selectShz' --��ѯ�����
BEGIN
	select a.id �����id,a.mc ���������,a.jlzt ��¼״̬ ,b.name ������,a.czrq ��������
	FROM YY_CQYB_YBSHZ a(NOLOCK) LEFT JOIN YY_ZGBMK b(NOLOCK) ON a.czyh = b.id
	
	RETURN 
END
ELSE IF @lb = 'yy_cqybddqq_yw_selectShzbq' --��ѯ����鲡��
BEGIN
	select a.shzid �����id,a.bqdm ��������,b.name ��������,a.jlzt ��¼״̬ ,c.name ������,a.czrq ��������
	FROM YY_CQYB_YBSHZBQ a(NOLOCK) INNER JOIN ZY_BQDMK b(NOLOCK) ON a.bqdm = b.id 
								   LEFT JOIN YY_ZGBMK c(NOLOCK) ON a.czyh = c.id
	WHERE  a.shzid = dbo.fun_cqyb_getvalbyseq(@input1,@seq,1)
	
	RETURN 
END
ELSE IF @lb = 'yy_cqybddqq_yw_saveShzbq' --���������
BEGIN
    IF EXISTS(SELECT 1 FROM YY_CQYB_YBSHZBQ(NOLOCK) WHERE bqdm = dbo.fun_cqyb_getvalbyseq(@input1,@seq,2))
	BEGIN
        SELECT 'F','�ò����ѱ���������飬�����ٷ��䣡'
		RETURN 
	END

	INSERT INTO YY_CQYB_YBSHZBQ(shzid, bqdm,jlzt,czyh,czrq)
	VALUES(dbo.fun_cqyb_getvalbyseq(@input1,@seq,1),dbo.fun_cqyb_getvalbyseq(@input1,@seq,2),0,dbo.fun_cqyb_getvalbyseq(@input1,@seq,3),GETDATE())
    IF @@ERROR <> 0 
	BEGIN
        SELECT 'F','���������ʧ�ܣ�'
	    RETURN
	END 
    SELECT 'T',''
	RETURN
END
ELSE IF @lb = 'yy_cqybddqq_yw_deleteShzbq' --ɾ������鲡��
BEGIN
    BEGIN TRAN

    DELETE YY_CQYB_YBSHZBQ WHERE shzid = dbo.fun_cqyb_getvalbyseq(@input1,@seq,1) AND bqdm = dbo.fun_cqyb_getvalbyseq(@input1,@seq,2)
	IF @@ERROR <> 0 
	BEGIN
	    ROLLBACK TRAN
        SELECT 'F','ɾ������鲡��ʧ�ܣ�'
	    RETURN
	END

	COMMIT TRAN

	SELECT 'T','�ɹ�'
	RETURN 
END
ELSE IF @lb = 'yy_cqybddqq_yw_ShzReport' --����鱨��
BEGIN
    create table #shzreport       
	(        
		���	VARCHAR(64)		not null,			--��ҳ���
		�����	VARCHAR(64)		not null,			--�������
		����    NUMERIC(10)			null
	) 
	
	INSERT INTO  #shzreport
	SELECT '��Ժ' ���, d.mc ҽ����, COUNT(1) ����
	from ZY_BRSYK a(nolock) inner join ZY_BRJSK b(nolock) on a.syxh = b.syxh and b.jlzt = 0 and b.ybjszt <> 2 AND b.ybjszt <> 5
							inner join YY_CQYB_YBSHZBQ c(NOLOCK) on a.bqdm = c.bqdm AND c.jlzt = 0
							INNER JOIN YY_CQYB_YBSHZ d(NOLOCK) ON c.shzid = d.id AND d.jlzt = 0
	where a.brzt in (2,4) and a.ybdm in (select ybdm from YY_YBFLK(NOLOCK) where xtbz = 1 and ybjkid = @ybjkid) 
	GROUP BY d.mc

	INSERT INTO  #shzreport
	SELECT '��ʱ��Ժ' ���, d.mc ҽ����, COUNT(1) ����
	from ZY_BRSYK a(nolock) 
		inner join ZY_BRJSK b(nolock) on a.syxh = b.syxh and b.jlzt = 0 and b.ybjszt <> 2 AND b.ybjszt <> 5
		inner join YY_CQYB_YBSHZBQ c(NOLOCK) on a.bqdm = c.bqdm AND c.jlzt = 0
		INNER JOIN YY_CQYB_YBSHZ d(NOLOCK) ON c.shzid = d.id AND d.jlzt = 0
		inner join VW_CQYB_LSCY e(nolock) on a.syxh = e.syxh
	where a.brzt in (1,5,6,7) and a.ybdm in (select ybdm from YY_YBFLK(NOLOCK) where xtbz = 1 and ybjkid = @ybjkid)
	GROUP BY d.mc

	INSERT INTO  #shzreport
	SELECT '�������г�Ժ��¼' ���,d.mc ҽ����, COUNT(1) ����
	from ZY_BRSYK a(nolock) 
		inner join ZY_BRJSK b(nolock) on a.syxh = b.syxh and b.jlzt = 0 and b.ybjszt <> 2 AND b.ybjszt <> 5
		inner join YY_CQYB_YBSHZBQ c(NOLOCK) on a.bqdm = c.bqdm AND c.jlzt = 0
		INNER JOIN YY_CQYB_YBSHZ d(NOLOCK) ON c.shzid = d.id AND d.jlzt = 0
		inner join VW_CQYB_CYJLYJSH e(nolock) on a.syxh = e.syxh
	where a.brzt in (1,5,6,7) and a.ybdm in (select ybdm from YY_YBFLK(NOLOCK) where xtbz = 1 and ybjkid = @ybjkid) 
	GROUP BY d.mc

	--����
	/* 
	INSERT INTO  #shzreport
	SELECT '��ʱ��Ժ' ���, d.mc ҽ����, COUNT(1)+2 ����
	from ZY_BRSYK a(nolock) inner join ZY_BRJSK b(nolock) on a.syxh = b.syxh and b.jlzt = 0 and b.ybjszt <> 2 AND b.ybjszt <> 5
							inner join YY_CQYB_YBSHZBQ c(NOLOCK) on a.bqdm = c.bqdm AND c.jlzt = 0
							INNER JOIN YY_CQYB_YBSHZ d(NOLOCK) ON c.shzid = d.id AND d.jlzt = 0
	where a.brzt in (2,4) and a.ybdm in (select ybdm from YY_YBFLK(NOLOCK) where xtbz = 1 and ybjkid = @ybjkid) 
	GROUP BY d.mc
	
	INSERT INTO  #shzreport
	SELECT '�������г�Ժ��¼' ���, d.mc ҽ����, COUNT(1)+3 ����
	from ZY_BRSYK a(nolock) inner join ZY_BRJSK b(nolock) on a.syxh = b.syxh and b.jlzt = 0 and b.ybjszt <> 2 AND b.ybjszt <> 5
							inner join YY_CQYB_YBSHZBQ c(NOLOCK) on a.bqdm = c.bqdm AND c.jlzt = 0
							INNER JOIN YY_CQYB_YBSHZ d(NOLOCK) ON c.shzid = d.id AND d.jlzt = 0
	where a.brzt in (2,4) and a.ybdm in (select ybdm from YY_YBFLK(NOLOCK) where xtbz = 1 and ybjkid = @ybjkid) 
	GROUP BY d.mc
	*/
	
	SELECT 
			a.�����, 
			IDENTITY(INT,0,1) X,
			MAX(CASE a.��� WHEN '��Ժ' THEN a.���� ELSE 0 END) AS '��Ժ',
			MAX(CASE a.��� WHEN '��ʱ��Ժ' THEN a.���� ELSE 0 END) AS '��ʱ��Ժ',
			MAX(CASE a.��� WHEN '�������г�Ժ��¼' THEN a.���� ELSE 0 END) AS '�������г�Ժ��¼'
	INTO #result_hz	 
	FROM #shzreport a
	GROUP BY a.�����

	select a.* from  #result_hz a

    RETURN
END
ELSE IF @lb = 'yy_cqybddqq_cftf' --�����˷�
BEGIN
	--�˹��ܽ���ʹ��,�����˷���,�����д���HIS��������(�����ڿ����˷�);
	--select	dbo.fun_cqyb_getvalbyseq(@input1,'|',2),		--�˵��Ĵ�����ϸ�ļ�¼��
	--		dbo.fun_cqyb_getvalbyseq(@input1,'|',3)			--�����ܽ��

	SELECT 'T','�ɹ�'
	RETURN 
END
ELSE
BEGIN
   SELECT 'F','����������ϵ����Ա��'
   RETURN
END  

GO
