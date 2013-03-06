<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title>IS E-pricing System</title>
<link href="css/css.css" rel="stylesheet" type="text/css">
<script>
	function login(){
	  if(document.all("username").value==""){
		alert('UserName can\'t empty!');
		return false;
	  }
	  //document.form1.submit();
	}
</script>
</head>

<body onLoad="form1.username.focus();">
<Form Method = "POST" name="form1" Action="forgetpwd_submit.asp" onSubmit="return login();" >
<table width="600" height="400" border="0" align="center" cellpadding="0" cellspacing="0" background="images/login.jpg">
  <tr> 
    <td height="200">&nbsp;</td>
  </tr>
  <tr> 
    <td><table width="240" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr> 
          <td height="30"><font color="#666666" size="2">请输入用户名</font></td>
          <td height="30"> <input type="text" name="username"  size="20" style="width:150px"></td>
        </tr>
        </tr>
			<tr align="center"> 
           	<td colspan="2">&nbsp;</td>
          </tr>
		<tr align="center"> 
            <td height="40" colspan="2"> <p> 
                <input type="Submit" name="Submit" value="找回密码">
              </p>
              <p align="left"></p></td>
          </tr>
      </table></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
  </tr>
</table>
</Form>
</body>
</html>

