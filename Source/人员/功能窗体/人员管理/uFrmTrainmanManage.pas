unit uFrmTrainmanManage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, AdvObj, BaseGrid, AdvGrid, RzStatus, RzPanel, PngCustomButton,
  StdCtrls, Mask, RzEdit, RzCmboBx, Buttons, PngSpeedButton, ExtCtrls,
  uGlobalDM,uSaftyEnum,uTrainman,uDBLocalTrainman,utfsystem,
  ComObj,uWorkShop,uGuideGroup,uTrainJiaolu;

type
  TfrmTrainmanManage = class(TForm)
    Panel1: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    btnAppendTrainman: TPngSpeedButton;
    btnModifyTrainman: TPngSpeedButton;
    btnQuery: TPngSpeedButton;
    btnDeleteTrainman: TPngSpeedButton;
    btnImport: TPngSpeedButton;
    btnExport: TPngSpeedButton;
    comboWorkShop: TRzComboBox;
    comboTrainmanJiaolu: TRzComboBox;
    comboGuideGroup: TRzComboBox;
    edtTrainmanNumber: TRzEdit;
    edtTrainmanName: TRzEdit;
    comboPhoto: TRzComboBox;
    comboFingerCount: TRzComboBox;
    RzPanel2: TRzPanel;
    PngCustomButton1: TPngCustomButton;
    Label1: TLabel;
    RzStatusBar1: TRzStatusBar;
    statusSum: TRzStatusPane;
    RzPanel1: TRzPanel;
    strGridTrainman: TAdvStringGrid;
    OpenDialog1: TOpenDialog;
    procedure btnQueryClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnAppendTrainmanClick(Sender: TObject);
    procedure btnModifyTrainmanClick(Sender: TObject);
    procedure btnDeleteTrainmanClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure comboWorkShopChange(Sender: TObject);
    procedure edtTrainmanNumberKeyPress(Sender: TObject; var Key: Char);
  private
    /// <summary>�Ƿ�Ϊ���ҳ���Ա�Ĵ���</summary>
    m_bIsQueryForm:Boolean;
    /// <summary>��ǰѡ�е���Ա</summary>
    m_SelectTrainMan:RRsTrainman;
    //��Ա���ݿ����
    m_DBTrainman :TRsDBLocalTrainman;
    //�������ݿ����
    //m_DBWorkShop : TRsDBWorkShop;
    //ָ�������ݿ����
    //m_DBGuideGroup : TRsDBGuideGroup;
    //�г��������ݿ����
    //m_DBTrainJiaolu : TRsDBTrainJiaolu;
    //��Ա�б�    
    m_TrainmanArray : TRsTrainmanArray;
    //��ʼ������
    procedure Init;
    //��ѯ����Ա��Ϣ
    procedure QueryTrainmans;
    //������Ա��Ϣ
    procedure ExportTrainmans;
    //������Ա��Ϣ
    procedure ImportTrainmans;
    procedure InitTrainJiaoLu();
    procedure InitGuideGroup();
  public
    //�򿪳���Ա��ѯ����
    class procedure OpenTrainmanQuery(bQuery:Boolean = False);
    property bIsQueryForm:Boolean read m_bIsQueryForm write m_bIsQueryForm;
    property SelectTrainMan:RRsTrainman read m_SelectTrainMan;
  end;

var
  frmTrainmanManage: TfrmTrainmanManage;

implementation

uses
  uFrmProgressEx , utfPopBox,ufrmQuestionBox ,
  ufrmUserInfoEdit;

{$R *.dfm}

procedure TfrmTrainmanManage.btnAppendTrainmanClick(Sender: TObject);
begin
  if not TfrmUserInfoEdit.AppendTrainmanInfo then
  begin
    exit;
  end;
  btnQuery.Click;
end;

procedure TfrmTrainmanManage.btnDeleteTrainmanClick(Sender: TObject);
var
  strTrainmanGUID : string;
begin
  if length(m_TrainmanArray) = 0 then
  begin
    Application.MessageBox('û�пɲ�����˾��','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if (strGridTrainman.Row = 0) or (strGridTrainman.Row = length(m_TrainmanArray)) then
    exit;
  if Application.MessageBox('��ȷ��Ҫɾ��ѡ�е�˾����','��ʾ',MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then exit;
  
  strTrainmanGUID := strGridTrainman.Cells[99,strGridTrainman.Row];

  try
    m_DBTrainman.DeleteTrainman(strTrainmanGUID);
    btnQuery.Click;
    exit;
  except on e : exception do
    begin
      TtfPopBox.ShowBox('ɾ��ʧ�ܣ�' + e.Message);
    end;
  end;
end;

procedure TfrmTrainmanManage.btnExportClick(Sender: TObject);
begin
  ExportTrainmans;
end;

procedure TfrmTrainmanManage.btnImportClick(Sender: TObject);
begin
  ImportTrainmans;
end;

procedure TfrmTrainmanManage.btnModifyTrainmanClick(Sender: TObject);
var
  strTrainmanGUID : string;
begin
    if length(m_TrainmanArray) = 0 then
  begin
    Application.MessageBox('û�пɲ�����˾��','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if (strGridTrainman.Row = 0) then
    exit;

  if (strGridTrainman.Row > length(m_TrainmanArray))  then
    Exit;
  
  
  strTrainmanGUID := strGridTrainman.Cells[99,strGridTrainman.Row];
  if not TfrmUserInfoEdit.ModifyTrainmanInfo(strTrainmanGUID) then
  begin
    exit;
  end;
  btnQuery.Click;
end;

procedure TfrmTrainmanManage.btnQueryClick(Sender: TObject);
begin
  QueryTrainmans;
end;

procedure TfrmTrainmanManage.comboWorkShopChange(Sender: TObject);
begin
  Exit ;
  InitGuideGroup();
  InitTrainJiaoLu();
end;

procedure TfrmTrainmanManage.edtTrainmanNumberKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #13 then
    btnQueryClick(nil);
end;

procedure TfrmTrainmanManage.ExportTrainmans;
var
  excelFile,trainmanGUID : string;
  excelApp,workBook,workSheet: Variant;
  m_nIndex : integer;
  trainman : RRsTrainman;
  i: Integer;
  strFinger2 :string;
begin
  if length(m_TrainmanArray) = 0 then
  begin
    TtfPopBox.ShowBox('���Ȳ�ѯ����Ҫ������˾����Ϣ��');
    exit;
  end;
  if not GlobalDM.FingerprintInitSuccess then
  begin
    if not tfMessageBox('��ǰָ����δ�ɹ����ӣ����޷�����˾��ָ����Ϣ������Ҫ������') then exit;
  end;
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

    excelApp.Cells[m_nIndex,1].Value := '��������';
    excelApp.Cells[m_nIndex,2].Value := '��������';
    excelApp.Cells[m_nIndex,3].Value := 'ָ����';
    excelApp.Cells[m_nIndex,4].Value := '����';
    excelApp.Cells[m_nIndex,5].Value := '����';

    excelApp.Cells[m_nIndex,6].Value := 'ְλ';
    excelApp.Cells[m_nIndex,7].Value := '˾���ȼ�';
    excelApp.Cells[m_nIndex,8].Value := '��ʻ����';
    excelApp.Cells[m_nIndex,9].Value := '�ͻ�';
    excelApp.Cells[m_nIndex,10].Value := '�ؼ���';
    excelApp.Cells[m_nIndex,11].Value := 'ABCD';
    excelApp.Cells[m_nIndex,12].Value := '�绰';
    excelApp.Cells[m_nIndex,13].Value := '�ֻ�';
    excelApp.Cells[m_nIndex,14].Value := '��ַ';
    excelApp.Cells[m_nIndex,15].Value := '��ְ����';
    excelApp.Cells[m_nIndex,16].Value := '��ְ����';

    excelApp.Cells[m_nIndex,17].Value := 'ָ��1';
    excelApp.Cells[m_nIndex,18].Value := 'ָ��2';
    
    Inc(m_nIndex);
    for i := 0 to Length(m_TrainmanArray) - 1 do
    begin
      trainmanGUID :=  m_TrainmanArray[i].strTrainmanGUID;
      m_DBTrainman.GetTrainman(trainmanGUID,trainman);
      if trainman.strTrainmanGUID <> '' then
      begin
        excelApp.Cells[m_nIndex,1].Value := trainman.strWorkShopName;
        excelApp.Cells[m_nIndex,2].Value := trainman.strTrainJiaoluName;
        excelApp.Cells[m_nIndex,3].Value := trainman.strGuideGroupName;
        excelApp.Cells[m_nIndex,4].Value := trainman.strTrainmanNumber;
        excelApp.Cells[m_nIndex,5].Value := trainman.strTrainmanName;

        excelApp.Cells[m_nIndex,6].Value := TRsPostNameAry[trainman.nPostID];
        excelApp.Cells[m_nIndex,7].Value := IntToStr(trainman.nDriverLevel);
        excelApp.Cells[m_nIndex,8].Value := TRsDriverTypeNameArray[trainman.nDriverType];
        excelApp.Cells[m_nIndex,9].Value := TRsKeHuoNameArray[trainman.nKeHuoID];
        excelApp.Cells[m_nIndex,10].Value := '';
        if trainman.bIsKey > 0 then
          excelApp.Cells[m_nIndex,10].Value := '��';
        excelApp.Cells[m_nIndex,11].Value := trainman.strABCD;
        excelApp.Cells[m_nIndex,12].Value := trainman.strTelNumber;
        excelApp.Cells[m_nIndex,13].Value := trainman.strMobileNumber;
        excelApp.Cells[m_nIndex,14].Value := trainman.strAdddress;
        excelApp.Cells[m_nIndex,15].Value := FormatDateTime('yyyy-MM-dd',trainman.dtRuZhiTime);
        excelApp.Cells[m_nIndex,16].Value := FormatDateTime('yyyy-MM-dd',trainman.dtJiuZhiTime);
        if GlobalDM.FingerprintInitSuccess then
        begin
          if not (VarIsEmpty(trainman.FingerPrint1) or VarIsNull(trainman.FingerPrint1)) then
          begin
            strFinger2 := GlobalDM.ZKFPEngX.EncodeTemplate1(trainman.FingerPrint1);
            excelApp.Cells[m_nIndex,17].Value := strFinger2;
          end;
          if not (VarIsEmpty(trainman.FingerPrint2) or VarIsNull(trainman.FingerPrint2)) then
          begin
            strFinger2 := GlobalDM.ZKFPEngX.EncodeTemplate1(trainman.FingerPrint2);
            excelApp.Cells[m_nIndex,18].Value := strFinger2;
          end;
        end;
      end;
      TfrmProgressEx.ShowProgress('���ڵ���˾����Ϣ�����Ժ�',i + 1,length(m_TrainmanArray));
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

procedure TfrmTrainmanManage.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  action := caFree;
  frmTrainmanManage := nil;
end;

procedure TfrmTrainmanManage.FormCreate(Sender: TObject);
begin
  m_bIsQueryForm := False;

  m_DBTrainman := TRsDBLocalTrainman.Create(GlobalDM.LocalADOConnection);
  {
  //�������ݿ����
  m_DBWorkShop := TRsDBWorkShop.Create(GlobalDM.ADOConnection);
  //ָ�������ݿ����
  m_DBGuideGroup := TRsDBGuideGroup.Create(GlobalDM.ADOConnection);
  //�г�����
  m_DBTrainJiaolu := TRsDBTrainJiaolu.Create(GlobalDM.ADOConnection);
  }
end;

procedure TfrmTrainmanManage.FormDestroy(Sender: TObject);
begin
  m_DBTrainman.Free;
  {
  //�������ݿ����
  m_DBWorkShop.Free;
  //ָ�������ݿ����
  m_DBGuideGroup.Free;
  //�г�����
  m_DBTrainJiaolu.Free;
  }
end;

procedure TfrmTrainmanManage.FormShow(Sender: TObject);
begin
  FillChar(m_SelectTrainMan,SizeOf(m_SelectTrainMan),0);
  m_SelectTrainMan.strTrainmanGUID := '';
  btnAppendTrainman.Visible := not m_bIsQueryForm;
  btnModifyTrainman.Visible := not m_bIsQueryForm;
  btnDeleteTrainman.Visible := not m_bIsQueryForm;
  btnImport.Visible := not m_bIsQueryForm;
end;

procedure TfrmTrainmanManage.ImportTrainmans;
var
  excelApp: Variant;
  nIndex,nTotalCount : integer;
  strTrainmanNumber :string;
  trainman : RRsTrainman;
  strFinger2 : string;
  kehuo : TRsKehuo;
  post : TRsPost;
  driverType : TRsDriverType;
begin
  if not GlobalDM.FingerprintInitSuccess then
  begin
    if not tfMessageBox('��ǰָ����δ�ɹ����ӣ����޷�����˾��ָ����Ϣ������Ҫ������') then exit;
  end;

  if not OpenDialog1.Execute then exit;
  try
    excelApp := CreateOleObject('Excel.Application');
  except
    Application.MessageBox('�㻹û�а�װMicrosoft Excel,���Ȱ�װ��','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  
  try
    excelApp.Visible := false;
    excelApp.Caption := 'Ӧ�ó������ Microsoft Excel';
    excelApp.workBooks.Open(OpenDialog1.FileName);
    excelApp.Worksheets[1].activate;
    nIndex := 2;
    nTotalCount := 0;
    while true do
    begin
      strTrainmanNumber := excelApp.Cells[nIndex,4].Value;
      if strTrainmanNumber = '' then break;
      Inc(nTotalCount);
      Inc(nIndex);
    end;
    if nTotalCount = 0 then
    begin
       Application.MessageBox('û�пɵ���ĳ���Ա��Ϣ��','��ʾ',MB_OK + MB_ICONINFORMATION);
       exit;
    end;
    nIndex := 2;

    for nIndex := 2 to nTotalCount + 1 do      
    begin
      trainman.strTrainmanGUID := NewGUID;

      trainman.nTrainmanState := tsNil;
      trainman.dtCreateTime := GlobalDM.GetNow;
      trainman.strWorkShopGUID := '';
      trainman.strTrainJiaoluGUID := '' ;
      trainman.strGuideGroupGUID := '' ;

      trainman.strTrainmanNumber := excelApp.Cells[nIndex,4].Value;
      trainman.strTrainmanName := excelApp.Cells[nIndex,5].Value;

      for post := low(TRsPost) to high(TRsPost) do
      begin
        if TRsPostNameAry[post] = excelApp.Cells[nIndex,6].Value then
          trainman.nPostID := post;        
      end;
      trainman.nDriverLevel := StrToInt(excelApp.Cells[nIndex,7].Value);

      for driverType := low(TRsDriverType) to high(TRsDriverType) do
      begin
        if TRsDriverTypeNameArray[driverType] =  excelApp.Cells[nIndex,8].Value then
           trainman.nDriverType := driverType;
      end;
      
      for kehuo := low(TRsKehuo) to high(TRsKehuo) do
      begin
        if TRsKeHuoNameArray[kehuo] = excelApp.Cells[nIndex,9].Value then
          trainman.nKeHuoID := kehuo;
      end;

      trainman.bIsKey  := 0;
      if excelApp.Cells[nIndex,10].Value <> '' then
        trainman.bIsKey := 1;
      trainman.strABCD := excelApp.Cells[nIndex,11].Value;
      trainman.strTelNumber := excelApp.Cells[nIndex,12].Value;
      trainman.strMobileNumber := excelApp.Cells[nIndex,13].Value;
      trainman.strAdddress := excelApp.Cells[nIndex,14].Value;
      trainman.dtRuZhiTime := StrToDate(excelApp.Cells[nIndex,15].Value);
      trainman.dtJiuZhiTime := StrToDate(excelApp.Cells[nIndex,16].Value);
      if GlobalDM.FingerprintInitSuccess then
      begin
        if not (VarIsEmpty(trainman.FingerPrint1) or VarIsNull(trainman.FingerPrint1)) then
        begin
          strFinger2 := GlobalDM.ZKFPEngX.EncodeTemplate1(trainman.FingerPrint1);
          excelApp.Cells[nIndex,17].Value := strFinger2;
        end;
        if not (VarIsEmpty(trainman.FingerPrint2) or VarIsNull(trainman.FingerPrint2)) then
        begin
          strFinger2 := GlobalDM.ZKFPEngX.EncodeTemplate1(trainman.FingerPrint2);
          excelApp.Cells[nIndex,18].Value := strFinger2;
        end;
      end;
      trainman.strJP := GlobalDM.GetHzPy(trainman.strTrainmanName);
      if not m_DBTrainman.ExistNumber('',trainman.strTrainmanNumber) then
        m_DBTrainman.AddTrainman(trainman);
      TfrmProgressEx.ShowProgress('���ڵ���˾����Ϣ�����Ժ�',nIndex - 1,nTotalCount);
    end;
  finally
    TfrmProgressEx.CloseProgress;
    excelApp.Quit;
    excelApp := Unassigned;
  end;
  Application.MessageBox('������ϣ�','��ʾ',MB_OK + MB_ICONINFORMATION);
end;

procedure TfrmTrainmanManage.Init;
var
  i : integer;
  workshopArray : TRsWorkShopArray;
begin
  Exit ;
  //m_DBWorkShop.GetWorkShopOfArea(GlobalDM.SiteInfo.strAreaGUID,workshopArray);
  comboWorkShop.Items.Clear;
  comboWorkShop.Values.Clear;
  comboWorkShop.AddItemValue('ȫ������','');
  for i := 0 to length(workshopArray) - 1 do
  begin
    comboWorkShop.AddItemValue(workshopArray[i].strWorkShopName,workshopArray[i].strWorkShopGUID);
  end;
  comboWorkShop.ItemIndex := comboWorkShop.Values.IndexOf(GlobalDM.SiteInfo.WorkShopGUID);
  InitGuideGroup();
  InitTrainJiaoLu();
end;

procedure TfrmTrainmanManage.InitGuideGroup;
var
  guideGroupArray : TRsGuideGroupArray;
  i: Integer;
  workShopGUID : string;
begin
  Exit ;
  comboGuideGroup.Items.Clear;
  comboGuideGroup.Values.Clear;
  comboGuideGroup.AddItemValue('ȫ��ָ����','');
  comboGuideGroup.ItemIndex := 0;

  workShopGUID := comboWorkShop.Values[comboWorkShop.ItemIndex];
  if workShopGUID <> '' then
  begin
    //���ָ������Ϣ
    //m_DBGuideGroup.GetGuideGroupOfWorkShop(workShopGUID,guideGroupArray);
    for i := 0 to length(guideGroupArray) - 1 do
    begin
      comboGuideGroup.AddItemValue(guideGroupArray[i].strGuideGroupName,
          guideGroupArray[i].strGuideGroupGUID);
    end;
  end;
end;

procedure TfrmTrainmanManage.InitTrainJiaoLu;
var
  trainJiaoluArray : TRsTrainJiaoluArray;
  i: Integer;
  workShopGUID : string;
begin
  Exit ;
  comboTrainmanJiaolu.Items.Clear;
  comboTrainmanJiaolu.Values.Clear;
  comboTrainmanJiaolu.AddItemValue('ȫ������','');
  comboTrainmanJiaolu.ItemIndex := 0;

  workShopGUID := comboWorkShop.Values[comboWorkShop.ItemIndex];
  if workShopGUID <> '' then
  begin
    //���������Ϣ
    //m_DBTrainJiaolu.GetTrainJiaoluArrayOfWorkShop(workShopGUID,trainJiaoluArray);
    for i := 0 to length(trainJiaoluArray) - 1 do
    begin
      comboTrainmanJiaolu.AddItemValue(trainJiaoluArray[i].strTrainJiaoluName,
          trainJiaoluArray[i].strTrainJiaoluGUID);
    end;
  end;
end;

class procedure TfrmTrainmanManage.OpenTrainmanQuery(bQuery:Boolean = False);
begin
  if frmTrainmanManage = nil then
  begin
    frmTrainmanManage :=  TfrmTrainmanManage.Create(nil);
    frmTrainmanManage.bIsQueryForm := bQuery;
    frmTrainmanManage.Init;
    frmTrainmanManage.Show;
  end
  else
  begin
    frmTrainmanManage.bIsQueryForm := bQuery;
    frmTrainmanManage.Show;
    frmTrainmanManage.WindowState := wsMaximized;
  end;
end;

procedure TfrmTrainmanManage.QueryTrainmans;
var
  QueryTrainman : RRsQueryTrainman;
  i: Integer;
  strTemp : string;
begin
  //��ǰ��ѯ�������0��
  QueryTrainman.strTrainmanNumber := Trim(edtTrainmanNumber.Text);
  QueryTrainman.strTrainmanName := Trim(edtTrainmanName.Text);

  {
  QueryTrainman.strWorkShopGUID := comboWorkShop.Values[comboWorkShop.ItemIndex];
  QueryTrainman.strTrainJiaoluGUID := comboTrainmanJiaolu.Values[comboTrainmanJiaolu.ItemIndex];
  QueryTrainman.strGuideGroupGUID := comboGuideGroup.Values[comboGuideGroup.ItemIndex];
  }

  QueryTrainman.strWorkShopGUID := '';
  QueryTrainman.strTrainJiaoluGUID := '';
  QueryTrainman.strGuideGroupGUID := '';

  QueryTrainman.nFingerCount := comboFingerCount.ItemIndex - 1;
  QueryTrainman.nPhotoCount := comboPhoto.ItemIndex - 1;
  strGridTrainman.BeginUpdate;
  try
    try
      m_DBTrainman.QueryTrainmans(QueryTrainman,m_TrainmanArray);
      statusSum.Caption := Format('��ǰ��ѯ�������%d�ˣ�',[length(m_TrainmanArray)]);
      strGridTrainman.ClearRows(1,9999);
      if length(m_TrainmanArray) = 0  then
        strGridTrainman.RowCount := 2
      else
        strGridTrainman.RowCount := Length(m_TrainmanArray) + 1;
      for i := 0 to Length(m_TrainmanArray) - 1 do
      begin
        with strGridTrainman do
        begin
          Cells[0,i + 1] := IntToStr(i+1);
          Cells[1,i + 1] := m_TrainmanArray[i].strWorkShopName;
          Cells[2,i + 1] := m_TrainmanArray[i].strTrainJiaoluName;
          Cells[3,i + 1] := m_TrainmanArray[i].strGuideGroupName;
          Cells[4,i + 1] := m_TrainmanArray[i].strTrainmanName;
          Cells[5,i + 1] := m_TrainmanArray[i].strTrainmanNumber;
          Cells[6,i + 1] := TRsPostNameAry[m_TrainmanArray[i].nPostID];
          Cells[7,i + 1] := TRsDriverTypeNameArray[m_TrainmanArray[i].nDriverType];
          Cells[8,i + 1] := TRsKeHuoNameArray[m_TrainmanArray[i].nKeHuoID];
          strTemp := '';
          if m_TrainmanArray[i].bIsKey <> 0 then
            strTemp := '��';
          Cells[9,i + 1] := IntToStr(i+1);
          Cells[10,i + 1] := m_TrainmanArray[i].strABCD;
          Cells[11,i + 1] := m_TrainmanArray[i].strTelNumber;
          Cells[12,i + 1] := m_TrainmanArray[i].strMobileNumber;
          Cells[13,i + 1] := m_TrainmanArray[i].strAdddress;
          Cells[14,i + 1] := TRsTrainmanStateNameAry[m_TrainmanArray[i].nTrainmanState];
          Cells[15,i + 1] := FormatDateTime('yy-MM-dd',m_TrainmanArray[i].dtRuZhiTime);
          Cells[16,i + 1] := FormatDateTime('yy-MM-dd',m_TrainmanArray[i].dtJiuZhiTime);
          strTemp := '��';
          if (VarIsNull(m_TrainmanArray[i].FingerPrint1) or VarIsEmpty(m_TrainmanArray[i].FingerPrint1)) then
            strTemp := '��';
          Cells[17,i + 1] := strTemp;
          if (VarIsNull(m_TrainmanArray[i].FingerPrint2) or VarIsEmpty(m_TrainmanArray[i].FingerPrint2)) then
            strTemp := '��';
          Cells[18,i + 1] := strTemp;
          if (VarIsNull(m_TrainmanArray[i].Picture) or VarIsEmpty(m_TrainmanArray[i].Picture)) then
            strTemp := '��';
          Cells[19,i + 1] := strTemp;
          Cells[99,i + 1] := m_TrainmanArray[i].strTrainmanGUID;

        end;
      end;
    except on e : exception do
      begin
        TtfPopBox.ShowBox('��ѯʧ�ܣ�' + e.Message);
      end;
    end;
  finally
    strGridTrainman.EndUpdate;
  end;
end;

end.
