<!--#include file="../include/conn.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/utils.asp"-->
<%


	conn.execute("delete from special_files where id="&request("fid"))
	'�ر����ݿ�����
	CloseDatabase

	response.write("ɾ���ɹ�")
%>