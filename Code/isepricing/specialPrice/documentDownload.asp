<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/commons.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="specialUtils.asp"-->

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title></title>
<LINK href="../css/css.css" type=text/css rel=stylesheet>
<script type="text/javascript" src="../js/My97DatePicker/WdatePicker.js" ></script>
<script type="text/javascript" src="../js/ut.js"></script>
<script type="text/javascript" src="../js/jquery-1.2.6.js"></script>
<script language="javascript">
	function downloadFile(no){
		if(no==1){
			$("#path").val("model/SOP-MKT-006 IS Pricing & Special Price Application.pdf");
			$("#fname").val("SOP-MKT-006 IS Pricing & Special Price Application.pdf");
		}
		if(no==2){
			$("#path").val("model/Special price approval Process (IS)(Sep 28).pptx");
			$("#fname").val("Special price approval Process (IS)(Sep 28).pptx");
		}
		if(no==3){
			$("#path").val("model/templates.zip");
			$("#fname").val("templates.zip");
		}
		document.forms[0].target="_top";
		document.forms[0].submit();	
	}
</script>

</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0">
<form method="post" action="../include/downloadFile.asp">
<input type="hidden" name="path" id="path">
<input type="hidden" name="fname" id="fname">
<div align="center">
  <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
   <tr> 
      <td>&nbsp;</td>
    </tr>
     <tr> 
      <td><table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td class="titleorange"><div align="center">Documents Download</div></td>
          </tr>
          <tr> 
            <td class="titleorange">&nbsp;</td>
          </tr>
         
          <tr> 
            <td class="line02">&nbsp; </td>
          </tr>
          <tr> 
            <td><table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" style="word-break:break-all">
                <tr class="line01"> 
                  <td width="10%">特价审批流程(SOP)</td>
                  <td width="20%" nowrap><a href="#" onclick="downloadFile(1);return false;" target='_top'>下载</a></td>
                </tr>
			
                <tr class="line01"> 
                  <td width="10%">流程图</td>
                  <td width="20%" nowrap><a href="#"  onclick="downloadFile(2);return false;"  target='_top'>下载</a></td>
                </tr>
				 <tr class="line01"> 
                  <td width="10%">模板</td>
                  <td width="20%" nowrap><a href="#" onclick="downloadFile(3);return false;"  target='_top'>下载</a></td>
                </tr>
              </table></td>
          </tr>
		  
		
	
        </table></td>
    </tr>
  </table>
  <!--#include file="../footer.asp"-->
</div>

</form>
</body>
</html>

