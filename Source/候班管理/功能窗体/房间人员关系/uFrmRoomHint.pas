unit uFrmRoomHint;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,uRoomSign,utfsystem,uBaseDBRoomSign,uDBAccessRoomSign;

type
  TFrmRoomHint = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    lbTrainman: TLabel;
    edtRoomNumber: TEdit;
    btnOk: TButton;
    btnCancel: TButton;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    procedure InitData(BedInfo:RRsBedInfo);
    function CheckInput():Boolean;
  private
    { Private declarations }
    m_dbRoomInfo : TRsBaseDBRoomInfo ;
    m_infoBed:RRsBedInfo;
  public
    { Public declarations }
    class function ChangeBedInfo(var BedInfo:RRsBedInfo):Boolean;
  end;

var
  FrmRoomHint: TFrmRoomHint;

implementation

uses
  uGlobalDM ;

{$R *.dfm}

procedure TFrmRoomHint.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel ;
end;

procedure TFrmRoomHint.btnOkClick(Sender: TObject);
var
  nBedNumber :Integer ;
begin
  if not CheckInput then
    Exit ;

  m_infoBed.strRoomNumber := edtRoomNumber.Text ;
  nBedNumber := m_dbRoomInfo.GetEmptyBedNumber(Trim(edtRoomNumber.Text));
  if nBedNumber = 0 then
  begin
    BoxErr('获取床位错误');
    exit ;
  end;
  m_infoBed.nBedNumber := nBedNumber ;
  ModalResult := mrOk ;
end;

class function TFrmRoomHint.ChangeBedInfo(var BedInfo: RRsBedInfo):Boolean;
var
  frm : TFrmRoomHint;
begin
  Result := False ;
  frm := TFrmRoomHint.Create(nil);
  try
    frm.InitData(BedInfo);
    if mrOk = frm.ShowModal then
    begin
      BedInfo := frm.m_infoBed ;
      Result := True ;
    end;
  finally
    frm.Free ;
  end;
end;

function TFrmRoomHint.CheckInput: Boolean;
var
  strRoomNumber:string;
  nBedNumber:Integer ;
begin
  Result := False ;
  strRoomNumber := Trim(edtRoomNumber.Text) ;
  if strRoomNumber = '' then
  begin
    BoxErr('房间号不能为空');
    Exit ;
  end;
    //检查是否存在
  if not m_dbRoomInfo.IsRoomExist(strRoomNumber) then
  begin
    if TBox('房间号不存在,是否创建?') then
      m_dbRoomInfo.InsertRoom(strRoomNumber)
    else
      Exit ;

    if m_dbRoomInfo.IsRoomFull(strRoomNumber) then
    begin
      BoxErr('房间人员已满,请重设房间号') ;
      Exit ;
    end;
  end;

  Result := True ;
end;

procedure TFrmRoomHint.FormCreate(Sender: TObject);
begin
  m_dbRoomInfo := TRsDBAccessRoomInfo.Create(GlobalDM.LocalADOConnection);
end;

procedure TFrmRoomHint.FormDestroy(Sender: TObject);
begin
  m_dbRoomInfo.Free ;
end;

procedure TFrmRoomHint.InitData(BedInfo: RRsBedInfo);
var
  strText:string;
begin
  m_infoBed := BedInfo ;
  strText := Format('[%s]%s',[BedInfo.strTrainmanNumber,BedInfo.strTrainmanName]);
  lbTrainman.Caption := strText ;

  edtRoomNumber.Text := BedInfo.strRoomNumber ;

end;

end.
