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
  lbMsg.Selected[lbMsg.Items.Count-1]:=true;//ѡ����ʾ���һ��״̬
end;

//��Ϣ�¼�������
procedure TForm1.MyMsgProc(var Msg:TMessage);
var
 pEvent:PTBriEvent_Data;
begin
 pEvent := PTBriEvent_Data(Msg.LParam);
 case pEvent^.lEventType of
   BriEvent_PhoneHook:
        begin
          ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ':' +'���ػ���ժ��');
        end;
   BriEvent_PhoneHang:
        begin
           ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ':' +'���ػ����һ�');
        end;
   BriEvent_CallIn:
        begin
           if pEvent^.lResult = 0 then
           begin
            ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ':' +'�������忪ʼ');
           end
           else
            ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ':' +'�������徲��');
        end;
   BriEvent_GetCallID:
        begin
            ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ':' +'��ȡ��������� '+pEvent^.szData);
        end;
   BriEvent_StopCallIn:
        begin
            ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ':' +'�Է�ֹͣ�������һ��δ�ӵ绰 ');
        end;
   BriEvent_DialEnd:
        begin
           ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ':' +'���Ž���');
        end;
   BriEvent_PlayFileEnd:
        begin
          ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ':' +'�����ļ�����');
        end;
   BriEvent_PlayMultiFileEnd:
        begin
          ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ':' +'���ļ���������');
        end;
   BriEvent_GetDTMFChar:
        begin
          ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ':' +'��⵽DTMF����:'+pEvent^.szData);
        end;
   BriEvent_Busy:
        begin
          ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ':' +'��⵽æ���ź�/����δͨ����ͨ���ѽ���');
        end;
   BriEvent_RemoteHook:
        begin
          ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ':' +'��⵽�Է�ժ��');
        end;
   BriEvent_RemoteHang:
        begin
          ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ':' +'��⵽�Է��һ�');
        end;
   BriEvent_DialTone:
        begin
          ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ':' +'��⵽������');
        end;
   BriEvent_RingBack:
        begin
          ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ':' +'��⵽������');
        end;
   BriEvent_RemoteSendFax:
        begin
            ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ':' +'�Է�׼�����ʹ��� ');
        end;
   BriEvent_FaxRecvFinished:
        begin
            ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ':' +'���մ������ ');
        end;
   BriEvent_FaxRecvFailed:
        begin
            ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ':' +'���մ���ʧ�� ');
        end;
   BriEvent_FaxSendFinished:
        begin
            ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ':' +'���ʹ������ ');
        end;
   BriEvent_FaxSendFailed:
        begin
           ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ':' +'���ʹ���ʧ�� ');
        end;
     else
        begin
         ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ':' +'�����¼� id:'+IntToStr(pEvent^.lEventType));
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

//��ʼ���豸
procedure TForm1.InitDevice();
var
id:integer;
begin
        if QNV_OpenDevice(0,0,NULL)> 0 then
        begin
            ShowMsg('��ʼ���豸�ɹ�,�ܹ�ͨ����'+IntToStr(QNV_DevInfo(0,QNV_DEVINFO_GETCHANNELS)));
            for id:=0 to QNV_DevInfo(0,QNV_DEVINFO_GETCHANNELS)-1 do
              begin
                QNV_Event(id,QNV_EVENT_REGWND,handle,NULL,NULL,0);
              end;
            ShowMsg('��ʼ��ͨ���������');
        end
        else
            ShowMsg('���豸ʧ��');
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
