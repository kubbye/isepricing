<!--#include file="../include/conn.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/chkUser.asp"-->

<%
pmid = request("pmid")

sql = "update product_maintain set state='1', updtuser='" & session("userid") & "', updttime='" & getdate() & "' where pmid=" & pmid
conn.execute(sql)

%>

<script language="javascript">
  alert ("Operation success!");
  location.assign("product_search.asp");
</script>