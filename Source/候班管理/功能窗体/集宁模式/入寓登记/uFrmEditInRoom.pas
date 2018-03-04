unit uFrmEditInRoom;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls,uWaitWork,uDBWaitWork,uGlobalDM,
  uTrainman,ufrmTextInput,DateUtils, Grids, AdvObj, BaseGrid, AdvGrid,uTFSystem,
  uWaitWorkMgr,uSaftyEnum,uDBWorkShop,uWorkShop,uRoomCall,uRoomCallApp,
  uDBLocalTrainman,uPubFun, utfLookupEdit,utfPopTypes, ExtCtrls, RzPanel;

type
  TFrmEditInRoom = class(TForm)
    lbl3: TLabel;
    dtpHouBanDay: TDateTimePicker;
    dtpHouBanTime: TDateTimePicker;
    dtpJiaoBanTime: TDateTimePicker;
    dtpJiaoBanDay: TDateTimePicker;
    chk_UseCallWork: TCheckBox;
    lbl4: TLabel;
    lbl1: TLabel;
    edtCheCi: TEdit;
    lbl2: TLabel;
    edtRoom: TEdit;
    edtTrainman1: TtfLookupEdit;
    Label1: TLabel;
    cbbJWD: TComboBox;
    lbl5: TLabel;
    grpLianJiao: TGroupBox;
    Label2: TLabel;
    DstList: TListBox;
    btnAddRoom: TButton;
    btnDelRoom: TButton;
    Label3: TLabel;
    SrcList: TListBox;
    RzPanel1: TRzPanel;
    chkLianJiao: TCheckBox;
    btnOK: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCreateTrainmanClick(Sender: TObject);
    procedure chk_UseWaitWorkClick(Sender: TObject);
    procedure chk_UseCallWorkClick(Sender: TObject);
    procedure edtCheCiChange(Sender: TObject);
    procedure btnAddRoomClick(Sender: TObject);
    procedure btnDelRoomClick(Sender: TObject);
    procedure chkLianJiaoClick(Sender: TObject);
    procedure edtRoomChange(Sender: TObject);
    procedure dtpJiaoBanTimeChange(Sender: TObject);
  private
    //车间数组
    m_WorkShopAry:TRsWorkShopArray;
    //车间数据库操作
    m_DBWorkShop:TRsDBWorkShop;

    m_InRoomWorkPlan:TInRoomWorkPlan;

    //人员数据库操作
    m_DBTrainman :TRsDBLocalTrainman;
    m_Trainman: RRsTrainman;
    //待乘管理
    m_WaitWorkMgr:TWaitWorkMgr;
    //是否修改计划
    m_bModifyMode:Boolean;
  private
      //房间设备数组
    m_RoomDevAry:TCallDevAry;
    //公寓叫班管理
    m_RoomCallApp:TRoomCallApp;
  private

    procedure SetEdtTrainmnEmpty();

    procedure AddToJoinRoom();
    procedure DelFromJoinRoom();

    procedure MoveSelected(List: TCustomListBox; Items: TStrings);
    procedure SetItem(List: TListBox; Index: Integer);
    function GetFirstSelection(List: TCustomListBox): Integer;
    procedure SetButtons;
  private
      procedure InitData();
      procedure InitRoom();
      procedure InitWorkShop(strWorkShopGUID:string='');
      function AddTrainman():boolean;

      function IsNeedModifyTrainman():boolean;
      function ModifyTrainman():boolean;
  private
    procedure InitUI();
    procedure UnInitUI();
    procedure IniColumns(LookupEdit : TtfLookupEdit);

    procedure edtTrainman1Selected(SelectedItem: TtfPopupItem;SelectedIndex: Integer);

    procedure edtTrainmanPrevPage(Sender: TObject);
    procedure edtTrainmanNextPage(Sender: TObject);
    procedure edtTrainmanChange(Sender: TObject);

        //设置弹出下拉框数据
     procedure SetPopupData(LookupEdit: TtfLookupEdit; Trainmans: TRsTrainmanArray);
     //设置选定的乘务员
     procedure SetSelected(EdtCtrl : TtfLookupEdit;SelectedItem:TtfPopupItem;
      var Trainman : RRsTrainman);
  private
    procedure ChangeWorkPlan();
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
  function CreateInRoomPlan(InRoomWorkPlan:TInRoomWorkPlan):Boolean;


var
  FrmEditInRoom: TFrmEditInRoom;

implementation
uses
  ufrmQuestionBox,uFrmJiNingTrainmanEdit;

{$R *.dfm}


{功能:新增候班计划}
function CreateInRoomPlan(InRoomWorkPlan:TInRoomWorkPlan):Boolean;
var
  frm:TFrmEditInRoom;
begin
  frm:=TFrmEditInRoom.Create(nil);
  try
    frm.m_InRoomWorkPlan := InRoomWorkPlan;
    if frm.ShowModal() = mrOk then
    begin
      result := True;
      Exit;
    end;
  finally
    frm.Free;
  end;
end;

{功能:修改候班计划}


procedure TFrmEditInRoom.AddToJoinRoom;
var
  Index: Integer;
begin
  Index := GetFirstSelection(SrcList);
  if Index < 0 then
    exit ;

  if SrcList.Items.Strings[Index] = Trim(edtRoom.Text) then
  begin
    BoxErr('不能联叫自己');
    exit ;
  end;
  MoveSelected(SrcList, DstList.Items);
  SetItem(SrcList, Index);
end;

function TFrmEditInRoom.AddTrainman: boolean;
var
  strTrainmanName:string;
begin
  Result := False ;
  try
    strTrainmanName :=  Trim( edtTrainman1.Text ) ;
    m_Trainman.strTrainmanGUID := NewGUID;
    m_Trainman.nTrainmanState :=   tsNormal ;
    m_Trainman.strTrainmanName := Trim( edtTrainman1.Text );
    m_Trainman.strTrainmanNumber := Trim( edtTrainman1.Text ) ;
    m_Trainman.strJP := GlobalDM.GetHzPy(strTrainmanName) ;
    m_Trainman.strWorkShopGUID := m_WorkShopAry[cbbJWD.ItemIndex].strWorkShopGUID ;
    m_DBTrainman.AddTrainman(m_Trainman);
    Result := True ;
  except on e : exception do
    begin
      Box('保存人员失败：' + e.Message);
      exit;
    end;
  end;
end;

function TFrmEditInRoom.bInPlan(strTrainmanGUID: string): Boolean;
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

procedure TFrmEditInRoom.btnAddRoomClick(Sender: TObject);
begin
//  if not chk_UseCallWork.Checked then
//  begin
//    BoxErr('请启用叫班时间');
//    exit ;
//  end;
  AddToJoinRoom;
end;

procedure TFrmEditInRoom.btnCancelClick(Sender: TObject);
begin
  Self.ModalResult := mrCancel;
end;


procedure TFrmEditInRoom.btnCreateTrainmanClick(Sender: TObject);
begin
    TFrmJiNingTrainmanEdit.CreateTrainman;
end;

procedure TFrmEditInRoom.btnDelRoomClick(Sender: TObject);
begin
  DelFromJoinRoom;
end;

procedure TFrmEditInRoom.btnOKClick(Sender: TObject);
var
  strWorkShopName:string;
begin
  if CheckInPut = False  then Exit;

  //如果人员不存在则创建人员
  if ( m_Trainman.strTrainmanNumber = '' ) and ( Trim(edtTrainman1.Text) <> '' ) then
  begin
    if not AddTrainman then
      exit ;
  end
  else
  begin
    //检查是否需要修改机务段信息
    if IsNeedModifyTrainman then
    begin
        //更改人员的机务段信息
      ModifyTrainman;
    end;
  end;



  SetPlanValues();


  if m_bModifyMode then
  begin
    ChangeWorkPlan();
  end;
  
  Self.ModalResult := mrOk;
end;

procedure TFrmEditInRoom.ChangeWorkPlan;
var
  strRoomNumber:string;
  strTrainNo:string;
  waitPlan:TWaitWorkPlan;
  i:Integer;
begin
//  strTrainNo := Trim(edtCheCi.Text);
//  if strTrainNo <> '' then
//  begin
//    waitPlan :=  m_WaitWorkMgr.FindPlan_CheCi(strTrainNo,i);
//    if waitPlan <> nil then
//    begin
//      waitPlan.strCheCi := m_InRoomWorkPlan.strCheCi ;
//      waitPlan.strRoomNum := m_InRoomWorkPlan.strRoomNum;
//
//      waitPlan.dtWaitWorkTime := m_InRoomWorkPlan.dtWaitWorkTime;
//      waitPlan.bNeedSyncCall := m_InRoomWorkPlan.bNeedSyncCall;
//      waitPlan.dtCallWorkTime := m_InRoomWorkPlan.dtCallWorkTime;
//
//      waitPlan.bNeedRest := m_InRoomWorkPlan.bNeedRest ;
//      waitPlan.JoinRoomList.Assign(m_InRoomWorkPlan.JoinRoomList);
//
//      m_WaitWorkMgr.ModifyWorkPlan(waitPlan);
//      exit ;
//    end;
//  end;


  strRoomNumber := Trim(edtRoom.Text);
  if strRoomNumber <> '' then
  begin
    waitPlan :=  m_WaitWorkMgr.FindPlanByRoom(strRoomNumber);
    if waitPlan <> nil then
    begin
      waitPlan.strCheCi := m_InRoomWorkPlan.strCheCi ;
      waitPlan.strRoomNum := m_InRoomWorkPlan.strRoomNum;

      waitPlan.dtWaitWorkTime := m_InRoomWorkPlan.dtWaitWorkTime;
      waitPlan.bNeedSyncCall := m_InRoomWorkPlan.bNeedSyncCall;
      waitPlan.dtCallWorkTime := m_InRoomWorkPlan.dtCallWorkTime;
      waitPlan.bNeedRest := m_InRoomWorkPlan.bNeedRest ;
      waitPlan.JoinRoomList.Assign(m_InRoomWorkPlan.JoinRoomList);
      m_WaitWorkMgr.ModifyWorkPlan(waitPlan);
    end;
  end;
end;

function TFrmEditInRoom.CheckInPut: Boolean;
var
  strCheCi:string;
  strRoomNum:string;
  planRoom:TWaitWorkPlan;
  planCheCi:TWaitWorkPlan;
  strErr:string;
  i,j : Integer ;
begin
  result := False;
  strCheCi := Trim(edtCheCi.Text);
  strRoomNum := Trim(edtRoom.Text) ;

  if ( strRoomNum = '' ) and  ( strCheCi = '' )then
  begin
    BoxErr('房间号和车次不能同时为空');
    exit ;
  end;

  if  ( Trim(edtTrainman1.Text) = '' )then
  begin
    tfMessageBox('人员不能为空',MB_ICONERROR);
    exit ;
  end;

  if (m_Trainman.strTrainmanNumber = '' )  and  ( Trim(edtTrainman1.Text) <> '' )then
  begin
    //如果没有选中人员，则检查一下EDIT是否可以
    if m_DBTrainman.ExistTrainman(m_WorkShopAry[cbbJWD.ItemIndex].strWorkShopGUID,edtTrainman1.Text,m_Trainman) then
    begin
       edtTrainman1.OnChange := nil;
      try
        edtTrainman1.Text := m_Trainman.strTrainmanName ;

        for I := 0 to cbbJWD.items.count - 1 do
        begin
          if cbbJWD.items[i] = m_Trainman.strWorkShopName then
          begin
            cbbJWD.ItemIndex := i;
            break;
          end;
        end;
      finally
        edtTrainman1.OnChange := edtTrainmanChange;
      end;
    end;
  end;



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

  if m_bModifyMode and (m_InRoomWorkPlan.strRoomNum = strRoomNum) then
  begin
    result := True;
    Exit;
  end;


  if ( strRoomNum <> ''  )  then
  begin
    planRoom := m_WaitWorkMgr.FindPlanByRoom(strRoomNum);
    if planRoom <> nil then
       m_bModifyMode := True ;
  end;

  //客车计划和入寓计划2合一
  if ( strRoomNum <> ''  ) and  ( strCheCi <> '' ) then
  begin
    planRoom := m_WaitWorkMgr.FindPlanByRoom(strRoomNum);
    planCheCi := m_WaitWorkMgr.FindPlan_CheCi(strCheCi,j);
    if Assigned (planRoom) and Assigned (planCheCi) then
    begin
      begin
        DstList.Items.Assign(planRoom.JoinRoomList);
        m_WaitWorkMgr.DelPlan(planRoom);
        m_bModifyMode := True ;
      end;
    end;
  end;

  //检测一下联交房间是否安排计划了
  for I := 0 to DstList.Items.Count - 1 do
  begin
    planRoom :=m_WaitWorkMgr.FindPlanByRoom(DstList.Items[i]);
    if Assigned (planRoom) then
    begin
      tfMessageBox('房间:[' + strRoomNum + ']已安排计划',MB_ICONINFORMATION);
      Exit;
    end;
  end;
  Result := True;
end;



procedure TFrmEditInRoom.chkLianJiaoClick(Sender: TObject);
begin
  if chkLianJiao.Checked then
  begin
    grpLianJiao.Visible := True ;
    Self.Height := Self.Height + 252   ;
    //Self.Position := poOwnerFormCenter;
  end
  else
  begin

    Self.Height := Self.Height - 252;
    grpLianJiao.Visible := False ;
    //Self.Position := poOwnerFormCenter;
  end;
end;

procedure TFrmEditInRoom.chk_UseCallWorkClick(Sender: TObject);
begin
  UseCallWorkTime(chk_UseCallWork.Checked);
end;

procedure TFrmEditInRoom.chk_UseWaitWorkClick(Sender: TObject);
begin
  UseWaitWorkTime(True);
end;

procedure TFrmEditInRoom.DelFromJoinRoom;
var
  Index: Integer;
begin
  Index := GetFirstSelection(DstList);
  if Index <0 then
    exit ;
  MoveSelected(DstList, SrcList.Items);
  SetItem(DstList, Index);
end;

procedure TFrmEditInRoom.dtpJiaoBanTimeChange(Sender: TObject);
var
  dtJiaoBanTime,dtNow:TDateTime ;
begin
//  dtNow := Now ;
//  if TimeOf(dtpJiaoBanTime.Time) < TimeOf(dtNow) then
//  begin
//    dtpJiaoBanDay.DateTime := IncDay(dtNow,1);
//  end;
  
end;

procedure TFrmEditInRoom.edtCheCiChange(Sender: TObject);
var
  nIndex : integer ;
  strTrainNo,strRoom:string;
  waitPlan,findPlan:TWaitWorkPlan;
begin
  strRoom := Trim(edtRoom.Text);
  strTrainNo := Trim(edtCheCi.Text);
  if (strTrainNo = '')  then Exit;
  waitPlan:=TWaitWorkPlan.Create;
  try
    findPlan := m_WaitWorkMgr.FindPlan_CheCi(strTrainNo,nIndex) ;
    if findPlan <> nil then
    begin
      if strTrainNo = findPlan.strCheCi then
      begin
        if ( strRoom <> findPlan.strRoomNum ) and  ( findPlan.strRoomNum <> '' ) then
        begin
          edtCheCi.Clear ;
          edtCheCi.SetFocus ;
          tfMessageBox('该车次已经存在，请换一个车次',MB_ICONERROR) ;
          exit ;
        end;
      end
      else
      begin
        if strTrainNo <> findPlan.strCheCi then
        begin
          edtCheCi.Clear ;
          edtCheCi.SetFocus ;
          tfMessageBox('该车次已经存在，请换一个车次',MB_ICONERROR) ;
          exit ;
        end;

        if ( findPlan.strRoomNum <> '' ) and  ( findPlan.tmPlanList[0].strTrainmanGUID <> '' ) then
        begin
          edtCheCi.Clear ;
          edtCheCi.SetFocus ;
          tfMessageBox('该车次已经存在，请换一个车次',MB_ICONERROR) ;
          exit ;
        end;
      end;
    end;
    

    if m_WaitWorkMgr.GetLastWaitPlan_ByTrainNo(strTrainNo,waitPlan) = False then
    begin
      m_bModifyMode := False ;
      Exit;
    end
    else
      m_bModifyMode := False;
    //edtRoom.Text:= waitPlan.strRoomNum ;

    chk_UseCallWork.Checked := waitPlan.bNeedSyncCall;


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

procedure TFrmEditInRoom.edtRoomChange(Sender: TObject);
var
  i : Integer ;
  strTrainmanGUID:string;
  strWorkShopName:string;
  strRoomNumber:string;
  waitPlan:TWaitWorkPlan;
begin
  waitPlan := nil ;
  strRoomNumber := Trim(edtRoom.Text);
  if strRoomNumber = '' then
  begin
    SetEdtTrainmnEmpty  ;

    edtTrainman1.Enabled := true ;
    cbbJWD.Enabled := true ;
    exit ;
  end;

  waitPlan := m_WaitWorkMgr.FindPlanByRoom(strRoomNumber);
  if waitPlan = nil then
  begin
    //edtCheCi.Enabled := false ;
    edtTrainman1.Enabled := true ;
    cbbJWD.Enabled := true ;
    exit ;
  end;

  edtRoom.Text := waitPlan.strRoomNum ;
  edtCheCi.Text := waitPlan.strCheCi ;
  if waitPlan.tmPlanList[0].strTrainmanGUID <> '' then
  begin
    //edtCheCi.Enabled := true ;
    edtTrainman1.Enabled := false ;
    cbbJWD.Enabled := false ;
  end;


  if waitPlan.JoinRoomList.Count >0 then
  begin
    chkLianJiao.Checked := True ;
    DstList.Items.Assign(waitPlan.JoinRoomList);
  end;

  chk_UseCallWork.Checked := waitPlan.bNeedSyncCall ;
  dtpJiaoBanDay.DateTime := DateOf(waitPlan.dtCallWorkTime) ;
  dtpJiaoBanTime.DateTime := TimeOf(waitPlan.dtCallWorkTime);


  edtTrainman1.OnChange := nil;
  edtTrainman1.IsAutoPopup := False ;
  try

    strTrainmanGUID := waitPlan.tmPlanList[0].strTrainmanGUID;
    m_DBTrainman.GetTrainmanWorkShopName(strTrainmanGUID,strWorkShopName);


    edtTrainman1.Text := waitPlan.tmPlanList[0].strTrainmanName ;
    for I := 0 to cbbJWD.items.count - 1 do
    begin
      if cbbJWD.items[i] = strWorkShopName then
      begin
        cbbJWD.ItemIndex := i;
        break;
      end;
    end;

    m_Trainman.strTrainmanGUID := waitPlan.tmPlanList[0].strTrainmanGUID ;
    m_Trainman.strTrainmanName := waitPlan.tmPlanList[0].strTrainmanName ;
    m_Trainman.strTrainmanNumber := waitPlan.tmPlanList[0].strTrainmanNumber ;
  finally
    edtTrainman1.OnChange :=  edtTrainmanChange ;
    edtTrainman1.IsAutoPopup := True ;
  end;

end;

procedure TFrmEditInRoom.edtTrainmanChange(Sender: TObject);
var
  edtTrainman: TtfLookupEdit;
  TrainmanArray : TRsTrainmanArray;
  nCount: Integer;
  strWorkShopGUID:string;
begin
  edtTrainman := TtfLookupEdit(Sender);
  FillChar(m_Trainman,SizeOf(RRstrainman),0);
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

procedure TFrmEditInRoom.edtTrainmanNextPage(Sender: TObject);
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

procedure TFrmEditInRoom.edtTrainmanPrevPage(Sender: TObject);
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



procedure TFrmEditInRoom.edtTrainman1Selected(
  SelectedItem: TtfPopupItem; SelectedIndex: Integer);
begin
  SetSelected(edtTrainman1,selectedItem,m_Trainman);
end;




procedure TFrmEditInRoom.FormCreate(Sender: TObject);
begin
  m_DBTrainman := TRsDBLocalTrainman.Create(GlobalDM.LocalADOConnection);
  m_DBWorkShop := TRsDBWorkShop.Create(GlobalDM.LocalADOConnection);
  m_WaitWorkMgr:=TWaitWorkMgr.GetInstance(GlobalDM.LocalADOConnection);
  m_RoomCallApp:=TRoomCallApp.GetInstance;
  InitData;
  m_bModifyMode:= False;
end;

procedure TFrmEditInRoom.FormDestroy(Sender: TObject);
begin
  m_DBTrainman.Free;
  m_DBWorkShop.Free;
  UnInitUI ;
end;

procedure TFrmEditInRoom.FormShow(Sender: TObject);
var
  trainman:RRsTrainman;
  strMsg:string;
begin
  edtRoom.Text := m_InRoomWorkPlan.strRoomNum;
  dtpHouBanDay.Date := DateOf(m_InRoomWorkPlan.dtWaitWorkTime);
  dtpHouBanTime.Time := TimeOf(m_InRoomWorkPlan.dtWaitWorkTime);
  //dtpJiaoBanDay.Date := DateOf(m_Plan.dtCallWorkTime);
  //dtpJiaoBanTime.Time := TimeOf(m_Plan.dtCallWorkTime);
  dtpJiaoBanDay.DateTime := m_InRoomWorkPlan.dtCallWorkTime;
  dtpJiaoBanTime.DateTime := m_InRoomWorkPlan.dtCallWorkTime;

  //修改状态,切不叫班
  //if (m_InRoomWorkPlan.strPlanGUID <> '') and ( m_InRoomWorkPlan.bNeedSyncCall = False) then
  chk_UseCallWork.Checked := False;
  UseCallWorkTime(chk_UseCallWork.Checked);


  UseWaitWorkTime(True);

  edtCheCi.Text := m_InRoomWorkPlan.strCheCi;

end;

function TFrmEditInRoom.GetCallWorkTime: TDateTime;
begin
  result := AssembleDateTime(dtpJiaoBanDay.Date, dtpJiaoBanTime.Time );
end;

function TFrmEditInRoom.GetFirstSelection(List: TCustomListBox): Integer;
begin
  for Result := 0 to List.Items.Count - 1 do
    if List.Selected[Result] then Exit;
  Result := LB_ERR;
end;

function TFrmEditInRoom.GetWaitWorkTime: TDateTime;
begin
  result := AssembleDateTime(dtpHouBanDay.Date,dtpHouBanTime.Time);
end;


procedure TFrmEditInRoom.IniColumns(LookupEdit: TtfLookupEdit);
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

procedure TFrmEditInRoom.InitData;
begin

  dtpHouBanDay.Date := DateOf(GlobalDM.GetNow);
  dtpHouBanTime.Time := TimeOf(IncHour(GlobalDM.GetNow,8));
  dtpHouBanTime.Format := 'hh:mm:00';
  InitUI;
  InitWorkShop('');
  InitRoom();
end;

procedure TFrmEditInRoom.InitRoom;
var
  i : Integer ;
begin
  m_RoomCallApp.DBCallDev.GetAll(m_RoomDevAry);
  for I := 0 to Length(m_RoomDevAry) - 1 do
  begin
    SrcList.Items.Add(m_RoomDevAry[i].strRoomNum);
  end;
end;

procedure TFrmEditInRoom.InitUI;
begin
  IniColumns(edtTrainman1);

  edtTrainman1.OnChange := edtTrainmanChange;
  edtTrainman1.OnPrevPage := edtTrainmanPrevPage;
  edtTrainman1.OnNextPage := edtTrainmanNextPage;
  edtTrainman1.OnSelected := edtTrainman1Selected;


    chkLianJiao.Checked := False ;
  chkLianJiaoClick(chkLianJiao);
end;



procedure TFrmEditInRoom.InitWorkShop(strWorkShopGUID: string);
var
  i:Integer;
begin
  m_DBWorkShop.GetAllWorkShop( m_WorkShopAry);
  cbbJWD.Items.Clear;
  for i := 0 to Length(m_WorkShopAry) - 1 do
  begin
    cbbJWD.Items.Add(m_WorkShopAry[i].strWorkShopName) ;
    if m_WorkShopAry[i].strWorkShopGUID = strWorkShopGUID then
      cbbJWD.ItemIndex := i;
  end;
  cbbJWD.ItemIndex := 0 ;
end;

function TFrmEditInRoom.IsNeedModifyTrainman: boolean;
var
  strTrainmanGUID,strWorkShopName:string;
begin
  result := false ;
  strTrainmanGUID := m_Trainman.strTrainmanGUID;
  if m_DBTrainman.GetTrainmanWorkShopName(strTrainmanGUID,strWorkShopName) then
  begin
    if strWorkShopName <> m_WorkShopAry[cbbJWD.ItemIndex].strWorkShopName then
      result := true ;
  end;
end;

function TFrmEditInRoom.ModifyTrainman: boolean;
var
  strTrainmanName:string;
begin
  Result := False ;
  try
    m_Trainman.strWorkShopGUID := m_WorkShopAry[cbbJWD.ItemIndex].strWorkShopGUID ;
    m_DBTrainman.UpdateTrainman(m_Trainman);
    Result := True ;
  except on e : exception do
    begin
      Box('更改人员失败：' + e.Message);
      exit;
    end;
  end;

end;

procedure TFrmEditInRoom.MoveSelected(List: TCustomListBox; Items: TStrings);
var
  I: Integer;
begin
  for I := List.Items.Count - 1 downto 0 do
    if List.Selected[I] then
    begin
      Items.AddObject(List.Items[I], List.Items.Objects[I]);
      List.Items.Delete(I);
    end;
end;

procedure TFrmEditInRoom.SetButtons;
var
  SrcEmpty, DstEmpty: Boolean;
begin
  SrcEmpty := SrcList.Items.Count = 0;
  DstEmpty := DstList.Items.Count = 0;
  btnAddRoom.Enabled := not SrcEmpty;
  btnDelRoom.Enabled := not DstEmpty;
end;

procedure TFrmEditInRoom.SetEditUserData(Index:integer;
  trainman: RRsTrainman);
begin
  case Index of
    1:begin
      edtTrainman1.OnChange := nil;
      try
        edtTrainman1.Text := trainman.strTrainmanName ;
      finally
        edtTrainman1.OnChange := edtTrainmanChange ;
      end;
    end;
  end;

end;

procedure TFrmEditInRoom.SetEdtTrainmnEmpty;
begin
    edtTrainman1.OnChange := nil;
    edtTrainman1.IsAutoPopup := False ;
    try
      edtTrainman1.Text := '' ;
    finally
      edtTrainman1.OnChange :=  edtTrainmanChange ;
      edtTrainman1.IsAutoPopup := True ;
    end;
end;

procedure TFrmEditInRoom.SetItem(List: TListBox; Index: Integer);
var
  MaxIndex: Integer;
begin
  with List do
  begin
    SetFocus;
    MaxIndex := List.Items.Count - 1;
    if Index = LB_ERR then Index := 0
    else if Index > MaxIndex then Index := MaxIndex;
    Selected[Index] := True;
  end;
  SetButtons;
end;

procedure TFrmEditInRoom.SetPlanValues;
var
  i:Integer;
begin
  m_InRoomWorkPlan.ePlanType :=  TWWPT_LOCAL ;
  m_InRoomWorkPlan.strCheCi := Trim(edtCheCi.Text);
  m_InRoomWorkPlan.strRoomNum := Trim(edtRoom.Text);

  dtpJiaoBanDay.Time := dtpJiaoBanTime.Time;
  dtpHouBanDay.Time := dtpHouBanTime.Time;

  m_InRoomWorkPlan.dtCallWorkTime := 0;
  m_InRoomWorkPlan.dtWaitWorkTime := 0;
  m_InRoomWorkPlan.bNeedSyncCall := False;
  m_InRoomWorkPlan.bNeedRest := True;
  
  if chk_UseCallWork.Checked then
  begin
    m_InRoomWorkPlan.bNeedSyncCall := True;
    m_InRoomWorkPlan.dtCallWorkTime:= GetCallWorkTime  ;
  end;




  m_InRoomWorkPlan.dtWaitWorkTime:= 0;//dtpHouBanDay.DateTime;
  m_InRoomWorkPlan.Trainman := m_Trainman ;

  m_InRoomWorkPlan.JoinRoomList.Assign(DstList.Items);

end;

procedure TFrmEditInRoom.SetPopupData(LookupEdit: TtfLookupEdit; Trainmans: TRsTrainmanArray);
var
  item : TtfPopupItem;
  i: Integer;
begin
  LookupEdit.Items.Clear;
  for i := 0 to Length(Trainmans) - 1 do
  begin
    item := TtfPopupItem.Create();
    item.StringValue := Trainmans[i].strTrainmanGUID;
    item.SubItems.Add(Format('%d', [(LookupEdit.PopStyle.PageIndex - 1) * 10 + i + 1]));
    item.SubItems.Add(Trainmans[i].strTrainmanName);
    item.SubItems.Add(Trainmans[i].strWorkShopName);
    LookupEdit.Items.Add(item);
  end;
  LookupEdit.PopStyle.PageInfo := Format('　第 %d 页，共 %d 页', [LookupEdit.PopStyle.PageIndex, LookupEdit.PopStyle.PageCount]);

end;


procedure TFrmEditInRoom.SetSelected(EdtCtrl: TtfLookupEdit;
  SelectedItem: TtfPopupItem; var Trainman: RRsTrainman);
var
  strText:string;
  i : integer ;
  plan:TWaitWorkPlan;
begin
   EdtCtrl.OnChange := nil;
  try
    m_DBTrainman.GetTrainman(SelectedItem.StringValue,Trainman);

    plan:=m_WaitWorkMgr.FindPlan(Trainman.strTrainmanGUID);
    if Assigned(plan) then
    begin
      strText := format('[%s]已经被安排计划',[Trainman.strTrainmanName]);
      tfMessageBox(strText,MB_ICONERROR);
      SetEdtTrainmnEmpty;
      exit ;
    end;



    EdtCtrl.Text := SelectedItem.SubItems[1];
    for I := 0 to cbbJWD.items.count - 1 do
    begin
      if cbbJWD.items[i] =  SelectedItem.SubItems[2]  then
      begin
        cbbJWD.ItemIndex := i ;
        break ;
      end;
    end;
  finally
    EdtCtrl.OnChange := edtTrainmanChange;
  end;
end;

procedure TFrmEditInRoom.UnInitUI;
begin
  edtTrainman1.OnChange := nil;

  edtTrainman1.OnSelected := nil;

  edtTrainman1.OnPrevPage := nil;
  edtTrainman1.OnNextPage := nil;
end;

procedure TFrmEditInRoom.UseCallWorkTime(bUse: Boolean);
begin
  dtpJiaoBanDay.Enabled := bUse;
  dtpJiaoBanTime.Enabled := bUse;

  if bUse then
  begin
    dtpJiaoBanDay.Date := DateOf(GlobalDM.GetNow);
    dtpJiaoBanTime.Time := TimeOf(IncHour(GlobalDM.GetNow,4));
  end;
end;

procedure TFrmEditInRoom.UseWaitWorkTime(bUse: Boolean);
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
