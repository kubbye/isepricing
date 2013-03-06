<!--#include file="../include/conn.asp"-->
<!--#include file="../include/constant.asp"-->

<%
'-------------------------------------------
'//禁止缓存该页 让AJAX读取该页始终为最新而非过期缓存页
Response.Expires = 0 
Response.Expiresabsolute = Now() - 1 
Response.AddHeader "pragma","no-cache" 
Response.AddHeader "cache-control","private" 
Response.CacheControl = "no-cache"
'-------------------------------------------
response.Charset="GB2312" '//数据返回的编码类型 显示中文数据必须
'-------------------------------------------

'在这里还可以进行一大堆数据库操作。
bu = request("bu")
modality = request("modality")
If bu = "" Then
	bu = 0
End If 
sql = "select * from modality where status='0' and bu=" & bu
Set rs = conn.execute(sql)
%>

<select name="modality">
	<option value=""></option>
	<%
	While Not rs.eof
	%>
	  <option value="<%=rs("mid")%>" <%If modality = CStr(rs("mid")) Then %> selected <% End If %>><%=rs("modality")%></option>
	<%
		rs.movenext
	Wend 
	%>
</select>