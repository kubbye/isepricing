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
		alert ("Please select BU!");
		return false;
	}
	if (cTrim(document.forms[0].modality.value, 0)==""){
		alert ("Please input modality!");
		return false;
	}
	if (document.forms[0].inst.value==""){
		alert ("Please input Inst.%!");
		return false;
	}
	if (document.forms[0].warr.value==""){
		alert ("Please input Warr.%!");
		return false;
	}
	if (document.forms[0].apptraining.value==""){
		alert ("Please input App Training(USD)!");
		return false;
	}
	if (document.forms[0].apptrainingrmb.value==""){
		alert ("Please input App Training(RMB)!");
		return false;
	}
	if (!isPlusNumeric(document.forms[0].inst.value)){
		alert ("Inst.% must be number!");
		return false;
	}
	if (!isPlusNumeric(document.forms[0].warr.value)){
		alert ("Warr.% must be number!");
		return false;
	}
	if (!isPlusNumeric(document.forms[0].apptraining.value)){
		alert ("App Training(USD) must be number!");
		return false;
	}
	if (!isPlusNumeric(document.forms[0].apptrainingrmb.value)){
		alert ("App Training(RMB) must be number!");
		return false;
	}
}
</script>

</head>

<body bgcolor="#ffffff" leftmargin="0" topmargin="0">
<div align="center">
  <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td>
	    <table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td class="titleorange"><div align="center">Add a New Modality</div></td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td valign="top">
			<form action="modality_add_submit.asp" onsubmit="return checkfield();">
<table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td width="25%" height="25"> 
                    <div align="left">BU<br>
                    </div></td>
                  <td width="25%"> <div align="left"> 
                      <select name="bu">
                         <%
						  For i = 0 To UBound(BU_TYPE)
						  %>
						  <option VALUE="<%=BU_TYPE(i,0)%>"><%=BU_TYPE(i,1)%></option>
						  <%
						  Next 
						  %>
						</select>
                      </select>
                    </div></td>
                  <td width="25%"> <div align="left">Modality</div></td>
                  <td width="25%"> <div align="left"> 
                      <input type="text" name="modality">
                    </div></td>
                </tr>
                <tr class="line01">
                  <td height="25">
<div align="left">Inst. % </div></td>
                  <td><div align="left">
                      <input type="text" name="inst">
                    </div></td>
                  <td><div align="left">Warr. %</div></td>
                  <td><div align="left">
                      <input type="text" name="warr">
                    </div></td>
                </tr>
                <tr class="line01">
                  <td height="25">
<div align="left">Standard App Training(USD)</div></td>
                  <td><div align="left">
                      <input type="text" name="apptraining">
                    </div></td>
                  <td><div align="left">Standard App Training(RMB)</div></td>
                  <td><div align="left">
                      <input type="text" name="apptrainingrmb">
                    </div></td>
                </tr>
                <tr> 
                  <td colspan="4">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="4"><div align="right"> 
                      <input type="submit" name="Submit" value="Save">
                      <input type="Reset" name="Submit2" value="Reset">
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
