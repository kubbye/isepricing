<%
'FROMEMAILADD="kubbye@163.com"
'EMAILSERVERURL="smtp.163.com"
CCTEST="e.pricing@philips.com"   
'SERVERURL="<br><a href=""http://cnhpekcrb1ms004.code1.emi.philips.com/isepricing/index.asp"">http://cnhpekcrb1ms004.code1.emi.philips.com/isepricing/index.asp</a>"
Dim ispwd,isCC
ispwd=false 
isCC=True  

If ispwd Then 
	CCTEST="kubbye@gmail.com"
End If 


'apply for oit
Sub sendmailApplyForOIT(qid)
	' 添加邮件收件人为dM
	sql = "select a.quotationno,case when a.username is null or a.username='' then a.nonusername else a.username end username, a.quotationno, b.email,a.crtuser from quotation a,userinfo b where a.crtuser=b.id and qid='"&qid&"'"

	Dim crtuser,quotationno,hospital,email
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			email= rsmail("email") '邮件的收件人地址
			crtuser=rsmail("crtuser")
			quotationno=rsmail("quotationno")
			hospital=rsmail("username")
		End If 
		rsmail.movenext
	Wend 

	Dim mailbody, topic
	topic = quotationno & " applied for OIT in IS e-Pricing System"
	mailbody = "<html><head><meta http-equiv=""Content-Type"" content=""text/html; charset=gb2312""></head><body>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody &  " The Quotation: "&quotationno&" ("&hospital&") has been applied for OIT in IS e-Pricing system, if contract summary doesn’t submit to commercial team within 7 days, then the Quotation No is not valid for OIT purpose.   " & SERVERURL & "<br>"
	mailbody = mailbody & "<br>" 
	mailbody = mailbody & "***This email is automatically sent from IS e-Pricing System, please do not reply to this email.***"
	mailbody = mailbody & "</body></html>"
	
	dim JMail
	set JMail =Server.CreateObject( "JMail.Message" )
	JMail.AddRecipient email
	JMail.Logging=True '启用使用日志
	JMail.silent = True '屏蔽例外错误，返回FALSE跟TRUE两值
	JMail.Charset="GB2312" '邮件文字的代码为简体中文
	JMail.ContentType = "text/html" '邮件的格式为HTML的
	

	
	' 添加邮件抄送收件人为Commercial
	sql = "select email from userinfo where id in ( select userid from user_rolerel where roleid=14) and id in(select userid from user_zonerel where zoneid in(select zid from zone where zonename='"&getzone(quotationno)&"' ))"

	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipientCC rsmail("email") '邮件的收件人地址
		End If 
		rsmail.movenext
	Wend 
	
	If isCC then
		JMail.AddRecipientCC CCTEST
		'JMail.AddRecipientCC getCommercial(getzone(quotationno))
	End If 

	JMail.From = FROMEMAILADD '发件人的地址
	JMail.FromName = "IS E-Pricing System"
	JMail.Priority = 3   '邮件的紧急程序，1 为最快，5 为最慢， 3 为默认值
	JMail.Subject=topic  '邮件标题
	JMail.Body=mailbody  '邮件内容
	
	If ispwd Then 
		JMail.MailServerUserName ="kubbye"  '登录邮件服务器所需的用户名
		JMail.MailServerPassword ="000965"   '登录邮件服务器所需的密码
	End If 
	JMail.Send(EMAILSERVERURL) '执行邮件发送（通过邮件服务器地址）
	SendMail=JMail.log
	JMail.Close    '关闭邮件对象
End Sub 

'single modality dm submit
Sub sendmailDMSubmit(sid,resubmit,isremind)
	remindmsg=""
	If isremind=True Then
		remindmsg="Remind:"
	End If 
	dim JMail
	set JMail =Server.CreateObject( "JMail.Message" )

	' 添加邮件收件人为dM
	sql = "select a.quotationno,a.username hospital,b.username,a.crtuser,a.productmodel,b.email from special_price a,userinfo b where a.crtuser=b.id and a.id="&sid
	Dim crtuser,quotationno,zone,email,username,sd
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("quotationno")) And rsmail("quotationno") <> "" Then 
			crtuser=rsmail("crtuser")
			quotationno=rsmail("quotationno")
			hospital=rsmail("hospital")
			username=rsmail("username")
			productmodel=rsmail("productmodel")
			JMail.AddRecipientCC rsmail("email") '邮件的收件人地址
		End If 
		rsmail.movenext
	Wend
	
		' 添加邮件抄送收件人为sd
	sql = "select top 1 email,username,id from userinfo where id in ( select userid from user_rolerel where roleid=8) and id in(select userid from user_zonerel where zoneid in(select zid from zone where zonename='"&getzone(quotationno)&"'))"

	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipient rsmail("email") '邮件的收件人地址
			sd=rsmail("username")
			Call addMail(sid,rsmail("id"),"8",productmodel)
		End If 
		rsmail.movenext
	Wend 
		
	zone=getzone(quotationno)

	difference="Quotation"
	If productmodel="2" Then 
		difference=" a Bundle deal "
	End If 
	Dim mailbody, topic
	topic =remindmsg& " Action required/ review Special Price Application （"&zone&"）in IS e-Pricing System"
	mailbody = "<html><head><meta http-equiv=""Content-Type"" content=""text/html; charset=gb2312""></head><body>"
	mailbody = mailbody & "<br>"
	'mailbody=mailbody & getAttention(sid)
	
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "Dear "&sd&",<br>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody &  username &"  has applied special price for  "&difference&" : "&quotationno&" ("&hospital&"). Please kindly review in IS e-Pricing system--Special price. " & SERVERURL & "<br>"
	
	
	mailbody = mailbody & "<br>"
	mailbody=mailbody & getAttention(sid)
	mailbody = mailbody & "<br>" 
	mailbody = mailbody & "***This email is automatically sent from IS e-Pricing System, please do not reply to this email.***"
	mailbody = mailbody & "</body></html>"
	
	
	JMail.Logging=True '启用使用日志
	JMail.silent = True '屏蔽例外错误，返回FALSE跟TRUE两值
	JMail.Charset="GB2312" '邮件文字的代码为简体中文
	JMail.ContentType = "text/html" '邮件的格式为HTML的
	

	If isCC then
		JMail.AddRecipientCC CCTEST
		JMail.AddRecipientCC getCommercial(getzone(quotationno))
	End if

	JMail.From = FROMEMAILADD '发件人的地址
	JMail.FromName = "IS E-Pricing System"
	JMail.Priority = 3   '邮件的紧急程序，1 为最快，5 为最慢， 3 为默认值
	JMail.Subject=topic  '邮件标题
	JMail.Body=mailbody  '邮件内容
	If ispwd Then 
		JMail.MailServerUserName ="kubbye"  '登录邮件服务器所需的用户名
		JMail.MailServerPassword ="000965"   '登录邮件服务器所需的密码
	End If 
	JMail.Send(EMAILSERVERURL) '执行邮件发送（通过邮件服务器地址）
	SendMail=JMail.log
	JMail.Close    '关闭邮件对象
End Sub 



'single modality sd approved
Sub sendmailSDApproved(sid,isremind)
	remindmsg=""
	If isremind=True Then
		remindmsg="Remind:"
	End If
	Call deleteMail(sid,"8",1)
	dim JMail
	set JMail =Server.CreateObject( "JMail.Message" )

	' 添加邮件收件人为dM
	sql = "select a.quotationno,a.username hospital,b.username,a.crtuser,b.email from special_price a,userinfo b where a.crtuser=b.id and a.id="&sid
	Dim crtuser,quotationno,zone,email,username,sd
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("quotationno")) And rsmail("quotationno") <> "" Then 
			crtuser=rsmail("crtuser")
			quotationno=rsmail("quotationno")
			hospital=rsmail("hospital")
			username=rsmail("username")
			email=rsmail("email")
		End If 
		rsmail.movenext
	Wend
	
' 添加邮件收件人为bu Director
	sql = "select  email,username,bu,id from userinfo where id in ( select userid from user_rolerel where roleid=3) and bu in(select b.bu from quotation a,quotation_detail b where a.qid=b.qid and a.quotationno='"&quotationno&"' )"

	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipient rsmail("email") '邮件的收件人地址
			buDirector=rsmail("username")
			Call addMail(sid,rsmail("id"),"3",1)
		End If 
		rsmail.movenext
	Wend 
	
	JMail.AddRecipientCC email

	zone=getzone(quotationno)
	'username=session("username")
	username=getApproveUserName(sid,1)
	Dim mailbody, topic
	topic =remindmsg& "Action required/review Special Price Application （"&getzone(quotationno)&"）in IS e-Pricing System"
	mailbody = "<html><head><meta http-equiv=""Content-Type"" content=""text/html; charset=gb2312""></head><body>"

	mailbody = mailbody & "<br>"
	mailbody = mailbody & "Dear "&buDirector&",<br>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody &" The special price application for Quotation:"&quotationno&" ("&hospital&") has been approved by "&username&". Please kindly review in IS e-Pricing system--Special price." & SERVERURL & "<br>"
	mailbody = mailbody & "<br>"
	mailbody=mailbody &getAttention(sid)
	mailbody = mailbody & "<br>" 
	mailbody = mailbody & "***This email is automatically sent from IS e-Pricing System, please do not reply to this email.***"
	mailbody = mailbody & "</body></html>"
	
	
	JMail.Logging=True '启用使用日志
	JMail.silent = True '屏蔽例外错误，返回FALSE跟TRUE两值
	JMail.Charset="GB2312" '邮件文字的代码为简体中文
	JMail.ContentType = "text/html" '邮件的格式为HTML的
	

	If isCC Then 
		JMail.AddRecipientCC CCTEST
	End If 

	JMail.From = FROMEMAILADD '发件人的地址
	JMail.FromName = "IS E-Pricing System"
	JMail.Priority = 3   '邮件的紧急程序，1 为最快，5 为最慢， 3 为默认值
	JMail.Subject=topic  '邮件标题
	JMail.Body=mailbody  '邮件内容
	If ispwd Then 
		JMail.MailServerUserName ="kubbye"  '登录邮件服务器所需的用户名
		JMail.MailServerPassword ="000965"   '登录邮件服务器所需的密码
	End If 
	JMail.Send(EMAILSERVERURL) '执行邮件发送（通过邮件服务器地址）
	SendMail=JMail.log
	JMail.Close    '关闭邮件对象
End Sub 



'single modality sd approved
Sub sendmailSDReject(sid)
	Call deleteMailAll(sid)
	dim JMail
	set JMail =Server.CreateObject( "JMail.Message" )

	' 添加邮件收件人为dM
	sql = "select a.quotationno,a.username hospital,b.username,a.crtuser,b.email from special_price a,userinfo b where a.crtuser=b.id and a.id="&sid
	Dim crtuser,quotationno,zone,email,username,sd
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("quotationno")) And rsmail("quotationno") <> "" Then 
			crtuser=rsmail("crtuser")
			quotationno=rsmail("quotationno")
			hospital=rsmail("hospital")
			username=rsmail("username")
			email=rsmail("email")
		End If 
		rsmail.movenext
	Wend
	

	JMail.AddRecipient email '邮件的收件人地址
	

	zone=getzone(quotationno)
	'byname=session("username")
	byname=getApproveUserName(sid,1)
	Dim mailbody, topic  
	topic = "Special Price Application （"&getzone(quotationno)&"） is rejected "
	mailbody = "<html><head><meta http-equiv=""Content-Type"" content=""text/html; charset=gb2312""></head><body>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "Dear "&username&",<br>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody &" The special price application for Quotation: "&quotationno&" ("&hospital&")  has been rejected by "&byname&". Please  increase price then restart  special price application or execute Target price ." & SERVERURL & "<br>"
	mailbody = mailbody & "<br>" 
	mailbody = mailbody & "***This email is automatically sent from IS e-Pricing System, please do not reply to this email.***"
	mailbody = mailbody & "</body></html>"
	
	
	JMail.Logging=True '启用使用日志
	JMail.silent = True '屏蔽例外错误，返回FALSE跟TRUE两值
	JMail.Charset="GB2312" '邮件文字的代码为简体中文
	JMail.ContentType = "text/html" '邮件的格式为HTML的
	

	If isCC Then 
		JMail.AddRecipientCC CCTEST
		JMail.AddRecipientCC getCommercial(getzone(quotationno))
	End if

	JMail.From = FROMEMAILADD '发件人的地址
	JMail.FromName = "IS E-Pricing System"
	JMail.Priority = 3   '邮件的紧急程序，1 为最快，5 为最慢， 3 为默认值
	JMail.Subject=topic  '邮件标题
	JMail.Body=mailbody  '邮件内容
	If ispwd Then 
		JMail.MailServerUserName ="kubbye"  '登录邮件服务器所需的用户名
		JMail.MailServerPassword ="000965"   '登录邮件服务器所需的密码
	End If 
	JMail.Send(EMAILSERVERURL) '执行邮件发送（通过邮件服务器地址）
	SendMail=JMail.log
	JMail.Close    '关闭邮件对象
End Sub 

'multi modality
Sub sendmailSDApproved_multi(sid,isremind)
	remindmsg=""
	If isremind=True Then
		remindmsg="Remind:"
	End If
	Call deleteMail(sid,"8",2)
	dim JMail
	set JMail =Server.CreateObject( "JMail.Message" )

	' 添加邮件收件人为dM
	sql = "select a.quotationno,a.username hospital,b.username,a.crtuser,b.email from special_price a,userinfo b where a.crtuser=b.id and a.id="&sid
	Dim crtuser,quotationno,zone,email,username,sd
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("quotationno")) And rsmail("quotationno") <> "" Then 
			crtuser=rsmail("crtuser")
			quotationno=rsmail("quotationno")
			hospital=rsmail("hospital")
			username=rsmail("username")
			email=rsmail("email")
			JMail.AddRecipientCC email
		End If 
		rsmail.movenext
	Wend
	
	' 添加邮件收件人为md
	sql = "select  email,username,bu,id from userinfo where id in ( select userid from user_rolerel where roleid=4)"

	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipient rsmail("email") '邮件的收件人地址
			mdname=rsmail("username")
			Call addMail(sid,rsmail("id"),"4",2)
		End If 
		rsmail.movenext
	Wend 

	' 添加邮件收件人为fc
	sql = "select  email,username,bu,id from userinfo where id in ( select userid from user_rolerel where roleid=6)"

	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipient rsmail("email") '邮件的收件人地址
			fcname=rsmail("username")
			Call addMail(sid,rsmail("id"),"6",2)
		End If 
		rsmail.movenext
	Wend 

' 添加邮件抄送收件人为bu Director
	sql = "select  email,username,bu from userinfo where id in ( select userid from user_rolerel where roleid=3) and bu in(select b.bu from quotation a,quotation_detail b where a.qid=b.qid and a.quotationno='"&quotationno&"' )"

	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipientCC rsmail("email") '邮件的收件人地址
		End If 
		rsmail.movenext
	Wend 
	
	' 添加邮件收件人为pricing
	sql = "select  email,username,bu from userinfo where id in ( select userid from user_rolerel where roleid=1)"

	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipientCC rsmail("email") '邮件的收件人地址
		End If 
		rsmail.movenext
	Wend 

	zone=getzone(quotationno)
	'byname=session("username")
	byname=getApproveUserName(sid,1)
	'byname="aaaaaa"
	Dim mailbody, topic
	topic =remindmsg& "Action required/review Special Price Application （"&getzone(quotationno)&"）in IS e-Pricing System"
	mailbody = "<html><head><meta http-equiv=""Content-Type"" content=""text/html; charset=gb2312""></head><body>"

	mailbody = mailbody & "<br>"
	mailbody = mailbody & "Dear "&mdname&" and "&fcname&",<br>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody &" The special price application for Quotation:"&quotationno&" ("&hospital&") has been approved by "&byname&". Please kindly review in IS e-Pricing system--Special price." & SERVERURL & "<br>"
	mailbody = mailbody & "<br>"
	mailbody=mailbody &getAttention(sid)
	mailbody = mailbody & "<br>" 
	mailbody = mailbody & "***This email is automatically sent from IS e-Pricing System, please do not reply to this email.***"
	mailbody = mailbody & "</body></html>"
	
	
	JMail.Logging=True '启用使用日志
	JMail.silent = True '屏蔽例外错误，返回FALSE跟TRUE两值
	JMail.Charset="GB2312" '邮件文字的代码为简体中文
	JMail.ContentType = "text/html" '邮件的格式为HTML的
	

	
	If isCC Then 
		JMail.AddRecipientCC CCTEST
	End if

	JMail.From = FROMEMAILADD '发件人的地址
	JMail.FromName = "IS E-Pricing System"
	JMail.Priority = 3   '邮件的紧急程序，1 为最快，5 为最慢， 3 为默认值
	JMail.Subject=topic  '邮件标题
	JMail.Body=mailbody  '邮件内容

	If ispwd Then 
		JMail.MailServerUserName ="kubbye"  '登录邮件服务器所需的用户名
		JMail.MailServerPassword ="000965"   '登录邮件服务器所需的密码
	End If 
	JMail.Send(EMAILSERVERURL) '执行邮件发送（通过邮件服务器地址）
	SendMail=JMail.log
	JMail.Close    '关闭邮件对象
End Sub 

'multi modality sd rejected
Sub sendmailSDReject_multi(sid)
	Call deleteMailAll(sid)
	dim JMail
	set JMail =Server.CreateObject( "JMail.Message" )

	' 添加邮件收件人为dM
	sql = "select a.quotationno,a.username hospital,b.username,a.crtuser,b.email from special_price a,userinfo b where a.crtuser=b.id and a.id="&sid
	Dim crtuser,quotationno,zone,email,username,sd
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("quotationno")) And rsmail("quotationno") <> "" Then 
			crtuser=rsmail("crtuser")
			quotationno=rsmail("quotationno")
			hospital=rsmail("hospital")
			username=rsmail("username")
			email=rsmail("email")
		End If 
		rsmail.movenext
	Wend
	

	JMail.AddRecipient email '邮件的收件人地址
	

	zone=getzone(quotationno)
	'byname=session("username")
	byname=getApproveUserName(sid,1)
	Dim mailbody, topic  
	topic = "Special Price Application （"&getzone(quotationno)&"） is rejected "
	mailbody = "<html><head><meta http-equiv=""Content-Type"" content=""text/html; charset=gb2312""></head><body>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "Dear "&username&",<br>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody &" The special price application for the Bundle deal: "&quotationno&" ("&hospital&")  has been rejected by "&byname&". Please  increase price then restart  special price application or execute Target price ." & SERVERURL & "<br>"
	mailbody = mailbody & "<br>" 
	mailbody = mailbody & "***This email is automatically sent from IS e-Pricing System, please do not reply to this email.***"
	mailbody = mailbody & "</body></html>"
	
	
	JMail.Logging=True '启用使用日志
	JMail.silent = True '屏蔽例外错误，返回FALSE跟TRUE两值
	JMail.Charset="GB2312" '邮件文字的代码为简体中文
	JMail.ContentType = "text/html" '邮件的格式为HTML的
	

	
	If isCC Then 
		JMail.AddRecipientCC CCTEST
		JMail.AddRecipientCC getCommercial(getzone(quotationno))
	End if

	JMail.From = FROMEMAILADD '发件人的地址
	JMail.FromName = "IS E-Pricing System"
	JMail.Priority = 3   '邮件的紧急程序，1 为最快，5 为最慢， 3 为默认值
	JMail.Subject=topic  '邮件标题
	JMail.Body=mailbody  '邮件内容
	If ispwd Then 
		JMail.MailServerUserName ="kubbye"  '登录邮件服务器所需的用户名
		JMail.MailServerPassword ="000965"   '登录邮件服务器所需的密码
	End if
	JMail.Send(EMAILSERVERURL) '执行邮件发送（通过邮件服务器地址）
	SendMail=JMail.log
	JMail.Close    '关闭邮件对象
End Sub 

'single modality sd approved
Sub sendmailBuApproved(sid,isremind)
	remindmsg=""
	If isremind=True Then
		remindmsg="Remind:"
	End If
	Call deleteMail(sid,"3",1)
	dim JMail
	set JMail =Server.CreateObject( "JMail.Message" )

	' 添加邮件收件人为dM
	sql = "select a.quotationno,a.username hospital,b.username,a.crtuser,b.email from special_price a,userinfo b where a.crtuser=b.id and a.id="&sid
	Dim crtuser,quotationno,zone,email,username,sd
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("quotationno")) And rsmail("quotationno") <> "" Then 
			crtuser=rsmail("crtuser")
			quotationno=rsmail("quotationno")
			hospital=rsmail("hospital")
			username=rsmail("username")
			email=rsmail("email")
		End If 
		rsmail.movenext
	Wend
	
	' 添加邮件收件人为fc
	sql = "select  email,username,id from userinfo where id in ( select userid from user_rolerel where roleid=6)"

	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipient rsmail("email") '邮件的收件人地址
			username=rsmail("username")
			Call addMail(sid,rsmail("id"),"6",1)
		End If 
		rsmail.movenext
	Wend 

	' 添加邮件抄送收件人为sd
	sql = "select email,username from userinfo where id in ( select userid from user_rolerel where roleid=8) and id in(select userid from user_zonerel where zoneid in(select zid from zone where zonename='"&getzone(quotationno)&"'))"

	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipientCC rsmail("email") '邮件的收件人地址
		End If 
		rsmail.movenext
	Wend 
	'send to dm
	JMail.AddRecipientCC email '邮件的收件人地址
	

	zone=getzone(quotationno)
	'byname=session("username")
	byname=getApproveUserName(sid,1)
	Dim mailbody, topic  
	topic =remindmsg& "Action required/review Special Price Application （"&getzone(quotationno)&"） in IS e-Pricing System "
	mailbody = "<html><head><meta http-equiv=""Content-Type"" content=""text/html; charset=gb2312""></head><body>"

	mailbody = mailbody & "<br>"
	mailbody = mailbody & "Dear "&username&",<br>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody &" The special price application for Quotation : "&quotationno&" ("&hospital&") has been approved by "&byname&". Please kindly review in IS e-Pricing system--Special price." & SERVERURL & "<br>"
	mailbody = mailbody & "<br>"
	mailbody=mailbody &getAttention(sid)
	mailbody = mailbody & "<br>" 
	mailbody = mailbody & "***This email is automatically sent from IS e-Pricing System, please do not reply to this email.***"
	mailbody = mailbody & "</body></html>"
	
	
	JMail.Logging=True '启用使用日志
	JMail.silent = True '屏蔽例外错误，返回FALSE跟TRUE两值
	JMail.Charset="GB2312" '邮件文字的代码为简体中文
	JMail.ContentType = "text/html" '邮件的格式为HTML的
	

	
	If isCC Then 
		JMail.AddRecipientCC CCTEST
	End if

	JMail.From = FROMEMAILADD '发件人的地址
	JMail.FromName = "IS E-Pricing System"
	JMail.Priority = 3   '邮件的紧急程序，1 为最快，5 为最慢， 3 为默认值
	JMail.Subject=topic  '邮件标题
	JMail.Body=mailbody  '邮件内容
	If ispwd Then 
		JMail.MailServerUserName ="kubbye"  '登录邮件服务器所需的用户名
		JMail.MailServerPassword ="000965"   '登录邮件服务器所需的密码
	End If 
	JMail.Send(EMAILSERVERURL) '执行邮件发送（通过邮件服务器地址）
	SendMail=JMail.log
	JMail.Close    '关闭邮件对象
End Sub 



'single modality sd approved
Sub sendmailBuReject(sid)
	Call deleteMailAll(sid)
	dim JMail
	set JMail =Server.CreateObject( "JMail.Message" )

	' 添加邮件收件人为dM
	sql = "select a.quotationno,a.username hospital,b.username,a.crtuser,b.email from special_price a,userinfo b where a.crtuser=b.id and a.id="&sid
	Dim crtuser,quotationno,zone,email,username,sd
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("quotationno")) And rsmail("quotationno") <> "" Then 
			crtuser=rsmail("crtuser")
			quotationno=rsmail("quotationno")
			hospital=rsmail("hospital")
			username=rsmail("username")
			email=rsmail("email")
		End If 
		rsmail.movenext
	Wend
	
	' 添加邮件收件人为sd
	sql = "select email,username from userinfo where id in ( select userid from user_rolerel where roleid=8) and id in(select userid from user_zonerel where zoneid in(select zid from zone where zonename='"&getzone(quotationno)&"'))"

	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipientCC rsmail("email") '邮件的收件人地址
		End If 
		rsmail.movenext
	Wend 
	'send to dm
	JMail.AddRecipient email '邮件的收件人地址
	

	zone=getzone(quotationno)
	'byname=session("username")
	byname=getApproveUserName(sid,1)
	Dim mailbody, topic  
	topic = "Special Price Application（"&getzone(quotationno)&"）is rejected in IS e-Pricing System"
	mailbody = "<html><head><meta http-equiv=""Content-Type"" content=""text/html; charset=gb2312""></head><body>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "Dear "&username&",<br>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody &"The special price application for Quotation :"&quotationno&" ("&hospital&")  has been rejected by "&byname&". Please increase price then restart  special price application or execute Target price." & SERVERURL & "<br>"
	mailbody = mailbody & "<br>" 
	mailbody = mailbody & "***This email is automatically sent from IS e-Pricing System, please do not reply to this email.***"
	mailbody = mailbody & "</body></html>"
	
	
	JMail.Logging=True '启用使用日志
	JMail.silent = True '屏蔽例外错误，返回FALSE跟TRUE两值
	JMail.Charset="GB2312" '邮件文字的代码为简体中文
	JMail.ContentType = "text/html" '邮件的格式为HTML的
	

	
	If isCC Then 
		JMail.AddRecipientCC CCTEST
		JMail.AddRecipientCC getCommercial(getzone(quotationno))
	End if

	JMail.From = FROMEMAILADD '发件人的地址
	JMail.FromName = "IS E-Pricing System"
	JMail.Priority = 3   '邮件的紧急程序，1 为最快，5 为最慢， 3 为默认值
	JMail.Subject=topic  '邮件标题
	JMail.Body=mailbody  '邮件内容
	If ispwd Then 
		JMail.MailServerUserName ="kubbye"  '登录邮件服务器所需的用户名
		JMail.MailServerPassword ="000965"   '登录邮件服务器所需的密码
	End if
	JMail.Send(EMAILSERVERURL) '执行邮件发送（通过邮件服务器地址）
	SendMail=JMail.log
	JMail.Close    '关闭邮件对象
End Sub 


'single modality sd approved
Sub sendmailFCApproved(sid,isremind)
	remindmsg=""
	If isremind=True Then
		remindmsg="Remind:"
	End If
	Call deleteMail(sid,"6",1)
	dim JMail
	set JMail =Server.CreateObject( "JMail.Message" )

	' 添加邮件收件人为dM
	sql = "select a.quotationno,a.username hospital,b.username,a.crtuser,b.email from special_price a,userinfo b where a.crtuser=b.id and a.id="&sid
	Dim crtuser,quotationno,zone,email,username,sd
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("quotationno")) And rsmail("quotationno") <> "" Then 
			crtuser=rsmail("crtuser")
			quotationno=rsmail("quotationno")
			hospital=rsmail("hospital")
			username=rsmail("username")
			email=rsmail("email")
		End If 
		rsmail.movenext
	Wend
	'send to dm
	JMail.AddRecipient email '邮件的收件人地址
	' 添加邮件收件人为sd
	sql = "select email,username from userinfo where id in ( select userid from user_rolerel where roleid=8) and id in(select userid from user_zonerel where zoneid in(select zid from zone where zonename='"&getzone(quotationno)&"'))"

	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipientCC rsmail("email") '邮件的收件人地址
		End If 
		rsmail.movenext
	Wend 
	' 添加邮件收件人为bu
		sql = "select  email,username,bu from userinfo where id in ( select userid from user_rolerel where roleid=3) and bu in(select b.bu from quotation a,quotation_detail b where a.qid=b.qid and a.quotationno='"&quotationno&"' )"

	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipientCC rsmail("email") '邮件的收件人地址
		End If 
		rsmail.movenext
	Wend 

	
	'byname=session("username")
	byname=getApproveUserName(sid,1)
	Dim mailbody, topic  

	topic =remindmsg& "Special Price Application （"&getzone(quotationno)&"）is approved in IS e-Pricing System"
	mailbody = "<html><head><meta http-equiv=""Content-Type"" content=""text/html; charset=gb2312""></head><body>"

	mailbody = mailbody & "<br>"
	mailbody = mailbody & "Dear "&username&",<br>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody &"The special price application for Quotation :"&quotationno&" ("&hospital&")  has been approved  by "&byname&". Please kindly review in IS e-Pricing system--Special price." & SERVERURL & "<br>"
	mailbody = mailbody & "<br>"
	mailbody=mailbody &getAttention(sid)
	mailbody = mailbody & "<br>" 
	mailbody = mailbody & "***This email is automatically sent from IS e-Pricing System, please do not reply to this email.***"
	mailbody = mailbody & "</body></html>"
	
	
	JMail.Logging=True '启用使用日志
	JMail.silent = True '屏蔽例外错误，返回FALSE跟TRUE两值
	JMail.Charset="GB2312" '邮件文字的代码为简体中文
	JMail.ContentType = "text/html" '邮件的格式为HTML的
	
	If isCC Then 
		JMail.AddRecipientCC CCTEST
		JMail.AddRecipientCC getCommercial(getzone(quotationno))
	End if

	JMail.From = FROMEMAILADD '发件人的地址
	JMail.FromName = "IS E-Pricing System"
	JMail.Priority = 3   '邮件的紧急程序，1 为最快，5 为最慢， 3 为默认值
	JMail.Subject=topic  '邮件标题
	JMail.Body=mailbody  '邮件内容
	If ispwd Then 
		JMail.MailServerUserName ="kubbye"  '登录邮件服务器所需的用户名
		JMail.MailServerPassword ="000965"   '登录邮件服务器所需的密
	End If 
	JMail.Send(EMAILSERVERURL) '执行邮件发送（通过邮件服务器地址）
	SendMail=JMail.log
	JMail.Close    '关闭邮件对象
End Sub 


'single modality sd approved
Sub sendmailFCReject(sid)
	Call deleteMailAll(sid)
	dim JMail
	set JMail =Server.CreateObject( "JMail.Message" )

	' 添加邮件收件人为dM
	sql = "select a.quotationno,a.username hospital,b.username,a.crtuser,b.email from special_price a,userinfo b where a.crtuser=b.id and a.id="&sid
	Dim crtuser,quotationno,zone,email,username,sd
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("quotationno")) And rsmail("quotationno") <> "" Then 
			crtuser=rsmail("crtuser")
			quotationno=rsmail("quotationno")
			hospital=rsmail("hospital")
			username=rsmail("username")
			email=rsmail("email")
		End If 
		rsmail.movenext
	Wend
	'send to dm
	JMail.AddRecipient email '邮件的收件人地址
	' 添加邮件收件人为sd
	sql = "select email,username from userinfo where id in ( select userid from user_rolerel where roleid=8) and id in(select userid from user_zonerel where zoneid in(select zid from zone where zonename='"&getzone(quotationno)&"'))"

	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipientCC rsmail("email") '邮件的收件人地址
		End If 
		rsmail.movenext
	Wend 
	' 添加邮件收件人为bu
		sql = "select  email,username,bu from userinfo where id in ( select userid from user_rolerel where roleid=3) and bu in(select b.bu from quotation a,quotation_detail b where a.qid=b.qid and a.quotationno='"&quotationno&"' )"

	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipientCC rsmail("email") '邮件的收件人地址
		End If 
		rsmail.movenext
	Wend 

	
	'byname=session("username")
	byname=getApproveUserName(sid,1)
	Dim mailbody, topic  
	topic = "Special Price Application（"&getzone(quotationno)&"）is rejected  "
	mailbody = "<html><head><meta http-equiv=""Content-Type"" content=""text/html; charset=gb2312""></head><body>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "Dear "&username&",<br>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody &"The special price application for Quotation :"&quotationno&" ("&hospital&")  has been rejected  by "&byname&".Please increase price then restart special price application or execute Target price ." & SERVERURL & "<br>"
	mailbody = mailbody & "<br>" 
	mailbody = mailbody & "***This email is automatically sent from IS e-Pricing System, please do not reply to this email.***"
	mailbody = mailbody & "</body></html>"
	
	
	JMail.Logging=True '启用使用日志
	JMail.silent = True '屏蔽例外错误，返回FALSE跟TRUE两值
	JMail.Charset="GB2312" '邮件文字的代码为简体中文
	JMail.ContentType = "text/html" '邮件的格式为HTML的
	
	If isCC Then 
		JMail.AddRecipientCC CCTEST
		JMail.AddRecipientCC getCommercial(getzone(quotationno))
	End if

	JMail.From = FROMEMAILADD '发件人的地址
	JMail.FromName = "IS E-Pricing System"
	JMail.Priority = 3   '邮件的紧急程序，1 为最快，5 为最慢， 3 为默认值
	JMail.Subject=topic  '邮件标题
	JMail.Body=mailbody  '邮件内容
	If ispwd Then 
		JMail.MailServerUserName ="kubbye"  '登录邮件服务器所需的用户名
		JMail.MailServerPassword ="000965"   '登录邮件服务器所需的密码
	End if
	JMail.Send(EMAILSERVERURL) '执行邮件发送（通过邮件服务器地址）
	SendMail=JMail.log
	JMail.Close    '关闭邮件对象
End Sub 


'multi modality fc approved
Sub sendmailFCApproved_multi(sid,isremind)
	remindmsg=""
	If isremind=True Then
		remindmsg="Remind:"
	End If
	'Call deleteMail(sid,session("roleid"),2)
	Call deleteMailAll(sid)
	dim JMail
	set JMail =Server.CreateObject( "JMail.Message" )

	' 添加邮件收件人为dM
	sql = "select a.quotationno,a.username hospital,b.username,a.crtuser,b.email from special_price a,userinfo b where a.crtuser=b.id and a.id="&sid
	Dim crtuser,quotationno,zone,email,username,sd
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("quotationno")) And rsmail("quotationno") <> "" Then 
			crtuser=rsmail("crtuser")
			quotationno=rsmail("quotationno")
			hospital=rsmail("hospital")
			username=rsmail("username")
			email=rsmail("email")
		End If 
		rsmail.movenext
	Wend
	'send to dm
	JMail.AddRecipient email '邮件的收件人地址
	' 添加邮件收件人为sd
	sql = "select email,username from userinfo where id in ( select userid from user_rolerel where roleid=8) and id in(select userid from user_zonerel where zoneid in(select zid from zone where zonename='"&getzone(quotationno)&"'))"

	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipientCC rsmail("email") '邮件的收件人地址
		End If 
		rsmail.movenext
	Wend 
	' 添加邮件抄送收件人为bu
		sql = "select  email,username,bu from userinfo where id in ( select userid from user_rolerel where roleid=3) and bu in(select b.bu from quotation a,quotation_detail b where a.qid=b.qid and a.quotationno='"&quotationno&"' )"

	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipientCC rsmail("email") '邮件的收件人地址
		End If 
		rsmail.movenext
	Wend 
	' 添加邮件抄送收件人为pricing
	sql = "select  email,username,bu from userinfo where id in ( select userid from user_rolerel where roleid=1)"
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipientCC rsmail("email") '邮件的收件人地址
		End If 
		rsmail.movenext
	Wend 
	
	'byname=session("username")
	byname=getApproveUserName(sid,1)
	Dim mailbody, topic  
	topic = remindmsg&"Special Price Application is approved （"&getzone(quotationno)&"）"
	mailbody = "<html><head><meta http-equiv=""Content-Type"" content=""text/html; charset=gb2312""></head><body>"

	mailbody = mailbody & "<br>"
	mailbody = mailbody & "Dear "&username&",<br>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody &"The special price application for Bundle deal: "&quotationno&" ("&hospital&")  has been approved  by "&byname&". Please kindly review in IS e-Pricing system--Special price." & SERVERURL & "<br>"
	mailbody = mailbody & "<br>"
	mailbody=mailbody &getAttention(sid)
	mailbody = mailbody & "<br>" 
	mailbody = mailbody & "***This email is automatically sent from IS e-Pricing System, please do not reply to this email.***"
	mailbody = mailbody & "</body></html>"
	
	
	JMail.Logging=True '启用使用日志
	JMail.silent = True '屏蔽例外错误，返回FALSE跟TRUE两值
	JMail.Charset="GB2312" '邮件文字的代码为简体中文
	JMail.ContentType = "text/html" '邮件的格式为HTML的
	
	If isCC Then 
		JMail.AddRecipientCC CCTEST
		JMail.AddRecipientCC getCommercial(getzone(quotationno))
	End if

	JMail.From = FROMEMAILADD '发件人的地址
	JMail.FromName = "IS E-Pricing System"
	JMail.Priority = 3   '邮件的紧急程序，1 为最快，5 为最慢， 3 为默认值
	JMail.Subject=topic  '邮件标题
	JMail.Body=mailbody  '邮件内容
	If ispwd Then 
		JMail.MailServerUserName ="kubbye"  '登录邮件服务器所需的用户名
		JMail.MailServerPassword ="000965"   '登录邮件服务器所需的密码
	End If 
	JMail.Send(EMAILSERVERURL) '执行邮件发送（通过邮件服务器地址）
	SendMail=JMail.log
	JMail.Close    '关闭邮件对象
End Sub 


'multi modality sd approved
Sub sendmailFCReject_multi(sid)
	Call deleteMailAll(sid)
	dim JMail
	set JMail =Server.CreateObject( "JMail.Message" )

	' 添加邮件收件人为dM
	sql = "select a.quotationno,a.username hospital,b.username,a.crtuser,b.email from special_price a,userinfo b where a.crtuser=b.id and a.id="&sid
	Dim crtuser,quotationno,zone,email,username,sd
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("quotationno")) And rsmail("quotationno") <> "" Then 
			crtuser=rsmail("crtuser")
			quotationno=rsmail("quotationno")
			hospital=rsmail("hospital")
			username=rsmail("username")
			email=rsmail("email")
		End If 
		rsmail.movenext
	Wend
	'send to dm
	JMail.AddRecipient email '邮件的收件人地址
	' 添加邮件收件人为sd
	sql = "select email,username from userinfo where id in ( select userid from user_rolerel where roleid=8) and id in(select userid from user_zonerel where zoneid in(select zid from zone where zonename='"&getzone(quotationno)&"'))"

	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipientCC rsmail("email") '邮件的收件人地址
		End If 
		rsmail.movenext
	Wend 
	' 添加邮件抄送收件人为bu
	sql = "select  email,username,bu from userinfo where id in ( select userid from user_rolerel where roleid=3) and bu in(select b.bu from quotation a,quotation_detail b where a.qid=b.qid and a.quotationno='"&quotationno&"' )"
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipientCC rsmail("email") '邮件的收件人地址
		End If 
		rsmail.movenext
	Wend 
' 添加邮件抄送收件人为pricing
	sql = "select  email,username,bu from userinfo where id in ( select userid from user_rolerel where roleid=1) "
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipientCC rsmail("email") '邮件的收件人地址
		End If 
		rsmail.movenext
	Wend 
	
	'byname=session("username")
	byname=getApproveUserName(sid,1)
	Dim mailbody, topic  
	topic = "Special Price Application is rejected （"&getzone(quotationno)&"）"
	mailbody = "<html><head><meta http-equiv=""Content-Type"" content=""text/html; charset=gb2312""></head><body>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "Dear "&username&",<br>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody &"The special price application for the Bundle deal :"&quotationno&" ("&hospital&")  has been rejected  by "&byname&".Please increase price then restart special price application or execute Target price ." & SERVERURL & "<br>"
	mailbody = mailbody & "<br>" 
	mailbody = mailbody & "***This email is automatically sent from IS e-Pricing System, please do not reply to this email.***"
	mailbody = mailbody & "</body></html>"
	
	
	JMail.Logging=True '启用使用日志
	JMail.silent = True '屏蔽例外错误，返回FALSE跟TRUE两值
	JMail.Charset="GB2312" '邮件文字的代码为简体中文
	JMail.ContentType = "text/html" '邮件的格式为HTML的
	
	If isCC Then 
		JMail.AddRecipientCC CCTEST
		JMail.AddRecipientCC getCommercial(getzone(quotationno))
	End if

	JMail.From = FROMEMAILADD '发件人的地址
	JMail.FromName = "IS E-Pricing System"
	JMail.Priority = 3   '邮件的紧急程序，1 为最快，5 为最慢， 3 为默认值
	JMail.Subject=topic  '邮件标题
	JMail.Body=mailbody  '邮件内容
	If ispwd Then 
		JMail.MailServerUserName ="kubbye"  '登录邮件服务器所需的用户名
		JMail.MailServerPassword ="000965"   '登录邮件服务器所需的密码
	End If 
	JMail.Send(EMAILSERVERURL) '执行邮件发送（通过邮件服务器地址）
	SendMail=JMail.log
	JMail.Close    '关闭邮件对象
End Sub 


'pricing breakdown
Sub sendmailPricingBreakDown(sid)
	dim JMail
	set JMail =Server.CreateObject( "JMail.Message" )

	' 添加邮件收件人为dM
	sql = "select a.quotationno,a.username hospital,b.username,a.crtuser,b.email from special_price a,userinfo b where a.crtuser=b.id and a.id="&sid
	Dim crtuser,quotationno,zone,email,username,sd
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("quotationno")) And rsmail("quotationno") <> "" Then 
			crtuser=rsmail("crtuser")
			quotationno=rsmail("quotationno")
			hospital=rsmail("hospital")
			username=rsmail("username")
			email=rsmail("email")
		End If 
		rsmail.movenext
	Wend
	
	' 添加邮件收件人为fc
	sql = "select  email,username from userinfo where id in ( select userid from user_rolerel where roleid=6)"

	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipient rsmail("email") '邮件的收件人地址
			fcname=rsmail("username")
		End If 
		rsmail.movenext
	Wend 
' 添加邮件收件人为md
	sql = "select  email,username from userinfo where id in ( select userid from user_rolerel where roleid=4)"

	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipient rsmail("email") '邮件的收件人地址
			mdname=rsmail("username")
		End If 
		rsmail.movenext
	Wend 
	

	zone=getzone(quotationno)
	byname=session("username")
	'byname=getApproveUserName(sid,1)
	Dim mailbody, topic  
	topic = " Action required/review Price Break Down of Special Price Application （"&getzone(quotationno)&"） in IS e-Pricing System "
	mailbody = "<html><head><meta http-equiv=""Content-Type"" content=""text/html; charset=gb2312""></head><body>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "Dear "&mdname&" and "&fcname&",<br>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody &" Please check price break down of special price application for Quotation: "&quotationno&" ("&hospital&").Should you have any further comments about the price breakdown, please contact:<a href='mailto:"&session("email")&"'> "& session("email") &"</a>" & SERVERURL & "<br>"
	mailbody = mailbody & "<br>" 
	mailbody = mailbody & "***This email is automatically sent from IS e-Pricing System, please do not reply to this email.***"
	mailbody = mailbody & "</body></html>"
	
	
	JMail.Logging=True '启用使用日志
	JMail.silent = True '屏蔽例外错误，返回FALSE跟TRUE两值
	JMail.Charset="GB2312" '邮件文字的代码为简体中文
	JMail.ContentType = "text/html" '邮件的格式为HTML的
	

	If isCC Then 
		JMail.AddRecipientCC CCTEST
	End if

	JMail.From = FROMEMAILADD '发件人的地址
	JMail.FromName = "IS E-Pricing System"
	JMail.Priority = 3   '邮件的紧急程序，1 为最快，5 为最慢， 3 为默认值
	JMail.Subject=topic  '邮件标题
	JMail.Body=mailbody  '邮件内容
	If ispwd Then 
		JMail.MailServerUserName ="kubbye"  '登录邮件服务器所需的用户名
		JMail.MailServerPassword ="000965"   '登录邮件服务器所需的密码
	End If 
	JMail.Send(EMAILSERVERURL) '执行邮件发送（通过邮件服务器地址）
	SendMail=JMail.log
	JMail.Close    '关闭邮件对象
End Sub 


'single & multi modality addtionnal information
Sub sendmailAddtionnalInformation(sid,isremind)
	Call  deleteMailAll(sid)
	remindmsg=""
	If isremind=True Then
		remindmsg="Remind:"
	End If
	dim JMail
	set JMail =Server.CreateObject( "JMail.Message" )

	' 添加邮件收件人为dM
	sql = "select a.quotationno,a.username hospital,b.username,a.crtuser,b.email,a.productmodel from special_price a,userinfo b where a.crtuser=b.id and a.id="&sid
	Dim crtuser,quotationno,zone,email,username,sd
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("quotationno")) And rsmail("quotationno") <> "" Then 
			crtuser=rsmail("crtuser")
			quotationno=rsmail("quotationno")
			hospital=rsmail("hospital")
			username=rsmail("username")
			email=rsmail("email")
			productmodel=rsmail("productmodel")
		End If 
		rsmail.movenext
	Wend
	If productmodel ="1" Then
		productmodelname="Single"
	ElseIf productmodel="2" Then
		productmodelname="Bundle"
	End If 
	
	JMail.AddRecipient email

	zone=getzone(quotationno)
	'byname=session("username")
	byname=getApproveUserName(sid,2)
	Dim mailbody, topic
	topic = remindmsg &"Special Price Application（"&getzone(quotationno)&"）needs additional information"
	mailbody = "<html><head><meta http-equiv=""Content-Type"" content=""text/html; charset=gb2312""></head><body>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "Dear "&username&",<br>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody &"The special price application for the "&productmodelname&" deal: "&quotationno&" ("&hospital&") needs additional information by "&byname&". Please add additional information in IS e-Pricing System. " & SERVERURL & "<br>"
	mailbody = mailbody & "<br>" 
	mailbody = mailbody & "***This email is automatically sent from IS e-Pricing System, please do not reply to this email.***"
	mailbody = mailbody & "</body></html>"
	
	
	JMail.Logging=True '启用使用日志
	JMail.silent = True '屏蔽例外错误，返回FALSE跟TRUE两值
	JMail.Charset="GB2312" '邮件文字的代码为简体中文
	JMail.ContentType = "text/html" '邮件的格式为HTML的
	

	If isCC Then 
		JMail.AddRecipientCC CCTEST
	End if

	JMail.From = FROMEMAILADD '发件人的地址
	JMail.FromName = "IS E-Pricing System"
	JMail.Priority = 3   '邮件的紧急程序，1 为最快，5 为最慢， 3 为默认值
	JMail.Subject=topic  '邮件标题
	JMail.Body=mailbody  '邮件内容
	If ispwd Then 
		JMail.MailServerUserName ="kubbye"  '登录邮件服务器所需的用户名
		JMail.MailServerPassword ="000965"   '登录邮件服务器所需的密码
	End If 
	
	'添加addtional提醒邮件记录
	Call addMail(sid,crtuser,"7",productmodel)

	JMail.Send(EMAILSERVERURL) '执行邮件发送（通过邮件服务器地址）
	SendMail=JMail.log
	JMail.Close    '关闭邮件对象
End Sub 



'特价变化超过2000美金或1%的discount 
Sub sendmailDiscountChange(sid)
	dim JMail
	set JMail =Server.CreateObject( "JMail.Message" )

	' 添加邮件收件人为dM
	sql = "select a.quotationno,a.username hospital,b.username,a.crtuser,b.email,a.productmodel from special_price a,userinfo b where a.crtuser=b.id and a.id="&sid
	Dim crtuser,quotationno,zone,email,username,sd
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("quotationno")) And rsmail("quotationno") <> "" Then 
			crtuser=rsmail("crtuser")
			quotationno=rsmail("quotationno")
			hospital=rsmail("hospital")
			username=rsmail("username")
			email=rsmail("email")
			productmodel=rsmail("productmodel")
		End If 
		rsmail.movenext
	Wend
	
	JMail.AddRecipient email

	' Attention: this special price application was rejected by XX(rejected 的人)
		'The special discount changed is +4%(系统计算得出)
		'The reason for resubmitting is ：XXXXXXXXXXXX (从AM填写的理由中带出来)
		sql="select * from special_price where id="&sid
		Set rsmail = conn.execute(sql)
		If  Not rsmail.eof Then 
			resubmitmark=rsmail("resubmitremark")
			discount=rsmail("specialdiscount")
			targetoitprice=rsmail("targetoitprice")
		End If 

		sql="select top 1 * from (select top 2 * from ( select * from special_price_his where id="&sid&"  )tmp order by operdate) tmp2 "
		Set rsmail = conn.execute(sql)
		If  Not rsmail.eof Then 
			olddiscount=rsmail("specialdiscount")
			oldtargetoitprice=rsmail("targetoitprice")
		End If 
		
		discount=CDbl(discount)-CDbl(olddiscount)
		targetoitprice=CDbl(targetoitprice)-CDbl(oldtargetoitprice)

		If abs(discount)<0.000000001 Then
			discount=0
		End If 
		discount=toformatnumber(discount)

		If abs(targetoitprice)<0.000000001 Then
			discount=0
		End If 
		targetoitprice=toformatnumber(targetoitprice)

	zone=getzone(quotationno)
	Dim mailbody, topic
	topic = "Action required/Check and resubmit Special Price Application（"&getzone(quotationno)&"）in IS e-Pricing System"
	mailbody = "<html><head><meta http-equiv=""Content-Type"" content=""text/html; charset=gb2312""></head><body>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "Dear "&username&",<br>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody &"<b>Due to</b>: The special discount changed is "&discount&"%(系统计算得出)<br> The NET Target Price changed is "&targetoitprice&"(系统计算得出)<br>You have to <b>check</b> and <b>resubmit</b> special price application for Quotation: "&quotationno&" ("&hospital&"). " & SERVERURL & "<br>"
	mailbody = mailbody & "<br>" 
	mailbody = mailbody & "***This email is automatically sent from IS e-Pricing System, please do not reply to this email.***"
	mailbody = mailbody & "</body></html>"
	
	
	JMail.Logging=True '启用使用日志
	JMail.silent = True '屏蔽例外错误，返回FALSE跟TRUE两值
	JMail.Charset="GB2312" '邮件文字的代码为简体中文
	JMail.ContentType = "text/html" '邮件的格式为HTML的
	
	If isCC Then 
		JMail.AddRecipientCC CCTEST
	End if

	JMail.From = FROMEMAILADD '发件人的地址
	JMail.FromName = "IS E-Pricing System"
	JMail.Priority = 3   '邮件的紧急程序，1 为最快，5 为最慢， 3 为默认值
	JMail.Subject=topic  '邮件标题
	JMail.Body=mailbody  '邮件内容
	If ispwd Then 
		JMail.MailServerUserName ="kubbye"  '登录邮件服务器所需的用户名
		JMail.MailServerPassword ="000965"   '登录邮件服务器所需的密码
	End If 
	JMail.Send(EMAILSERVERURL) '执行邮件发送（通过邮件服务器地址）
	SendMail=JMail.log
	JMail.Close    '关闭邮件对象
End Sub 


'single modality
'dm,sd,Commercial,BU Director,FC 
Sub sendmailCancel_single(sid,nowstatus)
	dim JMail
	set JMail =Server.CreateObject( "JMail.Message" )
	Dim dmmail,sdmail,bumail,fcmail
	Dim dmname,sdname,buname,fcname
	' dM
	sql = "select a.quotationno,a.username hospital,b.username,a.crtuser,b.email ,a.status from special_price a,userinfo b where a.crtuser=b.id and a.id="&sid
	Dim crtuser,quotationno,zone,email,username,sd
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("quotationno")) And rsmail("quotationno") <> "" Then 
			crtuser=rsmail("crtuser")
			quotationno=rsmail("quotationno")
			hospital=rsmail("hospital")
			dmname=rsmail("username")
			dmmail=rsmail("email")
		End If 
		rsmail.movenext
	Wend
	
	' 添加邮件收件人为sd
	sql = "select email,username from userinfo where id in ( select userid from user_rolerel where roleid=8) and id in(select userid from user_zonerel where zoneid in(select zid from zone where zonename='"&getzone(quotationno)&"'))"
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			sdmail= rsmail("email") '邮件的收件人地址
			sdname=rsmail("username")
		End If 
		rsmail.movenext
	Wend 

	' 添加邮件收件人为fc
	sql = "select  email,username,bu,id from userinfo where id in ( select userid from user_rolerel where roleid=6)"
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			fcname=rsmail("username")
			fcmail=rsmail("email")
		End If 
		rsmail.movenext
	Wend 

' 添加邮件抄送收件人为bu Director
	sql = "select  email,username,bu from userinfo where id in ( select userid from user_rolerel where roleid=3) and bu in(select b.bu from quotation a,quotation_detail b where a.qid=b.qid and a.quotationno='"&quotationno&"' )"
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			buname=rsmail("username")
			bumail= rsmail("email") '邮件的收件人地址
		End If 
		rsmail.movenext
	Wend 
	
	If nowstatus=0 Then
		JMail.AddRecipient dmmail
		byname=dmname
	elseIf nowstatus=2 Then
		JMail.AddRecipient sdmail
		byname=sdname
		JMail.AddRecipientCC dmmail
	ElseIf nowstatus=3 Then
		byname=buname
		JMail.AddRecipient bumail
		JMail.AddRecipientCC sdmail
		JMail.AddRecipientCC dmmail
	ElseIf nowstatus=4 Then
		byname=fcname
		JMail.AddRecipient fcmail
		JMail.AddRecipientCC bumail
		JMail.AddRecipientCC sdmail
		JMail.AddRecipientCC dmmail
	End if

	Dim mailbody, topic
	topic =remindmsg& "Special Price Application （"&getzone(quotationno)&"）canceled in IS e-Pricing System"
	mailbody = "<html><head><meta http-equiv=""Content-Type"" content=""text/html; charset=gb2312""></head><body>"

	mailbody = mailbody & "<br>"
	mailbody = mailbody & "Dear "&byname&"<br>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & dmname &" has canceled special price application for  Quotation :"&quotationno&" ("&hospital&"), The special price approval process is not required. This quotation will execute target price for OIT." & "<br>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "<br>" 
	mailbody = mailbody & "***This email is automatically sent from IS e-Pricing System, please do not reply to this email.***"
	mailbody = mailbody & "</body></html>"
	
	JMail.Logging=True '启用使用日志
	JMail.silent = True '屏蔽例外错误，返回FALSE跟TRUE两值
	JMail.Charset="GB2312" '邮件文字的代码为简体中文
	JMail.ContentType = "text/html" '邮件的格式为HTML的
	
	If isCC Then 
		JMail.AddRecipientCC CCTEST
		JMail.AddRecipientCC getCommercial(getzone(quotationno))
	End if

	JMail.From = FROMEMAILADD '发件人的地址
	JMail.FromName = "IS E-Pricing System"
	JMail.Priority = 3   '邮件的紧急程序，1 为最快，5 为最慢， 3 为默认值
	JMail.Subject=topic  '邮件标题
	JMail.Body=mailbody  '邮件内容

	If ispwd Then 
		JMail.MailServerUserName ="kubbye"  '登录邮件服务器所需的用户名
		JMail.MailServerPassword ="000965"   '登录邮件服务器所需的密码
	End If 
	JMail.Send(EMAILSERVERURL) '执行邮件发送（通过邮件服务器地址）
	SendMail=JMail.log
	JMail.Close    '关闭邮件对象
End Sub 

'multi modality
'dm,sd,Commercial,BU Director,FC ,MD
Sub sendmailCancel_multi(sid,nowstatus)
	dim JMail
	set JMail =Server.CreateObject( "JMail.Message" )
	Dim dmmail,sdmail,bumail,fcmail,mdmail
	Dim dmname,sdname,buname,fcname,mdname

	' 添加邮件收件人为dM
	sql = "select a.quotationno,a.username hospital,b.username,a.crtuser,b.email,a.status from special_price a,userinfo b where a.crtuser=b.id and a.id="&sid
	Dim crtuser,quotationno,zone,email,username,sd
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("quotationno")) And rsmail("quotationno") <> "" Then 
			crtuser=rsmail("crtuser")
			quotationno=rsmail("quotationno")
			hospital=rsmail("hospital")
			dmname=rsmail("username")
			dmmail=rsmail("email")
		End If 
		rsmail.movenext
	Wend

	' 添加邮件收件人为sd
	sql = "select email,username from userinfo where id in ( select userid from user_rolerel where roleid=8) and id in(select userid from user_zonerel where zoneid in(select zid from zone where zonename='"&getzone(quotationno)&"'))"
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			sdmail= rsmail("email") '邮件的收件人地址
			sdname=rsmail("username")
		End If 
		rsmail.movenext
	Wend 

	' 添加邮件收件人为md
	sql = "select  email,username,bu,id from userinfo where id in ( select userid from user_rolerel where roleid=4)"
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			mdmail=rsmail("email") '邮件的收件人地址
			mdname=rsmail("username")
		End If 
		rsmail.movenext
	Wend 

	' 添加邮件收件人为fc
	sql = "select  email,username,bu,id from userinfo where id in ( select userid from user_rolerel where roleid=6)"
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			fcmail= rsmail("email") '邮件的收件人地址
			fcname=rsmail("username")
		End If 
		rsmail.movenext
	Wend 

	If nowstatus=0 Then
		JMail.AddRecipient dmmail
		byname=dmname
	elseIf nowstatus=2 Then
		JMail.AddRecipient sdmail
		byname=sdname
	ElseIf nowstatus=3 Then
		byname=mdname &" and "&fcname
		JMail.AddRecipient fcmail
		JMail.AddRecipient mdmail
		JMail.AddRecipientCC sdmail
		JMail.AddRecipientCC dmmail
	ElseIf nowstatus=5 Then
		byname=mdname
		JMail.AddRecipient mdmail
		JMail.AddRecipientCC fcmail
		JMail.AddRecipientCC sdmail
		JMail.AddRecipientCC dmmail
	ElseIf nowstatus=6 Then
		byname=fcname
		JMail.AddRecipient fcmail
		JMail.AddRecipientCC mdmail
		JMail.AddRecipientCC sdmail
		JMail.AddRecipientCC dmmail
	End if

	Dim mailbody, topic
	topic =remindmsg& "Special Price Application （"&getzone(quotationno)&"）canceled in IS e-Pricing System"
	mailbody = "<html><head><meta http-equiv=""Content-Type"" content=""text/html; charset=gb2312""></head><body>"

	mailbody = mailbody & "<br>"
	mailbody = mailbody & "Dear "&byname&"<br>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & dmname &" has canceled special price application for  Quotation :"&quotationno&" ("&hospital&"), The special price approval process is not required. This quotation will execute target price for OIT." & "<br>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "<br>" 
	mailbody = mailbody & "***This email is automatically sent from IS e-Pricing System, please do not reply to this email.***"
	mailbody = mailbody & "</body></html>"
	
	
	
	JMail.Logging=True '启用使用日志
	JMail.silent = True '屏蔽例外错误，返回FALSE跟TRUE两值
	JMail.Charset="GB2312" '邮件文字的代码为简体中文
	JMail.ContentType = "text/html" '邮件的格式为HTML的
	

	
	If isCC Then 
		JMail.AddRecipientCC CCTEST
		JMail.AddRecipientCC getCommercial(getzone(quotationno))
	End if

	JMail.From = FROMEMAILADD '发件人的地址
	JMail.FromName = "IS E-Pricing System"
	JMail.Priority = 3   '邮件的紧急程序，1 为最快，5 为最慢， 3 为默认值
	JMail.Subject=topic  '邮件标题
	JMail.Body=mailbody  '邮件内容

	If ispwd Then 
		JMail.MailServerUserName ="kubbye"  '登录邮件服务器所需的用户名
		JMail.MailServerPassword ="000965"   '登录邮件服务器所需的密码
	End If 
	JMail.Send(EMAILSERVERURL) '执行邮件发送（通过邮件服务器地址）
	SendMail=JMail.log
	JMail.Close    '关闭邮件对象
End Sub 



'如果特价编辑前为wait dm to check,发邮件给需要审批的人
Sub sendmailCheckFinished(sid)
	dim JMail
	set JMail =Server.CreateObject( "JMail.Message" )
	
	sql = "select b.quotationno,b.username hospital,c.username ,c.email,d.username crtuser from special_mail a,special_price b,userinfo c,userinfo d where a.sid=b.id and a.userid=c.id and b.crtuser=d.id and a.sid="&sid
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			tomail= rsmail("email") '邮件的收件人地址
			username=rsmail("username")
			byname=rsmail("crtuser")
			hospital=rsmail("hospital")
			quotationno=rsmail("quotationno")

			JMail.AddRecipient tomail
		End If 
		rsmail.movenext
	Wend 

	

	Dim mailbody, topic
	topic ="Action required/ review Special Price Application ("&getzone(quotationno)&")in IS e-Pricing System"
	mailbody = "<html><head><meta http-equiv=""Content-Type"" content=""text/html; charset=gb2312""></head><body>"
	'response.write("<script>alert('"&topic&"');</script>")
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "Dear "&username&"<br>"
	mailbody = mailbody & "<br>"

	mailbody = mailbody & "The special price application for Quotation: "&quotationno&" ("&hospital&") has been checked by "&byname&" after releasing new Price Guideline or 3rd party product list. Now you can continually review it in IS e-Pricing System--Special price. <br>"& SERVERURL & "<br>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "<br>" 
	mailbody = mailbody & "***This email is automatically sent from IS e-Pricing System, please do not reply to this email.***"
	mailbody = mailbody & "</body></html>"
	
	JMail.Logging=True '启用使用日志
	JMail.silent = True '屏蔽例外错误，返回FALSE跟TRUE两值
	JMail.Charset="GB2312" '邮件文字的代码为简体中文
	JMail.ContentType = "text/html" '邮件的格式为HTML的
	
	If isCC Then 
		JMail.AddRecipientCC CCTEST
		JMail.AddRecipientCC getCommercial(getzone(quotationno))
	End if

	JMail.From = FROMEMAILADD '发件人的地址
	JMail.FromName = "IS E-Pricing System"
	JMail.Priority = 3   '邮件的紧急程序，1 为最快，5 为最慢， 3 为默认值
	JMail.Subject=topic  '邮件标题
	JMail.Body=mailbody  '邮件内容

	If ispwd Then 
		JMail.MailServerUserName ="kubbye"  '登录邮件服务器所需的用户名
		JMail.MailServerPassword ="000965"   '登录邮件服务器所需的密码
	End If 
	JMail.Send(EMAILSERVERURL) '执行邮件发送（通过邮件服务器地址）
	SendMail=JMail.log
	JMail.Close    '关闭邮件对象
End Sub 

Sub addMail(sid,userid,roleid,productmodel)
		add_sql="insert into special_mail(sid,userid,roleid,productmodel,operdate)values('"&sid&"','"&userid&"','"&roleid&"','"&productmodel&"',getdate())"
		conn.execute(add_sql)
End Sub 
Sub deleteMail(sid,roleid,productmodel)
		del_sql="delete from  special_mail where sid='"&sid&"' and roleid='"&roleid&"' and productmodel='"&productmodel&"'"
		conn.execute(del_sql)
End Sub 

Sub deleteMailByRole(sid,roleid)
		del_sql="delete from  special_mail where sid='"&sid&"' and roleid='"&roleid&"'"
		conn.execute(del_sql)
End Sub 
Sub deleteMailAll(sid)
		del_sql="delete from  special_mail where sid='"&sid&"'"
		conn.execute(del_sql)
End Sub 

Function getzone(quotationno)
	getzone=Left(quotationno,Len(quotationno)-13)
End Function 

Function toformatnumber(s)
	showquot=""
	s=formatnumber(s,2,,,0) 
	If s<0 Then
		s=abs(s)
		showquot="-"
	ElseIf s>0 Then 
		showquot="+"
	End If
	If s<1 And s<>0 Then
		If InStr(s,"0")<>0 then
			s="0"&s
		End If 
	End If
	s=showquot&s
	toformatnumber=s
End Function 

Function getAttention(sid)
	resubmit="0"
	Set rs_inMail=conn.execute("select top 2 * from special_approve where actiontype=3 and specialId="&sid & " order by approvetime desc")
	Dim lastResubTime,resubCnt
	resubCnt=0
	If Not rs_inMail.eof And Not rs_inMail.bof Then
		resubmit="1"
		While Not rs_inMail.eof 
			resubCnt=resubCnt+1
			If resubCnt=2 Then
				lastResubTime=rs_inMail("approvetime")
			End If 
			rs_inMail.movenext
		Wend 
	End if
	
' 查找dM
	sql = "select a.quotationno,a.username hospital,b.username,a.crtuser,a.productmodel from special_price a,userinfo b where a.crtuser=b.id and a.id="&sid
	Dim crtuser,quotationno,zone,email,username,sd
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("quotationno")) And rsmail("quotationno") <> "" Then 
			crtuser=rsmail("crtuser")
			quotationno=rsmail("quotationno")
			hospital=rsmail("hospital")
			username=rsmail("username")
			productmodel=rsmail("productmodel")
		End If 
		rsmail.movenext
	Wend

	If resubmit="1" Then 
		' Attention: this special price application was rejected by XX(rejected 的人)
		'The special discount changed is +4%(系统计算得出)
		'The reason for resubmitting is ：XXXXXXXXXXXX (从AM填写的理由中带出来)
		sql="select * from special_price where id="&sid
		Set rsmail = conn.execute(sql)
		If  Not rsmail.eof Then 
			resubmitmark=rsmail("resubmitremark")
			discount=rsmail("specialdiscount")
		End If 

		sql="select top 1 * from (select top 2 * from (select * from special_price_his where id="&sid&" )tmp order by operdate) tmp2 "
		Set rsmail = conn.execute(sql)
		If  Not rsmail.eof Then 
			olddiscount=rsmail("specialdiscount")
		End If 
		
		discount=CDbl(discount)-CDbl(olddiscount)

		If abs(discount)<0.000000001 Then
			discount=0
		End If 
		discount=toformatnumber(discount) 

		sql="select a.*,b.username from special_approve a,userinfo b where a.approveuser=b.id and specialid="&sid&" and actiontype=1 and result=2 order by approvetime desc"
		Set rsmail = conn.execute(sql)
		If  Not rsmail.eof Then 
			byname=rsmail("username")
		End If 
		
		'根据reject和resubmit的次数来决定是因为那种原因的重新提交
		'reject时间>与最新的resubmit时间中间没间隔，则是reject，reject时间与最新resubmit时间中间另外有resubmit，则是上传第3方库。
		
		sql="select a.*,b.username from special_approve a,userinfo b where a.approveuser=b.id and specialid="&sid&" and actiontype=1 and result=2 "
		If Not IsNull(lastResubTime) And lastResubTime<>"" Then
			sql=sql  & " and approvetime>'" & lastResubTime &"'"
		End If 
		sql=sql&" order by approvetime desc"
		Set rsmail = conn.execute(sql)
		If  Not rsmail.eof And Not rsmail.bof Then 
			mailbody = mailbody & "<br>" 
			mailbody = mailbody & "<table border='1' cellpadding='0' cellspacing='0' bordercolor='#000000'>"
			mailbody = mailbody & "<tr><td><b><font color='red'>Attention</font>: this special price application was rejected by "&byname&"</b></td></tr>"
			mailbody = mailbody & "<tr><td><b>The special discount changed is "&discount&"%</b></td></tr>"
			mailbody = mailbody & "<tr><td><b>The reason for resubmitting is ："&resubmitmark&"</b></td></tr>"
			mailbody = mailbody & "</table>"
		Else
			mailbody = mailbody & "<br>" 
			mailbody = mailbody & "<table border='1' cellpadding='0' cellspacing='0' bordercolor='#000000'>"
			mailbody = mailbody & "<tr><td><b><font color='red'>Attention</font>: this special price application was resubmitted by "&username&",due to additional special price discount requested.</b></td></tr>"
			mailbody = mailbody & "<tr><td><b>The special discount changed is "&discount&"%</b></td></tr>"
			mailbody = mailbody & "<tr><td><b>The reason for resubmitting is ："&resubmitmark&"</b></td></tr>"
			mailbody = mailbody & "</table>"
		End If 
	End If
	getAttention=mailbody
End Function 

'得到最后的一个审批人：1，审批，2，addtional information
Function getApproveUserName(sid,opertype)	
	sql_getuser="select top 1 a.*,b.username from  special_approve a,userinfo b where a.approveuser=b.id and  a.specialid='"&sid&"' and actiontype=1 "
	If opertype=1 Then  
		sql_getuser=sql_getuser+" and result in(1,2)"
	Else
		sql_getuser=sql_getuser+" and result in(3)"
	End If 
	sql_getuser=sql_getuser+" order by approvetime desc"
	Set rs_getuser=conn.execute(sql_getuser)
	If Not rs_getuser.eof Then
		getApproveUserName=rs_getuser("username")
	End If 
End Function

Function getCommercial (zonename)
	sql_getuser="select DISTINCT a.userid,a.username,a.email from userinfo a ,user_rolerel b,user_zonerel c where a.id=b.userid and a.id=c.userid and b.roleid=14 And a.validflag=1 and c.zoneid IN(select ZID from zone where zonename='"&zonename&"')"
	Set rs_getuser=conn.execute(sql_getuser)
	If Not rs_getuser.eof Then
		getCommercial=rs_getuser("email")
	End If 	
End function
%>