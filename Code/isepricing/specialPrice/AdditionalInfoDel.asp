<!--#include file="../include/conn.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/utils.asp"-->
<%


	conn.execute("delete from special_files where id="&request("fid"))
	'关闭数据库连接
	CloseDatabase

	response.write("删除成功")
%>