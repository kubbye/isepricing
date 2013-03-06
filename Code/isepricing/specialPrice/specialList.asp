<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/commons.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="specialUtils.asp"-->
<% 
	'状态：
	'-1.审批不通过
	'0，新建；
	'1，维护产品已保存；
	'2，待Sales Director审批；
	'3，待PM审批；
	'-3,Sales Director审批不通过
	'-4,PM审批不通过
	'-5,FC审批不通过
	'-6,Marketing Director审批不通过
	'4，待FC审批，
	'5，待Marketing Director 审批，
	'6。待FC 审批，
	'11，审批完成。
	dim rs
	dim strSql
	dim roleid
	roleid=session("roleid")
	'查询条件
	quotationNO=request("quotationNO")
	hospName=request("hospName")
	beginDate=request("beginDate")
	endDate=request("endDate")
	sbu=request("bu")
	szone=request("zone")
	isApplyForOIT=request("isApplyForOIT")
	shStatus=request("shStatus")
	If isApplyForOIT="" Or IsNull(isApplyForOIT) Then
		isApplyForOIT="0"
	End If 
	'是否显示bu
	isshowbu=false
	'pricing，market direct，ceo，cfo，fc
	If roleid="1" Or roleid="3" Or roleid="4" Or roleid="6" Or roleid="11" Or roleid="12" Or roleid="14" Or roleid="5" Or roleid="8" Then
		isshowbu=true
	End If
	strSql="select a.*,b.username crtusername,(select username from userinfo where id=a.updtuser) updtusername from special_price a left join userinfo b on a.crtuser=b.id where 1=1"   
	
	
	If Not IsNull(quotationNO) And  quotationNO<>"" Then
		strSql=strSql & " and a.quotationNO like '%"&Trim(quotationNO)&"%'"
	End If
	If Not IsNull(hospName) And  hospName<>"" Then
		strSql=strSql & " and a.username like '%"& porcSpecWord(Trim(hospName))&"%'"
	End If
	If Not IsNull(sbu) And sbu<>"" Then
		strsql=strsql & " and exists(select * from quotation_detail where bu="&sbu&" and qid=a.quotationid)" 
	End If 
	If Not IsNull(szone) And szone<>"" Then
		strSql=strSql& " and a.crtuser in(select distinct userid from user_zonerel where zoneid in("&szone&"))"
	End If 
	If Not IsNull(beginDate) And  beginDate<>"" Then
		strSql=strSql & " and convert(datetime,substring(a.crttime,1,8))>=convert(datetime, '"&beginDate&"')"
	End If
	If Not IsNull(endDate) And  endDate<>"" Then
		strSql=strSql & "and convert(datetime,substring(a.crttime,1,8))<=convert(datetime, '"&endDate&"')"
	End If
	If isApplyForOIT="0" Then
		strSql=strSql & " and a.quotationno not in(select quotationno from quotation where status=3)"
	Else
		strSql=strSql & " and a.quotationno  in(select quotationno from quotation where status=3)"
	End If 
	If shStatus<>"" And Not IsNull(shStatus) Then
		If shStatus="-1" Then
			strSql=strSql & " and (a.status<0 and a.status>-11 and a.status!=-2 and a.status!=-9 and ispending=0)"
		ElseIf shStatus="0" Then
			strSql=strSql & " and (a.status=0 and a.status!=-9 and ispending=0)"
		ElseIf shStatus="2" Then
			strSql=strSql & " and (a.status=2   and a.ispending=0 and a.isAdditional=0)"
		ElseIf shStatus="3" Then
			strSql=strSql & " and (a.status=3  and a.productmodel=1 and a.ispending=0 and a.isAdditional=0)"
		ElseIf shStatus="4" Then
			strSql=strSql & " and ((a.status=4 and a.productmodel=1 and a.ispending=0 and a.isAdditional=0) or ((a.status=3 or a.status=6) and a.productmodel=2 and a.ispending=0 and a.isAdditional=0))"
		ElseIf shStatus="5" Then
			strSql=strSql & " and ((a.status=5 and a.productmodel=2 and a.ispending=0 and a.isAdditional=0) or (a.status=3 and a.productmodel=2 and a.ispending=0 and a.isAdditional=0))"
		ElseIf shStatus="11" Then
			strSql=strSql & " and (a.status=11 and a.ispending=0 and a.isAdditional=0)"
		ElseIf shStatus="-11" Then
			strSql=strSql & " and (a.status=-11 )"
		ElseIf shStatus="-2" Then
			strSql=strSql & " and (a.status=-2 or a.ispending<>0)"
		ElseIf shStatus="-9" Then
			strSql=strSql & " and (a.status=-9 and a.ispending=0)"
		ElseIf shStatus="shaddtion" Then  
			strSql=strSql & " and a.isAdditional=1 and a.ispending=0"
		Else 
			strSql=strSql & " and a.status="&shStatus
		End If 
	End If 

	if roleid="7" or roleid="9" then
		strSql=StrSql & " and a.crtuser='"&session("principleid")&"'"
	end If
	if roleid<>"7" And  roleid<>"9" Then
		If IsNull(session("user_bu")) Or IsEmpty(session("user_bu")) Or session("user_bu")="" Then
			
		Else
			strSql=strSql & "  and exists (select * from quotation_detail where qid=a.quotationid and bu='"&session("user_bu")&"')"
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
	function add()
	{
		var f=document.forms[0];
		f.action="Special_Price.asp";
		f.submit();
	}
	function queryList()
	{
		var f=document.forms[0];
		f.action="specialList.asp";
		f.submit();
	}
	function approveSpecial(sid)
	{
		location.href="Special_Price_approve.asp?sid="+sid;
	}
	function toDetail(sid)
	{
		location.href="Special_Price_approve.asp?type=viewDetail&sid="+sid;
	}
	function toEdit(sid)
	{
		var f=document.forms[0];
		f.action="Special_Price.asp?d=<%=now%>&sid="+sid;
		f.submit();
	}
	//提交时需要验证价格，主要是应对从来没有提交过又去编辑了quotation的数据
	function doSubmit(sid,statusid,nowstatus,isneedmsg)
	{
		var f=document.forms[0];
		if(1==isneedmsg){
			if(!confirm('您是否确认不需要编辑特价就直接提交？')){
				return;
			}
		}else{
			if(!confirm('确定提交该特价申请？')){
				return ;
			}
		}
		if (nowstatus<0)
		{
			alert('请填写再次提交申请的理由！');
			location.href='resubmitRemark.asp?sid='+sid+"&statusid="+statusid;
			return false;
		}
		f.action="specialSubmit.asp?sid="+sid+"&statusid="+statusid;
		f.submit();
	}
	function Additional(sid)
	{
		var f=document.forms[0];
		if(!confirm('您确定材料已补充完成了吗？')){
			return ;
		}
		f.action="specialSubmit.asp?sid="+sid+"&isAdditional=0";
		f.submit();
	}
	function deleteSpecPrice(sid,qid)
	{
		var f=document.forms[0];
		if(!confirm('确定删除该特价申请？')){
			return ;
		}
		f.action="specialDelete.asp?sid="+sid+"&qid="+qid;
		f.submit();
	}
	function cancelSpecPrice(sid,qid)
	{
		var f=document.forms[0];
		if(!confirm('确定取消该特价申请？取消后不能再提交特价申请，只能以“Target Price”进单！')){
			return ;
		}
		f.action="specialCancel.asp?sid="+sid+"&qid="+qid;
		f.submit();
	}
	function openAdditional(sid)
	{
		window.open('AdditionInfo.asp?sid='+sid);
	}
	function sendMails()
	{
		location.href='remindMail.asp';
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
            <td class="titleorange"><div align="center">Special Price List </div></td>
          </tr>
          <tr> 
            <td class="titleorange">&nbsp;</td>
          </tr>
          <tr> 
            <td valign="top" class="line01"> <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
                <tr> 
                  <td><table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                      <tr class="line01"> 
                          <td width="18%"> 
                            <div align="left">Quotation No:<br>
                              报价文件号：<br>
                          </div></td>
                          <td width="20%"> 
                            <div align="left"> 
                              <input name="quotationNO" type="text" value="<%=quotationNO %>" style="width:100%">
                          </div></td>
                          <td width="14%"> 
                            <div align="left">Final User (Hospital) Name:<br>
                              最终用户名称（医院）：</div></td>
                          <td colspan="3"> 
                            <div align="left"> 
                              <input name="hospName" type="text" value="<%=hospName %>" style="width:100%">
                          </div></td>
						
                      </tr>
					     <tr class="line01"> 
                          <td width="18%"  height="25">
<div align="left">Submit Date:<br>
                              提交日期：
                            </div></td>
                        <td ><div align="left"> 
                              <input type="text" name="beginDate" readonly="true" size="15"  value="<%=beginDate %>" onClick="WdatePicker()">
							-  
                              <input type="text" name="endDate" readonly="true" size="15"  value="<%=endDate %>" onClick="WdatePicker()">
                          </div></td>
						 <% If isshowbu  Then %>
                        <td height="25"> <div align="left">BU:<br>BU：</div></td>
                          <td width="15%" > 
                            <div align="left"> 
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
                              &nbsp; </div></td>
						  <td width="14%" height="25" nowrap> 
                            <div align="left">Area:<br>
                              区域：&nbsp;</div></td>
                          <td width="15%" > 
                            <div align="left"> 
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
                              &nbsp; </div></td>
						 <% End If %>
						 <% If Not isshowbu then%>
							<td>&nbsp;</td><td colspan="3">&nbsp;</td>
						 <% End If %>
                      </tr>
					   <tr class="line01"> 
                        <td width="25%"> <div align="left">Status of Special Price Application:<br>特价申请状态：<br>
                          </div></td>
                        <td width="25%"> <div align="left"> 
                            <select name="shStatus" id="shStatus">
								<option value="">请选择</option>
								<option value="11">Approved</option>
								<option value="-1">Rejected</option>
								<option value="0">New</option>
								<option value="2">Wait for SD's Approval</option>
								<option value="3">Wait for BU Director's Approval</option>
								<option value="5">Wait for MD's Approval</option>
								<option value="4">Wait for FC's Approval</option>
								<option value="shaddtion">Wait for information</option>
								<option value="-2">Wait DM to check</option>
								<option value="-9">Wait DM to resubmit</option>
								<option value="-11">Canceled</option>
							</select>
                          </div></td>
                        <td width="25%"> <div align="left">Status of OIT Application:<br> OIT申请状态：</div></td>
                        <td width="25%" colspan="3"> <div align="left"> 
                           <select id="isApplyForOIT" name="isApplyForOIT">
								<option value="0">No</option>
								<option value="1">Yes</option>
						   </select>
                          </div></td>
                      </tr>
                    </table></td>
                </tr>
              </table>
              <p align="right"> 
                <input type="submit" name="Submit" value="Search" onClick="queryList();">
				&nbsp;&nbsp;
				<% if roleid="7" or roleid="9" then %>
				 <input type="button" name="Submit" value="Add New" onClick="add();">
				 <% end if%>
				 <% if roleid="16" or roleid="9" then %>
				 <input type="button" name="Submit" value="Send Mail" onClick="sendMails();">
				 <% end if%>
              </p></td>
          </tr>
          <tr> 
            <td class="line02">&nbsp; </td>
          </tr>
          <tr> 
            <td><table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" style="word-break:normal">
                <tr class="line01"> 
                  <td>Quotation No</td>
                  <td>Final User (Hospital) Name</td>
				   <td>Create By</td>
				    <td>Update By</td>
					 <td>Update Time</td>
                  <td>Status</td>
				    <td>Operation</td> 
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
                  <td nowrap><%=rs("quotationno")%>&nbsp;</td>
                  <td> 
				  <%
						response.write(rs("username"))
				  %>
				&nbsp;</td>
				  <td nowrap> <%=rs("crtusername")%>&nbsp;</td>
				  <td nowrap> <%=rs("updtusername")%>&nbsp;</td>
				<td nowrap> <%
				ut=rs("updttime")
				If Not IsNull(ut) And ut<>"" Then
					ut=displaytime2(ut)
				End If
				response.write(ut)
				%>&nbsp;</td>
				 <td nowrap><font color="#FF0000">
<%
	status=rs("status")
	ispending=rs("ispending")
	statusName=getApproveStatus(status,rs("productmodel"))
	If rs("isAdditional")=1 Then
		statusName="Wait for information"
	End If
	If ispending=1 Or ispending=9 Then
		statusName="Wait DM to check"
	End If
%>
				 <%=statusName %>
				</font> &nbsp;</td>
				  <td nowrap><a href="#" onclick="toDetail('<%=rs("id")%>');return false;">Details</a>&nbsp;&nbsp;
				  <% if (roleid="7" or roleid="9")  Then 
				  %>

				<%
					If ispending<>1 And  status<>"-11" And isApplyForOIT<>"1" And rs("isEdit")=1 then
					   If status<2 Or ispending=9  then
				  %>
				<a href="#" onclick="toEdit('<%=rs("id")%>');return false;">Edit</a>&nbsp;&nbsp;
				 <%
					  End If 
					End If
				%>
				<%
					 If status>=2 And rs("isAdditional")=1  And isApplyForOIT<>"1" And rs("isEdit")=1  then
				  %>
				<a href="#" onclick="openAdditional('<%=rs("id")%>');return false;">Additional Information</a>&nbsp;&nbsp;
				 <%
					End If
				%>
				<%
				 End if%>
				   <% if (roleid="7" or roleid="9")  Then 
				  %>

				<%
					 If (status=0 Or status=1 Or status=-1 ) And ispending=0  And status<>"-11"  And isApplyForOIT<>"1" And rs("isEdit")=1  then
				  %>
				<a href="#" onclick="deleteSpecPrice('<%=rs("id")%>','<%=rs("quotationid")%>');">Delete</a>&nbsp;&nbsp;
				 <%
					End If
				%>
			
				<%
				 End if%>
						
					<% if (roleid="7" or roleid="9")   And status<>11  And status<>"-11" And ispending=0  And isApplyForOIT<>"1" And rs("isEdit")=1  Then %>
							<% If status<2 And status>=0 then %>
							<a href="#" onclick="doSubmit('<%=rs("id")%>',2,'<%=status%>','<%=rs("isneedmsg")%>');">Submit</a>&nbsp;&nbsp;
							<% ElseIf status<0 And status<>"-2" Then %>
								<a href="#" onclick="doSubmit('<%=rs("id")%>',2,'<%=status%>','<%=rs("isneedmsg")%>');">Resubmit</a>&nbsp;&nbsp;
							<% End If %>
							<% If rs("isAdditional")=1 And ispending=0 then%>
								<a href="#" onclick="Additional('<%=rs("id")%>');">Submit</a>&nbsp;&nbsp;
							<% End if%>
					<% End If %>
				<% if (roleid="8"  Or roleid="3" Or roleid="4" Or roleid="6") And  status<>11 And status>0 And rs("isAdditional")=0 And ispending=0  And status<>"-11" And rs("isEdit")=1 Then 
					  If rs("productmodel")=1 And ((roleid=8 And status=2) Or (roleid=3 And status=3) Or (roleid=6 And status=4)) then 
				%>
						
							<a href="#" onclick="approveSpecial('<%=rs("id")%>');">Review</a>&nbsp;&nbsp;
							<% End If %>
					<%   If rs("productmodel")=2 And ((roleid=8 And status=2) Or (roleid=6 And (status=3 Or status=6)) Or (roleid=4 And (status =3 Or status=5))) then %>
						<a href="#" onclick="approveSpecial('<%=rs("id")%>');">Review</a>&nbsp;&nbsp;
					<% End If %>
					<% End If %>
		
					 <% if (roleid="7" or roleid="9" Or roleid="1")   And isApplyForOIT<>"1" And rs("isEdit")=1  Then  
						   If( status<>"11"  And status>0 ) then
					 %>	
						<a href="#" onclick="cancelSpecPrice('<%=rs("id")%>','<%=rs("quotationid")%>');">Cancel</a>&nbsp;&nbsp;
					<%
						End If
						End If
					%>
					&nbsp;
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
    document.forms[0].action="specialList.asp?page="+str;
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

  <% if not isnull(isApplyForOIT) and isApplyForOIT<>"" then %>
	$("#isApplyForOIT").val('<%=isApplyForOIT%>');
 <% end if %>
  <% if not isnull(shStatus) and shStatus<>"" then %>
	$("#shStatus").val('<%=shStatus%>');
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
