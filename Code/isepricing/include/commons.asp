<%
	hostAddr="http://" & request.ServerVariables("SERVER_NAME")
	url=request.ServerVariables("PATH_INFO")
	a=split(url,"/")
	url=a(1)
	hostAddr=hostAddr & "/" & url
 %>


<link rel=stylesheet href="<%= hostAddr %>/js/mg5/examples/TB.css" type="text/css">

