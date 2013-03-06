//验证是否是数字（允许带小数）
function isPlusNumeric(str){
	if(str.indexOf('-') != -1){
		return false;
	}
	var reg = /^\d+.?\d*$/;
	if (reg.test(str) && !isNaN(str))
		return true;
	else
		return false;
}

//验证是否是金额
function currency(str){
	var reg = /^\d+(\.\d+)?$/;
	if (reg.test(str) && !isNaN(str))
		return true;
	else
		return false;
}


/****************************************************
function	:	cTrim(sInputString,iType)
description	:	字符串去空格的函数
parameters	:	iType：	1=去掉字符串左边的空格
						2=去掉字符串左边的空格
						0=去掉字符串左边和右边的空格
return value:	去掉空格的字符串
****************************************************/
function cTrim(sInputString,iType)
{
	var sTmpStr = ' ';
	var i = -1;
	
	if(iType == 0 || iType == 1)
	{
		while(sTmpStr == ' ')
		{
			++i;
			sTmpStr = sInputString.substr(i,1);
		}
		sInputString = sInputString.substring(i);
	}	
	if(iType == 0 || iType == 2)
	{
		sTmpStr = ' ';
		i = sInputString.length;
		while(sTmpStr == ' ')
		{
			--i;
			sTmpStr = sInputString.substr(i,1);
		}
		sInputString = sInputString.substring(0,i+1);
	}
	return sInputString;
}
