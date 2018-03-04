unit UFrmRecvCallNotify;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, AdvObj, BaseGrid, AdvGrid, ExtCtrls, RzPanel, StdCtrls,
  ComCtrls, AdvDateTimePicker, RzLabel,uDBRoomCall,uRoomCall,uGlobalDM, Buttons,
  PngSpeedButton,uCallNotify,uDBCallNotify,uSaftyEnum,DateUtils,uPubFun,uTFSystem,
  ufrmTextInput,uWaitWork,uWaitWorkMgr,uRoomCallApp;

type

  TColIndex = (cl_Index,cl_State,cl_Cancel,cl_CheCi,cl_CallTime,cl_ChuQinTime,
    cl_TM,cl_Room,cl_InRoomTime,cl_SleepTime,cl_NotifyContent, cl_SendUser,cl_NotifyTime,cl_RecvUser,cl_RecvTime,
    cl_CancelUser,cl_CancelTime,cl_CancelReason);
    
  TFrmRecvCallNotify = class(TForm)
    rzpnl2: TRzPanel;
    rzpnl3: TRzPanel;
    btnRefreshPaln: TPngSpeedButton;
    btnCancel: TPngSpeedButton;
    lbl1: TLabel;
    GridNotifyCall: TAdvStringGrid;
    dtpStart: TAdvDateTimePicker;
    btnSetRoom: TPngSpeedButton;
    btnMatchRoom: TPngSpeedButton;
    rzpnl1: TRzPanel;
    btnOK: TButton;
    btnClose: TButton;
    chkHideCancel: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnRefreshPalnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnMatchRoomClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSetRoomClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure chkHideCancelClick(Sender: TObject);
  private
    //�а�֪ͨ���ݿ����
    m_DBCallNotify:TDBCallNotify;
    //�а�֪ͨ����
    m_CallNotifyAry:TRSCallNotifyAry;
    //������Ϣ�б�
    m_RoomList :TWaitRoomList;
    //���˹���
    m_WaitWorkMgr:TWaitWorkMgr;
    //��Ա�а�ƻ��б�
    m_CallManPlanList:TCallManPlanList;
    //�а����
    m_CallMgr:TRoomCallApp;
    //������
    m_WaitMgr:TWaitWorkMgr;
  private
    {����:��ʼ�����}
    procedure InitGrid(nCount:Integer);
    {����:�����}
    procedure FillGrid();
    {����:�����}
    procedure FillLine(nRow:Integer;callNotify:RRsCallNotify);
    {����:����֪ͨ}
    procedure SendNotify();
    {����:ˢ��}
    procedure RefreshData();
    {����:ȡ��֪ͨ}
    procedure CancelNotify();
    {����:��ʽ����ʾ�Ƿ�ȡ��}
    function Fmt2Yes(nCancel:Integer):String;
    {����:��ȡѡ��֪ͨ}
    function GetSelectNotify(out CallNotify:RRsCallNotify):Integer;
    {����:ƥ�䷿��}
    procedure MatchRoom();
    {����:���Ԣ����Ϣ}
    procedure FillLine_WaitInfo(nRow:integer;waitMan:TWaitWorkTrainmanInfo);
    {����:��䷿����Ϣ}
    procedure FillLine_RoomInfo(nRow:Integer;strRoomNum:string);
    {����:��ȡ��Ϣʱ��}
    function GetSleepTime(waitMan:TWaitWorkTrainmanInfo):string;
    {����:�����а�ƻ�}
    procedure CreateCallPlan(CallNotify:RRsCallNotify; waitMan:TWaitWorkTrainmanInfo);
    {����:�����а�ƻ�����ָ������}
    procedure CreateCallPlanWithRoom(CallNotify:RRsCallNotify;strRoomNum:string);

  end;

  {����:��ʾ���սа�֪ͨ����}
  procedure ShowRecvCallNotifyFrm();

implementation
uses
  utfPopBox ;

{$R *.dfm}
procedure ShowRecvCallNotifyFrm();
var
  frm :TFrmRecvCallNotify;
begin
  frm := TFrmRecvCallNotify.Create(nil);
  try
    frm.ShowModal;
  finally
    frm.Free;
  end;
end;
{ TFrmRecvCallNodity }


procedure TFrmRecvCallNotify.btnCancelClick(Sender: TObject);
begin
  CancelNotify;
end;

procedure TFrmRecvCallNotify.btnCloseClick(Sender: TObject);
begin
  Self.ModalResult := mrCancel;
end;

procedure TFrmRecvCallNotify.btnMatchRoomClick(Sender: TObject);
begin
  m_RoomList.Clear;
  m_WaitWorkMgr.GetRoomWaitInfo(m_RoomList);
  MatchRoom;
end;

procedure TFrmRecvCallNotify.btnOKClick(Sender: TObject);
var
  i:Integer;
  strGUIDAry:TStringArray;

begin
  SetLength(strGUIDAry,m_CallManPlanList.Count);
  for I := 0 to m_CallManPlanList.Count - 1 do
  begin
    strGUIDAry[i] := m_CallManPlanList.Items[i].strCallNotifyGUID;
  end;

  m_DBCallNotify.SetRecv(strGUIDAry,GlobalDM.DutyUser.strDutyName,GlobalDM.GetNow);
  m_CallMgr.DBCallPlan.Add(m_CallManPlanList);
  Self.ModalResult := mrOk;
end;

procedure TFrmRecvCallNotify.btnRefreshPalnClick(Sender: TObject);
begin
  RefreshData();
end;

procedure TFrmRecvCallNotify.btnSetRoomClick(Sender: TObject);
var
  callNotify:RRsCallNotify;
  waitMan:TWaitWorkTrainmanInfo;
  strNewRoom:string;
  nIndex:Integer;
begin
  nIndex := GetSelectNotify(callNotify) ;
  if nIndex = -1 then
  begin
    TtfPopBox.ShowBox('δѡ����Ч��¼');
    Exit;
  end;
  if callNotify.nCancel = 1 then
  begin
    TtfPopBox.ShowBox('��ѡ֪ͨ��ȡ��!');
    Exit;
  end;
  if callNotify.eCallState <> cwsNotify then
  begin
    TtfPopBox.ShowBox('����֪ͨ��¼��ָ������');
    Exit;
  end;
  
  waitMan :=m_RoomList.FindTrainman(callNotify.strTrainmanGUID);
  if waitMan <> nil then
  begin
    TtfPopBox.ShowBox('��ƥ�䷿��');
    Exit;
  end;
  if TextInput('��ʾ','ָ������',strNewRoom) = False then Exit;
  if m_WaitWorkMgr.DBRoom.bExist(strNewRoom) = False then
  begin
    TtfPopBox.ShowBox(Format('����[%s]������!',[strNewRoom]));
    Exit;
  end;
  
  CreateCallPlanWithRoom(callNotify,strNewRoom);
  FillLine_RoomInfo(nIndex+1,strNewRoom);

end;

procedure TFrmRecvCallNotify.CancelNotify;
var
  callNotify:RRsCallNotify;
  strReason:string;
begin
  if GetSelectNotify(callNotify) = -1 then
  begin
    TtfPopBox.ShowBox('δѡ����Ч��¼!');
    Exit;
  end;
  if TextInput('��ʾ!','���볷��ԭ��:',strReason) = False then Exit;
  
  m_DBCallNotify.SetCancel(callNotify.strMsgGUID,GlobalDM.DutyUser.strDutyName,
       GlobalDM.GetNow,strReason );
  RefreshData;
end;

procedure TFrmRecvCallNotify.chkHideCancelClick(Sender: TObject);
begin
  RefreshData();
end;

procedure TFrmRecvCallNotify.CreateCallPlan(CallNotify:RRsCallNotify;waitMan: TWaitWorkTrainmanInfo);
var
  newCallManPlan,oldCallManPlan:TCallManPlan;
begin
  newCallManPlan:=TCallManPlan.Create;
  if m_CallMgr.DBCallPlan.FindUnCall(CallNotify.strTrainPlanGUID,CallNotify.strTrainmanGUID,newCallManPlan) = False then
  begin
    newCallManPlan.strGUID := NewGUID;
  end;
  newCallManPlan.strWaitPlanGUID := waitMan.strPlanGUID;
  newCallManPlan.strTrainmanGUID := waitMan.strTrainmanGUID;
  newCallManPlan.strTrainmanNumber := waitMan.strTrainmanNumber;
  newCallManPlan.strTrainmanName := waitMan.strTrainmanName;
  newCallManPlan.strTrainPlanGUID := CallNotify.strTrainPlanGUID;
  newCallManPlan.strTrainNo := CallNotify.strTrainNo;
  newCallManPlan.dtCallTime := CallNotify.dtCallTime;
  newCallManPlan.dtChuQinTime := CallNotify.dtChuQinTime;
  newCallManPlan.strRoomNum := waitMan.strRealRoom;
  newCallManPlan.strCallNotifyGUID := CallNotify.strMsgGUID;
  newCallManPlan.dtFirstCallTime :=0;
  newCallManPlan.dtReCallTime := 0;
  newCallManPlan.ePlanState := TCS_Publish;
  oldCallManPlan:= m_CallManPlanList.Find(newCallManPlan.strTrainmanGUID);
  if oldCallManPlan <> nil then
    m_CallManPlanList.Remove(oldCallManPlan);
  m_CallManPlanList.Add(newCallManPlan);
end;

procedure TFrmRecvCallNotify.CreateCallPlanWithRoom(CallNotify: RRsCallNotify;
  strRoomNum: string);
var
  newCallManPlan,oldCallManPlan:TCallManPlan;
begin
  newCallManPlan:=TCallManPlan.Create;
  if m_CallMgr.DBCallPlan.FindUnCall(CallNotify.strTrainPlanGUID,CallNotify.strTrainmanGUID,newCallManPlan) = False then
  begin
    newCallManPlan.strGUID := NewGUID;
  end;
  newCallManPlan.strWaitPlanGUID := '';
  newCallManPlan.strTrainmanGUID := CallNotify.strTrainmanGUID;
  newCallManPlan.strTrainmanNumber := CallNotify.strTrainmanNumber;
  newCallManPlan.strTrainmanName := CallNotify.strTrainmanName;
  newCallManPlan.strTrainPlanGUID := CallNotify.strTrainPlanGUID;
  newCallManPlan.strTrainNo := CallNotify.strTrainNo;
  newCallManPlan.dtCallTime := CallNotify.dtCallTime;
  newCallManPlan.dtChuQinTime := CallNotify.dtChuQinTime;
  newCallManPlan.strRoomNum := strRoomNum;
  newCallManPlan.strCallNotifyGUID := CallNotify.strMsgGUID;
  newCallManPlan.dtFirstCallTime :=0;
  newCallManPlan.dtReCallTime := 0;
  newCallManPlan.ePlanState := TCS_Publish;
  oldCallManPlan:= m_CallManPlanList.Find(newCallManPlan.strTrainmanGUID);
  if oldCallManPlan <> nil then
    m_CallManPlanList.Remove(oldCallManPlan);
  m_CallManPlanList.Add(newCallManPlan);

end;

procedure TFrmRecvCallNotify.FillGrid;
var
  i:Integer;
begin
  InitGrid(Length(m_CallNotifyAry));
  for i := 0 to Length(m_CallNotifyAry) - 1 do
  begin
    FillLine(i+1,m_CallNotifyAry[i]);
  end;
    
end;

procedure TFrmRecvCallNotify.FillLine(nRow: Integer; callNotify:RRsCallNotify);
begin
  with GridNotifyCall do
  begin
        Cells[Ord(cl_Index),nRow] := IntToStr(nRow) ;
    Cells[Ord(cl_State),nRow] := TRsCallWorkStateName[callNotify.eCallState] ;
    Cells[Ord(cl_Cancel),nRow] :=Fmt2Yes(callNotify.nCancel) ;
    Cells[Ord(cl_CheCi),nRow] := callNotify.strTrainNo ;
    Cells[Ord(cl_CallTime),nRow] := TPubFun.DT2StrmmddHHnn(callNotify.dtCallTime) ;
    Cells[Ord(cl_ChuQinTime),nRow] :=TPubFun.DT2StrmmddHHnn(callNotify.dtChuQinTime) ;
    Cells[Ord(cl_TM),nRow] :=TPubFun.FormatTMNameNum(callNotify.strTrainmanName,callNotify.strTrainmanNumber) ;
    Cells[Ord(cl_NotifyContent),nRow] := callNotify.strSendMsgContent ;
    Cells[Ord(cl_SendUser),nRow] := callNotify.strSendUser ;
    Cells[Ord(cl_NotifyTime),nRow] :=TPubFun.DT2StrmmddHHnn(callNotify.dtSendTime) ;
    Cells[Ord(cl_RecvUser),nRow] := callNotify.strRecvUser ;
    Cells[Ord(cl_RecvTime),nRow] := TPubFun.DT2StrmmddHHnn(callNotify.dtRecvTime) ;
    Cells[Ord(cl_CancelUser),nRow] :=  callNotify.strCancelUser ;
    Cells[Ord(cl_CancelTime),nRow] :=TPubFun.DT2StrmmddHHnn(callNotify.dtCancelTime) ;
    Cells[Ord(cl_CancelReason),nRow] := callNotify.strCancelReason ;
  end;
end;

procedure TFrmRecvCallNotify.FillLine_WaitInfo(nRow: integer;waitMan:TWaitWorkTrainmanInfo);
begin
  with GridNotifyCall do
  begin
    cells[ord(cl_Room),nRow] := waitMan.strRealRoom;
    Cells[Ord(cl_InRoomTime),nRow] := TPubFun.DT2StrmmddHHnn(waitMan.InRoomInfo.dtInOutRoomTime);
    Cells[Ord(cl_SleepTime),nRow] := GetSleepTime(waitMan);
  end;

end;
procedure TFrmRecvCallNotify.FillLine_RoomInfo(nRow:Integer;strRoomNum:string);
begin
  with GridNotifyCall do
  begin
    cells[ord(cl_Room),nRow] := strRoomNum;
  end;
end;

function TFrmRecvCallNotify.Fmt2Yes(nCancel: Integer): String;
begin
  result := '';
  if nCancel = 1 then
    result := '��'
end;

procedure TFrmRecvCallNotify.FormCreate(Sender: TObject);
begin
  m_DBCallNotify := TDBCallNotify.Create(GlobalDM.ADOConnection);
  dtpStart.DateTime := IncMinute(GlobalDM.GetNow,-(60*4));
  m_RoomList := TWaitRoomList.Create;
  m_WaitWorkMgr:=TWaitWorkMgr.GetInstance(GlobalDM.LocalADOConnection);
  m_CallManPlanList:=TCallManPlanList.Create;
  m_CallMgr:=TRoomCallApp.GetInstance;
  m_WaitMgr:=TWaitWorkMgr.GetInstance(GlobalDM.LocalADOConnection);
end;

procedure TFrmRecvCallNotify.FormDestroy(Sender: TObject);
begin
  m_DBCallNotify.Free;
  m_RoomList.Free;
  m_CallManPlanList.Free;
end;



procedure TFrmRecvCallNotify.FormShow(Sender: TObject);
begin
  RefreshData();

end;

function TFrmRecvCallNotify.GetSelectNotify(
  out CallNotify: RRsCallNotify): Integer;
var
  nIndex:Integer;
begin
  result:= -1;
  nIndex := GridNotifyCall.Row -1;
  if (nIndex >= 0) and (nIndex < Length(m_CallNotifyAry)) then
  begin
    CallNotify := m_CallNotifyAry[nIndex];
    Result := nIndex;
  end;
end;

function TFrmRecvCallNotify.GetSleepTime(
  waitMan: TWaitWorkTrainmanInfo): string;
var
  dtNow,dtInRoom:TDateTime;
  nMinutes,nHours:Integer;
begin
  dtInRoom := waitMan.InRoomInfo.dtInOutRoomTime;
  dtNow := GlobalDM.GetNow;
  nHours := DateUtils.HoursBetween(dtNow,dtInRoom);
  nMinutes := DateUtils.MinutesBetween(dtNow,dtInRoom);
  result := Format('%dʱ%d��',[nHours,nMinutes - nHours*60]);
end;

procedure TFrmRecvCallNotify.InitGrid(nCount: Integer);
begin
  With GridNotifyCall do
  begin
    ClearRows(1,10000);
    if nCount > 0  then
      RowCount := nCount + 1
    else
    begin
      RowCount := 2;
      Cells[99,1] := ''
    end;
  end;
end;

procedure TFrmRecvCallNotify.MatchRoom;
var
  i:Integer;
  waitMan:TWaitWorkTrainmanInfo;
begin
  m_CallManPlanList.Clear;
  for i := 0 to Length(m_CallNotifyAry)- 1 do
  begin
    if m_CallNotifyAry[i].nCancel = 1 then Continue;
    if m_CallNotifyAry[i].eCallState <> cwsNotify  then Exit;
    waitMan := m_RoomList.FindTrainman(m_CallNotifyAry[i].strTrainmanGUID);
    if waitMan <> nil then
    begin
      m_WaitWorkMgr.GetInOutRoomInfo(waitMan);
      FillLine_WaitInfo(i+1,waitMan);
      CreateCallPlan(m_callNotifyAry[i],waitMan);
    end;
  end;
end;

procedure TFrmRecvCallNotify.RefreshData;
begin
  m_DBCallNotify.GetByStateSec(m_CallNotifyAry,cwsNotify,cwsFinish,dtpStart.DateTime,chkHideCancel.checked);
  FillGrid();
  btnMatchRoomClick(nil);
end;

procedure TFrmRecvCallNotify.SendNotify;
begin
  
end;

end.
