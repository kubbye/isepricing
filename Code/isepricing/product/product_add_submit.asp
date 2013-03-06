<!--#include file="../include/conn.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/chkUser.asp"-->

<%
bu = request("bu")
modality = request("modality")
product = request("product")
'targetprice = request("targetprice")
standardphilipscount = request("standardphilipscount")
standard3rdcount = request("standard3rdcount")
options1philipscount = request("options1philipscount")
options3rdcount = request("options3rdcount")

conn.BeginTrans    '开始一个事务

'插入产品主表
sql = "insert into product (productname, mid, state, status, standardprice, targetprice, version, crtuser, crttime, updtuser, updttime) values ('" & product & "', " & modality & ", '0', '2', 0, 0, '" &  getversion("1") & "', '" & session("userid") & "', '" & getdate() & "', '" & session("userid") & "', '" & getdate() & "')"
conn.execute(sql)

'得到插入数据的ID
sql = "select max(pid) pid from product"
Set rs = conn.execute(sql)
pid = rs("pid")

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
		
		sql = "insert into product_detail_philips (pid, cid, type, sortno, materialno, description, listprice, targetprice, discount,  qty, mutex, crtuser, crttime) values (" & pid & ", " & cid & ", '0', " & sortno & ", '" & materialno & "', '" & description & "', " & listprice & ", " & listprice & ", 1, " & qty & ", '" & mutex & "', '" & session("userid") & "', '" & getdate() & "')"
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
		
		sql = "insert into product_detail_philips (pid, cid, type, sortno, items, materialno, description, listprice, targetprice, discount, qty, mutex, crtuser, crttime) values (" & pid & ", " & cid & ", '1', " & sortno & ", '" & items & "', '" & materialno & "', '" & description & "', " & listprice & ", " & listprice &  ", 1, " & qty & ", '" & mutex & "', '" & session("userid") & "', '" & getdate() & "')"
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

If conn.errors.count = 0 Then
	conn.CommitTrans
Else
	conn.RollbackTrans
End If
%>

<script language="javascript">
  alert ("Operation success!");
  location.assign("product_search.asp?status=-1&bu=<%=bu%>");
</script>