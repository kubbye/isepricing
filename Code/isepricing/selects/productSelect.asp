
<!--#include file="../include/conn.asp"-->
<!--#include file="../system/utils.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../include/utils.asp"-->
<%
		
		response.Charset="gb2312"
		dim bu,modality,searchSql,pids
		bu=request("bu")
		modality=request("modality")
		pids=request("pids")

		dim returnStr
		if not isempty(modality) and modality<>"" then   '查询产品
			searchSql="select pid,productname from PRODUCT where state=0 and status=0   and mid="&modality   'and pid not in("&pids&")
			'"& getversion("0") &"
			dim pl
			pl=execSql(searchSql)
			for i=0 to ubound(pl) 
				returnStr =returnStr &"<option value='"& pl(i,0)&"'>"& pl(i,1)&"</option>"
				'returnStr =returnStr &"<option value='1'>中国</option>"
			next
		
			response.Write(returnStr)
		elseif 1=2 then '查询modality
			searchSql="select mid,modality from modality where status=0 and bu='"& bu &"'"
			dim mll
			mll=execSql(searchSql)
			for i=0 to ubound(mll) 
				returnStr =returnStr &"<option value='"& mll(i,0)&"'>"&mll(i,1)&"</option>"
			next
			response.Write(returnStr)
		elseif isnull(modality) or modality="" then

			searchSql="select pid,productname from PRODUCT a where state=0 and status=0  and exists(select * from modality where bu="&bu&" and mid=a.mid)"
			pl=execSql(searchSql)
			for i=0 to ubound(pl) 
				returnStr =returnStr &"<option value='"& pl(i,0)&"'>"& pl(i,1)&"</option>"
			next
		
			response.Write(returnStr)
		end if
%>
<%
		CloseDatabase
%>
