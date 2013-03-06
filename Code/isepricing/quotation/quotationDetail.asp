<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/commons.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="quotationVar.asp"-->

<%
	dim strsql
	dim rs,rsP,isclose
	'1,quotaionlist 2,quotationselect,3 close
	rtype=request("rtype")
	If IsNull(rtype) Or rtype="" Then
		rtype="1"
	End if
	strsql="select * from quotation where qid="&quotationid
	set rs=server.CreateObject("adodb.recordset")
	rs.open strsql,conn,1,1
	currencycode=rs("currencycode")
	curRate=rs("rate")
	sepcParment=rs("SEPC_PARMENTTERM")
	
	'是否显示价格明细
	isshowPriceDetail=False
	colspancnt=2
	colspancnt2=2
	If rs("prodcnt")>1 Then
		isshowPriceDetail=true
		colspancnt=5
		colspancnt2=3
	End if
	'产品
	strsql="select C.BU,c.modality modalityname ,b.productname ,a.quotedprice,a.targetprice,a.targetpricewew,a.part1,a.part2,a.part3,a.part4,a.adjustprice,b.remark from quotation_detail a,product  b,modality c where a.pid=b.pid and b.mid=c.mid and a.qid="&quotationid
	set rsP=server.CreateObject("adodb.recordset")
	rsP.open strsql,conn,1,1

	
	if not isnull(PromotionPlan) and PromotionPlan<>"" then
		'response.Write("<script>alert('"&PromotionPlan&"');</script>")
	end if
	
	'备件
	strsql="select a.qdid,b.pid,a.qid,c.modality modalityname ,b.productname ,a.quotedprice,b.freight isfreight,b.inst isinst,b.warr iswarr,b.apptraining istraining,b.standardprice  from quotation_detail a,product  b,modality c where a.pid=b.pid and b.mid=c.mid and a.qid="&quotationid
	set rsC=server.CreateObject("adodb.recordset")
	rsC.open strsql,conn,1,1

%>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title></title>
<LINK href="../css/css.css" type=text/css rel=stylesheet>
<script type="text/javascript" src="../js/ut.js"></script>
<script type="text/javascript" src="../js/jquery-1.2.6.js"></script>
<script>
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
	function goBack(){
		<% if rtype="1" then%>
		location.href="quotationList.asp?d=<%=now%>";
		<% end if%>
		<% if rtype="2" then%>
		location.href="../selects/quotationSelect.asp?d=<%=now%>";
		<% end if%>
		<% if rtype="3" then%>
			window.close();
		<% end if%>
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
</script>
</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0">
<div align="center">
  <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td>
	    <table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td class="titleorange"><div align="center">Imaging Systems Quotation</div></td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td valign="top">
              <table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td width="18%"> 
                    <div align="left">Quotation No:<br>
                      报价文件号：<br>
                    </div>
				  </td>
                  <td width="32%"> 
                    <div align="left"><%=rs("quotationno")%></div></td>
                  <td width="18%"> 
                    <div align="left">Final User (Hospital) Name:<br>
                      最终用户名称（医院）：</div></td>
                  <td width="32%"> 
                    <div align="left"> <%=rs("username")%> &nbsp;</div></td>
                </tr>
                <tr class="line01"> 
                  <td> <div align="left">Business Model:<br>
                      业务模式：</div></td>
                  <td> <div align="left"> <%=BUSINESS_MODEL(cint(rs("businessmodel")),1)%></div></td>
                  <td> <div align="left">Non-list Final User (Hospital) name:<br>
                      自填用户名称：</div></td>
                  <td> <div align="left"> <%=rs("nonusername")%> &nbsp;</div></td>
                </tr>
                <tr class="line01"> 
                  <td> <div align="left">Payment Term:<br>
                      付款方式：</div></td>
                  <td> <div align="left">
				  <% If Not IsNull(rs("paymentterm")) and rs("paymentterm")<>"" then
					 response.write(PAYMENT_TERM(cint(rs("paymentterm")),1))
				   End if%>
				  &nbsp;</div></td>
                  <td> <div align="left">Dealer Name:<br>
                      若非飞利浦竞标，请写明经销商名称：</div></td>
                  <td> <div align="left"><%=rs("dealername")%> &nbsp;</div></td>
                </tr>
				<tr class="line01"> 
                  <td> <div align="left">Special Payment Term:<br>
                      特殊付款方式：</div></td>
                  <td> <div align="left"> 
                     <%=sepcParment%>&nbsp;
                     </div>
				  </td>
                  <td>&nbsp; </td>
                  <td>&nbsp;</td>
                </tr>
				<tr class="line01"> 
				  <td> <div align="left">Tender Document No:<br>
                      招标文件号：</div></td>
                  <td> <div align="left"> 
                     <%=rs("tenderno")%>&nbsp;
                    </div>
				  </td>
                  <td> <div align="left">Currency:<br>
                      币种：</div></td>
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
                     </div>
				   </td>
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
      <td>
	    <table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td>
			  <table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td width="5%">No.</td>
                  <td width="34%">BU</td>
                  <td width="51%">Product</td>
				  <%If isshowPriceDetail then%>
				  <td nowrap title="目标进单价">Target OIT Price</td>
				  <td title="飞利浦产品净目标价">PartI</td>
				  <td title="第三方产品成本">PartII</td>
				  <td title="其他预留成本">PartIII</td>
				  <td title="飞利浦非标准保修">PartIV</td>
				  <%End If %>
                </tr>
				<% 
				dim i ,total,totalwew
				i=1
				while not rsP.eof 
				PromotionPlan=rsP("remark")
				total=total+rsP("targetprice")
				totalwew=totalwew+rsP("targetpricewew")
				adjustprice=rsP("adjustprice")
				If isnull(adjustprice) Or adjustprice="" Then
					adjustprice=0
				End If 
				%>
                <tr class="line02"> 
                  <td><%=i%></td>
                  <td><%=BU_TYPE(rsP("BU"),1)%>&nbsp;<br> </td>
                  <td>
					  <a href="#<%=i%>">
					  <%=rsP("productname")%>
					  </a>
					&nbsp;
				  </td>
				  <% If isshowPriceDetail then%>
				  <td nowrap  title="目标进单价">
				  <%=rsP("targetprice")%>
				  &nbsp;</td>
				  <td nowrap title="飞利浦产品净目标价">
				  <%=rsP("part1")%>
				  &nbsp;</td>
				  <td nowrap title="第三方产品成本">
				  <%=rsP("part2")%>
				  &nbsp;</td>
				  <td nowrap  title="其他预留成本">
				  <%=rsP("part3")%>
				  &nbsp;</td>
				  <td nowrap  title="飞利浦非标准保修">
				  <%=rsP("part4")%>
				  &nbsp;</td>
				  <% End If %>
                </tr>
				<%
					rsP.movenext
					i=i+1
					wend
				%>
 
				<tr class="line01" align="left"> 
                  <td colspan="8">&nbsp;</td>
                </tr>
				<tr class="line01" align="center" > 
                  <td colspan="8">Quotation Summary <br>报价概要</td>
                </tr>
                <tr class="line01"> 
                  <td  colspan="<%=colspancnt2%>" width="27%"><div align="left">Target OIT 
                      Price<br>
                      目标进单价</div></td>
                  <td colspan="<%=colspancnt%>" width="73%"><%=rs("targetprice")%>&nbsp;</td>
                </tr>
                <tr class="line01"> 
                  <td colspan="<%=colspancnt2%>"><div align="left">Target OIT 
                      Price（Without Extended Warranty）<br>
                      目标进单价（不含延长保修）
                    </div>
				  </td>
                  <td colspan="<%=colspancnt%>"><%=rs("targetpricewew")%>&nbsp;
				  </td>
                </tr>
				<tr class="line01"> 
                  <td colspan="<%=colspancnt2%>"><div align="left">Price Adjustment（For Promotion Plan Adjustment Only) <br>
				  	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;价格调整
                    </div></td>
                  <td id="d_adjustprice" colspan="<%=colspancnt%>">&nbsp;</td>
                </tr>
				<tr class="line01"> 
                  <td colspan="<%=colspancnt2%>"><div align="left">Part I:  Philips Product Net Target Price<br>
				  	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;飞利浦产品净目标价
                    </div></td>
                  <td id="part1" colspan="<%=colspancnt%>">&nbsp;</td>
                </tr>
				<tr class="line01"> 
                  <td colspan="<%=colspancnt2%>"><div align="left">Part II: 3rd Party Items<br>
				  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;第三方产品成本
                    </div></td>
                  <td id="part2" colspan="<%=colspancnt%>">&nbsp;</td>
                </tr>
				<tr class="line01"> 
                  <td colspan="<%=colspancnt2%>"><div align="left">Part III :  Other Provision<br>
				  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;其他预留成本
                    </div></td>
                  <td id="part3" colspan="<%=colspancnt%>">&nbsp;</td>
                </tr>
				<tr class="line01"> 
                  <td colspan="<%=colspancnt2%>"><div align="left">Part IV: Non-standard Warranty by Philips<br>
				  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;飞利浦非标准保修
                    </div></td>
                  <td id="part4" colspan="<%=colspancnt%>">&nbsp;</td>
                </tr>
              </table>
			</td>
          </tr>
        </table>
	  </td>
    </tr>
	
	<!--开始循环-->
	<% 
	Dim maojiIndex
	maojiIndex=0
	while not rsC.eof 
	maojiIndex=maojiIndex+1
	isclose=true
			dim qdid
	qdid=rsC("qdid")
	
	dim t1,t2,t3,t4
	
	strsql="select * from quotation_detail where qdid="&qdid
	set rsDetail=server.CreateObject("adodb.recordset")
	rsDetail.open strsql,conn,1,1
	
	t1=rsDetail("part1")
	%>
    <tr> 
      <td>&nbsp;</td>
    </tr>
	<tr > 
      <td bgcolor="red" height="5"> <a name="#<%=maojiIndex%>"></a></td>
    </tr>
    <tr> 
      <td>
	    <table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td valign="top"> 
			  <table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="table01"> 
                  <td width="100%" height="100" valign="top" class="line01">
				    <font style="font-size:18pt">
				      <%=rsC("productname")%>
				    </font>
                  </td>
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

	<!--如果adjustprice不等于0，显示adjustprice-->
<% If Not IsNull(rsDetail("adjustprice")) And rsDetail("adjustprice")<>"" And rsDetail("adjustprice")<>"0" Then %>
    <tr> 
      <td>
	    <table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td align="center">
              <table width="95%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line02"> 
                  <td width="10%">Promotion Plan</td>
                  <td width="25%"  align="left" id="td_PromotionPlan"><%=PromotionPlan%>&nbsp;</td>
                </tr>
				<tr class="line02"> 
                  <td width="10%">Price Adjustment<br>
				    <font color="red"> Promotion Plan Adjustment Only！</font>
				  </td>
                  <td width="25%" align="left"><%=rsDetail("adjustprice")%>&nbsp;
				  </td>
                </tr>
				<tr class="line02"> 
                  <td width="10%">Reason For Price Adjustment</td>
                  <td width="25%"  align="left" style="word-break:break-all"><%=rsDetail("adjustComments")%>&nbsp;
				  </td>
                </tr>
              </table>
		    </td>
		  </tr>
		</table>
	  </td>
    </tr>
<% End If %>
    <tr> 
      <td>
	    <table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td class="line01">Part I : Philips Product Net Target Price<br>飞利浦产品净目标价</td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td valign="top">
              <table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
				  <td width="5%">No.</td>
                  <td width="12%">Article No.</td>
                  <td width="48%">Article Description</td>
                  <td width="5%">Quantity</td>
                  <td width="15%">List Price</td>
                  <td width="15%">Total List Price</td> 
                </tr>
				  <%
						strsql="select * from quotation_detail_philips where type=0 and qdid="&qdid
						set rsStandard=server.CreateObject("adodb.recordset")
						rsStandard.open strsql,conn,1,1
				        i=1
				        while not rsStandard.eof
				't1=t1+rsStandard("quotedprice")
				  %>
				
                <tr class="line02"> 
                  <td><%=i%></td>
                  <td><%=rsStandard("materialno")%></td>
				  <td><%=rsStandard("description")%></td>
                  <td><%=rsStandard("qty")%></td>
                  <td><%=clng(rsStandard("listprice"))%></td>
                  <td><%=clng(rsStandard("listprice") * rsStandard("qty"))%></td>
                </tr>
				<%
					rsStandard.movenext
					i=i+1
					wend
				%>
				 <tr class="line02"> 
                  <td colspan="6">&nbsp;</td>
                </tr>
               </table>
			 </td>
          </tr>
		  <tr> 
            <td valign="top" align="center">
			  <table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
			    <tr class="line01"> 
                  <td colspan="6">Standard 3rd Party Products<br>标准第三方产品 &nbsp;</td>
                </tr>
			    <tr class="line01"> 
                  <td width="5%">No.</td>
				  <td width="12%">Product Code</td>
                  <td width="48%">Product Name</td>
                  <td width="5%">Quantity</td>
                  <td width="15%">Unit Cost</td>
                  <td width="15%">Total Cost</td>
                </tr>
				<%
						strsql="select * from quotation_detail_3rd where  qdid="&qdid &"  and type=0 order by type asc"
						set rs3rd_must=server.CreateObject("adodb.recordset")
						rs3rd_must.open strsql,conn,1,1
				i=1
				while not rs3rd_must.eof
				%>
                <tr class="line02"> 
                  <td><%=i%>&nbsp;</td>
                  <td><%=rs3rd_must("materialno")%> &nbsp;</td>
				   <td><%=rs3rd_must("itemname")%> &nbsp;</td>
                  <td><%=rs3rd_must("qty")%> &nbsp;</td>
                  <td><%=CLng(rs3rd_must("unitcost"))%>&nbsp;</td>
                  <td><%=CLng(rs3rd_must("quotedprice"))%>&nbsp;</td>
                </tr>
				<%
					rs3rd_must.movenext
					i=i+1
					wend
				%>
				<tr class="line02"> 
                  <td colspan="6">&nbsp;</td>
                </tr>
                <tr class="line01"> 
                  <td colspan="5">Standard Net target price<br>标准配置净目标价</td>
                  <td colspan="1"><%=CLng(rsC("standardprice"))%>&nbsp;</td>
                </tr>
              </table>
			</td>
          </tr>
        </table>
	  </td>
    </tr>
    <tr> 
      <td>
	    <table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
		  <tr> 
            <td>&nbsp;</td>
          </tr>
		  <tr> 
            <td class="line01">Options<br>选件&nbsp;
			  <br>
              以下选件不包含在“Standard Configuration”中，以下选件价格不包含在“Standard Net Target 
              Price”中！ </td>
          </tr>
          <tr> 
            <td>
			  <table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td width="5%">No.</td>
                  <td width="12%">Content</td>
                  <td width="12%">Article No.</td>
                  <td width="36%">Article Description</td>
                  <td width="5%">Quantity</td>
                  <td width="15%">List Price</td>
                  <td width="15%">Target  Price</td>
                </tr>
					<%
						strsql="select * from quotation_detail_philips where type=1 and qdid="&qdid
						set rsStandardOpt=server.CreateObject("adodb.recordset")
						rsStandardOpt.open strsql,conn,1,1
						i=1
						t2=0
						while not rsStandardOpt.eof
							t2=t2+rsStandardOpt("quotedprice")
					%>
                <tr class="line02"> 
                  <td><%=i%></td>
                  <td><%=rsStandardOpt("items")%>&nbsp;</td>
                  <td><%=rsStandardOpt("materialno")%></td>
                  <td><%=rsStandardOpt("description")%></td>
                  <td><%=rsStandardOpt("qty")%> </td>
                  <td><%=CLng(rsStandardOpt("listprice"))%></td>
                  <td><%=CLng(rsStandardOpt("quotedprice"))%></td>
                </tr>
					<%
						rsStandardOpt.movenext
						i=i+1
						wend
					%>
                <tr class="line01"> 
                  <td colspan="6">Option Target Price<br>选件目标价</td>
                  <td colspan="1"><%=Round(t2) %>&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="7"><div align="right"> &nbsp;&nbsp; &nbsp;&nbsp; 
                      &nbsp;&nbsp; </div></td>
                </tr>
					<%
					dim roleid
					roleid=session("roleid")
					if isnull(roleid) or trim(roleid)="1" or trim(roleid)="4" or trim(roleid)="6" then
					%>
				<!--
                <tr class="line01"> 
                  <td>&nbsp;</td>
                  <td> Sub-total</td>
                  <td><font color="#FF0000">&nbsp;</font><br></td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td><%=t1+t2%></td>
                </tr>
                <tr> 
                  <td colspan="7">&nbsp;</td>
                </tr>
				-->
				<% end if %>
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
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td>
	    <table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td>
			  <table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td width="5%">No.</td>
                  <td width="80%" >Other Direct Cost<br>
                    其他直接成本</td>
				  <td width="15%" >&nbsp;</td>
                  <!--  <td >Selection</td>
                  <td width="24%">Charged %</td>
                  <td width="16%">Amount</td>
				  -->
                </tr>
                <tr class="line02"> 
                  <td>1</td>
                  <td>Freight &amp; Insurance<br>运费&amp;保险费 </td>
				  <td>&nbsp;
				   <%
						if rsC("isfreight")="0" or isnull(rsc("isfreight")) then
							response.Write("无")
						else
							response.Write("有")
						end if
					%>
				  </td>
                  <!--  <td><%=rsDetail("fi")%>&nbsp;</td>
                  <td><%=rsDetail("ficharged")%>&nbsp;</td>
                  <td><%=rsDetail("fiamount")%>&nbsp;</td>
				  -->
                </tr>
                <tr class="line02"> 
                  <td>2</td>
                  <td>Installation By Philips<br>飞利浦安装成本</td>
				  <td>&nbsp;
				   <%
						if rsC("isinst")="0" or isnull(rsC("isinst")) then
							response.Write("无")
						else
							response.Write("有")
						end if
					%>
				   </td>
					   <!-- <td><%
							if rsDetail("ibp")="0" then
								response.Write("No")
							else
								response.Write("Yes")
							end if
						%></td>
					  <td><%=rsDetail("ibpcharged")%>&nbsp;</td>
					  <td><%=rsDetail("ibpamount")%>&nbsp;</td>
					  -->
                </tr>
                <tr class="line02"> 
                  <td>3</td>
                  <td>Application Training<br>应用培训成本</td>
				  <td >&nbsp;
				   <%
						if rsC("istraining")="0"  or isnull(rsC("istraining")) then
							response.Write("无")
						else
							response.Write("有")
						end if
					%></td>
					<!--  <td>&nbsp;</td>
					 <td>&nbsp;</td>
					  <td><%=rsDetail("atamount")%>&nbsp;</td>
					  -->
                </tr>
                <tr class="line02"> 
                  <td>4</td>
                  <td>Standard warranty By Philips<br>飞利浦标准保修费</td>
				   <td >&nbsp;
				   <%
						if rsC("iswarr")="0" or isnull(rsc("iswarr")) then
							response.Write("无")
						else
							response.Write("有")
						end if
					%></td>
                 <!-- <td><%
						if rsDetail("sbp")="0" then
							response.Write("No")
						else
							response.Write("Yes")
						end if
					%></td>
                   <td><%=rsDetail("sbpcharged")%>&nbsp;</td>
                  <td><%=rsDetail("sbpamount")%> &nbsp;</td>
				  -->
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
    <tr > 
      <td>
	    <table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td>
			  <table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line_subtotal"> 
                  <td colspan="2">Philips Product Net Target Price<br>净目标价</td>
                  <td width="15%"><%=t1%>&nbsp;</td>
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
      <td>
	    <table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td class="line01">Part II : 3rd party items<br>第三方产品成本</td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td>
			  <table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td width="5%">No.</td>
				  <td width="12%">Product Code</td>
                  <td width="48%">Product Name</td>
                  <td width="5%">Quantity</td>
                  <td width="15%">Unit Cost</td>
                  <td width="15%">Total Cost</td>
                </tr>
				<%
						strsql="select * from quotation_detail_3rd where  qdid="&qdid &"  and type!=0 order by type asc"
						set rs3rd=server.CreateObject("adodb.recordset")
						rs3rd.open strsql,conn,1,1
				i=1
				while not rs3rd.eof
				%>
                <tr class="line02"> 
                  <td><%=i%>&nbsp;</td>
                  <td><%=rs3rd("materialno")%> &nbsp;</td>
				   <td><%=rs3rd("itemname")%> &nbsp;</td>
                  <td><%=rs3rd("qty")%> &nbsp;</td>
                  <td><%=CLng(rs3rd("unitcost"))%>&nbsp;</td>
                  <td><%=CLng(rs3rd("quotedprice"))%>&nbsp;</td>
                </tr>
				<%
					rs3rd.movenext
					i=i+1
					wend
				%>
                <tr class="line01"> 
                  <td>&nbsp;</td>
				  <td>&nbsp;</td>
                  <td>Site preparation</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td><%
				   If IsNull(rsDetail("site")) Then
					   response.write(0)
				   Else 
					 response.write(CLng(rsDetail("site")))
				   End if
				  %>&nbsp;</td>
                </tr>
                <tr class="line_subtotal"> 
                  <td colspan="5">Subtotal</td>
                  <td colspan="1"><%
				   If IsNull(rsDetail("part2")) Then
					   response.write(0)
				   Else 
					 response.write(CLng(rsDetail("part2")))
				   End if
				 %>&nbsp;</td>
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
      <td>
	    <table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td class="line01">Part III : Other Provision<br>其他预留成本</td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td>
			  <table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td width="5%">No.</td>
                  <td width="60%">Description</td>
                  <td width="5%">Quantity</td>
                  <td width="15%">Unit Cost</td>
                  <td width="15%">Total Cost</td>
                </tr>
					<%
						strsql="select * from quotation_detail_provision where  qdid="&qdid 
						set rspro=server.CreateObject("adodb.recordset")
						rspro.open strsql,conn,1,1
					i=1
					while not rspro.eof
					%>
                <tr class="line02"> 
                  <td><%=i%></td>
                  <td><%=rspro("materialno")%> &nbsp;</td>
                  <td><%=rspro("qty")%> &nbsp; </td>
                  <td><% 
				  If IsNull(rspro("unitcost")) Then
					response.write(0)
				  Else
					response.write(CLng(rspro("unitcost")))
				  End if
				  %> &nbsp;</td>
                  <td><%
				   If IsNull(rspro("quotedprice")) Then
					response.write(0)
				  Else
					response.write( CLng(rspro("quotedprice")))
				  End If
				  %> &nbsp;</td>
                </tr>
					<%
						rspro.movenext
						i=i+1
						wend
					%>
              
                <tr class="line_subtotal"> 
                  <td colspan="4">Subtotal</td>
                  <td colspan="1">
					  <%
						If IsNull(rsDetail("part3")) Then
						response.write(0)
					  Else
						response.write( CLng(rsDetail("part3")))
					  End If
					  %>&nbsp;
				  </td>
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
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td>
	    <table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td class="line01">Part IV : Philips Non-standard Warranty<br>飞利浦非标准保修</td>
          </tr>
		  <%
			ewbpyear=rsDetail("ewbpyear")
			ewbpprice=rsDetail("ewbpprice")
			sewbpyear=rsDetail("sewbpyear")
			sewbpprice=rsDetail("sewbpprice")
			If ewbpyear=0 Then
				ewbpunitcost=0
			Else
				ewbpunitcost=ewbpprice/ewbpyear
			End If
			If sewbpyear=0 Then
				sewbpunitcost=0
			Else
				sewbpunitcost=sewbpprice/sewbpyear
			End if
		  %>
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td>
			  <table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td width="30%">Philips Extended Warranty :<br>
                    飞利浦延长保修费：</td>
                  <td width="10%">
				  	<%
						if rsDetail("ewbp")="0" then
							response.Write("No")
						else
							response.Write("Yes")
						end if
					%>
				  </td>
                  <td width="20%"><%=ewbpyear%>&nbsp;&nbsp;&nbsp;&nbsp; Year</td>
				 <!-- <td width="20%"><%=ewbpunitcost%>&nbsp;&nbsp;&nbsp;&nbsp;Unit Cost</td> -->
                  <td width="20%"><%=ewbpprice%>&nbsp;&nbsp;&nbsp;&nbsp;Total Cost</td>
                </tr>
				<tr class="line01"> 
                  <td width="30%">Special Warranty Terms in <br>
                    Standard Warranty Period :<br>
                    飞利浦标准保修期内的特殊要求：</td>
                  <td width="10%">	<%
						if rsDetail("sewbp")="0" then
							response.Write("No")
						else
							response.Write("Yes")
						end if
					%></td>
                  <td width="20%"><%=sewbpyear%> &nbsp;&nbsp;&nbsp;&nbsp;Year
                    </td>
                  <!--  <td width="20%"><%=sewbpunitcost%>&nbsp;&nbsp;&nbsp;&nbsp;Unit Cost</td>  -->
				   <td width="20%"><%=sewbpprice%>&nbsp;&nbsp;&nbsp;&nbsp;Total Cost</td>
                </tr>
                <tr class="line01"> 
                  <td>Comments :<br>
                    备注：</td>
                  <td colspan="4"><div align="left"><%=rsDetail("comments")%>&nbsp;</div></td>
                </tr>
              </table>
			</td>
          </tr>
        </table>
	  </td>
    </tr>
	
    <% 
      rsC.movenext
      Wend
    %>
    <!--结束循环-->
	<tr>
	  <td>&nbsp;
	    
	  </td>
	</tr>
	<tr bgcolor="white">
	  <td align="right">
			<% If rtype<>"3" Then %>
		  	<input type="button" value="Return" onClick="goBack();">
			<% End if%>
			<% If rtype="3" Then %>
		  	<input type="button" value="Close" onClick="goBack();">
			<% End if%>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  </td>
	</tr>
  </table>
  <!--#include file="../footer.asp"-->
</div>
<script>
	<% if isclose then%>
		$("#currencycode").val('<%=currencycode&"_"&curRate%>');
	<% end if%>
	
	getPartPrice('<%=quotationid%>');
	<% if quotationid<>"" then%>
		$("#currencycode").attr({"disabled":"disabled"});
	<%end if%>
	$("#td_PromotionPlan").val('<%=td_PromotionPlan%>');
</script>
</body>
</html>
<%
	rs.close
	set rs=nothing
	rsP.close
	set rsP=nothing
	
	rsC.close
	set rsC=nothing
	if isclose then
		rsStandard.close
		set rsStandard=nothing
		rsStandardOpt.close
		set rsStandardOpt=Nothing
		rs3rd_must.close
		set rs3rd_must=nothing
		rs3rd.close
		set rs3rd=nothing
		rspro.close
		set rspro=nothing
		rsDetail.close
		set rsDetail=nothing
	end if
	CloseDatabase
%>



