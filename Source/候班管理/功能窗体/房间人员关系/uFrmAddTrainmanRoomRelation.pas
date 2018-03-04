unit uFrmAddTrainmanRoomRelation;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,utfsystem,uTrainman,uWaitWork,uDBWaitWork,uDBLocalTrainman;

type
  TFrmAddTrainmanRoomRelation = class(TForm)
    Label1: TLabel;
    cmbBedNumber: TComboBox;
    Label2: TLabel;
    edtTrainmanNumber: TEdit;
    btnOk: TButton;
    btnCancel: TButton;
    procedure btnCancelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    procedure InitData();
    function CheckInput():Boolean;
  private
    { Private declarations }
    //
    m_dbTrainman :TRsDBLocalTrainman;
    m_bedInfo:RRsBedInfo;
  public
    { Public declarations }
    class function AddBedInfo(var BedInfo:RRsBedInfo):Boolean;
  end;

var
  FrmAddTrainmanRoomRelation: TFrmAddTrainmanRoomRelation;

implementation
uses
  uGlobalDM ;

{$R *.dfm}

class function TFrmAddTrainmanRoomRelation.AddBedInfo(
  var BedInfo: RRsBedInfo): Boolean;
var
  frm : TFrmAddTrainmanRoomRelation ;
begin
  Result := False ;
  frm := TFrmAddTrainmanRoomRelation.Create(nil);
  try
    frm.InitData;
    if mrOk = frm.ShowModal then
    begin
      BedInfo := frm.m_bedInfo ;
      Result := True ;
    end;
  finally
    frm.Free();
  end;
end;

procedure TFrmAddTrainmanRoomRelation.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel ;
end;

procedure TFrmAddTrainmanRoomRelation.btnOkClick(Sender: TObject);
var
  trainman:RRsTrainman ;
begin
  if not CheckInput then
    Exit ;

  if not m_dbTrainman.GetTrainmanByNumber(edtTrainmanNumber.Text,trainman) then
  begin
    BoxErr('不存在该人员!');
    exit;
  end;
  m_bedInfo.strTrainmanGUID := trainman.strTrainmanGUID ;
  m_bedInfo.strTrainmanNumber := trainman.strTrainmanNumber ;
  m_bedInfo.strTrainmanName := trainman.strTrainmanName ;
  m_bedInfo.nBedNumber := cmbBedNumber.ItemIndex + 1 ;
  ModalResult := mrOk ;
end;

function TFrmAddTrainmanRoomRelation.CheckInput: Boolean;
begin
  Result := False ;
  if Trim(edtTrainmanNumber.Text) = '' then
  begin
    BoxErr('工号不能为空');
    Exit;
  end;
  Result := True ;
end;

procedure TFrmAddTrainmanRoomRelation.FormCreate(Sender: TObject);
begin
  m_dbTrainman :=TRsDBLocalTrainman.Create(GlobalDM.LocalADOConnection);
end;

procedure TFrmAddTrainmanRoomRelation.FormDestroy(Sender: TObject);
begin
  m_dbTrainman.Free;
end;

procedure TFrmAddTrainmanRoomRelation.InitData;
begin
  ;
end;

end.
