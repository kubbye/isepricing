
<%
	'״̬��
	'-1.������ͨ��
	'0���½���
	'1��ά����Ʒ�ѱ��棻
	'2����Sales Director������
	'3����PM������
	'-3,Sales Director������ͨ��
	'-4,PM������ͨ��
	'-5,FC������ͨ��
	'-6,Marketing Director������ͨ��
	'4����FC������
	'5����Marketing Director ������
	'6����FC ������
	'11��������ɡ�
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
					statusName="Wait for BU Director��s Approval"
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
	
'����������¼
'ACTIONTYPE:1,������2��submit��3��resubmit 4,pm comments��5��cancel
'result��1������ͨ����2��������ͨ��;3,additional information
'remark����ע
	Sub doApprove(sid,actiontype,result,remark)
		sql="INSERT INTO Special_approve(specialId,approveUser ,approvetime ,result ,remark ,actiontype) VALUES('"&sid&"','"&session("principleid")&"','"&getdate()&"','"&result&"','"&remark&"','"&actiontype&"')"
		conn.execute(sql)
	End Sub
	
	
%>