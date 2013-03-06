<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="../include/conn.asp"-->
<!--#include file="utils.asp"-->
<!--#include file="../include/commons.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="roleutils.asp"-->
<%
	dim str,id,funname,fundesc,funorder,parent,validflag,url
	id=request("id")
	funname=request("funname")
	fundesc=request("fundesc")
	funorder=request("funorder")
	parent=request("parent")
	validflag=request("validflag")
	isleaf=request("isleaf")
	url=request("funurl")
	url=replace(url,"\","/")
	
	if id<>"" then 
		str="update functiontree set funname='"&funname&"',fundesc='"&fundesc&"',funurl='"&url&"',isleaf=" & isleaf & ",parentid= "&parent 	
		if funorder<>"" then
			str=str&",funorderid="&funorder
		end if
		if validflag<>"" then
			str=str&",validflag="&validflag
		end if
		str=str&" where funid="&id
	else
		if isHaveFunction(funname)=true then
			closeAll
			response.Write("<script>alert('²Ëµ¥ÒÑ´æÔÚ£¡');history.back();</script>")
			response.End()
		end if
	
		if funorder="" then 
			funorder="9999"
		end if
		str="insert into functiontree(funname,fundesc,funurl,funorderid,validflag,parentid,isleaf) values('"
		str=str&funname&"','"&fundesc&"','"&url&"',"&funorder&","&validflag&","&parent&","& isleaf &")"
	end if
	conn.execute str
	
	
	call writeFuncByRoleId ("")
	for i=1 to 20 
		call writeFuncByRoleId (i)
	next
	
	CloseDatabase
	response.Redirect("functionManager.asp")
%>
