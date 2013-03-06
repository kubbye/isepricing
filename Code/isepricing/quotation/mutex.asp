<!--#include file="../include/conn.asp"-->
<!--#include file="../include/constant.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="processwaitforcheck.asp"-->
<%
	pid=request("pid")
	pdid_opts=request("opts")
	opt_isConfig=request("opt_isConfig")
	pdid_opt_arr=split(pdid_opts,",")
	opt_isConfig_arr=Split(opt_isConfig,",")    '是否是key options
	key_options=""
	key_materialno=""

	for i=0 to ubound(pdid_opt_arr)
		If opt_isConfig_arr(i)="0" Or  opt_isConfig_arr(i)=0 Then
			s=""
		Else   '查询所有Materialno
				
			If key_options<>"" Then
				key_options=key_options&","&pdid_opt_arr(i)
			Else
				key_options=pdid_opt_arr(i)
			End If 
	
			 Set rs_m5=conn.execute("select materialno from product_detail_philips where pid="& pid &" and type=1 and pdid="&pdid_opt_arr(i))
			  While Not rs_m5.eof
				If key_materialno<>"" Then
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

	'判断是否keyoption互斥
	huchi_config=""
	If key_options<>"" Then
			sql_huchi="select count(*) as cnt,mutex from product_detail_philips where pdid in ("&key_options&") and mutex!='' and mutex is not null group by mutex"

			Set rs_huchi=conn.execute(sql_huchi)
			While Not rs_huchi.eof 
				If rs_huchi("cnt")>1 Then
					'查找该mutex的备件
					mt_index=rs_huchi("mutex")
					sql_mt="select materialno from product_detail_philips where type=1  and  pdid in ("&key_options&") and mutex='"& mt_index &"'"
					Set rs_mt=conn.execute(sql_mt)
					huchi_config=""
					While Not rs_mt.eof 
						If huchi_config<>"" Then
								huchi_config=huchi_config&","&rs_mt("materialno") 
						Else
							huchi_config=rs_mt("materialno") 
						End If 
						rs_mt.movenext
					Wend 
					rs_mt.close
					Set rs_mt=Nothing 
					If huchi_config<>"" Then
						'弹出提示
						response.write(huchi_config)
						response.End()
					End If 
				End If
				rs_huchi.movenext
			Wend 
			rs_huchi.close
			Set rs_huchi=nothing
	End If 

	CloseDatabase
%>
