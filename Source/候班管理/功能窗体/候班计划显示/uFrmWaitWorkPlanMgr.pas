unit uFrmWaitWorkPlanMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, ToolWin,uDBWaitWork,uGlobalDM,uFrmEditWaitWork,
  ExtCtrls,uWaitWork,DateUtils,uTrainman, jpeg, StdCtrls,
  RzPanel,uSaftyEnum, Grids, AdvObj, BaseGrid,
  AdvGrid,uWaitWorkMgr,uFrmCreateWaitWorkPlan,uTFVariantUtils, Buttons,
  PngCustomButton,ufrmTextInput,ufrmSelectColumn, Menus,ufrmHint,uTFSystem,
  uFrmModifyCallWorkTime,uRoomSignConfig,ufrmTimeRange,
  uFrmLoadWaitPlan,uFrmMunualCall,uRoomCallApp,uFrmMatchWaitMan,uPubFun,
  uFrmSelWaitTrainNo,uRoomCall,uDBLocalTrainman,ufrmTrainmanIdentityAccess,
  uTFMessageDefine,uTFMessageComponent,uRunSaftyMessageDefine,uDBTrainJiaolu,
  uTrainplan,uLCTrainPlan,uWorkShop,uDBWorkShop,uTrainJiaolu,uFrmNotifyNotOutRoom,
  uLogs,uCallRoomFunIF,uDBSignPlan,uSignPlan,uFrmAutoCloseQry,uProgressCommFun,superobject;



const
  BUTTON_NORMAL_IMAGE:string='����.png';    //����ͼƬ
  BUTTON_DOWN_IMAGE:string='����.png';      //����ͼƬ
  BUTTON_DISABLE_IMAGE:string='����.png';    //����ͼƬ


  MENU_ITEM_WIDTH  : integer = 240 ;    //�˵����
  MENU_ITEM_HEIGHT : integer = 40 ;     //�˵��߶�

type


//cl_PlanState{״̬}
//cl_WaitWorkTime{���ʱ��}


TColIndeAry = (cl_Index{���},
      cl_TrainNo{����},cl_RoomNum{����}, cl_JoinRooms{���з���},
      cl_TM1{����Ա1},cl_TMState1{״̬1} ,cl_TM2{����Ա2},cl_TMState2{״̬2} ,
      cl_InRoomTime{��Ԣʱ��},
      cl_KaiCheTime,cl_CallWorkTime{�а�ʱ��});

  TFrmWaitWorkPlanMgr = class(TForm)
    tmRefresh: TTimer;
    rzpnlBody: TRzPanel;
    rzpnl3: TRzPanel;
    btnDel: TPngCustomButton;
    btnInOutRoom: TPngCustomButton;
    pMenuColumn: TPopupMenu;
    miSelectColumn: TMenuItem;
    rzpnl2: TRzPanel;
    gridPlan: TAdvStringGrid;
    edtTrainNo: TEdit;
    pmOP: TPopupMenu;
    MenuItem2: TMenuItem;
    btnTuDingLoad: TPngCustomButton;
    btnModifyCallWork: TPngCustomButton;
    btnCall: TPngCustomButton;
    btnFindTrainNo: TPngCustomButton;
    mniModifyRoom: TMenuItem;
    N6: TMenuItem;
    N8: TMenuItem;
    N2: TMenuItem;
    mniModifyCheCi: TMenuItem;
    N13: TMenuItem;
    pos1: TMenuItem;
    pos2: TMenuItem;
    pos3: TMenuItem;
    pos4: TMenuItem;
    mniModifyLianJiaoRoom: TMenuItem;
    btnFindRoomNumber: TPngCustomButton;
    btnNowCall: TPngCustomButton;
    btnFindTrainmanByName: TPngCustomButton;
    cmbTrainman: TComboBox;
    cmbRoom: TComboBox;
    mniMatchKeChe: TMenuItem;
    N1: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    miSelectFont: TMenuItem;
    FontDialog1: TFontDialog;
    miSetRowHeight: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure tmRefreshTimer(Sender: TObject);
    procedure btnModifyClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TrainmanPicture1Paint(Sender: TObject);
    procedure GridPlanClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure btnInOutRoomClick(Sender: TObject);
    procedure miSelectColumnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure gridPlanGetCellColor(Sender: TObject; ARow, ACol: Integer;
      AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure gridPlanMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure gridPlanCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure gridPlanKeyPress(Sender: TObject; var Key: Char);
    procedure gridPlanEditCellDone(Sender: TObject; ACol, ARow: Integer);
    procedure gridPlanCellValidate(Sender: TObject; ACol, ARow: Integer;
      var Value: string; var Valid: Boolean);
    procedure btnModifyCallWorkClick(Sender: TObject);
    procedure btnFindTrainmanByNameClick(Sender: TObject);
    procedure btnFindTrainNoClick(Sender: TObject);
    procedure edtTrainNoKeyPress(Sender: TObject; var Key: Char);
    procedure edtGHKeyPress(Sender: TObject; var Key: Char);
    procedure btnTuDingLoadClick(Sender: TObject);
    procedure btnCallClick(Sender: TObject);
    procedure btnMatchWaitManClick(Sender: TObject);
    procedure pmOPPopup(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);

    procedure mniModifyLianJiaoRoomClick(Sender: TObject);
    procedure mniModifyRoomClick(Sender: TObject);
    procedure miSelectFontClick(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure mniModifyCheCiClick(Sender: TObject);
    procedure tmrNotifyOutRoomTimer(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure btnWaitSignClick(Sender: TObject);
    procedure pos1Click(Sender: TObject);
    procedure pos2Click(Sender: TObject);
    procedure pos3Click(Sender: TObject);
    procedure pos4Click(Sender: TObject);
    procedure btnAddTrainmanClick(Sender: TObject);
    procedure btnFindRoomNumberClick(Sender: TObject);
    procedure btnNowCallClick(Sender: TObject);
    procedure cmbTrainmanKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cmbRoomKeyPress(Sender: TObject; var Key: Char);
    procedure cmbTrainmanKeyPress(Sender: TObject; var Key: Char);
    procedure mniMatchRoomClick(Sender: TObject);
    procedure mniMatchKeCheClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure miSetRowHeightClick(Sender: TObject);
  private
    m_picMem : TMemoryStream ;
    //������
    m_WaitWorkMgr:TWaitWorkMgr;
    //ǩ�����ݿ����
    m_DBSign:TDBSignPlan;
    //������Ա���ݿ����
    m_DBTrainman :TRsDBLocalTrainman;
    //��ǰѡ����Ա
    m_curTrainmanInfo:TWaitWorkTrainmanInfo;
    //��Ԣ����
    m_obRoomSignConfig:TRoomSignConfigOper;
     //WEB�ƻ��ӿ�
    m_webTrainPlan:TRsLCTrainPlan;
    //�����б�
    m_WorkShopAry:TRsWorkShopArray;
    //�������ݿ����
    m_DBWorkShop:TRsDBWorkShop;
    //��·�б�
    m_TrainJiaoluAry:TRsTrainJiaoluArray;
    //�ͻ��˹�ע��·
    m_ClientTrainJiaoLuAry:TRsTrainJiaoluArray;
    //�а��߼�
    m_RoomCallApp:TRoomCallApp;

    //�ƻ��б�
    //m_PlanList:TWaitWorkPlanList;
  private
    {����:�ж��Ƿ��ע��·}
    function bGuanzhuJiaoLu(strJiaoLuGUID:string):Boolean;
    {����:������ԱGUID,��ȡ��Ա����(����)}
    function GetTrainmanNameNum(waitTrainman:TWaitWorkTrainmanInfo):string;
    {����:��ȡ��Ա������}
    function FindTrainmanCol(nIndex:Integer):Integer;
    {����:���Grid�ƻ��б�}
    procedure FillGrid();
    {����:���grid�ƻ��б���}
    procedure FillGridLine(nRow:Integer;plan:TWaitWorkPlan);
    {����:�ж�ָ�����Ƿ�Ϊ����Ա1}
    function IsTrainman1Col(nCol: Integer): Boolean;
    {����:�ж�ָ�����Ƿ�Ϊ����Ա2}
    function IsTrainman2Col(nCol: Integer): Boolean;
    {����:�ж�ָ�����Ƿ�Ϊ����Ա3}
    function IsTrainman3Col(nCol: Integer): Boolean;
    {����:�ж�ָ�����Ƿ�Ϊ����Ա4}
    function IsTrainman4Col(nCol: Integer): Boolean;
    {����:���빫Ԣ}
    procedure InOutRoom(trainman:RRsTrainman;eVerifyFlag: TRsRegisterFlag);
    {����:�빫Ԣ}
    procedure InRoom(plan:TWaitWorkPlan);
    {����:���빫Ԣ�Ǽ�}
    procedure InRoomLogin(InRoomWorkPlan:TInRoomWorkPlan;eVerifyFlag: TRsRegisterFlag);
    {����:���ǩ��}
    //procedure WaitSign(trainman:RRsTrainman;eVerifyFlag: TRsRegisterFlag);
    {����:�ж��Ƿ���Ϣ�㹻}
    function CheckCanOutRoom(waitTM:TWaitWorkTrainmanInfo) :Boolean;
    {����:��ֵ��Ԣ��Ϣ}
    procedure SetInOutRoomInfo(waitPlan:TWaitWorkPlan;trainman:RRsTrainman;var InOutRoomInfo:RRSInOutRoomInfo;
        eVerifyType :TRsRegisterFlag;eInOutType:TInOutRoomType);
    {����:�����Ա��Ϣ}
    procedure FillTrainmanInfo(plan:TWaitWorkPlan;nTMIndex:Integer);
    //{����:�޼ƻ���Ԣ}
   // function InRoomWithNoPlan(trainman:RRsTrainman;var tmInfo:TWaitWorkTrainmanInfo):boolean;
    {����:ָ�����ߴ�����Ԣ�ƻ�}
    function SetPlan(trainman: RRsTrainman;var plan:TWaitWorkPlan):Boolean;
    function SetPlan2(InRoomWorkPlan:TInRoomWorkPlan;var plan:TWaitWorkPlan):Boolean;
    {����ƥ����Ԣ�ƻ�}
    function MatchPlan(InRoomWorkPlan: TInRoomWorkPlan;var plan:TWaitWorkPlan):Boolean;
    {���ܸ�����Ԣ�ƻ��������ƻ� }
    function  CreateWaitWorkPlanFromInRoomPlan(InRoomWorkPlan:TInRoomWorkPlan;out plan:TWaitWorkPlan):Boolean;

    {����:��ȡѡ���мƻ�}
    function GetPlan(nIndex:Integer):TWaitWorkPlan;
    {����:�޸ķ���}
    function  MoifyRoom(plan:TWaitWorkPlan):Boolean ;
    {����:focus���}
    procedure FocusRoomByCheCi(strTrainNo:string);
    {����:focus���}
    procedure FocusRoomByRoomNumber(strRoomNumber:string);
    {����:focus���}
    procedure FocusRoomNumber(strRoomNumber:string);
    {����:��ȡ������Ӧ��˾������}
    function GetSelectTMIndex(nCol:Integer):Integer;
    {����:�����ƻ�}
    procedure ChangeWaitPlan();
    {����:��������}
    procedure ChangeRoom();
    {����:��������}
    procedure MatchKeCheRoom();
    {����:ƥ��ͳ�����}
    procedure MatchKeChePlan();
    {����:�޸���Աλ��}
    function ExchangeTMIndex(nDestIndex:Integer ):Boolean;
    {����:��ʼ��UI}
    procedure InitUi();
    {����:��ʼ����ť }
    procedure InitButtons();
    {����:��ʼ������ }
    procedure InitUiFont();
    {����:��ť����ͼƬ}
    procedure ButtonLoadImage(Button:TPngCustomButton;FilePath:string);

  private
    procedure ManaualCallRoom(RoomNumber:string);
  public

    {����:�յ��������Ϣ,�󴴽����ƻ�}
    function Msg_CreateWaitPlan(strData:string):Integer;
    {����:�ж��Ƿ�ͼ����೵��}
    function Msg_CheckTrainNo(strData:string):Integer;
    {��ʼ����Ϣ���}
    procedure InitMsgComponent();
     {����:��Ϣ�����Ϣ���ݻص�}
    procedure OnTFMessage(TFMessages: TTFMessageList);
    {����:��Ϣ�������ص�}
    procedure OnMessageError(strText: string);
     {����:��ȡ���ƻ�}
    procedure GetShowPlanS();
    {����:ˢ������}
    procedure RefreshData();
    {����:ˢ����Ա�б�����}
    procedure RefreshQueryNameList();
    {����:ˢ�·�������}
    procedure RefreshQueryRoomList();
    {����:ˢ�³�������}
    procedure RefreshQueryTrainNoList();
    {����:���ָ��ʶ��}
    procedure SetOnFingerTouch();
    {����:����ͼ�����ƻ�}
    procedure LoadTuDingWaitPlan();
    {����:ƥ��ǩ��ƻ�}
    procedure MatchSignPlan();
    {����:ָ�ƴ����¼�}
    procedure OnFingerTouching(Sender: TObject);
    {����:��������а�ƻ�}
    procedure CreateRoomCallPlan( waitPlan:TWaitWorkPlan; out RoomcallPlan:TCallRoomPlan);
    {����:���ҳ���}
    function FindWorkShop_ByJiaolu(strTrainJiaoLUGUID:string;var workShop:RRsWorkShop):Boolean;

    {����:�����ɰ�ƻ����ɺ��ƻ�}
    function CreateWaitPlan_ByAssign(PlanGUIDS:TStrings):Boolean;
    {����:�����ɰ�ƻ����º��ƻ�}
    function UpdateWaitPlan_ByAssign(PlanGUIDS:TStrings):Boolean;
    {����:�����ɰ�ƻ�ɾ�����ƻ�}
    function DelWaitPlan_ByAssign(PlanGUIDS:TStrings):Boolean;
    {����:����ǩ��ƻ����º��ƻ�}
    function UpdateWaitPlan_ByOutWorkSign(planGUID:string):Boolean;
    {����:��λ��Ա}
    procedure FocusTrainman(trainman:RRSTrainman);
  end;
var
  FrmWaitWorkPlanMgr: TFrmWaitWorkPlanMgr;

implementation

uses
  ufrmQuestionBox,uFrmEditWaitWorkJiNing,ufrmSelectTrainman2,uFrmEditInRoom,
  uFrmCreateWaitWorkPlan_JiNing ,uFrmJiNingTrainmanEdit,uFrmModifyCallKaiCheTime,
  ufrmTextInput2,uFrmJoinRoomManager,uDrawMenu;

{$R *.dfm}

//
//function TFrmWaitWorkPlanMgr.AutoFirstCall(CallPlan: TCallRoomPlan): Boolean;
//var
//  roomDev:RCallDev;
//  strMsg:string;
//  callrecord :TcallRoomRecord;
//begin
//  result := False;
//  if CallPlan.bNeedFirstCall(GlobalDM.GetNow) then
//  begin
//    if m_RoomCallApp.CallDevOp.bCalling = False then
//    begin
//      if m_RoomCallApp.DBCallDev.FindByRoom(CallPlan.strRoomNum,roomDev) then
//      begin
//        callrecord.nDeviceID := roomDev.nDevNum;
//        CreateAutoFirstCallRecord(CallPlan,callrecord);
//        m_RoomCallApp.CallDevOp.CallRecord := callrecord;
//        m_RoomCallApp.CallDevOp.AutoFirstCall(strMsg) ;
//        Result := True;
//      end;
//    end;
//  end;
//end;
//
//function TFrmWaitWorkPlanMgr.AutoReCall(CallPlan: TCallRoomPlan): Boolean;
//var
//  roomDev:RCallDev;
//  strMsg:string;
//  callrecord :TcallRoomRecord;
//begin
//  result := False;
//  //�Ѵ߽�
//  if CallPlan.dtReCallTime >1 then Exit;
//  if CallPlan.bNeedReCall(GlobalDM.GetNow) then
//  begin
//    if m_RoomCallApp.CallDevOp.bCalling = False then
//    begin
//      if m_RoomCallApp.DBCallDev.FindByRoom(CallPlan.strRoomNum,roomDev) then
//      begin
//        callrecord.nDeviceID := roomDev.nDevNum;
//        CreateAutoReCallRecord(CallPlan,callrecord);
//        m_RoomCallApp.CallDevOp.CallRecord := callrecord;
//        m_RoomCallApp.CallDevOp.AutoReCall(strMsg) ;
//        result := True;
//      end;
//    end;
//  end;
//end;

function TFrmWaitWorkPlanMgr.bGuanzhuJiaoLu(strJiaoLuGUID: string): Boolean;
var
  i:Integer;
begin
  result := False;
  for I := 0 to Length(m_ClientTrainJiaoLuAry) - 1 do
  begin
    if m_ClientTrainJiaoLuAry[i].strTrainJiaoluGUID = strJiaoLuGUID then
    begin
      result := True;
      Exit;
    end;
  end;
    
end;

procedure TFrmWaitWorkPlanMgr.btnAddTrainmanClick(Sender: TObject);
begin
  TFrmJiNingTrainmanEdit.CreateTrainman();
end;

procedure TFrmWaitWorkPlanMgr.btnCallClick(Sender: TObject);
//var
//  plan:TWaitWorkPlan;
//  callPlan:TCallRoomPlan;
//  strCheCi,strRoomNum:string;
//begin
//  callPlan := nil;
//  if TCallRoomFunIF.GetInstance.bCallling(false) then
//  begin
//    tfMessageBox('���ڽа�!',MB_ICONERROR);
//    Exit;
//  end;
//  plan := GetPlan(GridPlan.Row-1);
//  callPlan:=TCallRoomPlan.Create;
//  if plan <> nil then
//  begin
//    self.CreateRoomCallPlan(plan,callPlan);
//    strCheCi :=  plan.strCheCi;
//    strRoomNum  :=plan.strRoomNum;
//  end;
//  try
//    //MunualCall(callPlan,strCheCi,strRoomNum);
//    strCheCi := '' ;
//    strRoomNum := '' ;
//    TCallRoomFunIF.GetInstance.MunualCall2(callPlan,strCheCi,strRoomNum);
//  finally
//    FreeAndNil(callPlan);
//  end;
//end;
var
  strCheCi,strRoomNum:string;
begin
  if TCallRoomFunIF.GetInstance.bCallling(false) then
  begin
    tfMessageBox('���ڽа�!',MB_ICONERROR);
    Exit;
  end;

  strCheCi := '' ;
  strRoomNum := '' ;
  TCallRoomFunIF.GetInstance.MunualCall2(nil,strCheCi,strRoomNum);
end;

procedure TFrmWaitWorkPlanMgr.ChangeRoom;
var
  oldPlan,NewPlan:TWaitWorkPlan;
  nTMIndex:Integer;
  oldWaitMan:TWaitWorkTrainmanInfo;
  strRoomNum:string;
begin
  oldPlan := GetPlan(GridPlan.Row-1)   ;
  if not Assigned(oldPlan) then
  begin
    tfMessageBox('δѡ����Ч�ļƻ���¼',MB_ICONERROR);
    Exit;
  end;
  nTMIndex := 0 ;
//  nTMIndex := GetSelectTMIndex(gridPlan.RealCol);
//  if nTMIndex = -1  then
//  begin
//    tfMessageBox('δѡ����Ա',MB_ICONERROR);
//    Exit;
//  end;
  oldWaitMan := oldPlan.tmPlanList.Items[nTMIndex];

  if not ((oldWaitMan.eTMState >= psEdit )and (oldWaitMan.eTMState < psoutRoom)) then
  begin
    tfMessageBox('ֻ������Ԣ����Ա�ɸ�������!',MB_ICONERROR);
    Exit;
  end;

  strRoomNum := oldPlan.strRoomNum;
  if TPubFun.InputRoomNum('��������',strRoomNum) = False then Exit;
  NewPlan := m_WaitWorkMgr.planList.FindByRoomNum(strRoomNum);
  if NewPlan <> nil then
  begin
    //if NewPlan.GetTrainmanCount = 4 then
    begin
      tfMessageBox(format('[%s]��������Ա,��������ʧ��!',[strRoomNum]),MB_ICONERROR);
      Exit;
    end;
  end;
  if m_WaitWorkMgr.bRoomExist(strRoomNum) = False then
  begin
    if tfMessageBox('['+ strRoomNum + ']���䲻����,�Ƿ�ǼǴ˷���?')=  False then Exit;
    m_WaitWorkMgr.AddRoom(strRoomNum);
  end;

  oldWaitMan.strRealRoom := strRoomNum;
  m_WaitWorkMgr.SaveChangeRoomInfo(oldWaitMan) ;

end;

procedure TFrmWaitWorkPlanMgr.ChangeWaitPlan();
var
  oldPlan,NewPlan:TWaitWorkPlan;
  nTMIndex:Integer;
  trainman:RRsTrainman;
  oldWaitMan:TWaitWorkTrainmanInfo;
  strRoomNum:string;
begin

  oldPlan := GetPlan(GridPlan.Row-1)   ;
  if not Assigned(oldPlan) then
  begin
    tfMessageBox('δѡ����Ч�ļƻ���¼',MB_ICONERROR);
    Exit;
  end;
  nTMIndex := GetSelectTMIndex(gridPlan.RealCol);
  if nTMIndex = -1  then
  begin
    tfMessageBox('δѡ����Ա',MB_ICONERROR);
    Exit;
  end;
  oldWaitMan := oldPlan.tmPlanList.Items[nTMIndex];
  trainman.strTrainmanGUID := oldWaitMan.strTrainmanGUID;
  trainman.strTrainmanNumber := oldWaitMan.strTrainmanNumber;
  trainman.strTrainmanName := oldWaitMan.strTrainmanName;
  if oldWaitMan.eTMState = psOutRoom then
  begin
    tfMessageBox('�ѳ�Ԣ��Ա�޷������ƻ�!',MB_ICONERROR);
    Exit;
  end;
  
  if TPubFun.InputRoomNum('�����ƻ�',strRoomNum) = False then Exit;
  NewPlan := m_WaitWorkMgr.planList.FindByRoomNum(strRoomNum);
  if NewPlan = nil then
  begin
    //�����¼ƻ�
      if not GlobalDM.bShowUserList then
      begin
        if CreateWaitWorkPlanNoTrainman(NewPlan,strRoomNum)= False then Exit;
      end
      else
      begin
        if CreateWaitWorkPlanNoTrainman_JiNing(NewPlan,strRoomNum)= False then Exit;
      end;
  end;
  if NewPlan.GetTrainmanCount = 4 then
  begin
    tfMessageBox(Format('[%s]��������Ա,�����ƻ�ʧ��!',[strRoomNum]),MB_ICONERROR);
    Exit;
  end;

  m_WaitWorkMgr.ChangeTrainmanWaitPlan(oldWaitMan,oldPlan,NewPlan);

end;

procedure TFrmWaitWorkPlanMgr.btnDelClick(Sender: TObject);
var
  plan,t_Plan:TWaitWorkPlan;
  strText:string;
begin
  plan := TWaitWorkPlan.Create;
  try
    t_Plan := GetPlan(GridPlan.Row-1)   ;
    if not Assigned(t_Plan) then
    begin
      tfMessageBox('δѡ����Ч�ļƻ���¼!',MB_ICONERROR);
      Exit;
    end;
    plan.Clone(t_Plan);
    strText := format('ȷ��ɾ������:[%s]�ļƻ�?',[plan.strRoomNum]);
    if tfMessageBox(strText) = False then Exit;

    m_WaitWorkMgr.DelWaitPlan(plan);
    //GridPlan.RemoveRows(GridPlan.Row,1);
    RefreshData();
  finally
    plan.Free;
  end;

end;

procedure TFrmWaitWorkPlanMgr.btnFindRoomNumberClick(Sender: TObject);
var
  strRoomNumber:string;
begin
  strRoomNumber := Trim(cmbRoom.Text);
  FocusRoomByRoomNumber(strRoomNumber);
end;

procedure TFrmWaitWorkPlanMgr.btnFindTrainmanByNameClick(Sender: TObject);
var
  strText:string;
  i:Integer;
  plan:TWaitWorkPlan;
  waitTrainman:TWaitWorkTrainmanInfo;
  strName:string;
  nRow:Integer;
  nCol:Integer;
  nRealCol:integer;
begin
  nRow := 0;
  nCol := 0;
  strName := Trim(cmbTrainman.Text);
  if strName = '' then
  begin
    tfMessageBox('������Ա�����ֲ���Ϊ��!',MB_ICONERROR);
    Exit;
  end;
  

  for I := 0 to m_WaitWorkMgr.planList.Count - 1 do
  begin
    plan := m_WaitWorkMgr.planList.Items[i];
    waitTrainman := plan.tmPlanList.FindTrainman_Name(strName);
    if waitTrainman <> nil then
    begin
      nRow := i+1;
      
      nCol := FindTrainmanCol(waitTrainman.nIndex);
      Break;
    end;
  end;
  if nRow = 0 then
  begin
    tfMessageBox('δ�ҵ���Ա: '+ strName,MB_ICONERROR);
    Exit;
  end;
  nRealCol := nCol;
  //nRealCol := gridPlan.GetRealCol(nCol);
  nRealCol := gridPlan.DisplColIndex(nCol);
  FillTrainmanInfo(plan,waitTrainman.nIndex);

  if nRealCol < gridPlan.VisibleColCount then
    gridPlan.SelectRange(nRealCol,nRealCol,nRow,nRow)
  else
  begin
    gridPlan.SelectRange(0,0,nRow,nRow);
    tfMessageBox(Format('��%d����¼,��%dλ����Ա!',[nRow,waitTrainman.nIndex +1]),MB_ICONERROR);
  end;


  if plan <> nil then
  begin
    strText := Format('�Ƿ��: [%s] �����аࣿ',[plan.strRoomNum]);
    if tfMessageBox(strText,MB_ICONQUESTION)  then
    begin
      plan.dtCallWorkTime := GlobalDM.GetNow;
      plan.bNeedSyncCall :=True;
      m_waitWorkMgr.ModifyCallTime(plan,GlobalDM.bEnableOnesCall);
      FillGrid;
    end;
  end;

  //gridPlan.FocusCell(nRealCol,nRow);
  //gridPlan.MouseToCell(0,0,nRealCol,nRow);

end;

procedure TFrmWaitWorkPlanMgr.btnFindTrainNoClick(Sender: TObject);
var
  strTrainNo:string;
begin
  strTrainNo := Trim(edtTrainNo.Text);
  FocusRoomByCheCi(strTrainNo);

end;

procedure TFrmWaitWorkPlanMgr.FocusRoomByCheCi(strTrainNo:string);
var
  strText:string;
  nIndex:Integer;
  plan:TWaitWorkPlan;
  nRealCol:Integer;
  nRow:Integer;
begin
  plan := nil ;
  nIndex := -1;
  plan := m_WaitWorkMgr.FindPlan_CheCi(strTrainNo,nIndex);
  if plan = nil then
  begin
    Exit;
  end;

  //nRealCol := gridPlan.RealColIndex(Ord(cl_RoomNum));
  nRealCol := gridPlan.DisplColIndex(Ord(cl_RoomNum)) ;
  if nRealCol >= gridPlan.VisibleColCount then
  begin
    nRealCol := 0;
  end;

  nRow := nIndex + 1;
  gridPlan.SelectRange(nRealCol,nRealCol,nRow,nRow);
  gridPlan.FocusCell(nRealCol,nRow);



//  strText := Format('�Ƿ�Ը÷��䣺[%s] �����аࣿ',[plan.strRoomNum]);
//  if TBox(strText)  then
//  begin
//    plan.dtCallWorkTime := GlobalDM.GetNow;
//    plan.bNeedSyncCall :=True;
//    m_waitWorkMgr.ModifyCallTime(plan);
//    FillGrid;
//  end;

end;

procedure TFrmWaitWorkPlanMgr.FocusRoomByRoomNumber(strRoomNumber: string);
var
  strText:string;
  nIndex:Integer;
  plan:TWaitWorkPlan;
  nRealCol:Integer;
  nRow:Integer;
begin
  if strRoomNumber = '' then
  begin
    tfMessageBox('���ҷ���Ų���Ϊ��!',MB_ICONERROR);
    Exit;
  end;

  plan := nil ;
  nIndex := -1;
  plan := m_WaitWorkMgr.FindPlan_ByRoom(strRoomNumber,nIndex);
  if plan = nil then
  begin
    ManaualCallRoom(strRoomNumber);
    exit;
  end;

  //nRealCol := gridPlan.RealColIndex(Ord(cl_RoomNum));
  nRealCol := gridPlan.DisplColIndex(Ord(cl_RoomNum)) ;
  if nRealCol >= gridPlan.VisibleColCount then
  begin
    nRealCol := 0;
  end;

  nRow := nIndex + 1;
  gridPlan.SelectRange(nRealCol,nRealCol,nRow,nRow);
  gridPlan.FocusCell(nRealCol,nRow);


  strText := Format('�Ƿ��: [%s] �����аࣿ',[plan.strRoomNum]);
  //strText := Format('�Ƿ�Է��䣺[%s] �����аࣿ',[strRoomNumber]);
  if tfMessageBox(strText,MB_ICONQUESTION)  then
  begin
    plan.dtCallWorkTime := GlobalDM.GetNow;
    plan.bNeedSyncCall :=True;
    m_waitWorkMgr.ModifyCallTime(plan,GlobalDM.bEnableOnesCall);
    FillGrid;
  end;
end;

procedure TFrmWaitWorkPlanMgr.FocusRoomNumber(strRoomNumber: string);
var
  strText:string;
  nIndex:Integer;
  plan:TWaitWorkPlan;
  nRealCol:Integer;
  nRow:Integer;
begin
  if strRoomNumber = '' then
  begin
    Exit;
  end;

  plan := nil ;
  nIndex := -1;
  plan := m_WaitWorkMgr.FindPlan_ByRoom(strRoomNumber,nIndex);
  if plan = nil then
  begin
    exit;
  end;

  //nRealCol := gridPlan.RealColIndex(Ord(cl_RoomNum));
  nRealCol := gridPlan.DisplColIndex(Ord(cl_RoomNum)) ;
  if nRealCol >= gridPlan.VisibleColCount then
  begin
    nRealCol := 0;
  end;

  nRow := nIndex + 1;
  gridPlan.SelectRange(nRealCol,nRealCol,nRow,nRow);
  gridPlan.FocusCell(nRealCol,nRow);
end;

procedure TFrmWaitWorkPlanMgr.btnInOutRoomClick(Sender: TObject);
var
  plan:TInRoomWorkPlan;
  strTrainNo:string;
  strRoomNumber:string;
begin
  plan := TInRoomWorkPlan.Create;
  try

    //�Ƿ���������
    if GlobalDM.bUninterruptedSign then
    begin
      repeat
        plan.Clear;
        if CreateInRoomPlan(plan) = False then Exit;

        InRoomLogin(plan,rfInput);
        strTrainNo := plan.strCheCi;
        strRoomNumber := plan.strRoomNum;
        RefreshData();
        if strTrainNo <> '' then
          FocusRoomByCheCi(strTrainNo)
        else
          FocusRoomNumber(strRoomNumber)
      until tfMessageBox('�Ƿ����¼��ס����Ϣ',MB_ICONQUESTION) = false;
    end
    else
    begin
        plan.Clear;
        if CreateInRoomPlan(plan) = False then Exit;

        InRoomLogin(plan,rfInput);

        strTrainNo := plan.strCheCi;
        strRoomNumber := plan.strRoomNum;
        RefreshData();
        if strTrainNo <> '' then
          FocusRoomByCheCi(strTrainNo)
        else
          FocusRoomNumber(strRoomNumber)
    end;
  finally
    plan.Free;
  end;
end;

procedure TFrmWaitWorkPlanMgr.btnMatchWaitManClick(Sender: TObject);
begin
  if TFrmMatchWaitMan.MatchWaitMan2Room = True then
    RefreshData();
end;

procedure TFrmWaitWorkPlanMgr.btnModifyCallWorkClick(Sender: TObject);
var
  plan:TWaitWorkPlan;
begin
  try
    plan := GetPlan(gridPlan.GetRealRow-1);
    if not Assigned(plan) then
    begin
      tfMessageBox('��Ч�ļƻ���',MB_ICONERROR);
      Exit;
    end;
    ModifyWaitWorkCallTime(plan);
    FillGrid();

  finally
  end;

end;

procedure TFrmWaitWorkPlanMgr.btnModifyClick(Sender: TObject);
var
  plan,t_Plan:TWaitWorkPlan;
begin
  plan := TWaitWorkPlan.Create;
  try
    t_Plan := GetPlan(GridPlan.Row -1);
    if not Assigned(t_Plan) then
    begin
      tfMessageBox('��ѡ�ƻ���Ч');
      Exit;
    end;
    if m_WaitWorkMgr.bGetInOutRoomInfo(t_Plan.strPlanGUID) then
    begin
      tfMessageBox('������Ա�ĳ��빫Ԣ��Ϣ,�����޸�',MB_ICONERROR);
      Exit;
    end;
    plan.Clone(t_Plan);

    if ((plan.ePlanType = TWWPT_LOCAL) or ((plan.ePlanType = TWWPT_ASSIGN) and (GlobalDM.bUseByPaiBan = True))) then
    begin
      if not GlobalDM.bShowUserList then
        ModifyWaitWorkPlan(plan)
      else
        ModifyWaitWorkPlan_JiNing(plan);
    end
    else
    begin
      if MoifyRoom(plan) = False then exit;
    end;
    RefreshData();
  finally
    plan.Free;
  end;

end;

procedure TFrmWaitWorkPlanMgr.btnNewClick(Sender: TObject);
var
  plan:TWaitWorkPlan;
  strTrainNo:string;
begin
  //�Ƿ������Ա�б�ģʽ
  if not GlobalDM.bShowUserList then
  begin
    if CreateWaitWorkPlan(plan) = False then Exit;
  end
  else
  begin
    if CreateWaitWorkPlan_JiNing(plan) = False then Exit;
  end;

  //�������Ҫ����ǩ�����Զ��Ѽƻ���Ϊ����
  if not GlobalDM.bInRoomSign then
  begin
    InRoom(plan);
  end;

  strTrainNo := plan.strCheCi;
  RefreshData();
  FocusRoomByCheCi(strTrainNo);
  
end;

procedure TFrmWaitWorkPlanMgr.btnNowCallClick(Sender: TObject);
var
  waitPlan:TWaitWorkPlan;
  strMessage:string;
begin
  waitPlan := Self.GetPlan(gridPlan.Row-1);
  if waitPlan = nil then
  begin
    tfMessageBox('δѡ����Ч��¼',MB_ICONERROR);
    Exit;
  end;
  strMessage := Format('�Ƿ��: [%s--%s] �����аࣿ',[waitPlan.strRoomNum,waitPlan.tmPlanList[0].strTrainmanName]);
  if not tfMessageBox(strMessage,MB_ICONQUESTION) then
    Exit;

  waitPlan.dtCallWorkTime := GlobalDM.GetNow;
  waitPlan.bNeedSyncCall :=True;
  m_waitWorkMgr.ModifyCallTime(waitPlan,GlobalDM.bEnableOnesCall);
  FillGrid;
end;

procedure TFrmWaitWorkPlanMgr.btnTuDingLoadClick(Sender: TObject);
begin
  if TFrmLoadWaitPlan.LoadTuDingWaitPlan() = False then Exit;

  RefreshData();
end;

procedure TFrmWaitWorkPlanMgr.btnWaitSignClick(Sender: TObject);
var
  strGH:string;
  trainman:RRsTrainman;
begin
  if not GlobalDM.bShowUserList then
  begin
    if TextInput('���빤��','���������Ա����',strGH) = False then
    begin
      Exit;
    end;
    if m_DBTrainman.GetTrainmanByNumber(strGH,trainman) = False then
    begin
      tfMessageBox('��Ч�Ĺ���!',MB_ICONERROR);
      Exit;
    end;
  end
  else
  begin
    if not TfrmSelectTrainman2.GetTrainman(trainman) then
    begin
      tfMessageBox('��Ч�Ĺ���!', MB_ICONERROR);
      Exit;
    end;
  end;

  InOutRoom(trainman,rfInput);
  RefreshData();
end;

procedure TFrmWaitWorkPlanMgr.ButtonLoadImage(Button: TPngCustomButton;
  FilePath: string);
var
  strAppPath:string;
  strImagePath:string;
begin
  //���빫Ԣ
  strAppPath := ExtractFilePath(Application.ExeName);
  //����
  strImagePath := Format('%s\Images\buttons\%s\%s',[strAppPath,FilePath,BUTTON_NORMAL_IMAGE])  ;
  if FileExists(strImagePath) then
  begin
    Button.NormalPngImage.LoadFromFile(strImagePath);
  end;
  //����
  strImagePath := Format('%s\Images\buttons\%s\%s',[strAppPath,FilePath,BUTTON_DOWN_IMAGE])  ;
  if FileExists(strImagePath) then
  begin
    Button.DownPngImage.LoadFromFile(strImagePath);
  end;

  //����
  strImagePath := Format('%s\Images\buttons\%s\%s',[strAppPath,FilePath,BUTTON_DISABLE_IMAGE])  ;
  if FileExists(strImagePath) then
  begin
    Button.DisablePngImage.LoadFromFile(strImagePath);
  end;
end;

function TFrmWaitWorkPlanMgr.CheckCanOutRoom(waitTM: TWaitWorkTrainmanInfo):Boolean;
var
  dtNow,inRoomTime:TDateTime;
  strSleep:string;
begin
  result := False;
  m_WaitWorkMgr.getInOutRoomInfo(waitTM);
  strSleep:= TPubFun.CalTimeSpanHM(waitTM.InRoomInfo.dtInOutRoomTime,GlobalDM.GetNow);
  dtNow := GlobalDM.GetNow;
  m_WaitWorkMgr.GetInOutRoomInfo(waitTM);
  inRoomTime :=waitTM.InRoomInfo.dtInOutRoomTime ;
  if m_obRoomSignConfig.RoomSignConfigInfo.bEnableTimeLimit = False  then
  begin
    Result := True;
    Exit;
  end;
  if dtNow > inRoomTime then
  begin
    if MinutesBetween(dtNow,inRoomTime) > m_obRoomSignConfig.RoomSignConfigInfo.nSleepTime then
    begin
      Result := True;
      Exit;
    end;
  end;

  if TFrmAutoCloseQry.Box(Format('�Ƿ�����%s��Ԣ,��Ԣ��ʱ��:%s',[waitTM.strTrainmanName,strSleep])
    ,20,False) = False then Exit;
    result := True;
end;
procedure TFrmWaitWorkPlanMgr.cmbRoomKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    btnFindRoomNumber.Click;
end;

procedure TFrmWaitWorkPlanMgr.cmbTrainmanKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
    btnFindTrainmanByName.Click;
end;

procedure TFrmWaitWorkPlanMgr.cmbTrainmanKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

end;

//
//procedure TFrmWaitWorkPlanMgr.CreateAutoFirstCallRecord(callPlan: TCallRoomPlan;
//  out callrecord: TcallRoomRecord);
//begin
//
//end;
//
//procedure TFrmWaitWorkPlanMgr.CreateAutoReCallRecord(callPlan: TCallRoomPlan;
//  out callrecord: TcallRoomRecord);
//begin
//
//end;

procedure TFrmWaitWorkPlanMgr.CreateRoomCallPlan(waitPlan: TWaitWorkPlan;
  out RoomcallPlan: TCallRoomPlan);
var
  manCall:TCallManPlan;
  i:Integer;
begin
 
  
  for i := 0 to waitPlan.tmPlanList.Count - 1 do
  begin
    if waitPlan.tmPlanList.Items[i].strTrainmanGUID <> '' then
    begin
      manCall := TCallManPlan.Create;
      manCall.strGUID := NewGUID;
      manCall.strWaitPlanGUID := waitPlan.strPlanGUID;
      manCall.strTrainmanGUID := waitPlan.tmPlanList.Items[i].strTrainmanGUID;
      manCall.strTrainmanNumber :=waitPlan.tmPlanList.Items[i].strTrainmanNumber;
      manCall.strTrainmanName :=waitPlan.tmPlanList.Items[i].strTrainmanName;
      manCall.strTrainNo := waitPlan.strCheCi;
      manCall.dtCallTime := GlobalDM.GetNow();
      manCall.strRoomNum := waitPlan.tmPlanList.Items[i].strRealRoom;
      manCall.ePlanState := TCS_FIRSTCALL;
      if RoomcallPlan.manList.Count = 0 then
      begin
        RoomcallPlan.Init(manCall);
      end;
      RoomcallPlan.manList.Add(manCall);
    end;
  end;


end;


function TFrmWaitWorkPlanMgr.UpdateWaitPlan_ByOutWorkSign(planGUID:string):Boolean;
var
  s_waitPlan,waitPlan:TWaitWorkPlan;
  workShop:RRsWorkShop;
  signPlan:TSignPlan;
begin
  Result := False ;
  //��ȡ��Ҫǿ�ݵ���Ա�ƻ�
  GlobalDM.LogManage.InsertLog('������Ҫǿ�ݵ���Ա�ƻ�');
  signPlan := TSignPlan.Create;
  try
    if m_DBSign.GetSignPlan(planGUID,signPlan) = False then Exit;
    GlobalDM.LogManage.InsertLog('������Ҫǿ�ݵ���Ա�ƻ�');
    begin

      //�ų����ڵļƻ�
      //if GlobalDM.GetNow >= TrainmanPlan.TrainPlan.dtArriveTime then
      //  Continue ;
      s_waitPlan := TWaitWorkPlan.Create;
      try
        GlobalDM.LogManage.InsertLog(Format('���Ҽƻ�:%S',[signPlan.strGUID]));
        if m_WaitWorkMgr.FindPlan_PlanID_db(signPlan.strGUID,s_waitPlan) = True then
        begin
          GlobalDM.LogManage.InsertLog(Format('�ƻ�����:%S',[signPlan.strGUID]));
          if m_WaitWorkMgr.bGetInOutRoomInfo(s_waitPlan.strPlanGUID) = True then
          begin
            GlobalDM.LogManage.InsertLog(Format('�ƻ�����:%S,����Ԣ��¼����,����',[signPlan.strGUID]));
            Exit;
          end;
          GlobalDM.LogManage.InsertLog(Format('�ƻ�����:%S,���빫Ԣ��¼������,�����޸�',[signPlan.strGUID]));
          FillChar(workShop,SizeOf(workShop),0);
          FindWorkShop_ByJiaolu(signPlan.strTrainJiaoluGUID,workShop);
          s_waitPlan.CreateBySignPlan(signPlan,workShop);
          m_WaitWorkMgr.ModifyPlan(s_waitPlan)
        end
        else
        begin
          GlobalDM.LogManage.InsertLog(Format('�ƻ�������:%S,�������ƻ�',[signPlan.strGUID]));
          waitPlan := TWaitWorkPlan.Create;
          FillChar(workShop,SizeOf(workShop),0);
          FindWorkShop_ByJiaolu(signPlan.strTrainJiaoluGUID,workShop);
          waitPlan.CreateBySignPlan(signPlan,workShop);
          m_WaitWorkMgr.AddPlan(waitPlan)
        end;
      finally
        s_waitPlan.Free;
      end;
    end;

    Result := True ;
  finally
    signPlan.Free;
  end;
end;


function TFrmWaitWorkPlanMgr.UpdateWaitPlan_ByAssign(PlanGUIDS:TStrings):Boolean;
var
  //��Ա�ƻ�
  TrainmanPlan :RRsTrainmanPlan;
  TrainmanPlanArray:TRsTrainmanPlanArray ;
  strError:string;
  i : Integer ;
  s_waitPlan,waitPlan:TWaitWorkPlan;
  workShop:RRsWorkShop;
begin
  Result := False ;
  //��ȡ��Ҫǿ�ݵ���Ա�ƻ�
  GlobalDM.LogManage.InsertLog('������Ҫǿ�ݵ���Ա�ƻ�');

  if not m_webTrainPlan.GetTrainmanPlanOfNeedRest(PlanGUIDS,TrainmanPlanArray,strError) then
    Exit  ;
  try
    GlobalDM.LogManage.InsertLog('������Ҫǿ�ݵ���Ա�ƻ�');
    for I := 0 to Length(TrainmanPlanArray) - 1 do
    begin
      TrainmanPlan := TrainmanPlanArray[i] ;
      //�ų����ڵļƻ�
      //if GlobalDM.GetNow >= TrainmanPlan.TrainPlan.dtArriveTime then
      //  Continue ;
      s_waitPlan := TWaitWorkPlan.Create;
      try
        GlobalDM.LogManage.InsertLog(Format('���Ҽƻ�:%S',[TrainmanPlan.TrainPlan.strTrainPlanGUID]));
        if m_WaitWorkMgr.FindPlan_PlanID_db(TrainmanPlan.TrainPlan.strTrainPlanGUID,s_waitPlan) = True then
        begin
          GlobalDM.LogManage.InsertLog(Format('�ƻ�����:%S',[TrainmanPlan.TrainPlan.strTrainPlanGUID]));
          if m_WaitWorkMgr.bGetInOutRoomInfo(s_waitPlan.strPlanGUID) = True then
          begin
            GlobalDM.LogManage.InsertLog(Format('�ƻ�����:%S,����Ԣ��¼����,����',[TrainmanPlan.TrainPlan.strTrainPlanGUID]));
            Continue;
          end;
          GlobalDM.LogManage.InsertLog(Format('�ƻ�����:%S,���빫Ԣ��¼������,�����޸�',[TrainmanPlan.TrainPlan.strTrainPlanGUID]));
          FillChar(workShop,SizeOf(workShop),0);
          FindWorkShop_ByJiaolu(TrainmanPlan.TrainPlan.strTrainJiaoluGUID,workShop);
          s_waitPlan.CreateByTrainmanPlan(TrainmanPlan,workShop);
          m_WaitWorkMgr.ModifyPlan(s_waitPlan)
        end
        else
        begin
          GlobalDM.LogManage.InsertLog(Format('�ƻ�������:%S,�������ƻ�',[TrainmanPlan.TrainPlan.strTrainPlanGUID]));
          waitPlan := TWaitWorkPlan.Create;
          FillChar(workShop,SizeOf(workShop),0);
          FindWorkShop_ByJiaolu(TrainmanPlan.TrainPlan.strTrainJiaoluGUID,workShop);
          waitPlan.CreateByTrainmanPlan(TrainmanPlan,workShop);
          m_WaitWorkMgr.AddPlan(waitPlan)
        end;
      finally
        s_waitPlan.Free;
      end;
    end;

    Result := True ;
  finally
    ;
  end;
end;



function TFrmWaitWorkPlanMgr.CreateWaitPlan_ByAssign(PlanGUIDS: TStrings): Boolean;
var
  //��Ա�ƻ�
  TrainmanPlan :RRsTrainmanPlan;
  TrainmanPlanArray:TRsTrainmanPlanArray ;
  strError:string;
  i : Integer ;
  s_waitPlan,waitPlan:TWaitWorkPlan;
  workShop:RRsWorkShop;
begin
  Result := False ;
  //��ȡ��Ҫǿ�ݵ���Ա�ƻ�
  GlobalDM.LogManage.InsertLog('��ȡ��Ҫǿ�ݵ���Ա�ƻ�');

  if not m_webTrainPlan.GetTrainmanPlanOfNeedRest(PlanGUIDS,TrainmanPlanArray,strError) then
    Exit  ;

  try
    GlobalDM.LogManage.InsertLog('������Ҫǿ�ݵ���Ա�ƻ�');
    for I := 0 to Length(TrainmanPlanArray) - 1 do
    begin
      TrainmanPlan := TrainmanPlanArray[i] ;
      //�ų����ڵļƻ�
      //if GlobalDM.GetNow >= TrainmanPlan.TrainPlan.dtArriveTime then
      //  Continue ;
      s_waitPlan := TWaitWorkPlan.Create;
      try
        GlobalDM.LogManage.InsertLog(Format('�������ƻ�,�жϼƻ�%s�Ƿ����',[TrainmanPlan.TrainPlan.strTrainPlanGUID])) ;
        if m_WaitWorkMgr.FindPlan_PlanID_db(TrainmanPlan.TrainPlan.strTrainPlanGUID,s_waitPlan) = False then
        begin
          TLog.SaveLog(GlobalDM.GetNow,Format('��ʼ�����ƻ�%s',[TrainmanPlan.TrainPlan.strTrainPlanGUID]));
          waitPlan := TWaitWorkPlan.Create;
          FillChar(workShop,SizeOf(workShop),0);
          FindWorkShop_ByJiaolu(TrainmanPlan.TrainPlan.strTrainJiaoluGUID,workShop);
          waitPlan.CreateByTrainmanPlan(TrainmanPlan,workShop);
          m_WaitWorkMgr.AddPlan(waitPlan) ;
          GlobalDM.LogManage.InsertLog(Format('�ɹ��������ƻ�%s',[waitPlan.strPlanGUID]));
        end;
      finally
        s_waitPlan.Free;
      end;

    end;

    Result := True ;
  finally
    ;
  end;
end;

function TFrmWaitWorkPlanMgr.CreateWaitWorkPlanFromInRoomPlan(
  InRoomWorkPlan: TInRoomWorkPlan; out plan: TWaitWorkPlan): Boolean;
var
  i,j : Integer ;
begin
  Result := False ;
  plan := TWaitWorkPlan.Create;
  plan.strPlanGUID := NewGUID;
  plan.ePlanState := psPublish;
  plan.ePlanType := TWWPT_LOCAL ;

  plan.strCheCi := InRoomWorkPlan.strCheCi ;
  plan.strRoomNum := InRoomWorkPlan.strRoomNum;


  plan.dtWaitWorkTime := InRoomWorkPlan.dtWaitWorkTime;
  plan.bNeedSyncCall := InRoomWorkPlan.bNeedSyncCall;
  plan.dtCallWorkTime := InRoomWorkPlan.dtCallWorkTime;
  plan.bNeedRest := InRoomWorkPlan.bNeedRest ;
  plan.JoinRoomList.Assign(InRoomWorkPlan.JoinRoomList);

  for i := 0 to 3 do
  begin
    plan.AddNewTrianman('','','');
  end;

//  for j := 0 to InRoomWorkPlan.JoinRoomList.Count - 1 do
//  begin
//    for i := 0 to 3 do
//    begin
//      plan.AddNewTrianman('','','');
//    end;
//  end;


  m_waitWorkMgr.AddPlan(plan);
  Result := True
end;

function TFrmWaitWorkPlanMgr.DelWaitPlan_ByAssign(PlanGUIDS: TStrings): Boolean;
var
  i:Integer;
  waitPlan:TWaitWorkPlan;
begin
  GlobalDM.LogManage.InsertLog('ɾ����������ǿ�ݵ���Ա�ƻ�');
  waitPlan := TWaitWorkPlan.Create;
  try
    for i := 0 to PlanGUIDS.Count - 1 do
    begin
      if m_WaitWorkMgr.FindPlan_PlanID_db(PlanGUIDS.Strings[i],waitPlan) = true then
      begin
        GlobalDM.LogManage.InsertLog(Format('�ҵ��ƻ�:%s',[PlanGUIDS.Strings[i]]));
        if m_WaitWorkMgr.bGetInOutRoomInfo(waitPlan.strPlanGUID) = False then
        begin
          m_WaitWorkMgr.DelPlan(waitPlan);
          GlobalDM.LogManage.InsertLog(Format('�ƻ�:%s�޳���Ԣ��¼,ɾ��',[PlanGUIDS.Strings[i]]));
        end
        else
        begin
          GlobalDM.LogManage.InsertLog(Format('�ƻ�:%s�г���Ԣ��¼����',[PlanGUIDS.Strings[i]]));
        end;
      end
      else
      begin
        GlobalDM.LogManage.InsertLog(Format('δ�ҵ��ƻ�:%S',[PlanGUIDS.Strings[i]]));
      end;
    end;
  finally
    waitPlan.Free;
  end;
  result := True;

end;



procedure TFrmWaitWorkPlanMgr.edtGHKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    btnFindTrainmanByNameClick(nil);
  end;
end;

procedure TFrmWaitWorkPlanMgr.edtTrainNoKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #13 then
  begin
    btnFindTrainNoClick(nil);
  end;
end;

procedure TFrmWaitWorkPlanMgr.FillGrid;
var
  i:Integer;
begin
  try
    with GridPlan do
    begin
      BeginUpdate;
      ClearRows(1,10000);
      if m_WaitWorkMgr.planList.count > 0  then
        RowCount := m_WaitWorkMgr.planList.count + 1
      else
      begin
        RowCount := 2;
        Cells[99,1] := ''
      end;
      for i := 0 to m_WaitWorkMgr.planList.Count - 1 do
      begin
        FillGridLine(i+1,m_WaitWorkMgr.planList.Items[i]);
      end;
    end;

  finally
    GridPlan.EndUpdate;
  end;
end;

procedure TFrmWaitWorkPlanMgr.FillGridLine(nRow: Integer; plan: TWaitWorkPlan);
begin
  try
    with GridPlan do
    begin
      Cells[ord(cl_Index), nRow] := IntToStr(nRow);
      plan.UpdatePlanState;
//      Cells[ord(cl_PlanState), nRow] := TRsPlanStateNameAry[plan.ePlanState];

      //����
      Cells[ord(cl_TrainNo), nRow] := plan.strCheCi;
      FontStyles[ord(cl_TrainNo), nRow] := [fsBold];
      //����
      Cells[ord(cl_RoomNum), nRow] := plan.GetAllRoomNumStr();
      FontStyles[ord(cl_RoomNum), nRow] := [fsBold];

      //����
      cells[ord(cl_JoinRooms),nRow] := plan.JoinRoomList.CommaText;
      FontStyles[ord(cl_JoinRooms), nRow] := [fsBold];

      //��Ա1
      if plan.tmPlanList.Items[0] <> nil then
      begin
        Cells[ord(cl_TM1), nRow] := GetTrainmanNameNum(plan.tmPlanList.Items[0]);
        FontStyles[ord(cl_TM1), nRow] := [fsBold];

        Cells[ord(cl_TMState1), nRow] := plan.tmPlanList.Items[0].GetStateStr();

        if plan.tmPlanList.Items[0].InRoomInfo.dtInOutRoomTime <> 0  then
        begin
          //cells[ord(cl_InRoomTime),nRow] := FormatDateTime('yyyy-mm-dd hh:mm:ss',plan.tmPlanList.Items[0].InRoomInfo.dtInOutRoomTime) ;
          cells[ord(cl_InRoomTime),nRow] := FormatDateTime('mm-dd hh:mm:ss',plan.tmPlanList.Items[0].InRoomInfo.dtInOutRoomTime) ;
        end;
      end;


      //��Ա2
      if plan.tmPlanList.Items[1] <> nil then
      begin
        Cells[ord(cl_TM2), nRow] := GetTrainmanNameNum(plan.tmPlanList.Items[1]);
        FontStyles[ord(cl_TM2), nRow] := [fsBold];

        Cells[ord(cl_TMState2), nRow] := plan.tmPlanList.Items[1].GetStateStr();
      end;



      

//      //���ʱ��(����ʱ��)
//      if plan.bNeedRest = True then
//      begin
//        Cells[Ord(cl_WaitWorkTime), nRow] := FormatDateTime('mm-dd hh:mm', plan.dtwaitWorkTime);
//        FontStyles[ord(cl_WaitWorkTime), nRow] := [fsBold];
//      end;

      //�а�ʱ��
      if plan.bNeedSyncCall = True then
      begin
        //Cells[ord(cl_CallWorkTime), nRow] := FormatDateTime('yyyy-mm-dd hh:mm', plan.dtcallWorkTime);
        Cells[ord(cl_CallWorkTime), nRow] := FormatDateTime('mm-dd hh:mm', plan.dtcallWorkTime);
        FontStyles[ord(cl_CallWorkTime), nRow] := [fsBold];
        //Fonts[ord(cl_CallWorkTime), nRow].Name := ''
      end;

      //����ʱ��
      if plan.dtWaitWorkTime <> 0 then
      begin
        //Cells[Ord(cl_KaiCheTime), nRow] := FormatDateTime('yyyy-mm-dd hh:mm', plan.dtWaitWorkTime);
        Cells[Ord(cl_KaiCheTime), nRow] := FormatDateTime('mm-dd hh:mm', plan.dtWaitWorkTime);
        FontStyles[ord(cl_KaiCheTime), nRow] := [fsBold];
      end;

      cells[99, nRow] := plan.strPlanGUID;
    end;
  except
    on e:exception do
    begin
    
    end;
  end;
end;

procedure TFrmWaitWorkPlanMgr.FillTrainmanInfo(plan:TWaitWorkPlan;nTMIndex:Integer);
var
  trainman:RRsTrainman;
  tmInfo: TWaitWorkTrainmanInfo;
  nStart:Integer;
begin
  nStart:= GetTickCount;
  tmInfo := plan.tmPlanList.Items[nTmIndex];
//  lblRealRoom.Caption := '-';
//  lblInRoomTime.Caption := '-';
//  lblSleepTime.Caption:= '-';
  
  if m_DBTrainman.GetTrainman(tmInfo.strTrainmanGUID,trainman) = True then
  begin
    //TrainmanPicture1.Repaint;
  end
  else
  begin
    //m_picMem.Position := 0 ;
    //imgDrink.Picture.Bitmap.LoadFromStream(m_picMem);
  end;


  if tmInfo.strRealRoom <> '' then
  begin
   // lblRealRoom.Caption := tmInfo.strRealRoom;
  end;
  //TtfPopBox.ShowBox(IntToStr(GetTickCount-nstart));
  nStart:= GetTickCount;
  m_WaitWorkMgr.getInOutRoomInfo(tmInfo);
  //TtfPopBox.ShowBox(IntToStr(GetTickCount-nstart));
  if tmInfo.InRoomInfo.strGUID <> '' then
  begin
    //lblInRoomTime.Caption := FormatDateTime('yy-mm-dd hh:mm',tmInfo.InRoomInfo.dtInOutRoomTime);
    if tmInfo.InRoomInfo.dtInOutRoomTime > plan.dtWaitWorkTime then
    begin
      {nMinutes :=MinutesBetween(tmInfo.InRoomInfo.dtInOutRoomTime,plan.dtWaitWorkTime);
      if  nMinutes > 0then
      begin
        lblLate.Caption := IntToStr(nMinutes) + '����';
      end; }
    end;
    //lblSleepTime.Caption := TPubFun.CalTimeSpanHM(tmInfo.InRoomInfo.dtInOutRoomTime,GlobalDM.GetNow);

  end;
  if tmInfo.OutRoomInfo.strGUID <> '' then
  begin
    //lblSleepTime.Caption := TPubFun.CalTimeSpanHM(tmInfo.InRoomInfo.dtInOutRoomTime,tmInfo.OutRoomInfo.dtInOutRoomTime);
  end;

  

end;


function TFrmWaitWorkPlanMgr.FindTrainmanCol(nIndex: Integer): Integer;
begin
  Result := 0;
  case nIndex of
    0:Result := Ord(cl_TM1);
    1:Result := Ord(cl_TM2) ;
//    2:Result := Ord(cl_TM3) ;
//    3:Result := Ord(cl_TM4) ;
  end;
end;

function TFrmWaitWorkPlanMgr.FindWorkShop_ByJiaolu(strTrainJiaoLUGUID: string;
  var workShop: RRsWorkShop): Boolean;
var
  i:Integer;
  strWorkShopGUID:string;
begin
  result := False;
  strWorkShopGUID := '';
  for i := 0 to Length(m_TrainJiaoluAry) - 1 do
  begin
    if m_TrainJiaoluAry[i].strTrainJiaoluGUID = strTrainJiaoLUGUID then
    begin
      strWorkShopGUID := m_TrainJiaoluAry[i].strWorkShopGUID;
      Break;
    end;
  end;

  for I := 0 to Length(m_WorkShopAry) - 1 do
  begin
    if m_WorkShopAry[i].strWorkShopGUID = strWorkShopGUID then
    begin
      workShop := m_WorkShopAry[i];
      result := True;
      Exit;
    end;
  end;
end;

procedure TFrmWaitWorkPlanMgr.FormCreate(Sender: TObject);
begin
  InitUi;
  m_picMem := TMemoryStream.Create;


  m_DBTrainman :=TRsDBLocalTrainman.Create(GlobalDM.LocalADOConnection);
  m_WaitWorkMgr:=TWaitWorkMgr.GetInstance(GlobalDM.LocalADOConnection);
  m_DBSign:=TDBSignPlan.Create(GlobalDM.ADOConnection);
  GridPlan.ColumnSize.Save := false;
  GlobalDM.SetGridColumnWidth(GridPlan);
  GlobalDM.SetGridColumnVisible(GridPlan);
  GlobalDM.ReadGridRowHeight(GridPlan);
  m_obRoomSignConfig := TRoomSignConfigOper.Create(GlobalDM.AppPath + 'config.ini');
  m_obRoomSignConfig.ReadFromFile ;
  m_webTrainPlan := TRsLCTrainPlan.Create(GlobalDM.GetWebUrl,GlobalDM.SiteInfo.strSiteIP,GlobalDM.SiteInfo.strSiteGUID);
  m_DBWorkShop:=TRsDBWorkShop.Create(GlobalDM.LocalADOConnection);
  if GlobalDM.bUseByPaiBan then
  begin
    btnInOutRoom.Visible := False ;
    btnCall.Visible := False;
  end;
end;

procedure TFrmWaitWorkPlanMgr.FormDestroy(Sender: TObject);
begin
  m_picMem.Free ;
  m_DBTrainman.Free;
  GlobalDM.SaveGridColumnWidth(GridPlan);
  GlobalDM.WriteGridRowHeight(GridPlan);
  m_obRoomSignConfig.Free;
   m_webTrainPlan.Free ;
  m_DBWorkShop.Free;
  m_DBSign.Free;
end;

procedure TFrmWaitWorkPlanMgr.FormShow(Sender: TObject);
begin
  m_DBWorkShop.GetAllWorkShop(m_WorkShopAry);
  InitMsgComponent();
  RefreshData();
end;

function TFrmWaitWorkPlanMgr.GetPlan(nIndex: Integer): TWaitWorkPlan;
begin
  Result := nil;
  //if GridPlan.Row < 1 then Exit;;
  //if GridPlan.Row > m_WaitWorkMgr.planList.count then exit;
  if (nIndex >= 0) and (nIndex < m_WaitWorkMgr.planList.count ) then
    Result := m_WaitWorkMgr.planList.Items[nIndex];
end;

function TFrmWaitWorkPlanMgr.GetTrainmanNameNum(waitTrainman:TWaitWorkTrainmanInfo): string;
var
  strWorkShopName:string;
  trainman:RRstrainman;
begin
  result :='';
  trainman.strTrainmanGUID := waitTrainman.strTrainmanGUID;
  trainman.strTrainmanNumber := waitTrainman.strTrainmanNumber;
  trainman.strTrainmanName := waitTrainman.strTrainmanName;

  if GlobalDM.bShowTrainmNumber then
    Result := GetTrainmanText(trainman)
  else
  begin
    strWorkShopName := '' ;
    if trainman.strTrainmanGUID <> '' then
    begin
      m_DBTrainman.GetTrainmanWorkShopName(trainman.strTrainmanGUID,strWorkShopName);
      Result := Format('[%s]        %s',[strWorkShopName,trainman.strTrainmanName]);
    end
    else
      Result := '' ;
  end;
  {
  result := result + #13;
  if waitTrainman.InRoomInfo.strGUID <> '' then
    result := Result +  FormatDateTime('yy-mm-dd HH:nn',waitTrainman.InRoomInfo.dtInOutRoomTime) ;
    }
end;



procedure TFrmWaitWorkPlanMgr.gridPlanCanEditCell(Sender: TObject; ARow,
  ACol: Integer; var CanEdit: Boolean);
begin
  {//����,ֱ���˳�
  if not Assigned( GetPlan(ARow)) then Exit;
  //�а�ʱ���пɱ༭
  if gridPlan.RealColIndex(ACol) = ord(cl_CallWorkTime) then
  begin
    CanEdit := True;
  end; }
  
end;

procedure TFrmWaitWorkPlanMgr.gridPlanCellValidate(Sender: TObject; ACol,
  ARow: Integer; var Value: string; var Valid: Boolean);
var
  nRealCol:Integer;
  strTime:string;
  dtTime:TDateTime;
begin
 {m_dtNow := GlobalDM.GetNow;
  nRealCol := gridPlan.RealColIndex(ACol);
  //���ݿ���ʱ��������ʱ��
  if ( nRealCol = ord(cl_CallWorkTime)) then
  begin
    strTime := Value;
    try
      dtTime := strDecodeTime(strTime,m_dtNow);
    except
      on E: exception do
      begin
        Valid := False;
        Exit;
      end;
    end;
    Value := FormatDateTime('yy-MM-dd hh:nn',dtTime);
    gridPlan.Cells[ACol,ARow]  := Value;
  end; }
end;

procedure TFrmWaitWorkPlanMgr.GridPlanClickCell(Sender: TObject; ARow,
  ACol: Integer);
var
  nTmIndex:Integer;
  nCol:Integer;
  plan:TWaitWorkPlan;

begin


  if ARow = 0 then Exit;

  plan := GetPlan(ARow-1);
  m_curTrainmanInfo := nil;
  if not Assigned(plan) then Exit;

  nCol := GridPlan.RealColIndex(ACol);
  if nCol = ord(cl_RoomNum) then
  begin
    ;
  end;
  

  nTmIndex := -1;
  if IsTrainman1Col(nCol) then nTmIndex := 0;
  if IsTrainman2Col(nCol) then nTmIndex := 1;
  if IsTrainman3Col(nCol) then nTmIndex := 2;
  if IsTrainman4Col(nCol) then nTmIndex := 3;
  if nTmIndex = -1 then Exit;
  gridPlan.FocusCell(ACol,ARow);

  m_curTrainmanInfo := plan.tmPlanList.Items[nTmIndex];
  FillTrainmanInfo(plan,nTmIndex);

end;

function TFrmWaitWorkPlanMgr.GetSelectTMIndex(nCol:Integer):Integer;
begin
    result := -1;
  if IsTrainman1Col(nCol) then result := 0;
  if IsTrainman2Col(nCol) then result := 1;
  if IsTrainman3Col(nCol) then result := 2;
  if IsTrainman4Col(nCol) then result := 3;
end;

procedure TFrmWaitWorkPlanMgr.GetShowPlanS;
var
  dtStart,dtEnd:TDateTime;
begin
  dtStart := DateOf(GlobalDM.GetNow) ;//+ StrToTime('12:00:00') ;
  dtEnd := dtStart + 1;
  m_WaitWorkMgr.planList.Clear;

  m_WaitWorkMgr.GetShowPlanS(dtStart,dtEnd);
end;

procedure TFrmWaitWorkPlanMgr.gridPlanEditCellDone(Sender: TObject; ACol,
  ARow: Integer);
var
  strValue:string;
  dtTime:TDateTime;
begin
  Exit;
  {if gridPlan.RealRowIndex(ACol) = ord(cl_CallWorkTime) then
  begin
    strValue := gridPlan.Cells[ACol,ARow] + ':00' ;
    if TryStrToDateTime(strValue,dtTime)  then
    begin
      //gridPlan.Cells[ACol,ARow] := FormatDateTime(')
    end;
    dtTime :=  StrToDateTime(strValue);
  end; }
end;

procedure TFrmWaitWorkPlanMgr.gridPlanGetCellColor(Sender: TObject; ARow,
  ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
var
  plan:TWaitWorkPlan;
begin
  if ARow = 0 then Exit;
  
  plan := GetPlan(ARow-1);
  if  Assigned(plan) then
  begin

    //˾��1
    if (ACol =ord(cl_TM1)) or (ACol = (ord(cl_tm1)+1))  then
    begin
      with plan.tmPlanList.Items[0] do
      begin
        ABrush.Color := TRsPlanStateColorAry[eTMState];
        if (eTMState = psFirstCall) or  (eTMState = psReCall) then
        begin
          if bCallSucess = False then
          ABrush.Color := clRed;
        end;
      end;
    end;

    if (ACol =ord(cl_TM2)) or (ACol = (ord(cl_tm2)+1))  then
    begin
      with plan.tmPlanList.Items[1] do
      begin
        ABrush.Color := TRsPlanStateColorAry[eTMState];
        if (eTMState = psFirstCall) or  (eTMState = psReCall) then
        begin
          if bCallSucess = False then
          ABrush.Color := clRed;
        end;
      end;
    end;

  end;
end;

procedure TFrmWaitWorkPlanMgr.gridPlanKeyPress(Sender: TObject; var Key: Char);
var
  selectCol : integer;
begin
 { selectCol := gridPlan.RealColIndex(gridPlan.Col);
  if (selectCol = ord(cl_CallWorkTime))
  then
  begin
     if not (Key in ['0'..'9',#8,#13]) then
      Key := #0;
  end; }

end;

procedure TFrmWaitWorkPlanMgr.gridPlanMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  PT: TPoint;
  col,row,selectCol : integer;
begin
  if mbRight <> Button then
    Exit;

  GridPlan.MouseToCell(X,Y,col,row);
  if (row = 0) then
  begin
    pt := Point(X,Y);
    pt := GridPlan.ClientToScreen(pt);
    pMenuColumn.Popup(pt.X,pt.y);
    exit;
  end
  else
  begin
    pt := Point(X,Y);
    pt := GridPlan.ClientToScreen(pt);
    pmOP.Popup(pt.X,pt.y);
  end;
  
end;

procedure TFrmWaitWorkPlanMgr.InitButtons;
begin
  //���빫Ԣ
  ButtonLoadImage(btnInOutRoom,'���빫Ԣ');
end;

procedure TFrmWaitWorkPlanMgr.InitMsgComponent;
begin
  if GlobalDM.bLeaveLine then Exit;
  

  if GlobalDM.bLeaveLine then
    Exit;
  GlobalDM.TFMessageCompnent.OnMessage := OnTFMessage;
  GlobalDM.TFMessageCompnent.Open();
end;


procedure TFrmWaitWorkPlanMgr.InitUi;
var
  drawMenu : TDrawMenu ;
begin
  InitUiFont;
  InitButtons ;

  drawMenu := TDrawMenu.Create ;
  try
    drawMenu.DrawMenus(pMenuColumn);
    drawMenu.DrawMenus(pmOP);
  finally
    drawMenu.free
  end;
end;

procedure TFrmWaitWorkPlanMgr.InitUiFont;
var
  Font : TFont ;
begin
  Font := GlobalDM.UIFont['WaitPlanFont'] ;
  gridPlan.Font.Assign ( Font );
  Font.free;
end;

procedure TFrmWaitWorkPlanMgr.FocusTrainman(trainman:RRSTrainman);
var
  nCol:Integer;
  plan:TWaitWorkPlan;
begin
  plan := m_WaitWorkMgr.FindPlan(trainman.strTrainmanGUID);
  if plan = nil then Exit;

  nCol := 3;
  GridPlanClickCell(gridPlan,plan.nIndex+1,nCol);
  gridPlan.SelectRange(nCol,nCol,plan.nIndex+1,plan.nIndex+1);
  
end;
procedure TFrmWaitWorkPlanMgr.InOutRoom(trainman: RRsTrainman;eVerifyFlag: TRsRegisterFlag);
var
  //tmInfo:TWaitWorkTrainmanInfo;
  plan:TWaitWorkPlan;
  nCol:Integer;
  strMsg:string;
begin
  try
    plan:=m_WaitWorkMgr.FindPlan(TrainMan.strTrainmanGUID);
    if Assigned(plan) then
    begin
      if plan.strRoomNum = '' then
      begin
        if MoifyRoom(plan) = False then Exit;
      end;
    end;

    //�޼ƻ���Ԣ
    if not Assigned(plan) then
    begin
      //ָ����������һ���ƻ�
      if SetPlan(TrainMan,plan) = False then Exit;
      //ָ����Ա
      m_curTrainmanInfo :=plan.AddTrainman(trainman,strMsg);
      if not Assigned(m_curTrainmanInfo) then
      begin
        tfMessageBox(strMsg,MB_ICONERROR);
        Exit;
      end;
    end
    else //�мƻ�
    begin
      m_curTrainmanInfo := plan.tmPlanList.findTrainman(TrainMan.strTrainmanGUID);
    end;

    if m_curTrainmanInfo.eTMState = psOutRoom then
    begin
      tfMessageBox('û�и���Ա�Ĵ��˼ƻ�!',MB_ICONERROR);
      Exit;
    end;

    //�мƻ���Ԣ
    if m_curTrainmanInfo.eTMState = psPublish then
    begin
      //TfrmHint.ShowHint('���ڱ�����Ԣ��Ϣ,���Ժ򡭡�');
      m_curTrainmanInfo.InRoomInfo.SetValue(plan,trainman,GlobalDM.GetNow,eVerifyFlag,
          TInRoom,GlobalDM.DutyUser,globalDM.SiteInfo);
      //SetInOutRoomInfo(plan,trainman,m_curTrainmanInfo.InRoomInfo,eVerifyFlag,TInRoom);
      m_WaitWorkMgr.SaveInRoomInfo(plan,m_curTrainmanInfo);
      //TfrmHint.CloseHintDelay;
    end
    else
    begin
      //�Ƿ������Զ���Ԣ
      if GlobalDM.bAutoLeaveRoom then
      begin
        TfrmHint.ShowHint('����Ա������Ԣ״̬');
        exit ;
      end
      else
      begin
        if (m_curTrainmanInfo.eTMState >= psInRoom) and (m_curTrainmanInfo.eTMState < psOutRoom) then   //�мƻ���Ԣ
        begin
          if CheckCanOutRoom(m_curTrainmanInfo) = False then
            Exit;
          TfrmHint.ShowHint('���ڱ����Ԣ��Ϣ,���Ժ򡭡�');
          m_curTrainmanInfo.OutRoomInfo.SetValue(plan, trainman, GlobalDM.GetNow, eVerifyFlag, TOutRoom, GlobalDM.DutyUser, globalDM.SiteInfo);
      //SetInOutRoomInfo(plan,trainman,m_curTrainmanInfo.OutRoomInfo,eVerifyFlag,TOutRoom);
          m_curTrainmanInfo.OutRoomInfo.strInRoomGUID := m_curTrainmanInfo.InRoomInfo.strGUID;
          m_WaitWorkMgr.SaveOutRoomInfo(plan, m_curTrainmanInfo);
          TfrmHint.CloseHintDelay;
        end;
      end;
    end;


//    nCol := 3+ m_curTrainmanInfo.nIndex;
//    GridPlanClickCell(gridPlan,plan.nIndex+1,nCol);
//    gridPlan.SelectRange(nCol,nCol,plan.nIndex+1,plan.nIndex+1);
  finally
  end;
end;


procedure TFrmWaitWorkPlanMgr.InRoom(plan: TWaitWorkPlan);
var
  i : integer ;
  trainman : RRsTrainman ;
begin
  TfrmHint.ShowHint('���ڱ�����Ԣ��Ϣ,���Ժ򡭡�');
  try
    for I := 0 to plan.tmPlanList.Count - 1 do
    begin
      trainman.strTrainmanGUID := plan.tmPlanList[i].strTrainmanGUID  ;
      trainman.strTrainmanName := plan.tmPlanList[i].strTrainmanName  ;
      trainman.strTrainmanNumber := plan.tmPlanList[i].strTrainmanNumber  ;
      m_curTrainmanInfo := plan.tmPlanList.findTrainman(trainman.strTrainmanGUID);
      if m_curTrainmanInfo.eTMState = psOutRoom then
        Continue ;
      //�мƻ���Ԣ
      if m_curTrainmanInfo.eTMState = psPublish then
      begin
        m_curTrainmanInfo.InRoomInfo.SetValue(plan,trainman,GlobalDM.GetNow,rfInput,
            TInRoom,GlobalDM.DutyUser,globalDM.SiteInfo);
        m_WaitWorkMgr.SaveInRoomInfo(plan,m_curTrainmanInfo);
      end
    end;
  finally
    TfrmHint.CloseHintDelay;
  end;
end;

procedure TFrmWaitWorkPlanMgr.InRoomLogin(InRoomWorkPlan: TInRoomWorkPlan;eVerifyFlag: TRsRegisterFlag);
var
  //tmInfo:TWaitWorkTrainmanInfo;
  plan:TWaitWorkPlan;
  nCol:Integer;
  strMsg:string;
begin
  plan := nil ;
  try
    //�����Ԣ��ԱΪ��
    if InRoomWorkPlan.TrainMan.strTrainmanGUID <> '' then
    begin
      plan:=m_WaitWorkMgr.FindPlan(InRoomWorkPlan.TrainMan.strTrainmanGUID);
//      if Assigned(plan) then
//      begin
//        if plan.strRoomNum = '' then
//        begin
//          if MoifyRoom(plan) = False then Exit;
//        end;
//      end;
      //ƥ��һ��ͼ���ƻ�
      if not Assigned(plan) then
      begin
        //ָ����������һ���ƻ�
          if MatchPlan(InRoomWorkPlan, plan) = False then Exit;
        //ָ����Ա
          m_curTrainmanInfo := plan.AddTrainman(InRoomWorkPlan.trainman, strMsg);
      end
      else
      begin
        m_curTrainmanInfo := plan.tmPlanList.findTrainman(InRoomWorkPlan.TrainMan.strTrainmanGUID);
      end;
    end;
//    else
//    begin
//      //ƥ��һ��ͼ���ƻ�
//      if not Assigned(plan) then
//      begin
//        //ָ����������һ���ƻ�
//          if MatchPlan(InRoomWorkPlan, plan) = False then
//            Exit;
//      end
//      else
//      begin
//        if plan.strRoomNum = '' then
//        begin
//          if MoifyRoom(plan) = False then Exit;
//        end;
//      end;
//    end;

    //��������Ա�Ļ�
    if m_curTrainmanInfo <> nil then
    begin
      if m_curTrainmanInfo.eTMState = psOutRoom then
      begin
        tfMessageBox('û�и���Ա�ļƻ�!',MB_ICONERROR);
        Exit;
      end;

      //�мƻ���Ԣ
      if m_curTrainmanInfo.eTMState <> psOutRoom then
      begin
        //TfrmHint.ShowHint('���ڱ�����Ԣ��Ϣ,���Ժ򡭡�');
        m_curTrainmanInfo.InRoomInfo.SetValue(plan,InRoomWorkPlan.trainman,GlobalDM.GetNow,eVerifyFlag,
            TInRoom,GlobalDM.DutyUser,globalDM.SiteInfo);
        //SetInOutRoomInfo(plan,trainman,m_curTrainmanInfo.InRoomInfo,eVerifyFlag,TInRoom);
        m_WaitWorkMgr.SaveInRoomInfo1(plan,m_curTrainmanInfo,InRoomWorkPlan,GlobalDM.bEnableOnesCall);
        //TfrmHint.CloseHintDelay;
      end
      else
      begin
        //tfMessageBox('����Ա������Ԣ״̬',MB_ICONERROR);
        exit ;
      end;
    end  ;
//    else
//    begin
//      TfrmHint.ShowHint('���ڱ�����Ԣ��Ϣ,���Ժ򡭡�');
//      m_WaitWorkMgr.SaveInRoomInfo2(plan, InRoomWorkPlan);
//      TfrmHint.CloseHintDelay;
//    end;

  finally
  end;
end;

procedure TFrmWaitWorkPlanMgr.SetInOutRoomInfo(waitPlan:TWaitWorkPlan;trainman:RRsTrainman;var InOutRoomInfo:RRSInOutRoomInfo;
        eVerifyType :TRsRegisterFlag;eInOutType:TInOutRoomType);
begin
  with InOutRoomInfo do
  begin
    strGUID := NewGUID;
    if waitPlan.ePlanType = TWWPT_ASSIGN then
      strTrainPlanGUID := waitPlan.strPlanGUID;

    strWaitPlanGUID:= waitPlan.strPlanGUID;
    dtInOutRoomTime:= GlobalDM.GetNow();
    eVerifyType :=eVerifyType;
    strDutyUserGUID:= GlobalDM.DutyUser.strDutyGUID;
    strTrainmanGUID:=trainman.strTrainmanGUID;
    strTrainmanNumber:= trainman.strTrainmanNumber;
    dtCreatetTime :=GlobalDM.GetNow;
    strSiteGUID :=GlobalDM.SiteInfo.strSiteGUID;
    strRoomNumber :=waitPlan.strRoomNum;
    dtArriveTime := waitPlan.dtWaitWorkTime;
    nBedNumber := 0;
    bUploaded:= False;
    eWaitPlanType:=waitPlan.ePlanType;
    eInOutType:=eInOutType;
  end;
end;

procedure TFrmWaitWorkPlanMgr.SetOnFingerTouch;
begin
  GlobalDM.OnFingerTouching := self.OnFingerTouching;
end;

function TFrmWaitWorkPlanMgr.SetPlan(trainman: RRsTrainman;var plan:TWaitWorkPlan): Boolean;
var
  strRoomNum:string;
  strTrainNoList:TStringList;
  strTrainNo:string;
  nIndex:integer;
  strPlanGUID:string;
begin
  result := False;
  plan := nil;
  strTrainNoList:=TStringList.Create;
  m_WaitWorkMgr.DBTMRoomRel.IsHaveTrainmanRoomRelation(trainman.strTrainmanGUID,strRoomNum);
  if TextInput('ѡ�񷿼�','�����뷿���',strRoomNum) = False then Exit;
  {while True do
  begin
    strTrainNoList.Clear;
  //���뷿���, �޷���ֱ���˳�
    if TextInput('ѡ�񷿼�','�����뷿���',strRoomNum) = False then Exit;
    if QuestionBox(Format('ȷ�ϳ���Ա:%s[%s] ���뷿��[%s]��Ϣ?' ,
          [trainman.strTrainmanName,trainman.strTrainmanNumber,strRoomNum])) = True then Break;

    if QuestionBox('�Ƿ��������뷿���?') = False then Break;

  end;  }
  if m_WaitWorkMgr.getAllTrainNoByRoom(strRoomNum,strTrainNoList) = True then
  begin
    if strTrainNoList.Count >1 then
    begin
      strTrainNo := TFrmSelWaitTrainNo.SelectWaitTrainNo(strTrainNoList);
      if strTrainNo ='' then Exit;
    end
    else
    begin
      strTrainNo := strTrainNoList[0];
    end;
    plan:=m_WaitWorkMgr.FindPlan_CheCi(strTrainNo,nIndex);
  end;
  strTrainNoList.Free;

  //�޼ƻ� �������ƻ�,ֵ��Ա���복��,����ʱ��,�а�ʱ��
  if not Assigned(plan) then
  begin
    //if CreateWaitWorkPlanNoTrainman(plan,strRoomNum) = False then Exit;

    if not GlobalDM.bShowUserList then
    begin
      if CreateWaitWorkPlanNoTrainman(plan,strRoomNum)= False then Exit;
    end
    else
    begin
      if CreateWaitWorkPlanNoTrainman_JiNing(plan,strRoomNum)= False then Exit;
    end;


    strPlanGUID := plan.strPlanGUID;
    self.RefreshData();
    plan := m_WaitWorkMgr.planList.Find(strPlanGUID);

  end
  else
  begin
    if tfMessageBox(Format('ȷ�ϳ���Ա:%s[%s] ���뷿��[%s]��Ϣ?' ,
          [trainman.strTrainmanName,trainman.strTrainmanNumber,strRoomNum])) = False then Exit;

  end;
  Result := True;
end;



function TFrmWaitWorkPlanMgr.SetPlan2(InRoomWorkPlan: TInRoomWorkPlan;
  var plan: TWaitWorkPlan): Boolean;
var
  strRoomNum:string;
  strTrainNoList:TStringList;
  strTrainNo:string;
  nIndex:integer;
  strPlanGUID:string;
begin
  result := False;
  plan := nil;
  strTrainNoList:=TStringList.Create;
  m_WaitWorkMgr.DBTMRoomRel.IsHaveTrainmanRoomRelation(InRoomWorkPlan.trainman.strTrainmanGUID,strRoomNum);
  strRoomNum := InRoomWorkPlan.strRoomNum ;
  //if TextInput('ѡ�񷿼�','�����뷿���',strRoomNum) = False then Exit;
  {while True do
  begin
    strTrainNoList.Clear;
  //���뷿���, �޷���ֱ���˳�
    if TextInput('ѡ�񷿼�','�����뷿���',strRoomNum) = False then Exit;
    if QuestionBox(Format('ȷ�ϳ���Ա:%s[%s] ���뷿��[%s]��Ϣ?' ,
          [trainman.strTrainmanName,trainman.strTrainmanNumber,strRoomNum])) = True then Break;

    if QuestionBox('�Ƿ��������뷿���?') = False then Break;

  end;  }
  if m_WaitWorkMgr.getAllTrainNoByRoom(strRoomNum,strTrainNoList) = True then
  begin
    if strTrainNoList.Count >1 then
    begin
      strTrainNo := TFrmSelWaitTrainNo.SelectWaitTrainNo(strTrainNoList);
      if strTrainNo ='' then Exit;
    end
    else
    begin
      strTrainNo := strTrainNoList[0];
    end;
    plan:=m_WaitWorkMgr.FindPlan_CheCi(strTrainNo,nIndex);
  end;
  strTrainNoList.Free;

  //�޼ƻ� �������ƻ�,ֵ��Ա���복��,����ʱ��,�а�ʱ��
  if not Assigned(plan) then
  begin
    //if CreateWaitWorkPlanNoTrainman(plan,strRoomNum) = False then Exit;

    if not GlobalDM.bShowUserList then
    begin
      if CreateWaitWorkPlanNoTrainman(plan,strRoomNum)= False then Exit;
    end
    else
    begin
      if CreateWaitWorkPlanNoTrainman_JiNing(plan,strRoomNum)= False then Exit;
    end;


    strPlanGUID := plan.strPlanGUID;
    self.RefreshData();
    plan := m_WaitWorkMgr.planList.Find(strPlanGUID);

  end
  else
  begin
    if tfMessageBox(Format('ȷ�ϳ���Ա:%s[%s] ���뷿��[%s]��Ϣ?' ,
          [InRoomWorkPlan.trainman.strTrainmanName,InRoomWorkPlan.trainman.strTrainmanNumber,strRoomNum])) = False then Exit;

  end;
  Result := True;
end;

{
function TFrmWaitWorkPlanMgr.InRoomWithNoPlan(trainman:RRsTrainman;var tmInfo: TWaitWorkTrainmanInfo):Boolean;
var
  plan:TWaitWorkPlan;
  item:TListItem;
begin
  result := False;
  tmInfo := nil;
  if SetTrainmanWaitWorkPlan(TrainMan,plan) = True then
  begin
    RefreshData();
    tmInfo := plan.tmPlanList.findTrainman(trainman.strTrainmanGUID);
    result := True;
  end;
  
end; }

function TFrmWaitWorkPlanMgr.IsTrainman1Col(nCol: Integer): Boolean;
begin
  Result := False;

  if (nCol < 0) or (nCol >= GridPlan.ColumnHeaders.Count) then
    Exit;

  Result := (GridPlan.ColumnHeaders.Strings[nCol] = '����Ա');
end;

function TFrmWaitWorkPlanMgr.IsTrainman2Col(nCol: Integer): Boolean;
begin
  Result := False;

  if (nCol < 0) or (nCol >= GridPlan.ColumnHeaders.Count) then
    Exit;

  Result := (GridPlan.ColumnHeaders.Strings[nCol] = '����Ա2');
end;

function TFrmWaitWorkPlanMgr.IsTrainman3Col(nCol: Integer): Boolean;
begin
  Result := False;
  if (nCol < 0) or (nCol >= GridPlan.ColumnHeaders.Count) then
    Exit;

  Result := (GridPlan.ColumnHeaders.Strings[nCol] = '����Ա3');
end;

function TFrmWaitWorkPlanMgr.IsTrainman4Col(nCol: Integer): Boolean;
begin
  Result := False;
  if (nCol < 0) or (nCol >= GridPlan.ColumnHeaders.Count) then
    Exit;

  Result := (GridPlan.ColumnHeaders.Strings[nCol] = '����Ա4');
end;



procedure TFrmWaitWorkPlanMgr.LoadTuDingWaitPlan;
var
  dtBeginTime,dtEndTime:TDateTime;
  strMsg:string;
begin
if not TuDingTimeRange(dtBeginTime,dtEndTime) then
    Exit;

  strMsg := 'ȷ��Ҫ��ͼ�������м��ز���%s��%s�ļƻ���?';
  strMsg := Format(strMsg, [FormatDateTime('yyyy-MM-dd hh:nn', dtBeginTime), FormatDateTime('yyyy-MM-dd hh:nn', dtEndTime)]);

  if Application.MessageBox(PChar(strMsg), '��ʾ', MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then exit;
  try

  finally

  end;
end;

procedure TFrmWaitWorkPlanMgr.ManaualCallRoom(RoomNumber:string);
var
  strCheCi,strRoomNum:string;
begin
  if TCallRoomFunIF.GetInstance.bCallling(false) then
  begin
    tfMessageBox('���ڽа�!',MB_ICONERROR);
    Exit;
  end;

  strCheCi := '' ;
  strRoomNum := RoomNumber ;
  TCallRoomFunIF.GetInstance.MunualCall2(nil,strCheCi,strRoomNum);
end;

procedure TFrmWaitWorkPlanMgr.MatchKeChePlan;
var
  keChePlan,roomPlan:TWaitWorkPlan;
  i:Integer;
  strMessage,strRoomNum,strCheCi:string;
begin
  roomPlan := GetPlan(GridPlan.Row-1)   ;
  if not Assigned(roomPlan) then
  begin
    tfMessageBox('δѡ����Ч�ļƻ���¼',MB_ICONERROR);
    Exit;
  end;

  if roomPlan.strRoomNum = '' then
  begin
    tfMessageBox('Ҫƥ��ķ���Ų���Ϊ��',MB_ICONERROR);
    Exit;
  end;

  if roomPlan.strCheCi <> '' then
  begin
    tfMessageBox('�üƻ��Ѿ����г�����,����ƥ��!',MB_ICONERROR);
    Exit;
  end;
  


  strCheCi := '' ;
  if TextInput('�޸ĳ���','���복��',strCheCi)=False then Exit;

  keChePlan := m_WaitWorkMgr.planList.findByCheCi(strCheCi);
  if keChePlan = nil then
  begin
    tfMessageBox(format('û��[%s]�ҵ��ó���!',[strCheCi]),MB_ICONERROR);
    Exit;
  end  ;

  if keChePlan.tmPlanList.Items[0].strTrainmanGUID <> '' then
  begin
    tfMessageBox('�ó����Ѿ�ƥ���!',MB_ICONERROR );
    Exit;
  end;
  


//  else
//  begin
//    if keChePlan.strRoomNum <> '' then
//    begin
//      tfMessageBox('Ҫƥ��Ŀͳ��ƻ��Ѿ����䷿��!',MB_ICONERROR);
//      Exit;
//    end;
//  end;

  strMessage := Format('�Ƿ�ƥ�ͳ��ƻ�: [%s] ��',[keChePlan.strCheCi ]);
  if not tfMessageBox(strMessage,MB_ICONQUESTION) then
    Exit ;


  //��ȡ¼��ķ�����Ϣ
  roomPlan.strCheCi := keChePlan.strCheCi ;
  roomPlan.bNeedSyncCall := true ;
  roomplan.dtCallWorkTime := keChePlan.dtCallWorkTime ;

  try
    GlobalDM.LogManage.InsertLog('����ƥ��ͳ��ƻ�');
    //�޸ļƻ�ʱ��
    m_waitWorkMgr.ModifyCallTime(roomplan,GlobalDM.bEnableOnesCall);
    //ɾ���ɵ�
    m_WaitWorkMgr.DelWaitPlan(keChePlan);

    GlobalDM.LogManage.InsertLog('ƥ��ͳ��ƻ�����');
  finally
     RefreshData;
  end;
end;

procedure TFrmWaitWorkPlanMgr.MatchKeCheRoom;
var
  strGUID,strPlanGUID:string;
  keChePlan,roomPlan:TWaitWorkPlan;
  i:Integer;
  strMessage,strRoomNum:string;
begin
  keChePlan := GetPlan(GridPlan.Row-1)   ;
  if not Assigned(keChePlan) then
  begin
    tfMessageBox('δѡ����Ч�ļƻ���¼',MB_ICONERROR);
    Exit;
  end;

  if keChePlan.strRoomNum <> '' then
  begin
    BoxErr('�ÿͳ��ƻ��Ѿ�ƥ�������');
    Exit;
  end;


  strRoomNum := '' ;
  if TPubFun.InputRoomNum('���뷿���',strRoomNum) = False then Exit;
  roomPlan := m_WaitWorkMgr.planList.FindByRoomNum(strRoomNum);
  if roomPlan = nil then
  begin
    tfMessageBox(format('[%s]����û�а��żƻ�!',[strRoomNum]),MB_ICONERROR);
    Exit;
  end;

  strMessage := Format('��ƥ�䷿�� :[%s--%s] ��',[roomPlan.strRoomNum,roomPlan.tmPlanList[0].strTrainmanName]);
  if not tfMessageBox(strMessage,MB_ICONQUESTION) then
    Exit ;


  //��ȡ¼��ķ�����Ϣ
  keChePlan.JoinRoomList.Assign(roomPlan.JoinRoomList);
  keChePlan.strRoomNum := roomPlan.strRoomNum;
  for I := 0 to roomPlan.tmPlanList.Count - 1 do
  begin
    //��ǰ����һ��
    strGUID :=  keChePlan.tmPlanList[i].strGUID ;
    strPlanGUID := keChePlan.tmPlanList[i].strPlanGUID ;

    keChePlan.tmPlanList[i].Clone(roomPlan.tmPlanList.Items[i]);
    //�ָ�
    keChePlan.tmPlanList[i].strGUID := strGUID ;
    keChePlan.tmPlanList[i].strPlanGUID := strPlanGUID ;
  end;

  m_WaitWorkMgr.ModifyWorkPlan(keChePlan);
  m_WaitWorkMgr.ModifyInRoomWaitPlanGUID(roomPlan.strPlanGUID,keChePlan.strPlanGUID) ;

  m_waitWorkMgr.ModifyCallTime(keChePlan,GlobalDM.bEnableOnesCall);
  //ɾ���ɵ�
  m_WaitWorkMgr.DelPlan(roomPlan);
  RefreshData;

end;

function TFrmWaitWorkPlanMgr.MatchPlan(InRoomWorkPlan: TInRoomWorkPlan;
  var plan: TWaitWorkPlan): Boolean;
var
  strPlanGUID:string;
  strRoomNum:string;
  strTrainNoList:TStringList;
  strTrainNo:string;
  nIndex:integer;
begin
  result := False;
  plan := nil;
  strTrainNoList  :=  TStringList.Create;
  strRoomNum := InRoomWorkPlan.strRoomNum ;
  //����һ���Ƿ���ƥ��ķ����
  if m_WaitWorkMgr.getAllTrainNoByRoom(strRoomNum,strTrainNoList) = True then
  begin
    strTrainNo := strTrainNoList[0];
    plan:=m_WaitWorkMgr.FindPlan_CheCi(strTrainNo,nIndex);
  end
  else
  begin
    //�ٲ���һ�¼ƻ��Ƿ�ƥ��
    strTrainNo:=  InRoomWorkPlan.strCheCi ;
    if strTrainNo <> '' then
    begin
      plan := m_WaitWorkMgr.FindPlan_CheCi(strTrainNo, nIndex);
      if plan <> nil then
      begin
        if ( plan.strRoomNum <> '' ) and  ( plan.tmPlanList[0].strTrainmanGUID <> '' ) then
        begin
          plan := nil
        end;
      end;
    end;
  end;
  strTrainNoList.Free;

  //�޼ƻ� �������ƻ�,ֵ��Ա���복��,����ʱ��,�а�ʱ��
  if not Assigned(plan) then
  begin
    if CreateWaitWorkPlanFromInRoomPlan(InRoomWorkPlan,plan)= False then Exit;
    strPlanGUID :=  plan.strPlanGUID ;
    self.RefreshData();
    plan := nil ;
    plan := m_WaitWorkMgr.planList.Find(strPlanGUID);
  end
  else
  begin

    if InRoomWorkPlan.Trainman.strTrainmanGUID = '' then
    begin
      tfMessageBox('��Ԣ��Ա����Ϊ��',MB_ICONERROR);
      Exit;
    end;

    //�޸�һ�³�����Ϣ
    plan.strRoomNum := strRoomNum;
    m_WaitWorkMgr.ModifyPlan(plan);
    if tfMessageBox(Format('ȷ�ϳ���Ա:[%s] ���뷿��[%s]��Ϣ?' ,
          [InRoomWorkPlan.trainman.strTrainmanName,strRoomNum])) = False then Exit;

  end;
  Result := True;
end;

procedure TFrmWaitWorkPlanMgr.MatchSignPlan;
begin

end;

procedure TFrmWaitWorkPlanMgr.MenuItem1Click(Sender: TObject);
var
  waitPlan:TWaitWorkPlan;
  waitMan:TWaitWorkTrainmanInfo;
  nTMIndex:Integer;
begin

  
  waitPlan := Self.GetPlan(gridPlan.Row-1);
  if waitPlan = nil then
  begin
    Exit;
  end;
  nTMIndex := GetSelectTMIndex(gridPlan.RealCol);
  if nTMIndex = -1  then
  begin
    Exit;
  end;
  if tfMessageBox('ȷ���Ƴ�����Ա?') = False then Exit;
  waitMan :=waitPlan.tmPlanList.Items[nTMIndex];
  if waitMan.strTrainmanGUID<>''  then
  begin
    if waitMan.eTMState = psPublish then
    begin
      m_WaitWorkMgr.ReMoveTrainman(waitPlan,waitMan);
    end;
  end;
  RefreshData;

end;

procedure TFrmWaitWorkPlanMgr.miSelectColumnClick(Sender: TObject);
begin
  TfrmSelectColumn.SelectColumn(GridPlan,'WaitWorkPlan');
end;

function  TFrmWaitWorkPlanMgr.MoifyRoom(plan:TWaitWorkPlan):Boolean;
var
  strRoomNum:string;
begin
  Result := False;

  if TextInput('�޸ķ������','�����뷿�����',strRoomNum) = false then Exit;
  if m_WaitWorkMgr.bRoomExist(strRoomNum) = False then
  begin
    if tfMessageBox(Format('���������û��[%s]�ŷ���,�Ƿ�����?',[strRoomNum])) = False then Exit;
    m_WaitWorkMgr.AddRoom(strRoomNum);
  end;
  if Assigned (m_WaitWorkMgr.FindPlanByRoom(strRoomNum)) then
  begin
    tfMessageBox('����:[' + strRoomNum + ']�Ѱ��żƻ�',MB_ICONERROR);
    Exit;
  end;

  plan.strRoomNum := strRoomNum;

  m_WaitWorkMgr.ModifyPlan(plan);
  FillGridLine(GridPlan.Row,plan);
  Result := True;
end;

function TFrmWaitWorkPlanMgr.Msg_CheckTrainNo(strData: string): Integer;
var
  waitTime:RWaitTime;
  iJson:ISuperObject;
  strTrainNo:string;
begin
  iJson := SO(strData) ;
  strTrainNo := iJson.S['strTrainNo'];
  result:= 0;
  if m_WaitWorkMgr.DBWaitTime.FindByTrainNo(strTrainNo,waitTime) then
    result := 1;
  
end;

function TFrmWaitWorkPlanMgr.Msg_CreateWaitPlan(strData: string): Integer;
var
  iJson:ISuperObject;
  trainman:RRsTrainman;
  strTrainNo:string;
  waitPlan,s_waitPlan:TWaitWorkPlan;
  nIndex:Integer;
  //strTrainmanGUID,strTrainmanNumber,strTrainmanName:string;
  waitTime:RWaitTime;
begin
  result := 0;
  iJson := so(strData);
  if m_WaitWorkMgr.DBWaitTime.FindByTrainNo(iJson.S['strTrainNo'],waitTime) = False then Exit;
  if waitTime.bMustSleep = False  then Exit;

  waitPlan := TWaitWorkPlan.Create;
  try
    trainman.strTrainmanGUID := iJson.S['strTrainmanGUID'] ;
    trainman.strTrainmanNumber:= iJson.S['strTrainmanNumber'];
    trainman.strTrainmanName :=  iJson.S['strTrainmanName'] ;
    strTrainNo := iJson.S['strTrainNo'];
    s_waitPlan := m_WaitWorkMgr.FindPlan_CheCi(strTrainNo,nIndex);
    if s_waitPlan = nil then
    begin
      if CreateWaitWorkPlan_TrainNo_Traniman(trainman,strTrainNo,s_waitPlan) = False then Exit;
    end
    else
    begin
      waitPlan.Clone(s_waitPlan);
      if waitPlan.tmPlanList.findTrainman(trainman.strTrainmanGUID) <> nil then Exit;
      
      if ModifyWaitWorkPlan_Trainman(trainman,waitPlan) = False then Exit;

    end;
  finally
    waitPlan.Free;
  end;
  self.RefreshData;
  result := 1;
end;

procedure TFrmWaitWorkPlanMgr.N10Click(Sender: TObject);
var
  waitPlan,s_waitPlan:TWaitWorkPlan;
  waitMan:TWaitWorkTrainmanInfo;
  nTMIndex:Integer;
begin
  waitPlan := TWaitWorkPlan.Create;
  try
    s_waitPlan := Self.GetPlan(gridPlan.Row-1);
    if s_waitPlan = nil then
    begin
      Exit;
    end;
    nTMIndex := GetSelectTMIndex(gridPlan.RealCol);
    if nTMIndex = -1  then
    begin
      Exit;
    end;
    waitPlan.Clone(s_waitPlan);
    waitMan :=waitPlan.tmPlanList.Items[nTMIndex];
    if Trim(waitMan.strGUID) = '' then
    begin
      tfMessageBox('���ܶԿ���Ա����',MB_ICONERROR);
      Exit;
    end;
    
    if tfMessageBox(format('ȷ���Ƴ�%s[%s]',[waitMan.strTrainmanName,waitMan.strTrainmanNumber])) = False then Exit;
    m_WaitWorkMgr.ReMoveTrainman(waitPlan,waitMan);

    RefreshData;
  finally
    waitPlan.Free;
  end;
end;

procedure TFrmWaitWorkPlanMgr.N12Click(Sender: TObject);
var
  waitPlan,s_waitPlan:TWaitWorkPlan;
  waitMan:TWaitWorkTrainmanInfo;
  FindPlan:TWaitWorkPlan;
  nTMIndex:Integer;
  trainman:RRsTrainman;
  strGH:string;
begin
  waitPlan := TWaitWorkPlan.Create;
  try
    s_waitPlan := Self.GetPlan(gridPlan.Row-1);
    if s_waitPlan = nil then
    begin
      Exit;
    end;
    nTMIndex := GetSelectTMIndex(gridPlan.RealCol);
    if nTMIndex = -1  then
    begin
      Exit;
    end;
    waitPlan.Clone(s_waitPlan);
    waitMan :=waitPlan.tmPlanList.Items[nTMIndex];
    if tfMessageBox(format('ȷ������%s[%s]',[waitMan.strTrainmanName,waitMan.strTrainmanNumber])) = False then Exit;
    if TextInput('���빤��','���������Ա����',strGH) = False then
    begin
      m_WaitWorkMgr.ReMoveTrainman(waitPlan,waitMan);
    end
    else
    begin
      if m_DBTrainman.GetTrainmanByNumber(strGH,trainman) = False then
      begin
        tfMessageBox('��Ч�Ĺ���!',MB_ICONERROR);
        Exit;
      end;
      FindPlan := m_WaitWorkMgr.FindPlan(trainman.strTrainmanGUID);
      if FindPlan <> nil then
      begin
        tfMessageBox(Format('����:%s ����:%s �Ѵ�����%s��%s����ƻ���',[trainman.strTrainmanNumber,
          trainman.strTrainmanName,FindPlan.strCheCi,FindPlan.strRoomNum]),MB_ICONERROR);
        Exit;
      end;


      waitMan.strTrainmanGUID := trainman.strTrainmanGUID;
      waitMan.strTrainmanNumber := trainman.strTrainmanNumber;
      waitMan.strTrainmanName := trainman.strTrainmanName;
      waitMan.eTMState := psPublish;
      m_WaitWorkMgr.ModifyTrainman(waitMan);
    end;
    RefreshData;
  finally
    waitPlan.Free;
  end;
end;

procedure TFrmWaitWorkPlanMgr.N1Click(Sender: TObject);
var
  waitPlan:TWaitWorkPlan;
begin
  waitPlan := Self.GetPlan(gridPlan.Row-1);
  if waitPlan = nil then
  begin
    tfMessageBox('δѡ����Ч��¼',MB_ICONERROR);
    Exit;
  end;
  ModifyKaiCheCallTime(WaitPlan);
  FillGrid;
end;

procedure TFrmWaitWorkPlanMgr.N4Click(Sender: TObject);
var
  waitPlan:TWaitWorkPlan;
begin
  waitPlan := Self.GetPlan(gridPlan.Row-1);
  if waitPlan = nil then
  begin
    tfMessageBox('δѡ����Ч��¼',MB_ICONERROR);
    Exit;
  end;
  if not tfMessageBox('ȷ����սа�ʱ����') then
    exit ;

  waitPlan.ePlanState := psInRoom ;
  WaitPlan.dtCallWorkTime := 0;
  waitPlan.dtWaitWorkTime := 0 ;
  WaitPlan.bNeedSyncCall := false;

  m_WaitWorkMgr.ClearCallPlan(WaitPlan);
  
  FillGrid;
end;

procedure TFrmWaitWorkPlanMgr.mniModifyLianJiaoRoomClick(Sender: TObject);
var
  Plan:TWaitWorkPlan;
  strRoomNum:string;
begin
  Plan := GetPlan(GridPlan.Row-1)   ;
  if not Assigned(Plan) then
  begin
    tfMessageBox('δѡ����Ч�ļƻ���¼',MB_ICONERROR);
    Exit;
  end;

  {
  if not Plan.bNeedSyncCall  then
  begin
    BoxErr('�üƻ�û�на�ʱ��');
    Exit;
  end;
  }

  if TFrmJoinRoomManager.Edit(Plan) then
    RefreshData;
end;

procedure TFrmWaitWorkPlanMgr.mniModifyRoomClick(Sender: TObject);
begin
  ChangeRoom();
  RefreshData;
end;

procedure TFrmWaitWorkPlanMgr.miSelectFontClick(Sender: TObject);
var
  Font : TFont ;
begin
  Font := GlobalDM.UIFont['WaitPlanFont'] ;
  FontDialog1.Font.Assign( Font );
  Font.free;

  if FontDialog1.Execute(0) then
  begin
    GlobalDM.UIFont['WaitPlanFont'] := FontDialog1.Font ;
    tfMessageBox('����������鿴����')
  end;
end;

procedure TFrmWaitWorkPlanMgr.miSetRowHeightClick(Sender: TObject);
var
  nRowHeight : integer ;
  strHeight : string ;
begin
  nRowHeight := gridPlan.DefaultRowHeight ;
  strHeight := IntToStr(nRowHeight) ;
  if InputText('�������и�','��ʾ',strHeight) then
  begin
    nRowHeight := StrToIntDef(strHeight,40);
    gridPlan.DefaultRowHeight := nRowHeight ;
    GlobalDM.WriteGridRowHeight(GridPlan);
  end;
end;

procedure TFrmWaitWorkPlanMgr.N6Click(Sender: TObject);
var
  waitPlan:TWaitWorkPlan;
begin
  waitPlan := Self.GetPlan(gridPlan.Row-1);
  if waitPlan = nil then
  begin
    tfMessageBox('δѡ����Ч��¼',MB_ICONERROR);
    Exit;
  end;
  ModifyWaitWorkCallTime(WaitPlan);
  FillGrid;
end;

procedure TFrmWaitWorkPlanMgr.N7Click(Sender: TObject);
var
  waitPlan:TWaitWorkPlan;
  waitMan:TWaitWorkTrainmanInfo;
  nTMIndex:Integer;
  trainman:RRsTrainman;
begin
  waitPlan := Self.GetPlan(gridPlan.Row-1);
  if waitPlan = nil then
  begin
    Exit;
  end;
  nTMIndex := GetSelectTMIndex(gridPlan.RealCol);
  if nTMIndex = -1  then
  begin
    Exit;
  end;

  waitMan :=waitPlan.tmPlanList.Items[nTMIndex];
  if waitMan.strTrainmanGUID<>''  then
  begin
    if (waitMan.eTMState >= psInRoom) and (waitMan.eTMState < psOutRoom) then
    begin
      trainman.strTrainmanGUID := waitMan.strTrainmanGUID;
      trainman.strTrainmanNumber:= waitMan.strTrainmanNumber;
      trainman.strTrainmanName := waitMan.strTrainmanName;
      InOutRoom(trainman,rfInput);
    end;
  end;
  RefreshData;
  FocusTrainman(trainman);
end;

procedure TFrmWaitWorkPlanMgr.N8Click(Sender: TObject);
var
  waitPlan:TWaitWorkPlan;
  strText:string;
begin
  waitPlan := Self.GetPlan(gridPlan.Row-1);
  if waitPlan = nil then
  begin
    tfMessageBox('δѡ����Ч��¼',MB_ICONERROR);
    Exit;
  end;

  strText := Format('�Ƿ��: [%s] �����аࣿ',[waitPlan.strRoomNum]);
  if not tfMessageBox(strText,MB_ICONQUESTION) then
    Exit;

  waitPlan.dtCallWorkTime := GlobalDM.GetNow;
  waitPlan.bNeedSyncCall :=True;
  m_waitWorkMgr.ModifyCallTime(waitPlan,GlobalDM.bEnableOnesCall);
  FillGrid;
end;




procedure TFrmWaitWorkPlanMgr.mniMatchKeCheClick(Sender: TObject);
begin
  MatchKeChePlan;
end;

procedure TFrmWaitWorkPlanMgr.mniMatchRoomClick(Sender: TObject);
begin
  exit ;
  MatchKeCheRoom;
end;

procedure TFrmWaitWorkPlanMgr.mniModifyCheCiClick(Sender: TObject);
label
  retry ;
var
  waitPlan,findPlan:TWaitWorkPlan;
  strTrainNo:string;
  nIndex : integer ;
begin
  waitPlan := Self.GetPlan(gridPlan.Row-1);
  if waitPlan = nil then
  begin
    tfMessageBox('δѡ����Ч��¼',MB_ICONERROR);
    Exit;
  end;
  strTrainNo := waitPlan.strCheCi ;

retry :
  if TextInput('�޸ĳ���','���복��',strTrainNo)=False then Exit;

  findPlan := m_WaitWorkMgr.FindPlan_CheCi(strTrainNo,nIndex) ;
  if findPlan <> nil then
  begin
    if ( findPlan.strRoomNum <> '' ) and  ( findPlan.tmPlanList[0].strTrainmanGUID <> '' ) then
    begin
      tfMessageBox('�ó����Ѿ����ڣ��뻻һ������',MB_ICONERROR) ;
      goto retry ;
    end;
  end;
  

  waitPlan.strCheCi := strTrainNo;
  m_waitWorkMgr.ModifyCallTime(waitPlan,GlobalDM.bEnableOnesCall);
  FillGrid;
end;

procedure TFrmWaitWorkPlanMgr.OnFingerTouching(Sender: TObject);
var
  TrainMan: RRsTrainman;
  eVerifyFlag: TRsRegisterFlag;
begin
  try
    GlobalDM.OnFingerTouching := nil;
    if TCallRoomFunIF.GetInstance.bFrmCalling then Exit;
    if not TFrmTrainmanIdentityAccess.IdentfityTrainman(Sender,TrainMan,eVerifyFlag,
      '','','','') then
    begin
      exit;
    end;
    InOutRoom(TrainMan,eVerifyFlag);
    RefreshData();
    FocusTrainman(TrainMan);
  finally
    GlobalDM.OnFingerTouching := OnFingerTouching;
  end;


end;

procedure TFrmWaitWorkPlanMgr.OnMessageError(strText: string);
begin

end;

procedure TFrmWaitWorkPlanMgr.OnTFMessage(TFMessages: TTFMessageList);
var
  GUIDS: TStrings ;
  i: Integer;
begin
  GUIDS := TStringList.Create ;
  try
    for I := 0 to TFMessages.Count - 1 do
    begin
      TFMessages.Items[i].nResult := TFMESSAGE_STATE_RECIEVED;

      if not bGuanzhuJiaoLu(TFMessages.Items[i].StrField['jiaoLuGUID'])then
      begin
        TFMessages.Items[i].nResult := TFMESSAGE_STATE_CANCELD;
        Continue;
      end;

      case TFMessages.Items[i].msg of
        TFM_PLAN_TRAIN_PUBLISH:
        begin
          GlobalDM.LogManage.InsertLog('��Ԣ�˽��յ����յ�������Ա�Ľа���Ϣ');
          GUIDS.Text := TFMessages.Items[i].StrField['GUID'];
          CreateWaitPlan_ByAssign(GUIDS);
          TFMessages.Items[i].nResult := TFMESSAGE_STATE_CANCELD;
        end;
        TFM_PLAN_RENYUAN_PUBLISH :
        //���յ�������Ա�Ľа���Ϣ
        begin
          GlobalDM.LogManage.InsertLog('��Ԣ�˽��յ����յ�������Ա�Ľа���Ϣ');
          GUIDS.Text := TFMessages.Items[i].StrField['GUIDS'];
          CreateWaitPlan_ByAssign(GUIDS);
          TFMessages.Items[i].nResult := TFMESSAGE_STATE_CANCELD;
        end;
          //�޸ĺ��ƻ�
        TFM_PLAN_RENYUAN_UPDATE ,
        TFM_PLAN_RENYUAN_RMTRAINMAN ,
        TFM_PLAN_RENYUAN_RMGROUP:
        begin
          GlobalDM.LogManage.InsertLog('��Ԣ�˽��յ����յ��޸ĺ��ƻ��Ľа���Ϣ');
          GUIDS.Text := TFMessages.Items[i].StrField['GUIDS'];
          UpdateWaitPlan_ByAssign(GUIDS);
          TFMessages.Items[i].nResult := TFMESSAGE_STATE_CANCELD;
        end;
        //ɾ�����ƻ�
        TFM_PLAN_RENYUAN_DELETE ,
        TFM_PLAN_TRAIN_CANCEL :
        begin
          GlobalDM.LogManage.InsertLog('��Ԣ�˽��յ����յ�ɾ�����ƻ��Ľа���Ϣ');
          GUIDS.Text := TFMessages.Items[i].StrField['GUIDS'];


          DelWaitPlan_ByAssign(GUIDS);

          TFMessages.Items[i].nResult := TFMESSAGE_STATE_CANCELD;
        end;
        TFM_PLAN_SIGN_WAITWORK:
        begin
          GlobalDM.LogManage.InsertLog('��Ԣ�˽��յ��޸ĺ��ƻ��Ľа���Ϣ');
          GUIDS.Text := TFMessages.Items[i].StrField['GUIDS'];
          UpdateWaitPlan_ByOutWorkSign(GUIDS.Text);
          TFMessages.Items[i].nResult := TFMESSAGE_STATE_CANCELD;
        end

      else
        begin
          TFMessages.Items[i].nResult := TFMESSAGE_STATE_CANCELD;
          Continue;
        end;
      end;
    end;
    RefreshData();
  finally
    GUIDS.Free ;
  end;

end;

procedure TFrmWaitWorkPlanMgr.pmOPPopup(Sender: TObject);
var
  i:Integer;
  waitPlan:TWaitWorkPlan;
  nTMIndex:Integer;
  waitMan:TWaitWorkTrainmanInfo;
begin

    
  pmOP.Items.Enabled := False;
  waitPlan := Self.GetPlan(gridPlan.Row-1);
  if waitPlan = nil then
  begin
    Exit;
  end;

  if waitPlan.ePlanState < psOutRoom then
  begin
    mniModifyCheCi.Enabled := True; //��Ԣǰ�������޸ĳ���
    mniModifyRoom.Enabled := True ;
  end;

  nTMIndex := GetSelectTMIndex(gridPlan.RealCol);
  if nTMIndex = -1  then
  begin
    Exit;
  end;

  waitMan :=waitPlan.tmPlanList.Items[nTMIndex];
  if waitMan.strTrainmanGUID<>''  then
  begin
    if (waitMan.eTMState >= psPublish) and (waitMan.eTMState <= psReCall) then
    begin
      pmOP.Items[3].Enabled := True;
      pmOP.Items[0].Enabled := True;
      pmOP.Items[1].Enabled := True;
    end;
  end;

end;

procedure TFrmWaitWorkPlanMgr.pos1Click(Sender: TObject);
begin
  ExchangeTMIndex(0);
end;

procedure TFrmWaitWorkPlanMgr.pos2Click(Sender: TObject);
begin
  ExchangeTMIndex(1);
end;

procedure TFrmWaitWorkPlanMgr.pos3Click(Sender: TObject);
begin
  ExchangeTMIndex(2);
end;

procedure TFrmWaitWorkPlanMgr.pos4Click(Sender: TObject);
begin
  ExchangeTMIndex(3);
end;

function TFrmWaitWorkPlanMgr.ExchangeTMIndex(nDestIndex:Integer ):Boolean;
var
  waitPlan,s_waitPlan:TWaitWorkPlan;
  swaitMan,dWaitMan:TWaitWorkTrainmanInfo;
  nTMIndex:Integer;
begin
  waitPlan := TWaitWorkPlan.Create;
  try
    s_waitPlan := Self.GetPlan(gridPlan.Row-1);
    if s_waitPlan = nil then
    begin
      Exit;
    end;
    nTMIndex := GetSelectTMIndex(gridPlan.RealCol);
    if nTMIndex = -1  then
    begin
      Exit;
    end;
    
    waitPlan.Clone(s_waitPlan);
    swaitMan :=waitPlan.tmPlanList.Items[nTMIndex];
    if tfMessageBox(format('ȷ������%s[%s]��λ��',[swaitMan.strTrainmanName,swaitMan.strTrainmanNumber])) = False then Exit;
    dWaitMan := waitPlan.tmPlanList.Items[nDestIndex];
    m_WaitWorkMgr.ExChangeTMPos(swaitMan,dWaitMan);
    RefreshData;
  finally
    waitPlan.Free;
  end;
end;

procedure TFrmWaitWorkPlanMgr.RefreshData;
begin
  try
    SELF.GetShowPlanS;
    FillGrid();

    //ˢ�²�ѯ��Ϣ���б�
    RefreshQueryNameList  ;
    RefreshQueryRoomList ;
    RefreshQueryTrainNoList;
  except
    on e:Exception do
    begin
      tfMessageBox(e.Message,MB_ICONERROR);
    end;
  end;
end;


procedure TFrmWaitWorkPlanMgr.RefreshQueryRoomList;
var
  i : Integer ;
  strRoomNumber:string;
begin
  cmbRoom.Items.Clear;
  for i := 0 to m_WaitWorkMgr.planList.Count - 1 do
  begin
    strRoomNumber := m_WaitWorkMgr.planList[i].strRoomNum;
    if strRoomNumber <> '' then
    begin
      cmbRoom.Items.Add(strRoomNumber);
    end;
  end;
end;

procedure TFrmWaitWorkPlanMgr.RefreshQueryNameList;
var
  i,j : Integer ;
  strName:string;
begin
  cmbTrainman.Items.Clear;
  for i := 0 to m_WaitWorkMgr.planList.Count - 1 do
  begin
    for j := 0 to 4 - 1 do
    begin
      strName := m_WaitWorkMgr.planList[i].tmPlanList[j].strTrainmanName;
      if strName <> '' then
      begin
        cmbTrainman.Items.Add(strName);
      end;
    end;
  end;
end;

procedure TFrmWaitWorkPlanMgr.RefreshQueryTrainNoList;
begin

end;

procedure TFrmWaitWorkPlanMgr.tmrNotifyOutRoomTimer(Sender: TObject);
var
  i:Integer;
  plan:TWaitWorkPlan;
  dtNow:TDateTime;
begin
  dtNow := GlobalDM.GetNow;
  //tmrNotifyOutRoom.Enabled :=False;
  m_RoomCallApp:= TRoomCallApp.GetInstance;
  try
    for i := 0 to m_WaitWorkMgr.planList.Count - 1 do
    begin
      plan := m_WaitWorkMgr.planList.Items[i];
      if plan.bNeedSyncCall = False then continue;
      if plan.ePlanState < psInRoom then Continue ;//����������Ԣ��
      if dtNow < plan.dtCallWorkTime then Continue ;//��δ����а�ʱ��ĺ���
      if DateUtils.MinutesBetween(dtNow,plan.dtCallWorkTime) < m_RoomCallApp.CallConfig.nUnOutRoomNotifyInterval then Continue;//10���Ӻ������
      if (dtNow > plan.dtNotifyUnLeaveTime)
        and ( DateUtils.MinutesBetween(dtNow,plan.dtNotifyUnLeaveTime) >= 5 )
         and ( DateUtils.HoursBetween(dtNow,plan.dtNotifyUnLeaveTime) <= 5 )
        then
      begin
        if TCallRoomFunIF.GetInstance.bCallling = False then
        begin
          //TCallRoomFunIF.GetInstance.UnLeaveNotify(plan);
          m_WaitWorkMgr.UpdateNotifyUnLeaveTime(plan.strPlanGUID,dtNow);
        end;
      end;

    end;
  finally
    //tmrNotifyOutRoom.Enabled:= True;
  end;
    
end;

procedure TFrmWaitWorkPlanMgr.tmRefreshTimer(Sender: TObject);
begin
  RefreshData;
end;

procedure TFrmWaitWorkPlanMgr.TrainmanPicture1Paint(Sender: TObject);
var
  trainman:RRsTrainman;
begin
  if not Assigned(m_curTrainmanInfo) then Exit;
  
  if m_DBTrainman.GetTrainman(m_curTrainmanInfo.strTrainmanGUID,trainman) = True then
  begin
   TTFVariantUtils.CopyJPEGVariantToPaintBox(trainman.Picture,TPaintBox(Sender));
  end;
end;

end.
