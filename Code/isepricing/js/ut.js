function openDialog(url,width,height) {
	//window.showModalDialog(url,self,'dialogHeight:' + height + 'px;dialogWidth:' + width + 'px;status:no;scroll:yes;help:no')
	window.open(url, '','height='+height+', width='+width+', top=0, left=0, toolbar=no, menubar=no, scrollbars=yes, resizable=yes,location=no, status=no');
}

/*
if str > 0 and str is Integer return ture else return false
*/
function isPlusInt(str){
	if (str == "") return true;
	var regu = "^[0-9]*[1-9][0-9]*$";
	var re = new RegExp(regu);
	return re.test(str);
}


function formatNumber(num,pattern){  
  var strarr = num?num.toString().split('.'):['0'];  
  var fmtarr = pattern?pattern.split('.'):[''];  
  var retstr='';  
  
  // 整数部分  
  var str = strarr[0];  
  var fmt = fmtarr[0];  
  var i = str.length-1;    
  var comma = false;  
  for(var f=fmt.length-1;f>=0;f--){  
    switch(fmt.substr(f,1)){  
      case '#':  
        if(i>=0 ) retstr = str.substr(i--,1) + retstr;  
        break;  
      case '0':  
        if(i>=0) retstr = str.substr(i--,1) + retstr;  
        else retstr = '0' + retstr;  
        break;  
      case ',':  
        comma = true;  
        retstr=','+retstr;  
        break;  
    }  
  }  
  if(i>=0){  
    if(comma){  
      var l = str.length;  
      for(;i>=0;i--){  
        retstr = str.substr(i,1) + retstr;  
        if(i>0 && ((l-i)%3)==0) retstr = ',' + retstr;   
      }  
    }  
    else retstr = str.substr(0,i+1) + retstr;  
  }  
  
  retstr = retstr+'.';  
  // 处理小数部分  
  str=strarr.length>1?strarr[1]:'';  
  fmt=fmtarr.length>1?fmtarr[1]:''; 
  fmt="#";
  i=0;  
  for(var f=0;f<fmt.length;f++){  
    switch(fmt.substr(f,1)){  
      case '#':  
        if(i<str.length) retstr+=str.substr(i++,1);  
        break;  
      case '0':  
        if(i<str.length) retstr+= str.substr(i++,1);  
        else retstr+='0';  
        break;  
    }  
  }  
  retstr=retstr.replace(/^,+/,'').replace(/\.$/,'');  
  retstr=Math.round(retstr);
  return retstr;
}  