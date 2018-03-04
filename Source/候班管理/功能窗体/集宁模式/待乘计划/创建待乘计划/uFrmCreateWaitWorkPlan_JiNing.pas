unit uFrmCreateWaitWorkPlan_JiNing;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,uWaitWork,uWaitWorkMgr,uGlobalDM,uTFSystem,
  DateUtils,uSaftyEnum;

type
  TTFrmCreateWaitWorkPlan_JiNing = class(TForm)
    lbl3: TLabel;
    chk_UseWaitWork: TCheckBox;
    chk_UseCallWork: TCheckBox;
    lbl4: TLabel;
    dtpJiaoBanDay: TDateTimePicker;
    dtpHouBanDay: TDateTimePicker;
    dtpHouBanTime: TDateTimePicker;
    dtpJiaoBanTime: TDateTimePicker;
    btnCancel: TButton;
    btnOK: TButton;
    edtRoom: TEdit;
    edtCheCi: TEdit;
    lbl2: TLabel;
    lbl1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure edtCheCiChange(Sender: TObject);
    procedure chk_UseWaitWorkClick(Sender: TObject);
    procedure chk_UseCallWorkClick(Sender: TObject);
  private
    {启用叫班时间}
    procedure UseCallWorkTime(bUse:Boolean);
    {启用候班时间}
    procedure UseWaitWorkTime(bUse:Boolean);
    {功能:校验输入}
    function CheckInPut(): Boolean;
    {功能:获取叫班时间}
    function GetCallWorkTime():TDatetime;
    {功能:获取候班时间}
    function GetWaitWorkTime():TDateTime;
  private
    {待乘管理}
    m_waitWorkMgr:TWaitWorkMgr;
    {待乘计划}
    m_plan:TWaitWorkPlan;

  end;

  {功能:创建计划}
  function CreateWaitWorkPlanNoTrainman_JiNing(out plan:TWaitWorkPlan;
    strRoomNum:string;strCheCi:string=''):Boolean;

var
  TFrmCreateWaitWorkPlan_JiNing: TTFrmCreateWaitWorkPlan_JiNing;

implementation

uses
  utfPopBox ;


function CreateWaitWorkPlanNoTrainman_JiNing(out plan:TWaitWorkPlan;strRoomNum:string;strCheCi:string):Boolean;
var
  frm:TTFrmCreateWaitWorkPlan_JiNing;
begin
  result := False;
  frm:= TTFrmCreateWaitWorkPlan_JiNing.Create(nil);
  try
    plan := TWaitWorkPlan.Create;
    plan.strPlanGUID := NewGUID;
    plan.ePlanState := psPublish;
    plan.ePlanType := TWWPT_LOCAL ;
    plan.strCheCi := strCheCi ;
    plan.strRoomNum := strRoomNum;
    frm.m_plan := plan;
    if frm.ShowModal = mrOk then
    begin
      frm.m_waitWorkMgr.AddPlan(plan);
      Result := True;
    end
    else
    begin
      FreeAndNil(plan);
    end;
  finally
    frm.Free;
  end;

end;

{$R *.dfm}

procedure TTFrmCreateWaitWorkPlan_JiNing.btnCancelClick(Sender: TObject);
begin
  Self.ModalResult := mrCancel;
end;

procedure TTFrmCreateWaitWorkPlan_JiNing.btnOKClick(Sender: TObject);
var
  i:Integer;
begin
  if CheckInPut = False  then Exit;
  m_plan.strCheCi := trim(edtCheCi.Text);
  m_plan.strRoomNum := Trim(edtRoom.Text);
  m_plan.dtWaitWorkTime := GetWaitWorkTime;
  m_plan.bNeedSyncCall := False;
  m_plan.dtCallWorkTime := 0;
  if chk_UseCallWork.Checked then
  begin
    m_plan.dtCallWorkTime := GetCallWorkTime;
    m_plan.bNeedSyncCall := True;
  end;

  if chk_UseWaitWork.Checked then
  begin
    m_Plan.bNeedRest := True;
  end;


  m_Plan.strCheJianGUID := '';
  m_plan.strCheJianName := '';


  m_Plan.strTrainJiaoLuGUID := '';
  m_plan.strTrainJiaoLuName := '';

  m_plan.strTrainJiaoLuNickName := '';
  
  for i := 0 to 3 do
  begin
    m_plan.AddNewTrianman('','','');
  end;
  Self.ModalResult := mrOk;
end;

function TTFrmCreateWaitWorkPlan_JiNing.CheckInPut: Boolean;
begin
  result := False;
  {if Trim(edtCheCi.Text) = '' then
  begin
    TtfPopBox.ShowBox('车次不能为空!');
    edtCheCi.SetFocus;
    Exit;
  end;  }
  if Trim(edtRoom.Text) = '' then
  begin
    TtfPopBox.ShowBox('房间号不能为空!');
    edtRoom.SetFocus;
    Exit;
  end;
  {
  if (chk_UseCallWork.Checked ) and (chk_UseWaitWork.Checked) then
  begin
    if GetWaitWorkTime >= GetCallWorkTime then
    begin
      TtfPopBox.ShowBox('叫班时间必须大于候班时间');
      Exit;
    end;
  end;
  }

  Result := True;
end;

procedure TTFrmCreateWaitWorkPlan_JiNing.chk_UseCallWorkClick(Sender: TObject);
begin
  UseCallWorkTime(chk_UseCallWork.Checked);
end;

procedure TTFrmCreateWaitWorkPlan_JiNing.chk_UseWaitWorkClick(Sender: TObject);
begin
  UseWaitWorkTime(chk_UseWaitWork.Checked);
end;

procedure TTFrmCreateWaitWorkPlan_JiNing.edtCheCiChange(Sender: TObject);
var
  strTrainNo:string;
  waitPlan:TWaitWorkPlan;
begin
  strTrainNo := Trim(edtCheCi.Text);
  //if (strTrainNo = '') or (Length(strTrainNo) < 3) then Exit;
  waitPlan:=TWaitWorkPlan.Create;
  try
    if m_WaitWorkMgr.GetLastWaitPlan_ByTrainNo(strTrainNo,waitPlan) = False then Exit;
    chk_UseCallWork.Checked := waitPlan.bNeedSyncCall;
    chk_UseWaitWork.Checked := waitPlan.bNeedRest;

    if chk_UseCallWork.Checked then
    begin
      dtpJiaoBanTime.Time := DateUtils.TimeOf(waitPlan.dtCallWorkTime);
      if TimeOf(waitPlan.dtCallWorkTime ) < TimeOf(Now) then
      begin
        dtpJiaoBanDay.Date := DateOf(GlobalDM.GetNow) + 1;
      end;
    end;

    if chk_UseCallWork.Checked then
    begin
      if TimeOf(waitPlan.dtWaitWorkTime ) < TimeOf(waitPlan.dtCallWorkTime) then
      begin
        dtpHouBanDay.Date := dtpJiaoBanDay.Date;
      end;
    end;
    if chk_UseCallWork.Checked then
    begin
      if TimeOf(waitPlan.dtCallWorkTime ) < TimeOf(waitPlan.dtWaitWorkTime) then
      begin
        dtpJiaoBanDay.Date := DateOf(GlobalDM.GetNow) + 1;
      end;
    end;

    dtpHouBanTime.Time := DateUtils.TimeOf(waitPlan.dtWaitWorkTime);
  finally
    waitPlan.Free;
  end;
end;

procedure TTFrmCreateWaitWorkPlan_JiNing.FormCreate(Sender: TObject);
begin
  m_waitWorkMgr := TWaitWorkMgr.GetInstance(GlobalDM.LocalADOConnection);
end;

procedure TTFrmCreateWaitWorkPlan_JiNing.FormDestroy(Sender: TObject);
begin
  ;
end;

procedure TTFrmCreateWaitWorkPlan_JiNing.FormShow(Sender: TObject);
var
  dtNow:TDateTime;
begin
  edtCheCi.Text := m_plan.strCheCi ;
  edtRoom.Text := m_plan.strRoomNum;
  if edtRoom.Text = '' then
  begin
    edtRoom.Enabled := True;
  end;
  dtNow := GlobalDM.GetNow;
  dtpHouBanDay.Date := DateOf(dtNow);
  dtpHouBanTime.Time :=TimeOf( dtNow);
  dtpJiaoBanDay.Date := DateOf(dtNow);
  dtpJiaoBanTime.Time := TimeOf(dtNow);
end;

function TTFrmCreateWaitWorkPlan_JiNing.GetCallWorkTime: TDatetime;
begin
  result :=   AssembleDateTime(dtpJiaoBanDay.Date,dtpJiaoBanTime.Time) ;
end;

function TTFrmCreateWaitWorkPlan_JiNing.GetWaitWorkTime: TDateTime;
begin
  result := AssembleDateTime(dtpHouBanDay.Date,dtpHouBanTime.Time);
end;

procedure TTFrmCreateWaitWorkPlan_JiNing.UseCallWorkTime(bUse: Boolean);
begin
  dtpJiaoBanDay.Enabled := bUse;
  dtpJiaoBanTime.Enabled := bUse;

  if bUse then
  begin
//    dtpJiaoBanDay.Date := DateOf(GlobalDM.GetNow);
//    dtpJiaoBanTime.Time := TimeOf(IncHour(GlobalDM.GetNow,4));
  end;
end;

procedure TTFrmCreateWaitWorkPlan_JiNing.UseWaitWorkTime(bUse: Boolean);
begin
  dtpHouBanDay.Enabled := bUse;
  dtpHouBanTime.Enabled := bUse;
  if bUse then
  begin
    dtpHouBanDay.Date := DateOf(GlobalDM.GetNow);
    dtpHouBanTime.Time := TimeOf(GlobalDM.GetNow);
  end;
end;

end.
