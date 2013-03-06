<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="../include/conn.asp" -->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/commons.asp"-->
<!--#include file="roleutils.asp"-->
<%
	dim str,id,funstatus
	id=request("id")
	funstatus=request("funstatus")
	str="update functiontree set validflag="&funstatus&" where funid="&id
	conn.execute str
	
	call writeFuncByRoleId ("")
	CloseDatabase
	response.Redirect("functionManager.asp")
%>
