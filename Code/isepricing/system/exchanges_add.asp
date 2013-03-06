<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/commons.asp"-->
<%
	dim id,sourcecode,currency1,rate,readonly
	
	readonly=""
	
	id=request("id")
	if id<>"" then
		strSql="select * from exchanges a where id="&id
		set rs=server.createObject("adodb.recordset")
		rs.open strSql,conn,1,1
		sourcecode=rs("sourcecode")
		currency1=rs("currency")
		rate=rs("rate")
		bclose=true
		readonly="readonly"
	end if

%>
<HTML><HEAD>
<META http-equiv=Content-Type content="text/html; charset=gb2312"><LINK 
href="../css/css.css" type=text/css rel=stylesheet>
<STYLE type=text/css>A {
	CURSOR: hand; TEXT-DECORATION: none
}
A:hover {
	LEFT: 1px; CURSOR: hand; COLOR: #8c89f8; POSITION: relative; TOP: 1px; TEXT-DECORATION: none
}
.style1 {
	COLOR: #ff0000
}
</STYLE>

<SCRIPT src="../js/ut.js"></SCRIPT>

<SCRIPT language=javascript>
   function saveData() {  
   		if(!checkForm(document.form1)){
			return false;
		}
      document.form1.action="exchangesAdd.asp"      
	  document.form1.submit();
   }

   function restData() {
      document.form1.reset();
   }
   function checkForm(form){
   		var n=form.rate.value;
		if(n==null || n==''){
			alert('Please input Exchange Rate!');
			return false;
		}
		if(isNaN(n)){
			alert("Exchange Rate must be number!");
			form.funorder.focus();
			return false;
		}

		if(form.sourcecode.value==null || form.sourcecode.value==""){
			alert("Please input Currency Code!");
			form.sourcecode.focus();
			return false;
		}
		if(form.currency.value==null || form.currency.value==""){
			alert("Please input Currency Name!");
			form.currency.focus();
			return false;
		}
   		return true;
   }
 </SCRIPT>

<META content="MSHTML 6.00.2900.3314" name=GENERATOR></HEAD>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0">
<FORM name=form1 action="exchangesAdd.asp" method="post">
<input type="hidden" name="id" value="<%=id%>">
<div align="center" >
<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
   <tr> 
      <td>&nbsp;</td>
    </tr>
    <TR>
      <TD vAlign=top>
	  	<TABLE border="0" align="center" cellpadding="0" cellspacing="0" class="table01" width="96%">
            <TR>
             <td class="titleorange"><div align="center">Edit Exchange Rate</div></td>
            </TR>
            <TR>
              <td class="titleorange">&nbsp;</td>
            </TR>
  
  
        <TR >
      <td valign="top" class="line01" > <table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
        <TR class="line01">
          <TD class=tdLabel vAlign=center align=left 
          width="15%">Currency Code:</TD>
          <TD align="left" vAlign=center width="30%">
		  <INPUT name="sourcecode" id="sourcecode" value="<%=sourcecode%>" maxlength="20" <%=readonly%>> 
          </TD></TR>
		   <TR class="line01">
          <TD class=tdLabel vAlign=center align=left 
          width="15%">Currency Name:</TD>
          <TD align="left" vAlign=center width="30%">
		  <INPUT name="currency" id="currency" value="<%=currency1%>" maxlength="20"> 
          </TD></TR>
        <TR class="line01">
          <TD class=tdLabel vAlign=center align=left 
          width="15%">Exchange Rate:</TD>
          <TD align="left" vAlign=center width="30%">
		  <INPUT name="rate" id="rate" value="<%=rate%>" maxlength="50"> 
				</TD></TR>
		    <TR class="line01">
          <TD colspan="2" align="left">
		  =1 USD 美元
          </TD></TR>
		<tr bgcolor="white"> 
		  <td colspan="2">&nbsp;</td>
		</tr>

        <TR bgcolor="white">
          <TD colSpan=2><div align="right"><INPUT class=lankuang onclick=restData() type=button value=Reset> 
<INPUT class=lankuang onclick=saveData() type=button value=Save> 
<INPUT class=lankuang onClick="history.back()" type=button value="Back"> 
</div>
        </TD></TR>
		 </TABLE>

		  </TD>
      </TR>
	      </TABLE>
		</TD>
    </TR>
  </TABLE>
	
		<%
	if bclose then
		rs.close
		set rs=Nothing
	end if
	CloseDatabase
%>
<!--#include file="../footer.asp"-->
	</FORM>
</div>
</BODY></HTML>
