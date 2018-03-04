unit uFrmSelectTrainman;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, RzPanel, utfLookupEdit,utfPopTypes,
  uTrainman,uDBLocalTrainman, Buttons, PngCustomButton;

type
  TfrmSelectTrainman = class(TForm)
    Label1: TLabel;
    edtTrainman1: TtfLookupEdit;
    RzPanel1: TRzPanel;
    btnOK: TButton;
    btnCancel: TButton;
    RzPanel2: TRzPanel;
    PngCustomButton1: TPngCustomButton;
    lblHint: TLabel;
    btnCreateTrainman: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCreateTrainmanClick(Sender: TObject);
  private
    { Private declarations }
    m_DBTrainman :TRsDBLocalTrainman;
    m_Trainman: RRsTrainman;
    procedure IniColumns(LookupEdit : TtfLookupEdit);
    procedure edtTrainmanChange(Sender: TObject);
    procedure edtTrainman1Selected(SelectedItem: TtfPopupItem;
      SelectedIndex: Integer);
    procedure edtTrainmanNextPage(Sender: TObject);
    procedure edtTrainmanPrevPage(Sender: TObject);
    //设置弹出下拉框数据
     procedure SetPopupData(LookupEdit: TtfLookupEdit; Trainmans: TRsTrainmanArray);
     //设置选定的乘务员
     procedure SetSelected(EdtCtrl : TtfLookupEdit;SelectedItem:TtfPopupItem;
      var Trainman : RRsTrainman);
  public
    { Public declarations }
     //获取机组的乘务员输入情况
    class function GetTrainman(var Trainman: RRsTrainman) : boolean;
  end;

var
  frmSelectTrainman: TfrmSelectTrainman;

implementation
uses
  uGlobalDM,ufrmQuestionBox,uFrmJiNingTrainmanEdit;
{$R *.dfm}

{ TfrmSelectTrainman }

procedure TfrmSelectTrainman.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmSelectTrainman.btnCreateTrainmanClick(Sender: TObject);
var
  vTrainman: RRsTrainman ;
begin
  if TFrmJiNingTrainmanEdit.CreateTrainman(vTrainman) then
  begin
    m_Trainman := vTrainman ;
    //m_Trainman.strTrainmanNumber :=  vTrainman.strTrainmanNumber ;

    edtTrainman1.IsAutoPopup := False ;
    edtTrainman1.OnChange := nil ;
    try
      edtTrainman1.Text := Format('%s%s',[vTrainman.strWorkShopName ,vTrainman.strTrainmanName ]) ;
    finally
      edtTrainman1.OnChange :=  edtTrainmanChange ;
      edtTrainman1.IsAutoPopup := true ;
    end;
    //edtTrainman1.SetFocus;
  end;
  btnOK.SetFocus;
end;

procedure TfrmSelectTrainman.btnOKClick(Sender: TObject);
begin
  if m_Trainman.strTrainmanNumber = '' then
  begin
    tfMessageBox('请选择人员',MB_ICONWARNING);
    exit;
  end;
  ModalResult := mrOk;
end;

procedure TfrmSelectTrainman.edtTrainman1Selected(SelectedItem: TtfPopupItem;
  SelectedIndex: Integer);
begin
  SetSelected(edtTrainman1,selectedItem,m_Trainman);
end;

procedure TfrmSelectTrainman.edtTrainmanChange(Sender: TObject);
var
  edtTrainman: TtfLookupEdit;
  TrainmanArray : TRsTrainmanArray;
  nCount: Integer;
  strWorkShopGUID:string;
begin
  edtTrainman := TtfLookupEdit(Sender);
  with edtTrainman do
  begin
    PopStyle.PageIndex := 1;
    strWorkShopGUID := '' ;

    nCount := m_DBTrainman.GetPopupTrainmans(strWorkShopGUID, Text, PopStyle.PageIndex, TrainmanArray);
    PopStyle.PageCount := nCount div PopStyle.MaxViewCol;
    if nCount mod PopStyle.MaxViewCol > 0 then PopStyle.PageCount := PopStyle.PageCount + 1;
    SetPopupData(edtTrainman, TrainmanArray);
  end;
end;

procedure TfrmSelectTrainman.edtTrainmanNextPage(Sender: TObject);
var
  edtTrainman: TtfLookupEdit;
  TrainmanArray : TRsTrainmanArray;
  strWorkShopGUID :string ;
begin
  edtTrainman := TtfLookupEdit(Sender);
  with edtTrainman do
  begin
    PopStyle.PageIndex := PopStyle.PageIndex + 1;
    strWorkShopGUID := '' ;
    m_DBTrainman.GetPopupTrainmans(strWorkShopGUID, Text, PopStyle.PageIndex, TrainmanArray);
    SetPopupData(edtTrainman, TrainmanArray);
  end;
end;

procedure TfrmSelectTrainman.edtTrainmanPrevPage(Sender: TObject);
var
  edtTrainman: TtfLookupEdit;
  TrainmanArray : TRsTrainmanArray;
  strWorkShopGUID:string;
begin        
  edtTrainman := TtfLookupEdit(Sender);
  with edtTrainman do
  begin
    PopStyle.PageIndex := PopStyle.PageIndex - 1;
    strWorkShopGUID := '' ;
    m_DBTrainman.GetPopupTrainmans(strWorkShopGUID , Text, PopStyle.PageIndex, TrainmanArray);
    SetPopupData(edtTrainman, TrainmanArray);
  end;
end;

procedure TfrmSelectTrainman.FormCreate(Sender: TObject);
begin
  m_DBTrainman  := TRsDBLocalTrainman.Create(GlobalDM.LocalADOConnection);
  IniColumns(edtTrainman1);


  edtTrainman1.OnChange := edtTrainmanChange;
  edtTrainman1.OnPrevPage := edtTrainmanPrevPage;
  edtTrainman1.OnNextPage := edtTrainmanNextPage;

  edtTrainman1.OnSelected := edtTrainman1Selected;

end;

procedure TfrmSelectTrainman.FormDestroy(Sender: TObject);
begin
  m_DBTrainman.Free;
  edtTrainman1.OnChange := nil;

  edtTrainman1.OnSelected := nil;

  edtTrainman1.OnPrevPage := nil;
  edtTrainman1.OnNextPage := nil;

end;

procedure TfrmSelectTrainman.IniColumns(LookupEdit: TtfLookupEdit);
var
  col : TtfColumnItem;
begin
  LookupEdit.Columns.Clear;
  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := '序号';
  col.Width := 40;

  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := '姓名';
  col.Width := 80;

  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := '段号';
  col.Width := 80;
end;

class function TfrmSelectTrainman.GetTrainman(var Trainman: RRsTrainman): boolean;
var
  frmSelectTrainman: TfrmSelectTrainman;
begin
  result := false;
  frmSelectTrainman := TfrmSelectTrainman.Create(nil);
  try
    if frmSelectTrainman.ShowModal <> mrOk then exit;
    if frmSelectTrainman.m_Trainman.strTrainmanNumber <> '' then
    begin
      Trainman := frmSelectTrainman.m_Trainman;
      result := true;
    end;
  finally
    frmSelectTrainman.Free;
  end;
end;

procedure TfrmSelectTrainman.SetPopupData(LookupEdit: TtfLookupEdit;
  Trainmans: TRsTrainmanArray);
var
  item : TtfPopupItem;
  i: Integer;
begin
  LookupEdit.Items.Clear;
  for i := 0 to Length(Trainmans) - 1 do
  begin
    item := TtfPopupItem.Create();
    item.StringValue := Trainmans[i].strTrainmanGUID;
    item.SubItems.Add(Format('%d', [(LookupEdit.PopStyle.PageIndex - 1) * 10 + i + 1]));
    item.SubItems.Add(Trainmans[i].strTrainmanName);
    item.SubItems.Add(Trainmans[i].strWorkShopName);
    LookupEdit.Items.Add(item);
  end;
  LookupEdit.PopStyle.PageInfo := Format('　第 %d 页，共 %d 页', [LookupEdit.PopStyle.PageIndex, LookupEdit.PopStyle.PageCount]);

end;

procedure TfrmSelectTrainman.SetSelected(EdtCtrl: TtfLookupEdit;
  SelectedItem: TtfPopupItem; var Trainman: RRsTrainman);
begin
   EdtCtrl.OnChange := nil;
  try
    m_DBTrainman.GetTrainman(SelectedItem.StringValue,Trainman);
    EdtCtrl.Text := Format('%s[%s]',[SelectedItem.SubItems[2],SelectedItem.SubItems[1]]);
  finally
    EdtCtrl.OnChange := edtTrainmanChange;
  end;
end;

end.
