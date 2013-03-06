<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/commons.asp"-->

<%
Page=request("Page")
bu = request("bu")
modality = request("modality")

sql = "select * from modality where status='0'"
If bu <> "" Then
	sql = sql & " and bu=" & bu
End If 
If modality <> "" Then
	sql = sql & " and modality like '%" & modality & "%'"
End If 

Set rs = conn.execute(sql)

count=0
While Not rs.eof
  count=count+1
  rs.movenext
Wend 

'分页
if page="" or isEmpty(page) then 
    Page=1
End if
PageSize=10 '每页数量
if PageSize=0 then 
    PageSize=1
End if
PageCount=int((count-1)/PageSize)+1
if PageCount=0 then 
    Page=0
End if
Page=int(Page)
Startpage=(Page-1)*PageSize+1
EndPage=Startpage+PageSize

URLCS = "bu=" & bu & "&modality=" & modality

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
    
    document.form1.action="modality_search.asp?<%=URLCS%>&Page="+str;
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
            <td class="titleorange"><div align="center">Modality List</div></td>
          </tr>
          <tr> 
            <td class="titleorange">&nbsp;</td>
          </tr>
          <tr> 
            <td valign="top" class="line01"> <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
                <tr> 
                  <td>
				  <form name="form1" action="modality_search.asp" method="post">
				  <table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                      <tr class="line01"> 
                        <td width="25%" height="25"> <div align="left">BU:</div></td>
                        <td width="25%"> <div align="left"> 
                            <select name="bu">
                              <%
							  For i = 0 To UBound(BU_TYPE)
							  %>
							  <option VALUE="<%=BU_TYPE(i,0)%>" <%If bu = CStr(BU_TYPE(i,0)) Then %> selected <%End If %>><%=BU_TYPE(i,1)%></option>
							  <%
							  Next 
							  %>
                            </select>
                          </div></td>
                        <td width="25%"> <div align="left">Modality:</div></td>
                        <td width="25%"> <div align="left"> 
                            <input type="text" name="modality" value="<%=modality%>">
                          </div></td>
                      </tr>
					  <tr>
					    <td colspan="4" align="right">
						  <input type="submit" name="Submit" value="Search">&nbsp;&nbsp;&nbsp;
						  <%
						  If session("roleid") = 5 Then 
						  %>
						  <input type="button" value="&nbsp;New&nbsp;" onclick="location.href='modality_add.asp'">
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
                  <td width="21%">BU</td>
                  <td width="26%">Modality</td>
				  <td>Inst.%</td>
				  <td>Warr.%</td>
				  <td>Standard App Training(USD)</td>
				  <td>Standard App Training(RMB)</td>
				  <%
				  If session("roleid") = 5 Then 
				  %>
				  <td>Operation</td>
				  <%
				  End If 
				  %>
                </tr>
				<%
				y = 0
				While Not rs.eof
					y = y + 1
					If y>=StartPage And y<EndPage Then 
				%>
					<tr class="line02">
					  <td><%=BU_TYPE(rs("bu"), 1)%></td>
					  <td><%=rs("modality")%></td>
					  <td><%=rs("inst")%></td>
					  <td><%=rs("warr")%></td>
					  <td><%=Round(rs("apptraining"))%>&nbsp;</td>
					  <td><%=Round(rs("apptrainingrmb"))%>&nbsp;</td>
					  <%
					  If session("roleid") = 5 Then 
					  %>
					  <td><input type="button" value="Edit" onclick="location.href='modality_edit.asp?mid=<%=rs("mid")%>'" /></td>
					  <%
					  End If 
					  %>
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
					Record Count:<%=Count%>&nbsp;&nbsp;Page:<%=Page%>/<%=PageCount%>
				  </td>
				  <td noWrap align="middle" width="70%">
					First Page&nbsp;
					<A href="javascript:PageTo('1')">|&lt;&lt;</A>
					&nbsp;&nbsp; 
					<A href="javascript:PageTo('<%=Page-1%>')">&lt;&lt;</A>
					&nbsp;&nbsp; 
					<A href="javascript:PageTo('<%=Page+1%>')">&gt;&gt;</A>
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
