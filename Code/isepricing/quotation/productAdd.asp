<!--#include file="../include/conn.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="processwaitforcheck.asp"-->
<%
	response.Charset="gb2312"
	dim qid,pid,ot ,strSql,delqdid,newqdid,currencycode
	qid=request("qid")
	pid=request("pid")
	ot=request("ot")
	delqdid=request("delqdid")
	qotedPrice=request("qotedPrice")
	if ot="1" then  'insert 
		strSql="insert into quotation_detail(qid,pid,quotedprice,productname,mid,modalityname,bu,crtuser,crttime) select "&qid&",a.pid,"&qotedPrice&",a.productname,a.mid,a.modality,a.bu,'"&session("principleid")&"','"&getdate()&"' from v_product a where pid="&pid
		conn.execute strsql
		
		conn.execute "update quotation set prodcnt=prodcnt+1 where qid="&qid
	
		'得到刚添加的主键值
		set rsqdid=conn.execute("select @@identity as qdid")
		newqdid=rsqdid("qdid")
		rsqdid.close
		set rsqdid=nothing
	elseif ot="2" then  'delete
		dim rs
		dim sctargetprice,p1,p2,part1,part2,part3,part4,qdid
		currencycode=request("curRate")
	
		set rs=server.createObject("adodb.recordset")
		rs.open "select * from quotation_detail where qid="&qid &" and qdid in("&delqdid & ")",conn,1,1
		while not rs.eof 
			qdid=rs("qdid")
			part1=rs("part1")
			part2=rs("part2")
			part3=rs("part3")
			part4=rs("part4")
			part5=rs("part5")
			PriceAdjustment=rs("adjustprice")
			if part1="" or isnull(part1) then
				part1="0"
			end if
			if part2=""  or isnull(part2)  then
				part2="0"
			end if
			if part3=""  or isnull(part3)  then
				part3="0"
			end if
			if part4=""  or isnull(part4)  then
				part4="0"
			end if
			if part5=""  or isnull(part5)  then
				part5="0"
			end If
			if PriceAdjustment=""  or isnull(PriceAdjustment)  then
				PriceAdjustment="0"
			end if
			p1=cdbl(part1)+cdbl(part2)+cdbl(part3)+cdbl(part4)+CDbl(PriceAdjustment)
			p2=cdbl(part1)+cdbl(part2)+cdbl(part3)+CDbl(PriceAdjustment)
			sctargetprice=cdbl(part5)
	
			conn.execute "update quotation set targetprice=isnull(targetprice,0)-"&p1&",targetpricewew=isnull(targetpricewew,0)-"&p2&",sctargetprice=isnull(sctargetprice,0)-"&sctargetprice&" where qid="&qid 
			conn.execute "update quotation set prodcnt=prodcnt-1 where qid="&qid
			rs.movenext
		wend
		rs.close
		set rs=nothing
		strSql="delete from quotation_detail where qid="&qid &" and qdid in("&delqdid & ")"
		'delete product
 		conn.execute strsql
		'delete configration
		conn.execute "DELETE FROM QUOTATION_DETAIL_PHILIPS where qdid in("&delqdid & ")"
		conn.execute "DELETE FROM QUOTATION_DETAIL_3RD where qdid in("&delqdid & ")"
		conn.execute "DELETE FROM quotation_detail_provision where qdid in("&delqdid & ")"
		

		'处理waitforcheck
		'Call processWaitForCheck(qid)
	end if
	
	CloseDatabase
	if not isempty(newqdid) and  newqdid<>"" then
		response.Write(newqdid)
	Else
		//response.Write("success")
		response.Redirect("quotationEdit.asp?qid="&qid)
	end if
%>
