<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/upload_5xsoft.inc"-->
<%

	sid=request("sid")
%>
<html>
<head>
</head>
<body>
<form action="AdditionalInfoSave.asp" method="post" enctype="multipart/form-data">
<input type="hidden" name="sid" value="<%=sid%>">
	<input type="file" name="upFile">
	<input type="submit" Value="Submit">
</form>
</body>
</html>
