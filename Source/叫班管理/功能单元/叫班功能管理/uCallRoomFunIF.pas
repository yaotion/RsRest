unit uCallRoomFunIF;

interface

uses
  Classes, uFrmAutoCall, uFrmMunualCall, uRoomCall, uRoomCallOp, uAutoRecallNoFrm, uAutoServerRoomNoFrm, SysUtils, uRoomCallApp, uFrmNotifyNotOutRoom, uWaitWork, Controls, uFrmAutoCall_Insert, uTFSystem, uFrmMunualCall2, uFrmReverseCall_Insert, uFrmMunualMonitor;

type                           
  //�а๦��
  TCallRoomFunIF = class(TObject)
  public
    class function NewInstance: TObject; override;
    constructor Create();
    destructor Destroy(); override;
    procedure FreeInstance; override;
    //��ȡʵ������
    class function GetInstance(): TCallRoomFunIF;
  public
      //����:�ж��Ƿ����ڵ����а�
    function bFrmReverseCalling(): Boolean;
    //����:�ж��Ƿ����ڵ����а�
    function bFrmCalling(): Boolean;
    //����:�ж��Ƿ����ڽа�
    function bCallling(bCheckLastTastTime: Boolean = true): Boolean;
    //����:ִ���˹��а�
    procedure MunualCall(CallRoomPlan: TCallRoomPlan; strCheCi: string = ''; strRoomNum: string = '');
    //����:ִ���˹��а�
    procedure MunualCall2(CallRoomPlan: TCallRoomPlan; strCheCi: string = ''; strRoomNum: string = '');
    //����:ִ���˹�����
    procedure MunualMonitor(CallRoomPlan: TCallRoomPlan; strCheCi: string = ''; strRoomNum: string = '');
    //����:ִ�на�_Ƕ�볨��
    procedure AutoCall_InsertFrm(parentWnd: TWinControl; callRecord: TCallRoomRecord; callRoomPlan: TCallRoomPlan; FinishCallResult: TFinishCallResult);
    //����:ִ�з����Һ���_��������
    procedure AutoServerRoomCall_NoFrm(callRecord: TCallRoomRecord; callRoomPlan: TCallRoomPlan; FinishCallResult: TFinishCallResult);

    //����:����Ƕ�볨��
    procedure ReverseCall_InsertFrm(parentWnd: TWinControl; callRecord: TCallRoomRecord; FinishCallResult: TFinishCallResult);
    //���ܣ�ȡ��������
    procedure CancelReverseCall_InsertFrm();
  private
    //�Զ��а�_Ƕ�봰������¼�
    procedure AutoCall_InsertFrm_FinishEvent(bSucess: Boolean; data: TCallDevCallBackData);
    //�Զ��а�_�޴�������¼�
    procedure AutoServerRoomCall_NoFrm_FinishEvent(bSucess: Boolean; data: TCallDevCallBackData);
    //�˹��а�_�����¼�
    procedure MunalCall_FinishEvent(bSucess: Boolean; data: TCallDevCallBackData);
    //����_Ƕ�봰������¼�
    procedure ReverseCall_InsertFrm_FinishEvent(bSucess: Boolean; data: TCallDevCallBackData);
  private
      //�˹��аര�����
    m_FrmMunualCall2: TFrmMunualCall2;
    //�˹������������
    m_FrmMunualMonitor: TFrmMunualMonitor;
    //�˹��аര�����
   // m_FrmMunualCall:TFrmMunualCall;
    //�Զ��а�Ƕ�봰��
    m_FrmAutoCall_Insert: TFrmAutoCall_Insert;
    //�޴����Զ��߰�
    m_AutoServerRoomNoFrm: TAutoServerRoomNoFrm;
    //����Ƕ�봰��
    m_FrmReverseCall_Insert: TFrmReverseCall_Insert;

    //�а��������
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
  //�Ƿ�ʼ������
  if (m_FrmReverseCall_Insert = nil) then
  begin
    result := False;
    Exit ;
  end;
  //�Ƿ��Ѿ���ͨ
  Result := not m_FrmReverseCall_Insert.IsConnect ;
end;

//����:�ж��Ƿ����ڽа�
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


