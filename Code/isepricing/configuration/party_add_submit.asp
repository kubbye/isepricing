<!--#include file="../include/conn.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/chkUser.asp"-->

<%
itemcode = request("itemcode")
itemname = request("itemname")
dealer = request("dealer")
unitcost = request("unitcost")
unitcostrmb = request("unitcostrmb")
model = request("model")
diliverydate = request("diliverydate")
madein = request("madein")
warranty = request("warranty")

sql = "insert into party (itemcode, itemname, unitcost, unitcostrmb, dealer, model, diliverydate, warranty, madein, type, state, status, starttime, crtuser, crttime) values ('" & itemcode & "', '" & itemname & "', " & unitcost & ", " & unitcostrmb & ", '" & dealer & "', '" & model & "', '" & diliverydate & "', '" & warranty & "', '" & madein & "', '1', '0', '0', '" & getdate() & "', '" & session("userid") & "', '" & getdate() & "')"

conn.execute(sql)

%>

<script language="javascript">
  alert ("Operation success!");
  location.assign("party_search.asp");
</script>