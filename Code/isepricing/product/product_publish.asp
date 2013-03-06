<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../include/commons.asp"-->
<!--#include file="../include/chkUser.asp"-->

<%
Page=request("Page")
bu = request("bu")

sql = "select b.modality, a.productname, a.standardprice, c.standardprice laststandardprice, a.version from product a inner join modality b on a.mid=b.mid left join product c on a.productname=c.productname and c.state='0' and c.status='0' where  a.state='0' and b.status='0' and a.status='8'"
If bu <> "" Then
	sql = sql & " and b.bu=" & bu
End If 
sql = sql & " order by b.bu, b.modality, a.standardprice"
Set rs = conn.execute(sql)

st = "1"
For i = 1 To UBound(BU_TYPE)
	sqlstr = "select * from product a, modality b where a.mid=b.mid and a.state='0' and b.status='0' and a.status='8' and b.bu=" & BU_TYPE(i, 0)
	Set rs2 = conn.execute(sqlstr)
	If rs2.eof Then
		st = "0"
	End If 
Next 

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

URLCS = "bu=" & bu

Set rs = conn.execute(sql)

%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title>IS E-pricing system</title>
<link href="../css/css.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="../js/jquery-1.2.6.js"></script>
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
    
    document.form1.action="product_publish.asp?<%=URLCS%>&Page="+str;
    document.form1.submit();
}

function onpublish(){
	if (confirm("Do you confirm to publish the Price Guideline?")){
		document.form1.action="product_publish_submit.asp";
		document.form1.submit();
	}
}

function oncheck3rd(){
	document.form1.action = "product_publish_check3rd.asp";
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
            <td class="titleorange"><div align="center">Product List</div></td>
          </tr>
          <tr> 
            <td class="titleorange">&nbsp;</td>
          </tr>
          <tr> 
            <td valign="top" class="line01">
			  <form name="form1" method="post" action="product_publish.asp">
			  <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
                <tr> 
                  <td>
				    <table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                      <tr class="line01"> 
                        <td width="25%" height="25"> <div align="left">BU:
                            <br>
                          </div></td>
                        <td width="25%"> <div align="left"> 
                            <select name="bu">
							  <option value=""></option>
                              <%
							  For i = 1 To UBound(BU_TYPE)
							  %>
							  <option VALUE="<%=BU_TYPE(i,0)%>" <%If CStr(bu) = CStr(BU_TYPE(i,0)) Then %> selected <%End If %>><%=BU_TYPE(i,1)%></option>
							  <%
							  Next 
							  %>
                            </select>
                          </div></td>
                        <td width="25%"> <div align="left">&nbsp; </div></td>
                        <td width="25%"><div align="left"> 
                            &nbsp;
                          </div></td>
                      </tr>
                    </table></td>
                </tr>
              </table>
              <p align="right"> 
                <input type="submit" name="Submit" value="Search">&nbsp;&nbsp;
                <input type="button" name="check3rd" value="Check 3rd" onclick="oncheck3rd();">&nbsp;&nbsp;
				<%
				If st = "1" Then 
				%>
					<input type="button" name="publish" value="Publish" onclick="onpublish();">
				<%
				End If 
				%>
              </p>
			  </form>
			</td>
          </tr>
          <tr> 
            <td class="line02">&nbsp; </td>
          </tr>
          <tr> 
            <td><table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td>Version</td>
                  <td>Modality</td>
                  <td>Product</td>
                  <td>Last Standard Net Target Price</td>
                  <td>Standard Net Target Price</td>
                </tr>
				<%
				y = 0
				While Not rs.eof
					y = y + 1
					If y>=StartPage And y<EndPage Then
				%>
					<tr class="line02">
					  <td><%=rs("version")%></td>
					  <td><%=rs("modality")%></td>
					  <td><%=rs("productname")%></td>
					  <td><%=rs("laststandardprice")%>&nbsp;</td>
					  <td><%=rs("standardprice")%>&nbsp;</td>
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
