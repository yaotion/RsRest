unit recvfax;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,brisdklib,ShellApi;

type
  Trecvfaxform = class(TForm)
    recvpath: TLabel;
    faxpath: TEdit;
    opendoplay: TCheckBox;
    closerecvfax: TButton;
    startrecv: TButton;
    recvstate: TLabel;
    stoprecv: TButton;
    browerfile: TButton;
    procedure FormCreate(Sender: TObject);
    procedure MyMsgProc(var Msg:TMessage); message BRI_EVENT_MESSAGE;
    procedure closerecvfaxClick(Sender: TObject);
    procedure startrecvClick(Sender: TObject);
    procedure stoprecvClick(Sender: TObject);
    procedure opendoplayClick(Sender: TObject);
    procedure browerfileClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  recvfaxform: Trecvfaxform;

implementation

{$R *.dfm}


procedure Trecvfaxform.FormCreate(Sender: TObject);
begin
        QNV_Fax(0,QNV_FAX_LOAD,0,NULL);
        QNV_Event(0,QNV_EVENT_REGWND,handle,NULL,NULL,0);
end;

//消息事件处理器
procedure Trecvfaxform.MyMsgProc(var Msg:TMessage);
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
                   recvstate.Caption :='正在接收传真...';
                 end
        end;
    BriEvent_FaxRecvFinished:
        begin
            QNV_Fax(0,QNV_FAX_STOPRECV,0,NULL);
            recvstate.Caption :='接收传真完成';
        end;
    BriEvent_FaxRecvFailed,
    BriEvent_Silence,
    BriEvent_Busy,
    BriEvent_RemoteHang:
        begin
            QNV_Fax(0,QNV_FAX_STOPRECV,0,NULL);
            recvstate.Caption :='接收传真失败 eid='+IntToStr(pEvent^.lEventType);
        end;
 end;
end;

procedure Trecvfaxform.closerecvfaxClick(Sender: TObject);
begin
close();
end;

procedure Trecvfaxform.startrecvClick(Sender: TObject);
var
id:integer;
begin
 if QNV_Fax(0,QNV_FAX_TYPE,0,NULL) <> FAX_TYPE_NULL then
   begin
   MessageBox(handle,'传真模块状态错误，可能已经在处理传真或者设备错误，不能接收','警告',MB_OK);
   end
 else
   begin
    recvstate.Caption :='开始接收...';
    if QNV_Fax(0,QNV_FAX_STARTRECV,0,PChar(faxpath.Text)) > 0 then
        begin
	     if  (QNV_GetDevCtrl(0,QNV_CTRL_PHONE) = 0) OR ((QNV_DevInfo(0,QNV_DEVINFO_GETMODULE) AND DEVMODULE_SWITCH) <> 0)  then
                    begin
	                recvstate.Caption :='正在接收传真...';
                    end
		else
		   begin
			//如果没有继电器的,软摘机,然后提示用户挂机,检测到挂机后启动传真
			//这样主窗口检测到挂机后不能让它软挂机成功
			//立即暂停,等待挂机后恢复开始
			QNV_Fax(0,QNV_FAX_PAUSE,0,NULL);
			recvstate.Caption :='准备接收传真,请挂机...';
                    end
	end
        else
	    recvstate.Caption :='启动接收传真失败...';
   end
end;

procedure Trecvfaxform.stoprecvClick(Sender: TObject);
begin
     QNV_Fax(0,QNV_FAX_STOPRECV,0,NULL);
end;

procedure Trecvfaxform.opendoplayClick(Sender: TObject);
begin
     QNV_SetDevCtrl(0,QNV_CTRL_DOPLAY,Integer(opendoplay.Checked));
     QNV_SetDevCtrl(0,QNV_CTRL_PLAYMUX,DOPLAY_CHANNEL0_ADC);//选择听线路声音
end;

procedure Trecvfaxform.browerfileClick(Sender: TObject);
begin
   ShellExecute(handle,'Open','rundll32.exe',PChar('shimgvw.dll,ImageView_Fullscreen '+faxpath.Text),nil,SW_SHOWNORMAl);
end;

end.



