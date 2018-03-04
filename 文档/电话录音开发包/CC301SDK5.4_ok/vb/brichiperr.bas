Attribute VB_Name = "brichiperr"
'USB设备操作 返回的错误ID
Public Const BCERR_VALIDHANDLE = -9                 '不合法的句柄
Public Const BCERR_NOPLAYHANDLE = -10               '没有空闲播放句柄
Public Const BCERR_OPENFILEFAILED = -11             '打开文件失败
Public Const BCERR_READFILEFAILED = -12             '读取文件数据错误
Public Const BCERR_WAVHEADERFAILED = -13            '解析文件头失败
Public Const BCERR_NOTSUPPORTFORMAT = -14           '语音格式不支持
Public Const BCERR_NORECHANDLE = -15                '没有足够的录音句柄
Public Const BCERR_CREATEFILEFAILED = -16           '创建录音文件失败
Public Const BCERR_NOBUFSIZE = -17                  '缓冲不够
Public Const BCERR_PARAMERR = -18                   '参数错误
Public Const BCERR_INVALIDTYPE = -19                '不合法的参数类型
Public Const BCERR_INVALIDCHANNEL = -20             '不合法的通道ID
Public Const BCERR_ISMULTIPLAYING = -21             '正在多文件播放,请先停止播放
Public Const BCERR_ISCONFRECING = -22               '正在会议录音,请先停止录音
Public Const BCERR_INVALIDCONFID = -23              '错误的会议ID号
Public Const BCERR_NOTCREATECONF = -24              '会议模块还未创建
Public Const BCERR_NOTCREATEMULTIPLAY = -25         '没有开始多文件播放
Public Const BCERR_NOTCREATESTRINGPLAY = -26        '没有开始字符播放
Public Const BCERR_ISFLASHING = -27                 '正在拍插簧,请先停止
Public Const BCERR_FLASHNOTLINE = -28               '设备没有接通线路不能拍插簧
Public Const BCERR_NOTLOADFAXMODULE = -29           '未启动传真模块
Public Const BCERR_FAXMODULERUNING = -30            '传真正在使用，请先停止
Public Const BCERR_VALIDLICENSE = -31               '错误的license
Public Const BCERR_ISFAXING = -32                   '正在传真不能软挂机
Public Const BCERR_CCMSGOVER = -33                  'CC消息长度太长
Public Const BCERR_CCCMDOVER = -34                  'CC命令长度太长
Public Const BCERR_INVALIDSVR = -35                 '服务器错误
Public Const BCERR_INVALIDFUNC = -36                '未找到指定函数模块
Public Const BCERR_INVALIDCMD = -37                 '未找到指定命令
Public Const BCERR_UNSUPPORTFUNC = -38              '设备不支持该功能unsupport func
Public Const BCERR_DEVNOTOPEN = -39                 '未打开指定设备
Public Const BCERR_INVALIDDEVID = -40               '不合法的ID
Public Const BCERR_INVALIDPWD = -41                 '密码错误
Public Const BCERR_READSTOREAGEERR = -42            '读取存储错误
Public Const BCERR_INVALIDPWDLEN = -43              '密码长度太长
Public Const BCERR_NOTFORMAT = -44                  'flash还未格式化
Public Const BCERR_FORMATFAILED = -45               '格式化失败
Public Const BCERR_NOTENOUGHSPACE = -46             '写入的FLASH数据太长,存储空间不够
Public Const BCERR_WRITESTOREAGEERR = -47           '写入存储错误
Public Const BCERR_NOTSUPPORTCHECK = -48            '通道不支持线路检测功能
Public Const BCERR_INVALIDPATH = -49                '不合法的文件路径
Public Const BCERR_AUDRVINSTALLED = -50             '虚拟声卡驱动已经安装
Public Const BCERR_AUDRVUSEING = -51                '虚拟声卡正在使用不能覆盖,请退出正在使用该驱动的软件或者重新启动电脑再安装
Public Const BCERR_AUDRVCOPYFAILED = -52            '虚拟声卡驱动文件复制失败


Public Const ERROR_INVALIDDLL = -198                '不合法的DLL文件
Public Const ERROR_NOTINIT = -199                   '还没有初始化任何设备
Public Const BCERR_UNKNOW = -200                    '未知错误

'-------------------------------------------------------
'CC 操作 回调的错误ID
Public Const TMMERR_BASE = 0

Public Const TMMERR_SUCCESS = 0
Public Const TMMERR_FAILED = -1                     '异常错误
Public Const TMMERR_ERROR = 1                       '正常错误
Public Const TMMERR_SERVERDEAD = 2                  '服务器没反应
Public Const TMMERR_INVALIDUIN = 3                  '不合法的
Public Const TMMERR_INVALIDUSER = 4                 '不合法的用户
Public Const TMMERR_INVALIDPASS = 5                 '不合法的密码
Public Const TMMERR_DUPLOGON = 6                    '重复登陆
Public Const TMMERR_INVALIDCONTACT = 7              '添加的好友CC不存在
Public Const TMMERR_USEROFFLINE = 8                 '用户不在线
Public Const TMMERR_INVALIDTYPE = 9                 '无效
Public Const TMMERR_EXPIRED = 14                    '超时
Public Const TMMERR_INVALIDDLL = 15                 '无效
Public Const TMMERR_OVERRUN = 16                    '无效
Public Const TMMERR_NODEVICE = 17                   '打开设备失败
Public Const TMMERR_DEVICEBUSY = 18                 '语音呼叫时设备忙
Public Const TMMERR_NOTLOGON = 19                   '未登陆
Public Const TMMERR_ADDSELF = 20                    '不能增加自己为好友
Public Const TMMERR_ADDDUP = 21                     '增加好友重复
Public Const TMMERR_SESSIONBUSY = 23                '无效
Public Const TMMERR_NOINITIALIZE = 25               '还未初始化
Public Const TMMERR_NOANSWER = 26                   '无效
Public Const TMMERR_TIMEOUT = 27                    '无效
Public Const TMMERR_LICENCE = 28                    '无效
Public Const TMMERR_SENDPACKET = 29                 '无效
Public Const TMMERR_EDGEOUT = 30                    '无效
Public Const TMMERR_NOTSUPPORT = 31                 '无效
Public Const TMMERR_NOGROUP = 32                    '无效
Public Const TMMERR_LOWERVER_PEER = 34              '无效
Public Const TMMERR_LOWERVER = 35                   '无效
Public Const TMMERR_HASPOINTS = 36                  '无效
Public Const TMMERR_NOTENOUGHPOINTS = 37            '无效
Public Const TMMERR_NOMEMBER = 38                   '无效
Public Const TMMERR_NOAUTH = 39                     '无效
Public Const TMMERR_REGTOOFAST = 40                 '注册太快
Public Const TMMERR_REGTOOMANY = 41                 '注册太多
Public Const TMMERR_POINTSFULL = 42                 '无效
Public Const TMMERR_GROUPOVER = 43                  '无效
Public Const TMMERR_SUBGROUPOVER = 44               '无效
Public Const TMMERR_HASMEMBER = 45                  '无效
Public Const TMMERR_NOCONFERENCE = 46               '无效
Public Const TMMERR_RECALL = 47                     '呼叫转移
Public Const TMMERR_SWITCHVOIP = 48                 '修改VOIP服务器地址
Public Const TMMERR_RECFAILED = 49                  '设备录音错误

Public Const TMMERR_CANCEL = 101                    '自己取消
Public Const TMMERR_CLIENTCANCEL = 102              '对方取消
Public Const TMMERR_REFUSE = 103                    '拒绝对方
Public Const TMMERR_CLIENTREFUSE = 104              '对方拒绝
Public Const TMMERR_STOP = 105                      '自己停止=已接通
Public Const TMMERR_CLIENTSTOP = 106                '对方停止=已接通

Public Const TMMERR_VOIPCALLFAILED = 108            '帐号没钱了
Public Const TMMERR_VOIPCONNECTED = 200             'VOIP网络连通了
Public Const TMMERR_VOIPDISCONNECTED = 201          '跟服务器断开连接，SOCKET 服务器关闭了。
Public Const TMMERR_VOIPACCOUNTFAILED = 202         '余额不够
Public Const TMMERR_VOIPPWDFAILED = 203             '帐号密码错误
Public Const TMMERR_VOIPCONNECTFAILED = 204         '连接VOIP服务器失败
Public Const TMMERR_STARTPROXYTRANS = 205           '通过代理服务器中转了
'----------------------------------------------------------

