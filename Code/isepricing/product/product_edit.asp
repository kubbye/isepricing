<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../include/commons.asp"-->
<!--#include file="../include/chkUser.asp"-->
<%

pid = request("pid")

sql = "select a.*, b.modality, b.bu from product a, modality b where a.mid=b.mid and a.pid=" & pid
Set rs = conn.execute(sql)

sql = "select * from product_detail_philips where type='0' and pid=" & pid & " order by sortno"
Set rs1 = conn.execute(sql)
rs1count=0
While Not rs1.eof
  rs1count=rs1count+1
  rs1.movenext
Wend 
Set rs1 = conn.execute(sql)

sql = "select * from product_detail_3rd where type='0' and pid=" & pid
Set rs2 = conn.execute(sql)
rs2count=0
While Not rs2.eof
  rs2count=rs2count+1
  rs2.movenext
Wend 
Set rs2 = conn.execute(sql)

sql = "select * from product_detail_philips where type='1' and pid=" & pid & " order by sortno"
Set rs3 = conn.execute(sql)
rs3count=0
While Not rs3.eof
  rs3count=rs3count+1
  rs3.movenext
Wend 
Set rs3 = conn.execute(sql)

sql = "select * from product_detail_3rd where type='1' and pid=" & pid
Set rs5 = conn.execute(sql)
rs5count=0
While Not rs5.eof
  rs5count=rs5count+1
  rs5.movenext
Wend 
Set rs5 = conn.execute(sql)

%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title>IS E-pricing system</title>
<link href="../css/css.css" rel="stylesheet" type="text/css">
<script src="../js/ut.js"></script>
<SCRIPT language=javascript src="../js/check.js"></SCRIPT>
<script language="javascript">
var xmlHttp
/*建立XMLHTTP对象调用MS的ActiveXObject方法，如果成功（IE浏览器）则使用MS ActiveX实例化创建一个XMLHTTP对象*/ 
//非IE则转用建立一个本地Javascript对象的XMLHttp对象 （此方法确保不同浏览器下对AJAX的支持）
function createXMLHttp(){
    if(window.ActiveXObject){
        xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
    }
    else if(window.XMLHttpRequest){
        xmlHttp = new XMLHttpRequest();
    }
}

//建立主过程
function startXMLHttp(bu, modality){
    createXMLHttp(); //建立xmlHttp 对象
    xmlHttp.open("get","modality_choose_ajax.asp?bu=" + bu + "&modality=" + modality, true); //建立一个新的http请求，传送方式 读取的页面 异步与否(如果为真则自动调用dodo函数)
    xmlHttp.send(); //发送
	xmlHttp.onreadystatechange =doaction; //xmlHttp下的onreadystatechange方法 控制传送过程
}

function doaction(){
    if(xmlHttp.readystate==4){ // xmlHttp下的readystate方法 4表示传送完毕
        if(xmlHttp.status==200){ // xmlHttp的status方法读取状态（服务器HTTP状态码） 200对应OK 404对应Not Found（未找到）等
             document.getElementById("modalityselect").innerHTML=xmlHttp.responseText //xmlHttp的responseText方法 得到读取页数据
           }
	}
}

function selectPhilips(tableid){
	openDialog("choose_configuration.asp?version=<%=rs("version")%>&tableid=" + tableid,'750','500'); 
}

function selectPhilipsOption(tableid){
	openDialog("choose_configuration_option.asp?rowflg=1&version=<%=rs("version")%>&tableid=" + tableid,'750','500'); 
}

function selectParty(tableid){
	openDialog("choose_party.asp?tableid=" + tableid,'750','500'); 
}

function selectPartyOption(tableid){
	openDialog("choose_party_option.asp?tableid=" + tableid,'750','500'); 
}

function getParentNode(b, tag) {
	var pnode = b.parentNode;
	while( pnode.tagName!=tag ) {
		pnode = pnode.parentNode;
		if(pnode.tagName=='BODY') break;
	}
	return pnode;
}

function selectBox(b) {
	var tr = getParentNode(b, 'TR');
	tr.checkFlag = b.checked;
	tr.box = b;
}

function deleteBox(tableid) {
	if (confirm("Confirm to delete?")){
		var tbl = document.getElementById(tableid);
		var rows = tbl.rows;
		for (var i=2; i<rows.length - 2; i++) {
			if ( rows[i].checkFlag ) {
				rows[i].removeNode(true);
				i--;
			}
		}
		sumlistprice(tableid);
	}
}

function deleteBox2(tableid) {
	if (confirm("Confirm to delete?")){
		var tbl = document.getElementById(tableid);
		var rows = tbl.rows;
		for (var i=2; i<rows.length - 1; i++) {
			if ( rows[i].checkFlag ) {
				rows[i].removeNode(true);
				i--;
			}
		}
		sumlistprice(tableid);
	}
}

function sumlistprice(tableid){
	var count = document.getElementById(tableid + "count").value;
	var sumlp = 0;
	for (var i = 0; i < count; i++){
		if (document.all(tableid + "_listprice" + i)){
			sumlp = parseFloat(sumlp) + parseFloat(document.all(tableid + "_listprice" + i).value) * document.all(tableid + "_qty" + i).value;
			document.getElementById(tableid + "_totallistpricediv" + i).innerHTML = parseInt(document.all(tableid + "_listprice" + i).value) * document.all(tableid + "_qty" + i).value;
		}
	}
	if (tableid == "standardphilips"){
		document.getElementById(tableid+"div").innerHTML = sumlp.toFixed(0);
	}
}

function validPlusInt(obj, tableid){
	if (!isPlusInt(obj.value)){
		alert ("You must input integer!");
		obj.value = "";
		obj.focus();
		return false;
	}
	sumlistprice(tableid);
}

function validPlusInt2(obj, tableid){
	if (obj.value != "" && obj.value != 0 && !isPlusInt(obj.value)){
		alert ("You must input integer!");
		obj.value = "";
		obj.focus();
		return false;
	}
}

function deleteParty(tableid) {
	if (confirm("Confirm to delete?")){
		var tbl = document.getElementById(tableid);
		var rows = tbl.rows;
		for (var i=2; i<rows.length - 1; i++) {
			if ( rows[i].checkFlag ) {
				rows[i].removeNode(true);
				i--;
			}
		}
		sumunitcost(tableid);
	}
}

function sumunitcost(tableid){
	var count = document.getElementById(tableid + "count").value;
	var sumlp = 0;
	for (var i = 0; i < count; i++){
		if (document.all(tableid + "_unitcost" + i)){
			document.getElementById(tableid + "_quotedcost" + i).innerHTML =  (parseFloat(document.all(tableid + "_unitcost" + i).value) * document.all(tableid + "_qty" + i).value).toFixed(0);
			sumlp = parseFloat(sumlp) + parseFloat(document.all(tableid + "_unitcost" + i).value) * document.all(tableid + "_qty" + i).value;
		}
	}
	//if (tableid == "standard3rd"){
	//	document.getElementById(tableid+"div").innerHTML = sumlp.toFixed(0);
	//}
}

function validPlusIntParty(obj, tableid){
	if (!isPlusInt(obj.value)){
		alert ("You must input integer!");
		obj.value = "";
		obj.focus();
		return false;
	}
	sumunitcost(tableid);
}

function checkfield(){
	if (document.forms[0].modality.value==""){
		alert ("Please select Modality!");
		return false;
	}
	if (document.forms[0].product.value==""){
		alert ("Please input Product name!");
		return false;
	}
	document.form1.submit();
}

function calctargetprice(){
}

function add3rd(){
	alert ("超过1500美金的非飞利浦第三方产品如需进单需要SCM批准!");
	var tbl = document.getElementById("standard3rd");
	var count = document.getElementById("standard3rdcount").value;
	newRow = tbl.insertRow(tbl.rows.length - 2);
	newRow.id = "onerecord";
	newRow.className = "line02";

	c1 =  newRow.insertCell(0);
	c1.innerHTML = "<input type='checkbox' name='standard3rd_medication' onclick='selectBox(this);'>";

	c2 =  newRow.insertCell(1);
	c2.innerHTML ="<select name='standard3rd_mutex" + count + "'><option value=''></option><option value='1'>1</option><option value='2'>2</option><option value='3'>3</option><option value='4'>4</option><option value='5'>5</option></select>";

	c3 =  newRow.insertCell(2);
	c3.innerHTML ="<input type='text' name='standard3rd_itemcode" + count + "'>";

	c4 = newRow.insertCell(3);
	c4.innerHTML = "<input type='text' name='standard3rd_itemname" + count + "' size='50'>";

	c5 = newRow.insertCell(4);
	c5.innerHTML =  "<input type='text' name='standard3rd_qty" + count + "' value='1' size='3' onblur='validPlusIntParty(this, \"standard3rd\");'>";
	
	c6 = newRow.insertCell(5);
	c6.innerHTML =  "<input type='text' name='standard3rd_unitcost" + count + "' size='8' value='0' onblur='inputcost(this, " + count + ")'><input type='hidden' name='standard3rd_unitcostrmb" + count + "' value='0'>";
	
	c7 = newRow.insertCell(6);
	c7.innerHTML =  "<div id='standard3rd_quotedcost" + count + "'>0</div>";

	document.getElementById("standard3rdcount").value = parseInt(document.getElementById("standard3rdcount").value) + 1;

	sumunitcost('standard3rd');

}

function inputcost(obj){
	if (!isPlusNumeric(obj.value)){
		alert ("Please input number!");
		obj.value = "";
		obj.focus();
		return false;
	}
	sumunitcost('standard3rd');
}


</script>
</head>

<body bgcolor="#ffffff" leftmargin="0" topmargin="0" onload="startXMLHttp('<%=rs("bu")%>', '<%=rs("mid")%>')">
<div align="center">
  <form name="form1" method="post" action="product_edit_submit.asp">
  <input type="hidden" name="pid" value="<%=pid%>">
  <input type="hidden" name="bu" value="<%=rs("bu")%>">
  <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td>
	    <table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td class="titleorange"><div align="center">Product Details</div></td>
          </tr>
          <tr> 
            <td valign="top" class="line01"> <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
                <tr> 
                  <td><table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                      <tr class="line01"> 
                        <td width="25%" height="25"> <div align="left">BU: <br>
                          </div></td>
                        <td width="25%"> <div align="left"> <%=BU_TYPE(rs("bu"), 1)%>
                          </div></td>
                        <td width="25%"> <div align="left">Modality:</div></td>
                        <td width="25%"><div id="modalityselect" align="left"> 
                          </div></td>
                      </tr>
                      <tr class="line01"> 
                        <td height="25"> <div align="left">Product:</div></td>
                        <td> <div align="left"> 
                            <input type="text" name="product" value="<%=rs("productname")%>">
                          </div></td>
                        <td><div align="left">&nbsp;</div></td>
                        <td><div align="left">&nbsp;
                          </div></td>
                      </tr>
                      <tr class="line01"> 
                        <td height="25"> <div align="left">Promotion Plan:</div></td>
                        <td colspan="3"> <div align="left"> 
                            <input type="text" name="remark" value="<%=porcSpecWord(rs("remark"))%>" size="80">
                          </div></td>
                      </tr>
                    </table></td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
	  </td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td><table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td class="line01">Standard Configurations</td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td>
			  <table id="standardphilips" width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td colspan="8">Philips Standard Configurations
				  <input type="hidden" name="standardphilipscount" value="<%=rs1count%>">
				  </td>
                </tr>
                <tr class="line01"> 
                  <td width="3%">&nbsp;</td>
                  <td width="3%">Mutex</td>
                  <td width="3%">No.</td>
                  <td width="10%">Article No.</td>
                  <td>Article Description</td>
                  <td width="5%">Qty</td>
                  <td>List Price</td>
                  <td>Total List Price</td>
                </tr>
				<%
				sumprice = 0
				i = 0
				While Not rs1.eof
				%>
					<tr class="line02">
					  <td width="3%"><input type='checkbox' name='standardphilips_medication' onclick='selectBox(this);'></td>
					   <td width="3%">
					    <select name="standardphilips_mutex<%=i%>">
						  <option value="" <%If rs1("mutex")="" Then %>selected<% End If %>></option>
						  <option value="1" <%If rs1("mutex")="1" Then %>selected<% End If %>>1</option>
						  <option value="2" <%If rs1("mutex")="2" Then %>selected<% End If %>>2</option>
						  <option value="3" <%If rs1("mutex")="3" Then %>selected<% End If %>>3</option>
						  <option value="4" <%If rs1("mutex")="4" Then %>selected<% End If %>>4</option>
						  <option value="5" <%If rs1("mutex")="5" Then %>selected<% End If %>>5</option>
						  <option value="6" <%If rs1("mutex")="6" Then %>selected<% End If %>>6</option>
						  <option value="7" <%If rs1("mutex")="7" Then %>selected<% End If %>>7</option>
						  <option value="8" <%If rs1("mutex")="8" Then %>selected<% End If %>>8</option>
						  <option value="9" <%If rs1("mutex")="9" Then %>selected<% End If %>>9</option>
						  <option value="10" <%If rs1("mutex")="10" Then %>selected<% End If %>>10</option>
						  <option value="11" <%If rs1("mutex")="11" Then %>selected<% End If %>>11</option>
						  <option value="12" <%If rs1("mutex")="12" Then %>selected<% End If %>>12</option>
						  <option value="13" <%If rs1("mutex")="13" Then %>selected<% End If %>>13</option>
						  <option value="14" <%If rs1("mutex")="14" Then %>selected<% End If %>>14</option>
						  <option value="15" <%If rs1("mutex")="15" Then %>selected<% End If %>>15</option>
						</select>
					  </td>
					  <td>
					    <input type='text' name='standardphilips_sortno<%=i%>' size="3" value='<%=rs1("sortno")%>'  onblur='validPlusInt2(this, "standardphilips");'>
						<input type='hidden' name='standardphilips_pdid<%=i%>' value='<%=rs1("pdid")%>'>
					  </td>
					  <td>
					    <%=rs1("materialno")%>
					    <input type='hidden' name='standardphilips_cid<%=i%>' value='<%=rs1("cid")%>'>
						<input type='hidden' name='standardphilips_materialno<%=i%>' value='<%=rs1("materialno")%>'>
					  </td>
					  <td>
					    <%=rs1("description")%>
					    <input type='hidden' name='standardphilips_description<%=i%>' value='<%=rs1("description")%>'>
					  </td>
					  <td>
					    <input type='text' name='standardphilips_qty<%=i%>' value='<%=rs1("qty")%>' size='3' onblur="validPlusInt(this, 'standardphilips');">
					  </td>
					  <td>
					    <%=Round(rs1("listprice"))%>
					    <input type='hidden' name='standardphilips_listprice<%=i%>' value='<%=Round(rs1("listprice"))%>'>
					    <input type='hidden' name='standardphilips_targetprice<%=i%>' value='<%=Round(rs1("targetprice"))%>'>
					    <input type='hidden' name='standardphilips_discount<%=i%>' value='<%=rs1("discount")%>'>
					  </td>
					  <td>
					    <div id="standardphilips_totallistpricediv<%=i%>"><%=Round(rs1("listprice") * rs1("qty"))%></div>
					  </td>
					</tr>
				<%
					sumprice = sumprice + rs1("listprice") * rs1("qty")
					i = i + 1
					rs1.movenext
				Wend 
				%>
				<tr class="line01">
                  <td colspan="7">Subtotal</td>
                  <td><div id="standardphilipsdiv"><%=Round(sumprice)%></div></td>
				</tr>
				<tr>
				  <td colspan="8"><div align="right"> 
					  <input type="button" name="Submit2" value="Add New" onclick="selectPhilips('standardphilips')">
					  &nbsp;&nbsp; 
					  <input type="button" name="Submit2" value="Delete" onclick="deleteBox('standardphilips')">
					  &nbsp;&nbsp; &nbsp;&nbsp; </div>
				  </td>
				</tr>
              </table>
			</td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td><table id="standard3rd" width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td colspan="7">Standard 3rd Party Products
				    <input type="hidden" name="standard3rdcount" value="<%=rs2count%>">
				  </td>
                </tr>
                <tr class="line01"> 
                  <td width="3%">&nbsp;</td>
                  <td width="3%">Mutex</td>
                  <td width="10%">Product Code</td>
                  <td>Product Name</td>
                  <td width="5%">Qty</td>
                  <td>Unit Cost</td>
                  <td>Total Cost</td>
                </tr>
				<%
				sumprice = 0
				i = 0
				While Not rs2.eof
				%>
					<tr class="line02">
					  <td><input type='checkbox' name='standard3rd_medication' onclick='selectBox(this);'></td>
					   <td width="3%">
					    <select name="standard3rd_mutex<%=i%>">
						  <option value="" <%If rs2("mutex")="" Then %>selected<% End If %>></option>
						  <option value="1" <%If rs2("mutex")="1" Then %>selected<% End If %>>1</option>
						  <option value="2" <%If rs2("mutex")="2" Then %>selected<% End If %>>2</option>
						  <option value="3" <%If rs2("mutex")="3" Then %>selected<% End If %>>3</option>
						  <option value="4" <%If rs2("mutex")="4" Then %>selected<% End If %>>4</option>
						  <option value="5" <%If rs2("mutex")="5" Then %>selected<% End If %>>5</option>
						</select>
					  </td>
					  <td>
					    <%
						If rs2("cid") = "" Or IsNull(rs2("cid")) Then 
						%>
						<input type='text' name='standard3rd_itemcode<%=i%>' value='<%=rs2("materialno")%>'>
						<%
						Else 
						%>
					    <%=rs2("materialno")%>
					    <input type='hidden' name='standard3rd_itemcode<%=i%>' value='<%=rs2("materialno")%>'>
						<%
						End If 
						%>
					  </td>
					  <td>
					    <%
						If rs2("cid") = "" Or IsNull(rs2("cid")) Then 
						%>
						<input type='text' name='standard3rd_itemname<%=i%>' value='<%=rs2("itemname")%>'>
						<%
						Else 
						%>
					    <%=rs2("itemname")%>
					    <input type='hidden' name='standard3rd_itemname<%=i%>' value='<%=rs2("itemname")%>'>
						<%
						End If 
						%>
					    <input type='hidden' name='standard3rd_cid<%=i%>' value='<%=rs2("cid")%>'>
						<input type='hidden' name='standard3rd_pdid<%=i%>' value='<%=rs2("pdid")%>'>
					  </td>
					  <td>
					    <input type='text' name='standard3rd_qty<%=i%>' value='<%=rs2("qty")%>' size='3' onblur='validPlusIntParty(this, "standard3rd");'>
					  </td>
					  <td>
					    <%
						If rs2("cid") = "" Or IsNull(rs2("cid")) Then 
						%>
						<input type='text' name='standard3rd_unitcost<%=i%>' value='<%=Round(rs2("unitcost"))%>' onblur='inputcost(this)'>
						<%
						Else 
						%>
					    <%=Round(rs2("unitcost"))%>
					    <input type='hidden' name='standard3rd_unitcost<%=i%>' value='<%=Round(rs2("unitcost"))%>'>
						<%
						End If 
						%>
					    <input type='hidden' name='standard3rd_unitcostrmb<%=i%>' value='<%=Round(rs2("unitcostrmb"))%>'>
					  </td>
					  <td>
					    <div id='standard3rd_quotedcost<%=i%>'><%=Round(rs2("unitcost") * rs2("qty"))%></div>
					  </td>
					</tr>
				<%
					'sumprice = sumprice + rs2("unitcost") * rs2("qty")
					i = i + 1
					rs2.movenext
				Wend 
				%>
                <!--<tr class="line01"> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>-->
                <tr> 
                  <td colspan="7"><div align="right"> 
					  <input type="button" name="Submit2" value="Add Non-philips 3rd" onclick="add3rd()">
					  &nbsp;&nbsp; 
                      <input type="button" name="Submit22" value="Add Philips 3rd" onclick="selectParty('standard3rd')">
                      &nbsp;&nbsp; 
                      <input type="button" name="Submit22" value="Delete" onclick="deleteParty('standard3rd')">
                      &nbsp;&nbsp; &nbsp;&nbsp; </div></td>
                </tr>
              </table></td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td><table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td class="line01">Options</td>
          </tr>
          <tr> 
            <td class="line01">以下选件不包含在“Standard Configuration”中，以下选件价格不包含在“Standard Net Target Price”中！</td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td><table id="options1philips" width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td colspan="8">Philips Key Options
				  <input type="hidden" name="options1philipscount" value="<%=rs3count%>">
				  </td>
                </tr>
                <tr class="line01"> 
                  <td width="3%">&nbsp;</td>
                  <td width="3%">Mutex</td>
                  <td width="3%">No.</td>
                  <td width="10%">Content</td>
                  <td width="10%">Article No.</td>
                  <td>Article Description</td>
                  <td width="5%">Qty</td>
                  <td>List Price</td>
                </tr>
				<%
				'sumprice = 0
				i = 0
				While Not rs3.eof
				%>
					<tr class="line02">
					  <td width="3%"><input type='checkbox' name='options1philips_medication' onclick='selectBox(this);'></td>
					  <td width="3%">
					    <select name="options1philips_mutex<%=i%>">
						  <option value="" <%If rs3("mutex")="" Then %>selected<% End If %>></option>
						  <option value="1" <%If rs3("mutex")="1" Then %>selected<% End If %>>1</option>
						  <option value="2" <%If rs3("mutex")="2" Then %>selected<% End If %>>2</option>
						  <option value="3" <%If rs3("mutex")="3" Then %>selected<% End If %>>3</option>
						  <option value="4" <%If rs3("mutex")="4" Then %>selected<% End If %>>4</option>
						  <option value="5" <%If rs3("mutex")="5" Then %>selected<% End If %>>5</option>
						</select>
					  </td>
					  <td>
					    <input type='text' name='options1philips_sortno<%=i%>' size="3" value='<%=rs3("sortno")%>' onblur='validPlusInt2(this, "options1philips");'>
					  </td>
					  <td>
					    <input type='text' name='options1philips_items<%=i%>' value='<%=rs3("items")%>'>
						<input type='hidden' name='options1philips_pdid<%=i%>' value='<%=rs3("pdid")%>'>
					  </td>
					  <td>
					    <%=rs3("materialno")%>
					    <input type='hidden' name='options1philips_cid<%=i%>' value='<%=rs3("cid")%>'>
						<input type='hidden' name='options1philips_materialno<%=i%>' value='<%=rs3("materialno")%>'>
					  </td>
					  <td>
					    <%=rs3("description")%>
					    <input type='hidden' name='options1philips_description<%=i%>' value='<%=rs3("description")%>'>
					  </td>
					  <td>
					    <input type='text' name='options1philips_qty<%=i%>' value='<%=rs3("qty")%>' size='3' onblur='validPlusInt(this, "options1philips");'>
					  </td>
					  <td>
					    <%=rs3("listprice")%>
					    <input type='hidden' name='options1philips_listprice<%=i%>' value='<%=Round(rs3("listprice"))%>'>
					    <input type='hidden' name='options1philips_targetprice<%=i%>' value='<%=Round(rs3("targetprice"))%>'>
					    <input type='hidden' name='options1philips_discount<%=i%>' value='<%=rs3("discount")%>'>
					  </td>
					</tr>
				<%
					'sumprice = sumprice + rs3("listprice")
					i = i + 1
					rs3.movenext
				Wend 
				%>
				<!--<tr class="line01">
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
				</tr>-->
				<tr>
				  <td colspan="8"><div align="right"> 
					  <input type="button" name="Submit2" value="Add New" onclick="selectPhilipsOption('options1philips')">
					  &nbsp;&nbsp; 
					  <input type="button" name="Submit2" value="Delete" onclick="deleteBox2('options1philips')">
					  &nbsp;&nbsp; &nbsp;&nbsp; </div>
				  </td>
				</tr>
              </table></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td><table id="options3rd" width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td colspan="6">Key 3rd Party Options
				    <input type="hidden" name="options3rdcount" value="<%=rs5count%>">
				  </td>
                </tr>
                <tr class="line01"> 
                  <td width="3%">&nbsp;</td>
                  <td width="10%">Product Code</td>
                  <td>Product Name</td>
                  <td width="5%">Qty</td>
                  <td>Unit Cost</td>
                  <td>Total Cost</td>
                </tr>
				<%
				'sumprice = 0
				i = 0
				While Not rs5.eof
				%>
					<tr class="line02">
					  <td><input type='checkbox' name='options3rd_medication' onclick='selectBox(this);'></td>
					  <td>
					    <%=rs5("materialno")%>
						<input type='hidden' name='options3rd_itemcode<%=i%>' value='<%=rs5("materialno")%>'>
					  </td>
					  <td>
					    <%=rs5("itemname")%>
					    <input type='hidden' name='options3rd_cid<%=i%>' value='<%=rs5("cid")%>'>
						<input type='hidden' name='options3rd_itemname<%=i%>' value='<%=rs5("itemname")%>'>
						<input type='hidden' name='options3rd_pdid<%=i%>' value='<%=rs5("pdid")%>'>
					  </td>
					  <td>
					    <input type='text' name='options3rd_qty<%=i%>' value='<%=rs5("qty")%>' size='3' onblur="validPlusIntParty(this, 'options3rd');">
					  </td>
					  <td>
					    <%=Round(rs5("unitcost"))%>
					    <input type='hidden' name='options3rd_unitcost<%=i%>' value='<%=Round(rs5("unitcost"))%>'>
					    <input type='hidden' name='options3rd_unitcostrmb<%=i%>' value='<%=Round(rs5("unitcostrmb"))%>'>
					  </td>
					  <td>
					    <div id='options3rd_quotedcost<%=i%>'><%=Round(rs5("unitcost") * rs5("qty"))%></div>
					  </td>
					</tr>
				<%
					'sumprice = sumprice + rs5("unitcost") * rs5("qty")
					i = i + 1
					rs5.movenext
				Wend 
				%>
                <!--<tr class="line01"> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>-->
                <tr> 
                  <td colspan="6"><div align="right"> 
                      <input type="button" name="Submit22" value="Add New" onclick="selectPartyOption('options3rd')">
                      &nbsp;&nbsp; 
                      <input type="button" name="Submit22" value="Delete" onclick="deleteParty('options3rd')">
                      &nbsp;&nbsp; &nbsp;&nbsp; </div></td>
                </tr>
              </table></td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td><div align="right"> 
          <input type="button" name="Submit" value=" Save " onclick="checkfield();">&nbsp;&nbsp;&nbsp;&nbsp;
		  <!--<input type="button" name="Return" value="Return" onclick="javascript:history.go(-1)">-->
        </div></td>
    </tr>
  </table>
  </form>
  <!--#include file="../footer.asp"-->
</div>
</body>
</html>
