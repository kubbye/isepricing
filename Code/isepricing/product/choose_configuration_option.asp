<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/commons.asp"-->
<!--#include file="../include/chkUser.asp"-->
<%
thispage = request("thispage")
materialno = request("materialno")
tableid = request("tableid")
version = request("version")
rowflg = request("rowflg")

sql = "select * from configurations where state='0' and version='" & version & "'"

If materialno <> "" Then
	sql = sql & " and materialno like '%" & materialno & "%'"
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

URLCS = "materialno=" & materialno & "&tableid=" & tableid & "&version=" & version

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
    
    document.form1.action="choose_configuration_option.asp?<%=URLCS%>&thispage="+str;
    document.form1.submit();
 }

 function confirmconfiguration(cid, materialno, description, listprice){
	//if(confirm("Your select Material No is " + materialno + " ,confirm it?")){
		var tbl = window.opener.document.getElementById("<%=tableid%>");
		var count = window.opener.document.getElementById("<%=tableid%>count").value;
		newRow = tbl.insertRow(tbl.rows.length - <%=rowflg%>);
		newRow.id = "onerecord";
		newRow.className = "line02";
		newRow.bgColor = "#55C6FE";

		c1 =  newRow.insertCell(0);
		c1.innerHTML = "<input type='checkbox' name='<%=tableid%>_medication' onclick='selectBox(this);'>";

		c2 =  newRow.insertCell(1);
		c2.innerHTML = "<select name='<%=tableid%>_mutex" + count + "'><option value=''></option><option value='1'>1</option><option value='2'>2</option><option value='3'>3</option><option value='4'>4</option><option value='5'>5</option></select>";

		c3 =  newRow.insertCell(2);
		c3.innerHTML = "<input type='text' name='<%=tableid%>_sortno" + count + "' size='3' onblur='validPlusInt2(this, \"<%=tableid%>\");'>";

		c4 =  newRow.insertCell(3);
		c4.innerHTML = "<input type='text' name='<%=tableid%>_items" + count + "'>";

		c5 = newRow.insertCell(4);
		c5.innerHTML = "<input type='hidden' name='<%=tableid%>_cid" + count + "' value='" + cid + "'><input type='hidden' name='<%=tableid%>_materialno" + count + "' value='" + materialno + "'>" + materialno;

		c6 = newRow.insertCell(5);
		c6.innerHTML =  "<input type='hidden' name='<%=tableid%>_description" + count + "' value='" + description + "'>" + description;

		c7 = newRow.insertCell(6);
		c7.innerHTML ="<input type='text' name='<%=tableid%>_qty" + count + "' value='1' size='3' onblur='validPlusInt(this, \"<%=tableid%>\");'>";
		
		c8 = newRow.insertCell(7);
		c8.innerHTML =  "<input type='hidden' name='<%=tableid%>_listprice" + count + "' value='" + listprice + "'>" + listprice;

		window.opener.document.getElementById("<%=tableid%>count").value = parseInt(window.opener.document.getElementById("<%=tableid%>count").value) + 1;

		alert ("Selected " + materialno);

		window.opener.sumlistprice('<%=tableid%>');

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
            <td class="titleorange"><div align="center">Configuration List</div></td>
          </tr>
          <tr> 
            <td class="titleorange">&nbsp;</td>
          </tr>
          <tr> 
            <td valign="top" class="line01"> <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
                <tr> 
                  <td>
				    <form name="form1" action="choose_configuration_option.asp" method="post">
				    <table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                      <tr class="line01"> 
                        <td height="25"> <div align="left">Article No.</div></td>
                        <td> <div align="left"> 
                            <input type="text" name="materialno" value="<%=materialno%>">
							<input type="hidden" name="tableid" value="<%=tableid%>">
							<input type="hidden" name="version" value="<%=version%>">
							<input type="hidden" name="rowflg" value="<%=rowflg%>">
                          </div></td>
						<td align="right">
						  <input type="submit" name="Submit" value="Search">
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
                  <td width="14%">Article No.</td>
                  <td width="29%">Article Description</td>
                  <td width="15%">List Price</td>
                </tr>
				<%
				y = 0
				While Not rs.eof
					y = y + 1
					If y>=StartPage And y<EndPage Then 
				%>
					 <tr class="line02"> 
					  <td><input type="radio" value="on" onclick="confirmconfiguration('<%=rs("cid")%>', '<%=rs("materialno")%>', '<%=rs("description")%>', '<%=Round(rs("listprice"))%>')"></td>
					  <td><%=rs("materialno")%></td>
					  <td><%=rs("description")%></td>
					  <td><%=Round(rs("listprice"))%></td>
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
<!--#include file="../include/commons.asp"-->
</div>
</body>
</html>
