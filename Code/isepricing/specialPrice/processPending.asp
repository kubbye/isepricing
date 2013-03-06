<!--#include file="../include/sendMail2.asp"-->
<%
	Sub processPending(qid)
		Dim oitprice,targetprice,oldpridediscount,discount,oldtargetprice,oldestargetpriceesoitprice,ispending,currencyrate
		Dim sid
		Dim ifDiscountChange
		ifDiscountChange=False 
		sql="select a.*,(select count(distinct bu) from quotation_detail where qid=a.qid)productmodel,(select isnull(sum(part1),0)+isnull(sum(adjustprice),0) from quotation_detail where qid=a.qid ) standardprice  from quotation a where qid="&qid
		Set rs_quotation=conn.execute(sql)
		oitprice=rs_quotation("targetprice")
		targetprice=rs_quotation("standardprice")
		currencyrate=rs_quotation("rate")
		productmodel=rs_quotation("productmodel")
		
		sql="select * from special_price where quotationid="&qid
		set rs_spe_price=server.CreateObject("adodb.recordset")
		rs_spe_price.open sql,conn,1,3 
		If Not rs_spe_price.bof And Not rs_spe_price.eof Then
			sid=rs_spe_price("id")
			
			pd=1
			If productmodel>1 Then
				pd=2
			End If
			
				'先记录下special_price的上次的结果
		sql="INSERT INTO SPECIAL_PRICE_HIS (id,quotationid ,quotationno ,tenderno ,username ,currencyCODE ,businessmodel ,PRODUCTMODEL ,BIDDER ,CONTRACT_PARTY ,TENDER_CLOSEDATE ,TargetOITPrice ,NetTargetPrice ,Estimated_OITPrice ,Estimated_NetOITPrice ,SpecialDiscount ,Application_DATE ,KeyAccountProfile ,ProjectBrief ,Competitor ,CompetitorPrice ,TenderPrice ,status ,crtuser ,crttime ,updtuser ,updttime ,spec_paymentterm ,paymentterm ,isAdditional ,pm_comments ,ispending ,resubmitremark ,OPERDATE) select id, quotationid ,quotationno ,tenderno ,username ,currencyCODE ,businessmodel ,PRODUCTMODEL ,BIDDER ,CONTRACT_PARTY ,TENDER_CLOSEDATE ,TargetOITPrice ,NetTargetPrice ,Estimated_OITPrice ,Estimated_NetOITPrice ,SpecialDiscount ,Application_DATE ,KeyAccountProfile ,ProjectBrief ,Competitor ,CompetitorPrice ,TenderPrice ,status ,crtuser ,crttime ,updtuser ,updttime ,spec_paymentterm ,paymentterm ,isAdditional ,pm_comments ,ispending ,resubmitremark,'"&getdate()&"' from special_price where id="&sid
		'conn.execute(sql)
			'更新价格和信息
			sql="update special_price set productmodel='"&pd&"', targetoitprice='"&oitprice&"',nettargetprice='"&targetprice&"' where id="&sid 
			conn.execute(sql)

			'如果是reject或者new保持不变，如果为非（reject&new），进行更改操作
			sql="update special_price set ispending=9 where status<>'-11' and status>0 and id="&sid 
			conn.execute(sql)

			sql="update special_price set username=(case when b.username is not null and b.username!='' then b.username else b.nonusername end) ,businessmodel=b.businessmodel,tenderno=b.tenderno,paymentterm=b.paymentterm, spec_paymentterm=b.sepc_parmentterm from special_price a left join quotation b on a.quotationid=b.qid where b.qid="&qid
			conn.execute(sql)
		End If

		'发送邮件
		If ifDiscountChange Then
			Call sendmailDiscountChange(sid)
		End If 

		rs_quotation.close
		Set rs_quotation=Nothing 
		rs_spe_price.close
		Set rs_spe_price=Nothing 
	End sub
%>