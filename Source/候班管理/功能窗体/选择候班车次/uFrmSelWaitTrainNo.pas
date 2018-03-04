unit uFrmSelWaitTrainNo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzLabel;

type
  TFrmSelWaitTrainNo = class(TForm)
    lbl2: TRzLabel;
    cbbTrainNo: TComboBox;
    btnOK: TButton;
    btnCancel: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    //车次列表
    m_strTrainNoList:TStringList;
    //所选车次
    m_selTrainNo:string;
  public
    class function SelectWaitTrainNo(strTrainNoList:TstringList):string;
  end;



implementation

{$R *.dfm}

{ TFrmSelWaitTrainNo }

procedure TFrmSelWaitTrainNo.btnCancelClick(Sender: TObject);
begin
  self.ModalResult := mrCancel;
end;

procedure TFrmSelWaitTrainNo.btnOKClick(Sender: TObject);
begin
  self.m_selTrainNo := cbbTrainNo.Text;
  self.ModalResult := mrOk;
end;

procedure TFrmSelWaitTrainNo.FormShow(Sender: TObject);
var
  i:Integer;
begin
  cbbTrainNo.Clear;
  for i := 0 to m_strTrainNoList.Count - 1 do
  begin
    cbbTrainNo.Items.Add(m_strTrainNoList.Strings[i]);
  end;
  cbbTrainNo.ItemIndex := 0;
    
end;

class function TFrmSelWaitTrainNo.SelectWaitTrainNo(
  strTrainNoList: TstringList): string;
var
  FrmSelWaitTrainNo: TFrmSelWaitTrainNo;
begin
  result := '';
  FrmSelWaitTrainNo:= TFrmSelWaitTrainNo.Create(nil);
  try
    FrmSelWaitTrainNo.m_strTrainNoList:=strTrainNoList;
    if FrmSelWaitTrainNo.ShowModal = mrOk then
    begin
      result := FrmSelWaitTrainNo.m_selTrainNo;
    end;
  finally
    FrmSelWaitTrainNo.Free;
  end;

  
end;

end.
