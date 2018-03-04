unit callform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,brisdklib;

type
  Tcccalld = class(TForm)
    calllist: TListView;
    answer: TButton;
    refuse: TButton;
    replybusy: TButton;
    stop: TButton;
    procedure FormCreate(Sender: TObject);
    function  GetMsgParam(strMsg:string;strParam:string):string;
    procedure MyMsgProc(var Msg:TMessage); message BRI_EVENT_MESSAGE;
    procedure AppendCallIn(lcallhandle:longint;strData:string);
    procedure AppendCallList(strCC:string;strNick:string;strCallType:string;strState:string;lcallhandle:longint);
    procedure answerClick(Sender: TObject);
    procedure refuseClick(Sender: TObject);
    procedure replybusyClick(Sender: TObject);
    procedure stopClick(Sender: TObject);
    procedure InitForm();
    function  GetHandleItem(lcallhandle:longint):longint;
  private
    { Private declarations }
  public
    { Public declarations }
    function  CallCC(strCC:string):longint;
  end;

var
  cccalld: Tcccalld;

implementation

{$R *.dfm}

procedure Tcccalld.FormCreate(Sender: TObject);
begin
        calllist.Clear();
        calllist.Columns.Add;
        calllist.Columns.Add;
        calllist.Columns.Add;
        calllist.Columns.Add;
        calllist.Columns.Add;
        calllist.Columns.Items[0].Caption:='CC';
        calllist.Columns.Items[0].Width := 150;
        calllist.Columns.Items[1].Caption:='êÇ³Æ';
        calllist.Columns.Items[1].Width := 150;
        calllist.Columns.Items[2].Caption:='ºô½ÐÀàÐÍ';
        calllist.Columns.Items[2].Width := 100;
        calllist.Columns.Items[3].Caption:='×´Ì¬';
        calllist.Columns.Items[3].Width := 100;
        calllist.Columns.Items[4].Caption:='¾ä±úKEY';
        calllist.Columns.Items[4].Width := 64;
        calllist.ViewStyle:=vsreport;
        calllist.GridLines:=true;
end;

procedure Tcccalld.InitForm();
begin
        if QNV_Event(CCCTRL_CHANNELID,QNV_EVENT_REGWND,integer(handle),NULL,NULL,0) <= 0 then
        begin
        MessageBox(handle,'×¢²á´°¿ÚÊ§°Ü,¿ÉÄÜ»¹Î´Æô¶¯CCÄ£¿é','´íÎó',MB_OK);
        end;
end;

function  Tcccalld.CallCC(strCC:string):longint;
var
lcallhandle : longint;
begin
	lcallhandle := QNV_CCCtrl_Call(QNV_CCCTRL_CALL_START,0,PChar(strCC),-1);
	if lcallhandle = 0 then
        begin
                MessageBox(handle,'ºô½ÐÊ§°Ü','´íÎó',MB_OK);
        end
        else
		AppendCallList(strCC,'','È¥µç','¿ªÊ¼ºô³ö',lcallhandle);

        Result := lcallhandle;        
end;

function  Tcccalld.GetMsgParam(strMsg:string;strParam:string):string;
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

procedure Tcccalld.AppendCallList(strCC:string;strNick:string;strCallType:string;strState:string;lcallhandle:longint);
begin
        with calllist.items.add do
        begin
        caption:=strCC;
        subitems.add(strNick);
        subitems.add(strCallType);
        subitems.add(strState);
        subitems.add(inttostr(lcallhandle));
        end;
end;

function  Tcccalld.GetHandleItem(lcallhandle:longint):longint;
var
i : integer;
begin
        Result := -1;
        For i:=0 to calllist.Items.Count-1 Do
        begin
        if strtoint(calllist.Items.Item[i].SubItems.Strings[3]) = lcallhandle then
         begin
                Result := i;
                exit;
         end;
        end;

end;

procedure Tcccalld.AppendCallIn(lcallhandle:longint;strData:string);
var
iPos:Integer;
strParamText:string;
strCC:string;
strNick:string;
begin
        iPos := Pos(MSG_TEXT_SPLIT,strData);
        if iPos > 0 then
        begin
                strParamText := Copy(strData,0,iPos -1);
                strCC := GetMsgParam(strParamText,MSG_KEY_CC);
                strNick := GetMsgParam(strParamText,MSG_KEY_NAME);
                AppendCallList(strCC,strNick,'À´µç','ÕýÔÚºôÈë',lcallhandle);
        end
        else
        MessageBox(handle,'²ÎÊý´íÎó','´íÎó',MB_OK);
end;

procedure Tcccalld.MyMsgProc(var Msg:TMessage);
var
 pEvent:PTBriEvent_Data;
 lItem : longint;
begin
 pEvent := PTBriEvent_Data(Msg.LParam);
 case pEvent^.lEventType of
        BriEvent_CC_CallIn:
        begin
        AppendCallIn(pEvent^.lEventHandle,pEvent^.szData);
        Show();
        end;
        BriEvent_CC_CallOutSuccess:
        begin
        lItem := GetHandleItem(pEvent^.lEventHandle);
        if   lItem >= 0 then
                begin
                        calllist.Items.Item[lItem].SubItems.Strings[2] := 'ÒÑºô³ö';
                end;
        end;
        BriEvent_CC_CallOutFailed:
        begin
        lItem := GetHandleItem(pEvent^.lEventHandle);
        if   lItem >= 0 then
                begin
                        calllist.Items.Item[lItem].Delete();
                end;
        end;
        BriEvent_CC_Connected:
        begin
        lItem := GetHandleItem(pEvent^.lEventHandle);
        if   lItem >= 0 then
                begin
                        calllist.Items.Item[lItem].SubItems.Strings[2] := 'ÒÑ½ÓÍ¨';
                end;
        end;
        BriEvent_CC_CallFinished:
        begin
        lItem := GetHandleItem(pEvent^.lEventHandle);
        if   lItem >= 0 then
                begin
                        calllist.Items.Item[lItem].Delete();
                end;
        end;
  end;//end case
end;

procedure Tcccalld.answerClick(Sender: TObject);
var
lcallhandle:longint;
begin
        if calllist.Selected <> nil then
        begin
        lcallhandle := strtoint(calllist.Selected.SubItems.Strings[3]);
	if QNV_CCCtrl_Call(QNV_CCCTRL_CALL_ACCEPT,lcallhandle,NULL,-1) <= 0 then
        begin
                MessageBox(handle,'½ÓÌýÊ§°Ü','´íÎó',MB_OK);
        end;
        end
        else
                MessageBox(handle,'ÇëÑ¡Ôñ¼ÇÂ¼','¾¯¸æ',MB_OK);

end;

procedure Tcccalld.refuseClick(Sender: TObject);
var
lcallhandle:longint;
begin
        if calllist.Selected <> nil then
        begin
        lcallhandle := strtoint(calllist.Selected.SubItems.Strings[3]);
	if QNV_CCCtrl_Call(QNV_CCCTRL_CALL_REFUSE,lcallhandle,NULL,-1) <= 0 then
        begin
                MessageBox(handle,'¾Ü½ÓÊ§°Ü','´íÎó',MB_OK);
        end;
        end
        else
                MessageBox(handle,'ÇëÑ¡Ôñ¼ÇÂ¼','¾¯¸æ',MB_OK);
end;

procedure Tcccalld.replybusyClick(Sender: TObject);
var
lcallhandle:longint;
begin
       if calllist.Selected <> nil then
        begin
        lcallhandle := strtoint(calllist.Selected.SubItems.Strings[3]);
	if QNV_CCCtrl_Call(QNV_CCCTRL_CALL_BUSY,lcallhandle,NULL,-1) <= 0 then
        begin
                MessageBox(handle,'»Ø¸´Ã¦Ê§°Ü','´íÎó',MB_OK);
        end;
        end
        else
                MessageBox(handle,'ÇëÑ¡Ôñ¼ÇÂ¼','¾¯¸æ',MB_OK);
end;

procedure Tcccalld.stopClick(Sender: TObject);
var
lcallhandle:longint;
begin
      if calllist.Selected <> nil then
        begin
        lcallhandle := strtoint(calllist.Selected.SubItems.Strings[3]);
	if QNV_CCCtrl_Call(QNV_CCCTRL_CALL_STOP,lcallhandle,NULL,-1) <= 0 then
        begin
                MessageBox(handle,'Í£Ö¹Ê§°Ü','´íÎó',MB_OK);
        end;
        end
        else
                MessageBox(handle,'ÇëÑ¡Ôñ¼ÇÂ¼','¾¯¸æ',MB_OK);
end;

end.
