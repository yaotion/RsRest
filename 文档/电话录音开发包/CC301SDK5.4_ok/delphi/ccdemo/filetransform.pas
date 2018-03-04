unit filetransform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,QNVFILETRANSLib_TLB,brisdklib,brichiperr;

type
  Tfiletransd = class(TForm)
    translist: TListView;
    savetrans: TButton;
    refusetrans: TButton;
    stoptrans: TButton;
    showwin: TButton;
    hidewin: TButton;
    SavetransDialog: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure MyMsgProc(var Msg:TMessage); message BRI_EVENT_MESSAGE;
    procedure AppendTransList(strCC:string;strNick:string;strTransType:string;strState:string;strfilename:string;strlen:string;strFull:string;ltranshandle:longint);
    procedure showwinClick(Sender: TObject);
    procedure hidewinClick(Sender: TObject);
    procedure savetransClick(Sender: TObject);
    procedure refusetransClick(Sender: TObject);
    procedure stoptransClick(Sender: TObject);
    procedure DeleteTransItem(LiteItem: TListItem);
    function  GetHandleItem(lhandle:longint):TListItem;
    function  GetMsgParam(strMsg:string;strParam:string):string;
    procedure InitForm();
    procedure AppendRecvFile(lhandle:longint;strData:string);

  private
    { Private declarations }
  public
    { Public declarations }
    function StartSendFile(destcc:string;strfile:string):longint;
  end;

var
  filetransd: Tfiletransd;

implementation

{$R *.dfm}

procedure Tfiletransd.FormCreate(Sender: TObject);
begin
        translist.Clear();
        translist.Columns.Add;
        translist.Columns.Add;
        translist.Columns.Add;
        translist.Columns.Add;
        translist.Columns.Add;
        translist.Columns.Add;
        translist.Columns.Add;
        translist.Columns.Add;
        translist.Columns.Items[0].Caption:='CC';
        translist.Columns.Items[0].Width := 150;
        translist.Columns.Items[1].Caption:='昵称';
        translist.Columns.Items[1].Width := 150;
        translist.Columns.Items[2].Caption:='传输类型';
        translist.Columns.Items[2].Width := 100;
        translist.Columns.Items[3].Caption:='状态';
        translist.Columns.Items[3].Width := 100;
        translist.Columns.Items[4].Caption:='文件名';
        translist.Columns.Items[4].Width := 100;
        translist.Columns.Items[5].Caption:='长度(字节)';
        translist.Columns.Items[5].Width := 100;
        translist.Columns.Items[6].Caption:='本地路径';
        translist.Columns.Items[6].Width := 100;
        translist.Columns.Items[7].Caption:='句柄KEY';
        translist.Columns.Items[7].Width := 64;
        translist.ViewStyle:=vsreport;
        translist.GridLines:=true;
end;

procedure Tfiletransd.InitForm();
begin
        if QNV_Event(CCCTRL_CHANNELID,QNV_EVENT_REGWND,integer(handle),NULL,NULL,0) <= 0 then
        begin
        MessageBox(handle,'注册窗口失败,可能还未启动CC模块','错误',MB_OK);
        end;
end;

function  Tfiletransd.GetHandleItem(lhandle:longint):TListItem;
var
vfileAtl:Tqnvfiletransfer;
i:longint;
begin
        Result :=nil;
        For i:=0 to translist.Items.Count-1 Do
        begin
          vfileAtl := Tqnvfiletransfer(strtoint(translist.Items[i].SubItems.Strings[6]));
          if vfileAtl.FT_GetSID() = lhandle then
          begin
                Result := translist.Items[i];
                exit;
          end
       end;
end;

procedure Tfiletransd.MyMsgProc(var Msg:TMessage);
var
 pEvent:PTBriEvent_Data;
 ListItem : TListItem;
 vfileAtl:Tqnvfiletransfer;
 lRequestType:longint;
 lRet:longint;
 strValue:string;
begin
 pEvent := PTBriEvent_Data(Msg.LParam);
 case pEvent^.lEventType of
 BriEvent_CC_RecvFileRequest:
 begin
 AppendRecvFile(pEvent^.lEventHandle,pEvent^.szData);
 show();
 end;
 BriEvent_CC_TransFileFinished:
 begin
 ListItem := GetHandleItem(pEvent^.lEventHandle);
 if ListItem <> nil then
 begin
        vfileAtl := Tqnvfiletransfer(strtoint(ListItem.SubItems.Strings[6]));
        lRequestType := vfileAtl.FT_GetRequestType();//获取传输类型/发送/接收
        lRet := vfileAtl.FT_StopFileTrans(0);//停止并返回传输结果
        if lRet = 1 then
        begin
             if lRequestType = 0 then//接收
             begin
		strValue := '接收文件完成 ';
             end
             else//发送
             begin
             	strValue := '发送文件完成 ';
             end;
        end
        else if  lRet <> 2 then//已经停止过的忽略
        begin
        	if ((pEvent^.lResult = TMMERR_CLIENTREFUSE)
                        OR (pEvent^.lResult = TMMERR_CLIENTCANCEL)
                        OR (pEvent^.lResult = TMMERR_CLIENTSTOP)) then
                        begin
                           strValue := '对方停止传输 ';
                        end
		else
                        begin
                        strValue := '您已经停止传输 ';
                        end;
        end;

        DeleteTransItem(ListItem);

        end;
        if strValue <> '' then
        begin
        MessageBox(handle,PChar(strValue),'提示',MB_OK);
        end;        
 end;
 end;//end case
end;

function  Tfiletransd.GetMsgParam(strMsg:string;strParam:string):string;
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

procedure Tfiletransd.AppendRecvFile(lhandle:longint;strData:string);
var
iPos:Integer;
strParamText:string;
strCC:string;
strNick:string;
strFile:string;
lFileSize:integer;
vfileAtl:Tqnvfiletransfer;
begin
        iPos := Pos(MSG_TEXT_SPLIT,strData);
        if iPos > 0 then
        begin
                strParamText := Copy(strData,0,iPos -1);
                strCC := GetMsgParam(strParamText,MSG_KEY_CC);
                strNick := GetMsgParam(strParamText,MSG_KEY_NAME);
      		strFile := GetMsgParam(strParamText,MSG_KEY_FILENAME);//文件名
		lFileSize := strtoint(GetMsgParam(strParamText,MSG_KEY_FILESIZE));//目前版本最大支持文件长度为0x7FFFFFFF字节
                vfileAtl:=Tqnvfiletransfer.Create(filetransd);
                vfileAtl.parent:=filetransd;
                vfileAtl.Visible:=true;
                vfileAtl.ParentWindow:=filetransd.Handle;
                vfileAtl.Left := 170;
                vfileAtl.Top := 320;
                vfileAtl.FT_RecvRequest(strCC,strFile,lFileSize,$30301,0,lhandle);//0x30301 版本标记，不能修改
                AppendTransList(strCC,strNick,'接收','等待保存',strfile,inttostr(lFileSize),'',longint(vfileAtl));
        end
        else
        MessageBox(handle,'文件请求参数异常','错误',MB_OK);
end;

procedure Tfiletransd.AppendTransList(strCC:string;strNick:string;strTransType:string;strState:string;strfilename:string;strlen:string;strFull:string;ltranshandle:longint);
begin
        with translist.items.add do
        begin
        caption:=strCC;
        subitems.add(strNick);
        subitems.add(strTransType);
        subitems.add(strState);
        subitems.add(strfilename);
        subitems.add(strlen);
        subitems.add(strFull);
        subitems.add(inttostr(ltranshandle));
        end;
end;

function Tfiletransd.StartSendFile(destcc:string;strfile:string):longint;
var
lsendhandle:longint;
vfileAtl:Tqnvfiletransfer;
begin
        vfileAtl:=Tqnvfiletransfer.Create(filetransd);
        vfileAtl.parent:=filetransd;
        vfileAtl.Visible:=true;
        vfileAtl.ParentWindow:=filetransd.Handle;
        vfileAtl.Left := 170;
        vfileAtl.Top := 320;
        lsendhandle := vfileAtl.FT_SendRequest(destcc,strfile,$30301,0);//$30301 版本标记，不能修改
 	if lsendhandle = 0 then
        begin
                vfileAtl.Free;
                MessageBox(handle,'发送失败','错误',MB_OK);
        end
        else
        begin
                AppendTransList(destcc,'','发送','准备发送',strfile,'0','',longint(vfileAtl));
        end;
        Result := lsendhandle;
end;

procedure Tfiletransd.showwinClick(Sender: TObject);
var
vfileAtl:Tqnvfiletransfer;
begin
        if translist.Selected <> nil then
        begin
            vfileAtl := Tqnvfiletransfer(strtoint(translist.Selected.SubItems.Strings[6]));
            vfileAtl.Show;
        end
        else
             MessageBox(handle,'请选择记录','警告',MB_OK);
end;

procedure Tfiletransd.hidewinClick(Sender: TObject);
var
vfileAtl:Tqnvfiletransfer;
begin
        if translist.Selected <> nil then
        begin
            vfileAtl := Tqnvfiletransfer(strtoint(translist.Selected.SubItems.Strings[6]));
            vfileAtl.Hide;
        end
        else
            MessageBox(handle,'请选择记录','警告',MB_OK);
end;

procedure Tfiletransd.savetransClick(Sender: TObject);
var
vfileAtl:Tqnvfiletransfer;
begin
        if translist.Selected <> nil then
        begin
      		if ((translist.Selected.SubItems.Strings[1] = '接收')
                        AND (translist.Selected.SubItems.Strings[2] = '等待保存')) then
                    begin
                        if SavetransDialog.Execute then
                        begin
				vfileAtl := Tqnvfiletransfer(strtoint(translist.Selected.SubItems.Strings[6]));
				vfileAtl.FT_ReplyRecvFileRequest(vfileAtl.FT_GetSID(),SavetransDialog.FileName,0,1);
				translist.Selected.SubItems.strings[2] := '已接收';
			end
                     end
                     else
			MessageBox(handle,'该状态不能接收保存','错误',MB_OK);
        end
        else
            MessageBox(handle,'请选择记录','警告',MB_OK);
end;

procedure Tfiletransd.refusetransClick(Sender: TObject);
var
vfileAtl:Tqnvfiletransfer;
begin
        if translist.Selected <> nil then
        begin
             	if ((translist.Selected.SubItems.Strings[1] = '接收')
                        AND (translist.Selected.SubItems.Strings[2] = '等待保存')) then
                    begin
  			vfileAtl := Tqnvfiletransfer(strtoint(translist.Selected.SubItems.Strings[6]));
  			vfileAtl.FT_StopFileTrans(0);
        	    end
                    else
			MessageBox(handle,'该状态不能拒绝接收','错误',MB_OK);
        end
        else
            MessageBox(handle,'请选择记录','警告',MB_OK);
end;

procedure Tfiletransd.stoptransClick(Sender: TObject);
begin
        if translist.Selected <> nil then
        begin
                DeleteTransItem(translist.Selected);
        end
        else
                MessageBox(handle,'请选择记录','警告',MB_OK);
end;

procedure Tfiletransd.DeleteTransItem(LiteItem: TListItem);
var
vfileAtl:Tqnvfiletransfer;
begin
     vfileAtl := Tqnvfiletransfer(strtoint(LiteItem.SubItems.Strings[6]));
     vfileAtl.FT_StopFileTrans(0);
     vfileAtl.FT_ReleaseSource(0);
     vfileAtl.Free;
     LiteItem.Delete;
end;

end.
