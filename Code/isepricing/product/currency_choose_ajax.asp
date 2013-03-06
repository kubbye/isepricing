<!--#include file="../include/conn.asp"-->
<!--#include file="../include/constant.asp"-->

<%
Response.Expires = 0 
Response.Expiresabsolute = Now() - 1 
Response.AddHeader "pragma","no-cache" 
Response.AddHeader "cache-control","private" 
Response.CacheControl = "no-cache"
response.Charset="GB2312"

aa = request("currency")
If aa = "" Then
	aa = "RMB"
End If 
sql = "select * from exchanges where sourcecode='" & aa & "'"
Set rs = conn.execute(sql)
rate = 1
If Not rs.eof Then
	rate = rs("rate")
End If 
%>

<input type="hidden" name="currencyprice" value="<%=rate%>">