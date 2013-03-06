<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/commons.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../quotation/quotationVar.asp"-->

<% 
	dim rs
	dim strSql
	dim roleid
	roleid=session("roleid")
	strSql="select a.*,(select count(distinct bu) from quotation_detail where qid=a.qid)productmodel,b.username crtusername,c.username updtusername,(select isnull(sum(part1),0)+isnull(sum(adjustprice),0) from quotation_detail where qid=a.qid ) standardprice  from quotation a left join userinfo b on a.crtuser=b.id left join userinfo c on a.crtuser=c.id where status=0 and qid not in(select quotationid from special_price)"   '2:已删除

	if quotationNO<>""  then
		strSql=strSql &" and  a.quotationNO like '%"& Trim(quotationNO) & "%'"
	end if
	if  hospName<>"" then
		strSql=strSql & " and  (a.username like '%"& Trim(hospName) &"%' or a.nonusername like '%"& Trim(hospName) &"%')"
	end if
	if productName<>""  then
		strSql=strSql & " and exists(select * from quotation_detail where qid=a.qid and productname like '%"&productName&"%')"
	end if
	if beginDate<>""  then
		strSql=strSql & " and convert(datetime,substring(a.crttime,1,8))>=convert(datetime,'"& beginDate &"')"
	end if
	if endDate<>""  then
		strSql=strSql & " and convert(datetime,substring(a.crttime,1,8))<=convert(datetime, '"& endDate &"')"
	end if
	if roleid="7" or roleid="9" then
		strSql=StrSql & " and a.crtuser='"&session("principleid")&"'"
	end If
	if roleid<>"7" And  roleid<>"9" Then
		If IsNull(session("user_bu")) Or IsEmpty(session("user_bu")) Or session("user_bu")="" Then
			
		Else
			strSql=strSql & "  and exists (select * from quotation_detail where qid=a.qid and bu='"&session("user_bu")&"')"
		End If
		If IsNull(session("zoneidcontract")) Or IsEmpty(session("zoneidcontract")) Or session("zoneidcontract")="" Then
			
		Else
			strSql=strSql& " and a.crtuser in(select distinct userid from user_zonerel where zoneid in("&session("zoneidcontract")&"))"
		End if
	End if
	
	strSql=strSql & " order by a.crttime desc"
	set rs=server.createObject("adodb.recordset")
	'response.Write(strSql)
	'response.End()
	rs.open strSql,conn,3,3

	page=request("page")
	if page="" then
		page=0
	end if
	if page<>"" then
		if not isnumeric(page) then
%>
		  <script language="JavaScript">
				alert("页数请输入数字");
				history.go(-1);
			</script>
 <%
			response.end()
		else
			page=cint(page)
		end if
	else
			page=cint(page)
	end if


	%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title></title>
<LINK href="../css/css.css" type=text/css rel=stylesheet>
<script type="text/javascript" src="../js/My97DatePicker/WdatePicker.js" ></script>
<script type="text/javascript" src="../js/ut.js"></script>
<script type="text/javascript" src="../js/jquery-1.2.6.js"></script>
<script language="javascript">
	function queryList()
	{
		var f=document.forms[0];
		f.action="quotationSelect.asp";
		f.submit();
	}
	function detail(id)
	{
		var f=document.forms[0];
		f.action="../quotation/quotationDetail.asp?qid="+id+"&rtype=2";
		f.submit();
	}
	function selectOpt(quotationid,quotationno,tenderno,cuurencycode,oitprice,standardprice,finalusername,nonusername,businessmodel,paymentterm,spec_paymentterm,productmodel)
	{
		var username;
		username=finalusername;
		if(username==null || username==''){
			username=nonusername;
		}
		window.opener.doSelect(quotationid,quotationno,tenderno,cuurencycode,oitprice,standardprice,username,businessmodel,paymentterm,spec_paymentterm,productmodel);
		window.close();
	}
</script>

</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0">
<form method="post" action="quotationSelect.asp">
<div align="center">
  <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
   <tr> 
      <td>&nbsp;</td>
    </tr>
     <tr> 
      <td><table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td class="titleorange"><div align="center">Quotation List </div></td>
          </tr>
          <tr> 
            <td class="titleorange">&nbsp;</td>
          </tr>
          <tr> 
            <td valign="top" class="line01"> <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
                <tr> 
                  <td><table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                      <tr class="line01"> 
                        <td> <div align="left">Quotation No:<br>报价文件号:<br>
                          </div></td>
                        <td> <div align="left"> 
                            <input type="text" name="quotationNO" value="<%=quotationNO %>">
                          </div></td>
                        <td> <div align="left">Final User (Hospital) Name:<br>最终用户名称（医院）:</div></td>
                        <td> <div align="left"> 
                            <input type="text" name="hospName" value="<%=hospName %>">
                          </div></td>
                      </tr>
					     <tr class="line01"> 
                        <td width="25%" height="25"><div align="left">Submit Date :<br>提交日期：
                            </div></td>
                        <td width="25%" ><div align="left"> 
                            <input type="text" name="beginDate" readonly="true" size="10"  value="<%=beginDate %>" onClick="WdatePicker()">
							-  <input type="text" name="endDate" readonly="true" size="10"  value="<%=endDate %>" onClick="WdatePicker()">
                          </div></td>
                        <td height="25"> <div align="left">Product Name：<br>产品名称：</div></td>
                        <td > <div align="left"> 
                            <input type="text" name="productName"  value="<%=productName %>">
                          </div></td>
                      </tr>
                    </table></td>
                </tr>
              </table>
              <p align="right"> 
                <input type="submit" name="Submit" value="Search" onClick="queryList()">
              </p></td>
          </tr>
          <tr> 
            <td class="line02">&nbsp; </td>
          </tr>
          <tr> 
            <td><table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" style="word-break:break-all">
                <tr class="line01"> 
                  <td width="8%">Select</td>  
                  <td width="10%">Quotation No</td>
                  <td width="20%" nowrap>Final User (Hospital) Name</td>
				   <td width="10%">Create By</td>
				    <td width="10%">Update By</td>
					 <td width="10%">Update Time</td>
                  <td width="5%">Detail</td>
                </tr>
			<%
				If rs.bof  and   rs.eof then
			%>

                  <TR class="line02" >
                    <td colspan="11" align="center"> no record</td>
                  </tr>
                  <%
		else
			rs.pagesize=CONS_PAGESIZE
			if page<=0 then page=1 end if
			if page >rs.pagecount then page=rs.pagecount end If
			rs.absolutepage=page
			
			for i=1 to rs.pagesize 
			
			
		%>
                <tr class="line02"> 
                  <td><input type="radio" name="selQuot"        onclick="selectOpt('<%=rs("qid")%>','<%=rs("quotationno")%>','<%=porcSpecWordHtml(rs("tenderno"))%>','<%=rs("currencycode")%>','<%=rs("targetprice")%>','<%=rs("standardprice")%>','<%=porcSpecWordHtml(rs("username"))%>','<%=porcSpecWordHtml(rs("nonusername"))%>','<%=rs("businessmodel")%>','<%=rs("paymentterm")%>','<%=porcSpecWordHtml(rs("sepc_parmentterm"))%>','<%=rs("productmodel")%>');"> </td>
                  <td><%=rs("quotationno")%>&nbsp;</td>
                  <td> 
				  <% If  Not IsNull(rs("username")) And rs("username")<>"" Then
						response.write(rs("username"))
					Else
						response.write(rs("nonusername"))
				  End if
				  %>
				&nbsp;</td>
				  <td> <%=rs("crtusername")%>&nbsp;</td>
				  <td> <%=rs("updtusername")%>&nbsp;</td>
				<td nowrap> <%=displaytime2(rs("updttime"))%>&nbsp;</td>
				 <td valign="middle" nowrap><a href="#" onClick="detail('<%=rs("qid")%>');">Details</a> &nbsp;</td>
                </tr>
          <%
		  	rs.movenext
			 if rs.eof then exit for end if
		  	next
			end if
		  %>
                
              </table></td>
          </tr>
		  
		  <tr>
		<td>
        <TABLE height="34" cellSpacing="0" cellPadding="0" width="100%" background='../images/bg_bt.gif' border="0" class="table01">
            <TR class="line01">
              <TD align=right>Record Count:<%=rs.recordcount%> &nbsp;&nbsp;
			  Page:<%=page%>/<%=rs.pagecount%></TD>
              <TD noWrap align=middle width="70%"> First Page
			  &nbsp; <A href="javascript:PageTo('1')">|&lt;&lt;</A> &nbsp;&nbsp;
			   <A href="javascript:PageTo('<%=page-1%>')">&lt;&lt;</A>
			   &nbsp;&nbsp; <A href="javascript:PageTo('<%=page+1%>')">&gt;&gt;</A> 
			   &nbsp;&nbsp; <A href="javascript:PageTo('<%=rs.pagecount%>')">&gt;&gt;|</A> &nbsp;&nbsp;Last Page </TD>
            </TR>
        </TABLE>
      </TD>
    </TR>
	
        </table></td>
    </tr>
  </table>
  <!--#include file="../footer.asp"-->
</div>
<script>
	function PageTo(str) {
	if (parseInt(str) > <%=rs.pagecount%>)
	{
		alert ("This page is the last one!")
		return;
	}

	if (parseInt(str) < 1)
	{
		alert ("This page is the first one!")
		return;
	}
    document.forms[0].action="quotationSelect.asp?page="+str;
    document.forms[0].submit();	
 }
</script>
</form>
</body>
</html>
<%
	rs.close
	set rs=nothing
	CloseDatabase
%>
