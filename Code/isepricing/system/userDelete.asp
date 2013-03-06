<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="../include/conn.asp" -->
<!--#include file="../include/chkUser.asp"-->
<%
	dim id,strSql
	id=request("id")
	strSql="delete from userinfo  where id="&id
	conn.execute(strSql)
	strSql="delete from user_rolerel where userid="&id
	conn.execute strSql
	CloseDatabase
	response.Redirect("userManager.asp")
	%>
