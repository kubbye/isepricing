<!--#include file="../include/conn.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../include/utils.asp"-->

<%
	dim qid,strsql
	qid=request("qid")
	strsql="update quotation set status=2,updtuser='"&session("principleid")&"',updttime='"&getdate()&"' where qid="&qid
	conn.execute strsql

	'������ؼ����룬ɾ���ؼ�����
	'ɾ���ؼ������¼
	sql="delete from special_price where quotationid="&qid
	conn.execute(sql)
	sql="delete from special_approve where specialId in(select id from special_price where quotationid="&qid&")"
	conn.execute(sql)
	sql="delete from special_files where specialId in (select id from special_price where quotationid="&qid&")"
	conn.execute(sql)
	sql="delete from special_detail where specialId  in (select id from special_price where quotationid="&qid&")"
	conn.execute(sql)
	CloseDatabase
	response.Write("success")
%>
