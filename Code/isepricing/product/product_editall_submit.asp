<!--#include file="../include/conn.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/chkUser.asp"-->

<%
pid = request("pid")
bu = request("bu")
modality = request("modality")
product = request("product")
targetprice = request("targetprice")
standardprice = request("standardprice")
remark = request("remark")
standardphilipscount = request("standardphilipscount")
standard3rdcount = request("standard3rdcount")
options1philipscount = request("options1philipscount")
options2philipscount = request("options2philipscount")
options3rdcount = request("options3rdcount")

conn.BeginTrans    '开始一个事务

'更新产品主表
sql = "update product set productname='" & product & "', mid=" & modality & ", targetprice=" & targetprice & ", standardprice=" & standardprice & ", remark='" & remark & "', updtuser='" & session("userid") & "', updttime='" & getdate() & "' where pid=" & pid
conn.execute(sql)

sql = "delete from product_detail_philips where pid=" & pid
conn.execute(sql)
sql = "delete from product_detail_3rd where pid=" & pid
conn.execute(sql)

'插入标准philips配件
For i = 0 To standardphilipscount - 1
	If request("standardphilips_cid" & i) <> "" Then
		items = request("standardphilips_items" & i)
		cid = request("standardphilips_cid" & i)
		materialno = request("standardphilips_materialno" & i)
		description = request("standardphilips_description" & i)
		qty = request("standardphilips_qty" & i)
		listprice = request("standardphilips_listprice" & i)
		discount = request("standardphilips_discount" & i)
		
		sql = "insert into product_detail_philips (pid, cid, type, items, materialno, description, listprice, qty, targetprice, discount, crtuser, crttime) values (" & pid & ", " & cid & ", '0', '" & items & "', '" & materialno & "', '" & description & "', " & listprice & ", " & qty & ", " & listprice*discount & ", " & discount & ", '" & session("userid") & "', '" & getdate() & "')"
		conn.execute(sql)
	End If 
Next 

'插入标准第三方配件
For i = 0 To standard3rdcount - 1
	If request("standard3rd_cid" & i) <> "" Then
		cid = request("standard3rd_cid" & i)
		materialno = request("standard3rd_itemname" & i)
		qty = request("standard3rd_qty" & i)
		unitcost = request("standard3rd_unitcost" & i)
		
		sql = "insert into product_detail_3rd (pid, cid, type, materialno, unitcost, qty, crtuser, crttime) values (" & pid & ", " & cid & ", '0', '" & materialno & "', " & unitcost & ", " & qty & ", '" & session("userid") & "', '" & getdate() & "')"
		conn.execute(sql)
	End If 
Next 

'插入选装一philips配件
For i = 0 To options1philipscount - 1
	If request("options1philips_cid" & i) <> "" Then
		mutex = request("options1philips_mutex" & i)
		items = request("options1philips_items" & i)
		cid = request("options1philips_cid" & i)
		materialno = request("options1philips_materialno" & i)
		description = request("options1philips_description" & i)
		qty = 0
		listprice = request("options1philips_listprice" & i)
		discount = request("options1philips_discount" & i)
		
		sql = "insert into product_detail_philips (pid, cid, type, items, materialno, description, listprice, qty, targetprice, discount, mutex, crtuser, crttime) values (" & pid & ", " & cid & ", '1', '" & items & "', '" & materialno & "', '" & description & "', " & listprice & ", " & qty & ", " & listprice*discount & ", " & discount & ", '" & mutex & "', '" & session("userid") & "', '" & getdate() & "')"
		conn.execute(sql)
	End If 
Next 

'插入选装二philips配件
For i = 0 To options2philipscount - 1
	If request("options2philips_cid" & i) <> "" Then
		mutex = request("options2philips_mutex" & i)
		items = request("options2philips_items" & i)
		cid = request("options2philips_cid" & i)
		materialno = request("options2philips_materialno" & i)
		description = request("options2philips_description" & i)
		qty = 0
		listprice = request("options2philips_listprice" & i)
		discount = request("options2philips_discount" & i)
		
		sql = "insert into product_detail_philips (pid, cid, type, items, materialno, description, listprice, qty, targetprice, discount, mutex, crtuser, crttime) values (" & pid & ", " & cid & ", '2', '" & items & "', '" & materialno & "', '" & description & "', " & listprice & ", " & qty & ", " & listprice*discount & ", " & discount & ", '" &  mutex & "', '" & session("userid") & "', '" & getdate() & "')"
		conn.execute(sql)
	End If 
Next 

'插入选装第三方配件
For i = 0 To options3rdcount - 1
	If request("options3rd_cid" & i) <> "" Then
		cid = request("options3rd_cid" & i)
		materialno = request("options3rd_itemname" & i)
		qty = 0
		unitcost = request("options3rd_unitcost" & i)
		
		sql = "insert into product_detail_3rd (pid, cid, type, materialno, unitcost, qty, crtuser, crttime) values (" & pid & ", " & cid & ", '1', '" & materialno & "', " & unitcost & ", " & qty & ", '" & session("userid") & "', '" & getdate() & "')"
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
  location.assign("product_search.asp");
</script>