<!--#include file="../include/conn.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/sendMail2.asp"-->
<%
	dim qid,strsql
	qid=request("qid")
	response.Charset="gb2312"
	'����Ѿ����ؼۼ�¼����Ϊnew��״̬����Ҫ����Cancel�ؼ�����Ѿ����ؼۼ�¼����Ϊnew��״̬����Ҫ����Cancel�ؼ�
	sql="select * from special_price where (status=0)and quotationno=(select quotationno from quotation where qid="&qid&")"
	Set rs_statusQuery=conn.execute(sql)
	If Not rs_statusQuery.eof And Not rs_statusQuery.bof Then
		response.write("<script>alert('����ɾ���������ؼ����룬�����������');</script>")
		response.write("<script>location.href='quotationList.asp';</script>")
		response.end
	End If 
	'����Ѿ����ؼۼ�¼����Ϊwait dm to check����Ҫ�����ȴ����ؼ�
	sql="select * from special_price where (status=-2 or status=-9 or ispending=1)and quotationno=(select quotationno from quotation where qid="&qid&")"
	Set rs_statusQuery=conn.execute(sql)
	If Not rs_statusQuery.eof And Not rs_statusQuery.bof Then
		response.write("<script>alert('���ȴ���õ���SpecialPrice�١�Apply for OIT��!');</script>")
		response.write("<script>location.href='quotationList.asp';</script>")
		response.end
	End If 

	strsql="update quotation set status=3,updtuser='"&session("principleid")&"',updttime='"&getdate()&"' where qid="&qid
	conn.execute strsql
	'�����ʼ�
	Call sendmailApplyForOIT (qid)
	CloseDatabase
	response.write("<script>alert('success');</script>")
	response.write("<script>location.href='quotationList.asp';</script>")
%>
