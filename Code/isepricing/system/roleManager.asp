<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/commons.asp"-->
<!--#include file="../include/constant.asp"-->
<%
	dim rolename,roledesc,rolestate
	rolename=request("rolename")
	roledesc=request("roledesc")
	rolestate=request("rolestate")
	if rolestate="" then 
		rolestate="1"
	end if
%>
<HTML>
<HEAD>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK href="../css/css.css" type=text/css rel=stylesheet>
<STYLE type=text/css>
A {
	CURSOR: hand; TEXT-DECORATION: none
}
A:hover {
	LEFT: 1px; CURSOR: hand; COLOR: #8c89f8; POSITION: relative; TOP: 1px; TEXT-DECORATION: none
}
.style1 {
	COLOR: #ff0000
}
   </STYLE>
<SCRIPT src="../css/ut.js"></SCRIPT>
<SCRIPT lanuage="javascript">
  function newData(){
    document.form1.action="roleManager_add.asp"
	document.form1.submit();
  }
function changeState(roleid,state){
	if(state==0){
		if(!confirm("Confirm to disable?")){
			return false;
		}
	}
	document.form1.action="RoleChangeState.asp?roleid="+roleid+"&state="+state;
	document.form1.submit();
}
 function selectData(){	
    document.form1.action="roleManager.asp";
	document.form1.submit();	
 }

 function modifyData(id){	
    document.form1.action="roleManager_add.asp?id="+id;
	document.form1.submit();	
 }
 
 </SCRIPT>
</HEAD>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0">
<form name="form1" action="roleManager.asp" method="post">
<input type="hidden" name="state">
<div align="center" >
<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
   <tr> 
      <td>&nbsp;</td>
    </tr>
       <TR>
      <TD vAlign=top>
	  	<TABLE border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
            <TR>
             <td class="titleorange"><div align="center">Role List</div></td>
            </TR>
            <TR>
              <td class="titleorange">&nbsp;</td>
            </TR>
        </TABLE>
		</TD>
    </TR>
         <TR>
      <td valign="top" class="line01"> <table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
                <tr> 
                  <td><table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
       
              <TR  class="line01">
                <TD class=strong align=right width="5%" nowrap="nowrap">Role Name:</TD>
                <TD width="15%" align="left"><INPUT class=textBox type="text" name="rolename" value="<%=rolename%>"></TD>
                <TD class=strong align=right width="5%">Description:</TD>
                <TD width="15%" align="left"><INPUT class=textBox  type="text" name="roledesc" value="<%=roledesc%>">
                </TD>
                <TD class=strong align=right width="10%">Status:</TD>
				<TD class=strong width="20%" align="left">
					<select name="rolestate">
						<option value="1">valid</option>
						<option value="0">invalid</option>
					</select>
				</TD>
                <TD width="30%"><INPUT class=lankuang onclick=selectData(); type=button value=" Search " name=search>
                  <INPUT class=lankuang onclick=newData(); type=button value="Add New" name=search6>
                </TD>
              </tr>
          </TABLE>
		  </td>
		  </tr>
		  </table>
		  </td>
		  </TR>
		    <tr class="line02">
	 <td>&nbsp; 
	 </td>
	 </tr>
		  <tr>
		  <td>
             <TABLE width="96%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" align="center">
           
                  <TR class="line01">
                    <TD noWrap>Role Name</TD>
                    <TD noWrap>Description</TD>
					 <TD noWrap>Status</TD>
                    <TD noWrap width="286">Action</TD>
                  </TR>
		 <%
			page=request("page")
			if page<>"" then
				if not isnumeric(page) then
					%>
                  <script language="JavaScript">
						alert("页数请输入数字");
						history.go(-1);
					</script>
                  <%
					response.end
				else
					page=cint(page)
				end if
			else
					page=cint(page)
			end if
			
			dim rs
			dim strSql
			strSql="select * from rolemsg where 1=1 "
			if rolestate<>""  then
			strSql=strSql &" and  validflag="&rolestate
			end if
			if  rolename<>"" then
				strSql=strSql & " and  rolename like '%"& rolename &"%'"
			end if
			if roledesc<>""  then
				strSql=strSql & " and roledesc like '%"& roledesc &"%'"
			end if
		
			set rs=server.createObject("adodb.recordset")
			rs.open strSql,conn,3,3
			if  rs.eof and  rs.bof then
			%>

                  <TR class="line02">
                    <td colspan="8" align="center"> no record</td>
                  </tr>
                  <%
		else
			
			rs.pagesize=CONS_PAGESIZE
			if page<=0 then page=1
			if page >rs.pagecount then page=rs.pagecount
			rs.absolutepage=page
			
			for i=1 to rs.pagesize 
			
			
		%>
                  <TR class="line02">
                    <TD class=DataView noWrap><%=rs("rolename")%></TD>
                    <TD class=DataView noWrap><%=rs("roledesc")%></TD>
					 <TD class=DataView noWrap>
					 <% dim show
					 if rs("validflag")="0" then 
					 	show="Invalid"
					 else
					 	show="Valid"
					 end if
					 %>
					 <%=show%>
					 </TD>
                    <TD class=DataView noWrap width="286">
					<INPUT class=lankuang onclick=modifyData(<%=rs("roleid")%>); type=button value=" Edit " name=search0>
					<% if rs("validflag")="1" then%>
                      <INPUT class=lankuang onClick="changeState(<%=rs("roleid")%>,0);" type=button value=" Disable " name=search1>
					  <% end if
					  if rs("validflag")="0" then 
					  %>
                      <INPUT class=lankuang onClick="changeState('<%=rs("roleid")%>','1');" type=button value=" Enable " name=search1>
					  <% end if%>
                    </TD>
                  </TR>
	  <% 
	   rs.movenext
	   if rs.eof then exit for
	   	next
		end if
	   %>
              </TABLE>
			</td>
			</tr>
			<tr><td>
			
			
          <TABLE height="34" cellSpacing="0" cellPadding="0" width="100%" background='../img/bg_bt.gif' border="0">
              <TR class="line01">
                <TD align=right>Record Count:<%=rs.recordcount%> &nbsp;&nbsp;Page:<%=page%>/<%=rs.pagecount%></TD>
                <TD noWrap align=middle width="70%"> First Page&nbsp; 
				<A href="javascript:PageTo('1')">|&lt;&lt;</A> &nbsp;&nbsp; 
				<A href="javascript:PageTo('<%=page-1%>')">&lt;&lt;</A> &nbsp;&nbsp; 
				<A href="javascript:PageTo('<%=page+1%>')">&gt;&gt;</A> &nbsp;&nbsp;
				 <A href="javascript:PageTo('<%=rs.pagecount%>')">&gt;&gt;|</A> &nbsp;&nbsp; Last Page </TD>
              </TR>
    
          </TABLE>
          </TD>
      </TR>
  </TABLE>
  <script>
  	<% if rolestate<>"" then %>
	document.forms[0].rolestate.value=<%=rolestate%>;
	<% end if%>
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
	
    document.form1.action="roleManager.asp?page="+str;
    document.form1.submit();	
 }
</script>


<!--#include file="../footer.asp"-->
</form>
</div>
<%
	rs.close
	set rs=Nothing
	CloseDatabase
%>
</BODY>
</HTML>
