unit uFrmQueryWaitRecord;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, AdvDateTimePicker, StdCtrls, RzLabel, ExtCtrls, RzPanel,
  Grids, AdvObj, BaseGrid, AdvGrid, Buttons, PngCustomButton,uWaitWorkMgr,
  uWaitWork,uGlobalDM,uTFSystem,DateUtils,uDBWorkShop,uWorkShop,uPubFun,ComObj,
  ufrmProgressEx,uSaftyEnum, frxClass;

type
  TGridCol = (cl_Index,cl_Type,cl_CheJian,cl_jiaolu,cl_CheCi,cl_Room,cl_GH,cl_name,cl_dtWait,
    cl_dtInRoom ,cl_InRoomVerify,cl_dtLate,cl_CallTime, cl_dtOutRoom,cl_outRoomVerify,cl_dtSleep);
  TFrmQueryWaitRecord = class(TForm)
    rzpnlTop: TRzPanel;
    lbl: TRzLabel;
    lbl1: TRzLabel;
    dtpEnd: TAdvDateTimePicker;
    dtpStart: TAdvDateTimePicker;
    rzpnl1: TRzPanel;
    btnSearch: TPngCustomButton;
    btnExport2xsl: TPngCustomButton;
    GridWaitRecord: TAdvStringGrid;
    cbbCheJian: TComboBox;
    lbl2: TRzLabel;
    OpenDialog1: TOpenDialog;
    UserMasterDS: TfrxUserDataSet;
    frxrprt1: TfrxReport;
    lbl3: TRzLabel;
    edtTrainNo: TEdit;
    lbl4: TRzLabel;
    edtTrainmanNum: TEdit;
    btn2: TPngCustomButton;
    btnPrint: TPngCustomButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure btnExport2xslClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure frxrprt1GetValue(const VarName: string; var Value: Variant);
    procedure GridWaitRecordGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
  private
    //查询起始时间
    m_dtStart:TDateTime;
    //查询截止时间
    m_dtEnd:TDateTime;
    //候班计划
    m_PlanList:TWaitWorkPlanList;
    //候班管理
    m_WaitMgr:TWaitWorkMgr;
    //车间数据库操作
    m_dbWorkShop:TRsDBWorkShop;
    //车间列表
    m_WorkShopAry:TRsWorkShopArray;
    //打印索引
    m_PrintIndex:integer;
    
  private
    {功能:设置查询时间范围}
    function InitSearchData():Boolean;
    {功能:初始化表格}
    procedure InitGrid(nCount:Integer);
    {功能:填充表格}
    procedure FillGrid();
    {功能:填充行}
    procedure FillLine(nRow:Integer; plan:TWaitWorkPlan;man:TWaitWorkTrainmanInfo;
      strList:TStringList);
    {功能:获取迟到时长}
    function GetLateTimeStr(plan:TWaitWorkPlan;man:TWaitWorkTrainmanInfo):string;
    {功能:获取寓修时长}
    function GetSleepTimeStr(man:TWaitWorkTrainmanInfo):string;
    {功能:初始化车间}
    procedure InitCheJian();
  public
    { Public declarations }
  end;

var
  FrmQueryWaitRecord: TFrmQueryWaitRecord;

implementation

uses
  utfPopBox ;

{$R *.dfm}

procedure TFrmQueryWaitRecord.btnPrintClick(Sender: TObject);
var
  mmoItem:TfrxMemoView;
  Paiban_PlanCount,Paiban_TrainmanCount:Integer;
  QianDian_PlanCount,QianDian_TrainmanCount:Integer;
  BenDi_PlanCount,BenDi_TrainmanCount:Integer;
  SuoYou_PlanCount,SuoYou_TrainmanCount:Integer;
begin
  UserMasterDS.RangeEnd := reCount;
  UserMasterDS.RangeEndCount :=GridWaitRecord.RowCount -1;
  mmoItem:=TfrxMemoView(frxrprt1.FindObject('Memo_ShiDuan')) ;
  mmoItem.Text := Format('时段:%s至%s',[TPubFun.DateTime2Str(m_dtStart),TPubFun.DateTime2Str(m_dtEnd)]);
  mmoItem:=TfrxMemoView(frxrprt1.FindObject('Memo_PaiBan')) ;
  m_PlanList.GetPlanCount_Type(TWWPT_ASSIGN,Paiban_PlanCount,Paiban_TrainmanCount);
  mmoItem.Text := Format('派班计划:%3d个%3d人',[Paiban_PlanCount,Paiban_TrainmanCount]);

  mmoItem:=TfrxMemoView(frxrprt1.FindObject('Memo_QianDian')) ;
  m_PlanList.GetPlanCount_Type(TWWPT_SIGN,QianDian_PlanCount,QianDian_TrainmanCount);
  mmoItem.Text := Format('签点计划:%3d个%3d人',[QianDian_PlanCount,QianDian_TrainmanCount]);

  mmoItem:=TfrxMemoView(frxrprt1.FindObject('Memo_BenDi')) ;
   m_PlanList.GetPlanCount_Type(TWWPT_LOCAL,BenDi_PlanCount,BenDi_TrainmanCount);
  mmoItem.Text := Format('本地计划:%3d个%3d人',[BenDi_PlanCount,BenDi_TrainmanCount]);;

  mmoItem:=TfrxMemoView(frxrprt1.FindObject('Memo_SuoYou')) ;
  SuoYou_PlanCount := Paiban_PlanCount + QianDian_PlanCount+BenDi_PlanCount;
  SuoYou_TrainmanCount :=Paiban_TrainmanCount+ QianDian_TrainmanCount + BenDi_TrainmanCount;
  mmoItem.Text := Format('所有计划:%3d个%3d人',[SuoYou_PlanCount,SuoYou_TrainmanCount]);
  frxrprt1.ShowReport;
end;

procedure TFrmQueryWaitRecord.btnExport2xslClick(Sender: TObject);
var
  excelFile : string;
  excelApp,workBook,workSheet: Variant;
  m_nIndex : integer;
  i,j: Integer;
  plan:TWaitWorkPlan;
  man:TWaitWorkTrainmanInfo;
begin
  
  if not OpenDialog1.Execute then exit;
  excelFile := OpenDialog1.FileName;
  try
    excelApp := CreateOleObject('Excel.Application');
  except
    Application.MessageBox('你还没有安装Microsoft Excel,请先安装！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  try
    excelApp.Visible := false;
    excelApp.Caption := '应用程序调用 Microsoft Excel';
    if FileExists(excelFile) then
    begin
      TtfPopBox.ShowBox('文件已存在,请更换存储名称');
      Exit;
      excelApp.workBooks.Open(excelFile);
      excelApp.Worksheets[1].activate;
      workSheet := excelApp.Worksheets[1];
    end
    else begin
      excelApp.WorkBooks.Add;
      workBook:=excelApp.Workbooks.Add;
      workSheet:=workBook.Sheets.Add;
    end; 
    m_nIndex := 1;

    excelApp.Cells[m_nIndex,1].Value := '序号';
    excelApp.Cells[m_nIndex,2].Value := '车间';
    excelApp.Cells[m_nIndex,3].Value := '交路';
    excelApp.Cells[m_nIndex,4].Value := '车次';
    excelApp.Cells[m_nIndex,5].Value := '房间';
    excelApp.Cells[m_nIndex,6].Value := '工号';
    excelApp.Cells[m_nIndex,7].Value := '姓名';
    excelApp.Cells[m_nIndex,8].Value := '候班时间';
    workSheet.Columns[8].ColumnWidth := 20;
    //excelApp.Columns[m_nIndex,8].ColumnWidth := 100;
    excelApp.Cells[m_nIndex,9].Value := '入寓时间';
    workSheet.Columns[9].ColumnWidth := 20;
    excelApp.Cells[m_nIndex,10].Value := '入寓认证';
    excelApp.Cells[m_nIndex,11].Value := '晚到时长';
    excelApp.Cells[m_nIndex,12].Value := '出寓时间';
    workSheet.Columns[12].ColumnWidth := 20;
    excelApp.Cells[m_nIndex,13].Value := '出寓认证';
    excelApp.Cells[m_nIndex,14].Value := '寓修时长';
    
    Inc(m_nIndex);
    for i := 0 to m_PlanList.Count -1 do
    begin
      plan := m_PlanList.Items[i];
      if plan.tmPlanList.Count = 0 then
      begin
        excelApp.Cells[m_nIndex,1].Value := IntToStr(i+1);
        excelApp.Cells[m_nIndex,2].Value := plan.strCheJianName;
        excelApp.Cells[m_nIndex,3].Value := plan.strTrainJiaoLuName ;
        excelApp.Cells[m_nIndex,4].Value := plan.strCheCi;

        TfrmProgressEx.ShowProgress('正在导出候班信息，请稍后',i + 1,m_PlanList.Count);
        Inc(m_nIndex);
      end
      else
      begin
        for j := 0 to plan.tmPlanList.Count - 1 do
        begin
          man:= Plan.tmPlanList.Items[j];
          excelApp.Cells[m_nIndex,1].Value := IntToStr(i+1);
          excelApp.Cells[m_nIndex,2].Value := plan.strCheJianName;
          excelApp.Cells[m_nIndex,3].Value := plan.strTrainJiaoLuName ;
          excelApp.Cells[m_nIndex,4].Value := plan.strCheCi;
          excelApp.Cells[m_nIndex,5].Value := man.strRealRoom;;
          excelApp.Cells[m_nIndex,6].Value := man.strTrainmanNumber;
          excelApp.Cells[m_nIndex,7].Value := man.strTrainmanName;
          excelApp.Cells[m_nIndex,8].Value := FormatDateTime('yyyy-mm-dd HH:nn:ss',plan.dtWaitWorkTime);
          excelApp.Cells[m_nIndex,9].Value := FormatDateTime('yyyy-mm-dd HH:nn:ss',man.InRoomInfo.dtInOutRoomTime);
          excelApp.Cells[m_nIndex,10].Value := TRsRegisterFlagName[man.InRoomInfo.eVerifyType];
          excelApp.Cells[m_nIndex,11].Value := GetLateTimeStr(plan,man);
          excelApp.Cells[m_nIndex,12].Value := FormatDateTime('yyyy-mm-dd HH:nn:ss',man.OutRoomInfo.dtInOutRoomTime);
          excelApp.Cells[m_nIndex,13].Value := TRsRegisterFlagName[man.OutRoomInfo.eVerifyType];
          excelApp.Cells[m_nIndex,14].Value := GetSleepTimeStr(man);
          TfrmProgressEx.ShowProgress('正在导出候班信息，请稍后',i + 1,m_PlanList.Count);
          Inc(m_nIndex);
        end;
      end;
    end;
    if not FileExists(excelFile) then
    begin
      workSheet.SaveAs(excelFile);
    end
  finally
    TfrmProgressEx.CloseProgress;
    excelApp.Quit;
    excelApp := Unassigned;
  end;
  Application.MessageBox('导出完毕！','提示',MB_OK + MB_ICONINFORMATION);
end;

procedure TFrmQueryWaitRecord.btnSearchClick(Sender: TObject);
var
  strWorkShopGUID:string;
begin
  if InitSearchData = False  then Exit;
  if cbbCheJian.ItemIndex > 0 then
    strWorkShopGUID := m_WorkShopAry[cbbCheJian.ItemIndex-1].strWorkShopGUID;
  m_PlanList.Clear;
  m_WaitMgr.DBPlan.GetPlanManInOutRoom(m_dtStart,m_dtEnd,strWorkShopGUID,Trim(edtTrainNo.Text),Trim(edtTrainmanNum.Text),m_PlanList,not GlobalDM.bOrderByRoom);
  FillGrid();
  m_PrintIndex := 0;
end;

procedure TFrmQueryWaitRecord.FillGrid;
var
  i,j,nRow:Integer;
  plan:TWaitWorkPlan;
  man:TWaitWorkTrainmanInfo;
  MergeRowNumList:TStringList;
begin
  //GridWaitRecord.BeginUpdate;
  MergeRowNumList:=TStringList.Create;
  try
    InitGrid(m_PlanList.GetRecordCount());
    nRow := 1;
    for i := 0 to m_PlanList.Count -1 do
    begin
      plan := m_PlanList.Items[i];
      if plan.tmPlanList.Count = 0 then
      begin
        FillLine(nRow,plan,nil,MergeRowNumList);
        Inc(nRow);
      end
      else
      begin
        for j := 0 to plan.tmPlanList.Count - 1 do
        begin
          man:= Plan.tmPlanList.Items[j];
          FillLine(nRow,plan,man,MergeRowNumList);
          Inc(nRow);
        end;
      end;
    end;
    
    //self.GridWaitRecord.VAlignment:=vtaTop;
  finally
    MergeRowNumList.Free;
  end;
end;

procedure TFrmQueryWaitRecord.FillLine(nRow:Integer; plan:TWaitWorkPlan;
  man:TWaitWorkTrainmanInfo;strList:TStringList);
var
  i,j:Integer;
  nFirstRow,nPreFirstRow:Integer;
begin
  with GridWaitRecord do
  //with self.str1 do
  begin
    Cells[Ord(cl_Index),nRow] := IntToStr(nRow);
    Cells[Ord(cl_CheJian),nRow] := plan.strCheJianName;
    Cells[Ord(cl_jiaolu),nRow] := plan.strTrainJiaoLuNickName;
    Cells[Ord(cl_Type),nRow] :=  TWaitWorkPlanTypeName[plan.ePlanType];
    Cells[Ord(cl_CheCi),nRow] := plan.strCheCi;
    Cells[Ord(cl_dtWait),nRow] := TPubFun.DT2StrmmddHHnn( plan.dtWaitWorkTime);
    if man <> nil then
    begin
      Cells[Ord(cl_room),nRow] := man.strRealRoom;
      Cells[Ord(cl_GH),nRow] := man.strTrainmanNumber;
      Cells[Ord(cl_name),nRow] := man.strTrainmanName;
      if man.InRoomInfo.strGUID <> '' then
      begin
        Cells[Ord(cl_dtInRoom),nRow] := TPubFun.DT2StrmmddHHnn(man.InRoomInfo.dtInOutRoomTime);
        Cells[Ord(cl_InRoomVerify),nRow] :=TRsRegisterFlagName[man.InRoomInfo.eVerifyType];
        Cells[Ord(cl_dtLate),nRow] := GetLateTimeStr(plan,man);
      end;

      Cells[ord(cl_CallTime),nRow] := TPubFun.DT2StrmmddHHnn(plan.dtCallWorkTime);
      //Cells[ord(cl_FirstCall),nRow] := TPubFun.DT2StrmmddHHnn(man.dtFirstCallTime);

      if man.OutRoomInfo.strGUID <> '' then
      begin
        Cells[Ord(cl_dtOutRoom),nRow] := TPubFun.DT2StrmmddHHnn(man.OutRoomInfo.dtInOutRoomTime);
        Cells[Ord(cl_OutRoomVerify),nRow] :=TRsRegisterFlagName[man.OutRoomInfo.eVerifyType];
        Cells[Ord(cl_dtSleep),nRow] := GetSleepTimeStr(man);
      end;
    end;

    for i := 0 to 5 do
    begin
      if nRow = 1 then
      begin
        strList.Add('1')
      end
      else
      begin
        nFirstRow := StrToInt(strList.Strings[i]);
        nPreFirstRow := -1 ;
        if i > 0 then
          nPreFirstRow := StrToInt(strList.Strings[i-1]);
        if (Cells[i+1,nRow] = Cells[i+1,nFirstRow])  then
        begin
          MergeCells(i+1,nFirstRow,1,nRow - nFirstRow + 1);
        end
        else
        begin
          nFirstRow := nRow;
          strList.Strings[i] := IntToStr(nFirstRow);
          for j := i+1 to 5  do
          begin
            //nFirstRow := StrToInt(strList.Strings[j]);
            //MergeCells(j,nFirstRow,1,nRow - nFirstRow );
            strList.Strings[j] := IntToStr(nRow);
          end;
          Break;

        end;
      end;
    end;
  end;
end;

procedure TFrmQueryWaitRecord.FormCreate(Sender: TObject);
begin
  m_PlanList:=TWaitWorkPlanList.Create;
  m_WaitMgr:=TWaitWorkMgr.GetInstance(GlobalDM.LocalADOConnection);
  m_dbWorkShop:=TRsDBWorkShop.Create(GlobalDM.LocalADOConnection);
  InitCheJian;
  dtpStart.DateTime := DateOf(GlobalDM.GetNow);
  dtpEnd.DateTime := dtpStart.DateTime + 1;
end;

procedure TFrmQueryWaitRecord.FormDestroy(Sender: TObject);
begin
  m_PlanList.Free;
  m_dbWorkShop.Free;
end;

procedure TFrmQueryWaitRecord.frxrprt1GetValue(const VarName: string;
  var Value: Variant);
var
  RecIndex:Integer;
begin
  RecIndex := UserMasterDS.RecNo + 1;
  if CompareText(VarName, 'index') = 0 then
    Value := GridWaitRecord.Cells[Ord(cl_Index),RecIndex];
  if CompareText(VarName, 'WorkShop') = 0 then
    Value := GridWaitRecord.Cells[Ord(cl_CheJian),RecIndex];
  if CompareText(VarName, 'TrainJiaoLu') = 0 then
    Value := GridWaitRecord.Cells[Ord(cl_jiaolu),RecIndex];
  if CompareText(VarName, 'PlanType') = 0 then
    Value := GridWaitRecord.Cells[Ord(cl_Type),RecIndex];
  if CompareText(VarName, 'TrainNo') = 0 then
    Value := GridWaitRecord.Cells[Ord(cl_CheCi),RecIndex];
  if CompareText(VarName, 'Room') = 0 then
    Value := GridWaitRecord.Cells[Ord(cl_Room),RecIndex];
  if CompareText(VarName, 'Num') = 0 then
    Value := GridWaitRecord.Cells[Ord(cl_GH),RecIndex];
  if CompareText(VarName, 'Name') = 0 then
    Value := GridWaitRecord.Cells[Ord(cl_name),RecIndex];
  if CompareText(VarName, 'dtWait') = 0 then
    Value := GridWaitRecord.Cells[Ord(cl_dtWait),RecIndex];
  if CompareText(VarName, 'dtInRoom') = 0 then
    Value := GridWaitRecord.Cells[Ord(cl_dtInRoom),RecIndex];
  if CompareText(VarName, 'InRoomVerify') = 0 then
    Value := GridWaitRecord.Cells[Ord(cl_InRoomVerify),RecIndex];
  if CompareText(VarName, 'dtLate') = 0 then
    Value := GridWaitRecord.Cells[Ord(cl_dtLate),RecIndex];
  if CompareText(VarName, 'dtFirstCall') = 0 then
    Value := GridWaitRecord.Cells[Ord(cl_CallTime),RecIndex];
  if CompareText(VarName, 'dtOutRoom') = 0 then
    Value := GridWaitRecord.Cells[Ord(cl_dtOutRoom),RecIndex];
  if CompareText(VarName, 'OutRoomVerify') = 0 then
    Value := GridWaitRecord.Cells[Ord(cl_OutRoomVerify),RecIndex];
  if CompareText(VarName, 'dtSleep') = 0 then
    Value := GridWaitRecord.Cells[Ord(cl_dtSleep),RecIndex];

end;

function TFrmQueryWaitRecord.GetLateTimeStr(plan: TWaitWorkPlan;
  man: TWaitWorkTrainmanInfo): string;
var
  nMin,nHour:Integer;
begin
  Result := '';
  if plan.bNeedRest = False then Exit;
  
  if man.InRoomInfo.dtInOutRoomTime = 0 then Exit;
  if man.InRoomInfo.dtInOutRoomTime <= plan.dtWaitWorkTime then Exit;

  
  nMin := MinutesBetween(man.InRoomInfo.dtInOutRoomTime,plan.dtWaitWorkTime);
  nHour := HoursBetween(man.InRoomInfo.dtInOutRoomTime,plan.dtWaitWorkTime);
  if nMin > 0 then
  begin
    result := Format('%d时%d分',[nHour,nMin - nHour*60]);
  end;
  
end;

function TFrmQueryWaitRecord.GetSleepTimeStr(
  man: TWaitWorkTrainmanInfo): string;
var
  dtIn,dtOut:TDateTime;
  nMin,nHour:Integer;
begin
  Result := '';
  dtIn := man.InRoomInfo.dtInOutRoomTime;
  dtOut := man.OutRoomInfo.dtInOutRoomTime;
  if dtIn = 0 then Exit;
  if dtOut = 0 then Exit;
  if dtOut <= dtIn then Exit;
  
  nMin := MinutesBetween(dtIn,dtOut);
  nHour := HoursBetween(dtIn,dtOut);
  if nMin > 0 then
  begin
    result := Format('%d时%d分',[nHour,nMin - nHour*60]);
  end;
end;

procedure TFrmQueryWaitRecord.GridWaitRecordGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  HAlign := taCenter;
  //VAlign := vtaCenter;
end;

procedure TFrmQueryWaitRecord.InitCheJian;
var
  i:Integer;
begin
  m_dbWorkShop.GetWorkShopOfSite(GlobalDM.SiteInfo.strSiteGUID,m_WorkShopAry);
  cbbCheJian.Clear;
  cbbCheJian.Items.Add('所有');
  for I := 0 to Length(m_WorkShopAry) - 1 do
  begin
    cbbCheJian.Items.Add(m_WorkShopAry[i].strWorkShopName);
  end;
  if cbbCheJian.Items.Count >0 then
    cbbCheJian.ItemIndex := 0;
    
end;

procedure TFrmQueryWaitRecord.InitGrid(nCount: Integer);
begin
  with self.GridWaitRecord do
  //with self.str1 do
  begin
    ClearRows(1,10000);
    if nCount > 0  then
      RowCount :=nCount + 2
    else
    begin
      RowCount := 2;
      Cells[99,1] := ''
    end;
  end;
end;

function TFrmQueryWaitRecord.InitSearchData: Boolean;
begin
  result := False;
  if dtpStart.DateTime > dtpEnd.DateTime then
  begin
    TtfPopBox.ShowBox('起始时间必须小于截止时间');
    Exit;
  end;
  m_dtStart := dtpStart.DateTime;
  m_dtEnd := dtpEnd.DateTime;
  result := True;
end;

end.
