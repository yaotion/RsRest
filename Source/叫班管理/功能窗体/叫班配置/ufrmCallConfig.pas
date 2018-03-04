unit ufrmCallConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Mask, RzEdit, ComCtrls, ExtCtrls,uTFSystem, Spin,
  uRoomCallApp;

type
  TfrmCallConfig = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    ComboBox1: TComboBox;
    Label15: TLabel;
    Label16: TLabel;
    Label18: TLabel;
    btnClose: TSpeedButton;
    btnSave: TSpeedButton;
    ColorDialog1: TColorDialog;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    edtNightEnd: TRzDateTimeEdit;
    edtNightBegin: TRzDateTimeEdit;
    btnTestLine: TButton;
    timerTestLine: TTimer;
    checkCheckAudioLine: TCheckBox;
    CheckWaitforConfirm: TCheckBox;
    sedtDialVolume: TSpinEdit;
    sedtDayTalkVolume: TSpinEdit;
    sEdtDialIntervel: TSpinEdit;
    sEdtCallDelay: TSpinEdit;
    sEdtRecallIntervel: TSpinEdit;
    SpinEdit4: TSpinEdit;
    sEdtNightTalkVolume: TSpinEdit;
    sEdtPortNum: TSpinEdit;
    lbl1: TLabel;
    seUnOutRoomNotify: TSpinEdit;
    lbl2: TLabel;
    lbl3: TLabel;
    seVoiceStoreDays: TSpinEdit;
    lbl4: TLabel;
    procedure btnCloseClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure pColorOutTimeDblClick(Sender: TObject);
    procedure timerTestLineTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TabSheet1Show(Sender: TObject);
  private
    {功能:校验输入}
    function CheckData():Boolean;
    {功能:保存设置}
    procedure SaveData();
    {功能:显示配置}
    procedure InitUIData();
  private
    //公寓叫班逻辑
    m_RoomCallApp:TRoomCallApp;

  end;

  {功能:显示叫班配置}
  function ShowCallConfig():Boolean;

implementation
uses MMSystem;
{$R *.dfm}
function ShowCallConfig():Boolean;
var
  frm: TfrmCallConfig;
begin
  result := False;
  frm:= TfrmCallConfig.Create(nil);
  try
    if frm.ShowModal = mrOk then
      result := True;
  finally
    frm.Free;
  end;
end;

procedure TfrmCallConfig.btnCloseClick(Sender: TObject);
begin
 Close;
end;

procedure TfrmCallConfig.btnSaveClick(Sender: TObject);
begin
  if ComboBox1.ItemIndex = 0 then
  begin
    if Application.MessageBox('"串口"通讯类型只适用于安装调试，您确定要这样设定吗？','提示',MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then exit;
  end;
  SaveData();

  ModalResult := mrOk;
end;

function TfrmCallConfig.CheckData: Boolean;
begin
  Result := False;
end;

procedure TfrmCallConfig.FormCreate(Sender: TObject);
begin
  m_RoomCallApp:=TRoomCallApp.GetInstance;
end;

procedure TfrmCallConfig.InitUIData;
begin
  with m_RoomCallApp do
  begin
    sEdtPortNum.Value := CallConfig.nPort;
    ComboBox1.ItemIndex := CallConfig.nComType;
    sedtDialVolume.Value := CallConfig.nDialVolume;
    sedtDayTalkVolume.Value := CallConfig.nDayTalkVolume;
    sEdtDialIntervel.Value := CallConfig.nDialInterval;
    sEdtCallDelay.Value := CallConfig.nCallDelay;
    sEdtRecallIntervel.Value := CallConfig.nReCallInterval;
    seUnOutRoomNotify.value := callConfig.nUnOutRoomNotifyInterval;
    if 1 = CallConfig.nAutoCheckAudioLine  then
      checkCheckAudioLine.Checked := True
    else
      checkCheckAudioLine.Checked := False;
    if 1 = CallConfig.nWaitConfirm then
      CheckWaitforConfirm.Checked := True
    else
      CheckWaitforConfirm.Checked := False;

    edtNightBegin.Time := CallConfig.dtNightStartTime;
    edtNightEnd.Time := CallConfig.dtNightEndTime;
    sEdtNightTalkVolume.Value := CallConfig.nNightTalkVolume;
    seVoiceStoreDays.Value :=  CallConfig.nVoiceStoreDays;
  end;
end;

procedure TfrmCallConfig.pColorOutTimeDblClick(Sender: TObject);
begin
  if ColorDialog1.Execute then
  begin
    TPanel(Sender).Color := ColorDialog1.Color;
  end;
end;

procedure TfrmCallConfig.SaveData;
begin
  with m_RoomCallApp do
  begin
    CallConfig.nPort := sEdtPortNum.Value;
    CallConfig.nComType := ComboBox1.ItemIndex;
    CallConfig.nDialVolume := sedtDialVolume.Value;
    CallConfig.nDayTalkVolume := sedtDayTalkVolume.Value;
    CallConfig.nDialInterval := sEdtDialIntervel.Value;
    CallConfig.nCallDelay := sEdtCallDelay.Value;
    CallConfig.nReCallInterval := sEdtRecallIntervel.Value;
    CallConfig.nUnOutRoomNotifyInterval := seUnOutRoomNotify.value;
    if checkCheckAudioLine.Checked = True then
      CallConfig.nAutoCheckAudioLine := 1
    else
      CallConfig.nAutoCheckAudioLine := 0;
    if CheckWaitforConfirm.Checked = True then
      CallConfig.nWaitConfirm := 1
    else
      CallConfig.nWaitConfirm := 0;

    CallConfig.dtNightStartTime := edtNightBegin.Time;
    CallConfig.dtNightEndTime := edtNightEnd.Time;
    CallConfig.nNightTalkVolume := sEdtNightTalkVolume.Value;
    CallConfig.nVoiceStoreDays := seVoiceStoreDays.Value;
  end;

end;

procedure TfrmCallConfig.TabSheet1Show(Sender: TObject);
begin
  InitUIData();
end;

procedure TfrmCallConfig.timerTestLineTimer(Sender: TObject);
var
  i,nMidValue,nMaxValue: Integer;
begin

end;

end.

