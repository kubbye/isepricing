
<%
	'状态：
	'-1.审批不通过
	'0，新建；
	'1，维护产品已保存；
	'2，待Sales Director审批；
	'3，待PM审批；
	'-3,Sales Director审批不通过
	'-4,PM审批不通过
	'-5,FC审批不通过
	'-6,Marketing Director审批不通过
	'4，待FC审批，
	'5，待Marketing Director 审批，
	'6。待FC 审批，
	'11，审批完成。
	Function getApproveStatus(status,productmodel)
		Dim statusName
		If productmodel =1 Then 
			Select case status
				case "-1" 
					statusName="Rejected"
				case "-2" 
					statusName="Wait DM to check"
				case "-9" 
					statusName="Wait DM to resubmit"
				case 0  
					statusName="New"
			   case 1
					statusName="New"
				case 2
					statusName="Wait for SD's Approval"
				case 3
					statusName="Wait for BU Director’s Approval"
				case "-3"
					statusName="SD Rejected"
				case "-4"
					statusName="BU Director Rejected"
				case "-5"
					statusName="FC Rejected"
				case 4
					statusName="Wait for FC's Approval"
				case 11
					statusName="Approved"
				case "-11"
					statusName="Canceled"
			   case else
					statusName="unefined"
			 end select 
		  End If 	
		  If productmodel =2 Then 
			Select case status
				case "-1"
					statusName="Rejected"
				case "-2" 
					statusName="Wait DM to check"
				case "-9" 
					statusName="Wait DM to resubmit"
				case "-3"
					statusName="SD Rejected"
				case "-4"
					statusName="BU Director Rejected"
				case "-5"
					statusName="FC Rejected"
				case "-6"
					statusName="MD Rejected"
				case 0  
					statusName="New"
			   case 1
					statusName="New"
				case 2
					statusName="Wait for SD's Approval"
				case 3
					statusName="Wait for FC's & MD's Approval"
				case 5
					statusName="Wait for MD's Approval"
				case 6
					statusName="Wait for FC's Approval"
				case 11
					statusName="Approved"
				case "-11"
					statusName="Canceled"
			   case else
					statusName="unefined"
			 end select 
		  End If 	
	 
		getApproveStatus=statusName
	End Function
	
'插入审批记录
'ACTIONTYPE:1,审批；2，submit；3，resubmit 4,pm comments；5，cancel
'result：1，审批通过，2，审批不通过;3,additional information
'remark：备注
	Sub doApprove(sid,actiontype,result,remark)
		sql="INSERT INTO Special_approve(specialId,approveUser ,approvetime ,result ,remark ,actiontype) VALUES('"&sid&"','"&session("principleid")&"','"&getdate()&"','"&result&"','"&remark&"','"&actiontype&"')"
		conn.execute(sql)
	End Sub
	
	
%>