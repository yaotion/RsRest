unit uDevChangeNotify;

{******************************************************************************
   ���ܣ�
         �豸��μ����


   ���ߣ�������  houjbf@sina.com


   �ϴ��޸�: 2015-03-09
*******************************************************************************}


interface

uses
  Windows, SysUtils, Classes, Messages, Forms, StrUtils;

const
  {USB����豸��GUID}
  CLSID_USB_DEV: TGUID = '{A5DCBF10-6530-11D2-901F-00C04FB951ED}';

type
  {�豸״̬}
  TDevState = (dsInserted, dsDeleted);
  {�豸����¼�}
  TOnDevChangeEvent = procedure(Sender: TObject; const DevName: string; DevState: TDevState) of object;

  ////////////////////////////////////////////////////////////////////////////////
  ///����:TDevChangeMonitor
  ///����:�豸��μ���࣬�����ƶ�Ӳ�̺����̼�USB����豸
  ////////////////////////////////////////////////////////////////////////////////
  TDevChangeMonitor = class(TComponent)
  public
    constructor Create(AOwen: TComponent); override;
    destructor Destroy; override;
    
  public
    {���ܣ���������豸������USB�������豸}
    procedure Open(); overload; virtual;

    {���ܣ�������ض��豸}
    procedure Open(const classguid: string); overload;

    {���ܣ�������ض��豸}
    procedure Open(const classguid: TGUID); overload;

    {���ܣ��رռ��}
    procedure Close();

  private
    {�豸֪ͨ���}
    m_HDEVNOTIFY: HDEVNOTIFY;
    {�豸�����¼�}
    m_OnDevInsert: TNotifyEvent;
    {�豸�γ��¼�}
    m_OnDevDeleted: TNotifyEvent;
    {�豸�塢���¼�}
    m_OnDevChanged: TOnDevChangeEvent;
  protected
    {��������,����֧��winpro��Ϣ}
    m_WindowHandle: HWND;
    {������Ϣ����}
    procedure WndProc(var Msg: TMessage); virtual;
    {�豸״̬�仯��Ϣ}
    procedure WMDeviceChange(var Msg: TMessage); message WM_DEVICECHANGE;

  public
    {�豸�����¼�}
    property OnDevInserted: TNotifyEvent read m_OnDevInsert write m_OnDevInsert;
    {�豸�γ��¼�}
    property OnDevDeleted: TNotifyEvent read m_OnDevDeleted write m_OnDevDeleted;
    {�豸�塢���¼�����Ϣ����ϸ�����Ծݴ��жϱ���ε��豸�Ƿ���Ŀ���豸}
    property OnDevChanged: TOnDevChangeEvent read m_OnDevChanged write m_OnDevChanged;
  end;

  ////////////////////////////////////////////////////////////////////////////////
  ///����:TUsbDevChangeMonitor
  ///����:�豸��μ���࣬USB����豸
  ////////////////////////////////////////////////////////////////////////////////

  TUsbDevChangeMonitor = class(TDevChangeMonitor)
  public
    {���ܣ��������USB�豸}
    procedure Open(); override;
  end;

//------------------------------------------------------------------------------

{���ܣ��ж��豸�Ƿ�ָ���豸}
function IsSameDevice(const sDevNamePath: string; const sVid: string; const sPid: string=''): Boolean;

//------------------------------------------------------------------------------

implementation


//------------------------------------------------------------------------------

const
  //�豸����(DBT.h)
  //DBT_DEVTYP_HANDLE = $00000006;               { file system handle }
  DBT_DEVTYP_DEVICEINTERFACE = $00000005;      { device interface class }

  //֪ͨ
  DEVICE_NOTIFY_ALL_INTERFACE_CLASSES = $00000004;


const
  //�豸״̬
  DBT_DEVICEARRIVAL = $8000;
  DBT_DEVICEREMOVECOMPLETE = $8004;


type
  PDEV_BROADCAST_DEVICEINTERFACE = ^DEV_BROADCAST_DEVICEINTERFACE;
  DEV_BROADCAST_DEVICEINTERFACE = {packed} record //must not be packed�� -add by LiMingLei.
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
{���ܣ��ж��豸�Ƿ�ָ���豸}
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

