<!--#include file="../include/conn.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../include/sendMail2.asp"-->
<%
	Dim sid,qid
	sid=request("sid")
	qid=request("qid")

	'删除所有的记录
	sql="delete from special_detail where specialid="&sid
	conn.execute(sql)
	'查询qdid
	sql="select qdid,productname from quotation_detail where qid="&qid
	Set rs=conn.execute(sql)
	while Not rs.eof 
		If Not IsNull(request("splitOit"&rs("qdid"))) And request("splitOit"&rs("qdid"))<>"" Then
			sql="insert into special_detail(specialid,productname,qdid,estimateprice,estmateStandardPrice,estmateDiscount) values('"&sid&"','"&rs("productname")&"','"&rs("qdid")&"','"&request("splitOit"&rs("qdid"))&"','"&request("splitSd"&rs("qdid"))&"','"&request("splitDiscount"&rs("qdid"))&"')"
			conn.execute(sql)
		End if
		rs.movenext
	wend
	
	'更新special_price为已拆分状态
	sql="update special_price set issplit=1,updtuser='"&session("principleid")&"',updttime='"&getdate()&"'  where id="&sid
	conn.execute(sql)
	rs.close
	Set rs=Nothing 

	'发送邮件
	'Call sendmailPricingBreakDown(sid)
	'关闭数据库连接
	CloseDatabase

	response.write("<script>window.close();</script>")
%>