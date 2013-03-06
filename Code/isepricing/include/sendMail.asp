<%
'Catalog 更新
Sub sendmailCatalogupdate(versionset)
	Dim mailbody, topic
	topic = "Action required/update " & versionset & " Price Guideline in IS e-Pricing System"
	mailbody = "<html><head><meta http-equiv=""Content-Type"" content=""text/html; charset=gb2312""></head><body>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "Dear All,<br>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & versionset & " Catalog has been updated into IS e-Pricing system. Please follow below schedule to update Price Guideline accordingly: " & SERVERURL & "<br>"
	mailbody = mailbody & "<table border='1' cellpadding='0' cellspacing='0' bordercolor='#000000'>"
	mailbody = mailbody & "<tr><td>Product Manager:</td><td>Update Standard Configuration + Key Options</td><td>+3 working days</td></tr>"
	mailbody = mailbody & "<tr><td>Marketing BU Director:</td><td>Define Target Price</td><td>+3 working days</td></tr>"
	mailbody = mailbody & "<tr><td>Pricing:</td><td>Check Price guideline</td><td>+1 working days</td></tr>"
	mailbody = mailbody & "</table>"
	mailbody = mailbody & "<br>" 
	mailbody = mailbody & "***This email is automatically sent from IS e-Pricing System, please do not reply to this email.***"
	mailbody = mailbody & "</body></html>"
	
	dim JMail
	set JMail =Server.CreateObject( "JMail.Message" )
	JMail.Logging=True '启用使用日志
	JMail.silent = True '屏蔽例外错误，返回FALSE跟TRUE两值
	JMail.Charset="GB2312" '邮件文字的代码为简体中文
	JMail.ContentType = "text/html" '邮件的格式为HTML的
	
	' 添加邮件收件人为PM
	sql = "select * from userinfo where validflag='1' and id in (select userid from user_rolerel where roleid=2)"
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipient rsmail("email") '邮件的收件人地址
		End If 
		rsmail.movenext
	Wend 
	' 添加邮件抄送收件人为Pricing、BU Director
	sql = "select * from userinfo where validflag='1' and id in (select userid from user_rolerel where roleid in (1,3))"
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipientCC rsmail("email") '邮件的收件人地址
		End If 
		rsmail.movenext
	Wend 
	
	JMail.AddRecipientCC "e.pricing@philips.com"

	JMail.From = FROMEMAILADD '发件人的地址
	JMail.FromName = "IS E-Pricing System"
	JMail.Priority = 3   '邮件的紧急程序，1 为最快，5 为最慢， 3 为默认值
	JMail.Subject=topic  '邮件标题
	JMail.Body=mailbody  '邮件内容
	JMail.Send(EMAILSERVERURL) '执行邮件发送（通过邮件服务器地址）
	SendMail=JMail.log
	JMail.Close    '关闭邮件对象
End Sub 

' 第三方产品更新
Sub sendmail3rdupdate()
	Dim mailbody, topic
	topic = "3rd Party Product List is updated"
	mailbody = "<html><head><meta http-equiv=""Content-Type"" content=""text/html; charset=gb2312""></head><body>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "Dear All,<br>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "The 3rd Party Product List has been updated, please check and update Quotation (DM) in IS e-Pricing system, if necessary."
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "Website: " & SERVERURL & "<br>"
	mailbody = mailbody & "<br>" 
	mailbody = mailbody & "***This email is automatically sent from IS e-Pricing System, please do not reply to this email.***"
	mailbody = mailbody & "</body></html>"
	
	dim JMail
	set JMail =Server.CreateObject( "JMail.Message" )
	JMail.Logging=True '启用使用日志
	JMail.silent = True '屏蔽例外错误，返回FALSE跟TRUE两值
	JMail.Charset="GB2312" '邮件文字的代码为简体中文
	JMail.ContentType = "text/html" '邮件的格式为HTML的
	
	' 添加邮件收件人为PM、Marketing BU Director、DM、 SD、MD、 FC、 Finance、SCM Manager 、SCM Specialist、Pricing
	sql = "select * from userinfo where validflag='1' and id in (select userid from user_rolerel where roleid in (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 15))"
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipient rsmail("email") '邮件的收件人地址
		End If 
		rsmail.movenext
	Wend 
	
	JMail.AddRecipientCC "e.pricing@philips.com"

	JMail.From = FROMEMAILADD '发件人的地址
	JMail.FromName = "IS E-Pricing System"
	JMail.Priority = 3   '邮件的紧急程序，1 为最快，5 为最慢， 3 为默认值
	JMail.Subject=topic  '邮件标题
	JMail.Body=mailbody  '邮件内容
	JMail.Send(EMAILSERVERURL) '执行邮件发送（通过邮件服务器地址）
	SendMail=JMail.log
	JMail.Close    '关闭邮件对象
End Sub 

' PM提交
Sub sendmailpmsubmit(versionset, bu)
	dim JMail
	set JMail =Server.CreateObject( "JMail.Message" )
	JMail.Logging=True '启用使用日志
	JMail.silent = True '屏蔽例外错误，返回FALSE跟TRUE两值
	JMail.Charset="GB2312" '邮件文字的代码为简体中文
	JMail.ContentType = "text/html" '邮件的格式为HTML的

	Dim mailbody, topic
	Dim username
	' 添加邮件收件人为PM
	sql = "select * from userinfo where validflag='1' and id in (select userid from user_rolerel where roleid=3) and bu=" & bu
	Set rsmail = conn.execute(sql)
	If Not rsmail.eof Then 
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipient rsmail("email") '邮件的收件人地址
			username = rsmail("username")
		End If 
	End If  
	topic = "Action required/ set Target Price of " & versionset & " Price Guideline in IS e-Pricing System"
	mailbody = "<html><head><meta http-equiv=""Content-Type"" content=""text/html; charset=gb2312""></head><body>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "Dear " & username & ",<br>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "The configuration of " & versionset & " " & BU_TYPE(bu, 1) & " BU’s Price guideline has been updated, please check and define target price in IS e-Pricing System. <br>"
	mailbody = mailbody & SERVERURL & "<br>"
	mailbody = mailbody & "<table border='1' cellpadding='0' cellspacing='0' bordercolor='#000000'>"
	mailbody = mailbody & "<tr><td>Product Manager:</td><td>Update Standard Configuration + Key Options</td><td>+3 working days</td></tr>"
	mailbody = mailbody & "<tr><td>Marketing BU Director:</td><td>Define Target Price</td><td>+3 working days</td></tr>"
	mailbody = mailbody & "<tr><td>Pricing:</td><td>Check Price guideline</td><td>+1 working days</td></tr>"
	mailbody = mailbody & "</table>"
	mailbody = mailbody & "<br>" 
	mailbody = mailbody & "***This email is automatically sent from IS e-Pricing System, please do not reply to this email.***"
	mailbody = mailbody & "</body></html>"
	
	JMail.AddRecipientCC "e.pricing@philips.com"

	JMail.From = FROMEMAILADD '发件人的地址
	JMail.FromName = "IS E-Pricing System"
	JMail.Priority = 3   '邮件的紧急程序，1 为最快，5 为最慢， 3 为默认值
	JMail.Subject=topic  '邮件标题
	JMail.Body=mailbody  '邮件内容
	JMail.Send(EMAILSERVERURL) '执行邮件发送（通过邮件服务器地址）
	SendMail=JMail.log
	JMail.Close    '关闭邮件对象
End Sub 

' BU Director提交
Sub sendmailbudirectorsubmit(versionset, bu)
	dim JMail
	set JMail =Server.CreateObject( "JMail.Message" )
	JMail.Logging=True '启用使用日志
	JMail.silent = True '屏蔽例外错误，返回FALSE跟TRUE两值
	JMail.Charset="GB2312" '邮件文字的代码为简体中文
	JMail.ContentType = "text/html" '邮件的格式为HTML的

	Dim mailbody, topic
	' 添加邮件收件人为Pricing
	sql = "select * from userinfo where validflag='1' and id in (select userid from user_rolerel where roleid=1)"
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipient rsmail("email") '邮件的收件人地址
		End If 
		rsmail.movenext
	Wend 
	topic = "Please review " & versionset & " Price Guideline in IS e-Pricing System"
	mailbody = "<html><head><meta http-equiv=""Content-Type"" content=""text/html; charset=gb2312""></head><body>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & versionset & " " & BU_TYPE(bu, 1) & " BU’s Price guideline has been updated, please check and compare. <br>"
	mailbody = mailbody & SERVERURL & "<br>"
	mailbody = mailbody & "***This email is automatically sent from IS e-Pricing System, please do not reply to this email.***"
	mailbody = mailbody & "</body></html>"

	JMail.AddRecipientCC "e.pricing@philips.com"

	JMail.From = FROMEMAILADD '发件人的地址
	JMail.FromName = "IS E-Pricing System"
	JMail.Priority = 3   '邮件的紧急程序，1 为最快，5 为最慢， 3 为默认值
	JMail.Subject=topic  '邮件标题
	JMail.Body=mailbody  '邮件内容
	JMail.Send(EMAILSERVERURL) '执行邮件发送（通过邮件服务器地址）
	SendMail=JMail.log
	JMail.Close    '关闭邮件对象
End Sub 

' BU Director Reject
Sub sendmailbudirectorreject(versionset, bu, pid)
	dim JMail
	set JMail =Server.CreateObject( "JMail.Message" )
	JMail.Logging=True '启用使用日志
	JMail.silent = True '屏蔽例外错误，返回FALSE跟TRUE两值
	JMail.Charset="GB2312" '邮件文字的代码为简体中文
	JMail.ContentType = "text/html" '邮件的格式为HTML的

	Dim mailbody, topic, username
	' 添加邮件收件人为PM
	sql = "select * from userinfo where validflag='1' and id in (select userid from user_rolerel where roleid=2) and bu=" & bu
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipient rsmail("email") '邮件的收件人地址
		End If 
		rsmail.movenext
	Wend 
	sql = "select b.username from product a, userinfo b where a.crtuser=b.userid and a.pid=" & pid
	Set rsuser = conn.execute(sql)
	If Not rsuser.eof Then 
		username = rsuser("username")
	End If 
	topic = "Price Guideline rejected / Please check & update"
	mailbody = "<html><head><meta http-equiv=""Content-Type"" content=""text/html; charset=gb2312""></head><body>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "Dear " & username & ",<br>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "The " & versionset & " Price guideline has been rejected by Marketing BU Director, please check and update A.S.A.P in IS e-Pricing System. <br>"
	mailbody = mailbody & SERVERURL & "<br>"
	mailbody = mailbody & "***This email is automatically sent from IS e-Pricing System, please do not reply to this email.***"
	mailbody = mailbody & "</body></html>"

	JMail.AddRecipientCC "e.pricing@philips.com"

	JMail.From = FROMEMAILADD '发件人的地址
	JMail.FromName = "IS E-Pricing System"
	JMail.Priority = 3   '邮件的紧急程序，1 为最快，5 为最慢， 3 为默认值
	JMail.Subject=topic  '邮件标题
	JMail.Body=mailbody  '邮件内容
	JMail.Send(EMAILSERVERURL) '执行邮件发送（通过邮件服务器地址）
	SendMail=JMail.log
	JMail.Close    '关闭邮件对象
End Sub 

' Pricing submit
Sub sendmailpricingsubmit(versionset, bu)
	dim JMail
	set JMail =Server.CreateObject( "JMail.Message" )
	JMail.Logging=True '启用使用日志
	JMail.silent = True '屏蔽例外错误，返回FALSE跟TRUE两值
	JMail.Charset="GB2312" '邮件文字的代码为简体中文
	JMail.ContentType = "text/html" '邮件的格式为HTML的

	Dim mailbody, topic
	' 添加邮件收件人为Financial Controller, Marketing Director
	sql = "select * from userinfo where validflag='1' and id in (select userid from user_rolerel where roleid in (4, 6))"
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipient rsmail("email") '邮件的收件人地址
		End If 
		rsmail.movenext
	Wend 
	topic = " Action required/review " & versionset & " Price Guideline"
	mailbody = "<html><head><meta http-equiv=""Content-Type"" content=""text/html; charset=gb2312""></head><body>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "Dear both,<br>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "Please kindly review " & versionset & " " & BU_TYPE(bu, 1) & " BU’s Price Guideline in IS e-Pricing System. <br>"
	mailbody = mailbody & SERVERURL & "<br>"
	mailbody = mailbody & "***This email is automatically sent from IS e-Pricing System, please do not reply to this email.***"
	mailbody = mailbody & "</body></html>"

	JMail.AddRecipientCC "e.pricing@philips.com"

	JMail.From = FROMEMAILADD '发件人的地址
	JMail.FromName = "IS E-Pricing System"
	JMail.Priority = 3   '邮件的紧急程序，1 为最快，5 为最慢， 3 为默认值
	JMail.Subject=topic  '邮件标题
	JMail.Body=mailbody  '邮件内容
	JMail.Send(EMAILSERVERURL) '执行邮件发送（通过邮件服务器地址）
	SendMail=JMail.log
	JMail.Close    '关闭邮件对象
End Sub 

' Pricing goback
Sub sendmailpricinggoback(versionset, bu, mailuserid)
	dim JMail
	set JMail =Server.CreateObject( "JMail.Message" )
	JMail.Logging=True '启用使用日志
	JMail.silent = True '屏蔽例外错误，返回FALSE跟TRUE两值
	JMail.Charset="GB2312" '邮件文字的代码为简体中文
	JMail.ContentType = "text/html" '邮件的格式为HTML的

	Dim mailbody, topic, username
	' 添加邮件收件人为PM或BU Director
	sql = "select * from userinfo where validflag='1' and id in (select userid from user_rolerel where roleid=" & mailuserid & ") and bu=" & bu
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipient rsmail("email") '邮件的收件人地址
		End If 
		If mailuserid = "3" Then
			username = rsmail("username")
		End If 
		rsmail.movenext
	Wend 

	'如果是退回给PM，则需要添加抄送人为BU Director
	If mailuserid = "2" Then
		sql = "select * from userinfo where validflag='1' and id in (select userid from user_rolerel where roleid=3) and bu=" & bu
		Set rsmail = conn.execute(sql)
		While Not rsmail.eof
			If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
				JMail.AddRecipientCC rsmail("email") '邮件的收件人地址
			End If 
			rsmail.movenext
		Wend 
	End If 

	topic = "Action required/please revise " & versionset & " Price Guideline"
	mailbody = "<html><head><meta http-equiv=""Content-Type"" content=""text/html; charset=gb2312""></head><body>"
	mailbody = mailbody & "<br>"
	If mailuserid = "3" Then 
		mailbody = mailbody & "Dear " & username & ",<br>"
		mailbody = mailbody & "<br>"
	End If 
	mailbody = mailbody & "Please kindly revise " & versionset & " " & BU_TYPE(bu, 1) & " BU’s Price Guideline in IS e-Pricing System. <br>"
	mailbody = mailbody & SERVERURL & "<br>"
	mailbody = mailbody & "***This email is automatically sent from IS e-Pricing System, please do not reply to this email.***"
	mailbody = mailbody & "</body></html>"

	JMail.AddRecipientCC "e.pricing@philips.com"

	JMail.From = FROMEMAILADD '发件人的地址
	JMail.FromName = "IS E-Pricing System"
	JMail.Priority = 3   '邮件的紧急程序，1 为最快，5 为最慢， 3 为默认值
	JMail.Subject=topic  '邮件标题
	JMail.Body=mailbody  '邮件内容
	JMail.Send(EMAILSERVERURL) '执行邮件发送（通过邮件服务器地址）
	SendMail=JMail.log
	JMail.Close    '关闭邮件对象
End Sub 

' FC/MD Approved
Sub sendmailfcmdapproved(versionset, bu, rolename)
	dim JMail
	set JMail =Server.CreateObject( "JMail.Message" )
	JMail.Logging=True '启用使用日志
	JMail.silent = True '屏蔽例外错误，返回FALSE跟TRUE两值
	JMail.Charset="GB2312" '邮件文字的代码为简体中文
	JMail.ContentType = "text/html" '邮件的格式为HTML的

	Dim mailbody, topic
	' 添加邮件收件人为Pricing
	sql = "select * from userinfo where validflag='1' and id in (select userid from user_rolerel where roleid=1)"
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipient rsmail("email") '邮件的收件人地址
		End If 
		rsmail.movenext
	Wend 
	topic = versionset & " " & BU_TYPE(bu, 1) & " BU’s Price Guideline approved by " & rolename
	mailbody = "<html><head><meta http-equiv=""Content-Type"" content=""text/html; charset=gb2312""></head><body>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & versionset & " " & BU_TYPE(bu, 1) & " BU’s Price Guideline has been approved by " & session("username") & " <br>"
	mailbody = mailbody & SERVERURL & "<br>"
	mailbody = mailbody & "***This email is automatically sent from IS e-Pricing System, please do not reply to this email.***"
	mailbody = mailbody & "</body></html>"

	JMail.AddRecipientCC "e.pricing@philips.com"

	JMail.From = FROMEMAILADD '发件人的地址
	JMail.FromName = "IS E-Pricing System"
	JMail.Priority = 3   '邮件的紧急程序，1 为最快，5 为最慢， 3 为默认值
	JMail.Subject=topic  '邮件标题
	JMail.Body=mailbody  '邮件内容
	JMail.Send(EMAILSERVERURL) '执行邮件发送（通过邮件服务器地址）
	SendMail=JMail.log
	JMail.Close    '关闭邮件对象
End Sub 

' FC/MD goback
Sub sendmailfcmdgoback(versionset)
	dim JMail
	set JMail =Server.CreateObject( "JMail.Message" )
	JMail.Logging=True '启用使用日志
	JMail.silent = True '屏蔽例外错误，返回FALSE跟TRUE两值
	JMail.Charset="GB2312" '邮件文字的代码为简体中文
	JMail.ContentType = "text/html" '邮件的格式为HTML的

	Dim mailbody, topic
	' 添加邮件收件人为Pricing
	sql = "select * from userinfo where validflag='1' and id in (select userid from user_rolerel where roleid=1)"
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipient rsmail("email") '邮件的收件人地址
		End If 
		rsmail.movenext
	Wend 
	' 添加邮件收件人为BU Director
	sql = "select * from userinfo where validflag='1' and id in (select userid from user_rolerel where roleid=3) and bu=" & bu
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipient rsmail("email") '邮件的收件人地址
		End If 
		rsmail.movenext
	Wend 
	' 添加邮件抄送人为FC、MD
	sql = "select * from userinfo where validflag='1' and id in (select userid from user_rolerel where roleid in (4, 6))"
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipientCC rsmail("email") '邮件的收件人地址
		End If 
		rsmail.movenext
	Wend 
	topic = "Price Guideline is rejected / Please check & update"
	mailbody = "<html><head><meta http-equiv=""Content-Type"" content=""text/html; charset=gb2312""></head><body>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "The " & versionset & " Price guideline has been rejected by " & session("username") & ", please check and update A.S.A.P in IS e-Pricing System. <br>"
	mailbody = mailbody & SERVERURL & "<br>"
	mailbody = mailbody & "***This email is automatically sent from IS e-Pricing System, please do not reply to this email.***"
	mailbody = mailbody & "</body></html>"

	JMail.AddRecipientCC "e.pricing@philips.com"

	JMail.From = FROMEMAILADD '发件人的地址
	JMail.FromName = "IS E-Pricing System"
	JMail.Priority = 3   '邮件的紧急程序，1 为最快，5 为最慢， 3 为默认值
	JMail.Subject=topic  '邮件标题
	JMail.Body=mailbody  '邮件内容
	JMail.Send(EMAILSERVERURL) '执行邮件发送（通过邮件服务器地址）
	SendMail=JMail.log
	JMail.Close    '关闭邮件对象
End Sub 

' Publish
Sub sendmailpublish(versionset)
	dim JMail
	set JMail =Server.CreateObject( "JMail.Message" )
	JMail.Logging=True '启用使用日志
	JMail.silent = True '屏蔽例外错误，返回FALSE跟TRUE两值
	JMail.Charset="GB2312" '邮件文字的代码为简体中文
	JMail.ContentType = "text/html" '邮件的格式为HTML的

	Dim mailbody, topic
	' 添加邮件收件人为DM 、BU Director、PM、CEO、CFO、 FC 、Pricing、Marketing Director、 FA、Commercial、PM (no edit right)、Commercial Leader
	sql = "select * from userinfo where validflag='1' and id in (select userid from user_rolerel where roleid in (1, 2, 3, 4, 5, 6, 7, 11, 12, 14, 17, 18))"
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipient rsmail("email") '邮件的收件人地址
		End If 
		rsmail.movenext
	Wend 
	topic = versionset & " Price Guideline is published in IS e-Pricing System"
	mailbody = "<html><head><meta http-equiv=""Content-Type"" content=""text/html; charset=gb2312""></head><body>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "Dear All,<br>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "Please check " & versionset & " IS Price Guideline in IS e-Pricing System. Please check & update Quotation & Special Price accordingly. <br>"
	mailbody = mailbody & SERVERURL & "<br>"
	mailbody = mailbody & "Please be aware :<br>"
	mailbody = mailbody & "<ol>"
	mailbody = mailbody & "<li>The price guideline is applicable within Philips Healthcare Mainland China at this phase.</li>"
	mailbody = mailbody & "<li>Any additional options will increase target price, please check target price accordingly.</li>"
	mailbody = mailbody & "<li>The Target price identified in the Price guideline only refers NET target price of recommended standard configuration, including Standard Application, Standard Training, Standard Installation, and One year Warranty.  BUT excluding Extended Warranty, Non-included 3rd party product, Site Preparation and other Provisions. </li>"
	mailbody = mailbody & "<li>If estimated OIT price (Net) is lower than the target price, please obtain approval of special price before bidding.</li>"
	mailbody = mailbody & "</ol>"
	mailbody = mailbody & "Attention: Special price approval process can’t be carried out, until Quotation &Special Price have been checked accordingly!"
	mailbody = mailbody & "</body></html>"

	JMail.AddRecipientCC "e.pricing@philips.com"
	JMail.From = FROMEMAILADD '发件人的地址
	JMail.FromName = "IS E-Pricing System"
	JMail.Priority = 3   '邮件的紧急程序，1 为最快，5 为最慢， 3 为默认值
	JMail.Subject=topic  '邮件标题
	JMail.Body=mailbody  '邮件内容
	JMail.Send(EMAILSERVERURL) '执行邮件发送（通过邮件服务器地址）
	SendMail=JMail.log
	JMail.Close    '关闭邮件对象
End Sub 

' Dashboard Publish
Sub sendmaildashboardinsert(vyear, vquarter)
	dim JMail
	set JMail =Server.CreateObject( "JMail.Message" )
	JMail.Logging=True '启用使用日志
	JMail.silent = True '屏蔽例外错误，返回FALSE跟TRUE两值
	JMail.Charset="GB2312" '邮件文字的代码为简体中文
	JMail.ContentType = "text/html" '邮件的格式为HTML的

	Dim mailbody, topic
	' 添加邮件收件人为DM, BU Director, CEO, CFO, FC, Pricing, Marketing Director, FA, SD
	sql = "select * from userinfo where validflag='1' and id in (select userid from user_rolerel where roleid in (1, 3, 4, 5, 6, 7, 8, 11, 12))"
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipient rsmail("email") '邮件的收件人地址
		End If 
		rsmail.movenext
	Wend 
	topic = vyear & " " & vquarter & " IS Target Price Dashboard is published / Please check in IS e-Pricing System"
	mailbody = "<html><head><meta http-equiv=""Content-Type"" content=""text/html; charset=gb2312""></head><body>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "Dear all,<br>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "Please check " & vyear & " " & vquarter & " IS Target Price Dashboard in IS e-Pricing system. <br>"
	mailbody = mailbody & SERVERURL & "<br>"
	mailbody = mailbody & "***This email is automatically sent from IS e-Pricing System, please do not reply to this email.***"
	mailbody = mailbody & "</body></html>"

	JMail.AddRecipientCC "e.pricing@philips.com"
	JMail.From = FROMEMAILADD '发件人的地址
	JMail.FromName = "IS E-Pricing System"
	JMail.Priority = 3   '邮件的紧急程序，1 为最快，5 为最慢， 3 为默认值
	JMail.Subject=topic  '邮件标题
	JMail.Body=mailbody  '邮件内容
	JMail.Send(EMAILSERVERURL) '执行邮件发送（通过邮件服务器地址）
	SendMail=JMail.log
	JMail.Close    '关闭邮件对象
End Sub 

Sub sendmaildashboardupdate(vyear, vquarter)
	dim JMail
	set JMail =Server.CreateObject( "JMail.Message" )
	JMail.Logging=True '启用使用日志
	JMail.silent = True '屏蔽例外错误，返回FALSE跟TRUE两值
	JMail.Charset="GB2312" '邮件文字的代码为简体中文
	JMail.ContentType = "text/html" '邮件的格式为HTML的

	Dim mailbody, topic
	' 添加邮件收件人为DM, BU Director, CEO, CFO, FC, Pricing, Marketing Director, FA, SD
	sql = "select * from userinfo where validflag='1' and id in (select userid from user_rolerel where roleid in (1, 3, 4, 5, 6, 7, 8, 11, 12))"
	Set rsmail = conn.execute(sql)
	While Not rsmail.eof
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipient rsmail("email") '邮件的收件人地址
		End If 
		rsmail.movenext
	Wend 
	topic = vyear & " " & vquarter & " IS Target Price Dashboard is revised / Please check in IS e-Pricing System"
	mailbody = "<html><head><meta http-equiv=""Content-Type"" content=""text/html; charset=gb2312""></head><body>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "Dear all,<br>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "Please check " & vyear & " " & vquarter & " IS Target Price Dashboard in IS e-Pricing system. <br>"
	mailbody = mailbody & SERVERURL & "<br>"
	mailbody = mailbody & "***This email is automatically sent from IS e-Pricing System, please do not reply to this email.***"
	mailbody = mailbody & "</body></html>"

	JMail.AddRecipientCC "e.pricing@philips.com"
	JMail.From = FROMEMAILADD '发件人的地址
	JMail.FromName = "IS E-Pricing System"
	JMail.Priority = 3   '邮件的紧急程序，1 为最快，5 为最慢， 3 为默认值
	JMail.Subject=topic  '邮件标题
	JMail.Body=mailbody  '邮件内容
	JMail.Send(EMAILSERVERURL) '执行邮件发送（通过邮件服务器地址）
	SendMail=JMail.log
	JMail.Close    '关闭邮件对象
End Sub 

' 发送找回密码邮件
Sub sendmailfindpassword(userid)
	dim JMail
	set JMail =Server.CreateObject( "JMail.Message" )
	JMail.Logging=True '启用使用日志
	JMail.silent = True '屏蔽例外错误，返回FALSE跟TRUE两值
	JMail.Charset="GB2312" '邮件文字的代码为简体中文
	JMail.ContentType = "text/html" '邮件的格式为HTML的

	Dim mailbody, topic
	' 添加邮件收件人为DM, BU Director, CEO, CFO, FC, Pricing, Marketing Director, FA
	sql = "select * from userinfo where validflag='1' and userid='" & userid & "'"
	Set rsmail = conn.execute(sql)
	If Not rsmail.eof Then 
		If Not IsNull(rsmail("email")) And rsmail("email") <> "" Then 
			JMail.AddRecipient rsmail("email") '邮件的收件人地址
		End If 
	End If 
	topic ="Password of IS e-Pricing system"
	mailbody = "<html><head><meta http-equiv=""Content-Type"" content=""text/html; charset=gb2312""></head><body>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "Dear " & rsmail("username") & ",<br>"
	mailbody = mailbody & "<br>"
	mailbody = mailbody & "Please find your user name and password of IS e-Pricing system as below:<br>"
	mailbody = mailbody & "ID: " & userid & "<br>"
	mailbody = mailbody & "Password: " & rsmail("password") & "<br>"
	mailbody = mailbody & "The password can be changed in the system:<br>"
	mailbody = mailbody & SERVERURL & " --> Setting --> Change Password --> Save<br>"
	mailbody = mailbody & "***This email is automatically sent from IS e-Pricing System, please do not reply to this email.***"
	mailbody = mailbody & "</body></html>"

	JMail.AddRecipientCC "e.pricing@philips.com"
	JMail.From = FROMEMAILADD '发件人的地址
	JMail.FromName = "IS E-Pricing System"
	JMail.Priority = 3   '邮件的紧急程序，1 为最快，5 为最慢， 3 为默认值
	JMail.Subject=topic  '邮件标题
	JMail.Body=mailbody  '邮件内容
	JMail.Send(EMAILSERVERURL) '执行邮件发送（通过邮件服务器地址）
	SendMail=JMail.log
	JMail.Close    '关闭邮件对象
End Sub 
%>