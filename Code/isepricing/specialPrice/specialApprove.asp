<!--#include file="../include/conn.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../include/sendMail2.asp"-->
<!--#include file="specialUtils.asp"-->
<%
	Dim roleid,sid,statusid
	roleid=session("roleid")
	statusid=request("statusid")

	sid=request("specialId")
	comments=request("comments")
	actiontype=request("actiontype")
	result=request("result")

	comments=porcSpecWord(comments)
	'����
	Call doApprove(sid,actiontype,result,comments)
	
	If result=3 Then
		sql="update special_price set isAdditional='1',updtuser='"&session("principleid")&"',updttime='"&getdate()&"' where id="&sid
		conn.execute(sql)
		Call sendmailAddtionnalInformation(sid,false)
	End If
	If result<>3 Then
		'��ת����һ������
		sql="update special_price set status="&statusid &",updtuser='"&session("principleid")&"',updttime='"&getdate()&"' where id="&sid
		
		'���������ͨ��������quotation��״̬rejected
		If result=2 Then
			quotationSql="update quotation set status=-1 where qid in(select quotationid from special_price where id="&sid&")"
			conn.execute(quotationSql)
		End if
		'�������ͨ���ˣ�����quotationΪ����ͨ��
		If statusid=11 Then
			quotationSql="update quotation set status=11 where qid in(select quotationid from special_price where id="&sid&")"
			conn.execute(quotationSql)
		End if
	End if
	
	conn.execute(sql)
	'��ѯ��multi modality����single modality
	sql="select productmodel from special_price where id="&sid
	Set rs_pro=conn.execute(sql)
	If  Not rs_pro.eof   Then 
		productmodel=rs_pro("productmodel")
	End If  
	'������������̣����������ʼ�
	If actiontype="1" And productmodel="1" Then
		If roleid="8" And result="1" Then   'sd ����ͨ��
			Call sendmailSDApproved(sid,false)
		End If 
		If roleid="8" And result="2" Then   'sd ������ͨ��
			Call sendmailSDReject(sid)
		End If 

		If roleid="3" And result="1" Then   'bu Director  ����ͨ��
			Call sendmailBuApproved(sid,false)
		End If 
		If roleid="3" And result="2" Then   'bu Director  ������ͨ��
			Call sendmailBuReject(sid)
		End If 

		If roleid="6" And result="1" Then   'fc Director  ����ͨ��
			Call sendmailFCApproved(sid,false)
		End If 
		If roleid="6" And result="2" Then   'fc Director  ������ͨ��
			Call sendmailFCReject(sid)
		End If 
	End If 

		'������������̣����������ʼ�
	If actiontype="1" And productmodel="2" Then
		If roleid="8" And result="1" Then   'sd ����ͨ��
			Call sendmailSDApproved_multi(sid,false)
		End If 
		If roleid="8" And result="2" Then   'sd ������ͨ��
			Call sendmailSDReject_multi(sid)
		End If 

		If (roleid="6" Or roleid="4")And result="1" Then   'fc or md  ����ͨ��
			Call sendmailFCApproved_multi(sid,false)
		End If 
		If (roleid="6" Or roleid="4") And result="2" Then   'fc or md  ������ͨ��
			Call sendmailFCReject_multi(sid)
		End If 
	End If 

	rs_pro.close
	Set rs_pro=Nothing 
	'�ر����ݿ�����
	CloseDatabase
	


	response.write("<script>location.href='specialList.asp';</script>")
%>
