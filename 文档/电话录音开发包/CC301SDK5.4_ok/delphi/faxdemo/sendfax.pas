unit sendfax;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,brisdklib,shellapi;

type
  Tsendfaxform = class(TForm)
    sendpath: TLabel;
    faxpath: TEdit;
    closesendfax: TButton;
    opendoplay: TCheckBox;
    selectfile: TButton;
    browerfile: TButton;
    selectsendfile: TOpenDialog;
    startsend: TButton;
    stopsend: TButton;
    sendstate: TLabel;
    channelid: TLabel;
    channellist: TComboBox;
    procedure closesendfaxClick(Sender: TObject);
    procedure browerfileClick(Sender: TObject);
    procedure opendoplayClick(Sender: TObject);
    procedure selectfileClick(Sender: TObject);
    procedure startsendClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MyMsgProc(var Msg:TMessage); message BRI_EVENT_MESSAGE;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  sendfaxform: Tsendfaxform;

implementation

{$R *.dfm}

procedure Tsendfaxform.closesendfaxClick(Sender: TObject);
begin
close();
end;

procedure Tsendfaxform.browerfileClick(Sender: TObject);
begin
        ShellExecute(handle,'Open','rundll32.exe',PChar('shimgvw.dll,ImageView_Fullscreen '+faxpath.Text),nil,SW_SHOWNORMAl);
end;

procedure Tsendfaxform.opendoplayClick(Sender: TObject);
begin
        QNV_SetDevCtrl(0,QNV_CTRL_DOPLAY,Integer(opendoplay.Checked));
        QNV_SetDevCtrl(0,QNV_CTRL_PLAYMUX,DOPLAY_CHANNEL0_ADC);//选择听线路声音
end;

procedure Tsendfaxform.selectfileClick(Sender: TObject);
begin
        if selectsendfile.Execute() then begin
        faxpath.Text := selectsendfile.FileName;
        end
end;

procedure Tsendfaxform.startsendClick(Sender: TObject);
begin
        if faxpath.Text  = '' then
        begin
                MessageBox(handle,'文件不能为空','警告',MB_OK);
        end
        else
                if QNV_Fax(0,QNV_FAX_TYPE,0,NULL) <> FAX_TYPE_NULL then
                begin
                        MessageBox(handle,'已经在处理传真，不能发送','警告',MB_OK);
                end
                else
                begin
                        sendstate.Caption :='开始发送...';
                        if QNV_Fax(0,QNV_FAX_STARTSEND,0,PChar(faxpath.Text)) > 0 then
                        begin
	                        if (QNV_GetDevCtrl(0,QNV_CTRL_PHONE) = 0) OR ((QNV_DevInfo(0,QNV_DEVINFO_GETMODULE) AND DEVMODULE_SWITCH) <> 0)  then
                                begin
                                   sendstate.Caption :='正在发送传真...';
                                end
		                else
		                begin
			        //如果没有继电器的,软摘机,然后提示用户挂机,检测到挂机后启动传真
			        //这样主窗口检测到挂机后不能让它软挂机成功
			        //立即暂停,等待挂机后恢复开始
			        QNV_Fax(0,QNV_FAX_PAUSE,0,NULL);
			        sendstate.Caption :='准备发送传真,请挂机...';
                                end
	                end
                else
	                sendstate.Caption :='启动发送传真失败...';
                end
end;

procedure Tsendfaxform.FormCreate(Sender: TObject);
var
id:integer;
begin
        QNV_Fax(0,QNV_FAX_LOAD,0,NULL);
        for id:=0 to QNV_DevInfo(0,QNV_DEVINFO_GETCHANNELS)-1 do
         begin
              channellist.Items.Add('通道'+inttostr(id+1));
              QNV_Event(id,QNV_EVENT_REGWND,handle,NULL,NULL,0);
          end;
        if channellist.Items.Count > 0 then begin
           channellist.ItemIndex := 0;
        end;
end;

//消息事件处理器
procedure Tsendfaxform.MyMsgProc(var Msg:TMessage);
var
 pEvent:PTBriEvent_Data;
begin
 pEvent := PTBriEvent_Data(Msg.LParam);
 case pEvent^.lEventType of
   BriEvent_PhoneHang:
        begin
           if QNV_Fax(0,QNV_FAX_ISPAUSE,0,NULL) <> 0 then
                begin
                   QNV_Fax(0,QNV_FAX_RESUME,0,NULL);
                   sendstate.Caption :='正在发送传真...';
                 end
        end;
    BriEvent_FaxSendFinished:
        begin
            QNV_Fax(0,QNV_FAX_STOPSEND,0,NULL);
            sendstate.Caption :='发送传真完成';
        end;
    BriEvent_FaxSendFailed,
    BriEvent_Busy,
    BriEvent_RemoteHang:
        begin
            sendstate.Caption :='发送传真失败 eid='+IntToStr(pEvent^.lEventType);
        end;
 end;
end;

end.
