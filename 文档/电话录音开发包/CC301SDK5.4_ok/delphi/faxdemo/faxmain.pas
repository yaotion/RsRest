unit faxmain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,brisdklib;

type
  TForm1 = class(TForm)
    lbmsg: TListBox;
    Label1: TLabel;
    recvfax: TButton;
    sendfax: TButton;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure InitDevice();
    procedure ShowMsg(const msg : WideString);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure recvfaxClick(Sender: TObject);
    procedure sendfaxClick(Sender: TObject);
    procedure MyMsgProc(var Msg:TMessage); message BRI_EVENT_MESSAGE;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses recvfax,sendfax;

{$R *.dfm}

procedure TForm1.ShowMsg(const msg : WideString);
begin
  lbMsg.Items.Append(msg);
  lbMsg.Selected[lbMsg.Items.Count-1]:=true;//选择显示最后一个状态
end;

//消息事件处理器
procedure TForm1.MyMsgProc(var Msg:TMessage);
var
 pEvent:PTBriEvent_Data;
begin
 pEvent := PTBriEvent_Data(Msg.LParam);
 case pEvent^.lEventType of
   BriEvent_PhoneHook:
        begin
          ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ':' +'本地话机摘机');
        end;
   BriEvent_PhoneHang:
        begin
           ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ':' +'本地话机挂机');
        end;
   BriEvent_CallIn:
        begin
           if pEvent^.lResult = 0 then
           begin
            ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ':' +'来电响铃开始');
           end
           else
            ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ':' +'来电响铃静音');
        end;
   BriEvent_GetCallID:
        begin
            ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ':' +'获取到来电号码 '+pEvent^.szData);
        end;
   BriEvent_StopCallIn:
        begin
            ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ':' +'对方停止呼入产生一个未接电话 ');
        end;
   BriEvent_DialEnd:
        begin
           ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ':' +'拨号结束');
        end;
   BriEvent_PlayFileEnd:
        begin
          ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ':' +'播放文件结束');
        end;
   BriEvent_PlayMultiFileEnd:
        begin
          ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ':' +'多文件连播结束');
        end;
   BriEvent_GetDTMFChar:
        begin
          ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ':' +'检测到DTMF按键:'+pEvent^.szData);
        end;
   BriEvent_Busy:
        begin
          ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ':' +'检测到忙音信号/可能未通或者通话已结束');
        end;
   BriEvent_RemoteHook:
        begin
          ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ':' +'检测到对方摘机');
        end;
   BriEvent_RemoteHang:
        begin
          ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ':' +'检测到对方挂机');
        end;
   BriEvent_DialTone:
        begin
          ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ':' +'检测到拨号音');
        end;
   BriEvent_RingBack:
        begin
          ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ':' +'检测到回铃音');
        end;
   BriEvent_RemoteSendFax:
        begin
            ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ':' +'对方准备发送传真 ');
        end;
   BriEvent_FaxRecvFinished:
        begin
            ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ':' +'接收传真完成 ');
        end;
   BriEvent_FaxRecvFailed:
        begin
            ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ':' +'接收传真失败 ');
        end;
   BriEvent_FaxSendFinished:
        begin
            ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ':' +'发送传真完成 ');
        end;
   BriEvent_FaxSendFailed:
        begin
           ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ':' +'发送传真失败 ');
        end;
     else
        begin
         ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ':' +'其它事件 id:'+IntToStr(pEvent^.lEventType));
        end;
   end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  InitDevice();
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 QNV_CloseDevice(ODT_ALL,0);
end;

//初始化设备
procedure TForm1.InitDevice();
var
id:integer;
begin
        if QNV_OpenDevice(0,0,NULL)> 0 then
        begin
            ShowMsg('初始化设备成功,总共通道：'+IntToStr(QNV_DevInfo(0,QNV_DEVINFO_GETCHANNELS)));
            for id:=0 to QNV_DevInfo(0,QNV_DEVINFO_GETCHANNELS)-1 do
              begin
                QNV_Event(id,QNV_EVENT_REGWND,handle,NULL,NULL,0);
              end;
            ShowMsg('初始化通道参数完成');
        end
        else
            ShowMsg('打开设备失败');
end;

procedure TForm1.recvfaxClick(Sender: TObject);
begin
        recvfaxform.ShowModal;
end;

procedure TForm1.sendfaxClick(Sender: TObject);
begin
        sendfaxform.ShowModal;
end;

end.
