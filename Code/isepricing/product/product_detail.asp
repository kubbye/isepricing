<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/commons.asp"-->
<!--#include file="../include/chkUser.asp"-->
<%

pid = request("pid")

sql = "select a.*, b.modality, b.bu, convert(varchar, b.inst) minst, convert(varchar, b.warr) mwarr, b.apptraining mapptraining, b.apptrainingrmb mapptrainingrmb from product a, modality b where a.mid=b.mid and a.pid=" & pid
Set rs = conn.execute(sql)

If rs("status") = "0" Then
	confstatus = "0"
ElseIf rs("status") = "1" Then
	confstatus = "2"
Else 
	confstatus = "1"
End If 

sql = "select a.*, convert(varchar, a.discount) discount, b.wrp from product_detail_philips a, configurations b, product c where a.pid=c.pid and a.materialno=b.materialno and b.version=c.version and b.state='0' and b.status='" & confstatus & "' and a.type='0' and a.pid=" & pid & " order by a.sortno"
Set rs1 = conn.execute(sql)

sql = "select * from product_detail_3rd where type='0' and pid=" & pid
Set rs2 = conn.execute(sql)

sql = "select a.*, convert(varchar, a.discount) discount, b.wrp from product_detail_philips a, configurations b, product c where a.pid=c.pid and a.materialno=b.materialno and b.version=c.version and b.state='0' and b.status='" & confstatus & "' and a.type='1' and a.pid=" & pid & " order by a.sortno"
Set rs3 = conn.execute(sql)

sql = "select * from product_detail_3rd where type='1' and pid=" & pid
Set rs5 = conn.execute(sql)

sql = "select *, convert(varchar, discount) discount from product_option_discount where type='0' and pid=" & pid
Set rs6 = conn.execute(sql)


sql = "select * from exchanges where sourcecode='" & rs("currency") & "'"
Set rscurrency = conn.execute(sql)

vcurrency = 1
If Not rscurrency.eof Then
	vcurrency = rscurrency("rate")
End If 

%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title>IS E-pricing system</title>
<link href="../css/css.css" rel="stylesheet" type="text/css">
<%
If session("roleid") = 7 Or session("roleid") = 8 Or session("roleid") = 9 Then 
%>
<script language="javascript">

document.oncontextmenu=new Function("event.returnValue=false;");

document.onselectstart=new Function("event.returnValue=false;"); 
</script>
<%
End If 
%>
</head>

<body bgcolor="#CCCCCC" leftmargin="0" topmargin="0" >
<div align="center">
  <table width="1000" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td>
	    <table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td class="titleorange"><div align="center">Product Details</div></td>
          </tr>
          <tr> 
            <td valign="top" class="line01"> <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
                <tr> 
                  <td>
				    <%
					'MD, DM, SD, Sales Supervisor, SCM Specialist, CEO, CFO, Commercial, SCM Manager都不需要看！1）Modality,2） Non-key option discount，3）Total Target Price。
					isdisplay = 1
					If session("roleid") = 4 Or session("roleid") = 7 Or session("roleid") = 8 Or session("roleid") = 9 Or session("roleid") = 10 Or session("roleid") = 11 Or session("roleid") = 12 Or session("roleid") = 14 Or session("roleid") = 15 Then 
						isdisplay = 0
					End If 
					%>
				    <table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                      <tr class="line01"> 
                        <td width="25%" height="25"> <div align="left">BU:<br>
                          </div></td>
                        <td width="25%"> <div align="left"> <%=BU_TYPE(rs("bu"), 1)%></div></td>
                        <td width="25%"> <div align="left"><%If isdisplay = 1 Then %>Modality:<% End If %>&nbsp;</div></td>
                        <td width="25%"><div align="left"> <%If isdisplay = 1 Then %><%=rs("modality")%><% End If %>&nbsp;
                          </div></td>
                      </tr>
                      <tr class="line01"> 
                        <td height="25"> <div align="left">Product:</div></td>
                        <td> <div align="left"> 
                            <%=rs("productname")%>
                          </div></td>
                        <td><div align="left">Currency:</div></td>
                        <td><div align="left">
						<%
						If Not rscurrency.eof Then 
						%>
						<%=rscurrency("currency")%>
						<%
						Else 
						%>
						美元
						<%
						End If 
						%>
                          </div></td>
                      </tr>
                      <tr class="line01"> 
                        <td height="25"> <div align="left">Standard Net Target Price:</div></td>
                        <td> <div align="left"> 
                            &nbsp;<%=Round(rs("standardprice") * vcurrency)%>
                          </div></td>
                        <td><div align="left"><%If isdisplay = 1 Then %>Total Target Price:<% End If %>&nbsp;</div></td>
                        <td><div align="left">
                           <%If isdisplay = 1 Then %><%=Round(rs("targetprice") * vcurrency)%><% End If %>&nbsp;
                          </div></td>
                      </tr>
					  <%
					  If isdisplay = 1 Then
					  %>
                      <tr class="line01"> 
                        <td height="25"> <div align="left">Non-Key Options Discount:</div></td>
                        <td> <div align="left"> <%=rs("otherdiscount")%>
                            &nbsp;
                          </div></td>
                        <td><div align="left">&nbsp;</div></td>
                        <td><div align="left">&nbsp;
                          </div></td>
                      </tr>
					  <%
					  End If 
					  %>
                      <tr class="line01"> 
                        <td height="25"> <div align="left">Promotion Plan:</div></td>
                        <td colspan="3"> <div align="left"> 
                            &nbsp;<%=rs("remark")%>
                          </div></td>
                      </tr>
                    </table></td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
	  </td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td><table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td class="line01">Standard Configurations</td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td>
			  <%
			  isdisctp = 0
			  colspannum = 7
			  If session("roleid") = 1 Or session("roleid") = 3 Or session("roleid") = 4 Or session("roleid") = 6 Then
				isdisctp = 1
				colspannum = colspannum + 2
			  End If 
			  %>
			  <table id="standardphilips" width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td colspan="<%=colspannum%>">Philips Standard Configurations
				  </td>
                </tr>
                <tr class="line01"> 
                  <td width="3%">Mutex</td>
                  <td width="3%">No.</td>
                  <td width="10%">Article No.</td>
                  <td>Article Description</td>
                  <td width="5%">Qty</td>
                  <td>List Price</td>
                  <td>Total List Price</td>
				  <%
				  If isdisctp = 1 Then 
				  %>
				  <td>CTP</td>
				  <td>Total CTP</td>
				  <%
				  End If 
				  %>
                </tr>
				<%
				sumprice = 0
				sumctp = 0
				While Not rs1.eof
				%>
					<tr class="line02">
					  <td><%=rs1("mutex")%>&nbsp;</td>
					  <td><%=rs1("sortno")%>&nbsp;</td>
					  <td><%=rs1("materialno")%></td>
					  <td><%=rs1("description")%></td>
					  <td><%=rs1("qty")%></td>
					  <td><%=Round(rs1("listprice") * vcurrency)%></td>
					  <td><%=Round(rs1("listprice") * vcurrency * rs1("qty"))%></td>
					  <%
					  If isdisctp = 1 Then 
					  %>
					  <td><%=Round(rs1("wrp") * vcurrency)%></td>
					  <td><%=Round(rs1("wrp") * vcurrency * rs1("qty"))%></td>
					  <%
					  End If 
					  %>
					</tr>
				<%
					sumprice = sumprice + rs1("listprice") * rs1("qty") * vcurrency
					sumctp = sumctp + rs1("wrp") * rs1("qty") * vcurrency
					rs1.movenext
				Wend 
				%>
				<%
				If rs("status") <> "0" And rs("status") <> "1" Then 
				%>
				<tr class="line01">
                  <td colspan="6">Subtotal</td>
                  <td><%=Round(sumprice)%></td>
				  <%
				  If isdisctp = 1 Then 
				  %>
				  <td>&nbsp;</td>
				  <td><%=Round(sumctp)%></td>
				  <%
				  End If 
				  %>
				</tr>
			    <%
				End If 
				%>
              </table>
			</td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td><table id="standard3rd" width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td colspan="6">Standard 3rd Party Products
				  </td>
                </tr>
                <tr class="line01"> 
				  <td width="3%">Mutex</td>
                  <td width="10%">Product Code</td>
                  <td>Product Name</td>
                  <td width="5%">Qty</td>
                  <td>Unit Cost</td>
                  <td>Total Cost</td>
                </tr>
				<%
				sumprice = 0
				While Not rs2.eof
				%>
					<tr class="line02">
					  <td><%=rs2("mutex")%>&nbsp;</td>
					  <td><%=rs2("materialno")%>&nbsp;</td>
					  <td><%=rs2("itemname")%></td>
					  <td><%=rs2("qty")%></td>
					  <td><%If rs("currency") = "RMB" Then %><%=Round(rs2("unitcostrmb"))%><% Else %><%=Round(rs2("unitcost") * vcurrency)%><% End If %></td>
					  <td><%If rs("currency") = "RMB" Then %><%=Round(rs2("unitcost") * rs2("qty"))%><% Else %><%=Round(rs2("unitcost") * rs2("qty") * vcurrency)%><% End If %></td>
					</tr>
				<%
					'If rs("currency") = "RMB" Then 
					'	sumprice = sumprice + rs2("unitcost") * rs2("qty") * vcurrency
					'Else 
					'	sumprice = sumprice + rs2("unitcost") * rs2("qty")
					'End If 
					rs2.movenext
				Wend 
				%>
                <!--<tr class="line01"> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>-->
              </table></td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
		  <%
		  'If session("roleid") <> 7 and session("roleid") <> 2 Then 
		  If session("roleid") <> 7 And session("roleid") <> 8 And session("roleid") <> 11 And session("roleid") <> 12 And session("roleid") <> 2 Then 
		  %>
		  <tr> 
            <td><table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
				  <td>Other Direct Cost<br>其他直接成本</td>
                  <td>Selection</td>
                  <td>Charged %</td>
                  <td>Amount</td>
                </tr>
				<tr class="line02">
				  <td>Freight &amp; Insurance<br>运费&amp;保险费 </td>
				  <td>
				    <%
					If Not IsNull(rs("freight")) And rs("freight") <> "" Then 
					%>
				    <%=rs("freight")%>
					<%
					Else 
					%>
					CIP
					<%
					End If 
					%>
				  </td>
				  <td>
				    <div id="freightdiv">
					<%
					If rs("freight")="FCA" Then 
					%>
					0.0%
					<%
					ElseIf rs("freight")="CIF" Then 
					%>
					0.3%
					<%
					Else 
					%>
					0.5%
					<%
					End If 
					%>
					</div>
				  </td>
				  <td>&nbsp;</td>
				</tr>
                <tr class="line02"> 
                  <td>Installation By Philips<br>飞利浦安装成本</td>
                  <td>
				  <%
				  If rs("inst") = "0" Then 
				  %>
				  NO
				  <%
				  Else 
				  %>
				  YES
				  <%
				  End If 
				  %>
				  </td>
                  <td><%=rs("minst")%>%</td>
                  <td>&nbsp;</td>
                </tr>
                <tr class="line02"> 
                  <td>Application Training<br>应用培训成本</td>
                  <td>
				  <%
				  If rs("apptraining") = "0" Then 
				  %>
				  NO
				  <%
				  Else 
				  %>
				  YES
				  <%
				  End If 
				  %>
                  <td>&nbsp;</td>
                  <td>
				    <%If rs("currency") = "RMB" Then %><%=rs("mapptrainingrmb")%><% Else %><%=rs("mapptraining") * vcurrency%><% End If %>
                </tr>
                <tr class="line02"> 
                  <td>Standard warranty By Philips<br>飞利浦标准保修费</td>
                  <td>
				  <%
				  If rs("warr") = "0" Then 
				  %>
				  NO
				  <%
				  Else 
				  %>
				  YES
				  <%
				  End If 
				  %>
				  </td>
                  <td><%=rs("mwarr")%>%</td>
                  <td>&nbsp;</td>
                </tr>
              </table></td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
		  <%
		  ElseIf session("roleid") <> 2 Then 
		  %>
		  <tr> 
            <td><table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
				  <td>其他直接成本</td>
                  <td>&nbsp;</td>
                </tr>
				<tr class="line02">
				  <td>Freight &amp; Insurance<br>运费&amp;保险费 </td>
				  <td><%If rs("freight") = "FCA" Then %>无<% Else %>有<% End If %></td>
				</tr>
                <tr class="line02"> 
                  <td>Installation By Philips<br>飞利浦安装成本</td>
				  <td><%If rs("inst") = "0" Then %>无<% Else %>有<% End If %></td>
                </tr>
                <tr class="line02"> 
                  <td>Application Training<br>应用培训成本</td>
				  <td><%If rs("apptraining") = "0" Then %>无<% Else %>有<% End If %></td>
                </tr>
                <tr class="line02"> 
                  <td>Standard warranty By Philips<br>飞利浦标准保修费</td>
				  <td><%If rs("warr") = "0" Then %>无<% Else %>有<% End If %></td>
                </tr>
              </table></td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
		  <%
		  End If 
		  %>
        </table></td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td>
	    <table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td class="line01">Options</td>
          </tr>
          <tr> 
            <td class="line01">以下选件不包含在“Standard Configuration”中，以下选件价格不包含在“Standard Net Target Price”中！</td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td>
				<%
				isdisctp = 0
				colspannum = 9
				If session("roleid") = 1 Or session("roleid") = 2 Or session("roleid") = 3 Or session("roleid") = 4 Or session("roleid") = 6 Then
				isdisctp = 1
				colspannum = colspannum + 1
				End If 
				%>
			  <table id="options1philips" width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td colspan="<%=colspannum%>">Philips Key Options</td>
                </tr>
                <tr class="line01"> 
                  <td width="3%">Mutex</td>
                  <td width="3%">No.</td>
                  <td width="10%">Content</td>
                  <td width="10%">Article No.</td>
                  <td>Article Description</td>
                  <td width="5%">Qty</td>
                  <td>List Price</td>
				  <%
				  If isdisctp = 1 Then 
				  %>
				  <td>CTP</td>
				  <%
				  End If 
				  %>
                  <td>Target Price</td>
				   <%If session("roleid") <> 7 And session("roleid") <> 8 And session("roleid") <> 9 Then %>
                  <td>Dis. Rate</td>
				  <% End If %>
                </tr>
				<%
				'sumprice = 0
				While Not rs3.eof
				%>
					<tr class="line02">
					  <td><%=rs3("mutex")%>&nbsp;</td>
					  <td><%=rs3("sortno")%>&nbsp;</td>
					  <td><%=rs3("items")%>&nbsp;</td>
					  <td><%=rs3("materialno")%></td>
					  <td><%=rs3("description")%></td>
					  <td><%=rs3("qty")%></td>
					  <td><%=Round(rs3("listprice") * vcurrency)%></td>
					  <%
					  If isdisctp = 1 Then 
					  %>
					  <td><%=Round(rs3("wrp") * vcurrency)%></td>
					  <%
					  End If 
					  %>
					  <td><%=Round(rs3("targetprice") * vcurrency)%>&nbsp;</td>
				   <%If session("roleid") <> 7 And session("roleid") <> 8 And session("roleid") <> 9 Then %>
					  <td><%=rs3("discount")%>&nbsp;</td>
					   <% End If %>
					</tr>
				<%
					'sumprice = sumprice + rs3("listprice") * vcurrency
					rs3.movenext
				Wend 
				%>
				<!--<tr class="line01">
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
				   <%If session("roleid") <> 7 And session("roleid") <> 8 And session("roleid") <> 9 Then %>
                  <td>&nbsp;</td>
				  <% End If %>
				</tr>-->
              </table></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
		  <%
		  If session("roleid") = 1 Or session("roleid") = 3 Or session("roleid") = 4 Or session("roleid") = 6 Then 
		  %>
		  <tr> 
            <td><table id="dynamictable" width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td colspan="3">Dynamic Options Discount</td>
                </tr>
                <tr class="line01"> 
                  <td>Content</td>
                  <td>Article No.</td>
                  <td>Discount Rate</td>
                </tr>
				<%
				While Not rs6.eof
				%>
					<tr class="line02">
					  <td>
					    <%=rs6("items")%>
					  </td>
					  <td>
					    <%=rs6("options")%>
					  </td>
					  <td>
					    <%=rs6("discount")%>
					  </td>
					</tr>
				<%
					rs6.movenext
				Wend 
				%>
              </table></td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
		  <%
		  End If 
		  %>
          <tr> 
            <td><table id="options3rd" width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td colspan="5">Key 3rd Party Options
				  </td>
                </tr>
                <tr class="line01"> 
				  <td width="10%">Product Code</td>
                  <td>Product Name</td>
                  <td width="5%">Qty</td>
                  <td>Unit Cost</td>
                  <td>Total Cost</td>
                </tr>
				<%
				sumprice = 0
				While Not rs5.eof
				%>
					<tr class="line02">
					  <td><%=rs5("materialno")%></td>
					  <td><%=rs5("itemname")%></td>
					  <td><%=rs5("qty")%></td>
					  <td><%If rs("currency") = "RMB" Then %><%=Round(rs5("unitcostrmb"))%><% Else %><%=Round(rs5("unitcost") * vcurrency)%><% End If %></td>
					  <td><%If rs("currency") = "RMB" Then %><%=Round(rs5("unitcostrmb") * rs5("qty"))%><% Else %><%=Round(rs5("unitcost") * rs5("qty") * vcurrency)%><% End If %></td>
					</tr>
				<%
					'If rs("currency") = "RMB" Then 
					'	sumprice = sumprice + rs5("unitcostrmb") * rs5("qty")
					'Else 
					'	sumprice = sumprice + rs5("unitcost") * rs5("qty") * vcurrency
					'End If 
					rs5.movenext
				Wend 
				%>
               <!-- <tr class="line01"> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>-->
              </table></td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td><div align="right"> 
          <input type="button" name="btnreturn" value="Return" onclick="javascript:history.go(-1)">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        </div></td>
    </tr>
  </table>
  <!--#include file="../footer.asp"-->
</div>
</body>
</html>
