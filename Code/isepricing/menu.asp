<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<html>
<head>
<!--<link rel=stylesheet href="js/mg5/examples/TB.css" type="text/css"> -->
<style type="text/css">
BODY { background-color: #cccccc; font-weight: bold;  font-size: 12pt;}

.menuBar {
  background-color: #cccccc;
  border: 2px solid;
  border-color: #cccccc #cccccc #cccccc #cccccc;
  padding: 1px 4px;
}

.menuPad {
  background-color: #cccccc;
  border: 2px solid;
  border-color: #e0b090 #906040 #906040 #e0b090;
  padding:4px;
}

.menuItem {
  background-color: transparent;
  border: 1px solid #cccccc;
  color: #000000;
  cursor: default;
  font-weight: bold;
  padding: 2px 6px 2px 6px;
}
.menuItemOn {
  background-color: transparent;
  border: 1px solid #cccccc;
  color: #000000;
  cursor: default;
  font-weight: bold;
  padding: 2px 6px 2px 6px;
  border-color: #e0b090 #906040 #906040 #e0b090;
}
.menuItemDown {
  background-color: transparent;
  border: 1px solid #cccccc;
  color: #000000;
  cursor: default;
  font-weight: bold;
  padding: 2px 6px 2px 6px;
  margin-top:1px; margin-left:1px;
  background-color: #906040;
  border-color: #704020 #e0b090 #e0b090 #704020;
}

.menuItemSub {
  background-color: transparent;
  border: 1px solid #cccccc;
  color: #000000;
  cursor: default;
  font-weight: bold;
  padding: 2px 6px 2px 6px;
  border: 1px solid #906040;
  background-color: #906040;
}

.holderSpace {
  border: 1px solid #cccccc;
  color: #c09070;
  font-weight: bold;
  padding: 2px 6px 2px 6px;
  font-family: "MS Sans Serif", Arial, sans-serif;
  font-size: 8pt;
  font-style: normal;
  font-weight: normal;
}

.menuFont {
  font-family: "MS Sans Serif", Arial, sans-serif;
  font-size: 8pt;
  font-style: normal;
  font-weight: normal;
  text-decoration: none;
}
.menuFontOff {
  font-family: "MS Sans Serif", Arial, sans-serif;
  font-size: 8pt;
  font-style: normal;
  font-weight: normal;
  text-decoration: none;
  color: #000000;
}
.menuFontOn {
  font-family: "MS Sans Serif", Arial, sans-serif;
  font-size: 8pt;
  font-style: normal;
  font-weight: normal;
  text-decoration: none;
  color: #fff0d0;
}

.menuFontOffBold {
  font-family: "MS Sans Serif", Arial, sans-serif;
  font-size: 8pt;
  font-style: normal;
  font-weight: normal;
  text-decoration: none;
  color: #000000;
  font-weight: bold;
}
.menuFontOnBold {
  font-family: "MS Sans Serif", Arial, sans-serif;
  font-size: 8pt;
  font-style: normal;
  font-weight: normal;
  text-decoration: none;
  color: #fff0d0;
  font-weight: bold;
}
.menuInfo { padding: 2px 6px 2px 6px; }

.itemTopOff { width:140px; padding:1px; border:0px solid #000000; text-align:center; background-color:#cccccc; }
.itemTopOn { cursor:default; width:140px; padding:1px; border:1px solid #000000; text-align:center; background-color:#333333; }
.tagOff { width:8px; height:12px; float:right; background:url("images/tagRN.gif") no-repeat bottom; }
.tagOn { width:8px; height:12px; float:right; background:url("images/tagRH.gif") no-repeat bottom; }
.tagDownOff { width:10px; height:0px; float:right; background:url("images/tagDN.gif") no-repeat bottom center; }
.tagDownOn { width:10px; height:0px; float:right; background:url("images/tagDH.gif") no-repeat bottom center; }

.separatorT { background-color:#906040; height:1px; margin-top:3px; }
.separatorB { background-color:#e0b090; height:1px; margin-bottom:3px; }
</style>


<script language="javascript" src="js/mg5/script/menuG5FX.js"></script>

</head>

<body onLoad="initMenu('Demo','top'); setSubFrame('Demo',parent.main);" bgcolor="#CCCCCC" scroll="no">
<div align="center">
<table cellpadding="0" width="1000" cellspacing="0" border="0" >
<tr>
<td  id="holder" align="center"><div class="menuBar"><div class="holderSpace">&nbsp;</div></div></td>
</tr>
</table>
</div>
</body>
</html>
