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

sql = "select bl product from dashboard where vyear='" & vyear & "'"

If Not IsNull(session("user_bu")) And session("user_bu") <> "" Then
	sql = sql & " and bl='" & BU_TYPE(session("user_bu"), 1) & "'"
End If 

If Not IsNull(session("userzone")) And session("userzone") <> "" Then
	userzone = "'" & session("userzone") & "'"
	userzone = Replace(userzone, ",", "','")
	sql = sql & " and oacm in (" & userzone & ")" 
End If

If bu <> "" Then
	sql = sql & " and bl='" & bu & "'"
End If 

sql = sql & " group by bl"
sql = sql & " order by bl"

Set rs = conn.execute(sql)

%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title>IS E-pricing system</title>
<link href="../css/css.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="../js/jquery-1.2.6.js"></script>
<script language="javascript">
function intobuzone(bu, zone){
	document.form1.bu.value = bu;
	document.form1.zone.value = zone;
	document.form1.region.value = "";
	document.form1.action = "dashboard_report4.asp";
	document.form1.submit();
}

function intoburegion(bu, region){
	document.form1.bu.value = bu;
	document.form1.zone.value = "";
	document.form1.region.value = region;
	document.form1.action = "dashboard_report3.asp";
	document.form1.submit();
}

function intobu(bu){
	document.form1.bu.value = bu;
	document.form1.zone.value = "";
	document.form1.region.value = "";
	document.form1.action = "dashboard_report3.asp";
	document.form1.submit();
}

function intozonebu(zone, bu){
	document.form1.bu.value = bu;
	document.form1.zone.value = zone;
	document.form1.region.value = "";
	document.form1.action = "dashboard_report6.asp";
	document.form1.submit();
}

function intozone(zone){
	document.form1.bu.value = "";
	document.form1.zone.value = zone;
	document.form1.region.value = "";
	document.form1.action = "dashboard_report6.asp";
	document.form1.submit();
}
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
            <td class="titleorange" align="right">Currency: KUSD</td>
          </tr>
          <tr> 
            <td><table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td rowspan="2">Product</td>
                  <td rowspan="2">Region</td>
				  <%
				  If vquarter = "Q4" Then
				  %>
                  <td colspan="4"><%=vyear%> Q4</td>
				  <%
				  End If 
				  If vquarter >= "Q3" Then 
				  %>
                  <td colspan="4"><%=vyear%> Q3</td>
				  <%
				  End If 
				  If vquarter >= "Q2" Then 
				  %>
                  <td colspan="4"><%=vyear%> Q2</td>
				  <%
				  End If 
				  %>
                  <td colspan="4"><%=vyear%> Q1</td>
                  <td colspan="4">YTD</td>
                </tr>
				<tr class="line01"> 
				  <%
				  If vquarter = "Q4" Then
				  %>
                  <td>Target<br>Price</td>
                  <td>OIT<br>Net</td>
                  <td>Deviation</td>
                  <td>Qty</td>
				  <%
				  End If 
				  If vquarter >= "Q3" Then 
				  %>
                  <td>Target<br>Price</td>
                  <td>OIT<br>Net</td>
                  <td>Deviation</td>
                  <td>Qty</td>
				  <%
				  End If 
				  If vquarter >= "Q2" Then 
				  %>
                  <td>Target<br>Price</td>
                  <td>OIT<br>Net</td>
                  <td>Deviation</td>
                  <td>Qty</td>
				  <%
				  End If 
				  %>
                  <td>Target<br>Price</td>
                  <td>OIT<br>Net</td>
                  <td>Deviation</td>
                  <td>Qty</td>
                  <td>Target<br>Price</td>
                  <td>OIT<br>Net</td>
                  <td>Deviation</td>
                  <td>Qty</td>
                </tr>
				<%
				While Not rs.eof
					blsumtarget1 = 0
					blsumoit1 = 0
					blsumdev1 = 0
					blsumqty1 = 0
					blsumtarget2 = 0
					blsumoit2 = 0
					blsumdev2 = 0
					blsumqty2 = 0
					blsumtarget3 = 0
					blsumoit3 = 0
					blsumdev3 = 0
					blsumqty3 = 0	
					blsumtarget4 = 0
					blsumoit4 = 0
					blsumdev4 = 0
					blsumqty4 = 0
					blsumtarget = 0
					blsumoit = 0
					blsumdev = 0
					blsumqty = 0
					sqlregion = "select distinct region from zone where 1=1"
					If Not IsNull(session("userzone")) And session("userzone") <> "" Then
						userzone = "'" & session("userzone") & "'"
						userzone = Replace(userzone, ",", "','")
						sqlregion = sqlregion & " and zonename in (" & userzone & ")" 
					End If
					If region <> "" Then
						sqlregion = sqlregion & " and region='" & region & "'"
					End If 
					Set rsregion = conn.execute(sqlregion)

					While Not rsregion.eof
						sqlzone = "select distinct zonename from zone where region='" & rsregion("region") & "'"
						If Not IsNull(session("userzone")) And session("userzone") <> "" Then
							userzone = "'" & session("userzone") & "'"
							userzone = Replace(userzone, ",", "','")
							sqlzone = sqlzone & " and zonename in (" & userzone & ")" 
						End If
						Set rszone = conn.execute(sqlzone)

						While Not rszone.eof
				%>
							<tr class="line02">
							  <%
							  sql = "select vquarter, sum(targetprice) target, sum(netoit) oit, sum(qty) qty from dashboard where bl='" & rs("product") & "' and oacm='" & rszone("zonename") & "' and vyear='" & vyear & "'"
							  sql = sql & " group by vquarter"
							  'response.write sql
							  'response.end
							  Set rs2 = conn.execute(sql)
							  target1 = 0
							  oit1 = 0
							  dev1 = 0
							  qty1 = 0
							  target2 = 0
							  oit2 = 0
							  dev2 = 0
							  qty2 = 0
							  target3 = 0
							  oit3 = 0
							  dev3 = 0
							  qty3 = 0
							  target4 = 0
							  oit4 = 0
							  dev4 = 0
							  qty4 = 0
							  target = 0
							  oit = 0
							  dev = 0
							  qty = 0
							  While Not rs2.eof
								If rs2("vquarter")="Q1" Then
									target1 = rs2("target")
									oit1 = rs2("oit")
									If target1 <> 0 Then
										dev1 = (oit1 - target1) / target1 * 100
									End If 
									qty1 = rs2("qty")
									target = target + rs2("target")
									oit = oit + rs2("oit")
									If target <> 0 Then
										dev = (oit - target) / target * 100
									End If 
									qty = qty + rs2("qty")
								End If 
								If rs2("vquarter")="Q2" And vquarter >= "Q2" Then
									target2 = rs2("target")
									oit2 = rs2("oit")
									If target2 <> 0 Then
										dev2 = (oit2 - target2) / target2 * 100
									End If 
									qty2 = rs2("qty")
									target = target + rs2("target")
									oit = oit + rs2("oit")
									If target <> 0 Then
										dev = (oit - target) / target * 100
									End If 
									qty = qty + rs2("qty")
								End If 
								If rs2("vquarter")="Q3" And vquarter >= "Q3" Then
									target3 = rs2("target")
									oit3 = rs2("oit")
									If target3 <> 0 Then
										dev3 = (oit3 - target3) / target3 * 100
									End If 
									qty3 = rs2("qty")
									target = target + rs2("target")
									oit = oit + rs2("oit")
									If target <> 0 Then
										dev = (oit - target) / target * 100
									End If 
									qty = qty + rs2("qty")
								End If 
								If rs2("vquarter")="Q4" And vquarter = "Q4" Then
									target4 = rs2("target")
									oit4 = rs2("oit")
									If target4 <> 0 Then
										dev4 = (oit4 - target4) / target4 * 100
									End If 
									qty4 = rs2("qty")
									target = target + rs2("target")
									oit = oit + rs2("oit")
									If target <> 0 Then
										dev = (oit - target) / target * 100
									End If 
									qty = qty + rs2("qty")
								End If 
								rs2.movenext
							  Wend 
							  %>
							  <td><a href="javascript:intobuzone('<%=rs("product")%>', '<%=rszone("zonename")%>');"><%=rs("product")%></a></td>
							  <td><a href="javascript:intozonebu('<%=rszone("zonename")%>', '<%=rs("product")%>');"><%=rszone("zonename")%></a></td>
							  <%
							  If vquarter = "Q4" Then
							  %>
							  <td><%=Round(target4)%></td>
							  <td><%=Round(oit4)%></td>
							  <td class="<%If Round(dev4) >= 0 Then %>dashboard1<% ElseIf Round(dev4) > -5 Then %>dashboard2<% ElseIf Round(dev4) > -10 Then %>dashboard3<% Else %>dashboard4<% End If %>"><%=Round(dev4)%>%</td>
							  <td><%=Round(qty4)%></td>
							  <%
							  End If 
							  If vquarter >= "Q3" Then 
							  %>
							  <td><%=Round(target3)%></td>
							  <td><%=Round(oit3)%></td>
							  <td class="<%If Round(dev3) >= 0 Then %>dashboard1<% ElseIf Round(dev3) > -5 Then %>dashboard2<% ElseIf Round(dev3) > -10 Then %>dashboard3<% Else %>dashboard4<% End If %>"><%=Round(dev3)%>%</td>
							  <td><%=Round(qty3)%></td>
							  <%
							  End If 
							  If vquarter >= "Q2" Then 
							  %>
							  <td><%=Round(target2)%></td>
							  <td><%=Round(oit2)%></td>
							  <td class="<%If Round(dev2) >= 0 Then %>dashboard1<% ElseIf Round(dev2) > -5 Then %>dashboard2<% ElseIf Round(dev2) > -10 Then %>dashboard3<% Else %>dashboard4<% End If %>"><%=Round(dev2)%>%</td>
							  <td><%=Round(qty2)%></td>
							  <%
							  End If 
							  %>
							  <td><%=Round(target1)%></td>
							  <td><%=Round(oit1)%></td>
							  <td class="<%If Round(dev1) >= 0 Then %>dashboard1<% ElseIf Round(dev1) > -5 Then %>dashboard2<% ElseIf Round(dev1) > -10 Then %>dashboard3<% Else %>dashboard4<% End If %>"><%=Round(dev1)%>%</td>
							  <td><%=Round(qty1)%></td>
							  <td><%=Round(target)%></td>
							  <td><%=Round(oit)%></td>
							  <td class="<%If Round(dev) >= 0 Then %>dashboard1<% ElseIf Round(dev) > -5 Then %>dashboard2<% ElseIf Round(dev) > -10 Then %>dashboard3<% Else %>dashboard4<% End If %>"><%=Round(dev)%>%</td>
							  <td><%=Round(qty)%></td>
							</tr>
						
				<%
							rszone.movenext
						Wend 

						'����REGION����
						sql = "select vquarter, sum(targetprice) target, sum(netoit) oit, sum(qty) qty from dashboard where bl='" & rs("product") & "' and oacm in (select zonename from zone where region='" & rsregion("region") & "') and vyear='" & vyear & "'"
						If Not IsNull(session("userzone")) And session("userzone") <> "" Then
							userzone = "'" & session("userzone") & "'"
							userzone = Replace(userzone, ",", "','")
							sql = sql & " and oacm in (" & userzone & ")" 
						End If
						sql = sql & " group by vquarter"
						Set rs4 = conn.execute(sql)
						
						regiontarget1 = 0
						regionoit1 = 0
						regiondev1 = 0
						regionqty1 = 0
						regiontarget2 = 0
						regionoit2 = 0
						regiondev2 = 0
						regionqty2 = 0
						regiontarget3 = 0
						regionoit3 = 0
						regiondev3 = 0
						regionqty3 = 0
						regiontarget4 = 0
						regionoit4 = 0
						regiondev4 = 0
						regionqty4 = 0
						regiontarget = 0
						regionoit = 0
						regiondev = 0
						regionqty = 0

						  While Not rs4.eof
							If rs4("vquarter")="Q1" Then
								regiontarget1 = rs4("target")
								regionoit1 = rs4("oit")
								If regiontarget1 <> 0 Then
									regiondev1 = (regionoit1 - regiontarget1) / regiontarget1 * 100
								End If 
								regionqty1 = rs4("qty")
								regiontarget = regiontarget + rs4("target")
								regionoit = regionoit + rs4("oit")
								If regiontarget <> 0 Then
									regiondev = (regionoit - regiontarget) / regiontarget * 100
								End If 
								regionqty = regionqty + rs4("qty")
							End If 
							If rs4("vquarter")="Q2" And vquarter >= "Q2" Then
								regiontarget2 = rs4("target")
								regionoit2 = rs4("oit")
								If regiontarget2 <> 0 Then
									regiondev2 = (regionoit2 - regiontarget2) / regiontarget2 * 100
								End If 
								regionqty2 = rs4("qty")
								regiontarget = regiontarget + rs4("target")
								regionoit = regionoit + rs4("oit")
								If regiontarget <> 0 Then
									regiondev = (regionoit - regiontarget) / regiontarget * 100
								End If 
								regionqty = regionqty + rs4("qty")
							End If 
							If rs4("vquarter")="Q3" And vquarter >= "Q3" Then
								regiontarget3 = rs4("target")
								regionoit3 = rs4("oit")
								If regiontarget3 <> 0 Then
									regiondev3 = (regionoit3 - regiontarget3) / regiontarget3 * 100
								End If 
								regionqty3 = rs4("qty")
								regiontarget = regiontarget + rs4("target")
								regionoit = regionoit + rs4("oit")
								If regiontarget <> 0 Then
									regiondev = (regionoit - regiontarget) / regiontarget * 100
								End If 
								regionqty = regionqty + rs4("qty")
							End If 
							If rs4("vquarter")="Q4" And vquarter = "Q4" Then
								regiontarget4 = rs4("target")
								regionoit4 = rs4("oit")
								If regiontarget4 <> 0 Then
									regiondev4 = (regionoit4 - regiontarget4) / regiontarget4 * 100
								End If 
								regionqty4 = rs4("qty")
								regiontarget = regiontarget + rs4("target")
								regionoit = regionoit + rs4("oit")
								If regiontarget <> 0 Then
									regiondev = (regionoit - regiontarget) / regiontarget * 100
								End If 
								regionqty = regionqty + rs4("qty")
							End If 
							rs4.movenext
						  Wend 
						 
						
						'�����AM����ʾREGION����
						If session("roleid") <> 7 Then 
						%>
						<tr class="line02">
						  <td><a href="javascript:intoburegion('<%=rs("product")%>', '<%=rsregion("region")%>');"><%=rs("product")%></a></td>
						  <td><%=rsregion("region")%></td>
						  <%
						  If vquarter = "Q4" Then
						  %>
						  <td><%=Round(regiontarget4)%></td>
						  <td><%=Round(regionoit4)%></td>
						  <td class="<%If Round(regiondev4) >= 0 Then %>dashboard1<% ElseIf Round(regiondev4) > -5 Then %>dashboard2<% ElseIf Round(regiondev4) > -10 Then %>dashboard3<% Else %>dashboard4<% End If %>"><%=Round(regiondev4)%>%</td>
						  <td><%=Round(regionqty4)%></td>
						  <%
						  End If 
						  If vquarter >= "Q3" Then 
						  %>
						  <td><%=Round(regiontarget3)%></td>
						  <td><%=Round(regionoit3)%></td>
						  <td class="<%If Round(regiondev3) >= 0 Then %>dashboard1<% ElseIf Round(regiondev3) > -5 Then %>dashboard2<% ElseIf Round(regiondev3) > -10 Then %>dashboard3<% Else %>dashboard4<% End If %>"><%=Round(regiondev3)%>%</td>
						  <td><%=Round(regionqty3)%></td>
						  <%
						  End If 
						  If vquarter >= "Q2" Then 
						  %>
						  <td><%=Round(regiontarget2)%></td>
						  <td><%=Round(regionoit2)%></td>
						  <td class="<%If Round(regiondev2) >= 0 Then %>dashboard1<% ElseIf Round(regiondev2) > -5 Then %>dashboard2<% ElseIf Round(regiondev2) > -10 Then %>dashboard3<% Else %>dashboard4<% End If %>"><%=Round(regiondev2)%>%</td>
						  <td><%=Round(regionqty2)%></td>
						  <%
						  End If 
						  %>
						  <td><%=Round(regiontarget1)%></td>
						  <td><%=Round(regionoit1)%></td>
						  <td class="<%If Round(regiondev1) >= 0 Then %>dashboard1<% ElseIf Round(regiondev1) > -5 Then %>dashboard2<% ElseIf Round(regiondev1) > -10 Then %>dashboard3<% Else %>dashboard4<% End If %>"><%=Round(regiondev1)%>%</td>
						  <td><%=Round(regionqty1)%></td>
						  <td><%=Round(regiontarget)%></td>
						  <td><%=Round(regionoit)%></td>
						  <td class="<%If Round(regiondev) >= 0 Then %>dashboard1<% ElseIf Round(regiondev) > -5 Then %>dashboard2<% ElseIf Round(regiondev) > -10 Then %>dashboard3<% Else %>dashboard4<% End If %>"><%=Round(regiondev)%>%</td>
						  <td><%=Round(regionqty)%></td>
						</tr>
						<%
						End If 

						' С��ÿ��BU��Greater China
						blsumtarget1 = blsumtarget1 + regiontarget1
						blsumoit1 = blsumoit1 + regionoit1
						If blsumtarget1 <> 0 Then
							blsumdev1 = (blsumoit1 - blsumtarget1) / blsumtarget1 * 100
						End If 
						blsumqty1 = blsumqty1 + regionqty1
						blsumtarget2 = blsumtarget2 + regiontarget2
						blsumoit2 = blsumoit2 + regionoit2
						If blsumtarget2 <> 0 Then
							blsumdev2 = (blsumoit2 - blsumtarget2) / blsumtarget2 * 100
						End If 
						blsumqty2 = blsumqty2 + regionqty2
						blsumtarget3 = blsumtarget3 + regiontarget3
						blsumoit3 = blsumoit3 + regionoit3
						If blsumtarget3 <> 0 Then
							blsumdev3 = (blsumoit3 - blsumtarget3) / blsumtarget3 * 100
						End If 
						blsumqty3 = blsumqty3 + regionqty3
						blsumtarget4 = blsumtarget4 + regiontarget4
						blsumoit4 = blsumoit4 + regionoit4
						If blsumtarget4 <> 0 Then
							blsumdev4 = (blsumoit4 - blsumtarget4) / blsumtarget4 * 100
						End If 
						blsumqty4 = blsumqty4 + regionqty4
						blsumtarget = blsumtarget + regiontarget
						blsumoit = blsumoit + regionoit
						If blsumtarget <> 0 Then
							blsumdev = (blsumoit - blsumtarget) / blsumtarget * 100
						End If 
						blsumqty = blsumqty + regionqty

						rsregion.movenext
					Wend 

					'''''BUС��
					'�������BU��SUBTOTAL������ҪС��
					If session("roleid") <> 7 Then 
				%>
						<tr class="line02" bgcolor="#E1FFFF">
						  <td><a href="javascript:intobu('<%=rs("product")%>')"><%=rs("product")%></a></td>
						  <td nowrap>Subtotal</td>
						  <%
						  If vquarter = "Q4" Then
						  %>
						  <td><%=Round(blsumtarget4)%></td>
						  <td><%=Round(blsumoit4)%></td>
						  <td class="<%If Round(blsumdev4) >= 0 Then %>dashboard1<% ElseIf Round(blsumdev4) > -5 Then %>dashboard2<% ElseIf Round(blsumdev4) > -10 Then %>dashboard3<% Else %>dashboard4<% End If %>"><%=Round(blsumdev4)%>%</td>
						  <td><%=Round(blsumqty4)%></td>
						  <%
						  End If 
						  If vquarter >= "Q3" Then 
						  %>
						  <td><%=Round(blsumtarget3)%></td>
						  <td><%=Round(blsumoit3)%></td>
						  <td class="<%If Round(blsumdev3) >= 0 Then %>dashboard1<% ElseIf Round(blsumdev3) > -5 Then %>dashboard2<% ElseIf Round(blsumdev3) > -10 Then %>dashboard3<% Else %>dashboard4<% End If %>"><%=Round(blsumdev3)%>%</td>
						  <td><%=Round(blsumqty3)%></td>
						  <%
						  End If 
						  If vquarter >= "Q2" Then 
						  %>
						  <td><%=Round(blsumtarget2)%></td>
						  <td><%=Round(blsumoit2)%></td>
						  <td class="<%If Round(blsumdev2) >= 0 Then %>dashboard1<% ElseIf Round(blsumdev2) > -5 Then %>dashboard2<% ElseIf Round(blsumdev2) > -10 Then %>dashboard3<% Else %>dashboard4<% End If %>"><%=Round(blsumdev2)%>%</td>
						  <td><%=Round(blsumqty2)%></td>
						  <%
						  End If 
						  %>
						  <td><%=Round(blsumtarget1)%></td>
						  <td><%=Round(blsumoit1)%></td>
						  <td class="<%If Round(blsumdev1) >= 0 Then %>dashboard1<% ElseIf Round(blsumdev1) > -5 Then %>dashboard2<% ElseIf Round(blsumdev1) > -10 Then %>dashboard3<% Else %>dashboard4<% End If %>"><%=Round(blsumdev1)%>%</td>
						  <td><%=Round(blsumqty1)%></td>
						  <td><%=Round(blsumtarget)%></td>
						  <td><%=Round(blsumoit)%></td>
						  <td class="<%If Round(blsumdev) >= 0 Then %>dashboard1<% ElseIf Round(blsumdev) > -5 Then %>dashboard2<% ElseIf Round(blsumdev) > -10 Then %>dashboard3<% Else %>dashboard4<% End If %>"><%=Round(blsumdev)%>%</td>
						  <td><%=Round(blsumqty)%></td>
						</tr>
				<%
					End If 
					rs.movenext
				Wend 
				

				''''''''''''''''''''''''''IS
				'ֻ��IS����ʾIS����
				If bu = "" Then 
				sumtarget1 = 0
				sumoit1 = 0
				sumdev1 = 0
				sumqty1 = 0
				sumtarget2 = 0
				sumoit2 = 0
				sumdev2 = 0
				sumqty2 = 0
				sumtarget3 = 0
				sumoit3 = 0
				sumdev3 = 0
				sumqty3 = 0
				sumtarget4 = 0
				sumoit4 = 0
				sumdev4 = 0
				sumqty4 = 0
				sumtarget = 0
				sumoit = 0
				sumdev = 0
				sumqty = 0

				Set rs1 = conn.execute(sqlregion)
				While Not rs1.eof
				%>
				<tr class="line02">
				<%
					sql = "select vquarter, sum(targetprice) target, sum(netoit) oit, sum(qty) qty from dashboard where oacm in (select zonename from zone where region='" & rs1("region") & "') and vyear='" & vyear & "'"
					If Not IsNull(session("user_bu")) And session("user_bu") <> "" Then
						sql = sql & " and bl='" & BU_TYPE(session("user_bu"), 1) & "'"
					End If
					If Not IsNull(session("userzone")) And session("userzone") <> "" Then
					  userzone = "'" & session("userzone") & "'"
					  userzone = Replace(userzone, ",", "','")
					  sql = sql & " and oacm in (" & userzone & ")" 
				    End If
					If bu <> "" Then
						sql = sql & " and bl='" & bu & "'"
					End If 
					sql = sql & " group by vquarter"
					Set rs3 = conn.execute(sql)
					
					istarget1 = 0
					isoit1 = 0
					isdev1 = 0
					isqty1 = 0
					istarget2 = 0
					isoit2 = 0
					isdev2 = 0
					isqty2 = 0
					istarget3 = 0
					isoit3 = 0
					isdev3 = 0
					isqty3 = 0
					istarget4 = 0
					isoit4 = 0
					isdev4 = 0
					isqty4 = 0
					istarget = 0
					isoit = 0
					isdev = 0
					isqty = 0

					While Not rs3.eof
						If rs3("vquarter")="Q1" Then
							istarget1 = rs3("target")
							isoit1 = rs3("oit")
							If istarget1 <> 0 Then
								isdev1 = (isoit1 - istarget1) / istarget1 * 100
							End If 
							isqty1 = rs3("qty")
							istarget = istarget + rs3("target")
							isoit = isoit + rs3("oit")
							If istarget <> 0 Then
								isdev = (isoit - istarget) / istarget * 100
							End If 
							isqty = isqty + rs3("qty")
						End If 
						If rs3("vquarter")="Q2" And vquarter >= "Q2" Then
							istarget2 = rs3("target")
							isoit2 = rs3("oit")
							If istarget2 <> 0 Then
								isdev2 = (isoit2 - istarget2) / istarget2 * 100
							End If 
							isqty2 = rs3("qty")
							istarget = istarget + rs3("target")
							isoit = isoit + rs3("oit")
							If istarget <> 0 Then
								isdev = (isoit - istarget) / istarget * 100
							End If 
							isqty = isqty + rs3("qty")
						End If 
						If rs3("vquarter")="Q3" And vquarter >= "Q3" Then
							istarget3 = rs3("target")
							isoit3 = rs3("oit")
							If istarget3 <> 0 Then
								isdev3 = (isoit3 - istarget3) / istarget3 * 100
							End If 
							isqty3 = rs3("qty")
							istarget = istarget + rs3("target")
							isoit = isoit + rs3("oit")
							If istarget <> 0 Then
								isdev = (isoit - istarget) / istarget * 100
							End If 
							isqty = isqty + rs3("qty")
						End If 
						If rs3("vquarter")="Q4" And vquarter = "Q4" Then
							istarget4 = rs3("target")
							isoit4 = rs3("oit")
							If istarget4 <> 0 Then
								isdev4 = (isoit4 - istarget4) / istarget4 * 100
							End If 
							isqty4 = rs3("qty")
							istarget = istarget + rs3("target")
							isoit = isoit + rs3("oit")
							If istarget <> 0 Then
								isdev = (isoit - istarget) / istarget * 100
							End If 
							isqty = isqty + rs3("qty")
						End If 
						
						rs3.movenext
					Wend 

				If session("roleid") <> 7 Then 
				%>
				  <td>IS</td>
				  <td><%=rs1("region")%></td>
				  <%
				  If vquarter = "Q4" Then
				  %>
				  <td><%=Round(istarget4)%></td>
				  <td><%=Round(isoit4)%></td>
				  <td class="<%If Round(isdev4) >= 0 Then %>dashboard1<% ElseIf Round(isdev4) > -5 Then %>dashboard2<% ElseIf Round(isdev4) > -10 Then %>dashboard3<% Else %>dashboard4<% End If %>"><%=Round(isdev4)%>%</td>
				  <td><%=Round(isqty4)%></td>
				  <%
				  End If 
				  If vquarter >= "Q3" Then 
				  %>
				  <td><%=Round(istarget3)%></td>
				  <td><%=Round(isoit3)%></td>
				  <td class="<%If Round(isdev3) >= 0 Then %>dashboard1<% ElseIf Round(isdev3) > -5 Then %>dashboard2<% ElseIf Round(isdev3) > -10 Then %>dashboard3<% Else %>dashboard4<% End If %>"><%=Round(isdev3)%>%</td>
				  <td><%=Round(isqty3)%></td>
				  <%
				  End If 
				  If vquarter >= "Q2" Then 
				  %>
				  <td><%=Round(istarget2)%></td>
				  <td><%=Round(isoit2)%></td>
				  <td class="<%If Round(isdev2) >= 0 Then %>dashboard1<% ElseIf Round(isdev2) > -5 Then %>dashboard2<% ElseIf Round(isdev2) > -10 Then %>dashboard3<% Else %>dashboard4<% End If %>"><%=Round(isdev2)%>%</td>
				  <td><%=Round(isqty2)%></td>
				  <%
				  End If 
				  %>
				  <td><%=Round(istarget1)%></td>
				  <td><%=Round(isoit1)%></td>
				  <td class="<%If Round(isdev1) >= 0 Then %>dashboard1<% ElseIf Round(isdev1) > -5 Then %>dashboard2<% ElseIf Round(isdev1) > -10 Then %>dashboard3<% Else %>dashboard4<% End If %>"><%=Round(isdev1)%>%</td>
				  <td><%=Round(isqty1)%></td>
				  <td><%=Round(istarget)%></td>
				  <td><%=Round(isoit)%></td>
				  <td class="<%If Round(isdev) >= 0 Then %>dashboard1<% ElseIf Round(isdev) > -5 Then %>dashboard2<% ElseIf Round(isdev) > -10 Then %>dashboard3<% Else %>dashboard4<% End If %>"><%=Round(isdev)%>%</td>
				  <td><%=Round(isqty)%></td>
				</tr>
				<%
				End If 
					' �ܼ�IS��Greater China
					sumtarget1 = sumtarget1 + istarget1
					sumoit1 = sumoit1 + isoit1
					If sumtarget1 <> 0 Then
						sumdev1 = (sumoit1 - sumtarget1) / sumtarget1 * 100
					End If 
					sumqty1 = sumqty1 + isqty1
					sumtarget2 = sumtarget2 + istarget2
					sumoit2 = sumoit2 + isoit2
					If sumtarget2 <> 0 Then
						sumdev2 = (sumoit2 - sumtarget2) / sumtarget2 * 100
					End If 
					sumqty2 = sumqty2 + isqty2
					sumtarget3 = sumtarget3 + istarget3
					sumoit3 = sumoit3 + isoit3
					If sumtarget3 <> 0 Then
						sumdev3 = (sumoit3 - sumtarget3) / sumtarget3 * 100
					End If 
					sumqty3 = sumqty3 + isqty3
					sumtarget4 = sumtarget4 + istarget4
					sumoit4 = sumoit4 + isoit4
					If sumtarget4 <> 0 Then
						sumdev4 = (sumoit4 - sumtarget4) / sumtarget4 * 100
					End If 
					sumqty4 = sumqty4 + isqty4
					sumtarget = sumtarget + istarget
					sumoit = sumoit + isoit
					If sumtarget <> 0 Then
						sumdev = (sumoit - sumtarget) / sumtarget * 100
					End If 
					sumqty = sumqty + isqty

					rs1.movenext
				Wend 
				%>
				<tr class="line02" bgcolor="#E1FFFF">
				  <td>IS</td>
				  <td nowrap><a href="javascript:intozone('<%=session("userzone")%>');"><%=session("userzone")%></a></td>
				  <%
				  If vquarter = "Q4" Then
				  %>
				  <td><%=Round(sumtarget4)%></td>
				  <td><%=Round(sumoit4)%></td>
				  <td class="<%If Round(sumdev4) >= 0 Then %>dashboard1<% ElseIf Round(sumdev4) > -5 Then %>dashboard2<% ElseIf Round(sumdev4) > -10 Then %>dashboard3<% Else %>dashboard4<% End If %>"><%=Round(sumdev4)%>%</td>
				  <td><%=Round(sumqty4)%></td>
				  <%
				  End If 
				  If vquarter >= "Q3" Then 
				  %>
				  <td><%=Round(sumtarget3)%></td>
				  <td><%=Round(sumoit3)%></td>
				  <td class="<%If Round(sumdev3) >= 0 Then %>dashboard1<% ElseIf Round(sumdev3) > -5 Then %>dashboard2<% ElseIf Round(sumdev3) > -10 Then %>dashboard3<% Else %>dashboard4<% End If %>"><%=Round(sumdev3)%>%</td>
				  <td><%=Round(sumqty3)%></td>
				  <%
				  End If 
				  If vquarter >= "Q2" Then 
				  %>
				  <td><%=Round(sumtarget2)%></td>
				  <td><%=Round(sumoit2)%></td>
				  <td class="<%If Round(sumdev2) >= 0 Then %>dashboard1<% ElseIf Round(sumdev2) > -5 Then %>dashboard2<% ElseIf Round(sumdev2) > -10 Then %>dashboard3<% Else %>dashboard4<% End If %>"><%=Round(sumdev2)%>%</td>
				  <td><%=Round(sumqty2)%></td>
				  <%
				  End If 
				  %>
				  <td><%=Round(sumtarget1)%></td>
				  <td><%=Round(sumoit1)%></td>
				  <td class="<%If Round(sumdev1) >= 0 Then %>dashboard1<% ElseIf Round(sumdev1) > -5 Then %>dashboard2<% ElseIf Round(sumdev1) > -10 Then %>dashboard3<% Else %>dashboard4<% End If %>"><%=Round(sumdev1)%>%</td>
				  <td><%=Round(sumqty1)%></td>
				  <td><%=Round(sumtarget)%></td>
				  <td><%=Round(sumoit)%></td>
				  <td class="<%If Round(sumdev) >= 0 Then %>dashboard1<% ElseIf Round(sumdev) > -5 Then %>dashboard2<% ElseIf Round(sumdev) > -10 Then %>dashboard3<% Else %>dashboard4<% End If %>"><%=Round(sumdev)%>%</td>
				  <td><%=Round(sumqty)%></td>
				</tr>
			<%
			End If 
			%>
              </table></td>
          </tr>
		  <tr>
		    <td>&nbsp;</td>
		  </tr>
		  <tr class="linefont">
		    <td>
		      <font size="3">Scope:</font> IS Products sold in Mainland China via business models of Direct Deal & Bidding Reseller.
			</td>
		  </tr>
        </table>
	  </td>
	  <tr>
	    <td>&nbsp;
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
