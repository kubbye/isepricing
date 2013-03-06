<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/commons.asp"-->

<%
Page=request("Page")
bu = request("bu")
product = request("product")

sql = "select * from product_maintain where state='0'"
If bu <> "" Then
	sql = sql & " and bu like '%" & bu & "%'"
End If 
If product <> "" Then
	sql = sql & " and product like '%" & product & "%'"
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

URLCS = "bu=" & bu & "&product=" & product

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
    
    document.form1.action="product_search.asp?<%=URLCS%>&Page="+str;
    document.form1.submit();
 }

 function deleteproduct(pmid){
	if (confirm("Confirm to delete product?")){
		document.form1.action="product_delete.asp?pmid=" + pmid;
		document.form1.submit();
	}
 }
</script>
</head>

<body bgcolor="#ffffff" leftmargin="0" topmargin="0">
<div align="center">
  <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td><table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td class="titleorange"><div align="center">Product List</div></td>
          </tr>
          <tr> 
            <td class="titleorange">&nbsp;</td>
          </tr>
          <tr> 
            <td valign="top" class="line01"> <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
                <tr> 
                  <td>
				  <form name="form1" action="product_search.asp" method="post">
				  <table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                      <tr class="line01"> 
                        <td width="25%" height="25"> <div align="left">BU:</div></td>
                        <td width="25%"> <div align="left"> 
                            <input type="text" name="bu" value="<%=bu%>">
                          </div></td>
                        <td width="25%"> <div align="left">Product:</div></td>
                        <td width="25%"> <div align="left"> 
                            <input type="text" name="product" value="<%=product%>">
                          </div></td>
                      </tr>
					  <tr>
					    <td colspan="4" align="right">
						  <input type="submit" name="Submit" value="Search">&nbsp;&nbsp;&nbsp;
						  <input type="button" value="&nbsp;New&nbsp;" onclick="location.href='product_add.asp'">
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
                  <td>BU</td>
                  <td>Product</td>
				  <td>Operation</td>
                </tr>
				<%
				y = 0
				While Not rs.eof
					y = y + 1
					If y>=StartPage And y<EndPage Then 
				%>
					<tr class="line02">
					  <td><%=rs("bu")%></td>
					  <td><%=rs("product")%></td>
					  <td><input type="button" value="Delete" onclick="deleteproduct('<%=rs("pmid")%>');" /></td>
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
