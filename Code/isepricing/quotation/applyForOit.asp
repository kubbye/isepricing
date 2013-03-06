<!--#include file="../include/conn.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/sendMail2.asp"-->
<%
	dim qid,strsql
	qid=request("qid")
	response.Charset="gb2312"
	'如果已经有特价记录，且为new的状态，需要提醒Cancel特价如果已经有特价记录，且为new的状态，需要提醒Cancel特价
	sql="select * from special_price where (status=0)and quotationno=(select quotationno from quotation where qid="&qid&")"
	Set rs_statusQuery=conn.execute(sql)
	If Not rs_statusQuery.eof And Not rs_statusQuery.bof Then
		response.write("<script>alert('请先删除本单的特价申请，再申请进单！');</script>")
		response.write("<script>location.href='quotationList.asp';</script>")
		response.end
	End If 
	'如果已经有特价记录，且为wait dm to check，需要提醒先处理特价
	sql="select * from special_price where (status=-2 or status=-9 or ispending=1)and quotationno=(select quotationno from quotation where qid="&qid&")"
	Set rs_statusQuery=conn.execute(sql)
	If Not rs_statusQuery.eof And Not rs_statusQuery.bof Then
		response.write("<script>alert('请先处理该单的SpecialPrice再“Apply for OIT”!');</script>")
		response.write("<script>location.href='quotationList.asp';</script>")
		response.end
	End If 

	strsql="update quotation set status=3,updtuser='"&session("principleid")&"',updttime='"&getdate()&"' where qid="&qid
	conn.execute strsql
	'发送邮件
	Call sendmailApplyForOIT (qid)
	CloseDatabase
	response.write("<script>alert('success');</script>")
	response.write("<script>location.href='quotationList.asp';</script>")
%>
