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
        translist.Columns.Items[1].Caption:='�ǳ�';
        translist.Columns.Items[1].Width := 150;
        translist.Columns.Items[2].Caption:='��������';
        translist.Columns.Items[2].Width := 100;
        translist.Columns.Items[3].Caption:='״̬';
        translist.Columns.Items[3].Width := 100;
        translist.Columns.Items[4].Caption:='�ļ���';
        translist.Columns.Items[4].Width := 100;
        translist.Columns.Items[5].Caption:='����(�ֽ�)';
        translist.Columns.Items[5].Width := 100;
        translist.Columns.Items[6].Caption:='����·��';
        translist.Columns.Items[6].Width := 100;
        translist.Columns.Items[7].Caption:='���KEY';
        translist.Columns.Items[7].Width := 64;
        translist.ViewStyle:=vsreport;
        translist.GridLines:=true;
end;

procedure Tfiletransd.InitForm();
begin
        if QNV_Event(CCCTRL_CHANNELID,QNV_EVENT_REGWND,integer(handle),NULL,NULL,0) <= 0 then
        begin
        MessageBox(handle,'ע�ᴰ��ʧ��,���ܻ�δ����CCģ��','����',MB_OK);
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
        lRequestType := vfileAtl.FT_GetRequestType();//��ȡ��������/����/����
        lRet := vfileAtl.FT_StopFileTrans(0);//ֹͣ�����ش�����
        if lRet = 1 then
        begin
             if lRequestType = 0 then//����
             begin
		strValue := '�����ļ���� ';
             end
             else//����
             begin
             	strValue := '�����ļ���� ';
             end;
        end
        else if  lRet <> 2 then//�Ѿ�ֹͣ���ĺ���
        begin
        	if ((pEvent^.lResult = TMMERR_CLIENTREFUSE)
                        OR (pEvent^.lResult = TMMERR_CLIENTCANCEL)
                        OR (pEvent^.lResult = TMMERR_CLIENTSTOP)) then
                        begin
                           strValue := '�Է�ֹͣ���� ';
                        end
		else
                        begin
                        strValue := '���Ѿ�ֹͣ���� ';
                        end;
        end;

        DeleteTransItem(ListItem);

        end;
        if strValue <> '' then
        begin
        MessageBox(handle,PChar(strValue),'��ʾ',MB_OK);
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
      		strFile := GetMsgParam(strParamText,MSG_KEY_FILENAME);//�ļ���
		lFileSize := strtoint(GetMsgParam(strParamText,MSG_KEY_FILESIZE));//Ŀǰ�汾���֧���ļ�����Ϊ0x7FFFFFFF�ֽ�
                vfileAtl:=Tqnvfiletransfer.Create(filetransd);
                vfileAtl.parent:=filetransd;
                vfileAtl.Visible:=true;
                vfileAtl.ParentWindow:=filetransd.Handle;
                vfileAtl.Left := 170;
                vfileAtl.Top := 320;
                vfileAtl.FT_RecvRequest(strCC,strFile,lFileSize,$30301,0,lhandle);//0x30301 �汾��ǣ������޸�
                AppendTransList(strCC,strNick,'����','�ȴ�����',strfile,inttostr(lFileSize),'',longint(vfileAtl));
        end
        else
        MessageBox(handle,'�ļ���������쳣','����',MB_OK);
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
        lsendhandle := vfileAtl.FT_SendRequest(destcc,strfile,$30301,0);//$30301 �汾��ǣ������޸�
 	if lsendhandle = 0 then
        begin
                vfileAtl.Free;
                MessageBox(handle,'����ʧ��','����',MB_OK);
        end
        else
        begin
                AppendTransList(destcc,'','����','׼������',strfile,'0','',longint(vfileAtl));
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
             MessageBox(handle,'��ѡ���¼','����',MB_OK);
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
            MessageBox(handle,'��ѡ���¼','����',MB_OK);
end;

procedure Tfiletransd.savetransClick(Sender: TObject);
var
vfileAtl:Tqnvfiletransfer;
begin
        if translist.Selected <> nil then
        begin
      		if ((translist.Selected.SubItems.Strings[1] = '����')
                        AND (translist.Selected.SubItems.Strings[2] = '�ȴ�����')) then
                    begin
                        if SavetransDialog.Execute then
                        begin
				vfileAtl := Tqnvfiletransfer(strtoint(translist.Selected.SubItems.Strings[6]));
				vfileAtl.FT_ReplyRecvFileRequest(vfileAtl.FT_GetSID(),SavetransDialog.FileName,0,1);
				translist.Selected.SubItems.strings[2] := '�ѽ���';
			end
                     end
                     else
			MessageBox(handle,'��״̬���ܽ��ձ���','����',MB_OK);
        end
        else
            MessageBox(handle,'��ѡ���¼','����',MB_OK);
end;

procedure Tfiletransd.refusetransClick(Sender: TObject);
var
vfileAtl:Tqnvfiletransfer;
begin
        if translist.Selected <> nil then
        begin
             	if ((translist.Selected.SubItems.Strings[1] = '����')
                        AND (translist.Selected.SubItems.Strings[2] = '�ȴ�����')) then
                    begin
  			vfileAtl := Tqnvfiletransfer(strtoint(translist.Selected.SubItems.Strings[6]));
  			vfileAtl.FT_StopFileTrans(0);
        	    end
                    else
			MessageBox(handle,'��״̬���ܾܾ�����','����',MB_OK);
        end
        else
            MessageBox(handle,'��ѡ���¼','����',MB_OK);
end;

procedure Tfiletransd.stoptransClick(Sender: TObject);
begin
        if translist.Selected <> nil then
        begin
                DeleteTransItem(translist.Selected);
        end
        else
                MessageBox(handle,'��ѡ���¼','����',MB_OK);
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
