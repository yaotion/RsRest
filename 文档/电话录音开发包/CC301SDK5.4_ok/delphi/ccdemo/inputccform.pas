unit inputccform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  Tinputccd = class(TForm)
    Label1: TLabel;
    destcc: TEdit;
    idok: TButton;
    idcancel: TButton;
    procedure idcancelClick(Sender: TObject);
    procedure idokClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  inputccd: Tinputccd;

implementation

{$R *.dfm}

procedure Tinputccd.idcancelClick(Sender: TObject);
begin
destcc.Text := '';
close();
end;

procedure Tinputccd.idokClick(Sender: TObject);
begin
close();
end;

end.
