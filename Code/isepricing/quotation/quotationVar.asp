<%
	dim quotationid,quotationNO,hospName,beginDate,endDate,productName,businessModel,nonHospName,paymentTerm,dealerName,currencycode,curRate,tenderno
	Dim sepcParment,shStatus
	quotationid=request("qid")
	quotationNO=request("quotationNO")
	tenderno=request("tenderno")
	hospName=request("hospName")
	beginDate=request("beginDate")
	endDate=request("endDate")
	productName=request("productName")
	businessModel=request("businessModel")
	nonHospName=request("nonHospName")
	paymentTerm=request("paymentTerm")
	dealerName=request("dealerName")
	currencycode=request("currencycode")
	curRate=request("curRate")
	sepcParment=request("sepcParment")
	shStatus=request("shStatus")
%>
