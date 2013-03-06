<!--#include file="../include/conn.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/chkUser.asp"-->

<%
mmid = request("mid")
bu = request("bu")
modality = request("modality")
inst = request("inst")
warr = request("warr")
apptraining = request("apptraining")
apptrainingrmb = request("apptrainingrmb")

sql = "update modality set bu=" & bu & ", modality='" & modality & "', inst=" & inst & ", warr=" & warr & ", apptraining=" & apptraining & ", apptrainingrmb=" & apptrainingrmb & ", updtuser='" & session("userid") & "', updttime='" & getdate() & "' where mid=" & mmid
conn.execute(sql)

%>

<script language="javascript">
  alert ("Operation success!");
  location.assign("modality_search.asp");
</script>