<!--#include file="../include/conn.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/upload_5xsoft.inc"-->
<!--#include file="../include/utils.asp"-->
<%

	Set upload=new upload_5xsoft
	sid=upload.form("sid")
	'�ϴ��ļ�
	randomize   
	d=date()
	d=replace(d,"-","")
	d=replace(d,".","")
	d=replace(d,"/","")

	Dim MAX_FILESIZE
	MAX_FILESIZE=3300000
	for each formName in upload.file     '�г������ϴ��˵��ļ�
		 set file=upload.file(formName)  '����һ���ļ�����
		 if file.FileSize>0 then          '��� FileSize > 0 ˵�����ļ�����
			 If file.FileSize>MAX_FILESIZE Then
				response.write("<script>alert('����ϴ��ļ����ܳ���3M,�������ϴ���');</script>")
			 End If
			 uploadfileName=file.FilePath
			 quotpos=InStr(uploadfileName,".")
			 allLen=Len(uploadfileName)
			 aliasName=uploadfileName
			 fileext=Right(uploadfileName,allLen-quotpos)
			 fname = file.FileName
			 dname=d&int((1000000*rnd()))
			 filepath=dname&"."&fileext
			 
			  '��ȡ���ļ�����
			 aliasName=replace(aliasName,"\","/")
			 aliasNameArr=Split(aliasName,"/")
			 aliasName=aliasNameArr(UBound(aliasNameArr))

			 file.SaveAs Server.mappath(filepath&fname)   '�����ļ�
			 '�����ļ���Ϣ
			 filesql="insert into special_files(specialId,filepath,filename)values("&sid&",'"&filepath&"','"&aliasName&"')"
			 conn.execute(filesql)
		 end if
		set file=nothing
	next
	set upload=nothing  ''ɾ���˶���
	

	'�ر����ݿ�����
	CloseDatabase

	'response.write("<script>alert('�ϴ��ɹ�');window.close();opener.refreshWindow();</script>")
	response.write("<script>alert('�ϴ��ɹ�');window.close();opener.addFiles2ol('"&sid&"','"&aliasName&"','"&filepath&"');</script>")
%>