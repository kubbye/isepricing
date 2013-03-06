//��֤�Ƿ������֣������С����
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

//��֤�Ƿ��ǽ��
function currency(str){
	var reg = /^\d+(\.\d+)?$/;
	if (reg.test(str) && !isNaN(str))
		return true;
	else
		return false;
}


/****************************************************
function	:	cTrim(sInputString,iType)
description	:	�ַ���ȥ�ո�ĺ���
parameters	:	iType��	1=ȥ���ַ�����ߵĿո�
						2=ȥ���ַ�����ߵĿո�
						0=ȥ���ַ�����ߺ��ұߵĿո�
return value:	ȥ���ո���ַ���
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
