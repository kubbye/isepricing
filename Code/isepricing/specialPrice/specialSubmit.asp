<!--#include file="../include/conn.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/upload_5xsoft.inc"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../include/sendMail2.asp"-->
<!--#include file="specialUtils.asp"-->
<%
	Dim roleid,sid,statusid
	roleid=session("roleid")
	sid=request("sid")
	statusid=request("statusid")
	resubmitRemark=request("resubmitRemark")
	resubmitRemark=porcSpecWord(resubmitRemark)
	isAdditional=request("isAdditional")
	isresubmit="0"
	'������֤quotation�Ƿ���apply for oit������Ѿ�apply for oit�Ĳ������ύ
	Set rs_checkstatus=conn.execute("select * from  quotation where (status=3  or  status=13)  and quotationno=(select quotationno from special_price where id="&sid&")")
	If Not rs_checkstatus.eof And Not rs_checkstatus.bof Then
		response.write("<script>alert('�õ��Ѿ���Apply for OIT��,������Submit!');</script>")
		response.write("<script>location.href='specialList.asp';</script>")
		response.end
	End If 

	'��֤�۸�ϵͳ�˶������۸��Ƿ�һ�£�����һ�£�������ѿ���ȷ�������ؼۣ�������Quotation�е����Edit Finished��
	messages="��ȷ�������ؼۣ�������Quotation�е����Edit Finished��"
	sql="select * from special_price a,quotation b where a.quotationno=b.quotationno and a.id="&sid&" and a.targetoitprice=b.targetprice and isnull(iseditfinished,0)=1"
	Set rs_checkprice=conn.execute(sql)
	If  rs_checkprice.eof or rs_checkprice.bof Then
		response.write("<script>alert('"&messages&"');</script>")
		response.write("<script>location.href='specialList.asp';</script>")
		response.End()
	End If 
	'ÿ���ύʱ���²��״̬Ϊδ���,�����addtional information���ֲ��״̬����
	sql="update special_price set application_date='"&getdate()&"',resubmitremark='"&resubmitRemark&"',updtuser='"&session("principleid")&"',updttime='"&getdate()&"' "
	If Not  IsNull(isAdditional) And isAdditional<>"" Then
		sql=sql & " ,isAdditional='"&isAdditional & "'"
	Else
		sql=sql & " ,issplit=0 "
	End If 
	If not IsNull(statusid) And statusid<>"" Then
		sql=sql & " ,status="&statusid 
	End If 
	sql=sql & " where id="&sid
	conn.execute(sql)
	
	If Not IsNull(resubmitRemark) And resubmitRemark<>"" Then
		Call doApprove(sid,3,0,resubmitRemark)
		isresubmit="1"
	Else
		Call doApprove(sid,2,0,resubmitRemark)
	End If 

	'�ȼ�¼��special_price���ϴεĽ��,ֻ����submit����resubmit��ʱ��ż�¼��
		sql="INSERT INTO SPECIAL_PRICE_HIS (id,quotationid ,quotationno ,tenderno ,username ,currencyCODE ,businessmodel ,PRODUCTMODEL ,BIDDER ,CONTRACT_PARTY ,TENDER_CLOSEDATE ,TargetOITPrice ,NetTargetPrice ,Estimated_OITPrice ,Estimated_NetOITPrice ,SpecialDiscount ,Application_DATE ,KeyAccountProfile ,ProjectBrief ,Competitor ,CompetitorPrice ,TenderPrice ,status ,crtuser ,crttime ,updtuser ,updttime ,spec_paymentterm ,paymentterm ,isAdditional ,pm_comments ,ispending ,resubmitremark ,OPERDATE) select id, quotationid ,quotationno ,tenderno ,username ,currencyCODE ,businessmodel ,PRODUCTMODEL ,BIDDER ,CONTRACT_PARTY ,TENDER_CLOSEDATE ,TargetOITPrice ,NetTargetPrice ,Estimated_OITPrice ,Estimated_NetOITPrice ,SpecialDiscount ,Application_DATE ,KeyAccountProfile ,ProjectBrief ,Competitor ,CompetitorPrice ,TenderPrice ,status ,crtuser ,crttime ,updtuser ,updttime ,spec_paymentterm ,paymentterm ,isAdditional ,pm_comments ,ispending ,resubmitremark,'"&getdate()&"' from special_price where id="&sid
		conn.execute(sql)


	'����quotationΪ���ؼ�����״̬
	sql="update quotation set status=5,updtuser='"&session("principleid")&"',updttime='"&getdate()&"' where qid in(select quotationid from special_price where id="&sid&") and status<>3  and status<>13"
	conn.execute(sql)


	'��ѯ��sid�Ļ�����Ϣ
	Set rs_base=conn.execute("select status,productmodel,quotationno from special_price where id="&sid)
	now_st=rs_base("status")
	now_productmodel=rs_base("productmodel")
	now_quotationno=rs_base("quotationno")
	'�������information���ύ��ȡ�������ʼ�
	If isAdditional="0" Then 
		Call deleteMailByRole(sid,"7")
		'����status����ж�����˭�������ʼ�
		If now_productmodel=1 Then 
			If now_st=2 Then 
				' ��ѯsd
				sql_tmp1 = "select top 1 email,username,id from userinfo where id in ( select userid from user_rolerel where roleid=8) and id in(select userid from user_zonerel where zoneid in(select zid from zone where zonename='"&getzone(now_quotationno)&"'))"
				Set rs_tmp1=conn.execute(sql_tmp1)
				While Not rs_tmp1.eof
					Call  addMail(sid,rs_tmp1("id"),"8",now_productmodel)
					rs_tmp1.movenext
				Wend 
			ElseIf now_st=3 Then
					' ��ѯsd
				sql_tmp1 = "select  email,username,bu,id from userinfo where id in ( select userid from user_rolerel where roleid=3) and bu in(select b.bu from quotation a,quotation_detail b where a.qid=b.qid and a.quotationno='"&now_quotationno&"' )"
				Set rs_tmp1=conn.execute(sql_tmp1)
				While Not rs_tmp1.eof
					Call  addMail(sid,rs_tmp1("id"),"3",now_productmodel)
					rs_tmp1.movenext
				Wend 
			ElseIf now_st=4 Then
					' ��ѯsd
				sql_tmp1 = "select  email,username,id from userinfo where id in ( select userid from user_rolerel where roleid=6)"
				Set rs_tmp1=conn.execute(sql_tmp1)
				While Not rs_tmp1.eof
					Call  addMail(sid,rs_tmp1("id"),"6",now_productmodel)
					rs_tmp1.movenext
				Wend 
			End If 
		End If 
		If now_productmodel=2 Then 
			If now_st=2 Then 
				' ��ѯsd
				sql_tmp1 = "select top 1 email,username,id from userinfo where id in ( select userid from user_rolerel where roleid=8) and id in(select userid from user_zonerel where zoneid in(select zid from zone where zonename='"&getzone(now_quotationno)&"'))"
				Set rs_tmp1=conn.execute(sql_tmp1)
				While Not rs_tmp1.eof
					Call  addMail(sid,rs_tmp1("id"),"8",now_productmodel)
					rs_tmp1.movenext
				Wend 
			ElseIf now_st=3 Then
					' ��ѯfc
				sql_tmp1 = "select  email,username,id from userinfo where id in ( select userid from user_rolerel where roleid=6)"
				Set rs_tmp1=conn.execute(sql_tmp1)
				While Not rs_tmp1.eof
					Call  addMail(sid,rs_tmp1("id"),"6",now_productmodel)
					rs_tmp1.movenext
				Wend 
				' ��ѯmd
				sql_tmp2 = "select  email,username,id from userinfo where id in ( select userid from user_rolerel where roleid=4)"
				Set rs_tmp2=conn.execute(sql_tmp2)
				While Not rs_tmp2.eof
					Call  addMail(sid,rs_tmp2("id"),"4",now_productmodel)
					rs_tmp2.movenext
				Wend 
			ElseIf now_st=5 Then
					' ��ѯmd
				sql_tmp1 = "select  email,username,id from userinfo where id in ( select userid from user_rolerel where roleid=4)"
				Set rs_tmp1=conn.execute(sql_tmp1)
				While Not rs_tmp1.eof
					Call  addMail(sid,rs_tmp1("id"),"4",now_productmodel)
					rs_tmp1.movenext
				Wend 
			ElseIf now_st=6 Then
					' ��ѯfc
				sql_tmp1 = "select  email,username,id from userinfo where id in ( select userid from user_rolerel where roleid=6)"
				Set rs_tmp1=conn.execute(sql_tmp1)
				While Not rs_tmp1.eof
					Call  addMail(sid,rs_tmp1("id"),"6",now_productmodel)
					rs_tmp1.movenext
				Wend 
			End If 

		End If 
	Else
		'��sd���ʹ������ʼ�
		Call sendmailDMSubmit(sid,isresubmit,false)
	End If 
	
	'�ر����ݿ�����
	CloseDatabase

	response.write("<script>location.href='specialList.asp';</script>")
%>