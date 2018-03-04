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
       {电话录音计时}
    m_dtRecordingStart: TDateTime;
    {电话录音收集类}
    m_QNVControl : TQNVControl;
    {电话录音结果}
    m_SoundRecdInfo: RChannelInfo;
    {功能:开始呼叫}
    procedure OnCallBeginNotify(const ChannelInfo : RChannelInfo;var bRecording:Boolean);
    {功能:呼叫结束,添加语音通话记录}
    procedure OnCallEndNotify(const ChannelInfo : RChannelInfo);

    {功能:对方开始呼叫}
    procedure OnDestCallBeginNotify(const ChannelInfo : RChannelInfo);
    {功能:对方开始呼叫结束}
    procedure OnDestCallEndNotify(const ChannelInfo : RChannelInfo);

    {更新录音盒状态显示}
    procedure DoUpdateRecordingState();
    {功能:保存录音信息}
    procedure SaveRecordInfo(bIsDialed: boolean;strRemark: string);
  private
     // 回调
    m_OnLogEvent:TOnEventByString;
    //录音信息类
    m_TelRecord:TTelRecord;
    //录音操作类
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
    lblRecordingBoxState.Caption := '已连接';
  end
  else
  begin
    lblRecordingBoxState.Caption := '未连接';

    GlobalDM.LogManage.InsertLog('电话录音设备未连接，通话录音功能将无法使用。');
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
  GlobalDM.LogManage.InsertLog('录音开始...') ;
  lblRecordingBoxState.Caption := '录音开始...';
  if Assigned(m_OnLogEvent) then
    m_OnLogEvent('录音开始');
  //self.lblSoundRecording.Caption := '00:00';
  //RecordingTimer.Enabled := True;
end;

procedure TFrmRecordTel.OnCallEndNotify(const ChannelInfo: RChannelInfo);
begin
  m_SoundRecdInfo := ChannelInfo;
  //self.RecordingTimer.Enabled := False;
  GlobalDM.LogManage.InsertLog(Format('录音完毕:%s', [m_SoundRecdInfo.strCurrRecordingFileName]));
  SaveRecordInfo(True,'');
  if Assigned(m_OnLogEvent) then
    m_OnLogEvent('录音完毕');
end;

procedure TFrmRecordTel.OnDestCallBeginNotify(const ChannelInfo: RChannelInfo);
begin
  m_SoundRecdInfo := ChannelInfo;
  self.m_dtRecordingStart := now();
  GlobalDM.LogManage.InsertLog('接到来电'+ChannelInfo.strDestTel) ;
  lblRecordingBoxState.Caption := '接到来电...';
  if Assigned(m_OnLogEvent) then
    m_OnLogEvent('接到来电');
end;

procedure TFrmRecordTel.OnDestCallEndNotify(const ChannelInfo: RChannelInfo);
begin
  m_SoundRecdInfo := ChannelInfo;
  //self.RecordingTimer.Enabled := False;
  m_SoundRecdInfo.strCurrRecordingFileName := '' ;
  GlobalDM.LogManage.InsertLog('对方挂机');
  SaveRecordInfo(false,'未接');
  if Assigned(m_OnLogEvent) then
    m_OnLogEvent('对方挂机');
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
    GlobalDM.LogManage.InsertLog('保存电话记录失败:' +  e.Message );
   end;

  end;
end;

end.
