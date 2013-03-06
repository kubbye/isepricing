<!--#include file="../include/conn.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="waitforcheck.asp"-->
<%

	makeWaitForCheck
	CloseDatabase
	response.write("<script>location.href='quotationList.asp'</script>")
%>
