<!--#include file="../include/conn.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/utils.asp"-->
<%
	Dim sid,qid
	sid=request("sid")
	qid=request("qid")
	'ɾ���ؼ������¼
	sql="delete from special_price where id="&sid
	conn.execute(sql)
	sql="delete from special_approve where specialId="&sid
	conn.execute(sql)
	sql="delete from special_files where specialId="&sid
	conn.execute(sql)
	sql="delete from special_detail where specialId="&sid
	conn.execute(sql)
	'����quotation��״̬
	sql="update quotation set status=0 where qid="&qid
	conn.execute(sql)
	'�ر����ݿ�����
	CloseDatabase

	response.write("<script>location.href='specialList.asp';</script>")
%>