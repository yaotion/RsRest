unit uFrmEditWaitWork;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls,uWaitWork,uDBWaitWork,uGlobalDM,
  uTrainman,ufrmTextInput,DateUtils, Grids, AdvObj, BaseGrid, AdvGrid,uTFSystem,
  uWaitWorkMgr,uSaftyEnum,uDBWorkShop,uDBTrainJiaolu,uWorkShop,uTrainJiaolu,
  uDBLocalTrainman,uPubFun;
type
  TFrmEditWaitWork = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    edtCheCi: TEdit;
    edtRoom: TEdit;
    dtpHouBanDay: TDateTimePicker;
    dtpJiaoBanDay: TDateTimePicker;
    dtpHouBanTime: TDateTimePicker;
    dtpJiaoBanTime: TDateTimePicker;
    GridTrainman: TAdvStringGrid;
    lbl5: TLabel;
    cbbCheJian: TComboBox;
    lbl6: TLabel;
    cbbJiaoLu: TComboBox;
    lbl7: TLabel;
    edtJiaoLuNickName: TEdit;
    chk_UseCallWork: TCheckBox;
    chk_UseWaitWork: TCheckBox;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure gridTrainmanCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure gridTrainmanEditCellDone(Sender: TObject; ACol, ARow: Integer);
    procedure GridTrainmanGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure FormDestroy(Sender: TObject);
    procedure cbbCheJianChange(Sender: TObject);
    procedure chk_UseCallWorkClick(Sender: TObject);
    procedure edtCheCiExit(Sender: TObject);
    procedure edtCheCiChange(Sender: TObject);
    procedure chk_UseWaitWorkClick(Sender: TObject);
  private
    //候班计划
    m_Plan:TWaitWorkPlan;
    //人员数据库操作
    m_DBTrainman :TRsDBLocalTrainman;
    //待乘管理
    m_WaitWorkMgr:TWaitWorkMgr;
    //是否修改计划
    m_bModifyMode:Boolean;
     //车间数据库操作
    m_DBWorkShop:TRsDBWorkShop;
    //交路数据库操作
    m_DBTrainJiaoLu:TRsDBTrainJiaolu;
    //车间数组
    m_WorkShopAry:TRsWorkShopArray;
    //交路数组
    m_JiaoLuAry:TRsTrainJiaoluArray;
    //新增人员
    m_newTrainman:RRsTrainman;
  private
    {启用候班时间}
    procedure UseWaitWorkTime(bUse:Boolean);
    {启用叫班时间}
    procedure UseCallWorkTime(bUse:Boolean);
    {功能:更新计划属性值}
    procedure SetPlanValues();
    {功能:校验用户输入}
    function CheckInPut():Boolean;
    {功能:填充人员信息}
    procedure Fill_lvTrainman_Line(item:TListItem;trainman:RRsTrainman);
    {功能:判断人员已有候班计划}
    function bInPlan(strTrainmanGUID:string):Boolean;
    {功能:初始化grid}
    procedure InitGrid();
    {功能:清空Grid行数据}
    procedure ClearGridLine(nRow:Integer);
    {功能:填充Grid行数据}
    procedure SetGridLineData(nRow:Integer;trainman:RRsTrainman);
    {功能:获取待乘时间}
    function GetWaitWorkTime():TDateTime;
    {功能:获取叫班时间}
    function GetCallWorkTime():TDateTime;
     {功能:初始化车间}
    procedure InitWorkShop(strWorkShopGUID:string='');
    {功能:初始化交路}
    procedure InitJiaoLu(strJiaoLuGUID:string='');
  public
    { Public declarations }
  end;
  {功能:新增候班计划}
  function CreateWaitWorkPlan(out plan:TWaitWorkPlan):Boolean;
  {功能:修改候班计划}
  function ModifyWaitWorkPlan(var plan:TWaitWorkPlan):Boolean;
  {功能:创建候班计划根据人员车次信息}
  function CreateWaitWorkPlan_TrainNo_Traniman(trainman:RRsTrainman;strTrainNo:string; out plan:TWaitWorkPlan):Boolean;
  {功能:修改候班计划,增加人员}
  function ModifyWaitWorkPlan_Trainman(trainman:RRsTrainman;var  plan:TWaitWorkPlan):Boolean;

implementation

uses
  ufrmQuestionBox;


{$R *.dfm}

{功能:创建候班计划根据人员车次信息}
function CreateWaitWorkPlan_TrainNo_Traniman(trainman:RRsTrainman;strTrainNo:string; out plan:TWaitWorkPlan):Boolean;
var
  frm:TFrmEditWaitWork;
  i:Integer;
begin
  Result := False;

  plan := TWaitWorkPlan.Create;
  plan.strPlanGUID := NewGUID();
  plan.dtWaitWorkTime := GlobalDM.GetNow();
  plan.dtCallWorkTime := GlobalDM.GetNow();
  if GlobalDM.bUseByPaiBan = True then
    plan.ePlanType := TWWPT_ASSIGN
  else
    plan.ePlanType := TWWPT_LOCAL;
  plan.ePlanState := psPublish;
  plan.strCheCi := strTrainNo;
  for i := 0 to 3 do
  begin
    plan.AddNewTrianman('','','');
  end;
  frm:=TFrmEditWaitWork.Create(nil);
  try
    frm.m_Plan := plan;
    frm.m_newTrainman := trainman;
    if frm.ShowModal() = mrOk then
    begin
      frm.m_WaitWorkMgr.AddPlan(plan);
      result := True;
      Exit;
    end
    else
    begin
      FreeAndNil(plan);
    end;
  finally
    frm.Free;
  end;
end;
 {功能:新增候班计划}
function CreateWaitWorkPlan(out plan:TWaitWorkPlan):Boolean;
var
  frm:TFrmEditWaitWork;
  i:Integer;
begin
  Result := False;
  plan := TWaitWorkPlan.Create;
  plan.strPlanGUID := NewGUID();
  plan.dtWaitWorkTime := GlobalDM.GetNow();
  plan.dtCallWorkTime := GlobalDM.GetNow();
  if GlobalDM.bUseByPaiBan = True then
    plan.ePlanType := TWWPT_ASSIGN
  else
    plan.ePlanType := TWWPT_LOCAL;
  plan.ePlanState := psPublish;
  for i := 0 to 3 do
  begin
    plan.AddNewTrianman('','','');
  end;
  frm:=TFrmEditWaitWork.Create(nil);
  try
    frm.m_Plan := plan;
    if frm.ShowModal() = mrOk then
    begin
      frm.m_WaitWorkMgr.AddPlan(plan);
      result := True;
      Exit;
    end
    else
    begin
      FreeAndNil(plan);
    end;
  finally
    frm.Free;
  end;
end;
{功能:修改候班计划}
function ModifyWaitWorkPlan(var plan:TWaitWorkPlan):Boolean;
var
  frm:TFrmEditWaitWork;
begin
  Result := False;
  frm:=TFrmEditWaitWork.Create(nil);
  try
    frm.m_bModifyMode := True;
    frm.m_Plan := plan;
    if frm.ShowModal() = mrOk then
    begin
      frm.m_WaitWorkMgr.ModifyPlan(plan);
      result := True;
    end;
  finally
    frm.Free;
  end;
end;

function ModifyWaitWorkPlan_Trainman(trainman:RRsTrainman;var  plan:TWaitWorkPlan):Boolean;
{功能:修改候班计划,增加人员}
var
  frm:TFrmEditWaitWork;
begin
  Result := False;
  frm:=TFrmEditWaitWork.Create(nil);
  try
    frm.m_bModifyMode := True;
    frm.m_Plan := plan;
    frm.m_newTrainman := trainman;
    if frm.ShowModal() = mrOk then
    begin
      frm.m_WaitWorkMgr.ModifyPlan(frm.m_Plan);
      result := True;
    end;
  finally
    frm.Free;
  end;
end;

procedure TFrmEditWaitWork.gridTrainmanCanEditCell(Sender: TObject; ARow,
  ACol: Integer; var CanEdit: Boolean);
begin
  CanEdit := False;
  if ACol = 2 then
  begin
    CanEdit := True;
  end;

end;

procedure TFrmEditWaitWork.gridTrainmanEditCellDone(Sender: TObject; ACol,
  ARow: Integer);
var
  strGH:string;
  trainman:RRsTrainman;
begin
  ClearGridLine(ARow);
  strGH := gridTrainman.Cells[2,ARow] ;
  if strGH = '' then Exit;
  
  if m_DBTrainman.GetTrainmanByNumber(strGH,trainman) = False then
  begin
    ShowMessage('无效的工号!');
    gridTrainman.Cells[2,ARow] := '';
    GridTrainman.FocusCell(2,ARow);
    Exit;
  end;
  if bInPlan(trainman.strTrainmanGUID) = True  then
  begin
    ShowMessage(format('%s乘务员已有待乘计划',[strGH]));
    gridTrainman.Cells[2,ARow] := '';
    GridTrainman.FocusCell(2,ARow);
    Exit;
  end;
  gridTrainman.Cells[1,ARow] := trainman.strTrainmanGUID;
  GridTrainman.Cells[3,ARow] := trainman.strTrainmanName;

  gridTrainman.Invalidate;
end;

procedure TFrmEditWaitWork.GridTrainmanGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  HAlign := taCenter;
  //VAlign := vtaCenter;
end;

function TFrmEditWaitWork.bInPlan(strTrainmanGUID: string): Boolean;
var
  plan:TWaitWorkPlan;
  i:Integer;
begin
  Result := False;
  for i := 0 to m_WaitWorkMgr.planList.Count - 1 do
  begin
    plan := m_WaitWorkMgr.planList.Items[i];
    if Assigned(plan.tmPlanList.findTrainman(strTrainmanGUID)) then
    begin
      Result := True;
      Exit;
    end;
  end;

  for i := 1 to GridTrainman.RowCount do
  begin
    if GridTrainman.Cells[1,i] = strTrainmanGUID then
    begin
      Result := True;
      Exit;
    end;
  end;

end;


procedure TFrmEditWaitWork.btnCancelClick(Sender: TObject);
begin
  Self.ModalResult := mrCancel;
end;



procedure TFrmEditWaitWork.btnOKClick(Sender: TObject);
begin
  if CheckInPut = False  then Exit;
  SetPlanValues();
  
  Self.ModalResult := mrOk;
end;

procedure TFrmEditWaitWork.cbbCheJianChange(Sender: TObject);
begin
    InitJiaoLu();
end;

function TFrmEditWaitWork.CheckInPut: Boolean;
var
  strRoomNum:string;
  plan:TWaitWorkPlan;
  strErr:string;
begin
  result := False;
  {if Trim(edtCheCi.Text) = '' then
  begin
    TtfPopBox.ShowBox('车次不能为空!');
    edtCheCi.SetFocus;
    Exit;
  end;   }
  {if Trim(edtRoom.Text) = '' then
  begin
    TtfPopBox.ShowBox('房间号不能为空!');
    edtRoom.SetFocus;
    Exit;
  end; }
  (*if Trim(cbbCheJian.Text) = '' then
  begin
    TtfPopBox.ShowBox('车间不能为空!');
    cbbCheJian.Focused;
    Exit;
  end;
  if Trim(cbbJiaoLu.Text) = '' then
  begin
    TtfPopBox.ShowBox('交路不能为空!');
    cbbJiaoLu.SetFocus;
    Exit;
  end;
  if Trim(edtJiaoLuNickName.Text) ='' then
  begin
    TtfPopBox.ShowBox('交路简称不能为空!');
    edtJiaoLuNickName.SetFocus;
    Exit;
  end;
  *)

  strRoomNum := edtRoom.Text;
  if strRoomNum <> '' then
  begin
    if m_WaitWorkMgr.bRoomExist(strRoomNum) = False then
    begin
      if tfMessageBox(Format('房间管理中没有[%s]号房间,是否增加?',[strRoomNum])) = False then Exit;
      if TPubfun.CheckRoomNum(strRoomNum,strErr) = False then
      begin
        tfMessageBox(strErr,MB_ICONINFORMATION);
        Exit ;
      end;

      m_WaitWorkMgr.AddRoom(strRoomNum);
    end;
  end;
  
  if chk_UseCallWork.Checked  and chk_UseWaitWork.Checked then
  begin
    if GetWaitWorkTime >= GetCallWorkTime then
    begin
      tfMessageBox('叫班时间必须大于候班时间',MB_ICONINFORMATION);
      Exit;
    end;
  end;


  if m_bModifyMode and (m_Plan.strRoomNum = strRoomNum) then
  begin
    result := True;
    Exit;
  end;

  if strRoomNum <> ''  then
  begin
    plan :=m_WaitWorkMgr.FindPlanByRoom(strRoomNum);
    if Assigned (plan) then
    begin
      tfMessageBox('房间:[' + strRoomNum + ']已安排计划',MB_ICONINFORMATION);
      Exit;
    end;
  end;

  Result := True;
end;


procedure TFrmEditWaitWork.chk_UseCallWorkClick(Sender: TObject);
begin
  UseCallWorkTime(chk_UseCallWork.Checked);
end;


procedure TFrmEditWaitWork.chk_UseWaitWorkClick(Sender: TObject);
begin
  UseWaitWorkTime(chk_UseWaitWork.Checked);
end;

procedure TFrmEditWaitWork.ClearGridLine(nRow: Integer);
begin
  GridTrainman.Cells[1,nRow]:= '';
  GridTrainman.Cells[3,nRow]:= '';
end;

procedure TFrmEditWaitWork.edtCheCiChange(Sender: TObject);
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

procedure TFrmEditWaitWork.edtCheCiExit(Sender: TObject);
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

procedure TFrmEditWaitWork.Fill_lvTrainman_Line(item: TListItem;
  trainman: RRsTrainman);
begin
  item.Caption := trainman.strTrainmanNumber;
  item.SubItems.Clear;
  item.Data := @trainman;
  item.SubItems.Add(trainman.strTrainmanName) ;
end;

procedure TFrmEditWaitWork.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  //m_DBPlan.Free;
end;

procedure TFrmEditWaitWork.FormCreate(Sender: TObject);
begin
  m_DBTrainman := TRsDBLocalTrainman.Create(GlobalDM.LocalADOConnection);
  m_WaitWorkMgr:=TWaitWorkMgr.GetInstance(GlobalDM.LocalADOConnection);
  m_DBWorkShop:=TRsDBWorkShop.Create(GlobalDM.LocalADOConnection);
  m_DBTrainJiaoLu:=TRsDBTrainJiaolu.Create(GlobalDM.LocalADOConnection);
  InitGrid();
  m_bModifyMode:= False;
end;

procedure TFrmEditWaitWork.FormDestroy(Sender: TObject);
begin
  m_DBTrainman.Free;
  m_DBWorkShop.Free;
  m_DBTrainJiaoLu.Free;
end;

procedure TFrmEditWaitWork.InitGrid();
var
  i:Integer;
begin
  GridTrainman.HideColumn(1);
  for i := 0 to GridTrainman.RowCount - 1 do
  begin
    GridTrainman.RowHeights[i]:= 30;
  end;
  for i := 0 to GridTrainman.ColCount - 1 do
  begin
    GridTrainman.ColWidths[i] := 120;
  end;
end;

procedure TFrmEditWaitWork.InitJiaoLu(strJiaoLuGUID:string);
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

procedure TFrmEditWaitWork.InitWorkShop(strWorkShopGUID:string);
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
procedure TFrmEditWaitWork.FormShow(Sender: TObject);
var
  trainman:RRsTrainman;
  i:Integer;
  strMsg:string;
begin
  edtRoom.Text := m_Plan.strRoomNum;
  InitWorkShop(m_Plan.strCheJianGUID);
  InitJiaoLu(m_Plan.strTrainJiaoLuGUID);
  edtJiaoLuNickName.Text := m_Plan.strTrainJiaoLuNickName;
  dtpHouBanDay.Date := DateOf(m_Plan.dtWaitWorkTime);
  dtpHouBanTime.Time := TimeOf(m_Plan.dtWaitWorkTime);
  //dtpJiaoBanDay.Date := DateOf(m_Plan.dtCallWorkTime);
  //dtpJiaoBanTime.Time := TimeOf(m_Plan.dtCallWorkTime);
  dtpJiaoBanDay.DateTime := m_Plan.dtCallWorkTime;
  dtpJiaoBanTime.DateTime := m_Plan.dtCallWorkTime;

  //修改状态,切不叫班
  if (m_Plan.strPlanGUID <> '') and ( m_Plan.bNeedSyncCall = False) then
    chk_UseCallWork.Checked := False;
  UseCallWorkTime(chk_UseCallWork.Checked);


  if (m_Plan.strPlanGUID <> '') and ( m_Plan.bNeedRest = False ) then
    chk_UseWaitWork.Checked := False;
  UseWaitWorkTime(chk_UseWaitWork.Checked);


  for i := 0 to m_Plan.tmPlanList.Count - 1 do
  begin
    if m_DBTrainman.GetTrainman(m_Plan.tmPlanList.Items[i].strTrainmanGUID,trainman) = True then
    begin
      SetGridLineData(i+1,trainman);
    end;
  end;
  edtCheCi.Text := m_Plan.strCheCi;
  //edtCheCiChange(nil);
  if m_newTrainman.strTrainmanGUID <> '' then
  begin
    if m_Plan.AddTrainman(m_newTrainman,strMsg) = nil then
    begin
      tfMessageBox(strMsg,MB_ICONINFORMATION);
      Exit;
    end
  end;
  
  for i := 0 to m_Plan.tmPlanList.Count - 1 do
  begin
    if m_DBTrainman.GetTrainman(m_Plan.tmPlanList.Items[i].strTrainmanGUID,trainman) = True then
    begin
      SetGridLineData(i+1,trainman);
    end;
  end;


end;

function TFrmEditWaitWork.GetCallWorkTime: TDateTime;
begin
  result := AssembleDateTime(dtpJiaoBanDay.Date,dtpJiaoBanTime.Time);
end;

function TFrmEditWaitWork.GetWaitWorkTime: TDateTime;
begin
  result := AssembleDateTime(dtpHouBanDay.Date,dtpHouBanTime.Time);
end;

procedure TFrmEditWaitWork.SetGridLineData(nRow: Integer;
  trainman: RRsTrainman);
begin
  GridTrainman.Cells[1,nRow]:= trainman.strTrainmanGUID;
  GridTrainman.Cells[2,nRow]:= trainman.strTrainmanNumber;
  GridTrainman.Cells[3,nRow]:= trainman.strTrainmanName;
end;

procedure TFrmEditWaitWork.SetPlanValues;
var
  i:Integer;
begin
  m_Plan.strCheCi := Trim(edtCheCi.Text);
  m_Plan.strRoomNum := Trim(edtRoom.Text);
  dtpJiaoBanDay.Time := dtpJiaoBanTime.Time;
  dtpHouBanDay.Time := dtpHouBanTime.Time;
  m_Plan.dtCallWorkTime := 0;
  m_Plan.dtWaitWorkTime := 0;
  m_Plan.bNeedSyncCall := False;
  m_Plan.bNeedRest := False;
  
  if chk_UseCallWork.Checked then
  begin
    m_Plan.bNeedSyncCall := True;
    m_Plan.dtCallWorkTime:=dtpJiaoBanDay.DateTime;
  end;

  if chk_UseWaitWork.Checked then
  begin
    m_Plan.bNeedRest := True;
  end;
  m_Plan.dtWaitWorkTime:= dtpHouBanDay.DateTime;

  if cbbCheJian.ItemIndex >=0 then
  begin
    m_Plan.strCheJianGUID := m_WorkShopAry[cbbCheJian.ItemIndex].strWorkShopGUID;
    m_plan.strCheJianName := m_WorkShopAry[cbbCheJian.ItemIndex].strWorkShopName;
  end;
  if cbbJiaoLu.ItemIndex >= 0 then
  begin
    m_Plan.strTrainJiaoLuGUID := m_JiaoLuAry[cbbJiaoLu.ItemIndex].strTrainJiaoLuGUID;
    m_plan.strTrainJiaoLuName := m_JiaoLuAry[cbbJiaoLu.ItemIndex].strTrainJiaoLuName;
    m_plan.strTrainJiaoLuNickName := Trim(edtJiaoLuNickName.Text);
  end;

  for i := 0 to 3 do
  begin
    if m_Plan.tmPlanList.Items[i].strTrainmanGUID = '' then
    begin
      m_Plan.tmPlanList.Items[i].strTrainmanGUID := GridTrainman.Cells[1,i+1];
      m_Plan.tmPlanList.Items[i].strTrainmanNumber := GridTrainman.Cells[2,i+1];
      m_Plan.tmPlanList.Items[i].strTrainmanName := GridTrainman.Cells[3,i+1];
      m_Plan.tmPlanList.Items[i].eTMState := psEdit;
      if m_Plan.tmPlanList.Items[i].strTrainmanGUID <> '' then
      begin
        m_Plan.tmPlanList.Items[i].eTMState := psPublish;
      end;
    end;
  end;

end;
procedure TFrmEditWaitWork.UseWaitWorkTime(bUse:Boolean);
begin
  dtpHouBanDay.Enabled := bUse;
  dtpHouBanTime.Enabled := bUse;
  if bUse then
  begin
    dtpHouBanDay.Date := DateOf(GlobalDM.GetNow);
    dtpHouBanTime.Time := TimeOf(GlobalDM.GetNow);
  end;

end;
procedure TFrmEditWaitWork.UseCallWorkTime(bUse: Boolean);
begin
  dtpJiaoBanDay.Enabled := bUse;
  dtpJiaoBanTime.Enabled := bUse;

  if bUse then
  begin
    dtpJiaoBanDay.Date := DateOf(GlobalDM.GetNow);
    dtpJiaoBanTime.Time := TimeOf(IncHour(GlobalDM.GetNow,4));
  end;

end;

end.
