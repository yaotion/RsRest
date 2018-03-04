unit uCallRoomFunIF;

interface

uses
  Classes, uFrmAutoCall, uFrmMunualCall, uRoomCall, uRoomCallOp, uAutoRecallNoFrm, uAutoServerRoomNoFrm, SysUtils, uRoomCallApp, uFrmNotifyNotOutRoom, uWaitWork, Controls, uFrmAutoCall_Insert, uTFSystem, uFrmMunualCall2, uFrmReverseCall_Insert, uFrmMunualMonitor;

type                           
  //叫班功能
  TCallRoomFunIF = class(TObject)
  public
    class function NewInstance: TObject; override;
    constructor Create();
    destructor Destroy(); override;
    procedure FreeInstance; override;
    //获取实例对象
    class function GetInstance(): TCallRoomFunIF;
  public
      //功能:判断是否正在弹窗叫班
    function bFrmReverseCalling(): Boolean;
    //功能:判断是否正在弹窗叫班
    function bFrmCalling(): Boolean;
    //功能:判断是否正在叫班
    function bCallling(bCheckLastTastTime: Boolean = true): Boolean;
    //功能:执行人工叫班
    procedure MunualCall(CallRoomPlan: TCallRoomPlan; strCheCi: string = ''; strRoomNum: string = '');
    //功能:执行人工叫班
    procedure MunualCall2(CallRoomPlan: TCallRoomPlan; strCheCi: string = ''; strRoomNum: string = '');
    //功能:执行人工监听
    procedure MunualMonitor(CallRoomPlan: TCallRoomPlan; strCheCi: string = ''; strRoomNum: string = '');
    //功能:执行叫班_嵌入敞口
    procedure AutoCall_InsertFrm(parentWnd: TWinControl; callRecord: TCallRoomRecord; callRoomPlan: TCallRoomPlan; FinishCallResult: TFinishCallResult);
    //功能:执行服务室呼叫_不带窗口
    procedure AutoServerRoomCall_NoFrm(callRecord: TCallRoomRecord; callRoomPlan: TCallRoomPlan; FinishCallResult: TFinishCallResult);

    //功能:反呼嵌入敞口
    procedure ReverseCall_InsertFrm(parentWnd: TWinControl; callRecord: TCallRoomRecord; FinishCallResult: TFinishCallResult);
    //功能：取消反呼叫
    procedure CancelReverseCall_InsertFrm();
  private
    //自动叫班_嵌入窗体结束事件
    procedure AutoCall_InsertFrm_FinishEvent(bSucess: Boolean; data: TCallDevCallBackData);
    //自动叫班_无窗体结束事件
    procedure AutoServerRoomCall_NoFrm_FinishEvent(bSucess: Boolean; data: TCallDevCallBackData);
    //人工叫班_结束事件
    procedure MunalCall_FinishEvent(bSucess: Boolean; data: TCallDevCallBackData);
    //反呼_嵌入窗体结束事件
    procedure ReverseCall_InsertFrm_FinishEvent(bSucess: Boolean; data: TCallDevCallBackData);
  private
      //人工叫班窗体对象
    m_FrmMunualCall2: TFrmMunualCall2;
    //人工监听窗体对象
    m_FrmMunualMonitor: TFrmMunualMonitor;
    //人工叫班窗体对象
   // m_FrmMunualCall:TFrmMunualCall;
    //自动叫班嵌入窗体
    m_FrmAutoCall_Insert: TFrmAutoCall_Insert;
    //无窗体自动催班
    m_AutoServerRoomNoFrm: TAutoServerRoomNoFrm;
    //反呼嵌入窗体
    m_FrmReverseCall_Insert: TFrmReverseCall_Insert;

    //叫班结束对象
    m_FinishCallResult: TFinishCallResult;
  end;

implementation

var
  CallRoomFunIFIns: TCallRoomFunIF = nil;
  CallRoomFunIF_CanFree: Boolean;

{ TCallRoomFrmMgr }

procedure TCallRoomFunIF.AutoCall_InsertFrm(parentWnd: TWinControl; callRecord: TCallRoomRecord; callRoomPlan: TCallRoomPlan; FinishCallResult: TFinishCallResult);
begin
  m_FinishCallResult := FinishCallResult;
  m_FrmAutoCall_Insert := TFrmAutoCall_Insert.Create(nil);
  try
    m_FrmAutoCall_Insert.Parent := parentWnd;
    m_FrmAutoCall_Insert.Align := alClient;
    m_FrmAutoCall_Insert.CallRecord.Clone(callRecord);
    m_FrmAutoCall_Insert.CallRoomPlan.Clone(callRoomPlan);
    m_FrmAutoCall_Insert.FinishCallResult := AutoCall_InsertFrm_FinishEvent;
    parentWnd.Height := m_FrmAutoCall_Insert.Height;
    m_FrmAutoCall_Insert.Show;
  finally
  end;
end;

procedure TCallRoomFunIF.AutoServerRoomCall_NoFrm(callRecord: TCallRoomRecord; callRoomPlan: TCallRoomPlan; FinishCallResult: TFinishCallResult);
begin
  m_FinishCallResult := FinishCallResult;
  m_AutoServerRoomNoFrm := TAutoServerRoomNoFrm.Create;
  m_AutoServerRoomNoFrm.AutoCall(callRecord, callRoomPlan, AutoServerRoomCall_NoFrm_FinishEvent);
end;

procedure TCallRoomFunIF.AutoServerRoomCall_NoFrm_FinishEvent(bSucess: Boolean; data: TCallDevCallBackData);
begin
  try
    if Assigned(m_FinishCallResult) then
      m_FinishCallResult(bSucess, data);
  finally
    FreeAndNil(m_AutoServerRoomNoFrm);
  end;

end;

procedure TCallRoomFunIF.AutoCall_InsertFrm_FinishEvent(bSucess: Boolean; data: TCallDevCallBackData);
begin
  try
    if Assigned(m_FinishCallResult) then
      m_FinishCallResult(bSucess, data);
  finally
    m_FrmAutoCall_Insert.Parent.Height := 0;
    //m_FrmAutoCall_Insert.Parent := nil;
    try
      FreeAndNil(m_FrmAutoCall_Insert);
    except
      on e: Exception do
        Box(e.Message);
    end;
  end;
end;

function TCallRoomFunIF.bFrmCalling: Boolean;
begin
  result := True;
  if (m_FrmMunualCall2 = nil) then
    result := False;
end;

function TCallRoomFunIF.bFrmReverseCalling: Boolean;
begin
  //是否开始反呼叫
  if (m_FrmReverseCall_Insert = nil) then
  begin
    result := False;
    Exit ;
  end;
  //是否已经接通
  Result := not m_FrmReverseCall_Insert.IsConnect ;
end;

//功能:判断是否正在叫班
function TCallRoomFunIF.bCallling(bCheckLastTastTime: Boolean = true): Boolean;
begin
  //result := TRoomCallApp.GetInstance.CallDevOp.bCalling or(m_FrmNotifyNotOutRoom <> nil);
  //Exit;

  result := True;
  if (m_FrmMunualCall2 = nil) and ( m_FrmMunualMonitor = nil) and (m_FrmAutoCall_Insert = nil) and (m_AutoServerRoomNoFrm = nil) and (m_FrmReverseCall_Insert = nil) then
  begin
    if bCheckLastTastTime = True then
    begin
      result := not TRoomCallApp.GetInstance.CallDevOp.CheckLastCallTime;
      Exit;
    end;
    result := False;
  end;
end;

procedure TCallRoomFunIF.CancelReverseCall_InsertFrm;
begin
  if m_FrmReverseCall_Insert <> nil then
  begin
    m_FrmReverseCall_Insert.Parent.Height := 0;
    FreeAndNil( m_FrmReverseCall_Insert );
    m_FrmReverseCall_Insert := nil ;
  end;
end;

constructor TCallRoomFunIF.Create;
begin
  m_FrmMunualMonitor := nil;
  m_FrmMunualCall2 := nil;
  m_AutoServerRoomNoFrm := nil;
  m_FrmAutoCall_Insert := nil;
  m_FrmReverseCall_Insert := nil;
end;

destructor TCallRoomFunIF.Destroy;
begin
  FreeAndNil(m_FrmMunualCall2);
  FreeAndNil(m_FrmMunualMonitor);
  FreeAndNil(m_AutoServerRoomNoFrm);
  FreeAndNil(m_FrmAutoCall_Insert);
  FreeAndNil(m_FrmReverseCall_Insert);
  inherited;
end;

procedure TCallRoomFunIF.FreeInstance;
begin
  if not CallRoomFunIF_CanFree then
    Exit;
  inherited FreeInstance;
  CallRoomFunIFIns := nil;

end;

class function TCallRoomFunIF.GetInstance: TCallRoomFunIF;
begin
  if not Assigned(CallRoomFunIFIns) then
    CallRoomFunIFIns := TCallRoomFunIF.Create;
  result := CallRoomFunIFIns;
end;

procedure TCallRoomFunIF.MunalCall_FinishEvent(bSucess: Boolean; data: TCallDevCallBackData);
begin

end;

procedure TCallRoomFunIF.MunualCall(CallRoomPlan: TCallRoomPlan; strCheCi: string = ''; strRoomNum: string = '');
begin
//  m_FrmMunualCall:= TFrmMunualCall.Create(nil);
//  try
//    m_FrmMunualCall.CallRoomPlan.Clone(CallRoomPlan);
//    m_FrmMunualCall.strCheCi := strCheCi;
//    m_FrmMunualCall.strRoomNum := strRoomNum;
//    m_FrmMunualCall.ShowModal
//  finally
//    FreeAndNil(m_FrmMunualCall);
//  end;
end;

procedure TCallRoomFunIF.MunualCall2(CallRoomPlan: TCallRoomPlan; strCheCi, strRoomNum: string);
begin
  m_FrmMunualCall2 := TFrmMunualCall2.Create(nil);
  try
    //m_FrmMunualCall2.CallRoomPlan.Clone(CallRoomPlan);
//    m_FrmMunualCall2.strCheCi := strCheCi;
//    m_FrmMunualCall2.strRoomNum := strRoomNum;
    m_FrmMunualCall2.InitData(strCheCi, strRoomNum);
    m_FrmMunualCall2.ShowModal
  finally
    FreeAndNil(m_FrmMunualCall2);
  end;
end;

procedure TCallRoomFunIF.MunualMonitor(CallRoomPlan: TCallRoomPlan; strCheCi, strRoomNum: string);
begin
  m_FrmMunualMonitor := TFrmMunualMonitor.Create(nil);
  try
    m_FrmMunualMonitor.InitData(strCheCi, strRoomNum);
    m_FrmMunualMonitor.ShowModal
  finally
    FreeAndNil(m_FrmMunualMonitor);
  end;
end;

class function TCallRoomFunIF.NewInstance: TObject;
begin
  //CallRoomFunIF: TCallRoomFunIF = nil;
  //CallRoomFunIF_CanFree:Boolean;

  if not Assigned(CallRoomFunIFIns) then
  begin
    CallRoomFunIFIns := TCallRoomFunIF(inherited NewInstance);
  end;
  result := CallRoomFunIFIns;
end;

procedure TCallRoomFunIF.ReverseCall_InsertFrm(parentWnd: TWinControl; callRecord: TCallRoomRecord; FinishCallResult: TFinishCallResult);
begin
  m_FinishCallResult := FinishCallResult;
  m_FrmReverseCall_Insert := TFrmReverseCall_Insert.Create(nil);
  try
    m_FrmReverseCall_Insert.Parent := parentWnd;
    m_FrmReverseCall_Insert.Align := alClient;
    m_FrmReverseCall_Insert.CallRecord.Clone(callRecord);
    m_FrmReverseCall_Insert.FinishCallResult := ReverseCall_InsertFrm_FinishEvent;
    parentWnd.Height := m_FrmReverseCall_Insert.Height;
    m_FrmReverseCall_Insert.Show;
  finally
  end;
end;

procedure TCallRoomFunIF.ReverseCall_InsertFrm_FinishEvent(bSucess: Boolean; data: TCallDevCallBackData);
begin
  try
    if Assigned(m_FinishCallResult) then
      m_FinishCallResult(bSucess, data);
  finally
    m_FrmReverseCall_Insert.Parent.Height := 0;
    //m_FrmAutoCall_Insert.Parent := nil;
    try
      FreeAndNil(m_FrmReverseCall_Insert);
    except
      on e: Exception do
        Box(e.Message);
    end;
  end;
end;

initialization
  CallRoomFunIFIns := TCallRoomFunIF.Create;

finalization
  CallRoomFunIF_CanFree := True;
  if Assigned(CallRoomFunIFIns) then
  begin
    CallRoomFunIFIns.Free;
    CallRoomFunIFIns := nil;
  end;

end.


