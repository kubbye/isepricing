
<%
	hostAddr="http://" & request.ServerVariables("SERVER_NAME")
	url=request.ServerVariables("PATH_INFO")
	a=split(url,"/")
	url=a(1)
	hostAddr=hostAddr & "/" & url
 %>

<%
	if session("userid")="" or session("username")="" then
		response.Write("<script>alert('�����µ�¼');</script>")
		response.Redirect(hostAddr & "/close.asp")
	end if 
%>
