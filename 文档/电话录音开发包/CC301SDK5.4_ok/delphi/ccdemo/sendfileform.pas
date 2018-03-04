unit sendfileform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  Tsendfiled = class(TForm)
    Label1: TLabel;
    destcc: TEdit;
    Label2: TLabel;
    transfile: TEdit;
    selectfile: TButton;
    idok: TButton;
    idcancel: TButton;
    selectlocalfile: TOpenDialog;
    procedure idcancelClick(Sender: TObject);
    procedure idokClick(Sender: TObject);
    procedure selectfileClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  sendfiled: Tsendfiled;

implementation

{$R *.dfm}

procedure Tsendfiled.idcancelClick(Sender: TObject);
begin
destcc.text := '';
close();
end;

procedure Tsendfiled.idokClick(Sender: TObject);
begin
close();
end;

procedure Tsendfiled.selectfileClick(Sender: TObject);
begin
        if selectlocalfile.Execute then
        begin
            transfile.text :=selectlocalfile.FileName;
        end;
end;

end.
