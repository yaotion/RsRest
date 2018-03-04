unit uFrmEditCallPlan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, AdvDateTimePicker, RzButton, StdCtrls, RzLabel,
  uRoomCall,uGlobalDM,uTFSystem,DateUtils;

type
  TFrmEditCallPlan = class(TForm)
    lbl: TRzLabel;
    edtRoomNum: TEdit;
    lbl1: TRzLabel;
    lbl2: TRzLabel;
    lbl3: TRzLabel;
    btnOk: TRzButton;
    btnCancel: TRzButton;
    dtpStartTrainTime: TAdvDateTimePicker;
    dtpCallTime: TAdvDateTimePicker;
    edtTrainNo: TEdit;
    procedure FormShow(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    //叫班计划
    m_CallPlan:TCallRoomPlan;


  private
    {功能:初始化显示数据}
    procedure InitShowData();
    {功能:校验数据}
    function CheckData():Boolean;
    {功能:保存赋值}
    procedure SaveData();
  end;
  {功能:创建叫班计划}
  function CreateCallPlan(out CallPlan :TCallRoomPlan ):Boolean;
  {功能:修改叫班计划}
  function ModifyCallPlan(var CallPlan:TCallRoomPlan):Boolean;


implementation

uses
  utfPopBox ;

{$R *.dfm}
{功能:创建叫班计划}
function CreateCallPlan(out CallPlan :TCallRoomPlan ):Boolean;
var
  FrmEditCallPlan: TFrmEditCallPlan;
begin
  result := False;
  FrmEditCallPlan:=TFrmEditCallPlan.Create(nil);
  try
    if FrmEditCallPlan.ShowModal = mrOk then
    begin
      CallPlan := frmEditCallPlan.m_CallPlan;
      result := True;
    end;
  finally
    FrmEditCallPlan.Free;
  end;
end;
{功能:修改叫班计划}
function ModifyCallPlan(var CallPlan:TCallRoomPlan):Boolean;
var
  FrmEditCallPlan: TFrmEditCallPlan;
begin
  result := False;
  FrmEditCallPlan:=TFrmEditCallPlan.Create(nil);
  try
    FrmEditCallPlan.m_CallPlan := CallPlan;
    if FrmEditCallPlan.ShowModal = mrOk then
    begin

      CallPlan := frmEditCallPlan.m_CallPlan;
      result := True;
    end;
  finally
    FrmEditCallPlan.Free;
  end;
end;

procedure TFrmEditCallPlan.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrmEditCallPlan.btnOkClick(Sender: TObject);
begin
  if CheckData= False then Exit;
  SaveData();
  ModalResult := mrOk;
end;

function TFrmEditCallPlan.CheckData: Boolean;
begin
  result := False;
  if Trim(edtRoomNum.Text) = '' then
  begin
    edtRoomNum.SetFocus;
    TtfPopBox.ShowBox('房间号不能为空!');
    Exit;
  end;
  if Trim(edtTrainNo.Text ) ='' then
  begin
    edtTrainNo.SetFocus;
    TtfPopBox.ShowBox('车次不能为空!');
    Exit;
  end;
  {if DateUtils.HoursBetween(dtpStartTrainTime.DateTime,GlobalDM.GetNow) > 48 then
  begin
    dtpStartTrainTime.SetFocus;
    TtfPopBox.ShowBox('计划开车时间不在48小时内');
    Exit;
  end;
  }
  if dtpStartTrainTime.DateTime <= dtpCallTime.DateTime then
  begin
    TtfPopBox.ShowBox('叫班时间必须早于开车时间!');
    Exit;
  end;
  result := True;
end;

procedure TFrmEditCallPlan.FormShow(Sender: TObject);
begin
  InitShowData();
end;

procedure TFrmEditCallPlan.InitShowData;
var
  nowTime:TDateTime;
begin
  edtRoomNum.Text := m_CallPlan.strRoomNum;
  edtTrainNo.Text := m_CallPlan.strTrainNo;
  nowTime :=  GlobalDM.GetNow();
  if m_CallPlan.dtChuQinTime > 1 then
  begin
    dtpStartTrainTime.DateTime :=  m_CallPlan.dtChuQinTime ;
  end
  else
  begin
    dtpStartTrainTime.DateTime := nowTime;
  end;
  if m_CallPlan.dtStartCallTime > 1 then
  begin
    dtpCallTime.DateTime :=  m_CallPlan.dtStartCallTime ;
  end
  else
  begin
    dtpCallTime.DateTime :=  nowTime;
  end;
end;


procedure TFrmEditCallPlan.SaveData;
begin
  m_CallPlan.strRoomNum := Trim(edtRoomNum.Text);
  m_CallPlan.strTrainNo := Trim(edtTrainNo.Text);
  m_CallPlan.dtChuQinTime := dtpStartTrainTime.DateTime;
  m_CallPlan.dtStartCallTime := dtpCallTime.DateTime;
end;

end.
