<!--#include file="include/conn.asp"-->
<%
Public function HTMLEncode(fString)
  fString=replace(fString,";","&#59;")
  fString=server.htmlencode(fString)
  fString=replace(fString,"'","&#39;")
  fString=replace(fString,"--","&#45;&#45;")
  fString=replace(fString,"\","&#92;")
  fString=replace(fString,vbCrlf,"<br>")
  HTMLEncode=fString
end function

Public function UnHTMLEncode(fString)
  fString=replace(fString,"&#59;", ";")
  fString=replace(fString,"&#39;","'")
  fString=replace(fString,"&#45;&#45;","--")
  fString=replace(fString,"&#92;","\")
  fString=replace(fString,"<br>",vbCrlf)
  UnHTMLEncode=fString
end function

username=HTMLEncode(trim(request("username")))
password=HTMLEncode(trim(request("password")))
sql="select a.*,b.roleid from userinfo a left join user_rolerel b on a.id=b.userid  where a.userid='"&username&"'" ' and password='"&password&"'"
set rs=conn.execute(sql)

if rs.eof then
  	Response.write"<script language='JavaScript'> alert ('Sorry,username  is wrong'); location.href='index.asp';</script>"
 	response.end
Else
		dbPwd=rs("password")
		If dbPwd<>password Then
			Response.write"<script language='JavaScript'> alert ('Sorry,password  is wrong'); location.href='index.asp';</script>"
 			response.end
		End if
		session("principleid")=rs("id")
		session("userid")=rs("userid")
 		session("username")=rs("username")
 	 	session("password")=rs("password")
		session("roleid")=rs("roleid")
		session("user_bu")=rs("bu")
		session("email")=rs("email")
 ' session("UserType")=rs("UserType")
end If

'-----login-sso-----
'username=Request.servervariables("HTTP_USERID")
'sql="select * from userinfo where username='"&username&"'"
'set rs=conn.execute(sql)

'if not rs.eof then 
'  session("UserName")=rs("username")
'  session("UserType")=rs("UserType")
' Else 
 '  Response.write"<script language='JavaScript'> alert ('Sorry,username or password is wrong'); location.href='index.asp';
   'response.end
'End If 
	
	sql="select b.zonename,b.zid zoneid from user_zonerel a,zone b  where a.zoneid=b.zid and a.userid="&session("principleid")
	set rs1=conn.execute(sql)
	Dim zoneindex,zonecontact,zoneidcontract
	while  not rs1.eof 
		If zoneindex=0 then
			zonecontact=rs1("zonename")
			zoneidcontract=rs1("zoneid")
		Else
			zonecontact=zonecontact&","&rs1("zonename")
			zoneidcontract=zoneidcontract& "," & rs1("zoneid")
		End If
		zoneindex=zoneindex+1
		rs1.movenext
	wend
	session("userzone")=zonecontact
	session("zoneidcontract")=zoneidcontract
	
	rs.close
	set rs=nothing
	rs1.close
	set rs1=nothing
	CloseDatabase
%>

<script language="javascript">
  //location.href='main.asp';
  location.href='rule.asp';
</script>