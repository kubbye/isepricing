<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/commons.asp"-->
<%
	dim saveFlag,str,password,username,principleid
	password=request("newpwd")
	principleid=session("principleid")
	saveFlag=request("save")
	if saveFlag="true" then
		str="update userinfo set password='"&password&"' where id="&principleid
		conn.execute str
		response.write("<script>alert('Password successfully changed, please relogin.');</script>")
		response.write("<script>parent.parent.parent.location.href='../index.asp';</script>")
		response.Flush()
	end if
	CloseDataBase
%>
<HTML>
<HEAD>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK 
href="../css/css.css" type=text/css rel=stylesheet>
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
<SCRIPT src="../js/ut.js"></SCRIPT>
<SCRIPT language=javascript>
   function saveData() { 
   	   if(!checkPassWord()){
	   		return false;
	   }
      document.form1.action="password.asp?save=true" ;  
	  document.form1.submit();
   }

   function restData() {
      document.form1.reset();
   }
   function checkPassWord(){
   		var newpass=document.form1.newpwd.value;
		var againpass=document.form1.confirmpwd.value;
		var pwd=document.form1.password.value;
		if(pwd!='<%=session("password")%>'){
			alert("Please input correct Password!");
			return false;
		}
		if(newpass==null || newpass==""){
			alert("新密码不能为空");
			return false;
		}
		if(newpass!=againpass){
			alert("New Passwords do not match!");
			return false;
		}
   		return true;
   }
 </SCRIPT>
<META content="MSHTML 6.00.2900.3314" name=GENERATOR>
</HEAD>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0">

<div align="center" >
<FORM name=form1 action="" method=post>
  <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
	 <tr> 
      <td>&nbsp;</td>
    </tr>
      <TR>
        <TD vAlign=top height=30><TABLE class="table01" cellSpacing=0 cellPadding=0 width="100%"  border=0>
            
             <TR>
             <td class="titleorange"><div align="center">Change Password </div></td>
            </TR>
            <TR>
              <td class="titleorange">&nbsp;</td>
            </TR>
            
          </TABLE></TD>
      </TR>
      <TR class="line01" >
        <TD >
          <TABLE bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
          
              <TR class="line01">
                <TD   align=left width="20%">Input Old Password:</TD>
                <TD  Align=left width="80%">
				<INPUT type="password" name="password">
                </TD>
              </TR>
              <TR class="line01">
                <TD  align=left 
          width="20%">Input New Password:</TD>
                <TD  Align=left width="80%">
				<INPUT type="password" name="newpwd" >
                </TD>
              </TR>
              <TR class="line01">
                <TD  align=left 
          width="20%">Input New Password again:</TD>
                <TD  Align=left width="80%">
				<INPUT type="password" name="confirmpwd" >
                </TD>
              </TR>
			  
          </TABLE>
          </TD>
      </TR>
	   <tr bgcolor="white"> 
                  <td >&nbsp;</td>
                </tr>
				<TR bgcolor="white">
                <TD ><div align="center">
				<INPUT class=lankuang onclick=restData() type=button value=Reset>
                  <INPUT class=lankuang onclick=saveData() type=button value=Save>
				   </div>
                </TD>
              </TR>
  </TABLE>
</FORM>
</div>
</BODY>
</HTML>
