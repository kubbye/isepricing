<!--#include file="../include/conn.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/sendMail.asp"-->
<!--#include file="../include/constant.asp"-->

<%
'userid = request("userid")

'sql = "update product set status='2', updtuser='" & session("userid") & "', updttime='" & getdate() & "' where state='0' and status='3' and crtuser='" & userid & "'"

bu = request("bu")
pid = request("pid")
sql = "update product set status='2', updtuser='" & session("userid") & "', updttime='" & getdate() & "' where pid=" & pid

conn.execute(sql)

Call sendmailbudirectorreject(getversion(1), session("user_bu"), pid)

%>

<script language="javascript">
  alert ("Operation success!");
  location.assign("product_search.asp?status=-1&bu=<%=bu%>");
</script>