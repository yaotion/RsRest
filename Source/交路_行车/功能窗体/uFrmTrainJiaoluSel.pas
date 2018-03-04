unit uFrmTrainJiaoluSel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, ExtCtrls, RzPanel,uTFSystem,uTrainJiaolu;

type

  TFrmTrainJiaoSel = class(TForm)
    chklst1: TCheckListBox;
    pnl1: TRzPanel;
    btnOK: TButton;
    btnCancel: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    //选中的行车交路
    m_SelJiaoLuAry:TRsTrainJiaoluArray;
    //所有的行车交路
    m_TotalTrainJiaoLuAry:TRsTrainJiaoluArray;

  private
    //填充所有交路
    procedure InitAllJiaolu();
    //勾选已选交路
    procedure CheckSelJiaoLu();
    //获取已选交路
    procedure GetSelTrainJiaolu(var list:TStringList);

  public
    class function SelTrainJiaoLu(totalTrainJiaolu,
        selTrainJiaolu:TRsTrainJiaoluArray;var selJiaoluGUIDList:TStringList):boolean;

  end;

implementation

{$R *.dfm}

{ TFrmTrainJiaoSel }

procedure TFrmTrainJiaoSel.btnCancelClick(Sender: TObject);
begin
  self.ModalResult := mrCancel;
end;

procedure TFrmTrainJiaoSel.btnOKClick(Sender: TObject);
begin
  self.ModalResult := mrOk;
end;

procedure TFrmTrainJiaoSel.CheckSelJiaoLu;
var
  i,j:Integer;
begin
  for I := 0 to Length(m_TotalTrainJiaoLuAry) - 1 do
  begin
    for j := 0 to Length(m_SelJiaoLuAry) - 1 do
    begin
      if m_TotalTrainJiaoLuAry[i].strTrainJiaoluGUID = m_SelJiaoLuAry[j].strTrainJiaoluGUID then
      begin
        chklst1.Checked[i]:= True;
      end;
    end;
  end;

end;

procedure TFrmTrainJiaoSel.FormShow(Sender: TObject);
begin
  InitAllJiaolu;
  CheckSelJiaoLu;
end;

procedure TFrmTrainJiaoSel.GetSelTrainJiaolu(var list:TStringList);
var
  i:Integer;
begin
  for i := 0 to Length(m_TotalTrainJiaoLuAry) - 1 do
  begin
    if chklst1.Checked[i] = True then
    begin
      list.Add(m_TotalTrainJiaoLuAry[i].strTrainJiaoluGUID);
    end;
  end;
end;

procedure TFrmTrainJiaoSel.InitAllJiaolu;
var
  i:Integer;
begin
  for i := 0 to Length(m_TotalTrainJiaoLuAry) - 1 do
  begin
    chklst1.Items.Add(m_TotalTrainJiaoLuAry[i].strTrainJiaoluName);
  end;
end;

class function TFrmTrainJiaoSel.SelTrainJiaoLu(totalTrainJiaolu,
        selTrainJiaolu:TRsTrainJiaoluArray;var selJiaoluGUIDList:TStringList):boolean;
var
  FrmTrainJiaoSel: TFrmTrainJiaoSel;
begin
  result:= False;
  FrmTrainJiaoSel:= TFrmTrainJiaoSel.Create(nil);
  try
    FrmTrainJiaoSel.m_TotalTrainJiaoLuAry :=totalTrainJiaolu;
    FrmTrainJiaoSel.m_SelJiaoLuAry:=selTrainJiaolu;
    if FrmTrainJiaoSel.ShowModal = mrOk then
    begin
      FrmTrainJiaoSel.GetSelTrainJiaolu(selJiaoluGUIDList);
      Result := True;
    end;
  finally
    FrmTrainJiaoSel.Free;
  end;
end;

end.
