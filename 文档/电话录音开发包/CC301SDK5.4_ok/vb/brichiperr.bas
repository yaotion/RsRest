Attribute VB_Name = "brichiperr"
'USB�豸���� ���صĴ���ID
Public Const BCERR_VALIDHANDLE = -9                 '���Ϸ��ľ��
Public Const BCERR_NOPLAYHANDLE = -10               'û�п��в��ž��
Public Const BCERR_OPENFILEFAILED = -11             '���ļ�ʧ��
Public Const BCERR_READFILEFAILED = -12             '��ȡ�ļ����ݴ���
Public Const BCERR_WAVHEADERFAILED = -13            '�����ļ�ͷʧ��
Public Const BCERR_NOTSUPPORTFORMAT = -14           '������ʽ��֧��
Public Const BCERR_NORECHANDLE = -15                'û���㹻��¼�����
Public Const BCERR_CREATEFILEFAILED = -16           '����¼���ļ�ʧ��
Public Const BCERR_NOBUFSIZE = -17                  '���岻��
Public Const BCERR_PARAMERR = -18                   '��������
Public Const BCERR_INVALIDTYPE = -19                '���Ϸ��Ĳ�������
Public Const BCERR_INVALIDCHANNEL = -20             '���Ϸ���ͨ��ID
Public Const BCERR_ISMULTIPLAYING = -21             '���ڶ��ļ�����,����ֹͣ����
Public Const BCERR_ISCONFRECING = -22               '���ڻ���¼��,����ֹͣ¼��
Public Const BCERR_INVALIDCONFID = -23              '����Ļ���ID��
Public Const BCERR_NOTCREATECONF = -24              '����ģ�黹δ����
Public Const BCERR_NOTCREATEMULTIPLAY = -25         'û�п�ʼ���ļ�����
Public Const BCERR_NOTCREATESTRINGPLAY = -26        'û�п�ʼ�ַ�����
Public Const BCERR_ISFLASHING = -27                 '�����Ĳ��,����ֹͣ
Public Const BCERR_FLASHNOTLINE = -28               '�豸û�н�ͨ��·�����Ĳ��
Public Const BCERR_NOTLOADFAXMODULE = -29           'δ��������ģ��
Public Const BCERR_FAXMODULERUNING = -30            '��������ʹ�ã�����ֹͣ
Public Const BCERR_VALIDLICENSE = -31               '�����license
Public Const BCERR_ISFAXING = -32                   '���ڴ��治����һ�
Public Const BCERR_CCMSGOVER = -33                  'CC��Ϣ����̫��
Public Const BCERR_CCCMDOVER = -34                  'CC�����̫��
Public Const BCERR_INVALIDSVR = -35                 '����������
Public Const BCERR_INVALIDFUNC = -36                'δ�ҵ�ָ������ģ��
Public Const BCERR_INVALIDCMD = -37                 'δ�ҵ�ָ������
Public Const BCERR_UNSUPPORTFUNC = -38              '�豸��֧�ָù���unsupport func
Public Const BCERR_DEVNOTOPEN = -39                 'δ��ָ���豸
Public Const BCERR_INVALIDDEVID = -40               '���Ϸ���ID
Public Const BCERR_INVALIDPWD = -41                 '�������
Public Const BCERR_READSTOREAGEERR = -42            '��ȡ�洢����
Public Const BCERR_INVALIDPWDLEN = -43              '���볤��̫��
Public Const BCERR_NOTFORMAT = -44                  'flash��δ��ʽ��
Public Const BCERR_FORMATFAILED = -45               '��ʽ��ʧ��
Public Const BCERR_NOTENOUGHSPACE = -46             'д���FLASH����̫��,�洢�ռ䲻��
Public Const BCERR_WRITESTOREAGEERR = -47           'д��洢����
Public Const BCERR_NOTSUPPORTCHECK = -48            'ͨ����֧����·��⹦��
Public Const BCERR_INVALIDPATH = -49                '���Ϸ����ļ�·��
Public Const BCERR_AUDRVINSTALLED = -50             '�������������Ѿ���װ
Public Const BCERR_AUDRVUSEING = -51                '������������ʹ�ò��ܸ���,���˳�����ʹ�ø���������������������������ٰ�װ
Public Const BCERR_AUDRVCOPYFAILED = -52            '�������������ļ�����ʧ��


Public Const ERROR_INVALIDDLL = -198                '���Ϸ���DLL�ļ�
Public Const ERROR_NOTINIT = -199                   '��û�г�ʼ���κ��豸
Public Const BCERR_UNKNOW = -200                    'δ֪����

'-------------------------------------------------------
'CC ���� �ص��Ĵ���ID
Public Const TMMERR_BASE = 0

Public Const TMMERR_SUCCESS = 0
Public Const TMMERR_FAILED = -1                     '�쳣����
Public Const TMMERR_ERROR = 1                       '��������
Public Const TMMERR_SERVERDEAD = 2                  '������û��Ӧ
Public Const TMMERR_INVALIDUIN = 3                  '���Ϸ���
Public Const TMMERR_INVALIDUSER = 4                 '���Ϸ����û�
Public Const TMMERR_INVALIDPASS = 5                 '���Ϸ�������
Public Const TMMERR_DUPLOGON = 6                    '�ظ���½
Public Const TMMERR_INVALIDCONTACT = 7              '��ӵĺ���CC������
Public Const TMMERR_USEROFFLINE = 8                 '�û�������
Public Const TMMERR_INVALIDTYPE = 9                 '��Ч
Public Const TMMERR_EXPIRED = 14                    '��ʱ
Public Const TMMERR_INVALIDDLL = 15                 '��Ч
Public Const TMMERR_OVERRUN = 16                    '��Ч
Public Const TMMERR_NODEVICE = 17                   '���豸ʧ��
Public Const TMMERR_DEVICEBUSY = 18                 '��������ʱ�豸æ
Public Const TMMERR_NOTLOGON = 19                   'δ��½
Public Const TMMERR_ADDSELF = 20                    '���������Լ�Ϊ����
Public Const TMMERR_ADDDUP = 21                     '���Ӻ����ظ�
Public Const TMMERR_SESSIONBUSY = 23                '��Ч
Public Const TMMERR_NOINITIALIZE = 25               '��δ��ʼ��
Public Const TMMERR_NOANSWER = 26                   '��Ч
Public Const TMMERR_TIMEOUT = 27                    '��Ч
Public Const TMMERR_LICENCE = 28                    '��Ч
Public Const TMMERR_SENDPACKET = 29                 '��Ч
Public Const TMMERR_EDGEOUT = 30                    '��Ч
Public Const TMMERR_NOTSUPPORT = 31                 '��Ч
Public Const TMMERR_NOGROUP = 32                    '��Ч
Public Const TMMERR_LOWERVER_PEER = 34              '��Ч
Public Const TMMERR_LOWERVER = 35                   '��Ч
Public Const TMMERR_HASPOINTS = 36                  '��Ч
Public Const TMMERR_NOTENOUGHPOINTS = 37            '��Ч
Public Const TMMERR_NOMEMBER = 38                   '��Ч
Public Const TMMERR_NOAUTH = 39                     '��Ч
Public Const TMMERR_REGTOOFAST = 40                 'ע��̫��
Public Const TMMERR_REGTOOMANY = 41                 'ע��̫��
Public Const TMMERR_POINTSFULL = 42                 '��Ч
Public Const TMMERR_GROUPOVER = 43                  '��Ч
Public Const TMMERR_SUBGROUPOVER = 44               '��Ч
Public Const TMMERR_HASMEMBER = 45                  '��Ч
Public Const TMMERR_NOCONFERENCE = 46               '��Ч
Public Const TMMERR_RECALL = 47                     '����ת��
Public Const TMMERR_SWITCHVOIP = 48                 '�޸�VOIP��������ַ
Public Const TMMERR_RECFAILED = 49                  '�豸¼������

Public Const TMMERR_CANCEL = 101                    '�Լ�ȡ��
Public Const TMMERR_CLIENTCANCEL = 102              '�Է�ȡ��
Public Const TMMERR_REFUSE = 103                    '�ܾ��Է�
Public Const TMMERR_CLIENTREFUSE = 104              '�Է��ܾ�
Public Const TMMERR_STOP = 105                      '�Լ�ֹͣ=�ѽ�ͨ
Public Const TMMERR_CLIENTSTOP = 106                '�Է�ֹͣ=�ѽ�ͨ

Public Const TMMERR_VOIPCALLFAILED = 108            '�ʺ�ûǮ��
Public Const TMMERR_VOIPCONNECTED = 200             'VOIP������ͨ��
Public Const TMMERR_VOIPDISCONNECTED = 201          '���������Ͽ����ӣ�SOCKET �������ر��ˡ�
Public Const TMMERR_VOIPACCOUNTFAILED = 202         '����
Public Const TMMERR_VOIPPWDFAILED = 203             '�ʺ��������
Public Const TMMERR_VOIPCONNECTFAILED = 204         '����VOIP������ʧ��
Public Const TMMERR_STARTPROXYTRANS = 205           'ͨ�������������ת��
'----------------------------------------------------------

