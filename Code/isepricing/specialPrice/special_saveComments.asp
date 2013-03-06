<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="specialUtils.asp"-->
<%
	Dim sid,qid
	sid=request("sid")
	pm_comments=request("comments")
	'

	Call doApprove(sid,4,0,pm_comments)
	'sql="update special_price set pm_comments='"&pm_comments&"' ,updtuser='"&session("principleid")&"',updttime='"&getdate()&"' where id="&sid
	'conn.execute(sql)
	'关闭数据库连接
	CloseDatabase
%>