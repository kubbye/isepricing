<!--#include file="../include/conn.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/chkUser.asp"-->

<%
bu = request("bu")
product = request("product")

sql = "insert into product_maintain (bu, product, state, crtuser, crttime) values ('" & bu & "', '" & product & "', '0', '" & session("userid") & "', '" & getdate() & "')"
conn.execute(sql)

%>

<script language="javascript">
  alert ("Operation success!");
  location.assign("product_search.asp");
</script>