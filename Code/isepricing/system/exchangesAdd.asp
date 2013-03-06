<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/chkUser.asp"-->
<%
	dim str,id,sourcecode,currency1,rate,userid,nowtime
	id=request("id")
	sourcecode=request("sourcecode")
	currency1=request("currency")
	rate=request("rate")
	userid=session("principleid")
	nowtime=getdate()
	
	if id<>"" then 
		str="update exchanges set currency='"&currency1&"',rate='"&rate&"',updtuser=" & userid & ",updttime= '"&nowtime &"'" 	
		str=str&" where id="&id
	else
		'check sourcecode exists or not
		set rs=server.createObject("adodb.recordset")
		rs.open "select * from exchanges where sourcecode='"&sourcecode&"'" ,conn,1,1
		if not rs.eof and not rs.bof then
			response.Write("<script>alert('The currency code has existed!');history.back();</script>")
			response.End()
		end if
		str="insert into exchanges(sourcecode,currency,rate,targetcode,updtuser,updttime) values('"
		str=str&sourcecode&"','"&currency1&"','"&rate&"','USD','"&userid&"','"&nowtime&"')"
	end if
	conn.execute str
	
	CloseDatabase
	response.Redirect("exchanges.asp")
%>
