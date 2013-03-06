<!--#include file="../include/conn.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/sendMail.asp"-->
<!--#include file="../include/constant.asp"-->

<%
bu = request("bu")
version = getversion("1")
roleid = request("roleid")


'conn.BeginTrans    '开始一个事务

If roleid = 2 Then 
	'specialist submit
	sql = "update product set status='3', specialisttime='" & getdate() & "', updtuser='" & session("userid") & "', updttime='" & getdate() & "' where status='2' and version='" & version & "' and mid in (select mid from modality where bu=" & bu & ") and crtuser='" & session("userid") & "'"
	conn.execute(sql)
	Call sendmailpmsubmit(version, bu)
ElseIf roleid = 3 Then 
	'PM submit

	'更新此BU未提交给PM的产品状态为无效
	sql = "update product set state='1', updtuser='" & session("userid") & "', updttime='" & getdate() & "' where version='" & version & "' and mid in (select mid from modality where bu=" & bu & ") and status='2'"
	conn.execute(sql)

	'给所有未设置价格的产品设置价格
	sql = "update product_detail_philips set targetprice=listprice, discount=1, updtuser='" & session("userid") & "', updttime='" & getdate() & "' where discount is null and pid in (select pid from product where state='0' and version='" & version & "' and mid in (select mid from modality where bu=" & bu & "))"
	conn.execute(sql)

	'更新没有TARGETPRICE的产品表的targetprice和standardprice
	sql = "select * from product where targetprice is null and state='0' and version='" & version & "' and mid in (select mid from modality where bu=" & bu & ") and status='3'"
	Set rs = conn.execute(sql)
	While Not rs.eof
		targetprice = 0
		standardprice = 0
		sql = "select sum(targetprice) targetprice, type from product_detail_philips where pid=" & rs("pid") & " group by type"
		Set rsdetail = conn.execute(sql)
		While Not rsdetail.eof
			If rsdetail("type") = "0" Then
				standardprice = standardprice + rsdetail("targetprice")
			End If 
			targetprice = targetprice + rsdetail("targetprice")
			rsdetail.movenext
		Wend 
		sql = "select sum(unitcost) unitcost, type from product_detail_3rd where pid=" & rs("pid") & " group by type"
		Set rsdetail = conn.execute(sql)
		While Not rsdetail.eof
			If rsdetail("type") = "0" Then
				standardprice = standardprice + rsdetail("unitcost")
			End If 
			targetprice = targetprice + rsdetail("unitcost")
			rsdetail.movenext
		Wend 

		sql = "update product set targetprice=" & targetprice & ", standardprice=" & standardprice & " from product where pid=" & rs("pid")
		conn.execute(sql)
		rs.movenext
	Wend 

	'更新产品表
	sql = "update product set status='4', pmtime='" & getdate() & "', updtuser='" & session("userid") & "', updttime='" & getdate() & "' where state='0' and version='" & version & "' and mid in (select mid from modality where bu=" & bu & ") and status='3'"
	conn.execute(sql)

	Call sendmailbudirectorsubmit(version, bu)

ElseIf roleid = 1 Then 
	'Pricing submit
	sql = "update product set status='5', pricetime='" & getdate() & "', updtuser='" & session("userid") & "', updttime='" & getdate() & "' where version='" & version & "' and mid in (select mid from modality where bu=" & bu & ") and state='0'"
	conn.execute(sql)

	Call sendmailpricingsubmit(version, bu)
ElseIf roleid = 4 Then 
	'Marketing Director submit
	sql = "select * from product where version='" & version & "' and mid in (select mid from modality where bu=" & bu & ") and state='0'"
	Set rs = conn.execute(sql)
	If Not rs.eof Then
		status = rs("status")
		If status <> "7" Then
			'FA没有审批通过
			sql = "update product set status='6', directortime='" & getdate() & "', updtuser='" & session("userid") & "', updttime='" & getdate() & "' where version='" & version & "' and mid in (select mid from modality where bu=" & bu & ") and state='0'"
			conn.execute(sql)
		Else
			'FA审批通过
			sql = "update product set status='8', directortime='" & getdate() & "', updtuser='" & session("userid") & "', updttime='" & getdate() & "' where version='" & version & "' and mid in (select mid from modality where bu=" & bu & ") and state='0'"
			conn.execute(sql)
		End If 
	End If 

	Call sendmailfcmdapproved(version, bu, "MD")
ElseIf roleid = 6 Then 
	'FA submit
	sql = "select * from product where version='" & version & "' and mid in (select mid from modality where bu=" & bu & ") and state='0'"
	Set rs = conn.execute(sql)
	If Not rs.eof Then
		status = rs("status")
		If status <> "6" Then
			'Director没有审批通过
			sql = "update product set status='7', finacetime='" & getdate() & "', updtuser='" & session("userid") & "', updttime='" & getdate() & "' where version='" & version & "' and mid in (select mid from modality where bu=" & bu & ") and state='0'"
			conn.execute(sql)
		Else
			'Director审批通过
			sql = "update product set status='8', finacetime='" & getdate() & "', updtuser='" & session("userid") & "', updttime='" & getdate() & "' where version='" & version & "' and mid in (select mid from modality where bu=" & bu & ") and state='0'"
			conn.execute(sql)
		End If 
	End If 

	Call sendmailfcmdapproved(version, bu, "FC")
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