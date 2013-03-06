<!--#include file="../include/conn.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../include/sendMail2.asp"-->
<!--#include file="specialUtils.asp"-->
<%
	Dim sid,qid
	sid=request("sid")
	qid=request("qid")

	'如果在审批过程中，需要发邮件给需要审批的人
	sql="select productmodel,status from special_price where id="&sid
	Set rs_prd=conn.execute(sql)
	productmodel=1
	nowstatus=0
	If Not rs_prd.eof Then
		productmodel=rs_prd("productmodel")
		nowstatus=rs_prd("status")
	End If 

	
	'更新特价状态为Cancel
	sql="update special_price set status='-11',ispending=0,isAdditional=0 where id="&sid
	conn.execute(sql)
	'删除提醒邮件
	sql="delete from special_mail where sid="&sid
	conn.execute(sql)
	'更新quotation状态
	sql="update quotation set status=0 where status<>3  and status<>13 and status<>2 and  qid="&qid
	conn.execute(sql)
	'插入流水表
	Call doApprove(sid,5,0,"")
	

	If productmodel=1 Then
		Call sendmailCancel_single(sid,nowstatus)
	ElseIf productmodel=2 Then
		Call sendmailCancel_multi(sid,nowstatus)
	End if
	'关闭数据库连接
	CloseDatabase

	response.write("<script>location.href='specialList.asp';</script>")
%>