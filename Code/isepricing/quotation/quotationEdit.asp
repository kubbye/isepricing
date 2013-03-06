<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/commons.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="quotationVar.asp"-->
<!--#include file="quotationUtils.asp"-->
<%
	dim rs
	dim strSql,isclose
	dim targetprice,targetpricewew,sctargetprice
	Dim isAwakeDmtoCheck
	targetprice="0"
	targetpricewew="0"
	sctargetprice="0"
	isAwakeDmtoCheck="0"
	if quotationid<>"" then
		isclose=true
		strSql="select * from quotation a where qid="&quotationid
		set rs=server.createObject("adodb.recordset")
		rs.open strsql,conn,1,1
		quotationno=rs("quotationno")
		tenderno=rs("tenderno")
		hospname=rs("username")
		nonHospName=rs("nonusername")
		businessModel=rs("businessModel")
		paymentTerm=rs("paymentTerm")
		sepcParment=rs("SEPC_PARMENTTERM")
		dealerName=rs("dealerName")
		currencycode=rs("currencycode")
		curRate=rs("rate")
		targetprice=rs("targetprice")
		sctargetprice=rs("sctargetprice")
		targetpricewew=rs("targetpricewew")
		conn.execute("update quotation set iseditfinished=0 where qid="&quotationid)
		'查询是否需要提醒isAwakeDmtoCheck
		Set rs_isAwakeDmtoCheck=conn.execute("select * from quotation a,special_price b where a.quotationno=b.quotationno and  a.status=4 and (b.status=-2  or ispending=1 or ispending=9) and a.qid="&quotationid)
		If Not rs_isAwakeDmtoCheck.bof And Not rs_isAwakeDmtoCheck.eof Then
			isAwakeDmtoCheck="1"
		End If 
		set rsProd=server.createObject("adodb.recordset")
		rsProd.open "select * from quotation_detail where qid="&quotationid,conn,1,1
	end if
	
	if quotationid=""  THEN '生成报价文件号
		application.Lock()
		quotationno=session("userzone")&getdate2()
		userzone=session("userzone")
		if isnull(application(userzone&"quotationdate")) or isempty(application(userzone&"quotationdate")) or application(userzone&"quotationdate")<>getdate2() then
			application(userzone&"quotationdate")=getdate2()
			'取出当前数据库中最大的seq
			Set rsSeq=conn.execute("select substring(MAX(QUOTATIONNO),11,5) as QUOTATIONNO from quotation where quotationno like '"&quotationno&"%'")
			If rsSeq.bof And rsSeq.eof Then
				application(userzone&"quotationSeq")=1
			Else
				If IsNull(rsSeq("quotationno")) Then
					seq=0
				Else
					seq=CInt(rsSeq("quotationno"))
				End if
				application(userzone&"quotationSeq")=seq+1
			End if
		else
			application(userzone&"quotationSeq")=application(userzone&"quotationSeq")+1
		end if
		
		seq=application(userzone&"quotationSeq")
		l=len(seq)
		for i=1 to 5-l
			seq="0"&seq
		next
		
		quotationno=quotationno&seq
		application.UnLock()
	end if
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title></title>
<LINK href="../css/css.css" type=text/css rel=stylesheet>
<script type="text/javascript" src="../js/ut.js"></script>
<script type="text/javascript" src="../js/jquery-1.2.6.js"></script>
<script type="text/javascript">
	function saveQuotation()
	{
		var f=document.forms("quotationform");
		if($("#quotationNO").val()==null || $("#quotationNO").val()=='')
		{
			$("#quotationNO").val('');
			alert("Quotation No不能为空!");
			$("#quotationNO").focus();
			return false;
		}
		if(($("#hospName").val()==null || $("#hospName").val()=='') &&($("#nonHospName").val()==null || $("#nonHospName").val()=='') )
		{
			alert("请填写用户名称!");
			return false;
		}
		if($("#businessModel").val()==null || $("#businessModel").val()=='')
		{
			alert("请选择业务模式！");
			$("#businessModel").focus();
			return false;
		}
		if(($("#paymentTerm").val()==null || $("#paymentTerm").val()=='') && ($("#sepcParment").val()==null || $("#sepcParment").val()==''))
		{
			alert("请选择付款方式或填写特殊付款方式！");
			//$("#paymentTerm").focus();
			return false;
		}
		if($("#hospName").val()=="" && $("#nonHospName").val()!=null && $("#nonHospName").val()!=""){
			alert("如果最终用户名不被commercial 加入Final user list,将不能进单.");
		}
		setRate($("#currencycode").val());
		f.action='quotationAdd.asp?currencycode='+$("#currencycode").val();
		f.submit();
		/*
		$.post('quotationAdd.asp',
		{qid:$("input:hidden[name='qid']").val(),quotationNO:$("#quotationNO").val(),tenderno:$("#tenderno").val(),hospName:$("#hospName").val(),businessModel:$("#businessModel").val()
		,paymentTerm:$("#paymentTerm").val(),nonHospName:$("#nonHospName").val(),dealerName:$("#dealerName").val(),currencycode:$("#currencycode").val(),curRate:$("#curRate").val()},function(data)
		{
			if( data==null || data==''){
				alert('保存Quotation信息失败');
			}else{
				$("input:hidden[name='qid']").val(data);
				alert('保存成功');
			}
		});
		*/
		//return true;
	}
	function saveAndP()
	{
		if(saveQuotation()){
			openZone(1);
		}
	}
	function saveAndExit(){
		if(saveQuotation()){
			location.href="quotationList.asp";
		}
	}
	function addProductRow()
	{
	
	}
	//删除产品
	function delProductRow()
	{
		if(!confirm('确定删除该产品？')){
			return false;
		}
		var qid,qdid
		qid=$("#qid").val();
			
		qdid='0';
		if($("input:checkbox[name='qdids'][checked]").size()!=0){
			qdid='';
			$("input:checkbox[name='qdids'][checked]").each(function(index)
			{
				if(index==0){
					qdid=$(this).val();
				}else{
					qdid=qdid+","+$(this).val();
				}
			}
			);
		}
		if(qdid=='0'){
			alert('pls select a product to delete!');
			return;
		}
		$("input:checkbox[name='qdids'][checked]").each(function(id){
			$(this).parent().parent().remove();
		});
		/*
		$.post("productAdd.asp",{ot:2,qid:qid,delqdid:qdid,curRate:$("#curRate").val()},function(data){
			location.href="quotationEdit.asp?qid="+$("#qid").val();
			//resetProductSeq('productTable',4);
		});
		*/
		location.href="productAdd.asp?ot=2&qid="+qid+"&delqdid="+qdid+"&curRate="+$("#curRate").val();
		//getPartPrice('<%=quotationid%>');
	}
	//对产品表格重新排序
	function resetProductSeq(tname,len){
		var l=$("#"+tname+" tr").size();
		$("#"+tname+" tr").each(function(index){
				if(index>0 && index<l-len){
					var ri= $(this).parent().find("tr").index($(this));   
					$(this).find("td:eq(1)").text(ri);
				}
		});
	}
	//添加产品
	function selectProducts(){
		$("select[name='bu']").val('');
		clearOptions('modality');
		clearOptions('product');
		$("input:text[name='qotedPrice']").val('');
		$("tr[name='productsAdd']").show();
	}
	
	//选择产品
	function selectConfig(qid,pid,qdid){
		if($("input:hidden[name='priceHasChange']").size()!=0){
			
		}
		if($("input:hidden[name='prdEscape']").size()!=0){
			alert("请删除已经不存在的产品");
			return;
		}
		window.open('configAdd.asp?qid='+qid+'&pid='+pid+'&qdid='+qdid+'&curRate='+$("#currencycode").val(),'Configuration','width=1024px,height=768px,resizable=yes');
	}
	//保存添加的产品
	function saveProduct(){
		var qid
		var pid
		qid=$("#qid").val();
		pid=$("select[name='product']").val();
		if($("select[name='product']").val()==''){
			alert('请选择产品');
			return false;
		}
		/*
		if($("input:text[name='qotedPrice']").val()==''){
			alert('请填写价格');
			return false;
		}else{
			if(isNaN($("input:text[name='qotedPrice']").val())){
				alert('请填写数字！');
				return false;
			}
		}
		*/
		$.post("productAdd.asp",{ot:1,qid:qid,pid:pid,qotedPrice:$("input:hidden[name='qotedPrice']").val()},function(data){
			var res=data;
			if("success"!=data){
				alert("操作成功，请单击产品名称配置产品！");
				res="success";
			}else{
				return;
			}
			if(res=='success'){
					var l=$("#productTable tr").size();
				$("#productTable").find("tr:eq("+(l-9)+")").after("<tr class='line02'><td><input type='checkbox' name='qdids' value='"+data+"'></td><td>"+(l-8)+"</td><td>"+$("select[name='bu']").find("option:selected").text()+"</td><td><a href='#'  onclick='selectConfig("+$("#qid").val()+","+$("select[name='product']").val()+","+data+");'>"+$("select[name='product']").find("option:selected").text()+"</a></td></tr>");
			}else{
				alert('添加产品错误，请联系系统管理员！');
			}
		});
		$("tr[name='productsAdd']").hide();
	}
	//控制页面区域的现实与否
	function openZone(id)
	{
		if(id==1)
		{
			$("tr[name='products']").show();
		}else if(id=2)
		{
			//$("tr[name='configs']").show();
		}
	}
	//页面初始化后的显示
	function hiddenInit()
	{
		$("tr[name='products']").hide();
		<% if quotationid<>"" then %>
		$("tr[name='products']").show();
		<% end if%>
	}
	//选择modality
	 function selectModality(bu){
		clearOptions('modality');
		clearOptions('product');
		 if(bu==null || bu==''){
			return false;
		}
		$.post('../selects/productSelect.asp',{bu:bu},function(data)
		{
			$(data).appendTo("select[name='modality']");
		});
	 }
	 //选择产品
	 function selectProduct(modality){
		clearOptions('product');
		if(modality==null || modality==''){
			return false;
		}
		var pids;
		pids='0';
		if($("input:checkbox[name='pids']").size()!=0){
			$("input:checkbox[name='pids']").each(function(index)
			{
				if(index==0){
					pids=$(this).val();
				}else{
					pids=pids+","+$(this).val();
				}
			}
			);
		}
		//return;
		$.post('../selects/productSelect.asp',{modality:modality,pids:pids},function(data)
		{
			$(data).appendTo("select[name='product']");
		});
	 }
	 function selectProductByBu(bu)
	 {
		clearOptions('product');
		 if(bu==null || bu==''){
			return false;
		}
		$.post('../selects/productSelect.asp',{bu:bu},function(data)
		{
			$(data).appendTo("select[name='product']");
		});
	 }
	 //清空给定select的options，仅保留下“请选择”的选择
	 function clearOptions(on){
	 	var obj=document.all(on);
		$("select[name='"+on+"']").empty();
		$("<option value=''>请选择</option>").appendTo("select[name='"+on+"']");
	 }
	 function showp(pid){
	 	//alert($("#configs").html());
	 	$("#configs").after("<tr id''>"+$("#configs").html()+"</tr>");
	 }
	function plusPrice(p1,p2,p3){
		var p11=$("#p1").text();
		var p22=$("#p2").text();
		if(p11=='' || p11==null || isNaN(parseInt($("#p1").text()))) {
			p11=0;
		}
		if(p22==''|| p22==null || isNaN(parseInt($("#p2").text()))) {
			p22=0;
		}
		p11=parseFloat(p11)+parseFloat(p1);
		p22=parseFloat(p22)+parseFloat(p2);
		//p33=parseFloat(p33)+parseFloat(p3);
		p11=formatNumber(p11,'123456789.##');
		p22=formatNumber(p22,'123456789.##');
		//p33=formatNumber(p33,'123456789.##');

		$("#p1").text(p11);
		$("#p2").text(p22);
		//$("#p3").text(p33);
		getPartPrice('<%=quotationid%>');
	}
	function setRate(val){
		val=val.substring(val.indexOf("_")+1);
		$("#curRate").val(val);
	}
	function setPayTerm(){
		var bm;
		clearOptions('paymentTerm');
		bm=$("#businessModel").val();
		if(bm==1){
			<%
				for i=1 to 2
			%>
	
			  $("<option value='<%=PAYMENT_TERM(i,0)%>'><%=PAYMENT_TERM(i,1)%></option>").appendTo("select[name='paymentTerm']");
			<%
				next
			%>
		}else if(bm==3){
				<%
				for i=1 to 6
			%>
			  $("<option value='<%=PAYMENT_TERM(i,0)%>'><%=PAYMENT_TERM(i,1)%></option>").appendTo("select[name='paymentTerm']");
			<%
				next
			%>
		}else if(bm==2){
				<%
				for i=1 to 6
			%>
	
			  $("<option value='<%=PAYMENT_TERM(i,0)%>'><%=PAYMENT_TERM(i,1)%></option>").appendTo("select[name='paymentTerm']");
			<%
				next
			%>
		}
	}
	function itemAlert(){
		var msg;
		msg=" Business Partner 标准付款方式为100% TT /  LC ；其他皆为非标准付款方式，请按照SOP-F&A-001提前申请特批。";
		var bm=$("#businessModel").val();
		var items=$("#paymentTerm").val();
		if(bm==2 && (items!=1 && items!=2) )
		{
			alert(msg);
		}
	}
	function getPartPrice(qid){
		$.post('queryPartPrice.asp',{qid:qid},function(data)
		{
			var arr=new Array();
			arr=data.split(',');
			$("#part1").text(arr[0]);
			$("#part2").text(arr[1]);
			$("#part3").text(arr[2]);
			$("#part4").text(arr[3]);
			$("#d_adjustprice").text(arr[4]);
		});
	}
	function awokeSpecPay(){
		var msg;
		msg="特殊付款方式必须得到信控部门的批准,否则无法OIT. 具体申请流程参考OIT流程!";
		if($("#sepcParment").val()!=null && $("#sepcParment").val()!=''){
			alert(msg);
		}
	}
	function goBack(){
		location.href="quotationList.asp?d=<%=now%>";
	}

	//如果选择的时候提醒
	document.onselectstart=toTixing;
	var isContinue=false;
	function toTixing()
	{
		/*
		if (!isContinue)
		{
			if(!confirm('该页面含公司重要机密信息，请确定是否需要复制？')){
				event.returnValue=false;
			}else{
				isContinue=true;
			}
		}
		*/
	}
	function editFinished(qid)
	{
		saveQuotation();
		<%
			if  "1"=isAwakeDmtoCheck then 
			response.write("alert('请去Special Price Application检查该单的特价。');")
			end if 
		%>
		if(!confirm("确定Quotation编辑完成？（如未完成请点“Edit Finished”左侧的“Save”暂时保存Quotation。）"))
		{
			return;
		}
		location.href="editfinished.asp?qid="+qid;
	}
	function refreshWindow()
	{
		location.href="quotationEdit.asp?qid="+$("#qid").val();
	}
</script>
</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" onLoad="hiddenInit();">
<div align="center">
  <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td><table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td class="titleorange"><div align="center">Imaging Systems Quotation
			</div></td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td>
			<form name="quotationform" action="quotationAdd.asp" method="post" >
			<input type="hidden" name="curRate" id="curRate" value="1">
			<input type="hidden" name="qid" id="qid" value="<%=quotationid%>">
			<table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td width="18%"> <div align="left">Quotation No:<br>报价文件号：<br>
                    </div></td>
                  <td width="32%"> <div align="left"> 
                      <input type="text" name="quotationNO" id="quotationNO" value='<%=quotationNO %>' readonly="true" style="width:100%">
                    </div></td>
                  <td width="18%"> <div align="left">Final User (Hospital) Name<font color="#FF0000">*</font>:<br>最终<font color="#FF0000">*</font>：</div></td>
                  <td width="32%"> <div align="left"> 
                      <input type="text" name="hospName" id="hospName" value="<%=hospName%>" style="width:100%">
                    </div></td>
                </tr>
                <tr class="line01"> 
                  <td> <div align="left">Business Model<font color="#FF0000">*</font>:<br>业务模式<font color="#FF0000">*</font>：</div></td>
                  <td> <div align="left"> 
                      <select name="businessModel" id="businessModel" onChange="setPayTerm();">
					  	<option value="" >请选择</option>
						<%
							for i=1 to ubound (BUSINESS_MODEL)
						%>
						 <option value="<%=BUSINESS_MODEL(i,0)%>"><%=BUSINESS_MODEL(i,1)%></option>
						<%
							
							next
						%>
                      </select>
                    </div></td>
                  <td> <div align="left">Non-list Final User (Hospital) name:<br>自填用户名称：
                    </div></td>
                  <td> <div align="left"> 
                      <input type="text" name="nonHospName" id="nonHospName" value="<%=nonHospName%>" style="width:100%">
                    </div></td>
                </tr>
                <tr class="line01"> 
                  <td> <div align="left">Payment Term<font color="#FF0000">*</font>:<br>付款方式<font color="#FF0000">*</font>：</div></td>
                  <td> <div align="left"> 
                      <select name="paymentTerm" id="paymentTerm" onChange="itemAlert();">
					  	<option value="" >请选择</option>

                      </select>
                 </div></td>
                  <td> <div align="left">Dealer Name:<br>若非飞利浦竞标，请写明经销商名称：</div></td>
                  <td> <div align="left"> 
                      <input type="text" name="dealerName" id="dealerName" value="<%=dealerName%>" style="width:100%">
                    </div></td>
                </tr>
				    <tr class="line01"> 
                  <td> <div align="left">Special Payment Term:<br>特殊付款方式: </div></td>
                  <td> <div align="left"> 
                      <input name="sepcParment" id="sepcParment" value="<%=sepcParment%>" onblur="awokeSpecPay();" style="width:100%">
                 </div></td>
                  <td>&nbsp; </td>
                  <td>&nbsp;</td>
                </tr>
				<tr class="line01"> 
				     <td> <div align="left">Tender Document No:<br>招标文件号：</div></td>
                  <td> <div align="left"> 
                     <input type="text" name="tenderno" id="tenderno" value="<%=tenderno %>" style="width:100%">
                    </div></td>
                  <td> <div align="left">Currency:<br>币种: </div></td>
                  <td> <div align="left">
                      <select name="currencycode" id="currencycode" >
					  	<option value="USD_1">USD&nbsp; 美元</option>
						<%
							set rsCur=server.createObject("adodb.recordset")
							rsCur.open "select * from exchanges order by id ASC",conn,1,1
							while not rsCur.eof
						%>
						 <option value="<%=rsCur("sourcecode")%>_<%=rsCur("rate")%>"><%=rsCur("sourcecode")%>&nbsp;<%=rsCur("currency")%></option>
						<%
							rsCur.movenext
							wend
						%>
                      </select>
                 </div></td>
             
                </tr>
                <tr class="line01"> 
                  <td>&nbsp;</td>
                  <td> <div align="left">&nbsp; </div></td>
                  <td colspan="2"> <div align="right"> 
                      <input type="button" name="Submit" value="Save" onClick="saveQuotation();">
                    <!--  <input type="button" name="Submit2" value="Save&Add New" onClick="saveAndP();"> -->
	                <!--  <input type="button" name="Submit23" value="Save&Exit" onClick="saveAndExit();"> -->
					<% If Not IsNull(quotationid) And quotationid<>"" Then %>
					<input type="button" name="Submit23" value="Edit Finished" onClick="editFinished('<%=quotationid%>');">
					<% End If %>
					    <input type="button" name="Back" value="Return" onClick="goBack();">  
                    </div></td>
                </tr>
              </table></td>
          </tr>
        </table>
		</form>
		</td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
 
    <tr  name="products"> 
      <td><table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td><table id="productTable" width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td width="3%">&nbsp;</td>
                  <td width="5%">No.</td>
                  <td width="38%">BU</td> 
                  <td width="54%">Product</td>
                </tr>
				<% 
					if quotationid<>"" then
					dim i
					i=1
				while not rsProd.eof
				bgcolor=""
				titleMsg=""
				identiHtml=""
				res=validProduct(rsProd("pid"))
				If res="1" Then
					'bgcolor="yellow"
					'titleMsg="该产品标准配置净目标价改变，请重新配置产品"
					'identiHtml="<input type='hidden' name='priceHasChange'>"
				End If
				If res="2" Then
					titleMsg="产品已经不存在，请删除该产品"
					bgcolor="red"
					identiHtml="<input type='hidden' name='prdEscape'>"
				End if
				%>
				<tr class="line02" bgcolor="<%=bgcolor%>" title="<%=titleMsg%>"> 
				<%
					response.write(identiHtml)
				%>
                  <td width="3%"><input type='checkbox' name='qdids' value='<%=rsProd("qdid")%>'>&nbsp;</td>
                  <td width="5%"><%=i%></td>
                 <td width="38%"><%=BU_TYPE(rsProd("BU"),1)%>&nbsp;</td>
                  <td width="54%"><a href="javascript:selectConfig(<%=quotationid%>,<%=rsProd("pid")%>,'<%=rsProd("qdid")%>')" ><%=rsProd("productname")%></a>&nbsp;</td>
                </tr>
				<%
					rsProd.movenext
					i=i+1
					wend
					end if
				%>
                <tr class="line01"> 
                  <td colspan="3"><div align="left" >Target OIT Price<br>
                      目标进单价</div></td>
                  <td id="p1"><%=targetprice%>&nbsp;</td
                ></tr>
				<!--
				 <tr class="line01"> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td><div align="left">standard configuration target price:<br>不包括选件的价格:</div></td>
                  <td id="p3">&nbsp;<%=sctargetprice%></td>
                </tr>
				-->
                <tr class="line01"> 
                  <td  colspan="3"><div align="left">Target OIT Price（Without 
                      Extended Warranty）<br>
                      目标进单价（不含延长保修）
                    </div></td>
                  <td id="p2"><%=targetpricewew%>&nbsp;</td>
                </tr>
			 <tr class="line01"> 
                  <td  colspan="3"><div align="left">Price Adjustment（For Promotion Plan Adjustment Only)<br>
				  	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;价格调整
                    </div></td>
                  <td id="d_adjustprice">&nbsp;</td>
                </tr>
				  <tr class="line01"> 
                  <td  colspan="3"><div align="left">Part I: Philips Product Net Target Price<br>
				  	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;飞利浦产品净目标价
                    </div></td>
                  <td id="part1">&nbsp;</td>
                </tr>
				  <tr class="line01"> 
                  <td  colspan="3"><div align="left">Part II: 3rd Party Items<br>
				  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;第三方产品成本
                    </div></td>
                  <td id="part2">&nbsp;</td>
                </tr>
				  <tr class="line01"> 
                  <td  colspan="3"><div align="left">Part III : Other Provision<br>
				  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;其他预留成本
                    </div></td>
                  <td id="part3">&nbsp;</td>
                </tr>
				  <tr class="line01"> 
                  <td  colspan="3"><div align="left">Part IV: Non-standard Warranty by Philips<br>
				  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;飞利浦非标准保修
                  <td id="part4">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="4"><div align="right"> 
                      <input type="submit" name="Submit2" value="Add" onClick="selectProducts();">
                      &nbsp;&nbsp; 
                      <input type="submit" name="Submit2" value="Delete" onClick="delProductRow();">
                      &nbsp;&nbsp; &nbsp;&nbsp; </div></td>
                </tr>
              </table></td>
          </tr>
        </table></td>
    </tr>
    <tr  name="products"> 
      <td>&nbsp;</td>
    </tr>
    <tr  name="productsAdd" style="display:none"> 
      <td><table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td valign="top"> <table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="table01"> 
                  <td width="100%" valign="top" class="line01"> <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
                      <tr> 
                        <td><table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                            <tr class="line01"> 
                              <td width="18%" height="25"> 
                                <div align="left">BU: <br>
                                </div></td>
                              <td width="32%"> 
                                <div align="left"> 
                                  <select name="bu" onChange="selectProductByBu(this.value)">
                                   	<option value="">请选择</option>
										<%
											for i=1 to ubound (BU_TYPE)
										%>
										 <option value="<%=BU_TYPE(i,0)%>"><%=BU_TYPE(i,1)%></option>
										<%
											next
										%>
                                  </select>
                                </div></td>
								<!--
                              <td width="25%"> <div align="left">Modality Name.: 
                                </div></td>
                              <td width="25%"> <div align="left"> 
                                  <select name="modality" onChange="selectProduct(this.value);">
								  	 <option value="">请选择</option>
                                  </select>
                                </div></td>
								-->
								
                              <td width="18%" >&nbsp;</td>
                              <td width="32%" >&nbsp;</td>
                            </tr>
                            <tr class="line01"> 
                              <td height="25"> <div align="left">Product Name</div></td>
                              <td> <div align="left"> 
                                  <select name="product">
                                    <option value="">请选择</option>
                                  </select>
                                </div></td>
                              <td>&nbsp;
							  <!--
							  <div align="left">Quoted Price</div>
							  -->
							  </td>
                              <td>&nbsp;
                                  <input name="qotedPrice" type="hidden" value="0">
                                </td>
                            </tr>
                          </table></td>
                      </tr>
                    </table>
                    <p align="right"> 
                      <input type="submit" name="Submit" value="Save" onClick="saveProduct();openZone(2);">
                    </p></td>
                </tr>
              </table></td>
          </tr>
        </table></td>
    </tr>
  </table>
   <!--#include file="../footer.asp"-->
</div>
<script>
	setPayTerm();
	<% if isclose then%>
		$("#businessModel").val('<%=businessModel%>');
		setPayTerm();
		$("#paymentTerm").val('<%=paymentTerm%>');
		$("#currencycode").val('<%=currencycode&"_"&curRate%>');
	<% end if%>
	
	setRate($("#currencycode").val());
	
	getPartPrice('<%=quotationid%>');
	<% if quotationid<>"" then%>
		$("#currencycode").attr({"disabled":"disabled"});
	<%end if%>
</script>
</body>
</html>
<%
	if isclose then
		rs.close
		set rs=nothing
		rsProd.close
		set rsProd=nothing
	end if
		CloseDatabase
%>
