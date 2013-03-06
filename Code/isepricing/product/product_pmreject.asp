<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/commons.asp"-->
<!--#include file="../include/chkUser.asp"-->

<%
bu = request("bu")

sql = "select distinct b.userid, b.username from product a, userinfo b where a.crtuser=b.userid and a.state='0' and a.status='3' and b.bu=" & bu
Set rs = conn.execute(sql)

%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title>IS E-pricing system</title>
<link href="../css/css.css" rel="stylesheet" type="text/css">
</head>

<body bgcolor="#CCCCCC" leftmargin="0" topmargin="0">
<div align="center">
  <table width="1000" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td><table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td class="titleorange"><div align="center">Reject to Specialist</div></td>
          </tr>
          <tr> 
            <td class="titleorange">&nbsp;</td>
          </tr>
          <tr> 
            <td><table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td>User ID</td>
                  <td>User Name</td>
                  <td>Operation</td>
                </tr>
				<%
				While Not rs.eof
				%>
					<tr class="line02">
					  <td><%=rs("userid")%></td>
					  <td><%=rs("username")%></td>
					  <td>
					    <a href="product_pmreject_submit.asp?userid=<%=rs("userid")%>&bu=<%=bu%>">Reject</a>
					  </td>
					</tr>
				<%
					rs.movenext
				Wend 
				%>
              </table></td>
          </tr>
        </table></td>
    </tr>
  </table>
  <!--#include file="../footer.asp"-->
</div>
</body>
</html>
