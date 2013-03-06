<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/commons.asp"-->
<!--#include file="../include/chkUser.asp"-->
<%
thispage = request("thispage")
itemcode = request("itemcode")
itemname = request("itemname")
tableid = request("tableid")

sql = "select * from party where state='0' and status='0'"

If itemcode <> "" Then
	sql = sql & " and itemcode like '%" & itemcode & "%'"
End If 
If itemname <> "" Then
	sql = sql & " and itemname like '%" & itemname & "%'"
End If 

Set rs = conn.execute(sql)

count=0
While Not rs.eof
  count=count+1
  rs.movenext
Wend 

'分页
if thispage="" or isEmpty(thispage) then 
    thispage=1
End if
PageSize=10 '每页数量
if PageSize=0 then 
    PageSize=1
End if
PageCount=int((count-1)/PageSize)+1
if PageCount=0 then 
    thispage=0
End if
thispage=int(thispage)
Startpage=(thispage-1)*PageSize+1
EndPage=Startpage+PageSize

URLCS = "itemcode=" & itemcode & "&itemname=" & itemname & "&tableid=" & tableid

Set rs = conn.execute(sql)

%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title>IS E-pricing system</title>
<link href="../css/css.css" rel="stylesheet" type="text/css">
<script language="javascript">
	function PageTo(str) {
    if (str > <%=PageCount%>)
    {
        alert ("This page is the last one!")
        return;
    }

    if (str < 1)
    {
        alert ("This page is the first one!")
        return;
    }
    
    document.form1.action="choose_party_option.asp?<%=URLCS%>&thispage="+str;
    document.form1.submit();
 }

 
function confirmparty(cid, itemcode, itemname, unitcost, unitcostrmb){
	//if(confirm("Your select Item is " + itemname + " ,confirm it?")){
		var tbl = window.opener.document.getElementById("<%=tableid%>");
		var count = window.opener.document.getElementById("<%=tableid%>count").value;
		newRow = tbl.insertRow(tbl.rows.length - 2);
		newRow.id = "onerecord";
		newRow.className = "line02";
		newRow.bgColor = "#55C6FE";

		c1 =  newRow.insertCell(0);
		c1.innerHTML = "<input type='checkbox' name='<%=tableid%>_medication' onclick='selectBox(this);'>";

		c2 =  newRow.insertCell(1);
		c2.innerHTML = "<input type='hidden' name='<%=tableid%>_cid" + count + "' value='" + cid + "'><input type='hidden' name='<%=tableid%>_itemcode" + count + "' value='" + itemcode + "'>" + itemcode;

		c3 = newRow.insertCell(2);
		c3.innerHTML = "<input type='hidden' name='<%=tableid%>_itemname" + count + "' value='" + itemname + "'>" + itemname;
		
		c4 = newRow.insertCell(3);
		c4.innerHTML =  "<input type='text' name='<%=tableid%>_qty" + count + "' value='1' size='3' onblur='validPlusIntParty(this, \"<%=tableid%>\");'>";

		c5 = newRow.insertCell(4);
		c5.innerHTML =  "<input type='hidden' name='<%=tableid%>_unitcost" + count + "' value='" + unitcost + "'><input type='hidden' name='<%=tableid%>_unitcostrmb" + count + "' value='" + unitcostrmb + "'>" + unitcost;
		
		c6 = newRow.insertCell(5);
		c6.innerHTML =  "<div id='<%=tableid%>_quotedcost" + count + "'>" + unitcost + "</div>";

		window.opener.document.getElementById("<%=tableid%>count").value = parseInt(window.opener.document.getElementById("<%=tableid%>count").value) + 1;

		window.opener.sumunitcost('<%=tableid%>');

		window.opener.calctargetprice();

		alert ("Selected " + itemcode);

	//	window.close();
	//}
 }
</script>
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
            <td class="titleorange"><div align="center">3rd Party Product List</div></td>
          </tr>
          <tr> 
            <td class="titleorange">&nbsp;</td>
          </tr>
          <tr> 
            <td valign="top" class="line01"> <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
                <tr> 
                  <td>
				    <form name="form1" action="choose_party_option.asp" method="post">
				    <table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                      <tr class="line01"> 
                        <td height="25"> <div align="left">Product code</div></td>
                        <td> <div align="left"> 
                            <input type="text" name="itemcode" value="<%=itemcode%>">
                          </div></td>
                        <td height="25"> <div align="left">Product name</div></td>
                        <td> <div align="left"> 
                            <input type="text" name="itemname" value="<%=itemname%>">
							<input type="hidden" name="tableid" value="<%=tableid%>">
                          </div></td>
						<td align="right">
						  <input type="submit" name="Submit" value="Search">&nbsp;&nbsp;
						  <!--<input type="button" name="Submit2" value=" New " onclick="location.href='configuration_add.asp'">-->
						</td>
                      </tr>
                    </table>
					</form>
			      </td>
                </tr>
              </table>
			</td>
          </tr>
          <tr> 
            <td><table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
				  <td width="3%">Select</td>
                  <td>Product code</td>
                  <td>Product name</td>
                  <td>Vendor</td>
                  <td>Unit cost(USD)</td>
                  <td>Unit cost(RMB)</td>
                  <td>Applicable modality</td>
                  <td>Lead time</td>
                  <td>Original country</td>
                  <td>Warranty period</td>
                </tr>
				<%
				y = 0
				While Not rs.eof
					y = y + 1
					If y>=StartPage And y<EndPage Then 
				%>
					 <tr class="line02"> 
					  <td><input type="radio" value="on" onclick="confirmparty('<%=rs("pid")%>', '<%=rs("itemcode")%>', '<%=rs("itemname")%>', '<%=Round(rs("unitcost"))%>', '<%=Round(rs("unitcostrmb"))%>')"></td>
					  <td><%=rs("itemcode")%>&nbsp;</td>
					  <td><%=rs("itemname")%>&nbsp;</td>
					  <td><%=rs("dealer")%>&nbsp;</td>
					  <td><%=Round(rs("unitcost"))%>&nbsp;</td>
					  <td><%=Round(rs("unitcostrmb"))%>&nbsp;</td>
					  <td><%=rs("model")%>&nbsp;</td>
					  <td><%=rs("diliverydate")%>&nbsp;</td>
					  <td><%=rs("madein")%>&nbsp;</td>
					  <td><%=rs("warranty")%>&nbsp;</td>
					</tr>
				<%
					End If 
					rs.movenext
				Wend 
				%>
              </table></td>
          </tr>
		  <tr>
		    <td>
			  <TABLE height="34" cellSpacing="0" cellPadding="0" width="100%" background='../img/bg_bt.gif' border="0">
				<TBODY>
				<tr class="line01">
				  <td align="right">
					Record Count:<%=Count%>&nbsp;&nbsp;Page:<%=thispage%>/<%=PageCount%>
				  </td>
				  <td noWrap align="middle" width="70%">
					First Page&nbsp;
					<A href="javascript:PageTo('1')">|&lt;&lt;</A>
					&nbsp;&nbsp; 
					<A href="javascript:PageTo('<%=thispage-1%>')">&lt;&lt;</A>
					&nbsp;&nbsp; 
					<A href="javascript:PageTo('<%=thispage+1%>')">&gt;&gt;</A>
					&nbsp;&nbsp; 
					<A href="javascript:PageTo('<%=PageCount%>')">&gt;&gt;|</A>
					&nbsp; Last Page&nbsp;
				  </td>
				</tr>
				</TBODY>
			  </TABLE>
			</td>
		  </tr>
        </table></td>
    </tr>
  </table>
  <!--#include file="../footer.asp"-->
</div>
</body>
</html>
