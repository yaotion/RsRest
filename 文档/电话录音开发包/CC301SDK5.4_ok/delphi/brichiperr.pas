unit brichiperr;

interface


//USB设备操作 返回的错误ID
const		BCERR_VALIDHANDLE			=-9;  //不合法的句柄
const		BCERR_NOPLAYHANDLE			=-10; //没有空闲播放句柄
const		BCERR_OPENFILEFAILED		        =-11; //打开文件失败
const		BCERR_READFILEFAILED		        =-12; //读取文件数据错误
const		BCERR_WAVHEADERFAILED		        =-13; //解析文件头失败
const		BCERR_NOTSUPPORTFORMAT		        =-14; //语音格式不支持
const		BCERR_NORECHANDLE			=-15; //没有足够的录音句柄
const		BCERR_CREATEFILEFAILED		        =-16; //创建录音文件失败
const		BCERR_NOBUFSIZE				=-17; //缓冲不够
const		BCERR_PARAMERR				=-18; //参数错误
const		BCERR_INVALIDTYPE			=-19; //不合法的参数类型		
const		BCERR_INVALIDCHANNEL		        =-20; //不合法的通道ID
const		BCERR_ISMULTIPLAYING		        =-21; //正在多文件播放,请先停止播放
const		BCERR_ISCONFRECING			=-22; //正在会议录音,请先停止录音
const		BCERR_INVALIDCONFID			=-23; //错误的会议ID号
const		BCERR_NOTCREATECONF			=-24; //会议模块还未创建
const		BCERR_NOTCREATEMULTIPLAY	        =-25; //没有开始多文件播放
const		BCERR_NOTCREATESTRINGPLAY	        =-26; //没有开始字符播放
const		BCERR_ISFLASHING			=-27; //正在拍插簧,请先停止
const		BCERR_FLASHNOTLINE			=-28; //设备没有接通线路不能拍插簧
const		BCERR_NOTLOADFAXMODULE		        =-29; //未启动传真模块
const		BCERR_FAXMODULERUNING		        =-30; //传真正在使用，请先停止
const		BCERR_VALIDLICENSE			=-31; //错误的license
const		BCERR_ISFAXING				=-32; //正在传真不能软挂机
const		BCERR_CCMSGOVER				=-33; //CC消息长度太长
const		BCERR_CCCMDOVER				=-34; //CC命令长度太长
const 		BCERR_INVALIDSVR			=-35; //服务器错误
const		BCERR_INVALIDFUNC			=-36; //未找到指定函数模块
const		BCERR_INVALIDCMD			=-37; //未找到指定命令
const		BCERR_UNSUPPORTFUNC			=-38; //设备不支持该功能unsupport func
const		BCERR_DEVNOTOPEN			=-39; //未打开指定设备
const		BCERR_INVALIDDEVID			=-40; //不合法的ID
const		BCERR_INVALIDPWD			=-41; //密码错误
const		BCERR_READSTOREAGEERR		        =-42; //读取存储错误
const		BCERR_INVALIDPWDLEN			=-43; //密码长度太长
const		BCERR_NOTFORMAT				=-44; //flash还未格式化
const		BCERR_FORMATFAILED			=-45; //格式化失败
const		BCERR_NOTENOUGHSPACE		        =-46; //写入的FLASH数据太长,存储空间不够
const		BCERR_WRITESTOREAGEERR		        =-47; //写入存储错误
const		BCERR_NOTSUPPORTCHECK		        =-48; //通道不支持线路检测功能
const		BCERR_INVALIDPATH			=-49; //不合法的文件路径
const		BCERR_AUDRVINSTALLED			=-50; //虚拟声卡驱动已经安装
const		BCERR_AUDRVUSEING			=-51; //虚拟声卡正在使用不能覆盖,请退出正在使用该驱动的软件或者重新启动电脑再安装
const		BCERR_AUDRVCOPYFAILED			=-52; //虚拟声卡驱动文件复制失败


const		ERROR_INVALIDDLL			=-198;//不合法的DLL文件
const		ERROR_NOTINIT				=-199;//还没有初始化任何设备
const		BCERR_UNKNOW				=-200;//未知错误

//-------------------------------------------------------
//CC 操作 回调的错误ID
const TMMERR_BASE                       =0;

const TMMERR_SUCCESS			=0;
const TMMERR_FAILED			=-1;//异常错误
const TMMERR_ERROR			=1;//正常错误
const TMMERR_SERVERDEAD		        =2;//服务器没反应
const TMMERR_INVALIDUIN		        =3;//不合法的
const TMMERR_INVALIDUSER		=4;//不合法的用户
const TMMERR_INVALIDPASS		=5;//不合法的密码
const TMMERR_DUPLOGON			=6;//重复登陆
const TMMERR_INVALIDCONTACT	        =7;//添加的好友CC不存在
const TMMERR_USEROFFLINE		=8;//用户不在线
const TMMERR_INVALIDTYPE		=9;//无效
const TMMERR_EXPIRED			=14;//超时
const TMMERR_INVALIDDLL		        =15;//无效
const TMMERR_OVERRUN			=16;//无效
const TMMERR_NODEVICE			=17;//打开设备失败
const TMMERR_DEVICEBUSY		        =18;//语音呼叫时设备忙
const	TMMERR_NOTLOGON			=19;//未登陆
const TMMERR_ADDSELF			=20;//不能增加自己为好友
const TMMERR_ADDDUP			=21;//增加好友重复
const TMMERR_SESSIONBUSY		=23;//无效
const TMMERR_NOINITIALIZE		=25;//还未初始化
const TMMERR_NOANSWER			=26;//无效
const TMMERR_TIMEOUT			=27;//无效
const TMMERR_LICENCE			=28;//无效
const TMMERR_SENDPACKET		        =29;//无效
const TMMERR_EDGEOUT			=30;//无效
const TMMERR_NOTSUPPORT		        =31;//无效
const TMMERR_NOGROUP			=32;//无效
const TMMERR_LOWERVER_PEER	        =34;//无效
const TMMERR_LOWERVER			=35;//无效
const TMMERR_HASPOINTS		        =36;//无效
const TMMERR_NOTENOUGHPOINTS	        =37;//无效
const TMMERR_NOMEMBER			=38;//无效
const TMMERR_NOAUTH			=39;//无效
const TMMERR_REGTOOFAST		        =40;//注册太快
const TMMERR_REGTOOMANY		        =41;//注册太多
const TMMERR_POINTSFULL		        =42;//无效
const TMMERR_GROUPOVER		        =43;//无效
const TMMERR_SUBGROUPOVER		=44;//无效
const TMMERR_HASMEMBER		        =45;//无效
const TMMERR_NOCONFERENCE		=46;//无效
const	TMMERR_RECALL			=47;//呼叫转移
const	TMMERR_SWITCHVOIP		=48;//修改VOIP服务器地址
const	TMMERR_RECFAILED		=49;//设备录音错误

const TMMERR_CANCEL			=101;//自己取消
const TMMERR_CLIENTCANCEL		=102;//对方取消
const TMMERR_REFUSE			=103;//拒绝对方
const TMMERR_CLIENTREFUSE		=104;//对方拒绝
const TMMERR_STOP			=105;//自己停止=已接通;
const TMMERR_CLIENTSTOP		        =106;//对方停止=已接通;

const TMMERR_VOIPCALLFAILED	        =108;//帐号没钱了
const TMMERR_VOIPCONNECTED	        =200;//VOIP网络连通了
const TMMERR_VOIPDISCONNECTED	        =201;//跟服务器断开连接，SOCKET 服务器关闭了。
const TMMERR_VOIPACCOUNTFAILED          =202;//余额不够
const TMMERR_VOIPPWDFAILED	        =203;//帐号密码错误
const TMMERR_VOIPCONNECTFAILED          =204;//连接VOIP服务器失败
const TMMERR_STARTPROXYTRANS	        =205;//通过代理服务器中转了
//----------------------------------------------------------

implementation

end.
