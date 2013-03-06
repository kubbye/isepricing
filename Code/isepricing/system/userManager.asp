<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/commons.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="utils.asp"-->
<!--#include file="../include/constant.asp"-->
<%
	dim userid,username,roleid
	userid=request.Form("userid")
	username=request("username")
	roleid=request("roleid")
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
    document.form1.action="userManager_add.asp"
	document.form1.submit();
  }

 function selectData(){	
    document.form1.action="userManager.asp";
	document.form1.submit();	
 }

 function modifyData(id){	
    document.form1.action="userManager_add.asp?id="+id;
	document.form1.submit();	
 }

 function deleteData(id){	
 	if(confirm("Confirm to delete?")){
		document.form1.action="userDelete.asp?id="+id;
		document.form1.submit();	
	}
 }

 
 </SCRIPT>
</HEAD>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0">
<form name="form1" action="userManager.asp" method="post">
 <div align="center" >
<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
   <tr> 
      <td>&nbsp;</td>
    </tr>
    <TR>
      <TD vAlign=top>
	  	<TABLE border="0" align="center" cellpadding="0" cellspacing="0" class="table01" width="96%">
            <TR>
             <td class="titleorange"><div align="center">User List
			 </div></td>
            </TR>
            <TR>
              <td class="titleorange">&nbsp;</td>
            </TR>
        </TABLE>
		</TD>
    </TR>
      <TR >
      <td valign="top" class="line01" > <table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
                <tr> 
                  <td><table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
              <TR class="line01">
                <TD class=strong align=right width="11%">ID:</TD>
                <TD width="26%" align="left"><INPUT type="text" class=textBox name="userid" id="userid" value="<%=userid%>"></TD>
                <TD class=strong align=right width="9%">name:</TD>
                <TD width="25%" align="left"><INPUT type="text" class=textBox name="username" id="username" value="<%=username%>">
                </TD>
                <TD class=strong align=right width="8%"></TD>
                <TD width="18%"></TD>
              </tr>
              <TR class="line01">
                <TD class=strong align=right width="11%">Role:</TD>
                <TD width="26%" align="left"><select  name="roleid" style="width:60%">
                    <option></option>
                    <%
			  	 dim rsrole,strrole
				 strrole="select roleid,rolename from rolemsg where validflag=1"
				 set rsrole=server.CreateObject("adodb.recordset")
				 rsrole.open strrole,conn,1,1
				 if rsrole.eof and rsrole.bof then 
				 %>
                    <%
				 else
				  while not rsrole.eof 
			  %>
                    <option value="<%=rsrole("roleid")%>"><%=rsrole("rolename")%></option>
                    <%
			  	rsrole.movenext
			  	wend
			   end if
			   	rsrole.close
				set rsrole=Nothing
			   %>
                  </select>
                </TD>
                <TD class=strong align=right width="9%"></TD>
                <TD width="25%"></TD>
                <TD class=strong align=right width="8%"></TD>
                <TD width="18%"><INPUT class=lankuang onclick=selectData(); type=button value=" Search " name=search>
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
            <TABLE width="96%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" align="center" style="word-break:break-all">

                  <TR class="line01">
                    <TD noWrap>ID</TD>
                    <TD noWrap>Name</TD>
                    <TD noWrap>Role</TD>
                    <TD noWrap>E-MAIL</TD>
                    <TD noWrap>Mobile</TD>
					 <TD noWrap>Zone</TD>
					<TD noWrap>BU</TD>
                    <TD noWrap >Action</TD>
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
			strSql="select * from userinfo where validflag=1 and userid<>'10001'"
			if roleid<>""  then
			strSql=strSql &" and id in (select userid from user_rolerel where roleid ="& roleid &") "
			end if
			if  userid<>"" then
				strSql=strSql & " and  userid='"& userid &"'"
			end if
			if username<>""  then
				strSql=strSql & " and username like'%"& username &"%'"
			end if
		
			set rs=server.createObject("adodb.recordset")
			rs.open strSql,conn,3,3
			if  rs.eof and  rs.bof then
			%>
                  <TR class="line02">
                    <td colspan="8"> no record</td>
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
                    <TD width="20%"><%=rs("userid")%></TD>
                    <TD width="10%"><%=rs("username")%></TD>
                    <TD width="10%"  >
	<%
		dim rsRoleShow ,strRoleShow
		set rsRoleShow=server.CreateObject("adodb.recordset")
		strRoleShow="select distinct rolename from user_rolerel a,rolemsg b where a.roleid=b.roleid"

		strRoleShow=strRoleShow&" and a.userid="&rs("id")
		rsRoleShow.open strRoleShow ,conn,1,1
		dim j
		j=0
		while not rsRoleShow.eof
			if j=0 then
				response.Write(rsRoleShow("rolename"))
			else
				response.Write(","&rsRoleShow("rolename"))
			end if
			j=j+1
			rsRoleShow.movenext
		wend
		rsRoleShow.close
		set rsRoleShow=Nothing
	%>&nbsp;
					
					</TD>
                    <TD width="10%" ><%=rs("email")%>&nbsp;</TD>
                    <TD width="10%" ><%=rs("mobile")%>&nbsp;</TD>
					
					<TD width="10%" >
	
					<% dim zonelist
					zonelist=execSql("select zid,zonename from user_zonerel a,zone b where a.zoneid=b.zid and a.userid="&rs("id"))%>
					<% 
					for k=0 to ubound(zonelist) %>
						<%=zonelist(k,1)%>&nbsp;
					<% next
					%>
					&nbsp;
					</TD>
					<%
						dim buname
						buname=""
						if  not isnull(rs("bu")) and  rs("bu")<>"" then
							buname=BU_TYPE(cint(rs("bu")),1)
						end if
					%>
					<TD  width="10%"><%=buname%>&nbsp;</TD>
                    <TD  noWrap width="10%"><INPUT class=lankuang onclick=modifyData('<%=rs("id")%>'); type=button value=" Edit " name=search7>
                      <INPUT class=lankuang onclick=deleteData('<%=rs("id")%>'); type=button value=" Delete " name=search8>
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
		   <TR>
		   <td>
              <TABLE height="34" cellSpacing="0" cellPadding="0" width="100%" background='../img/bg_bt.gif' border="0" class="table01">
                  <TR class="line01">
                    <TD align=right>
					Record Count:<%=rs.recordcount%> &nbsp;&nbsp;Page:<%=page%>/<%=rs.pagecount%></TD>
                    <TD noWrap align=middle width="70%"> First Page&nbsp; <A href="javascript:PageTo('1')">|&lt;&lt;</A> &nbsp;&nbsp; <A href="javascript:PageTo('<%=page-1%>')">&lt;&lt;</A> &nbsp;&nbsp; <A href="javascript:PageTo('<%=page+1%>')">&gt;&gt;</A> &nbsp;&nbsp; <A href="javascript:PageTo('<%=rs.pagecount%>')">&gt;&gt;|</A> &nbsp;&nbsp;Last Page </TD>
                  </TR>
              </TABLE>
        </TD>
      </TR>
  </TABLE>
  <script>
  <% if roleid<>"" then%>
	document.forms[0].roleid.value=<%=roleid%>;
	<%end if%>
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
	
    document.form1.action="userManager.asp?page="+str;
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
