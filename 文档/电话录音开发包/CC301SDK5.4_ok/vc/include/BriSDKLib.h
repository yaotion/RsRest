#ifndef __BRISDKLIB_H__
#define __BRISDKLIB_H__

//---------------------------------------------------------
//USB/CC设备开发接口和参数说明
//---------------------------------------------------------

#ifdef __cplusplus
extern "C" {
#endif

#ifndef WIN32
#define BRISDKLIBAPI
#else
#define BRISDKLIBAPI	WINAPI
#endif

//2009/10/10
//#define		QNV_DLL_VER						0x0101
//#define		QNV_DLL_VER_STR					"1.01"
//2010/01/08
//#define		QNV_DLL_VER						0x0102
//#define		QNV_DLL_VER_STR					"1.02"
//2010/02/04 增加c/s socket远程通信接口
//#define		QNV_DLL_VER						0x0103
//#define		QNV_DLL_VER_STR					"1.03"

//2010/03/05
//#define		QNV_DLL_VER						0x0104
//#define		QNV_DLL_VER_STR					"1.04"

//2010/09/20
//#define		QNV_DLL_VER						0x0105
//#define		QNV_DLL_VER_STR					"1.05"

//2010/10/29
//#define		QNV_DLL_VER							0x0106
//#define		QNV_DLL_VER_STR						"1.06"

//2011/04/18
#define		QNV_DLL_VER							0x0201
#define		QNV_DLL_VER_STR						"2.01"

#define		QNV_CC_LICENSE						"quniccub_x"	

//---------------------------------------------
typedef  __int64			BRIINT64;//符号 64bit(8字节)
typedef  __int32			BRIINT32;//符号 32bit(4字节)
typedef  unsigned __int32   BRIUINT32;//无符号 32bit(4字节)
typedef	 __int16			BRIINT16;//符号 16bit(2字节)
typedef	 unsigned __int16	BRIUINT16;//符号 16bit(2字节)
typedef	 unsigned char		BRIBYTE8;//无符号 8bit(1字节)
typedef  char				BRICHAR8;//符号 8bit(1字节)
typedef  char*				BRIPCHAR8;//字符串指针(ANSI)
typedef  short*				BRIPSHORT16;//字符串指针(UNICODE)
//---------------------------------------------

//播放/录音回调时如果返回该值，系统将自动删除该回调模块，下次将不会被回调
#define		CB_REMOVELIST						(-1)

//多个文件播放列表分割符号
#define		MULTI_SEPA_CHAR						'|'
//代拨标记
#define		PROXYDIAL_SIGN						0x40000000
//代拨标记
#define		PROXYDIAL_SIGN_STRU					'P'
//代拨标记
#define		PROXYDIAL_SIGN_STRL					'p'

#define		RING_BEGIN_SIGN_STR					"0"
#define		RING_END_SIGN_STR					"1"
#define		RING_BEGIN_SIGN_CH					'0'
#define		RING_END_SIGN_CH					'1'

#define		RINGBACK_TELDIAL_STR				"0"
#define		RINGBACK_PCDIAL_STR					"1"
#define		RINGBACK_PCDIAL_CH					'1'
#define		RINGBACK_TELDIAL_CH					'0'

//默认拍插簧间隔时间(ms)
#define		DEFAULT_FLASH_ELAPSE				600
//默认拍插簧后间隔一定时间回调事件ms
#define		DEFAULT_FLASHEND_ELAPSE				1000
//默认给内部话机/交换机震铃时间ms响 1秒
#define		DEFAULT_RING_ELAPSE					1000
//默认给内部话机/交换机震铃后停止ms 4秒
#define		DEFAULT_RINGSILENCE_ELAPSE			4000
//默认给内线震铃超时次数,每次1秒响4秒停,总共时间就为N*5秒
#define		DEFAULT_RING_TIMEOUT				12
//拒接时默认使用间隔(ms)
#define		DEFAULT_REFUSE_ELAPSE				500
//默认拨号速度(ms)
#define		DEFAULT_DIAL_SPEED					100
//默认号码之间静音时间(ms)
#define		DEFAULT_DIAL_SILENCE				100
//检测拨号音超时就强制呼叫(ms)
#define		DEFAULT_CHECKDIALTONE_TIMEOUT		3000
//来电响铃超时ms
#define		DEFAULT_CALLINTIMEOUT				5500

//拨号时号码之间延迟1秒
#define		DIAL_DELAY_SECOND					','
//拨号时号码之间延迟0.5秒
#define		DIAL_DELAY_HSECOND					'.'
//拨号时该符号后自动过滤城市区号
#define		DIAL_CHECK_CITYCODE					':'

//CC参数的分隔符号
#define		CC_PARAM_SPLIT						','
//伪代码执行时的分隔符号
#define		EXEC_CMD_CHAR						' '

//自动创建录音文件时的默认目录名
#define		RECFILE_DIR							"recfile"
//配置信息里的KEY
#define		INI_QNVICC							"qnvicc"
//默认配置文件名
#define		INI_FILENAME						"cc301config.ini"
//VOIP代拨标记
#define		CC_VOIP_SIGN						"VOIP"
//匿名登陆CC,密码跟号码为相同
#define		WEB_802ID							"800002000000000000"

//支持的最多USB芯片数
#define		MAX_USB_COUNT						64
//支持的最多USB通道数
#define		MAX_CHANNEL_COUNT					128

//声卡控制有效通道ID号
//0->255为USB设备通道号
#define		SOUND_CHANNELID						(BRIINT16)256
//远程http通信通道,HTTP上传/下载
#define		REMOTE_CHANNELID					(BRIINT16)257
//CC控制通道
#define		CCCTRL_CHANNELID					(BRIINT16)258
//socket 服务器端通道
#define		SOCKET_SERVER_CHANNELID				(BRIINT16)259
//socket 终端通道
#define		SOCKET_CLIENT_CHANNELID				(BRIINT16)260
//UDP通道
#define		SOCKET_UDP_CHANNELID				(BRIINT16)261
//ICC301虚拟声卡驱动控制
#define		AUDRV_CHANNELID						(BRIINT16)262

//发送CC消息的最大长度
#define		MAX_CCMSG_LEN						400
//发送CC命令的最大长度
#define		MAX_CCCMD_LEN						400
//存储模块一次最多读取的长度
#define		MAX_STORAGE_LEN						1024

//通道类型
#define		CHANNELTYPE_PHONE					0x1//phone模块
#define		CHANNELTYPE_LINE					0x2//line模块

//设备类型
#define		DEVTYPE_UNKNOW						-1//未知设备
//内部使用系列
#define		DEVTYPE_T2F							0x100c
#define		DEVTYPE_TC2_R						0x1007
//
//cc301系列
#define		DEVTYPE_T1							0x1009
#define		DEVTYPE_T2							0x1000
#define		DEVTYPE_T3							0x1008
#define		DEVTYPE_T4							0x1005
#define		DEVTYPE_T5							0x1001
#define		DEVTYPE_T6							0x1004

//8-I系列/1-单路/0-R系列/1-A系列第1个
#define		DEVTYPE_IR1							0x8100
#define		DEVTYPE_ID1							0x8102
//8-I系列/1-单路/1-A系列/1-A系列第1个
#define		DEVTYPE_IA1							0x8111
#define		DEVTYPE_IA2							0x8112
#define		DEVTYPE_IA3							0x8113
#define		DEVTYPE_IA4							0x8114
#define		DEVTYPE_IA4_F						0x8115
//8-I系列/1-单路/2-B系列/1-A系列第1个
#define		DEVTYPE_IB1							0x8121
#define		DEVTYPE_IB2							0x8122
#define		DEVTYPE_IB3							0x8123
#define		DEVTYPE_IB4							0x8124
//8-I系列/1-单路/3-P系列/1-A系列第1个
#define		DEVTYPE_IP1							0x8131
#define		DEVTYPE_IP1_F						0x8132
//2路设备
#define		DEVTYPE_IC2_R						0x8200
#define		DEVTYPE_IC2_LP						0x8203
#define		DEVTYPE_IC2_LPQ						0x8207
#define		DEVTYPE_IC2_LPF						0x8211
//4路设备
#define		DEVTYPE_IC4_R						0x8400
#define		DEVTYPE_IC4_LP						0x8403
#define		DEVTYPE_IC4_LPQ						0x8407
#define		DEVTYPE_IC4_LPF						0x8411
//7路设备
#define		DEVTYPE_IC7_R						0x8700
#define		DEVTYPE_IC7_LP						0x8703
#define		DEVTYPE_IC7_LPQ						0x8707
#define		DEVTYPE_IC7_LPF						0x8711

#define		DEVTYPE_Z2							0x9001//OEM芯片开发板
#define		DEVTYPE_K1							0x9101//保留

//玻瑞器
#define		DEVTYPE_A1							0x1100000
#define		DEVTYPE_A2							0x1200000
#define		DEVTYPE_A3							0x1300000
#define		DEVTYPE_A4							0x1400000
#define		DEVTYPE_B1							0x2100000
#define		DEVTYPE_B2							0x2200000
#define		DEVTYPE_B3							0x2300000
#define		DEVTYPE_B4							0x2400000
#define 	DEVTYPE_C4_L						0x3100000
#define 	DEVTYPE_C4_P						0x3200000
#define 	DEVTYPE_C4_LP						0x3300000
#define 	DEVTYPE_C4_LPQ						0x3400000
#define		DEVTYPE_C7_L						0x3500000	
#define		DEVTYPE_C7_P						0x3600000
#define		DEVTYPE_C7_LP						0x3700000
#define		DEVTYPE_C7_LPQ						0x3800000
#define		DEVTYPE_R1							0x4100000
#define		DEVTYPE_C4_R						0x4200000
#define		DEVTYPE_C7_R						0x4300000
//
//--------------------------------------------------------------
//设备功能模块定义
//是否具有内置喇叭功能
//可以PC播放语音到喇叭/通话时线路声音到喇叭
#define		DEVMODULE_DOPLAY					0x1
//是否具有可接入外线获取来电号码(FSK/DTMF双制式)/通话录音功能
//可以来电弹屏/通话录音/通话时获取对方按键(DTMF)
#define		DEVMODULE_CALLID					0x2
//是否具有可接入话机进行PSTN通话功能
//可以使用电话机进行PSTN通话/获取话机拨出的号码
#define		DEVMODULE_PHONE						0x4
//是否具有继电器切换断开/接通话机功能
//断开话机后可以:来电时话机不响铃/使用话机MIC独立采集录音,可以配合DEVFUNC_RING模块给话机模拟来电震铃
#define		DEVMODULE_SWITCH					0x8
//PC播放语音给话机听筒,具有 DEVMODULE_SWITCH模块,switch后播放语音到话机听筒
#define		DEVMODULE_PLAY2TEL					0x10
//是否具有PC摘机后拨号/放音给线路的功能
//可以使用PC自动摘机进行拨号/通话时可以给对方播放语音/来电留言/外拨通知/来电IVR(语音答录)
#define		DEVMODULE_HOOK						0x20
//是否具有插入MIC/耳机功能
//可以用MIC/耳机进行PSTN通话/使用MIC独立录音/PC播放语音给耳机
#define		DEVMODULE_MICSPK					0x40
//是否具有让接在phone口的设备(电话机,交换机等)模拟震铃功能
//可以任意时刻让phone口的设备模拟来电震铃.如:在来电IVR(语音答录)之后进入工服务时给内部话机或交换机模拟震铃
#define		DEVMODULE_RING						0x80
//是否具有接收/发送传真功能
//可以发送图片,文档到对方的传真机/可以接收保存对方传真机发送过来的图片
#define		DEVMODULE_FAX						0x100
//是否具有存储功能
#define		DEVMODULE_STORAGE					0x200
//具有级性反转检测对方摘机的功能
//如果PSTN线路在当地电信部门同时开通该级性反转检测服务,就可以在外拨时精确检测到对方摘机/挂机
//如果没有该功能,只有拨打的号码具有标准回铃才才能检测到对方摘机,对手机彩铃,IP等不具有标准回铃线路的不能检测对方摘机/挂机
#define		DEVMODULE_POLARITY					0x800
//----------------------------------------------------------------


//保存用户自定义参数
//保存tool用户数据立即写入文件
#define		SUD_WRITEFILE						0x1
//加密
#define		SUD_ENCRYPT							0x2
//释放资源,下次读写入时重新读取文件
#define		SUD_UNLOAD							0x4
//

//打开设备类型
#define		ODT_LBRIDGE							0x0//CC301设备
#define		ODT_SOUND							0x1//声卡
#define		ODT_CC								0x2//CC模块
#define		ODT_SOCKET_CLIENT					0x4//SOCKET终端模块
#define		ODT_SOCKET_SERVER					0x8//SOCKET服务器模块
#define		ODT_SOCKET_UDP						0x10//UDP模块
#define		ODT_AUDRV							0x20//虚拟声卡模块
#define		ODT_ALL								0xFF//全部类型
#define		ODT_CHANNEL							0x100//关闭指定CC301通道
//

//-----------------------------------------------------
//linein线路选择
#define		LINEIN_ID_1							0x0//电话机断开后话柄录音
#define		LINEIN_ID_2							0x1//默认正常状态录音，采集来电号码等
#define		LINEIN_ID_3							0x2//hook line 软摘机后录音,录音数据可以提高对方的音量,降低本地音量
#define		LINEIN_ID_LOOP						0x3//内部环路测试,设备测试使用,建议用户不需要使用
//-----------------------------------------------------

#define		ADCIN_ID_MIC						0x0//mic录音
#define		ADCIN_ID_LINE						0x1//电话线录音

//adc
//芯片第2个通道的电话线的声音到喇叭
#define		DOPLAY_CHANNEL1_ADC					0x0
//芯片第1个通道的电话线的声音到喇叭
#define		DOPLAY_CHANNEL0_ADC					0x1
//从芯片第1个通道播放的声音到喇叭
#define		DOPLAY_CHANNEL0_DAC					0x2
//从芯片第2个通道播放的声音到喇叭
#define		DOPLAY_CHANNEL1_DAC					0x3

//------------
#define		SOFT_FLASH							0x1//使用软件调用拍插完成
#define		TEL_FLASH							0x2//使用话机拍插完成
//------------

#define		HOOK_VOICE							0x0//语音检测的摘挂机信号
#define		HOOK_POLARITY						0x1//反级检测的摘挂机信号
//拒接时使用模式
#define		REFUSE_ASYN							0x0//异步模式,调用后函数立即返回，但并不表示拒接完成，拒接完成后将接收到一个拒接完成的事件
#define		REFUSE_SYN							0x1//同步模式,调用后该函数被堵塞，等待拒接完成返回，系统不再有拒接完成的事件

//拍插簧类型
#define		FT_NULL								0x0
#define		FT_TEL								0x1//话机拍插簧
#define		FT_PC								0x2//软拍插簧
#define		FT_ALL								(FT_TEL|FT_PC)
//-------------------------------

//拨号类型
#define		DTT_DIAL							0x0//拨号
#define		DTT_SEND							0x1//二次发码/震铃发送CALLID
//-------------------------------

//来电号码模式
#define		CALLIDMODE_NULL						0x0//未知
#define		CALLIDMODE_FSK						0x1//FSK来电
#define		CALLIDMODE_DTMF						0x2//DTMF来电
//

//号码类型
#define		CTT_NULL							0x0
#define		CTT_MOBILE							0x1//移动号码
#define		CTT_PSTN							0x2//普通固话号码
//------------------------------

#define		CALLT_NULL							0x0//
#define		CALLT_CALLIN						0x1//来电
#define		CALLT_CALLOUT						0x2//去电
//-------------------

#define		CRESULT_NULL						0x0
#define		CRESULT_MISSED						0x1//呼入未接
#define		CRESULT_REFUSE						0x2//呼入拒接
#define		CRESULT_RINGBACK					0x3//呼叫后回铃了
#define		CRESULT_CONNECTED					0x4//接通
//-------------------------------

#define		OPTYPE_NULL							0x0
//上传成功后删除本地文件
#define		OPTYPE_REMOVE						0x1
//本地保存临时记录,成功后删除,如果没成功，以后可以重新传
#define		OPTYPE_SAVE							0x2

//设备错误ID
#define		DERR_READERR						0x0//读取数据错误
#define		DERR_WRITEERR						0x1//写入数据错误
#define		DERR_FRAMELOST						0x2//丢数据包
#define		DERR_REMOVE							0x3//设备移除
#define		DERR_SERIAL							0x4//设备序列号冲突
//--------------------------------

//语音识别时的性别类型
#define		SG_NULL								0x0
#define		SG_MALE								0x1//男性
#define		SG_FEMALE							0x2//女性
#define		SG_AUTO								0x3//自动
//--------------------------------

//设备共享模式
#define		SM_NOTSHARE							0x0
#define		SM_SENDVOICE						0x1//发送语音
#define		SM_RECVVOICE						0x2//接收语音
//----------------------------------

//----------------------------------------------
//传真接受/发送
#define		FAX_TYPE_NULL						0x0
#define		FAX_TYPE_SEND						0x1//发送传真
#define		FAX_TYPE_RECV						0x2//接收传真
//------------------------------------------------

//
#define		TTS_LIST_REINIT						0x0//重新初始化新的TTS列表
#define		TTS_LIST_APPEND						0x1//追加TTS列表文件
//------------------------------------------------

//--------------------------------------------------------
#define		DIALTYPE_DTMF						0x0//DTMF拨号
#define		DIALTYPE_FSK						0x1//FSK拨号
//--------------------------------------------------------

//--------------------------------------------------------
#define		PLAYFILE_MASK_REPEAT				0x1//循环播放
#define		PLAYFILE_MASK_PAUSE					0x2//默认暂停
//--------------------------------------------------------

//播放文件回调的状态
#define		PLAYFILE_PLAYING					0x1//正在播放
#define		PLAYFILE_REPEAT						0x2//准备重复播放
#define		PLAYFILE_END						0x3//播放结束

//-----------------------------------------------------------------------------------
#define		RECORD_MASK_ECHO					0x1//回音抵消后的数据
#define		RECORD_MASK_AGC						0x2//自动增益后录音
#define		RECORD_MASK_PAUSE					0x4//暂停

#define		CONFERENCE_MASK_DISABLEMIC			0x100//停止MIC,会议中其它成员不能听到该用户说话
#define		CONFERENCE_MASK_DISABLESPK			0x200//停止SPK,不能听到会议中其它成员说话
//------------------------------------------------------------------------------------

#define		CHECKLINE_MASK_DIALOUT				0x1//线路是否有正常拨号音(有就可以正常软拨号)
#define		CHECKLINE_MASK_REV					0x2//线路LINE口/PHONE口接线是否正常,不正常就表示接反了

#define		CHECKDIALTONE_BEGIN					0x0//检测拨号音
#define		CHECKDIALTONE_ENDDIAL				0x1//检测到拨号音准备拨号

#define		CHECKDIALTONE_TIMEOUTDIAL			0x2//检测拨号音超时强制自动拨号
#define		CHECKDIALTONE_FAILED				0x3//检测拨号音超时就报告拨号失败,不拨号


#define		IPMODE_NULL							0x0//空
#define		IPMODE_BROADCAST					0x1//广播
#define		IPMODE_LISTALL						0x2//搜索全部IP
#define		IPMODE_LISTIP						0x4//搜索固定IP
#define		IPMODE_ALL							0xFF//全部

#define		RB_RINGBACK							0x0//回铃信号
#define		RB_TIMEOUT							0x1//拨号超时
#define		RB_CODEEND							0x2//号码长度动态计算完毕

#define		SPEECH_DEV							0x0//设备语音识别
#define		SPEECH_FILE							0x1//文件语音识别

#define		REMOTE_ASYN							0x1//异步

#define		OUTVALUE_MAX_SIZE					260//location等返回的最大长度


//-----------------------------------------------

//cc 消息参数
//具体字体参数意义请查看windows相关文档
#define		MSG_KEY_CC				"cc:" //消息来源CC号
#define		MSG_KEY_NAME			"name:"//消息来源名称，保留
#define		MSG_KEY_TIME			"time:"//消息来源时间
#define		MSG_KEY_FACE			"face:"//字体名称
#define		MSG_KEY_COLOR			"color:"//字体颜色
#define		MSG_KEY_SIZE			"size:"//字体尺寸
#define		MSG_KEY_CHARSET			"charset:"//字体特征
#define		MSG_KEY_EFFECTS			"effects:"//字体效果
#define		MSG_KEY_LENGTH			"length:"//消息正文长度
#define		MSG_KEY_CID				"cid:"//会议ID
#define		MSG_KEY_IMTYPE			"imtp:"//消息类型
//CC文件参数
#define		MSG_KEY_FILENAME		"filename:"//文件名
#define		MSG_KEY_FILESIZE		"filesize:"//文件长度
#define		MSG_KEY_FILETYPE		"filetype:"//文件类型
//
#define		MSG_KEY_CALLPARAM		"callparam:"//CC呼叫时的参数


#define		MSG_KEY_IP				"ip:"//接收到的UDP数据的IP地址
#define		MSG_KEY_WEBIP			"webip:"//接收到的UDP数据的web IP地址
#define		MSG_KEY_PORT			"port:"//接收到的UDP数据的端口

#define		MSG_KEY_SPLIT			"\r\n"//参数之间分隔符号
#define		MSG_TEXT_SPLIT			"\r\n\r\n"//消息参数和消息内容的分隔符号
//

//事件产生后保存的数据最大长度,需要保存即时消息400字节内容加附加信息最大在550左右
#define		MAX_BRIEVENT_DATA	600
//4字节对齐
typedef struct tag_BriEvent_Data
{
	BRICHAR8	uVersion;//结构版本，保留
	BRICHAR8	uReserv;//保留
	BRIINT16	uChannelID;//通道ID
	BRIINT32	lEventType;//事件类型ID 查看BRI_EVENT.lEventType Define
	BRIINT32	lEventHandle;//事件相关句柄
	BRIINT32	lResult;//事件相关数值
	BRIINT32	lParam;//保留,扩展时使用
	BRICHAR8	szData[MAX_BRIEVENT_DATA];//事件相关数据.如：来电时，保存了来电的号码
	BRICHAR8	szDataEx[32];//保留,扩展时使用

}BRI_EVENT,*PBRI_EVENT;


//----------------------------------------------------------------------
//回调函数原型
//----------------------------------------------------------------------
//
//缓冲播放回调原型
//uChannelID:通道ID
//dwUserData:用户自定义的数据
//lHandle:播放时返回的句柄
//lDataSize:当前缓冲的语音数据
//lFreeSize:当前缓冲的空闲长度
//返回 CB_REMOVELIST(-1) 将被系统删除该回调资源，下次不再回调/返回其它值保留
typedef BRIINT32 (CALLBACK *PCallBack_PlayBuf)(BRIINT16 uChannelID,BRIUINT32 dwUserData,BRIINT32 lHandle,BRIINT32 lDataSize,BRIINT32 lFreeSize);
///////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//设置文件播放回调原型
//uChannelID:通道ID
//nPlayState:文件播放的状态,PLAYING/REPLAY/END
//dwUserData:用户自定义的数据
//lHandle:播放时返回的句柄
//lElapses:总共播放的时间(单位秒)
//返回 CB_REMOVELIST(-1) 系统将自动停止播放该文件/返回其它值保留
typedef BRIINT32 (CALLBACK *PCallBack_PlayFile)(BRIINT16 uChannelID,BRIUINT32 nPlayState,BRIUINT32 dwUserData,BRIINT32 lHandle,BRIINT32 lElapses);

//////////////////////////////////////////////////////////////////////////////////////////
//缓冲录音回调原型 默认格式为8K/16位/单声道/线性
//uChannelID:通道ID
//dwUserData:用户自定义数据
//pBufData:语音数据
//lBufSize:语音数据的内存字节长度
//返回 CB_REMOVELIST(-1) 将被系统删除该回调资源，下次不再回调/返回其它值保留
//注意:不要在回调函数里删除该回调功能,会引起回调死锁,如果想在回调里删除该回调功能只要把该回调函数返回CB_REMOVELIST(-1)即可
//消息模式回调也一样
typedef BRIINT32 (CALLBACK *PCallBack_RecordBuf)(BRIINT16 uChannelID,BRIUINT32 dwUserData,BRIBYTE8 *pBufData,BRIINT32 lBufSize);
////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////
//事件发生回调原型
//uChannelID:通道ID
//dwUserData:用户自定义数据
//lType:事件类型ID 查看BRI_EVENT.lEventType Define
//lResult:事件相关数据
//lParam:保留数据,扩展使用
//szData:事件相关数据
//pDataEx:附加数据,扩展使用
/////////////////////////////////////////////////////////////////////////////////////////
typedef BRIINT32 (CALLBACK *PCallBack_Event)(BRIINT16 uChannelID,BRIUINT32 dwUserData,BRIINT32	lType,BRIINT32 lHandle,BRIINT32 lResult,BRIINT32 lParam,BRIPCHAR8 pData,BRIPCHAR8 pDataEx);

//////////////////////////////////////////////////////////////////////////////////////////
//事件发生回调原型,使用结构体方式
//pEvent:事件结构体数据
//dwUserData:用户自定义数据
//备注:和PCallBack_Event只要使用其中一种方式就可以了
/////////////////////////////////////////////////////////////////////////////////////////
typedef BRIINT32 (CALLBACK *PCallBack_EventEx)(PBRI_EVENT pEvent,BRIUINT32 dwUserData);


//////////////////////////////////////////////////////////////////////
//  BRI_EVENT.lEventType Define
//  事件类型定义.同步与系统发出的窗口消息(请选择其中一种方式处理)
///////////////////////////////////////////////////////////////////////


// 本地电话机摘机事件
#define	BriEvent_PhoneHook						(BRIINT32)1
// 本地电话机挂机事件
#define BriEvent_PhoneHang						(BRIINT32)2

// 外线通道来电响铃事件
// BRI_EVENT.lResult		为响铃次数
// BRI_EVENT.szData[0]='0'	开始1秒响铃
// BRI_EVENT.szData[0]='1'	为1秒响铃完成，开始4秒静音
#define BriEvent_CallIn							(BRIINT32)3		

// 得到来电号码
// BRI_EVENT.lResult		来电号码模式(CALLIDMODE_FSK/CALLIDMODE_DTMF
// BRI_EVENT.szData			保存的来电号码
// 该事件可能在响铃前,也可能在响铃后
#define BriEvent_GetCallID						(BRIINT32)4

// 对方停止呼叫(产生一个未接电话)
#define BriEvent_StopCallIn						(BRIINT32)5

// 调用开始拨号后，全部号码拨号结束
#define BriEvent_DialEnd						(BRIINT32)6

// 播放文件结束事件
// BRI_EVENT.lEventHandle	   播放文件时返回的句柄ID 
#define BriEvent_PlayFileEnd					(BRIINT32)7		

// 多文件连播结束事件
// 
#define BriEvent_PlayMultiFileEnd				(BRIINT32)8

//播放字符结束
#define	BriEvent_PlayStringEnd					(BRIINT32)9

// 播放文件结束准备重复播放
// BRI_EVENT.lEventHandle	   播放文件时返回的句柄ID 
// 
#define BriEvent_RepeatPlayFile					(BRIINT32)10

// 给本地PHONE设备发送震铃信号时发送号码结束
#define BriEvent_SendCallIDEnd					(BRIINT32)11

//给本地PHONE设备发送震铃信号时超时
//默认响DEFAULT_RING_TIMEOUT(12)次后超时
#define BriEvent_RingTimeOut					(BRIINT32)12

//给本地PHONE设备正在震铃
// BRI_EVENT.lResult	    已经响铃的次数
// BRI_EVENT.szData[0]='0'	开始一次响铃
// BRI_EVENT.szData[0]='1'	一次响铃完成，准备静音
#define BriEvent_Ringing						(BRIINT32)13

// 通话时检测到一定时间的静音.默认为5秒
#define BriEvent_Silence						(BRIINT32)14

// 线路接通时收到DTMF码事件
// 该事件不能区分通话中是本地话机按键还是对方话机按键触发
#define BriEvent_GetDTMFChar					(BRIINT32)15

// 拨号后,被叫方摘机事件(该事件仅做参考,原因如下：)
// 原因：
// 该事件只适用于拨打是标准信号音的号码时，也就是拨号后带有标准回铃音的号码。
// 如：当拨打的对方号码是彩铃(彩铃手机号)或系统提示音(179xx)都不是标准回铃音时该事件无效。
// 
// 反极信号是模拟线路中唯一可靠的判断对方摘机的方法，只是一方面需要开通才有该功能，另一方面在有些地方，即使申请也未必受理，因为该功能原本是针对公用电话计费的。
// 没有该功能，利用信号音做判断依据，但可靠性不能做到100％，尤其是在被叫方为彩铃时，检测率很低
// 拥有反级服务方式一：向电信的PSTN线路申请开通,该方式操作性不强,原因如上所述
// 拥有反级服务方式二：购买一个手机sim/3g卡,再购买一个带反级服务的sim/3g平台设备(200人民币左右),该设备会引出一个电话线接入到USB设备
// BRI_EVENT.lResult : 0 为语音信号分析的结果
// BRI_EVENT.lResult : 1 为反级检测的结果
#define BriEvent_RemoteHook						(BRIINT32)16

// 挂机事件
// 如果线路检测到被叫方摘机后，被叫方挂机时会触发该事件，不然被叫方挂机后就触发BriEvent_Busy事件
// 该事件或者BriEvent_Busy的触发都表示PSTN线路已经被断开
// 备注：该事件是根据线路的忙音信号检测，如果没有忙音就不会触发该事件
// 如果有反级服务就为可靠提示
// BRI_EVENT.lResult : 0 为语音信号分析的结果
// BRI_EVENT.lResult : 1 为反级检测的结果
#define BriEvent_RemoteHang						(BRIINT32)17

// 检测到忙音事件,表示PSTN线路已经被断开
#define BriEvent_Busy							(BRIINT32)18

// 本地摘机后检测到拨号音
#define BriEvent_DialTone						(BRIINT32)19

// 只有在本地话机摘机，没有调用软摘机时,检测到DTMF拨号
// BRI_EVENT.szData 保存已经拨的号码
#define BriEvent_PhoneDial						(BRIINT32)20

// 电话机拨号结束呼出事件。
// 也就时电话机拨号后接收到标准回铃音或者15秒超时
// BRI_EVENT.lResult=0 检测到回铃音// 注意：如果线路是彩铃是不会触发该类型
// BRI_EVENT.lResult=1 拨号超时
// BRI_EVENT.lResult=2 动态检测拨号码结束(根据中国大陆的号码规则进行智能分析，仅做参考)
// BRI_EVENT.szData[0]='1' 软摘机拨号结束后回铃了
// BRI_EVENT.szData[0]='0' 电话机拨号中回铃了
#define BriEvent_RingBack						(BRIINT32)21

// MIC插入状态
// 只适用具有该功能的设备
#define BriEvent_MicIn							(BRIINT32)22		
// MIC拔出状态
// 只适用具有该功能的设备
#define BriEvent_MicOut							(BRIINT32)23		

// 拍插簧(Flash)完成事件，拍插簧完成后可以检测拨号音后进行二次拨号
// BRI_EVENT.lResult=TEL_FLASH  用户使用电话机进行拍叉簧完成
// BRI_EVENT.lResult=SOFT_FLASH 调用StartFlash函数进行拍叉簧完成
#define BriEvent_FlashEnd						(BRIINT32)24		

// 拒接完成
#define BriEvent_RefuseEnd						(BRIINT32)25

// 语音识别完成 
#define	BriEvent_SpeechResult					(BRIINT32)26

//PSTN线路断开,线路进入空闲状态
//当前没有软摘机而且话机也没摘机
#define BriEvent_PSTNFree						(BRIINT32)27

// 接收到对方准备发送传真的信号
#define BriEvent_RemoteSendFax					(BRIINT32)30

// 接收传真完成
#define BriEvent_FaxRecvFinished				(BRIINT32)31
// 接收传真失败
#define BriEvent_FaxRecvFailed					(BRIINT32)32

// 发送传真完成
#define BriEvent_FaxSendFinished				(BRIINT32)33
// 发送传真失败
#define BriEvent_FaxSendFailed					(BRIINT32)34

// 启动声卡失败
#define BriEvent_OpenSoundFailed				(BRIINT32)35

// 产生一个PSTN呼入/呼出日志
#define BriEvent_CallLog						(BRIINT32)36

//检测到连续的静音
//使用QNV_GENERAL_CHECKSILENCE启动后检测到设定的静音长度
#define	BriEvent_RecvSilence					(BRIINT32)37

//检测到连续的声音
//使用QNV_GENERAL_CHECKVOICE启动后检测到设定的语音长度
#define	BriEvent_RecvVoice						(BRIINT32)38

//远程上传事件
// BRI_EVENT.lResult	   启动上传时返回的本次操作的句柄
// http 服务器接收到数据后返回Result:1 终端将接收到该事件，否则返回失败
#define	BriEvent_UploadSuccess					(BRIINT32)50

#define	BriEvent_UploadFailed					(BRIINT32)51
// 远程连接已被断开
#define BriEvent_RemoteDisconnect				(BRIINT32)52

//HTTP远程下载文件完成
//BRI_EVENT.lResult	   启动下载时返回的本次操作的句柄
#define	BriEvent_DownloadSuccess				(BRIINT32)60
#define	BriEvent_DownloadFailed					(BRIINT32)61
//等候播放远程数据
#define	BriEvent_PlayRemoteWait					(BRIINT32)62

//线路检测结果
//BRI_EVENT.lResult 为检测结果信息
//1:能软拨号
//2:线路没接反
//3:能软拨号而且线路没接反
#define	BriEvent_CheckLine						(BRIINT32)70

// 应用层调用软摘机/软挂机成功事件
// BRI_EVENT.lResult=1 软摘机
// BRI_EVENT.lResult=0 软挂机			
#define BriEvent_EnableHook						(BRIINT32)100
// 喇叭被打开或者/关闭
// BRI_EVENT.lResult=0 关闭
// BRI_EVENT.lResult=1 打开			
#define BriEvent_EnablePlay						(BRIINT32)101
// MIC被打开或者关闭	
// BRI_EVENT.lResult=0 关闭
// BRI_EVENT.lResult=1 打开			
#define BriEvent_EnableMic						(BRIINT32)102		
// 耳机被打开或者关闭
// BRI_EVENT.lResult=0 关闭
// BRI_EVENT.lResult=1 打开			
#define BriEvent_EnableSpk						(BRIINT32)103		
// 电话机跟电话线(PSTN)断开/接通(DoPhone)
// BRI_EVENT.lResult=0 断开
// BRI_EVENT.lResult=1 接通		
#define BriEvent_EnableRing						(BRIINT32)104		
// 修改输入的线路line通道
// BRI_EVENT.lResult= linein id值
#define BriEvent_SelectLineIn					(BRIINT32)105		
// 开始软件拨号
// BRI_EVENT.szData	准备拨的号码
// BRI_EVENT.lResult=0 拨号前准备检测拨号音
// BRI_EVENT.lResult=1 检测到拨号音开始拨号
// BRI_EVENT.lResult=2 未检测到拨号音开始强制拨号(QNV_PARAM_DIALTONERESULT=2时触发)
// BRI_EVENT.lResult=3 未检测到拨号音,拨号失败，不再进行拨号了(QNV_PARAM_DIALTONERESULT=3时触发)
#define BriEvent_DoStartDial					(BRIINT32)106
// 喇叭语音通道被选择
// BRI_EVENT.lResult= 选择的mux值
#define	BriEvent_EnablePlayMux					(BRIINT32)107
//改变设备控制状态
#define	BriEvent_DevCtrl						(BRIINT32)110

//在通话状态中接收到拨号音
//如果是来电响铃后刚拿起话机一定时间内检测到,应用层可以考虑认为是刚才电话已经未接,本次拿起话机属于去电
#define	BriEvent_DialToneEx						(BRIINT32)193
// 接收到DTMF,不区分是拨号还是通话中,所有接收到的DTMF事件都回调
// BRI_EVENT.szData	号码
// 建议一般用户不需要使用
#define BriEvent_RecvedDTMF						(BRIINT32)194

//设备可能被拔掉了,效果相当于BriEvent_DevErr事件时的BRI_EVENT.lResult=3
#define BriEvent_PlugOut						(BRIINT32)195
//硬解码来电
// 保留
#define	BriEvent_CallInEx						(BRIINT32)196
// 重新打开设备成功
// 保留
#define BriEvent_ReopenSucccess					(BRIINT32)197
// 接收到号码,包括通话中FSK		
// BRI_EVENT.szData	号码
//保留，内部使用，建议一般用户不需要使用
#define BriEvent_RecvedFSK						(BRIINT32)198
//设备异常错误
//BRI_EVENT.lResult=3 表示设备可能被移除了,必须关闭后重新打开设备才可以正常使用
//其它可以忽略不做处理
#define BriEvent_DevErr							(BRIINT32)199

// CCCtrl Event
// CC控制相关事件
// BRI_EVENT.szData 保存消息相关信息
// 消息内的参数和内容使用2个换行分隔
// 每个参数使用1个换行分隔
#define BriEvent_CC_ConnectFailed				(BRIINT32)200//连接失败
#define	BriEvent_CC_LoginFailed					(BRIINT32)201//登陆失败
#define	BriEvent_CC_LoginSuccess				(BRIINT32)202//登陆成功
#define BriEvent_CC_SystemTimeErr				(BRIINT32)203//系统时间错误
#define	BriEvent_CC_CallIn						(BRIINT32)204//有CC呼入请求
#define BriEvent_CC_CallOutFailed				(BRIINT32)205//呼叫失败
#define	BriEvent_CC_CallOutSuccess				(BRIINT32)206//呼叫成功，正在呼叫
#define BriEvent_CC_Connecting					(BRIINT32)207//呼叫正在连接
#define BriEvent_CC_Connected					(BRIINT32)208//呼叫连通
#define BriEvent_CC_CallFinished				(BRIINT32)209//呼叫结束
#define BriEvent_CC_ReplyBusy					(BRIINT32)210//对方回复忙过来
#define BriEvent_CC_GetDTMF						(BRIINT32)211//接收到DTMF
#define	BriEvent_CC_PlayFileEnd					(BRIINT32)212//播放文件结束
#define BriEvent_CC_ReConnect					(BRIINT32)212//正在重新连接

#define BriEvent_CC_RecvedMsg					(BRIINT32)220//接收到用户即时消息
#define BriEvent_CC_RecvedCmd					(BRIINT32)221//接收到用户自定义命令
#define BriEvent_CC_RecvedIP					(BRIINT32)222//接收到用户IP地址信息

#define	BriEvent_CC_RegSuccess					(BRIINT32)225//注册CC成功
#define	BriEvent_CC_RegFailed					(BRIINT32)226//注册CC失败
#define	BriEvent_CC_FindSuccess					(BRIINT32)227//搜索CC服务器IP成功
#define	BriEvent_CC_FindFailed					(BRIINT32)228//搜索CC服务器IP失败
#define	BriEvent_CC_FindEnd						(BRIINT32)229//搜索CC服务器结束

#define	BriEvent_CC_RecvFileRequest				(BRIINT32)230//接收到用户发送的文件请求
#define	BriEvent_CC_TransFileFinished			(BRIINT32)231//传输文件结束

#define BriEvent_CC_AddContactSuccess			(BRIINT32)240//增加好友成功
#define BriEvent_CC_AddContactFailed			(BRIINT32)241//增加好友失败
#define BriEvent_CC_InviteContact				(BRIINT32)242//接收到增加好好友邀请
#define BriEvent_CC_ReplyAcceptContact			(BRIINT32)243//对方回复同意为好友
#define BriEvent_CC_ReplyRefuseContact			(BRIINT32)244//对方回复拒绝为好友
#define BriEvent_CC_AcceptContactSuccess		(BRIINT32)245//接受好友成功
#define BriEvent_CC_AcceptContactFailed			(BRIINT32)246//接受好友失败
#define BriEvent_CC_RefuseContactSuccess		(BRIINT32)247//拒绝好友成功
#define BriEvent_CC_RefuseContactFailed			(BRIINT32)248//拒绝好友失败	
#define BriEvent_CC_DeleteContactSuccess		(BRIINT32)249//删除好友成功
#define	BriEvent_CC_DeleteContactFailed			(BRIINT32)250//删除好友失败
#define BriEvent_CC_ContactUpdateStatus			(BRIINT32)251//好友登陆状态改变
#define BriEvent_CC_ContactDownendStatus		(BRIINT32)252//获取到所有好友改变完成
#define	BriEvent_CC_ModifyPwdFailed				(BRIINT32)253//修改密码失败
#define	BriEvent_CC_ModifyPwdSuccess			(BRIINT32)254//修改密码成功

//c/s socket收发数据事件
//终端接收到的事件
#define BriEvent_Socket_C_ConnectSuccess		(BRIINT32)300//连接成功
#define BriEvent_Socket_C_ConnectFailed			(BRIINT32)301//连接失败
#define BriEvent_Socket_C_ReConnect				(BRIINT32)302//开始重新连接
#define BriEvent_Socket_C_ReConnectFailed		(BRIINT32)303//重新连接失败
#define BriEvent_Socket_C_ServerClose			(BRIINT32)304//服务器断开连接
#define BriEvent_Socket_C_DisConnect			(BRIINT32)305//连接激活超时
#define BriEvent_Socket_C_RecvedData			(BRIINT32)306//接收到服务端发送过来的数据
//
//服务器端接收到的事件
#define BriEvent_Socket_S_NewLink				(BRIINT32)340//有新连接进入
#define BriEvent_Socket_S_DisConnect			(BRIINT32)341//终端连接激活超时
#define BriEvent_Socket_S_ClientClose			(BRIINT32)342//终端断开连接了
#define BriEvent_Socket_S_RecvedData			(BRIINT32)343//接收到终端发送过来的数据
//
//UDP事件
#define	BriEvent_Socket_U_RecvedData			(BRIINT32)360//接收到UDP数据
#define BriEvent_Socket_U_FindUDPSuccess		(BRIINT32)361//接收到UDP方式查询服务器回复
#define BriEvent_Socket_U_FindUDPFailed			(BRIINT32)362//查找UDB服务器失败

//

#define	BriEvent_EndID							(BRIINT32)500//空ID
#define	BriEvent_UserID							(BRIINT32)1024//用户自定义ID


///////////////////////////////////////////////////////////////
//消息定义说明
//////////////////////////////////////////////////////////////
//默认事件消息ID,如果有冲突可以使用QNV_EVENT_SETEVENTMSGID修改该消息回调值
//备注：用户接收到消息结构后不要修改结构的内容
#define		BRI_EVENT_MESSAGE					(WM_USER+2000)
//默认缓冲录音数据消息ID,如果有冲突可以使用QNV_RECORD_BUF_SETCBMSGID修改该消息回调值
#define		BRI_RECBUF_MESSAGE					(WM_USER+2001)
//

//语音文件编码格式ID
//除了BRI_WAV_FORMAT_PCM8K16B外，其它格式需要系统语音编码库支持
//如果系统不支持在开始文件录音时将被返回BCERR_NOTSUPPORTFORMAT(-14)
#define		BRI_WAV_FORMAT_DEFAULT					(BRIUINT32)0 // BRI_AUDIO_FORMAT_PCM8K16B
#define		BRI_WAV_FORMAT_ALAW8K					(BRIUINT32)1 // 8k/s
#define		BRI_WAV_FORMAT_ULAW8K					(BRIUINT32)2 // 8k/s
#define		BRI_WAV_FORMAT_IMAADPCM8K4B				(BRIUINT32)3 // 4k/s
#define		BRI_WAV_FORMAT_PCM8K8B					(BRIUINT32)4 // 8k/s
#define		BRI_WAV_FORMAT_PCM8K16B					(BRIUINT32)5 //16k/s
#define		BRI_WAV_FORMAT_MP38K8B					(BRIUINT32)6 //~1.2k/s//保留
#define		BRI_WAV_FORMAT_MP38K16B					(BRIUINT32)7 //~2.4k/s//保留
#define		BRI_WAV_FORMAT_TM8K1B					(BRIUINT32)8 //~1.5k/s
#define		BRI_WAV_FORMAT_GSM6108K					(BRIUINT32)9 //~2.2k/s
#define		BRI_WAV_FORMAT_END						(BRIUINT32)255 //无效ID
//保留最多256个
////////////////////////////////////////////////////////////


//----------------------------------------------------------------------------------
//设备信息
#define		QNV_DEVINFO_GETCHIPTYPE					(BRIUINT32)1//获取USB芯片模块类型
#define		QNV_DEVINFO_GETCHIPS					(BRIUINT32)2//获取USB模块数量,该值等于最后一个通道的DEVID+1
#define		QNV_DEVINFO_GETTYPE						(BRIUINT32)3//获取通道设备类型
#define		QNV_DEVINFO_GETMODULE					(BRIUINT32)4//获取通道功能模块
#define		QNV_DEVINFO_GETCHIPCHID					(BRIUINT32)5//获取通道所在USB芯片的中的传输ID(0或者1)
#define		QNV_DEVINFO_GETSERIAL					(BRIUINT32)6//获取通道序列号(0-n)
#define		QNV_DEVINFO_GETCHANNELS					(BRIUINT32)7//获取通道数量
#define		QNV_DEVINFO_GETDEVID					(BRIUINT32)8//获取通道所在的USB芯片ID(0-n)
#define		QNV_DEVINFO_GETDLLVER					(BRIUINT32)9//获取DLL版本号
#define		QNV_DEVINFO_GETCHIPCHANNEL				(BRIUINT32)10//获取该USB模块第一个传输ID所在的通道号
#define		QNV_DEVINFO_GETCHANNELTYPE				(BRIUINT32)11//通道线路接外线还是话机类型
#define		QNV_DEVINFO_GETCHIPCHANNELS				(BRIUINT32)12//获取该USB模块第二个传输ID所在的通道号

#define		QNV_DEVINFO_FILEVERSION					(BRIUINT32)20//获取DLL的文件版本[字符]
#define		QNV_DEVINFO_FILEVERSIONL				(BRIUINT32)21//获取DLL的文件版本[数字]
//---------------------------------------------------------------------------------

//参数类型列表
//uParamType (可以使用API(QNV_GENERAL_READPARAM/QNV_GENERAL_WRITEPARAM)自动保存/读取)
#define		QNV_PARAM_BUSY							(BRIUINT32)1//检测到几个忙音回调
	
#define		QNV_PARAM_DTMFLEVEL						(BRIUINT32)2//dtmf检测时允许的性噪声比(0-7)
#define		QNV_PARAM_DTMFVOL						(BRIUINT32)3//dtmf检测时允许的能量(1-100)
#define		QNV_PARAM_DTMFNUM						(BRIUINT32)4//dtmf检测时允许的持续时间(2-10)
#define		QNV_PARAM_DTMFLOWINHIGH					(BRIUINT32)5//dtmf低频不能超过高频值(默认为7)
#define		QNV_PARAM_DTMFHIGHINLOW					(BRIUINT32)6//dtmf高频不能超过低频值(默认为5)

#define		QNV_PARAM_DIALSPEED						(BRIUINT32)7//拨号的DTMF长度(1ms-60000ms)
#define		QNV_PARAM_DIALSILENCE					(BRIUINT32)8//拨号时的间隔静音长度(1ms-60000ms)
#define		QNV_PARAM_DIALVOL						(BRIUINT32)9//拨号音量大小

#define		QNV_PARAM_RINGSILENCE					(BRIUINT32)10//来电不响铃多少时间超时算未接电话
#define		QNV_PARAM_CONNECTSILENCE				(BRIUINT32)11//通话时连续多少时间静音后回调
#define		QNV_PARAM_RINGBACKNUM					(BRIUINT32)12//拨几个数字以上后检测回铃开始有效//默认为2个,可起到忽略出局号码后检测的回铃音
#define		QNV_PARAM_SWITCHLINEIN					(BRIUINT32)13//自动切换LINEIN选择
#define		QNV_PARAM_FLASHELAPSE					(BRIUINT32)14//拍插簧间隔
#define		QNV_PARAM_FLASHENDELAPSE				(BRIUINT32)15//拍插簧后延迟一定时间再回调事件
#define		QNV_PARAM_RINGELAPSE					(BRIUINT32)16//内线震铃时时间长度
#define		QNV_PARAM_RINGSILENCEELAPSE				(BRIUINT32)17//内线震铃时静音长度
#define		QNV_PARAM_RINGTIMEOUT					(BRIUINT32)18//内线震铃时超时次数
#define		QNV_PARAM_RINGCALLIDTYPE				(BRIUINT32)19//内线震铃时发送号码的方式dtmf/fsk
#define		QNV_PARAM_REFUSEELAPSE					(BRIUINT32)20//拒接时间隔时间长度
#define		QNV_PARAM_DIALTONETIMEOUT				(BRIUINT32)21//检测拨号音超时时间
#define		QNV_PARAM_MINCHKFLASHELAPSE				(BRIUINT32)22//拍插簧检测时挂机至少的时间ms,挂机时间小于该值就不算拍插簧
#define		QNV_PARAM_MAXCHKFLASHELAPSE				(BRIUINT32)23//拍插簧检测时挂机最长的时间ms,挂机时间大于该值就不算拍插簧
#define		QNV_PARAM_HANGUPELAPSE					(BRIUINT32)24//检测电话机挂机时的至少时间长度ms,//建议挂机检测时间在拍插簧以上，避免发生挂机后又检测到拍插
#define		QNV_PARAM_OFFHOOKELAPSE					(BRIUINT32)25//检测电话机摘机时的至少时间长度ms
#define		QNV_PARAM_RINGHIGHELAPSE				(BRIUINT32)26//检测来电震铃时响铃的至少时间长度ms
#define		QNV_PARAM_RINGLOWELAPSE					(BRIUINT32)27//检测来电震铃时不响铃的至少时间长度ms
#define		QNV_PARAM_DIALTONERESULT				(BRIUINT32)28//检测拨号音超时后强制拨号还是提示拨号dostartdial失败

#define		QNV_PARAM_SPEECHGENDER					(BRIUINT32)30//语音识别性别
#define		QNV_PARAM_SPEECHTHRESHOLD				(BRIUINT32)31//语音识别门限
#define		QNV_PARAM_SPEECHSILENCEAM				(BRIUINT32)32//语音识别静音门限
#define		QNV_PARAM_ECHOTHRESHOLD					(BRIUINT32)33//回音抵消处理抵消门限参数
#define		QNV_PARAM_ECHODECVALUE					(BRIUINT32)34//回音抵消处理减少增益参数
#define		QNV_PARAM_SIGSILENCEAM					(BRIUINT32)35//信号音/线路通话分析的静音门限

#define		QNV_PARAM_LINEINFREQ1TH					(BRIUINT32)40//第一组线路双频模式信号音频率
#define		QNV_PARAM_LINEINFREQ2TH					(BRIUINT32)41//第二组线路双频模式信号音频率
#define		QNV_PARAM_LINEINFREQ3TH					(BRIUINT32)42//第三组线路双频模式信号音频率

#define		QNV_PARAM_ADBUSYMINFREQ					(BRIUINT32)45//检测忙音叠加时最小频率
#define		QNV_PARAM_ADBUSYMAXFREQ					(BRIUINT32)46//检测忙音叠加时最大频率

//增益控制
#define		QNV_PARAM_AM_MIC						(BRIUINT32)50//MIC增益
#define		QNV_PARAM_AM_SPKOUT						(BRIUINT32)51//耳机spk增益
#define		QNV_PARAM_AM_LINEIN						(BRIUINT32)52//线路输入能量
#define		QNV_PARAM_AM_LINEOUT					(BRIUINT32)53//mic到线路能量+播放语音到到线路能量
#define		QNV_PARAM_AM_DOPLAY						(BRIUINT32)54//喇叭输出增益
//
#define		QNV_PARAM_CITYCODE						(BRIUINT32)60//城市区号,适合中国大陆
#define		QNV_PARAM_PROXYDIAL						(BRIUINT32)61//代拨号

#define		QNV_PARAM_FINDSVRTIMEOUT				(BRIUINT32)70//设置自动CC搜索超时时间,保留[内部使用]
#define		QNV_PARAM_CONFJITTERBUF					(BRIUINT32)71//会议交换的动态缓冲大小

#define		QNV_PARAM_RINGTHRESHOLD					(BRIUINT32)80//来电响铃信号分析门限

#define		QNV_PARAM_DTMFCALLIDLEVEL				(BRIUINT32)100//dtmf来电号码检测时允许的性噪声比(0-7)
#define		QNV_PARAM_DTMFCALLIDNUM					(BRIUINT32)101//dtmf来电号码检测时允许的持续时间(2-10)
#define		QNV_PARAM_DTMFCALLIDVOL					(BRIUINT32)102//dtmf来电号码检测时允许的能量要求

#define		QNV_PARAM_FSKFILTER						(BRIUINT32)110//是否开启FSK信号滤波,如果来电号码里有很高概率乱码时可以切换该参数测试
#define		QNV_PARAM_FSKSPACEAM					(BRIUINT32)111//FSK信号匹配参数,默认为100,范围为20-1000.200表示放大一倍，恢复高频被衰减部分，提高可靠度,建议在100-400之间


//设备控制/状态
//uCtrlType
#define		QNV_CTRL_DOSHARE						(BRIUINT32)1//设备共享模式
#define		QNV_CTRL_DOHOOK							(BRIUINT32)2//软件摘挂机控制
#define		QNV_CTRL_DOPHONE						(BRIUINT32)3//控制电话机是否可用,可控制话机震铃,实现硬拍插簧等
#define		QNV_CTRL_DOPLAY							(BRIUINT32)4//喇叭控制开关
#define		QNV_CTRL_DOLINETOSPK					(BRIUINT32)5//线路声音到耳机，用耳机通话时打开
#define		QNV_CTRL_DOPLAYTOSPK					(BRIUINT32)6//播放的语音到耳机
#define		QNV_CTRL_DOMICTOLINE					(BRIUINT32)7//MIC说话声到电话线
#define		QNV_CTRL_ECHO							(BRIUINT32)8//打开/关闭回音抵消
#define		QNV_CTRL_RECVFSK						(BRIUINT32)9//打开/关闭接收FSK来电号码
#define		QNV_CTRL_RECVDTMF						(BRIUINT32)10//打开/关闭接收DTMF
#define		QNV_CTRL_RECVSIGN						(BRIUINT32)11//打开/关闭信号音检测
#define		QNV_CTRL_WATCHDOG						(BRIUINT32)12//打开关闭看门狗
#define		QNV_CTRL_PLAYMUX						(BRIUINT32)13//选择到喇叭的语音通道 line1x/pcplay ch0/line2x/pcplay ch1
#define		QNV_CTRL_PLAYTOLINE						(BRIUINT32)14//播放的语音到line(保留，用户不需要修改)
#define		QNV_CTRL_SELECTLINEIN					(BRIUINT32)15//选择输入的线路line通道
#define		QNV_CTRL_SELECTADCIN					(BRIUINT32)16//选择输入的为线路还是MIC语音
#define		QNV_CTRL_PHONEPOWER						(BRIUINT32)17//打开/关闭给话机供电使能,如果不给话机供电,dophone切换后,话机将不可用,所有对话机的操作都无效
#define		QNV_CTRL_RINGPOWER						(BRIUINT32)18//内线震铃使能
#define		QNV_CTRL_LEDPOWER						(BRIUINT32)19//LED指示灯
#define		QNV_CTRL_LINEOUT						(BRIUINT32)20//线路输出使能(保留，用户不需要修改)
#define		QNV_CTRL_SWITCHOUT						(BRIUINT32)21//硬件回音抵消
#define		QNV_CTRL_UPLOAD							(BRIUINT32)22//打开/关闭设备数据上传功能,关闭后将接收不到设备语音数据
#define		QNV_CTRL_DOWNLOAD						(BRIUINT32)23//打开/关闭设备数据下载功能,关闭后将不能发送语音/拨号到设备
#define		QNV_CTRL_POLARITY						(BRIUINT32)24//开关级性反转摘机检测
#define		QNV_CTRL_ADBUSY							(BRIUINT32)25//是否打开检测忙音叠加时环境(只有在使用两路外线网关时由于同时挂机才会触发忙音被叠加的环境,普通用户不需要使用)
#define		QNV_CTRL_RECVCALLIN						(BRIUINT32)26//打开/关闭软解码来电
#define		QNV_CTRL_READFRAMENUM					(BRIUINT32)27//一次请求读取的USB帧数量，越大占用CPU越小，延迟也就越大，一帧为4ms,最大30帧，也就是设置范围为(1-30)
#define		QNV_CTRL_DTMFCALLID						(BRIUINT32)28//忽略DTMF模式接收来电号码,默认是开启检测的
//以下状态不能设置(set),只能获取(get)
#define		QNV_CTRL_PHONE							(BRIUINT32)30//电话机摘挂机状态
#define		QNV_CTRL_MICIN							(BRIUINT32)31//mic插入状态
#define		QNV_CTRL_RINGTIMES						(BRIUINT32)32//来电响铃的次数
#define		QNV_CTRL_RINGSTATE						(BRIUINT32)33//来电响铃状态，正在响还是不响
//


//放音控制
//uPlayType
#define		QNV_PLAY_FILE_START						(BRIUINT32)1//开始播放文件
#define		QNV_PLAY_FILE_SETCALLBACK				(BRIUINT32)2//设置播放文件回调函数
#define		QNV_PLAY_FILE_SETVOLUME					(BRIUINT32)3//设置播放文件音量
#define		QNV_PLAY_FILE_GETVOLUME					(BRIUINT32)4//获取播放文件音量
#define		QNV_PLAY_FILE_PAUSE						(BRIUINT32)5//暂停播放文件
#define		QNV_PLAY_FILE_RESUME					(BRIUINT32)6//恢复播放文件
#define		QNV_PLAY_FILE_ISPAUSE					(BRIUINT32)7//检测是否已暂停播放
#define		QNV_PLAY_FILE_SETREPEAT					(BRIUINT32)8//设置是否循环播放
#define		QNV_PLAY_FILE_ISREPEAT					(BRIUINT32)9//检测是否在循环播放
#define		QNV_PLAY_FILE_SEEKTO					(BRIUINT32)11//跳转到某个时间(ms)
#define		QNV_PLAY_FILE_SETREPEATTIMEOUT			(BRIUINT32)12//设置循环播放超时次数
#define		QNV_PLAY_FILE_GETREPEATTIMEOUT			(BRIUINT32)13//获取循环播放超时次数
#define		QNV_PLAY_FILE_SETPLAYTIMEOUT			(BRIUINT32)14//设置播放总共超时时长(ms)
#define		QNV_PLAY_FILE_GETPLAYTIMEOUT			(BRIUINT32)15//获取播放总共超时时长
#define		QNV_PLAY_FILE_TOTALLEN					(BRIUINT32)16//总共时间(ms)
#define		QNV_PLAY_FILE_CURSEEK					(BRIUINT32)17//当前播放的文件时间位置(ms)
#define		QNV_PLAY_FILE_ELAPSE					(BRIUINT32)18//总共播放的时间(ms),包括重复的,后退的,不包括暂停的时间
#define		QNV_PLAY_FILE_ISPLAY					(BRIUINT32)19//该句柄是否有效播放句柄
#define		QNV_PLAY_FILE_ENABLEAGC					(BRIUINT32)20//打开关闭自动增益
#define		QNV_PLAY_FILE_ISENABLEAGC				(BRIUINT32)21//检测是否打开自动增益
#define		QNV_PLAY_FILE_STOP						(BRIUINT32)22//停止播放指定文件
#define		QNV_PLAY_FILE_GETCOUNT					(BRIUINT32)23//获取正在文件播放的数量,可以用来检测如果没有了就可以关闭喇叭
#define		QNV_PLAY_FILE_STOPALL					(BRIUINT32)24//停止播放所有文件
#define		QNV_PLAY_FILE_REMOTEBUFFERLEN			(BRIUINT32)25//远程播放需要下载的缓冲长度
#define		QNV_PLAY_FILE_REMOTEBUFFERSEEK			(BRIUINT32)26//远程播放已经下载的缓冲长度
//--------------------------------------------------------

#define		QNV_PLAY_BUF_START						(BRIUINT32)1//开始缓冲播放
#define		QNV_PLAY_BUF_SETCALLBACK				(BRIUINT32)2//设置缓冲播放回调函数
#define		QNV_PLAY_BUF_SETWAVEFORMAT				(BRIUINT32)3//设置缓冲播放语音的格式
#define		QNV_PLAY_BUF_WRITEDATA					(BRIUINT32)4//写缓冲数据
#define		QNV_PLAY_BUF_SETVOLUME					(BRIUINT32)5//设置音量
#define		QNV_PLAY_BUF_GETVOLUME					(BRIUINT32)6//获取音量
#define		QNV_PLAY_BUF_SETUSERVALUE				(BRIUINT32)7//设置用户自定义数据
#define		QNV_PLAY_BUF_GETUSERVALUE				(BRIUINT32)8//获取用户自定义数据
#define		QNV_PLAY_BUF_ENABLEAGC					(BRIUINT32)9//打开关闭自动增益
#define		QNV_PLAY_BUF_ISENABLEAGC				(BRIUINT32)10//检测是否打开了自动增益
#define		QNV_PLAY_BUF_PAUSE						(BRIUINT32)11//暂停播放文件
#define		QNV_PLAY_BUF_RESUME						(BRIUINT32)12//恢复播放文件
#define		QNV_PLAY_BUF_ISPAUSE					(BRIUINT32)13//检测是否已暂停播放
#define		QNV_PLAY_BUF_STOP						(BRIUINT32)14//停止缓冲播放
#define		QNV_PLAY_BUF_FREESIZE					(BRIUINT32)15//空闲字节
#define		QNV_PLAY_BUF_DATASIZE					(BRIUINT32)16//数据字节
#define		QNV_PLAY_BUF_TOTALSAMPLES				(BRIUINT32)17//总共播放的采样数
#define		QNV_PLAY_BUF_SETJITTERBUFSIZE			(BRIUINT32)18//设置动态缓冲长度，当缓冲数据播放为空后下次播放前缓冲内必须大于该长度的语音,可用在播放网络数据包，避免网络抖动
#define		QNV_PLAY_BUF_GETJITTERBUFSIZE			(BRIUINT32)19//获取动态缓冲长度
#define		QNV_PLAY_BUF_GETCOUNT					(BRIUINT32)20//获取正在缓冲播放的数量,可以用来检测如果没有了就可以关闭喇叭
#define		QNV_PLAY_BUF_STOPALL					(BRIUINT32)21//停止所有播放
//-------------------------------------------------------

#define		QNV_PLAY_MULTIFILE_START				(BRIUINT32)1//开始多文件连续播放
#define		QNV_PLAY_MULTIFILE_PAUSE				(BRIUINT32)2//暂停多文件连续播放
#define		QNV_PLAY_MULTIFILE_RESUME				(BRIUINT32)3//恢复多文件连续播放
#define		QNV_PLAY_MULTIFILE_ISPAUSE				(BRIUINT32)4//检测是否暂停了多文件连续播放
#define		QNV_PLAY_MULTIFILE_SETVOLUME			(BRIUINT32)5//设置多文件播放音量
#define		QNV_PLAY_MULTIFILE_GETVOLUME			(BRIUINT32)6//获取多文件播放音量
#define		QNV_PLAY_MULTIFILE_ISSTART				(BRIUINT32)7//是否启动了多文件连续播放
#define		QNV_PLAY_MULTIFILE_STOP					(BRIUINT32)8//停止多文件连续播放
#define		QNV_PLAY_MULTIFILE_STOPALL				(BRIUINT32)9//停止全部多文件连续播放
//--------------------------------------------------------

#define		QNV_PLAY_STRING_INITLIST				(BRIUINT32)1//初始化字符播放列表
#define		QNV_PLAY_STRING_START					(BRIUINT32)2//开始字符播放
#define		QNV_PLAY_STRING_PAUSE					(BRIUINT32)3//暂停字符播放
#define		QNV_PLAY_STRING_RESUME					(BRIUINT32)4//恢复字符播放
#define		QNV_PLAY_STRING_ISPAUSE					(BRIUINT32)5//检测是否暂停了字符播放
#define		QNV_PLAY_STRING_SETVOLUME				(BRIUINT32)6//设置字符播放音量
#define		QNV_PLAY_STRING_GETVOLUME				(BRIUINT32)7//获取字符播放音量
#define		QNV_PLAY_STRING_ISSTART					(BRIUINT32)8//是否启动了播放字符
#define		QNV_PLAY_STRING_STOP					(BRIUINT32)9//停止字符播放
#define		QNV_PLAY_STRING_STOPALL					(BRIUINT32)10//停止全部字符播放
//--------------------------------------------------------

//录音控制
//uRecordType
#define		QNV_RECORD_FILE_START					(BRIUINT32)1//开始文件录音
#define		QNV_RECORD_FILE_PAUSE					(BRIUINT32)2//暂停文件录音
#define		QNV_RECORD_FILE_RESUME					(BRIUINT32)3//恢复文件录音
#define		QNV_RECORD_FILE_ISPAUSE					(BRIUINT32)4//检测是否暂停文件录音
#define		QNV_RECORD_FILE_ELAPSE					(BRIUINT32)5//获取已经录音的时间长度,单位(s)
#define		QNV_RECORD_FILE_SETVOLUME				(BRIUINT32)6//设置文件录音音量
#define		QNV_RECORD_FILE_GETVOLUME				(BRIUINT32)7//获取文件录音音量
#define		QNV_RECORD_FILE_PATH					(BRIUINT32)8//获取文件录音的路径
#define		QNV_RECORD_FILE_STOP					(BRIUINT32)9//停止某个文件录音
#define		QNV_RECORD_FILE_STOPALL					(BRIUINT32)10//停止全部文件录音
#define		QNV_RECORD_FILE_COUNT					(BRIUINT32)11//获取正在录音的数量

#define		QNV_RECORD_FILE_SETROOT					(BRIUINT32)20//设置默认录音目录
#define		QNV_RECORD_FILE_GETROOT					(BRIUINT32)21//获取默认录音目录

//----------------------------------------------------------
#define		QNV_RECORD_BUF_HWND_START				(BRIUINT32)1//开始缓冲录音窗口回调
#define		QNV_RECORD_BUF_HWND_STOP				(BRIUINT32)2//停止某个缓冲录音窗口回调
#define		QNV_RECORD_BUF_HWND_STOPALL				(BRIUINT32)3//停止全部缓冲录音窗口回调
#define		QNV_RECORD_BUF_CALLBACK_START			(BRIUINT32)4//开始缓冲录音回调
#define		QNV_RECORD_BUF_CALLBACK_STOP			(BRIUINT32)5//停止某个缓冲录音回调
#define		QNV_RECORD_BUF_CALLBACK_STOPALL			(BRIUINT32)6//停止全部缓冲录音回调
#define		QNV_RECORD_BUF_SETCBSAMPLES				(BRIUINT32)7//设置回调采样数,每秒8K,如果需要20ms回调一次就设置为20*8=160,/默认为20ms回调一次
#define		QNV_RECORD_BUF_GETCBSAMPLES				(BRIUINT32)8//获取设置的回调采样数
#define		QNV_RECORD_BUF_ENABLEECHO				(BRIUINT32)9//打开关闭回调的语音是否经过回音抵消
#define		QNV_RECORD_BUF_ISENABLEECHO				(BRIUINT32)10//检测回调的语音回音抵消是否打开
#define		QNV_RECORD_BUF_PAUSE					(BRIUINT32)11//暂停缓冲录音
#define		QNV_RECORD_BUF_ISPAUSE					(BRIUINT32)12//检测是否暂停缓冲录音
#define		QNV_RECORD_BUF_RESUME					(BRIUINT32)13//恢复缓冲录音
#define		QNV_RECORD_BUF_SETVOLUME				(BRIUINT32)14//设置缓冲录音音量
#define		QNV_RECORD_BUF_GETVOLUME				(BRIUINT32)15//获取缓冲录音音量
#define		QNV_RECORD_BUF_SETWAVEFORMAT			(BRIUINT32)16//设置录音回调的语音编码格式ID,默认为BRI_WAV_FORMAT_PCM8K16B
#define		QNV_RECORD_BUF_GETWAVEFORMAT			(BRIUINT32)17//获取录音回调的语音编码格式ID

#define		QNV_RECORD_BUF_GETCBMSGID				(BRIUINT32)100//查询缓冲录音的窗口回调的消息ID,默认为BRI_RECBUF_MESSAGE
#define		QNV_RECORD_BUF_SETCBMSGID				(BRIUINT32)101//设置缓冲录音的窗口回调的消息ID,默认为BRI_RECBUF_MESSAGE
//--------------------------------------------------------

//会议控制
//uConferenceType
#define		QNV_CONFERENCE_CREATE					(BRIUINT32)1//创建会议
#define		QNV_CONFERENCE_ADDTOCONF				(BRIUINT32)2//增加通道到某个会议
#define		QNV_CONFERENCE_GETCONFID				(BRIUINT32)3//获取某个通道的会议ID
#define		QNV_CONFERENCE_SETSPKVOLUME				(BRIUINT32)4//设置会议中某个通道放音音量
#define		QNV_CONFERENCE_GETSPKVOLUME				(BRIUINT32)5//获取会议中某个通道放音音量
#define		QNV_CONFERENCE_SETMICVOLUME				(BRIUINT32)6//设置会议中某个通道录音音量
#define		QNV_CONFERENCE_GETMICVOLUME				(BRIUINT32)7//获取会议中某个通道录音音量
#define		QNV_CONFERENCE_PAUSE					(BRIUINT32)8//暂停某个会议
#define		QNV_CONFERENCE_RESUME					(BRIUINT32)9//恢复某个会议
#define		QNV_CONFERENCE_ISPAUSE					(BRIUINT32)10//检测是否暂停了某个会议
#define		QNV_CONFERENCE_ENABLESPK				(BRIUINT32)11//打开关闭会议者听功能
#define		QNV_CONFERENCE_ISENABLESPK				(BRIUINT32)12//检测会议者听功能是否打开
#define		QNV_CONFERENCE_ENABLEMIC				(BRIUINT32)13//打开关闭会议者说功能
#define		QNV_CONFERENCE_ISENABLEMIC				(BRIUINT32)14//检测会议者说功能是否打开
#define		QNV_CONFERENCE_ENABLEAGC				(BRIUINT32)15//打开关闭自动增益
#define		QNV_CONFERENCE_ISENABLEAGC				(BRIUINT32)16//检测是否打开了自动增益
#define		QNV_CONFERENCE_DELETECHANNEL			(BRIUINT32)17//把通道从会议中删除
#define		QNV_CONFERENCE_DELETECONF				(BRIUINT32)18//删除一个会议
#define		QNV_CONFERENCE_DELETEALLCONF			(BRIUINT32)19//删除全部会议
#define		QNV_CONFERENCE_GETCONFCOUNT				(BRIUINT32)20//获取会议数量
#define		QNV_CONFERENCE_SETJITTERBUFSIZE			(BRIUINT32)21//设置会议动态缓冲长度
#define		QNV_CONFERENCE_GETJITTERBUFSIZE			(BRIUINT32)22//获取会议动态缓冲长度

#define		QNV_CONFERENCE_RECORD_START				(BRIUINT32)30//开始录音
#define		QNV_CONFERENCE_RECORD_PAUSE				(BRIUINT32)31//暂停录音
#define		QNV_CONFERENCE_RECORD_RESUME			(BRIUINT32)32//恢复录音
#define		QNV_CONFERENCE_RECORD_ISPAUSE			(BRIUINT32)33//检测是否暂停录音
#define		QNV_CONFERENCE_RECORD_FILEPATH			(BRIUINT32)34//获取录音文件路径
#define		QNV_CONFERENCE_RECORD_ISSTART			(BRIUINT32)35//检测会议是否已经启动了录音
#define		QNV_CONFERENCE_RECORD_STOP				(BRIUINT32)36//停止指定会议录音
#define		QNV_CONFERENCE_RECORD_STOPALL			(BRIUINT32)37//停止全部会议录音
//--------------------------------------------------------


//语音广播
#define		QNV_BROADCAST_SEND_START				(BRIUINT32)1//开始广播
#define		QNV_BROADCAST_SEND_STOP					(BRIUINT32)2//停止广播
#define		QNV_BROADCAST_SEND_ADDADDR				(BRIUINT32)3//增加目标地址
#define		QNV_BROADCAST_SEND_DELETEADDR			(BRIUINT32)4//删除目标地址
#define		QNV_BROADCAST_SEND_PAUSE				(BRIUINT32)5//暂停广播
#define		QNV_BROADCAST_SEND_RESUME				(BRIUINT32)6//恢复广播
#define		QNV_BROADCAST_SEND_ISPAUSE				(BRIUINT32)7//检测是否暂停了广播
#define		QNV_BROADCAST_SEND_SETVOLUME			(BRIUINT32)8//设置广播音量
#define		QNV_BROADCAST_SEND_GETVOLUME			(BRIUINT32)9//获取广播音量

#define		QNV_BROADCAST_RECV_START				(BRIUINT32)30//开始接收
#define		QNV_BROADCAST_RECV_STOP					(BRIUINT32)31//停止接收
#define		QNV_BROADCAST_RECV_SETVOLUME			(BRIUINT32)32//设置接收音量
#define		QNV_BROADCAST_RECV_GETVOLUME			(BRIUINT32)33//获取接收音量
//

//speech语音识别
#define		QNV_SPEECH_CONTENTLIST					(BRIUINT32)1//设置识别汉字内容列表
#define		QNV_SPEECH_STARTSPEECH					(BRIUINT32)2//开始识别
#define		QNV_SPEECH_ISSPEECH						(BRIUINT32)3//检测是否正在识别
#define		QNV_SPEECH_STOPSPEECH					(BRIUINT32)4//停止识别
#define		QNV_SPEECH_GETRESULT					(BRIUINT32)5//获取识别后的结果,使用返回地址方式
#define		QNV_SPEECH_GETRESULTEX					(BRIUINT32)6//获取识别后的结果,使用复制内存方式
#define		QNV_SPEECH_STARTSPEECHFILE				(BRIUINT32)7//识别文件语音

//------------------------------------------------------------

//传真模块接口
#define		QNV_FAX_LOAD							(BRIUINT32)1//加载启动传真模块
#define		QNV_FAX_UNLOAD							(BRIUINT32)2//卸载传真模块
#define		QNV_FAX_STARTSEND						(BRIUINT32)3//开始发送传真
#define		QNV_FAX_STOPSEND						(BRIUINT32)4//停止发送传真
#define		QNV_FAX_STARTRECV						(BRIUINT32)5//开始接收传真
#define		QNV_FAX_STOPRECV						(BRIUINT32)6//停止接收传真
#define		QNV_FAX_STOP							(BRIUINT32)7//停止全部
#define		QNV_FAX_PAUSE							(BRIUINT32)8//暂停
#define		QNV_FAX_RESUME							(BRIUINT32)9//恢复
#define		QNV_FAX_ISPAUSE							(BRIUINT32)10//是否暂停
#define		QNV_FAX_TYPE							(BRIUINT32)11//传真状态是接受或者发送
#define		QNV_FAX_TRANSMITSIZE					(BRIUINT32)12//已经发送的图象数据大小
#define		QNV_FAX_IMAGESIZE						(BRIUINT32)13//总共需要发送图象数据大小
#define		QNV_FAX_SAVESENDFILE					(BRIUINT32)14//保存发送的传真图片
//----------------------------------------------------------

//函数event
//ueventType
#define		QNV_EVENT_POP							(BRIUINT32)1//获取后自动删除当前事件,pValue->PBRI_EVENT
#define		QNV_EVENT_POPEX							(BRIUINT32)2//获取后自动删除当前事件,pValue->字符分隔格式:chid,type,handle,result,data
#define		QNV_EVENT_TYPE							(BRIUINT32)3//获取事件类型,获取后不会自动删除，获取成功后使用 QNV_EVENT_REMOVE删除该事件
#define		QNV_EVENT_HANDLE						(BRIUINT32)4//获取事件的句柄信息
#define		QNV_EVENT_RESULT						(BRIUINT32)5//获取事件数值
#define		QNV_EVENT_PARAM							(BRIUINT32)6//获取事件保留值
#define		QNV_EVENT_DATA							(BRIUINT32)7//获取事件数据
#define		QNV_EVENT_DATAEX						(BRIUINT32)8//获取事件附加数据

#define		QNV_EVENT_REMOVE						(BRIUINT32)20//删除最老的事件
#define		QNV_EVENT_REMOVEALL						(BRIUINT32)21//删除所有事件

#define		QNV_EVENT_REGWND						(BRIUINT32)30//注册接收消息的窗口句柄
#define		QNV_EVENT_UNREGWND						(BRIUINT32)31//删除接收消息的窗口句柄
#define		QNV_EVENT_REGCBFUNC						(BRIUINT32)32//注册事件回调函数()
#define		QNV_EVENT_REGCBFUNCEX					(BRIUINT32)33//注册事件回调函数(结构体方式)
#define		QNV_EVENT_UNREGCBFUNC					(BRIUINT32)34//删除事件回调函数

#define		QNV_EVENT_GETEVENTMSGID					(BRIUINT32)100//查询窗口回调的消息ID,默认为BRI_EVENT_MESSAGE
#define		QNV_EVENT_SETEVENTMSGID					(BRIUINT32)101//设置窗口回调的消息ID,默认为BRI_EVENT_MESSAGE
//-----------------------------------------------------------

//函数general
//uGeneralType
#define		QNV_GENERAL_STARTDIAL					(BRIUINT32)1//开始拨号
#define		QNV_GENERAL_SENDNUMBER					(BRIUINT32)2//二次拨号
#define		QNV_GENERAL_REDIAL						(BRIUINT32)3//重拨最后一次呼叫的号码,程序退出后该号码被释放
#define		QNV_GENERAL_STOPDIAL					(BRIUINT32)4//停止拨号
#define		QNV_GENERAL_ISDIALING					(BRIUINT32)5//是否在拨号

#define		QNV_GENERAL_STARTRING					(BRIUINT32)10//phone口震铃
#define		QNV_GENERAL_STOPRING					(BRIUINT32)11//phone口震铃停止
#define		QNV_GENERAL_ISRINGING					(BRIUINT32)12//phone口是否在震铃

#define		QNV_GENERAL_STARTFLASH					(BRIUINT32)20//拍插簧
#define		QNV_GENERAL_STOPFLASH					(BRIUINT32)21//拍插簧停止
#define		QNV_GENERAL_ISFLASHING					(BRIUINT32)22//是否正在拍插簧

#define		QNV_GENERAL_STARTREFUSE					(BRIUINT32)30//拒接当前呼入
#define		QNV_GENERAL_STOPREFUSE					(BRIUINT32)31//终止拒接操作
#define		QNV_GENERAL_ISREFUSEING					(BRIUINT32)32//是否正在拒接当前呼入

#define		QNV_GENERAL_GETCALLIDTYPE				(BRIUINT32)50//获取本次呼入的来电号码类型
#define		QNV_GENERAL_GETCALLID					(BRIUINT32)51//获取本次呼入的来电号码
#define		QNV_GENERAL_GETTELDIALCODE				(BRIUINT32)52//获取本次电话机拨出的号码,return buf
#define		QNV_GENERAL_GETTELDIALCODEEX			(BRIUINT32)53//获取本次电话机拨出的号码,outbuf
#define		QNV_GENERAL_RESETTELDIALBUF				(BRIUINT32)54//清空电话拨的号码缓冲
#define		QNV_GENERAL_GETTELDIALLEN				(BRIUINT32)55//电话机已拨的号码长度

#define		QNV_GENERAL_STARTSHARE					(BRIUINT32)60//启动设备共享服务
#define		QNV_GENERAL_STOPSHARE					(BRIUINT32)61//停止设备共享服务
#define		QNV_GENERAL_ISSHARE						(BRIUINT32)62//是否启用设备共享服务模块

#define		QNV_GENERAL_ENABLECALLIN				(BRIUINT32)70//禁止/启用外线呼入
#define		QNV_GENERAL_ISENABLECALLIN				(BRIUINT32)71//外线是否允许呼入
#define		QNV_GENERAL_ISLINEHOOK					(BRIUINT32)72//外线是否摘机状态(电话机摘机并连着line或者有软摘机都表示摘机状态)
#define		QNV_GENERAL_ISLINEFREE					(BRIUINT32)73//外线是否空闲(没有摘机并且没有来电表示空闲)

#define		QNV_GENERAL_RESETRINGBACK				(BRIUINT32)80//复位检测到的回铃,重新启动检测
#define		QNV_GENERAL_CHECKCHANNELID				(BRIUINT32)81//检测通道ID是否合法
#define		QNV_GENERAL_CHECKDIALTONE				(BRIUINT32)82//检测摘机后是否检测到拨号音了
#define		QNV_GENERAL_CHECKSILENCE				(BRIUINT32)83//检测线路静音
#define		QNV_GENERAL_CHECKVOICE					(BRIUINT32)84//检测线路声音,声音幅度最低值可使用QNV_PARAM_SPEECHSILENCEAM设置
#define		QNV_GENERAL_CHECKLINESTATE				(BRIUINT32)85//检测线路状态(是否可正常拨号/是否接反)
#define		QNV_GENERAL_GETMAXPOWER					(BRIUINT32)86//获取当前最大语音幅度
#define		QNV_GENERAL_GETCHANNELIDOFSERIAL		(BRIUINT32)87//根据序列号获取通道ID
#define		QNV_GENERAL_RESETRINGBACKEX				(BRIUINT32)88//重新开始检测对方信号,让系统进入是拨号结束状态,不管当前状态是否已经结束

#define		QNV_GENERAL_SETUSERVALUE				(BRIUINT32)90//用户自定义通道数据,系统退出后自动释放
#define		QNV_GENERAL_SETUSERSTRING				(BRIUINT32)91//用户自定义通道字符,系统退出后自动释放
#define		QNV_GENERAL_GETUSERVALUE				(BRIUINT32)92//获取用户自定义通道数据
#define		QNV_GENERAL_GETUSERSTRING				(BRIUINT32)93//获取用户自定义通道字符


#define		QNV_GENERAL_USEREVENT					(BRIUINT32)99//发送用户自定义事件
//初始化通道INI文件参数
#define		QNV_GENERAL_READPARAM					(BRIUINT32)100//读取ini文件进行全部参数初始化
#define		QNV_GENERAL_WRITEPARAM					(BRIUINT32)101//把参数写入到ini文件
//

//call log
#define		QNV_CALLLOG_BEGINTIME					(BRIUINT32)1//获取呼叫开始时间
#define		QNV_CALLLOG_RINGBACKTIME				(BRIUINT32)2//获取回铃时间
#define		QNV_CALLLOG_CONNECTEDTIME				(BRIUINT32)3//获取接通时间
#define		QNV_CALLLOG_ENDTIME						(BRIUINT32)4//获取结束时间
#define		QNV_CALLLOG_CALLTYPE					(BRIUINT32)5//获取呼叫类型/呼入/呼出
#define		QNV_CALLLOG_CALLRESULT					(BRIUINT32)6//获取呼叫结果
#define		QNV_CALLLOG_CALLID						(BRIUINT32)7//获取号码
#define		QNV_CALLLOG_CALLRECFILE					(BRIUINT32)8//获取录音文件路径
#define		QNV_CALLLOG_DELRECFILE					(BRIUINT32)9//删除日志录音文件，要删除前必须先停止录音

#define		QNV_CALLLOG_RESET						(BRIUINT32)20//复位所有状态
#define		QNV_CALLLOG_AUTORESET					(BRIUINT32)21//自动复位
//


//工具函数，跟设备无关
//uToolType
#define		QNV_TOOL_PSTNEND						(BRIUINT32)1//检测PSTN号码是否已经结束
#define		QNV_TOOL_CODETYPE						(BRIUINT32)2//判断号码类型(内地手机/固话)
#define		QNV_TOOL_LOCATION						(BRIUINT32)3//获取号码所在地信息
#define		QNV_TOOL_DISKFREESPACE					(BRIUINT32)4//获取该硬盘剩余空间(M)
#define		QNV_TOOL_DISKTOTALSPACE					(BRIUINT32)5//获取该硬盘总共空间(M)
#define		QNV_TOOL_DISKLIST						(BRIUINT32)6//获取硬盘列表
#define		QNV_TOOL_RESERVID1						(BRIUINT32)7//保留ID1
#define		QNV_TOOL_RESERVID2						(BRIUINT32)8//保留ID2
#define		QNV_TOOL_CONVERTFMT						(BRIUINT32)9//转换语音文件格式
#define		QNV_TOOL_SELECTDIRECTORY				(BRIUINT32)10//选择目录
#define		QNV_TOOL_SELECTFILE						(BRIUINT32)11//选择文件
#define		QNV_TOOL_CONVERTTOTIFF					(BRIUINT32)12//转换图片到传真tiff格式,必须先启动传真模块,支持格式:(*.doc,*.htm,*.html,*.mht,*.jpg,*.pnp.....)
#define		QNV_TOOL_APMQUERYSUSPEND				(BRIUINT32)13//是否允许PC进入待机/休眠,打开USB设备后才能使用
#define		QNV_TOOL_SLEEP							(BRIUINT32)14//让调用该方法的线程等待N毫秒
#define		QNV_TOOL_SETUSERVALUE					(BRIUINT32)15//保存用户自定义信息
#define		QNV_TOOL_GETUSERVALUE					(BRIUINT32)16//读取用户自定义信息
#define		QNV_TOOL_SETUSERVALUEI					(BRIUINT32)17//保存用户自定义信息
#define		QNV_TOOL_GETUSERVALUEI					(BRIUINT32)18//读取用户自定义信息
#define		QNV_TOOL_ISFILEEXIST					(BRIUINT32)20//检测本地文件是否存在
#define		QNV_TOOL_FSKENCODE						(BRIUINT32)21//FSK编码
#define		QNV_TOOL_WRITELOG						(BRIUINT32)22//写文件日志->userlog目录
//------------------------------------------------------

//存储操作,该数据将被永久的存储在USB芯片内
#define		QNV_STORAGE_PUBLIC_READ					(BRIUINT32)1//读取共享区域数据
#define		QNV_STORAGE_PUBLIC_READSTR				(BRIUINT32)2//读取共享区域字符串数据,读到'\0'自动结束
#define		QNV_STORAGE_PUBLIC_WRITE				(BRIUINT32)3//写入共享区域数据
#define		QNV_STORAGE_PUBLIC_SETREADPWD			(BRIUINT32)4//设置读取共享区域数据的密码
#define		QNV_STORAGE_PUBLIC_SETWRITEPWD			(BRIUINT32)5//设置写入共享区域数据的密码
#define		QNV_STORAGE_PUBLIC_GETSPACESIZE			(BRIUINT32)6//获取存储空间长度

//---以下为内部使用接口
#define		QNV_STORAGE_GLOBALINFO_READ				(BRIUINT32)11//读取
#define		QNV_STORAGE_GLOBALINFO_READSTR			(BRIUINT32)12//读取字符串
#define		QNV_STORAGE_GLOBALINFO_WRITE			(BRIUINT32)13//写入
#define		QNV_STORAGE_GLOBALINFO_SETREADPWD		(BRIUINT32)14//设置读取区域数据的密码
#define		QNV_STORAGE_GLOBALINFO_SETWRITEPWD		(BRIUINT32)15//设置写入区域数据的密码
#define		QNV_STORAGE_GLOBALINFO_GETSPACESIZE		(BRIUINT32)16//获取存储空间长度

#define		QNV_STORAGE_PRIVATEINFO_READ			(BRIUINT32)21//读取
#define		QNV_STORAGE_PRIVATEINFO_READSTR			(BRIUINT32)22//读取字符串
#define		QNV_STORAGE_PRIVATEINFO_WRITE			(BRIUINT32)23//写入
#define		QNV_STORAGE_PRIVATEINFO_SETREADPWD		(BRIUINT32)24//设置读取区域数据的密码
#define		QNV_STORAGE_PRIVATEINFO_SETWRITEPWD		(BRIUINT32)25//设置写入区域数据的密码
#define		QNV_STORAGE_PRIVATEINFO_GETSPACESIZE	(BRIUINT32)26//获取存储空间长度

#define		QNV_STORAGE_OEMINFO_READ				(BRIUINT32)31//读取
#define		QNV_STORAGE_OEMINFO_READSTR				(BRIUINT32)32//读取字符串
#define		QNV_STORAGE_OEMINFO_WRITE				(BRIUINT32)33//写入
#define		QNV_STORAGE_OEMINFO_SETREADPWD			(BRIUINT32)34//设置读取区域数据的密码
#define		QNV_STORAGE_OEMINFO_SETWRITEPWD			(BRIUINT32)35//设置写入区域数据的密码
#define		QNV_STORAGE_OEMINFO_GETSPACESIZE		(BRIUINT32)36//获取存储空间长度

#define		QNV_STORAGE_DEVINFO_READ				(BRIUINT32)41//读取
#define		QNV_STORAGE_DEVINFO_READSTR				(BRIUINT32)42//读取字符串
#define		QNV_STORAGE_DEVINFO_WRITE				(BRIUINT32)43//写入
#define		QNV_STORAGE_DEVINFO_SETREADPWD			(BRIUINT32)44//设置读取区域数据的密码
#define		QNV_STORAGE_DEVINFO_SETWRITEPWD			(BRIUINT32)45//设置写入区域数据的密码
#define		QNV_STORAGE_DEVINFO_GETSPACESIZE		(BRIUINT32)46//获取存储空间长度
//--------------------------------------------------------------------------------------


//远程文件操作
//RemoteType
#define		QNV_REMOTE_UPLOAD_START					(BRIUINT32)1//上传文件到WEB服务器(http协议)
#define		QNV_REMOTE_UPLOAD_DATA					(BRIUINT32)2//上传字符数据到WEB服务器(send/post)(保留)
#define		QNV_REMOTE_UPLOAD_STOP					(BRIUINT32)3//上传文件到WEB服务器(http协议)
#define		QNV_REMOTE_UPLOAD_LOG					(BRIUINT32)4//重新上传以前没有成功的记录
#define		QNV_REMOTE_UPLOAD_TOTALSIZE				(BRIUINT32)5//获取需要上传的总共长度
#define		QNV_REMOTE_UPLOAD_TRANSIZE				(BRIUINT32)6//获取已经上传的长度
#define		QNV_REMOTE_UPLOAD_CLEARLOG				(BRIUINT32)7//删除所有未成功的日志
#define		QNV_REMOTE_UPLOAD_COUNT					(BRIUINT32)8//
#define		QNV_REMOTE_UPLOAD_STOPALL				(BRIUINT32)9//

#define		QNV_REMOTE_DOWNLOAD_START				(BRIUINT32)20//开始下载远程文件
#define		QNV_REMOTE_DOWNLOAD_STOP				(BRIUINT32)21//停止下载远程文件
#define		QNV_REMOTE_DOWNLOAD_TOTALSIZE			(BRIUINT32)22//下载的总共长度
#define		QNV_REMOTE_DOWNLOAD_TRANSIZE			(BRIUINT32)23//已经下载的长度
#define		QNV_REMOTE_DOWNLOAD_COUNT				(BRIUINT32)24//
#define		QNV_REMOTE_DOWNLOAD_STOPALL				(BRIUINT32)25//

#define		QNV_REMOTE_SETCOOKIE					(BRIUINT32)40//设置HTTP连接的COOKIE
//------------------------------------------------------

//CC控制
#define		QNV_CCCTRL_SETLICENSE					(BRIUINT32)1//设置license
#define		QNV_CCCTRL_SETSERVER					(BRIUINT32)2//设置服务器IP地址
#define		QNV_CCCTRL_LOGIN						(BRIUINT32)3//登陆
#define		QNV_CCCTRL_LOGOUT						(BRIUINT32)4//退出
#define		QNV_CCCTRL_ISLOGON						(BRIUINT32)5//是否登陆成功了
#define		QNV_CCCTRL_REGCC						(BRIUINT32)6//注册CC号码
#define		QNV_CCCTRL_STARTFINDSERVER				(BRIUINT32)7//自动在内网搜索CC服务器,255.255.255.255表示只广播模式/0.0.0.0只轮寻模式/空表示广播+轮寻模式/其它为指定IP方式
#define		QNV_CCCTRL_STOPFINDSERVER				(BRIUINT32)8//停止搜索
#define		QNV_CCCTRL_MODIFYPWD					(BRIUINT32)9//修改登陆密码
#define		QNV_CCCTRL_SETFINDSVRTIMEOUT			(BRIUINT32)10//设置搜索的超时时间
#define		QNV_CCCTRL_GETFINDSVRTIMEOUT			(BRIUINT32)11//获取搜索的超时时间
//
//语音
#define		QNV_CCCTRL_CALL_START					(BRIUINT32)1//呼叫CC
#define		QNV_CCCTRL_CALL_VOIP					(BRIUINT32)2//VOIP代拨固话
#define		QNV_CCCTRL_CALL_STOP					(BRIUINT32)3//停止呼叫
#define		QNV_CCCTRL_CALL_ACCEPT					(BRIUINT32)4//接听来电
#define		QNV_CCCTRL_CALL_BUSY					(BRIUINT32)5//发送忙提示
#define		QNV_CCCTRL_CALL_REFUSE					(BRIUINT32)6//拒接
#define		QNV_CCCTRL_CALL_STARTPLAYFILE			(BRIUINT32)7//播放文件
#define		QNV_CCCTRL_CALL_STOPPLAYFILE			(BRIUINT32)8//停止播放文件
#define		QNV_CCCTRL_CALL_STARTRECFILE			(BRIUINT32)9//开始文件录音
#define		QNV_CCCTRL_CALL_STOPRECFILE				(BRIUINT32)10//停止文件录音
#define		QNV_CCCTRL_CALL_HOLD					(BRIUINT32)11//保持通话,不影响播放文件
#define		QNV_CCCTRL_CALL_UNHOLD					(BRIUINT32)12//恢复通话
#define		QNV_CCCTRL_CALL_SWITCH					(BRIUINT32)13//呼叫转移到其它CC

#define		QNV_CCCTRL_CALL_CONFHANDLE				(BRIUINT32)20//获取呼叫句柄所在的会议句柄

//
//消息/命令
#define		QNV_CCCTRL_MSG_SENDMSG					(BRIUINT32)1//发送消息
#define		QNV_CCCTRL_MSG_SENDCMD					(BRIUINT32)2//发送命令
#define		QNV_CCCTRL_MSG_REPLYWEBIM				(BRIUINT32)3//回复WEB801消息
#define		QNV_CCCTRL_MSG_REPLYWEBCHECK			(BRIUINT32)4//应答WEB801在线状态查询
#define		QNV_CCCTRL_MSG_QUERYIPINFO				(BRIUINT32)5//查询CC的所有IP地址信息
//
//
//好友
#define		QNV_CCCTRL_CONTACT_ADD					(BRIUINT32)1//增加好友
#define		QNV_CCCTRL_CONTACT_DELETE				(BRIUINT32)2//删除好友
#define		QNV_CCCTRL_CONTACT_ACCEPT				(BRIUINT32)3//接受好友
#define		QNV_CCCTRL_CONTACT_REFUSE				(BRIUINT32)4//拒绝好友
#define		QNV_CCCTRL_CONTACT_GET					(BRIUINT32)5//获取好友状态
//
//

//好友信息/自己的信息
#define		QNV_CCCTRL_CCINFO_OWNERCC				(BRIUINT32)1//获取本人登陆的CC
#define		QNV_CCCTRL_CCINFO_NICK					(BRIUINT32)2//获取CC的昵称,如果没有输入CC就表示获取本人的昵称
#define		QNV_CCCTRL_CCINFO_PWD					(BRIUINT32)3//获取输入的密码
#define		QNV_CCCTRL_CCINFO_CRYPTPWD				(BRIUINT32)4//获取加密后的密码,登陆成功后才能获取，否则返回失败
//
//------------------------------------------------------------

//socket 终端控制
//内部使用接口
#define		QNV_SOCKET_CLIENT_CONNECT				(BRIUINT32)1//连接到服务器
#define		QNV_SOCKET_CLIENT_DISCONNECT			(BRIUINT32)2//断开服务器
#define		QNV_SOCKET_CLIENT_STARTRECONNECT		(BRIUINT32)3//自动重连服务器
#define		QNV_SOCKET_CLIENT_STOPRECONNECT			(BRIUINT32)4//停止自动重连服务器
#define		QNV_SOCKET_CLIENT_ISCONNECTED			(BRIUINT32)5//检测是否已经连接到服务器了
#define		QNV_SOCKET_CLIENT_SENDDATA				(BRIUINT32)6//立即发送数据
#define		QNV_SOCKET_CLIENT_APPENDDATA			(BRIUINT32)7//追加发送数据到队列，如果可以发送就立即发送

//socket 服务器端控制
//内部使用接口
//UDP模块
#define		QNV_SOCKET_UDP_OPEN						(BRIUINT32)1//打开UDP模块
#define		QNV_SOCKET_UDP_CLOSE					(BRIUINT32)2//关闭UDP模块
#define		QNV_SOCKET_UDP_ISOPEN					(BRIUINT32)3//是否打开了UDP模块
#define		QNV_SOCKET_UDP_SENDDATA					(BRIUINT32)4//向目标地址/端口发送数据
#define		QNV_SOCKET_UDP_SETSVRNAME				(BRIUINT32)5//启动主机服务(指定服务名)
#define		QNV_SOCKET_UDP_STARTFINDSVR				(BRIUINT32)6//搜索指定服务名主机
#define		QNV_SOCKET_UDP_STOPFINDSVR				(BRIUINT32)7//停止搜索
//

//AUDIO 虚拟声卡模块
#define		QNV_AUDRV_INSTALL						(BRIUINT32)1//安装虚拟声卡驱动
#define		QNV_AUDRV_UNINSTALL						(BRIUINT32)2//删除虚拟声卡驱动
#define		QNV_AUDRV_ISINSTALL						(BRIUINT32)3//检测ICC301虚拟声卡是否安装了
#define		QNV_AUDRV_SETWAVEOUTID					(BRIUINT32)4//设置ICC301虚拟声卡语音输出的目的USB通道ID(0->N),默认为第一个通道(0),不改变正在在输出的
#define		QNV_AUDRV_SETWAVEINID					(BRIUINT32)5//设置ICC301虚拟声卡语音输入的USB通道ID(0->N),默认为第一个通道(0),不改变正在在输出的
#define		QNV_AUDRV_SWITCHWAVEOUTID				(BRIUINT32)6//转换ICC301虚拟声卡正在输出的语音通道
#define		QNV_AUDRV_SWITCHWAVEINID				(BRIUINT32)7//转换ICC301虚拟声卡正在输入的语音通道
#define		QNV_AUDRV_WAVEOUTCOUNT					(BRIUINT32)8//已经打开的waveout数量
#define		QNV_AUDRV_WAVEINCOUNT					(BRIUINT32)9//已经打开的wavein数量
//

//接口函数列表
//
// 打开设备
BRIINT32	BRISDKLIBAPI	QNV_OpenDevice(BRIUINT32 uDevType,BRIUINT32 uValue,BRICHAR8 *pValue);
// 关闭设备
BRIINT32	BRISDKLIBAPI	QNV_CloseDevice(BRIUINT32 uDevType,BRIUINT32 uValue);
// set dev ctrl
BRIINT32	BRISDKLIBAPI	QNV_SetDevCtrl(BRIINT16 nChannelID,BRIUINT32 uCtrlType,BRIINT32 nValue);
// get dev ctrl
BRIINT32	BRISDKLIBAPI	QNV_GetDevCtrl(BRIINT16 nChannelID,BRIUINT32 uCtrlType);

// set param
BRIINT32	BRISDKLIBAPI	QNV_SetParam(BRIINT16 nChannelID,BRIUINT32 uParamType,BRIINT32 nValue);

// get param
BRIINT32	BRISDKLIBAPI	QNV_GetParam(BRIINT16 nChannelID,BRIUINT32 uParamType);

// play file
BRIINT32	BRISDKLIBAPI	QNV_PlayFile(BRIINT16 nChannelID,BRIUINT32 uPlayType,BRIINT32 nValue,BRIINT32 nValueEx,BRICHAR8 *pValue);

// play buf
BRIINT32	BRISDKLIBAPI	QNV_PlayBuf(BRIINT16 nChannelID,BRIUINT32 uPlayType,BRIINT32 nValue,BRIINT32 nValueEx,BRICHAR8 *pValue);

// play multifile
BRIINT32	BRISDKLIBAPI	QNV_PlayMultiFile(BRIINT16 nChannelID,BRIUINT32 uPlayType,BRIINT32 nValue,BRIINT32 nValueEx,BRICHAR8 *pValue);
// play string
BRIINT32	BRISDKLIBAPI	QNV_PlayString(BRIINT16 nChannelID,BRIUINT32 uPlayType,BRIINT32 nValue,BRIINT32 nValueEx,BRICHAR8 *pValue);

// record file
BRIINT32	BRISDKLIBAPI	QNV_RecordFile(BRIINT16 nChannelID,BRIUINT32 uRecordType,BRIINT32 nValue,BRIINT32 nValueEx,BRICHAR8 *pValue);

// record buf
BRIINT32	BRISDKLIBAPI	QNV_RecordBuf(BRIINT16 nChannelID,BRIUINT32 uRecordType,BRIINT32 nValue,BRIINT32 nValueEx,BRICHAR8 *pValue);

// conference
BRIINT32	BRISDKLIBAPI	QNV_Conference(BRIINT16 nChannelID,BRIINT32 nConfID,BRIUINT32 uConfType,BRIINT32 nValue,BRICHAR8 *pValue);

// broadcast
BRIINT32	BRISDKLIBAPI	QNV_Broadcast(BRIINT16 nChannelID,BRIUINT32 uBroadType,BRIINT32 nValue,BRICHAR8 *pValue);

// speech
BRIINT32	BRISDKLIBAPI	QNV_Speech(BRIINT16 nChannelID,BRIUINT32 uSpeechType,BRIINT32 nValue,BRICHAR8 *pValue);

// fax
BRIINT32	BRISDKLIBAPI	QNV_Fax(BRIINT16 nChannelID,BRIUINT32 uFaxType,BRIINT32 nValue,BRICHAR8 *pValue);

// event
BRIINT32	BRISDKLIBAPI	QNV_Event(BRIINT16 nChannelID,BRIUINT32 uEventType,BRIINT32 nValue,BRICHAR8 *pInValue,BRICHAR8 *pOutValue,BRIINT32 nBufSize);

// general
BRIINT32	BRISDKLIBAPI	QNV_General(BRIINT16 nChannelID,BRIUINT32 uGeneralType,BRIINT32 nValue,BRICHAR8 *pValue);

// pstn call log
BRIINT32	BRISDKLIBAPI	QNV_CallLog(BRIINT16 nChannelID,BRIUINT32 uLogType,BRICHAR8 *pValue,BRIINT32 nValue);

// devinfo
BRIINT32	BRISDKLIBAPI	QNV_DevInfo(BRIINT16 nChannelID,BRIUINT32 uDevInfoType);

// storage read write
BRIINT32	BRISDKLIBAPI	QNV_Storage(BRIINT16 nDevID,BRIUINT32 uOPType,BRIUINT32 uSeek,BRICHAR8 *pPwd,BRICHAR8 *pValue,BRIINT32 nBufSize);

// tool
BRIINT32	BRISDKLIBAPI	QNV_Tool(BRIUINT32 uToolType,BRIINT32 nValue,BRICHAR8 *pInValue,BRICHAR8 *pInValueEx,BRICHAR8 *pOutValue,BRIINT32 nBufSize);

// remote
BRIINT32	BRISDKLIBAPI	QNV_Remote(BRIUINT32 uRemoteType,BRIINT32 nValue,BRICHAR8 *pInValue,BRICHAR8 *pInValueEx,BRICHAR8 *pOutValue,BRIINT32 nBufSize);

// CC ctrl 
BRIINT32	BRISDKLIBAPI	QNV_CCCtrl(BRIUINT32 uCtrlType,BRICHAR8 *pInValue,BRIINT32 nValue);
// CC Call
BRIINT32	BRISDKLIBAPI	QNV_CCCtrl_Call(BRIUINT32 uCallType,BRIINT32 lHandle,BRICHAR8 *pInValue,BRIINT32 nValue);
// CC msg
BRIINT32	BRISDKLIBAPI	QNV_CCCtrl_Msg(BRIUINT32 uMsgType,BRICHAR8 *pDestCC,BRICHAR8 *pMsgValue,BRICHAR8 *pParam,BRIINT32 nReserv);
//
// CC contact
BRIINT32	BRISDKLIBAPI	QNV_CCCtrl_Contact(BRIUINT32 uContactType,BRICHAR8 *pDestCC,BRICHAR8 *pValue);
//
// CC contact info
BRIINT32	BRISDKLIBAPI	QNV_CCCtrl_CCInfo(BRIUINT32 uInfoType,BRICHAR8 *pDestCC,BRICHAR8 *pOutValue,BRIINT32 nBufSize);
//
//远程C/S SOCKET
//终端
BRIINT32	BRISDKLIBAPI	QNV_Socket_Client(BRIUINT32 uSktType,BRIINT32 nHandle,BRIINT32 nValue,BRICHAR8 *pInValue,BRIINT32 nInValueLen);

//服务器端
BRIINT32	BRISDKLIBAPI	QNV_Socket_Server(BRIUINT32 uSktType,BRIINT32 nValue,BRICHAR8 *pInValue,BRIINT32 nInValueLen);

//UDP模块
BRIINT32	BRISDKLIBAPI	QNV_Socket_UDP(BRIUINT32 uUDPType,BRIINT32 nValue,BRICHAR8 *pInAddr,BRICHAR8 *pInValue,BRIINT32 nInValueLen);

//AuDrv虚拟声卡控制
BRIINT32	BRISDKLIBAPI	QNV_Audrv(BRIUINT32 uAudioType,BRIINT32 nValue,BRICHAR8 *pInValue,BRICHAR8 *pOutValue,BRIINT32 nBufSize);

//获取最后一次函数操作错误值
BRIINT32	BRISDKLIBAPI	QNV_GetLastError();
#ifdef __cplusplus
}
#endif

#endif