unit uFrmEditWaitWorkJiNing;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls,uWaitWork,uDBWaitWork,uGlobalDM,
  uTrainman,ufrmTextInput,DateUtils, Grids, AdvObj, BaseGrid, AdvGrid,uTFSystem,
  uWaitWorkMgr,uSaftyEnum,
  uDBLocalTrainman,uPubFun, utfLookupEdit,utfPopTypes;

type
  TFrmEditWaitWorkJiNing = class(TForm)
    lbl3: TLabel;
    chk_UseWaitWork: TCheckBox;
    dtpHouBanDay: TDateTimePicker;
    dtpHouBanTime: TDateTimePicker;
    dtpJiaoBanTime: TDateTimePicker;
    dtpJiaoBanDay: TDateTimePicker;
    chk_UseCallWork: TCheckBox;
    lbl4: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    lbl1: TLabel;
    edtCheCi: TEdit;
    lbl2: TLabel;
    edtRoom: TEdit;
    btnCreateTrainman: TButton;
    edtUserInfo1: TtfLookupEdit;
    Label6: TLabel;
    edtUserInfo3: TtfLookupEdit;
    edtUserInfo4: TtfLookupEdit;
    Label7: TLabel;
    Label1: TLabel;
    Label5: TLabel;
    edtUserInfo2: TtfLookupEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCreateTrainmanClick(Sender: TObject);
    procedure chk_UseWaitWorkClick(Sender: TObject);
    procedure chk_UseCallWorkClick(Sender: TObject);
    procedure edtCheCiChange(Sender: TObject);
  private
    //候班计划
    m_Plan:TWaitWorkPlan;
    //人员数据库操作
    m_DBTrainman :TRsDBLocalTrainman;
    //待乘管理
    m_WaitWorkMgr:TWaitWorkMgr;
    //是否修改计划
    m_bModifyMode:Boolean;
    //新增人员
    m_newTrainman:RRsTrainman;

    //查询到的人员
    m_SelectUserInfoArray:TRsTrainmanArray;
  private
    procedure InitUI();
    procedure UnInitUI();
    procedure IniColumns(LookupEdit : TtfLookupEdit);

    procedure edtUserInfoSelected1(SelectedItem: TtfPopupItem;SelectedIndex: Integer);
    procedure edtUserInfoSelected2(SelectedItem: TtfPopupItem;SelectedIndex: Integer);
    procedure edtUserInfoSelected3(SelectedItem: TtfPopupItem;SelectedIndex: Integer);
    procedure edtUserInfoSelected4(SelectedItem: TtfPopupItem;SelectedIndex: Integer);
    
    procedure edtUserInfoPrevPage(Sender: TObject);
    procedure edtUserInfoNextPage(Sender: TObject);
    procedure edtUserInfoChange(Sender: TObject);

    //设置弹出下拉框数据
    procedure SetPopupData(LookupEdit: TtfLookupEdit; TrainmanArray : TRsTrainmanArray);
  private
      {启用候班时间}
    procedure UseWaitWorkTime(bUse:Boolean);
    {启用叫班时间}
    procedure UseCallWorkTime(bUse:Boolean);
    {功能:更新计划属性值}
    procedure SetPlanValues();
    {功能:校验用户输入}
    function CheckInPut():Boolean;
    {功能:判断人员已有候班计划}
    function bInPlan(strTrainmanGUID:string):Boolean;
    {功能:获取待乘时间}
    function GetWaitWorkTime():TDateTime;
    {功能:获取叫班时间}
    function GetCallWorkTime():TDateTime;
    {功能:填充Grid行数据}
    procedure SetEditUserData(Index:integer;trainman:RRsTrainman);
  public
    { Public declarations }
  end;


    {功能:集宁模式新增候班计划}
  function CreateWaitWorkPlan_JiNing(out plan:TWaitWorkPlan):Boolean;
  {功能:集宁模式修改候班计划}
  function ModifyWaitWorkPlan_JiNing(var plan:TWaitWorkPlan):Boolean;

var
  FrmEditWaitWorkJiNing: TFrmEditWaitWorkJiNing;

implementation
uses
  ufrmQuestionBox,uFrmJiNingTrainmanEdit;

{$R *.dfm}


{功能:新增候班计划}
function CreateWaitWorkPlan_JiNing(out plan:TWaitWorkPlan):Boolean;
var
  frm:TFrmEditWaitWorkJiNing;
  i:Integer;
begin
  Result := False;
  plan := TWaitWorkPlan.Create;
  plan.strPlanGUID := NewGUID();
  plan.dtWaitWorkTime := GlobalDM.GetNow();
  plan.dtCallWorkTime := GlobalDM.GetNow();
  plan.ePlanType := TWWPT_LOCAL;
  plan.ePlanState := psPublish;
  for i := 0 to 3 do
  begin
    plan.AddNewTrianman('','','');
  end;
  frm:=TFrmEditWaitWorkJiNing.Create(nil);
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
function ModifyWaitWorkPlan_JiNing(var plan:TWaitWorkPlan):Boolean;
var
  frm:TFrmEditWaitWorkJiNing;
begin
  Result := False;
  frm:=TFrmEditWaitWorkJiNing.Create(nil);
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

function TFrmEditWaitWorkJiNing.bInPlan(strTrainmanGUID: string): Boolean;
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
  
end;

procedure TFrmEditWaitWorkJiNing.btnCancelClick(Sender: TObject);
begin
  Self.ModalResult := mrCancel;
end;


procedure TFrmEditWaitWorkJiNing.btnCreateTrainmanClick(Sender: TObject);
begin
    TFrmJiNingTrainmanEdit.CreateTrainman;
end;

procedure TFrmEditWaitWorkJiNing.btnOKClick(Sender: TObject);
begin
  if CheckInPut = False  then Exit;
  SetPlanValues();
  
  Self.ModalResult := mrOk;
end;

function TFrmEditWaitWorkJiNing.CheckInPut: Boolean;
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



procedure TFrmEditWaitWorkJiNing.chk_UseCallWorkClick(Sender: TObject);
begin
  UseCallWorkTime(chk_UseCallWork.Checked);
end;

procedure TFrmEditWaitWorkJiNing.chk_UseWaitWorkClick(Sender: TObject);
begin
  UseWaitWorkTime(chk_UseWaitWork.Checked);
end;

procedure TFrmEditWaitWorkJiNing.edtCheCiChange(Sender: TObject);
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

procedure TFrmEditWaitWorkJiNing.edtUserInfoChange(Sender: TObject);
var
  edtTrainman: TtfLookupEdit;
  TrainmanArray : TRsTrainmanArray;
  nCount: Integer;
  strWorkShopGUID:string;
begin
  edtTrainman := TtfLookupEdit(Sender);
  with edtTrainman do
  begin
    PopStyle.PageIndex := 1;
    strWorkShopGUID := '' ;

    nCount := m_DBTrainman.GetPopupTrainmans(strWorkShopGUID, Text, PopStyle.PageIndex, TrainmanArray);
    PopStyle.PageCount := nCount div PopStyle.MaxViewCol;
    if nCount mod PopStyle.MaxViewCol > 0 then PopStyle.PageCount := PopStyle.PageCount + 1;
    SetPopupData(edtTrainman, TrainmanArray);
  end;
end;

procedure TFrmEditWaitWorkJiNing.edtUserInfoNextPage(Sender: TObject);
var
  edtTrainman: TtfLookupEdit;
  TrainmanArray : TRsTrainmanArray;
  strWorkShopGUID :string ;
begin
  edtTrainman := TtfLookupEdit(Sender);
  with edtTrainman do
  begin
    PopStyle.PageIndex := PopStyle.PageIndex + 1;
    strWorkShopGUID := '' ;
    m_DBTrainman.GetPopupTrainmans(strWorkShopGUID, Text, PopStyle.PageIndex, TrainmanArray);
    SetPopupData(edtTrainman, TrainmanArray);
  end;
end;

procedure TFrmEditWaitWorkJiNing.edtUserInfoPrevPage(Sender: TObject);
var
  edtTrainman: TtfLookupEdit;
  TrainmanArray : TRsTrainmanArray;
  strWorkShopGUID:string;
begin        
  edtTrainman := TtfLookupEdit(Sender);
  with edtTrainman do
  begin
    PopStyle.PageIndex := PopStyle.PageIndex - 1;
    strWorkShopGUID := '' ;
    m_DBTrainman.GetPopupTrainmans(strWorkShopGUID , Text, PopStyle.PageIndex, TrainmanArray);
    SetPopupData(edtTrainman, TrainmanArray);
  end;
end;



procedure TFrmEditWaitWorkJiNing.edtUserInfoSelected1(
  SelectedItem: TtfPopupItem; SelectedIndex: Integer);
begin
  edtUserInfo1.OnChange := nil;
  try
    FillChar(m_SelectUserInfoArray[0],SizeOf(RRsTrainman),0);
    if edtUserInfo1.Text <> '' then
    begin
      m_DBTrainman.GetTrainman(SelectedItem.StringValue, m_SelectUserInfoArray[0]);
      if bInPlan(m_SelectUserInfoArray[0].strTrainmanGUID) = True then
      begin
        ShowMessage(format('%s乘务员已有待乘计划', [m_SelectUserInfoArray[0].strTrainmanName]));
        FillChar(m_SelectUserInfoArray[0], SizeOf(RRsTrainman), 0);
        edtUserInfo1.Text := '';
        Exit;
      end;
    end;

   edtUserInfo1.Text := Format('%s',[SelectedItem.SubItems[1]]);
  finally
     edtUserInfo1.OnChange := edtUserInfoChange;
  end;
end;

procedure TFrmEditWaitWorkJiNing.edtUserInfoSelected2(
  SelectedItem: TtfPopupItem; SelectedIndex: Integer);
begin
  edtUserInfo2.OnChange := nil;
  try
    FillChar(m_SelectUserInfoArray[1],SizeOf(RRsTrainman),0);
    if edtUserInfo2.Text <> '' then
    begin
      m_DBTrainman.GetTrainman(SelectedItem.StringValue, m_SelectUserInfoArray[1]);
      if bInPlan(m_SelectUserInfoArray[1].strTrainmanGUID) = True then
      begin
        ShowMessage(format('%s乘务员已有待乘计划', [m_SelectUserInfoArray[1].strTrainmanName]));
        FillChar(m_SelectUserInfoArray[1], SizeOf(RRsTrainman), 0);
        edtUserInfo2.Text := '';
        Exit;
      end;
    end;

   edtUserInfo2.Text := Format('%s',[SelectedItem.SubItems[1]]);
  finally
     edtUserInfo2.OnChange := edtUserInfoChange;
  end;
end;

procedure TFrmEditWaitWorkJiNing.edtUserInfoSelected3(
  SelectedItem: TtfPopupItem; SelectedIndex: Integer);
begin
  edtUserInfo3.OnChange := nil;
  try
    FillChar(m_SelectUserInfoArray[2],SizeOf(RRsTrainman),0);
    if edtUserInfo3.Text <> '' then
    begin
      m_DBTrainman.GetTrainman(SelectedItem.StringValue, m_SelectUserInfoArray[2]);
      if bInPlan(m_SelectUserInfoArray[2].strTrainmanGUID) = True then
      begin
        ShowMessage(format('%s乘务员已有待乘计划', [m_SelectUserInfoArray[2].strTrainmanName]));
        FillChar(m_SelectUserInfoArray[2], SizeOf(RRsTrainman), 0);
        edtUserInfo3.Text := '';
        Exit;
      end;
    end;

   edtUserInfo3.Text := Format('%s',[SelectedItem.SubItems[1]]);
  finally
     edtUserInfo3.OnChange := edtUserInfoChange;
  end;
end;

procedure TFrmEditWaitWorkJiNing.edtUserInfoSelected4(
  SelectedItem: TtfPopupItem; SelectedIndex: Integer);
begin
  edtUserInfo4.OnChange := nil;
  try
    FillChar(m_SelectUserInfoArray[3],SizeOf(RRsTrainman),0);
    if edtUserInfo4.Text <> '' then
    begin
      m_DBTrainman.GetTrainman(SelectedItem.StringValue, m_SelectUserInfoArray[3]);
      if bInPlan(m_SelectUserInfoArray[3].strTrainmanGUID) = True then
      begin
        ShowMessage(format('%s乘务员已有待乘计划', [m_SelectUserInfoArray[3].strTrainmanName]));
        FillChar(m_SelectUserInfoArray[3], SizeOf(RRsTrainman), 0);
        edtUserInfo4.Text := '';
        Exit;
      end;
    end;

   edtUserInfo4.Text := Format('%s',[SelectedItem.SubItems[1]]);
  finally
     edtUserInfo4.OnChange := edtUserInfoChange ;
  end;
end;

procedure TFrmEditWaitWorkJiNing.FormCreate(Sender: TObject);
begin
  SetLength(m_SelectUserInfoArray,4);
  m_DBTrainman := TRsDBLocalTrainman.Create(GlobalDM.LocalADOConnection);
  m_WaitWorkMgr:=TWaitWorkMgr.GetInstance(GlobalDM.LocalADOConnection);
  m_bModifyMode:= False;
  InitUI;
end;

procedure TFrmEditWaitWorkJiNing.FormDestroy(Sender: TObject);
begin
  m_DBTrainman.Free;
  UnInitUI ;
end;

procedure TFrmEditWaitWorkJiNing.FormShow(Sender: TObject);
var
  trainman:RRsTrainman;
  i:Integer;
  strMsg:string;
begin


  edtRoom.Text := m_Plan.strRoomNum;
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



  edtUserInfo1.IsAutoPopup := False ;
  edtUserInfo2.IsAutoPopup := False ;
  edtUserInfo3.IsAutoPopup := False ;
  edtUserInfo4.IsAutoPopup := False ;

  try
    for i := 0 to m_Plan.tmPlanList.Count - 1 do
    begin
      if m_Plan.tmPlanList.Items[i].strTrainmanGUID <> '' then
      begin
        if m_DBTrainman.GetTrainman(m_Plan.tmPlanList.Items[i].strTrainmanGUID,trainman) = True then
        begin
          SetEditUserData(i+1,trainman);
        end;
      end;
    end;
  finally
    edtUserInfo1.IsAutoPopup := true ;
    edtUserInfo2.IsAutoPopup := true ;
    edtUserInfo3.IsAutoPopup := true ;
    edtUserInfo4.IsAutoPopup := true ;
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

  {
  for i := 0 to m_Plan.tmPlanList.Count - 1 do
  begin
    if m_Plan.tmPlanList.Items[i].strTrainmanGUID <> '' then
    begin
      if m_DBTrainman.GetTrainman(m_Plan.tmPlanList.Items[i].strTrainmanGUID,trainman) = True then
      begin
        SetEditUserData(i+1,trainman);
      end;
    end;
  end;
  }

end;

function TFrmEditWaitWorkJiNing.GetCallWorkTime: TDateTime;
begin
  result := AssembleDateTime(dtpJiaoBanDay.Date,dtpJiaoBanTime.Time);
end;

function TFrmEditWaitWorkJiNing.GetWaitWorkTime: TDateTime;
begin
  result := AssembleDateTime(dtpHouBanDay.Date,dtpHouBanTime.Time);
end;


procedure TFrmEditWaitWorkJiNing.IniColumns(LookupEdit: TtfLookupEdit);
var
  col : TtfColumnItem;
begin
  LookupEdit.Columns.Clear;
  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := '序号';
  col.Width := 40;

  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := '姓名';
  col.Width := 80;

  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := '段号';
  col.Width := 80;
end;

procedure TFrmEditWaitWorkJiNing.InitUI;
begin
  //乘务员1
  IniColumns(edtUserInfo1);
  edtUserInfo1.OnChange := edtUserInfoChange;
  edtUserInfo1.OnPrevPage := edtUserInfoPrevPage;
  edtUserInfo1.OnNextPage := edtUserInfoNextPage;
  edtUserInfo1.OnSelected := edtUserInfoSelected1;

   //乘务员2
  IniColumns(edtUserInfo2);
  edtUserInfo2.OnChange := edtUserInfoChange;
  edtUserInfo2.OnPrevPage := edtUserInfoPrevPage;
  edtUserInfo2.OnNextPage := edtUserInfoNextPage;
  edtUserInfo2.OnSelected := edtUserInfoSelected2;

    //乘务员3
  IniColumns(edtUserInfo3);
  edtUserInfo3.OnChange := edtUserInfoChange;
  edtUserInfo3.OnPrevPage := edtUserInfoPrevPage;
  edtUserInfo3.OnNextPage := edtUserInfoNextPage;
  edtUserInfo3.OnSelected := edtUserInfoSelected3;

    //乘务员4
  IniColumns(edtUserInfo4);
  edtUserInfo4.OnChange := edtUserInfoChange;
  edtUserInfo4.OnPrevPage := edtUserInfoPrevPage;
  edtUserInfo4.OnNextPage := edtUserInfoNextPage;
  edtUserInfo4.OnSelected := edtUserInfoSelected4;

end;



procedure TFrmEditWaitWorkJiNing.SetEditUserData(Index:integer;
  trainman: RRsTrainman);
begin
  case Index of
    1:begin
      edtUserInfo1.OnChange := nil;
      try
        edtUserInfo1.Text := trainman.strTrainmanName ;
      finally
        edtUserInfo1.OnChange := edtUserInfoChange ;
      end;
    end;
    2:begin
      edtUserInfo2.OnChange := nil;
      try
        edtUserInfo2.Text := trainman.strTrainmanName ;
      finally
        edtUserInfo2.OnChange := edtUserInfoChange ;
      end;
    end;
    3:begin
      edtUserInfo3.OnChange := nil;
      try
        edtUserInfo3.Text := trainman.strTrainmanName ;
      finally
        edtUserInfo3.OnChange := edtUserInfoChange ;
      end;
    end;
    4:begin
      edtUserInfo4.OnChange := nil;
      try
        edtUserInfo4.Text := trainman.strTrainmanName ;
      finally
        edtUserInfo4.OnChange := edtUserInfoChange ;
      end;
    end;
  end;

end;

procedure TFrmEditWaitWorkJiNing.SetPlanValues;
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

  begin
    m_Plan.strCheJianGUID := '';
    m_plan.strCheJianName := '';
  end;

  begin
    m_Plan.strTrainJiaoLuGUID := '';
    m_plan.strTrainJiaoLuName := '';
    m_plan.strTrainJiaoLuNickName := '' ;
  end;

  for i := 0 to 3 do
  begin
    if m_Plan.tmPlanList.Items[i].strTrainmanGUID = '' then
    begin
      m_Plan.tmPlanList.Items[i].strTrainmanGUID := m_SelectUserInfoArray[i].strTrainmanGUID;
      m_Plan.tmPlanList.Items[i].strTrainmanNumber := m_SelectUserInfoArray[i].strTrainmanNumber;
      m_Plan.tmPlanList.Items[i].strTrainmanName := m_SelectUserInfoArray[i].strTrainmanName;
      m_Plan.tmPlanList.Items[i].eTMState := psEdit;
      if m_Plan.tmPlanList.Items[i].strTrainmanGUID <> '' then
      begin
        m_Plan.tmPlanList.Items[i].eTMState := psPublish;
      end;
    end;
  end;
end;

procedure TFrmEditWaitWorkJiNing.SetPopupData(LookupEdit: TtfLookupEdit;
  TrainmanArray: TRsTrainmanArray);
var
  item : TtfPopupItem;
  i: Integer;
begin
  LookupEdit.Items.Clear;
  for i := 0 to Length(TrainmanArray) - 1 do
  begin
    item := TtfPopupItem.Create();
    item.StringValue := TrainmanArray[i].strTrainmanGUID;
    item.SubItems.Add(Format('%d', [(LookupEdit.PopStyle.PageIndex - 1) * 10 + i + 1]));
    item.SubItems.Add(TrainmanArray[i].strTrainmanName);
    item.SubItems.Add(TrainmanArray[i].strWorkShopName);
    LookupEdit.Items.Add(item);
  end;
  LookupEdit.PopStyle.PageInfo := Format('　第 %d 页，共 %d 页', [LookupEdit.PopStyle.PageIndex, LookupEdit.PopStyle.PageCount]);

end;


procedure TFrmEditWaitWorkJiNing.UnInitUI;
begin
  edtUserInfo1.OnChange := nil;
  edtUserInfo1.OnPrevPage := nil;
  edtUserInfo1.OnNextPage := nil;
  edtUserInfo1.OnSelected := nil;

   //乘务员2
  edtUserInfo2.OnChange := nil;
  edtUserInfo2.OnPrevPage := nil;
  edtUserInfo2.OnNextPage := nil;
  edtUserInfo2.OnSelected := nil;

    //乘务员3
  edtUserInfo3.OnChange := nil;
  edtUserInfo3.OnPrevPage := nil;
  edtUserInfo3.OnNextPage := nil;
  edtUserInfo3.OnSelected := nil;

    //乘务员4
  edtUserInfo4.OnChange := nil;
  edtUserInfo4.OnPrevPage := nil;
  edtUserInfo4.OnNextPage := nil;
  edtUserInfo4.OnSelected := nil;  
end;

procedure TFrmEditWaitWorkJiNing.UseCallWorkTime(bUse: Boolean);
begin
  dtpJiaoBanDay.Enabled := bUse;
  dtpJiaoBanTime.Enabled := bUse;

  if bUse then
  begin
    dtpJiaoBanDay.Date := DateOf(GlobalDM.GetNow);
    dtpJiaoBanTime.Time := TimeOf(IncHour(GlobalDM.GetNow,4));
  end;
end;

procedure TFrmEditWaitWorkJiNing.UseWaitWorkTime(bUse: Boolean);
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
