<!--#include file="../include/conn.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/upload_5xsoft.inc"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../include/sendMail2.asp"-->
<%
	Dim upload
	Set upload=new upload_5xsoft
	sid=upload.form("sid")
	qid=upload.form("qid")
	quotationNo=upload.form("quotationNo")
	businessModel=upload.form("businessmodel")
	paymentterm=upload.form("paymentterm")
	spec_paymentterm=upload.form("spec_paymentterm")
	currencycode=upload.form("currencycode")
	productModel=upload.form("productModel")
	oitPrice=upload.form("oitPrice")
	tenderno=upload.form("tenderno")
	standardprice=upload.form("standardprice")
	finalusername=upload.form("finalusername")
	estimatedOitPrice=upload.form("estimatedOitPrice")
	bidder=upload.form("bidder")
	estimatedStandardprice=upload.form("estimatedStandardprice")
	ContractParty=upload.form("ContractParty")
	SpecialDiscount=upload.form("SpecialDiscount")
	tenderClosingDate=upload.form("tenderClosingDate")
	ApplicationDate=upload.form("ApplicationDate")
	KeyAccountProfile=upload.form("KeyAccountProfile")
	ProjectBrief=upload.form("ProjectBrief")
	Competitor=upload.form("Competitor")
	CompetitorPrice=upload.form("CompetitorPrice")
	TenderPrice=upload.form("TenderPrice")
	
	quotationNo=porcSpecWord(quotationNo)
	businessModel=porcSpecWord(businessModel)
	paymentterm=porcSpecWord(paymentterm)
	spec_paymentterm=porcSpecWord(spec_paymentterm)
	currencycode=porcSpecWord(currencycode)
	productModel=porcSpecWord(productModel)
	oitPrice=porcSpecWord(oitPrice)
	tenderno=porcSpecWord(tenderno)
	standardprice=porcSpecWord(standardprice)
	finalusername=porcSpecWord(finalusername)
	estimatedOitPrice=porcSpecWord(estimatedOitPrice)
	bidder=porcSpecWord(bidder)
	estimatedStandardprice=porcSpecWord(estimatedStandardprice)
	ContractParty=porcSpecWord(ContractParty)
	KeyAccountProfile=porcSpecWord(KeyAccountProfile)
	ProjectBrief=porcSpecWord(ProjectBrief)
	Competitor=porcSpecWord(Competitor)
	CompetitorPrice=porcSpecWord(CompetitorPrice)
	TenderPrice=porcSpecWord(TenderPrice)
	
	currencyrate=1
	If(currencycode<>"USD") Then 
		Set RS_CURRENCY=conn.execute("select * from dbo.exchanges where sourcecode='"&currencycode&"'")
		currencyrate=RS_CURRENCY("rate")
	End If 
	If Not IsNull(sid) And sid<>"" Then
		'先记录下special_price的上次的结果,只有是submit或者resubmit的时候才记录下
		sql="INSERT INTO SPECIAL_PRICE_HIS (id,quotationid ,quotationno ,tenderno ,username ,currencyCODE ,businessmodel ,PRODUCTMODEL ,BIDDER ,CONTRACT_PARTY ,TENDER_CLOSEDATE ,TargetOITPrice ,NetTargetPrice ,Estimated_OITPrice ,Estimated_NetOITPrice ,SpecialDiscount ,Application_DATE ,KeyAccountProfile ,ProjectBrief ,Competitor ,CompetitorPrice ,TenderPrice ,status ,crtuser ,crttime ,updtuser ,updttime ,spec_paymentterm ,paymentterm ,isAdditional ,pm_comments ,ispending ,resubmitremark ,OPERDATE) select id, quotationid ,quotationno ,tenderno ,username ,currencyCODE ,businessmodel ,PRODUCTMODEL ,BIDDER ,CONTRACT_PARTY ,TENDER_CLOSEDATE ,TargetOITPrice ,NetTargetPrice ,Estimated_OITPrice ,Estimated_NetOITPrice ,SpecialDiscount ,Application_DATE ,KeyAccountProfile ,ProjectBrief ,Competitor ,CompetitorPrice ,TenderPrice ,status ,crtuser ,crttime ,updtuser ,updttime ,spec_paymentterm ,paymentterm ,isAdditional ,pm_comments ,ispending ,resubmitremark,'"&getdate()&"' from special_price where id="&sid
		'conn.execute(sql)

		'1.先保存修改后的记录
		'2.判断是否已提交过：未提交过的，修改为原始状态；未reject状态的，保持reject状态；已提交过的且为非reject状态的，转第3步
		'3.已提交过的判断是否超出标准（1%或者5000美金）：
		'4.未超过的，保留原来的状态
		'5.超过标准的，并且之前的状态为wait dm to check的改为wait dm to resubmit，不是的不变化
		strSql="update special_price set Estimated_OITPrice='"&estimatedOitPrice&"',Estimated_NetOITPrice='"&estimatedStandardprice&"',SpecialDiscount='"&SpecialDiscount&"',TENDER_CLOSEDATE='"&tenderClosingDate&"',BIDDER='"&bidder&"',CONTRACT_PARTY='"&ContractParty&"',KeyAccountProfile='"&KeyAccountProfile&"',ProjectBrief='"&ProjectBrief&"',Competitor='"&Competitor&"',CompetitorPrice='"&CompetitorPrice&"',TenderPrice='"&TenderPrice&"',updtuser='"&session("principleid")&"',updttime='"&getdate()&"'  where id="& sid
		conn.execute(strsql)
		'判断现在的状态，如果是reject
		Set rs_rejectorder=conn.execute("select status,ispending from special_price where status<=-3 and id="&sid)
		Dim isRejected
		isRejected=False 
		If Not rs_rejectorder.eof And Not  rs_rejectorder.bof Then
			isRejected=true
		End If 
		'如果修改之前是wait dm to check 状态，需要发邮件给相关人员
		Set rs_tocheck=conn.execute("select status,ispending from special_price where (status=-2 or  ispending=1 or ispending=9) and id="&sid)
		isSendtoCheckMail=False 
		If Not rs_tocheck.eof And Not  rs_tocheck.bof Then
			isSendtoCheckMail=true
		End If 
		
		If Not isRejected Then 
		'如果是wait dm to check 状态，判断特价的变化
		Set rs_status=conn.execute("select * from special_approve where (actiontype=2 or actiontype=3) and specialId="&sid)
		If Not rs_status.eof And Not  rs_status.bof  Then
			ifDiscountChange=False
			Set rs_spe_price=conn.execute("select top 1 * from special_price_his where id="&sid&" order by operdate desc")
			If Not rs_spe_price.bof And Not rs_spe_price.eof Then
				oldtargetprice=rs_spe_price("nettargetprice")
				oldoitprice=rs_spe_price("targetoitprice")
				oldpridediscount=rs_spe_price("specialdiscount")
				oldestargetpriceesoitprice=rs_spe_price("estimated_netoitprice")
				esoitprice=rs_spe_price("estimated_oitprice")
				
				'newesSdprice=esoitprice-(oitprice-targetprice)
				'If targetprice=0 Or targetprice="0" Then
					'discount=0
				'Else
					'discount=CLng((newesSdprice/targetprice-1)*1000)/10
				'End If 
				'如果价格增加了5000$或者折扣降低了1%，直接打回给am
				'否则直接更新pending状态为不pending
				'response.write(currencyrate)
				'response.End()
				If (oitPrice-oldoitprice)>=(2000*currencyrate) or cint(SpecialDiscount-oldpridediscount)<=-1   Then
					sql="update special_price set status=-9,ispending=0,updtuser='"&session("principleid")&"',updttime='"&getdate()&"' where (status=-2 or ispending=1 or ispending=9 ) and id="&sid
					conn.execute(sql)
					'发送邮件
					ifDiscountChange=True 
				Else
					sql="update special_price set ispending=0 ,updtuser='"&session("principleid")&"',updttime='"&getdate()&"' where id="&sid
					conn.execute(sql)
					'已审批通过的未进单的quotation，如果未变化，改为已审批状态
					sql="update quotation set status=11 where status!=3 and  qid="&qid &" and qid in(select quotationid from  special_price where  status=11 and id="&sid&")"
					conn.execute(sql)
					'已审批不通过的未进单的quotation，如果未变化，改为已reject状态
					sql="update quotation set status=-1 where status!=3 and  qid="&qid &" and qid in(select quotationid from  special_price where status!=-2 and  status<0 and id="&sid&")"
					conn.execute(sql)
				End If
					'发送邮件
				If ifDiscountChange Then
					Call sendmailDiscountChange(sid)
				End If 
			 End If
		 Else 
				conn.execute("update special_price set status=0,ispending=0 where id="&sid)
		End If 
		Else 
			conn.execute("update special_price set ispending=0 where id="&sid)
		End If 
	
		If isSendtoCheckMail Then 
			Call sendmailCheckFinished(sid)
		End If 
		conn.execute("update special_price set isneedmsg=0 where id="&sid)
	Else
		'保存信息
		StrSql="INSERT INTO SPECIAL_PRICE (quotationid ,quotationno ,tenderno ,username ,currencyCODE ,businessmodel,paymentterm,spec_paymentterm,PRODUCTMODEL ,BIDDER ,CONTRACT_PARTY ,TENDER_CLOSEDATE ,TargetOITPrice ,NetTargetPrice ,Estimated_OITPrice ,Estimated_NetOITPrice ,SpecialDiscount,Application_DATE ,KeyAccountProfile ,ProjectBrief ,Competitor ,CompetitorPrice ,TenderPrice ,status,crtuser ,crttime ) VALUES('"&qid&"','"&quotationNo&"','"&tenderno&"','"&finalusername&"','"&currencycode&"','"&businessmodel&"','"&paymentterm&"','"&spec_paymentterm&"','"&productmodel&"','"&bidder&"','"&contractParty&"','"&tenderclosingdate&"','"&oitprice&"','"&standardprice&"','"&estimatedOitprice&"','"&estimatedstandardprice&"','"&SpecialDiscount&"','"&ApplicationDate&"','"&KeyAccountProfile&"','"&ProjectBrief&"','"&Competitor&"','"&CompetitorPrice&"','"&TenderPrice&"',0,'"&session("principleid")&"','"&getdate()&"')"
		conn.execute(StrSql)

		'得到刚刚插入的记录的id
		Set rs=conn.execute("select @@identity as sid")
		sid=rs("sid")
	End If
	
	
	
	'上传文件
	randomize   
	d=date()
	d=replace(d,"-","")
	d=replace(d,".","")
	d=replace(d,"/","")

	Dim MAX_FILESIZE
	MAX_FILESIZE=3300000
	for each formName in upload.file     '列出所有上传了的文件
		 set file=upload.file(formName)  '生成一个文件对象
		 if file.FileSize>0 then          '如果 FileSize > 0 说明有文件数据
			 If file.FileSize>MAX_FILESIZE Then
				response.write("<script>alert('最大上传文件不能超过3M,请重新上传！');</script>")
			 End If
			 uploadfileName=file.FilePath
			 quotpos=InStr(uploadfileName,".")
			 allLen=Len(uploadfileName)
			 aliasName=uploadfileName
			 fileext=Right(uploadfileName,allLen-quotpos)
			 fname = file.FileName
			 dname=d&int((1000000*rnd()))
			 filepath=dname&"."&fileext
			 
			 '截取下文件名称
			 aliasName=replace(aliasName,"\","/")
			 aliasNameArr=Split(aliasName,"/")
			 aliasName=aliasNameArr(UBound(aliasNameArr))
			 file.SaveAs Server.mappath(filepath&fname)   '保存文件
			 '保存文件信息
			 filesql="insert into special_files(specialId,filepath,filename)values("&sid&",'"&filepath&"','"&aliasName&"')"
			 conn.execute(filesql)
		 end if
		set file=nothing
	next
	set upload=nothing  ''删除此对象
	

	'关闭数据库连接
	CloseDatabase



	response.write("<script>location.href='specialList.asp';</script>")
%>