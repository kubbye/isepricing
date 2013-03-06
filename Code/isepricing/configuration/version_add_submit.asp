<!--#include file="../include/conn.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/chkUser.asp"-->

<%
version = request("version")

sql = "insert into versionset (version, status, crtuser, crttime) values ('" & version & "', '1', '" & session("userid") & "', '" & getdate() & "')"

conn.execute(sql)

%>

<script language="javascript">
  alert ("Operation success!");
  location.assign("version_search.asp");
</script>