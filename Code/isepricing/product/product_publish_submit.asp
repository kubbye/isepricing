<!--#include file="../include/conn.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../quotation/waitforcheck.asp"-->
<!--#include file="../include/sendMail.asp"-->
<!--#include file="../include/constant.asp"-->

<%

conn.BeginTrans    '��ʼһ������

Dim version
version = getversion(1)

'����ǰ����Ч���������Ϊ�ѹ���
sql = "update configurations set status='2', endtime='" & getdate() & "', updtuser='" & session("userid") & "', updttime='" & getdate() & "' where status='0'"
conn.execute(sql)

'���ɵ���Ч�еİ汾�Ÿ���Ϊ�ѹ���
sql = "update versionset set status='2', endtime='" & getdate() & "', updtuser='" & session("userid") & "', updttime='" & getdate() & "' where status='0'"
conn.execute(sql)

'����Ч�еĲ�Ʒ����Ϊ�ѹ���
sql = "update product set status='1', endtime='" & getdate() & "', updtuser='" & session("userid") & "', updttime='" & getdate() & "' where status='0'"
conn.execute(sql)

'��δ��Ч���������Ϊ����Ч
sql = "update configurations set status='0', starttime='" & getdate() & "', updtuser='" & session("userid") & "', updttime='" & getdate() & "' where status='1'"
conn.execute(sql)

'��δ��Ч�İ汾�Ÿ���Ϊ����Ч
sql = "update versionset set status='0', starttime='" & getdate() & "', updtuser='" & session("userid") & "', updttime='" & getdate() & "' where status='1'"
conn.execute(sql)

'��δ��Ч�Ĳ�Ʒ����Ϊ����Ч
sql = "update product set status='0', starttime='" & getdate() & "', updtuser='" & session("userid") & "', updttime='" & getdate() & "' where status='8'"
conn.execute(sql)

makeWaitForCheck()

If conn.errors.count = 0 Then
	conn.CommitTrans
	Call sendmailpublish(version)
Else
	conn.RollbackTrans
End If 
%>

<script language="javascript">
  alert ("Operation success!");
  location.assign("product_search.asp");
</script>