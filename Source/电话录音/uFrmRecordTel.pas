unit uFrmRecordTel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,brisdklib,uQNVControl,StdCtrls, RzStatus, ExtCtrls, RzPanel,
  uTelRecord,uRecordTelUtil,utfsYSTEM, pngimage;

type
  TFrmRecordTel = class(TForm)
    RzStatusBar1: TRzStatusBar;
    lblRecordingBoxState: TRzStatusPane;
    Label1: TLabel;
    Image1: TImage;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
       {�绰¼����ʱ}
    m_dtRecordingStart: TDateTime;
    {�绰¼���ռ���}
    m_QNVControl : TQNVControl;
    {�绰¼�����}
    m_SoundRecdInfo: RChannelInfo;
    {����:��ʼ����}
    procedure OnCallBeginNotify(const ChannelInfo : RChannelInfo;var bRecording:Boolean);
    {����:���н���,�������ͨ����¼}
    procedure OnCallEndNotify(const ChannelInfo : RChannelInfo);

    {����:�Է���ʼ����}
    procedure OnDestCallBeginNotify(const ChannelInfo : RChannelInfo);
    {����:�Է���ʼ���н���}
    procedure OnDestCallEndNotify(const ChannelInfo : RChannelInfo);

    {����¼����״̬��ʾ}
    procedure DoUpdateRecordingState();
    {����:����¼����Ϣ}
    procedure SaveRecordInfo(bIsDialed: boolean;strRemark: string);
  private
     // �ص�
    m_OnLogEvent:TOnEventByString;
    //¼����Ϣ��
    m_TelRecord:TTelRecord;
    //¼��������
    m_RecordTelUtil :TRecordTelUtil;
  public
    { Public declarations }
    property   LogEvent: TOnEventByString read m_OnLogEvent write  m_OnLogEvent;
  end;

var
  FrmRecordTel: TFrmRecordTel;

implementation
uses
  uGlobalDM,utfPopBox;

{$R *.dfm}

procedure TFrmRecordTel.DoUpdateRecordingState;
begin
  if m_QNVControl.Active then
  begin
    lblRecordingBoxState.Caption := '������';
  end
  else
  begin
    lblRecordingBoxState.Caption := 'δ����';

    GlobalDM.LogManage.InsertLog('�绰¼���豸δ���ӣ�ͨ��¼�����ܽ��޷�ʹ�á�');
  end;
end;

procedure TFrmRecordTel.FormCreate(Sender: TObject);
begin

  m_TelRecord := TTelRecord.Create;
  m_RecordTelUtil :=  TRecordTelUtil.Create(GlobalDM.LocalADOConnection);

  m_QNVControl := TQNVControl.Create;
  m_QNVControl.OnCallBeginNotify := self.OnCallBeginNotify;
  m_QNVControl.OnCallEndNotify := self.OnCallEndNotify;

  m_QNVControl.OnDestCallIn := self.OnDestCallBeginNotify;
  m_QNVControl.OnStopCallIn := self.OnDestCallEndNotify;

  m_QNVControl.FileOutputPath := ExtractFilePath(ParamStr(0))+'TelRecordFile\';
  if not m_QNVControl.Open then
  begin
    TtfPopBox.ShowBox(m_QNVControl.GetLastError );
  end;

end;

procedure TFrmRecordTel.FormDestroy(Sender: TObject);
begin
  m_TelRecord.Free ;
  m_RecordTelUtil.free ;
  m_QNVControl.Close;
  m_QNVControl.Free;
end;

procedure TFrmRecordTel.OnCallBeginNotify(const ChannelInfo: RChannelInfo;
  var bRecording: Boolean);
begin
  m_SoundRecdInfo := ChannelInfo;
  self.m_dtRecordingStart := now();
  GlobalDM.LogManage.InsertLog('¼����ʼ...') ;
  lblRecordingBoxState.Caption := '¼����ʼ...';
  if Assigned(m_OnLogEvent) then
    m_OnLogEvent('¼����ʼ');
  //self.lblSoundRecording.Caption := '00:00';
  //RecordingTimer.Enabled := True;
end;

procedure TFrmRecordTel.OnCallEndNotify(const ChannelInfo: RChannelInfo);
begin
  m_SoundRecdInfo := ChannelInfo;
  //self.RecordingTimer.Enabled := False;
  GlobalDM.LogManage.InsertLog(Format('¼�����:%s', [m_SoundRecdInfo.strCurrRecordingFileName]));
  SaveRecordInfo(True,'');
  if Assigned(m_OnLogEvent) then
    m_OnLogEvent('¼�����');
end;

procedure TFrmRecordTel.OnDestCallBeginNotify(const ChannelInfo: RChannelInfo);
begin
  m_SoundRecdInfo := ChannelInfo;
  self.m_dtRecordingStart := now();
  GlobalDM.LogManage.InsertLog('�ӵ�����'+ChannelInfo.strDestTel) ;
  lblRecordingBoxState.Caption := '�ӵ�����...';
  if Assigned(m_OnLogEvent) then
    m_OnLogEvent('�ӵ�����');
end;

procedure TFrmRecordTel.OnDestCallEndNotify(const ChannelInfo: RChannelInfo);
begin
  m_SoundRecdInfo := ChannelInfo;
  //self.RecordingTimer.Enabled := False;
  m_SoundRecdInfo.strCurrRecordingFileName := '' ;
  GlobalDM.LogManage.InsertLog('�Է��һ�');
  SaveRecordInfo(false,'δ��');
  if Assigned(m_OnLogEvent) then
    m_OnLogEvent('�Է��һ�');
end;



procedure TFrmRecordTel.SaveRecordInfo(bIsDialed: boolean;strRemark: string);
begin
  try
    m_TelRecord.Clear ;
    m_TelRecord.strGUID :=  NewGUID;
    m_TelRecord.strDestTel :=  m_SoundRecdInfo.strDestTel ;
    m_TelRecord.strUserNumber := GlobalDM.DutyUser.strDutyNumber ;
    m_TelRecord.strUserName  :=  GlobalDM.DutyUser.strDutyName ;
    m_TelRecord.strFileName := m_SoundRecdInfo.strCurrRecordingFileName;
    m_TelRecord.dtCreateTime := now  ;
    m_TelRecord.dtStartTime :=  self.m_dtRecordingStart;
    m_TelRecord.dtEndTime := now  ;
    m_TelRecord.nCallDirection := Ord(m_SoundRecdInfo.CurrCallDirection) ;
    m_TelRecord.bIsDialed :=  bIsDialed ;
    m_TelRecord.strRemark := strRemark ;
    m_RecordTelUtil.Insert(m_TelRecord);
  except
   on e:Exception do
   begin
    GlobalDM.LogManage.InsertLog('����绰��¼ʧ��:' +  e.Message );
   end;

  end;
end;

end.
