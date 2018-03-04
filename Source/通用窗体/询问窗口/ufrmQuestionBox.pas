unit ufrmQuestionBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, pngimage, StdCtrls, RzPanel, Buttons,PngCustomButton,
  ActnList, PngImageList, uTFImage;
                                                                        
type
  TFrmQuestionBox = class(TForm)
    ActionList1: TActionList;
    ActEnter: TAction;
    ActCancel: TAction;
    ActEnd: TAction;
    btnConfirm: TPngCustomButton;
    lblHint: TLabel;
    imgPicture: TImage;
    ActLeft: TAction;
    ActRight: TAction;
    btnCancel: TPngCustomButton;
    Label1: TLabel;
    PngImageCollection1: TPngImageCollection;
    imgICONBtn: TTFImage;
    procedure ActCancelExecute(Sender: TObject);
    procedure ActEnterExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnConfirmClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ActLeftExecute(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  public
    {功能:显示文本}
    procedure InitLabel(strLabel:String);
    procedure SetButtonType(nButtonType: DWORD);
  end;

function tfMessageBox(const strText : string;
  nButtonType: DWORD=MB_ICONQUESTION): BOOL;

implementation



{$R *.dfm}

function tfMessageBox(const strText : string; nButtonType: DWORD): BOOL;
//功能:询问对话框
var
  FrmQuestionBox: TFrmQuestionBox;
begin
  Result := False ;
  FrmQuestionBox := TFrmQuestionBox.Create(nil);
  try
    FrmQuestionBox.SetButtonType(nButtonType);
    FrmQuestionBox.InitLabel(strText);
    if FrmQuestionBox.ShowModal = mrok then
      Result := True;
  finally
    FrmQuestionBox.Free;
  end;
end;

procedure TFrmQuestionBox.ActCancelExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmQuestionBox.ActEnterExecute(Sender: TObject);
begin
  if btnConfirm.Down then
    ModalResult := mrok
  else
    Close;
end;      

procedure TFrmQuestionBox.ActLeftExecute(Sender: TObject);
begin
  exit ;
  if btnConfirm.Down then
  begin
    btnCancel.Down := True;
    btnCancel.Font.Color := clBlack;
    btnConfirm.Font.Color := clWhite;
  end
  else
  begin
    btnConfirm.Down := True;
    btnConfirm.Font.Color := clBlack;
    btnCancel.Font.Color := clWhite;
  end;
end;

procedure TFrmQuestionBox.btnConfirmClick(Sender: TObject);
begin
  ModalResult := Mrok;
end;


procedure TFrmQuestionBox.FormCreate(Sender: TObject);
begin
  Self.Brush.Style := bsClear ;
end;

procedure TFrmQuestionBox.FormShow(Sender: TObject);
var
  strFileName : String;
begin

  //if m_InteractiveFlag = ifKeyboard then
  begin
//    btnConfirm.GroupIndex := 1;
//    btnCancel.GroupIndex := 1;
    ActLeftExecute(Sender);
  end;
end;

procedure TFrmQuestionBox.InitLabel(strLabel: String);
//功能:初始化标签
begin
  lblHint.Caption := strLabel;
end;

procedure TFrmQuestionBox.SetButtonType(nButtonType: DWORD);
begin
  case nButtonType of
    MB_ICONWARNING :  begin
      imgICONBtn.ImageIndex :=  0 ;
    end;
    MB_ICONINFORMATION: begin
      imgICONBtn.ImageIndex :=  1 ;
    end;
    MB_ICONQUESTION:
    begin
      imgICONBtn.ImageIndex :=  2 ;
    end;
    MB_ICONERROR:
    begin
      imgICONBtn.ImageIndex :=  3 ;
    end;
  end;
//  case nButtonType of
//    MB_YESNO:
//    begin
//      btnConfirm.Caption := '是';
//      btnCancel.Caption := '否';
//    end;
//  end;
end;

procedure TFrmQuestionBox.btnCancelClick(Sender: TObject);
begin
  Close;
end;

end.
