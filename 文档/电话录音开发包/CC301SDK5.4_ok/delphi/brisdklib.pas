unit brisdklib;

interface

const           NULL                            =nil;//c++->delphi //nil
//2009/10/10
//const		QNV_DLL_VER		      	=$101;
//const         QNV_DLL_VER_STR                 ='1.01';
//2010/01/08
//const		QNV_DLL_VER			=$102;
//const		QNV_DLL_VER_STR			='1.02';
//2010/02/04 增加c/s socket远程通信接口
//const 	QNV_DLL_VER	                =$103;
//const		QNV_DLL_VER_STR			='1.03';

//2010/03/05
//const		QNV_DLL_VER			=$104;
//const		QNV_DLL_VER_STR			='1.04';

//2010/09/20
//const		QNV_DLL_VER			=$105;
//const		QNV_DLL_VER_STR			='1.05';

//2010/10/29
const		QNV_DLL_VER			=$106;
const		QNV_DLL_VER_STR			='1.06';


const		QNV_FILETRANS_VER		=$30301;


const		QNV_CC_LICENSE			='quniccub_x';

//---------------------------------------------
//typedef  __int64			BRIINT64;//符号 64bit(8字节)
//typedef  __int32			BRIINT32;//符号 32bit(4字节)
//typedef  unsigned __int32             BRIUINT32;//无符号 32bit(4字节)
//typedef  __int16			BRIINT16;//符号 16bit(2字节)
//typedef  unsigned __int16	        BRIUINT16;//符号 16bit(2字节)
//typedef  unsigned char		BRIBYTE8;//无符号 8bit(1字节)
//typedef  char				BRICHAR8;//符号 8bit(1字节)
//typedef  char*			BRIPCHAR8;//字符串指针(ANSI)
//typedef  short*			BRIPSHORT16;//字符串指针(UNICODE)
type BRIINT64 = Int64;
type BRIINT32 = Integer;
type BRIUINT32= Cardinal;
type BRIINT16 = Smallint;
type BRIUINT16= Word;
type BRIBYTE8 = Byte;
type BRICHAR8 = AnsiChar;//Shortint;
type BRIPCHAR8= PAnsiChar;//^Shortint   Pchar 升级为  PAnsiChar ,Char升级为AnsiChar
type BRIPSHORT16=^Smallint;
//---------------------------------------------

//播放/录音回调时如果返回该值，系统将自动删除该回调模块，下次将不会被回调
const		CB_REMOVELIST				=-1;

const		MULTI_SEPA_CHAR				='|';//多个文件播放列表分割符号
Const           PROXYDIAL_SIGN                          = $40000000;//代拨标记
Const           PROXYDIAL_SIGN_STRU                     = 'P';//代拨标记
Const           PROXYDIAL_SIGN_STRL                     = 'p';//代拨标记

const		RING_BEGIN_SIGN_STR			='0';
const		RING_END_SIGN_STR			='1';
const		RING_BEGIN_SIGN_CH			='0';
const		RING_END_SIGN_CH			='1';

const		RINGBACK_TELDIAL_STR		        ='0';
const		RINGBACK_PCDIAL_STR			='1';
const		RINGBACK_PCDIAL_CH			='1';
const		RINGBACK_TELDIAL_CH			='0';



const		DIAL_DELAY_SECOND			=',';//拨号时号码之间延迟1秒
const		DIAL_DELAY_HSECOND			='.';//拨号时号码之间延迟0.5秒
const		DIAL_CHECK_CITYCODE			=':';//拨号时该符号后自动过滤城市区号

const		CC_PARAM_SPLIT				=',';//CC参数的分隔符号


//自动创建录音文件时的默认目录名
const		RECFILE_DIR			       ='recfile';
//配置信息里的KEY
const		INI_QNVICC			       ='qnvicc';
//默认配置文件名
const		INI_FILENAME			       ='cc301config.ini';
//VOIP代拨标记
const		CC_VOIP_SIGN			       ='VOIP';
//匿名登陆CC,密码跟号码为相同
const   	WEB_802ID			       ='800002000000000000';



const		MAX_USB_COUNT				=64;//支持的最多USB芯片数
const		MAX_CHANNEL_COUNT			=128;//支持的最多通道数
//声卡控制有效通道ID号
//0->255为USB设备通道号
const		SOUND_CHANNELID				=256;
//远程通信通道,HTTP上传/下载
const		REMOTE_CHANNELID			=257;
//CC控制通道
const		CCCTRL_CHANNELID			=258;
//
//socket 服务器端通道
const		SOCKET_SERVER_CHANNELID		        =259;
//socket 终端通道
const		SOCKET_CLIENT_CHANNELID		        =260;

const		MAX_CCMSG_LEN				=400;//发送消息的最大长度
const		MAX_CCCMD_LEN				=400;//发送命令的最大长度

const		DEFAULT_FLASH_ELAPSE			=600;//默认拍插簧间隔时间(ms)
const		DEFAULT_FLASHFLASH_ELAPSE		=1000;//默认拍插簧后间隔一定时间回调事件ms
const		DEFAULT_RING_ELAPSE			=1000;//默认给内部话机/交换机震铃时间ms响 1秒
const		DEFAULT_RINGSILENCE_ELAPSE		=4000;//默认给内部话机/交换机震铃后停止ms 4秒
const		DEFAULT_RING_TIMEOUT			=12;//默认给内线震铃超时次数,每次1秒响4秒停,总共时间就为N*5
const		DEFAULT_REFUSE_ELAPSE			=500;//拒接时默认使用间隔(ms)
const		DEFAULT_DIAL_SPEED			=75;//默认拨号速度ms
const		DEFAULT_DIAL_SILENCE			=75;//默认号码之间静音时间ms
const		DEFAULT_CHECKDIALTONE_TIMEOUT		=3000;//检测拨号音超时就强制呼叫ms
const		DEFAULT_CALLINTIMEOUT			=5500;//来电响铃超时ms

//设备类型
const		DEVTYPE_UNKNOW				=-1;//未知设备
//cc301系列
const		DEVTYPE_T1		   		=$1009;
const		DEVTYPE_T2		   		=$1000;
const		DEVTYPE_T3		   		=$1008;
const		DEVTYPE_T4		   		=$1005;
const		DEVTYPE_T5		   		=$1002;
const		DEVTYPE_T6		   		=$1004;

const		DEVTYPE_IR1		   		=$8100;

const		DEVTYPE_IA1				=$8111;
const		DEVTYPE_IA2				=$8112;
const		DEVTYPE_IA3				=$8113;
const		DEVTYPE_IA4		   		=$8114;

const		DEVTYPE_IB1				=$8121;
const		DEVTYPE_IB2				=$8122;
const		DEVTYPE_IB3				=$8123;
const		DEVTYPE_IB4				=$8124;

const		DEVTYPE_IP1				=$8131;
const		DEVTYPE_IP1_F				=$8132;  

const		DEVTYPE_IC2_R		        	=$8200;
const		DEVTYPE_IC2_LP			        =$8203;
const		DEVTYPE_IC2_LPQ				=$8207;
const		DEVTYPE_IC2_LPF				=$8211;

const		DEVTYPE_IC4_R		        	=$8400;
const		DEVTYPE_IC4_LP			        =$8403;
const		DEVTYPE_IC4_LPQ				=$8407;
const		DEVTYPE_IC4_LPF				=$8411;

const		DEVTYPE_IC7_R		        	=$8700;
const		DEVTYPE_IC7_LP			        =$8703;
const		DEVTYPE_IC7_LPQ				=$8707;
const		DEVTYPE_IC7_LPF				=$8711;


//玻瑞器
const		DEVTYPE_A1				=$1100000;
const		DEVTYPE_A2				=$1200000;
const		DEVTYPE_A3				=$1300000;
const		DEVTYPE_A4				=$1400000;
const		DEVTYPE_B1		       		=$2100000;
const		DEVTYPE_B2		       		=$2200000;
const		DEVTYPE_B3		       		=$2300000;
const		DEVTYPE_B4		       		=$2400000;
const 	        DEVTYPE_C4_L		       		=$3100000;
const 	        DEVTYPE_C4_P		       		=$3200000;
const 	        DEVTYPE_C4_LP		       		=$3300000;
const 	        DEVTYPE_C4_LPQ		       		=$3400000;
const		DEVTYPE_C7_L		       		=$3500000;
const		DEVTYPE_C7_P		       		=$3600000;
const		DEVTYPE_C7_LP		       		=$3700000;
const		DEVTYPE_C7_LPQ		       		=$3800000;
const		DEVTYPE_R1		       		=$4100000;
const		DEVTYPE_C_PR		       		=$4200000;

//--------------------------------------------------------------
//设备功能模块
//是否具有内置喇叭功能
//可以PC播放语音到喇叭/通话时线路声音到喇叭
const		DEVMODULE_DOPLAY			=$1;
//是否具有可接入外线获取来电号码(FSK/DTMF双制式)/通话录音功能
//可以来电弹屏/通话录音/通话时获取对方按键(DTMF)
const		DEVMODULE_CALLID			=$2;
//是否具有可接入话机进行PSTN通话功能
//可以使用电话机进行PSTN通话/获取话机拨出的号码
const		DEVMODULE_PHONE				 =$4;
//是否具有继电器切换断开/接通话机功能
//断开话机后可以:来电时话机不响铃/使用话机MIC独立采集录音配合DEVFUNC_RING模块给话机模拟来电震铃
const		DEVMODULE_SWITCH			  =$8;
//PC播放语音给话机听筒,具有 DEVMODULE_SWITCH模块,switch后播放语音到话机听筒
const		DEVMODULE_PLAY2TEL			 =$10;
//是否具有话机摘机后拨号/放音给线路的功能
//可以使用PC自动摘机进行拨号/通话时可以给对方播放语音/来电留言/外拨通知/来电IVR(语音答录)
const		DEVMODULE_HOOK				  =$20;
//是否具有插入MIC/耳机功能
//可以用MIC/耳机进行PSTN通话/使用MIC独立录音/PC播放语音给耳机
const		DEVMODULE_MICSPK			   =$40;
//是否具有让接在phone口的设备(电话机,交换机等)模拟震铃功能
//可以任意时刻让phone口的设备模拟来电震铃.如:在来电IVR(语音答录)之后进入工服务时给内部话机或交换机模拟震铃
const		DEVMODULE_RING				    =$80;
//是否具有接收/发送传真功能
//可以发送图片,文档到对方的传真机/可以接收保存对方传真机发送过来的图片
const		DEVMODULE_FAX				     =$100;
//具有级性反转检测对方摘机的功能
//如果PSTN线路在当地电信部门同时开通该级性反转检测服务,就可以在外拨时精确检测到对方摘机/挂机
//如果没有该功能,只有拨打的号码具有标准回铃才才能检测到对方摘机,对手机彩铃,IP等不具有标准回铃线路的不能检测对方摘机/挂机
const		DEVMODULE_POLARITY			      =$800;
//----------------------------------------------------------------


//打开设备类型
const		ODT_LBRIDGE				       =$0;//玻瑞器
const		ODT_SOUND				       =$1;//声卡
const		ODT_CC					       =$2;//CC模块
const		ODT_SOCKET_CLIENT			       =$4;//SOCKET终端模块
const		ODT_SOCKET_SERVER			       =$8;//SOCKET服务器模块
const		ODT_SOCKET_UDP				       =$10;//UDP模块
const		ODT_ALL					       =$FF;//全部
const		ODT_CHANNEL				       =$100;//关闭指定通道
//

//-----------------------------------------------------
//linein线路选择
const		LINEIN_ID_1				       =$0;//默认正常状态录音，采集来电号码等
const		LINEIN_ID_2				       =$1;//电话机断开后话柄录音
const		LINEIN_ID_3				       =$2;//hook line 软摘机后录音,录音数据可以提高对方的音量,降低本地音量
const		LINEIN_ID_LOOP				       =$3;//内部环路测试,设备测试使用,建议用户不需要使用
//-----------------------------------------------------

const		ADCIN_ID_MIC				       =$0;//mic录音
const		ADCIN_ID_LINE				       =$1;//电话线录音

//adc
const		DOPLAY_CHANNEL1_ADC			       =$0;
const		DOPLAY_CHANNEL0_ADC			       =$1;
const		DOPLAY_CHANNEL0_DAC			       =$2;
const		DOPLAY_CHANNEL1_DAC			       =$3;

//------------
const		SOFT_FLASH				       =$1;//使用软件调用拍插完成
const		TEL_FLASH				       =$2;//使用话机拍插完成
//------------
//拒接时使用模式
const		REFUSE_ASYN				       =$0;//异步模式,调用后函数立即返回，但并不表示拒接完成，拒接完成后将接收到一个拒接完成的事件
const		REFUSE_SYN				       =$1;//同步模式,调用后该函数被堵塞，等待拒接完成返回，系统不再有拒接完成的事件

//拍插簧类型
const		FT_NULL					       =$0;
const		FT_TEL					       =$1;//话机拍插簧
const		FT_PC					       =$2;//软拍插簧
const		FT_ALL					       =$3;
//-------------------------------

//拨号类型
const		DTT_DIAL				       =$0;//拨号
const		DTT_SEND				       =$1;//二次发码/震铃发送CALLID
//-------------------------------

//来电号码模式
const		CALLIDMODE_NULL				       =$0;//未知
const		CALLIDMODE_FSK				       =$1;//FSK来电
const		CALLIDMODE_DTMF				       =$2;//DTMF来电
//

//号码类型
const		CTT_NULL				       =$0;
const		CTT_MOBILE				       =$1;//移动号码
const		CTT_PSTN				       =$2;//普通固话号码
//------------------------------

const		CALLT_NULL				       =$0;//
const		CALLT_CALLIN				       =$1;//来电
const		CALLT_CALLOUT				       =$2;//去电
//-------------------

const		CRESULT_NULL				       =$0;
const		CRESULT_MISSED				       =$1;//呼入未接
const		CRESULT_REFUSE				       =$2;//呼入拒接
const		CRESULT_RINGBACK			       =$3;//呼叫后回铃了
const		CRESULT_CONNECTED			       =$4;//接通
//--------------------------------------

const		OPTYPE_NULL				       =$0;
const		OPTYPE_REMOVE				       =$1;//上传成功后删除本地文件

//设备错误ID
const		DERR_READERR				       =$0;//读取数据发送错误
const		DERR_WRITEERR				       =$1;//写入数据错误
const		DERR_FRAMELOST				       =$2;//丢数据包
const		DERR_REMOVE				       =$3;//设备移除
const		DERR_SERIAL				       =$4;//设备序列号冲突
//---------------------------------------

//语音识别时的性别类型
const		SG_NULL					       =$0;
const		SG_MALE					       =$1;//男性
const		SG_FEMALE				       =$2;//女性
const		SG_AUTO					       =$3;//自动
//--------------------------------

//设备共享模式
const		SM_NOTSHARE				       =$0 ;
const		SM_SENDVOICE				       =$1;//发送语音
const		SM_RECVVOICE				       =$2;//接收语音
//----------------------------------

//----------------------------------------------
//传真接受/发送
const		FAX_TYPE_NULL				       =$0;
const		FAX_TYPE_SEND				       =$1;//发送传真
const		FAX_TYPE_RECV				       =$2;//接收传真
//------------------------------------------------

//
const		TTS_LIST_REINIT				       =$0;//重新初始化新的TTS列表
const		TTS_LIST_APPEND				       =$1;//追加TTS列表文件
//------------------------------------------------

//--------------------------------------------------------
const		DIALTYPE_DTMF				       =$0;//DTMF拨号
const		DIALTYPE_FSK				       =$1;//FSK拨号
//--------------------------------------------------------

//--------------------------------------------------------
const		PLAYFILE_MASK_REPEAT				=$1;//循环播放
const		PLAYFILE_MASK_PAUSE				=$2;//默认暂停
//--------------------------------------------------------

//播放文件回调的状态
const		PLAYFILE_PLAYING				=$1;//正在播放
const		PLAYFILE_REPEAT					=$2;//准备重复播放
const		PLAYFILE_END					=$3;//播放结束


const		CONFERENCE_MASK_DISABLEMIC		        =$100;//停止MIC,会议中其它成员不能听到该用户说话
const		CONFERENCE_MASK_DISABLESPK		        =$200;//停止SPK,不能听到会议中其它成员说话


const		RECORD_MASK_ECHO			        =$1;//回音抵消后的数据
const		RECORD_MASK_AGC				        =$2;//自动增益后录音
const		RECORD_MASK_PAUSE			        =$4;//暂停

const		CHECKLINE_MASK_DIALOUT				=$1;//线路是否有正常拨号音(有就可以正常软拨号)
const		CHECKLINE_MASK_REV				=$2;//线路LINE口/PHONE口接线是否正常,不正常就表示接反了

const		OUTVALUE_MAX_SIZE			        =260;//location返回的最大长度


//-----------------------------------------------

//cc 消息参数
//具体字体参数意义请查看windows相关文档
const		MSG_KEY_CC				        ='cc:'; //消息来源CC号
const		MSG_KEY_NAME			                ='name:';//消息来源名称，保留
const		MSG_KEY_TIME			                ='time:';//消息来源时间
const		MSG_KEY_FACE			                ='face:';//字体名称
const		MSG_KEY_COLOR			                ='color:';//字体颜色
const		MSG_KEY_SIZE			                ='size:';//字体尺寸
const		MSG_KEY_CHARSET			                ='charset:';//字体特征
const		MSG_KEY_EFFECTS			                ='effects:';//字体效果
const		MSG_KEY_LENGTH			                ='length:';//消息正文长度
const		MSG_KEY_CID				        ='cid:';//会议ID
const		MSG_KEY_IMTYPE			                ='imtp:';//消息类型
//CC文件参数
const		MSG_KEY_FILENAME		                ='filename:';//文件名
const		MSG_KEY_FILESIZE		                ='filesize:';//文件长度
const		MSG_KEY_FILETYPE		                ='filetype:';//文件类型

//
const		MSG_KEY_CALLPARAM		                ='callparam:';//CC呼叫时的参数

//
//const		MSG_KEY_SPLIT			                ='\r\n';//参数之间分隔符号
//const		MSG_TEXT_SPLIT		                	='\r\n\r\n';//消息参数和消息内容的分隔符号
const		MSG_KEY_SPLIT			                =#13#10;
const		MSG_TEXT_SPLIT		                	=#13#10#13#10;




//数据结构
const		MAX_BRIEVENT_DATA	=600;//事件产生后保存的数据最大长度
type
  TBriEvent_Data = record
    uVersion:           BRIBYTE8;
    uReserv:            BRIBYTE8;
    uChannelID:         BRIINT16;//事件来自通道ID
    lEventType:         BRIINT32;//事件类型ID 查看BRI_EVENT.lEventType Define
    lEventHandle:       BRIINT32;//事件相关句柄
    lResult:            BRIINT32;//事件相关数值
    lParam:             BRIINT32;//保留,扩展时使用
    szData: Array[1..MAX_BRIEVENT_DATA] of BRICHAR8; //事件相关数据.如：来电时，保存了来电的号码
    szDataEx: Array[1..32] of BRICHAR8; //保留,扩展时使用
  end;

type PTBriEvent_Data = ^TBriEvent_Data;


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
//typedef BRIINT32 (CALLBACK *PCallBack_PlayBuf)(BRIINT16 uChannelID,BRIUINT32 dwUserData,BRIINT32 lHandle,BRIINT32 lDataSize,BRIINT32 lFreeSize);
type PCallBack_PlayBuf = function(uChannelID:BRIINT16;dwUserData:longint;lHandle:longint;lDataSize:longint;lFreeSize:longint):longint;stdcall;
///////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//设置文件播放回调原型
//uChannelID:通道ID
//nPlayState:文件播放的状态,PLAYING/REPLAY/END
//dwUserData:用户自定义的数据
//lHandle:播放时返回的句柄
//lElapses:总共播放的时间(单位秒)
//返回 CB_REMOVELIST(-1) 系统将自动停止播放该文件/返回其它值保留
//typedef BRIINT32 (CALLBACK *PCallBack_PlayFile)(BRIINT16 uChannelID,BRIUINT32 nPlayState,BRIUINT32 dwUserData,BRIINT32 lHandle,BRIINT32 lElapses);
type PCallBack_PlayFile = function(uChannelID:BRIINT16;nPlayState:longint;dwUserData:longint;lHandle:longint;lElapses:longint):longint;stdcall;

//////////////////////////////////////////////////////////////////////////////////////////
//缓冲录音回调原型 默认格式为8K/16位/单声道/线性
//uChannelID:通道ID
//dwUserData:用户自定义数据
//pBufData:语音数据
//lBufSize:语音数据的内存字节长度
//返回 CB_REMOVELIST(-1) 将被系统删除该回调资源，下次不再回调/返回其它值保留
//typedef BRIINT32 (CALLBACK *PCallBack_RecordBuf)(BRIINT16 uChannelID,BRIUINT32 dwUserData,BRIBYTE8 *pBufData,BRIINT32 lBufSize);
type PCallBack_RecordBuf = function(uChannelID:BRIINT16;dwUserData:longint;pBufData:BRIPCHAR8;lBufSize:longint):longint;stdcall;
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
//typedef BRIINT32 (CALLBACK *PCallBack_Event)(BRIINT16 uChannelID,BRIUINT32 dwUserData,BRIINT32 lType,BRIINT32 lHandle,BRIINT32 lResult,,BRIINT32 lParam,BRIPCHAR8 pData,BRIPCHAR8 pDataEx);
type PCallBack_Event = function(uChannelID:BRIINT16;dwUserData:longint;lType:longint;lHandle:longint;lResult:longint;lParam:longint;pData:BRIPCHAR8;pDataEx:BRIPCHAR8):longint;stdcall;

//////////////////////////////////////////////////////////////////////////////////////////
//事件发生回调原型,使用结构体方式
//pEvent:事件结构体数据
//dwUserData:用户自定义数据
//备注:和PCallBack_Event只要使用其中一种凡是就可以了
/////////////////////////////////////////////////////////////////////////////////////////
//typedef BRIINT32 (CALLBACK *PCallBack_EventEx)(PBRI_EVENT pEvent,BRIUINT32 dwUserData);
type PCallBack_EventEx = function(pEvent:PTBriEvent_Data;dwUserData:longint):longint;stdcall;



//////////////////////////////////////////////////////////////////////
//  BRI_EVENT.lEventType Define
//  事件类型定义.同步与系统发出的窗口消息(请选择其中一种方式处理)
///////////////////////////////////////////////////////////////////////


// 本地电话机摘机事件
const	BriEvent_PhoneHook				=1;
// 本地电话机挂机事件
const BriEvent_PhoneHang				=2;

// 外线通道来电响铃事件
// BRI_EVENT.lResult		为响铃次数
// BRI_EVENT.szData[0]='0'	开始1秒响铃
// BRI_EVENT.szData[0]='1'	为1秒响铃完成，开始4秒静音
const BriEvent_CallIn					=3;

// 得到来电号码
// BRI_EVENT.lResult		来电号码模式(CALLIDMODE_FSK/CALLIDMODE_DTMF
// BRI_EVENT.szData		保存的来电号码
// 该事件可能在响铃前,也可能在响铃后
const BriEvent_GetCallID				=4;

// 对方停止呼叫(产生一个未接电话)
const BriEvent_StopCallIn				=5;

// 调用开始拨号后，全部号码拨号结束
const BriEvent_DialEnd				        =6;

// 播放文件结束事件
// BRI_EVENT.lResult	   播放文件时返回的句柄ID 
const BriEvent_PlayFileEnd			        =7;

// 多文件连播结束事件
// 
const BriEvent_PlayMultiFileEnd		                =8;

//播放字符结束
const	BriEvent_PlayStringEnd			        =9;

// 播放文件结束准备重复播放
// BRI_EVENT.lResult	   播放文件时返回的句柄ID 
// 
const BriEvent_RepeatPlayFile			        =10;

// 给本地设备发送震铃信号时发送号码结束
const BriEvent_SendCallIDEnd			        =11;

//给本地设备发送震铃信号时超时
//默认不会超时
const BriEvent_RingTimeOut			        =12;

//正在内线震铃
//BRI_EVENT.lResult	   已经响铃的次数
// BRI_EVENT.szData[0]='0'	开始一次响铃
// BRI_EVENT.szData[0]='1'	一次响铃完成，准备静音
const BriEvent_Ringing				        =13;

// 通话时检测到一定时间的静音.默认为5秒
const BriEvent_Silence				        =14;

// 线路接通时收到DTMF码事件
// 该事件不能区分通话中是本地话机按键还是对方话机按键触发
const BriEvent_GetDTMFChar			        =15;

// 拨号后,被叫方摘机事件（该事件仅做参考,原因如下：）
// 原因：
// 该事件只适用于拨打是标准信号音的号码时，也就是拨号后带有标准回铃音的号码。
// 如：当拨打的对方号码是彩铃(彩铃手机号)或系统提示音(179xx)都不是标准回铃音时该事件无效。
// 
const BriEvent_RemoteHook				=16;

// 挂机事件
// 如果线路检测到被叫方摘机后，被叫方挂机时会触发该事件，不然被叫方挂机后就触发BriEvent_Busy事件
// 该事件或者BriEvent_Busy的触发都表示PSTN线路已经被断开
const BriEvent_RemoteHang				=17;

// 检测到忙音事件,表示PSTN线路已经被断开
const BriEvent_Busy					=18;

// 本地摘机后检测到拨号音
const BriEvent_DialTone				        =19;

// 只有在本地话机摘机，没有调用软摘机时，检测到DTMF拨号
const BriEvent_PhoneDial				=20;

// 电话机拨号结束呼出事件。
// 也就时电话机拨号后接收到标准回铃音或者15秒超时
// BRI_EVENT.lResult=0 检测到回铃音// 注意：如果线路是彩铃是不会触发该类型
// BRI_EVENT.lResult=1 拨号超时
// BRI_EVENT.lResult=2 动态检测拨号码结束(根据中国大陆的号码规则进行智能分析，仅做参考)
// BRI_EVENT.szData[0]='1' 软摘机拨号结束后回铃了
// BRI_EVENT.szData[0]='0' 电话机拨号中回铃了
const BriEvent_RingBack				        =21;

// MIC插入状态
// 只适用具有该功能的设备
const BriEvent_MicIn					=22;
// MIC拔出状态
// 只适用具有该功能的设备
const BriEvent_MicOut					=23;

// 拍插簧(Flash)完成事件，拍插簧完成后可以检测拨号音后进行二次拨号
// BRI_EVENT.lResult=TEL_FLASH  用户使用电话机进行拍叉簧完成
// BRI_EVENT.lResult=SOFT_FLASH 调用StartFlash函数进行拍叉簧完成
const BriEvent_FlashEnd				        =24;

// 拒接完成
const BriEvent_RefuseEnd				=25;

// 语音识别完成 
const BriEvent_SpeechResult		        	=26;

//PSTN线路断开,线路进入空闲状态
//当前没有软摘机而且话机也没摘机
const BriEvent_PSTNFree			        	=27;

// 接收到对方准备发送传真的信号
const BriEvent_RemoteSendFax			        =30;

// 接收传真完成
const BriEvent_FaxRecvFinished	                	=31;
// 接收传真失败
const BriEvent_FaxRecvFailed		        	=32;

// 发送传真完成
const BriEvent_FaxSendFinished		                =33;
// 发送传真失败
const BriEvent_FaxSendFailed		        	=34;

// 启动声卡失败
const BriEvent_OpenSoundFailed		                =35;

// 产生一个PSTN呼入/呼出日志
const BriEvent_CallLog				        =36;

//检测到连续的静音
//使用QNV_GENERAL_CHECKSILENCE启动后检测到设定的静音长度
const BriEvent_RecvSilence			        =37;

//检测到连续的声音
//使用QNV_GENERAL_CHECKVOICE启动后检测到设定的声音长度
const BriEvent_RecvVoice				=38;

//远程上传事件
const BriEvent_UploadSuccess			        =50;
const BriEvent_UploadFailed			        =51;
// 远程连接已被断开
const BriEvent_RemoteDisconnect		                =52;

//HTTP远程下载文件完成
//BRI_EVENT.lResult	   启动下载时返回的本次操作的句柄
const BriEvent_DownloadSuccess				=60;
const BriEvent_DownloadFailed				=61;

//线路检测结果
//BRI_EVENT.lResult 为检测结果信息
const BriEvent_CheckLine				=70;


// 应用层调用软摘机/软挂机成功事件
// BRI_EVENT.lResult=0 软摘机
// BRI_EVENT.lResult=1 软挂机			
const BriEvent_EnableHook				=100;
// 喇叭被打开或者/关闭
// BRI_EVENT.lResult=0 关闭
// BRI_EVENT.lResult=1 打开			
const BriEvent_EnablePlay				=101;
// MIC被打开或者关闭	
// BRI_EVENT.lResult=0 关闭
// BRI_EVENT.lResult=1 打开			
const BriEvent_EnableMic				=102;
// 耳机被打开或者关闭
// BRI_EVENT.lResult=0 关闭
// BRI_EVENT.lResult=1 打开			
const BriEvent_EnableSpk				=103;
// 电话机跟电话线(PSTN)断开/接通(DoPhone)
// BRI_EVENT.lResult=0 断开
// BRI_EVENT.lResult=1 接通		
const BriEvent_EnableRing				=104;
// 修改录音源 (无用/保留)
// BRI_EVENT.lResult 录音源数值
const BriEvent_DoRecSource			        =105;
// 开始软件拨号
// BRI_EVENT.szData	准备拨的号码
const BriEvent_DoStartDial			        =106;

const BriEvent_EnablePlayMux			        =107;

// 接收到FSK信号，包括通话中FSK/来电号码的FSK		
const BriEvent_RecvedFSK				=198;
//设备错误
const BriEvent_DevErr					=199;

//CCCtrl Event
//CC控制相关事件
const BriEvent_CC_ConnectFailed		                =200;//连接失败
const BriEvent_CC_LoginFailed		               	=201;//登陆失败
const BriEvent_CC_LoginSuccess		                =202;//登陆成功
const BriEvent_CC_SystemTimeErr		                =203;//系统时间错误
const BriEvent_CC_CallIn				=204;//有CC呼入请求
const BriEvent_CC_CallOutFailed		                =205;//呼叫失败
const BriEvent_CC_CallOutSuccess		        =206;//呼叫成功，正在呼叫
const BriEvent_CC_Connecting			        =207;//呼叫正在连接
const BriEvent_CC_Connected			        =208;//呼叫连通
const BriEvent_CC_CallFinished		                =209;//呼叫结束
const BriEvent_CC_ReplyBusy		                =210;//呼叫结束

const BriEvent_CC_RecvedMsg			        =220;//接收到用户即时消息
const BriEvent_CC_RecvedCmd			        =221;//接收到用户自定义命令

const BriEvent_CC_RegSuccess			        =225;//注册CC成功
const BriEvent_CC_RegFailed			        =226;//注册CC失败

const BriEvent_CC_RecvFileRequest       	        =230;//接收到用户发送的文件请求
const BriEvent_CC_TransFileFinished	                =231;//传输文件结束

const BriEvent_CC_AddContactSuccess	                =240;//增加好友成功
const BriEvent_CC_AddContactFailed	                =241;//增加好友失败
const BriEvent_CC_InviteContact		                =242;//接收到增加好好友邀请
const BriEvent_CC_ReplyAcceptContact	                =243;//对方回复同意为好友
const BriEvent_CC_ReplyRefuseContact	                =244;//对方回复拒绝为好友
const BriEvent_CC_AcceptContactSuccess                  =245;//接受好友成功
const BriEvent_CC_AcceptContactFailed	                =246;//接受好友失败
const BriEvent_CC_RefuseContactSuccess                  =247;//拒绝好友成功
const BriEvent_CC_RefuseContactFailed	                =248;//拒绝好友失败
const BriEvent_CC_DeleteContactSuccess                  =249;//删除好友成功
const BriEvent_CC_DeleteContactFailed                   =250;//删除好友失败
const BriEvent_CC_ContactUpdateStatus	                =251;//好友登陆状态改变
const BriEvent_CC_ContactDownendStatus                  =252;//获取到所有好友改变完成

//终端接收到的事件
const BriEvent_Socket_C_ConnectSuccess                  =300;//连接成功
const BriEvent_Socket_C_ConnectFailed                   =301;//连接失败
const BriEvent_Socket_C_ReConnect                       =302;//开始重新连接
const BriEvent_Socket_C_ReConnectFailed                 =303;//重新连接失败
const BriEvent_Socket_C_ServerClose                     =304;//服务器断开连接
const BriEvent_Socket_C_DisConnect                      =305;//连接激活超时
const BriEvent_Socket_C_RecvedData                      =306;//接收到服务端发送过来的数据
//服务器端接收到的事件
const BriEvent_Socket_S_NewLink                         =340;//有新连接进入
const BriEvent_Socket_S_DisConnect                      =341;//终端连接激活超时
const BriEvent_Socket_S_ClientClose                     =342;//终端断开连接了
const BriEvent_Socket_S_RecvedData                      =343;//接收到终端发送过来的数据

//UDP事件
const BriEvent_Socket_U_RecvedData			=360;//接收到UDP数据
//
const BriEvent_EndID					=500;//空ID





///////////////////////////////////////////////////////////////
//消息定义说明
//////////////////////////////////////////////////////////////
const           WM_USER                                 =1024;
const		BRI_EVENT_MESSAGE			=WM_USER+2000;//事件消息
const		BRI_RECBUF_MESSAGE			=WM_USER+2001;//缓冲录音数据消息

//文件录音格式
const		BRI_WAV_FORMAT_DEFAULT			=0; // BRI_AUDIO_FORMAT_PCM8K16B
const		BRI_WAV_FORMAT_ALAW8K			=1; // 8k/s
const		BRI_WAV_FORMAT_ULAW8K			=2; // 8k/s
const		BRI_WAV_FORMAT_IMAADPCM8K4B		=3; // 4k/s
const		BRI_WAV_FORMAT_PCM8K8B			=4; // 8k/s
const		BRI_WAV_FORMAT_PCM8K16B			=5; //16k/s
const		BRI_WAV_FORMAT_MP38K8B			=6; //~1.2k/s
const		BRI_WAV_FORMAT_MP38K16B			=7; //~2.4k/s
const		BRI_WAV_FORMAT_TM8K1B			=8; //~1.5k/s
const		BRI_WAV_FORMAT_GSM6108K			=9; //~2.2k/s
const		BRI_WAV_FORMAT_END			=255; //无效ID
//保留最多256个
////////////////////////////////////////////////////////////




//-------------------------------------------------------------------------------------
//
//
//----------------------------------------------------------------------------------
//设备信息
const		QNV_DEVINFO_GETCHIPTYPE			=1;//获取USB模块类型
const		QNV_DEVINFO_GETCHIPS			=2;//获取USB模块数量,该值等于最后一个通道的DEVID
const		QNV_DEVINFO_GETTYPE			=3;//获取通道类型
const		QNV_DEVINFO_GETMODULE			=4;//获取通道功能模块
const		QNV_DEVINFO_GETCHIPCHID			=5;//获取通道所在USB芯片的中的传输ID(0或者1)
const		QNV_DEVINFO_GETSERIAL			=6;//获取通道序列号(0-n)
const		QNV_DEVINFO_GETCHANNELS			=7;//获取通道数量
const		QNV_DEVINFO_GETDEVID			=8;//获取通道所在的USB模块ID(0-n)
const		QNV_DEVINFO_GETDLLVER		       	=9;//获取DLL版本号
const           QNV_DEVINFO_GETCHIPCHANNEL              =10;//获取该USB模块第一个传输ID所在的通道号
const		QNV_DEVINFO_GETCHANNELTYPE		=11;//通道线路接外线还是话机类型
const		QNV_DEVINFO_GETCHIPCHANNELS		=12;//获取该USB模块第二个传输ID所在的通道号

const		QNV_DEVINFO_FILEVERSION			=20;//获取DLL的文件版本

//-----------------------------------------------------------------

//参数类型列表
//uParamType (可以使用API自动保存/读取)
const		QNV_PARAM_BUSY				=1;//检测到几个忙音回调
const		QNV_PARAM_DTMFLEVEL		        =2;//dtmf检测时允许的性噪声比(0-5)
const		QNV_PARAM_DTMFVOL			=3;//dtmf检测时允许的能量(1-100)
const		QNV_PARAM_DTMFNUM			=4;//dtmf检测时允许的持续时间(2-10)
const		QNV_PARAM_DTMFLOWINHIGH			=5;//dtmf低频不能超过高频值(默认为6)
const		QNV_PARAM_DTMFHIGHINLOW			=6;//dtmf高频不能超过低频值(默认为4)
const		QNV_PARAM_DIALSPEED			=7;//拨号的DTMF长度(1ms-60000ms)
const		QNV_PARAM_DIALSILENCE			=8;//拨号时的间隔静音长度(1ms-60000ms)
const		QNV_PARAM_DIALVOL			=9;//拨号音量大小
const		QNV_PARAM_RINGSILENCE			=10;//来电不响铃多少时间超时算未接电话
const		QNV_PARAM_CONNECTSILENCE		=11;//通话时连续多少时间静音后回调
const		QNV_PARAM_RINGBACKNUM			=12;//拨几个数字以上后检测回铃开始有效//默认为2个,可起到忽略出局号码后检测的回铃音
const		QNV_PARAM_SWITCHLINEIN			=13;//自动切换LINEIN选择
const		QNV_PARAM_FLASHELAPSE			=14;//拍插簧间隔
const		QNV_PARAM_FLASHENDELAPSE		=15;//拍插簧后延迟一定时间再回调事件
const		QNV_PARAM_RINGELAPSE			=16;//内线震铃时时间长度
const		QNV_PARAM_RINGSILENCEELAPSE		=17;//内线震铃时静音长度
const		QNV_PARAM_RINGTIMEOUT			=18;//内线震铃时超时次数
const		QNV_PARAM_RINGCALLIDTYPE		=19;//内线震铃时发送号码的方式dtmf/fsk
const		QNV_PARAM_REFUSEELAPSE			=20;//拒接时间隔时间长度
const		QNV_PARAM_DIALTONETIMEOUT		=21;//检测拨号音超时
const		QNV_PARAM_MINCHKFLASHELAPSE		=22;//拍插簧检测时挂机至少的时间ms,挂机时间小于该值就不算拍插簧
const		QNV_PARAM_MAXCHKFLASHELAPSE		=23;//拍插簧检测时挂机最长的时间ms,挂机时间大于该值就不算拍插簧
const		QNV_PARAM_HANGUPELAPSE			=24;//检测电话机挂机时的至少时间长度ms,//建议挂机检测次数在拍插簧以上，避免发生挂机后又检测到拍插
const		QNV_PARAM_OFFHOOKELAPSE			=25;//检测电话机摘机时的至少时间长度ms
const		QNV_PARAM_RINGHIGHELAPSE		=26;//检测来电震铃时响铃的至少时间长度ms
const		QNV_PARAM_RINGLOWELAPSE			=27;//检测来电震铃时不响铃的至少时间长度ms

const		QNV_PARAM_SPEECHGENDER			=30;//语音设置性别
const		QNV_PARAM_SPEECHTHRESHOLD		=31;//语音识别门限
const		QNV_PARAM_SPEECHSILENCEAM		=32;//语音识别静音门限
const		QNV_PARAM_ECHOTHRESHOLD			=33;//回音抵消处理抵消门限参数
const		QNV_PARAM_ECHODECVALUE			=34;//回音抵消处理减少增益参数
const		QNV_PARAM_SIGSILENCEAM			=35;//信号音/线路通话分析的静音门限

const		QNV_PARAM_LINEINFREQ1TH			=40;//第一组线路双频模式信号音频率
const		QNV_PARAM_LINEINFREQ2TH			=41;//第二组线路双频模式信号音频率
const		QNV_PARAM_LINEINFREQ3TH			=42;//第三组线路双频模式信号音频率

Const           QNV_PARAM_ADBUSYMINFREQ                 =45;//检测忙音叠加时最小频率
Const           QNV_PARAM_ADBUSYMAXFREQ                 =46;//检测忙音叠加时最大频率

//增益控制
const		QNV_PARAM_AM_MIC			=50;//MIC增益
const		QNV_PARAM_AM_SPKOUT			=51;//耳机spk增益
const		QNV_PARAM_AM_LINEIN			=52;//线路输入能量
const		QNV_PARAM_AM_LINEOUT			=53;//mic到线路能量+播放语音到到线路能量
const		QNV_PARAM_AM_DOPLAY			=54;//喇叭输出增益

const		QNV_PARAM_CITYCODE			=60;//城市区号,适合中国大陆
const		QNV_PARAM_PROXYDIAL			=61;//代拨号

const		QNV_PARAM_FINDSVRTIMEOUT		=70;//设置自动CC搜索超时时间
const		QNV_PARAM_CONFJITTERBUF			=71;//会议交换的动态缓冲大小

const		QNV_PARAM_RINGTHRESHOLD			=80;//来电响铃信号分析门限

const		QNV_PARAM_DTMFCALLIDLEVEL		=100;//dtmf来电号码检测时允许的性噪声比(0-7)
const		QNV_PARAM_DTMFCALLIDNUM			=101;//dtmf来电号码检测时允许的持续时间(2-10)
const		QNV_PARAM_DTMFCALLIDVOL			=102;//dtmf来电号码检测时允许的能量要求

//

//设备控制/状态
//uCtrlType
const		QNV_CTRL_DOSHARE			=1;//设备共享
const		QNV_CTRL_DOHOOK				=2;//软件摘挂机控制
const		QNV_CTRL_DOPHONE			=3;//控制电话机是否可用,可控制话机震铃,实现硬拍插簧等
const		QNV_CTRL_DOPLAY				=4;//喇叭控制开关
const		QNV_CTRL_DOLINETOSPK			=5;//线路声音到耳机，用耳机通话时打开
const		QNV_CTRL_DOPLAYTOSPK			=6;//播放的语音到耳机
const		QNV_CTRL_DOMICTOLINE			=7;//MIC说话声到电话线
const		QNV_CTRL_ECHO				=8;//打开/关闭回音抵消
const		QNV_CTRL_RECVFSK			=9;//打开/关闭接收FSK来电号码
const		QNV_CTRL_RECVDTMF			=10;//打开/关闭接收DTMF
const		QNV_CTRL_RECVSIGN			=11;//打开/关闭信号音检测
const		QNV_CTRL_WATCHDOG			=12;//打开关闭看门狗
const		QNV_CTRL_PLAYMUX			=13;//选择到喇叭的语音通道 line1x/pcplay ch0/line2x/pcplay ch1
const		QNV_CTRL_PLAYTOLINE			=14;//播放的语音到line
const		QNV_CTRL_SELECTLINEIN			=15;//选择输入的线路line通道
const		QNV_CTRL_SELECTADCIN			=16;//选择输入的为线路还是MIC语音
const		QNV_CTRL_PHONEPOWER			=17;//打开/关闭给话机供电使能,如果不给话机供电,dophone切换后,话机将不可用,所有对话机的操作都无效
const		QNV_CTRL_RINGPOWER			=18;//内线震铃使能
const		QNV_CTRL_LEDPOWER			=19;//LED指示灯
const		QNV_CTRL_LINEOUT			=20;//线路输出使能
const		QNV_CTRL_SWITCHOUT			=21;//硬件回音抵消
const		QNV_CTRL_UPLOAD				=22;//打开/关闭设备USB数据上传功能,关闭后将接收不到设备语音数据
const		QNV_CTRL_DOWNLOAD			=23;//打开/关闭设备USB数据下载功能,关闭后将不能发送语音/拨号到设备
const		QNV_CTRL_POLARITY			=24;//开关级性反转摘机检测
const		QNV_CTRL_ADBUSY				=25;//是否打开检测忙音叠加时环境(只有在使用两路外线网关时由于同时挂机才会触发忙音被叠加的环境,普通用户不需要使用)
const		QNV_CTRL_RECVCALLIN			=26;//打开/关闭软解码来电
const		QNV_CTRL_READFRAMENUM			=27;//一次请求读取的USB帧数量，越大占用CPU越小，延迟也就越大，一帧为4ms,最大30帧，也就是设置范围为(1-30)
const		QNV_CTRL_DTMFCALLID			=28;//忽略DTMF模式接收来电号码,默认是开启检测的

//以下状态不能设置(set),只能获取(get)
const		QNV_CTRL_PHONE				=30;//电话机摘挂机状态
const		QNV_CTRL_MICIN				=31;//mic插入状态
const		QNV_CTRL_RINGTIMES			=32;//来电响铃的次数
const		QNV_CTRL_RINGSTATE			=33;//来电响铃状态，正在响还是不响
//

//放音控制
//uPlayType
const		QNV_PLAY_FILE_START		       	=1;//开始播放文件
const		QNV_PLAY_FILE_SETCALLBACK		=2;//设置播放文件回调函数
const		QNV_PLAY_FILE_SETVOLUME			=3;//设置播放文件音量
const		QNV_PLAY_FILE_GETVOLUME			=4;//获取播放文件音量
const		QNV_PLAY_FILE_PAUSE			=5;//暂停播放文件
const		QNV_PLAY_FILE_RESUME			=6;//恢复播放文件
const		QNV_PLAY_FILE_ISPAUSE			=7;//检测是否已暂停播放
const		QNV_PLAY_FILE_SETREPEAT			=8;//设置是否循环播放
const		QNV_PLAY_FILE_ISREPEAT			=9;//检测是否在循环播放
const		QNV_PLAY_FILE_SEEKTO			=11;//跳转到某个时间(ms)
const		QNV_PLAY_FILE_SETREPEATTIMEOUT	        =12;//设置循环播放超时次数
const		QNV_PLAY_FILE_GETREPEATTIMEOUT	        =13;//获取循环播放超时次数
const		QNV_PLAY_FILE_SETPLAYTIMEOUT	        =14;//设置播放总共超时时长(ms)
const		QNV_PLAY_FILE_GETPLAYTIMEOUT	        =15;//获取播放总共超时时长
const		QNV_PLAY_FILE_TOTALLEN			=16;//总共时间(ms)
const		QNV_PLAY_FILE_CURSEEK			=17;//当前播放的文件时间位置(ms)
const		QNV_PLAY_FILE_ELAPSE			=18;//总共播放的时间(ms),包括重复的,后退的,不包括暂停的时间
const		QNV_PLAY_FILE_ISPLAY			=19;//该句柄是否在播放
const		QNV_PLAY_FILE_ENABLEAGC			=20;//打开关闭自动增益
const		QNV_PLAY_FILE_ISENABLEAGC		=21;//检测是否打开自动增益
const		QNV_PLAY_FILE_STOP		       	=22;//停止播放指定文件
const		QNV_PLAY_FILE_GETCOUNT			=23;//获取正在文件播放的数量,可以用来检测如果没有了就可以关闭喇叭
const		QNV_PLAY_FILE_STOPALL			=24;//停止播放所有文件
const		QNV_PLAY_FILE_REMOTEBUFFERLEN		=25;//远程播放需要下载的缓冲长度
const		QNV_PLAY_FILE_REMOTEBUFFERSEEK		=26;//远程播放已经下载的缓冲长度
//--------------------------------------------------------

const		QNV_PLAY_BUF_START			=1;//开始缓冲播放
const		QNV_PLAY_BUF_SETCALLBACK		=2;//设置缓冲播放回调函数
const		QNV_PLAY_BUF_SETWAVEFORMAT		=3;//设置缓冲播放语音的格式
const		QNV_PLAY_BUF_WRITEDATA			=4;//写缓冲数据
const		QNV_PLAY_BUF_SETVOLUME			=5;//设置音量
const		QNV_PLAY_BUF_GETVOLUME			=6;//获取音量
const		QNV_PLAY_BUF_SETUSERVALUE		=7;//设置用户自定义数据
const		QNV_PLAY_BUF_GETUSERVALUE		=8;//获取用户自定义数据
const		QNV_PLAY_BUF_ENABLEAGC			=9;//打开关闭自动增益
const		QNV_PLAY_BUF_ISENABLEAGC		=10;//检测是否打开了自动增益
Const           QNV_PLAY_BUF_PAUSE                      =11;//暂停播放文件
Const           QNV_PLAY_BUF_RESUME                     =12;//恢复播放文件
Const           QNV_PLAY_BUF_ISPAUSE                    =13;//检测是否已暂停播放
Const           QNV_PLAY_BUF_STOP                       =14;//停止缓冲播放
Const           QNV_PLAY_BUF_FREESIZE                   =15;//空闲字节
Const           QNV_PLAY_BUF_DATASIZE                   =16;//数据字节
Const           QNV_PLAY_BUF_TOTALSAMPLES               =17;//总共播放的采样数
Const           QNV_PLAY_BUF_SETJITTERBUFSIZE           =18;//设置动态缓冲长度，当缓冲数据播放为空后下次播放前缓冲内必须大于该长度的语音,可用在播放网络数据包，避免网络抖动
Const           QNV_PLAY_BUF_GETJITTERBUFSIZE           =19;//获取动态缓冲长度
Const           QNV_PLAY_BUF_GETCOUNT                   =20;//获取正在缓冲播放的数量,可以用来检测如果没有了就可以关闭喇叭
Const           QNV_PLAY_BUF_STOPALL                    =21;//停止所有播放
//-------------------------------------------------------

const		QNV_PLAY_MULTIFILE_START		=1;//开始多文件连续播放
const		QNV_PLAY_MULTIFILE_PAUSE		=2;//暂停多文件连续播放
const		QNV_PLAY_MULTIFILE_RESUME		=3;//恢复多文件连续播放
const		QNV_PLAY_MULTIFILE_ISPAUSE		=4;//检测是否暂停了多文件连续播放
const		QNV_PLAY_MULTIFILE_SETVOLUME	        =5;//设置多文件播放音量
const		QNV_PLAY_MULTIFILE_GETVOLUME	        =6;//获取多文件播放音量
const		QNV_PLAY_MULTIFILE_ISSTART	        =7;//是否启动了多文件连续播放
const		QNV_PLAY_MULTIFILE_STOP			=8;//停止多文件连续播放
const		QNV_PLAY_MULTIFILE_STOPALL		=9;//停止全部多文件连续播放
//--------------------------------------------------------

const		QNV_PLAY_STRING_INITLIST		=1;//初始化字符播放列表
const		QNV_PLAY_STRING_START			=2;//开始字符播放
const		QNV_PLAY_STRING_PAUSE			=3;//暂停字符播放
const		QNV_PLAY_STRING_RESUME			=4;//恢复字符播放
const		QNV_PLAY_STRING_ISPAUSE			=5;//检测是否暂停了字符播放
const		QNV_PLAY_STRING_SETVOLUME		=6;//设置字符播放音量
const		QNV_PLAY_STRING_GETVOLUME		=7;//获取字符播放音量
const		QNV_PLAY_STRING_ISSTART 		=8;//是否启动了字符播放
const		QNV_PLAY_STRING_STOP			=9;//停止字符播放
const		QNV_PLAY_STRING_STOPALL			=10;//停止全部字符播放

//--------------------------------------------------------

//录音控制
//uRecordType
const		QNV_RECORD_FILE_START			=1;//开始文件录音
const		QNV_RECORD_FILE_PAUSE			=2;//暂停文件录音
const		QNV_RECORD_FILE_RESUME			=3;//恢复文件录音
const		QNV_RECORD_FILE_ISPAUSE			=4;//检测是否暂停文件录音
const		QNV_RECORD_FILE_ELAPSE			=5;//获取已经录音的时间长度,单位(s)
const		QNV_RECORD_FILE_SETVOLUME		=6;//设置文件录音音量
const		QNV_RECORD_FILE_GETVOLUME		=7;//获取文件录音音量
const		QNV_RECORD_FILE_PATH			=8;//获取文件录音的路径
const		QNV_RECORD_FILE_STOP			=9;//停止某个文件录音
const		QNV_RECORD_FILE_STOPALL			=10;//停止全部文件录音
const		QNV_RECORD_FILE_COUNT			=11;//获取正在录音的数量
const		QNV_RECORD_FILE_SETROOT			=20;//设置默认录音目录
const		QNV_RECORD_FILE_GETROOT			=21;//获取默认录音目录
//----------------------------------------------------------

const		QNV_RECORD_BUF_HWND_START		=1;//开始缓冲录音窗口回调
const		QNV_RECORD_BUF_HWND_STOP		=2;//停止某个缓冲录音窗口回调
const		QNV_RECORD_BUF_HWND_STOPALL		=3;//停止全部缓冲录音窗口回调
const		QNV_RECORD_BUF_CALLBACK_START	        =4;//开始缓冲录音回调
const		QNV_RECORD_BUF_CALLBACK_STOP	        =5;//停止某个缓冲录音回调
const		QNV_RECORD_BUF_CALLBACK_STOPALL	        =6;//停止全部缓冲录音回调
const		QNV_RECORD_BUF_SETCBSAMPLES		=7;//设置回调采样数,每秒8K,如果需要20ms回调一次就设置为20*8=160,/默认为20ms回调一次
const		QNV_RECORD_BUF_GETCBSAMPLES		=8;//获取设置的回调采样数
const		QNV_RECORD_BUF_ENABLEECHO		=9;//打开关闭自动增益
const		QNV_RECORD_BUF_ISENABLEECHO		=10;//检测自动增益是否打开
const		QNV_RECORD_BUF_PAUSE			=11;//暂停缓冲录音
const		QNV_RECORD_BUF_ISPAUSE			=12;//检测是否暂停缓冲录音
const		QNV_RECORD_BUF_RESUME			=13;//恢复缓冲录音
const		QNV_RECORD_BUF_SETVOLUME		=14;//设置缓冲录音音量
const		QNV_RECORD_BUF_GETVOLUME		=15;//获取缓冲录音音量
const		QNV_RECORD_BUF_SETWAVEFORMAT	        =16;//设置录音回调的语音编码格式,默认为8K,16位,wav线性
const		QNV_RECORD_BUF_GETWAVEFORMAT	        =17;//获取录音回调的语音编码格式

const		QNV_RECORD_BUF_GETCBMSGID		=100;//查询缓冲录音的窗口回调的消息ID,默认为BRI_RECBUF_MESSAGE
const		QNV_RECORD_BUF_SETCBMSGID		=101;//设置缓冲录音的窗口回调的消息ID,默认为BRI_RECBUF_MESSAGE
//--------------------------------------------------------

//会议控制
//uConferenceType
const		QNV_CONFERENCE_CREATE			=1;//创建会议
const		QNV_CONFERENCE_ADDTOCONF		=2;//增加通道到某个会议
const		QNV_CONFERENCE_GETCONFID		=3;//获取某个通道的会议ID
const		QNV_CONFERENCE_SETSPKVOLUME		=4;//设置会议中某个通道放音音量
const		QNV_CONFERENCE_GETSPKVOLUME		=5;//获取会议中某个通道放音音量
const		QNV_CONFERENCE_SETMICVOLUME		=6;//设置会议中某个通道录音音量
const		QNV_CONFERENCE_GETMICVOLUME		=7;//获取会议中某个通道录音音量
const		QNV_CONFERENCE_PAUSE			=8;//暂停某个会议
const		QNV_CONFERENCE_RESUME			=9;//恢复某个会议
const		QNV_CONFERENCE_ISPAUSE			=10;//检测是否暂停了某个会议
const		QNV_CONFERENCE_ENABLESPK		=11;//打开关闭会议者听功能
const		QNV_CONFERENCE_ISENABLESPK		=12;//检测会议者听功能是否打开
const		QNV_CONFERENCE_ENABLEMIC		=13;//打开关闭会议者说功能
const		QNV_CONFERENCE_ISENABLEMIC		=14;//检测会议者说功能是否打开
const		QNV_CONFERENCE_ENABLEAGC		=15;//打开关闭自动增益
const		QNV_CONFERENCE_ISENABLEAGC		=16;//检测是否打开了自动增益
const		QNV_CONFERENCE_DELETECHANNEL	        =17;//把通道从会议中删除
const		QNV_CONFERENCE_DELETECONF		=18;//删除一个会议
const		QNV_CONFERENCE_DELETEALLCONF	        =19;//删除全部会议
const		QNV_CONFERENCE_GETCONFCOUNT		=20;//获取会议数量
const		QNV_CONFERENCE_SETJITTERBUFSIZE		=21;//设置会议动态缓冲长度
const		QNV_CONFERENCE_GETJITTERBUFSIZE		=22;//获取会议动态缓冲长度

const		QNV_CONFERENCE_RECORD_START		=30;//开始录音
const		QNV_CONFERENCE_RECORD_PAUSE		=31;//暂停录音
const		QNV_CONFERENCE_RECORD_RESUME	        =32;//恢复录音
const		QNV_CONFERENCE_RECORD_ISPAUSE	        =33;//检测是否暂停录音
const		QNV_CONFERENCE_RECORD_FILEPATH	        =34;//获取录音文件路径
const		QNV_CONFERENCE_RECORD_ISSTART	        =35;//检测会议是否已经启动了录音
const		QNV_CONFERENCE_RECORD_STOP		=36;//停止指定会议录音
const		QNV_CONFERENCE_RECORD_STOPALL	        =37;//停止全部会议录音
//--------------------------------------------------------

//speech语音识别
const		QNV_SPEECH_CONTENTLIST			=1;//设置识别汉字内容列表
const		QNV_SPEECH_STARTSPEECH			=2;//开始识别
const		QNV_SPEECH_ISSPEECH		       	=3;//检测是否正在识别
const		QNV_SPEECH_STOPSPEECH			=4;//停止识别
const		QNV_SPEECH_GETRESULT			=5;//获取识别后的结果
const		QNV_SPEECH_GETRESULTEX			=6;//获取识别后的结果,使用复制内存方式
//------------------------------------------------------------

//传真模块接口
const		QNV_FAX_LOAD			   	=1;//加载启动传真模块
const		QNV_FAX_UNLOAD			  	=2;//卸载传真模块
const		QNV_FAX_STARTSEND		   	=3;//开始发送传真
const		QNV_FAX_STOPSEND		   	=4;//停止发送传真
const		QNV_FAX_STARTRECV		  	=5;//开始接收传真
const		QNV_FAX_STOPRECV		  	=6;//停止接收传真
const		QNV_FAX_STOP			  	=7;//停止全部
const		QNV_FAX_PAUSE			  	=8;//暂停
const		QNV_FAX_RESUME			  	=9;//恢复
const		QNV_FAX_ISPAUSE			  	=10;//是否暂停
const		QNV_FAX_TYPE			   	=11;//传真状态是接受或者发送
const		QNV_FAX_TRANSMITSIZE			=12;//已经发送的图象数据大小
const		QNV_FAX_IMAGESIZE		   	=13;//总共需要发送图象数据大小
const   	QNV_FAX_SAVESENDFILE			=14;//保存发送的传真图片
//----------------------------------------------------------

//函数event
//ueventType
const		QNV_EVENT_POP			 	=1;//获取后自动删除当前事件,pValue->PBRI_EVENT
const		QNV_EVENT_POPEX			 	=2;//获取后自动删除当前事件,pValue->字符分隔格式:chid,type,handle,result,data
const		QNV_EVENT_TYPE			 	=3;//获取事件类型,获取后不会自动删除，获取成功后使用 QNV_GENERAL_EVENT_REMOVE删除该事件
const		QNV_EVENT_HANDLE		  	=4;//获取事件句柄值
const		QNV_EVENT_RESULT		  	=5;//获取事件数值
const		QNV_EVENT_PARAM 		  	=6;//获取事件保留参数
const		QNV_EVENT_DATA			  	=7;//获取事件数据
const		QNV_EVENT_DATAEX		  	=8;//获取事件附加数据

const		QNV_EVENT_REMOVE		  	=20;//删除最老的事件
const		QNV_EVENT_REMOVEALL		 	=21;//删除所有事件

const		QNV_EVENT_REGWND		 	=30;//注册接收消息的窗口句柄
const		QNV_EVENT_UNREGWND		   	=31;//删除接收消息的窗口句柄
const		QNV_EVENT_REGCBFUNC		   	=32;//注册事件回调函数
const		QNV_EVENT_REGCBFUNCEX			=33;//注册事件回调函数(结构体方式)
const		QNV_EVENT_UNREGCBFUNC			=34;//删除事件回调函数

const		QNV_EVENT_GETEVENTMSGID			=100;//查询窗口回调的消息ID,默认为BRI_EVENT_MESSAGE
const		QNV_EVENT_SETEVENTMSGID			=101;//设置窗口回调的消息ID,默认为BRI_EVENT_MESSAGE
//-----------------------------------------------------------

//函数general
//uGeneralType
const		QNV_GENERAL_STARTDIAL			=1;//开始拨号
const		QNV_GENERAL_SENDNUMBER			=2;//二次拨号
const		QNV_GENERAL_REDIAL		 	=3;//重拨最后一次呼叫的号码,程序退出后该号码被释放
const		QNV_GENERAL_STOPDIAL			=4;//停止拨号
const		QNV_GENERAL_ISDIALING			=5;//是否在拨号

const		QNV_GENERAL_STARTRING			=10;//phone口震铃
const		QNV_GENERAL_STOPRING			=11;//phone口震铃停止
const		QNV_GENERAL_ISRINGING			=12;//phone口是否在震铃

const		QNV_GENERAL_STARTFLASH			=20;//拍插簧
const		QNV_GENERAL_STOPFLASH			=21;//拍插簧停止
const		QNV_GENERAL_ISFLASHING			=22;//是否正在拍插簧

const		QNV_GENERAL_STARTREFUSE			=30;//拒接当前呼入
const		QNV_GENERAL_STOPREFUSE			=31;//终止拒接操作
const		QNV_GENERAL_ISREFUSEING			=32;//是否正在拒接当前呼入

const		QNV_GENERAL_GETCALLIDTYPE		=50;//获取本次呼入的来电号码类型
const		QNV_GENERAL_GETCALLID			=51;//获取本次呼入的来电号码
const		QNV_GENERAL_GETTELDIALCODE		=52;//获取本次电话机拨出的号码类型,return buf
const		QNV_GENERAL_GETTELDIALCODEEX	        =53;//获取本次电话机拨出的号码类型,outbuf
const		QNV_GENERAL_RESETTELDIALBUF		=54;//清空电话拨的号码缓冲
const		QNV_GENERAL_GETTELDIALLEN		=55;//电话机已拨的号码长度

const		QNV_GENERAL_STARTSHARE			=60;//启动设备共享服务
const		QNV_GENERAL_STOPSHARE			=61;//停止设备共享服务
const		QNV_GENERAL_ISSHARE		 	=62;//是否启用设备共享服务模块

const		QNV_GENERAL_ENABLECALLIN		=70;//禁止/启用外线呼入
const		QNV_GENERAL_ISENABLECALLIN		=71;//外线是否允许呼入
const		QNV_GENERAL_ISLINEHOOK			=72;//外线是否摘机状态(电话机摘机并连着line或者有软摘机都表示摘机状态)
const		QNV_GENERAL_ISLINEFREE			=73;//外线是否空闲(没有摘机并且没有来电表示空闲)


const		QNV_GENERAL_RESETRINGBACK		=80;//复位检测到的回铃,重新启动检测
const		QNV_GENERAL_CHECKCHANNELID		=81;//检测通道ID是否合法
const		QNV_GENERAL_CHECKDIALTONE		=82;//检测拨号音
const		QNV_GENERAL_CHECKSILENCE		=83;//检测线路静音
const		QNV_GENERAL_CHECKVOICE			=84;//检测线路声音
const		QNV_GENERAL_CHECKLINESTATE		=85;//检测线路状态(是否可正常拨号/是否接反)
const		QNV_GENERAL_GETMAXPOWER			=86;//获取当前最大语音幅度

const		QNV_GENERAL_SETUSERVALUE		=90;//用户自定义通道数据,系统退出后自动释放
const		QNV_GENERAL_SETUSERSTRING		=91;//用户自定义通道字符,系统退出后自动释放
const		QNV_GENERAL_GETUSERVALUE		=92;//获取用户自定义通道数据
const		QNV_GENERAL_GETUSERSTRING		=93;//获取用户自定义通道字符

const		QNV_GENERAL_USEREVENT			=99;//发送用户自定义事件

//初始化通道INI文件参数
const		QNV_GENERAL_READPARAM			=100;//读取ini文件进行全部参数初始化
const		QNV_GENERAL_WRITEPARAM			=101;//把参数写入到ini文件
//

//call log
const		QNV_CALLLOG_BEGINTIME			=1;//获取呼叫开始时间
const		QNV_CALLLOG_RINGBACKTIME		=2;//获取回铃时间
const		QNV_CALLLOG_CONNECTEDTIME		=3;//获取接通时间
const		QNV_CALLLOG_ENDTIME		   	=4;//获取结束时间
const		QNV_CALLLOG_CALLTYPE			=5;//获取呼叫类型/呼入/呼出
const		QNV_CALLLOG_CALLRESULT			=6;//获取呼叫结果
const		QNV_CALLLOG_CALLID		        =7;//获取号码
const		QNV_CALLLOG_CALLRECFILE			=8;//获取录音文件路径
const		QNV_CALLLOG_DELRECFILE			=9;//删除日志录音文件，要删除前必须先停止录音

const		QNV_CALLLOG_RESET			=20;//复位所有状态
const		QNV_CALLLOG_AUTORESET			=21;//自动复位
//工具函数，跟设备无关
//uToolType
const		QNV_TOOL_PSTNEND		 	=1;//检测PSTN号码是否已经结束
const		QNV_TOOL_CODETYPE		 	=2;//判断号码类型(内地手机/固话)
const		QNV_TOOL_LOCATION		 	=3;//获取号码所在地信息
const		QNV_TOOL_DISKFREESPACE			=4;//获取该硬盘剩余空间(M)
const		QNV_TOOL_DISKTOTALSPACE			=5;//获取该硬盘总共空间(M)
const		QNV_TOOL_DISKLIST		 	=6;//获取硬盘列表
const		QNV_TOOL_RESERVID1			=7;//保留
const		QNV_TOOL_RESERVID2			=8;//保留
const		QNV_TOOL_CONVERTFMT	      		=9;//转换语音文件格式
const		QNV_TOOL_SELECTDIRECTORY		=10;//选择目录
const		QNV_TOOL_SELECTFILE			=11;//选择文件
const		QNV_TOOL_CONVERTTOTIFF			=12;//转换图片到传真tiff格式,必须先启动传真模块,支持格式:(*.doc,*.htm,*.html,*.mht,*.jpg,*.pnp.....)
const		QNV_TOOL_APMQUERYSUSPEND		=13;//是否允许PC进入待机/休眠,打开USB设备后才能使用
const		QNV_TOOL_SLEEP				=14;//让调用该方法的线程等待N毫秒
const		QNV_TOOL_SETUSERVALUE			=15;//保存用户自定义信息
const		QNV_TOOL_GETUSERVALUE			=16;//读取用户自定义信息
const		QNV_TOOL_SETUSERVALUEI			=17;//保存用户自定义信息
const		QNV_TOOL_GETUSERVALUEI			=18;//读取用户自定义信息
const		QNV_TOOL_ISFILEEXIST			=20;//检测本地文件是否存在
const		QNV_TOOL_FSKENCODE			=21;//FSK编码
const		QNV_TOOL_WRITELOG			=22;//写文件日志->userlog目录

//------------------------------------------------------

//存储操作
const		QNV_STORAGE_PUBLIC_READ			 =1;//读取共享区域数据
const		QNV_STORAGE_PUBLIC_READSTR		 =2;//读取共享区域字符串数据,读到'\0'自动结束
const		QNV_STORAGE_PUBLIC_WRITE		 =3;//写入共享区域数据
const		QNV_STORAGE_PUBLIC_SETREADPWD		 =4;//设置读取共享区域数据的密码
const		QNV_STORAGE_PUBLIC_SETWRITEPWD		 =5;//设置写入共享区域数据的密码
const		QNV_STORAGE_PUBLIC_GETSPACESIZE		 =6;//获取存储空间长度


//远程操作
//RemoteType
const		QNV_REMOTE_UPLOADFILE			=1;//上传文件到WEB服务器(http协议)
const		QNV_REMOTE_DOWNLOADFILE			=2;//下载远程文件
const		QNV_REMOTE_UPLOADDATA			=3;//上传字符数据到WEB服务器(send/post)
const		QNV_REMOTE_UPLOADLOG			=4;//重新上传以前没有成功的记录
const		QNV_REMOTE_CLEARLOG			=5;//删除所有未成功的日志
//--------------------------------------------------------

//CC控制
const		QNV_CCCTRL_SETLICENSE			=1;//设置license
const		QNV_CCCTRL_SETSERVER			=2;//设置服务器IP地址
const		QNV_CCCTRL_LOGIN		   	=3;//登陆
const		QNV_CCCTRL_LOGOUT		  	=4;//退出
const		QNV_CCCTRL_ISLOGON		   	=5;//是否登陆成功了
const		QNV_CCCTRL_REGCC		   	=6;//注册CC号码
//
//语音
const		QNV_CCCTRL_CALL_START			=1;//呼叫CC
const		QNV_CCCTRL_CALL_VOIP			=2;//VOIP代拨固话
const		QNV_CCCTRL_CALL_STOP			=3;//停止呼叫
const		QNV_CCCTRL_CALL_ACCEPT			=4;//接听来电
const		QNV_CCCTRL_CALL_BUSY			=5;//发送忙提示
const		QNV_CCCTRL_CALL_REFUSE			=6;//拒接
const		QNV_CCCTRL_CALL_STARTPLAYFILE	        =7;//播放文件
const		QNV_CCCTRL_CALL_STOPPLAYFILE	        =8;//停止播放文件
const		QNV_CCCTRL_CALL_STARTRECFILE	        =9;//开始文件录音
const		QNV_CCCTRL_CALL_STOPRECFILE		=10;//停止文件录音
const   	QNV_CCCTRL_CALL_HOLD			=11;//保持通话,不影响播放文件
const		QNV_CCCTRL_CALL_UNHOLD			=12;//恢复通话
const		QNV_CCCTRL_CALL_SWITCH			=13;//呼叫转移到其它CC

const		QNV_CCCTRL_CALL_CONFHANDLE		=20;//获取呼叫句柄所在的会议句柄

//
//消息/命令
const		QNV_CCCTRL_MSG_SENDMSG			=1;//发送消息
const		QNV_CCCTRL_MSG_SENDCMD			=2;//发送命令
const		QNV_CCCTRL_MSG_REPLYWEBIM		=3;//回复WEB801消息
const		QNV_CCCTRL_MSG_REPLYWEBCHECK		=4;//应答WEB801在线状态查询
//
//好友
const		QNV_CCCTRL_CONTACT_ADD			=1;//增加好友
const		QNV_CCCTRL_CONTACT_DELETE		=2;//删除好友
const		QNV_CCCTRL_CONTACT_ACCEPT		=3;//接受好友
const		QNV_CCCTRL_CONTACT_REFUSE		=4;//拒绝好友
const		QNV_CCCTRL_CONTACT_GET			=5;//获取好友状态

//好友信息/自己的信息
const		QNV_CCCTRL_CCINFO_OWNERCC	        =1;//获取本人登陆的CC
const		QNV_CCCTRL_CCINFO_NICK		        =2;//获取CC的昵称,如果没有输入CC就表示获取本人的昵称

//socket 终端控制
const		QNV_SOCKET_CLIENT_CONNECT		=1;//连接到服务器
const		QNV_SOCKET_CLIENT_DISCONNECT		=2;//断开服务器
const		QNV_SOCKET_CLIENT_STARTRECONNECT	=3;//自动重连服务器
const		QNV_SOCKET_CLIENT_STOPRECONNECT		=4;//停止自动重连服务器
const		QNV_SOCKET_CLIENT_SENDDATA		=5;//发送数据


const           QNVDLLNAME                              ='qnviccub.dll';
//------------------------------------------------------------
//接口函数列表
//
// 打开设备
//BRIINT32	BRISDKLIBAPI	QNV_OpenDevice(BRIUINT32 uDevType,BRIUINT32 uValue,BRICHAR8 *pValue);//C++原型
function                        QNV_OpenDevice(uDevType:longint;uValue:longint;pValue:BRIPCHAR8):longint;stdcall;External QNVDLLNAME;

// 关闭设备
//BRIINT32	BRISDKLIBAPI	QNV_CloseDevice(BRIUINT32 uDevType);//C++原型
function                        QNV_CloseDevice(uDevType:longint;uValue:longint):longint;stdcall;External QNVDLLNAME;

// set dev ctrl
//BRIINT32	BRISDKLIBAPI	QNV_SetDevCtrl(BRIINT16 nChannelID,BRIUINT32 uCtrlType,BRIINT32 nValue);//C++原型
function                        QNV_SetDevCtrl(nChannelID:BRIINT16;uCtrlType:longint;nValue:longint):longint;stdcall;External QNVDLLNAME;

// get dev ctrl
//BRIINT32	BRISDKLIBAPI	QNV_GetDevCtrl(BRIINT16 nChannelID,BRIUINT32 uCtrlType);//C++原型
function                        QNV_GetDevCtrl(nChannelID:BRIINT16;uCtrlType:longint):longint;stdcall;External QNVDLLNAME;

// set param
//BRIINT32	BRISDKLIBAPI	QNV_SetParam(BRIINT16 nChannelID,BRIUINT32 uParamType,BRIINT32 nValue);//C++原型
function                        QNV_SetParam(nChannelID:BRIINT16;uParamType:longint;nValue:longint):longint;stdcall;External QNVDLLNAME;

// get param
//BRIINT32	BRISDKLIBAPI	QNV_GetParam(BRIINT16 nChannelID,BRIUINT32 uParamType);//C++原型
function                        QNV_GetParam(nChannelID:BRIINT16;uParamType:longint):longint;stdcall;External QNVDLLNAME;

// play file
//BRIINT32	BRISDKLIBAPI	QNV_PlayFile(BRIINT16 nChannelID,BRIUINT32 uPlayType,BRIINT32 nValue,BRIINT32 nValueEx,BRICHAR8 *pValue);//C++原型
function                        QNV_PlayFile(nChannelID:BRIINT16;uPlayType:longint;nValue:longint;nValueEx:longint;pValue:BRIPCHAR8):longint;stdcall;External QNVDLLNAME;

// play buf
//BRIINT32	BRISDKLIBAPI	QNV_PlayBuf(BRIINT16 nChannelID,BRIUINT32 uPlayType,BRIINT32 nValue,BRIINT32 nValueEx,BRICHAR8 *pValue);//C++原型
function                        QNV_PlayBuf(nChannelID:BRIINT16;uPlayType:longint;nValue:longint;nValueEx:longint;pValue:BRIPCHAR8):longint;stdcall;External QNVDLLNAME;

// play multifile
//BRIINT32	BRISDKLIBAPI	QNV_PlayMultiFile(BRIINT16 nChannelID,BRIUINT32 uPlayType,BRIINT32 nValue,BRIINT32 nValueEx,BRICHAR8 *pValue);//C++原型
function                        QNV_PlayMultiFile(nChannelID:BRIINT16;uPlayType:longint;nValue:longint;nValueEx:longint;pValue:BRIPCHAR8):longint;stdcall;External QNVDLLNAME;

// play string
//BRIINT32	BRISDKLIBAPI	QNV_PlayString(BRIINT16 nChannelID,BRIUINT32 uPlayType,BRIINT32 nValue,BRIINT32 nValueEx,BRICHAR8 *pValue);//C++原型
function                        QNV_PlayString(nChannelID:BRIINT16;uPlayType:longint;nValue:longint;nValueEx:longint;pValue:BRIPCHAR8):longint;stdcall;External QNVDLLNAME;

// record file
//BRIINT32	BRISDKLIBAPI	QNV_RecordFile(BRIINT16 nChannelID,BRIUINT32 uRecordType,BRIINT32 nValue,BRIINT32 nValueEx,BRICHAR8 *pValue);//C++原型
function                        QNV_RecordFile(nChannelID:BRIINT16;uRecordType:longint;nValue:longint;nValueEx:longint;pValue:BRIPCHAR8):longint;stdcall;External QNVDLLNAME;

// record buf
//BRIINT32	BRISDKLIBAPI	QNV_RecordBuf(BRIINT16 nChannelID,BRIUINT32 uRecordType,BRIINT32 nValue,BRIINT32 nValueEx,BRICHAR8 *pValue);//C++原型
function                        QNV_RecordBuf(nChannelID:BRIINT16;uRecordType:longint;nValue:longint;nValueEx:longint;pValue:BRIPCHAR8):longint;stdcall;External QNVDLLNAME;

// conference
//BRIINT32	BRISDKLIBAPI	QNV_Conference(BRIINT16 nChannelID,BRIINT32 nConfID,BRIUINT32 uConferenceType,BRIINT32 nValue,BRICHAR8 *pValue);//C++原型
function                        QNV_Conference(nChannelID:BRIINT16;nConfID:longint;uConferenceType:longint;nValue:longint;pValue:BRIPCHAR8):longint;stdcall;External QNVDLLNAME;

// speech
//BRIINT32	BRISDKLIBAPI	QNV_Speech(BRIINT16 nChannelID,BRIUINT32 uSpeechType,BRIINT32 nValue,BRICHAR8 *pValue);//C++原型
function                        QNV_Speech(nChannelID:BRIINT16;uSpeechType:longint;nValue:longint;pValue:BRIPCHAR8):longint;stdcall;External QNVDLLNAME;

// fax
//BRIINT32	BRISDKLIBAPI	QNV_Fax(BRIINT16 nChannelID,BRIUINT32 uFaxType,BRIINT32 nValue,BRICHAR8 *pValue);//C++原型
function                        QNV_Fax(nChannelID:BRIINT16;uFaxType:longint;nValue:longint;pValue:BRIPCHAR8):longint;stdcall;External QNVDLLNAME;

// event
//BRIINT32	BRISDKLIBAPI	QNV_Event(BRIINT16 nChannelID,BRIUINT32 uEventType,BRIINT32 nValue,BRICHAR8 *pInValue,BRICHAR8 *pOutValue,BRIINT32 nBufSize);//C++原型
function                        QNV_Event(nChannelID:BRIINT16;uEventType:longint;nValue:longint;pInValue:BRIPCHAR8;pOutValue:BRIPCHAR8;nBufSize:longint):longint;stdcall;External QNVDLLNAME;
function                        QNV_Event_E(nChannelID:BRIINT16;uEventType:longint;nValue:longint;pInValue:BRIPCHAR8;e:PTBriEvent_Data;nBufSize:longint):longint;stdcall;External QNVDLLNAME;

// general
//BRIINT32	BRISDKLIBAPI	QNV_General(BRIINT16 nChannelID,BRIUINT32 uGeneralType,BRIINT32 nValue,BRICHAR8 *pValue);//C++原型
function                        QNV_General(nChannelID:BRIINT16;uGeneralType:longint;nValue:longint;pValue:BRIPCHAR8):longint;stdcall;External QNVDLLNAME;

// pstn call log
//BRIINT32	BRISDKLIBAPI	QNV_CallLog(BRIINT16 nChannelID,BRIUINT32 uLogType,BRICHAR8 *pValue,BRIINT32 nValue);//C++原型
function                        QNV_CallLog(nChannelID:BRIINT16;uLogType:longint;pValue:BRIPCHAR8;nValue:longint):longint;stdcall;External QNVDLLNAME;

// devinfo
//BRIINT32	BRISDKLIBAPI	QNV_DevInfo(BRIINT16 nChannelID,BRIUINT32 uGeneralType);//C++原型
function                        QNV_DevInfo(nChannelID:BRIINT16;uGeneralType:longint):longint;stdcall;External QNVDLLNAME;

// tool
//BRIINT32	BRISDKLIBAPI	QNV_Tool(BRIUINT32 uToolType,BRIINT32 nValue,BRICHAR8 *pInValue,BRICHAR8 *pInValueEx,BRICHAR8 *pOutValue,BRIINT32 nBufSize);//C++原型
function                        QNV_Tool(uToolType:longint;nValue:longint;pInValue:BRIPCHAR8;pInValueEx:BRIPCHAR8;pOutValue:BRIPCHAR8;nBufSize:longint):longint;stdcall;External QNVDLLNAME;

// storage read write
//BRIINT32	BRISDKLIBAPI	QNV_Storage(BRIINT16 nDevID,BRIUINT32 uOPType,BRIUINT32 uSeek,BRICHAR8 *pPwd,BRICHAR8 *pValue,BRIINT32 nBufSize);
function                        QNV_Storage(nDevID:longint;uOPType:longint;uSeek:longint;pPwd:BRIPCHAR8;pValue:BRIPCHAR8;nBufSize:longint):longint;stdcall;External QNVDLLNAME;

// remote
//BRIINT32	BRISDKLIBAPI	QNV_Remote(BRIUINT32 uRemoteType,BRIINT32 nValue,BRICHAR8 *pInValue,BRICHAR8 *pInValueEx,BRICHAR8 *pOutValue,BRIINT32 nBufSize);//C++原型
function                        QNV_Remote(uRemoteType:longint;nValue:longint;pInValue:BRIPCHAR8;pInValueEx:BRIPCHAR8;pOutValue:BRIPCHAR8;nBufSize:longint):longint;stdcall;External QNVDLLNAME;

// CC ctrl 
//BRIINT32	BRISDKLIBAPI	QNV_CCCtrl(BRIUINT32 uCtrlType,BRICHAR8 *pInValue,BRIINT32 nValue);//C++原型
function                        QNV_CCCtrl(uCtrlType:longint;pInValue:BRIPCHAR8;nValue:longint):longint;stdcall;External QNVDLLNAME;

// CC Call
//BRIINT32	BRISDKLIBAPI	QNV_CCCtrl_Call(BRIUINT32 uCallType,BRIINT32 lSessHandle,BRICHAR8 *pInValue,BRIINT32 nValue);//C++原型
function                        QNV_CCCtrl_Call(uCallType:longint;lSessHandle:longint;pInValue:BRIPCHAR8;nValue:longint):longint;stdcall;External QNVDLLNAME;

// CC msg
//BRIINT32	BRISDKLIBAPI	QNV_CCCtrl_Msg(BRIUINT32 uMsgType,BRICHAR8 *pDestCC,BRICHAR8 *pMsgValue,BRICHAR8 *pParam,BRIINT32 nReserv);//C++原型
function                        QNV_CCCtrl_Msg(uMsgType:longint;pDestCC:BRIPCHAR8;pMsgValue:pChar;pParam:BRIPCHAR8;nReserv:longint):longint;stdcall;External QNVDLLNAME;
//
// CC contact
//BRIINT32	BRISDKLIBAPI	QNV_CCCtrl_Contact(BRIUINT32 uContactType,BRICHAR8 *pCC,BRICHAR8 *pValue);//c++原型
function                        QNV_CCCtrl_Contact(uContactType:longint;pCC:BRIPCHAR8;pValue:pChar):longint;stdcall;External QNVDLLNAME;
// CC contact info
//BRIINT32	BRISDKLIBAPI	QNV_CCCtrl_CCInfo(BRIUINT32 uInfoType,BRICHAR8 *pDestCC,BRICHAR8 *pOutValue,long nBufSize);/c++ 原型
function	        	QNV_CCCtrl_CCInfo(uInfoType:longint;pDestCC:BRIPCHAR8;pOutValue:BRIPCHAR8;nBufSize:longint):longint;stdcall;External QNVDLLNAME;
//

//BRIINT32	BRISDKLIBAPI	QNV_Socket_Client(BRIUINT32 uSktType,BRIINT32 nHandle,BRIINT32 nValue,BRICHAR8 *pInValue,BRIINT32 nInValueLen);//c++原型
function                        QNV_Socket_Client(uSktType:longint;nHandle:longint;nValue:longint;pInValue:BRIPCHAR8;nInValueLen:longint):longint;stdcall;External QNVDLLNAME;

implementation

end.
