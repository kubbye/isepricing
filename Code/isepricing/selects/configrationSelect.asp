<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/commons.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../system/utils.asp"-->

<%
	dim rs1
	dim qid,isclose
	dim curRate,currencycode,currencyrate
	pid=request("pid")
	pdids=request("pdids")
	bu=request("bu")
	items=request("items")
	articleNO=request("articleNO")

	curRate=request("curRate")
	currencycode=split(curRate,"_")(0)
	currencyrate=split(curRate,"_")(1)
	
	'如果是ct，给出items列表
	'if bu="1" then
			'set rsItems=conn.execute("select distinct items from PRODUCT_DETAIL_PHILIPS where  pid="&pid)
			arr=execSql("select distinct items val,items name from PRODUCT_DETAIL_PHILIPS where type=1 and  pid="&pid)
	'end if
	If items="" then
		items=arr(0,0)
	End If 
	if pid<>"" then
		isclose=true
		strSql="select pdid,items,materialno,description,listprice*"&currencyrate&" listprice,targetprice*"&currencyrate&" targetprice from product_detail_philips where type=1 and pid="&pid
		if pdids<>"" then
			strSql=strSql & " and pdid not in("&pdids&") "
			strSql=strSql & " and mutex not in(select mutex from product_detail_philips where pdid in("&pdids&") and isnull(mutex,'')!='')"
		end If
		'if bu="1" THEN
			if items<>"" then
				strSql=strSql & " and items like '%"&items&"%'"
			Else
				strSql=strSql & " and (items='' or items is null)"
			end If
		'End IF
		If articleNO<>"" Then
			strSql=strSql & " and materialno like '%"&Trim(articleNO)&"%'"
		End if
		if bu="2" then 
			strSql=StrSql  & " and (type=2 or type=1)"
		end If
		strSql=strSql & " order by sortno"
		set rs1=server.createObject("adodb.recordset")
		'response.write(strsql)
		rs1.open strsql,conn,1,1
		
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
	huchi_flag=false;
	function doSelect()
	{
		huchi();
	}
	function doSelect_fact(){
		var obj;
		var objrow;
		var qty;
		obj=$("input:checkbox[name='pdid'][checked]");
		
		if(obj.size()==0){
			alert('pls select configration！');
			return ;
		}
		var ids;
		
		obj.each(function(index){
			ids=$("input:checkbox[name='pdid']").index(this);
			qty=$("input[name='qty']").eq(ids).val();
	
			if(isNaN(qty) || qty<1){
					alert('请填写整数！');
					return false;
			}
		
			objrow=$(this).parent().parent();
			opener.addRow('opt_table',
			"<tr class='line02'>"+objrow.html()+"</tr>",
			$(this).val(),
			$("input[name='qty']").eq(ids).val(),
			$("input:hidden[name='unitprice']").eq(ids).val(),
			$("input:hidden[name='qp']").eq(ids).val(),1);
			//$(this).attr("checked",false);

			objrow.remove();
			var tmppdiss=$("#pdids").val();
			if(tmppdiss==null || tmppdiss==''){
				$("#pdids").val($(this).val());
			}else{
				$("#pdids").val(tmppdiss+","+$(this).val());
			}
			
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
		
			var unitprice=$("input:hidden[name='unitprice']").eq(index).val();
			if(unitprice==null || unitprice==''){
				unitprice=0;
			}
			$("input:hidden[name='unitprice']").eq(index).val(unitprice);
			var totalprice=$(this).val()*unitprice;
			totalprice=formatNumber(totalprice,'1234567890.00');
			$(this).parent().parent().find("td:eq(6)").text(totalprice);

			var lp=$("input:hidden[name='lp']").eq(index).val();
			if(lp==null || lp==''){
				lp=0;
			}
			$("input:hidden[name='lp']").eq(index).val(lp);
			var qp=$(this).val()*lp;
			qp=formatNumber(qp,'1234567890.00');
			$(this).parent().parent().find("td:eq(7)").html(qp+"<input type='hidden' name='qp' value='"+qp+"'>");

		});
	}
	function queryList(){
		document.forms[0].submit();
	}

	function huchi(){
		var ismsg=1;
			//philips可选件
		var opts='';
		var s_config='';
		if ($("input:checkbox[name='pdid'][checked]").size()==0)
		{
			alert('pls select configration！');
			return;
		}
		$("input:checkbox[name='pdid'][checked]").each(function(index){
			if(index==0){
				opts=$(this).val();
				s_config='1';
			}else{
				opts=opts+","+$(this).val();
				s_config=s_config+",1";
			}
			$("#opts").val(opts);
		});
		if (opts!='')
		{
			$.post("../quotation/mutex.asp",{opts:opts,opt_isConfig:s_config,pid:$("#pid").val()},function(data){
				if(data!=null && data!='')
				{
					if(ismsg==1)
					{
						alert(data+"互斥，请重新选择");
					}
					huchi_flag=true;
				}else{
					huchi_flag=false;
					doSelect_fact();
				}
			});
			
		}
	}
</script>
</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0"  scroll="auto">
<form action="configrationSelect.asp" method="post">
<input type="hidden" id="pdids" name="pdids" value="<%=pdids%>">
<input type="hidden" name="pid" id="pid" value="<%=pid%>">
<input type="hidden" name="bu" id="bu" value="<%=bu%>">
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
            <td class="titleorange"><div align="center">Add  Key Options
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

					    <td width="10%"> <div align="left">Article No:<br>
                          </div></td>
                        <td> <div align="left"> 
                           <input type="text" name="articleNO" value="<%=articleNO %>"> 
                          </div></td>
						    <% 'if bu="1" then %>
                        <td width="10%"> <div align="left">Content:<br>
                          </div></td>
                        <td> <div align="left"> 
								<select name="items" id="items" onChange="queryList();">
								<% for i=0 to ubound(arr)%>
								<option value='<%=arr(i,0)%>' ><%=arr(i,1)%></option>
								<%next%>
							</select>
                          </div></td>
	 <% 'end if%>
	 <td>
						  <input type="submit" name="Submit" value="Search" onClick="queryList()">
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
            <td><table id="t_data" width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td width="4%">&nbsp;</td>
                  <td width="8%">No.</td>
                  <td width="12%">Content</td>
                  <td width="16%">Article No.</td>
                  <td width="23%">Article Description</td>
                  <td width="10%">Quantity</td>
                  <td width="12%">Total List Price</td>
                  <td width="15%">Total Target Price</td>
                </tr>
				<%
				 i2=1
				 while not rs1.eof
				 targetprice=rs1("targetprice")
				 listprice=rs1("listprice")
				 if isnull(targetprice) Or IsEmpty(targetprice) or targetprice="" then
				 	targetprice=0
				else
					targetprice=clng(targetprice)
				 end If
				  if isnull(listprice) Or IsEmpty(listprice) or listprice="" then
				 	listprice=0
				else
					listprice=clng(listprice)
				 end if
				  %>
                <tr class="line02"> 
                  <td><input type="checkbox" name="pdid" value="<%=rs1("pdid")%>"></td>
                  <td><%=i2%></td>
                  <td><%=rs1("items")%> &nbsp;<input type="hidden" name="unitprice" value="<%=listprice%>">
				  	<input type="hidden" name="lp" value="<%=targetprice%>">
				  </td>
                  <td><%=rs1("materialno")%>&nbsp;</td>
                  <td><%=rs1("description")%>&nbsp;</td>
				  <td>
				  <input type="text" name="qty" onChange="chgQuotedPrice();" size="5" maxlength="5" value="1">
				  </td>
                  <td><%=listprice%>&nbsp;
				  </td>
                  <td><%=targetprice%>&nbsp;
				  <input type="hidden" name="qp" value="<%=targetprice%>">
				  </td>
                </tr>
               <%
					rs1.movenext
					i2=i2+1
					wend
				%>
                <tr> 
                  <td colspan="8"><div align="right"> 
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
	$("#items").val('<%=items%>');
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
