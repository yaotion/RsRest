unit uQNVControl;

interface
uses Windows,SysUtils,Classes,brisdklib,Messages,uTFSystem;

type
  {TCallDirection 呼叫方向}
  TCallDirection = (cdCaller{主叫},cdCalled{被叫});
  
  {RChannelsInfo 通道信息结构体}
  RChannelInfo = Record
    {通道索引}
    nChannelIndex : Integer;
    {对方电话}
    strDestTel : String;
    {是否正在录音}
    bRecording : Boolean;
    {当前录音文件ID}
    nRecFileID : Integer;
    {录音开始时间}
    dtRecordingBeginTime : TDateTime;
    {录音结束时间}
    dtRecordingEndTime : TDateTime;
    {开始呼叫时间}
    dtDestBeginCallTime : TDateTime;
    {结束呼叫时间}
    dtDestEndCallTime : TDateTime;
    {本机是否摘机}
    bLocalHook : Boolean;
    {对方是否摘机}
    bDestHook : Boolean;
    {当前录音文件名称}
    strCurrRecordingFileName : String;
    {当前呼叫方向}
    CurrCallDirection : TCallDirection;
  end;

  {TChannels 通道信息数组}
  TChannels = array of RChannelInfo;

  {通话通知}
  TOnCallNotify = procedure(const ChannelInfo : RChannelInfo) of Object;

  {通话开始通知}
  TOnCallBeginNotify = procedure(const ChannelInfo : RChannelInfo;
      var bRecording:Boolean) of Object;
  

  //////////////////////////////////////////////////////////////////////////////
  /// 类名: TQNVControl
  /// 说明: 奇普嘉电话录音控制类
  //////////////////////////////////////////////////////////////////////////////
  TQNVControl = Class
  public
    constructor Create();
    destructor Destroy();override;
  public
    {功能:打开设备}
    function Open():boolean;
    {功能:关闭装置}
    procedure Close();
    {功能:获得最后一次错误信息}
    function GetLastError():String;
  private
    {消息接受句柄}
    m_MsgHwnd : HWND;
    {当前通道总数}
    m_nChannelsCount : Integer;
    {当前设备是否打开}
    m_bActive : Boolean;
    {录音文件输入目录}
    m_strFileOutputPath : String;
    {通道信息}
    m_Channels : TChannels;
    {开始通话事件通知}
    m_OnCallBeginNotify : TOnCallBeginNotify;
    {通话结束事件通知}
    m_OnCallEndNotify : TOnCallNotify;
    {对方来电事件通知}
    m_OnDestCallIn : TOnCallNotify;
    {产生新的未接来电}
    m_OnStopCallIn : TOnCallNotify;
    {最后一次错误信息}
    m_strLastError : String;
  private
    procedure SetActive(bValue:Boolean);
    function GetActive():Boolean;
    procedure SetFileOutputPath(strPath:String);
  protected
    {功能:监听消息过程}
    procedure MyMsgProc(var Msg:TMessage);
    {功能:初始化通道信息}
    procedure InitChannels();
  published
    {设备打开状态}
    property Active : Boolean read GetActive write SetActive;
    {录音文件输出目录}
    property FileOutputPath:String read m_strFileOutputPath write SetFileOutputPath;
    {开始通话事件通知}
    property OnCallBeginNotify : TOnCallBeginNotify read m_OnCallBeginNotify
        write m_OnCallBeginNotify;
    {结束通话事件通知}
    property OnCallEndNotify : TOnCallNotify read m_OnCallEndNotify
        write m_OnCallEndNotify;
    {对方来电事件通知}
    property OnDestCallIn : TOnCallNotify read m_OnDestCallIn
        write m_OnDestCallIn;
    property OnStopCallIn : TOnCallNotify read m_OnStopCallIn
        write m_OnStopCallIn;
  end;

implementation

{ TQNVControl }

procedure TQNVControl.Close;
begin
  QNV_CloseDevice(ODT_LBRIDGE,0);
  m_bActive := False;
end;

constructor TQNVControl.Create;
begin
  m_MsgHwnd := AllocateHWnd(MyMsgProc);
end;

destructor TQNVControl.Destroy;
begin
  Active := False;
  DeallocateHWnd(m_MsgHwnd);
  inherited;
end;

function TQNVControl.GetActive():Boolean;
begin
{  if m_bActive then
  begin
    if QNV_DevInfo(0,QNV_DEVINFO_GETCHANNELS) <= 0 then
    begin
      Close();
    end;
  end;}
  Result := m_bActive;
end;

function TQNVControl.GetLastError: String;
begin
  Result := m_strLastError;
end;

procedure TQNVControl.InitChannels;
{功能:初始化通道信息}
var
  i : Integer;
begin
  for I := 0 to length(m_Channels) - 1 do
  begin
    m_Channels[i].nChannelIndex := i;
    m_Channels[i].strDestTel := '';
    m_Channels[i].bRecording := False;
    m_Channels[i].nRecFileID := -1;
    m_Channels[i].bLocalHook := False;
    m_Channels[i].bDestHook := False;
    m_Channels[i].strCurrRecordingFileName := '';
    m_Channels[i].dtRecordingBeginTime := 0;
    m_Channels[i].dtRecordingEndTime := 0;
    m_Channels[i].dtDestBeginCallTime := 0;
    m_Channels[i].dtDestEndCallTime := 0;
  end;
end;


{开始录音的条件
双方都摘机了
}

{停止录音的条件
 BriEvent_PhoneHang(本地挂机)
 BriEvent_PSTNFree(线路中断空闲)
 BriEvent_RemoteHang(被叫方挂机)
 BriEvent_Busy(被叫方挂机)
}


procedure TQNVControl.MyMsgProc(var Msg: TMessage);
{功能:监听消息过程}
var
  strFileName : String;
  pEvent:PTBriEvent_Data;
  nFileID : Integer;
  bRecording : Boolean;
begin
  if Msg.Msg <> BRI_EVENT_MESSAGE then Exit;
  pEvent := PTBriEvent_Data(Msg.LParam);
  case pEvent^.lEventType of
    {本机拨号}
    BriEvent_PhoneDial :
      begin
        if m_Channels[pEvent^.uChannelID].bRecording then Exit;
        m_Channels[pEvent^.uChannelID].strDestTel := Trim(pEvent^.szData);
      end;
    {本机拨号结束开始呼叫}
    BriEvent_RingBack :
      begin
        m_Channels[pEvent^.uChannelID].CurrCallDirection := cdCaller;
      end;
    {本机摘机或者对方摘机}
    BriEvent_PhoneHook,BriEvent_RemoteHook:
      begin
        if pEvent^.lEventType = BriEvent_PhoneHook then
          m_Channels[pEvent^.uChannelID].bLocalHook := True
        else
          m_Channels[pEvent^.uChannelID].bDestHook := True;

        if (m_Channels[pEvent^.uChannelID].bLocalHook = False) or
            (m_Channels[pEvent^.uChannelID].bDestHook = False) then Exit;

        if m_Channels[pEvent^.uChannelID].bRecording then Exit;

        m_Channels[pEvent^.uChannelID].bRecording := True;
        m_Channels[pEvent^.uChannelID].dtRecordingBeginTime := Now;

        strFileName := m_strFileOutputPath+'通道'+
            IntToStr(pEvent^.uChannelID)+'_'+
            formatDateTime('yyyymmddhhnnss',now)+'.wav';

        if FileExists(strFileName) then
          DeleteFile(strFileName);

        m_Channels[pEvent^.uChannelID].strCurrRecordingFileName := strFileName;


        if Assigned(m_OnCallBeginNotify) then
        begin
          bRecording := True;
          m_OnCallBeginNotify(m_Channels[pEvent^.uChannelID],bRecording);
          if bRecording = False then
          begin
            m_Channels[pEvent^.uChannelID].bRecording := False;          
            Exit;
          end;
        end;

        {开始录音代码}
        nFileID := QNV_RecordFile(pEvent^.uChannelID,QNV_RECORD_FILE_START,
            BRI_WAV_FORMAT_DEFAULT,RECORD_MASK_ECHO,PChar(strFileName));

        if nFileID > 0 then
          m_Channels[pEvent^.uChannelID].nRecFileID := nFileID;

      end;
    {对方呼叫}
    BriEvent_GetCallID:
      begin
        m_Channels[pEvent^.uChannelID].bDestHook := True;
        m_Channels[pEvent^.uChannelID].strDestTel := Trim(pEvent^.szData);
        m_Channels[pEvent^.uChannelID].dtDestBeginCallTime := Now;
        m_Channels[pEvent^.uChannelID].CurrCallDirection := cdCalled;
        if Assigned(m_OnDestCallIn) then
          m_OnDestCallIn(m_Channels[pEvent^.uChannelID]);
      end;
    BriEvent_PhoneHang,BriEvent_PSTNFree,
    BriEvent_RemoteHang,BriEvent_Busy :
      begin
        {停止录音}

        {本机挂机}
        if pEvent^.lEventType = BriEvent_PhoneHang then
          m_Channels[pEvent^.uChannelID].bLocalHook := False;

        {对方挂机或者线路中断}
        if pEvent^.lEventType in
            [BriEvent_RemoteHang,BriEvent_PSTNFree,BriEvent_Busy] then
        begin
          m_Channels[pEvent^.uChannelID].bDestHook := False;
        end;

        {如果没有录音那么则不进行任何处理}
        if m_Channels[pEvent^.uChannelID].bRecording = False then Exit;

        m_Channels[pEvent^.uChannelID].dtRecordingEndTime := Now;

        {停止录音代码}
        QNV_RecordFile(pEvent^.uChannelID,QNV_RECORD_FILE_STOP,
            m_Channels[pEvent^.uChannelID].nRecFileID,0,'');

        if Assigned(m_OnCallEndNotify) then
          m_OnCallEndNotify(m_Channels[pEvent^.uChannelID]);

        m_Channels[pEvent^.uChannelID].bRecording := False;
        m_Channels[pEvent^.uChannelID].nRecFileID := -1;
      end;
    BriEvent_StopCallIn :
      begin
        {未接来电}
        m_Channels[pEvent^.uChannelID].dtDestEndCallTime := Now;
        if Assigned(m_OnStopCallIn) then
          m_OnStopCallIn(m_Channels[pEvent^.uChannelID]);
      end;
  end;

{    BriEvent_PhoneHook : Box('本地摘机');
    BriEvent_PhoneHang : Box('本地挂机');
    BriEvent_CallIn : Box('对方来电');
    BriEvent_GetCallID : Box('对方来电号码:('+Trim(pEvent^.szData)+')');
    BriEvent_StopCallIn : Box('产生新的未接来电!');
    BriEvent_PhoneDial : Box('本机拨出电话:('+Trim(pEvent^.szData)+')');
    BriEvent_RemoteHook : Box('对方摘机,开始录音.');
    BriEvent_RemoteHang : Box('被叫方挂机1');
    BriEvent_Busy : Box('被叫方挂机2');
    BriEvent_DialTone : Box('摘机后得到拨号音');
    BriEvent_RingBack :Box('电话拨号结束后!');}
  
end;

function TQNVControl.Open():Boolean;
{功能:打开设备}
var
  i : Integer;
  nResult : longint;
begin
  Result := False;
  if m_bActive then
  begin
    m_strLastError := '设备已经打开!';
    Exit;
  end;
  nResult := QNV_OpenDevice(ODT_LBRIDGE,0,nil);
  if nResult <= 0 then
  begin
    case nResult of
      0 : m_strLastError := '打开录音盒设备失败!请检查设备是否连接.';
    else
      m_strLastError := '打开录音盒设备失败!错误ID:('+IntToStr(nResult)+')';
    end;
    Exit;
  end;
  m_nChannelsCount := QNV_DevInfo(0,QNV_DEVINFO_GETCHANNELS);
  SetLengTh(m_Channels,m_nChannelsCount);
  InitChannels();
  for I := 0 to m_nChannelsCount - 1 do
  begin
    if System.DebugHook <> 0 then
    begin
      {如果在调试状态下，关闭自动复位功能}
      QNV_SetDevCtrl(i,QNV_CTRL_WATCHDOG,0);
    end
    else
    begin
      {如果在执行运行,那么打开自动复位功能}
      QNV_SetDevCtrl(i,QNV_CTRL_WATCHDOG,1);
    end;
    QNV_Event(i,QNV_EVENT_REGWND,m_MsgHwnd,nil,nil,0);
  end;
  m_bActive := True;
  Result := True;
end;

procedure TQNVControl.SetActive(bValue: Boolean);
begin
  if m_bActive = bValue then Exit;
  if bValue then
    Open()
  else
    Close();
end;

procedure TQNVControl.SetFileOutputPath(strPath: String);
begin
  if strPath <> '' then
  begin
    if strPath[length(strPath)] <> '\' then
      strPath := strPath + '\';
  end;
  m_strFileOutputPath := strPath;
end;

end.
