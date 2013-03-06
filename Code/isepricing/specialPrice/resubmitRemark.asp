<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/commons.asp"-->
<!--#include file="../include/chkUser.asp"-->
<%

	sid=request("sid")
	statusid=request("statusid")
%>
<html>
<head>
<LINK href="../css/css.css" type=text/css rel=stylesheet>
<script type="text/javascript" src="../js/jquery-1.2.6.js"></script>
<script>
	function doSubmit()
	{
		var f=document.forms[0];
		var sid=$("#sid").val();
		var statusid=$("#statusid").val();
		var resubmitRemark=$("#resubmitRemark").val();
		if (resubmitRemark==null || resubmitRemark=='')
		{
			alert("请填写再次提交申请的理由");
			return false;
		}
		f.action="specialSubmit.asp?sid="+sid+"&statusid="+statusid;
		f.submit();
	}
</script>
</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0">
<div align="center">
<form action="specialSubmit.asp" method="post">
<input type="hidden" name="sid" id="sid" value="<%=sid%>">
<input type="hidden" name="statusid" id="statusid" value="<%=statusid%>">
	 <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
	<tr class="line01"><td align="left">
	<strong>Reasons for Resubmitting:</strong>
	<br><br>
	<textarea name="resubmitRemark" id="resubmitRemark" rows="4" cols="60">
	</textarea>
	<br>
	<input type="button" value="Submit" onclick="doSubmit();">
	</td></tr>
	</table>
	  <!--#include file="../footer.asp"-->
</form>
<script>
	$("#resubmitRemark").val('');
</script>
</div>
</body>
</html>
