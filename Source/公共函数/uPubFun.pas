unit uPubFun;

interface
uses
  Classes,SysUtils,DateUtils,Forms,PerlRegEx,ufrmTextInput;
type
  ///////////////////////////////////////////////////////////////////////////////
  ///类名:TPubFun
  ///描述:公共函数
  ///////////////////////////////////////////////////////////////////////////////
  TPubFun = class
  public
    {功能:字符串到日期}
    class function Str2DateTime(strDateTime:string):TDateTime;
    {功能:日期转换为字符串}
    class function DateTime2Str(dt:TDateTime):string;
    {功能:日期转换为字符串MM-DD HH:nn}
    class function DT2StrmmddHHnn(dt:TDateTime):string;
    {功能:布尔类型转换为整型}
    class function Bool2Int(bl_Value:Boolean):Integer;
    {功能:整型转换为布尔类型}
    class function Int2Bool(n_Value:Integer):Boolean;
    {功能:获取系统路径}
    class function AppPath():string;
    {功能:判断是否在时间区段内}
    class function CheckInTimeSec(dtStart,dtEnd,dtNow:TDateTime):Boolean;
    {功能:格式化显示乘务员工号姓名}
    class function FormatTMNameNum(strName,strGH: string): string;
    {功能:计算时差**小时**分钟}
    class function CalTimeSpanHM(dtFrom,dtEnd:TDateTime):string;

    {功能:判断房间号是否合法}
    class function CheckRoomNum(strRoomNum:string;var strErr:string):Boolean;
    //输入房间号
    class function InputRoomNum(strTitle:string;var strRoomNum:string):Boolean;

  end;

implementation

{ TPubFun }

class function TPubFun.AppPath: string;
begin
  Result := ExtractFilePath(Application.ExeName);
end;

class function TPubFun.Bool2Int(bl_Value: Boolean): Integer;
begin
  result := 0;
  if bl_Value then result := 1;
  
end;
class function TPubFun.FormatTMNameNum(strName,strGH: string): string;
begin
  result :='';
  if strGH <> '' then
  begin
    result := Format('%s[%s]',[strName,strGH]);
  end;
end;
class function TPubFun.CalTimeSpanHM(dtFrom, dtEnd: TDateTime): string;
var
  nHours,nMinutes:Integer;
begin
  nHours := DateUtils.HoursBetween(dtFrom,dtEnd);
  nMinutes := DateUtils.MinutesBetween(dtFrom,dtEnd);
  nMinutes := nMinutes - nHours*60;
  Result := Format('%d时%d分',[nHours,nMinutes]);
  if dtFrom > dtEnd then
  begin
    Result := '负'+ result;
  end;

end;

class function TPubFun.CheckInTimeSec(dtStart, dtEnd,
  dtNow: TDateTime): Boolean;
var
  time_Start,time_end,time_now:TDateTime;
begin
  time_Start := TimeOf(dtStart);
  time_end := TimeOf(dtEnd);
  time_now := TimeOf(dtNow);
  result := False;
  
  if time_Start < time_end then
  begin
    if (time_now >= time_Start) and (time_now <= time_end) then
    begin
      result := True;
      Exit;
    end;
  end
  else
  begin
    if (time_now >= time_Start) or (time_now <= time_end)  then
    begin
      result := True;
      Exit;
    end;
  end;
  
end;

class function TPubFun.CheckRoomNum(strRoomNum: string;var strErr:string): Boolean;
var
  reg:TPerlRegEx;
begin
  result := false;
  strErr := '房间号必须是1位(1-9)的楼层+2位(0-9)的房间号组成';
  reg := TPerlRegEx.Create;
  try
    reg.Subject := strRoomNum;
    reg.RegEx := '^[1-9][0-9][0-9]$';
    result :=  reg.Match ;
  finally
    reg.Free;
  end;
end;

class function TPubFun.DateTime2Str(dt: TDateTime): string;
begin
  Result := '';
  if dt > 1 then
    result := FormatDateTime('yyyy-mm-dd HH:mm:ss',dt);
end;
class function TPubFun.DT2StrmmddHHnn(dt:TDateTime):string;
begin
  Result := '';
  if dt > 1 then
    result := FormatDateTime('yy-mm-dd HH:mm',dt);
end;

class function TPubFun.InputRoomNum(strTitle: string; var strRoomNum:string): Boolean;
begin
  result := TextInput(strTitle,'输入房间号',strRoomNum,'房间号必须是1位(1-9)的楼层+2位(0-9)的房间号组成','^[1-9][0-9][0-9]$');
end;

class function TPubFun.Int2Bool(n_Value: Integer): Boolean;
begin
  result := False;
  if n_Value >0 then result := True;

end;

class function TPubFun.str2DateTime(strDateTime: string): TDateTime;
begin
  result := 0;
  TryStrToDateTime(strDateTime,result);
end;

end.
