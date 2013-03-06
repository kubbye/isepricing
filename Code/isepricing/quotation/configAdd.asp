<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/commons.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="quotationUtils.asp"-->

<%
	dim rs,rs1,rs2,rs3,rs4,rs5,rs6,rs7,rs8
	dim PromotionPlan   '促销
	dim qid,pid,strSql,isclose,qdid,bu
	dim curRate,currencycode,currencyrate
	dim fi,ficharged,fiamount,ibp,ibpcharged,ibpamount,atamount,sbp,sbpcharged,sbpamount,ewbp,ewbpyear,ewbpprice,comments,site
	dim sewbp,sewbpyear,sewbpprice,sewbpunitcost,ewbpunitcost
	dim stdPrice,appcost,inst,warrcost,isfreight
	qid=request("qid")
	pid=request("pid")
	qdid=request("qdid")
	curRate=request("curRate")
	currencycode=split(curRate,"_")(0)
	currencyrate=split(curRate,"_")(1)
	'查询出新的pid
	Set rsNewProd=conn.execute("select a.pid,productname from v_product a where a.state=0 and a.status=0 and exists(select * from v_product  where a.productname=productname and bu=a.bu and pid="&pid&")")
	pid=rsNewProd("pid")
	productname=rsNewProd("productname")
	if qid<>"" then
		isclose=true
		'查询qdid
		set rs=server.createObject("adodb.recordset")
		rs.open "select * from quotation_detail where qid="& qid &" and qdid= "& qdid,conn,1,1
		if not rs.eof then
			ewbp=rs("ewbp")
			ewbpyear=rs("ewbpyear")
			ewbpprice=rs("ewbpprice")
			If ewbpyear=0 Then
				ewbpunitcost=0
			Else
				ewbpunitcost=ewbpprice/ewbpyear
			End if
			sewbp=rs("sewbp")
			sewbpyear=rs("sewbpyear")
			sewbpprice=rs("sewbpprice")
			If sewbpyear=0 Then
				sewbpunitcost=0
			Else
				sewbpunitcost=sewbpprice/sewbpyear
			End if
			
			comments=rs("comments")
			site=rs("site")
			
			fi=rs("fi")
			ficharged=rs("ficharged")
			fiamount=rs("fiamount")
			ibp=rs("ibp")
			ibpcharged=rs("ibpcharged")
			ibpamount=rs("ibpamount")
			ibpcharged=rs("ibpcharged")
			ibpamount=rs("ibpamount")
			atamount=rs("atamount")
			sbp=rs("sbp")
			sbpcharged=rs("sbpcharged")
			sbpamount=rs("sbpamount")
			PriceAdjustment=rs("ADJUSTPRICE")
			AdjustmentReason=RS("ADJUSTCOMMENTS")
		end if
		
		'philips标准件
		strSql="select a.mutex,a.pdid, a.materialno,a.description,a.qty,a.listprice*"&currencyrate&" listprice,a.targetprice*"&currencyrate&" targetprice,b.pdid pd  from product_detail_philips a left join (select * from quotation_detail_philips b where qdid="&qdid&") b on a.pdid=b.pdid  where a.type=0 and a.pid="&pid 
		strSql=strSql & " order by a.sortno,a.mutex"
		set rs1=server.createObject("adodb.recordset")
		rs1.open strsql,conn,1,1
		
		'philips选装件
		strSql="select * from QUOTATION_DETAIL_PHILIPS where type=1 and pdid!=0 and qdid="&qdid
		set rs2=server.createObject("adodb.recordset")
		rs2.open strsql,conn,1,1

		'philips other 选装件
		strSql="select * from QUOTATION_DETAIL_PHILIPS where type=1 and pdid=0 and qdid="&qdid
		set rs8=server.createObject("adodb.recordset")
		rs8.open strsql,conn,1,1
		
		'第3方标准件
		strSql="select a.pdid,a.pid,a.cid,a.type,a.materialno,a.itemname,a.unitcost,a.unitcostrmb,a.qty,a.mutex,b.pdid pd from PRODUCT_DETAIL_3RD a left join (select * from quotation_detail_3rd where qdid="&qdid&")b on a.pdid=b.pdid where a.type=0 and a.pid="&pid
		strSql=strSql & "  order by a.mutex"
		set rs3=server.createObject("adodb.recordset")
		rs3.open strSql,conn,3,1
		
		'第3方选装件
		strSql="select a.*,b.unitcost oldunitcost,b.unitcostrmb oldunitcostrmb from  QUOTATION_DETAIL_3RD a left join (select * from party where state=0 and status=0) b on a.materialno=b.itemcode where a.partytype=0  and a.type=1 and  a.qdid="&qdid
		set rs4=server.createObject("adodb.recordset")
		rs4.open strsql,conn,1,1
		'不在表中的第3方配件
		strSql="select * from QUOTATION_DETAIL_3RD where partytype=1 and  qdid="&qdid
		set rs7=server.createObject("adodb.recordset")
		rs7.open strsql,conn,1,1
		
		'其他费用查询
		strSql="select a.mid,a.modality,a.bu,a.inst,a.warr,a.apptraining,b.pid,b.productname,b.standardprice,b.freight isfreight,b.inst isinst,b.warr iswarr,b.apptraining istraining ,b.remark from modality  a,product b where a.mid=b.mid and b.pid="&pid
		set rs5=server.createObject("adodb.recordset")
		rs5.open strsql,conn,1,1
		bu=rs5("bu")
		stdPrice=rs5("standardprice")*currencyrate
		
		isfreight=rs5("isfreight")
		appcost=rs5("istraining")
		inst=rs5("isinst")
		warrcost=rs5("iswarr")
		
		PromotionPlan=rs5("remark")
		if not isnull(PromotionPlan) and PromotionPlan<>"" then
			'response.Write("<script>alert('"&PromotionPlan&"');</script>")
		end if
		'provision备件信息
		strSql="select * from QUOTATION_DETAIL_provision where  qdid="&qdid
		set rs6=server.createObject("adodb.recordset")
		rs6.open strsql,conn,1,1
	end If
	
	'提示信息
	titleMsg1="备件已经不存在，请删除备件"
	titleMsg2="备件价格发生变化，请删除后重新选择备件"
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title></title>
<LINK href="../css/css.css" type=text/css rel=stylesheet>
<script type="text/javascript" src="../js/ut.js"></script>
<script type="text/javascript" src="../js/jquery-1.2.6.js"></script>
<script type="text/javascript">
	var needto=2;
	function calcSum(){
		var t1=0,t2=0,t3=0,t4=0,t5=0;
		var t6=0,t7=0,t8=0,t9=0;
		t1=<%=stdPrice%>;
		/*
		$("input:hidden[name='must_qty']").each(function(index){
			var qp=$("input:hidden[name='must_qp']").eq(index).val();
			if(qp==null || qp==''){
				qp=0;
			}
			t1=parseFloat(t1)+parseFloat(qp);
		});
		*/
		$("input:hidden[name='opt_qty']").each(function(index){
			var qp=$("input:hidden[name='opt_qp']").eq(index).val();
			if(qp==null || qp==''){
				qp=0;
			}
			t2=parseFloat(t2)+parseFloat(qp);
		});
		
		var rate1=0,rate2=0,rate3=0,rate4=0;
		var fi=$("select[name='fi']").val();
		if(fi==1){
			rate1=0.005;
		}else if(fi==2){
			rate1=0;
		}else if(fi==3){
			rate1=0.003;
		}
		var ibps=$("select[name='ibps']").val();
		if(ibps==1){
			rate2=<%=cdbl(rs5("inst"))/100%>;
		}else{
			rate2=0;
		}
		var swbps=$("select[name='swbps']").val();
		if(swbps==1){
			rate3=<%=cdbl(rs5("warr"))/100%>;
		}else{
			rate3=0;
		}
		t5=parseFloat(t1)+parseFloat(t2);
		t6=parseFloat(t5)*parseFloat(rate1);
		t7=parseFloat(t5)*parseFloat(rate2);
		t8=<%=cdbl(rs5("apptraining"))%>;
		t9=parseFloat(t5)*parseFloat(rate3);
		t3=parseFloat(t5)-parseFloat(t6)-parseFloat(t7)-parseFloat(t8)-parseFloat(t9);
		t4=parseFloat(t6)+parseFloat(t7)+parseFloat(t8)+parseFloat(t9);
		t1=formatNumber(t1,'123456789');
		t2=formatNumber(t2,'123456789');
		t3=formatNumber(t3,'123456789');
		t4=formatNumber(t4,'123456789');
		t5=formatNumber(t5,'123456789');
		t6=formatNumber(t6,'123456789');
		t7=formatNumber(t7,'123456789');
		t8=formatNumber(t8,'123456789');
		t9=formatNumber(t9,'123456789');
		$("#t1").text(t1);
		$("#t2").text(t2);
		$("#t3").text(t3);
		$("#t4").text(t4);
		$("#t5").text(t5);
		$("#t6").text(t6);
		$("#t7").text(t7);
		$("#t8").text(t8);
		$("#t9").text(t9);
		
		$("#p1").text(rate1*100);
		$("#p2").text(rate2*100);
		$("#p3").text(rate3*100);
		
		$("#ficharged").val(rate1*100);
		$("#fiamount").val(t6);
		$("#ibpcharged").val(rate2*100);
		$("#ibpamount").val(t7);
		$("#atamount").val(t8);
		$("#sbpcharged").val(rate3*100);
		$("#sbpamount").val(t9);
		
		$("#part1").val(t5);
	}
	function calcThrSum(){
		var t10=0;
		/*
		$("input:hidden[name='thr_must_qty']").each(function(index){
			var qp=$("input:hidden[name='thr_must_qp']").eq(index).val();
			if(qp==null || qp==''){
				qp=0;
			}
			t10=parseFloat(t10)+parseFloat(qp);
		});
		*/
		var p4=parseFloat(t10)+parseFloat($("#t1").text());
		p4=formatNumber(p4,'123456789');
		$("#part4").val(p4);
		$("input:hidden[name='thr_opt_qty']").each(function(index){
			var qp=$("input:hidden[name='thr_opt_qp']").eq(index).val();
			if(qp==null || qp==''){
				qp=0;
			}
			t10=parseFloat(t10)+parseFloat(qp);
		});
		
		$("input:text[name='thr_var_qp']").each(function(index){
			var qp=$("input:text[name='thr_var_qp']").eq(index).val();
			if(qp==null || qp==''){
				qp=0;
			}
			t10=parseFloat(t10)+parseFloat(qp);
		});
		
		if($("#site").val()!=null && $("#site").val()!=''){
			t10=t10+parseFloat($("#site").val());
		}
		t10=formatNumber(t10,'1234567890');
		$("#t10").text(t10);
		
		$("#part2").val(t10);
	}
	function calcThrVar(){
		$("input:text[name='thr_var_qty']").each(function(index){
			var qty=$(this).val();
			if(qty==null || qty=='')
			{
				qty=0;
				$(this).val(0);
			}
			if(isNaN($(this).val()) || $(this).val()<0){
				alert("Quantity请填写整数！");
				qty=0;
			}
			var lp=$("input:text[name='thr_var_lp']").eq(index).val();
			if(lp==null || lp==''){
				lp=0;
				$("input:text[name='thr_var_lp']").eq(index).val(0);
			}
			if(isNaN(lp) || lp<0){
				alert("Unit Cost请填写整数！");
				lp=0;
			}
			var qp=parseInt(qty)*parseFloat(lp);
			qp=formatNumber(qp,'1234567890.00');
			$("input:text[name='thr_var_qp']").eq(index).val(qp);
		});
		calcThrSum();
		
	}
	function calcProvisionSum(){
		$("input:text[name='pro_qty']").each(function(index){
			var qty=$(this).val();
			if(qty==null || qty=='')
			{
				qty=0;
				$(this).val(0);
			}
			if(isNaN(qty) || parseInt(qty)<0){
				alert('must to be positive integer!');
				return false;
			}
			var lp=$("input:text[name='pro_lp']").eq(index).val();
			if(lp==null || lp=='')
			{
				lp=0;
				$("input:text[name='pro_lp']").eq(index).val(0);
			}
			if(isNaN(lp)){
				alert('请填写数字！');
				return false;
			}else{
				var qp=parseInt(qty)*parseFloat(lp);
				qp=formatNumber(qp,'1234567890.00');
				$(this).parent().parent().find("td:eq(5)").html(qp+"<input type='hidden' name='pro_qp' value='"+qp+"'> ");
			}
		});
		var t11=0;
		$("input:hidden[name='pro_qp']").each(function(index){
			if($(this).val()!=null && $(this).val()!=''){
				t11=parseFloat(t11)+parseFloat($(this).val());
			}
		});
		t11=formatNumber(t11,'1234567890');
		$("#t11").text(t11);
		$("#part3").val(t11);
	}
	function calcWarr(){
		var ewbp=$("#ewbp").val();
		var ewbpyear=$("#ewbpyear").val();
		var sewbp=$("#sewbp").val();
		var sewbpyear=$("#sewbpyear").val();
		if(ewbp=='0'){
			$("#ewbpyear").val('0');
			$("#ewbpunitcost").val('0');
			$("#ewbpprice").val('0');
		}else if(ewbp=='1'){
			if($("#ewbpunitcost").val()!=null && !isNaN($("#ewbpunitcost").val())){
				tp=$("#ewbpyear").val()*$("#ewbpunitcost").val();
				tp=formatNumber(tp,'1234567890.00');
				$("#ewbpprice").val(tp);
			}else{
				$("#ewbpunitcost").val('0');
				$("#ewbpprice").val('0');
			}
		}
		if(sewbp=='0'){
			$("#sewbpyear").val('0');
			$("#sewbpunitcost").val('0');
			$("#sewbpprice").val('0');
		}else if(sewbp=='1'){
			if($("#sewbpunitcost").val()!=null && !isNaN($("#sewbpunitcost").val())){
				tp=$("#sewbpyear").val()*$("#sewbpunitcost").val();
				tp=formatNumber(tp,'1234567890.00');
				$("#sewbpprice").val(tp);
			}else{
				$("#sewbpunitcost").val('0');
				$("#sewbpprice").val('0');
			}
		}
	}
	function selectStdConfigs(pid){
		var pdids;
		pdids='';
		if($("input:checkbox[name='pdid_opts']").size()>0)
		{
			$("input:checkbox[name='pdid_opts']").each(function(index){
				if(index==0){
					pdids=$(this).val();
				}else{
					pdids=pdids+","+$(this).val();
				}
			});
		}
		window.open('../selects/configrationSelect.asp?pid='+pid+"&pdids="+pdids+'&bu='+$("#bu").val()+'&currate='+$("#curRate").val(),'','width=1024px,height=768px,resizable=yes');
	}
	function selectOtherStdConfigs(pid){
		var pdids;
		pdids='';
		if($("input:checkbox[name='pdid_opts']").size()>0)
		{
			$("input:checkbox[name='pdid_opts']").each(function(index){
				if(index==0){
					pdids=$(this).val();
				}else{
					pdids=pdids+","+$(this).val();
				}
			});
		}
		window.open('../selects/otherConfigrationSelect.asp?pid='+pid+"&pdids="+pdids+'&currate='+$("#curRate").val(),'','width=1024px,height=768px,resizable=yes');
	}
	function delRow(){
		if(!confirm('确定删除该选件？')){
			return false;
		}
		$("input:checkbox[name='pdid_opts'][checked]").each(function(id){
			$(this).parent().parent().remove();
		});
		resetProductSeq('opt_table',(4-needto));
		calcSum();
		huchi(1);
	}
	
	function selectThrConfigs(pid){
		var pdids;
		pdids='';
		if($("input:checkbox[name='thr_pdid_opts']").size()>0)
		{
			$("input:checkbox[name='thr_pdid_opts']").each(function(index){
				if(index==0){
					pdids=$(this).val();
				}else{
					pdids=pdids+","+$(this).val();
				}
			});
		}
		window.open('../selects/thrConfigrationSelect.asp?pid='+pid+"&pdids="+pdids+'&currate='+$("#curRate").val(),'','width=1024px,height=768px,resizable=yes');
	}
	function delThrRow(){
		if(!confirm('确定删除第三方产品？')){
			return false;
		}
		$("input:checkbox[name='thr_pdid_opts'][checked]").each(function(id){
			$(this).parent().parent().remove();
		});
		$("input:checkbox[name='thr_var_pdid'][checked]").each(function(id){
			$(this).parent().parent().remove();
		});
		resetProductSeq('thr_table',3);
		calcThrSum();
	}
	function addRow(tablename,str,pid,qty,lp,qp,isConfig){
		var l=$("#"+tablename+" tr").size()-(5-needto);
		var obj=$("#"+tablename+" tr:eq("+l+")").after(str);
		$("#"+tablename+" tr:eq("+(l+1)+")").find("td:eq(0)").html("<input type='checkbox' name='pdid_opts' value='"+pid+"'><input type='hidden' name='opt_isConfig' value='"+isConfig+"'>");
		$("#"+tablename+" tr:eq("+(l+1)+")").find("td:eq(5)").html(qty+"<input type='hidden' name='opt_qty' value='"+qty+"'>");
		$("#"+tablename+" tr:eq("+(l+1)+")").find("td:eq(6)").html(lp*qty+"<input type='hidden' name='opt_lp' value='"+lp+"'>&nbsp;");
		$("#"+tablename+" tr:eq("+(l+1)+")").find("td:eq(7)").html(qp+"<input type='hidden' name='opt_qp' value='"+qp+"'>&nbsp;");
		resetProductSeq('opt_table',(4-needto));
		calcSum();
		huchi(0);
	}
	function addThrRow(tablename,str,pid,qty,lp,qp){
		var l=$("#"+tablename+" tr").size()-4;
		var obj=$("#"+tablename+" tr:eq("+l+")").after(str);
		$("#"+tablename+" tr:eq("+(l+1)+")").find("td:eq(0)").html("<input type='checkbox' name='thr_pdid_opts' value='"+pid+"'>");
		$("#"+tablename+" tr:eq("+(l+1)+")").find("td:eq(4)").html(qty+"<input type='hidden' name='thr_opt_qty' value='"+qty+"'>");
		$("#"+tablename+" tr:eq("+(l+1)+")").find("td:eq(5)").html(lp+"<input type='hidden' name='thr_opt_lp' value='"+lp+"'>&nbsp;");
		$("#"+tablename+" tr:eq("+(l+1)+")").find("td:eq(6)").html(qp+"<input type='hidden' name='thr_opt_qp' value='"+qp+"'>&nbsp;");
		resetProductSeq('thr_table',3);
		calcThrSum();
	}
	function addThrVarRow(){
		var str=" <tr class='line02'><td>&nbsp;<input type='checkbox' name='thr_var_pdid'></td>";
              str=str+"<td>4</td><td><input type='text' name='thr_var_materialno' value='' size='25'></td><td><input type='text'  name='thr_var_itemname' style='width:100%' value=''></td>";
              str=str+"<td><input type='text' size='5'  maxlength='5' name='thr_var_qty' onblur='calcThrVar();'></td><td><input type='text' name='thr_var_lp'  size='12'  maxlength='5' onblur='calcThrVar();awokeThrVar(this.value);'></td>";
               str=str+"<td>&nbsp;<input type='text' name='thr_var_qp' size='12' value='' readonly></td></tr>";
		var l=$("#thr_table tr").size()-4;
		var obj=$("#thr_table tr:eq("+l+")").after(str);
		resetProductSeq('thr_table',3);
	}
	function addProvisionRow(){
		var l=$("#provision_table tr").size()-3;
		var str;
		
		str=" <tr class='line02'><td><input type='checkbox' name='pro_pdid'></td><td>"+(l+1)+"</td><td><input type='text' name='pro_materialno'  style='width:100%'> </td><td><input type='text' name='pro_qty' onblur='calcProvisionSum();' size='5'> </td><td><input type='text' name='pro_lp' onblur='calcProvisionSum();' size='12'> </td><td><input type='hidden' name='pro_qp'> </td></tr>";
		var obj=$("#provision_table tr:eq("+l+")").after(str);
		resetProductSeq('provision_table',2);
		calcProvisionSum();
	}
	function delProvisionRow(){
		if(!confirm('确定删除？')){
			return false;
		}
		$("input:checkbox[name='pro_pdid'][checked]").each(function(id){
			$(this).parent().parent().remove();
		});
		resetProductSeq('provision_table',2);
		calcProvisionSum();
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
	function chkSite(){
		if($("#site").val()!=null && $("#site").val()){
			if(isNaN($("#site").val())){
				alert('请填写数字！');
				$("#site").val("0");
				$("#site").focus();
			}
			
		}else{
			$("#site").val('0');
		}
		calcThrSum();
	}
	function checkWarr(){
		var val=true;
		var msg="请检查\"Part IV : 飞利浦非标准保修\”中填写内容";
		var uc=<%=EWBP_COST%>;
		var ewbp=$("#ewbp").val();
		var ewbpyear=$("#ewbpyear").val();
		var sewbp=$("#sewbp").val();
		var sewbpyear=$("#sewbpyear").val();
		if(ewbp=='0'){
			$("#ewbpyear").val('0');
			if($("#ewbpyear").val()==0 && $("#ewbpprice").val()!=0)
			{
				alert(msg);
				$("#ewbpprice").focus();
				return false;
			}
		}else if(ewbp=='1'){
			if($("#ewbpyear").val()==null || $("#ewbpyear").val()==''){
				alert(msg);
				$("#ewbpyear").focus();
				return false;
			}else{
				if(isNaN($("#ewbpyear").val()) || $("#ewbpyear").val()<0){
					alert(msg);
					$("#ewbpyear").focus();
					return false;
				}
			}
			if($("#ewbpprice").val()==null || $("#ewbpprice").val()==''){
				alert(msg);
				$("#ewbpprice").focus();
				return false;
			}else{
				if(isNaN($("#ewbpprice").val()) || $("#ewbpprice").val()<0){
					alert(msg);
					$("#ewbpprice").focus();
					return false;
				}
			}
		}
		if(sewbp=='0'){
			$("#sewbpyear").val('0');
			if($("#sewbpyear").val()==0 && $("#sewbpprice").val()!=0)
			{
				alert(msg);
				$("#sewbpprice").focus();
				return false;
			}
		}else if(sewbp=='1'){
			if($("#sewbpyear").val()==null || $("#sewbpyear").val()==''){
				alert(msg);
				$("#sewbpyear").focus();
				return false;
			}else{
				if(isNaN($("#sewbpyear").val()) || $("#sewbpyear").val()<0){
					alert(msg);
					$("#sewbpyear").focus();
					return false;
				}
			}
			if($("#sewbpprice").val()==null || $("#sewbpprice").val()==''){
				alert(msg);
				$("#sewbpprice").focus();
				return false;
			}else{
				if(!isPlusInt($("#sewbpprice").val())){
					alert(msg);
					$("#sewbpprice").focus();
					return false;
				}
			}
		}
		return true;
	}
	function checkProvision(){
		var val=true;
		var msg="请检查 \”Part III : Other Provision 其他预留成本 \”中填写内容";
		var msg_provision="确定不添加其它预留成本？";
		$("input:text[name='pro_materialno']").each(function(index){
			if($(this).val()==null || $(this).val()==''){
				alert(msg);
				val=  false;
				$(this).focus();
				return false;
			}
		});
		if(!val){
			return false;
		}
		$("input:text[name='pro_qty']").each(function(index){
			qty=$(this).val();
			lp=$("input:text[name='pro_lp']").eq(index).val();
			if(qty==null || qty=='' || lp==null || lp==''){
				alert(msg);
				val= false;
				$(this).focus();
				return false;
			}
			if(isNaN(qty) || qty<0 || isNaN(lp) || lp<0){
				alert(msg);
				val= false;
				$(this).focus();
				return false;
			}
			if((qty==0 && lp!=0) || (qty!=0 && lp==0))
			{
				alert(msg);
				val= false;
				return false;
			}
		});
		if(!val){
			return false;
		}
		var istip=true;
		$("input:text[name='pro_qty']").each(function(index){
			if($(this).val()!=0){
				istip= false;
				$(this).focus();
				return false;
			}
		});
		if(istip)
		{
			if(!confirm(msg_provision)){
				val=false;
			}
		}
		return val;
	}
	function checkThrVar(){
		var val=true;
		var msg="请检查  \"Part II 第三方产品成本:Non-Philips 3rd Party \”中填写内容";
		/*
		$("input:text[name='thr_var_materialno']").each(function(index){
			if($(this).val()==null || $(this).val()==''){
				alert("materialno can not be null");
				val= false;
				$(this).focus();
				return false;
			}
		});
		if(!val){
			return false;
		}
		*/
		$("input:text[name='thr_var_itemname']").each(function(index){
			if($(this).val()==null || $(this).val()==''){
						
				alert(msg);
				val= false;
				$(this).focus();
				return false;
			}
		});
		if(!val){
			return false;
		}
		$("input:text[name='thr_var_qty']").each(function(index){
			qty=$(this).val();
			lp=$("input:text[name='thr_var_lp']").eq(index).val();
			if(qty==null ||qty=='' || lp==null || lp==''){
				alert(msg);
				val= false;
				$(this).focus();
				return false;
			}
			if(isNaN(qty) || qty<0 || isNaN(lp) || lp<0){
				alert(msg);
				val= false;
				$(this).focus();
				return false;
			}
			if((qty==0 && lp!=0) || (qty!=0 && lp==0))
			{
				alert(msg);
				val= false;
				return false;
			}
		});
		if(!val){
			return false;
		}
		return val;
	}
	function checkDueWith(){
		if($("input:hidden[name='mustDueWith']").size()>0){
			alert('必须处理标红的备件！');
			return false;
		}
		return true;
	}
	function doSubmit(){
		var msg_thr_var="是否不需要添加Part II : 3rd party items？";
		var msg_opts="确定不添加选件？";
		var msg_provision="确定不添加其它预留成本？";
		val=true;
		//philips可选件
		var opts='';
		if ($("input:checkbox[name='pdid_opts']").size()==0)
		{
			if(!confirm(msg_opts)){
				return false;
			}
		}
		$("input:checkbox[name='pdid_opts']").each(function(index){
			if(index==0){
				opts=$(this).val();
			}else{
				opts=opts+","+$(this).val();
			}
			$("#opts").val(opts);
		});
		
		if(huchi_flag){
			huchi(1);
			return;
		}
		if(!checkDueWith()){
			return false;
		}
		if(!checkAdjust(2))
		{
			return false;
		}
		if(!checkThrVar()){
			return false;
		}
		if(!checkProvision()){
			return false;
		}
		if(!checkWarr()){
			return false;
		}
	
	
		
		//philips必选件
		var must_ids='';
		$("input:hidden[name='pdid_musts']").each(function(index){
			if(index==0){
				must_ids=$(this).val();
			}else{
				must_ids=must_ids+","+$(this).val();
			}
		});
		$("input:radio").each(function(index){
			if ($(this).attr("name").indexOf("pdid_musts")==0 && $(this).attr("checked")==true)
			{
				if(must_ids==''){
					must_ids=$(this).val();
				}else{
					must_ids=must_ids+","+$(this).val();
				}
			}
			
		});
		$("#must_ids").val(must_ids);
		
		//第3方必选件   
			var thr_must_ids='';
		$("input:hidden[name='thr_musts']").each(function(index){
			if(index==0){
				thr_must_ids=$(this).val();
			}else{
				thr_must_ids=thr_must_ids+","+$(this).val();
			}
		});
		$("input:radio").each(function(index){
			if ($(this).attr("name").indexOf("thr_musts")==0 && $(this).attr("checked")==true)
			{
				if(thr_must_ids==''){
					thr_must_ids=$(this).val();
				}else{
					thr_must_ids=thr_must_ids+","+$(this).val();
				}
			}
			
		});
		$("#thr_must_ids").val(thr_must_ids);
		//第3方可选件
		var thr_opts='';
		if ($("input[name='thr_pdid_opts']").size()==0)
		{
			if(!confirm(msg_thr_var)){
				return false;
			}
		}
		$("input[name='thr_pdid_opts']").each(function(index){
			if(index==0){
				thr_opts=$(this).val();
			}else{
				thr_opts=thr_opts+","+$(this).val();
			}
			$("#thr_opts").val(thr_opts);
		});
		var f=document.forms[0];
		f.submit();
	}
	function awokeThrVar(lp){
			//if(lp>=(1500*$("#currencyrate").val())){
				alert("超过1500美金的非飞利浦第三方产品如需进单需要SCM批准.");
			//}
	}
	function awokeProvision(val){	
		if(val!=null && val!=""  && val!="0" && $("#isawokeProvision").val()=='0')
			alert("海外培训的人均费用为每人USD7000，本地培训为每人USD2000，开机典礼和科研费用依情况确定.但上述四项的费用预留总额不能超过外贸合同金额的10%.");
			//$("#isawokeProvision").val('1');
	}
	function awokeProvision2(){	
			var msg;
			msg="如果有第三方佣金预留要求，OIT时 需要填写SOP-F&A-008a1, Commission to third party requisition form，并获得相应的批准.Commission % over upper limit (the lower of USD 100K or 6% for IS modalities and 10% for US &PCCI modalities), it must be approved by GSS GC CEO and CFO in advance.佣金总数需合理参照售出飞利浦产品或服务的价值。佣金上线设为 1): 10万美金， 和2)影像类产品的6%， 或者超声和患者护理和临床信息系统产品的10%当中较低的那个金额。但凡超过上述限额必须提前经过医疗保健事业部大中华区总裁和财务总监的同意";
			alert(msg);
	}
	function checkAdjust(step)
	{
		var val=$("#PriceAdjustment").val();
		var res=true;
		if(val!=null && val!=''){
			if(isNaN(val)){
				alert('必须输入数字！');
				$("#PriceAdjustment").val('')
				res=false;
			}
		}
		if (step==2 && val!='' && val!='0' && !isNaN(val))
		{	
			if($("#AdjustmentReason").val()==null || $("#AdjustmentReason").val()==''){
				alert('必须填写Price Adjustment 的备注');
				$("#AdjustmentReason").focus();
				res=false;
			}
		}
		return res;
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
	function  clearWarranty()
	{
		if($("#ewbp").val()==0)
		{
			$("#ewbpyear").val('0');
			$("#ewbpunitcost").val('0');
			$("#ewbpprice").val('0');
		}
	}
	function  clearSpecWarranty()
	{
		if($("#sewbp").val()==0)
		{
			$("#sewbpyear").val('0');
			$("#sewbpunitcost").val('0');
			$("#sewbpprice").val('0');
		}
	}
	function closeWindow()
	{
		if(!confirm("是否确定不保存修改？"))
		{
			return;
		}
		window.close();
	}
	huchi_flag=false;
	function huchi(ismsg){
			//philips可选件
		var opts='';
		if ($("input:checkbox[name='pdid_opts']").size()==0)
		{
			return;
		}
		$("input:checkbox[name='pdid_opts']").each(function(index){
			if(index==0){
				opts=$(this).val();
			}else{
				opts=opts+","+$(this).val();
			}
			$("#opts").val(opts);
		});
		if (opts!='')
		{
			var s_config='';
			$("input:hidden[name='opt_isConfig']").each(function(idx){
				if (s_config!='')
				{
					s_config=s_config+","+$(this).val();
				}else{
					s_config=$(this).val();
				}
				
			});
		
			$.post("mutex.asp",{opts:opts,opt_isConfig:s_config,pid:$("#pid").val()},function(data){
				if(data!=null && data!='')
				{
					if(ismsg==1)
					{
						alert(data+"互斥，请重新选择");
					}
					huchi_flag=true;
				}else{
					huchi_flag=false;
				}
			});
			
		}
	}
</script>
</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" scroll="auto">
<form action="quotationSave.asp" method="post">
<input type="hidden" name="isawokeProvision"  id="isawokeProvision" value="0">
<input type="hidden" name="curRate" id="curRate" value="<%=curRate%>">
<input type="hidden" name="currencycode" id="currencycode" value="<%=currencycode%>">
<input type="hidden" name="currencyrate" id="currencyrate" value="<%=currencyrate%>">
<input type="hidden" name="qid" value="<%=qid%>">
<input type="hidden" name="pid" id="pid" value="<%=pid%>">
<input type="hidden" name="qdid" value="<%=qdid%>">
<input type="hidden" name="bu" id="bu" value="<%=rs5("bu")%>">
<input type="hidden" name="must_ids" id="must_ids">
<input type="hidden" name="opts" id="opts">
<input type="hidden" name="thr_must_ids" id="thr_must_ids">
<input type="hidden" name="thr_opts" id="thr_opts">
<!--t5,净目标价-->
<input type="hidden" name="part1" id="part1">  
<!--t10,Total Cost,第3方总价-->   
<input type="hidden" name="part2" id="part2">
<!--t11，Total Amount，provision总价-->  
<input type="hidden" name="part3" id="part3">
<!--不包含选件价格的总价--> 
<input type="hidden" name="part4" id="part4" value="0">
<input type="hidden" name="part5" id="part5">
<!--标准价-->
<input type="hidden" name="stdPrice" id="stdPrice" value="<%=stdPrice%>">
<div align="center">
  <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td><table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td class="titleorange"><div align="center">Edit Configurations<br><%=productname%>
			</div></td>
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
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td align="center">
<table width="95%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line02"> 
                  <td width="10%">Promotion Plan</td>
                  <td width="25%"  align="left">&nbsp;<%=PromotionPlan%></td>
                </tr>
				 <tr class="line02"> 
                  <td width="10%">Price Adjustment<br>
				 <font color="red"> Promotion Plan Adjustment Only！</font>
				  </td>
                  <td width="25%" align="left"><input type="text" name="PriceAdjustment" id="PriceAdjustment" value="<%=PriceAdjustment%>" onchange="checkAdjust(1);">
				   <br><font color="red">针对Promotion的手动调整.请注意：OIT时会检查该调整的有效性 无效调整将无法进单. 必须填写调整理由 .</font>
				  </td>
                </tr>
				 <tr class="line02"> 
                  <td width="10%">Reason For Price Adjustment</td>
                  <td width="25%"  align="left"><input type="text" name="AdjustmentReason" id="AdjustmentReason" value="<%=AdjustmentReason%>" size="50" maxlength="80">
				  </td>
                </tr>
              </table>
			  </td>
    </tr>
	<tr name="configs" id="configs">
	<td>
	<table align="center" width="100%">
		   <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr > 
      <td><table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td class="line01">Part I : Philips Product Net Target Price<br>飞利浦产品净目标价
			</td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td valign="top">
<table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                            <td width="5%">No.</td>
                            <td width="12%">Article No</td>
                            <td width="48%">Article Description</td>
                  <td width="5%">Quantity</td>
                            <td width="15%">List Price</td>
                            <td width="15%">Total List Price</td> 
                </tr>
				<% 
				dim i1
				i1=1
				while not rs1.eof %>
				
                <tr class="line02"> 
                  <td><% If IsNull(rs1("mutex")) Or rs1("mutex")="" Then
							response.write(i1)%>
<input type="hidden" name="pdid_musts" value="<%=rs1("pdid")%>">
							<%
					End if
				  %>
				  <%
					Dim ischk,nowmutex,oldmutex
					 If Not IsNull(rs1("mutex")) And rs1("mutex")<>"" Then
					 nowmutex=rs1("mutex")
					 If nowmutex<> oldmutex Then
						ischk="checked"
						oldmutex=nowmutex
					Else 
						ischk=""
					 End If
					 If Not IsNull(rs1("pd")) And rs1("pd")<>"" Then
						ischk="checked"
					 End if
				 %>
					替换件<%=rs1("mutex")%><input type='radio' name='pdid_musts<%=rs1("mutex")%>' <%=ischk%> value="<%=rs1("pdid")%>">
				<%
					 End if
				  %>
				  </td>
                  <td><%=rs1("materialno")%>&nbsp;</td>
                  <td><%=rs1("description")%>&nbsp;</td>
                  <td><%=rs1("qty")%>&nbsp;
				  <input type="hidden" name="must_qty" value="<%=rs1("qty")%>">
				  </td>
                  <td><%=clng(rs1("listprice"))%>&nbsp;
				  <input type="hidden" name="must_lp" value="<%=clng(rs1("listprice"))%>">
				  </td>
				
                  <td>
				  <%
				  	 tp=rs1("listprice")
					 if isnull(tp) or tp="" then
					 	tp=0
					 end if
					 qp=clng(tp)*cint(rs1("qty"))
				  %>
				  <%=clng(qp)%>&nbsp;
				  <input type="hidden" name="must_qp" value="<%=qp%>">
				  </td>
			
                </tr>
				<%
					rs1.movenext
					i1=i1+1
					wend
				%>
				
              </table></td>
          </tr>
        </table></td>
    </tr>



	 <tr > 
      <td><table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td class="line01">Standard 3rd Party Products <br>标准第三方产品</td>
          </tr>
          <tr> 
            <td><table width="100%"  border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                            <td width="5%">No.</td>
                            <td width="12%" >Product Code</td>
                            <td width="48%">Product Name</td>
                            <td width="5%">Quantity</td>
                            <td width="15%">Unit Cost</td>
                            <td width="15%">Total Cost</td>
                </tr>
				<%
					i3=1
					while not rs3.eof
				%>
                <tr class="line02" > 
                  <td>
				  <% If IsNull(rs3("mutex")) Or rs3("mutex")="" Then
							response.write(i3)%>
<input type="hidden" name="thr_musts" value="<%=rs3("pdid")%>">
							<%
					End if
				  %>
				   <%
					Dim optischk,optnowmutex,optoldmutex
					 If Not IsNull(rs3("mutex")) And rs3("mutex")<>"" Then
					 optnowmutex=rs3("mutex")
					 If optnowmutex<> optoldmutex Then
						optischk="checked"
						optoldmutex=optnowmutex
					Else 
						optischk=""
					 End If
					 If Not IsNull(rs3("pd")) And rs3("pd")<>"" Then
						optischk="checked"
					 End if
				 %>
					替换件<%=rs3("mutex")%><input type='radio' name='thr_musts<%=rs3("mutex")%>' <%=optischk%> value="<%=rs3("pdid")%>">
				<%
					 End if
				  %>
                            </td>
                            <td><%=rs3("materialno")%>&nbsp; </td>
                            <td><%=rs3("itemname")%>&nbsp; </td>
                            <td><%=rs3("qty")%> &nbsp; <input type="hidden" name="thr_must_qty" value="<%=rs3("qty")%> "> 
                            </td>
                            <% if currencycode=CURRENCY_CHINA then
				  			unitcost=rs3("unitcostrmb")
					else
						unitcost=rs3("unitcost")*currencyrate
				  	end if
					
					if isnull(unitcost) or unitcost="" then
						unitcost=0
					end If
					
					unitcost=CLng(unitcost)
				  %>
                            <td><%=unitcost%>&nbsp; <input type="hidden" name="thr_must_lp" value="<%=clng(rs3("unitcost"))%>"> 
                            </td>
                            <td> 
                              <%
				  	 
					 tqp=unitcost*cint(rs3("qty"))
				  %>
                              <%=clng(tqp)%></td>
                </tr>
				
				<% 
				rs3.movenext
				i3=i3+1
				wend
				%>

				<tr>
                            <td colspan="6">&nbsp;</td>
				</tr>
				   <tr  class="line01" > 
                            <td colspan="5">Standard Net Target Price<br>
                              标准配置净目标价&nbsp; </td>
                            <td id="t1" colspan="1">&nbsp;<%=stdPrice%> </td>
                          </tr>
                        </table></td>
          </tr>
        </table></td>
    </tr>


    <tr > 
      <td><table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
	   <tr> 
            <td class="line01">Options <br>选件 
			<br>
			以下选件不包含在“Standard Configuration”中，以下选件价格不包含在“Standard Net Target Price”中！
			</td>
          </tr>
          <tr> 
            <td><table width="100%" id="opt_table" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                            <td width="3%" height="20">&nbsp;</td>
                  <td width="5%">No.</td>
                  <td width="12%">Content</td>
                  <td width="12%">Article No</td>
                  <td width="33%">Article Description</td>
                  <td width="5%">Quantity</td>
                            <td width="15%">List Price</td>
                  <td width="15%">Target Price</td>
                </tr>
				<% 
					i=1
					while not rs2.eof
					pdid=rs2("pdid")
					bgcolor=""
					titleMsg=""
					res= getPhilipsOption(pid,bu,rs2("materialno"),rs2("listprice"),currencyrate,rs2("items"))
					If res<>"0" Then
						bgcolor="red"
						If res="1" Then
							titleMsg=titleMsg1
						ElseIf res="4" Then
							titleMsg=titleMsg1
						ElseIf res="5" Then
							titleMsg=titleMsg2
						End if
					End if
				%>
				<tr class="line02" bgcolor="<%=bgcolor%>" title="<%=titleMsg%>">
				<%
					If bgcolor<>"" Then
						response.write("<input type='hidden' name='mustDueWith'>")
					End if
				%>
				            <td>
<input type='checkbox' name='pdid_opts' value='<%=pdid%>'>
                              &nbsp; 
				 <input type="hidden" name="opt_isConfig" value="1">
				 </td>
                            <td><%=i%></td>
                            <td><%=rs2("items")%>&nbsp;</td>
                            <td><%=rs2("materialno")%>&nbsp;</td>
                            <td><%=rs2("description")%>&nbsp;</td>
                            <td><%=rs2("qty")%>
<input type='hidden' name='opt_qty' value='<%=rs2("qty")%>'>
                              &nbsp;</td>
                            <td><%=CLng(rs2("listprice"))*rs2("qty") %>
<input type='hidden' name='opt_lp' value='<%=rs2("listprice")%>'>
                              &nbsp;</td>
                  <td width="15%"><%=CLng(rs2("quotedprice"))%><input type='hidden' name='opt_qp' value='<%=rs2("quotedprice")%>'>&nbsp;</td>
				  </tr>
				<%
					i=i+1
					rs2.movenext
					wend 
				%>

				<% 
					while not rs8.eof
					pdid=rs8("cid")
					bgcolor=""
					titleMsg=""
					res=getPhilipsOtherOption(rs8("materialno"),bu,rs8("targetprice"),currencyrate,rs8("discount"))
					If res="1"  Then
						bgcolor="red"
						titleMsg=titleMsg1
					ElseIf res="2" Then
						bgcolor="red"
						titleMsg=titleMsg2
					End if
				%>
				<tr class="line02" bgcolor="<%=bgcolor%>"  title="<%=titleMsg%>">
				<%
					If bgcolor<>"" Then
						response.write("<input type='hidden' name='mustDueWith'>")
					End if
				%>
				            <td>
<input type='checkbox' name='pdid_opts' value='<%=pdid%>'>
                              &nbsp; 
				 <input type="hidden" name="opt_isConfig" value="0">
				 </td>
                            <td><%=i%></td>
                            <td><%=rs8("items")%>&nbsp;</td>
                            <td><%=rs8("materialno")%>&nbsp;</td>
                            <td><%=rs8("description")%>&nbsp;</td>
                            <td><%=rs8("qty")%>
<input type='hidden' name='opt_qty' value='<%=rs8("qty")%>'>
                              &nbsp;</td>
                            <td><%=CLng(rs8("listprice"))*rs8("qty") %>
<input type='hidden' name='opt_lp' value='<%=rs8("listprice")%>'>
                              &nbsp;</td>
                  <td width="15%"><%=CLng(rs8("quotedprice"))%><input type='hidden' name='opt_qp' value='<%=rs8("quotedprice")%>'>&nbsp;</td>
				  </tr>
				<%
					i=i+1
					rs8.movenext
					wend 
				%>

				    <tr class="line01"> 
                  <td colspan="7">Option Target Price<br>选件目标价</td>
                  <td id="t2"  colspan="1">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="8"><div align="right"> 
                      <input type="button" name="Submit2" value="Key Options" onClick="selectStdConfigs('<%=pid%>');">
                      &nbsp;&nbsp; 
					    <input type="button" name="Submit2" value="Other Options" onClick="selectOtherStdConfigs('<%=pid%>');">
                      &nbsp;&nbsp; 
                      <input type="button" name="Submit2" value="Delete" onClick="delRow();">
                      &nbsp;&nbsp; &nbsp;&nbsp; </div></td>
                </tr>
				<%
					dim roleid
					roleid=session("roleid")
					if 1=2 then
					'if isnull(roleid) or trim(roleid)="1" or trim(roleid)="4" or trim(roleid)="6" then
				%>
				<script>
					needto=0;
				</script>
                <tr class="line01"> 
                  <td  colspan="6"> Sub-total</td>
                  <td id="t3"  colspan="2">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="8">&nbsp;</td>
                </tr>
				<% end if %>
              </table></td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr > 
      <td>&nbsp;</td>
    </tr>
    <tr > 
      <td><table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td><table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                            <td width="5%">No.</td>
                            <td width="80%">Other Direct Cost<br>
                              其他直接成本</td>
                  <td width="20%">&nbsp;</td>
				  <!--
                  <td width="24%">Charged %</td>
                  <td width="16%">Amount</td>
				   -->
                </tr>
				<input type="hidden" name="ficharged" id="ficharged">
				<input type="hidden" name="fiamount" id="fiamount">
				<input type="hidden" name="ibpcharged" id="ibpcharged">
				<input type="hidden" name="ibpamount" id="ibpamount">
				<input type="hidden" name="atamount" id="atamount">
				<input type="hidden" name="sbpcharged" id="sbpcharged">
				<input type="hidden" name="sbpamount" id="sbpamount">
                <tr class="line02"> 
                  <td>1</td>
                  <td>Freight &amp; Insurance<br>运费&amp;保险费 </td>
                            <td width="15%">&nbsp; 
                              <%
				 	if isfreight="0" or isnull(isfreight) then
						response.Write("无")
					else
						response.Write("有")
					end if
				 %>
				  <!--
				  <select name="fi" id="fi" onChange="calcSum();">
				  	<% for i=1 to ubound(FI_TYPE) %>
                      <option value="<%=FI_TYPE(i,0)%>"><%=FI_TYPE(i,1)%></option>
					 <% next %>
                    </select>
					-->
					</td>
					<!--
                  <td id="p1">&nbsp;</td>
                  <td id="t6">&nbsp;</td>
				  -->
                </tr>
                <tr class="line02"> 
                  <td>2</td>
                  <td>Installation By Philips<br>飞利浦安装成本</td>
                  <td>&nbsp;
				  <%
				  	if inst="0" or isnull(inst) then
						response.Write("无")
					end if
					if inst="1" then
						response.Write("有")
					end if
				  %>
				  <!--
				  <select name="ibps" id="ibps" onChange="calcSum();">
                      <option value="1">Yes</option>
                      <option value="0">No</option>
                    </select>
					-->
					</td>
				<!--
                  <td id="p2">&nbsp;</td>
                  <td id="t7">&nbsp;</td>
				 -->
                </tr>
                <tr class="line02"> 
                  <td>3</td>
                  <td>Application Training<br>应用培训成本</td>
                  <td>&nbsp;
				    <%
				  	if appcost<>"0" then
						response.Write("有")
					end if
					if appcost="0" or isnull(appcost) then
						response.Write("无")
					end if
				  %>
				  </td>
					<!--
                  <td>&nbsp;</td>
                  <td id="t8">&nbsp; </td>
				  -->
                </tr>
                <tr class="line02"> 
                  <td>4</td>
                  <td>Standard warranty By Philips<br>飞利浦标准保修费</td>
                  <td>&nbsp;
				      <%
				  	if warrcost<>"0" then
						response.Write("有")
					end if
					if warrcost="0" or isnull(warrcost) then
						response.Write("无")
					end if
					%>
				 <!--
				  <select name="swbps" id="swbps" onChange="calcSum();">
                      <option value="1">Yes</option>
                      <option value="0">No</option>
                    </select>
					-->
					</td>
					<!--
                  <td id="p3">&nbsp;</td>
                  <td id="t9">&nbsp;</td>
				 -->
                </tr>
               <!--
                <tr class="line01"> 
                  <td>&nbsp;</td>
                  <td>Sub-total</td>
				    -->
				  <!--
                  <td><br></td>
                  <td>&nbsp;</td>
				  -->
				   <!--
                  <td id="t4">&nbsp;</td>
                </tr>
				-->
              </table></td>
          </tr>
        </table></td>
    </tr>

   <tr > 
      <td>&nbsp;</td>
    </tr>
 <tr > 
      <td><table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td><table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line_subtotal"> 
                  <td colspan="2">Philips Product Net Target Price<br>净目标价</td>
                  <td id="t5">&nbsp;</td>
                </tr>
              </table></td>
          </tr>
        </table></td>
    </tr>


    <tr > 
      <td>&nbsp;</td>
    </tr>
    <tr > 
      <td><table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td class="line01">Part II : 3rd party items<br>第三方产品成本</td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td><table width="100%" id="thr_table" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td width="3%">&nbsp;</td>
                            <td width="5%">No.</td>
				            <td width="12%">Product Code</td>
                            <td width="45%">Product Name</td>
                            <td width="5%">Quantity</td>
                            <td width="15%">Unit Cost</td>
                            <td width="15%">Total Cost</td>
                </tr>
	
			
				<%
					i3=1
					while not rs4.eof
					bgcolor=""
					titleMsg=""
					showprice=rs4("unitcost")
					If currencycode=CURRENCY_CHINA Then
						If IsNull(rs4("oldunitcostrmb")) Or rs4("oldunitcostrmb")=""Then
							bgcolor="red"
							titleMsg=titleMsg1
						Else
							If   rs4("unitcost")<>CLng(rs4("oldunitcostrmb"))  Then
								bgcolor="red"
								showprice=CLng(rs4("oldunitcostrmb"))
								titleMsg=titleMsg2
							End if
						End if
					Else
						If IsNull(rs4("oldunitcost")) Or  rs4("oldunitcost")=""  Then
							bgcolor="red"
							titleMsg=titleMsg1
						Else
							If rs4("unitcost")<>CLng(rs4("oldunitcost")*currencyrate) Then
								bgcolor="red"
								showprice=CLng(rs4("oldunitcost")*currencyrate)
								titleMsg=titleMsg2
							End if
						End if
					End if
				%>
                <tr class="line02" bgcolor="<%=bgcolor%>" title="<%=titleMsg%>"> 
				<%
					If bgcolor<>"" Then
						response.write("<input type='hidden' name='mustDueWith'>")
					End if
				%>
                  <td>&nbsp;
				  <% 
				  '可选配件
				  if rs4("pdid")="0" and rs4("type")="1" and  rs4("partytype")="0" then%>
				  	<input type="checkbox" name="thr_pdid_opts" value="<%=rs4("cid")%>"></td>
					<%
					else 
					%>
					 <input type="hidden" name="thr_pdid_opts" value="<%=rs4("cid")%>">
					<%
					end if%>
                  <td><%=i3 %>&nbsp;</td>
                  <td><%=rs4("materialno")%>&nbsp;</td>
				   <td><%=rs4("itemname")%>&nbsp; </td>
                  <td><%=rs4("qty")%><input type='hidden' name='thr_opt_qty' value='<%=rs4("qty")%>' size="3"> &nbsp; 
				  </td>
                  <td><%=rs4("unitcost")%><input type='hidden' name='thr_opt_lp' value='<%=showprice %>'>&nbsp;</td>
                  <td><%=rs4("quotedprice")%><input type='hidden' name='thr_opt_qp' value='<%=rs4("quotedprice")%>'>&nbsp;</td>
                </tr>
					<% 
				rs4.movenext
				i3=i3+1
				wend%>
				
				<%
					while not rs7.eof
				%>
                <tr class="line02"> 
                  <td>&nbsp;
				  	<input type="checkbox" name="thr_var_pdid" value="<%=rs7("cid")%>"></td>
                  <td><%=i3%>&nbsp;</td>
                  <td><input type='text' name='thr_var_materialno' value="<%=rs7("materialno")%>" style="width:100%"></td>
				   <td><input type='text' name='thr_var_itemname' value="<%=rs7("itemname")%>" style="width:100%"></td>
                  <td><input type='text' name='thr_var_qty' value='<%=rs7("qty")%>' onblur='calcThrVar();' size="5"  maxlength="5">
				  </td>
                  <td><input type='text' name='thr_var_lp' value="<%=rs7("unitcost")%>"  onblur='calcThrVar();' size="12" maxlength="12"></td>
                  <td><input type='text' name='thr_var_qp' value='<%=rs7("quotedprice")%>' readonly size="12"></td>
                </tr>
					<% 
				rs7.movenext
				i3=i3+1
				wend%>
                <tr class="line01"> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
				   <td>&nbsp;</td>
                  <td>Site preparation</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td><input type="text" name="site"  id="site" onBlur="chkSite();" value="<%=site%>" size='15'></td>
                </tr>
                <tr class="line_subtotal"> 
                            <td  colspan="6">Subtotal</td>
                  <td id="t10"  colspan="1">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="7"><div align="right"> 
				   	<input type="button" name="Submit2" value="Add Philips 3rd Party" onClick="selectThrConfigs(<%=pid%>);">
                      &nbsp;&nbsp; 
					 <input type="button" name="Submit2" value="Add Non-Philips 3rd Party" onClick="addThrVarRow();">
					&nbsp;&nbsp; 
                      <input type="button" name="Submit2" value="Delete" onClick="delThrRow();">
                      &nbsp;&nbsp; &nbsp;&nbsp; </div></td>
                </tr>
              </table></td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr > 
      <td><table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td class="line01">Part III : Other Provision<br> 其他预留成本</td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td><table width="100%" id="provision_table" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                            <td width="3%">&nbsp;</td>
                            <td width="5%">No.</td>
                            <td width="57%">Description</td>
                            <td width="5%">Quantity</td>
                            <td width="15%">Unit Cost</td>
                            <td width="15%">Total Cost</td>
                </tr>
				<% if rs6.bof and rs6.eof then %>
					   <tr class="line02"> 
                  <td >
				  <!--
				  <input type='checkbox' name='pro_pdid'>
				  -->
				  &nbsp;</td>
                  <td>1</td>
                  <td ><input type='text' name='pro_materialno' value="Inspection Tour（Overseas）" readonly style="width:100%"></td>
                  <td  nowrap="nowrap"><input type='text' name='pro_qty' value="0" onblur='calcProvisionSum();' size='5'>&nbsp;</td>
                  <td  nowrap="nowrap"><input type='text' name='pro_lp' value="0"  size='12' onblur='calcProvisionSum();awokeProvision(this.value);'>&nbsp;</td>
                  <td  nowrap="nowrap"><input type='hidden' name='pro_qp' readonly value="0">&nbsp;</td>
                </tr>
				   <tr class="line02"> 
                  <td>
				  <!--
				  <input type='checkbox' name='pro_pdid'>
				  -->
				  &nbsp;</td>
                  <td >2</td>
                  <td ><input type='text' name='pro_materialno' value="Inspection Tour（Local）" readonly style="width:100%"></td>
                  <td  nowrap="nowrap"><input type='text' name='pro_qty' value="0" onblur='calcProvisionSum();'  size='5'>&nbsp;</td>
                  <td nowrap="nowrap"><input type='text' name='pro_lp' value="0"  size='12' onblur='calcProvisionSum();awokeProvision(this.value);'>&nbsp;</td>
                  <td  nowrap="nowrap"><input type='hidden' name='pro_qp'  readonly value=0"">&nbsp;</td>
                </tr>
			
				   <tr class="line02"> 
                  <td>
				  <!--
				  <input type='checkbox' name='pro_pdid'>
				  -->
				  &nbsp;</td>
                  <td>3</td>
                  <td><input type='text' name='pro_materialno' value="Opening Ceremony" readonly style="width:100%"></td>
                  <td nowrap="nowrap"><input type='text' name='pro_qty' value="0" onblur='calcProvisionSum();'  size='5'>&nbsp;</td>
                  <td nowrap="nowrap"><input type='text' name='pro_lp' value="0"  size='12' onblur='calcProvisionSum();awokeProvision(this.value);'>&nbsp;</td>
                  <td nowrap="nowrap"><input type='hidden' name='pro_qp' readonly value=0"">&nbsp;</td>
                </tr>
				   <tr class="line02"> 
                  <td >
				  <!--
				  <input type='checkbox' name='pro_pdid'>
				  -->
				  &nbsp;</td>
                  <td>4</td>
                  <td ><input type='text' name='pro_materialno' value="Clinical Research" readonly style="width:100%"></td>
                  <td nowrap="nowrap"><input type='text' name='pro_qty' value="0" onblur='calcProvisionSum();'  size='5'>&nbsp;</td>
                  <td nowrap="nowrap"><input type='text' name='pro_lp' value="0"  size='12' onblur='calcProvisionSum();awokeProvision(this.value);'>&nbsp;</td>
                  <td  nowrap="nowrap"><input type='hidden' name='pro_qp' readonly value="0">&nbsp;</td>
                </tr>
				   <tr class="line02"> 
                  <td >
				  <!--
				  <input type='checkbox' name='pro_pdid'>
				  -->
				  &nbsp;</td>
                  <td >5</td>
                  <td ><input type='text' name='pro_materialno' value="Commission"  readonly style="width:100%"></td>
                  <td  nowrap="nowrap"><input type='text' name='pro_qty' value="0" onblur='calcProvisionSum();'  size='5'>&nbsp;</td>
                  <td  nowrap="nowrap"><input type='text' name='pro_lp' value="0"  size='12' onblur='calcProvisionSum();awokeProvision2();'>&nbsp;</td>
                  <td nowrap="nowrap"><input type='hidden' name='pro_qp' readonly value=0"">&nbsp;</td>
                </tr>
		<tr class="line02"> 
                  <td width="8%">
				  <!--
				  <input type='checkbox' name='pro_pdid'>
				  -->
				  &nbsp;</td>
                  <td >6</td>
                  <td  nowrap><input type='text' name='pro_materialno' value="Tender Fee" readonly style="width:100%"></td>
                  <td  nowrap="nowrap"><input type='text' name='pro_qty' value="0" onblur='calcProvisionSum();'  size='5'>&nbsp;</td>
                  <td  nowrap="nowrap"><input type='text' name='pro_lp' value="0" onblur='calcProvisionSum();'  size='12'>&nbsp;</td>
                  <td  nowrap="nowrap"><input type='hidden' name='pro_qp' readonly value="0">&nbsp;</td>
                </tr>
				<% else %>
				<%
					i6=1
					while not rs6.eof 
				%>
					   <tr class="line02"> 
                  <td >
				  <% if i6>6 then%>
				  <input type='checkbox' name='pro_pdid'>
				  <% end if%>
				  &nbsp;</td>
                  <td ><%=i6%></td>
                  <td><input type='text' name='pro_materialno' value="<%=rs6("materialno")%>" 
				    <% if i6<=6 then%>
				 readonly
				  <% end if%>
				   style="width:100%"></td>
                  <td  nowrap="nowrap"><input type='text' name='pro_qty' value="<%=rs6("qty")%>" onblur='calcProvisionSum();'  size='5'>&nbsp;</td>
                  <td  nowrap="nowrap"><input type='text' name='pro_lp'  size='12' value="<%=rs6("unitcost")%>" onblur='calcProvisionSum(); 
				  <% If rs6("materialno")="Commission" Then %>
						awokeProvision2()
				  <% Else   
						If rs6("materialno")<>"Tender Fee" And i6<6  then
				  %>
						awokeProvision(this.value)
				   <% End If
				   End if
				   %>
				  ;'>&nbsp;</td>
                  <td  nowrap="nowrap"><input type='hidden' name='pro_qp' readonly value="<%=rs6("quotedprice")%>">&nbsp;</td>
                </tr>
				<%
					rs6.movenext
					i6=i6+1
					wend
					end if
				%>
   				<tr class="line_subtotal"> 
                            <td colspan="5">Subtotal</td>
                  <td id="t11"  colspan="1">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="6"><div align="right"> 
                      <input type="button" name="Submit2" value="Add New" onClick="addProvisionRow();">
                      &nbsp;&nbsp; 
                      <input type="button" name="Submit2" value="Delete" onClick="delProvisionRow();">
                      &nbsp;&nbsp; &nbsp;&nbsp; </div></td>
                </tr>
              </table></td>
          </tr>
        </table></td>
    </tr>
    <tr > 
      <td>&nbsp;</td>
    </tr>
    <tr > 
      <td>&nbsp;</td>
    </tr>
    <tr > 
      <td><table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td class="line01">Part IV : Philips Non-standard Warranty<br> 飞利浦非标准保修</td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td><table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                            <td width="30%">Philips Extended Warranty:<br>
                              飞利浦延长保修费：</td>
                  <td width="10%"><select name="ewbp" id="ewbp" onchange="clearWarranty();">
                      <option value="1" selected>Yes</option>
                      <option value="0">No</option>
                    </select></td>
                  <td width="20%"><input name="ewbpyear" id="ewbpyear" type="text" size="5" value="<%=ewbpyear%>" >
                    Year</td>
				<!--  <td width="20%"><input name="ewbpunitcost" id="ewbpunitcost" type="text" size="12" maxlength="12" value="<%=ewbpunitcost%>"  onchange="calcWarr();">Unit Cost</td>
				-->
                  <td width="20%"><input name="ewbpprice" id="ewbpprice" type="text" size="12" maxlength="12" value="<%=ewbpprice%>" >Total Cost</td>
                </tr>
				 <tr class="line01"> 
                  <td width="30%">Special Warranty Terms in <br>
                              Standard Warranty Period:<br>
                              飞利浦标准保修期内的特殊要求：</td>
                  <td width="10%"><select name="sewbp" id="sewbp"  onchange="clearSpecWarranty();">
                      <option value="1" selected>Yes</option>
                      <option value="0">No</option>
                    </select></td>
                  <td width="20%"><input name="sewbpyear" id="sewbpyear" type="text" size="5" value="<%=sewbpyear%>" >
                    Year</td>
				<!--
				<td width="20%"><input name="sewbpunitcost" id="sewbpunitcost" type="text" size="12"  maxlength="12"  value="<%=sewbpunitcost%>"  onchange="calcWarr();">Unit Cost</td>
				-->
                  <td width="20%"><input name="sewbpprice" id="sewbpprice" type="text" size="12"  maxlength="12"  value="<%=sewbpprice%>" >Total Cost</td>
                </tr>
                <tr class="line01"> 
                            <td>Comments:<br>
                              备注：</td>
                  <td colspan="4"><input name="comments" type="text" size="80" value="<%=comments%>" style="width:100%"></td>
                </tr>
                <tr> 
                  <td colspan="5"><div align="right"> 
                      <input type="button" name="Submit2" value="Save" onClick="doSubmit();">
					   <input type="button" name="Submit2" value="Close" onClick="closeWindow();">
					   </div></td>
                </tr>
              </table></td>
          </tr>
        </table></td>
    </tr>
   		</table>
		</td>
		</tr>
  </table>
   <!--#include file="../footer.asp"-->
</div>
</form>
<script>
	//当编辑的时候初始化页面的下拉框
	$("#ewbp").val("<%=ewbp%>");
	$("#sewbp").val("<%=sewbp%>");
	$("#fi").val("<%=fi%>");
	$("#ibps").val("<%=ibp%>");
	$("#swbps").val("<%=sbp%>");
	
	calcSum();
	calcThrSum();
	calcProvisionSum();
</script>
</body>
</html>
<%
	if isclose then
		rs.close
		set rs=nothing
		rs1.close
		set rs1=nothing
		rs2.close
		set rs2=nothing
		rs3.close
		set rs3=nothing
		rs4.close
		set rs4=nothing
		rs5.close
		set rs5=nothing
		rs6.close
		set rs6=nothing
		rs7.close
		set rs7=Nothing
		rs8.close
		set rs8=Nothing
		
		rsNewProd.close
		Set rsNewProd=Nothing
	end if
		CloseDatabase
%>
