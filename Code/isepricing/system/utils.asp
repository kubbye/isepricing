<!--#include file="../include/chkUser.asp"-->
<%
	dim rsSet,strSet
	function isHaveUser(userid,username)
		set rsSet=server.CreateObject("adodb.recordset")
	'用户是否已经存在
		strSet="select * from userinfo where userid='"&userid&"'"
		rsSet.open strSet,conn,1,1
		if rsSet.eof and rsSet.bof then
			isHaveUser=false
		else
			isHaveUser=true
		end if
	end function
	
	function isHaveRole(rolename)
		set rsSet=server.CreateObject("adodb.recordset")
		'角色是否已经存在
		strSet="select * from rolemsg where rolename='"&trim(rolename)&"'"
		rsSet.open strSet,conn,1,1
		if rsSet.eof and rsSet.bof then
			isHaveRole=false
		else
			isHaveRole=true
		end if
	end function
	
	'菜单是否已经存在
	function isHaveFunction(funname)
		set rsSet=server.CreateObject("adodb.recordset")
		strSet="select * from functiontree where funname='"&trim(funname)&"'"
		rsSet.open strSet,conn,1,1
		if rsSet.eof and rsSet.bof then
			isHaveFunction=false
		else
			isHaveFunction=true
		end if
	end function
	function getParentId(funid)
		set rsSet=server.CreateObject("adodb.recordset")
		strSet="select funid ,parentid from functiontree where funid="&funid
		rsSet.open strSet,conn,1,1
		if not rsSet.eof and not rsSet.bof then
			getParentId=rsSet("parentid")
		else
			getParentId=""
		end if
	end function
	
	function isContainElement(arr,e)
		for i=0 to ubound(arr)
			if arr(i)=e then
				isContainElement=true
				exit function
			end if
		next
		isContainElement=false
	end function 

	
	sub closeAll
		rsSet.close
		set rsSet=Nothing
	end sub
	
	function  execSql(sql)
		set rsSet=server.CreateObject("adodb.recordset")
		rsSet.open sql,conn,1,1
		execSql=resultMap(rsSet)
		closeAll
	end function 
	
	function resultMap(rs)
		if  rs.eof and  rs.bof then
			dim arr(0,2)
			resultMap=arr
		else
			redim arr(rs.recordcount-1,2)
			dim i
			i=0
			 while not rs.eof 
			 	arr(i,0)=rs.fields(0).value
				arr(i,1)=rs.fields(1).value
				i=i+1
			 	rs.movenext
			 wend
			 resultMap=arr
		end if
	end function
%>

