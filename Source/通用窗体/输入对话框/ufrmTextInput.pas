unit ufrmTextInput;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,uTFSystem,PerlRegEx, Buttons, PngCustomButton, pngimage,
  ExtCtrls;

type
  TfrmTextInput = class(TForm)
    edtText: TEdit;
    Image1: TImage;
    btnConfirm: TPngCustomButton;
    btnCancel: TPngCustomButton;
    lblCaption: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure btnConfirmClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    reg: TPerlRegEx; //声明正则表达式变量
    m_strNotice:string;//提示字符串
  public
    { Public declarations }
  end;

  {功能:文本输入}
  function TextInput(strTitle,strCaption:String;var strText:String;strNotice:string = '';strRule:string = ''):Boolean;


implementation
uses
  uGlobalDM,utfPopBox;
{$R *.dfm}


function TextInput(strTitle,strCaption:String;var strText:String;strNotice:string = '';strRule:string = ''):Boolean;
{功能:文本输入}
var
  frmTextInput: TfrmTextInput;
begin
  Result := False;
  frmTextInput:= TfrmTextInput.Create(nil);
  try
    frmTextInput.Caption := strTitle;
    frmTextInput.lblCaption.Caption := strCaption;
    frmTextInput.edtText.Text := strText;
    frmTextInput.reg.RegEx := strRule;
    frmTextInput.m_strNotice := strNotice;
    if frmTextInput.ShowModal = mrok then
    begin
      Result := True;
      strText := Trim(frmTextInput.edtText.Text);
    end;
  finally
    frmTextInput.Free;
  end;
end;

procedure TfrmTextInput.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmTextInput.btnConfirmClick(Sender: TObject);
begin
  if Trim(edtText.Text) = '' then
  begin
    TtfPopBox.ShowBox('内容不能为空!');
    Exit;
  end;
  if reg.RegEx <> ''  then
  begin
    reg.Subject := Trim(edtText.Text);
    if reg.Match = False then
    begin
      if m_strNotice = '' then
      begin
        ShowMessage('格式不正确');
      end
      else
      begin
        ShowMessage(m_strNotice);
      end;
      Exit;
    end;
  end;
  ModalResult := mrok;
end;

procedure TfrmTextInput.FormCreate(Sender: TObject);
begin
  reg:= TPerlRegEx.Create; 
end;

procedure TfrmTextInput.FormDestroy(Sender: TObject);
begin
  reg.Free;
end;

end.
