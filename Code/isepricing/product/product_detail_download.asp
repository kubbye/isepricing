<!--#include file="../include/conn.asp"-->
<!--#include file="../include/utils.asp"-->
<!--#include file="../include/chkUser.asp"-->


<%

pid = request("pid")

sql = "select * from product a, modality b, product_detail_philips c, product_detail_3rd d, product_option_discount e where a.mid=b.mid and a.pid=c.pid and a.pid=d.pid and a.pid=e.pid and a.pid=" & pid
Set rs = conn.execute(sql)

'导出EXECL需要的参数
	dim expyear,expmonth,expday,exphour,expmin,expsecond
	expyear=year(now)
	expmonth=month(now)
	expday=day(now)
	exphour=hour(now)
	expmin=minute(now)
	expsecond=second(now)
  title=ordertype&"ListReport"&expyear&expmonth&expday&exphour&expmin&expsecond
  sql="select "&tablelist&"  from ("&sql&") tmp"
  dim tablecolumnlist
  tablecolumnlist=replace(tablelist,",","  text,")
  tablecolumnlist=tablecolumnlist&"  text"

%>
<%
	dim excelfile,tablename,rs
	set rs=server.CreateObject("adodb.recordset")
	'response.Write(sql)
	'response.End()
	rs.open sql,conn,1,1
	ExcelFile=title&".xls" 
	set fso=Server.CreateObject ("Scripting.FileSystemObject")
	fpath=Server.MapPath(ExcelFile)       
	if fso.FileExists(fpath) then
	 				whichfile=Server.MapPath(ExcelFile)
					  Set fs = CreateObject("Scripting.FileSystemObject")
					  Set thisfile = fs.GetFile(whichfile)
					  thisfile.delete true
	end if
	dim str,connExcel,createSql,insertsql,insertColumnVal
	set connExcel=server.CreateObject("adodb.connection")
	str="Provider=Microsoft.Jet.OLEDB.4.0;Data Source="&server.MapPath(excelfile)&";extended properties=excel 8.0"
	connExcel.open str
	createSql="create table sheet1("&tablecolumnlist&")"
	connExcel.execute(createSql)
	while not rs.eof 
		for i=0 to rs.fields.Count-1
			insertColumnVal=insertColumnVal&"'"&rs(i)&"',"
		next
			insertColumnVal=left(insertColumnVal,len(insertColumnVal)-1)
			insertsql="insert into sheet1 ("&tablelist&") values("&insertColumnVal&")"		
			connExcel.execute(insertSql)

			insertColumnVal=""
			insertsql=""
		rs.movenext
	wend
	connExcel.close
	set connExcel=nothing
%>
<%
	CloseDatabase
%>

<script>
  history.go(-1);
 top.location.href="../exportdata/<%=excelfile%>";
  //window.open("../exportdata/<%=filename%>","dddddddd");
</script>