<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/commons.asp"-->
<!--#include file="../include/constant.asp"-->
<%
	dim funname,fundesc,funstate
	funname=request("funname")
	fundesc=request("fundesc")
	funstate=request("funStatus")
	if funstate="" then 
		funstate="1"
	end if

	dim rs
	dim strSql
	strSql="select a.*,b.funname as parentname from functiontree a " 
strSql=strSql&" left join functiontree b on a.parentid=b.funid"
strSql=strSql&" where a.funid>1 "
	if funstate<>""  then
	strSql=strSql &" and  a.validflag="&funstate
	end if
	if  funname<>"" then
		strSql=strSql & " and  a.funname like '%"& funname &"%'"
	end if
	if fundesc<>""  then
		strSql=strSql & " and a.fundesc like '%"& fundesc &"%'"
	end if
	set rs=server.createObject("adodb.recordset")
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

<SCRIPT lanuage="javascript">
  function newData(){
    document.form1.action="functionManager_add.asp"
	document.form1.submit();
  }

 function selectData(){	
    document.form1.action="functionManager.asp";
	document.form1.submit();	
 }

 function modifyData(id){	
    document.form1.action="functionManager_add.asp?id="+id;
	document.form1.submit();	
 }

 function changeStatus(funid,status){	
 	if(status==0){
		if(!confirm("Confirm to disable?")){
			return false;
		}
	}
    document.form1.action="functionChangeStatus.asp?funstatus="+status+"&id="+funid;
	document.form1.submit();	
 }
 </SCRIPT>
</HEAD>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0">
<form name="form1" action="functionManager.asp" method="post">
<input type="hidden" name="page">
<div align="center" >
<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
   <tr> 
      <td>&nbsp;</td>
    </tr>
    <TR>
      <TD vAlign=top>
	  	<TABLE border="0" align="center" cellpadding="0" cellspacing="0" class="table01" width="96%">
            <TR>
             <td class="titleorange"><div align="center">Function List</div></td>
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
              <TD class=strong align=right width="8%" nowrap="nowrap">Function Name:</TD>
              <TD width="18%" nowrap="nowrap"><INPUT type="text" class=textBox name="funname" value="<%=funname%>"></TD>
              <TD class=strong align=right width="8%" >Description:</TD>
              <TD width="18%"><INPUT type="text" class=textBox name="fundesc" value="<%=fundesc%>">
              </TD>
              <TD class=strong align=right width="10%">Status:</TD>
			  <TD class=strong align=left width="18%">
			  <select name="funStatus">
			  		<option value="1">valid</option>
					<option value="0">invalid</option>
			  </select>
			  </TD>
              <TD width="20%"><INPUT class=lankuang onclick=selectData(); type=button value=" Search " name=search>
                <INPUT class=lankuang onclick=newData(); type=button value="Add New" name=search6>
              </TD>
            </tr>

        </TABLE>
		</td>
		</tr>
		 </TABLE>
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
                  <TD noWrap>Function Name</TD>
                  <TD noWrap>Description</TD>
				   <TD noWrap>Parent</TD>
				   <TD noWrap>Display Order</TD>
				   <TD noWrap>Status</TD>
                  <TD noWrap width="286">Action</TD>
                </TR>
	 <%
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
			rs.open strSql,conn,3,3
			if  rs.eof and  rs.bof then
			%>

                  <TR class="line02" >
                    <td colspan="8" align="center"> no record</td>
                  </tr>
                  <%
		else
			
			rs.pagesize=CONS_PAGESIZE
			if page<=0 then page=1  end if
			if page >rs.pagecount then page=rs.pagecount end if
			rs.absolutepage=page
			
			for i=1 to rs.pagesize 
			
			
		%>
                <TR class="line02">
                  <TD class=DataView noWrap><%=rs("funname")%></TD>
                  <TD class=DataView noWrap><%=rs("fundesc")%></TD>
				   <TD class=DataView noWrap><%=rs("parentname")%></TD>
				    <TD class=DataView noWrap><%=rs("funorderid")%></TD>
				  <TD class=DataView noWrap>
				  <%  dim funstatus
				  if rs("validflag")="1" then 
				  	funstatus="Valid"
				else
				  	funstatus="Invalid"
				end if
				  %>
				  <%=funstatus%>
				  </TD>
                  <TD class=DataView noWrap width="286">
				  <INPUT class=lankuang onclick=modifyData(<%=rs("funid")%>); type=button value=" Edit " name=search0>
				  <% if rs("validflag")="1" then%>
                    <INPUT class=lankuang onClick="changeStatus(<%=rs("funid")%>,0);" type=button value=" Disable " name=search1>
				<% else%>
                    <INPUT class=lankuang onClick="changeStatus(<%=rs("funid")%>,1);" type=button value=" Enable " name=search1>
				<% end if%>
                  </TD>
                </TR>
             <% 
	   rs.movenext
	   if rs.eof then exit for end if
	   	next
		end if
	   %>     
         
            </TABLE>
		</td>
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
			   &nbsp;&nbsp; <A href="javascript:PageTo('<%=rs.pagecount%>')">&gt;&gt;|</A> &nbsp;&nbsp; Last Page</TD>
            </TR>
        </TABLE>
      </TD>
    </TR>
</TABLE>


<!--#include file="../footer.asp"-->
<script>
  	<% if funstate<>"" then %>
		document.forms[0].funStatus.value=<%=funstate%>;
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
    document.form1.action="functionManager.asp?page="+str;
	document.form1.page.value=str;
    document.form1.submit();	
 }
</script>
</form>
</div>
<%
	rs.close
	set rs=Nothing
	CloseDatabase
%>
</BODY>
</HTML>
