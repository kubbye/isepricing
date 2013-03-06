<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="../include/conn.asp" -->
<!--#include file="../include/chkUser.asp"-->
<%
	dim str,state,roleid
	state=request("state")
	roleid=request("roleid")
	str="update rolemsg set validflag="&state &"  where roleid="&roleid
	conn.execute str
	CloseDatabase
	response.Redirect("roleManager.asp")
%>
