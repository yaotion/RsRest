unit uFrmCreateWaitWorkPlan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,uWaitWork,uWaitWorkMgr,uGlobalDM,uTFSystem,
  DateUtils,uSaftyEnum,uDBWorkShop,uDBTrainJiaolu,uWorkShop,uTrainJiaolu;

type
  TFrmCreateWaitWorkPlan = class(TForm)
    lbl4: TLabel;
    dtpJiaoBanDay: TDateTimePicker;
    dtpJiaoBanTime: TDateTimePicker;
    dtpHouBanTime: TDateTimePicker;
    dtpHouBanDay: TDateTimePicker;
    lbl3: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    lbl1: TLabel;
    edtCheCi: TEdit;
    lbl2: TLabel;
    edtRoom: TEdit;
    lbl5: TLabel;
    cbbCheJian: TComboBox;
    lbl6: TLabel;
    cbbJiaoLu: TComboBox;
    edtJiaoLuNickName: TEdit;
    lbl7: TLabel;
    chk_UseCallWork: TCheckBox;
    chk_UseWaitWork: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbbCheJianChange(Sender: TObject);
    procedure chk_UseCallWorkClick(Sender: TObject);
    procedure edtCheCiExit(Sender: TObject);
    procedure edtCheCiChange(Sender: TObject);
    procedure chk_UseWaitWorkClick(Sender: TObject);

  private
         //车间数据库操作
    m_DBWorkShop:TRsDBWorkShop;
    //交路数据库操作
    m_DBTrainJiaoLu:TRsDBTrainJiaolu;
    //车间数组
    m_WorkShopAry:TRsWorkShopArray;
    //交路数组
    m_JiaoLuAry:TRsTrainJiaoluArray;
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
    {功能:初始化车间}
    procedure InitWorkShop(strWorkShopGUID:string='');
    {功能:初始化交路}
    procedure InitJiaoLu(strJiaoLuGUID:string='');
  private
    {待乘管理}
    m_waitWorkMgr:TWaitWorkMgr;
    {待乘计划}
    m_plan:TWaitWorkPlan;

  end;

  {功能:创建计划}
  function CreateWaitWorkPlanNoTrainman(out plan:TWaitWorkPlan;strRoomNum:string):Boolean;
implementation

uses
  utfPopBox ;

{$R *.dfm}
function CreateWaitWorkPlanNoTrainman(out plan:TWaitWorkPlan;strRoomNum:string):Boolean;
var
  frm:TFrmCreateWaitWorkPlan;
begin
  result := False;
  frm:= TFrmCreateWaitWorkPlan.Create(nil);
  try
    plan := TWaitWorkPlan.Create;
    plan.strPlanGUID := NewGUID;
    plan.ePlanState := psPublish;
    plan.ePlanType := TWWPT_LOCAL ;
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
procedure TFrmCreateWaitWorkPlan.InitJiaoLu(strJiaoLuGUID:string);
var
  i:Integer;
  strWorkShopGUID:string;
begin
  if cbbCheJian.ItemIndex = -1 then Exit;
  strWorkShopGUID := m_WorkShopAry[cbbCheJian.ItemIndex].strWorkShopGUID;
  m_DBTrainJiaoLu.GetTrainJiaoluArrayOfWorkShop(strWorkShopGUID,m_JiaoLuAry);
  cbbJiaoLu.Items.Clear;
  for i := 0 to Length(m_JiaoLuAry) - 1 do
  begin
    cbbJiaoLu.Items.Add(m_JiaoLuary[i].strTrainJiaoluName);
    if m_JiaoLuary[i].strTrainJiaoluGUID = strJiaoLuGUID then
      cbbJiaoLu.ItemIndex := i;
  end;
end;

procedure TFrmCreateWaitWorkPlan.InitWorkShop(strWorkShopGUID:string);
var
  i:Integer;
begin
  m_DBWorkShop.GetWorkShopOfSite(GlobalDM.SiteInfo.strSiteGUID, m_WorkShopAry);
  cbbCheJian.Items.Clear;
  for i := 0 to Length(m_WorkShopAry) - 1 do
  begin
    cbbCheJian.Items.Add(m_WorkShopAry[i].strWorkShopName) ;
    if m_WorkShopAry[i].strWorkShopGUID = strWorkShopGUID then
      cbbCheJian.ItemIndex := i;
  end;
  
end;

procedure TFrmCreateWaitWorkPlan.UseCallWorkTime(bUse: Boolean);
begin
  dtpJiaoBanDay.Enabled := bUse;
  dtpJiaoBanTime.Enabled := bUse;

  if bUse then
  begin
    dtpJiaoBanDay.Date := DateOf(GlobalDM.GetNow);
    dtpJiaoBanTime.Time := TimeOf(IncHour(GlobalDM.GetNow,4));
  end;
end;

procedure TFrmCreateWaitWorkPlan.UseWaitWorkTime(bUse:Boolean);
begin
  dtpHouBanDay.Enabled := bUse;
  dtpHouBanTime.Enabled := bUse;
  if bUse then
  begin
    dtpHouBanDay.Date := DateOf(GlobalDM.GetNow);
    dtpHouBanTime.Time := TimeOf(GlobalDM.GetNow);
  end;

end;

function TFrmCreateWaitWorkPlan.GetCallWorkTime: TDateTime;
begin
  result :=   AssembleDateTime(dtpJiaoBanDay.Date,dtpJiaoBanTime.Time) ;
end;

function TFrmCreateWaitWorkPlan.GetWaitWorkTime: TDateTime;
begin
  result := AssembleDateTime(dtpHouBanDay.Date,dtpHouBanTime.Time);
end;

procedure TFrmCreateWaitWorkPlan.btnCancelClick(Sender: TObject);
begin
  Self.ModalResult := mrCancel;
end;

procedure TFrmCreateWaitWorkPlan.btnOKClick(Sender: TObject);
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
  m_Plan.dtWaitWorkTime:= dtpHouBanDay.DateTime;
  
  if cbbCheJian.ItemIndex >= 0 then
  begin
    m_Plan.strCheJianGUID := m_WorkShopAry[cbbCheJian.ItemIndex].strWorkShopGUID;
    m_plan.strCheJianName := m_WorkShopAry[cbbCheJian.ItemIndex].strWorkShopName;
  end;
  if cbbJiaoLu.ItemIndex >= 0 then
  begin
    m_Plan.strTrainJiaoLuGUID := m_JiaoLuAry[cbbJiaoLu.ItemIndex].strTrainJiaoLuGUID;
    m_plan.strTrainJiaoLuName := m_JiaoLuAry[cbbJiaoLu.ItemIndex].strTrainJiaoLuName;
  end;
  m_plan.strTrainJiaoLuNickName := Trim(edtJiaoLuNickName.Text);
  
  for i := 0 to 3 do
  begin
    m_plan.AddNewTrianman('','','');
  end;
  Self.ModalResult := mrOk;
end;

procedure TFrmCreateWaitWorkPlan.cbbCheJianChange(Sender: TObject);
begin
  InitJiaoLu();
end;

function TFrmCreateWaitWorkPlan.CheckInPut: Boolean;
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
  if (chk_UseCallWork.Checked ) and (chk_UseWaitWork.Checked) then
  begin
    if GetWaitWorkTime >= GetCallWorkTime then
    begin
      TtfPopBox.ShowBox('叫班时间必须大于候班时间');
      Exit;
    end;
  end;

  Result := True;
end;
procedure TFrmCreateWaitWorkPlan.chk_UseCallWorkClick(Sender: TObject);
begin
  UseCallWorkTime(chk_UseCallWork.Checked);
end;

procedure TFrmCreateWaitWorkPlan.chk_UseWaitWorkClick(Sender: TObject);
begin
  UseWaitWorkTime(chk_UseWaitWork.Checked);
end;

procedure TFrmCreateWaitWorkPlan.edtCheCiChange(Sender: TObject);
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

procedure TFrmCreateWaitWorkPlan.edtCheCiExit(Sender: TObject);
var
  strTrainNo:string;
  waitPlan:TWaitWorkPlan;
begin
  strTrainNo := Trim(edtCheCi.Text);
  if strTrainNo = '' then Exit;
  waitPlan:=TWaitWorkPlan.Create;
  try
    if m_WaitWorkMgr.GetLastWaitPlan_ByTrainNo(strTrainNo,waitPlan) = False then Exit;
    chk_UseCallWork.Checked := True;
    dtpJiaoBanTime.Time := DateUtils.TimeOf(waitPlan.dtCallWorkTime);
    if TimeOf(waitPlan.dtCallWorkTime ) < TimeOf(GlobalDM.GetNow) then
    begin
      dtpJiaoBanDay.Date := DateOf(GlobalDM.GetNow) + 1;
    end;
  finally
    waitPlan.Free;
  end;
end;

procedure TFrmCreateWaitWorkPlan.FormCreate(Sender: TObject);
begin
  m_waitWorkMgr := TWaitWorkMgr.GetInstance(GlobalDM.LocalADOConnection);
  m_DBWorkShop:=TRsDBWorkShop.Create(GlobalDM.LocalADOConnection);
  m_DBTrainJiaoLu:=TRsDBTrainJiaolu.Create(GlobalDM.LocalADOConnection);
end;

procedure TFrmCreateWaitWorkPlan.FormDestroy(Sender: TObject);
begin
  m_DBWorkShop.Free;
  m_DBTrainJiaoLu.Free;
end;

procedure TFrmCreateWaitWorkPlan.FormShow(Sender: TObject);
var
  dtNow:TDateTime;
begin
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
   InitWorkShop(m_Plan.strCheJianGUID);
  InitJiaoLu(m_Plan.strTrainJiaoLuGUID);
end;

end.
