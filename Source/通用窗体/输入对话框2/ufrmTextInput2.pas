unit ufrmTextInput2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,uTFSystem, Buttons, PngCustomButton, pngimage,
  ExtCtrls;

type
  TfrmTextInput2 = class(TForm)
    edtText: TEdit;
    Image1: TImage;
    btnConfirm: TPngCustomButton;
    btnCancel: TPngCustomButton;
    lblCaption: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure btnConfirmClick(Sender: TObject);
  public
    { Public declarations }
  end;

  {功能:文本输入}
  function InputText(strTitle,strCaption:String;var strText:String):Boolean;


implementation
uses
  uGlobalDM,utfPopBox;
{$R *.dfm}


function InputText(strTitle,strCaption:String;var strText:String):Boolean;
{功能:文本输入}
var
  frmTextInput2: TfrmTextInput2;
begin
  Result := False;
  frmTextInput2:= TfrmTextInput2.Create(nil);
  try
    frmTextInput2.Caption := strTitle;
    frmTextInput2.lblCaption.Caption := strCaption;
    frmTextInput2.edtText.Text := strText;
    if frmTextInput2.ShowModal = mrok then
    begin
      Result := True;
      strText := Trim(frmTextInput2.edtText.Text);
    end;
  finally
    frmTextInput2.Free;
  end;
end;

procedure TfrmTextInput2.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmTextInput2.btnConfirmClick(Sender: TObject);
begin
  ModalResult := mrok;
end;

end.
