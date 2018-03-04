unit uFrmSelectTrainman2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, RzPanel, utfLookupEdit,utfPopTypes,
  uTrainman,uDBLocalTrainman, Buttons, PngCustomButton,uDBWorkShop,uWorkShop;

type
  TfrmSelectTrainman2 = class(TForm)
    Label1: TLabel;
    edtTrainman1: TtfLookupEdit;
    RzPanel1: TRzPanel;
    btnOK: TButton;
    btnCancel: TButton;
    RzPanel2: TRzPanel;
    PngCustomButton1: TPngCustomButton;
    lblHint: TLabel;
    lbl5: TLabel;
    cbbJWD: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    m_DBTrainman :TRsDBLocalTrainman;
    m_Trainman: RRsTrainman;

        //车间数组
    m_WorkShopAry:TRsWorkShopArray;
    //车间数据库操作
    m_DBWorkShop:TRsDBWorkShop;
  private
    procedure InitWorkShop(strWorkShopGUID:string='');
    function CheckInput():Boolean;
    procedure InitData();
    function AddTrainman():boolean;
  private

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
  frmSelectTrainman2: TfrmSelectTrainman2;

implementation
uses
  uGlobalDM,ufrmQuestionBox,uSaftyEnum,uTFSystem,uFrmJiNingTrainmanEdit;
{$R *.dfm}

{ TfrmSelectTrainman }

function TfrmSelectTrainman2.AddTrainman():boolean;
var
  strTrainmanName:string;
begin
  Result := False ;
  try
    strTrainmanName :=  Trim( edtTrainman1.Text ) ;
    m_Trainman.strTrainmanGUID := NewGUID;
    m_Trainman.nTrainmanState :=   tsNormal ;
    m_Trainman.strTrainmanName := Trim( edtTrainman1.Text );
    m_Trainman.strTrainmanNumber := Trim( edtTrainman1.Text ) ;
    m_Trainman.strJP := GlobalDM.GetHzPy(strTrainmanName) ;
    m_Trainman.strWorkShopGUID := m_WorkShopAry[cbbJWD.ItemIndex].strWorkShopGUID ;
    m_DBTrainman.AddTrainman(m_Trainman);
    Result := True ;
  except on e : exception do
    begin
      Box('保存人员失败：' + e.Message);
      exit;
    end;
  end;
end;

procedure TfrmSelectTrainman2.btnCancelClick(Sender: TObject);
begin
  Close;
end;



procedure TfrmSelectTrainman2.btnOKClick(Sender: TObject);
begin
  //检查是否为空
  if not CheckInput then
    Exit ;


  //如果人员不存在则创建人员
  if m_Trainman.strTrainmanNumber = '' then
  begin
    if not AddTrainman then exit ;
  end;

  ModalResult := mrOk;
end;

function TfrmSelectTrainman2.CheckInput: Boolean;
begin
  Result := False ;
  //检查人员是否为空
  if Trim(edtTrainman1.Text) = ''then
  begin
    tfMessageBox('人员名字不能为空');
    exit ;
  end;
  //检查是否选中人员

  if m_Trainman.strTrainmanNumber = '' then
  begin
    //如果没有选中人员，则检查一下EDIT是否可以
    if m_DBTrainman.ExistTrainman(m_WorkShopAry[cbbJWD.ItemIndex].strWorkShopGUID,edtTrainman1.Text,m_Trainman) then
    begin
       edtTrainman1.OnChange := nil;
      try
        edtTrainman1.Text := Format('%s[%s]',[m_Trainman.strWorkShopName,m_Trainman.strTrainmanName]);
      finally
        edtTrainman1.OnChange := edtTrainmanChange;
      end;
    end;
  end;
  Result := True ;
end;

procedure TfrmSelectTrainman2.edtTrainman1Selected(SelectedItem: TtfPopupItem;
  SelectedIndex: Integer);
begin
  SetSelected(edtTrainman1,selectedItem,m_Trainman);
end;

procedure TfrmSelectTrainman2.edtTrainmanChange(Sender: TObject);
var
  edtTrainman: TtfLookupEdit;
  TrainmanArray : TRsTrainmanArray;
  nCount: Integer;
  strWorkShopGUID:string;
begin
  edtTrainman := TtfLookupEdit(Sender);
  FillChar(m_Trainman,SizeOf(RRstrainman),0);
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

procedure TfrmSelectTrainman2.edtTrainmanNextPage(Sender: TObject);
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

procedure TfrmSelectTrainman2.edtTrainmanPrevPage(Sender: TObject);
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

procedure TfrmSelectTrainman2.FormCreate(Sender: TObject);
begin
  m_DBTrainman  := TRsDBLocalTrainman.Create(GlobalDM.LocalADOConnection);
  m_DBWorkShop := TRsDBWorkShop.Create(GlobalDM.LocalADOConnection);
  InitData();
  IniColumns(edtTrainman1);


  edtTrainman1.OnChange := edtTrainmanChange;
  edtTrainman1.OnPrevPage := edtTrainmanPrevPage;
  edtTrainman1.OnNextPage := edtTrainmanNextPage;

  edtTrainman1.OnSelected := edtTrainman1Selected;

end;

procedure TfrmSelectTrainman2.FormDestroy(Sender: TObject);
begin
  m_DBWorkShop.Free;
  m_DBTrainman.Free;
  edtTrainman1.OnChange := nil;

  edtTrainman1.OnSelected := nil;

  edtTrainman1.OnPrevPage := nil;
  edtTrainman1.OnNextPage := nil;

end;

procedure TfrmSelectTrainman2.IniColumns(LookupEdit: TtfLookupEdit);
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

procedure TfrmSelectTrainman2.InitData;
begin
  InitWorkShop('');
end;

procedure TfrmSelectTrainman2.InitWorkShop(strWorkShopGUID: string);
var
  i:Integer;
begin
  m_DBWorkShop.GetAllWorkShop( m_WorkShopAry);
  cbbJWD.Items.Clear;
  for i := 0 to Length(m_WorkShopAry) - 1 do
  begin
    cbbJWD.Items.Add(m_WorkShopAry[i].strWorkShopName) ;
    if m_WorkShopAry[i].strWorkShopGUID = strWorkShopGUID then
      cbbJWD.ItemIndex := i;
  end;
  cbbJWD.ItemIndex := 0 ;
end;

class function TfrmSelectTrainman2.GetTrainman(var Trainman: RRsTrainman): boolean;
var
  frmSelectTrainman2: TfrmSelectTrainman2;
begin
  result := false;
  frmSelectTrainman2 := TfrmSelectTrainman2.Create(nil);
  try
    if frmSelectTrainman2.ShowModal <> mrOk then exit;
    if frmSelectTrainman2.m_Trainman.strTrainmanNumber <> '' then
    begin
      Trainman := frmSelectTrainman2.m_Trainman;
      result := true;
    end;
  finally
    frmSelectTrainman2.Free;
  end;
end;

procedure TfrmSelectTrainman2.SetPopupData(LookupEdit: TtfLookupEdit;
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

procedure TfrmSelectTrainman2.SetSelected(EdtCtrl: TtfLookupEdit;
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
