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

//��Ϣ�¼�������
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
                   recvstate.Caption :='���ڽ��մ���...';
                 end
        end;
    BriEvent_FaxRecvFinished:
        begin
            QNV_Fax(0,QNV_FAX_STOPRECV,0,NULL);
            recvstate.Caption :='���մ������';
        end;
    BriEvent_FaxRecvFailed,
    BriEvent_Silence,
    BriEvent_Busy,
    BriEvent_RemoteHang:
        begin
            QNV_Fax(0,QNV_FAX_STOPRECV,0,NULL);
            recvstate.Caption :='���մ���ʧ�� eid='+IntToStr(pEvent^.lEventType);
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
   MessageBox(handle,'����ģ��״̬���󣬿����Ѿ��ڴ���������豸���󣬲��ܽ���','����',MB_OK);
   end
 else
   begin
    recvstate.Caption :='��ʼ����...';
    if QNV_Fax(0,QNV_FAX_STARTRECV,0,PChar(faxpath.Text)) > 0 then
        begin
	     if  (QNV_GetDevCtrl(0,QNV_CTRL_PHONE) = 0) OR ((QNV_DevInfo(0,QNV_DEVINFO_GETMODULE) AND DEVMODULE_SWITCH) <> 0)  then
                    begin
	                recvstate.Caption :='���ڽ��մ���...';
                    end
		else
		   begin
			//���û�м̵�����,��ժ��,Ȼ����ʾ�û��һ�,��⵽�һ�����������
			//���������ڼ�⵽�һ�����������һ��ɹ�
			//������ͣ,�ȴ��һ���ָ���ʼ
			QNV_Fax(0,QNV_FAX_PAUSE,0,NULL);
			recvstate.Caption :='׼�����մ���,��һ�...';
                    end
	end
        else
	    recvstate.Caption :='�������մ���ʧ��...';
   end
end;

procedure Trecvfaxform.stoprecvClick(Sender: TObject);
begin
     QNV_Fax(0,QNV_FAX_STOPRECV,0,NULL);
end;

procedure Trecvfaxform.opendoplayClick(Sender: TObject);
begin
     QNV_SetDevCtrl(0,QNV_CTRL_DOPLAY,Integer(opendoplay.Checked));
     QNV_SetDevCtrl(0,QNV_CTRL_PLAYMUX,DOPLAY_CHANNEL0_ADC);//ѡ������·����
end;

procedure Trecvfaxform.browerfileClick(Sender: TObject);
begin
   ShellExecute(handle,'Open','rundll32.exe',PChar('shimgvw.dll,ImageView_Fullscreen '+faxpath.Text),nil,SW_SHOWNORMAl);
end;

end.



