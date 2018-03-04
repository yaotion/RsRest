unit ufrmHint;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, pngimage, uTFImage;

type
  TfrmHint = class(TForm)
    TFImage1: TTFImage;
    lblHint: TLabel;
  private
    { Private declarations }
    class var frmHint: TfrmHint;

    procedure ReLocateLable();
  public
    { Public declarations }
    class procedure ShowHint(strHint: string);
    class procedure ShowHintDelay(strHint: string);
    class procedure CloseHint();
    class procedure CloseHintDelay();
  end;

implementation

{$R *.dfm}

class procedure TfrmHint.CloseHint();
begin
  if Assigned(frmHint) then
  begin
    FreeAndNil(frmHint);
  end;
end;

class procedure TfrmHint.CloseHintDelay;
begin
  if Assigned(frmHint) then
  begin
    Sleep(300);
    FreeAndNil(frmHint);
  end;
end;

procedure TfrmHint.ReLocateLable;
var
  nWidth: Integer;
begin
  nWidth := lblHint.Canvas.TextWidth(lblHint.Caption);

  if nWidth > Self.Width then
  begin
    lblHint.Left := 10;
  end
  else
  begin
    lblHint.Left := (Self.Width - nWidth) div 2;
  end;
end;

class procedure TfrmHint.ShowHint(strHint: string);
begin
  if not Assigned(frmHint) then
    frmHint := TfrmHint.Create(nil);

  frmHint.lblHint.Caption := strHint;
  frmHint.ReLocateLable();
  
  if not frmHint.Visible then  
    frmHint.Show;
  frmHint.Update;
  //Application.ProcessMessages();
end;

class procedure TfrmHint.ShowHintDelay(strHint: string);
begin
  ShowHint(strHint);
  Sleep(300);
end;

initialization

finalization
  TfrmHint.CloseHint;
end.
