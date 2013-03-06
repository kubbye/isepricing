
<!--#include file="../include/upload_5xsoft.inc"-->
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/sendMail.asp"-->
<!--#include file="../include/constant.asp"-->
<%
dim upload,file,filepath,d,vyear, vquarter
randomize   
d=date()
d=replace(d,"-","")
d=replace(d,".","")
d=d&int((1000000*rnd()))
d="dashboard"
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
Next

vyear = upload.Form("vyear")
vquarter = upload.Form("vquarter")

set upload=nothing  ''删除此对象


'将excel中数据导入数据库中

Call importDashboard(filepath, version)
	CloseDatabase
%>

<script language="javascript">
  alert ("Operation Success!");
  location.assign("dashboard_upload.asp");
</script>

<%
sub importDashboard(filename, version)
	dim quotationno, targetprice, sapwbs, soldtoparty, productname, qty, businessmodel, region, oacm, billtoparty, productmanager, oit, bl, oitprice, extendedwarrenty, sales, philipsgoodscost, thirdpartycost, installation, sitepreparation, standardapplicationtraining, othercost, freight, gm, commission, warranty, gmpoint, netoit
	dim connExcel,strExcel,strsql,rs
	set connExcel=server.createObject("adodb.connection")
	strExcel="Provider=Microsoft.ACE.OLEDB.12.0;Data Source="&server.MapPath(filename)&";extended properties=Excel 12.0 Xml;"
	'strExcel="Provider=Microsoft.Jet.OLEDB.4.0;Data Source= "&server.MapPath(filename)&";Extended Properties=Excel 8.0;"
	connExcel.open strExcel

	conn.BeginTrans    '开始一个事务

	'清空此版本号的Dashboard数据
	strsql = "delete from dashboard where vyear='" & vyear & "' and vquarter='" & vquarter & "'"
	conn.execute(strsql)

	strSql="select * from [sheet1$]"
	set rs=connExcel.execute(strSql)
	dim i
	while not rs.eof
		i=0
		quotationno=replacequot(rs.fields(i).value)
		i = i + 1
		targetprice=replacequon(rs.fields(i).value)
		i = i + 1
		sapwbs=replacequot(rs.fields(i).value)
		i = i + 1
		soldtoparty=replacequot(rs.fields(i).value)
		i = i + 1
		productname=replacequot(rs.fields(i).value)
		i = i + 1
		qty=replacequon(rs.fields(i).value)
		i = i + 1
		businessmodel=replacequot(rs.fields(i).value)
		i = i + 1
		region=replacequot(rs.fields(i).value)
		i = i + 1
		oacm=replacequot(rs.fields(i).value)
		i = i + 1
		billtoparty=replacequot(rs.fields(i).value)
		i = i + 1
		productmanager=replacequot(rs.fields(i).value)
		i = i + 1
		oit=replacequot(rs.fields(i).value)
		i = i + 1
		bl=replacequot(rs.fields(i).value)
		i = i + 1
		oitprice=replacequon(rs.fields(i).value)
		i = i + 1
		extendedwarrenty=replacequon(rs.fields(i).value)
		i = i + 1
		sales=replacequon(rs.fields(i).value)
		i = i + 1
		philipsgoodscost=replacequon(rs.fields(i).value)
		i = i + 1
		thirdpartycost=replacequon(rs.fields(i).value)
		i = i + 1
		installation=replacequon(rs.fields(i).value)
		i = i + 1
		sitepreparation=replacequon(rs.fields(i).value)
		i = i + 1
		standardapplicationtraining=replacequon(rs.fields(i).value)
		i = i + 1
		othercost=replacequon(rs.fields(i).value)
		i = i + 1
		freight=replacequon(rs.fields(i).value)
		i = i + 1
		gm=replacequon(rs.fields(i).value)
		i = i + 1
		commission=replacequon(rs.fields(i).value)
		i = i + 1
		warranty=replacequon(rs.fields(i).value)
		i = i + 1
		gmpoint=replacequon(rs.fields(i).value)
		i = i + 1
		netoit=replacequon(rs.fields(i).value)

		If bl <> "" Then 
			strsql="insert into dashboard (vyear, vquarter, quotationno, targetprice, sapwbs, soldtoparty, productname, qty, businessmodel, region, oacm, billtoparty, productmanager, oit, bl, oitprice, extendedwarrenty, sales, philipsgoodscost, thirdpartycost, installation, sitepreparation, standardapplicationtraining, othercost, freight, gm, commission, warranty, gmpoint, netoit, crtuser, crttime) values ('" & vyear & "', '" & vquarter & "', '" & quotationno & "', " & targetprice & ", '" & sapwbs & "', '" & soldtoparty & "', '" & productname & "', " & qty & ", '" & businessmodel & "', '" & region & "', '" & oacm & "', '" & billtoparty & "', '" & productmanager & "', '" & oit & "', '" & bl & "', " & oitprice & ", " & extendedwarrenty & ", " & sales & ", " & philipsgoodscost & ", " & thirdpartycost & ", " & installation & ", " & sitepreparation & ", " & standardapplicationtraining & ", " & othercost & ", " & freight & ", " & gm & ", " & commission & ", " & warranty & ", " & gmpoint & ", " & netoit & ", '" & session("userid") & "', '" & getdate() & "')"
			'response.write strsql
			'response.write "<br>"
			conn.execute(strsql)
		End If 
		'response.write strsql
		'response.end
		rs.movenext
	Wend
	
	If conn.errors.count = 0 And connExcel.errors.count = 0 Then
		conn.CommitTrans
		sql = "select * from dashboard where vyear > '" & vyear & "' or (vyear = '" & vyear & "' and vquarter > '" & vquarter & "')"
		Set rs = conn.execute(sql)
		If rs.eof Then
			Call sendmaildashboardinsert(vyear, vquarter)
		Else 
			Call sendmaildashboardupdate(vyear, vquarter)
		End If 
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
		replacequot=replace(str,"'","’")
	end if
end Function

function replacequon(str)
	if isnull(str) then
		replacequon=0
	else
		replacequon=str
	end if
end function
%>