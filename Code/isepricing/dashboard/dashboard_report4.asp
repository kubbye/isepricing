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

sql = "select productname from dashboard where vyear='" & vyear & "' and bl='" & bu & "'"

If product <> "" Then
	sql = sql & " and productname='" & product & "'"
End If 

If Not IsNull(session("user_bu")) And session("user_bu") <> "" Then
	sql = sql & " and bl='" & BU_TYPE(session("user_bu"), 1) & "'"
End If 

sql = sql & " group by productname"
sql = sql & " order by productname"

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
function intoproductzone(product, zone){
	document.form1.product.value = product;
	document.form1.zone.value = zone;
	document.form1.action = "dashboard_report_detail.asp";
	document.form1.submit();
}

function intoproduct(product){
	document.form1.product.value = product;
	document.form1.zone.value = "";
	document.form1.action = "dashboard_report_detail.asp";
	document.form1.submit();
}

function intobu(bu){
	document.form1.product.value = "";
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
  <input type="hidden" name="product" value="<%=product%>">
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
				'循环product
				While Not rs.eof
					sql = "select zonename from zone where 1=1"
					If region <> "" Then
						sql = sql & " and region='" & region & "'"
					End If 
					If zone <> "" Then
						sql = sql & " and zonename='" & zone & "'"
					End If 
					Set rszone = conn.execute(sql)
					
					'开始循环zone
					While Not rszone.eof

				%>
					<tr class="line02">
					  <%
						sql = "select vquarter, sum(targetprice) target, sum(netoit) oit, sum(qty) qty from dashboard where productname='" & rs("productname") & "' and oacm='" & rszone("zonename") & "' and vyear='" & vyear & "'"
					
					  If Not IsNull(session("userzone")) And session("userzone") <> "" Then
						  userzone = "'" & session("userzone") & "'"
						  userzone = Replace(userzone, ",", "','")
						  sql = sql & " and oacm in (" & userzone & ")" 
					  End If
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
					  '循环四个季度
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
					  '结束循环四个季度
					  Wend 
					  %>
					  <td><a href="javascript:intoproductzone('<%=rs("productname")%>', '<%=rszone("zonename")%>')"><%=rs("productname")%></a></td>
					  <td><%=rszone("zonename")%></td>
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
				'结束循环zone
				Wend 
				
				'小结一个product
				'只有当没有ZONE时才小结产品
				If zone = "" Then 
					sql = "select vquarter, sum(targetprice) target, sum(netoit) oit, sum(qty) qty from dashboard where productname='" & rs("productname") & "' and vyear='" & vyear & "'"

					If region <> "" Then
						sql = sql & " and oacm in (select zonename from zone where region='" & region & "')"
					End If 
						
					If Not IsNull(session("userzone")) And session("userzone") <> "" Then
					  userzone = "'" & session("userzone") & "'"
					  userzone = Replace(userzone, ",", "','")
					  sql = sql & " and oacm in (" & userzone & ")" 
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
					  '循环四个季度
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
					  '结束循环四个季度
					  Wend 
					  %>
					<tr class="line02" bgcolor="#E1FFFF">
					  <td><a href="javascript:intoproduct('<%=rs("productname")%>')"><%=rs("productname")%></a></td>
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
				'结束“只有当没有ZONE时才小结产品”
				End If 
				

				rs.movenext
			'结束循环product
			Wend 

			'计算BU的合计数据
			'只有当没有product时才小结BU
			If product = "" Then 
				sql = "select vquarter, sum(targetprice) target, sum(netoit) oit, sum(qty) qty from dashboard where bl='" & bu & "' and vyear='" & vyear & "'"

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
			  %>
				<tr class="line02" bgcolor="#8DB4E3">
				  <td><a href="javascript:intobu('<%=bu%>')"><%=bu%></a></td>
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
			'结束"只有当没有product时才小结BU"
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
