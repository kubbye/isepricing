<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/commons.asp"-->
<!--#include file="../include/chkUser.asp"-->

<%
vyear = request("vyear")
vquarter = request("vquarter")
bu = request("bu")
region = request("region")
zone = request("zone")
product = request("product")

sql = "select * from dashboard where vyear='" & vyear & "' and vquarter<='" & vquarter & "'"

If bu <> "" Then
	sql = sql & " and bl='" & bu & "'"
End If 
If product <> "" Then
	sql = sql & " and productname='" & product & "'"
End If 
If region <> "" Then
	sql = sql & " and oacm in (select zonename from zone where region='" & region & "')"
End If 
If zone <> "" Then
	sql = sql & " and oacm='" & zone & "'"
End If 

If Not IsNull(session("userzone")) And session("userzone") <> "" Then
	userzone = "'" & session("userzone") & "'"
	userzone = Replace(userzone, ",", "','")
	sql = sql & " and oacm in (" & userzone & ")" 
End If

If Not IsNull(session("user_bu")) And session("user_bu") <> "" Then
	sql = sql & " and bl='" & BU_TYPE(session("user_bu"), 1) & "'"
End If 

sql = sql & " order by productname, oacm"

'response.write sql
'response.End 
Set rs = conn.execute(sql)

%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title>IS E-pricing system</title>
<link href="../css/css.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="../js/jquery-1.2.6.js"></script>
<script language="javascript">
</script>
</head>

<body bgcolor="#ffffff" leftmargin="0" topmargin="0">
<form name="form1" action="" method="post">
  <input type="hidden" name="vyear" value="<%=vyear%>">
  <input type="hidden" name="vquarter" value="<%=vquarter%>">
  <input type="hidden" name="bu" value="">
  <input type="hidden" name="region" value="">
  <input type="hidden" name="zone" value="">
</form>
<div align="center">
  <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td><table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td class="titleorange"><div align="center"><%=vyear%> <%=vquarter%> IS Target Price Deviation Dashboard</div></td>
          </tr>
          <tr> 
            <td class="titleorange">&nbsp;</td>
          </tr>
          <tr> 
            <td>
			  <table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
				  <td>Quotation No.</td>
				  <td>SAP WBS</td>
				  <td>Sold to Party</td>
				  <td>Product Name</td>
				  <td>QTY</td>
				  <td>Business Model</td>
				  <td>Region</td>
				  <td>OACM</td>
				  <td>Product Manager</td>
				  <td>OIT</td>
				  <td>BL</td>
				  <td>Target Price</td>
				  <td>Net OIT Price</td>
				  <td>OIT Price</td>
				  <td>Ext. War.</td>
				  <td>3rd part cost</td>
				  <td>Site prep.</td>
				  <td>Other cost</td>
				  <td>Comm.</td>
                </tr>
				<%
				While Not rs.eof
				%>
				<tr class="line02">
				  <td><%=rs("quotationno")%>&nbsp;</td>
				  <td width="10%" style="word-break:break-all"><%=rs("sapwbs")%>&nbsp;</td>
				  <td width="15%"><%=rs("soldtoparty")%>&nbsp;</td>
				  <td><%=rs("productname")%>&nbsp;</td>
				  <td><%=rs("qty")%>&nbsp;</td>
				  <td><%=rs("businessmodel")%>&nbsp;</td>
				  <td><%=rs("region")%>&nbsp;</td>
				  <td><%=rs("oacm")%>&nbsp;</td>
				  <td><%=rs("productmanager")%>&nbsp;</td>
				  <td><%=rs("oit")%>&nbsp;</td>
				  <td><%=rs("bl")%>&nbsp;</td>
				  <td><%=CInt(rs("targetprice"))%></td>
				  <td><%=CInt(rs("netoit"))%></td>
				  <td><%=CInt(rs("oitprice"))%></td>
				  <td><%=CInt(rs("extendedwarrenty"))%></td>
				  <td><%=CInt(rs("thirdpartycost"))%></td>
				  <td><%=CInt(rs("sitepreparation"))%></td>
				  <td><%=CInt(rs("othercost"))%></td>
				  <td><%=CInt(rs("commission"))%></td>
				</tr>
				<%
					rs.movenext
				Wend 
				%>
              </table></td>
          </tr>
        </table>
	  </td>
	  <tr>
	    <td>
		  <table  width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
		    <tr class="linefont">
			  <td align="right">
			    Business Model:
			  </td>
			  <td align="left">
			    DD=Direct Deal
			  </td>
			</tr>
		    <tr class="linefont">
			  <td>
			    &nbsp;
			  </td>
			  <td align="left">
			    BR=Bidding Reseller
			  </td>
			</tr>
		  </table>
		<td>
	  </tr>
	  <tr>
	    <td align="right">
		  <input type="button" name="rtn" value="Return" onclick="javascript:history.go(-1)">&nbsp;&nbsp;&nbsp;&nbsp;
		</td>
	  </tr>
    </tr>
  </table>
  <!--#include file="../footer.asp"-->
</div>
</body>
</html>
