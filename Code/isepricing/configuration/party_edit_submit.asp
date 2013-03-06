<!--#include file="../include/conn.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../quotation/waitforcheck.asp"-->
<!--#include file="../include/sendMail.asp"-->
<!--#include file="../include/constant.asp"-->

<%
pid = request("pid")
itemcode = request("itemcode")
itemname = request("itemname")
dealer = request("dealer")
unitcost = request("unitcost")
unitcostrmb = request("unitcostrmb")
model = request("model")
diliverydate = request("diliverydate")
madein = request("madein")
warranty = request("warranty")

sql = "update party set itemcode='" & itemcode & "', itemname='" & itemname & "', unitcost=" & unitcost & ", unitcostrmb=" & unitcostrmb & ", dealer='" & dealer & "', model='" & model & "', diliverydate='" & diliverydate & "', warranty='" & warranty & "', madein='" & madein & "', updtuser='" & session("userid") & "', updttime='" & getdate() & "', starttime='" & getdate() & "' where pid=" & pid

conn.execute(sql)

makeWaitForCheck3rdConfig(itemname)

%>

<script language="javascript">
  alert ("Operation success!");
  location.assign("party_search.asp");
</script>