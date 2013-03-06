<!--#include file="../include/conn.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/utils.asp"-->
<%
	Dim sid,qid
	sid=request("sid")
	qid=request("qid")
	'删除特价申请记录
	sql="delete from special_price where id="&sid
	conn.execute(sql)
	sql="delete from special_approve where specialId="&sid
	conn.execute(sql)
	sql="delete from special_files where specialId="&sid
	conn.execute(sql)
	sql="delete from special_detail where specialId="&sid
	conn.execute(sql)
	'更改quotation的状态
	sql="update quotation set status=0 where qid="&qid
	conn.execute(sql)
	'关闭数据库连接
	CloseDatabase

	response.write("<script>location.href='specialList.asp';</script>")
%>