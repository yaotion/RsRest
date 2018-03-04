unit uProgressCommFun;

interface
uses
  Classes,Windows,ShellAPI,Tlhelp32,SysUtils,Messages;
type

  //////////////////////////////////////////////////////////////////////////////
  ///类名: RExeInfo
  ///描述: exe程序基础信息
  //////////////////////////////////////////////////////////////////////////////
  RExeInfo = record
    //程序路径
    strFilePath:string;
    //程序名称
    strProName:string;
    //主窗口类名称
    strClassName:string;
    //主窗口标题
    strCaption:string;
    //主窗口句柄
    Handle:THandle;
  end;

  TProgressCommFun = class
    {功能:判断进程是否存在}
    class function bProgressExist(strProgressName:string;out strMsg:string):Boolean;
    {功能:启动程序}
    class function OpenExe(strExeFilePath:string;strProgressName:string;out strMsg:string):Boolean;
    {功能:查找窗口}
    class function FindWind(strClassName,strCaption:string):THandle;
    {功能:进程间发送字符串消息}
    class function SendMsg(msgWnd:THandle;nMsgID:Integer;nData:Integer;strData:string;out strMsg:string):Integer;
    {功能:进程间发送字符串消息 post}
    class function PostMsg(msgWnd:THandle;nMsgID:Integer;nData:Integer;strData:string;out strMsg:string): Boolean; deprecated;
    {功能:进程间接收字符串消息}
    class procedure RecvMsg(var AMsg: TWmCopyData;out nMsgID:Integer;out nData:Integer;out strData:string);

  end;

implementation

{ TProgressCommFun }

class function TProgressCommFun.bProgressExist(strProgressName: string;
  out strMsg: string): Boolean;
var
  nHandle : hwnd;//句柄
  fprocessentry32 : TProcessEntry32; //结构类型的变量
  bProgressExist : Boolean;   //返回一个布尔值（用来判断是否找到进程信息）
  processid : dword; //储存找到的进程ID
  strName : string; //储存找到的进程名称 end;
begin
  Result := False;
  strMsg := '进程:' + strProgressName + '未启动';
  nHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);   //获得进程快照句柄
  fprocessentry32.dwSize := sizeof(fprocessentry32); //给TProcessEntry32结构的第一个参数赋值（也可以理解为把这个结构的第一个参数初始化）
  bProgressExist := Process32First(nHandle,fprocessentry32); //使用 Process32First函数取得第一个进程的信息
  while bProgressExist = true do //如果 Process32First函数执行成功也就是说找到进程列表里的第一个进程时开始循环
  begin
    bProgressExist := Process32Next(nHandle,FprocessEntry32); //取得第下一个进程信息
    strName := fprocessentry32.szExeFile; //取得一个进程的名称
    if strName = strProgressName then //如果进程名等于这个字符串
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
    strMsg :='未找到文件:' + strExeFilePath;
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
    strMsg := '程序:' + strProgressName + ' 启动失败!';
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
    strMsg := '无效的窗口句柄';
    Exit;
  end;
  sData.dwData :=nData;
  sData.cbData := Length(strData) + 1;
  //为传递的数据分配内存
  GetMem(sData.lpData,sData.cbData );
  try
    StrCopy(sData.lpData,PChar(strData));
    //发送WM_COPYDATA消息
    result := PostMessage(msgWnd,WM_COPYDATA,nMsgID,Cardinal(@sData));
  finally
    FreeMem(sData.lpData); //释放资源
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
    strMsg := '无效的窗口句柄';
    Exit;
  end;
  sData.dwData :=nData;
  sData.cbData := Length(strData) + 1;
  //为传递的数据分配内存
  GetMem(sData.lpData,sData.cbData );
  try
    StrCopy(sData.lpData,PChar(strData));
    //发送WM_COPYDATA消息
    result := SendMessage(msgWnd,WM_COPYDATA,nMsgID,Cardinal(@sData));
  finally
    FreeMem(sData.lpData); //释放资源
  end;
end;

end.
