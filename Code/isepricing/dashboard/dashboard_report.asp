<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/commons.asp"-->
<!--#include file="../include/chkUser.asp"-->

<%
sql = "select max(vyear) vyear from dashboard"
Set rs = conn.execute(sql)

vyear = rs("vyear")

sql = "select max(vquarter) vquarter from dashboard where vyear='" & vyear & "'"
Set rs = conn.execute(sql)

vquarter = rs("vquarter")

sql = "select distinct vyear from dashboard"
Set rs = conn.execute(sql)

%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title>IS E-pricing system</title>
<link href="../css/css.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="../js/jquery-1.2.6.js"></script>
<script language="javascript">
function checkfield(){
	if (document.form1.vyear.value == ""){
		alert ("Please choose Year!");
		return false;
	}
	if (document.form1.vquarter.value == ""){
		alert ("Please choose Quarter!");
		return false;
	}
	<%
	If session("roleid") = 7 Then 
	%>
	document.form1.action = "dashboard_report7.asp";
	<%
	Else
	%>
	document.form1.action = "dashboard_report1.asp";
	<%
	End If 
	%>
	document.form1.submit();
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
            <td class="titleorange"><div align="center">Dashboard</div></td>
          </tr>
          <tr> 
            <td class="titleorange">&nbsp;</td>
          </tr>
          <tr> 
            <td valign="top" class="line01">
			  <form name="form1" method="post" action="">
			  <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
                <tr> 
                  <td>
				    <table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                      <tr class="line01"> 
				  <td> <div align="left">Year:</div></td>
				  <td>
				    <div align="left">
					  <select name="vyear">
					    <%
						While Not rs.eof 
						%>
							<option value="<%=rs("vyear")%>" <%If vyear = rs("vyear") Then %>selected<% End If %>><%=rs("vyear")%></option>
						<%
							rs.movenext
						Wend 
						%>
					  </select>
				    </div>
				  </td>
				  <td> <div align="left">Quarter:</div></td>
				  <td>
				    <div align="left">
					  <select name="vquarter">
					    <option value="Q1" <%If vquarter = "Q1" Then %>selected<% End If %>>Q1</option>
					    <option value="Q2" <%If vquarter = "Q2" Then %>selected<% End If %>>Q2</option>
					    <option value="Q3" <%If vquarter = "Q3" Then %>selected<% End If %>>Q3</option>
					    <option value="Q4" <%If vquarter = "Q4" Then %>selected<% End If %>>Q4</option>
					  </select>
				    </div>
				  </td>
				  <td>
				    <input type="button" name="Submit2" value=" Search " onclick="checkfield();" />&nbsp;&nbsp;
				  </td>
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
