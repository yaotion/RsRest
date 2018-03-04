unit uFrmLeaderInspect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, RzListVw, ActnList, StdCtrls, ExtCtrls, RzPanel,uLeaderExam,
  uDBLocalTrainman,uSaftyEnum,uTrainman,utfsystem,uDBTrainman, Menus,
  Buttons, PngSpeedButton, Grids,uDBLeaderInspect, PngCustomButton,
  ComObj,ufrmProgressEx,uCallRoomFunIF;

type
  TFrmLeaderInspect = class(TForm)
    rzpnl1: TRzPanel;
    actlst1: TActionList;
    actInspect: TAction;
    lb1: TLabel;
    dtpStartDate: TDateTimePicker;
    lvRecord: TListView;
    lb2: TLabel;
    dtpEndDate: TDateTimePicker;
    dtpStartTime: TDateTimePicker;
    dtpEndTime: TDateTimePicker;
    btnCheck: TPngCustomButton;
    btnExport2xsl: TPngCustomButton;
    OpenDialog1: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCheckClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnExport2xslClick(Sender: TObject);
  private
    procedure InitData();
    procedure DataToListView(LeaderInspectList:TRsLeaderInspectList);
    procedure ExcuteInspect(Trainman : RRsTrainman;Verify : TRsRegisterFlag);
  private
    { Private declarations }
    m_dbLeaderInspect:TRsDBLeaderInspect;
    m_listLeaderInspect:TRsLeaderInspectList;
    m_dbTrainman:TRsDBLocalTrainman ;
  public
    { Public declarations }
    procedure OnFingerTouching(Sender: TObject);
    procedure RefreshData;
  end;

var
  FrmLeaderInspect: TFrmLeaderInspect;

implementation


uses
  uGlobalDM,uFrmGetInput,ufrmTrainmanIdentityAccess,ufrmSelectTrainman,ufrmTextInput,utfPopBox;

{$R *.dfm}

procedure TFrmLeaderInspect.btnCheckClick(Sender: TObject);
var
  strNumber : string;
  trainman : RRsTrainman;
  Verify :  TRsRegisterFlag;
begin
  GlobalDM.OnFingerTouching := nil;
  try
    begin

      if not GlobalDM.bShowUserList then
      begin
        if TextInput('����Ա��������', '���������Ա����:', strNumber) = False then
          Exit;
        if not m_DBTrainman.GetTrainmanByNumber(Trim(strNumber), trainman) then
        begin
          TtfPopBox.ShowBox('����ĳ���Ա����');
          exit;
        end;
      end
      else
      begin
        if not TfrmSelectTrainman.GetTrainman(trainman) then
        begin
          TtfPopBox.ShowBox('��Ч�Ĺ���!', MB_ICONERROR);
          Exit;
        end;
      end;
    end;
    strNumber := trainman.strTrainmanGUID;
    Verify :=  rfInput;
    ExcuteInspect(Trainman,Verify);
  finally
    GlobalDM.OnFingerTouching := OnFingerTouching;
  end;
end;

procedure TFrmLeaderInspect.btnExport2xslClick(Sender: TObject);
var
  excelFile : string;
  excelApp,workBook,workSheet: Variant;
  m_nIndex : integer;
  i: Integer;
  leaderInspect:RRsLeaderInspect;
begin
  if not OpenDialog1.Execute then exit;
  excelFile := OpenDialog1.FileName;
  try
    excelApp := CreateOleObject('Excel.Application');
  except
    Application.MessageBox('�㻹û�а�װMicrosoft Excel,���Ȱ�װ��','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  try
    excelApp.Visible := false;
    excelApp.Caption := 'Ӧ�ó������ Microsoft Excel';
    if FileExists(excelFile) then
    begin
      excelApp.workBooks.Open(excelFile);
       excelApp.Worksheets[1].activate;
    end
    else begin
      excelApp.WorkBooks.Add;
      workBook:=excelApp.Workbooks.Add;
      workSheet:=workBook.Sheets.Add;
    end; 
    m_nIndex := 1;

    excelApp.Cells[m_nIndex,1].Value := '���';
    excelApp.Cells[m_nIndex,2].Value := '����';
    excelApp.Cells[m_nIndex,3].Value := '����';
    excelApp.Cells[m_nIndex,4].Value := '�鷿ʱ��';
    excelApp.Cells[m_nIndex,5].Value := '�ǼǷ�ʽ';
    excelApp.Cells[m_nIndex,6].Value := '�鷿���';
    Inc(m_nIndex);
    for i := 0 to Length(m_listLeaderInspect) -1 do
    begin
      leaderInspect := m_listLeaderInspect[i];

      excelApp.Cells[m_nIndex,1].Value := IntToStr(i+1);
      excelApp.Cells[m_nIndex,2].Value := leaderInspect.strTrainmanName;
      excelApp.Cells[m_nIndex,3].Value := leaderInspect.strTrainmanNumber ;
      excelApp.Cells[m_nIndex,4].Value := FormatDateTime('YYYY-mm-dd HH:nn:ss',leaderInspect.CreateTime);
      if leaderInspect.VerifyID = 1 then
        excelApp.Cells[m_nIndex,5].Value := 'ָ��'
      else
        excelApp.Cells[m_nIndex,5].Value := '�ֶ�' ;
      excelApp.Cells[m_nIndex,6].Value := leaderInspect.strContext;

      TfrmProgressEx.ShowProgress('���ڵ��������Ϣ�����Ժ�',i + 1,Length(m_listLeaderInspect));
      Inc(m_nIndex);

    end;
    if not FileExists(excelFile) then
    begin
      workSheet.SaveAs(excelFile);
    end;
  finally
    TfrmProgressEx.CloseProgress;
    excelApp.Quit;
    excelApp := Unassigned;
  end;
  Application.MessageBox('������ϣ�','��ʾ',MB_OK + MB_ICONINFORMATION);
end;

procedure TFrmLeaderInspect.btnRefreshClick(Sender: TObject);
begin
  InitData;
end;



procedure TFrmLeaderInspect.DataToListView(LeaderInspectList:TRsLeaderInspectList);
var
  listItem:TListItem;
  i : Integer ;
  strText:string;
begin
  lvRecord.Items.Clear;
  for I := 0 to Length(LeaderInspectList) - 1 do
  begin
    listItem := lvRecord.Items.Add;
    with listItem do
    begin
      if GlobalDM.bShowTrainmNumber then
        Caption := Format('[%s]%s',[LeaderInspectList[i].strTrainmanNumber,LeaderInspectList[i].strTrainmanName])
      else
        Caption := Format('%s',[LeaderInspectList[i].strTrainmanName]);
      SubItems.Add( FormatDateTime('yyyy-MM-dd HH:nn:ss',LeaderInspectList[i].CreateTime) );
      if LeaderInspectList[i].VerifyID = 1 then
        strText := 'ָ��'
      else
        strText := '�ֶ�' ;
      SubItems.Add(strText);
      SubItems.Add(LeaderInspectList[i].strContext);
    end;
  end;

end;

procedure TFrmLeaderInspect.ExcuteInspect(Trainman: RRsTrainman;
  Verify: TRsRegisterFlag);
var
  strText:string;
  leaderInspect:RRsLeaderInspect ;
begin
  if not TFrmGetInput.GetInputText(strText) then
      Exit;

  leaderInspect.GUID := NewGUID ;
  leaderInspect.strContext := strText ;
  leaderInspect.LeaderGUID := Trainman.strTrainmanGUID ;
  leaderInspect.strTrainmanName := Trainman.strTrainmanName;
  leaderInspect.strTrainmanNumber := Trainman.strTrainmanNumber ;
  leaderInspect.VerifyID := ord(Verify);
  leaderInspect.CreateTime := Now ;
  leaderInspect.DutyGUID := '' ;
  m_dbLeaderInspect.AddLeaderInspect(leaderInspect) ;

  InitData;
end;

procedure TFrmLeaderInspect.FormCreate(Sender: TObject);
begin
  m_dbLeaderInspect := TRsDBLeaderInspect.Create(GlobalDM.LocalADOConnection);
  m_dbTrainman := TRsDBLocalTrainman.Create(GlobalDM.LocalADOConnection);

  dtpStartDate.Date := Now ;
  dtpStartDate.Format := 'yyyy-MM-dd';
  dtpEndDate.Date := Now ;
  dtpEndDate.Format := 'yyyy-MM-dd';

  InitData;
end;

procedure TFrmLeaderInspect.FormDestroy(Sender: TObject);
begin

  m_dbLeaderInspect.Free;
  m_dbTrainman.Free;
end;

procedure TFrmLeaderInspect.InitData;
var
  dtStart:TDateTime ;
  dtEnd:TDateTime ;
begin
  //��ȡ��ʼ�ͽ����Ĳ�ѯʱ��
  dtStart := AssembleDateTime(dtpStartDate.Date,dtpStartTime.Time);
  dtEnd := AssembleDateTime(dtpEndDate.Date,dtpEndTime.Time) ;

  //��ѯ���ݿ�
  SetLength(m_listLeaderInspect,0);
  m_dbLeaderInspect.GetLeaderInspectList(dtStart,dtEnd,m_listLeaderInspect);

  //��ʾ�����
  DataToListView(m_listLeaderInspect);
end;



procedure TFrmLeaderInspect.OnFingerTouching(Sender: TObject);
var
  TrainMan: RRsTrainman;
  Verify: TRsRegisterFlag;
begin
  if TCallRoomFunIF.GetInstance.bFrmCalling then Exit;
  if not TFrmTrainmanIdentityAccess.IdentfityTrainman(Sender,TrainMan,Verify,
    '',
    '',
    '',
    '') then
  begin
    exit;
  end;

  ExcuteInspect(TrainMan,verify)
end;

procedure TFrmLeaderInspect.RefreshData;
begin
  InitData;
  GlobalDM.OnFingerTouching := self.OnFingerTouching;
end;


end.
