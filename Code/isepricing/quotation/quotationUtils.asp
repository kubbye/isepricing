<%
	'�ж�philipsѡ���ļ۸��Ƿ����仯
	'1.��Ʒ�Ѿ������ڣ���������ѡ���Ʒ
	'4.����������Ѿ������ڣ���������ѡ��
	'5.��������Ŵ��ڣ����Ǽ۸�仯�ˣ���������ѡ�񣬼۸�仯��1����������Ϊ�۸�û�仯
	'
	Function getPhilipsOption(pid,bu,materialno,price,currencyrate,item)
		'��Ʒid�������ţ�ԭ���۸񣬻��ʣ�item
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
	
	'�ж�philips other options�ļ۸��Ƿ����仯
	'1.�ı����Ѿ������ڣ����
	'2.�ñ����۸����仯�����
	' �۸�仯��1����������Ϊ�۸�û�仯

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

	
	'��֤��Ʒ
	'Return:
	'0����Ʒδ�����仯
	'1����Ʒ�۸����仯
	'2. ��Ʒ�Ѿ�������
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

	'�õ�quotation��״̬����
	'0,normal;
	'1,OIT������������;
	'2,ɾ����
	'3 apply for OIT;
	'4.waiting for check
	'5.special priceing(�ؼ�����������)
	'11.Special price approved
	'-1.Special price rejected
	'
	function quotationstatus(sid)
		Select Case sid
			Case 0
				quotationstatus="New"
			Case 1
				quotationstatus="OIT������������"
			Case 2
				quotationstatus="��ɾ��"
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
