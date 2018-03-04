unit uDevChangeNotify;

{******************************************************************************
   功能：
         设备插拔检测类


   作者：李明雷  houjbf@sina.com


   上次修改: 2015-03-09
*******************************************************************************}


interface

uses
  Windows, SysUtils, Classes, Messages, Forms, StrUtils;

const
  {USB外接设备类GUID}
  CLSID_USB_DEV: TGUID = '{A5DCBF10-6530-11D2-901F-00C04FB951ED}';

type
  {设备状态}
  TDevState = (dsInserted, dsDeleted);
  {设备插拔事件}
  TOnDevChangeEvent = procedure(Sender: TObject; const DevName: string; DevState: TDevState) of object;

  ////////////////////////////////////////////////////////////////////////////////
  ///类名:TDevChangeMonitor
  ///描述:设备插拔检测类，包括移动硬盘和优盘及USB外接设备
  ////////////////////////////////////////////////////////////////////////////////
  TDevChangeMonitor = class(TComponent)
  public
    constructor Create(AOwen: TComponent); override;
    destructor Destroy; override;
    
  public
    {功能：监控所有设备，包括USB和其他设备}
    procedure Open(); overload; virtual;

    {功能：仅监控特定设备}
    procedure Open(const classguid: string); overload;

    {功能：仅监控特定设备}
    procedure Open(const classguid: TGUID); overload;

    {功能：关闭监控}
    procedure Close();

  private
    {设备通知句柄}
    m_HDEVNOTIFY: HDEVNOTIFY;
    {设备插入事件}
    m_OnDevInsert: TNotifyEvent;
    {设备拔出事件}
    m_OnDevDeleted: TNotifyEvent;
    {设备插、拔事件}
    m_OnDevChanged: TOnDevChangeEvent;
  protected
    {创建窗体,用来支持winpro消息}
    m_WindowHandle: HWND;
    {窗体消息函数}
    procedure WndProc(var Msg: TMessage); virtual;
    {设备状态变化消息}
    procedure WMDeviceChange(var Msg: TMessage); message WM_DEVICECHANGE;

  public
    {设备插入事件}
    property OnDevInserted: TNotifyEvent read m_OnDevInsert write m_OnDevInsert;
    {设备拔出事件}
    property OnDevDeleted: TNotifyEvent read m_OnDevDeleted write m_OnDevDeleted;
    {设备插、拔事件，信息更详细，可以据此判断被插拔的设备是否是目标设备}
    property OnDevChanged: TOnDevChangeEvent read m_OnDevChanged write m_OnDevChanged;
  end;

  ////////////////////////////////////////////////////////////////////////////////
  ///类名:TUsbDevChangeMonitor
  ///描述:设备插拔检测类，USB外接设备
  ////////////////////////////////////////////////////////////////////////////////

  TUsbDevChangeMonitor = class(TDevChangeMonitor)
  public
    {功能：监控所有USB设备}
    procedure Open(); override;
  end;

//------------------------------------------------------------------------------

{功能：判断设备是否指定设备}
function IsSameDevice(const sDevNamePath: string; const sVid: string; const sPid: string=''): Boolean;

//------------------------------------------------------------------------------

implementation


//------------------------------------------------------------------------------

const
  //设备类型(DBT.h)
  //DBT_DEVTYP_HANDLE = $00000006;               { file system handle }
  DBT_DEVTYP_DEVICEINTERFACE = $00000005;      { device interface class }

  //通知
  DEVICE_NOTIFY_ALL_INTERFACE_CLASSES = $00000004;


const
  //设备状态
  DBT_DEVICEARRIVAL = $8000;
  DBT_DEVICEREMOVECOMPLETE = $8004;


type
  PDEV_BROADCAST_DEVICEINTERFACE = ^DEV_BROADCAST_DEVICEINTERFACE;
  DEV_BROADCAST_DEVICEINTERFACE = {packed} record //must not be packed！ -add by LiMingLei.
    dbcc_size: DWORD;
    dbcc_devicetype: DWORD;
    dbcc_reserved: DWORD;
    dbcc_classguid: TGUID;
    dbcc_name: array[0..0] of CHAR;   { variable-sized buffer, potentially containing binary and/or text data }
  end;

//------------------------------------------------------------------------------
//DevPath: \\?\usb#vid_046d&pid_c52f#6&2e2f5def&0&2#{a5dcbf10-6530-11d2-901f-00c04fb951ed}

//------------------------------------------------------------------------------
function IsSameDevice(const sDevNamePath: string; const sVid, sPid: string): Boolean;
{功能：判断设备是否指定设备}
begin
  result := (sVid<>'') and (sDevNamePath<>'') and ContainsText(sDevNamePath, 'vid_'+sVid);
  if result and (sPid<>'') then
  begin
    result := ContainsText(sDevNamePath, 'pid_'+sPid);
  end;
end;

{ TDevChangeMonitor }
  
//------------------------------------------------------------------------------
procedure TDevChangeMonitor.Close;
begin
  if m_HDEVNOTIFY<>nil then
  begin
    Windows.UnregisterDeviceNotification(m_HDEVNOTIFY);
    m_HDEVNOTIFY := nil;
  end;
end;

constructor TDevChangeMonitor.Create(AOwen: TComponent);
begin
  inherited;
  m_HDEVNOTIFY := nil;
  m_WindowHandle := Classes.AllocateHWnd(WndProc);
end;
//------------------------------------------------------------------------------

destructor TDevChangeMonitor.Destroy;
begin
  self.Close;
  Classes.DeallocateHWnd(m_WindowHandle);
  inherited;
end;
//------------------------------------------------------------------------------

procedure TDevChangeMonitor.Open(const classguid: string);
begin
  self.Open(StringToGUID(classguid));
end;
//------------------------------------------------------------------------------

procedure TDevChangeMonitor.Open(const classguid: TGUID);
var
  DevInt: DEV_BROADCAST_DEVICEINTERFACE;
begin
  ZeroMemory( @DevInt, sizeof( DevInt ));
  DevInt.dbcc_size := sizeof( DevInt );
  DevInt.dbcc_devicetype := DBT_DEVTYP_DEVICEINTERFACE;
  DevInt.dbcc_classguid := classguid;
  m_HDEVNOTIFY := RegisterDeviceNotification( m_WindowHandle, @DevInt,
    DEVICE_NOTIFY_WINDOW_HANDLE);
end;
//------------------------------------------------------------------------------

procedure TDevChangeMonitor.Open;
var
  DevInt: DEV_BROADCAST_DEVICEINTERFACE;
begin
  ZeroMemory( @DevInt, sizeof( DevInt ));
  DevInt.dbcc_size := sizeof( DevInt );
  DevInt.dbcc_devicetype := DBT_DEVTYP_DEVICEINTERFACE;
  //DevInt.dbcc_classguid := classguid;
  m_HDEVNOTIFY := RegisterDeviceNotification( m_WindowHandle, @DevInt,
    DEVICE_NOTIFY_WINDOW_HANDLE OR DEVICE_NOTIFY_ALL_INTERFACE_CLASSES);
end;

//------------------------------------------------------------------------------

procedure TDevChangeMonitor.WMDeviceChange(var Msg: TMessage);
begin
  inherited;
  case Msg.WParam of
    DBT_DEVICEARRIVAL:
    begin
      if Assigned(m_OnDevInsert) then
      begin
        m_OnDevInsert(self);
      end;
      if Assigned(m_OnDevChanged) then
      begin
        m_OnDevChanged(self,
          PChar(@PDEV_BROADCAST_DEVICEINTERFACE(Msg.LParam).dbcc_name),
          dsInserted);
      end;
    end;
    DBT_DEVICEREMOVECOMPLETE:
    begin
      if Assigned(m_OnDevDeleted) then
      begin
        m_OnDevDeleted(self);
      end;
      if Assigned(m_OnDevChanged) then
      begin
        m_OnDevChanged(self,
          PChar(@PDEV_BROADCAST_DEVICEINTERFACE(Msg.LParam).dbcc_name),
          dsDeleted);
      end;
    end;
  end;
end;
//------------------------------------------------------------------------------

procedure TDevChangeMonitor.WndProc(var Msg: TMessage);
begin
  with Msg do
    if Msg = WM_DEVICECHANGE then
      try
        self.Dispatch(Msg);
      except
        Application.HandleException(Self);
      end
    else
      Result := DefWindowProc(m_WindowHandle, Msg, wParam, lParam);  
end;
//------------------------------------------------------------------------------


{ TUsbDevChangeMonitor }

procedure TUsbDevChangeMonitor.Open;
begin
  self.Open(CLSID_USB_DEV);
end;

//------------------------------------------------------------------------------


end.

