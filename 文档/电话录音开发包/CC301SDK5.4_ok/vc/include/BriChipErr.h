#ifndef __BRICHIPERR_H__
#define __BRICHIPERR_H__
//API错误ID定义

//USB设备操作 返回的错误ID
#define		BCERR_BASE					(-9)  //最小错误值
#define		BCERR_INVALIDHANDLE			(-9)  //不合法的句柄
#define		BCERR_NOPLAYHANDLE			(-10) //没有空闲播放句柄
#define		BCERR_OPENFILEFAILED		(-11) //打开文件失败
#define		BCERR_READFILEFAILED		(-12) //读取文件数据错误
#define		BCERR_WAVHEADERFAILED		(-13) //解析文件头失败
#define		BCERR_NOTSUPPORTFORMAT		(-14) //语音格式不支持
#define		BCERR_NORECHANDLE			(-15) //没有足够的录音句柄
#define		BCERR_CREATEFILEFAILED		(-16) //创建录音文件失败,检查文件路径格式
#define		BCERR_NOBUFSIZE				(-17) //缓冲不够
#define		BCERR_PARAMERR				(-18) //参数错误
#define		BCERR_INVALIDTYPE			(-19) //不合法的参数类型		
#define		BCERR_INVALIDCHANNEL		(-20) //不合法的通道ID
#define		BCERR_ISMULTIPLAYING		(-21) //正在多文件播放,请先停止播放
#define		BCERR_ISCONFRECING			(-22) //正在会议录音,请先停止录音
#define		BCERR_INVALIDCONFID			(-23) //错误的会议ID号
#define		BCERR_NOTCREATECONF			(-24) //会议模块还未创建
#define		BCERR_NOTCREATEMULTIPLAY	(-25) //没有开始多文件播放
#define		BCERR_NOTCREATESTRINGPLAY	(-26) //没有开始字符播放
#define		BCERR_ISFLASHING			(-27) //正在拍插簧,请先停止
#define		BCERR_FLASHNOTLINE			(-28) //设备没有接通线路不能拍插簧
#define		BCERR_NOTLOADFAXMODULE		(-29) //未启动传真模块
#define		BCERR_FAXMODULERUNING		(-30) //传真正在使用，请先停止
#define		BCERR_VALIDLICENSE			(-31) //错误的license
#define		BCERR_ISFAXING				(-32) //正在传真不能软挂机
#define		BCERR_CCMSGOVER				(-33) //CC消息长度太长
#define		BCERR_CCCMDOVER				(-34) //CC命令长度太长
#define		BCERR_INVALIDSVR			(-35) //服务器错误
#define		BCERR_INVALIDFUNC			(-36) //未找到指定函数模块
#define		BCERR_INVALIDCMD			(-37) //未找到指定命令
#define		BCERR_UNSUPPORTFUNC			(-38) //设备不支持该功能unsupport func
#define		BCERR_DEVNOTOPEN			(-39) //未打开指定设备
#define		BCERR_INVALIDDEVID			(-40) //不合法的ID
#define		BCERR_INVALIDPWD			(-41) //密码错误
#define		BCERR_READSTOREAGEERR		(-42) //读取存储错误
#define		BCERR_INVALIDPWDLEN			(-43) //密码长度太长
#define		BCERR_NOTFORMAT				(-44) //flash还未格式化
#define		BCERR_FORMATFAILED			(-45) //格式化失败
#define		BCERR_NOTENOUGHSPACE		(-46) //写入的FLASH数据太长,存储空间不够
#define		BCERR_WRITESTOREAGEERR		(-47) //写入存储错误
#define		BCERR_NOTSUPPORTCHECK		(-48) //通道不支持线路检测功能
#define		BCERR_INVALIDPATH			(-49) //不合法的文件路径
#define		BCERR_AUDRVINSTALLED		(-50) //虚拟声卡驱动已经安装
#define		BCERR_AUDRVUSEING			(-51) //虚拟声卡正在使用不能覆盖,请退出正在使用该驱动的软件或者重新启动电脑再安装
#define		BCERR_AUDRVCOPYFAILED		(-52) //虚拟声卡驱动文件复制失败

#define		ERROR_INVALIDDLL			(-198)//不合法的DLL文件
#define		ERROR_NOTINIT				(-199)//还没有初始化任何设备
#define		BCERR_UNKNOW				(-200)//未知错误

//-------------------------------------------------------
//CC 操作 回调的错误ID
#define TMMERR_BASE 0

#define TMMERR_SUCCESS			(DWORD)0
#define TMMERR_FAILED			(DWORD)(-1)//异常错误
#define TMMERR_ERROR			(TMMERR_BASE + 1)//正常错误
#define TMMERR_SERVERDEAD		(TMMERR_BASE + 2)//服务器没反应
#define TMMERR_INVALIDUIN		(TMMERR_BASE + 3)//不合法的
#define TMMERR_INVALIDUSER		(TMMERR_BASE + 4)//不合法的用户
#define TMMERR_INVALIDPASS		(TMMERR_BASE + 5)//不合法的密码
#define TMMERR_DUPLOGON			(TMMERR_BASE + 6)//重复登陆
#define TMMERR_INVALIDCONTACT	(TMMERR_BASE + 7)//添加的好友CC不存在
#define TMMERR_USEROFFLINE		(TMMERR_BASE + 8)//用户不在线
#define TMMERR_INVALIDTYPE		(TMMERR_BASE + 9)//无效
#define TMMERR_EXPIRED			(TMMERR_BASE + 14)//超时
#define TMMERR_INVALIDDLL		(TMMERR_BASE + 15)//无效
#define TMMERR_OVERRUN			(TMMERR_BASE + 16)//无效
#define TMMERR_NODEVICE			(TMMERR_BASE + 17)//打开设备失败
#define TMMERR_DEVICEBUSY		(TMMERR_BASE + 18)//语音呼叫时设备忙
#define	TMMERR_NOTLOGON			(TMMERR_BASE + 19)//未登陆
#define TMMERR_ADDSELF			(TMMERR_BASE + 20)//不能增加自己为好友
#define TMMERR_ADDDUP			(TMMERR_BASE + 21)//增加好友重复
#define TMMERR_SESSIONBUSY		(TMMERR_BASE + 23)//无效
#define TMMERR_NOINITIALIZE		(TMMERR_BASE + 25)//还未初始化
#define TMMERR_NOANSWER			(TMMERR_BASE + 26)//无效
#define TMMERR_TIMEOUT			(TMMERR_BASE + 27)//无效
#define TMMERR_LICENCE			(TMMERR_BASE + 28)//无效
#define TMMERR_SENDPACKET		(TMMERR_BASE + 29)//无效
#define TMMERR_EDGEOUT			(TMMERR_BASE + 30)//无效
#define TMMERR_NOTSUPPORT		(TMMERR_BASE + 31)//无效
#define TMMERR_NOGROUP			(TMMERR_BASE + 32)//无效
#define TMMERR_LOWERVER_PEER	(TMMERR_BASE + 34)//无效
#define TMMERR_LOWERVER			(TMMERR_BASE + 35)//无效
#define TMMERR_HASPOINTS		(TMMERR_BASE + 36)//无效
#define TMMERR_NOTENOUGHPOINTS	(TMMERR_BASE + 37)//无效
#define TMMERR_NOMEMBER			(TMMERR_BASE + 38)//无效
#define TMMERR_NOAUTH			(TMMERR_BASE + 39)//无效
#define TMMERR_REGTOOFAST		(TMMERR_BASE + 40)//注册太快
#define TMMERR_REGTOOMANY		(TMMERR_BASE + 41)//注册太多
#define TMMERR_POINTSFULL		(TMMERR_BASE + 42)//无效
#define TMMERR_GROUPOVER		(TMMERR_BASE + 43)//无效
#define TMMERR_SUBGROUPOVER		(TMMERR_BASE + 44)//无效
#define TMMERR_HASMEMBER		(TMMERR_BASE + 45)//无效
#define TMMERR_NOCONFERENCE		(TMMERR_BASE + 46)//无效
#define	TMMERR_RECALL			(TMMERR_BASE + 47)//呼叫转移
#define	TMMERR_SWITCHVOIP		(TMMERR_BASE + 48)//修改VOIP服务器地址
#define	TMMERR_RECFAILED		(TMMERR_BASE + 49)//设备录音错误

#define TMMERR_CANCEL			(TMMERR_BASE + 101)//自己取消
#define TMMERR_CLIENTCANCEL		(TMMERR_BASE + 102)//对方取消
#define TMMERR_REFUSE			(TMMERR_BASE + 103)//拒绝对方
#define TMMERR_CLIENTREFUSE		(TMMERR_BASE + 104)//对方拒绝
#define TMMERR_STOP				(TMMERR_BASE + 105)//自己停止(已接通)
#define TMMERR_CLIENTSTOP		(TMMERR_BASE + 106)//对方停止(已接通)

#define TMMERR_VOIPCALLFAILED	 (TMMERR_BASE + 108)//帐号没钱了
#define TMMERR_VOIPCONNECTED	 (TMMERR_BASE + 200)//VOIP网络连通了
#define TMMERR_VOIPDISCONNECTED	 (TMMERR_BASE + 201)//跟服务器断开连接，SOCKET 服务器关闭了。
#define TMMERR_VOIPACCOUNTFAILED (TMMERR_BASE + 202)//余额不够
#define TMMERR_VOIPPWDFAILED	 (TMMERR_BASE + 203)//帐号密码错误
#define TMMERR_VOIPCONNECTFAILED (TMMERR_BASE + 204)//连接VOIP服务器失败
#define TMMERR_STARTPROXYTRANS	 (TMMERR_BASE + 205)//通过代理服务器中转了
//----------------------------------------------------------

#endif