<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/commons.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../include/utils.asp"-->
<%
	dim sid
	sid=request("sid")
	viewtype=request("type")
	sql="select * from special_price where id="&sid
	Set rs=conn.execute(sql)
	productModel=rs("productmodel")
	status=rs("status")
	'�õ�����list
	sql="select a.*,b.username from Special_approve a left join userinfo b on a.approveUser=b.id where a.actiontype=1 and a.specialId="&sid
	sql=sql & " order by a.approvetime"
	Set rsApprove=conn.execute(sql)

	'�õ�resubmit list
	sql="select a.*,b.username from Special_approve a left join userinfo b on a.approveUser=b.id where a.actiontype=3 and a.specialId="&sid
	sql=sql & " order by a.approvetime"
	Set rsApprove2=conn.execute(sql)

	'�õ�pm comments list
	sql="select a.*,b.username from Special_approve a left join userinfo b on a.approveUser=b.id where a.actiontype=4 and a.specialId="&sid
	sql=sql & " order by a.approvetime"
	Set rsApprove3=conn.execute(sql)


	sql="select * from special_files where specialid="&sid
	Set rsfiles=conn.execute(sql)

	'��ѯ��ּ�¼
	'sql= "select * from special_detail where specialid="&sid
	'Set rs_split=conn.execute(sql)
%>
<%
	'0���½���
	'1��ά����Ʒ�ѱ��棻
	'2��am�ύ��
	'3��Sales Director���ύ��
	'4��PM���ύ��
	'5��fc���ύ��
	'6��Marketing Director���ύ��
	'11��������ɡ�

	dim roleid
	roleid=session("roleid")
	approveid=0
	rejectid=-1

	
	'Product Manager
	if roleid="3" Then
		approveid=4
		rejectid=-4
	End If
	'Marketing Director
	if roleid="4" Then
		If status=5 Then
			approveid=11
		Else
			approveid=6
		End if
		rejectid=-6
	End If
	'Sales Director
	if roleid="8" Then
		approveid=3
		rejectid=-3
	End If
	'FC
	if roleid="6" Then
		If productModel=1 Then
			approveid=11
		Else
			If status=6 Then
				approveid=11
			Else
				approveid=5
			End if
		End if
		rejectid=-5
	End if
%>	
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title>IS E-pricing system</title>
<LINK href="../css/css.css" type=text/css rel=stylesheet>
<script type="text/javascript" src="../js/My97DatePicker/WdatePicker.js" ></script>
<script type="text/javascript" src="../js/ut.js"></script>
<script type="text/javascript" src="../js/jquery-1.2.6.js"></script>
<script>
	function doApprove(res)
	{
		var form;
		form=document.forms[0];
		var statusid;
		if (form.comments.value==null || form.comments.value=='')
		{
			if(confirm('����Ҫ��д������ע��'))
			{
				return false;
			}
		}
		if(res==1){
			if(!confirm('ȷ����׼��')){
				return false;
			}
			<%
				'�����fc����market director�����Ʒ��������
				if (roleid="6" or roleid="4") and rs("productmodel")=2 and (rs("issplit")<>1) then
				%>
				alert('��ȴ�Priceing��ּ۸�');
				return false;
				<%
				end if 
			%>
			statusid=<%=approveid%>;
		}else if(res==2){
			if(!confirm('ȷ�����أ�')){
				return false;
			}
			statusid=<%=rejectid%>;
		}else if(res==3){
			if(!confirm('ȷ��Ҫ�󲹳���ϣ�')){
				return false;
			}
		}
		form.action="specialApprove.asp?actiontype=1&result="+res+"&statusid="+statusid;
		form.submit();
	}
	function toReport(sid,qid)
	{
		window.open("Quotation_Report.asp?sid="+sid+"&qid="+qid,'','width=1024px,height=768px,resizable=yes')
	}
	function goBack()
	{
		location.href="specialList.asp";
	}
	function savePMComments()
	{
		$.post("special_saveComments.asp",{sid:$("#specialId").val(),comments:$("#pm_comments").val()},function(data){
			alert("����ɹ�");
			location.reload();
		});
		
	}
</script>
</head>

<body bgcolor="#ffffff" leftmargin="0" topmargin="0">
<form action="specialApprove.asp" method="post">
<input type="hidden" name="specialId" id="specialId" value="<%=rs("id")%>">
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
                      <div align="left">Quotation NO: �����ļ��ţ�<br>
                    </div></td>
                    <td width="30%"> 
                      <div align="left"> <%=rs("quotationno")%>&nbsp;</div></td>
                    <td width="20%">
<div align="left">Quotation Details: �������飺</div></td>
                    <td width="30%">
<div align="left"><a href="#" onclick="toReport('<%=rs("id")%>','<%=rs("quotationid")%>');return false;">Supporting 
                        Information</a></div></td>
                </tr>
                <tr class="line01"> 
                  <td> <div align="left">Business Model: ҵ��ģʽ��</div></td>
                  <td> <div align="left"> 
				   <select name="show_businessModel" id="show_businessModel">
						<%
							for i=1 to ubound (BUSINESS_MODEL)
						%>
						 <option value="<%=BUSINESS_MODEL(i,0)%>"><%=BUSINESS_MODEL(i,1)%></option>
						<%
							
							next
						%>
                      </select>
				  &nbsp; </div></td>
                  <td> <div align="left">Currency: ���ҵ�λ��<br>
                    </div></td>
                  <td> <div align="left"><%=rs("currencycode")%> &nbsp; </div></td>
                </tr>
				 <tr class="line01"> 
                  <td height="25"> <div align="left">Payment Term: ���ʽ��<br>
                    </div></td>
                  <td> <div align="left">  <input type="hidden" name="paymentterm" id="paymentterm">
                      <select name="show_paymentterm" id="show_paymentterm">
						<option value=""></option>
                       <%
							for i=1 to 6
						%>
						  $("<option value='<%=PAYMENT_TERM(i,0)%>'><%=PAYMENT_TERM(i,1)%></option>").appendTo("select[name='paymentTerm']");
						<%
							next
						%>
                      </select>
                    </div></td>
                  <td><div align="left">Special Payment Term: ���⸶�ʽ��</div></td>
                  <td> <div align="left"> 
						<%=rs("spec_paymentterm")%>&nbsp;
                    </div></td>
                </tr>
                <tr class="line01"> 
                  <td height="25"> <div align="left">Single/Multi Modality:<br>
                        ��һ/�����Ʒ�ͺţ�<br>
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
				  &nbsp; </div></td>
                  <td bgcolor="lightgreen" title="���ڱ���Quotation ��Ŀ���(����Ŀ��۸�+��������Ʒ+����Ԥ������+���Ᵽ�޷���)"><div align="left">Target 
                        OIT Price: Ŀ������ۣ�</div></td>
                  <td bgcolor="lightgreen"> <div align="left"><%=rs("TargetOITPrice")%> &nbsp; </div></td>
                </tr>
                <tr class="line01"> 
                  <td height="25"><div align="left">Tender Document No: �б��ļ��ţ�</div></td>
                  <td><div align="left"><%=rs("tenderno")%> &nbsp; </div></td>
                  <td bgcolor="lightgreen"  title="����Philips�豸��Ŀ��ۣ�Quotation Part I : Philips Product Net Target Price&#13(�����豸�۸�+��׼��װ+��׼��ѵ+��׼����+Standard ������)"><div align="left">Net 
                        Target Price: ��Ŀ��۸�<br>
                    </div></td>
                  <td bgcolor="lightgreen"><div align="left"><%=rs("NetTargetPrice")%> &nbsp; </div></td>
                </tr>
                <tr class="line01"> 
                  <td height="25"><div align="left">Final User (Hospital) Name:<br>
                        �����û����ƣ�</div></td>
                  <td><div align="left"> <%=rs("username")%>&nbsp; </div></td>
                  <td bgcolor="yellow"  title="���ڱ���Ԥ���Ľ�����(����Ŀ���+��������Ʒ+����Ԥ������+���Ᵽ�޷���)"><div align="left">Estimated OIT Price:<br>
                        Ԥ���Ľ����ۣ�<br>
                    </div></td>
                  <td bgcolor="yellow"><div align="left"><%=rs("Estimated_OITPrice")%> &nbsp; </div></td>
                </tr>
                <tr class="line01"> 
                  <td height="25"><div align="left">Bidder: Ͷ���ˣ�</div></td>
                  <td><div align="left"><%=rs("bidder")%> &nbsp; </div></td>
                  <td><div align="left" title="����Philips�豸��Ԥ�������۸�(Ԥ�������ۡ���������Ʒ������Ԥ�����á����Ᵽ�޷���)">Estimated Net OIT Price:<br>
                        Ԥ���ľ������ۣ�<br>
                    </div></td>
                  <td><div align="left"> <%=rs("Estimated_NetOITPrice")%>&nbsp; </div></td>
                </tr>
                <tr class="line01"> 
                  <td><div align="left">Contracting Party: ��ͬ����</div></td>
                  <td><div align="left"> <%=rs("contract_Party")%>&nbsp; </div></td>
                  <td title="=(Ԥ���ľ�������-��Ŀ��۸�)/(��Ŀ��۸�)"><div align="left">Special Discount Requested:<br>
                        �ؼ��ۿ�����<br>
                    </div></td>
                  <td><div align="left">
				  <font color="red">
				  <%=rs("specialdiscount")%>
				  %</font>
				  &nbsp;</div></td>
                </tr>
                <tr class="line01"> 
                  <td> <div align="left">Tender Closing Date:<br>
                        Ͷ���ֹ���ڣ�</div></td>
                  <td> <div align="left"><%=rs("TENDER_CLOSEDATE")%> &nbsp; </div></td>
                  <td> <div align="left">&nbsp;Application Date: �������ڣ�</div></td>
                  <td> <div align="left"><%=displayTime2(rs("Application_DATE"))%> &nbsp; </div></td>
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
                  <td><div align="left">Key Account Profile: �ͻ��ſ���</div></td>
                </tr>
                <tr class="line02"> 
                  <td width="25%" height="25" style="word-break:break-all"> <div align="left"><%=rs("KeyAccountProfile")%> &nbsp; <br>
                    <!--  <a href="#">������Ϣ </a><br>  -->
                    </div></td>
                </tr>
                <tr class="line01"> 
                  <td ><div align="left">Project Brief: ��Ŀ��飺</div></td>
                </tr>
                <tr class="line02"> 
                  <td style="word-break:break-all"><div align="left"><%=rs("ProjectBrief")%> &nbsp; <br>
                     <!--   <a href="#">������Ϣ </a> <br>  -->
                      <br>
                    </div></td>
                </tr>
                <tr class="line01"> 
                  <td><div align="left">Main Competitor: ��Ҫ�������֣�</div></td>
                </tr>
                <tr class="line02"> 
                  <td style="word-break:break-all"> <div align="left"> <%=rs("Competitor")%>&nbsp; <br>
                    </div></td>
                </tr>
                <tr class="line01"> 
                  <td><div align="left">Competitor Price w/o. VAT: �������ּ۸�</div></td>
                </tr>
                <tr class="line02"> 
                  <td style="word-break:break-all"><div align="left"> <%=rs("CompetitorPrice")%>&nbsp; <br>
                    </div></td>
                </tr>
                <tr class="line01"> 
                  <td><div align="left">Estimated Tender/Win Bid Price: Ԥ��Ͷ��/�б�ۣ�</div></td>
                </tr>
                <tr class="line02"> 
                  <td style="word-break:break-all"><div align="left"><%=rs("TenderPrice")%> &nbsp; <br>
                    </div></td>
                </tr>
			<tr class="line01"> 
                  <td><div align="left">Uploaded Files: ���ϴ��ļ���</div></td>
                </tr>
                <tr class="line02"> 
                  <td><div align="left" id="fileZone"> 
				  <% 
					While Not rsfiles.eof 
						response.write("<a href='../include/downloadFile.asp?path="&rsfiles("filepath")&"&fname="&rsfiles("filename")&"'  target='_blank'>"&rsfiles("filename")&"</a><br>")
						rsfiles.movenext
					wend
				  %>
                    </div></td>
                </tr>
	
                <tr class="line02"> 
                  <td><p>&nbsp;</p>
                    <p align="right">&nbsp; </p></td>
                </tr>
              </table></td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td> <table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td class="titleorange"><strong>Review History:������¼:</strong></td>
          </tr>
          <tr> 
            <td valign="top"> <table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td width="13%" height="25"> <div align="center">Time</div></td>

                  <td width="15%">Name</td>
                  <td width="14%" height="25"> <div align="center">Results</div></td>
                  <td width="46%">Comments</td>
                </tr>
				<% While Not rsApprove.bof  And Not rsApprove.eof %>
                <tr class="line01"> 
                  <td height="25"><div align="center"> 
                      <p class="textgrey"><%=displaytime2(rsApprove("approvetime"))%>&nbsp;</p>
                    </div></td>
                  <td><%=rsApprove("username")%>&nbsp;</td>
                  <td height="25"><div align="left"> 
                      <p class="textgrey">
					  <% If rsApprove("result")="1" Then
							response.write("Approved")
						ElseIf rsApprove("result")="2" THEN
							response.write("Rejected")
						ElseIf rsApprove("result")="3" Then
							response.write("Additional Information")
						End if
					  %>&nbsp; </p>
                    </div></td>
                  <td style="word-break:break-all;"><div align="left"> 
                     <%=rsApprove("remark")%>&nbsp;
                    </div></td>
                </tr>
				<%
					rsApprove.movenext
					wend
				%>
              </table></td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
<% If productModel=2 Then %>
	
	   <tr> 
		  <td>
		  <table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
			  <tr> 
				<td class="titleorange"><strong>Comments of MKT BU Director��</strong></td>
			  </tr>
			  <tr> 
				<td valign="top">
				<table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
					<% While Not rsApprove3.eof %>
					<tr class="line01"> 
						<td width="13%" > <p class="textgrey"><%=displaytime2(rsApprove3("approvetime"))%>&nbsp;</p></td>
						<td width="10%"  nowrap><%=rsApprove3("username")%>&nbsp;</td>
					  <td width="77%"  height="25" style="word-break:break-all"> <div align="left"> 
						 <%=rsApprove3("remark")%>&nbsp;
						</div></td>
					</tr>
					<% rsApprove3.movenext
					  Wend 
					%>
				  </table>
				  </td>
			  </tr>
			</table>
		  </td>
		</tr>
<% End If %>
	 <tr> 
      <td>&nbsp;</td>
    </tr>
	<% If Not IsNull(rs("resubmitremark")) And  rs("resubmitremark")<>"" then %>
	<tr> 
      <td>
	  <table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td class="titleorange"><strong>Reasons for Resubmitting���ٴ��ύ��������ɣ�</strong></td>
          </tr>
          <tr> 
            <td valign="top">
			<table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
				<% While Not rsApprove2.eof %>
                <tr class="line01"> 
					<td width="10%" > <p class="textgrey"><%=displaytime2(rsApprove2("approvetime"))%>&nbsp;</p></td>
                  <td width="90%"  height="25" style="word-break:break-all"> <div align="left"> 
                     <%=rsApprove2("remark")%>&nbsp;
                    </div></td>
                </tr>
				<% rsApprove2.movenext
				  Wend 
				%>
              </table>
			  </td>
          </tr>
        </table>
	  </td>
    </tr>
	 <tr> 
      <td>&nbsp;</td>
    </tr>
	<% End If %>
	<% If viewtype<>"viewDetail" Then %>
    <tr> 
      <td><table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td><table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td><div align="left">Comments</div></td>
                </tr>
                <tr class="line02"> 
                  <td width="25%" height="25"> <div align="left"> 
                      <textarea name="comments" cols="100" rows="4"></textarea>
                      <br>
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
      <td><div align="right"> 
          <input type="button" name="Submit3" value="Approve" onclick="doApprove(1);">
          <input type="button" name="Submit2" value="Reject" onclick="doApprove(2);">
		  <% If rs("isAdditional")<>1 Then %>
		  <input type="button" name="Submit1" value="Additional Information" onclick="doApprove(3);">
		  <% End If %>
          <input type="Reset" name="Submit4" value="Return" onclick="goBack();">
        </div></td>
    </tr>
	<% End If %>
	<% If viewtype="viewDetail" then%>
		<% If roleid="3" And (rs("status")=2 Or rs("status")=3)  And productModel=2  Then %>
		<tr> 
      <td><table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td><table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td><div align="left">Comments</div></td>
                </tr>
                <tr class="line02"> 
                  <td width="25%" height="25"> <div align="left"> 
                      <textarea name="pm_comments" id="pm_comments" cols="100" rows="4"></textarea>
                      <br>
                    </div></td>
                </tr>
              </table></td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <%   end if  %>
	    <tr> 
      <td><div align="right"> 
	  <% If roleid="3" And (rs("status")=2 Or rs("status")=3) And productModel=2  Then %>
			<input type="button" name="back" value="Save Comments" onclick="savePMComments();">
	    <%   end if  %>
          <input type="button" name="back" value="Return" onclick="history.back();">&nbsp;&nbsp;&nbsp;&nbsp;
        </div></td>
    </tr>
	<% End If %>
  </table>
  <!--#include file="../footer.asp"-->
</div>
<script>
	$("#show_paymentterm").val('<%=rs("paymentterm")%>');
	$("#show_businessModel").val('<%=rs("businessmodel")%>');
	$("#productModel").val('<%=rs("productModel")%>');
	$("#show_paymentterm").attr({"disabled":"disabled"});
	$("#show_businessModel").attr({"disabled":"disabled"});
	$("#productModel").attr({"disabled":"disabled"});
</script>
</form>
</body>
</html>
<%
	rs.close
	Set rs=Nothing
	rsApprove.close
	Set rsApprove=Nothing
	rsApprove2.close
	Set rsApprove2=Nothing
	rsApprove3.close
	Set rsApprove3=Nothing
	rsfiles.close
	Set rsfiles=Nothing 
	'�ر����ݿ�����
	CloseDatabase
%>
