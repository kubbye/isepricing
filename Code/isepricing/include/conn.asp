<%
Dim strSQLServerName
Dim strSQLDBUserName
Dim strSQLDBPassword
Dim strSQLDBName
Dim conn
Dim StrConn

'����д���ݿ�������
'-----------------------------------------------------------------------------------------------
strSQLServerName = "127.0.0.1"      '���������ƻ��ַ
strSQLDBUserName = "sa"             '���ݿ��ʺ�
strSQLDBPassword = "123456"               '���ݿ�����
strSQLDBName = "yanghong_test"             '���ݿ�����


'strSQLServerName = "61.152.107.124"      '���������ƻ��ַ
'strSQLDBUserName = "yanghong"             '���ݿ��ʺ�
'strSQLDBPassword = "3RVemriBZ4"               '���ݿ�����
'strSQLDBName = "yanghong"             '���ݿ�����
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