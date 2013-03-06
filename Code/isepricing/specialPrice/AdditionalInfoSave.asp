<!--#include file="../include/conn.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/upload_5xsoft.inc"-->
<!--#include file="../include/utils.asp"-->
<%

	Set upload=new upload_5xsoft
	sid=upload.form("sid")
	'上传文件
	randomize   
	d=date()
	d=replace(d,"-","")
	d=replace(d,".","")
	d=replace(d,"/","")

	Dim MAX_FILESIZE
	MAX_FILESIZE=3300000
	for each formName in upload.file     '列出所有上传了的文件
		 set file=upload.file(formName)  '生成一个文件对象
		 if file.FileSize>0 then          '如果 FileSize > 0 说明有文件数据
			 If file.FileSize>MAX_FILESIZE Then
				response.write("<script>alert('最大上传文件不能超过3M,请重新上传！');</script>")
			 End If
			 uploadfileName=file.FilePath
			 quotpos=InStr(uploadfileName,".")
			 allLen=Len(uploadfileName)
			 aliasName=uploadfileName
			 fileext=Right(uploadfileName,allLen-quotpos)
			 fname = file.FileName
			 dname=d&int((1000000*rnd()))
			 filepath=dname&"."&fileext
			 
			  '截取下文件名称
			 aliasName=replace(aliasName,"\","/")
			 aliasNameArr=Split(aliasName,"/")
			 aliasName=aliasNameArr(UBound(aliasNameArr))

			 file.SaveAs Server.mappath(filepath&fname)   '保存文件
			 '保存文件信息
			 filesql="insert into special_files(specialId,filepath,filename)values("&sid&",'"&filepath&"','"&aliasName&"')"
			 conn.execute(filesql)
		 end if
		set file=nothing
	next
	set upload=nothing  ''删除此对象
	

	'关闭数据库连接
	CloseDatabase

	'response.write("<script>alert('上传成功');window.close();opener.refreshWindow();</script>")
	response.write("<script>alert('上传成功');window.close();opener.addFiles2ol('"&sid&"','"&aliasName&"','"&filepath&"');</script>")
%>