<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/commons.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../include/sendMail2.asp"-->
<!--#include file="quotationVar.asp"-->
<!--#include file="quotationUtils.asp"-->

<% 
	dim rs
	dim strSql
	dim roleid
	Dim sbu
	roleid=session("roleid")
	sbu=request("bu")
	szone=request("zone")
	spStatus=request("spStatus")
	'是否显示bu
	isshowbu=false
	'pricing，market direct，ceo，cfo，fc
	If roleid="1" Or roleid="3" Or roleid="4" Or roleid="6" Or roleid="11" Or roleid="12" Or roleid="14" Or roleid="5" Or roleid="8" Then
		isshowbu=true
	End If
	strSql="select a.*,c.status spstatuc,b.username crtusername,(select username from userinfo where id=a.updtuser) updtusername from quotation a left join special_price c on c.quotationno=a.quotationno left join userinfo b on a.crtuser=b.id  where (a.status=3) "   '2:已删除

	if quotationNO<>""  then
		strSql=strSql &" and  a.quotationNO like '%"&Trim(quotationNO) & "%'"
	end if
	if  hospName<>"" then
		strSql=strSql & " and ( a.username like '%"& porcSpecWord(Trim(hospName)) &"%' or a.nonusername like '%"& porcSpecWord(Trim(hospName)) &"%')"
	end if
	if productName<>""  then
		strSql=strSql & " and exists(select * from quotation_detail where qid=a.qid and productname like '%"&Trim(productName)&"%')"
	end If
	If Not IsNull(sbu) And sbu<>"" Then
		strsql=strsql & " and exists(select * from quotation_detail where bu="&sbu&" and qid=a.qid)" 
	End If 
	If Not IsNull(szone) And szone<>"" Then
		strSql=strSql& " and a.crtuser in(select distinct userid from user_zonerel where zoneid in("&szone&"))"
	End If 
	if beginDate<>""  then
		strSql=strSql & " and convert(datetime,substring(a.crttime,1,8))>=convert(datetime,'"& beginDate &"')"
	end if
	if endDate<>""  then
		strSql=strSql & " and convert(datetime,substring(a.crttime,1,8))<=convert(datetime, '"& endDate &"')"
	end if
	if roleid="7" or roleid="9" then
		strSql=StrSql & " and a.crtuser='"&session("principleid")&"'"
	end If
	'If shStatus<>"" And Not IsNull(shStatus) Then
		'strSql=StrSql & " and a.status='"&shStatus&"'"
	'End If 
	if roleid<>"7" And  roleid<>"9" Then
		If IsNull(session("user_bu")) Or IsEmpty(session("user_bu")) Or session("user_bu")="" Then
			
		Else
			strSql=strSql & "  and exists (select * from quotation_detail where qid=a.qid and bu='"&session("user_bu")&"')"
		End If
		If IsNull(session("zoneidcontract")) Or IsEmpty(session("zoneidcontract")) Or session("zoneidcontract")="" Then
			
		Else
			strSql=strSql& " and a.crtuser in(select distinct userid from user_zonerel where zoneid in("&session("zoneidcontract")&"))"
		End if
	End If
	If spStatus<>"" And Not IsNull(spStatus) Then
		If spStatus="1" Then
			strSql=strSql& " and (c.status=0 or c.status is null) "
		ElseIf spStatus="2" Then
			strSql=strSql& " and (c.status>0 and c.status is not null) "
		ElseIf spStatus="3" Then
			strSql=strSql& " and (c.status<0 and c.status is not null) "
		End If 
	End if
	
	strSql=strSql & " order by a.crttime desc"
	set rs=server.createObject("adodb.recordset")
	'response.Write(strSql)
	'response.End()
	rs.open strSql,conn,3,3


	'查询zone列表
	Set rs_zone=conn.execute("select * from zone")
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
		f.action="appliedList.asp";
		f.submit();
	}
	function detail(id)
	{
		var f=document.forms[0];
		f.action="quotationDetail.asp?qid="+id;
		f.submit();
	}
</script>

</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0">
<form method="post" action="quotationList.asp">
<div align="center">
  <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
   <tr> 
      <td>&nbsp;</td>
    </tr>
     <tr> 
      <td><table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td class="titleorange"><div align="center">Applied OIT Quotation List </div></td>
          </tr>
          <tr> 
            <td class="titleorange">&nbsp;</td>
          </tr>
          <tr> 
            <td valign="top" class="line01"> <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
                <tr> 
                  <td><table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                      <tr class="line01"> 
                        <td width="15%"> <div align="left">Quotation No:<br>
                              报价文件号：<br>
                          </div></td>
                        <td width="20%"> <div align="left"> 
                            <input type="text" name="quotationNO" value="<%=quotationNO %>">
                          </div></td>
                        <td width="25%"> <div align="left">Final User (Hospital) Name:<br>
                              最终用户名称（医院）：</div></td>
                        <td width="20%"> <div align="left"> 
                            <input type="text" name="hospName" value="<%=hospName %>">
                          </div></td>
						  <% If isshowbu then%>
						    <td width="10%"> <div align="left">BU:<br>
                              BU:</div></td>
                        <td width="10%"> <div align="left"> 
							<select name="bu" id="bu">
								<option value="">请选择</option>
								<%
									for i=1 to ubound (BU_TYPE)
								%>
								 <option value="<%=BU_TYPE(i,0)%>"><%=BU_TYPE(i,1)%></option>
								<%
									next
								%>
							</select>
                          </div></td>
						<% End If %>
                      </tr>
					     <tr class="line01"> 
                        <td height="25"><div align="left">Submit Date:<br>提交日期：
                            </div></td>
                        <td  ><div align="left"> 
                            <input type="text" name="beginDate" readonly="true" size="10"  value="<%=beginDate %>" onClick="WdatePicker()">
							-  <input type="text" name="endDate" readonly="true" size="10"  value="<%=endDate %>" onClick="WdatePicker()">
                          </div></td>
                        <td height="25"> <div align="left">Product Name:<br>
                              产品名称：</div></td>
                        <td > <div align="left"> 
                            <input type="text" name="productName"  value="<%=productName %>">
                          </div></td>
						    <% If isshowbu then%>
					 <td height="25" nowrap> <div align="left">Area:<br>
                              区域：</div></td>
                        <td > <div align="left"> 
                           <select name="zone" id="zone">
								<option value="">请选择</option>
								<%
									While Not rs_zone.eof 
								%>
								 <option value="<%=rs_zone("zid")%>"><%=rs_zone("zonename")%></option>
								<%
									 rs_zone.movenext
									wend
								%>
							</select>
                          </div></td>
						<% End If %>
                      </tr>
					    <tr class="line01"> 
						 <td width="15%"> <div align="left">Special Price Status:<br>
                              特价申请状态：</div></td>
                        <td width="20%"> <div align="left"> 
                           <select name="spStatus" id="spStatus" style="width:200px">
								<option value="">请选择</option>
								<option value="1">No Special Price Application</option>
								<option value="2">Special Price Approved</option>
								<option value="3">Special Price Rejected</option>
						   </select>
                          </div></td>

                        <td width="15%"> 
						<!--
						<div align="left">Quotation Status:<br>
                              报价单状态：<br>
                          </div>
						  -->
						  </td>
                        <td width="20%"> 
						<!--
						<div align="left"> 
                           <select name="shStatus" id="shStatus" style="width:170px">
								<option value="">请选择</option>
								
								<option value="4">Wait DM to Check</option>
								<option value="0">New</option>
								<option value="5">Applying Special Price</option>
								<option value="-1">Special Price Rejected</option>
								<option value="11">Special Price Approved</option>
								
								<option value="3">Applied OIT</option>
								<option value="13">Closed</option>
						   </select>
                          </div>
						 -->
						  </td>
                       
						  <% If isshowbu then%>
						    <td width="10%"> <div align="left">&nbsp;</div></td>
                        <td width="10%"> <div align="left"> 
							&nbsp;
                          </div></td>
						<% End If %>
                      </tr>
                    </table></td>
                </tr>
              </table>
              <p align="right"> 
                <input type="button" name="Submit" value="Search" onClick="queryList()">
		<!--
				 <input type="button" name="Submit" value="WaitFor" onClick="testWait();">   -->
				&nbsp;&nbsp;
				<% if roleid="7" or roleid="9" then %>
				 <input type="button" name="Submit" value="Add New" onClick="add();">
				 <% end if%>
              </p></td>
          </tr>
          <tr> 
            <td class="line02">&nbsp; </td>
          </tr>
          <tr> 
            <td><table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" style="word-break:normal">
                <tr class="line01"> 
                 <!-- <td width="8%">Items</td>  -->
                  <td  nowrap>Quotation No</td>
                  <td  nowrap>Final User (Hospital) Name</td>
				   <td  nowrap>Create By</td>
				    <td  nowrap>Update By</td>
					 <td   nowrap>Update Time</td>
                  <td nowrap>Status</td>
				   <td nowrap> Special Price Status</td>
                  <td   nowrap>Operation</td>
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
                 <!-- <td><%=i%> <br> </td> -->
                  <td nowrap><%=rs("quotationno")%>&nbsp;</td>
                  <td> 
				  <% If  Not IsNull(rs("username")) And rs("username")<>"" Then
						response.write(rs("username"))
					Else
						response.write(rs("nonusername"))
				  End if
				  %>
				&nbsp;</td>
				  <td nowrap> <%=rs("crtusername")%>&nbsp;</td>
				  <td nowrap> <%=rs("updtusername")%>&nbsp;</td>
				<td nowrap> <%=displaytime2(rs("updttime"))%>&nbsp;</td>
				 <td nowrap  ><font color="#FF0000">
				 <%= quotationstatus(rs("STATUS")) %> 
				</font> &nbsp;</td>
				 <td nowrap  ><font color="#FF0000">
				 <%= specialstatus(rs("spstatuc")) %> 
				</font> &nbsp;</td>
				 <td valign="middle" nowrap><a href="#" onClick="detail('<%=rs("qid")%>');">Details</a> &nbsp;&nbsp;
				</td>
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
    document.forms[0].action="appliedList.asp?page="+str;
    document.forms[0].submit();	
 }
  <% If isshowbu then%>
 <% if not isnull(sbu) and sbu<>"" then %>
	$("#bu").val('<%=sbu%>');
 <% end if %>
 <% if not isnull(szone) and szone<>"" then %>
	$("#zone").val('<%=szone%>');
 <% end if %>
  <% end if %>
 <% if not isnull(shStatus) and shStatus<>"" then %>
	$("#shStatus").val('<%=shStatus%>');
 <% end if %>
  <% if not isnull(spStatus) and spStatus<>"" then %>
	$("#spStatus").val('<%=spStatus%>');
 <% end if %>
</script>
</form>
</body>
</html>
<%
	rs.close
	set rs=Nothing
	rs_zone.close
	Set rs_zone=Nothing 
	CloseDatabase
%>
