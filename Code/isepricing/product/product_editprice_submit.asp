<!--#include file="../include/conn.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../quotation/waitforcheck.asp"-->

<%
bu = request("bu")
pid = request("pid")
targetprice = request("targetprice")
standardprice = request("standardprice")
vcurrency = request("currency")
otherdiscount = request("otherdiscount")
remark = request("remark")
freight = request("freight")
inst = request("inst")
apptraining = request("apptraining")
warr = request("warr")
standardphilipscount = request("standardphilipscount")
options1philipscount = request("options1philipscount")
dynamiccount = request("dynamiccount")



'conn.BeginTrans    '开始一个事务

'更新产品主表
sql = "update product set currency='" & vcurrency & "', targetprice=" & targetprice & ", standardprice=" & standardprice & ", otherdiscount=" & otherdiscount & ", remark='" & remark & "', freight='" & freight & "', inst='" & inst & "', warr='" & warr & "', apptraining='" & apptraining & "', updtuser='" & session("userid") & "', updttime='" & getdate() & "' where pid=" & pid
conn.execute(sql)

'更新标准philips配件
sql = "update product_detail_philips set targetprice=listprice, discount=1, updtuser='" & session("userid") & "', updttime='" & getdate() & "' where type='0' and pid=" & pid
conn.execute(sql)


'更新选装一philips配件
For i = 0 To options1philipscount - 1
	pdid = request("options1philips_pdid" & i)
	discount = request("options1philips_discount" & i)
	If discount = "" Then
		discount = 1
	End If 

	sql = "update product_detail_philips set targetprice=listprice*" & discount & ", discount=" & discount & ", updtuser='" & session("userid") & "', updttime='" & getdate() & "' where pdid=" & pdid
	conn.execute(sql)
Next

'插入动态折扣
sql = "delete from product_option_discount where pid=" & pid
conn.execute(sql)
For i = 0 To dynamiccount - 1
	items = request("dynamic_items" & i)
	options = request("dynamic_options" & i)
	discount = request("dynamic_discount" & i)
	
	If items <> "" Then 
		sql = "insert into product_option_discount (pid, type, items, options, discount, crtuser, crttime) values (" & pid & ", '0', '" & items & "', '" & options & "', " & discount & ", '" & session("userid") & "', '" & getdate() & "')"
		conn.execute(sql)
	End If 
Next 

sql = "select * from product where pid=" & pid
Set rs = conn.execute(sql)

If rs("version") = getversion(0) Then
	makeWaitForCheckProduct(rs("productname"))
End If 

'If conn.errors.count = 0 Then
'	conn.CommitTrans
'Else
'	conn.RollbackTrans
'End If
%>

<script language="javascript">
  alert ("Operation success!");
  location.assign("product_search.asp?status=-1&bu=<%=bu%>");
</script>