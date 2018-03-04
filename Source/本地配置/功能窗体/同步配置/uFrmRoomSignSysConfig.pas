unit uFrmRoomSignSysConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzTabs, ExtCtrls, RzPanel, StdCtrls;

type
  TFrmRoomSignsSysConfig = class(TForm)
    rzpgcntrlPageCtrlMain: TRzPageControl;
    tsConfig: TRzTabSheet;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    procedure CreateSubForms();
    procedure DestorySubForms();
  public
    { Public declarations }
    //ø™ º…Ë÷√
    class procedure ShowConfig();
  end;

var
  FrmRoomSignsSysConfig: TFrmRoomSignsSysConfig;

implementation

uses
  uFrmRoomSign_Config;

{$R *.dfm}

{ TFrmRoomSignConfig }

procedure TFrmRoomSignsSysConfig.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel ;
end;

procedure TFrmRoomSignsSysConfig.CreateSubForms;
begin

  FrmRoomSign_Config := TFrmRoomSign_Config.Create(nil);
  FrmRoomSign_Config.Parent := tsConfig ;
  FrmRoomSign_Config.Show ;
  rzpgcntrlPageCtrlMain.HideAllTabs;


  
end;

procedure TFrmRoomSignsSysConfig.DestorySubForms;
begin

  FrmRoomSign_Config.Free ;

end;

procedure TFrmRoomSignsSysConfig.FormCreate(Sender: TObject);
begin
  CreateSubForms;
end;

procedure TFrmRoomSignsSysConfig.FormDestroy(Sender: TObject);
begin
  DestorySubForms;
end;

class procedure TFrmRoomSignsSysConfig.ShowConfig;
var
  frm:TFrmRoomSignsSysConfig;
begin
  frm := TFrmRoomSignsSysConfig.Create(nil);
  try
    frm.ShowModal ;
  finally
    frm.Free ;
  end;
end;

end.
