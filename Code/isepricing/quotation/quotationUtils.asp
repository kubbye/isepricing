<%
	'判断philips选件的价格是否发生变化
	'1.产品已经不存在，必须重新选择产品
	'4.如果备件号已经不存在，必须重新选择
	'5.如果备件号存在，但是价格变化了，必须重新选择，价格变化在1美金以内认为价格没变化
	'
	Function getPhilipsOption(pid,bu,materialno,price,currencyrate,item)
		'产品id，备件号，原来价格，汇率，item
		strSql="select a.* from product  a left join modality b on a.mid=b.mid  where productname=(select productname from product where pid="&pid&") and a.state=0 and a.status=0 and b.bu="&bu
		Set rs_getoption1=conn.execute(strSql)
		If rs_getoption1.bof And rs_getoption1.eof Then
			getPhilipsOption="1"
		Else
			strSql="select * from product_detail_philips where type=1 and materialno='"&materialno&"'  and  pid="&rs_getoption1("pid")
			If item<>"" And  Not IsNull(item) Then
				strSql=strSql&" and items='"&item&"'"
			End If
			Set rs_getoption2=conn.execute(strSql)
			If rs_getoption2.bof And rs_getoption2.eof Then
				getPhilipsOption="4"
			Else
				If abs(CLng(rs_getoption2("listprice")*currencyrate) - CLng(price))>1 Then
					getPhilipsOption="5"
				Else
					getPhilipsOption="0"
				End if
			End if
			rs_getoption2.close
			Set rs_getoption2=nothing
		End If
		rs_getoption1.close
		Set rs_getoption1=nothing
	End Function
	
	'判断philips other options的价格是否发生变化
	'1.改备件已经不存在，标红
	'2.该备件价格发生变化，标红
	' 价格变化在1美金以内认为价格没变化

	Function getPhilipsOtherOption(materialno,bu,price,currencyrate,discount)
		strSql="select * from configurations where state=0 and status=0 and materialno='"&materialno&"'"
		Set rs_getoption1=conn.execute(strSql)
		If rs_getoption1.bof And rs_getoption1.eof Then
			getPhilipsOtherOption="1"
		Else
			If abs(CLng(rs_getoption1("listprice")*currencyrate*discount)-CLng(price))<=1 Then
				getPhilipsOtherOption="0"
			Else
				getPhilipsOtherOption="2"
			End if
		End If
		rs_getoption1.close
		Set rs_getoption1=nothing
	End Function

	
	'验证产品
	'Return:
	'0，产品未发生变化
	'1，产品价格发生变化
	'2. 产品已经不存在
	'
	'
	Function validProduct(pid)
		strSql="select a.pid,a.productName,a.bu,a.standardprice from v_product a where pid="&pid
		Set rs_getoption1=conn.execute(strSql)
		pName=rs_getoption1("productName")
		bu=rs_getoption1("bu")
		standardprice=rs_getoption1("standardprice")
		strSql2="select a.pid,a.productName,a.standardprice,b.bu from product a left join modality b on a.mid=b.mid where a.state=0 and a.status=0 and a.productName='"&pName&"' and b.bu='"&bu&"'"
		Set rs_getoption2=conn.execute(strSql2)
		If rs_getoption2.bof And rs_getoption2.eof Then
			validProduct="2"
		Else
			If CLng(rs_getoption2("standardprice"))=CLng(standardprice) Then
				validProduct="0"
			Else
				validProduct="1"
			End if
		End If
		rs_getoption1.close
		Set rs_getoption1=Nothing
		rs_getoption2.close
		Set rs_getoption2=nothing
	End Function

	'得到quotation的状态名称
	'0,normal;
	'1,OIT进单需再审批;
	'2,删除；
	'3 apply for OIT;
	'4.waiting for check
	'5.special priceing(特价审批进行中)
	'11.Special price approved
	'-1.Special price rejected
	'
	function quotationstatus(sid)
		Select Case sid
			Case 0
				quotationstatus="New"
			Case 1
				quotationstatus="OIT进单需再审批"
			Case 2
				quotationstatus="已删除"
			Case 3
				quotationstatus="Applied OIT"
			Case 4
				quotationstatus="Wait DM to check"
			Case 5
				quotationstatus="Applying Special Price"
			Case 11
				quotationstatus="Special Price Approved"
			Case 13
				quotationstatus="Closed"
			Case -1
				quotationstatus="Special Price Rejected"
			case Else
				quotationstatus="undefined"
		End select
	end Function
	
	function specialstatus(sid)
		If IsNull(sid) Or IsEmpty(sid) Or sid=0 Then
			specialstatus="No Special Price Application"
		ElseIf sid>0 Then
			specialstatus="Special Price Approved"
		ElseIf sid<0 Then
			specialstatus="Special Price Rejected"
		End if
	end function
%>
