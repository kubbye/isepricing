<!--#include file="../include/conn.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/chkUser.asp"-->

<%
bu = request("bu")
modality = request("modality")
inst = request("inst")
warr = request("warr")
apptraining = request("apptraining")
apptrainingrmb = request("apptrainingrmb")

sql = "insert into modality (bu, modality, inst, warr, apptraining, apptrainingrmb, status, crtuser, crttime) values (" & bu & ", '" & modality & "', " & inst & ", " & warr & ", " & apptraining & ", " & apptrainingrmb & ", '0', '" & session("userid") & "', '" & getdate() & "')"
conn.execute(sql)

%>

<script language="javascript">
  alert ("Operation success!");
  location.assign("modality_search.asp");
</script>