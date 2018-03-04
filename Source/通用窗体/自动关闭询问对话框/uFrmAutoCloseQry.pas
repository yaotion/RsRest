unit uFrmAutoCloseQry;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFrmAutoCloseQry = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    mmo1: TMemo;
    tmr1: TTimer;
    procedure FormShow(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    //提示信息
    m_strMsg:string;
    //自动关闭用时
    m_nAutoCloseSecond:Integer;
    //默认值
    m_bDesaultValue:Boolean;
  public
    class function Box(strMsg:string;nSecond:Integer;m_bDesaultValue :Boolean):Boolean;
  end;




implementation

{$R *.dfm}

{ TFrmAutoCloseQry }

class function TFrmAutoCloseQry.Box(strMsg:string;nSecond:Integer;m_bDesaultValue :Boolean):Boolean;
var
  FrmAutoCloseQry: TFrmAutoCloseQry;
begin
  result := False;
  FrmAutoCloseQry := TFrmAutoCloseQry.Create(nil);
  try
    FrmAutoCloseQry.m_strMsg := strMsg;
    FrmAutoCloseQry.m_nAutoCloseSecond := nSecond;
    FrmAutoCloseQry.m_bDesaultValue := m_bDesaultValue;
    if FrmAutoCloseQry.ShowModal = mrOk then
      result := True;
  finally
    FrmAutoCloseQry.Free ;
  end;
end;

procedure TFrmAutoCloseQry.btnCancelClick(Sender: TObject);
begin
  self.ModalResult := mrCancel;
end;

procedure TFrmAutoCloseQry.btnOkClick(Sender: TObject);
begin
  Self.ModalResult := mrOk;
end;

procedure TFrmAutoCloseQry.FormShow(Sender: TObject);
begin
  mmo1.Text := m_strMsg;
  btnCancel.Caption := Format('否(%d)',[m_nAutoCloseSecond]);
end;

procedure TFrmAutoCloseQry.tmr1Timer(Sender: TObject);
begin
  inc(m_nAutoCloseSecond,-1);
  if m_nAutoCloseSecond <= 0 then
  begin
    if m_bDesaultValue = True then
      self.ModalResult:= mrOk
    else
      self.ModalResult := mrCancel;
  end;
  btnCancel.Caption := Format('否(%d)',[m_nAutoCloseSecond]);
end;

end.
