<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/commons.asp"-->
<!--#include file="../include/chkUser.asp"-->
<%

pid = request("pid")

sql = "select a.*, b.modality, b.bu from product a, modality b where a.mid=b.mid and a.pid=" & pid
Set rs = conn.execute(sql)

sql = "select *, convert(varchar, discount) discount from product_detail_philips where type='0' and pid=" & pid
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

sql = "select *, convert(varchar, discount) discount from product_detail_philips where type='1' and pid=" & pid
Set rs3 = conn.execute(sql)
rs3count=0
While Not rs3.eof
  rs3count=rs3count+1
  rs3.movenext
Wend 
Set rs3 = conn.execute(sql)

sql = "select *, convert(varchar, discount) discount from product_detail_philips where type='2' and pid=" & pid
Set rs4 = conn.execute(sql)
rs4count=0
While Not rs4.eof
  rs4count=rs4count+1
  rs4.movenext
Wend 
Set rs4 = conn.execute(sql)

sql = "select * from product_detail_3rd where type='1' and pid=" & pid
Set rs5 = conn.execute(sql)
rs5count=0
While Not rs5.eof
  rs5count=rs5count+1
  rs5.movenext
Wend 
Set rs5 = conn.execute(sql)

unexistcount = 0

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

function selectPhilipsAll(tableid){
	openDialog("choose_configuration_editall.asp?tableid=" + tableid,'750','500'); 
}

function selectPhilipsOptionAll(tableid){
	openDialog("choose_configuration_option_editall.asp?tableid=" + tableid,'750','500'); 
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
	var tbl = document.getElementById(tableid);
	var rows = tbl.rows;
	for (var i=2; i<rows.length - 2; i++) {
		if ( rows[i].checkFlag ) {
			if (rows[i].id != ""){
				document.all("unexistcount").value = document.all("unexistcount").value - 1;
			}
			rows[i].removeNode(true);
			i--;
		}
	}
	sumlistprice(tableid);
}

function sumlistprice(tableid){
	var count = document.getElementById(tableid + "count").value;
	var sumlp = 0;
	for (var i = 0; i < count; i++){
		if (document.all(tableid + "_listprice" + i)){
			if (document.all(tableid + "_qty" + i)){
				sumlp = parseFloat(sumlp) + parseFloat(document.all(tableid + "_listprice" + i).value) * document.all(tableid + "_qty" + i).value;
			} else {
				sumlp = parseFloat(sumlp) + parseFloat(document.all(tableid + "_listprice" + i).value);
			}
		}
	}
	document.getElementById(tableid+"div").innerHTML = sumlp.toFixed(2);
	calctargetprice();
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

function deleteParty(tableid) {
	var tbl = document.getElementById(tableid);
	var rows = tbl.rows;
	for (var i=2; i<rows.length - 2; i++) {
		if ( rows[i].checkFlag ) {
			if (rows[i].id != ""){
				document.all("unexistcount").value = document.all("unexistcount").value - 1;
			}
			rows[i].removeNode(true);
			i--;
		}
	}
	sumunitcost(tableid);
}

function sumunitcost(tableid){
	var count = document.getElementById(tableid + "count").value;
	var sumlp = 0;
	for (var i = 0; i < count; i++){
		if (document.all(tableid + "_unitcost" + i)){
			if ( document.all(tableid + "_qty" + i)){
				document.getElementById(tableid + "_quotedcost" + i).innerHTML =  (parseFloat(document.all(tableid + "_unitcost" + i).value) * document.all(tableid + "_qty" + i).value).toFixed(4);
				sumlp = parseFloat(sumlp) + parseFloat(document.all(tableid + "_unitcost" + i).value) * document.all(tableid + "_qty" + i).value;
			} else {
				document.getElementById(tableid + "_quotedcost" + i).innerHTML =  parseFloat(document.all(tableid + "_unitcost" + i).value);
				sumlp = parseFloat(sumlp) + parseFloat(document.all(tableid + "_unitcost" + i).value);
			}
		}
	}
	document.getElementById(tableid+"div").innerHTML = sumlp.toFixed(4);
	calctargetprice();
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
	if (document.forms[0].bu.value==""){
		alert ("Please choose BU!");
		return false;
	}
	if (document.forms[0].modality.value==""){
		alert ("Please select Modality!");
		return false;
	}
	if (document.forms[0].product.value==""){
		alert ("Please input Product name!");
		return false;
	}
	if (!isPlusNumeric(document.forms[0].targetprice.value)){
		alert ("Target price must be number!");
		return false;
	}
}

function calctargetprice(){
	var standardphilipscount = document.form1.standardphilipscount.value;
	var standard3rdcount = document.form1.standard3rdcount.value;
	var options1philipscount = document.form1.options1philipscount.value;
	var options2philipscount = document.form1.options2philipscount.value;
	var options3rdcount = document.form1.options3rdcount.value;
	var standardprice = 0;
	var targetprice = 0;

	for (var i = 0; i < standardphilipscount; i++){
		if (document.all("standardphilips_listprice" + i) &&  document.all("standardphilips_qty" + i) && document.all("standardphilips_discount" + i)){
			targetprice = targetprice + parseFloat(document.all("standardphilips_listprice" + i).value * document.all("standardphilips_qty" + i).value * document.all("standardphilips_discount" + i).value);
		}
	}
	for (var i = 0; i < standard3rdcount; i++){
		if (document.all("standard3rd_unitcost" + i) &&  document.all("standard3rd_qty" + i)){
			targetprice = targetprice + parseFloat(document.all("standard3rd_unitcost" + i).value * document.all("standard3rd_qty" + i).value);
		}
	}
	standardprice = targetprice;
	for (var i = 0; i < options1philipscount; i++){
		if (document.all("options1philips_listprice" + i) &&  document.all("options1philips_discount" + i)){
			targetprice = targetprice + parseFloat(document.all("options1philips_listprice" + i).value * document.all("options1philips_discount" + i).value);
		}
	}
	for (var i = 0; i < options2philipscount; i++){
		if (document.all("options2philips_listprice" + i) &&  document.all("options2philips_discount" + i)){
			targetprice = targetprice + parseFloat(document.all("options2philips_listprice" + i).value * document.all("options2philips_discount" + i).value);
		}
	}
	for (var i = 0; i < options3rdcount; i++){
		if (document.all("options3rd_unitcost" + i)){
			targetprice = targetprice + parseFloat(document.all("options3rd_unitcost" + i).value);
		}
	}

	document.form1.targetprice.value = targetprice.toFixed(4);
	document.form1.standardprice.value = standardprice.toFixed(4);
}

function batchdiscount(obj, tableid){
	if (!isPlusNumeric(obj.value)){
		alert ("Please input number!");
		obj.value = "";
		obj.focus();
		return false;
	}
	var count = document.all(tableid+"count").value;
	for (var i = 0; i < count; i ++){
		document.all(tableid+"_discount"+i).value = obj.value;
		document.getElementById(tableid + "_targetpricediv" + i).innerHTML = (obj.value * document.all(tableid+"_listprice"+i).value).toFixed(2);
	}
	calctargetprice();
}

function validPlusNumeric(obj, tableid, i, listprice){
	if (!isPlusNumeric(obj.value)){
		alert ("Please input number!");
		obj.value = "";
		obj.focus();
		return false;
	}
	document.getElementById(tableid + "_targetpricediv" + i).innerHTML = (obj.value * listprice).toFixed(2);
	calctargetprice();
}

function toDynamic(pid){
	openDialog("product_editprice_discount.asp?pid=" + pid,'750','500'); 
}
</script>
</head>

<body bgcolor="#ffffff" leftmargin="0" topmargin="0" onload="startXMLHttp('<%=rs("bu")%>', '<%=rs("mid")%>')">
<div align="center">
  <form name="form1" method="post" action="product_editall_submit.asp" onsubmit="return checkfield();">
  <input type="hidden" name="pid" value="<%=pid%>">
  <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td>
	    <table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td class="titleorange"><div align="center">Product and Configurtions</div></td>
          </tr>
          <tr> 
            <td valign="top" class="line01"> <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
                <tr> 
                  <td><table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                      <tr class="line01"> 
                        <td width="25%" height="25"> <div align="left">BU: <br>
                          </div></td>
                        <td width="25%"> <div align="left"> 
                            <select name="bu" onchange="startXMLHttp(this.value, '<%=rs("mid")%>')">
                              <%
							  For i = 1 To UBound(BU_TYPE)
							  %>
							  <option VALUE="<%=BU_TYPE(i,0)%>" <%If CStr(rs("bu")) = CStr(BU_TYPE(i,0)) Then %> selected <%End If %>><%=BU_TYPE(i,1)%></option>
							  <%
							  Next 
							  %>
                            </select>
                          </div></td>
                        <td width="25%"> <div align="left">Modality Name:</div></td>
                        <td width="25%"><div id="modalityselect" align="left"> 
                          </div></td>
                      </tr>
                      <tr class="line01"> 
                        <td height="25"> <div align="left">Product Name</div></td>
                        <td> <div align="left"> 
                            <input type="text" name="product" value="<%=rs("productname")%>">
                          </div></td>
                        <td><div align="left">Total Target Price</div></td>
                        <td><div align="left">
						   <input type="text" name="targetprice" value="<%=rs("targetprice")%>" readonly>
                          </div></td>
                      </tr>
                      <tr class="line01"> 
                        <td height="25"> <div align="left">Standard Target Price</div></td>
                        <td> <div align="left"> 
                            <input type="text" name="standardprice" value="<%=rs("standardprice")%>" readonly>
                          </div></td>
                        <td><div align="left">&nbsp;</div></td>
                        <td><div align="left">
                            &nbsp;
                          </div></td>
                      </tr>
                      <tr class="line01"> 
                        <td height="25"> <div align="left">Promotion Plan</div></td>
                        <td colspan="3"> <div align="left"> 
                            <input type="text" name="remark" value="<%=rs("remark")%>" size="80">
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
                  <td colspan="7">Philips
				  <input type="hidden" name="standardphilipscount" value="<%=rs1count%>">
				  </td>
				  <td>
				    <input type="text" size="6" name="standardphilipsbatchdiscount" onblur="batchdiscount(this, 'standardphilips');">
				  </td>
                </tr>
                <tr class="line01"> 
                  <td width="3%">&nbsp;</td>
                  <td width="14%">Items</td>
                  <td width="14%">Material No.</td>
                  <td width="28%">Material Details</td>
                  <td width="9%">Quantity</td>
                  <td width="11%">List Price</td>
                  <td>Target Price</td>
                  <td>Discount Rate</td>
                </tr>
				<%
				sumprice = 0
				i = 0
				While Not rs1.eof
				%>
					<tr class="line02">
					  <td width="3%"><input type='checkbox' name='standardphilips_medication' onclick='selectBox(this);'></td>
					  <td>
					    <input type='text' name='standardphilips_items<%=i%>' value='<%=rs1("items")%>'>
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
					    <%=rs1("listprice")%>
					    <input type='hidden' name='standardphilips_listprice<%=i%>' value='<%=rs1("listprice")%>'>
					  </td>
					  <td><div id="standardphilips_targetpricediv<%=i%>">&nbsp;<%=rs1("targetprice")%></div></td>
					  <td>
					     <input type="text" size="6" name="standardphilips_discount<%=i%>" value="<%=rs1("discount")%>" onblur="validPlusNumeric(this, 'standardphilips', '<%=i%>', '<%=rs1("listprice")%>');">
					  </td>
					</tr>
				<%
					sumprice = sumprice + rs1("listprice")
					i = i + 1
					rs1.movenext
				Wend 
				%>
				<tr class="line01">
                  <td width="3%">&nbsp;</td>
                  <td width="14%">Grandtotal</td>
                  <td width="14%">&nbsp;</td>
                  <td width="28%">&nbsp;</td>
                  <td width="9%">&nbsp;</td>
                  <td width="11%"><div id="standardphilipsdiv"><%=sumprice%></div></td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
				</tr>
				<tr>
				  <td colspan="8"><div align="right"> 
					  <input type="button" name="Submit2" value="Add" onclick="selectPhilipsAll('standardphilips')">
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
                  <td colspan="5">the 3rd Parth
				    <input type="hidden" name="standard3rdcount" value="<%=rs2count%>">
				  </td>
                </tr>
                <tr class="line01"> 
                  <td width="3%">&nbsp;</td>
                  <td width="30%">Description</td>
                  <td width="15%">Quantity</td>
                  <td width="17%">Unit Cost</td>
                  <td width="24%">Quoted Cost</td>
                </tr>
				<%
				sumprice = 0
				i = 0
				While Not rs2.eof
				%>
					<tr class="line02">
					  <td><input type='checkbox' name='standard3rd_medication' onclick='selectBox(this);'></td>
					  <td>
					    <%=rs2("materialno")%>
					    <input type='hidden' name='standard3rd_cid<%=i%>' value='<%=rs2("cid")%>'>
						<input type='hidden' name='standard3rd_itemname<%=i%>' value='<%=rs2("materialno")%>'>
					  </td>
					  <td>
					    <input type='text' name='standard3rd_qty<%=i%>' value='<%=rs2("qty")%>' size='3' onblur='validPlusIntParty(this, "standard3rd");'>
					  </td>
					  <td>
					    <%=rs2("unitcost")%>
					    <input type='hidden' name='standard3rd_unitcost<%=i%>' value='<%=rs2("unitcost")%>'>
					  </td>
					  <td>
					    <div id='standard3rd_quotedcost<%=i%>'><%=rs2("unitcost") * rs2("qty")%></div>
					  </td>
					</tr>
				<%
					sumprice = sumprice + rs2("unitcost") * rs2("qty")
					i = i + 1
					rs2.movenext
				Wend 
				%>
                <tr class="line01"> 
                  <td>&nbsp;</td>
                  <td>Total Cost</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td><div id="standard3rddiv"><%=sumprice%></div></td>
                </tr>
                <tr> 
                  <td colspan="5"><div align="right"> 
                      <input type="button" name="Submit22" value="Add" onclick="selectParty('standard3rd')">
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
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td><table id="options1philips" width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td colspan="7">Philips Options 1
				    <input type="hidden" name="options1philipscount" value="<%=rs3count%>">
				  </td>
				  <td>
				    <input type="text" size="6" name="options1philipsbatchdiscount" onblur="batchdiscount(this, 'options1philips');">
				  </td>
                </tr>
                <tr class="line01"> 
                  <td width="3%">&nbsp;</td>
                  <td width="3%">Mutex</td>
                  <td width="14%">Items</td>
                  <td width="14%">Material No.</td>
                  <td width="28%">Material Details</td>
                  <td width="11%">List Price</td>
                  <td>Target Price</td>
                  <td>Discount Rate</td>
                </tr>
				<%
				sumprice = 0
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
					    <%=rs3("listprice")%>
					    <input type='hidden' name='options1philips_listprice<%=i%>' value='<%=rs3("listprice")%>'>
					  </td>
					  <td><div id="options1philips_targetpricediv<%=i%>">&nbsp;<%=rs3("targetprice")%></div></td>
					  <td>
					     <input type="text" size="6" name="options1philips_discount<%=i%>" value="<%=rs3("discount")%>" onblur="validPlusNumeric(this, 'options1philips', '<%=i%>', '<%=rs3("listprice")%>');">
					  </td>
					</tr>
				<%
					sumprice = sumprice + rs3("listprice")
					i = i + 1
					rs3.movenext
				Wend 
				%>
				<tr class="line01">
                  <td width="3%">&nbsp;</td>
                  <td width="3%">&nbsp;</td>
                  <td width="14%">Grandtotal</td>
                  <td width="14%">&nbsp;</td>
                  <td width="28%">&nbsp;</td>
                  <td width="11%"><div id="options1philipsdiv"><%=sumprice%></div></td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
				</tr>
				<tr>
				  <td colspan="8"><div align="right"> 
					  <input type="button" name="Submit2" value="Add" onclick="selectPhilipsOptionAll('options1philips')">
					  &nbsp;&nbsp; 
					  <input type="button" name="Submit2" value="Delete" onclick="deleteBox('options1philips')">
					  &nbsp;&nbsp; &nbsp;&nbsp; </div>
				  </td>
				</tr>
              </table></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td><table id="options2philips" width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td colspan="7">Philips Options 2
				    <input type="hidden" name="options2philipscount" value="<%=rs4count%>">
				  </td>
				  <td>
				    <input type="text" size="6" name="options2philipsbatchdiscount" onblur="batchdiscount(this, 'options2philips');">
				  </td>
                </tr>
                <tr class="line01"> 
                  <td width="3%">&nbsp;</td>
                  <td width="3%">Mutex</td>
                  <td width="14%">Items</td>
                  <td width="14%">Material No.</td>
                  <td width="28%">Material Details</td>
                  <td width="11%">List Price</td>
                  <td>Target Price</td>
                  <td>Discount Rate</td>
                </tr>
				<%
				sumprice = 0
				i = 0
				While Not rs4.eof
				%>
					<tr class="line02">
					  <td width="3%"><input type='checkbox' name='options2philips_medication' onclick='selectBox(this);'></td>
					  <td width="3%">
					    <select name="options2philips_mutex<%=i%>">
						  <option value="" <%If rs4("mutex")="" Then %>selected<% End If %>></option>
						  <option value="1" <%If rs4("mutex")="1" Then %>selected<% End If %>>1</option>
						  <option value="2" <%If rs4("mutex")="2" Then %>selected<% End If %>>2</option>
						  <option value="3" <%If rs4("mutex")="3" Then %>selected<% End If %>>3</option>
						  <option value="4" <%If rs4("mutex")="4" Then %>selected<% End If %>>4</option>
						  <option value="5" <%If rs4("mutex")="5" Then %>selected<% End If %>>5</option>
						</select>
					  </td>
					  <td>
					    <input type='text' name='options2philips_items<%=i%>' value='<%=rs4("items")%>'>
						<input type='hidden' name='options2philips_pdid<%=i%>' value='<%=rs4("pdid")%>'>
				      </td>
					  <td>
					    <%=rs4("materialno")%>
					    <input type='hidden' name='options2philips_cid<%=i%>' value='<%=rs4("cid")%>'>
						<input type='hidden' name='options2philips_materialno<%=i%>' value='<%=rs4("materialno")%>'>
					  </td>
					  <td>
					    <%=rs4("description")%>
					    <input type='hidden' name='options2philips_description<%=i%>' value='<%=rs4("description")%>'>
					  </td>
					  <td>
					    <%=rs4("listprice")%>
					    <input type='hidden' name='options2philips_listprice<%=i%>' value='<%=rs4("listprice")%>'>
					  </td>
					  <td><div id="options2philips_targetpricediv<%=i%>">&nbsp;<%=rs4("targetprice")%></div></td>
					  <td>
					     <input type="text" size="6" name="options2philips_discount<%=i%>" value="<%=rs4("discount")%>" onblur="validPlusNumeric(this, 'options2philips', '<%=i%>', '<%=rs4("listprice")%>');">
					  </td>
					</tr>
				<%
					sumprice = sumprice + rs4("listprice")
					i = i + 1
					rs4.movenext
				Wend 
				%>
				<tr class="line01">
                  <td width="3%">&nbsp;</td>
                  <td width="3%">&nbsp;</td>
                  <td width="14%">Grandtotal</td>
                  <td width="14%">&nbsp;</td>
                  <td width="28%">&nbsp;</td>
                  <td width="11%"><div id="options2philipsdiv"><%=sumprice%></div></td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
				</tr>
				<tr>
				  <td colspan="8"><div align="right"> 
					  <input type="button" name="Submit2" value="Add" onclick="selectPhilipsOptionAll('options2philips')">
					  &nbsp;&nbsp; 
					  <input type="button" name="Submit2" value="Delete" onclick="deleteBox('options2philips')">
					  &nbsp;&nbsp; &nbsp;&nbsp; </div>
				  </td>
				</tr>
              </table></td>
          </tr>
          <tr> 
            <td align="right">
			  <input type="button" name="btndynamic" value="Dynamic Discount" onclick="toDynamic('<%=pid%>');">&nbsp;
			</td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td><table id="options3rd" width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td colspan="4">the 3rd Options
				    <input type="hidden" name="options3rdcount" value="<%=rs5count%>">
				  </td>
                </tr>
                <tr class="line01"> 
                  <td width="3%">&nbsp;</td>
                  <td width="30%">Description</td>
                  <td width="17%">Unit Cost</td>
                  <td width="24%">Quoted Cost</td>
                </tr>
				<%
				sumprice = 0
				i = 0
				While Not rs5.eof
				%>
					<tr class="line02">
					  <td><input type='checkbox' name='options3rd_medication' onclick='selectBox(this);'></td>
					  <td>
					    <%=rs5("materialno")%>
					    <input type='hidden' name='options3rd_cid<%=i%>' value='<%=rs5("cid")%>'>
						<input type='hidden' name='options3rd_itemname<%=i%>' value='<%=rs5("materialno")%>'>
						<input type='hidden' name='options3rd_pdid<%=i%>' value='<%=rs5("pdid")%>'>
					  </td>
					  <td>
					    <%=rs5("unitcost")%>
					    <input type='hidden' name='options3rd_unitcost<%=i%>' value='<%=rs5("unitcost")%>'>
					  </td>
					  <td>
					    <div id='options3rd_quotedcost<%=i%>'><%=rs5("unitcost")%></div>
					  </td>
					</tr>
				<%
					sumprice = sumprice + rs5("unitcost")
					i = i + 1
					rs5.movenext
				Wend 
				%>
                <tr class="line01"> 
                  <td>&nbsp;</td>
                  <td>Total Cost</td>
                  <td>&nbsp;</td>
                  <td><div id="options3rddiv"><%=sumprice%></div></td>
                </tr>
                <tr> 
                  <td colspan="4"><div align="right"> 
                      <input type="button" name="Submit22" value="Add" onclick="selectPartyOption('options3rd')">
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
          <input type="submit" name="Submit" value="Save for This Product">&nbsp;&nbsp;&nbsp;&nbsp;
		  <input type="button" name="Return" value="Return" onclick="javascript:history.go(-1)">&nbsp;&nbsp;&nbsp;&nbsp;
		  <input type="hidden" name="unexistcount" value="<%=unexistcount%>">
        </div></td>
    </tr>
  </table>
  </form>
  <!--#include file="../footer.asp"-->
</div>
</body>
</html>
