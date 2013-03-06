<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../include/commons.asp"-->
<!--#include file="../include/chkUser.asp"-->
<%
thispage = request("thispage")
materialno = request("materialno")

sql = "select * from configurations where status!='2'"

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

URLCS = "materialno=" & materialno

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
    
    document.form1.action="configuration_search.asp?<%=URLCS%>&thispage="+str;
    document.form1.submit();
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
            <td class="titleorange"><div align="center">Search Configurations</div></td>
          </tr>
          <tr> 
            <td class="titleorange">&nbsp;</td>
          </tr>
          <tr> 
            <td valign="top" class="line01"> <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
                <tr> 
                  <td>
				    <form name="form1" action="configuration_search.asp" method="post">
				    <table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                      <tr class="line01"> 
                        <td height="25"> <div align="left">Article No.</div></td>
                        <td> <div align="left"> 
                            <input type="text" name="materialno" value="<%=materialno%>">
                          </div></td>
						<td align="right">
						  <input type="submit" name="Submit" value="Search">&nbsp;&nbsp;
						  <%
						  If session("roleid") = "1" Then 
						  %>
						  <input type="button" name="Submit2" value="Add New" onclick="location.href='configuration_add.asp'">
						  <%
						  End If 
						  %>
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
                  <td width="14%">Version</td>
                  <td width="14%">Article No.</td>
                  <td width="29%">Article Description</td>
                  <td width="15%">List Price</td>
                  <td width="12%">CTP</td>
                  <td width="13%">Status</td>
                  <td>Operation</td>
                </tr>
				<%
				y = 0
				While Not rs.eof
					y = y + 1
					If y>=StartPage And y<EndPage Then 
				%>
					 <tr class="line02"> 
					  <td><%=rs("version")%></td>
					  <td><%=rs("materialno")%></td>
					  <td><%=rs("description")%></td>
					  <td><%=Round(rs("listprice"))%></td>
					  <td><%=Round(rs("wrp"))%></td>
					  <td><%=CONFIGURATION_STATUS_DISPLAY(rs("status"))%></td>
					  <td>&nbsp;
					    <%
						If session("roleid") = "1" And rs("status") <> "2" Then 
						%>
						<input type="button" value=" Edit " onclick="location.href='configuration_edit.asp?cid=<%=rs("cid")%>'">
						<%
						End If 
						%>
					  </td>
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
					&nbsp;Last Page 
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
