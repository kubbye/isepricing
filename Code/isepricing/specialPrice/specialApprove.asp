<!--#include file="../include/conn.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../include/sendMail2.asp"-->
<!--#include file="specialUtils.asp"-->
<%
	Dim roleid,sid,statusid
	roleid=session("roleid")
	statusid=request("statusid")

	sid=request("specialId")
	comments=request("comments")
	actiontype=request("actiontype")
	result=request("result")

	comments=porcSpecWord(comments)
	'审批
	Call doApprove(sid,actiontype,result,comments)
	
	If result=3 Then
		sql="update special_price set isAdditional='1',updtuser='"&session("principleid")&"',updttime='"&getdate()&"' where id="&sid
		conn.execute(sql)
		Call sendmailAddtionnalInformation(sid,false)
	End If
	If result<>3 Then
		'流转到下一个流程
		sql="update special_price set status="&statusid &",updtuser='"&session("principleid")&"',updttime='"&getdate()&"' where id="&sid
		
		'如果审批不通过，更新quotation的状态rejected
		If result=2 Then
			quotationSql="update quotation set status=-1 where qid in(select quotationid from special_price where id="&sid&")"
			conn.execute(quotationSql)
		End if
		'如果审批通过了，更新quotation为审批通过
		If statusid=11 Then
			quotationSql="update quotation set status=11 where qid in(select quotationid from special_price where id="&sid&")"
			conn.execute(quotationSql)
		End if
	End if
	
	conn.execute(sql)
	'查询是multi modality还是single modality
	sql="select productmodel from special_price where id="&sid
	Set rs_pro=conn.execute(sql)
	If  Not rs_pro.eof   Then 
		productmodel=rs_pro("productmodel")
	End If  
	'如果是审批流程，发送审批邮件
	If actiontype="1" And productmodel="1" Then
		If roleid="8" And result="1" Then   'sd 审批通过
			Call sendmailSDApproved(sid,false)
		End If 
		If roleid="8" And result="2" Then   'sd 审批不通过
			Call sendmailSDReject(sid)
		End If 

		If roleid="3" And result="1" Then   'bu Director  审批通过
			Call sendmailBuApproved(sid,false)
		End If 
		If roleid="3" And result="2" Then   'bu Director  审批不通过
			Call sendmailBuReject(sid)
		End If 

		If roleid="6" And result="1" Then   'fc Director  审批通过
			Call sendmailFCApproved(sid,false)
		End If 
		If roleid="6" And result="2" Then   'fc Director  审批不通过
			Call sendmailFCReject(sid)
		End If 
	End If 

		'如果是审批流程，发送审批邮件
	If actiontype="1" And productmodel="2" Then
		If roleid="8" And result="1" Then   'sd 审批通过
			Call sendmailSDApproved_multi(sid,false)
		End If 
		If roleid="8" And result="2" Then   'sd 审批不通过
			Call sendmailSDReject_multi(sid)
		End If 

		If (roleid="6" Or roleid="4")And result="1" Then   'fc or md  审批通过
			Call sendmailFCApproved_multi(sid,false)
		End If 
		If (roleid="6" Or roleid="4") And result="2" Then   'fc or md  审批不通过
			Call sendmailFCReject_multi(sid)
		End If 
	End If 

	rs_pro.close
	Set rs_pro=Nothing 
	'关闭数据库连接
	CloseDatabase
	


	response.write("<script>location.href='specialList.asp';</script>")
%>
