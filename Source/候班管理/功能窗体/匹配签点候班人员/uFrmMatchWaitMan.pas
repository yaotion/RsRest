unit uFrmMatchWaitMan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, AdvObj, BaseGrid, AdvGrid, StdCtrls, ComCtrls, ExtCtrls,
  RzPanel,uGlobalDM,uTrainJiaolu,uDBTrainJiaolu,uLCSignPlan,uSaftyEnum,
  AdvDateTimePicker,uSignPlan,uWaitWork,uWaitWorkMgr,uTFSystem,uPubFun,StrUtils,
  DateUtils;

type

  TMatchResult =(MC_OK{匹配成功},MC_TMDiff{人员不一致},MC_WaitTimeDiff{候班时间不一致},
    MC_NOWaitPlan{未找到候班计划},MC_NOSignPlan{未找到签点计划},MC_OKTMCHANGE{匹配成功人员变化});



  TFrmMatchWaitMan = class(TForm)
    rzpnl1: TRzPanel;
    lbl1: TLabel;
    btnMatch: TButton;
    rzpnl2: TRzPanel;
    GridMatchWaitMan: TAdvStringGrid;
    rzpnl3: TRzPanel;
    btnOK: TButton;
    btnCancel: TButton;
    lbl2: TLabel;
    dtpStart: TAdvDateTimePicker;
    dtpEnd: TAdvDateTimePicker;
    procedure FormCreate(Sender: TObject);
    procedure btnMatchClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure GridMatchWaitManGetCellColor(Sender: TObject; ARow, ACol: Integer;
      AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
  public
    class function MatchWaitMan2Room():Boolean;
  private
    //交路数组
    m_JiaoluAry:TRsTrainJiaoluArray;
    //交路数据库操作
    m_dbTrainJiaoLu:TRsDBTrainJiaolu;
    //签点web操作
    m_WebSinPlan:TRSLCSignPlan;
    //候班起始时间
    m_dtStart:TDateTime;
    //候班截止时间
    m_dtEnd:TDateTime;
    //签点计划
    m_SignPlanList:TSignPlanList;
    //候班计划
    m_WaitPlanList:TWaitWorkPlanList;
    //候班管理
    m_WaitMgr:TWaitWorkMgr;

  private
    {功能:设置起止时间}
    function SetStartEndTime():Boolean;
    {功能:将签点人员匹配到候班计划中}
    procedure MatchWaitMan();
    {功能:查找跟候班计划匹配的签点计划}
    function MatchSignPlan(nCurRow:Integer;waitPlan:TWaitWorkPlan):Boolean;
    {功能:填充行记录}
    procedure FillLine(nRow:Integer;waitPlan:TWaitWorkPlan;signPlan:TSignPlan;eMatchResult:TMatchResult);
    {功能:初始化显示列表}
    procedure InitGrid(nCount:Integer);
    {功能:判断候班计划和签点计划中的人员是否一致}
    function CheckTrainmanSame(waitPlan:TWaitWorkPlan;signPlan:TSignPlan):Boolean;
    {功能:格式化日期时间}
    function FormatDT(dtTime:TDateTime):string;
    {功能:判断候班时间是否相同,不比较秒}
    function CheckSameTime(dt1,dt2:TDateTime):Boolean;

  public
    { Public declarations }
  end;
  
const
  //匹配结果名称
 TMatchResultNameAry : array[TMatchResult] of string =
    ('匹配成功','人员不一致','候班时间不一致','未找到候班计划','未找到签点计划','匹配成功人员变化');
 //匹配结果颜色标示
 TMatchResultColorAry : array[TMatchResult] of Integer =
  (clWhite,clBlue,clRed,clYellow,clLime,clGreen);

implementation

uses
  utfPopBox ;

{$R *.dfm}

procedure TFrmMatchWaitMan.btnCancelClick(Sender: TObject);
begin
  Self.ModalResult := mrCancel;
end;

procedure TFrmMatchWaitMan.btnMatchClick(Sender: TObject);
var
  jiaoluGUIDList:TStringList;
  i:Integer;
  strMsg:string;
begin
  if SetStartEndTime = False then Exit;
  m_WaitPlanList.Clear;
  m_SignPlanList.Clear;
  m_WaitMgr.DBPlan.GetAllNeedShowPlan(m_WaitPlanList,m_dtStart,m_dtEnd);
  
  m_dbTrainJiaoLu.GetTrainJiaoluArrayOfSite(GlobalDM.SiteInfo.strSiteGUID,m_JiaoluAry);
  jiaoluGUIDList:=TStringList.create;
  for i := 0 to Length(m_JiaoluAry) - 1 do
  begin
    jiaoluGUIDList.Add(m_JiaoluAry[i].strTrainJiaoluGUID);
  end;
  try
    if m_WebSinPlan.GetSignPlan_ByJiaoLuAry(m_dtStart,m_dtEnd,jiaoluGUIDList,m_SignPlanList,strMsg) = False then
    begin
      TtfPopBox.ShowBox(strMsg);
      Exit;
    end;
  finally
    jiaoluGUIDList.Free;
  end;
  MatchWaitMan();

end;

procedure TFrmMatchWaitMan.btnOKClick(Sender: TObject);
var
  i:Integer;
begin
  for i := 0 to m_WaitPlanList.Count - 1 do
  begin
    m_WaitMgr.ModifyPlan(m_WaitPlanList.Items[i]);
  end;
  Self.ModalResult := mrOk;
end;

function TFrmMatchWaitMan.CheckSameTime(dt1, dt2: TDateTime): Boolean;
begin
  result := False;
  if FormatDT(dt1) = FormatDT(dt2) then
    result := True;

  
end;

function TFrmMatchWaitMan.CheckTrainmanSame(waitPlan: TWaitWorkPlan;
  signPlan: TSignPlan): Boolean;
var
  i:Integer;
  waitMan:TWaitWorkTrainmanInfo;
begin
  result := False;
  if waitPlan.GetTrainmanCount <> signPlan.GetTrainmanCount then Exit;
  for i := 0 to waitPlan.tmPlanList.Count - 1 do
  begin
    waitMan :=waitPlan.tmPlanList.Items[i];
    if waitMan.strTrainmanGUID <> '' then
    begin
      if signPlan.FindTrainmanIndex(waitMan.strTrainmanGUID) = -1 then Exit;
    end;
  end;
  result := True;
  
end;

procedure TFrmMatchWaitMan.FillLine(nRow:Integer;waitPlan: TWaitWorkPlan;
  signPlan: TSignPlan;eMatchResult:TMatchResult);
begin
  with GridMatchWaitMan do
  begin
    Cells[0,nRow] := IntToStr(nRow);
    Cells[100,nRow] := IntToStr(Ord(eMatchResult));
    Cells[1,nRow] := TMatchResultNameAry[eMatchResult];
    if waitPlan <> nil then
    begin
      Cells[2,nRow] := waitPlan.strCheCi;
      Cells[3,nRow] := waitPlan.strRoomNum;
      Cells[4,nRow] := FormatDT(waitPlan.dtWaitWorkTime);

    end;
    if signPlan <> nil then
    begin
      Cells[5,nRow] := signPlan.strTrainNo;
      Cells[6,nRow] := FormatDT(signPlan.dtArriveTime);
      Cells[7,nRow] := TPubFun.FormatTMNameNum(signPlan.strTrainmanName1,signPlan.strTrainmanNumber1);
      Cells[8,nRow] := TPubFun.FormatTMNameNum(signPlan.strTrainmanName2,signPlan.strTrainmanNumber2);
      Cells[9,nRow] := TPubFun.FormatTMNameNum(signPlan.strTrainmanName3,signPlan.strTrainmanNumber3);
      Cells[10,nRow] := TPubFun.FormatTMNameNum(signPlan.strTrainmanName4,signPlan.strTrainmanNumber4);
    end;
  end;


end;

function TFrmMatchWaitMan.FormatDT(dtTime: TDateTime): string;
begin
  result := FormatDateTime('YYYY-MM-DD HH:nn',dtTime);
end;

procedure TFrmMatchWaitMan.FormCreate(Sender: TObject);
begin
  m_WaitPlanList:=TWaitWorkPlanList.Create;
  m_WaitMgr:=TWaitWorkMgr.GetInstance(GlobalDM.LocalADOConnection);
  m_SignPlanList:= TSignPlanList.Create;
  m_dbTrainJiaoLu:=TRsDBTrainJiaolu.Create(GlobalDM.ADOConnection);
  m_WebSinPlan:=TRSLCSignPlan.Create(GlobalDM.GetWebUrl,
  GlobalDM.SiteInfo.strSiteIP,GlobalDM.SiteInfo.strSiteGUID);
  //dtpStart.DateTime := StrToDateTime(FormatDateTime('yyyy-mm-dd',GlobalDM.GetNow)+ ' 12:00:00');
  //dtpEnd.DateTime := StrToDateTime(FormatDateTime('yyyy-mm-dd',GlobalDM.GetNow+1)+ ' 12:00:00');

  dtpStart.DateTime := DateOf(GlobalDM.GetNow)+  TimeOf(GlobalDM.LoadWaitWorkPlanStartTime);
  dtpEnd.DateTime := DateOf(dtpStart.DateTime + 1) + TimeOf(GlobalDM.LoadWaitWorkPlanEndTime);
end;

procedure TFrmMatchWaitMan.FormDestroy(Sender: TObject);
begin
  m_SignPlanList.Free;
  m_dbTrainJiaoLu.Free;
  m_WebSinPlan.Free;
  m_WaitPlanList.Free;
end;

procedure TFrmMatchWaitMan.GridMatchWaitManGetCellColor(Sender: TObject; ARow,
  ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
var
  eMcResult:TMatchResult;
begin
  if ARow < 1 then Exit;
  if ACol = 1 then
  begin
    if GridMatchWaitMan.cells[100,arow] <> '' then
    begin
      eMcResult := TMatchResult(strtoint(GridMatchWaitMan.cells[100,arow]));
      ABrush.Color := TMatchResultColorAry[eMcResult];
    end;
  end;
end;

procedure TFrmMatchWaitMan.InitGrid(nCount: Integer);
begin
  with GridMatchWaitMan do
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

function TFrmMatchWaitMan.MatchSignPlan(nCurRow:Integer;waitPlan: TWaitWorkPlan): Boolean;
var
  i:Integer;
  signPlan:TSignPlan;
  strMsg:string;
begin
  result := False;
  strMsg := '';
  for i := 0 to m_SignPlanList.Count - 1 do
  begin
    signPlan := m_SignPlanList.Items[i];
    //车次相同
    if signPlan.strTrainNo = waitPlan.strCheCi then
    begin
      if CheckSameTime(signPlan.dtArriveTime ,waitPlan.dtWaitWorkTime)= False then
      begin
        fillLine(nCurRow, waitPlan,signPlan,MC_WaitTimeDiff);    //'候班时间不同'
        m_SignPlanList.Remove(signPlan);
        Exit;
      end;

      //人员已入寓,但未变化
      if (waitPlan.GetTrainmanCount <> 0)  and (CheckTrainmanSame(waitPlan,signPlan)= True) then
      begin
        fillLine(nCurRow, waitPlan,signPlan,MC_OK); //匹配成功
        m_SignPlanList.Remove(signPlan);
        Exit;
      end
      else
      begin
        if waitPlan.GetInRoomTrainmanCount <> 0 then //人员变化,但已入寓
        begin
          fillLine(nCurRow, waitPlan,signPlan,MC_TMDiff); //strMsg := '人员不一致';
          m_SignPlanList.Remove(signPlan);
          Exit;
        end
        else  //人员变化,但是都未入寓
        begin
          if signPlan.strTrainmanGUID1 <> '' then
          begin
            waitPlan.tmPlanList.Items[0].strTrainmanGUID := signPlan.strTrainmanGUID1;
            waitPlan.tmPlanList.Items[0].strTrainmanNumber := signPlan.strTrainmanNumber1;
            waitPlan.tmPlanList.Items[0].strTrainmanName := signPlan.strTrainmanName1;
            waitPlan.tmPlanList.Items[0].eTMState := psPublish;
          end;
          if signPlan.strTrainmanGUID2 <> '' then
          begin
            waitPlan.tmPlanList.Items[1].strTrainmanGUID := signPlan.strTrainmanGUID2;
            waitPlan.tmPlanList.Items[1].strTrainmanNumber := signPlan.strTrainmanNumber2;
            waitPlan.tmPlanList.Items[1].strTrainmanName := signPlan.strTrainmanName2;
            waitPlan.tmPlanList.Items[1].eTMState := psPublish;
          end;
          if signPlan.strTrainmanGUID3 <> '' then
          begin
            waitPlan.tmPlanList.Items[2].strTrainmanGUID := signPlan.strTrainmanGUID3;
            waitPlan.tmPlanList.Items[2].strTrainmanNumber := signPlan.strTrainmanNumber3;
            waitPlan.tmPlanList.Items[2].strTrainmanName := signPlan.strTrainmanName3;
            waitPlan.tmPlanList.Items[2].eTMState := psPublish;
          end;
          if signPlan.strTrainmanGUID4 <> '' then
          begin
            waitPlan.tmPlanList.Items[3].strTrainmanGUID := signPlan.strTrainmanGUID4;
            waitPlan.tmPlanList.Items[3].strTrainmanNumber := signPlan.strTrainmanNumber4;
            waitPlan.tmPlanList.Items[3].strTrainmanName := signPlan.strTrainmanName4;
            waitPlan.tmPlanList.Items[3].eTMState := psPublish;
          end;
        
          fillLine(nCurRow, waitPlan,signPlan,MC_OK);//匹配成功
          m_SignPlanList.Remove(signPlan);
          Exit;
        end;
      end;
    end
  end;

  fillLine(nCurRow, waitPlan,nil,MC_NOSignPlan); //无对应签点计划';
end;

procedure TFrmMatchWaitMan.MatchWaitMan;
var
  i:Integer;
  nRowCount:Integer;
  nCurRow:Integer;
begin
  nRowCount := m_SignPlanList.Count;
  if m_WaitPlanList.Count > m_SignPlanList.Count then
  begin
    nRowCount := m_WaitPlanList.Count;
  end;
  InitGrid(nRowCount);
  nCurRow := 1;
  for I := 0 to m_WaitPlanList.Count - 1 do
  begin
    MatchSignPlan(nCurRow,m_WaitPlanList.Items[i]);
    Inc(nCurRow);
  end;
  GridMatchWaitMan.RowCount := GridMatchWaitMan.RowCount +  m_SignPlanList.Count;
  for i := 0 to m_SignPlanList.Count - 1 do
  begin
    fillLine(nCurRow,nil,m_SignPlanList.Items[i],MC_NOWaitPlan);
    Inc(nCurRow);
  end;

end;

class function TFrmMatchWaitMan.MatchWaitMan2Room: Boolean;
var
  frm: TFrmMatchWaitMan;
begin
  result := False;
  frm := TFrmMatchWaitMan.Create(nil);
  try
    if frm.ShowModal = mrOk then
    begin
      result := True;
    end;
  finally
    frm.Free;
  end;
end;

function TFrmMatchWaitMan.SetStartEndTime: Boolean;
begin
  result := False;
  if dtpEnd.DateTime < dtpStart.Date then
  begin
    TtfPopBox.ShowBox('截止时间必须大于起始时间');
    Exit;
  end;
  m_dtStart := dtpStart.DateTime;
  m_dtEnd := dtpEnd.DateTime;
  result := True;
end;

end.
