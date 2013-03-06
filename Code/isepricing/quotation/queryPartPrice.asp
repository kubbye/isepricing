<!--#include file="../include/conn.asp"-->
<%
	dim qid,part1,part2,part3,part4
	qid=request("qid")
	set rs=conn.execute("select sum(part1) part1,sum(part2)part2,sum(part3)part3,sum(part4)part4,sum(adjustprice) PriceAdjustment from quotation_detail where qid="&qid)
	part1=rs("part1")
	part2=rs("part2")
	part3=rs("part3")
	part4=rs("part4")
	PriceAdjustment=rs("PriceAdjustment")
	if isnull(part1) or isempty(part1) or part1="" then
		part1="0"
	end if
	if isnull(part2) or isempty(part2) or part2="" then
		part2="0"
	end if
	if isnull(part3) or  isempty(part3) or part3="" then
		part3="0"
	end if
	if  isnull(part4) or isempty(part4) or part4="" then
		part4="0"
	end if
	if PriceAdjustment=""  or isnull(PriceAdjustment)  then
		PriceAdjustment="0"
	end If
	PriceAdjustment=CDbl(PriceAdjustment)
	'part1=CDbl(part1)+CDbl(PriceAdjustment)	
	rs.close
	set rs=nothing
	CloseDatabase
	
	response.Write(part1&","&part2&","&part3&","&part4&","&PriceAdjustment)
%>


