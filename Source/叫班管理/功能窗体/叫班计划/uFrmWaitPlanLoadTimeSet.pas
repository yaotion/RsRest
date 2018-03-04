unit uFrmWaitPlanLoadTimeSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, RzDTP, StdCtrls, RzButton,uGlobalDM, pngimage, ExtCtrls,
  Buttons, PngCustomButton;

type
  TFrmWaitWorkPlanLoadTimeSet = class(TForm)
    Image1: TImage;
    dtEnd: TRzDateTimePicker;
    lbl2: TLabel;
    lbl1: TLabel;
    dtStart: TRzDateTimePicker;
    btnConfirm: TPngCustomButton;
    btnCancel: TPngCustomButton;
    procedure btnOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function ShowConfig():Boolean;
  end;



implementation

{$R *.dfm}

{ TFrmWaitWorkPlanLoadTimeSet }

procedure TFrmWaitWorkPlanLoadTimeSet.btnCancelClick(Sender: TObject);
begin
  self.ModalResult := mrCancel;
end;

procedure TFrmWaitWorkPlanLoadTimeSet.btnOkClick(Sender: TObject);
begin
  GlobalDM.LoadWaitWorkPlanStartTime := dtStart.Time;
  GlobalDM.LoadWaitWorkPlanEndTime := dtEnd.Time;
  self.ModalResult := mrOk;
end;

procedure TFrmWaitWorkPlanLoadTimeSet.FormShow(Sender: TObject);
begin
  dtStart.Time := GlobalDM.LoadWaitWorkPlanStartTime;
  dtEnd.Time := GlobalDM.LoadWaitWorkPlanEndTime;
end;

class function TFrmWaitWorkPlanLoadTimeSet.ShowConfig: Boolean;
var
  Frm: TFrmWaitWorkPlanLoadTimeSet;
begin
  Result:= False;
  Frm:= TFrmWaitWorkPlanLoadTimeSet.Create(nil);
  try
    if Frm.ShowModal = mrok then
    begin
      result := True;
    end;
  finally
    Frm.Free;
  end;
end;

end.
