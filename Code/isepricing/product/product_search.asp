<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/commons.asp"-->
<!--#include file="../include/chkUser.asp"-->

<%
Page=request("Page")
bu = request("bu")
modality = request("modality")
product = request("product")
status = request("status")

isnew = "0"  '�Ƿ�������
iscopy = "0"  '�Ƿ���copy
isslsubmit = "0"   '�Ƿ���specialist�ύ
ispmsubmit = "0"   '�Ƿ���PM�ύ
ispmreject = "0"   '�Ƿ���PM Reject
iseditproduct = "0"   '�Ƿ����޸�����
iseditprice = "0"   '�Ƿ����޸ļ۸�
isdelete = "0"    '�Ƿ���ɾ������
isgobacksl = "0"   '�Ƿ����˻ص�specialist
isgobackpm = "0"   '�Ƿ����˻ظ�PM
isreject = "0"     '�Ƿ����˻ظ�PM
ispricesubmit = "0"   '�Ƿ���pricing�ύ
isdirectsubmit = "0"   '�Ƿ���director�ύ
isfasubmit = "0"   '�Ƿ���FA�ύ
isdispnot = "0"   '�Ƿ�����ʾNot Available״̬�Ĳ�ѯ���
isnotcopy = "0"   '�Ƿ��ܸ���ҳ��

If IsNull(bu) Or bu = "" Then
	bu = 1
End If 

If session("roleid") = 2 Or session("roleid") = 3 Then
	bu = session("user_bu")
End If 
If session("user_bu") <> "" Then
	bu = session("user_bu")
End If 

If status = "" Then 
	status = "0"
End If 

sql = "select a.*, b.bu, b.modality from product a, modality b where a.mid=b.mid and a.state='0' and b.status='0'"
If bu <> "" Then
	sql = sql & " and b.bu=" & bu
End If 
If modality <> "" Then
	sql = sql & " and a.mid=" & modality
End If 
If product <> "" Then
	sql = sql & " and a.productname like '%" & product & "%'"
End If 
If status = "0" Or status = "1" Then 
	sql = sql & " and a.status='" & status & "'"
Else 
	sql = sql & " and a.status!='0' and a.status!='1'"
End If 

'If session("roleid") = 2 Then
'	sql = sql & " and a.crtuser='" & session("userid") & "'"
'End If 

sql = sql & " order by b.bu, b.modality, a.standardprice"


Set rs = conn.execute(sql)

sqlst = "select distinct a.status from product a, modality b where a.mid=b.mid and a.state='0' and b.status='0' and a.version='" & getversion("1") & "' and b.bu=" & bu
Set rsst = conn.execute(sqlst)

'��ɫ��Ȩ�޿���
If session("roleid") = 1 Then
	'Pricing
	isdispnot = "1"
	iseditproduct = "1"
	iseditprice = "1"
	isdelete = "1"
	If status = "-1" Then 
		While Not rsst.eof
			If rsst("status") = "4" Then
				isgobacksl = "1"
				isgobackpm = "1"
				ispricesubmit = "1"
			End If 
			rsst.movenext
		Wend 
	End If 
ElseIf session("roleid") = 2 Then
	'Specialist
	isdispnot = "1"
	If rsst.eof Then
		'����BU��״̬ʱ���Ҳ�ѯ״̬Ϊδ��Чʱ������������Ʒ
		If status = "-1" Then 
			isnew = "1"
		End If 
		'����BU��״̬ʱ�����Ը��Ʋ�Ʒ
		iscopy = "1"
	Else
		'�д�BU��״̬ʱ
		sqlstr2 = "select distinct a.status from product a, modality b where a.mid=b.mid and a.state='0' and b.status='0' and a.version='" & getversion("1") & "' and b.bu=" & bu & " and a.crtuser='" & session("userid") & "'"
		Set rsstr2 = conn.execute(sqlstr2)
		isflag = ""
		While Not rsst.eof
			'����BU״̬Ϊ�����á���ƷרԱ�ύʱ�����п���������Ʒ�����Ʋ�Ʒ���޸Ĳ�Ʒ
			If rsst("status") = "2" Or rsst("status") = "3" Then
				If rsstr2.eof Then
					'���˲�ƷרԱδ¼���Ʒʱ������������Ʒ�����Ʋ�Ʒ���޸Ĳ�Ʒ
					If status = "-1" Then 
						isnew = "1"
						iseditproduct = "1"
						''''''''''''''���ڡ�baijian.bj.han@philips.com���ʺţ�����editprice����
						If session("userid") = "baijian.bj.han@philips.com" Then 
							iseditprice = "1"
						End If 
						isdelete = "1"
					End If 
					iscopy = "1"
				Else 
					'ѭ����BU�ı��˵����в�Ʒ״̬������һ����Ʒ״̬��Ϊ������ʱ��������������Ʒ�����Ʋ�Ʒ���޸Ĳ�Ʒ���ύ��Ʒ
					While Not rsstr2.eof
						If rsstr2("status") = "2" Then
							isflag = "1"
						End If 
						rsstr2.movenext
					Wend 
					If isflag = "1" Then
						If status = "-1" Then 
							isnew = "1"
							iseditproduct = "1"
							''''''''''''''���ڡ�baijian.bj.han@philips.com���ʺţ�����editprice����
							If session("userid") = "baijian.bj.han@philips.com" Then 
								iseditprice = "1"
							End If 
							isslsubmit = "1"
							isdelete = "1"
						End If 
						iscopy = "1"
					End If 
				End If 
			End If 
			rsst.movenext
		Wend 
	End If 
ElseIf session("roleid") = 3 Then
	'PM
	isdispnot = "1"
	ispmsubmitflag = ""
	If status = "-1" Then
		While Not rsst.eof
			If rsst("status") = "3" Then
				iseditproduct = "1"
				iseditprice = "1"
				ispmreject = "1"
			Else
				ispmsubmitflag = "1"
			End If 
			rsst.movenext
		Wend 
		If ispmsubmitflag <> "1" Then
			ispmsubmit = "1"
		End If 
	End If 
ElseIf session("roleid") = 4 Then
	'Marketing Director
	isdispnot = "1"
	If status = "-1" Then
		While Not rsst.eof
			If rsst("status") = "5" Or rsst("status") = "7" Then
				isreject = "1"
				isdirectsubmit = "1"
			End If 
			rsst.movenext
		Wend 
	End If 
ElseIf session("roleid") = 5 Then
	'Fiancial Analyst
	isdispnot = "1"
ElseIf session("roleid") = 6 Then
	'Financial Controller
	isdispnot = "1"
	If status = "-1" Then
		While Not rsst.eof
			If rsst("status") = "5" Or rsst("status") = "6" Then
				isreject = "1"
				isfasubmit = "1"
			End If 
			rsst.movenext
		Wend 
	End If 
ElseIf session("roleid") = 7 Or session("roleid") = 8 Or session("roleid") = 9 Then 
	isnotcopy = "1"
End If 

count=0
While Not rs.eof
  count=count+1
  rs.movenext
Wend 

'��ҳ
if page="" or isEmpty(page) then 
    Page=1
End if
PageSize=10 'ÿҳ����
if PageSize=0 then 
    PageSize=1
End if
PageCount=int((count-1)/PageSize)+1
if PageCount=0 then 
    Page=0
End if
Page=int(Page)
Startpage=(Page-1)*PageSize+1
EndPage=Startpage+PageSize

URLCS = "bu=" & bu & "&modality=" & modality & "&product=" & product

Set rs = conn.execute(sql)

%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title>IS E-pricing system</title>
<link href="../css/css.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="../js/jquery-1.2.6.js"></script>

<%
If isnotcopy = "1" Then 
%>
<script language="javascript">

document.oncontextmenu=new Function("event.returnValue=false;");

document.onselectstart=new Function("event.returnValue=false;"); 

//document.getElementById("modalityselect").style.display = "block";
</script>
<%
End If 
%>
<script language="javascript">
var xmlHttp
/*����XMLHTTP�������MS��ActiveXObject����������ɹ���IE���������ʹ��MS ActiveXʵ��������һ��XMLHTTP����*/ 
//��IE��ת�ý���һ������Javascript�����XMLHttp���� ���˷���ȷ����ͬ������¶�AJAX��֧�֣�
function createXMLHttp(){
    if(window.ActiveXObject){
        xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
    }
    else if(window.XMLHttpRequest){
        xmlHttp = new XMLHttpRequest();
    }
}

//����������
function startXMLHttp(bu, modality){
    createXMLHttp(); //����xmlHttp ����
    xmlHttp.open("get","modality_choose_ajax.asp?bu=" + bu + "&modality=" + modality,true); //����һ���µ�http���󣬴��ͷ�ʽ ��ȡ��ҳ�� �첽���(���Ϊ�����Զ�����dodo����)
    xmlHttp.send(); //����
	xmlHttp.onreadystatechange =doaction; //xmlHttp�µ�onreadystatechange���� ���ƴ��͹���
}

function doaction(){
    if(xmlHttp.readystate==4){ // xmlHttp�µ�readystate���� 4��ʾ�������
        if(xmlHttp.status==200){ // xmlHttp��status������ȡ״̬��������HTTP״̬�룩 200��ӦOK 404��ӦNot Found��δ�ҵ�����
             document.getElementById("modalityselect").innerHTML=xmlHttp.responseText //xmlHttp��responseText���� �õ���ȡҳ����
			 <%
			 if isnotcopy = "1" then
			 %>
			 document.getElementById("modalityselect").style.display = "none";
			 <%
			 end if 
			 %>
           }
	}
}

function PageTo(str) {
    if (str > <%=PageCount%>)
    {
        alert ("This page is the last one!")
        return;
    }

    if (str < 1)
    {
        alert ("This page is the first one!")
        return;
    }
    
    document.form1.action="product_search.asp?<%=URLCS%>&Page="+str;
    document.form1.submit();
 }

function deleteproduct(pid, bu){
	if (confirm("Confirm to delete product?")){
		document.form1.action="product_delete_submit.asp?pid=" + pid + "&bu=" + bu;
		document.form1.submit();
	}
}

function rejectproduct(pid){
	if (confirm("Do you want to reject the product?")){
		document.form1.action="product_pmreject_submit.asp?pid=" + pid;
		document.form1.submit();
	}
}

function specialistsubmit(buname){
	if (confirm("Do you want to submit the product?")){
		document.form1.action="product_submit.asp?roleid=2";
		document.form1.submit();
	}
}

function pmsubmit(buname){
	if (confirm("Do you want to submit the Price Guideline?")){
		document.form1.action="product_submit.asp?roleid=3";
		document.form1.submit();
	}
}

function pricingsubmit(){
	buname = $("select[name='bu']").find("option:selected").text();
	if (confirm("Do you want to submit the Price Guideline?")){
		document.form1.action="product_submit.asp?roleid=1";
		document.form1.submit();
	}
}

function directorsubmit(){
	buname = $("select[name='bu']").find("option:selected").text();
	if (confirm("Do you confirm to approve the Price Guideline?")){
		document.form1.action="product_submit.asp?roleid=4";
		document.form1.submit();
	}
}

function fasubmit(){
	buname = $("select[name='bu']").find("option:selected").text();
	if (confirm("Do you confirm to approve the Price Guideline?")){
		document.form1.action="product_submit.asp?roleid=6";
		document.form1.submit();
	}
}

function gobackspecialist(){
	buname = $("select[name='bu']").find("option:selected").text();
	if (confirm("Do you want to reject the product?")){
		document.form1.action="product_goback.asp?backtostatus=2";
		document.form1.submit();
	}
}

function gobackpm(){
	buname = $("select[name='bu']").find("option:selected").text();
	if (confirm("Do you want to reject the Price Guideline?")){
		document.form1.action="product_goback.asp?backtostatus=3";
		document.form1.submit();
	}
}

function gotopmreject(){
	buname = $("select[name='bu']").find("option:selected").text();
	if (confirm("You will the " + buname + " goback to PM, confirm it?")){
		document.form1.action="product_pmreject.asp";
		document.form1.submit();
	}
}
</script>
</head>

<body bgcolor="#ffffff" leftmargin="0" topmargin="0" onload="startXMLHttp('<%=bu%>', '<%=modality%>')">
<div align="center">
  <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td><table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
          <tr> 
            <td class="titleorange"><div align="center">Price Guideline</div></td>
          </tr>
          <tr> 
            <td class="titleorange">&nbsp;</td>
          </tr>
          <tr> 
            <td valign="top" class="line01">
			  <form name="form1" method="post" action="product_search.asp">
			  <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
                <tr> 
                  <td>
				    <table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                      <tr class="line01"> 
                        <td width="25%" height="25"> <div align="left">BU: 
                            <br>
                          </div></td>
                        <td width="25%"> <div align="left"> 
							<%
							If session("roleid") = 2 Or session("roleid") = 3 Or session("user_bu") <> "" Then 
							%>
								<%=BU_TYPE(session("user_bu"), 1)%>
								<input type="hidden" name="bu" value="<%=session("user_bu")%>">
							<%
							Else 
							%>
                            <select name="bu" onchange="startXMLHttp(this.value, '<%=modality%>')">
                              <%
							  For i = 1 To UBound(BU_TYPE)
							  %>
							  <option VALUE="<%=BU_TYPE(i,0)%>" <%If CStr(bu) = CStr(BU_TYPE(i,0)) Then %> selected <%End If %>><%=BU_TYPE(i,1)%></option>
							  <%
							  Next 
							  %>
                            </select>
							<%
							End If 
							%>
                          </div></td>
                        <td width="25%"> <div align="left"><%If isnotcopy <> "1" Then %>Modality:<% End If %>&nbsp; </div></td>
                        <td width="25%"><div id="modalityselect" align="left"> 
                            
                          </div>&nbsp;</td>
                      </tr>
                      <tr class="line01"> 
                        <td height="25"> <div align="left">Product: </div></td>
                        <td > <div align="left"> 
                            <input type="text" name="product" value="<%=product%>">
                          </div></td>
                        <td width="25%"> <div align="left">Status: </div></td>
                        <td width="25%"><div align="left"> 
                            <select name="status">
							  <option value="0" <%If status="0" Then %> selected <%End If %>>Active</option>
							  <%
							  If isdispnot = "1" Then 
							  %>
							  <option value="-1" <%If status="-1" Then %> selected <%End If %>>Pending</option>
							  <%
							  End If 
							  %>
							  <option value="1" <%If status="1" Then %> selected <%End If %>>Inactive</option>
							</select>
                          </div></td>
                      </tr>
                    </table></td>
                </tr>
              </table>
              <p align="right"> 
                <input type="submit" name="Submit" value="Search">&nbsp;&nbsp;
				<%
				If isnew = "1" Then 
				%>
				<input type="button" name="newproduct" value="New Product" onclick="location.href='product_add.asp'">&nbsp;&nbsp;
				<%
				End If
				If isslsubmit = "1" Then 
				%>
				<input type="button" name="newproduct" value="Submit" onclick="specialistsubmit('<%=BU_TYPE(session("user_bu"), 1)%>');">&nbsp;&nbsp;
				<%
				End If 
				If ispmsubmit = "1" Then 
				%>
				<input type="button" name="newproduct" value="Submit" onclick="pmsubmit('<%=BU_TYPE(session("user_bu"), 1)%>');">&nbsp;&nbsp;
				<%
				End If 
				If isgobacksl = "1" Then 
				%>
				<input type="button" name="newproduct" value="Reject to PM" onclick="gobackspecialist();">&nbsp;&nbsp;
				<%
				End If 
				If isgobackpm = "1" Then 
				%>
				<input type="button" name="newproduct" value="Reject to BU Director" onclick="gobackpm();">&nbsp;&nbsp;
				<%
				End If 
				If isreject = "1" Then 
				%>
				<input type="button" name="newproduct" value="Reject" onclick="gobackpm();">&nbsp;&nbsp;
				<%
				End If 
				If ispricesubmit = "1" Then 
				%>
				<input type="button" name="newproduct" value="Submit" onclick="pricingsubmit();">&nbsp;&nbsp;
				<%
				End If 
				If isdirectsubmit = "1" Then 
				%>
				<input type="button" name="newproduct" value="Approve" onclick="directorsubmit();">&nbsp;&nbsp;
				<%
				End If  
				If isfasubmit = "1" Then 
				%>
				<input type="button" name="newproduct" value="Approve" onclick="fasubmit();">&nbsp;&nbsp;
				<%
				End If 
				%>
              </p>
			  </form>
			</td>
          </tr>
          <tr> 
            <td class="line02">&nbsp; </td>
          </tr>
          <tr> 
            <td><table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#CCCCCC" cellspacing="0" cellpadding="0" >
                <tr class="line01"> 
                  <td>Version</td>
				  <%
				  If session("roleid") <> 7 And session("roleid") <> 8 And session("roleid") <> 9 Then 
				  %>
                  <td >Modality</td>
				  <%
				  End If 
				  %>
                  <td >Product</td>
                  <td >Standard Net Target Price</td>
				  <%
				  If session("roleid") <> 7 And session("roleid") <> 8 And session("roleid") <> 9 Then 
				  %>
                  <td >Create by</td>
				  <%
				  End If 
				  %>
                  <td >Promotion</td>
                  <td>Start date</td>
                  <td>End date</td>
                  <td >Status</td>
                  <td >Details</td>
				  <%
				  If iscopy = "1" Then 
				  %>
                  <td >Copy</td>
				  <%
				  End If 
				  If iseditproduct = "1" Then 
				  %>
				  <td>Edit Product</td>
				  <%
				  End If 
				  If iseditprice = "1" Then 
				  %>
				  <td>Edit Price</td>
				  <%
				  End If 
				  If isdelete = "1" Then 
				  %>
				  <td>Delete</td>
				  <%
				  End If 
				  If ispmreject = "1" Then 
				  %>
				  <td>Reject</td>
				  <%
				  End If 
				  %>
                </tr>
				<%
				y = 0
				While Not rs.eof
					y = y + 1
					If y>=StartPage And y<EndPage Then
				%>
					<tr class="line02">
					  <td><%=rs("version")%></td>
					  <%
					  If session("roleid") <> 7 And session("roleid") <> 8 And session("roleid") <> 9 Then 
					  %>
					  <td><%=rs("modality")%></td>
					  <%
					  End If 
					  %>
					  <td><%=rs("productname")%></td>
					  <td><%=rs("standardprice")%>&nbsp;</td>
				      <%
				      If session("roleid") <> 7 And session("roleid") <> 8 And session("roleid") <> 9 Then 
				      %>
					  <td><%=rs("crtuser")%></td>
					  <%
					  End If 
					  %>
					  <td><%If IsNull(rs("remark")) Or rs("remark") = "" Then %>N<% Else %>Y<% End If %></td>
					  <td><%=displaytime(rs("starttime"))%>&nbsp;</td>
					  <td><%=displaytime(rs("endtime"))%>&nbsp;</td>
					  <td><%=PRODUCT_STATUS(rs("status"))%></td>
					  <td><a href="product_detail.asp?pid=<%=rs("pid")%>">Details</a></td>
					  <%
					  If iscopy = "1" Then 
					  %>
					  <td><a href="product_addcopy.asp?pid=<%=rs("pid")%>">Copy</a></td>
					  <%
					  End If 
					  If iseditproduct = "1"Then 
					  %>
					  <td>&nbsp;
					    <%
						If (session("roleid") <> 2 And session("roleid") <> 3) Or (session("roleid") = 2 And rs("status") = "2") Or (session("roleid") = 3 And rs("status") = "3") Then 
						%>
					      <a href="product_edit.asp?pid=<%=rs("pid")%>">Edit Product</a>
						<%
						End If 
						%>
					  </td>
					  <%
					  End If 
					  If iseditprice = "1" Then 
					  %>
					  <td>&nbsp;
					    <%
						If session("roleid") <> 3 Or (session("roleid") = 3 And rs("status") = "3") Then 
						%>
					      <a href="product_editprice.asp?pid=<%=rs("pid")%>">Edit Price</a>
						<%
						End If 
						%>
					  </td>
					  <%
					  End If 
					  If isdelete = "1" Then 
					  %>
					  <td>&nbsp;
					    <%
						If session("roleid") <> "2" Or (session("roleid") = "2" And rs("status") = "2") Then 
						%>
					      <a href="javascript:deleteproduct(<%=rs("pid")%>, <%=rs("bu")%>);">Delete</a>
						<%
						End If 
						%>
					  </td>
					  <%
					  End If 
					  If ispmreject = "1" Then 
					  %>
					  <td>&nbsp;
					    <%
						If session("roleid") <> 3 Or (session("roleid") = 3 And rs("status") = "3") Then 
						%>
					      <a href="javascript:rejectproduct(<%=rs("pid")%>);">Reject</a>
						<%
						End If 
						%>
					  </td>
					  <%
					  End If 
					  %>
					</tr>
				<%
					End If 
					rs.movenext
				Wend 
				%>
              </table></td>
          </tr>
		  <tr>
		    <td>
			<TABLE height="34" cellSpacing="0" cellPadding="0" width="100%" background='../img/bg_bt.gif' border="0">
				<TBODY>
				<tr class="line01">
				  <td align="right">
					Record Count:<%=Count%>&nbsp;&nbsp;Page:<%=Page%>/<%=PageCount%>
				  </td>
				  <td noWrap align="middle" width="70%">
					First Page&nbsp;
					<A href="javascript:PageTo('1')">|&lt;&lt;</A>
					&nbsp;&nbsp; 
					<A href="javascript:PageTo('<%=Page-1%>')">&lt;&lt;</A>
					&nbsp;&nbsp; 
					<A href="javascript:PageTo('<%=Page+1%>')">&gt;&gt;</A>
					&nbsp;&nbsp; 
					<A href="javascript:PageTo('<%=PageCount%>')">&gt;&gt;|</A>
					&nbsp;Last Page
				  </td>
				</tr>
				</TBODY>
			  </TABLE>
			</td>
		  </tr>
        </table></td>
    </tr>
  </table>
  <!--#include file="../footer.asp"-->
</div>
</body>
</html>
