<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../include/commons.asp"-->
<!--#include file="../include/chkUser.asp"-->
<%
cid = request("cid")

sql = "select * from configurations where cid=" & cid
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
	if (document.forms[0].materialno.value==""){
		alert ("Please input Article No.!");
		return false;
	}
	if (cTrim(document.forms[0].description.value, 0)==""){
		alert ("Please input Article Description!");
		return false;
	}
	if (document.forms[0].listprice.value==""){
		alert ("Please input List price!");
		return false;
	}
	if (document.forms[0].wrp.value==""){
		alert ("Please input CTP!");
		return false;
	}
	if (!isPlusNumeric(document.forms[0].listprice.value)){
		alert ("List price must be number!");
		return false;
	}
	if (!isPlusNumeric(document.forms[0].wrp.value)){
		alert ("CTP must be number!");
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
      <td><table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td class="titleorange"><div align="center">Configuration Edit</div></td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td>
			  <form name="form1" method="post" action="configuration_edit_submit.asp" onsubmit="return checkfield();">
			  <table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td width="25%"> <div align="left">Article No.: <br>
                    </div></td>
                  <td width="25%"> <div align="left"> 
				      <input type="hidden" name="cid" value="<%=rs("cid")%>">
                      <input type="text" name="materialno" value="<%=rs("materialno")%>">
                    </div></td>
                  <td width="25%"> <div align="left">Article Description: </div></td>
                  <td width="25%"> <div align="left"> 
                      <input type="text" name="description" value="<%=rs("description")%>">
                    </div></td>
                </tr>
                <tr class="line01"> 
                  <td> <div align="left">List Price: </div></td>
                  <td> <div align="left"> 
                      <input type="text" name="listprice" value="<%=Round(rs("listprice"))%>">
                    </div></td>
                  <td> <div align="left">CTP: </div></td>
                  <td> <div align="left"> 
                      <input type="text" name="wrp" value="<%=Round(rs("wrp"))%>">
                    </div></td>
                </tr>
                <tr class="line01"> 
                  <td> <div align="left">Status: </div></td>
                  <td> <div align="left"> 
                      <select name="state">
					    <%
						For i = 0 To UBound(CONFIGURATION_STATE_DISPLAY)
						%>
							<option VALUE="<%=i%>" <%If Int(rs("state"))=i Then %>selected<% End If %>><%=CONFIGURATION_STATE_DISPLAY(i)%></option>
						<%
						Next 
						%>
                      </select>
                    </div></td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
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
<!--#include file="../include/commons.asp"-->
</div>
</body>
</html>
