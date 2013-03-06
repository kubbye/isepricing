<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/chkUser.asp"-->
<%
	dim str ,rs
	set rs=server.CreateObject("adodb.recordset")
	str="select * from functiontree where validflag=1  order by parentid,funorderid "
	rs.open str,conn,1,1
%>
<HTML>
<HEAD>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<LINK 
href="../css/style.css" type=text/css rel=stylesheet>
<STYLE type=text/css>
A {
	CURSOR: hand; TEXT-DECORATION: none
}
A:hover {
	LEFT: 1px; CURSOR: hand; COLOR: #8c89f8; POSITION: relative; TOP: 1px; TEXT-DECORATION: none
}
.style1 {
	COLOR: #ff0000
}
</STYLE>
<link rel="stylesheet" href="dtree/dtree.css">
<SCRIPT src="../js/ut.js"></SCRIPT>
<SCRIPT src="../js/selectDate.js"></SCRIPT>
<SCRIPT language=javascript src="../js/pupdate.js"></SCRIPT>
<SCRIPT language=javascript src="../js/editrow.js"></SCRIPT>
<SCRIPT language=javascript src="../js/editrow.js"></SCRIPT>
<SCRIPT language=javascript src="dtree/dtree.js" ></SCRIPT>
<META content="MSHTML 6.00.2900.3314" name=GENERATOR>
</HEAD>
<BODY text=#000000 bottomMargin=0 vLink=#000000 aLink=#000000 link=#000000 
bgColor=#eeeee3 leftMargin=0 topMargin=0 onLoad="parent.invoke();">
	<div id="treediv">
		<script>
			var d=new dTree("d");
			<%
				while not rs.eof 
			%>
			d.add(<%=rs("funid")%>,<%=rs("parentid")%>,'<%=rs("funname")%>','');
			<%
			rs.movenext
			 wend%>
			document.write(d);
		</script>
	</div>
	<%
		rs.close
		set rs=Nothing
		CloseDatabase
	%>
</BODY>
</HTML>
