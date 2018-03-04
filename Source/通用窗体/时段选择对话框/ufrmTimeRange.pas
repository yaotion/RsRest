unit ufrmTimeRange;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, RzDTP, StdCtrls, ExtCtrls, RzPanel,uTFSystem;

type
  TfrmTuDingTimeRange = class(TForm)
    RzGroupBox1: TRzGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    dtBeginDatePicker: TRzDateTimePicker;
    dtBeginTimePicker: TRzDateTimePicker;
    dtEndDatePicker: TRzDateTimePicker;
    dtEndTimePicker: TRzDateTimePicker;
    Button1: TButton;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
function TuDingTimeRange(var dtBegin: TDateTime;var dtEnd: TDateTime): Boolean;
implementation
uses
  uGlobalDM;
function TuDingTimeRange(var dtBegin: TDateTime;var dtEnd: TDateTime): Boolean;
var
  frmTuDingTimeRange: TfrmTuDingTimeRange;
begin
  frmTuDingTimeRange := TfrmTuDingTimeRange.Create(nil);
  try
    frmTuDingTimeRange.dtBeginDatePicker.DateTime := dtBegin;
    frmTuDingTimeRange.dtBeginTimePicker.DateTime := dtBegin;

    frmTuDingTimeRange.dtEndDatePicker.DateTime := dtEnd;
    frmTuDingTimeRange.dtEndTimePicker.DateTime := dtEnd;
    

    Result := frmTuDingTimeRange.ShowModal = mrOk;

    if Result then
    begin
      dtBegin := AssembleDateTime(frmTuDingTimeRange.dtBeginDatePicker.DateTime,frmTuDingTimeRange.dtBeginTimePicker.DateTime);

      dtEnd := AssembleDateTime(frmTuDingTimeRange.dtEndDatePicker.DateTime,frmTuDingTimeRange.dtEndTimePicker.DateTime);
    end;
  finally
    frmTuDingTimeRange.Free;
  end;
end;
{$R *.dfm}

procedure TfrmTuDingTimeRange.Button1Click(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfrmTuDingTimeRange.Button2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
