<!--#include file="../include/conn.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../include/sendMail2.asp"-->
<%
	'查询已提交但是未审批完成的订单
	sql="select  distinct sid,roleid,productmodel  from special_mail where datediff(day,operdate,getdate())%3=0 and datediff(day,operdate,getdate())>0 and sid not in (select id from special_price where status in(-2) or ispending in (1,9))"
	Set rs_1=conn.execute(sql)
	While Not rs_1.eof And Not rs_1.bof
		sid=rs_1("sid")
		roleid=rs_1("roleid")
		productModel=rs_1("productmodel")
		'addtional information
		If roleid="7" Then 
			Call sendmailAddtionnalInformation(sid,true)
		End If 
		If productModel="1" Then
			If roleid="8" Then   'sd 审批通过
				Call sendmailDMSubmit(sid,false,true)
			End If 

			If roleid="3"  Then   'bu Director  审批通过
				Call sendmailSDApproved(sid,true)
			End If 

			If roleid="6" Then   'fc Director  审批通过
				Call sendmailBuApproved(sid,true)
			End If 
		End If 

		'如果是审批流程，发送审批邮件
		If   productModel="2" Then
			If roleid="8"  Then   'sd 审批通过
				Call sendmailDMSubmit(sid,false,true)
			End If 
			If (roleid="6" Or roleid="4") Then   'fc or md  审批通过
				Call sendmailSDApproved_multi(sid,true)
			End If 
		End If 
		rs_1.movenext
	wend

	rs_1.close
	Set rs_1=Nothing 
	'关闭数据库连接
	CloseDatabase
	response.write("<script>alert('发送成功');location.href='specialList.asp';</script>")
%>