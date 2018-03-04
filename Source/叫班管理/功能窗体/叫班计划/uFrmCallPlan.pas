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
    {����:���빫Ԣ}
    procedure OutRoom(CallPlan: TCallRoomPlan;eVerifyFlag: TRsRegisterFlag);
    {ˢ������}
    procedure ReFreshData();
    {����:���һ���Ƿ���ͻȻ�ر�ϵͳ���¼ƻ��޷�ɾ��}
    function IsInValidPlan(CallPlan: TCallRoomPlan):boolean;
    //��ȡ���з�����Ϣ
    procedure GetJoinRooms(Rooms:TStringList;CallRoomRecord:TCallRoomRecord);
  private
    //�а��߼�
    m_RoomCallApp:TRoomCallApp;
    //�а�ƻ�
    m_CallRoomPlanList:TCallRoomPlanList;
    //������
    m_waitMgr:TWaitWorkMgr;
   
  private
    {����:��ȡ�а�ƻ�}
    procedure GetRoomCallPlan();
    {����:���а�ƻ��б�}
    procedure FillGrid();
    {����:����б�}
    procedure ClearGrid(nRowCount:Integer);
    {����:���а�ƻ���}
    procedure FillLine(nRow:Integer;CallPlan:TCallRoomPlan);
    {����:��ȡѡ�мƻ�����}
    function GetSelectPlanIndex():Integer;

    {����:��ʾ��Ա��������}
    function FmtTMNameNum(callRoomPlan:TCallRoomPlan;nIndex:Integer):string;
    {����:�а�ص��¼�}
    procedure FinishCallEvent(bSucess:Boolean; data:TCallDevCallBackData);
  private //�а����
    {����:ִ���Զ��׽�}
    function AutoFirstCall(CallPlan:TCallRoomPlan):Boolean;
    {����:ִ���Զ��߽�}
    function AutoReCall(CallPlan:TCallRoomPlan):Boolean;
    {����:ִ�з����Һ���}
    function AutoServerRoomCall(CallPlan:TCallRoomPlan):Boolean;
    {����:�����Զ��׽м�¼}
    procedure CreateAutoFirstCallRecord(callPlan:TCallRoomPlan;out callrecord:TcallRoomRecord;nDevNum:Integer);
    {����:�����Զ��߽м�¼}
    procedure CreateAutoReCallRecord(callPlan:TCallRoomPlan;out callrecord:TcallRoomRecord;nDevNum:Integer);
    {����:�����Զ��߽м�¼}
    procedure CreateServerRoomCallRecord(callPlan:TCallRoomPlan;out callrecord:TcallRoomRecord;nDevNum:Integer;strExternalRoomNumber:string);
    {����:�����˹��а��¼}
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
  //�а��¼
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
            //�޸ĺ��ƻ�����Ա�Ľа�״̬
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

            strText := Format('[�׽�]:�豸��:[%d]--�����:[%s]',[roomDev.nDevNum,CallPlan.strRoomNum]);
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
  
  //�Ѵ߽�
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
            //�޸ĺ��ƻ�����Ա�Ľа�״̬
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
            strText := Format('[�߽�]:�豸��:[%d]--�����:[%s]',[roomDev.nDevNum,CallPlan.strRoomNum]);
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


{����:ִ�з����Һ���}
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

  //�Ѵ߽�
  //if true then
  if CallPlan.bNeedServerRoomCall(dtNow,m_RoomCallApp.CallConfig.nReCallInterval) then
  begin
    if m_RoomCallApp.CallDevOp.bCalling = False then
    begin
      //����Ƿ���ڹ����ķ����ҷ���
      if m_RoomCallApp.DBServerRoomDev.IsExistSleepRoom(CallPlan.strRoomNum,strServerRoomNumber) then
      begin
        OutputDebugString('���ҷ���');
        if m_RoomCallApp.DBServerRoomDev.FindByRoom(strServerRoomNumber,roomDev) then
        begin
          callrecord :=TcallRoomRecord.Create;
          try
            CreateServerRoomCallRecord(CallPlan,callrecord, roomDev.nDevNum,strServerRoomNumber);
             GetJoinRooms(CallPlan.manList[0].JoinRoomList ,callrecord);
            if not TCallRoomFunIF.GetInstance.bCallling then
            begin
              strText := Format('������:[%s]--�豸��:[%d]--�����:[%s]',[strServerRoomNumber,roomDev.nDevNum,CallPlan.strRoomNum]);
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
        strText := Format('����[%s]û���ҵ������ķ�����',[CallPlan.strRoomNum]);
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
        TtfPopBox.ShowBox('���Ӽƻ�ʧ��,ԭ��:'+ e.Message);
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
      TtfPopBox.ShowBox('�豸���ڽа�,�����ظ��а�!');
      Exit;
    end;
    //tmrAutoCallRoom.Enabled := False;
    //ClearCallEventDeal();
    nIndex := GetSelectPlanIndex();
    if nIndex = -1 then
    begin
      TtfPopBox.ShowBox('δѡ����Ч�Ľа�ƻ�');
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
        TtfPopBox.ShowBox('�޸ļƻ�ʧ��,ԭ��:'+ e.Message);
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
        TtfPopBox.ShowBox('�޸ļƻ�ʧ��,ԭ��:'+ e.Message);
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
  //if bSucess = True then //�а�ɹ��Ĵ洢¼��,���ɹ��Ĵ洢��¼
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

  
  //�޸ĺ��ƻ�����Ա�Ľа�״̬
  for i := 0 to callrecord.CallManRecordList.Count - 1 do
  begin
    if data.callRoomRecord.eCallState = TCS_FIRSTCALL{�׽�} then
    begin
      ePlanState := psFirstCall;
    end;
    if data.callRoomRecord.eCallState = TCS_RECALL{�׽�} then
    begin
      ePlanState := psReCall;
    end;

    if data.callRoomRecord.eCallState = TCS_SERVER_ROOM_CALL{�׽�} then
    begin
      ePlanState := psServerRoomCall;
    end;

   
    m_waitMgr.ModifyTMCallState(callrecord.CallManRecordList.Items[i].strWaitPlanGUID,
        callrecord.CallManRecordList.Items[i].strTrainmanGUID,ePlanState,GlobalDM.GetNow,bSucess);


    if GlobalDM.bEnableServerRoomCall then
    begin
      //����Ƿ���������Զ���Ԣ
      if ePlanState = psServerRoomCall then
      begin
        m_waitMgr.SaveOutRoomInfo3(callrecord.CallManRecordList.Items[i].strWaitPlanGUID,callrecord.strRoomNum);
      end;
    end
    else
    begin
      //����Ǵ߽����Զ���Ԣ
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
  //��ǰѡ����Ա
  m_curTrainmanInfo:TWaitWorkTrainmanInfo;
  plan:TWaitWorkPlan;
  nCol:Integer;
  strMsg:string;
  TrainMan:RRsTrainman;
  i : Integer ;
  bNoTrainman : Boolean;
begin
  GlobalDM.LogManage.InsertLog('��ʼ��Ԣ');
  plan:= m_waitMgr.FindPlan_PlanID(CallPlan.strWaitPlanGUID);
  m_waitMgr.SaveOutRoomInfo2(CallPlan);
  GlobalDM.LogManage.InsertLog('��Ԣ�ɹ�');
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
//      //��ȡ��Ա�ļƻ�
//      plan:= m_waitMgr.FindPlan(TrainMan.strTrainmanGUID);
//      if plan <> nil then
//      begin
//        m_curTrainmanInfo := plan.tmPlanList.findTrainman(TrainMan.strTrainmanGUID);
//        if m_curTrainmanInfo <> nil then
//        begin
//          if ( m_curTrainmanInfo.eTMState >= psInRoom)  and (m_curTrainmanInfo.eTMState < psOutRoom) then   //�мƻ���Ԣ
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

    //�׽�
    for i := 0 to m_CallRoomPlanList.Count - 1 do
    begin
      if AutoFirstCall(m_CallRoomPlanList.Items[i]) = True then
      begin
        Exit;
      end;
    end;

    //�߽�
    for i := 0 to m_CallRoomPlanList.count - 1 do
    begin
      if AutoReCall(m_CallRoomPlanList.Items[i]) = True then
      begin
        Exit;
      end;
    end;

    //�����Һ���
    if GlobalDM.bEnableServerRoomCall   then
    begin

      for i := 0 to m_CallRoomPlanList.count - 1 do
      begin
        //����Ǵ���ļƻ���Ϣ��ֱ��ɾ��
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
