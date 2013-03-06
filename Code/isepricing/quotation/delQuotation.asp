<!--#include file="../include/conn.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../include/utils.asp"-->

<%
	dim qid,strsql
	qid=request("qid")
	strsql="update quotation set status=2,updtuser='"&session("principleid")&"',updttime='"&getdate()&"' where qid="&qid
	conn.execute strsql

	'如果有特价申请，删除特价申请
	'删除特价申请记录
	sql="delete from special_price where quotationid="&qid
	conn.execute(sql)
	sql="delete from special_approve where specialId in(select id from special_price where quotationid="&qid&")"
	conn.execute(sql)
	sql="delete from special_files where specialId in (select id from special_price where quotationid="&qid&")"
	conn.execute(sql)
	sql="delete from special_detail where specialId  in (select id from special_price where quotationid="&qid&")"
	conn.execute(sql)
	CloseDatabase
	response.Write("success")
%>
