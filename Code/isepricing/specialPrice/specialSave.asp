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
		'�ȼ�¼��special_price���ϴεĽ��,ֻ����submit����resubmit��ʱ��ż�¼��
		sql="INSERT INTO SPECIAL_PRICE_HIS (id,quotationid ,quotationno ,tenderno ,username ,currencyCODE ,businessmodel ,PRODUCTMODEL ,BIDDER ,CONTRACT_PARTY ,TENDER_CLOSEDATE ,TargetOITPrice ,NetTargetPrice ,Estimated_OITPrice ,Estimated_NetOITPrice ,SpecialDiscount ,Application_DATE ,KeyAccountProfile ,ProjectBrief ,Competitor ,CompetitorPrice ,TenderPrice ,status ,crtuser ,crttime ,updtuser ,updttime ,spec_paymentterm ,paymentterm ,isAdditional ,pm_comments ,ispending ,resubmitremark ,OPERDATE) select id, quotationid ,quotationno ,tenderno ,username ,currencyCODE ,businessmodel ,PRODUCTMODEL ,BIDDER ,CONTRACT_PARTY ,TENDER_CLOSEDATE ,TargetOITPrice ,NetTargetPrice ,Estimated_OITPrice ,Estimated_NetOITPrice ,SpecialDiscount ,Application_DATE ,KeyAccountProfile ,ProjectBrief ,Competitor ,CompetitorPrice ,TenderPrice ,status ,crtuser ,crttime ,updtuser ,updttime ,spec_paymentterm ,paymentterm ,isAdditional ,pm_comments ,ispending ,resubmitremark,'"&getdate()&"' from special_price where id="&sid
		'conn.execute(sql)

		'1.�ȱ����޸ĺ�ļ�¼
		'2.�ж��Ƿ����ύ����δ�ύ���ģ��޸�Ϊԭʼ״̬��δreject״̬�ģ�����reject״̬�����ύ������Ϊ��reject״̬�ģ�ת��3��
		'3.���ύ�����ж��Ƿ񳬳���׼��1%����5000���𣩣�
		'4.δ�����ģ�����ԭ����״̬
		'5.������׼�ģ�����֮ǰ��״̬Ϊwait dm to check�ĸ�Ϊwait dm to resubmit�����ǵĲ��仯
		strSql="update special_price set Estimated_OITPrice='"&estimatedOitPrice&"',Estimated_NetOITPrice='"&estimatedStandardprice&"',SpecialDiscount='"&SpecialDiscount&"',TENDER_CLOSEDATE='"&tenderClosingDate&"',BIDDER='"&bidder&"',CONTRACT_PARTY='"&ContractParty&"',KeyAccountProfile='"&KeyAccountProfile&"',ProjectBrief='"&ProjectBrief&"',Competitor='"&Competitor&"',CompetitorPrice='"&CompetitorPrice&"',TenderPrice='"&TenderPrice&"',updtuser='"&session("principleid")&"',updttime='"&getdate()&"'  where id="& sid
		conn.execute(strsql)
		'�ж����ڵ�״̬�������reject
		Set rs_rejectorder=conn.execute("select status,ispending from special_price where status<=-3 and id="&sid)
		Dim isRejected
		isRejected=False 
		If Not rs_rejectorder.eof And Not  rs_rejectorder.bof Then
			isRejected=true
		End If 
		'����޸�֮ǰ��wait dm to check ״̬����Ҫ���ʼ��������Ա
		Set rs_tocheck=conn.execute("select status,ispending from special_price where (status=-2 or  ispending=1 or ispending=9) and id="&sid)
		isSendtoCheckMail=False 
		If Not rs_tocheck.eof And Not  rs_tocheck.bof Then
			isSendtoCheckMail=true
		End If 
		
		If Not isRejected Then 
		'�����wait dm to check ״̬���ж��ؼ۵ı仯
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
				'����۸�������5000$�����ۿ۽�����1%��ֱ�Ӵ�ظ�am
				'����ֱ�Ӹ���pending״̬Ϊ��pending
				'response.write(currencyrate)
				'response.End()
				If (oitPrice-oldoitprice)>=(2000*currencyrate) or cint(SpecialDiscount-oldpridediscount)<=-1   Then
					sql="update special_price set status=-9,ispending=0,updtuser='"&session("principleid")&"',updttime='"&getdate()&"' where (status=-2 or ispending=1 or ispending=9 ) and id="&sid
					conn.execute(sql)
					'�����ʼ�
					ifDiscountChange=True 
				Else
					sql="update special_price set ispending=0 ,updtuser='"&session("principleid")&"',updttime='"&getdate()&"' where id="&sid
					conn.execute(sql)
					'������ͨ����δ������quotation�����δ�仯����Ϊ������״̬
					sql="update quotation set status=11 where status!=3 and  qid="&qid &" and qid in(select quotationid from  special_price where  status=11 and id="&sid&")"
					conn.execute(sql)
					'��������ͨ����δ������quotation�����δ�仯����Ϊ��reject״̬
					sql="update quotation set status=-1 where status!=3 and  qid="&qid &" and qid in(select quotationid from  special_price where status!=-2 and  status<0 and id="&sid&")"
					conn.execute(sql)
				End If
					'�����ʼ�
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
		'������Ϣ
		StrSql="INSERT INTO SPECIAL_PRICE (quotationid ,quotationno ,tenderno ,username ,currencyCODE ,businessmodel,paymentterm,spec_paymentterm,PRODUCTMODEL ,BIDDER ,CONTRACT_PARTY ,TENDER_CLOSEDATE ,TargetOITPrice ,NetTargetPrice ,Estimated_OITPrice ,Estimated_NetOITPrice ,SpecialDiscount,Application_DATE ,KeyAccountProfile ,ProjectBrief ,Competitor ,CompetitorPrice ,TenderPrice ,status,crtuser ,crttime ) VALUES('"&qid&"','"&quotationNo&"','"&tenderno&"','"&finalusername&"','"&currencycode&"','"&businessmodel&"','"&paymentterm&"','"&spec_paymentterm&"','"&productmodel&"','"&bidder&"','"&contractParty&"','"&tenderclosingdate&"','"&oitprice&"','"&standardprice&"','"&estimatedOitprice&"','"&estimatedstandardprice&"','"&SpecialDiscount&"','"&ApplicationDate&"','"&KeyAccountProfile&"','"&ProjectBrief&"','"&Competitor&"','"&CompetitorPrice&"','"&TenderPrice&"',0,'"&session("principleid")&"','"&getdate()&"')"
		conn.execute(StrSql)

		'�õ��ող���ļ�¼��id
		Set rs=conn.execute("select @@identity as sid")
		sid=rs("sid")
	End If
	
	
	
	'�ϴ��ļ�
	randomize   
	d=date()
	d=replace(d,"-","")
	d=replace(d,".","")
	d=replace(d,"/","")

	Dim MAX_FILESIZE
	MAX_FILESIZE=3300000
	for each formName in upload.file     '�г������ϴ��˵��ļ�
		 set file=upload.file(formName)  '����һ���ļ�����
		 if file.FileSize>0 then          '��� FileSize > 0 ˵�����ļ�����
			 If file.FileSize>MAX_FILESIZE Then
				response.write("<script>alert('����ϴ��ļ����ܳ���3M,�������ϴ���');</script>")
			 End If
			 uploadfileName=file.FilePath
			 quotpos=InStr(uploadfileName,".")
			 allLen=Len(uploadfileName)
			 aliasName=uploadfileName
			 fileext=Right(uploadfileName,allLen-quotpos)
			 fname = file.FileName
			 dname=d&int((1000000*rnd()))
			 filepath=dname&"."&fileext
			 
			 '��ȡ���ļ�����
			 aliasName=replace(aliasName,"\","/")
			 aliasNameArr=Split(aliasName,"/")
			 aliasName=aliasNameArr(UBound(aliasNameArr))
			 file.SaveAs Server.mappath(filepath&fname)   '�����ļ�
			 '�����ļ���Ϣ
			 filesql="insert into special_files(specialId,filepath,filename)values("&sid&",'"&filepath&"','"&aliasName&"')"
			 conn.execute(filesql)
		 end if
		set file=nothing
	next
	set upload=nothing  ''ɾ���˶���
	

	'�ر����ݿ�����
	CloseDatabase



	response.write("<script>location.href='specialList.asp';</script>")
%>