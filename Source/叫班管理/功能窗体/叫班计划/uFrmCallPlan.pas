unit uFrmCallPlan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, AdvObj, BaseGrid, AdvGrid, Buttons, PngCustomButton, ExtCtrls,
  RzPanel,uFrmEditCallPlan,uRoomCall,uRoomCallApp,uGlobalDM,uSaftyEnum,uPubFun,
  uTFSystem,uFrmMunualCall,uRoomCallOp,ulogs,UFrmRecvCallNotify,uFrmQueryCallRecord,
  StdCtrls,uWaitWorkMgr,uFrmWaitWorkPlanMgr,uCallRoomFunIF,uTrainman;
type
  TColAry = (CL_Index,CL_State,CL_TrainNo,CL_CALL,CL_Room,CL_JoinRooms,cl_TM1,cl_FirstCall,cl_Recall);
    
  TFrmCallPlan = class(TForm)
    rzpnlTop: TRzPanel;
    rzpnlBody: TRzPanel;
    btnAdd: TPngCustomButton;
    btnModify: TPngCustomButton;
    btnDle: TPngCustomButton;
    btnCall: TPngCustomButton;
    GridCallPlan: TAdvStringGrid;
    tmrAutoCallRoom: TTimer;
    btnLoadPlan: TPngCustomButton;
    btnCallRecord: TPngCustomButton;
    procedure btnAddClick(Sender: TObject);
    procedure btnModifyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnDleClick(Sender: TObject);
    procedure tmrUpdatePlanTimer(Sender: TObject);
    procedure btnCallClick(Sender: TObject);
    procedure tmrAutoCallRoomTimer(Sender: TObject);
    procedure btnLoadPlanClick(Sender: TObject);
    procedure btnCallRecordClick(Sender: TObject);
    procedure btn1Click(Sender: TObject);

  public
    {功能:出入公寓}
    procedure OutRoom(CallPlan: TCallRoomPlan;eVerifyFlag: TRsRegisterFlag);
    {刷新数据}
    procedure ReFreshData();
    {功能:检查一下是否是突然关闭系统导致计划无法删除}
    function IsInValidPlan(CallPlan: TCallRoomPlan):boolean;
    //获取联叫房间信息
    procedure GetJoinRooms(Rooms:TStringList;CallRoomRecord:TCallRoomRecord);
  private
    //叫班逻辑
    m_RoomCallApp:TRoomCallApp;
    //叫班计划
    m_CallRoomPlanList:TCallRoomPlanList;
    //候班管理
    m_waitMgr:TWaitWorkMgr;
   
  private
    {功能:获取叫班计划}
    procedure GetRoomCallPlan();
    {功能:填充叫班计划列表}
    procedure FillGrid();
    {功能:清空列表}
    procedure ClearGrid(nRowCount:Integer);
    {功能:填充叫班计划行}
    procedure FillLine(nRow:Integer;CallPlan:TCallRoomPlan);
    {功能:获取选中计划索引}
    function GetSelectPlanIndex():Integer;

    {功能:显示人员姓名工号}
    function FmtTMNameNum(callRoomPlan:TCallRoomPlan;nIndex:Integer):string;
    {功能:叫班回调事件}
    procedure FinishCallEvent(bSucess:Boolean; data:TCallDevCallBackData);
  private //叫班操作
    {功能:执行自动首叫}
    function AutoFirstCall(CallPlan:TCallRoomPlan):Boolean;
    {功能:执行自动催叫}
    function AutoReCall(CallPlan:TCallRoomPlan):Boolean;
    {功能:执行服务室呼叫}
    function AutoServerRoomCall(CallPlan:TCallRoomPlan):Boolean;
    {功能:创建自动首叫记录}
    procedure CreateAutoFirstCallRecord(callPlan:TCallRoomPlan;out callrecord:TcallRoomRecord;nDevNum:Integer);
    {功能:创建自动催叫记录}
    procedure CreateAutoReCallRecord(callPlan:TCallRoomPlan;out callrecord:TcallRoomRecord;nDevNum:Integer);
    {功能:创建自动催叫记录}
    procedure CreateServerRoomCallRecord(callPlan:TCallRoomPlan;out callrecord:TcallRoomRecord;nDevNum:Integer;strExternalRoomNumber:string);
    {功能:创建人工叫班记录}
    procedure CreateMunalCallRecord(CallRoomPlan:TCallRoomPlan;out CallRoomRecord:TCallRoomRecord);
  end;


{$INCLUDE uDebug.INC}
implementation
uses
  uFrmMain_RoomSign,utfPopBox,uWaitWork;
{$R *.dfm}

function TFrmCallPlan.AutoFirstCall(CallPlan: TCallRoomPlan):Boolean;
var
  strText:string;
  roomDev:RCallDev;
  //叫班记录
  callrecord :TcallRoomRecord;
  dtNow :TDateTime;
begin
  result := False;
  dtNow := GlobalDM.GetNow;
  //if True then
  if CallPlan.bNeedFirstCall(dtNow) then
  begin
    if m_RoomCallApp.CallDevOp.bCalling = False then
    begin
      if m_RoomCallApp.DBCallDev.FindByRoom(CallPlan.strRoomNum,roomDev) then
      begin
        callrecord :=TcallRoomRecord.Create;
        try
          CreateAutoFirstCallRecord(CallPlan,callrecord, roomDev.nDevNum);

          GetJoinRooms(CallPlan.manList[0].JoinRoomList ,callrecord);
          {IF TFrmAutoCall.AutoCall(callrecord,CallPlan) = True then
          begin
            //修改候班计划中人员的叫班状态
            for i := 0 to callrecord.CallManRecordList.Count - 1 do
            begin
              m_waitMgr.ModifyTMCallState(callrecord.CallManRecordList.Items[i].strWaitPlanGUID,
                  callrecord.CallManRecordList.Items[i].strTrainmanGUID,psFirstCall,dtNow);
            end;
            //FrmWaitWorkPlanMgr.GetShowPlanS;
            FrmWaitWorkPlanMgr.RefreshData;
            Result := True;
          end; }
          if not TCallRoomFunIF.GetInstance.bCallling then
          begin

            strText := Format('[首叫]:设备号:[%d]--房间号:[%s]',[roomDev.nDevNum,CallPlan.strRoomNum]);
            GlobalDM.LogManage.InsertLog(strText);

            //TCallRoomFunIF.GetInstance.AutoCall_Frm(callrecord,CallPlan,FinishCallEvent);
            TCallRoomFunIF.GetInstance.AutoCall_InsertFrm(FrmMain_RoomSign.pnlCallWork,callrecord,CallPlan,FinishCallEvent);
            result := true ;
          end;
        finally
          callrecord.Free;
        end;
      end;
    end;
  end;
end;

function TFrmCallPlan.AutoReCall(CallPlan: TCallRoomPlan) :Boolean;
var
  strText:string;
  roomDev:RCallDev;
  callrecord :TcallRoomRecord;
  dtNow:TDateTime;
begin
  result := False;
  dtNow := GlobalDM.GetNow;
  
  //已催叫
  //if CallPlan.dtReCallTime >1 then Exit;
  if CallPlan.bNeedReCall(dtNow,m_RoomCallApp.CallConfig.nReCallInterval) then
  begin
    if m_RoomCallApp.CallDevOp.bCalling = False then
    begin
      if m_RoomCallApp.DBCallDev.FindByRoom(CallPlan.strRoomNum,roomDev) then
      begin
        callrecord :=TcallRoomRecord.Create;
        try
          CreateAutoReCallRecord(CallPlan,callrecord, roomDev.nDevNum);
          GetJoinRooms(CallPlan.manList[0].JoinRoomList ,callrecord);
          {IF TFrmAutoCall.AutoCall(callrecord,CallPlan) = True then
          begin
            //修改候班计划中人员的叫班状态
            for i := 0 to callrecord.CallManRecordList.Count - 1 do
            begin
              m_waitMgr.ModifyTMCallState(callrecord.CallManRecordList.Items[i].strWaitPlanGUID,
                  callrecord.CallManRecordList.Items[i].strTrainmanGUID,psReCall,dtNow);
            end;
            //FrmWaitWorkPlanMgr.GetShowPlanS;
            FrmWaitWorkPlanMgr.RefreshData;
            Result := True;
          end; }

          if not TCallRoomFunIF.GetInstance.bCallling then
          begin
            strText := Format('[催叫]:设备号:[%d]--房间号:[%s]',[roomDev.nDevNum,CallPlan.strRoomNum]);
            GlobalDM.LogManage.InsertLog(strText);

            //TCallRoomFunIF.GetInstance.AutoCall_NoFrm(callrecord,CallPlan,FinishCallEvent);
            TCallRoomFunIF.GetInstance.AutoCall_InsertFrm(FrmMain_RoomSign.pnlCallWork,callrecord,CallPlan,FinishCallEvent);
            Result := True ;
          end;
        finally
          callrecord.Free;
        end;
      end;
    end;
  end;
end;


{功能:执行服务室呼叫}
function TFrmCallPlan.AutoServerRoomCall(CallPlan:TCallRoomPlan):Boolean;
var
  strText:string;
  strServerRoomNumber:string;
  roomDev:RCallDev;
  callrecord :TcallRoomRecord;
  dtNow:TDateTime;
begin

  result := False;
  dtNow := GlobalDM.GetNow;

  //已催叫
  //if true then
  if CallPlan.bNeedServerRoomCall(dtNow,m_RoomCallApp.CallConfig.nReCallInterval) then
  begin
    if m_RoomCallApp.CallDevOp.bCalling = False then
    begin
      //检查是否存在关联的服务室房间
      if m_RoomCallApp.DBServerRoomDev.IsExistSleepRoom(CallPlan.strRoomNum,strServerRoomNumber) then
      begin
        OutputDebugString('查找房间');
        if m_RoomCallApp.DBServerRoomDev.FindByRoom(strServerRoomNumber,roomDev) then
        begin
          callrecord :=TcallRoomRecord.Create;
          try
            CreateServerRoomCallRecord(CallPlan,callrecord, roomDev.nDevNum,strServerRoomNumber);
             GetJoinRooms(CallPlan.manList[0].JoinRoomList ,callrecord);
            if not TCallRoomFunIF.GetInstance.bCallling then
            begin
              strText := Format('服务室:[%s]--设备号:[%d]--房间号:[%s]',[strServerRoomNumber,roomDev.nDevNum,CallPlan.strRoomNum]);
              GlobalDM.LogManage.InsertLog(strText);

              TCallRoomFunIF.GetInstance.AutoServerRoomCall_NoFrm(callrecord,CallPlan,FinishCallEvent);
              Result := True ;
            end;
          finally
            callrecord.Free;
          end;
        end;
      end
      else
      begin
        strText := Format('房间[%s]没有找到关联的服务室',[CallPlan.strRoomNum]);
        GlobalDM.LogManage.InsertLog(strText);
        Result := True ;
      end;
    end;
  end;
end;

procedure TFrmCallPlan.btn1Click(Sender: TObject);
begin
  tmrAutoCallRoomTimer(nil);
end;

procedure TFrmCallPlan.btnAddClick(Sender: TObject);
var
  CallPlan:TCallRoomPlan;
begin

    if CreateCallPlan(CallPlan)= False then Exit;
    try
     // CallPlan.New(GlobalDM.GetNow);
      //m_RoomCallApp.DBCallPlan.Add(CallPlan);
    except on E:Exception do
      begin
        TtfPopBox.ShowBox('增加计划失败,原因:'+ e.Message);
        Exit;
      end;
    end;

end;

procedure TFrmCallPlan.btnCallClick(Sender: TObject);
var
  nIndex:Integer;
  CallRoomPlan:TCallRoomPlan;
begin
  try
    tmrAutoCallRoom.Enabled := False;
    if m_RoomCallApp.CallDevOp.bCalling then
    begin
      TtfPopBox.ShowBox('设备正在叫班,请勿重复叫班!');
      Exit;
    end;
    //tmrAutoCallRoom.Enabled := False;
    //ClearCallEventDeal();
    nIndex := GetSelectPlanIndex();
    if nIndex = -1 then
    begin
      TtfPopBox.ShowBox('未选择有效的叫班计划');
      Exit;
    end;
    CallRoomPlan := m_CallRoomPlanList.Items[nIndex];
    MunualCall(CallRoomPlan.strTrainNo,CallRoomPlan.strRoomNum);
    //self.SetCallEventDeal();
    ReFreshData;
  finally
    tmrAutoCallRoom.Enabled := True;
  end;


end;

procedure TFrmCallPlan.btnCallRecordClick(Sender: TObject);
begin
  TFrmQueryCallRecord.ShowCallRecordFrm(nil);
end;

procedure TFrmCallPlan.btnDleClick(Sender: TObject);
var
  nIndex:Integer;
begin
  {tmrUpdatePlan.Enabled := False;
  try
    nIndex := GetSelectPlanIndex();
    if nIndex = -1 then Exit;
    try
      m_RoomCallApp.DBCallRoomPlan.Delete(m_RoomCallAry[nIndex].strGUID);
    except on E:Exception do
      begin
        TtfPopBox.ShowBox('修改计划失败,原因:'+ e.Message);
        Exit;
      end;
    end;
  finally
    tmrUpdatePlan.Enabled := True;
  end;  }
end;

procedure TFrmCallPlan.btnLoadPlanClick(Sender: TObject);
begin
  ShowRecvCallNotifyFrm();
  ReFreshData();
end;

procedure TFrmCallPlan.btnModifyClick(Sender: TObject);
var
  CallPlan:TCallRoomPlan;
  nIndex:Integer;
begin
  {tmrUpdatePlan.Enabled := False;
  try
    nIndex := GetSelectPlanIndex();
    if nIndex = -1 then Exit;
    if ModifyCallPlan(m_CallRoomPlanList.items[nIndex])= False then Exit;
    try
      m_RoomCallApp.DBCallRoomPlan.Modify(CallPlan);
    except on E:Exception do
      begin
        TtfPopBox.ShowBox('修改计划失败,原因:'+ e.Message);
        Exit;
      end;
    end;
  finally
    tmrUpdatePlan.Enabled := True;
  end;   }
  
end;


procedure TFrmCallPlan.ClearGrid(nRowCount:Integer);
begin
  GridCallPlan.ClearRows(1,10000);
  if nRowCount > 0  then
    GridCallPlan.RowCount := nRowCount + 1
  else
  begin
    GridCallPlan.RowCount := 2;
    GridCallPlan.Cells[99,1] := ''
  end;
end;



procedure TFrmCallPlan.CreateAutoFirstCallRecord(callPlan: TCallRoomPlan;
  out callrecord: TcallRoomRecord;nDevNum:Integer);
begin
  callrecord.Init(callPlan,GlobalDM.GetNow);
  callrecord.nDeviceID := nDevNum;
  callrecord.eCallType:=TCT_AutoCall;
  callrecord.eCallState := TCS_FIRSTCALL;
end;

procedure TFrmCallPlan.CreateAutoReCallRecord(callPlan: TCallRoomPlan;
  out callrecord: TcallRoomRecord;nDevNum:Integer);
begin
  callrecord.Init(callPlan,GlobalDM.GetNow);
  callrecord.nDeviceID := nDevNum;
  callrecord.eCallType:=TCT_AutoCall;
  callrecord.eCallState := TCS_RECALL;
end;


procedure TFrmCallPlan.CreateServerRoomCallRecord(callPlan:TCallRoomPlan;
  out callrecord:TcallRoomRecord;nDevNum:Integer;strExternalRoomNumber:string);
begin
  callrecord.Init(callPlan,GlobalDM.GetNow);
  callrecord.strExternalRoomNumber := strExternalRoomNumber ;
  callrecord.nDeviceID := nDevNum;
  callrecord.eCallType:= TCT_AutoCall;
  callrecord.eCallState := TCS_SERVER_ROOM_CALL;
end;


procedure TFrmCallPlan.CreateMunalCallRecord(CallRoomPlan: TCallRoomPlan;
  out CallRoomRecord: TCallRoomRecord);
begin
  CallRoomRecord:=TCallRoomRecord.Create;
  CallRoomRecord.Init(CallRoomPlan,GlobalDM.getNow);
end;

procedure TFrmCallPlan.FillGrid;
var
  i:Integer;
  nCount:Integer;
begin

  nCount := m_CallRoomPlanList.Count;
  ClearGrid(nCount);
  for i := 0 to nCount -1 do
  begin
    FillLine(i+1,m_CallRoomPlanList.Items[i]);
  end;
    
end;

procedure TFrmCallPlan.FillLine(nRow: Integer; CallPlan: TCallRoomPlan);
begin
 {CL_Index,CL_State,CL_TrainNo,CL_CALL,cl_ChuQin,CL_Room,cl_TM1,cl_TM2,
    cl_TM3,cl_TM4,cl_FirstCall,cl_Recall }
  GridCallPlan.Cells[Ord(CL_Index),nRow] := IntToStr(nRow);
  GridCallPlan.Cells[Ord(CL_State),nRow] := TRoomCallStateNameAry[CallPlan.ePlanState];
  GridCallPlan.Cells[Ord(CL_TrainNo) ,nRow] := CallPlan.strTrainNo;
  GridCallPlan.Cells[Ord(CL_CALL) ,nRow] := TPubFun.DateTime2Str(CallPlan.dtStartCallTime);
  GridCallPlan.Cells[Ord(CL_Room),nRow] := CallPlan.strRoomNum;
  if CallPlan.manList.Count >= 1 then
  begin
    GridCallPlan.Cells[ord(CL_JoinRooms),nRow] := CallPlan.manList[0].JoinRoomList.CommaText;
  end;
  GridCallPlan.Cells[Ord(cl_TM1),nRow] :=FmtTMNameNum(CallPlan,0);
  GridCallPlan.Cells[Ord(cl_firstCall) ,nRow] := TPubFun.DateTime2Str(CallPlan.dtFirstCallTime);
  GridCallPlan.Cells[Ord(cl_ReCall) ,nRow] := TPubFun.DateTime2Str(CallPlan.dtReCallTime);
end;

procedure TFrmCallPlan.FinishCallEvent(bSucess: Boolean;
  data: TCallDevCallBackData);
var
  CallRecord :TCallRoomRecord;
  i:Integer;
  strFilePath:string;
  ePlanState:TRSPlanstate;
begin
  CallRecord := data.callRoomRecord;
  //if bSucess = True then //叫班成功的存储录音,不成功的存储记录
  begin
    CallRecord.CallVoice.strCallVoiceGUID := NewGUID;
    CallRecord.CallVoice.dtCreateTime := GlobalDM.GetNow;
    strFilePath := GlobalDM.AppPath + 'CallVoice\' ;
    if DirectoryExists(strFilePath) = False  then
      CreateDir(strFilePath);
    strFilePath := strFilePath + FormatDateTime('yyyy-MM-dd',CallRecord.CallVoice.dtCreateTime) + '\';
    if DirectoryExists(strFilePath) = False  then
      CreateDir(strFilePath);

    CallRecord.CallVoice.strFilePathName := strFilePath  + CallRecord.CreateVoiceFileName();
    for i := 0 to CallRecord.CallManRecordList.Count - 1 do
    begin
      CallRecord.CallManRecordList.Items[i].strCallVoiceGUID :=CallRecord.CallVoice.strCallVoiceGUID;
    end;
  end;

  m_RoomCallApp.SaveCallResult(CallRecord);

  
  //修改候班计划中人员的叫班状态
  for i := 0 to callrecord.CallManRecordList.Count - 1 do
  begin
    if data.callRoomRecord.eCallState = TCS_FIRSTCALL{首叫} then
    begin
      ePlanState := psFirstCall;
    end;
    if data.callRoomRecord.eCallState = TCS_RECALL{首叫} then
    begin
      ePlanState := psReCall;
    end;

    if data.callRoomRecord.eCallState = TCS_SERVER_ROOM_CALL{首叫} then
    begin
      ePlanState := psServerRoomCall;
    end;

   
    m_waitMgr.ModifyTMCallState(callrecord.CallManRecordList.Items[i].strWaitPlanGUID,
        callrecord.CallManRecordList.Items[i].strTrainmanGUID,ePlanState,GlobalDM.GetNow,bSucess);


    if GlobalDM.bEnableServerRoomCall then
    begin
      //如果是服务呼叫则自动离寓
      if ePlanState = psServerRoomCall then
      begin
        m_waitMgr.SaveOutRoomInfo3(callrecord.CallManRecordList.Items[i].strWaitPlanGUID,callrecord.strRoomNum);
      end;
    end
    else
    begin
      //如果是催叫则自动离寓
      if ePlanState = psReCall then
      begin
        m_waitMgr.SaveOutRoomInfo3(callrecord.CallManRecordList.Items[i].strWaitPlanGUID,callrecord.strRoomNum);
      end;
    end;

  end;
  FrmWaitWorkPlanMgr.RefreshData;
  ReFreshData;
end;



function TFrmCallPlan.FmtTMNameNum(callRoomPlan: TCallRoomPlan;
  nIndex: Integer): string;
var
  manPlan:TCallManPlan;
begin
  result := '';
  if (nIndex >= 0) and (nIndex < callRoomPlan.manList.Count) then
  begin
    manPlan := callRoomPlan.manList.Items[nIndex];
    if GlobalDM.bShowTrainmNumber then
      result := TPubFun.FormatTMNameNum(manPlan.strTrainmanNumber,manPlan.strTrainmanName)
    else
      Result :=  manPlan.strTrainmanName ;
  end;
end;

procedure TFrmCallPlan.FormCreate(Sender: TObject);
begin


  GridCallPlan.ColumnSize.Save := false;
  GlobalDM.SetGridColumnWidth(GridCallPlan);
  GlobalDM.SetGridColumnVisible(GridCallPlan);
  m_CallRoomPlanList:=TCallRoomPlanList.Create;
  m_RoomCallApp:=TRoomCallApp.GetInstance();

  //Self.SetCallEventDeal();
  btnLoadPlan.Enabled := not GlobalDM.bLeaveLine;
  m_waitMgr:=TWaitWorkMgr.GetInstance(nil);

  tmrAutoCallRoom.Enabled := not GlobalDM.bUseByPaiBan ;

end;

procedure TFrmCallPlan.FormDestroy(Sender: TObject);
begin
  GlobalDM.SaveGridColumnWidth(GridCallPlan);
  m_CallRoomPlanList.Free;
end;

procedure TFrmCallPlan.GetJoinRooms(Rooms: TStringList;
  CallRoomRecord: TCallRoomRecord);
var
  i : Integer ;
  strRoom:string;
  strText:string;
  roomDev:RCallDev;
begin
  for I := 0 to Rooms.Count - 1 do
  begin
    strRoom := Rooms.Strings[i];
    if m_RoomCallApp.DBCallDev.FindByRoom(strRoom,roomDev) then
    begin
      strText := Format('%s=%d',[strRoom,roomDev.nDevNum]);
      CallRoomRecord.JoinRooms.Add( strText ) ;
    end;
  end;  
end;

procedure TFrmCallPlan.GetRoomCallPlan;

begin
  m_CallRoomPlanList.Clear;
  //m_RoomCallApp.DBCallPlan.GetRoomCallPlanList(m_CallRoomPlanList,TCS_Publish ,TCS_FIRSTCALL);


  m_RoomCallApp.DBCallPlan.GetRoomCallPlanList(m_CallRoomPlanList,TCS_Publish ,TCS_SERVER_ROOM_CALL);
end;

function TFrmCallPlan.GetSelectPlanIndex: Integer;
var
  nRealRow:Integer;
begin
  result := -1;
  nRealRow := GridCallPlan.RealRow;
  if (nRealRow >=1) and (nRealRow <= m_CallRoomPlanList.Count ) then
  begin
    result := nRealRow-1;
  end;
end;



function TFrmCallPlan.IsInValidPlan(CallPlan: TCallRoomPlan): boolean;
begin
  result := false ;
  if CallPlan.nReCallTimes >0   then
  begin
    if ( CallPlan.eServerRoomCallResult = TR_SUCESS ) or
        ( CallPlan.nServerRoomCallTryTimes > 1  ) then
    begin
      result := true ;
    end;
  end;
end;

procedure TFrmCallPlan.OutRoom(CallPlan: TCallRoomPlan;
  eVerifyFlag: TRsRegisterFlag);
var
  //当前选中人员
  m_curTrainmanInfo:TWaitWorkTrainmanInfo;
  plan:TWaitWorkPlan;
  nCol:Integer;
  strMsg:string;
  TrainMan:RRsTrainman;
  i : Integer ;
  bNoTrainman : Boolean;
begin
  GlobalDM.LogManage.InsertLog('开始离寓');
  plan:= m_waitMgr.FindPlan_PlanID(CallPlan.strWaitPlanGUID);
  m_waitMgr.SaveOutRoomInfo2(CallPlan);
  GlobalDM.LogManage.InsertLog('离寓成功');
  exit;

//  bNoTrainman := False ;
//  for I := 0 to CallPlan.manList.Count - 1 do
//  begin
//    if CallPlan.manList[i].strTrainmanGUID <> '' then
//    begin
//      bNoTrainman := True ;
//      TrainMan.strTrainmanGUID := CallPlan.manList[i].strTrainmanGUID ;
//      TrainMan.strTrainmanName := CallPlan.manList[i].strTrainmanName ;
//      TrainMan.strTrainmanNumber := CallPlan.manList[i].strTrainmanNumber ;
//
//      //获取人员的计划
//      plan:= m_waitMgr.FindPlan(TrainMan.strTrainmanGUID);
//      if plan <> nil then
//      begin
//        m_curTrainmanInfo := plan.tmPlanList.findTrainman(TrainMan.strTrainmanGUID);
//        if m_curTrainmanInfo <> nil then
//        begin
//          if ( m_curTrainmanInfo.eTMState >= psInRoom)  and (m_curTrainmanInfo.eTMState < psOutRoom) then   //有计划出寓
//          begin
//
//            m_curTrainmanInfo.OutRoomInfo.SetValue(plan,trainman,GlobalDM.GetNow,eVerifyFlag,
//                TOutRoom,GlobalDM.DutyUser,globalDM.SiteInfo);
//            //SetInOutRoomInfo(plan,trainman,m_curTrainmanInfo.OutRoomInfo,eVerifyFlag,TOutRoom);
//            m_curTrainmanInfo.OutRoomInfo.strInRoomGUID := m_curTrainmanInfo.InRoomInfo.strGUID;
//            m_waitMgr.SaveOutRoomInfo(plan,m_curTrainmanInfo);
//            GlobalDM.LogManage.InsertLog('TFrmCallPlan.OutRoom 1');
//          end;
//        end
//        else
//        begin
//
//        end;
//      end
//      else
//      begin
//        GlobalDM.LogManage.InsertLog('TFrmCallPlan.OutRoom 2') ;
//        m_waitMgr.SaveOutRoomInfo2(CallPlan);
//      end;
//    end;
//  end;
//
//  if not bNoTrainman  then
//  begin
//    plan:= m_waitMgr.FindPlan_PlanID(CallPlan.strWaitPlanGUID);
//    m_waitMgr.SaveOutRoomInfo2(CallPlan);
//    GlobalDM.LogManage.InsertLog('TFrmCallPlan.OutRoom3');
//  end;
end;

procedure TFrmCallPlan.ReFreshData;
begin
  try
    GetRoomCallPlan();
    FillGrid();
  except

  end;
end;

procedure TFrmCallPlan.tmrAutoCallRoomTimer(Sender: TObject);
var
  i:Integer;
  nDevNum:Integer;
begin
  tmrAutoCallRoom.Enabled := False;
  try

    //首叫
    for i := 0 to m_CallRoomPlanList.Count - 1 do
    begin
      if AutoFirstCall(m_CallRoomPlanList.Items[i]) = True then
      begin
        Exit;
      end;
    end;

    //催叫
    for i := 0 to m_CallRoomPlanList.count - 1 do
    begin
      if AutoReCall(m_CallRoomPlanList.Items[i]) = True then
      begin
        Exit;
      end;
    end;

    //服务室呼叫
    if GlobalDM.bEnableServerRoomCall   then
    begin

      for i := 0 to m_CallRoomPlanList.count - 1 do
      begin
        //如果是错误的计划信息则直接删除
        if IsInValidPlan(m_CallRoomPlanList.Items[i]) then
        begin
          OutRoom(m_CallRoomPlanList.Items[i], rfInput);
          Continue;
        end;

        if AutoServerRoomCall(m_CallRoomPlanList.Items[i]) = True then
        begin
          //OutRoom(m_CallRoomPlanList.Items[i], rfInput);
          Exit;
        end;
      end;
    end;
  finally
    ReFreshData;
    tmrAutoCallRoom.Enabled := True;
  end;
end;

procedure TFrmCallPlan.tmrUpdatePlanTimer(Sender: TObject);
begin
  ReFreshData();

end;

end.
