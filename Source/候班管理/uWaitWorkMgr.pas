unit uWaitWorkMgr;

interface
uses
  Classes,SysUtils,DateUtils,uWaitWork,uDBWaitWork,ADODB,uTFSystem,uSaftyEnum,
  StrUtils,uRoomCall,uRoomCallApp;
type
  //////////////////////////////////////////////////////////////////////////////
  ///类名:TWaitWorkMgr
  ///描述:候班逻辑
  //////////////////////////////////////////////////////////////////////////////
  TWaitWorkMgr = class
  public
    constructor Create(adoCon:TADOConnection);
    destructor Destroy();override;
  public
    {功能:获取未完成计划信息}
    procedure GetShowPlanS(dtStart,dtEnd:TDateTime);
    {功能:获取前一个候班计划}
    function GetLastWaitPlan_ByTrainNo(strTrainNo:string;waitplan:TWaitWorkPlan):Boolean;
    {功能:获取所有入公未出寓的人员信息}
    procedure GetRoomWaitInfo(waitRoomList:TWaitRoomList);
    {功能:新增计划信息}
    function AddPlan(plan:TWaitWorkPlan;bOnlySaveDB:Boolean = False):Boolean;
    {功能:修改计划}
    procedure ModifyPlan(plan:TWaitWorkPlan);
    {功能:修改计划}
    procedure ModifyWorkPlan(plan:TWaitWorkPlan);
    {功能:修改计划}
    procedure ModifyWorkPlan2(plan:TWaitWorkPlan);
    {功能:修改人员}
    procedure ModifyTrainman(trainmanPlan:TWaitWorkTrainmanInfo);
    {功能:修改叫班时间}
    procedure ModifyCallTime(plan:TWaitWorkPlan;EnableOnesCall:Boolean=false);
    {功能:修改叫班联叫房间}
    procedure ModifyCallJoinRooms(plan:TWaitWorkPlan;EnableOnesCall:Boolean=false);
    {功能:发布叫班计划}
    procedure PublishCallPlan(plan:TWaitWorkPlan);
    {功能:修改车次}
    procedure ModifyTrainNo(plan:TWaitWorkPlan);
    {功能:修改候班人员的叫班状态}
    procedure ModifyTMCallState(planGUID,tmGUID:string;ePlanState: TRsPlanState;dtTime:TDatetime;bSucess:Boolean);
    {功能:移除候班人员}
    procedure ReMoveTrainman(plan:TWaitWorkPlan;waitMan:TWaitWorkTrainmanInfo);
    {功能:交换人员位置}
    procedure ExChangeTMPos(sWaitman,dWaitMan:TWaitWorkTrainmanInfo);
    {功能:删除计划}
    procedure DelPlan(plan:TWaitWorkPlan;bOnlySaveDB:Boolean = False);
    {功能：匹配客车计划}
    procedure MatchKeCheRoom(Roomplan,KeChePlan:TWaitWorkPlan;bOnlySaveDB:Boolean = False);
    {功能:删除计划}
    procedure DelWaitPlan(plan:TWaitWorkPlan;bOnlySaveDB:Boolean = False);
    {功能:清空叫班时间}
    procedure ClearCallPlan(plan:TWaitWorkPlan);
    {功能:删除计划by计划ID}
    procedure DelPlanByID(strPlanGUID:string);
    {功能:获取此房间的所有车次}
    function getAllTrainNoByRoom(strRoomNum: string;
      var strTrainNoList:TStringList): Boolean;

    {功能:修改人员候班计划}
    function ChangeTrainmanWaitPlan(oldWaitMan:TWaitWorkTrainmanInfo;oldPlan,newPlan:TWaitWorkPlan):Boolean;

    {功能:增加待同步候班计划GUID}
    procedure SaveSYNCPlanGUID(planIDInfo:TSyncPlanIDInfo);
    {功能:保存同步计划}
    function SaveSYNCPlan(plan:TWaitWorkPlan):Boolean;
    {功能:获取待同步计划GUID列表}
    procedure GetSYNCPlanGUIDList(strGUIDList:TSyncPlanIDInfoList);
    {功能:删除同步计划byID}
    procedure DelSYNCPlanByID(strPlanGUID:string);
    {功能:删除待同步计划ID}
    procedure DelNeedSyncPlanID(strPlanGUID:string);

    {功能:出入公寓记录匹配出勤计划}
    procedure UpDateInOutRoomTrainPlan(strTrainPlanGUID,strTrainmanGUID:string;dtStartTime:TDateTime);
    {功能:更新未离寓提醒时间}
    procedure UpdateNotifyUnLeaveTime(strPlanGUID:string;dtTime:TDateTime);
    {功能:入寓}
    function SaveInRoomInfo(plan:TWaitWorkPlan;trainmanInfo:TWaitWorkTrainmanInfo):Boolean;
    {功能:入寓}
    function SaveInRoomInfo1(plan:TWaitWorkPlan;
      trainmanInfo:TWaitWorkTrainmanInfo;InRoomWorkPlan: TInRoomWorkPlan;EnableOnesCall:boolean=false):Boolean;
    {功能:入寓没有人员}
    function SaveInRoomInfo2(plan:TWaitWorkPlan;InRoomWorkPlan: TInRoomWorkPlan):Boolean;
    {功能:出寓}
    function SaveOutRoomInfo(plan:TWaitWorkPlan;trainmanInfo:TWaitWorkTrainmanInfo):Boolean;
    {功能:出寓2}
    function SaveOutRoomInfo2(CallPlan: TCallRoomPlan):Boolean;
    {功能:出寓2}
    function SaveOutRoomInfo3(WaitPlanGUID:string;RoomNumber:string):Boolean;
    {功能:修改入寓的代办计划}
    function ModifyInRoomWaitPlanGUID(OldPlanGUID,NewPlanGUID:string):boolean;
    {功能:更换房间}
    function SaveChangeRoomInfo(trainmanInfo:TWaitWorkTrainmanInfo):Boolean;
    {功能:获取实例}
    class function GetInstance(adoCon:TADOConnection = nil):TWaitWorkMgr;
    {功能:释放实例}
    class procedure FreeInstance();
    {功能:获取计划人员信息}
    function FindTrainmanInfo(strTrainmanGUID:string):TWaitWorkTrainmanInfo;
    {功能:查找人员上一次入住的房间}
    function FindTrainmanLastWaitRoom(strTrainmanGUID:string):string;
    {功能:获取计划,根据人员}
    function FindPlan(strTrainmanGUID:string):TWaitWorkPlan;
    {功能:获取计划,根据计划GUID}
    function FindPlan_PlanID(strPlanGUID:string):TWaitWorkPlan;
    {功能:从db中获取计划,根据计划guid}
    function FindPlan_PlanID_DB(strPlanGUID:string;waitplan:TWaitWorkPlan):Boolean;
    {功能:根据车次找计划}
    function FindPlan_CheCi(strTrainNo:string;var nIndex:Integer):TWaitWorkPlan;
    {功能:查找计划,根据房间号}
    function FindPlanByRoom(strRoomNum:string):TWaitWorkPlan;
    function FindPlan_ByRoom(strRoomNum:string;var nIndex:Integer):TWaitWorkPlan;
    {功能:判断是否有出入公寓记录}
    function bGetInOutRoomInfo(strWaitPlanGUID:string):Boolean;
    {功能:获取未上传出入公寓记录}
    procedure GetUnUploadInOutRoomInfo(out inRoomInfoS:RRsInOutRoomInfoArray;
                    out OutRoomInfoS:RRsInOutRoomInfoArray);
    {功能:更新出入公寓记录}
    procedure ModifyInOutRoomInfo(inoutRoomInfo:RRsInOutRoomInfo);

    {功能:获取所有房间信息}
    procedure GetAllRoom(RoomList:TWaitRoomList);
    {功能:增加房间}
    procedure AddRoom(strRoomNum:string);
    {功能:删除房间}
    procedure DelRoom(strRoomNum:string);
    {功能:检测房间}
    function bRoomExist(strRoomNum:string):Boolean;
    {功能:获取出入公寓信息}
    procedure GetInOutRoomInfo(waitTrainman:TWaitWorkTrainmanInfo);

    {功能：制造交班计划}
    procedure CreateCallPlanByRoom(waitPlan:TWaitWorkPlan;RoomNumber:string);
  private
     {功能:设置数据库连接}
    procedure SetDB(adoCon:TADOConnection);
    {功能:根据入公寓信息生成或者修改叫班计划}
    procedure CreateCallManPlan_InRoom(waitPlan:TWaitWorkPlan;inRoomInfo:RRSInOutRoomInfo);
    {功能:根据入公寓信息生成或者修改叫班计划}
    procedure CreateCallManPlan_InRoom_ByRoomNumber(waitPlan:TWaitWorkPlan;RoomNumber:string);
    {功能：修改叫班计划}
    procedure ModifyCallManPlan_InRoom_ByRoomNumber(waitPlan:TWaitWorkPlan;RoomNumber:string);
    {功能:未离寓创建催叫计划}
    procedure CreateReCallManPlan_UnLeave(waitPlan:TWaitWorkPlan;dtRecallTime:TDateTime;inRoomInfo:RRSInOutRoomInfo);
    {功能:修改叫班计划}
    procedure ModifyCallManPlan_InRoom(WaitPlan:TWaitWorkPlan;inRoomInfo:RRSInOutRoomInfo);
    {功能:根据出寓信息删除叫班计划}
    procedure DelCallManPlan_OutRoom(WaitPlanGUID,strTrainmanGUID:string);
    {功能:根据出寓信息删除叫班计划}
    procedure DelCallManPlan_OutRoomByRoom(WaitPlanGUID,strRoomNumber:string);
  public
    //待乘计划列表
    planList:TWaitWorkPlanList;
  private
    //本对象实例
    //class var m_Self:TWaitWorkMgr;
    //待乘计划数据库操作
    m_dbPlan:TDBWaitWorkPlan;
    //待乘计划人员数据库操作
    m_dbPlanTrainman:TDBWaitWorkTrainman;
    //出入公寓记录数据库操作
    m_dbInOutRoom:TRSDBInOutRoom;
    //待同步计划id数据库操作
    m_dbSyncPlanID:TDBSyncPlanID;
    //数据库连接
    m_ADOCon:TADOConnection;
    //房间数据库管理
    m_DBRoom:TDBWaitWorkRoom;
    //候班表
    m_DBWaitTime:TDBWaitTime;
    //人员房间关系
    m_DBTMRoomRel :TDBRoomTrainmanRelation;
   
  public
    property DBPlan :TDBWaitWorkPlan read m_dbPlan;
    property DBWaitTime:TDBWaitTime read m_DBWaitTime;
    property DBWaitMan:TDBWaitWorkTrainman read m_dbPlanTrainman;
    property DBRoom :TDBWaitWorkRoom read m_DBRoom;
    property DBTMRoomRel :TDBRoomTrainmanRelation read m_DBTMRoomRel;
  end;

implementation
uses uGlobalDM;

{ TInOutRoomMgr }
var m_Self:TWaitWorkMgr;


function TWaitWorkMgr.ChangeTrainmanWaitPlan(oldWaitMan: TWaitWorkTrainmanInfo;
    oldPlan,newPlan: TWaitWorkPlan): Boolean;
var
  newWaitMan :TWaitWorkTrainmanInfo;
  callManPlan:TCallManPlan;
begin

  callManPlan:=TCallManPlan.Create;
  TRoomCallApp.GetInstance.DBCallPlan.Find(oldWaitMan.strPlanGUID,oldWaitMan.strTrainmanGUID,callManPlan);

  self.m_ADOCon.BeginTrans;

  try
    try
      GetInOutRoomInfo(oldWaitMan);
      //修改新的人员候班计划
      newWaitMan := newPlan.tmPlanList.FindEmptyTrainman();
      newWaitMan.strPlanGUID := newPlan.strPlanGUID;
      newWaitMan.strTrainmanGUID := oldWaitMan.strTrainmanGUID;
      newWaitMan.strTrainmanNumber := oldWaitMan.strTrainmanNumber;
      newWaitMan.strTrainmanName := oldWaitMan.strTrainmanName;
      newWaitMan.eTMState := oldWaitMan.eTMState;
      if newWaitMan.eTMState = psInRoom then
        newWaitMan.strRealRoom := newPlan.strRoomNum;
      m_dbPlanTrainman.Modify(newWaitMan);
      //修改新的候班计划状态
      newPlan.UpdatePlanState;
      m_dbPlan.Modify(newPlan);

      //修改人员的出入公寓记录,只修改候班计划,和房间号
      if oldWaitMan.InRoomInfo.strGUID <> '' then
      begin
        newWaitMan.InRoomInfo := oldWaitMan.InRoomInfo;
        newWaitMan.InRoomInfo.strWaitPlanGUID := newPlan.strPlanGUID;
        newWaitMan.InRoomInfo.strRoomNumber := newPlan.strRoomNum;
        m_dbInOutRoom.UpdateInRoom(newWaitMan.InRoomInfo);
        //更改叫班计划
        Self.DelCallManPlan_OutRoom(oldWaitMan.strPlanGUID,oldWaitMan.strTrainmanGUID);
        if newPlan.bNeedSyncCall = True then
          Self.CreateCallManPlan_InRoom(newPlan,newWaitMan.InRoomInfo);
      end;


      //置空原人员候班计划
      oldWaitMan.strTrainmanGUID := '';
      oldWaitMan.strTrainmanNumber  := '';
      oldWaitMan.strTrainmanName := '';
      oldWaitMan.strRealRoom := '';
      oldWaitMan.eTMState := psEdit;
      m_dbPlanTrainman.Modify(oldWaitMan);
      //修改原候班计划状态
      //if oldPlan.bAllInRoom then
      //  oldPlan.ePlanState := psInRoom;
      oldPlan.UpdatePlanState;
      m_dbPlan.Modify(oldPlan);


      m_ADOCon.CommitTrans;
    except on e:Exception do
      m_ADOCon.RollbackTrans;

    end;
  finally
    callManPlan.Free;
  end;
end;


procedure TWaitWorkMgr.ClearCallPlan(plan: TWaitWorkPlan);
var
  i:Integer;
begin
  m_ADOCon.BeginTrans;
  try
    //更改叫班计划
    m_dbPlan.Modify(plan);
    //删除叫班计划
    TRoomCallApp.GetInstance.DBCallPlan.DelByWaitPlan(plan.strPlanGUID);
    m_ADOCon.CommitTrans;
  except on e:Exception do
    m_ADOCon.RollbackTrans;
  end;
end;

constructor TWaitWorkMgr.Create(adoCon:TADOConnection);
begin
  SetDB(adoCon);
end;

procedure TWaitWorkMgr.MatchKeCheRoom(Roomplan, KeChePlan: TWaitWorkPlan;
  bOnlySaveDB: Boolean);
var
  i:Integer;
  j:Integer;
  waitMan:TWaitWorkTrainmanInfo;
begin
  m_ADOCon.BeginTrans;
  try
    m_dbPlan.Modify(Roomplan);
    if Roomplan.bNeedSyncCall then
    begin
      //如果一个人也没有
      if (Roomplan.tmPlanList.Items[0].strTrainmanGUID = '' ) and
        (Roomplan.tmPlanList.Items[1].strTrainmanGUID = '' ) and
        (Roomplan.tmPlanList.Items[2].strTrainmanGUID = '' ) and
        (Roomplan.tmPlanList.Items[3].strTrainmanGUID = '' ) then
      begin
        ModifyCallManPlan_InRoom_ByRoomNumber(Roomplan,Roomplan.strRoomNum);
        for j := 0 to Roomplan.JoinRoomList.Count - 1 do
        begin
          ModifyCallManPlan_InRoom_ByRoomNumber(Roomplan,Roomplan.JoinRoomList.Strings[j]);
        end;
      end
      else
      begin
        for i := 0 to Roomplan.tmPlanList.Count - 1 do
        begin
          waitMan :=  Roomplan.tmPlanList.Items[i];
          if waitMan.strTrainmanGUID <> '' then
          begin
            GetInOutRoomInfo(waitMan);
            if (waitMan.eTMState >= psInRoom) and (waitMan.eTMState< psOutRoom) then
            begin
              CreateCallManPlan_InRoom(Roomplan,waitMan.InRoomInfo);
              for j := 0 to Roomplan.JoinRoomList.Count - 1 do
              begin
                ModifyCallManPlan_InRoom_ByRoomNumber(Roomplan,Roomplan.JoinRoomList.Strings[j]);
              end;
            end;
          end;
        end;
      end;
    end;


    //删除客车计划
    m_dbPlan.Del(KeChePlan.strPlanGUID);
    for i := 0 to KeChePlan.tmPlanList.Count - 1 do
    begin
      m_dbPlanTrainman.Del(KeChePlan.tmPlanList.Items[i].strGUID);
    end;
    m_ADOCon.CommitTrans;
    if not bOnlySaveDB then
      planList.Remove(KeChePlan);

    m_ADOCon.CommitTrans;
  except on e:Exception do
    m_ADOCon.RollbackTrans;
  end;
end;

procedure TWaitWorkMgr.ModifyCallJoinRooms(plan: TWaitWorkPlan;EnableOnesCall:Boolean);
var
  i:Integer;
  j:Integer;
  waitMan:TWaitWorkTrainmanInfo;
  callApp:TRoomCallApp;
begin
  m_ADOCon.BeginTrans;
  try
    m_dbPlan.Modify(plan);
    if plan.bNeedSyncCall then
    begin
      for i := 0 to plan.tmPlanList.Count - 1 do
      begin
        waitMan :=  plan.tmPlanList.Items[i];
        if waitMan.strTrainmanGUID <> '' then
        begin
          GetInOutRoomInfo(waitMan);
          if (waitMan.eTMState >= psInRoom) and (waitMan.eTMState< psOutRoom) then
          begin
            //添加主叫班计划
            CreateCallManPlan_InRoom(plan,waitMan.InRoomInfo);
            //删除旧的计划
            callApp := TRoomCallApp.GetInstance;
            callApp.DBCallPlan.Del_PlanAndTMGUID(plan.strPlanGUID,'');

            if not EnableOnesCall then
            begin
              //添加新的叫班计划
              for j := 0 to plan.JoinRoomList.Count - 1 do
              begin
                CreateCallManPlan_InRoom_ByRoomNumber(plan,plan.JoinRoomList.Strings[j]);
              end;
            end;
          end;
        end;
      end;
    end;
    m_ADOCon.CommitTrans;
  except on e:Exception do
    m_ADOCon.RollbackTrans;
  end;
end;

procedure TWaitWorkMgr.ModifyCallManPlan_InRoom(WaitPlan:TWaitWorkPlan;
  inRoomInfo:RRSInOutRoomInfo);
var
  callManPlan:TCallManPlan;
  callApp:TRoomCallApp;
begin
  callManPlan := TCallManPlan.Create;
  callApp := TRoomCallApp.GetInstance;
  try
    if callApp.DBCallPlan.Find(waitPlan.strPlanGUID,inRoomInfo.strTrainmanGUID,callManPlan)<> True then
    begin
      Exit;
    end;
    callManPlan.strWaitPlanGUID := waitPlan.strPlanGUID;
    callManPlan.strTrainmanGUID := inRoomInfo.strTrainmanGUID;
    callManPlan.strTrainmanNumber := inRoomInfo.strTrainmanNumber;
    callManPlan.strTrainmanName := inRoomInfo.strTrainmanName;
    callManPlan.strTrainNo := waitPlan.strCheCi;
    callManPlan.dtCallTime := waitPlan.dtCallWorkTime;
    callManPlan.strRoomNum := inRoomInfo.strRoomNumber;
    callApp.DBCallPlan.Add(callManPlan);
  finally
    callManPlan.Free;
  end;
end;
procedure TWaitWorkMgr.ModifyCallManPlan_InRoom_ByRoomNumber(
  waitPlan: TWaitWorkPlan; RoomNumber: string);
var
  callManPlan:TCallManPlan;
  callApp:TRoomCallApp;
begin
  callManPlan := TCallManPlan.Create;
  callApp := TRoomCallApp.GetInstance;
  try
    callManPlan.strWaitPlanGUID := waitPlan.strPlanGUID;
    callManPlan.strTrainmanGUID := '';
    callManPlan.strTrainmanNumber := '';
    callManPlan.strTrainmanName := '';
    callManPlan.strTrainNo := waitPlan.strCheCi;
    callManPlan.dtCallTime := waitPlan.dtCallWorkTime;
    callManPlan.strRoomNum := RoomNumber;
    callManPlan.dtFirstCallTime := 0;
    callManPlan.dtReCallTime := 0;
    callManPlan.ePlanState := TCS_Publish;
    callManPlan.eFirstCallResult := TR_NONE;
    callManPlan.nFirstCallTimes := 0;
    callManPlan.eReCallResult := TR_NONE;
    callManPlan.nReCallTimes :=0;


    callManPlan.dtServerRoomCallTime := 0;
    callManPlan.nServerRoomCallTryTimes := 0;
    callManPlan.eServerRoomCallResult := TR_NONE ;

    callApp.DBCallPlan.ModifyManPlan(callManPlan,waitPlan.strPlanGUID,RoomNumber);
  finally
    callManPlan.Free;
  end;
end;

procedure TWaitWorkMgr.CreateReCallManPlan_UnLeave(waitPlan:TWaitWorkPlan;dtRecallTime:TDateTime;
  inRoomInfo:RRSInOutRoomInfo);
var
  callManPlan:TCallManPlan;
  callApp:TRoomCallApp;
begin
  callManPlan := TCallManPlan.Create;
  callApp := TRoomCallApp.GetInstance;
  try
    if callApp.DBCallPlan.Find(waitPlan.strPlanGUID,inRoomInfo.strTrainmanGUID,callManPlan)<> True then
    begin
      callManPlan.strGUID := NewGUID;
    end;
    callManPlan.strWaitPlanGUID := waitPlan.strPlanGUID;
    callManPlan.strTrainmanGUID := inRoomInfo.strTrainmanGUID;
    callManPlan.strTrainmanNumber := inRoomInfo.strTrainmanNumber;
    callManPlan.strTrainmanName := inRoomInfo.strTrainmanName;
    callManPlan.strTrainNo := waitPlan.strCheCi;
    callManPlan.dtCallTime := DateUtils.IncMinute(dtRecallTime,-callApp.CallConfig.nReCallInterval) ;
    callManPlan.strRoomNum := inRoomInfo.strRoomNumber;
    callManPlan.dtFirstCallTime := 100;
    callManPlan.dtReCallTime := 0;
    callManPlan.nFirstCallTimes := 1;
    callManPlan.eFirstCallResult := TR_SUCESS;
    callManPlan.nReCallTimes := 0;
    callManPlan.eReCallResult := TR_NONE;
    callManPlan.ePlanState := TCS_Publish;
    callApp.DBCallPlan.Add(callManPlan);
  finally
    callManPlan.Free;
  end;
end;
procedure TWaitWorkMgr.CreateCallManPlan_InRoom(waitPlan: TWaitWorkPlan;
  inRoomInfo: RRSInOutRoomInfo);
var
  callManPlan:TCallManPlan;
  callApp:TRoomCallApp;
begin
  callManPlan := TCallManPlan.Create;
  callApp := TRoomCallApp.GetInstance;
  try
    if callApp.DBCallPlan.Find(waitPlan.strPlanGUID,inRoomInfo.strTrainmanGUID,callManPlan)<> True then
    begin
      callManPlan.strGUID := NewGUID;
    end;
    callManPlan.strWaitPlanGUID := waitPlan.strPlanGUID;
    callManPlan.strTrainmanGUID := inRoomInfo.strTrainmanGUID;
    callManPlan.strTrainmanNumber := inRoomInfo.strTrainmanNumber;
    callManPlan.strTrainmanName := inRoomInfo.strTrainmanName;
    callManPlan.strTrainNo := waitPlan.strCheCi;
    callManPlan.dtCallTime := waitPlan.dtCallWorkTime;
    callManPlan.strRoomNum := inRoomInfo.strRoomNumber;
    callManPlan.dtFirstCallTime := 0;
    callManPlan.dtReCallTime := 0;
    callManPlan.ePlanState := TCS_Publish;
    callManPlan.eFirstCallResult := TR_NONE;
    callManPlan.nFirstCallTimes := 0;
    callManPlan.eReCallResult := TR_NONE;
    callManPlan.nReCallTimes :=0;


    callManPlan.dtServerRoomCallTime := 0;
    callManPlan.nServerRoomCallTryTimes := 0;
    callManPlan.eServerRoomCallResult := TR_NONE ;

    callManPlan.JoinRoomList.Assign( waitPlan.JoinRoomList );

    callApp.DBCallPlan.Add(callManPlan);
  finally
    callManPlan.Free;
  end;
end;


procedure TWaitWorkMgr.CreateCallManPlan_InRoom_ByRoomNumber(waitPlan: TWaitWorkPlan;RoomNumber:string);
var
  callManPlan:TCallManPlan;
  callApp:TRoomCallApp;
  strText:string;
begin
  callManPlan := TCallManPlan.Create;
  callApp := TRoomCallApp.GetInstance;
  try
    callManPlan.strGUID := NewGUID;
    callManPlan.strWaitPlanGUID := waitPlan.strPlanGUID;

    strText := '' ; //format('[%s]联叫人员',[waitPlan.strRoomNum]);

    callManPlan.strTrainmanGUID := strText;
    callManPlan.strTrainmanNumber := strText;
    callManPlan.strTrainmanName := strText;
    callManPlan.strTrainNo := waitPlan.strCheCi;
    callManPlan.dtCallTime := waitPlan.dtCallWorkTime;
    callManPlan.strRoomNum := RoomNumber;
    callManPlan.dtFirstCallTime := 0;
    callManPlan.dtReCallTime := 0;
    callManPlan.ePlanState := TCS_Publish;
    callManPlan.eFirstCallResult := TR_NONE;
    callManPlan.nFirstCallTimes := 0;
    callManPlan.eReCallResult := TR_NONE;
    callManPlan.nReCallTimes :=0;


    callManPlan.dtServerRoomCallTime := 0;
    callManPlan.nServerRoomCallTryTimes := 0;
    callManPlan.eServerRoomCallResult := TR_NONE ;

    callApp.DBCallPlan.Add(callManPlan);
  finally
    callManPlan.Free;
  end;
end;

procedure TWaitWorkMgr.CreateCallPlanByRoom(waitPlan: TWaitWorkPlan;
  RoomNumber: string);
begin
  if RoomNumber = '' then
    exit ;
  CreateCallManPlan_InRoom_ByRoomNumber(waitPlan,RoomNumber);
end;

procedure TWaitWorkMgr.DelCallManPlan_OutRoom(WaitPlanGUID,strTrainmanGUID:string);
var
  callApp:TRoomCallApp;
begin
  callApp := TRoomCallApp.GetInstance;
  callApp.DBCallPlan.Del_PlanAndTMGUID(WaitPlanGUID,strTrainmanGUID);
end;



procedure TWaitWorkMgr.DelCallManPlan_OutRoomByRoom(WaitPlanGUID,
  strRoomNumber: string);
var
  callApp:TRoomCallApp;
begin
  callApp := TRoomCallApp.GetInstance;
  callApp.DBCallPlan.Del_PlanAndRoomNumber(WaitPlanGUID,strRoomNumber);

end;

procedure TWaitWorkMgr.DelNeedSyncPlanID(strPlanGUID: string);
begin
  m_dbSyncPlanID.Del(strPlanGUID);
end;

procedure TWaitWorkMgr.DelPlan(plan: TWaitWorkPlan;bOnlySaveDB:Boolean = False);
var
  i:Integer;
begin
  m_ADOCon.BeginTrans;
  try
    m_dbPlan.Del(plan.strPlanGUID);
    for i := 0 to plan.tmPlanList.Count - 1 do
    begin
      m_dbPlanTrainman.Del(plan.tmPlanList.Items[i].strGUID);
    end;
    m_ADOCon.CommitTrans;
    if not bOnlySaveDB then
      planList.Remove(plan);
  except on e:Exception do
    m_ADOCon.RollbackTrans;
  end;

end;

procedure TWaitWorkMgr.DelPlanByID(strPlanGUID: string);
begin
  m_ADOCon.BeginTrans;
  try
    m_dbPlan.Del(strPlanGUID);
    m_dbPlanTrainman.DelByPlanID(strPlanGUID);
    m_ADOCon.CommitTrans;
  except on e:Exception do
    m_ADOCon.RollbackTrans;
  end;
end;

procedure TWaitWorkMgr.DelRoom(strRoomNum: string);
begin
  m_DBRoom.Del(strRoomNum);
end;

procedure TWaitWorkMgr.DelSYNCPlanByID(strPlanGUID: string);
begin
  m_ADOCon.BeginTrans;
  try
    m_dbPlan.Del(strPlanGUID);
    m_dbPlanTrainman.DelByPlanID(strPlanGUID);
    m_dbSyncPlanID.Del(strPlanGUID);
    m_ADOCon.CommitTrans;
  except on e:Exception do
    m_ADOCon.RollbackTrans;
  end;
end;

procedure TWaitWorkMgr.DelWaitPlan(plan: TWaitWorkPlan; bOnlySaveDB: Boolean);
var
  i:Integer;
begin
  m_ADOCon.BeginTrans;
  try
    m_dbPlan.Del(plan.strPlanGUID);
    for i := 0 to plan.tmPlanList.Count - 1 do
    begin
      m_dbPlanTrainman.Del(plan.tmPlanList.Items[i].strGUID);
    end;
    //删除叫班计划
    TRoomCallApp.GetInstance.DBCallPlan.DelByWaitPlan(plan.strPlanGUID);

    m_ADOCon.CommitTrans;
    if not bOnlySaveDB then
      planList.Remove(plan);
  except on e:Exception do
    m_ADOCon.RollbackTrans;
  end;
end;

destructor TWaitWorkMgr.Destroy;
begin
  m_dbSyncPlanID.Free;
  m_dbPlan.Free;
  m_dbInOutRoom.Free;
  m_dbPlanTrainman.Free;
  m_DBRoom.Free;
  m_DBWaitTime.Free;
  planList.Free;
  m_DBTMRoomRel.Free;
  inherited;
end;

function TWaitWorkMgr.FindPlan(strTrainmanGUID: string): TWaitWorkPlan;
var
  i:Integer;
begin
  result := nil;
  for i := 0 to Self.planList.Count - 1 do
  begin
    if Assigned(planList.Items[i].tmPlanList.findTrainman(strTrainmanGUID)) then
    begin
      Result := planList.Items[i];
      Break;
    end;
  end;
end;

function TWaitWorkMgr.FindPlanByRoom(strRoomNum: string): TWaitWorkPlan;
var
  i,j:Integer;
  JoinRoomList : TStringList ;
begin
  result := nil;
  for i := 0 to Self.planList.Count - 1 do
  begin
    if  UpperCase(planList.Items[i].strRoomNum) = UpperCase(strRoomNum) then
    begin
      if planList.Items[i].ePlanState <> psOutRoom then
      begin
        result := planList.Items[i];
        Exit;
      end;
    end;


    //检查是否是联交房间
    JoinRoomList := planList.Items[i].JoinRoomList ;
    for j := 0 to JoinRoomList.Count - 1 do
    begin
      if JoinRoomList[j] = strRoomNum  then
      begin
        result := planList.Items[i];
        Exit;
      end;
    end;

  end;
end;



function TWaitWorkMgr.FindPlan_PlanID(strPlanGUID:string):TWaitWorkPlan;
var
  i:Integer;
begin
  result := nil;
  for i := 0 to planList.Count - 1 do
  begin
    if planList.Items[i].strPlanGUID = strPlanGUID then
    begin
      result := planList.Items[i];
      Break;
    end;
  end;
    
end;

function TWaitWorkMgr.FindPlan_PlanID_DB(strPlanGUID:string;waitplan:TWaitWorkPlan):Boolean;
begin
  result := m_dbPlan.Find(strPlanGUID,waitplan);
end;

function TWaitWorkMgr.FindPlan_ByRoom(strRoomNum: string;
  var nIndex: Integer): TWaitWorkPlan;
var
  i,j:Integer;
  plan:TWaitWorkPlan;
  JoinRoomList : TStringList ;
begin
  result := nil;
  for i := 0 to planList.Count - 1 do
  begin
    plan:= planList.Items[i];
    if UpperCase(plan.strRoomNum) = UpperCase(strRoomNum) then
    begin
      nIndex := i;
      result := plan;
      Exit;
    end;

    //检查是否是联交房间
    JoinRoomList := plan.JoinRoomList ;
    for j := 0 to JoinRoomList.Count - 1 do
    begin
      if JoinRoomList[j] = strRoomNum  then
      begin
        result := plan;
        Exit;
      end;
    end;
  end;
end;

function TWaitWorkMgr.FindPlan_CheCi(strTrainNo: string;var nIndex:Integer): TWaitWorkPlan;
var
  i:Integer;
  plan:TWaitWorkPlan;
begin
  result := nil;
  for i := 0 to planList.Count - 1 do
  begin
    plan:= planList.Items[i];
    if UpperCase(plan.strCheCi) = UpperCase(strTrainNo) then
    begin
      nIndex := i;
      result := plan;
      Exit;
    end;
  end;
end;

function TWaitWorkMgr.FindTrainmanInfo(
  strTrainmanGUID: string): TWaitWorkTrainmanInfo;
var
  plan:TWaitWorkPlan;
begin
  Result := nil;
  plan := Self.FindPlan(strTrainmanGUID);
  if Assigned(plan) then
  begin
    result := plan.tmPlanList.findTrainman(strTrainmanGUID);
  end;
end;

function TWaitWorkMgr.FindTrainmanLastWaitRoom(strTrainmanGUID: string): string;
begin
  result := m_dbInOutRoom.GetTMLastWaitRoom(strTrainmanGUID);
end;

class procedure TWaitWorkMgr.FreeInstance;
begin
  if Assigned(m_Self) then
  begin
    m_Self.Free;
  end;
end;
procedure TWaitWorkMgr.AddRoom(strRoomNum: string);
var
  room:TWaitRoom;
begin
  if m_DBRoom.bExist(strRoomNum) then Exit;
  room := TWaitRoom.Create;
  try
    room.strRoomNum := strRoomNum;
    m_DBRoom.Add(room);
  finally
    room.Free;
  end;

end;

function TWaitWorkMgr.bGetInOutRoomInfo(strWaitPlanGUID:string):Boolean;
var
  bInRoom,bOutRoom:Boolean;
begin
  bInRoom := m_dbInOutRoom.bHaveInRoomInfo_WaitPlan(strWaitPlanGUID);
  bOutRoom := m_dbInOutRoom.bHaveOutRoomInfo_WaitPlan(strWaitPlanGUID);
  result := bInRoom And bInRoom;
end;

function TWaitWorkMgr.bRoomExist(strRoomNum: string): Boolean;
begin
  result := false;
  if m_DBRoom.bExist(strRoomNum) = True then
  begin
    result := True;
    Exit;
  end;
  
end;

procedure TWaitWorkMgr.GetAllRoom( RoomList:TWaitRoomList);
begin
  m_DBRoom.GetAll(RoomList);
end;

procedure TWaitWorkMgr.GetRoomWaitInfo(waitRoomList:TWaitRoomList);
begin
  //取所有房间
  m_DBRoom.GetAll(waitRoomList);
  //取所有入寓未出寓的人员
  m_dbPlanTrainman.GetRoomWaitMan(waitRoomList);
  //取所有联叫人员
  m_dbPlanTrainman.GetRoomWaitManWithJoin(waitRoomList);
end;



procedure TWaitWorkMgr.GetInOutRoomInfo(waitTrainman: TWaitWorkTrainmanInfo);
begin
  m_dbInOutRoom.GetTMInRoomInfo_WaitPlan(waitTrainman.strPlanGUID,waitTrainman.strTrainmanGUID,waitTrainman.InRoomInfo);
  m_dbInOutRoom.GetTMOutRoomInfo_WaitPlan(waitTrainman.strPlanGUID,waitTrainman.strTrainmanGUID,waitTrainman.OutRoomInfo);
    
end;

class function TWaitWorkMgr.GetInstance(adoCon:TADOConnection = nil): TWaitWorkMgr;
begin
  if not Assigned(m_Self) then
  begin
    if adoCon = nil then
    begin
      raise Exception.Create('TWaitWorkMgr获取实例:未指定数据库连接');
    end;
    m_Self := TWaitWorkMgr.Create(adoCon);
  end;
  Result := m_Self;
end;

function TWaitWorkMgr.GetLastWaitPlan_ByTrainNo(strTrainNo: string;
  waitplan: TWaitWorkPlan): Boolean;
var
  waitTime:RWaitTime;
begin
  Result := false ;
  if m_DBWaitTime.FindByTrainNo(strTrainNo,waitTime) = True then
  begin
    waitplan.CreateByWaitTime(waitTime);
    result := true;
    Exit;
  end;
  //result := m_dbPlan.GetLastWaitPlan_ByTrainNo(strTrainNo,waitplan);
end;

function TWaitWorkMgr.getAllTrainNoByRoom(strRoomNum: string;
        var strTrainNoList:TStringList): Boolean;
var
  i:Integer;
begin
  result := False;
  strTrainNoList.Clear;
  for i := 0 to self.planList.Count - 1 do
  begin
    //房间号相等
    if (planList.Items[i].strRoomNum = strRoomNum) and (planList.Items[i].eplanState < psOutRoom )then
    begin
      strTrainNoList.Add(planList.Items[i].strCheCi);
    end;
  end;
  if strTrainNoList.Count = 0 then Exit;
  
  result := True;
end;

procedure TWaitWorkMgr.GetSYNCPlanGUIDList(strGUIDList: TSyncPlanIDInfoList);
begin
  m_dbSyncPlanID.GetAllUnDone(strGUIDList);
end;

procedure TWaitWorkMgr.GetShowPlanS(dtStart,dtEnd:TDateTime);
begin
  planList.Clear;
  m_dbPlan.GetAllNeedShowPlan(planList,dtStart,dtEnd,GlobalDM.bOrderByRoom);
  if GlobalDM.bUseByPaiBan then
  begin
    planList.DelPlan_ByType(TWWPT_SIGN);
    planList.DelPlan_ByType(TWWPT_LOCAL);
  end;
end;

procedure TWaitWorkMgr.GetUnUploadInOutRoomInfo(out inRoomInfoS:RRsInOutRoomInfoArray;
                    out OutRoomInfoS:RRsInOutRoomInfoArray);
begin
  m_dbInOutRoom.GetUnUploadInRoomInfo(inRoomInfoS);
  m_dbInOutRoom.GetUnUplaodOutRoomInfo(OutRoomInfoS);
end;

procedure TWaitWorkMgr.PublishCallPlan(plan:TWaitWorkPlan);
var
  i:Integer;
  waitMan:TWaitWorkTrainmanInfo;
begin
  m_ADOCon.BeginTrans;
  try
    for i := 0 to plan.tmPlanList.Count - 1 do
    begin
      waitMan :=  plan.tmPlanList.Items[i];
      if waitMan.strTrainmanGUID <> '' then
      begin
        GetInOutRoomInfo(waitMan);
        if (waitMan.eTMState >= psInRoom) and (waitMan.eTMState< psOutRoom) then
        begin
          CreateReCallManPlan_UnLeave(plan,Now,waitMan.InRoomInfo);
          //CreateCallManPlan_InRoom(plan,waitMan.InRoomInfo);
        end;
      end;
    end;
    //TRoomCallApp.GetInstance.DBCallPlan.Del();
    m_ADOCon.CommitTrans;

  except on e:Exception do
    m_ADOCon.RollbackTrans;
  end;
end;
procedure TWaitWorkMgr.ModifyCallTime(plan: TWaitWorkPlan;EnableOnesCall:Boolean);
var
  i:Integer;
  j:Integer;
  waitMan:TWaitWorkTrainmanInfo;
begin
  m_ADOCon.BeginTrans;
  try
    m_dbPlan.Modify(plan);
    if plan.bNeedSyncCall then
    begin
      //如果一个人也没有
      if (plan.tmPlanList.Items[0].strTrainmanGUID = '' ) and
        (plan.tmPlanList.Items[1].strTrainmanGUID = '' ) and
        (plan.tmPlanList.Items[2].strTrainmanGUID = '' ) and
        (plan.tmPlanList.Items[3].strTrainmanGUID = '' ) then
      begin
        ModifyCallManPlan_InRoom_ByRoomNumber(plan,plan.strRoomNum);
        for j := 0 to plan.JoinRoomList.Count - 1 do
        begin
          ModifyCallManPlan_InRoom_ByRoomNumber(plan,plan.JoinRoomList.Strings[j]);
        end;
      end
      else
      begin
        for i := 0 to plan.tmPlanList.Count - 1 do
        begin
          waitMan :=  plan.tmPlanList.Items[i];
          if waitMan.strTrainmanGUID <> '' then
          begin
            GetInOutRoomInfo(waitMan);
            if (waitMan.eTMState >= psPublish ) and (waitMan.eTMState< psOutRoom) then
            begin
              CreateCallManPlan_InRoom(plan,waitMan.InRoomInfo);

              //如果没有启用同时叫班
              if not EnableOnesCall then
              begin
                for j := 0 to plan.JoinRoomList.Count - 1 do
                begin
                  ModifyCallManPlan_InRoom_ByRoomNumber(plan,plan.JoinRoomList.Strings[j]);
                end;
              end;
            end;
          end;
        end;
      end;
    end;
    m_ADOCon.CommitTrans;
  except on e:Exception do
    m_ADOCon.RollbackTrans;
  end;
end;

procedure TWaitWorkMgr.ModifyInOutRoomInfo(inoutRoomInfo: RRsInOutRoomInfo);
begin
  if inoutRoomInfo.eInOutType = TInRoom then
    m_dbInOutRoom.ModifyInRoom(inoutRoomInfo)
  else
    m_dbInOutRoom.ModifyOutRoom(inoutRoomInfo);
end;
function TWaitWorkMgr.ModifyInRoomWaitPlanGUID(OldPlanGUID,
  NewPlanGUID: string): boolean;
begin
  result := m_dbInOutRoom.ModifyWaitPlanGUID(OldPlanGUID,NewPlanGUID);
end;

procedure TWaitWorkMgr.ModifyTrainman(trainmanPlan:TWaitWorkTrainmanInfo);
begin
  m_dbPlanTrainman.Modify(trainmanPlan);
end;
procedure TWaitWorkMgr.ModifyPlan(plan: TWaitWorkPlan);
var
  i:Integer;
begin
  m_ADOCon.BeginTrans;
  try
    m_dbPlan.Modify(plan);
    for i := 0 to plan.tmPlanList.Count - 1 do
    begin
      m_dbPlanTrainman.Modify(plan.tmPlanList.Items[i]);
    end;
    m_ADOCon.CommitTrans;
  except on e:Exception do
    m_ADOCon.RollbackTrans;
  end;
end;
procedure TWaitWorkMgr.ModifyTMCallState(planGUID, tmGUID: string;
  ePlanState: TRsPlanState;dtTime:TDatetime;bSucess:Boolean);
var
  waitPlan:TWaitWorkPlan;
  waitman:TWaitWorkTrainmanInfo;
begin
  waitPlan := self.FindPlan_PlanID(planGUID);
  if waitPlan <> nil then
  begin
    waitman := waitPlan.tmPlanList.findTrainman(tmGUID);
    if waitman <> nil then
    begin
      if ePlanState > waitman.eTMState then
        waitman.eTMState := ePlanState;
      if waitman.eTMState = psFirstCall  then
        waitman.dtFirstCallTime := dtTime;
      waitman.bCallSucess := bSucess;
    end;
  end;
  m_ADOCon.BeginTrans;
  try
    m_dbPlanTrainman.ModifyPlanState(planGUID,tmGUID,ePlanState,waitman.dtFirstCallTime,bSucess);
    waitPlan.UpdatePlanState;
    m_dbPlan.ModifyPlanState(planGUID,waitPlan.ePlanState);
    m_ADOCon.CommitTrans;
  except on e:Exception do
    m_ADOCon.RollbackTrans;
  end;

end;

procedure TWaitWorkMgr.ModifyTrainNo(plan:TWaitWorkPlan);
var
  i:Integer;
  waitMan:TWaitWorkTrainmanInfo;
begin
  m_ADOCon.BeginTrans;
  try
    m_dbPlan.Modify(plan);
    if plan.tmPlanList.Count = 0 then
    begin

    end;
    for i := 0 to plan.tmPlanList.Count - 1 do
    begin
      waitMan :=  plan.tmPlanList.Items[i];
      if waitMan.strTrainmanGUID <> '' then
      begin
        GetInOutRoomInfo(waitMan);
        if (waitMan.eTMState >= psInRoom) and (waitMan.eTMState< psOutRoom) then
        begin
          ModifyCallManPlan_InRoom(plan,waitMan.InRoomInfo);
        end;
      end;
    end;
      
    m_ADOCon.CommitTrans;

  except on e:Exception do
    m_ADOCon.RollbackTrans;
  end;
end;

procedure TWaitWorkMgr.ModifyWorkPlan(plan: TWaitWorkPlan);
var
  i:Integer;
begin
  m_ADOCon.BeginTrans;
  try
    m_dbPlan.Modify(plan);
    for i := 0 to plan.tmPlanList.Count - 1 do
    begin
      m_dbPlanTrainman.Modify(plan.tmPlanList.Items[i]);
    end;
    m_ADOCon.CommitTrans;
  except on e:Exception do
    m_ADOCon.RollbackTrans;
  end;
end;

procedure TWaitWorkMgr.ModifyWorkPlan2(plan: TWaitWorkPlan);
var
  i:Integer;
begin
  m_ADOCon.BeginTrans;
  try
    m_dbPlan.Modify(plan);
    for i := 0 to plan.tmPlanList.Count - 1 do
    begin
      m_dbPlanTrainman.Modify(plan.tmPlanList.Items[i]);
    end;

    m_ADOCon.CommitTrans;
  except on e:Exception do
    m_ADOCon.RollbackTrans;
  end;
end;

procedure TWaitWorkMgr.ExChangeTMPos(sWaitman,dWaitMan:TWaitWorkTrainmanInfo);
{功能:交换人员位置}
var
  npos:Integer;
begin
  m_ADOCon.BeginTrans;
  try
    nPos := sWaitman.nIndex;
    sWaitman.nIndex := dWaitMan.nIndex;
    dWaitMan.nIndex := npos;
    m_dbPlanTrainman.ModityTMPos(sWaitman);
    m_dbPlanTrainman.ModityTMPos(dWaitMan);
    m_ADOCon.CommitTrans;
  except on e:Exception do
    begin
      m_ADOCon.CommitTrans;
      RaiseLastWin32Error;
    end;
  end;
end;
procedure TWaitWorkMgr.ReMoveTrainman(plan: TWaitWorkPlan;
  waitMan: TWaitWorkTrainmanInfo);
begin
  waitMan.strTrainmanGUID := '';
  waitMan.strTrainmanNumber := '';
  waitMan.strTrainmanName := '';
  waitMan.strRealRoom := '';
  waitMan.eTMState := psEdit;
  if plan.bAllOutRoom then
    plan.ePlanState := psOutRoom;
  m_ADOCon.BeginTrans;
  try
    m_dbPlan.Modify(plan);
    m_dbPlanTrainman.Modify(waitMan);
    m_ADOCon.CommitTrans;
  except on e:Exception do
  begin
    m_ADOCon.CommitTrans;
    RaiseLastWin32Error;
  end;
  end;
end;

function TWaitWorkMgr.SaveChangeRoomInfo(trainmanInfo:TWaitWorkTrainmanInfo):Boolean;
var
  s_waitPlan,WaitPlan:TWaitWorkPlan;
begin
  result := False;
  s_waitPlan  := self.planList.Find(trainmanInfo.strPlanGUID);
  if s_waitPlan = nil then
    raise Exception.Create('TWaitWorkMgr.SaveChangeRoomInfo函数planList.Find没有找到');
  self.GetInOutRoomInfo(trainmanInfo);
  WaitPlan := TWaitWorkPlan.Create;
  WaitPlan.Clone(s_waitPlan);
  m_ADOCon.BeginTrans;
  try
    try
      if WaitPlan.bAllChanged2OtherRoom(trainmanInfo) then
      begin
        WaitPlan.strRoomNum := trainmanInfo.strRealRoom;
        m_dbPlan.Modify(WaitPlan);
      end;
      trainmanInfo.eTMState := psInRoom;
      m_dbPlanTrainman.Modify(trainmanInfo);
      trainmanInfo.InRoomInfo.strRoomNumber := trainmanInfo.strRealRoom;
      m_dbInOutRoom.AddInRoom(trainmanInfo.InRoomInfo);
      if WaitPlan.bNeedSyncCall then
        Self.CreateCallManPlan_InRoom(Self.planList.Find(trainmanInfo.strPlanGUID),trainmanInfo.InRoomInfo);
      //TRoomCallApp.GetInstance.DBCallPlan.ChangeRoom(trainmanInfo.strPlanGUID,
      //  trainmanInfo.strTrainmanGUID,ChangeRoom);
      m_ADOCon.CommitTrans;
      Result := True;
    except on e:Exception do
      begin
        trainmanInfo.eTMState := psPublish;
        m_ADOCon.RollbackTrans;
      end;
    end;
  finally
    WaitPlan.Free;
  end;
end;

function TWaitWorkMgr.SaveInRoomInfo(plan:TWaitWorkPlan;
              trainmanInfo: TWaitWorkTrainmanInfo): Boolean;
var
  bedInfo:RRsBedInfo;
begin
  result := False;
  m_ADOCon.BeginTrans;
  try
    trainmanInfo.eTMState := psInRoom;
    trainmanInfo.strRealRoom := plan.strRoomNum;
    m_dbPlanTrainman.Modify(trainmanInfo);
    m_dbInOutRoom.AddInRoom(trainmanInfo.InRoomInfo);
    if plan.bNeedSyncCall = True then
      self.CreateCallManPlan_InRoom(plan,trainmanInfo.InRoomInfo);
    {if plan.bAllInRoom then
      plan.ePlanState := psInRoom;}
    plan.UpdatePlanState;
    m_dbPlan.Modify(plan);
    if m_DBTMRoomRel.IsHaveTrainmanRoomRelation(trainmanInfo.strTrainmanGUID,bedInfo.strRoomNumber) = False then
    begin
      bedInfo.strRoomNumber :=  trainmanInfo.strRealRoom;
      bedInfo.strTrainmanGUID := trainmanInfo.strTrainmanGUID;
      bedInfo.strTrainmanNumber := trainmanInfo.strTrainmanNumber;
      bedInfo.strTrainmanName := trainmanInfo.strTrainmanName;
      bedInfo.nBedNumber := 1;
      m_DBTMRoomRel.InsertTrainmanRoomRelation(bedInfo.strRoomNumber,bedInfo);
    end;
    m_ADOCon.CommitTrans;
    Result := True;
  except on e:Exception do
    begin
      trainmanInfo.eTMState := psPublish;
      m_ADOCon.RollbackTrans;
    end;
  end;
end;

function TWaitWorkMgr.SaveInRoomInfo1(plan: TWaitWorkPlan;
  trainmanInfo: TWaitWorkTrainmanInfo;
  InRoomWorkPlan: TInRoomWorkPlan;EnableOnesCall:boolean): Boolean;
var
  strMessage:string;
  bedInfo:RRsBedInfo;
  strText:string;
  i:Integer;
begin
  result := False;
  m_ADOCon.BeginTrans;
  try
    trainmanInfo.eTMState := psInRoom;
    trainmanInfo.strRealRoom := plan.strRoomNum;
    m_dbPlanTrainman.Modify(trainmanInfo);
    m_dbInOutRoom.AddInRoom(trainmanInfo.InRoomInfo);


    if plan.bNeedSyncCall = True then
    begin
      //删除联交的房间计划
      Self.DelCallManPlan_OutRoom(plan.strPlanGUID,'');
      //添加人员的叫班信息
      self.CreateCallManPlan_InRoom(plan,trainmanInfo.InRoomInfo);

      if not EnableOnesCall then
      begin
        //添加联交房间
        for I := 0 to InRoomWorkPlan.JoinRoomList.Count - 1 do
        begin
          strMessage := Format('[%s]添加联交房间:[%s]',[plan.strRoomNum,InRoomWorkPlan.JoinRoomList.Strings[i]]);
          GlobalDM.LogManage.InsertLog(strMessage);
          CreateCallManPlan_InRoom_ByRoomNumber(plan,InRoomWorkPlan.JoinRoomList.Strings[i]);
        end;
      end;
    end;

    strText := format('[%s]联叫人员',[trainmanInfo.InRoomInfo.strRoomNumber]);
    for I := 0 to InRoomWorkPlan.JoinRoomList.Count - 1 do
    begin
      trainmanInfo.InRoomInfo.strGUID := NEWGUID;
      trainmanInfo.InRoomInfo.strTrainmanGUID := strText ;
      trainmanInfo.InRoomInfo.strTrainmanName :=   strText ;
      trainmanInfo.InRoomInfo.strTrainmanNumber :=  strText ;
      trainmanInfo.InRoomInfo.strRoomNumber := InRoomWorkPlan.JoinRoomList[i];
      m_dbInOutRoom.AddInRoom1(trainmanInfo.InRoomInfo);
    end;


    {if plan.bAllInRoom then
      plan.ePlanState := psInRoom;}
    plan.UpdatePlanState;
    m_dbPlan.Modify(plan);
//    if m_DBTMRoomRel.IsHaveTrainmanRoomRelation(trainmanInfo.strTrainmanGUID,bedInfo.strRoomNumber) = False then
//    begin
//      bedInfo.strRoomNumber :=  trainmanInfo.strRealRoom;
//      bedInfo.strTrainmanGUID := trainmanInfo.strTrainmanGUID;
//      bedInfo.strTrainmanNumber := trainmanInfo.strTrainmanNumber;
//      bedInfo.strTrainmanName := trainmanInfo.strTrainmanName;
//      bedInfo.nBedNumber := 1;
//      m_DBTMRoomRel.InsertTrainmanRoomRelation(bedInfo.strRoomNumber,bedInfo);
//    end;
    m_ADOCon.CommitTrans;
    Result := True;
  except on e:Exception do
    begin
      trainmanInfo.eTMState := psPublish;
      m_ADOCon.RollbackTrans;
    end;
  end;
end;

function TWaitWorkMgr.SaveInRoomInfo2(plan: TWaitWorkPlan;
  InRoomWorkPlan: TInRoomWorkPlan): Boolean;
var
  bedInfo:RRsBedInfo;
  i:Integer;
begin
  result := False;
  m_ADOCon.BeginTrans;
  try
    if plan.bNeedSyncCall = True then
    begin
      //删除旧的计划
      Self.DelCallManPlan_OutRoom(plan.strPlanGUID,'');
      CreateCallManPlan_InRoom_ByRoomNumber(plan,plan.strRoomNum);
      //添加联交房间
      for I := 0 to InRoomWorkPlan.JoinRoomList.Count - 1 do
      begin
        CreateCallManPlan_InRoom_ByRoomNumber(plan,InRoomWorkPlan.JoinRoomList.Strings[i]);
      end;
    end;
    {if plan.bAllInRoom then
      plan.ePlanState := psInRoom;}
    plan.UpdatePlanState;
    m_dbPlan.Modify(plan);
    m_ADOCon.CommitTrans;
    Result := True;
  except on e:Exception do
    begin
      m_ADOCon.RollbackTrans;
    end;
  end;
end;

function TWaitWorkMgr.SaveOutRoomInfo(plan:TWaitWorkPlan;
                    trainmanInfo: TWaitWorkTrainmanInfo): Boolean;
begin
  result := False;
  m_ADOCon.BeginTrans;
  try
    //oldPlanState := plan.ePlanState;
    trainmanInfo.eTMState := psOutRoom;
    if plan.bAllOutRoom = True then
      plan.ePlanState := psOutRoom;
    m_dbPlan.Modify(plan);
    m_dbPlanTrainman.Modify(trainmanInfo);
    m_dbInOutRoom.AddOutRoom(trainmanInfo.OutRoomInfo);
    Self.DelCallManPlan_OutRoom(plan.strPlanGUID,trainmanInfo.strTrainmanGUID);

    m_ADOCon.CommitTrans;
    Result := True;
  except on e:Exception do
    begin
       trainmanInfo.eTMState := psInRoom;
      m_ADOCon.RollbackTrans;
    end;
  end;
end;

function TWaitWorkMgr.SaveOutRoomInfo2(CallPlan: TCallRoomPlan): Boolean;
begin
  result := False;
  m_ADOCon.BeginTrans;
  try
    GlobalDM.LogManage.InsertLog('开始更新计划状态为:离寓');
    m_dbPlan.ModifyPlanState(CallPlan.strWaitPlanGUID,psOutRoom);
    GlobalDM.LogManage.InsertLog('开始删除叫班计划');
    Self.DelCallManPlan_OutRoomByRoom(CallPlan.strWaitPlanGUID,CallPlan.strRoomNum); //删除当前的叫班计划
    m_ADOCon.CommitTrans;
    Result := True;
  except on e:Exception do
    begin
      GlobalDM.LogManage.InsertLog('开始修改计划状态:发生异常'+e.Message);
      m_ADOCon.RollbackTrans;
    end;
  end;
end;

function TWaitWorkMgr.SaveOutRoomInfo3(WaitPlanGUID,
  RoomNumber: string): Boolean;
begin
  result := False;
  m_ADOCon.BeginTrans;
  try
    GlobalDM.LogManage.InsertLog('开始更新计划状态为:离寓');
    m_dbPlan.ModifyPlanState(WaitPlanGUID,psOutRoom);
    GlobalDM.LogManage.InsertLog('开始删除叫班计划');
    Self.DelCallManPlan_OutRoomByRoom(WaitPlanGUID,RoomNumber); //删除当前的叫班计划
    m_ADOCon.CommitTrans;
    Result := True;
  except on e:Exception do
    begin
      GlobalDM.LogManage.InsertLog('开始修改计划状态:发生异常'+e.Message);
      m_ADOCon.RollbackTrans;
    end;
  end;
end;

procedure TWaitWorkMgr.SaveSYNCPlanGUID(planIDInfo:TSyncPlanIDInfo);
begin
  //if m_dbInOutRoom.bGetInfo(strPlanGUID) = True then Exit;
  m_dbSyncPlanID.Add(planIDInfo);

end;

procedure TWaitWorkMgr.SetDB(adoCon: TADOConnection);
begin
  m_ADOCon := adocon;
  m_dbPlan:=TDBWaitWorkPlan.Create(adocon);
  m_dbInOutRoom:=TRSDBInOutRoom.Create(adocon);
  m_dbPlanTrainman:=TDBWaitWorkTrainman.Create(adocon);
  m_dbSyncPlanID:=TDBSyncPlanID.Create(adocon);
  m_DBRoom := TDBWaitWorkRoom.Create(adoCon);
  planList:=TWaitWorkPlanList.Create;
  m_DBWaitTime:=TDBWaitTime.Create(adoCon);
  m_DBTMRoomRel := TDBRoomTrainmanRelation.Create(adoCon);
end;

procedure TWaitWorkMgr.UpDateInOutRoomTrainPlan(strTrainPlanGUID,
  strTrainmanGUID: string;dtStartTime:TDateTime);
var
  inRoomInfo:RRSInOutRoomInfo;
  dtSearchStart,dtSearchEnd:TDateTime;
begin
  try
    //如果已经存在了出勤计划对应的入寓记录,则表示已关联,不再处理
    if m_dbInOutRoom.GetTMInRoomInfo_TrainPlan(strTrainPlanGUID,
                strTrainmanGUID,inRoomInfo)= True then Exit;
    dtSearchStart := IncHour(dtStartTime,-12);
    dtSearchEnd := dtStartTime;
    //取在计划开车时间前12小时内司机的最后一个出入寓记录,并将其与行车计划关联
    m_dbInOutRoom.SetTMLastInRoomTrainPlan(strTrainPlanGUID,strTrainmanGUID,dtSearchStart,dtSearchEnd);
    m_dbInOutRoom.SetTMLastOutRoomTrainPlan(strTrainPlanGUID,strTrainmanGUID,dtSearchStart,dtSearchEnd);
  except on e:Exception do
    raise Exception.Create('关联出入寓记录出错:'+ e.Message);
  end;
end;

procedure TWaitWorkMgr.UpdateNotifyUnLeaveTime(strPlanGUID: string;
  dtTime: TDateTime);
begin
  m_dbPlan.UpdateNotifyUnLeaveTime(strPlanGUID,dtTime);
end;

function TWaitWorkMgr.SaveSYNCPlan(plan:TWaitWorkPlan):Boolean;
var
  i:Integer;
begin
  Result := False;
  m_ADOCon.BeginTrans;
  try
    m_dbPlan.Add(plan);
    m_dbPlanTrainman.DelByPlanID(plan.strPlanGUID);

    for i := 0 to plan.tmPlanList.Count - 1 do
    begin
      m_dbPlanTrainman.Add(plan.tmPlanList.Items[i]);
    end;
    m_dbSyncPlanID.Del(plan.strPlanGUID);
    m_ADOCon.CommitTrans;
    Result := True;
  except on e:Exception do
    m_ADOCon.RollbackTrans;
  end;
end;

function TWaitWorkMgr.AddPlan(plan: TWaitWorkPlan;bOnlySaveDB:Boolean = False):Boolean;
var
  i:Integer;
begin
  result := False;
  Self.m_ADOCon.BeginTrans;
  try
    m_dbPlan.Add(plan);
    for i := 0 to plan.tmPlanList.Count - 1 do
    begin
      if plan.tmPlanList.Items[i].strTrainmanGUID <> '' then
        plan.tmPlanList.Items[i].eTMState := psPublish;
      m_dbPlanTrainman.Add(plan.tmPlanList.Items[i]);
    end;
    m_ADOCon.CommitTrans;
    if bOnlySaveDB = False then
      planList.Add(plan);
    Result := True;
  except on e:Exception do
    m_ADOCon.RollbackTrans;
  end;

end;

end.
