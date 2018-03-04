unit uFrmJiNingTrainmanEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,utfsystem,uTrainman,uDBLocalTrainman,uDBWorkShop,uWorkShop;

type
  TFrmJiNingTrainmanEdit = class(TForm)
    Label2: TLabel;
    edtTrainmanName: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    cbbJWD: TComboBox;
    lbl5: TLabel;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
      //当前操作的司机信息
    m_Trainman : RRsTrainman;
    //司机数据库操作
    m_DBTrainman : TRsDBLocalTrainman;
    //车间数组
    m_WorkShopAry:TRsWorkShopArray;
    //车间数据库操作
    m_DBWorkShop:TRsDBWorkShop;
  private
    { Private declarations }
    function CheckInput():Boolean;
    procedure InitData();
         {功能:初始化车间}
    procedure InitWorkShop(strWorkShopGUID:string='');
  public
    { Public declarations }
    class function CreateTrainman():Boolean; overload;
    class function CreateTrainman(var Trainman : RRsTrainman):Boolean; overload;
  end;

var
  FrmJiNingTrainmanEdit: TFrmJiNingTrainmanEdit;

implementation

uses
  uSaftyEnum,ufrmQuestionBox,uGlobalDM;

{$R *.dfm}

procedure TFrmJiNingTrainmanEdit.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel ;
end;

procedure TFrmJiNingTrainmanEdit.btnOKClick(Sender: TObject);
var
  strTrainmanName:string;
begin
  if CheckInput() = False then Exit;
  try
    strTrainmanName :=  Trim( edtTrainmanName.Text ) ;
    m_Trainman.strTrainmanGUID := NewGUID;
    m_Trainman.strTrainmanName := Trim( edtTrainmanName.Text );
    m_Trainman.strTrainmanNumber := Trim( edtTrainmanName.Text ) ;
    m_Trainman.strJP := GlobalDM.GetHzPy(strTrainmanName) ;
    m_Trainman.strWorkShopGUID := m_WorkShopAry[cbbJWD.ItemIndex].strWorkShopGUID ;
    m_DBTrainman.AddTrainman(m_Trainman);
    Box('保存人员成功');
  except on e : exception do
    begin
      Box('保存数据失败：' + e.Message);
      exit;
    end;
  end;
  ModalResult := mrOk ;
end;

function TFrmJiNingTrainmanEdit.CheckInput: Boolean;
begin
  Result := False ;
  if Trim(edtTrainmanName.Text) = ''then
  begin
    tfMessageBox('人员名字不能为空');
    exit ;
  end;
  Result := True ;
end;

class function TFrmJiNingTrainmanEdit.CreateTrainman(
  var Trainman: RRsTrainman): Boolean;
var
  strNumber:string;
  frm : TFrmJiNingTrainmanEdit;
begin
  Result := False ;
  frm := TFrmJiNingTrainmanEdit.Create(nil);
  try
    frm.InitData;
    if frm.ShowModal = mrOk then
    begin
      Trainman := frm.m_Trainman ;
      Result := True ;
    end;
  finally
    frm.Free;
  end;
end;

class function TFrmJiNingTrainmanEdit.CreateTrainman: Boolean;
var
  frm : TFrmJiNingTrainmanEdit;
begin
  Result := False ;
  frm := TFrmJiNingTrainmanEdit.Create(nil);
  try
    frm.InitData;
    if frm.ShowModal = mrOk then
      Result := True ;
  finally
    frm.Free;
  end;
end;

procedure TFrmJiNingTrainmanEdit.FormCreate(Sender: TObject);
begin
  m_Trainman.nTrainmanState := tsNil;
  m_DBTrainman := TRsDBLocalTrainman.Create(GlobalDM.LocalADOConnection);
  m_DBWorkShop:=TRsDBWorkShop.Create(GlobalDM.LocalADOConnection);
end;



procedure TFrmJiNingTrainmanEdit.FormDestroy(Sender: TObject);
begin
  m_DBTrainman.Free;
  m_DBWorkShop.Free;
end;

procedure TFrmJiNingTrainmanEdit.InitData;
begin
  InitWorkShop('');
end;

procedure TFrmJiNingTrainmanEdit.InitWorkShop(strWorkShopGUID: string);
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

end.
