<!--#include file="../include/conn.asp"-->
<!--#include file="../include/constant.asp"-->

<%
'-------------------------------------------
'//��ֹ�����ҳ ��AJAX��ȡ��ҳʼ��Ϊ���¶��ǹ��ڻ���ҳ
Response.Expires = 0 
Response.Expiresabsolute = Now() - 1 
Response.AddHeader "pragma","no-cache" 
Response.AddHeader "cache-control","private" 
Response.CacheControl = "no-cache"
'-------------------------------------------
response.Charset="GB2312" '//���ݷ��صı������� ��ʾ�������ݱ���
'-------------------------------------------

'�����ﻹ���Խ���һ������ݿ������
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