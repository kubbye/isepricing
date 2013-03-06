<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/commons.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/constant.asp"-->

<%
	Dim sid,qid,roleid
	sid=request("sid")
	qid=request("qid")
	roleid=session("roleid")

	Dim ewbpcost,sewbpcost,thrdtotal,othertotal
	Dim productmodel,hasEsOitprice,hasEsNetprice
	Dim estimated_oitprice
	ewbpcost=0
	sewbpcost=0
	thrdtotal=0
	othertotal=0
	hasEsOitprice=0
	hasEsNetprice=0
	estimated_oitprice=0
	If IsNull(sid) Or sid="" Then
		sid=0
	End If

	'sid=0,表示新增
	sql="select * from special_price where id="&sid
	Set rs=conn.execute(sql)
	If Not rs.eof And Not rs.bof then
		productmodel=rs("productmodel")
		spStatus=rs("status")
		estimated_oitprice=rs("estimated_oitprice")
	End if
	sql="select a.* ,(select isnull(sum(part1),0)+isnull(sum(adjustprice),0) from quotation_detail where qid=a.qid ) standardprice from quotation a where qid="&qid 
	'查询quotation
	Set rs1=conn.execute(sql)
	'查询产品详细
	Set rs2=conn.execute("select a.*,b.estimateprice,b.estmateStandardPrice,b.estmateDiscount from quotation_detail a left join special_detail b on a.qdid=b.qdid where qid="&qid &" order by a.productname,a.qdid")
	'查询产品数量
	Set rs3=conn.execute("select count(*) as cnt from quotation_detail where qid="&qid)
	Dim cnt
	cnt=rs3("cnt")
	redim arr(cnt,11)
	Dim i
	i=1

	While  Not rs2.eof 
		k=0
		arr(i,k)=rs2("productname")
		k=k+1  '1
		arr(i,k)=rs2("targetprice")
		k=k+1   '2
		arr(i,k)=rs2("part1")
		k=k+1   '3
		arr(i,k)=rs2("ewbpprice")
		ewbpcost=ewbpcost+rs2("ewbpprice")
		k=k+1   '4
		arr(i,k)=rs2("sewbpprice")
		sewbpcost=sewbpcost+rs2("sewbpprice")
		k=k+1   '5
		arr(i,k)=rs2("part2")
		k=k+1   '6
		arr(i,k)=rs2("part3")
		k=k+1   '7
		arr(i,k)=rs2("part4")
		k=k+1   '8  qdid
		arr(i,k)=rs2("qdid")
		k=k+1   '9  split_oitprice
		arr(i,k)=rs2("estimateprice")
		hasEsOitprice=hasEsOitprice+rs2("estimateprice")
		k=k+1   '10  split_sdoitprice
		arr(i,k)=rs2("estmateStandardPrice")
		hasEsNetprice=hasEsNetprice+rs2("estmateStandardPrice")
		k=k+1   '11  split_discount
		arr(i,k)=rs2("estmateDiscount")
		rs2.movenext
		i=i+1
	Wend
	
	'查询第3方得所有备件
	Set rs4=conn.execute("select  itemname,sum(quotedprice) quotedprice from quotation_detail_3rd where qdid in(select qdid from quotation_detail where qid="&qid&") and type!=0 group by itemname order by itemname")
	
	'查询other provision得所有备件
	Set rs5=conn.execute("select  materialno,sum(quotedprice) quotedprice from quotation_detail_provision where qdid in(select qdid from quotation_detail where qid="&qid&") group by materialno order by  (select case materialno when 'Inspection Tour（Overseas）' then 1 when 'Inspection Tour（Local）' then 2 when 'Opening ceremony' then 3 when 'Clinical research' then 4 when 'Commission' then 5 when 'Tender fee' then 6 else 7 end)")

	'查询已拆分的特价
	If sid<>"0" Then
		
	End If
	

	'定义第3方产品的总价
	'是否显示拆分
	isshowsplit=False
	 If (roleid="1" And productmodel=2) Or (roleid="3" And productmodel=1 And rs1("prodcnt")>1) Then
		isshowsplit=true
	 End If 
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title>IS E-pricing system</title>
<LINK href="../css/css.css" type=text/css rel=stylesheet>
<script type="text/javascript" src="../js/ut.js"></script>
<script type="text/javascript" src="../js/jquery-1.2.6.js"></script>
<script>
	function quotationDetail(id)
	{
		window.open("../quotation/quotationDetail.asp?qid="+id+"&rtype=3",'','width=1024,height=768,scrollbars=yes,toolbar=no,resizable=yes');
	}

	//拆分的价格
	function calcSplit(val,id,oitprice,sdprice)
	{
		if(val==null || val==''){
			return;
		}
		if(isNaN(val)){
			alert('请输入数字');
			return false;
		}
		var splitSd=val-(oitprice-sdprice);
		var splitDiscount;
		splitDiscount=(splitSd-sdprice)*100*10/sdprice;
		splitDiscount=formatNumber(splitDiscount,'123456789.00');
		splitDiscount=Math.round(splitDiscount)/10;
		$("#splitSd"+id).val(splitSd);
		$("#splitDiscount"+id).val(splitDiscount);

		calcSplitSum();
	}
	function calcSplitSum()
	{
		var f=document.forms[0];
		var oitsum=0;
		var netprice=0;
		for(var i=0;i<f.elements.length;i++)
		{
			var e=f.elements[i];
			if(e.name.indexOf("splitOit")==0){
				if(e.value!=null && e.value!='')
				{
					oitsum=oitsum+parseInt(e.value);
				}
			}
			if(e.name.indexOf("splitSd")==0){
				if(e.value!=null && e.value!=''){
					if(!isNaN(e.value)){
						netprice=netprice+parseInt(e.value);
					}
				}
			}
		}
		$("#label1").text(oitsum);
		$("#label2").text(netprice);
	}
	function saveSplit()
	{
		var cs=$("#label1").text();
		var ts=<%=estimated_oitprice%>;
		if(cs==null || cs=='')
		{
			cs=0;
		}
		if(cs!=ts)
		{
			if(!confirm("拆分的总价与预估的总价不符,确定要保存吗?"))
			{
				return;
			}
		}
		var f=document.forms[0];
		f.submit();
	}
	function closeWindow()
	{
		if(document.getElementById("div_esoitprice"))
		{
			if(!confirm("您确定不保存修改？"))
			{
				return;
			}
		}
		window.close();
	}
</script>
</head>

<body bgcolor="#ffffff" leftmargin="0" topmargin="0" scroll="auto">
<form action="special_split.asp" method="post">
<input type="hidden" name="sid" value="<%=sid%>">
<input type="hidden" name="qid"  value="<%=qid%>">
<div align="center">
  <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td><table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td class="titleorange"><div align="center">Supporting Information for Special Price Application
                </div></td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td><table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td width="28%"> <div align="left">Quotation NO: 报价文件号：<br>
                    </div></td>
                  <td width="20%"> <div align="left"> 
				  <a href="#" onclick="quotationDetail(' <%=rs1("qid")%>');return false;">
                     <%=rs1("quotationno")%>
					 </a>
                    </div></td>
                  <td width="30%">&nbsp;</td>
                  <td width="22%">
				  <% If isshowsplit Then  %>
						拆分的进单价总和：<label id="label1"><%=hasEsOitprice%></label>
						<br>
						拆分的净进单价总和：<label id="label2"><%=hasEsNetprice%></label>
				 <%	End If 
				  %>
				  &nbsp;</td>
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
                    <td height="20">Description</td>
                  <td>Total <br></td>
				 <% for j=1 to ubound(arr) %>
                  <td><%=arr(j,0)%></td>
				  <% Next %>
                </tr>
                <tr class="line01" style="background-Color:lightgreen"> 
                  <td title="等于本单Quotation 的目标价(含净目标价格+第三方产品+其它预留费用+额外保修费用)"><div align="left">Target OIT Price&nbsp;目标进单价<br>
                    </div></td>
                  <td><%=rs1("targetprice")%></td>
				   <% for j=1 to ubound(arr) %>
				     <td><div align="center"><%=arr(j,1)%></div></td>
				  <% Next %>
                
                </tr>
                <tr class="line01"  style="background-Color:lightgreen"> 
                  <td title="等于Philips设备的目标价：Quotation Part I : Philips Product Net Target Price&#13(含净设备价格+标准安装+标准培训+标准保修+Standard 第三方)"><div align="left">Equipment Net Target Price&nbsp;净目标价格</div></td>
                  <td><%=rs1("standardprice")%></td>
                   <% for j=1 to ubound(arr) %>
				     <td><div align="center"><%=arr(j,2)%></div></td>
				  <% Next %>
                </tr>
<% If isshowsplit And spStatus<>11 then%>
	    <tr class="line01"> 
                  <td  title="请填写 &#13等于本单预估的进单价"><div align="left"  id="div_esoitprice">Estimated OIT Price Breakdown 
预估的进单价拆分	
<br>
                    </div></td>
                  <td><%=estimated_oitprice%></td>
				   <% for j=1 to ubound(arr) %>
				     <td><div align="center"><input type="text" id="splitOit<%=arr(j,8)%>" name="splitOit<%=arr(j,8)%>" value="<%=arr(j,9)%>" onblur="calcSplit(this.value,'<%=arr(j,8)%>','<%=arr(j,1)%>','<%=arr(j,2)%>');"></div></td>
				  <% Next %>
                
                </tr>
                <tr class="line01"> 
                  <td title="不需填写，自动计算&#13等于Philips设备的预估进单价格(预估进单价—第三方产品—其它预留费用—额外保修费用)"><div align="left">Estimated Net OIT Price 
预估的净进单价拆分	
</div></td>
                  <td><%=rs("estimated_netoitprice")%></td>
                   <% for j=1 to ubound(arr) %>
				     <td><div align="center"><input type="text" id="splitSd<%=arr(j,8)%>" name="splitSd<%=arr(j,8)%>" readonly  value="<%=arr(j,10)%>"></div></td>
				  <% Next %>
                </tr>
				  <tr class="line01"> 
                  <td title="不需填写，自动计算&#13=(预估的净进单价-净目标价格)/(净目标价格)"><div align="left">Special Discount Requested	
&nbsp;特价折扣请求</div></td>
                  <td><%=rs("specialdiscount")%><font color="red">%</font></td>
                   <% for j=1 to ubound(arr) %>
				     <td><div align="center"><input type="text" id="splitDiscount<%=arr(j,8)%>" name="splitDiscount<%=arr(j,8)%>" readonly value="<%=arr(j,11)%>">
					 <font color="red">%</font>
					 </div></td>
				  <% Next %>
                </tr>
<% End If %>
<!-- 所有审批完成的或者fc或者market director可以看到 -->
<% If spStatus=11 Or (roleid=6 And  productmodel=1) Or (productmodel=2 And (roleid=6 Or roleid=4))  then%>
	    <tr class="line01" style="background-Color:yellow"> 
                  <td  title="请填写 &#13等于本单预估的进单价"><div align="left">Estimated OIT Price Breakdown 
预估的进单价拆分	
<br>
                    </div></td>
                  <td><%=estimated_oitprice%></td>
				   <% for j=1 to ubound(arr) %>
				     <td><div align="center"><%=arr(j,9)%>&nbsp;</div></td>
				  <% Next %>
                
                </tr>
                <tr class="line01"> 
                  <td title="不需填写，自动计算&#13等于Philips设备的预估进单价格(预估进单价—第三方产品—其它预留费用—额外保修费用)"><div align="left">Estimated Net OIT Price 
预估的净进单价拆分	
</div></td>
                  <td><%=rs("estimated_netoitprice")%></td>
                   <% for j=1 to ubound(arr) %>
				     <td><div align="center"><%=arr(j,10)%>&nbsp;</div></td>
				  <% Next %>
                </tr>
				  <tr class="line01"> 
                  <td title="不需填写，自动计算&#13=(预估的净进单价-净目标价格)/(净目标价格)"><div align="left">Special Discount Requested	
&nbsp;特价折扣请求</div></td>
                  <td><%=rs("specialdiscount")%><font color="red">%</font></td>
                   <% for j=1 to ubound(arr) %>
				     <td><div align="center"><%=arr(j,11)%>&nbsp;
					 <font color="red">%</font>
					 </div></td>
				  <% Next %>
                </tr>
<% End If %>


                <tr class="line01"> 
                  <td><div align="left">Subtotal 3rd Party Items&nbsp;第3方产品</div></td>
                  <td ><label id="3rdTotal"></label>&nbsp;</td>
                 <% for j=1 to ubound(arr) %>
				     <td><%=arr(j,5) %>&nbsp;</td>
				  <% Next %>
                </tr>
				<%
				While Not rs4.eof
					thrdtotal=thrdtotal+CLng(rs4("quotedprice"))
				%>
			
					  <tr class="line02"> 
                  <td><div align="left"><%=rs4("itemname")%></div></td>
				     <td><%=CLng(rs4("quotedprice"))%>&nbsp;</td>
                  <%  
				  for j=1 to ubound(arr)
						sql="select   isnull(sum(a.quotedprice),0) quotedprice from quotation_detail_3rd a ,quotation_detail b where a.qdid=b.qdid and a.qdid in(select qdid from quotation_detail where qid="&qid&") and a.itemname='"&porcSpecWord(rs4("itemname"))&"' and a.qdid='"&arr(j,8)&"' and b.productname='"&porcSpecWord(arr(j,0))&"'"
						Set rs_productprice=conn.execute(sql)
						nowprice="-"
						If rs_productprice.bof And rs_productprice.eof Then
							nowprice="-"
						Else
							nowprice=CLng(rs_productprice("quotedprice"))
						End If
						If nowprice="0" Then
							nowprice="-"
						End If
						rs_productprice.close
						Set rs_productprice=nothing
				  %>
					<td><div align="center"><%=nowprice%>&nbsp;</div></td>
						
				 <% Next %>
				   </tr>
			<% 
				rs4.movenext
				Wend
			%>
               <tr class="line01"> 
                  <td><div align="left">Subtotal Other Provision&nbsp;其他预留成本<br>
                    </div></td>
                  <td><label id="otherTotal"></label>&nbsp;</td>
				 <% for j=1 to ubound(arr) %>
				     <td><%=arr(j,6)%>&nbsp;</td>
				  <% Next %>
                </tr>
				<% While Not rs5.eof
					othertotal=othertotal+CLng(rs5("quotedprice"))
				%>
                <tr class="line02"> 
                  <td><div align="left"><%=rs5("materialno")%>&nbsp;</div></td>
                  <td><%=CLng(rs5("quotedprice"))%>&nbsp;</td>
                 <% for j=1 to ubound(arr)
						sql="select   isnull(sum(a.quotedprice),0) quotedprice from quotation_detail_provision a ,quotation_detail b where a.qdid=b.qdid and a.qdid in(select qdid from quotation_detail where qid="&qid&") and a.materialno='"&porcSpecWord(rs5("materialno"))&"' and a.qdid='"&arr(j,8)&"' and b.productname='"&porcSpecWord(arr(j,0))&"'"
						Set rs_productprice=conn.execute(sql)
						nowprice="-"
						If rs_productprice.bof And rs_productprice.eof Then
							nowprice="-"
						Else
							nowprice=CLng(rs_productprice("quotedprice"))
						End If
						If nowprice="0" Then
							nowprice="-"
						End If
						rs_productprice.close
						Set rs_productprice=nothing
				 %>
					<td> <div align="center"><%=nowprice%>&nbsp;</div></td>
				 <%
					next
				  %>
                </tr>
               <%
					rs5.movenext
					wend
			   %>
                <tr class="line01"> 
                  <td height="19"> <div align="left">Subtotal Non-standard Warranty &nbsp;飞利浦非标准保修
                    </div></td>
                  <td><label id="warr"><%=ewbpcost+sewbpcost%></label>&nbsp;</td>
                <% for j=1 to ubound(arr) %>
				     <td><%=arr(j,7)%>&nbsp;</td>
				  <% Next %>
                </tr>
                <tr class="line02"> 
                  <td><div align="left">Extended Warranty by Philips</div></td>
                  <td><%=ewbpcost%>&nbsp;</td>
                  <% for j=1 to ubound(arr) %>
                  <td><%=arr(j,3)%></td>
				  <% Next %>
                </tr>
                <tr class="line02"> 
                  <td><div align="left">Special Warranty Terms in Standard Warranty Period</div></td>
                  <td><%=sewbpcost%>&nbsp;</td>
                  <% for j=1 to ubound(arr) %>
                  <td><%=arr(j,4)%></td>
				  <% Next %>
                </tr>
              </table></td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td><div align="right">
	  <% If isshowsplit And spStatus<>11 Then %>
		<input type="button" name="Submit" value="Save" onclick="saveSplit();">&nbsp;&nbsp;
	  <% End If %>
          <input type="button" name="Submit" value="Close" onclick="closeWindow();">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        </div></td>
    </tr>
	</table>
      <!--#include file="../footer.asp"-->
</div>
<script>
	$("#3rdTotal").text('<%=thrdtotal%>');
	$("#otherTotal").text('<%=othertotal%>');


</script>
</form>
</body>
</html>
<%
	rs.close
	Set rs=Nothing
	rs1.close
	Set rs1=Nothing
	rs2.close
	Set rs2=Nothing
	rs3.close
	Set rs3=Nothing
	rs4.close
	Set rs4=Nothing
	rs5.close
	Set rs5=Nothing

	'关闭数据库连接
	CloseDatabase
%>