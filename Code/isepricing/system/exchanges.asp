<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/commons.asp"-->
<!--#include file="../include/constant.asp"-->
<%
	dim sourcecode
	sourcecode=request("sourcecode")
	dim rs
	dim strSql
	strSql="select *  from exchanges a where 1=1 " 
	if sourcecode<>""  then
	strSql=strSql &" and  a.sourcecode like '%"&sourcecode &"%'"
	end if
	strSql=strSql & " order by id desc"
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
    document.form1.action="exchanges_add.asp"
	document.form1.submit();
  }

 function selectData(){	
    document.form1.action="exchanges.asp";
	document.form1.submit();	
 }

 function modifyData(id){	
    document.form1.action="exchanges_add.asp?id="+id;
	document.form1.submit();	
 }
 </SCRIPT>
</HEAD>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0">
<form name="form1" action="exchanges.asp" method="post">
<div align="center" >
<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
   <tr> 
      <td>&nbsp;</td>
    </tr>
    <TR>
      <TD vAlign=top>
	  	<TABLE border="0" align="center" cellpadding="0" cellspacing="0" class="table01" width="96%">
            <TR>
             <td class="titleorange"><div align="center">Exchange Rate</div></td>
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
              <TD class=strong align=right width="8%">Currency Code:</TD>
              <TD width="18%" align="left"><INPUT type="text" class=textBox name="sourcecode" value="<%=sourcecode%>"></TD>
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
                  <TD noWrap>Currency Code</TD>
                  <TD noWrap>Currency Name</TD>
				   <TD noWrap>Rate</TD>
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
                  <TD class=DataView noWrap><%=rs("sourcecode")%></TD>
                  <TD class=DataView noWrap><%=rs("currency")%></TD>
				   <TD class=DataView noWrap><%=rs("rate")%></TD>
                  <TD class=DataView noWrap width="286">
				  <INPUT  onclick=modifyData(<%=rs("id")%>); type=button value=" Edit " name=search0>
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
			   &nbsp;&nbsp; <A href="javascript:PageTo('<%=rs.pagecount%>')">&gt;&gt;|</A> &nbsp;&nbsp;Last Page </TD>
            </TR>
        </TABLE>
      </TD>
    </TR>
</TABLE>


<!--#include file="../footer.asp"-->
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
    document.form1.action="exchanges.asp?page="+str;
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
