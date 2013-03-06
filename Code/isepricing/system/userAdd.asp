<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="../include/conn.asp" -->
<!--#include file="utils.asp"-->
<!--#include file="../include/chkUser.asp"-->
<%
	dim id,strSql,strRel,strId,username,userid,email,tel,roles,asp,aspno,aspname
	id=request("id")
	userid=request("userid")
	username=request("username")
	email=request("email")
	tel=request("tel")
	roles=split(request("role"),",") 
	bu=request("bu")
	zoneids=request("zoneids")
	pwd=request("pwd")
	
	if id<>"" then 
		strSql="update userinfo set username='"&username&"',password='"&pwd&"',email='"&email&"',mobile='"&tel&"',bu='"&bu&"',updtuser='"&session("principleid")&"',updttime=getdate() where id="&id
	else
		if isHaveUser(userid,username)=true then
			clsoeAll
			response.Write("<script>alert('用户已存在！');history.back();</script>")
			response.End()
		end if
		strSql="insert into userinfo(userid,username,email,mobile,validflag,crttime,password,bu,crtuser) values('"
		strSql=StrSql&userid&"','"&username&"','"&email&"','"&tel&"',1,getdate(),'"&pwd&"','"&bu&"','"&session("principleid")&"')"
	end if

	conn.execute strSql
	strID="select IDENT_CURRENT('userinfo') as cals"
	if id="" then
		dim rs
		set rs=server.CreateObject("adodb.recordset")
		rs.open strId,conn,1,1
		id=rs("cals")
		rs.close
		set rs=Nothing
	end if
	'先删除所有关系
	strRel="delete from user_rolerel where userid="&id
	conn.execute strRel
	dim i
	for i=0 to Ubound(roles)
		strRel="insert into user_rolerel(userid,roleid) values("&id&","&roles(i)&")"
		conn.execute strRel
	next
	
	'zone
	strRel="delete from user_zonerel where userid="&id
		conn.execute strRel
	if not isempty(zoneids) and zoneids<>"" then
		zones=split(zoneids,",") 
		for i=0 to Ubound(zones)
			strRel="insert into user_zonerel(userid,zoneid) values("&id&","&zones(i)&")"
			response.Write(strrel)
			conn.execute strRel
		next
	end if
	CloseDatabase
	response.Redirect("userManager.asp")
%>
