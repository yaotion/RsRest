Attribute VB_Name = "brisdklib"
Public Const NULL_VB = 0
'2009/10/10
'2009/10/10
'Public Const QNV_DLL_VER = &H101
'Public Const QNV_DLL_VER_STR = "1.01"
'2010/01/08
'Public Const QNV_DLL_VER = &H102
'Public Const QNV_DLL_VER_STR = "1.02"

'2010/02/04 ����c/s socketԶ��ͨ�Žӿ�
'Public Const QNV_DLL_VER = &H103
'Public Const QNV_DLL_VER_STR = "1.03"

'2010/03/05
'Public Const QNV_DLL_VER = &H104
'Public Const QNV_DLL_VER_STR = "1.04"

'2010/09/20
'Public Const  QNV_DLL_VER    =&H105
'Public Const  QNV_DLL_VER_STR="1.05"

'2010/10/29
Public Const QNV_DLL_VER = &H106
Public Const QNV_DLL_VER_STR = "1.06"


Public Const QNV_FILETRANS_VER = &H30301


Public Const QNV_CC_LICENSE = "quniccub_x"

'---------------------------------------------
'typedef  __int64          BRIINT64'���� 64bit(8�ֽ�)
'typedef  __int32          BRIINT32'���� 32bit(4�ֽ�)
'typedef  unsigned __int32             BRIUINT32'�޷��� 32bit(4�ֽ�)
'typedef  __int16          BRIINT16'���� 16bit(2�ֽ�)
'typedef  unsigned __int16         BRIUINT16'���� 16bit(2�ֽ�)
'typedef  unsigned char        BRIBYTE8'�޷��� 8bit(1�ֽ�)
'typedef  char             BRICHAR8'���� 8bit(1�ֽ�)
'typedef  char*            BRIPCHAR8'�ַ���ָ��(ANSI)
'typedef  Integer*           BRIPInteger16'�ַ���ָ��(UNICODE)
'type BRIINT64 = Int64
'type BRIINT32 = Integer
'type BRIUINT32= Cardinal
'type BRIINT16 = Smallint
'type BRIUINT16= Word
'type BRIBYTE8 = Byte
'type BRICHAR8 = Integerint
'type BRIPCHAR8= PChar'^Integerint
'type BRIPInteger16=^Smallint
'---------------------------------------------

'����/¼���ص�ʱ������ظ�ֵ��ϵͳ���Զ�ɾ���ûص�ģ�飬�´ν����ᱻ�ص�
Public Const CB_REMOVELIST = -1
 
Public Const MULTI_SEPA_CHAR = "|"                   '����ļ������б�ָ����
Public Const PROXYDIAL_SIGN = &H40000000             '�������
Public Const PROXYDIAL_SIGN_STRU = "P"               '�������
Public Const PROXYDIAL_SIGN_STRL = "p"               '�������

Public Const RING_BEGIN_SIGN_STR = "0"
Public Const RING_END_SIGN_STR = "1"
Public Const RING_BEGIN_SIGN_CH = "0"
Public Const RING_END_SIGN_CH = "1"

Public Const RINGBACK_TELDIAL_STR = "0"
Public Const RINGBACK_PCDIAL_STR = "1"
Public Const RINGBACK_PCDIAL_CH = "1"
Public Const RINGBACK_TELDIAL_CH = "0"



Public Const DIAL_DELAY_SECOND = ","                '����ʱ����֮���ӳ�1��
Public Const DIAL_DELAY_HSECOND = "."               '����ʱ����֮���ӳ�0.5��
Public Const DIAL_CHECK_CITYCODE = ":"              '����ʱ�÷��ź��Զ����˳�������

Public Const CC_PARAM_SPLIT = ","                   'CC�����ķָ�����



'�Զ�����¼���ļ�ʱ��Ĭ��Ŀ¼��
Public Const RECFILE_DIR = "recfile"
'������Ϣ���KEY
Public Const INI_QNVICC_ = "qnvicc"
'Ĭ�������ļ���
Public Const INI_FILENAME = "cc301config.ini"
'VOIP�������
Public Const CC_VOIP_SIGN = "VOIP"
'������½CC,���������Ϊ��ͬ
Public Const WEB_802ID = "800002000000000000"



Public Const MAX_USB_COUNT = 64                     '֧�ֵ����USBоƬ��
Public Const MAX_CHANNEL_COUNT = 128                '֧�ֵ����ͨ����
'����������Чͨ��ID��
'0->255ΪUSB�豸ͨ����
Public Const SOUND_CHANNELID = 256
'Զ��ͨ��ͨ��,HTTP�ϴ�/����
Public Const REMOTE_CHANNELID = 257
'CC����ͨ��
Public Const CCCTRL_CHANNELID = 258

Public Const SOCKET_SERVER_CHANNELID = 259          'socket ��������ͨ��
Public Const SOCKET_CLIENT_CHANNELID = 260          'socket �ն�ͨ��


Public Const MAX_CCMSG_LEN = 400                    '������Ϣ����󳤶�
Public Const MAX_CCCMD_LEN = 400                    '�����������󳤶�

Public Const DEFAULT_FLASH_ELAPSE = 600             'Ĭ���Ĳ�ɼ��ʱ��(ms)
Public Const DEFAULT_FLASHFLASH_ELAPSE = 1000       'Ĭ���Ĳ�ɺ���һ��ʱ��ص��¼�ms
Public Const DEFAULT_RING_ELAPSE = 1000             'Ĭ�ϸ��ڲ�����/����������ʱ��ms�� 1��
Public Const DEFAULT_RINGSILENCE_ELAPSE = 4000      'Ĭ�ϸ��ڲ�����/�����������ֹͣms 4��
Public Const DEFAULT_RING_TIMEOUT = 12              'Ĭ�ϸ��������峬ʱ����,ÿ��1����4��ͣ,�ܹ�ʱ���ΪN*5
Public Const DEFAULT_REFUSE_ELAPSE = 500            '�ܽ�ʱĬ��ʹ�ü��(ms)
Public Const DEFAULT_DIAL_SPEED = 75                'Ĭ�ϲ����ٶ�ms
Public Const DEFAULT_DIAL_SILENCE = 75              'Ĭ�Ϻ���֮�侲��ʱ��ms
Public Const DEFAULT_CHECKDIALTONE_TIMEOUT = 3000   '��Ⲧ������ʱ��ǿ�ƺ���ms
Public Const DEFAULT_CALLINTIMEOUT = 5500           '�������峬ʱms

'�豸����
Public Const DEVTYPE_UNKNOW = -1                    'δ֪�豸

'cc301ϵ��
Public Const DEVTYPE_T1 = &H1009
Public Const DEVTYPE_T2 = &H1000
Public Const DEVTYPE_T3 = &H1008
Public Const DEVTYPE_T4 = &H1005
Public Const DEVTYPE_T5 = &H1002
Public Const DEVTYPE_T6 = &H1004

Public Const DEVTYPE_IR1 = &H8100
Public Const DEVTYPE_IA1 = &H8111
Public Const DEVTYPE_IA2 = &H8112
Public Const DEVTYPE_IA3 = &H8113
Public Const DEVTYPE_IA4 = &H8114
Public Const DEVTYPE_IA4_F = &H8115

Public Const DEVTYPE_IB1 = &H8121
Public Const DEVTYPE_IB2 = &H8122
Public Const DEVTYPE_IB3 = &H8123
Public Const DEVTYPE_IB4 = &H8124

Public Const DEVTYPE_IP1 = &H8131
Public Const DEVTYPE_IP1_F = &H8132

Public Const DEVTYPE_IC2_R = &H8200
Public Const DEVTYPE_IC2_LP = &H8203
Public Const DEVTYPE_IC2_LPQ = &H8207
Public Const DEVTYPE_IC2_LPF = &H8211

Public Const DEVTYPE_IC4_R = &H8400
Public Const DEVTYPE_IC4_LP = &H8403
Public Const DEVTYPE_IC4_LPQ = &H8407
Public Const DEVTYPE_IC4_LPF = &H8411

Public Const DEVTYPE_IC7_R = &H8700
Public Const DEVTYPE_IC7_LP = &H8703
Public Const DEVTYPE_IC7_LPQ = &H8707
Public Const DEVTYPE_IC7_LPF = &H8711


'������
Public Const DEVTYPE_B1 = &H2100000
Public Const DEVTYPE_B2 = &H2200000
Public Const DEVTYPE_B3 = &H2300000
Public Const DEVTYPE_B4 = &H2400000
Public Const DEVTYPE_C4_L = &H3100000
Public Const DEVTYPE_C4_P = &H3200000
Public Const DEVTYPE_C4_LP = &H3300000
Public Const DEVTYPE_C4_LPQ = &H3400000
Public Const DEVTYPE_C7_L = &H3500000
Public Const DEVTYPE_C7_P = &H3600000
Public Const DEVTYPE_C7_LP = &H3700000
Public Const DEVTYPE_C7_LPQ = &H3800000
Public Const DEVTYPE_R1 = &H4100000
Public Const DEVTYPE_C_PR = &H4200000
'


'--------------------------------------------------------------
'�豸����ģ��
'�Ƿ�����������ȹ���
'����PC��������������/ͨ��ʱ��·����������
Public Const DEVMODULE_DOPLAY = &H1
'�Ƿ���пɽ������߻�ȡ�������(FSK/DTMF˫��ʽ)/ͨ��¼������
'�������絯��/ͨ��¼��/ͨ��ʱ��ȡ�Է�����(DTMF)
Public Const DEVMODULE_CALLID = &H2
'�Ƿ���пɽ��뻰������PSTNͨ������
'����ʹ�õ绰������PSTNͨ��/��ȡ���������ĺ���
Public Const DEVMODULE_PHONE = &H4
'�Ƿ���м̵����л��Ͽ�/��ͨ��������
'�Ͽ����������:����ʱ����������/ʹ�û���MIC�����ɼ�¼�����DEVFUNC_RINGģ�������ģ����������
Public Const DEVMODULE_SWITCH = &H8
'PC����������������Ͳ,���� DEVMODULE_SWITCHģ��,switch�󲥷�������������Ͳ
Public Const DEVMODULE_PLAY2TEL = &H10
'�Ƿ���л���ժ���󲦺�/��������·�Ĺ���
'����ʹ��PC�Զ�ժ�����в���/ͨ��ʱ���Ը��Է���������/��������/�Ⲧ֪ͨ/����IVR(������¼)
Public Const DEVMODULE_HOOK = &H20
'�Ƿ���в���MIC/��������
'������MIC/��������PSTNͨ��/ʹ��MIC����¼��/PC��������������
Public Const DEVMODULE_MICSPK = &H40
'�Ƿ�����ý���phone�ڵ��豸(�绰��,��������)ģ�����幦��
'��������ʱ����phone�ڵ��豸ģ����������.��:������IVR(������¼)֮����빤����ʱ���ڲ������򽻻���ģ������
Public Const DEVMODULE_RING = &H80
'�Ƿ���н���/���ʹ��湦��
'���Է���ͼƬ,�ĵ����Է��Ĵ����/���Խ��ձ���Է���������͹�����ͼƬ
Public Const DEVMODULE_FAX = &H100
'���м��Է�ת���Է�ժ���Ĺ���
'���PSTN��·�ڵ��ص��Ų���ͬʱ��ͨ�ü��Է�ת������,�Ϳ������Ⲧʱ��ȷ��⵽�Է�ժ��/�һ�
'���û�иù���,ֻ�в���ĺ�����б�׼����Ų��ܼ�⵽�Է�ժ��,���ֻ�����,IP�Ȳ����б�׼������·�Ĳ��ܼ��Է�ժ��/�һ�
Public Const DEVMODULE_POLARITY = &H800
'----------------------------------------------------------------


'���豸����
Public Const ODT_LBRIDGE = &H0                        '������
Public Const ODT_SOUND = &H1                          '����
Public Const ODT_CC = &H2                             'CCģ��
Public Const ODT_SOCKET_CLIENT = &H4                  'SOCKET�ն�ģ��
Public Const ODT_SOCKET_SERVER = &H8                  'SOCKET������ģ��
Public Const ODT_ALL = &HFF                           'ȫ��
Public Const ODT_CHANNEL = &H100                      '��ָ��ͨ��

'-----------------------------------------------------
'linein��·ѡ��
Public Const LINEIN_ID_1 = &H0                        'Ĭ������״̬¼�����ɼ���������
Public Const LINEIN_ID_2 = &H1                        '�绰���Ͽ��󻰱�¼��
Public Const LINEIN_ID_3 = &H2                        'hook line ��ժ����¼��,¼�����ݿ�����߶Է�������,���ͱ�������
Public Const LINEIN_ID_LOOP = &H3                     '�ڲ���·����,�豸����ʹ��,�����û�����Ҫʹ��
'-----------------------------------------------------

Public Const ADCIN_ID_MIC = &H0                       'mic¼��
Public Const ADCIN_ID_LINE = &H1                      '�绰��¼��

'adc
Public Const DOPLAY_CHANNEL1_ADC = &H0
Public Const DOPLAY_CHANNEL0_ADC = &H1
Public Const DOPLAY_CHANNEL0_DAC = &H2
Public Const DOPLAY_CHANNEL1_DAC = &H3

'------------
Public Const SOFT_FLASH = &H1                           'ʹ����������Ĳ����
Public Const TEL_FLASH = &H2                            'ʹ�û����Ĳ����
'------------
'�ܽ�ʱʹ��ģʽ
Public Const REFUSE_ASYN = &H0                          '�첽ģʽ,���ú����������أ���������ʾ�ܽ���ɣ��ܽ���ɺ󽫽��յ�һ���ܽ���ɵ��¼�
Public Const REFUSE_SYN = &H1                           'ͬ��ģʽ,���ú�ú������������ȴ��ܽ���ɷ��أ�ϵͳ�����оܽ���ɵ��¼�


'�Ĳ������
Public Const FT_NULL = &H0
Public Const FT_TEL = &H1                               '�����Ĳ��
Public Const FT_PC = &H2                                '���Ĳ��
Public Const FT_ALL = &H3
'-------------------------------

'��������
Public Const DTT_DIAL = &H0                             '����
Public Const DTT_SEND = &H1                             '���η���/���巢��CALLID
'-------------------------------

'�������ģʽ
Public Const CALLIDMODE_NULL = &H0                      'δ֪
Public Const CALLIDMODE_FSK = &H1                       'FSK����
Public Const CALLIDMODE_DTMF = &H2                      'DTMF����
'

'��������
Public Const CTT_NULL = &H0
Public Const CTT_MOBILE = &H1                           '�ƶ�����
Public Const CTT_PSTN = &H2                             '��ͨ�̻�����
'------------------------------
    
Public Const CALLT_NULL = &H0                           '
Public Const CALLT_CALLIN = &H1                         '����
Public Const CALLT_CALLOUT = &H2                        'ȥ��
'-------------------

Public Const CRESULT_NULL = &H0
Public Const CRESULT_MISSED = &H1                       '����δ��
Public Const CRESULT_REFUSE = &H2                       '����ܽ�
Public Const CRESULT_RINGBACK = &H3                     '���к������
Public Const CRESULT_CONNECTED = &H4                    '��ͨ
'--------------------------------------

Public Const OPTYPE_NULL = &H0
Public Const OPTYPE_REMOVE = &H1                        '�ϴ��ɹ���ɾ�������ļ�

'�豸����ID
Public Const DERR_READERR = &H0                         '��ȡ���ݷ��ʹ���
Public Const DERR_WRITEERR = &H1                        'д�����ݴ���
Public Const DERR_FRAMELOST = &H2                       '�����ݰ�
Public Const DERR_REMOVE = &H3                          '�豸�Ƴ�
Public Const DERR_SERIAL = &H4                          '�豸���кų�ͻ
'---------------------------------------

'����ʶ��ʱ���Ա�����
Public Const SG_NULL = &H0
Public Const SG_MALE = &H1                              '����
Public Const SG_FEMALE = &H2                            'Ů��
Public Const SG_AUTO = &H3                              '�Զ�
'--------------------------------

'�豸����ģʽ
Public Const SM_NOTSHARE = &H0
Public Const SM_SENDVOICE = &H1                         '��������
Public Const SM_RECVVOICE = &H2                         '��������
'----------------------------------

'----------------------------------------------
'�������/����
Public Const FAX_TYPE_NULL = &H0
Public Const FAX_TYPE_SEND = &H1                        '���ʹ���
Public Const FAX_TYPE_RECV = &H2                        '���մ���
'------------------------------------------------

'
Public Const TTS_LIST_REINIT = &H0                      '���³�ʼ���µ�TTS�б�
Public Const TTS_LIST_APPEND = &H1                      '׷��TTS�б��ļ�
'------------------------------------------------

'--------------------------------------------------------
Public Const DIALTYPE_DTMF = &H0                        'DTMF����
Public Const DIALTYPE_FSK = &H1                         'FSK����
'--------------------------------------------------------

'--------------------------------------------------------
Public Const PLAYFILE_MASK_REPEAT = &H1                 'ѭ������
Public Const PLAYFILE_MASK_PAUSE = &H2                  'Ĭ����ͣ
'--------------------------------------------------------

'�����ļ��ص���״̬
Public Const PLAYFILE_PLAYING = &H1                     '���ڲ���
Public Const PLAYFILE_REPEAT = &H2                      '׼���ظ�����
Public Const PLAYFILE_END = &H3                         '���Ž���


Public Const CONFERENCE_MASK_DISABLEMIC = &H100         'ֹͣMIC,������������Ա�����������û�˵��
Public Const CONFERENCE_MASK_DISABLESPK = &H200         'ֹͣSPK,��������������������Ա˵��


Public Const RECORD_MASK_ECHO = &H1                     '���������������
Public Const RECORD_MASK_AGC = &H2                      '�Զ������¼��
Public Const RECORD_MASK_PAUSE = &H4                    '��ͣ


Public Const CHECKLINE_MASK_DIALOUT = &H1               '��·�Ƿ�������������(�оͿ�����������)
Public Const CHECKLINE_MASK_REV = &H2                   '��·LINE��/PHONE�ڽ����Ƿ�����,�������ͱ�ʾ�ӷ���


Public Const OUTVALUE_MAX_SIZE = 260                    'location���ص���󳤶�


'-----------------------------------------------

'cc ��Ϣ����
'�����������������鿴windows����ĵ�
Public Const MSG_KEY_CC = "cc:"                         '��Ϣ��ԴCC��
Public Const MSG_KEY_NAME = "name:"                     '��Ϣ��Դ���ƣ�����
Public Const MSG_KEY_TIME = "time:"                     '��Ϣ��Դʱ��
Public Const MSG_KEY_FACE = "face:"                     '��������
Public Const MSG_KEY_COLOR = "color:"                   '������ɫ
Public Const MSG_KEY_SIZE = "size:"                     '����ߴ�
Public Const MSG_KEY_CHARSET = "charset:"               '��������
Public Const MSG_KEY_EFFECTS = "effects:"               '����Ч��
Public Const MSG_KEY_LENGTH = "length:"                 '��Ϣ���ĳ���
'CC�ļ�����
Public Const MSG_KEY_FILENAME = "filename:"             '�ļ���
Public Const MSG_KEY_FILESIZE = "filesize:"             '�ļ�����
Public Const MSG_KEY_FILETYPE = "filetype:"             '�ļ�����

Public Const MSG_KEY_CALLPARAM = "callparam:"           'CC����ʱ�Ĳ���

'
Public Const MSG_KEY_SPLIT = vbCrLf                     '����֮��ָ�����
Public Const MSG_TEXT_SPLIT = vbCrLf + vbCrLf           '��Ϣ��������Ϣ���ݵķָ�����
'Public Const       MSG_KEY_SPLIT                           =#13#10
'Public Const       MSG_TEXT_SPLIT                          =#13#10#13#10



'----------------------------------------------------------------------
'�ص�����ԭ��
'----------------------------------------------------------------------
'
'���岥�Żص�ԭ��
'uChannelID:ͨ��ID
'dwUserData:�û��Զ��������
'lHandle:����ʱ���صľ��
'lDataSize:��ǰ�������������
'lFreeSize:��ǰ����Ŀ��г���
'���� CB_REMOVELIST(-1) ����ϵͳɾ���ûص���Դ���´β��ٻص�/��������ֵ����
'typedef BRIINT32 (CALLBACK *PCallBack_PlayBuf)(BRIINT16 uChannelID,BRIUINT32 dwUserData,BRIINT32 lHandle,BRIINT32 lDataSize,BRIINT32 lFreeSize);'C++ԭ��

'''''''''''''''''''''''''''''''''''''''''''''''''''''/

'''''''''''''''''''''''''''''''''''''''''''''''''''''
'�����ļ����Żص�ԭ��
'uChannelID:ͨ��ID
'nPlayState:�ļ����ŵ�״̬,PLAYING/REPLAY/END
'dwUserData:�û��Զ��������
'lHandle:����ʱ���صľ��
'lElapses:�ܹ����ŵ�ʱ��(��λ��)
'���� CB_REMOVELIST(-1) ϵͳ���Զ�ֹͣ���Ÿ��ļ�/��������ֵ����
'typedef BRIINT32 (CALLBACK *PCallBack_PlayFile)(BRIINT16 uChannelID,BRIUINT32 nPlayState,BRIUINT32 dwUserData,BRIINT32 lHandle,BRIINT32 lElapses);'C++ԭ��


'''''''''''''''''''''''''''''''''''''''''''''
'����¼���ص�ԭ�� Ĭ�ϸ�ʽΪ8K/16λ/������/����
'uChannelID:ͨ��ID
'dwUserData:�û��Զ�������
'pBufData:��������
'lBufSize:�������ݵ��ڴ��ֽڳ���
'���� CB_REMOVELIST(-1) ����ϵͳɾ���ûص���Դ���´β��ٻص�/��������ֵ����
'typedef BRIINT32 (CALLBACK *PCallBack_RecordBuf)(BRIINT16 uChannelID,BRIUINT32 dwUserData,BRIBYTE8 *pBufData,BRIINT32 lBufSize);'C++ԭ��

''''''''''''''''''''''''''''''''''''''''''''''

'''''''''''''''''''''''''''''''''''''''''''''
'�¼������ص�ԭ��
'uChannelID:ͨ��ID
'dwUserData:�û��Զ�������
'lType:�¼�����ID �鿴BRI_EVENT.lEventType Define
'lResult:�¼��������
'lParam:��������,��չʹ��
'szData:�¼��������
'pDataEx:��������,��չʹ��
''''''''''''''''''''''''''''''''''''''''''''
'typedef BRIINT32 (CALLBACK *PCallBack_Event)(BRIINT16 uChannelID,BRIUINT32 dwUserData,BRIINT32  lType,BRIINT32 lHandle,BRIINT32 lResult,BRIINT32 lParam,BRIPCHAR8 pData,BRIPCHAR8 pDataEx);'C++ԭ��


'//////////////////////////////////////////////////////////////////////////////////////////
'�¼������ص�ԭ��,ʹ�ýṹ�巽ʽ
'pEvent:�¼��ṹ������
'dwUserData:�û��Զ�������
'��ע:��PCallBack_EventֻҪʹ������һ�ַ��ǾͿ�����
'////////////////////////////////////////////////////////////////////////////////////////
'typedef BRIINT32 (CALLBACK *PCallBack_EventEx)(PBRI_EVENT pEvent,BRIUINT32 dwUserData);'C++ԭ��



'���ݽṹ
Public Const MAX_BRIEVENT_DATA = 600       '�¼������󱣴��������󳤶�

Public Type TBriEvent_Data
    uVersion     As Byte
    uReserv      As Byte
    uChannelID   As Integer '�¼�����ͨ��ID Integer ->2�ֽ�
    lEventType   As Long '�¼�����ID �鿴BRI_EVENT.lEventType Define
    lEventHandle As Long '�¼���ؾ��
    lResult      As Long '�¼������ֵ
    lParam       As Long '����,��չʱʹ��
    szData       As String * MAX_BRIEVENT_DATA '�¼��������.�磺����ʱ������������ĺ���
    szDataEx     As String * 32 '����,��չʱʹ��
End Type



'''''''''''''''''''''''''''''''''''
'  BRI_EVENT.lEventType Define
'  �¼����Ͷ���.ͬ����ϵͳ�����Ĵ�����Ϣ(��ѡ������һ�ַ�ʽ����)
'''''''''''''''''''''''''''''''''''/


' ���ص绰��ժ���¼�
Public Const BriEvent_PhoneHook = 1
' ���ص绰���һ��¼�
Public Const BriEvent_PhoneHang = 2

' ����ͨ�����������¼�
' BRI_EVENT.lResult        Ϊ�������
' BRI_EVENT.szData[0]="0"  ��ʼ1������
' BRI_EVENT.szData[0]="1"  Ϊ1��������ɣ���ʼ4�뾲��
Public Const BriEvent_CallIn = 3

' �õ��������
' BRI_EVENT.lResult        �������ģʽ(CALLIDMODE_FSK/CALLIDMODE_DTMF
' BRI_EVENT.szData         ������������
' ���¼�����������ǰ,Ҳ�����������
Public Const BriEvent_GetCallID = 4

' �Է�ֹͣ����(����һ��δ�ӵ绰)
Public Const BriEvent_StopCallIn = 5

' ���ÿ�ʼ���ź�ȫ�����벦�Ž���
Public Const BriEvent_DialEnd = 6

' �����ļ������¼�
' BRI_EVENT.lResult       �����ļ�ʱ���صľ��ID
Public Const BriEvent_PlayFileEnd = 7

' ���ļ����������¼�
'
Public Const BriEvent_PlayMultiFileEnd = 8

'�����ַ�����
Public Const BriEvent_PlayStringEnd = 9

' �����ļ�����׼���ظ�����
' BRI_EVENT.lResult       �����ļ�ʱ���صľ��ID
'
Public Const BriEvent_RepeatPlayFile = 10

' �������豸���������ź�ʱ���ͺ������
Public Const BriEvent_SendCallIDEnd = 11

'�������豸���������ź�ʱ��ʱ
'Ĭ����DEFAULT_RING_TIMEOUT(12)�κ�ʱ
Public Const BriEvent_RingTimeOut = 12

'������������
'BRI_EVENT.lResult    �Ѿ�����Ĵ���
' BRI_EVENT.szData[0]="0"  ��ʼһ������
' BRI_EVENT.szData[0]="1"  һ��������ɣ�׼������
Public Const BriEvent_Ringing = 13

' ͨ��ʱ��⵽һ��ʱ��ľ���.Ĭ��Ϊ5��
Public Const BriEvent_Silence = 14

' ��·��ͨʱ�յ�DTMF���¼�
' ���¼���������ͨ�����Ǳ��ػ����������ǶԷ�������������
Public Const BriEvent_GetDTMFChar = 15

' ���ź�,���з�ժ���¼������¼������ο�,ԭ�����£���
' ԭ��
' ���¼�ֻ�����ڲ����Ǳ�׼�ź����ĺ���ʱ��Ҳ���ǲ��ź���б�׼�������ĺ��롣
' �磺������ĶԷ������ǲ���(�����ֻ���)��ϵͳ��ʾ��(179xx)�����Ǳ�׼������ʱ���¼���Ч��
'
' �����ź���ģ����·��Ψһ�ɿ����ж϶Է�ժ���ķ�����ֻ��һ������Ҫ��ͨ���иù��ܣ���һ��������Щ�ط�����ʹ����Ҳδ��������Ϊ�ù���ԭ������Թ��õ绰�Ʒѵġ�
' û�иù��ܣ������ź������ж����ݣ����ɿ��Բ�������100�����������ڱ��з�Ϊ����ʱ������ʺܵ�
' ӵ�з�������ʽһ������ŵ�PSTN��·���뿪ͨ,�÷�ʽ�����Բ�ǿ,ԭ����������
' ӵ�з�������ʽ��������һ���ֻ�sim/3g��,�ٹ���һ�������������sim/3gƽ̨�豸(200���������),���豸������һ���绰�߽��뵽USB�豸
' BRI_EVENT.lResult : 0 Ϊ�����źŷ����Ľ��
' BRI_EVENT.lResult : 1 Ϊ�������Ľ��
Public Const BriEvent_RemoteHook = 16

' �һ��¼�
' �����·��⵽���з�ժ���󣬱��з��һ�ʱ�ᴥ�����¼�����Ȼ���з��һ���ʹ���BriEvent_Busy�¼�
' ���¼�����BriEvent_Busy�Ĵ�������ʾPSTN��·�Ѿ����Ͽ�
' ��ע�����¼��Ǹ�����·��æ���źż�⣬���û��æ���Ͳ��ᴥ�����¼�
' ����з��������Ϊ�ɿ���ʾ
' BRI_EVENT.lResult : 0 Ϊ�����źŷ����Ľ��
' BRI_EVENT.lResult : 1 Ϊ�������Ľ��
Public Const BriEvent_RemoteHang = 17

' ��⵽æ���¼�,��ʾPSTN��·�Ѿ����Ͽ�
Public Const BriEvent_Busy = 18

' ����ժ�����⵽������
Public Const BriEvent_DialTone = 19

' ֻ���ڱ��ػ���ժ����û�е�����ժ��ʱ����⵽DTMF����
Public Const BriEvent_PhoneDial = 20

' �绰�����Ž��������¼���
' Ҳ��ʱ�绰�����ź���յ���׼����������15�볬ʱ
' BRI_EVENT.lResult=0 ��⵽������' ע�⣺�����·�ǲ����ǲ��ᴥ��������
' BRI_EVENT.lResult=1 ���ų�ʱ
' BRI_EVENT.lResult=2 ��̬��Ⲧ�������(�����й���½�ĺ������������ܷ����������ο�)
' BRI_EVENT.szData[0]="1" ��ժ�����Ž����������
' BRI_EVENT.szData[0]="0" �绰�������л�����
Public Const BriEvent_RingBack = 21

' MIC����״̬
' ֻ���þ��иù��ܵ��豸
Public Const BriEvent_MicIn = 22
' MIC�γ�״̬
' ֻ���þ��иù��ܵ��豸
Public Const BriEvent_MicOut = 23

' �Ĳ��(Flash)����¼����Ĳ����ɺ���Լ�Ⲧ��������ж��β���
' BRI_EVENT.lResult=TEL_FLASH  �û�ʹ�õ绰�������Ĳ�����
' BRI_EVENT.lResult=SOFT_FLASH ����StartFlash���������Ĳ�����
Public Const BriEvent_FlashEnd = 24

' �ܽ����
Public Const BriEvent_RefuseEnd = 25

' ����ʶ�����
Public Const BriEvent_SpeechResult = 26

'PSTN��·�Ͽ�,��·�������״̬
'��ǰû����ժ�����һ���Ҳûժ��
Public Const BriEvent_PSTNFree = 27

' ���յ��Է�׼�����ʹ�����ź�
Public Const BriEvent_RemoteSendFax = 30

' ���մ������
Public Const BriEvent_FaxRecvFinished = 31
' ���մ���ʧ��
Public Const BriEvent_FaxRecvFailed = 32

' ���ʹ������
Public Const BriEvent_FaxSendFinished = 33
' ���ʹ���ʧ��
Public Const BriEvent_FaxSendFailed = 34

' ��������ʧ��
Public Const BriEvent_OpenSoundFailed = 35

' ����һ��PSTN����/������־
Public Const BriEvent_CallLog = 36

'��⵽�����ľ���
'ʹ��QNV_GENERAL_CHECKSILENCE�������⵽�趨�ľ�������
Public Const BriEvent_RecvSilence = 37

'��⵽����������
'ʹ��QNV_GENERAL_CHECKVOICE�������⵽�趨����������
Public Const BriEvent_RecvVoice = 38

'Զ���ϴ��¼�
Public Const BriEvent_UploadSuccess = 50
Public Const BriEvent_UploadFailed = 51
' Զ�������ѱ��Ͽ�
Public Const BriEvent_RemoteDisconnect = 52

'HTTPԶ�������ļ����
'BRI_EVENT.lResult    ��������ʱ���صı��β����ľ��
Public Const BriEvent_DownloadSuccess = 60
Public Const BriEvent_DownloadFailed = 61

'��·�����
'BRI_EVENT.lResult Ϊ�������Ϣ
Public Const BriEvent_CheckLine = 70


' Ӧ�ò������ժ��/��һ��ɹ��¼�
' BRI_EVENT.lResult=0 ��ժ��
' BRI_EVENT.lResult=1 ��һ�
Public Const BriEvent_EnableHook = 100
' ���ȱ��򿪻���/�ر�
' BRI_EVENT.lResult=0 �ر�
' BRI_EVENT.lResult=1 ��
Public Const BriEvent_EnablePlay = 101
' MIC���򿪻��߹ر�
' BRI_EVENT.lResult=0 �ر�
' BRI_EVENT.lResult=1 ��
Public Const BriEvent_EnableMic = 102
' �������򿪻��߹ر�
' BRI_EVENT.lResult=0 �ر�
' BRI_EVENT.lResult=1 ��
Public Const BriEvent_EnableSpk = 103
' �绰�����绰��(PSTN)�Ͽ�/��ͨ(DoPhone)
' BRI_EVENT.lResult=0 �Ͽ�
' BRI_EVENT.lResult=1 ��ͨ
Public Const BriEvent_EnableRing = 104
' �޸�¼��Դ (����/����)
' BRI_EVENT.lResult ¼��Դ��ֵ
Public Const BriEvent_DoRecSource = 105
' ��ʼ�������
' BRI_EVENT.szData ׼�����ĺ���
Public Const BriEvent_DoStartDial = 106
' ��������ͨ����ѡ��
' BRI_EVENT.lResult= ѡ���muxֵ
Public Const BriEvent_EnablePlayMux = 107
'�ı��豸����״̬
Public Const BriEvent_DevCtrl = 110

'��ͨ��״̬�н��յ�������
'������������������𻰻�һ��ʱ���ڼ�⵽,Ӧ�ò���Կ�����Ϊ�Ǹղŵ绰�Ѿ�δ��,�������𻰻�����ȥ��
Public Const BriEvent_DialToneEx = 193
' ���յ�DTMF,�������ǲ��Ż���ͨ����,���н��յ���DTMF�¼����ص�
' BRI_EVENT.szData ����
' ����һ���û�����Ҫʹ��
Public Const BriEvent_RecvedDTMF = 194

'�豸���ܱ��ε���,Ч���൱��BriEvent_DevErr�¼�ʱ��BRI_EVENT.lResult=3
Public Const BriEvent_PlugOut = 195
'Ӳ��������
' ����
Public Const BriEvent_CallInEx = 196
' ���´��豸�ɹ�
' ����
Public Const BriEvent_ReopenSucccess = 197
' ���յ�FSK�źţ�����ͨ����FSK/��������FSK
' BRI_EVENT.szData ����
'�������ڲ�ʹ�ã�����һ���û�����Ҫʹ��
Public Const BriEvent_RecvedFSK = 198
'�豸�쳣����
'BRI_EVENT.lResult=3 ��ʾ�豸���ܱ��Ƴ���,����رպ����´��豸�ſ�������ʹ��
'�������Ժ��Բ�������
Public Const BriEvent_DevErr = 199

'CCCtrl Event
'CC��������¼�
Public Const BriEvent_CC_ConnectFailed = 200                   '����ʧ��
Public Const BriEvent_CC_LoginFailed = 201                     '��½ʧ��
Public Const BriEvent_CC_LoginSuccess = 202                    '��½�ɹ�
Public Const BriEvent_CC_SystemTimeErr = 203                   'ϵͳʱ�����
Public Const BriEvent_CC_CallIn = 204                          '��CC��������
Public Const BriEvent_CC_CallOutFailed = 205                   '����ʧ��
Public Const BriEvent_CC_CallOutSuccess = 206                  '���гɹ������ں���
Public Const BriEvent_CC_Connecting = 207                      '������������
Public Const BriEvent_CC_Connected = 208                       '������ͨ
Public Const BriEvent_CC_CallFinished = 209                    '���н���
Public Const BriEvent_CC_ReplyBusy = 210                       '�Է��ظ�æ����

Public Const BriEvent_CC_RecvedMsg = 220                       '���յ��û���ʱ��Ϣ
Public Const BriEvent_CC_RecvedCmd = 221                       '���յ��û��Զ�������

Public Const BriEvent_CC_RegSuccess = 225                      'ע��CC�ɹ�
Public Const BriEvent_CC_RegFailed = 226                       'ע��CCʧ��

Public Const BriEvent_CC_RecvFileRequest = 230                 '���յ��û����͵��ļ�����
Public Const BriEvent_CC_TransFileFinished = 231               '�����ļ�����

Public Const BriEvent_CC_AddContactSuccess = 240               '���Ӻ��ѳɹ�
Public Const BriEvent_CC_AddContactFailed = 241                '���Ӻ���ʧ��
Public Const BriEvent_CC_InviteContact = 242                   '���յ����Ӻú�������
Public Const BriEvent_CC_ReplyAcceptContact = 243              '�Է��ظ�ͬ��Ϊ����
Public Const BriEvent_CC_ReplyRefuseContact = 244              '�Է��ظ��ܾ�Ϊ����
Public Const BriEvent_CC_AcceptContactSuccess = 245            '���ܺ��ѳɹ�
Public Const BriEvent_CC_AcceptContactFailed = 246             '���ܺ���ʧ��
Public Const BriEvent_CC_RefuseContactSuccess = 247            '�ܾ����ѳɹ�
Public Const BriEvent_CC_RefuseContactFailed = 248             '�ܾ�����ʧ��
Public Const BriEvent_CC_DeleteContactSuccess = 249            'ɾ�����ѳɹ�
Public Const BriEvent_CC_DeleteContactFailed = 250             'ɾ������ʧ��
Public Const BriEvent_CC_ContactUpdateStatus = 251             '���ѵ�½״̬�ı�
Public Const BriEvent_CC_ContactDownendStatus = 252            '��ȡ�����к��Ѹı����


'�ն˽��յ����¼�
Public Const BriEvent_Socket_C_ConnectSuccess = 300      '���ӳɹ�
Public Const BriEvent_Socket_C_ConnectFailed = 301       '����ʧ��
Public Const BriEvent_Socket_C_ReConnect = 302           '��ʼ��������
Public Const BriEvent_Socket_C_ReConnectFailed = 303     '��������ʧ��
Public Const BriEvent_Socket_C_ServerClose = 304         '�������Ͽ�����
Public Const BriEvent_Socket_C_DisConnect = 305          '���Ӽ��ʱ
Public Const BriEvent_Socket_C_RecvedData = 306          '���յ�����˷��͹���������
'�������˽��յ����¼�
Public Const BriEvent_Socket_S_NewLink = 340             '�������ӽ���
Public Const BriEvent_Socket_S_DisConnect = 341          '�ն����Ӽ��ʱ
Public Const BriEvent_Socket_S_ClientClose = 342         '�ն˶Ͽ�������
Public Const BriEvent_Socket_S_RecvedData = 343          '���յ��ն˷��͹���������


Public Const BriEvent_EndID = 500                        '��ID





'''''''''''''''''''''''''''''''/
'��Ϣ����˵��
'''''''''''''''''''''''''''''''
Public Const WM_USER = 1024
Public Const BRI_EVENT_MESSAGE = WM_USER + 2000       '�¼���Ϣ
Public Const BRI_RECBUF_MESSAGE = WM_USER + 2001      '����¼��������Ϣ

'�ļ�¼����ʽ
Public Const BRI_WAV_FORMAT_DEFAULT = 0               ' BRI_AUDIO_FORMAT_PCM8K16B
Public Const BRI_WAV_FORMAT_ALAW8K = 1                ' 8k/s
Public Const BRI_WAV_FORMAT_ULAW8K = 2                ' 8k/s
Public Const BRI_WAV_FORMAT_IMAADPCM8K4B = 3          ' 4k/s
Public Const BRI_WAV_FORMAT_PCM8K8B = 4               ' 8k/s
Public Const BRI_WAV_FORMAT_PCM8K16B = 5              '16k/s
Public Const BRI_WAV_FORMAT_MP38K8B = 6               '~1.2k/s
Public Const BRI_WAV_FORMAT_MP38K16B = 7              '~2.4k/s
Public Const BRI_WAV_FORMAT_TM8K1B = 8                '~1.5k/s
Public Const BRI_WAV_FORMAT_GSM6108K = 9              '~2.2k/s
Public Const BRI_WAV_FORMAT_END = 255                 '��ЧID
'�������256��
''''''''''''''''''''''''''''''




'-------------------------------------------------------------------------------------
'
'
'----------------------------------------------------------------------------------
'�豸��Ϣ
Public Const QNV_DEVINFO_GETCHIPTYPE = 1             '��ȡUSBģ������
Public Const QNV_DEVINFO_GETCHIPS = 2                '��ȡUSBģ������,��ֵ�������һ��ͨ����DEVID
Public Const QNV_DEVINFO_GETTYPE = 3                 '��ȡͨ������
Public Const QNV_DEVINFO_GETMODULE = 4               '��ȡͨ������ģ��
Public Const QNV_DEVINFO_GETCHIPCHID = 5             '��ȡͨ������USBоƬ���еĴ���ID(0����1)
Public Const QNV_DEVINFO_GETSERIAL = 6               '��ȡͨ�����к�(0-n)
Public Const QNV_DEVINFO_GETCHANNELS = 7             '��ȡͨ������
Public Const QNV_DEVINFO_GETDEVID = 8                '��ȡͨ�����ڵ�USBģ��ID(0-n)
Public Const QNV_DEVINFO_GETDLLVER = 9               '��ȡDLL�汾��
Public Const QNV_DEVINFO_GETCHIPCHANNEL = 10         '��ȡ��USBģ���һ������ID���ڵ�ͨ����
Public Const QNV_DEVINFO_GETCHANNELTYPE = 11         'ͨ����·�����߻��ǻ�������
Public Const QNV_DEVINFO_GETCHIPCHANNELS = 12        '��ȡ��USBģ��ڶ�������ID���ڵ�ͨ����

Public Const QNV_DEVINFO_FILEVERSION = 20            '��ȡDLL���ļ��汾
'-----------------------------------------------------------------

'���������б�
'uParamType (����ʹ��API�Զ�����/��ȡ)
Public Const QNV_PARAM_BUSY = 1                       '��⵽����æ���ص�
Public Const QNV_PARAM_DTMFLEVEL = 2                  'dtmf���ʱ�������������(0-5)
Public Const QNV_PARAM_DTMFVOL = 3                    'dtmf���ʱ���������(1-100)
Public Const QNV_PARAM_DTMFNUM = 4                    'dtmf���ʱ����ĳ���ʱ��(2-10)
Public Const QNV_PARAM_DTMFLOWINHIGH = 5              'dtmf��Ƶ���ܳ�����Ƶֵ(Ĭ��Ϊ6)
Public Const QNV_PARAM_DTMFHIGHINLOW = 6              'dtmf��Ƶ���ܳ�����Ƶֵ(Ĭ��Ϊ4)
Public Const QNV_PARAM_DIALSPEED = 7                  '���ŵ�DTMF����(1ms-60000ms)
Public Const QNV_PARAM_DIALSILENCE = 8                '����ʱ�ļ����������(1ms-60000ms)
Public Const QNV_PARAM_DIALVOL = 9                    '����������С
Public Const QNV_PARAM_RINGSILENCE = 10               '���粻�������ʱ�䳬ʱ��δ�ӵ绰
Public Const QNV_PARAM_CONNECTSILENCE = 11            'ͨ��ʱ��������ʱ�侲����ص�
Public Const QNV_PARAM_RINGBACKNUM = 12               '�������������Ϻ�����忪ʼ��Ч'Ĭ��Ϊ2��,���𵽺��Գ��ֺ������Ļ�����
Public Const QNV_PARAM_SWITCHLINEIN = 13              '�Զ��л�LINEINѡ��
Public Const QNV_PARAM_FLASHELAPSE = 14               '�Ĳ�ɼ��
Public Const QNV_PARAM_FLASHENDELAPSE = 15            '�Ĳ�ɺ��ӳ�һ��ʱ���ٻص��¼�
Public Const QNV_PARAM_RINGELAPSE = 16                '��������ʱʱ�䳤��
Public Const QNV_PARAM_RINGSILENCEELAPSE = 17         '��������ʱ��������
Public Const QNV_PARAM_RINGTIMEOUT = 18               '��������ʱ��ʱ����
Public Const QNV_PARAM_RINGCALLIDTYPE = 19            '��������ʱ���ͺ���ķ�ʽdtmf/fsk
Public Const QNV_PARAM_REFUSEELAPSE = 20              '�ܽ�ʱ���ʱ�䳤��
Public Const QNV_PARAM_DIALTONETIMEOUT = 21           '��Ⲧ������ʱ
Public Const QNV_PARAM_MINCHKFLASHELAPSE = 22         '�Ĳ�ɼ��ʱ�һ����ٵ�ʱ��ms,�һ�ʱ��С�ڸ�ֵ�Ͳ����Ĳ��
Public Const QNV_PARAM_MAXCHKFLASHELAPSE = 23         '�Ĳ�ɼ��ʱ�һ����ʱ��ms,�һ�ʱ����ڸ�ֵ�Ͳ����Ĳ��
Public Const QNV_PARAM_HANGUPELAPSE = 24              '���绰���һ�ʱ������ʱ�䳤��ms,'����һ����������Ĳ�����ϣ����ⷢ���һ����ּ�⵽�Ĳ�
Public Const QNV_PARAM_OFFHOOKELAPSE = 25             '���绰��ժ��ʱ������ʱ�䳤��ms
Public Const QNV_PARAM_RINGHIGHELAPSE = 26            '�����������ʱ���������ʱ�䳤��ms
Public Const QNV_PARAM_RINGLOWELAPSE = 27             '�����������ʱ�����������ʱ�䳤��ms

Public Const QNV_PARAM_SPEECHGENDER = 30              '���������Ա�
Public Const QNV_PARAM_SPEECHTHRESHOLD = 31           '����ʶ������
Public Const QNV_PARAM_SPEECHSILENCEAM = 32           '����ʶ��������
Public Const QNV_PARAM_ECHOTHRESHOLD = 33             '������������������޲���
Public Const QNV_PARAM_ECHODECVALUE = 34              '����������������������
Public Const QNV_PARAM_SIGSILENCEAM = 35              '�ź�����·ͨ�������ľ�������

Public Const QNV_PARAM_LINEINFREQ1TH = 40             '��һ����·˫Ƶģʽ�ź���Ƶ��
Public Const QNV_PARAM_LINEINFREQ2TH = 41             '�ڶ�����·˫Ƶģʽ�ź���Ƶ��
Public Const QNV_PARAM_LINEINFREQ3TH = 42             '��������·˫Ƶģʽ�ź���Ƶ��

Public Const QNV_PARAM_ADBUSYMINFREQ = 45             '���æ������ʱ��СƵ��
Public Const QNV_PARAM_ADBUSYMAXFREQ = 46             '���æ������ʱ���Ƶ��

'�������
Public Const QNV_PARAM_AM_MIC = 50                    'MIC����
Public Const QNV_PARAM_AM_SPKOUT = 51                 '����spk����
Public Const QNV_PARAM_AM_LINEIN = 52                 '��·��������
Public Const QNV_PARAM_AM_LINEOUT = 53                'mic����·����+��������������·����
Public Const QNV_PARAM_AM_DOPLAY = 54                 '�����������

Public Const QNV_PARAM_CITYCODE = 60                  '��������,�ʺ��й���½
Public Const QNV_PARAM_PROXYDIAL = 61                 '������

Public Const QNV_PARAM_FINDSVRTIMEOUT = 70            '�����Զ�CC������ʱʱ��
Public Const QNV_PARAM_CONFJITTERBUF = 71             '���齻���Ķ�̬�����С

Public Const QNV_PARAM_RINGTHRESHOLD = 80             '���������źŷ�������

Public Const QNV_PARAM_DTMFCALLIDLEVEL = 100          'dtmf���������ʱ�������������(0-7)
Public Const QNV_PARAM_DTMFCALLIDNUM = 101            'dtmf���������ʱ����ĳ���ʱ��(2-10)
Public Const QNV_PARAM_DTMFCALLIDVOL = 102            'dtmf���������ʱ���������Ҫ��

'

'�豸����/״̬
'uCtrlType
Public Const QNV_CTRL_DOSHARE = 1                    '�豸����
Public Const QNV_CTRL_DOHOOK = 2                     '���ժ�һ�����
Public Const QNV_CTRL_DOPHONE = 3                    '���Ƶ绰���Ƿ����,�ɿ��ƻ�������,ʵ��Ӳ�Ĳ�ɵ�
Public Const QNV_CTRL_DOPLAY = 4                     '���ȿ��ƿ���
Public Const QNV_CTRL_DOLINETOSPK = 5                '��·�������������ö���ͨ��ʱ��
Public Const QNV_CTRL_DOPLAYTOSPK = 6                '���ŵ�����������
Public Const QNV_CTRL_DOMICTOLINE = 7                'MIC˵�������绰��
Public Const QNV_CTRL_ECHO = 8                       '��/�رջ�������
Public Const QNV_CTRL_RECVFSK = 9                    '��/�رս���FSK�������
Public Const QNV_CTRL_RECVDTMF = 10                  '��/�رս���DTMF
Public Const QNV_CTRL_RECVSIGN = 11                  '��/�ر��ź������
Public Const QNV_CTRL_WATCHDOG = 12                  '�򿪹رտ��Ź�
Public Const QNV_CTRL_PLAYMUX = 13                   'ѡ�����ȵ�����ͨ�� line1x/pcplay ch0/line2x/pcplay ch1
Public Const QNV_CTRL_PLAYTOLINE = 14                '���ŵ�������line
Public Const QNV_CTRL_SELECTLINEIN = 15              'ѡ���������·lineͨ��
Public Const QNV_CTRL_SELECTADCIN = 16               'ѡ�������Ϊ��·����MIC����
Public Const QNV_CTRL_PHONEPOWER = 17                '��/�رո���������ʹ��,���������������,dophone�л���,������������,���жԻ����Ĳ�������Ч
Public Const QNV_CTRL_RINGPOWER = 18                 '��������ʹ��
Public Const QNV_CTRL_LEDPOWER = 19                  'LEDָʾ��
Public Const QNV_CTRL_LINEOUT = 20                   '��·���ʹ��
Public Const QNV_CTRL_SWITCHOUT = 21                 'Ӳ����������
Public Const QNV_CTRL_UPLOAD = 22                    '��/�ر��豸USB�����ϴ�����,�رպ󽫽��ղ����豸��������
Public Const QNV_CTRL_DOWNLOAD = 23                  '��/�ر��豸USB�������ع���,�رպ󽫲��ܷ�������/���ŵ��豸
Public Const QNV_CTRL_POLARITY = 24                  '���ؼ��Է�תժ�����
Public Const QNV_CTRL_ADBUSY = 25                    '�Ƿ�򿪼��æ������ʱ����(ֻ����ʹ����·��������ʱ����ͬʱ�һ��Żᴥ��æ�������ӵĻ���,��ͨ�û�����Ҫʹ��)
Public Const QNV_CTRL_RECVCALLIN = 26                '��/�ر����������
Public Const QNV_CTRL_READFRAMENUM = 27              'һ�������ȡ��USB֡������Խ��ռ��CPUԽС���ӳ�Ҳ��Խ��һ֡Ϊ4ms,���30֡��Ҳ�������÷�ΧΪ(1-30)
Public Const QNV_CTRL_DTMFCALLID = 28                '����/����DTMFģʽ�����������,Ĭ���ǿ�������

'����״̬��������(set),ֻ�ܻ�ȡ(get)
Public Const QNV_CTRL_PHONE = 30                     '�绰��ժ�һ�״̬
Public Const QNV_CTRL_MICIN = 31                     'mic����״̬
Public Const QNV_CTRL_RINGTIMES = 32                 '��������Ĵ���
Public Const QNV_CTRL_RINGSTATE = 33                 '��������״̬�������컹�ǲ���
'

'��������
'uPlayType
Public Const QNV_PLAY_FILE_START = 1                 '��ʼ�����ļ�
Public Const QNV_PLAY_FILE_SETCALLBACK = 2           '���ò����ļ��ص�����
Public Const QNV_PLAY_FILE_SETVOLUME = 3             '���ò����ļ�����
Public Const QNV_PLAY_FILE_GETVOLUME = 4             '��ȡ�����ļ�����
Public Const QNV_PLAY_FILE_PAUSE = 5                 '��ͣ�����ļ�
Public Const QNV_PLAY_FILE_RESUME = 6                '�ָ������ļ�
Public Const QNV_PLAY_FILE_ISPAUSE = 7               '����Ƿ�����ͣ����
Public Const QNV_PLAY_FILE_SETREPEAT = 8             '�����Ƿ�ѭ������
Public Const QNV_PLAY_FILE_ISREPEAT = 9              '����Ƿ���ѭ������
Public Const QNV_PLAY_FILE_SEEKTO = 11               '��ת��ĳ��ʱ��(ms)
Public Const QNV_PLAY_FILE_SETREPEATTIMEOUT = 12     '����ѭ�����ų�ʱ����
Public Const QNV_PLAY_FILE_GETREPEATTIMEOUT = 13     '��ȡѭ�����ų�ʱ����
Public Const QNV_PLAY_FILE_SETPLAYTIMEOUT = 14       '���ò����ܹ���ʱʱ��(ms)
Public Const QNV_PLAY_FILE_GETPLAYTIMEOUT = 15       '��ȡ�����ܹ���ʱʱ��
Public Const QNV_PLAY_FILE_TOTALLEN = 16             '�ܹ�ʱ��(ms)
Public Const QNV_PLAY_FILE_CURSEEK = 17              '��ǰ���ŵ��ļ�ʱ��λ��(ms)
Public Const QNV_PLAY_FILE_ELAPSE = 18               '�ܹ����ŵ�ʱ��(ms),�����ظ���,���˵�,��������ͣ��ʱ��
Public Const QNV_PLAY_FILE_ISPLAY = 19               '�þ���Ƿ��ڲ���
Public Const QNV_PLAY_FILE_ENABLEAGC = 20            '�򿪹ر��Զ�����
Public Const QNV_PLAY_FILE_ISENABLEAGC = 21          '����Ƿ���Զ�����
Public Const QNV_PLAY_FILE_STOP = 22                 'ֹͣ����ָ���ļ�
Public Const QNV_PLAY_FILE_GETCOUNT = 23             '��ȡ�����ļ����ŵ�����,��������������û���˾Ϳ��Թر�����
Public Const QNV_PLAY_FILE_STOPALL = 24              'ֹͣ���������ļ�

Public Const QNV_PLAY_FILE_REMOTEBUFFERLEN = 25      'Զ�̲�����Ҫ���صĻ��峤��
Public Const QNV_PLAY_FILE_REMOTEBUFFERSEEK = 26     'Զ�̲����Ѿ����صĻ��峤��
'--------------------------------------------------------

Public Const QNV_PLAY_BUF_START = 1                  '��ʼ���岥��
Public Const QNV_PLAY_BUF_SETCALLBACK = 2            '���û��岥�Żص�����
Public Const QNV_PLAY_BUF_SETWAVEFORMAT = 3          '���û��岥�������ĸ�ʽ
Public Const QNV_PLAY_BUF_WRITEDATA = 4              'д��������
Public Const QNV_PLAY_BUF_SETVOLUME = 5              '��������
Public Const QNV_PLAY_BUF_GETVOLUME = 6              '��ȡ����
Public Const QNV_PLAY_BUF_SETUSERVALUE = 7           '�����û��Զ�������
Public Const QNV_PLAY_BUF_GETUSERVALUE = 8           '��ȡ�û��Զ�������
Public Const QNV_PLAY_BUF_ENABLEAGC = 9              '�򿪹ر��Զ�����
Public Const QNV_PLAY_BUF_ISENABLEAGC = 10           '����Ƿ�����Զ�����
Public Const QNV_PLAY_BUF_PAUSE = 11                 '��ͣ�����ļ�
Public Const QNV_PLAY_BUF_RESUME = 12                '�ָ������ļ�
Public Const QNV_PLAY_BUF_ISPAUSE = 13               '����Ƿ�����ͣ����
Public Const QNV_PLAY_BUF_STOP = 14                  'ֹͣ���岥��
Public Const QNV_PLAY_BUF_FREESIZE = 15              '�����ֽ�
Public Const QNV_PLAY_BUF_DATASIZE = 16              '�����ֽ�
Public Const QNV_PLAY_BUF_TOTALSAMPLES = 17          '�ܹ����ŵĲ�����
Public Const QNV_PLAY_BUF_SETJITTERBUFSIZE = 18      '���ö�̬���峤�ȣ����������ݲ���Ϊ�պ��´β���ǰ�����ڱ�����ڸó��ȵ�����,�����ڲ����������ݰ����������綶��
Public Const QNV_PLAY_BUF_GETJITTERBUFSIZE = 19      '��ȡ��̬���峤��
Public Const QNV_PLAY_BUF_GETCOUNT = 20              '��ȡ���ڻ��岥�ŵ�����,��������������û���˾Ϳ��Թر�����
Public Const QNV_PLAY_BUF_STOPALL = 21               'ֹͣ���в���
'-------------------------------------------------------

Public Const QNV_PLAY_MULTIFILE_START = 1            '��ʼ���ļ���������
Public Const QNV_PLAY_MULTIFILE_PAUSE = 2            '��ͣ���ļ���������
Public Const QNV_PLAY_MULTIFILE_RESUME = 3           '�ָ����ļ���������
Public Const QNV_PLAY_MULTIFILE_ISPAUSE = 4          '����Ƿ���ͣ�˶��ļ���������
Public Const QNV_PLAY_MULTIFILE_SETVOLUME = 5        '���ö��ļ���������
Public Const QNV_PLAY_MULTIFILE_GETVOLUME = 6        '��ȡ���ļ���������
Public Const QNV_PLAY_MULTIFILE_ISSTART = 7          '�Ƿ������˶��ļ���������
Public Const QNV_PLAY_MULTIFILE_STOP = 8             'ֹͣ���ļ���������
Public Const QNV_PLAY_MULTIFILE_STOPALL = 9          'ֹͣȫ�����ļ���������
'--------------------------------------------------------

Public Const QNV_PLAY_STRING_INITLIST = 1            '��ʼ���ַ������б�
Public Const QNV_PLAY_STRING_START = 2               '��ʼ�ַ�����
Public Const QNV_PLAY_STRING_PAUSE = 3               '��ͣ�ַ�����
Public Const QNV_PLAY_STRING_RESUME = 4              '�ָ��ַ�����
Public Const QNV_PLAY_STRING_ISPAUSE = 5             '����Ƿ���ͣ���ַ�����
Public Const QNV_PLAY_STRING_SETVOLUME = 6           '�����ַ���������
Public Const QNV_PLAY_STRING_GETVOLUME = 7           '��ȡ�ַ���������
Public Const QNV_PLAY_STRING_ISSTART = 8             '�Ƿ��������ַ�����
Public Const QNV_PLAY_STRING_STOP = 9                'ֹͣ�ַ�����
Public Const QNV_PLAY_STRING_STOPALL = 10            'ֹͣȫ���ַ�����
'--------------------------------------------------------

'¼������
'uRecordType
Public Const QNV_RECORD_FILE_START = 1               '��ʼ�ļ�¼��
Public Const QNV_RECORD_FILE_PAUSE = 2               '��ͣ�ļ�¼��
Public Const QNV_RECORD_FILE_RESUME = 3              '�ָ��ļ�¼��
Public Const QNV_RECORD_FILE_ISPAUSE = 4             '����Ƿ���ͣ�ļ�¼��
Public Const QNV_RECORD_FILE_ELAPSE = 5              '��ȡ�Ѿ�¼����ʱ�䳤��,��λ(s)
Public Const QNV_RECORD_FILE_SETVOLUME = 6           '�����ļ�¼������
Public Const QNV_RECORD_FILE_GETVOLUME = 7           '��ȡ�ļ�¼������
Public Const QNV_RECORD_FILE_PATH = 8                '��ȡ�ļ�¼����·��
Public Const QNV_RECORD_FILE_STOP = 9                'ֹͣĳ���ļ�¼��
Public Const QNV_RECORD_FILE_STOPALL = 10            'ֹͣȫ���ļ�¼��
Public Const QNV_RECORD_FILE_COUNT = 11              '��ȡ����¼��������

Public Const QNV_RECORD_FILE_SETROOT = 20            '����Ĭ��¼��Ŀ¼
Public Const QNV_RECORD_FILE_GETROOT = 21            '��ȡĬ��¼��Ŀ¼
'----------------------------------------------------------

Public Const QNV_RECORD_BUF_HWND_START = 1           '��ʼ����¼�����ڻص�
Public Const QNV_RECORD_BUF_HWND_STOP = 2            'ֹͣĳ������¼�����ڻص�
Public Const QNV_RECORD_BUF_HWND_STOPALL = 3         'ֹͣȫ������¼�����ڻص�
Public Const QNV_RECORD_BUF_CALLBACK_START = 4       '��ʼ����¼���ص�
Public Const QNV_RECORD_BUF_CALLBACK_STOP = 5        'ֹͣĳ������¼���ص�
Public Const QNV_RECORD_BUF_CALLBACK_STOPALL = 6     'ֹͣȫ������¼���ص�
Public Const QNV_RECORD_BUF_SETCBSAMPLES = 7         '���ûص�������,ÿ��8K,�����Ҫ20ms�ص�һ�ξ�����Ϊ20*8=160,/Ĭ��Ϊ20ms�ص�һ��
Public Const QNV_RECORD_BUF_GETCBSAMPLES = 8         '��ȡ���õĻص�������
Public Const QNV_RECORD_BUF_ENABLEECHO = 9           '�򿪹ر��Զ�����
Public Const QNV_RECORD_BUF_ISENABLEECHO = 10        '����Զ������Ƿ��
Public Const QNV_RECORD_BUF_PAUSE = 11               '��ͣ����¼��
Public Const QNV_RECORD_BUF_ISPAUSE = 12             '����Ƿ���ͣ����¼��
Public Const QNV_RECORD_BUF_RESUME = 13              '�ָ�����¼��
Public Const QNV_RECORD_BUF_SETVOLUME = 14           '���û���¼������
Public Const QNV_RECORD_BUF_GETVOLUME = 15           '��ȡ����¼������
Public Const QNV_RECORD_BUF_SETWAVEFORMAT = 16       '����¼���ص������������ʽ,Ĭ��Ϊ8K,16λ,wav����
Public Const QNV_RECORD_BUF_GETWAVEFORMAT = 17       '��ȡ¼���ص������������ʽ

Public Const QNV_RECORD_BUF_GETCBMSGID = 100         '��ѯ����¼���Ĵ��ڻص�����ϢID,Ĭ��ΪBRI_RECBUF_MESSAGE
Public Const QNV_RECORD_BUF_SETCBMSGID = 101         '���û���¼���Ĵ��ڻص�����ϢID,Ĭ��ΪBRI_RECBUF_MESSAGE

'--------------------------------------------------------

'�������
'uConferenceType
Public Const QNV_CONFERENCE_CREATE = 1               '��������
Public Const QNV_CONFERENCE_ADDTOCONF = 2            '����ͨ����ĳ������
Public Const QNV_CONFERENCE_GETCONFID = 3            '��ȡĳ��ͨ���Ļ���ID
Public Const QNV_CONFERENCE_SETSPKVOLUME = 4         '���û�����ĳ��ͨ����������
Public Const QNV_CONFERENCE_GETSPKVOLUME = 5         '��ȡ������ĳ��ͨ����������
Public Const QNV_CONFERENCE_SETMICVOLUME = 6         '���û�����ĳ��ͨ��¼������
Public Const QNV_CONFERENCE_GETMICVOLUME = 7         '��ȡ������ĳ��ͨ��¼������
Public Const QNV_CONFERENCE_PAUSE = 8                '��ͣĳ������
Public Const QNV_CONFERENCE_RESUME = 9               '�ָ�ĳ������
Public Const QNV_CONFERENCE_ISPAUSE = 10             '����Ƿ���ͣ��ĳ������
Public Const QNV_CONFERENCE_ENABLESPK = 11           '�򿪹رջ�����������
Public Const QNV_CONFERENCE_ISENABLESPK = 12         '���������������Ƿ��
Public Const QNV_CONFERENCE_ENABLEMIC = 13           '�򿪹رջ�����˵����
Public Const QNV_CONFERENCE_ISENABLEMIC = 14         '��������˵�����Ƿ��
Public Const QNV_CONFERENCE_ENABLEAGC = 15           '�򿪹ر��Զ�����
Public Const QNV_CONFERENCE_ISENABLEAGC = 16         '����Ƿ�����Զ�����
Public Const QNV_CONFERENCE_DELETECHANNEL = 17       '��ͨ���ӻ�����ɾ��
Public Const QNV_CONFERENCE_DELETECONF = 18          'ɾ��һ������
Public Const QNV_CONFERENCE_DELETEALLCONF = 19       'ɾ��ȫ������
Public Const QNV_CONFERENCE_GETCONFCOUNT = 20        '��ȡ��������
Public Const QNV_CONFERENCE_SETJITTERBUFSIZE = 21    '���û��鶯̬���峤��
Public Const QNV_CONFERENCE_GETJITTERBUFSIZE = 22    '��ȡ���鶯̬���峤��

Public Const QNV_CONFERENCE_RECORD_START = 30        '��ʼ¼��
Public Const QNV_CONFERENCE_RECORD_PAUSE = 31        '��ͣ¼��
Public Const QNV_CONFERENCE_RECORD_RESUME = 32       '�ָ�¼��
Public Const QNV_CONFERENCE_RECORD_ISPAUSE = 33      '����Ƿ���ͣ¼��
Public Const QNV_CONFERENCE_RECORD_FILEPATH = 34     '��ȡ¼���ļ�·��
Public Const QNV_CONFERENCE_RECORD_ISSTART = 35      '�������Ƿ��Ѿ�������¼��
Public Const QNV_CONFERENCE_RECORD_STOP = 36         'ָֹͣ������¼��
Public Const QNV_CONFERENCE_RECORD_STOPALL = 37      'ֹͣȫ������¼��
'--------------------------------------------------------

'speech����ʶ��
Public Const QNV_SPEECH_CONTENTLIST = 1              '����ʶ���������б�
Public Const QNV_SPEECH_STARTSPEECH = 2              '��ʼʶ��
Public Const QNV_SPEECH_ISSPEECH = 3                 '����Ƿ�����ʶ��
Public Const QNV_SPEECH_STOPSPEECH = 4               'ֹͣʶ��
Public Const QNV_SPEECH_GETRESULT = 5                '��ȡʶ���Ľ��
Public Const QNV_SPEECH_GETRESULTEX = 6              '��ȡʶ���Ľ��,ʹ�ø����ڴ淽ʽ
'------------------------------------------------------------

'����ģ��ӿ�
Public Const QNV_FAX_LOAD = 1                        '������������ģ��
Public Const QNV_FAX_UNLOAD = 2                      'ж�ش���ģ��
Public Const QNV_FAX_STARTSEND = 3                   '��ʼ���ʹ���
Public Const QNV_FAX_STOPSEND = 4                    'ֹͣ���ʹ���
Public Const QNV_FAX_STARTRECV = 5                   '��ʼ���մ���
Public Const QNV_FAX_STOPRECV = 6                    'ֹͣ���մ���
Public Const QNV_FAX_STOP = 7                        'ֹͣȫ��
Public Const QNV_FAX_PAUSE = 8                       '��ͣ
Public Const QNV_FAX_RESUME = 9                      '�ָ�
Public Const QNV_FAX_ISPAUSE = 10                    '�Ƿ���ͣ
Public Const QNV_FAX_TYPE = 11                       '����״̬�ǽ��ܻ��߷���
Public Const QNV_FAX_TRANSMITSIZE = 12               '�Ѿ����͵�ͼ�����ݴ�С
Public Const QNV_FAX_IMAGESIZE = 13                  '�ܹ���Ҫ����ͼ�����ݴ�С
Public Const QNV_FAX_SAVESENDFILE = 14               '���淢�͵Ĵ���ͼƬ
'----------------------------------------------------------

'����event
'ueventType
Public Const QNV_EVENT_POP = 1                       '��ȡ���Զ�ɾ����ǰ�¼�,pValue->PBRI_EVENT
Public Const QNV_EVENT_POPEX = 2                     '��ȡ���Զ�ɾ����ǰ�¼�,pValue->�ַ��ָ���ʽ:chid,type,handle,result,data
Public Const QNV_EVENT_TYPE = 3                      '��ȡ�¼�����,��ȡ�󲻻��Զ�ɾ������ȡ�ɹ���ʹ�� QNV_GENERAL_EVENT_REMOVEɾ�����¼�
Public Const QNV_EVENT_HANDLE = 4                    '��ȡ�¼���ֵ
Public Const QNV_EVENT_RESULT = 5                    '��ȡ�¼���ֵ
Public Const QNV_EVENT_PARAM = 6                     '��ȡ�¼���ֵ
Public Const QNV_EVENT_DATA = 7                      '��ȡ�¼�����
Public Const QNV_EVENT_DATAEX = 8                    '��ȡ�¼���������
Public Const QNV_EVENT_REMOVE = 20                   'ɾ�����ϵ��¼�
Public Const QNV_EVENT_REMOVEALL = 21                'ɾ�������¼�
Public Const QNV_EVENT_REGWND = 30                   'ע�������Ϣ�Ĵ��ھ��
Public Const QNV_EVENT_UNREGWND = 31                 'ɾ��������Ϣ�Ĵ��ھ��
Public Const QNV_EVENT_REGCBFUNC = 32                'ע���¼��ص�����
Public Const QNV_EVENT_REGCBFUNCEX = 33              'ע���¼��ص�����
Public Const QNV_EVENT_UNREGCBFUNC = 34              'ɾ���¼��ص�����

Public Const QNV_EVENT_GETEVENTMSGID = 100           '��ѯ���ڻص�����ϢID,Ĭ��ΪBRI_EVENT_MESSAGE
Public Const QNV_EVENT_SETEVENTMSGID = 101           '���ô��ڻص�����ϢID,Ĭ��ΪBRI_EVENT_MESSAGE
'-----------------------------------------------------------

'����general
'uGeneralType
Public Const QNV_GENERAL_STARTDIAL = 1                '��ʼ����
Public Const QNV_GENERAL_SENDNUMBER = 2               '���β���
Public Const QNV_GENERAL_REDIAL = 3                   '�ز����һ�κ��еĺ���,�����˳���ú��뱻�ͷ�
Public Const QNV_GENERAL_STOPDIAL = 4                 'ֹͣ����
Public Const QNV_GENERAL_ISDIALING = 5                '�Ƿ��ڲ���

Public Const QNV_GENERAL_STARTRING = 10               'phone������
Public Const QNV_GENERAL_STOPRING = 11                'phone������ֹͣ
Public Const QNV_GENERAL_ISRINGING = 12               'phone���Ƿ�������

Public Const QNV_GENERAL_STARTFLASH = 20              '�Ĳ��
Public Const QNV_GENERAL_STOPFLASH = 21               '�Ĳ��ֹͣ
Public Const QNV_GENERAL_ISFLASHING = 22              '�Ƿ������Ĳ��

Public Const QNV_GENERAL_STARTREFUSE = 30             '�ܽӵ�ǰ����
Public Const QNV_GENERAL_STOPREFUSE = 31              '��ֹ�ܽӲ���
Public Const QNV_GENERAL_ISREFUSEING = 32             '�Ƿ����ھܽӵ�ǰ����

Public Const QNV_GENERAL_GETCALLIDTYPE = 50           '��ȡ���κ���������������
Public Const QNV_GENERAL_GETCALLID = 51               '��ȡ���κ�����������
Public Const QNV_GENERAL_GETTELDIALCODE = 52          '��ȡ���ε绰�������ĺ�������,return buf
Public Const QNV_GENERAL_GETTELDIALCODEEX = 53                '��ȡ���ε绰�������ĺ�������,outbuf
Public Const QNV_GENERAL_RESETTELDIALBUF = 54         '��յ绰���ĺ��뻺��
Public Const QNV_GENERAL_GETTELDIALLEN = 55           '�绰���Ѳ��ĺ��볤��

Public Const QNV_GENERAL_STARTSHARE = 60              '�����豸�������
Public Const QNV_GENERAL_STOPSHARE = 61               'ֹͣ�豸�������
Public Const QNV_GENERAL_ISSHARE = 62                 '�Ƿ������豸�������ģ��

Public Const QNV_GENERAL_ENABLECALLIN = 70            '��ֹ/�������ߺ���
Public Const QNV_GENERAL_ISENABLECALLIN = 71          '�����Ƿ��������
Public Const QNV_GENERAL_ISLINEHOOK = 72              '�����Ƿ�ժ��״̬(�绰��ժ��������line��������ժ������ʾժ��״̬)
Public Const QNV_GENERAL_ISLINEFREE = 73              '�����Ƿ����(û��ժ������û�������ʾ����)


Public Const QNV_GENERAL_RESETRINGBACK = 80           '��λ��⵽�Ļ���,�����������
Public Const QNV_GENERAL_CHECKCHANNELID = 81          '���ͨ��ID�Ƿ�Ϸ�
Public Const QNV_GENERAL_CHECKDIALTONE = 82           '��Ⲧ����
Public Const QNV_GENERAL_CHECKSILENCE = 83            '�����·����
Public Const QNV_GENERAL_CHECKVOICE = 84              '�����·����
Public Const QNV_GENERAL_CHECKLINESTATE = 85          '�����·״̬(�Ƿ����������/�Ƿ�ӷ�)
Public Const QNV_GENERAL_GETMAXPOWER = 86             '��ȡ��ǰ�����������

Public Const QNV_GENERAL_SETUSERVALUE = 90            '�û��Զ���ͨ������,ϵͳ�˳����Զ��ͷ�
Public Const QNV_GENERAL_SETUSERSTRING = 91           '�û��Զ���ͨ���ַ�,ϵͳ�˳����Զ��ͷ�
Public Const QNV_GENERAL_GETUSERVALUE = 92            '��ȡ�û��Զ���ͨ������
Public Const QNV_GENERAL_GETUSERSTRING = 93           '��ȡ�û��Զ���ͨ���ַ�

Public Const QNV_GENERAL_USEREVENT = 99               '�����û��Զ����¼�
'��ʼ��ͨ��INI�ļ�����
Public Const QNV_GENERAL_READPARAM = 100              '��ȡini�ļ�����ȫ��������ʼ��
Public Const QNV_GENERAL_WRITEPARAM = 101             '�Ѳ���д�뵽ini�ļ�
'

'call log
Public Const QNV_CALLLOG_BEGINTIME = 1               '��ȡ���п�ʼʱ��
Public Const QNV_CALLLOG_RINGBACKTIME = 2            '��ȡ����ʱ��
Public Const QNV_CALLLOG_CONNECTEDTIME = 3           '��ȡ��ͨʱ��
Public Const QNV_CALLLOG_ENDTIME = 4                 '��ȡ����ʱ��
Public Const QNV_CALLLOG_CALLTYPE = 5                '��ȡ��������/����/����
Public Const QNV_CALLLOG_CALLRESULT = 6              '��ȡ���н��
Public Const QNV_CALLLOG_CALLID = 7                  '��ȡ����
Public Const QNV_CALLLOG_CALLRECFILE = 8             '��ȡ¼���ļ�·��
Public Const QNV_CALLLOG_DELRECFILE = 9              'ɾ����־¼���ļ���Ҫɾ��ǰ������ֹͣ¼��

Public Const QNV_CALLLOG_RESET = 20                  '��λ����״̬
Public Const QNV_CALLLOG_AUTORESET = 21              '�Զ���λ

'���ߺ��������豸�޹�
'uToolType
Public Const QNV_TOOL_PSTNEND = 1                    '���PSTN�����Ƿ��Ѿ�����
Public Const QNV_TOOL_CODETYPE = 2                   '�жϺ�������(�ڵ��ֻ�/�̻�)
Public Const QNV_TOOL_LOCATION = 3                   '��ȡ�������ڵ���Ϣ
Public Const QNV_TOOL_DISKFREESPACE = 4              '��ȡ��Ӳ��ʣ��ռ�(M)
Public Const QNV_TOOL_DISKTOTALSPACE = 5             '��ȡ��Ӳ���ܹ��ռ�(M)
Public Const QNV_TOOL_DISKLIST = 6                   '��ȡӲ���б�
Public Const QNV_TOOL_RESERVID1 = 7                  '����
Public Const QNV_TOOL_RESERVID2 = 8                  '����
Public Const QNV_TOOL_CONVERTFMT = 9                 'ת�������ļ���ʽ
Public Const QNV_TOOL_SELECTDIRECTORY = 10           'ѡ��Ŀ¼
Public Const QNV_TOOL_SELECTFILE = 11                'ѡ���ļ�
Public Const QNV_TOOL_CONVERTTOTIFF = 12             'ת��ͼƬ������tiff��ʽ,��������������ģ��,֧�ָ�ʽ:(*.doc,*.htm,*.html,*.mht,*.jpg,*.pnp.....)
Public Const QNV_TOOL_APMQUERYSUSPEND = 13           '�Ƿ�����PC�������/����,��USB�豸�����ʹ��
Public Const QNV_TOOL_SLEEP = 14                     '�õ��ø÷������̵߳ȴ�N����
Public Const QNV_TOOL_SETUSERVALUE = 15              '�����û��Զ�����Ϣ
Public Const QNV_TOOL_GETUSERVALUE = 16              '��ȡ�û��Զ�����Ϣ
Public Const QNV_TOOL_SETUSERVALUEI = 17             '�����û��Զ�����Ϣ
Public Const QNV_TOOL_GETUSERVALUEI = 18             '��ȡ�û��Զ�����Ϣ
Public Const QNV_TOOL_ISFILEEXIST = 20               '��Ȿ���ļ��Ƿ����
Public Const QNV_TOOL_FSKENCODE = 21                 'FSK����
Public Const QNV_TOOL_WRITELOG = 22                  'д�ļ���־->userlogĿ¼
'------------------------------------------------------

'�洢����
Public Const QNV_STORAGE_PUBLIC_READ = 1             '��ȡ������������
Public Const QNV_STORAGE_PUBLIC_READSTR = 2          '��ȡ���������ַ�������,����'\0'�Զ�����
Public Const QNV_STORAGE_PUBLIC_WRITE = 3            'д�빲����������
Public Const QNV_STORAGE_PUBLIC_SETREADPWD = 4       '���ö�ȡ�����������ݵ�����
Public Const QNV_STORAGE_PUBLIC_SETWRITEPWD = 5      '����д�빲���������ݵ�����
Public Const QNV_STORAGE_PUBLIC_GETSPACESIZE = 6     '��ȡ�洢�ռ䳤��


'Զ�̲���
'RemoteType
Public Const QNV_REMOTE_UPLOAD_START = 1             '�ϴ��ļ���WEB������(httpЭ��)
Public Const QNV_REMOTE_UPLOAD_DATA = 2              '�ϴ��ַ����ݵ�WEB������(send/post)(����)
Public Const QNV_REMOTE_UPLOAD_STOP = 3              '�ϴ��ļ���WEB������(httpЭ��)
Public Const QNV_REMOTE_UPLOAD_LOG = 4               '�����ϴ���ǰû�гɹ��ļ�¼
Public Const QNV_REMOTE_UPLOAD_TOTALSIZE = 5         '��ȡ��Ҫ�ϴ����ܹ�����
Public Const QNV_REMOTE_UPLOAD_TRANSIZE = 6          '��ȡ�Ѿ��ϴ��ĳ���
Public Const QNV_REMOTE_UPLOAD_CLEARLOG = 7          'ɾ������δ�ɹ�����־
Public Const QNV_REMOTE_UPLOAD_COUNT = 8             '�ϴ�������
Public Const QNV_REMOTE_UPLOAD_STOPALL = 9           'ֹͣȫ��

Public Const QNV_REMOTE_DOWNLOAD_START = 20          '��ʼ����Զ���ļ�
Public Const QNV_REMOTE_DOWNLOAD_STOP = 21           'ֹͣ����Զ���ļ�
Public Const QNV_REMOTE_DOWNLOAD_TOTALSIZE = 22      '���ص��ܹ�����
Public Const QNV_REMOTE_DOWNLOAD_TRANSIZE = 23       '�Ѿ����صĳ���
Public Const QNV_REMOTE_DOWNLOAD_COUNT = 24          '���ص�����
Public Const QNV_REMOTE_DOWNLOAD_STOPALL = 25        'ֹͣȫ��

Public Const QNV_REMOTE_SETCOOKIE = 40               '����HTTP���ӵ�COOKIE

'--------------------------------------------------------

'CC����
Public Const QNV_CCCTRL_SETLICENSE = 1               '����license
Public Const QNV_CCCTRL_SETSERVER = 2                '���÷�����IP��ַ
Public Const QNV_CCCTRL_LOGIN = 3                    '��½
Public Const QNV_CCCTRL_LOGOUT = 4                   '�˳�
Public Const QNV_CCCTRL_ISLOGON = 5                  '�Ƿ��½�ɹ���
Public Const QNV_CCCTRL_REGCC = 6                    'ע��CC����
Public Const QNV_CCCTRL_STARTFINDSERVER = 7          '�Զ�����������CC������,255.255.255.255��ʾֻ�㲥ģʽ/0.0.0.0ֻ��Ѱģʽ/�ձ�ʾ�㲥+��Ѱģʽ/����Ϊָ��IP��ʽ
Public Const QNV_CCCTRL_STOPFINDSERVER = 8           'ֹͣ����

'
'����
Public Const QNV_CCCTRL_CALL_START = 1               '����CC
Public Const QNV_CCCTRL_CALL_VOIP = 2               'VOIP�����̻�
Public Const QNV_CCCTRL_CALL_STOP = 3                'ֹͣ����
Public Const QNV_CCCTRL_CALL_ACCEPT = 4              '��������
Public Const QNV_CCCTRL_CALL_BUSY = 5                '����æ��ʾ
Public Const QNV_CCCTRL_CALL_REFUSE = 6              '�ܽ�
Public Const QNV_CCCTRL_CALL_STARTPLAYFILE = 7       '�����ļ�
Public Const QNV_CCCTRL_CALL_STOPPLAYFILE = 8        'ֹͣ�����ļ�
Public Const QNV_CCCTRL_CALL_STARTRECFILE = 9        '��ʼ�ļ�¼��
Public Const QNV_CCCTRL_CALL_STOPRECFILE = 10         'ֹͣ�ļ�¼��
Public Const QNV_CCCTRL_CALL_HOLD = 11               '����ͨ��,��Ӱ�첥���ļ�
Public Const QNV_CCCTRL_CALL_UNHOLD = 12             '�ָ�ͨ��
Public Const QNV_CCCTRL_CALL_SWITCH = 13             '����ת�Ƶ�����CC

Public Const QNV_CCCTRL_CALL_CONFHANDLE = 20         '��ȡ���о�����ڵĻ�����


'
'��Ϣ/����
Public Const QNV_CCCTRL_MSG_SENDMSG = 1              '������Ϣ
Public Const QNV_CCCTRL_MSG_SENDCMD = 2              '��������
'
'����
Public Const QNV_CCCTRL_CONTACT_ADD = 1              '���Ӻ���
Public Const QNV_CCCTRL_CONTACT_DELETE = 2           'ɾ������
Public Const QNV_CCCTRL_CONTACT_ACCEPT = 3           '���ܺ���
Public Const QNV_CCCTRL_CONTACT_REFUSE = 4           '�ܾ�����
Public Const QNV_CCCTRL_CONTACT_GET = 5              '��ȡ����״̬

'������Ϣ/�Լ�����Ϣ
Public Const QNV_CCCTRL_CCINFO_OWNERCC = 1           '��ȡ���˵�½��CC
Public Const QNV_CCCTRL_CCINFO_NICK = 2              '��ȡCC���ǳ�,���û������CC�ͱ�ʾ��ȡ���˵��ǳ�

'socket �ն˿���
Public Const QNV_SOCKET_CLIENT_CONNECT = 1           '���ӵ�������
Public Const QNV_SOCKET_CLIENT_DISCONNECT = 2        '�Ͽ�������
Public Const QNV_SOCKET_CLIENT_STARTRECONNECT = 3    '�Զ�����������
Public Const QNV_SOCKET_CLIENT_STOPRECONNECT = 4     'ֹͣ�Զ�����������
Public Const QNV_SOCKET_CLIENT_ISCONNECTED = 5       '����Ƿ��Ѿ����ӵ���������
Public Const QNV_SOCKET_CLIENT_SENDDATA = 6          '��������
Public Const QNV_SOCKET_CLIENT_APPENDDATA = 7        '׷�ӷ������ݵ����У�������Է��;���������

'../../bin/qnviccub.dll
Public Const QNVDLLPATH = "qnviccub.dll"
'------------------------------------------------------------
'ע�������Lib�ؼ��ֺ��� "qnviccub.dll"����·���������뱣֤��ǰ����Ŀ¼ΪVB��������Ŀ¼����app.path��
'������Ǿ��޸�
'ȷ��û����ϵͳĿ¼system32û����ص�DLL(quviccub.dll/bridge.dll)��������ش���DLL
'byref
'[Alias "��������"]

'�ӿں����б�
'
' ���豸
'BRIINT32  BRISDKLIBAPI    QNV_OpenDevice(BRIUINT32 uDevType,BRIUINT32 uValue,BRICHAR8 *pValue)'C++ԭ��
Public Declare Function QNV_OpenDevice Lib "qnviccub.dll" (ByVal uDevType As Long, ByVal uValue As Long, ByVal pValue As String) As Long

' �ر��豸
'BRIINT32  BRISDKLIBAPI    QNV_CloseDevice(BRIUINT32 uDevType)'C++ԭ��
Public Declare Function QNV_CloseDevice Lib "qnviccub.dll" (ByVal uDevType As Long, ByVal uValue As Long) As Long

' set dev ctrl
'BRIINT32  BRISDKLIBAPI    QNV_SetDevCtrl(BRIINT16 nChannelID,BRIUINT32 uCtrlType,BRIINT32 nValue)'C++ԭ��
Public Declare Function QNV_SetDevCtrl Lib "qnviccub.dll" (ByVal nChannelID As Integer, ByVal uCtrlType As Long, ByVal uValue As Long) As Long

' get dev ctrl
'BRIINT32  BRISDKLIBAPI    QNV_GetDevCtrl(BRIINT16 nChannelID,BRIUINT32 uCtrlType)'C++ԭ��
Public Declare Function QNV_GetDevCtrl Lib "qnviccub.dll" (ByVal nChannelID As Integer, ByVal uCtrlType As Long) As Long


' set param
'BRIINT32  BRISDKLIBAPI    QNV_SetParam(BRIINT16 nChannelID,BRIUINT32 uParamType,BRIINT32 nValue)'C++ԭ��
Public Declare Function QNV_SetParam Lib "qnviccub.dll" (ByVal nChannelID As Integer, ByVal uParamType As Long, ByVal uValue As Long) As Long

' get param
'BRIINT32  BRISDKLIBAPI    QNV_GetParam(BRIINT16 nChannelID,BRIUINT32 uParamType)'C++ԭ��
Public Declare Function QNV_GetParam Lib "qnviccub.dll" (ByVal nChannelID As Integer, ByVal uParamType As Long) As Long


' play file
'BRIINT32  BRISDKLIBAPI    QNV_PlayFile(BRIINT16 nChannelID,BRIUINT32 uPlayType,BRIINT32 nValue,BRIINT32 nValueEx,BRICHAR8 *pValue)'C++ԭ��
Public Declare Function QNV_PlayFile Lib "qnviccub.dll" (ByVal nChannelID As Integer, ByVal uPlayType As Long, ByVal uValue As Long, ByVal uValueEx As Long, ByVal pValue As String) As Long


' play buf
'BRIINT32  BRISDKLIBAPI    QNV_PlayBuf(BRIINT16 nChannelID,BRIUINT32 uPlayType,BRIINT32 nValue,BRIINT32 nValueEx,BRICHAR8 *pValue)'C++ԭ��
Public Declare Function QNV_PlayBuf Lib "qnviccub.dll" (ByVal nChannelID As Integer, ByVal uPlayType As Long, ByVal uValue As Long, ByVal uValueEx As Long, ByVal pValue As String) As Long

' play multifile
'BRIINT32  BRISDKLIBAPI    QNV_PlayMultiFile(BRIINT16 nChannelID,BRIUINT32 uPlayType,BRIINT32 nValue,BRIINT32 nValueEx,BRICHAR8 *pValue)'C++ԭ��
Public Declare Function QNV_PlayMultiFile Lib "qnviccub.dll" (ByVal nChannelID As Integer, ByVal uPlayType As Long, ByVal uValue As Long, ByVal uValueEx As Long, ByVal pValue As String) As Long


' play string
'BRIINT32  BRISDKLIBAPI    QNV_PlayString(BRIINT16 nChannelID,BRIUINT32 uPlayType,BRIINT32 nValue,BRIINT32 nValueEx,BRICHAR8 *pValue)'C++ԭ��
Public Declare Function QNV_PlayString Lib "qnviccub.dll" (ByVal nChannelID As Integer, ByVal uPlayType As Long, ByVal uValue As Long, ByVal uValueEx As Long, ByVal pValue As String) As Long

' record file
'BRIINT32  BRISDKLIBAPI    QNV_RecordFile(BRIINT16 nChannelID,BRIUINT32 uRecordType,BRIINT32 nValue,BRIINT32 nValueEx,BRICHAR8 *pValue)'C++ԭ��
Public Declare Function QNV_RecordFile Lib "qnviccub.dll" (ByVal nChannelID As Integer, ByVal uRecordType As Long, ByVal uValue As Long, ByVal uValueEx As Long, ByVal pValue As String) As Long

' record buf
'BRIINT32  BRISDKLIBAPI    QNV_RecordBuf(BRIINT16 nChannelID,BRIUINT32 uRecordType,BRIINT32 nValue,BRIINT32 nValueEx,BRICHAR8 *pValue)'C++ԭ��
Public Declare Function QNV_RecordBuf Lib "qnviccub.dll" (ByVal nChannelID As Integer, ByVal uRecordType As Long, ByVal uValue As Long, ByVal uValueEx As Long, ByVal pValue As String) As Long

' conference
'BRIINT32  BRISDKLIBAPI    QNV_Conference(BRIINT16 nChannelID,BRIINT32 nConfID,BRIUINT32 uConferenceType,BRIINT32 nValue,BRICHAR8 *pValue)'C++ԭ��
Public Declare Function QNV_Conference Lib "qnviccub.dll" (ByVal nChannelID As Integer, ByVal nConfID As Long, ByVal uConferenceType As Long, ByVal uValue As Long, ByVal pValue As String) As Long
'function                        QNV_Conference(nChannelID:BRIINT16nConfID:longintuConferenceType:longintnValue:longintpValue:PChar):longintstdcallExternal QNVDLLNAME

' speech
'BRIINT32  BRISDKLIBAPI    QNV_Speech(BRIINT16 nChannelID,BRIUINT32 uSpeechType,BRIINT32 nValue,BRICHAR8 *pValue)'C++ԭ��
Public Declare Function QNV_Speech Lib "qnviccub.dll" (ByVal nChannelID As Integer, ByVal uSpeechType As Long, ByVal uValue As Long, ByVal pValue As String) As Long
'function                        QNV_Speech(nChannelID:BRIINT16uSpeechType:longintnValue:longintpValue:PChar):longintstdcallExternal QNVDLLNAME

' fax
'BRIINT32  BRISDKLIBAPI    QNV_Fax(BRIINT16 nChannelID,BRIUINT32 uFaxType,BRIINT32 nValue,BRICHAR8 *pValue)'C++ԭ��
Public Declare Function QNV_Fax Lib "qnviccub.dll" (ByVal nChannelID As Integer, ByVal uFaxType As Long, ByVal uValue As Long, ByVal pValue As String) As Long
'function                        QNV_Fax(nChannelID:BRIINT16uFaxType:longintnValue:longintpValue:PChar):longintstdcallExternal QNVDLLNAME

' event
'BRIINT32  BRISDKLIBAPI    QNV_Event(BRIINT16 nChannelID,BRIUINT32 uEventType,BRIINT32 nValue,BRICHAR8 *pInValue,BRICHAR8 *pOutValue,BRIINT32 nBufSize)'C++ԭ��
Public Declare Function QNV_Event Lib "qnviccub.dll" (ByVal nChannelID As Integer, ByVal uEventType As Long, ByVal uValue As Long, ByVal pInValue As String, ByVal pOutValue As String, ByVal nBufSize As Long) As Long

' general
'BRIINT32  BRISDKLIBAPI    QNV_General(BRIINT16 nChannelID,BRIUINT32 uGeneralType,BRIINT32 nValue,BRICHAR8 *pValue)'C++ԭ��
Public Declare Function QNV_General Lib "qnviccub.dll" (ByVal nChannelID As Integer, ByVal uGeneralType As Long, ByVal uValue As Long, ByVal pValue As String) As Long


' pstn call log
'BRIINT32  BRISDKLIBAPI    QNV_CallLog(BRIINT16 nChannelID,BRIUINT32 uLogType,BRICHAR8 *pValue,BRIINT32 nValue)'C++ԭ��
Public Declare Function QNV_CallLog Lib "qnviccub.dll" (ByVal nChannelID As Integer, ByVal uLogType As Long, ByVal pValue As String, ByVal uValue As Long) As Long

' devinfo
'BRIINT32  BRISDKLIBAPI    QNV_DevInfo(BRIINT16 nChannelID,BRIUINT32 uGeneralType)'C++ԭ��
Public Declare Function QNV_DevInfo Lib "qnviccub.dll" (ByVal nChannelID As Integer, ByVal uGeneralType As Long) As Long


' tool
'BRIINT32  BRISDKLIBAPI    QNV_Tool(BRIUINT32 uToolType,BRIINT32 nValue,BRICHAR8 *pInValue,BRICHAR8 *pInValueEx,BRICHAR8 *pOutValue,BRIINT32 nBufSize)'C++ԭ��
Public Declare Function QNV_Tool Lib "qnviccub.dll" (ByVal uToolType As Long, ByVal uValue As Long, ByVal pInValue As String, ByVal pInValueEx As String, ByVal pOutValue As String, ByVal nBufSize As Long) As Long

' storage read write
'BRIINT32    BRISDKLIBAPI    QNV_Storage(BRIINT16 nDevID,BRIUINT32 uOPType,BRIUINT32 uSeek,BRICHAR8 *pPwd,BRICHAR8 *pValue,BRIINT32 nBufSize);
Public Declare Function QNV_Storage Lib "qnviccub.dll" (ByVal nDevID As Long, ByVal uOPType As Long, ByVal uSeek As Long, ByVal pPwd As String, ByVal pValue As String, ByVal nBufSize As Long) As Long


' remote
'BRIINT32  BRISDKLIBAPI    QNV_Remote(BRIUINT32 uRemoteType,BRIINT32 nValue,BRICHAR8 *pInValue,BRICHAR8 *pInValueEx,BRICHAR8 *pOutValue,BRIINT32 nBufSize)'C++ԭ��
Public Declare Function QNV_Remote Lib "qnviccub.dll" (ByVal uRemoteType As Long, ByVal uValue As Long, ByVal pInValue As String, ByVal pInValueEx As String, ByVal pOutValue As String, ByVal nBufSize As Long) As Long


' CC ctrl
'BRIINT32  BRISDKLIBAPI    QNV_CCCtrl(BRIUINT32 uCtrlType,BRICHAR8 *pInValue,BRIINT32 nValue)'C++ԭ��
Public Declare Function QNV_CCCtrl Lib "qnviccub.dll" (ByVal uCtrlType As Long, ByVal pInValue As String, ByVal uValue As Long) As Long

' CC Call
'BRIINT32  BRISDKLIBAPI    QNV_CCCtrl_Call(BRIUINT32 uCallType,BRIINT32 lSessHandle,BRICHAR8 *pInValue,BRIINT32 nValue)'C++ԭ��
Public Declare Function QNV_CCCtrl_Call Lib "qnviccub.dll" (ByVal uCallType As Long, ByVal lSessHandle As Long, ByVal pInValue As String, ByVal uValue As Long) As Long

' CC msg
'BRIINT32  BRISDKLIBAPI    QNV_CCCtrl_Msg(BRIUINT32 uMsgType,BRICHAR8 *pDestCC,BRICHAR8 *pMsgValue,BRICHAR8 *pParam,BRIINT32 nReserv)'C++ԭ��
Public Declare Function QNV_CCCtrl_Msg Lib "qnviccub.dll" (ByVal uMsgType As Long, ByVal pDestCC As String, ByVal pMsgValue As String, ByVal pParam As String, ByVal nReserv As Long) As Long
'
' CC contact
'BRIINT32  BRISDKLIBAPI    QNV_CCCtrl_Contact(BRIUINT32 uContactType,BRICHAR8 *pCC,BRICHAR8 *pValue)'c++ԭ��
Public Declare Function QNV_CCCtrl_Contact Lib "qnviccub.dll" (ByVal uContactType As Long, ByVal pCC As String, ByVal pValue As String) As Long

' CC contact info
'BRIINT32  BRISDKLIBAPI    QNV_CCCtrl_CCInfo(BRIUINT32 uInfoType,BRICHAR8 *pDestCC,BRICHAR8 *pOutValue,long nBufSize)/c++ ԭ��
Public Declare Function QNV_CCCtrl_CCInfo Lib "qnviccub.dll" (ByVal uInfoType As Long, ByVal pDestCC As String, ByVal pOutValue As String, ByVal nBufSize As Long) As Long
'
'�ն�
'BRIINT32    BRISDKLIBAPI    QNV_Socket_Client(BRIUINT32 uSktType,BRIINT32 nHandle,BRIINT32 nValue,BRICHAR8 *pInValue,BRIINT32 nInValueLen);
Public Declare Function QNV_Socket_Client Lib "qnviccub.dll" (ByVal uSktType As Long, ByVal nHandle As Long, ByVal nValue As Long, ByVal pInValue As String, ByVal nInValueLen As Long) As Long






