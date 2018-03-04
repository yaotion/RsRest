unit uFrmMatchWaitMan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, AdvObj, BaseGrid, AdvGrid, StdCtrls, ComCtrls, ExtCtrls,
  RzPanel,uGlobalDM,uTrainJiaolu,uDBTrainJiaolu,uLCSignPlan,uSaftyEnum,
  AdvDateTimePicker,uSignPlan,uWaitWork,uWaitWorkMgr,uTFSystem,uPubFun,StrUtils,
  DateUtils;

type

  TMatchResult =(MC_OK{ƥ��ɹ�},MC_TMDiff{��Ա��һ��},MC_WaitTimeDiff{���ʱ�䲻һ��},
    MC_NOWaitPlan{δ�ҵ����ƻ�},MC_NOSignPlan{δ�ҵ�ǩ��ƻ�},MC_OKTMCHANGE{ƥ��ɹ���Ա�仯});



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
    //��·����
    m_JiaoluAry:TRsTrainJiaoluArray;
    //��·���ݿ����
    m_dbTrainJiaoLu:TRsDBTrainJiaolu;
    //ǩ��web����
    m_WebSinPlan:TRSLCSignPlan;
    //�����ʼʱ��
    m_dtStart:TDateTime;
    //����ֹʱ��
    m_dtEnd:TDateTime;
    //ǩ��ƻ�
    m_SignPlanList:TSignPlanList;
    //���ƻ�
    m_WaitPlanList:TWaitWorkPlanList;
    //������
    m_WaitMgr:TWaitWorkMgr;

  private
    {����:������ֹʱ��}
    function SetStartEndTime():Boolean;
    {����:��ǩ����Աƥ�䵽���ƻ���}
    procedure MatchWaitMan();
    {����:���Ҹ����ƻ�ƥ���ǩ��ƻ�}
    function MatchSignPlan(nCurRow:Integer;waitPlan:TWaitWorkPlan):Boolean;
    {����:����м�¼}
    procedure FillLine(nRow:Integer;waitPlan:TWaitWorkPlan;signPlan:TSignPlan;eMatchResult:TMatchResult);
    {����:��ʼ����ʾ�б�}
    procedure InitGrid(nCount:Integer);
    {����:�жϺ��ƻ���ǩ��ƻ��е���Ա�Ƿ�һ��}
    function CheckTrainmanSame(waitPlan:TWaitWorkPlan;signPlan:TSignPlan):Boolean;
    {����:��ʽ������ʱ��}
    function FormatDT(dtTime:TDateTime):string;
    {����:�жϺ��ʱ���Ƿ���ͬ,���Ƚ���}
    function CheckSameTime(dt1,dt2:TDateTime):Boolean;

  public
    { Public declarations }
  end;
  
const
  //ƥ��������
 TMatchResultNameAry : array[TMatchResult] of string =
    ('ƥ��ɹ�','��Ա��һ��','���ʱ�䲻һ��','δ�ҵ����ƻ�','δ�ҵ�ǩ��ƻ�','ƥ��ɹ���Ա�仯');
 //ƥ������ɫ��ʾ
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
    //������ͬ
    if signPlan.strTrainNo = waitPlan.strCheCi then
    begin
      if CheckSameTime(signPlan.dtArriveTime ,waitPlan.dtWaitWorkTime)= False then
      begin
        fillLine(nCurRow, waitPlan,signPlan,MC_WaitTimeDiff);    //'���ʱ�䲻ͬ'
        m_SignPlanList.Remove(signPlan);
        Exit;
      end;

      //��Ա����Ԣ,��δ�仯
      if (waitPlan.GetTrainmanCount <> 0)  and (CheckTrainmanSame(waitPlan,signPlan)= True) then
      begin
        fillLine(nCurRow, waitPlan,signPlan,MC_OK); //ƥ��ɹ�
        m_SignPlanList.Remove(signPlan);
        Exit;
      end
      else
      begin
        if waitPlan.GetInRoomTrainmanCount <> 0 then //��Ա�仯,������Ԣ
        begin
          fillLine(nCurRow, waitPlan,signPlan,MC_TMDiff); //strMsg := '��Ա��һ��';
          m_SignPlanList.Remove(signPlan);
          Exit;
        end
        else  //��Ա�仯,���Ƕ�δ��Ԣ
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
        
          fillLine(nCurRow, waitPlan,signPlan,MC_OK);//ƥ��ɹ�
          m_SignPlanList.Remove(signPlan);
          Exit;
        end;
      end;
    end
  end;

  fillLine(nCurRow, waitPlan,nil,MC_NOSignPlan); //�޶�Ӧǩ��ƻ�';
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
    TtfPopBox.ShowBox('��ֹʱ����������ʼʱ��');
    Exit;
  end;
  m_dtStart := dtpStart.DateTime;
  m_dtEnd := dtpEnd.DateTime;
  result := True;
end;

end.
