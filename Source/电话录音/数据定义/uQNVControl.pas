unit uQNVControl;

interface
uses Windows,SysUtils,Classes,brisdklib,Messages,uTFSystem;

type
  {TCallDirection ���з���}
  TCallDirection = (cdCaller{����},cdCalled{����});
  
  {RChannelsInfo ͨ����Ϣ�ṹ��}
  RChannelInfo = Record
    {ͨ������}
    nChannelIndex : Integer;
    {�Է��绰}
    strDestTel : String;
    {�Ƿ�����¼��}
    bRecording : Boolean;
    {��ǰ¼���ļ�ID}
    nRecFileID : Integer;
    {¼����ʼʱ��}
    dtRecordingBeginTime : TDateTime;
    {¼������ʱ��}
    dtRecordingEndTime : TDateTime;
    {��ʼ����ʱ��}
    dtDestBeginCallTime : TDateTime;
    {��������ʱ��}
    dtDestEndCallTime : TDateTime;
    {�����Ƿ�ժ��}
    bLocalHook : Boolean;
    {�Է��Ƿ�ժ��}
    bDestHook : Boolean;
    {��ǰ¼���ļ�����}
    strCurrRecordingFileName : String;
    {��ǰ���з���}
    CurrCallDirection : TCallDirection;
  end;

  {TChannels ͨ����Ϣ����}
  TChannels = array of RChannelInfo;

  {ͨ��֪ͨ}
  TOnCallNotify = procedure(const ChannelInfo : RChannelInfo) of Object;

  {ͨ����ʼ֪ͨ}
  TOnCallBeginNotify = procedure(const ChannelInfo : RChannelInfo;
      var bRecording:Boolean) of Object;
  

  //////////////////////////////////////////////////////////////////////////////
  /// ����: TQNVControl
  /// ˵��: ���ռε绰¼��������
  //////////////////////////////////////////////////////////////////////////////
  TQNVControl = Class
  public
    constructor Create();
    destructor Destroy();override;
  public
    {����:���豸}
    function Open():boolean;
    {����:�ر�װ��}
    procedure Close();
    {����:������һ�δ�����Ϣ}
    function GetLastError():String;
  private
    {��Ϣ���ܾ��}
    m_MsgHwnd : HWND;
    {��ǰͨ������}
    m_nChannelsCount : Integer;
    {��ǰ�豸�Ƿ��}
    m_bActive : Boolean;
    {¼���ļ�����Ŀ¼}
    m_strFileOutputPath : String;
    {ͨ����Ϣ}
    m_Channels : TChannels;
    {��ʼͨ���¼�֪ͨ}
    m_OnCallBeginNotify : TOnCallBeginNotify;
    {ͨ�������¼�֪ͨ}
    m_OnCallEndNotify : TOnCallNotify;
    {�Է������¼�֪ͨ}
    m_OnDestCallIn : TOnCallNotify;
    {�����µ�δ������}
    m_OnStopCallIn : TOnCallNotify;
    {���һ�δ�����Ϣ}
    m_strLastError : String;
  private
    procedure SetActive(bValue:Boolean);
    function GetActive():Boolean;
    procedure SetFileOutputPath(strPath:String);
  protected
    {����:������Ϣ����}
    procedure MyMsgProc(var Msg:TMessage);
    {����:��ʼ��ͨ����Ϣ}
    procedure InitChannels();
  published
    {�豸��״̬}
    property Active : Boolean read GetActive write SetActive;
    {¼���ļ����Ŀ¼}
    property FileOutputPath:String read m_strFileOutputPath write SetFileOutputPath;
    {��ʼͨ���¼�֪ͨ}
    property OnCallBeginNotify : TOnCallBeginNotify read m_OnCallBeginNotify
        write m_OnCallBeginNotify;
    {����ͨ���¼�֪ͨ}
    property OnCallEndNotify : TOnCallNotify read m_OnCallEndNotify
        write m_OnCallEndNotify;
    {�Է������¼�֪ͨ}
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
{����:��ʼ��ͨ����Ϣ}
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


{��ʼ¼��������
˫����ժ����
}

{ֹͣ¼��������
 BriEvent_PhoneHang(���عһ�)
 BriEvent_PSTNFree(��·�жϿ���)
 BriEvent_RemoteHang(���з��һ�)
 BriEvent_Busy(���з��һ�)
}


procedure TQNVControl.MyMsgProc(var Msg: TMessage);
{����:������Ϣ����}
var
  strFileName : String;
  pEvent:PTBriEvent_Data;
  nFileID : Integer;
  bRecording : Boolean;
begin
  if Msg.Msg <> BRI_EVENT_MESSAGE then Exit;
  pEvent := PTBriEvent_Data(Msg.LParam);
  case pEvent^.lEventType of
    {��������}
    BriEvent_PhoneDial :
      begin
        if m_Channels[pEvent^.uChannelID].bRecording then Exit;
        m_Channels[pEvent^.uChannelID].strDestTel := Trim(pEvent^.szData);
      end;
    {�������Ž�����ʼ����}
    BriEvent_RingBack :
      begin
        m_Channels[pEvent^.uChannelID].CurrCallDirection := cdCaller;
      end;
    {����ժ�����߶Է�ժ��}
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

        strFileName := m_strFileOutputPath+'ͨ��'+
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

        {��ʼ¼������}
        nFileID := QNV_RecordFile(pEvent^.uChannelID,QNV_RECORD_FILE_START,
            BRI_WAV_FORMAT_DEFAULT,RECORD_MASK_ECHO,PChar(strFileName));

        if nFileID > 0 then
          m_Channels[pEvent^.uChannelID].nRecFileID := nFileID;

      end;
    {�Է�����}
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
        {ֹͣ¼��}

        {�����һ�}
        if pEvent^.lEventType = BriEvent_PhoneHang then
          m_Channels[pEvent^.uChannelID].bLocalHook := False;

        {�Է��һ�������·�ж�}
        if pEvent^.lEventType in
            [BriEvent_RemoteHang,BriEvent_PSTNFree,BriEvent_Busy] then
        begin
          m_Channels[pEvent^.uChannelID].bDestHook := False;
        end;

        {���û��¼����ô�򲻽����κδ���}
        if m_Channels[pEvent^.uChannelID].bRecording = False then Exit;

        m_Channels[pEvent^.uChannelID].dtRecordingEndTime := Now;

        {ֹͣ¼������}
        QNV_RecordFile(pEvent^.uChannelID,QNV_RECORD_FILE_STOP,
            m_Channels[pEvent^.uChannelID].nRecFileID,0,'');

        if Assigned(m_OnCallEndNotify) then
          m_OnCallEndNotify(m_Channels[pEvent^.uChannelID]);

        m_Channels[pEvent^.uChannelID].bRecording := False;
        m_Channels[pEvent^.uChannelID].nRecFileID := -1;
      end;
    BriEvent_StopCallIn :
      begin
        {δ������}
        m_Channels[pEvent^.uChannelID].dtDestEndCallTime := Now;
        if Assigned(m_OnStopCallIn) then
          m_OnStopCallIn(m_Channels[pEvent^.uChannelID]);
      end;
  end;

{    BriEvent_PhoneHook : Box('����ժ��');
    BriEvent_PhoneHang : Box('���عһ�');
    BriEvent_CallIn : Box('�Է�����');
    BriEvent_GetCallID : Box('�Է��������:('+Trim(pEvent^.szData)+')');
    BriEvent_StopCallIn : Box('�����µ�δ������!');
    BriEvent_PhoneDial : Box('���������绰:('+Trim(pEvent^.szData)+')');
    BriEvent_RemoteHook : Box('�Է�ժ��,��ʼ¼��.');
    BriEvent_RemoteHang : Box('���з��һ�1');
    BriEvent_Busy : Box('���з��һ�2');
    BriEvent_DialTone : Box('ժ����õ�������');
    BriEvent_RingBack :Box('�绰���Ž�����!');}
  
end;

function TQNVControl.Open():Boolean;
{����:���豸}
var
  i : Integer;
  nResult : longint;
begin
  Result := False;
  if m_bActive then
  begin
    m_strLastError := '�豸�Ѿ���!';
    Exit;
  end;
  nResult := QNV_OpenDevice(ODT_LBRIDGE,0,nil);
  if nResult <= 0 then
  begin
    case nResult of
      0 : m_strLastError := '��¼�����豸ʧ��!�����豸�Ƿ�����.';
    else
      m_strLastError := '��¼�����豸ʧ��!����ID:('+IntToStr(nResult)+')';
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
      {����ڵ���״̬�£��ر��Զ���λ����}
      QNV_SetDevCtrl(i,QNV_CTRL_WATCHDOG,0);
    end
    else
    begin
      {�����ִ������,��ô���Զ���λ����}
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
