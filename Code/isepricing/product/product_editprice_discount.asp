<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/commons.asp"-->
<!--#include file="../include/chkUser.asp"-->
<%
pid = request("pid")

sql = "select distinct items from product_detail_philips where type in ('1', '2') and pid=" & pid
Set rs = conn.execute(sql)

%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title>IS E-pricing system</title>
<link href="../css/css.css" rel="stylesheet" type="text/css">
<script src="../js/ut.js"></script>
<SCRIPT language=javascript src="../js/check.js"></SCRIPT>
<script language="javascript">

function addrow(){
	if (document.form1.items.value == ""){
		alert ("Please choose Content!");
		return false;
	}
	if (document.form1("options").value == ""){
		alert ("Please choose Article No.!");
		return false;
	}
	var tbl =window.opener.document.getElementById("dynamictable");
	var count = window.opener.document.getElementById("dynamiccount").value;
	newRow = tbl.insertRow(tbl.rows.length);
	newRow.id = "onerecord";
	newRow.className = "line02";

	c1 =  newRow.insertCell(0);
	c1.innerHTML = "<input type='checkbox' name='dynamic_medication' onclick='selectBox(this);'>";

	c2 =  newRow.insertCell(1);
	c2.innerHTML = document.form1.items.value + "<input type='hidden' name='dynamic_items" + count + "' value='" + document.form1.items.value + "'>";

	c3 =  newRow.insertCell(2);
	c3.innerHTML = document.all("options").value + "<input type='hidden' name='dynamic_options" + count + "' value='" + document.all("options").value + "'>";

	c4 = newRow.insertCell(3);
	c4.innerHTML = document.form1.discount.value + "<input type='hidden' name='dynamic_discount" + count + "' value='" + document.form1.discount.value + "'>";

	window.opener.document.getElementById("dynamiccount").value = parseInt(window.opener.document.getElementById("dynamiccount").value) + 1;

	window.close();
}

function validPlusNumeric(obj){
	if (!isPlusNumeric(obj.value)){
		alert ("Please input number!");
		obj.value = "";
		obj.focus();
		return false;
	}
}

function chooseoption(objname){
	openDialog("choose_configuration_dynamic.asp?objname=" + objname,'750','500'); 
}
</script>
</head>

<body bgcolor="#ffffff" leftmargin="0" topmargin="0">
<div align="center">
<form name="form1" action="product_editprice_discount_submit.asp" method="post">
  <input type="hidden" name="count" value="<%=count%>">
  <input type="hidden" name="pid" value="<%=pid%>">
  <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td><table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td class="titleorange"><div align="center">Dynamic Discount Rate</div></td>
          </tr>
          <tr> 
            <td class="titleorange">&nbsp;</td>
          </tr>
          <tr> 
            <td><table id="datatable" width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td>Content</td>
                  <td>Article No.</td>
                  <td width="15%">Discount Rate(请填0~1的数字)</td>
                </tr>
				<tr class="line02"> 
				  <td>
				    <select name="items">
					<%
					While Not rs.eof
					%>
					  <option value="<%=rs("items")%>"><%=rs("items")%></option>
					<%
						rs.movenext
					Wend 
					%>
					</select>
				  </td>
				  <td><input type="text" name="options" readonly onclick="chooseoption(this.name)"></td>
				  <td><input type="text" size="6" name="discount" value="1" onblur="validPlusNumeric(this)"></td>
				</tr>
				<tr>
				  <td colspan="4">
				    <div align="right"> 
                      <input type="button" name="Submit22" value=" Add " onclick="addrow()">
                      &nbsp;&nbsp; 
                      <input type="button" name="Submit22" value="Close" onclick="window.close();">
                      &nbsp;&nbsp; &nbsp;&nbsp; </div>
				  </td>
				</tr>
              </table></td>
          </tr>
        </table>
	  </td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
  </table>
</form>
<!--#include file="../include/commons.asp"-->
</div>
</body>
</html>
