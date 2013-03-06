<!--#include file="../include/conn.asp"-->
<!--#include file="../include/chkUser.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="processwaitforcheck.asp"-->
<%
	dim qid,pid,qdid
	qid=request("qid")
	pid=request("pid")
	qdid=request("qdid")
	currencyrate=request("currencyrate")
	currencycode=request("currencycode")

	PriceAdjustment=request("PriceAdjustment")
	AdjustmentReason=request("AdjustmentReason")
	If IsNull(PriceAdjustment) Or PriceAdjustment="" Then
		PriceAdjustment=0
	End if
	dim rs,oldpart1,oldpart2,oldpart3,oldpart4,oldpart5
	set rs=server.createObject("adodb.recordset")
	rs.open "select * from quotation_detail where qid="& qid &" and qdid= "& qdid,conn,1,1

	if not rs.eof then
		oldpart1=rs("part1")
		oldpart2=rs("part2")
		oldpart3=rs("part3")
		oldpart4=rs("part4")
		oldpart5=rs("part5")
		oldAdjustmentReason=rs("adjustprice")
	end if
	rs.close
	set rs=nothing
	if oldpart1="" or isnull(oldpart1) then
		oldpart1="0"
	end if
	if oldpart2=""  or isnull(oldpart2)  then
		oldpart2="0"
	end if
	if oldpart3=""  or isnull(oldpart3)  then
		oldpart3="0"
	end if
	if oldpart4=""  or isnull(oldpart4)  then
		oldpart4="0"
	end if
	if oldpart5=""  or isnull(oldpart5)  then
		oldpart5="0"
	end If
	if oldAdjustmentReason=""  or isnull(oldAdjustmentReason)  then
		oldAdjustmentReason="0"
	end if
	'开启事务
	conn.BeginTrans
	'清除philipse配置
	conn.execute "DELETE FROM QUOTATION_DETAIL_PHILIPS where qdid="&qdid
	'清除第3方配置
	conn.execute "DELETE FROM QUOTATION_DETAIL_3RD where qdid="&qdid
	'清除自定义配置
	conn.execute "DELETE FROM quotation_detail_provision where qdid="&qdid
	'保存必选标准配置
	dim pdid_musts,must_qty,must_lp,must_qp
	'pdid_musts=request("pdid_musts")
	pdid_musts=request("must_ids")
	must_qty=request("must_qty")
	must_lp=request("must_lp")
	must_qp=request("must_qp")
	strSql="INSERT INTO QUOTATION_DETAIL_PHILIPS (qdid,PDID,CID ,TYPE ,ITEMS ,MATERIALNO ,DESCRIPTION ,LISTPRICE ,QTY ,QUOTEDPRICE ,TARGETPRICE ,DISCOUNT ,CRTUSER ,CRTTIME)  select "&qdid&" ,PDID,cid,type,items,materialno,description,listprice*"&currencyrate&",qty,qty*targetprice*"&currencyrate&",targetprice*"&currencyrate&",discount,"&session("principleid")&",'"&getdate()&"' from   product_detail_philips where type=0 and pdid in("&pdid_musts&")"  'pid=" & pid &" and type=0"
		'response.Write(strsql)
		conn.execute strSql
		

	
	'保存第3方标准配置
	If currencycode=CURRENCY_CHINA Then 
		columnName="unitcostrmb"
	Else
		columnName="unitcost*"&currencyrate
	End if
	thr_must_ids=request("thr_must_ids")
	'response.write("<br><br>"+thr_must_ids)
	If Not IsNull(thr_must_ids) and Trim(thr_must_ids)<>""  then
	strsql="INSERT INTO QUOTATION_DETAIL_3RD (QDID ,PDID,CID ,TYPE ,PARTYTYPE ,MATERIALNO ,itemname,UNITCOST ,QTY, quotedprice,crtuser,crttime )select  "&qdid&" ,PDID, cid,type,0,materialno,itemname,"&columnName&",qty,qty*"&columnName&","&session("principleid")&",'"&getdate()&"' from PRODUCT_DETAIL_3RD where type=0 and pdid in("&thr_must_ids&")" 'pid="&pid
	'response.Write("<br>"+strsql)
	conn.execute strsql
	End if
	
	'保存第3方可选配置
	dim thr_opts,thr_opt_qty,thr_opt_lp,thr_opt_qp
	thr_opts=request("thr_opts")
	thr_opt_qty=request("thr_opt_qty")
	thr_opt_lp=request("thr_opt_lp")
	thr_opt_qp=request("thr_opt_qp")

	thr_opts_arr=split(thr_opts,",")
	thr_opt_qty_arr=split(thr_opt_qty,",")
	thr_opt_lp_arr=split(thr_opt_lp,",")
	thr_opt_qp_arr=split(thr_opt_qp,",")

	for i=0 to ubound(thr_opts_arr)
	if thr_opts_arr(i)<>"" then
	strsql="INSERT INTO QUOTATION_DETAIL_3RD (QDID ,PDID,CID ,TYPE ,PARTYTYPE ,MATERIALNO,itemname ,UNITCOST ,QTY, quotedprice,crtuser,crttime )select  "&qdid&" , '',pid,1,0,itemcode materialno,itemname ,"&thr_opt_lp_arr(i)&","&thr_opt_qty_arr(i)&","&thr_opt_qp_arr(i)&","&session("principleid")&",'"&getdate()&"' from party where state=0 and status=0 and itemcode=(select itemcode from party where pid="&thr_opts_arr(i) &") "
		conn.execute strsql
		end if
	next
	
	'保存不在第3方配件表中的配件
	dim thr_var_materialno,thr_var_qty,thr_var_lp,thr_var_qp,quotationstatus,remark,thr_var_itemname
	thr_var_materialno=request("thr_var_materialno")
	thr_var_itemname=request("thr_var_itemname")
	thr_var_qty=request("thr_var_qty")
	thr_var_lp=request("thr_var_lp")
	thr_var_qp=request("thr_var_qp")
	thr_var_mate_arr=split(thr_var_materialno,",")
	thr_var_itemname_arr=split(thr_var_itemname,",")
	thr_var_qty_arr=split(thr_var_qty,",")
	thr_var_lp_arr=split(thr_var_lp,",")
	thr_var_qp_arr=split(thr_var_qp,",")
	quotationstatus="0" 
	for i=0 to ubound(thr_var_qty_arr)
		thr_materialno=""
		if  isnull(thr_var_materialno) or  isempty(thr_var_materialno)  or thr_var_materialno="" then
			
		elseif not isempty(thr_var_mate_arr(i))  then
			thr_materialno=thr_var_mate_arr(i)
		end if
		if thr_var_qty_arr(i)<>"" then
		strsql="INSERT INTO QUOTATION_DETAIL_3RD (QDID,pdid ,TYPE ,PARTYTYPE ,MATERIALNO,itemname ,QTY,UNITCOST , quotedprice,crtuser,crttime )values("&qdid&",0,3,1,'"&Replace(trim(thr_materialno),"'","''")&"','"&Replace(trim(thr_var_itemname_arr(i)),"'","''")&"','"&thr_var_qty_arr(i)&"','"&thr_var_lp_arr(i)&"','"&thr_var_qp_arr(i)&"','"&session("principleid")&"','"&getdate()&"')"
			'response.Write(strsql)
			'RESPONSE.END
			conn.execute strsql
		end if
	next
	
	'保存philips可选标准配置
	'查询出折扣
	set rsrate=conn.execute("select OTHERDISCOUNT from product where pid="&pid)
	otherdiscount=rsrate("OTHERDISCOUNT")
	if isnull(otherdiscount) or otherdiscount="" then
		otherdiscount=1
	end if
	rsrate.close
	set rsrate=Nothing
	'列出所有已出现的materialno：philips必选件，philips可选件，第3方必选件，第3方可选件
	Dim allMaterialno
	 Set rs_m1=conn.execute("select materialno from   product_detail_philips where type=0 and pdid in("&pdid_musts&")")
	 While Not rs_m1.eof
		allMaterialno=allMaterialno&",'"&rs_m1("materialno")  &"'"
		rs_m1.movenext
	 Wend 
	rs_m1.close()
	Set rs_m1=Nothing 
	If Not IsNull(thr_must_ids) and Trim(thr_must_ids)<>""  then
		 Set rs_m2=conn.execute("select materialno from PRODUCT_DETAIL_3RD where type=0 and pdid in("& thr_must_ids &")")
		  While Not rs_m2.eof
			allMaterialno=allMaterialno&",'"&rs_m2("materialno")  &"'"
			rs_m2.movenext
		 Wend 
		 rs_m2.close()
		Set rs_m2=Nothing 
	End  If 
	 for i=0 to ubound(thr_opts_arr)
	if thr_opts_arr(i)<>"" then
	 Set rs_m3=conn.execute("select  itemcode materialno from party where pid="&thr_opts_arr(i))
	  While Not rs_m3.eof
		allMaterialno=allMaterialno&",'"&rs_m3("materialno")  &"'"
		rs_m3.movenext
	 Wend 
	 rs_m3.close()
	Set rs_m3=Nothing 
	end if
	next
	allMaterialno=Right(allMaterialno,Len(allMaterialno)-1)




	dim pdid_opts,opt_qty,opt_lp,opt_qp
	pdid_opts=request("opts")
	opt_qty=request("opt_qty")
	opt_lp=request("opt_lp")
	opt_qp=request("opt_qp")
	opt_isConfig=request("opt_isConfig")
	pdid_opt_arr=split(pdid_opts,",")
	opt_qty_arr=split(opt_qty,",")
	opt_lp_arr=split(opt_lp,",")
	opt_qp_arr=split(opt_qp,",")
	opt_isConfig_arr=Split(opt_isConfig,",")    '是否是key options
	key_options=""
	key_materialno=""
	for i=0 to ubound(pdid_opt_arr)
		If opt_isConfig_arr(i)="0" Or  opt_isConfig_arr(i)=0 Then
			 Set rs_m4=conn.execute(" select  materialno from   CONFIGURATIONS where  cid="&pdid_opt_arr(i))
			  While Not rs_m4.eof
				allMaterialno=allMaterialno&",'"&rs_m4("materialno")  &"'"
				rs_m4.movenext
			 Wend 
			rs_m4.close()
			Set rs_m4=Nothing 
		
		Else   '查询所有Materialno
			If key_options<>"" Then
				key_options=key_options&","&pdid_opt_arr(i)
			Else
				key_options=pdid_opt_arr(i)
			End If 
			
			 Set rs_m5=conn.execute("select materialno from product_detail_philips where pid="& pid &" and type=1 and pdid="&pdid_opt_arr(i))
			  While Not rs_m5.eof
				allMaterialno=allMaterialno&",'"&rs_m5("materialno")  &"'"
				
				If key_options<>"" Then
					key_materialno=key_materialno&",'"&rs_m5("materialno")  &"'"
				Else
					key_materialno="'"&rs_m5("materialno")  &"'"
				End If 
				rs_m5.movenext
			 Wend 
			rs_m5.close()
			Set rs_m5=Nothing 
		End if
	Next

	for i=0 to ubound(pdid_opt_arr)
		If opt_isConfig_arr(i)="0" Or  opt_isConfig_arr(i)=0 Then
			strSql="INSERT INTO QUOTATION_DETAIL_PHILIPS (qdid,pdid,CID ,TYPE ,ITEMS ,MATERIALNO ,DESCRIPTION  ,LISTPRICE ,QTY ,QUOTEDPRICE ,TARGETPRICE ,DISCOUNT ,CRTUSER ,CRTTIME)  select  "&qdid&" ,0 pdid,cid,1,'' items,materialno,description,listprice*"&currencyrate&","&opt_qty_arr(i)&","&opt_qp_arr(i)&",listprice*"&currencyrate&"*"&otherdiscount&" as targetprice,'"&otherdiscount&"',"&session("principleid")&",'"&getdate()&"' from   CONFIGURATIONS where state=0 and status=0 and  materialno=(select materialno from CONFIGURATIONS where  cid="&pdid_opt_arr(i) &")" 
		Else
			'根据key options的名称，来得到其在新的配置关系中的id
			Set rs_newKeyOptions=conn.execute("select pdid from product_detail_philips  where type=1 and materialno=(select materialno from product_detail_philips where pdid="&pdid_opt_arr(i)&")  and items=(select items from product_detail_philips where pdid="&pdid_opt_arr(i)&")  and  PID="&pid)
			If Not rs_newKeyOptions.eof And Not rs_newKeyOptions.bof Then
				newKeyOptionsid=rs_newKeyOptions("pdid")
				'key options,需要判断items的是否可以享受更低折扣
				tmpsql="select PDID ,PID ,CID ,TYPE ,ITEMS ,MATERIALNO ,DESCRIPTION ,LISTPRICE ,QTY , (case when discount2 is not null and discount2<discount then LISTPRICE*discount2 else LISTPRICE*discount end)TARGETPRICE,(case when discount2 is not null and discount2<discount then discount2 else discount end) discount ,mutex ,sortno  from( SELECT PDID ,PID ,CID ,TYPE ,ITEMS ,MATERIALNO ,DESCRIPTION ,LISTPRICE ,QTY ,TARGETPRICE ,DISCOUNT ,(select min(discount) discount from PRODUCT_OPTION_DISCOUNT where options in("&allMaterialno&") and pid=a.pid and  items=a.items ) discount2 ,mutex ,sortno from product_detail_philips a where  a.type=1 )tmp where tmp.pid="& pid &" and tmp.pdid ="&newKeyOptionsid

				strSql="INSERT INTO QUOTATION_DETAIL_PHILIPS (qdid,pdid,CID ,TYPE ,ITEMS ,MATERIALNO ,DESCRIPTION  ,LISTPRICE ,QTY ,QUOTEDPRICE ,TARGETPRICE ,DISCOUNT ,CRTUSER ,CRTTIME)  select  "&qdid&" ,pdid,cid,type,items,materialno,description,listprice*"&currencyrate&","&opt_qty_arr(i)&","&opt_qty_arr(i)&"*targetprice*"&currencyrate&",targetprice*"&currencyrate&",discount,"&session("principleid")&",'"&getdate()&"' from ("& tmpsql &")tmp2   "
				'product_detail_philips where pid="& pid &" and type=1 and pdid="&pdid_opt_arr(i)
			End If
			rs_newKeyOptions.close()
			Set rs_newKeyOptions=Nothing 
		End if
		conn.execute strsql
	Next
	'response.End()
	'重新计算part1：原来直接从页面取值，现在从数据库取值=标准值+type=1的值
	stdPrice=request("stdPrice")
	Set rs_part1=conn.execute("select isnull(convert(int,sum(quotedprice)),0)quotedprice from quotation_detail_philips where qdid="&qdid&" and type=1")
	If Not rs_part1.bof And Not rs_part1.eof Then
		part1=CLng(stdPrice)+CLng(rs_part1("quotedprice"))
	End If 
	rs_part1.close()
	Set rs_part1=Nothing 


	'保存Provision
	dim pro_ma,pro_qty,pro_lp,pro_qp
	pro_ma=request("pro_materialno")
	pro_qty=request("pro_qty")
	pro_lp=request("pro_lp")
	pro_qp=request("pro_qp")
	pro_ma_arr=split(pro_ma,",")
	pro_qty_arr=split(pro_qty,",")
	pro_lp_arr=split(pro_lp,",")
	pro_qp_arr=split(pro_qp,",")
	for i=0 to ubound(pro_ma_arr)
		strsql="INSERT INTO quotation_detail_provision (qdid ,materialno ,qty ,unitcost ,quotedprice,crtuser ,crttime) VALUES ("&qdid&",'"&Replace(trim(pro_ma_arr(i)),"'","''")&"',"&pro_qty_arr(i)&","&pro_lp_arr(i)&","&pro_qp_arr(i)&",'"&session("principleid")&"','"&getdate()&"')"
		conn.execute strsql
	next
	
	'保存其他费用
	'Extended Warranty 
	dim fi,ficharged,fiamount,ibp,ibpcharged,ibpamount,atamount,sbp,sbpcharged,sbpamount,ewbp,ewbpyear,ewbpprice,comments,site
	dim sewbp,sewbpyear,sewbpprice
	dim part1,part2,part3,part4
	fi=request("fi")
	ficharged=request("ficharged")
	fiamount=request("fiamount")
	ibp=request("ibps")
	ibpcharged=request("ibpcharged")
	ibpamount=request("ibpamount")
	ibpcharged=request("ibpcharged")
	ibpamount=request("ibpamount")
	atamount=request("atamount")
	sbp=request("swbps")
	sbpcharged=request("sbpcharged")
	sbpamount=request("sbpamount")
	ewbp=request("ewbp")
	ewbpyear=request("ewbpyear")
	ewbpprice=request("ewbpprice")
	sewbp=request("sewbp")
	sewbpyear=request("sewbpyear")
	sewbpprice=request("sewbpprice")
	comments=request("comments")
	site=request("site")
	
	'part1=request("part1")
	part2=request("part2")
	part3=request("part3")
	if ewbp="1" then
		part4=cdbl(ewbpprice)
	else
		part4=0
	end if
	if sewbp="1" then
		part4=part4+cdbl(sewbpprice)
	else
		part4=part4+0
	end if
	dim sctargetprice
	sctargetprice=request("part4")
	
	dim p1,p2
	p1=cdbl(part1)+cdbl(part2)+cdbl(part3)+cdbl(part4)+CDbl(PriceAdjustment)
	p2=cdbl(part1)+cdbl(part2)+cdbl(part3)+CDbl(PriceAdjustment)
	
	
	strsql="update quotation_detail set fi='"&fi&"',ficharged='"&ficharged&"',fiamount='"&fiamount&"',ibp='"&ibp&"',ibpcharged='"&ibpcharged&"',ibpamount='"&ibpamount&"',atamount='"&atamount&"',sbp='"&sbp&"',sbpcharged='"&sbpcharged&"',sbpamount='"&sbpamount&"',ewbp='"&ewbp&"',ewbpyear='"&ewbpyear&"',ewbpprice='"&ewbpprice&"',sewbp='"&sewbp&"',sewbpyear='"&sewbpyear&"',sewbpprice='"&sewbpprice&"',comments='"&Replace(comments,"'","''")&"',site='"&site&"',part1="&part1&",part2="&part2&",part3="&part3&",part4="&part4&",part5="&sctargetprice&",targetprice="&p1&",targetpricewew="&p2&",ADJUSTPRICE='"&PriceAdjustment&"',ADJUSTCOMMENTS='"&Replace(AdjustmentReason,"'","''")&"',pid='"&pid&"',updtuser='"&session("principleid")&"',updttime='"&getdate()&"' where qdid="&qdid
	'response.Write(strsql)
	conn.execute strsql
	
	
	'response.Write("<br>"&oldpart1)
	p1=cdbl(p1)-(cdbl(oldpart1)+cdbl(oldpart2)+cdbl(oldpart3)+cdbl(oldpart4)+CDbl(oldAdjustmentReason))
	p2=cdbl(p2)-(cdbl(oldpart1)+cdbl(oldpart2)+cdbl(oldpart3)+CDbl(oldAdjustmentReason))
	sctargetprice=cdbl(sctargetprice)-cdbl(oldpart5)
	conn.execute "update quotation set targetprice=isnull(targetprice,0)+"&p1&",targetpricewew=isnull(targetpricewew,0)+"&p2&",sctargetprice=isnull(sctargetprice,0)+"&sctargetprice&" ,updtuser='"&session("principleid")&"' ,updttime='"&getdate()&"' where qid="&qid
	
	'处理waitforcheck
	conn.execute("update quotation_detail set isprocess=1 where  qdid="&qdid)

	If conn.errors.count = 0 Then
		conn.CommitTrans
	Else
		conn.RollbackTrans
	End If

	'处理waitforcheck

	'Call processWaitForCheck(qid)
	CloseDatabase
%>
<script >
	//window.opener.plusPrice('<%=p1%>','<%=p2%>','<%=sctargetprice%>');
	//window.close();
	window.opener.refreshWindow();
	window.close();
</script>
