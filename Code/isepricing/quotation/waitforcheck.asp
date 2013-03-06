<%
	Sub makeWaitForCheck
		sql="update quotation set status=4 where status<>2 and status<>3 and status<>13"
		conn.execute(sql)
		conn.execute("update quotation_detail set isprocess=0 where qid in(select qid from quotation where  status<>2 and status<>3  and status<>13)")
		Call makeSpecialPending
	End Sub
	
	'对于特价：
	'1.如果是new 和 reject状态，大库发布后保持原状态，在提交的时候弹出提醒
	'2.非new，非 reject状态，变为wait dm to check状态，根据编辑后的信心再决定
	Sub makeSpecialPending
		sql="update special_price set ispending=1 where quotationid in (select qid from quotation where  status<>2 and status<>3  and status<>13) and ((status<>'-11' and status>0) or status='-9')  "
		conn.execute(sql)

		sql="update special_price set isedit=0 "
		conn.execute(sql)

		sql="update special_price set isNeedMsg=1 where quotationid in (select qid from quotation where  status<>2 and status<>3  and status<>13) and (status<>'-11' and status<=0 and status<>'-9')"
		conn.execute(sql)
	End Sub 

	Sub makeWaitForCheck3rdConfig(pname)
		sql="update quotation set status=4 where status<>2 and status<>3  and status<>13 and  qid in(select b.qid from quotation_detail_3rd a,quotation_detail b where a.qdid=b.qdid and a.itemname='"&pname&"')"
		conn.execute(sql)
		conn.execute("update quotation_detail set isprocess=0 where qid in(select qid from quotation where  status<>2 and status<>3  and status<>13) and qid in (select b.qid from quotation_detail_3rd a,quotation_detail b where a.qdid=b.qdid and a.itemname='"&pname&"')")

		sql="update special_price set ispending=1 where quotationid in (select qid from quotation where  status<>2 and status<>3  and status<>13)  and  quotationid in(select b.qid from quotation_detail_3rd a,quotation_detail b where a.qdid=b.qdid and a.itemname='"&pname&"') and ((status<>'-11' and status>0) or status='-9')"
		conn.execute(sql)
		sql="update special_price set isNeedMsg=1 where quotationid in (select qid from quotation where  status<>2 and status<>3  and status<>13)  and  quotationid in(select b.qid from quotation_detail_3rd a,quotation_detail b where a.qdid=b.qdid and a.itemname='"&pname&"') and (status<>'-11' and status<=0 and status<>'-9')"
		conn.execute(sql)

		sql="update special_price set isedit=0 where    quotationid in(select b.qid from quotation_detail_3rd a,quotation_detail b where a.qdid=b.qdid and a.itemname='"&pname&"') "
		conn.execute(sql)

	End Sub
	
	Sub makeWaitForCheckProduct(pname)
		sql="update quotation set status=4 where status<>2 and status<>3  and status<>13 and  qid in(select a.qid from quotation_detail a where a.productname='"&pname&"')"
		conn.execute(sql)
		conn.execute("update quotation_detail set isprocess=0 where qid in(select qid from quotation where  status<>2 and status<>3  and status<>13) and qid in (select a.qid from quotation_detail a where  a.productname='"&pname&"')")

		sql="update special_price set ispending=1 where quotationid in (select qid from quotation where  status<>2 and status<>3  and status<>13) and  quotationid in(select a.qid from quotation_detail a where a.productname='"&pname&"')  and ((status<>'-11' and status>0) or status='-9') "
		conn.execute(sql)
		sql="update special_price set isNeedMsg=1 where quotationid in (select qid from quotation where  status<>2 and status<>3  and status<>13) and  quotationid in(select a.qid from quotation_detail a where a.productname='"&pname&"')  and (status<>'-11' and status<=0 and status<>'-9')"
		conn.execute(sql)

		sql="update special_price set isedit=0 where quotationid in(select a.qid from quotation_detail a where a.productname='"&pname&"') "
		conn.execute(sql)
	End Sub  
%>
