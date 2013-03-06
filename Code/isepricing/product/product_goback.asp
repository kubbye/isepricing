<!--#include file="../include/conn.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/sendMail.asp"-->
<!--#include file="../include/constant.asp"-->

<%
bu = request("bu")
version = getversion("1")
backtostatus = request("backtostatus")

sql = "update product set status='" & backtostatus & "', updtuser='" & session("userid") & "', updttime='" & getdate() & "' where version='" & version & "' and mid in (select mid from modality where bu=" & bu & ") and state='0'"
conn.execute(sql)

If session("roleid") = "1" Then 
	'Pricing goback
	Call sendmailpricinggoback(version, bu, backtostatus)
Else 
	Call sendmailfcmdgoback(version)
End If 

%>

<script language="javascript">
  alert ("Operation success!");
  location.assign("product_search.asp?status=-1&bu=<%=bu%>");
</script>