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
		'��ѯ�Ƿ���Ҫ����isAwakeDmtoCheck
		Set rs_isAwakeDmtoCheck=conn.execute("select * from quotation a,special_price b where a.quotationno=b.quotationno and  a.status=4 and (b.status=-2  or ispending=1 or ispending=9) and a.qid="&quotationid)
		If Not rs_isAwakeDmtoCheck.bof And Not rs_isAwakeDmtoCheck.eof Then
			isAwakeDmtoCheck="1"
		End If 
		set rsProd=server.createObject("adodb.recordset")
		rsProd.open "select * from quotation_detail where qid="&quotationid,conn,1,1
	end if
	
	if quotationid=""  THEN '���ɱ����ļ���
		application.Lock()
		quotationno=session("userzone")&getdate2()
		userzone=session("userzone")
		if isnull(application(userzone&"quotationdate")) or isempty(application(userzone&"quotationdate")) or application(userzone&"quotationdate")<>getdate2() then
			application(userzone&"quotationdate")=getdate2()
			'ȡ����ǰ���ݿ�������seq
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
			alert("Quotation No����Ϊ��!");
			$("#quotationNO").focus();
			return false;
		}
		if(($("#hospName").val()==null || $("#hospName").val()=='') &&($("#nonHospName").val()==null || $("#nonHospName").val()=='') )
		{
			alert("����д�û�����!");
			return false;
		}
		if($("#businessModel").val()==null || $("#businessModel").val()=='')
		{
			alert("��ѡ��ҵ��ģʽ��");
			$("#businessModel").focus();
			return false;
		}
		if(($("#paymentTerm").val()==null || $("#paymentTerm").val()=='') && ($("#sepcParment").val()==null || $("#sepcParment").val()==''))
		{
			alert("��ѡ�񸶿ʽ����д���⸶�ʽ��");
			//$("#paymentTerm").focus();
			return false;
		}
		if($("#hospName").val()=="" && $("#nonHospName").val()!=null && $("#nonHospName").val()!=""){
			alert("��������û�������commercial ����Final user list,�����ܽ���.");
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
				alert('����Quotation��Ϣʧ��');
			}else{
				$("input:hidden[name='qid']").val(data);
				alert('����ɹ�');
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
	//ɾ����Ʒ
	function delProductRow()
	{
		if(!confirm('ȷ��ɾ���ò�Ʒ��')){
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
	//�Բ�Ʒ�����������
	function resetProductSeq(tname,len){
		var l=$("#"+tname+" tr").size();
		$("#"+tname+" tr").each(function(index){
				if(index>0 && index<l-len){
					var ri= $(this).parent().find("tr").index($(this));   
					$(this).find("td:eq(1)").text(ri);
				}
		});
	}
	//��Ӳ�Ʒ
	function selectProducts(){
		$("select[name='bu']").val('');
		clearOptions('modality');
		clearOptions('product');
		$("input:text[name='qotedPrice']").val('');
		$("tr[name='productsAdd']").show();
	}
	
	//ѡ���Ʒ
	function selectConfig(qid,pid,qdid){
		if($("input:hidden[name='priceHasChange']").size()!=0){
			
		}
		if($("input:hidden[name='prdEscape']").size()!=0){
			alert("��ɾ���Ѿ������ڵĲ�Ʒ");
			return;
		}
		window.open('configAdd.asp?qid='+qid+'&pid='+pid+'&qdid='+qdid+'&curRate='+$("#currencycode").val(),'Configuration','width=1024px,height=768px,resizable=yes');
	}
	//������ӵĲ�Ʒ
	function saveProduct(){
		var qid
		var pid
		qid=$("#qid").val();
		pid=$("select[name='product']").val();
		if($("select[name='product']").val()==''){
			alert('��ѡ���Ʒ');
			return false;
		}
		/*
		if($("input:text[name='qotedPrice']").val()==''){
			alert('����д�۸�');
			return false;
		}else{
			if(isNaN($("input:text[name='qotedPrice']").val())){
				alert('����д���֣�');
				return false;
			}
		}
		*/
		$.post("productAdd.asp",{ot:1,qid:qid,pid:pid,qotedPrice:$("input:hidden[name='qotedPrice']").val()},function(data){
			var res=data;
			if("success"!=data){
				alert("�����ɹ����뵥����Ʒ�������ò�Ʒ��");
				res="success";
			}else{
				return;
			}
			if(res=='success'){
					var l=$("#productTable tr").size();
				$("#productTable").find("tr:eq("+(l-9)+")").after("<tr class='line02'><td><input type='checkbox' name='qdids' value='"+data+"'></td><td>"+(l-8)+"</td><td>"+$("select[name='bu']").find("option:selected").text()+"</td><td><a href='#'  onclick='selectConfig("+$("#qid").val()+","+$("select[name='product']").val()+","+data+");'>"+$("select[name='product']").find("option:selected").text()+"</a></td></tr>");
			}else{
				alert('��Ӳ�Ʒ��������ϵϵͳ����Ա��');
			}
		});
		$("tr[name='productsAdd']").hide();
	}
	//����ҳ���������ʵ���
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
	//ҳ���ʼ�������ʾ
	function hiddenInit()
	{
		$("tr[name='products']").hide();
		<% if quotationid<>"" then %>
		$("tr[name='products']").show();
		<% end if%>
	}
	//ѡ��modality
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
	 //ѡ���Ʒ
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
	 //��ո���select��options���������¡���ѡ�񡱵�ѡ��
	 function clearOptions(on){
	 	var obj=document.all(on);
		$("select[name='"+on+"']").empty();
		$("<option value=''>��ѡ��</option>").appendTo("select[name='"+on+"']");
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
		msg=" Business Partner ��׼���ʽΪ100% TT /  LC ��������Ϊ�Ǳ�׼���ʽ���밴��SOP-F&A-001��ǰ����������";
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
		msg="���⸶�ʽ����õ��ſز��ŵ���׼,�����޷�OIT. �����������̲ο�OIT����!";
		if($("#sepcParment").val()!=null && $("#sepcParment").val()!=''){
			alert(msg);
		}
	}
	function goBack(){
		location.href="quotationList.asp?d=<%=now%>";
	}

	//���ѡ���ʱ������
	document.onselectstart=toTixing;
	var isContinue=false;
	function toTixing()
	{
		/*
		if (!isContinue)
		{
			if(!confirm('��ҳ�溬��˾��Ҫ������Ϣ����ȷ���Ƿ���Ҫ���ƣ�')){
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
			response.write("alert('��ȥSpecial Price Application���õ����ؼۡ�');")
			end if 
		%>
		if(!confirm("ȷ��Quotation�༭��ɣ�����δ�����㡰Edit Finished�����ġ�Save����ʱ����Quotation����"))
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
                  <td width="18%"> <div align="left">Quotation No:<br>�����ļ��ţ�<br>
                    </div></td>
                  <td width="32%"> <div align="left"> 
                      <input type="text" name="quotationNO" id="quotationNO" value='<%=quotationNO %>' readonly="true" style="width:100%">
                    </div></td>
                  <td width="18%"> <div align="left">Final User (Hospital) Name<font color="#FF0000">*</font>:<br>����<font color="#FF0000">*</font>��</div></td>
                  <td width="32%"> <div align="left"> 
                      <input type="text" name="hospName" id="hospName" value="<%=hospName%>" style="width:100%">
                    </div></td>
                </tr>
                <tr class="line01"> 
                  <td> <div align="left">Business Model<font color="#FF0000">*</font>:<br>ҵ��ģʽ<font color="#FF0000">*</font>��</div></td>
                  <td> <div align="left"> 
                      <select name="businessModel" id="businessModel" onChange="setPayTerm();">
					  	<option value="" >��ѡ��</option>
						<%
							for i=1 to ubound (BUSINESS_MODEL)
						%>
						 <option value="<%=BUSINESS_MODEL(i,0)%>"><%=BUSINESS_MODEL(i,1)%></option>
						<%
							
							next
						%>
                      </select>
                    </div></td>
                  <td> <div align="left">Non-list Final User (Hospital) name:<br>�����û����ƣ�
                    </div></td>
                  <td> <div align="left"> 
                      <input type="text" name="nonHospName" id="nonHospName" value="<%=nonHospName%>" style="width:100%">
                    </div></td>
                </tr>
                <tr class="line01"> 
                  <td> <div align="left">Payment Term<font color="#FF0000">*</font>:<br>���ʽ<font color="#FF0000">*</font>��</div></td>
                  <td> <div align="left"> 
                      <select name="paymentTerm" id="paymentTerm" onChange="itemAlert();">
					  	<option value="" >��ѡ��</option>

                      </select>
                 </div></td>
                  <td> <div align="left">Dealer Name:<br>���Ƿ����־��꣬��д�����������ƣ�</div></td>
                  <td> <div align="left"> 
                      <input type="text" name="dealerName" id="dealerName" value="<%=dealerName%>" style="width:100%">
                    </div></td>
                </tr>
				    <tr class="line01"> 
                  <td> <div align="left">Special Payment Term:<br>���⸶�ʽ: </div></td>
                  <td> <div align="left"> 
                      <input name="sepcParment" id="sepcParment" value="<%=sepcParment%>" onblur="awokeSpecPay();" style="width:100%">
                 </div></td>
                  <td>&nbsp; </td>
                  <td>&nbsp;</td>
                </tr>
				<tr class="line01"> 
				     <td> <div align="left">Tender Document No:<br>�б��ļ��ţ�</div></td>
                  <td> <div align="left"> 
                     <input type="text" name="tenderno" id="tenderno" value="<%=tenderno %>" style="width:100%">
                    </div></td>
                  <td> <div align="left">Currency:<br>����: </div></td>
                  <td> <div align="left">
                      <select name="currencycode" id="currencycode" >
					  	<option value="USD_1">USD&nbsp; ��Ԫ</option>
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
					'titleMsg="�ò�Ʒ��׼���þ�Ŀ��۸ı䣬���������ò�Ʒ"
					'identiHtml="<input type='hidden' name='priceHasChange'>"
				End If
				If res="2" Then
					titleMsg="��Ʒ�Ѿ������ڣ���ɾ���ò�Ʒ"
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
                      Ŀ�������</div></td>
                  <td id="p1"><%=targetprice%>&nbsp;</td
                ></tr>
				<!--
				 <tr class="line01"> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td><div align="left">standard configuration target price:<br>������ѡ���ļ۸�:</div></td>
                  <td id="p3">&nbsp;<%=sctargetprice%></td>
                </tr>
				-->
                <tr class="line01"> 
                  <td  colspan="3"><div align="left">Target OIT Price��Without 
                      Extended Warranty��<br>
                      Ŀ������ۣ������ӳ����ޣ�
                    </div></td>
                  <td id="p2"><%=targetpricewew%>&nbsp;</td>
                </tr>
			 <tr class="line01"> 
                  <td  colspan="3"><div align="left">Price Adjustment��For Promotion Plan Adjustment Only)<br>
				  	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�۸����
                    </div></td>
                  <td id="d_adjustprice">&nbsp;</td>
                </tr>
				  <tr class="line01"> 
                  <td  colspan="3"><div align="left">Part I: Philips Product Net Target Price<br>
				  	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�����ֲ�Ʒ��Ŀ���
                    </div></td>
                  <td id="part1">&nbsp;</td>
                </tr>
				  <tr class="line01"> 
                  <td  colspan="3"><div align="left">Part II: 3rd Party Items<br>
				  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��������Ʒ�ɱ�
                    </div></td>
                  <td id="part2">&nbsp;</td>
                </tr>
				  <tr class="line01"> 
                  <td  colspan="3"><div align="left">Part III : Other Provision<br>
				  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����Ԥ���ɱ�
                    </div></td>
                  <td id="part3">&nbsp;</td>
                </tr>
				  <tr class="line01"> 
                  <td  colspan="3"><div align="left">Part IV: Non-standard Warranty by Philips<br>
				  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�����ַǱ�׼����
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
                                   	<option value="">��ѡ��</option>
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
								  	 <option value="">��ѡ��</option>
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
                                    <option value="">��ѡ��</option>
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
