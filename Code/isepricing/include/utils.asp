
<%

'****************************************************
'���ܣ��õ�14λ�ĵ�ǰ����ʱ��(yyyymmddhh24miss)
'****************************************************
Function getdate()
	datey = Year(now)
	If Len(Month(now)) = 1 Then
		datem = "0" & Month(now)
	Else 
		datem = Month(now)
	End If 
	If Len(Day(now)) = 1 Then
		dated = "0" & Day(now)
	Else 
		dated = Day(now)
	End If 
	If Len(Hour(now)) = 1 Then
		dateh = "0" & Hour(now)
	Else 
		dateh = Hour(now)
	End If 
	If Len(Minute(now)) = 1 Then
		datei = "0" & Minute(now)
	Else 
		datei = Minute(now)
	End If 
	If Len(Second(now)) = 1 Then
		dates = "0" & Second(now)
	Else 
		dates = Second(now)
	End If 
	getdate = datey & datem & dated & dateh & datei & dates
End function

Function getdate2()
	datey = Year(now)
	If Len(Month(now)) = 1 Then
		datem = "0" & Month(now)
	Else 
		datem = Month(now)
	End If 
	If Len(Day(now)) = 1 Then
		dated = "0" & Day(now)
	Else 
		dated = Day(now)
	End If 
	If Len(Hour(now)) = 1 Then
		dateh = "0" & Hour(now)
	Else 
		dateh = Hour(now)
	End If 
	If Len(Minute(now)) = 1 Then
		datei = "0" & Minute(now)
	Else 
		datei = Minute(now)
	End If 
	If Len(Second(now)) = 1 Then
		dates = "0" & Second(now)
	Else 
		dates = Second(now)
	End If 
	getdate2 = datey & datem & dated
End function
'************************************************************************************
'���ܣ��õ��汾��
'������flag (0-����Ч����ǰ����ʹ�õİ汾��;1-δ��Ч����ǰ���������еİ汾��)
'************************************************************************************
Function getversion(flag)
	sqlversion = "select * from versionset where status='" & flag & "'"
	Set rsversion = conn.execute(sqlversion)
	If Not rsversion.eof Then
		getversion = rsversion("version")
	Else
		getversion = ""
	End If 
End Function 

'************************************************************************************
'���ܣ���14λ������ʱ��ת��Ϊyyyy-mm-dd hh:24mi:ss�ĸ�ʽ
'������datetime(yyyymmddhh24miss)
'************************************************************************************
Function displaytime(datetime)
	If IsNull(datetime) Or datetime = "" Or Len(datetime) <> 14 Then
		displaytime = ""
	Else 
		displaytime = Left(datetime, 4) & "-" & Mid(datetime, 5, 2) & "-" & Mid(datetime, 7, 2) & " " & Mid(datetime, 9, 2) & ":" & Mid(datetime, 11, 2) & ":" & right(datetime, 2)
	End If 
End Function 

Function displaytime2(datetime)
	If IsNull(datetime) Or datetime = "" Or Len(datetime) <> 14 Then
		displaytime2 = ""
	Else 
		displaytime2 = Left(datetime, 4) & "-" & Mid(datetime, 5, 2) & "-" & Mid(datetime, 7, 2)
	End If 
End Function 

Function porcSpecWord(s)
	s=Replace(s,"'","''")
	s=Replace(s,"""","��")
	s=Replace(s,"\r","")
	s=Replace(s,"\n","")
	s=Replace(s,"\r\n","")

	's = Replace(s,CHR(32),"") 
	s = Replace(s,CHR(9),"") 
	s = Replace(s, CHR(13), "") 
	s = Replace(s, CHR(10), "") 


	porcSpecWord=s
End Function

Function porcSpecWordHtml(s)
	s=Replace(s,"'","\'")
	s=Replace(s,"""","��")
	porcSpecWordHtml=s
End function
%>