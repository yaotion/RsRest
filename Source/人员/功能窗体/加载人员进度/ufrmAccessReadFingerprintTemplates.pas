unit ufrmAccessReadFingerprintTemplates;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, pngimage, RzPrgres, StdCtrls, RzPanel,uTFSystem;

type
  TfrmAccessReadFingerprintTemplates = class(TForm)
    RzPanel1: TRzPanel;
    Label1: TLabel;
    ProgressBar: TRzProgressBar;
    Image1: TImage;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
        { Private declarations }
    m_bForceUpdate : boolean;
    {����:ָ����������֪ͨ}
    procedure OnReadFingerprintTemplatesChangeEvent(nMax,nPosition:Integer);
    {����:ָ�������������}
    procedure OnReadFingerprintTemplatesComplete();
  public
    { Public declarations }
  end;

    {����:����ָ������}
  procedure ReadFingerprintTemplatesAccess(ForceUpdate : boolean);

var
  frmAccessReadFingerprintTemplates: TfrmAccessReadFingerprintTemplates;

implementation

uses
  uGlobalDM,utfPopBox;

{$R *.dfm}

procedure ReadFingerprintTemplatesAccess(ForceUpdate : boolean);
{����:����ָ������}
var
  frmReadFingerprintTemplates: TfrmAccessReadFingerprintTemplates;
begin
  frmReadFingerprintTemplates := TfrmAccessReadFingerprintTemplates.Create(nil);
  try
    frmReadFingerprintTemplates.m_bForceUpdate := ForceUpdate;
    frmReadFingerprintTemplates.ShowModal;
  finally
    frmReadFingerprintTemplates.Free;
  end;
end;


procedure TfrmAccessReadFingerprintTemplates.FormCreate(Sender: TObject);
begin
  m_bForceUpdate := false;
  GlobalDM.OnReadFingerprintTemplatesChangeEvent :=
      OnReadFingerprintTemplatesChangeEvent;
  GlobalDM.OnReadFingerprintTemplatesComplete :=
      OnReadFingerprintTemplatesComplete;
end;

procedure TfrmAccessReadFingerprintTemplates.FormDestroy(Sender: TObject);
begin
  ;
end;

procedure TfrmAccessReadFingerprintTemplates.FormShow(Sender: TObject);
begin
  ProgressBar.PartsComplete := 0;
  Timer1.Enabled := true;
end;

procedure TfrmAccessReadFingerprintTemplates.OnReadFingerprintTemplatesChangeEvent(
  nMax, nPosition: Integer);
begin
  ProgressBar.TotalParts := nMax;
  ProgressBar.PartsComplete := nPosition;
end;

procedure TfrmAccessReadFingerprintTemplates.OnReadFingerprintTemplatesComplete;
begin
  Close;
end;

procedure TfrmAccessReadFingerprintTemplates.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  try
    GlobalDM.ReadAccessFingerprintTemplate(m_bForceUpdate);
  except on e : exception do
    begin
        TtfPopBox.ShowBox('����ָ��ʧ�ܣ�' + e.Message);
        Close;
    end;
  end;
end;

end.
