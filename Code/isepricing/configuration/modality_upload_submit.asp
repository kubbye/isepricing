
<!--#include file="../include/upload_5xsoft.inc"-->
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/commons.asp"-->
<!--#include file="../include/chkUser.asp"-->
<%
dim upload,file,filepath,d
randomize   
d=date()
d=replace(d,"-","")
d=replace(d,".","")
d=d&int((1000000*rnd()))
d="modality"
filepath=d&".xlsx"
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

	importModality(filepath)
	CloseDatabase
%>

<script language="javascript">
  alert ("Operation Success!");
  location.assign("modality_search.asp");
</script>

<%
sub importModality(filename)
	dim modality, bu, inst, warr, apptraining
	dim connExcel,strExcel,strsql,rs
	set connExcel=server.createObject("adodb.connection")
	strExcel="Provider=Microsoft.ACE.OLEDB.12.0;Data Source="&server.MapPath(filename)&";extended properties=Excel 12.0 Xml;"
	connExcel.open strExcel

	conn.BeginTrans    '开始一个事务
	
	'禁用原来所有的MODALITY
	sql = "update modality set status='1', updtuser='" & session("userid") & "', updttime='" & getdate() & "' where status='0'"
	conn.execute(sql)

	strSql="select * from [sheet1$]"
	set rs=connExcel.execute(strSql)
	dim i
	while not rs.eof
		i=0
		bu=rs.fields(i).value
		For j = 0 To UBound(BU_TYPE)
			If bu = BU_TYPE(j, 1) Then
				bu = BU_TYPE(j, 0)
			End If 
		Next 
		i = i + 1
		modality=replacequot(rs.fields(i).value)
		i = i + 1
		inst=replacenum(rs.fields(i).value)
		i = i + 1
		warr=replacenum(rs.fields(i).value)
		i = i + 1
		apptraining=replacenum(rs.fields(i).value)
		i = i + 1
		apptrainingrmb=replacenum(rs.fields(i).value)

		strSql="insert into modality (bu, modality, inst, warr, apptraining, apptrainingrmb, status, crtuser, crttime) values (" & bu & ", '" & modality & "', " & inst & ", " & warr & ", " & apptraining & ", " & apptrainingrmb & ", '0', '" & session("userid") & "', '" & getdate() & "')"
		conn.execute(strsql)
		rs.movenext
	Wend
	
	If conn.errors.count = 0 And connExcel.errors.count = 0 Then
		conn.CommitTrans
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
end Function

Function replacenum(str)
	If IsNull(str) Then
		replacenum=0
	Else 
		replacenum=str
	End If 
End Function 
%>