<!--#include file="../include/conn.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="quotationVar.asp"-->

<%
	response.Charset="gb2312"
	dim quotationsql
	currencycode=left(currencycode,instr(currencycode,"_")-1)
	if isempty(quotationid) or quotationid="" then    'insert
		quotationsql="insert into QUOTATION(   QUOTATIONNO,tenderno,USERNAME ,NONUSERNAME ,BUSINESSMODEL ,PAYMENTTERM ,SEPC_PARMENTTERM ,DEALERNAME ,currencycode,rate,VERSION ,CRTUSER ,CRTTIME )values('"&quotationNO&"','"&porcSpecWord(tenderno)&"','"&porcSpecWord(hospName)&"','"&porcSpecWord(nonHospName)&"','"&businessModel&"','"&paymentTerm&"','"&porcSpecWord(sepcParment)&"','"&porcSpecWord(dealerName)&"','"&currencycode&"',"&curRate&",'"&getversion(0)&"','"&session("principleid")&"','"&getdate()&"')"
		conn.execute  quotationsql

		set rs=server.CreateObject("adodb.recordset")
		rs.open "select @@identity as qid",conn,1,1
		'response.Write(rs("qid"))
		quotationid=rs("qid")
		rs.close
		set rs=Nothing
	else   'update
		quotationsql="update quotation set quotationno='"&quotationNO&"',tenderno='"&porcSpecWord(tenderno)&"',username='"&porcSpecWord(hospName)&"',nonusername='"&porcSpecWord(nonHospName)&"',businessmodel='"&businessModel&"',paymentterm='"&paymentTerm&"',SEPC_PARMENTTERM='"&porcSpecWord(sepcParment)&"',dealername='"&porcSpecWord(dealerName)&"',updttime='"&getdate()&"',updtuser='"&session("principleid")&"' where qid=" & quotationid
		'response.Write(quotationsql)
		'response.End()
		conn.execute quotationsql
		'response.Write(quotationid)
	end if
	
	CloseDatabase
	
%>

<script>	
	location.href='quotationEdit.asp?qid='+<%=quotationid%>;
</script>
