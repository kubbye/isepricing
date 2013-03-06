
<!--#include file="../include/upload_5xsoft.inc"-->
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../quotation/waitforcheck.asp"-->
<!--#include file="../include/sendMail.asp"-->
<!--#include file="../include/constant.asp"-->
<%
dim upload,file,filepath,d
randomize   
d=date()
d=replace(d,"-","")
d=replace(d,".","")
d=d&int((1000000*rnd()))
d="party"
filepath=d&".xlsx"
'filepath=d&".xls"
set upload=new upload_5xSoft ''建立上传对象
for each formName in upload.file ''列出所有上传了的文件

 set file=upload.file(formName)  ''生成一个文件对象

 if file.FileSize>0 then         ''如果 FileSize > 0 说明有文件数据

  fname = file.filename
  file.SaveAs Server.mappath(filepath&fname)   ''保存文件
 end if
set file=nothing
next
set upload=nothing  ''删除此对象


'将excel中数据导入数据库中

	importParty(filepath)
	makeWaitForCheck()
	CloseDatabase

%>

<script language="javascript">
  alert ("Operation Success!");
  location.assign("party_search.asp");
</script>

<%
sub importParty(filename)
	'dim itemname, unitcost, maxversion, validversion, version, status
	Dim itemcode, itemname, unitcost, unitcostrmb, dealer, model, diliverydate, warranty, madein
	dim connExcel,strExcel,strsql,rs
	set connExcel=server.createObject("adodb.connection")
	strExcel="Provider=Microsoft.ACE.OLEDB.12.0;Data Source="&server.MapPath(filename)&";extended properties=Excel 12.0 Xml;"
	'strExcel="Provider=Microsoft.Jet.OLEDB.4.0;Data Source= "&server.MapPath(filename)&";Extended Properties=Excel 8.0;"
	connExcel.open strExcel

	conn.BeginTrans    '开始一个事务

	sql = "update party set state='1', status='2', endtime='" & getdate() & "', updtuser='" & session("userid") & "', updttime='" & getdate() & "' where state='0'"
	conn.execute(sql)

	strSql="select * from [sheet1$]"
	set rs=connExcel.execute(strSql)
	dim i
	while not rs.eof
		i=0
		itemcode = replacequot(rs.fields(i).value)
		i = i + 1
		itemname = replacequot(rs.fields(i).value)
		i = i + 1
		dealer = replacequot(rs.fields(i).value)
		i = i + 1
		unitcost = replacequot(rs.fields(i).value)
		i = i + 1
		unitcostrmb = replacequot(rs.fields(i).value)
		i = i + 1
		model = replacequot(rs.fields(i).value)
		i = i + 1
		diliverydate = replacequot(rs.fields(i).value)
		i = i + 1
		madein = replacequot(rs.fields(i).value)
		i = i + 1
		warranty = replacequot(rs.fields(i).value)

		strSql = "insert into party (itemcode, itemname, unitcost, unitcostrmb, dealer, model, diliverydate, warranty, madein, type, state, status, crtuser, crttime) values ('" & itemcode & "', '" & itemname & "', " & unitcost & ", " &  unitcostrmb & ", '" & dealer & "', '" & model & "', '" & diliverydate & "', '" & warranty & "', '" & madein & "', '0', '0', '0', '" & session("userid") & "', '" & getdate() & "')"

		'response.write strSql

		conn.execute(strSql)
		rs.movenext
	Wend
	
	If conn.errors.count = 0 And connExcel.errors.count = 0 Then
		conn.CommitTrans
		Call sendmail3rdupdate()
	Else
		conn.RollbackTrans
	End If 

	connExcel.close
	set connExcel=nothing	
end sub

	
function replacequot(str)
	if isnull(str) then
		replacequot=""
	else
		replacequot=replace(str,"'","''")
	end if
end function
%>