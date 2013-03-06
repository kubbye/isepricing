<!--#include file="../include/chkUser.asp"-->
<%
	sub writeFuncByRoleId(roleid)
		dim strsql,lineend,sub_postfix
		 lineend=""
		 sub_postfix="-sub"
		strSql="select a.* from functiontree a   inner join functiontree c  on a.parentid=c.funid  where  a.funid!=1 and a.validflag='1' and c.validflag='1' "
		if not isempty(roleid) and roleid<>"" then
		  strsql=strsql & " and exists (select * from role_funcrel where roleid ="& roleid &" and funid=a.funid)"
		 end if
				strSql=strSql & "order by a.parentid,a.funorderid "
				set rsSet=server.CreateObject("adodb.recordset")
		rsSet.open strSql,conn,1,1
		addExit=true
		if  not rsSet.eof then
			  Set fso=Server.CreateObject("Scripting.FileSystemObject")
			  filepath=server.MapPath("../js/mg5/usermenu")
			  response.Write(filepath & "\content" & roleid & ".js")
			  'response.End()
			dim txtFile
			set  txtFile=fso.OpenTextFile(filepath & "/content" & roleid & ".js",2,true)
			
			txtFile.writeline("addMenu(""Demo"", ""demo-top"");" & lineend)
			  while not rsSet.eof 
			  
			 url=rsSet("FUNURL")
			if isempty(url) or url="" then
				url=""
			end if

			 parentid=rsSet("PARENTID")
			 funname=rsSet("FUNNAME")
			 funid=rsSet("FUNID")
			 isleaf=rsSet("ISLEAF")
			
			
			if parentid="1" Then
				oldparentid="1"
				menucode=funid & sub_postfix
				txtFile.writeline("addSubMenu(""demo-top"", """ & funname & """, """", """&url&""", """ & menucode &""", """");" & lineend)
			Else
				If addExit Then
					addExit=false
					 txtFile.writeline(" addLink(""demo-top"", ""Exit"", """", ""close.asp"", """");")
				End If 
				
				pcode=parentid & sub_postfix
				menucode=funid & sub_postfix
				if ifleaf="1" then
					txtFile.writeline("addSubMenu("""&pcode&""",  """&funname&""", """", """&url&""", """&menucode&""", """");" & lineend)
				else
					txtFile.writeline("addLink("""&pcode&""", """&funname&""", """", """&url&""", """");" & lineend)
				end if
			end if
			  	
				rsset.movenext
			  wend
			 'txtFile.writeline(" addLink(""demo-top"", ""Exit"", """", ""close.asp"", """");")
			 txtFile.writeline("endMenu();" & lineend)
			 txtFile.close
			 set txtFile=nothing
			
		end if
	end sub
	
	
	%>
	

	
