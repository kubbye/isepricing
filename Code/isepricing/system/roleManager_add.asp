<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="../include/conn.asp" -->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/commons.asp"-->

<%
	dim id,strSql,rs,rolename,roledesc,validflag,bclose
	id=request("id")
	if id<>"" then
		strSql="select * from rolemsg a where roleid="&id
		set rs=server.createObject("adodb.recordset")
		rs.open strSql,conn,1,1
		rolename=rs("rolename")
		roledesc=rs("roledesc")
		validflag=rs("validflag")
		bclose=true
	end if
%>c
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
	var nodes=document.treeframe.selectnode;
	var funs="";
	for(var i=0;i<nodes.length;i++){
		if(nodes[i].checked){
			funs +=nodes[i].value+",";
		}
	}
      document.form1.action="roleAdd.asp?funs="+funs;      
	  document.form1.submit();
   }

   function restData() {
      document.form1.reset();
   }
   function checkForm(form){
   		var n=form.RoleName;
		if(n.value==null || n.value==""){
			alert("Please input Role Name!");
			n.focus();
			return false;
		}
		return true;
   }
 </SCRIPT>

<META content="MSHTML 6.00.2900.3314" name=GENERATOR></HEAD>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0">
<FORM name=form1 action="roleAdd.asp" method=post>
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
             <td class="titleorange"><div align="center">Add Role </div></td>
            </TR>
            <TR>
              <td class="titleorange">&nbsp;</td>
            </TR>
  
          <TR >
      <td valign="top" class="line01" > <table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
        <TR class="line01" >
          <TD class=tdLabel vAlign=center align=left 
          width="15%">Role Name:
		  </TD>
          <TD align="left" vAlign=center width="30%">
		  <INPUT name=RoleName id="RoleName" value="<%=rolename%>"> 
				</TD></TR>
        <TR class="line01" >
          <TD class=tdLabel vAlign=center align=left 
          width="15%">Description:</TD>
          <TD align="left" vAlign=center width="30%">
		  <INPUT name=roledesc id="roledesc" value="<%=roledesc%>"> 
          </TD></TR>
        <TR class="line01">
          <TD class=tdLabel vAlign=center align=left 
          width="15%">Status:</TD>
          <TD align="left" vAlign=center width="30%">
					<select name="validflag" >
					<option value="1">Valid</option>
					<option value="0">Invalid</option>
					</select> </TD></TR>
  <tr class="line01"> <td colspan="2">
		 <FIELDSET style="WIDTH: 98%" align=center><LEGEND>Function Select</LEGEND>
			 	<iframe name="treeframe" scrolling="auto" src="functiontree.asp" frameborder="0" style="width:100%;height:250px"></iframe>
		 	         </FIELDSET>
	</TD></TR>
	  <tr bgcolor="white"> 
                  <td colspan="2">&nbsp;</td>
                </tr>
        <TR bgcolor="white">
          <TD colSpan=2><div align="right"> 
		  <INPUT class=lankuang onclick=restData() type=button value=Reset> 
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

<!--#include file="../footer.asp"-->
</FORM>
</div>

</BODY></HTML>
<!--设置选中菜单项-->
<script>
	function invoke(){
<%
	if id<>"" then
		dim rsRel ,strRel,condition
		condition="0==1"
		strRel ="select * from role_funcrel where roleid="&id
		set rsRel=server.CreateObject("adodb.recordset")
		rsRel.open strRel,conn,1,1
		while not rsRel.eof
			condition=condition & " || "&"obj.value=="&rsRel("funid")
			rsRel.movenext
		wend
%>

			var cnodes=document.treeframe.selectnode;
			for(var i=0;i<cnodes.length;i++){
				var obj=cnodes[i];
				if(<%=condition%>){
					obj.checked=true;
				}
			}
		

<%
	end if
%>
}
</script>
<%
	if bclose then 
		rs.close
		set rs=Nothing
	end if
	
	CloseDatabase
%>
