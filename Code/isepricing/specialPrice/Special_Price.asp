<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/commons.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../include/Utils.asp"-->
<%
	Response.Expires = -1 
	Response.ExpiresAbsolute = Now() - 1 
	Response.cachecontrol = "no-cache"

%>
<%
	Dim isclose
	Dim qid,quotationno,businessmodel,productmodel,paymentterm,specpaymentterm,currencycode,tenderno,finalusername
	Dim oitprice,sdprice,esoitprice,essdprice,specdiscount,bidder,contractParty,closeingdate,applicationdate
	Dim keyprofile,projectbrief,mainCompetitor,CompetitorPrice,bidPrice
	isclose=false
	sid=request("sid")

	'删除文件
	delfile=request("delfile")
	If Not IsNull(delfile) And delfile="1" Then
		conn.execute("delete from special_files where id="&request("fid"))
	End If 

	If Not IsNull(sid) And sid<>"" Then
		isclose=true
		sql="select * from special_price where id="&sid
		Set rs=conn.execute(sql)
		qid=rs("quotationid")
		quotationno=rs("quotationno")
		businessmodel=rs("businessmodel")
		productmodel=rs("productmodel")
		paymentterm=rs("paymentterm")
		specpaymentterm=rs("spec_paymentterm")
		currencycode=rs("currencycode")
		tenderno=rs("tenderno")
		finalusername=rs("username")
		oitprice=rs("targetoitprice")
		sdprice=rs("nettargetprice")
		esoitprice=rs("estimated_oitprice")
		essdprice=rs("estimated_netoitprice")
		specdiscount=rs("specialdiscount")
		bidder=rs("bidder")
		contractParty=rs("contract_Party")
		closeingdate=rs("tender_closedate")
		applicationdate=rs("application_date")
		keyprofile=rs("keyaccountprofile")
		projectbrief=rs("projectbrief")
		mainCompetitor=rs("Competitor")
		CompetitorPrice=rs("CompetitorPrice")
		bidPrice=rs("tenderprice")

		'上传文件
		sql="select * from special_files where specialid="&sid
		Set rsfiles=conn.execute(sql)


		
	End If 
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>IS E-pricing system</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<meta HTTP-EQUIV="pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Cache-Control" CONTENT="no-cache, must-revalidate">
<meta HTTP-EQUIV="expires" CONTENT="0">

<LINK href="../css/css.css" type=text/css rel=stylesheet>
<script type="text/javascript" src="../js/ut.js"></script>
<script type="text/javascript" src="../js/jquery-1.2.6.js"></script>
<script type="text/javascript" src="../js/My97DatePicker/WdatePicker.js" ></script>

<script>
	function showQuotation()
	{
		window.open('../selects/quotationSelect.asp','','width=1024px,height=768px,resizable=yes');
	}
	function toReport(sid,qid)
	{
		window.open("Quotation_Report.asp?sid="+sid+"&qid="+qid,'','width=1024px,height=768px,resizable=yes');
	}
	function saveSpecial(){
		var f=document.forms[0];
		if(!checkForm(f)){
			return false;
		}
		f.submit();
	}
	
	function checkForm(f)
	{
		var estimatedOitPrice=$("#estimatedOitPrice").val();
		var tenderClosingDate=$("#tenderClosingDate").val();
		var KeyAccountProfile=$("#KeyAccountProfile").val();    
		var ProjectBrief=$("#ProjectBrief").val(); 
		var Competitor=$("#Competitor").val(); 
		var CompetitorPrice=$("#CompetitorPrice").val(); 
		var TenderPrice=$("#TenderPrice").val(); 
		var qid=$("#qid").val();
		if(qid==null || qid=='')
		{
			alert('请选择 Quotation No!');
			return false;
		}
		if(estimatedOitPrice==null || estimatedOitPrice=='')
		{
			alert('请填写预估进单价!');
			return false;
		}
		if(tenderClosingDate==null || tenderClosingDate=='')
		{
			alert('请填写投标截止日期!');
			return false;
		}
		if(KeyAccountProfile==null || KeyAccountProfile=='')
		{
			alert('请填写客户概况!');
			return false;
		}
		if(ProjectBrief==null || ProjectBrief=='')
		{
			alert('请填写项目简介!');
			return false;
		}
		if(Competitor==null || Competitor=='')
		{
			alert('请填写主要竞争对手!');
			return false;
		}
		if(CompetitorPrice==null || CompetitorPrice=='')
		{
			alert('请填写竞争对手价格!');
			return false;
		}
		if(TenderPrice==null || TenderPrice=='')
		{
			alert('请填写预估投标/中标价!');
			return false;
		}  
		if($("#validProductModel").val()==1 &&  $("#productModel").val()==2)
		{
			alert('必须选择Single Modality！');
			return false;
		}
		if($("#validProductModel").val()>1 &&  $("#productModel").val()==1)
		{
			alert('必须选择Multi Modality(Bundle deal)！');
			return false;
		}
		return true;
	}
	function goBack()
	{
		if(!confirm("您确定不保存修改?"))
		{
			return;
		}
		location.href="specialList.asp";
	}
	function doSelect(quotationid,quotationno,tenderno,cuurencycode,oitprice,standardprice,username,businessmodel,paymentterm,spec_paymentterm,productmodel)
	{
		$("#qid").val(quotationid);
		$("#quotationNo").val(quotationno);
		$("#tenderno").val(tenderno);
		$("#currencycode").val(cuurencycode);
		$("#oitPrice").val(oitprice);
		$("#standardprice").val(standardprice);
		$("#finalusername").val(username);
		$("#validProductModel").val(productmodel);
		$("#paymentterm").val(paymentterm);
		$("#spec_paymentterm").val(spec_paymentterm);
		$("#businessmodel").val(businessmodel);
		$("#reportDiv").html("<a href='#' onclick=\"toReport('"+$("#sid").val()+"',"+quotationid+");return false;\">Supporting Information </a>");
		setSelectVals(paymentterm,businessmodel);
		calcAll();
	}
	function calcAll()
	{
		$("#estimatedStandardprice").val('');
		$("#SpecialDiscount").val('');
		var oitprice,stprice,esOitprice,esStprice,specialDiscount;
		var chajia;
		esOitprice=$("#estimatedOitPrice").val();
		oitprice=$("#oitPrice").val();
		stprice=$("#standardprice").val();
		if(esOitprice==null || esOitprice==""){
			return;
		}
		if(!isPlusInt(esOitprice)){
			alert('请输入整数！');
			$("#estimatedOitPrice").val('');
			$("#estimatedOitPrice").focus();
			return;
		}
		if(oitprice==null || oitprice==""){
			return;
		}
		if(stprice==null || stprice==""){
			return;
		}
		chajia=oitprice-stprice;
		esStprice=esOitprice-chajia;
		specialDiscount=(esStprice-stprice)*100*10/stprice;
		specialDiscount=formatNumber(specialDiscount,'123456789.00');
		esStprice=parseInt(esStprice);
		specialDiscount=Math.round(specialDiscount)/10;
		
		$("#estimatedStandardprice").val(esStprice);
		$("#SpecialDiscount").val(specialDiscount);
	}
	function setSelectVals(paymentterm,businessmodel)
	{
		$("#show_paymentterm").val(paymentterm);
		$("#show_businessModel").val(businessmodel);
		$("#show_paymentterm").attr({"disabled":"disabled"});
		$("#show_businessModel").attr({"disabled":"disabled"});
	}
	var filecnt=1;
	function addUploads()
	{
		filecnt=filecnt+1;
		var l=$("#f_table tr").size()-1;
		<% if isclose then%>
			l=l-1;
		<% end if %>
		var adds="<tr><td><input type='file' name='upFile"+filecnt+"'></td></tr>";
		$("#f_table tr:eq("+l+")").after(adds);
	}
	function delUpFile(id)
	{
		if(!confirm("您确实要删除该文件吗?"))
		{
			return false;
		}
		$.post("AdditionalInfoDel.asp",{fid:id},function(data){});
		alert("删除成功");
		$("#"+id).remove();
		//location.href="Special_Price.asp?fid="+id+"&delfile=1&sid="+$("#sid").val()+"&d=<%=now%>";
	}
	function openAdditional(sid)
	{
		window.open('AdditionInfo.asp?sid='+sid,'','width=400,height=300');
	}
	function refreshWindow(){
		location.href="Special_Price.asp?d=<%=now%>&sid="+$("#sid").val();
	}
	function addFiles2ol(id,name,path)
	{
		var strHtml="<li id='"+id+"'>  <a href='../include/downloadFile.asp?path="+path+"&fname="+name+"' target='_top' >"+name+"</a>&nbsp;&nbsp;<a href='#' onclick='delUpFile("+id+");return false;'>Delete</a>";
		$("#ol_files").html($("#ol_files").html()+strHtml);
	}
</script>
</head>

<body bgcolor="#ffffff" leftmargin="0" topmargin="0">
<form action="specialSave.asp"  method="post" enctype="multipart/form-data">
<input type="hidden" name="qid" id="qid" value="<%=qid%>">
<input type="hidden" name="sid" id="sid" value="<%=sid%>">
<input type="hidden" name="validProductModel" id="validProductModel">
<div align="center">
  <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td><table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td class="titleorange"><div align="center">Philips Healthcare Greater 
                China Special Price Application </div></td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td><table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                    <td width="20%"> 
                      <div align="left">Quotation No: 报价文件号：<font color="#FF0000">*</font><br>
                    </div></td>
                    <td width="30%"> <div align="left"> 
                        <input name="quotationNo" type="text"  id="quotationNo"
					  onclick="showQuotation();"
					  value="<%=quotationno%>" style="width:100%" readonly
					  <% If Not isclose then%>
					  <% End If %>>
                    </div></td>
                    <td width="20%">
<div align="left">Quotation Details: 报价详情：</div></td>
                    <td width="30%">
<div align="left" id="reportDiv"> 
				    <% If  isclose then%>
                        <a href='#' onclick="toReport('<%=sid%>','<%=qid%>');return false;">Supporting 
                        Information </a> 
					  <% End If %>
				  &nbsp;</div></td>
                </tr>
                <tr class="line01"> 
                  <td> <div align="left">Business Model: 业务模式：</div></td>
                  <td> <div align="left">
					<input type="hidden" name="businessmodel" id="businessmodel" >
                      <select name="show_businessModel" id="show_businessModel">
						<%
							for i=1 to ubound (BUSINESS_MODEL)
						%>
						 <option value="<%=BUSINESS_MODEL(i,0)%>"><%=BUSINESS_MODEL(i,1)%></option>
						<%
							
							next
						%>
                      </select>
                    </div></td>
                  <td> <div align="left">Currency: 货币单位：<br>
                    </div></td>
                  <td> <div align="left"> 
                     <input type="text" name="currencycode" id="currencycode" readonly value="<%=currencycode%>">
                    </div></td>
                </tr>
			 <tr class="line01"> 
                  <td height="25"> <div align="left">Payment Term: 付款方式：<br>
                    </div></td>
                  <td> <div align="left">  <input type="hidden" name="paymentterm" id="paymentterm">
                      <select name="show_paymentterm" id="show_paymentterm">
						<option value=""></option>
                       <%
							for i=1 to 6
						%>
						 <option value='<%=PAYMENT_TERM(i,0)%>'><%=PAYMENT_TERM(i,1)%></option>
						<%
							next
						%>
                      </select>
                    </div></td>
                  <td><div align="left">Special Payment Term: 特殊付款方式：</div></td>
                  <td> <div align="left"> 
                    <input type="text" name="spec_paymentterm" id="spec_paymentterm" readonly value="<%=specpaymentterm%>">
                    </div></td>
                </tr>
                <tr class="line01"> 
                  <td height="25"> <div align="left">Single/Multi Modality:<br>
                        单一/多个产品型号：<br>
                    </div></td>
                  <td> <div align="left"> 
                      <select name="productModel" id="productModel">
						 <%
							for i=1 to 2
						%>
						 <option value='<%=SPECIAL_PRODUCTMODEL(i,0)%>'><%=SPECIAL_PRODUCTMODEL(i,1)%></option>
						<%
							next
						%>
                      </select>
                    </div></td>
                  <td bgcolor="lightgreen" title="此处不需填写，自动从Quotation Maker中带出&#13等于本单Quotation 的目标价(含净目标价格+第三方产品+其它预留费用+额外保修费用)"><div align="left">Target 
                        OIT Price: 目标进单价：</div></td>
                  <td bgcolor="lightgreen"> <div align="left"> 
                      <input name="oitPrice" id="oitPrice" type="text"  readonly value="<%=oitprice%>" >
                    </div></td>
                </tr>
                <tr class="line01"> 
                  <td height="25"><div align="left">Tender Document No.:<br>
                        招标文件号：</div></td>
                  <td><div align="left"> 
                      <input name="tenderno"  id="tenderno" type="text" readonly  value="<%=tenderno%>">
                    </div></td>
                  <td  bgcolor="lightgreen"  title="此处不需填写，自动从Quotation带出&#13等于Philips设备的目标价：Quotation Part I : Philips Product Net Target Price&#13(含净设备价格+标准安装+标准培训+标准保修+Standard 第三方)"><div align="left">Net 
                        Target Price: 净目标价格：<br>
                    </div></td>
                  <td  bgcolor="lightgreen"><div align="left"> 
                      <input name="standardprice" id="standardprice" type="text" readonly  value="<%=sdprice%>" >
                    </div></td>
                </tr>
                <tr class="line01"> 
                  <td height="25"><div align="left">Final User (Hospital) Name:<br>
                        最终用户名称：</div></td>
                  <td><div align="left"> 
                      <input name="finalusername" id="finalusername" type="text" readonly style="width:100%"  value="<%=finalusername%>">
                    </div></td>
                  <td bgcolor="yellow" title="请填写 &#13等于本单预估的进单价(含净目标价+第三方产品+其他预留费用+额外保修费用)"><div align="left">Estimated 
                        OIT Price: 预估的进单价：<font color="#FF0000">*</font><br>
                    </div></td>
                  <td bgcolor="yellow"><div align="left"> 
                      <input name="estimatedOitPrice"  id="estimatedOitPrice" type="text" onblur="calcAll();"  value="<%=esoitprice%>" >
                    </div></td>
                </tr>
                <tr class="line01"> 
                  <td height="25"><div align="left">Bidder: 投标人：</div></td>
                  <td><div align="left"> 
                      <input name="bidder" id="bidder" type="text" style="width:100%"  value="<%=bidder%>">
                    </div></td>
                  <td title="不需填写，自动计算&#13等于Philips设备的预估进单价格(预估进单价—第三方产品—其它预留费用—额外保修费用)"><div align="left">Estimated Net OIT Price:<br>
                        预估的净进单价：<br>
                    </div></td>
                  <td><div align="left"> 
                      <input name="estimatedStandardprice"  id="estimatedStandardprice" type="text" readonly  value="<%=essdprice%>">
                    </div></td>
                </tr>
                <tr class="line01"> 
                  <td><div align="left">Contracting Party: 合同方：</div></td>
                  <td><div align="left"> 
                      <input name="ContractParty" id="ContractParty" type="text" style="width:100%"  value="<%=contractparty%>">
                    </div></td>
                  <td title="不需填写，自动计算&#13=(预估的净进单价-净目标价格)/(净目标价格)"><div align="left">Special Discount Requested:<br>
                        特价折扣请求：<br>
                    </div></td>
                  <td><div align="left"> 
                      <input name="SpecialDiscount"  id="SpecialDiscount" type="text" readonly  value="<%=specdiscount%>" style="color:red;"><font color="red">%</font>
                    </div></td>
                </tr>
                <tr class="line01"> 
                  <td> <div align="left">Tender Closing Date:<font color="#FF0000">*</font><br>
                        投标截止日期：</div></td>
                  <td> <div align="left"> 
                      <input name="tenderClosingDate"  id="tenderClosingDate" type="text" size="10" readonly onClick="WdatePicker()"   value="<%=closeingdate%>">
                    </div></td>
                  <td> <div align="left">&nbsp;Application Date: 申请日期：</div></td>
                  <td> <div align="left"> &nbsp;
				  <%=displaytime2(applicationdate)%>
                <!--      <input name="ApplicationDate"  id="ApplicationDate" type="text"  size="10"  readonly onClick="WdatePicker()">  -->
                    </div></td>
                </tr>
              </table></td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td><table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td><table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td><div align="left">Key Account Profile: 客户概况：<font color="#FF0000">*</font></div></td>
                </tr>
                <tr class="line02"> 
                  <td width="25%" height="25"> <div align="left"> 
                        <textarea name="KeyAccountProfile" id="KeyAccountProfile" style="width:70%" rows="5"></textarea>
                      <br>
                    </div></td>
                </tr>
                <tr class="line01"> 
                  <td><div align="left">Project Brief: 项目简介：<font color="#FF0000">*</font></div></td>
                </tr>
                <tr class="line02"> 
                  <td><div align="left"> 
                        <textarea name="ProjectBrief" id="ProjectBrief" style="width:70%" rows="5"></textarea>
                          <br>
                    </div></td>
                </tr>
                <tr class="line01"> 
                  <td><div align="left">Main Competitor: 主要竞争对手：<font color="#FF0000">*</font></div></td>
                </tr>
                <tr class="line02"> 
                  <td><div align="left"> 
                        <textarea name="Competitor" id="Competitor" style="width:70%" rows="5"></textarea>
                      <br>
                    </div></td>
                </tr>
                <tr class="line01"> 
                  <td><div align="left">Competitor Price w/o. VAT: 竞争对手价格：<font color="#FF0000">*</font></div></td>
                </tr>
                <tr class="line02"> 
                  <td><div align="left"> 
                        <textarea name="CompetitorPrice" id="CompetitorPrice" style="width:70%" rows="5"></textarea>
                      <br>
                    </div></td>
                </tr>
                <tr class="line01"> 
                  <td><div align="left">Estimated Tender/Win Bid Price: 预估投标/中标价：<font color="#FF0000">*</font></div></td>
                </tr>
                <tr class="line02"> 
                  <td><div align="left"> 
                        <textarea name="TenderPrice" id="TenderPrice" style="width:70%" rows="5"></textarea>
                      <br>
                    </div></td>
                </tr>
				<tr class="line01"> 
                  <td><div align="left">文件上传：(<font color="red">上传文件最大为3M</font>) 
                        <input type="button" value="+" onclick="addUploads();">
			
				  </div></td>
                </tr>
                <tr class="line02"> 
                  <td><div align="left" id="fileZone"> 
				 <font color="red">Pricing Letter的上传只针对非直销模式</font><br>
				 <ol id="ol_files" >
				    <% 
					If isclose then
					While Not rsfiles.eof 
						response.write("<li id='"& rsfiles("id")&"'><a href='../include/downloadFile.asp?path="&rsfiles("filepath")&"&fname="&rsfiles("filename")&"' target='_top' >"&rsfiles("filename")&"</a>&nbsp;&nbsp;")
						response.write("<a href='#' onclick='delUpFile("&rsfiles("id") &");return false;'>Delete</a>")
						'response.write("<br>")
						rsfiles.movenext
					Wend
				  End if
				  %>
				  </ol>
				  <table id="f_table"><tr><td>
				
				  <input type="file" name="upFile1"> 
			
				  </td></tr>
				  
				  <% If isclose then%>
					<tr><td>
					<br>
					上传单个文件：<input type="button" value="上传文件" onclick="openAdditional('<%=sid%>');">
					</td></tr>
				  <% End If %>
				  </table>
                    </div></td>
                </tr>
                <tr class="line02"> 
                  <td><p>&nbsp;</p>
                    <p align="right">
                      <input type="button" name="Submit" value="Save" onclick="saveSpecial();">
					  <input type="button" name="Submit3" value="Return" onclick="goBack();">
                    </p></td>
                </tr>
              </table></td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
    </table>
     <!--#include file="../footer.asp"-->
</div>
<script>
	calcAll();
	<% if  isclose then %>
			$("#show_paymentterm").val('<%=paymentterm %>');
			$("#show_businessModel").val('<%=businessmodel %>');
			$("#productModel").val('<%=productmodel %>');
			$("#KeyAccountProfile").val("<%=keyprofile %>");
			$("#Competitor").val("<%=mainCompetitor %>");
			$("#CompetitorPrice").val("<%=CompetitorPrice %>");
			$("#TenderPrice").val("<%=bidPrice %>");
			$("#ProjectBrief").val("<%=projectbrief %>");

			$("#show_paymentterm").attr("disabled","true");
			$("#show_businessModel").attr("disabled","true");
			$("#productModel").attr("disabled","true");
	<% end if %>
</script>
</form>
</body>
</html>
<%
	If isclose Then
		rs.close
		Set rs=Nothing 
	End If 
	'关闭数据库连接
	CloseDatabase
%>
