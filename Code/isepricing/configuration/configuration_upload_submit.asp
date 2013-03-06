
<!--#include file="../include/upload_5xsoft.inc"-->
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/sendMail.asp"-->
<!--#include file="../include/constant.asp"-->

<%
'判断是否存在未生效的版本，若不存在，则不允许导入
sql = "select * from versionset where status='1'"
Set rs = conn.execute(sql)
If rs.eof Then
%>
<script language="javascript">
  alert ("Please create version!");
  location.assign("configuration_upload.asp");
</script>
<%
	response.End 
End If 
%>

<%
dim upload,file,filepath,d
randomize   
d=date()
d=replace(d,"-","")
d=replace(d,".","")
d=d&int((1000000*rnd()))
d="configuration"
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

	importConfiguration(filepath)
	CloseDatabase
%>

<script language="javascript">
  alert ("Operation Success!");
  location.assign("configuration_search.asp");
</script>

<%
sub importConfiguration(filename)
	dim materialno, description, listprice, wrp, maxversion, validversion, version, status
	dim connExcel,strExcel,strsql,rs
	set connExcel=server.createObject("adodb.connection")
	strExcel="Provider=Microsoft.ACE.OLEDB.12.0;Data Source="&server.MapPath(filename)&";extended properties=Excel 12.0 Xml;"
	'strExcel="Provider=Microsoft.Jet.OLEDB.4.0;Data Source= "&server.MapPath(filename)&";Extended Properties=Excel 8.0;"
	connExcel.open strExcel

	conn.BeginTrans    '开始一个事务

	'得到版本号
	version = getversion(1)
	
	'清空未生效的配置数据, 版本号不变
	'version = rs("version")
	'删除philips的产品配置表数据
	strsql = "delete from product_detail_philips where pid in (select pid from product where version='" & version & "')"
	conn.execute(strsql)
	'删除第三方的产品配置表数据
	strsql = "delete from product_detail_3rd where pid in (select pid from product where version='" & version & "')"
	conn.execute(strsql)
	'删除产品表数据
	strsql = "delete from product where version='" & version & "'"
	conn.execute(strsql)
	'删除配置表
	strsql = "delete from configurations where version='" & version & "'"
	conn.execute(strsql)

	strSql="select * from [sheet1$]"
	set rs=connExcel.execute(strSql)
	dim i
	while not rs.eof
		i=0
		materialno=replacequot(rs.fields(i).value)
		i = i + 1
		description=replacequot(rs.fields(i).value)
		i = i + 1
		listprice=rs.fields(i).value
		i = i + 1
		wrp=rs.fields(i).value
		strSql="insert into configurations (materialno, description, listprice, wrp, type, state, status, version, crtuser, crttime) values ('" & materialno & "', '" & description & "', " & listprice & ", " & wrp & ", '0', '0', '1', '" & version & "', '" & session("userid") & "', '" & getdate() & "')"
		conn.execute(strsql)
		rs.movenext
	Wend
	
	If conn.errors.count = 0 And connExcel.errors.count = 0 Then
		conn.CommitTrans
		Call sendmailCatalogupdate(version)
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
end function
%>