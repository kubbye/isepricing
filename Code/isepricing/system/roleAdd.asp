<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="../include/conn.asp"-->
<!--#include file="utils.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="roleutils.asp"-->
<%
	dim strrole,strrolefun,funstr,funs,rolename,roledesc,validflag,id
	id=request("id")

	funstr=request("funs")
	rolename=request("RoleName")
	roledesc=request("roledesc")
	validflag=request("validflag")


	
	funs=split(funstr,",")
	
	if id="" then
		if isHaveRole(rolename)=true then
			clsoeAll
			response.Write("<script>alert('½ÇÉ«ÒÑ´æÔÚ£¡');history.back();</script>")
			response.End()
		end if
		strrole="insert into rolemsg (rolename,roledesc,validflag) values('"
		strrole=strrole &rolename&"','"&roledesc&"',"&validflag&")"
	else
		strrole="update rolemsg set rolename='"&rolename&"',roledesc='"&roledesc&"',validflag="&validflag&"  where roleid="&id
		
	end if

	conn.execute strrole

	if id="" then
		dim rs
		set rs=server.CreateObject("adodb.recordset")
		rs.open "select IDENT_CURRENT('rolemsg') as id" ,conn,1,1
		if not rs.eof and not rs.bof then
			id=rs("id")
		end if
		rs.close
		set rs=Nothing
	end if
	dim strdel
		strdel="delete from role_funcrel where roleid="&id
		conn.execute strdel

		for i=0 to ubound(funs)
			if funs(i)<>"" then
				strrolefun="insert into role_funcrel (roleid,funid) values("&id&","&funs(i)&")"
				conn.execute strrolefun
			end  if
		next
		
		call writeFuncByRoleId(id)
	CloseDatabase
	response.Redirect("roleManager.asp")
%>
