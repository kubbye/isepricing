<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!--#include file="include/conn.asp"-->
<!--#include file="include/constant.asp"-->
<!--#include file="include/sendMail.asp"-->
<%
Dim flag
flag = "1"
userid = request("username")

sql = "select * from userinfo where validflag='1' and userid='" & userid & "'"
Set rs = conn.execute(sql)

If rs.eof Then
	' 不存在此用户
	flag = "0"
Else 
	sendmailfindpassword(userid)
End If 

If flag = "0" Then 
%>
<script language="javascript">
  alert ("User name error!");
  location.assign("forgetpwd.asp");
</script>
<%
Else 
%>
<script language="javascript">
  alert ("Please check E-mail!");
  location.assign("index.asp");
</script>
<%
End If 
%>