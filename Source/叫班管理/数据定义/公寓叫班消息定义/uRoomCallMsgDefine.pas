unit uRoomCallMsgDefine;

interface
uses
  Windows,Messages;
const
  WM_MESSAGE_FORMSHOW = WM_USER + 10;
  WM_BeginCall = WM_User + 1;
  WM_EndCall = WM_User + 4;
  WM_CallSucceed = WM_User + 2;
  WM_CallFail = WM_User + 3;
  WM_HangSucceed = WM_User + 5;
  WM_HangFail = WM_User + 6;
  WM_Message_EndPlay = WM_User + 7;
  //公寓叫班连接设备消息
  WM_MSG_STARTCONDEV = WM_USER + 1000;
  //尝试连接设备
  WM_MSG_TRYCONDEV = WM_USER + 1001;
  //连接设备结束
  WM_MSG_FINISHCONDEV = WM_USER + 1002;
  //开始播放首叫语音
  WM_MSG_START_FIRSTCALLPLAY = WM_USER + 1003;
  //首叫语音播放结束
  WM_MSG_FINISH_FIRSTCALLPLAY = WM_USER + 1004;
  //开始播放催叫语音
  WM_MSG_START_RECALLPLAY = WM_USER + 1005;
  //催叫语音播放结束
  WM_MSG_FINISH_RECALLPLAY = WM_USER + 1006;

  //开始播放催叫语音
  WM_MSG_START_SERVERROOM_CALLPLAY = WM_USER + 1007;
   //催叫语音播放结束
  WM_MSG_FINISH_SERVERROOM_CALLPLAY = WM_USER + 1008;

  //查询呼叫结果
  WM_MSG_QUERY_CONDEV = WM_USER + 1009;
type
  //叫班线程函数
  TExecuteEvent = function ():Boolean of object;

  


implementation

end.
