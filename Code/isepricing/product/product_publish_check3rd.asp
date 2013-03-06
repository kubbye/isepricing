<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../include/commons.asp"-->
<!--#include file="../include/chkUser.asp"-->

<%

sql = "select * from product a, modality b where a.mid=b.mid and b.status='0' and a.state='0' and a.version='" & getversion(1) & "'"
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
            <td class="titleorange"><div align="center">Check Result</div></td>
          </tr>
          <tr> 
            <td class="titleorange">&nbsp;</td>
          </tr>
          <tr> 
            <td><table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td>BU</td>
                  <td>Modality</td>
                  <td>Product</td>
                </tr>
				<%
				While Not rs.eof
					disp = 0
					sql = "select * from product_detail_3rd where pid=" & rs("pid")
					Set rs3rd = conn.execute(sql)
					If Not rs3rd.eof Then 
						If Not IsNull(rs3rd("materialno")) And rs3rd("materialno") <> "" Then 
							sql = "select * from party where state='0' and status='0' and itemcode='" & rs3rd("materialno") & "'"
							Set rsparty = conn.execute(sql)
							If rsparty.eof Then
								disp = 1
							ElseIf Round(rsparty("unitcost")) <> Round(rs3rd("unitcost")) Or Round(rsparty("unitcostrmb")) <> Round(rs3rd("unitcostrmb")) Then
								disp = 1
							End If 
							If disp = 1 Then 
				%>
								<tr class="line02">
								  <td><%=BU_TYPE(rs("bu"), 1)%><%=rs("pid")%></td>
								  <td><%=rs("modality")%></td>
								  <td><%=rs("productname")%></td>
								</tr>
				<%
							End If 
						End If 
					End If 
					rs.movenext
				Wend 
				%>
              </table></td>
          </tr>
          <tr> 
            <td class="line02">&nbsp; </td>
          </tr>
          <tr> 
            <td><input type="button" name="btn1" value="Return" onclick="javascript:history.go(-1);"> </td>
          </tr>
        </table></td>
    </tr>
  </table>
  <!--#include file="../footer.asp"-->
</div>
</body>
</html>
