<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!--#include file="../include/constant.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/commons.asp"-->

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title>IS E-pricing system</title>
<link href="../css/css.css" rel="stylesheet" type="text/css">
<SCRIPT language=javascript src="../js/check.js"></SCRIPT>
<script language="javascript">
function checkfield(){
	if (document.forms[0].bu.value==""){
		alert ("Please input BU!");
		return false;
	}
	if (cTrim(document.forms[0].product.value, 0)==""){
		alert ("Please input product!");
		return false;
	}
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
            <td class="titleorange"><div align="center">Add a New Product</div></td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td valign="top">
			<form action="product_add_submit.asp" onsubmit="return checkfield();">
<table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td width="25%" height="25"> 
                    <div align="left">BU<br>
                    </div></td>
                  <td width="25%"> <div align="left"> 
                      <input type="text" name="bu">
                    </div></td>
                  <td width="25%"> <div align="left">Product</div></td>
                  <td width="25%"> <div align="left"> 
                      <input type="text" name="product">
                    </div></td>
                </tr>
                <tr> 
                  <td colspan="4">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="4"><div align="right"> 
                      <input type="submit" name="Submit" value="Save">
                      <input type="button" name="Submit2" value="Return" onclick="javascript:history.go(-1);">
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
