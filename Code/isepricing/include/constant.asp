<%
	 dim BUSINESS_MODEL(3,2) 'BUSINESS_MODEL
	 dim PAYMENT_TERM(12,2)   'PAYMENT_TERM 
	 Dim SPECIAL_PRODUCTMODEL(2,2)  'PRODUCTMODEL
	 'Dim BU_TYPE(6, 2)	'BU
	 Dim BU_TYPE(8,2)
	Dim CONFIGURATION_STATUS_DISPLAY(2)	'CONFIGURATION��״̬��ʾ
	Dim CONFIGURATION_STATE_DISPLAY(1)	'CONFIGURATION�����ý���״̬
	Dim PRODUCT_STATUS(8)	'PRODUCT��״̬
	dim FI_TYPE(3,3)      'Freight & Insurance

    dim EWBP_COST      'ÿ��ı��ռ�ֵ
	dim CURRENCY_CHINA   '����Ҵ���
	DIM CURRENCY_USA    '��Ԫ���� 
	 dim CONS_PAGESIZE   'ÿҳ��ʾ��¼��

	 Dim VERSION_STATUE(3)  '�汾״̬

	 Dim SERVERURL   '��������ַ
	 Dim EMAILSERVERURL    '�ʼ���������ַ
	 Dim FROMEMAILADD     '�����˵�ַ
	 ''''''''''''''''''''''''''''''''''
	 
	 EWBP_COST=3000
	 CURRENCY_CHINA="CNY"
	 CURRENCY_USA="USD"
	 CONS_PAGESIZE=10
	 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	 BUSINESS_MODEL(0,0)=""
	 BUSINESS_MODEL(0,1)="��ѡ��"
	 BUSINESS_MODEL(1,0)="1"
	 BUSINESS_MODEL(1,1)="Spot Dealer"
	 BUSINESS_MODEL(2,0)="2"
     BUSINESS_MODEL(2,1)="Business partner"
	 BUSINESS_MODEL(3,0)="3"
	 BUSINESS_MODEL(3,1)="Direct Sales"
	 
	 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	 PAYMENT_TERM(0,0)=""
	 PAYMENT_TERM(0,1)="��ѡ��"
	 PAYMENT_TERM(1,0)="1"
	 PAYMENT_TERM(1,1)="100%  T/T in advance"
	 PAYMENT_TERM(2,0)="2"
     PAYMENT_TERM(2,1)="100%  L/C at sight"
	 PAYMENT_TERM(3,0)="3"
	 PAYMENT_TERM(3,1)="90%  L/C at sight; 10%  L/C against acceptance "
	  PAYMENT_TERM(4,0)="4"
	 PAYMENT_TERM(4,1)="90%  T/T in advance,10% T/T against acceptance"
	  PAYMENT_TERM(5,0)="5"
	 PAYMENT_TERM(5,1)="90%  L/C at sight; 10% T/T against acceptance"
	  PAYMENT_TERM(6,0)="6"
	 PAYMENT_TERM(6,1)="90%  T/T in advance, 10%  L/C against acceptance"
 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	
	 SPECIAL_PRODUCTMODEL(1,0)="1"
	 SPECIAL_PRODUCTMODEL(1,1)="Single Modality"
	 SPECIAL_PRODUCTMODEL(2,0)="2"
     SPECIAL_PRODUCTMODEL(2,1)="Multi Modality(Bundle deal)"

	 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	BU_TYPE(0,0) = ""
	BU_TYPE(0,1) = "��ѡ��"
	BU_TYPE(1,0) = 1
	BU_TYPE(1,1) = "CT"
	BU_TYPE(2,0) = 2
	BU_TYPE(2,1) = "MR"
	BU_TYPE(3,0) = 3
	BU_TYPE(3,1) = "NM"
	BU_TYPE(4,0) = 4
	BU_TYPE(4,1) = "iXR"
	BU_TYPE(5,0) = 5
	BU_TYPE(5,1) = "AE"
	BU_TYPE(6,0) = 6
	BU_TYPE(6,1) = "DXR"
	BU_TYPE(7,0) = 7
	BU_TYPE(7,1) = "Oncology"
	BU_TYPE(8,0) = 8
	BU_TYPE(8,1) = "IGIT"


	 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''


	CONFIGURATION_STATUS_DISPLAY(0) = "Active"
	CONFIGURATION_STATUS_DISPLAY(1) = "Pending"
	CONFIGURATION_STATUS_DISPLAY(2) = "Inactive"
	
	CONFIGURATION_STATE_DISPLAY(0) = "Active"
	CONFIGURATION_STATE_DISPLAY(1) = "Pending"
	
	PRODUCT_STATUS(0) = "Active"
	PRODUCT_STATUS(1) = "Inactive"
	PRODUCT_STATUS(2) = "Wait PM to submit"
	PRODUCT_STATUS(3) = "PM Submitted"
	PRODUCT_STATUS(4) = "BU Director Submitted"
	PRODUCT_STATUS(5) = "Pricing Manager Submitted"
	PRODUCT_STATUS(6) = "MD Approved"
	PRODUCT_STATUS(7) = "FC Approved"
	PRODUCT_STATUS(8) = "Waiting to publish"
	
	'''''''''''''''''''''''''''''''''''''''
	FI_TYPE(0,0)=""
	FI_TYPE(0,1)=""
	FI_TYPE(0,1)=""
	FI_TYPE(1,0)="1"
	FI_TYPE(1,1)="CIP"
	FI_TYPE(1,2)="0.005"
	FI_TYPE(2,0)="2"
	FI_TYPE(2,1)="FCA"
	FI_TYPE(2,2)="0"
	FI_TYPE(3,0)="3"
	FI_TYPE(3,1)="CIF"
	FI_TYPE(3,2)="0.003"


 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

	VERSION_STATUE(0) = "Active"
	VERSION_STATUE(1) = "Pending"
	VERSION_STATUE(2) = "Inactive"
'''''''''''''''''''''''''''

SERVERURL = "<br><a href=""http://cnhpekcrb1ms004.code1.emi.philips.com/isepricing/index.asp"">http://cnhpekcrb1ms004.code1.emi.philips.com/isepricing/index.asp</a>"
'EMAILSERVERURL = "smtprelay-asp1.philips.com"
'FROMEMAILADD = "cnhpekcrb1ms004@philips.com"

FROMEMAILADD="kubbye@163.com"
EMAILSERVERURL="smtp.163.com"
%>