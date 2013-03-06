<!--#include file="../include/conn.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../quotation/waitforcheck.asp"-->
<!--#include file="../include/sendMail.asp"-->
<!--#include file="../include/constant.asp"-->

<%

conn.BeginTrans    '开始一个事务

Dim version
version = getversion(1)

'将当前已生效的配件更新为已过期
sql = "update configurations set status='2', endtime='" & getdate() & "', updtuser='" & session("userid") & "', updttime='" & getdate() & "' where status='0'"
conn.execute(sql)

'将旧的生效中的版本号更新为已过期
sql = "update versionset set status='2', endtime='" & getdate() & "', updtuser='" & session("userid") & "', updttime='" & getdate() & "' where status='0'"
conn.execute(sql)

'将生效中的产品更新为已过期
sql = "update product set status='1', endtime='" & getdate() & "', updtuser='" & session("userid") & "', updttime='" & getdate() & "' where status='0'"
conn.execute(sql)

'将未生效的配件更新为已生效
sql = "update configurations set status='0', starttime='" & getdate() & "', updtuser='" & session("userid") & "', updttime='" & getdate() & "' where status='1'"
conn.execute(sql)

'将未生效的版本号更新为已生效
sql = "update versionset set status='0', starttime='" & getdate() & "', updtuser='" & session("userid") & "', updttime='" & getdate() & "' where status='1'"
conn.execute(sql)

'将未生效的产品更新为已生效
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