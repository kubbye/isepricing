<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/commons.asp"-->

<%
pid = request("pid")
sql = "select * from party where pid=" & pid
Set rs = conn.execute(sql)
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title>IS E-pricing system</title>
<link href="../css/css.css" rel="stylesheet" type="text/css">
<SCRIPT language=javascript src="../js/check.js"></SCRIPT>
<script language="javascript">
function checkfield(){
	if (document.forms[0].itemcode.value==""){
		alert ("Please input Product code!");
		return false;
	}
	if (document.forms[0].itemname.value==""){
		alert ("Please input Product name!");
		return false;
	}
	if (document.forms[0].dealer.value==""){
		alert ("Please input Vendor!");
		return false;
	}
	if (document.forms[0].unitcost.value==""){
		alert ("Please input Cost(USD)!");
		return false;
	}
	if (document.forms[0].unitcostrmb.value==""){
		alert ("Please input Cost(RMB)!");
		return false;
	}
	if (document.forms[0].model.value==""){
		alert ("Please input Applicable Modality!");
		return false;
	}
	if (document.forms[0].diliverydate.value==""){
		alert ("Please input Lead Time!");
		return false;
	}
	if (document.forms[0].madein.value==""){
		alert ("Please input Original Country!");
		return false;
	}
	if (document.forms[0].warranty.value==""){
		alert ("Please input Warranty Period!");
		return false;
	}
	if (!isPlusNumeric(document.forms[0].unitcost.value)){
		alert ("Cost(USD) must be number!");
		return false;
	}
	if (!isPlusNumeric(document.forms[0].unitcostrmb.value)){
		alert ("Cost(RMB) must be number!");
		return false;
	}
	document.forms[0].submit();
}
</script>

</head>

<body bgcolor="#CCCCCC" leftmargin="0" topmargin="0">
<div align="center">
  <table width="1000" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td>
	    <table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td class="titleorange"><div align="center">Edit a New 3rd Party</div></td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td valign="top">
			<form action="party_edit_submit.asp">
<table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td width="25%" height="25"> 
                    <div align="left">Product code<br>
                    </div></td>
                  <td width="25%"> <div align="left"> 
				      <input type="hidden" name="pid" value="<%=pid%>">
                      <input type="text" name="itemcode" value="<%=rs("itemcode")%>" readonly>
                    </div></td>
                  <td width="25%"> <div align="left">Product name</div></td>
                  <td width="25%"> <div align="left"> 
                      <input type="text" name="itemname" value="<%=rs("itemname")%>">
                    </div></td>
                </tr>
                <tr class="line01">
                  <td height="25">
					<div align="left">Vendor</div></td>
                  <td><div align="left">
                      <input type="text" name="dealer" value="<%=rs("dealer")%>">
                    </div></td>
                  <td><div align="left">Cost(USD)</div></td>
                  <td><div align="left">
                      <input type="text" name="unitcost" value="<%=Round(rs("unitcost"))%>">
                    </div></td>
                </tr>
                <tr class="line01">
                  <td height="25">
					<div align="left">Cost(RMB)</div></td>
                  <td><div align="left">
                      <input type="text" name="unitcostrmb" value="<%=Round(rs("unitcostrmb"))%>">
                    </div></td>
                  <td><div align="left">Applicable Modality</div></td>
                  <td><div align="left"><input type="text" name="model" value="<%=rs("model")%>"></div></td>
                </tr>
                <tr class="line01">
                  <td height="25">
					<div align="left">Lead Time</div></td>
                  <td><div align="left">
                      <input type="text" name="diliverydate" value="<%=rs("diliverydate")%>">
                    </div></td>
                  <td><div align="left">Original Country</div></td>
                  <td><div align="left"><input type="text" name="madein" value="<%=rs("madein")%>"></div></td>
                </tr>
                <tr class="line01">
                  <td height="25">
					<div align="left">Warranty Period</div></td>
                  <td><div align="left">
                      <input type="text" name="warranty" value="<%=rs("warranty")%>">
                    </div></td>
                  <td><div align="left">&nbsp;</div></td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="4">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="4"><div align="right"> 
                      <input type="button" name="btnsave" value="Save" onclick="checkfield();">
                      <input type="button" name="btnreturn" value="Return" onclick="history.go(-1);">
                    </div></td>
                </tr>
              </table>
			  </form>
			</td>
          </tr>
        </table></td>
    </tr>
  </table>
  <!--#include file="../footer.asp"-->
</div>
</body>
</html>
