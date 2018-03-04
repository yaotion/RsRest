unit uProgressCommFun;

interface
uses
  Classes,Windows,ShellAPI,Tlhelp32,SysUtils,Messages;
type

  //////////////////////////////////////////////////////////////////////////////
  ///����: RExeInfo
  ///����: exe���������Ϣ
  //////////////////////////////////////////////////////////////////////////////
  RExeInfo = record
    //����·��
    strFilePath:string;
    //��������
    strProName:string;
    //������������
    strClassName:string;
    //�����ڱ���
    strCaption:string;
    //�����ھ��
    Handle:THandle;
  end;

  TProgressCommFun = class
    {����:�жϽ����Ƿ����}
    class function bProgressExist(strProgressName:string;out strMsg:string):Boolean;
    {����:��������}
    class function OpenExe(strExeFilePath:string;strProgressName:string;out strMsg:string):Boolean;
    {����:���Ҵ���}
    class function FindWind(strClassName,strCaption:string):THandle;
    {����:���̼䷢���ַ�����Ϣ}
    class function SendMsg(msgWnd:THandle;nMsgID:Integer;nData:Integer;strData:string;out strMsg:string):Integer;
    {����:���̼䷢���ַ�����Ϣ post}
    class function PostMsg(msgWnd:THandle;nMsgID:Integer;nData:Integer;strData:string;out strMsg:string): Boolean; deprecated;
    {����:���̼�����ַ�����Ϣ}
    class procedure RecvMsg(var AMsg: TWmCopyData;out nMsgID:Integer;out nData:Integer;out strData:string);

  end;

implementation

{ TProgressCommFun }

class function TProgressCommFun.bProgressExist(strProgressName: string;
  out strMsg: string): Boolean;
var
  nHandle : hwnd;//���
  fprocessentry32 : TProcessEntry32; //�ṹ���͵ı���
  bProgressExist : Boolean;   //����һ������ֵ�������ж��Ƿ��ҵ�������Ϣ��
  processid : dword; //�����ҵ��Ľ���ID
  strName : string; //�����ҵ��Ľ������� end;
begin
  Result := False;
  strMsg := '����:' + strProgressName + 'δ����';
  nHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);   //��ý��̿��վ��
  fprocessentry32.dwSize := sizeof(fprocessentry32); //��TProcessEntry32�ṹ�ĵ�һ��������ֵ��Ҳ�������Ϊ������ṹ�ĵ�һ��������ʼ����
  bProgressExist := Process32First(nHandle,fprocessentry32); //ʹ�� Process32First����ȡ�õ�һ�����̵���Ϣ
  while bProgressExist = true do //��� Process32First����ִ�гɹ�Ҳ����˵�ҵ������б���ĵ�һ������ʱ��ʼѭ��
  begin
    bProgressExist := Process32Next(nHandle,FprocessEntry32); //ȡ�õ���һ��������Ϣ
    strName := fprocessentry32.szExeFile; //ȡ��һ�����̵�����
    if strName = strProgressName then //�����������������ַ���
    begin
      Result := True;
      Exit;
    end;
  end;
end;

class function TProgressCommFun.FindWind(strClassName, strCaption: string): THandle;
begin
  result := 0;
  Result := FindWindow(PAnsiChar(AnsiString(strClassName)) ,PAnsiChar(AnsiString(strCaption)));
end;

class function TProgressCommFun.OpenExe(strExeFilePath: string; strProgressName:string;
  out strMsg: string): Boolean;
var
  nResult:Integer;
  strDirectory:string;
begin
  result := False;
  if SysUtils.FileExists(strExeFilePath) = False then
  begin
    strMsg :='δ�ҵ��ļ�:' + strExeFilePath;
    Exit;
  end;
  strDirectory := ExtractFilePath(strExeFilePath);
  if bProgressExist(strProgressName,strMsg) = True then
  begin
    result := True;
    Exit;
  end;
  nResult := ShellExecute(GetDesktopWindow,'open', PAnsiChar(AnsiString(strExeFilePath)),'',
        PAnsiChar(AnsiString(strDirectory)),SW_SHOWNORMAL);
  if nResult <= 32 then
  begin
    strMsg := '����:' + strProgressName + ' ����ʧ��!';
    Exit;
  end;
  result := True;
end;

class function TProgressCommFun.PostMsg(msgWnd: THandle; nMsgID, nData: Integer;
  strData: string; out strMsg: string): Boolean;
var
  sData: TCopyDataStruct;
begin
  result := False;
  if Windows.IsWindow(msgWnd) = False then
  begin
    strMsg := '��Ч�Ĵ��ھ��';
    Exit;
  end;
  sData.dwData :=nData;
  sData.cbData := Length(strData) + 1;
  //Ϊ���ݵ����ݷ����ڴ�
  GetMem(sData.lpData,sData.cbData );
  try
    StrCopy(sData.lpData,PChar(strData));
    //����WM_COPYDATA��Ϣ
    result := PostMessage(msgWnd,WM_COPYDATA,nMsgID,Cardinal(@sData));
  finally
    FreeMem(sData.lpData); //�ͷ���Դ
  end;
end;

class procedure TProgressCommFun.RecvMsg(var AMsg: TWmCopyData;out nMsgID:Integer;
  out nData:Integer;out strData:string);
begin
  strData := StrPas(AMsg.CopyDataStruct^.lpData);
  nMsgID := AMsg.From;
  nData := AMsg.CopyDataStruct.dwData;
end;

class function TProgressCommFun.SendMsg(msgWnd:THandle;nMsgID:Integer;nData:Integer;strData:string;out strMsg:string): Integer;
var
  sData: TCopyDataStruct;
begin
  result := -1;
  if Windows.IsWindow(msgWnd) = False then
  begin
    strMsg := '��Ч�Ĵ��ھ��';
    Exit;
  end;
  sData.dwData :=nData;
  sData.cbData := Length(strData) + 1;
  //Ϊ���ݵ����ݷ����ڴ�
  GetMem(sData.lpData,sData.cbData );
  try
    StrCopy(sData.lpData,PChar(strData));
    //����WM_COPYDATA��Ϣ
    result := SendMessage(msgWnd,WM_COPYDATA,nMsgID,Cardinal(@sData));
  finally
    FreeMem(sData.lpData); //�ͷ���Դ
  end;
end;

end.
