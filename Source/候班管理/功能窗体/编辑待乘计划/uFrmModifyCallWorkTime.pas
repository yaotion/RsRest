unit uFrmModifyCallWorkTime;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, RzEdit, ComCtrls, RzDTP,uWaitWork,uGlobalDM,DateUtils,
  uWaitWorkMgr,uTFSystem;

type
  TFrmEditCallWorkTime = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    dtpDay: TRzDateTimePicker;
    edtSourceDateTime: TRzEdit;
    dtpTime: TRzDateTimePicker;
    btnOK: TButton;
    btnCancel: TButton;
    Label3: TLabel;
    edtWaitWorkTIme: TRzEdit;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  public
  private
    //���˼ƻ�
    m_plan:TWaitWorkPlan;
    //���˹���
    m_waitWorkMgr:TWaitworkMgr;
  private
    {����:��ȡ�µĽа�ʱ��}
    function GetNewCallTime():TDateTime;
    {����:У����������}
    function CheckData():Boolean;
  end;
  {����:�޸Ĵ��˼ƻ��а�ʱ��}
  function ModifyWaitWorkCallTime(plan:TWaitWorkPlan):Boolean;


implementation
uses
  ufrmQuestionBox;

{$R *.dfm}
function ModifyWaitWorkCallTime(plan:TWaitWorkPlan):Boolean;
var
  Frm: TFrmEditCallWorkTime;
begin
  result := False;
  frm:= TFrmEditCallWorkTime.Create(nil);
  try
    Frm.m_plan := plan;
    if Frm.ShowModal = mrOk then
    begin
      result := True;
    end;
  finally
    Frm.Free;
  end;
end;
procedure TFrmEditCallWorkTime.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrmEditCallWorkTime.btnOKClick(Sender: TObject);
var
  strMessage:string;
begin
  if CheckData = False  then Exit;
  m_plan.dtCallWorkTime := GetNewCallTime;
  m_plan.bNeedSyncCall := true;

  strMessage :=  Format('ȷ�϶Է���: [%s] �޸Ľа�ʱ��?',[m_plan.strRoomNum]) ;
  if not tfMessageBox(strMessage,MB_ICONQUESTION) then
    Exit;

  m_waitWorkMgr.ModifyCallTime(m_plan,GlobalDM.bEnableOnesCall);
  ModalResult := mrOk;
end;

function TFrmEditCallWorkTime.CheckData: Boolean;
begin
  result := False;
  {if GetNewCallTime <= m_plan.dtWaitWorkTime then
  begin
    TtfPopBox.ShowBox('�а�ʱ�������ں��ʱ��!');
    Exit;
  end;  }
  result := True;
end;

procedure TFrmEditCallWorkTime.FormCreate(Sender: TObject);
begin
  m_waitWorkMgr:=TWaitworkMgr.GetInstance(GlobalDM.LocalADOConnection);
end;

procedure TFrmEditCallWorkTime.FormShow(Sender: TObject);
begin
  edtWaitWorkTIme.Text := FormatDateTime('yyyy-mm-dd HH:mm:ss',m_plan.dtWaitWorkTime);
  edtSourceDateTime.Text := FormatDateTime('yyyy-mm-dd HH:mm:ss',m_plan.dtCallWorkTime);
  dtpDay.DateTime := GlobalDM.GetNow;
  dtpTime.DateTime := IncMinute(GlobalDM.GetNow,0);
end;

function TFrmEditCallWorkTime.GetNewCallTime: TDateTime;
begin
  dtpDay.Time:= dtpTime.Time;

  result := dtpDay.DateTime;
end;

end.
