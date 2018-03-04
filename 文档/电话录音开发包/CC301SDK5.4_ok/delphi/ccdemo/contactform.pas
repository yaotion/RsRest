unit contactform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,brisdklib;

type
  Tcccontactd = class(TForm)
    Label1: TLabel;
    CCCode: TEdit;
    add: TButton;
    del: TButton;
    closeform: TButton;
    procedure addClick(Sender: TObject);
    procedure delClick(Sender: TObject);
    function  GetMsgParam(strMsg:string;strParam:string):string;
    procedure MyMsgProc(var Msg:TMessage); message BRI_EVENT_MESSAGE;
    procedure closeformClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  cccontactd: Tcccontactd;

implementation

{$R *.dfm}

function  Tcccontactd.GetMsgParam(strMsg:string;strParam:string):string;
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

procedure Tcccontactd.MyMsgProc(var Msg:TMessage);
var
 pEvent:PTBriEvent_Data;
 strValue:string;
 iPos:Integer;
 strParam:string;
 strMsgText:string;
 strCC:string;
 strMsg:string;
begin
 pEvent := PTBriEvent_Data(Msg.LParam);
 case pEvent^.lEventType of
        BriEvent_CC_AddContactSuccess:
        begin
        MessageBox(handle,'添加好友成功','提示',MB_OK);
        end;
        BriEvent_CC_AddContactFailed:
        begin
        MessageBox(handle,'添加好友失败','提示',MB_OK);
        end;
        BriEvent_CC_InviteContact:
        begin
        strMsg := pEvent^.szData;
        iPos := Pos(MSG_TEXT_SPLIT,strMsg);
        if iPos > 0 then
        begin
        strParam := Copy(strMsg,0,iPos -1);
        strMsgText := Copy(strMsg,iPos+4-1,length(strMsg) - iPos - 4+1);
        strCC := GetMsgParam(strParam,MSG_KEY_CC);
        strValue := '接收到增加好友的邀请 是否接受? \r\n cc:'+strCC+' \r\n提示:'+strMsgText;
        if MessageBox(Handle,PChar(strValue),'提示',MB_OK or MB_YESNO) = IDYES then
        begin
        QNV_CCCtrl_Contact(QNV_CCCTRL_CONTACT_ACCEPT,PChar(strCC),'同意');
        end
        else
        QNV_CCCtrl_Contact(QNV_CCCTRL_CONTACT_REFUSE,PChar(strCC),'拒绝');
        end;

        end;
        BriEvent_CC_ReplyAcceptContact:
        begin
        strMsg := pEvent^.szData;
        iPos := Pos(MSG_TEXT_SPLIT,strMsg);
        if iPos > 0 then
        begin
        strParam := Copy(strMsg,0,iPos -1);
        strMsgText := Copy(strMsg,iPos+4-1,length(strMsg) - iPos - 4+1);
        strCC := GetMsgParam(strParam,MSG_KEY_CC);
        strValue := strCC+' 同意好友邀请';
        MessageBox(Handle,PChar(strValue),'提示',MB_OK);
        end;

        end;
        BriEvent_CC_ReplyRefuseContact:
        begin
        strMsg := pEvent^.szData;
        iPos := Pos(MSG_TEXT_SPLIT,strMsg);
        if iPos > 0 then
        begin
        strParam := Copy(strMsg,0,iPos -1);
        strMsgText := Copy(strMsg,iPos+4-1,length(strMsg) - iPos - 4+1);
        strCC := GetMsgParam(strParam,MSG_KEY_CC);
        strValue := strCC+' 拒绝好友邀请';
        MessageBox(Handle,PChar(strValue),'提示',MB_OK);
        end;

        end;
        BriEvent_CC_AcceptContactSuccess:
        begin
        MessageBox(handle,'接受好友成功','提示',MB_OK);
        end;
        BriEvent_CC_AcceptContactFailed:
        begin
        MessageBox(handle,'接受好友失败','提示',MB_OK);
        end;
        BriEvent_CC_RefuseContactSuccess:
        begin
        MessageBox(handle,'拒绝好友成功','提示',MB_OK);
        end;
        BriEvent_CC_RefuseContactFailed:
        begin
        MessageBox(handle,'拒绝好友失败','提示',MB_OK);
        end;
        BriEvent_CC_DeleteContactSuccess:
        begin
        MessageBox(handle,'删除好友成功','提示',MB_OK);
        end;
        BriEvent_CC_DeleteContactFailed:
        begin
        MessageBox(handle,'接受好友失败','提示',MB_OK);
        end;
  end;//end case
end;


procedure Tcccontactd.addClick(Sender: TObject);
begin
	if QNV_CCCtrl_Contact(QNV_CCCTRL_CONTACT_ADD,PChar(CCCode),'请求加为好友') <= 0 then
        begin
		MessageBox(handle,'添加好友失败','提示',MB_OK);
        end;
end;

procedure Tcccontactd.delClick(Sender: TObject);
begin
	if QNV_CCCtrl_Contact(QNV_CCCTRL_CONTACT_DELETE,PChar(CCCode),'请求加为好友') <= 0 then
        begin
		MessageBox(handle,'添加好友失败','提示',MB_OK);
        end;
end;

procedure Tcccontactd.closeformClick(Sender: TObject);
begin
close();
end;

end.
