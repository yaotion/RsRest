unit uFrmLoadWaitPlan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, AdvDateTimePicker, StdCtrls, ExtCtrls, RzPanel,uWaitWorkMgr,
  uWaitWork,uGlobalDM,DateUtils,uTFSystem,uSaftyEnum,uPubFun;

type
  TFrmLoadWaitPlan = class(TForm)
    rzpnl1: TRzPanel;
    btnOK: TButton;
    btnCancel: TButton;
    lvWaitPlan: TListView;
    rzpnl2: TRzPanel;
    btnCreate: TButton;
    lbl1: TLabel;
    dtpStart: TAdvDateTimePicker;
    lbl2: TLabel;
    dtpEnd: TAdvDateTimePicker;
    chkCreateCallPlan: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btnCreateClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    {功能:设置起止日期}
    function SetStartEndDate():Boolean ;
    {功能:判断候班计划是可以创建}
    function CanPlanCreate(waitTime:RWaitTime;dtStart,dtEnd:TDateTime):Boolean;
    {功能:生成候班计划}
    procedure CreateWaitPlanS();
    {功能:根据候班时刻表,生成一个候班计划}
    function NewAPlan(waitRoom:RWaitTime;dtDay:TDate):TWaitWorkPlan;
    {功能:生成日期}
    function CreateDateTime(dtDate,dtTime:TDateTime):TDateTime;
    {功能:填充一行数据,根据时刻表}
    procedure FillLine_time(item:TListItem;waitTime:RWaitTime;strResult:string);
    {功能:填充行数据,根据候班计划}
    procedure FillLine_Plan(Item:TListItem;plan:TWaitWorkPlan);
  public
    {功能:加载图钉候班计划}
    class function LoadTuDingWaitPlan():Boolean;
  private
     //候班管理
    m_WaitMgr:TWaitWorkMgr;
    //已有计划
    m_CurWaitPlanList:TWaitWorkPlanList;
    //新计划
    m_NewWaitPlanList:TWaitWorkPlanList;
    //图钉候班时刻表
    m_WaitTimeAry:TWaitTimeAry;
    //开始时间
    m_dtStartTime:TDateTime;
    //截止时间
    m_dtEndTime:TDateTime;
  end;



implementation

{$R *.dfm}


procedure TFrmLoadWaitPlan.btn1Click(Sender: TObject);
begin
  lvWaitPlan.Clear;
end;

procedure TFrmLoadWaitPlan.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrmLoadWaitPlan.btnCreateClick(Sender: TObject);
begin
  SetStartEndDate();
  m_CurWaitPlanList.Clear;
  m_NewWaitPlanList.clear;
  SetLength(m_WaitTimeAry,0);
  lvWaitPlan.Clear;
  lvWaitPlan.Update;
  m_WaitMgr.DBPlan.GetPlanS(m_CurWaitPlanList,m_dtStartTime,m_dtEndTime);
  m_WaitMgr.DBWaitTime.GetAll(m_WaitTimeAry);
  CreateWaitPlanS();

end;

procedure TFrmLoadWaitPlan.btnOKClick(Sender: TObject);
var
  i:Integer;
begin
  for i := 0 to m_NewWaitPlanList.Count - 1 do
  begin
    m_WaitMgr.AddPlan(m_NewWaitPlanList.Items[i],true)  ;

    if chkCreateCallPlan.Checked then
    begin
      m_WaitMgr.CreateCallPlanByRoom(m_NewWaitPlanList.Items[i],m_NewWaitPlanList.Items[i].strRoomNum);
    end;
  end;
  ModalResult := mrOk;
end;

function TFrmLoadWaitPlan.CanPlanCreate(waitTime: RWaitTime;dtStart,dtEnd:TDateTime): Boolean;
var
  item:TListItem;
begin
  result := False;
  {if m_CurWaitPlanList.FindByRoomNum(waitTime.strRoomNum) <> nil then
  begin
    item := lvWaitPlan.Items.Add;
    FillLine_time(item,waitTime,'房间被占用');
    Exit;
  end; }
//  if not( (DateOf(dtStart) +TimeOf(waitTime.dtWaitTime) >=  dtStart)  and (DateOf(dtStart) +TimeOf(waitTime.dtWaitTime) <= dtEnd)) then
//    Exit;

  if not( (DateOf(dtStart) +TimeOf(waitTime.dtCallTime) >=  dtStart)  and
      (DateOf(dtStart) +TimeOf(waitTime.dtCallTime) <= dtEnd)) then
    Exit;



  if m_CurWaitPlanList.findByCheCi(waitTime.strTrainNo) <> nil  then
  begin
    item := lvWaitPlan.Items.Add;
    FillLine_time(item,waitTime,'车次被占用');
    Exit;
  end;


  Result := True;
end;

function TFrmLoadWaitPlan.CreateDateTime(dtDate, dtTime: TDateTime): TDateTime;
var
  strDate,strTime:string;
begin
  strDate := FormatDateTime('yyyy-mm-dd',dtDate);
  strTime := FormatDateTime('HH:nn:00',dtTime);
  Result := StrToDateTime(strDate +' ' + strTime);

end;

procedure TFrmLoadWaitPlan.CreateWaitPlanS;
var
  i:Integer;
  waitPlan :TWaitWorkPlan;
  item:TListItem;
  _startTime,_endTime:TDateTime;
  strStartTime,strEndTime,strmEndTime:string;
begin
  _startTime := m_dtStartTime;

  strStartTime := FormatDateTime('yyyy-MM-dd hh:mm:ss',_startTime);
  OutputDebugString(PAnsiChar(strStartTime));

  _endTime := DateOf(_startTime) + 1;

  strEndTime :=   FormatDateTime('yyyy-MM-dd hh:mm:ss',_endTime);
  OutputDebugString(PAnsiChar(strEndTime));

  strmEndTime :=  FormatDateTime('yyyy-MM-dd hh:mm:ss',m_dtEndTime);
  OutputDebugString(PAnsiChar(strmEndTime));
  
  if CompareDateTime(_endTime , m_dtEndTime) = 1then
  begin
    _endTime := m_dtEndTime;
  end;
  while _startTime < m_dtEndTime do
  begin
    for i := 0 to Length(m_WaitTimeAry) -1 do
    begin
      if CanPlanCreate(m_waittimeAry[i],_startTime,_endTime) = True then
      begin
        waitPlan := NewAPlan(m_WaitTimeAry[i],DateOf(_startTime));
        m_NewWaitPlanList.Add(waitPlan)
      end;
    end;  
    OutputDebugString('');
    _startTime :=  DateOf(_startTime) + 1;
    _endTime := DateOf(_startTime) + 1;
    if CompareDateTime(_endTime , m_dtEndTime) = 1 then
    begin
      _endTime := m_dtEndTime;
    end;
  end;
  



  for i := 0 to  m_NewWaitPlanList.Count- 1 do
  begin
    item:= lvWaitPlan.Items.Add;
    FillLine_Plan(item,m_NewWaitPlanList.Items[i]);
  end;
    

end;

procedure TFrmLoadWaitPlan.FillLine_Plan(Item: TListItem; plan: TWaitWorkPlan);
begin
  Item.Caption := IntToStr(Item.Index + 1);
//  Item.SubItems.Add(plan.strCheJianName);
//  Item.SubItems.Add(plan.strTrainJiaoLuNickName);
  Item.SubItems.Add(plan.strCheCi);
  Item.SubItems.Add(plan.strRoomNum);
  Item.SubItems.Add('00:00');
  Item.SubItems.Add(TPubFun.DT2StrmmddHHnn(plan.dtCallWorkTime));
  item.SubItems.Add(TPubFun.DT2StrmmddHHnn(plan.dtWaitWorkTime));
  item.SubItems.Add('');
end;

procedure TFrmLoadWaitPlan.FillLine_time(item: TListItem; waitTime: RWaitTime;strResult:string);
begin
  Item.Caption := IntToStr(Item.Index + 1);
  Item.SubItems.Add(waitTime.strTrainNo);
  item.SubItems.Add(waitTime.strRoomNum);
  Item.SubItems.Add(FormatDateTime('HH:nn',waitTime.dtWaitTime));
  item.SubItems.Add(FormatDateTime('HH:nn',waitTime.dtCallTime));
  item.SubItems.Add(FormatDateTime('HH:nn',waitTime.dtKaiCheTime));
  item.SubItems.Add(strResult);
end;

procedure TFrmLoadWaitPlan.FormCreate(Sender: TObject);
begin
  m_WaitMgr:=TWaitWorkMgr.GetInstance(GlobalDM.LocalADOConnection);
  m_CurWaitPlanList:=TWaitWorkPlanList.Create;
  m_NewWaitPlanList:=TWaitWorkPlanList.Create;

end;

procedure TFrmLoadWaitPlan.FormDestroy(Sender: TObject);
begin
  m_CurWaitPlanList.Free;
  m_NewWaitPlanList.Free;
end;

procedure TFrmLoadWaitPlan.FormShow(Sender: TObject);
begin
  dtpStart.DateTime := DateOf(GlobalDM.GetNow)+  TimeOf(GlobalDM.LoadWaitWorkPlanStartTime);

  dtpEnd.DateTime := DateOf(GlobalDM.GetNow + 1 ) + TimeOf(GlobalDM.LoadWaitWorkPlanEndTime);
end;

class function TFrmLoadWaitPlan.LoadTuDingWaitPlan: Boolean;
var
  frm:TFrmLoadWaitPlan;
begin
  result := False;
  frm := TFrmLoadWaitPlan.Create(nil);
  try
    if frm.ShowModal = mrOk then
      result:= True;
  finally
    frm.Free;
  end;
end;

function TFrmLoadWaitPlan.NewAPlan(waitRoom: RWaitTime;dtDay:TDate): TWaitWorkPlan;
var
  waitPlan  : TWaitWorkPlan;
  i:Integer;
  waitMan:TWaitWorkTrainmanInfo;
begin
  waitPlan := TWaitWorkPlan.Create;
  waitPlan.strPlanGUID := NewGUID;
  waitPlan.bNeedRest := False;
  waitPlan.bNeedSyncCall := False;
  if FormatDateTime('HH:nn:ss', waitRoom.dtCallTime) <> '00:00:00' then
  begin
    waitPlan.bNeedSyncCall := true;
  end;
  
  waitPlan.bNeedRest := waitRoom.bMustSleep;

  {if FormatDateTime('HH:nn:ss', waitRoom.dtWaitTime) <> '00:00:00' then
  begin
    waitPlan.bNeedRest := true;
  end; }

  waitPlan.ePlanState := psPublish;
  waitPlan.strCheCi := waitRoom.strTrainNo;
  waitPlan.strRoomNum := waitRoom.strRoomNum;
  waitPlan.strCheJianGUID := waitRoom.strWorkshopGUID;
  waitPlan.strCheJianName := waitRoom.strWorkShopName;
  waitPlan.strTrainJiaoLuGUID := waitRoom.strTrainJiaoLuGUID;
  waitPlan.strTrainJiaoLuName := waitRoom.strTrainJiaoLuName;
  waitPlan.strTrainJiaoLuNickName := waitRoom.strTrainJiaoLuNickName;

  waitPlan.dtWaitWorkTime := DateOf(dtDay) + TimeOf(waitRoom.dtWaitTime);
  {if FormatDateTime('HH:nn:00',waitRoom.dtWaitTime) < FormatDateTime('HH:nn:00',dtpStart.Time) then
  begin
    waitPlan.dtWaitWorkTime := CreateDateTime(DateOf(m_dtStartTime)+1,waitRoom.dtWaitTime);
  end
  else
  begin
    waitPlan.dtWaitWorkTime := CreateDateTime(DateOf(m_dtStartTime),waitRoom.dtWaitTime);
  end; }
  
  if FormatDateTime('HH:nn:ss', waitRoom.dtCallTime) <> '00:00:00' then
  begin
    //叫班时间
    if waitRoom.dtCallTime < waitRoom.dtWaitTime then
    begin
      waitPlan.dtCallWorkTime := CreateDateTime(DateOf(waitPlan.dtWaitWorkTime)+1,waitRoom.dtCallTime);
      waitPlan.dtWaitWorkTime := CreateDateTime(DateOf(waitPlan.dtWaitWorkTime)+1,waitRoom.dtKaiCheTime);
    end
    else
    begin
      waitPlan.dtCallWorkTime := CreateDateTime(DateOf(waitPlan.dtWaitWorkTime),waitRoom.dtCallTime);
      waitPlan.dtWaitWorkTime := CreateDateTime(DateOf(waitPlan.dtWaitWorkTime),waitRoom.dtKaiCheTime);
    end;
  end;
  
  waitPlan.ePlanType := TWWPT_LOCAL;
  if GlobalDM.bUseByPaiBan = True then
    waitPlan.ePlanType := TWWPT_ASSIGN;

  for i := 0 to 3 do
  begin
    waitMan:=TWaitWorkTrainmanInfo.Create;
    waitMan.strGUID := NewGUID;
    waitMan.strPlanGUID := waitPlan.strPlanGUID;
    waitMan.eTMState := psEdit;
    waitMan.strRealRoom := '';
    waitPlan.tmPlanList.Add(waitMan);
  end;
  result := waitPlan; 
  
end;

function TFrmLoadWaitPlan.SetStartEndDate():Boolean;
begin
  m_dtStartTime := dtpStart.DateTime;
  m_dtEndTime := dtpEnd.DateTime;
end;

end.
