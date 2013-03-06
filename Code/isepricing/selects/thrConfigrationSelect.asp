<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/commons.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../include/utils.asp"-->
<%
	dim rs1
	dim qid,isclose,unitcost
	dim curRate,currencycode,currencyrate
	pid=request("pid")
	pdids=request("pdids")
	
	curRate=request("curRate")
	currencycode=split(curRate,"_")(0)
	currencyrate=split(curRate,"_")(1)
	
	materialno=request("materialno")
	description=request("description")
	
	if pid<>"" then
		isclose=true
		strSql="select pid as pdid,itemcode as materialno,itemname,unitcost,unitcostrmb,model,diliverydate,madein,warranty,starttime from party where state=0 and status=0 "
		if materialno<>"" then
			strSql =strSql & " and itemcode='"&materialno&"'" 
		end if
		if description<> "" then
			strSql =strSql & " and itemname like '%"&description&"%'" 
		end if
		set rs1=server.createObject("adodb.recordset")
		rs1.open strsql,conn,3,3
	end if
	
%>
<%
	page=request("page")
	if page="" then
		page=0
	end if
	if page<>"" then
		if not isnumeric(page) then
%>
		  <script language="JavaScript">
				alert("页数请输入数字");
				history.go(-1);
			</script>
 <%
			response.end()
		else
			page=cint(page)
		end if
	else
			page=cint(page)
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
	function doSelect(){
		var obj;
		var objrow;
		var qty;
		obj=$("input:checkbox[name='pdid'][checked]");
		
		if(obj.size()==0){
			alert('pls select configration！');
			return ;
		}
		var ids;
		
		//obj=$("input:checkbox[name='pdid'][checked]").parent().parent();
		obj.each(function(index){
			ids=$("input:checkbox[name='pdid']").index(this);
			qty=$("input[name='qty']").eq(ids).val();
	
			if(isNaN(qty) || qty<1){
					alert('请填写整数！');
					return false;
			}
			objrow=$(this).parent().parent();
			
			opener.addThrRow('thr_table',
			"<tr class='line02'><td></td><td></td><td>"+objrow.find("td:eq(1)").html()+"</td><td>"+objrow.find("td:eq(2)").html()+"</td><td></td><td></td><td></td></tr>",
			$(this).val(),
			$("input[name='qty']").eq(ids).val(),
			$("input:hidden[name='lp']").eq(ids).val(),
			$("input:hidden[name='qp']").eq(ids).val());
		});
		alert("操作成功！");
		//window.close();
	}
	function chgQuotedPrice(){
		$("input:text[name='qty']").each(function(index){
			if(isNaN($(this).val()) || $(this).val()<1){
				alert('请填写整数！');
				$(this).focus();
				$(this).val('');
				return false;
			}
			var qp=$(this).val()*$("input:hidden[name='lp']").eq(index).val();
			
			qp=formatNumber(qp,'1234567890.0000');
			$(this).parent().parent().find("td:eq(5)").html(qp+"<input type='hidden' name='qp' value='"+qp+"'>");;
		});
	}
</script>
</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0"  scroll="auto">
<form action="thrConfigrationSelect.asp" method="post">
<input type="hidden" name="pid" value="<%=pid%>">
<input type="hidden" name="curRate" id="curRate" value="<%=curRate%>">
<input type="hidden" name="currencycode" id="currencycode" value="<%=currencycode%>">
<input type="hidden" name="currencyrate" id="currencyrate" value="<%=currencyrate%>">
<div align="center">
  <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td><table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td class="titleorange"><div align="center">Add 3rd Party Product
			</div></td>
          </tr>
        </table>
		</td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
	
	 <tr> 
            <td valign="top" class="line01"> <table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
                <tr> 
                  <td><table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
				 
                      <tr class="line01"> 
                        <td width="10%"> <div align="left">Product Code:<br>
                          </div></td>
                        <td> <div align="left"> 
                         <input type="text" name="materialno" value="<%=materialno %>">
                          </div></td>
						   <td width="10%"> <div align="left">Product Name<br>
                          </div></td>
                        <td> <div align="left"> 
                         <input type="text" name="description" value="<%=description %>">
                          </div></td>
						  <td >
						 
						  <input type="submit" name="Submit" value="Search">
				&nbsp;&nbsp;
				 
				   &nbsp;
						  </td>
                      </tr>
					
                    </table></td>
                </tr>
              </table>
       </td>
          </tr>
          <tr> 
            <td class="line02">&nbsp; </td>
          </tr>
	
	<tr >
	<td>
	<table align="center" width="100%">
    <tr > 
      <td><table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td><table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td width="5%">&nbsp;</td>
				   <td width="15%">Product Code</td>
                  <td width="20%">Product Name</td>
                  <td width="5%">Quantity</td>
                  <td width="10%">Unit Cost</td>
				   <td width="10%">Total Cost</td>
					<td width="10%">Applicable Modality</td>
					<td width="5%">Lead Time</td>
					<td width="5%">Original Country</td>
					<td width="5%">Warranty Period</td>
					<td width="10%">Update Date</td>
                </tr>
				<% If rs1.bof And rs1.eof then%>
					<tr><td colspan="11" align="center">no records!<td></tr>
				<%
				else
				 i2=1
				 rs1.pagesize=10
			if page<=0 then page=1 end if
			if page >rs1.pagecount then page=rs1.pagecount end if
			rs1.absolutepage=page
			
			for i=1 to rs1.pagesize  %>
                <tr class="line02"> 
                  <td><input type="checkbox" name="pdid" value="<%=rs1("pdid")%>"></td>
                  <td nowrap="nowrap"><%=rs1("materialno")%> &nbsp;</td>
				  <td ><%=rs1("itemname")%> &nbsp;</td>
                   <td>
				   <input type="text" name="qty" onChange="chgQuotedPrice();" size="5" maxlength="5" value="1">
				  </td>
                  <td>&nbsp;
				  <% if currencycode=CURRENCY_CHINA then
				  			unitcost=rs1("unitcostrmb")
					else
						unitcost=rs1("unitcost")*currencyrate
				  	end if
					
					if isnull(unitcost) or unitcost="" then
						unitcost=0
					end If
					
					unitcost=CLng(unitcost)
				  %>
				  <%=clng(unitcost)%>
				  	<input type="hidden" name="lp" value="<%=unitcost%>">
				  </td>
					<td>
				  	<input type="hidden" name="qp">
				  </td>
				  <td ><%=rs1("model")%> &nbsp;</td>
					<td nowrap="nowrap"><%=rs1("diliverydate")%> &nbsp;</td>
					<td ><%=rs1("madein")%> &nbsp;</td>
					<td ><%=rs1("warranty")%> &nbsp;</td>
					<td nowrap><%=displaytime2(rs1("starttime"))%> &nbsp;</td>
                </tr>
               <%
					rs1.movenext
					i2=i2+1
					if rs1.eof then exit for end if
					Next
				End if
				%>
				
				  <tr>
		<td colspan="11">
        <TABLE height="34" cellSpacing="0" cellPadding="0" width="100%" background='../images/bg_bt.gif' border="0" class="table01">
            <TR class="line01">
              <TD align=right>Record Count:<%=rs1.recordcount%> &nbsp;&nbsp;
			  Page:<%=page%>/<%=rs1.pagecount%></TD>
              <TD noWrap align=middle width="70%"> First Page
			  &nbsp; <A href="javascript:PageTo('1')">|&lt;&lt;</A> &nbsp;&nbsp;
			   <A href="javascript:PageTo('<%=page-1%>')">&lt;&lt;</A>
			   &nbsp;&nbsp; <A href="javascript:PageTo('<%=page+1%>')">&gt;&gt;</A> 
			   &nbsp;&nbsp; <A href="javascript:PageTo('<%=rs1.pagecount%>')">&gt;&gt;|</A> &nbsp;&nbsp; Last Page</TD>
            </TR>
        </TABLE>
      </TD>
    </TR>
				
				
                <tr> 
                  <td colspan="11"><div align="right"> 
                      <input type="button" name="Submit2" value="Select" onClick="doSelect();">
                      &nbsp;&nbsp; 
                      <input type="button" name="Submit2" value="Close" onClick="window.close();">
                      &nbsp;&nbsp; &nbsp;&nbsp; </div></td>
                </tr>
				<%
					dim roleid
					roleid=session("roleid")
					if isnull(roleid) or trim(roleid)="" then
				%>
				<% end if %>
              </table></td>
          </tr>
        </table></td>
    </tr>
   
  </table>
   <!--#include file="../footer.asp"-->
</div>
</form>
<script>
	chgQuotedPrice();
</script>

<script>
	function PageTo(str) {
	if (parseInt(str) > <%=rs1.pagecount%>)
	{
		alert ("This page is the last one!")
		return;
	}

	if (parseInt(str) < 1)
	{
		alert ("This page is the first one!")
		return;
	}
    document.forms[0].action="thrConfigrationSelect.asp?page="+str;
    document.forms[0].submit();	
 }
</script>
</body>
</html>
<%
	if isclose then
		rs1.close
		set rs1=nothing
	end if
		CloseDatabase
%>
