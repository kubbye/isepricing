<!--#include file="../include/conn.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/chkUser.asp"-->

<%
pid = request("pid")
count = request("count")

conn.BeginTrans    '开始一个事务

'删除产品的原动态折扣
sql = "delete from product_option_discount where pid=" & pid
conn.execute(sql)

'插入产品的新动态折扣
For i = 1 To count
	If Not request("mainoption" & i) = "" Then 
		mainoption = request("mainoption" & i)
		lesseroption = request("lesseroption" & i)
		discount = request("discount" & i)
		sql = "insert into product_option_discount (pid, type, mainoption, lesseroption, discount, crtuser, crttime) values (" & pid & ", '0', '" & mainoption & "', '" & lesseroption & "', " & discount & ", '" & session("userid") & "', '" & getdate() & "')"
		conn.execute(sql)
	End If 
Next 

If conn.errors.count = 0 Then
	conn.CommitTrans
Else
	conn.RollbackTrans
End If
%>

<script language="javascript">
  alert ("Operation success!");
  location.assign("product_editprice_discount.asp?pid=<%=pid%>");
</script>