<!--#include file="../include/conn.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/chkUser.asp"-->

<%
pid = request("pid")
bu = request("bu")

sql = "update product set state='1', updtuser='" & session("userid") & "', updttime='" & getdate() & "' where pid=" & pid
conn.execute(sql)
%>

<script language="javascript">
  alert ("Operation success!");
  location.assign("product_search.asp?status=-1&bu=<%=bu%>");
</script>