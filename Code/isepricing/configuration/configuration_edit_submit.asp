<!--#include file="../include/conn.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/chkUser.asp"-->

<%
cid = request("cid")
materialno = request("materialno")
description = request("description")
listprice = request("listprice")
wrp = request("wrp")
state = request("state")

sql = "update configurations set materialno='" & materialno & "', description='" & description & "', listprice=" & listprice & ", wrp=" & wrp & ", state='" & state & "', updtuser='" & session("userid") & "', updttime='" & getdate() & "' where cid=" & cid

conn.execute(sql)

%>

<script language="javascript">
  alert ("Operation success!");
  location.assign("configuration_search.asp");
</script>