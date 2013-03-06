<!--#include file="../specialPrice/processPending.asp"-->

<%
	Sub processWaitForCheck(qid)
		Set rs_procss=conn.execute("select count(*) as cnt from quotation_detail where qid="&qid&" and isprocess=0")
		'如果结果为空，说明已经处理完成
		
		If IsNull(rs_procss("cnt")) Or rs_procss("cnt")="" or rs_procss("cnt")=0 Then
			'如果申请过特价，更新为已申请特价状态;如果申请过特价，并且为reject状态，更新为special reject状态；如果没有，更新为New
			sql="update quotation set status=5,updtuser='"&session("principleid")&"',updttime='"&getdate()&"' where status=4 and qid in(select quotationid from special_price a left join special_approve b on a.id=b.specialid where (b.actiontype=2 or b.actiontype=3) and status<>'-11' and a.quotationid="&qid&")"
			conn.execute(sql)
			'查询特价状态
			Set rs_special_status=conn.execute("select status from special_price where quotationno=(select quotationno from quotation where qid="&qid&")")
			If Not rs_special_status.eof And Not rs_special_status.bof Then
				special_status=rs_special_status("status")
				If CInt(special_status)<-2 And CInt(special_status)<>-11  Then
					sql="update quotation set status=-1 where qid="&qid
				End If 
				If CInt(special_status)=11 Then 
					sql="update quotation set status=5 where qid="&qid
				End If
				conn.execute(sql)
			End If 
			conn.execute(sql)
			sql="update quotation set status=0,updtuser='"&session("principleid")&"',updttime='"&getdate()&"' where status=4 and qid="&qid
			conn.execute(sql)
			Call processPending(qid)
		End If 
		
	End Sub
	
%>
