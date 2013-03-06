<!--#include file="../include/conn.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../quotation/waitforcheck.asp"-->

<%
pid = request("pid")
bu = request("bu")
modality = request("modality")
product = request("product")
targetprice = request("targetprice")
remark = request("remark")
standardphilipscount = request("standardphilipscount")
standard3rdcount = request("standard3rdcount")
options1philipscount = request("options1philipscount")
options3rdcount = request("options3rdcount")

'conn.BeginTrans    '开始一个事务

'更新产品主表
sql = "update product set productname='" & product & "', mid=" & modality & ", remark='" & remark & "', updtuser='" & session("userid") & "', updttime='" & getdate() & "' where pid=" & pid
conn.execute(sql)

If session("roleid") = 2 Then 
	sql = "update product set crtuser='" & session("userid") & "' where pid=" & pid
	conn.execute(sql)
End If 

sql = "delete from product_detail_philips where pid=" & pid
conn.execute(sql)
sql = "delete from product_detail_3rd where pid=" & pid
conn.execute(sql)

'插入标准philips配件
For i = 0 To standardphilipscount - 1
	If request("standardphilips_cid" & i) <> "" Then
		mutex = request("standardphilips_mutex" & i)
		sortno = request("standardphilips_sortno" & i)
		If sortno = "" Then
			sortno = 0
		End If 
		cid = request("standardphilips_cid" & i)
		materialno = request("standardphilips_materialno" & i)
		description = request("standardphilips_description" & i)
		qty = request("standardphilips_qty" & i)
		listprice = request("standardphilips_listprice" & i)
		targetprice = request("standardphilips_targetprice" & i)
		If targetprice = "" Then
			targetprice = listprice
		End If 
		discount = request("standardphilips_discount" & i)
		If discount = "" Then
			discount = 1
		End If 
		
		sql = "insert into product_detail_philips (pid, cid, type, sortno, materialno, description, listprice, targetprice, discount, qty, mutex, crtuser, crttime) values (" & pid & ", " & cid & ", '0', " & sortno & ", '" & materialno & "', '" & description & "', " & listprice & ", " & targetprice & ", " & discount & ", " & qty & ", '" & mutex & "', '" & session("userid") & "', '" & getdate() & "')"
		conn.execute(sql)
	End If 
Next 

'插入标准第三方配件
For i = 0 To standard3rdcount - 1
	If request("standard3rd_itemname" & i) <> "" Then
		cid = request("standard3rd_cid" & i)
		mutex = request("standard3rd_mutex" & i)
		materialno = request("standard3rd_itemcode" & i)
		itemname = request("standard3rd_itemname" & i)
		qty = request("standard3rd_qty" & i)
		unitcost = request("standard3rd_unitcost" & i)
		unitcostrmb = request("standard3rd_unitcostrmb" & i)
		
		If cid <> "" Then 
			sql = "insert into product_detail_3rd (pid, cid, type, materialno, itemname, unitcost, unitcostrmb, qty, mutex, crtuser, crttime) values (" & pid & ", " & cid & ", '0', '" & materialno & "', '" & itemname & "', " & unitcost & ", " & unitcostrmb & ", " & qty & ", '" & mutex & "', '" & session("userid") & "', '" & getdate() & "')"
		Else 
			sql = "insert into product_detail_3rd (pid, type, itemname, unitcost, unitcostrmb, qty, mutex, crtuser, crttime) values (" & pid & ", '0', '" & itemname & "', " & unitcost & ", " & unitcost & ", " & qty & ", '" & mutex & "', '" & session("userid") & "', '" & getdate() & "')"
		End If 
		conn.execute(sql)
	End If 
Next 

'插入选装一philips配件
For i = 0 To options1philipscount - 1
	If request("options1philips_cid" & i) <> "" Then
		mutex = request("options1philips_mutex" & i)
		sortno = request("options1philips_sortno" & i)
		If sortno = "" Then
			sortno = 0
		End If 
		items = request("options1philips_items" & i)
		cid = request("options1philips_cid" & i)
		materialno = request("options1philips_materialno" & i)
		description = request("options1philips_description" & i)
		qty = request("options1philips_qty" & i)
		listprice = request("options1philips_listprice" & i)
		targetprice = request("options1philips_targetprice" & i)
		If targetprice = "" Then
			targetprice = listprice
		End If 
		discount = request("options1philips_discount" & i)
		If discount = "" Then
			discount = 1
		End If 
		
		sql = "insert into product_detail_philips (pid, cid, type, sortno, items, materialno, description, listprice, targetprice, discount, qty, mutex, crtuser, crttime) values (" & pid & ", " & cid & ", '1', " & sortno & ", '" & items & "', '" & materialno & "', '" & description & "', " & listprice & ", " & targetprice & ", " & discount & ", " & qty & ", '" & mutex & "' , '" & session("userid") & "', '" & getdate() & "')"
		conn.execute(sql)
	End If 
Next 

'插入选装第三方配件
For i = 0 To options3rdcount - 1
	If request("options3rd_cid" & i) <> "" Then
		cid = request("options3rd_cid" & i)
		itemname = request("options3rd_itemname" & i)
		materialno = request("options3rd_itemcode" & i)
		qty = request("options3rd_qty" & i)
		unitcost = request("options3rd_unitcost" & i)
		unitcostrmb = request("options3rd_unitcostrmb" & i)
		
		sql = "insert into product_detail_3rd (pid, cid, type, materialno, itemname, unitcost, unitcostrmb, qty, crtuser, crttime) values (" & pid & ", " & cid & ", '1', '" & materialno & "', '" & itemname & "', " & unitcost & ", " & unitcostrmb & ", " & qty & ", '" & session("userid") & "', '" & getdate() & "')"
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