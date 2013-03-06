
<SCRIPT RUNAT=SERVER LANGUAGE=VBSCRIPT>
dim oUpFileStream

Class upload_5xSoft
 
dim Form,File,Version
  
Private Sub Class_Initialize 
dim RequestBinDate,sStart,bCrLf,sInfo,iInfoStart,iInfoEnd,tStream,iStart,oFileInfo
dim iFileSize,sFilePath,sFileType,sFormvalue,sFileName
dim iFindStart,iFindEnd
dim iFormStart,iFormEnd,sFormName
Version="无组件上传类 Version 0.93"
set Form=Server.CreateObject("Scripting.Dictionary")
set File=Server.CreateObject("Scripting.Dictionary")
if Request.TotalBytes<1 then Exit Sub
set tStream = Server.CreateObject("adodb.stream")
set oUpFileStream = Server.CreateObject("adodb.stream")
oUpFileStream.Type = 1
oUpFileStream.Mode =3
oUpFileStream.Open
oUpFileStream.Write  Request.BinaryRead(Request.TotalBytes)
'response.write("import success!")
'Response.Write  "<font size=""2"">页面执行时间："&FormatNumber((Timer() -time1)*1000,3)&"毫秒</font><br>"
oUpFileStream.Position=0
RequestBinDate =oUpFileStream.Read 
iFormStart = 1
iFormEnd = LenB(RequestBinDate)
bCrLf = chrB(13) & chrB(10)
sStart = MidB(RequestBinDate,1, InStrB(iFormStart,RequestBinDate,bCrLf)-1)
iStart = LenB (sStart)
iFormStart=iFormStart+iStart+1
while (iFormStart + 10) < iFormEnd 
 iInfoEnd = InStrB(iFormStart,RequestBinDate,bCrLf & bCrLf)+3
 tStream.Type = 1
 tStream.Mode =3
 tStream.Open
 oUpFileStream.Position = iFormStart
 oUpFileStream.CopyTo tStream,iInfoEnd-iFormStart
 tStream.Position = 0
 tStream.Type = 2
 tStream.Charset ="gb2312"
 sInfo = tStream.ReadText      
 '取得表单项目名称
 iFormStart = InStrB(iInfoEnd,RequestBinDate,sStart)
 iFindStart = InStr(22,sInfo,"name=""",1)+6
 iFindEnd = InStr(iFindStart,sInfo,"""",1)
 sFormName = Mid (sinfo,iFindStart,iFindEnd-iFindStart)
 '如果是文件
 if InStr (45,sInfo,"filename=""",1) > 0 then
  set oFileInfo=new FileInfo
  '取得文件名
  iFindStart = InStr(iFindEnd,sInfo,"filename=""",1)+10
  iFindEnd = InStr(iFindStart,sInfo,"""",1)
  sFileName = Mid (sinfo,iFindStart,iFindEnd-iFindStart)
  oFileInfo.FileName=getFileName(sFileName)
  oFileInfo.FilePath=getFilePath(sFileName)
  '取得文件类型
  iFindStart = InStr(iFindEnd,sInfo,"Content-Type: ",1)+14
  iFindEnd = InStr(iFindStart,sInfo,vbCr)
  oFileInfo.FileType =Mid (sinfo,iFindStart,iFindEnd-iFindStart)
  oFileInfo.FileStart =iInfoEnd
  oFileInfo.FileSize = iFormStart -iInfoEnd -3
  oFileInfo.FormName=sFormName
  file.add sFormName,oFileInfo
 else
 '如果是表单项目
  tStream.Close
  tStream.Type =1
  tStream.Mode =3
  tStream.Open
  oUpFileStream.Position = iInfoEnd 
  oUpFileStream.CopyTo tStream,iFormStart-iInfoEnd-3
  tStream.Position = 0
  tStream.Type = 2
  tStream.Charset ="gb2312"
  sFormvalue = tStream.ReadText 
  form.Add sFormName,sFormvalue
 end if
 tStream.Close
 iFormStart=iFormStart+iStart+1
 wend
RequestBinDate=""
set tStream =nothing
End Sub

Private Sub Class_Terminate  
if not Request.TotalBytes<1 then
 form.RemoveAll
 file.RemoveAll
 set form=nothing
 set file=nothing
 oUpFileStream.Close
 set oUpFileStream =nothing
  end if
End Sub
   
 
 Private function GetFilePath(FullPath)
  If FullPath <> "" Then
   GetFilePath = left(FullPath,InStrRev(FullPath, ""))
  Else
   GetFilePath = ""
  End If
 End  function
 
 Private function GetFileName(FullPath)
  If FullPath <> "" Then
   GetFileName = mid(FullPath,InStrRev(FullPath, "")+1)
  Else
   GetFileName = ""
  End If
 End  function

End Class

Class FileInfo
  dim FormName,FileName,FilePath,FileSize,FileType,FileStart
  Private Sub Class_Initialize 
    FileName = ""
    FilePath = ""
    FileSize = 0
    FileStart= 0
    FormName = ""
    FileType = ""
  End Sub
  
 Public function SaveAs(FullPath)
    dim oFileStream,ErrorChar,i
    SaveAs=1
    if trim(fullpath)="" or right(fullpath,1)="/" then exit function
    set oFileStream=CreateObject("Adodb.Stream")
    oFileStream.Type=1
    oFileStream.Mode=3
    oFileStream.Open
    oUpFileStream.position=FileStart
    oUpFileStream.copyto oFileStream,FileSize
    oFileStream.SaveToFile FullPath,2
    oFileStream.Close
    set oFileStream=nothing 
    SaveAs=0
  end function
End Class
</SCRIPT>