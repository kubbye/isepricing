<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/commons.asp"-->
<%
	dim id,rs,funname,fundesc,funorder,funurl,parent,validflag,bclose,isleaf
	id=request("id")
	if id<>"" then
		strSql="select * from functiontree a where funid="&id
		set rs=server.createObject("adodb.recordset")
		rs.open strSql,conn,1,1
		funname=rs("funname")
		fundesc=rs("fundesc")
		funorder=rs("funorderid")
		parent=rs("parentid")
		validflag=rs("validflag")
		funurl=rs("funurl")
		isleaf=rs("isleaf")
		bclose=true
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
      document.form1.action="functionAdd.asp"      
	  document.form1.submit();
   }

   function restData() {
      document.form1.reset();
   }
   function checkForm(form){
   		var n=form.funorder.value;
		if(isNaN(n)){
			alert("functionOrder must to be a number!");
			form.funorder.focus();
			return false;
		}

		if(form.funname.value==null || form.funname.value==""){
			alert("Please input Function Name!");
			form.funname.focus();
			return false;
		}
   		return true;
   }
 </SCRIPT>

<META content="MSHTML 6.00.2900.3314" name=GENERATOR></HEAD>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0">
<FORM name=form1 action="functionAdd.asp" method="post">
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
             <td class="titleorange"><div align="center">Add Function</div></td>
            </TR>
            <TR>
              <td class="titleorange">&nbsp;</td>
            </TR>
  
  
        <TR >
      <td valign="top" class="line01" > <table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >


        <TR class="line01">
          <TD class=tdLabel vAlign=center align=left 
          width="15%">Function Name:</TD>
          <TD align="left" vAlign=center width="30%">
		  <INPUT name=funname id="funname" value="<%=funname%>" maxlength="50"> 
				</TD></TR>
        <TR class="line01">
          <TD class=tdLabel vAlign=center align=left 
          width="15%">Description:</TD>
          <TD align="left" vAlign=center width="30%">
		  <INPUT name=fundesc id="fundesc" value="<%=fundesc%>" maxlength="50"> 
          </TD></TR>
		   <TR class="line01">
          <TD class=tdLabel vAlign=center align=left 
          width="15%">Function URL:</TD>
          <TD align="left" vAlign=center width="30%">
		  <INPUT name="funurl" id="funurl" value="<%=funurl%>" maxlength="100"> 
          </TD></TR>
		 <TR class="line01">
          <TD class=tdLabel vAlign=center align=left 
          width="15%">Display Order:</TD>
          <TD align="left" vAlign=center width="30%">
		  <INPUT name=funorder id="funorder" value="<%=funorder%>"> （数字越小越靠前）
          </TD></TR>
		   <TR class="line01">
          <TD class=tdLabel vAlign=center align=left 
          width="15%">Parent:</TD>
          <TD align="left" vAlign=center width="30%">
					<select name="parent">
					<%
						dim rsfun
						set rsfun=server.CreateObject("adodb.recordset")
						str="select funid,funname from functiontree order by parentid, funid"
						rsfun.open str,conn,1,1
						while not rsfun.eof 
							if trim(rsfun("funid"))<>trim(id) then
					%>
						<option value="<%=rsfun("funid")%>"><%=rsfun("funname")%></option>
					<%
							end if
						rsfun.movenext
						wend
					%>
					</select> </TD></TR>
		<TR class="line01">
          <TD class=tdLabel vAlign=center align=left 
          width="15%">IsLeaf:</TD>
          <TD align="left" vAlign=center width="30%">
		  <input type="radio" name="isleaf" value="0" checked="checked">NO
		   <input type="radio" name="isleaf" value="1">YES
          </TD></TR>
        <TR class="line01">
          <TD class=tdLabel vAlign=center align=left 
          width="15%">Status:</TD>
          <TD align="left" vAlign=center width="30%">
					<select name="validflag">
					<option value="1">Valid</option>
					<option value="0">Invalid</option>
					</select> </TD></TR>
					
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
<% if id<>"" then%>
<script>
	document.form1.parent.value=<%=parent%>;
	document.form1.validflag.value=<%=validflag%>;
	var isleafs=document.getElementsByName("isleaf");
	for(var i=0;i<isleafs.length;i++){
		if(isleafs[i].value=='<%=isleaf%>'){
			isleafs[i].checked="true";
			break;
		}
	}
</script>
<% end if%>
	
		<%
	if bclose then
		rs.close
		set rs=Nothing
	end if
	rsfun.close
	set rsfun=Nothing
	CloseDatabase
%>
<!--#include file="../footer.asp"-->
	</FORM>
</div>
</BODY></HTML>
