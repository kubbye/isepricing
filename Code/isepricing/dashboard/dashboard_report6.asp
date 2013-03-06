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

sql = "select distinct region from zone where 1=1"



If region <> "" Then
	sql = sql & " and region='" & region & "'"
End If 
If zone <> "" Then
	sql = sql & " and zonename='" & zone & "'"
End If 

If Not IsNull(session("userzone")) And session("userzone") <> "" Then
	userzone = "'" & session("userzone") & "'"
	userzone = Replace(userzone, ",", "','")
	sql = sql & " and zonename in (" & userzone & ")" 
End If

sql = sql & " order by region"

Set rs = conn.execute(sql)

%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title>IS E-pricing system</title>
<link href="../css/css.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="../js/jquery-1.2.6.js"></script>
<script language="javascript">
function intozoneproduct(zone, product){
	document.form1.product.value = product;
	document.form1.zone.value = zone;
	document.form1.action = "dashboard_report_detail.asp";
	document.form1.submit();
}

function intozone(zone){
	document.form1.product.value = "";
	document.form1.zone.value = zone;
	document.form1.region.value = "";
	document.form1.action = "dashboard_report_detail.asp";
	document.form1.submit();
}

function intoregion(region){
	document.form1.product.value = "";
	document.form1.zone.value = "";
	document.form1.region.value = region;
	document.form1.action = "dashboard_report_detail.asp";
	document.form1.submit();
}

function intobu(){
	document.form1.product.value = "";
	document.form1.zone.value = "";
	document.form1.region.value = "";
	document.form1.action = "dashboard_report_detail.asp";
	document.form1.submit();
}
</script>
</head>

<body bgcolor="#ffffff" leftmargin="0" topmargin="0">
<form name="form1" action="" method="post">
  <input type="hidden" name="vyear" value="<%=vyear%>">
  <input type="hidden" name="vquarter" value="<%=vquarter%>">
  <input type="hidden" name="bu" value="<%=bu%>">
  <input type="hidden" name="region" value="<%=region%>">
  <input type="hidden" name="zone" value="<%=zone%>">
  <input type="hidden" name="product" value="">
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
                  <td rowspan="2">Region</td>
                  <td rowspan="2">Product</td>
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
				'开始循环region
				While Not rs.eof

					sql = "select distinct zonename from zone where region='" & rs("region") & "'"
					If Not IsNull(session("userzone")) And session("userzone") <> "" Then
						userzone = "'" & session("userzone") & "'"
						userzone = Replace(userzone, ",", "','")
						sql = sql & " and zonename in (" & userzone & ")" 
					End If
					If zone <> "" Then
						sql = sql & " and zonename='" & zone & "'"
					End If 
					Set rs1 = conn.execute(sql)
					
					'开始循环zone
					While Not rs1.eof

						sql = "select distinct productname from dashboard where vyear='" & vyear & "'"
						If bu <> "" Then
							sql = sql & " and bl='" & bu & "'"
						End If 
						Set rsproduct = conn.execute(sql)
						
						'开始循环product
						While Not rsproduct.eof
							
							sql = "select vquarter, sum(targetprice) target, sum(netoit) oit, sum(qty) qty from dashboard where oacm='" & rs1("zonename") & "' and vyear='" & vyear & "' and productname='" & rsproduct("productname") & "'"
							sql = sql & " group by vquarter"
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

							' 开始循环Q1-Q4
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
							'结束循环Q1-Q4
							Wend 
							  %>
							<tr class="line02">
							  <td><a href="javascript:intozoneproduct('<%=rs1("zonename")%>', '<%=rsproduct("productname")%>')"><%=rs1("zonename")%></a></td>
							  <td><%=rsproduct("productname")%></td>
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
							rsproduct.movenext
						'结束循环product
						Wend 

						sql = "select vquarter, sum(targetprice) target, sum(netoit) oit, sum(qty) qty from dashboard where oacm='" & rs1("zonename") & "' and vyear='" & vyear & "'"
						If bu <> "" Then
							sql = sql & " and bl='" & bu & "'"
						End If 
						sql = sql & " group by vquarter"
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

						' 开始循环Q1-Q4
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
						'结束循环Q1-Q4
						Wend 
							  %>
							<tr class="line02" bgcolor="#E1FFFF">
							  <td><a href="javascript:intozone('<%=rs1("zonename")%>')"><%=rs1("zonename")%></a></td>
							  <td>Subtotal</td>
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
						rs1.movenext
					'结束循环zone
					Wend 
					

					''''''''''''''''''''''''''''''REGION
					'当ZONE为空时才显示REGION
					If zone = "" Then 
						sql = "select vquarter, sum(targetprice) target, sum(netoit) oit, sum(qty) qty from dashboard where oacm in (select zonename from zone where region='" & rs("region") & "') and vyear='" & vyear & "'"
						If bu <> "" Then
							sql = sql & " and bl='" & bu & "'"
						End If 
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

						'开始循环region的Q1-Q4
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
						'结束循环region的Q1-Q4
						Wend 
							%>
							<tr class="line02" bgcolor="#E1FFFF">
							  <td><a href="javascript:intoregion('<%=rs("region")%>')"><%=rs("region")%></a></td>
							  <td>Subtotal</td>
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
					rs.movenext
				'结束循环region
				Wend 

				''''''''''''''''''''''''''Total
				'只有当REGION和ZONE都为空时才显示TOTAL
				If region = "" And zone = "" Then 
					sql = "select vquarter, sum(targetprice) target, sum(netoit) oit, sum(qty) qty from dashboard where vyear='" & vyear & "'"
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
					%>
					<tr class="line02" bgcolor="#8DB4E3">
					  <td><a href="javascript:intobu()">Subtotal</a></td>
					  <td><%=bu%></td>
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
