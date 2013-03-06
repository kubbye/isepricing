<!--#include file="include/chkUser.asp"-->
<html>

<head>
<title>IS E-pricing System</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">

<!--<script language="javascript" src="js/mg5/examples/menu/fst6-path.js"></script>  -->
<script language="javascript" src="js/mg5/examples/menu/brainjar-path.js"></script>
<script>
	var contentScript="js/mg5/usermenu/content<%=session("roleid")%>.js";
	var styleScript="js/mg5/examples/menu/fst6-style.js";
</script>
<script language="javascript" src="js/mg5/script/menuG5LoaderFSX.js"></script>

</head>


<frameset rows="144,20, *" border="0" frameborder="0" >
	<frame src="top.asp" scrolling="no" noresize="noresize"></frame>
	<frame src="menu.asp" marginwidth="200"  noresize="noresize"></frame>
	<frame src="welcome.asp" name="main"  noresize="noresize"></frame>
</frameset><noframes></noframes>



</html>

