<!--#include file="../include/conn.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="processwaitforcheck.asp"-->
<%
	qid=request("qid")
	'�ж��Ƿ����еĲ�Ʒ���������
	'response.write(qid)
	'response.End()
	Set rs_procss=conn.execute("select count(*) as cnt from quotation_detail where qid="&qid&" and isprocess=0")
	'response.write("<script>alert('"&rs_procss("cnt")&"');</script>")
	If IsNull(rs_procss("cnt")) Or rs_procss("cnt")="" or rs_procss("cnt")=0 Then
		'response.write("<script>alert('entering..........');</script>")
		conn.execute("update quotation set iseditfinished=1 where qid="&qid)
		conn.execute("update special_price set isEdit=1 where quotationno=(select quotationno from quotation where qid="&qid&")")
		'������Ϊ�գ�˵���Ѿ��������
		'��������ɺ󣬴��ݵ��ؼ�
		Call processWaitForCheck(qid)
		'response.redirect("quotationList.asp")
		response.write("<script>location.href='quotationList.asp';</script>")
	Else 
		response.write("<script>alert('���������в�Ʒ�ٵ㡰Edit Finished����');</script>")
		'response.Redirect("quotationEdit.asp?qid="+qid)
		response.write("<script>location.href='quotationEdit.asp?qid="&qid&"';</script>")
	End If 
	CloseDatabase
%>
