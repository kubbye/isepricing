<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!--#include file="../include/commons.asp"-->
<!--#include file="../include/chkUser.asp"-->

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>IS E-pricing system</title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />

<script type="text/javascript">
   function importData(){
 	var f=document.fileform;
	if(f.importfile.value==null || f.importfile.value==""){
		alert("Please select document!");
		return false;
	}
	f.action="configuration_upload_submit.asp";
	f.submit();
 }
</script>

</head>

<body bgcolor="#ffffff" leftmargin="0" topmargin="0">
<div align="center">
  <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td><table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td class="titleorange"><div align="center">Upload Configurations</div></td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td>
			  <form name="fileform" action="" method="post" enctype="multipart/form-data">
			  <table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td> <div align="left">Upload Document: </div></td>
                  <td colspan="3" align="left">
                    <input class="lankuang" type="file" name="importfile"  value="Browse" size="80" />
				  </td>
				  <td>
				    <input type="submit" name="Submit2" value=" OK " onclick="importData()" />&nbsp;&nbsp;
					<input type="button" name="mould" value="Template" onclick="location.href='../mould/configuration_template.xlsx'"/>
				  </td>
                </tr>
              </table>
              </form>
            </td>
          </tr>
        </table></td>
    </tr>
  </table>
  <!--#include file="../footer.asp"-->
</div>
</body>
</html>
