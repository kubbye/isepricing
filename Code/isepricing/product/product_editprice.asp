<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../include/commons.asp"-->
<!--#include file="../include/chkUser.asp"-->
<%

pid = request("pid")

sql = "select a.*, b.modality, b.bu, convert(varchar, b.inst) minst, convert(varchar, b.warr) mwarr, b.apptraining mapptraining, b.apptrainingrmb mapptrainingrmb from product a, modality b where a.mid=b.mid and a.pid=" & pid
Set rs = conn.execute(sql)

If rs("status") = "0" Then
	confstatus = "0"
ElseIf rs("status") = "1" Then
	confstatus = "2"
Else 
	confstatus = "1"
End If 

sql = "select a.*, convert(varchar, a.discount) discount, b.wrp from product_detail_philips a, configurations b where a.materialno=b.materialno and b.state='0' and b.status='" & confstatus & "' and a.type='0' and a.pid=" & pid & " order by a.sortno"
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

sql = "select a.*, convert(varchar, a.discount) discount, b.wrp from product_detail_philips a, configurations b where a.materialno=b.materialno and b.state='0' and b.status='" & confstatus & "' and a.type='1' and a.pid=" & pid & " order by a.sortno"
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

sql = "select * from product_option_discount where type='0' and pid=" & pid
Set rs6 = conn.execute(sql)
rs6count = 0
While Not rs6.eof
	rs6count = rs6count + 1
	rs6.movenext
Wend 
Set rs6 = conn.execute(sql)


sql = "select * from exchanges"
Set rscurrency = conn.execute(sql)

sql = "select * from exchanges where sourcecode='" & rs("currency") & "'"
Set rsexchanges = conn.execute(sql)
Dim rate
If rsexchanges.eof Then
	rate = 1
Else 
	rate = rsexchanges("rate")
End If 

sql = "select *, convert(varchar, discount) discount from product_option_discount where type='0' and pid=" & pid
Set rsdynamic = conn.execute(sql)
dynamiccount = 0
While Not rsdynamic.eof
	dynamiccount = dynamiccount + 1
	rsdynamic.movenext
Wend 
Set rsdynamic = conn.execute(sql)

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
function startXMLHttp(currency){
    createXMLHttp(); //建立xmlHttp 对象
    xmlHttp.open("get","currency_choose_ajax.asp?currency=" + currency,true); //建立一个新的http请求，传送方式 读取的页面 异步与否(如果为真则自动调用dodo函数)
    xmlHttp.send(); //发送
	xmlHttp.onreadystatechange =doaction; //xmlHttp下的onreadystatechange方法 控制传送过程
}

function doaction(){
    if(xmlHttp.readystate==4){ // xmlHttp下的readystate方法 4表示传送完毕
        if(xmlHttp.status==200){ // xmlHttp的status方法读取状态（服务器HTTP状态码） 200对应OK 404对应Not Found（未找到）等
			// document.form1.currencyprice.value=xmlHttp.responseText  //xmlHttp的responseText方法 得到读取页数据
             //document.getElementById("modalityselect").innerHTML=xmlHttp.responseText //xmlHttp的responseText方法 得到读取页数据
			 document.getElementById("currencypricediv").innerHTML=xmlHttp.responseText //xmlHttp的responseText方法 得到读取页数据
			 calcprice();
           }
	}
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
	document.getElementById(tableid+"div").innerHTML = sumlp.toFixed(0);
}

function validPlusNumeric(obj, tableid, i, listprice){
	if (!isPlusNumeric(obj.value)){
		alert ("Please input number!");
		obj.value = "";
		obj.focus();
		return false;
	}
	document.getElementById(tableid + "_targetpricediv" + i).innerHTML = (obj.value * listprice).toFixed(0);
	calcprice();
}

function calctargetprice(){
	var options1philipscount = document.form1.options1philipscount.value;
	var options3rdcount = document.form1.options3rdcount.value;
	var standardprice = document.form1.standardprice.value;
	if (standardprice == ""){
		standardprice = 0;
	}
	var targetprice = parseFloat(standardprice);

	for (var i = 0; i < options1philipscount; i++){
		targetprice = targetprice + parseFloat(document.all("options1philips_listprice" + i).value * document.all("options1philips_discount" + i).value);
	}
	for (var i = 0; i < options3rdcount; i++){
		targetprice = targetprice + parseFloat(document.all("options3rd_unitcost" + i).value);
	}

	document.form1.targetprice.value = targetprice.toFixed(0);
}

function batchdiscount(obj, tableid){
	if (obj.value != ""){
		if (!isPlusNumeric(obj.value)){
			alert ("Please input number!");
			obj.value = "";
			obj.focus();
			return false;
		}
		var count = document.all(tableid+"count").value;
		for (var i = 0; i < count; i ++){
			document.all(tableid+"_discount"+i).value = obj.value;
			document.getElementById(tableid + "_targetpricediv" + i).innerHTML = (obj.value * document.all(tableid+"_listprice"+i).value).toFixed(0);
		}
		calcprice();
	}
}

function toDynamic(pid){
	openDialog("product_editprice_discount.asp?pid=" + pid,'750','500'); 
}

function calcprice(){
	//alert (document.all("currencyprice").value);
	var rate = document.form1.currencyprice.value;
	var count, sumprice, standardprice, targetprice, totalprice, listprice;
	totalprice = 0;
	// 计算产品标准价
	standardprice = 0;
	totalprice = 0;
	if (document.form1.standardprice.value != "" && document.form1.standardprice.value != 0){
		//standardprice = parseFloat(document.form1.standardprice.value).toFixed(2);
    	//document.form1.standardprice.value = standardprice;
		totalprice = parseFloat(document.form1.standardprice.value);
	}

	// 计算philips标准件价格
	count = document.form1.standardphilipscount.value;
	for (var i = 0; i < count; i ++){
		listprice = parseFloat(document.all("standardphilips_listprice"+i).value) * parseFloat(rate);
		document.getElementById("standardphilips_listpricediv"+i).innerHTML = listprice.toFixed(0);
	}
	// 计算第三方标准件价格
	count = document.form1.standard3rdcount.value;
	for (var i = 0; i < count; i ++){
		if (document.all("currency").value == "RMB"){
			listprice = parseFloat(document.all("standard3rd_unitcostrmb"+i).value);
		} else {
			listprice = parseFloat(document.all("standard3rd_unitcost"+i).value) * parseFloat(rate);
		}
		document.getElementById("standard3rd_unitcostdiv"+i).innerHTML = listprice.toFixed(0);
	}
	// 计算philips选装件一价格
	count = document.form1.options1philipscount.value;
	sumprice = 0;
	for (var i = 0; i < count; i ++){
		listprice = parseFloat(document.all("options1philips_listprice"+i).value) * parseFloat(rate);
		//alert (listprice);
		document.getElementById("options1philips_listpricediv"+i).innerHTML = listprice.toFixed(0);
		targetprice = listprice * parseFloat(document.all("options1philips_discount"+i).value);
		document.getElementById("options1philips_targetpricediv"+i).innerHTML = targetprice.toFixed(0);
		sumprice = sumprice + targetprice;
	}
	totalprice = totalprice + sumprice;
	//document.getElementById("options1philips_sumprice").innerHTML = sumprice.toFixed(0);
	// 计算第三方选装件价格
	count = document.form1.options3rdcount.value;
	sumprice = 0;
	for (var i = 0; i < count; i ++){
		if (document.all("currency").value == "RMB"){
			listprice = parseFloat(document.all("options3rd_unitcostrmb"+i).value);
		} else {
			listprice = parseFloat(document.all("options3rd_unitcost"+i).value) * parseFloat(rate);
		}
		document.getElementById("options3rd_unitcostdiv"+i).innerHTML = listprice.toFixed(0);
		sumprice = sumprice + listprice;
	}
	totalprice = totalprice + sumprice;
	//document.getElementById("options3rd_sumprice").innerHTML = sumprice.toFixed(0);

	document.all("targetprice").value = totalprice.toFixed(0);

	if (document.all("currency").value == "RMB"){
		document.getElementById("apptrainingdiv").innerHTML = document.all("mapptrainingrmb").value;
	} else {
		document.getElementById("apptrainingdiv").innerHTML = parseFloat(document.all("mapptraining").value) * parseFloat(rate);
	}
}

function checkfields(){
	if (document.form1.standardprice.value==""){
		alert ("Please input Standart Net Target Price!");
		return false;
	}
	if (document.form1.otherdiscount.value==""){
		alert ("Please input Non-Key Options Discount!");
		return false;
	}
	document.forms[0].submit();
}

function changefreight(obj){
	if (obj.value == "CIP"){
		document.getElementById("freightdiv").innerHTML = "0.5%";
	} else if (obj.value == "FCA"){
		document.getElementById("freightdiv").innerHTML = "0.0%";
	} else if (obj.value == "CIF"){
		document.getElementById("freightdiv").innerHTML = "0.3%";
	}
}

function checknum(obj){
	if (obj.value != "" && !isPlusNumeric(obj.value)){
		alert ("Please input number!");
		obj.value = "";
		obj.focus();
		return false;
	}
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

function deleteBox() {
	var tbl = document.getElementById("dynamictable");
	var rows = tbl.rows;
	for (var i=2; i<rows.length; i++) {
		if ( rows[i].checkFlag ) {
			rows[i].removeNode(true);
			i--;
		}
	}
}

function onothercost(){
//alert (document.getElementById("instdiv").disabled);
//alert (document.getElementById("apptrainingdiv").disabled);
//alert (document.getElementById("warrdiv").disabled);
	if (document.form1.inst.value == "1"){
		document.getElementById("instdiv").style.visibility = "visible";
	} else {
		document.getElementById("instdiv").style.visibility = "hidden";
	}
	if (document.form1.apptraining.value == "1"){
		document.getElementById("apptrainingdiv").style.visibility = "visible";
	} else {
		document.getElementById("apptrainingdiv").style.visibility = "hidden";
	}
	if (document.form1.warr.value == "1"){
		document.getElementById("warrdiv").style.visibility = "visible";
	} else {
		document.getElementById("warrdiv").style.visibility = "hidden";
	}
}

</script>

</head>

<body bgcolor="#ffffff" leftmargin="0" topmargin="0" onload="calcprice();onothercost();">
<div align="center">
  <form name="form1" action="product_editprice_submit.asp" method="post" >
  <input type="hidden" name="bu" value="<%=rs("bu")%>">
  <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td>
	    <table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td class="titleorange"><div align="center">Product and Configurations</div></td>
          </tr>
			<tr> 
			  <td>&nbsp;</td>
			</tr>
          <tr> 
            <td valign="top" class="line01"> <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
                <tr> 
                  <td><table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                      <tr class="line01"> 
                        <td width="25%" height="25"> <div align="left">BU: <br>
                          </div></td>
                        <td width="25%"> <div align="left"> <%=BU_TYPE(rs("bu"), 1)%></div></td>
                        <td width="25%"> <div align="left">Modality:</div></td>
                        <td width="25%"><div align="left"> <%=rs("modality")%>
                          </div></td>
                      </tr>
                      <tr class="line01"> 
                        <td height="25"> <div align="left">Product:</div></td>
                        <td> <div align="left"> 
                            <%=rs("productname")%>
                          </div></td>
                        <td><div align="left">Currency:</div></td>
                        <td align="left">
						  <select name="currency" onchange="startXMLHttp(this.value);">
						    <option value="USD" <%If rs("currency")="USD" Or rs("currency")="" Then %>selected<% End If %>>美元</option>
							<%
							While Not rscurrency.eof
							%>
							  <option value="<%=rscurrency("sourcecode")%>" <%If rs("currency")=rscurrency("sourcecode") Then %>selected<% End If %>><%=rscurrency("currency")%></option>
							<%
							  rscurrency.movenext
							Wend 
							%>
						  </select>
                          </div></td>
                      </tr>
                      <tr class="line01"> 
                        <td height="25"> <div align="left">Standard Net Target Price:</div></td>
                        <td> <div align="left"> 
                            &nbsp;<input type="text" name="standardprice" value="<%=Round(rs("standardprice"))%>" onchange="checknum(this);" onblur="calcprice();">
                          </div></td>
                        <td><div align="left">Total Target Price:</div></td>
                        <td align="left">
                           <input type="text" name="targetprice" value="<%=Round(rs("targetprice"))%>" readonly>
						   <input type="hidden" name="pid" value="<%=pid%>">
			              <div id="currencypricediv"><input type="hidden" name="currencyprice" value="<%=rate%>"></div>
                          </td>
                      </tr>
                      <tr class="line01"> 
                        <td height="25"> <div align="left">Non-Key Options Discount:</div></td>
                        <td> <div align="left"> 
                            &nbsp;<input type="text" size="6" name="otherdiscount" value="<%=rs("otherdiscount")%>" onchange="checknum(this);">
                          </div></td>
                        <td><div align="left">&nbsp;</div></td>
                        <td align="left">&nbsp;
                           
                          </td>
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
			<%
			colspan = 5
			dispwrp = ""
			If rs("bu") = "4" Then
				colspan = 6
				dispwrp = "1"
			End If 
			%>
			  <table id="standardphilips" width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td colspan="9">Philips Standard Configurations
				    <input type="hidden" name="standardphilipscount" value="<%=rs1count%>">
				  </td>
                </tr>
                <tr class="line01"> 
                  <td width="3%">Mutex</td>
                  <td width="3%">No.</td>
                  <td width="10%">Article No.</td>
                  <td>Article Description</td>
                  <td width="5%">Qty</td>
                  <td>List Price</td>
                  <td>Total List Price</td>
				  <td>CTP</td>
				  <td>Total CTP</td>
                </tr>
				<%
				i = 0
				sumprice = 0
				sumctp = 0
				While Not rs1.eof
				%>
					<tr class="line02">
					  <td><%=rs1("mutex")%>&nbsp;</td>
					  <td><%=rs1("sortno")%>&nbsp;</td>
					  <td><%=rs1("materialno")%></td>
					  <td><%=rs1("description")%></td>
					  <td><%=rs1("qty")%><input type="hidden" name="standardphilips_qty<%=i%>" value="<%=rs1("qty")%>"></td>
					  <td><div id="standardphilips_listpricediv<%=i%>"><%=Round(rs1("listprice"))%></div><input type="hidden" name="standardphilips_listprice<%=i%>" value="<%=Round(rs1("listprice"))%>"></td>
					  <td><div id="standardphilips_totallistpricediv<%=i%>"><%=Round(rs1("listprice")) * rs1("qty")%></div><input type="hidden" name="standardphilips_totallistprice<%=i%>" value="<%=Round(rs1("listprice")) * rs1("qty")%>"></td>
					  <td><%=Round(rs1("wrp"))%></td>
					  <td><div id="standardphilips_totalctpdiv<%=i%>"><%=Round(rs1("wrp")) * rs1("qty")%></div></td>
					</tr>
				<%
					i = i + 1
					sumprice = sumprice + Round(rs1("listprice")) * rs1("qty")
					sumctp = sumctp + Round(rs1("wrp")) * rs1("qty")
					rs1.movenext
				Wend 
				%>
				<tr class="line01">
                  <td colspan="6">Subtotal</td>
                  <td><%=sumprice%></td>
				  <td>&nbsp;</td>
				  <td><%=sumctp%></td>
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
                  <td colspan="5">Standard 3rd Party Products
				    <input type="hidden" name="standard3rdcount" value="<%=rs2count%>">
				  </td>
                </tr>
                <tr class="line01"> 
				  <td width="3%">Mutex</td>
				  <td width="10%">Product Code</td>
                  <td>Product Name</td>
                  <td width="5%">Qty</td>
                  <td>Unit Cost</td>
                </tr>
				<%
				i = 0
				While Not rs2.eof
				%>
					<tr class="line02">
					  <td><%=rs2("mutex")%>&nbsp;</td>
					  <td><%=rs2("materialno")%>&nbsp;</td>
					  <td><%=rs2("itemname")%></td>
					  <td><%=rs2("qty")%></td>
					  <td><div id="standard3rd_unitcostdiv<%=i%>"><%=Round(rs2("unitcost"))%></div><input type="hidden" name="standard3rd_unitcost<%=i%>" value="<%=Round(rs2("unitcost"))%>"><input type="hidden" name="standard3rd_unitcostrmb<%=i%>" value="<%=Round(rs2("unitcostrmb"))%>"</td>
					</tr>
				<%
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
                </tr>-->
              </table></td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td><table id="standard3rd" width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
				  <td>Other Direct Cost</td>
                  <td>Selection</td>
                  <td>Charged %</td>
                  <td>Amount</td>
                </tr>
				<tr class="line02">
				  <td>Freight &amp; Insurance<br>运费&amp;保险费 </td>
				  <td>
				    <select name="freight" onchange="changefreight(this);">
					  <option value="CIP" <%If rs("freight")="CIP" Then %>selected<%End If %>>CIP</option>
					  <option value="FCA" <%If rs("freight")="FCA" Then %>selected<%End If %>>FCA</option>
					  <option value="CIF" <%If rs("freight")="CIF" Then %>selected<%End If %>>CIF</option>
					</select>
				  </td>
				  <td>
				    <div id="freightdiv">
					<%
					If rs("freight")="FCA" Then 
					%>
					0.0%
					<%
					ElseIf rs("freight")="CIF" Then 
					%>
					0.3%
					<%
					Else 
					%>
					0.5%
					<%
					End If 
					%>
					</div>
				  </td>
				  <td>&nbsp;</td>
				</tr>
                <tr class="line02"> 
                  <td>Installation by Philips<br>
                    飞利浦安装成本</td>
                  <td>
				    <select name="inst" onchange="onothercost()">
					  <option value="1" <%If rs("inst")="1" Then %>selected<%End If %>>YES</option>
					  <option value="0" <%If rs("inst")="0" Then %>selected<%End If %>>NO</option>
					</select>
				  </td>
                  <td><div id="instdiv"><%=rs("minst")%>%</div></td>
                  <td>&nbsp;</td>
                </tr>
                <tr class="line02"> 
                  <td>Application Training<br>应用培训成本</td>
                  <td>
				    <select name="apptraining" onchange="onothercost()">
					  <option value="1" <%If rs("apptraining")="1" Then %>selected<%End If %>>YES</option>
					  <option value="0" <%If rs("apptraining")="0" Then %>selected<%End If %>>NO</option>
					</select>
				  </td>
                  <td>&nbsp;</td>
                  <td>
				    <div id="apptrainingdiv"><%=rs("mapptraining")%></div>
					<input type="hidden" name="mapptraining" value="<%=rs("mapptraining")%>">
				  </td>
                </tr>
                <tr class="line02"> 
                  <td>Standard Warranty by Philips<br>
                    飞利浦标准保修费</td>
                  <td>
				    <select name="warr" onchange="onothercost()">
					  <option value="1" <%If rs("warr")="1" Then %>selected<%End If %>>YES</option>
					  <option value="0" <%If rs("warr")="0" Then %>selected<%End If %>>NO</option>
					</select>
				  </td>
                  <td><div id="warrdiv"><%=rs("mwarr")%>%</div></td>
                  <td>&nbsp;</td>
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
                  <td colspan="10">Philips Key Options
				    <input type="hidden" name="options1philipscount" value="<%=rs3count%>">
				  </td>
                </tr>
                <tr class="line01"> 
                  <td width="3%">Mutex</td>
                  <td width="3%">No.</td>
                  <td width="10%">Content</td>
                  <td width="10%">Article No.</td>
                  <td>Article Description</td>
                  <td width="5%">Qty</td>
                  <td>List Price</td>
                  <td>CTP</td>
                  <td>Target Price</td>
                  <td>Dis. Rate(请填0~1的数字)<input type="text" size="6" name="options1philipsbatchdiscount" onblur="batchdiscount(this, 'options1philips');"></td>
                </tr>
				<%
				i = 0
				While Not rs3.eof
					If IsNull(rs3("discount")) Or rs3("discount") = "" Then
						discount = 1
					Else
						discount = rs3("discount")
					End If 
					If IsNull(rs3("targetprice")) Or rs3("targetprice") = "" Then
						targetprice = rs3("listprice")
					Else
						targetprice = rs3("targetprice")
					End If 
				%>
					<tr class="line02">
					  <td><%=rs3("mutex")%>&nbsp;</td>
					  <td><%=rs3("sortno")%>&nbsp;</td>
					  <td><%=rs3("items")%>&nbsp;</td>
					  <td><%=rs3("materialno")%><input type="hidden" name="options1philips_pdid<%=i%>" value="<%=rs3("pdid")%>"></td>
					  <td><%=rs3("description")%></td>
					  <td><%=rs3("qty")%></td>
					  <td><div id="options1philips_listpricediv<%=i%>"><%=Round(rs3("listprice"))%></div><input type="hidden" name="options1philips_listprice<%=i%>" value="<%=Round(rs3("listprice"))%>"></td>
					  <td><%=rs3("wrp")%></td>
					  <td><div id="options1philips_targetpricediv<%=i%>"><%=Round(targetprice)%></div></td>
					  <td><input type="text" size="6" name="options1philips_discount<%=i%>" value="<%=discount%>" onblur="validPlusNumeric(this, 'options1philips', '<%=i%>', '<%=Round(rs3("listprice"))%>');"></td>
					</tr>
				<%
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
                  <td>&nbsp;</td>
				</tr>-->
              </table></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td><table id="dynamictable" width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td colspan="4">Dynamic Options Discount
				    <input type="hidden" name="dynamiccount" value="<%=dynamiccount%>">
				  </td>
                </tr>
                <tr class="line01"> 
                  <td width="3%">&nbsp;</td>
                  <td>Content</td>
                  <td>Article No.</td>
                  <td>Discount Rate</td>
                </tr>
				<%
				i = 0
				While Not rsdynamic.eof
				%>
					<tr class="line02">
					  <td><input type='checkbox' name='dynamic_medication' onclick='selectBox(this);'></td>
					  <td>
					    <%=rsdynamic("items")%>
					    <input type='hidden' name='dynamic_items<%=i%>' value='<%=rsdynamic("items")%>'>
					  </td>
					  <td>
					    <%=rsdynamic("options")%>
					    <input type='hidden' name='dynamic_options<%=i%>' value='<%=rsdynamic("options")%>'>
					  </td>
					  <td>
					    <%=rsdynamic("discount")%>
					    <input type='hidden' name='dynamic_discount<%=i%>' value='<%=rsdynamic("discount")%>'>
					  </td>
					</tr>
				<%
					i = i + 1
					rsdynamic.movenext
				Wend 
				%>
              </table></td>
          </tr>
          <tr> 
            <td align="right">
			  <input type="button" name="btndynamic" value="Add Dynamic Discount" onclick="toDynamic('<%=pid%>');">&nbsp;
			  <input type="button" name="btndelete" value=" Delete " onclick="deleteBox();">&nbsp;
			</td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td><table id="options3rd" width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td colspan="5">Key 3rd Party Options
				    <input type="hidden" name="options3rdcount" value="<%=rs5count%>">
				  </td>
                </tr>
                <tr class="line01"> 
				  <td width="10%">Product Code</td>
                  <td>Product Name</td>
                  <td width="5%">Qty</td>
                  <td>Unit Cost</td>
                  <td>Total Cost</td>
                </tr>
				<%
				i = 0
				While Not rs5.eof
				%>
					<tr class="line02">
					  <td><%=rs5("materialno")%></td>
					  <td><%=rs5("itemname")%></td>
					  <td><%=rs5("qty")%></td>
					  <td><div id="options3rd_unitcostdiv<%=i%>"><%=Round(rs5("unitcost"))%></div><input type="hidden" name="options3rd_unitcost<%=i%>" value="<%=Round(rs5("unitcost"))%>"><input type="hidden" name="options3rd_unitcostrmb<%=i%>" value="<%=Round(rs5("unitcostrmb"))%>"></td>
					  <td><div id="options3rd_totalunitcostdiv<%=i%>"><%=Round(rs5("unitcost")) * rs5("qty")%></div></td>
					</tr>
				<%
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
                </tr>-->
              </table></td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td><div align="right"> 
		  <input type="button" name="btnsubmit" value="Save" onclick="checkfields();">&nbsp;&nbsp;&nbsp;
          <!--<input type="button" name="rtn" value="Return" onclick="javascript:history.go(-1)">-->
        </div></td>
    </tr>
  </table>
  <!--#include file="../footer.asp"-->
  </form>
</div>
</body>
<script >


</script>
</html>


