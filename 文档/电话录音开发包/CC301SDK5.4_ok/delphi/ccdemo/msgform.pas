unit msgform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,brisdklib;

type
  Tccmsgd = class(TForm)
    sendmsg: TEdit;
    sendmsgbtn: TButton;
    Label1: TLabel;
    Label2: TLabel;
    destcc: TEdit;
    recvmsg: TMemo;
    procedure MyMsgProc(var Msg:TMessage); message BRI_EVENT_MESSAGE;
    procedure AppendRecvMsg(strMsg:string;tp:Integer;cid:Integer);
    procedure InitForm();
    function  GetMsgParam(strMsg:string;strParam:string):string;
    procedure AppendRecvView(strCC:string;strNick:string;strMsg:string;ttime:TDateTime);
    procedure sendmsgbtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ccmsgd: Tccmsgd;

  icid:Integer;
  imtype:Integer;
implementation

{$R *.dfm}

procedure Tccmsgd.InitForm();
begin
        icid:=0;
        imtype:=0;
        if QNV_Event(CCCTRL_CHANNELID,QNV_EVENT_REGWND,integer(handle),NULL,NULL,0) <= 0 then
        begin
        MessageBox(handle,'ע�ᴰ��ʧ��,���ܻ�δ����CCģ��','����',MB_OK);
        end;
end;

function  Tccmsgd.GetMsgParam(strMsg:string;strParam:string):string;
var
iPos:Integer;
iEndPos:Integer;
strTemp:string;
begin
     iPos := Pos(strParam,strMsg);
     if iPos <> 0 then
     begin
     strTemp := Copy(strMsg,iPos+length(strParam),length(strMsg) - iPos - length(strParam));
     iEndPos := Pos(MSG_KEY_SPLIT,strTemp);
     if iEndPos <> 0 then
        begin
        strTemp := Copy(strTemp,0,iEndPos - 1);
        end;
        Result := strTemp;
     end
     else
     Result := '';
end;

procedure Tccmsgd.AppendRecvMsg(strMsg:string;tp:Integer;cid:Integer);
var
iPos:Integer;
strParam:string;
strMsgText:string;
strCC:string;
strNick:string;
dtime:TDatetime;
v :double;
begin
        iPos := Pos(MSG_TEXT_SPLIT,strMsg);
        if iPos > 0 then
        begin
        strParam := Copy(strMsg,0,iPos -1);
        strMsgText := Copy(strMsg,iPos+4-1,length(strMsg) - iPos - 4+1);
        strCC := GetMsgParam(strParam,MSG_KEY_CC);
        icid:=strtoint(GetMsgParam(strParam,MSG_KEY_CID));
        imtype:=strtoint(GetMsgParam(strParam,MSG_KEY_IMTYPE));
        strNick := GetMsgParam(strParam,MSG_KEY_NAME);
        v :=double(encodedate(1970,1,1)) + (60*60*8 + strtoint(GetMsgParam(strParam,MSG_KEY_TIME)) )/86400;//8����
        dtime := TDatetime(v);
        AppendRecvView(strCC,strNick,strMsgText,dtime);
        destcc.Text := strCC;
        end  
        else
        begin
        MessageBox(handle,'�����쳣','����',MB_OK);
        end;
end;

procedure Tccmsgd.AppendRecvView(strCC:string;strNick:string;strMsg:string;ttime:TDateTime);
var
strInfo:string;
systemTime:TSystemTime;
begin
        DateTimeToSystemTime(ttime,systemTime);
        strInfo := strCC+' ['+strNick+']  ' + inttostr(systemTime.wYear)+'/'+inttostr(systemTime.wMonth)+'/'+inttostr(systemTime.wDay) +' ' + inttostr(systemTime.wHour)+':'+inttostr(systemTime.wMinute)+':'+inttostr(systemTime.wSecond);
        recvmsg.Lines.Add(strInfo);
        recvmsg.Lines.Add('  '+strMsg);
end;

procedure Tccmsgd.MyMsgProc(var Msg:TMessage);
var
 pEvent:PTBriEvent_Data;
begin
 pEvent := PTBriEvent_Data(Msg.LParam);
 case pEvent^.lEventType of
        BriEvent_CC_RecvedMsg:
        begin
        AppendRecvMsg(pEvent^.szData,0,0);
        Show();
        end;
  end;//end case
end;

procedure Tccmsgd.sendmsgbtnClick(Sender: TObject);
var
szOwnerCC:string;
szNick:string;
iRet:Integer;
begin
 if destcc.Text = '' then
 begin
 MessageBox(handle,'Ŀ��CC����Ϊ��','����',MB_OK);
 end
 else if sendmsg.text = '' then
 begin
 MessageBox(handle,'���͵���Ϣ���ݲ���Ϊ��','����',MB_OK);
 end
 else
 begin
        if imtype = 705 then //705->��ʾ����web��Ϣ
        begin
                iRet := QNV_CCCtrl_Msg(QNV_CCCTRL_MSG_REPLYWEBIM,PChar(destcc.Text),PChar(sendmsg.text),NULL,icid);//�ظ�801��Ϣ
        end
        else
        begin
                iRet := QNV_CCCtrl_Msg(QNV_CCCTRL_MSG_SENDMSG,PChar(destcc.Text),PChar(sendmsg.text),NULL,0);
        end;

 	if iRet <= 0 then
        begin
	      MessageBox(handle,'������Ϣʧ��','����',MB_OK);
        end
        else
	begin
                SetLength(szOwnerCC,32);//����ռ�
                SetLength(szNick,64);//����ռ�
      		QNV_CCCtrl_CCInfo(QNV_CCCTRL_CCINFO_OWNERCC,'',PChar(szOwnerCC),32);//����CC
		QNV_CCCtrl_CCInfo(QNV_CCCTRL_CCINFO_NICK,PChar(szOwnerCC),PChar(szNick),64);//�����ǳ�,����ʹ��szCC����Ϊ��QNV_CCCtrl_CCInfo(QNV_CCCTRL_CONTACTINFO_NICK,NULL,szNick,64);
                SetLength(szOwnerCC,StrLen(PChar(szOwnerCC)));//ɾ����������
                SetLength(szNick,StrLen(PChar(szNick)));//ɾ����������
		AppendRecvView(szOwnerCC,szNick,sendmsg.text,Now);
		sendmsg.text := '';
	end;
 end;

end;

end.
