<!--#include file="../include/conn.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/chkUser.asp"-->

<%
materialno = request("materialno")
description = request("description")
listprice = request("listprice")
wrp = request("wrp")
state = request("state")

sql = "insert into configurations (materialno, description, listprice, wrp, type, state, status, version, crtuser, crttime) values ('" & materialno & "', '" & description & "', " & listprice & ", " & wrp & ", '1', '" & state & "', '1', '" & getversion(1) & "', '" & session("userid") & "', '" & getdate() & "')"

conn.execute(sql)

%>

<script language="javascript">
  alert ("Operation success!");
  location.assign("configuration_search.asp");
</script>