<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<HTML>
<HEAD>
<!--#include file="../include/conn.asp" -->
<!--#include file="../include/commons.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="utils.asp"-->
<%
	dim id,strSql,rs,userid,username,email,tel,bu,bclose,useridreadonly,zoneid
	id=request("id")
	if id<>"" then
		strSql="select a.* from userinfo a   where a.id="&id
		set rs=server.createObject("adodb.recordset")
		rs.open strSql,conn,1,1
		
		userid=rs("userid")
		username=rs("username")
		email=rs("email")
		tel=rs("mobile")
		bu=rs("bu")
		pwd=rs("password")
		
		strSql="select * from user_zonerel where userid="&id
		set rsZone=server.createObject("adodb.recordset")
		rsZone.open strSql,conn,1,1
	
		
		bclose=true
		useridreadonly="readonly"
	end if
	if id="" then
		Dim objTypeLib,pl
		Set objTypeLib = CreateObject("Scriptlet.TypeLib")
		pwd=objTypeLib.Guid
		pwd=replace(pwd,"-","")
		pl=len(pwd)
		pwd= left(pwd,pl-10)
		pwd=right(pwd,pl-20)
		
	end if



%>
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
<script type="text/javascript" src="../js/jquery-1.2.6.js"></script>
<SCRIPT language=javascript>
   function saveData() {  
	  if(!checkForm(document.form1)){
		  return false;
	  }
	  //concat all zone
	  var zoneids='';
	  if($("input:checkbox[name='zoneid'][checked]").size()>0){
	  	$("input:checkbox[name='zoneid'][checked]").each(function(index){
			if(index==0){
				zoneids=$(this).val();
			}else{
				zoneids=zoneids+","+$(this).val();
			}
		});
		$("#zoneids").val(zoneids);
	  }
      document.form1.action="userAdd.asp"      
	  document.form1.submit();
   }

   function restData() {
      document.form1.reset();
   }
   function checkForm(form){
   		if(form.userid.value==null|| form.userid.value==""){
			alert("Please input ID!");
			form.userid.focus();
			return false;
		}
		if(form.username.value==null|| form.username.value==""){
			alert("Please input Name!");
			form.username.focus();
			return false;
		}
		if(form.pwd.value==null|| form.pwd.value==""){
			alert("Please input Password!");
			form.pwd.focus();
			return false;
		}
		if(form.email.value==null|| form.email.value==""){
			alert("PLEASE CHOOSE A EMAIL !");
			form.email.focus();
			return false;
		}
		if(form.email.value!=null && form.email.value!=""){
			if(!checkEmail(form.email)){
				alert("Please input correct email address!");
				form.email.focus();
				return false;
			}
		}
		if(form.role.value==null|| form.role.value==""){
			alert("PLEASE CHOOSE A ROLE !");
			form.role.focus();
			return false;
		}
	
		if(form.tel.value!=null && form.tel.value!=""){
			if(!checkTel(form.tel)){
				alert("Please input correct mobile no!");
				form.tel.focus();
				return false;
			}
		}
		return true;
   }
   function checkEmail(obj){
   		var s=/^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/ ;
		return s.test(obj.value);
   }
   function checkTel(obj){
   		var s=/^([0-9]{3,4}-){0,1}[1-9]{1}[0-9]{5,12}(-[0-9]{2-4}){0,1}$/;
		return s.test(obj.value);
   }
 </SCRIPT>
<META content="MSHTML 6.00.2900.3314" name=GENERATOR>
</HEAD>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0">
<FORM name=form1 action="" method=post>
  <input type="hidden" value="<%=id%>" name="id">
    <input type="hidden"  name="zoneids" id="zoneids">
<div align="center" >
<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
   <tr> 
      <td>&nbsp;</td>
    </tr>
    <TR>
      <TD vAlign=top>
	  	<TABLE border="0" align="center" cellpadding="0" cellspacing="0" class="table01" width="96%">
            <TR>
             <td class="titleorange"><div align="center">User Add</div></td>
            </TR>
            <TR>
              <td class="titleorange">&nbsp;</td>
            </TR>
  
          <TR >
      <td valign="top" class="line01" > <table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >

              <TR class="line01">
                <TD vAlign=center align=left width="15%">ID:</TD>
                <TD  vAlign=center align="left"><INPUT name="userid" value="<%=userid%>" <%=useridreadonly%> maxlength="60" size="30">
                </TD>
              </TR>
              <TR class="line01">
                <TD class=tdLabel vAlign=center align=left 
          width="15%">Name:</TD>
                <TD align="left" vAlign=center width="30%"><INPUT name="username" value="<%=username%>" maxlength="60" size="30">
                </TD>
              </TR>
			       <TR class="line01">
                <TD class=tdLabel vAlign=center align=left 
          width="15%">Password:</TD>
                <TD align="left" vAlign=center width="30%"><INPUT name="pwd" value="<%=pwd%>" maxlength="30" size="30">
                </TD>
              </TR>
              <TR class="line01">
                <TD class=tdLabel vAlign=center align=left 
          width="15%">Email:</TD>
                <TD align="left" vAlign=center width="30%"><INPUT name="email" value="<%=email%>" size="30">
                </TD>
              </TR>
              <TR class="line01">
                <TD class=tdLabel vAlign=center align=left 
          width="15%">Mobile:</TD>
                <TD align="left" vAlign=center width="30%"><INPUT name="tel" value="<%=tel%>" size="30">
                </TD>
              </TR>
              <TR class="line01">
                <TD  vAlign=center align=left 
          width="15%">Role:</TD>
                <TD  vAlign=center align="left" width="30%"><select name="role">
                    <%  '设置角色列表
			  	 dim rsrole,strrole
				 strrole="select roleid,rolename from rolemsg where validflag=1"
				 set rsrole=server.CreateObject("adodb.recordset")
				 rsrole.open strrole,conn,1,1
				 if rsrole.eof and rsrole.bof then 
				 %>
                    <option></option>
                    <%
				 else
				  while not rsrole.eof 
			  %>
                    <option value="<%=rsrole("roleid")%>"><%=rsrole("rolename")%></option>
                    <%
			  	rsrole.movenext
			  	wend
			   end if%>
                  </select>
                </TD>
              </TR>
			      <TR class="line01">
                <TD class=tdLabel vAlign=center align=left 
          width="15%">Zone:</TD>
                <TD align="left" vAlign=center width="30%">
						<% dim zonelist
					zonelist=execSql("select zid,zonename from zone")%>
					<% for i=0 to ubound(zonelist) %>
						<input type="checkbox" name="zoneid" value="<%=zonelist(i,0)%>"><%=zonelist(i,1)%>
					<% next%>
                </TD>
              </TR>
			      <TR class="line01">
                <TD class=tdLabel vAlign=center align=left 
          width="15%">Bu:</TD>
                <TD align="left" vAlign=center width="30%">
				<SELECT name="bu" >
					<% for i=0 to ubound(BU_TYPE) %>
						<option value="<%=BU_TYPE(i,0)%>"><%=BU_TYPE(i,1)%></option>
					<% next%>
				</SELECT>
				
                </TD>
              </TR>
			    <tr bgcolor="white"> 
                  <td colspan="2">&nbsp;</td>
                </tr>
         
              <TR bgcolor="white">
                <TD colSpan=2><div align="right"> <INPUT class=lankuang onclick=restData() type=button value=Reset>
                  <INPUT class=lankuang onclick=saveData() type=button value=Save>
				  <INPUT class=lankuang onClick="history.back()" type=button value="Back"> 
				  </div>
                </TD>
              </TR>
          </TABLE>

		  </TD>
      </TR>
	      </TABLE>
		</TD>
    </TR>
  </TABLE>
<%
'设置选定角色

	dim condition
	condition="0==1"
	if id<>"" then
	rs.close
	strSql="select roleid from user_rolerel where userid="&id
	rs.open strSql ,conn,1,1
	while not rs.eof
		condition=condition &" ||"&" role.options[i].value=="&rs("roleid")
		rs.movenext
	wend

	%>
<script>
	var role=document.forms[0].role;
	for(var i=0;i<role.options.length;i++){
		if(<%=condition%>){
			role.options[i].selected="true";
		}
	}
	var bu=document.forms[0].bu;
	bu.value='<%=bu%>';
	
	<% while not rsZone.eof%>
	$("input:checkbox[name='zoneid']").each(function(index){
			if($(this).val()=='<%=rsZone("zoneid")%>'){
				$(this).attr("checked",true); 
				return;
			}
		});
	<% 
		rsZone.movenext
		wend
	%>
	var zoneid=document.forms[0].zoneid;
	zoneid.value='<%=zoneid%>';
	</script>
<%
end if
%>
<%
	if bclose then
		rs.close
		set rs=Nothing
		rsZone.close
		set rsZone=nothing
	end if
	rsrole.close
	set rsrole=Nothing

	CloseDatabase
%>
<!--#include file="../footer.asp"-->
</FORM>
</div>
</BODY>
</HTML>
