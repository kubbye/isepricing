<%
Dim strSQLServerName
Dim strSQLDBUserName
Dim strSQLDBPassword
Dim strSQLDBName
Dim conn
Dim StrConn

'请填写数据库具体参数
'-----------------------------------------------------------------------------------------------
strSQLServerName = "127.0.0.1"      '服务器名称或地址
strSQLDBUserName = "sa"             '数据库帐号
strSQLDBPassword = "123456"               '数据库密码
strSQLDBName = "yanghong_test"             '数据库名称


'strSQLServerName = "61.152.107.124"      '服务器名称或地址
'strSQLDBUserName = "yanghong"             '数据库帐号
'strSQLDBPassword = "3RVemriBZ4"               '数据库密码
'strSQLDBName = "yanghong"             '数据库名称
'-----------------------------------------------------------------------------------------------
Set conn = Server.CreateObject("ADODB.Connection")
StrConn="Provider=SQLOLEDB.1;Persist Security Info=False;User ID="&strSQLDBUserName&";Password="&strSQLDBPassword&";Initial Catalog="&strSQLDBName&";Data Source="&strSQLServerName&";Connect Timeout=3000000" 
conn.Open strConn

response.expires=0

function CloseDatabase
	conn.close
	Set conn = Nothing
End Function

%>