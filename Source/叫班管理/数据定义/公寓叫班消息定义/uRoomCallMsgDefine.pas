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
  //��Ԣ�а������豸��Ϣ
  WM_MSG_STARTCONDEV = WM_USER + 1000;
  //���������豸
  WM_MSG_TRYCONDEV = WM_USER + 1001;
  //�����豸����
  WM_MSG_FINISHCONDEV = WM_USER + 1002;
  //��ʼ�����׽�����
  WM_MSG_START_FIRSTCALLPLAY = WM_USER + 1003;
  //�׽��������Ž���
  WM_MSG_FINISH_FIRSTCALLPLAY = WM_USER + 1004;
  //��ʼ���Ŵ߽�����
  WM_MSG_START_RECALLPLAY = WM_USER + 1005;
  //�߽��������Ž���
  WM_MSG_FINISH_RECALLPLAY = WM_USER + 1006;

  //��ʼ���Ŵ߽�����
  WM_MSG_START_SERVERROOM_CALLPLAY = WM_USER + 1007;
   //�߽��������Ž���
  WM_MSG_FINISH_SERVERROOM_CALLPLAY = WM_USER + 1008;

  //��ѯ���н��
  WM_MSG_QUERY_CONDEV = WM_USER + 1009;
type
  //�а��̺߳���
  TExecuteEvent = function ():Boolean of object;

  


implementation

end.
